Resource/UI/HUDDev.res
{
	ModelViewerControllerImage
	{
		ControlName			ImagePanel
		xpos				0
		ypos				0
		wide				405
		tall				288
		image 				"ui/menu/controls_menu/xboxone_gamepad_stick_layout" [$DURANGO || $WINDOWS]
		image 				"ui/menu/controls_menu/ps4_gamepad_stick_layout" [$PS4]
		visible				0
		scaleImage			1

		zpos				1001

		pin_to_sibling				SafeArea
		pin_corner_to_sibling		BOTTOM_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}

	ModelViewerTriggerLeftLabel
	{
		ControlName			Label
		xpos				124
		ypos				-34
		wide				247
		tall				27
		visible				0
		font				Default_17_ShadowGlow
		labelText			""
		allcaps				0
		textAlignment		east
		fgcolor_override 	"255 255 255 255"

		zpos				1002

		pin_to_sibling				ModelViewerControllerImage
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}

	ModelViewerTriggerRightLabel
	{
		ControlName			Label
		xpos				-281
		ypos				-34
		wide				247
		tall				27
		visible				0
		font				Default_17_ShadowGlow
		labelText			""
		allcaps				0
		textAlignment		west
		fgcolor_override 	"255 255 255 255"

		zpos				1002

		pin_to_sibling				ModelViewerControllerImage
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}

	ModelViewerShoulderLeftLabel
	{
		ControlName			Label
		xpos				124
		ypos				-67
		wide				247
		tall				27
		visible				0
		font				Default_17_ShadowGlow
		labelText			""
		allcaps				0
		textAlignment		east
		fgcolor_override 	"255 255 255 255"

		zpos				1002

		pin_to_sibling				ModelViewerControllerImage
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}

	ModelViewerShoulderRightLabel
	{
		ControlName			Label
		xpos				-281
		ypos				-67
		wide				247
		tall				27
		visible				0
		font				Default_17_ShadowGlow
		labelText			""
		allcaps				0
		textAlignment		west
		fgcolor_override 	"255 255 255 255"

		zpos				1002

		pin_to_sibling				ModelViewerControllerImage
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}

	ModelViewerButtonYLabel
	{
		ControlName			Label
		xpos				-274
		ypos				-101
		wide				247
		tall				27
		visible				0
		font				Default_17_ShadowGlow
		labelText			"%[Y_BUTTON|]% Next Model"
		allcaps				0
		textAlignment		west
		fgcolor_override 	"255 255 255 255"

		zpos				1002

		pin_to_sibling				ModelViewerControllerImage
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}

	ModelViewerButtonXLabel
	{
		ControlName			Label
		xpos				-27
		ypos				-121
		wide				247
		tall				27
		visible				0
		font				Default_17_ShadowGlow
		labelText			""
		allcaps				0
		textAlignment		east
		fgcolor_override 	"255 255 255 255"

		zpos				1002

		pin_to_sibling				ModelViewerControllerImage
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}

	ModelViewerButtonBLabel
	{
		ControlName			Label
		xpos				-297
		ypos				-121
		wide				247
		tall				27
		visible				0
		font				Default_17_ShadowGlow
		labelText			""
		allcaps				0
		textAlignment		west
		fgcolor_override 	"255 255 255 255"

		zpos				1002

		pin_to_sibling				ModelViewerControllerImage
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}

	ModelViewerButtonALabel
	{
		ControlName			Label
		xpos				-274
		ypos				-142
		wide				247
		tall				27
		visible				0
		font				Default_17_ShadowGlow
		labelText			"%[A_BUTTON|]% Toggle noclip"
		allcaps				0
		textAlignment		west
		fgcolor_override 	"255 255 255 255"

		zpos				1002

		pin_to_sibling				ModelViewerControllerImage
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}

	ModelViewerStickLeftLabel
	{
		ControlName			Label
		xpos				117
		ypos				-124
		wide				247
		tall				27
		visible				0
		font				Default_17_ShadowGlow
		labelText			""
		allcaps				0
		textAlignment		east
		fgcolor_override 	"255 255 255 255"

		zpos				1002

		pin_to_sibling				ModelViewerControllerImage
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}

	ModelViewerStickRightLabel
	{
		ControlName			Label
		xpos				-234
		ypos				-169
		wide				247
		tall				27
		visible				0
		font				Default_17_ShadowGlow
		labelText			""
		allcaps				0
		textAlignment		west
		fgcolor_override 	"255 255 255 255"

		zpos				1002

		pin_to_sibling				ModelViewerControllerImage
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}

	ModelViewerStickDPadLabel
	{
		ControlName			Label
		xpos				81
		ypos				-166
		wide				247
		tall				27
		visible				0
		font				Default_17_ShadowGlow
		labelText			"Drop Model"
		allcaps				0
		textAlignment		east
		fgcolor_override 	"255 255 255 255"

		zpos				1002

		pin_to_sibling				ModelViewerControllerImage
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}

	ModelViewerModelName0
	{
		ControlName			Label
		xpos				0
		ypos				247
		wide				450
		tall				27
		visible				0
		font				Default_17_ShadowGlow
		labelText			"Use reRun to add models, then restart the model viewer."
		allcaps				0
		textAlignment		west
		fgcolor_override 	"255 255 255 255"

		zpos				1002

		pin_to_sibling				ModelViewerControllerImage
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}

	ModelViewerModelName1
	{
		ControlName			Label
		xpos				0
		ypos				0
		wide				450
		tall				27
		visible				0
		font				Default_17_ShadowGlow
		labelText			""
		allcaps				0
		textAlignment		west
		fgcolor_override 	"255 255 255 255"

		zpos				1002

		pin_to_sibling				ModelViewerModelName0
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}

	ModelViewerModelName2
	{
		ControlName			Label
		xpos				0
		ypos				0
		wide				450
		tall				27
		visible				0
		font				Default_17_ShadowGlow
		labelText			""
		allcaps				0
		textAlignment		west
		fgcolor_override 	"255 255 255 255"

		zpos				1002

		pin_to_sibling				ModelViewerModelName1
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}

	ModelViewerModelName3
	{
		ControlName			Label
		xpos				0
		ypos				0
		wide				450
		tall				27
		visible				0
		font				Default_17_ShadowGlow
		labelText			""
		allcaps				0
		textAlignment		west
		fgcolor_override 	"255 255 255 255"

		zpos				1002

		pin_to_sibling				ModelViewerModelName2
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}

	ModelViewerModelName4
	{
		ControlName			Label
		xpos				0
		ypos				0
		wide				450
		tall				27
		visible				0
		font				Default_17_ShadowGlow
		labelText			""
		allcaps				0
		textAlignment		west
		fgcolor_override 	"255 255 255 255"

		zpos				1002

		pin_to_sibling				ModelViewerModelName3
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}

	ModelViewerModelName5
	{
		ControlName			Label
		xpos				0
		ypos				0
		wide				450
		tall				27
		visible				0
		font				Default_17_ShadowGlow
		labelText			""
		allcaps				0
		textAlignment		west
		fgcolor_override 	"255 255 255 255"

		zpos				1002

		pin_to_sibling				ModelViewerModelName4
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}

	ModelViewerModelName6
	{
		ControlName			Label
		xpos				0
		ypos				0
		wide				450
		tall				27
		visible				0
		font				Default_17_ShadowGlow
		labelText			""
		allcaps				0
		textAlignment		west
		fgcolor_override 	"255 255 255 255"

		zpos				1002

		pin_to_sibling				ModelViewerModelName5
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}

	ModelViewerModelName7
	{
		ControlName			Label
		xpos				0
		ypos				0
		wide				450
		tall				27
		visible				0
		font				Default_17_ShadowGlow
		labelText			""
		allcaps				0
		textAlignment		west
		fgcolor_override 	"255 255 255 255"

		zpos				1002

		pin_to_sibling				ModelViewerModelName6
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}

	ModelViewerModelName8
	{
		ControlName			Label
		xpos				0
		ypos				0
		wide				450
		tall				27
		visible				0
		font				Default_17_ShadowGlow
		labelText			""
		allcaps				0
		textAlignment		west
		fgcolor_override 	"255 255 255 255"

		zpos				1002

		pin_to_sibling				ModelViewerModelName7
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}

	ModelViewerModelName9
	{
		ControlName			Label
		xpos				0
		ypos				0
		wide				450
		tall				27
		visible				0
		font				Default_17_ShadowGlow
		labelText			""
		allcaps				0
		textAlignment		west
		fgcolor_override 	"255 255 255 255"

		zpos				1002

		pin_to_sibling				ModelViewerModelName8
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}
}