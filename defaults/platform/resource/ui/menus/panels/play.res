"resource/ui/menus/panels/play.res"
{
    Screen
    {
        ControlName				Label
        wide			        %100
        tall			        %100
        labelText				""
        visible					0
    }

    PanelFrame
    {
		ControlName				Label
		xpos					0
		ypos					0
		wide					%100
		tall					%100
		labelText				""
		visible				    0
        bgcolor_override        "0 0 0 64"
        paintbackground         1

        proportionalToParent    1
    }

	ChatRoomTextChat
	{
		ControlName				CBaseHudChat
		xpos					32
		wide					992
		tall					208
		visible 				1
		enabled					1

		destination				"chatroom"
		interactive				1
		chatBorderThickness		1
		messageModeAlwaysOn		1
        setUnusedScrollbarInvisible 1
		hideInputBox			1 [$GAMECONSOLE]
		font 					Default_27
		zpos                    2

		bgcolor_override 		"0 0 0 0"
		chatHistoryBgColor		"24 27 30 10"
		chatEntryBgColor		"24 27 30 100"
		chatEntryBgColorFocused	"24 27 30 120"

        pin_to_sibling			ReadyButton
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	BOTTOM_RIGHT
	}

    AccessibilityHint
    {
        ControlName             RuiPanel
        classname               "MenuButton"
        wide                    300
        tall                    40
        visible                 1

        rui                     "ui/accessibility_hint.rpak"

        ruiArgs
        {
            buttonText          "#MENU_ACCESSIBILITY_CHAT_HINT" [!$PC]
            buttonText          "#MENU_ACCESSIBILITY_CHAT_HINT_PC" [$PC] // controller chat option only on console
            buttonTextPC        "#MENU_ACCESSIBILITY_CHAT_HINT_PC"
        }

        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling			ChatRoomTextChat
        pin_to_sibling_corner	TOP_LEFT
    }

    FillButton
    {
        ControlName				RuiButton
        classname               "MenuButton"
        wide					367
        tall					38
        ypos                    16
        rui                     "ui/generic_button.rpak"
        labelText               ""
        visible					1
        cursorVelocityModifier  0.7

        navUp                   InviteFriendsButton0
        navRight                InviteFriendsButton0
        navDown                 ModeButton

        proportionalToParent    1

        pin_to_sibling			ModeButton
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }

    ModeButton
    {
        ControlName				RuiButton
        classname               "MenuButton"
        wide					367
        tall					76
        ypos                    16
        zpos                    10
        rui                     "ui/generic_dropdown_button.rpak"
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


    EliteBadge
    {
        ControlName				RuiButton
        wide					96
        tall					96
        ypos                    0
        xpos                    0
        zpos                    20
        rui                     "ui/elite_badge_lobby.rpak"
        labelText               ""
        visible					1

        proportionalToParent    1

        pin_to_sibling			ModeButton
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }

    RankedBadge
    {
        ControlName				RuiButton
        wide					367
        tall					139
        ypos                    0
        xpos                    0
        rui                     "ui/ranked_badge_lobby.rpak"
        labelText               ""
        visible					0

        proportionalToParent    1

        pin_to_sibling			ModeButton
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }

    AboutButton
    {
        ControlName				RuiButton
        wide					280
        tall					96
        ypos                    5
        xpos                    0
        zpos                    20
        rui                     "ui/about_ltm_button.rpak"

        labelText               ""
        visible					1
        cursorVelocityModifier  0.7

        proportionalToParent    1

        pin_to_sibling			ModeButton
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }

    PlaylistNotificationMessage
    {
        ControlName				RuiPanel

        wide					288
        tall					40

        ypos                    0
        xpos                    0
        zpos					3

        rui						"ui/menu_button_small.rpak"
        labelText               ""
        visible					0

        ruiArgs
        {
            buttonText "#APEX_ELITE_AVAILABLE"
            isSelected 1
        }

        enabled					1
        visible					1
        auto_wide_tocontents 	1
        behave_as_label         1
        ruiDefaultHeight        36
        fontHeight              32

        proportionalToParent    1

        pin_to_sibling			ModeButton
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	TOP_LEFT
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

		navUp                   ModeButton

        proportionalToParent    1

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT

        sound_focus             "UI_Menu_Focus_Large"
    }

    InviteFriendsButton0
    {
        ControlName				RuiButton
        InheritProperties       InviteButton
        xpos                    -374
        ypos                    -90

        navUp                   FriendButton0
        navRight                FriendButton0
        navLeft                 InviteLastPlayedUnitframe0

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	CENTER
        pin_to_sibling_corner	CENTER
    }

    InviteFriendsButton1
    {
        ControlName				RuiButton
        InheritProperties       InviteButton
        xpos                    374
        ypos                    -90

        navLeft                 FriendButton1
        navRight                OpenLootBoxButton

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	CENTER
        pin_to_sibling_corner	CENTER
    }

    InviteLastSquadHeader
	{
		ControlName				RuiPanel
		//xpos					-30
		ypos					-155
		wide					245
		tall					24
		visible					1
        rui					    "ui/invite_last_squad_header.rpak"

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	LEFT
	}

    InviteLastPlayedUnitframe0
    {
        ControlName             RuiButton

        pin_to_sibling			InviteLastSquadHeader
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        rightClickEvents		1

        ypos                    14

        navRight                InviteFriendsButton0
        navDown                 InviteLastPlayedUnitframe1

        scriptID                0

        wide                    245
        tall                    47

        rui					    "ui/unitframe_lobby_invite_last_squad.rpak"
    }

    InviteLastPlayedUnitframe1
    {
        ControlName             RuiButton

        pin_to_sibling			InviteLastPlayedUnitframe0
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        rightClickEvents		1

        ypos                    20

        navUp                   InviteLastPlayedUnitframe0
        navRight                InviteFriendsButton0
        navDown                 FillButton

        scriptID                1

        wide                    245
        tall                    47

        rui					    "ui/unitframe_lobby_invite_last_squad.rpak"
    }

    SelfButton
    {
        ControlName				RuiButton
        wide					340
        tall					88
        xpos                    0
        ypos                    -30
        rui                     "ui/lobby_friend_button.rpak"
        labelText               ""
        visible					1
        cursorVelocityModifier  0.7
        scriptID                -1
        rightClickEvents		0
        tabPosition             1

        navDown                 FriendButton0
        navLeft                 FriendButton0
        navRight                FriendButton1

        proportionalToParent    1

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP
    }


    FriendButton0
    {
        ControlName				RuiButton
        wide					340
        tall					88
        xpos                    -376
        ypos                    -74
        rui                     "ui/lobby_friend_button.rpak"
        labelText               ""
        visible					1
        cursorVelocityModifier  0.7
        scriptID                0
        rightClickEvents		1

        navLeft                 InviteFriendsButton0
        navRight                SelfButton

        proportionalToParent    1

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP
    }

    FriendButton1
    {
        ControlName				RuiButton
        wide					340
        tall					88
        xpos                    376
        ypos                    -74
        rui                     "ui/lobby_friend_button.rpak"
        labelText               ""
        visible					1
        cursorVelocityModifier  0.7
        scriptID                1
        rightClickEvents		1

        navLeft                 SelfButton
        navRight                InviteFriendsButton1

        proportionalToParent    1

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP
    }

	HDTextureProgress
	{
		ControlName				RuiPanel
		xpos					0
		ypos					70
		zpos					10
		wide					300
		tall					24
		visible					1
		proportionalToParent    1
		rui 					"ui/lobby_hd_progress.rpak"

		pin_to_sibling			TabsCommon
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
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

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP_RIGHT
        pin_to_sibling_corner	TOP_RIGHT
    }

	ChallengesBox
    {
        ControlName				RuiPanel
        wide					308
        tall					86
        visible					0
        rui					    "ui/lobby_challenge_box.rpak"

        pin_to_sibling			TopRightContentAnchor
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

	ChallengesBoxBG
    {
        ControlName				RuiPanel
        wide					400
        tall					86
        visible					0
        rui					    "ui/basic_image.rpak"
        ruiArgs
        {
            basicImageColor     "0 0 0"
            basicImageAlpha     0.0
        }

        pin_to_sibling			ChallengesBox
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

    ChallengeButton0
    {
        ControlName RuiButton

        pin_to_sibling          ChallengesBox
        pin_corner_to_sibling	TOP_RIGHT
        pin_to_sibling_corner	BOTTOM_RIGHT
        xpos                    0
        ypos                    16
        wide					308
        tall					82

        visible                 0
        rui                     "ui/lobby_challenge_box_row.rpak"
    }

    ChallengeButton1
    {
        ControlName RuiButton

        pin_to_sibling          ChallengeButton0
        pin_corner_to_sibling	TOP_RIGHT
        pin_to_sibling_corner	BOTTOM_RIGHT
        xpos                    0
        ypos                    9
        wide					308
        tall					82

        visible                 0
        rui                     "ui/lobby_challenge_box_row.rpak"
    }

    ChallengeButton2
    {
        ControlName RuiButton

        pin_to_sibling          ChallengeButton1
        pin_corner_to_sibling	TOP_RIGHT
        pin_to_sibling_corner	BOTTOM_RIGHT
        xpos                    0
        ypos                    9
        wide					308
        tall					82

        visible                 0
        rui                     "ui/lobby_challenge_box_row.rpak"
    }

    ChallengeButton3
    {
        ControlName RuiButton

        pin_to_sibling          ChallengeButton2
        pin_corner_to_sibling	TOP_RIGHT
        pin_to_sibling_corner	BOTTOM_RIGHT
        xpos                    0
        ypos                    9
        wide					308
        tall					82

        visible                 0
        rui                     "ui/lobby_challenge_box_row.rpak"
    }

    ChallengeButton4
    {
        ControlName RuiButton

        pin_to_sibling          ChallengeButton3
        pin_corner_to_sibling	TOP_RIGHT
        pin_to_sibling_corner	BOTTOM_RIGHT
        xpos                    0
        ypos                    9
        wide					308
        tall					82

        visible                 0
        rui                     "ui/lobby_challenge_box_row.rpak"
    }

    AllChallengesButton
    {
        ControlName			    RuiButton
        ypos                    24
        zpos			        3
        wide			        400 // intentionally goes off screen
        tall			        64
        visible			        0
        labelText               ""
        rui					    "ui/lobby_all_challenges_button.rpak"
        proportionalToParent    1
        sound_focus             "UI_Menu_Focus_Small"
        cursorVelocityModifier  0.7
        pin_to_sibling			ChallengeButton2
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

    MiniPromo
    {
        ControlName				RuiButton
        wide                    308
        tall                    106
        rui                     "ui/mini_promo.rpak"
        visible					0
        cursorVelocityModifier  0.7

        proportionalToParent    1

        navLeft                 InviteFriendsButton1

        pin_to_sibling          TopRightContentAnchor
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT

        sound_focus             "UI_Menu_Focus_Large"
        sound_accept            ""
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    //ChatroomPanel
    //{
    //    ControlName				CNestedPanel
    //    ypos					0
    //    wide					%100
    //    tall					308
    //    visible					1
    //    controlSettingsFile		"resource/ui/menus/panels/chatroom.res"
    //    proportionalToParent    1
    //    pin_to_sibling          PanelFrame
    //    pin_corner_to_sibling	BOTTOM_RIGHT
    //    pin_to_sibling_corner	BOTTOM_RIGHT
    //}

    //OpenInvitePanel
    //{
    //    ControlName				CNestedPanel
    //    xpos					c-300
    //    ypos					r670
    //    zpos					10
    //    wide					552
    //    tall					440
    //    visible					0
    //    controlSettingsFile		"resource/ui/menus/panels/community_openinvites.res"
    //}

    //InviteNetworkButton
    //{
    //    ControlName				RuiButton
    //    wide					320
    //    tall					80
    //    ypos                    16
    //    zpos                    3
    //    rui                     "ui/prototype_generic_button.rpak"
    //    labelText               ""
    //    visible					1
	//
    //    proportionalToParent    1
	//
    //    pin_to_sibling			InviteFriendsButton0
    //    pin_corner_to_sibling	TOP
    //    pin_to_sibling_corner	BOTTOM
    //}

    UserInfo
    {
        ControlName				CNestedPanel

        xpos                    0
        ypos                    0
        tall					500

        zpos					5
        wide					%28
        visible					0
        controlSettingsFile		"resource/ui/menus/panels/user_info.res"
        pin_to_sibling          PanelFrame
        pin_corner_to_sibling	BOTTOM_RIGHT
        pin_to_sibling_corner	BOTTOM_RIGHT
    }

    MatchDetails
    {
        ControlName				CNestedPanel
        xpos					650
        ypos					180
        wide					780
        tall					470
        visible					0
        controlSettingsFile		"resource/ui/menus/panels/match_info.res"
    }

    PopupMessage
    {
        ControlName				RuiButton
        wide        650
        tall        170
        ypos        -25
        rui         "ui/bp_popup_widget.rpak"

        visible     0
        enabled     1
        zpos        100

        pin_to_sibling          PanelFrame
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP
    }
}