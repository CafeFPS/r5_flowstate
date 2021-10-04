global function InitStatsPerformancePanel

struct
{
	var panel
	var topLegendsStatsCard
	var topWeaponsStatsCard
	var graphStatsCard
} file

void function InitStatsPerformancePanel( var panel )
{
	//
	//
	file.panel = panel
	file.topLegendsStatsCard = Hud_GetChild( panel, "TopLegendsStatsCard" )
	file.topWeaponsStatsCard = Hud_GetChild( panel, "TopWeaponsStatsCard" )
	//
	//
	SetPanelTabTitle( panel, "#STATS_MENU_TAB_PERFORMANCE" )
	//
	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, StatsPerformancePanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, StatsPerformancePanel_OnHide )
	//
	//
	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
}


void function StatsPerformancePanel_OnShow( var panel )
{
	//
}

void function StatsPerformancePanel_OnHide( var panel )
{
	//
}

void function StatsPerformancePanel_Update( var panel )
{

}

void function StatsPerformancePanel_OnFocusChanged( var panel, var oldFocus, var newFocus )
{
	printf( "StatCardDebug: Performance Panel OnFocusChanged" )

	if ( !IsValid( panel ) ) //
		return
	if ( GetParentMenu( panel ) != GetActiveMenu() )
		return

	UpdateFooterOptions()

	if ( IsControllerModeActive() )
		CustomizeMenus_UpdateActionContext( newFocus )
}
