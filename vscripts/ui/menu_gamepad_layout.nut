untyped

global function MenuGamepadLayout_Init

global function GetGamepadButtonLayoutIndex
global function ExecCurrentGamepadButtonConfig
global function ExecCurrentGamepadStickConfig
global function InitGamepadLayoutMenu
global function GetGamepadButtonLayoutName
global function RefreshButtonBinds

//script_ui AdvanceMenu( GetMenu( "GamepadLayoutMenu" ) )


struct ButtonVars
{
	string common
	string pilot
	string titan
}

struct ButtonData
{
	int    buttonEnum
	int    buttonIndex
	string ruiArg
	bool   isLeft
}

struct
{
	var                menu
	var                gamepadButtonLayoutBG
	table<int, string> buttonToRuiArg
	array<ButtonData>  buttonData

	var        customBackgroundPilot
	array<var> customBindButtonsPilot

	int pilotBindFocusIndex

	var gamepadLayoutRui

	var description
} file


void function MenuGamepadLayout_Init()
{
}


string function GetGamepadButtonLayoutName()
{
	int id = GetGamepadButtonLayoutIndex()
	switch ( id )
	{
		case 0:
			return "#GAMEPAD_CUSTOM"

		default:
			break
	}

	return "unk_gamepad_button_layout"
}


int function GetGamepadButtonLayoutIndex()
{
	int id = GetConVarInt( "gamepad_button_layout" )
	if ( (id < 0) || (id >= uiGlobal.buttonConfigs.len()) )
		id = 0
	return id
}


int function GetGamepadStickLayout()
{
	int id = GetConVarInt( "gamepad_stick_layout" )
	if ( (id < 0) || (id >= uiGlobal.stickConfigs.len()) )
		id = 0
	return id
}


string function GetButtonStance()
{
	string stance = "orthodox"
	if ( GetConVarInt( "gamepad_buttons_are_southpaw" ) != 0 )
		stance = "southpaw"

	return stance
}


void function ExecCurrentGamepadButtonConfig()
{
	ExecConfig( uiGlobal.buttonConfigs[ GetGamepadButtonLayoutIndex() ][ GetButtonStance() ] )
}


void function ExecCurrentGamepadStickConfig()
{
	ExecConfig( uiGlobal.stickConfigs[ GetGamepadStickLayout() ] )
}

const int PRESETS_COUNT = 6

const array<string> PRESET_NAMES =
[
	"#GAMEPAD_BUTTON_PRESET_DEFAULT",
	"#GAMEPAD_BUTTON_PRESET_BUMPER_JUMPER",
	"#GAMEPAD_BUTTON_PRESET_BUTTON_PUNCHER",
	"#GAMEPAD_BUTTON_PRESET_EVOLVED",
	"#GAMEPAD_BUTTON_PRESET_GRENADIER",
	"#GAMEPAD_BUTTON_PRESET_NINJA",
]


const array<string> PRESET_DESCRIPTIONS =
[
	"#GAMEPAD_BUTTON_PRESET_DEFAULT_DESC",
	"#GAMEPAD_BUTTON_PRESET_BUMPER_JUMPER_DESC",
	"#GAMEPAD_BUTTON_PRESET_BUTTON_PUNCHER_DESC",
	"#GAMEPAD_BUTTON_PRESET_EVOLVED_DESC",
	"#GAMEPAD_BUTTON_PRESET_GRENADIER_DESC",
	"#GAMEPAD_BUTTON_PRESET_NINJA_DESC",
]


const array<string> PRESET_PILOT_BINDS =
[
	"0,1,2,3,4,5,6,7,8,9,10,11,12,13,14",
	"6,1,2,3,4,5,0,7,8,9,10,11,12,13,14",
	"0,9,2,3,4,5,6,7,8,1,10,11,12,13,14",
	"6,9,2,3,4,5,0,7,8,1,10,11,12,13,14",
	"0,1,2,3,4,5,6,13,8,9,7,11,12,10,14",
	"7,6,2,3,4,5,0,1,8,9,10,11,12,13,14",
]


int function GetButtonIndexForPreset( int buttonIndex, int presetIndex )
{
	array<int> arr = BuildCommandForButtonArrayFromString( PRESET_PILOT_BINDS[presetIndex] )
	return arr[buttonIndex]
}


