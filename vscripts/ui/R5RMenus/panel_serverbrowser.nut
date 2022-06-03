global function InitR5RServerBrowserPanel
global function RefreshServerListing

global const SB_MAX_SERVER_PER_PAGE = 19

struct R5RServer
{
	int ServerID
	string Name
	string Playlist
	string Map
	string Desc
	int maxplayers
	int currentplayers
}

struct ServerInfo
{
	int ServerID = -1
	string ServerName = ""
	string Map = ""
	string Playlist = ""
	string Desc
}

struct
{
	var menu
	var panel

	array<R5RServer> Servers
	int allplayers

	int pages
	int currentpage
	int pageoffset
} file

ServerInfo SelectedServerInfo

void function InitR5RServerBrowserPanel( var panel )
{
	file.panel = panel
	file.menu = GetParentMenu( file.panel )

	//Setup Page Nav Buttons
	Hud_AddEventHandler( Hud_GetChild( file.panel, "BtnServerListRightArrow" ), UIE_CLICK, NextPage )
	Hud_AddEventHandler( Hud_GetChild( file.panel, "BtnServerListLeftArrow" ), UIE_CLICK, PrevPage )
	//Setup Connect Button
	Hud_AddEventHandler( Hud_GetChild( file.panel, "ConnectButton" ), UIE_CLICK, ConnectToServer )
	//Setup Refresh Button
	Hud_AddEventHandler( Hud_GetChild( file.panel, "RefreshServers" ), UIE_CLICK, RefreshServersClick )

	//Add event handlers for the server buttons
	//Clear buttontext
	//No need to remove them as they are hidden if not in use
	array<var> serverbuttons = GetElementsByClassname( file.menu, "ServBtn" )
	foreach ( var elem in serverbuttons )
	{
		RuiSetString( Hud_GetRui( elem ), "buttonText", "")
		Hud_AddEventHandler( elem, UIE_CLICK, SelectServer )
	}
}

void function RefreshServersClick(var button)
{
	//Refresh Server Browser
	RefreshServerListing()
}

void function ConnectToServer(var button)
{
	//If server isnt selected return
	if(SelectedServerInfo.ServerID == -1)
		return

	//Connect to server
	thread StartServerConnection()
	printf("Debug (Server ID: " + SelectedServerInfo.ServerID + " | Server Name: " + SelectedServerInfo.ServerName + " | Map: " + SelectedServerInfo.Map + " | Playlist: " + SelectedServerInfo.Playlist + ")")
}

void function SelectServer(var button)
{
	//Get the button id and add it to the pageoffset to get the correct server id
	int finalid = Hud_GetScriptID( button ).tointeger() + file.pageoffset

	SetSelectedServer(finalid, file.Servers[finalid].Name, file.Servers[finalid].Map, file.Servers[finalid].Playlist, file.Servers[finalid].Desc)
}

void function RefreshServerListing()
{
	//Clear Server List Text, Hide no servers found ui, Reset pages
	ResetServerLabels()
	ShowNoServersFound(false)
	file.pages = 0

	// Get Server Count
	int servercount = GetServerCount()

	// If no servers then set no servers found ui and return
	if(servercount == 0) {
		// Show no servers found ui
		ShowNoServersFound(true)

		// Set selected server to none
		SetSelectedServer(-1, "", "", "", "")

		// Set servercount, playercount, pages to none
		Hud_SetText( Hud_GetChild( file.panel, "PlayersCount"), "Players: 0")
		Hud_SetText( Hud_GetChild( file.panel, "ServersCount"), "Servers: 0")
		Hud_SetText (Hud_GetChild( file.panel, "Pages" ), "Page: 0/0")

		// Return as it dosnt need togo past this if no servers are found
		return
	}

	// Get Server Array
	file.Servers = GetServerArray(servercount)

	// Setup Buttons and labels
	for( int i=0; i < file.Servers.len() && i < SB_MAX_SERVER_PER_PAGE; i++ )
	{
		Hud_SetText( Hud_GetChild( file.panel, "ServerName" + i ), file.Servers[i].Name)
		Hud_SetText( Hud_GetChild( file.panel, "Playlist" + i ), GetUIPlaylistName(file.Servers[i].Playlist))
		Hud_SetText( Hud_GetChild( file.panel, "Map" + i ), GetUIMapName(file.Servers[i].Map))
		Hud_SetText( Hud_GetChild( file.panel, "PlayerCount" + i ), file.Servers[i].currentplayers + "/" + file.Servers[i].maxplayers)
		Hud_SetVisible(Hud_GetChild( file.panel, "ServerButton" + i ), true)
	}

	// Select first server in the list
	SetSelectedServer(0, file.Servers[0].Name, file.Servers[0].Map, file.Servers[0].Playlist, file.Servers[0].Desc)

	// Set UI Labels
	Hud_SetText( Hud_GetChild( file.panel, "PlayersCount"), "Players: " + file.allplayers)
	Hud_SetText( Hud_GetChild( file.panel, "ServersCount"), "Servers: " + servercount)
	Hud_SetText (Hud_GetChild( file.panel, "Pages" ), "Page: 1/" + (file.pages + 1))
}

