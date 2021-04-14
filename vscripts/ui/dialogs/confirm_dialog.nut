global function InitConfirmDialog
global function InitOKDialog

global function OpenConfirmDialogFromData
global function OpenOKDialogFromData

enum eDialogType
{
	CONFIRM,
	OK,
}

global struct ConfirmDialogData
{
	string        headerText = "headerText"
	string        messageText = "messageText"
	array<string> okText = ["#B_BUTTON_CLOSE", "#B_BUTTON_CLOSE"]
	array<string> yesText = ["#A_BUTTON_YES", "#YES"]
	array<string> noText = ["#B_BUTTON_CANCEL", "#B_BUTTON_CANCEL"]
	asset         contextImage = $""

	void functionref( int )    resultCallback

	int dialogType
	var __menu
}

global enum eDialogResult
{
	CANCEL
	YES
	NO
}

struct
{
	var confirmMenu
	var okMenu
	var contentRui

	ConfirmDialogData ornull showDialogData
} file

void function InitConfirmDialog()
{
	var menu = GetMenu( "ConfirmDialog" )
	file.confirmMenu = menu

	SetDialog( menu, true )
	SetGamepadCursorEnabled( menu, false )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, Dialog_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, ConfirmDialog_OnClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, ConfirmDialog_OnNavigateBack )
}


void function InitOKDialog()
{
	var menu = GetMenu( "OKDialog" )
	file.okMenu = menu

	SetDialog( menu, true )
	SetGamepadCursorEnabled( menu, false )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, Dialog_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, ConfirmDialog_OnClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, ConfirmDialog_OnNavigateBack )
}


void function OpenConfirmDialogFromData( ConfirmDialogData dialogData )
{
	Assert( file.showDialogData == null )
	Assert( dialogData.resultCallback != null, "resultCallback == null; this dialog won't do anything" )

	dialogData.dialogType = eDialogType.CONFIRM
	dialogData.__menu = file.confirmMenu

	file.showDialogData = dialogData

	AdvanceMenu( GetMenu( "ConfirmDialog" ) )

	/*
	var                    menu
	string                 header
	string                 message
	DialogMessageRuiData & ruiMessage
	array                  messageColor = [161, 161, 161, 255]
	asset                  image
	asset                  rightImage = $""
	bool                   forceChoice = false
	bool                   noChoice = false
	bool                   noChoiceWithNavigateBack = false
	bool                   showSpinner = false
	bool                   showPCBackButton = false
	float                  inputDisableTime = 0
	table<int, bool>       coloredButton
	bool                   darkenBackground = false
	bool                   useFullMessageHeight = false
	float                  timeoutDuration = -1
	int                    magicNumber = 0

	array<DialogButtonData> buttonData
	array<DialogFooterData> footerData
	*/
}


void function OpenOKDialogFromData( ConfirmDialogData dialogData )
{
	Assert( file.showDialogData == null )

	dialogData.dialogType = eDialogType.OK
	dialogData.__menu = file.okMenu

	file.showDialogData = dialogData

	AdvanceMenu( GetMenu( "OKDialog" ) )
}


void function Dialog_OnOpen()
{
	Assert( file.showDialogData != null )

	ClearMenuFooterOptions( _confirmData().__menu )
	var contentRui = Hud_GetRui( Hud_GetChild( _confirmData().__menu, "ContentRui" ) )
	RuiSetString( contentRui, "headerText", _confirmData().headerText )
	RuiSetString( contentRui, "messageText", _confirmData().messageText )
	RuiSetAsset( contentRui, "contextImage", _confirmData().contextImage )

	if ( _confirmData().dialogType == eDialogType.CONFIRM )
	{
		AddMenuFooterOption( _confirmData().__menu, LEFT, BUTTON_A, true, _confirmData().yesText[0], _confirmData().yesText[1], ConfirmDialog_Yes )
		AddMenuFooterOption( _confirmData().__menu, LEFT, BUTTON_B, true, _confirmData().noText[0], _confirmData().noText[1], ConfirmDialog_No )
	}
	else
	{
		if ( _confirmData().yesText[0] != "" )
			AddMenuFooterOption( _confirmData().__menu, LEFT, BUTTON_B, true, _confirmData().okText[0], _confirmData().okText[1], ConfirmDialog_Yes )
	}
}


ConfirmDialogData function _confirmData()
{
	Assert( file.showDialogData != null )
	return expect ConfirmDialogData( file.showDialogData )
}


void function ConfirmDialog_OnClose()
{
	file.showDialogData = null
}


void function ConfirmDialog_OnNavigateBack()
{
	ConfirmDialogData confirmData = _confirmData()
	CloseActiveMenu()
	if ( confirmData.resultCallback != null )
		confirmData.resultCallback( eDialogResult.CANCEL )
}


void function ConfirmDialog_Yes( var button )
{
	// todo(bm): AddMenuFooterOption registers the inputs, and it seems flakey.
	if ( file.showDialogData == null )
		return

	ConfirmDialogData confirmData = _confirmData()
	if ( GetActiveMenu() == confirmData.__menu )
		CloseActiveMenu()

	if ( confirmData.resultCallback != null )
		confirmData.resultCallback( eDialogResult.YES )
}


void function ConfirmDialog_No( var button )
{
	// todo(bm): AddMenuFooterOption registers the inputs, and it seems flakey.
	if ( file.showDialogData == null )
		return

	ConfirmDialogData confirmData = _confirmData()
	if ( GetActiveMenu() == confirmData.__menu )
		CloseActiveMenu()

	if ( confirmData.resultCallback != null )
		confirmData.resultCallback( eDialogResult.NO )
}

