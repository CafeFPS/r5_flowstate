// 512x512
vgui_titan_threat.res
{
	MinimapCockpitScreen
	{
		ControlName			CMapOverview

		xpos				0
		ypos				32
		wide				512
		tall				512
		visible				1
		scaleImage			1
		zpos				2

		// CMapOverview specific
		displayDistScalar			1
		circular					0
		clampToEdgeScale			0.908
		hostileFiringFadeOut 		4.0 // fade out time for shots/doublejump pings
		hostileFiringColor			"255 21 0 255"
		cloakedPlayerFadeOut		1
		localPlayerIcon				"vgui/HUD/compass_icon_you"
		localPlayerIconScale		0.1
		mapTextureAlpha				.7
		pingIconMaxScale			0.12
		heightArrowFriendlyIcon		"vgui/HUD/threathud_arrow_friendly"
		heightArrowEnemyIcon		"vgui/HUD/threathud_arrow_enemy"
		heightArrowNeutralIcon		"vgui/HUD/threathud_arrow_neutral"
		heightArrowDistanceThres	120
		heightArrowRatioThres		0.35
		heightArrowIconScale		0.025
	}

	// 56
	// 88

	MinimapBG
	{
		ControlName			ImagePanel
		xpos				0
		ypos				0
		wide				710
		tall				914
		visible				0
		image				vgui/HUD/minimap_bg
		scaleImage			1
		drawColor			"255 255 255 255"

		zpos				4

		pin_to_sibling				MinimapCockpitScreen
		pin_corner_to_sibling		CENTER
		pin_to_sibling_corner		CENTER
	}

	MinimapFG
	{
		ControlName			ImagePanel
		xpos				0
		ypos				0
		wide				710
		tall				914
		visible				0
		image				vgui/HUD/minimap_shape
		scaleImage			1
		drawColor			"255 255 255 255"

		zpos				16

		pin_to_sibling				MinimapCockpitScreen
		pin_corner_to_sibling		CENTER
		pin_to_sibling_corner		CENTER
	}

	MinimapCompass
	{
		ControlName			ImagePanel
		xpos				6
		ypos				0
		wide				500
		tall				64
		visible				0
		image				vgui/HUD/compass_ticker
		scaleImage			1
		drawColor			"119 148 169 255"

		zpos				6

	}
}

// 36 182 16