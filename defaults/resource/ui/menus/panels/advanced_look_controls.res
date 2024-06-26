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
        minValue				0.0
        maxValue				0.5
        stepSize				0.025
        inverseFill             0
        showLabel               0
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
        minValue				0.01
        maxValue				0.3
        stepSize				0.01
        inverseFill             0
        showLabel               0
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
        minValue				0.0
        maxValue				30.0
        stepSize				1.0
        inverseFill             0
        showLabel               0
    }

//		SwchGamepadCustomAssist
//		{
//			ControlName				RuiButton
//			InheritProperties		SwitchButton
//			style					DialogListButton
//			pin_to_sibling			SldGamepadCustomCurve
//			pin_corner_to_sibling	TOP_LEFT
//			pin_to_sibling_corner	BOTTOM_LEFT
//			navUp					SldGamepadCustomCurve
//			navDown					SldGamepadCustomHipYaw
//			ConVar					"gamepad_custom_assist_on"
//			list
//			{
//				"#SETTING_OFF"		0
//				"#SETTING_ON"		1
//			}
//		}

    SwchGamepadCustomAssist
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton
        navUp					SldGamepadCustomCurve
        navDown					SldGamepadCustomHipYaw
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

    ///////////////////////////
    // Hipfire
    ///////////////////////////

    SldGamepadCustomHipYaw
    {
        ControlName				SliderControl
        InheritProperties		SliderControl
        pin_to_sibling			SwchGamepadCustomAssist
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        ypos					32
        navUp					SwchGamepadCustomAssist
        navDown					SldGamepadCustomHipPitch
        conCommand				"gamepad_custom_hip_yaw"
        minValue				0.0
        maxValue				500.0
        stepSize				10.0
        inverseFill             0
        showLabel               0
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
        minValue				0.0
        maxValue				500.0
        stepSize				10.0
        inverseFill             0
        showLabel               0
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
        minValue				0.0
        maxValue				250.0
        stepSize				10.0
        showLabel               0
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
        minValue				0.0
        maxValue				250.0
        stepSize				10.0
        inverseFill             0
        showLabel               0
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
        minValue				0.0
        maxValue				1.0
        stepSize				0.05
        inverseFill             0
        showLabel               0
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
        minValue				0.0
        maxValue				1.0
        stepSize				0.05
        inverseFill             0
        showLabel               0
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
        minValue				0.0
        maxValue				500.0
        stepSize				10.0
        inverseFill             0
        showLabel               0
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
        minValue				0.0
        maxValue				500.0
        stepSize				10.0
        inverseFill             0
        showLabel               0
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
        minValue				0.0
        maxValue				250.0
        stepSize				10.0
        inverseFill             0
        showLabel               0
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
        minValue				0.0
        maxValue				250.0
        stepSize				10.0
        inverseFill             0
        showLabel               0
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
        minValue				0.0
        maxValue				1.0
        stepSize				0.05
        inverseFill             0
        showLabel               0
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
        minValue				0.0
        maxValue				1.0
        stepSize				0.05
        inverseFill             0
        showLabel               0
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