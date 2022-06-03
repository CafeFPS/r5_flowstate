global function InitConfirmLeaveMatchDialog
global function ConfirmLeaveMatchDialog_Open
global function ConfirmLeaveMatchDialog_SetPlayerCanBeRespawned

struct
{
	var menu
	var contentRui
	bool playerCanBeRespawned
	bool penaltyMayBeActive
	bool hasShownRespawnWarningString
	float nextAllowCloseTime
	float nextAllowConfirmTime
	string warningString = "#ARE_YOU_SURE_YOU_WANT_TO_LEAVE"
} file

void function InitConfirmLeaveMatchDialog( var newMenuArg )
{
	var menu = GetMenu( "ConfirmLeaveMatchDialog" )
	file.menu = menu

	SetDialog( menu, true )
	SetGamepadCursorEnabled( menu, false )

	file.contentRui = Hud_GetRui( Hud_GetChild( file.menu, "ContentRui" ) )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, ConfirmLeaveMatchDialog_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, ConfirmLeaveMatchDialog_OnClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, ConfirmLeaveMatchDialog_OnNavigateBack )

	AddMenuFooterOption( menu, LEFT, BUTTON_A, true, "#A_BUTTON_YES", "#YES", Confirm )
	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CANCEL", "#B_BUTTON_CANCEL" )
}

void function Confirm( var button )
{
	if ( Time() < file.nextAllowConfirmTime )
		return

	if ( IsFullyConnected() )
	{
		RunClientScript( "UICallback_QueryPlayerCanBeRespawned" )

		if ( file.playerCanBeRespawned && !file.hasShownRespawnWarningString )
		{
			file.nextAllowConfirmTime = Time() + 0.5 // Anti A spam
			file.hasShownRespawnWarningString = true
			EmitUISound( "ui_ingame_markedfordeath_playermarked" )
			SetWarningString( "#YOU_CAN_STILL_BE_RESPAWNED" )
			return
		}
	}

	if ( GetActiveMenu() == file.menu )
		CloseActiveMenu()

	LeaveMatchWithDialog()
}

void function ConfirmLeaveMatchDialog_OnOpen()
{
	SetWarningString( file.warningString )
}

void function ConfirmLeaveMatchDialog_OnClose()
{
}

void function ConfirmLeaveMatchDialog_SetPlayerCanBeRespawned( bool playerCanBeRespawned, bool penaltyMayBeActive )
{
	file.playerCanBeRespawned = playerCanBeRespawned
	file.penaltyMayBeActive = penaltyMayBeActive
}

void function SetWarningString( string newStr )
{
	file.warningString = newStr
	RuiSetString( file.contentRui, "headerText", Localize( file.warningString ).toupper() )
}

void function ConfirmLeaveMatchDialog_Open()
{
	RunClientScript( "UICallback_QueryPlayerCanBeRespawned" )

	ConfirmDialogData data
	data.headerText = "#LEAVE_MATCH"
	if ( file.playerCanBeRespawned )
	{
		if ( file.penaltyMayBeActive )
			data.messageText = "#YOU_CAN_STILL_BE_RESPAWNED_LEAVE_PENALTY"
		else
			data.messageText = "#YOU_CAN_STILL_BE_RESPAWNED"

		data.contextImage = $"rui/hud/gametype_icons/survival/dna_station"
	}
	else if ( file.penaltyMayBeActive )
	{
		data.messageText = "#ARE_YOU_SURE_YOU_WANT_TO_LEAVE_PENALTY"
	}
	else if ( IsSurvivalTraining() || IsFiringRangeGameMode() )
	{
		data.headerText = "#RETURN_TO_LOBBY"
		data.messageText = "#LEAVE_QUESTION"
	}
	else
	{
		data.messageText = "#ARE_YOU_SURE_YOU_WANT_TO_LEAVE"
	}

	data.resultCallback = OnLeaveMatchDialogResult

	OpenConfirmDialogFromData( data )
}


void function OnLeaveMatchDialogResult( int result )
{
	if ( result != eDialogResult.YES )
	{
		file.nextAllowCloseTime = Time() + 0.1
		return
	}

	LeaveMatchWithDialog()
}


void function ConfirmLeaveMatchDialog_OnNavigateBack()
{
	file.nextAllowCloseTime = Time() + 0.1
	CloseActiveMenu()
}
