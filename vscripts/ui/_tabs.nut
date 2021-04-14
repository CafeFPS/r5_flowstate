global function InitTabs
global function AddTab
global function ClearTabs
global function IsTabActive
global function ActivateTab
global function DeactivateTab
global function GetMenuActiveTabIndex
global function GetTabDataForPanel
global function GetMenuNumTabs
global function UpdateMenuTabs
global function RegisterTabNavigationInput
global function DeregisterTabNavigationInput
global function ShowPanel
global function ShowPanelInternal
global function HidePanel
global function HidePanelInternal
global function ShutdownAllPanels
global function IsPanelTabbed
global function SetPanelTabEnabled
global function SetPanelTabNew
global function IsTabIndexEnabled
global function IsTabPanelActive
global function _HasActiveTabPanel
global function _GetActiveTabPanel
global function _OnTab_NavigateBack
global function SetTabRightSound
global function SetTabLeftSound
global function Tab_GetTabIndexByBodyName
global function Tab_GetTabDefByBodyName
global function SetTabNavigationEnabled
global function SetTabNavigationEndCallback

global function GetTabBodyParent

global function GetPanelTabs
global function SetTabDefEnabled

global function ActivateTabNext
global function ActivateTabPrev

global function GetTabForTabButton

global const int INVALID_TAB_INDEX = -1
global struct TabData
{
	var             parentPanel
	var             tabPanel
	array<var>      tabButtons
	array<TabDef>   tabDefs
	int             tabIndex = INVALID_TAB_INDEX
	string          tabRightSound = "UI_Menu_ApexTab_Select"
	string          tabLeftSound = "UI_Menu_ApexTab_Select"
	bool            tabNavigationDisabled = false

	table<int, void functionref()> tabNavigationEndCallbacks
}

struct
{
	int                 tabWidth
	table<var, TabData> elementTabData
	table<var, var>     tabButtonParents

	table<var, TabDef> tabBodyDefMap
} file

const MAX_TABS = 8

global enum eTabDirection
{
	PREV
	NEXT
}

// TODO: Move to be a single call per menu in standard init for all menus (also, apply the same organization to InitFooterOptions())
void function InitTabs()
{
	foreach ( menu in uiGlobal.allMenus )
	{
		array<var> tabButtonPanels = GetElementsByClassname( menu, "TabsCommonClass" )
		foreach ( tabButtonPanel in tabButtonPanels )
		{
			var parentPanel = Hud_GetParent( tabButtonPanel )
			Assert( !(parentPanel in file.elementTabData) )
			bool isMenu = parentPanel == GetParentMenu( parentPanel )
			Assert( isMenu || parentPanel in uiGlobal.panelData, "Panel " + Hud_GetHudName( parentPanel ) + " not initialized with AddPanel()" )
			TabData tabData
			tabData.parentPanel = parentPanel
			tabData.tabPanel = tabButtonPanel
			tabData.tabNavigationEndCallbacks[eTabDirection.PREV] <- null
			tabData.tabNavigationEndCallbacks[eTabDirection.NEXT] <- null
			file.elementTabData[parentPanel] <- tabData

			array<var> tabButtons = GetElementsByClassname( menu, "TabButtonClass" )

			foreach ( tabButton in tabButtons )
			{
				var tabButtonParent = Hud_GetParent( tabButton )
				if ( tabButtonParent != tabButtonPanel )
					continue

				tabData.tabButtons.append( tabButton )

				Hud_AddEventHandler( tabButton, UIE_CLICK, OnTab_Activate )
				Hud_AddEventHandler( tabButton, UIE_GET_FOCUS, OnTab_GetFocus )
				Hud_AddEventHandler( tabButton, UIE_LOSE_FOCUS, OnTab_LoseFocus )
				Hud_Hide( tabButton )

				file.tabButtonParents[tabButton] <- parentPanel
			}
		}
	}

	AddMenuVarChangeHandler( "isFullyConnected", UpdateMenuTabs )
	AddMenuVarChangeHandler( "isGamepadActive", UpdateMenuTabs )
}


TabDef function GetTabForTabButton( var button )
{
	TabDef tabDef
	return tabDef
}


TabDef function GetTabForTabBody( var body )
{
	return file.tabBodyDefMap[body]
}


