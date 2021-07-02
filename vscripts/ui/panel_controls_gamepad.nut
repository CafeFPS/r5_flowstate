global function InitControlsGamepadPanel
global function RestoreGamepadDefaults
global function ControlsGamepadPanel_GetConVarData

struct
{
	var                itemDescriptionBox
	table<var, string> buttonTitles
	table<var, string> buttonDescriptions
	var                detailsPanel
	array<var>         advanceControlsDisableItems
	array<var>         advanceControlsVisibleItems
	array<var>         advanceControlsOffVisibleItems
	var					advancedLookControlsBtn

	array<ConVarData>    conVarDataList
} file

void function InitControlsGamepadPanel( var panel )
{
	var contentPanel = Hud_GetChild( panel, "ContentPanel" )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, OnControlsGamepadPanel_Show )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, OnControlsGamepadPanel_Hide )

	var button
	button = Hud_GetChild( contentPanel, "BtnGamepadLayout" )
	SetupSettingsButton( button, "#GAMEPAD_SET_BINDS", "#GAMEPAD_SET_BINDS_DESC", $"rui/menu/settings/settings_gamepad" )
	AddButtonEventHandler( button, UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "GamepadLayoutMenu" ) ) )

	button = Hud_GetChild( contentPanel, "SwchStickLayout" )
	SetupSettingsButton( button, "#STICK_LAYOUT", "#STICK_LAYOUT_DESC", $"rui/menu/settings/settings_gamepad" )
	AddButtonEventHandler( button, UIE_CHANGE, StickLayout_OnChanged )

	button = Hud_GetChild( contentPanel, "BtnControllerOpenAdvancedMenu" )
	SetupSettingsButton( button, "#OPEN_ADVANCED_LOOK_CONTROLS", "#OPEN_ADVANCED_LOOK_CONTROLS_DESC", $"rui/menu/settings/settings_gamepad" )
	AddButtonEventHandler( button, UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "ControlsAdvancedLookMenu" ) ) )
	file.advancedLookControlsBtn = button

	button = SetupSettingsButton( Hud_GetChild( contentPanel, "SwchLookSensitivity" ), "#LOOK_SENSITIVITY", "#GAMEPAD_MENU_SENSITIVITY_DESC", $"rui/menu/settings/settings_gamepad" )
	file.advanceControlsDisableItems.append( button )

	button = SetupSettingsButton( Hud_GetChild( contentPanel, "BtnLookSensitivityMenu" ), "#MENU_SENSITIVITY", "#GAMEPAD_MENU_SENSITIVITY_ADS_DESC", $"rui/menu/settings/settings_gamepad" )
	AddButtonEventHandler( button, UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "ControlsAdvancedLookMenuConsole" ) ) )
	file.advanceControlsDisableItems.append( button )

	SetupSettingsButton( Hud_GetChild( contentPanel, "SwchLookInvert" ), "#LOOK_INVERT", "#GAMEPAD_MENU_INVERT_DESC", $"rui/menu/settings/settings_gamepad" )

	button = SetupSettingsButton( Hud_GetChild( contentPanel, "SwchLookDeadzone" ), "#LOOK_DRIFT_GUARD", "#GAMEPAD_MENU_DRIFT_GUARD_DESC", $"rui/menu/settings/settings_gamepad" )
	file.advanceControlsDisableItems.append( button )

	SetupSettingsButton( Hud_GetChild( contentPanel, "SwchMoveDeadzone" ), "#MOVE_DRIFT_GUARD", "#GAMEPAD_MENU_MOVE_DRIFT_GUARD_DESC", $"rui/menu/settings/settings_gamepad" )

	#if DURANGO_PROG
		button = SetupSettingsButton( Hud_GetChild( contentPanel, "SwchLookAiming" ), "#LOOKSTICK_AIMING", "#GAMEPAD_MENU_LOOK_AIMING_DESC_DURANGO", $"rui/menu/settings/settings_gamepad" )
	#else // #if DURANGO_PROG
		button = SetupSettingsButton( Hud_GetChild( contentPanel, "SwchLookAiming" ), "#LOOKSTICK_AIMING", "#GAMEPAD_MENU_LOOK_AIMING_DESC", $"rui/menu/settings/settings_gamepad" )
	#endif // #if DURANGO_PROG
	file.advanceControlsDisableItems.append( button )

	SetupSettingsButton( Hud_GetChild( contentPanel, "SwchVibration" ), "#VIBRATION", "#GAMEPAD_MENU_VIBRATION_DESC", $"rui/menu/settings/settings_gamepad" )
	SetupSettingsButton( Hud_GetChild( contentPanel, "SwchHoldToCrouch" ), "#HOLDTOCROUCH", "#GAMEPAD_MENU_HOLDTOCROUCH_DESC", $"rui/menu/settings/settings_gamepad" )
	SetupSettingsButton( Hud_GetChild( contentPanel, "SwchTapToUse" ), "#TAPTOUSE", "#GAMEPAD_MENU_TAPTOUSE_DESC", $"rui/menu/settings/settings_gamepad" )
	SetupSettingsButton( Hud_GetChild( contentPanel, "SwchToggleGamepadADS" ), "#GAMEPAD_TOGGLE_ADS", "#GAMEPAD_TOGGLE_ADS_DESC", $"rui/menu/settings/settings_gamepad" )
	SetupSettingsButton( Hud_GetChild( contentPanel, "SwchTriggerDeadzone" ), "#GAMEPAD_TRIGGER_DEADZONES", "#GAMEPAD_TRIGGER_DEADZONES_DESC", $"rui/menu/settings/settings_gamepad" )
	SetupSettingsSlider( Hud_GetChild( contentPanel, "SldCursorVelocity" ), "#GAMEPAD_CURSOR_VELOCITY", "#GAMEPAD_CURSOR_VELOCITY_DESC", $"rui/menu/settings/settings_gamepad" )

	file.advanceControlsVisibleItems.append( Hud_GetChild( contentPanel, "SwchLookSensitivity_AdvLabel" ) )
	file.advanceControlsVisibleItems.append( Hud_GetChild( contentPanel, "SwchLookSensitivityADS_AdvLabel" ) )
	file.advanceControlsVisibleItems.append( Hud_GetChild( contentPanel, "SwchLookAiming_AdvLabel" ) )
	file.advanceControlsVisibleItems.append( Hud_GetChild( contentPanel, "SwchLookDeadzone_AdvLabel" ) )
	//file.advanceControlsVisibleItems.append( Hud_GetChild( contentPanel, "LblAdvControllerOn" ) )
	//file.advanceControlsOffVisibleItems.append( Hud_GetChild( contentPanel, "LblAdvControllerOff" ) )

	ScrollPanel_InitPanel( panel )
	ScrollPanel_InitScrollBar( panel, Hud_GetChild( panel, "ScrollBar" ) )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, LEFT, BUTTON_BACK, true, "#BACKBUTTON_RESTORE_DEFAULTS", "#RESTORE_DEFAULTS", OpenConfirmRestoreGamepadDefaultsDialog )
	AddPanelFooterOption( panel, LEFT, -1, false, "#FOOTER_CHOICE_HINT", "" )

	file.conVarDataList.append( CreateSettingsConVarData( "gamepad_togglecrouch_hold", eConVarType.INT ) )
	file.conVarDataList.append( CreateSettingsConVarData( "gamepad_toggle_ads", eConVarType.INT ) )
	file.conVarDataList.append( CreateSettingsConVarData( "gamepad_aim_speed", eConVarType.INT ) )
	file.conVarDataList.append( CreateSettingsConVarData( "gamepad_aim_speed_ads_0", eConVarType.INT ) )
	file.conVarDataList.append( CreateSettingsConVarData( "joy_inverty", eConVarType.INT ) )
	file.conVarDataList.append( CreateSettingsConVarData( "gamepad_look_curve", eConVarType.INT ) )
	file.conVarDataList.append( CreateSettingsConVarData( "gamepad_deadzone_index_look", eConVarType.INT ) )
	file.conVarDataList.append( CreateSettingsConVarData( "gamepad_deadzone_index_move", eConVarType.INT ) )
	file.conVarDataList.append( CreateSettingsConVarData( "joy_rumble", eConVarType.INT ) )
	file.conVarDataList.append( CreateSettingsConVarData( "gamepad_use_type", eConVarType.INT ) )
	file.conVarDataList.append( CreateSettingsConVarData( "gamepad_custom_pilot", eConVarType.INT ) )
	file.conVarDataList.append( CreateSettingsConVarData( "gamepad_stick_layout", eConVarType.INT ) )
}


