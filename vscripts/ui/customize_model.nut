global function CustomizeModel_Init

global function CustomizeModelButton_UpdateAndMarkForUpdating
global function CustomizeModelButton_UnmarkForUpdating

//global function CustomizeMenus_IsSelectedItemOwned
global function CustomizeModelMenus_IsFocusedItem
global function CustomizeModelMenus_IsFocusedItemParentItemLocked
global function CustomizeModelMenus_IsFocusedItemEquippable
global function CustomizeModelMenus_IsFocusedItemLocked
global function CustomizeModelMenus_IsFocusedItemUnlocked
global function CustomizeModelMenus_UpdateActionContext
global function CustomizeModelMenus_SetActionButton
global function CustomizeModelMenus_Equip
global function ActionModelButton_OnClick

struct CustomizeModelButtonContext
{
	int                 index
	var                 button
	string               usedAsset
    array<string>        assets
	//bool          showTooltip

	void functionref( string )                               previewItemCb = null
	void functionref( string, void functionref() proceedCb)  confirmationFunc = null
}

struct FileStruct_LifetimeLevel
{
	table<var, CustomizeModelButtonContext> activeCustomizeButtons = {}
	var                                actionButton = null
	CustomizeModelButtonContext ornull      actionContext
    string                              currentEquipped

	bool isUnlockOperationActive = false
}

FileStruct_LifetimeLevel& fileLevel


/////////////////////////
/////////////////////////
//// Initialiszation ////
/////////////////////////
/////////////////////////
void function CustomizeModel_Init()
{
	FileStruct_LifetimeLevel newFileLevel
	fileLevel = newFileLevel

	AddUICallback_InputModeChanged( OnInputModeChanged )
}


void function OnInputModeChanged( bool controllerModeActive )
{
	UpdateActionButton()
}


//////////////////////////
//////////////////////////
//// Global functions ////
//////////////////////////
//////////////////////////
void function CustomizeModelButton_UpdateAndMarkForUpdating( 
		var button,
		array<string> assets,
		string usedAsset,
		void functionref( string ) previewItemCb,
		void functionref( string, void functionref() proceedCb) confirmationFunc
	)
{
	Assert( !(button in fileLevel.activeCustomizeButtons) )

	CustomizeModelButtonContext cbc
	cbc.index = fileLevel.activeCustomizeButtons.len()
	cbc.button = button
	cbc.usedAsset = usedAsset
    cbc.assets = assets
	cbc.previewItemCb = previewItemCb
	cbc.confirmationFunc = confirmationFunc
	fileLevel.activeCustomizeButtons[button] <- cbc

	Hud_AddEventHandler( button, UIE_CLICK, CustomizeModelButton_OnClick )
	Hud_AddEventHandler( button, UIE_CLICKRIGHT, CustomizeModelButton_OnRightClick )
	Hud_AddEventHandler( button, UIE_DOUBLECLICK, CustomizeModelButton_OnRightOrDoubleClick )

	UpdateCustomizeItemButton( cbc, true )
}


void function CustomizeModelButton_UnmarkForUpdating( var button )
{
	Assert( button in fileLevel.activeCustomizeButtons )
	CustomizeModelButtonContext cbc = fileLevel.activeCustomizeButtons[button]

	delete fileLevel.activeCustomizeButtons[button]

	Hud_RemoveEventHandler( button, UIE_CLICK, CustomizeModelButton_OnClick )
	Hud_RemoveEventHandler( button, UIE_CLICKRIGHT, CustomizeModelButton_OnRightClick )
	Hud_RemoveEventHandler( button, UIE_DOUBLECLICK, CustomizeModelButton_OnRightOrDoubleClick )
}

bool function CustomizeModelMenus_IsFocusedItem()
{
	foreach( var button, CustomizeModelButtonContext cbc in fileLevel.activeCustomizeButtons )
	{
		if ( Hud_IsFocused( button ) )
			return true
	}

	return false
}


bool function CustomizeModelMenus_IsFocusedItemEquippable()
{
	if ( !GRX_IsInventoryReady() )
		return false

	foreach( var button, CustomizeModelButtonContext cbc in fileLevel.activeCustomizeButtons )
	{
		if ( Hud_IsFocused( button ) )
		{
			//bool isOwned = GRX_IsItemOwnedByPlayer( cbc.itemFlavor )

			bool isEquipped = fileLevel.currentEquipped == cbc.usedAsset

            printl("ISEQUIPPED: " + isEquipped)

			return !isEquipped
		}
	}

	return false
}


bool function CustomizeModelMenus_IsFocusedItemUnlocked()
{
	return true
}


bool function CustomizeModelMenus_IsFocusedItemLocked()
{
	return false
}


