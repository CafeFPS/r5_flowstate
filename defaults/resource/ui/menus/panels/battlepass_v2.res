"resource/ui/menus/panels/battlepass_v2.res"
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
        wide					1826
		tall					%100
		labelText				""
	    bgcolor_override		"70 30 70 64"
		visible					0
		paintbackground			1
        rui					    "ui/basic_image.rpak"
        proportionalToParent    1

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP
	}

	StatusBox
	{
		ControlName				RuiButton
		xpos					0
		ypos					-64
		wide					700
		tall					125
		visible					1
		zpos                    50
        rui					    "ui/battle_pass_status_v2.rpak"

        pin_to_sibling			CenterFrame
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
	}

	PurchaseBG
	{
		ControlName				RuiPanel
		xpos					0
		ypos					32
		wide					1200
		tall					200
		zpos                    0
		visible					1
        rui					    "ui/battle_pass_purchase_bg.rpak"

        pin_to_sibling			StatusBox
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
	}

    PurchaseButton
    {
        ControlName			    RuiButton
        classname               "MenuButton"
        labelText               ""
        xpos				    -16
        ypos				    0
        wide				    464
        tall				    100
        visible                 1
        scriptID                0
        rui					    "ui/battle_pass_purchase_button.rpak"
        sound_focus             "UI_Menu_Focus_Large"
        cursorVelocityModifier  0.7
        proportionalToParent	1
        pin_to_sibling			PurchaseBG
        pin_corner_to_sibling	LEFT
        pin_to_sibling_corner	LEFT

        navUp AboutButton
    }

	DetailsBox
	{
		ControlName				RuiPanel
		xpos					0
		ypos					0
		wide					500
		tall					200
		visible					1
        rui					    "ui/battle_pass_reward_details_v2.rpak"

        pin_to_sibling			PurchaseBG
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	RIGHT
	}

    LoadscreenPreviewBox
    {
        ControlName             RuiPanel
        xpos					80
        ypos					0
        zpos                    90
        wide                    526
        tall                    296
        visible                 0
        rui                     "ui/custom_loadscreen_image.rpak"

        pin_to_sibling			DetailsBox
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_RIGHT
    }

	LoadscreenPreviewBoxOverlay
	{
		ControlName				RuiPanel
		xpos				    0
        ypos				    0
        zpos                    91
        wide                    526
        tall                    296
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
		visible					0
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
		visible					0
        rui					    "ui/battle_pass_reqs_button.rpak"

        pin_to_sibling			DetailsBox
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
	}

    RewardBarPanelHeader
    {
        ControlName				CNestedPanel
        xpos					-38
        ypos					16
        wide					1556
        tall					450
        visible					1
        controlSettingsFile		"resource/ui/menus/panels/battlepass_reward_header.res"

        pin_to_sibling			PurchaseBG
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

	RewardBarFooter
	{
		ControlName				RuiPanel
		xpos					-335
		ypos					-36
		wide					500
		tall					48
		visible					1
        rui					    "ui/battle_pass_footer_bar_v2.rpak"
        //proportionalToParent    1

        pin_to_sibling			RewardBarPanelHeader
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
	}

    RewardBarPrevButton
    {
        ControlName				RuiButton
        ypos                    0
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
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	LEFT
    }

    RewardBarNextButton
    {
        ControlName				RuiButton
        ypos                    0
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
        pin_corner_to_sibling	LEFT
        pin_to_sibling_corner	RIGHT
    }
}
