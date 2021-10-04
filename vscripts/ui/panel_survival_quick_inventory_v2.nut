global function InitSurvivalQuickInventoryPanel

global function InitSquadPanelInventory
global function InitCharacterDetailsPanel
global function InitSystemInventoryPanel
global function InitLegendPanelInventory

global function SurvivalGroundItem_SetGroundItemCount
global function SurvivalGroundItem_SetGroundItemHeader
global function SurvivalGroundItem_IsHeader

global function SurvivalQuickInventory_OnUpdate

global function SurvivalQuickInventory_NavigateBack

global function SurvivalQuickInventory_SetEmptyTooltipForSlot
global function SurvivalQuickInventory_ClearTooltipForSlot
global function SurvivalQuickInventory_SetClientUpdateLootTooltipData
global function SurvivalQuickInventory_SetClientUpdateDefaultTooltipData

global function SurvivalQuickInventory_MarkInventoryButtonUsed
global function SurvivalQuickInventory_MarkInventoryButtonPinged
global function SurvivalQuickInventory_UpdateEquipmentForActiveWeapon
global function SurvivalQuickInventory_UpdateWeaponSlot

global function GetGroundItemDef
global function GetGroundItemCount
global function Survival_CommonButtonInit
global function GetInventoryItemCount
global function UpdateInventoryDpadTooltip
global function TranslateBackpackGridPosition

global function ClientCallback_SetTempButtonRef
global function ClientCallback_SetTempBoolMouseDragAllowed
global function ClientCallback_StartEquipmentExtendedUse

global function ConvertCursorToScreenPos

const float INACTIVE_WEAPON_SCALE = 0.8

global const int INVENTORY_ROWS = 2
global const int INVENTORY_COLS = 9

const float MOUSE_DRAG_BUFFER = 25.0
const float MOUSE_DRAG_BUFFER_TIME = 1.0

table<int, string> clickStringForLoot
table<int, string> clickRightStringForLoot

struct CommonButtonData
{
	int useCount
	int pingCount
}

struct
{
	var mainPanel

	var inventoryGridStatic

	var mainInventoryPanel

	var characterDetailsPanel
	var characterDetailsRui

	var overlay
	var holdToUseElem

	bool compactModeEnabled = false

	int 		groundItemCount = 0

	array<bool>	groundItemHeaders = []

	table< string, var > equipmentButtons = {}

	table<var, CommonButtonData> useDataForButtons = {}

	string tempButtonRef
	bool tempBoolMouseDragAllowed

	table<var, void functionref( var,var,var,int ) > onMouseDropCallbacks
	array<var> allDropSlots
} file

void function Survival_CommonButtonInit( var button )
{
	CommonButtonData bd
	file.useDataForButtons[button] <- bd
}

void function SurvivalQuickInventory_MarkInventoryButtonPinged( var button )
{
	CommonButtonData bd = file.useDataForButtons[button]
	bd.pingCount += 1
	var rui = Hud_GetRui( button )
	RuiSetInt( rui, "pingCounter", bd.pingCount )
}

void function SurvivalQuickInventory_MarkInventoryButtonUsed( var button )
{
	CommonButtonData bd = file.useDataForButtons[button]
	bd.useCount += 1
	var rui = Hud_GetRui( button )
	RuiSetInt( rui, "useCounter", bd.useCount )
}

void function OnBackpackItemCommand( var panel, var button, int index, string command  )
{
}


