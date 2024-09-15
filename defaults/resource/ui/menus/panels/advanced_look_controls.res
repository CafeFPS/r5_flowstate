"resource/ui/menus/panels/advanced_look_controls.res"
{
//	PanelFrame
//	{
//		ControlName				Label
//		xpos					0
//		ypos					0
//		wide					%100
//		tall					1500
//		labelText				""
//		bgcolor_override		"70 70 70 255"
//		visible					0
//		paintbackground			1
//
//        proportionalToParent    1
//	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    SwchGamepadCustomEnabled
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton
        xpos					0
        ypos					0
        navDown					SldGamepadCustomDeadzoneIn
        tabPosition				1
        ConVar					"gamepad_custom_enabled"
        list
        {
            "#SETTING_OFF"		0
            "#SETTING_ON"		1
        }

        childGroupAlways        ChoiceButtonAlways
    }

    SldGamepadCustomDeadzoneIn
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        pin_to_sibling			SwchGamepadCustomEnabled
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        ypos					32
        navUp					SwchGamepadCustomEnabled
        navDown					SldGamepadCustomDeadzoneOut
        conCommand				"gamepad_custom_deadzone_in"
		minValue				0.000000
        maxValue				0.500000
        stepSize				0.025
        inverseFill             0
        showLabel               0
    }
	
	TextGamepadCustomDeadzoneIn
    {
        ControlName				TextEntry
        InheritProperties       SliderControlTextEntrySmall
		
		ConVar					"gamepad_custom_deadzone_in"
        syncedConVar            "gamepad_custom_deadzone_in"
        showConVarAsFloat		1
		minValue				0.000000
        maxValue				0.500000
        stepSize				0.025
		
        pin_to_sibling			SldGamepadCustomDeadzoneIn
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	RIGHT
    }

    SldGamepadCustomDeadzoneOut
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        pin_to_sibling			SldGamepadCustomDeadzoneIn
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SldGamepadCustomDeadzoneIn
        navDown					SldGamepadCustomCurve
        conCommand				"gamepad_custom_deadzone_out"
		minValue				0.010000
        maxValue				0.300000
        stepSize				0.01
        inverseFill             0
        showLabel               0
    }
	
	TextGamepadCustomDeadzoneOut
    {
        ControlName				TextEntry
        InheritProperties       SliderControlTextEntrySmall
		
		ConVar					"gamepad_custom_deadzone_out"
        syncedConVar            "gamepad_custom_deadzone_out"
        showConVarAsFloat		1
		minValue				0.010000
        maxValue				0.300000
        stepSize				0.025
		
        pin_to_sibling			SldGamepadCustomDeadzoneOut
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	RIGHT
    }

    SldGamepadCustomCurve
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        pin_to_sibling			SldGamepadCustomDeadzoneOut
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SldGamepadCustomDeadzoneOut
        navDown					SwchGamepadCustomAssist
        conCommand				"gamepad_custom_curve"
        minValue				0.000000
        maxValue				30.000000
        stepSize				1.0
        inverseFill             0
        showLabel               0
    }
	
	TextGamepadCustomCurve
    {
        ControlName				TextEntry
        InheritProperties       SliderControlTextEntrySmall
		
		ConVar					"gamepad_custom_curve"
        syncedConVar            "gamepad_custom_curve"
        showConVarAsFloat		1
		minValue				0.000000
        maxValue				30.000000
        stepSize				1.0
		
        pin_to_sibling			SldGamepadCustomCurve
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	RIGHT
    }
    
    SwchGamepadCustomAssist
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton
        navUp					SldGamepadCustomCurve
        navDown					BtnLookSensitivityMenu
        ConVar					"gamepad_custom_assist_on"
        list
        {
            "#SETTING_OFF"		0
            "#SETTING_ON"		1
        }

        pin_to_sibling			SldGamepadCustomCurve
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        childGroupAlways        ChoiceButtonAlways
    }

    //////////////////////////
    // Per Optic Settings...
    //////////////////////////

    BtnLookSensitivityMenu
    {
        ControlName				RuiButton
        InheritProperties		SettingBasicButton

        pin_to_sibling			SwchGamepadCustomAssist
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        ypos					32
        navUp					SwchGamepadCustomAssist
        navDown					SldGamepadCustomHipYaw
    }

    ///////////////////////////
    // Hipfire
    ///////////////////////////

    SldGamepadCustomHipYaw
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        pin_to_sibling			BtnLookSensitivityMenu
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        ypos					32
        navUp					BtnLookSensitivityMenu
        navDown					SldGamepadCustomHipPitch
        conCommand				"gamepad_custom_hip_yaw"
        minValue				0.000000
        maxValue				500.000000
        stepSize				10.0
        inverseFill             0
        showLabel               0
    }
	
	TextGamepadCustomHipYaw
    {
        ControlName				TextEntry
        InheritProperties       SliderControlTextEntrySmall
		
		ConVar					"gamepad_custom_hip_yaw"
        syncedConVar            "gamepad_custom_hip_yaw"
        showConVarAsFloat		1
		minValue				0.000000
        maxValue				500.000000
        stepSize				10.0
		
        pin_to_sibling			SldGamepadCustomHipYaw
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	RIGHT
    }

    SldGamepadCustomHipPitch
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        pin_to_sibling			SldGamepadCustomHipYaw
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SldGamepadCustomHipYaw
        navDown					SldGamepadCustomHipTurnYaw
        conCommand				"gamepad_custom_hip_pitch"
        minValue				0.000000
        maxValue				500.000000
        stepSize				10.0
        inverseFill             0
        showLabel               0
    }
	
	TextGamepadCustomHipPitch
    {
        ControlName				TextEntry
        InheritProperties       SliderControlTextEntrySmall
		
		ConVar					"gamepad_custom_hip_pitch"
        syncedConVar            "gamepad_custom_hip_pitch"
        showConVarAsFloat		1
		minValue				0.000000
        maxValue				500.000000
        stepSize				10.0
		
        pin_to_sibling			SldGamepadCustomHipPitch
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	RIGHT
    }

    SldGamepadCustomHipTurnYaw
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        pin_to_sibling			SldGamepadCustomHipPitch
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SldGamepadCustomHipPitch
        navDown					SldGamepadCustomHipTurnPitch
        conCommand				"gamepad_custom_hip_turn_yaw"
        minValue				0.000000
        maxValue				250.000000
        stepSize				10.0
        showLabel               0
    }
	
	TextGamepadCustomHipTurnYaw
    {
        ControlName				TextEntry
        InheritProperties       SliderControlTextEntrySmall
		
		ConVar					"gamepad_custom_hip_turn_yaw"
        syncedConVar            "gamepad_custom_hip_turn_yaw"
        showConVarAsFloat		1
		minValue				0.000000
        maxValue				250.000000
        stepSize				10.0
		
        pin_to_sibling			SldGamepadCustomHipTurnYaw
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	RIGHT
    }

    SldGamepadCustomHipTurnPitch
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        pin_to_sibling			SldGamepadCustomHipTurnYaw
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SldGamepadCustomHipTurnYaw
        navDown					SldGamepadCustomHipTurnTime
        conCommand				"gamepad_custom_hip_turn_pitch"
        minValue				0.000000
        maxValue				250.000000
        stepSize				10.0
        inverseFill             0
        showLabel               0
    }
	
	TextGamepadCustomHipTurnPitch
    {
        ControlName				TextEntry
        InheritProperties       SliderControlTextEntrySmall
		
		ConVar					"gamepad_custom_hip_turn_pitch"
        syncedConVar            "gamepad_custom_hip_turn_pitch"
        showConVarAsFloat		1
		minValue				0.000000
        maxValue				250.000000
        stepSize				10.0
		
        pin_to_sibling			SldGamepadCustomHipTurnPitch
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	RIGHT
    }

    SldGamepadCustomHipTurnTime
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        pin_to_sibling			SldGamepadCustomHipTurnPitch
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SldGamepadCustomHipTurnPitch
        navDown					SldGamepadCustomHipTurnDelay
        conCommand				"gamepad_custom_hip_turn_time"
        minValue				0.000000
        maxValue				1.000000
        stepSize				0.05
        inverseFill             0
        showLabel               0
    }
	
	TextGamepadCustomHipTurnTime
    {
        ControlName				TextEntry
        InheritProperties       SliderControlTextEntrySmall
		
		ConVar					"gamepad_custom_hip_turn_time"
        syncedConVar            "gamepad_custom_hip_turn_time"
        showConVarAsFloat		1
		minValue				0.000000
        maxValue				1.000000
        stepSize				0.05
		
        pin_to_sibling			SldGamepadCustomHipTurnTime
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	RIGHT
    }

    SldGamepadCustomHipTurnDelay
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        pin_to_sibling			SldGamepadCustomHipTurnTime
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SldGamepadCustomHipTurnTime
        navDown					SldGamepadCustomADSYaw
        conCommand				"gamepad_custom_hip_turn_delay"
        minValue				0.000000
        maxValue				1.000000
        stepSize				0.05
        inverseFill             0
        showLabel               0
    }
	
	TextGamepadCustomHipTurnDelay
    {
        ControlName				TextEntry
        InheritProperties       SliderControlTextEntrySmall
		
		ConVar					"gamepad_custom_hip_turn_delay"
        syncedConVar            "gamepad_custom_hip_turn_delay"
        showConVarAsFloat		1
		minValue				0.000000
        maxValue				1.000000
        stepSize				0.05
		
        pin_to_sibling			SldGamepadCustomHipTurnDelay
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	RIGHT
    }

    ///////////////////////////
    // ADS
    ///////////////////////////

    SldGamepadCustomADSYaw
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        pin_to_sibling			SldGamepadCustomHipTurnDelay
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        ypos					32
        navUp					SldGamepadCustomHipTurnDelay
        navDown					SldGamepadCustomADSPitch
        conCommand				"gamepad_custom_ads_yaw"
        minValue				0.000000
        maxValue				500.000000
        stepSize				10.0
        inverseFill             0
        showLabel               0
    }
	
	TextGamepadCustomADSYaw
    {
        ControlName				TextEntry
        InheritProperties       SliderControlTextEntrySmall
		
		ConVar					"gamepad_custom_ads_yaw"
        syncedConVar            "gamepad_custom_ads_yaw"
        showConVarAsFloat		1
        minValue				0.000000
        maxValue				500.000000
        stepSize				10.0
		
        pin_to_sibling			SldGamepadCustomADSYaw
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	RIGHT
    }

    SldGamepadCustomADSPitch
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        pin_to_sibling			SldGamepadCustomADSYaw
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SldGamepadCustomADSYaw
        navDown					SldGamepadCustomADSTurnYaw
        conCommand				"gamepad_custom_ads_pitch"
        minValue				0.000000
        maxValue				500.000000
        stepSize				10.0
        inverseFill             0
        showLabel               0
    }
	
	TextGamepadCustomADSPitch
    {
        ControlName				TextEntry
        InheritProperties       SliderControlTextEntrySmall
		
		ConVar					"gamepad_custom_ads_pitch"
        syncedConVar            "gamepad_custom_ads_pitch"
        showConVarAsFloat		1
        minValue				0.000000
        maxValue				500.000000
        stepSize				10.0
		
        pin_to_sibling			SldGamepadCustomADSPitch
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	RIGHT
    }

    SldGamepadCustomADSTurnYaw
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        pin_to_sibling			SldGamepadCustomADSPitch
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SldGamepadCustomADSPitch
        navDown					SldGamepadCustomADSTurnPitch
        conCommand				"gamepad_custom_ads_turn_yaw"
        minValue				0.000000
        maxValue				250.000000
        stepSize				10.0
        inverseFill             0
        showLabel               0
    }
	
	TextGamepadCustomADSTurnYaw
    {
        ControlName				TextEntry
        InheritProperties       SliderControlTextEntrySmall
		
		ConVar					"gamepad_custom_ads_turn_yaw"
        syncedConVar            "gamepad_custom_ads_turn_yaw"
        showConVarAsFloat		1
        minValue				0.000000
        maxValue				250.000000
        stepSize				10.0
		
        pin_to_sibling			SldGamepadCustomADSTurnYaw
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	RIGHT
    }

    SldGamepadCustomADSTurnPitch
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        pin_to_sibling			SldGamepadCustomADSTurnYaw
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SldGamepadCustomADSTurnYaw
        navDown					SldGamepadCustomADSTurnTime
        conCommand				"gamepad_custom_ads_turn_pitch"
        minValue				0.000000
        maxValue				250.000000
        stepSize				10.0
        inverseFill             0
        showLabel               0
    }
	
	TextGamepadCustomADSTurnPitch
    {
        ControlName				TextEntry
        InheritProperties       SliderControlTextEntrySmall
		
		ConVar					"gamepad_custom_ads_turn_pitch"
        syncedConVar            "gamepad_custom_ads_turn_pitch"
        showConVarAsFloat		1
        minValue				0.000000
        maxValue				250.000000
        stepSize				10.0
		
        pin_to_sibling			SldGamepadCustomADSTurnPitch
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	RIGHT
    }

    SldGamepadCustomADSTurnTime
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        pin_to_sibling			SldGamepadCustomADSTurnPitch
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SldGamepadCustomADSTurnPitch
        navDown					SldGamepadCustomADSTurnDelay
        conCommand				"gamepad_custom_ads_turn_time"
        minValue				0.000000
        maxValue				1.000000
        stepSize				0.05
        inverseFill             0
        showLabel               0
    }
	
	TextGamepadCustomADSTurnTime
    {
        ControlName				TextEntry
        InheritProperties       SliderControlTextEntrySmall
		
		ConVar					"gamepad_custom_ads_turn_time"
        syncedConVar            "gamepad_custom_ads_turn_time"
        showConVarAsFloat		1
        minValue				0.000000
        maxValue				1.000000
        stepSize				0.05
		
        pin_to_sibling			SldGamepadCustomADSTurnTime
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	RIGHT
    }

    SldGamepadCustomADSTurnDelay
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        pin_to_sibling			SldGamepadCustomADSTurnTime
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SldGamepadCustomADSTurnTime
        conCommand				"gamepad_custom_ads_turn_delay"
        minValue				0.000000
        maxValue				1.000000
        stepSize				0.05
        inverseFill             0
        showLabel               0
    }
	
	TextGamepadCustomADSTurnDelay
    {
        ControlName				TextEntry
        InheritProperties       SliderControlTextEntrySmall
		
		ConVar					"gamepad_custom_ads_turn_delay"
        syncedConVar            "gamepad_custom_ads_turn_delay"
        showConVarAsFloat		1
        minValue				0.000000
        maxValue				1.000000
        stepSize				0.05
		
        pin_to_sibling			SldGamepadCustomADSTurnDelay
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	RIGHT
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

        pin_to_sibling			SldGamepadCustomADSTurnDelay
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
	}
}