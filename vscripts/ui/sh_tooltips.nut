global function Sh_InitToolTips
global function UpdateToolTipElement

global function Hud_SetToolTipData
global function Hud_ClearToolTipData
global function Hud_GetToolTipData
global function Hud_HasToolTipData

global function AddCallback_OnUpdateTooltip

global function _ToolTips_GetToolTipData
global function _ToolTips_SetToolTipData
global function _ToolTips_HasToolTipData
global function _ToolTips_ClearToolTipData

#if UI
global function ToolTips_AddMenu
global function ToolTips_MenuOpened
global function ToolTips_MenuClosed

global function ToolTips_HideTooltipUntilRefocus
#endif

// needs to match the .menu entry and the .rui
const int TOOLTIP_HEIGHT = 192

struct ToolTipElementData
{
	var element
}

struct ToolTipMenuData
{
	var menu
	var toolTip
	//table<string, ToolTipElementData> toolTipElements
}

struct {
	bool enabled = false

	asset currentTooltipRui
	var tooltipRui

	table< string, ToolTipMenuData > menusWithToolTips

	table<string, ToolTipData> _toolTipElements
	string                     lastFocusElement

	table< int, array<void functionref(int style, ToolTipData)> > onUpdateTooltipCallbacks
}
file

void function Sh_InitToolTips()
{
	file.enabled = GetConVarBool( "gameCursor_ModeActive" )

	#if UI
	UpdateTooltipRui( $"ui/generic_tooltip.rpak" )
	#endif

	foreach ( style in eTooltipStyle )
	{
		file.onUpdateTooltipCallbacks[ style ] <- []
	}
}

#if UI
void function ToolTips_AddMenu( var menu )
{
	if ( !Hud_HasChild( menu, "ToolTip" ) )
		return

	ToolTipMenuData menuData
	menuData.menu = menu

	file.menusWithToolTips[string(menu)] <- menuData

	menuData.toolTip = Hud_GetChild( menu, "ToolTip" )

	//array<var> elementsWithToolTips = GetElementsByClassname( menu, "ShowToolTip" )
	//foreach ( element in elementsWithToolTips )
	//{
	//	Hud_SetKeyValue( element, "parentMenu", menu )
	//	Hud_AddEventHandler( element, UIE_GET_FOCUS, OnElementGetFocus )
	//	Hud_AddEventHandler( element, UIE_LOSE_FOCUS, OnElementLoseFocus )
	//
	//	ToolTipElementData elementData
	//	elementData.element = element
	//
	//	//menuData.toolTipElements[string(element)] <- elementData
	//}

	AddMenuThinkFunc( menu, OnToolTipMenuThink )
}


void function ToolTips_MenuOpened( var menu )
{
	if ( !(string( menu ) in file.menusWithToolTips) )
		return

	ToolTipMenuData menuData = file.menusWithToolTips[string(menu)]

	if ( !GetConVarBool( "gameCursor_ModeActive" ) )
	{
		return
	}
}


void function ToolTips_MenuClosed( var menu )
{
	if ( !(string( menu ) in file.menusWithToolTips) )
		return

	ToolTipMenuData menuData = file.menusWithToolTips[string(menu)]
}

/*
void function OnElementGetFocus( var element )
{
	var menu = Hud_GetValueForKey( element, "parentMenu" )

	//ToolTipMenuData menuData = file.menusWithToolTips[string(menu)]
	//if ( !(string(element) in menuData.toolTipElements) )
	//	return

	// update tooltip data

}


void function OnElementLoseFocus( var element )
{
	var menu = Hud_GetValueForKey( element, "parentMenu" )
	printt( "OnElementLoseFocus" )
}
*/

var s_hideElement = null
void function ToolTips_HideTooltipUntilRefocus( var element )
{
	s_hideElement = element
}

// TODO: could probably be replaced with a few event driven code callbacks and the ability to pin an element to the cursor
void function OnToolTipMenuThink( var menu )
{
	ToolTipMenuData menuData = file.menusWithToolTips[string(menu)]

	var focusElement = GetMouseFocus()
	if ( focusElement == null || !Hud_HasToolTipData( focusElement ) )
	{
		s_hideElement = null
		HideTooltipRui();
		return
	}

	if ( (s_hideElement != null) && (s_hideElement == focusElement) )
	{
		HideTooltipRui();
		return
	}
	s_hideElement = null

	UpdateToolTipElement( menuData.toolTip, focusElement )

	// populate the tooltip to generate size
}

var function UpdateTooltipRui( asset ruiAsset )
{
	if ( file.currentTooltipRui == ruiAsset )
		return

	file.currentTooltipRui = ruiAsset
	file.tooltipRui = SetTooltipRui( string( ruiAsset ) )
}
#endif

void function Hud_SetToolTipData( var element, ToolTipData toolTipData )
{
	_ToolTips_SetToolTipData( element, toolTipData )
}

void function Hud_ClearToolTipData( var element )
{
	_ToolTips_ClearToolTipData( element )
}

ToolTipData function Hud_GetToolTipData( var element )
{
	return _ToolTips_GetToolTipData( element )
}

