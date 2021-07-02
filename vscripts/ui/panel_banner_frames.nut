global function InitCardFramesPanel

struct
{
	var                    panel
	var                    listPanel
	array<ItemFlavor>      cardFrameList
} file


void function InitCardFramesPanel( var panel )
{
	file.panel = panel
	file.listPanel = Hud_GetChild( panel, "FrameList" )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, CardFramesPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, CardFramesPanel_OnHide )
	AddPanelEventHandler_FocusChanged( panel, CardFramesPanel_OnFocusChanged )

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


void function CardFramesPanel_OnShow( var panel )
{
	AddCallback_OnTopLevelCustomizeContextChanged( panel, CardFramesPanel_Update )
	CardFramesPanel_Update( panel )
}


void function CardFramesPanel_OnHide( var panel )
{
	RemoveCallback_OnTopLevelCustomizeContextChanged( panel, CardFramesPanel_Update )
	CardFramesPanel_Update( panel )
	var scrollPanel = Hud_GetChild( file.listPanel, "ScrollPanel" )
	Hud_SetSelected( Hud_GetChild( scrollPanel, "GridButton0" ), true )
}


void function CardFramesPanel_Update( var panel )
{
	var scrollPanel = Hud_GetChild( file.listPanel, "ScrollPanel" )

	// cleanup
	foreach ( int flavIdx, ItemFlavor unused in file.cardFrameList )
	{
		var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
		CustomizeButton_UnmarkForUpdating( button )
	}
	file.cardFrameList.clear()

	SendMenuGladCardPreviewCommand( eGladCardPreviewCommandType.FRAME, -1, null )

	// setup, but only if we're active
	if ( IsPanelActive( file.panel ) )
	{
		LoadoutEntry entry = Loadout_GladiatorCardFrame( GetTopLevelCustomizeContext() )
		file.cardFrameList = GetLoadoutItemsSortedForMenu( entry, GladiatorCardFrame_GetSortOrdinal )
		FilterFrameList( file.cardFrameList )

		Hud_InitGridButtons( file.listPanel, file.cardFrameList.len() )
		foreach ( int flavIdx, ItemFlavor flav in file.cardFrameList )
		{
			var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
			CustomizeButton_UpdateAndMarkForUpdating( button, [entry], flav, PreviewCardFrame, CanEquipCanBuyCharacterItemCheck )
		}
	}
}


void function CardFramesPanel_OnFocusChanged( var panel, var oldFocus, var newFocus )
{
	if ( !IsValid( panel ) ) // uiscript_reset
		return
	if ( GetParentMenu( panel ) != GetActiveMenu() )
		return

	UpdateFooterOptions()
}


void function PreviewCardFrame( ItemFlavor flav )
{
	SendMenuGladCardPreviewCommand( eGladCardPreviewCommandType.FRAME, 0, flav )
}

void function FilterFrameList( array<ItemFlavor> frameList )
{
	for ( int i = frameList.len() - 1; i >= 0; i-- )
	{
		if ( !ShouldDisplayFrame( frameList[i] ) )
			frameList.remove( i )
	}
}

bool function ShouldDisplayFrame( ItemFlavor frame )
{
	if ( GladiatorCardFrame_ShouldHideIfLocked( frame ) )
	{
		if ( !IsItemFlavorUnlockedForLoadoutSlot( LocalClientEHI(), Loadout_CharacterClass(), frame ) )
			return false
	}

	return true
}