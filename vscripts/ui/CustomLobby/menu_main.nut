global function InitR5RMainMenu
global function SetMainMenuBlackScreenVisible

global bool g_isAtMainMenu = false

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
	RuiSetString( subtitleRui, "subtitleText", Localize( "Reloaded" ).toupper() )
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

void function OnR5RSB_Show()
{
	thread SetAtMainMenu()

	int width = int( Hud_GetHeight( file.titleArt ) * 1.77777778 )
	Hud_SetWidth( file.titleArt, width )
	Hud_SetWidth( file.subtitle, width )

	ActivatePanel( GetPanel( "R5RMainMenuPanel" ) )

	Chroma_MainMenu()
}

void function SetAtMainMenu()
{
	//You are at the main menu
	g_isAtMainMenu = true

	//Wait a extra 1.5 before showing the main menu
	wait 1.5
	
	//Hide the fullscreen black panel
	SetMainMenuBlackScreenVisible(false)
}

void function SetMainMenuBlackScreenVisible(bool show)
{
	//Hide/show full black screen
	Hud_SetVisible(Hud_GetChild( file.menu, "FullBlackScreen" ), show)
}

void function OnR5RSB_Close()
{
	HidePanel( GetPanel( "R5RMainMenuPanel" ) )
}

void function OnR5RSB_NavigateBack()
{
    OpenConfirmExitToDesktopDialog()
}