void function NextPage(var button)
{
	//If Pages is 0 then return
	//or if is on the last page
	if(file.pages == 0 || file.currentpage == file.pages )
		return

	// Reset Server Labels
	ResetServerLabels()

	// Set current page to next page
	file.currentpage++

	// If current page is greater then last page set to last page
	if(file.currentpage > file.pages)
		file.currentpage = file.pages

	// "startint" = starting server id
	int startint
	// "endint" = ending server id
	int endint
	if(file.currentpage == 0){
		startint = 0
		endint = SB_MAX_SERVER_PER_PAGE
		file.pageoffset = 0
	} else {
		startint = file.currentpage * SB_MAX_SERVER_PER_PAGE
		endint = startint + SB_MAX_SERVER_PER_PAGE
		file.pageoffset = file.currentpage * SB_MAX_SERVER_PER_PAGE
	}

	// Check if endint is greater then actual amount of servers
	if(endint > file.Servers.len())
		endint = file.Servers.len()

	// Set current page ui
	Hud_SetText(Hud_GetChild( file.panel, "Pages" ), "Page: " + (file.currentpage + 1) + "/" + (file.pages + 1))

	// "id" is diffrent from "i" and is used for setting UI elements
	// "i" is used for server id
	int id = 0
	for( int i=startint; i < endint; i++ ) {
		Hud_SetText( Hud_GetChild( file.panel, "ServerName" + id ), file.Servers[i].Name)
		Hud_SetText( Hud_GetChild( file.panel, "Playlist" + id ), GetUIPlaylistName(file.Servers[i].Playlist))
		Hud_SetText( Hud_GetChild( file.panel, "Map" + id ), GetUIMapName(file.Servers[i].Map))
		Hud_SetText( Hud_GetChild( file.panel, "PlayerCount" + id ), file.Servers[i].currentplayers + "/" + file.Servers[i].maxplayers)
		Hud_SetVisible(Hud_GetChild( file.panel, "ServerButton" + id ), true)
		id++
	}
}

void function PrevPage(var button)
{
	//If Pages is 0 then return
	//or if is one the first page
	if(file.pages == 0 || file.currentpage == 0)
		return

	// Reset Server Labels
	ResetServerLabels()

	// Set current page to prev page
	file.currentpage--

	// If current page is less then first page set to first page
	if(file.currentpage < 0)
		file.currentpage = 0

	// "startint" = starting server id
	int startint
	// "endint" = ending server id
	int endint
	if(file.currentpage == 0) {
		startint = 0
		endint = SB_MAX_SERVER_PER_PAGE
		file.pageoffset = 0
	} else {
		startint = file.currentpage * SB_MAX_SERVER_PER_PAGE
		endint = startint + SB_MAX_SERVER_PER_PAGE
		file.pageoffset = file.currentpage * SB_MAX_SERVER_PER_PAGE
	}

	// Check if endint is greater then actual amount of servers
	if(endint > file.Servers.len())
		endint = file.Servers.len()

	// Set current page ui
	Hud_SetText(Hud_GetChild( file.panel, "Pages" ), "Page: " + (file.currentpage + 1) + "/" + (file.pages + 1))

	// "id" is diffrent from "i" and is used for setting UI elements
	// "i" is used for server id
	int id = 0
	for( int i=startint; i < endint; i++ ) {
		Hud_SetText( Hud_GetChild( file.panel, "ServerName" + id ), file.Servers[i].Name)
		Hud_SetText( Hud_GetChild( file.panel, "Playlist" + id ), GetUIPlaylistName(file.Servers[i].Playlist))
		Hud_SetText( Hud_GetChild( file.panel, "Map" + id ), GetUIMapName(file.Servers[i].Map))
		Hud_SetText( Hud_GetChild( file.panel, "PlayerCount" + id ), file.Servers[i].currentplayers + "/" + file.Servers[i].maxplayers)
		Hud_SetVisible(Hud_GetChild( file.panel, "ServerButton" + id ), true)
		id++
	}
}

