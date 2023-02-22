untyped
// Only way to get Hud_GetPos(sliderButton) working was to use untyped

global function InitR5RServerBrowserPanel
global function InitR5RConnectingPanel

global function ServerBrowser_RefreshServerListing
global function RegisterServerBrowserButtonPressedCallbacks
global function UnRegisterServerBrowserButtonPressedCallbacks
global function ServerBrowser_UpdateFilterLists

global function MS_GetPlayerCount
global function MS_GetServerCount
global function Servers_GetActivePlaylists
global function Servers_GetCurrentServerListing

//Used for max items for page
//Changing this requires a bit of work to get more to show correctly
const SB_MAX_SERVER_PER_PAGE = 15

// Stores mouse delta used for scroll bar
struct {
	int deltaX = 0
	int deltaY = 0
} mouseDeltaBuffer

struct
{
	int Offset = 0
	int Start = 0
	int End = 0
} m_vScroll

//Struct for selected server
struct SelectedServerInfo
{
	int svServerID = -1
	string svServerName = ""
	string svMapName = ""
	string svPlaylist = ""
	string svDescription = ""
}

//Struct for server listing
global struct ServerListing
{
	int	svServerID
	string svServerName
	string svMapName
	string svPlaylist
	string svDescription
	int svMaxPlayers
	int svCurrentPlayers
}

struct {
	bool hideEmpty = false
	bool useSearch = false
	string searchTerm
	array<string> filterMaps
	string filterMap = "Any"
	array<string> filterGamemodes
	string filterGamemode = "Any"
} filterArguments

struct
{
	var menu
	var panel
	var connectingpanel

	int m_vAllPlayers
	int m_vAllServers

	SelectedServerInfo m_vSelectedServer
	array<ServerListing> m_vServerList
	array<ServerListing> m_vFilteredServerList
} file

global array<ServerListing> global_m_vServerList

void function InitR5RConnectingPanel( var panel )
{
	file.connectingpanel = panel
}

void function InitR5RServerBrowserPanel( var panel )
{
	file.panel = panel
	file.menu = GetParentMenu( file.panel )

	AddMouseMovementCaptureHandler( Hud_GetChild(file.panel, "MouseMovementCapture"), UpdateMouseDeltaBuffer )
	Hud_AddEventHandler( Hud_GetChild( file.panel, "ConnectButton" ), UIE_CLICK, ServerBrowser_ConnectBtnClicked )
	Hud_AddEventHandler( Hud_GetChild( file.panel, "RefreshServers" ), UIE_CLICK, ServerBrowser_RefreshBtnClicked )
	Hud_AddEventHandler( Hud_GetChild( file.panel, "ClearFliters" ), UIE_CLICK, ClearFilterServer_Activate )
	Hud_AddEventHandler( Hud_GetChild( file.panel, "BtnServerListDownArrow" ), UIE_CLICK, OnScrollDown )
	Hud_AddEventHandler( Hud_GetChild( file.panel, "BtnServerListUpArrow" ), UIE_CLICK, OnScrollUp )
	AddButtonEventHandler( Hud_GetChild( file.panel, "BtnServerSearch"), UIE_CHANGE, FilterServer_Activate )

	Hud_AddEventHandler( Hud_GetChild( Hud_GetChild( file.panel, "SwtBtnHideEmpty" ), "LeftButton" ), UIE_CLICK, FilterServer_Activate )
	Hud_AddEventHandler( Hud_GetChild( Hud_GetChild( file.panel, "SwtBtnHideEmpty" ), "RightButton" ), UIE_CLICK, FilterServer_Activate )
	Hud_AddEventHandler( Hud_GetChild( Hud_GetChild( file.panel, "SwtBtnSelectGamemode" ), "LeftButton" ), UIE_CLICK, FilterServer_Activate )
	Hud_AddEventHandler( Hud_GetChild( Hud_GetChild( file.panel, "SwtBtnSelectGamemode" ), "RightButton" ), UIE_CLICK, FilterServer_Activate )
	Hud_AddEventHandler( Hud_GetChild( Hud_GetChild( file.panel, "SwtBtnSelectMap" ), "LeftButton" ), UIE_CLICK, FilterServer_Activate )
	Hud_AddEventHandler( Hud_GetChild( Hud_GetChild( file.panel, "SwtBtnSelectMap" ), "RightButton" ), UIE_CLICK, FilterServer_Activate )

	foreach ( var elem in GetElementsByClassname( file.menu, "ServBtn" ) ) {
		RuiSetString( Hud_GetRui( elem ), "buttonText", "")
		Hud_AddEventHandler( elem, UIE_CLICK, ServerBrowser_ServerBtnClicked )
		Hud_AddEventHandler( elem, UIE_DOUBLECLICK, ServerBrowser_ServerBtnDoubleClicked )
	}
	
	ServerBrowser_UpdateSelectedServerUI()
	ServerBrowser_UpdateServerPlayerCount()
	ServerBrowser_NoServersFound(false)

	ServerBrowser_UpdateFilterLists()
	OnBtnFiltersClear()
}

