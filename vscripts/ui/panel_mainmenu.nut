
global function InitMainMenuPanel
global function StartSearchForPartyServer
global function StopSearchForPartyServer
global function IsSearchingForPartyServer
global function SetLaunchState
global function PrelaunchValidateAndLaunch


global function UICodeCallback_GetOnPartyServer

#if DURANGO_PROG
global function UICodeCallback_OnStartedUserSignIn
global function UICodeCallback_OnFailedUserSignIn
global function UICodeCallback_OnCompletedUserSignIn
global function UICodeCallback_OnUserSignOut
#endif

const bool SPINNER_DEBUG_INFO = PC_PROG

// r5r
global function LaunchR5RLobby
global bool isLeavingMatch = false

struct
{
	var                menu
	var                panel
	var                status
	var                launchButton
	void functionref() launchButtonActivateFunc = null
	var                statusDetails
	bool               statusDetailsVisiblity = false
	//bool               autoConnect = true
	bool               working = false
	bool               searching = false
	bool               isNucleusProcessActive = false
	var				   serverSearchMessage
	var				   serverSearchError

	#if DURANGO_PROG
		bool forceProfileSelect = false
	#endif // DURANGO_PROG

	float startTime = 0
} file

#if SPINNER_DEBUG_INFO
void function SetSpinnerDebugInfo( string message )
{
	if ( GetConVarBool( "spinner_debug_info" ) )
	{
		Assert( file.working )
		SetLaunchState( eLaunchState.WORKING, message )
	}
}
#endif

void function InitMainMenuPanel( var panel )
{
	RegisterSignal( "EndPrelaunchValidation" )
	RegisterSignal( "EndSearchForPartyServerTimeout" )
	RegisterSignal( "SetLaunchState" )
	RegisterSignal( "MainMenu_Think" )

	file.panel = GetPanel( "MainMenuPanel" )
	file.menu = GetParentMenu( file.panel )

	AddPanelEventHandler( file.panel, eUIEvent.PANEL_SHOW, OnMainMenuPanel_Show )
	AddPanelEventHandler( file.panel, eUIEvent.PANEL_HIDE, OnMainMenuPanel_Hide )

	file.launchButton = Hud_GetChild( panel, "LaunchButton" )
	Hud_AddEventHandler( file.launchButton, UIE_CLICK, LaunchButton_OnActivate )

	file.status = Hud_GetRui( Hud_GetChild( panel, "Status" ) )
	file.statusDetails = Hud_GetRui( Hud_GetChild( file.panel, "StatusDetails" ) )
	file.serverSearchMessage = Hud_GetChild( file.panel, "ServerSearchMessage" )
	file.serverSearchError = Hud_GetChild( file.panel, "ServerSearchError" )

	//file.autoConnect = GetConVarInt( "ui_lobby_noautostart" ) == 0 // TEMP, need code to add convar which defaults to 1

	#if PC_PROG
		AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_EXIT_TO_DESKTOP", "#B_BUTTON_EXIT_TO_DESKTOP", null, IsExitToDesktopFooterValid )
	// AddPanelFooterOption( panel, LEFT, KEY_TAB, false, "", "#DATACENTER_DOWNLOADING", OpenDataCenterDialog, IsDataCenterFooterVisible, UpdateDataCenterFooter )
	#endif // PC_PROG
	// AddPanelFooterOption( panel, LEFT, BUTTON_STICK_RIGHT, false, "#DATACENTER_DOWNLOADING", "", OpenDataCenterDialog, IsDataCenterFooterVisible, UpdateDataCenterFooter )
	AddPanelFooterOption( panel, LEFT, BUTTON_START, true, "#START_BUTTON_ACCESSIBLITY", "#BUTTON_ACCESSIBLITY", Accessibility_OnActivate, IsAccessibilityFooterValid )

	#if DURANGO_PROG
		AddPanelFooterOption( panel, LEFT, BUTTON_Y, true, "#Y_BUTTON_SWITCH_PROFILE", "", SwitchProfile_OnActivate, IsSwitchProfileFooterValid )
	#endif

	#if CONSOLE_PROG
		AddMenuVarChangeHandler( "CONSOLE_isSignedIn", UpdateFooterOptions )
		AddMenuVarChangeHandler( "CONSOLE_isSignedIn", UpdateSignedInState )
	#endif // CONSOLE_PROG
}