array<R5RServer> function GetServerArray(int servercount)
{
	array<R5RServer> Servers

	int serverrow = 0
	file.allplayers = 0

	// Add each server to the array
	for( int i=0; i < servercount; i++ ) {
		//Setup new server
		R5RServer new
		new.ServerID = i
		new.Name = GetServerName(i)
		new.Playlist = GetServerPlaylist(i)
		new.Map = GetServerMap(i)
		new.Desc = "Server description coming soon."
		new.maxplayers = 32
		new.currentplayers = 0
		//Add new server to array
		Servers.append(new)

		// If server is on final row add a new page
		if(serverrow == SB_MAX_SERVER_PER_PAGE)
		{
			file.pages++
			serverrow = 0
		}
		serverrow++

		// Add servers player count to all player count
		file.allplayers += 0
	}

	return Servers
}

void function ShowNoServersFound(bool show)
{
	//Set no servers found ui based on bool
	Hud_SetVisible(Hud_GetChild( file.panel, "PlayerCountLine" ), !show )
	Hud_SetVisible(Hud_GetChild( file.panel, "PlaylistLine" ), !show )
	Hud_SetVisible(Hud_GetChild( file.panel, "MapLine" ), !show )
	Hud_SetVisible(Hud_GetChild( file.panel, "NoServersLbl" ), show )
}

void function ResetServerLabels()
{
	//Hide all server buttons
	array<var> serverbuttons = GetElementsByClassname( file.menu, "ServBtn" )
	foreach ( var elem in serverbuttons )
	{
		Hud_SetVisible(elem, false)
	}

	//Clear all server labels
	array<var> serverlabels = GetElementsByClassname( file.menu, "ServerLabels" )
	foreach ( var elem in serverlabels )
	{
		Hud_SetText(elem, "")
	}
}

void function SetSelectedServer(int id, string name, string map, string playlist, string desc)
{
	//Set selected server info
	SelectedServerInfo.ServerID = id
	SelectedServerInfo.ServerName = name
	SelectedServerInfo.Map = map
	SelectedServerInfo.Playlist = playlist
	SelectedServerInfo.Desc = desc

	//Set selected server ui
	Hud_SetText(Hud_GetChild( file.panel, "ServerNameInfoEdit" ), name )
	Hud_SetText(Hud_GetChild( file.panel, "PlaylistInfoEdit" ), GetUIPlaylistName(playlist) )
	Hud_SetText(Hud_GetChild( file.panel, "ServerDesc" ), desc )
	RuiSetImage( Hud_GetRui( Hud_GetChild( file.panel, "ServerMapImg" ) ), "loadscreenImage", GetUIMapAsset(map) )
}

void function StartServerConnection()
{
	//Shutdown the lobby vm
	ShutdownHostGame()

	//Set the main menus blackscreen visibility to true
	SetMainMenuBlackScreenVisible(true)

	//wait for lobby vm to be actually shut down and back at the main menu
	while(!AtMainMenu) {
		WaitFrame()
	}

	//Connect to server
	SetEncKeyAndConnect(SelectedServerInfo.ServerID)

	//No longer at main menu
	AtMainMenu = false
}