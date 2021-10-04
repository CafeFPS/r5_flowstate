global function InitStatsSummaryPanel

struct
{
	var panel
} file

void function InitStatsSummaryPanel( var panel )
{
	//
	//
	//
	//
	//
	//
	SetPanelTabTitle( panel, "#STATS_MENU_TAB_SUMMARY" )
	//
	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, StatsSummaryPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, StatsSummaryPanel_OnHide )
	//
	//
	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
}


void function StatsSummaryPanel_OnShow( var panel )
{
	//
}

void function StatsSummaryPanel_OnHide( var panel )
{
	//
}

void function StatsSummaryPanel_Update( var panel )
{

}

void function StatsSummaryPanel_OnFocusChanged( var panel, var oldFocus, var newFocus )
{
	printf( "StatCardDebug: Summary Panel OnFocusChanged" )

	if ( !IsValid( panel ) ) //
		return
	if ( GetParentMenu( panel ) != GetActiveMenu() )
		return

	UpdateFooterOptions()

	if ( IsControllerModeActive() )
		CustomizeMenus_UpdateActionContext( newFocus )
}
