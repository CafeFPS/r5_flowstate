//967x202
vgui_xpbar.res
{
	XPBarAnchor
	{
		ControlName			ImagePanel
		xpos				0
		ypos				0
		wide				967
		tall				202
		visible				1
		scaleImage			1
		image				vgui/HUD/white
		fillColor			"0 0 0 0"
		drawColor			"255 0 255 0"
	}

	xpBarBG
	{
		ControlName			ImagePanel
		xpos				0
		ypos				0
		wide				827
		tall				18
		visible				0
		image				vgui/HUD/white
		scaleImage			1
		drawColor			"0 0 0 127"

		pin_to_sibling				XPBarAnchor
		pin_corner_to_sibling		TOP
		pin_to_sibling_corner		TOP
	}

	xpBarFG
	{
		ControlName			ImagePanel
		xpos				0
		ypos				0
		wide				827
		tall				18
		visible				0
		image				vgui/HUD/white
		scaleImage			1
		drawColor			"255 255 255 100"

		pin_to_sibling				xpBarBG
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}
}
