global function InitCustomizeModelMenu
global function CustomizeModelMenu_UpdateTitleRUI

struct
{
	var        menu
	var        decorationRui
	var        titleRui
	array<var> weaponTabBodyPanelList

	array<ItemFlavor> weaponList
} file


void function InitCustomizeModelMenu( var newMenuArg )
{
	var menu = GetMenu( "CustomizeModelMenu" )
	file.menu = menu

	SetTabRightSound( menu, "UI_Menu_ArmoryTab_Select" )
	SetTabLeftSound( menu, "UI_Menu_ArmoryTab_Select" )

	file.decorationRui = Hud_GetRui( Hud_GetChild( menu, "Decoration" ) )
	file.titleRui = Hud_GetRui( Hud_GetChild( menu, "Title" ) )

    Hud_Hide(Hud_GetChild(menu, "UserInfo"))
    Hud_Hide(Hud_GetChild(menu, "Decoration"))
    Hud_Hide(Hud_GetChild(menu, "Logo"))

	file.weaponTabBodyPanelList = [
		Hud_GetChild( menu, "WeaponSkinsPanel0" )
		Hud_GetChild( menu, "WeaponSkinsPanel1" )
		Hud_GetChild( menu, "WeaponSkinsPanel2" )
		Hud_GetChild( menu, "WeaponSkinsPanel3" )
		Hud_GetChild( menu, "WeaponSkinsPanel4" )
	]

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, CustomizeModelMenu_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, CustomizeModelMenu_OnShow )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, CustomizeModelMenu_OnClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, CustomizeModelMenu_OnNavigateBack )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddMenuFooterOption( menu, LEFT, BUTTON_A, true, "#A_BUTTON_SELECT", "" )
	AddMenuFooterOption( menu, LEFT, BUTTON_X, true, "Pause", "Pause")
	//AddMenuFooterOption( menu, LEFT, BUTTON_X, true, "#X_BUTTON_UNLOCK", "#X_BUTTON_UNLOCK", null, CustomizeMenus_IsFocusedItemLocked )
}


void function CustomizeModelMenu_OnOpen()
{
	// (dw): the customize context should not change while this menu is up

	RuiSetGameTime( file.decorationRui, "initTime", Time() )
	RuiSetString( file.titleRui, "title", Localize("Models"))

	AddCallback_OnTopLevelCustomizeContextChanged( file.menu, CustomizeModelMenu_Update )
	CustomizeModelMenu_Update( file.menu )

	if ( uiGlobal.lastMenuNavDirection == MENU_NAV_FORWARD )
	{
		TabData tabData = GetTabDataForPanel( file.menu )
		ActivateTab( tabData, 0 )
	}
	//else
	//	ActivateTab( file.menu, GetMenuActiveTabIndex( file.menu ) )
}


void function CustomizeModelMenu_OnShow()
{
	UI_SetPresentationType( ePresentationType.MODEL )
}


void function CustomizeModelMenu_OnClose()
{
	RemoveCallback_OnTopLevelCustomizeContextChanged( file.menu, CustomizeModelMenu_Update )
	CustomizeModelMenu_Update( file.menu )
	RunClientScript("ClearModelMenu")
}


void function CustomizeModelMenu_Update( var menu )
{
	for ( int panelIdx = 0; panelIdx < file.weaponTabBodyPanelList.len(); panelIdx++ )
	{
		var tabBodyPanel = file.weaponTabBodyPanelList[panelIdx]
		if ( panelIdx < file.weaponList.len() )
		{
			ItemFlavor weapon = file.weaponList[panelIdx]
			Newness_RemoveCallback_OnRerverseQueryUpdated( NEWNESS_QUERIES.WeaponTab[weapon], OnNewnessQueryChangedUpdatePanelTab, tabBodyPanel )
		}
	}
	file.weaponList.clear()

	ClearTabs( menu )

	// set up, but only if we're active
	if ( GetActiveMenu() == menu )
	{
		ItemFlavor category = GetTopLevelCustomizeContext()
		file.weaponList = GetWeaponsInCategory( category )

		foreach ( int weaponIdx, ItemFlavor weapon in file.weaponList )
		{
			var tabBodyPanel = file.weaponTabBodyPanelList[weaponIdx]

			float tabBarLeftOffsetFracIfVisible = 0.434
			AddTab( menu, tabBodyPanel, Localize( ItemFlavor_GetShortName( weapon ) ).toupper(), false, tabBarLeftOffsetFracIfVisible )

			Newness_AddCallbackAndCallNow_OnRerverseQueryUpdated( NEWNESS_QUERIES.WeaponTab[weapon], OnNewnessQueryChangedUpdatePanelTab, tabBodyPanel )
		}
	}

	UpdateMenuTabs()
}


void function CustomizeModelMenu_OnNavigateBack()
{
	Assert( GetActiveMenu() == file.menu )

	CloseActiveMenu()
}

void function CustomizeModelMenu_UpdateTitleRUI(string to) {
	RuiSetString( file.titleRui, "title", Localize(to) )
}