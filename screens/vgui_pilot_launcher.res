// ========= Pilot Launcher (LAW/SRAM) screen =========
vgui_pilot_launcher.res
{
	VGUI_PilotLauncher_TargetName
	{
		ControlName			Label
		xpos				100
		ypos				101
		wide				562
		tall				49
		visible				0
		enable				1
		labelText			"[Target Name]"
		font				Default_55_Responsive
		textAlignment		west
		zpos				9
	}

	VGUI_PilotLauncher_Range
	{
		ControlName			Label
		xpos				104
		ypos				160
		wide				562
		tall				49
		visible				0
		enable				1
		labelText			"0000m"
		font				Default_55_Responsive
		textAlignment		west
		zpos				9
	}

	VGUI_PilotLauncher_LockStatus
	{
		ControlName			Label
		xpos				247
		ypos				850
		wide				899
		tall				90
		visible				0
		enable				1
		labelText			"[LOCK STATUS]"
		font				Default_69_Responsive
		textAlignment		center
		zpos				9
	}

	VGUI_PilotLauncher_Ammo_Label
	{
		ControlName			Label
		xpos				0
		ypos				924
		wide				315
		tall				56
		visible				0
		enable				1
		labelText			"[AMMO]"
		font				Default_69_Responsive
		textAlignment		center
		zpos				9
	}

	VGUI_PilotLauncher_AmmoIcon0
	{
		ControlName			ImagePanel
		xpos				320
		ypos				800
		wide				72
		tall				144
		visible				1
		image				vgui/HUD/sram/sram_rocket_icon
		scaleImage			1
		zpos				9
	}

	VGUI_PilotLauncher_AmmoIcon1
	{
		ControlName			ImagePanel
		xpos				266
		ypos				800
		wide				72
		tall				144
		visible				1
		image				vgui/HUD/sram/sram_rocket_icon
		scaleImage			1
		zpos				9
	}

	VGUI_PilotLauncher_AmmoIcon2
	{
		ControlName			ImagePanel
		xpos				212
		ypos				800
		wide				72
		tall				144
		visible				1
		image				vgui/HUD/sram/sram_rocket_icon
		scaleImage			1
		zpos				9
	}

	VGUI_PilotLauncher_AmmoIcon3
	{
		ControlName			ImagePanel
		xpos				158
		ypos				800
		wide				72
		tall				144
		visible				1
		image				vgui/HUD/sram/sram_rocket_icon
		scaleImage			1
		zpos				9
	}

	VGUI_PilotLauncher_AmmoIcon4
	{
		ControlName			ImagePanel
		xpos				104
		ypos				800
		wide				72
		tall				144
		visible				1
		image				vgui/HUD/sram/sram_rocket_icon
		scaleImage			1
		zpos				9
	}

	VGUI_PilotLauncher_AmmoIcon5
	{
		ControlName			ImagePanel
		xpos				50
		ypos				800
		wide				72
		tall				144
		visible				1
		image				vgui/HUD/sram/sram_rocket_icon
		scaleImage			1
		zpos				9
	}

	VGUI_PilotLauncher_Ticker
	{
		ControlName			ImagePanel
		xpos				45
		ypos				0
		wide				899
		tall				112
		visible				1
		image				vgui/HUD/sram/sram_ticker
		scaleImage			4
		zpos				10
	}

	VGUI_PilotLauncher_Ticker_Extra
	{
		ControlName			ImagePanel
		xpos				944
		ypos				0
		wide				899
		tall				112
		visible				1
		image				vgui/HUD/sram/sram_ticker
		scaleImage			4
		zpos				10
	}

	VGUI_PilotLauncher_TargetingCircle
	{
		ControlName			ImagePanel
		xpos				697
		ypos				483
		wide				90
		tall				79
		visible				0
		image				vgui/HUD/sram/sram_targeting_circle
		scaleImage			1.0
		zpos				10
	}

	VGUI_PilotLauncher_TargetingRing_Inner
	{
		ControlName			ImagePanel
		xpos				0
		ypos				0
		wide				337
		tall				337
		visible				0
		image				vgui/HUD/sram/sram_targeting_inner_ring
		scaleImage			1.0
		zpos				11
	}

	VGUI_PilotLauncher_TargetingRing_Outer
	{
		ControlName			ImagePanel
		xpos				0
		ypos				0
		wide				337
		tall				337
		visible				0
		image				vgui/HUD/sram/sram_targeting_outer_ring
		scaleImage			1.0
		zpos				11
	}
}