void function InitSurvivalQuickInventoryPanel( var panel )
{
	file.mainPanel = panel

	RegisterSignal("StopMouseDrag" )
	RegisterSignal("StartEquipmentExtendedUse" )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, OnSurvivalQuickInventoryPanel_Show )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, OnSurvivalQuickInventoryPanel_Hide )

	InitInventoryFooter( panel )

	file.mainInventoryPanel = Hud_GetChild( panel, "MainInventory" )
	InitMainInventoryPanel( file.mainInventoryPanel )

	array<var> dropSlots = GetElementsByClassname( GetParentMenu( panel ), "DropSlot" )

	foreach ( slot in dropSlots )
	{
		RegisterDropSlot( slot, null )
		if ( Hud_GetScriptID( slot ) == "ground" )
		{
			var rui = Hud_GetRui( slot )
			RuiSetBool( rui, "isAlwaysVisible", true )
			RuiSetString( rui, "optionalText", "#INVENTORY_SLOT_GROUND" )
		}
	}

	var reskin0 = Hud_GetChild( file.mainInventoryPanel, "MainWeaponReskin0" )
	Hud_AddEventHandler( reskin0, UIE_CLICK, OnReskinButtonClick )

	var reskin1 = Hud_GetChild( file.mainInventoryPanel, "MainWeaponReskin1" )
	Hud_AddEventHandler( reskin1, UIE_CLICK, OnReskinButtonClick )

	file.inventoryGridStatic = Hud_GetChild( file.mainInventoryPanel, "BackpackGrid" )
	GridPanel_Init( file.inventoryGridStatic, INVENTORY_ROWS, INVENTORY_COLS, OnBindBackpackItem, GetMaxInventoryItemCount, Survival_CommonButtonInit )
	GridPanel_SetButtonHandler( file.inventoryGridStatic, UIE_CLICK, OnBackpackItemClick )
	GridPanel_SetButtonHandler( file.inventoryGridStatic, UIE_CLICKRIGHT, OnBackpackItemClickRight )
	GridPanel_SetButtonHandler( file.inventoryGridStatic, UIE_GET_FOCUS, OnBackpackItemGetFocus )
	GridPanel_SetButtonHandler( file.inventoryGridStatic, UIE_LOSE_FOCUS, OnBackpackItemLoseFocus )
	GridPanel_SetKeyPressHandler( file.inventoryGridStatic, OnBackpackItemKeyPress )

	GridPanel_SetCommandHandler( file.inventoryGridStatic, OnBackpackItemCommand )

	var elem = Hud_GetChild( panel, "MouseDragIcon" )
	Hud_Hide( elem )

	file.holdToUseElem = Hud_GetChild( Hud_GetParent( panel ), "HoldToUseElem" )

	AddUICallback_OnResolutionChanged( OnSurvivalQuickInventoryPanel_Refresh )
	AddUICallback_LevelShutdown( OnLevelShutdown )

	HudElem_SetChildRuiArg( file.mainInventoryPanel, "InventoryBracketR", "basicImage", $"rui/menu/inventory/backpack_container_side_bracket", eRuiArgType.IMAGE )
	HudElem_SetChildRuiArg( file.mainInventoryPanel, "InventoryBracketL", "basicImage", $"rui/menu/inventory/backpack_container_side_bracket", eRuiArgType.IMAGE )

	HudElem_SetChildRuiArg( file.mainInventoryPanel, "InventoryBracketR", "imageRotation", 0.5, eRuiArgType.FLOAT )

	HudElem_SetChildRuiArg( file.mainInventoryPanel, "InventoryBracketL", "basicImageAlpha", 0.5, eRuiArgType.FLOAT )
	HudElem_SetChildRuiArg( file.mainInventoryPanel, "InventoryBracketR", "basicImageAlpha", 0.5, eRuiArgType.FLOAT )

	HudElem_SetChildRuiArg( file.mainInventoryPanel, "GearBracketR", "basicImage", $"rui/menu/inventory/gear_container_side_bracket", eRuiArgType.IMAGE )
	HudElem_SetChildRuiArg( file.mainInventoryPanel, "GearBracketL", "basicImage", $"rui/menu/inventory/gear_container_side_bracket", eRuiArgType.IMAGE )
	HudElem_SetChildRuiArg( file.mainInventoryPanel, "GearBracketR", "imageRotation", 0.5, eRuiArgType.FLOAT )

	HudElem_SetChildRuiArg( file.mainInventoryPanel, "GearBracketL", "basicImageAlpha", 0.5, eRuiArgType.FLOAT )
	HudElem_SetChildRuiArg( file.mainInventoryPanel, "GearBracketR", "basicImageAlpha", 0.5, eRuiArgType.FLOAT )

	HudElem_SetChildRuiArg( file.mainInventoryPanel, "BackerInventoryBG", "basicImage", $"rui/menu/inventory/backpack_container_mask", eRuiArgType.IMAGE )
	HudElem_SetChildRuiArg( file.mainInventoryPanel, "BackerInventoryBG", "basicImageColor", <0.0,0.0,0.0>, eRuiArgType.VECTOR )
	HudElem_SetChildRuiArg( file.mainInventoryPanel, "BackerInventoryBG", "basicImageAlpha", 0.65, eRuiArgType.FLOAT )
	HudElem_SetChildRuiArg( file.mainInventoryPanel, "BackerInventory", "maskImage", $"rui/menu/inventory/backpack_container_mask", eRuiArgType.IMAGE )
	HudElem_SetChildRuiArg( file.mainInventoryPanel, "BackerInventory", "textureImage", $"rui/menu/inventory/backpack_container_texture", eRuiArgType.IMAGE )
	HudElem_SetChildRuiArg( file.mainInventoryPanel, "BackerInventory", "basicImageAlpha", 0.25, eRuiArgType.FLOAT )
	HudElem_SetChildRuiArg( file.mainInventoryPanel, "BackerInventory2", "maskImage", $"rui/menu/inventory/backpack_container_mask", eRuiArgType.IMAGE )
	HudElem_SetChildRuiArg( file.mainInventoryPanel, "BackerInventory2", "textureImage", $"rui/menu/inventory/backpack_container_texture", eRuiArgType.IMAGE )
	HudElem_SetChildRuiArg( file.mainInventoryPanel, "BackerInventory2", "basicImageAlpha", 0.25, eRuiArgType.FLOAT )
	HudElem_SetChildRuiArg( file.mainInventoryPanel, "BackerInventory2", "imageRotation", 0.5, eRuiArgType.FLOAT )

	if ( !( uiGlobal.uiShutdownCallbacks.contains(Inventory_Shutdown) ) )
		AddUICallback_UIShutdown( Inventory_Shutdown )
}