void function InitGamepadLayoutMenu()
{
	var menu = GetMenu( "GamepadLayoutMenu" )
	file.menu = menu

	SetDialog( menu, true )

	file.gamepadLayoutRui = Hud_GetRui( Hud_GetChild( file.menu, "GamepadButtonLayoutBGRui" ) )

	HudElem_SetRuiArg( Hud_GetChild( file.menu, "DialogFrame" ), "headerText", "#MENU_BUTTON_LAYOUT" )
	InitButtonRCP( Hud_GetChild( file.menu, "DialogFrame" ) )


	// Preset binds:
	for ( int idx = 0; idx < PRESETS_COUNT; ++idx )
	{
		string btnName = "BtnPreset" + format( "%d", idx )
		var button     = Hud_GetChild( menu, btnName )
		int buttonID   = int( Hud_GetScriptID( button ) )
		Assert( (idx == buttonID), ("Button '" + btnName + "' needs its 'scriptID' value set correctly.") )

		AddButtonEventHandler( button, UIE_CLICK, OnPresetButton_Clicked )
		AddButtonEventHandler( button, UIE_GET_FOCUS, OnPresetButton_FocusedOn )
		AddButtonEventHandler( button, UIE_LOSE_FOCUS, OnPresetButton_FocusedOff )

		SetButtonRuiText( button, PRESET_NAMES[idx] )
	}

	////
	file.description = Hud_GetChild( menu, "lblControllerDescription" )

	////
	file.customBackgroundPilot = Hud_GetChild( menu, "PilotControlsBG" )
	for ( int idx = 0; idx < GAMEPAD_CUSTOM_BUTTONS_COUNT; ++idx )
	{
		string btnName = "BtnPilotBind" + format( "%02d", idx )
		var bindButton = Hud_GetChild( menu, btnName )
		file.customBindButtonsPilot.append( bindButton )

		var buttonRui = Hud_GetRui( bindButton )
		RuiSetBool( buttonRui, "alignedRight", false )

		ButtonVars bv = GetBindDisplayName( GetBindString( CUSTOM_BIND_ALIASES_PILOT[idx] ) )
		RuiSetString( buttonRui, "commandLabelCommon", bv.common )
		RuiSetString( buttonRui, "commandLabelSpecific", bv.pilot )

		Hud_SetVisible( bindButton, false )

		if ( idx > 13 )
		{
			RuiSetBool( buttonRui, "isBindable", false )
			//AddButtonEventHandler( bindButton, UIE_GET_FOCUS, UnbindableButtonPilot_FocusedOn )
			//AddButtonEventHandler( bindButton, UIE_LOSE_FOCUS, UnbindableButtonPilot_FocusedOff )
		}
		else
		{
			//AddButtonEventHandler( bindButton, UIE_GET_FOCUS, BindButtonPilot_FocusedOn )
			//AddButtonEventHandler( bindButton, UIE_LOSE_FOCUS, BindButtonPilot_FocusedOff )
			RuiSetBool( buttonRui, "isBindable", true )
		}
	}

	RegisterButtonData( BUTTON_A, "aText", false )
	RegisterButtonData( BUTTON_B, "bText", false )
	RegisterButtonData( BUTTON_X, "xText", false )
	RegisterButtonData( BUTTON_Y, "yText", false )
	RegisterButtonData( BUTTON_TRIGGER_LEFT, "lTriggerText", true )
	RegisterButtonData( BUTTON_TRIGGER_RIGHT, "rTriggerText", false )
	RegisterButtonData( BUTTON_SHOULDER_LEFT, "lShoulderText", true )
	RegisterButtonData( BUTTON_SHOULDER_RIGHT, "rShoulderText", false )
	RegisterButtonData( BUTTON_STICK_LEFT, "lStickText", true )
	RegisterButtonData( BUTTON_STICK_RIGHT, "rStickText", false )
	RegisterButtonData( BUTTON_DPAD_UP, "upText", true )
	RegisterButtonData( BUTTON_DPAD_DOWN, "downText", true )
	RegisterButtonData( BUTTON_DPAD_LEFT, "leftText", true )
	RegisterButtonData( BUTTON_DPAD_RIGHT, "rightText", true )
	RegisterButtonData( BUTTON_BACK, "backText", true )
	RegisterButtonData( BUTTON_START, "startText", false )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpenGamepadLayoutMenu )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnCloseGamepadLayoutMenu )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnNavigateBackMenu )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK", null, ShouldShowBackButton )
	//AddMenuFooterOption( menu, LEFT, BUTTON_BACK, true, "#BACKBUTTON_RESTORE_DEFAULTS", "#RESTORE_DEFAULTS", RestoreDefaultsButton ) //ShouldShowRestoreDefaultsButton
}