void function RegisterServerBrowserButtonPressedCallbacks()
{
	RegisterButtonPressedCallback( MOUSE_WHEEL_UP , OnScrollUp )
	RegisterButtonPressedCallback( MOUSE_WHEEL_DOWN , OnScrollDown )
}

void function UnRegisterServerBrowserButtonPressedCallbacks()
{
	DeregisterButtonPressedCallback( MOUSE_WHEEL_UP , OnScrollUp )
	DeregisterButtonPressedCallback( MOUSE_WHEEL_DOWN , OnScrollDown )
}

////////////////////////////////////
//
//		Button Functions
//
////////////////////////////////////

void function ClearFilterServer_Activate(var button)
{
	OnBtnFiltersClear()
	thread ServerBrowser_FilterServerList()
}

void function FilterServer_Activate(var button)
{
	thread ServerBrowser_FilterServerList()
}

void function ServerBrowser_RefreshBtnClicked(var button)
{
	thread ServerBrowser_RefreshServerListing()
}

void function ServerBrowser_ConnectBtnClicked(var button)
{
	//If server isnt selected return
	if(file.m_vSelectedServer.svServerID == -1)
		return

	//Connect to server
	printf("Connecting to server: (Server ID: " + file.m_vSelectedServer.svServerID + " | Server Name: " + file.m_vSelectedServer.svServerName + " | Map: " + file.m_vSelectedServer.svMapName + " | Playlist: " + file.m_vSelectedServer.svPlaylist + ")")
	thread ServerBrowser_StartConnection(file.m_vSelectedServer.svServerID)
}

void function ServerBrowser_ServerBtnClicked(var button)
{
	//Get the button id and add it to the scroll offset to get the correct server id
	int id = Hud_GetScriptID( button ).tointeger() + m_vScroll.Offset
	ServerBrowser_SelectServer(file.m_vFilteredServerList[id].svServerID)
}

void function ServerBrowser_ServerBtnDoubleClicked(var button)
{
	//Get the button id and add it to the scroll offset to get the correct server id
	int id = Hud_GetScriptID( button ).tointeger() + m_vScroll.Offset
	ServerBrowser_SelectServer(file.m_vFilteredServerList[id].svServerID)
	thread ServerBrowser_StartConnection(id)
}

////////////////////////////////////
//
//		General Functions
//
////////////////////////////////////

void function ServerBrowser_StartConnection(int id)
{
	Hud_SetVisible(Hud_GetChild( file.menu, "R5RConnectingPanel"), true)
	Hud_SetText(Hud_GetChild( GetPanel( "R5RConnectingPanel" ), "ServerName" ), file.m_vServerList[id].svServerName )

	wait 2

	Hud_SetVisible(Hud_GetChild( file.menu, "R5RConnectingPanel"), false)
	ConnectToListedServer(id)
}

void function ServerBrowser_UpdateSelectedServerUI()
{
	Hud_SetText(Hud_GetChild( file.panel, "ServerCurrentPlaylist" ), "Current Playlist" )
	Hud_SetText(Hud_GetChild( file.panel, "ServerCurrentMap" ), "Current Map" )
	Hud_SetText(Hud_GetChild( file.panel, "ServerNameInfoEdit" ), file.m_vSelectedServer.svServerName )
	Hud_SetText(Hud_GetChild( file.panel, "ServerCurrentMapEdit" ), GetUIMapName(file.m_vSelectedServer.svMapName) )
	Hud_SetText(Hud_GetChild( file.panel, "PlaylistInfoEdit" ), GetUIPlaylistName(file.m_vSelectedServer.svPlaylist) )
	Hud_SetText(Hud_GetChild( file.panel, "ServerDesc" ), file.m_vSelectedServer.svDescription )
	RuiSetImage( Hud_GetRui( Hud_GetChild( file.panel, "ServerMapImg" ) ), "loadscreenImage", GetUIMapAsset(file.m_vSelectedServer.svMapName) )
}

