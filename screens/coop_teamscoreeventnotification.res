Coop_TeamScoreEventNotification.res
{
	Coop_TeamScoreEventNotification_Anchor
	{
		ControlName					Label
		xpos						0
		ypos						0
		wide						%100
		tall						%100
		visible						0
		proportionalToParent		1
	}
	Coop_TeamScoreEventNotification_BG
	{
		ControlName			ImagePanel
		zpos				1012
		wide				450
		tall				36
		image				"vgui/hud/coop/wave_callout_strip"
		visible				0
		enable				1
		scaleImage			1

		pin_to_sibling				Coop_TeamScoreEventNotification_Anchor
		pin_corner_to_sibling		CENTER
		pin_to_sibling_corner		CENTER
	}

	Coop_TeamScoreEventNotification_FG
	{
		ControlName			ImagePanel
		zpos				1012
		wide				450
		tall				38
		image				"vgui/hud/coop/wave_callout_strip_lines"
		visible				0
		enable				1
		scaleImage			1

		pin_to_sibling				Coop_TeamScoreEventNotification_BG
		pin_corner_to_sibling		CENTER
		pin_to_sibling_corner		CENTER
	}

	Coop_TeamScoreEventNotification_EventValue
	{
		ControlName			Label
		zpos				1014
		xpos 				-27
		wide 				81
		tall				36
		visible				0
		font				Default_21_ShadowGlow
		labelText			"+200"
		allcaps				1
		textAlignment		east
		fgcolor_override 	"230 230 230 255"
		//bgcolor_override 	"0 255 255 128"

		pin_to_sibling				Coop_TeamScoreEventNotification_BG
		pin_corner_to_sibling		RIGHT
		pin_to_sibling_corner		RIGHT
	}

	Coop_TeamScoreEventNotification_EventName
	{
		ControlName			Label
		zpos				1014
		xpos 				-72
		wide 				247
		tall				36
		visible				0
		font				Default_21_ShadowGlow
		labelText			"HARVESTER HEALTH"
		allcaps				1
		textAlignment		west
		fgcolor_override 	"230 230 230 255"
		//bgcolor_override 	"0 255 0 128"

		pin_to_sibling				Coop_TeamScoreEventNotification_BG
		pin_corner_to_sibling		RIGHT
		pin_to_sibling_corner		RIGHT
	}

	Coop_TeamScoreEventNotification_Icon
	{
		ControlName			ImagePanel
		zpos				1014
		xpos 				-22
		wide				27
		tall				27
		visible				0
		image				vgui/white
		scaleImage			1

		pin_to_sibling				Coop_TeamScoreEventNotification_BG
		pin_corner_to_sibling		RIGHT
		pin_to_sibling_corner		RIGHT
	}

	Coop_TeamScoreEventNotification_Flare
	{
		ControlName			ImagePanel
		zpos				1012
		wide				450
		tall				36
		image				"vgui/hud/coop/score_notification_flare"
		visible				0
		enable				1
		scaleImage			1

		pin_to_sibling				Coop_TeamScoreEventNotification_BG
		pin_corner_to_sibling		CENTER
		pin_to_sibling_corner		CENTER
	}
}