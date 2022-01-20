global function InitR5RGamemodeMenu

struct
{
	var menu

	array<string> availablePlaylists = []
} file

const string GAMEMODE_BUTTON_CLASSNAME = "GamemodeBtn"

void function InitR5RGamemodeMenu( var newMenuArg )
{
	var menu = GetMenu( "R5RChangeGamemode" )
	file.menu = menu

	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, OnR5RSB_Show )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnR5RSB_NavigateBack )

	SetGamepadCursorEnabled( menu, false )

	// this is temp until i can figure out a way of getting the playlists early enough
	// so that they can be used from a native func
	file.availablePlaylists = [
		"survival_staging_baseline",
		"survival_training",
		"survival_firingrange",
		"survival",
		"ranked",
		"FallLTM",
		"duos",
		"custom_tdm",
		"custom_tdm_tps",
		"survival_dev",
		"dev_default",
		"menufall"
	]

	foreach( button in GetElementsByClassname( menu, GAMEMODE_BUTTON_CLASSNAME ) )
	{
		int buttonID = int( Hud_GetScriptID( button ) )

		// if this button's script id is above the maximum index of gamemodes, break from the loop
		if(buttonID > file.availablePlaylists.len()-1)
			break;

		Hud_AddEventHandler( button, UIE_CLICK, GamemodeButton_SetMode )

		var rui = Hud_GetRui( button )
		RuiSetString( rui, "buttonText", file.availablePlaylists[ buttonID ] )
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

void function GamemodeButton_SetMode( var button )
{
	int buttonID = int( Hud_GetScriptID( button ) )

	// check that button id is still within the range of gamemodes
	// i don't think this can actually be an issue that occurs but may as well check it
	if( buttonID > file.availablePlaylists.len()-1 )
	{
		Warning("Attempted to use a gamemode button with script id %i, but the maximum index is %i!", buttonID, file.availablePlaylists.len()-1)
		return
	}

	string requestedPlaylistName = file.availablePlaylists[ buttonID ]

	printf( "%s() - Setting server playlist to %s\n", FUNC_NAME(), requestedPlaylistName )
	SetGamemode(requestedPlaylistName)
	CloseActiveMenu()
}