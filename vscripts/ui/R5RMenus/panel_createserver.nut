global function InitR5RCreateServerPanel

global function SetSelectedServerMap
global function SetSelectedServerPlaylist
global function SetSelectedServerVis
global function HideAllCreateServerPanels

struct
{
	var menu
	var panel

	array<var> panels
} file

global struct ServerStruct
{
	string svServerName
	string svMapName
	string svPlaylist
	int svVisibility
}

global ServerStruct ServerSettings

void function InitR5RCreateServerPanel( var panel )
{
	file.panel = panel
	file.menu = GetParentMenu( file.panel )

	//Setup Button EventHandlers
	Hud_AddEventHandler( Hud_GetChild( file.panel, "BtnStartGame" ), UIE_CLICK, StartNewGame )
	AddButtonEventHandler( Hud_GetChild( file.panel, "BtnServerName"), UIE_CHANGE, UpdateServerName )
	array<var> buttons = GetElementsByClassname( file.menu, "createserverbuttons" )
	foreach ( var elem in buttons ) {
		Hud_AddEventHandler( elem, UIE_CLICK, OpenSelectedPanel )
	}

	//Setup panel array
	file.panels.append(Hud_GetChild(file.panel, "R5RMapPanel"))
	file.panels.append(Hud_GetChild(file.panel, "R5RPlaylistPanel"))
	file.panels.append(Hud_GetChild(file.panel, "R5RVisPanel"))

	//Setup Default Server Config
	ServerSettings.svServerName = "A R5Reloaded Server"
	ServerSettings.svMapName = "mp_rr_aqueduct"
	ServerSettings.svPlaylist = "custom_tdm"
	ServerSettings.svVisibility = eServerVisibility.OFFLINE

	//Setup Default Server Config
	Hud_SetText(Hud_GetChild( file.panel, "PlaylistInfoEdit" ), playlisttoname[ServerSettings.svPlaylist])
	RuiSetImage( Hud_GetRui( Hud_GetChild( file.panel, "ServerMapImg" ) ), "loadscreenImage", GetUIMapAsset( ServerSettings.svMapName ) )
	Hud_SetText(Hud_GetChild( file.panel, "VisInfoEdit" ), vistoname[ServerSettings.svVisibility])
	Hud_SetText( Hud_GetChild( file.panel, "BtnServerName" ), "A R5Reloaded Server" )
}

void function OpenSelectedPanel( var button )
{
	//Show panel depending on script id
	ShowSelectedPanel( file.panels[Hud_GetScriptID( button ).tointeger()] )
}

void function StartNewGame( var button )
{
	//Start thread for starting the server
	thread StartServer()
}

void function StartServer()
{
	//Shutdown the lobby vm
	ShutdownHostGame()

	//Set the main menus blackscreen visibility to true
	SetMainMenuBlackScreenVisible(true)

	//wait for lobby vm to be actually shut down and back at the main menu
	while(!AtMainMenu) {
		WaitFrame()
	}

	//Create new server with selected settings
	CreateServer(ServerSettings.svServerName, ServerSettings.svMapName, ServerSettings.svPlaylist, ServerSettings.svVisibility)

	//No longer at main menu
	AtMainMenu = false
}

void function SetSelectedServerMap( string map )
{
	//set map
	ServerSettings.svMapName = map

	//Set the panel to not visible
	Hud_SetVisible( file.panels[0], false )

	//Set the new map image
	RuiSetImage( Hud_GetRui( Hud_GetChild( file.panel, "ServerMapImg" ) ), "loadscreenImage", GetUIMapAsset( ServerSettings.svMapName ) )
}

void function SetSelectedServerPlaylist( string playlist )
{
	//set playlist
	ServerSettings.svPlaylist = playlist

	//Get the maps of the new playlist
	array<string> playlist_maps = GetPlaylistMaps(ServerSettings.svPlaylist)
	
	//Set the panel to not visible
	Hud_SetVisible( file.panels[1], false )

	//Set the new playlist text
	Hud_SetText(Hud_GetChild( file.panel, "PlaylistInfoEdit" ), GetUIPlaylistName( ServerSettings.svPlaylist ) )

	//This should ever really be triggered but here just incase
	//The way this would be triggered is if there are no maps in put in the selected playlist
	if(playlist_maps.len() == 0) {
		SetSelectedServerMap("mp_rr_canyonlands_64k_x_64k")
		RefreshUIMaps()
		return
	}

	//Check to see if the current map is allowed on the new selected playlist
	if(!playlist_maps.contains(ServerSettings.svMapName))
		SetSelectedServerMap(playlist_maps[0])

	//Refresh Maps
	RefreshUIMaps()
}

void function SetSelectedServerVis( int vis )
{
	//set visibility
	ServerSettings.svVisibility = vis

	//Set the panel to not visible
	Hud_SetVisible( file.panels[2], false )

	//Set the new visibility text
	Hud_SetText(Hud_GetChild( file.panel, "VisInfoEdit" ), vistoname[ServerSettings.svVisibility])
}

void function ShowSelectedPanel(var panel)
{
	//Hide all panels
	foreach ( p in file.panels ) {
		Hud_SetVisible( p, false )
	}

	//Show selected panel
	Hud_SetVisible( panel, true )
}

void function HideAllCreateServerPanels()
{
	//Hide all panels
	foreach ( p in file.panels ) {
		Hud_SetVisible( p, false )
	}
}

void function UpdateServerName( var button )
{
    //Update the servername when the text is changed
    ServerSettings.svServerName = Hud_GetUTF8Text( Hud_GetChild( file.panel, "BtnServerName" ) )
}