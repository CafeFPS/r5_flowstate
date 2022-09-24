global function InitFRChallengesMainMenu
global function OpenFRChallengesMainMenu
global function CloseFRChallengesMainMenu
global function SetAimTrainerSessionEnabled

struct
{
	var menu
} file

global string PlayerKillsForChallengesUI = ""
global string PlayerCurrentWeapon = ""
global bool ISAIMTRAINER = false //check if its in aim trainer main menu to change behavior of global settings menu.

void function OpenFRChallengesMainMenu(int dummiesKilled)
{
	CloseAllMenus()
	ISAIMTRAINER = true
	PlayerKillsForChallengesUI = dummiesKilled.tostring()
	Hud_SetText(Hud_GetChild( file.menu, "DummiesKilledCounter"), "Dummies killed this session: " + dummiesKilled.tostring())
	if(PlayerCurrentWeapon == "") 
		Hud_SetText(Hud_GetChild( file.menu, "CurrentWeapon"), "Current weapon: Wingman")
	else
		Hud_SetText(Hud_GetChild( file.menu, "CurrentWeapon"), "Current weapon: " + PlayerCurrentWeapon)
	EmitUISound("UI_Menu_SelectMode_Extend")
	AdvanceMenu( file.menu )
}

void function SetAimTrainerSessionEnabled(bool activated)
{
	if(!activated) ISAIMTRAINER = true
	else ISAIMTRAINER = false
}

void function CloseFRChallengesMainMenu()
{
	ISAIMTRAINER = false
	CloseAllMenus()
}

void function InitFRChallengesMainMenu( var newMenuArg )
{
	var menu = GetMenu( "FRChallengesMainMenu" )
	file.menu = menu
    AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, OnR5RSB_Show )
	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnR5RSB_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnR5RSB_Close )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnR5RSB_NavigateBack )
	
	AddEventHandlerToButton( menu, "History", UIE_CLICK, HistoryButtonFunct )
	AddEventHandlerToButton( menu, "Settings", UIE_CLICK, SettingsButtonFunct )
	//var Challenge1 = Hud_GetChild( menu, "Challenge1" )
	//First column
	AddEventHandlerToButton( menu, "Challenge1", UIE_CLICK, Challenge1Funct )
	AddEventHandlerToButton( menu, "Challenge2", UIE_CLICK, Challenge2Funct )
	AddEventHandlerToButton( menu, "Challenge3", UIE_CLICK, Challenge3Funct )
	AddEventHandlerToButton( menu, "Challenge4", UIE_CLICK, Challenge4Funct )
	AddEventHandlerToButton( menu, "Challenge5", UIE_CLICK, Challenge5Funct )
	AddEventHandlerToButton( menu, "Challenge6", UIE_CLICK, Challenge6Funct )
	AddEventHandlerToButton( menu, "Challenge7", UIE_CLICK, Challenge7Funct )
	//AddEventHandlerToButton( menu, "Challenge8", UIE_CLICK, Challenge8Funct )
	//Second column
	AddEventHandlerToButton( menu, "Challenge1NewC", UIE_CLICK, Challenge1NewCFunct )
	AddEventHandlerToButton( menu, "Challenge2NewC", UIE_CLICK, Challenge2NewCFunct )
	AddEventHandlerToButton( menu, "Challenge3NewC", UIE_CLICK, Challenge3NewCFunct )
	AddEventHandlerToButton( menu, "Challenge4NewC", UIE_CLICK, Challenge4NewCFunct )
	AddEventHandlerToButton( menu, "Challenge5NewC", UIE_CLICK, Challenge5NewCFunct )
	AddEventHandlerToButton( menu, "Challenge6NewC", UIE_CLICK, Challenge6NewCFunct )
	AddEventHandlerToButton( menu, "Challenge7NewC", UIE_CLICK, Challenge7NewCFunct )
	//AddEventHandlerToButton( menu, "Challenge8NewC", UIE_CLICK, Challenge8NewCFunct )
	
	var gameMenuButton = Hud_GetChild( menu, "GameMenuButton" )
	ToolTipData gameMenuToolTip
	gameMenuToolTip.descText = "Global Settings"
	Hud_SetToolTipData( gameMenuButton, gameMenuToolTip )
	HudElem_SetRuiArg( gameMenuButton, "icon", $"rui/menu/lobby/settings_icon" )
	HudElem_SetRuiArg( gameMenuButton, "shortcutText", "Global Settings" )
	Hud_AddEventHandler( gameMenuButton, UIE_CLICK, OpenGlobalSettings )

	if(IsConnected() && GetCurrentPlaylistVarBool( "firingrange_aimtrainerbycolombia", false ))
		RunClientScript("RefreshChallengeActivated")
}

