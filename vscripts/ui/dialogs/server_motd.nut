// mp server motd															//mkos
																			//used a template

global function Init_Server_MOTD
global function OpenServerMOTD
global function ServerMOTD_OnOpen
global function ServerMOTD_OnClose

struct
{
	var menu
	var ServerMessage
	var footersPanel
	var parentMenuPanel

	string serverMotdText
	
} file


void function Init_Server_MOTD( var newMenuArg )
{
	#if DEVELOPER
		printt("INIT Init_Server_MOTD")
	#endif
	
	var menu = GetMenu( "SERVER_MOTD" )
	file.menu = menu

	SetDialog( menu, true )
	
	SetGamepadCursorEnabled( menu, false )

	file.ServerMessage = Hud_GetChild( menu, "ServerMessage" )
	file.footersPanel = Hud_GetChild( menu, "FooterButtons" )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CLOSE", "#CLOSE", null )
	
	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, ServerMOTD_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, ServerMOTD_OnClose )
}

void function OpenServerMOTD( string motdText, var parentMenu = null )
{
	file.serverMotdText = motdText
	file.parentMenuPanel = parentMenu
	AdvanceMenu( file.menu )
}

void function ServerMOTD_OnOpen()
{
	if( file.parentMenuPanel != null )
		ScrollPanel_SetActive( file.parentMenuPanel, false )
		
	RegisterStickMovedCallback( ANALOG_RIGHT_Y, FocusServerMOTD )
	RegisterButtonPressedCallback( BUTTON_DPAD_UP, FocusServerMOTD )
	RegisterButtonPressedCallback( BUTTON_DPAD_DOWN, FocusServerMOTD )

	var frameElem = Hud_GetChild( file.menu, "DialogFrame" )
	RuiSetImage( Hud_GetRui( frameElem ), "basicImage", $"rui/menu/common/dialog_gradient" )

	int agreementHeight = 375
	Hud_SetHeight( file.ServerMessage, ContentScaledYAsInt( agreementHeight ) )

	int footerPanelWidth = 200 //: 422
	Hud_SetWidth( file.footersPanel, ContentScaledXAsInt( footerPanelWidth ) )

	Hud_SetText( file.ServerMessage, file.serverMotdText )
}


void function ServerMOTD_OnClose()
{
	if( file.parentMenuPanel != null )
		ScrollPanel_SetActive( file.parentMenuPanel, true )

	DeregisterStickMovedCallback( ANALOG_RIGHT_Y, FocusServerMOTD )
	DeregisterButtonPressedCallback( BUTTON_DPAD_UP, FocusServerMOTD )
	DeregisterButtonPressedCallback( BUTTON_DPAD_DOWN, FocusServerMOTD )
}


void function FocusServerMOTD( ... )
{
	if( !Hud_IsFocused( file.ServerMessage ) )
		Hud_SetFocused( file.ServerMessage )
}