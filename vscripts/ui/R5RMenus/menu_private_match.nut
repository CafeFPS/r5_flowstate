global function InitR5RPrivateMatchMenu
global function InitR5RNamePanel
global function InitR5RDescPanel
global function InitR5RKickPanel
global function InitR5RStartingPanel

global function SetSelectedServerMap
global function SetSelectedServerPlaylist
global function SetSelectedServerVis

global function UpdatePlayersList
global function AddPlayerToUIArray
global function ClearPlayerUIArray
global function EnableCreateMatchUI
global function UI_SetServerInfo
global function UpdateHostName
global function ShowMatchStartingScreen
global function PrivateMatchMenuOpened

struct
{
	var menu
    var listPanel

    var namepanel
	var descpanel
    var kickpanel
    var startingpanel

	array<var> panels

    string tempservername
    string tempserverdesc
    string tempplayertokick

    bool inputsRegistered = false
    bool startingmatch = false

    var realMenu
} file

global struct privatematchmenusopen
{
    bool maps_open = false
    bool playlists_open = false
    bool vis_open = false
    bool name_open = false
    bool desc_open = false
    bool kick_open = false
}

struct PM_PlayerData
{
    string name
}

array<PM_PlayerData> playerdata

global struct ServerStruct
{
	string svServerName
	string svServerDesc
	string svMapName
	string svPlaylist
	int svVisibility
}

global ServerStruct ServerSettings
global privatematchmenusopen PMMenusOpen

global string server_host_name = ""

void function InitR5RNamePanel( var panel )
{
	file.namepanel = panel

	AddButtonEventHandler( Hud_GetChild( panel, "BtnSaveName"), UIE_CLICK, UpdateServerName )
	AddButtonEventHandler( Hud_GetChild( panel, "BtnServerName"), UIE_CHANGE, TempSaveNameChanges )
}

void function UpdateServerName( var button )
{
    ServerSettings.svServerName = file.tempservername
    RunClientScript("UICodeCallback_UpdateServerInfo", 0, file.tempservername)

    Hud_SetVisible( file.namepanel, false )

    PMMenusOpen.name_open = false
}

void function TempSaveNameChanges( var button )
{
	file.tempservername = Hud_GetUTF8Text( Hud_GetChild( file.namepanel, "BtnServerName" ) )
}

void function InitR5RDescPanel( var panel )
{
	file.descpanel = panel

	AddButtonEventHandler( Hud_GetChild( panel, "BtnSaveDesc"), UIE_CLICK, UpdateServerDesc )
	AddButtonEventHandler( Hud_GetChild( panel, "BtnServerDesc"), UIE_CHANGE, TempSaveDescChanges )
}

void function UpdateServerDesc( var button )
{
    ServerSettings.svServerDesc = file.tempserverdesc

	Hud_SetVisible( file.descpanel, false )

    PMMenusOpen.desc_open = false
}

void function TempSaveDescChanges( var button )
{
	file.tempserverdesc = Hud_GetUTF8Text( Hud_GetChild( file.descpanel, "BtnServerDesc" ) )
}

void function InitR5RKickPanel( var panel )
{
	file.kickpanel = panel

	AddButtonEventHandler( Hud_GetChild( panel, "BtnKick"), UIE_CLICK, KickOrBanPlayer )
    AddButtonEventHandler( Hud_GetChild( panel, "BtnBan"), UIE_CLICK, KickOrBanPlayer )
	AddButtonEventHandler( Hud_GetChild( panel, "BtnCancel"), UIE_CLICK, DontKickOrBanPlayer )
}

void function KickOrBanPlayer(var button)
{
    RunClientScript("UICodeCallback_KickOrBanPlayer", Hud_GetScriptID( button ).tointeger(), file.tempplayertokick)

    Hud_SetVisible( file.kickpanel, false )

    PMMenusOpen.kick_open = false
    file.tempplayertokick = ""
}

void function InitR5RStartingPanel( var panel )
{
	file.startingpanel = panel
}

void function DontKickOrBanPlayer(var button)
{
    Hud_SetVisible( file.kickpanel, false )

    PMMenusOpen.kick_open = false
    file.tempplayertokick = ""
}

