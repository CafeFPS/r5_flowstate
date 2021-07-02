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
	bool listeningForButtonBind

	var gamepadLayoutRui
	var ultimateBindButtonPilot
	var warnMessage
	var description
} file


void function MenuGamepadLayout_Init()
{
	AddUICallback_InputModeChanged( OnInputModeChanged )
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

const int GAMEPAD_CUSTOM_LAYOUT_INDEX = 6

int function GetButtonIndexForPreset( int buttonIndex, int presetIndex )
{
	array<int> arr = BuildCommandForButtonArrayFromString( PRESET_PILOT_BINDS[presetIndex] )
	return arr[buttonIndex]
}


void function InitGamepadLayoutMenu( var newMenuArg ) //
{
	var menu = GetMenu( "GamepadLayoutMenu" )
	file.menu = menu

	file.gamepadButtonLayoutBG = Hud_GetChild( file.menu, "GamepadButtonLayoutBGRui" )
	file.gamepadLayoutRui = Hud_GetRui( file.gamepadButtonLayoutBG )

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

		HudElem_SetRuiArg( button, "hideBlur", true )
		SetButtonRuiText( button, PRESET_NAMES[idx] )
	}

	////
	file.description = Hud_GetChild( menu, "lblControllerDescription" )

	////
	var customBtn = Hud_GetChild( menu, "BtnCustomizeLayout" )
	SetButtonRuiText( customBtn, "#GAMEPAD_CUSTOM" )
	HudElem_SetRuiArg( customBtn, "hideBlur", true )
	
	AddButtonEventHandler( customBtn, UIE_CLICK, OnCustomButton_Clicked )
	AddButtonEventHandler( customBtn, UIE_GET_FOCUS, OnPresetButton_FocusedOn )
	AddButtonEventHandler( customBtn, UIE_LOSE_FOCUS, OnPresetButton_FocusedOff )

	file.customBackgroundPilot = Hud_GetChild( menu, "PilotControlsBG" )
	for ( int idx = 0; idx < GAMEPAD_CUSTOM_BUTTONS_COUNT; ++idx )
	{
		string btnName = "BtnPilotBind" + format( "%02d", idx )
		var bindButton = Hud_GetChild( menu, btnName )
		file.customBindButtonsPilot.append( bindButton )

		var buttonRui = Hud_GetRui( bindButton )
		RuiSetBool( buttonRui, "alignedRight", false )

		ButtonVars bv = GetBindDisplayName( CUSTOM_BIND_ALIASES_PILOT[idx] )
		RuiSetString( buttonRui, "commandLabelCommon", bv.common )
		RuiSetString( buttonRui, "commandLabelSpecific", bv.pilot )

		Hud_SetVisible( bindButton, false )

		if ( idx >= GAMEPAD_CUSTOM_BUTTONS_COUNT )
		{
			RuiSetBool( buttonRui, "isBindable", false )
			AddButtonEventHandler( bindButton, UIE_GET_FOCUS, UnbindableButtonPilot_FocusedOn )
			AddButtonEventHandler( bindButton, UIE_LOSE_FOCUS, UnbindableButtonPilot_FocusedOff )
		}
		else
		{
			AddButtonEventHandler( bindButton, UIE_CLICK, BindButtonPilot_Clicked )
			AddButtonEventHandler( bindButton, UIE_GET_FOCUS, BindButtonPilot_FocusedOn )
			AddButtonEventHandler( bindButton, UIE_LOSE_FOCUS, BindButtonPilot_FocusedOff )
			RuiSetBool( buttonRui, "isBindable", true )
		}
	}
	file.ultimateBindButtonPilot = Hud_GetChild( menu, "BtnPilotBindUltimate" )
	var ultButtonRui = Hud_GetRui( file.ultimateBindButtonPilot )
	RuiSetString( ultButtonRui, "commandLabelCommon", "#ULTIMATE_ABILITY" )
	RuiSetBool( ultButtonRui, "isBindable", false )

	file.warnMessage = Hud_GetChild( file.menu, "GamepadLayoutWarningMessage" )
	SetCustomGamepadLayoutVisible( IsCustomGamepadLayoutSelected() )

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
	AddMenuFooterOption( menu, LEFT, BUTTON_BACK, true, "#BACKBUTTON_RESTORE_DEFAULTS", "#RESTORE_DEFAULTS", RestoreDefaultsButton )
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

void function OnInputModeChanged( bool controllerModeActive )
{
	if( controllerModeActive )
		return

	if( file.listeningForButtonBind && file.pilotBindFocusIndex >= 0 )
	{
		file.listeningForButtonBind = false
		SetMenuNavigationDisabled( false )

		var buttonRui = Hud_GetRui( file.customBindButtonsPilot[file.pilotBindFocusIndex] )
		RuiSetBool( buttonRui, "isListeningForBind", false )
		RefreshButtonBinds()
	}
}

void function OnPresetButton_Clicked( var button )
{
	SetCustomGamepadLayoutVisible( false )

	int buttonID = int( Hud_GetScriptID( button ) )
	SetConVarInt( "gamepad_button_layout", buttonID  )
	RefreshButtonBinds()

	EmitUISound( "menu_email_sent" )
	UpdatePresetButtons()
}

void function UpdatePresetButtons()
{
	int layoutIdx = GetConVarInt( "gamepad_button_layout" )

	for ( int idx = 0; idx < PRESETS_COUNT; ++idx )
	{
		string btnName = "BtnPreset" + format( "%d", idx )
		var button     = Hud_GetChild( file.menu, btnName )
		int buttonID   = int( Hud_GetScriptID( button ) )
		HudElem_SetRuiArg( button, "isEquipped", layoutIdx == buttonID )
	}

	var btnCustom = Hud_GetChild( file.menu, "BtnCustomizeLayout" )
	HudElem_SetRuiArg( btnCustom, "isEquipped", layoutIdx == GAMEPAD_CUSTOM_LAYOUT_INDEX )
}


void function OnPresetButton_FocusedOn( var button )
{
	int buttonID = int( Hud_GetScriptID( button ) )

	SetCustomGamepadLayoutVisible( buttonID == GAMEPAD_CUSTOM_LAYOUT_INDEX )

	if( buttonID < PRESETS_COUNT )
		RefreshButtonBinds( buttonID )
	else
		RefreshButtonBinds()

	UpdateInfoText( buttonID )
}


void function OnPresetButton_FocusedOff( var button )
{
	SetCustomGamepadLayoutVisible( IsCustomGamepadLayoutSelected() )
	RefreshButtonBinds()
	UpdateInfoText( GetConVarInt( "gamepad_button_layout" ) )
}

void function OnCustomButton_Clicked( var button )
{
	SetCustomGamepadLayoutVisible( true )

	int buttonID = int( Hud_GetScriptID( button ) )
	SetConVarInt( "gamepad_button_layout", buttonID  )
	RefreshButtonBinds()

	EmitUISound( "menu_email_sent" )
	UpdatePresetButtons()
}

void function UpdateInfoText( int layoutIdx )
{
	if( layoutIdx < PRESETS_COUNT )
	{
		string descText = PRESET_DESCRIPTIONS[layoutIdx]
		SetInfoText( PRESET_NAMES[layoutIdx], descText );
	}
	else
	{
		SetInfoText( "#GAMEPAD_CUSTOM", "#GAMEPAD_CUSTOM_DESC" );
	}
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
	file.listeningForButtonBind = false
	file.pilotBindFocusIndex = -1
	//file.titanBindFocusIndex = -1
	RegisterBindCallbacks()

	// Update bind text. Some can change if toggle or hold settings change.
	foreach ( idx, button in file.customBindButtonsPilot )
	{
		var buttonRui = Hud_GetRui( button )
		ButtonVars bv = GetBindDisplayName( CUSTOM_BIND_ALIASES_PILOT[idx] )
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

	//
	SetMenuNavigationDisabled( false )
}


void function OnNavigateBackMenu()
{
	if( file.listeningForButtonBind )
		return

	if ( IsCustomGamepadLayoutSelected() && AnyBindButtonHasFocus() )
	{
		var btnCustom = Hud_GetChild( file.menu, "BtnCustomizeLayout" )
		Hud_SetFocused( btnCustom )
		return
	}

	CloseActiveMenu()
}


bool function IsCustomGamepadLayoutSelected()
{
	int layoutIdx = GetConVarInt( "gamepad_button_layout" )
	return layoutIdx == GAMEPAD_CUSTOM_LAYOUT_INDEX
}


void function SetCustomGamepadLayoutVisible( bool isVisible )
{
	Hud_SetVisible( file.customBackgroundPilot, isVisible )
	Hud_SetVisible( file.ultimateBindButtonPilot, isVisible )
	Hud_SetVisible( file.warnMessage, isVisible )
	Hud_SetVisible( file.gamepadButtonLayoutBG, !isVisible )

	foreach ( var button in file.customBindButtonsPilot )
		Hud_SetVisible( button, isVisible )
}


void function SetBindPromptForPilot( var button )
{
	int buttonID       = int( Hud_GetScriptID( button ) )
	ButtonVars bv      = GetBindDisplayName( CUSTOM_BIND_ALIASES_PILOT[buttonID] )
	string displayName = (bv.pilot == "") ? bv.common : bv.pilot
	//SetInfoText( Localize( "#GAMEPAD_BUTTON_ASSIGN_PROMPT_PILOT", Localize( displayName ) ) );
}


void function SetUnbindablePromptForPilot( var button )
{
	int buttonID       = int( Hud_GetScriptID( button ) )
	ButtonVars bv      = GetBindDisplayName( CUSTOM_BIND_ALIASES_PILOT[buttonID] )
	string displayName = (bv.pilot == "") ? bv.common : bv.pilot
	//SetInfoText( Localize( "#GAMEPAD_BUTTON_CANNOT_ASSIGN_PROMPT", Localize( displayName ) ) );
}

void function BindButtonPilot_Clicked( var button )
{
	SetBindPromptForPilot( button )
}

void function BindButtonPilot_FocusedOn( var button )
{
	int buttonID = int( Hud_GetScriptID( button ) )
	file.pilotBindFocusIndex = buttonID
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

		case "chat_wheel":
			displayName.common = ""
			displayName.pilot = "#CHAT_WHEEL"
			displayName.titan = ""
			break

		case "scriptcommand5":
		case "scriptcommand5; chat_wheel":
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
	bool isCustomLayout = IsCustomGamepadLayoutSelected();
	for ( int idx = 0; idx < GAMEPAD_CUSTOM_BUTTONS_COUNT; ++idx )
	{
		var button    = file.customBindButtonsPilot[idx]
		var buttonRui = Hud_GetRui( button )

		int buttonIndex  = GetCustomButtonIndexForCommandIndexPilot( idx )
		string buttonStr = GetGamepadButtonStringForIndex( buttonIndex )
		bool isDefault   = (buttonIndex == idx)

		RuiSetString( buttonRui, "iconText", buttonStr )
		RuiSetBool( buttonRui, "isNonDefault", (!isDefault) )
		RuiSetBool( buttonRui, "isListeningForBind", false )

		ButtonVars bv     = GetBindDisplayName( CUSTOM_BIND_ALIASES_PILOT[idx] )
		string bindString = ((bv.pilot.len() > 0) ? bv.pilot : bv.common)
		RuiSetArg( file.gamepadLayoutRui, GetButtonDataForIndex( idx ).ruiArg, bindString )
	}

	bool isPreview = presetIndex >= 0
	array<ABBind> bindArray
	if ( isPreview || !isCustomLayout )
	{
		if( presetIndex < 0 )
			presetIndex = GetConVarInt( "gamepad_button_layout" )
		array<int> arr = BuildCommandForButtonArrayFromString( PRESET_PILOT_BINDS[presetIndex] )
		bindArray = BuildABBindSet( arr )
	}

	string tacticalBind, pingBind
	SetStandardAbilityBindingsForPilot( null )
	for ( int idx = 0; idx < GAMEPAD_CUSTOM_BUTTONS_COUNT; ++idx )
	{
		int buttonEnum  = GetButtonEnumForIndex( idx )
		int buttonIndex = isPreview || !isCustomLayout ? GetButtonIndexForPreset( idx, presetIndex ) : GetCustomButtonIndexForCommandIndexPilot( idx )

		string buttonStr = GetGamepadButtonStringForIndex( idx )
		bool isDefault   = (buttonIndex == idx)

		ABBind abBind = isPreview || !isCustomLayout ? bindArray[idx] : GetAbilityABind( idx )

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

	RuiSetString( Hud_GetRui( file.ultimateBindButtonPilot ), "iconText", tacticalBind + "+" + pingBind )
}


void function RestoreDefaultsButton( var button )
{
	if( file.listeningForButtonBind )
		return

	SetConVarToDefault( "gamepad_custom_pilot" )
	SetConVarToDefault( "gamepad_button_layout" )

	Hud_SetFocused( Hud_GetChild( file.menu, "BtnPreset0" ) )
	SetCustomGamepadLayoutVisible( false )
	UpdatePresetButtons()
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
	if ( file.listeningForButtonBind && file.pilotBindFocusIndex >= 0 )
	{
		file.listeningForButtonBind = false
		SetMenuNavigationDisabled( false )

		var bindButton = file.customBindButtonsPilot[file.pilotBindFocusIndex]
		var buttonRui = Hud_GetRui( bindButton )
		RuiSetBool( buttonRui, "isListeningForBind", false )

		if( !IsBindingAllowed( buttonEnum ) )
		{
			EmitUISound( "menu_deny" )
			return
		}

		int buttonIndex = GetButtonIndexForButtonEnum( buttonEnum )
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

const table<string, string> GAMEPAD_BIND_CONFLICTS =
{
	["offhand1"] 	= "ping",
	["ping"]		= "offhand1",
	["zoom"] 		= "attack,speed",
	["attack"] 		= "zoom",
	["speed"] 		= "zoom",
}

enum eBindMessageType
{
	WARNING,
	INFO,
}

bool function IsButtonDpad( int buttonIndex )
{
	return buttonIndex >= BUTTON_DPAD_UP && buttonIndex <= BUTTON_DPAD_LEFT
}

bool function IsBindingAllowed( int buttonEnum )
{
	array<string> dpadBindCommands
	string bindWarningMessage = ""

	int buttonIdx = GetCustomButtonIndexForCommandIndexPilot( file.pilotBindFocusIndex )
	string currentBindCommandFocused = GetCustomBindCommandForButtonIndexPilot( buttonIdx )

	if ( currentBindCommandFocused == "ping" )
	{
		if( buttonEnum == BUTTON_B )
		{
			bindWarningMessage = Localize( "#SETTING_BIND_GAMEPAD_WARN_CANT_BIND", Localize( GetDisplayStringForBindCmd( currentBindCommandFocused ) ), Localize( "%B_BUTTON%" ) )
			SetWarnMessage( bindWarningMessage, eBindMessageType.WARNING )
			return false
		}
		else if ( buttonEnum != BUTTON_SHOULDER_RIGHT )
		{
			bindWarningMessage = Localize( "#SETTING_BIND_GAMEPAD_INVENTORY_PING" )
			SetWarnMessage( bindWarningMessage, eBindMessageType.INFO )
		}
	}

	if( !IsButtonDpad( buttonEnum ) )
		return true

	for( int dpadEnum = BUTTON_DPAD_UP; dpadEnum <= BUTTON_DPAD_LEFT; dpadEnum++  )
	{
		if( dpadEnum == buttonEnum )
		{
			buttonIdx = GetCustomButtonIndexForCommandIndexPilot( file.pilotBindFocusIndex )
			currentBindCommandFocused = GetCustomBindCommandForButtonIndexPilot( buttonIdx )
			dpadBindCommands.append( currentBindCommandFocused )
		}
		else
		{
			dpadBindCommands.append( GetCustomBindCommandForButtonIndexPilot( GAMEPAD_BUTTON_INDECES[dpadEnum] ) )
		}
	}

	if( currentBindCommandFocused in GAMEPAD_BIND_CONFLICTS )
	{
		string csvStr = GAMEPAD_BIND_CONFLICTS[currentBindCommandFocused]
		array<string> conflictingBindCommands = split( csvStr, "," )

		foreach( command in dpadBindCommands )
		{
			if( conflictingBindCommands.find( command ) >= 0 )
			{
				bindWarningMessage = Localize( "#SETTING_BIND_GAMEPAD_WARN_TWO_BINDS", Localize( GetDisplayStringForBindCmd( currentBindCommandFocused ) ), Localize( GetDisplayStringForBindCmd( command ) ) )
				SetWarnMessage( bindWarningMessage, eBindMessageType.WARNING )
				return false
			}
		}
	}
	return true
}

void function SetWarnMessage( string bindWarningMessage, int messageType )
{
	RuiSetString( Hud_GetRui( file.warnMessage ), "bindWarningMessage", bindWarningMessage )
	RuiSetInt( Hud_GetRui( file.warnMessage ), "bindIdx", file.pilotBindFocusIndex )
	RuiSetInt( Hud_GetRui( file.warnMessage ), "bindMessageType", messageType )
}

void function BindCatch_A( var button )
{
	if( !file.listeningForButtonBind && file.pilotBindFocusIndex >= 0 )
	{
		file.listeningForButtonBind = true
		SetMenuNavigationDisabled( true )

		var buttonRui = Hud_GetRui( file.customBindButtonsPilot[file.pilotBindFocusIndex] )
		RuiSetBool( buttonRui, "isListeningForBind", true )
		RuiSetInt( Hud_GetRui( file.warnMessage ), "bindIdx", -1 )
	}
	else
	{
		BindCatchCommon( BUTTON_A )
	}

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