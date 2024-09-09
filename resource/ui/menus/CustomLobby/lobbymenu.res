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
			"labelText"				"#FS_WELCOME_BACK"
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
			"visible"					"0"
			"fontHeight"				"50"
			"labelText"					"R5Reloaded"
			"font"						"DefaultBold_41"
			"allcaps"					"1"
			"fgcolor_override"			"255 255 255 255"

			"pin_to_sibling"			"MainButtonsFrame"
			"pin_corner_to_sibling"		"LEFT"
			"pin_to_sibling_corner"		"LEFT"
		}

		"NabButton0"
		{
			"ControlName"				"RuiButton"
			"InheritProperties"			"TabButtonSettings"
			"classname" 				"TopButtons"
			"zpos"						"3"
			"xpos"                    	"-500" // from -400 with ModsBtn visible
			"scriptID"					"0"

			"pin_to_sibling"			"MainButtonsFrame"
			"pin_corner_to_sibling"		"CENTER"
			"pin_to_sibling_corner"		"CENTER"
		}

		"NabButton1"
		{
			"ControlName"				"RuiButton"
			"InheritProperties"			"TabButtonSettings"
			"classname" 				"TopButtons"
			"zpos"						"3"
			"xpos"                    	"-80" // from -400 with ModsBtn visible
			"scriptID"					"1"

			"pin_to_sibling"			"NabButton0"
			"pin_corner_to_sibling"		"BOTTOM_LEFT"
			"pin_to_sibling_corner"		"BOTTOM_RIGHT"
		}

		"NabButton2"
		{
			"ControlName"				"RuiButton"
			"InheritProperties"			"TabButtonSettings"
			"classname" 				"TopButtons"
			"zpos"						"3"
			"xpos"                    	"-80"
			"scriptID"					"2"

			"pin_to_sibling"			"NabButton1"
			"pin_corner_to_sibling"		"BOTTOM_LEFT"
			"pin_to_sibling_corner"		"BOTTOM_RIGHT"
		}

		"NabButton3"
		{
			"ControlName"				"RuiButton"
			"InheritProperties"			"TabButtonSettings"
			"classname" 				"TopButtons"
			"zpos"						"3"
			"xpos"                    	"-80"
			"scriptID"					"3"

			"pin_to_sibling"			"NabButton2"
			"pin_corner_to_sibling"		"BOTTOM_LEFT"
			"pin_to_sibling_corner"		"BOTTOM_RIGHT"
		}

		"NabButton4"
		{
			"ControlName"				"RuiButton"
			"InheritProperties"			"TabButtonSettings"
			"classname" 				"TopButtons"
			"zpos"						"3"
			"xpos"                    	"-80"
			"scriptID"					"4"

			"pin_to_sibling"			"NabButton3"
			"pin_corner_to_sibling"		"BOTTOM_LEFT"
			"pin_to_sibling_corner"		"BOTTOM_RIGHT"
		}

		"NabButton5"
		{
			"ControlName"				"RuiButton"
			"InheritProperties"			"TabButtonSettings"
			"classname" 				"TopButtons"
			"zpos"						"3"
			"xpos"                    	"-80"
			"scriptID"					"5"

			"pin_to_sibling"			"NabButton4"
			"pin_corner_to_sibling"		"BOTTOM_LEFT"
			"pin_to_sibling_corner"		"BOTTOM_RIGHT"
		}

		"HomePanel"
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

		"CreatePanel"
    	{
    	    "ControlName"				"CNestedPanel"
    	    "ypos"						"20"
    	    "wide"						"f0"
			"tall"						"1200"
			"visible"					"0"
    	    "controlSettingsFile"		"scripts/resource/ui/menus/CustomLobby/panels/create_match.res"
    	    "proportionalToParent"    	"1"

    	    "pin_to_sibling"          	"MainButtonsFrame"
    	    "pin_corner_to_sibling"		"TOP"
    	    "pin_to_sibling_corner"		"BOTTOM"
    	}

		"ServerBrowserPanel"
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

		"LegendsPanel"
    	{
    	    "ControlName"				"CNestedPanel"
    	    "ypos"						"20"
    	    "wide"						"f0"
			"tall"						"1200"
			"visible"					"0"
    	    "controlSettingsFile"		"scripts/resource/ui/menus/CustomLobby/panels/characters.res"
    	    "proportionalToParent"    	"1"

    	    "pin_to_sibling"          	"MainButtonsFrame"
    	    "pin_corner_to_sibling"		"TOP"
    	    "pin_to_sibling_corner"		"BOTTOM"
    	}

		"LoadoutPanel"
    	{
    	    "ControlName"				"CNestedPanel"
    	    "ypos"						"20"
    	    "wide"						"f0"
			"tall"						"1200"
			"visible"					"0"
    	    "controlSettingsFile"		"scripts/resource/ui/menus/CustomLobby/panels/loadout.res"
    	    "proportionalToParent"    	"1"

    	    "pin_to_sibling"          	"MainButtonsFrame"
    	    "pin_corner_to_sibling"		"TOP"
    	    "pin_to_sibling_corner"		"BOTTOM"
    	}

		"R5RNamePanel"
		{
			"ControlName"				"CNestedPanel"
			"classname"					"CustomPrivateMatchMenu"
			"ypos"						"0"
			"zpos"						"45"
			"wide"						"f0"
			"tall"						"f0"
			"visible"					"0"
			"controlSettingsFile"		"scripts/resource/ui/menus/CustomLobby/panels/servername.res"
			"proportionalToParent"    	"1"
			"zpos"                      "10"
		}

		"R5RDescPanel"
		{
			"ControlName"				"CNestedPanel"
			"classname"					"CustomPrivateMatchMenu"
			"ypos"						"0"
			"zpos"						"45"
			"wide"						"f0"
			"tall"						"f0"
			"visible"					"0"
			"controlSettingsFile"		"scripts/resource/ui/menus/CustomLobby/panels/serverdesc.res"
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

		MatchmakingStatus
        {
            ControlName		        RuiPanel
            InheritProperties		MatchmakingStatus

            pin_to_sibling			DarkenBackground
            pin_corner_to_sibling	BOTTOM
            pin_to_sibling_corner	BOTTOM
        }

		ToolTip
		{
			ControlName				CNestedPanel
			InheritProperties		ToolTip
		}
	}
}