void function OnControlsGamepadPanel_Show( var panel )
{
	ScrollPanel_SetActive( panel, true )
	SetStatesForCustomEnable()
}


void function OnControlsGamepadPanel_Hide( var panel )
{
	ScrollPanel_SetActive( panel, false )
	RefreshCustomGamepadBinds_UI()
	SaveSettingsConVars( file.conVarDataList )
	SavePlayerSettings()
}


bool function IsAffectedByAdvancedControls( var button )
{
	foreach ( var item in file.advanceControlsDisableItems )
	{
		if ( item == button )
			return true
	}
	return false
}


void function SetStatesForCustomEnable()
{
	bool customGamepadIsEnabled = GetConVarBool( "gamepad_custom_enabled" )

	//
	//

	foreach ( var item in file.advanceControlsDisableItems )
		Hud_SetEnabled( item, !customGamepadIsEnabled )

	foreach ( var item in file.advanceControlsVisibleItems )
		Hud_SetVisible( item, customGamepadIsEnabled )

	foreach ( var item in file.advanceControlsOffVisibleItems )
		Hud_SetVisible( item, !customGamepadIsEnabled )
}


void function OpenConfirmRestoreGamepadDefaultsDialog( var button )
{
	ConfirmDialogData data
	data.headerText = "#RESTORE_GAMEPAD_DEFAULTS"
	data.messageText = "#RESTORE_GAMEPAD_DEFAULTS_DESC"
	data.resultCallback = OnConfirmDialogResult

	OpenConfirmDialogFromData( data )
	AdvanceMenu( GetMenu( "ConfirmDialog" ) )
}


