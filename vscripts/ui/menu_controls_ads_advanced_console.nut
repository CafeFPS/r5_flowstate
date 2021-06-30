
global function InitADSAdvancedControlsMenuConsole
global function InitADSAdvancedControlsPanelConsole
global function RestoreADSAdvancedDefaultsGamePad

struct
{
	var                menu
	var                panel
	table<var, string> buttonTitles
	table<var, string> buttonDescriptions
	var                detailsPanel
	var                contentPanel

	array<ConVarData> conVarDataList

	array<var> aimAssistItems
	array<var> adsSensitivityItems
} file


void function InitADSAdvancedControlsMenuConsole( var menu ) //
{
	file.menu = menu
	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpenControlsADSAdvancedMenuConsole )
}


void function InitADSAdvancedControlsPanelConsole( var panel )
{
	file.panel = panel
	file.detailsPanel = Hud_GetChild( panel, "DetailsPanel" )
	var contentPanel = Hud_GetChild( panel, "ContentPanel" )
	file.contentPanel = contentPanel

	//
	bool aimAssistSettingsEnabled = true//GetConVarBool( "gamepad_aim_assist_sniper_scopes" ) // DOES NOT EXIST
	if ( aimAssistSettingsEnabled )
	{
		Hud_SetHeight( file.contentPanel, 1480 )
	}
	else
	{
		Hud_SetHeight( file.contentPanel, 750 )
		var firstADSSensitivityButton = Hud_GetChild( contentPanel, "SwchCustomADSEnabled" )
		Hud_SetNavUp( firstADSSensitivityButton, firstADSSensitivityButton )
		var adsHeader = Hud_GetChild( contentPanel, "CustomADSHeader" )
		Hud_SetY( adsHeader, 0 )
		Hud_SetPinSibling( adsHeader, "CustomAimAssistHeader" )
	}
	
	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, OnADSAdvancedControlsPanel_Show )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, OnADSAdvancedControlsPanel_Hide )

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
	
	//
	var adsSensitivitybutton = Hud_GetChild( contentPanel, "SwchCustomADSEnabled" )
	SetupSettingsButton( adsSensitivitybutton, "#PEROPTICADS_ENABLED", "#PEROPTICADS_ENABLED_DESC", $"" )
	AddButtonEventHandler( adsSensitivitybutton, UIE_CHANGE, Button_Toggle_ADSAdvancedEnabled )
	
	//
	file.adsSensitivityItems.extend( SetupSettingsSlider( Hud_GetChild( contentPanel, "SldADSAdvancedSensitivity0" ), "#PEROPTICADS_0", "#GAMEPAD_MENU_SENSITIVITY_ZOOM_DESC", $"" ) )
	file.adsSensitivityItems.extend( SetupSettingsSlider( Hud_GetChild( contentPanel, "SldADSAdvancedSensitivity1" ), "#PEROPTICADS_1", "#GAMEPAD_MENU_SENSITIVITY_ZOOM_DESC", $"" ) )
	file.adsSensitivityItems.extend( SetupSettingsSlider( Hud_GetChild( contentPanel, "SldADSAdvancedSensitivity2" ), "#PEROPTICADS_2", "#GAMEPAD_MENU_SENSITIVITY_ZOOM_DESC", $"" ) )
	file.adsSensitivityItems.extend( SetupSettingsSlider( Hud_GetChild( contentPanel, "SldADSAdvancedSensitivity3" ), "#PEROPTICADS_3", "#GAMEPAD_MENU_SENSITIVITY_ZOOM_DESC", $"" ) )
	file.adsSensitivityItems.extend( SetupSettingsSlider( Hud_GetChild( contentPanel, "SldADSAdvancedSensitivity4" ), "#PEROPTICADS_4", "#GAMEPAD_MENU_SENSITIVITY_ZOOM_DESC", $"" ) )
	file.adsSensitivityItems.extend( SetupSettingsSlider( Hud_GetChild( contentPanel, "SldADSAdvancedSensitivity5" ), "#PEROPTICADS_5", "#GAMEPAD_MENU_SENSITIVITY_ZOOM_DESC", $"" ) )
	file.adsSensitivityItems.extend( SetupSettingsSlider( Hud_GetChild( contentPanel, "SldADSAdvancedSensitivity6" ), "#PEROPTICADS_6", "#GAMEPAD_MENU_SENSITIVITY_ZOOM_DESC", $"" ) )

	file.adsSensitivityItems.append( Hud_GetChild( contentPanel, "TextEntryADSAdvancedSensitivityZoomed0" ) )
	file.adsSensitivityItems.append( Hud_GetChild( contentPanel, "TextEntryADSAdvancedSensitivityZoomed1" ) )
	file.adsSensitivityItems.append( Hud_GetChild( contentPanel, "TextEntryADSAdvancedSensitivityZoomed2" ) )
	file.adsSensitivityItems.append( Hud_GetChild( contentPanel, "TextEntryADSAdvancedSensitivityZoomed3" ) )
	file.adsSensitivityItems.append( Hud_GetChild( contentPanel, "TextEntryADSAdvancedSensitivityZoomed4" ) )
	file.adsSensitivityItems.append( Hud_GetChild( contentPanel, "TextEntryADSAdvancedSensitivityZoomed5" ) )
	file.adsSensitivityItems.append( Hud_GetChild( contentPanel, "TextEntryADSAdvancedSensitivityZoomed6" ) )

	ScrollPanel_InitPanel( panel )
	ScrollPanel_InitScrollBar( panel, Hud_GetChild( panel, "ScrollBar" ) )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, LEFT, BUTTON_BACK, true, "#BACKBUTTON_RESTORE_DEFAULTS", "#RESTORE_DEFAULTS", OpenConfirmRestoreLookControlsAdvancedDefaultsDialog )
	AddPanelFooterOption( panel, LEFT, -1, false, "#FOOTER_CHOICE_HINT", "" )
}

