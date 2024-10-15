																						//~mkos
global function ChatUtility_Init

global function Chat_GetAllEffects
global function Chat_FindEffect
global function Chat_CheckGlobalMute
global function Chat_GetMutedReason
global function Chat_FindMuteReasonInArgs
global function Chat_ToggleMuteForAll
global function Chat_InMutedList

#if DEVELOPER
	global function DEV_PrintAllChatEffects
#endif

//CHAT EFFECTS
global struct Chat 
{
	table<string,string> effects = 
	{
	
		["THUMBSUP"] = "󰉥",
		["SKULL"] = "󰆿",
		["PISTOL"] = "󰉅",
		["ROOK"] = "󰈭",
		["YELLOW_SKULL"] = "󰈫",
		["NO_WEP"] = "󰈝",
		["HEALTHKIT"] = "󰈘",
		["PHOENIX"] = "󰈖",
		["LOCKED"] = "󰈎",
		["EYE"] = "󰇊",
		["FRIEND"] = "󰆾",
		["LAG"] = "󰆼",
		["CONNECTING"] = "󰆺",
		["CELL"] = "󰈚",
		["BATTERY"] = "󰈙",
		["APEX"] = "󰅡",
		["FIVE"] = "󰆗",
		["CIRCLE"] = "󰆉",
		["BLUEPEX"] = "󰅠",
		["WRAITH_BANNER"] = "󰄒",
		["BIG_WHITE_CROWN"] = "󰄈",
		["WHITE_CROWN"] = "󰄇",
		["BLUE_CROWN"] = "󰄄",
		["TREE"] = "󰃻",
		["SUS"] = "󰃴",
		["RED_SQUARE"] = "󰃭"
	}
}

global Chat chat
const string YES = "1"
const array<string> REASON_ARG_ALIASES = [ "-r", "r", "-reason", "reason" ]

struct 
{
	table<string,int> mutedPlayers //uid -> unix unmute time
	array<string> ignoreUidList
	
	bool bGlobalMuteEnabled = true
	bool opt_in_spam_mute	= true
	float chatInterval 		= 60
	int timeoutAmount 		= 60
	int chatThreshhold 		= 15
	
} file

void function ChatUtility_Init()
{
	//Init options first
	file.chatInterval 			= GetCurrentPlaylistVarFloat( "chat_interval", 60 )
	file.chatThreshhold 		= GetCurrentPlaylistVarInt( "chat_threshhold", 15 )
	file.bGlobalMuteEnabled 	= GetCurrentPlaylistVarBool( "opt_in_global_mute", true )
	file.opt_in_spam_mute 		= GetCurrentPlaylistVarBool( "opt_in_spam_mute", true )
	
	//Callbacks
	AddClientCommandCallback( "FS_TT", SetRelayChallenge )
	AddClientCommandCallbackNew( "say", ChatWatchdog )
	AddCallback_OnClientConnected( CheckOnConnect )
	
	if( file.opt_in_spam_mute )
		AddCallback_OnClientConnected( Chat_SpamCheck )
	
	#if TRACKER && HAS_TRACKER_DLL
		AddCallback_PlayerData( "unmuteTime", SetUnmuteTime ) //must be before muted
		AddCallback_PlayerData( "muted", MuteFromPersistence )	
	#endif
	
	array<string> args = []
	string timeString = GetCurrentPlaylistVarString( "chat_timeout", "" )
	
	if( !empty( timeString ) )
	{
		args = split( timeString, " " )
		file.timeoutAmount = ParseTimeString( args )
		
		if( file.timeoutAmount == -1 )
			printw( "Timeout was set to -1. Was the timeout string correctly formatted in playlists?" )
	}
	
	// commands/args and their aliases
	Commands_Register( "-r", handleReason, REASON_ARG_ALIASES )
}

void function handleReason( string value ) 
{
	printw( "Reason:", value )
}

table<string,int> function GetMutedList()
{
	return file.mutedPlayers
}

bool function Chat_InMutedList( string uid )
{
	return ( uid in GetMutedList() )
}

void function MutedList_Update( string uid, int timestamp = -1 )
{
	if( Chat_InMutedList( uid ) && timestamp != -1 )
		file.mutedPlayers[ uid ] = timestamp 
	else 
		file.mutedPlayers[ uid ] <- timestamp
	
}

