// Localized strings table //mkos

global function INIT_Flowstate_Localization_Strings
global function Flowstate_FetchToken
global function ClientLocalizedTokenExists
global function StringReplaceLimited

#if SERVER
	global function Flowstate_FetchTokenID
	global function LocalMsg
	global function LocalVarMsg
	global function MessageLong
	global function LocalEventMsgDelayed
	global function LocalEventMsg //wrapper for LocalMsg ui type 1
	global function IBMM_Notify
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
	global function DEV_Print_eMsgUI
	#if CLIENT || SERVER
		global function DEV_printLocalizationTable
	#endif
	#if CLIENT 
		global function DEV_printLocalizedTokenByID
	#endif 
#endif

	const ASSERT_LOCALIZATION = true 
	const DEBUG_VARMSG = false

global enum eMsgUI
{
	DEFAULT, 			//0
	EVENT, 				//1
	CIRCLE_WARNING, 	//2
	BIG, 				//3
	QUICK, 				//4
	SWEEP, 				//5
	RESULTS, 			//6
	OBJECTIVE, 			//7
	ELITE, 				//8
	WAVE, 				//9
	VAR_TITLE_SLOT, 	//10
	VAR_SUBTEXT_SLOT, 	//11
	VAR_EVENT, 			//12
	VAR_MOTD, 			//13
	IBMM, 				//14
}

struct 
{
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
		"#FS_WELCOME",
		"#FS_INPUT_VS",
		"#FS_CONTROLLER",
		"#FS_MKB",
		"#FS_Scenarios_Tip",
		"#FS_Scenarios_30Remaining",
		"#FS_OVER_BUDGET",
		"#FS_PLAYING_ANIM",
		"#FS_REMOVING_ALL_ANIMS"
		
	]
	
} file

//local script vars
const array<int> longUiTypes = 
[
	eMsgUI.EVENT,
	eMsgUI.QUICK,
	eMsgUI.VAR_MOTD
]

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
	
	#if DEVELOPER && ASSERT_LOCALIZATION
		Warning("ASSERTS ENABLED for script: " + FILE_NAME() )
	#endif
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
	#if ASSERT_LOCALIZATION
		mAssert( searchString.len() > 0, "cannot use StringReplaceLimited with an empty searchString" )
	#endif 
	
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
			mAssert( ref.find("#") != -1, "Reference missing # symbol  ref: [ " + ref + " ] in calling func: " + FUNC_NAME( 3 ) + "()" )
			mAssert( LocalizedTokenExists( ref ), "Localized Token Reference does not exist for [ " + ref + " ] \n in calling func: " + FUNC_NAME( 3 ) + "()" )
		}
	#endif 
	//original template by @Cafe ( Message() function )
	
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
		
		if( uiTypeValidLong && varStringLen >= 599 )
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
			if( varSubStringLen > 1 && varSubStringLen >= 599 )
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
			MessageLong( player, ref, subref, uiType, duration, appendString, "", sound, false )
		}
		else 
		{
			MessageLong( player, ref, subref, uiType, duration, "", appendSubstring, sound, false )
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
	thread( void function() : ( player, ref, subref, uiType, duration, varString, varSubstring, sound, long )
	{
		wait 0.5 //HACKFIX: avoid code rock
		LocalMsg( player, ref, subref, uiType, duration, varString, varSubstring, sound, long )
	})()
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
	LocalMsg( player, ref, "", eMsgUI.EVENT, duration, varString, "", "", false )
}

void function LocalEventMsgDelayed( float eventdelay, entity player, string ref, string varString = "", float duration = 5 )
{
	thread( void function() : ( eventdelay, player, ref, varString, duration )
			{
				wait eventdelay
				LocalEventMsg( player, ref, varString, duration )
			})()
}

void function IBMM_Notify( entity player, string ibmmLockTypeToken, int enemyPlayerInputType, string enemyName, float duration = 5.0 )
{
	string inputTypeToken = "";
	
	switch( enemyPlayerInputType )
	{
		case 0: inputTypeToken = "#FS_MKB"; break;
		case 1: inputTypeToken = "#FS_CONTROLLER"; break;
	}
	
	LocalMsg( player, ibmmLockTypeToken, inputTypeToken, eMsgUI.IBMM, duration, "", enemyName, "", false )
}
#endif //SERVER

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
		printt( "REGEX FOUND %s count:", found )
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
		printt("msg: ", StringReplaceLimited( Msg, "\n", "\\n", 999 ), " ;SubMsg: ", StringReplaceLimited( SubMsg, "\n", "\\n", 999 ) )
	#endif
	

	switch(uiType)
	{
		case eMsgUI.DEFAULT: DisplayMessage( Msg, SubMsg, duration ); break
		case eMsgUI.EVENT: Flowstate_AddCustomScoreEventMessage(  Msg, duration ); break
		// > 2 is handled by enum: eMsgUI and DisplayMessage()
		
		default:
			DisplayMessage( Msg, SubMsg, duration, uiType ); break
	}
	
	file.fs_variableString = ""
	file.fs_variableSubString = ""
}

