#base "HudWeapons.res"
#base "MPPrematch.res"
#base "HUDDev.res"
#base "HudDeathRecap.res"
#base "DebugOverlays.res"
#base "flowstate_customhudvgui.res"

Resource/UI/HudScripted_mp.res
{
	Screen
	{
		ControlName		ImagePanel
		wide			%100
		tall			%100
		visible			1
		scaleImage		1
		fillColor		"0 0 0 0"
		drawColor		"0 0 0 0"
	}

	SafeArea
	{
		ControlName		ImagePanel
		wide			%90
		tall			%70
		visible			1
		scaleImage		1
		fillColor		"0 0 0 0"
		drawColor		"0 0 0 0"

		pin_to_sibling				Screen
		pin_corner_to_sibling		CENTER
		pin_to_sibling_corner		CENTER
	}

	SafeAreaCenter
	{
		ControlName		ImagePanel
		wide			%90
		tall			%90
		visible			1
		scaleImage		1
		fillColor		"0 0 0 0"
		drawColor		"0 0 0 0"

		pin_to_sibling				Screen
		pin_corner_to_sibling		CENTER
		pin_to_sibling_corner		CENTER
	}

	Scoreboard
	{
		ControlName			CNestedPanel
		xpos				0
		ypos				0
		wide				%100
		tall				%100
		visible				0

		zpos				4000

		controlSettingsFile	"resource/UI/HudScoreboard.res"
	}

	OutOfBoundsWarning_Anchor
	{
		ControlName				Label
		xpos					c-2
		ypos					c-45
		wide					4
		tall					4
		visible					0
		enabled					1
		labelText				""
		textAlignment			center
		fgcolor_override 		"255 255 0 255"
		font					Default_34_ShadowGlow
	}

	OutOfBoundsWarning_Message
	{
		ControlName				Label
		xpos					0
		ypos					0
		wide					674
		tall					45
		visible					0
		enabled					1
		auto_wide_tocontents	1
		labelText				"#OUT_OF_BOUNDS_WARNING"
		textAlignment			center
		fgcolor_override 		"255 255 0 255"
		bgcolor_override 		"0 0 0 200"
		font					Default_34_ShadowGlow

		pin_to_sibling			OutOfBoundsWarning_Anchor
		pin_corner_to_sibling	TOP
		pin_to_sibling_corner	BOTTOM
	}

	OutOfBoundsWarning_Timer
	{
		ControlName				Label
		xpos					0
		ypos					0
		wide					674
		tall					45
		visible					0
		enabled					1
		auto_wide_tocontents	1
		labelText				":00"
		textAlignment			center
		fgcolor_override 		"255 255 0 255"
		bgcolor_override 		"0 0 0 200"
		font					Default_34_ShadowGlow

		pin_to_sibling			OutOfBoundsWarning_Message
		pin_corner_to_sibling	TOP
		pin_to_sibling_corner	BOTTOM
	}

	ShoutOutAnchor
	{
		ControlName		ImagePanel
		xpos			c-0
		ypos			c-405
		wide			0
		tall			0
		visible			1
		scaleImage		1

		zpos			5
	}

	EventNotification
	{
		ControlName				Label
		xpos					0
		ypos					150
		wide					899
		tall					67
		visible					0
		font					Default_27_ShadowGlow
		labelText				"Something is going on!"
		textAlignment			center
		auto_wide_tocontents	1
		fgcolor_override 		"255 255 255 255"
		allCaps					1

		zpos			1000

		pin_to_sibling				ShoutOutAnchor
		pin_corner_to_sibling		CENTER
		pin_to_sibling_corner		CENTER
	}

	IngameTextChat
	{
		ControlName				CBaseHudChat
		InheritProperties		ChatBox

		destination				"match"

		visible 				0

		pin_to_sibling			Screen
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
		xpos					-48 [$PC]
		xpos					%-5 [!$PC]
		ypos					-512
		zpos                    9999
	}

    AccessibilityHint
    {
        ControlName             RuiPanel
        classname               "MenuButton"
        ypos                    12
        wide                    300
        tall                    40
        visible                 0

        rui                     "ui/accessibility_hint.rpak"

        ruiArgs
        {
            buttonText          "#INGAME_ACCESSIBILITY_CHAT_HINT" [!$PC]
            buttonText          "#INGAME_ACCESSIBILITY_CHAT_HINT_PC" [$PC] // controller chat option only on console
            buttonTextPC        "#INGAME_ACCESSIBILITY_CHAT_HINT_PC"
        }

        pin_to_sibling			IngameTextChat
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

	HudCheaterMessage
	{
		ControlName			Label
		font				Default_34_ShadowGlow
		labelText			"#FAIRFIGHT_CHEATER"
		visible				0
		enabled				1
		fgcolor_override 	"255 255 255 205"
		zpos				10
		wide				450
		tall				58
		textAlignment		center

		pin_to_sibling				SafeArea
		pin_corner_to_sibling		TOP
		pin_to_sibling_corner		TOP
	}

	EMPScreenFX
	{
		ControlName		ImagePanel
		xpos 			0
		ypos 			0
		zpos			-1000
		wide			%100
		tall			%100
		visible			0
		scaleImage		1
		image			vgui/HUD/pilot_flashbang_overlay
		drawColor		"255 255 255 64"

		pin_to_sibling				Screen
		pin_corner_to_sibling		CENTER
		pin_to_sibling_corner		CENTER
	}

    NotificationBox
    {
        ControlName		RuiPanel
        wide			680
        tall			140
        visible			0
        enabled         0
        rui                     "ui/notification_box.rpak"

		pin_to_sibling				Screen
		pin_corner_to_sibling		BOTTOM
		pin_to_sibling_corner		BOTTOM
    }
 
// Movement Gym related-------------------------------------------------------------------------------- 
	MG_Style_Pin
	{
			ControlName				Label
			wide					300
			tall					40
			ypos					-150
			xpos					-50
			visible					0
			drawColor				"0 0 255 100"
			pin_to_sibling				Screen
			pin_corner_to_sibling			BOTTOM_LEFT
			pin_to_sibling_corner			BOTTOM_LEFT
	}
	
	
	MG_Style_Label
	{
		ControlName			Label
		font					"DefaultBold_62_DropShadow"
		allcaps					1
		auto_wide_tocontents			1
		labelText			" "
		visible				0
		enabled				1
		fgcolor_override 	"255 255 255 205"
		ypos					-30
		xpos					0
		wide				500
		tall				50
		fontHeight				60

		pin_to_sibling			MG_Style_Pin
		pin_corner_to_sibling		LEFT
		pin_to_sibling_corner		LEFT
	}
	
	MG_Style_History_Superglide
	{
		ControlName			Label
		font					"DefaultBold_62_DropShadow"
		allcaps					0
		auto_wide_tocontents			1
		labelText			" "
		visible				0
		enabled				1
		fgcolor_override 	"255 255 255 205"
		ypos					-90
		xpos					0
		wide				500
		tall				50
		fontHeight				40

		pin_to_sibling			MG_Style_Pin
		pin_corner_to_sibling		LEFT
		pin_to_sibling_corner		LEFT
	}
	
	MG_Style_History_Wallrun
	{
		ControlName			Label
		font					"DefaultBold_62_DropShadow"
		allcaps					0
		auto_wide_tocontents			1
		labelText			" "
		visible				0
		enabled				1
		fgcolor_override 	"255 255 255 205"
		ypos					-130
		xpos					0
		wide				500
		tall				50
		fontHeight				40

		pin_to_sibling			MG_Style_Pin
		pin_corner_to_sibling		LEFT
		pin_to_sibling_corner		LEFT
	}
	
	MG_Style_History_Slide
	{
		ControlName			Label
		font					"DefaultBold_62_DropShadow"
		allcaps					0
		auto_wide_tocontents			1
		labelText			" "
		visible				0
		enabled				1
		fgcolor_override 	"255 255 255 205"
		ypos					-170
		xpos					0
		wide				500
		tall				50
		fontHeight				40

		pin_to_sibling			MG_Style_Pin
		pin_corner_to_sibling		LEFT
		pin_to_sibling_corner		LEFT
	}
	
	MG_Style_History_Speed
	{
		ControlName			Label
		font					"DefaultBold_62_DropShadow"
		allcaps					0
		auto_wide_tocontents			1
		labelText			" "
		visible				0
		enabled				1
		fgcolor_override 	"255 255 255 205"
		ypos					-210
		xpos					0
		wide				500
		tall				50
		fontHeight				40

		pin_to_sibling			MG_Style_Pin
		pin_corner_to_sibling		LEFT
		pin_to_sibling_corner		LEFT
	}
	
	MG_Style_Bar
	{
		ControlName				RuiPanel
		wide					500
		tall					25
		xpos					0
		ypos					0
		visible					0
		rui                     "ui/basic_image.rpak"

		ruiArgs
		{
			basicImageColor     "0 0 255"
			basicImageAlpha     0.5
		}
			pin_to_sibling				MG_Style_Pin
			pin_corner_to_sibling			LEFT
			pin_to_sibling_corner			LEFT
	}
	
	MG_StopWatch_Pin
	{
			ControlName				Label
			wide					300
			tall					40
			ypos					-150
			visible					0
			drawColor				"0 0 255 100"
			pin_to_sibling				Screen
			pin_corner_to_sibling			BOTTOM
			pin_to_sibling_corner			BOTTOM
	}
	
	MG_StopWatch
	{
			ControlName				Label
			xpos                    		105
			ypos					0
			zpos 					0
			auto_wide_tocontents			1
			tall					30
			visible					0
			fontHeight				30
			labelText				"0:00"
			font					"DefaultBold_62_DropShadow"
			allcaps					1
			fgcolor_override			"255 255 0 255"
			pin_to_sibling				MG_StopWatch_Label
			pin_corner_to_sibling			CENTER
			pin_to_sibling_corner			CENTER
	}
	
	MG_StopWatch_Label
	{
			ControlName				Label
			xpos                    		0
			ypos					0
			zpos 					0
			auto_wide_tocontents			1
			tall					30
			visible					0
			fontHeight				30
			labelText				"Current Time: "
			font					"DefaultBold_62_DropShadow"
			allcaps					1
			fgcolor_override			"255 255 255 255"
			pin_to_sibling				MG_StopWatch_Pin
			pin_corner_to_sibling			CENTER
			pin_to_sibling_corner			CENTER
	}
	
	MG_StopWatch_Frame
	{
			ControlName				RuiPanel
			wide					375
			tall					45
			ypos					0
			visible					0
			rui                     "ui/basic_image.rpak"

		ruiArgs
		{
			basicImageColor     "0 0 255"
			basicImageAlpha     0.5
			basicImage "rui/hud/ko_shield_hud/ko_shield_bg_0"
		}
			pin_to_sibling				MG_StopWatch_Pin
			pin_corner_to_sibling			CENTER
			pin_to_sibling_corner			CENTER
	}
	
	MG_StopWatch_Icon
	{
		ControlName				RuiPanel
		wide					33
		tall					33
		visible					0
		enabled					0
		rui                     "ui/basic_image.rpak"
		
		ypos 					0
		xpos 					-105
		zpos					0
		
		ruiArgs
		{
			basicImage "rui/flowstatecustom/dea/stopwatch"
			basicImageAlpha     1.0
		}
		pin_to_sibling          MG_StopWatch_Label
		pin_corner_to_sibling   CENTER
		pin_to_sibling_corner   CENTER
	}
	
	MG_Speedometer_Pin
	{
			ControlName				Label
			wide					100
			tall					80
			ypos					-150
			xpos					-150
			zpos					0
			visible					0
			drawColor				"0 0 255 100"
			pin_to_sibling				Screen
			pin_corner_to_sibling			BOTTOM_RIGHT
			pin_to_sibling_corner			BOTTOM_RIGHT
	}
	
	MG_Speedometer_kmh
	{
			ControlName				Label
			xpos                    		0
			ypos					3
			zpos 					0
			auto_wide_tocontents			1
			tall					170
			visible					0
			fontHeight				80
			labelText				""
			font					"DefaultBold_62_DropShadow"
			allcaps					1
			textAlignment				right
			fgcolor_override			"255 255 255 255"
			pin_to_sibling				MG_Speedometer_Pin
			pin_corner_to_sibling			RIGHT
			pin_to_sibling_corner			RIGHT
	}
	
	MG_Speedometer_mph
	{
			ControlName				Label
			xpos                    		0
			ypos					3
			zpos 					0
			auto_wide_tocontents			1
			tall					170
			visible					0
			fontHeight				80
			labelText				""
			font					"DefaultBold_62_DropShadow"
			allcaps					1
			textAlignment				right
			fgcolor_override			"255 255 255 255"
			pin_to_sibling				MG_Speedometer_Pin
			pin_corner_to_sibling			RIGHT
			pin_to_sibling_corner			RIGHT
	}
	
	MG_Speedometer_Icon
	{
		ControlName				RuiPanel
		wide					70
		tall					70
		visible					0
		enabled					0
		rui                     "ui/basic_image.rpak"
		
		ypos 					0
		xpos 					75
		zpos					0
		
		ruiArgs
		{
			basicImage "rui/hud/gamestate/net_latency"
		}
		pin_to_sibling          MG_Speedometer_Pin
		pin_corner_to_sibling   RIGHT
		pin_to_sibling_corner   RIGHT
	}
	
	MG_MO_Pin
	{
		ControlName				Label
		wide					100
		tall					100
		ypos					-50
		xpos					13
		zpos					0
		visible					0
		drawColor				"0 0 0 0"
		pin_to_sibling				Screen
		pin_corner_to_sibling			BOTTOM
		pin_to_sibling_corner			BOTTOM
	}

	MG_MO_W
	{
		ControlName				Label
		xpos                    		0
		ypos					0
		zpos 					0
		tall					30
		visible					0
		fontHeight				30
		textAlignment				left
		labelText				"%$vgui/fonts/buttons/icon_unbound%"
		font					"DefaultBold_62_DropShadow"
		fgcolor_override			"255 255 255 255"
		pin_to_sibling				MG_MO_Pin
		pin_corner_to_sibling			CENTER
		pin_to_sibling_corner			CENTER
	}
	
	MG_MO_A
	{
		ControlName				Label
		xpos                    		-30
		ypos					30
		zpos 					0
		tall					30
		visible					0
		fontHeight				30
		textAlignment				left
		labelText				"%$vgui/fonts/buttons/icon_unbound%"
		font					"DefaultBold_62_DropShadow"
		fgcolor_override			"255 255 255 255"
		pin_to_sibling				MG_MO_Pin
		pin_corner_to_sibling			CENTER
		pin_to_sibling_corner			CENTER
	}
	
	MG_MO_S
	{
		ControlName				Label
		xpos                    		0
		ypos					30
		zpos 					0
		tall					30
		visible					0
		fontHeight				30
		textAlignment				left
		labelText				"%$vgui/fonts/buttons/icon_unbound%"
		font					"DefaultBold_62_DropShadow"
		fgcolor_override			"255 255 255 255"
		pin_to_sibling				MG_MO_Pin
		pin_corner_to_sibling			CENTER
		pin_to_sibling_corner			CENTER
	}
	
	MG_MO_D
	{
		ControlName				Label
		xpos                    		30
		ypos					30
		zpos 					0
		tall					30
		visible					0
		fontHeight				30
		textAlignment				left
		labelText				"%$vgui/fonts/buttons/icon_unbound%"
		font					"DefaultBold_62_DropShadow"
		fgcolor_override			"255 255 255 255"
		pin_to_sibling				MG_MO_Pin
		pin_corner_to_sibling			CENTER
		pin_to_sibling_corner			CENTER
	}
	
	MG_MO_CTRL
	{
		ControlName				Label
		xpos                    		-45
		ypos					60
		zpos 					0
		tall					30
		visible					0
		fontHeight				30
		textAlignment				left
		labelText				" "
		font					"DefaultBold_62_DropShadow"
		fgcolor_override			"255 255 255 255"
		pin_to_sibling				MG_MO_Pin
		pin_corner_to_sibling			CENTER
		pin_to_sibling_corner			CENTER
	}
	
	MG_MO_SPACE
	{
		ControlName				Label
		xpos                    		15
		ypos					60
		zpos 					0
		tall					30
		visible					0
		fontHeight				30
		textAlignment				left
		labelText				" "
		font					"DefaultBold_62_DropShadow"
		fgcolor_override			"255 255 255 255"
		pin_to_sibling				MG_MO_Pin
		pin_corner_to_sibling			CENTER
		pin_to_sibling_corner			CENTER
	}
}