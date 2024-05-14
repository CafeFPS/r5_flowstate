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

        GameModeSelectPanel
        {
            ControlName				RuiButton
            classname               "MenuButton"
            wide					1500
            tall					475
            xpos                    -48
            ypos                    -110
            zpos                    5
            rui                     "ui/gamemode_select_v2_bg_panel.rpak"
            labelText               ""
            visible					1
            cursorVelocityModifier  0.7

            pin_to_sibling			CloseButton
            pin_corner_to_sibling	BOTTOM_LEFT
            pin_to_sibling_corner	BOTTOM_LEFT
        }

		GameModeSelectAnchor
		{
			ControlName				Label
            labelText               ""

            wide					0
            tall					0
            xpos                    0
            ypos                    -80

            pin_to_sibling			GameModeSelectPanel
            pin_corner_to_sibling	TOP_LEFT
            pin_to_sibling_corner	TOP_LEFT
		}

        GameModeButton0
        {
            ControlName				RuiButton
            classname               "MenuButton"
            wide					160
            tall					365
            xpos                    48
            zpos                    10
            rui                     "ui/gamemode_select_v2_button.rpak"
            labelText               ""
            visible					1
            tabPosition             1
            cursorVelocityModifier  0.7
            sound_accept            "UI_Menu_GameMode_Select"

            ruiArgs
            {
                lockIconEnabled 0
            }


            navRight                GameModeButton1

            pin_to_sibling			GameModeSelectAnchor
            pin_corner_to_sibling	TOP_LEFT
            pin_to_sibling_corner	TOP_RIGHT
        }


        GameModeButton1
        {
            ControlName				RuiButton
            classname               "MenuButton"
            wide					160
            tall					365
            xpos                    48
            zpos                    10
            rui                     "ui/gamemode_select_v2_button.rpak"
            labelText               ""
            visible					1
            cursorVelocityModifier  0.7
            sound_accept            "UI_Menu_GameMode_Select"

            navLeft                 GameModeButton0
            navRight                GameModeButton2

            pin_to_sibling			GameModeButton0
            pin_corner_to_sibling	TOP_LEFT
            pin_to_sibling_corner	TOP_RIGHT
        }


        GameModeButton2
        {
            ControlName				RuiButton
            classname               "MenuButton"
            wide					365
            tall					365
            xpos                    48
            zpos                    10
            rui                     "ui/gamemode_select_v2_button.rpak"
            labelText               ""
            visible					1
            cursorVelocityModifier  0.7
            sound_accept            "UI_Menu_GameMode_Select"

            navLeft                 GameModeButton1
            navRight                GameModeButton3

            pin_to_sibling			GameModeButton1
            pin_corner_to_sibling	TOP_LEFT
            pin_to_sibling_corner	TOP_RIGHT
        }


        GameModeButton3
        {
            ControlName				RuiButton
            classname               "MenuButton"
            wide					365
            tall					365
            xpos                    48
            zpos                    10
            rui                     "ui/gamemode_select_v2_button.rpak"
            labelText               ""
            visible					1
            cursorVelocityModifier  0.7
            sound_accept            "UI_Menu_GameMode_Select"

            navLeft                 GameModeButton2
            navRight                GameModeButton4

            pin_to_sibling			GameModeButton2
            pin_corner_to_sibling	TOP_LEFT
            pin_to_sibling_corner	TOP_RIGHT
        }


        GameModeButton4
        {
            ControlName				RuiButton
            classname               "MenuButton"
            wide					365
            tall					365
            xpos                    48
            zpos                    10
            rui                     "ui/gamemode_select_v2_button.rpak"
            labelText               ""
            visible					1
            cursorVelocityModifier  0.7
            sound_accept            "UI_Menu_GameMode_Select"

            navLeft                 GameModeButton3

            pin_to_sibling			GameModeButton3
            pin_corner_to_sibling	TOP_LEFT
            pin_to_sibling_corner	TOP_RIGHT
        }

		FooterButtons
		{
			ControlName				CNestedPanel
			InheritProperties       FooterButtons
		}
	}
}
