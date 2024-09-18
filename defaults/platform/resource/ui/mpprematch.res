Resource/UI/MPPrematch.res
{
	Screen
	{
		ControlName			ImagePanel
		xpos				0
		ypos				0
		wide				%100
		tall				%100
		visible				1
		scaleImage			1
		zpos				1000
	}

	prematchTopBar
	{
		ControlName			ImagePanel
		xpos				0
		ypos				0
		wide				%100
		tall				%15
		visible				0
		image				vgui/HUD/black
		scaleImage			1

		pin_to_sibling				Screen
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}

	prematchBottomBar
	{
		ControlName			ImagePanel
		xpos				0
		ypos				0
		wide				%100
		tall				%15
		visible				0
		image				vgui/HUD/black
		scaleImage			1

		pin_to_sibling				Screen
		pin_corner_to_sibling		BOTTOM_RIGHT
		pin_to_sibling_corner		BOTTOM_RIGHT
	}

	prematchCountdownTimerText
	{
		ControlName			Label
		xpos				124
		ypos				0
		wide				72
		tall				72
		visible				0
		font				Default_34_ShadowGlow
		labelText			"3"
		textAlignment		west
		fgcolor_override 	"255 200 50 240"

		pin_to_sibling				prematchCountdownDescText
		pin_corner_to_sibling		CENTER
		pin_to_sibling_corner		CENTER
	}

	prematchCountdownTimerTextGlow
	{
		ControlName			Label
		xpos				124
		ypos				0
		wide				72
		tall				72
		visible				0
		font				Default_34_ShadowGlow
		labelText			"3"
		textAlignment		west
		fgcolor_override 	"255 200 50 240"

		pin_to_sibling				prematchCountdownDescText
		pin_corner_to_sibling		CENTER
		pin_to_sibling_corner		CENTER
	}

	prematchCountdownDescText
	{
		ControlName			Label
		xpos				0
		ypos				0
		wide				1151
		tall				72
		visible				0
		font				Default_31_ShadowGlow
		labelText			"#STARTING_IN"
		textAlignment		center
		fgcolor_override 	"255 255 255 255"

		pin_to_sibling				prematchTopBar
		pin_corner_to_sibling		BOTTOM
		pin_to_sibling_corner		BOTTOM
	}

	classicMPCountdownDescText
	{
		ControlName			Label
		xpos				0
		ypos				0
		wide				1151
		tall				72
		visible				0
		font				Default_34_ShadowGlow
		labelText			"#STARTING_IN"
		textAlignment		center
		fgcolor_override 	"255 255 255 255"
		zpos				10

		pin_to_sibling				Screen
		pin_corner_to_sibling		CENTER
		pin_to_sibling_corner		CENTER
	}

	gamescomWaitTillReady
	{
		ControlName			ImagePanel
		xpos				0
		ypos				0
		wide				%100
		tall				%100
		visible				0
		//image				"ui/menu/temp/prepare_titanfall"
		scaleImage			1
	}

	waitingForPlayersText
	{
		ControlName			Label
		xpos				180
		ypos				r175
		wide				1151
		tall				81
		visible				0
		font				Default_31_ShadowGlow
		labelText			"#HUD_WAITING_FOR_PLAYERS_BASIC"
		textAlignment		west
		fgcolor_override 	"255 255 255 255"

		zpos				5010
	}

	waitingForPlayersLine
	{
		ControlName			ImagePanel
		xpos				0
		ypos				-67
		wide				1151
		tall				36
		visible				0
		image				vgui/HUD/flare_thin
		scaleImage			1

		zpos				5000

		pin_to_sibling				Screen
		pin_corner_to_sibling		BOTTOM_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}

	waitingForPlayersTimer
	{
		ControlName			ImagePanel
		xpos				90
		ypos				r175
		wide				81
		tall				81
		visible				0
		enabled				1
		scaleImage			1
		image				"ui/icon_loading"
		frame				0

		zpos			5001
	}

	LoadOutIcon
	{
		ControlName			Label
		xpos				-54
		ypos				-49
		wide				144
		tall				36
		visible				0
		font				Default_21_ShadowGlow
		labelText			"WHY?"
		textAlignment		east
		//drawColor			"255 255 255 255" // using this instead of fgcolor_override causes HideOverTime to sometimes fail; investigate further
		fgcolor_override 	"255 255 255 255"

		zpos				10

		pin_to_sibling				SafeArea
		pin_corner_to_sibling		BOTTOM_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}

	LoadOutText
	{
		ControlName			Label
		xpos				-216
		ypos				-49
		wide				288
		tall				36
		visible				0
		font				Default_21_ShadowGlow
		labelText			"Select Loadout"
		textAlignment		west
		fgcolor_override 	"255 255 255 255"

		zpos				10

		pin_to_sibling				SafeArea
		pin_corner_to_sibling		BOTTOM_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}

	halfTimeText
	{
		ControlName			Label
		xpos				0
		ypos				-225
		wide				787
		tall				112
		visible				0
		font				DefaultBold_34
		labelText			"PLACEHOLDER TEXT"
		fgcolor_override 	"255 255 255 255"
		textAlignment	center

		pin_to_sibling				Screen
		pin_corner_to_sibling		CENTER
		pin_to_sibling_corner		CENTER
	}
}