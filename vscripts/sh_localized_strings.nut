// Localized strings table //mkos

global function INIT_Flowstate_Localization_Strings
global function Flowstate_FetchToken

#if SERVER
	global function Flowstate_FetchTokenID
#endif

#if CLIENT 	
	global function FS_BuildLocalizedTokenWithVariableString
	global function FS_DisplayLocalizedToken
#endif

#if DEVELOPER 
	global function DEV_GenerateTable
	global function DEV_getTokenIdFromRef //deprecated use Flowstate_FetchTokenID
	global function DEV_printLocalizationTable
#endif

struct {

	table<int, string> FS_LocalizedStrings = {}
	
#if SERVER
	table<string, int> FS_LocalizedStringMap = {}
#endif

#if CLIENT
	string fs_variableString = ""
	string fs_variableSubString = ""
#endif

	array<string> allTokens = [
		"#FS_NULL",
		"#FS_1v1_Banner",
		"#FS_1V1_Tracker",
		"#FS_GameNotPlaying",
		"#FS_Scenarios_Banner",
		"#FS_Challenges_Disabled",
		"#FS_NotInFight",
		"#FS_CantChalSelf",
		"#FS_ChalSent",
		"#FS_InvalidPlayer",
		"#FS_OVERFLOW",
		"#FS_FAILED",
		"#FS_Usage",
		"#FS_Challenge_usage",
		"#FS_Challenges",
		"#FS_Challenge_usage_2",
		"#FS_NEW_REQUEST",
		"#FS_ChalRequest",
		"#FS_PlayerNotInChallenges",
		"#FS_RemovedChallenger",
		"#FS_ChallengersCleared",
		"#FS_ChalRevoked",
		"#FS_RevokedX",
		"#FS_RevokedFromPlayers",
		"#FS_NoChallengesToRemove",
		"#FS_PlayerQuit",
		"#FS_NotInChal",
		"#FS_SpawnCycDisabled",
		"#FS_SpawnCycEnabled",
		"#FS_SpawnSwapDisabled",
		"#FS_SpawnSwapEnabled",
		"#FS_DisabledLegends",
		"#FS_InvalidLegend",
		"#FS_PlayingAs",
		"#FS_OutgoingChal",
		"#FS_NoOutgoingChal",
		"#FS_UnknownCommand",
		"#FS_InChallenge",
		"#FS_InChallenge_SUBSTR",
		"#FS_PlayerInChal",
		"#FS_NoChal",
		"#FS_NoChalFromPlayer",
		"#FS_NoChalFromPlayer_SUBSTR",
		"#FS_ChalQuit",
		"#FS_ChalAccepted",
		"#FS_NoChalToEnd",
		"#FS_ChalEnded",
		"#FS_RESTCOOLDOWN",
		"#FS_MATCHING",
		"#FS_BASE_RestText",
		"#FS_SendingToRestAfter",
		"#FS_TryRestAgainIn",
		"#FS_RestGrace",
		"#FS_YouAreResting",
		"#FS_WaitingForPlayers",
		"#FS_MustBeInRest",
		"#FS_MustBeInRest_SUBSTR",
		"#FS_JumpToStopSpec",
		"#FS_IBMM_Any",
		"#FS_IBMM_SAME",
		"#FS_SettingNotAllowed",
		"#FS_ChalDisabled",
		"#FS_ChalEnabled",
		"#FS_StartInRestDisabled",
		"#FS_StartInRestEnabled",
		"#FS_InputBannerDisabled",
		"#FS_InputBannerEnabled",
		"#FS_OpponentDisconnect",
		"#FS_ChalStarted",
		"#FS_InputLocked",
		"#FS_CouldNotLock",
		"#FS_AnyInput",
		"#FS_INPUT_CHANGED",
		"#FS_INPUT_CHANGED_SUBSTR"
	]
	
} file


//########################################################
//							init						//
//########################################################


void function INIT_Flowstate_Localization_Strings()
{
	#if DEVELOPER
		printt("Initializing all localization tokens")
	#endif
	
	for ( int i = 0; i <= file.allTokens.len() - 1; i++ )
	{
		file.FS_LocalizedStrings[i] <- file.allTokens[i]
		
		#if SERVER
			file.FS_LocalizedStringMap[file.allTokens[i]] <- i
		#endif
	}
}


//########################################################
//					 UTILITY FUNCTIONS					//
//########################################################


string function Flowstate_FetchToken( int tokenID )
{
	if( tokenID in file.FS_LocalizedStrings )
	{
		return file.FS_LocalizedStrings[tokenID]
	}
	
	//possibly developer define out and return blank	
	return "Token not found"
}

#if SERVER

	int function Flowstate_FetchTokenID( string ref )
	{
		if ( ref in file.FS_LocalizedStringMap )
		{
			return file.FS_LocalizedStringMap[ref]
		}
		
		return 0
	}
	
