global function InitR5RLobbyMenu
global function GetUIPlaylistName
global function GetUIMapName
global function GetUIMapAsset
global function GetUIVisibilityName

struct
{
	var menu
	array<var> buttons
	array<var> panels

	int currentpanel = 0

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
	[ "mp_rr_arena_skygarden" ] = $"rui/menu/maps/mp_rr_arena_skygarden",
	[ "mp_rr_party_crasher" ] = $"rui/menu/maps/mp_rr_party_crasher",
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
	[ "mp_rr_arena_skygarden" ] = "Encore",
	[ "mp_rr_party_crasher" ] = "Party Crasher",
	[ "mp_lobby" ] = "Lobby"
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
    AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, OnR5RLobby_Show )
	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnR5RLobby_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnR5RLobby_Close )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnR5RLobby_Back )

	//Button event handlers
	array<var> buttons = GetElementsByClassname( file.menu, "TopButtons" )
	foreach ( var elem in buttons ) {
		Hud_AddEventHandler( elem, UIE_CLICK, OpenSelectedPanel )
	}

	//Setup panel array
	file.panels.append(Hud_GetChild(menu, "R5RHomePanel"))
	file.panels.append(Hud_GetChild(menu, "R5RServerBrowserPanel"))
	file.panels.append(Hud_GetChild(menu, "ModsPanel"))
	file.panels.append(null)

	//Setup Button Vars
	file.buttons.append(Hud_GetChild(menu, "HomeBtn"))
	file.buttons.append(Hud_GetChild(menu, "ServerBrowserBtn"))
	file.buttons.append(Hud_GetChild(menu, "ModsBtn"))
	file.buttons.append(Hud_GetChild(menu, "SettingsBtn"))

	ToolTips_AddMenu( menu )
}

void function OnR5RLobby_Open()
{
	ToolTips_MenuOpened( file.menu )
	RegisterServerBrowserButtonPressedCallbacks()
}

void function OnR5RLobby_Close()
{
	ToolTips_MenuClosed( file.menu )
	UnRegisterServerBrowserButtonPressedCallbacks()
}

void function OnR5RLobby_Show()
{
	ServerBrowser_UpdateFilterLists()
	SetupLobby()

	//Show Home Panel
	ShowSelectedPanel( file.panels[0], file.buttons[0] )
	UI_SetPresentationType( ePresentationType.PLAY )
	CurrentPresentationType = ePresentationType.PLAY

	//Set back to default for next time
	g_isAtMainMenu = false
}

void function OnR5RLobby_Back()
{
	if(file.currentpanel == 2) {
		switch(g_modCameraPosition) {
			case ModCameraPosition.BROWSE:
				ChangeModsPanel(ModCameraMovement.BROWSE_TO_MAIN)
				return;
			case ModCameraPosition.INSTALLED:
				ChangeModsPanel(ModCameraMovement.INSTALLED_TO_MAIN)
				return;
		}
	}

	AdvanceMenu( GetMenu( "SystemMenu" ) )
}

void function OpenSelectedPanel(var button)
{
	//Get the script id, and show the panel acording to that id
	int scriptid = Hud_GetScriptID( button ).tointeger()
	ShowSelectedPanel( file.panels[scriptid], button )

	file.currentpanel = scriptid

	switch(scriptid)
	{
		case 0:
			Play_SetupUI()
			UI_SetPresentationType( ePresentationType.PLAY )
			CurrentPresentationType = ePresentationType.PLAY
			break;
		case 1:
			UI_SetPresentationType( ePresentationType.COLLECTION_EVENT )
			CurrentPresentationType = ePresentationType.COLLECTION_EVENT
			break;
		case 2:
			Mods_SetupUI()
			UI_SetPresentationType( ePresentationType.MODS )
			CurrentPresentationType = ePresentationType.MODS
			break;
		case 3:
			AdvanceMenu( GetMenu( "MiscMenu" ) )
			break;
	}
}

void function SetupLobby()
{
	//Setup Lobby Stuff
	UI_SetPresentationType( CurrentPresentationType )
	thread TryRunDialogFlowThread()

	//Set Version
	Play_SetupUI()

	//Set selected legend from playlist
	ItemFlavor character = GetItemFlavorByHumanReadableRef( GetCurrentPlaylistVarString( "set_legend", "character_wraith" ) )
	RequestSetItemFlavorLoadoutSlot( LocalClientEHI(), Loadout_CharacterClass(), character )
}

void function ShowSelectedPanel(var panel, var button)
{
	if(panel == null)
		return
	
	//Hide all panels
	foreach ( p in file.panels ) {
		if(p != null)
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

////////////////////////////////////////////////////////////////////////////////////////
//
// Extra Functions
//
////////////////////////////////////////////////////////////////////////////////////////

string function GetUIPlaylistName(string playlist)
{
	if(!IsLobby() || !IsConnected())
		return ""

	return GetPlaylistVarString( playlist, "name", playlist )
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