#if PC_PROG
bool function IsExitToDesktopFooterValid()
{
	return !IsWorking() && !IsSearchingForPartyServer()
}
#endif // PC_PROG


bool function IsAccessibilityFooterValid()
{
	if ( !IsAccessibilityAvailable() )
		return false

	#if DURANGO_PROG
		return Console_IsSignedIn() && !IsWorking() && !IsSearchingForPartyServer()
	#else
		return !IsWorking() && !IsSearchingForPartyServer()
	#endif
}

bool function IsDataCenterFooterVisible()
{
	return !IsWorking() && !IsSearchingForPartyServer()
}


bool function IsDataCenterFooterClickable()
{
#if DEVELOPER
	bool hideDurationElapsed = true
#else //
	bool hideDurationElapsed = Time() - file.startTime > 10.0
#endif //

	#if DURANGO_PROG
		return Console_IsSignedIn() && !IsWorking() && !IsSearchingForPartyServer() && hideDurationElapsed
	#else
		return !IsWorking() && !IsSearchingForPartyServer() && hideDurationElapsed
	#endif
}

void function UpdateDataCenterFooter( InputDef footerData )
{
	string label = "#DATACENTER_DOWNLOADING"
	if ( !IsDatacenterMatchmakingOk() )
	{
		if ( IsSendingDatacenterPings() )
			label = Localize( "#DATACENTER_CALCULATING" )
		else
			label = Localize( label, GetDatacenterDownloadStatusCode() )
	}
	else
	{
		label = Localize( "#DATACENTER_INFO", GetDatacenterName(), GetDatacenterMinPing(), GetDatacenterPing(), GetDatacenterPacketLoss(), GetDatacenterSelectedReasonSymbol() )
		if ( IsDataCenterFooterClickable() )
			footerData.clickable = true
	}

	var elem = footerData.vguiElem
	Hud_SetText( elem, label )
	Hud_Show( elem )
}

void function OnMainMenuPanel_Show( var panel )
{
	if( isLeavingMatch )
	{
		LaunchR5RLobby()
		return
	}
	
	file.startTime = Time()

	AccessibilityHintReset()
	EnterLobbySurveyReset()

	thread MainMenu_Think()

	thread PrelaunchValidation()

	ExecCurrentGamepadButtonConfig()
	ExecCurrentGamepadStickConfig()
}

void function MainMenu_Think()
{
	Signal( uiGlobal.signalDummy, "MainMenu_Think" )
	EndSignal( uiGlobal.signalDummy, "MainMenu_Think" )

	while ( true )
	{
		UpdateFooterOptions()

		WaitFrame()
	}
}


void function PrelaunchValidateAndLaunch()
{
	thread PrelaunchValidation( true )
}


void function PrelaunchValidation( bool autoContinue = false )
{
	EndSignal( uiGlobal.signalDummy, "EndPrelaunchValidation" )

	SetLaunchState( eLaunchState.WORKING )

	if( !autoContinue )
		wait 1.0

	if ( autoContinue )
		LaunchMP()
	else
		SetLaunchState( eLaunchState.WAIT_TO_CONTINUE, "", Localize( "#MAINMENU_CONTINUE" ) )
}


void function OnMainMenuPanel_Hide( var panel )
{
	Signal( uiGlobal.signalDummy, "MainMenu_Think" )
	Signal( uiGlobal.signalDummy, "EndPrelaunchValidation" )
	file.working = false
	file.searching = false
	#if DURANGO_PROG
		file.forceProfileSelect = false
	#endif // DURANGO_PROG
}


