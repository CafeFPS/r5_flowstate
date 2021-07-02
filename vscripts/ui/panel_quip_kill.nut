global function InitKillQuipsPanel

struct
{
	var                    panel
	var                    listPanel
	array<ItemFlavor>      quipList

	string lastSoundPlayed
} file


void function InitKillQuipsPanel( var panel )
{
	file.panel = panel
	file.listPanel = Hud_GetChild( panel, "QuipList" )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, KillQuipsPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, KillQuipsPanel_OnHide )
	AddPanelEventHandler_FocusChanged( panel, KillQuipsPanel_OnFocusChanged )

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


void function KillQuipsPanel_OnShow( var panel )
{
	AddCallback_OnTopLevelCustomizeContextChanged( panel, KillQuipsPanel_Update )
	KillQuipsPanel_Update( panel )
}


void function KillQuipsPanel_OnHide( var panel )
{
	RemoveCallback_OnTopLevelCustomizeContextChanged( panel, KillQuipsPanel_Update )
	KillQuipsPanel_Update( panel )
	var scrollPanel = Hud_GetChild( file.listPanel, "ScrollPanel" )
	Hud_SetSelected( Hud_GetChild( scrollPanel, "GridButton0" ), true )
}


void function KillQuipsPanel_Update( var panel )
{
	var scrollPanel = Hud_GetChild( file.listPanel, "ScrollPanel" )

	// cleanup
	foreach ( int flavIdx, ItemFlavor unused in file.quipList )
	{
		var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
		CustomizeButton_UnmarkForUpdating( button )
	}
	file.quipList.clear()

	StopLastPlayedQuip()

	// setup, but only if we're active
	if ( IsPanelActive( file.panel ) )
	{
		LoadoutEntry entry = Loadout_CharacterKillQuip( GetTopLevelCustomizeContext() )
		file.quipList = GetLoadoutItemsSortedForMenu( entry, CharacterIntroQuip_GetSortOrdinal )

		Hud_InitGridButtons( file.listPanel, file.quipList.len() )
		foreach ( int flavIdx, ItemFlavor flav in file.quipList )
		{
			var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
			CustomizeButton_UpdateAndMarkForUpdating( button, [entry], flav, PreviewQuip, CanEquipCanBuyCharacterItemCheck )
		}
	}
}


void function KillQuipsPanel_OnFocusChanged( var panel, var oldFocus, var newFocus )
{
	if ( !IsValid( panel ) ) // uiscript_reset
		return
	if ( GetParentMenu( panel ) != GetActiveMenu() )
		return

	UpdateFooterOptions()
}


void function PreviewQuip( ItemFlavor flav )
{
	printt( ItemFlavor_GetHumanReadableRef( flav ) )

	StopLastPlayedQuip()

	string quipAlias = CharacterKillQuip_GetVictimVoiceSoundEvent( flav )
	if ( quipAlias != "" )
	{
		EmitUISound( quipAlias )
		file.lastSoundPlayed = quipAlias
	}
}


void function StopLastPlayedQuip()
{
	if ( file.lastSoundPlayed != "" )
		StopUISoundByName( file.lastSoundPlayed )
}


