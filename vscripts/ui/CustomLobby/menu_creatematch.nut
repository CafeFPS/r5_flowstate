untyped
// Only way to get Hud_GetPos(sliderButton) working was to use untyped

global function InitR5RCreateMatch

const MAX_BUTTONS_PER_ROW = 3
const MAX_BUTTON_ROWS = 3
const MAX_BUTTONS_PER_PAGE = 9

global struct PrivateMatchSettings {
    string pm_Servername = "Enter a Server Name"
    string pm_Serverdesc = ""
    string pm_Playlist = ""
    string pm_Map = ""
    int pm_Vis = 0
}

struct {
	var menu

    int mapscrolloffset = 0
    int playlistscrollOffset = 0
	
	array<string> m_vPlaylists
	array<string> m_vMaps

	bool mapscrollCallback = false
	bool playlistscrollCallback = false
} file

struct {
	int deltaX = 0
	int deltaY = 0
} mapmouseDeltaBuffer

struct {
	int deltaX = 0
	int deltaY = 0
} playlistmouseDeltaBuffer

global PrivateMatchSettings p_ServerSettings

void function InitR5RCreateMatch( var newMenuArg ) //
{
	var menu = GetMenu( "R5RCreateMatch" )
	file.menu = menu

    foreach ( button in GetElementsByClassname( menu, "MapButton" ) ) {
		Hud_AddEventHandler( button, UIE_CLICK, MapButton_Activated )
		AddButtonEventHandler( button, UIE_GET_FOCUS, MapButton_Hover )
	}

    foreach ( button in GetElementsByClassname( menu, "PlaylistButton" ) ) {
		Hud_AddEventHandler( button, UIE_CLICK, PlaylistButton_Activated )
		AddButtonEventHandler( button, UIE_GET_FOCUS, PlaylistButton_Hover )
	}

    AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpenModeSelectDialog )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnCloseModeSelectDialog )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnNavBack )

	Hud_AddEventHandler( Hud_GetChild( menu, "GamemodesBtn" ), UIE_CLICK, Gamemodes_Activated )
	Hud_AddEventHandler( Hud_GetChild( menu, "BtnPlaylistListDownArrow" ), UIE_CLICK, OnScrollDown_Playlist )
	Hud_AddEventHandler( Hud_GetChild( menu, "BtnPlaylistListUpArrow" ), UIE_CLICK, OnScrollUp_Playlist )
	Hud_AddEventHandler( Hud_GetChild( menu, "BtnMapListDownArrow" ), UIE_CLICK, OnScrollDown_Map )
	Hud_AddEventHandler( Hud_GetChild( menu, "BtnMapListUpArrow" ), UIE_CLICK, OnScrollUp_Map )
	Hud_AddEventHandler( Hud_GetChild( menu, "SaveBtn" ), UIE_CLICK, CreateMatch_Activated )
	Hud_AddEventHandler( Hud_GetChild( Hud_GetChild( file.menu, "SwtBtnVisibility" ), "LeftButton" ), UIE_CLICK, VisButton_Activate )
	Hud_AddEventHandler( Hud_GetChild( Hud_GetChild( file.menu, "SwtBtnVisibility" ), "RightButton" ), UIE_CLICK, VisButton_Activate )

	AddMouseMovementCaptureHandler( Hud_GetChild(menu, "MapMouseMovementCapture"), UpdateMapMouseDeltaBuffer )
	AddMouseMovementCaptureHandler( Hud_GetChild(menu, "PlaylistMouseMovementCapture"), UpdatePlaylistMouseDeltaBuffer )
	AddButtonEventHandler( Hud_GetChild(menu, "MapMouseMovementCapture"), UIE_GET_FOCUS, MapButton_Hover )
	AddButtonEventHandler( Hud_GetChild(menu, "PlaylistMouseMovementCapture"), UIE_GET_FOCUS, PlaylistButton_Hover )
	AddButtonEventHandler( Hud_GetChild( menu, "BtnServerName"), UIE_CHANGE, SaveServerName )
	AddButtonEventHandler( Hud_GetChild( menu, "BtnServerDesc"), UIE_CHANGE, SaveServerDesc )
}

void function VisButton_Activate( var button )
{
	p_ServerSettings.pm_Vis = GetConVarInt( "menu_faq_community_version" )
}

void function SaveServerName(var button)
{
	p_ServerSettings.pm_Servername = Hud_GetUTF8Text( button )
}

