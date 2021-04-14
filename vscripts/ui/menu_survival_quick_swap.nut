global function InitQuickSwapMenu
global function OpenSurvivalQuickSwapMenu
global function SurvivalQuickInventory_OpenSwapForItem
global function SurvivalQuickSwapMenu_DoQuickSwap
global function UpdateQuickSwapMenu

struct
{
	var menu

	var quickSwapGrid
	var quickSwapHeader
	var swapButton

	int selectedGroundItemEntIndex = -1
} file

void function InitQuickSwapMenu()
{
	RegisterSignal( "Delayed_SetCursorToObject" )

	var menu = GetMenu( "SurvivalQuickSwapMenu" )
	file.menu = menu
	Survival_RegisterInventoryMenu( menu )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnSurvivalQuickSwapMenu_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnSurvivalQuickSwapMenu_NavBack )
	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, OnSurvivalQuickSwapMenu_Show )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnSurvivalQuickSwapMenu_Close )

	AddMenuFooterOption( menu, LEFT, BUTTON_Y, true, "", "", SurvivalMenuSwapWeapon, IsSurvivalMenuEnabled )
	AddMenuFooterOption( menu, LEFT, BUTTON_DPAD_UP, true, "", "", TryCloseSurvivalInventory, IsSurvivalMenuEnabled )
	AddMenuFooterOption( menu, LEFT, KEY_TAB, true, "", "", TryCloseSurvivalInventory, IsSurvivalMenuEnabled )

	file.quickSwapGrid = Hud_GetChild( menu, "QuickSwapGrid" )
	GridPanel_Init( file.quickSwapGrid, INVENTORY_ROWS, INVENTORY_COLS, OnBindQuickSwapItem, GetInventoryItemCount, Survival_CommonButtonInit )
	GridPanel_SetButtonHandler( file.quickSwapGrid, UIE_CLICK, OnQuickSwapItemClick )
	GridPanel_SetButtonHandler( file.quickSwapGrid, UIE_CLICKRIGHT, OnQuickSwapItemClickRight )

	file.quickSwapHeader = Hud_GetChild( menu, "QuickSwapHeader" )
	RuiSetString( Hud_GetRui( file.quickSwapHeader ), "headerText", "#PROMPT_QUICK_SWAP" )

	var inventorySwapIcon = Hud_GetChild( menu, "SwapIcon" )
	RuiSetImage( Hud_GetRui( inventorySwapIcon ), "basicImage", $"rui/hud/loot/loot_swap_icon" )

	file.swapButton = Hud_GetChild( menu, "SwapButton" )
	Hud_SetSelected( file.swapButton, true )
}

void function OnSurvivalQuickSwapMenu_Open()
{
	UpdateSwapButton()
	GridPanel_Refresh( file.quickSwapGrid )
	Hud_Show( file.quickSwapGrid )
	RunClientScript( "UICallback_GroundlistOpened" )
}


void function OnSurvivalQuickSwapMenu_Show()
{
	SetBlurEnabled( false )
}

void function UpdateQuickSwapMenu()
{
	if ( GetActiveMenu() == file.menu )
	{
		UpdateSwapButton()
		GridPanel_Refresh( file.quickSwapGrid )
	}
}

void function OnSurvivalQuickSwapMenu_Close()
{
	SetBlurEnabled( false )
	file.selectedGroundItemEntIndex = -1
	RunClientScript( "UICallback_GroundlistClosed" )
}

void function OnSurvivalQuickSwapMenu_NavBack()
{
	CloseActiveMenu()
}

void function CloseSurvivalQuickSwapMenu()
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

void function OpenSurvivalQuickSwapMenu( int groundItemEntIndex )
{
	file.selectedGroundItemEntIndex = groundItemEntIndex
	CloseAllMenus()
	AdvanceMenu( file.menu )
}

void function SurvivalQuickSwapMenu_DoQuickSwap( int backpackSlot, int deathBoxEntIndex )
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

	CloseAllMenus()
}

void function SurvivalQuickInventory_OpenSwapForItem( string guid )
{
	OpenSurvivalQuickSwapMenu( int( guid ) )
}

void function UpdateSwapButton()
{
	RunClientScript( "UICallback_UpdateQuickSwapItemButton", file.swapButton, file.selectedGroundItemEntIndex )
}