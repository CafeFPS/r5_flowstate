
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

	array<var> adsSensitivityItems
} file


void function InitADSAdvancedControlsMenuConsole( var menu ) 
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

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, OnADSAdvancedControlsPanel_Show )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, OnADSAdvancedControlsPanel_Hide )

	
	var adsSensitivitybutton = Hud_GetChild( contentPanel, "SwchCustomADSEnabled" )
	SetupSettingsButton( adsSensitivitybutton, "#PEROPTICADS_ENABLED", "#PEROPTICADS_ENABLED_DESC", $"" )
	AddButtonEventHandler( adsSensitivitybutton, UIE_CHANGE, Button_Toggle_ADSAdvancedEnabled )

	
	file.adsSensitivityItems.extend( SetupSettingsSlider( Hud_GetChild( contentPanel, "SldADSAdvancedSensitivity0" ), "#PEROPTICADS_0", "#GAMEPAD_MENU_SENSITIVITY_ZOOM_DESC", $"" ) )
	file.adsSensitivityItems.extend( SetupSettingsSlider( Hud_GetChild( contentPanel, "SldADSAdvancedSensitivity1" ), "#PEROPTICADS_1", "#GAMEPAD_MENU_SENSITIVITY_ZOOM_DESC_2x", $"" ) )
	file.adsSensitivityItems.extend( SetupSettingsSlider( Hud_GetChild( contentPanel, "SldADSAdvancedSensitivity2" ), "#PEROPTICADS_2", "#GAMEPAD_MENU_SENSITIVITY_ZOOM_DESC_3x", $"" ) )
	file.adsSensitivityItems.extend( SetupSettingsSlider( Hud_GetChild( contentPanel, "SldADSAdvancedSensitivity3" ), "#PEROPTICADS_3", "#GAMEPAD_MENU_SENSITIVITY_ZOOM_DESC", $"" ) )
	file.adsSensitivityItems.extend( SetupSettingsSlider( Hud_GetChild( contentPanel, "SldADSAdvancedSensitivity4" ), "#PEROPTICADS_4", "#GAMEPAD_MENU_SENSITIVITY_ZOOM_DESC", $"" ) )
	file.adsSensitivityItems.extend( SetupSettingsSlider( Hud_GetChild( contentPanel, "SldADSAdvancedSensitivity5" ), "#PEROPTICADS_5", "#GAMEPAD_MENU_SENSITIVITY_ZOOM_DESC_8x", $"" ) )
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
	ScrollPanel_Refresh( panel )
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
		Button_Toggle_ADSAdvancedEnabled( null )
	}
	OpenConfirmDialogFromData( data )
}

void function RestoreADSAdvancedDefaultsGamePad()
{
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