void function SaveServerDesc(var button)
{
	p_ServerSettings.pm_Serverdesc = Hud_GetUTF8Text( button )
}

void function CreateMatch_Activated( var button )
{
	Hud_Hide( Hud_GetChild( file.menu, "ErrorText" ) )

	if(p_ServerSettings.pm_Servername.len() == 0) {
		ShowErrorMessage("Error: Server name cannot be empty")
		return
	}
	
	if(p_ServerSettings.pm_Playlist.len() == 0) {
		ShowErrorMessage("Error: No Playlist Selected")
		return
	}
	
	if(p_ServerSettings.pm_Map.len() == 0) {
		ShowErrorMessage("Error: No Map Selected")
		return
	}

	CreateServer(p_ServerSettings.pm_Servername, p_ServerSettings.pm_Serverdesc, p_ServerSettings.pm_Map, p_ServerSettings.pm_Playlist, p_ServerSettings.pm_Vis)
}

void function ShowErrorMessage(string message)
{
	Hud_Show( Hud_GetChild( file.menu, "ErrorText" ) )
	Hud_SetText( Hud_GetChild( file.menu, "ErrorText" ), message )
}

void function PlaylistButton_Activated(var button)
{
	int id = Hud_GetScriptID( button ).tointeger()
	p_ServerSettings.pm_Playlist = file.m_vPlaylists[id + file.playlistscrollOffset]
	file.mapscrolloffset = 0

	array<string> playlist_maps = GetPlaylistMaps(p_ServerSettings.pm_Playlist)
	if(!playlist_maps.contains(p_ServerSettings.pm_Map))
		p_ServerSettings.pm_Map = ""

	SetupMapButtons()
	SetupPlaylistButtons()
	UpdateMapListSliderPosition( file.m_vMaps.len() )
}

void function MapButton_Activated(var button)
{
	int id = Hud_GetScriptID( button ).tointeger()
	p_ServerSettings.pm_Map = file.m_vMaps[id + file.mapscrolloffset]
	SetupMapButtons()
}

void function OnOpenModeSelectDialog()
{
	Hud_SetText( Hud_GetChild( file.menu, "BtnServerName" ), p_ServerSettings.pm_Servername )
	Hud_SetText( Hud_GetChild( file.menu, "BtnServerDesc" ), p_ServerSettings.pm_Serverdesc )

	SetupMapButtons()
    SetupPlaylistButtons()
	UpdateMapListSliderPosition( file.m_vMaps.len() )
	UpdatePlaylistListSliderPosition( file.m_vPlaylists.len() )
}

void function OnCloseModeSelectDialog()
{
	//
}

void function Gamemodes_Activated(var button)
{
    CloseActiveMenu()
}

void function OnNavBack()
{
    CloseAllMenus()
    AdvanceMenu( GetMenu( "R5RLobbyMenu" ) )
}

void function SetupMapButtons()
{
    foreach ( button in GetElementsByClassname( file.menu, "MapButton" ) ) {
		Hud_Hide( button )
	}

    file.m_vMaps = GetPlaylistMaps(p_ServerSettings.pm_Playlist)
	for(int i = 0; i < MAX_BUTTONS_PER_PAGE; i++)
	{
        if((i + file.mapscrolloffset) > (file.m_vMaps.len() - 1))
            break

        Hud_Show(Hud_GetChild( file.menu, "MapButton" + i ))

        RuiSetString( Hud_GetRui( Hud_GetChild( file.menu, "MapButton" + i ) ), "modeNameText", GetUIMapName(file.m_vMaps[i + file.mapscrolloffset]) )
		RuiSetString( Hud_GetRui( Hud_GetChild( file.menu, "MapButton" + i ) ), "modeDescText", "" )
		RuiSetImage( Hud_GetRui( Hud_GetChild( file.menu, "MapButton" + i ) ), "modeImage", GetUIMapAsset(file.m_vMaps[i + file.mapscrolloffset]) )
		RuiSetBool( Hud_GetRui( Hud_GetChild( file.menu, "MapButton" + i ) ), "alwaysShowDesc", false)
		RuiSetBool( Hud_GetRui( Hud_GetChild( file.menu, "MapButton" + i ) ), "isPartyLeader", false )

		if(p_ServerSettings.pm_Map == file.m_vMaps[i + file.mapscrolloffset])
		{
			RuiSetBool( Hud_GetRui( Hud_GetChild( file.menu, "MapButton" + i ) ), "alwaysShowDesc", true)
			RuiSetBool( Hud_GetRui( Hud_GetChild( file.menu, "MapButton" + i ) ), "isPartyLeader", true )
		}
	}

	UpdateMapListSliderHeight( float( file.m_vMaps.len() ) )
}