void function SetLaunchState( int launchState, string details = "", string prompt = "" )
{
	printt( "*** SetLaunchState *** launchState: " + GetEnumString( "eLaunchState", launchState ) + " details: \"" + details + "\" prompt: \"" + prompt + "\"" )

	if ( launchState == eLaunchState.WAIT_TO_CONTINUE )
	{
		file.launchButtonActivateFunc = PrelaunchValidateAndLaunch
		AccessibilityHint( eAccessibilityHint.LAUNCH_TO_LOBBY )
	}
	else
	{
		file.launchButtonActivateFunc = null
	}

	Hud_SetVisible( file.launchButton, launchState == eLaunchState.WAIT_TO_CONTINUE )

	RuiSetString( file.status, "prompt", prompt )
	RuiSetBool( file.status, "showPrompt", prompt != "" )

	file.working = launchState == eLaunchState.WORKING
	RuiSetBool( file.status, "showSpinner", file.working )

	thread ShowStatusMessagesAfterDelay()

	if ( details == "" )
		details = GetConVarString( "rspn_motd" )

	if ( details != "" )
		RuiSetString( file.statusDetails, "details", details )

	bool lastStatusDetailsVisiblity = file.statusDetailsVisiblity
	file.statusDetailsVisiblity = details != ""

	if ( file.statusDetailsVisiblity == true || ( file.statusDetailsVisiblity == false && lastStatusDetailsVisiblity != false ) )
	{
		RuiSetBool( file.statusDetails, "isVisible", file.statusDetailsVisiblity )
		RuiSetGameTime( file.statusDetails, "initTime", Time() )
	}

	UpdateSignedInState()
	UpdateFooterOptions()
}


void function ShowStatusMessagesAfterDelay()
{
	Signal( uiGlobal.signalDummy, "SetLaunchState" )
	EndSignal( uiGlobal.signalDummy, "SetLaunchState" )

	if ( !IsWorking() )
		return

	wait 5.0

	if ( !IsWorking() )
		return

	OnThreadEnd(
		function() : (  )
		{
			Hud_SetVisible( file.serverSearchMessage, false )
			Hud_SetVisible( file.serverSearchError, false )
		}
	)

	Hud_SetVisible( file.serverSearchMessage, true )
	Hud_SetVisible( file.serverSearchError, true )

	WaitForever()
}


bool function IsWorking()
{
	return file.working
}


void function StartSearchForPartyServer()
{
	#if DURANGO_PROG
		// IMPORTANT: As a safety measure leave any party view we are in at this point.
		// Otherwise, if you are unlucky enough to get stuck in a party view, you will
		// trash its state by pointing it to your private lobby.
		Durango_LeaveParty()
	#endif // DURANGO_PROG

	SearchForPartyServer()
	SetLaunchState( eLaunchState.WORKING )
	file.searching = true

#if SPINNER_DEBUG_INFO
	SetSpinnerDebugInfo( "SearchForPartyServer" )
#endif

	UpdateSignedInState()
	UpdateFooterOptions()

	thread SearchForPartyServerTimeout()

	thread LaunchR5RLobby( isLeavingMatch ? 0.0 : 1.0 )
}

void function LaunchR5RLobby( float delay = 0.0 )
{
	if( delay > 0 )
		wait delay

	CreateServer( "Lobby VM", "", "mp_lobby", "menufall", eServerVisibility.OFFLINE )

	isLeavingMatch = false
}


