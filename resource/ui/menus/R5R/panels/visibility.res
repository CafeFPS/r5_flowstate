"scripts/resource/ui/menus/R5R/panels/visibility.res"
{
	"DarkenBackground"
	{
		"ControlName"			"Label"
		"xpos"					"0"
		"ypos"					"0"
		"zpos"					"0"
		"wide"					"500"
		"tall"					"220"
		"labelText"				""
		"bgcolor_override"		"0 0 0 200"
		"visible"				"0"
		"paintbackground"		"1"
	}

	"PanelTopBG"
	{
		"ControlName"			"Label"
		"xpos"					"0"
		"ypos"					"0"
		"zpos"					"0"
		"wide"					"470"
		"tall"					"40"
		"labelText"				""
		"bgcolor_override"		"195 29 38 220"
		"visible"				"1"
		"paintbackground"		"1"

		"pin_to_sibling"		"DarkenBackground"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"TOP_LEFT"
	}

	"PanelBG"
	{
		"ControlName"			"Label"
		"xpos"					"0"
		"ypos"					"0"
		"zpos"					"0"
		"wide"					"470"
		"tall"					"155"
		"labelText"				""
		"bgcolor_override"		"50 50 50 200"
		"visible"				"1"
		"paintbackground"		"1"

		"pin_to_sibling"		"PanelTopBG"
		"pin_corner_to_sibling"	"TOP"
		"pin_to_sibling_corner"	"BOTTOM"
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

	VisList
	{
		ControlName				GridButtonListPanel
		xpos                    0
		ypos                    -2
		columns                 1
		rows                    3
		buttonSpacing           2
		scrollbarSpacing        6
		scrollbarOnLeft         0
		setUnusedScrollbarInvisible 0
		visible					1
		tabPosition             1
		selectOnDpadNav         1

		ButtonSettings
		{
			rui                     "ui/generic_item_button.rpak"
			clipRui                 1
			wide					470
			tall					50
			cursorVelocityModifier  0.7
			rightClickEvents		1
			doubleClickEvents       1
			sound_focus             "UI_Menu_Focus_Small"
			sound_accept            ""
			sound_deny              ""
		}

		pin_to_sibling				PanelBG
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}
}
