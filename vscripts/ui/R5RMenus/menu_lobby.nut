global function InitR5RLobbyMenu
global function GetUIPlaylistName
global function GetUIMapName
global function GetUIMapAsset
global function GetUIVisibilityName
global function InPlayersLobby

struct
{
	var menu
	array<var> buttons
	array<var> panels

	var HomePanel
	var CreateServerPanel
	var ServerBrowserPanel
} file

// do not change this enum without modifying it in code at gameui/IBrowser.h
global enum eServerVisibility
{
	OFFLINE,
	HIDDEN,
	PUBLIC
}

global int CurrentPresentationType = ePresentationType.PLAY

//Map to asset
global table<string, asset> MapAssets = {
	[ "mp_rr_canyonlands_staging" ] = $"rui/menu/maps/mp_rr_canyonlands_staging",
	[ "mp_rr_aqueduct" ] = $"rui/menu/maps/mp_rr_aqueduct",
	[ "mp_rr_aqueduct_night" ] = $"rui/menu/maps/mp_rr_aqueduct_night",
	[ "mp_rr_ashs_redemption" ] = $"rui/menu/maps/mp_rr_ashs_redemption",
	[ "mp_rr_canyonlands_64k_x_64k" ] = $"rui/menu/maps/mp_rr_canyonlands_64k_x_64k",
	[ "mp_rr_canyonlands_mu1" ] = $"rui/menu/maps/mp_rr_canyonlands_mu1",
	[ "mp_rr_canyonlands_mu1_night" ] = $"rui/menu/maps/mp_rr_canyonlands_mu1_night",
	[ "mp_rr_desertlands_64k_x_64k" ] = $"rui/menu/maps/mp_rr_desertlands_64k_x_64k",
	[ "mp_rr_desertlands_64k_x_64k_nx" ] = $"rui/menu/maps/mp_rr_desertlands_64k_x_64k_nx",
	[ "mp_rr_desertlands_64k_x_64k_tt" ] = $"rui/menu/maps/mp_rr_desertlands_64k_x_64k_tt",
	[ "mp_rr_arena_composite" ] = $"rui/menu/maps/mp_rr_arena_composite",
	[ "mp_lobby" ] = $"rui/menu/maps/mp_lobby"
}

//Map to readable name
global table<string, string> MapNames = {
	[ "mp_rr_canyonlands_staging" ] = "Firing Range",
	[ "mp_rr_aqueduct" ] = "Overflow",
	[ "mp_rr_aqueduct_night" ] = "Overflow After Dark",
	[ "mp_rr_ashs_redemption" ] = "Ash's Redemption",
	[ "mp_rr_canyonlands_64k_x_64k" ] = "Kings Canyon S1",
	[ "mp_rr_canyonlands_mu1" ] = "Kings Canyon S2",
	[ "mp_rr_canyonlands_mu1_night" ] = "Kings Canyon S2 After Dark",
	[ "mp_rr_desertlands_64k_x_64k" ] = "Worlds Edge",
	[ "mp_rr_desertlands_64k_x_64k_nx" ] = "Worlds Edge After Dark",
	[ "mp_rr_desertlands_64k_x_64k_tt" ] = "Worlds Edge Mirage Voyage",
	[ "mp_rr_arena_composite" ] = "Drop Off",
	[ "mp_lobby" ] = "Lobby"
}

//Playlist to readable name
global table<string, string> playlisttoname = {
	[ "custom_aimtrainer" ] = "Flowstate Aim Trainer",
	[ "firingrange" ] = "Firing Range (Beta)",
	[ "survival" ] = "Battle Royale (Beta)",
	[ "FallLTM" ] = "ShadowFall",
	[ "duos" ] = "Duos (Beta)",
	[ "custom_tdm" ] = "Flowstate TDM/FFA",
	[ "custom_ctf" ] = "Capture The Flag",
	[ "survival_dev" ] = "Survival Dev",
	[ "custom_tdm_fiesta" ] = "Flowstate Fiesta",
	[ "custom_tdm_gungame" ] = "Flowstate Gungame (Beta)",
	[ "custom_prophunt" ] = "Flowstate Prophunt (Beta)",
	[ "custom_surf" ] = "Flowstate SURF",
	[ "map_editor" ] = "Map Editor",
	[ "dev_default" ] = "Dev Default"
}

//Vis to readable name
global table<int, string> VisibilityNames = {
	[ eServerVisibility.OFFLINE ] = "Offline",
	[ eServerVisibility.HIDDEN ] = "Hidden",
	[ eServerVisibility.PUBLIC ] = "Public"
}

void function InitR5RLobbyMenu( var newMenuArg )
{
	var menu = GetMenu( "R5RLobbyMenu" )
	file.menu = menu

	//Add menu event handlers
    AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, OnR5RLobby_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnR5RLobby_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnR5RLobby_Back )

	//Button event handlers
	Hud_AddEventHandler( Hud_GetChild(menu, "SettingsBtn"), UIE_CLICK, SettingsPressed )
	Hud_AddEventHandler( Hud_GetChild(menu, "QuitBtn"), UIE_CLICK, QuitPressed )
	array<var> buttons = GetElementsByClassname( file.menu, "TopButtons" )
	foreach ( var elem in buttons ) {
		Hud_AddEventHandler( elem, UIE_CLICK, OpenSelectedPanel )
	}

	//Setup panel array
	file.panels.append(Hud_GetChild(menu, "R5RHomePanel"))
	file.panels.append(Hud_GetChild(menu, "R5RPrivateMatchPanel"))
	file.panels.append(Hud_GetChild(menu, "R5RServerBrowserPanel"))

	//Setup Button Vars
	file.buttons.append(Hud_GetChild(menu, "HomeBtn"))
	file.buttons.append(Hud_GetChild(menu, "CreateServerBtn"))
	file.buttons.append(Hud_GetChild(menu, "ServerBrowserBtn"))
}