bool function ShouldShowBackButton()
{
	return true
}

void function HistoryButtonFunct(var button)
{
	CloseAllMenus()
	RunClientScript("ServerCallback_OpenFRChallengesHistory", PlayerKillsForChallengesUI)
}

void function SettingsButtonFunct(var button)
{
	CloseAllMenus()
	EmitUISound("UI_Menu_SelectMode_Close")
	RunClientScript("ServerCallback_OpenFRChallengesSettings")
}

void function Challenge1Funct(var button)
{
	CloseAllMenus()
	EmitUISound("UI_Menu_SelectMode_Close")
	RunClientScript("StartChallenge1Client")
}

void function Challenge2Funct(var button)
{
	CloseAllMenus()
	EmitUISound("UI_Menu_SelectMode_Close")
	RunClientScript("StartChallenge2Client")
}

void function Challenge3Funct(var button)
{
	CloseAllMenus()
	EmitUISound("UI_Menu_SelectMode_Close")
	RunClientScript("StartChallenge3Client")
}

void function Challenge4Funct(var button)
{
	CloseAllMenus()
	EmitUISound("UI_Menu_SelectMode_Close")
	RunClientScript("StartChallenge4Client")
}

void function Challenge5Funct(var button)
{
	CloseAllMenus()
	EmitUISound("UI_Menu_SelectMode_Close")
	RunClientScript("StartChallenge5Client")
}
void function Challenge6Funct(var button)
{
	CloseAllMenus()
	EmitUISound("UI_Menu_SelectMode_Close")
	RunClientScript("StartChallenge6Client")
}
void function Challenge7Funct(var button)
{
	CloseAllMenus()
	EmitUISound("UI_Menu_SelectMode_Close")
	RunClientScript("StartChallenge7Client")
}
void function Challenge8Funct(var button)
{
	CloseAllMenus()
	EmitUISound("UI_Menu_SelectMode_Close")
	RunClientScript("StartChallenge8Client")
}
void function Challenge1NewCFunct(var button)
{
	CloseAllMenus()
	EmitUISound("UI_Menu_SelectMode_Close")
	RunClientScript("StartChallenge1NewCClient")
}

void function Challenge2NewCFunct(var button)
{
	CloseAllMenus()
	EmitUISound("UI_Menu_SelectMode_Close")
	RunClientScript("StartChallenge2NewCClient")
}

void function Challenge3NewCFunct(var button)
{
	CloseAllMenus()
	EmitUISound("UI_Menu_SelectMode_Close")
	RunClientScript("StartChallenge3NewCClient")
}

void function Challenge4NewCFunct(var button)
{
	CloseAllMenus()
	EmitUISound("UI_Menu_SelectMode_Close")
	RunClientScript("StartChallenge4NewCClient")
}

void function Challenge5NewCFunct(var button)
{
	CloseAllMenus()
	EmitUISound("UI_Menu_SelectMode_Close")
	RunClientScript("StartChallenge5NewCClient")
}

void function Challenge6NewCFunct(var button)
{
	CloseAllMenus()
	EmitUISound("UI_Menu_SelectMode_Close")
	RunClientScript("StartChallenge6NewCClient")
}

void function Challenge7NewCFunct(var button)
{
	CloseAllMenus()
	EmitUISound("UI_Menu_SelectMode_Close")
	RunClientScript("StartChallenge7NewCClient")
}

void function Challenge8NewCFunct(var button)
{
	CloseAllMenus()
	EmitUISound("UI_Menu_SelectMode_Close")
	RunClientScript("StartChallenge8NewCClient")
}
void function OnR5RSB_Show()
{
    //
}

void function OnR5RSB_Open()
{
	//
}


void function OnR5RSB_Close()
{
	//
}

void function OnR5RSB_NavigateBack()
{
    CloseAllMenus()
	AdvanceMenu( GetMenu( "SystemMenu" ) )	
}

void function OpenGlobalSettings(var button)
{
    CloseAllMenus()
	AdvanceMenu( GetMenu( "SystemMenu" ) )	
}
