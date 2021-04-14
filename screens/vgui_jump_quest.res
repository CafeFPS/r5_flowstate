vgui_jump_quest.res
{
	Background
	{
		ControlName			ImagePanel
		xpos				11
		ypos				11
		wide				652
		tall				337
		visible				1
		image				vgui/HUD/white
		scaleImage			1
		drawColor 			"0 0 0 200"

		zpos				5
	}

	TopTrim
	{
		ControlName			ImagePanel
		xpos				0
		ypos				0
		wide				672
		tall				11
		visible				1
		image				vgui/HUD/white
		scaleImage			1
		drawColor 			"220 220 200 100"

		zpos				5
	}

	BottomTrim
	{
		ControlName			ImagePanel
		xpos				0
		ypos				348
		wide				672
		tall				11
		visible				1
		image				vgui/HUD/white
		scaleImage			1
		drawColor 			"220 220 200 100"

		zpos				5
	}

	LeftTrim
	{
		ControlName			ImagePanel
		xpos				0
		ypos				11
		wide				11
		tall				337
		visible				1
		image				vgui/HUD/white
		scaleImage			1
		drawColor 			"220 220 200 100"

		zpos				5
	}

	RightTrim
	{
		ControlName			ImagePanel
		xpos				663
		ypos				11
		wide				11
		tall				337
		visible				1
		image				vgui/HUD/white
		scaleImage			1
		drawColor 			"220 220 200 100"

		zpos				5
	}

	Star1
	{
		ControlName			ImagePanel
		xpos				56
		ypos				157
		wide				157
		tall				157
		visible				0
		image				vgui/HUD/loadout/xbutton
		scaleImage			1
		drawColor			"255 255 255 255"

		zpos				10
	}

	Star2
	{
		ControlName			ImagePanel
		xpos				259
		ypos				157
		wide				157
		tall				157
		visible				0
		image				vgui/HUD/loadout/xbutton
		scaleImage			1
		drawColor			"255 255 255 255"

		zpos				10
	}

	Star3
	{
		ControlName			ImagePanel
		xpos				461
		ypos				157
		wide				157
		tall				157
		visible				0
		image				vgui/HUD/loadout/xbutton
		scaleImage			1
		drawColor			"255 255 255 255"

		zpos				10
	}

	BestScore
	{
		ControlName			Label
		xpos				427
		ypos				22
		wide				674
		tall				112
		visible				0
		font				HudNumbersSmall
		labelText			""
		textAlignment		west
		drawColor			"255 255 255 255"

		zpos				10
	}

	TrackTitle
	{
		ControlName			Label
		xpos				45
		ypos				22
		wide				674
		tall				112
		visible				0
		font				HudNumbersSmall
		labelText			"Track 3"
		textAlignment		west
		drawColor			"255 255 255 255"

		zpos				10
	}



	JQ_BG
	{
		ControlName			ImagePanel
		xpos				0
		ypos				0
		wide				405
		tall				270
		visible				0
		image				vgui/HUD/minimap_bg
		scaleImage			1
		drawColor			"255 255 255 255"

		zpos				4

	}

	JQ_FG
	{
		ControlName			ImagePanel
		xpos				0
		ypos				0
		wide				405
		tall				270
		visible				0
		image				vgui/HUD/vdu_shape
		scaleImage			1
		drawColor			"255 255 255 255"

		zpos				16
	}



	Points
	{
		ControlName			Label
		xpos				0
		ypos				0
		wide				674
		tall				112
		visible				0
		font				HudNumbersSmall
		labelText			"0"
		textAlignment		center
		drawColor			"155 255 255 255"
		alpha				"255"
		pin_to_sibling				JQ_BG
		pin_corner_to_sibling		CENTER
		pin_to_sibling_corner		CENTER

		zpos				50
	}
	Points2 // so it'll show up damnit
	{
		ControlName			Label
		xpos				0
		ypos				0
		wide				674
		tall				112
		visible				0
		font				HudNumbersSmall
		labelText			"0"
		textAlignment		center
		drawColor			"155 255 255 255"
		pin_to_sibling				JQ_BG
		pin_corner_to_sibling		CENTER
		pin_to_sibling_corner		CENTER

		zpos				50
	}

	Mult1
	{
		ControlName			Label
		xpos				-90
		ypos				-45
		wide				674
		tall				112
		visible				0
		font				HudNumbersSmall
		labelText			"X2"
		textAlignment		center
		drawColor			"155 255 255 255"
		pin_to_sibling				JQ_BG
		pin_corner_to_sibling		CENTER
		pin_to_sibling_corner		CENTER

		zpos				10
	}

	Mult2
	{
		ControlName			Label
		xpos				90
		ypos				-45
		wide				674
		tall				112
		visible				0
		font				HudNumbersSmall
		labelText			"X2"
		textAlignment		center
		drawColor			"155 255 255 255"
		pin_to_sibling				JQ_BG
		pin_corner_to_sibling		CENTER
		pin_to_sibling_corner		CENTER

		zpos				10
	}

	Mult3
	{
		ControlName			Label
		xpos				90
		ypos				45
		wide				674
		tall				112
		visible				0
		font				HudNumbersSmall
		labelText			"X2"
		textAlignment		center
		drawColor			"155 255 255 255"
		pin_to_sibling				JQ_BG
		pin_corner_to_sibling		CENTER
		pin_to_sibling_corner		CENTER

		zpos				10
	}

	Mult4
	{
		ControlName			Label
		xpos				-90
		ypos				45
		wide				674
		tall				112
		visible				0
		font				HudNumbersSmall
		labelText			"X2"
		textAlignment		center
		drawColor			"155 255 255 255"
		pin_to_sibling				JQ_BG
		pin_corner_to_sibling		CENTER
		pin_to_sibling_corner		CENTER

		zpos				10
	}
}
