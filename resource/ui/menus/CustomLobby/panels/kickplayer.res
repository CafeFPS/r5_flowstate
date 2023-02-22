"scripts/resource/ui/menus/CustomLobby/panels/kickplayer.res"
{
	"DarkenBackground"
	{
		"ControlName"			"Label"
		"xpos"					"0"
		"ypos"					"0"
		"zpos"					"50"
		"wide"					"f0"
		"tall"					"f0"
		"bgcolor_override"		"50 50 50 200"
		"labelText"				""
		"visible"				"1"
		"paintbackground"		"1"
	}

	"PanelBG"
	{
		"ControlName"			"Label"
		"xpos"					"0"
		"ypos"					"0"
		"zpos"					"55"
		"wide"					"f0"
		"tall"					"350"
		"labelText"				""
		"bgcolor_override"		"25 25 25 150"
		"visible"				"1"
		"paintbackground"		"1"

		"pin_to_sibling"		"DarkenBackground"
		"pin_corner_to_sibling"	"LEFT"
		"pin_to_sibling_corner"	"LEFT"
	}

	KickTopMessage
	{
		ControlName				Label
		labelText				"Player Options"
		"font"					"DefaultBold_41"
		"allcaps"				"1"
		auto_wide_tocontents	1
		zpos 					71
		fontHeight				40
		xpos					0
		ypos					-25
		"fgcolor_override"		"255 255 255 255"

		"pin_to_sibling"		"PanelBG"
		"pin_corner_to_sibling"	"TOP"
		"pin_to_sibling_corner"	"TOP"
	}

	SetPlayerKickMessage
	{
		ControlName				Label
		labelText				"Are you sure you want to kick this player?"
		"font"					"DefaultBold_41"
		"allcaps"				"1"
		auto_wide_tocontents	1
		zpos 					71
		fontHeight				35
		xpos					0
		ypos					-25
		"fgcolor_override"		"255 255 255 255"

		"pin_to_sibling"		"PanelBG"
		"pin_corner_to_sibling"	"CENTER"
		"pin_to_sibling_corner"	"CENTER"
	}

	"PanelTopBG"
	{
		"ControlName"			"Label"
		"xpos"					"0"
		"ypos"					"0"
		"zpos"					"55"
		"wide"					"f0"
		"tall"					"3"
		"labelText"				""
		"bgcolor_override"		"195 29 38 200"
		"visible"				"1"
		"paintbackground"		"1"

		"pin_to_sibling"		"PanelBG"
		"pin_corner_to_sibling"	"BOTTOM"
		"pin_to_sibling_corner"	"TOP"
	}

	"PanelBottomBG"
	{
		"ControlName"			"Label"
		"xpos"					"0"
		"ypos"					"0"
		"zpos"					"55"
		"wide"					"f0"
		"tall"					"3"
		"labelText"				""
		"bgcolor_override"		"195 29 38 200"
		"visible"				"1"
		"paintbackground"		"1"

		"pin_to_sibling"		"PanelBG"
		"pin_corner_to_sibling"	"TOP"
		"pin_to_sibling_corner"	"BOTTOM"
	}

	BanPanel
	{
		ControlName RuiPanel
		wide 300
		tall 50
		xpos 0
		ypos -25

		rui "ui/control_options_description.rpak"

		visible 1
		zpos 70

		pin_to_sibling			PanelBG
		pin_corner_to_sibling	BOTTOM
		pin_to_sibling_corner	BOTTOM
	}

	BtnBan
	{
		ControlName RuiButton
		InheritProperties RuiSmallButton
		wide 300
		tall 50
		xpos 0
		ypos 0
		zpos 72
		scriptID 1


		pin_to_sibling BanPanel
		pin_corner_to_sibling CENTER
		pin_to_sibling_corner CENTER
	}

	BtnBanText
	{
		ControlName				Label
		labelText				"Ban"
		"font"					"DefaultBold_41"
		"allcaps"				"1"
		auto_wide_tocontents	1
		zpos 					71
		fontHeight				25
		xpos					0
		ypos					0
		"fgcolor_override"		"255 255 255 255"

		pin_to_sibling BanPanel
		pin_corner_to_sibling CENTER
		pin_to_sibling_corner CENTER
	}

	KickPanel
	{
		ControlName RuiPanel
		wide 300
		tall 50
		xpos 5
		ypos 0

		rui "ui/control_options_description.rpak"

		visible 1
		zpos 70

		pin_to_sibling			BanPanel
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_LEFT
	}

	BtnKick
	{
		ControlName RuiButton
		InheritProperties RuiSmallButton
		wide 300
		tall 50
		xpos 0
		ypos 0
		zpos 72
		scriptID 0


		pin_to_sibling KickPanel
		pin_corner_to_sibling CENTER
		pin_to_sibling_corner CENTER
	}

	BtnKickText
	{
		ControlName				Label
		labelText				"Kick"
		"font"					"DefaultBold_41"
		"allcaps"				"1"
		auto_wide_tocontents	1
		zpos 					71
		fontHeight				25
		xpos					0
		ypos					0
		"fgcolor_override"		"255 255 255 255"

		pin_to_sibling KickPanel
		pin_corner_to_sibling CENTER
		pin_to_sibling_corner CENTER
	}

	CancelPanel
	{
		ControlName RuiPanel
		wide 300
		tall 50
		xpos 5
		ypos 0

		rui "ui/control_options_description.rpak"

		visible 1
		zpos 70

		pin_to_sibling			BanPanel
		pin_corner_to_sibling	LEFT
		pin_to_sibling_corner	RIGHT
	}

	BtnCancel
	{
		ControlName RuiButton
		InheritProperties RuiSmallButton
		wide 300
		tall 50
		xpos 0
		ypos 0
		zpos 72


		pin_to_sibling CancelPanel
		pin_corner_to_sibling CENTER
		pin_to_sibling_corner CENTER
	}

	BtnCancelText
	{
		ControlName				Label
		labelText				"Cancel"
		"font"					"DefaultBold_41"
		"allcaps"				"1"
		auto_wide_tocontents	1
		zpos 					71
		fontHeight				25
		xpos					0
		ypos					0
		"fgcolor_override"		"255 255 255 255"

		pin_to_sibling CancelPanel
		pin_corner_to_sibling CENTER
		pin_to_sibling_corner CENTER
	}
}

