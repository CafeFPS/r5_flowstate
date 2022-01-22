global function InitErrorDialog
global function OpenErrorDialogThread

struct
{
	var menu
	var contentRui
	var errorimage
	var errorheader
	var errormessage

	asset contextImage
	string headerText
	string messageText
} file

void function InitErrorDialog( var newMenuArg )
{
	var menu = GetMenu( "ErrorDialog" )
	file.menu = menu

	SetDialog( menu, true )
	SetGamepadCursorEnabled( menu, false )

	//file.contentRui = Hud_GetRui( Hud_GetChild( file.menu, "ContentRui" ) )

	file.errorimage = Hud_GetRui( Hud_GetChild( file.menu, "ErrorImage" ) )
	file.errorheader = Hud_GetChild( file.menu, "ErrorHeader" )
	file.errormessage = Hud_GetChild( file.menu, "ErrorMessage" )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, ErrorDialog_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, ErrorDialog_OnClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, ErrorDialog_OnNavigateBack )

	var button = Hud_GetChild(menu, "ContinueButton")
	Hud_AddEventHandler( button, UIE_CLICK, Continue )

	//AddMenuFooterOption( menu, LEFT, BUTTON_A, true, "#A_BUTTON_CONTINUE", "#CONTINUE", Continue )
}

void function Continue( var button )
{
	if ( GetActiveMenu() == file.menu )
		CloseActiveMenu()
}

void function ErrorDialog_OnOpen()
{
	//RuiSetAsset( file.contentRui, "contextImage", file.contextImage )
	//RuiSetString( file.contentRui, "headerText", file.headerText )
	//RuiSetString( file.contentRui, "messageText", file.messageText )

	RuiSetImage( file.errorimage, "basicImage", file.contextImage )
	Hud_SetText(file.errorheader, file.headerText)
	Hud_SetText(file.errormessage, file.messageText)
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

	while ( GetActiveMenu() != GetMenu( "R5RMenu" ) )
		WaitSignal( uiGlobal.signalDummy, "OpenErrorDialog", "ActiveMenuChanged" )

	AdvanceMenu( file.menu )
}