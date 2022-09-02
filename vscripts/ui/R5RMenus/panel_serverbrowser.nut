global function InitR5RServerBrowserPanel
global function RefreshServerListing

//Used for max items for page
//Changing this requires a bit of work to get more to show correctly
//So keep at 19
global const SB_MAX_SERVER_PER_PAGE = 19

struct
{
	var menu
	var panel
} file

//Struct for page system
struct
{
	int pAmount
	int pCurrent
	int pOffset
	int pStart
	int pEnd
} m_vPages

//Struct for selected server
struct SelectedServerInfo
{
	int svServerID = -1
	string svServerName = ""
	string svMapName = ""
	string svPlaylist = ""
	string svDescription
}

//Struct for server listing
struct ServerListing
{
	int	svServerID
	string svServerName
	string svMapName
	string svPlaylist
	string svDescription
	int svMaxPlayers
	int svCurrentPlayers
}

//Array for server listing
array<ServerListing> m_vServerList
//Used for what server you selected
SelectedServerInfo m_vSelectedServer
//Used for all player count
int m_vAllPlayers

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
	foreach ( var elem in serverbuttons ) {
		RuiSetString( Hud_GetRui( elem ), "buttonText", "")
		Hud_AddEventHandler( elem, UIE_CLICK, SelectServer )
	}

	//Reset Server Panel
	ShowNoServersFound(false)
	SetSelectedServer(-1, "", "", "", "")
	ResetServerLabels()

	// Set servercount, playercount, pages to none
	Hud_SetText( Hud_GetChild( file.panel, "PlayersCount"), "Players: 0")
	Hud_SetText( Hud_GetChild( file.panel, "ServersCount"), "Servers: 0")
	Hud_SetText (Hud_GetChild( file.panel, "Pages" ), "  Page: 0/0  ")

	Hud_SetText(Hud_GetChild( file.panel, "ServerCurrentPlaylist" ), "" )
	Hud_SetText(Hud_GetChild( file.panel, "ServerCurrentMap" ), "" )
}

void function RefreshServersClick(var button)
{
	//Refresh Server Browser
	RefreshServerListing()
}

void function ConnectToServer(var button)
{
	//If server isnt selected return
	if(m_vSelectedServer.svServerID == -1)
		return

	//Connect to server
	printf("Connecting to server: (Server ID: " + m_vSelectedServer.svServerID + " | Server Name: " + m_vSelectedServer.svServerName + " | Map: " + m_vSelectedServer.svMapName + " | Playlist: " + m_vSelectedServer.svPlaylist + ")")
	SetEncKeyAndConnect(m_vSelectedServer.svServerID)
}

void function SelectServer(var button)
{
	//Get the button id and add it to the pageoffset to get the correct server id
	int finalid = Hud_GetScriptID( button ).tointeger() + m_vPages.pOffset

	SetSelectedServer(finalid, m_vServerList[finalid].svServerName, m_vServerList[finalid].svMapName, m_vServerList[finalid].svPlaylist, m_vServerList[finalid].svDescription)
}

