global function InitSquadPanel
global function SquadPanel_Shutdown
global function ClientCallback_SetStartTimeForRui

struct SquadPanelData
{
	var panel
	table<var,bool> cardsInitialized
	array<var> gCards
}

struct
{
	table<var,SquadPanelData> squadPanels
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
			button = Hud_GetChild( panel, "TeammateMute"+i )
			AddButtonEventHandler( button, UIE_CLICK, OnMuteButtonClick )
			RuiSetImage( Hud_GetRui( button ), "unmuteIcon", $"rui/menu/lobby/icon_voicechat" )
			RuiSetImage( Hud_GetRui( button ), "muteIcon", $"rui/menu/lobby/icon_voicechat_muted" )
			ToolTipData d1
			d1.tooltipFlags = d1.tooltipFlags | eToolTipFlag.CLIENT_UPDATE
			d1.tooltipStyle = eTooltipStyle.DEFAULT
			Hud_SetToolTipData( button, d1 )

			button = Hud_GetChild( panel, "TeammateMutePing"+i )
			AddButtonEventHandler( button, UIE_CLICK, OnMutePingButtonClick )
			RuiSetImage( Hud_GetRui( button ), "unmuteIcon", $"rui/menu/lobby/icon_ping" )
			RuiSetImage( Hud_GetRui( button ), "muteIcon", $"rui/menu/lobby/icon_ping_muted" )
			ToolTipData d2
			d2.tooltipFlags = d2.tooltipFlags | eToolTipFlag.CLIENT_UPDATE
			d2.tooltipStyle = eTooltipStyle.DEFAULT
			Hud_SetToolTipData( button, d2 )

			button = Hud_GetChild( panel, "TeammateMuteChat"+i )
			AddButtonEventHandler( button, UIE_CLICK, OnMuteChatButtonClick )
			RuiSetImage( Hud_GetRui( button ), "unmuteIcon", $"rui/menu/lobby/icon_textchat" )
			RuiSetImage( Hud_GetRui( button ), "muteIcon", $"rui/menu/lobby/icon_textchat_muted" )
			ToolTipData d3
			d3.tooltipFlags = d3.tooltipFlags | eToolTipFlag.CLIENT_UPDATE
			d3.tooltipStyle = eTooltipStyle.DEFAULT
			Hud_SetToolTipData( button, d3 )
		}
		i++
	}

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, OnShowSquad )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, OnHideSquad )
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

void function OnShowSquad( var panel )
{
	SurvivalInventory_SetBGVisible( true )

	int i
	foreach ( elem in file.squadPanels[ panel ].gCards )
	{
		var muteButton
		var mutePingButton
		var muteChatButton

		if ( i > 0 )
		{
			muteButton = Hud_GetChild( panel, "TeammateMute"+i )
			mutePingButton = Hud_GetChild( panel, "TeammateMutePing"+i )
			muteChatButton = Hud_GetChild( panel, "TeammateMuteChat"+i )
		}

		RunClientScript( "UICallback_PopulateClientGladCard", elem, muteButton, mutePingButton, muteChatButton, i, Time(), eGladCardPresentation.FULL_BOX )
		file.squadPanels[panel].cardsInitialized[elem] = true

		i++
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