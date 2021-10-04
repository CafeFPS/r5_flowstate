global function InitSquadPanel
global function ClientCallback_SetStartTimeForRui
global function ClientCallback_UpdatePlayerOverlayButton

global function RegisterButtonForUID
global function AssignUIDToButton
global function GetUIDForButton

struct SquadPanelData
{
	var panel
	table<var,bool> cardsInitialized
	array<var> gCards
}

struct
{
	table<var,SquadPanelData> squadPanels
	table<var,string> buttonToUID
} file


void function InitSquadPanel( var panel )
{
	SquadPanelData data
	data.gCards.append( Hud_GetChild( panel, "GCard0" ) )
	data.gCards.append( Hud_GetChild( panel, "GCard1" ) )
	data.gCards.append( Hud_GetChild( panel, "GCard2" ) )
	data.panel = panel
	foreach ( elem in data.gCards )
		data.cardsInitialized[ elem ] <- false

	file.squadPanels[ panel ] <- data

	int i
	foreach ( elem in file.squadPanels[ panel ].gCards )
	{
		var button
		if ( i > 0 )
		{
			{
				button = Hud_GetChild( panel, "TeammateMute"+i )
				AddButtonEventHandler( button, UIE_CLICK, OnMuteButtonClick )
				RuiSetImage( Hud_GetRui( button ), "unmuteIcon", $"rui/menu/lobby/icon_voicechat" )
				RuiSetImage( Hud_GetRui( button ), "muteIcon", $"rui/menu/lobby/icon_voicechat_muted" )
				ToolTipData d1
				d1.tooltipFlags = d1.tooltipFlags | eToolTipFlag.CLIENT_UPDATE
				d1.tooltipStyle = eTooltipStyle.DEFAULT
				Hud_SetToolTipData( button, d1 )
			}

			{
				button = Hud_GetChild( panel, "TeammateMutePing"+i )
				AddButtonEventHandler( button, UIE_CLICK, OnMutePingButtonClick )
				RuiSetImage( Hud_GetRui( button ), "unmuteIcon", $"rui/menu/lobby/icon_ping" )
				RuiSetImage( Hud_GetRui( button ), "muteIcon", $"rui/menu/lobby/icon_ping_muted" )
				ToolTipData d2
				d2.tooltipFlags = d2.tooltipFlags | eToolTipFlag.CLIENT_UPDATE
				d2.tooltipStyle = eTooltipStyle.DEFAULT
				Hud_SetToolTipData( button, d2 )
			}

			{
				button = Hud_GetChild( panel, "TeammateMuteChat"+i )
				AddButtonEventHandler( button, UIE_CLICK, OnMuteChatButtonClick )
				RuiSetImage( Hud_GetRui( button ), "unmuteIcon", $"rui/menu/lobby/icon_textchat" )
				RuiSetImage( Hud_GetRui( button ), "muteIcon", $"rui/menu/lobby/icon_textchat_muted" )
				ToolTipData d3
				d3.tooltipFlags = d3.tooltipFlags | eToolTipFlag.CLIENT_UPDATE
				d3.tooltipStyle = eTooltipStyle.DEFAULT
				Hud_SetToolTipData( button, d3 )
			}

			{
				button = Hud_GetChild( panel, "TeammateInvite"+i )
				AddButtonEventHandler( button, UIE_CLICK, OnInviteButtonClick )
				ToolTipData d4
				d4.tooltipFlags = d4.tooltipFlags | eToolTipFlag.CLIENT_UPDATE
				d4.tooltipStyle = eTooltipStyle.DEFAULT
				Hud_SetToolTipData( button, d4 )
			}

			{
				button = Hud_GetChild( panel, "TeammateReport"+i )
				AddButtonEventHandler( button, UIE_CLICK, OnReportButtonClick )
				RuiSetImage( Hud_GetRui( button ), "unmuteIcon", $"rui/menu/lobby/icon_report" )
				RuiSetImage( Hud_GetRui( button ), "muteIcon", $"rui/menu/lobby/icon_report" )
				ToolTipData d5
				d5.tooltipFlags = d5.tooltipFlags | eToolTipFlag.CLIENT_UPDATE
				d5.tooltipStyle = eTooltipStyle.DEFAULT
				Hud_SetToolTipData( button, d5 )
			}

			{
				button = Hud_GetChild( panel, "GCardOverlay"+i )

				RegisterButtonForUID( button )
			}
		}
		i++
	}

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, OnShowSquad )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, OnHideSquad )

	if ( !( uiGlobal.uiShutdownCallbacks.contains(SquadPanel_Shutdown) ) )
		AddUICallback_UIShutdown( SquadPanel_Shutdown )
}

void function SquadPanel_Shutdown()
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

