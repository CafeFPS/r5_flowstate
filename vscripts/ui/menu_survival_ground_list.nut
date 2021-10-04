global function InitGroundListMenu
global function UpdateGroundListMenu
global function GroundItem_OpenQuickSwap

global function SurvivalQuickInventory_DoQuickSwap

global function OpenSurvivalGroundListMenu

global function SurvivalGroundItem_BeginUpdate
global function SurvivalGroundItem_EndUpdate

global function ClientCallback_StartGroundItemExtendedUse

struct
{
	var menu

	var holdToUseElem

	var groundList
	var groundHeader
	var groundScrollBar
	var groundListSelected
	ToolTipData& groundListSavedTooltipData

	var quickSwapBacker
	var quickSwapGrid
	var quickSwapHeader
	var inventorySwapIcon

	bool groundItemUpdateInProgress = false
	var  selectedGroundItemEntIndex = -1
	int  selectedGroundItemPosition = -1

	bool closeOnQuickSwapClose = false
	bool quickInventoryGridPanelShowing = false

	int       swappedItemSlot = -1

	float 		lastScrollTime
	float 		trackedScrollValue

	string guidOverride = ""
} file

void function OnGroundListCommand( var panel, var button, int index, string command )
{
	if ( command == "+ping" )
	{
		if ( IsFullyConnected() )
			RunClientScript( "UICallback_PingGroundListItem", button, index )
	}
}

void function OnQuickSwapMenuCommand( var panel, var button, int index, string command  )
{
}

void function InitGroundListMenu( var newMenuArg )
{
	RegisterSignal( "Delayed_SetCursorToObject" )
	RegisterSignal( "StartGroundItemExtendedUse" )

	var menu = GetMenu( "SurvivalGroundListMenu" )
	file.menu = menu
	Survival_RegisterInventoryMenu( menu )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnSurvivalGroundListMenu_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnSurvivalGroundListMenu_NavBack )
	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, OnSurvivalGroundListMenu_Show )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnSurvivalGroundListMenu_Close )

	AddMenuFooterOption( menu, LEFT, BUTTON_Y, true, "", "", SurvivalMenuSwapWeapon, IsSurvivalMenuEnabled )

	file.groundList = Hud_GetChild( menu, "ListPanel" )
	file.groundScrollBar = Hud_GetChild( menu, "ScrollBar" )
	ListPanel_InitPanel( file.groundList, OnBindListItem, GetGroundItemDef, Survival_CommonButtonInit )
	ListPanel_SetExclusiveSelection( file.groundList, true )
	ListPanel_InitScrollBar( file.groundList, file.groundScrollBar )
	ListPanel_SetButtonHandler( file.groundList, UIE_CLICK, OnGroundItemClick )
	ListPanel_SetButtonHandler( file.groundList, UIE_CLICKRIGHT, OnGroundItemAltClick )
	ListPanel_SetButtonHandler( file.groundList, UIE_GET_FOCUS, OnGroundItemGetFocus )
	ListPanel_SetButtonHandler( file.groundList, UIE_LOSE_FOCUS, OnGroundItemLoseFocus )
	ListPanel_SetKeyPressHandler( file.groundList, OnGroundItemKeyPress )
	ListPanel_SetScrollCallback( file.groundList, OnGroundListScroll )
	ListPanel_SetItemHeightCallback( file.groundList, GetGroundListItemHeight )
	ListPanel_SetItemHeaderCheckCallback( file.groundList, GetGroundListItemIsHeader )

	AddMenuEventHandler( menu, eUIEvent.MENU_INPUT_MODE_CHANGED, OnSurvivalGroundListMenu_InputModeChanged )
	Survival_AddPassthroughCommandsToMenu( menu )

	ListPanel_SetCommandHandler( file.groundList, OnGroundListCommand )

	AddMenuFooterOption( menu, LEFT, KEY_TAB, true, "", "", TryCloseSurvivalInventory, PROTO_ShouldInventoryFooterHack )

	file.quickSwapBacker = Hud_GetChild( menu, "QuickSwapBacker" )
	file.holdToUseElem = Hud_GetChild( menu, "HoldToUseElem" )

	file.quickSwapGrid = Hud_GetChild( menu, "QuickSwapGrid" )
	GridPanel_Init( file.quickSwapGrid, INVENTORY_ROWS, INVENTORY_COLS, OnBindQuickSwapItem, GetInventoryItemCount, Survival_CommonButtonInit )
	GridPanel_SetButtonHandler( file.quickSwapGrid, UIE_CLICK, OnQuickSwapItemClick )
	GridPanel_SetButtonHandler( file.quickSwapGrid, UIE_CLICKRIGHT, OnQuickSwapItemClickRight )

	GridPanel_SetCommandHandler( file.quickSwapGrid, OnQuickSwapMenuCommand )

	file.quickSwapHeader = Hud_GetChild( menu, "QuickSwapHeader" )
	RuiSetString( Hud_GetRui( file.quickSwapHeader ), "headerText", "#PROMPT_QUICK_SWAP" )

	file.groundHeader = Hud_GetChild( menu, "GroundHeader" )
	RuiSetString( Hud_GetRui( file.groundHeader ), "headerText", "#HEADER_GROUND" )

	file.inventorySwapIcon = Hud_GetChild( menu, "SwapIcon" )
	RuiSetImage( Hud_GetRui( file.inventorySwapIcon ), "basicImage", $"rui/hud/loot/loot_swap_icon" )

	AddMenuFooterOption( menu, RIGHT, BUTTON_B, true, "#B_BUTTON_CLOSE", "#CLOSE" )

	var weaponSwapButton = Hud_GetChild( menu, "WeaponSwapButton" )
	var rui = Hud_GetRui( weaponSwapButton )
	RuiSetImage( rui, "iconImage", $"rui/hud/loot/weapon_swap_icon" )
	//
	RuiSetInt( rui, "lootTier", 1 )
	Hud_AddEventHandler( weaponSwapButton, UIE_CLICK, OnWeaponSwapButtonClick )
}

