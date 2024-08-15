
global function InitScenariosMenu

global function UI_OpenScenariosStandingsMenu
global function UI_CloseScenariosStandingsMenu
global function UI_UpdateScenariosRecapMenu

struct 
{
	var menu
	var footersPanel

} file


void function InitScenariosMenu( var menu )
{	
	file.menu = menu
	
	SetMenuReceivesCommands( menu, false )
	SetGamepadCursorEnabled( menu, false )
	
	file.footersPanel = Hud_GetChild( menu, "FooterButtons" )
	
	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CLOSE", "#CLOSE", null )
	
	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, ScenariosStandingsMenuOnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, ScenariosStandingsMenuOnClose )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, ScenariosStandingsMenuOnNavBack )
}

void function UI_OpenScenariosStandingsMenu()
{
	CloseAllMenus()
	AdvanceMenu( file.menu )
}

void function UI_CloseScenariosStandingsMenu()
{
	CloseAllMenus()
}

void function ScenariosStandingsMenuOnOpen()
{
	
}

void function ScenariosStandingsMenuOnClose()
{

}

void function ScenariosStandingsMenuOnNavBack()
{
	CloseAllMenus()
}

void function UI_UpdateScenariosRecapMenu()
{
	
}

/*

struct ClientRecapStruct
{
	int value 
	int count
}

RegisterSignal( "ScenariosRecapReady" )

if( IsValid( player ) )
			player.Signal( "ScenariosRecapUpdated" )
*/