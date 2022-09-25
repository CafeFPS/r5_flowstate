global function InitR5RMainMenuPanel

struct
{
	var menu
	var panel
	var launchButton
} file

void function InitR5RMainMenuPanel( var panel )
{
	file.panel = GetPanel( "R5RMainMenuPanel" )
	file.menu = GetParentMenu( file.panel )
	file.launchButton = Hud_GetChild( panel, "LaunchButton" )

	// mainmenu handler
	AddPanelEventHandler( file.panel, eUIEvent.PANEL_SHOW, OnMainMenuPanel_Show )

	// launchbutton handler
	Hud_AddEventHandler( file.launchButton, UIE_CLICK, LaunchButton_OnActivate )
}

void function OnMainMenuPanel_Show( var panel )
{
	SetupRUI()
}

void function LaunchButton_OnActivate( var button )
{
	// create local lobby server
	CreateServer("Lobby", "", "mp_lobby", "menufall", eServerVisibility.OFFLINE)
}

void function SetupRUI()
{
	var statusDetailsRui = Hud_GetRui( Hud_GetChild( file.panel, "StatusDetails" ) )
	var statusRui = Hud_GetRui( Hud_GetChild( file.panel, "Status" ) )

	// setup StatusDetails ui
	// RuiSetString( statusDetailsRui, "details", "Press Enter to continue" )
	// RuiSetBool( statusDetailsRui, "isVisible", true )
	RuiSetGameTime( statusDetailsRui, "initTime", Time() )

	// setup Status ui
	RuiSetString( statusRui, "prompt", Localize("#MAINMENU_CONTINUE") )
	RuiSetBool( statusRui, "showPrompt", true )
	RuiSetBool( statusRui, "showSpinner", false )

	// setup launch button
	Hud_SetVisible( file.launchButton, true )

}