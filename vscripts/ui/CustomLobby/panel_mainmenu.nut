global function InitR5RMainMenuPanel

struct
{
	var menu
	var panel
	var launchButton
	var status

	bool is_working = false
} file

void function InitR5RMainMenuPanel( var panel )
{
	file.panel = GetPanel( "R5RMainMenuPanel" )
	file.menu = GetParentMenu( file.panel )
	file.launchButton = Hud_GetChild( panel, "LaunchButton" )

	file.status = Hud_GetRui( Hud_GetChild( panel, "Status" ) )

	AddPanelEventHandler( file.panel, eUIEvent.PANEL_SHOW, OnMainMenuPanel_Show )
	Hud_AddEventHandler( file.launchButton, UIE_CLICK, LaunchButton_OnActivate )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_EXIT_TO_DESKTOP", "#B_BUTTON_EXIT_TO_DESKTOP", null, null )
	AddPanelFooterOption( panel, LEFT, BUTTON_Y, true, "#BUTTON_REVIEW_TERMS", "#REVIEW_TERMS", OpenEULAReviewFromFooter, null )
}

void function OpenEULAReviewFromFooter( var button )
{
	OpenEULADialog( IsEULAAccepted() )
}

void function LaunchButton_OnActivate( var button )
{
	if(file.is_working)
		return
	
	thread LaunchCustomLobby()
}

void function LaunchCustomLobby()
{
	file.is_working = true

	ShowSpinner(true)
	
	#if LISTEN_SERVER
	wait 1

	CreateServer("Lobby", "", "mp_lobby", "menufall", eServerVisibility.OFFLINE)
	#endif // LISTEN_SERVER
	
	ShowSpinner(false)

	file.is_working = false
}

void function ShowSpinner(bool show)
{
	RuiSetBool( file.status, "showSpinner", show )
	RuiSetBool( file.status, "showPrompt", !show )
}

void function OnMainMenuPanel_Show( var panel )
{
	var statusDetailsRui = Hud_GetRui( Hud_GetChild( file.panel, "StatusDetails" ) )
	var statusRui = Hud_GetRui( Hud_GetChild( file.panel, "Status" ) )

	RuiSetGameTime( statusDetailsRui, "initTime", Time() )
	RuiSetString( statusRui, "prompt", Localize("#MAINMENU_CONTINUE") )
	RuiSetBool( statusRui, "showPrompt", true )
	RuiSetBool( statusRui, "showSpinner", false )
	Hud_SetVisible( file.launchButton, true )
}