global function InitSkydiveTrailPanel

struct
{
	var                    panel
	var                    headerRui
	var                    listPanel
	array<ItemFlavor>      skydiveTrailsList

	var   videoRui
	int   videoChannel = -1
	asset currentVideo = $""
} file

void function InitSkydiveTrailPanel( var panel )
{
	file.panel = panel
	file.listPanel = Hud_GetChild( panel, "SkydiveTrailList" )
	file.headerRui = Hud_GetRui( Hud_GetChild( panel, "Header" ) )
	file.videoRui = Hud_GetRui( Hud_GetChild( panel, "Video" ) )

	SetPanelTabTitle( panel, "#FINISHER" )
	RuiSetString( file.headerRui, "title", Localize( "#OWNED" ).toupper() )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, SkydiveTrailPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, SkydiveTrailPanel_OnHide )
	AddPanelEventHandler_FocusChanged( panel, SkydiveTrailPanel_OnFocusChanged )


	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, LEFT, BUTTON_A, false, "#A_BUTTON_SELECT", "", null, CustomizeMenus_IsFocusedItem )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_EQUIP", "#X_BUTTON_EQUIP", null, CustomizeMenus_IsFocusedItemEquippable )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_UNLOCK", "#X_BUTTON_UNLOCK", null, CustomizeMenus_IsFocusedItemLocked )

	file.videoChannel = ReserveVideoChannel()
	RuiSetInt( file.videoRui, "channel", file.videoChannel )
}


void function SkydiveTrailPanel_OnShow( var panel )
{
	AddCallback_OnTopLevelCustomizeContextChanged( panel, SkydiveTrailPanel_Update )
	SkydiveTrailPanel_Update( panel )

	//
}


void function SkydiveTrailPanel_OnHide( var panel )
{
	RemoveCallback_OnTopLevelCustomizeContextChanged( panel, SkydiveTrailPanel_Update )
	SkydiveTrailPanel_Update( panel )
}


void function SkydiveTrailPanel_Update( var panel )
{
	var scrollPanel = Hud_GetChild( file.listPanel, "ScrollPanel" )

	//
	foreach ( int flavIdx, ItemFlavor unused in file.skydiveTrailsList )
	{
		var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
		CustomizeButton_UnmarkForUpdating( button )
	}
	file.skydiveTrailsList.clear()

	StopVideoOnChannel( file.videoChannel )
	file.currentVideo = $""

	//
	if ( IsPanelActive( file.panel ) )
	{
		LoadoutEntry entry   = Loadout_SkydiveTrail()
		file.skydiveTrailsList = GetLoadoutItemsSortedForMenu( entry, SkydiveTrail_GetSortOrdinal )

		Hud_InitGridButtons( file.listPanel, file.skydiveTrailsList.len() )
		foreach ( int flavIdx, ItemFlavor flav in file.skydiveTrailsList )
		{
			var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
			CustomizeButton_UpdateAndMarkForUpdating( button, [entry], flav, PreviewSkydiveTrail, null )
		}

		RuiSetString( file.headerRui, "collected", CustomizeMenus_GetCollectedString( entry, file.skydiveTrailsList, false ) )
	}
}


void function SkydiveTrailPanel_OnFocusChanged( var panel, var oldFocus, var newFocus )
{
	if ( !IsValid( panel ) ) //
		return
	if ( GetParentMenu( panel ) != GetActiveMenu() )
		return

	UpdateFooterOptions()
}


void function PreviewSkydiveTrail( ItemFlavor flav )
{
	asset desiredVideo = SkydiveTrail_GetVideo( flav )

	if ( file.currentVideo != desiredVideo ) //
	{
		file.currentVideo = desiredVideo
		StartVideoOnChannel( file.videoChannel, desiredVideo, true, 0.0 )
	}
}


