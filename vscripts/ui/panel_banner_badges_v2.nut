global function InitCardBadgesPanel

struct
{
	var               panel
	var               listPanel
	array<ItemFlavor> cardBadgeList
} file


void function InitCardBadgesPanel( var panel )
{
	file.panel = panel
	file.listPanel = Hud_GetChild( panel, "BadgeList" )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, CardBadgesPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, CardBadgesPanel_OnHide )
	AddPanelEventHandler_FocusChanged( panel, CardBadgesPanel_OnFocusChanged )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	//
	//AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_UNLOCK_LEGEND", "#X_BUTTON_UNLOCK_LEGEND", null, CustomizeMenus_IsFocusedItemParentItemLocked )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_EQUIP", "#X_BUTTON_EQUIP", null, CustomizeMenus_IsFocusedItemEquippable )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_CLEAR", "#X_BUTTON_CLEAR", null, bool function () : ()
	{
		return ( CustomizeMenus_IsFocusedItemUnlocked() && !CustomizeMenus_IsFocusedItemEquippable() )
	} )
	//AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_UNLOCK", "#X_BUTTON_UNLOCK", null, CustomizeMenus_IsFocusedItemLocked )
	//
	//
	//
	//

	RegisterSignal( "StopCycleBadgePreviewImageThread" )
}


void function CardBadgesPanel_OnShow( var panel )
{
	CardBadgesPanel_Update( panel )
}


void function CardBadgesPanel_OnHide( var panel )
{
	CardBadgesPanel_Update( panel )
}


