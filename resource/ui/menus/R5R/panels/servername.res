"scripts/resource/ui/menus/R5R/panels/visibility.res"
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

	SetServerNameTxt
	{
		ControlName				Label
		labelText				"Set Server Name"
		"font"					"DefaultBold_41"
		"allcaps"				"1"
		auto_wide_tocontents	1
		zpos 					71
		fontHeight				35
		xpos					0
		ypos					-60
		"fgcolor_override"		"255 255 255 255"

		"pin_to_sibling"		"PanelBG"
		"pin_corner_to_sibling"	"BOTTOM"
		"pin_to_sibling_corner"	"TOP"
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

	BtnServerName
	{
		ControlName				TextEntry
		zpos					100 // This works around input weirdness when the control is constructed by code instead of VGUI blackbox.
		wide					800
		tall					50
		xpos					0
		ypos					0
		zpos					70
		allowRightClickMenu		0
		allowSpecialCharacters	0
		unicode					0

		keyboardTitle			"Enter Server Name"
		keyboardDescription		"Enter Server Name"

		visible					1
		enabled					1
		textHidden				0
		editable				1
		maxchars				100
		textAlignment			"center"
		ruiFont                 TitleRegularFont
		ruiFontHeight           22
		ruiMinFontHeight        16
		bgcolor_override		"30 30 30 200"

		pin_to_sibling PanelBG
		pin_corner_to_sibling	CENTER
		pin_to_sibling_corner	CENTER
	}

	SavePanel
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

	BtnSaveName
	{
		ControlName RuiButton
		InheritProperties RuiSmallButton
		wide 300
		tall 50
		xpos 0
		ypos 0
		zpos 72


		pin_to_sibling SavePanel
		pin_corner_to_sibling CENTER
		pin_to_sibling_corner CENTER
	}

	BtnSaveText
	{
		ControlName				Label
		labelText				"Save"
		"font"					"DefaultBold_41"
		"allcaps"				"1"
		auto_wide_tocontents	1
		zpos 					71
		fontHeight				25
		xpos					0
		ypos					0
		"fgcolor_override"		"255 255 255 255"

		pin_to_sibling SavePanel
		pin_corner_to_sibling CENTER
		pin_to_sibling_corner CENTER
	}
}

