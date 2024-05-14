"Resource/UI/HudDeathRecap.res"
{
	deathRecapBackground
	{
		ControlName			ImagePanel
		ypos				0 		[!$WIN32]
		ypos				-49 	[$WIN32]
		xpos				-45
		zpos				1012
		wide				510
		tall				256
		image				"ui/deathrecap_bg_one_source"
		visible				0
		enable				1
		scaleImage			1

		pin_to_sibling				Screen
		pin_corner_to_sibling		LEFT
		pin_to_sibling_corner		LEFT
	}

	deathRecapForeground
	{
		ControlName			ImagePanel
		zpos				1013
		wide				510
		tall				256
		image				"ui/deathrecap_fg_one_source"
		visible				0
		enable				1
		scaleImage			1

		pin_to_sibling				deathRecapBackground
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}

	deathRecap_Column1_Row1
	{
		ControlName			Label
		xpos				9
		ypos				-11
		zpos				1014
		wide 				157
		tall				29
		visible				0
		font				Default_21_ShadowGlow
		labelText			""
		allcaps				1
		textAlignment		center
		fgcolor_override 	"255 255 255 255"
		//bgcolor_override 	"0 255 0 128"

		pin_to_sibling				deathRecapBackground
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}

	deathRecap_Column1_Row2
	{
		ControlName			Label
		xpos				-18
		ypos				7
		zpos				1014
		wide				202
		tall				27
		visible				0
		font				Default_21_ShadowGlow
		labelText			""
		textAlignment		east
		textinsetx			13
		fgcolor_override 	"0 0 0 255"
		//bgcolor_override 	"0 0 255 128"

		pin_to_sibling				deathRecap_Column1_Row1
		pin_corner_to_sibling		TOP_RIGHT
		pin_to_sibling_corner		BOTTOM_RIGHT
	}

	deathRecap_WeaponIcon_0
	{
		ControlName			ImagePanel
		xpos				-56
		ypos				0
		zpos				1014
		wide				27
		tall				27
		visible				0
		image				vgui/white
		scaleImage			1

		pin_to_sibling				deathRecap_Column1_Row2
		pin_corner_to_sibling		TOP_RIGHT
		pin_to_sibling_corner		TOP_RIGHT
	}

	deathRecap_WeaponIcon_1
	{
		ControlName			ImagePanel
		xpos				-56
		ypos				0
		zpos				1014
		wide				27
		tall				27
		visible				0
		image				vgui/white
		scaleImage			1

		pin_to_sibling				deathRecap_Column1_Row4
		pin_corner_to_sibling		TOP_RIGHT
		pin_to_sibling_corner		TOP_RIGHT
	}

	deathRecap_DoomedEnemyTypeIcon_0
	{
		ControlName			ImagePanel
		xpos				-67
		ypos				-27
		zpos				1014
		wide				54
		tall				54
		visible				0
		image				vgui/white
		scaleImage			1

		pin_to_sibling				deathRecap_Column1_Row1
		pin_corner_to_sibling		TOP_RIGHT
		pin_to_sibling_corner		TOP_RIGHT
	}

	deathRecap_DoomedEnemyTypeIcon_1
	{
		ControlName			ImagePanel
		xpos				-67
		ypos				-27
		zpos				1014
		wide				54
		tall				54
		visible				0
		image				vgui/white
		scaleImage			1

		pin_to_sibling				deathRecap_Column1_Row6
		pin_corner_to_sibling		TOP_RIGHT
		pin_to_sibling_corner		TOP_RIGHT
	}

	deathRecap_Column1_Row3
	{
		ControlName			Label
		xpos				0
		zpos				1014
		wide				202
		tall				27
		visible				0
		font				Default_21_ShadowGlow
		labelText			""
		textAlignment		east
		textinsetx			13
		fgcolor_override 	"0 0 0 255"
		//bgcolor_override 	"0 0 255 128"

		pin_to_sibling				deathRecap_Column1_Row2
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}

	deathRecap_Column1_Row4
	{
		ControlName			Label
		xpos				0
		zpos				1014
		wide				202
		tall				27
		visible				0
		font				Default_21_ShadowGlow
		labelText			""
		textAlignment		east
		textinsetx			13
		fgcolor_override 	"0 0 0 255"
		//bgcolor_override 	"0 255 255 128"

		pin_to_sibling				deathRecap_Column1_Row3
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}

	deathRecap_Column1_Row5
	{
		ControlName			Label
		xpos				0
		zpos				1014
		wide				202
		tall				27
		visible				0
		font				Default_21_ShadowGlow
		labelText			""
		textAlignment		east
		textinsetx			13
		fgcolor_override 	"0 0 0 255"
		//bgcolor_override 	"0 255 255 128"

		pin_to_sibling				deathRecap_Column1_Row4
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}

	deathRecap_Column1_Row6
	{
		ControlName			Label
		xpos				9
		ypos				-153
		zpos				1014
		wide				157
		tall				29
		visible				0
		font				Default_21_ShadowGlow
		labelText			""
		textAlignment		center
		textinsetx			13
		fgcolor_override 	"255 255 255 255"
		//bgcolor_override 	"0 255 255 128"

		pin_to_sibling				deathRecapBackground
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}

	deathRecap_Column1_Row7
	{
		ControlName			Label
		xpos				-18
		zpos				1014
		wide				202
		tall				27
		visible				0
		font				Default_21_ShadowGlow
		labelText			""
		textAlignment		east
		textinsetx			13
		fgcolor_override 	"0 0 0 255"
		//bgcolor_override 	"0 255 255 128"

		pin_to_sibling				deathRecap_Column1_Row6
		pin_corner_to_sibling		TOP_RIGHT
		pin_to_sibling_corner		BOTTOM_RIGHT
	}

	deathRecap_Column1_Row8
	{
		ControlName			Label
		xpos				0
		zpos				1014
		wide				202
		tall				27
		visible				0
		font				Default_21_ShadowGlow
		labelText			""
		textAlignment		east
		textinsetx			13
		fgcolor_override 	"0 0 0 255"
		//bgcolor_override 	"0 255 255 128"

		pin_to_sibling				deathRecap_Column1_Row7
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}

	deathRecap_Column2_Row1
	{
		ControlName			Label
		xpos				-148
		ypos				-11
		zpos				1014
		wide 				259
		tall				29
		visible				0
		font				Default_21_ShadowGlow
		labelText			""
		allcaps				1
		textAlignment		west
		textinsetx			0
		fgcolor_override 	"0 0 0 255"
		//bgcolor_override 	"0 255 255 128"

		pin_to_sibling				deathRecapBackground
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}

	deathRecap_HealthStatus_Killer
	{
		ControlName			Label
		xpos				0
		ypos				0
		zpos				1014
		wide 				90
		tall				29
		visible				0
		font				Default_21_ShadowGlow
		labelText			""
		allcaps				1
		textAlignment		west
		textinsetx			0
		fgcolor_override 	"0 0 0 255"
		//bgcolor_override 	"0 255 255 128"

		pin_to_sibling				deathRecap_Column2_Row1
		pin_corner_to_sibling		LEFT
		pin_to_sibling_corner		RIGHT
	}

	deathRecapWeaponIcon_0
	{
		ControlName			ImagePanel
		ypos				7
		wide				27
		tall				27
		visible				0
		image				vgui/white
		scaleImage			1

		pin_to_sibling				deathRecap_Column2_Row1
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT

		zpos			1014
	}

	deathRecap_Column2_Row2
	{
		ControlName			Label
		zpos				1014
		wide 				330
		tall				27
		visible				0
		font				Default_21_ShadowGlow
		labelText			""
		allcaps				1
		textAlignment		west
		textinsetx			0
		fgcolor_override 	"254 93 80 255"
		//bgcolor_override 	"0 0 255 128"

		pin_to_sibling				deathRecapWeaponIcon_0
		pin_corner_to_sibling		LEFT
		pin_to_sibling_corner		RIGHT
	}

	deathRecap_Column2_Row3
	{
		ControlName			Label
		zpos				1014
		wide				405
		tall				27
		visible				0
		font				Default_21_ShadowGlow
		labelText			""
		allcaps				1
		textAlignment		west
		textinsetx			0
		fgcolor_override 	"254 93 80 255"
		//bgcolor_override 	"255 255 0 128"

		pin_to_sibling				deathRecapWeaponIcon_0
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}

	deathRecapWeaponIcon_1
	{
		ControlName			ImagePanel
		ypos				0
		wide				27
		tall				27
		visible				0
		image				vgui/white
		scaleImage			1

		pin_to_sibling				deathRecap_Column2_Row3
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT

		zpos			1014
	}

	deathRecap_Column2_Row4
	{
		ControlName			Label
		zpos				1014
		wide				330
		tall				27
		visible				0
		font				Default_21_ShadowGlow
		labelText			""
		allcaps				1
		textAlignment		west
		textinsetx			0
		fgcolor_override 	"254 93 80 255"
		//bgcolor_override 	"255 0 255 128"

		pin_to_sibling				deathRecapWeaponIcon_1
		pin_corner_to_sibling		LEFT
		pin_to_sibling_corner		RIGHT
	}

	deathRecap_Column2_Row5
	{
		ControlName			Label
		zpos				1014
		wide				405
		tall				27
		visible				0
		font				Default_21_ShadowGlow
		labelText			""
		allcaps				1
		textAlignment		west
		textinsetx			0
		fgcolor_override 	"254 93 80 255"
		//bgcolor_override 	"255 0 255 128"

		pin_to_sibling				deathRecapWeaponIcon_1
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}

	deathRecap_Column2_Row6
	{
		ControlName			Label
		zpos				1014
		wide				259
		tall				27
		visible				0
		font				Default_21_ShadowGlow
		labelText			""
		allcaps				1
		textAlignment		west
		textinsetx			0
		fgcolor_override 	"254 93 80 255"
		//bgcolor_override 	"255 0 255 128"

		pin_to_sibling				deathRecap_Column2_Row5
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}

	deathRecap_HealthStatus_Assister
	{
		ControlName			Label
		zpos				1014
		wide				90
		tall				27
		visible				0
		font				Default_21_ShadowGlow
		labelText			""
		allcaps				1
		textAlignment		west
		textinsetx			0
		fgcolor_override 	"0 0 0 255"
		//bgcolor_override 	"255 0 255 128"

		pin_to_sibling				deathRecap_Column2_Row6
		pin_corner_to_sibling		LEFT
		pin_to_sibling_corner		RIGHT
	}

	deathRecapWeaponIcon_2
	{
		ControlName			ImagePanel
		xpos				0
		ypos				0
		wide				27
		tall				27
		visible				0
		image				vgui/white
		scaleImage			1

		pin_to_sibling				deathRecap_Column2_Row6
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT

		zpos			1014
	}

	deathRecap_Column2_Row7
	{
		ControlName			Label
		zpos				1014
		wide				330
		tall				27
		visible				0
		font				Default_21_ShadowGlow
		labelText			""
		allcaps				1
		textAlignment		west
		textinsetx			0
		fgcolor_override 	"220 220 220 255"
		//bgcolor_override 	"255 0 255 128"

		pin_to_sibling				deathRecapWeaponIcon_2
		pin_corner_to_sibling		LEFT
		pin_to_sibling_corner		RIGHT
	}

	deathRecap_Column2_Row8
	{
		ControlName			Label
		zpos				1014
		wide				330
		tall				27
		visible				0
		font				Default_21_ShadowGlow
		labelText			""
		allcaps				1
		textAlignment		west
		textinsetx			0
		fgcolor_override 	"254 93 80 255"
		//bgcolor_override 	"255 0 255 128"

		pin_to_sibling				deathRecapWeaponIcon_2
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}
}
