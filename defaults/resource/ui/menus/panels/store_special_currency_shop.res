"resource/ui/menus/panels/store_special_currency_shop.res"
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
        xpos					0
        ypos					0
        wide					1920
		tall					%100
		labelText				""
	    bgcolor_override		"70 30 70 64"
		visible					0
		paintbackground			1
        proportionalToParent    1

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP
	}

	InfoBox
	{
	    ControlName				RuiPanel

	    pin_to_sibling			CenterFrame
	    pin_corner_to_sibling	TOP_LEFT
	    pin_to_sibling_corner	TOP_LEFT
	    xpos					0
	    ypos					-22
	    wide					620
	    tall					340

        visible                 1
	    rui					    "ui/special_currency_shop_info_box.rpak"
	}

	OfferButton1
	{
		ControlName				RuiButton
        classname               "MenuButton"

        pin_corner_to_sibling	TOP_RIGHT
        pin_to_sibling			InfoBox
        pin_to_sibling_corner	BOTTOM_RIGHT
		xpos					0
		ypos                    26
		wide					580
		tall					440

        visible                 0
        rui					    "ui/special_currency_shop_item_button.rpak"
        rightClickEvents		1
        navRight                OfferButton4
	}

	OfferButton2
	{
		ControlName				RuiButton
        classname               "MenuButton"

        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling			InfoBox
        pin_to_sibling_corner	TOP_RIGHT
		xpos					46
		ypos                    -30
		wide					580
		tall					370

        visible                 0
        rui					    "ui/special_currency_shop_item_button.rpak"
        rightClickEvents		1
        navLeft                 OfferButton1
        navRight                OfferButton3
        navDown                 OfferButton4
	}

	OfferButton3
	{
		ControlName				RuiButton
        classname               "MenuButton"

        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling			OfferButton2
        pin_to_sibling_corner	TOP_RIGHT
		xpos					42
		ypos                    0
		wide					580
		tall					370

        visible                 0
        rui					    "ui/special_currency_shop_item_button.rpak"
        rightClickEvents		1
        navLeft                 OfferButton2
        navDown                 OfferButton6
	}

	OfferButton4
	{
		ControlName				RuiButton
        classname               "MenuButton"

        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling			OfferButton2
        pin_to_sibling_corner	BOTTOM_LEFT
		xpos					0
		ypos                    40
		wide					370
		tall					370

        visible                 0
        rui					    "ui/special_currency_shop_item_button.rpak"
        rightClickEvents		1
        navLeft                 OfferButton1
        navRight                OfferButton5
        navUp                   OfferButton2
	}

	OfferButton5
	{
		ControlName				RuiButton
        classname               "MenuButton"

        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling			OfferButton4
        pin_to_sibling_corner	TOP_RIGHT
		xpos					44
		ypos                    0
		wide					370
		tall					370

        visible                 0
        rui					    "ui/special_currency_shop_item_button.rpak"
        rightClickEvents		1
        navLeft                 OfferButton4
        navRight                OfferButton6
        navUp                   OfferButton2
	}

	OfferButton6
	{
		ControlName				RuiButton
        classname               "MenuButton"

        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling			OfferButton5
        pin_to_sibling_corner	TOP_RIGHT
		xpos					44
		ypos                    0
		wide					370
		tall					370

        visible                 0
        rui					    "ui/special_currency_shop_item_button.rpak"
        rightClickEvents		1
        navLeft                 OfferButton5
        navUp                   OfferButton3
	}
}


