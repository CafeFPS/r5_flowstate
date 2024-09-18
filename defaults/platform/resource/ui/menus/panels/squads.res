resource/ui/menus/panels/squads.res
{
    ToolTip
    {
        ControlName				RuiPanel
        InheritProperties       ToolTip
    }

    ScreenFrame
    {
        ControlName				ImagePanel
        xpos					0
        ypos					0
        wide					%100
        tall					%100
        visible					0
        enabled 				1
        drawColor				"0 0 0 0"
    }

    GCard1
    {
        ControlName             RuiPanel
        xpos					100
        ypos					0
        wide 					502
        tall					866
        rui 					"ui/gladiator_card_squadscreen.rpak"
        visible					1
        zpos					5

        pin_to_sibling			GCard0
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	LEFT
    }

    GCard2
    {
        ControlName             RuiPanel
        xpos					100
        ypos					0
        wide 					502
        tall					866
        rui 					"ui/gladiator_card_squadscreen.rpak"
        visible					1
        zpos					5

        pin_to_sibling			GCard0
        pin_corner_to_sibling	LEFT
        pin_to_sibling_corner	RIGHT
    }

    GCard0
    {
        ControlName             RuiPanel
        xpos					0
        ypos					-30
        wide 					502
        tall					866
        rui 					"ui/gladiator_card_squadscreen.rpak"
        visible					1
        zpos					5

        pin_to_sibling			ScreenFrame
        pin_corner_to_sibling	CENTER
        pin_to_sibling_corner	CENTER
    }

    GCardOverlay1
    {
        ControlName             RuiButton

        wide					500
        tall					680

        scriptID                1

        rui                     "ui/basic_image.rpak"
        ruiArgs
        {

                basicImageAlpha     0.0
        }

        xpos                    0
        ypos                    0
        zpos                    100

        rightClickEvents        1

        visible                 1
        enabled                 1

        pin_to_sibling          GCard1
        pin_corner_to_sibling   CENTER
        pin_to_sibling_corner   CENTER
    }

    GCardOverlay2
    {
        ControlName             RuiButton

        wide					500
        tall					680

        scriptID                2

        rui                     "ui/basic_image.rpak"
        ruiArgs
        {

                basicImageAlpha     0.0
        }


        xpos                    0
        ypos                    0
        zpos                    100

        rightClickEvents        1

        visible                 1
        enabled                 1

        pin_to_sibling          GCard2
        pin_corner_to_sibling   CENTER
        pin_to_sibling_corner   CENTER
    }

    TeammateMute1
    {
        ControlName             RuiButton

        wide					64
        tall					64

        scriptID                1

        rui                     "ui/mute_button.rpak"

        xpos                    5
        ypos                    -15
        zpos                    100

        visible                 0
        enabled                 1
        cursorVelocityModifier  0.6

        tabPosition             1
        navLeft                 TeammateReport2
        navRight                TeammateMutePing1

        pin_to_sibling          GCard1
        pin_corner_to_sibling   BOTTOM_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT
    }

    TeammateMutePing1
    {
        ControlName             RuiButton

        wide					64
        tall					64

        scriptID                1

        rui                     "ui/mute_button.rpak"

        xpos                    20
        ypos                    0
        zpos                    100

        visible                 0
        enabled                 1
        cursorVelocityModifier  0.6

        navLeft                TeammateMute1
        navRight               TeammateMuteChat1

        pin_to_sibling          TeammateMute1
        pin_corner_to_sibling   BOTTOM_LEFT
        pin_to_sibling_corner   BOTTOM_RIGHT
    }

    TeammateMuteChat1
    {
        ControlName             RuiButton

        wide					64
        tall					64

        scriptID                1

        rui                     "ui/mute_button.rpak"

        xpos                    20
        ypos                    0
        zpos                    100

        visible                 0
        enabled                 1
        cursorVelocityModifier  0.6

        navLeft                 TeammateMutePing1
        navRight                TeammateReport1

        pin_to_sibling          TeammateMutePing1
        pin_corner_to_sibling   BOTTOM_LEFT
        pin_to_sibling_corner   BOTTOM_RIGHT
    }

    TeammateReport1
    {
        ControlName             RuiButton

        wide					64
        tall					64

        scriptID                1

        rui                     "ui/mute_button.rpak"

        xpos                    20
        ypos                    0
        zpos                    100

        visible                 0
        enabled                 1
        cursorVelocityModifier  0.6

        navLeft                 TeammateMuteChat1

        pin_to_sibling          TeammateMuteChat1
        pin_corner_to_sibling   BOTTOM_LEFT
        pin_to_sibling_corner   BOTTOM_RIGHT
    }

    TeammateInvite1
    {
        ControlName             RuiButton

        wide					150
        tall					150

        scriptID                1

        rui                     "ui/invite_button.rpak"

        xpos                    0
        ypos                    -85
        zpos                    100

        visible                 0
        enabled                 1
        cursorVelocityModifier  0.6

        navLeft                 TeammateReport1

        pin_to_sibling          GCard1
        pin_corner_to_sibling   CENTER
        pin_to_sibling_corner   BOTTOM_RIGHT
    }

    TeammateDisconnected1
    {
        ControlName             RuiPanel

        wide					232
        tall					64

        scriptID                1

        rui                     "ui/disconnected_widget.rpak"

        xpos                    0
        ypos                    0
        zpos                    100

        visible                 0
        enabled                 1
        cursorVelocityModifier  0.6

        pin_to_sibling          TeammateMute1
        pin_corner_to_sibling   LEFT
        pin_to_sibling_corner   LEFT
    }

    TeammateMute2
    {
        ControlName             RuiButton

        wide					64
        tall					64

        scriptID                2

        rui                     "ui/mute_button.rpak"

        xpos                    5
        ypos                    -15
        zpos                    100

        visible                 0
        enabled                 1
        cursorVelocityModifier  0.6

        navRight                TeammateMutePing2

        pin_to_sibling          GCard2
        pin_corner_to_sibling   BOTTOM_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT
    }

    TeammateMutePing2
    {
        ControlName             RuiButton

        wide					64
        tall					64

        scriptID                2

        rui                     "ui/mute_button.rpak"

        xpos                    20
        ypos                    0
        zpos                    100

        visible                 0
        enabled                 1
        cursorVelocityModifier  0.6

        navLeft                 TeammateMute2
        navRight                TeammateMuteChat2

        pin_to_sibling          TeammateMute2
        pin_corner_to_sibling   BOTTOM_LEFT
        pin_to_sibling_corner   BOTTOM_RIGHT
    }

    TeammateMuteChat2
    {
        ControlName             RuiButton

        wide					64
        tall					64

        scriptID                2

        rui                     "ui/mute_button.rpak"

        xpos                    20
        ypos                    0
        zpos                    100

        visible                 0
        enabled                 1
        cursorVelocityModifier  0.6

        navRight                TeammateReport2
        navLeft                 TeammateMutePing2

        pin_to_sibling          TeammateMutePing2
        pin_corner_to_sibling   BOTTOM_LEFT
        pin_to_sibling_corner   BOTTOM_RIGHT
    }

    TeammateReport2
    {
        ControlName             RuiButton

        wide					64
        tall					64

        scriptID                2

        rui                     "ui/mute_button.rpak"

        xpos                    20
        ypos                    0
        zpos                    100

        visible                 0
        enabled                 1
        cursorVelocityModifier  0.6

        navLeft                 TeammateMuteChat2
        navRight                TeammateInvite2

        pin_to_sibling          TeammateMuteChat2
        pin_corner_to_sibling   BOTTOM_LEFT
        pin_to_sibling_corner   BOTTOM_RIGHT
    }

    TeammateInvite2
    {
        ControlName             RuiButton

        wide					150
        tall					150

        scriptID                2

        rui                     "ui/invite_button.rpak"

        xpos                    0
        ypos                    -85
        zpos                    100

        visible                 0
        enabled                 1
        cursorVelocityModifier  0.6

        navRight                TeammateMute1
        navLeft                 TeammateReport2

        pin_to_sibling          GCard2
        pin_corner_to_sibling   CENTER
        pin_to_sibling_corner   BOTTOM_RIGHT
    }

    TeammateDisconnected2
    {
        ControlName             RuiPanel

        wide					232
        tall					64

        scriptID                1

        rui                     "ui/disconnected_widget.rpak"

        xpos                    0
        ypos                    0
        zpos                    100

        visible                 0
        enabled                 1
        cursorVelocityModifier  0.6

        pin_to_sibling          TeammateMute2
        pin_corner_to_sibling   LEFT
        pin_to_sibling_corner   LEFT
    }
}
