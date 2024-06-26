"resource/ui/menus/panels/establish_user_error.res"
{
    DarkenBackground
    {
        ControlName				Label
        xpos					0
        ypos					0
        wide					%100
        tall					%100
        labelText				""
        bgcolor_override		"0 0 0 227"
        visible					0
        paintbackground			1
    }

    DialogFrame
    {
        ControlName				RuiPanel
        wide					%100
        tall					386 //664
        rui                     "ui/basic_image.rpak"
        visible					1

        pin_to_sibling			DarkenBackground
        pin_corner_to_sibling	CENTER
        pin_to_sibling_corner	CENTER
    }

    DialogHeader
    {
        ControlName				Label
        xpos					-368
        ypos                    -40
        auto_wide_tocontents	1
        tall					41
        visible					1
        labelText				""
        font					DefaultBold_41
        allcaps					1
        fgcolor_override		"255 255 255 255"

        pin_to_sibling			DialogFrame
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP
    }

    DialogMessage
    {
        ControlName				Label
        classname 				DialogMessageClass
        ypos					28
        wide					736
        auto_tall_tocontents	1
        visible					1
        labelText				""
        font					Default_28
        textAlignment			north-west
        wrap					1

        pin_to_sibling			DialogHeader
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

    DialogMessageRui
    {
        ControlName				RuiPanel
        classname 				DialogMessageRuiClass
        ypos					28
        wide					736
        tall                    196
        visible					1
        rui                     "ui/dialog_message_area.rpak"

        pin_to_sibling			DialogHeader
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

    DialogImage
    {
        ControlName				RuiPanel
        classname 				DialogImageClass
        xpos                    30
        ypos                    -8
        wide					160
        tall					160
        visible					1
        rui                     "ui/basic_image.rpak"

        pin_to_sibling			DialogHeader
        pin_corner_to_sibling	TOP_RIGHT
        pin_to_sibling_corner	TOP_LEFT
    }

    ContinueFooter
    {
        ControlName				Label
        xpos					-368
        ypos                    -38
        zpos					3
        auto_wide_tocontents 	1
        tall 					36
        labelText				"DEFAULT"
        font					Default_28_ShadowGlow
        enabled					1
        visible					1

		pin_to_sibling			DialogFrame
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	BOTTOM
    }
}