int function MutedList_GetUnmuteTime( string uid )
{
	if( Chat_InMutedList( uid ) )
		return GetMutedList()[ uid ]
		
	return 0
}

void function MutedList_Remove( string uid )
{
	if( Chat_InMutedList( uid ) )
		delete GetMutedList()[ uid ]
}

// purpose: prevent 
void function AddToChatMuteIgnoreList( string uid )
{
	if( !ChatMuteIgnoreList_Contains( uid ) )
		file.ignoreUidList.append( uid )
}

bool function ChatMuteIgnoreList_Contains( string uid )
{
	return ( file.ignoreUidList.contains( uid ) )
}

void function RemoveFromChatMuteIgnoreList( string uid )
{
	file.ignoreUidList.fastremovebyvalue( uid )
}
//

#if TRACKER && HAS_TRACKER_DLL
void function SetUnmuteTime( entity player, string potentialTimestamp )
{
	int timestamp = -1
	
	if( !IsNumeric( potentialTimestamp ) )
		return
	
	try
	{
		timestamp = potentialTimestamp.tointeger() //Todo(dw): server-based persistence vars need typed like global stats.
	}
	catch( e )
	{
		#if DEVELOPER 
			printw( "Warning, tried to set timestamp", e )
		#endif 
	}
	
	player.p.unmuteTime = timestamp
}
#endif

void function SetUnmuteTime_Raw( entity player, int timestamp )
{	
	player.p.unmuteTime = timestamp
}

void function Chat_SpamCheck( entity player )
{
	if( file.chatThreshhold <= 0 )
		return
	
	thread 
	(
		void function() : ( player )
		{
			wait file.chatInterval
			if( !IsValid( player ) )
				return 
			
			int msgCount = player.p.msg 			
			player.p.msg = maxint( 0, ( msgCount - file.chatThreshhold ) )
		}
	)()
}

int function ParseTimeString( array<string> args )
{		
	if( args.len() < 2 )
		return -1
		
	#if DEVELOPER
		string printout
		{
			string space
			for( int j = 0; j < args.len(); j++ )
			{
				space = j == 0 ? "" : " "
				printout += space + args[ j ]
			}
			
			printw( printout )
		}
	#endif
	
	int startIndex = 0
	if( args[ 0 ] == "mute" && args.len() >= 4 )
		startIndex = 2
	
	int addTime = 0
	for ( int i = startIndex; i < args.len(); i += 2 )
	{
		if ( i >= args.len() )
			return -1
			
		if( !IsNumeric( args[ i ] ) )
			continue 
		
		if( Commands_AllCommandAliasesContains( args[ i ] ) )
			continue
		
		int timeAmount = 0
		try
		{
			timeAmount = args[ i ].tointeger()
		} 
		catch( e )
		{
			#if DEVELOPER 
				printw( "Warning:", e )
			#endif 
		}
		
		if ( i + 1 >= args.len() )
			return -1
		
		string timeUnit = args[ i + 1 ].tolower()
		switch ( timeUnit ) 
		{
			case "year":
			case "years":
				addTime += ( timeAmount * 31557600 )
				break 
				
			case "month":
			case "months":
				addTime += ( timeAmount * 2629800 ) //avg
				break
				
			case "day":
			case "days":
				addTime += ( timeAmount * 86400 )
				break
				
			case "hour":
			case "hours":
				addTime += ( timeAmount * 3600 )
				break
				
			case "min":
			case "mins":
			case "minute":
			case "minutes":
				addTime += ( timeAmount * 60 )
				break
				
			case "sec":
			case "secs":
			case "second":
			case "seconds":
				addTime += ( timeAmount * 1 )
				break
			
			default:
				#if DEVELOPER 
					printw( "Invalid time unit used:", "\"" + timeUnit + "\""  )
				#endif
				return -1
		}
	}
	
	return addTime
}

void function MuteFromPersistence( entity player, string setting )
{
	if( !IsValid( player ) ) 
		return 
	
	string uid = player.p.UID
	
	if( setting == YES && !ChatMuteIgnoreList_Contains( uid ) )
	{
		if ( !Chat_InMutedList( uid ) )
			MutedList_Update( uid, GetEntityUnmuteTimestamp( player ) )
		
		CheckOnConnect( player )
	}
}