void function SearchForPartyServerTimeout()
{
	EndSignal( uiGlobal.signalDummy, "EndSearchForPartyServerTimeout" )

	Hud_SetAutoText( file.serverSearchMessage, "", HATT_MATCHMAKING_EMPTY_SERVER_SEARCH_STATE, 0 )
	Hud_SetAutoText( file.serverSearchError, "", HATT_MATCHMAKING_EMPTY_SERVER_SEARCH_ERROR, 0 )

	string noServers              = Localize( "#MATCHMAKING_NOSERVERS" )
	string serverError            = Localize( "#MATCHMAKING_SERVERERROR" )
	string localError             = Localize( "#MATCHMAKING_LOCALERROR" )
	string lastValidSearchMessage = ""
	string lastValidSearchError   = ""
	float startTime               = Time()

	while ( Time() - startTime < 30.0 )
	{
		string searchMessage = Hud_GetUTF8Text( file.serverSearchMessage )
		string searchError = Hud_GetUTF8Text( file.serverSearchError )
		//printt( "searchMessage:", searchMessage, "searchError:", searchError )

		if ( searchMessage == noServers || searchMessage == serverError || searchMessage == localError )
		{
			lastValidSearchMessage = searchMessage
			lastValidSearchError = searchError
		}

		WaitFrame()
	}
	//printt( "lastValidSearchMessage:", lastValidSearchMessage, "lastValidSearchError:", lastValidSearchError )

	string details
	if ( (lastValidSearchMessage == serverError || lastValidSearchMessage == localError) && lastValidSearchError != "" )
		details = Localize( "#UNABLE_TO_CONNECT_ERRORCODE", lastValidSearchError )
	else
		details = Localize( "#UNABLE_TO_CONNECT" )

	thread StopSearchForPartyServer( details, Localize( "#MAINMENU_RETRY" ) )
}


void function StopSearchForPartyServer( string details, string prompt )
{
	Signal( uiGlobal.signalDummy, "EndSearchForPartyServerTimeout" )

	MatchmakingCancel()
	ClientCommand( "party_leave" )
	SetLaunchState( eLaunchState.WAIT_TO_CONTINUE, details, prompt )
	file.searching = false

	UpdateSignedInState()
	UpdateFooterOptions()
}


bool function IsSearchingForPartyServer()
{
	return file.searching
}


#if DURANGO_PROG
void function UICodeCallback_OnStartedUserSignIn()
{
	printt( "UICodeCallback_OnStartedUserSignIn" )
	SetLaunchState( eLaunchState.WORKING )

#if SPINNER_DEBUG_INFO
	SetSpinnerDebugInfo( "OnStartedUserSignIn" )
#endif
}

void function UICodeCallback_OnFailedUserSignIn()
{
	printt( "UICodeCallback_OnFailedUserSignIn" )
	SetLaunchState( eLaunchState.WAIT_TO_CONTINUE, "", Localize( "#MAINMENU_SIGN_IN" ) )
}

void function UICodeCallback_OnCompletedUserSignIn()
{
	printt( "UICodeCallback_OnCompletedUserSignIn" )
	SetLaunchState( eLaunchState.WAIT_TO_CONTINUE, "", Localize( "#MAINMENU_CONTINUE" ) )
}

void function UICodeCallback_OnUserSignOut()
{
	printt( "UICodeCallback_OnUserSignOut" )
	SetLaunchState( eLaunchState.WAIT_TO_CONTINUE, "", Localize( "#MAINMENU_SIGN_IN" ) )
}

void function XB1_PermissionsDialog()
{
	Durango_VerifyMultiplayerPermissions()

	if ( !Console_HasPermissionToPlayMultiplayer() )
		file.forceProfileSelect = true

	// TODO: Need code to know when this ends
	//PrelaunchValidateAndLaunch()
}
#endif // DURANGO_PROG


