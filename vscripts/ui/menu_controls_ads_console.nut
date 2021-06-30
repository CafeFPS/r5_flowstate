
global function InitADSControlsMenuConsole
global function InitADSControlsPanelConsole
global function RestoreADSDefaultsGamePad

struct
{
	var                menu
	var                panel
	table<var, string> buttonTitles
	table<var, string> buttonDescriptions
	var                detailsPanel
	var                contentPanel

	array<ConVarData> conVarDataList

	array<var> customItems
	array<var> defaultItems
	array<var> aimAssistItems
} file


void function InitADSControlsMenuConsole( var menu ) //
{
	file.menu = menu
	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpenControlsADSMenuConsole )
}


void function InitADSControlsPanelConsole( var panel )
{
	file.panel = panel
	file.detailsPanel = Hud_GetChild( panel, "DetailsPanel" )
	var contentPanel = Hud_GetChild( panel, "ContentPanel" )
	file.contentPanel = contentPanel
	
	//
	bool aimAssistSettingsEnabled = true//GetConVarBool( "gamepad_aim_assist_sniper_scopes" ) // DOES NOT EXIST
	if ( aimAssistSettingsEnabled )
	{
		Hud_SetHeight( file.contentPanel, 1640 )
	}
	else
	{
		Hud_SetHeight( file.contentPanel, 750 )
		var lastADSSensitivityButton = Hud_GetChild( contentPanel, "SwchLookSensitivityADS6" )
		Hud_SetNavDown( lastADSSensitivityButton, lastADSSensitivityButton )
	}

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, OnADSControlsPanel_Show )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, OnADSControlsPanel_Hide )

	SetupSettingsButton( Hud_GetChild( contentPanel, "SwchLookSensitivity" ), "#LOOK_SENSITIVITY", "#GAMEPAD_MENU_SENSITIVITY_DESC", $"rui/menu/settings/settings_gamepad" )

	var button = Hud_GetChild( contentPanel, "SwchCustomADSEnabled" )
	SetupSettingsButton( button, "#PEROPTICADS_ENABLED", "#PEROPTICADS_ENABLED_DESC", $"" )
	AddButtonEventHandler( button, UIE_CHANGE, Button_Toggle_ADSEnabled )

	//
	file.defaultItems.append( SetupSettingsButton( Hud_GetChild( contentPanel, "SwchLookSensitivityADS" ), "#LOOK_SENSITIVITY_ADS", "#GAMEPAD_MENU_SENSITIVITY_ADS_DESC", $"rui/menu/settings/settings_gamepad" ) )

	//
	file.customItems.append( SetupSettingsButton( Hud_GetChild( contentPanel, "SwchLookSensitivityADS0" ), "#PEROPTICADS_0", "", $"" ) )
	file.customItems.append( SetupSettingsButton( Hud_GetChild( contentPanel, "SwchLookSensitivityADS1" ), "#PEROPTICADS_1", "", $"" ) )
	file.customItems.append( SetupSettingsButton( Hud_GetChild( contentPanel, "SwchLookSensitivityADS2" ), "#PEROPTICADS_2", "", $"" ) )
	file.customItems.append( SetupSettingsButton( Hud_GetChild( contentPanel, "SwchLookSensitivityADS3" ), "#PEROPTICADS_3", "", $"" ) )
	file.customItems.append( SetupSettingsButton( Hud_GetChild( contentPanel, "SwchLookSensitivityADS4" ), "#PEROPTICADS_4", "", $"" ) )
	file.customItems.append( SetupSettingsButton( Hud_GetChild( contentPanel, "SwchLookSensitivityADS5" ), "#PEROPTICADS_5", "", $"" ) )
	file.customItems.append( SetupSettingsButton( Hud_GetChild( contentPanel, "SwchLookSensitivityADS6" ), "#PEROPTICADS_6", "", $"" ) )

	//
	var aimAssistbutton = Hud_GetChild( contentPanel, "SwchGamepadAimAssist" )
	SetupSettingsButton( aimAssistbutton, "#GAMEPADCUSTOM_ASSIST", "#GAMEPADCUSTOM_ASSIST_DESC", $"" )
	AddButtonEventHandler( aimAssistbutton, UIE_CHANGE, Button_Toggle_AimAssistEnabled )
	
	file.aimAssistItems.append( SetupSettingsButton( Hud_GetChild( contentPanel, "SwchGamepadAimAssistMelee" ), "#GAMEPADCUSTOM_ASSIST_MELEE", "#GAMEPADCUSTOM_ASSIST_MELEE_DESC", $"" ) )
	
	//
	file.aimAssistItems.append( SetupSettingsButton( Hud_GetChild( contentPanel, "SwchGamepadAimAssistHipLowPowerScope" ), "#GAMEPADCUSTOM_ASSIST_HIP_LOW_POWER", "#GAMEPADCUSTOM_ASSIST_HIP_LOW_POWER_DESC", $"" ) )
	file.aimAssistItems.append( SetupSettingsButton( Hud_GetChild( contentPanel, "SwchGamepadAimAssistHipHighPowerScope" ), "#GAMEPADCUSTOM_ASSIST_HIP_HIGH_POWER", "#GAMEPADCUSTOM_ASSIST_HIP_HIGH_POWER_DESC", $"" ) )
	
	//
	file.aimAssistItems.append( SetupSettingsButton( Hud_GetChild( contentPanel, "SwchCustomAimAssistEnabled0" ), "#PEROPTICADS_0", "#PEROPTIC_AIMASSIST_ENABLED_DESC", $"" ) )
	file.aimAssistItems.append( SetupSettingsButton( Hud_GetChild( contentPanel, "SwchCustomAimAssistEnabled1" ), "#PEROPTICADS_1", "#PEROPTIC_AIMASSIST_ENABLED_DESC", $"" ) )
	file.aimAssistItems.append( SetupSettingsButton( Hud_GetChild( contentPanel, "SwchCustomAimAssistEnabled2" ), "#PEROPTICADS_2", "#PEROPTIC_AIMASSIST_ENABLED_DESC", $"" ) )
	file.aimAssistItems.append( SetupSettingsButton( Hud_GetChild( contentPanel, "SwchCustomAimAssistEnabled3" ), "#PEROPTICADS_3", "#PEROPTIC_AIMASSIST_ENABLED_DESC", $"" ) )
	file.aimAssistItems.append( SetupSettingsButton( Hud_GetChild( contentPanel, "SwchCustomAimAssistEnabled4" ), "#PEROPTICADS_4", "#PEROPTIC_AIMASSIST_ENABLED_DESC", $"" ) )
	file.aimAssistItems.append( SetupSettingsButton( Hud_GetChild( contentPanel, "SwchCustomAimAssistEnabled5" ), "#PEROPTICADS_5", "#PEROPTIC_AIMASSIST_ENABLED_DESC", $"" ) )
	file.aimAssistItems.append( SetupSettingsButton( Hud_GetChild( contentPanel, "SwchCustomAimAssistEnabled6" ), "#PEROPTICADS_6", "#PEROPTIC_AIMASSIST_ENABLED_DESC", $"" ) )
	
	ScrollPanel_InitPanel( panel )
	ScrollPanel_InitScrollBar( panel, Hud_GetChild( panel, "ScrollBar" ) )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, LEFT, BUTTON_BACK, true, "#BACKBUTTON_RESTORE_DEFAULTS", "#RESTORE_DEFAULTS", OpenConfirmRestoreLookControlsDefaultsDialog )
	AddPanelFooterOption( panel, LEFT, -1, false, "#FOOTER_CHOICE_HINT", "" )
}


