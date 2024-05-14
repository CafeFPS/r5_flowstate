"resource/ui/menus/panels/establish_user.res"
{
    Screen
    {
        ControlName				Label
        wide			        %100
        tall			        %100
        labelText				""
        visible					0
    }

    PinFrame
    {
        ControlName				Label
        xpos                    -190
        ypos					-12
        wide					940
        tall					288
        labelText				""
        //bgcolor_override 		"210 170 0 255"
        //paintbackground 		1
        //visible				1

        pin_to_sibling			Screen
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	CENTER
    }

    SignInStatus
    {
        ControlName				Label
        wide 					674
        auto_tall_tocontents 	1
        labelText				""
		font					Default_28_ShadowGlow [!$JAPANESE && !$TCHINESE]
		font					Default_34_ShadowGlow [$JAPANESE || $TCHINESE]
        textAlignment			center
        allcaps					1
        visible					0

        pin_to_sibling			PinFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP
    }

///////////////////////////////

    ErrorDisplay
    {
        ControlName				CNestedPanel
        wide					%100
        tall					%100
        visible					1
        controlSettingsFile		"resource/ui/menus/panels/establish_user_error.res"
    }
}