void function InitInventoryFooter( var panel )
{
	AddPanelFooterOption( panel, LEFT, BUTTON_Y, false, "", "", SurvivalMenuSwapWeapon, IsSurvivalMenuEnabled )

	AddPanelFooterOption( panel, LEFT, BUTTON_BACK, false, "", "", TryToggleMap )

	AddPanelFooterOption( panel, LEFT, KEY_M, false, "", "", TryToggleMap, PROTO_ShouldInventoryFooterHack )
	AddPanelFooterOption( panel, LEFT, KEY_TAB, false, "", "", TryCloseSurvivalInventory, PROTO_ShouldInventoryFooterHack )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, RIGHT, BUTTON_START, true, "#HINT_SYSTEM_MENU_GAMEPAD", "#HINT_SYSTEM_MENU_KB", TryOpenSystemMenu )

	#if R5DEV
		if ( Dev_CommandLineHasParm( "-showdevmenu" ) )
			AddPanelFooterOption( panel, LEFT, BUTTON_STICK_LEFT, true, "#LEFT_STICK_DEV_MENU", "#DEV_MENU", OpenDevMenu )
	#endif
}

void function RegisterDropSlot( var button, void functionref( var,var,var,int ) dropFunc )
{
	file.allDropSlots.append( button )
	file.onMouseDropCallbacks[ button ] <- dropFunc
	Hud_SetAboveBlur( button, false )
}

void function InitSystemInventoryPanel( var panel )
{
	InitSystemPanel( panel )
	InitInventoryFooter( panel )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, OnShowSystemPanel )
}

void function OnShowSystemPanel( var panel )
{
	SurvivalInventory_SetBGVisible( true )
	UpdateSystemPanel( panel )
}

void function InitCharacterDetailsPanel( var panel )
{
	file.characterDetailsPanel = panel
	file.characterDetailsRui = Hud_GetRui( file.characterDetailsPanel )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, OnShowCharacterDetails )

	InitInventoryFooter( panel )
}


void function OnShowCharacterDetails( var panel )
{
	SurvivalInventory_SetBGVisible( true )
	RunClientScript( "UICallback_UpdateCharacterDetailsPanel", file.characterDetailsPanel )
}

void function OnSurvivalQuickInventoryPanel_Show( var panel )
{
	var menu = GetParentMenu( panel )

	UISize screenSize = GetScreenSize()
	SetCursorPosition( <1920.0 * 0.5, 1080.0 * 0.5, 0> )

	file.compactModeEnabled = false

	SurvivalQuickInventory_OnUpdate()

	Hud_Show( file.mainInventoryPanel )
	SurvivalInventory_SetBGVisible( true )

	Hud_SetVisible( Hud_GetChild( panel, "IngameTextChatHistory" ), IsAccessibilityChatToSpeech() )

	if ( !IsFullyConnected() )
		return

	if ( IsLobby() )
		return

	RunClientScript( "UICallback_BackpackOpened" )

	RunClientScript( "UICallback_UpdatePlayerInfo", Hud_GetChild( file.mainInventoryPanel, "PlayerInfo" ) )
	RunClientScript( "UICallback_UpdateTeammateInfo", Hud_GetChild( file.mainInventoryPanel, "TeammateInfo0" ) )
	RunClientScript( "UICallback_UpdateTeammateInfo", Hud_GetChild( file.mainInventoryPanel, "TeammateInfo1" ) )
	RunClientScript( "UICallback_UpdateUltimateInfo", Hud_GetChild( file.mainInventoryPanel, "PlayerUltimate" ) )
}

void function OnSurvivalQuickInventoryPanel_Refresh()
{
	SurvivalQuickInventory_OnUpdate()
}

void function OnSurvivalQuickInventoryPanel_Hide( var panel )
{
	Hud_SetHeight( Hud_GetChild( file.mainInventoryPanel, "TeammateInfo0" ), Hud_GetBaseHeight( Hud_GetChild( file.mainInventoryPanel, "TeammateInfo0" ) ) )
	Hud_SetHeight( Hud_GetChild( file.mainInventoryPanel, "TeammateInfo1" ), Hud_GetBaseHeight( Hud_GetChild( file.mainInventoryPanel, "TeammateInfo1" ) ) )

	SurvivalMenu_AckAction()

	if ( !IsFullyConnected() )
		return

	if ( IsLobby() )
		return

	CloseCharacterDetails()

	RunClientScript( "UICallback_BackpackClosed" )
}