void function SetupPlaylistButtons()
{
    foreach ( button in GetElementsByClassname( file.menu, "PlaylistButton" ) ) {
		Hud_Hide( button )
	}

    file.m_vPlaylists = GetPlaylists()
    for(int i = 0; i < MAX_BUTTONS_PER_PAGE; i++)
	{
        if((i + file.playlistscrollOffset) > (file.m_vPlaylists.len() - 1))
            break

        Hud_Show(Hud_GetChild( file.menu, "PlaylistButton" + i ))

        RuiSetString( Hud_GetRui( Hud_GetChild( file.menu, "PlaylistButton" + i ) ), "modeNameText", GetUIPlaylistName(file.m_vPlaylists[i + file.playlistscrollOffset]) )
		RuiSetString( Hud_GetRui( Hud_GetChild( file.menu, "PlaylistButton" + i ) ), "modeDescText", "" )
		RuiSetImage( Hud_GetRui( Hud_GetChild( file.menu, "PlaylistButton" + i ) ), "modeImage", $"rui/menu/store/feature_background_square")
		RuiSetBool( Hud_GetRui( Hud_GetChild( file.menu, "PlaylistButton" + i ) ), "alwaysShowDesc", false)
		RuiSetBool( Hud_GetRui( Hud_GetChild( file.menu, "PlaylistButton" + i ) ), "isPartyLeader", false )

		if(p_ServerSettings.pm_Playlist == file.m_vPlaylists[i + file.playlistscrollOffset])
		{
			RuiSetBool( Hud_GetRui( Hud_GetChild( file.menu, "PlaylistButton" + i ) ), "alwaysShowDesc", true)
			RuiSetBool( Hud_GetRui( Hud_GetChild( file.menu, "PlaylistButton" + i ) ), "isPartyLeader", true )
		}
	}

	UpdatePlaylistListSliderHeight( float( file.m_vPlaylists.len() ) )
}

array<string> function GetPlaylists()
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

////////////////////////////////////////////////////////////////////////////////////////
//
// Scrolling
//
////////////////////////////////////////////////////////////////////////////////////////

void function AddMouseScrollCallback( int Type )
{
	if(file.playlistscrollCallback)
	{
		file.playlistscrollCallback = false
		RemoveCallback_OnMouseWheelUp( PlaylistScrollUp )
        RemoveCallback_OnMouseWheelDown( PlaylistScrollDown )
	}

	if(file.mapscrollCallback)
	{
		file.mapscrollCallback = false
		RemoveCallback_OnMouseWheelUp( MapScrollUp )
        RemoveCallback_OnMouseWheelDown( MapScrollDown )
	}

	switch(Type)
	{
		case 0:
			file.mapscrollCallback = true
			AddCallback_OnMouseWheelUp( MapScrollUp )
			AddCallback_OnMouseWheelDown( MapScrollDown )
			break
		case 1:
			file.playlistscrollCallback = true
			AddCallback_OnMouseWheelUp( PlaylistScrollUp )
			AddCallback_OnMouseWheelDown( PlaylistScrollDown )
			break
	}
}

void function MapButton_Hover( var button )
{
	if(Hud_IsVisible(button))
		AddMouseScrollCallback(0)
}

void function PlaylistButton_Hover( var button )
{
	if(Hud_IsVisible(button))
		AddMouseScrollCallback(1)
}

void function PlaylistScrollDown()
{
	if(file.playlistscrollOffset > (file.m_vPlaylists.len() - 4))
		return

	file.playlistscrollOffset += MAX_BUTTONS_PER_ROW

	SetupPlaylistButtons()
	UpdatePlaylistListSliderPosition( file.m_vPlaylists.len() )
}

void function PlaylistScrollUp()
{
	file.playlistscrollOffset -= MAX_BUTTONS_PER_ROW
	if(file.playlistscrollOffset < 0)
		file.playlistscrollOffset = 0

	SetupPlaylistButtons()
	UpdatePlaylistListSliderPosition( file.m_vPlaylists.len() )
}

