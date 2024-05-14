"resource/ui/menus/panels/store_vc.res"
{
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	PanelFrame
	{
		ControlName				Label
		xpos					0
		ypos					0
		wide					%100
		tall					%100
		labelText				""
	    bgcolor_override		"70 70 70 255"
		visible					0
		paintbackground			1

        proportionalToParent    1
	}

	VCButton1
	{
		ControlName			RuiButton
		scriptId            0
		xpos			    "%-50"
		ypos			    -60
		zpos			    4
		wide			    337
		tall			    646
		visible			    1
		enabled             0
        rui					"ui/store_button_vc.rpak"
        cursorVelocityModifier  0.7
		proportionalToParent	1

		tabPosition             1

		navRight                VCButton2

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP
	}

	VCButton2
	{
		ControlName			RuiButton
		scriptId            1
		xpos			    10
		ypos			    0
		zpos			    4
		wide			    337
		tall			    646
		visible			    1
		enabled             0
        rui					"ui/store_button_vc.rpak"
        cursorVelocityModifier  0.7
		proportionalToParent	1

        navLeft                 VCButton1
		navRight                VCButton3

        pin_to_sibling          VCButton1
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   TOP_RIGHT
	}

	VCButton3
	{
		ControlName			RuiButton
		scriptId            2
		xpos			    0
		ypos			    -60
		zpos			    4
		wide			    337
		tall			    646
		visible			    1
		enabled             0
        rui					"ui/store_button_vc.rpak"
        cursorVelocityModifier  0.7
		proportionalToParent	1

        navLeft                 VCButton2
		navRight                VCButton4

        pin_to_sibling          PanelFrame
        pin_corner_to_sibling   TOP
        pin_to_sibling_corner   TOP
	}

	VCButton4
	{
		ControlName			RuiButton
		scriptId            3
		xpos			    10
		ypos			    0
		zpos			    4
		wide			    337
		tall			    646
		visible			    1
		enabled             0
        rui					"ui/store_button_vc.rpak"
        cursorVelocityModifier  0.7
		proportionalToParent	1

        navLeft                 VCButton3
		navRight                VCButton5

        pin_to_sibling          VCButton5
        pin_corner_to_sibling   TOP_RIGHT
        pin_to_sibling_corner   TOP_LEFT
	}

	VCButton5
	{
		ControlName			RuiButton
		scriptId            4
		xpos			    "%50"
		ypos			    -60
		zpos			    4
		wide			    337
		tall			    646
		visible			    1
		enabled             0
        rui					"ui/store_button_vc.rpak"
        cursorVelocityModifier  0.7
		proportionalToParent	1

        navLeft                 VCButton4

        pin_to_sibling          PanelFrame
        pin_corner_to_sibling   TOP_RIGHT
        pin_to_sibling_corner   TOP
	}

	DiscountPanel
	{
		ControlName				RuiPanel
		ypos                    -60
		wide					900
		tall					80
		visible					1
        rui                     "ui/store_discount_panel.rpak"

        proportionalToParent    1

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	BOTTOM
        pin_to_sibling_corner	BOTTOM
	}
}