void function RegisterButtonData( int buttonEnum, string ruiArg, bool isLeft )
{
	ButtonData buttonData
	buttonData.buttonIndex = file.buttonData.len()
	buttonData.buttonEnum = buttonEnum
	buttonData.ruiArg = ruiArg
	buttonData.isLeft = isLeft

	file.buttonData.append( buttonData )
}


ButtonData function GetButtonDataForIndex( int index )
{
	return file.buttonData[index]
}


ButtonData function GetButtonDataForEnum( int buttonEnum )
{
	foreach ( buttonData in file.buttonData )
	{
		if ( buttonData.buttonEnum != buttonEnum )
			continue

		return buttonData
	}

	unreachable
}


void function SetInfoText( string headerText, string descText )
{
	RuiSetString( Hud_GetRui( file.description ), "headerText", headerText )
	RuiSetString( Hud_GetRui( file.description ), "description", descText )
}


void function OnPresetButton_Clicked( var button )
{
	int buttonID      = int( Hud_GetScriptID( button ) )
	string pilotBinds = PRESET_PILOT_BINDS[buttonID]

	SetConVarString( "gamepad_custom_pilot", pilotBinds )
	RefreshButtonBinds()

	EmitUISound( "menu_email_sent" )
	UpdatePresetButtons()
}


void function UpdatePresetButtons()
{
	string currentBinds = GetConVarString( "gamepad_custom_pilot" )

	for ( int idx = 0; idx < PRESETS_COUNT; ++idx )
	{
		string btnName = "BtnPreset" + format( "%d", idx )
		var button     = Hud_GetChild( file.menu, btnName )
		int buttonID   = int( Hud_GetScriptID( button ) )

		string presetBinds = PRESET_PILOT_BINDS[buttonID]

		Hud_SetSelected( button, currentBinds == presetBinds )
	}
}


void function OnPresetButton_FocusedOn( var button )
{
	int buttonID    = int( Hud_GetScriptID( button ) )
	string descText = PRESET_DESCRIPTIONS[buttonID]
	SetInfoText( PRESET_NAMES[buttonID], descText );

	RefreshButtonBinds( buttonID )
}


void function OnPresetButton_FocusedOff( var button )
{
	int buttonID = int( Hud_GetScriptID( button ) )
	SetInfoText( "", "" );

	RefreshButtonBinds()
}

//void function OnBackButton_FocusedOn( var button )
//{
//	SetInfoText( "" );
//}
//void function OnDefaultsButton_FocusedOn( var button )
//{
//	SetInfoText( "" );
//}

bool function AnyBindButtonHasFocus()
{
	if ( file.pilotBindFocusIndex >= 0 )
		return true
	//if ( file.titanBindFocusIndex >= 0 )
	//	return true

	return false
}


bool function ShouldShowBackButton()
{
	if ( IsControllerModeActive() && AnyBindButtonHasFocus() )
		return false

	return true
}


bool function ShouldShowRestoreDefaultsButton()
{
	if ( IsControllerModeActive() && AnyBindButtonHasFocus() )
		return true

	return false
}


void function OnOpenGamepadLayoutMenu()
{
	UpdateCustomButtonsVisibility( false )

	file.pilotBindFocusIndex = -1
	//file.titanBindFocusIndex = -1
	RegisterBindCallbacks()

	// Update bind text. Some can change if toggle or hold settings change.
	foreach ( idx, button in file.customBindButtonsPilot )
	{
		var buttonRui = Hud_GetRui( button )
		ButtonVars bv = GetBindDisplayName( GetBindString( CUSTOM_BIND_ALIASES_PILOT[idx] ) )
		RuiSetString( buttonRui, "commandLabelCommon", bv.common )
		RuiSetString( buttonRui, "commandLabelSpecific", bv.pilot )
	}

	RefreshButtonBinds()
	UpdatePresetButtons()

	SetInfoText( "", "" );
}


