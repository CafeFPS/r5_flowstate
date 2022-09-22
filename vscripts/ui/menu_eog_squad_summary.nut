global function InitEOGMenu
global function OpenEOGMenu
global function CloseEOGMenu

struct EOGMenuData
{
	var panel
	table<var,bool> cardsInitialized
	array<var> gCards
}

struct
{
	var menu
	table<var,EOGMenuData> menuData
	array<var> buttons
} file


void function InitEOGMenu( var newMenuArg ) //
{
	var menu = GetMenu( "EOGSquadSummaryMenu" )
	file.menu = menu

	AddUICallback_UIShutdown( EOGMenu_Shutdown )

	EOGMenuData data
	data.gCards.append( Hud_GetChild( menu, "GCard0" ) )
	data.gCards.append( Hud_GetChild( menu, "GCard1" ) )
	data.gCards.append( Hud_GetChild( menu, "GCard2" ) )
	data.panel = menu
	foreach ( elem in data.gCards )
		data.cardsInitialized[ elem ] <- false

	file.menuData[ menu ] <- data

	int i
	foreach ( elem in file.menuData[ menu ].gCards )
	{
		var button
		if ( i > 0 )
		{
			{
				button = Hud_GetChild( menu, "TeammateMute"+i )
				AddButtonEventHandler( button, UIE_CLICK, OnMuteButtonClick )
				RuiSetImage( Hud_GetRui( button ), "unmuteIcon", $"rui/menu/lobby/icon_voicechat" )
				RuiSetImage( Hud_GetRui( button ), "muteIcon", $"rui/menu/lobby/icon_voicechat_muted" )
				ToolTipData d1
				d1.tooltipFlags = d1.tooltipFlags | eToolTipFlag.CLIENT_UPDATE
				d1.tooltipStyle = eTooltipStyle.DEFAULT
				Hud_SetToolTipData( button, d1 )
				file.buttons.append( button )
				AddButtonEventHandler( button, UIE_GET_FOCUS, OnButtonFocus )
				AddButtonEventHandler( button, UIE_LOSE_FOCUS, OnButtonFocus )
			}

			//
			//
			//
			//
			//
			//
			//
			//
			//
			//
			//
			//
			//

			{
				button = Hud_GetChild( menu, "TeammateMuteChat"+i )
				AddButtonEventHandler( button, UIE_CLICK, OnMuteChatButtonClick )
				RuiSetImage( Hud_GetRui( button ), "unmuteIcon", $"rui/menu/lobby/icon_textchat" )
				RuiSetImage( Hud_GetRui( button ), "muteIcon", $"rui/menu/lobby/icon_textchat_muted" )
				ToolTipData d3
				d3.tooltipFlags = d3.tooltipFlags | eToolTipFlag.CLIENT_UPDATE
				d3.tooltipStyle = eTooltipStyle.DEFAULT
				Hud_SetToolTipData( button, d3 )
				file.buttons.append( button )
				AddButtonEventHandler( button, UIE_GET_FOCUS, OnButtonFocus )
				AddButtonEventHandler( button, UIE_LOSE_FOCUS, OnButtonFocus )
			}

			{
				button = Hud_GetChild( menu, "TeammateInvite"+i )
				AddButtonEventHandler( button, UIE_CLICK, OnInviteButtonClick )
				ToolTipData d4
				d4.tooltipFlags = d4.tooltipFlags | eToolTipFlag.CLIENT_UPDATE
				d4.tooltipStyle = eTooltipStyle.DEFAULT
				Hud_SetToolTipData( button, d4 )
				file.buttons.append( button )
				AddButtonEventHandler( button, UIE_GET_FOCUS, OnButtonFocus )
				AddButtonEventHandler( button, UIE_LOSE_FOCUS, OnButtonFocus )
			}

			{
				button = Hud_GetChild( menu, "TeammateReport"+i )
				AddButtonEventHandler( button, UIE_CLICK, OnReportButtonClick )
				RuiSetImage( Hud_GetRui( button ), "unmuteIcon", $"rui/menu/lobby/icon_report" )
				RuiSetImage( Hud_GetRui( button ), "muteIcon", $"rui/menu/lobby/icon_report" )
				ToolTipData d5
				d5.tooltipFlags = d5.tooltipFlags | eToolTipFlag.CLIENT_UPDATE
				d5.tooltipStyle = eTooltipStyle.DEFAULT
				Hud_SetToolTipData( button, d5 )
				file.buttons.append( button )
				AddButtonEventHandler( button, UIE_GET_FOCUS, OnButtonFocus )
				AddButtonEventHandler( button, UIE_LOSE_FOCUS, OnButtonFocus )
			}

			{
				button = Hud_GetChild( menu, "GCardOverlay"+i )
				AddButtonEventHandler( button, UIE_GET_FOCUS, OnButtonFocus )
				AddButtonEventHandler( button, UIE_LOSE_FOCUS, OnButtonFocus )
				file.buttons.append( button )
				RegisterButtonForUID( button )
			}
		}
		i++
	}

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnNavBack )

	AddMenuFooterOption( menu, LEFT, KEY_SPACE, false, "", "", TryReturnToLobby )
	AddMenuFooterOption( menu, LEFT, KEY_TAB, false, "", "", Spectate )
	AddMenuFooterOption( menu, LEFT, BUTTON_A, false, "", "", TrySpectate )

	#if DEVELOPER
		AddMenuFooterOption( menu, LEFT, BUTTON_Y, true, "Dev Menu", "Dev Menu", OpenDevMenu )
	#endif

	#if PC_PROG
		AddMenuFooterOption( menu, RIGHT, KEY_ENTER, false, "", "", UI_OnLoadoutButton_Enter )
	#endif
}

