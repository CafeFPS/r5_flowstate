"resource/ui/menus/panels/battlepass_reward_bar.res"
{
	PanelFrame
	{
		ControlName				Label
		xpos					0
		ypos					0
		wide					%100
		tall					%100
		labelText				""
	    bgcolor_override		"70 60 30 128"
		visible					0
		paintbackground			1
        proportionalToParent    1
	}

	InvisiblePageLeftTriggerButton
    {
        ControlName				RuiButton
        wide					1
        tall					1
        visible					1
        rui					    "ui/blank_button.rpak"
    }

	RewardButton1
	{
		ControlName				RuiButton
		classname               RewardButton
		rightClickEvents		1
		scriptId                0
		wide					100
		tall					100
		visible					1
        rui					    "ui/battle_pass_reward_button.rpak"
        sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""
        proportionalToParent    1

		tabPosition 1
        navLeft InvisiblePageLeftTriggerButton
        navRight RewardButton2
	}

	RewardButton2
	{
		ControlName				RuiButton
		classname               RewardButton
		rightClickEvents		1
		scriptId                1
		wide					100
		tall					100
		visible					1
        rui					    "ui/battle_pass_reward_button.rpak"
        sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""
        proportionalToParent    1

        navLeft RewardButton1
        navRight RewardButton3
	}

	RewardButton3
	{
		ControlName				RuiButton
		classname               RewardButton
		rightClickEvents		1
		scriptId                2
		wide					100
		tall					100
		visible					1
        rui					    "ui/battle_pass_reward_button.rpak"
        sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""
        proportionalToParent    1

        navLeft RewardButton2
        navRight RewardButton4
	}

	RewardButton4
	{
		ControlName				RuiButton
		classname               RewardButton
		rightClickEvents		1
		scriptId                3
		wide					100
		tall					100
		visible					1
        rui					    "ui/battle_pass_reward_button.rpak"
        sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""
        proportionalToParent    1

        navLeft RewardButton3
        navRight RewardButton5
	}

	RewardButton5
	{
		ControlName				RuiButton
		classname               RewardButton
		rightClickEvents		1
		scriptId                4
		wide					100
		tall					100
		visible					1
        rui					    "ui/battle_pass_reward_button.rpak"
        sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""
        proportionalToParent    1

        navLeft RewardButton4
        navRight RewardButton6
	}

	RewardButton6
	{
		ControlName				RuiButton
		classname               RewardButton
		rightClickEvents		1
		scriptId                5
		wide					100
		tall					100
		visible					1
        rui					    "ui/battle_pass_reward_button.rpak"
        sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""
        proportionalToParent    1

        navLeft RewardButton5
        navRight RewardButton7
	}

	RewardButton7
	{
		ControlName				RuiButton
		classname               RewardButton
		rightClickEvents		1
		scriptId                6
		wide					100
		tall					100
		visible					1
        rui					    "ui/battle_pass_reward_button.rpak"
        sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""
        proportionalToParent    1

        navLeft RewardButton6
        navRight RewardButton8
	}

	RewardButton8
	{
		ControlName				RuiButton
		classname               RewardButton
		rightClickEvents		1
		scriptId                7
		wide					100
		tall					100
		visible					1
        rui					    "ui/battle_pass_reward_button.rpak"
        sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""
        proportionalToParent    1

        navLeft RewardButton7
        navRight RewardButton9
	}

	RewardButton9
	{
		ControlName				RuiButton
		classname               RewardButton
		rightClickEvents		1
		scriptId                8
		wide					100
		tall					100
		visible					1
        rui					    "ui/battle_pass_reward_button.rpak"
        sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""
        proportionalToParent    1

        navLeft RewardButton8
        navRight RewardButton10
	}

	RewardButton10
	{
		ControlName				RuiButton
		classname               RewardButton
		rightClickEvents		1
		scriptId                9
		wide					100
		tall					100
		visible					1
        rui					    "ui/battle_pass_reward_button.rpak"
        sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""
        proportionalToParent    1

        navLeft RewardButton9
        navRight RewardButton11
	}

	RewardButton11
	{
		ControlName				RuiButton
		classname               RewardButton
		rightClickEvents		1
		scriptId                10
		wide					100
		tall					100
		visible					1
        rui					    "ui/battle_pass_reward_button.rpak"
        sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""
        proportionalToParent    1

        navLeft RewardButton10
        navRight RewardButton12
	}

	RewardButton12
	{
		ControlName				RuiButton
		classname               RewardButton
		rightClickEvents		1
		scriptId                11
		wide					100
		tall					100
		visible					1
        rui					    "ui/battle_pass_reward_button.rpak"
        sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""
        proportionalToParent    1

        navLeft RewardButton11
        navRight RewardButton13
	}

	RewardButton13
	{
		ControlName				RuiButton
		classname               RewardButton
		rightClickEvents		1
		scriptId                12
		wide					100
		tall					100
		visible					1
        rui					    "ui/battle_pass_reward_button.rpak"
        sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""
        proportionalToParent    1

        navLeft RewardButton12
        navRight RewardButton14
	}

	RewardButton14
	{
		ControlName				RuiButton
		classname               RewardButton
		rightClickEvents		1
		scriptId                13
		wide					100
		tall					100
		visible					1
        rui					    "ui/battle_pass_reward_button.rpak"
        sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""
        proportionalToParent    1

        navLeft RewardButton13
        navRight RewardButton15
	}

	RewardButton15
	{
		ControlName				RuiButton
		classname               RewardButton
		rightClickEvents		1
		scriptId                14
		wide					100
		tall					100
		visible					1
        rui					    "ui/battle_pass_reward_button.rpak"
        sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""
        proportionalToParent    1

        navLeft RewardButton14
        navRight InvisiblePageRightTriggerButton
	}

	InvisiblePageRightTriggerButton
    {
        ControlName				RuiButton
        wide					1
        tall					1
        visible					1
        rui					    "ui/blank_button.rpak"
    }

	RewardFooter1
	{
		ControlName				RuiPanel
		classname               RewardFooter
		scriptId                0
		ypos                    106
		wide					96
		tall					32
		visible					1
        rui					    "ui/battle_pass_reward_footer.rpak"
        proportionalToParent    1
	}

	RewardFooter2
	{
		ControlName				RuiPanel
		classname               RewardFooter
		scriptId                1
		ypos                    106
		wide					96
		tall					32
		visible					1
        rui					    "ui/battle_pass_reward_footer.rpak"
        proportionalToParent    1
	}

	RewardFooter3
	{
		ControlName				RuiPanel
		classname               RewardFooter
		scriptId                2
		ypos                    106
		wide					96
		tall					32
		visible					1
        rui					    "ui/battle_pass_reward_footer.rpak"
        proportionalToParent    1
	}

	RewardFooter4
	{
		ControlName				RuiPanel
		classname               RewardFooter
		scriptId                3
		ypos                    106
		wide					96
		tall					32
		visible					1
        rui					    "ui/battle_pass_reward_footer.rpak"
        proportionalToParent    1
	}

	RewardFooter5
	{
		ControlName				RuiPanel
		classname               RewardFooter
		scriptId                4
		ypos                    106
		wide					96
		tall					32
		visible					1
        rui					    "ui/battle_pass_reward_footer.rpak"
        proportionalToParent    1
	}

	RewardFooter6
	{
		ControlName				RuiPanel
		classname               RewardFooter
		scriptId                5
		ypos                    106
		wide					96
		tall					32
		visible					1
        rui					    "ui/battle_pass_reward_footer.rpak"
        proportionalToParent    1
	}

	RewardFooter7
	{
		ControlName				RuiPanel
		classname               RewardFooter
		scriptId                6
		ypos                    106
		wide					96
		tall					32
		visible					1
        rui					    "ui/battle_pass_reward_footer.rpak"
        proportionalToParent    1
	}

	RewardFooter8
	{
		ControlName				RuiPanel
		classname               RewardFooter
		scriptId                7
		ypos                    106
		wide					96
		tall					32
		visible					1
        rui					    "ui/battle_pass_reward_footer.rpak"
        proportionalToParent    1
	}

	RewardFooter9
	{
		ControlName				RuiPanel
		classname               RewardFooter
		scriptId                8
		ypos                    106
		wide					96
		tall					32
		visible					1
        rui					    "ui/battle_pass_reward_footer.rpak"
        proportionalToParent    1
	}

	RewardFooter10
	{
		ControlName				RuiPanel
		classname               RewardFooter
		scriptId                9
		ypos                    106
		wide					96
		tall					32
		visible					1
        rui					    "ui/battle_pass_reward_footer.rpak"
        proportionalToParent    1
	}

	RewardFooter11
	{
		ControlName				RuiPanel
		classname               RewardFooter
		scriptId                9
		ypos                    106
		wide					96
		tall					32
		visible					1
        rui					    "ui/battle_pass_reward_footer.rpak"
        proportionalToParent    1
	}

	RewardFooter12
	{
		ControlName				RuiPanel
		classname               RewardFooter
		scriptId                9
		ypos                    106
		wide					96
		tall					32
		visible					1
        rui					    "ui/battle_pass_reward_footer.rpak"
        proportionalToParent    1
	}

	RewardFooter13
	{
		ControlName				RuiPanel
		classname               RewardFooter
		scriptId                9
		ypos                    106
		wide					96
		tall					32
		visible					1
        rui					    "ui/battle_pass_reward_footer.rpak"
        proportionalToParent    1
	}

	RewardFooter14
	{
		ControlName				RuiPanel
		classname               RewardFooter
		scriptId                9
		ypos                    106
		wide					96
		tall					32
		visible					1
        rui					    "ui/battle_pass_reward_footer.rpak"
        proportionalToParent    1
	}

	RewardFooter15
	{
		ControlName				RuiPanel
		classname               RewardFooter
		scriptId                9
		ypos                    106
		wide					96
		tall					32
		visible					1
        rui					    "ui/battle_pass_reward_footer.rpak"
        proportionalToParent    1
	}
}
