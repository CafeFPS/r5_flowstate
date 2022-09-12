global function InitR5RPlaylistPanel
global function RefreshUIPlaylists

struct
{
	var menu
	var panel
	var listPanel

	table<var, string> playlist_button_table
} file

void function InitR5RPlaylistPanel( var panel )
{
	file.panel = panel
	file.menu = GetPanel( "R5RPrivateMatchPanel" )

	file.listPanel = Hud_GetChild( panel, "PlaylistList" )
}

table<var, void functionref(var)> WORKAROUND_PlaylistButtonToClickHandlerMap = {}
void function RefreshUIPlaylists()
{
	//Get Playlists Array
	array<string> m_vPlaylists = GetPlaylists()

	//Get Number Of Playlists
	int m_vPlaylists_count = m_vPlaylists.len()

	var scrollPanel = Hud_GetChild( file.listPanel, "ScrollPanel" )

	Hud_InitGridButtons( file.listPanel, m_vPlaylists_count )

	foreach ( int id, string playlist in m_vPlaylists )
	{
		var button = Hud_GetChild( scrollPanel, "GridButton" + id )
        var rui = Hud_GetRui( button )
	    RuiSetString( rui, "buttonText", GetUIPlaylistName(playlist) )

        //If button already has a evenhandler remove it
		if ( button in file.playlist_button_table ) {
			Hud_RemoveEventHandler( button, UIE_CLICK, SelectServerPlaylist )
			Hud_RemoveEventHandler( button, UIE_GET_FOCUS, OnPlaylistHover )
			Hud_RemoveEventHandler( button, UIE_LOSE_FOCUS, OnPlaylistUnHover )
			delete file.playlist_button_table[button]
		}

		//Add the Even handler for the button
		Hud_AddEventHandler( button, UIE_CLICK, SelectServerPlaylist )
		Hud_AddEventHandler( button, UIE_GET_FOCUS, OnPlaylistHover )
		Hud_AddEventHandler( button, UIE_LOSE_FOCUS, OnPlaylistUnHover )

		//Add the button and playlist to a table
		file.playlist_button_table[button] <- playlist
	}

	Hud_SetHeight(Hud_GetChild(file.panel, "PanelBG"), Hud_GetHeight(file.listPanel) + 1)
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

void function SelectServerPlaylist( var button )
{
	EmitUISound( "menu_accept" )
	
	//Set selected server playlist
	thread SetSelectedServerPlaylist(file.playlist_button_table[button])
}

void function OnPlaylistHover( var button )
{
	Hud_SetText(Hud_GetChild( file.menu, "PlaylistInfoEdit" ), GetUIPlaylistName( file.playlist_button_table[button] ) )
}

void function OnPlaylistUnHover( var button )
{
	Hud_SetText(Hud_GetChild( file.menu, "PlaylistInfoEdit" ), GetUIPlaylistName( ServerSettings.svPlaylist ) )
}