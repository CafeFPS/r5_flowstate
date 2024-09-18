"resource/ui/menus/panels/store_collection_event.res"
{
	PanelFrame
	{
		ControlName				Label
		wide					%100
		tall					%100
		labelText				""
	    bgcolor_override		"70 70 0 128"
		visible					0
		paintbackground			1
	    proportionalToParent    1
	}

	CenterFrame
	{
		ControlName				Label
        xpos					0
        ypos					0
        wide					1920
		tall					%100
		labelText				""
	    bgcolor_override		"70 30 70 64"
		visible					0
		paintbackground			1
        proportionalToParent    1

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP
	}

	BigInfoBox
	{
	    ControlName				RuiPanel

	    pin_corner_to_sibling	TOP_LEFT
	    pin_to_sibling			CenterFrame
	    pin_to_sibling_corner	TOP_LEFT
	    xpos					0
	    ypos					-15
	    wide					690
	    tall					540

	    visible					1
	    rui					    "ui/collection_event_big_info_box.rpak"
	}

	AboutButton
	{
	    ControlName			    RuiButton
	    classname               "MenuButton"

	    pin_corner_to_sibling	TOP_LEFT
	    pin_to_sibling			BigInfoBox
	    pin_to_sibling_corner	TOP_LEFT
	    xpos				    -50
	    ypos				    -360
	    wide				    530
	    tall				    50

	    visible                 1
	    rui					    "ui/collection_event_about_button.rpak"
	    cursorVelocityModifier  0.7
	    sound_focus             "UI_Menu_Focus_Large"
	    navDown                 Purchase1PackButton
	    navRight                OpenPackButton
        tabPosition				1
	}

	Purchase1PackButton
	{
	    ControlName			    RuiButton
	    classname               "MenuButton"

	    pin_corner_to_sibling	TOP_LEFT
	    pin_to_sibling			AboutButton
	    pin_to_sibling_corner	BOTTOM_LEFT
	    xpos				    0
	    ypos				    16
	    wide				    252
	    tall				    90

	    visible                 1
	    rui					    "ui/collection_event_buy_packs_button.rpak"
	    cursorVelocityModifier  0.7
	    sound_focus             "UI_Menu_Focus_Large"
	    navUp                   AboutButton
	    navRight                PurchaseNPacksButton
	    navDown                 HeirloomBox
	}

	PurchaseNPacksButton
	{
	    ControlName			    RuiButton
	    classname               "MenuButton"

	    pin_corner_to_sibling	TOP_LEFT
	    pin_to_sibling			Purchase1PackButton
	    pin_to_sibling_corner	TOP_RIGHT
	    xpos				    26
	    ypos				    0
	    wide				    252
	    tall				    90

	    visible                 1
	    rui					    "ui/collection_event_buy_packs_button.rpak"
	    cursorVelocityModifier  0.7
	    sound_focus             "UI_Menu_Focus_Large"
	    navUp                   AboutButton
	    navLeft                 Purchase1PackButton
	    navDown                 HeirloomBox
	    navRight                OpenPackButton
	}

	HeirloomBox
	{
		ControlName				RuiButton

	    pin_corner_to_sibling	TOP_LEFT
	    pin_to_sibling			BigInfoBox
	    pin_to_sibling_corner	BOTTOM_LEFT
	    xpos                    0
	    ypos                    25
	    wide                    620
	    tall                    240

	    rui					    "ui/collection_event_heirloom_box.rpak"
	    navUp                   Purchase1PackButton
	    navRight                RewardButton01x01
	}

	RewardBarPanel
	{
	    ControlName				CNestedPanel

	    pin_corner_to_sibling	TOP_LEFT
	    pin_to_sibling			HeirloomBox
	    pin_to_sibling_corner	TOP_RIGHT
	    xpos					52
	    ypos					0
	    wide					1150
	    tall					350

	    visible					1
	    controlSettingsFile		"resource/ui/menus/panels/collection_event_rewards.res"
	}

	ItemDetailsBox
	{
		ControlName				RuiPanel
	    xpos					-200
	    ypos					-185
		wide					400
		tall					200
	    rui					    "ui/collection_event_item_details.rpak"
		visible					1

	    pin_corner_to_sibling	TOP_RIGHT
	    pin_to_sibling			CenterFrame
	    pin_to_sibling_corner	TOP_RIGHT
	}
	OpenPackButton
	{
	    ControlName             RuiButton
	    classname               "MenuButton"

	    pin_corner_to_sibling   BOTTOM_LEFT
	    pin_to_sibling          ItemDetailsBox
	    pin_to_sibling_corner   BOTTOM_LEFT
	    xpos                    -30
	    ypos                    33
	    wide                    308
	    tall                    88
	    proportionalToParent    1

	    visible                 0
	    rui                     "ui/generic_loot_button.rpak"
	    cursorVelocityModifier  0.7
	    sound_focus             "UI_Menu_Focus_Large"
	    sound_accept            "UI_Menu_OpenLootBox"
	    navLeft                 AboutButton
	    navDown                 RewardButton01x01
	}
}

