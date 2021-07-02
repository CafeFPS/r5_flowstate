global function InitSurvivalInventoryMenu

global function OpenSurvivalInventoryMenu
global function CloseSurvivalInventoryMenu

global function SurvivalMenuSwapWeapon
global function SurvivalMenuSwapToMelee
global function SurvivalMenuSwapToOrdnance
global function IsSurvivalMenuEnabled
global function Survival_PlayerIsTitan
global function Survival_SetPlayerIsTitan
global function Survival_PlayerIsRodeoing
global function Survival_SetPlayerIsRodeoing
global function Survival_CanPlayerUseTitanItem

global function SurvivalMenu_OnAction
global function SurvivalMenu_AckAction

global function SurvivalInventoryMenu_SetInventoryLimit
global function SurvivalInventoryMenu_GetInventoryLimit
global function SurvivalInventoryMenu_SetInventoryLimitMax
global function SurvivalInventoryMenu_GetInventoryLimitMax
global function SurvivalInventoryMenu_GetMaxInventoryLimit
global function SurvivalInventoryMenu_BeginUpdate
global function SurvivalInventoryMenu_EndUpdate

global function TryCloseSurvivalInventory
global function TryCloseSurvivalInventoryFromDamage

global function SURVIVAL_GetMaxInventoryLimit
global function SURVIVAL_GetInventoryLimit

global function Survival_RegisterInventoryMenu

global function PROTO_Survival_DoInventoryMenusUseCommands
global function PROTO_ShouldInventoryFooterHack
global function Survival_AddPassthroughCommandsToMenu
global function SURVIVAL_IsAnInventoryMenuOpened

global function SurvivalInventory_SetBGVisible

struct
{
	var  menu
	bool playerIsTitan
	bool playerIsRodeoing

	var quickInventoryPanel
	var characterDetailsPanel

	int inventoryLimit
	int maxInventoryLimit

	float menuOpenTime

	bool tabsInitialized = false

	array<var> inventoryMenus
} file

void function InitSurvivalInventoryMenu( var newMenuArg )
{
	var menu = GetMenu( "SurvivalInventoryMenu" )
	file.menu = menu

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnSurvivalInventoryMenu_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnSurvivalInventoryMenu_NavBack )
	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, OnSurvivalInventoryMenu_Show )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnSurvivalInventoryMenu_Close )

	AddMenuEventHandler( menu, eUIEvent.MENU_INPUT_MODE_CHANGED, OnSurvivalInventory_OnInputModeChange )
	Survival_AddPassthroughCommandsToMenu( menu )
	Survival_RegisterInventoryMenu( menu )

	file.quickInventoryPanel = GetPanel( "SurvivalQuickInventoryPanel" )

	HudElem_SetChildRuiArg( Hud_GetChild( menu, "TabsCommon" ), "Background" , "bgColor", <0,0,0>, eRuiArgType.VECTOR )
	HudElem_SetChildRuiArg( Hud_GetChild( menu, "TabsCommon" ), "Background" , "bgAlpha", 1.6, eRuiArgType.FLOAT )

	SetTabRightSound( menu, "UI_InGame_InventoryTab_Select" )
	SetTabLeftSound( menu, "UI_InGame_InventoryTab_Select" )
}


bool function PROTO_Survival_DoInventoryMenusUseCommands()
{
	return GetCurrentPlaylistVarBool( "survival_menus_use_commands", true )
}

bool function PROTO_ShouldInventoryFooterHack()
{
	return IsSurvivalMenuEnabled() && !PROTO_Survival_DoInventoryMenusUseCommands()
}

