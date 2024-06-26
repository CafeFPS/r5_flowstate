resource/ui/menus/panels/ranked_rewards.res
{
    ScreenFrame
    {
        ControlName				ImagePanel
        xpos					0
        ypos					0
        wide					%100
        tall					487
        visible					1
        enabled 				1
        scaleImage				1
        image					"vgui/HUD/white"
        drawColor				"0 0 0 0"
    }

    InfoPane0
    {
        ControlName				RuiPanel
        wide					181
        tall					487
        zpos                    10
        ypos                    0
        xpos                    -47
        rui                     "ui/ranked_info_box.rpak"
        labelText               ""
        visible					1
        scriptID                0
        classname               RankedInfoPanel

        proportionalToParent    1

        pin_to_sibling			ScreenFrame
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

    InfoPane1
    {
        ControlName				RuiPanel
        wide					181
        tall					487
        zpos                    10
        ypos                    0
        xpos                    -255
        rui                     "ui/ranked_info_box.rpak"
        labelText               ""
        visible					1
        scriptID                1
        classname               RankedInfoPanel

        proportionalToParent    1

        pin_to_sibling			ScreenFrame
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

    InfoPane2
    {
        ControlName				RuiPanel
        wide					284
        tall					487
        zpos                    10
        ypos                    0
        xpos                    -458
        rui                     "ui/ranked_info_box.rpak"
        labelText               ""
        visible					1
        scriptID                2
        classname               RankedInfoPanel

        proportionalToParent    1

        pin_to_sibling			ScreenFrame
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

    InfoPane3
    {
        ControlName				RuiPanel
        wide					284
        tall					487
        zpos                    10
        ypos                    0
        xpos                    -766
        rui                     "ui/ranked_info_box.rpak"
        labelText               ""
        visible					1
        scriptID                3
        classname               RankedInfoPanel

        proportionalToParent    1

        pin_to_sibling			ScreenFrame
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

    InfoPane4
    {
        ControlName				RuiPanel
        wide					386
        tall					487
        zpos                    10
        ypos                    0
        xpos                    -1075
        rui                     "ui/ranked_info_box.rpak"
        labelText               ""
        visible					1
        scriptID                4
        classname               RankedInfoPanel

        proportionalToParent    1

        pin_to_sibling			ScreenFrame
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

    InfoPane5
    {
        ControlName				RuiPanel
        wide					386
        tall					487
        zpos                    10
        ypos                    0
        xpos                    -1486
        rui                     "ui/ranked_info_box.rpak"
        labelText               ""
        visible					1
        scriptID                5
        classname               RankedInfoPanel

        proportionalToParent    1

        pin_to_sibling			ScreenFrame
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

    RewardButton0_0
    {
        ControlName				RuiButton
        classname               RewardButton
        rightClickEvents		1
        scriptId                0_0
        wide					72
        tall					72
        visible					1
        rui					    "ui/ranked_reward_button.rpak"
        sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""
        proportionalToParent    1
        xpos                    0
        ypos                    -20
        zpos                    20

        pin_to_sibling			InfoPane0
        pin_corner_to_sibling	BOTTOM
        pin_to_sibling_corner	BOTTOM
    }

    RewardButton1_0
    {
        ControlName				RuiButton
        classname               RewardButton
        rightClickEvents		1
        scriptId                1_0
        wide					72
        tall					72
        visible					1
        rui					    "ui/ranked_reward_button.rpak"
        sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""
        proportionalToParent    1
        xpos                    0
        ypos                    -20
        zpos                    20

        pin_to_sibling			InfoPane1
        pin_corner_to_sibling	BOTTOM
        pin_to_sibling_corner	BOTTOM
    }

    RewardButton2_0
    {
        ControlName				RuiButton
        classname               RewardButton
        rightClickEvents		1
        scriptId                2_0
        wide					72
        tall					72
        visible					1
        rui					    "ui/ranked_reward_button.rpak"
        sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""
        proportionalToParent    1
        xpos                    -10
        ypos                    -20
        zpos                    20

        pin_to_sibling			InfoPane2
        pin_corner_to_sibling	BOTTOM_RIGHT
        pin_to_sibling_corner	BOTTOM
    }

    RewardButton2_1
    {
        ControlName				RuiButton
        classname               RewardButton
        rightClickEvents		1
        scriptId                2_1
        wide					72
        tall					72
        visible					1
        rui					    "ui/ranked_reward_button.rpak"
        sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""
        proportionalToParent    1
        xpos                    10
        ypos                    -20
        zpos                    20

        pin_to_sibling			InfoPane2
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	BOTTOM
    }

    RewardButton3_0
    {
        ControlName				RuiButton
        classname               RewardButton
        rightClickEvents		1
        scriptId                3_0
        wide					72
        tall					72
        visible					1
        rui					    "ui/ranked_reward_button.rpak"
        sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""
        proportionalToParent    1
        xpos                    -10
        ypos                    -20
        zpos                    20

        pin_to_sibling			InfoPane3
        pin_corner_to_sibling	BOTTOM_RIGHT
        pin_to_sibling_corner	BOTTOM
    }

    RewardButton3_1
    {
        ControlName				RuiButton
        classname               RewardButton
        rightClickEvents		1
        scriptId                3_1
        wide					72
        tall					72
        visible					1
        rui					    "ui/ranked_reward_button.rpak"
        sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""
        proportionalToParent    1
        xpos                    10
        ypos                    -20
        zpos                    20

        pin_to_sibling			InfoPane3
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	BOTTOM
    }

    RewardButton4_0
    {
        ControlName				RuiButton
        classname               RewardButton
        rightClickEvents		1
        scriptId                4_0
        wide					72
        tall					72
        visible					1
        rui					    "ui/ranked_reward_button.rpak"
        sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""
        proportionalToParent    1
        xpos                    20
        ypos                    0
        zpos                    20

        pin_to_sibling			RewardButton4_1
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	LEFT
    }

    RewardButton4_1
    {
        ControlName				RuiButton
        classname               RewardButton
        rightClickEvents		1
        scriptId                4_1
        wide					72
        tall					72
        visible					1
        rui					    "ui/ranked_reward_button.rpak"
        sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""
        proportionalToParent    1
        xpos                    0
        ypos                    -20
        zpos                    20

        pin_to_sibling			InfoPane4
        pin_corner_to_sibling	BOTTOM
        pin_to_sibling_corner	BOTTOM
    }

    RewardButton4_2
    {
        ControlName				RuiButton
        classname               RewardButton
        rightClickEvents		1
        scriptId                4_2
        wide					72
        tall					72
        visible					1
        rui					    "ui/ranked_reward_button.rpak"
        sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""
        proportionalToParent    1
        xpos                    20
        ypos                    0
        zpos                    20

        pin_to_sibling			RewardButton4_1
        pin_corner_to_sibling	LEFT
        pin_to_sibling_corner	RIGHT
    }

    RewardButton5_0
    {
        ControlName				RuiButton
        classname               RewardButton
        rightClickEvents		1
        scriptId                5_0
        wide					72
        tall					72
        visible					1
        rui					    "ui/ranked_reward_button.rpak"
        sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""
        proportionalToParent    1
        xpos                    20
        ypos                    0
        zpos                    20

        pin_to_sibling			RewardButton5_1
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	LEFT
    }

    RewardButton5_1
    {
        ControlName				RuiButton
        classname               RewardButton
        rightClickEvents		1
        scriptId                5_1
        wide					72
        tall					72
        visible					1
        rui					    "ui/ranked_reward_button.rpak"
        sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""
        proportionalToParent    1
        xpos                    0
        ypos                    -20
        zpos                    20

        pin_to_sibling			InfoPane5
        pin_corner_to_sibling	BOTTOM
        pin_to_sibling_corner	BOTTOM
    }

    RewardButton5_2
    {
        ControlName				RuiButton
        classname               RewardButton
        rightClickEvents		1
        scriptId                5_2
        wide					72
        tall					72
        visible					1
        rui					    "ui/ranked_reward_button.rpak"
        sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""
        proportionalToParent    1
        xpos                    20
        ypos                    0
        zpos                    20

        pin_to_sibling			RewardButton5_1
        pin_corner_to_sibling	LEFT
        pin_to_sibling_corner	RIGHT
    }
}