void function ServerBrowser_NoServersLabel(bool show)
{
	//Set no servers found ui based on bool
	Hud_SetVisible(Hud_GetChild( file.panel, "PlayerCountLine" ), !show )
	Hud_SetVisible(Hud_GetChild( file.panel, "PlaylistLine" ), !show )
	Hud_SetVisible(Hud_GetChild( file.panel, "MapLine" ), !show )
	Hud_SetVisible(Hud_GetChild( file.panel, "NoServersLbl" ), show )
}

void function ServerBrowser_UpdateServerPlayerCount()
{
	Hud_SetText( Hud_GetChild( file.panel, "PlayersCount"), "Players: " + file.m_vAllPlayers)
	Hud_SetText( Hud_GetChild( file.panel, "ServersCount"), "Servers: " + file.m_vAllServers)
}

void function OnBtnFiltersClear()
{
	Hud_SetText( Hud_GetChild( file.panel, "BtnServerSearch" ), "" )
	filterArguments.useSearch = false
	filterArguments.searchTerm = ""
	filterArguments.filterGamemode = "Any"
	filterArguments.filterMap = "Any"
	filterArguments.hideEmpty = false

	SetConVarBool( "grx_hasUnknownItems", false )
	SetConVarInt( "match_rankedSwitchETA", 0 )
	SetConVarInt( "match_rankedMaxPing", 0 )
}

void function ServerBrowser_SelectServer(int id)
{
	if(file.m_vFilteredServerList.len() == 0)
		id = -1


	if(id == -1) {
		file.m_vSelectedServer.svServerID = -1
		file.m_vSelectedServer.svServerName = "Please select a server from the list"
		file.m_vSelectedServer.svMapName = "error"
		file.m_vSelectedServer.svPlaylist = "error"
		file.m_vSelectedServer.svDescription = ""
		ServerBrowser_UpdateSelectedServerUI()
		return
	}

	file.m_vSelectedServer.svServerID = file.m_vServerList[id].svServerID
	file.m_vSelectedServer.svServerName = file.m_vServerList[id].svServerName
	file.m_vSelectedServer.svMapName = file.m_vServerList[id].svMapName
	file.m_vSelectedServer.svPlaylist = file.m_vServerList[id].svPlaylist
	file.m_vSelectedServer.svDescription = file.m_vServerList[id].svDescription
	ServerBrowser_UpdateSelectedServerUI()
}

void function ServerBrowser_ResetLabels()
{
	//Hide all server buttons
	array<var> serverbuttons = GetElementsByClassname( file.menu, "ServBtn" )
	foreach ( var elem in serverbuttons )
		Hud_SetVisible(elem, false)

	//Clear all server labels
	array<var> serverlabels = GetElementsByClassname( file.menu, "ServerLabels" )
	foreach ( var elem in serverlabels )
		Hud_SetText(elem, "")
}

void function ServerBrowser_NoServersFound(bool showlabel)
{
	ServerBrowser_NoServersLabel(showlabel)
	ServerBrowser_SelectServer(-1)
	ServerBrowser_ResetLabels()

	if(showlabel)
		Hud_SetText( Hud_GetChild( file.panel, "PlayersCount"), "Players: 0")
		Hud_SetText( Hud_GetChild( file.panel, "ServersCount"), "Servers: 0")
}

////////////////////////////////////
//
//		ServerListing Functions
//
////////////////////////////////////

void function ServerBrowser_RefreshServerListing(bool refresh = true)
{
	if (refresh)
		RefreshServerList()

	file.m_vServerList.clear()

	// Add each server to the array
	for (int i=0, j=GetServerCount(); i < j; i++) {
		ServerListing Server
		Server.svServerID = i
		Server.svServerName = GetServerName(i)
		Server.svPlaylist = GetServerPlaylist(i)
		Server.svMapName = GetServerMap(i)
		Server.svDescription = GetServerDescription(i)
		Server.svMaxPlayers = GetServerMaxPlayers(i)
		Server.svCurrentPlayers = GetServerCurrentPlayers(i)
		file.m_vServerList.append(Server)
	}

	thread ServerBrowser_FilterServerList()
}

