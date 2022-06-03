global function InitR5RMapPanel
global function RefreshUIMaps

struct
{
	var menu
	var panel

	table<var, string> buttonmap
} file

//Maps to be removed from the ui
array<string> removedmaps = [
	"mp_lobby",
	"mp_npe"
]

void function InitR5RMapPanel( var panel )
{
	file.panel = panel
	file.menu = GetParentMenu( file.panel )
}

void function RefreshUIMaps()
{
	//Get maps array
	array<string> availablemaps = GetMaps()

	//Get number of maps
	int number_of_maps = availablemaps.len()

	//Currently supports upto 16 maps
	//Amos and I talked and will setup a page system for maps when needed
	if(number_of_maps > 16)
		number_of_maps = 16

	//Intial row and width
	int current_row_items = 0
	int map_bg_width = 330

	for( int i=0; i < number_of_maps; i++ ) {
		//Set Map Text
		Hud_SetText( Hud_GetChild( file.panel, "MapText" + i ), GetUIMapName(availablemaps[i]))

		//Set Map Asset
		RuiSetImage( Hud_GetRui( Hud_GetChild( file.panel, "MapImg" + i ) ), "loadscreenImage", GetUIMapAsset(availablemaps[i]) )

		//Set the map ui visibility to true
		Hud_SetVisible( Hud_GetChild( file.panel, "MapText" + i ), true )
		Hud_SetVisible( Hud_GetChild( file.panel, "MapImg" + i ), true )
		Hud_SetVisible( Hud_GetChild( file.panel, "MapBtn" + i ), true )

		//If button already has a evenhandler remove it
		var button = Hud_GetChild( file.panel, "MapBtn" + i )
		if ( button in file.buttonmap )
		{
			Hud_RemoveEventHandler( button, UIE_CLICK, SelectServerMap )
			delete file.buttonmap[button]
		}

		//Add the Even handler for the button
		Hud_AddEventHandler( Hud_GetChild( file.panel, "MapBtn" + i ), UIE_CLICK, SelectServerMap )

		//Add the button and map to a table
		file.buttonmap[Hud_GetChild( file.panel, "MapBtn" + i )] <- availablemaps[i]

		//For calculating map selection background width
		if(current_row_items > 3) {
			map_bg_width += 325
			current_row_items = 0
		}

		current_row_items++
	}

	//Set the map selection background width
	Hud_SetWidth( Hud_GetChild( file.panel, "PanelBG" ), map_bg_width )
	Hud_SetWidth( Hud_GetChild( file.panel, "PanelTopBG" ), map_bg_width )
}

array<string> function GetMaps()
{
	//Get all available maps
	array<string> allmaps = GetAvailableMaps()
	array<string> availablemaps

	//Setup available maps array
	foreach( string map in allmaps) {
		//If is a lobby map dont add
		if(!IsValidMap(map))
			continue

		//Add map to the array
		availablemaps.append(map)
	}

	return availablemaps
}

bool function IsValidMap(string map)
{
	//Dont show these maps in the map selection
	if( removedmaps.contains(map) )
		return false

	return true
}

void function SelectServerMap( var button )
{
	//printf("Debug Map Selected: " + file.buttonmap[button])
	SetSelectedServerMap(file.buttonmap[button])
}