void function OnConfirmDialogResult( int result )
{
	switch ( result )
	{
		case eDialogResult.YES:
			RestoreGamepadDefaults()
	}
}


void function RestoreGamepadDefaults()
{
	SetConVarToDefault( "gamepad_togglecrouch_hold" )
	SetConVarToDefault( "gamepad_toggle_ads" )
	SetConVarToDefault( "gamepad_aim_speed" )
	SetConVarToDefault( "gamepad_aim_speed_ads_0" )
	SetConVarToDefault( "joy_inverty" )
	SetConVarToDefault( "gamepad_look_curve" )
	SetConVarToDefault( "gamepad_deadzone_index_look" )
	SetConVarToDefault( "gamepad_deadzone_index_move" )
	SetConVarToDefault( "joy_rumble" )
	SetConVarToDefault( "gamepad_use_type" )
	RestoreADSDefaultsGamePad()

	SetConVarToDefault( "gamepad_button_layout" )
	SetConVarToDefault( "gamepad_stick_layout" )

	SetConVarToDefault( "gamepad_custom_pilot" )
	SetConVarToDefault( "gamepad_custom_titan" )
	RefreshCustomGamepadBinds_UI()

	SetConVarToDefault( "gamepad_custom_enabled" )
	SetStatesForCustomEnable()

	UnbindAllGamepad()

	ExecConfig( "gamepad_stick_layout_default.cfg" )
	ExecConfig( "gamepad_button_layout_custom.cfg" )

#if CONSOLE_PROG
	ExecConfig( "config_default_console.cfg" )
#endif

	SaveSettingsConVars( file.conVarDataList )

	EmitUISound( "menu_advocategift_open" )
}


void function StickLayout_OnChanged( var button )
{
	ExecCurrentGamepadStickConfig()
}


array<ConVarData> function ControlsGamepadPanel_GetConVarData()
{
	return file.conVarDataList
}
