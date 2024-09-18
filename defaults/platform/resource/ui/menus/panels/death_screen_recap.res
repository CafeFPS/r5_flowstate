resource/ui/menus/panels/death_screen_recap.res
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

	DeathRecap
	{
		ControlName             RuiPanel
		xpos					0
		ypos					0
		wide 					%100
		tall					%100
		rui 					"ui/death_recap.rpak"
		visible					1
		zpos					3

		pin_to_sibling			ScreenFrame
		pin_corner_to_sibling	CENTER
		pin_to_sibling_corner	CENTER
	}

	DamageBlockAnchor
	{
		ControlName				ImagePanel
		xpos					-20
		ypos					-180
		wide					540
		tall					730
		visible					0
		enabled 				1
		drawColor				"255 128 0 64"

		pin_to_sibling          DeathRecap
		pin_corner_to_sibling   TOP
		pin_to_sibling_corner   TOP
	}

	// Block0 is at the bottom and MainDamageBlock is at the top
	// scriptID matches the order they where sent to the client. Most recent damage first, cause that is how the damage history is stored
	Block9
	{
		ControlName             RuiButton
        InheritProperties       DeathScreenRecapBlock
		scriptID                9

		ypos					0
		pin_to_sibling          DamageBlockAnchor
		pin_corner_to_sibling   BOTTOM
		pin_to_sibling_corner   BOTTOM
	}

	Block8
	{
		ControlName             RuiButton
        InheritProperties       DeathScreenRecapBlock
		scriptID                8
		pin_to_sibling          Block9
	}

	Block7
	{
		ControlName             RuiButton
        InheritProperties       DeathScreenRecapBlock
		scriptID                7
		pin_to_sibling          Block8
	}

	Block6
	{
		ControlName             RuiButton
        InheritProperties       DeathScreenRecapBlock
		scriptID                6
		pin_to_sibling          Block7
	}

	Block5
	{
		ControlName             RuiButton
        InheritProperties       DeathScreenRecapBlock
		scriptID                5
		pin_to_sibling          Block6
	}

	Block4
	{
		ControlName             RuiButton
        InheritProperties       DeathScreenRecapBlock
		scriptID                4
		pin_to_sibling          Block5
	}

	Block3
	{
		ControlName             RuiButton
        InheritProperties       DeathScreenRecapBlock
		scriptID                3
		pin_to_sibling          Block4
	}

	Block2
	{
		ControlName             RuiButton
        InheritProperties       DeathScreenRecapBlock
		scriptID                2
		pin_to_sibling          Block3
	}

	Block1
	{
		ControlName             RuiButton
        InheritProperties       DeathScreenRecapBlock
		scriptID                1
		pin_to_sibling          Block2
	}

	MainDamageBlock
	{
		ControlName             RuiButton
		wide					540
		tall					155
		scriptID                0
		rui                     "ui/death_recap_damage_block_main.rpak"
		xpos                    0
		ypos                    10
		zpos                    10
		visible                 1
		enabled                 1
		cursorVelocityModifier  0.6
		pin_to_sibling          Block1
		pin_corner_to_sibling   BOTTOM
		pin_to_sibling_corner   TOP
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
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_RIGHT

		xpos					-100
		ypos					-90
		zpos                    200

		wide					463
		tall 					95
	}
}