void function RefreshServerListing(bool refresh = true)
{
	if (refresh)
		RefreshServerList()

	//Clear Server List Text, Hide no servers found ui, Reset pages
	ResetServerLabels()
	ShowNoServersFound(false)
	m_vPages.pAmount = 0

	// Get Server Count
	int svServerCount = GetServerCount()

	// If no servers then set no servers found ui and return
	if(svServerCount == 0) {
		// Show no servers found ui
		ShowNoServersFound(true)

		// Set selected server to none
		SetSelectedServer(-1, "", "", "", "")

		// Set servercount, playercount, pages to none
		Hud_SetText( Hud_GetChild( file.panel, "PlayersCount"), "Players: 0")
		Hud_SetText( Hud_GetChild( file.panel, "ServersCount"), "Servers: 0")
		Hud_SetText (Hud_GetChild( file.panel, "Pages" ), "  Page: 0/0  ")

		// Return as it dosnt need togo past this if no servers are found
		return
	}

	// Get Server Array
	m_vServerList = GetServerArray(svServerCount)

	// Setup Buttons and labels
	for( int i=0; i < m_vServerList.len() && i < SB_MAX_SERVER_PER_PAGE; i++ )
	{
		Hud_SetText( Hud_GetChild( file.panel, "ServerName" + i ), m_vServerList[i].svServerName)
		Hud_SetText( Hud_GetChild( file.panel, "Playlist" + i ), GetUIPlaylistName(m_vServerList[i].svPlaylist))
		Hud_SetText( Hud_GetChild( file.panel, "Map" + i ), GetUIMapName(m_vServerList[i].svMapName))
		Hud_SetText( Hud_GetChild( file.panel, "PlayerCount" + i ), m_vServerList[i].svCurrentPlayers + "/" + m_vServerList[i].svMaxPlayers)
		Hud_SetVisible(Hud_GetChild( file.panel, "ServerButton" + i ), true)
	}

	// Select first server in the list
	SetSelectedServer(0, m_vServerList[0].svServerName, m_vServerList[0].svMapName, m_vServerList[0].svPlaylist, m_vServerList[0].svDescription)

	// Set UI Labels
	Hud_SetText( Hud_GetChild( file.panel, "PlayersCount"), "Players: " + m_vAllPlayers)
	Hud_SetText( Hud_GetChild( file.panel, "ServersCount"), "Servers: " + svServerCount)
	Hud_SetText (Hud_GetChild( file.panel, "Pages" ), "  Page: 1/" + (m_vPages.pAmount + 1) + "  ")
}

void function NextPage(var button)
{
	//If Pages is 0 then return
	//or if is on the last page
	if(m_vPages.pAmount == 0 || m_vPages.pCurrent == m_vPages.pAmount )
		return

	// Reset Server Labels
	ResetServerLabels()

	// Set current page to next page
	m_vPages.pCurrent++

	// If current page is greater then last page set to last page
	if(m_vPages.pCurrent > m_vPages.pAmount)
		m_vPages.pCurrent = m_vPages.pAmount

	//Set Start ID / End ID / and ID Offset
	m_vPages.pStart = m_vPages.pCurrent * SB_MAX_SERVER_PER_PAGE
	m_vPages.pEnd = m_vPages.pStart + SB_MAX_SERVER_PER_PAGE
	m_vPages.pOffset = m_vPages.pCurrent * SB_MAX_SERVER_PER_PAGE

	// Check if m_vPages.pEnd is greater then actual amount of servers
	if(m_vPages.pEnd > m_vServerList.len())
		m_vPages.pEnd = m_vServerList.len()

	// Set current page ui
	Hud_SetText(Hud_GetChild( file.panel, "Pages" ), "  Page:" + (m_vPages.pCurrent + 1) + "/" + (m_vPages.pAmount + 1) + "  ")

	// "id" is diffrent from "i" and is used for setting UI elements
	// "i" is used for server id
	int id = 0
	for( int i=m_vPages.pStart; i < m_vPages.pEnd; i++ ) {
		Hud_SetText( Hud_GetChild( file.panel, "ServerName" + id ), m_vServerList[i].svServerName)
		Hud_SetText( Hud_GetChild( file.panel, "Playlist" + id ), GetUIPlaylistName(m_vServerList[i].svPlaylist))
		Hud_SetText( Hud_GetChild( file.panel, "Map" + id ), GetUIMapName(m_vServerList[i].svMapName))
		Hud_SetText( Hud_GetChild( file.panel, "PlayerCount" + id ), m_vServerList[i].svCurrentPlayers + "/" + m_vServerList[i].svMaxPlayers)
		Hud_SetVisible(Hud_GetChild( file.panel, "ServerButton" + id ), true)
		id++
	}
}

