// Localized strings table //mkos

global function INIT_Flowstate_Localization_Strings
global function Flowstate_FetchToken
global function ClientLocalizedTokenExists

#if SERVER
	global function Flowstate_FetchTokenID
	global function LocalMsg
	global function LocalVarMsg
	global function MessageLong
	global function LocalEventMsg //wrapper for LocalMsg ui type 1
	global function LocalizedTokenExists
#endif

#if CLIENT 	
	global function FS_ShowLocalizedMultiVarMessage
	global function FS_BuildLocalizedTokenWithVariableString
	global function FS_DisplayLocalizedToken
	global function FS_BuildLocalizedMultiVarString
#endif

#if DEVELOPER 
	global function DEV_GenerateTable
	global function DEV_getTokenIdFromRef //deprecated use Flowstate_FetchTokenID
	#if CLIENT || SERVER
		global function DEV_printLocalizationTable
	#endif
	#if CLIENT 
		global function DEV_printLocalizedTokenByID
	#endif 
#endif

	const ASSERT_LOCALIZATION = true 
	const DEBUG_VARMSG = false

struct {

	table<int, string> FS_LocalizedStrings = {}
	
#if SERVER
	table<string, int> FS_LocalizedStringMap = {}
#endif

#if CLIENT
	string fs_variableString = ""
	string fs_variableSubString = ""
	table<int, string> variableVars = {}
#endif

	//these must match the same order on client.
	//use playlist patch to add tokens between releases
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
		"#FS_INPUT_CHANGED_SUBSTR",
		"#FS_ERROR",
		"#FS_DisabledTDMWeps",
		"#FS_NotAllowedWaiting",
		"#FS_WepNotAllowed",
		"#FS_WepBlacklisted",
		"#FS_AbilityBlacklisted",
		"#FS_TgiveCooldown",
		"#FS_WEAPONSAVED",
		"#FS_FAILEDSAVE",
		"#FS_TEAMSBALANCED",
		"#FS_TEAMSBALANCED_SUBSTR",
		"#FS_HitsoundNumFail",
		"#FS_SUCCESS",
		"#FS_HitsoundChanged",
		"#FS_HandicapTitle",
		"#FS_HandicapSubstr",
		"#FS_HandicapOnSubstr",
		"#FS_HandicapOffSubstr",
		"#FS_IBMM_Time_Failed",
		"#FS_IBMM_Time_Changed",
		"#FS_LOCK1V1_ENABLED",
		"#FS_LOCK1V1_DISABLED",
		"#FS_START_IN_REST_TITLE",
		"#FS_START_IN_REST_SUBSTR",
		"#FS_START_IN_REST_ENABLED",
		"#FS_START_IN_REST_DISABLED",
		"#FS_INPUT_BANNER_DEPRECATED",
		"#FS_INPUT_BANNER_SUBSTR_DEP",
		"#FS_INPUT_BANNER_ENABLED_DEP",
		"#FS_INPUT_BANNER_DISABLED_DEP",
		"#FS_KILL_STREAK",
		"#FS_5_KILL_STREAK_SUBSTR",
		"#FS_EXTRA_KILL_STREAK_TITLE",
		"#FS_EXTRA_KILL_STREAK_SUBSTR",
		"#FS_15_KILL_STREAK_TITLE",
		"#FS_15_KILL_STREAK_SUBSTR",
		"#FS_20_KILL_STREAK_TITLE",
		"#FS_20_KILL_STREAK_SUBSTR",
		"#FS_30_KILL_STREAK_TITLE",
		"#FS_30_KILL_STREAK_SUBSTR",
		"#FS_PRED_SUMPREMACY_TITLE",
		"#FS_35_KILL_STREAK_SUBSTR",
		"#FS_50_KILL_STREAK_TITLE",
		"#FS_50_KILL_STREAK_SUBSTR",
		"#FS_25_PREDATORY_SUPREMACY",
		"#FS_EXTRA_SHIELD_TITLE",
		"#FS_EXTRA_SHIELD_SUBSTR",
		"#FS_Oddball",
		"#FS_STRING_VAR",
		"#FS_OddballReady",
		"#FS_Deathmatch",
		"#FS_ERROR_OCCURED",
		"#FS_ERROR_OCCURED2",
		"#FS_COOLDOWN",
		"#FS_COULD_NOT_SPECTATE",
		"#FS_NO_PLAYERS_TO_SPEC",
		"#FS_WAIT_TIME_CC",
		"#FS_AFK_KICK",
		"#FS_PUSHDOWN",
		"#FS_SPACE",
		"#FS_OVERFLOW_TEST",
		"#FS_CUSTOM_WEAPON_CHAL_ONLY",
		"#FS_CustomWepChalOnly",
		"#FS_IN_QUEUE",
		"#FS_MATCHED",
		"#FS_RESTING",
		"#FS_WEAPONS_RESET",
		"#FS_ALL_WEPS_SAVED",
		"#FS_MUTED",
		"#FS_UNMUTED",
		"#FS_ADMIN_RECORDER_ENDALL",
		"#FS_RECORDER_ENDALL",
		"#FS_MOVEMENT_RECORDER",
		"#FS_PLAYBACK_LIMIT",
		"#FS_PLAYING_ALL_ANIMS",
		"#FS_CANT_SWITCH_LEGEND",
		"#FS_RECORDINGANIM_CUSTOM",
		"#FS_NO_SLOTS",
		"#FS_MOVEMENT_SAVED",
		"#FS_ANIM_NOT_FOUND",
		"#FS_ANIM_REMOVED_SLOT",
		
	]
	
} file

