global function ChatEffects
global function FindChatEffect
global function DEV_PrintAllChatEffects
global function SetRelayChallenge
global function ChatUtility_Init
global function CheckOnConnect

//CHAT EFFECTS
global struct Chat {

	table<string,string> effects = {
	
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

struct {

	array<string> mutedPlayers //uid

} file

void function ChatUtility_Init()
{
	AddClientCommandCallback( "FS_TT", SetRelayChallenge )
	AddClientCommandCallback( "say", ChatWatchdog )
	AddCallback_OnClientConnected( CheckOnConnect )
	
	#if TRACKER && HAS_TRACKER_DLL
		AddCallback_PlayerData( "muted", MuteFromPersistence )
	#endif
}

void function MuteFromPersistence( entity player, string setting )
{
	if( setting == "1" )
	{
		file.mutedPlayers.append( player.p.UID )
		ToggleMute( player, true )
		CheckAllMutes( player.p.handle, player.p.UID )
	}
}

void function CheckOnConnect( entity player )
{
	CheckAllMutes( player.p.handle, player.p.UID ) //may need rawget
}

void function CheckAllMutes( int ehandle, string uid )
{
	if( file.mutedPlayers.contains( uid ) )
	{
		foreach( s_player in GetPlayerArray() )
		{
			if( !IsValid( s_player ) ) continue		
			Remote_CallFunction_NonReplay( s_player, "FS_Silence", true, ehandle )	
		}
	}
}

void function UnmuteForAll( entity player )
{
	if( !IsValid( player ) ){ return }
	
	int eHandle = player.p.handle	
	
	ToggleMute( player, false )
	
	foreach ( s_player in GetPlayerArray() )
	{
		if( !IsValid( s_player ) ) continue 
		
		Remote_CallFunction_NonReplay( s_player, "FS_Silence", false, eHandle )
	}
}

table <string,string> function ChatEffects()
{
	return chat.effects
}

string function FindChatEffect( string key )
{
	if( key in chat.effects )
	{
		return chat.effects[key]
	}
	
	string query = key.tolower()
	
	foreach( effectKey, chatValue in chat.effects )
	{
		if ( effectKey.tolower() == query )
		{
			return chatValue
		}
	}
	
	return "Not found.";
}

void function DEV_PrintAllChatEffects()
{
	string print_effects = format( "\n\n --- Chat Effects --- \n\n" )
	
	foreach( key, value in chat.effects )
	{
		print_effects += format( "%s \n", key ) 
	}
	
	sqprint( print_effects )
}


bool function SetRelayChallenge( entity player, array<string> args )
{
	if ( !CheckRate( player ) )
	{
		if( IsValid( player ) )
		{
			if( player.p.bInRetry ){ return true }
			thread( void function() : ( player, args )
			{
				player.p.bInRetry = true
				EndSignal( player, "OnDestroy" )
				wait 0.5
				player.p.bInRetry = false
				SetRelayChallenge( player, args )
				return
			}())
		}
	}
	
	if( args.len() < 1 ){ return true }
	
	string challengeCode = args[0]
	
	if( !IsNumeric(challengeCode) ){ return true }
	
	if( challengeCode.len() > 8 ){ return true }
	
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

bool function ChatWatchdog( entity player, array<string> args )
{
	if( !IsValid( player ) ){ return true }	
	if( player.p.bTextmute && args.len() > 0 )
	{ 
		//printt("should be muted")
		//printarray( args )
		KickPlayerById( player.GetPlatformUID(), "Chat Error" ) 
	}
	return true
}