void function OnCloseGamepadLayoutMenu()
{
	DeregisterBindCallbacks()

	RefreshCustomGamepadBinds_UI()
}


void function OnNavigateBackMenu()
{
	bool customIsSet = CustomGamepadLayoutIsSet()
	if ( customIsSet && AnyBindButtonHasFocus() )
		return

	CloseActiveMenu()
}


bool function CustomGamepadLayoutIsSet()
{
	return true
}


void function UpdateCustomButtonsVisibility( bool isVisible )
{
	Hud_SetVisible( file.customBackgroundPilot, isVisible )
	foreach ( var button in file.customBindButtonsPilot )
		Hud_SetVisible( button, isVisible )
}


void function SetBindPromptForPilot( var button )
{
	int buttonID       = int( Hud_GetScriptID( button ) )
	ButtonVars bv      = GetBindDisplayName( GetBindString( CUSTOM_BIND_ALIASES_PILOT[buttonID] ) )
	string displayName = (bv.pilot == "") ? bv.common : bv.pilot
	//SetInfoText( Localize( "#GAMEPAD_BUTTON_ASSIGN_PROMPT_PILOT", Localize( displayName ) ) );
}


void function SetUnbindablePromptForPilot( var button )
{
	int buttonID       = int( Hud_GetScriptID( button ) )
	ButtonVars bv      = GetBindDisplayName( GetBindString( CUSTOM_BIND_ALIASES_PILOT[buttonID] ) )
	string displayName = (bv.pilot == "") ? bv.common : bv.pilot
	//SetInfoText( Localize( "#GAMEPAD_BUTTON_CANNOT_ASSIGN_PROMPT", Localize( displayName ) ) );
}


void function BindButtonPilot_FocusedOn( var button )
{
	int buttonID = int( Hud_GetScriptID( button ) )
	file.pilotBindFocusIndex = buttonID
	SetBindPromptForPilot( button )
}


void function BindButtonPilot_FocusedOff( var button )
{
	file.pilotBindFocusIndex = -1
}


void function UnbindableButtonPilot_FocusedOn( var button )
{
	int buttonID = int( Hud_GetScriptID( button ) )
	file.pilotBindFocusIndex = -1
	SetUnbindablePromptForPilot( button )
}


void function UnbindableButtonPilot_FocusedOff( var button )
{
	file.pilotBindFocusIndex = -1
}


