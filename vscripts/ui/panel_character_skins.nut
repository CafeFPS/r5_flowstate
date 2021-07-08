global function InitCharacterSkinsPanel

//global function PROTO_TogglePIPThumbnails

struct
{
	var               panel
	var               headerRui
	var               listPanel
	array<ItemFlavor> characterSkinList
	var heirloomButton
} file

void function InitCharacterSkinsPanel( var panel )
{
	file.panel = panel
	file.listPanel = Hud_GetChild( panel, "CharacterSkinList" )
	file.headerRui = Hud_GetRui( Hud_GetChild( panel, "Header" ) )

	SetPanelTabTitle( panel, "#SKINS" )
	RuiSetString( file.headerRui, "title", Localize( "#OWNED" ).toupper() )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, CharacterSkinsPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, CharacterSkinsPanel_OnHide )
	AddPanelEventHandler_FocusChanged( panel, CharacterSkinsPanel_OnFocusChanged )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, LEFT, BUTTON_A, false, "#A_BUTTON_SELECT", "", null, CustomizeMenus_IsFocusedItem )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_UNLOCK_LEGEND", "#X_BUTTON_UNLOCK_LEGEND", null, CustomizeMenus_IsFocusedItemParentItemLocked )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_EQUIP", "#X_BUTTON_EQUIP", null, CustomizeMenus_IsFocusedItemEquippable )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_UNLOCK", "#X_BUTTON_UNLOCK", null, CustomizeMenus_IsFocusedItemLocked )
	AddPanelFooterOption( panel, LEFT, BUTTON_STICK_LEFT, false, "#MENU_ZOOM_CONTROLS_GAMEPAD", "#MENU_ZOOM_CONTROLS" )
	//AddPanelFooterOption( panel, LEFT, BUTTON_DPAD_LEFT, false, "#TRIGGERS_CHANGE_LEGEND", "", CustomizeCharacterMenu_PrevButton_OnActivate )
	//AddPanelFooterOption( panel, LEFT, BUTTON_DPAD_RIGHT, false, "", "", CustomizeCharacterMenu_NextButton_OnActivate )
	//AddPanelFooterOption( panel, LEFT, BUTTON_TRIGGER_LEFT, false, "", "", CustomizeCharacterMenu_PrevButton_OnActivate )
	//AddPanelFooterOption( panel, LEFT, BUTTON_TRIGGER_RIGHT, false, "", "", CustomizeCharacterMenu_NextButton_OnActivate )

	file.heirloomButton = Hud_GetChild( panel, "EquipHeirloomButton" )
	HudElem_SetRuiArg( file.heirloomButton, "bigText", "" )
	HudElem_SetRuiArg( file.heirloomButton, "buttonText", "" )
	HudElem_SetRuiArg( file.heirloomButton, "descText", "" )
	Hud_AddEventHandler( file.heirloomButton, UIE_CLICK, CustomizeCharacterMenu_HeirloomButton_OnActivate )
	//RegisterSignal( "PROTO_StopButtonThumbnailsThink" )
}


void function CharacterSkinsPanel_OnShow( var panel )
{
	UI_SetPresentationType( ePresentationType.CHARACTER_SKIN )

	AddCallback_OnTopLevelCustomizeContextChanged( panel, CharacterSkinsPanel_Update )
	RunClientScript( "EnableModelTurn" )
	thread TrackIsOverScrollBar( file.listPanel )
	CharacterSkinsPanel_Update( panel )

	//
	AddCallback_ItemFlavorLoadoutSlotDidChange_SpecificPlayer( LocalClientEHI(), Loadout_MeleeSkin( GetTopLevelCustomizeContext() ), OnMeleeSkinChanged )
	CustomizeCharacterMenu_UpdateHeirloomButton()
}


void function CharacterSkinsPanel_OnHide( var panel )
{
	RemoveCallback_OnTopLevelCustomizeContextChanged( panel, CharacterSkinsPanel_Update )
	Signal( uiGlobal.signalDummy, "TrackIsOverScrollBar" )
	RunClientScript( "EnableModelTurn" )
	CharacterSkinsPanel_Update( panel )

	//Signal( panel, "PROTO_StopButtonThumbnailsThink" )
	RemoveCallback_ItemFlavorLoadoutSlotDidChange_SpecificPlayer( LocalClientEHI(), Loadout_MeleeSkin( GetTopLevelCustomizeContext() ), OnMeleeSkinChanged )
}


