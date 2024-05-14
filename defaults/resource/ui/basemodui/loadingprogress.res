Resource/UI/LoadingProgress.res
{
	LoadingProgress
	{
		ControlName				Frame
		wide					f0
		tall					f0
		visible					1
		enabled					1
		tabPosition				0
	}

    Letterbox
    {
        ControlName				ImagePanel
        xpos                    c-864 [!$WIDESCREEN_16_9]
        ypos                    c-486 [!$WIDESCREEN_16_9]
        wide					1728 [!$WIDESCREEN_16_9]
        tall					972 [!$WIDESCREEN_16_9]

        xpos                    c-960 [$WIDESCREEN_16_9]
        ypos                    c-540 [$WIDESCREEN_16_9]
        wide					1920 [$WIDESCREEN_16_9]
        tall					1080 [$WIDESCREEN_16_9]

        zpos					3
        visible					0
        scaleImage				1
        image					"vgui/HUD/white"
        drawColor				"255 0 0 192"

		pin_to_sibling			LoadingProgress
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	CENTER
    }

	GradientOverlay
	{
		ControlName				ImagePanel
		wide					0
		tall					0
		image					"loadscreens/gradient_overlay"
		scaleImage				1
		visible					0

		pin_to_sibling			LoadingGameMode
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}

	LoadingGameMode
	{
		ControlName				Label
		xpos					110
		ypos					860
		auto_wide_tocontents 	1
		auto_tall_tocontents	1
		labelText				"<Game Mode>"
		font					"DefaultRegularFont"
		fontHeight				65
		fgcolor_override 		"255 255 255 0"
		allcaps					1
		visible					0
	}

    LoadingTipBackgroundImage
    {
        ControlName				ImagePanel
        xpos                    500
        ypos                    500
        wide					560 [!$WIDESCREEN_16_9]
        tall					126 [!$WIDESCREEN_16_9]

        xpos                    500 [$WIDESCREEN_16_9]
        ypos                    500 [$WIDESCREEN_16_9]
        wide					580 [$WIDESCREEN_16_9]
        tall					138 [$WIDESCREEN_16_9]

        zpos					3
        visible					1
        scaleImage				1
        image					"vgui/HUD/white"
        drawColor				"0 0 0 220"

		pin_to_sibling			Letterbox
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_RIGHT
    }

	LoadingTip
	{
		ControlName				Label
		ypos					0  [!$WIDESCREEN_16_9]
		xpos                    -8  [!$WIDESCREEN_16_9]
		wide                    552  [!$WIDESCREEN_16_9]
		tall                    110  [!$WIDESCREEN_16_9]

		ypos					0  [$WIDESCREEN_16_9]
		xpos                    -8  [$WIDESCREEN_16_9]
		wide                    572  [$WIDESCREEN_16_9]
		tall                    112  [$WIDESCREEN_16_9]
		zpos                    4

		labelText				""
        textAlignment           left
		font					"DefaultRegularFont"
		fontHeight				26
		centerWrap 				1
		fgcolor_override 		"220 220 220 255"
		visible					0

		pin_to_sibling			LoadingTipBackgroundImage
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}

	LoadingMapName
	{
		ControlName				Label
		xpos                    38
        ypos                    0
		auto_wide_tocontents 	1
		auto_tall_tocontents	1
		labelText				""
		font					"TitleBoldFont"
		fontHeight				41
		fgcolor_override 		"0 0 0 255"
		allcaps					0
		visible					0
        textalign               east

		pin_to_sibling			LoadingTipBackgroundImage
		pin_corner_to_sibling	BOTTOM_RIGHT
		pin_to_sibling_corner	BOTTOM_LEFT
	}

	WorkingAnim
	{
		ControlName				ImagePanel
		xpos					r165 [!$WIDESCREEN_16_9]
		ypos					r200 [!$WIDESCREEN_16_9]
		xpos					r190 [$WIDESCREEN_16_9]
		ypos					r150 [$WIDESCREEN_16_9]
		wide					100
		tall					100
		visible					0
		enabled					1
		tabPosition				0
		scaleImage				1
		image					"vgui/spinner"
		frame					0
	}

	ProgressBarAnchor
	{
		ControlName				Label
		xpos					0
		ypos					920
		wide					2
		tall					2
		visible					0
		enabled					1
		tabPosition				0
	}

	GameModeInfoRui
	{
		ControlName				RuiPanel
		classname				"RuiLoadingThing"
		wide					f0
		tall					f0
		visible					0
		rui 					"ui/loadscreen_game_mode_info.rpak"
		drawColor				"255 0 255 255"
	}

	DetentText
	{
		ControlName				RuiPanel
		classname				"RuiDetentText"
		wide					f0
		tall					f0
		visible					0
		rui 					"ui/loadscreen_detent.rpak"
		drawColor				"255 0 255 255"
	}

	SPLog
	{
		ControlName				RuiPanel
		classname				"RuiSPLog"
		wide					f0
		tall					f0
		visible					0
		rui 					"ui/loadscreen_sp_log.rpak"
		drawColor				"255 0 255 255"
	}
}
