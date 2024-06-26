resource/ui/menus/panels/death_screen_spectate.res
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
		pin_corner_to_sibling	LEFT
		pin_to_sibling_corner	LEFT

		xpos					-50
		ypos					100
		zpos                    200

		tall 					125
	}
}
