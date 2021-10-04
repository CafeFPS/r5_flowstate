global function InitWeaponSkinsPanel
global function WeaponSkinsPanel_SetWeapon

global function CharmsButton_Reset
global function CharmsMenuEnableOrDisable
global function IsCharmsMenuActive

struct PanelData
{
	var panel
	var weaponNameRui
	var ownedRui
	var listPanel
	var charmsButton

	ItemFlavor ornull weaponOrNull
	array<ItemFlavor> weaponSkinList
	array<ItemFlavor> weaponCharmList
}


struct
{
	table<var, PanelData> panelDataMap

	var         currentPanel = null
	ItemFlavor& currentWeapon
	ItemFlavor& currentWeaponSkin
	bool charmsMenuActive = false
} file


void function InitWeaponSkinsPanel( var panel )
{
	Assert( !(panel in file.panelDataMap) )
	PanelData pd
	file.panelDataMap[ panel ] <- pd

	pd.weaponNameRui = Hud_GetRui( Hud_GetChild( panel, "WeaponName" ) )

	pd.ownedRui = Hud_GetRui( Hud_GetChild( panel, "Owned" ) )
	RuiSetString( pd.ownedRui, "title", Localize( "#SKINS_OWNED" ).toupper() )

	pd.listPanel = Hud_GetChild( panel, "WeaponSkinList" )
	AddUICallback_InputModeChanged( OnInputModeChanged )

	pd.charmsButton = Hud_GetChild( panel, "CharmsButton" )
	Hud_SetVisible( pd.charmsButton, true )
	Hud_SetEnabled( pd.charmsButton, true )
	CharmsButton_Update( pd.charmsButton )
	AddButtonEventHandler( pd.charmsButton, UIE_CLICK, CharmsButton_OnClick )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, WeaponSkinsPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, WeaponSkinsPanel_OnHide )
	AddPanelEventHandler_FocusChanged( panel, WeaponSkinsPanel_OnFocusChanged )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, LEFT, BUTTON_Y, true, "#CONTROLLER_CHARMS_BUTTON", "#CHARMS_BUTTON", CharmsButton_OnRightStickClick, CharmsFooter_IsVisible )
	AddPanelFooterOption( panel, LEFT, BUTTON_Y, true, "#CONTROLLER_SKINS_BUTTON", "#SKINS_BUTTON", CharmsButton_OnRightStickClick, SkinsFooter_IsVisible )
	AddPanelFooterOption( panel, LEFT, BUTTON_A, false, "#A_BUTTON_SELECT", "", null, CustomizeMenus_IsFocusedItem )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_EQUIP", "#X_BUTTON_EQUIP", null, CustomizeMenus_IsFocusedItemEquippable )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_UNLOCK", "#X_BUTTON_UNLOCK", null, CustomizeMenus_IsFocusedItemLocked )
	AddPanelFooterOption( panel, LEFT, BUTTON_TRIGGER_LEFT, false, "#MENU_ZOOM_CONTROLS_GAMEPAD", "#MENU_ZOOM_CONTROLS", null, ZoomFooter_IsVisible )
	//AddPanelFooterOption( panel, LEFT, BUTTON_DPAD_LEFT, false, "#DPAD_LEFT_RIGHT_SWITCH_CHARACTER", "", PrevButton_OnActivate )
	//AddPanelFooterOption( panel, LEFT, BUTTON_DPAD_RIGHT, false, "", "", NextButton_OnActivate )
}


bool function ZoomFooter_IsVisible()
{
	bool result = CharmsFooter_IsVisible()
	return result

	return true
}


bool function SkinsFooter_IsVisible()
{
	return IsCharmsMenuActive()
}

bool function CharmsFooter_IsVisible()
{
	bool result = IsCharmsMenuActive()
	return !result
}

bool function IsCharmsMenuActive()
{
	return file.charmsMenuActive
}

void function CharmsMenuEnableOrDisable()
{
	if ( file.charmsMenuActive )
	{
		UI_SetPresentationType( ePresentationType.WEAPON_SKIN )
		file.charmsMenuActive = false
	}
	else
	{
		UI_SetPresentationType( ePresentationType.WEAPON_CHARMS )
		file.charmsMenuActive = true
	}

	foreach ( var panel, PanelData pd in file.panelDataMap )
	{
		CharmsButton_Update( pd.charmsButton )
	}

	WeaponSkinsPanel_Update( file.currentPanel )
}

void function CharmsButton_Reset()
{
	file.charmsMenuActive = false

	foreach ( var panel, PanelData pd in file.panelDataMap )
	{
		CharmsButton_Update( pd.charmsButton )
	}
}

void function CharmsButton_Update( var button )
{
	string buttonText
	bool controllerActive = IsControllerModeActive()

	if ( file.charmsMenuActive )
		buttonText = controllerActive ? "#CONTROLLER_SKINS_BUTTON" : "#SKINS_BUTTON"
	else
		buttonText = controllerActive ? "#CONTROLLER_CHARMS_BUTTON" : "#CHARMS_BUTTON"

	HudElem_SetRuiArg( button, "centerText", buttonText )
	UpdateFooterOptions()
}