void function Chat_CheckGlobalMute( entity player )
{
	if( !file.bGlobalMuteEnabled )
		return 

	bool globalMute = GetPlayerStatBool( player.GetPlatformUID(), "globally_muted" )
	
	if( globalMute )
		MuteFromPersistence( player, YES )
}

void function CheckOnConnect( entity player )
{
	if( !IsValid( player ) )
		return
	
	string uid = player.p.UID
	if( Chat_InMutedList( uid ) )
	{
		int unmuteTime = GetEntityUnmuteTimestamp( player )	
		
		if( unmuteTime > 0 ) //I would prefer -1 to be the only infinite trigger
		{
			if( GetUnixTimestamp() > unmuteTime )
			{
				Chat_ToggleMuteForAll( player, false )
				return
			}
			else if( IsTimeInSameMatch( unmuteTime ) )
			{
				thread AutoUnmuteAtTime( player, unmuteTime, uid )
			}
		}
	
		Chat_ToggleMuteForAll( player )
	}
}

void function Chat_ToggleMuteForAll( entity player, bool toggle = true, bool cmdLine = false, array<string> cmdStringArgs = [], int timeoutAmount = -1, string uid = "" )
{
	int eHandle
	bool bSyncToPlayers = true
	
	if( IsValid( player ) )
	{
		eHandle = player.p.handle	
		uid = player.p.UID
	}
	else if( !empty( uid ) )
	{
		bSyncToPlayers = false //attempt list update only
	}
	else 
	{
		return
	}
	
	if ( toggle )
	{
		int timestamp = -1

		if( cmdLine )
		{
			if( timeoutAmount > -1 )
				timestamp = GetUnixTimestamp() + timeoutAmount
			else
				timestamp = GetUnixTimestamp() + ParseTimeString( cmdStringArgs )	
				
			string reason = Chat_FindMuteReasonInArgs( cmdStringArgs )
			Tracker_SavePlayerData( uid, "muted_reason", reason )
			Tracker_SavePlayerData( uid, "unmuteTime", timestamp )
			
			if( IsTimeInSameMatch( timestamp ) )
				thread AutoUnmuteAtTime( player, timestamp, uid )
				
			if( bSyncToPlayers )
				SetUnmuteTime_Raw( player, timestamp )
				
			RemoveFromChatMuteIgnoreList( uid )
		}
		else if( bSyncToPlayers )
		{
			timestamp = GetEntityUnmuteTimestamp( player )
		}
		else 
		{
			timestamp = MutedList_GetUnmuteTime( uid )
		}
			
		MutedList_Update( uid, timestamp )
	}
	else
	{
		if( cmdLine )
			AddToChatMuteIgnoreList( uid )
			
		MutedList_Remove( uid )
	}
	
	if( bSyncToPlayers )
	{
		ToggleMute( player, toggle )
		
		foreach ( s_player in GetPlayerArray() )
		{
			if( !IsValid( s_player ) || player == s_player )
				continue
				
			Remote_CallFunction_NonReplay( s_player, "FS_Silence", toggle, eHandle )
		}
	}
}

string function Chat_GetMutedReason( string uid = "", entity player = null )
{
	string reason
	
	if( !empty( uid ) )
		reason = Tracker_FetchPlayerData( uid, "muted_reason" )
	else if( IsValid( player ) )
		reason = Tracker_FetchPlayerData( player.p.UID, "muted_reason" )	
		#if DEVELOPER
	else 
			printw( "No valid uid or player entity provided." )
		#endif 
		
	return reason
}

void function AutoUnmuteAtTime( entity player, int unmuteTime, string uid )
{
	if( !IsValid( player ) )
		return
		
	EndSignal( player, "OnDestroy", "OnDisconnected" )
	int currentTime = GetUnixTimestamp() 
	
	if( unmuteTime == -1 )
		return 
	
	if( unmuteTime > currentTime )
		wait ( unmuteTime - currentTime )
	else 
	{
		#if DEVELOPER 
			printw( "Invalid unmute time? unmuteTime:", unmuteTime, "currentTime:", currentTime )
		#endif 
		
		return
	}
	
	if( Chat_InMutedList( uid ) && MutedList_GetUnmuteTime( uid ) != 0 && MutedList_GetUnmuteTime( uid ) < GetUnixTimestamp() )
	{
		#if DEVELOPER 
			printw( "New muted time", MutedList_GetUnmuteTime( uid ), " is less thhan current time", GetUnixTimestamp(), "for player", player )
		#endif
		
		return
	}
	
	//recheck from wait.
	if( IsValid( player ) )
	{
		Chat_ToggleMuteForAll( player, false ) //saves player data in process.
		LocalMsg( player, "#FS_AUTO_UNMUTED" )
	}
	else
	{
		Tracker_SavePlayerData( uid, "muted", false ) //player disconnected. Save it and ship anyway.
	}
	
	#if DEVELOPER 
		printw( "player was auto unmuted:", player )
	#endif 
}