void function OnSurvivalGroundListMenu_Open()
{
	file.swappedItemSlot = -1
	file.guidOverride = ""

	ListPanel_SetActive( file.groundList, true )

	UpdateGroundListMenu()
	ListPanel_ScrollListPaneltoIndex( file.groundList, 0 )
	RunClientScript( "UICallback_GroundlistOpened" )
	ListPanel_FocusFirstItem( file.groundList, true )
	thread Delayed_SetCursorToObject( file.groundHeader )

	RunClientScript( "UICallback_SetGroundMenuHeaderToPlayerName", file.groundHeader )
}


void function OnSurvivalGroundListMenu_Show()
{
	SetMenuReceivesCommands( file.menu, PROTO_Survival_DoInventoryMenusUseCommands() && !IsControllerModeActive() )

	SetBlurEnabled( false )
}

void function OnSurvivalGroundListMenu_InputModeChanged()
{
	SetMenuReceivesCommands( file.menu, PROTO_Survival_DoInventoryMenusUseCommands() && !IsControllerModeActive() )
}

void function Delayed_SetCursorToObject( var obj )
{
	Signal( uiGlobal.signalDummy, "Delayed_SetCursorToObject" )
	EndSignal( uiGlobal.signalDummy, "Delayed_SetCursorToObject" )

	wait 0.1 // TODO: Why do we need this?

	float width  = 1920
	float height = 1080

	UISize screenSize = GetScreenSize()
	float x = float( Hud_GetAbsX( obj ) + Hud_GetWidth( obj )/2 ) / screenSize.width
	float y = float( Hud_GetAbsY( obj ) + Hud_GetHeight( obj )/2 ) / screenSize.height

	SetCursorPosition( <width * x, height * y, 0> )
}

void function UpdateGroundListMenu()
{
	ListPanel_Refresh( file.groundList )
	GridPanel_Refresh( file.quickSwapGrid )
}

void function OnSurvivalGroundListMenu_Close()
{
	ListPanel_SetActive( file.groundList, false )

	HideInventoryGridPanel( true )

	file.selectedGroundItemEntIndex = -1
	file.selectedGroundItemPosition = -1

	ListPanel_ClearSelection( file.groundList )

	SetBlurEnabled( false )
	RunClientScript( "UICallback_GroundlistClosed" )
}

void function OnSurvivalGroundListMenu_NavBack()
{
	if ( file.groundListSelected != null )
	{
		ListPanel_OnListButtonClick( file.groundListSelected )
		return
	}

	CloseActiveMenu()
}