void function Survival_AddPassthroughCommandsToMenu( var menu )
{
	AddCommandForMenuToPassThrough( menu, "+forward" )
	AddCommandForMenuToPassThrough( menu, "+backward" )
	AddCommandForMenuToPassThrough( menu, "+moveleft" )
	AddCommandForMenuToPassThrough( menu, "+moveright" )
	AddCommandForMenuToPassThrough( menu, "+duck" )
	AddCommandForMenuToPassThrough( menu, "+toggle_duck" )
	AddCommandForMenuToPassThrough( menu, "+jump" )
	AddCommandForMenuToPassThrough( menu, "+speed" )
	AddCommandForMenuToPassThrough( menu, "+reload" )
	AddCommandForMenuToPassThrough( menu, "+weaponcycle" )
	AddCommandForMenuToPassThrough( menu, "+pushtotalk" )

	AddCommandForMenuToPassThrough( menu, "weaponSelectPrimary0" )
	AddCommandForMenuToPassThrough( menu, "weaponSelectPrimary1" )
	AddCommandForMenuToPassThrough( menu, "weaponSelectPrimary2" )
	AddCommandForMenuToPassThrough( menu, "weaponSelectOrdnance" )
	AddCommandForMenuToPassThrough( menu, "+scriptCommand4" )
	AddCommandForMenuToPassThrough( menu, "Sur_UseHealthPack" )
	AddCommandForMenuToPassThrough( menu, "weapon_inspect" )
	AddCommandForMenuToPassThrough( menu, "toggle_inventory" )
	AddCommandForMenuToPassThrough( menu, "toggle_map" )
	AddCommandForMenuToPassThrough( menu, "+scriptCommand3" )
	AddCommandForMenuToPassThrough( menu, "say_team" )
}


void function SurvivalInventoryMenu_Clear()
{
}


void function SurvivalMenu_OnAction()
{
	Hud_SetEnabled( GetPanel( "SurvivalQuickInventoryPanel" ), false )
	Hud_Show( Hud_GetChild( file.quickInventoryPanel, "BUSYBLOCKER" ) )
}


void function SurvivalMenu_AckAction()
{
	Hud_SetEnabled( GetPanel( "SurvivalQuickInventoryPanel" ), true )
	Hud_Hide( Hud_GetChild( file.quickInventoryPanel, "BUSYBLOCKER" ) )
}


void function OpenSurvivalInventoryMenu( bool playerIsTitan )
{
	file.playerIsTitan = playerIsTitan
	CloseAllMenus()
	AdvanceMenu( file.menu )

	TabData tabData = GetTabDataForPanel( file.menu )
	ActivateTab( tabData, 0 )
}


void function OnSurvivalInventoryMenu_Open()
{

	if ( !file.tabsInitialized )
	{
		TabData tabData = GetTabDataForPanel( file.menu )
		tabData.centerTabs = true
		AddTab( file.menu, file.quickInventoryPanel, "#INVENTORY_TITLE" )
		AddTab( file.menu, Hud_GetChild( file.menu, "SquadPanel" ), "BUG THIS" )
		AddTab( file.menu, Hud_GetChild( file.menu, "CharacterDetailsPanel" ), "#LEGEND" )
		file.tabsInitialized = true
	}

	TabData squadData = GetTabDataForPanel( file.menu )
	TabDef squadDef   = Tab_GetTabDefByBodyName( squadData, "SquadPanel" )
	if ( IsSoloMode() )
		squadDef.title = "#STATS"
	else
		squadDef.title = "#SQUAD"

	SetTabNavigationEnabled( file.menu, true )
	EmitUISound( "UI_InGame_Inventory_Open" )

	file.menuOpenTime = Time()

	UISize screenSize = GetScreenSize()
	SetCursorPosition( <1920.0 * 0.5, 1080.0 * 0.5, 0> )
}


void function OnSurvivalInventoryMenu_Show()
{
	SetMenuReceivesCommands( file.menu, PROTO_Survival_DoInventoryMenusUseCommands() && !IsControllerModeActive() )
}


void function OnSurvivalInventory_OnInputModeChange()
{
	SetMenuReceivesCommands( file.menu, PROTO_Survival_DoInventoryMenusUseCommands() && !IsControllerModeActive() )
}


void function OnSurvivalInventoryMenu_Close()
{
	HidePanel( GetPanel( "SurvivalQuickInventoryPanel" ) )
	SetBlurEnabled( false )
}


void function OnSurvivalInventoryMenu_NavBack()
{
	var panel = GetPanel( "SurvivalQuickInventoryPanel" )
	if ( Hud_IsVisible( panel ) )
	{
		SurvivalQuickInventory_NavigateBack()
		return
	}

	CloseActiveMenu()
}


