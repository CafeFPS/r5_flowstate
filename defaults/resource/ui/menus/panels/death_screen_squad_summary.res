resource/ui/menus/panels/death_screen_squad_summary.res
{
    ScreenFrame
    {
        ControlName				ImagePanel
        xpos					0
        ypos					0
        wide					%100
        tall					%100
        visible					1
        enabled 				1
        drawColor				"0 0 0 0"
    }

	Header
	{
		ControlName             RuiPanel
		xpos					0
		ypos					0
		wide 					%100
		tall					%100
		rui 					"ui/squad_summary_header_data.rpak"
		visible					1
		zpos					3

		pin_to_sibling			ScreenFrame
		pin_corner_to_sibling	CENTER
		pin_to_sibling_corner	CENTER
	}

	GCard0
	{
		ControlName             RuiPanel
		xpos					0
		ypos					65
		wide 					500
		tall					705
		rui 					"ui/squad_summary_gladiator_card.rpak"
		visible					1
		zpos					5

		pin_to_sibling			ScreenFrame
		pin_corner_to_sibling	CENTER
		pin_to_sibling_corner	CENTER
	}

	GCard1
	{
		ControlName             RuiPanel
		xpos					100
		ypos					0
		wide 					500
		tall					705
		rui 					"ui/squad_summary_gladiator_card.rpak"
		visible					1
		zpos					5

		pin_to_sibling			GCard0
		pin_corner_to_sibling	RIGHT
		pin_to_sibling_corner	LEFT
	}

	GCard2
	{
		ControlName             RuiPanel
		xpos					100
		ypos					0
		wide 					500
		tall					705
		rui 					"ui/squad_summary_gladiator_card.rpak"
		visible					1
		zpos					5

		pin_to_sibling			GCard0
		pin_corner_to_sibling	LEFT
		pin_to_sibling_corner	RIGHT
	}

//	GCardStats0
//	{
//		ControlName             RuiPanel
//
//		wide 					528
//		tall					912
//
//		scriptID                1
//
//		rui                     "ui/round_end_squad_member_stats_menu.rpak"
//
//		xpos                    0
//		ypos                    0
//		zpos                    10
//
//		visible                 1
//		enabled                 1
//
//		pin_to_sibling          GCard0
//		pin_corner_to_sibling   CENTER
//		pin_to_sibling_corner   CENTER
//	}
//
//	GCardStats1
//	{
//		ControlName             RuiPanel
//
//		wide 					528
//		tall					912
//
//		scriptID                1
//
//		rui                     "ui/round_end_squad_member_stats_menu.rpak"
//
//		xpos                    0
//		ypos                    0
//		zpos                    10
//
//		visible                 1
//		enabled                 1
//
//		pin_to_sibling          GCard1
//		pin_corner_to_sibling   CENTER
//		pin_to_sibling_corner   CENTER
//	}
//
//	GCardStats2
//	{
//		ControlName             RuiPanel
//
//		wide 					528
//		tall					912
//
//		scriptID                1
//
//		rui                     "ui/round_end_squad_member_stats_menu.rpak"
//
//		xpos                    0
//		ypos                    0
//		zpos                    10
//
//		visible                 1
//		enabled                 1
//
//		pin_to_sibling          GCard2
//		pin_corner_to_sibling   CENTER
//		pin_to_sibling_corner   CENTER
//	}

	GCardOverlay1
	{
		ControlName             RuiButton

		wide					500
		tall					680

		scriptID                1

		rui                     "ui/basic_image.rpak"
		ruiArgs
		{

				basicImageAlpha     0.0
		}

		xpos                    0
		ypos                    0
		zpos                    100

		rightClickEvents        1

		visible                 1
		enabled                 1

		pin_to_sibling          GCard1
		pin_corner_to_sibling   CENTER
		pin_to_sibling_corner   CENTER
	}

	GCardOverlay2
	{
		ControlName             RuiButton

		wide					500
		tall					680

		scriptID                2

		rui                     "ui/basic_image.rpak"
		ruiArgs
		{

				basicImageAlpha     0.0
		}


		xpos                    0
		ypos                    0
		zpos                    100

		rightClickEvents        1

		visible                 1
		enabled                 1

		pin_to_sibling          GCard2
		pin_corner_to_sibling   CENTER
		pin_to_sibling_corner   CENTER
	}

	TeammateMute1
	{
		ControlName             RuiButton

		wide					64
		tall					64

		scriptID                1

		rui                     "ui/mute_button.rpak"

		xpos                    -14
		ypos                    -14
		zpos                    110

		visible                 0
		enabled                 1
		cursorVelocityModifier  0.6

		navLeft                 TeammateReport2
		navRight                TeammateMuteChat1

		pin_to_sibling          GCard1
		pin_corner_to_sibling   BOTTOM_LEFT
		pin_to_sibling_corner   BOTTOM_LEFT
	}

	TeammateMuteChat1
	{
		ControlName             RuiButton

		wide					64
		tall					64

		scriptID                1

		rui                     "ui/mute_button.rpak"

		xpos                    5
		ypos                    0
		zpos                    110

		visible                 0
		enabled                 1
		cursorVelocityModifier  0.6

		navLeft                 TeammateMute1
		navRight                TeammateReport1

		pin_to_sibling          TeammateMute1
		pin_corner_to_sibling   BOTTOM_LEFT
		pin_to_sibling_corner   BOTTOM_RIGHT
	}

	TeammateReport1
	{
		ControlName             RuiButton

		wide					64
		tall					64

		scriptID                1

		rui                     "ui/mute_button.rpak"

		xpos                    5
		ypos                    0
		zpos                    110

		visible                 0
		enabled                 1
		cursorVelocityModifier  0.6

		navLeft                 TeammateMuteChat1

		pin_to_sibling          TeammateMuteChat1
		pin_corner_to_sibling   BOTTOM_LEFT
		pin_to_sibling_corner   BOTTOM_RIGHT
	}

	TeammateInvite1
	{
		ControlName             RuiButton

		wide					150
		tall					150

		scriptID                1

		rui                     "ui/invite_button.rpak"

		xpos                    0
		ypos                    -85
		zpos                    110

		visible                 0
		enabled                 1
		cursorVelocityModifier  0.6

		navLeft                 TeammateReport1

		pin_to_sibling          GCard1
		pin_corner_to_sibling   CENTER
		pin_to_sibling_corner   BOTTOM
	}

	TeammateDisconnected1
	{
		ControlName             RuiPanel

		wide					132
		tall					64

		scriptID                1

		rui                     "ui/disconnected_widget.rpak"

		ruiArgs
		{
			textWidth   118.0
			fontSize    24.0
		}

		xpos                    0
		ypos                    0
		zpos                    110

		visible                 0
		enabled                 1
		cursorVelocityModifier  0.6

		pin_to_sibling          TeammateMute1
		pin_corner_to_sibling   LEFT
		pin_to_sibling_corner   LEFT
	}

	TeammateMute2
	{
		ControlName             RuiButton

		wide					64
		tall					64

		scriptID                2

		rui                     "ui/mute_button.rpak"

		xpos                    -14
		ypos                    -14
		zpos                    110

		visible                 0
		enabled                 1
		cursorVelocityModifier  0.6

		navRight                TeammateMuteChat2

		pin_to_sibling          GCard2
		pin_corner_to_sibling   BOTTOM_LEFT
		pin_to_sibling_corner   BOTTOM_LEFT
	}

	TeammateMuteChat2
	{
		ControlName             RuiButton

		wide					64
		tall					64

		scriptID                2

		rui                     "ui/mute_button.rpak"

		xpos                    5
		ypos                    0
		zpos                    110

		visible                 0
		enabled                 1
		cursorVelocityModifier  0.6

		navRight                TeammateReport2
		navLeft                 TeammateMute2

		pin_to_sibling          TeammateMute2
		pin_corner_to_sibling   BOTTOM_LEFT
		pin_to_sibling_corner   BOTTOM_RIGHT
	}

	TeammateReport2
	{
		ControlName             RuiButton

		wide					64
		tall					64

		scriptID                2

		rui                     "ui/mute_button.rpak"

		xpos                    5
		ypos                    0
		zpos                    110

		visible                 0
		enabled                 1
		cursorVelocityModifier  0.6

		navLeft                 TeammateMuteChat2
		navRight                TeammateInvite2

		pin_to_sibling          TeammateMuteChat2
		pin_corner_to_sibling   BOTTOM_LEFT
		pin_to_sibling_corner   BOTTOM_RIGHT
	}

	TeammateInvite2
	{
		ControlName             RuiButton

		wide					150
		tall					150

		scriptID                2

		rui                     "ui/invite_button.rpak"

		xpos                    0
		ypos                    -85
		zpos                    110

		visible                 0
		enabled                 1
		cursorVelocityModifier  0.6

		navRight                TeammateMute1
		navLeft                 TeammateReport2

		pin_to_sibling          GCard2
		pin_corner_to_sibling   CENTER
		pin_to_sibling_corner   BOTTOM
	}

	TeammateDisconnected2
	{
		ControlName             RuiPanel

		wide					132
		tall					64

		scriptID                2

		rui                     "ui/disconnected_widget.rpak"

		ruiArgs
		{
			textWidth   118.0
			fontSize    24.0
		}

		xpos                    0
		ypos                    0
		zpos                    110

		visible                 0
		enabled                 1
		cursorVelocityModifier  0.6

		pin_to_sibling          TeammateMute2
		pin_corner_to_sibling   LEFT
		pin_to_sibling_corner   LEFT
	}

	LobbyChatBox
	{
		ControlName             CBaseHudChat
		InheritProperties       ChatBox

		bgcolor_override        "0 0 0 80"
		chatBorderThickness     1
		chatHistoryBgColor      "24 27 30 120"
		chatEntryBgColor        "24 27 30 120"
		chatEntryBgColorFocused "24 27 30 120"

		destination				    "match"
		visible                    1
		teamChat                   1
		stopMessageModeOnFocusLoss 1
		menuModeWithFade           1

		pin_to_sibling			ScreenFrame
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT

		xpos					-100
		ypos					-96
		zpos                    200

		wide					500
		tall 					150
	}




}
