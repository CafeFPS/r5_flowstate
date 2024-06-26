"resource/ui/menus/panels/character_emotes.res"
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
        xpos					651
        ypos					96
		zpos			    3
		wide			    492
		tall			    56
		visible			    0
		labelText           ""
        rui					"ui/character_section_button.rpak"


        ruiArgs
        {
            textBreakWidth 400.0
        }
	}

	SectionButton1
	{
		ControlName			RuiButton
		xpos			    0
		ypos			    3
		zpos			    3
		wide			    492
		tall			    56
		visible			    0
		labelText           ""
        rui					"ui/character_section_button.rpak"


        ruiArgs
        {
            textBreakWidth 400.0
        }

        pin_to_sibling			SectionButton0
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
	}

	SectionButton2
	{
		ControlName			RuiButton
		xpos			    0
		ypos			    3
		zpos			    3
		wide			    492
		tall			    56
		visible			    0
		labelText           ""
        rui					"ui/character_section_button.rpak"


        ruiArgs
        {
            textBreakWidth 400.0
        }

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
		wide			    492
		tall			    56
		visible			    0
		labelText           ""
        rui					"ui/character_section_button.rpak"


        ruiArgs
        {
            textBreakWidth 400.0
        }

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
		wide			    492
		tall			    56
		visible			    0
		labelText           ""
        rui					"ui/character_section_button.rpak"


        ruiArgs
        {
            textBreakWidth 400.0
        }

        pin_to_sibling			SectionButton3
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
	}

	SectionButton5
	{
		ControlName			RuiButton
		xpos			    0
		ypos			    3
		zpos			    3
		wide			    492
		tall			    56
		visible			    0
		labelText           ""
        rui					"ui/character_section_button.rpak"


        ruiArgs
        {
            textBreakWidth 400.0
        }

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
		wide			    492
		tall			    56
		visible			    0
		labelText           ""
        rui					"ui/character_section_button.rpak"


        ruiArgs
        {
            textBreakWidth 400.0
        }

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
		wide			    492
		tall			    56
		visible			    0
		labelText           ""
        rui					"ui/character_section_button.rpak"


        ruiArgs
        {
            textBreakWidth 400.0
        }

        pin_to_sibling			SectionButton6
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
	}


	HintGamepad
	{
		ControlName			RuiPanel
        ypos					632
        xpos					651
		zpos			    3
		wide			    492
		tall			    196
		visible			    1
		labelText           ""
        rui					"ui/character_section_button.rpak"
        activeInputExclusivePaint	gamepad

        ruiArgs
        {
            textBreakWidth 400.0
        }
	}


	HintMKB
	{
		ControlName			RuiPanel
        ypos					632
        xpos					651
		zpos			    3
		wide			    492
		tall			    196
		visible			    1
		labelText           ""
        rui					"ui/character_section_button.rpak"
		activeInputExclusivePaint		keyboard

		ruiArgs
		{
		    textBreakWidth 400.0
        }
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    QuipsPanel
    {
        ControlName				CNestedPanel
		xpos			    158
		ypos			    96
        wide					550
        tall					840
        visible					1
        tabPosition             1
        controlSettingsFile		"resource/ui/menus/panels/quips.res"
    }

}