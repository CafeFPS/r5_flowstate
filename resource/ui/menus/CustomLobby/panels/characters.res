"resource/ui/menus/panels/characters.res"
{
    PanelFrame
    {
		ControlName				Label
		xpos					0
		ypos					0
		wide					%100
		tall					%100
		labelText				""
		visible				    1
        bgcolor_override        "0 0 0 0"
        paintbackground         1

        proportionalToParent    1
    }

    //ActionButton
    //{
    //    ControlName				RuiButton
    //    classname               "MenuButton"
    //    wide					280
    //    tall					80
    //    xpos                    -28
    //    ypos                    -25
    //    rui                     "ui/generic_loot_button.rpak"
    //    labelText               ""
    //    visible					0
    //    cursorVelocityModifier  0.7

    //    pin_to_sibling			PanelFrame
    //    pin_corner_to_sibling	BOTTOM_LEFT
    //    pin_to_sibling_corner	BOTTOM_LEFT
    //}

    ActionLabel
    {
        ControlName				Label
        auto_wide_tocontents 	1
        auto_tall_tocontents 	1
        visible					0
        labelText				"This is a Label"
        fgcolor_override		"220 220 220 255"
        fontHeight              36
        ypos                    420
        xpos                    -178

        pin_to_sibling			CharacterSelectInfo
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

    CharacterSelectInfo
    {
        ControlName		        RuiPanel
        xpos                    -150
        ypos                    -120
        wide                    740
        tall                    153
        visible			        1
        rui                     "ui/character_select_info.rpak"

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    Anchor
    {
        ControlName             Label

        labelText               ""
        xpos                    428 //500
        ypos                    300
        wide					50
        tall                    50
        //bgcolor_override		"0 255 0 100"
        //paintbackground			1
    }

    CharacterButton0
    {
        ControlName				RuiButton
        InheritProperties		LobbyCharacterButton
        tabPosition             1
    }
    CharacterButton1
    {
        ControlName				RuiButton
        InheritProperties		LobbyCharacterButton
    }
    CharacterButton2
    {
        ControlName				RuiButton
        InheritProperties		LobbyCharacterButton
    }
    CharacterButton3
    {
        ControlName				RuiButton
        InheritProperties		LobbyCharacterButton
    }
    CharacterButton4
    {
        ControlName				RuiButton
        InheritProperties		LobbyCharacterButton
    }
    CharacterButton5
    {
        ControlName				RuiButton
        InheritProperties		LobbyCharacterButton
    }
    CharacterButton6
    {
        ControlName				RuiButton
        InheritProperties		LobbyCharacterButton
    }
    CharacterButton7
    {
        ControlName				RuiButton
        InheritProperties		LobbyCharacterButton
    }
    CharacterButton8
    {
        ControlName				RuiButton
        InheritProperties		LobbyCharacterButton
    }
    CharacterButton9
    {
        ControlName				RuiButton
        InheritProperties		LobbyCharacterButton
    }
    CharacterButton10
    {
        ControlName				RuiButton
        InheritProperties		LobbyCharacterButton
    }
    CharacterButton11
    {
        ControlName				RuiButton
        InheritProperties		LobbyCharacterButton
    }
    CharacterButton12
    {
        ControlName             RuiButton
        InheritProperties       LobbyCharacterButton
    }
    CharacterButton13
    {
        ControlName             RuiButton
        InheritProperties       LobbyCharacterButton
    }
    CharacterButton14
    {
        ControlName             RuiButton
        InheritProperties       LobbyCharacterButton
    }
    CharacterButton15
    {
        ControlName             RuiButton
        InheritProperties       LobbyCharacterButton
    }
    CharacterButton16
    {
        ControlName             RuiButton
        InheritProperties       LobbyCharacterButton
    }
    CharacterButton17
    {
        ControlName             RuiButton
        InheritProperties       LobbyCharacterButton
    }
    CharacterButton18
    {
        ControlName             RuiButton
        InheritProperties       LobbyCharacterButton
    }
    CharacterButton19
    {
        ControlName             RuiButton
        InheritProperties       LobbyCharacterButton
    }
    CharacterButton20
    {
        ControlName             RuiButton
        InheritProperties       LobbyCharacterButton
    }
    CharacterButton21
    {
        ControlName             RuiButton
        InheritProperties       LobbyCharacterButton
    }
    CharacterButton22
    {
        ControlName             RuiButton
        InheritProperties       LobbyCharacterButton
    }
    CharacterButton23
    {
        ControlName             RuiButton
        InheritProperties       LobbyCharacterButton
    }
    CharacterButton24
    {
        ControlName             RuiButton
        InheritProperties       LobbyCharacterButton
    }
    CharacterButton25
    {
        ControlName             RuiButton
        InheritProperties       LobbyCharacterButton
    }
    CharacterButton26
    {
        ControlName             RuiButton
        InheritProperties       LobbyCharacterButton
    }
    CharacterButton27
    {
        ControlName             RuiButton
        InheritProperties       LobbyCharacterButton
    }
    CharacterButton28
    {
        ControlName             RuiButton
        InheritProperties       LobbyCharacterButton
    }
    CharacterButton29
    {
        ControlName             RuiButton
        InheritProperties       LobbyCharacterButton
    }
}

