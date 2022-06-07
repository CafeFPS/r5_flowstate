global function InitR5RVisPanel

struct
{
	var menu
	var panel

	table<var, int> vis_button_table
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
		file.vis_button_table[Hud_GetChild( file.panel, "VisBtn" + i )] <- visibility[i]
	}
}

void function SelectServerVis( var button )
{
	//Set selected server vis
	SetSelectedServerVis(file.vis_button_table[button])
}