void function SurvivalQuickInventory_OnUpdate()
{
	GridPanel_Refresh( file.inventoryGridStatic )

	if ( !IsFullyConnected() )
		return

	if ( GetActiveMenu() != GetParentMenu( file.mainPanel ) )
		return

	if ( IsLobby() )
		return

	foreach ( button in file.equipmentButtons )
	{
		Hud_ClearToolTipData( button )
		if ( IsFullyConnected() )
			RunClientScript( "UICallback_UpdateEquipmentButton", button )
	}

	UpdateBackpackDpadNav()

// -----------------------------------------------------------------
// CONDENSE UNUSED ATTACHMENTS
// -----------------------------------------------------------------
	array<string> attachmentSuffix =
	[
		"Barrel",
		"Mag",
		"Sight",
		"Grip",
		"Hopup",
	]

	for ( int i=0; i<2; i++ )
	{
		string prefix = "MainWeapon" + i
		bool didDpadMapping = false

		var prevButton = null
		foreach ( suffix in attachmentSuffix )
		{
			var button = Hud_GetChild( file.mainInventoryPanel, prefix + "_" + suffix )

			Hud_SetX( button, Hud_GetBaseX( button ) )

			if ( prevButton != null )
			{
				if ( Hud_GetWidth( prevButton ) == 0 )
				{
					Hud_SetX( button, 0 )
				}
				else if( !didDpadMapping )
				{
					//
					var mainWeapon = Hud_GetChild( file.mainInventoryPanel, prefix )
					Hud_SetNavUp( mainWeapon, prevButton )
					didDpadMapping = true
				}
			}

			prevButton = button
		}
	}
// -----------------------------------------------------------------
}


void function Callback_PlayerInventoryChanged()
{
	GridPanel_Refresh( file.inventoryGridStatic )
}


void function SurvivalGroundItem_AddItem( int lootIndex, string guid, int count, bool TEMP_hasMods )
{
}

string function GetEquipmentSlotTypeForButton( var button )
{
	string scriptID = Hud_GetScriptID( button )
	return scriptID
}


void function OnEquipmentCommand( var button, string command )
{
	if ( IsLobby() )
		return

	if ( command == "+ping" )
	{
		if ( IsFullyConnected() )
			RunClientScript( "UICallback_PingEquipmentItem", button )
	}
}


void function InitMainInventoryPanel( var panel )
{
	array<var> buttons = GetElementsByClassname( GetParentMenu( panel ), "SurvivalEquipment" )
	foreach ( button in buttons )
	{
		string equipmentType = GetEquipmentSlotTypeForButton( button )

		Hud_AddEventHandler( button, UIE_CLICK, OnEquipmentButtonClick )
		Hud_AddEventHandler( button, UIE_GET_FOCUS, OnEquipmentItemGetFocus )
		Hud_AddEventHandler( button, UIE_LOSE_FOCUS, OnEquipmentItemLoseFocus )
		Hud_AddEventHandler( button, UIE_CLICKRIGHT, OnEquipmentButtonClickRight )
		Hud_AddKeyPressHandler( button, OnEquipmentKeyPress )

		Hud_SetCommandHandler( button, OnEquipmentCommand )

		file.equipmentButtons[equipmentType] <- button

		Survival_CommonButtonInit( button )
	}
}

void function OnEquipmentItemGetFocus( var button )
{
	if ( GetMouseFocus() != button && !GetDpadNavigationActive() )
		return

	SetTabNavigationEnabled( Hud_GetParent( file.mainPanel ), false )

	if( Hud_HasToolTipData( button ) && GetDpadNavigationActive() )
	{
		LootData ld = GetLootDataFromButton( button, -1 )
		ToolTipData ttd = Hud_GetToolTipData( button )
		string equipmentSlot = Hud_GetScriptID( button )
		RunClientScript( "UpdateDpadTooltipText", ld.ref, ttd.titleText, equipmentSlot )
	}
	else
	{
		SetInventoryDpadTooltipVisible( false )
	}
}

void function OnEquipmentItemLoseFocus( var button )
{
	SetTabNavigationEnabled( Hud_GetParent( file.mainPanel ), true )

	if( !GetDpadNavigationActive() )
		SetInventoryDpadTooltipVisible( false )
}

void function OnEquipmentButtonClick( var button )
{
	if ( IsLobby() )
		return

	if ( !IsFullyConnected() )
		return

	if ( InputIsButtonDown( MOUSE_LEFT ) )
	{
		thread TrackMouseDrag( file.mainInventoryPanel, button, -1, OnEquipmentButtonClickAction )
		return
	}

	OnEquipmentButtonClickAction( file.mainInventoryPanel, button, -1 )
}

void function OnEquipmentButtonClickAction( var panel, var button, int index )
{
	EmitUISound( "UI_InGame_Inventory_Select" )
	RunClientScript( "UICallback_OnEquipmentButtonAction", button )
}

void function OnEquipmentButtonClickRight( var button )
{
	if ( IsLobby() )
		return

	if ( IsFullyConnected() )
	{
		EmitUISound( "UI_InGame_Inventory_Drop" )
		RunClientScript( "UICallback_OnEquipmentButtonAltAction", button, false )
	}
}

bool function OnEquipmentKeyPress( var button, int keyId, bool isDown )
{
	if ( !isDown )
		return false


	if ( IsLobby() )
		return false

	if ( keyId == BUTTON_SHOULDER_RIGHT )
	{
		if ( IsFullyConnected() )
			RunClientScript( "UICallback_PingEquipmentItem", button )
		return true
	}

	return false
}

