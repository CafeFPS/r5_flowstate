"scripts/resource/ui/menus/R5R/panels/matchstarting.res"
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

	TopMessage
	{
		ControlName				Label
		labelText				"Match Starting"
		"font"					"DefaultBold_41"
		"allcaps"				"1"
		auto_wide_tocontents	1
		zpos 					71
		fontHeight				40
		xpos					0
		ypos					-50
		"fgcolor_override"		"255 255 255 255"

		"pin_to_sibling"		"PanelBG"
		"pin_corner_to_sibling"	"TOP"
		"pin_to_sibling_corner"	"TOP"
	}

	MapAndGamemode
	{
		ControlName				Label
		labelText				"CUSTOM_TDM - MP_RR_BOX"
		"font"					"DefaultBold_41"
		"allcaps"				"1"
		auto_wide_tocontents	1
		zpos 					71
		fontHeight				40
		xpos					0
		ypos					50
		"fgcolor_override"		"200 200 200 255"

		"pin_to_sibling"		"TopMessage"
		"pin_corner_to_sibling"	"TOP"
		"pin_to_sibling_corner"	"BOTTOM"
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

	DialogSpinner
	{
		ControlName				RuiPanel
		InheritProperties		RuiDialogSpinner
		classname 				DialogSpinnerClass
		xpos					0
		ypos					75

		pin_to_sibling			PanelBG
		pin_corner_to_sibling	CENTER
		pin_to_sibling_corner	CENTER
	}

	Timer
	{
		ControlName				Label
		labelText				"5"
		"font"					"DefaultBold_41"
		"allcaps"				"1"
		auto_wide_tocontents	1
		zpos 					71
		fontHeight				35
		xpos					0
		ypos					0
		"fgcolor_override"		"255 255 255 255"

		"pin_to_sibling"		"DialogSpinner"
		"pin_corner_to_sibling"	"CENTER"
		"pin_to_sibling_corner"	"CENTER"
	}
}