bool function IsTimeInSameMatch( int timestamp )
{
	if( ( GetUnixTimestamp() + FlowState_RoundTime() ) > timestamp )
		return true 
		
	return false
}

int function GetEntityUnmuteTimestamp( entity player )
{
	int potentiallyUpdatedTime = -1
	
	if( Chat_InMutedList( player.p.UID ) )
		potentiallyUpdatedTime = MutedList_GetUnmuteTime( player.p.UID )
		
	return maxint( player.p.unmuteTime, potentiallyUpdatedTime )
}

string function Chat_FindMuteReasonInArgs( array<string> args ) 
{
	int i = 0

	while ( i < args.len() ) 
	{
        string tag = args[ i ]  

		if ( i + 1 < args.len() ) 
		{
            string value = args[ i + 1 ]
			if ( REASON_ARG_ALIASES.contains( tag ) )
			{
				CommandHandle handler = Commands_GetCommandHandler( REASON_ARG_ALIASES[ 0 ] ) //0 is base handler for aliases
				handler( value )
                return value
			}
				
            i += 2 //continue
		} 
		else 
		{
			#if DEVELOPER
				printw( "Error: Missing value for command", "\"" + tag + "\"" )
			#endif
			
			break
		}
	}
	
	return "{none}"
}

//////////////////
// Chat Effects //
//////////////////

table <string,string> function Chat_GetAllEffects()
{
	return chat.effects
}

string function Chat_FindEffect( string key )
{
	if( key in chat.effects )
		return chat.effects[ key ]
	
	string query = key.tolower()
	
	foreach( effectKey, chatValue in chat.effects )
	{
		if ( effectKey.tolower() == query )
			return chatValue
	}
	
	return "Not found.";
}

#if DEVELOPER
	void function DEV_PrintAllChatEffects()
	{
		string print_effects = format( "\n\n --- Chat Effects --- \n\n" )
		
		foreach( key, value in chat.effects )
			print_effects += format( "%s \n", key ) 
		
		sqprint( print_effects )
	}
#endif

bool function SetRelayChallenge( entity player, array<string> args )
{
	if( !IsValid( player ) )
		return false
	
	if( args.len() < 1 )
		return true
	
	string challengeCode = args[0]
	
	if( !IsNumeric( challengeCode, 10000000, 99999999 ) )
		return true
	
	if( challengeCode.len() != 8 )
		return true
	
	int compCode = -1
	
	try
	{
		compCode = challengeCode.tointeger()
	}
	catch(e){ return true }
	
	if( compCode != player.p.relayChallengeCode )
	{
		return true 
	}
	else
	{
		player.p.bRelayChallengeState = true
		player.Signal( "ChallengeReceived" )
	}
	
	return true
}

void function ChatWatchdog( entity player, array<string> args )
{
	if( !IsValid( player ) )
		return
		
	int wordCount = args.len()
	
	if( player.p.bTextmute && wordCount )
	{
		KickPlayerById( player.GetPlatformUID(), "Attempted to bypass chat mute" )
		return
	}
	
	if( !file.opt_in_spam_mute )
		return
	
	if( wordCount > 0 )
	{
		player.p.msg++
		
		if( TooManyMessages( player ) )
		{
			Chat_ToggleMuteForAll( player, true, true, [], file.timeoutAmount )
			LocalMsg( player, "#FS_SPAM_MUTE", "#FS_SPAM_MUTE_DESC", eMsgUI.DEFAULT, 5.0, "", string( file.timeoutAmount ) )
			
			#if DEVELOPER
				printw( "player textmuted for spam: ", player, " count:", player.p.msg, "penalty of:", file.timeoutAmount )
			#endif 
		}
	}
}

bool function TooManyMessages( entity player )
{
	return player.p.msg > file.chatThreshhold
}