//local script vars
const array<int> longUiTypes = [1]

//########################################################
//							init						//
//########################################################


void function INIT_Flowstate_Localization_Strings()
{
	#if DEVELOPER
		printt("Initializing all localization tokens")
	#endif
	
	int iTokensCount = file.allTokens.len()
	
	if( iTokensCount <= 0 )
		return
	
	for ( int i = 0; i <= iTokensCount - 1; i++ )
	{
		file.FS_LocalizedStrings[i] <- file.allTokens[i]
		
		#if SERVER
			file.FS_LocalizedStringMap[file.allTokens[i]] <- i
		#endif
	}
	
	file.allTokens.resize(0)
}


//########################################################
//					 UTILITY FUNCTIONS					//
//########################################################

//SHARED
string function Flowstate_FetchToken( int tokenID )
{
	if( tokenID in file.FS_LocalizedStrings )
	{
		return file.FS_LocalizedStrings[tokenID]
	}
	
	//possibly developer define out and return blank	
	return "Token not found"
}

string function StringReplaceLimited( string baseString, string searchString, string replaceString, int limit )
{
	Assert( searchString.len() > 0, "cannot use StringReplaceLimited with an empty searchString" )

	string newString = ""

	int searchIndex = 0
	int iReplaced = 0
	
	while( searchIndex < (baseString.len() - searchString.len() + 1) && iReplaced < limit )
	{
		var occurenceIndexOrNull = baseString.find_olduntyped( searchString, searchIndex )

		if ( occurenceIndexOrNull == null )
			break

		int occurenceIndex = expect int( occurenceIndexOrNull )

		newString += baseString.slice( searchIndex, occurenceIndex )
		newString += replaceString

		searchIndex = occurenceIndex + searchString.len()
		iReplaced++;
	}

	newString += baseString.slice( searchIndex )

	return newString
}

bool function ClientLocalizedTokenExists( int tokenRef )
{
	return ( tokenRef in file.FS_LocalizedStrings )
}
// /SHARED

#if SERVER

	bool function LocalizedTokenExists( string token )
	{
		return ( token in file.FS_LocalizedStringMap )
	}
	
	int function Flowstate_FetchTokenID( string ref )
	{
		if ( ref in file.FS_LocalizedStringMap )
		{
			return file.FS_LocalizedStringMap[ref]
		}
		
		return 0
	}
	
#endif

