scripts/resource/ui/menus/panels/tabs_buymenu.res
{
    Anchor
    {
		ControlName				Label
		ypos					0
		wide					%100
		tall					%100
		labelText				""
		visible				    1
        bgcolor_override        "0 0 0 0"
        paintbackground         1
    }

	LeftNavButton
	{
		ControlName				RuiPanel
		xpos                    -80
		xpos_nx_handheld	    -78   [$NX || $NX_UI_PC]
		wide                    0
		wide_nx_handheld	    116   [$NX || $NX_UI_PC]
		tall					0
		tall_nx_handheld		38    [$NX || $NX_UI_PC]
		visible					0
		rui                     "ui/shoulder_navigation_shortcut_angle.rpak"
		activeInputExclusivePaint	gamepad

		pin_to_sibling			Tab0
		pin_corner_to_sibling	BOTTOM_RIGHT
		pin_to_sibling_corner	BOTTOM_LEFT
	}

	Tab0
	{
		ControlName				RuiButton
		InheritProperties		TabButton
		scriptID				0
		xpos                    -10 //-700
		ypos					%-10
		zpos 10
		pin_to_sibling			Anchor
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP
	}
	
	Line
	{
		ControlName		ImagePanel
		xpos 5
		wide					2
		tall					30
		visible			1
		scaleImage		1
		proportionalToParent    0
		fillColor		"255 255 255 200"
		drawColor		"255 255 255 200"

		pin_to_sibling			Tab0
		pin_corner_to_sibling	RIGHT
		pin_to_sibling_corner	RIGHT
	}
	
	Tab1
	{
		ControlName				RuiButton
		InheritProperties		TabButton
		scriptID				1
		xpos                    12
		zpos 10
		pin_to_sibling			Tab0
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}
	Line2
	{
		ControlName		ImagePanel
		xpos 5
		wide					2
		tall					30
		visible			1
		scaleImage		1
		proportionalToParent    0
		fillColor		"255 255 255 200"
		drawColor		"255 255 255 200"

		pin_to_sibling			Tab1
		pin_corner_to_sibling	RIGHT
		pin_to_sibling_corner	RIGHT
	}
	Tab2
	{
		ControlName				RuiButton
		InheritProperties		TabButton
		scriptID				2
		xpos                    12
		zpos 10
		pin_to_sibling			Tab1
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}
	Line3
	{
		ControlName		ImagePanel
		xpos 5
		wide					2
		tall					30
		visible			1
		scaleImage		1
		proportionalToParent    0
		fillColor		"255 255 255 200"
		drawColor		"255 255 255 200"

		pin_to_sibling			Tab2
		pin_corner_to_sibling	RIGHT
		pin_to_sibling_corner	RIGHT
	}
	Tab3
	{
		ControlName				RuiButton
		InheritProperties		TabButton
		scriptID				3
		xpos                    12
		zpos 10
		pin_to_sibling			Tab2
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}
	Line4
	{
		ControlName		ImagePanel
		xpos 5
		wide					2
		tall					30
		visible			1
		scaleImage		1
		proportionalToParent    0
		fillColor		"255 255 255 200"
		drawColor		"255 255 255 200"

		pin_to_sibling			Tab3
		pin_corner_to_sibling	RIGHT
		pin_to_sibling_corner	RIGHT
	}
	Tab4
	{
		ControlName				RuiButton
		InheritProperties		TabButton
		scriptID				4
		xpos                    10
		pin_to_sibling			Tab3
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}

	Tab5
	{
		ControlName				RuiButton
		InheritProperties		TabButton
		scriptID				5
		xpos                    10
		pin_to_sibling			Tab4
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}

	Tab6
	{
		ControlName				RuiButton
		InheritProperties		TabButton
		scriptID				6
		xpos                    10
		pin_to_sibling			Tab5
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}

	Tab7
	{
		ControlName				RuiButton
		InheritProperties		TabButtonSettings
		scriptID				7
		xpos                    10
		pin_to_sibling			Tab6
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}

	RightNavButton
	{
		ControlName				RuiPanel
		xpos                    -24
		xpos_nx_handheld        -32   [$NX || $NX_UI_PC]
		wide                    0
		wide_nx_handheld        116   [$NX || $NX_UI_PC]
		tall					0
		tall_nx_handheld		38    [$NX || $NX_UI_PC]
		
		visible					0
		rui                     "ui/shoulder_navigation_shortcut_angle.rpak"
		activeInputExclusivePaint	gamepad

		pin_to_sibling			Tab7
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	BOTTOM_RIGHT
	}
}