array<TabDef> function GetPanelTabs( var panel )
{
	TabData tabData = GetTabDataForPanel( panel )

	return tabData.tabDefs
}


TabDef function AddTab( var parentPanel, var panel, string tabTitle )
{
	TabData tabData = GetTabDataForPanel( parentPanel )

	TabDef data
	data.button = tabData.tabButtons[tabData.tabDefs.len()]
	data.panel = panel
	data.title = tabTitle
	data.parentPanel = parentPanel

	file.tabBodyDefMap[data.panel] <- data

	Hud_Show( data.button )

	file.elementTabData[parentPanel].tabDefs.append( data )
	if ( file.elementTabData[parentPanel].tabDefs.len() == 1 )
		file.elementTabData[parentPanel].tabIndex = 0

	return data
}


TabData function GetTabDataForPanel( var element )
{
	return file.elementTabData[element]
}


void function ClearTabs( var menu )
{
	TabData tabData = GetTabDataForPanel( menu )

	if ( tabData.tabIndex != INVALID_TAB_INDEX )
		DeactivateTab( tabData )

	tabData.tabDefs.clear()
	tabData.tabIndex = INVALID_TAB_INDEX
}


int function Tab_GetTabIndexByBodyName( TabData tabData, string bodyName )
{
	foreach ( index, tabDef in tabData.tabDefs )
	{
		if ( Hud_GetHudName( tabDef.panel ) != bodyName )
			continue

		return index
	}

	return -1
}

TabDef function Tab_GetTabDefByBodyName( TabData tabData, string bodyName )
{
	foreach ( index, tabDef in tabData.tabDefs )
	{
		if ( Hud_GetHudName( tabDef.panel ) != bodyName )
			continue

		return tabDef
	}

	Assert( false )

	unreachable
}

void function SetTabNavigationEndCallback( TabData tabData, int tabSide, void functionref() callbackFunc )
{
	tabData.tabNavigationEndCallbacks[tabSide] <- callbackFunc
}

bool function IsTabActive( TabData tabData )
{
	var panel = tabData.tabDefs[tabData.tabIndex].panel
	return uiGlobal.panelData[panel].isActive
}

// TODO: Need this to cause open/close and footer update
// AddMenuEventHandler() and AddMenuFooterOption() has to be different for tab panels
// AddPanelFooterOption()? This needs more thought. The panel needs to affect the footer options of it's parent, so these setup functions need to work differently for panels.
void function ActivateTab( TabData tabData, int tabIndex )
{
	if ( !CanNavigateFromActiveTab( tabData, tabIndex ) )
		return

	array<TabDef> tabDefs = tabData.tabDefs
	int oldTabIndex       = tabData.tabIndex
	tabData.tabIndex = tabIndex

	UpdateMenuTabs()

	var panel = tabDefs[ tabIndex ].panel
	if ( panel == null )
		return

	HideVisibleTabBodies( tabData )
	ShowPanel( panel )
}


void function HideVisibleTabBodies( TabData tabData )
{
	foreach ( tabDef in tabData.tabDefs )
		HidePanel( tabDef.panel )
}


void function DeactivateTab( TabData tabData )
{
	HidePanel( tabData.tabDefs[tabData.tabIndex].panel )
}


int function GetMenuActiveTabIndex( var menu )
{
	return GetTabDataForPanel( menu ).tabIndex
}


int function GetMenuNumTabs( var menu )
{
	return GetTabDataForPanel( menu ).tabDefs.len()
}


void function ShowPanel( var panel )
{
	if ( uiGlobal.panelData[ panel ].isActive )
		return

	uiGlobal.panelData[ panel ].isActive = true

	if ( uiGlobal.panelData[ panel ].isCurrentlyShown )
		return

	if ( IsMenuVisible( panel ) )
		return

	ShowPanelInternal( panel )
}


void function ShowPanelInternal( var panel )
{
	Hud_Show( panel )

	uiGlobal.activePanels.append( panel )
	UpdateFooterOptions()

	Assert( !uiGlobal.panelData[ panel ].isCurrentlyShown )
	uiGlobal.panelData[ panel ].isCurrentlyShown = true
	uiGlobal.panelData[ panel ].enterTime = Time()

	foreach ( showFunc in uiGlobal.panelData[ panel ].showFuncs )
		showFunc( panel )
}


