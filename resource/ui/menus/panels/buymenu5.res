scripts/resource/ui/menus/panels/buymenu1.res
{
	PanelFrame
	{
		ControlName				ImagePanel

		zpos                    0
		wide					f0
		tall					f0
		visible					0
		enabled 				1
		scaleImage				1
		image					"vgui/HUD/white"
		drawColor				"0 0 0 200"
	}

    DialogFrame
	{
		ControlName		ImagePanel
		wide					1015
		tall					500
		xpos                    0
		visible			1
		scaleImage		1
		fillColor		"30 30 30 200"
		drawColor		"30 30 30 200"

		pin_to_sibling			PanelFrame
		pin_corner_to_sibling	CENTER
		pin_to_sibling_corner	CENTER
	}
	
	InvisibleExitButton
	{
		"ControlName"			"RuiButton"
		wide					1015
		tall					500
		"rui"                   "ui/invisible.rpak"
		"labelText"             ""
		sound_focus           ""
		"sound_accept"          ""
		"cursorPriority"        "-1"

		xpos                   	0
		ypos                    0
		zpos                    20
		rightClickEvents        1
		visible 0
		pin_to_sibling			PanelFrame
		pin_corner_to_sibling	CENTER
		pin_to_sibling_corner	CENTER
	}
	
	ImgTopBar2
	{
		ControlName		ImagePanel
		wide					1015
		tall					2
		visible			1
		scaleImage		1
		proportionalToParent    0
		fillColor		"255 255 255 200"
		drawColor		"255 255 255 200"

		pin_to_sibling			DialogFrame
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}

	ImgTopBar3
	{
		ControlName		ImagePanel
		wide					1015
		tall					2
		visible			1
		scaleImage		1
		proportionalToParent    0
		fillColor		"255 255 255 200"
		drawColor		"255 255 255 200"

		pin_to_sibling			DialogFrame
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}

	ImgTopBar4
	{
		ControlName		ImagePanel
		wide					2
		tall					500
		visible			1
		scaleImage		1
		proportionalToParent    0
		fillColor		"255 255 255 200"
		drawColor		"255 255 255 200"

		pin_to_sibling			DialogFrame
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}

	ImgTopBar5
		{
			ControlName		ImagePanel
			wide					2
			tall					500
            visible			1
            scaleImage		1
			proportionalToParent    0
            fillColor		"255 255 255 200"
            drawColor		"255 255 255 200"

			pin_to_sibling			DialogFrame
			pin_corner_to_sibling	TOP_RIGHT
			pin_to_sibling_corner	TOP_RIGHT
		}

	DialogHeader
		{
			ControlName				Label
			xpos					-15
			ypos                    -15
			auto_wide_tocontents	1
			tall					30
			visible					0
			fontHeight				30
			labelText				"Pistols, Shotguns & SMGs"
			font					DefaultBold_41
			allcaps					1
			fgcolor_override		"255 255 255 255"

			pin_to_sibling			DialogFrame
			pin_corner_to_sibling	TOP_LEFT
			pin_to_sibling_corner	TOP_LEFT
		}

		VoltButton
		{
			"ControlName"				"RuiButton"
			"rui"						"ui/generic_friend_button.rpak"
			wide					200
			tall					150
			"visible"					"1"
			"sound_accept"				"ui_rankedsummary_circletick_reached"
			"sound_focus"				"UI_Menu_Focus_Small"
			xpos                    -100
			ypos                    -10
			zpos                    5
			rightClickEvents        1
			pin_to_sibling          DialogFrame
			pin_corner_to_sibling   TOP_LEFT
			pin_to_sibling_corner   TOP_LEFT
		}
		
		Volt
		{
			ControlName 				 RuiPanel 
			rui 						 ui/basic_image.rpak 
			wide 						 160 
			tall 						 75 
			xpos                    0
			ypos                    -10
			zpos                    5
			pin_to_sibling          VoltButton
			pin_corner_to_sibling   CENTER
			pin_to_sibling_corner   CENTER
		}

		Volt_Name
		{
			ControlName				Label
			wide                    224
			labelText				"Volt"
			visible                 1
			zpos 5
			fgcolor_override		"2 252 240 255"
			ypos                                       20
			xpos					120
			fontHeight				35
			pin_to_sibling          Volt
			pin_corner_to_sibling   BOTTOM_RIGHT
			pin_to_sibling_corner   BOTTOM_RIGHT
		}
		R99Button
		{
			"ControlName"				"RuiButton"
			"rui"						"ui/generic_friend_button.rpak"
			wide					200
			tall					150
			"visible"					"1"
			"sound_accept"				"ui_rankedsummary_circletick_reached"
			"sound_focus"				"UI_Menu_Focus_Small"
			xpos                    100
			ypos                    0
			zpos                    5
			rightClickEvents        1
			pin_to_sibling          VoltButton
			pin_corner_to_sibling   TOP_LEFT
			pin_to_sibling_corner   TOP_RIGHT
		}
		
		R99
		{
			ControlName 				 RuiPanel 
			rui 						 ui/basic_image.rpak 
			wide 						 160 
			tall 						 75 
			xpos                    0
			ypos                    -10
			zpos                    5
			pin_to_sibling          R99Button
			pin_corner_to_sibling   CENTER
			pin_to_sibling_corner   CENTER
		}

		R99_Name
		{
			ControlName				Label
			wide                    224
			labelText				"R-99"
			visible                 1
			zpos 5
			fgcolor_override		"2 252 240 255"
			ypos                                       20
			xpos					120
			fontHeight				35
			pin_to_sibling          R99
			pin_corner_to_sibling   BOTTOM_RIGHT
			pin_to_sibling_corner   BOTTOM_RIGHT
		}
		CarButton
		{
			"ControlName"				"RuiButton"
			"rui"						"ui/generic_friend_button.rpak"
			wide					200
			tall					150
			"visible"					"1"
			"sound_accept"				"ui_rankedsummary_circletick_reached"
			"sound_focus"				"UI_Menu_Focus_Small"
			xpos                    100
			ypos                    0
			zpos                    5
			rightClickEvents        1
			pin_to_sibling          R99Button
			pin_corner_to_sibling   TOP_LEFT
			pin_to_sibling_corner   TOP_RIGHT
		}
		
		Car
		{
			ControlName 				 RuiPanel 
			rui 						 ui/basic_image.rpak 
			wide 						 160 
			tall 						 75 
			xpos                    0
			ypos                    -10
			zpos                    5
			pin_to_sibling          CarButton
			pin_corner_to_sibling   CENTER
			pin_to_sibling_corner   CENTER
		}

		Car_Name
		{
			ControlName				Label
			wide                    224
			labelText				"Car"
			visible                 1
			zpos 5
			fgcolor_override		"2 252 240 255"
			ypos                                       20
			xpos					120
			fontHeight				35
			pin_to_sibling          Car
			pin_corner_to_sibling   BOTTOM_RIGHT
			pin_to_sibling_corner   BOTTOM_RIGHT
		}
	
		ProwlerButton
		{
			"ControlName"				"RuiButton"
			"rui"						"ui/generic_friend_button.rpak"
			wide					200
			tall					150
			"visible"					"1"
			"sound_accept"				"ui_rankedsummary_circletick_reached"
			"sound_focus"				"UI_Menu_Focus_Small"
			xpos                    0
			ypos                    10
			zpos                    5
			rightClickEvents        1
			pin_to_sibling          VoltButton
			pin_corner_to_sibling   TOP
			pin_to_sibling_corner   BOTTOM
			visible                 0
		}
		
		Prowler
		{
			ControlName 				 RuiPanel 
			rui 						 ui/basic_image.rpak 
			wide 						 160 
			tall 						 75 
			xpos                    0
			ypos                    -10
			zpos                    5
			pin_to_sibling          ProwlerButton
			pin_corner_to_sibling   CENTER
			pin_to_sibling_corner   CENTER
		}

		Prowler_Name
		{
			ControlName				Label
			wide                    224
			labelText				"Prowler"
			visible                 1
			zpos 5
			fgcolor_override		"2 252 240 255"
			ypos                                       20
			xpos					110
			fontHeight				35
			pin_to_sibling          Prowler
			pin_corner_to_sibling   BOTTOM_RIGHT
			pin_to_sibling_corner   BOTTOM_RIGHT
		}
		AlternatorButton
		{
			"ControlName"				"RuiButton"
			"rui"						"ui/generic_friend_button.rpak"
			wide					200
			tall					150
			"visible"					"1"
			"sound_accept"				"ui_rankedsummary_circletick_reached"
			"sound_focus"				"UI_Menu_Focus_Small"
			xpos                    100
			ypos                    0
			zpos                    5
			rightClickEvents        1
			pin_to_sibling          ProwlerButton
			pin_corner_to_sibling   TOP_LEFT
			pin_to_sibling_corner   TOP_RIGHT
		}
		
		Alternator
		{
			ControlName 				 RuiPanel 
			rui 						 ui/basic_image.rpak 
			wide 						 160 
			tall 						 75 
			xpos                    0
			ypos                    -10
			zpos                    5
			pin_to_sibling          AlternatorButton
			pin_corner_to_sibling   CENTER
			pin_to_sibling_corner   CENTER
		}

		Alternator_Name
		{
			ControlName				Label
			wide                    224
			labelText				"Alternator"
			visible                 1
			zpos 5
			fgcolor_override		"2 252 240 255"
			ypos                                       20
			xpos					90
			fontHeight				35
			pin_to_sibling          Alternator
			pin_corner_to_sibling   BOTTOM_RIGHT
			pin_to_sibling_corner   BOTTOM_RIGHT
		}
		// RE45Button
		// {
			// "ControlName"				"RuiButton"
			// "rui"						"ui/generic_friend_button.rpak"
			// wide					200
			// tall					150
			// "visible"					"1"
			// "sound_accept"				"ui_rankedsummary_circletick_reached"
			// "sound_focus"				"UI_Menu_Focus_Small"
			// xpos                    0
			// ypos                    60
			// zpos                    5
			// pin_to_sibling          P2020
			// pin_corner_to_sibling   TOP
			// pin_to_sibling_corner   BOTTOM
			// visible                 0
		// }
		
		// RE45
		// {
			// ControlName 				 RuiPanel 
			// rui 						 ui/basic_image.rpak 
			// wide 						 160 
			// tall 						 75 
			// xpos                    0
			// ypos                    -10
			// zpos                    9
			// pin_to_sibling          RE45Button
			// pin_corner_to_sibling   CENTER
			// pin_to_sibling_corner   CENTER
			
			// visible                 0
		// }

		// RE45_Name
		// {
			// ControlName				Label
			// wide                    224
			// labelText				"RE45"
			// visible                 1
			// zpos 9
			// fgcolor_override		"2 252 240 255"
			// ypos                                       20
			// xpos					100
			// fontHeight				35
			// pin_to_sibling          RE45
			// pin_corner_to_sibling   BOTTOM_RIGHT
			// pin_to_sibling_corner   BOTTOM_RIGHT
			
			// visible                 0
		// }
//attachments box
	

        SMGLootFrame
		{
            ControlName		ImagePanel
			wide					%30
			tall					%24
            xpos                    0
			ypos					0
			zpos 24
			visible			0
            scaleImage		0
            fillColor		"30 30 30 220"
            drawColor		"30 30 30 220"
		}
		ScreenBlur
		{
			ControlName				RuiPanel
			wide					%30
			tall					%24
			zpos 25
			rui                     "ui/tabs_background.rpak"
			visible					0
			drawColor				"0 0 0 50"
		}	
        SMGLootFrame2
		{
            ControlName		ImagePanel
			wide					%30
			tall					%5
            xpos                    0
			ypos					0
			zpos 25
			visible			0
            scaleImage		0
            fillColor		"30 30 30 255"
            drawColor		"30 30 30 255"
		}
        SMGLootFrame3
		{
            ControlName		ImagePanel
			wide					%30
			tall					%5
            xpos                    0
			ypos					0
			zpos 25
			visible			0
            scaleImage		0
            fillColor		"30 30 30 255"
            drawColor		"30 30 30 255"
		}
		
		Line1
		{
			ControlName		ImagePanel
			wide					%30
			tall					2
            visible			0
            scaleImage		1
			zpos 30
			proportionalToParent    0
            fillColor		"99 99 99 200"
            drawColor		"99 99 99 200"

			pin_to_sibling			SMGLootFrame
			pin_corner_to_sibling	BOTTOM_LEFT
			pin_to_sibling_corner	BOTTOM_LEFT
		}

		Line2
		{
			ControlName		ImagePanel
			wide					%30
			tall					2
            visible			0
            scaleImage		1
			zpos 30
			proportionalToParent    0
            fillColor		"99 99 99 200"
            drawColor		"99 99 99 200"

			pin_to_sibling			SMGLootFrame
			pin_corner_to_sibling	TOP_LEFT
			pin_to_sibling_corner	TOP_LEFT
		}

		Line3
		{
			ControlName		ImagePanel
			wide					2
			tall					%24
            visible			0
            scaleImage		1
			zpos 30
			proportionalToParent    0
            fillColor		"99 99 99 200"
            drawColor		"99 99 99 200"

			pin_to_sibling			SMGLootFrame
			pin_corner_to_sibling	TOP_LEFT
			pin_to_sibling_corner	TOP_LEFT
		}

		Line4
		{
			ControlName		ImagePanel
			wide					2
			tall					%24
            visible			0
            scaleImage		1
			zpos 30
			proportionalToParent    0
            fillColor		"99 99 99 200"
            drawColor		"99 99 99 200"

			pin_to_sibling			SMGLootFrame
			pin_corner_to_sibling	TOP_RIGHT
			pin_to_sibling_corner	TOP_RIGHT
		}
		//actual loot
		//optics
		SMGOptics1
		{
			sound_accept            "UI_Menu_Accept"
			
			ControlName             RuiButton
			InheritProperties       SurvivalInventoryGridButton

			classname               "SurvivalEquipment"
			scriptID                "armor"

			wide                    75
			tall                    75

			xpos                    0
			ypos                    0
			zpos					25
			visible 0
		}
		
		SMGOptics2
		{
			sound_accept            "UI_Menu_Accept"
			
			ControlName             RuiButton
			InheritProperties       SurvivalInventoryGridButton

			classname               "SurvivalEquipment"
			scriptID                "armor"

			wide                    75
			tall                    75

			xpos                    0
			ypos                    0
			zpos					25
			visible 0
		}
		
		SMGOptics3
		{
			sound_accept            "UI_Menu_Accept"
			
			ControlName             RuiButton
			InheritProperties       SurvivalInventoryGridButton

			classname               "SurvivalEquipment"
			scriptID                "armor"

			wide                    75
			tall                    75

			xpos                    0
			ypos                    0
			zpos					25
			visible 0
		}
		
		SMGOptics4
		{
			sound_accept            "UI_Menu_Accept"
			
			ControlName             RuiButton
			InheritProperties       SurvivalInventoryGridButton

			classname               "SurvivalEquipment"
			scriptID                "armor"

			wide                    75
			tall                    75

			xpos                    0
			ypos                    0
			zpos					25
			visible 0
		}
		
		SMGOptics5
		{
			sound_accept            "UI_Menu_Accept"
			
			ControlName             RuiButton
			InheritProperties       SurvivalInventoryGridButton

			classname               "SurvivalEquipment"
			scriptID                "armor"

			wide                    75
			tall                    75

			xpos                    0
			ypos                    0
			zpos					25
			visible 0
		}
		
		SMGOptics6
		{
			sound_accept            "UI_Menu_Accept"
			
			ControlName             RuiButton
			InheritProperties       SurvivalInventoryGridButton

			classname               "SurvivalEquipment"
			scriptID                "armor"

			wide                    75
			tall                    75

			xpos                    0
			ypos                    0
			zpos					25
			visible 0
		}
		//barrels
		SMGBarrels1
		{
			sound_accept            "UI_Menu_Accept"
			
			ControlName             RuiButton
			InheritProperties       SurvivalInventoryGridButton

			classname               "SurvivalEquipment"
			scriptID                "armor"

			wide                    75
			tall                    75

			xpos                    0
			ypos                    0
			zpos					25
			visible 0
		}
		
		SMGBarrels2
		{
			sound_accept            "UI_Menu_Accept"
			
			ControlName             RuiButton
			InheritProperties       SurvivalInventoryGridButton

			classname               "SurvivalEquipment"
			scriptID                "armor"

			wide                    75
			tall                    75

			xpos                    0
			ypos                    0
			zpos					25
			visible 0
		}
		
		SMGBarrels3
		{
			sound_accept            "UI_Menu_Accept"
			
			ControlName             RuiButton
			InheritProperties       SurvivalInventoryGridButton

			classname               "SurvivalEquipment"
			scriptID                "armor"

			wide                    75
			tall                    75

			xpos                    0
			ypos                    0
			zpos					25
			visible 0
		}
		
		SMGBarrels4
		{
			sound_accept            "UI_Menu_Accept"
			
			ControlName             RuiButton
			InheritProperties       SurvivalInventoryGridButton

			classname               "SurvivalEquipment"
			scriptID                "armor"

			wide                    75
			tall                    75

			xpos                    0
			ypos                    0
			zpos					25
			visible 0
		}

		//stocks
		SMGStocks1
		{
			sound_accept            "UI_Menu_Accept"
			
			ControlName             RuiButton
			InheritProperties       SurvivalInventoryGridButton

			classname               "SurvivalEquipment"
			scriptID                "armor"

			wide                    75
			tall                    75

			xpos                    0
			ypos                    0
			zpos					25
			visible 0
		}
		
		SMGStocks2
		{
			sound_accept            "UI_Menu_Accept"
			
			ControlName             RuiButton
			InheritProperties       SurvivalInventoryGridButton

			classname               "SurvivalEquipment"
			scriptID                "armor"

			wide                    75
			tall                    75

			xpos                    0
			ypos                    0
			zpos					25
			visible 0
		}
		
		SMGStocks3
		{
			sound_accept            "UI_Menu_Accept"
			
			ControlName             RuiButton
			InheritProperties       SurvivalInventoryGridButton

			classname               "SurvivalEquipment"
			scriptID                "armor"

			wide                    75
			tall                    75

			xpos                    0
			ypos                    0
			zpos					25
			visible 0
		}
		
		SMGStocks4
		{
			sound_accept            "UI_Menu_Accept"
			
			ControlName             RuiButton
			InheritProperties       SurvivalInventoryGridButton

			classname               "SurvivalEquipment"
			scriptID                "armor"

			wide                    75
			tall                    75

			xpos                    0
			ypos                    0
			zpos					25
			visible 0
		}
		
		SMGStocks5
		{
			sound_accept            "UI_Menu_Accept"
			
			ControlName             RuiButton
			InheritProperties       SurvivalInventoryGridButton

			classname               "SurvivalEquipment"
			scriptID                "armor"

			wide                    75
			tall                    75

			xpos                    0
			ypos                    0
			zpos					25
			visible 0
		}
		
		SMGStocks6
		{
			sound_accept            "UI_Menu_Accept"
			
			ControlName             RuiButton
			InheritProperties       SurvivalInventoryGridButton

			classname               "SurvivalEquipment"
			scriptID                "armor"

			wide                    75
			tall                    75

			xpos                    0
			ypos                    0
			zpos					25
			visible 0
		}
		//shotgun bolts!
		ShotgunBolt1
		{
			sound_accept            "UI_Menu_Accept"
			
			ControlName             RuiButton
			InheritProperties       SurvivalInventoryGridButton

			classname               "SurvivalEquipment"
			scriptID                "armor"

			wide                    75
			tall                    75

			xpos                    0
			ypos                    0
			zpos					25
			visible 0
		}
		
		ShotgunBolt2
		{
			sound_accept            "UI_Menu_Accept"
			
			ControlName             RuiButton
			InheritProperties       SurvivalInventoryGridButton

			classname               "SurvivalEquipment"
			scriptID                "armor"

			wide                    75
			tall                    75

			xpos                    0
			ypos                    0
			zpos					25
			visible 0
		}
		
		ShotgunBolt3
		{
			sound_accept            "UI_Menu_Accept"
			
			ControlName             RuiButton
			InheritProperties       SurvivalInventoryGridButton

			classname               "SurvivalEquipment"
			scriptID                "armor"

			wide                    75
			tall                    75

			xpos                    0
			ypos                    0
			zpos					25
			visible 0
		}
		
		ShotgunBolt4
		{
			sound_accept            "UI_Menu_Accept"
			
			ControlName             RuiButton
			InheritProperties       SurvivalInventoryGridButton

			classname               "SurvivalEquipment"
			scriptID                "armor"

			wide                    75
			tall                    75

			xpos                    0
			ypos                    0
			zpos					25
			visible 0
		}
		Mags1
		{
			sound_accept            "UI_Menu_Accept"
			
			ControlName             RuiButton
			InheritProperties       SurvivalInventoryGridButton

			classname               "SurvivalEquipment"
			scriptID                "armor"

			wide                    75
			tall                    75

			xpos                    0
			ypos                    0
			zpos					25
			visible 0
		}
		
		Mags2
		{
			sound_accept            "UI_Menu_Accept"
			
			ControlName             RuiButton
			InheritProperties       SurvivalInventoryGridButton

			classname               "SurvivalEquipment"
			scriptID                "armor"

			wide                    75
			tall                    75

			xpos                    0
			ypos                    0
			zpos					25
			visible 0
		}
		
		Mags3
		{
			sound_accept            "UI_Menu_Accept"
			
			ControlName             RuiButton
			InheritProperties       SurvivalInventoryGridButton

			classname               "SurvivalEquipment"
			scriptID                "armor"

			wide                    75
			tall                    75

			xpos                    0
			ypos                    0
			zpos					25
			visible 0
		}
		
		Mags4
		{
			sound_accept            "UI_Menu_Accept"
			
			ControlName             RuiButton
			InheritProperties       SurvivalInventoryGridButton

			classname               "SurvivalEquipment"
			scriptID                "armor"

			wide                    75
			tall                    75

			xpos                    0
			ypos                    0
			zpos					25
			visible 0
		}
		//Attachments box header
		OpticsButton
		{
			ControlName				RuiButton
			InheritProperties		TabButton
			labelText				""
			wide %7.5
			xpos                    0
			ypos 0
			zpos 26
			visible 0
		}
		OpticsText
		{
			ControlName				Label
			auto_wide_tocontents    1
			labelText				"OPTICS"
			visible                 0
			zpos 25
			tall					40
			fontHeight				20
			font					TitleBoldFont
			fgcolor_override		"255 255 255 255"
		
			ypos                    0
			xpos					0
		}
		BarrelsButton
		{
			ControlName				RuiButton
			InheritProperties		TabButton
			wide %7.5
			xpos                    0
			zpos 26
			visible 0
		}
		BarrelsText
		{
			ControlName				Label
			auto_wide_tocontents    1
			labelText				"LASER"
			visible                 0
			zpos 25
			tall					40
			fontHeight				20
			font					TitleBoldFont
			fgcolor_override		"255 255 255 255"
		
			ypos                    0
			xpos					0
		}
		BoltsButton
		{
			ControlName				RuiButton
			InheritProperties		TabButton
			wide %7.5
			xpos                    0
			zpos 26
			visible 0
		}
		BoltsText
		{
			ControlName				Label
			auto_wide_tocontents    1
			labelText				"BOLTS"
			visible                 0
			zpos 25
			tall					40
			fontHeight				20
			font					TitleBoldFont
			fgcolor_override		"255 255 255 255"
		
			ypos                    0
			xpos					0
		}
		StocksButton
		{
			ControlName				RuiButton
			InheritProperties		TabButton
			wide %7.5
			xpos                    0
			zpos 26
			visible 0
		}
		StocksText
		{
			ControlName				Label
			auto_wide_tocontents    1
			labelText				"STOCKS"
			visible                 0
			zpos 25
			tall					40
			fontHeight				20
			font					TitleBoldFont
			fgcolor_override		"255 255 255 255"
		
			ypos                    0
			xpos					0
		}
		MagsButton
		{
			ControlName				RuiButton
			InheritProperties		TabButton
			wide %7.5
			xpos                    0
			zpos 26
			visible 0
		}
		MagsText
		{
			ControlName				Label
			auto_wide_tocontents    1
			labelText				"MAGS"
			visible                 0
			zpos 25
			tall					40
			fontHeight				20
			font					TitleBoldFont
			fgcolor_override		"255 255 255 255"
		
			ypos                    0
			xpos					0
		}				
		//attachments box footer
		CloseButton
		{
			ControlName				RuiButton
			InheritProperties		TabButton
			wide %15
			xpos                    0
			ypos 0
			zpos 26
			visible 0
		}
}
