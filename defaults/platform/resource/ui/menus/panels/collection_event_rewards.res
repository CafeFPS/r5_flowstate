"resource/ui/menus/panels/collection_event_rewards.res"
{
	PanelFrame
	{
		ControlName				Label
		xpos					0
		ypos					0
		wide					%100
		tall					%100
		labelText				""
	    bgcolor_override		"70 60 30 50"
		visible					0
		paintbackground			1
	}

	RewardBarBacker
	{
        ControlName				RuiPanel
        xpos					0
        ypos					0
        wide					1163
        tall					240
        rui					    "ui/collection_event_reward_bar.rpak"
        visible					1

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
	}

	RewardButton01x01
	{
		ControlName				RuiButton
		classname               RewardButton
		rightClickEvents		1
		scriptId                0
		wide					95
		tall					95
		visible					0
        rui					    "ui/collection_event_reward_button.rpak"
        sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""

        navLeft                 HeirloomBox
        navRight                RewardButton02x01
        navUp                   OpenPackButton
        navDown                 RewardButton01x02

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
        xpos                    -15
        ypos                    -40
	}

	RewardButton02x01
	{
		ControlName				RuiButton
		classname               RewardButton
		rightClickEvents		1
		scriptId                1
		wide					95
		tall					95
		visible					0
        rui					    "ui/collection_event_reward_button.rpak"
        sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""

        navLeft                 RewardButton01x01
        navRight                RewardButton03x01
        navUp                   OpenPackButton
        navDown                 RewardButton02x02

        pin_to_sibling			RewardButton01x01
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
        xpos                    0
        ypos                    0
	}

	RewardButton03x01
	{
		ControlName				RuiButton
		classname               RewardButton
		rightClickEvents		1
		scriptId                2
		wide					95
		tall					95
		visible					0
        rui					    "ui/collection_event_reward_button.rpak"
        sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""

        navLeft                 RewardButton02x01
        navRight                RewardButton04x01
        navUp                   OpenPackButton
        navDown                 RewardButton03x02

        pin_to_sibling			RewardButton02x01
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
        xpos                    0
        ypos                    0
	}

	RewardButton04x01
	{
		ControlName				RuiButton
		classname               RewardButton
		rightClickEvents		1
		scriptId                3
		wide					95
		tall					95
		visible					0
        rui					    "ui/collection_event_reward_button.rpak"
        sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""

        navLeft                 RewardButton03x01
        navRight                RewardButton05x01
        navUp                   OpenPackButton
        navDown                 RewardButton04x02

        pin_to_sibling			RewardButton03x01
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
        xpos                    0
        ypos                    0
	}

	RewardButton05x01
	{
		ControlName				RuiButton
		classname               RewardButton
		rightClickEvents		1
		scriptId                4
		wide					95
		tall					95
		visible					0
        rui					    "ui/collection_event_reward_button.rpak"
        sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""

        navLeft                 RewardButton04x01
        navRight                RewardButton06x01
        navUp                   OpenPackButton
        navDown                 RewardButton05x02

        pin_to_sibling			RewardButton04x01
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
        xpos                    0
        ypos                    0
	}

	RewardButton06x01
	{
		ControlName				RuiButton
		classname               RewardButton
		rightClickEvents		1
		scriptId                5
		wide					95
		tall					95
		visible					0
        rui					    "ui/collection_event_reward_button.rpak"
        sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""

        navLeft                 RewardButton05x01
        navRight                RewardButton07x01
        navUp                   OpenPackButton
        navDown                 RewardButton06x02

        pin_to_sibling			RewardButton05x01
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
        xpos                    0
        ypos                    0
	}

	RewardButton07x01
	{
		ControlName				RuiButton
		classname               RewardButton
		rightClickEvents		1
		scriptId                6
		wide					95
		tall					95
		visible					0
        rui					    "ui/collection_event_reward_button.rpak"
        sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""

        navLeft                 RewardButton06x01
        navRight                RewardButton08x01
        navUp                   OpenPackButton
        navDown                 RewardButton07x02

        pin_to_sibling			RewardButton06x01
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
        xpos                    0
        ypos                    0
	}

	RewardButton08x01
	{
		ControlName				RuiButton
		classname               RewardButton
		rightClickEvents		1
		scriptId                7
		wide					95
		tall					95
		visible					0
        rui					    "ui/collection_event_reward_button.rpak"
        sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""

        navLeft                 RewardButton07x01
        navRight                RewardButton09x01
        navUp                   OpenPackButton
        navDown                 RewardButton08x02

        pin_to_sibling			RewardButton07x01
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
        xpos                    0
        ypos                    0
	}

	RewardButton09x01
	{
		ControlName				RuiButton
		classname               RewardButton
		rightClickEvents		1
		scriptId                8
		wide					95
		tall					95
		visible					0
        rui					    "ui/collection_event_reward_button.rpak"
        sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""

        navLeft                 RewardButton08x01
        navRight                RewardButton10x01
        navUp                   OpenPackButton
        navDown                 RewardButton09x02

        pin_to_sibling			RewardButton08x01
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
        xpos                    0
        ypos                    0
	}

	RewardButton10x01
	{
		ControlName				RuiButton
		classname               RewardButton
		rightClickEvents		1
		scriptId                9
		wide					95
		tall					95
		visible					0
        rui					    "ui/collection_event_reward_button.rpak"
        sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""

        navLeft                 RewardButton09x01
        navRight                RewardButton11x01
        navUp                   OpenPackButton
        navDown                 RewardButton10x02

        pin_to_sibling			RewardButton09x01
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
        xpos                    0
        ypos                    0
	}

	RewardButton11x01
	{
		ControlName				RuiButton
		classname               RewardButton
		rightClickEvents		1
		scriptId                10
		wide					95
		tall					95
		visible					0
        rui					    "ui/collection_event_reward_button.rpak"
        sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""

        navLeft                 RewardButton10x01
        navRight                RewardButton12x01
        navUp                   OpenPackButton
        navDown                 RewardButton11x02

        pin_to_sibling			RewardButton10x01
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
        xpos                    0
        ypos                    0
	}

	RewardButton12x01
	{
		ControlName				RuiButton
		classname               RewardButton
		rightClickEvents		1
		scriptId                11
		wide					95
		tall					95
		visible					0
        rui					    "ui/collection_event_reward_button.rpak"
        sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""

        navLeft                 RewardButton11x01
        navDown                 RewardButton12x02
        navUp                   OpenPackButton

        pin_to_sibling			RewardButton11x01
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
        xpos                    0
        ypos                    0
	}

	RewardButton01x02
	{
		ControlName				RuiButton
		classname               RewardButton
		rightClickEvents		1
		scriptId                12
		wide					95
		tall					95
		visible					0
        rui					    "ui/collection_event_reward_button.rpak"
        sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""

        navLeft                 HeirloomBox
        navRight                RewardButton02x02
        navUp                   RewardButton01x01

        pin_to_sibling			RewardButton01x01
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
        xpos                    0
        ypos                    0
	}

	RewardButton02x02
	{
		ControlName				RuiButton
		classname               RewardButton
		rightClickEvents		1
		scriptId                13
		wide					95
		tall					95
		visible					0
        rui					    "ui/collection_event_reward_button.rpak"
        sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""

        navLeft                 RewardButton01x02
        navRight                RewardButton03x02
        navUp                   RewardButton02x01

        pin_to_sibling			RewardButton01x02
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
        xpos                    0
        ypos                    0
	}

	RewardButton03x02
	{
		ControlName				RuiButton
		classname               RewardButton
		rightClickEvents		1
		scriptId                14
		wide					95
		tall					95
		visible					0
        rui					    "ui/collection_event_reward_button.rpak"
        sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""

        navLeft                 RewardButton02x02
        navRight                RewardButton04x02
        navUp                   RewardButton03x01

        pin_to_sibling			RewardButton02x02
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
        xpos                    0
        ypos                    0
	}

	RewardButton04x02
	{
		ControlName				RuiButton
		classname               RewardButton
		rightClickEvents		1
		scriptId                15
		wide					95
		tall					95
		visible					0
        rui					    "ui/collection_event_reward_button.rpak"
        sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""

        navLeft                 RewardButton03x02
        navRight                RewardButton05x02
        navUp                   RewardButton04x01

        pin_to_sibling			RewardButton03x02
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
        xpos                    0
        ypos                    0
	}

	RewardButton05x02
	{
		ControlName				RuiButton
		classname               RewardButton
		rightClickEvents		1
		scriptId                16
		wide					95
		tall					95
		visible					0
        rui					    "ui/collection_event_reward_button.rpak"
        sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""

        navLeft                 RewardButton04x02
        navRight                RewardButton06x02
        navUp                   RewardButton05x01

        pin_to_sibling			RewardButton04x02
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
        xpos                    0
        ypos                    0
	}

	RewardButton06x02
	{
		ControlName				RuiButton
		classname               RewardButton
		rightClickEvents		1
		scriptId                17
		wide					95
		tall					95
		visible					0
        rui					    "ui/collection_event_reward_button.rpak"
        sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""

        navLeft                 RewardButton05x02
        navRight                RewardButton07x02
        navUp                   RewardButton06x01

        pin_to_sibling			RewardButton05x02
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
        xpos                    0
        ypos                    0
	}

	RewardButton07x02
	{
		ControlName				RuiButton
		classname               RewardButton
		rightClickEvents		1
		scriptId                18
		wide					95
		tall					95
		visible					0
        rui					    "ui/collection_event_reward_button.rpak"
        sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""

        navLeft                 RewardButton06x02
        navRight                RewardButton08x02
        navUp                   RewardButton07x01

        pin_to_sibling			RewardButton06x02
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
        xpos                    0
        ypos                    0
	}

	RewardButton08x02
	{
		ControlName				RuiButton
		classname               RewardButton
		rightClickEvents		1
		scriptId                19
		wide					95
		tall					95
		visible					0
        rui					    "ui/collection_event_reward_button.rpak"
        sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""

        navLeft                 RewardButton07x02
        navRight                RewardButton09x02
        navUp                   RewardButton08x01

        pin_to_sibling			RewardButton07x02
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
        xpos                    0
        ypos                    0
	}

	RewardButton09x02
	{
		ControlName				RuiButton
		classname               RewardButton
		rightClickEvents		1
		scriptId                20
		wide					95
		tall					95
		visible					0
        rui					    "ui/collection_event_reward_button.rpak"
        sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""

        navLeft                 RewardButton08x02
        navRight                RewardButton10x02
        navUp                   RewardButton09x01

        pin_to_sibling			RewardButton08x02
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
        xpos                    0
        ypos                    0
	}

	RewardButton10x02
	{
		ControlName				RuiButton
		classname               RewardButton
		rightClickEvents		1
		scriptId                21
		wide					95
		tall					95
		visible					0
        rui					    "ui/collection_event_reward_button.rpak"
        sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""

        navLeft                 RewardButton09x02
        navRight                RewardButton11x02
        navUp                   RewardButton10x01

        pin_to_sibling			RewardButton09x02
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
        xpos                    0
        ypos                    0
	}

	RewardButton11x02
	{
		ControlName				RuiButton
		classname               RewardButton
		rightClickEvents		1
		scriptId                22
		wide					95
		tall					95
		visible					0
        rui					    "ui/collection_event_reward_button.rpak"
        sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""

        navLeft                 RewardButton10x02
        navRight                RewardButton12x02
        navUp                   RewardButton11x01

        pin_to_sibling			RewardButton10x02
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
        xpos                    0
        ypos                    0
	}

	RewardButton12x02
	{
		ControlName				RuiButton
		classname               RewardButton
		rightClickEvents		1
		scriptId                23
		wide					95
		tall					95
		visible					0
        rui					    "ui/collection_event_reward_button.rpak"
        sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""

        navLeft                 RewardButton11x02
        navUp                   RewardButton12x01

        pin_to_sibling			RewardButton11x02
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
        xpos                    0
        ypos                    0
	}
}