void function HidePanel( var panel )
{
	if ( !uiGlobal.panelData[ panel ].isActive )
		return

	uiGlobal.panelData[ panel ].isActive = false

	if ( !uiGlobal.panelData[ panel ].isCurrentlyShown )
		return

	HidePanelInternal( panel )
}


void function HidePanelInternal( var panel )
{
	Hud_Hide( panel )

	uiGlobal.activePanels.removebyvalue( panel )

	Assert( uiGlobal.panelData[ panel ].isCurrentlyShown )
	uiGlobal.panelData[ panel ].isCurrentlyShown = false
	PIN_PageView( Hud_GetHudName( panel ), Time() - uiGlobal.panelData[ panel ].enterTime, uiGlobal.pin_lastMenuId, false )
	uiGlobal.pin_lastMenuId = Hud_GetHudName( panel )

	foreach ( hideFunc in uiGlobal.panelData[ panel ].hideFuncs )
		hideFunc( panel )
}


void function ShutdownAllPanels()
{
	uiGlobal.activePanels.clear() // todo(dw): aaaaaahhhhh

	foreach ( var panel, PanelDef panelDef in uiGlobal.panelData )
		HidePanel( panel )
}


void function UpdateMenuTabs()
{
	var menu = GetActiveMenu()
	if ( menu == null )
		return

	bool isNestedTabActive = Tab_GetActiveNestedTabData( menu ) != null

	array<var> tabButtonPanels = GetElementsByClassname( menu, "TabsCommonClass" )
	foreach ( tabButtonPanel in tabButtonPanels )
	{
		var parentPanel = Hud_GetParent( tabButtonPanel )
		TabData tabData = GetTabDataForPanel( parentPanel )

		array<TabDef> tabDefs = tabData.tabDefs
		array<var> tabButtons = tabData.tabButtons
		int numTabs           = tabDefs.len()

		int tabWidth = Hud_GetWidth( tabButtons[0] )

		int tabIndex = 0
		while ( tabIndex < numTabs )
		{
			var tab = tabButtons[ tabIndex ]

			if ( tabIndex == tabData.tabIndex )
				Hud_SetSelected( tab, true )
			else
				Hud_SetSelected( tab, false )

			var rui = Hud_GetRui( tab )
			RuiSetString( rui, "buttonText", tabDefs[tabIndex].title )

			Hud_SetEnabled( tab, tabDefs[tabIndex].enabled )
			Hud_SetNew( tab, tabDefs[tabIndex].new )
			if ( tabWidth != 0 )
				Hud_SetWidth( tab, tabWidth )

			if ( Tab_IsRootLevel( tabData ) && isNestedTabActive )
				RuiSetBool( rui, "isInactive", true )
			else
				RuiSetBool( rui, "isInactive", false )

			tabIndex++
		}

		var tabsPanel     = tabData.tabPanel
		var leftShoulder  = Hud_GetChild( tabsPanel, "LeftNavButton" )
		var rightShoulder = Hud_GetChild( tabsPanel, "RightNavButton" )

		if ( GetMenuVarBool( "isGamepadActive" ) && numTabs > 1 )
		{
			string leftText
			string rightText

			//if ( Tab_IsRootLevel( tabData ) )
			{
				leftText = IsGamepadPS4() ? "L1" : "LB"
				rightText = IsGamepadPS4() ? "R1" : "RB"
			}
			//else
			//{
			//	leftText = "LT"
			//	rightText = "RT"
			//}

			SetLabelRuiText( leftShoulder, leftText )
			Hud_SetVisible( leftShoulder, !isNestedTabActive || !Tab_IsRootLevel( tabData ) )

			SetLabelRuiText( rightShoulder, rightText )
			Hud_SetVisible( rightShoulder, !isNestedTabActive || !Tab_IsRootLevel( tabData ) )

			var tab = tabButtons[ tabIndex ]
			Hud_SetPinSibling( rightShoulder, Hud_GetHudName( tab ) )
		}
		else
		{
			SetLabelRuiText( leftShoulder, "" )
			Hud_SetVisible( leftShoulder, false )

			SetLabelRuiText( rightShoulder, "" )
			Hud_SetVisible( rightShoulder, false )
		}

		// Disable empty tabs
		while ( tabIndex < MAX_TABS )
		{
			var tab = tabButtons[ tabIndex ]
			var rui = Hud_GetRui( tab )
			RuiSetString( rui, "buttonText", "" )

			Hud_SetEnabled( tab, false )
			Hud_SetNew( tab, false )
			Hud_SetWidth( tab, 0 )

			tabIndex++
		}
	}
}


