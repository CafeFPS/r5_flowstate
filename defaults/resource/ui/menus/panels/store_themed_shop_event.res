"resource/ui/menus/panels/store_themed_shop_event.res"
{
	PanelFrame
	{
		ControlName				Label
		wide					%100
		tall					%100
		labelText				""
	    bgcolor_override		"70 70 0 128"
		visible					0
		paintbackground			1
        proportionalToParent    1
	}

	CenterFrame
	{
		ControlName				Label
        wide					1920
		tall					%100
		labelText				""
	    bgcolor_override		"0 255 0 100"
		visible					0
		paintbackground			1
        proportionalToParent    1

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	ItemGroup1
	{
		ControlName				RuiPanel

        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling			CenterFrame
        pin_to_sibling_corner	TOP_LEFT
        xpos					-48
        ypos					-12
        wide					1056
		tall					822

        rui                     "ui/themed_shop_item_group.rpak"
	}

	OfferButton1
	{
		ControlName				RuiButton
        classname               "MenuButton"

        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling			ItemGroup1
        pin_to_sibling_corner	TOP_LEFT
		xpos					-24
		ypos                    -78
		wide					498
		tall					408

        visible                 0
        rui					    "ui/themed_shop_item_button.rpak"
        navRight                OfferButton2
        navDown                 OfferButton3
	}

	OfferButton2
	{
		ControlName				RuiButton
        classname               "MenuButton"

        pin_corner_to_sibling	TOP_RIGHT
        pin_to_sibling			ItemGroup1
        pin_to_sibling_corner	TOP_RIGHT
		xpos					-24
		ypos                    -78
		wide					498
		tall					408

        visible                 0
        rui					    "ui/themed_shop_item_button.rpak"
        navLeft                 OfferButton1
        navRight                OfferButton5
        navDown                 OfferButton4
	}

	OfferButton3
	{
		ControlName				RuiButton
        classname               "MenuButton"

        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling			OfferButton1
        pin_to_sibling_corner	BOTTOM_LEFT
		ypos                    12
		wide					498
		tall					312

        visible                 0
        rui					    "ui/themed_shop_item_button.rpak"
        navUp                   OfferButton1
        navRight                OfferButton4
	}

	OfferButton4
	{
		ControlName				RuiButton
        classname               "MenuButton"

        pin_corner_to_sibling	TOP_RIGHT
        pin_to_sibling			OfferButton2
        pin_to_sibling_corner	BOTTOM_RIGHT
		ypos                    12
		wide					498
		tall					312

        visible                 0
        rui					    "ui/themed_shop_item_button.rpak"
        navLeft                 OfferButton3
        navRight                OfferButton5
        navUp                   OfferButton2
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	ItemGroup2
	{
		ControlName				RuiPanel

        pin_corner_to_sibling	TOP_RIGHT
        pin_to_sibling			CenterFrame
        pin_to_sibling_corner	TOP_RIGHT
        xpos					-48
        ypos					-12
        wide					732
		tall					822

        rui                     "ui/themed_shop_item_group.rpak"
	}

	OfferButton5
	{
		ControlName				RuiButton
        classname               "MenuButton"

        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling			ItemGroup2
        pin_to_sibling_corner	TOP_LEFT
		xpos					-24
		ypos                    -78
		wide					336
		tall					732

        visible                 0
        rui					    "ui/themed_shop_item_button.rpak"
        navLeft                 OfferButton2
        navRight                OfferButton6
	}

	OfferButton6
	{
		ControlName				RuiButton
        classname               "MenuButton"

        pin_corner_to_sibling	TOP_RIGHT
        pin_to_sibling			ItemGroup2
        pin_to_sibling_corner	TOP_RIGHT
		xpos					-24
		ypos                    -78
		wide					336
		tall					360

        visible                 0
        rui					    "ui/themed_shop_item_button.rpak"
        navLeft                 OfferButton5
        navDown                 OfferButton7
	}

	OfferButton7
	{
		ControlName				RuiButton
        classname               "MenuButton"

        pin_corner_to_sibling	TOP_RIGHT
        pin_to_sibling			OfferButton6
        pin_to_sibling_corner	BOTTOM_RIGHT
		ypos                    12
		wide					336
		tall					360

        visible                 0
        rui					    "ui/themed_shop_item_button.rpak"
        navLeft                 OfferButton5
        navUp                   OfferButton7
	}
}


