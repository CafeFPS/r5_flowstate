global function InitConfirmRestDialog													//mkos
global function ConfirmRestDialog_Open
global function ServerCallback_UiConfirmRest

const REST_CONFIRM_CMD = "rest 1"

struct
{
	var menu
	var contentRui
	
	float nextAllowCloseTime
	float nextAllowConfirmTime
	string warningString = "#FS_REST_CONFIRM"
	
} file

void function InitConfirmRestDialog( var newMenuArg )
{
	var menu = GetMenu( "ConfirmRestDialog" )
	file.menu = menu

	SetDialog( menu, true )
	SetGamepadCursorEnabled( menu, false )

	file.contentRui = Hud_GetRui( Hud_GetChild( file.menu, "ContentRui" ) )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, ConfirmRestDialog_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, ConfirmRestDialog_OnClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, ConfirmRestDialog_OnNavigateBack )

	AddMenuFooterOption( menu, LEFT, BUTTON_A, true, "#A_BUTTON_YES", "#YES", Confirm )
	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CANCEL", "#B_BUTTON_CANCEL" )
}

void function Confirm( var button )
{
	if ( Time() < file.nextAllowConfirmTime )
		return

	if ( GetActiveMenu() == file.menu )
		CloseActiveMenu()
}

void function ConfirmRestDialog_OnOpen()
{
	SetWarningString( file.warningString )
}

void function ConfirmRestDialog_OnClose()
{
}

void function SetWarningString( string newStr )
{
	file.warningString = newStr
	RuiSetString( file.contentRui, "headerText", Localize( file.warningString ).toupper() )
}

void function ServerCallback_UiConfirmRest()
{
	ConfirmRestDialog_Open()
}

void function ConfirmRestDialog_Open()
{
	ConfirmDialogData data
	data.headerText = "#FS_EXIT_ROUND"
	data.messageText = "#FS_REST_CONFIRM"

	data.resultCallback = OnRestDialogResult

	OpenConfirmDialogFromData( data )
}


void function OnRestDialogResult( int result )
{
	if ( result != eDialogResult.YES )
	{
		file.nextAllowCloseTime = Time() + 0.1
		return
	}
	
	RunClientScript( "UiToClient_ConfirmRest", REST_CONFIRM_CMD )
}


void function ConfirmRestDialog_OnNavigateBack()
{
	file.nextAllowCloseTime = Time() + 0.1
	CloseActiveMenu()
}