bool function Tab_IsRootLevel( TabData tabData )
{
	return tabData.parentPanel == GetParentMenu( tabData.parentPanel )
}


TabData function GetParentTabData( var button )
{
	return file.elementTabData[file.tabButtonParents[button]]
}


void function OnTab_GetFocus( var button )
{
	TabData tabData = GetParentTabData( button )
	int tabIndex    = int( Hud_GetScriptID( button ) )

	if ( !IsTabIndexEnabled( tabData, tabIndex ) )
		return

	UpdateMenuTabs()
}


void function OnTab_LoseFocus( var button )
{
}

bool function CanNavigateFromActiveTab( TabData tabData, int desinationTabIndex )
{
	TabDef tabDef = tabData.tabDefs[tabData.tabIndex]
	if ( tabDef.canNavigateFunc == null )
		return true

	return tabDef.canNavigateFunc( tabData.parentPanel, desinationTabIndex )
}


void function OnTab_Activate( var button )
{
	TabData tabData = GetParentTabData( button )
	int tabIndex    = int( Hud_GetScriptID( button ) )

	if ( !IsTabIndexEnabled( tabData, tabIndex ) )
		return

	if ( tabData.tabNavigationDisabled )
		return

	string animPrefix
	if ( tabIndex < tabData.tabIndex )
		animPrefix = "MoveRight_"
	else if ( tabIndex > tabData.tabIndex )
		animPrefix = "MoveLeft_"
	else
		return // Already on this tab

	//printt( "tabIndex was:", tabIndex, "menu:", Hud_GetHudName( tabsData[ tabIndex ].panel ) )

	ActivateTab( tabData, tabIndex )

	//printt( "tabIndex now:", tabIndex, "menu:", Hud_GetHudName( tabsData[ tabIndex ].panel ) )
}


void function OnMenuTab_NavLeft( var unusedNull )
{
	var menu = GetActiveMenu()
	if ( menu == null )
		return

	if ( IsDialog( menu ) )
		return

	TabData ornull tabData = Tab_GetActiveNestedTabData( menu )
	if ( tabData == null )
	{
		if ( !IsPanelTabbed( menu ) )
			return

		tabData = GetTabDataForPanel( menu )
	}

	expect TabData( tabData )

	if ( tabData.tabNavigationDisabled )
	{
		// allow us to back out even when tabs are disabled
		if ( tabData.tabNavigationEndCallbacks[eTabDirection.PREV] != null )
			tabData.tabNavigationEndCallbacks[eTabDirection.PREV]()

		return
	}

	ActivateTabPrev( tabData )
}


void function ActivateTabPrev( TabData tabData )
{
	int tabIndex = tabData.tabIndex

	while ( tabIndex > 0 )
	{
		tabIndex--
		if ( !IsTabIndexEnabled( tabData, tabIndex ) )
			continue

		EmitUISound( tabData.tabLeftSound )
		ActivateTab( tabData, tabIndex )
		return
	}

	if ( tabIndex == 0 && tabData.tabNavigationEndCallbacks[eTabDirection.PREV] != null )
		tabData.tabNavigationEndCallbacks[eTabDirection.PREV]()

	UpdateMenuTabs()
}


void function ActivateTabNext( TabData tabData )
{
	int tabIndex = tabData.tabIndex

	while ( tabIndex < tabData.tabDefs.len() - 1 )
	{
		tabIndex++
		if ( !IsTabIndexEnabled( tabData, tabIndex ) )
			continue

		EmitUISound( tabData.tabRightSound )
		ActivateTab( tabData, tabIndex )
		return
	}

	if ( tabData.tabNavigationEndCallbacks[eTabDirection.NEXT] != null )
		tabData.tabNavigationEndCallbacks[eTabDirection.NEXT]()

	UpdateMenuTabs()
}


void function OnMenuTab_NavRight( var unusedNull )
{
	var menu = GetActiveMenu()
	if ( menu == null )
		return

	if ( IsDialog( menu ) )
		return

	TabData ornull tabData = Tab_GetActiveNestedTabData( menu )
	if ( tabData == null )
	{
		if ( !IsPanelTabbed( menu ) )
			return

		tabData = GetTabDataForPanel( menu )
	}

	expect TabData( tabData )

	if ( tabData.tabNavigationDisabled )
		return

	ActivateTabNext( tabData )
}


