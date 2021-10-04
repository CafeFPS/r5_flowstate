
global function InitControlsAdvancedLookMenu
global function InitAdvancedLookControlsPanel
global function RestoreLookControlsDefaults

struct
{
	var                menu
	var                panel
	table<var, string> buttonTitles
	table<var, string> buttonDescriptions
	var                detailsPanel
	var                contentPanel

	array<ConVarData> conVarDataList

	array<var> enableItems
	array<var> graphEnablingItems
	array<var> graphs
} file

//

void function InitControlsAdvancedLookMenu( var newMenuArg )
{
	var menu = GetMenu( "ControlsAdvancedLookMenu" )
	file.menu = menu

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpenControlsAdvancedLookMenu )
}


void function InitAdvancedLookControlsPanel( var panel )
{
	file.panel = panel
	file.detailsPanel = Hud_GetChild( panel, "DetailsPanel" )
	var contentPanel = Hud_GetChild( panel, "ContentPanel" )
	file.contentPanel = contentPanel

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, OnAdvancedLookControlsPanel_Show )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, OnAdvancedLookControlsPanel_Hide )

	var button = Hud_GetChild( contentPanel, "SwchGamepadCustomEnabled" )
	//
	SetupButtonBase( button, "#GAMEPADCUSTOM_ENABLED", "#GAMEPADCUSTOM_ENABLED_DESC" )
	AddButtonEventHandler( button, UIE_CHANGE, Button_Toggle_CustomEnabled )

	file.graphEnablingItems.append( SetupSlider( Hud_GetChild( contentPanel, "SldGamepadCustomDeadzoneIn" ), "#GAMEPADCUSTOM_DEADZONE_IN", "#GAMEPADCUSTOM_DEADZONE_IN_DESC" ) )
	file.graphEnablingItems.append( SetupSlider( Hud_GetChild( contentPanel, "SldGamepadCustomDeadzoneOut" ), "#GAMEPADCUSTOM_DEADZONE_OUT", "#GAMEPADCUSTOM_DEADZONE_OUT_DESC" ) )
	file.graphEnablingItems.append( SetupSlider( Hud_GetChild( contentPanel, "SldGamepadCustomCurve" ), "#GAMEPADCUSTOM_CURVE", "#GAMEPADCUSTOM_CURVE_DESC" ) )

	SetupButton( Hud_GetChild( contentPanel, "SwchGamepadCustomAssist" ), "#GAMEPADCUSTOM_ASSIST",	"#GAMEPADCUSTOM_ASSIST_DESC" )

	//
	SetupSlider( Hud_GetChild( contentPanel, "SldGamepadCustomHipYaw" ),		"#GAMEPADCUSTOM_HIP_YAW",			"#GAMEPADCUSTOM_HIP_YAW_DESC" )
	SetupSlider( Hud_GetChild( contentPanel, "SldGamepadCustomHipPitch" ),		"#GAMEPADCUSTOM_HIP_PITCH",			"#GAMEPADCUSTOM_HIP_PITCH_DESC" )
	SetupSlider( Hud_GetChild( contentPanel, "SldGamepadCustomHipTurnYaw" ),	"#GAMEPADCUSTOM_HIP_TURN_YAW",		"#GAMEPADCUSTOM_HIP_TURN_YAW_DESC" )
	SetupSlider( Hud_GetChild( contentPanel, "SldGamepadCustomHipTurnPitch" ),	"#GAMEPADCUSTOM_HIP_TURN_PITCH",	"#GAMEPADCUSTOM_HIP_TURN_PITCH_DESC" )
	SetupSlider( Hud_GetChild( contentPanel, "SldGamepadCustomHipTurnTime" ),	"#GAMEPADCUSTOM_HIP_TURN_TIME",		"#GAMEPADCUSTOM_HIP_TURN_TIME_DESC" )
	SetupSlider( Hud_GetChild( contentPanel, "SldGamepadCustomHipTurnDelay" ),	"#GAMEPADCUSTOM_HIP_TURN_DELAY",	"#GAMEPADCUSTOM_HIP_TURN_DELAY_DESC" )

	SetupSlider( Hud_GetChild( contentPanel, "SldGamepadCustomADSYaw" ),		"#GAMEPADCUSTOM_ADS_YAW",			"#GAMEPADCUSTOM_ADS_YAW_DESC" )
	SetupSlider( Hud_GetChild( contentPanel, "SldGamepadCustomADSPitch" ),		"#GAMEPADCUSTOM_ADS_PITCH",			"#GAMEPADCUSTOM_ADS_PITCH_DESC" )
	SetupSlider( Hud_GetChild( contentPanel, "SldGamepadCustomADSTurnYaw" ),	"#GAMEPADCUSTOM_ADS_TURN_YAW",		"#GAMEPADCUSTOM_ADS_TURN_YAW_DESC" )
	SetupSlider( Hud_GetChild( contentPanel, "SldGamepadCustomADSTurnPitch" ),	"#GAMEPADCUSTOM_ADS_TURN_PITCH",	"#GAMEPADCUSTOM_ADS_TURN_PITCH_DESC" )
	SetupSlider( Hud_GetChild( contentPanel, "SldGamepadCustomADSTurnTime" ),	"#GAMEPADCUSTOM_ADS_TURN_TIME",		"#GAMEPADCUSTOM_ADS_TURN_TIME_DESC" )
	SetupSlider( Hud_GetChild( contentPanel, "SldGamepadCustomADSTurnDelay" ),	"#GAMEPADCUSTOM_ADS_TURN_DELAY",	"#GAMEPADCUSTOM_ADS_TURN_DELAY_DESC" )

	file.graphs.append( Hud_GetChild( panel, "DeadzonesGraph" ) )
	file.graphs.append( Hud_GetChild( panel, "CurveGraph" ) )

	ScrollPanel_InitPanel( panel )
	ScrollPanel_InitScrollBar( panel, Hud_GetChild( panel, "ScrollBar" ) )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, LEFT, BUTTON_BACK, true, "#BACKBUTTON_RESTORE_DEFAULTS", "#RESTORE_DEFAULTS", OpenConfirmRestoreLookControlsDefaultsDialog )
	AddPanelFooterOption( panel, LEFT, -1, false, "#FOOTER_CHOICE_HINT", "" )

	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
}