void function OnADSAdvancedControlsPanel_Show( var panel )
{
	ScrollPanel_SetActive( panel, true )
}

void function OnADSAdvancedControlsPanel_Hide( var panel )
{
	ScrollPanel_SetActive( panel, false )
	SavePlayerSettings()
}

void function OnOpenControlsADSAdvancedMenuConsole()
{
	if ( IsLobby() )
		UI_SetPresentationType( ePresentationType.WEAPON_CATEGORY )
	SetBlurEnabled( true )

	ShowPanel( Hud_GetChild( file.menu, "ADSAdvancedControlsPanel" ) )
	Button_Toggle_ADSAdvancedEnabled( null )
	
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

void function Button_Toggle_ADSAdvancedEnabled( var button )
{
	bool isEnabled = GetConVarBool( "gamepad_use_per_scope_sensitivity_scalars" )

	foreach ( var item in file.adsSensitivityItems )
		Hud_SetVisible( item, isEnabled )
		
	var adsSensitivitybutton = Hud_GetChild( file.contentPanel, "SwchCustomADSEnabled" )
		
	if ( isEnabled )
		Hud_SetNavDown( adsSensitivitybutton, Hud_GetChild( file.contentPanel, "SldADSAdvancedSensitivity0" ) )
	else
		Hud_SetNavDown( adsSensitivitybutton, adsSensitivitybutton )
}

void function OpenConfirmRestoreLookControlsAdvancedDefaultsDialog( var button )
{
	ConfirmDialogData data
	data.headerText = "#RESTORE_LOOK_DEFAULTS"
	data.messageText = "#RESTORE_LOOK_DEFAULTS_DESC"
	data.resultCallback = void function ( int result ) : ()
	{
		if ( result != eDialogResult.YES )
			return

		RestoreADSAdvancedDefaultsGamePad()
		Button_Toggle_AimAssistEnabled( null )
		Button_Toggle_ADSAdvancedEnabled( null )
	}
	OpenConfirmDialogFromData( data )
}

void function Button_Toggle_AimAssistEnabled( var button )
{
	bool isEnabled = GetConVarBool( "gamepad_custom_assist_on" )

	foreach ( var item in file.aimAssistItems )
		Hud_SetEnabled( item, isEnabled )
}

void function RestoreADSAdvancedDefaultsGamePad()
{
	SetConVarToDefault( "gamepad_aim_assist_scope_0" )
	SetConVarToDefault( "gamepad_aim_assist_scope_1" )
	SetConVarToDefault( "gamepad_aim_assist_scope_2" )
	SetConVarToDefault( "gamepad_aim_assist_scope_3" )
	SetConVarToDefault( "gamepad_aim_assist_scope_4" )
	SetConVarToDefault( "gamepad_aim_assist_scope_5" )
	SetConVarToDefault( "gamepad_aim_assist_scope_6" )
	SetConVarToDefault( "gamepad_custom_assist_on" )
	SetConVarToDefault( "gamepad_aim_assist_melee" )
	SetConVarToDefault( "gamepad_aim_assist_hip_low_power_scopes" )
	SetConVarToDefault( "gamepad_aim_assist_hip_high_power_scopes" )
	SetConVarToDefault( "gamepad_use_per_scope_sensitivity_scalars" )
	SetConVarToDefault( "gamepad_ads_advanced_sensitivity_scalar_0" )
	SetConVarToDefault( "gamepad_ads_advanced_sensitivity_scalar_1" )
	SetConVarToDefault( "gamepad_ads_advanced_sensitivity_scalar_2" )
	SetConVarToDefault( "gamepad_ads_advanced_sensitivity_scalar_3" )
	SetConVarToDefault( "gamepad_ads_advanced_sensitivity_scalar_4" )
	SetConVarToDefault( "gamepad_ads_advanced_sensitivity_scalar_5" )
	SetConVarToDefault( "gamepad_ads_advanced_sensitivity_scalar_6" )
	SetConVarToDefault( "gamepad_ads_advanced_sensitivity_scalar_7" )

	SavePlayerSettings()
}