void function InitR5RPrivateMatchMenu( var panel )
{
    var menu = panel
	file.menu = panel

    file.realMenu = GetParentMenu( menu )

    file.listPanel = Hud_GetChild( menu, "PlayerList" )

    //Setup Button EventHandlers
	Hud_AddEventHandler( Hud_GetChild( file.menu, "BtnStartGame" ), UIE_CLICK, StartNewGame )
	
    array<var> buttons = GetElementsByClassname( file.realMenu, "createserverbuttons" )
	foreach ( var elem in buttons ) {
		Hud_AddEventHandler( elem, UIE_CLICK, OpenSelectedPanel )
	}

	//Setup panel array
	file.panels.append(Hud_GetChild(menu, "R5RMapPanel"))
	file.panels.append(Hud_GetChild(menu, "R5RPlaylistPanel"))
	file.panels.append(Hud_GetChild(menu, "R5RVisPanel"))
	file.panels.append(Hud_GetChild(file.realMenu, "R5RNamePanel"))
	file.panels.append(Hud_GetChild(file.realMenu, "R5RDescPanel"))
}

void function OpenSelectedPanel( var button )
{
    //Refresh Maps
    RefreshUIMaps()
    RefreshUIPlaylists()

	//Show panel depending on script id
	ShowSelectedPanel( file.panels[Hud_GetScriptID( button ).tointeger()] )

    switch (Hud_GetScriptID( button ).tointeger())
    {
        case 0:
                PMMenusOpen.maps_open = true
            break;
        case 1:
                PMMenusOpen.playlists_open = true
            break;
        case 2:
                PMMenusOpen.vis_open = true
            break;
        case 3:
                PMMenusOpen.name_open = true
                Hud_SetText( Hud_GetChild( file.namepanel, "BtnServerName" ), ServerSettings.svServerName )
            break;
        case 4:
                PMMenusOpen.desc_open = true
                Hud_SetText( Hud_GetChild( file.descpanel, "BtnServerDesc" ), ServerSettings.svServerDesc )
            break;
        
    }
}

void function StartNewGame( var button )
{
    RunClientScript("UICallback_StartMatch")
	//CreateServer(ServerSettings.svServerName, ServerSettings.svServerDesc, ServerSettings.svMapName, ServerSettings.svPlaylist, ServerSettings.svVisibility)
}

void function SetSelectedServerMap( string map )
{
	ServerSettings.svMapName = map

    RunClientScript("UICodeCallback_UpdateServerInfo", 1, map)
	Hud_SetVisible( file.panels[0], false )

    PMMenusOpen.maps_open = false
}

void function SetSelectedServerPlaylist( string playlist )
{
	ServerSettings.svPlaylist = playlist

    RunClientScript("UICodeCallback_UpdateServerInfo", 2, playlist)

    array<string> playlist_maps = GetPlaylistMaps(ServerSettings.svPlaylist)
	//This should ever really be triggered but here just incase
	if(playlist_maps.len() == 0) {
		SetSelectedServerMap("mp_rr_canyonlands_64k_x_64k")
        RefreshUIMaps()
		return
	}

	//Check to see if the current map is allowed on the new selected playlist
	if(!playlist_maps.contains(ServerSettings.svMapName))
		SetSelectedServerMap(playlist_maps[0])

    RefreshUIMaps()
    Hud_SetVisible( file.panels[1], false )

    PMMenusOpen.playlists_open = false
}