void function CloseSurvivalGroundListMenu()
{
}

void function OnBindListItem( var panel, var button, int position )
{
	if ( !IsConnected() )
		return


	if ( IsLobby() )
		return

	Hud_ClearToolTipData( button )
	RunClientScript( "UICallback_UpdateGroundItem", button, position )
}

void function OnGroundItemClick( var panel, var button, int position )
{
	if ( file.groundItemUpdateInProgress )
		return

	// close quick swap
	if ( Hud_IsSelected( button ) )
	{
		file.groundListSelected = null

		file.selectedGroundItemEntIndex = -1
		file.selectedGroundItemPosition = -1

		Hud_SetToolTipData( button, file.groundListSavedTooltipData )
		HideInventoryGridPanel()
		Hud_SetSelected( button, false )
		return
	}

	if ( IsLobby() )
		return

	if ( IsConnected() )
		RunClientScript( "UICallback_GroundItemAction", button, position, false )
}

void function ClientCallback_StartGroundItemExtendedUse( var button, int position, float duration )
{
	thread StartGroundItemExtendedUse( button, position, duration )
}

void function StartGroundItemExtendedUse( var button, int position, float duration )
{
	Signal( uiGlobal.signalDummy, "StartGroundItemExtendedUse" )
	EndSignal( uiGlobal.signalDummy, "StartGroundItemExtendedUse" )

	var elem = file.holdToUseElem
	Hud_Show( elem )
	HideGameCursor()

	var rui = Hud_GetRui( elem )
	RuiSetBool( rui, "isVisible", true )
	RuiSetGameTime( rui, "startTime", Time() )
	RuiSetFloat( rui, "duration", duration )

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

	while ( ( InputIsButtonDown( MOUSE_LEFT ) || InputIsButtonDown( BUTTON_A ) ) && Time() < uiEndTime && ( GetMouseFocus() == button || GetDpadNavigationActive() ) )
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
		RunClientScript( "UICallback_GroundItemAction", button, position, true )
}

void function OnGroundItemAltClick( var panel, var button, int position )
{
	if ( IsLobby() )
		return

	if ( IsConnected() )
		RunClientScript( "UICallback_GroundItemAltAction", button, position )
}

void function GroundItem_OpenQuickSwap( var button, int position, int guid )
{
	Hud_SetSelected( button, true )

	file.groundListSelected = button
	file.selectedGroundItemEntIndex = file.guidOverride == "" ? guid : int( file.guidOverride )
	file.selectedGroundItemPosition = position

	GridPanel_Refresh( file.quickSwapGrid )
	ShowInventoryGridPanel()

	if ( Hud_HasToolTipData( button ) )
	{
		file.groundListSavedTooltipData = Hud_GetToolTipData( button )
		Hud_ClearToolTipData( button )
	}

	int buttonY    = Hud_GetY( button ) + (Hud_GetHeight( button ) / 2)
	int gridHeight = Hud_GetHeight( file.quickSwapGrid )
	int listAbsY   = Hud_GetAbsY( file.groundList )

	int gridOffset = -buttonY + (gridHeight / 2)

	Hud_SetY( file.quickSwapGrid, gridOffset )

	if ( GetDpadNavigationActive() )
		Hud_SetFocused( Hud_GetChild( file.quickSwapGrid, "GridButton0x0" ) )

	int gridWidth = Hud_GetWidth( file.quickSwapGrid )

	Hud_SetSize( file.quickSwapHeader, gridWidth, 64 )
	Hud_SetSize( file.quickSwapBacker, gridWidth, gridHeight )
}

void function OnGroundListScroll( var panel, float scrollValue )
{
	float timeSinceLastScroll = Time() - file.lastScrollTime

	float scrollScalar = GraphCapped( timeSinceLastScroll, 0.0, 0.5, 1.0, 0.0 )
	file.trackedScrollValue = ( file.trackedScrollValue * scrollScalar ) + fabs( scrollValue )

	file.lastScrollTime = Time()

	if ( file.trackedScrollValue > 7.0 )
		RunClientScript( "GroundListUpdateNextFrame" )
}


bool function OnGroundItemKeyPress( var panel, var button, int position, int keyId, bool isDown )
{
	if ( !isDown )
		return false


	if ( IsLobby() )
		return false

	if ( ButtonIsBoundToPing( keyId ) )
	{
		if ( IsFullyConnected() )
			RunClientScript( "UICallback_PingGroundListItem", button, position )
		return true
	}

	return false
}


