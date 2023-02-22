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
				isSelected 0
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
				isSelected 1
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

        BtnServerName
        {
            ControlName				TextEntry
            zpos					100 // This works around input weirdness when the control is constructed by code instead of VGUI blackbox.
            wide					600
            tall					50
            ypos                    -198
            xpos                    -120
            zpos					70
            allowRightClickMenu		0
            allowSpecialCharacters	0
            unicode					0

            keyboardTitle			"Enter Server Name"
            keyboardDescription		"Enter Server Name"

            visible					1
            enabled					1
            textHidden				0
            editable				1
            maxchars				100
            textAlignment			"center"
            ruiFont                 TitleRegularFont
            ruiFontHeight           22
            ruiMinFontHeight        16
            bgcolor_override		"30 30 30 200"

            pin_to_sibling			ScreenFrame
            pin_corner_to_sibling	TOP_RIGHT
            pin_to_sibling_corner	TOP_RIGHT
        }

        "ServerNameText"
		{
			"ControlName"			"Label"
			"xpos"                  "0"
			"ypos"					"10"
			"auto_wide_tocontents"	"1"
			"tall"					"25"
			"visible"				"1"
			"wrap"					"0"
			"fontHeight"			"25"
			"zpos"					"5"
			"textAlignment"			"north-west"
			"labelText"				"Server Name:"
			"font"					"TitleBoldFont"
			"allcaps"				"1"
			"fgcolor_override"		"200 200 200 255"

			"pin_to_sibling"		"BtnServerName"
			"pin_corner_to_sibling"	"BOTTOM"
			"pin_to_sibling_corner"	"TOP"
		}

        BtnServerDesc
        {
            ControlName				TextEntry
            zpos					100 // This works around input weirdness when the control is constructed by code instead of VGUI blackbox.
            wide					600
            tall					50
            ypos                    50
            xpos                    0
            zpos					70
            allowRightClickMenu		0
            allowSpecialCharacters	0
            unicode					0

            keyboardTitle			"Enter Server Name"
            keyboardDescription		"Enter Server Name"

            visible					1
            enabled					1
            textHidden				0
            editable				1
            maxchars				100
            textAlignment			"center"
            ruiFont                 TitleRegularFont
            ruiFontHeight           22
            ruiMinFontHeight        16
            bgcolor_override		"30 30 30 200"

            pin_to_sibling			BtnServerName
            pin_corner_to_sibling	TOP_RIGHT
            pin_to_sibling_corner	BOTTOM_RIGHT
        }

        "ServerDescText"
		{
			"ControlName"			"Label"
			"xpos"                  "0"
			"ypos"					"10"
			"auto_wide_tocontents"	"1"
			"tall"					"25"
			"visible"				"1"
			"wrap"					"0"
			"fontHeight"			"25"
			"zpos"					"5"
			"textAlignment"			"north-west"
			"labelText"				"Server Name:"
			"font"					"TitleBoldFont"
			"allcaps"				"1"
			"fgcolor_override"		"200 200 200 255"

			"pin_to_sibling"		"BtnServerDesc"
			"pin_corner_to_sibling"	"BOTTOM"
			"pin_to_sibling_corner"	"TOP"
		}

        SwtBtnVisibility
        {
            ControlName RuiButton
            InheritProperties SwitchButton
            style                   DialogListButton
            ConVar "menu_faq_community_version"
            classname FilterPanelChild
            wide 600
            ypos                    30
            xpos                    0

            ruiArgs
            {
                buttonText "Server Visibility"
            }

            list
            {
                "Offline" 0
                "Visible" 1
                "Hidden" 2
            }

            pin_to_sibling			BtnServerDesc
            pin_corner_to_sibling	TOP_RIGHT
            pin_to_sibling_corner	BOTTOM_RIGHT

            childGroupAlways        MultiChoiceButtonAlways
        }

        "SettingsText"
		{
			"ControlName"			"Label"
			"xpos"                  "0"
			"ypos"					"60"
			"auto_wide_tocontents"	"1"
			"tall"					"30"
			"visible"				"1"
			"wrap"					"0"
			"fontHeight"			"30"
			"zpos"					"5"
			"textAlignment"			"north-west"
			"labelText"				"Server Settings"
			"font"					"TitleBoldFont"
			"allcaps"				"1"
			"fgcolor_override"		"200 200 200 255"

			"pin_to_sibling"		"BtnServerName"
			"pin_corner_to_sibling"	"BOTTOM"
			"pin_to_sibling_corner"	"TOP"
		}

        SaveBtn
        {
            ControlName				RuiButton
            wide					600
            tall					120
            ypos                    -100
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
                modeNameText "Create Private Match"
                modeDescText ""
                modeImage "rui/menu/store/feature_background_square"
            }

            pin_to_sibling			ScreenFrame
            pin_corner_to_sibling	BOTTOM_RIGHT
            pin_to_sibling_corner	BOTTOM_RIGHT
        }

        "ErrorText"
		{
			"ControlName"			"Label"
			"xpos"                  "0"
			"ypos"					"10"
			"auto_wide_tocontents"	"1"
			"tall"					"30"
			"visible"				"0"
			"wrap"					"0"
			"fontHeight"			"30"
			"zpos"					"5"
			"textAlignment"			"north-west"
			"labelText"				""
			"font"					"TitleBoldFont"
			"allcaps"				"1"
			"fgcolor_override"		"200 30 30 255"

			"pin_to_sibling"		"SaveBtn"
			"pin_corner_to_sibling"	"TOP"
			"pin_to_sibling_corner"	"BOTTOM"
		}

        "SettingsBG"
        {
            "ControlName"			"Label"
            "xpos"					"2"
            "ypos"					"50"
            "zpos"					"1"
            "wide"					"600"
            "tall"					"700"
            "labelText"				""
            "bgcolor_override"		"100 100 100 150"
            "visible"				"1"
            "paintbackground"		"1"

            "pin_to_sibling"		"BtnServerName"
            "pin_corner_to_sibling"	"TOP"
            "pin_to_sibling_corner"	"TOP"
        }

        //Row 1
        MapButton0
        {
            ControlName				RuiButton
            classname               "MapButton"
            wide					280
            tall					120
            ypos                    125
            xpos                    -120
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
                modeNameText "Map Name"
                modeDescText ""
                //modeImage "rui/menu/gamemode/firing_range"
            }

            pin_to_sibling			ScreenFrame
            pin_corner_to_sibling	LEFT
            pin_to_sibling_corner	LEFT
        }

        MapButton1
        {
            ControlName				RuiButton
            classname               "MapButton"
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
            sound_accept            "UI_Menu_GameMode_Select"
            "scriptID"					"1"

            ruiArgs
            {
                lockIconEnabled 0
                modeNameText "Map Name"
                modeDescText ""
                //modeImage "rui/menu/gamemode/firing_range"
            }

            pin_to_sibling			MapButton0
            pin_corner_to_sibling	LEFT
            pin_to_sibling_corner	RIGHT
        }

        MapButton2
        {
            ControlName				RuiButton
            classname               "MapButton"
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
            sound_accept            "UI_Menu_GameMode_Select"
            "scriptID"					"2"

            ruiArgs
            {
                lockIconEnabled 0
                modeNameText "Map Name"
                modeDescText ""
                //modeImage "rui/menu/gamemode/firing_range"
            }

            pin_to_sibling			MapButton1
            pin_corner_to_sibling	LEFT
            pin_to_sibling_corner	RIGHT
        }

        //Row 2
        MapButton3
        {
            ControlName				RuiButton
            classname               "MapButton"
            wide					280
            tall					120
            ypos                    10
            xpos                    0
            zpos                    10
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
                modeNameText "Map Name"
                modeDescText ""
                //modeImage "rui/menu/gamemode/firing_range"
            }

            pin_to_sibling			MapButton0
            pin_corner_to_sibling	TOP
            pin_to_sibling_corner	BOTTOM
        }

        MapButton4
        {
            ControlName				RuiButton
            classname               "MapButton"
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
            sound_accept            "UI_Menu_GameMode_Select"
            "scriptID"					"4"

            ruiArgs
            {
                lockIconEnabled 0
                modeNameText "Map Name"
                modeDescText ""
                //modeImage "rui/menu/gamemode/firing_range"
            }

            pin_to_sibling			MapButton3
            pin_corner_to_sibling	LEFT
            pin_to_sibling_corner	RIGHT
        }

        MapButton5
        {
            ControlName				RuiButton
            classname               "MapButton"
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
            sound_accept            "UI_Menu_GameMode_Select"
            "scriptID"					"5"

            ruiArgs
            {
                lockIconEnabled 0
                modeNameText "Map Name"
                modeDescText ""
                //modeImage "rui/menu/gamemode/firing_range"
            }

            pin_to_sibling			MapButton4
            pin_corner_to_sibling	LEFT
            pin_to_sibling_corner	RIGHT
        }

        //Row 3
        MapButton6
        {
            ControlName				RuiButton
            classname               "MapButton"
            wide					280
            tall					120
            ypos                    10
            xpos                    0
            zpos                    10
            rui                     "ui/gamemode_select_v2_lobby_button.rpak"
            labelText               ""
            visible					1
            tabPosition             1
            cursorVelocityModifier  0.7
            sound_accept            "UI_Menu_GameMode_Select"
            "scriptID"					"6"

            ruiArgs
            {
                lockIconEnabled 0
                modeNameText "Map Name"
                modeDescText ""
                //modeImage "rui/menu/gamemode/firing_range"
            }

            pin_to_sibling			MapButton3
            pin_corner_to_sibling	TOP
            pin_to_sibling_corner	BOTTOM
        }

        MapButton7
        {
            ControlName				RuiButton
            classname               "MapButton"
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
            sound_accept            "UI_Menu_GameMode_Select"
            "scriptID"					"7"

            ruiArgs
            {
                lockIconEnabled 0
                modeNameText "Map Name"
                modeDescText ""
                //modeImage "rui/menu/gamemode/firing_range"
            }

            pin_to_sibling			MapButton6
            pin_corner_to_sibling	LEFT
            pin_to_sibling_corner	RIGHT
        }

        MapButton8
        {
            ControlName				RuiButton
            classname               "MapButton"
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
            sound_accept            "UI_Menu_GameMode_Select"
            "scriptID"					"8"

            ruiArgs
            {
                lockIconEnabled 0
                modeNameText "Map Name"
                modeDescText ""
                //modeImage "rui/menu/gamemode/firing_range"
            }

            pin_to_sibling			MapButton7
            pin_corner_to_sibling	LEFT
            pin_to_sibling_corner	RIGHT
        }

        "MapText"
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
			"labelText"				"Select Map"
			"font"					"TitleBoldFont"
			"allcaps"				"1"
			"fgcolor_override"		"200 200 200 255"

			"pin_to_sibling"		"MapButton1"
			"pin_corner_to_sibling"	"BOTTOM"
			"pin_to_sibling_corner"	"TOP"
		}

        //Row 1
        PlaylistButton0
        {
            ControlName				RuiButton
            classname               "PlaylistButton"
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
            "scriptID"					"0"

            ruiArgs
            {
                lockIconEnabled 0
                modeNameText "Playlist Name"
                modeDescText ""
                //modeImage "rui/menu/gamemode/firing_range"
            }

            pin_to_sibling			ScreenFrame
            pin_corner_to_sibling	TOP_LEFT
            pin_to_sibling_corner	TOP_LEFT
        }

        PlaylistButton1
        {
            ControlName				RuiButton
            classname               "PlaylistButton"
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
            sound_accept            "UI_Menu_GameMode_Select"
            "scriptID"					"1"

            ruiArgs
            {
                lockIconEnabled 0
                modeNameText "Playlist Name"
                modeDescText ""
                //modeImage "rui/menu/gamemode/firing_range"
            }

            pin_to_sibling			PlaylistButton0
            pin_corner_to_sibling	LEFT
            pin_to_sibling_corner	RIGHT
        }

        PlaylistButton2
        {
            ControlName				RuiButton
            classname               "PlaylistButton"
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
            sound_accept            "UI_Menu_GameMode_Select"
            "scriptID"					"2"

            ruiArgs
            {
                lockIconEnabled 0
                modeNameText "Playlist Name"
                modeDescText ""
                //modeImage "rui/menu/gamemode/firing_range"
            }

            pin_to_sibling			PlaylistButton1
            pin_corner_to_sibling	LEFT
            pin_to_sibling_corner	RIGHT
        }

        //Row 2
        PlaylistButton3
        {
            ControlName				RuiButton
            classname               "PlaylistButton"
            wide					280
            tall					120
            ypos                    10
            xpos                    0
            zpos                    10
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
                modeNameText "Playlist Name"
                modeDescText ""
                //modeImage "rui/menu/gamemode/firing_range"
            }

            pin_to_sibling			PlaylistButton0
            pin_corner_to_sibling	TOP
            pin_to_sibling_corner	BOTTOM
        }

        PlaylistButton4
        {
            ControlName				RuiButton
            classname               "PlaylistButton"
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
            sound_accept            "UI_Menu_GameMode_Select"
            "scriptID"					"4"

            ruiArgs
            {
                lockIconEnabled 0
                modeNameText "Playlist Name"
                modeDescText ""
                //modeImage "rui/menu/gamemode/firing_range"
            }

            pin_to_sibling			PlaylistButton3
            pin_corner_to_sibling	LEFT
            pin_to_sibling_corner	RIGHT
        }

        PlaylistButton5
        {
            ControlName				RuiButton
            classname               "PlaylistButton"
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
            sound_accept            "UI_Menu_GameMode_Select"
            "scriptID"					"5"

            ruiArgs
            {
                lockIconEnabled 0
                modeNameText "Playlist Name"
                modeDescText ""
                //modeImage "rui/menu/gamemode/firing_range"
            }

            pin_to_sibling			PlaylistButton4
            pin_corner_to_sibling	LEFT
            pin_to_sibling_corner	RIGHT
        }

        //Row 3
        PlaylistButton6
        {
            ControlName				RuiButton
            classname               "PlaylistButton"
            wide					280
            tall					120
            ypos                    10
            xpos                    0
            zpos                    10
            rui                     "ui/gamemode_select_v2_lobby_button.rpak"
            labelText               ""
            visible					1
            tabPosition             1
            cursorVelocityModifier  0.7
            sound_accept            "UI_Menu_GameMode_Select"
            "scriptID"					"6"

            ruiArgs
            {
                lockIconEnabled 0
                modeNameText "Playlist Name"
                modeDescText ""
                //modeImage "rui/menu/gamemode/firing_range"
            }

            pin_to_sibling			PlaylistButton3
            pin_corner_to_sibling	TOP
            pin_to_sibling_corner	BOTTOM
        }

        PlaylistButton7
        {
            ControlName				RuiButton
            classname               "PlaylistButton"
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
            sound_accept            "UI_Menu_GameMode_Select"
            "scriptID"					"7"

            ruiArgs
            {
                lockIconEnabled 0
                modeNameText "Playlist Name"
                modeDescText ""
                //modeImage "rui/menu/gamemode/firing_range"
            }

            pin_to_sibling			PlaylistButton6
            pin_corner_to_sibling	LEFT
            pin_to_sibling_corner	RIGHT
        }

        PlaylistButton8
        {
            ControlName				RuiButton
            classname               "PlaylistButton"
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
            sound_accept            "UI_Menu_GameMode_Select"
            "scriptID"					"8"

            ruiArgs
            {
                lockIconEnabled 0
                modeNameText "Playlist Name"
                modeDescText ""
                //modeImage "rui/menu/gamemode/firing_range"
            }

            pin_to_sibling			PlaylistButton7
            pin_corner_to_sibling	LEFT
            pin_to_sibling_corner	RIGHT
        }

        "PlaylistText"
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
			"labelText"				"Select Playlist"
			"font"					"TitleBoldFont"
			"allcaps"				"1"
			"fgcolor_override"		"200 200 200 255"

			"pin_to_sibling"		"PlaylistButton1"
			"pin_corner_to_sibling"	"BOTTOM"
			"pin_to_sibling_corner"	"TOP"
		}

        //Map Slider
        "MapListSliderBG"
        {
            "ControlName"			"ImagePanel"
            wide 32
            tall 335
            xpos 10
            ypos -45
            zpos 0
            "fillColor"				"195 29 38 150"
            scaleImage				1
            "visible"				"0"

            pin_to_sibling MapButton2
            pin_corner_to_sibling TOP_LEFT
            pin_to_sibling_corner TOP_RIGHT
        }

        BtnMapListSlider
        {
            ControlName RuiButton
            InheritProperties RuiSmallButton
            //labelText "V"
            wide 30
            tall 290
            xpos 10
            ypos -45
            zpos 0

            image "vgui/hud/white"
            drawColor "255 255 255 255"

            pin_to_sibling MapButton2
            pin_corner_to_sibling TOP_LEFT
            pin_to_sibling_corner TOP_RIGHT
        }

        BtnMapListSliderPanel
        {
            ControlName RuiPanel
            wide 30
            tall 290
            xpos 10
            ypos -45
            zpos 100

            rui "ui/control_options_description.rpak"

            visible 1
            zpos -1

            pin_to_sibling MapButton2
            pin_corner_to_sibling TOP_LEFT
            pin_to_sibling_corner TOP_RIGHT
        }

        // sh_menu_models.gnut has a global function which gets called when
        // left mouse button gets called while hovering and has mouse
        // deltaX; deltaY which we can yoink for ourselfes
        MapMouseMovementCapture
        {
            ControlName CMouseMovementCapturePanel
            wide 30
            tall 290
            xpos 10
            ypos -45
            zpos 100

            pin_to_sibling MapButton2
            pin_corner_to_sibling TOP_LEFT
            pin_to_sibling_corner TOP_RIGHT
        }

        BtnMapListUpArrow
        {
            ControlName RuiButton
            InheritProperties RuiSmallButton
            //labelText "A"
            wide 30
            tall 45
            xpos 0
            ypos 0
            zpos 5

            image "vgui/hud/white"
            drawColor "255 255 255 128"

            pin_to_sibling MapListSliderBG
            pin_corner_to_sibling BOTTOM_LEFT
            pin_to_sibling_corner TOP_LEFT
        }

        BtnMapListUpArrowPanel
        {
            ControlName RuiPanel
            wide 30
            tall 45
            xpos 0
            ypos 0

            rui "ui/control_options_description.rpak"

            visible 1
            zpos 4

            pin_to_sibling MapListSliderBG
            pin_corner_to_sibling BOTTOM_LEFT
            pin_to_sibling_corner TOP_LEFT
        }

        BtnMapListDownArrow
        {
            ControlName RuiButton
            InheritProperties RuiSmallButton
            //labelText "A"
            wide 30
            tall 45
            xpos 0
            ypos 0
            zpos 5

            image "vgui/hud/white"
            drawColor "255 255 255 128"

            pin_to_sibling MapListSliderBG
            pin_corner_to_sibling BOTTOM_LEFT
            pin_to_sibling_corner BOTTOM_LEFT
        }

        BtnMapListDownArrowPanel
        {
            ControlName RuiPanel
            wide 30
            tall 45
            xpos 0
            ypos 0

            rui "ui/control_options_description.rpak"

            visible 1
            zpos 4

            pin_to_sibling MapListSliderBG
            pin_corner_to_sibling BOTTOM_LEFT
            pin_to_sibling_corner BOTTOM_LEFT
        }

        //Playlist Slider
        "PlaylistListSliderBG"
        {
            "ControlName"			"ImagePanel"
            wide 32
            tall 335
            xpos 10
            ypos -45
            zpos 0
            "fillColor"				"195 29 38 150"
            scaleImage				1
            "visible"				"0"

            pin_to_sibling PlaylistButton2
            pin_corner_to_sibling TOP_LEFT
            pin_to_sibling_corner TOP_RIGHT
        }

        PlaylistMapListSlider
        {
            ControlName RuiButton
            InheritProperties RuiSmallButton
            //labelText "V"
            wide 30
            tall 290
            xpos 10
            ypos -45
            zpos 0

            image "vgui/hud/white"
            drawColor "255 255 255 255"

            pin_to_sibling PlaylistButton2
            pin_corner_to_sibling TOP_LEFT
            pin_to_sibling_corner TOP_RIGHT
        }

        PlaylistMapListSliderPanel
        {
            ControlName RuiPanel
            wide 30
            tall 290
            xpos 10
            ypos -45
            zpos 100

            rui "ui/control_options_description.rpak"

            visible 1
            zpos -1

            pin_to_sibling PlaylistButton2
            pin_corner_to_sibling TOP_LEFT
            pin_to_sibling_corner TOP_RIGHT
        }

        // sh_menu_models.gnut has a global function which gets called when
        // left mouse button gets called while hovering and has mouse
        // deltaX; deltaY which we can yoink for ourselfes
        PlaylistMouseMovementCapture
        {
            ControlName CMouseMovementCapturePanel
            wide 30
            tall 290
            xpos 10
            ypos -45
            zpos 100

            pin_to_sibling PlaylistButton2
            pin_corner_to_sibling TOP_LEFT
            pin_to_sibling_corner TOP_RIGHT
        }

        BtnPlaylistListUpArrow
        {
            ControlName RuiButton
            InheritProperties RuiSmallButton
            //labelText "A"
            wide 30
            tall 45
            xpos 0
            ypos 0
            zpos 5

            image "vgui/hud/white"
            drawColor "255 255 255 128"

            pin_to_sibling PlaylistListSliderBG
            pin_corner_to_sibling BOTTOM_LEFT
            pin_to_sibling_corner TOP_LEFT
        }

        BtnPlaylistListUpArrowPanel
        {
            ControlName RuiPanel
            wide 30
            tall 45
            xpos 0
            ypos 0

            rui "ui/control_options_description.rpak"

            visible 1
            zpos 4

            pin_to_sibling PlaylistListSliderBG
            pin_corner_to_sibling BOTTOM_LEFT
            pin_to_sibling_corner TOP_LEFT
        }

        BtnPlaylistListDownArrow
        {
            ControlName RuiButton
            InheritProperties RuiSmallButton
            //labelText "A"
            wide 30
            tall 45
            xpos 0
            ypos 0
            zpos 5

            image "vgui/hud/white"
            drawColor "255 255 255 128"

            pin_to_sibling PlaylistListSliderBG
            pin_corner_to_sibling BOTTOM_LEFT
            pin_to_sibling_corner BOTTOM_LEFT
        }

        BtnPlaylistListDownArrowPanel
        {
            ControlName RuiPanel
            wide 30
            tall 45
            xpos 0
            ypos 0

            rui "ui/control_options_description.rpak"

            visible 1
            zpos 4

            pin_to_sibling PlaylistListSliderBG
            pin_corner_to_sibling BOTTOM_LEFT
            pin_to_sibling_corner BOTTOM_LEFT
        }
	}
}