#if CLIENT
string function trim( string str ) 
{
    int start = 0;
    int end = str.len() - 1;
    string whitespace = " \t\n\r";

    while ( start <= end && whitespace.find( str.slice( start, start + 1 )) != -1 ) 
	{
        start++;
    }

    while (end >= start && whitespace.find( str.slice( end, end + 1 )) != -1 ) 
	{
        end--;
    }

    return str.slice(start, end + 1);
}
#endif

//########################################################
//					 SERVER FUNCTIONS					//
//########################################################

#if SERVER
void function LocalMsg( entity player, string ref, string subref = "", int uiType = 0, float duration = 5.0, string varString = "", string varSubstring = "", string sound = "", bool long = false )
{
	#if DEVELOPER && ASSERT_LOCALIZATION
		if( !empty(ref) )
		{
			mAssert( ref.find("#") != -1, "Reference missing # symbol  ref: [ " + ref + " ] in calling func: " + FUNC_NAME( 2 ) + "()" )
			mAssert( LocalizedTokenExists( ref ), "Localized Token Reference does not exist for [ " + ref + " ] \n in calling func: " + FUNC_NAME( 2 ) + "()" )
		}
	#endif 
	//original template by @Cafe
	
	if ( !IsValid( player ) ) return
	if ( !player.IsPlayer() ) return
	if ( !player.p.isConnected ) return
	
	int datalen = varString.len() + varSubstring.len()
	int varStringLen = varString.len()
	int varSubStringLen = varSubstring.len()
	
	string appendSubstring;
	string appendString;
	bool uiTypeValidLong;
	string sendMessage;
	
	if ( ( datalen ) >= 599 )
	{
		long = true
		uiTypeValidLong = longUiTypes.contains(uiType)
	}
	
	if( long )
	{
		if( varStringLen + varSubstring.len() > 1199 )
		{
			#if DEVELOPER
				sqerror("Variable strings were too long.")
			#endif
			return 	
		}
		
		if( varStringLen > 599 && !uiTypeValidLong )
		{
			#if DEVELOPER
				sqerror("Title for LocalMsg variable string was too long for uiType.")
			#endif
			return 			
		}
		
		if( uiTypeValidLong )
		{
			if( varStringLen > 1 )
			{	
				int slicePoint = 599 - varStringLen
				appendString = varString.slice( slicePoint, varStringLen )
				varString = varString.slice( 0, slicePoint )
			}	
		}
		else 
		{
			if( varSubStringLen > 1 )
			{	
				int slicePoint = 599 - varStringLen
				appendSubstring = varSubstring.slice( slicePoint, varSubStringLen )
				varSubstring = varSubstring.slice( 0, slicePoint )
			}
			
			
		}
	}	
	
	if ( datalen > 0 )
	{
		for ( int textType = 0 ; textType < 2 ; textType++ )
		{
			sendMessage = textType == 0 ? varString : varSubstring

			for ( int i = 0; i < sendMessage.len(); i++ )
			{
				Remote_CallFunction_NonReplay( player, "FS_BuildLocalizedTokenWithVariableString", textType, sendMessage[i] )
			}
		}
	}
	
	if ( long )
	{
		if( uiTypeValidLong )
		{
			thread MessageLong( player, ref, subref, uiType, duration, appendString, "", sound, false )
		}
		else 
		{
			thread MessageLong( player, ref, subref, uiType, duration, "", appendSubstring, sound, false )
		}
		
		return
	}
	
	int tokenID = Flowstate_FetchTokenID(ref)
	int subTokenID = 0
	
	if( subref != "" )
	{
		subTokenID = Flowstate_FetchTokenID(subref)
	}
	
	Remote_CallFunction_NonReplay( player, "FS_DisplayLocalizedToken", tokenID, subTokenID, uiType, duration )
	
	if ( sound != "" )
	{
		thread EmitSoundOnEntityOnlyToPlayer( player, player, sound )
	}
}

