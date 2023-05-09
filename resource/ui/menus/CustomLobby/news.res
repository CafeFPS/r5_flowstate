resource/ui/menus/dialog.menu
{
	menu
	{
		ControlName				Frame
		zpos					3
		wide					f0
		tall					f0
		autoResize				0
		pinCorner				0
		visible					1
		enabled					1
		tabPosition				0
		PaintBackgroundType		0
		infocus_bgcolor_override	"0 0 0 0"
		outoffocus_bgcolor_override	"0 0 0 0"
		modal					1
		disableDpad             1

		ScreenBlur
		{
			ControlName				RuiPanel
			wide					%100
			tall					%100
			rui                     "ui/screen_blur.rpak"
			visible					1
		}

		DarkenBackground
		{
			ControlName				Label
			xpos					0
			ypos					0
			wide					%100
			tall					%100
			labelText				""
			bgcolor_override		"0 0 0 150"
			visible					1
			paintbackground			1
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

		"NewsBtn"
		{
			"ControlName"				"RuiButton"
			"InheritProperties"			"TabButtonSettings"
			"classname" 				"TopButtons"
			"zpos"						"3"

			ruiArgs
			{
				isSelected 1
				buttonText "News"
			}

			"pin_to_sibling"			"MainButtonsFrame"
			"pin_corner_to_sibling"		"CENTER"
			"pin_to_sibling_corner"		"CENTER"
		}

		MouseWheelText
		{
			"ControlName"			"Label"
			"xpos"                  "0"
			"ypos"					"-50"
			"auto_wide_tocontents"	"1"
			"tall"					"20"
			"visible"				"1"
			"wrap"					"0"
			"fontHeight"			"20"
			"zpos"					"5"
			"labelText"				"%weaponcycle% NEXT/PREV"
			"font"					"TitleBoldFont"
			"allcaps"				"1"
			"fgcolor_override"		"255 255 255 255"

			"pin_to_sibling"		"DarkenBackground"
			"pin_corner_to_sibling"	"BOTTOM"
			"pin_to_sibling_corner"	"BOTTOM"
		}

		"DescText"
		{
			"ControlName"			"Label"
			"xpos"                  "-30"
			"ypos"					"-30"
			"wide"					"600"
			"tall"					"190"
			"visible"				"1"
			"wrap"					"1"
			"fontHeight"			"28"
			"zpos"					"5"
			"textAlignment"			"north-west"
			"labelText"				"This project allows you to run APEX Legends with mods, by running the embedded server and loading custom scripts/global compile lists into the scripting VM. This allows you to create custom gamemodes, levels, weapons and more. This project allows you to run APEX Legends with mods, by running the embedded server and loading custom scripts/global compile lists into the scripting VM. This allows you to create custom gamemodes, levels, weapons and more. This project allows you to run APEX Legends with mods, by running the embedded server and loading custom scripts/global compile lists into the scripting VM. This allows you to create custom gamemodes, levels, weapons and more. This project allows you to run APEX Legends with mods, by running the embedded server and loading custom scripts/global compile lists into the scripting VM. This allows you to create custom gamemodes, levels, weapons and more."
			"font"					"DefaultBold_41"
			"allcaps"				"0"
			"fgcolor_override"		"255 255 255 255"

			"pin_to_sibling"		"CenterNewsImage"
			"pin_corner_to_sibling"	"BOTTOM_LEFT"
			"pin_to_sibling_corner"	"BOTTOM_LEFT"
		}

		"TitleText"
		{
			"ControlName"			"Label"
			"xpos"                  "0"
			"ypos"					"5"
			"wide"					"900"
			"tall"					"50"
			"visible"				"1"
			"wrap"					"0"
			"fontHeight"			"50"
			"zpos"					"5"
			"textAlignment"			"north-west"
			"labelText"				"TEST TITLE. TEST TITLE. TEST TITLE. TEST TITLE. TEST TITLE. TEST TITLE. TEST TITLE. TEST TITLE. TEST TITLE. TEST TITLE. TEST TITLE. TEST TITLE. TEST TITLE. TEST TITLE. TEST TITLE. TEST TITLE. TEST TITLE. TEST TITLE. TEST TITLE. TEST TITLE. "
			"font"					"TitleBoldFont"
			"allcaps"				"1"
			"fgcolor_override"		"255 255 255 255"

			"pin_to_sibling"		"DescText"
			"pin_corner_to_sibling"	"BOTTOM_LEFT"
			"pin_to_sibling_corner"	"TOP_LEFT"
		}

		CenterNewsImage
		{
			ControlName		RuiPanel
			wide			1280
			tall            720
			visible			1
			rui           	"ui/custom_loadscreen_image.rpak"
			ypos			20
			zpos 2

			pin_to_sibling				MainButtonsFrame
			pin_corner_to_sibling		TOP
			pin_to_sibling_corner		BOTTOM
		}

		LeftNewsImage
		{
			ControlName		RuiPanel
			wide			1180
			tall            620
			visible			1
			rui           	"ui/custom_loadscreen_image.rpak"
			zpos 2

			xpos			100

			pin_to_sibling				CenterNewsImage
			pin_corner_to_sibling		RIGHT
			pin_to_sibling_corner		LEFT
		}

		RightNewsImage
		{
			ControlName		RuiPanel
			wide			1180
			tall            620
			visible			1
			rui           	"ui/custom_loadscreen_image.rpak"
			zpos 2

			xpos			100

			pin_to_sibling				CenterNewsImage
			pin_corner_to_sibling		LEFT
			pin_to_sibling_corner		RIGHT
		}

        PrevPageButton
        {
            ControlName				RuiButton
            wide					960
            tall					594
            rui                     "ui/promo_page_change_button.rpak"
            labelText               ""
            visible					1
            proportionalToParent    1
			xpos					150
            sound_accept            "UI_Menu_MOTD_Tab"
			zpos 10

            pin_to_sibling			CenterNewsImage
            pin_corner_to_sibling	LEFT
            pin_to_sibling_corner	LEFT
        }

        NextPageButton
        {
            ControlName				RuiButton
            wide					960
            tall					594
            rui                     "ui/promo_page_change_button.rpak"
            labelText               ""
            visible					1
            proportionalToParent    1
			xpos					150
            sound_accept            "UI_Menu_MOTD_Tab"
			zpos 10

           	pin_to_sibling			CenterNewsImage
            pin_corner_to_sibling	RIGHT
            pin_to_sibling_corner	RIGHT
        }

		NewsItem1
		{
			ControlName				RuiButton
        	classname               "MenuButton MatchmakingStatusRui"
			wide			256  
			tall            144
			visible			1
			rui             "ui/gamemode_select_v2_lobby_button.rpak"
			ypos			-100
			xpos			0
			zpos 2
			"scriptID"					"0"

			pin_to_sibling				DarkenBackground
			pin_corner_to_sibling		BOTTOM
			pin_to_sibling_corner		BOTTOM
		}

		NewsItem2
		{
			ControlName				RuiButton
        	classname               "MenuButton MatchmakingStatusRui"
			wide			256  
			tall            144
			visible			1
			rui             "ui/gamemode_select_v2_lobby_button.rpak"
			xpos			10
			zpos 2
			"scriptID"					"1"

			pin_to_sibling				NewsItem1
			pin_corner_to_sibling		LEFT
			pin_to_sibling_corner		RIGHT
		}

		NewsItem3
		{
			ControlName				RuiButton
        	classname               "MenuButton MatchmakingStatusRui"
			wide			256  
			tall            144
			visible			1
			rui             "ui/gamemode_select_v2_lobby_button.rpak"
			xpos			10
			zpos 2
			"scriptID"					"2"

			pin_to_sibling				NewsItem2
			pin_corner_to_sibling		LEFT
			pin_to_sibling_corner		RIGHT
		}

		NewsItem4
		{
			ControlName				RuiButton
        	classname               "MenuButton MatchmakingStatusRui"
			wide			256  
			tall            144
			visible			1
			rui             "ui/gamemode_select_v2_lobby_button.rpak"
			xpos			10
			zpos 2
			"scriptID"					"3"

			pin_to_sibling				NewsItem3
			pin_corner_to_sibling		LEFT
			pin_to_sibling_corner		RIGHT
		}

		NewsItem5
		{
			ControlName				RuiButton
        	classname               "MenuButton MatchmakingStatusRui"
			wide			256  
			tall            144
			visible			1
			rui             "ui/gamemode_select_v2_lobby_button.rpak"
			xpos			10
			zpos 2
			"scriptID"					"4"

			pin_to_sibling				NewsItem4
			pin_corner_to_sibling		LEFT
			pin_to_sibling_corner		RIGHT
		}

		NewsItem6
		{
			ControlName				RuiButton
        	classname               "MenuButton MatchmakingStatusRui"
			wide			256  
			tall            144
			visible			1
			rui             "ui/gamemode_select_v2_lobby_button.rpak"
			xpos			10
			zpos 2
			"scriptID"					"5"

			pin_to_sibling				NewsItem5
			pin_corner_to_sibling		LEFT
			pin_to_sibling_corner		RIGHT
		}

		NewsItemSelected
		{
			ControlName				ImagePanel
            wide					296
            tall                    450
            visible				    1
            image                   "vgui/HUD/flare_announcement"
            drawColor               "255 255 255 255"
            scaleImage              1
			"zpos"						"0"

			"pin_to_sibling"		"NewsItem1"
			"pin_corner_to_sibling"	"CENTER"
			"pin_to_sibling_corner"	"CENTER"
		}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		FooterButtons
		{
			ControlName				CNestedPanel
			InheritProperties       PromoFooterButtons
			xpos					-15
			ypos                    -35
            //wide					200 // width of 1 button
            wide					422 // width of 2 buttons including space in between

			pin_to_sibling			DarkenBackground
			pin_corner_to_sibling	BOTTOM_LEFT
			pin_to_sibling_corner	BOTTOM_LEFT
		}
	}
}
