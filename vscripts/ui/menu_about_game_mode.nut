global function InitAboutGameModeMenu
global function OpenAboutGameModePage

struct
{
	var menu
} file

void function InitAboutGameModeMenu( var newMenuArg ) //
{
	var menu = GetMenu( "AboutGameModeMenu" )
	file.menu = menu

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnAboutGameModeMenu_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnAboutGameModeMenu_Close )

	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, OnAboutGameModeMenu_Show )
	AddMenuEventHandler( menu, eUIEvent.MENU_HIDE, OnAboutGameModeMenu_Hide )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
}

void function OpenAboutGameModePage( var button )
{
	AdvanceMenu( file.menu )
}

void function OnAboutGameModeMenu_Open()
{
	var rui = Hud_GetRui( Hud_GetChild( file.menu, "InfoMain" ) )
	UISize screenSize = GetScreenSize()
//
	RuiSetFloat2( rui, "actualRes", < screenSize.width, screenSize.height, 0 > )

	/*array<int> emblemColor = GetEmblemColor( Lobby_GetSelectedPlaylist() )
	RuiSetColorAlpha( rui, "emblemColor", SrgbToLinear( <emblemColor[0],emblemColor[1],emblemColor[2]> / 255.0 ), emblemColor[3] / 255.0 )*/

	string aboutTitle = GetPlaylistVarString( Lobby_GetSelectedPlaylist(), "name", "" )
	string aboutText = GetPlaylistVarString( Lobby_GetSelectedPlaylist(), "about_text", "" )
	RuiSetString( rui, "aboutTitle", aboutTitle )
	RuiSetString( rui, "aboutText", aboutText )
}

void function OnAboutGameModeMenu_Close()
{

}

void function OnAboutGameModeMenu_Show()
{

}

void function OnAboutGameModeMenu_Hide()
{

}