void function DisplayMessage( string str1, string str2, float duration, int uiType = 0 )
{
	entity player = GetLocalClientPlayer()
	AnnouncementData announcement = Announcement_Create( str1 )
	Announcement_SetSubText( announcement, str2 )
	Announcement_SetHideOnDeath( announcement, false )
	Announcement_SetDuration( announcement, duration )
	Announcement_SetPurge( announcement, true )
	//Announcement_SetSoundAlias( announcement, "" )
	//Announcement_SetLeftText( announcement, ["test","test","test"] )
	//Announcement_SetRightText( announcement, ["test","test","test"] )
	
	//set default 
	Announcement_SetStyle(announcement, ANNOUNCEMENT_STYLE_CIRCLE_WARNING)

	int mode = Gamemode()
	
	if( uiType < 2 ) //old Message() style
	{
		int playlist = Playlist()
		
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
		int iCustomUI = ANNOUNCEMENT_STYLE_CIRCLE_WARNING
		
		switch( uiType )
		{
			case eMsgUI.CIRCLE_WARNING: break;
			case eMsgUI.BIG: iCustomUI = ANNOUNCEMENT_STYLE_BIG; break;
			case eMsgUI.QUICK: iCustomUI = ANNOUNCEMENT_STYLE_QUICK; break;
			case eMsgUI.SWEEP: iCustomUI = ANNOUNCEMENT_STYLE_SWEEP; break;
			case eMsgUI.RESULTS: iCustomUI = ANNOUNCEMENT_STYLE_RESULTS; break;
			case eMsgUI.OBJECTIVE: iCustomUI = ANNOUNCEMENT_STYLE_OBJECTIVE; break;
			case eMsgUI.ELITE: 
				iCustomUI = ANNOUNCEMENT_STYLE_ELITE; 
				//Announcement_SetOptionalTextArgsArray( announcement, [ player.GetPlayerNetInt("SeasonScore").tostring() ] )
				break;	
			case eMsgUI.WAVE:	iCustomUI = ANNOUNCEMENT_STYLE_WAVE; break;
			case eMsgUI.VAR_MOTD:
				RunUIScript( "SetMotdText", str1 + str2 )
				return
			
			case eMsgUI.IBMM:
				thread FS_IBMM_Msg( str1, str2, duration )
				return
				
			default:
				#if DEVELOPER
					Warning( format( "Server tried to call ui that doesn't exist: uiType: %d, function: %s()", uiType, FUNC_NAME()  ) )
				#endif
				break
		}
		
		#if DEVELOPER && DEBUG_VARMSG
			printt("\n\n --- LocalMsg() ---\n", "str1:", StringReplaceLimited( str1, "\n", "\\n", 999 ), "\n str2:", StringReplaceLimited( str2, "\n", "\\n", 999 ), "\n duration:", duration, "\n uiType:", uiType, "\n iCustomUI:", iCustomUI )
		#endif 
		
		Announcement_SetStyle(announcement, iCustomUI )
		Announcement_SetDuration( announcement, duration )
		Announcement_SetTitleColor( announcement, Vector(0,0,0) )
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
		
		#if DEVELOPER && ASSERT_LOCALIZATION
			mAssert( file.variableVars.len() == 10, "Variable vars were removed, but do not equal max vars" )
		#endif
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
		Warning( format("Error " + e + " ;Invalid format qualifiers in message ID: %d , Text: %s", token, Localize( Flowstate_FetchToken( token ) ) ) )
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
		case eMsgUI.VAR_TITLE_SLOT: DisplayMessage( Msg, " ", duration ); break;
		case eMsgUI.VAR_SUBTEXT_SLOT: DisplayMessage( " ", Msg, duration ); break;
		case eMsgUI.VAR_EVENT: Flowstate_AddCustomScoreEventMessage(  Msg, duration ); break;

		default:
			#if DEVELOPER
				Warning( format( "Server tried to call ui that doesn't exist: uiType: %d, function: %s()", uiType, FUNC_NAME()  ) )
			#endif
			break
	}
	
	file.variableVars.clear()
}
#endif //CLIENT


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
	#endif //CLIENT
	
	foreach ( key, value in file.FS_LocalizedStrings )
	{		
#endif
		#if CLIENT 
			string vFormat = StringReplaceLimited( Localize(value), "\n", "\\n", 100 )
			string kFormat = StringReplaceLimited( value, "#", "", 1 )
			int kOffset = 30 - kFormat.len()
			kvFormat += "\"" + kFormat + "\"" + TableIndent( kOffset ) + "\"" + vFormat + "\"\n";				
		#endif //CLIENT
			
		#if SERVER 
			printt( key, value )
		#endif 
#if CLIENT || SERVER
	}
	
	#if CLIENT 
		printt( "\n\n --- LOCALIZATION TOKENS --- \n\n" + kvFormat + "\n" )
		printt( "Token count:", file.FS_LocalizedStrings.len(), "\n\n" )
	#endif //CLIENT
}
#endif //CLIENT || SERVER

	#if CLIENT 
		void function DEV_printLocalizedTokenByID( int id )
		{
			printt( Localize( Flowstate_FetchToken( id ) ) )
		}
	#endif //CLIENT
	
	void function DEV_Print_eMsgUI()
	{	
		string tableText = "\n\nglobal enum eMsgUI\n{\n"
		
		foreach( enumName, index in eMsgUI )
		{
			int offset = 25 - enumName.len()
			tableText += TableIndent( 5 ) + enumName + TableIndent( offset ) + " = " + string( index ) + "\n"
		}
		
		tableText += "}\n\n"
		printt( tableText )
	}
#endif //DEVELOPER


/////////////////////////////////////////
// reload command: reload_localization //