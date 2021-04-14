global function InitConfirmExitToDesktopDialog
global function OpenConfirmExitToDesktopDialog

struct
{
	var menu
	var contentRui
} file

void function InitConfirmExitToDesktopDialog()
{
	var menu = GetMenu( "ConfirmExitToDesktopDialog" )
	file.menu = menu

	SetDialog( menu, true )
	SetGamepadCursorEnabled( menu, false )

	file.contentRui = Hud_GetRui( Hud_GetChild( file.menu, "ContentRui" ) )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, ConfirmExitToDesktopDialog_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, ConfirmExitToDesktopDialog_OnClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, ConfirmExitToDesktopDialog_OnNavigateBack )

	AddMenuFooterOption( menu, LEFT, BUTTON_A, true, "#A_BUTTON_YES", "#YES", Confirm )
	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CANCEL", "#B_BUTTON_CANCEL" )
}

void function OpenConfirmExitToDesktopDialog()
{
	AdvanceMenu( file.menu )
}

void function Confirm( var button )
{
	ClientCommand( "quit" )
}

void function ConfirmExitToDesktopDialog_OnOpen()
{
	RuiSetString( file.contentRui, "headerText", "#EXIT_TO_DESKTOP" )
	RuiSetString( file.contentRui, "messageText", "#EXITING_TO_DESKTOP" )
}

void function ConfirmExitToDesktopDialog_OnClose()
{
}

void function ConfirmExitToDesktopDialog_OnNavigateBack()
{
	CloseActiveMenu()
}
