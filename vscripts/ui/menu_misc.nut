global function InitMiscMenu

struct
{
	var menu
	var screenBlur

} file

struct
{
} s_settings

void function InitMiscMenu( var newMenuArg )
{
	var menu = GetMenu( "MiscMenu" )
	file.menu = menu

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnMiscMenu_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnMiscMenu_Close )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnMiscMenu_NavigateBack )

	//file.screenBlur = Hud_GetChild( menu, "ScreenBlur" )

	//InitSettingsPanel( Hud_GetChild( file.menu, "SettingsPanel" ) )
}

void function OnMiscMenu_Open()
{
	if ( IsLobby() )
		UI_SetPresentationType( ePresentationType.WEAPON_CATEGORY )
	SetBlurEnabled( true )

	ShowPanel( Hud_GetChild( file.menu, "SettingsPanel" ) )

/*
	if ( IsConnected() && !IsLobby() )
	{
		HudElem_SetRuiArg( file.screenBlur, "saturationValue", 1.0 )
		HudElem_SetRuiArg( file.screenBlur, "lightnessValue", 1.0 )
	}
	else
	{
		HudElem_SetRuiArg( file.screenBlur, "saturationValue", 1.0 )
		HudElem_SetRuiArg( file.screenBlur, "lightnessValue", 1.0 )
	}
*/
}

void function OnMiscMenu_Close()
{
	HidePanel( Hud_GetChild( file.menu, "SettingsPanel" ) )

	RefreshCustomGamepadBinds_UI()
	//TabData tabData = GetTabDataForPanel( file.menu )
	//DeactivateTab( tabData )
}

void function OnMiscMenu_NavigateBack()
{
	Assert( GetActiveMenu() == file.menu )

	if ( uiGlobal.videoSettingsChanged )
	{
		DiscardVideoSettingsDialog( null, -1 )
		return
	}

	CloseActiveMenu()

	if ( IsLobby() )
	{
		if (GetActiveMenu() != GetMenu( GetCurrentLobbyMenu() ) )
			AdvanceMenu( GetMenu( GetCurrentLobbyMenu() ) )

		UI_SetPresentationType( CurrentPresentationType )
	}
		

	if(ISAIMTRAINER){
		CloseAllMenus()
		RunClientScript("ServerCallback_OpenFRChallengesMainMenu", PlayerKillsForChallengesUI)
	}
}