void function MessageLong( entity player, string ref, string subref = "", int uiType = 0, float duration = 5.0, string varString = "", string varSubstring = "", string sound = "", bool long = true )
{
	wait 0.5
	LocalMsg( player, ref, subref, uiType, duration, varString, varSubstring, sound, long )
}

void function LocalVarMsg( entity player, string ref, int uiType = 2, float duration = 5, ... )
{
	if ( !IsValid( player ) ) return
	if ( !player.IsPlayer() ) return
	if ( !player.p.isConnected ) return
	
	int tokenID = Flowstate_FetchTokenID( ref )
	
	int vargCount = expect int( vargc );
	
	for ( int i = 0; i <= vargCount - 1; i++ )
	{
		if ( !ValidateType( vargv[i] ) ) 
			return
		
		string send = "";

		if( typeof( vargv[i] ) != "string" )
		{
			send = string( vargv[i] )
		}
		else
		{
			send = expect string( vargv[i] );
		}

		for ( int k = 0; k <= send.len() - 1; k++)
		{
			Remote_CallFunction_NonReplay( player, "FS_BuildLocalizedMultiVarString", i, send[k] )
		}
	}
	
	Remote_CallFunction_NonReplay( player, "FS_ShowLocalizedMultiVarMessage", tokenID, uiType, duration )
	
}

bool function ValidateType( ... )
{
	if( vargc <= 0 ){ return false }
	
	string type = typeof( vargv[0] )
	
	switch( type )
	{	
		case "string":
		case "int":
		case "float":
		case "bool":
		
		return true
	}
	
	return false
}

void function LocalEventMsg( entity player, string ref, string varString = "", float duration = 5 )
{
	LocalMsg( player, ref, "", 1, duration, varString, "", "", false )
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
	int found = RegexpFindAll( str, "%s" ).len()
	// var pattern = MakeRegexp( "%s" )
	// int found = Regexp_Match( pattern, str ).len()
		#if DEVELOPER && DEBUG_VARMSG
			printt( "REGEX FOUND %s: ", found )
		#endif

	return found
}

void function FS_DisplayLocalizedToken( int token, int subtoken, int uiType, float duration )
{
	string S = file.fs_variableString
	string SubS = file.fs_variableSubString
	string localToken = Flowstate_FetchToken( token )
	string localSubToken = Flowstate_FetchToken( subtoken )

	string Msg = " ";
	string SubMsg = " ";

	string add_placeholder_to_msg = countStringArgs( Localize( localToken ) ) == 0 ? "%s" : "";
	string add_placeholder_to_submsg = countStringArgs( Localize( localSubToken ) ) == 0 ? "%s" : "";
	
	#if DEVELOPER && DEBUG_VARMSG
		printt("msg placeholder: ", add_placeholder_to_msg, " ; submsg placeholder: ", add_placeholder_to_submsg )
		printt("S: ", S, " SubS: ", SubS )
	#endif
	
	try 
	{
		Msg = format( ( Localize( localToken ) + add_placeholder_to_msg ) , " " + S )
	}
	catch(e)
	{
		printt("Error ", e ," ; Function: ", FUNC_NAME(), " ;Invalid format qualifiers in message ID: ", token )
		Msg = Localize( trim( localToken ) ) + " " + S
		
		#if DEVELOPER && DEBUG_VARMSG 
			printt("New msg:", Msg )
		#endif
	}
	
	try
	{
		SubMsg = format( ( Localize( localSubToken ) + add_placeholder_to_submsg ) , SubS )
	}
	catch(e2)
	{
		printt("Error ", e2 ," ; Function: ", FUNC_NAME(), " ;Invalid format qualifiers in message ID: ", subtoken )
	}
	
	#if DEVELOPER && DEBUG_VARMSG
		printt("msg: ", Msg, " ;SubMsg: ", SubMsg )
	#endif
	

	switch(uiType)
	{
		case 0: DisplayOldMessage( Msg, SubMsg, duration ); break
		case 1: Flowstate_AddCustomScoreEventMessage(  Msg, duration ); break
		case 2: DisplayOldMessage( Msg, SubMsg, duration, 2 ); break
		
		default:
			printt("Server tried to call ui that doesn't exist.")
		break
	}
	
	file.fs_variableString = ""
	file.fs_variableSubString = ""
}

