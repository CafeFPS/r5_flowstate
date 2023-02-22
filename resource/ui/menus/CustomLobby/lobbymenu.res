"scripts/resource/ui/menus/CustomLobby/lobbymenu.menu"
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
			"tall"						"83"
			"visible"					"1"
            "scaleImage"				"1"
			"zpos"						"0"
            "fillColor"					"30 30 30 200"
            "drawColor"					"30 30 30 200"

			"pin_to_sibling"			"DarkenBackground"
			"pin_corner_to_sibling"		"TOP"
			"pin_to_sibling_corner"		"TOP"
		}

		"Logo"
        {
            "ControlName"				"RuiPanel"
			"InheritProperties"       	"Logo"

            "pin_to_sibling"			"MainButtonsFrame"
            "pin_corner_to_sibling"		"TOP_LEFT"
            "pin_to_sibling_corner"		"TOP_LEFT"
        }

		"WelcomeBack"
		{
			"ControlName"			"Label"
			"xpos"                  "-10"
			"ypos"					"-15"
			"wide"					"300"
			"tall"					"30"
			"visible"				"0"
			"fontHeight"			"30"
			"labelText"				"Welcome back"
			"font"					"DefaultBold_41"
			"allcaps"				"0"
			"fgcolor_override"		"255 255 255 255"
			"textAlignment"			"east"

			"pin_to_sibling"		"MainButtonsFrame"
			"pin_corner_to_sibling"	"RIGHT"
			"pin_to_sibling_corner"	"RIGHT"
		}

		"R5Reloaded"
		{
			"ControlName"				"Label"
			"xpos"                    	"-180"
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

		"HomeBtn"
		{
			"ControlName"				"RuiButton"
			"InheritProperties"			"TabButtonSettings"
			"classname" 				"TopButtons"
			"zpos"						"3"
			"xpos"                    	"-400"
			"scriptID"					"0"

			ruiArgs
			{
				isSelected 1
				buttonText "#Play"
			}

			"pin_to_sibling"			"MainButtonsFrame"
			"pin_corner_to_sibling"		"CENTER"
			"pin_to_sibling_corner"		"CENTER"
		}

		"ServerBrowserBtn"
		{
			"ControlName"				"RuiButton"
			"InheritProperties"			"TabButtonSettings"
			"classname" 				"TopButtons"
			"zpos"						"3"
			"xpos"                    	"-80"
			"scriptID"					"1"

			ruiArgs
			{
				isSelected 0
				buttonText "Server Browser"
			}

			"pin_to_sibling"			"HomeBtn"
			"pin_corner_to_sibling"		"BOTTOM_LEFT"
			"pin_to_sibling_corner"		"BOTTOM_RIGHT"
		}

		"ModsBtn"
		{
			"ControlName"				"RuiButton"
			"InheritProperties"			"TabButtonSettings"
			"classname" 				"TopButtons"
			"zpos"						"3"
			"xpos"                    	"-80"
			"scriptID"					"2"

			ruiArgs
			{
				isSelected 0
				buttonText "Mods (Coming Soon)"
			}

			"pin_to_sibling"			"ServerBrowserBtn"
			"pin_corner_to_sibling"		"BOTTOM_LEFT"
			"pin_to_sibling_corner"		"BOTTOM_RIGHT"
		}

		"SettingsBtn"
		{
			"ControlName"				"RuiButton"
			"InheritProperties"			"TabButtonSettings"
			"classname" 				"TopButtons"
			"zpos"						"3"
			"xpos"                    	"-80"
			"scriptID"					"3"

			ruiArgs
			{
				isSelected 0
				buttonText "Settings"
			}

			"pin_to_sibling"			"ModsBtn"
			"pin_corner_to_sibling"		"BOTTOM_LEFT"
			"pin_to_sibling_corner"		"BOTTOM_RIGHT"
		}

		"R5RHomePanel"
    	{
    	    "ControlName"				"CNestedPanel"
    	    "ypos"						"20"
    	    "wide"						"f0"
			"tall"						"1200"
			"visible"					"0"
    	    "controlSettingsFile"		"scripts/resource/ui/menus/CustomLobby/panels/home.res"
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
			"tall"						"1200"
			"visible"					"0"
    	    "controlSettingsFile"		"scripts/resource/ui/menus/CustomLobby/panels/serverbrowser.res"
    	    "proportionalToParent"    	"1"

    	    "pin_to_sibling"          	"MainButtonsFrame"
    	    "pin_corner_to_sibling"		"TOP"
    	    "pin_to_sibling_corner"		"BOTTOM"
    	}

		"ModsPanel"
    	{
    	    "ControlName"				"CNestedPanel"
    	    "ypos"						"20"
    	    "wide"						"f0"
			"tall"						"1200"
			"visible"					"0"
    	    "controlSettingsFile"		"scripts/resource/ui/menus/CustomLobby/panels/mods.res"
    	    "proportionalToParent"    	"1"

    	    "pin_to_sibling"          	"MainButtonsFrame"
    	    "pin_corner_to_sibling"		"TOP"
    	    "pin_to_sibling_corner"		"BOTTOM"
    	}

		"R5RKickPanel"
		{
			"ControlName"				"CNestedPanel"
			"ypos"						"0"
			"zpos"						"45"
			"wide"						"f0"
			"tall"						"f0"
			"visible"					"0"
			"controlSettingsFile"		"scripts/resource/ui/menus/CustomLobby/panels/kickplayer.res"
			"proportionalToParent"    	"1"
			"zpos"                      "10"
		}

		"R5RConnectingPanel"
		{
			"ControlName"				"CNestedPanel"
			"ypos"						"0"
			"zpos"						"45"
			"wide"						"f0"
			"tall"						"f0"
			"visible"					"0"
			"controlSettingsFile"		"scripts/resource/ui/menus/CustomLobby/panels/connecting.res"
			"proportionalToParent"    	"1"
			"zpos"                      "10"
		}

		ToolTip
		{
			ControlName				CNestedPanel
			InheritProperties		ToolTip
		}
	}
}
