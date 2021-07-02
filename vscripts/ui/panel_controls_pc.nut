// TODO: Change code to apply binds instantly. Script has needed to call KeyBindings_Apply( file.panel ) thus far.

global function InitControlsPCPanel
global function InitControlsPCPanelForCode
global function AddKeyBindEvent
global function RestoreMouseKeyboardDefaults
global function ControlsPCPanel_GetConVarData

struct
{
	var panel
	var keyBindingPanel
	//var itemDescriptionBox

	table<var, string> buttonTitles
	table<var, string> buttonDescriptions
	var detailsPanel

	var keyBindMessage
	int messageUpdateID = -1

	array<ConVarData>    conVarDataList
} file



void function InitControlsPCPanelForCode( var panel )
{
	file.keyBindingPanel = CreateKeyBindingPanel( panel, "ContentPanel", $"resource/ui/menus/panels/controls_pc.res" )
	Hud_SetPos( file.keyBindingPanel, 0, 0 ) // TEMP
	//
	Assert( Hud_HasChild( file.keyBindingPanel, "PanelFrame" ) )
	UISize elementSize = REPLACEHud_GetSize( Hud_GetChild( file.keyBindingPanel, "PanelFrame" ) )
	Hud_SetSize( file.keyBindingPanel, elementSize.width, elementSize.height )
	Hud_Hide( file.keyBindingPanel )
	//
	//// reset first in case we reset the UI. don't want to double register
	KeyBindings_ClearTappedHeldPairs( file.keyBindingPanel )
	KeyBindings_AddTappedHeldPair( file.keyBindingPanel, "weaponSelectOrdnance", "+strafe" )
	KeyBindings_AddTappedHeldPair( file.keyBindingPanel, "+scriptCommand4", "+scriptCommand2" )
}


void function InitControlsPCPanel( var panel )
{
	file.panel = panel

	file.keyBindMessage = Hud_GetChild( file.keyBindingPanel, "KeyBindMessage" )
	Hud_SetVisible( file.keyBindMessage, true )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, OnControlsPCPanel_Show )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, OnControlsPCPanel_Hide )

	//file.itemDescriptionBox = Hud_GetChild( panel, "LblMenuItemDescription" )

	SetupSettingsSlider( Hud_GetChild( file.keyBindingPanel, "SldMouseSensitivity" ), "#MOUSE_SENSITIVITY", "#MOUSE_KEYBOARD_MENU_SENSITIVITY_DESC", $"rui/menu/settings/settings_pc" )

	var button = SetupSettingsButton( Hud_GetChild( file.keyBindingPanel, "BtnLookSensitivityMenu" ), "#MENU_MOUSE_SENSITIVITY_ZOOM", "#MOUSE_KEYBOARD_MENU_SENSITIVITY_ZOOM_DESC", $"rui/menu/settings/settings_pc" )
	AddButtonEventHandler( button, UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "ControlsAdvancedLookMenuPC" ) ) )

	SetupSettingsButton( Hud_GetChild( file.keyBindingPanel, "SwchMouseAcceleration" ), "#MOUSE_ACCELERATION", "#MOUSE_KEYBOARD_MENU_ACCELERATION_DESC", $"rui/menu/settings/settings_pc" )
	SetupSettingsButton( Hud_GetChild( file.keyBindingPanel, "SwchMouseInvertY" ), "#MOUSE_INVERT", "#MOUSE_KEYBOARD_MENU_INVERT_DESC", $"rui/menu/settings/settings_pc" )
	SetupSettingsButton( Hud_GetChild( file.keyBindingPanel, "SwchLightingEffects" ), "#LIGHTING_EFFECTS", "#MOUSE_KEYBOARD_MENU_LIGHTING_DESC", $"rui/menu/settings/settings_pc" )

	ScrollPanel_InitPanel( panel )
	ScrollPanel_InitScrollBar( panel, Hud_GetChild( panel, "ScrollBar" ) )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, LEFT, BUTTON_BACK, true, "#BACKBUTTON_RESTORE_DEFAULTS", "#RESTORE_DEFAULTS", OpenConfirmRestoreMouseKeyboardDefaultsDialog )
	AddPanelFooterOption( panel, LEFT, -1, false, "#FOOTER_CHOICE_HINT", "" )

	file.conVarDataList.append( CreateSettingsConVarData( "mouse_sensitivity", eConVarType.FLOAT ) )
	file.conVarDataList.append( CreateSettingsConVarData( "mouse_zoomed_sensitivity_scalar_0", eConVarType.FLOAT ) )
	file.conVarDataList.append( CreateSettingsConVarData( "m_acceleration", eConVarType.INT ) )
	file.conVarDataList.append( CreateSettingsConVarData( "m_invert_pitch", eConVarType.INT ) )
}