void function SetSelectedServerVis( int vis )
{
    ServerSettings.svVisibility = vis

    RunClientScript("UICodeCallback_UpdateServerInfo", 3, vis.tostring())
	Hud_SetVisible( file.panels[2], false )

    PMMenusOpen.vis_open = false
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

void function PrivateMatchMenuOpened()
{

    array<var> privatematchui = GetElementsByClassname( file.realMenu, "CreateServerUI" )
	foreach ( var elem in privatematchui ) {
		Hud_SetVisible(elem, false)
	}

    array<var> buttons = GetElementsByClassname( file.realMenu, "createserverbuttons" )
	foreach ( var elem in buttons ) {
		Hud_SetVisible(elem, false)
	}

    Hud_SetVisible(Hud_GetChild( file.menu, "HostSettingUpGamePanel" ), true)
    Hud_SetVisible(Hud_GetChild( file.menu, "HostSettingUpGamePanelText" ), true)
    Hud_SetVisible( file.startingpanel, false )

    if(!file.startingmatch)
        RunClientScript("ServerCallback_LobbyVM_UpdateUI")
    else
        UpdatePlayersList()

	g_isAtMainMenu = false
}

/////////////////////////////////////////////////////
//
//   Client to UI
//
/////////////////////////////////////////////////////

void function EnableCreateMatchUI()
{
    array<var> privatematchui = GetElementsByClassname( file.realMenu, "CreateServerUI" )
	foreach ( var elem in privatematchui )
	{
		Hud_SetVisible(elem, true)
	}

    array<var> buttons = GetElementsByClassname( file.realMenu, "createserverbuttons" )
	foreach ( var elem in buttons ) {
		Hud_SetVisible(elem, true)
	}

    Hud_SetVisible(Hud_GetChild( file.menu, "HostSettingUpGamePanel" ), false)
    Hud_SetVisible(Hud_GetChild( file.menu, "HostSettingUpGamePanelText" ), false)
}

void function AddPlayerToUIArray(string name)
{
    PM_PlayerData p
    p.name = name

    playerdata.append(p)
}

table<var, void functionref(var)> WORKAROUND_PlayerButtonToClickHandlerMap = {}
void function ClearPlayerUIArray()
{
    playerdata.clear()
}

void function UpdateHostName(string name)
{
    server_host_name = name
}

void function UpdatePlayersList()
{
    var scrollPanel = Hud_GetChild( file.listPanel, "ScrollPanel" )

    Hud_InitGridButtons( file.listPanel, playerdata.len() )
    foreach ( int id, PM_PlayerData p in playerdata )
	{
		var button = Hud_GetChild( scrollPanel, "GridButton" + id )
        var rui = Hud_GetRui( button )
	    RuiSetString( rui, "buttonText", p.name )

        if ( button in WORKAROUND_PlayerButtonToClickHandlerMap )
		{
			Hud_RemoveEventHandler( button, UIE_DOUBLECLICK, WORKAROUND_PlayerButtonToClickHandlerMap[button] )
			delete WORKAROUND_PlayerButtonToClickHandlerMap[button]
		}

        void functionref(var) clickHandler = (void function( var button ) : ( p) {
            if(p.name != playerdata[0].name)
            {
                EmitUISound( "menu_accept" )
                Hud_SetText( Hud_GetChild( file.kickpanel, "SetPlayerKickMessage" ), "What do you want todo with " + p.name + "?" )
                Hud_SetVisible( file.kickpanel, true )
                file.tempplayertokick = p.name
                PMMenusOpen.kick_open = true
            }
		})

        if(server_host_name == GetPlayerName())
        {
            Hud_AddEventHandler( button, UIE_DOUBLECLICK, clickHandler )
            WORKAROUND_PlayerButtonToClickHandlerMap[button] <- clickHandler
        }
	}

    if(!file.startingmatch)
        RunClientScript("UICallback_CheckForHost")

    if(playerdata.len() > 1) {
        Hud_SetVisible( Hud_GetChild( file.menu, "PlayersListTop" ), true )
        Hud_SetVisible( Hud_GetChild( file.menu, "CurrentPlayersText" ), true )
        Hud_SetVisible( Hud_GetChild( file.menu, "PlayerList" ), true )
    } else {
        Hud_SetVisible( Hud_GetChild( file.menu, "PlayersListTop" ), false )
        Hud_SetVisible( Hud_GetChild( file.menu, "CurrentPlayersText" ), false )
        Hud_SetVisible( Hud_GetChild( file.menu, "PlayerList" ), false )
    }

}

void function UI_SetServerInfo( int type, string text )
{
    switch( type )
    {
        case 0:
                ServerSettings.svServerName = text
	            Hud_SetText(Hud_GetChild( file.menu, "MapServerNameInfoEdit" ), text)
            break;
        case 1:
                ServerSettings.svMapName = text
	            RuiSetImage( Hud_GetRui( Hud_GetChild( file.menu, "ServerMapImg" ) ), "loadscreenImage", GetUIMapAsset( text ) )
            break;
        case 2:
                ServerSettings.svPlaylist = text
	            Hud_SetText(Hud_GetChild( file.menu, "PlaylistInfoEdit" ), GetUIPlaylistName( text ) )
            break;
        case 3:
                ServerSettings.svVisibility = text.tointeger()
	            Hud_SetText(Hud_GetChild( file.menu, "VisInfoEdit" ), GetUIVisibilityName(text.tointeger()))
            break;
    }
}

void function ShowMatchStartingScreen()
{
    file.startingmatch = true

    thread StartMatch()
}

void function StartMatch()
{
    Hud_SetVisible( file.startingpanel, true )
    Hud_SetText( Hud_GetChild( file.startingpanel, "MapAndGamemode" ), GetUIPlaylistName(ServerSettings.svPlaylist) + " - " + GetUIMapName(ServerSettings.svMapName))

    int timer = 5
    while( timer > -1)
    {
        EmitUISound( "menu_accept" )
        Hud_SetText( Hud_GetChild( file.startingpanel, "Timer" ), timer.tostring() )

        timer--
        wait 1
    }

    Hud_SetVisible( file.startingpanel, false )

    file.startingmatch = false

    if(GetPlayerName() == server_host_name)
        CreateServer(ServerSettings.svServerName, ServerSettings.svServerDesc, ServerSettings.svMapName, ServerSettings.svPlaylist, ServerSettings.svVisibility)
}