void function OnAdvancedLookControlsPanel_Show( var panel )
{
	ScrollPanel_SetActive( panel, true )
}


void function OnAdvancedLookControlsPanel_Hide( var panel )
{
	ScrollPanel_SetActive( panel, false )
	//
	SavePlayerSettings()
}

///////
///////
void function OnOpenControlsAdvancedLookMenu()
{
	if ( IsLobby() )
		UI_SetPresentationType( ePresentationType.WEAPON_CATEGORY )
	SetBlurEnabled( true )

	ShowPanel( Hud_GetChild( file.menu, "AdvancedLookControlsPanel" ) )

	Button_Toggle_CustomEnabled( null )
}


void function Button_Toggle_CustomEnabled( var button )
{
	bool isEnabled = GetConVarBool( "gamepad_custom_enabled" )

	foreach ( var item in file.enableItems )
		Hud_SetVisible( item, isEnabled )

	var btnGamepadCustomEnabled = Hud_GetChild( file.contentPanel, "SwchGamepadCustomEnabled" )
	var sldGamepadCustomDeadzoneIn = Hud_GetChild( file.contentPanel, "SldGamepadCustomDeadzoneIn" )
	if( isEnabled )
		Hud_SetNavDown( btnGamepadCustomEnabled, sldGamepadCustomDeadzoneIn )
	else
		Hud_SetNavDown( btnGamepadCustomEnabled, btnGamepadCustomEnabled )
}

///////
///////
void function SetupButtonBase( var button, string buttonText, string description )
{
	SetButtonRuiText( button, buttonText )
	file.buttonTitles[button] <- buttonText
	file.buttonDescriptions[button] <- description
	AddButtonEventHandler( button, UIE_GET_FOCUS, Button_Focused )
	AddButtonEventHandler( button, UIE_LOSE_FOCUS, Button_LoseFocus )
}