void function ServerBrowser_FilterServerList()
{
	if(!IsLobby())
		return

	ServerBrowser_UpdateFilterLists()
	
	//Must wait for convars to actually set
	wait 0.1

	ServerBrowser_NoServersFound(false)

	m_vScroll.Offset = 0
	file.m_vAllPlayers = 0

	filterArguments.hideEmpty = GetConVarBool( "grx_hasUnknownItems" )
	filterArguments.filterMap = filterArguments.filterMaps[GetConVarInt( "match_rankedMaxPing" )]
	filterArguments.filterGamemode = filterArguments.filterGamemodes[GetConVarInt( "match_rankedSwitchETA" )]
	filterArguments.searchTerm = Hud_GetUTF8Text( Hud_GetChild( file.panel, "BtnServerSearch" ) )
	filterArguments.useSearch = filterArguments.searchTerm != ""

	file.m_vFilteredServerList.clear()
	for ( int i = 0, j = file.m_vServerList.len(); i < j; i++ )
	{
		// Filters
		if ( filterArguments.hideEmpty && file.m_vServerList[i].svCurrentPlayers == 0 )
			continue;

		if ( filterArguments.filterMap != "Any" && filterArguments.filterMap != file.m_vServerList[i].svMapName )
			continue;

		if ( filterArguments.filterGamemode != "Any" && filterArguments.filterGamemode != file.m_vServerList[i].svPlaylist )
			continue;
		
		// Search
		if ( filterArguments.useSearch )
		{	
			array<string> sName
			sName.append( file.m_vServerList[i].svServerName.tolower() )
			sName.append( file.m_vServerList[i].svMapName.tolower() )
			sName.append( GetUIMapName(file.m_vServerList[i].svMapName).tolower() )
			sName.append( file.m_vServerList[i].svPlaylist.tolower() )
			sName.append( GetUIPlaylistName(file.m_vServerList[i].svPlaylist).tolower() )

			string sTerm = filterArguments.searchTerm.tolower()
			
			bool found = false
			for( int l = 0, k = sName.len(); l < k; l++ )
				if ( sName[l].find( sTerm ) >= 0 )
					found = true
			
			if ( !found )
				continue;
		}
		
		// Server fits our requirements, add it to the list
		file.m_vFilteredServerList.append(file.m_vServerList[i])
	}
	
	// Get Server Count
	file.m_vAllServers = file.m_vFilteredServerList.len()

	// If no servers then set no servers found ui and return
	if(file.m_vAllServers == 0) {
		ServerBrowser_NoServersFound(true)
		return
	}

	// Setup Buttons and labels
	for( int i=0, j=file.m_vAllServers, l=SB_MAX_SERVER_PER_PAGE; i < j && i < l; i++ )
	{
		Hud_SetText( Hud_GetChild( file.panel, "ServerName" + i ), file.m_vFilteredServerList[i].svServerName)
		Hud_SetText( Hud_GetChild( file.panel, "Playlist" + i ), GetUIPlaylistName(file.m_vFilteredServerList[i].svPlaylist))
		Hud_SetText( Hud_GetChild( file.panel, "Map" + i ), GetUIMapName(file.m_vFilteredServerList[i].svMapName))
		Hud_SetText( Hud_GetChild( file.panel, "PlayerCount" + i ), file.m_vFilteredServerList[i].svCurrentPlayers + "/" + file.m_vFilteredServerList[i].svMaxPlayers)
		Hud_SetVisible(Hud_GetChild( file.panel, "ServerButton" + i ), true)
		file.m_vAllPlayers += file.m_vFilteredServerList[i].svCurrentPlayers
	}

	UpdateListSliderHeight( float( file.m_vFilteredServerList.len() ) )
	UpdateListSliderPosition( file.m_vFilteredServerList.len() )
	ServerBrowser_SelectServer(file.m_vFilteredServerList[0].svServerID)
	ServerBrowser_UpdateServerPlayerCount()
}

