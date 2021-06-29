
global function InitADSControlsMenuPC
global function InitADSControlsPanelPC
global function RestoreADSDefaultsPC

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
} file


void function InitADSControlsMenuPC( var menu ) //
{
	file.menu = menu
	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpenControlsADSMenuPC )
}


void function InitADSControlsPanelPC( var panel )
{
	file.panel = panel
	file.detailsPanel = Hud_GetChild( panel, "DetailsPanel" )
	var contentPanel = Hud_GetChild( panel, "ContentPanel" )
	file.contentPanel = contentPanel

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, OnADSControlsPanel_Show )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, OnADSControlsPanel_Hide )

	SetupSettingsSlider( Hud_GetChild( contentPanel, "SldMouseSensitivity" ), "#MOUSE_SENSITIVITY", "#MOUSE_KEYBOARD_MENU_SENSITIVITY_DESC", $"rui/menu/settings/settings_pc" )

	var button = Hud_GetChild( contentPanel, "SwchCustomADSEnabled" )
	SetupSettingsButton( button, "#PEROPTICADS_ENABLED", "#PEROPTICADS_ENABLED_DESC", $"" )
	AddButtonEventHandler( button, UIE_CHANGE, Button_Toggle_ADSEnabled )

	file.defaultItems.extend( SetupSettingsSlider( Hud_GetChild( contentPanel, "SldMouseSensitivityZoomed" ), "#MOUSE_SENSITIVITY_ZOOM", "#MOUSE_KEYBOARD_MENU_SENSITIVITY_ZOOM_DESC", $"rui/menu/settings/settings_pc" ) )
	file.defaultItems.append( Hud_GetChild( contentPanel, "TextEntryMouseSensitivityZoomed" ) )

	file.customItems.extend( SetupSettingsSlider( Hud_GetChild( contentPanel, "SldSensitivity0" ), "#PEROPTICADS_0", "#MOUSE_KEYBOARD_MENU_SENSITIVITY_ZOOM_DESC", $"rui/menu/settings/settings_pc" ) )
	file.customItems.extend( SetupSettingsSlider( Hud_GetChild( contentPanel, "SldSensitivity1" ), "#PEROPTICADS_1", "#MOUSE_KEYBOARD_MENU_SENSITIVITY_ZOOM_DESC", $"rui/menu/settings/settings_pc" ) )
	file.customItems.extend( SetupSettingsSlider( Hud_GetChild( contentPanel, "SldSensitivity2" ), "#PEROPTICADS_2", "#MOUSE_KEYBOARD_MENU_SENSITIVITY_ZOOM_DESC", $"rui/menu/settings/settings_pc" ) )
	file.customItems.extend( SetupSettingsSlider( Hud_GetChild( contentPanel, "SldSensitivity3" ), "#PEROPTICADS_3", "#MOUSE_KEYBOARD_MENU_SENSITIVITY_ZOOM_DESC", $"rui/menu/settings/settings_pc" ) )
	file.customItems.extend( SetupSettingsSlider( Hud_GetChild( contentPanel, "SldSensitivity4" ), "#PEROPTICADS_4", "#MOUSE_KEYBOARD_MENU_SENSITIVITY_ZOOM_DESC", $"rui/menu/settings/settings_pc" ) )
	file.customItems.extend( SetupSettingsSlider( Hud_GetChild( contentPanel, "SldSensitivity5" ), "#PEROPTICADS_5", "#MOUSE_KEYBOARD_MENU_SENSITIVITY_ZOOM_DESC", $"rui/menu/settings/settings_pc" ) )
	file.customItems.extend( SetupSettingsSlider( Hud_GetChild( contentPanel, "SldSensitivity6" ), "#PEROPTICADS_6", "#MOUSE_KEYBOARD_MENU_SENSITIVITY_ZOOM_DESC", $"rui/menu/settings/settings_pc" ) )

	file.customItems.append( Hud_GetChild( contentPanel, "TextEntryMouseSensitivityZoomed0" ) )
	file.customItems.append( Hud_GetChild( contentPanel, "TextEntryMouseSensitivityZoomed1" ) )
	file.customItems.append( Hud_GetChild( contentPanel, "TextEntryMouseSensitivityZoomed2" ) )
	file.customItems.append( Hud_GetChild( contentPanel, "TextEntryMouseSensitivityZoomed3" ) )
	file.customItems.append( Hud_GetChild( contentPanel, "TextEntryMouseSensitivityZoomed4" ) )
	file.customItems.append( Hud_GetChild( contentPanel, "TextEntryMouseSensitivityZoomed5" ) )
	file.customItems.append( Hud_GetChild( contentPanel, "TextEntryMouseSensitivityZoomed6" ) )

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


void function OnOpenControlsADSMenuPC()
{
	if ( IsLobby() )
		UI_SetPresentationType( ePresentationType.WEAPON_CATEGORY )
	SetBlurEnabled( true )

	ShowPanel( Hud_GetChild( file.menu, "ADSControlsPanel" ) )//
	Button_Toggle_ADSEnabled( null )
}

void function Button_Toggle_ADSEnabled( var button )
{
	bool isEnabled = GetConVarBool( "mouse_use_per_scope_sensitivity_scalars" )

	foreach ( var item in file.customItems )
		Hud_SetVisible( item, isEnabled )

	foreach ( var item in file.defaultItems )
		Hud_SetVisible( item, !isEnabled )
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

		RestoreADSDefaultsPC()
		Button_Toggle_ADSEnabled( null )
	}
	OpenConfirmDialogFromData( data )
}


void function RestoreADSDefaultsPC()
{
	SetConVarToDefault( "mouse_sensitivity" )
	SetConVarToDefault( "mouse_use_per_scope_sensitivity_scalars" )
	SetConVarToDefault( "mouse_zoomed_sensitivity_scalar_0" )
	SetConVarToDefault( "mouse_zoomed_sensitivity_scalar_1" )
	SetConVarToDefault( "mouse_zoomed_sensitivity_scalar_2" )
	SetConVarToDefault( "mouse_zoomed_sensitivity_scalar_3" )
	SetConVarToDefault( "mouse_zoomed_sensitivity_scalar_4" )
	SetConVarToDefault( "mouse_zoomed_sensitivity_scalar_5" )
	SetConVarToDefault( "mouse_zoomed_sensitivity_scalar_6" )
	SetConVarToDefault( "mouse_zoomed_sensitivity_scalar_7" )

	SavePlayerSettings()
}
