global function InitR5RVisPanel

struct
{
	var menu
	var panel
	var listPanel

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
	file.menu = GetPanel( "CreatePanel" )
	file.listPanel = Hud_GetChild( panel, "VisList" )
	
	var scrollPanel = Hud_GetChild( file.listPanel, "ScrollPanel" )

	Hud_InitGridButtons( file.listPanel, visibility.len() )
	foreach ( int id, int vis in visibility )
	{
		var button = Hud_GetChild( scrollPanel, "GridButton" + id )
        var rui = Hud_GetRui( button )
	    RuiSetString( rui, "buttonText", GetUIVisibilityName(vis) )

		//Add the Event handler for the button
		Hud_AddEventHandler( button, UIE_CLICK, SelectServerVis )
		Hud_AddEventHandler( button, UIE_GET_FOCUS, OnVisHover )
		Hud_AddEventHandler( button, UIE_LOSE_FOCUS, OnVisUnHover )

		//Add the button and map to a table
		file.vis_button_table[button] <- vis
	}
}

void function SelectServerVis( var button )
{
	//Set selected server vis
	EmitUISound( "menu_accept" )
	SetSelectedServerVis(file.vis_button_table[button])
}

void function OnVisHover( var button )
{
	Hud_SetText(Hud_GetChild( file.menu, "VisInfoEdit" ), GetUIVisibilityName(file.vis_button_table[button]))
}

void function OnVisUnHover( var button )
{
	Hud_SetText(Hud_GetChild( file.menu, "VisInfoEdit" ), GetUIVisibilityName(ServerSettings.svVisibility))
}