void function CharmsButton_OnRightStickClick( var button )
{
	EmitUISound( "UI_Menu_accept" )
	CharmsButton_OnClick( button )
}

void function CharmsButton_OnClick( var button )
{
	CharmsMenuEnableOrDisable()
}

void function OnInputModeChanged( bool controllerModeActive )
{
	foreach ( var panel, PanelData pd in file.panelDataMap )
		CharmsButton_Update( pd.charmsButton )
}


void function WeaponSkinsPanel_SetWeapon( var panel, ItemFlavor ornull weaponFlavOrNull )
{
	PanelData pd = file.panelDataMap[panel]
	pd.weaponOrNull = weaponFlavOrNull
}


void function WeaponSkinsPanel_OnShow( var panel )
{
	bool charmsActive = file.charmsMenuActive

	if ( !charmsActive )
		RunClientScript( "UIToClient_ResetWeaponRotation" )

	RunClientScript( "EnableModelTurn" )

	file.currentPanel = panel

	// (dw): Customize context is already being used for the category, which is unfortunate.
	//AddCallback_OnTopLevelCustomizeContextChanged( panel, WeaponSkinsPanel_Update )
	//SetCustomizeContext( PanelData_Get( panel ).weapon )

	thread TrackIsOverScrollBar( file.panelDataMap[panel].listPanel )

	WeaponSkinsPanel_Update( panel )
}


void function WeaponSkinsPanel_OnHide( var panel )
{
	//RemoveCallback_OnTopLevelCustomizeContextChanged( panel, WeaponSkinsPanel_Update )
	Signal( uiGlobal.signalDummy, "TrackIsOverScrollBar" )

	RunClientScript( "EnableModelTurn" )
	WeaponSkinsPanel_Update( panel )
}


void function WeaponSkinsPanel_Update( var panel )// TODO: IMPLEMENT
{
	PanelData pd    = file.panelDataMap[panel]
	var scrollPanel = Hud_GetChild( pd.listPanel, "ScrollPanel" )

	// cleanup
	foreach ( int flavIdx, ItemFlavor unused in pd.weaponCharmList )
	{
		var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
		CustomizeButton_UnmarkForUpdating( button )
	}
	pd.weaponCharmList.clear()

	foreach ( int flavIdx, ItemFlavor unused in pd.weaponSkinList)
	{
		var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
		CustomizeButton_UnmarkForUpdating( button )
	}
	pd.weaponSkinList.clear()

	CustomizeMenus_SetActionButton( null )

	// Items
	string ownedText = file.charmsMenuActive ? "#CHARMS_OWNED" : "#SKINS_OWNED"

	RuiSetString( pd.ownedRui, "title", Localize( ownedText ).toupper() )

	// setup, but only if we're active
	if ( IsPanelActive( panel ) && pd.weaponOrNull != null )
	{
		file.currentWeapon = expect ItemFlavor(pd.weaponOrNull)
		LoadoutEntry entry
		array<ItemFlavor> itemList
		void functionref( ItemFlavor ) previewFunc
		void functionref( ItemFlavor, var ) customButtonUpdateFunc
		void functionref( ItemFlavor, void functionref() ) confirmationFunc
		bool ignoreDefaultItemForCount

		if ( file.charmsMenuActive )
		{
			entry = Loadout_WeaponCharm( file.currentWeapon )
			pd.weaponCharmList = GetLoadoutItemsSortedForMenu( entry, WeaponCharm_GetSortOrdinal )
			itemList = pd.weaponCharmList
			previewFunc = PreviewWeaponCharm
			customButtonUpdateFunc = (void function( ItemFlavor charmFlav, var rui )
			{
				asset img = $""

				ItemFlavor ornull weaponFlavorOrNull = GetWeaponThatCharmIsCurrentlyEquippedToForPlayer( ToEHI( GetUIPlayer() ), charmFlav )
				if ( weaponFlavorOrNull != null )
				{
					ItemFlavor weaponFlavorThatCharmIsEquippedTo = expect ItemFlavor( weaponFlavorOrNull )
					if ( weaponFlavorThatCharmIsEquippedTo != file.currentWeapon )
					{
						img = WeaponItemFlavor_GetHudIcon( weaponFlavorThatCharmIsEquippedTo )
						RuiSetBool( rui, "isEquipped", false ) //
					}
				}


				RuiSetAsset( rui, "equippedCharmWeaponAsset", img )
			})
			confirmationFunc = (void function( ItemFlavor charmFlav, void functionref() proceedCb ) {
				ItemFlavor ornull charmCurrentWeaponFlav = GetWeaponThatCharmIsCurrentlyEquippedToForPlayer( LocalClientEHI(), charmFlav )
				if ( charmCurrentWeaponFlav == null || charmCurrentWeaponFlav == file.currentWeapon )
				{
					proceedCb()
					return
				}
				expect ItemFlavor(charmCurrentWeaponFlav)
				string localizedEquippedWeaponName = Localize( ItemFlavor_GetShortName( charmCurrentWeaponFlav ) )
				string localizedCurrentWeaponName = Localize( ItemFlavor_GetShortName( file.currentWeapon ) )

				ConfirmDialogData data
				data.headerText = Localize( "#CHARM_DIALOG", localizedEquippedWeaponName )
				data.messageText = Localize( "#CHARM_DIALOG_DESC", localizedCurrentWeaponName, localizedEquippedWeaponName )
				data.resultCallback = (void function( int result ) : ( charmCurrentWeaponFlav, proceedCb )
				{
					if ( result != eDialogResult.YES )
						return

					RequestSetItemFlavorLoadoutSlot( LocalClientEHI(), Loadout_WeaponCharm( charmCurrentWeaponFlav ), GetItemFlavorByAsset( $"settings/itemflav/weapon_charm/none.rpak" ) )

					proceedCb()
				})
				OpenConfirmDialogFromData( data )
			})
			ignoreDefaultItemForCount = true
		}
		else
		{
			entry = Loadout_WeaponSkin( file.currentWeapon )
			pd.weaponSkinList = GetLoadoutItemsSortedForMenu( entry, WeaponSkin_GetSortOrdinal )
			FilterWeaponSkinList( pd.weaponSkinList )
			itemList = pd.weaponSkinList
			previewFunc = PreviewWeaponSkin
			confirmationFunc = null
			ignoreDefaultItemForCount = false

			customButtonUpdateFunc = (void function( ItemFlavor charmFlav, var rui )
			{
				RuiSetAsset( rui, "equippedCharmWeaponAsset", $"" )
			})
		}

		RuiSetString( pd.weaponNameRui, "text", Localize( ItemFlavor_GetLongName( file.currentWeapon ) ).toupper() )
		RuiSetString( pd.ownedRui, "collected", CustomizeMenus_GetCollectedString( entry, itemList, ignoreDefaultItemForCount ) )

		Hud_InitGridButtons( pd.listPanel, itemList.len() )

		foreach ( int flavIdx, ItemFlavor flav in itemList )
		{
			var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
			CustomizeButton_UpdateAndMarkForUpdating( button, [entry], flav, previewFunc, null, false, customButtonUpdateFunc, confirmationFunc )
		}

		CustomizeMenus_SetActionButton( Hud_GetChild( panel, "ActionButton" ) )
	}
}