void function OnShowSquad( var panel )
{
	SurvivalInventory_SetBGVisible( true )

	int i
	foreach ( elem in file.squadPanels[ panel ].gCards )
	{
		var muteButton
		var mutePingButton
		var muteChatButton
		var inviteButton
		var reportButton
		var overlayButton
		var disconnectedElem

		if ( i > 0 )
		{
			muteButton = Hud_GetChild( panel, "TeammateMute"+i )
			mutePingButton = Hud_GetChild( panel, "TeammateMutePing"+i )
			muteChatButton = Hud_GetChild( panel, "TeammateMuteChat"+i )
			inviteButton = Hud_GetChild( panel, "TeammateInvite"+i )
			reportButton = Hud_GetChild( panel, "TeammateReport"+i )
			overlayButton = Hud_GetChild( panel, "GCardOverlay"+i )
			disconnectedElem = Hud_GetChild( panel, "TeammateDisconnected"+i )

			Hud_ClearToolTipData( overlayButton )
		}

		RunClientScript( "UICallback_PopulateClientGladCard", panel, elem, muteButton, mutePingButton, muteChatButton, reportButton, null, overlayButton, disconnectedElem, i, Time(), eGladCardPresentation.FULL_BOX )
		RunClientScript( "UICallback_UpdateGladCardVisibility", panel, elem, i )
		file.squadPanels[panel].cardsInitialized[elem] = true

		i++
	}
}

void function ClientCallback_UpdatePlayerOverlayButton( var panel, var overlayButton, string name, string uid, string hardware, int buttonIndex )
{
	AssignUIDToButton( overlayButton, uid )

	if ( uid == "" || hardware == "" )
	{
		Hud_Hide( overlayButton )
		return
	}
	else
	{
		Hud_Show( overlayButton )
	}


	bool canAddFriend = CanSendFriendRequest( GetUIPlayer() )
	bool canInviteParty = CanInviteSquadMate( uid ) && CanInviteToparty() == 0

	if ( canAddFriend )
	{
		CommunityFriends friends = GetFriendInfo()
		foreach ( id in friends.ids )
		{
			if ( uid == id )
			{
				canAddFriend = false
				break
			}
		}
	}

	if ( canInviteParty )
	{

		Party myParty = GetParty()
		foreach ( p in myParty.members )
		{
			if ( p.uid == uid )
			{
				canInviteParty = false
				break
			}
		}
	}

	if ( canInviteParty || canAddFriend )
	{
		ToolTipData td
		td.tooltipStyle = eTooltipStyle.DEFAULT
		td.titleText = ""
		td.descText = name
		td.actionHint2 = canInviteParty ? "#CLICK_INVITE_PARTY" : ""
		td.actionHint1 = canAddFriend ? "#RCLICK_INVITE_FRIEND" : ""
		Hud_SetToolTipData( overlayButton, td )
	}
}

void function OnHideSquad( var panel )
{
	foreach ( elem in file.squadPanels[ panel ].gCards )
	{
		if ( file.squadPanels[panel].cardsInitialized[elem] )
		{
			RunClientScript( "UICallback_DestroyClientGladCardData", elem )
			file.squadPanels[panel].cardsInitialized[elem] = false
		}
	}

}

void function ClientCallback_SetStartTimeForRui( var elem, float delay )
{
	var rui = Hud_GetRui( elem )
	RuiSetGameTime( rui, "startTime", Time() + delay )
}

void function OnOverlayClick( var button )
{
	string uid = GetUIDForButton( button )

	if ( uid == "" )
		return

	bool canInviteParty = CanInviteSquadMate( uid ) && CanInviteToparty() == 0

	if ( canInviteParty )
	{
		Party myParty = GetParty()
		foreach ( p in myParty.members )
		{
			if ( p.uid == uid )
			{
				canInviteParty = false
				break
			}
		}
	}

	if ( !canInviteParty )
		return

	ToolTipData td = Hud_GetToolTipData( button )
	td.actionHint2 = "#STATUS_PARTY_REQUEST_SENT"

	DoInviteToParty( [ uid ] )
}

void function OnOverlayClickRight( var button )
{
	string uid = GetUIDForButton( button )

	if ( uid == "" )
		return

	bool canAddFriend = CanSendFriendRequest( GetUIPlayer() )

	if ( canAddFriend )
	{
		CommunityFriends friends = GetFriendInfo()
		foreach ( id in friends.ids )
		{
			if ( uid == id )
			{
				canAddFriend = false
				break
			}
		}
	}

	if ( !canAddFriend )
		return

	ToolTipData td = Hud_GetToolTipData( button )
	td.actionHint1 = "#STATUS_FRIEND_REQUEST_SENT"

	EmitUISound( "UI_Menu_InviteFriend_Send" )
	DoInviteToBeFriend( uid )
}

void function RegisterButtonForUID( var button )
{
	AddButtonEventHandler( button, UIE_CLICK, OnOverlayClick )
	AddButtonEventHandler( button, UIE_CLICKRIGHT, OnOverlayClickRight )
	ToolTipData td
	td.tooltipFlags = td.tooltipFlags | eToolTipFlag.CLIENT_UPDATE
	td.tooltipStyle = eTooltipStyle.DEFAULT
	Hud_SetToolTipData( button, td )

	file.buttonToUID[ button ] <- ""
}

void function AssignUIDToButton( var button, string uid )
{
 	file.buttonToUID[ button ] = uid
}

string function GetUIDForButton( var button )
{
	return file.buttonToUID[ button ]
}