ButtonVars function GetBindDisplayName( string bind )
{
	ButtonVars displayName

	if ( bind[0] == "+" )
		bind = bind.slice( 1, bind.len() )

	switch ( bind.tolower() )
	{
		case "zoom":
		case "toggle_zoom":
			displayName.common = GetConVarBool( "gamepad_toggle_ads" ) ? "#AIM_TOGGLE" : "#AIM_HOLD"
			displayName.pilot = ""
			displayName.titan = ""
			break

		case "attack":
			displayName.common = "#FIRE"
			displayName.pilot = ""
			displayName.titan = ""
			break

		case "jump":
			displayName.common = ""
			displayName.pilot = "#JUMP"
			displayName.titan = "#DASH"
			break

		case "dodge":
			displayName.common = ""
			displayName.pilot = "#DASH"
			displayName.titan = "#DASH"
			break

		case "ping":
			displayName.common = ""
			displayName.pilot = "#PING_AND_WHEEL"
			displayName.titan = "#PING_AND_WHEEL"
			break

		case "scriptcommand5":
			displayName.common = ""
			displayName.pilot = "#EXTRA_CHARACTER_ACTION"
			displayName.titan = ""
			break

		case "scriptcommand4":
			displayName.common = ""
			displayName.pilot = "#USE_HEALTH_KIT"        //"#ACTIVATE_BOOST"
			displayName.titan = ""
			break

		case "scriptcommand2":
			displayName.common = "#HEALTH_WHEEL"
			displayName.pilot = ""
			displayName.titan = ""
			break

		case "scriptcommand3":
			displayName.common = ""
			displayName.pilot = "#SWITCH_FIRE_MODE"
			displayName.titan = ""
			break

		case "scriptcommand1":
			displayName.common = ""
			displayName.pilot = "#QUICK_CHAT"
			displayName.titan = ""
			break

		case "scoreboard_focus":
			displayName.common = ""
			displayName.pilot = ""
			displayName.titan = ""
			break

		case "toggle_duck":
			displayName.common = GetConVarBool( "gamepad_togglecrouch_hold" ) ? "#CROUCH_HOLD" : "#CROUCH_TOGGLE"
			displayName.pilot = ""
			displayName.titan = ""
			break

		case "use_long":
			displayName.common = ""
			displayName.pilot = ""
			displayName.titan = ""
			break

		case "reload; use_long":
		case "reload":
			displayName.common = "#RELOAD"
			displayName.pilot = ""
			displayName.titan = ""
			break

		case "strafe":
			displayName.common = "#GRENADE_WHEEL"
			displayName.pilot = ""
			displayName.titan = ""
			break

		case "use_alt":
			displayName.common = ""
			displayName.pilot = ""
			displayName.titan = ""
			break

		case "reload; use":
		case "useandreload":
			displayName.common = "#USE_RELOAD"
			displayName.pilot = ""
			displayName.titan = ""
			break

		case "use":
		case "use; use_long":
		case "use_long; use":
			displayName.common = "#USE"
			displayName.pilot = ""
			displayName.titan = ""
			break

		case "weapon_inspect":
			displayName.common = "#INSPECT_WEAPON"
			displayName.pilot = ""
			displayName.titan = ""
			break

		case "weaponcycle":
		case "offhand2":
			displayName.common = ""
			displayName.pilot = "#SWITCH_WEAPONS_HOLSTER"
			displayName.titan = "#TITAN_UTILITY"
			break

		case "offhand0":
			displayName.common = ""
			displayName.pilot = "#ORDNANCE"
			displayName.titan = "#TITAN_ORDNANCE_ABILITY"
			break

		case "offhand1":
			displayName.common = ""
			displayName.pilot = "#TACTICAL_ABILITY"
			displayName.titan = "#TITAN_DEFENSE_ABILITY"
			break

		case "offhand3":
			displayName.common = ""
			displayName.pilot = "Team Comms"        // "#TITANFALL_TITAN_AI_MODE"
			displayName.titan = "Team Comms"        // "#TITAN_CORE_CONTROLS"
			break

		case "offhand4":
			displayName.common = ""
			displayName.pilot = "Ultimate Ability"
			displayName.titan = "#DISABLE_EJECT_SAFETY_TITAN"
			break

		case "showscores":
			displayName.common = "#SCOREBOARD"
			displayName.pilot = ""
			displayName.titan = ""
			break

		case "displayfullscreenmap":
			displayName.common = "#DISPLAY_FULLSCREEN_MINIMAP"
			displayName.pilot = ""
			displayName.titan = ""
			break

		case "ingamemenu_activate":
			displayName.common = "#LOADOUTS_SETTINGS"
			displayName.pilot = ""
			displayName.titan = ""
			break

		case "speed":
			displayName.common = "#SPRINT"
			displayName.pilot = ""
			displayName.titan = ""
			break

		case "melee":
			displayName.common = "#MELEE"
			displayName.pilot = ""
			displayName.titan = ""
			break

		case "weaponselectordnance":
			displayName.common = "#EQUIP_GRENADE"
			displayName.pilot = ""
			displayName.titan = ""
			break

		case "weaponselectprimary2":
			displayName.common = "#EQUIP_MELEE"
			displayName.pilot = ""
			displayName.titan = ""
			break

		case "toggle_inventory":
			displayName.common = "#INVENTORY"
			displayName.pilot = ""
			displayName.titan = ""
			break

		case "toggle_map":
			displayName.common = "#MAP"
			displayName.pilot = ""
			displayName.titan = ""
			break

		case "score":
			displayName.common = "#GIB_SHIELD_TOGGLE"
			displayName.pilot = ""
			displayName.titan = ""
			break

		case "ability 0":
		case "ability 1":
		case "ability 2":
		case "ability 3":
		case "ability 4":
		case "ability 5":
		case "ability 6":
		case "ability 7":
		case "ability 8":
		case "ability 9":
		case "ability 10":
		case "ability 11":
		case "ability 12":
		case "ability 13":
		case "ability 14":
		{
			int abilityIndex = int( bind.slice( 9 ) )
			int bindIndex    = (abilityIndex)

			string pilotBind
			{
				string baseBind   = GetCustomBindCommandForButtonIndexPilot( bindIndex )
				string bindString = GetBindString( baseBind )
				ButtonVars bv     = GetBindDisplayName( bindString )
				pilotBind = ((bv.pilot.len() > 0) ? bv.pilot : bv.common)
			}

			string titanBind
			{
				string baseBind   = GetCustomBindCommandForButtonIndexTitan( bindIndex )
				string bindString = GetBindString( baseBind )
				ButtonVars bv     = GetBindDisplayName( bindString )
				titanBind = ((bv.titan.len() > 0) ? bv.titan : bv.common)
			}

			if ( pilotBind == titanBind )
			{
				displayName.common = pilotBind
				displayName.pilot = ""
				displayName.titan = ""
			}
			else
			{
				displayName.common = ""
				displayName.pilot = pilotBind
				displayName.titan = titanBind
			}
		}
			break

		default:
			displayName.common = bind
			displayName.pilot = ""
			displayName.titan = ""
			break
	}

	return displayName
}


