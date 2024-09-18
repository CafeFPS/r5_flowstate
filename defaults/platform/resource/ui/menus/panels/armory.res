"resource/ui/menus/panels/armory.res"
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
        bgcolor_override        "0 0 0 0"
        paintbackground         1
    }

    WeaponCategoryButton0
    {
        ControlName				RuiButton
        InheritProperties		WeaponCategoryButton
        classname               WeaponCategoryButtonClass
        scriptID				0
        xpos                    173
        ypos                    189
        tabPosition             1
        cursorVelocityModifier  0.7

        navDown                 WeaponCategoryButton3
        navRight                WeaponCategoryButton1
    }
    WeaponCategoryButton1
    {
        ControlName				RuiButton
        InheritProperties		WeaponCategoryButton
        classname               WeaponCategoryButtonClass
        scriptID				1
        xpos                    -121
        cursorVelocityModifier  0.7

        navDown                 WeaponCategoryButton4
        navLeft                 WeaponCategoryButton0
        navRight                WeaponCategoryButton2

        pin_to_sibling			WeaponCategoryButton0
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }
    WeaponCategoryButton2
    {
        ControlName				RuiButton
        InheritProperties		WeaponCategoryButton
        classname               WeaponCategoryButtonClass
        scriptID				2
        xpos                    -121
        cursorVelocityModifier  0.7

        navDown                 WeaponCategoryButton5
        navLeft                 WeaponCategoryButton1

        pin_to_sibling			WeaponCategoryButton1
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }
    WeaponCategoryButton3
    {
        ControlName				RuiButton
        InheritProperties		WeaponCategoryButton
        classname               WeaponCategoryButtonClass
        scriptID				3
        ypos                    35
        cursorVelocityModifier  0.7
        ruiArgs
        {
            isNameAtTop         1
        }

        navUp                   WeaponCategoryButton0
        navRight                WeaponCategoryButton4

        pin_to_sibling			WeaponCategoryButton0
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }
    WeaponCategoryButton4
    {
        ControlName				RuiButton
        InheritProperties		WeaponCategoryButton
        classname               WeaponCategoryButtonClass
        scriptID				4
        xpos                    -121
        cursorVelocityModifier  0.7
        ruiArgs
        {
            isNameAtTop         1
        }

        navUp                   WeaponCategoryButton1
        navLeft                 WeaponCategoryButton3
        navRight                WeaponCategoryButton5
        navDown                 MiscCustomizeButton

        pin_to_sibling			WeaponCategoryButton3
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }
    WeaponCategoryButton5
    {
        ControlName				RuiButton
        InheritProperties		WeaponCategoryButton
        classname               WeaponCategoryButtonClass
        scriptID				5
        xpos                    -121
        cursorVelocityModifier  0.7
        ruiArgs
        {
            isNameAtTop         1
        }

        navUp                   WeaponCategoryButton2
        navLeft                 WeaponCategoryButton4

        pin_to_sibling			WeaponCategoryButton4
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }
    MiscCustomizeButton
    {
        ControlName				RuiButton
        InheritProperties		MiscCustomizeButton
        classname               MiscCustomizeButtonClass
        scriptID				6
        ypos                    35
        visible                 0
        cursorVelocityModifier  0.7

        navUp                   WeaponCategoryButton4

        pin_to_sibling			WeaponCategoryButton4
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	BOTTOM
    }
}