void function DisplayOldMessage( string str1, string str2, float duration, int uiType = 0 )
{
	entity player = GetLocalClientPlayer()
	AnnouncementData announcement = Announcement_Create( str1 )
	Announcement_SetSubText( announcement, str2 )
	Announcement_SetHideOnDeath( announcement, false )
	Announcement_SetDuration( announcement, duration )
	Announcement_SetPurge( announcement, true )
	// Announcement_SetSoundAlias( announcement, "" )
	
	//string mode = GameRules_GetGameMode()
	int mode = Gamemode()
	
	if( uiType < 2 )
	{
		switch(mode)
		{
			case eGamemodes.fs_dm:
			case eGamemodes.fs_prophunt:
			case eGamemodes.fs_duckhunt:
			case eGamemodes.fs_snd:
			
				Announcement_SetStyle(announcement, ANNOUNCEMENT_STYLE_CIRCLE_WARNING)
				Announcement_SetTitleColor( announcement, Vector(0,0,0) )	
		
			break;
			
			default: break;
		}
	}
	
	
	if( uiType < 2 )
	{
		//string playlist = GetCurrentPlaylistName()
		int playlist = Playlist()
		
		switch(playlist)
		{
			case ePlaylists.fs_movementgym:
			case ePlaylists.fs_scenarios:
			case ePlaylists.fs_1v1:
			case ePlaylists.fs_survival_solos:
			case ePlaylists.fs_lgduels_1v1:
			case ePlaylists.fs_snd:
			
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
	}
	else 
	{
		switch( uiType)
		{
			case 2:
				Announcement_SetDuration( announcement, 5 )
				Announcement_SetStyle(announcement, ANNOUNCEMENT_STYLE_CIRCLE_WARNING)
				Announcement_SetTitleColor( announcement, Vector(0,0,0) )
				
			default: 
				break
		}
	}
	
	AnnouncementFromClass( player, announcement )
}

void function FS_BuildLocalizedMultiVarString( int varNum, ... )
{	
	for ( int i = 0; i < vargc; i++ )
	{ 
		if( !( varNum in file.variableVars ) )
		{
			file.variableVars[varNum] <- format( "%c", vargv[i] )
		} 
		else 
		{
			file.variableVars[varNum] += format( "%c", vargv[i] )
		} 
	} 
}


void function FS_ShowLocalizedMultiVarMessage( int token, int uiType, float duration )
{
	string localToken = Flowstate_FetchToken( token )
	string localTokenString = Localize( localToken )
	
	int varCount = file.variableVars.len()
	int tokenPlaceholdersCount = countStringArgs( localTokenString )
	
	if( varCount > 10 )
	{
		for( int k = varCount; k >= 11; k-- )
		{
			if( k in file.variableVars )
			{
				delete file.variableVars[k]
			}
		}
		
		Assert( file.variableVars.len() == 10, "Variable vars were removed, but do not equal max vars" )
	}

	if( tokenPlaceholdersCount > varCount )
	{
		int placeholdersToRemove = tokenPlaceholdersCount - varCount;	
		localTokenString = StringReplaceLimited( localTokenString, "%s", "", placeholdersToRemove )
	}
	else if( varCount > tokenPlaceholdersCount )
	{
		int placeholdersToAdd = varCount - tokenPlaceholdersCount;  
		
		for( int i = 0; i <= placeholdersToAdd - 1; i++ )
		{
			localTokenString += " %s";
		}
	}
	
	string Msg = "";	
	
	//find me a variadic method, ty. 
	try 
	{
		switch( varCount )
		{
			case 0: break;
			case 1: Msg = format( localTokenString, file.variableVars[0] ); break;
			case 2: Msg = format( localTokenString, file.variableVars[0], file.variableVars[1] ); break;
			case 3: Msg = format( localTokenString, file.variableVars[0], file.variableVars[1], file.variableVars[2] ); break;
			case 4: Msg = format( localTokenString, file.variableVars[0], file.variableVars[1], file.variableVars[2], file.variableVars[3] ); break;
			case 5: Msg = format( localTokenString, file.variableVars[0], file.variableVars[1], file.variableVars[2], file.variableVars[3], file.variableVars[4] ); break;
			case 6: Msg = format( localTokenString, file.variableVars[0], file.variableVars[1], file.variableVars[2], file.variableVars[3], file.variableVars[4], file.variableVars[5] ); break;
			case 7: Msg = format( localTokenString, file.variableVars[0], file.variableVars[1], file.variableVars[2], file.variableVars[3], file.variableVars[4], file.variableVars[5], file.variableVars[6] ); break;
			case 8: Msg = format( localTokenString, file.variableVars[0], file.variableVars[1], file.variableVars[2], file.variableVars[3], file.variableVars[4], file.variableVars[5], file.variableVars[6], file.variableVars[7] ); break;
			case 9: Msg = format( localTokenString, file.variableVars[0], file.variableVars[1], file.variableVars[2], file.variableVars[3], file.variableVars[4], file.variableVars[5], file.variableVars[6], file.variableVars[7], file.variableVars[8] ); break;
			case 10: Msg = format( localTokenString, file.variableVars[0], file.variableVars[1], file.variableVars[2], file.variableVars[3], file.variableVars[4], file.variableVars[5], file.variableVars[6], file.variableVars[7], file.variableVars[8], file.variableVars[9] ); break;
			default: break
		}
	} 
	catch (e)
	{
		printt("Error " + e + " ;Invalid format qualifiers in message ID: ", token )
	}
	
	#if DEVELOPER && DEBUG_VARMSG
		int count = 0;
		foreach( vVar in file.variableVars )
		{
			count++;
			printt( "var: ", count, vVar )
		}
		
		printt("Message: ", Msg )
		printt("uiType: ", uiType )
		printt("Var count was: " + varCount + ", place holder count was: ", tokenPlaceholdersCount )
	#endif 
	
	switch( uiType )
	{
		case 0: DisplayOldMessage( Msg, " ", duration ); break
		case 1: DisplayOldMessage( " ", Msg, duration ); break
		case 2: Flowstate_AddCustomScoreEventMessage(  Msg, duration ); break
		case 3: DisplayOldMessage( Msg, " ", duration, 2 ); break //type 2 big text
		case 4: DisplayOldMessage(" ", Msg, duration, 2 ); break //type 2 big text, subtext slot
		default:
			printt("Server tried to call ui that doesn't exist.")
			break
	}
	
	file.variableVars.clear()
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
	if( !DevDoesFileExist( path ) )
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

#if CLIENT || SERVER
void function DEV_printLocalizationTable()
{
	
	#if CLIENT 
		string kvFormat = "";
	#endif 
	
	foreach ( key, value in file.FS_LocalizedStrings )
	{		
#endif
		#if CLIENT 
			string vFormat = StringReplaceLimited( Localize(value), "\n", "\\n", 100 )
			string kFormat = StringReplaceLimited( value, "#", "", 1 )
			int kOffset = 30 - kFormat.len()
			kvFormat += "\"" + kFormat + "\"" + TableIndent( kOffset ) + "\"" + vFormat + "\"\n";				
		#endif 
			
		#if SERVER 
			printt( key, value )
		#endif 
#if CLIENT || SERVER
	}
	
	#if CLIENT 
		printt( "\n\n --- LOCALIZATION TOKENS --- \n\n" + kvFormat + "\n" )
		printt( "Token count:", file.FS_LocalizedStrings.len(), "\n\n" )
	#endif
}
#endif 

	#if CLIENT 
		void function DEV_printLocalizedTokenByID( int id )
		{
			printt( Localize( Flowstate_FetchToken( id ) ) )
		}
	#endif
#endif


/////////////////////////////////////////
// reload command: reload_localization //