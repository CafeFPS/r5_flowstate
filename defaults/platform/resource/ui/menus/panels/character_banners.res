"resource/ui/menus/panels/character_banners.res"
{
    PanelFrame
    {
		ControlName				Label
		wide					%100
		tall					%100
		labelText				""
        bgcolor_override        "0 0 0 0"
		visible				    0
        paintbackground         1
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    Header
    {
        ControlName             RuiPanel
        xpos                    163 //22
        ypos                    64
        zpos                    4
        wide                    550
        tall                    33
        rui                     "ui/character_items_header.rpak"
    }

	SectionButton0
	{
		ControlName			RuiButton
		xpos			    123
		ypos			    96
		zpos			    3
		wide			    296
		tall			    56
		visible			    0
		labelText           ""
        rui					"ui/character_section_button.rpak"
        cursorVelocityModifier  0.7
	}

	SectionButton1
	{
		ControlName			RuiButton
		xpos			    0
		ypos			    3
		zpos			    3
		wide			    296
		tall			    56
		visible			    0
		labelText           ""
        rui					"ui/character_section_button.rpak"
        cursorVelocityModifier  0.7

        pin_to_sibling			SectionButton0
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
	}

	SectionButton2
	{
		ControlName			RuiButton
		xpos			    0
		ypos			    45
		zpos			    3
		wide			    296
		tall			    56
		visible			    0
		labelText           ""
        rui					"ui/character_section_button.rpak"
        cursorVelocityModifier  0.7

        pin_to_sibling			SectionButton1
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
	}

	SectionButton3
	{
		ControlName			RuiButton
		xpos			    0
		ypos			    3
		zpos			    3
		wide			    296
		tall			    56
		visible			    0
		labelText           ""
        rui					"ui/character_section_button.rpak"
        cursorVelocityModifier  0.7

        pin_to_sibling			SectionButton2
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
	}

	SectionButton4
	{
		ControlName			RuiButton
		xpos			    0
		ypos			    3
		zpos			    3
		wide			    296
		tall			    56
		visible			    0
		labelText           ""
        rui					"ui/character_section_button.rpak"
        cursorVelocityModifier  0.7

        pin_to_sibling			SectionButton3
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
	}

	SectionButton5
	{
		ControlName			RuiButton
		xpos			    0
		ypos			    45
		zpos			    3
		wide			    296
		tall			    56
		visible			    0
		labelText           ""
        rui					"ui/character_section_button.rpak"
        cursorVelocityModifier  0.7

        pin_to_sibling			SectionButton4
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
	}

	SectionButton6
	{
		ControlName			RuiButton
		xpos			    0
		ypos			    3
		zpos			    3
		wide			    296
		tall			    56
		visible			    0
		labelText           ""
        rui					"ui/character_section_button.rpak"
        cursorVelocityModifier  0.7

        pin_to_sibling			SectionButton5
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
	}

	SectionButton7
	{
		ControlName			RuiButton
		xpos			    0
		ypos			    3
		zpos			    3
		wide			    296
		tall			    56
		visible			    0
		labelText           ""
        rui					"ui/character_section_button.rpak"
        cursorVelocityModifier  0.7

        pin_to_sibling			SectionButton6
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    CardFramesPanel
    {
        ControlName				CNestedPanel
        xpos					491
        ypos					96
        wide					1408
        tall					840
        visible					1
        tabPosition             1
        controlSettingsFile		"resource/ui/menus/panels/card_frames.res"
    }

    CardPosesPanel
    {
        ControlName				CNestedPanel
        xpos					491
        ypos					96
        wide					1408
        tall					840
        visible					1
        tabPosition             1
        controlSettingsFile		"resource/ui/menus/panels/card_poses.res"
    }

    CardBadgesPanel
    {
        ControlName				CNestedPanel
        xpos					491
        ypos					96
        wide					1408
        tall					840
        visible					1
        tabPosition             1
        controlSettingsFile		"resource/ui/menus/panels/card_badges.res"
    }

    CardTrackersPanel
    {
        ControlName				CNestedPanel
        xpos					491
        ypos					96
        wide					1408
        tall					840
        visible					1
        tabPosition             1
        controlSettingsFile		"resource/ui/menus/panels/card_trackers.res"
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//    DebugBG
//    {
//        ControlName				Label
//        wide					800
//        tall					800
//        labelText				""
//        bgcolor_override		"70 70 70 100"
//        visible					1
//        paintbackground			1
//
//        pin_to_sibling			CombinedCard
//        pin_corner_to_sibling	TOP_LEFT
//        pin_to_sibling_corner	TOP_LEFT
//    }
    CombinedCard
    {
        ControlName				RuiPanel
        xpos                    -930
        ypos                    -16
        wide					850 //800
        tall					850 //800
        rui                     "ui/combined_card.rpak"
        visible					1

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }
}