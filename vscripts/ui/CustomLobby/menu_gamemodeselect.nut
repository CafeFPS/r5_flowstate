global function InitR5RGamemodeSelectDialog

const int MAX_DISPLAYED_MODES = 5
const int MAX_TOP_SERVERS = 3
const int MAX_FREEROAM_MAPS = 6

struct TopServer {
	int	svServerID
	string svServerName
	string svMapName
	string svPlaylist
	string svDescription
	int svMaxPlayers
	int svCurrentPlayers
}

global struct SelectedTopServer {
	int	svServerID
	string svServerName
	string svMapName
	string svPlaylist
	string svDescription
	int svMaxPlayers
	int svCurrentPlayers
}

struct {
	var menu

	bool showfreeroam = false
	int freeroamscroll = 0

	int pageoffset = 0

	array<TopServer> m_vTopServers
	array<string> m_vPlaylists
	array<string> m_vMaps
} file

global SelectedTopServer g_SelectedTopServer

global string g_SelectedPlaylist
global string g_SelectedQuickPlay
global string g_SelectedQuickPlayMap
global asset g_SelectedQuickPlayImage

void function InitR5RGamemodeSelectDialog( var newMenuArg ) //
{
	var menu = GetMenu( "R5RGamemodeSelectV2Dialog" )
	file.menu = menu

	HudElem_SetRuiArg( Hud_GetChild( menu, "PrevPageButton" ), "flipHorizontal", true )
	Hud_AddEventHandler( Hud_GetChild( menu, "PrevPageButton" ), UIE_CLICK, PrevPage_Activated )
	Hud_AddEventHandler( Hud_GetChild( menu, "NextPageButton" ), UIE_CLICK, NextPage_Activated )
	Hud_AddEventHandler( Hud_GetChild( menu, "FiringRangeButton" ), UIE_CLICK, FiringRange_Activated )
	Hud_AddEventHandler( Hud_GetChild( menu, "FreeRoamButton" ), UIE_CLICK, FreeRoam_Activated )
	Hud_AddEventHandler( Hud_GetChild( menu, "PrivateMatchBtn" ), UIE_CLICK, PrivateMatch_Activated )
	Hud_AddEventHandler( Hud_GetChild( menu, "CloseButton" ), UIE_CLICK, OnCloseButton_Activate )
	
	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpenModeSelectDialog )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnCloseModeSelectDialog )
	
	foreach ( uielem in GetElementsByClassname( menu, "FreeRoamUI" ) ) {
		Hud_Hide( uielem )
		Hud_AddEventHandler( uielem, UIE_CLICK, FreeRoamButton_Activated )
	}

	foreach ( btn in GetElementsByClassname( menu, "TopServerButtons" ) )
		Hud_AddEventHandler( btn, UIE_CLICK, TopServerButton_Activated )

	foreach ( btn in GetElementsByClassname( menu, "GamemodeButtons" ) )
		Hud_AddEventHandler( btn, UIE_CLICK, PlaylistButton_Activated )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CLOSE", "#CLOSE" )
	AddMenuFooterOption( menu, LEFT, BUTTON_A, true, "#A_BUTTON_SELECT" )
}

void function PrivateMatch_Activated(var button)
{
	AdvanceMenu( GetMenu( "R5RCreateMatch" ) )
}

void function OnOpenModeSelectDialog()
{
	Servers_GetCurrentServerListing()
	SetupTopServers()
	SetupPlaylistQuickSearch()
	SetupFreeRoamButtons()
}

void function OnCloseModeSelectDialog()
{
	DiagCloseing()
}

void function OnCloseButton_Activate( var button )
{
	DiagCloseing()
}

void function DiagCloseing()
{
	if(!file.showfreeroam)
		return
	
	foreach ( var uielem in GetElementsByClassname( file.menu, "FreeRoamUI" ) )
		Hud_Hide( uielem )

	RemoveCallback_OnMouseWheelUp( FreeRoam_ScrollUp )
    RemoveCallback_OnMouseWheelDown( FreeRoam_ScrollDown )

	file.showfreeroam = false
	file.freeroamscroll = 0
}

////////////////////////////////////////////////////////////////////////////////////////
//
// Quick Server Join
//
////////////////////////////////////////////////////////////////////////////////////////

void function NextPage_Activated(var button)
{
	file.pageoffset += 1
	SetupPlaylistQuickSearch()
}

void function PrevPage_Activated(var button)
{
	file.pageoffset -= 1
	SetupPlaylistQuickSearch()
}

void function PlaylistButton_Activated(var button)
{
	int id = Hud_GetScriptID( button ).tointeger()
	g_SelectedPlaylist = file.m_vPlaylists[id + file.pageoffset]
	R5RPlay_SetSelectedPlaylist(JoinType.QuickServerJoin)
	DiagCloseing()
	CloseActiveMenu()
}

