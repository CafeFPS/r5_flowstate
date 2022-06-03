global function InitR5RVisPanel

struct
{
	var menu
	var panel

	table<var, int> buttonvis
} file

array<int> visibility = [
	eServerVisibility.OFFLINE,
	eServerVisibility.HIDDEN,
	eServerVisibility.PUBLIC
]

void function InitR5RVisPanel( var panel )
{
	file.panel = panel
	file.menu = GetParentMenu( file.panel )

	//Initial panel height
	int height = 10

	for( int i=0; i < visibility.len(); i++ ) {
		//Set vis name
		Hud_SetText( Hud_GetChild( file.panel, "VisText" + i ), vistoname[visibility[i]])

		//Set the map ui visibility to true
		Hud_SetVisible( Hud_GetChild( file.panel, "VisText" + i ), true )
		Hud_SetVisible( Hud_GetChild( file.panel, "VisBtn" + i ), true )
		Hud_SetVisible( Hud_GetChild( file.panel, "VisPanel" + i ), true )

		//Add the Even handler for the button
		Hud_AddEventHandler( Hud_GetChild( file.panel, "VisBtn" + i ), UIE_CLICK, SelectServerVis )

		//Add the button and map to a table
		file.buttonvis[Hud_GetChild( file.panel, "VisBtn" + i )] <- visibility[i]

		//Add height
		height += 45
	}

	//Set final panel height
	Hud_SetHeight( Hud_GetChild( file.panel, "PanelBG" ), height )
}

void function SelectServerVis( var button )
{
	//printf("Debug Vis Selected: " + file.buttonplaylist[button])
	SetSelectedServerVis(file.buttonvis[button])
}