void function WeaponSkinsPanel_OnFocusChanged( var panel, var oldFocus, var newFocus )
{
	if ( !IsValid( panel ) ) // uiscript_reset
		return
	if ( GetParentMenu( panel ) != GetActiveMenu() )
		return

	UpdateFooterOptions()

	if ( IsControllerModeActive() )
		CustomizeMenus_UpdateActionContext( newFocus )
}

void function PreviewWeaponCharm( ItemFlavor charmFlavor )
{
	ItemFlavor charmWeaponSkin = LoadoutSlot_GetItemFlavor( LocalClientEHI(), Loadout_WeaponSkin( file.currentWeapon ) )
	int weaponSkinId           = ItemFlavor_GetNetworkIndex_DEPRECATED( charmWeaponSkin )
	int weaponCharmId          = ItemFlavor_GetNetworkIndex_DEPRECATED( charmFlavor )
	bool shouldHighlightWeapon = file.currentWeaponSkin == charmWeaponSkin ? false : true
	file.currentWeaponSkin = charmWeaponSkin

	RunClientScript( "UIToClient_PreviewWeaponSkin", weaponSkinId, weaponCharmId, shouldHighlightWeapon )
}

void function PreviewWeaponSkin( ItemFlavor weaponSkinFlavor )
{
	ItemFlavor charmFlavor = LoadoutSlot_GetItemFlavor( LocalClientEHI(), Loadout_WeaponCharm( WeaponSkin_GetWeaponFlavor( weaponSkinFlavor ) ) )
	int weaponCharmId      = ItemFlavor_GetNetworkIndex_DEPRECATED( charmFlavor )

	int weaponSkinId = ItemFlavor_GetNetworkIndex_DEPRECATED( weaponSkinFlavor )
	file.currentWeaponSkin = weaponSkinFlavor

	RunClientScript( "UIToClient_PreviewWeaponSkin", weaponSkinId, weaponCharmId, true )
}


void function FilterWeaponSkinList( array<ItemFlavor> weaponSkinList )
{
	for ( int i = weaponSkinList.len() - 1; i >= 0; i-- )
	{
		if ( !ShouldDisplayWeaponSkin( weaponSkinList[i] ) )
			weaponSkinList.remove( i )
	}
}


bool function ShouldDisplayWeaponSkin( ItemFlavor weaponSkin )
{
	if ( GladiatorCardWeaponSkin_ShouldHideIfLocked( weaponSkin ) )
	{
		if ( !IsItemFlavorUnlockedForLoadoutSlot( LocalClientEHI(), Loadout_CharacterClass(), weaponSkin ) )
			return false
	}

	return true
}