string function GetDisplayStringForBindCmd( string bindCmd )
{
	if ( bindCmd == "" )
		return ""

	ButtonVars tapBv = GetBindDisplayName( bindCmd )
	return ((tapBv.pilot.len() > 0) ? tapBv.pilot : tapBv.common)
}


void function RefreshButtonBinds( int presetIndex = -1 )
{
	for ( int idx = 0; idx < GAMEPAD_CUSTOM_BUTTONS_COUNT; ++idx )
	{
		var button    = file.customBindButtonsPilot[idx]
		var buttonRui = Hud_GetRui( button )

		int buttonIndex  = GetCustomButtonIndexForCommandIndexPilot( idx )
		string buttonStr = GetGamepadButtonStringForIndex( buttonIndex )
		bool isDefault   = (buttonIndex == idx)

		RuiSetString( buttonRui, "iconText", buttonStr )
		RuiSetBool( buttonRui, "isNonDefault", (!isDefault) )

		ButtonVars bv     = GetBindDisplayName( GetBindString( CUSTOM_BIND_ALIASES_PILOT[idx] ) )
		string bindString = ((bv.pilot.len() > 0) ? bv.pilot : bv.common)
		RuiSetArg( file.gamepadLayoutRui, GetButtonDataForIndex( idx ).ruiArg, bindString )
	}

	bool isPreview = presetIndex >= 0
	array<ABBind> bindArray
	if ( isPreview )
	{
		array<int> arr = BuildCommandForButtonArrayFromString( PRESET_PILOT_BINDS[presetIndex] )
		bindArray = BuildABBindSet( arr )
	}

	string tacticalBind, pingBind
	SetStandardAbilityBindingsForPilot( null )
	for ( int idx = 0; idx < GAMEPAD_CUSTOM_BUTTONS_COUNT; ++idx )
	{
		int buttonEnum  = GetButtonEnumForIndex( idx )
		int buttonIndex = isPreview ? GetButtonIndexForPreset( idx, presetIndex ) : GetCustomButtonIndexForCommandIndexPilot( idx )

		string buttonStr = GetGamepadButtonStringForIndex( idx )
		bool isDefault   = (buttonIndex == idx)

		ABBind abBind = isPreview ? bindArray[idx] : GetAbilityABind( idx )

		string tapBindString  = GetDisplayStringForBindCmd( abBind.tapBind )
		string holdBindString = GetDisplayStringForBindCmd( abBind.holdBind )

		bool isLeft = GetButtonDataForIndex( idx ).isLeft
		string bindString
		if ( tapBindString != "" && holdBindString != "" )
		{
			string bindLoc
			if ( isLeft )
				bindLoc = isDefault ? "#TAPHOLD_BIND_LEFT" : "#TAPHOLD_BIND_LEFT_MOD"
			else
				bindLoc = isDefault ? "#TAPHOLD_BIND_RIGHT" : "#TAPHOLD_BIND_RIGHT_MOD"

			bindString = Localize( bindLoc, buttonStr, Localize( tapBindString ), Localize( holdBindString ) )
		}
		else if ( tapBindString != "" )
		{
			string bindLoc
			if ( isLeft )
				bindLoc = isDefault ? "#TAP_BIND_LEFT" : "#TAP_BIND_LEFT_MOD"
			else
				bindLoc = isDefault ? "#TAP_BIND_RIGHT" : "#TAP_BIND_RIGHT_MOD"

			bindString = Localize( bindLoc, buttonStr, Localize( tapBindString ) )
		}
		else if ( holdBindString != "" )
		{
			string bindLoc
			if ( isLeft )
				bindLoc = isDefault ? "#HOLD_BIND_LEFT" : "#HOLD_BIND_LEFT_MOD"
			else
				bindLoc = isDefault ? "#HOLD_BIND_RIGHT" : "#HOLD_BIND_RIGHT_MOD"

			bindString = Localize( bindLoc, buttonStr, Localize( holdBindString ) )
		}
		else
		{
			bindString = ""
		}

		if( tapBindString == "#PING_AND_WHEEL" )
		{
			pingBind = buttonStr;
		}
		else if( tapBindString == "#TACTICAL_ABILITY" )
		{
			tacticalBind = buttonStr;
		}

		RuiSetArg( file.gamepadLayoutRui, GetButtonDataForIndex( idx ).ruiArg, bindString )
	}

	if ( IsGamepadPS4() )
		RuiSetImage( file.gamepadLayoutRui, "gamepadImage", $"rui/menu/controls_menu/ps4_gamepad_button_layout" )
	else
		RuiSetImage( file.gamepadLayoutRui, "gamepadImage", $"rui/menu/controls_menu/xboxone_gamepad_button_layout" )

	string startString = Localize( "#TAP_BIND_RIGHT", "%START%", Localize( "#INVENTORY" ) )
	RuiSetArg( file.gamepadLayoutRui, GetButtonDataForEnum( BUTTON_START ).ruiArg, startString )
	RuiSetArg( file.gamepadLayoutRui, "ultimateText", Localize( "#ULTIMATE_ABILITY" ) + "\n" + tacticalBind + "+" + pingBind )
	RuiSetBool( file.gamepadLayoutRui, "isPreview", isPreview )
}


