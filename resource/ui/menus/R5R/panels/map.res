"scripts/resource/ui/menus/R5R/panels/map.res"
{
	"DarkenBackground"
	{
		"ControlName"			"Label"
		"xpos"					"550"
		"ypos"					"0"
		"zpos"					"0"
		"wide"					"f0"
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
		"ypos"					"0"
		"zpos"					"0"
		"wide"					"30"
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
		"xpos"					"1"
		"ypos"					"0"
		"zpos"					"0"
		"wide"					"490"
		"tall"					"40"
		"labelText"				""
		"bgcolor_override"		"30 30 30 150"
		"visible"				"1"
		"paintbackground"		"1"

		"pin_to_sibling"		"PanelBG"
		"pin_corner_to_sibling"	"BOTTOM"
		"pin_to_sibling_corner"	"TOP"
	}

	"PanelTopText"
	{
		"ControlName"			"Label"
		"labelText"				"Maps"
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

	"MapImg0"
	{
		"ControlName"			"RuiPanel"
		"wide"					"320"
		"tall"            		"180"
		"visible"				"0"
		"rui"           		"ui/custom_loadscreen_image.rpak"
		"ypos" 					"-5"
		"xpos"					"-5"
		"zpos" 					"1"
		"classname"				"mapimages"

		"pin_to_sibling"		"PanelBG"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"TOP_LEFT"
	}

	"MapImg1"
	{
		"ControlName"			"RuiPanel"
		"wide"					"320"
		"tall"            		"180"
		"visible"				"0"
		"rui"           		"ui/custom_loadscreen_image.rpak"
		"ypos" 					"5"
		"xpos"					"0"
		"zpos" 					"1"
		"classname"				"mapimages"

		"pin_to_sibling"		"MapImg0"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"BOTTOM_LEFT"
	}

	"MapImg2"
	{
		"ControlName"			"RuiPanel"
		"wide"					"320"
		"tall"            		"180"
		"visible"				"0"
		"rui"           		"ui/custom_loadscreen_image.rpak"
		"ypos" 					"5"
		"xpos"					"0"
		"zpos" 					"1"
		"classname"				"mapimages"

		"pin_to_sibling"		"MapImg1"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"BOTTOM_LEFT"
	}

	"MapImg3"
	{
		"ControlName"			"RuiPanel"
		"wide"					"320"
		"tall"            		"180"
		"visible"				"0"
		"rui"           		"ui/custom_loadscreen_image.rpak"
		"ypos" 					"5"
		"xpos"					"0"
		"zpos" 					"1"
		"classname"				"mapimages"

		"pin_to_sibling"		"MapImg2"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"BOTTOM_LEFT"
	}

	"MapImg4"
	{
		"ControlName"			"RuiPanel"
		"wide"					"320"
		"tall"           		"180"
		"visible"				"0"
		"rui"           		"ui/custom_loadscreen_image.rpak"
		"ypos" 					"0"
		"xpos"					"5"
		"zpos" 					"1"
		"classname"				"mapimages"

		"pin_to_sibling"		"MapImg0"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"TOP_RIGHT"
	}

	"MapImg5"
	{
		"ControlName"			"RuiPanel"
		"wide"					"320"
		"tall"            		"180"
		"visible"				"0"
		"rui"           		"ui/custom_loadscreen_image.rpak"
		"ypos" 					"5"
		"xpos"					"0"
		"zpos" 					"1"
		"classname"				"mapimages"

		"pin_to_sibling"		"MapImg4"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"BOTTOM_LEFT"
	}

	"MapImg6"
	{
		"ControlName"			"RuiPanel"
		"wide"					"320"
		"tall"            		"180"
		"visible"				"0"
		"rui"           		"ui/custom_loadscreen_image.rpak"
		"ypos" 					"5"
		"xpos"					"0"
		"zpos" 					"1"
		"classname"				"mapimages"

		"pin_to_sibling"		"MapImg5"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"BOTTOM_LEFT"
	}

	"MapImg7"
	{
		"ControlName"			"RuiPanel"
		"wide"					"320"
		"tall"            		"180"
		"visible"				"0"
		"rui"           		"ui/custom_loadscreen_image.rpak"
		"ypos" 					"5"
		"xpos"					"0"
		"zpos" 					"1"
		"classname"				"mapimages"

		"pin_to_sibling"		"MapImg6"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"BOTTOM_LEFT"
	}

	"MapImg8"
	{
		"ControlName"			"RuiPanel"
		"wide"					"320"
		"tall"           		"180"
		"visible"				"0"
		"rui"           		"ui/custom_loadscreen_image.rpak"
		"ypos" 					"0"
		"xpos"					"5"
		"zpos" 					"1"
		"classname"				"mapimages"

		"pin_to_sibling"		"MapImg4"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"TOP_RIGHT"
	}

	"MapImg9"
	{
		"ControlName"			"RuiPanel"
		"wide"					"320"
		"tall"            		"180"
		"visible"				"0"
		"rui"           		"ui/custom_loadscreen_image.rpak"
		"ypos" 					"5"
		"xpos"					"0"
		"zpos" 					"1"
		"classname"				"mapimages"

		"pin_to_sibling"		"MapImg8"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"BOTTOM_LEFT"
	}

	"MapImg10"
	{
		"ControlName"			"RuiPanel"
		"wide"					"320"
		"tall"            		"180"
		"visible"				"0"
		"rui"           		"ui/custom_loadscreen_image.rpak"
		"ypos" 					"5"
		"xpos"					"0"
		"zpos" 					"1"
		"classname"				"mapimages"

		"pin_to_sibling"		"MapImg9"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"BOTTOM_LEFT"
	}

	"MapImg11"
	{
		"ControlName"			"RuiPanel"
		"wide"					"320"
		"tall"            		"180"
		"visible"				"0"
		"rui"           		"ui/custom_loadscreen_image.rpak"
		"ypos" 					"5"
		"xpos"					"0"
		"zpos" 					"1"
		"classname"				"mapimages"

		"pin_to_sibling"		"MapImg10"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"BOTTOM_LEFT"
	}

	"MapImg12"
	{
		"ControlName"			"RuiPanel"
		"wide"					"320"
		"tall"           		"180"
		"visible"				"0"
		"rui"           		"ui/custom_loadscreen_image.rpak"
		"ypos" 					"0"
		"xpos"					"5"
		"zpos" 					"1"
		"classname"				"mapimages"

		"pin_to_sibling"		"MapImg8"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"TOP_RIGHT"
	}

	"MapImg13"
	{
		"ControlName"			"RuiPanel"
		"wide"					"320"
		"tall"            		"180"
		"visible"				"0"
		"rui"           		"ui/custom_loadscreen_image.rpak"
		"ypos" 					"5"
		"xpos"					"0"
		"zpos" 					"1"
		"classname"				"mapimages"

		"pin_to_sibling"		"MapImg12"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"BOTTOM_LEFT"
	}

	"MapImg14"
	{
		"ControlName"			"RuiPanel"
		"wide"					"320"
		"tall"            		"180"
		"visible"				"0"
		"rui"           		"ui/custom_loadscreen_image.rpak"
		"ypos" 					"5"
		"xpos"					"0"
		"zpos" 					"1"
		"classname"				"mapimages"

		"pin_to_sibling"		"MapImg13"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"BOTTOM_LEFT"
	}

	"MapImg15"
	{
		"ControlName"			"RuiPanel"
		"wide"					"320"
		"tall"            		"180"
		"visible"				"0"
		"rui"           		"ui/custom_loadscreen_image.rpak"
		"ypos" 					"5"
		"xpos"					"0"
		"zpos" 					"1"
		"classname"				"mapimages"

		"pin_to_sibling"		"MapImg14"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"BOTTOM_LEFT"
	}


	"MapBtn0"
	{
		"ControlName" 			"RuiButton"
		"InheritProperties" 	"RuiSmallButton"
		"wide" 					"320"
		"tall" 					"180"
		"xpos" 					"0"
		"ypos" 					"0"
		"zpos" 					"10"
		"visible"				"0"
		"classname"				"mapbuttons"

		"image" 				"vgui/hud/white"
		"drawColor" 			"255 255 255 128"

		"pin_to_sibling" 		"MapImg0"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"MapBtn1"
	{
		"ControlName" 			"RuiButton"
		"InheritProperties" 	"RuiSmallButton"
		"wide" 					"320"
		"tall" 					"180"
		"xpos" 					"0"
		"ypos" 					"0"
		"zpos" 					"10"
		"visible"				"0"
		"classname"				"mapbuttons"

		"image" 				"vgui/hud/white"
		"drawColor" 			"255 255 255 128"

		"pin_to_sibling" 		"MapImg1"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"MapBtn2"
	{
		"ControlName" 			"RuiButton"
		"InheritProperties" 	"RuiSmallButton"
		"wide" 					"320"
		"tall" 					"180"
		"xpos" 					"0"
		"ypos" 					"0"
		"zpos" 					"10"
		"visible"				"0"
		"classname"				"mapbuttons"

		"image" 				"vgui/hud/white"
		"drawColor" 			"255 255 255 128"

		"pin_to_sibling" 		"MapImg2"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	MapBtn3
	{
		"ControlName" 			"RuiButton"
		"InheritProperties" 	"RuiSmallButton"
		"wide" 					"320"
		"tall" 					"180"
		"xpos" 					"0"
		"ypos" 					"0"
		"zpos" 					"10"
		"visible"				"0"
		"classname"				"mapbuttons"

		"image" 				"vgui/hud/white"
		"drawColor" 			"255 255 255 128"

		"pin_to_sibling" 		"MapImg3"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"MapBtn4"
	{
		"ControlName" 			"RuiButton"
		"InheritProperties" 	"RuiSmallButton"
		"wide" 					"320"
		"tall" 					"180"
		"xpos" 					"0"
		"ypos" 					"0"
		"zpos" 					"10"
		"visible"				"0"
		"classname"				"mapbuttons"

		"image" 				"vgui/hud/white"
		"drawColor" 			"255 255 255 128"

		"pin_to_sibling" 		"MapImg4"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"MapBtn5"
	{
		"ControlName" 			"RuiButton"
		"InheritProperties" 	"RuiSmallButton"
		"wide" 					"320"
		"tall" 					"180"
		"xpos" 					"0"
		"ypos" 					"0"
		"zpos" 					"10"
		"visible"				"0"
		"classname"				"mapbuttons"

		"image" 				"vgui/hud/white"
		"drawColor" 			"255 255 255 128"

		"pin_to_sibling" 		"MapImg5"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"MapBtn6"
	{
		"ControlName" 			"RuiButton"
		"InheritProperties" 	"RuiSmallButton"
		"wide" 					"320"
		"tall" 					"180"
		"xpos" 					"0"
		"ypos" 					"0"
		"zpos" 					"10"
		"visible"				"0"
		"classname"				"mapbuttons"

		"image" 				"vgui/hud/white"
		"drawColor" 			"255 255 255 128"

		"pin_to_sibling" 		"MapImg6"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"MapBtn7"
	{
		"ControlName" 			"RuiButton"
		"InheritProperties" 	"RuiSmallButton"
		"wide" 					"320"
		"tall" 					"180"
		"xpos" 					"0"
		"ypos" 					"0"
		"zpos" 					"10"
		"visible"				"0"
		"classname"				"mapbuttons"

		"image" 				"vgui/hud/white"
		"drawColor" 			"255 255 255 128"

		"pin_to_sibling" 		"MapImg7"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"MapBtn8"
	{
		"ControlName" 			"RuiButton"
		"InheritProperties" 	"RuiSmallButton"
		"wide" 					"320"
		"tall" 					"180"
		"xpos" 					"0"
		"ypos" 					"0"
		"zpos" 					"10"
		"visible"				"0"
		"classname"				"mapbuttons"

		"image" 				"vgui/hud/white"
		"drawColor" 			"255 255 255 128"

		"pin_to_sibling" 		"MapImg8"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"MapBtn9"
	{
		"ControlName" 			"RuiButton"
		"InheritProperties" 	"RuiSmallButton"
		"wide" 					"320"
		"tall" 					"180"
		"xpos" 					"0"
		"ypos" 					"0"
		"zpos" 					"10"
		"visible"				"0"
		"classname"				"mapbuttons"

		"image" 				"vgui/hud/white"
		"drawColor" 			"255 255 255 128"

		"pin_to_sibling" 		"MapImg9"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"MapBtn10"
	{
		"ControlName" 			"RuiButton"
		"InheritProperties" 	"RuiSmallButton"
		"wide" 					"320"
		"tall" 					"180"
		"xpos" 					"0"
		"ypos" 					"0"
		"zpos" 					"10"
		"visible"				"0"
		"classname"				"mapbuttons"

		"image" 				"vgui/hud/white"
		"drawColor" 			"255 255 255 128"

		"pin_to_sibling" 		"MapImg10"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"MapBtn11"
	{
		"ControlName" 			"RuiButton"
		"InheritProperties" 	"RuiSmallButton"
		"wide" 					"320"
		"tall" 					"180"
		"xpos" 					"0"
		"ypos" 					"0"
		"zpos" 					"10"
		"visible"				"0"
		"classname"				"mapbuttons"

		"image" 				"vgui/hud/white"
		"drawColor" 			"255 255 255 128"

		"pin_to_sibling" 		"MapImg11"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"MapBtn12"
	{
		"ControlName" 			"RuiButton"
		"InheritProperties" 	"RuiSmallButton"
		"wide" 					"320"
		"tall" 					"180"
		"xpos" 					"0"
		"ypos" 					"0"
		"zpos" 					"10"
		"visible"				"0"
		"classname"				"mapbuttons"

		"image" 				"vgui/hud/white"
		"drawColor" 			"255 255 255 128"

		"pin_to_sibling" 		"MapImg12"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"MapBtn13"
	{
		"ControlName" 			"RuiButton"
		"InheritProperties" 	"RuiSmallButton"
		"wide" 					"320"
		"tall" 					"180"
		"xpos" 					"0"
		"ypos" 					"0"
		"zpos" 					"10"
		"visible"				"0"
		"classname"				"mapbuttons"

		"image" 				"vgui/hud/white"
		"drawColor" 			"255 255 255 128"

		"pin_to_sibling" 		"MapImg13"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"MapBtn14"
	{
		"ControlName" 			"RuiButton"
		"InheritProperties" 	"RuiSmallButton"
		"wide" 					"320"
		"tall" 					"180"
		"xpos" 					"0"
		"ypos" 					"0"
		"zpos" 					"10"
		"visible"				"0"
		"classname"				"mapbuttons"

		"image" 				"vgui/hud/white"
		"drawColor" 			"255 255 255 128"

		"pin_to_sibling" 		"MapImg14"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	MapBtn15
	{
		"ControlName" 			"RuiButton"
		"InheritProperties" 	"RuiSmallButton"
		"wide" 					"320"
		"tall" 					"180"
		"xpos" 					"0"
		"ypos" 					"0"
		"zpos" 					"10"
		"visible"				"0"
		"classname"				"mapbuttons"

		"image" 				"vgui/hud/white"
		"drawColor" 			"255 255 255 128"

		"pin_to_sibling" 		"MapImg15"
		"pin_corner_to_sibling" "CENTER"
		"pin_to_sibling_corner" "CENTER"
	}

	"MapText0"
	{
		"ControlName"			"Label"
		"labelText"				"Map Name"
		"font"					"DefaultBold_41"
		"allcaps"				"1"
		"auto_wide_tocontents"	"1"
		"zpos" 					"6"
		"fontHeight"			"25"
		"xpos"					"-15"
		"ypos"					"-15"
		"fgcolor_override"		"255 255 255 255"
		"visible"				"0"
		"classname"				"MapLabels"

		"pin_to_sibling" 		"MapImg0"
		"pin_corner_to_sibling" "TOP_LEFT"
		"pin_to_sibling_corner" "TOP_LEFT"
	}

	"MapText1"
	{
		"ControlName"			"Label"
		"labelText"				"Map Name"
		"font"					"DefaultBold_41"
		"allcaps"				"1"
		"auto_wide_tocontents"	"1"
		"zpos" 					"6"
		"fontHeight"			"25"
		"xpos"					"-15"
		"ypos"					"-15"
		"fgcolor_override"		"255 255 255 255"
		"visible"				"0"
		"classname"				"MapLabels"

		"pin_to_sibling" 		"MapImg1"
		"pin_corner_to_sibling" "TOP_LEFT"
		"pin_to_sibling_corner" "TOP_LEFT"
	}

	"MapText2"
	{
		"ControlName"			"Label"
		"labelText"				"Map Name"
		"font"					"DefaultBold_41"
		"allcaps"				"1"
		"auto_wide_tocontents"	"1"
		"zpos" 					"6"
		"fontHeight"			"25"
		"xpos"					"-15"
		"ypos"					"-15"
		"fgcolor_override"		"255 255 255 255"
		"visible"				"0"
		"classname"				"MapLabels"

		"pin_to_sibling" 		"MapImg2"
		"pin_corner_to_sibling" "TOP_LEFT"
		"pin_to_sibling_corner" "TOP_LEFT"
	}

	"MapText3"
	{
		"ControlName"			"Label"
		"labelText"				"Map Name"
		"font"					"DefaultBold_41"
		"allcaps"				"1"
		"auto_wide_tocontents"	"1"
		"zpos" 					"6"
		"fontHeight"			"25"
		"xpos"					"-15"
		"ypos"					"-15"
		"fgcolor_override"		"255 255 255 255"
		"visible"				"0"
		"classname"				"MapLabels"

		"pin_to_sibling" 		"MapImg3"
		"pin_corner_to_sibling" "TOP_LEFT"
		"pin_to_sibling_corner" "TOP_LEFT"
	}

	"MapText4"
	{
		"ControlName"			"Label"
		"labelText"				"Map Name"
		"font"					"DefaultBold_41"
		"allcaps"				"1"
		"auto_wide_tocontents"	"1"
		"zpos" 					"6"
		"fontHeight"			"25"
		"xpos"					"-15"
		"ypos"					"-15"
		"fgcolor_override"		"255 255 255 255"
		"visible"				"0"
		"classname"				"MapLabels"

		"pin_to_sibling" 		"MapImg4"
		"pin_corner_to_sibling" "TOP_LEFT"
		"pin_to_sibling_corner" "TOP_LEFT"
	}

	"MapText5"
	{
		"ControlName"			"Label"
		"labelText"				"Map Name"
		"font"					"DefaultBold_41"
		"allcaps"				"1"
		"auto_wide_tocontents"	"1"
		"zpos" 					"6"
		"fontHeight"			"25"
		"xpos"					"-15"
		"ypos"					"-15"
		"fgcolor_override"		"255 255 255 255"
		"visible"				"0"
		"classname"				"MapLabels"

		"pin_to_sibling" 		"MapImg5"
		"pin_corner_to_sibling" "TOP_LEFT"
		"pin_to_sibling_corner" "TOP_LEFT"
	}

	"MapText6"
	{
		"ControlName"			"Label"
		"labelText"				"Map Name"
		"font"					"DefaultBold_41"
		"allcaps"				"1"
		"auto_wide_tocontents"	"1"
		"zpos" 					"6"
		"fontHeight"			"25"
		"xpos"					"-15"
		"ypos"					"-15"
		"fgcolor_override"		"255 255 255 255"
		"visible"				"0"
		"classname"				"MapLabels"

		"pin_to_sibling" 		"MapImg6"
		"pin_corner_to_sibling" "TOP_LEFT"
		"pin_to_sibling_corner" "TOP_LEFT"
	}

	"MapText7"
	{
		"ControlName"			"Label"
		"labelText"				"Map Name"
		"font"					"DefaultBold_41"
		"allcaps"				"1"
		"auto_wide_tocontents"	"1"
		"zpos" 					"6"
		"fontHeight"			"25"
		"xpos"					"-15"
		"ypos"					"-15"
		"fgcolor_override"		"255 255 255 255"
		"visible"				"0"
		"classname"				"MapLabels"

		"pin_to_sibling" 		"MapImg7"
		"pin_corner_to_sibling" "TOP_LEFT"
		"pin_to_sibling_corner" "TOP_LEFT"
	}

	"MapText8"
	{
		"ControlName"			"Label"
		"labelText"				"Map Name"
		"font"					"DefaultBold_41"
		"allcaps"				"1"
		"auto_wide_tocontents"	"1"
		"zpos" 					"6"
		"fontHeight"			"25"
		"xpos"					"-15"
		"ypos"					"-15"
		"fgcolor_override"		"255 255 255 255"
		"visible"				"0"
		"classname"				"MapLabels"

		"pin_to_sibling" 		"MapImg8"
		"pin_corner_to_sibling" "TOP_LEFT"
		"pin_to_sibling_corner" "TOP_LEFT"
	}

	"MapText9"
	{
		"ControlName"			"Label"
		"labelText"				"Map Name"
		"font"					"DefaultBold_41"
		"allcaps"				"1"
		"auto_wide_tocontents"	"1"
		"zpos" 					"6"
		"fontHeight"			"25"
		"xpos"					"-15"
		"ypos"					"-15"
		"fgcolor_override"		"255 255 255 255"
		"visible"				"0"
		"classname"				"MapLabels"

		"pin_to_sibling" 		"MapImg9"
		"pin_corner_to_sibling" "TOP_LEFT"
		"pin_to_sibling_corner" "TOP_LEFT"
	}

	"MapText10"
	{
		"ControlName"			"Label"
		"labelText"				"Map Name"
		"font"					"DefaultBold_41"
		"allcaps"				"1"
		"auto_wide_tocontents"	"1"
		"zpos" 					"6"
		"fontHeight"			"25"
		"xpos"					"-15"
		"ypos"					"-15"
		"fgcolor_override"		"255 255 255 255"
		"visible"				"0"
		"classname"				"MapLabels"

		"pin_to_sibling" 		"MapImg10"
		"pin_corner_to_sibling" "TOP_LEFT"
		"pin_to_sibling_corner" "TOP_LEFT"
	}

	"MapText11"
	{
		"ControlName"			"Label"
		"labelText"				"Map Name"
		"font"					"DefaultBold_41"
		"allcaps"				"1"
		"auto_wide_tocontents"	"1"
		"zpos" 					"6"
		"fontHeight"			"25"
		"xpos"					"-15"
		"ypos"					"-15"
		"fgcolor_override"		"255 255 255 255"
		"visible"				"0"
		"classname"				"MapLabels"

		"pin_to_sibling" 		"MapImg11"
		"pin_corner_to_sibling" "TOP_LEFT"
		"pin_to_sibling_corner" "TOP_LEFT"
	}

	"MapText12"
	{
		"ControlName"			"Label"
		"labelText"				"Map Name"
		"font"					"DefaultBold_41"
		"allcaps"				"1"
		"auto_wide_tocontents"	"1"
		"zpos" 					"6"
		"fontHeight"			"25"
		"xpos"					"-15"
		"ypos"					"-15"
		"fgcolor_override"		"255 255 255 255"
		"visible"				"0"
		"classname"				"MapLabels"

		"pin_to_sibling" 		"MapImg12"
		"pin_corner_to_sibling" "TOP_LEFT"
		"pin_to_sibling_corner" "TOP_LEFT"
	}

	"MapText13"
	{
		"ControlName"			"Label"
		"labelText"				"Map Name"
		"font"					"DefaultBold_41"
		"allcaps"				"1"
		"auto_wide_tocontents"	"1"
		"zpos" 					"6"
		"fontHeight"			"25"
		"xpos"					"-15"
		"ypos"					"-15"
		"fgcolor_override"		"255 255 255 255"
		"visible"				"0"
		"classname"				"MapLabels"

		"pin_to_sibling" 		"MapImg13"
		"pin_corner_to_sibling" "TOP_LEFT"
		"pin_to_sibling_corner" "TOP_LEFT"
	}

	"MapText14"
	{
		"ControlName"			"Label"
		"labelText"				"Map Name"
		"font"					"DefaultBold_41"
		"allcaps"				"1"
		"auto_wide_tocontents"	"1"
		"zpos" 					"6"
		"fontHeight"			"25"
		"xpos"					"-15"
		"ypos"					"-15"
		"fgcolor_override"		"255 255 255 255"
		"visible"				"0"
		"classname"				"MapLabels"

		"pin_to_sibling" 		"MapImg14"
		"pin_corner_to_sibling" "TOP_LEFT"
		"pin_to_sibling_corner" "TOP_LEFT"
	}

	"MapText15"
	{
		"ControlName"			"Label"
		"labelText"				"Map Name"
		"font"					"DefaultBold_41"
		"allcaps"				"1"
		"auto_wide_tocontents"	"1"
		"zpos" 					"6"
		"fontHeight"			"25"
		"xpos"					"-15"
		"ypos"					"-15"
		"fgcolor_override"		"255 255 255 255"
		"visible"				"0"
		"classname"				"MapLabels"

		"pin_to_sibling" 		"MapImg15"
		"pin_corner_to_sibling" "TOP_LEFT"
		"pin_to_sibling_corner" "TOP_LEFT"
	}
}

