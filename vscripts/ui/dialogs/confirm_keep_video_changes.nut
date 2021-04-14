global function InitConfirmKeepVideoChangesDialog

struct
{
	var menu
	var contentRui
	bool revertChanges = true
} file

void function InitConfirmKeepVideoChangesDialog()
{
	RegisterSignal( "EndVideoChangesCountdown" )

	var menu = GetMenu( "ConfirmKeepVideoChangesDialog" )
	file.menu = menu

	SetDialog( menu, true )
	SetGamepadCursorEnabled( menu, false )

	file.contentRui = Hud_GetRui( Hud_GetChild( file.menu, "ContentRui" ) )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, ConfirmKeepVideoChangesDialog_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, ConfirmKeepVideoChangesDialog_OnClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, ConfirmKeepVideoChangesDialog_OnNavigateBack )

	AddMenuFooterOption( menu, LEFT, BUTTON_A, true, "#A_BUTTON_YES", "#YES", Confirm )
	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CANCEL", "#B_BUTTON_CANCEL" )
}

void function Confirm( var button )
{
	file.revertChanges = false
	Signal( uiGlobal.signalDummy, "EndVideoChangesCountdown" )

	foreach ( func in uiGlobal.resolutionChangedCallbacks )
		func()

	if ( GetActiveMenu() == file.menu )
		CloseActiveMenu()
}

void function ConfirmKeepVideoChangesDialog_OnOpen()
{
	RuiSetString( file.contentRui, "headerText", Localize( "#KEEP_VIDEO_SETTINGS_CONFIRM" ) )
	thread VideoChangesCountdown()
}

void function ConfirmKeepVideoChangesDialog_OnClose()
{
}

void function ConfirmKeepVideoChangesDialog_OnNavigateBack()
{
	Signal( uiGlobal.signalDummy, "EndVideoChangesCountdown" )
}

void function VideoChangesCountdown()
{
	Signal( uiGlobal.signalDummy, "EndVideoChangesCountdown" )
	EndSignal( uiGlobal.signalDummy, "EndVideoChangesCountdown" )

	OnThreadEnd(
		function() : ()
		{
			if ( file.revertChanges )
			{
				if ( GetActiveMenu() == file.menu )
					CloseActiveMenu()

				RevertVideoSettings()
			}
		}
	)

	file.revertChanges = true
	int countdown = 15

	while ( countdown > 0 )
	{
		RuiSetString( file.contentRui, "messageText", Localize( "#REVERTING_VIDEO_SETTINGS_TIMER", countdown ) )

		wait 1.0
		countdown--
	}
}