"resource/ui/menus/panels/controls_pc.res"
{
	PanelFrame
	{
		ControlName				ImagePanel

		zpos                    0
		wide					%100
		tall					836//788
		visible					0
		enabled 				1
		scaleImage				1
		image					"vgui/HUD/white"
		drawColor				"255 0 0 200"

		proportionalToParent    1
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    SldMouseSensitivity
    {
        ControlName				SliderControl
        InheritProperties		SliderControl

        ypos                    0

        navDown					SldMouseSensitivityZoomed
		
        minValue				0.200000
        maxValue				20.000000
		
        stepSize				0.2
        conCommand				"mouse_sensitivity"
        tabPosition				1
    }
	
    TextEntryMouseSensitivity
    {
        ControlName				TextEntry
        InheritProperties       SliderControlTextEntrySmall
		
        syncedConVar            "mouse_sensitivity"
        showConVarAsFloat		1
		
        minValue				0.200000
        maxValue				20.000000
		
        pin_to_sibling			SldMouseSensitivity
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	RIGHT
    }

    SldMouseSensitivityZoomed
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        pin_to_sibling			SldMouseSensitivity
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SldMouseSensitivity
        navDown					SwchMouseAcceleration
        minValue				0.200000
        maxValue				10.000000
        stepSize				0.2

        conCommand				"mouse_zoomed_sensitivity_scalar_0"
        visible 0
    }
	
    TextEntryMouseSensitivityZoomed
    {
        ControlName				TextEntry
        InheritProperties       SliderControlTextEntrySmall
        syncedConVar            "mouse_zoomed_sensitivity_scalar_0"
        showConVarAsFloat		1

		minValue				0.200000
		maxValue				10.000000

        pin_to_sibling			SldMouseSensitivityZoomed
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	RIGHT
        visible 0
    }

    BtnLookSensitivityMenu
    {
        ControlName				RuiButton
        InheritProperties		SettingBasicButton

        pin_to_sibling			SldMouseSensitivity
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SldMouseSensitivity
        navDown					SwchMouseAcceleration
    }

    SwchMouseAcceleration
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton
        pin_to_sibling			BtnLookSensitivityMenu
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SldMouseSensitivityZoomed
        navDown					SwchMouseInvertY
        ConVar 					"m_acceleration"
        TextInsetWidth          120

        list
        {
            "#SETTING_OFF"		0
            "#SETTING_ON"		1
//            "#SETTING_DEFAULT"   2
        }

        childGroupAlways        ChoiceButtonAlways
    }

    SwchMouseInvertY
    {
        ControlName             RuiButton
        InheritProperties       SwitchButton
        style                   DialogListButton
        pin_to_sibling          SwchMouseAcceleration
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT
        navUp                   SwchMouseAcceleration
        navDown                 SwchLightingEffects
        ConVar                  "m_invert_pitch"

        list
        {
            "#SETTING_OFF"      0
            "#SETTING_ON"       1
        }

        childGroupAlways        ChoiceButtonAlways
    }

    SwchLightingEffects
    {
        ControlName             RuiButton
        InheritProperties       SwitchButton
        style                   DialogListButton
        pin_to_sibling          SwchMouseInvertY
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT
        navUp                   SwchMouseInvertY
        navDown                 BtnGamepadLayout
        ConVar                  "chroma_enable"

        list
        {
            "#SETTING_OFF"      0
            "#SETTING_ON"       1
        }

        childGroupAlways        ChoiceButtonAlways
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    background_keybindings
    {
        ControlName				RuiPanel

        wide					1040
        tall					480

        zpos                    0
        visible					1
        enabled 				0

        rui                     "ui/basic_image.rpak"

        ruiArgs
        {
            basicImageAlpha     0.75
            basicImageColor     "0.06 0.064 0.07"
        }

        proportionalToParent    1

        pin_to_sibling			listpanel_keybindlist
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }

    listpanel_keybindlist
    {
        ControlName				SectionedListPanel
        ypos					32
        zpos					100
        wide					1040
        tall					480
        autoResize				0
        pinCorner				0
        visible					1
        enabled					1
        linespacing				40
        paintborder				0
        single_click_edit       1
        linePadding             4
        fontHeight              30

        pin_to_sibling			SwchLightingEffects
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

    ruipanel_keybindlist
    {
        ControlName             RuiButton
        rui                     "ui/keybindlist_overlay.rpak"
        xpos                    0
        ypos                    0
        zpos                    101
        wide                    1040
        tall                    480

        pin_to_sibling			listpanel_keybindlist
        pin_corner_to_sibling	CENTER
        pin_to_sibling_corner	CENTER

        visible                 0
        enabled                 0
    }

	KeyBindMessage
	{
		ControlName				RuiPanel
        rui                     "ui/keybindlist_message.rpak"
		ypos					0
		wide					1040
		tall					48
		visible					0

        pin_to_sibling			listpanel_keybindlist
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	BOTTOM
	}
}