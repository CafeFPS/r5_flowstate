"resource/ui/menus/panels/battlepass.res"
{
	PanelFrame
	{
		ControlName				RuiPanel
		xpos					0
		ypos					0
		wide					%100
		tall					%100
		labelText				""
	    bgcolor_override		"70 30 30 255"
		visible					0
		paintbackground			1
        rui					    "ui/lobby_button_small.rpak"
        proportionalToParent    1
	}

	CenterFrame
	{
		ControlName				RuiPanel
        xpos					0
        ypos					0
        wide					1556
		tall					%100
		labelText				""
	    bgcolor_override		"70 30 70 64"
		visible					0
		paintbackground			1
        rui					    "ui/lobby_button_small.rpak"
        proportionalToParent    1

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP
	}

	StatusBox
	{
		ControlName				RuiPanel
		xpos					0
		ypos					-130
		wide					519
		tall					357
		visible					1
        rui					    "ui/battle_pass_status.rpak"

        pin_to_sibling			CenterFrame
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
	}

    PurchaseButton
    {
        ControlName			    RuiButton
        classname               "MenuButton"
        xpos				    0
        ypos				    10
        wide				    464
        tall				    100
        visible                 1
        scriptID                0
        rui					    "ui/battle_pass_purchase_button.rpak"
        sound_focus             "UI_Menu_Focus_Large"
        cursorVelocityModifier  0.7
        proportionalToParent	1
        pin_to_sibling			StatusBox
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT

        navUp AboutButton
    }

    AboutButton
    {
        ControlName			    RuiButton
        classname               "MenuButton"
        xpos					-24
        ypos					-16
        wide					200
        tall					36
        visible			        1
        scriptID                1
        rui					    "ui/generic_popup_button.rpak"
        cursorVelocityModifier  0.7
        proportionalToParent	1
        //sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            "UI_Menu_BattlePass_AboutInfo"
        pin_to_sibling			StatusBox
        pin_corner_to_sibling	BOTTOM
        pin_to_sibling_corner	BOTTOM

        ruiArgs
        {
            textHeight          "22.0"
        }

        navDown PurchaseButton
    }

	DetailsBox
	{
		ControlName				RuiPanel
		xpos					0
		ypos					-140
		wide					460
		tall					446
		visible					1
        rui					    "ui/battle_pass_reward_details.rpak"

        pin_to_sibling			CenterFrame
        pin_corner_to_sibling	TOP_RIGHT
        pin_to_sibling_corner	TOP_RIGHT
	}

    LoadscreenPreviewBox
    {
        ControlName             RuiPanel
        xpos					18
        ypos					0
        zpos                    90
        wide                    548
        tall                    308
        visible                 0
        rui                     "ui/custom_loadscreen_image.rpak"

        pin_to_sibling			DetailsBox
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	LEFT
    }

	LoadscreenPreviewBoxOverlay
	{
		ControlName				RuiPanel
		xpos				    0
        ypos				    0
        zpos                    91
		wide				    548
		tall				    308
		visible				    0
        rui					    "ui/loadscreen_preview_box_overlay.rpak"

        pin_to_sibling			LoadscreenPreviewBox
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
	}

	LevelReqButton
	{
		ControlName				RuiButton
		xpos					0
		ypos					8
		wide					340
		tall					42
		visible					1
        rui					    "ui/battle_pass_reqs_button.rpak"

        pin_to_sibling			PremiumReqButton
        pin_corner_to_sibling	BOTTOM
        pin_to_sibling_corner	TOP
	}

	PremiumReqButton
	{
		ControlName				RuiButton
		xpos					-32
		ypos					0
		wide					340
		tall					42
		visible					1
        rui					    "ui/battle_pass_reqs_button.rpak"

        pin_to_sibling			DetailsBox
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
	}

    RewardBarPanel
    {
        ControlName				CNestedPanel
        xpos					0
        ypos					-10
        wide					1556
        tall					190
        visible					1
        tabPosition             1
        controlSettingsFile		"resource/ui/menus/panels/battlepass_reward_bar.res"

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	BOTTOM
        pin_to_sibling_corner	BOTTOM
    }

	RewardBarFooter
	{
		ControlName				RuiPanel
		ypos					-24
		wide					1556
		tall					48
		visible					1
        rui					    "ui/battle_pass_footer_bar.rpak"
        //proportionalToParent    1

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	BOTTOM
        pin_to_sibling_corner	BOTTOM
	}

    RewardBarPrevButton
    {
        ControlName				RuiButton
        ypos                    60
        wide					64
        tall					64
        rui                     "ui/arrow_button_square.rpak"
        labelText               ""
        visible					1
        cursorVelocityModifier  0.7
        proportionalToParent    1
        sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""
        pin_to_sibling			RewardBarFooter
        pin_corner_to_sibling	BOTTOM_RIGHT
        pin_to_sibling_corner	TOP_LEFT
    }

    RewardBarNextButton
    {
        ControlName				RuiButton
        ypos                    60
        wide					64
        tall					64
        rui                     "ui/arrow_button_square.rpak"
        labelText               ""
        visible					1
        cursorVelocityModifier  0.7
        proportionalToParent    1
        sound_focus             "UI_Menu_BattlePass_Level_Focus"
        sound_accept            ""
        pin_to_sibling			RewardBarFooter
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }
}
