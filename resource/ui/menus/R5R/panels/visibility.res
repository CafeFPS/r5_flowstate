"scripts/resource/ui/menus/R5R/panels/visibility.res"
{
	"DarkenBackground"
	{
		"ControlName"			"Label"
		"xpos"					"550"
		"ypos"					"0"
		"zpos"					"0"
		"wide"					"500"
		"tall"					"935"
		"labelText"				""
		"bgcolor_override"		"0 0 0 200"
		"visible"				"0"
		"paintbackground"		"1"
	}

	"PanelBG"
	{
		"ControlName"			"Label"
		"xpos"					"0"
		"ypos"					"-250"
		"zpos"					"0"
		"wide"					"490"
		"tall"					"145"
		"labelText"				""
		"bgcolor_override"		"50 50 50 100"
		"visible"				"1"
		"paintbackground"		"1"

		"pin_to_sibling"		"DarkenBackground"
		"pin_corner_to_sibling"	"LEFT"
		"pin_to_sibling_corner"	"LEFT"
	}

	"PanelTopBG"
	{
		"ControlName"			"Label"
		"xpos"					"0"
		"ypos"					"0"
		"zpos"					"0"
		"wide"					"490"
		"tall"					"40"
		"labelText"				""
		"bgcolor_override"		"195 29 38 200"
		"visible"				"1"
		"paintbackground"		"1"

		"pin_to_sibling"		"PanelBG"
		"pin_corner_to_sibling"	"BOTTOM"
		"pin_to_sibling_corner"	"TOP"
	}

	"PanelTopText"
	{
		"ControlName"			"Label"
		"labelText"				"Visibility"
		"font"					"DefaultBold_41"
		"allcaps"				"1"
		"auto_wide_tocontents"	"1"
		"zpos" 					"3"
		"fontHeight"			"25"
		"xpos"					"0"
		"ypos"					"0"
		"fgcolor_override"		"255 255 255 255"
		"visible" 				"1"

		"pin_to_sibling" 		"PanelTopBG"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"VisPanel0"
	{
		"ControlName" 			"RuiPanel"
		"wide" 					"480"
		"tall" 					"40"
		"xpos" 					"-5"
		"ypos" 					"-5"
		"zpos" 					"0"
		"rui" 					"ui/control_options_description.rpak"
		"visible" 				"0"

		"pin_to_sibling"		"PanelBG"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"TOP_LEFT"
	}

	"VisPanel1"
	{
		"ControlName" 			"RuiPanel"
		"wide" 					"480"
		"tall" 					"40"
		"xpos" 					"0"
		"ypos" 					"5"
		"zpos" 					"0"
		"rui" 					"ui/control_options_description.rpak"
		"visible" 				"0"

		"pin_to_sibling"		"VisPanel0"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"BOTTOM_LEFT"
	}

	"VisPanel2"
	{
		"ControlName" 			"RuiPanel"
		"wide" 					"480"
		"tall" 					"40"
		"xpos" 					"0"
		"ypos" 					"5"
		"zpos" 					"0"
		"rui" 					"ui/control_options_description.rpak"
		"visible" 				"0"

		"pin_to_sibling"		"VisPanel1"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"BOTTOM_LEFT"
	}

	"VisBtn0"
	{
		"ControlName" 			"RuiButton"
		"InheritProperties" 	"RuiSmallButton"
		"wide" 					"480"
		"tall" 					"40"
		"xpos" 					"0"
		"ypos" 					"0"
		"zpos" 					"6"
		"visible" 				"0"


		"pin_to_sibling" 		"VisPanel0"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"VisBtn1"
	{
		"ControlName" 			"RuiButton"
		"InheritProperties" 	"RuiSmallButton"
		"wide" 					"480"
		"tall" 					"40"
		"xpos" 					"0"
		"ypos" 					"0"
		"zpos" 					"6"
		"visible" 				"0"


		"pin_to_sibling" 		"VisPanel1"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"VisBtn2"
	{
		"ControlName" 			"RuiButton"
		"InheritProperties" 	"RuiSmallButton"
		"wide" 					"480"
		"tall" 					"40"
		"xpos" 					"0"
		"ypos" 					"0"
		"zpos" 					"6"
		"visible" 				"0"


		"pin_to_sibling" 		"VisPanel2"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"VisText0"
	{
		"ControlName"			"Label"
		"labelText"				""
		"font"					"DefaultBold_41"
		"allcaps"				"1"
		"auto_wide_tocontents"	"1"
		"zpos" 					"3"
		"fontHeight"			"25"
		"xpos"					"0"
		"ypos"					"0"
		"fgcolor_override"		"255 255 255 255"
		"visible" 				"0"

		"pin_to_sibling" 		"VisPanel0"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"VisText1"
	{
		"ControlName"			"Label"
		"labelText"				""
		"font"					"DefaultBold_41"
		"allcaps"				"1"
		"auto_wide_tocontents"	"1"
		"zpos" 					"3"
		"fontHeight"			"25"
		"xpos"					"0"
		"ypos"					"0"
		"fgcolor_override"		"255 255 255 255"
		"visible" 				"0"

		"pin_to_sibling" 		"VisPanel1"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"VisText2"
	{
		"ControlName"			"Label"
		"labelText"				""
		"font"					"DefaultBold_41"
		"allcaps"				"1"
		"auto_wide_tocontents"	"1"
		"zpos" 					"3"
		"fontHeight"			"25"
		"xpos"					"0"
		"ypos"					"0"
		"fgcolor_override"		"255 255 255 255"
		"visible" 				"0"

		"pin_to_sibling" 		"VisPanel2"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}
}