void function RestoreDefaultsButton( var button )
{
	SetConVarToDefault( "gamepad_custom_pilot" )
	SetConVarToDefault( "gamepad_custom_titan" )
	RefreshButtonBinds()

	EmitUISound( "menu_advocategift_open" )
}


Assert( GAMEPAD_CUSTOM_BUTTONS_COUNT == 15 )
void function RegisterBindCallbacks()
{
	RegisterButtonPressedCallback( BUTTON_A, BindCatch_A )
	RegisterButtonPressedCallback( BUTTON_B, BindCatch_B )
	RegisterButtonPressedCallback( BUTTON_X, BindCatch_X )
	RegisterButtonPressedCallback( BUTTON_Y, BindCatch_Y )
	RegisterButtonPressedCallback( BUTTON_TRIGGER_LEFT, BindCatch_LT )
	RegisterButtonPressedCallback( BUTTON_TRIGGER_RIGHT, BindCatch_RT )
	RegisterButtonPressedCallback( BUTTON_SHOULDER_LEFT, BindCatch_LS )
	RegisterButtonPressedCallback( BUTTON_SHOULDER_RIGHT, BindCatch_RS )
	RegisterButtonPressedCallback( BUTTON_STICK_LEFT, BindCatch_LA )
	RegisterButtonPressedCallback( BUTTON_STICK_RIGHT, BindCatch_RA )
	RegisterButtonPressedCallback( BUTTON_DPAD_UP, BindCatch_DPAD_UP )
	RegisterButtonPressedCallback( BUTTON_DPAD_DOWN, BindCatch_DPAD_DOWN )
	RegisterButtonPressedCallback( BUTTON_DPAD_LEFT, BindCatch_DPAD_LEFT )
	RegisterButtonPressedCallback( BUTTON_DPAD_RIGHT, BindCatch_DPAD_RIGHT )
	RegisterButtonPressedCallback( BUTTON_BACK, BindCatch_BACK )
}


