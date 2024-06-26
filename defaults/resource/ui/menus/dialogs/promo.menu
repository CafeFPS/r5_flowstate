resource/ui/menus/dialog.menu
{
	menu
	{
		ControlName				Frame
		zpos					3
		wide					f0
		tall					f0
		autoResize				0
		pinCorner				0
		visible					1
		enabled					1
		tabPosition				0
		PaintBackgroundType		0
		infocus_bgcolor_override	"0 0 0 0"
		outoffocus_bgcolor_override	"0 0 0 0"
		modal					1
		disableDpad             1

		ScreenBlur
		{
			ControlName				RuiPanel
			wide					%100
			tall					%100
			rui                     "ui/promo_screen_blur.rpak"
			visible					1
		}

		DarkenBackground
		{
			ControlName				Label
			xpos					0
			ypos					0
			wide					%100
			tall					%100
			labelText				""
			bgcolor_override		"0 0 0 150"
			visible					1
			paintbackground			1
		}

		LastPage
		{
			ControlName				RuiPanel
			wide					1920
			tall                    664
			visible					1
			rui                     "ui/promo_page.rpak"

			pin_to_sibling			DarkenBackground
			pin_corner_to_sibling	CENTER
			pin_to_sibling_corner	CENTER
		}

		ActivePage
		{
			ControlName				RuiPanel
			wide					1920
			tall                    664
			visible					1
			rui                     "ui/promo_page.rpak"

			pin_to_sibling			DarkenBackground
			pin_corner_to_sibling	CENTER
			pin_to_sibling_corner	CENTER
		}

        PrevPageButton
        {
            ControlName				RuiButton
            wide					960
            tall					594
            rui                     "ui/promo_page_change_button.rpak"
            labelText               ""
            visible					1
            proportionalToParent    1
            sound_accept            "UI_Menu_MOTD_Tab"

            pin_to_sibling			ActivePage
            pin_corner_to_sibling	TOP_LEFT
            pin_to_sibling_corner	TOP_LEFT
        }

        NextPageButton
        {
            ControlName				RuiButton
            wide					960
            tall					594
            rui                     "ui/promo_page_change_button.rpak"
            labelText               ""
            visible					1
            proportionalToParent    1
            sound_accept            "UI_Menu_MOTD_Tab"

            pin_to_sibling			ActivePage
            pin_corner_to_sibling	TOP_RIGHT
            pin_to_sibling_corner	TOP_RIGHT
        }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		FooterButtons
		{
			ControlName				CNestedPanel
			InheritProperties       PromoFooterButtons
			xpos					0
			ypos                    32
            //wide					200 // width of 1 button
            wide					422 // width of 2 buttons including space in between

			pin_to_sibling			ActivePage
			pin_corner_to_sibling	TOP
			pin_to_sibling_corner	BOTTOM
		}
	}
}
