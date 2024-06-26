"resource/ui/menus/panels/store_characters.res"
{
    PanelFrame
    {
		ControlName				Label
		xpos					0
		ypos					0
		wide					%100
		tall					%100
		labelText				""
		visible				    0
        bgcolor_override        "0 0 0 255"
        paintbackground         1

        proportionalToParent    1
    }

    CharacterSelectInfo
    {
        ControlName		        RuiPanel
        xpos                    -150
        ypos                    0
        wide                    740
        tall                    153
        visible			        1
        rui                     "ui/character_select_info.rpak"

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }

    CharacterButton0
    {
        ControlName				RuiButton
        InheritProperties		StoreCharacterButton
        classname               CharacterButtonClass
        scriptID				0
        xpos                    0
        ypos                    234
        visible                 0
        cursorVelocityModifier  0.7

        tabPosition             1

        navRight                CharacterButton1
    }
    CharacterButton1
    {
        ControlName				RuiButton
        InheritProperties		StoreCharacterButton
        classname               CharacterButtonClass
        scriptID				1
        xpos                    -182
        visible					0
        cursorVelocityModifier  0.7

        pin_to_sibling			CharacterButton0
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT //TOP_RIGHT

        navRight                CharacterButton2
        navLeft                 CharacterButton0
    }
    CharacterButton2
    {
        ControlName				RuiButton
        InheritProperties		StoreCharacterButton
        classname               CharacterButtonClass
        scriptID				2
        xpos                    -182
        visible					0
        cursorVelocityModifier  0.7

        pin_to_sibling			CharacterButton1
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT

        navRight                CharacterButton3
        navLeft                 CharacterButton1
    }
    CharacterButton3
    {
        ControlName				RuiButton
        InheritProperties		StoreCharacterButton
        classname               CharacterButtonClass
        scriptID				3
        xpos                    -182
        visible					0
        cursorVelocityModifier  0.7

        pin_to_sibling			CharacterButton2
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT

        navRight                CharacterButton4
        navLeft                 CharacterButton2
    }
    CharacterButton4
    {
        ControlName				RuiButton
        InheritProperties		StoreCharacterButton
        classname               CharacterButtonClass
        scriptID				4
        xpos                    -182
        visible					0
        cursorVelocityModifier  0.7

        pin_to_sibling			CharacterButton3
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT

        navRight                CharacterButton5
        navLeft                 CharacterButton3
    }
    CharacterButton5
    {
        ControlName				RuiButton
        InheritProperties		StoreCharacterButton
        classname               CharacterButtonClass
        scriptID				5
        xpos                    -48
        visible					0
        cursorVelocityModifier  0.7

        pin_to_sibling			CharacterButton0
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT

        navRight                CharacterButton6
        navLeft                 CharacterButton4
    }
    CharacterButton6
    {
        ControlName				RuiButton
        InheritProperties		StoreCharacterButton
        classname               CharacterButtonClass
        scriptID				6
        xpos                    -121
        visible					0
        cursorVelocityModifier  0.7

        pin_to_sibling			CharacterButton5
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT

        navRight                CharacterButton7
        navLeft                 CharacterButton5
    }
    CharacterButton7
    {
        ControlName				RuiButton
        InheritProperties		StoreCharacterButton
        classname               CharacterButtonClass
        scriptID				7
        xpos                    -121
        visible					0
        cursorVelocityModifier  0.7

        pin_to_sibling			CharacterButton6
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }
    CharacterButton8
    {
        ControlName				RuiButton
        InheritProperties		StoreCharacterButton
        classname               CharacterButtonClass
        scriptID				8
        xpos                    -121
        visible					0
        cursorVelocityModifier  0.7

        pin_to_sibling			CharacterButton7
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }
    CharacterButton9
    {
        ControlName				RuiButton
        InheritProperties		StoreCharacterButton
        classname               CharacterButtonClass
        scriptID				9
        xpos                    -121
        visible					0
        cursorVelocityModifier  0.7

        pin_to_sibling			CharacterButton8
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }
    CharacterButton10
    {
        ControlName             RuiButton
        InheritProperties       StoreCharacterButton
        classname               CharacterButtonClass
        scriptID                10
        xpos                    -48
        visible                 0
        cursorVelocityModifier  0.7

        pin_to_sibling			CharacterButton5
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }
    CharacterButton11
    {
        ControlName             RuiButton
        InheritProperties       StoreCharacterButton
        classname               CharacterButtonClass
        scriptID                11
        xpos                    -121
        visible                 0
        cursorVelocityModifier  0.7

        pin_to_sibling          CharacterButton10
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }
    CharacterButton12
    {
        ControlName             RuiButton
        InheritProperties       StoreCharacterButton
        classname               CharacterButtonClass
        scriptID                12
        xpos                    -121
        visible                 0
        cursorVelocityModifier  0.7

        pin_to_sibling          CharacterButton11
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }
    CharacterButton13
    {
        ControlName             RuiButton
        InheritProperties       StoreCharacterButton
        classname               CharacterButtonClass
        scriptID                13
        xpos                    -121
        visible                 0
        cursorVelocityModifier  0.7

        pin_to_sibling          CharacterButton12
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }
    CharacterButton14
    {
        ControlName             RuiButton
        InheritProperties       StoreCharacterButton
        classname               CharacterButtonClass
        scriptID                14
        xpos                    -121
        visible                 0
        cursorVelocityModifier  0.7

        pin_to_sibling          CharacterButton13
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }
    CharacterButton15
    {
        ControlName             RuiButton
        InheritProperties       StoreCharacterButton
        classname               CharacterButtonClass
        scriptID                15
        xpos                    -48
        visible                 0
        cursorVelocityModifier  0.7

        pin_to_sibling          CharacterButton10
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }
    CharacterButton16
    {
        ControlName             RuiButton
        InheritProperties       StoreCharacterButton
        classname               CharacterButtonClass
        scriptID                16
        xpos                    -121
        visible                 0
        cursorVelocityModifier  0.7

        pin_to_sibling          CharacterButton15
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   TOP_LEFT
    }
    CharacterButton17
    {
        ControlName             RuiButton
        InheritProperties       StoreCharacterButton
        classname               CharacterButtonClass
        scriptID                17
        xpos                    -121
        visible                 0
        cursorVelocityModifier  0.7

        pin_to_sibling          CharacterButton16
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   TOP_LEFT
    }
    CharacterButton18
    {
        ControlName             RuiButton
        InheritProperties       StoreCharacterButton
        classname               CharacterButtonClass
        scriptID                18
        xpos                    -121
        visible                 0
        cursorVelocityModifier  0.7

        pin_to_sibling          CharacterButton17
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   TOP_LEFT
    }
    CharacterButton19
    {
        ControlName             RuiButton
        InheritProperties       StoreCharacterButton
        classname               CharacterButtonClass
        scriptID                19
        xpos                    -121
        visible                 0
        cursorVelocityModifier  0.7

        pin_to_sibling          CharacterButton18
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   TOP_LEFT
    }

    AllLegendsPanel
    {
        ControlName				RuiPanel
        rui                     "ui/all_legends.rpak"
        ypos					-64
        wide					%100
        tall					%100
        visible					0
        zpos                    10

        proportionalToParent    1

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP
    }
}