var function SetupButton( var button, string buttonText, string description )
{
	file.enableItems.append( button )
	SetupButtonBase( button, buttonText, description )

	return button
}


var function SetupSlider( var slider, string buttonText, string description )
{
	var button = Hud_GetChild( slider, "BtnDropButton" )

	file.enableItems.append( slider )

	SetButtonRuiText( button, buttonText )
	file.buttonTitles[button] <- buttonText
	file.buttonDescriptions[button] <- description
	AddButtonEventHandler( button, UIE_GET_FOCUS, DropButton_Focused )
	AddButtonEventHandler( button, UIE_LOSE_FOCUS, DropButton_Focused )
	Hud_AddEventHandler( slider, UIE_GET_FOCUS, Setting_Focused )

	return button
}


bool function RequiresGraphDisplay( var button )
{
	foreach ( var item in file.graphEnablingItems )
	{
		if ( item == button )
			return true
	}

	return false
}

void function DisplaySettingInfoForButton( var button )
{
	var rui = Hud_GetRui( file.detailsPanel )
	RuiSetArg( rui, "selectionText", file.buttonTitles[button] )
	RuiSetArg( rui, "descText", file.buttonDescriptions[button] )
	RuiSetAsset( rui, "detailImage", $"" )
	RuiSetBool( rui, "showCbInfo", false )

	bool requiresGraph = RequiresGraphDisplay( button )
	foreach ( var graph in file.graphs )
		Hud_SetVisible( graph, requiresGraph )
}

void function Button_Focused( var button )
{
	DisplaySettingInfoForButton( button )
	Setting_Focused( button )
}

void function Button_LoseFocus( var button )
{
	var rui = Hud_GetRui( file.detailsPanel )
	RuiSetArg( rui, "selectionText", "" )
	RuiSetArg( rui, "descText", "" )

	foreach ( var graph in file.graphs )
		Hud_SetVisible( graph, false )
}

void function DropButton_Focused( var button )
{
	DisplaySettingInfoForButton( button )
}

void function Setting_Focused( var panel )
{
	ScrollPanel_ScrollIntoView( file.panel )
}

void function OpenConfirmRestoreLookControlsDefaultsDialog( var button )
{
	ConfirmDialogData data
	data.headerText = "#RESTORE_LOOK_DEFAULTS"
	data.messageText = "#RESTORE_LOOK_DEFAULTS_DESC"
	data.resultCallback = OnConfirmDialogResult

	OpenConfirmDialogFromData( data )
	AdvanceMenu( GetMenu( "ConfirmDialog" ) )
}


void function OnConfirmDialogResult( int result )
{
	switch ( result )
	{
		case eDialogResult.YES:
			RestoreLookControlsDefaults()
	}
}


void function RestoreLookControlsDefaults()
{
	SetConVarToDefault( "gamepad_custom_deadzone_in" )
	SetConVarToDefault( "gamepad_custom_deadzone_out" )
	SetConVarToDefault( "gamepad_custom_curve" )
	SetConVarToDefault( "gamepad_custom_assist_on" )
	SetConVarToDefault( "gamepad_custom_hip_yaw" )
	SetConVarToDefault( "gamepad_custom_hip_pitch" )
	SetConVarToDefault( "gamepad_custom_hip_turn_yaw" )
	SetConVarToDefault( "gamepad_custom_hip_turn_pitch" )
	SetConVarToDefault( "gamepad_custom_hip_turn_delay" )
	SetConVarToDefault( "gamepad_custom_hip_turn_time" )
	SetConVarToDefault( "gamepad_custom_ads_yaw" )
	SetConVarToDefault( "gamepad_custom_ads_pitch" )
	SetConVarToDefault( "gamepad_custom_ads_turn_yaw" )
	SetConVarToDefault( "gamepad_custom_ads_turn_pitch" )
	SetConVarToDefault( "gamepad_custom_ads_turn_delay" )
	SetConVarToDefault( "gamepad_custom_ads_turn_time" )

	SavePlayerSettings()
}
