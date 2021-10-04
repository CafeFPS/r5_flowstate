global function InitReportPlayerDialog
global function InitReportReasonPopup
global function ClientToUI_ShowReportPlayerDialog

struct {
	var menu
	var reportReasonButton
	var reportCheatButton
	var reportOtherButton

	var reportReasonMenu

	var reportReasonPopup
	var reportReasonList

	var closeButton

	array<string> reasons

	table<var, string> buttonToReason

	string selectedReportReason = ""

	string reportPlayerName = ""
	string reportPlayerHardware = ""
	string reportPlayerUID = ""
	string friendlyOrEnemy = "friendly"
} file

void function InitReportPlayerDialog( var newMenuArg )
{
	var menu = GetMenu( "ReportPlayerDialog" )
	file.menu = menu

	file.reportReasonButton = Hud_GetChild( menu, "ReportReasonButton" )
	Hud_AddEventHandler( file.reportReasonButton, UIE_CLICK, ReportReasonButton_OnActivate )

	file.reportCheatButton = Hud_GetChild( menu, "ReportCheatButton" )
	Hud_AddEventHandler( file.reportCheatButton, UIE_CLICK, ReportCheatButton_OnActivate )

	file.reportOtherButton = Hud_GetChild( menu, "ReportOtherButton" )
	Hud_AddEventHandler( file.reportOtherButton, UIE_CLICK, ReportOtherButton_OnActivate )

	var panel = Hud_GetChild( file.menu, "FooterButtons" )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, ReportPlayerDialog_OnOpen )

	AddMenuFooterOption( menu, LEFT, BUTTON_A, true, "#A_BUTTON_REPORT", "#A_BUTTON_REPORT", ReportPlayerDialog_Yes )
	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CANCEL", "#B_BUTTON_CANCEL", ReportPlayerDialog_No )
}


void function ClientToUI_ShowReportPlayerDialog( string playerName, string playerHardware, string playerUID, string friendlyOrEnemy )
{
	if ( IsDialog( GetActiveMenu() ) )
		return

	file.friendlyOrEnemy = friendlyOrEnemy
	file.reportPlayerName = playerName
	file.reportPlayerHardware = playerHardware
	file.reportPlayerUID = playerUID

	int ver = GetReportStyle()
	#if(CONSOLE_PROG)
		ver = minint( ver, 1 )
	#endif

	if ( ver == 1 )
		ShowPlayerProfileCardForUID( file.reportPlayerUID )
	else if ( ver == 2 )
		AdvanceMenu( GetMenu( "ReportPlayerDialog" ) )
}


void function ReportPlayerDialog_OnOpen()
{
	var contentRui = Hud_GetRui( Hud_GetChild( file.menu, "ContentRui" ) )
	RuiSetString( contentRui, "headerText", "#REPORT_PLAYER" )
	RuiSetString( contentRui, "messageText", file.reportPlayerName )

	Hud_SetVisible( file.reportReasonButton, false )
	Hud_SetVisible( file.reportCheatButton, true )
	Hud_SetVisible( file.reportOtherButton, true )

	HudElem_SetRuiArg( file.reportReasonButton, "buttonText", Localize( "#SELECT_REPORT_REASON" ) )
	file.selectedReportReason = ""
}


void function ReportPlayerDialog_Yes( var button )
{
	#if(PC_PROG)
		string pcOrConsole = "pc"
	#else
		string pcOrConsole = "console"
	#endif

	if ( file.selectedReportReason != "" )
	{
		if ( IsFullyConnected() )
			ClientCommand( "ReportPlayer " + file.reportPlayerHardware + " " + file.reportPlayerUID + " " + file.selectedReportReason )

		CloseAllToTargetMenu( file.menu )
		CloseActiveMenu()
	}

}

void function ReportPlayerDialog_No( var button )
{
	CloseAllToTargetMenu( file.menu )
	CloseActiveMenu()
}


void function ReportReasonButton_OnActivate( var button )
{
	AdvanceMenu( GetMenu( "ReportPlayerReasonPopup" ) )
	Hud_SetSelected( file.reportReasonButton, true )
}

void function ReportCheatButton_OnActivate( var button )
{
	file.reasons = GetCheatReportReasons()

	Hud_SetVisible( file.reportReasonButton, GetCheatReportReasons().len() > 0 )

	Hud_SetVisible( file.reportCheatButton, false )
	Hud_SetVisible( file.reportOtherButton, false )
}

void function ReportOtherButton_OnActivate( var button )
{
	#if(PC_PROG)
/*
*/
		if ( file.friendlyOrEnemy == "friendly" )
		{
			file.reasons = GetHarassmentReportReasons()
			Hud_SetVisible( file.reportReasonButton, GetHarassmentReportReasons().len() > 0 )
			Hud_SetVisible( file.reportCheatButton, false )
			Hud_SetVisible( file.reportOtherButton, false )
		}
		else
		{
			CloseActiveMenu( true, true )

			if ( !Origin_IsOverlayAvailable() )
			{
				ConfirmDialogData dialogData
				dialogData.headerText = ""
				dialogData.messageText = "#ORIGIN_INGAME_REQUIRED"
				dialogData.contextImage = $"ui/menu/common/dialog_notice"

				OpenOKDialogFromData( dialogData )
			}
			ShowPlayerProfileCardForUID( file.reportPlayerUID )
		}
	#else
		CloseActiveMenu( true, true )
		ShowPlayerProfileCardForUID( file.reportPlayerUID )
	#endif
}

