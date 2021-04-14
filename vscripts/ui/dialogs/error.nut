global function InitErrorDialog
global function OpenErrorDialogThread

struct
{
	var menu
	var contentRui
	asset contextImage
	string headerText
	string messageText
} file

void function InitErrorDialog()
{
	var menu = GetMenu( "ErrorDialog" )
	file.menu = menu

	SetDialog( menu, true )
	SetGamepadCursorEnabled( menu, false )

	file.contentRui = Hud_GetRui( Hud_GetChild( file.menu, "ContentRui" ) )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, ErrorDialog_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, ErrorDialog_OnClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, ErrorDialog_OnNavigateBack )

	AddMenuFooterOption( menu, LEFT, BUTTON_A, true, "#A_BUTTON_CONTINUE", "#CONTINUE", Continue )
}

void function Continue( var button )
{
	if ( GetActiveMenu() == file.menu )
		CloseActiveMenu()
}

void function ErrorDialog_OnOpen()
{
	RuiSetAsset( file.contentRui, "contextImage", file.contextImage )
	RuiSetString( file.contentRui, "headerText", file.headerText )
	RuiSetString( file.contentRui, "messageText", file.messageText )
}

void function ErrorDialog_OnClose()
{
}

void function ErrorDialog_OnNavigateBack()
{
	CloseActiveMenu()
}

void function OpenErrorDialogThread( string errorMessage )
{
	bool isIdleDisconnect = errorMessage.find( Localize( "#DISCONNECT_IDLE" ) ) == 0

	file.contextImage = isIdleDisconnect ? $"ui/menu/common/dialog_notice" : $"ui/menu/common/dialog_error"
	file.headerText = ( isIdleDisconnect ? Localize( "#DISCONNECTED_HEADER" ) : Localize( "#ERROR" ) ).toupper()
	file.messageText = errorMessage

	while ( GetActiveMenu() != GetMenu( "MainMenu" ) )
		WaitSignal( uiGlobal.signalDummy, "OpenErrorDialog", "ActiveMenuChanged" )

	AdvanceMenu( file.menu )
}