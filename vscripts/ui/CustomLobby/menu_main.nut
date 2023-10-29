global function InitR5RMainMenu
global function SetMainMenuBlackScreenVisible

struct
{
	var menu

	var titleArt
	var subtitle
} file

void function InitR5RMainMenu( var newMenuArg )
{
	var menu = GetMenu( "R5RMainMenu" )
	file.menu = menu

	//Setup menu event handlers
    AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, OnR5RSB_Show )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnR5RSB_Close )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnR5RSB_NavigateBack )

	//Setup titleArt
	file.titleArt = Hud_GetChild( file.menu, "TitleArt" )
	var titleArtRui = Hud_GetRui( file.titleArt )
	RuiSetImage( titleArtRui, "basicImage", $"ui/menu/title_screen/title_art" )

	//Setup subtitle
	file.subtitle = Hud_GetChild( file.menu, "Subtitle" )
	var subtitleRui = Hud_GetRui( file.subtitle )
	RuiSetString( subtitleRui, "subtitleText", "Flowstate ".toupper() + FLOWSTATE_VERSION )
}

void function OnR5RSB_Show()
{
	thread SetAtMainMenu()

	int width = int( Hud_GetHeight( file.titleArt ) * 1.77777778 )
	Hud_SetWidth( file.titleArt, width )
	Hud_SetWidth( file.subtitle, width )

	ActivatePanel( GetPanel( "R5RMainMenuPanel" ) )

	Chroma_MainMenu()
}

void function OnR5RSB_Close()
{
	HidePanel( GetPanel( "R5RMainMenuPanel" ) )
}

void function OnR5RSB_NavigateBack()
{
    OpenConfirmExitToDesktopDialog()
}

void function SetAtMainMenu()
{
	WaitFrame()

	//Hide the fullscreen black panel
	SetMainMenuBlackScreenVisible(false)
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

	// check if eula version is greater than the last accepted version
	// as this will require the user to view the EULA again
	if( !IsEULAAccepted() )
	{
		OpenEULADialog(false)
	}
}

void function SetMainMenuBlackScreenVisible(bool show)
{
	//Hide/show full black screen
	Hud_SetVisible(Hud_GetChild( file.menu, "FullBlackScreen" ), show)
}