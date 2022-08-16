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

		ClickWeaponButton
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

			pin_to_sibling          DialogFrame
			pin_corner_to_sibling   TOP_LEFT
			pin_to_sibling_corner   TOP_LEFT
			visible                 0
		}
		
		// ClickWeapon
		// {
			// ControlName 				 RuiPanel 
			// rui 						 ui/basic_image.rpak 
			// wide 						 160 
			// tall 						 75 
			// xpos                    0
			// ypos                    -10
			// zpos                    9
			// pin_to_sibling          ClickWeaponButton
			// pin_corner_to_sibling   CENTER
			// pin_to_sibling_corner   CENTER
			
			// visible                 0
		// }

		ClickWeapon_Name
		{
			ControlName				Label
			wide                    224
			labelText				"Hitscan"
			visible                 1
			zpos 5
			fgcolor_override		"2 252 240 255"
			ypos                    0
			xpos					65
			fontHeight				35
			pin_to_sibling          ClickWeaponButton
			pin_corner_to_sibling   CENTER
			pin_to_sibling_corner   CENTER
			
			visible                 0
		}
		HitscanAutoButton
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
			pin_to_sibling          ClickWeaponButton
			pin_corner_to_sibling   TOP_LEFT
			pin_to_sibling_corner   TOP_RIGHT
		}
		
		// HitscanAuto
		// {
			// ControlName 				 RuiPanel 
			// rui 						 ui/basic_image.rpak 
			// wide 						 160 
			// tall 						 75 
			// xpos                    0
			// ypos                    -10
			// zpos                    5
			// pin_to_sibling          HitscanAutoButton
			// pin_corner_to_sibling   CENTER
			// pin_to_sibling_corner   CENTER
		// }

		HitscanAuto_Name
		{
			ControlName				Label
			wide                    224
			labelText				"Hitscan Auto"
			visible                 1
			zpos 5
			fgcolor_override		"2 252 240 255"
			xpos					40
			ypos                    0
			fontHeight				35
			pin_to_sibling          HitscanAutoButton
			pin_corner_to_sibling   CENTER
			pin_to_sibling_corner   CENTER
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
}
