global function InitDeathScreenSpectatePanel
global function UI_UpdateDeathScreenSpectatePanel

struct
{
	var panel
} file

void function InitDeathScreenSpectatePanel( var panel )
{
	file.panel = panel

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, SpectateOnOpenPanel )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, SpectateOnClosePanel )

	SetPanelClearBlur( panel, true )

	InitDeathScreenPanelFooter( panel, eDeathScreenPanel.SPECTATE)
}


void function SpectateOnOpenPanel( var panel )
{
	//

	var menu = GetParentMenu( panel )
	var headerElement = Hud_GetChild( menu, "Header" )
	RunClientScript( "UICallback_ShowSpectateTab", headerElement )

	RegisterButtonPressedCallback( KEY_LSHIFT, DeathScreenTryToggleGladCard )
	RegisterButtonPressedCallback( KEY_RSHIFT, DeathScreenTryToggleGladCard )
	RegisterButtonPressedCallback( KEY_SPACE, DeathScreenPingRespawn )
	RegisterButtonPressedCallback( KEY_R, DeathScreenOnReportButtonClick )
	RegisterButtonPressedCallback( MOUSE_MIDDLE, DeathScreenSpectateNext )
	RegisterButtonPressedCallback( MOUSE_WHEEL_UP, DeathScreenSpectateNext )
	RegisterButtonPressedCallback( MOUSE_WHEEL_DOWN, DeathScreenSpectateNext )
	RegisterButtonPressedCallback( KEY_TAB, DeathScreenSkipDeathCam )

	DeathScreenUpdateCursor()
}


void function UI_UpdateDeathScreenSpectatePanel()
{
	//

	var menu = GetParentMenu( file.panel )
	var headerElement = Hud_GetChild( menu, "Header" )
	RunClientScript( "UICallback_ShowSpectateTab", headerElement )
}


void function SpectateOnClosePanel( var panel )
{
	DeregisterButtonPressedCallback( KEY_LSHIFT, DeathScreenTryToggleGladCard )
	DeregisterButtonPressedCallback( KEY_RSHIFT, DeathScreenTryToggleGladCard )
	DeregisterButtonPressedCallback( KEY_SPACE, DeathScreenPingRespawn )
	DeregisterButtonPressedCallback( KEY_R, DeathScreenOnReportButtonClick )
	DeregisterButtonPressedCallback( MOUSE_MIDDLE, DeathScreenSpectateNext )
	DeregisterButtonPressedCallback( MOUSE_WHEEL_UP, DeathScreenSpectateNext )
	DeregisterButtonPressedCallback( MOUSE_WHEEL_DOWN, DeathScreenSpectateNext )
	DeregisterButtonPressedCallback( KEY_TAB, DeathScreenSkipDeathCam )
}
