"scripts/resource/ui/menus/R5R/panels/playlist.res"
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
		"ypos"					"50"
		"zpos"					"0"
		"wide"					"490"
		"tall"					"745"
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
		"labelText"				"Playlists"
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

	"PlaylistPanel0"
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

	"PlaylistPanel1"
	{
		"ControlName" 			"RuiPanel"
		"wide" 					"480"
		"tall" 					"40"
		"xpos" 					"0"
		"ypos" 					"5"
		"zpos" 					"0"
		"rui" 					"ui/control_options_description.rpak"
		"visible" 				"0"

		"pin_to_sibling"		"PlaylistPanel0"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"BOTTOM_LEFT"
	}

	"PlaylistPanel2"
	{
		"ControlName" 			"RuiPanel"
		"wide" 					"480"
		"tall" 					"40"
		"xpos" 					"0"
		"ypos" 					"5"
		"zpos" 					"0"
		"rui" 					"ui/control_options_description.rpak"
		"visible" 				"0"

		"pin_to_sibling"		"PlaylistPanel1"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"BOTTOM_LEFT"
	}

	"PlaylistPanel3"
	{
		"ControlName" 			"RuiPanel"
		"wide" 					"480"
		"tall" 					"40"
		"xpos" 					"0"
		"ypos" 					"5"
		"zpos" 					"0"
		"rui" 					"ui/control_options_description.rpak"
		"visible" 				"0"

		"pin_to_sibling"		"PlaylistPanel2"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"BOTTOM_LEFT"
	}

	"PlaylistPanel4"
	{
		"ControlName" 			"RuiPanel"
		"wide" 					"480"
		"tall" 					"40"
		"xpos" 					"0"
		"ypos" 					"5"
		"zpos" 					"0"
		"rui" 					"ui/control_options_description.rpak"
		"visible" 				"0"

		"pin_to_sibling"		"PlaylistPanel3"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"BOTTOM_LEFT"
	}

	"PlaylistPanel5"
	{
		"ControlName" 			"RuiPanel"
		"wide" 					"480"
		"tall" 					"40"
		"xpos" 					"0"
		"ypos" 					"5"
		"zpos" 					"0"
		"rui" 					"ui/control_options_description.rpak"
		"visible" 				"0"

		"pin_to_sibling"		"PlaylistPanel4"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"BOTTOM_LEFT"
	}

	"PlaylistPanel6"
	{
		"ControlName" 			"RuiPanel"
		"wide" 					"480"
		"tall" 					"40"
		"xpos" 					"0"
		"ypos" 					"5"
		"zpos" 					"0"
		"rui" 					"ui/control_options_description.rpak"
		"visible" 				"0"

		"pin_to_sibling"		"PlaylistPanel5"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"BOTTOM_LEFT"
	}

	"PlaylistPanel7"
	{
		"ControlName" 			"RuiPanel"
		"wide" 					"480"
		"tall" 					"40"
		"xpos" 					"0"
		"ypos" 					"5"
		"zpos" 					"0"
		"rui" 					"ui/control_options_description.rpak"
		"visible" 				"0"

		"pin_to_sibling"		"PlaylistPanel6"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"BOTTOM_LEFT"
	}

	"PlaylistPanel8"
	{
		"ControlName" 			"RuiPanel"
		"wide" 					"480"
		"tall" 					"40"
		"xpos" 					"0"
		"ypos" 					"5"
		"zpos" 					"0"
		"rui" 					"ui/control_options_description.rpak"
		"visible" 				"0"

		"pin_to_sibling"		"PlaylistPanel7"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"BOTTOM_LEFT"
	}

	"PlaylistPanel9"
	{
		"ControlName" 			"RuiPanel"
		"wide" 					"480"
		"tall" 					"40"
		"xpos" 					"0"
		"ypos" 					"5"
		"zpos" 					"0"
		"rui" 					"ui/control_options_description.rpak"
		"visible" 				"0"

		"pin_to_sibling"		"PlaylistPanel8"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"BOTTOM_LEFT"
	}

	"PlaylistPanel10"
	{
		"ControlName" 			"RuiPanel"
		"wide" 					"480"
		"tall" 					"40"
		"xpos" 					"0"
		"ypos" 					"5"
		"zpos" 					"0"
		"rui" 					"ui/control_options_description.rpak"
		"visible" 				"0"

		"pin_to_sibling"		"PlaylistPanel9"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"BOTTOM_LEFT"
	}

	"PlaylistPanel11"
	{
		"ControlName" 			"RuiPanel"
		"wide" 					"480"
		"tall" 					"40"
		"xpos" 					"0"
		"ypos" 					"5"
		"zpos" 					"0"
		"rui" 					"ui/control_options_description.rpak"
		"visible" 				"0"

		"pin_to_sibling"		"PlaylistPanel10"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"BOTTOM_LEFT"
	}

	"PlaylistPanel12"
	{
		"ControlName" 			"RuiPanel"
		"wide" 					"480"
		"tall" 					"40"
		"xpos" 					"0"
		"ypos" 					"5"
		"zpos" 					"0"
		"rui" 					"ui/control_options_description.rpak"
		"visible" 				"0"

		"pin_to_sibling"		"PlaylistPanel11"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"BOTTOM_LEFT"
	}

	"PlaylistPanel13"
	{
		"ControlName" 			"RuiPanel"
		"wide" 					"480"
		"tall" 					"40"
		"xpos" 					"0"
		"ypos" 					"5"
		"zpos" 					"0"
		"rui" 					"ui/control_options_description.rpak"
		"visible" 				"0"

		"pin_to_sibling"		"PlaylistPanel12"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"BOTTOM_LEFT"
	}

	"PlaylistPanel14"
	{
		"ControlName" 			"RuiPanel"
		"wide" 					"480"
		"tall" 					"40"
		"xpos" 					"0"
		"ypos" 					"5"
		"zpos" 					"0"
		"rui" 					"ui/control_options_description.rpak"
		"visible" 				"0"

		"pin_to_sibling"		"PlaylistPanel13"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"BOTTOM_LEFT"
	}

	"PlaylistPanel15"
	{
		"ControlName" 			"RuiPanel"
		"wide" 					"480"
		"tall" 					"40"
		"xpos" 					"0"
		"ypos" 					"5"
		"zpos" 					"0"
		"rui" 					"ui/control_options_description.rpak"
		"visible" 				"0"

		"pin_to_sibling"		"PlaylistPanel14"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"BOTTOM_LEFT"
	}

	"PlaylistPanel16"
	{
		"ControlName" 			"RuiPanel"
		"wide" 					"480"
		"tall" 					"40"
		"xpos" 					"0"
		"ypos" 					"5"
		"zpos" 					"0"
		"rui" 					"ui/control_options_description.rpak"
		"visible" 				"0"

		"pin_to_sibling"		"PlaylistPanel15"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"BOTTOM_LEFT"
	}

	"PlaylistPanel17"
	{
		"ControlName" 			"RuiPanel"
		"wide" 					"480"
		"tall" 					"40"
		"xpos" 					"0"
		"ypos" 					"5"
		"zpos" 					"0"
		"rui" 					"ui/control_options_description.rpak"
		"visible" 				"0"

		"pin_to_sibling"		"PlaylistPanel16"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"BOTTOM_LEFT"
	}

	"PlaylistPanel18"
	{
		"ControlName" 			"RuiPanel"
		"wide" 					"480"
		"tall" 					"40"
		"xpos" 					"0"
		"ypos" 					"5"
		"zpos" 					"0"
		"rui" 					"ui/control_options_description.rpak"
		"visible" 				"0"

		"pin_to_sibling"		"PlaylistPanel17"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"BOTTOM_LEFT"
	}

	"PlaylistPanel19"
	{
		"ControlName" 			"RuiPanel"
		"wide" 					"480"
		"tall" 					"40"
		"xpos" 					"0"
		"ypos" 					"5"
		"zpos" 					"0"
		"rui" 					"ui/control_options_description.rpak"
		"visible" 				"0"

		"pin_to_sibling"		"PlaylistPanel18"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"BOTTOM_LEFT"
	}

	"PlaylistBtn0"
	{
		"ControlName" 			"RuiButton"
		"InheritProperties" 	"RuiSmallButton"
		"wide" 					"480"
		"tall" 					"40"
		"xpos" 					"0"
		"ypos" 					"0"
		"zpos" 					"6"
		"visible" 				"0"

		"pin_to_sibling" 		"PlaylistPanel0"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"PlaylistBtn1"
	{
		"ControlName" 			"RuiButton"
		"InheritProperties" 	"RuiSmallButton"
		"wide" 					"480"
		"tall" 					"40"
		"xpos" 					"0"
		"ypos" 					"0"
		"zpos" 					"6"
		"visible" 				"0"


		"pin_to_sibling" 		"PlaylistPanel1"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"PlaylistBtn2"
	{
		"ControlName" 			"RuiButton"
		"InheritProperties" 	"RuiSmallButton"
		"wide" 					"480"
		"tall" 					"40"
		"xpos" 					"0"
		"ypos" 					"0"
		"zpos" 					"6"
		"visible" 				"0"


		"pin_to_sibling" 		"PlaylistPanel2"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"PlaylistBtn3"
	{
		"ControlName" 			"RuiButton"
		"InheritProperties" 	"RuiSmallButton"
		"wide" 					"480"
		"tall" 					"40"
		"xpos" 					"0"
		"ypos" 					"0"
		"zpos" 					"6"
		"visible" 				"0"


		"pin_to_sibling" 		"PlaylistPanel3"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"PlaylistBtn4"
	{
		"ControlName" 			"RuiButton"
		"InheritProperties" 	"RuiSmallButton"
		"wide" 					"480"
		"tall" 					"40"
		"xpos" 					"0"
		"ypos" 					"0"
		"zpos" 					"6"
		"visible" 				"0"


		"pin_to_sibling" 		"PlaylistPanel4"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"PlaylistBtn5"
	{
		"ControlName" 			"RuiButton"
		"InheritProperties" 	"RuiSmallButton"
		"wide" 					"480"
		"tall" 					"40"
		"xpos" 					"0"
		"ypos" 					"0"
		"zpos" 					"6"
		"visible" 				"0"


		"pin_to_sibling" 		"PlaylistPanel5"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"PlaylistBtn6"
	{
		"ControlName" 			"RuiButton"
		"InheritProperties" 	"RuiSmallButton"
		"wide" 					"480"
		"tall" 					"40"
		"xpos" 					"0"
		"ypos" 					"0"
		"zpos" 					"6"
		"visible" 				"0"


		"pin_to_sibling" 		"PlaylistPanel6"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"PlaylistBtn7"
	{
		"ControlName" 			"RuiButton"
		"InheritProperties" 	"RuiSmallButton"
		"wide" 					"480"
		"tall" 					"40"
		"xpos" 					"0"
		"ypos" 					"0"
		"zpos" 					"6"
		"visible" 				"0"


		"pin_to_sibling" 		"PlaylistPanel7"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"PlaylistBtn8"
	{
		"ControlName" 			"RuiButton"
		"InheritProperties" 	"RuiSmallButton"
		"wide" 					"480"
		"tall" 					"40"
		"xpos" 					"0"
		"ypos" 					"0"
		"zpos" 					"6"
		"visible" 				"0"


		"pin_to_sibling" 		"PlaylistPanel8"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"PlaylistBtn9"
	{
		"ControlName" 			"RuiButton"
		"InheritProperties" 	"RuiSmallButton"
		"wide" 					"480"
		"tall" 					"40"
		"xpos" 					"0"
		"ypos" 					"0"
		"zpos" 					"6"
		"visible" 				"0"


		"pin_to_sibling" 		"PlaylistPanel9"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"PlaylistBtn10"
	{
		"ControlName" 			"RuiButton"
		"InheritProperties" 	"RuiSmallButton"
		"wide" 					"480"
		"tall" 					"40"
		"xpos" 					"0"
		"ypos" 					"0"
		"zpos" 					"6"
		"visible" 				"0"


		"pin_to_sibling" 		"PlaylistPanel10"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"PlaylistBtn11"
	{
		"ControlName" 			"RuiButton"
		"InheritProperties" 	"RuiSmallButton"
		"wide" 					"480"
		"tall" 					"40"
		"xpos" 					"0"
		"ypos" 					"0"
		"zpos" 					"6"
		"visible" 				"0"


		"pin_to_sibling" 		"PlaylistPanel11"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"PlaylistBtn12"
	{
		"ControlName" 			"RuiButton"
		"InheritProperties" 	"RuiSmallButton"
		"wide" 					"480"
		"tall" 					"40"
		"xpos" 					"0"
		"ypos" 					"0"
		"zpos" 					"6"
		"visible" 				"0"


		"pin_to_sibling" 		"PlaylistPanel12"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"PlaylistBtn13"
	{
		"ControlName" 			"RuiButton"
		"InheritProperties" 	"RuiSmallButton"
		"wide" 					"480"
		"tall" 					"40"
		"xpos" 					"0"
		"ypos" 					"0"
		"zpos" 					"6"
		"visible" 				"0"


		"pin_to_sibling" 		"PlaylistPanel13"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"PlaylistBtn14"
	{
		"ControlName" 			"RuiButton"
		"InheritProperties" 	"RuiSmallButton"
		"wide" 					"480"
		"tall" 					"40"
		"xpos" 					"0"
		"ypos" 					"0"
		"zpos" 					"6"
		"visible" 				"0"


		"pin_to_sibling" 		"PlaylistPanel14"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"PlaylistBtn15"
	{
		"ControlName" 			"RuiButton"
		"InheritProperties" 	"RuiSmallButton"
		"wide" 					"480"
		"tall" 					"40"
		"xpos" 					"0"
		"ypos" 					"0"
		"zpos" 					"6"
		"visible" 				"0"


		"pin_to_sibling" 		"PlaylistPanel15"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"PlaylistBtn16"
	{
		"ControlName" 			"RuiButton"
		"InheritProperties" 	"RuiSmallButton"
		"wide" 					"480"
		"tall" 					"40"
		"xpos" 					"0"
		"ypos" 					"0"
		"zpos" 					"6"
		"visible" 				"0"


		"pin_to_sibling" 		"PlaylistPanel16"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"PlaylistBtn17"
	{
		"ControlName" 			"RuiButton"
		"InheritProperties" 	"RuiSmallButton"
		"wide" 					"480"
		"tall" 					"40"
		"xpos" 					"0"
		"ypos" 					"0"
		"zpos" 					"6"
		"visible" 				"0"


		"pin_to_sibling" 		"PlaylistPanel17"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"PlaylistBtn18"
	{
		"ControlName" 			"RuiButton"
		"InheritProperties" 	"RuiSmallButton"
		"wide" 					"480"
		"tall" 					"40"
		"xpos" 					"0"
		"ypos" 					"0"
		"zpos" 					"6"
		"visible" 				"0"


		"pin_to_sibling" 		"PlaylistPanel18"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"PlaylistBtn19"
	{
		"ControlName" 			"RuiButton"
		"InheritProperties" 	"RuiSmallButton"
		"wide" 					"480"
		"tall" 					"40"
		"xpos" 					"0"
		"ypos" 					"0"
		"zpos" 					"6"
		"visible" 				"0"


		"pin_to_sibling" 		"PlaylistPanel19"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"PlaylistText0"
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

		"pin_to_sibling" 		"PlaylistPanel0"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"PlaylistText1"
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

		"pin_to_sibling" 		"PlaylistPanel1"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"PlaylistText2"
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

		"pin_to_sibling" 		"PlaylistPanel2"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"PlaylistText3"
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

		"pin_to_sibling" 		"PlaylistPanel3"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"PlaylistText4"
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

		"pin_to_sibling" 		"PlaylistPanel4"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"PlaylistText5"
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

		"pin_to_sibling" 		"PlaylistPanel5"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"PlaylistText6"
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

		"pin_to_sibling" 		"PlaylistPanel6"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"PlaylistText7"
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

		"pin_to_sibling" 		"PlaylistPanel7"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"PlaylistText8"
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

		"pin_to_sibling" 		"PlaylistPanel8"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"PlaylistText9"
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

		"pin_to_sibling" 		"PlaylistPanel9"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"PlaylistText10"
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

		"pin_to_sibling" 		"PlaylistPanel10"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"PlaylistText11"
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

		"pin_to_sibling" 		"PlaylistPanel11"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"PlaylistText12"
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

		"pin_to_sibling" 		"PlaylistPanel12"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"PlaylistText13"
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

		"pin_to_sibling" 		"PlaylistPanel13"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"PlaylistText14"
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

		"pin_to_sibling" 		"PlaylistPanel14"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"PlaylistText15"
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

		"pin_to_sibling" 		"PlaylistPanel15"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"PlaylistText16"
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

		"pin_to_sibling" 		"PlaylistPanel16"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"PlaylistText17"
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

		"pin_to_sibling" 		"PlaylistPanel17"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"PlaylistText18"
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

		"pin_to_sibling" 		"PlaylistPanel18"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"PlaylistText19"
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

		"pin_to_sibling" 		"PlaylistPanel19"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}
}

