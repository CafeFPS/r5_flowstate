// 1151x1151
vgui_titan_vdu.res
{
	Screen
	{
		ControlName			ImagePanel
		xpos				0
		ypos				0
		wide				1151
		tall				1151
		visible				0
		//image				vgui/HUD/white
		image				vgui/HUD/screen_grid_overlay
		scaleImage			1
		drawColor			"0 0 0 0"

		zpos				1
	}

	VDU_CockpitScreen
	{
		ControlName			ImagePanel
		image				vgui/HUD/vdu_hud_monitor

		xpos				0
		ypos				0
		wide				0
		tall				0
		visible				1
		scaleImage			1
		zpos				8

		pin_to_sibling				Screen
		pin_corner_to_sibling		CENTER
		pin_to_sibling_corner		CENTER
	}

	VDU_CockpitScreen_widescreen
	{
		ControlName			ImagePanel
		image				vgui/HUD/vdu_hud_monitor_widescreen

		xpos				0
		ypos				0
		wide				0
		tall				0
		visible				0
		scaleImage			1
		zpos				8

		pin_to_sibling				Screen
		pin_corner_to_sibling		CENTER
		pin_to_sibling_corner		CENTER
	}

	VDU_BG
	{
		ControlName			ImagePanel
		xpos				0
		ypos				0
		wide				0
		tall				0
		visible				0
		image				vgui/HUD/minimap_bg
		scaleImage			1
		drawColor			"255 255 255 255"

		zpos				4

		pin_to_sibling				VDU_CockpitScreen
		pin_corner_to_sibling		CENTER
		pin_to_sibling_corner		CENTER
	}

	VDU_FG
	{
		ControlName			ImagePanel
		xpos				0
		ypos				0
		wide				0
		tall				0
		visible				0
		image				vgui/HUD/vdu_shape
		scaleImage			1
		drawColor			"255 255 255 255"

		zpos				16

		pin_to_sibling				VDU_CockpitScreen
		pin_corner_to_sibling		CENTER
		pin_to_sibling_corner		CENTER
	}

	VDU_FG_widescreen
	{
		ControlName			ImagePanel
		xpos				0
		ypos				0
		wide				0
		tall				0
		visible				0
		image				vgui/HUD/vdu_shape_widescreen
		scaleImage			1
		drawColor			"255 255 255 255"

		zpos				16

		pin_to_sibling				VDU_CockpitScreen
		pin_corner_to_sibling		CENTER
		pin_to_sibling_corner		CENTER
	}
}
