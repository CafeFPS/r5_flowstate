#if(true)

global function InitQuipsPanel

struct
{
	var               panel
	var               listPanel
	array<ItemFlavor> quipList
	string 				lastSoundPlayed
} file


void function InitQuipsPanel( var panel )
{
	file.panel = panel
	file.listPanel = Hud_GetChild( panel, "QuipList" )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, QuipsPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, QuipsPanel_OnHide )
	AddPanelEventHandler_FocusChanged( panel, QuipsPanel_OnFocusChanged )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, LEFT, BUTTON_A, false, "#A_BUTTON_SELECT", "", null, CustomizeMenus_IsFocusedItem )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_UNLOCK_LEGEND", "#X_BUTTON_UNLOCK_LEGEND", null, CustomizeMenus_IsFocusedItemParentItemLocked )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_EQUIP", "#X_BUTTON_EQUIP", null, CustomizeMenus_IsFocusedItemEquippable )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_CLEAR", "#X_BUTTON_CLEAR", null, bool function () : ()
	{
		return ( CustomizeMenus_IsFocusedItemUnlocked() && !CustomizeMenus_IsFocusedItemEquippable() )
	} )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_UNLOCK", "#X_BUTTON_UNLOCK", null, CustomizeMenus_IsFocusedItemLocked )
	//
	//
	//
	//
}


void function QuipsPanel_OnShow( var panel )
{
	AddCallback_OnTopLevelCustomizeContextChanged( panel, QuipsPanel_Update )
	QuipsPanel_Update( panel )
}


void function QuipsPanel_OnHide( var panel )
{
	RemoveCallback_OnTopLevelCustomizeContextChanged( panel, QuipsPanel_Update )
	QuipsPanel_Update( panel )
	if ( file.quipList.len() > 0 )
	{
		var scrollPanel = Hud_GetChild( file.listPanel, "ScrollPanel" )
		Hud_SetSelected( Hud_GetChild( scrollPanel, "GridButton0" ), true )
	}
}


void function QuipsPanel_Update( var panel )
{
	var scrollPanel = Hud_GetChild( file.listPanel, "ScrollPanel" )

	//
	foreach ( int flavIdx, ItemFlavor unused in file.quipList )
	{
		var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
		CustomizeButton_UnmarkForUpdating( button )
	}
	file.quipList.clear()

	StopLastPlayedQuip()

	//
	if ( IsPanelActive( file.panel ) )
	{
		ItemFlavor character = GetTopLevelCustomizeContext()

		array<LoadoutEntry> entries
		LoadoutEntry entry
		for ( int i=0; i<MAX_QUIPS_EQUIPPED; i++ )
		{
			entry   = Loadout_CharacterQuip( character, i )
			entries.append( entry )
		}

		file.quipList = clone GetLoadoutItemsSortedForMenu( entry, ( int function( ItemFlavor a ) : () { return 0 } ) )
		SortQuipsAndFilter( character, file.quipList )

		Hud_InitGridButtons( file.listPanel, file.quipList.len() )
		bool emptyShown = false
		foreach ( int flavIdx, ItemFlavor flav in file.quipList )
		{
			var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
			CustomizeButton_UpdateAndMarkForUpdating( button, entries, flav, PreviewQuip, CanEquipCanBuyCharacterItemCheck )
		}
	}
}


void function QuipsPanel_OnFocusChanged( var panel, var oldFocus, var newFocus )
{
	if ( !IsValid( panel ) ) //
		return
	if ( GetParentMenu( panel ) != GetActiveMenu() )
		return

	UpdateFooterOptions()
}


void function PreviewQuip( ItemFlavor flav )
{
	StopLastPlayedQuip()

	if ( CharacterQuip_IsTheEmpty( flav ) )
		return

	string subAlias = CharacterQuip_GetAliasSubName( flav )

	if ( subAlias != "" )
	{
		ItemFlavor character = GetTopLevelCustomizeContext()
		asset playerSettings = CharacterClass_GetSetFile( character )
		string voice = GetGlobalSettingsString( playerSettings, "voice" )

		string quipAlias = "diag_mp_" + voice + "_" + subAlias + "_1p"
		if ( quipAlias != "" )
		{
			EmitUISound( quipAlias )
			file.lastSoundPlayed = quipAlias
		}
	}

}


void function StopLastPlayedQuip()
{
	if ( file.lastSoundPlayed != "" )
		StopUISoundByName( file.lastSoundPlayed )
}


void function SortQuipsAndFilter( ItemFlavor character, array<ItemFlavor> emoteList )
{
	table<ItemFlavor, int> equippedQuipSet
	for ( int i = 0; i < MAX_QUIPS_EQUIPPED; i++ )
	{
		LoadoutEntry emoteSlot = Loadout_CharacterQuip( character, i )
		if ( LoadoutSlot_IsReady( LocalClientEHI(), emoteSlot ) )
		{
			ItemFlavor quip = LoadoutSlot_GetItemFlavor( LocalClientEHI(), emoteSlot )
			equippedQuipSet[quip] <- i
		}
	}

	bool emptyShown = false
	ItemFlavor firstEmpty

	for ( int i = emoteList.len() - 1; i >= 0; i-- )
	{
		bool isEmpty = CharacterQuip_IsTheEmpty( emoteList[i] )

		if ( isEmpty )
		{
			firstEmpty = emoteList[i]
			emptyShown = true
		}

		if ( isEmpty )
			emoteList.remove( i )
	}

	emoteList.sort( int function( ItemFlavor a, ItemFlavor b ) : ( equippedQuipSet ) {
		bool a_isEquipped = (a in equippedQuipSet)
		bool b_isEquipped = (b in equippedQuipSet)
		if ( a_isEquipped != b_isEquipped )
			return (a_isEquipped ? -1 : 1)

		if ( ItemFlavor_GetType( a ) != ItemFlavor_GetType( b ) )
		{
			int diff = ItemFlavor_GetType( a ) - ItemFlavor_GetType( b )
			return diff / abs( diff )
		}
		else
		{
			int itemType = ItemFlavor_GetType( a )

			int aQuality = ItemFlavor_HasQuality( a ) ? ItemFlavor_GetQuality( a ) : -1
			int bQuality = ItemFlavor_HasQuality( b ) ? ItemFlavor_GetQuality( b ) : -1
			if ( aQuality > bQuality )
				return -1
			else if ( aQuality < bQuality )
				return 1

			return SortStringAlphabetize( Localize( ItemFlavor_GetLongName( a ) ), Localize( ItemFlavor_GetLongName( b ) ) )
		}
		unreachable
	} )
}


bool function ShouldDisplayQuip( ItemFlavor quip, table<ItemFlavor, int> equippedQuipSet, int quipIndex, ItemFlavor character )
{
	if ( CharacterQuip_IsTheEmpty( quip ) )
		return true

	LoadoutEntry emoteSlot = Loadout_CharacterQuip( character, quipIndex )
	if ( LoadoutSlot_IsReady( LocalClientEHI(), emoteSlot ) )
	{
		ItemFlavor equippedQuip = LoadoutSlot_GetItemFlavor( LocalClientEHI(), emoteSlot )
		if ( equippedQuip == quip )
			return true
		if ( quip in equippedQuipSet )
			return false
	}

	return true
}
#endif