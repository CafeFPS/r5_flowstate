global function InitChallengesHistory
global function OpenFRChallengesHistory
global function CloseFRChallengesHistory

struct
{
	var menu
	bool wpnselectorToggle = false
} file

void function OpenFRChallengesHistory(int dummiesKilled)
{
	//use dummies killed
	CloseAllMenus()
	EmitUISound("UI_Menu_SelectMode_Extend")
	AdvanceMenu( file.menu )	
}

void function CloseFRChallengesHistory()
{
	CloseAllMenus()
}

void function InitChallengesHistory( var newMenuArg )
{
	var menu = GetMenu( "FRChallengesHistory" )
	file.menu = menu
	
    AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, OnR5RSB_Show )
	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnR5RSB_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnR5RSB_Close )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnR5RSB_NavigateBack )
	
	AddEventHandlerToButton( menu, "Challenges", UIE_CLICK, ChallengesButtonFunct )
	AddEventHandlerToButton( menu, "Settings", UIE_CLICK, SettingsButtonFunct )
	
	array<var> serverbuttons = GetElementsByClassname( file.menu, "ServBtn" )
	foreach ( var elem in serverbuttons ) {
		RuiSetString( Hud_GetRui( elem ), "buttonText", "")
		// Hud_AddEventHandler( elem, UIE_CLICK, SelectServer )
	}
}

void function ChallengesButtonFunct(var button)
{
	CloseAllMenus()
	RunClientScript("ServerCallback_OpenFRChallengesMainMenu", PlayerKillsForChallengesUI)
}

void function SettingsButtonFunct(var button)
{
	CloseAllMenus()
	EmitUISound("UI_Menu_SelectMode_Close")
	RunClientScript("ServerCallback_OpenFRChallengesSettings")
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
	RunClientScript("ServerCallback_OpenFRChallengesMainMenu", PlayerKillsForChallengesUI)	
}