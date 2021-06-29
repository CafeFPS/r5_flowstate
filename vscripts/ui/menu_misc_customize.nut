global function InitMiscCustomizeMenu


struct
{
	var        menu
	var        decorationRui
	var        titleRui
	array<var> tabBodyPanelList

	//
} file


void function InitMiscCustomizeMenu( var newMenuArg ) //
{
	var menu = GetMenu( "MiscCustomizeMenu" )
	file.menu = menu

	SetTabRightSound( menu, "UI_Menu_ArmoryTab_Select" )
	SetTabLeftSound( menu, "UI_Menu_ArmoryTab_Select" )

	file.decorationRui = Hud_GetRui( Hud_GetChild( menu, "Decoration" ) )
	file.titleRui = Hud_GetRui( Hud_GetChild( menu, "Title" ) )

	file.tabBodyPanelList = [
		Hud_GetChild( menu, "LoadscreenPanel" )
		Hud_GetChild( menu, "MusicPackPanel" )
		Hud_GetChild( menu, "SkydiveTrailPanel" )
	]

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, MiscCustomizeMenu_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, MiscCustomizeMenu_OnShow )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, MiscCustomizeMenu_OnClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, MiscCustomizeMenu_OnNavigateBack )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddMenuFooterOption( menu, LEFT, BUTTON_A, true, "#A_BUTTON_SELECT", "" )
	//
	//
}


void function MiscCustomizeMenu_OnOpen()
{
	RuiSetGameTime( file.decorationRui, "initTime", Time() )
	RuiSetString( file.titleRui, "title", Localize( "#MISC_CUSTOMIZATION" ).toupper() )

	AddCallback_OnTopLevelCustomizeContextChanged( file.menu, MiscCustomizeMenu_Update )
	MiscCustomizeMenu_Update( file.menu )

	if ( uiGlobal.lastMenuNavDirection == MENU_NAV_FORWARD )
	{
		TabData tabData = GetTabDataForPanel( file.menu )
		ActivateTab( tabData, 0 )
	}
	//
	//

	Newness_AddCallbackAndCallNow_OnRerverseQueryUpdated( NEWNESS_QUERIES.LoadscreenButton, OnNewnessQueryChangedUpdatePanelTab, GetPanel( "LoadscreenPanel" ) )
	Newness_AddCallbackAndCallNow_OnRerverseQueryUpdated( NEWNESS_QUERIES.MusicPackButton, OnNewnessQueryChangedUpdatePanelTab, GetPanel( "MusicPackPanel" ) )
	Newness_AddCallbackAndCallNow_OnRerverseQueryUpdated( NEWNESS_QUERIES.SkydiveTrailButton, OnNewnessQueryChangedUpdatePanelTab, GetPanel( "SkydiveTrailPanel" ) )
}


void function MiscCustomizeMenu_OnShow()
{
	UI_SetPresentationType( ePresentationType.WEAPON_CATEGORY )
}


void function MiscCustomizeMenu_OnClose()
{

	Newness_RemoveCallback_OnRerverseQueryUpdated( NEWNESS_QUERIES.LoadscreenButton, OnNewnessQueryChangedUpdatePanelTab, GetPanel( "LoadscreenPanel" ) )
	Newness_RemoveCallback_OnRerverseQueryUpdated( NEWNESS_QUERIES.MusicPackButton, OnNewnessQueryChangedUpdatePanelTab, GetPanel( "MusicPackPanel" ) )
	Newness_RemoveCallback_OnRerverseQueryUpdated( NEWNESS_QUERIES.SkydiveTrailButton, OnNewnessQueryChangedUpdatePanelTab, GetPanel( "SkydiveTrailPanel" ) )

	RemoveCallback_OnTopLevelCustomizeContextChanged( file.menu, MiscCustomizeMenu_Update )
	MiscCustomizeMenu_Update( file.menu )
}


void function MiscCustomizeMenu_Update( var menu )
{
	/*











*/
	ClearTabs( menu )

	//
	if ( GetActiveMenu() == menu )
	{
		/*












*/

		float tabBarLeftOffsetFracIfVisible = 0.434
		AddTab( menu, file.tabBodyPanelList[0], Localize( "#TAB_CUSTOMIZE_LOADSCREEN" ).toupper(), false, tabBarLeftOffsetFracIfVisible )
		AddTab( menu, file.tabBodyPanelList[1], Localize( "#TAB_CUSTOMIZE_MUSIC_PACK" ).toupper(), false, tabBarLeftOffsetFracIfVisible )
		AddTab( menu, file.tabBodyPanelList[2], Localize( "#TAB_CUSTOMIZE_SKYDIVE_TRAIL" ).toupper(), false, tabBarLeftOffsetFracIfVisible )
	}

	SetPanelTabNew( GetPanel( "LoadscreenPanel" ), (Newness_ReverseQuery_GetNewCount( NEWNESS_QUERIES.LoadscreenButton ) > 0) )
	SetPanelTabNew( GetPanel( "MusicPackPanel" ), (Newness_ReverseQuery_GetNewCount( NEWNESS_QUERIES.MusicPackButton ) > 0) )
	SetPanelTabNew( GetPanel( "SkydiveTrailPanel" ), (Newness_ReverseQuery_GetNewCount( NEWNESS_QUERIES.SkydiveTrailButton ) > 0) )

	UpdateMenuTabs()
}


void function MiscCustomizeMenu_OnNavigateBack()
{
	Assert( GetActiveMenu() == file.menu )

	CloseActiveMenu()
}