#if PS4_PROG
// TODO: All of this needs improving. Need simpler interface to script.
void function PS4_PSNSignIn()
{
	if ( Ps4_LoginDialog_Schedule() )
	{
#if SPINNER_DEBUG_INFO
		SetSpinnerDebugInfo( "Ps4_LoginDialog_Running" )
#endif
		while ( Ps4_LoginDialog_Running() )
			WaitFrame()

		//printt( "!!!!!!!!!!!!!!!!!!!!!!!!! starting PS4_ScheduleUserNetworkingEnabledTest" )

		PS4_ScheduleUserNetworkingEnabledTest()
		WaitFrame()
		if ( !PS4_isUserNetworkingResolved() )
		{
			//printt( "PS4 - networking isn't resolved yet" )
#if SPINNER_DEBUG_INFO
			SetSpinnerDebugInfo( "PS4_isUserNetworkingResolved" )
#endif
			while ( !PS4_isUserNetworkingResolved() )
				WaitFrame()
		}

		//printt( "!!!!!!!!!!!!!!!!!!!!!!!!! PS4_isUserNetworkingEnabled", PS4_isUserNetworkingEnabled() )
		//printt( "!!!!!!!!!!!!!!!!!!!!!!!!! resolved and not enabled means you failed with dialog or net is down or something else?" )

		// Had to add PS4_NETWORK_STATUS_AGE_RESTRICTION check because PS4_isUserNetworkingEnabled() will be false when that is the resolution and underage users that just signed in were being asked to sign in again
		if ( !PS4_isUserNetworkingEnabled() && PS4_getUserNetworkingResolution() != PS4_NETWORK_STATUS_AGE_RESTRICTION )
		{
			// user backed out of login or forgot password or ...
			SetLaunchState( eLaunchState.WAIT_TO_CONTINUE, Localize( "#PS4_DISCONNECT_NOT_SIGNED_IN_TO_PSN" ), Localize( "#MAINMENU_SIGN_IN" ) )
		}
		else
		{		
			//printt( "!!!!!!!!!!!!!!!!!!!!!!!!! PS4_getUserNetworkingResolution", PS4_getUserNetworkingResolution() )
			//printt( "!!!!!!!!!!!!!!!!!!!!!!!!! Ps4_PSN_Is_Loggedin", Ps4_PSN_Is_Loggedin() )

			bool isPSNConnected
			if ( PS4_getUserNetworkingResolution() == PS4_NETWORK_STATUS_NOT_LOGGED_IN )
			{
				isPSNConnected = false
			}
			else
			{
				float endTime = Time() + 10
				while ( !Ps4_PSN_Is_Loggedin() && Time() < endTime )
					WaitFrame()

				isPSNConnected = Ps4_PSN_Is_Loggedin()
			}

			PrintLaunchDebugVal( "isPSNConnected", isPSNConnected )
			if ( !isPSNConnected )
				SetLaunchState( eLaunchState.WAIT_TO_CONTINUE, Localize( "#PS4_DISCONNECT_NOT_SIGNED_IN_TO_PSN" ), Localize( "#MAINMENU_SIGN_IN" ) )
			else
				PrelaunchValidateAndLaunch()
		}
	}
}


void function PS4_PlusSignUp()
{
	if ( Ps4_ScreenPlusDialog_Schedule() )
	{
#if SPINNER_DEBUG_INFO
		SetSpinnerDebugInfo( "Ps4_ScreenPlusDialog_Running" )
#endif
		while ( Ps4_ScreenPlusDialog_Running() )
			WaitFrame()

		Ps4_CheckPlus_Schedule()
#if SPINNER_DEBUG_INFO
		SetSpinnerDebugInfo( "Ps4_CheckPlus_Running" )
#endif
		while ( Ps4_CheckPlus_Running() )
			WaitFrame()
		bool hasPlus = Ps4_CheckPlus_Allowed()
		PrintLaunchDebugVal( "hasPlus", hasPlus )

		if ( !hasPlus )
			SetLaunchState( eLaunchState.WAIT_TO_CONTINUE, Localize( "#PSN_MUST_BE_PLUS_USER" ), Localize( "#MAINMENU_CONTINUE" ) )
		else
			PrelaunchValidateAndLaunch()
	}
}
#endif // PS4_PROG

void function LaunchButton_OnActivate( var button )
{
	if ( file.launchButtonActivateFunc == null )
		return

	printt( "*** LaunchButton_OnActivate ***", string( file.launchButtonActivateFunc ) )
	thread file.launchButtonActivateFunc()
}


void function UICodeCallback_GetOnPartyServer()
{
	uiGlobal.launching = eLaunching.MULTIPLAYER_INVITE
	PrelaunchValidateAndLaunch()
}