void function SurvivalQuickInventory_UpdateEquipmentForActiveWeapon( int activeWeaponSlot )
{
	array<int> allSlots = [ 0, 1 ]
	foreach ( slot in allSlots )
	{
		bool selected = (activeWeaponSlot == slot)
		string slotName = "main_weapon" + slot

		Hud_SetSelected( file.equipmentButtons[slotName], selected )

		//if ( activeWeaponSlot != -1 )
		//{
		//	string pinTo = selected ?  "MainWeaponAnchor" : "StowedWeaponAnchor"
		//	float scale  = selected ?  1.0 : INACTIVE_WEAPON_SCALE
		//	Hud_SetPinSibling( file.equipmentButtons[slotName], pinTo )
		//}
	}
	//		foreach ( point in GetAllAttachmentPoints() )
	//		{
	//			ScaleButton( slotName + "_" + point, scale )
	//		}
	//	}
	//}
}


void function SurvivalQuickInventory_UpdateWeaponSlot( int weaponSlot, int skinTier, string skinName, string charmName )
{
	var reskin = Hud_GetChild( file.mainInventoryPanel, "MainWeaponReskin" + weaponSlot )
	bool isVisible = (skinTier > 0 && skinName != "") || (charmName != "")
	Hud_SetVisible( reskin, isVisible )

	ToolTipData toolTipData
	toolTipData.titleText = "Apply Loadout"
	toolTipData.descText = skinName

	Hud_SetToolTipData( reskin, toolTipData )
}


void function OnReskinButtonClick( var button )
{
	int weaponSlot = int( Hud_GetScriptID( button ) )
	Hud_SetVisible( button, false )

	ClientCommand( "WeaponCosmeticsApply " + weaponSlot )
}

void function ScaleButton( string equipmentSlot, float scale )
{
	var button = file.equipmentButtons[equipmentSlot]
		Hud_SetWidth( button, Hud_GetBaseWidth( button ) * scale )
		Hud_SetHeight( button, Hud_GetBaseHeight( button ) * scale )
		Hud_SetX( button, Hud_GetBaseX( button ) * scale )
		Hud_SetY( button, Hud_GetBaseY( button ) * scale )
}

void function SurvivalGroundItem_SetGroundItemCount( int count )
{
	file.groundItemCount = count
	file.groundItemHeaders = []
	file.groundItemHeaders.resize( count, false )
}

int function GetGroundItemCount( var panel )
{
	return file.groundItemCount
}

void function SurvivalGroundItem_SetGroundItemHeader( int index, bool isHeader )
{
	file.groundItemHeaders[index] = isHeader
}

ListPanelListDef function GetGroundItemDef( var panel )
{
	ListPanelListDef def
	def.itemCount = file.groundItemCount
	return def
}

bool function SurvivalGroundItem_IsHeader( int index )
{
	return file.groundItemHeaders[index]
}

void function SurvivalQuickInventory_SetClientUpdateLootTooltipData( var button, bool isMainWeapon )
{
	ToolTipData dt
	dt.tooltipFlags = dt.tooltipFlags | eToolTipFlag.CLIENT_UPDATE
	dt.tooltipStyle = isMainWeapon ? eTooltipStyle.WEAPON_LOOT_PROMPT : eTooltipStyle.LOOT_PROMPT
	Hud_SetToolTipData( button, dt )
}

void function SurvivalQuickInventory_SetClientUpdateDefaultTooltipData( var button )
{
	ToolTipData dt
	dt.tooltipFlags = dt.tooltipFlags | eToolTipFlag.CLIENT_UPDATE
	dt.tooltipStyle = eTooltipStyle.DEFAULT
	Hud_SetToolTipData( button, dt )
}

void function OnBindBackpackItem( var panel, var button, int index )
{
	if ( !IsFullyConnected() )
		return

	if ( IsLobby() )
		return

	int position = TranslateBackpackGridPosition( index )
	Hud_ClearToolTipData( button )

	RunClientScript( "UICallback_UpdateInventoryButton", button, position )
}

void function OnBackpackItemClick( var panel, var button, int index )
{
	if ( !IsFullyConnected() )
		return

	if ( IsLobby() )
		return

	int position = TranslateBackpackGridPosition( index )

	if ( InputIsButtonDown( MOUSE_LEFT ) )
	{
		thread TrackMouseDrag( panel, button, position, OnBackpackItemClickAction )
		return
	}

	OnBackpackItemClickAction( panel, button, position )
}

void function OnBackpackItemClickAction( var panel, var button, int index )
{
	EmitUISound( "UI_InGame_Inventory_Select" )

	if ( !IsFullyConnected() )
		return

	RunClientScript( "UICallback_OnInventoryButtonAction", button, index )
}

void function OnBackpackItemClickRight( var panel, var button, int index )
{
	if ( !IsFullyConnected() )
		return

	if ( IsLobby() )
		return


	int position = TranslateBackpackGridPosition( index )
	EmitUISound( "UI_InGame_Inventory_Drop" )
	RunClientScript( "UICallback_OnInventoryButtonAltAction", button, position )
}

