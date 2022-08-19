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

		P2020Button
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
		
		P2020
		{
			ControlName 				 RuiPanel 
			rui 						 ui/basic_image.rpak 
			wide 						 160 
			tall 						 75 
			xpos                    0
			ypos                    -10
			zpos                    5
			pin_to_sibling          P2020Button
			pin_corner_to_sibling   CENTER
			pin_to_sibling_corner   CENTER
		}

		P2020_Name
		{
			ControlName				Label
			wide                    224
			labelText				"P2020"
			visible                 1
			zpos 5
			fgcolor_override		"2 252 240 255"
			ypos                                       20
			xpos					100
			fontHeight				35
			pin_to_sibling          P2020
			pin_corner_to_sibling   BOTTOM_RIGHT
			pin_to_sibling_corner   BOTTOM_RIGHT
		}
		MozambiqueButton
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
			pin_to_sibling          P2020Button
			pin_corner_to_sibling   TOP_LEFT
			pin_to_sibling_corner   TOP_RIGHT
		}
		
		Mozambique
		{
			ControlName 				 RuiPanel 
			rui 						 ui/basic_image.rpak 
			wide 						 160 
			tall 						 75 
			xpos                    0
			ypos                    -10
			zpos                    5
			pin_to_sibling          MozambiqueButton
			pin_corner_to_sibling   CENTER
			pin_to_sibling_corner   CENTER
		}

		Mozambique_Name
		{
			ControlName				Label
			wide                    224
			labelText				"Mozambique"
			visible                 1
			zpos 5
			fgcolor_override		"2 252 240 255"
			ypos                                       20
			xpos					80
			fontHeight				35
			pin_to_sibling          Mozambique
			pin_corner_to_sibling   BOTTOM_RIGHT
			pin_to_sibling_corner   BOTTOM_RIGHT
		}
		WingmanButton
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
			pin_to_sibling          MozambiqueButton
			pin_corner_to_sibling   TOP_LEFT
			pin_to_sibling_corner   TOP_RIGHT
		}
		
		Wingman
		{
			ControlName 				 RuiPanel 
			rui 						 ui/basic_image.rpak 
			wide 						 160 
			tall 						 75 
			xpos                    0
			ypos                    -10
			zpos                    5
			pin_to_sibling          WingmanButton
			pin_corner_to_sibling   CENTER
			pin_to_sibling_corner   CENTER
		}

		Wingman_Name
		{
			ControlName				Label
			wide                    224
			labelText				"Wingman"
			visible                 1
			zpos 5
			fgcolor_override		"2 252 240 255"
			ypos                                       20
			xpos					90
			fontHeight				35
			pin_to_sibling          Wingman
			pin_corner_to_sibling   BOTTOM_RIGHT
			pin_to_sibling_corner   BOTTOM_RIGHT
		}
	
		RE45Button
		{
			"ControlName"				"RuiButton"
			"rui"						"ui/generic_friend_button.rpak"
			wide					200
			tall					150
			"visible"					"1"
			"sound_accept"				"ui_rankedsummary_circletick_reached"
			"sound_focus"				"UI_Menu_Focus_Small"
			xpos                    0
			ypos                    60
			zpos                    5
			rightClickEvents        1
			pin_to_sibling          P2020
			pin_corner_to_sibling   TOP
			pin_to_sibling_corner   BOTTOM
		}
		
		RE45
		{
			ControlName 				 RuiPanel 
			rui 						 ui/basic_image.rpak 
			wide 						 160 
			tall 						 75 
			xpos                    0
			ypos                    -10
			zpos                    5
			pin_to_sibling          RE45Button
			pin_corner_to_sibling   CENTER
			pin_to_sibling_corner   CENTER
		}

		RE45_Name
		{
			ControlName				Label
			wide                    224
			labelText				"RE-45"
			visible                 1
			zpos 5
			fgcolor_override		"2 252 240 255"
			ypos                                       20
			xpos					110
			fontHeight				35
			pin_to_sibling          RE45
			pin_corner_to_sibling   BOTTOM_RIGHT
			pin_to_sibling_corner   BOTTOM_RIGHT
		}

		EVA8Button
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
			pin_to_sibling          RE45Button
			pin_corner_to_sibling   TOP_LEFT
			pin_to_sibling_corner   TOP_RIGHT
		}
		
		EVA8
		{
			ControlName 				 RuiPanel 
			rui 						 ui/basic_image.rpak 
			wide 						 160 
			tall 						 75 
			xpos                    0
			ypos                    -10
			zpos                    5
			pin_to_sibling          EVA8Button
			pin_corner_to_sibling   CENTER
			pin_to_sibling_corner   CENTER
		}

		EVA8_Name
		{
			ControlName				Label
			wide                    224
			labelText				"EVA-8"
			visible                 1
			zpos 5
			fgcolor_override		"2 252 240 255"
			ypos                                       20
			xpos					100
			fontHeight				35
			pin_to_sibling          EVA8
			pin_corner_to_sibling   BOTTOM_RIGHT
			pin_to_sibling_corner   BOTTOM_RIGHT
		}

		MastiffButton
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
			pin_to_sibling          EVA8Button
			pin_corner_to_sibling   TOP_LEFT
			pin_to_sibling_corner   TOP_RIGHT
		}
		
		Mastiff
		{
			ControlName 				 RuiPanel 
			rui 						 ui/basic_image.rpak 
			wide 						 160 
			tall 						 75 
			xpos                    0
			ypos                    -10
			zpos                    5
			pin_to_sibling          MastiffButton
			pin_corner_to_sibling   CENTER
			pin_to_sibling_corner   CENTER
		}

		Mastiff_Name
		{
			ControlName				Label
			wide                    224
			labelText				"Mastiff"
			visible                 1
			zpos 5
			fgcolor_override		"2 252 240 255"
			ypos                                       20
			xpos					105
			fontHeight				35
			pin_to_sibling          Mastiff
			pin_corner_to_sibling   BOTTOM_RIGHT
			pin_to_sibling_corner   BOTTOM_RIGHT
		}
		
		PeacekeeperButton
		{
			"ControlName"				"RuiButton"
			"rui"						"ui/generic_friend_button.rpak"
			wide					200
			tall					150
			"visible"					"1"
			"sound_accept"				"ui_rankedsummary_circletick_reached"
			"sound_focus"				"UI_Menu_Focus_Small"
			xpos                    0
			ypos                    60
			zpos                    5
			rightClickEvents        1
			pin_to_sibling          RE45
			pin_corner_to_sibling   TOP
			pin_to_sibling_corner   BOTTOM
		}
		
		Peacekeeper
		{
			ControlName 				 RuiPanel 
			rui 						 ui/basic_image.rpak 
			wide 						 160 
			tall 						 75 
			xpos                    0
			ypos                    -10
			zpos                    5
			pin_to_sibling          PeacekeeperButton
			pin_corner_to_sibling   CENTER
			pin_to_sibling_corner   CENTER
		}

		Peacekeeper_Name
		{
			ControlName				Label
			wide                    224
			labelText				"Peacekeeper"
			visible                 1
			zpos 5
			fgcolor_override		"2 252 240 255"
			ypos                                       20
			xpos					75
			fontHeight				35
			pin_to_sibling          Peacekeeper
			pin_corner_to_sibling   BOTTOM_RIGHT
			pin_to_sibling_corner   BOTTOM_RIGHT
		}
	
		// MastiffButton
		// {
			// "ControlName"				"RuiButton"
			// "rui"						"ui/generic_friend_button.rpak"
			// wide					200
			// tall					150
			// "visible"					"1"
			// "sound_accept"				"ui_rankedsummary_circletick_reached"
			// "sound_focus"				"UI_Menu_Focus_Small"
			// xpos                    100
			// ypos                    0
			// zpos                    5
			// rightClickEvents        1
			// pin_to_sibling          EVA8Button
			// pin_corner_to_sibling   TOP_LEFT
			// pin_to_sibling_corner   TOP_RIGHT
		// }
		
		// Mastiff
		// {
			// ControlName 				 RuiPanel 
			// rui 						 ui/basic_image.rpak 
			// wide 						 160 
			// tall 						 75 
			// xpos                    0
			// ypos                    -10
			// zpos                    5
			// pin_to_sibling          MastiffButton
			// pin_corner_to_sibling   CENTER
			// pin_to_sibling_corner   CENTER
		// }

		// Mastiff_Name
		// {
			// ControlName				Label
			// wide                    224
			// labelText				"Mastiff"
			// visible                 1
			// zpos 5
			// fgcolor_override		"2 252 240 255"
			// ypos                                       20
			// xpos					100
			// fontHeight				35
			// pin_to_sibling          Mastiff
			// pin_corner_to_sibling   BOTTOM_RIGHT
			// pin_to_sibling_corner   BOTTOM_RIGHT
		// }

		// PeacekeeperButton
		// {
			// "ControlName"				"RuiButton"
			// "rui"						"ui/generic_friend_button.rpak"
			// wide					200
			// tall					150
			// "visible"					"1"
			// "sound_accept"				"ui_rankedsummary_circletick_reached"
			// "sound_focus"				"UI_Menu_Focus_Small"
			// xpos                    100
			// ypos                    0
			// zpos                    5
			// rightClickEvents        1
			// pin_to_sibling          MastiffButton
			// pin_corner_to_sibling   TOP_LEFT
			// pin_to_sibling_corner   TOP_RIGHT
		// }
		
		// Peacekeeper
		// {
			// ControlName 				 RuiPanel 
			// rui 						 ui/basic_image.rpak 
			// wide 						 160 
			// tall 						 75 
			// xpos                    0
			// ypos                    -10
			// zpos                    5
			// pin_to_sibling          PeacekeeperButton
			// pin_corner_to_sibling   CENTER
			// pin_to_sibling_corner   CENTER
		// }

		// Peacekeeper_Name
		// {
			// ControlName				Label
			// wide                    224
			// labelText				"Peacekeeper"
			// visible                 1
			// zpos 5
			// fgcolor_override		"2 252 240 255"
			// ypos                                       20
			// xpos					75
			// fontHeight				35
			// pin_to_sibling          Peacekeeper
			// pin_corner_to_sibling   BOTTOM_RIGHT
			// pin_to_sibling_corner   BOTTOM_RIGHT
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
		//shotgun bolts!
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
			wide %8.33
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
			wide %8.33
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
			wide %8.33
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
			wide %8.33
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
			wide %8.33
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
