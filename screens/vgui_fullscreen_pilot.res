#base "vgui_fullscreen.res"
vgui_fullscreen_pilot.res
{
	Screen
	{
		ControlName			ImagePanel
		xpos				0
		ypos				0
		wide				1920
		tall				1080
		visible				1
		//image				vgui/HUD/white
		image				vgui/HUD/screen_grid_overlay
		scaleImage			1
		drawColor			"0 0 0 0"

		zpos				1
	}

	EMPScreenFX
	{
		ControlName		ImagePanel
		xpos 			0
		ypos 			0
		zpos			-1000
		wide			1920
		tall			1080
		visible			0
		scaleImage		1
		image			vgui/HUD/pilot_flashbang_overlay
		drawColor		"255 255 255 64"

		pin_to_sibling				Screen
		pin_corner_to_sibling		CENTER
		pin_to_sibling_corner		CENTER
	}
}