void function MapScrollUp()
{
	file.mapscrolloffset -= MAX_BUTTONS_PER_ROW
	if(file.mapscrolloffset < 0)
		file.mapscrolloffset = 0

	SetupMapButtons()
	UpdateMapListSliderPosition( file.m_vMaps.len() )
}

void function MapScrollDown()
{
	if(file.mapscrolloffset > (file.m_vMaps.len() - 4))
		return

	file.mapscrolloffset += MAX_BUTTONS_PER_ROW

	SetupMapButtons()
	UpdateMapListSliderPosition( file.m_vMaps.len() )
}

void function OnScrollDown_Map(var button)
{
	MapScrollDown()
}

void function OnScrollUp_Map(var button)
{
	MapScrollUp()
}

void function OnScrollDown_Playlist(var button)
{
	PlaylistScrollDown()
}

void function OnScrollUp_Playlist(var button)
{
	PlaylistScrollUp()
}


void function UpdateMapMouseDeltaBuffer( int x, int y )
{
	mapmouseDeltaBuffer.deltaX += x
	mapmouseDeltaBuffer.deltaY += y

	MapSliderBarUpdate()
}

void function FlushMapMouseDeltaBuffer()
{
	mapmouseDeltaBuffer.deltaX = 0
	mapmouseDeltaBuffer.deltaY = 0
}

void function UpdateMapListSliderPosition( int servers )
{
	var sliderButton = Hud_GetChild( file.menu , "BtnMapListSlider" )
	var sliderPanel = Hud_GetChild( file.menu , "BtnMapListSliderPanel" )
	var movementCapture = Hud_GetChild( file.menu , "MapMouseMovementCapture" )

	float minYPos = -50.0 * ( GetScreenSize().height / 1080.0 )
	float useableSpace = (280.0 * ( GetScreenSize().height / 1080.0 ) - Hud_GetHeight( sliderPanel ) )

	float jump = minYPos - ( useableSpace / ( float( servers ) - MAX_BUTTON_ROWS ) * file.mapscrolloffset )

	if ( jump > minYPos ) jump = minYPos

	Hud_SetPos( sliderButton , 10, jump )
	Hud_SetPos( sliderPanel , 10, jump )
	Hud_SetPos( movementCapture , 10, jump )
}

void function UpdateMapListSliderHeight( float servers )
{
	var sliderButton = Hud_GetChild( file.menu , "BtnMapListSlider" )
	var sliderPanel = Hud_GetChild( file.menu , "BtnMapListSliderPanel" )
	var movementCapture = Hud_GetChild( file.menu , "MapMouseMovementCapture" )

	float maxHeight = 280.0 * ( GetScreenSize().height / 1080.0 )
	float minHeight = 40.0 * ( GetScreenSize().height / 1080.0 )

	float height = maxHeight * ( MAX_BUTTONS_PER_PAGE / servers )

	if ( height > maxHeight ) height = maxHeight
	if ( height < minHeight ) height = minHeight

	Hud_SetHeight( sliderButton , height )
	Hud_SetHeight( sliderPanel , height )
	Hud_SetHeight( movementCapture , height )
}

void function MapSliderBarUpdate()
{
	if ( file.m_vMaps.len() <= MAX_BUTTONS_PER_PAGE ) {
		FlushMapMouseDeltaBuffer()
		return
	}

	var sliderButton = Hud_GetChild( file.menu , "BtnMapListSlider" )
	var sliderPanel = Hud_GetChild( file.menu , "BtnMapListSliderPanel" )
	var movementCapture = Hud_GetChild( file.menu , "MapMouseMovementCapture" )

	Hud_SetFocused( sliderButton )

	float minYPos = -50.0 * ( GetScreenSize().height / 1080.0 )
	float maxHeight = 280.0  * ( GetScreenSize().height / 1080.0 )
	float maxYPos = minYPos - ( maxHeight - Hud_GetHeight( sliderPanel ) )
	float useableSpace = ( maxHeight - Hud_GetHeight( sliderPanel ) )

	float jump = minYPos - ( useableSpace / ( float( file.m_vMaps.len() - 3 ) ) )

	// got local from official respaw scripts, without untyped throws an error
	local pos =	Hud_GetPos( sliderButton )[1]
	local newPos = pos - mapmouseDeltaBuffer.deltaY
	FlushMapMouseDeltaBuffer()

	if ( newPos < maxYPos ) newPos = maxYPos
	if ( newPos > minYPos ) newPos = minYPos

	Hud_SetPos( sliderButton , 10, newPos )
	Hud_SetPos( sliderPanel , 10, newPos )
	Hud_SetPos( movementCapture , 10, newPos )

	file.mapscrolloffset = -int( ( ( newPos - minYPos ) / useableSpace ) * ( file.m_vMaps.len() - 8 ) ) * 3
	SetupMapButtons()
}