bool function IsStryderAuthenticated()
{
	return GetConVarInt( "mp_allowed" ) != -1
}


bool function IsStryderAllowingMP()
{
	return GetConVarInt( "mp_allowed" ) == 1
}


// TODO: Non-PS4 platforms need to actually check instead of blindly returning true
bool function HasLatestPatch()
{
	#if PS4_PROG
		if ( PS4_getUserNetworkingErrorStatus() == -2141913073 ) // SCE_NP_ERROR_LATEST_PATCH_PKG_EXIST
			return false
	#endif // PS4_PROG

	return true
}


bool function HasPermission()
{
	#if CONSOLE_PROG
		return Console_HasPermissionToPlayMultiplayer() // A more general permission check. Can fail if not patched, underage profile logged in to another controller, network issue, etc.
	#endif

	return true
}


void function Accessibility_OnActivate( var button )
{
	#if DURANGO_PROG
		if ( !Console_IsSignedIn() )
			return
	#endif

	if ( IsDialog( GetActiveMenu() ) )
		return

	if ( !IsAccessibilityAvailable() )
		return

	AdvanceMenu( GetMenu( "AccessibilityDialog" ) )
}


void function OnConfirmDialogResult( int result )
{
	printt( result )
}


void function PrintLaunchDebugVal( string name, bool val )
{
	#if DEVELOPER
		printt( "*** PrelaunchValidation *** " + name + ": " + val )
	#endif // DEVELOPER
}


#if CONSOLE_PROG
void function NucleusLogin()
{
	if ( file.isNucleusProcessActive )
		return

	file.isNucleusProcessActive = true
	OnThreadEnd( void function() {
		file.isNucleusProcessActive = false
	} )

	if ( !Nucleussdk_is_loggedin() )
	{
		printt( "Nucleussdk_is_loggedin is false 1." )
		WaitFrame();
		Nucleussdk_login()
#if SPINNER_DEBUG_INFO
		SetSpinnerDebugInfo( "Nucleussdk_is_loging_in" )
#endif
		while ( Nucleussdk_is_loging_in() )
			WaitFrame()
	}

	if ( !Nucleussdk_is_loggedin() )
	{
		string errorDetails
		switch ( Nucleussdk_last_error() )
		{
			case EA_Nucleus_kNcsErrorLoginCancelled:
				errorDetails = Localize( "#ORIGINSDK_NO_ACCOUNT" )
				break
			case EA_Nucleus_kNcsErrorServerError:
				errorDetails = Localize( "#ORIGINSDK_EA_NETWORK" )
				break
			case EA_Nucleus_kNcsErrorDeviceTokenError:
				#if DURANGO_PROG
					errorDetails = Localize( "#ORIGINSDK_XBOX1_NETWORK" )
				#elseif PS4_PROG
					errorDetails = Localize( "#ORIGINSDK_PS4_NETWORK" )
				#endif
				break
			default:
				errorDetails = Localize( "#ORIGINSDK_UNKNOWN_ERROR", string( Nucleussdk_last_error() ) )
				break
		}

		SetLaunchState( eLaunchState.WAIT_TO_CONTINUE, errorDetails, Localize( "#MAINMENU_RETRY" ) )
		return
	}
	else
	{
		PrelaunchValidateAndLaunch()
	}
}
#endif // CONSOLE_PROG

void function SwitchProfile_OnActivate( var button )
{
	#if DURANGO_PROG
		// this combo seems to put us in the right state for the account picker to properly show when we press "A"
		Durango_ShowAccountPicker()
		Durango_GoToSplashScreen()
		SetLaunchState( eLaunchState.WAIT_TO_CONTINUE, "", Localize( "#MAINMENU_SIGN_IN" ) )
	#endif
}


bool function IsSwitchProfileFooterValid()
{
	#if DURANGO_PROG
		return Console_IsSignedIn() && !IsWorking() && !IsSearchingForPartyServer()
	#else
		return false
	#endif
}