void function CharacterSkinsPanel_Update( var panel )
{
	var scrollPanel = Hud_GetChild( file.listPanel, "ScrollPanel" )

	// cleanup
	foreach ( int flavIdx, ItemFlavor unused in file.characterSkinList )
	{
		var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
		CustomizeButton_UnmarkForUpdating( button )
	}
	file.characterSkinList.clear()

	CustomizeMenus_SetActionButton( null )

	RunMenuClientFunction( "ClearAllCharacterPreview" )

	// setup, but only if we're active
	if ( IsPanelActive( file.panel ) && IsTopLevelCustomizeContextValid() )
	{
		LoadoutEntry entry = Loadout_CharacterSkin( GetTopLevelCustomizeContext() )
		file.characterSkinList = GetLoadoutItemsSortedForMenu( entry, CharacterSkin_GetSortOrdinal )
		FilterCharacterSkinList( file.characterSkinList )

		Hud_InitGridButtons( file.listPanel, file.characterSkinList.len() )
		foreach ( int flavIdx, ItemFlavor flav in file.characterSkinList )
		{
			var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
			CustomizeButton_UpdateAndMarkForUpdating( button, [entry], flav, PreviewCharacterSkin, CanEquipCanBuyCharacterItemCheck )
		}

		CustomizeMenus_SetActionButton( Hud_GetChild( panel, "ActionButton" ) )

		RuiSetString( file.headerRui, "collected", CustomizeMenus_GetCollectedString( entry, file.characterSkinList , false ) )
	}
}


void function CharacterSkinsPanel_OnFocusChanged( var panel, var oldFocus, var newFocus )
{
	if ( !IsValid( panel ) ) // uiscript_reset
		return
	if ( GetParentMenu( panel ) != GetActiveMenu() )
		return

	UpdateFooterOptions()

	if ( IsControllerModeActive() )
		CustomizeMenus_UpdateActionContext( newFocus )
}


void function PreviewCharacterSkin( ItemFlavor flav )
{
	RunClientScript( "UIToClient_PreviewCharacterSkinFromCharacterSkinPanel", ItemFlavor_GetNetworkIndex_DEPRECATED( flav ), ItemFlavor_GetNetworkIndex_DEPRECATED( GetTopLevelCustomizeContext() ) )
}


//bool doPIPThumbnails = false
//bool isPanelShown = false
//void function PROTO_TogglePIPThumbnails()
//{
//	doPIPThumbnails = !doPIPThumbnails
//}
//
//void function PROTO_ButtonThumbnailsThink( var panel )
//{
//	EndSignal( panel, "PROTO_StopButtonThumbnailsThink" )
//
//	ItemFlavor customizeContext = GetCustomizeContext()
//
//	table<ItemFlavor, bool> activeFlavorSet = {}
//
//	OnThreadEnd( void function() : ( activeFlavorSet ) {
//		foreach( ItemFlavor flav, bool unused in activeFlavorSet )
//			RunClientScript( "UIToClient_PROTO_StopButtonThumbnail", ItemFlavor_GetRef( flav ) )
//	} )
//
//	var scrollPanel = Hud_GetChild( file.listPanel, "ScrollPanel" )
//
//	WaitFrame()
//
//	while ( true )
//	{
//		if ( customizeContext != GetCustomizeContext() )
//		{
//			customizeContext = GetCustomizeContext()
//			foreach( ItemFlavor flav, bool unused in activeFlavorSet )
//				RunClientScript( "UIToClient_PROTO_StopButtonThumbnail", ItemFlavor_GetRef( flav ) )
//			activeFlavorSet.clear()
//		}
//
//		for ( int buttonIndex = 0; buttonIndex < file.characterSkinList.len(); buttonIndex++ )
//		{
//			var button            = Hud_GetChild( scrollPanel, "GridButton" + buttonIndex )
//			ItemFlavor itemFlavor = file.characterSkinList[buttonIndex]
//			bool isActive         = (itemFlavor in activeFlavorSet)
//			bool shouldBeActive   = doPIPThumbnails && Hud_IsVisible( button )
//
//			if ( shouldBeActive )
//			{
//				if ( !isActive )
//				{
//					activeFlavorSet[itemFlavor] <- true
//					RunClientScript( "UIToClient_PROTO_StartButtonThumbnail", button, ItemFlavor_GetRef( itemFlavor ) )
//				}
//			}
//			else if ( isActive )
//			{
//				delete activeFlavorSet[itemFlavor]
//				RunClientScript( "UIToClient_PROTO_StopButtonThumbnail", ItemFlavor_GetRef( itemFlavor ) )
//			}
//		}
//
//		WaitFrame()
//	}
//}