#endif

//########################################################
//					 CLIENT FUNCTIONS					//
//########################################################

#if CLIENT

void function FS_BuildLocalizedTokenWithVariableString( int Type, ... )
{
	if ( Type == 0 )
	{
		for ( int i = 0; i < vargc; i++ )
		{
			file.fs_variableString += format( "%c", vargv[i] )
		}
	}
	else 
	{
		for ( int i = 0; i < vargc; i++ )
		{
			file.fs_variableSubString += format( "%c", vargv[i] )
		}
	}
}

int function countStringArgs( string str )
{
	array<string> count = split( str, "%s" )
	return ( count.len() - 1 )
}

void function FS_DisplayLocalizedToken( int token, int subtoken, int uiType, float duration )
{
	string S = file.fs_variableString
	string SubS = file.fs_variableSubString
	string localToken = Flowstate_FetchToken( token )
	string localSubToken = Flowstate_FetchToken( subtoken )

	string Msg = "";
	string SubMsg = "";

	string add_placeholder_to_msg = countStringArgs( localToken ) > 0 ? "" : "%s";
	string add_placeholder_to_submsg = countStringArgs( localSubToken ) > 0 ? "" : "%s";
	
	try 
	{
		Msg = format( ( Localize( localToken ) + add_placeholder_to_msg ) , S )
		SubMsg = format( ( Localize( localSubToken ) + add_placeholder_to_submsg ) , SubS )
		printt("Showing msg: ", Msg )
	}
	catch(e)
	{
		printt("Error " + e + " ;Invalid format qualifiers in message ID: ", token )
	}

	switch(uiType)
	{
		case 0: DisplayOldMessage( Msg, SubMsg, duration ); break
		case 1: Flowstate_AddCustomScoreEventMessage(  Msg, duration ); break
	}
	
	file.fs_variableString = ""
	file.fs_variableSubString = ""
}

void function DisplayOldMessage( string str1, string str2, float duration )
{
	entity player = GetLocalClientPlayer()
	AnnouncementData announcement = Announcement_Create( str1 )
	Announcement_SetSubText( announcement, str2 )
	Announcement_SetHideOnDeath( announcement, false )
	Announcement_SetDuration( announcement, duration )
	Announcement_SetPurge( announcement, true )
	// Announcement_SetSoundAlias( announcement, "" )
	
	string mode = GameRules_GetGameMode()
	
	switch(mode)
	{
		case "fs_dm":
		case "fs_prophunt":
		case "fs_duckhunt":
		case "fs_snd":
		Announcement_SetStyle(announcement, ANNOUNCEMENT_STYLE_CIRCLE_WARNING)
		Announcement_SetTitleColor( announcement, Vector(0,0,0) )		
		break;
		
		default: break;
	}
	
	string playlist = GetCurrentPlaylistName()
	
	switch(playlist)
	{
		case "fs_movementgym":
		case "fs_scenarios":
		case "fs_1v1":
		case "fs_survival_solos":
		case "fs_lgduels_1v1":
		case "fs_snd":
		
		Announcement_SetStyle(announcement, ANNOUNCEMENT_STYLE_SWEEP)
		Announcement_SetTitleColor( announcement, Vector(0,0,1) )
		
		if(duration == 8.420)
		{
			Announcement_SetDuration( announcement, 5 )
			Announcement_SetStyle(announcement, ANNOUNCEMENT_STYLE_CIRCLE_WARNING)
			Announcement_SetTitleColor( announcement, Vector(0,0,0) )
		}
		
		break;
		
		default: break;
	}
	
	AnnouncementFromClass( player, announcement )
}
#endif


//########################################################
//					DEV FUNCTIONS						//
//########################################################

#if DEVELOPER
void function DEV_GenerateTable()
{
	//ParseFSTokens("mods/Flowstate.Localization/resource/flowstate_english.txt")
	//Todo: logic to dump data
}

void function ParseFSTokens( string path )
{
/*
	if( !DevDoesFileExist() )
	{
		printt("file not found.")
	}
	
    string fileData = DevReadFile( path )
    string fpattern = "\"(FS_[^\"]+)\"";

    array<string> found = RegexpFindAll( fileData, fpattern);
	//file.allTokens.extend(found)
	
	string buildPrint = ""
	
	foreach( match in found )
	{
		buildPrint += format( "\"#" + match + "\", \n")
	}	
	
	printt( buildPrint )
	printt("FS_Tokens Count: ", found.len() )
*/
}

int function DEV_getTokenIdFromRef( string ref ) //deprecated
{
	foreach ( key, value in file.FS_LocalizedStrings )
	{
		if ( ref == value )
		{
			return key
		}
	}
	
	return -1
}

void function DEV_printLocalizationTable()
{
	foreach ( key, value in file.FS_LocalizedStrings )
	{
		printt( key, value )
	}
}
#endif