bool function CustomizeModelMenus_IsFocusedItemParentItemLocked()
{
	return false
}


bool function IsParentItemOwned( CustomizeModelButtonContext cbc )
{
	return true
}


void function CustomizeModelMenus_SetActionButton( var button )
{
	if ( button != null )
		Assert( fileLevel.actionButton == null, "CustomizeMenus_SetActionButton() passed a non-null value when fileLevel.actionButton wasn't null. This likely means some script isn't clearing it when it should." )

	if ( fileLevel.actionButton != null )
		Hud_RemoveEventHandler( fileLevel.actionButton, UIE_CLICK, ActionModelButton_OnClick )

	fileLevel.actionButton = button

	if ( fileLevel.actionButton != null )
		Hud_AddEventHandler( fileLevel.actionButton, UIE_CLICK, ActionModelButton_OnClick )

	UpdateActionButton()
}


///////////////////
///////////////////
//// Internals ////
///////////////////
///////////////////
void function CustomizeModelButton_OnClick( var button )
{
	CustomizeModelButtonContext cbc = fileLevel.activeCustomizeButtons[button]
	CustomizeModelMenus_UpdateActionContext( button )
	PlayPreviewSound()
	PreviewCustomizeButtonItem( cbc )
}


void function CustomizeModelButton_OnRightClick( var button )
{
	CustomizeModelButtonContext cbc = fileLevel.activeCustomizeButtons[button]

	if ( cbc.assets.len() > 1 )
	{
		//
		bool wasEquipped = fileLevel.currentEquipped == cbc.usedAsset

		if ( !wasEquipped )
		{
			CustomizeModelButton_OnRightOrDoubleClick( button )
		}

		return
	}

	CustomizeModelButton_OnRightOrDoubleClick( button )
}


void function CustomizeModelButton_OnRightOrDoubleClick( var button )
{
	CustomizeModelButtonContext cbc = fileLevel.activeCustomizeButtons[button]
	CustomizeModelMenus_UpdateActionContext( button )
	PreviewCustomizeButtonItem( cbc )
	EquipCustomizeButtonItemOrShowSlotPickerDialogOrShowUnlockDialog( cbc )
}

void function CustomizeModelMenus_Equip(string toEquip) {
	fileLevel.currentEquipped = toEquip
}

void function PreviewCustomizeButtonItem( CustomizeModelButtonContext cbc )
{
	Hud_SetNew( cbc.button, false )

	foreach( var b, CustomizeModelButtonContext cbcIter in fileLevel.activeCustomizeButtons )
		Hud_SetSelected( b, cbc == cbcIter )

	if ( cbc.previewItemCb != null )
		cbc.previewItemCb( cbc.usedAsset )

	UpdateFooterOptions()
	CustomizeModelMenus_UpdateActionContext( cbc.button )
}


void function EquipCustomizeButtonItemOrShowSlotPickerDialogOrShowUnlockDialog( CustomizeModelButtonContext cbc )
{
	PlayerClickedToEquipThing( cbc )
}


void function PlayerClickedToEquipThing( CustomizeModelButtonContext cbc )
{
	PlayerClickedToEquipThing_Part1_UnlockDialog( cbc )
}


void function PlayerClickedToEquipThing_Part1_UnlockDialog( CustomizeModelButtonContext cbc )
{
	PlayerClickedToEquipThing_Part2_SlotPicker( cbc )
}


void function PlayerClickedToEquipThing_Part2_SlotPicker( CustomizeModelButtonContext cbc )
{
	PlayerClickedToEquipThing_Part3_ConfirmationDialog( cbc, cbc.usedAsset, 0 )
}

void function PlayerClickedToEquipThing_Part3_ConfirmationDialog( CustomizeModelButtonContext cbc, string to, int slotIndex )
{
	if ( cbc.confirmationFunc != null )
	{
		cbc.confirmationFunc( cbc.usedAsset, void function() : ( cbc, to, slotIndex ) {
			PlayerClickedToEquipThing_Part4_DoIt( cbc, to, slotIndex )
		} )
		return
	}

	PlayerClickedToEquipThing_Part4_DoIt( cbc, to, slotIndex )
}


void function PlayerClickedToEquipThing_Part4_DoIt( CustomizeModelButtonContext cbc, string to, int slotIndex )
{
	fileLevel.currentEquipped = to
	foreach(key, value in fileLevel.activeCustomizeButtons) {
		UpdateCustomizeItemButton(value, false)
	}
	PlayEquipSound()
}


void function PlayPreviewSound()
{
	string sound = "UI_Menu_Banner_Preview"
	EmitUISound( sound )
}