void function CardBadgesPanel_Update( var panel )
{
	var scrollPanel = Hud_GetChild( file.listPanel, "ScrollPanel" )

	//
	foreach ( int flavIdx, ItemFlavor unused in file.cardBadgeList )
	{
		var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
		CustomizeButton_UnmarkForUpdating( button )
	}
	file.cardBadgeList.clear()

	for ( int badgeIndex = 0; badgeIndex < GLADIATOR_CARDS_NUM_BADGES; badgeIndex++ )
		SendMenuGladCardPreviewCommand( eGladCardPreviewCommandType.BADGE, badgeIndex, null )

	//
	if ( IsPanelActive( file.panel ) )
	{
		ItemFlavor character = GetTopLevelCustomizeContext()
		int badgeIndex       = 0 //

		array<LoadoutEntry> entries
		LoadoutEntry entry
		for ( int i=0; i<GLADIATOR_CARDS_NUM_BADGES; i++ )
		{
			entry   = Loadout_GladiatorCardBadge( character, i )
			entries.append( entry )
		}

		file.cardBadgeList = clone GetValidItemFlavorsForLoadoutSlot( LocalClientEHI(), entry )
		SortBadgesAndFilter( character, file.cardBadgeList )

		Hud_InitGridButtons( file.listPanel, file.cardBadgeList.len() )
		foreach ( int flavIdx, ItemFlavor flav in file.cardBadgeList )
		{
			var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
			CustomizeButton_UpdateAndMarkForUpdating( button, entries, flav, PreviewCardBadge, CanEquipCanBuyBadgeCheck )

			var rui = Hud_GetRui( button )
			RuiDestroyNestedIfAlive( rui, "badge" )
			CreateNestedGladiatorCardBadge( rui, "badge", LocalClientEHI(), flav, badgeIndex, character )
			//

			ToolTipData toolTipData
			toolTipData.titleText = Localize( ItemFlavor_GetLongName( flav ) )
			array<GladCardBadgeTierData> tierDataList = GladiatorCardBadge_GetTierDataList( flav )
			string badgeHint                          = GladiatorCardBadge_IsCharacterBadge( flav ) ? Localize( "#CHARACTER_BADGE", Localize( ItemFlavor_GetLongName( character ) ) ) : "#ACCOUNT_BADGE"
			if ( tierDataList.len() > 1 )
			{
				int currTierIdx = GetPlayerBadgeDataInteger( LocalClientEHI(), flav, badgeIndex, character )

				string goalStr = ""
				foreach ( int tierIdx, GladCardBadgeTierData tierData in tierDataList )
				{
					if ( tierIdx > 0 )
						goalStr += " | "

					if ( currTierIdx == tierIdx )
						goalStr += "`3"
					goalStr += string(tierData.unlocksAt)
					if ( currTierIdx == tierIdx )
						goalStr += "`2"
				}
				toolTipData.actionHint1 = Localize( "#BADGE_TIER", currTierIdx + 1, tierDataList.len() ) + "`2 - " + goalStr

				toolTipData.actionHint2 = badgeHint

				int displayTierIdx      = maxint( 0, currTierIdx )
				float unlockRequirement = tierDataList[displayTierIdx].unlocksAt
				toolTipData.descText = Localize( ItemFlavor_GetShortDescription( flav ), format( "`2%s`0", string(unlockRequirement) ) )
			}
			else
			{
				if ( tierDataList.len() == 1 && tierDataList[0].unlocksAt > 0 )
				{
					string unlockStatRef = GladiatorCardBadge_GetUnlockStatRef( flav, character )
					if ( IsValidStatEntryRef( unlockStatRef ) )
					{
						StatEntry se = GetStatEntryByRef( unlockStatRef )
						if ( se.type == eStatType.INT || se.type == eStatType.FLOAT )
						{
							bool good     = true
							float currVal = 0
							float goalVal = tierDataList[0].unlocksAt
							if ( se.type == eStatType.INT )
							{
								if ( goalVal == 1 )
									good = false
								else
									currVal = float(GetStat_Int( GetUIPlayer(), se ))
							}
							else if ( se.type == eStatType.FLOAT )
							{
								currVal = GetStat_Float( GetUIPlayer(), se )
							}
							if ( good )
								toolTipData.actionHint1 = format( "%s / %s", string(currVal), string(goalVal) )
						}
					}
				}

				//R5Reloaded Temp
				if(ItemFlavor_GetHumanReadableRef(flav) == "gcard_badge_account_dev_badge")
				{
					toolTipData.titleText = "R5Reloaded Badge"
					toolTipData.descText = "Play R5Reloaded"
				}
				else
					toolTipData.descText = Localize( ItemFlavor_GetShortDescription( flav ) )
				//////////////////////////////////////////////////////////////

				//Original Code
				//toolTipData.descText = Localize( ItemFlavor_GetShortDescription( flav ) )

				toolTipData.actionHint2 = badgeHint
			}
			toolTipData.tooltipFlags = toolTipData.tooltipFlags | eToolTipFlag.INSTANT_FADE_IN
			Hud_SetToolTipData( button, toolTipData )
		}
	}
}


void function CardBadgesPanel_OnFocusChanged( var panel, var oldFocus, var newFocus )
{
	if ( !IsValid( panel ) ) //
		return
	if ( GetParentMenu( panel ) != GetActiveMenu() )
		return

	UpdateFooterOptions()

	if ( IsValid( oldFocus ) && Hud_GetParent( oldFocus ) == Hud_GetChild( file.listPanel, "ScrollPanel" ) )
	{
		Signal( oldFocus, "StopCycleBadgePreviewImageThread" )
	}
	if ( IsValid( newFocus ) && Hud_GetParent( newFocus ) == Hud_GetChild( file.listPanel, "ScrollPanel" ) )
	{
		thread CycleBadgePreviewImageThread( newFocus )
	}
}


