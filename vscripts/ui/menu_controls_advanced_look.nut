
global function InitControlsAdvancedLookMenu
global function RestoreLookControlsDefaults

struct
{
	var menu
	table<var,string> buttonTitles
	table<var,string> buttonDescriptions
	var detailsPanel
	array<var> enableItems
	array<var> graphEnablingItems
	array<var> graphItems
	var topButton
} file

void function InitControlsAdvancedLookMenu()
{
	var menu = GetMenu( "ControlsAdvancedLookMenu" )
	file.menu = menu

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpenControlsAdvancedLookMenu )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnCloseControlsAdvancedLookMenu )
	//////////////////////////

	var button
	var slider

	button = Hud_GetChild( menu, "SwchGamepadCustomEnabled" )
	SetupButtonBase( button, "#GAMEPADCUSTOM_ENABLED", "#GAMEPADCUSTOM_ENABLED_DESC" )
	AddButtonEventHandler( button, UIE_CHANGE, Button_Toggle_CustomEnabled )
	file.topButton = button

	button = Hud_GetChild( menu, "BtnGamepadCustomResetToDefaults" )
	SetupButton( button, "#GAMEPADCUSTOM_RESET_TO_DEFAULTS", "#GAMEPADCUSTOM_RESET_TO_DEFAULTS_DESC" )
	AddButtonEventHandler( button, UIE_CLICK, OpenConfirmRestoreLookControlsDefaultsDialog )

	file.enableItems.append( Hud_GetChild( menu, "ImgGeneralSubheaderBackground2" ) )

	slider = Hud_GetChild( menu, "SldGamepadCustomDeadzoneIn" )
	button = SetupSlider( slider, "#GAMEPADCUSTOM_DEADZONE_IN", "#GAMEPADCUSTOM_DEADZONE_IN_DESC" )
	file.graphEnablingItems.append( button )

	slider = Hud_GetChild( menu, "SldGamepadCustomDeadzoneOut" )
	button = SetupSlider( slider, "#GAMEPADCUSTOM_DEADZONE_OUT", "#GAMEPADCUSTOM_DEADZONE_OUT_DESC" )
	file.graphEnablingItems.append( button )

	slider = Hud_GetChild( menu, "SldGamepadCustomCurve" )
	button = SetupSlider( slider, "#GAMEPADCUSTOM_CURVE", "#GAMEPADCUSTOM_CURVE_DESC" )
	file.graphEnablingItems.append( button )

	button = SetupButton( Hud_GetChild( menu, "SwchGamepadCustomAssist" ), "#GAMEPADCUSTOM_ASSIST",	"#GAMEPADCUSTOM_ASSIST_DESC" )

	//
	file.enableItems.append( Hud_GetChild( menu, "ImgGeneralSubheaderBackground3" ) )
	SetupSlider( Hud_GetChild( menu, "SldGamepadCustomHipYaw" ),		"#GAMEPADCUSTOM_HIP_YAW",			"#GAMEPADCUSTOM_HIP_YAW_DESC" )
	SetupSlider( Hud_GetChild( menu, "SldGamepadCustomHipPitch" ),		"#GAMEPADCUSTOM_HIP_PITCH",			"#GAMEPADCUSTOM_HIP_PITCH_DESC" )
	SetupSlider( Hud_GetChild( menu, "SldGamepadCustomHipTurnYaw" ),	"#GAMEPADCUSTOM_HIP_TURN_YAW",		"#GAMEPADCUSTOM_HIP_TURN_YAW_DESC" )
	SetupSlider( Hud_GetChild( menu, "SldGamepadCustomHipTurnPitch" ),	"#GAMEPADCUSTOM_HIP_TURN_PITCH",	"#GAMEPADCUSTOM_HIP_TURN_PITCH_DESC" )
	SetupSlider( Hud_GetChild( menu, "SldGamepadCustomHipTurnTime" ),	"#GAMEPADCUSTOM_HIP_TURN_TIME",		"#GAMEPADCUSTOM_HIP_TURN_TIME_DESC" )
	SetupSlider( Hud_GetChild( menu, "SldGamepadCustomHipTurnDelay" ),	"#GAMEPADCUSTOM_HIP_TURN_DELAY",	"#GAMEPADCUSTOM_HIP_TURN_DELAY_DESC" )
	//
	file.enableItems.append( Hud_GetChild( menu, "ImgGeneralSubheaderBackground4" ) )
	SetupSlider( Hud_GetChild( menu, "SldGamepadCustomADSYaw" ),		"#GAMEPADCUSTOM_ADS_YAW",			"#GAMEPADCUSTOM_ADS_YAW_DESC" )
	SetupSlider( Hud_GetChild( menu, "SldGamepadCustomADSPitch" ),		"#GAMEPADCUSTOM_ADS_PITCH",			"#GAMEPADCUSTOM_ADS_PITCH_DESC" )
	SetupSlider( Hud_GetChild( menu, "SldGamepadCustomADSTurnYaw" ),	"#GAMEPADCUSTOM_ADS_TURN_YAW",		"#GAMEPADCUSTOM_ADS_TURN_YAW_DESC" )
	SetupSlider( Hud_GetChild( menu, "SldGamepadCustomADSTurnPitch" ),	"#GAMEPADCUSTOM_ADS_TURN_PITCH",	"#GAMEPADCUSTOM_ADS_TURN_PITCH_DESC" )
	SetupSlider( Hud_GetChild( menu, "SldGamepadCustomADSTurnTime" ),	"#GAMEPADCUSTOM_ADS_TURN_TIME",		"#GAMEPADCUSTOM_ADS_TURN_TIME_DESC" )
	SetupSlider( Hud_GetChild( menu, "SldGamepadCustomADSTurnDelay" ),	"#GAMEPADCUSTOM_ADS_TURN_DELAY",	"#GAMEPADCUSTOM_ADS_TURN_DELAY_DESC" )

	//
	file.graphItems.append( Hud_GetChild( menu, "DeadzonesGraph" ) )
	file.graphItems.append( Hud_GetChild( menu, "CurveGraph" ) )

	//Hud_EnableKeyBindingIcons( Hud_GetChild( menu, "LblMenuItemDescription" ) )


	//SetupButton( Hud_GetChild( Hud_GetChild( menu, "SldMouseSensitivity" ), "BtnDropButton" ), "#MOUSE_SENSITIVITY", "#MOUSE_KEYBOARD_MENU_SENSITIVITY_DESC" )
	//SetupButton( Hud_GetChild( menu, "SwchMouseAcceleration" ), "#MOUSE_ACCELERATION", "#MOUSE_KEYBOARD_MENU_ACCELERATION_DESC" )

	//button = Hud_GetChild( menu, "BtnControllerResetToDefaults" )
	//SetupButton( button, "#RESTORE_DEFAULTS", "#RESET_CONTROLLER_TO_DEFAULT_DESC" )
	//AddButtonEventHandler( button, UIE_CLICK, GamepadControlsResetToDefaultsDialog )

	//////////////////////////
