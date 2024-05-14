Resource/UI/menus/panels/survival_inventory_list.res
{
    PanelFrame
    {
		ControlName				ImagePanel
		wide					f0
		tall					f0
		visible				    0
        scaleImage				1
        image					"vgui/HUD/white"
        drawColor				"255 255 255 15"

        proportionalToParent    1
    }

	NavUpHidden
	{
		ControlName			BaseModHybridButton
		visible			    1
		enabled             1
	}

	NavDownHidden
	{
		ControlName			BaseModHybridButton
		visible			    0
		enabled             1
	}

	// WeaponButton0
	// {
		// ControlName			RuiButton
		// Classname			"ListButtonClass"
		// InheritProperties	SurvivalInventoryListButton
		// wide			240
		// tall			68
		// visible			1

		// zpos			1

		// navDown         WeaponButton1
	// }

	// WeaponButton1
	// {
		// ControlName			RuiButton
		// Classname			"ListButtonClass"
		// InheritProperties	SurvivalInventoryListButton
		// wide			240
		// tall			68
		// visible			1

		// zpos			1
		
		// navUp           WeaponButton0
		// navDown         ListButton0
	// }
		
	ListButton0
	{
		ControlName			RuiButton
		Classname			"ListButtonClass"
		InheritProperties	SurvivalInventoryListButton
		wide			525
		tall			68
		visible			1

		zpos			1
		
		navUp           WeaponButton1
		navDown         ListButton1
	}

	ListButton1
	{
		ControlName			RuiButton
		Classname			"ListButtonClass"
		InheritProperties	SurvivalInventoryListButton
		wide			525
		tall			68
		visible			1

		zpos			1

		navUp           ListButton1
		navDown         ListButton2
	}

	ListButton2
	{
		ControlName			RuiButton
		Classname			"ListButtonClass"
		InheritProperties	SurvivalInventoryListButton
		wide			525
		tall			68
		visible			1

		zpos			1

		navUp           ListButton2
		navDown         ListButton3
	}

	ListButton3
	{
		ControlName			RuiButton
		Classname			"ListButtonClass"
		InheritProperties	SurvivalInventoryListButton
		wide			525
		tall			68
		visible			1

		zpos			1
	}

	ListButton4
	{
		ControlName			RuiButton
		Classname			"ListButtonClass"
		InheritProperties	SurvivalInventoryListButton
		wide			525
		tall			68
		visible			1

		zpos			1
	}

	ListButton5
	{
		ControlName			RuiButton
		Classname			"ListButtonClass"
		InheritProperties	SurvivalInventoryListButton
		wide			525
		tall			68
		visible			1

		zpos			1
	}

	ListButton6
	{
		ControlName			RuiButton
		Classname			"ListButtonClass"
		InheritProperties	SurvivalInventoryListButton
		wide			525
		tall			68
		visible			1

		zpos			1
	}

	ListButton7
	{
		ControlName			RuiButton
		Classname			"ListButtonClass"
		InheritProperties	SurvivalInventoryListButton
		wide			525
		tall			68
		visible			1

		zpos			1
	}

	ListButton8
	{
		ControlName			RuiButton
		Classname			"ListButtonClass"
		InheritProperties	SurvivalInventoryListButton
		wide			525
		tall			68
		visible			1

		zpos			1
	}

	ListButton9
	{
		ControlName			RuiButton
		Classname			"ListButtonClass"
		InheritProperties	SurvivalInventoryListButton
		wide			525
		tall			68
		visible			1

		zpos			1
	}

	ListButton10
	{
		ControlName			RuiButton
		Classname			"ListButtonClass"
		InheritProperties	SurvivalInventoryListButton
		wide			525
		tall			68
		visible			1

		zpos			1
	}

	ListButton11
	{
		ControlName			RuiButton
		Classname			"ListButtonClass"
		InheritProperties	SurvivalInventoryListButton
		wide			525
		tall			68
		visible			1

		zpos			1
	}

	ListButton12
	{
		ControlName			RuiButton
		Classname			"ListButtonClass"
		InheritProperties	SurvivalInventoryListButton
		wide			525
		tall			68
		visible			1

		zpos			1
	}

	ListButton13
	{
		ControlName			RuiButton
		Classname			"ListButtonClass"
		InheritProperties	SurvivalInventoryListButton
		wide			525
		tall			68
		visible			1

		zpos			1
	}

	ListButton14
	{
		ControlName			RuiButton
		Classname			"ListButtonClass"
		InheritProperties	SurvivalInventoryListButton
		wide			525
		tall			68
		visible			1

		zpos			1
	}

	ListButton15
	{
		ControlName			RuiButton
		Classname			"ListButtonClass"
		InheritProperties	SurvivalInventoryListButton
		wide			525
		tall			68
		visible			1

		zpos			1
	}

	ListButton16
	{
		ControlName			RuiButton
		Classname			"ListButtonClass"
		InheritProperties	SurvivalInventoryListButton
		wide			525
		tall			68
		visible			1

		zpos			1
	}

	ListButton17
	{
		ControlName			RuiButton
		Classname			"ListButtonClass"
		InheritProperties	SurvivalInventoryListButton
		wide			525
		tall			68
		visible			1

		zpos			1
	}

	ListButton18
	{
		ControlName			RuiButton
		Classname			"ListButtonClass"
		InheritProperties	SurvivalInventoryListButton
		wide			525
		tall			68
		visible			1

		zpos			1
	}

	ListButton19
	{
		ControlName			RuiButton
		Classname			"ListButtonClass"
		InheritProperties	SurvivalInventoryListButton
		wide			525
		tall			68
		visible			1

		zpos			1
	}

	ListButton20
	{
		ControlName			RuiButton
		Classname			"ListButtonClass"
		InheritProperties	SurvivalInventoryListButton
		wide			525
		tall			68
		visible			1

		zpos			1
	}

}