void function ServerBrowser_UpdateFilterLists()
{
	if(!IsLobby())
		return

	if(Hud_GetDialogListItemCount(Hud_GetChild( file.panel, "SwtBtnSelectMap" )) == 0)
	{
		array<string> maps = ["Any"]
		maps.extend(GetAvailableMaps())
		filterArguments.filterMaps = maps
		foreach ( int id, string map in maps )
			Hud_DialogList_AddListItem( Hud_GetChild( file.panel, "SwtBtnSelectMap" ) , map, string( id ) )
	}

	if(Hud_GetDialogListItemCount(Hud_GetChild( file.panel, "SwtBtnSelectGamemode" )) == 0)
	{
		array<string> playlists = ["Any"]
		playlists.extend(GetVisiblePlaylists())
		filterArguments.filterGamemodes = playlists
		foreach( int id, string mode in playlists )
			Hud_DialogList_AddListItem( Hud_GetChild( file.panel, "SwtBtnSelectGamemode" ) , mode, string( id ) )
	}
}

////////////////////////////////////
//
//		Scrolling
//
////////////////////////////////////

//Used scroll code from northstar.
void function OnScrollDown( var button )
{
	m_vScroll.Offset += 1
	if (m_vScroll.Offset + SB_MAX_SERVER_PER_PAGE > file.m_vFilteredServerList.len())
		m_vScroll.Offset = file.m_vFilteredServerList.len() - SB_MAX_SERVER_PER_PAGE

	if ( m_vScroll.Offset < 0 )
		m_vScroll.Offset = 0

	UpdateShownPage()
	UpdateListSliderPosition( file.m_vFilteredServerList.len() )
}

void function OnScrollUp( var button )
{
	m_vScroll.Offset -= 1
	if ( m_vScroll.Offset < 0 )
		m_vScroll.Offset = 0

	UpdateShownPage()
	UpdateListSliderPosition( file.m_vFilteredServerList.len() )
}

void function UpdateShownPage()
{
	if(file.m_vFilteredServerList.len() == 0)
		return

	// Reset Server Labels
	ServerBrowser_ResetLabels()

	m_vScroll.End = m_vScroll.Offset + SB_MAX_SERVER_PER_PAGE

	if(file.m_vFilteredServerList.len() < SB_MAX_SERVER_PER_PAGE)
		m_vScroll.End = file.m_vFilteredServerList.len()

	for( int i=m_vScroll.Offset, id=0; i < m_vScroll.End; i++, id++ ) {
		Hud_SetText( Hud_GetChild( file.panel, "ServerName" + id ), file.m_vFilteredServerList[i].svServerName)
		Hud_SetText( Hud_GetChild( file.panel, "Playlist" + id ), GetUIPlaylistName(file.m_vFilteredServerList[i].svPlaylist))
		Hud_SetText( Hud_GetChild( file.panel, "Map" + id ), GetUIMapName(file.m_vFilteredServerList[i].svMapName))
		Hud_SetText( Hud_GetChild( file.panel, "PlayerCount" + id ), file.m_vFilteredServerList[i].svCurrentPlayers + "/" + file.m_vFilteredServerList[i].svMaxPlayers)
		Hud_SetVisible(Hud_GetChild( file.panel, "ServerButton" + id ), true)
	}

	UpdateListSliderHeight( float( file.m_vFilteredServerList.len() ) )
}

void function UpdateListSliderPosition( int servers )
{
	var sliderButton = Hud_GetChild( file.panel , "BtnServerListSlider" )
	var sliderPanel = Hud_GetChild( file.panel , "BtnServerListSliderPanel" )
	var movementCapture = Hud_GetChild( file.panel , "MouseMovementCapture" )

	float minYPos = 0.0 * ( GetScreenSize().height / 1080.0 )
	float useableSpace = (550.0 * ( GetScreenSize().height / 1080.0 ) - Hud_GetHeight( sliderPanel ) )

	float jump = minYPos - ( useableSpace / ( float( servers ) - SB_MAX_SERVER_PER_PAGE ) * m_vScroll.Offset )

	if ( jump > minYPos ) jump = minYPos

	Hud_SetPos( sliderButton , 2, jump )
	Hud_SetPos( sliderPanel , 2, jump )
	Hud_SetPos( movementCapture , 2, jump )
}


