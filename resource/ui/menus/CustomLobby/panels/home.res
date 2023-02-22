"scripts/resource/ui/menus/CustomLobby/panels/home.res"
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

	TopRightContentAnchor
    {
        ControlName				Label
        wide					308
        tall					45
        labelText               ""
        //visible					1
        //bgcolor_override        "0 255 0 64"
        //paintbackground         1
		xpos					-50

        pin_to_sibling			DarkenBackground
        pin_corner_to_sibling	TOP_RIGHT
        pin_to_sibling_corner	TOP_RIGHT
    }

	R5ReloadedBox
    {
        ControlName				RuiPanel
        wide					308
        tall					86
        visible					1
		"zpos"					"10"
        rui					    "ui/lobby_challenge_box.rpak"

		ruiArgs
        {
            headerText     "Welcome To"
			subText		   "R5Reloaded"
        }

        pin_to_sibling			TopRightContentAnchor
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

	R5ReloadedBoxLogo
    {
        ControlName				RuiPanel
        wide					100
        tall					100
		"zpos"					"20"
        visible					1
        rui					    "ui/basic_image.rpak"
        ruiArgs
        {
            basicImage     "rui/hud/custom_badges/r5r_badge"
        }

        pin_to_sibling			R5ReloadedBox
        pin_corner_to_sibling	CENTER
        pin_to_sibling_corner	LEFT
    }

	"R5ReloadedBoxBG"
	{
        "ControlName"			"ImagePanel"
		"wide"					"508"
		"tall"					"300"
		"visible"				"1"
        "scaleImage"			"1"
		"zpos"					"1"
        "fillColor"				"30 30 30 200"
        "drawColor"				"30 30 30 200"

		"pin_to_sibling"		"R5ReloadedBox"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"BOTTOM_LEFT"
	}

	"Info"
	{
        "ControlName"			"Label"
		"xpos"                  "-15"
		"ypos"					"-5"
		"wide"					"325"
		"tall"					"300"
		"visible"				"1"
		"wrap"					"1"
		"fontHeight"			"25"
		"zpos"					"5"
		"textAlignment"			"north-west"
		"labelText"				"This project allows you to run APEX Legends with mods, by running the embedded server and loading custom scripts/global compile lists into the scripting VM. This allows you to create custom gamemodes, levels, weapons and more."
		"font"					"DefaultBold_41"
		"allcaps"				"0"
		"fgcolor_override"		"200 200 200 255"

		"pin_to_sibling"		"R5ReloadedBoxBG"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"TOP_LEFT"
	}

    R5RVersionButton
    {
        ControlName			    RuiButton
        ypos                    0
        zpos			        0
        wide			        400 // intentionally goes off screen
        tall			        64
        visible			        1
        labelText               ""
        rui					    "ui/lobby_all_challenges_button.rpak"
        proportionalToParent    1
        sound_focus             "UI_Menu_Focus_Small"
        cursorVelocityModifier  0.7
        pin_to_sibling			R5ReloadedBoxBG
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

	MiniPromo
    {
        ControlName				RuiButton
        wide                    308
        tall                    106
		ypos					25
        rui                     "ui/mini_promo.rpak"
        visible					1
        cursorVelocityModifier  0.7

        proportionalToParent    1

        pin_to_sibling          R5RVersionButton
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT

        sound_focus             "UI_Menu_Focus_Large"
        sound_accept            ""
    }

	ReadyButton
    {
        ControlName				RuiButton
        classname               "MenuButton MatchmakingStatusRui"
        wide					367
        tall					112
        rui                     "ui/generic_ready_button.rpak"
        labelText               ""
        visible					1
		cursorVelocityModifier  0.7
		ypos					-150
		xpos					-50

		navUp                   ModeButton

        proportionalToParent    1

        pin_to_sibling			DarkenBackground
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT

        sound_focus             "UI_Menu_Focus_Large"
    }

	GamemodeSelectV2Button
    {
        ControlName				RuiButton
        classname               "MenuButton MatchmakingStatusRui"
        wide					367
        tall					168
        ypos                    13
        zpos                    10
        rui                     "ui/gamemode_select_v2_lobby_button.rpak"
        labelText               ""
        visible					1
        cursorVelocityModifier  0.7
        sound_accept            "UI_Menu_SelectMode_Extend"

        navUp                   InviteFriendsButton0
        navDown                 ReadyButton
        navRight                InviteFriendsButton0

        proportionalToParent    1

        pin_to_sibling			ReadyButton
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	TOP_LEFT
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

	GameMenuButton
        {
            ControlName				RuiButton
            InheritProperties		CornerButton
            zpos                    5
			ypos					-150
			xpos					-50

            pin_to_sibling			DarkenBackground
            pin_corner_to_sibling	BOTTOM_RIGHT
            pin_to_sibling_corner	BOTTOM_RIGHT
        }

	PlayersButton
        {
            ControlName				RuiButton
            InheritProperties		CornerButton
            xpos                    13
            zpos                    5

            pin_to_sibling			GameMenuButton
            pin_corner_to_sibling	BOTTOM_RIGHT
            pin_to_sibling_corner	BOTTOM_LEFT
        }

	ServersButton
        {
            ControlName				RuiButton
            InheritProperties		CornerButton
            xpos                    13
            zpos                    5

            pin_to_sibling			PlayersButton
            pin_corner_to_sibling	BOTTOM_RIGHT
            pin_to_sibling_corner	BOTTOM_LEFT
        }

	NewsButton
        {
            ControlName				RuiButton
            InheritProperties		CornerButton
            xpos                    13
            zpos                    5

            pin_to_sibling			ServersButton
            pin_corner_to_sibling	BOTTOM_RIGHT
            pin_to_sibling_corner	BOTTOM_LEFT
        }
}