void function CycleBadgePreviewImageThread( var button )
{
	EndSignal( button, "StopCycleBadgePreviewImageThread" )

	ItemFlavor badgeFlav                      = CustomizeButton_GetItemFlavor( button )
	array<GladCardBadgeTierData> tierDataList = GladiatorCardBadge_GetTierDataList( badgeFlav )
	if ( tierDataList.len() <= 1 )
		return

	int tierIndex = 0

	OnThreadEnd( void function() : ( button, badgeFlav ) {
		if ( IsValid( button ) )
		{
			int badgeIndex       = GetCardPropertyIndex()
			var rui              = Hud_GetRui( button )
			RuiDestroyNestedIfAlive( rui, "badge" )
			if ( IsTopLevelCustomizeContextValid() )
			{
				ItemFlavor character = GetTopLevelCustomizeContext()
				CreateNestedGladiatorCardBadge( rui, "badge", LocalClientEHI(), badgeFlav, badgeIndex, character, null )
			}
		}
	} )

	while ( IsValid( button ) && Hud_IsFocused( button ) && IsTopLevelCustomizeContextValid() )
	{
		ItemFlavor character = GetTopLevelCustomizeContext()
		var rui              = Hud_GetRui( button )
		RuiDestroyNestedIfAlive( rui, "badge" )
		CreateNestedGladiatorCardBadge( rui, "badge", LocalClientEHI(), badgeFlav, -1, character, tierIndex )

		wait 1.1

		tierIndex++
		if ( tierIndex >= tierDataList.len() )
			tierIndex = 0
	}
}


void function PreviewCardBadge( ItemFlavor flav )
{
	int badgeIndex = GetCardPropertyIndex()
	SendMenuGladCardPreviewCommand( eGladCardPreviewCommandType.BADGE, badgeIndex, flav )
}


int function CanEquipCanBuyBadgeCheck( ItemFlavor unused )
{
	return eItemCanEquipCanBuyStatus.CAN_EQUIP_CAN_BUY

	int status = CanEquipCanBuyCharacterItemCheck( unused )
	if ( status == eItemCanEquipCanBuyStatus.CAN_EQUIP_CAN_BUY )
		return eItemCanEquipCanBuyStatus.CAN_EQUIP_CANNOT_BUY
	return status
}


void function SortBadgesAndFilter( ItemFlavor character, array<ItemFlavor> badgeList )
{
	table<ItemFlavor, int> equippedBadgeSet
	for ( int iterBadgeIndex = 0; iterBadgeIndex < GLADIATOR_CARDS_NUM_BADGES; iterBadgeIndex++ )
	{
		LoadoutEntry badgeSlot = Loadout_GladiatorCardBadge( character, iterBadgeIndex )
		if ( LoadoutSlot_IsReady( LocalClientEHI(), badgeSlot ) )
		{
			ItemFlavor badge = LoadoutSlot_GetItemFlavor( LocalClientEHI(), badgeSlot )
			equippedBadgeSet[badge] <- iterBadgeIndex
		}
	}
	for ( int i = badgeList.len() - 1; i >= 0; i-- )
	{
		if ( !ShouldDisplayBadge( badgeList[i], equippedBadgeSet, character ) )
			badgeList.remove( i )
	}

	badgeList.sort( int function( ItemFlavor a, ItemFlavor b ) : ( equippedBadgeSet ) {
		bool a_isEquipped = (a in equippedBadgeSet)
		bool b_isEquipped = (b in equippedBadgeSet)
		if ( a_isEquipped != b_isEquipped )
			return (a_isEquipped ? -1 : 1)

		int aso = GladiatorCardBadge_GetSortOrdinal( a )
		int bso = GladiatorCardBadge_GetSortOrdinal( b )
		return aso - bso
	} )
}


bool function ShouldDisplayBadge( ItemFlavor badge, table<ItemFlavor, int> equippedBadgeSet, ItemFlavor character )
{
	/*if ( GladiatorCardBadge_ShouldHideIfLocked( badge ) )
	{
		if ( !IsItemFlavorUnlockedForLoadoutSlot( LocalClientEHI(), Loadout_GladiatorCardBadge( character, 0 ), badge ) )//
			return false
	}

	if ( GladiatorCardBadge_IsTheEmpty( badge ) )
		return false*/

	return true
}