void function OnADSControlsPanel_Show( var panel )
{
	ScrollPanel_SetActive( panel, true )
}


void function OnADSControlsPanel_Hide( var panel )
{
	ScrollPanel_SetActive( panel, false )
	SavePlayerSettings()
}


void function OnOpenControlsADSMenuConsole()
{
	if ( IsLobby() )
		UI_SetPresentationType( ePresentationType.WEAPON_CATEGORY )
	SetBlurEnabled( true )

	ShowPanel( Hud_GetChild( file.menu, "ADSControlsPanel" ) )//
	Button_Toggle_ADSEnabled( null )
	
	//
	bool aimAssistSettingsEnabled = true//GetConVarBool( "gamepad_aim_assist_sniper_scopes" ) // DOES NOT EXIST
	if ( aimAssistSettingsEnabled )
	{
		Button_Toggle_AimAssistEnabled( null )
	}
	else
	{
		Hud_SetVisible( Hud_GetChild( file.contentPanel, "CustomAimAssistHeader" ), false )
		Hud_SetVisible( Hud_GetChild( file.contentPanel, "CustomAimAssistHeaderText" ), false )
		Hud_SetVisible( Hud_GetChild( file.contentPanel, "SwchGamepadAimAssist" ), false )
		Hud_SetVisible( Hud_GetChild( file.contentPanel, "SwchGamepadAimAssistMelee" ), false )
		
		Hud_SetVisible( Hud_GetChild( file.contentPanel, "CustomAimAssistHipHeader" ), false )
		Hud_SetVisible( Hud_GetChild( file.contentPanel, "CustomAimAssistHipHeaderText" ), false )
		Hud_SetVisible( Hud_GetChild( file.contentPanel, "CustomAimAssistADSHeader" ), false )
		Hud_SetVisible( Hud_GetChild( file.contentPanel, "CustomAimAssistADSHeaderText" ), false )
		
		foreach ( var item in file.aimAssistItems )
			Hud_SetVisible( item, false )
	}
}