bool function Hud_HasToolTipData( var element )
{
	return _ToolTips_HasToolTipData( element )
}

void function _ToolTips_SetToolTipData( var element, ToolTipData toolTipData )
{
	if ( !(string(element) in file._toolTipElements) )
		file._toolTipElements[string(element)] <- toolTipData

	file._toolTipElements[string(element)] = toolTipData
}

ToolTipData function _ToolTips_GetToolTipData( var element )
{
	Assert( string(element) in file._toolTipElements )

	return file._toolTipElements[string(element)]
}

bool function _ToolTips_HasToolTipData( var element )
{
	return (string(element) in file._toolTipElements)
}

void function _ToolTips_ClearToolTipData( var element )
{
	if ( !(string(element) in file._toolTipElements) )
		return

	delete file._toolTipElements[string(element)]
}

void function UpdateToolTipElement( var toolTipElement, var focusElement )
{
	if ( !Hud_HasToolTipData( focusElement ) )
		return

	ToolTipData dt = Hud_GetToolTipData( focusElement )

	foreach ( func in file.onUpdateTooltipCallbacks[dt.tooltipStyle] )
	{
		func( dt.tooltipStyle, dt )
	}

	asset ruiAsset

	// TODO: have this be data driven
	switch ( dt.tooltipStyle )
	{
		case eTooltipStyle.LOOT_PROMPT:
			ruiAsset = LOOT_PICKUP_HINT_DEFAULT_RUI
			break
		case eTooltipStyle.WEAPON_LOOT_PROMPT:
			ruiAsset = WEAPON_PICKUP_HINT_DEFAULT_RUI
			break
		case eTooltipStyle.BUTTON_PROMPT:
			ruiAsset = $"ui/button_tooltip.rpak"
			break
		case eTooltipStyle.ACCESSIBLE:
			ruiAsset = $"ui/accessibility_tooltip.rpak"
			break
		case eTooltipStyle.CURRENCY:
			ruiAsset = $"ui/currency_tooltip.rpak"
			break
		default:
			ruiAsset = $"ui/generic_tooltip.rpak"
	}

	#if UI
		UpdateTooltipRui( ruiAsset )
		ShowTooltipRui()

		if ( dt.tooltipFlags & eToolTipFlag.CLIENT_UPDATE )
		{
			if ( IsFullyConnected() )
				RunClientScript( "UpdateToolTipElement", toolTipElement, focusElement )
			return
		}
	#endif

	switch ( dt.commsAction )
	{
		case eCommsAction.INVENTORY_NEED_AMMO_BULLET:
		case eCommsAction.INVENTORY_NEED_AMMO_SPECIAL:
		case eCommsAction.INVENTORY_NEED_AMMO_HIGHCAL:
		case eCommsAction.INVENTORY_NEED_AMMO_SHOTGUN:
		case eCommsAction.INVENTORY_NEED_AMMO_SNIPER:
			dt.commsPromptDefault = IsControllerModeActive() ? "#PING_PROMPT_REQUEST_AMMO_GAMEPAD" : "#PING_PROMPT_REQUEST_AMMO"
	}

	string commsPrompt = dt.commsPromptDefault
	if ( (dt.tooltipFlags & eToolTipFlag.EMPTY_SLOT) || (dt.commsAction != eCommsAction.BLANK) && commsPrompt == "" )
		commsPrompt = IsControllerModeActive() ? "#PING_PROMPT_REQUEST_GAMEPAD" : "#PING_PROMPT_REQUEST"

	var rui = GetTooltipRui()

	if ( ruiAsset == "ui/generic_tooltip.rpak" || ruiAsset == $"ui/button_tooltip.rpak" || ruiAsset == $"ui/accessibility_tooltip.rpak" || ruiAsset == $"ui/currency_tooltip.rpak" )
	{
		array<string> actionList
		if ( dt.actionHint1 != "" )
			actionList.append( dt.actionHint1 )
		if ( dt.actionHint2 != "" )
			actionList.append( dt.actionHint2 )
		if ( dt.actionHint3 != "" )
			actionList.append( dt.actionHint3 )

		RuiSetString( rui, "titleText", dt.titleText )
		RuiSetString( rui, "descText", dt.descText )
		RuiSetString( rui, "actionText1", actionList.len() > 0 ? actionList[0] : "" )
		RuiSetString( rui, "actionText2", actionList.len() > 1 ? actionList[1] : ""  )
		RuiSetString( rui, "actionText3", actionList.len() > 2 ? actionList[2] : ""  )
		RuiSetString( rui, "commsPrompt", commsPrompt )
		RuiSetInt( rui, "tooltipFlags", dt.tooltipFlags )

		if ( file.lastFocusElement != string(focusElement) )
			RuiSetGameTime( rui, "changeTime", Time() )

		file.lastFocusElement = string(focusElement)
	}
}

void function AddCallback_OnUpdateTooltip( int style, void functionref(int style, ToolTipData) func )
{
	Assert( !file.onUpdateTooltipCallbacks[ style ].contains( func ) )

	file.onUpdateTooltipCallbacks[ style ].append( func )
}