void function SetTabNavigationEnabled( var menu, bool state )
{
	GetTabDataForPanel( menu ).tabNavigationDisabled = !state
}


TabData ornull function Tab_GetActiveNestedTabData( var menu )
{
	array<var> tabButtonPanels = GetElementsByClassname( menu, "TabsCommonClass" )
	foreach ( tabButtonPanel in tabButtonPanels )
	{
		var parentPanel = Hud_GetParent( tabButtonPanel )
		TabData tabData = GetTabDataForPanel( parentPanel )

		if ( Tab_IsRootLevel( tabData ) )
			continue

		if ( !uiGlobal.panelData[ parentPanel ].isActive )
			continue

		return tabData
	}

	return null
}


void function OnNestedTab_NavLeft( var unusedNull )
{
	var menu = GetActiveMenu()
	if ( menu == null )
		return

	if ( IsDialog( menu ) )
		return

	TabData ornull tabData = Tab_GetActiveNestedTabData( menu )
	if ( tabData == null )
		return
	expect TabData( tabData )

	if ( tabData.tabNavigationDisabled )
		return

	int tabIndex = tabData.tabIndex
	while ( tabIndex > 0 )
	{
		tabIndex--
		if ( !IsTabIndexEnabled( tabData, tabIndex ) )
			continue

		EmitUISound( tabData.tabLeftSound )
		ActivateTab( tabData, tabIndex )
		break
	}
}


void function OnNestedTab_NavRight( var unusedNull )
{
	var menu = GetActiveMenu()
	if ( menu == null )
		return

	if ( IsDialog( menu ) )
		return

	TabData ornull tabData = Tab_GetActiveNestedTabData( menu )
	if ( tabData == null )
		return
	expect TabData( tabData )

	if ( tabData.tabNavigationDisabled )
		return

	int tabIndex = tabData.tabIndex

	while ( tabIndex < tabData.tabDefs.len() - 1 )
	{
		tabIndex++
		if ( !IsTabIndexEnabled( tabData, tabIndex ) )
			continue

		EmitUISound( tabData.tabRightSound )
		ActivateTab( tabData, tabIndex )
		break
	}
}


bool function _HasActiveTabPanel( var menu )
{
	if ( menu == null )
		return false

	if ( !(menu in file.elementTabData) )
		return false

	TabData tabData = GetTabDataForPanel( menu )
	return tabData.tabIndex != INVALID_TAB_INDEX
}


var function _GetActiveTabPanel( var menu )
{
	if ( menu == null )
		return null

	TabData tabData = GetTabDataForPanel( menu )
	if ( tabData.tabIndex == INVALID_TAB_INDEX )
		return null
	return tabData.tabDefs[tabData.tabIndex].panel
}


void function _OnTab_NavigateBack( var unusedNull )
{
	if ( !_HasActiveTabPanel( GetActiveMenu() ) )
		return

	var activeTabPanel = _GetActiveTabPanel( GetActiveMenu() )

	if ( uiGlobal.panelData[ activeTabPanel ].navBackFunc != null )
		uiGlobal.panelData[ activeTabPanel ].navBackFunc( activeTabPanel )
}


void function OnTab_DPadUp( var unusedNull )
{
	if ( !_HasActiveTabPanel( GetActiveMenu() ) )
		return

	var activeTabPanel = _GetActiveTabPanel( GetActiveMenu() )

	if ( uiGlobal.panelData[ activeTabPanel ].navUpFunc != null )
		uiGlobal.panelData[ activeTabPanel ].navUpFunc( activeTabPanel )
}


void function OnTab_DPadDown( var unusedNull )
{
	if ( !_HasActiveTabPanel( GetActiveMenu() ) )
		return

	var activeTabPanel = _GetActiveTabPanel( GetActiveMenu() )

	if ( uiGlobal.panelData[ activeTabPanel ].navDownFunc != null )
		uiGlobal.panelData[ activeTabPanel ].navDownFunc( activeTabPanel )
}


void function OnTab_ButtonY( var unusedNull )
{
	if ( !_HasActiveTabPanel( GetActiveMenu() ) )
		return

	OnTab_InputHandler( _GetActiveTabPanel( GetActiveMenu() ), BUTTON_Y )
}