void function OnGroundItemGetFocus( var panel, var button, int position )
{
}


void function OnGroundItemLoseFocus( var panel, var button, int position )
{
}

void function OnBindQuickSwapItem( var panel, var button, int index )
{
	if ( !IsConnected() )
		return

	if ( IsLobby() )
		return

	int position = TranslateBackpackGridPosition( index )
	Hud_ClearToolTipData( button )

	RunClientScript( "UICallback_UpdateQuickSwapItem", button, position )
}

void function OnQuickSwapItemClick( var panel, var button, int index )
{
	if ( !IsConnected() )
		return

	if ( IsLobby() )
		return

	int position = TranslateBackpackGridPosition( index )

	RunClientScript( "UICallback_OnQuickSwapItemClick", button, position )
}

void function OnQuickSwapItemClickRight( var panel, var button, int index )
{
	if ( !IsConnected() )
		return

	if ( IsLobby() )
		return


	int position = TranslateBackpackGridPosition( index )

	RunClientScript( "UICallback_OnQuickSwapItemClickRight", button, position )
}


void function ShowInventoryGridPanel()
{
	Hud_Show( file.quickSwapGrid )
	Hud_Show( file.quickSwapHeader )
	Hud_Show( file.inventorySwapIcon )
	Hud_Show( file.quickSwapBacker )

	file.quickInventoryGridPanelShowing = true
}


void function HideInventoryGridPanel( bool isClosingTopPanel = false )
{
	file.quickInventoryGridPanelShowing = false

	Hud_Hide( file.quickSwapGrid )
	Hud_Hide( file.quickSwapHeader )
	Hud_Hide( file.inventorySwapIcon )
	Hud_Hide( file.quickSwapBacker )

	if ( file.closeOnQuickSwapClose )
	{
		file.closeOnQuickSwapClose = false
		if ( !isClosingTopPanel )
			CloseActiveMenu()
	}

	file.groundListSelected = null
}

void function OpenSurvivalGroundListMenu( bool playerIsTitan )
{
	CloseAllMenus()
	AdvanceMenu( file.menu )
}

void function SurvivalQuickInventory_DoQuickSwap( int backpackSlot, int deathBoxEntIndex )
{
	SurvivalGroundList_DoQuickSwap( backpackSlot, deathBoxEntIndex )
	SurvivalQuickSwapMenu_DoQuickSwap( backpackSlot, deathBoxEntIndex )
}

void function SurvivalGroundList_DoQuickSwap( int backpackSlot, int deathBoxEntIndex )
{
	if ( GetActiveMenu() != file.menu )
		return

	if ( file.selectedGroundItemEntIndex == -1 )
		return

	string boxString = ""
	if ( deathBoxEntIndex > -1 )
	{
		boxString = " " + deathBoxEntIndex
	}

	if ( backpackSlot >= 0 )
		ClientCommand( "SwapSurvivalItem " + backpackSlot + " " + file.selectedGroundItemEntIndex + boxString )
	else
		ClientCommand( "PickupSurvivalItem " + file.selectedGroundItemEntIndex + " 0 " + boxString )

	file.selectedGroundItemEntIndex = -1
	file.selectedGroundItemPosition = -1

	file.swappedItemSlot = file.selectedGroundItemPosition

	SurvivalMenu_OnAction()
	HideInventoryGridPanel()
	ListPanel_ClearSelection( file.groundList )
}

void function SurvivalGroundItem_BeginUpdate()
{
	file.groundItemUpdateInProgress = true
}

void function SurvivalGroundItem_EndUpdate()
{
	file.groundItemUpdateInProgress = false
	UpdateGroundListMenu()
}

void function OnWeaponSwapButtonClick( var button )
{
	if ( IsLobby() )
		return

	if ( IsFullyConnected() )
		RunClientScript( "UICallback_WeaponSwap" )
}

float function GetGroundListItemHeight( var panel, int index )
{
	return SurvivalGroundItem_IsHeader( index ) ? 0.5 : 1.0
}

bool function GetGroundListItemIsHeader( var panel, int index )
{
	return SurvivalGroundItem_IsHeader( index )
}