"resource/ui/menus/panels/ads_advanced_controls_gamepad.res"
{	
    ///////////////////////////
    // ADS Sensitivity
    ///////////////////////////
    
    CustomADSHeader
    {
        ControlName				ImagePanel
        InheritProperties		SubheaderBackgroundWide
        xpos					0
        ypos					0
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
	///////////////////////////////////////
    // ADS Sensitivity Per Scope Enabled
    ///////////////////////////////////////
    SwchCustomADSEnabled
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton
        tabPosition				1
        pin_to_sibling          CustomADSHeader
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navDown					SldADSAdvancedSensitivity0
        ConVar					"gamepad_use_per_scope_sensitivity_scalars"
        list
        {
            "#SETTING_OFF"		0
            "#SETTING_ON"		1
        }

        childGroupAlways        ChoiceButtonAlways
    }
	///////////////////////////////
    // ADS Sensitivity Per Scope
    ///////////////////////////////
    SldADSAdvancedSensitivity0
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        pin_to_sibling			SwchCustomADSEnabled
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        ypos					32
        navUp					SwchCustomADSEnabled
        navDown					SldADSAdvancedSensitivity1
        conCommand				"gamepad_ads_advanced_sensitivity_scalar_0"
        minValue				0.2
        maxValue				10.0
        stepSize				0.2
        inverseFill             0
        showLabel               0
    }
    TextEntryADSAdvancedSensitivityZoomed0
    {
        ControlName				TextEntry
        InheritProperties       SliderControlTextEntry
        syncedConVar            "gamepad_ads_advanced_sensitivity_scalar_0"
        showConVarAsFloat		1

        pin_to_sibling			SldADSAdvancedSensitivity0
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	RIGHT
    }

    SldADSAdvancedSensitivity1
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        pin_to_sibling			SldADSAdvancedSensitivity0
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SldADSAdvancedSensitivity0
        navDown					SldADSAdvancedSensitivity2
        conCommand				"gamepad_ads_advanced_sensitivity_scalar_1"
        minValue				0.2
        maxValue				10.0
        stepSize				0.2
        inverseFill             0
        showLabel               0
    }
    TextEntryADSAdvancedSensitivityZoomed1
    {
        ControlName				TextEntry
        InheritProperties       SliderControlTextEntry
        syncedConVar            "gamepad_ads_advanced_sensitivity_scalar_1"
        showConVarAsFloat		1

        pin_to_sibling			SldADSAdvancedSensitivity1
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	RIGHT
    }

    SldADSAdvancedSensitivity2
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        pin_to_sibling			SldADSAdvancedSensitivity1
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SldADSAdvancedSensitivity1
        navDown					SldADSAdvancedSensitivity3
        conCommand				"gamepad_ads_advanced_sensitivity_scalar_2"
        minValue				0.2
        maxValue				10.0
        stepSize				0.2
        inverseFill             0
        showLabel               0
    }
    TextEntryADSAdvancedSensitivityZoomed2
    {
        ControlName				TextEntry
        InheritProperties       SliderControlTextEntry
        syncedConVar            "gamepad_ads_advanced_sensitivity_scalar_2"
        showConVarAsFloat		1

        pin_to_sibling			SldADSAdvancedSensitivity2
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	RIGHT
    }

    SldADSAdvancedSensitivity3
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        pin_to_sibling			SldADSAdvancedSensitivity2
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SldADSAdvancedSensitivity2
        navDown					SldADSAdvancedSensitivity4
        conCommand				"gamepad_ads_advanced_sensitivity_scalar_3"
        minValue				0.2
        maxValue				10.0
        stepSize				0.2
        inverseFill             0
        showLabel               0
    }
    TextEntryADSAdvancedSensitivityZoomed3
    {
        ControlName				TextEntry
        InheritProperties       SliderControlTextEntry
        syncedConVar            "gamepad_ads_advanced_sensitivity_scalar_3"
        showConVarAsFloat		1

        pin_to_sibling			SldADSAdvancedSensitivity3
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	RIGHT
    }

    SldADSAdvancedSensitivity4
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        pin_to_sibling			SldADSAdvancedSensitivity3
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SldADSAdvancedSensitivity3
        navDown					SldADSAdvancedSensitivity5
        conCommand				"gamepad_ads_advanced_sensitivity_scalar_4"
        minValue				0.2
        maxValue				10.0
        stepSize				0.2
        inverseFill             0
        showLabel               0
    }
    TextEntryADSAdvancedSensitivityZoomed4
    {
        ControlName				TextEntry
        InheritProperties       SliderControlTextEntry
        syncedConVar            "gamepad_ads_advanced_sensitivity_scalar_4"
        showConVarAsFloat		1

        pin_to_sibling			SldADSAdvancedSensitivity4
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	RIGHT
    }

    SldADSAdvancedSensitivity5
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        pin_to_sibling			SldADSAdvancedSensitivity4
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SldADSAdvancedSensitivity4
        navDown					SldADSAdvancedSensitivity6
        conCommand				"gamepad_ads_advanced_sensitivity_scalar_5"
        minValue				0.2
        maxValue				10.0
        stepSize				0.2
        inverseFill             0
        showLabel               0
    }
    TextEntryADSAdvancedSensitivityZoomed5
    {
        ControlName				TextEntry
        InheritProperties       SliderControlTextEntry
        syncedConVar            "gamepad_ads_advanced_sensitivity_scalar_5"
        showConVarAsFloat		1

        pin_to_sibling			SldADSAdvancedSensitivity5
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	RIGHT
    }

    SldADSAdvancedSensitivity6
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        pin_to_sibling			SldADSAdvancedSensitivity5
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SldADSAdvancedSensitivity5
        conCommand				"gamepad_ads_advanced_sensitivity_scalar_6"
        minValue				0.2
        maxValue				10.0
        stepSize				0.2
        inverseFill             0
        showLabel               0
    }
    TextEntryADSAdvancedSensitivityZoomed6
    {
        ControlName				TextEntry
        InheritProperties       SliderControlTextEntry
        syncedConVar            "gamepad_ads_advanced_sensitivity_scalar_6"
        showConVarAsFloat		1

        pin_to_sibling			SldADSAdvancedSensitivity6
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	RIGHT
    }
}