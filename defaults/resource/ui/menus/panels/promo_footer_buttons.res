"resource/ui/menus/panels/dialog_footer_buttons.res"
{
	PinFrame
	{
		ControlName				Label
		xpos					0
		ypos					0
		wide					%100
		tall					60
		labelText				""
		//bgcolor_override		"100 100 100 100"
		//paintbackground			1
		//visible					1
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	LeftRuiFooterButton0
	{
		ControlName				RuiButton
		//InheritProperties		LeftRuiFooterButton
        classname				"LeftRuiFooterButtonClass MenuButton"
        style					RuiFooterButton
        rui						"ui/promo_footer_button.rpak"
        wide                    200
        tall					60
        font                    Default_28
        labelText				"DEFAULT"
        enabled					1
        visible					1
        behave_as_label         1

		scriptID				0
		pin_to_sibling			PinFrame
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	LeftRuiFooterButton1
	{
		ControlName				RuiButton
		//InheritProperties		LeftRuiFooterButton
        classname				"LeftRuiFooterButtonClass MenuButton"
        style					RuiFooterButton
        rui						"ui/promo_footer_button.rpak"
        wide                    200
        tall					60
        font                    Default_28
        labelText				"DEFAULT"
        enabled					1
        visible					1
        behave_as_label         1

		scriptID				1
		pin_to_sibling			LeftRuiFooterButton0
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		xpos 					22
	}
}