void function OnControlsPCPanel_Show( var panel )
{
	ScrollPanel_SetActive( panel, true )
	Hud_Show( file.keyBindingPanel )
	KeyBindings_FillInCurrent( file.keyBindingPanel )
}

void function OnControlsPCPanel_Hide( var panel )
{
	ScrollPanel_SetActive( panel, false )
	Hud_Hide( file.keyBindingPanel )

	SaveSettingsConVars( file.conVarDataList )
	SavePlayerSettings()

	RunClientScript( "UpdateWeaponStatusOnBindingChange" )
}


void function OpenConfirmRestoreMouseKeyboardDefaultsDialog( var button )
{
	if ( KeyBindings_IsBindingOverlayPanelVisible( file.keyBindingPanel ) )
		return

	ConfirmDialogData data
	data.headerText = "#RESTORE_PC_DEFAULTS"
	data.messageText = "#RESTORE_PC_DEFAULTS_DESC"
	data.resultCallback = OnConfirmDialogResult

	OpenConfirmDialogFromData( data )
}

void function OnConfirmDialogResult( int result )
{
	switch ( result )
	{
		case eDialogResult.YES:
			RestoreMouseKeyboardDefaults()
	}
}


void function RestoreMouseKeyboardDefaults()
{
	SetConVarToDefault( "mouse_sensitivity" )
	SetConVarToDefault( "mouse_zoomed_sensitivity_scalar_0" )
	SetConVarToDefault( "m_acceleration" )
	SetConVarToDefault( "m_invert_pitch" )

	RestoreADSDefaultsPC()

	SaveSettingsConVars( file.conVarDataList )

	KeyBindings_ResetToDefault( file.keyBindingPanel )
}

void function SetKeyBindMessage( string message, bool isUnbind )
{
	bool visible = message != ""

	var rui = Hud_GetRui( file.keyBindMessage )

	RuiSetString( rui, "messageText", message )
	file.messageUpdateID++
	RuiSetInt( rui, "updateID", file.messageUpdateID )
	RuiSetBool( rui, "isUnbind", isUnbind )
}

void function AddKeyBindEvent( string key, string binding, string oldBinding = "" )
{
	var rui = Hud_GetRui( file.keyBindMessage )
	string messageText = ""

	bool isUnbind
	if ( oldBinding != "" && binding != "" )
	{
		isUnbind = true
		messageText = Localize( "#SETTING_BIND_REPLACE", key, Localize( oldBinding ), Localize( binding ) )
	}
	else if ( oldBinding != "" )
	{
		isUnbind = true
		messageText = Localize( "#SETTING_BIND_UNBIND", key, Localize( oldBinding ) )
	}
	else if ( binding != "" )
	{
		isUnbind = false
		messageText = Localize( "#SETTING_BIND_BIND", key, Localize( binding ) )
	}

	SetKeyBindMessage( messageText, isUnbind )
}

array<ConVarData> function ControlsPCPanel_GetConVarData()
{
	return file.conVarDataList
}