void function CloseSurvivalInventoryMenu()
{
	if ( GetActiveMenu() == file.menu )
	{
		CloseAllMenus()
	}
}

void function SurvivalMenuSwapWeapon( var button )
{
	if ( Time() > file.menuOpenTime + 0.1 )
		RunClientScript( "Survival_SwapPrimary" )
}

void function SurvivalMenuSwapToMelee( var button )
{
	if ( Time() > file.menuOpenTime + 0.1 )
		RunClientScript( "Survival_SwapToMelee" )
}

void function SurvivalMenuSwapToOrdnance( var button )
{
	if ( Time() > file.menuOpenTime + 0.1 )
		RunClientScript( "Survival_SwapToOrdnance" )
}

bool function IsSurvivalMenuEnabled()
{
	return GetCurrentPlaylistVarInt( "survival_menu_enabled", 1 ) == 1
}


void function Survival_SetPlayerIsTitan( bool value )
{
	file.playerIsTitan = value
}


bool function Survival_PlayerIsTitan()
{
	return file.playerIsTitan
}


void function Survival_SetPlayerIsRodeoing( bool value )
{
	file.playerIsRodeoing = value
}


bool function Survival_PlayerIsRodeoing()
{
	return file.playerIsRodeoing
}


bool function Survival_CanPlayerUseTitanItem()
{
	return file.playerIsTitan || file.playerIsRodeoing
}

//
void function SurvivalInventoryMenu_SetInventoryLimit( int limit )
{
	file.inventoryLimit = limit
}


int function SurvivalInventoryMenu_GetInventoryLimit()
{
	return file.inventoryLimit
}

void function SurvivalInventoryMenu_SetInventoryLimitMax( int limitMax )
{
	file.maxInventoryLimit = limitMax
}


int function SurvivalInventoryMenu_GetInventoryLimitMax()
{
	return file.maxInventoryLimit
}

int function SurvivalInventoryMenu_GetMaxInventoryLimit()
{
	return SURVIVAL_GetMaxInventoryLimit( GetUIPlayer() )
}


void function SurvivalInventoryMenu_BeginUpdate()
{
	if ( GetActiveMenu() == file.menu )
	{
		SurvivalInventoryMenu_Clear()
	}
}


void function SurvivalInventoryMenu_EndUpdate()
{
	if ( GetActiveMenu() == file.menu )
	{
		SurvivalQuickInventory_OnUpdate()

		if( !GetDpadNavigationActive() )
			ForceVGUIFocusUpdate()
	}

	UpdateQuickSwapMenu()
}

void function TryCloseSurvivalInventoryFromDamage( var button )
{
	if ( SURVIVAL_IsAnInventoryMenuOpened() )
	{
		CloseActiveMenu()
		if ( IsFullyConnected() )
		{
			RunClientScript( "UICallback_BlockPingForDuration", 0.5 )
		}
	}
}

void function TryCloseSurvivalInventory( var button )
{
	if ( SURVIVAL_IsAnInventoryMenuOpened() )
		CloseActiveMenu()
}

int function SURVIVAL_GetMaxInventoryLimit( entity player )
{
	return SurvivalInventoryMenu_GetInventoryLimitMax()
}


int function SURVIVAL_GetInventoryLimit( entity player )
{
	return SurvivalInventoryMenu_GetInventoryLimit()
}

void function Survival_RegisterInventoryMenu( var menu )
{
	file.inventoryMenus.append( menu )
}

bool function SURVIVAL_IsAnInventoryMenuOpened()
{
	foreach ( var wtf in file.inventoryMenus )
	{
		if ( wtf == GetActiveMenu() || IsPanelActive( wtf ) )
			return true
	}

	return false
}

void function SurvivalInventory_SetBGVisible( bool visible )
{
	Hud_SetVisible( Hud_GetChild( file.menu, "Blur" ), visible )
	Hud_SetVisible( Hud_GetChild( file.menu, "Cover" ), visible )
}