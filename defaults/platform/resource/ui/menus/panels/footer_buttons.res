"resource/ui/menus/panels/footer_buttons.res"
{
	PinFrame
	{
		ControlName				Label
		xpos					0
		ypos					0
		wide					%100
		tall					36
		labelText				""
		//bgcolor_override		"100 100 100 100"
		//paintbackground			1
		//visible					1
		mouseEnabled			0
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	LeftRuiFooterButton0
	{
		ControlName				RuiButton
		InheritProperties		LeftRuiFooterButton
		scriptID				0
		pin_to_sibling			PinFrame
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
		xpos					-48
	}
	LeftRuiFooterButton1
	{
		ControlName				RuiButton
		InheritProperties		LeftRuiFooterButton
		scriptID				1
		pin_to_sibling			LeftRuiFooterButton0
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		xpos 					22
	}
	LeftRuiFooterButton2
	{
		ControlName				RuiButton
		InheritProperties		LeftRuiFooterButton
		scriptID				2
		pin_to_sibling			LeftRuiFooterButton1
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		xpos 					22
	}
	LeftRuiFooterButton3
	{
		ControlName				RuiButton
		InheritProperties		LeftRuiFooterButton
		scriptID				3
		pin_to_sibling			LeftRuiFooterButton2
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		xpos 					22
	}
	LeftRuiFooterButton4
	{
		ControlName				RuiButton
		InheritProperties		LeftRuiFooterButton
		scriptID				4
		pin_to_sibling			LeftRuiFooterButton3
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		xpos 					22
	}
	LeftRuiFooterButton5
	{
		ControlName				RuiButton
		InheritProperties		LeftRuiFooterButton
		scriptID				5
		pin_to_sibling			LeftRuiFooterButton4
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		xpos 					22
	}
	LeftRuiFooterButton6
	{
		ControlName				RuiButton
		InheritProperties		LeftRuiFooterButton
		scriptID				6
		pin_to_sibling			LeftRuiFooterButton5
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		xpos 					22
	}
	LeftRuiFooterButton7
	{
		ControlName				RuiButton
		InheritProperties		LeftRuiFooterButton
		scriptID				7
		pin_to_sibling			LeftRuiFooterButton6
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		xpos 					22
	}




	RightRuiFooterButton0
	{
		ControlName				RuiButton
		InheritProperties		RightRuiFooterButton
		scriptID				0
		pin_to_sibling			PinFrame
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_RIGHT
		xpos					-48
		bgcolor_override		"0 255 0 255"
      	paintbackground			1
	}
	RightRuiFooterButton1
	{
		ControlName				RuiButton
		InheritProperties		RightRuiFooterButton
		scriptID				1
		pin_to_sibling			RightRuiFooterButton0
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_LEFT
		xpos 					22
	}
	RightRuiFooterButton2
	{
		ControlName				RuiButton
		InheritProperties		RightRuiFooterButton
		scriptID				2
		pin_to_sibling			RightRuiFooterButton1
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_LEFT
		xpos 					22
	}
	RightRuiFooterButton3
	{
		ControlName				RuiButton
		InheritProperties		RightRuiFooterButton
		scriptID				3
		pin_to_sibling			RightRuiFooterButton2
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_LEFT
		xpos 					22
	}
	RightRuiFooterButton4
	{
		ControlName				RuiButton
		InheritProperties		RightRuiFooterButton
		scriptID				4
		pin_to_sibling			RightRuiFooterButton3
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_LEFT
		xpos 					22
	}
	RightRuiFooterButton5
	{
		ControlName				RuiButton
		InheritProperties		RightRuiFooterButton
		scriptID				5
		pin_to_sibling			RightRuiFooterButton4
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_LEFT
		xpos 					22
	}
	RightRuiFooterButton6
	{
		ControlName				RuiButton
		InheritProperties		RightRuiFooterButton
		scriptID				6
		pin_to_sibling			RightRuiFooterButton5
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_LEFT
		xpos 					22
	}
	RightRuiFooterButton7
	{
		ControlName				RuiButton
		InheritProperties		RightRuiFooterButton
		scriptID				7
		pin_to_sibling			RightRuiFooterButton6
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_LEFT
		xpos 					22
	}
}