// 319x319
vgui_titan_ammo.res
{
	Background
	{
		ControlName			ImagePanel
		xpos				0
		ypos				0
		wide				319
		tall				319
		visible				1
		image				vgui/HUD/info_rounded_shape_bg
		scaleImage			1
		drawColor			"0 0 0 128"

		zpos				0
	}

	Foreground
	{
		ControlName			ImagePanel
		xpos				0
		ypos				0
		wide				319
		tall				319
		visible				1
		image				vgui/HUD/info_rounded_shape
		scaleImage			1
		drawColor			"255 255 255 64"

		zpos				299
	}

	Overlay
	{
		ControlName			ImagePanel
		xpos				0
		ypos				0
		wide				319
		tall				319
		visible				0
		image				vgui/HUD/info_rounded_shape_bg
		scaleImage			1
		drawColor			"255 255 255 16" // "255 255 255 16"

		zpos				300
	}

	DamageLayer
	{
		ControlName			ImagePanel
		xpos				0
		ypos				0
		wide				319
		tall				319
		visible				0
		image				vgui/HUD/info_rounded_shape
		scaleImage			1
		drawColor			"255 0 0 255"

		zpos				10
	}

	WeaponName
	{
		ControlName			Label
		xpos				-18
		ypos				-45
		wide				306
		tall				45
		visible				1
		font				CapturePointStatusHUD
		labelText			"[WEAPON NAME]"
		textAlignment		east

		zpos				200

		pin_to_sibling				Background
		pin_corner_to_sibling		BOTTOM
		pin_to_sibling_corner		BOTTOM
	}

	AmmoCount
	{
		ControlName			Label
		xpos				-18
		ypos				-135
		wide				306
		tall				45
		visible				1
		font				CapturePointStatusHUD
		labelText			"[AMMO COUNT]"
		textAlignment		east

		zpos				200

		pin_to_sibling				Background
		pin_corner_to_sibling		BOTTOM
		pin_to_sibling_corner		BOTTOM
	}

	AmmoTotal
	{
		ControlName			Label
		xpos				-18
		ypos				-9
		wide				306
		tall				45
		visible				1
		font				CapturePointStatusHUD
		labelText			"[AMMO TOTAL]"
		textAlignment		east

		zpos				200

		pin_to_sibling				Background
		pin_corner_to_sibling		BOTTOM
		pin_to_sibling_corner		BOTTOM
	}

	AmmoBarBackground
	{
		ControlName			Label
		xpos				0
		ypos				-112
		wide				283
		tall				36
		visible				1
		font				CapturePointStatusHUD
		labelText			""
		textAlignment		center
		bgcolor_override	"0 0 0 160"

		zpos				199

		pin_to_sibling				Background
		pin_corner_to_sibling		TOP
		pin_to_sibling_corner		TOP
	}

	AmmoBar
	{
		ControlName			ImagePanel
		xpos				-4
		ypos				0
		wide				274
		tall				27
		visible				1
		image				vgui/HUD/white
		scaleImage			1

		drawColor			"160 160 160 128"

		zpos				201

		pin_to_sibling				AmmoBarBackground
		pin_corner_to_sibling		LEFT
		pin_to_sibling_corner		LEFT
	}

	SuperIconB
	{
		ControlName			ImagePanel
		xpos				-18
		ypos				-18
		wide				72
		tall				72
		visible				1
		image				vgui/HUD/white
		scaleImage			1

		drawColor			"255 255 255 160"

		zpos				201

		pin_to_sibling				Background
		pin_corner_to_sibling		TOP_RIGHT
		pin_to_sibling_corner		TOP_RIGHT
	}

	SuperBarBG
	{
		ControlName			ImagePanel
		xpos				0
		ypos				-31
		wide				135
		tall				54
		visible				1
		image				vgui/HUD/hud_wedge
		scaleImage			1

		drawColor			"0 0 0 32"

		zpos				200

		pin_to_sibling				Background
		pin_corner_to_sibling		TOP
		pin_to_sibling_corner		TOP
	}

	SuperBarFill
	{
		ControlName			ImagePanel
		xpos				0
		ypos				-31
		wide				135
		tall				54
		visible				1
		image				vgui/HUD/hud_wedge_fill
		scaleImage			1

		drawColor			"255 255 255 160"

		zpos				201

		pin_to_sibling				Background
		pin_corner_to_sibling		TOP
		pin_to_sibling_corner		TOP
	}

	SuperIconA
	{
		ControlName			ImagePanel
		xpos				-18
		ypos				-18
		wide				72
		tall				72
		visible				1
		image				vgui/HUD/white
		scaleImage			1

		drawColor			"255 255 255 160"

		zpos				201

		pin_to_sibling				Background
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}
}
