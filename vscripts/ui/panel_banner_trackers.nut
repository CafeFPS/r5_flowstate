/*
global function InitCardTrackersPanel

struct
{
	var                    panel
	var                    listPanel
	array<ItemFlavor>      cardTrackerList
} file


void function InitCardTrackersPanel( var panel )
{
	file.panel = panel
	file.listPanel = Hud_GetChild( panel, "TrackerList" )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, CardTrackersPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, CardTrackersPanel_OnHide )
	AddPanelEventHandler_FocusChanged( panel, CardTrackersPanel_OnFocusChanged )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, LEFT, BUTTON_A, false, "#A_BUTTON_SELECT", "", null, CustomizeMenus_IsFocusedItem )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_UNLOCK_LEGEND", "#X_BUTTON_UNLOCK_LEGEND", null, CustomizeMenus_IsFocusedItemParentItemLocked )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_EQUIP", "#X_BUTTON_EQUIP", null, CustomizeMenus_IsFocusedItemEquippable )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_UNLOCK", "#X_BUTTON_UNLOCK", null, CustomizeMenus_IsFocusedItemLocked )
	//AddPanelFooterOption( panel, LEFT, BUTTON_DPAD_LEFT, false, "#TRIGGERS_CHANGE_LEGEND", "", CustomizeCharacterMenu_PrevButton_OnActivate )
	//AddPanelFooterOption( panel, LEFT, BUTTON_DPAD_RIGHT, false, "", "", CustomizeCharacterMenu_NextButton_OnActivate )
	//AddPanelFooterOption( panel, LEFT, BUTTON_TRIGGER_LEFT, false, "", "", CustomizeCharacterMenu_PrevButton_OnActivate )
	//AddPanelFooterOption( panel, LEFT, BUTTON_TRIGGER_RIGHT, false, "", "", CustomizeCharacterMenu_NextButton_OnActivate )
}


void function CardTrackersPanel_OnShow( var panel )
{
	AddCallback_OnTopLevelCustomizeContextChanged( panel, CardTrackersPanel_Update )
	CardTrackersPanel_Update( panel )
}


void function CardTrackersPanel_OnHide( var panel )
{
	RemoveCallback_OnTopLevelCustomizeContextChanged( panel, CardTrackersPanel_Update )
	CardTrackersPanel_Update( panel )
	var scrollPanel = Hud_GetChild( file.listPanel, "ScrollPanel" )
	Hud_SetSelected( Hud_GetChild( scrollPanel, "GridButton0" ), true )
}


void function CardTrackersPanel_Update( var panel )
{
	var scrollPanel = Hud_GetChild( file.listPanel, "ScrollPanel" )

	// cleanup
	foreach ( int flavIdx, ItemFlavor unused in file.cardTrackerList )
	{
		var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
		CustomizeButton_UnmarkForUpdating( button )
	}
	file.cardTrackerList.clear()

	for ( int trackerIndex = 0; trackerIndex < GLADIATOR_CARDS_NUM_TRACKERS; trackerIndex++ )
		SendMenuGladCardPreviewCommand( eGladCardPreviewCommandType.TRACKER, trackerIndex, null )

	// setup, but only if we're active
	if ( IsPanelActive( file.panel ) )
	{
		ItemFlavor character = GetTopLevelCustomizeContext()
		LoadoutEntry entry   = Loadout_GladiatorCardStatTracker( character, GetCardPropertyIndex() )
		file.cardTrackerList = GetLoadoutItemsSortedForMenu( entry, GladiatorCardStatTracker_GetSortOrdinal )
		SortTrackersAndFilter( character, file.cardTrackerList, GetCardPropertyIndex() )

		Hud_InitGridButtons( file.listPanel, file.cardTrackerList.len() )
		foreach ( int flavIdx, ItemFlavor flav in file.cardTrackerList )
		{
			var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
			CustomizeButton_UpdateAndMarkForUpdating( button, entry, flav, PreviewCardTracker, CanEquipCanBuyCharacterItemCheck, true )

			var rui = Hud_GetRui( button )
			RuiSetString( rui, "trackerValue", GladiatorCardStatTracker_GetFormattedValueText( GetUIPlayer(), character, flav ) )
		}
	}
}


void function CardTrackersPanel_OnFocusChanged( var panel, var oldFocus, var newFocus )
{
	if ( !IsValid( panel ) ) // uiscript_reset
		return
	if ( GetParentMenu( panel ) != GetActiveMenu() )
		return

	UpdateFooterOptions()
}


void function PreviewCardTracker( ItemFlavor flav )
{
	SendMenuGladCardPreviewCommand( eGladCardPreviewCommandType.TRACKER, GetCardPropertyIndex(), flav )
}

void function SortTrackersAndFilter( ItemFlavor character, array<ItemFlavor> trackerList, int trackerIndex )
{
	table<ItemFlavor, int> equippedTrackerSet
	for ( int iterTrackerIndex = 0; iterTrackerIndex < GLADIATOR_CARDS_NUM_TRACKERS; iterTrackerIndex++ )
	{
		LoadoutEntry trackerSlot = Loadout_GladiatorCardStatTracker( character, iterTrackerIndex )
		if ( LoadoutSlot_IsReady( LocalClientEHI(), trackerSlot ) )
		{
			ItemFlavor tracker = LoadoutSlot_GetItemFlavor( LocalClientEHI(), trackerSlot )
			equippedTrackerSet[tracker] <- iterTrackerIndex
		}
	}
	for ( int i = trackerList.len() - 1; i >= 0; i-- )
	{
		if ( !ShouldDisplayTracker( trackerList[i], equippedTrackerSet, trackerIndex, character ) )
			trackerList.remove( i )
	}

	trackerList.sort( int function( ItemFlavor a, ItemFlavor b ) : ( equippedTrackerSet ) {
		bool a_isEquipped = (a in equippedTrackerSet)
		bool b_isEquipped = (b in equippedTrackerSet)
		if ( a_isEquipped != b_isEquipped )
			return (a_isEquipped ? -1 : 1)

		int aso = GladiatorCardStatTracker_GetSortOrdinal( a )
		int bso = GladiatorCardStatTracker_GetSortOrdinal( b )
		return aso - bso
	} )
}

bool function ShouldDisplayTracker( ItemFlavor tracker, table<ItemFlavor, int> equippedTrackerSet, int trackerIndex, ItemFlavor character )
{
	if ( GladiatorCardTracker_IsTheEmpty( tracker ) )
		return true

	LoadoutEntry trackerSlot = Loadout_GladiatorCardStatTracker( character, trackerIndex )
	if ( LoadoutSlot_IsReady( LocalClientEHI(), trackerSlot )  )
	{
		ItemFlavor equippedTracker = LoadoutSlot_GetItemFlavor( LocalClientEHI(), trackerSlot )
		if ( equippedTracker == tracker )
			return true
		if ( tracker in equippedTrackerSet )
			return false
	}

	return true
}
*/