global function InitMainMenu
//global function UpdateDataCenterFooter
global function LaunchMP
global function AttemptLaunch
global function GetUserSignInState
global function UpdateSignedInState

struct
{
	var menu
	var titleArt
	var versionDisplay
	var signedInDisplay
	#if PS4_PROG
		bool chatRestrictionNoticeJustHandled = false
	#endif // PS4_PROG
} file


void function InitMainMenu()
{
	var menu = GetMenu( "MainMenu" )
	file.menu = menu

	SetGamepadCursorEnabled( menu, false )

	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, OnMainMenu_Show )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnMainMenu_NavigateBack )

	file.titleArt = Hud_GetChild( file.menu, "TitleArt" )
	var titleArtRui = Hud_GetRui( file.titleArt )
	RuiSetImage( titleArtRui, "basicImage", $"ui/menu/title_screen/title_art" )

	file.versionDisplay = Hud_GetChild( menu, "versionDisplay" )
	file.signedInDisplay = Hud_GetChild( menu, "SignInDisplay" )
}


void function OnMainMenu_Show()
{
	Hud_SetWidth( file.titleArt, int( Hud_GetHeight( file.titleArt ) * 1.77777778 ) ) // force aspect correct width
	Hud_SetText( file.versionDisplay, GetPublicGameVersion() )
	Hud_Show( file.versionDisplay )

	ActivatePanel( GetPanel( "MainMenuPanel" ) )
}


void function ActivatePanel( var panel )
{
	Assert( panel != null )

	array<var> elems = GetElementsByClassname( file.menu, "MainMenuPanelClass" )
	foreach ( elem in elems )
	{
		if ( elem != panel && Hud_IsVisible( elem ) )
			HidePanel( elem )
	}

	ShowPanel( panel )
}


void function OnMainMenu_NavigateBack()
{
	if ( IsSearchingForPartyServer() )
	{
		StopSearchForPartyServer( "", Localize( "#MAINMENU_CONTINUE" ) )
		return
	}

	#if PC_PROG
		OpenConfirmExitToDesktopDialog()
	#endif // PC_PROG
}


int function GetUserSignInState()
{
	#if DURANGO_PROG
		if ( Durango_InErrorScreen() )
		{
			return userSignInState.ERROR
		}
		else if ( Durango_IsSigningIn() )
		{
			return userSignInState.SIGNING_IN
		}
		else if ( !Console_IsSignedIn() && !Console_SkippedSignIn() )
		{
			//printt( "Console_IsSignedIn():", Console_IsSignedIn(), "Console_SkippedSignIn:", Console_SkippedSignIn() )
			return userSignInState.SIGNED_OUT
		}

		Assert( Console_IsSignedIn() || Console_SkippedSignIn() )
	#endif
	return userSignInState.SIGNED_IN
}


void function UpdateSignedInState()
{
	#if DURANGO_PROG
		if ( Console_IsSignedIn() )
		{
			Hud_SetText( file.signedInDisplay, Localize( "#SIGNED_IN_AS_N", Durango_GetGameDisplayName() ) )
			return
		}
	#endif
	Hud_SetText( file.signedInDisplay, "" )
}

void function LaunchMP()
{
	uiGlobal.launching = eLaunching.MULTIPLAYER
	AttemptLaunch()
}


void function AttemptLaunch()
{
	if ( uiGlobal.launching == eLaunching.FALSE )
		return
	Assert( uiGlobal.launching == eLaunching.MULTIPLAYER ||	uiGlobal.launching == eLaunching.MULTIPLAYER_INVITE )

	#if CONSOLE_PROG
		if ( !IsEULAAccepted() )
		{
			if ( GetActiveMenu() == GetMenu( "EULADialog" ) )
				return

			if ( IsDialog( GetActiveMenu() ) )
				CloseActiveMenu( true )

			if ( GetUserSignInState() != userSignInState.SIGNED_IN )
				return

			OpenEULADialog( false )
			return
		}
	#endif // CONSOLE_PROG

	#if PS4_PROG
		// If profile has chat restriction enabled show notice
		// TODO: The implementation of this would be much better if we could check for the need to show it separately from actually showing it.
		if ( !file.chatRestrictionNoticeJustHandled )
		{
			thread PS4_ChatRestrictionNotice()
			return
		}
	#endif // PS4_PROG

	if ( !IsIntroViewed() )
	{
		if ( GetActiveMenu() == GetMenu( "PlayVideoMenu" ) )
			return

		if ( IsDialog( GetActiveMenu() ) )
			CloseActiveMenu( true )

		PlayVideoMenu( "intro", "Apex_Opening_Movie", true, PrelaunchValidateAndLaunch )
		return
	}

	StartSearchForPartyServer()

	uiGlobal.launching = eLaunching.FALSE
	#if PS4_PROG
		file.chatRestrictionNoticeJustHandled = false
	#endif // PS4_PROG
}


#if PS4_PROG
void function PS4_ChatRestrictionNotice()
{
	Plat_ShowChatRestrictionNotice()
	while ( Plat_IsSystemMessageDialogOpen() )
		WaitFrame()

	file.chatRestrictionNoticeJustHandled = true
	PrelaunchValidateAndLaunch()
}
#endif // PS4_PROG
