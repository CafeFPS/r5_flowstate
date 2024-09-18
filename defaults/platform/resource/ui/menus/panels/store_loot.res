"resource/ui/menus/panels/store_loot.res"
{
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	PanelFrame
	{
		ControlName				Label
		xpos					0
		ypos					0
		wide					1728
		tall					%100
		labelText				""
	    bgcolor_override		"70 70 70 255"
		visible					0
		paintbackground			1

		proportionalToParent    1
	}

	OpenOwnedButton
	{
		ControlName			RuiButton
		classname           "MenuButton"
		xpos			    0
		ypos			    16
		zpos			    4
		wide			    832
		tall			    96
		visible			    1
		labelText           ""
        rui					"ui/generic_loot_button.rpak"
        cursorVelocityModifier  0.7
		proportionalToParent	1

        navUp                   PurchaseButton

		tabPosition             1

        pin_to_sibling			LootPanelA
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	BOTTOM
	}

	PanelArt
	{
	    ControlName             RuiPanel
		ypos			        -32
        wide					832
        tall					768
        rui                     "ui/store_panel_loot_art.rpak"
        visible					1

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT

	}

	LootPanelA
	{
		ControlName			CNestedPanel
		ypos			    -32
		zpos			    4
		wide			    832
		tall			    656
		visible			    1
		labelText           ""
		proportionalToParent	1

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP_RIGHT
        pin_to_sibling_corner	TOP_RIGHT

        PanelFrame
        {
            ControlName				Label
            xpos					0
            ypos					0
            wide					%100
            tall					%100
            labelText				""
            bgcolor_override		"10 10 10 255"
            visible					0
            paintbackground			1
    		proportionalToParent	1
        }

        PanelContent
        {
            ControlName				RuiPanel
            xpos					0
            ypos					0
            wide					%100
            tall					%100
            rui					    "ui/store_panel_loot_details.rpak"
            visible					1
    		proportionalToParent	1
        }

        PurchaseButton
        {
            ControlName			RuiButton
            classname           "MenuButton"
            xpos			    %-25
            ypos			    "%-2"
            zpos			    4
            wide			    %40
            tall			    96
            visible			    1
            scriptID            0
            rui					"ui/generic_bar_desc_button.rpak"
            cursorVelocityModifier  0.7
            proportionalToParent	1
            sound_accept            ""

            navRight                PurchaseButtonN
            navDown                 OpenOwnedButton

            pin_to_sibling			PanelContent
            pin_corner_to_sibling	BOTTOM
            pin_to_sibling_corner	BOTTOM_LEFT
        }

        PurchaseButtonN
        {
            ControlName			RuiButton
            classname           "MenuButton"
            xpos			    %-25
            ypos			    "%-2"
            zpos			    4
            wide			    %40
            tall			    96
            visible			    1
            scriptID            1
            rui					"ui/generic_bar_desc_button.rpak"
            cursorVelocityModifier  0.7
            proportionalToParent	1
            sound_accept            ""

            navLeft                 PurchaseButton
            navDown                 OpenOwnedButton

            pin_to_sibling			PanelContent
            pin_corner_to_sibling	BOTTOM
            pin_to_sibling_corner	BOTTOM_RIGHT
        }
	}
}