void function DeregisterBindCallbacks()
{
	DeregisterButtonPressedCallback( BUTTON_A, BindCatch_A )
	DeregisterButtonPressedCallback( BUTTON_B, BindCatch_B )
	DeregisterButtonPressedCallback( BUTTON_X, BindCatch_X )
	DeregisterButtonPressedCallback( BUTTON_Y, BindCatch_Y )
	DeregisterButtonPressedCallback( BUTTON_TRIGGER_LEFT, BindCatch_LT )
	DeregisterButtonPressedCallback( BUTTON_TRIGGER_RIGHT, BindCatch_RT )
	DeregisterButtonPressedCallback( BUTTON_SHOULDER_LEFT, BindCatch_LS )
	DeregisterButtonPressedCallback( BUTTON_SHOULDER_RIGHT, BindCatch_RS )
	DeregisterButtonPressedCallback( BUTTON_STICK_LEFT, BindCatch_LA )
	DeregisterButtonPressedCallback( BUTTON_STICK_RIGHT, BindCatch_RA )
	DeregisterButtonPressedCallback( BUTTON_DPAD_UP, BindCatch_DPAD_UP )
	DeregisterButtonPressedCallback( BUTTON_DPAD_DOWN, BindCatch_DPAD_DOWN )
	DeregisterButtonPressedCallback( BUTTON_DPAD_LEFT, BindCatch_DPAD_LEFT )
	DeregisterButtonPressedCallback( BUTTON_DPAD_RIGHT, BindCatch_DPAD_RIGHT )
	DeregisterButtonPressedCallback( BUTTON_BACK, BindCatch_BACK )
}


void function BindCatchCommon( int buttonEnum )
{
	if ( file.pilotBindFocusIndex >= 0 )
	{
		int buttonIndex  = GetButtonIndexForButtonEnum( buttonEnum )
		bool didAnything = ChangeCustomGamepadButtonIndexToCommandIndex_Pilot( buttonIndex, file.pilotBindFocusIndex )
		if ( didAnything )
		{
			RefreshButtonBinds()
			if ( buttonEnum != BUTTON_A )
				EmitUISound( "menu_accept" )
		}

		return
	}

	//if ( file.titanBindFocusIndex >= 0 )
	//{
	//	int buttonIndex = GetButtonIndexForButtonEnum( buttonEnum )
	//	bool didAnything = ChangeCustomGamepadButtonIndexToCommandIndex_Titan( buttonIndex, file.titanBindFocusIndex )
	//	if ( didAnything )
	//	{
	//		RefreshButtonBinds()
	//		if ( buttonEnum != BUTTON_A )
	//			EmitUISound( "menu_accept" )
	//	}
	//
	//	return
	//}
}


void function BindCatch_A( var button )
{
	BindCatchCommon( BUTTON_A )
}


void function BindCatch_B( var button )
{
	BindCatchCommon( BUTTON_B )
}


void function BindCatch_X( var button )
{
	BindCatchCommon( BUTTON_X )
}


void function BindCatch_Y( var button )
{
	BindCatchCommon( BUTTON_Y )
}


void function BindCatch_LT( var button )
{
	BindCatchCommon( BUTTON_TRIGGER_LEFT )
}


void function BindCatch_RT( var button )
{
	BindCatchCommon( BUTTON_TRIGGER_RIGHT )
}


void function BindCatch_LS( var button )
{
	BindCatchCommon( BUTTON_SHOULDER_LEFT )
}


void function BindCatch_RS( var button )
{
	BindCatchCommon( BUTTON_SHOULDER_RIGHT )
}


void function BindCatch_LA( var button )
{
	BindCatchCommon( BUTTON_STICK_LEFT )
}


void function BindCatch_RA( var button )
{
	BindCatchCommon( BUTTON_STICK_RIGHT )
}


void function BindCatch_DPAD_UP( var button )
{
	BindCatchCommon( BUTTON_DPAD_UP )
}


void function BindCatch_DPAD_DOWN( var button )
{
	BindCatchCommon( BUTTON_DPAD_DOWN )
}


void function BindCatch_DPAD_LEFT( var button )
{
	BindCatchCommon( BUTTON_DPAD_LEFT )
}


void function BindCatch_DPAD_RIGHT( var button )
{
	BindCatchCommon( BUTTON_DPAD_RIGHT )
}


void function BindCatch_BACK( var button )
{
	BindCatchCommon( BUTTON_BACK )
}


string function GetBindString( string baseBind )
{
	switch ( baseBind )
	{
		case "weaponselectordnance":
		case "toggle_inventory":
		case "toggle_map":
			return baseBind
	}

	return "+" + baseBind
}