void function OnTab_InputHandler( var panel, int inputID )
{
	if ( !(inputID in uiGlobal.panelData[ panel ].panelInputs) )
		return

	if ( uiGlobal.panelData[ panel ].panelInputs[inputID] != null )
		uiGlobal.panelData[ panel ].panelInputs[inputID]( panel )
}


bool function IsPanelTabbed( var parentPanel )
{
	return parentPanel in file.elementTabData
}


void function SetPanelTabEnabled( var panel, bool enabled )
{
	TabDef tab = GetTabForTabBody( panel )

	if ( tab.enabled != enabled )
	{
		tab.enabled = enabled
		UpdateMenuTabs()
	}
}


void function SetTabDefEnabled( TabDef tabDef, bool state )
{
	tabDef.enabled = state
	UpdateMenuTabs()
}


void function SetPanelTabNew( var panel, bool new )
{
	TabDef tab = GetTabForTabBody( panel )

	if ( tab.new != new )
	{
		tab.new = new
		UpdateMenuTabs()
	}
}


bool function IsTabIndexEnabled( TabData tabData, int tabIndex )
{
	return (tabIndex in tabData.tabDefs && tabData.tabDefs[ tabIndex ].enabled)
}


bool function IsTabPanelActive( var tabPanel )
{
	if ( !IsPanelTabbed( GetActiveMenu() ) )
	{
		if ( IsTabBody( tabPanel ) )
		{
			return _GetActiveTabPanel( GetTabForTabBody( tabPanel ).parentPanel ) == tabPanel
		}
		return false
	}

	return _GetActiveTabPanel( GetActiveMenu() ) == tabPanel
}


void function RegisterTabNavigationInput()
{
	if ( !uiGlobal.tabButtonsRegistered )
	{
		RegisterButtonPressedCallback( BUTTON_SHOULDER_LEFT, OnMenuTab_NavLeft )
		RegisterButtonPressedCallback( BUTTON_SHOULDER_RIGHT, OnMenuTab_NavRight )
		//RegisterButtonPressedCallback( BUTTON_TRIGGER_LEFT, OnNestedTab_NavLeft )
		//RegisterButtonPressedCallback( BUTTON_TRIGGER_RIGHT, OnNestedTab_NavRight )
		RegisterButtonPressedCallback( BUTTON_DPAD_UP, OnTab_DPadUp )
		RegisterButtonPressedCallback( BUTTON_DPAD_DOWN, OnTab_DPadDown )

		RegisterButtonPressedCallback( BUTTON_Y, OnTab_ButtonY ) // TODO: code should be passing the input index to the registered function

		uiGlobal.tabButtonsRegistered = true
	}
}


void function DeregisterTabNavigationInput()
{
	if ( uiGlobal.tabButtonsRegistered )
	{
		DeregisterButtonPressedCallback( BUTTON_SHOULDER_LEFT, OnMenuTab_NavLeft )
		DeregisterButtonPressedCallback( BUTTON_SHOULDER_RIGHT, OnMenuTab_NavRight )
		//DeregisterButtonPressedCallback( BUTTON_TRIGGER_LEFT, OnNestedTab_NavLeft )
		//DeregisterButtonPressedCallback( BUTTON_TRIGGER_RIGHT, OnNestedTab_NavRight )
		DeregisterButtonPressedCallback( BUTTON_DPAD_UP, OnTab_DPadUp )
		DeregisterButtonPressedCallback( BUTTON_DPAD_DOWN, OnTab_DPadDown )

		DeregisterButtonPressedCallback( BUTTON_Y, OnTab_ButtonY )

		uiGlobal.tabButtonsRegistered = false
	}
}


void function SetTabRightSound( var panel, string sound )
{
	GetTabDataForPanel( panel ).tabRightSound = sound
}


void function SetTabLeftSound( var panel, string sound )
{
	GetTabDataForPanel( panel ).tabLeftSound = sound
}


bool function IsTabBody( var panel )
{
	return panel in file.tabBodyDefMap
}

TabData function GetTabBodyParent( var panel )
{
	Assert( IsTabBody( panel ) )
	TabDef def = GetTabForTabBody( panel )
	return GetTabDataForPanel( def.parentPanel )
}