void function Button_Toggle_ADSEnabled( var button )
{
	bool isEnabled = GetConVarBool( "gamepad_use_per_scope_ads_settings" )

	foreach ( var item in file.customItems )
		Hud_SetEnabled( item, isEnabled )

	foreach ( var item in file.defaultItems )
		Hud_SetEnabled( item, !isEnabled )
}


void function OpenConfirmRestoreLookControlsDefaultsDialog( var button )
{
	ConfirmDialogData data
	data.headerText = "#RESTORE_LOOK_DEFAULTS"
	data.messageText = "#RESTORE_LOOK_DEFAULTS_DESC"
	data.resultCallback = void function ( int result ) : ()
	{
		if ( result != eDialogResult.YES )
			return

		RestoreADSDefaultsGamePad()
		Button_Toggle_ADSEnabled( null )
		Button_Toggle_AimAssistEnabled( null )
	}
	OpenConfirmDialogFromData( data )
}


void function Button_Toggle_AimAssistEnabled( var button )
{
	bool isEnabled = GetConVarBool( "gamepad_custom_assist_on" )

	foreach ( var item in file.aimAssistItems )
		Hud_SetEnabled( item, isEnabled )
}


void function RestoreADSDefaultsGamePad()
{
	SetConVarToDefault( "gamepad_use_per_scope_ads_settings" )
	SetConVarToDefault( "gamepad_aim_speed_ads_0" )
	SetConVarToDefault( "gamepad_aim_speed_ads_1" )
	SetConVarToDefault( "gamepad_aim_speed_ads_2" )
	SetConVarToDefault( "gamepad_aim_speed_ads_3" )
	SetConVarToDefault( "gamepad_aim_speed_ads_4" )
	SetConVarToDefault( "gamepad_aim_speed_ads_5" )
	SetConVarToDefault( "gamepad_aim_speed_ads_6" )
	SetConVarToDefault( "gamepad_aim_speed_ads_7" )
	SetConVarToDefault( "gamepad_custom_assist_on" )
	SetConVarToDefault( "gamepad_aim_assist_melee" )
	SetConVarToDefault( "gamepad_aim_assist_hip_low_power_scopes" )
	SetConVarToDefault( "gamepad_aim_assist_hip_high_power_scopes" )
	SetConVarToDefault( "gamepad_aim_assist_scope_0" )
	SetConVarToDefault( "gamepad_aim_assist_scope_1" )
	SetConVarToDefault( "gamepad_aim_assist_scope_2" )
	SetConVarToDefault( "gamepad_aim_assist_scope_3" )
	SetConVarToDefault( "gamepad_aim_assist_scope_4" )
	SetConVarToDefault( "gamepad_aim_assist_scope_5" )
	SetConVarToDefault( "gamepad_aim_assist_scope_6" )
	
	SavePlayerSettings()
}
