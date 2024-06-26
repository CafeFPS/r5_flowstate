"resource/ui/menus/panels/weapon_skins.res"
{
	PanelFrame
	{
		ControlName				Label
		xpos					0
		ypos					0
		wide					%100
		tall					%100
		labelText				""
		bgcolor_override		"70 70 70 255"
		visible					0
		paintbackground			1
		proportionalToParent    1
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    WeaponName
    {
        ControlName				RuiPanel
        xpos					92
        ypos					16
        wide					900
        tall					78
        rui                     "ui/weapon_name.rpak"
    }

    Owned
    {
        ControlName             RuiPanel
        xpos                    92
        ypos                    100
        wide                    550
        tall                    33
        rui                     "ui/character_items_header.rpak"
    }

    WeaponSkinList
    {
        ControlName				GridButtonListPanel
        xpos                    92
        ypos                    151
        columns                 1
        rows                    11
        buttonSpacing           6
        scrollbarSpacing        6
        scrollbarOnLeft         0
        visible					1
        tabPosition             1
        selectOnDpadNav         1

        ButtonSettings
        {
            rui                     "ui/generic_item_button.rpak"
            clipRui                 1
            wide					350
            tall					50
            cursorVelocityModifier  0.7
            rightClickEvents		1
            doubleClickEvents       1
            sound_focus             "UI_Menu_Focus_Small"
            sound_accept            ""
            sound_deny              ""
        }
    }

//    RefFrame
//    {
//        ControlName				Label
//        xpos					364 //637
//        ypos					151
//        wide					1095
//        tall					514
//        labelText				""
//        bgcolor_override		"0 0 0 80"
//        visible					1
//        paintbackground			1
//    }

    ModelRotateMouseCapture
    {
        ControlName				CMouseMovementCapturePanel
        xpos                    610
        ypos                    0
        wide                    1340
        tall                    %100
    }


    ActionButton
    {
        ControlName				RuiButton
        classname               "MenuButton"
        wide					280
        tall					110
        xpos                    -28
        ypos                    -25
        rui                     "ui/generic_loot_button.rpak"
        labelText               ""
        visible					1
        cursorVelocityModifier  0.7

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	BOTTOM_RIGHT
        pin_to_sibling_corner	BOTTOM_RIGHT
    }


    CharmsButton
    {
        ControlName				RuiButton
         classname               "MenuButton"
         wide					280
         tall					110
         xpos                    -28
         ypos                    -25
         rui                     "ui/generic_loot_button.rpak"
         labelText               ""
         visible					0
         enabled                 0

         cursorVelocityModifier  0.7

         pin_to_sibling			PanelFrame
         pin_corner_to_sibling	TOP_RIGHT
         pin_to_sibling_corner	TOP_RIGHT
     }
 }