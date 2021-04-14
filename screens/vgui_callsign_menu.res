vgui_callsign_menu.res
{
	Background
	{
		ControlName			ImagePanel
		xpos				0
		ypos				0
		wide				320
		tall				274
		visible				1
		image				vgui/HUD/white
		scaleImage			1
		drawColor			"255 255 255 255"

		zpos				0
	}

	State
	{
		ControlName			Label
		xpos				0
		ypos				0
		wide				320
		tall				45
		visible				1
		font				CapturePointStatusHUD
		labelText			"#CONTROL_PANEL_DISABLED"
		textAlignment		center

		fgcolor_override 	"164 233 108 160"

		zpos				200

		pin_to_sibling				Background
		pin_corner_to_sibling		CENTER
		pin_to_sibling_corner		CENTER
	}

	ControlledItem
	{
		ControlName			Label
		xpos				0
		ypos				0
		wide				320
		tall				112
		visible				1
		font				CapturePointStatusHUD
		labelText			"----------"
		textAlignment		center

		fgcolor_override 	"164 233 108 160"

		zpos				200

		pin_to_sibling				Background
		pin_corner_to_sibling		TOP
		pin_to_sibling_corner		TOP
	}
}