void function PlayEquipSound()
{
	string sound = "UI_Menu_LegenedSkin_Equip_Common"
	EmitUISound( sound )
}


void function UpdateCustomizeItemButton( CustomizeModelButtonContext cbc, bool justAdded )
{
	var rui = Hud_GetRui( cbc.button )

	// Name, icon and quality
	string name = Localize(cbc.usedAsset)
	int quality = 0

	RuiSetString( rui, "buttonText", name )
	RuiSetImage( rui, "buttonImage",  $"" )
	RuiSetInt( rui, "quality", quality )
	RuiSetImage( rui, "sourceIcon",  $"" )

	// Tooltip
	//if ( cbc.showTooltip )
	//{
	//	ToolTipData toolTipData
	//	toolTipData.titleText = Localize( ItemFlavor_GetName( cbc.itemFlavor ) )
	//	//toolTipData.descText = ""
	//	Hud_SetToolTipData( cbc.button, toolTipData )
	//}

	// Newness
	// todo(dw): make new and locked mutually exclusive

	// Seleted/equipped
	bool isEquipped = cbc.usedAsset == fileLevel.currentEquipped

	if ( justAdded )
		Hud_SetSelected( cbc.button, false )

	if ( isEquipped && justAdded )
	{
		PreviewCustomizeButtonItem( cbc )
		Hud_ScrollToItemIndex( Hud_GetParent( Hud_GetParent( cbc.button ) ), cbc.index )
	}

	RuiSetBool( rui, "isEquipped", isEquipped )

	// Purchase info
	bool isOwned = true

	Hud_SetLocked( cbc.button, !isOwned )
	//RuiSetBool( rui, "isOwned", isOwned )
}


void function UpdateAllCurrentCustomizeItemButtons()
{
	if ( fileLevel.isUnlockOperationActive )
		return

	foreach ( var button, CustomizeModelButtonContext cbc in fileLevel.activeCustomizeButtons )
	{
		UpdateCustomizeItemButton( cbc, false )
	}

	UpdateFooterOptions()
	UpdateActionButton()
}


void function OnLoadoutSlotContentsChanged( EHI playerEHI, ItemFlavor contents )
{
	UpdateAllCurrentCustomizeItemButtons()
	UpdateActionButton()
}


void function CustomizeModelMenus_UpdateActionContext( var button )
{
	if ( button in fileLevel.activeCustomizeButtons )
	{
		fileLevel.actionContext = fileLevel.activeCustomizeButtons[button]
	}
	else
	{
		if ( IsControllerModeActive() )
		{
			foreach ( var b, CustomizeModelButtonContext cbc in fileLevel.activeCustomizeButtons )
			{
				if ( Hud_IsSelected( b ) )
				{
					fileLevel.actionContext = fileLevel.activeCustomizeButtons[b]
					break
				}
			}
		}

		fileLevel.actionContext = null
	}

	//printt( "Set context:", ItemFlavor_GetHumanReadableRef( expect CustomizeModelButtonContext( fileLevel.actionContext ).itemFlavor ) )
	UpdateActionButton()
}


CustomizeModelButtonContext ornull function GetActionContext()
{
	return fileLevel.actionContext
}


void function ActionModelButton_OnClick( var button )
{
	CustomizeModelButtonContext ornull cbc = GetActionContext()
	if ( cbc == null )
		return

	expect CustomizeModelButtonContext( cbc )

//	EquipCustomizeButtonItemOrShowSlotPickerDialogOrShowUnlockDialog( cbc )
}


bool function IsItemInCBCEquipped( CustomizeModelButtonContext cbc )
{
	return cbc.usedAsset == fileLevel.currentEquipped
}


void function UpdateActionButton()
{
	if ( fileLevel.actionButton == null )
		return

	CustomizeModelButtonContext ornull cbc = GetActionContext()
	if ( cbc == null )
	{
		Hud_SetVisible( fileLevel.actionButton, false )
		return
	}

	expect CustomizeModelButtonContext( cbc )
	//ItemFlavor item = cbc.itemFlavor

	bool isParentItemOwned = IsParentItemOwned( cbc )
	bool isOwned           = true
	bool isEquipped        = IsItemInCBCEquipped( cbc )
	bool isVisible         = !isParentItemOwned || !isOwned || (isOwned && !isEquipped)

	Hud_SetVisible( fileLevel.actionButton, isVisible )

	if ( !isVisible )
		return

	string buttonText
	bool controllerActive = IsControllerModeActive()

    buttonText = controllerActive ? "#X_BUTTON_EQUIP" : "#EQUIP"

	HudElem_SetRuiArg( fileLevel.actionButton, "centerText", buttonText )
}