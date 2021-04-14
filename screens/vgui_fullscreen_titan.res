#base "vgui_fullscreen.res"
vgui_fullscreen_titan.res
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
		fillColor			"255 255 255 0"

		zpos				1
	}

	SafeArea
	{
		ControlName		ImagePanel
		wide			1760
		tall			1000
		visible			1
		scaleImage		1
		fillColor		"255 0 0 0"
		drawColor		"0 0 0 0"
		image			vgui/HUD/white

		pin_to_sibling				Screen
		pin_corner_to_sibling		CENTER
		pin_to_sibling_corner		CENTER

		zpos				2
	}

	SafeAreaCenter
	{
		ControlName		ImagePanel
		xpos			0
		ypos			0
		wide			1500
		tall			1070
		visible			1
		scaleImage		1
		fillColor		"0 0 255 0"
		drawColor		"0 0 255 0"
		image			vgui/HUD/white

		pin_to_sibling				Screen
		pin_corner_to_sibling		CENTER
		pin_to_sibling_corner		CENTER
	}
}