void function OpenSelectedPanel(var button)
{
	//Get the script id, and show the panel acording to that id
	int scriptid = Hud_GetScriptID( button ).tointeger()
	ShowSelectedPanel( file.panels[scriptid], button )

	switch(scriptid)
	{
		case 0:
			UI_SetPresentationType( ePresentationType.PLAY )
			CurrentPresentationType = ePresentationType.PLAY
			break;
		case 1:
			PrivateMatchMenuOpened()
			UI_SetPresentationType( ePresentationType.CHARACTER_SELECT )
			CurrentPresentationType = ePresentationType.CHARACTER_SELECT
			break;
		case 2:
			//thread ServerBrowser_RefreshServersForEveryone()
			UI_SetPresentationType( ePresentationType.COLLECTION_EVENT )
			CurrentPresentationType = ePresentationType.COLLECTION_EVENT
			break;
	}
}

void function SettingsPressed(var button)
{
	//Open Settings Menu
	AdvanceMenu( GetMenu( "MiscMenu" ) )
}

void function QuitPressed(var button)
{
	//Open confirm exit diologe
	OpenConfirmExitToDesktopDialog()
}

void function OnR5RLobby_Open()
{
	//needed on both show and open
	SetupLobby()

	//Show Home Panel
	ShowSelectedPanel( file.panels[0], file.buttons[0] )
	UI_SetPresentationType( ePresentationType.PLAY )
	CurrentPresentationType = ePresentationType.PLAY

	//Set back to default for next time
	g_isAtMainMenu = false

	server_host_name = ""

	RunClientScript("UICallback_SetHostName", GetPlayerName() + "'s Lobby")
}

void function SetupLobby()
{
	//Setup Lobby Stuff
	UI_SetPresentationType( CurrentPresentationType )
	thread TryRunDialogFlowThread()

	//Set Version
	SetUIVersion()

	//Set selected legend from playlist
	ItemFlavor character = GetItemFlavorByHumanReadableRef( GetCurrentPlaylistVarString( "set_legend", "character_wraith" ) )
	RequestSetItemFlavorLoadoutSlot( LocalClientEHI(), Loadout_CharacterClass(), character )
}

void function ShowSelectedPanel(var panel, var button)
{
	//Hide all panels
	foreach ( p in file.panels ) {
		Hud_SetVisible( p, false )
	}

	//Unselect all buttons
	foreach ( btn in file.buttons ) {
		RuiSetBool( Hud_GetRui( btn ) ,"isSelected", false )
	}

	//Select button
	RuiSetBool( Hud_GetRui( button ) ,"isSelected", true )

	//Show selected panel
	Hud_SetVisible( panel, true )
}

string function GetUIPlaylistName(string playlist)
{
	//Set default playlist string
	string playlistname = playlist

	//If playlist in the table set it to the readable name
	if(playlist in playlisttoname)
		playlistname = playlisttoname[playlist]

	//return the playlist name
	return playlistname
}

string function GetUIMapName(string map)
{
	if(map in MapNames)
		return MapNames[map]

	return map
}

string function GetUIVisibilityName(int vis)
{
	if(vis in VisibilityNames)
		return VisibilityNames[vis]

	return ""
}

asset function GetUIMapAsset(string map)
{
	if(map in MapAssets)
		return MapAssets[map]

	return $"rui/menu/maps/map_not_found"
}

void function OnR5RLobby_Back()
{
	if(PMMenusOpen.maps_open || PMMenusOpen.playlists_open || PMMenusOpen.vis_open || PMMenusOpen.name_open || PMMenusOpen.desc_open || PMMenusOpen.kick_open)
    {
		var pmpanel = GetPanel( "R5RPrivateMatchPanel" )
        Hud_SetVisible( Hud_GetChild(pmpanel, "R5RMapPanel"), false )
        Hud_SetVisible( Hud_GetChild(pmpanel, "R5RPlaylistPanel"), false )
        Hud_SetVisible( Hud_GetChild(pmpanel, "R5RVisPanel"), false )
        Hud_SetVisible( Hud_GetChild(file.menu, "R5RNamePanel"), false )
        Hud_SetVisible( Hud_GetChild(file.menu, "R5RDescPanel"), false )
        Hud_SetVisible( Hud_GetChild(file.menu, "R5RKickPanel"), false )

        PMMenusOpen.maps_open = false
        PMMenusOpen.playlists_open = false
        PMMenusOpen.vis_open = false
        PMMenusOpen.name_open = false
        PMMenusOpen.desc_open = false
        PMMenusOpen.kick_open = false
    }
}

void function InPlayersLobby(bool show, string host)
{
	Hud_SetVisible( Hud_GetChild(GetPanel( "R5RHomePanel" ), "InPlayersLobby"), show )
    Hud_SetVisible( Hud_GetChild(GetPanel( "R5RHomePanel" ), "InPlayersLobbyText"), show )
	Hud_SetText( Hud_GetChild(GetPanel( "R5RHomePanel" ), "InPlayersLobbyText"), "You are in " + host + "'s lobby" )
}