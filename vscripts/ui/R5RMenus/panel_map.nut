global function InitR5RMapPanel
global function RefreshUIMaps

struct
{
	var menu
	var panel
	var listPanel

	table<var, string> map_button_table
} file

void function InitR5RMapPanel( var panel )
{
	file.panel = panel
	file.menu = GetPanel( "R5RPrivateMatchPanel" )

	file.listPanel = Hud_GetChild( panel, "MapList" )
}

void function RefreshUIMaps()
{
	//GetUIMapAsset(m_vMaps[i])

	array<string> m_vMaps = GetPlaylistMaps(ServerSettings.svPlaylist)

	int m_vMaps_count = m_vMaps.len()

	var scrollPanel = Hud_GetChild( file.listPanel, "ScrollPanel" )

	Hud_InitGridButtons( file.listPanel, m_vMaps_count )

	foreach ( int id, string map in m_vMaps )
	{
		var button = Hud_GetChild( scrollPanel, "GridButton" + id )
        var rui = Hud_GetRui( button )
	    RuiSetString( rui, "buttonText", GetUIMapName(map) )

        //If button already has a evenhandler remove it
		if ( button in file.map_button_table ) {
			Hud_RemoveEventHandler( button, UIE_CLICK, SelectServerMap )
			Hud_RemoveEventHandler( button, UIE_GET_FOCUS, OnMapHover )
			Hud_RemoveEventHandler( button, UIE_LOSE_FOCUS, OnMapUnHover )
			delete file.map_button_table[button]
		}

		//Add the Even handler for the button
		Hud_AddEventHandler( button, UIE_CLICK, SelectServerMap )
		Hud_AddEventHandler( button, UIE_GET_FOCUS, OnMapHover )
		Hud_AddEventHandler( button, UIE_LOSE_FOCUS, OnMapUnHover )

		//Add the button and map to a table
		file.map_button_table[button] <- map
	}

	Hud_SetHeight(Hud_GetChild(file.panel, "PanelBG"), Hud_GetHeight(file.listPanel) + 1)
}

void function SelectServerMap( var button )
{
	EmitUISound( "menu_accept" )
	
	//Set selected server map
	SetSelectedServerMap(file.map_button_table[button])
}

void function OnMapHover( var button )
{
	RuiSetImage( Hud_GetRui( Hud_GetChild( file.menu, "ServerMapImg" ) ), "loadscreenImage", GetUIMapAsset( file.map_button_table[button] ) )
}

void function OnMapUnHover( var button )
{
	RuiSetImage( Hud_GetRui( Hud_GetChild( file.menu, "ServerMapImg" ) ), "loadscreenImage", GetUIMapAsset( ServerSettings.svMapName ) )
}