void function OnBackpackItemGetFocus( var panel, var button, int position )
{
	if ( GetMouseFocus() != button && !GetDpadNavigationActive() )
		return

	SetTabNavigationEnabled( Hud_GetParent( file.mainPanel ), false )

	if( Hud_HasToolTipData( button ) && GetDpadNavigationActive() )
	{
		int newPos = TranslateBackpackGridPosition( position )
		LootData ld = GetLootDataFromButton( button, newPos )
		ToolTipData ttd = Hud_GetToolTipData( button )
		string equipmentSlot = Hud_GetScriptID( button )
		RunClientScript( "UpdateDpadTooltipText", ld.ref, ttd.titleText, equipmentSlot )
	}
	else
	{
		SetInventoryDpadTooltipVisible( false )
	}
}

void function OnBackpackItemLoseFocus( var panel, var button, int position )
{
	SetTabNavigationEnabled( Hud_GetParent( file.mainPanel ), true )

	if( !GetDpadNavigationActive() )
		SetInventoryDpadTooltipVisible( false )
}

bool function OnBackpackItemKeyPress( var panel, var button, int index, int keyId, bool isDown )
{
	int position = TranslateBackpackGridPosition( index )

	if ( !isDown )
		return false

	if ( IsLobby() )
		return false


	if ( keyId == BUTTON_SHOULDER_RIGHT )
	{
		RunClientScript( "UICallback_PingInventoryItem", button, position )
		return true
	}

	return false
}

int function GetInventoryItemCount( var panel )
{
	return SurvivalInventoryMenu_GetInventoryLimit()
}

int function GetMaxInventoryItemCount( var panel )
{
	return SurvivalInventoryMenu_GetMaxInventoryLimit()
}

void function SurvivalQuickInventory_NavigateBack()
{
	CloseActiveMenu()
}

bool function IsOptionsFooterValid()
{
	return IsSurvivalMenuEnabled()
}

int function TranslateBackpackGridPosition( int position )
{
	int limit = SURVIVAL_GetInventoryLimit( GetUIPlayer() )
	if ( position >= limit )
	{
		return position
	}

	int rows = INVENTORY_ROWS
	int cols = INVENTORY_COLS

	int currentCol = position / rows
	int currentRow = position % rows

	int newCols = int( ceil( float( limit ) / float( rows ) ) )

	int newPos = currentCol + (currentRow*newCols)

	return newPos
}

void function SurvivalQuickInventory_SetEmptyTooltipForSlot( var button, string title, int commsAction, int tooltipFlags )
{
	ToolTipData dt
	dt.titleText = title
	dt.descText = ""
	dt.tooltipFlags = eToolTipFlag.EMPTY_SLOT | eToolTipFlag.SOLID | tooltipFlags
	dt.commsAction = commsAction

	dt.tooltipStyle = eTooltipStyle.DEFAULT
	Hud_SetToolTipData( button, dt )
}

void function SurvivalQuickInventory_ClearTooltipForSlot( var button )
{
	Hud_ClearToolTipData( button )
}

void function TryOpenOptions( var button )
{
	AdvanceMenu( GetMenu( "SystemMenu" ) )
}

void function TryToggleCharacterDetails( var button )
{
	if ( !IsValid( file.characterDetailsPanel ) )
		return

	if ( !IsSurvivalMenuEnabled() )
		return

	if ( Hud_IsVisible( file.characterDetailsPanel ) )
	{
		Hud_SetVisible( file.characterDetailsPanel, false )
	}
	else
	{
		Hud_SetVisible( file.characterDetailsPanel, true )
	}
}

void function CloseCharacterDetails()
{
	if ( !IsValid( file.characterDetailsPanel ) )
		return

	if ( !IsSurvivalMenuEnabled() )
		return

	if ( Hud_IsVisible( file.characterDetailsPanel ) )
		Hud_SetVisible( file.characterDetailsPanel, false )
}

void function TryToggleMap( var button )
{
	RunClientScript( "ClientToUI_ToggleScoreboard" )
}

void function TrackMouseDrag( var panel, var button, int index, void functionref(var,var,int) clickFunc )
{
	float startTime = Time()
	vector mouseStart = GetCursorPosition()

	float dist
	float elapsedTime
	bool dragStarted = false

	OnThreadEnd(
		function() : ()
		{
			Signal( uiGlobal.signalDummy, "StopMouseDrag" )
		}
	)

	if ( MouseDragAllowed( panel, button, index ) )
	{
		while( InputIsButtonDown( MOUSE_LEFT ) )
		{
			vector mouseEnd = GetCursorPosition()
			dist = Length( mouseEnd-mouseStart )
			elapsedTime = Time() - startTime

			if ( !dragStarted && ( elapsedTime > MOUSE_DRAG_BUFFER_TIME || dist > MOUSE_DRAG_BUFFER ) )
			{
				dragStarted = true
				thread StartMouseDrag( panel, button, index )
			}

			WaitFrame()
		}
	}

	if ( !dragStarted )
	{
		clickFunc( panel, button, index )
	}
	else
	{
		var focusElement = GetMouseFocus()
		if ( focusElement in file.onMouseDropCallbacks )
		{
			if ( file.onMouseDropCallbacks[ focusElement ] != null )
			{
				file.onMouseDropCallbacks[ focusElement ]( focusElement, panel, button, index )
			}

			RunClientScript( "UICallback_OnInventoryMouseDrop", focusElement, panel, button, index, false )
		}
	}
}

