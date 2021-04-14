global function ShowNotification
global function InitNotificationsMenu

struct
{
	var menu
	var notificationBoxRui
} file

void function ShowNotification()
{
	BackendError backendError = GetBackendError()
	if ( backendError.errorString == "" && IsViewingNotification() )
		return

	if ( backendError.errorString != "" )
	{
		printt( "showing notification of " + backendError.errorString )
		RuiSetString( file.notificationBoxRui, "titleText", "#NOTIFICATION" )
		RuiSetString( file.notificationBoxRui, "messageText", backendError.errorString )

		Hud_Show( file.menu )
		thread HideNotificationInABit()

		if ( !IsLobby() && IsFullyConnected() )
			RunClientScript( "UIToClient_Notification", "#NOTIFICATION", backendError.errorString )
	}
	else
	{
		Hud_Hide( file.menu )
	}
}

void function HideNotificationInABit()
{
	 EndSignal( uiGlobal.signalDummy, "CleanupInGameMenus" )

	float notificationWaitTime = GetConVarFloat( "notification_displayTime" )
	printt( "about to wait " + notificationWaitTime + " while we show a notification\n" )
	wait notificationWaitTime

	printt( "we're done waiting " + notificationWaitTime + " while we showed a notification" )

	Hud_Hide( file.menu )

	ShowNotification()
}

bool function IsViewingNotification()
{
	return Hud_IsVisible( file.menu )
}

void function InitNotificationsMenu()
{
	file.menu = GetMenu( "Notifications" )

	Hud_Hide( file.menu )
	Hud_SetAboveBlur( file.menu, true )
	file.notificationBoxRui = Hud_GetRui( Hud_GetChild( file.menu, "NotificationBox" ) )

	Assert( !IsViewingNotification() )
}