void function PrevPage(var button)
{
	//If Pages is 0 then return
	//or if is one the first page
	if(m_vPages.pAmount == 0 || m_vPages.pCurrent == 0)
		return

	// Reset Server Labels
	ResetServerLabels()

	// Set current page to prev page
	m_vPages.pCurrent--

	// If current page is less then first page set to first page
	if(m_vPages.pCurrent < 0)
		m_vPages.pCurrent = 0

	//Set Start ID / End ID / and ID Offset
	m_vPages.pStart = m_vPages.pCurrent * SB_MAX_SERVER_PER_PAGE
	m_vPages.pEnd = m_vPages.pStart + SB_MAX_SERVER_PER_PAGE
	m_vPages.pOffset = m_vPages.pCurrent * SB_MAX_SERVER_PER_PAGE

	// Check if m_vPages.pEnd is greater then actual amount of servers
	if(m_vPages.pEnd > m_vServerList.len())
		m_vPages.pEnd = m_vServerList.len()

	// Set current page ui
	Hud_SetText(Hud_GetChild( file.panel, "Pages" ), "  Page:" + (m_vPages.pCurrent + 1) + "/" + (m_vPages.pAmount + 1) + "  ")

	// "id" is diffrent from "i" and is used for setting UI elements
	// "i" is used for server id
	int id = 0
	for( int i=m_vPages.pStart; i < m_vPages.pEnd; i++ ) {
		Hud_SetText( Hud_GetChild( file.panel, "ServerName" + id ), m_vServerList[i].svServerName)
		Hud_SetText( Hud_GetChild( file.panel, "Playlist" + id ), GetUIPlaylistName(m_vServerList[i].svPlaylist))
		Hud_SetText( Hud_GetChild( file.panel, "Map" + id ), GetUIMapName(m_vServerList[i].svMapName))
		Hud_SetText( Hud_GetChild( file.panel, "PlayerCount" + id ), m_vServerList[i].svCurrentPlayers + "/" + m_vServerList[i].svMaxPlayers)
		Hud_SetVisible(Hud_GetChild( file.panel, "ServerButton" + id ), true)
		id++
	}
}

array<ServerListing> function GetServerArray(int svServerCount)
{
	//Create array for servers to be returned
	array<ServerListing> ServerList

	//No servers so just return
	if(svServerCount == 0)
		return ServerList

	//Set on first row
	int m_vCurrentRow = 0

	//Reset all players count
	m_vAllPlayers = 0
	// Add each server to the array
	for( int i=0; i < svServerCount; i++ ) {
		//Add Server to array
		AddServerToArray(i, GetServerName(i), GetServerPlaylist(i), GetServerMap(i), GetServerDescription(i), GetServerMaxPlayers(i), GetServerCurrentPlayers(i), ServerList)

		// If server is on final row add a new page
		if(m_vCurrentRow == SB_MAX_SERVER_PER_PAGE) {
			m_vPages.pAmount++
			m_vCurrentRow = 0
		}
		m_vCurrentRow++

		// Add servers player count to all player count
		m_vAllPlayers += 0
	}

	//Return Server Listing
	return ServerList
}

void function AddServerToArray(int id, string name, string playlist, string map, string desc, int max, int current, array<ServerListing> ServerList)
{
	//Setup new server
	ServerListing Server
	Server.svServerID = id
	Server.svServerName = name
	Server.svPlaylist = playlist
	Server.svMapName = map
	Server.svDescription = desc
	Server.svMaxPlayers = max
	Server.svCurrentPlayers = current

	//Add new server to array
	ServerList.append(Server)
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
	m_vSelectedServer.svServerID = id
	m_vSelectedServer.svServerName = name
	m_vSelectedServer.svMapName = map
	m_vSelectedServer.svPlaylist = playlist
	m_vSelectedServer.svDescription = desc

	//Set selected server ui
	Hud_SetText(Hud_GetChild( file.panel, "ServerCurrentPlaylist" ), "Current Playlist" )
	Hud_SetText(Hud_GetChild( file.panel, "ServerCurrentMap" ), "Current Map" )

	Hud_SetText(Hud_GetChild( file.panel, "ServerNameInfoEdit" ), name )
	Hud_SetText(Hud_GetChild( file.panel, "ServerCurrentMapEdit" ), GetUIMapName(map) )
	Hud_SetText(Hud_GetChild( file.panel, "PlaylistInfoEdit" ), GetUIPlaylistName(playlist) )
	Hud_SetText(Hud_GetChild( file.panel, "ServerDesc" ), desc )
	RuiSetImage( Hud_GetRui( Hud_GetChild( file.panel, "ServerMapImg" ) ), "loadscreenImage", GetUIMapAsset(map) )
}