void function StartMouseDrag( var panel, var button, int index )
{
	EndSignal( uiGlobal.signalDummy, "StopMouseDrag" )

	var elem = Hud_GetChild( file.mainPanel, "MouseDragIcon" )

	var rui = Hud_GetRui( elem )

	LootData data = GetLootDataFromButton( button, index )

	if ( data.index == -1 )
		return

	array<int> size = [ Hud_GetWidth(button), Hud_GetHeight(button) ]
	if ( Hud_GetScriptID( button ) in file.equipmentButtons )
	{
		if ( Hud_GetScriptID( button ).len() != "main_weapon0".len() )
		{
			size = [ Hud_GetWidth(button), Hud_GetWidth(button) ]
		}
	}

	Hud_SetSize( elem, size[0], size[1] )
	Hud_Show( elem )

	RuiSetImage( rui, "iconImage", data.hudIcon )
	RuiSetInt( rui, "lootTier", data.tier )
	RuiSetBool( rui, "brackerGradientEnabled", false )

	foreach ( slot in file.allDropSlots )
	{
		RunClientScript( "UICallback_OnInventoryMouseDrop", slot, panel, button, index, true )
		Hud_Show( slot )
		Hud_SetEnabled( slot, true )
	}

	OnThreadEnd(
		function () : ( elem, panel, button, index )
		{
			Hud_Hide( elem )

			foreach ( slot in file.allDropSlots )
			{
				Hud_Hide( slot )
				Hud_SetEnabled( slot, false )
			}
		}
	)

	while ( 1 )
	{
		vector screenPos = ConvertCursorToScreenPos()
		Hud_SetPos( elem, screenPos.x - Hud_GetWidth( elem )*0.5, screenPos.y - Hud_GetHeight( elem )*0.5 )
		WaitFrame()
	}
}

vector function ConvertCursorToScreenPos()
{
	vector mousePos = GetCursorPosition()
	UISize screenSize = GetScreenSize()
	mousePos = < mousePos.x * screenSize.width / 1920.0, mousePos.y * screenSize.height / 1080.0, 0.0 >
	return mousePos
}

void function ClientCallback_SetTempBoolMouseDragAllowed( bool allowed )
{
	file.tempBoolMouseDragAllowed = allowed
}

void function ClientCallback_SetTempButtonRef( string ref )
{
	file.tempButtonRef = ref
}

LootData function GetLootDataFromButton( var button, int index )
{
	LootData data

	// this function will set file.tempButtonRef
	RunClientScript( "UICallback_GetLootDataFromButton", button, index )

	if ( SURVIVAL_Loot_IsRefValid( file.tempButtonRef ) )
	{
		data = SURVIVAL_Loot_GetLootDataByRef( file.tempButtonRef )
	}

	return data
}

bool function MouseDragAllowed( var panel, var button, var index )
{
	// sets file.tempBoolMouseDragAllowed
	RunClientScript( "UICallback_GetMouseDragAllowedFromButton", button, index )
	return file.tempBoolMouseDragAllowed
}

void function InitSquadPanelInventory( var panel )
{
	InitSquadPanel( panel )
	InitInventoryFooter( panel )
}

void function InitLegendPanelInventory( var panel )
{
	InitLegendPanel( panel )
	InitInventoryFooter( panel )
}

void function ClientCallback_StartEquipmentExtendedUse( var button, float duration )
{
	thread StartEquipmentExtendedUse( button, duration )
}

void function StartEquipmentExtendedUse( var button, float duration )
{
	Signal( uiGlobal.signalDummy, "StartEquipmentExtendedUse" )
	EndSignal( uiGlobal.signalDummy, "StartEquipmentExtendedUse" )

	var elem = file.holdToUseElem
	Hud_Show( elem )
	HideGameCursor()

	var rui = Hud_GetRui( elem )
	RuiSetBool( rui, "isVisible", true )
	RuiSetGameTime( rui, "startTime", Time() )
	RuiSetFloat( rui, "duration", duration )
	RuiSetString( rui, "holdButtonHint", "%[X_BUTTON|MOUSE2]%" )
	float uiEndTime = Time() + duration

	EmitUISound( "survival_titan_linking_loop" )

	OnThreadEnd(
		function() : ( rui, elem )
		{
			ShowGameCursor()
			Hud_Hide( elem )
			RuiSetBool( rui, "isVisible", false )
			StopUISound( "survival_titan_linking_loop" )
		}
	)

	bool isButtonFocused = GetMouseFocus() == button || ( GetDpadNavigationActive() && Hud_IsFocused( button ) )
	while ( ( InputIsButtonDown( MOUSE_RIGHT ) || InputIsButtonDown( BUTTON_X ) ) && Time() < uiEndTime && isButtonFocused )
	{
		vector screenPos = ConvertCursorToScreenPos()
		Hud_SetPos( elem, screenPos.x - Hud_GetWidth( elem )*0.5, screenPos.y - Hud_GetHeight( elem )*0.5 )
		WaitFrame()
	}

	if ( Time() < uiEndTime )
		return

	if ( IsLobby() )
		return

	EmitUISound( "ui_menu_store_purchase_success" )

	if ( IsConnected() )
		RunClientScript( "UICallback_OnEquipmentButtonAltAction", button, true )
}