void function OnMeleeSkinChanged( EHI playerEHI, ItemFlavor flavor )
{
	CustomizeCharacterMenu_UpdateHeirloomButton()
}

ItemFlavor ornull function GetMeleeHeirloom( ItemFlavor character )
{
	LoadoutEntry entry = Loadout_MeleeSkin( GetTopLevelCustomizeContext() )
	array<ItemFlavor> melees = GetValidItemFlavorsForLoadoutSlot( LocalClientEHI(), entry )

	foreach ( meleeFlav in melees )
	{
		if ( ItemFlavor_GetQuality( meleeFlav ) == eQuality.HEIRLOOM )
		{
			return meleeFlav
		}
	}

	return null
}

void function CustomizeCharacterMenu_UpdateHeirloomButton()
{
	LoadoutEntry entry = Loadout_MeleeSkin( GetTopLevelCustomizeContext() )
	ItemFlavor ornull meleeHeirloom = GetMeleeHeirloom( GetTopLevelCustomizeContext() )
	if ( meleeHeirloom != null )
	{
		expect ItemFlavor( meleeHeirloom )

		Hud_Show( file.heirloomButton )

		bool isEquipped = (LoadoutSlot_GetItemFlavor( LocalClientEHI(), entry ) == meleeHeirloom)
		bool isEquippable = IsItemFlavorUnlockedForLoadoutSlot( LocalClientEHI(), entry, meleeHeirloom )
		string meleeName = ItemFlavor_GetLongName( meleeHeirloom )

		Hud_SetLocked( file.heirloomButton, !isEquippable )
		Hud_ClearToolTipData( file.heirloomButton )

		HudElem_SetRuiArg( file.heirloomButton, "buttonText", Localize( meleeName ) )
		if ( !isEquippable )
		{
			HudElem_SetRuiArg( file.heirloomButton, "descText", Localize( "#MENU_ITEM_LOCKED" ) )
			HudElem_SetRuiArg( file.heirloomButton, "bigText", "`1%$rui/menu/store/reqs_locked%" )
			Hud_Hide( file.heirloomButton )
		}
		else if ( isEquipped )
		{
			HudElem_SetRuiArg( file.heirloomButton, "descText", Localize( "#EQUIPPED_LOOT_REWARD" ) )
			HudElem_SetRuiArg( file.heirloomButton, "bigText", "`1%$rui/hud/check_selected%" )
		}
		else
		{
			HudElem_SetRuiArg( file.heirloomButton, "descText", Localize( "#EQUIP_LOOT_REWARD" ) )
			HudElem_SetRuiArg( file.heirloomButton, "bigText", "`1%$rui/borders/key_border%" )
		}
	}
	else
	{
		Hud_Hide( file.heirloomButton )
	}
}

void function CustomizeCharacterMenu_HeirloomButton_OnActivate( var button )
{
	if ( Hud_IsLocked( button ) )
		return

	LoadoutEntry entry = Loadout_MeleeSkin( GetTopLevelCustomizeContext() )
	ItemFlavor ornull meleeHeirloom = GetMeleeHeirloom( GetTopLevelCustomizeContext() )

	if ( meleeHeirloom == null )
		return

	array<ItemFlavor> meleeSkinList = RegisterReferencedItemFlavorsFromArray( GetTopLevelCustomizeContext(), "meleeSkins", "flavor", "featureFlag" )
	Assert( meleeSkinList.len() == 2 )

	ItemFlavor context = GetTopLevelCustomizeContext()
	ItemFlavor meleeToEquip

	foreach ( meleeFlav in meleeSkinList )
	{
		bool isEquipped = (LoadoutSlot_GetItemFlavor( LocalClientEHI(), entry ) == meleeFlav )
		if ( !isEquipped )
		{
			meleeToEquip = meleeFlav
			break
		}
	}

	PIN_Customization( context, meleeToEquip )
	RequestSetItemFlavorLoadoutSlot( LocalClientEHI(), entry, meleeToEquip )
}

void function FilterCharacterSkinList( array<ItemFlavor> characterSkinList )
{
	for ( int i = characterSkinList.len() - 1; i >= 0; i-- )
	{
		if ( !ShouldDisplayCharacterSkin( characterSkinList[i] ) )
			characterSkinList.remove( i )
	}
}

bool function ShouldDisplayCharacterSkin( ItemFlavor characterSkin )
{
	if ( GladiatorCardCharacterSkin_ShouldHideIfLocked( characterSkin ) )
	{
		if ( !IsItemFlavorUnlockedForLoadoutSlot( LocalClientEHI(), Loadout_CharacterClass(), characterSkin ) )
			return false
	}

	return true
}