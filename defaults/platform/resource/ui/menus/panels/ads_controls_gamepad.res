"resource/ui/menus/panels/ads_controls_gamepad.res"
{
    SwchLookSensitivity
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton
        xpos					0
        ypos					0
        navDown					SwchLookSensitivityADS
        navUp                   ""
        tabPosition				1
        ConVar					"gamepad_aim_speed"
        list
        {
            "#SETTING_SENSITIVITY_VERYLOW"		0
            "#SETTING_SENSITIVITY_LOW"			1
            "#SETTING_SENSITIVITY_DEFAULT_NUM"	2
            "#SETTING_SENSITIVITY_HIGH"			3
            "#SETTING_SENSITIVITY_VERY_HIGH"	4
            "#SETTING_SENSITIVITY_SUPER_HIGH"	5
            "#SETTING_SENSITIVITY_ULTRA_HIGH"	6
            "#SETTING_SENSITIVITY_INSANE"		7
        }

        childGroupAlways        MultiChoiceButtonAlways
    }

    SwchLookSensitivityADS
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton

        pin_to_sibling			SwchLookSensitivity
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SwchLookSensitivity
        navDown					SwchCustomADSEnabled

        ConVar					"gamepad_aim_speed_ads_0"
        list
        {
            "#SETTING_SENSITIVITY_SAME"		    -1
            "#SETTING_SENSITIVITY_VERYLOW"		0
            "#SETTING_SENSITIVITY_LOW"			1
            "#SETTING_SENSITIVITY_DEFAULT_NUM"	2
            "#SETTING_SENSITIVITY_HIGH"			3
            "#SETTING_SENSITIVITY_VERY_HIGH"	4
            "#SETTING_SENSITIVITY_SUPER_HIGH"	5
            "#SETTING_SENSITIVITY_ULTRA_HIGH"	6
            "#SETTING_SENSITIVITY_INSANE"		7
        }

        childGroupAlways        MultiChoiceButtonAlways
    }

    CustomADSHeader
    {
        ControlName				ImagePanel
        InheritProperties		SubheaderBackgroundWide
        xpos					0
        ypos					38
        pin_to_sibling			SwchLookSensitivityADS
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
        navDown					SwchLookSensitivityADS0
        tabPosition				1
        ConVar					"gamepad_use_per_scope_ads_settings"
        list
        {
            "#SETTING_OFF"		0
            "#SETTING_ON"		1
        }

        childGroupAlways        ChoiceButtonAlways
    }

    SwchLookSensitivityADS0
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton

        pin_to_sibling			SwchCustomADSEnabled
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        ypos					32
        navUp					SwchCustomADSEnabled
        navDown					SwchLookSensitivityADS1

        ConVar					"gamepad_aim_speed_ads_0"
        list
        {
            "#SETTING_SENSITIVITY_DEFAULT"			-1
            "#SETTING_SENSITIVITY_VERYLOW"		0
            "#SETTING_SENSITIVITY_LOW"			1
            "#SETTING_SENSITIVITY_DEFAULT_NUM"	2
            "#SETTING_SENSITIVITY_HIGH"			3
            "#SETTING_SENSITIVITY_VERY_HIGH"	4
            "#SETTING_SENSITIVITY_SUPER_HIGH"	5
            "#SETTING_SENSITIVITY_ULTRA_HIGH"	6
            "#SETTING_SENSITIVITY_INSANE"		7
        }

        childGroupAlways        MultiChoiceButtonAlways
    }

    SwchLookSensitivityADS1
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton

        pin_to_sibling			SwchLookSensitivityADS0
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SwchLookSensitivityADS0
        navDown					SwchLookSensitivityADS2

        ConVar					"gamepad_aim_speed_ads_1"
        list
        {
            "#SETTING_SENSITIVITY_DEFAULT"			-1
            "#SETTING_SENSITIVITY_VERYLOW"		0
            "#SETTING_SENSITIVITY_LOW"			1
            "#SETTING_SENSITIVITY_DEFAULT_NUM"	2
            "#SETTING_SENSITIVITY_HIGH"			3
            "#SETTING_SENSITIVITY_VERY_HIGH"	4
            "#SETTING_SENSITIVITY_SUPER_HIGH"	5
            "#SETTING_SENSITIVITY_ULTRA_HIGH"	6
            "#SETTING_SENSITIVITY_INSANE"		7
        }

        childGroupAlways        MultiChoiceButtonAlways
    }

    SwchLookSensitivityADS2
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton

        pin_to_sibling			SwchLookSensitivityADS1
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SwchLookSensitivityADS1
        navDown					SwchLookSensitivityADS3

        ConVar					"gamepad_aim_speed_ads_2"
        list
        {
            "#SETTING_SENSITIVITY_DEFAULT"			-1
            "#SETTING_SENSITIVITY_VERYLOW"		0
            "#SETTING_SENSITIVITY_LOW"			1
            "#SETTING_SENSITIVITY_DEFAULT_NUM"	2
            "#SETTING_SENSITIVITY_HIGH"			3
            "#SETTING_SENSITIVITY_VERY_HIGH"	4
            "#SETTING_SENSITIVITY_SUPER_HIGH"	5
            "#SETTING_SENSITIVITY_ULTRA_HIGH"	6
            "#SETTING_SENSITIVITY_INSANE"		7
        }

        childGroupAlways        MultiChoiceButtonAlways
    }

    SwchLookSensitivityADS3
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton

        pin_to_sibling			SwchLookSensitivityADS2
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SwchLookSensitivityADS2
        navDown					SwchLookSensitivityADS4

        ConVar					"gamepad_aim_speed_ads_3"
        list
        {
            "#SETTING_SENSITIVITY_DEFAULT"			-1
            "#SETTING_SENSITIVITY_VERYLOW"		0
            "#SETTING_SENSITIVITY_LOW"			1
            "#SETTING_SENSITIVITY_DEFAULT_NUM"	2
            "#SETTING_SENSITIVITY_HIGH"			3
            "#SETTING_SENSITIVITY_VERY_HIGH"	4
            "#SETTING_SENSITIVITY_SUPER_HIGH"	5
            "#SETTING_SENSITIVITY_ULTRA_HIGH"	6
            "#SETTING_SENSITIVITY_INSANE"		7
        }

        childGroupAlways        MultiChoiceButtonAlways
    }

    SwchLookSensitivityADS4
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton

        pin_to_sibling			SwchLookSensitivityADS3
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SwchLookSensitivityADS3
        navDown					SwchLookSensitivityADS5

        ConVar					"gamepad_aim_speed_ads_4"
        list
        {
            "#SETTING_SENSITIVITY_DEFAULT"			-1
            "#SETTING_SENSITIVITY_VERYLOW"		0
            "#SETTING_SENSITIVITY_LOW"			1
            "#SETTING_SENSITIVITY_DEFAULT_NUM"	2
            "#SETTING_SENSITIVITY_HIGH"			3
            "#SETTING_SENSITIVITY_VERY_HIGH"	4
            "#SETTING_SENSITIVITY_SUPER_HIGH"	5
            "#SETTING_SENSITIVITY_ULTRA_HIGH"	6
            "#SETTING_SENSITIVITY_INSANE"		7
        }

        childGroupAlways        MultiChoiceButtonAlways
    }

    SwchLookSensitivityADS5
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton

        pin_to_sibling			SwchLookSensitivityADS4
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SwchLookSensitivityADS4
        navDown					SwchLookSensitivityADS6

        ConVar					"gamepad_aim_speed_ads_5"
        list
        {
            "#SETTING_SENSITIVITY_DEFAULT"			-1
            "#SETTING_SENSITIVITY_VERYLOW"		0
            "#SETTING_SENSITIVITY_LOW"			1
            "#SETTING_SENSITIVITY_DEFAULT_NUM"	2
            "#SETTING_SENSITIVITY_HIGH"			3
            "#SETTING_SENSITIVITY_VERY_HIGH"	4
            "#SETTING_SENSITIVITY_SUPER_HIGH"	5
            "#SETTING_SENSITIVITY_ULTRA_HIGH"	6
            "#SETTING_SENSITIVITY_INSANE"		7
        }

        childGroupAlways        MultiChoiceButtonAlways
    }

    SwchLookSensitivityADS6
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton

        pin_to_sibling			SwchLookSensitivityADS5
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SwchLookSensitivityADS5
        navDown					SwchLookSensitivityADS7

        ConVar					"gamepad_aim_speed_ads_6"
        list
        {
            "#SETTING_SENSITIVITY_DEFAULT"			-1
            "#SETTING_SENSITIVITY_VERYLOW"		0
            "#SETTING_SENSITIVITY_LOW"			1
            "#SETTING_SENSITIVITY_DEFAULT_NUM"	2
            "#SETTING_SENSITIVITY_HIGH"			3
            "#SETTING_SENSITIVITY_VERY_HIGH"	4
            "#SETTING_SENSITIVITY_SUPER_HIGH"	5
            "#SETTING_SENSITIVITY_ULTRA_HIGH"	6
            "#SETTING_SENSITIVITY_INSANE"		7
        }

        childGroupAlways        MultiChoiceButtonAlways
    }

    SwchLookSensitivityADS7
    {
        ControlName				RuiButton
        InheritProperties		SwitchButton
        style					DialogListButton

        pin_to_sibling			SwchLookSensitivityADS6
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        navUp					SwchLookSensitivityADS6
        navDown                 ""

        ConVar					"gamepad_aim_speed_ads_7"
        list
        {
            "#SETTING_SENSITIVITY_DEFAULT"			-1
            "#SETTING_SENSITIVITY_VERYLOW"		0
            "#SETTING_SENSITIVITY_LOW"			1
            "#SETTING_SENSITIVITY_DEFAULT_NUM"	2
            "#SETTING_SENSITIVITY_HIGH"			3
            "#SETTING_SENSITIVITY_VERY_HIGH"	4
            "#SETTING_SENSITIVITY_SUPER_HIGH"	5
            "#SETTING_SENSITIVITY_ULTRA_HIGH"	6
            "#SETTING_SENSITIVITY_INSANE"		7
        }

        childGroupAlways        MultiChoiceButtonAlways

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

        pin_to_sibling			SwchLookSensitivityADS7
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
	}
}