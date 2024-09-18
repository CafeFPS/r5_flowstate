resource/ui/menus/panels/tabs_lobby.res
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

    Background
    {
        ControlName				RuiPanel
		wide					%100
		tall					%100
        visible					1
        enabled					1
        proportionalToParent    1
        rui 					"ui/tabs_background.rpak"
    }

	LeftNavButton
	{
		ControlName				RuiPanel
		xpos                    -80
		wide                    76
		tall					28
		visible					1
		rui                     "ui/shoulder_navigation_shortcut_angle.rpak"
		activeInputExclusivePaint	gamepad

		pin_to_sibling			Anchor
		pin_corner_to_sibling	BOTTOM_RIGHT
		pin_to_sibling_corner	BOTTOM_LEFT
	}

	Tab0
	{
		ControlName				RuiButton
		InheritProperties		TabButtonLobby
		scriptID				0
		xpos                    -650 //-700
		pin_to_sibling			Anchor
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP
	}

	Tab1
	{
		ControlName				RuiButton
		InheritProperties		TabButtonLobby
		scriptID				1

		xpos                    -80

		pin_to_sibling			Tab0
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}

	Tab2
	{
		ControlName				RuiButton
		InheritProperties		TabButtonLobby
		scriptID				2

		xpos                    -80

		pin_to_sibling			Tab1
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}

	Tab3
	{
		ControlName				RuiButton
		InheritProperties		TabButtonLobby
		scriptID				3

		xpos                    -80

		pin_to_sibling			Tab2
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}

	Tab4
	{
		ControlName				RuiButton
		InheritProperties		TabButtonLobby
		scriptID				4

		xpos                    -80

		pin_to_sibling			Tab3
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}

	Tab5
	{
		ControlName				RuiButton
		InheritProperties		TabButtonLobby
		scriptID				5

		xpos                    -80

		pin_to_sibling			Tab4
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}

	Tab6
	{
		ControlName				RuiButton
		InheritProperties		TabButtonLobby
		scriptID				6

		xpos                    -80

		pin_to_sibling			Tab5
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}

	Tab7
	{
		ControlName				RuiButton
		InheritProperties		TabButtonLobby
		scriptID				7

		xpos                    -80

		pin_to_sibling			Tab6
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}

	RightNavButton
	{
		ControlName				RuiPanel
		xpos                    -24
		wide                    76
		tall					28
		visible					1
		rui                     "ui/shoulder_navigation_shortcut_angle.rpak"
		activeInputExclusivePaint	gamepad

		pin_to_sibling			Anchor
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	BOTTOM_RIGHT
	}
}