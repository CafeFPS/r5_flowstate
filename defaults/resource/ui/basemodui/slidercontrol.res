Resource/UI/SliderControl.res
{
    BtnDropButton
    {
        ControlName				RuiPanel
        tall					60
        zpos					3
        visible					1
        enabled					1
        style					SliderButton
        rui						"ui/settings_base_button.rpak"
        clipRui					1
        autoResize				1
        pinCorner				0
        command					""
    }

	LblSliderText
	{
		ControlName				RuiPanel
        rui						"ui/settings_slider_label.rpak"
		fieldName				LblSliderText
		xpos                    0
		wide					60
		tall					60
		zpos                    100
		autoResize				0
		pinCorner				0
		visible					1
		enabled					1

		pin_to_sibling          BtnDropButton
		pin_corner_to_sibling	RIGHT
		pin_to_sibling_corner	RIGHT
	}

	PrgValue
	{
		ControlName				RuiPanel
		fieldName				PrgValue
		zpos					5
        wide					280
		tall					60
		visible					1
		enabled					1
		tabPosition				0
		rui                     "ui/settings_slider.rpak"
	}

	PnlDefaultMark
	{
		ControlName				RuiPanel
		ypos 					0
		zpos					10
		wide					2
		tall					60
		rui                     "ui/settings_slider_default.rpak"
		visible					1

		pin_corner_to_sibling	CENTER
		pin_to_sibling_corner	CENTER
	}
}