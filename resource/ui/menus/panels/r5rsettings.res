"scripts/resource/ui/menus/panels/r5rsettings.res"
{
	PanelFrame
	{
		ControlName				Label
		xpos					0
		ypos					0
		wide					%100
		tall					%100
		labelText				""
	    bgcolor_override		"30 30 30 200"
		visible					0
		paintbackground			1

		proportionalToParent    1
	}

    ScreenBlur
    {
        ControlName     Label
        labelText       ""
    }

    TabsCommon
    {
        ControlName				CNestedPanel
        classname				"TabsCommonClass"
        zpos					1
        wide					f0
        tall					84
        visible					1
        controlSettingsFile		"scripts/resource/ui/menus/panels/r5rtabs_settings.res"

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    DetailsPanel
    {
        ControlName				RuiPanel
        InheritProperties       SettingsDetailsPanel
        visible					1

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP
    }

    ControlsPCPanelContainer
    {
        ControlName			    CNestedPanel
        InheritProperties       SettingsTabPanel

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP

        tabPosition             1

        ScrollFrame
        {
            ControlName				ImagePanel
            InheritProperties       SettingsScrollFrame
        }

        ScrollBar
        {
            ControlName				RuiButton
            InheritProperties       SettingsScrollBar

            pin_to_sibling			ScrollFrame
            pin_corner_to_sibling	TOP_RIGHT
            pin_to_sibling_corner	TOP_RIGHT
        }

        // Code created via CreateKeyBindingPanel()
        //    ContentPanel
        //    {
        //        ControlName			CNestedPanel
        //        xpos					320
        //        ypos					64
        //        wide					1408
        //        tall					840
        //        visible				0
        //        controlSettingsFile	"resource/ui/menus/panels/controls_pc.res"
        //    }
    }

    ControlsGamepadPanel
    {
        ControlName			    CNestedPanel
        InheritProperties       SettingsTabPanel

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP

        tabPosition             1

        ScrollFrame
        {
            ControlName				ImagePanel
            InheritProperties       SettingsScrollFrame
        }

        ScrollBar
        {
            ControlName				RuiButton
            InheritProperties       SettingsScrollBar

            pin_to_sibling			ScrollFrame
            pin_corner_to_sibling	TOP_RIGHT
            pin_to_sibling_corner	TOP_RIGHT
        }

        ContentPanel
        {
            ControlName				CNestedPanel
            InheritProperties       SettingsContentPanel
            tall                    980
            tabPosition             1

            controlSettingsFile		"resource/ui/menus/panels/controls.res"
        }
    }

    VideoPanelContainer
    {
        ControlName			    CNestedPanel
        InheritProperties       SettingsTabPanel

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP

        tabPosition             1

        ScrollFrame
        {
            ControlName				ImagePanel
            InheritProperties       SettingsScrollFrame
        }

        ScrollBar
        {
            ControlName				RuiButton
            InheritProperties       SettingsScrollBar

            pin_to_sibling			ScrollFrame
            pin_corner_to_sibling	TOP_RIGHT
            pin_to_sibling_corner	TOP_RIGHT
        }

    // Code created via CreateVideoOptionsPanel()
    //    ContentPanel
    //    {
    //        ControlName			CNestedPanel
    //        xpos					320
    //        ypos					64
    //        wide					1408
    //        tall					840
    //        visible				0
    //        controlSettingsFile	"resource/ui/menus/panels/video.res"
    //        clip                  1
    //    }
    }

    SoundPanel
    {
        ControlName			    CNestedPanel
        InheritProperties       SettingsTabPanel

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP

        tabPosition             1

        ScrollFrame
        {
            ControlName				ImagePanel
            InheritProperties       SettingsScrollFrame
        }

        ScrollBar
        {
            ControlName				RuiButton
            InheritProperties       SettingsScrollBar

            pin_to_sibling			ScrollFrame
            pin_corner_to_sibling	TOP_RIGHT
            pin_to_sibling_corner	TOP_RIGHT
        }

        ContentPanel
        {
            ControlName				CNestedPanel
            InheritProperties       SettingsContentPanel
            //tall                    952 [$WINDOWS]
            tall                    882 [$WINDOWS]
            tabPosition             1

            controlSettingsFile		"resource/ui/menus/panels/audio.res" [$WINDOWS]
            controlSettingsFile		"resource/ui/menus/panels/audio_console.res" [$GAMECONSOLE]
        }
    }

    HudOptionsPanel
    {
        ControlName			    CNestedPanel
        InheritProperties       SettingsTabPanel

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP

        tabPosition             1

        ScrollFrame
        {
            ControlName				ImagePanel
            InheritProperties       SettingsScrollFrame
        }

        ScrollBar
        {
            ControlName				RuiButton
            InheritProperties       SettingsScrollBar

            pin_to_sibling			ScrollFrame
            pin_corner_to_sibling	TOP_RIGHT
            pin_to_sibling_corner	TOP_RIGHT
        }

        ContentPanel
        {
            ControlName				CNestedPanel
            InheritProperties       SettingsContentPanel
            tall                    1166 [$WINDOWS]
            tall                    1101 [$GAMECONSOLE]

            tabPosition             1

            controlSettingsFile		"resource/ui/menus/panels/hud_options.res"
        }
    }
}