void function SetupPlaylistQuickSearch()
{
	array<string> playlists = Servers_GetActivePlaylists()
	playlists.insert(0, "Random Server")

	file.m_vPlaylists = playlists

	Hud_Hide( Hud_GetChild( file.menu, "PrevPageButton" ) )
	if( file.pageoffset != 0 && playlists.len() > 4)
		Hud_Show( Hud_GetChild( file.menu, "PrevPageButton" ) )

	Hud_Hide( Hud_GetChild( file.menu, "NextPageButton" ) )
	if( file.pageoffset < playlists.len() - 5 && playlists.len() > 4)
		Hud_Show( Hud_GetChild( file.menu, "NextPageButton" ) )

    //Hide all items
    for(int j = 0; j < MAX_DISPLAYED_MODES; j++)
        Hud_Hide( Hud_GetChild( file.menu, "GameModeButton" + j ) )

    int offset = 0
    for(int j = 0; j < playlists.len() + 1; j++)
    {
		if( j > playlists.len() - 1 )
			break

		if( j > MAX_DISPLAYED_MODES - 1 )
			break
		
        Hud_Show( Hud_GetChild( file.menu, "GameModeButton" + j ) )

		if(j != 0)
        	offset -= (Hud_GetWidth(Hud_GetChild( file.menu, "GameModeButton0" ))/2) + 5
    }

    Hud_SetX( Hud_GetChild( file.menu, "GameModeButton0" ), 0 )
    if( playlists.len() > 0 )
        Hud_SetX( Hud_GetChild( file.menu, "GameModeButton0" ), offset )

	for(int i = 0; i < MAX_DISPLAYED_MODES; i++)
	{
		if(i + file.pageoffset >= playlists.len())
			break
		
		if(playlists[i + file.pageoffset] == "Random Server")
		{
			RuiSetString( Hud_GetRui( Hud_GetChild( file.menu, "GameModeButton" + i ) ), "modeNameText", "Random Server" )
			RuiSetString( Hud_GetRui( Hud_GetChild( file.menu, "GameModeButton" + i ) ), "modeDescText", "Quickly Join any kind of server" )
			RuiSetImage( Hud_GetRui( Hud_GetChild( file.menu, "GameModeButton" + i ) ), "modeImage", $"rui/menu/gamemode/ranked_1" )
		}
		else
		{
			RuiSetString( Hud_GetRui( Hud_GetChild( file.menu, "GameModeButton" + i ) ), "modeNameText", GetUIPlaylistName(playlists[i + file.pageoffset]) )
			RuiSetString( Hud_GetRui( Hud_GetChild( file.menu, "GameModeButton" + i ) ), "modeDescText", "" )
			RuiSetImage( Hud_GetRui( Hud_GetChild( file.menu, "GameModeButton" + i ) ), "modeImage", $"rui/menu/gamemode/play_apex" )
		}
	    RuiSetBool( Hud_GetRui( Hud_GetChild( file.menu, "GameModeButton" + i )), "alwaysShowDesc", false )
	}
}

////////////////////////////////////////////////////////////////////////////////////////
//
// Top Servers
//
////////////////////////////////////////////////////////////////////////////////////////

void function SetupTopServers()
{
	foreach ( btn in GetElementsByClassname( file.menu, "TopServerButtons" ) )
		Hud_Hide( btn )
	
	file.m_vTopServers.clear()
	for(int i = 0; i < MAX_TOP_SERVERS; i++)
	{
		if(i >= global_m_vServerList.len())
			break
		
		TopServer server
		server.svServerID = global_m_vServerList[i].svServerID
		server.svServerName = global_m_vServerList[i].svServerName
		server.svMapName = global_m_vServerList[i].svMapName
		server.svPlaylist = global_m_vServerList[i].svPlaylist
		server.svDescription = global_m_vServerList[i].svDescription
		server.svMaxPlayers = global_m_vServerList[i].svMaxPlayers
		server.svCurrentPlayers = global_m_vServerList[i].svCurrentPlayers
		file.m_vTopServers.append(server)
	}

	int btnid = 2
	foreach(int i, TopServer server in file.m_vTopServers)
	{
		string servername = file.m_vTopServers[i].svServerName
		if(file.m_vTopServers[i].svServerName.len() > 30)
			servername = file.m_vTopServers[i].svServerName.slice(0, 30) + "..."

		var TopServer = Hud_GetChild( file.menu, "TopServerButton" + btnid )
		Hud_Show( TopServer )
		RuiSetString( Hud_GetRui( TopServer ), "modeNameText", servername )
		RuiSetString( Hud_GetRui( TopServer ), "modeDescText", "Players " + file.m_vTopServers[i].svCurrentPlayers + "/" + file.m_vTopServers[i].svMaxPlayers )
		RuiSetBool( Hud_GetRui( TopServer ), "alwaysShowDesc", false )
		RuiSetImage( Hud_GetRui( TopServer ), "modeImage", GetUIMapAsset(file.m_vTopServers[i].svMapName ) )
		Hud_SetLocked( TopServer, false )
		RuiSetString( Hud_GetRui( TopServer ), "modeLockedReason", "" )
		RuiSetBool( Hud_GetRui( TopServer ), "showLockedIcon", false )

		if( file.m_vTopServers[i].svCurrentPlayers == file.m_vTopServers[i].svMaxPlayers )
		{
			Hud_SetLocked( TopServer, true )
			RuiSetString( Hud_GetRui( TopServer ), "modeLockedReason", "Server is full" )
			RuiSetBool( Hud_GetRui( TopServer ), "showLockedIcon", true )
		}

		btnid--
	}
}

