global function InitR5RMapMenu

struct
{
	var menu

	array<string> maps
} file

const string MAP_BUTTON_CLASSNAME = "MapButton"

string function TEMP_GetMapNameSuffix(string mapname)
{
	switch(mapname)
	{
		case "mp_rr_canyonlands_64k_x_64k":
			return " (Season 0)"
		case "mp_rr_canyonlands_mu1":
			return " (Season 2)"
		case "mp_rr_desertlands_64k_x_64k":
		case "mp_rr_desertlands_64k_x_64k_nx":
			return " (Season 3)"
		default:
			return ""
	}
	unreachable
}

void function InitR5RMapMenu( var newMenuArg )
{
	var menu = GetMenu( "R5RChangeMap" )
	file.menu = menu

	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, OnR5RSB_Show )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnR5RSB_NavigateBack )

	SetGamepadCursorEnabled( menu, false )

	file.maps = GetAvailableMaps()

	foreach( button in GetElementsByClassname( menu, MAP_BUTTON_CLASSNAME ) )
	{
		int buttonID = int( Hud_GetScriptID( button ) )

		// if this button's script id is above the maximum index of maps, break from the loop
		if(buttonID > file.maps.len()-1)
		{
			Hud_SetEnabled( button, false )
			Hud_SetVisible( button, true )
			continue;
		}

		Hud_SetEnabled( button, true )
		Hud_SetVisible( button, true )

		Hud_AddEventHandler( button, UIE_CLICK, MapButton_SetMap )

		var rui = Hud_GetRui( button )
		RuiSetString( rui, "buttonText", Localize( "#" + file.maps[ buttonID ]) + TEMP_GetMapNameSuffix( file.maps[ buttonID ] ) )
	}
}

void function OnR5RSB_Show()
{
	Chroma_MainMenu()
}

void function OnR5RSB_NavigateBack()
{
	CloseActiveMenu()
}

void function MapButton_SetMap( var button )
{
	int buttonID = int( Hud_GetScriptID( button ) )

	// check that button id is still within the range of gamemodes
	// i don't think this can actually be an issue that occurs but may as well check it
	if( buttonID > file.maps.len()-1 )
	{
		Warning("Attempted to use a map button with script id %i, but the maximum index is %i!", buttonID, file.maps.len()-1)
		return
	}

	string mapname = file.maps[ buttonID ]

	printf( "%s() - Setting server map to %s\n", FUNC_NAME(), mapname )

	SetMap( mapname )
	CloseActiveMenu()
}