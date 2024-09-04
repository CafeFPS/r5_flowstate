"resource/ui/menus/panels/ads_controls_pc.res"
{
    SldMouseSensitivity
    {
        ControlName				SliderControl
        InheritProperties		SliderControl

        xpos					0
        ypos					0

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
    }

    CustomADSHeader
    {
        ControlName				ImagePanel
        InheritProperties		SubheaderBackgroundWide
        xpos					0
        ypos					38
        pin_to_sibling			SldMouseSensitivityZoomed
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }
	
    CustomADSHeaderText
    {
        ControlName				Label
        InheritProperties		SubheaderText
        pin_to_sibling			CustomADSHeader
        pin_corner_to_sibling	LEFT
        pin_to_sibling_corner	LEFT
        labelText				"#MENU_PEROPTICADS"
    }

    SwchCustomADSEnabled
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton

        pin_to_sibling          CustomADSHeader
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp                   SwchLookSensitivityADS
        navDown					SldSensitivity0
        tabPosition				1
        ConVar					"mouse_use_per_scope_sensitivity_scalars"
        list
        {
            "#SETTING_OFF"		0
            "#SETTING_ON"		1
        }

        childGroupAlways        ChoiceButtonAlways
    }

    SldSensitivity0
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        pin_to_sibling			SwchCustomADSEnabled
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        ypos					32
        navUp					SldMouseSensitivityZoomed
        navDown					SldSensitivity1
        conCommand				"mouse_zoomed_sensitivity_scalar_0"
        minValue				0.200000
        maxValue				10.000000
        stepSize				0.2
        inverseFill             0
        showLabel               0
    }
	
    TextEntryMouseSensitivityZoomed0
    {
        ControlName				TextEntry
        InheritProperties       SliderControlTextEntrySmall
        syncedConVar            "mouse_zoomed_sensitivity_scalar_0"
        showConVarAsFloat		1
		
		minValue				0.200000
        maxValue				10.000000
		
        pin_to_sibling			SldSensitivity0
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	RIGHT
    }

    SldSensitivity1
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        pin_to_sibling			SldSensitivity0
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SldSensitivity0
        navDown					SldSensitivity2
        conCommand				"mouse_zoomed_sensitivity_scalar_1"
        minValue				0.200000
        maxValue				10.000000
        stepSize				0.2
        inverseFill             0
        showLabel               0
    }
	
    TextEntryMouseSensitivityZoomed1
    {
        ControlName				TextEntry
        InheritProperties       SliderControlTextEntrySmall
        syncedConVar            "mouse_zoomed_sensitivity_scalar_1"
        showConVarAsFloat		1

        minValue				0.200000
        maxValue				10.000000

        pin_to_sibling			SldSensitivity1
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	RIGHT
    }

    SldSensitivity2
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        pin_to_sibling			SldSensitivity1
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SldSensitivity1
        navDown					SldSensitivity3
        conCommand				"mouse_zoomed_sensitivity_scalar_2"
        minValue				0.200000
        maxValue				10.000000
        stepSize				0.2
        inverseFill             0
        showLabel               0
    }
	
    TextEntryMouseSensitivityZoomed2
    {
        ControlName				TextEntry
        InheritProperties       SliderControlTextEntrySmall
        syncedConVar            "mouse_zoomed_sensitivity_scalar_2"
        showConVarAsFloat		1

        minValue				0.200000
        maxValue				10.000000

        pin_to_sibling			SldSensitivity2
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	RIGHT
    }

    SldSensitivity3
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        pin_to_sibling			SldSensitivity2
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SldSensitivity2
        navDown					SldSensitivity4
        conCommand				"mouse_zoomed_sensitivity_scalar_3"
        minValue				0.200000
        maxValue				10.000000
        stepSize				0.2
        inverseFill             0
        showLabel               0
    }
	
    TextEntryMouseSensitivityZoomed3
    {
        ControlName				TextEntry
        InheritProperties       SliderControlTextEntrySmall
        syncedConVar            "mouse_zoomed_sensitivity_scalar_3"
        showConVarAsFloat		1

        minValue				0.200000
        maxValue				10.000000

        pin_to_sibling			SldSensitivity3
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	RIGHT
    }

    SldSensitivity4
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        pin_to_sibling			SldSensitivity3
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SldSensitivity3
        navDown					SldSensitivity5
        conCommand				"mouse_zoomed_sensitivity_scalar_4"
        minValue				0.200000
        maxValue				10.000000
        stepSize				0.2
        inverseFill             0
        showLabel               0
    }
	
    TextEntryMouseSensitivityZoomed4
    {
        ControlName				TextEntry
        InheritProperties       SliderControlTextEntrySmall
        syncedConVar            "mouse_zoomed_sensitivity_scalar_4"
        showConVarAsFloat		1

        minValue				0.200000
        maxValue				10.000000

        pin_to_sibling			SldSensitivity4
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	RIGHT
    }

    SldSensitivity5
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        pin_to_sibling			SldSensitivity4
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SldSensitivity4
        navDown					SldSensitivity6
        conCommand				"mouse_zoomed_sensitivity_scalar_5"
        minValue				0.200000
        maxValue				10.000000
        stepSize				0.2
        inverseFill             0
        showLabel               0
    }
	
    TextEntryMouseSensitivityZoomed5
    {
        ControlName				TextEntry
        InheritProperties       SliderControlTextEntrySmall
        syncedConVar            "mouse_zoomed_sensitivity_scalar_5"
        showConVarAsFloat		1

        minValue				0.200000
        maxValue				10.000000

        pin_to_sibling			SldSensitivity5
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	RIGHT
    }

    SldSensitivity6
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        pin_to_sibling			SldSensitivity5
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SldSensitivity5
        navDown					SldSensitivity7
        conCommand				"mouse_zoomed_sensitivity_scalar_6"
        minValue				0.200000
        maxValue				10.000000
        stepSize				0.2
        inverseFill             0
        showLabel               0
    }
	
    TextEntryMouseSensitivityZoomed6
    {
        ControlName				TextEntry
        InheritProperties       SliderControlTextEntrySmall
        syncedConVar            "mouse_zoomed_sensitivity_scalar_6"
        showConVarAsFloat		1

        minValue				0.200000
        maxValue				10.000000

        pin_to_sibling			SldSensitivity6
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	RIGHT
    }

    SldSensitivity7
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        pin_to_sibling			SldSensitivity6
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SldSensitivity6
        conCommand				"mouse_zoomed_sensitivity_scalar_7"
        minValue				0.200000
        maxValue				10.000000
        stepSize				0.2
        inverseFill             0
        showLabel               0

        visible 0
    }
	
    TextEntryMouseSensitivityZoomed7
    {
        ControlName				TextEntry
        InheritProperties       SliderControlTextEntrySmall
        syncedConVar            "mouse_zoomed_sensitivity_scalar_7"
        showConVarAsFloat		1

        minValue				0.200000
        maxValue				10.000000

        pin_to_sibling			SldSensitivity7
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	RIGHT

        visible 0
    }

	PanelBottom
	{
		ControlName				Label
		labelText               ""

		zpos                    0
		wide					1
		tall					1
		visible					1
		enabled 				0

        pin_to_sibling			SldSensitivity7
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
	}
}