void function TopServerButton_Activated(var button)
{
	if ( Hud_IsLocked( button ) )
		return

	int id = Hud_GetScriptID( button ).tointeger()

	g_SelectedTopServer.svServerID = file.m_vTopServers[id].svServerID
	g_SelectedTopServer.svServerName = file.m_vTopServers[id].svServerName
	g_SelectedTopServer.svMapName = file.m_vTopServers[id].svMapName
	g_SelectedTopServer.svPlaylist = file.m_vTopServers[id].svPlaylist
	g_SelectedTopServer.svDescription = file.m_vTopServers[id].svDescription
	g_SelectedTopServer.svMaxPlayers = file.m_vTopServers[id].svMaxPlayers
	g_SelectedTopServer.svCurrentPlayers = file.m_vTopServers[id].svCurrentPlayers

	R5RPlay_SetSelectedPlaylist(JoinType.TopServerJoin)
	DiagCloseing()
	CloseActiveMenu()
}

////////////////////////////////////////////////////////////////////////////////////////
//
// Quick Play
//
////////////////////////////////////////////////////////////////////////////////////////

void function FiringRange_Activated(var button)
{
	g_SelectedQuickPlay = "survival_firingrange"
	g_SelectedQuickPlayMap = "mp_rr_canyonlands_staging"
	g_SelectedQuickPlayImage = $"rui/menu/gamemode/firing_range"
	R5RPlay_SetSelectedPlaylist(JoinType.QuickPlay)
	DiagCloseing()
	CloseActiveMenu()
}

////////////////////////////////////////////////////////////////////////////////////////
//
// Free Roam
//
////////////////////////////////////////////////////////////////////////////////////////

void function SetupFreeRoamButtons()
{
	file.m_vMaps = GetPlaylistMaps("survival_dev")
	for(int i = 0; i < MAX_FREEROAM_MAPS; i++)
	{
		RuiSetString( Hud_GetRui( Hud_GetChild( file.menu, "FreeRoamButton" + i ) ), "modeNameText", GetUIMapName(file.m_vMaps[i + file.freeroamscroll]) )
		RuiSetString( Hud_GetRui( Hud_GetChild( file.menu, "FreeRoamButton" + i ) ), "modeDescText", "" )
		RuiSetImage( Hud_GetRui( Hud_GetChild( file.menu, "FreeRoamButton" + i ) ), "modeImage", GetUIMapAsset(file.m_vMaps[i + file.freeroamscroll]) )
	}
}

void function FreeRoam_Activated(var button)
{
	if(file.showfreeroam)
	{
		foreach ( var uielem in GetElementsByClassname( file.menu, "FreeRoamUI" ) )
			Hud_Hide( uielem )

		RemoveCallback_OnMouseWheelUp( FreeRoam_ScrollUp )
        RemoveCallback_OnMouseWheelDown( FreeRoam_ScrollDown )
		file.showfreeroam = false
		return
	}

	foreach ( var uielem in GetElementsByClassname( file.menu, "FreeRoamUI" ) )
		Hud_Show( uielem )

	AddCallback_OnMouseWheelUp( FreeRoam_ScrollUp )
    AddCallback_OnMouseWheelDown( FreeRoam_ScrollDown )
	file.showfreeroam = true
	file.freeroamscroll = 0
}

void function FreeRoam_ScrollUp()
{
	if(file.freeroamscroll > 0)
		file.freeroamscroll -= 1

	SetupFreeRoamButtons()
}

void function FreeRoam_ScrollDown()
{
	int max = file.m_vMaps.len()

	if(file.freeroamscroll + 6 < max)
		file.freeroamscroll += 1

    SetupFreeRoamButtons()
}

void function FreeRoamButton_Activated(var button)
{
	int id = Hud_GetScriptID( button ).tointeger()
	
	g_SelectedQuickPlay = "survival_dev"
	g_SelectedQuickPlayMap = file.m_vMaps[id + file.freeroamscroll]
	g_SelectedQuickPlayImage = GetUIMapAsset( g_SelectedQuickPlayMap )

	R5RPlay_SetSelectedPlaylist(JoinType.QuickPlay)
	DiagCloseing()
	CloseActiveMenu()
}