"scripts/resource/ui/menus/R5R/lobbymenu.menu"
{
	menu
	{
		"ControlName"					"Frame"
		"xpos"							"0"
		"ypos"							"0"
		"zpos"							"3"
		"wide"							"f0"
		"tall"							"f0"
		"autoResize"					"0"
		"pinCorner"						"0"
		"visible"						"1"
		"enabled"						"1"
		"tabPosition"					"0"
		"PaintBackgroundType"			"0"
		"infocus_bgcolor_override"		"0 0 0 0"
		"outoffocus_bgcolor_override"	"0 0 0 0"
		"modal"							"1"

		"DarkenBackground"
		{
			"ControlName"				"Label"
			"xpos"						"0"
			"ypos"						"0"
			"wide"						"%100"
			"tall"						"%100"
			"labelText"					""
			"bgcolor_override"			"0 0 0 0"
			"visible"					"1"
			"paintbackground"			"1"
		}

        "MainButtonsFrame"
		{
            "ControlName"				"ImagePanel"
			"wide"						"f0"
			"tall"						"125"
			"visible"					"1"
            "scaleImage"				"1"
			"zpos"						"0"
            "fillColor"					"30 30 30 200"
            "drawColor"					"30 30 30 200"

			"pin_to_sibling"			"DarkenBackground"
			"pin_corner_to_sibling"		"TOP"
			"pin_to_sibling_corner"		"TOP"
		}

		"R5Reloaded"
		{
			"ControlName"				"Label"
			"xpos"                    	"-150"
			"ypos"						"0"
			"auto_wide_tocontents"		"1"
			"tall"						"40"
			"visible"					"1"
			"fontHeight"				"50"
			"labelText"					"R5Reloaded"
			"font"						"DefaultBold_41"
			"allcaps"					"1"
			"fgcolor_override"			"255 255 255 255"

			"pin_to_sibling"			"MainButtonsFrame"
			"pin_corner_to_sibling"		"LEFT"
			"pin_to_sibling_corner"		"LEFT"
		}

		"TitleLine"
		{
            "ControlName"				"ImagePanel"
			"wide"						"373"
			"tall"						"2"
			"visible"					"1"
            "scaleImage"				"1"
			"zpos"						"0"
			"ypos"						20
            "fillColor"					"255 255 255 255"
            "drawColor"					"255 255 255 255"

			"pin_to_sibling"			"MainButtonsFrame"
			"pin_corner_to_sibling"		"LEFT"
			"pin_to_sibling_corner"		"LEFT"
		}

		"HomeBtn"
		{
			"ControlName"				"RuiButton"
			"InheritProperties"			"TabButtonStore"
			"classname" 				"TopButtons"
			"zpos"						"3"
			"xpos"                    	"-900"
			"wide"						"240"
			"tall"						"50"
			"scriptID"					"0"

			ruiArgs
			{
				isSelected 1
				buttonText "Home"
			}

			"pin_to_sibling"			"MainButtonsFrame"
			"pin_corner_to_sibling"		"BOTTOM_RIGHT"
			"pin_to_sibling_corner"		"BOTTOM_RIGHT"
		}

		"CreateServerBtn"
		{
			"ControlName"				"RuiButton"
			"InheritProperties"			"TabButtonStore"
			"classname" 				"TopButtons"
			"zpos"						"3"
			"xpos"                    	"-35"
			"wide"						"240"
			"tall"						"50"
			"scriptID"					"1"

			ruiArgs
			{
				isSelected 0
				buttonText "Create Server"
			}

			"pin_to_sibling"			"HomeBtn"
			"pin_corner_to_sibling"		"BOTTOM_LEFT"
			"pin_to_sibling_corner"		"BOTTOM_RIGHT"
		}

		"ServerBrowserBtn"
		{
			"ControlName"				"RuiButton"
			"InheritProperties"			"TabButtonStore"
			"classname" 				"TopButtons"
			"zpos"						"3"
			"xpos"                    	"-35"
			"wide"						"240"
			"tall"						"50"
			"scriptID"					"2"

			ruiArgs
			{
				isSelected 0
				buttonText "Server Browser"
			}

			"pin_to_sibling"			"CreateServerBtn"
			"pin_corner_to_sibling"		"BOTTOM_LEFT"
			"pin_to_sibling_corner"		"BOTTOM_RIGHT"
		}

		"SettingsBtn"
		{
			"ControlName"				"RuiButton"
			"InheritProperties"			"TabButtonStore"
			"zpos"						"3"
			"xpos"                    	"-35"
			"wide"						"240"
			"tall"						"50"
			
			ruiArgs
			{
				isSelected 0
				buttonText "Settings"
			}

			"pin_to_sibling"			"ServerBrowserBtn"
			"pin_corner_to_sibling"		"BOTTOM_LEFT"
			"pin_to_sibling_corner"		"BOTTOM_RIGHT"
		}

		"QuitBtn"
		{
			"ControlName"				"RuiButton"
			"InheritProperties"			"TabButtonStore"
			"zpos"						"3"
			"xpos"                    	"-35"
			"wide"						"240"
			"tall"						"50"
			
			ruiArgs
			{
				isSelected 0
				buttonText "Quit"
			}

			"pin_to_sibling"			"SettingsBtn"
			"pin_corner_to_sibling"		"BOTTOM_LEFT"
			"pin_to_sibling_corner"		"BOTTOM_RIGHT"
		}

		"R5RHomePanel"
    	{
    	    "ControlName"				"CNestedPanel"
    	    "ypos"						"20"
    	    "wide"						"f0"
			"tall"						"960"
			"visible"					"0"
    	    "controlSettingsFile"		"scripts/resource/ui/menus/R5R/panels/home.res"
    	    "proportionalToParent"    	"1"

    	    "pin_to_sibling"          	"MainButtonsFrame"
    	    "pin_corner_to_sibling"		"TOP"
    	    "pin_to_sibling_corner"		"BOTTOM"
    	}

		"R5RCreateServerPanel"
    	{
    	    "ControlName"				"CNestedPanel"
    	    "ypos"						"20"
    	    "wide"						"f0"
			"tall"						"960"
			"visible"					"0"
    	    "controlSettingsFile"		"scripts/resource/ui/menus/R5R/panels/createserver.res"
    	    "proportionalToParent"    	"1"

    	    "pin_to_sibling"          	"MainButtonsFrame"
    	    "pin_corner_to_sibling"		"TOP"
    	    "pin_to_sibling_corner"		"BOTTOM"
    	}

		"R5RServerBrowserPanel"
    	{
    	    "ControlName"				"CNestedPanel"
    	    "ypos"						"20"
    	    "wide"						"f0"
			"tall"						"960"
			"visible"					"0"
    	    "controlSettingsFile"		"scripts/resource/ui/menus/R5R/panels/serverbrowser.res"
    	    "proportionalToParent"    	"1"

    	    "pin_to_sibling"          	"MainButtonsFrame"
    	    "pin_corner_to_sibling"		"TOP"
    	    "pin_to_sibling_corner"		"BOTTOM"
    	}
	}
}
