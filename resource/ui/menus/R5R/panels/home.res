"scripts/resource/ui/menus/R5R/panels/home.res"
{
	"DarkenBackground"
	{
		"ControlName"			"Label"
		"xpos"					"0"
		"ypos"					"0"
		"zpos"					"0"
		"wide"					"%100"
		"tall"					"%100"
		"labelText"				""
		"bgcolor_override"		"0 0 0 0"
		"visible"				"1"
		"paintbackground"		"1"
	}
	
	"HomeBackground"
	{
        "ControlName"			"ImagePanel"
		"wide"					"500"
		"tall"					"870"
		"visible"				"1"
        "scaleImage"			"1"
		"xpos"					"-30"
		"ypos"					"-40"
		"zpos"					"0"
        "fillColor"				"30 30 30 200"
        "drawColor"				"30 30 30 200"

		"pin_to_sibling"		"DarkenBackground"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"TOP_LEFT"
	}

	"InPlayersLobby"
	{
        "ControlName"			"ImagePanel"
		"wide"					"350"
		"tall"					"75"
		"visible"				"1"
        "scaleImage"			"1"
		"xpos"					"0"
		"ypos"					"-40"
		"zpos"					"0"
        "fillColor"				"30 30 30 200"
        "drawColor"				"30 30 30 200"

		"pin_to_sibling"		"DarkenBackground"
		"pin_corner_to_sibling"	"TOP_RIGHT"
		"pin_to_sibling_corner"	"TOP_RIGHT"
	}

	"InPlayersLobbyText"
	{
        "ControlName"			"Label"
		"xpos"                  "0"
		"ypos"					"0"
		"auto_wide_tocontents"	"1"
		"tall"					"40"
		"visible"				"1"
		"fontHeight"			"30"
		"labelText"				"You are in <players> lobby"
		"font"					"DefaultBold_41"
		"allcaps"				"0"
		"fgcolor_override"		"255 100 100 255"

		"pin_to_sibling"		"InPlayersLobby"
		"pin_corner_to_sibling"	"CENTER"
		"pin_to_sibling_corner"	"CENTER"
	}

	"R5RPicBox"
	{
		"ControlName"			"RuiPanel"
		"wide"					"501"
		"tall"					"275"
		"rui"                   "ui/basic_image.rpak"
		"visible"				"1"
		"scaleImage"			"1"

		"pin_to_sibling"		"HomeBackground"
		"pin_corner_to_sibling"	"TOP"
		"pin_to_sibling_corner"	"TOP"
	}

	"Welcome"
	{
        "ControlName"			"Label"
		"xpos"                  "-25"
		"ypos"					"20"
		"auto_wide_tocontents"	"1"
		"tall"					"40"
		"visible"				"1"
		"fontHeight"			"30"
		"labelText"				"Welcome to R5Reloaded"
		"font"					"DefaultBold_41"
		"allcaps"				"0"
		"fgcolor_override"		"255 100 100 255"

		"pin_to_sibling"		"R5RPicBox"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"BOTTOM_LEFT"
	}

	"Info"
	{
        "ControlName"			"Label"
		"xpos"                  "0"
		"ypos"					"20"
		"wide"					"450"
		"tall"					"200"
		"visible"				"1"
		"wrap"					"1"
		"fontHeight"			"25"
		"textAlignment"			"north-west"
		"labelText"				"This project allows you to run APEX Legends with mods, by running the embedded server and loading custom scripts/global compile lists into the scripting VM. This allows you to create custom gamemodes, levels, weapons and more. "
		"font"					"DefaultBold_41"
		"allcaps"				"0"
		"fgcolor_override"		"200 200 200 255"

		"pin_to_sibling"		"Welcome"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"BOTTOM_LEFT"
	}
	
	"Welcome2"
	{
        "ControlName"			"Label"
		"xpos"                  "0"
		"ypos"					"45"
		"auto_wide_tocontents"	"1"
		"tall"					"40"
		"visible"				"1"
		"fontHeight"			"30"
		"labelText"				"You're using Flowstate scripts!"
		"font"					"DefaultBold_41"
		"allcaps"				"0"
		"fgcolor_override"		"255 100 100 255"

		"pin_to_sibling"		"Info2"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"TOP_LEFT"
	}
	
	"Info2"
	{
        "ControlName"			"Label"
		"xpos"                  "0"
		"ypos"					"5"
		"wide"					"450"
		"tall"					"300"
		"visible"				"1"
		"wrap"					"1"
		"fontHeight"			"25"
		"textAlignment"			"north-west"
		"labelText"				"Flowstate is a package of scripts for R5 Reloaded (Modded Apex Legends) that includes a large number of bugs fixes and new features. It also includes exclusive content made by the community like abilities, gamemodes or maps!" 
		"font"					"DefaultBold_41"
		"allcaps"				"0"
		"fgcolor_override"		"200 200 200 255"

		"pin_to_sibling"		"Info"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"BOTTOM_LEFT"
	}

	"VersionNumber"
	{
		"ControlName"			"Label"
		"labelText"				"custom_tdm"
		"font"					"Default_27_Outline"
		"allcaps"				"1"
		"wide"					"225"
		"zpos" 					"7"
		"fontHeight"			"25"
		"xpos"					"-15"
		"ypos"					"-15"
		"textAlignment"			"east"
		"fgcolor_override"		"240 240 240 255"
		"bgcolor_override"		"0 0 0 255"
		visible 0

		"pin_to_sibling"		"HomeBackground"
		"pin_corner_to_sibling"	"BOTTOM_RIGHT"
		"pin_to_sibling_corner"	"BOTTOM_RIGHT"
	}

	SelfButton
    {
        ControlName				RuiButton
        wide					340
        tall					88
        xpos                    0
        ypos                    -70
        rui                     "ui/lobby_friend_button.rpak"
        labelText               ""
        visible					1
        cursorVelocityModifier  0.7
        scriptID                -1
        rightClickEvents		0
        tabPosition             1

        proportionalToParent    1

		ruiArgs
		{
			canViewStats 0
			isLeader 1
		}

        pin_to_sibling			DarkenBackground
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP
    }
}

