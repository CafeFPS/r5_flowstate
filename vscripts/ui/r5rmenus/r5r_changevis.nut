global function InitR5RVisibilityMenu

struct
{
	var menu

	var vis1
	var vis2
	var vis3
} file

void function InitR5RVisibilityMenu( var newMenuArg )
{
	var menu = GetMenu( "R5RChangeVisibility" )
	file.menu = menu

	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, OnR5RSB_Show )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnR5RSB_Close )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnR5RSB_NavigateBack )

	SetGamepadCursorEnabled( menu, false )

	//Set RUI/VGUI

	file.vis1 = Hud_GetChild(menu, "Visbtn1")
	Hud_AddEventHandler( file.vis1, UIE_CLICK, SetVis1 )
	var vis1rui = Hud_GetRui( file.vis1 )
	RuiSetString( vis1rui, "buttonText", "Offline" )

	file.vis2 = Hud_GetChild(menu, "Visbtn2")
	Hud_AddEventHandler( file.vis2, UIE_CLICK, SetVis2 )
	var vis2rui = Hud_GetRui( file.vis2 )
	RuiSetString( vis2rui, "buttonText", "Private/Hidden" )

	file.vis3 = Hud_GetChild(menu, "Visbtn3")
	Hud_AddEventHandler( file.vis3, UIE_CLICK, SetVis3 )
	var vis3rui = Hud_GetRui( file.vis3 )
	RuiSetString( vis3rui, "buttonText", "Public" )
}

void function OnR5RSB_Show()
{
	Chroma_MainMenu()
}


void function OnR5RSB_Close()
{
	//
}

void function OnR5RSB_NavigateBack()
{
	CloseActiveMenu()
}

void function SetVis1(var button)
{
	SetVisibility( eServerVisibility.OFFLINE )
	CloseActiveMenu()
}

void function SetVis2(var button)
{
	SetVisibility( eServerVisibility.HIDDEN )
	CloseActiveMenu()
}

void function SetVis3(var button)
{
	SetVisibility( eServerVisibility.PUBLIC )
	CloseActiveMenu()
}