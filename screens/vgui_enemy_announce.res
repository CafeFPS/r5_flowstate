vgui_enemy_announce.res
{
	PreviewCard_background
	{
		ControlName			ImagePanel
		xpos				0
		ypos				0
		zpos				125

		wide				1061
		tall				135

		image				"vgui/hud/coop/wave_callout_strip"

		scaleImage			1
		drawColor			"255 255 255 255"
	}

	PreviewCard_backgroundOutline
	{
		ControlName			ImagePanel
		xpos				0
		ypos				0
		zpos				126

		wide				1061
		tall				135

		image				"vgui/hud/coop/wave_callout_strip_lines"

		scaleImage			1
		drawColor			"255 255 255 255"

		pin_to_sibling				PreviewCard_background
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}

	PreviewCard_HeaderBackground
	{
		ControlName			ImagePanel
		xpos				0
		ypos				0
		zpos				125

		wide				1061
		tall				135

		image				"vgui/hud/coop/wave_callout_hazard"

		scaleImage			1
		drawColor			"255 255 255 255"
	}

	PreviewCard_numEnemies
	{
		ControlName			Label
		xpos				-27
		ypos				0

		visible				0
		zpos				136
		wide				124
		tall				450
		labelText			"64"
		allCaps				1
		font				Default_69_Outline_DropShadow
		fgcolor_override 	"190 190 190 255"
		//bgcolor_override 	"120 0 0 255"
		//paintbackground 	1
		centerwrap			0
		textAlignment 		east

		pin_to_sibling				PreviewCard_background
		pin_corner_to_sibling		LEFT
		pin_to_sibling_corner		LEFT
	}

	PreviewCard_icon1
	{
		ControlName			ImagePanel
		xpos				4
		ypos				0
		zpos				135

		wide				126
		tall				126

		image				"ui/icon_status_titan_burn"

		scaleImage			1
		drawColor			"255 255 255 255"

		pin_to_sibling				PreviewCard_numEnemies
		pin_corner_to_sibling		LEFT
		pin_to_sibling_corner		RIGHT
	}

	// hacky- for "header" cards only this element is used
	PreviewCard_HeaderTitle
	{
		ControlName			Label
		xpos				-67
		ypos				0

		visible				0
		zpos				135
		wide				576
		tall				144
		labelText			"HEADER TITLE"
		allCaps				1
		font				DefaultBold_62_DropShadow
		fgcolor_override 	"235 235 235 235"
		centerwrap			0
		textAlignment 		west

		pin_to_sibling				PreviewCard_background
		pin_corner_to_sibling		LEFT
		pin_to_sibling_corner		LEFT
	}

	// hacky- for "footer" cards only this element is used
	PreviewCard_FooterTitle
	{
		ControlName				Label
		xpos					0
		ypos					0

		visible					0
		zpos					135
		//wide					562
		auto_wide_tocontents 	1
		textinsetx				27
		use_proportional_insets	1
		tall					63
		labelText				"#NEW_ENEMY_ANNOUNCE_HINT"
		allCaps					1
		font					Default_41_DropShadow
		fgcolor_override 		"190 190 190 235"
		bgcolor_override 		"0 0 0 150"
		paintbackground 		1
		centerwrap				0
		textAlignment 			center

		pin_to_sibling			PreviewCard_icon1
		pin_corner_to_sibling	LEFT
		pin_to_sibling_corner	RIGHT
	}

	PreviewCard_title
	{
		ControlName			Label
		xpos				9
		ypos				0

		visible				0
		zpos				135
		wide				742
		tall				54
		labelText			"TITLE"
		allCaps				1
		font				Default_51_Outline_DropShadow
		fgcolor_override 	"157 196 219 255"
		//bgcolor_override 	"0 120 0  255"
		//paintbackground 	1
		centerwrap			0
		textAlignment 		southwest

		pin_to_sibling				PreviewCard_icon1
		pin_corner_to_sibling		BOTTOM_LEFT
		pin_to_sibling_corner		RIGHT
	}

	PreviewCard_description
	{
		ControlName			Label
		xpos				9
		ypos				0

		visible				0
		zpos				135
		wide				742
		tall				54
		labelText			"TITLE"
		allCaps				0
		font				Default_41_DropShadow
		fgcolor_override 	"190 190 190 235"
		//bgcolor_override 	"120 0 0  255"
		//paintbackground 	1
		centerwrap			0
		textAlignment 		northwest

		pin_to_sibling				PreviewCard_icon1
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		RIGHT
	}
}