//
void function UpdateBackpackDpadNav()
{
	if( !Hud_HasChild( file.inventoryGridStatic, "GridButton0x0" ) )
		return

	const int MAX_BACKPACK_SLOTS = 7
	var mainWeap0 = Hud_GetChild( file.mainInventoryPanel, "MainWeapon0" )

	for( int i = 0; i < MAX_BACKPACK_SLOTS; i++ )
	{
		var gridBtn = Hud_GetChild( file.inventoryGridStatic, "GridButton0x" + i )
		Hud_SetNavUp( gridBtn, mainWeap0 )
	}

	Hud_SetNavDown( Hud_GetChild( file.inventoryGridStatic, "GridButton1x0" ), Hud_GetChild( file.mainInventoryPanel, "Helmet" ) )
	Hud_SetNavDown( Hud_GetChild( file.inventoryGridStatic, "GridButton1x1" ), Hud_GetChild( file.mainInventoryPanel, "Helmet" ) )
	Hud_SetNavDown( Hud_GetChild( file.inventoryGridStatic, "GridButton1x2" ), Hud_GetChild( file.mainInventoryPanel, "Armor" ) )
	Hud_SetNavDown( Hud_GetChild( file.inventoryGridStatic, "GridButton1x3" ), Hud_GetChild( file.mainInventoryPanel, "IncapShield" ) )
	Hud_SetNavDown( Hud_GetChild( file.inventoryGridStatic, "GridButton1x4" ), Hud_GetChild( file.mainInventoryPanel, "BackPack" ) )
	#if(false)


#endif

	if( Hud_IsEnabled( Hud_GetChild( file.inventoryGridStatic, "GridButton1x4" ) ) )
		Hud_SetNavUp( Hud_GetChild( file.mainInventoryPanel, "BackPack" ), Hud_GetChild( file.inventoryGridStatic, "GridButton1x4" ) )
	else
		Hud_SetNavUp( Hud_GetChild( file.mainInventoryPanel, "BackPack" ), Hud_GetChild( file.mainInventoryPanel, "BackPack" ) )

	#if(false)




#endif
}

void function SetInventoryDpadTooltipVisible( bool isVisible )
{
	var dpadToolTip = Hud_GetChild( Hud_GetParent( file.mainPanel ), "TooltipDpad" )
	var dpadToolTipRui = Hud_GetRui( dpadToolTip )

	Hud_SetVisible( dpadToolTip, isVisible )
}

void function UpdateInventoryDpadTooltip( string itemName, string mainUsePrompt = "", string altUsePrompt = "", string pingPrompt = "", string specialPrompt = "" )
{
	var dpadToolTip = Hud_GetChild( Hud_GetParent( file.mainPanel ), "TooltipDpad" )
	var dpadToolTipRui = Hud_GetRui( dpadToolTip )

	string spacer = "      "
	string footerText = specialPrompt

	footerText += mainUsePrompt != "" ? spacer + mainUsePrompt : ""
	footerText += altUsePrompt != "" ? spacer + altUsePrompt : ""
	footerText += pingPrompt != "" ? spacer + pingPrompt : ""
	RuiSetString( dpadToolTipRui, "itemNameText", Localize( itemName ) )
	RuiSetString( dpadToolTipRui, "footerText", footerText )
	Hud_SetVisible( dpadToolTip, itemName != "" )
}

void function Inventory_Shutdown()
{
	if ( IsFullyConnected() )
		RunClientScript( "UICallback_BackpackClosed" )
}

void function TryOpenSystemMenu( var panel )
{
	if ( InputIsButtonDown( BUTTON_START ) )
		return

	OpenSystemMenu()
}

void function OnLevelShutdown()
{
	if ( GetBugReproNum() == 53995 )
		return

	Hud_SetHeight( Hud_GetChild( file.mainInventoryPanel, "TeammateInfo0" ), Hud_GetBaseHeight( Hud_GetChild( file.mainInventoryPanel, "TeammateInfo0" ) ) )
	Hud_SetHeight( Hud_GetChild( file.mainInventoryPanel, "TeammateInfo1" ), Hud_GetBaseHeight( Hud_GetChild( file.mainInventoryPanel, "TeammateInfo1" ) ) )

	foreach ( button in file.equipmentButtons )
	{
		Hud_SetWidth( button, Hud_GetBaseWidth( button ) )
	}
}