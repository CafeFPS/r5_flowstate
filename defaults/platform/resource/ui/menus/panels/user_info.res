"resource/ui/menus/user_info.menu"
{
	Background
	{
		ControlName 			RuiPanel
		wide					%28
		tall					500
		visible					1
		image 					"ui/menu/lobby/lobby_playlist_back_01"
		rui                     "ui/basic_border_box.rpak"
		scaleImage				1
	}

	Name
	{
		ControlName				Label
		ypos					0
		wide					%28
		tall					36
		textAlignment			"center"
		visible					0
		font 					DefaultBold_33
	}

    CallsignCard
    {
        ControlName				RuiPanel
        rui                     "ui/callsign_basic.rpak"
        pin_to_sibling          Background
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP
        wide                    320
        tall                    172
        ypos                    -8
        visible					1
        scaleImage				1
        image					vgui/white
        fillColor               "255 255 255 255"
    }

	XPLabel
	{
		ControlName				Label
		tall 					30
		labelText				"#COMMUNITY_XP_LABEL"
		wide					200
		font					Default_27
		textinsetx				11
		textinsety				1
		allcaps					1
		visible					1
		textAlignment			"east"
		fgcolor_override		"240 240 240 128"
		xpos					0
		ypos					208
		zpos					1
	}

	XP
	{
		ControlName				Label
		pin_to_sibling			XPLabel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		wide					292
		tall					30
		visible					1
		font 					Default_27
	}

	KillsLabel
	{
		ControlName				Label
		pin_to_sibling			XPLabel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		tall 					30
		wide					200
		labelText				"#COMMUNITY_KILLS_LABEL"
		font					Default_27
		textinsetx				11
		textinsety				1
		allcaps					1
		visible					1
		fgcolor_override		"240 240 240 128"
		textAlignment			"east"

		zpos					1
	}

	Kills
	{
		ControlName				Label
		pin_to_sibling			KillsLabel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		wide					292
		tall					30
		visible					1
		font 					Default_27
	}

	WinsLabel
	{
		ControlName				Label
		pin_to_sibling			KillsLabel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		tall 					30
		wide					200
		labelText				"#COMMUNITY_WINS_LABEL"
		font					Default_27
		textinsetx				11
		textinsety				1
		allcaps					1
		visible					1
		textAlignment			"east"
		fgcolor_override		"240 240 240 128"

		zpos					1
	}

	Wins
	{
		ControlName				Label
		pin_to_sibling			Kills
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		wide					292
		tall					30
		visible					1
		font 					Default_27
	}

	LossesLabel
	{
		ControlName				Label
		pin_to_sibling			Wins
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		tall 					30
		wide					1800
		labelText				"#COMMUNITY_LOSSES_LABEL"
		font					Default_27
		textinsetx				11
		textinsety				1
		textAlignment			"west"
		allcaps					1
		visible					0
		fgcolor_override		"240 240 240 128"

		zpos					1
	}

	Losses
	{
		ControlName				Label
		pin_to_sibling			LossesLabel
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_LEFT
		wide					292
		tall					30
		visible					0
		font 					Default_27
	}

	DeathsLabel
	{
		ControlName				Label
		pin_to_sibling			Kills
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		tall 					30
		wide					200
		labelText				"#COMMUNITY_DEATHS_LABEL"
		font					Default_27
		textinsetx				11
		textinsety				1
		allcaps					1
		visible					0
		fgcolor_override		"240 240 240 128"

		zpos					1
	}

	Deaths
	{
		ControlName				Label
		pin_to_sibling			Losses
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		wide					292
		tall					30
		visible					0
		font 					Default_27
	}

	Community0Label
	{
		ControlName				Label
		pin_to_sibling			WinsLabel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		tall 					30
		wide					200
		labelText				""
		font					Default_27
		textinsetx				11
		textinsety				1
		allcaps					1
		textAlignment			"east"
		visible					0
		fgcolor_override		"240 240 240 128"

		zpos					1
	}

	Community0
	{
		ControlName				Label
		pin_to_sibling			Community0Label
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		wide				    300
		tall					30
		visible					0
		font 					Default_27
	}

	Community1Label
	{
		ControlName				Label
		pin_to_sibling			Community0Label
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		tall 					30
		wide					200
		labelText				""
		font					Default_27
		textinsetx				11
		textinsety				1
		allcaps					1
		textAlignment			"east"
		visible					0
		fgcolor_override		"240 240 240 128"

		zpos					1
	}

	Community1
	{
		ControlName				Label
		pin_to_sibling			Community0
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		wide				    300
		tall					30
		visible					0
		font 					Default_27
	}

	Community2Label
	{
		ControlName				Label
		pin_to_sibling			Community1Label
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		tall 					30
		wide					200
		labelText				""
		font					Default_27
		textinsetx				11
		textinsety				1
		allcaps					1
		textAlignment			"east"
		visible					0
		fgcolor_override		"240 240 240 128"

		zpos					1
	}

	Community2
	{
		ControlName				Label
		pin_to_sibling			Community1
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		wide				    300
		tall					30
		visible					0
		font 					Default_27
	}

	Community3Label
	{
		ControlName				Label
		pin_to_sibling			Community2Label
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		tall 					30
		wide					200
		labelText				""
		font					Default_27
		textinsetx				11
		textinsety				1
		allcaps					1
		textAlignment				"east"
		visible					0
		fgcolor_override		"240 240 240 128"

		zpos					1
	}

	Community3
	{
		ControlName				Label
		pin_to_sibling				Community2
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			BOTTOM_LEFT
		wide				    300
		tall					30
		visible					0
		font 					Default_27
	}

	Community4Label
	{
		ControlName				Label
		pin_to_sibling			Community3Label
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		tall 					30
		wide					200
		labelText				""
		font					Default_27
		textinsetx				11
		textinsety				1
		allcaps					1
		textAlignment				"east"
		visible					0
		fgcolor_override		"240 240 240 128"

		zpos					1
	}

	Community4
	{
		ControlName				Label
		pin_to_sibling				Community3
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			BOTTOM_LEFT
		wide				    300
		tall					30
		visible					0
		font 					Default_27
	}

	Community5Label
	{
		ControlName				Label
		pin_to_sibling			Community4Label
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		tall 					30
		wide					200
		labelText				""
		font					Default_27
		textinsetx				11
		textinsety				1
		allcaps					1
		textAlignment				"east"
		visible					0
		fgcolor_override		"240 240 240 128"

		zpos					1
	}

	Community5
	{
		ControlName				Label
		pin_to_sibling				Community4
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			BOTTOM_LEFT
		wide				    300
		tall					30
		visible					0
		font 					Default_27
	}

	Community6Label
	{
		ControlName				Label
		pin_to_sibling			Community5Label
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		tall 					30
		wide					200
		labelText				""
		font					Default_27
		textinsetx				11
		textinsety				1
		allcaps					1
		textAlignment				"east"
		visible					0
		fgcolor_override		"240 240 240 128"

		zpos					1
	}

	Community6
	{
		ControlName				Label
		pin_to_sibling				Community5
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			BOTTOM_LEFT
		wide				    300
		tall					30
		visible					0
		font 					Default_27
	}

	Community7Label
	{
		ControlName				Label
		pin_to_sibling			Community6Label
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		tall 					30
		wide					200
		labelText				""
		font					Default_27
		textinsetx				11
		textinsety				1
		textAlignment				"east"
		allcaps					1
		visible					0
		fgcolor_override		"240 240 240 128"

		zpos					1
	}

	Community7
	{
		ControlName				Label
		pin_to_sibling				Community6
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			BOTTOM_LEFT
		wide				    300
		tall					30
		visible					0
		font 					Default_27
	}

	Community8Label
	{
		ControlName				Label
		pin_to_sibling			Community7Label
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		tall 					30
		wide					200
		labelText				""
		font					Default_27
		textinsetx				11
		textinsety				1
		textAlignment				"east"
		allcaps					1
		visible					0
		fgcolor_override		"240 240 240 128"

		zpos					1
	}

	Community8
	{
		ControlName				Label
		pin_to_sibling				Community7
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			BOTTOM_LEFT
		wide				    300
		tall					30
		visible					0
		font 					Default_27
	}

	ViewUserCard
	{
		ControlName		Button
		InheritProperties	DefaultButton
		xpos			250
		ypos			592
		wide			464
		tall			50
		consoleStyle		1
		navDown			Close
		autoResize		0
		pinCorner		0
		visible			0
		enabled			1
		tabPosition		0
		labelText		"#USER_VIEWUSERCARD"
		textAlignment		"west"
		wrap			0
		Default			0
		selected		0
		font 			Default_27
	}
}
