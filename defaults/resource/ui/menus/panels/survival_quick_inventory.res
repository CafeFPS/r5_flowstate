resource/ui/menus/panels/survival_quick_inventory.res
{
	PanelFrame
	{
		ControlName				ImagePanel

		zpos                    0
		wide					%100
		tall					%100
		visible					0
		enabled 				1
		scaleImage				1
		image					"vgui/HUD/white"
		drawColor				"0 0 0 200"
	}

	BUSYBLOCKER
	{
		ControlName				ImagePanel

		zpos                    1
		wide					%200
		tall					%200
		visible					0
		enabled 				1
		scaleImage				1
		image					"vgui/HUD/white"
		drawColor				"0 0 0 1"
		zpos                    20
	}

	MainInventory
	{
		ControlName				CNestedPanel

		zpos                    0
		xpos					0
        ypos                    0
		wide					%100
		tall					%100
		visible					1
		tabPosition				1
		controlSettingsFile		"Resource/UI/menus/panels/survival_main_inventory.res"

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP
	}

	IngameTextChatHistory
	{
		ControlName				CBaseHudChat
		InheritProperties		ChatBox
		xpos                    -32  [$PC]
		xpos                    %-5  [!$PC]
		ypos                    -120
		zpos					1
		wide                    300
		tall                    460

		destination				"match"
		messageModeAlwaysOn     1
		interactive             1
		hideInputBox			1

		visible 				0

		pin_to_sibling			PanelFrame
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
		xpos					0
		ypos					0
	}

	MouseDragIcon
	{
	    ControlName				RuiPanel

        wide					1
        tall					1
        visible					0
        enabled 				1
        scaleImage				1
        rui                     "ui/survival_inventory_grid_button_v2.rpak"
        zpos                    20
	}
}
