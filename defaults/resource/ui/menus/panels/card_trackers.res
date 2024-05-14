"resource/ui/menus/panels/card_trackers.res"
{
	PanelFrame
	{
		ControlName				Label
		xpos					0
		ypos					0
		wide					%100
		tall					%100
		labelText				""
//		bgcolor_override		"70 70 70 255"
//		visible					1
//		paintbackground			1

        proportionalToParent    1
	}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    TrackerList
    {
        ControlName				GridButtonListPanel
        xpos                    0
        ypos                    0
        columns                 1
        rows                    8
        buttonSpacing           6
        scrollbarSpacing        6
        scrollbarOnLeft         0
        visible					1
        tabPosition             1

        ButtonSettings
        {
            rui                     "ui/card_tracker_button.rpak"
            clipRui                 1
            wide					470
            tall					70
            cursorVelocityModifier  0.7
            rightClickEvents		1
            doubleClickEvents       1
            sound_focus             "UI_Menu_Focus_Small"
            sound_accept            ""
            sound_deny              ""
        }
    }
}