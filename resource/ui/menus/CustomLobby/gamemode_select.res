resource/ui/menus/dialog_gamemode_select_v2.menu
{
	menu
	{
		ControlName				Frame
		xpos					0
		ypos					0
		zpos					3
		wide					f0
		tall					f0
		autoResize				0
		pinCorner				0
		visible					1
		enabled					1
		tabPosition				1
		PaintBackgroundType		0
		infocus_bgcolor_override	"0 0 0 0"
		outoffocus_bgcolor_override	"0 0 0 0"
		modal					1

		ScreenBlur
		{
			ControlName				Label
            labelText               ""
		}

        ScreenFrame
        {
            ControlName				RuiPanel
            xpos					0
            ypos					0
            wide					%100
            tall					%100
            visible					1
            enabled 				1
            scaleImage				1
            rui                     "ui/screen_blur.rpak"
            drawColor				"255 255 255 255"
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

			"pin_to_sibling"			"ScreenFrame"
			"pin_corner_to_sibling"		"TOP"
			"pin_to_sibling_corner"		"TOP"
		}

		"GamemodesBtn"
        {
			"ControlName"				"RuiButton"
			"InheritProperties"			"TabButtonSettings"
			"classname" 				"TopButtons"
			"zpos"						"3"
            "xpos"                      "-100"

			ruiArgs
			{
				isSelected 1
				buttonText "Quick Play"
			}

			"pin_to_sibling"			"MainButtonsFrame"
			"pin_corner_to_sibling"		"CENTER"
			"pin_to_sibling_corner"		"CENTER"
		}

        "PrivateMatchBtn"
        {
			"ControlName"				"RuiButton"
			"InheritProperties"			"TabButtonSettings"
			"classname" 				"TopButtons"
			"zpos"						"3"
            "xpos"                      "-80"

			ruiArgs
			{
				isSelected 0
				buttonText "Private Match"
			}

			"pin_to_sibling"			"GamemodesBtn"
			"pin_corner_to_sibling"		"LEFT"
			"pin_to_sibling_corner"		"RIGHT"
		}

        Cover
        {
            ControlName				ImagePanel
            xpos					0
            ypos					0
            wide                    %200
            tall					%200
            visible					1
            enabled 				1
            scaleImage				1
            image					"vgui/HUD/white"
            drawColor				"0 0 0 200"

            pin_to_sibling			ScreenFrame
            pin_corner_to_sibling	CENTER
            pin_to_sibling_corner	CENTER
        }

        PrevPageButton
        {
            ControlName				RuiButton
            wide					960
            tall					560
            rui                     "ui/promo_page_change_button.rpak"
            labelText               ""
            visible					1
            proportionalToParent    1
			xpos					50
            ypos                    100
            sound_accept            "UI_Menu_MOTD_Tab"
			zpos 1

            pin_to_sibling			ScreenFrame
            pin_corner_to_sibling	LEFT
            pin_to_sibling_corner	LEFT
        }

        NextPageButton
        {
            ControlName				RuiButton
            wide					960
            tall					560
            rui                     "ui/promo_page_change_button.rpak"
            labelText               ""
            visible					1
            proportionalToParent    1
			xpos					50
            ypos                    100
            sound_accept            "UI_Menu_MOTD_Tab"
			zpos 1

           	pin_to_sibling			ScreenFrame
            pin_corner_to_sibling	RIGHT
            pin_to_sibling_corner	RIGHT
        }

        CloseButton
        {
            ControlName             BaseModHybridButton
            xpos					0
            ypos					0
            wide					%100
            tall					%100
            labelText               ""
            visible                 1
            sound_accept            "UI_Menu_SelectMode_Close"
        }

        "QuickPlayText"
		{
			"ControlName"			"Label"
			"xpos"                  "0"
			"ypos"					"10"
			"auto_wide_tocontents"	"1"
			"tall"					"30"
			"visible"				"1"
			"wrap"					"0"
			"fontHeight"			"30"
			"zpos"					"5"
			"textAlignment"			"north-west"
			"labelText"				"Quick Play"
			"font"					"TitleBoldFont"
			"allcaps"				"1"
			"fgcolor_override"		"200 200 200 255"

			"pin_to_sibling"		"FiringRangeButton"
			"pin_corner_to_sibling"	"BOTTOM"
			"pin_to_sibling_corner"	"TOP_RIGHT"
		}

        FiringRangeButton
        {
            ControlName				RuiButton
            classname               "MenuButton"
            wide					280
            tall					120
            ypos                    -150
            xpos                    -120
            zpos                    10
            rui                     "ui/gamemode_select_v2_lobby_button.rpak"
            labelText               ""
            visible					1
            tabPosition             1
            cursorVelocityModifier  0.7
            sound_accept            "UI_Menu_GameMode_Select"

            ruiArgs
            {
                lockIconEnabled 0
                modeNameText "Firing Range"
                modeDescText "Run around in the custom Firing Range"
                modeImage "rui/menu/gamemode/firing_range"
            }

            pin_to_sibling			ScreenFrame
            pin_corner_to_sibling	TOP_LEFT
            pin_to_sibling_corner	TOP_LEFT
        }

        FreeRoamButton
        {
            ControlName				RuiButton
            classname               "MenuButton"
            wide					280
            tall					120
            ypos                    0
            xpos                    10
            zpos                    10
            rui                     "ui/gamemode_select_v2_lobby_button.rpak"
            labelText               ""
            visible					1
            tabPosition             1
            cursorVelocityModifier  0.7
            sound_accept            "UI_Menu_MOTD_Tab"

            ruiArgs
            {
                lockIconEnabled 0
                modeNameText "Free Roam"
                modeDescText "Run around any map"
                modeImage "rui/menu/maps/mp_rr_desertlands_64k_x_64k"
            }

            pin_to_sibling			FiringRangeButton
            pin_corner_to_sibling	LEFT
            pin_to_sibling_corner	RIGHT
        }

        "TopServersText"
		{
			"ControlName"			"Label"
			"xpos"                  "0"
			"ypos"					"10"
			"auto_wide_tocontents"	"1"
			"tall"					"30"
			"visible"				"1"
			"wrap"					"0"
			"fontHeight"			"30"
			"zpos"					"5"
			"textAlignment"			"north-west"
			"labelText"				"Top Servers"
			"font"					"TitleBoldFont"
			"allcaps"				"1"
			"fgcolor_override"		"200 200 200 255"

			"pin_to_sibling"		"TopServerButton1"
			"pin_corner_to_sibling"	"BOTTOM"
			"pin_to_sibling_corner"	"TOP"
		}

        TopServerButton0
        {
            ControlName				RuiButton
            classname               "TopServerButtons"
            wide					260
            tall					120
            ypos                    -150
            xpos                    -120
            zpos                    10
            rui                     "ui/gamemode_select_v2_lobby_button.rpak"
            labelText               ""
            visible					1
            tabPosition             1
            cursorVelocityModifier  0.7
            sound_accept            "UI_Menu_GameMode_Select"
            "scriptID"					"2"

            ruiArgs
            {
                lockIconEnabled 0
            }

            pin_to_sibling			ScreenFrame
            pin_corner_to_sibling	TOP_RIGHT
            pin_to_sibling_corner	TOP_RIGHT
        }

        TopServerButton1
        {
            ControlName				RuiButton
            classname               "TopServerButtons"
            wide					260
            tall					120
            ypos                    0
            xpos                    10
            zpos                    10
            rui                     "ui/gamemode_select_v2_lobby_button.rpak"
            labelText               ""
            visible					1
            tabPosition             1
            cursorVelocityModifier  0.7
            sound_accept            "UI_Menu_GameMode_Select"
            "scriptID"					"1"

            ruiArgs
            {
                lockIconEnabled 0
            }

            pin_to_sibling			TopServerButton0
            pin_corner_to_sibling	RIGHT
            pin_to_sibling_corner	LEFT
        }

        TopServerButton2
        {
            ControlName				RuiButton
            classname               "TopServerButtons"
            wide					260
            tall					120
            ypos                    0
            xpos                    10
            zpos                    10
            rui                     "ui/gamemode_select_v2_lobby_button.rpak"
            labelText               ""
            visible					1
            tabPosition             1
            cursorVelocityModifier  0.7
            sound_accept            "UI_Menu_GameMode_Select"
            "scriptID"					"0"

            ruiArgs
            {
                lockIconEnabled 0
            }

            pin_to_sibling			TopServerButton1
            pin_corner_to_sibling	RIGHT
            pin_to_sibling_corner	LEFT
        }

		GameModeSelectAnchor
		{
			ControlName				Label
            labelText               ""

            wide					0
            tall					0
            xpos                    0
            ypos                    0

            pin_to_sibling			ScreenFrame
            pin_corner_to_sibling	CENTER
            pin_to_sibling_corner	CENTER
		}

        "TitleText"
		{
			"ControlName"			"Label"
			"xpos"                  "0"
			"ypos"					"-215"
			"auto_wide_tocontents"	"1"
			"tall"					"30"
			"visible"				"1"
			"wrap"					"0"
			"fontHeight"			"30"
			"zpos"					"5"
			"textAlignment"			"north-west"
			"labelText"				"Quick Join"
			"font"					"TitleBoldFont"
			"allcaps"				"1"
			"fgcolor_override"		"200 200 200 255"

			"pin_to_sibling"		"GameModeSelectAnchor"
			"pin_corner_to_sibling"	"CENTER"
			"pin_to_sibling_corner"	"CENTER"
		}

        GameModeButton0
        {
            ControlName				RuiButton
            classname               "GamemodeButtons"
            wide					325
            tall					560
            ypos                    100
            xpos                    -675
            zpos                    10
            rui                     "ui/gamemode_select_v2_button.rpak"
            labelText               ""
            visible					1
            tabPosition             1
            cursorVelocityModifier  0.7
            sound_accept            "UI_Menu_GameMode_Select"
            "scriptID"					"0"

            ruiArgs
            {
                lockIconEnabled 0
                modeNameText "Random Playlist"
                modeDescText "Quickly Join any kind of server"
                modeImage "rui/menu/gamemode/ranked_1"
            }


            navRight                GameModeButton1

            pin_to_sibling			GameModeSelectAnchor
            pin_corner_to_sibling	CENTER
            pin_to_sibling_corner	CENTER
        }


        GameModeButton1
        {
            ControlName				RuiButton
            classname               "GamemodeButtons"
            wide					325
            tall					560
            xpos                    15
            zpos                    10
            rui                     "ui/gamemode_select_v2_button.rpak"
            labelText               ""
            visible					1
            cursorVelocityModifier  0.7
            sound_accept            "UI_Menu_GameMode_Select"
            "scriptID"					"1"

            navLeft                 GameModeButton0
            navRight                GameModeButton2

            pin_to_sibling			GameModeButton0
            pin_corner_to_sibling	LEFT
            pin_to_sibling_corner	RIGHT
        }


        GameModeButton2
        {
            ControlName				RuiButton
            classname               "GamemodeButtons"
            wide					325
            tall					560
            xpos                    15
            zpos                    10
            rui                     "ui/gamemode_select_v2_button.rpak"
            labelText               ""
            visible					1
            cursorVelocityModifier  0.7
            sound_accept            "UI_Menu_GameMode_Select"
            "scriptID"					"2"

            navLeft                 GameModeButton1
            navRight                GameModeButton3

            pin_to_sibling			GameModeButton1
            pin_corner_to_sibling	LEFT
            pin_to_sibling_corner	RIGHT
        }


        GameModeButton3
        {
            ControlName				RuiButton
            classname               "GamemodeButtons"
            wide					325
            tall					560
            xpos                    15
            zpos                    10
            rui                     "ui/gamemode_select_v2_button.rpak"
            labelText               ""
            visible					1
            cursorVelocityModifier  0.7
            sound_accept            "UI_Menu_GameMode_Select"
            "scriptID"					"3"

            navLeft                 GameModeButton2
            navRight                GameModeButton4

            pin_to_sibling			GameModeButton2
            pin_corner_to_sibling	LEFT
            pin_to_sibling_corner	RIGHT
        }


        GameModeButton4
        {
            ControlName				RuiButton
            classname               "GamemodeButtons"
            wide					325
            tall					560
            xpos                    15
            zpos                    10
            rui                     "ui/gamemode_select_v2_button.rpak"
            labelText               ""
            visible					1
            cursorVelocityModifier  0.7
            sound_accept            "UI_Menu_GameMode_Select"
            "scriptID"					"4"

            navLeft                 GameModeButton3

            pin_to_sibling			GameModeButton3
            pin_corner_to_sibling	LEFT
            pin_to_sibling_corner	RIGHT
        }

		FooterButtons
		{
			ControlName				CNestedPanel
			InheritProperties       FooterButtons
		}

        FreeRoamPanel
        {
            "ControlName"				"ImagePanel"
            classname                   "FreeRoamUI"
			"wide"						"300"
			"tall"						"780"
            "xpos"                      "10"
			"visible"					"1"
            "scaleImage"				"1"
			"zpos"						"100"
            "fillColor"					"30 30 30 255"
            "drawColor"					"30 30 30 255"

			"pin_to_sibling"			"FreeRoamButton"
			"pin_corner_to_sibling"		"TOP_LEFT"
			"pin_to_sibling_corner"		"TOP_RIGHT"
        }

        "FreeRoamText"
		{
			"ControlName"			"Label"
            classname                   "FreeRoamUI"
			"xpos"                  "0"
			"ypos"					"10"
			"auto_wide_tocontents"	"1"
			"tall"					"30"
			"visible"				"1"
			"wrap"					"0"
			"fontHeight"			"30"
			"zpos"					"5"
			"textAlignment"			"north-west"
			"labelText"				"Select Map"
			"font"					"TitleBoldFont"
			"allcaps"				"1"
			"fgcolor_override"		"200 200 200 255"

			pin_to_sibling			FreeRoamPanel
            pin_corner_to_sibling	BOTTOM
            pin_to_sibling_corner	TOP
		}

        FreeRoamButton0
        {
            ControlName				RuiButton
            classname               "FreeRoamUI"
            wide					280
            tall					120
            ypos                    -5
            xpos                    0
            zpos                    105
            rui                     "ui/gamemode_select_v2_lobby_button.rpak"
            labelText               ""
            visible					1
            tabPosition             1
            cursorVelocityModifier  0.7
            sound_accept            "UI_Menu_GameMode_Select"
            "scriptID"					"0"

            ruiArgs
            {
                lockIconEnabled 0
            }

            pin_to_sibling			FreeRoamPanel
            pin_corner_to_sibling	TOP
            pin_to_sibling_corner	TOP
        }

        FreeRoamButton1
        {
            ControlName				RuiButton
            classname               "FreeRoamUI"
            wide					280
            tall					120
            ypos                    5
            xpos                    0
            zpos                    105
            rui                     "ui/gamemode_select_v2_lobby_button.rpak"
            labelText               ""
            visible					1
            tabPosition             1
            cursorVelocityModifier  0.7
            sound_accept            "UI_Menu_GameMode_Select"
            "scriptID"					"1"

            ruiArgs
            {
                lockIconEnabled 0
            }

            pin_to_sibling			FreeRoamButton0
            pin_corner_to_sibling	TOP_LEFT
            pin_to_sibling_corner	BOTTOM_LEFT
        }

        FreeRoamButton2
        {
            ControlName				RuiButton
            classname               "FreeRoamUI"
            wide					280
            tall					120
            ypos                    5
            xpos                    0
            zpos                    105
            rui                     "ui/gamemode_select_v2_lobby_button.rpak"
            labelText               ""
            visible					1
            tabPosition             1
            cursorVelocityModifier  0.7
            sound_accept            "UI_Menu_GameMode_Select"
            "scriptID"					"2"

            ruiArgs
            {
                lockIconEnabled 0
            }

            pin_to_sibling			FreeRoamButton1
            pin_corner_to_sibling	TOP_LEFT
            pin_to_sibling_corner	BOTTOM_LEFT
        }

        FreeRoamButton3
        {
            ControlName				RuiButton
            classname               "FreeRoamUI"
            wide					280
            tall					120
            ypos                    5
            xpos                    0
            zpos                    105
            rui                     "ui/gamemode_select_v2_lobby_button.rpak"
            labelText               ""
            visible					1
            tabPosition             1
            cursorVelocityModifier  0.7
            sound_accept            "UI_Menu_GameMode_Select"
            "scriptID"					"3"

            ruiArgs
            {
                lockIconEnabled 0
            }

            pin_to_sibling			FreeRoamButton2
            pin_corner_to_sibling	TOP_LEFT
            pin_to_sibling_corner	BOTTOM_LEFT
        }

        FreeRoamButton4
        {
            ControlName				RuiButton
            classname               "FreeRoamUI"
            wide					280
            tall					120
            ypos                    5
            xpos                    0
            zpos                    105
            rui                     "ui/gamemode_select_v2_lobby_button.rpak"
            labelText               ""
            visible					1
            tabPosition             1
            cursorVelocityModifier  0.7
            sound_accept            "UI_Menu_GameMode_Select"
            "scriptID"					"4"

            ruiArgs
            {
                lockIconEnabled 0
            }

            pin_to_sibling			FreeRoamButton3
            pin_corner_to_sibling	TOP_LEFT
            pin_to_sibling_corner	BOTTOM_LEFT
        }

        FreeRoamButton5
        {
            ControlName				RuiButton
            classname               "FreeRoamUI"
            wide					280
            tall					120
            ypos                    5
            xpos                    0
            zpos                    105
            rui                     "ui/gamemode_select_v2_lobby_button.rpak"
            labelText               ""
            visible					1
            tabPosition             1
            cursorVelocityModifier  0.7
            sound_accept            "UI_Menu_GameMode_Select"
            "scriptID"					"5"

            ruiArgs
            {
                lockIconEnabled 0
            }

            pin_to_sibling			FreeRoamButton4
            pin_corner_to_sibling	TOP_LEFT
            pin_to_sibling_corner	BOTTOM_LEFT
        }

        MouseWheelText
		{
			"ControlName"			"Label"
            classname               "FreeRoamUI"
			"xpos"                  "0"
			"ypos"					"10"
			"auto_wide_tocontents"	"1"
			"tall"					"20"
			"visible"				"1"
			"wrap"					"0"
			"fontHeight"			"20"
			"zpos"					"150"
			"labelText"				"%weaponcycle% NEXT/PREV"
			"font"					"TitleBoldFont"
			"allcaps"				"1"
			"fgcolor_override"		"255 255 255 255"

			pin_to_sibling			FreeRoamButton5
            pin_corner_to_sibling	TOP
            pin_to_sibling_corner	BOTTOM
		}
	}
}
