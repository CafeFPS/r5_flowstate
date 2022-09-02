
global function InitR5RMainMenuPanel

struct
{
	var                menu
	var                panel

	bool			   isworking = false
} file

void function InitR5RMainMenuPanel( var panel )
{
	file.panel = GetPanel( "R5RMainMenuPanel" )
	file.menu = GetParentMenu( file.panel )

	//Setup panel event handlers
	AddPanelEventHandler( file.panel, eUIEvent.PANEL_SHOW, OnMainMenuPanel_Show )

	//Setup button event handlers
	Hud_AddEventHandler( Hud_GetChild( panel, "LaunchButton" ), UIE_CLICK, LaunchButton_OnActivate )
}

void function OnMainMenuPanel_Show( var panel )
{
	//Setup rui
	SetupRUI()
}

void function LaunchButton_OnActivate( var button )
{
	//return if is already working
	if(file.isworking)
		return

	//Launch lobby
	CreateServer("Lobby VM", "", "mp_lobby", "menufall", eServerVisibility.OFFLINE)
}

void function SetupRUI()
{
	file.isworking = false
	
	//Setup StatusDetails ui
	RuiSetString( Hud_GetRui( Hud_GetChild( file.panel, "StatusDetails" ) ), "details", "Press Enter to continue" )
	RuiSetBool( Hud_GetRui( Hud_GetChild( file.panel, "StatusDetails" ) ), "isVisible", true )
	RuiSetGameTime( Hud_GetRui( Hud_GetChild( file.panel, "StatusDetails" ) ), "initTime", Time() )

	//Setup Status ui
	RuiSetString( Hud_GetRui( Hud_GetChild( file.panel, "Status" ) ), "prompt", "" )
	RuiSetBool( Hud_GetRui( Hud_GetChild( file.panel, "Status" ) ), "showPrompt", false )
	RuiSetBool( Hud_GetRui( Hud_GetChild( file.panel, "Status" ) ), "showSpinner", false )
}