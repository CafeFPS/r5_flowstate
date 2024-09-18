"resource/ui/menus/panels/mainmenu.res"
{
    PanelFrame
    {
		ControlName				Label
		wide					%100
		tall					%100
		labelText				""
		//visible				    1
        //bgcolor_override        "0 0 0 0"
        //paintbackground         1

        //proportionalToParent    1
    }

    LaunchButton
    {
        ControlName				RuiButton
        wide					%100
        tall					%100
        zpos                    3
        rui                     "ui/invisible.rpak"
        labelText               ""
        visible					1
		sound_focus             ""
		//sound_accept            ""
        //cursorVelocityModifier  0.7
        cursorPriority          -1

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    Status
	{
		ControlName				RuiPanel
		ypos                    110
		wide                    600
		tall					92
		visible					1
		rui                     "ui/titlemenu_status.rpak"

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	CENTER
        pin_to_sibling_corner	CENTER
	}

    StatusDetails
    {
        ControlName				RuiPanel
        ypos					-126
        wide					940
        tall					90
        rui                     "ui/titlemenu_status_details.rpak"
        visible					1

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	BOTTOM
        pin_to_sibling_corner	BOTTOM
    }

    // Invisible. Script only reads the values from these.
    ServerSearchMessage
    {
        ControlName				Label
        auto_wide_tocontents 	1
        auto_tall_tocontents 	1
        visible					0
        labelText				""
        font					Default_28
        fgcolor_override		"255 255 255 255"

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	CENTER
        pin_to_sibling_corner	CENTER
    }

    ServerSearchError
    {
        ControlName				Label
        auto_wide_tocontents 	1
        auto_tall_tocontents 	1
        visible					0
        labelText				""
        font					Default_28
        fgcolor_override		"255 255 255 255"

        pin_to_sibling			ServerSearchMessage
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	BOTTOM
    }
}