//Playlist Slider
void function UpdatePlaylistMouseDeltaBuffer( int x, int y )
{
	playlistmouseDeltaBuffer.deltaX += x
	playlistmouseDeltaBuffer.deltaY += y

	PlaylistSliderBarUpdate()
}

void function FlushPlaylistMouseDeltaBuffer()
{
	playlistmouseDeltaBuffer.deltaX = 0
	playlistmouseDeltaBuffer.deltaY = 0
}

void function UpdatePlaylistListSliderPosition( int servers )
{
	var sliderButton = Hud_GetChild( file.menu , "PlaylistMapListSlider" )
	var sliderPanel = Hud_GetChild( file.menu , "PlaylistMapListSliderPanel" )
	var movementCapture = Hud_GetChild( file.menu , "PlaylistMouseMovementCapture" )

	float minYPos = -50.0 * ( GetScreenSize().height / 1080.0 )
	float useableSpace = (280.0 * ( GetScreenSize().height / 1080.0 ) - Hud_GetHeight( sliderPanel ) )

	float jump = minYPos - ( useableSpace / ( float( servers ) - MAX_BUTTON_ROWS ) * file.playlistscrollOffset )

	if ( jump > minYPos ) jump = minYPos

	Hud_SetPos( sliderButton , 10, jump )
	Hud_SetPos( sliderPanel , 10, jump )
	Hud_SetPos( movementCapture , 10, jump )
}

void function UpdatePlaylistListSliderHeight( float servers )
{
	var sliderButton = Hud_GetChild( file.menu , "PlaylistMapListSlider" )
	var sliderPanel = Hud_GetChild( file.menu , "PlaylistMapListSliderPanel" )
	var movementCapture = Hud_GetChild( file.menu , "PlaylistMouseMovementCapture" )

	float maxHeight = 280.0 * ( GetScreenSize().height / 1080.0 )
	float minHeight = 40.0 * ( GetScreenSize().height / 1080.0 )

	float height = maxHeight * ( MAX_BUTTONS_PER_PAGE / servers )

	if ( height > maxHeight ) height = maxHeight
	if ( height < minHeight ) height = minHeight

	Hud_SetHeight( sliderButton , height )
	Hud_SetHeight( sliderPanel , height )
	Hud_SetHeight( movementCapture , height )
}

void function PlaylistSliderBarUpdate()
{
	if ( file.m_vPlaylists.len() <= MAX_BUTTONS_PER_PAGE ) {
		FlushPlaylistMouseDeltaBuffer()
		return
	}

	var sliderButton = Hud_GetChild( file.menu , "PlaylistMapListSlider" )
	var sliderPanel = Hud_GetChild( file.menu , "PlaylistMapListSliderPanel" )
	var movementCapture = Hud_GetChild( file.menu , "PlaylistMouseMovementCapture" )

	Hud_SetFocused( sliderButton )

	float minYPos = -50.0 * ( GetScreenSize().height / 1080.0 )
	float maxHeight = 280.0  * ( GetScreenSize().height / 1080.0 )
	float maxYPos = minYPos - ( maxHeight - Hud_GetHeight( sliderPanel ) )
	float useableSpace = ( maxHeight - Hud_GetHeight( sliderPanel ) )

	float jump = minYPos - ( useableSpace / ( float( file.m_vPlaylists.len() - 3 ) ) )

	// got local from official respaw scripts, without untyped throws an error
	local pos =	Hud_GetPos( sliderButton )[1]
	local newPos = pos - playlistmouseDeltaBuffer.deltaY
	FlushPlaylistMouseDeltaBuffer()

	if ( newPos < maxYPos ) newPos = maxYPos
	if ( newPos > minYPos ) newPos = minYPos

	Hud_SetPos( sliderButton , 10, newPos )
	Hud_SetPos( sliderPanel , 10, newPos )
	Hud_SetPos( movementCapture , 10, newPos )

	file.playlistscrollOffset = -int( ( ( newPos - minYPos ) / useableSpace ) * ( file.m_vPlaylists.len() - 8 ) ) * 3
	SetupPlaylistButtons()
}