void function UI_OnLoadoutButton_Enter( var button )
{
	var chatbox = Hud_GetChild( file.menu, "LobbyChatBox" )

	if ( !HudChat_HasAnyMessageModeStoppedRecently() )
		Hud_StartMessageMode( chatbox )

	Hud_SetVisible( chatbox, true )
}

void function TryReturnToLobby( var button )
{
	LeaveDialog()
}

void function TrySpectate( var button )
{
	if ( !file.buttons.contains( GetFocus() ) )
		Spectate( button )
}

void function Spectate( var button )
{
	if ( GetActiveMenu() == file.menu )
		CloseActiveMenu()
	else if ( IsMenuInMenuStack( file.menu ) )
		RemoveFromMenuStack( file.menu )
}

void function OpenEOGMenu()
{
	//
	if ( IsDialog( GetActiveMenu() ) )
		CloseActiveMenu( true )

	if ( !IsMenuInMenuStack( file.menu ) )
		AdvanceMenu( file.menu )
}

void function CloseEOGMenu()
{
	if ( GetActiveMenu() == file.menu )
		CloseActiveMenu( true )
	else if ( IsMenuInMenuStack( file.menu ) )
		CloseAllMenus() //
}

void function EOGMenu_Shutdown()
{
	if ( IsFullyConnected() )
		RunClientScript( "UICallback_DestroyAllClientGladCardData" )
}

void function OnMuteButtonClick( var button )
{
	RunClientScript( "UICallback_ToggleMute", button )
}

void function OnMutePingButtonClick( var button )
{
	RunClientScript( "UICallback_ToggleMutePing", button )
}

void function OnMuteChatButtonClick( var button )
{
	RunClientScript( "UICallback_ToggleMuteChat", button )
}

void function OnInviteButtonClick( var button )
{
	if ( Hud_IsSelected( button ) )
		return

	RunClientScript( "UICallback_InviteSquadMate", button )
}

void function OnReportButtonClick( var button )
{
	RunClientScript( "UICallback_ReportSquadMate", button )
}

void function OnOpen()
{
	RunClientScript( "UICallback_SetShowingEOGMenu", true )

	var menu = file.menu

	int i
	foreach ( elem in file.menuData[ menu ].gCards )
	{
		var muteButton
		var mutePingButton
		var muteChatButton
		var inviteButton
		var reportButton
		var overlayButton
		var disconnectedElem
		var statsPanel = Hud_GetChild( menu, "GCardStats" + i )

		RunClientScript( "UICallback_PopulatePlayerStatsRui", statsPanel, i )

		if ( i > 0 )
		{
			muteButton = Hud_GetChild( menu, "TeammateMute"+i )
			//
			muteChatButton = Hud_GetChild( menu, "TeammateMuteChat"+i )
			inviteButton = Hud_GetChild( menu, "TeammateInvite"+i )
			reportButton = Hud_GetChild( menu, "TeammateReport"+i )
			overlayButton = Hud_GetChild( menu, "GCardOverlay"+i )
			//

			Hud_ClearToolTipData( overlayButton )
		}

		RunClientScript( "UICallback_PopulateClientGladCard", menu, elem, muteButton, mutePingButton, muteChatButton, reportButton, null, overlayButton, disconnectedElem, i, Time(), eGladCardPresentation.FRONT_CLEAN )
		RunClientScript( "UICallback_UpdateGladCardVisibility", menu, elem, i )
		RunClientScript( "UICallback_PlayerStatusUpdateThread", menu, statsPanel, muteButton, mutePingButton, muteChatButton, reportButton, inviteButton, null, disconnectedElem, i )

		file.menuData[menu].cardsInitialized[elem] = true

		i++
	}
}

void function OnNavBack()
{
	if ( InputIsButtonDown( KEY_ESCAPE ) )
		OpenSystemMenu()
	else
		LeaveDialog()
}

void function OnClose()
{
	RunClientScript( "UICallback_SetShowingEOGMenu", false )

	var menu = file.menu
	foreach ( elem in file.menuData[ menu ].gCards )
	{
		if ( file.menuData[menu].cardsInitialized[elem] )
		{
			RunClientScript( "UICallback_DestroyClientGladCardData", elem )
			file.menuData[menu].cardsInitialized[elem] = false
		}
	}
}

void function OnButtonFocus( var button )
{
	UpdateFooterOptions()
}

bool function IsNotFocusedOnAButton()
{
	return ( file.buttons.contains( GetFocus() ) )
}