array<string> function GetCheatReportReasons()
{
	array<string> prefixes
	array<string> reportReasons = []

	#if(PC_PROG)
		prefixes.append( "report_player_reason_pc_cheat_" )
	#else
		prefixes.append( "report_player_reason_console_cheat_" )
	#endif

	foreach ( playlistVarPrefix in prefixes )
	{
		int numReasons = GetCurrentPlaylistVarInt( playlistVarPrefix + "count", 0 )
		for ( int index = 0; index < numReasons; index++ )
		{
			reportReasons.append( GetCurrentPlaylistVarString( playlistVarPrefix + (index + 1), "#UNAVAILABLE" ) )
		}
	}

	return reportReasons
}

array<string> function GetHarassmentReportReasons()
{
	array<string> prefixes
	array<string> reportReasons = []

	#if(PC_PROG)
		prefixes.append( "report_player_reason_pc_other_" )
	#else
		prefixes.append( "report_player_reason_console_other_" )
	#endif

	foreach ( playlistVarPrefix in prefixes )
	{
		int numReasons = GetCurrentPlaylistVarInt( playlistVarPrefix + "count", 0 )
		for ( int index = 0; index < numReasons; index++ )
		{
			reportReasons.append( GetCurrentPlaylistVarString( playlistVarPrefix + (index + 1), "#UNAVAILABLE" ) )
		}
	}

	return reportReasons
}


void function InitReportReasonPopup( var newMenuArg )
{
	var reportReasonMenu = GetMenu( "ReportPlayerReasonPopup" )
	file.reportReasonMenu = reportReasonMenu

	SetPopup( reportReasonMenu, true )

	file.reportReasonPopup = Hud_GetChild( reportReasonMenu, "ReportReasonPopup" )
	AddMenuEventHandler( reportReasonMenu, eUIEvent.MENU_OPEN, OnOpenReportPlayerDialog )
	AddMenuEventHandler( reportReasonMenu, eUIEvent.MENU_CLOSE, OnCloseReportPlayerDialog )

	file.reportReasonList = Hud_GetChild( file.reportReasonPopup, "ReportReasonList" )

	file.closeButton = Hud_GetChild( reportReasonMenu, "CloseButton" )
	Hud_AddEventHandler( file.closeButton, UIE_CLICK, OnCloseButton_Activate )
}


void function OnCloseButton_Activate( var button )
{
	CloseAllToTargetMenu( file.menu )
	Hud_SetSelected( file.reportReasonButton, false )
}

void function OnOpenReportPlayerDialog()
{
	//
	foreach ( button, playlistName in file.buttonToReason )
	{
		Hud_RemoveEventHandler( button, UIE_CLICK, OnReasonButton_Activate )
	}
	file.buttonToReason.clear()
	//

	var ownerButton = file.reportReasonButton

	UIPos ownerPos   = REPLACEHud_GetAbsPos( ownerButton )
	UISize ownerSize = REPLACEHud_GetSize( ownerButton )

	array<string> reasons = file.reasons

	if ( reasons.len() == 0 )
		return

	Hud_Show( file.reportReasonButton )

	Hud_InitGridButtons( file.reportReasonList, reasons.len() )
	var scrollPanel = Hud_GetChild( file.reportReasonList, "ScrollPanel" )
	for ( int i = 0; i < reasons.len(); i++ )
	{
		var button = Hud_GetChild( scrollPanel, ("GridButton" + i) )
		if ( i == 0 )
		{
			int popupHeight = (Hud_GetHeight( button ) * reasons.len())
			Hud_SetPos( file.reportReasonPopup, ownerPos.x, ownerPos.y/**/)
			Hud_SetSize( file.reportReasonPopup, ownerSize.width, popupHeight )
			Hud_SetSize( file.reportReasonList, ownerSize.width, popupHeight )

			if ( GetDpadNavigationActive() )
			{
				Hud_SetFocused( button )
				Hud_SetSelected( button, true )
			}
		}

		ReasonButton_Init( button, reasons[i] )
	}
}


void function OnCloseReportPlayerDialog()
{
	Hud_SetSelected( file.reportReasonButton, false )

	if ( GetDpadNavigationActive() )
		Hud_SetFocused( file.reportReasonButton )
}


void function ReasonButton_Init( var button, string reason )
{
	Assert( Hud_GetWidth( file.reportReasonButton ) == Hud_GetWidth( button ), "" + Hud_GetWidth( file.reportReasonButton ) + " != " + Hud_GetWidth( button ) )

	InitButtonRCP( button )
	var rui = Hud_GetRui( button )

	RuiSetString( rui, "buttonText", Localize( reason ) )

	Hud_AddEventHandler( button, UIE_CLICK, OnReasonButton_Activate )
	file.buttonToReason[button] <- reason
}


void function OnReasonButton_Activate( var button )
{
	file.selectedReportReason = file.buttonToReason[button]
	HudElem_SetRuiArg( file.reportReasonButton, "buttonText", Localize( file.selectedReportReason ) )
	Hud_SetSelected( file.reportReasonButton, false )

	CloseAllToTargetMenu( file.menu )
}