#if PC_PROG
	AddEventHandlerToButtonClass( menu, "LeftRuiFooterButtonClass", UIE_GET_FOCUS, FooterButton_Focused )
#endif //PC_PROG

	AddMenuFooterOption( menu, LEFT, BUTTON_A, true, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
#if DURANGO_PROG
	AddMenuFooterOption( menu, LEFT, BUTTON_Y, true, "#Y_BUTTON_XBOX_HELP", "", OpenXboxHelp )
#endif // DURANGO_PROG
}

///////
///////
void function OnOpenControlsAdvancedLookMenu()
{
	UI_SetPresentationType( ePresentationType.WEAPON_CATEGORY )
	Button_Toggle_CustomEnabled( null )

	thread HACK_DelayedSetFocus_BecauseWhy( file.topButton )
}

void function OnCloseControlsAdvancedLookMenu()
{
}

void function Button_Toggle_CustomEnabled( var button )
{
	bool isEnabled = GetConVarBool( "gamepad_custom_enabled" )

	foreach ( var item in file.enableItems )
		Hud_SetVisible( item, isEnabled )
}

///////
///////
void function SetupButtonBase( var button, string buttonText, string description )
{
	SetButtonRuiText( button, buttonText )
	file.buttonDescriptions[ button ] <- description
	AddButtonEventHandler( button, UIE_GET_FOCUS, Button_Focused )
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
	file.buttonDescriptions[ button ] <- description
	AddButtonEventHandler( button, UIE_GET_FOCUS, Button_Focused )

	return button
}

bool function IsAGraphEnablingItem( var button )
{
	foreach ( var item in file.graphEnablingItems )
	{
		if ( item == button )
			return true
	}
	return false
}

void function Button_Focused( var button )
{
	string description = file.buttonDescriptions[ button ]
	SetElementsTextByClassname( file.menu, "MenuItemDescriptionClass", description )

	bool areGraphsEnabled = IsAGraphEnablingItem( button )
	foreach ( var graph in file.graphItems )
		Hud_SetVisible( graph, areGraphsEnabled )
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
}

void function DisableAimassistSetting()
{
	SetConVarInt( "gamepad_custom_assist_on", 0 )
}

#if PC_PROG
void function FooterButton_Focused( var button )
{
	SetElementsTextByClassname( file.menu, "MenuItemDescriptionClass", "" )
}
#endif //PC_PROG