void function UpdateListSliderHeight( float servers )
{
	var sliderButton = Hud_GetChild( file.panel , "BtnServerListSlider" )
	var sliderPanel = Hud_GetChild( file.panel , "BtnServerListSliderPanel" )
	var movementCapture = Hud_GetChild( file.panel , "MouseMovementCapture" )

	float maxHeight = 550.0 * ( GetScreenSize().height / 1080.0 )
	float minHeight = 80.0 * ( GetScreenSize().height / 1080.0 )

	float height = maxHeight * ( SB_MAX_SERVER_PER_PAGE / servers )

	if ( height > maxHeight ) height = maxHeight
	if ( height < minHeight ) height = minHeight

	Hud_SetHeight( sliderButton , height )
	Hud_SetHeight( sliderPanel , height )
	Hud_SetHeight( movementCapture , height )
}

void function UpdateMouseDeltaBuffer( int x, int y )
{
	mouseDeltaBuffer.deltaX += x
	mouseDeltaBuffer.deltaY += y

	SliderBarUpdate()
}

void function FlushMouseDeltaBuffer()
{
	mouseDeltaBuffer.deltaX = 0
	mouseDeltaBuffer.deltaY = 0
}


void function SliderBarUpdate()
{
	if ( file.m_vFilteredServerList.len() <= SB_MAX_SERVER_PER_PAGE ) {
		FlushMouseDeltaBuffer()
		return
	}

	var sliderButton = Hud_GetChild( file.panel , "BtnServerListSlider" )
	var sliderPanel = Hud_GetChild( file.panel , "BtnServerListSliderPanel" )
	var movementCapture = Hud_GetChild( file.panel , "MouseMovementCapture" )

	Hud_SetFocused( sliderButton )

	float minYPos = 0.0 * ( GetScreenSize().height / 1080.0 )
	float maxHeight = 550.0  * ( GetScreenSize().height / 1080.0 )
	float maxYPos = minYPos - ( maxHeight - Hud_GetHeight( sliderPanel ) )
	float useableSpace = ( maxHeight - Hud_GetHeight( sliderPanel ) )

	float jump = minYPos - ( useableSpace / ( float( file.m_vFilteredServerList.len() ) ) )

	// got local from official respaw scripts, without untyped throws an error
	local pos =	Hud_GetPos( sliderButton )[1]
	local newPos = pos - mouseDeltaBuffer.deltaY
	FlushMouseDeltaBuffer()

	if ( newPos < maxYPos ) newPos = maxYPos
	if ( newPos > minYPos ) newPos = minYPos

	Hud_SetPos( sliderButton , 2, newPos )
	Hud_SetPos( sliderPanel , 2, newPos )
	Hud_SetPos( movementCapture , 2, newPos )

	m_vScroll.Offset = -int( ( ( newPos - minYPos ) / useableSpace ) * ( file.m_vFilteredServerList.len() - SB_MAX_SERVER_PER_PAGE ) )
	UpdateShownPage()
}

int function MS_GetPlayerCount()
{
	if(file.m_vServerList.len() == 0)
		ServerBrowser_RefreshServerListing()

	int count = 0
	for (int i=0, j=GetServerCount(); i < j; i++) {
		count += GetServerCurrentPlayers(i)
	}

	return count
}

int function MS_GetServerCount()
{
	if(file.m_vServerList.len() == 0)
		ServerBrowser_RefreshServerListing()

	return file.m_vServerList.len()
}

array<string> function Servers_GetActivePlaylists()
{
	if(file.m_vServerList.len() == 0)
		ServerBrowser_RefreshServerListing()

	array<string> playlists

	for (int i=0, j=GetServerCount(); i < j; i++) {
		string playlist = GetServerPlaylist(i)
		if (!playlists.contains(playlist))
			playlists.append(playlist)
	}

	return playlists
}

void function Servers_GetCurrentServerListing()
{
	if(file.m_vServerList.len() == 0)
		ServerBrowser_RefreshServerListing()

	global_m_vServerList = file.m_vServerList
}

array<string> function GetVisiblePlaylists()
{
	array<string> m_vPlaylists

	//Setup available playlists array
	foreach( string playlist in GetAvailablePlaylists())
	{
		//Check playlist visibility
		if(!GetPlaylistVarBool( playlist, "visible", false ))
			continue

		//Add playlist to the array
		m_vPlaylists.append(playlist)
	}

	return m_vPlaylists
}