///////////////////////////////////////////////////////////
// Tracker scheme resource file
//
// sections:
//		Colors			- all the colors used by the scheme
//		BaseSettings	- contains settings for app to use to draw controls
//		Fonts			- list of all the fonts used by app
//		Borders			- description of all the borders
//
///////////////////////////////////////////////////////////
Scheme
{
	//////////////////////// COLORS ///////////////////////////
	// color details
	// this is a list of all the colors used by the scheme
	Colors
	{
		// base colors
		Orange						"178 82 22 255"
		White						"255 255 255 255"
		Red							"192 28 0 140"
		Blue						"0 28 162 140"
		Yellow						"251 235 202 255"
		Black						"46 43 42 255" //"0 0 0 255" Changed black to a NTSC safe color
		TransparentBlack			"0 0 0 196"
		Gray						"178 178 178 255"
		Blank						"0 0 0 0"
	}

	///////////////////// BASE SETTINGS ////////////////////////
	// default settings for all panels
	// controls use these to determine their settings
	BaseSettings
	{
		Label.TextDullColor				White
		Label.TextColor					White
		Label.TextBrightColor			White
		Label.SelectedTextColor			White
		Label.BgColor					Blank
		Label.FgColor					White
		Label.DisabledFgColor1			White
		Label.DisabledFgColor2			White

		Frame.TopBorderImage			"vgui/menu_backgroud_top"
		Frame.BottomBorderImage			"vgui/menu_backgroud_bottom"
		Frame.SmearColor				"0 0 0 180"

		FgColor							"248 255 248 200"
		BgColor							"39 63 82 0"

		Panel.FgColor					"248 255 248 200"
		Panel.BgColor					"39 63 82 0"

		// checkboxes and radio buttons
		BaseText						OffWhite
		BrightControlText				White
		CheckBgColor					TransparentBlack
		CheckButtonBorder1 				Border.Dark 		// the left checkbutton border
		CheckButtonBorder2  			Border.Bright		// the right checkbutton border
		CheckButtonCheck				White				// color of the check itself

		// HL1-style QuickHUD colors
		Yellowish						"255 160 0 255"
		Normal							"255 255 225 128"
		Caution							"255 48 0 255"

		// Top-left corner of the menu on the main screen
		Main.Menu.X						32
		Main.Menu.X_hidef				76
		Main.Menu.Y						340
		Main.Menu.Color					"168 97 64 255"
		Menu.TextColor					"0 0 0 255"
		Menu.BgColor					"125 125 125 255"

		ScrollBar.Wide					12

		ScrollBarButton.FgColor			Black
		ScrollBarButton.BgColor			Blank
		ScrollBarButton.ArmedFgColor	White
		ScrollBarButton.ArmedBgColor	Blank
		ScrollBarButton.DepressedFgColor White
		ScrollBarButton.DepressedBgColor Blank

		ScrollBarSlider.FgColor			"0 0 0 255"		// nob color
		ScrollBarSlider.BgColor			"0 0 0 40"		// slider background color
		ScrollBarSlider.NobFocusColor	White
		ScrollBarSlider.NobDragColor	White
		ScrollBarSlider.Inset			3
	}

	//////////////////////// FONTS /////////////////////////////

	BitmapFontFiles
	{
		ControllerButtons		"materials/vgui/fonts/controller_buttons.vbf"			[$DURANGO || $WINDOWS]
		ControllerButtons		"materials/vgui/fonts/controller_buttons_ps4.vbf"		[$PS4]
	}

	Fonts
	{
		// fonts are used in order that they are listed
		// fonts listed later in the order will only be used if they fulfill a range not already filled
		// if a font fails to load then the subsequent fonts will replace

		//////////////////////////////////// Font definitions referenced by code ////////////////////////////////////

		DebugFixed
		{
			1
			{
				name			"Lucida Console"
				tall			14
				antialias 		1
			}
		}

		DebugFixedSmall
		{
			1
			{
				name			"Lucida Console"
				tall			14
				antialias 		1
			}
		}

		DebugOverlay
		{
			1
			{
				name			"Lucida Console"
				tall			14
				antialias 		1
				outline 		1
			}
		}

		Default
		{
			1
			{
				name			Tahoma
				tall			20		[!$GAMECONSOLE]
				weight			700		[!$GAMECONSOLE]
				tall			31		[$GAMECONSOLE]
				weight			900		[$GAMECONSOLE]
				antialias 		1
			}
		}

		DefaultSmall
		{
			1
			{
				name			Tahoma
				tall			12
				weight			0
				range			"0x0000 0x017F"
				yres			"480 599"
			}
			2
			{
				name			Tahoma
				tall			13
				weight			0
				range			"0x0000 0x017F"
				yres			"600 767"
			}
			3
			{
				name			Tahoma
				tall			14
				weight			0
				range			"0x0000 0x017F"
				yres			"768 1023"
				antialias		1
			}
			4
			{
				name			Tahoma
				tall			20
				weight			0
				range			"0x0000 0x017F"
				yres			"1024 1199"
				antialias		1
			}
			5
			{
				name			Tahoma
				tall			24
				weight			0
				range			"0x0000 0x017F"
				yres			"1200 6000"
				antialias		1
			}
			6
			{
				name			Tahoma
				tall			12
				range 			"0x0000 0x00FF"
				weight			0
			}
		}

		DefaultVerySmall
		{
			1
			{
				name			Tahoma
				tall			12
				weight			0
				range			"0x0000 0x017F" //	Basic Latin, Latin-1 Supplement, Latin Extended-A
				yres			"480 599"
			}
			2
			{
				name			Tahoma
				tall			13
				weight			0
				range			"0x0000 0x017F" //	Basic Latin, Latin-1 Supplement, Latin Extended-A
				yres			"600 767"
			}
			3
			{
				name			Tahoma
				tall			14
				weight			0
				range			"0x0000 0x017F" //	Basic Latin, Latin-1 Supplement, Latin Extended-A
				yres			"768 1023"
				antialias		1
			}
			4
			{
				name			Tahoma
				tall			20
				weight			0
				range			"0x0000 0x017F" //	Basic Latin, Latin-1 Supplement, Latin Extended-A
				yres			"1024 1199"
				antialias		1
			}
			5
			{
				name			Tahoma
				tall			24
				weight			0
				range			"0x0000 0x017F" //	Basic Latin, Latin-1 Supplement, Latin Extended-A
				yres			"1200 6000"
				antialias		1
			}
			6
			{
				name			Tahoma
				tall			12
				range 			"0x0000 0x00FF"
				weight			0
			}
			7
			{
				name			Tahoma
				tall			11
				range 			"0x0000 0x00FF"
				weight			0
			}
		}

		HudNumbers
		{
			1
			{
				name			Default
				tall			111
				antialias 		1
				additive		1
			}
		}

		HudNumbersGlow
		{
			1
			{
				name			Default
				tall			111
				weight			0
				blur			2
				scanlines		2
				antialias 		1
				additive		1
			}
		}

		HudNumbersSmall
		{
			1
			{
				name			Default
				tall			55
				weight			1000
				additive		1
				antialias 		1
			}
		}

		// this is the symbol font
		Marlett
		{
			1
			{
				name			Marlett
				tall			14
				weight			0
				symbol			1
			}
		}

		// TODO: Code should be updated so this scales with resolution. On a 4k screen names get tiny.
		PlayerNames
		{
			1
			{
				name			Default
				tall			16
				antialias		1
			}
		}

		GameUIButtons
		{
			1
			{
				bitmap			1
				name			"ControllerButtons"
				scalex			0.843
				scaley			0.843
			}
		}

		GameUIButtonsTiny
		{
			1
			{
				bitmap		1
				name		ControllerButtons
				scalex		0.562
				scaley		0.562
			}
		}

		KillShotGlow
		{
			1
			{
				name			Default
				tall			43
				weight			0
				antialias		1
  				blur			2
  				additive		1
				scanlines		2
			}
		}

		HudFontMed
		{
			1
			{
				name			Default
				tall			31
				weight			100
				antialias		1
				shadowglow		7
			}
		}

		//////////////////////////////////// Default font variations ////////////////////////////////////

		Default_9
		{
			isproportional		only
			1
			{
				name			Default
				tall			9
				antialias		1
			}
		}
		Default_9_DropShadow
		{
			isproportional	only
			1
			{
				name			Default
				tall			9
				antialias 		1
				dropshadow		1
			}
		}
		Default_9_Additive_Blur_Scanlines
		{
			isproportional		only
			1
			{
				name			Default
				tall			9
				antialias		1
  				blur			2
  				additive		1
				scanlines		2
			}
		}

		Default_17
		{
			isproportional	only
			1
			{
				name			Default
				tall			17
				antialias 		1
			}
		}
		Default_17_ShadowGlow
		{
			1
			{
				name			Default
				tall			17
				antialias		1
				shadowglow		7
			}
		}

		Default_21
		{
			1
			{
				name			Default
				tall			21
				antialias		1
			}
		}
		Default_21_ShadowGlow
		{
			1
			{
				name			Default
				tall			21
				antialias		1
				shadowglow		7
			}
		}
		Default_21_Outline
		{
			1
			{
				name			Default
				tall			21
				antialias		1
				outline 		1
			}
		}
		Default_21_Italic
		{
			isproportional	only
			1
			{
				name			Default
				tall			21
				antialias 		1
				italic			1
			}
		}
		Default_21_ShadowGlow_Outline
		{
			1
			{
				name			Default
				tall			21
				antialias		1
				shadowglow 		7
				outline 		1
			}
		}

		Default_23_Additive
		{
			isproportional		only
			1
			{
				name			Default
				tall			23
				antialias 		1
				additive		1
			}
		}
		Default_23_ShadowGlow
		{
			isproportional		only
			1
			{
				name			Default
				tall			23
				antialias		1
				shadowglow		7
			}
		}
		Default_23_ShadowGlow_Outline
		{
			isproportional	only
			1
			{
				name			Default
				tall			23
				antialias		1
				outline 		1
				shadowglow 		7
			}
		}

		Default_27
		{
			isproportional	only
			1
			{
				name			Default
				tall			27
				antialias		1
			}
		}
		Default_27_ShadowGlow
		{
			1
			{
				name			Default
				tall			27
				antialias		1
				shadowglow		7
			}
		}
		Default_27_Outline
		{
			1
			{
				name			Default
				tall			27
				antialias		1
				outline 		1
			}
		}
		Default_27_ShadowGlow_Outline
		{
			1
			{
				name			Default
				tall			27
				antialias		1
				shadowglow 		7
				outline 		1
			}
		}
		Default_27_Additive_Blur
		{
			1
			{
				name			Default
				tall			27
				antialias		1
				blur			2
				additive		1
			}
		}

		Default_28_ShadowGlow
		{
			isproportional	only
			1
			{
				name			Default
				tall			28
				antialias		1
				shadowglow		4
			}
		}

		Default_29
		{
			isproportional	only
			1
			{
				name			Default
				tall			29
				antialias 		1
			}
		}

		Default_31
		{
			1
			{
				name			Default
				tall			31
				antialias		1
			}
		}
		Default_31_ShadowGlow
		{
			1
			{
				name			Default
				tall			31
				antialias		1
				shadowglow		7
			}
		}
		Default_31_ShadowGlow_Outline
		{
			1
			{
				name			Default
				tall			31
				antialias		1
				shadowglow		7
				outline 		1
			}
		}

		Default_34
		{
			isproportional		only
			1
			{
				name			Default
				tall			34
				antialias		1
			}
		}
		Default_34_ShadowGlow
		{
			1
			{
				name			Default
				tall			34
				antialias		1
				shadowglow		7
			}
		}
		Default_34_DropShadow
		{
			isproportional		only
			1
			{
				name			Default
				tall			34
				antialias		1
				dropshadow 		1
			}
		}
		Default_34_Italic
		{
			isproportional	only
			1
			{
				name			Default
				tall			34
				antialias 		1
				italic			1
			}
		}

		Default_39_ShadowGlow_Outline
		{
			1
			{
				name			Default
				tall			39
				antialias		1
				shadowglow		7
				outline 		1
			}
		}

		Default_41_DropShadow
		{
			isproportional	only
			1
			{
				name			Default
				tall			41
				antialias 		1
				dropshadow 		1
			}
		}

		Default_43
		{
			isproportional		only
			1
			{
				name			Default
				tall			43
				antialias		1
			}
		}

		Default_51_Outline_DropShadow
		{
			isproportional	only
			1
			{
				name			Default
				tall			51
				antialias 		1
				outline 		1
				dropshadow 		1
			}
		}

		Default_55_ShadowGlow
		{
			1
			{
				name			Default
				tall			55
				antialias		1
				shadowglow		7
			}
		}
		Default_55_Responsive
		{
			1
			{
				name			Default
				tall			55
				antialias		1
				shadowglow		7
				responsiveaa	1
			}
		}

		Default_69_ShadowGlow
		{
			1
			{
				name			Default
				tall			69
				antialias		1
				shadowglow		11
			}
		}
		Default_69_DropShadow
		{
			isproportional	only
			1
			{
				name			Default
				tall			69
				antialias 		1
				dropshadow		1
			}
		}
		Default_69_Outline_DropShadow
		{
			isproportional 	only
			1
			{
				name			Default
				tall			69
				antialias		1
				outline 		1
				dropshadow 		1
			}
		}
		Default_69_Responsive
		{
			1
			{
				name			Default
				tall			69
				antialias		1
				shadowglow		11
				responsiveaa	1
			}
		}

		Default_83_Additive
		{
			isproportional	only
			1
			{
				name			Default
				tall			83
				antialias 		1
				additive		1
			}
		}

		Default_92_DropShadow
		{
			isproportional	only
			1
			{
				name			Default
				tall			92
				antialias 		1
				dropshadow 		1
			}
		}

		//////////////////////////////////// Default bold font variations ////////////////////////////////////

		DefaultBold_11_DropShadow
		{
			isproportional	only
			1
			{
				name			DefaultBold
				tall			11
				antialias 		1
				dropshadow		1
			}
		}

		DefaultBold_17
		{
			isproportional	only
			1
			{
				name			DefaultBold
				tall			17
				antialias		1
			}
		}

		DefaultBold_21
		{
			isproportional	only
			1
			{
				name			DefaultBold
				tall			21
				antialias	    1
			}
		}

		DefaultBold_34
		{
			isproportional		only
			1
			{
				name			DefaultBold
				tall			34
				antialias		1
			}
		}

		DefaultBold_43
		{
			isproportional		only
			1
			{
				name			DefaultBold
				tall			43
				antialias		1
			}
		}

		DefaultBold_44_DropShadow
		{
			isproportional	only
			1
			{
				name			DefaultBold
				tall			44
				antialias 		1
				dropshadow		1
			}
		}

		DefaultBold_62_Outline
		{
			isproportional		only
			1
			{
				name			DefaultBold
				tall			62
				antialias		1
				outline 		1
			}
		}
		DefaultBold_62_DropShadow
		{
			isproportional	only
			1
			{
				name			DefaultBold
				tall			62
				antialias 		1
				dropshadow 		1
			}
		}

		//////////////////////////////////// Titanfall font variations ////////////////////////////////////

		Titanfall_48_Additive_Scanlines
		{
			isproportional		only
			1
			{
				name			Titanfall
				tall			48
				antialias 		1
				additive		1
				scanlines		2
			}
		}
		Titanfall_48_ShadowGlow_Scanlines
		{
			isproportional		only
			1
			{
				name			Titanfall
				tall			48
				antialias 		1
				shadowglow		7
				scanlines		2
			}
		}

		Titanfall_54_Additive_ShadowGlow_Scanlines
		{
			isproportional		only
			1
			{
				name			Titanfall
				tall			54
				antialias 		1
				additive		1
				shadowglow		7
				scanlines		2
			}
		}
		Titanfall_54_Scanlines
		{
			isproportional		only
			1
			{
				name			Titanfall
				tall			54
				antialias 		1
				scanlines		2
			}
		}
		Titanfall_54_ShadowGlow_Scanlines
		{
			isproportional		only
			1
			{
				name			Titanfall
				tall			54
				antialias 		1
				shadowglow		7
				scanlines		2
			}
		}

		Titanfall_72_Additive_Scanlines
		{
			isproportional		only
			1
			{
				name			Titanfall
				tall			72
				antialias 		1
				additive		1
				scanlines		2
			}
		}
		Titanfall_72_ShadowGlow_Scanlines
		{
			isproportional		only
			1
			{
				name			Titanfall
				tall			72
				antialias 		1
				shadowglow		7
				scanlines		2
			}
		}

		//////////////////////////////////// Special-case definitions ////////////////////////////////////

		XpText
		{
			1
			{
				name			Default
				tall			34
				antialias		1
			}
		}

		KillShot
		{
			1
			{
				name			Default
				tall			43
				antialias		1
			}
		}

		MPObituary
		{
			1
			{
				name			Default
				tall			21
				antialias		1
			}
		}

		CapturePointStatusHUD
		{
			1
			{
				name			Default
				tall			34
				antialias		1
			}
		}

		MPScoreBarLarge
		{
			1
			{
				name			Default
				tall			23
				antialias		1
			}
		}

		MPScoreBarSmall
		{
			1
			{
				name			Default
				tall			19
				antialias		1
			}
		}

		TitanHUD
		{
			1
			{
				name			Default
				tall			34
				antialias		1
			}
		}

		SmartPistolStatus
		{
			1
			{
				name			Default
				tall			21
				antialias		1
			}
		}

		SmartPistolStatusGlow
		{
			1
			{
				name			Default
				tall			21
				weight			0
				antialias		1
  				blur			2
  				additive		1
				scanlines		2
			}
		}

		FlyoutDescription
		{
			1
			{
				name			Default
				tall			27
				antialias		1
			}
		}

		FlyoutDescriptionGlow
		{
			1
			{
				name			Default
				tall			27
				weight			0
				antialias		1
  				blur			2
  				additive		1
				scanlines		2
			}
		}
	}

	InheritableProperties
	{
		ScoreboardTeamScore
		{
			zpos				1012
			wide				128
			tall				64
			visible				0
			scaleImage			1
			rui					"ui/scoreboard_team_score.rpak"
		}

		ScoreboardTeamLogo
		{
			zpos				1012
			wide				64
			tall				64
			visible				0
			scaleImage			1
			rui					"ui/scoreboard_logo.rpak"
		}

		ScoreboardPlayer
		{
			ypos				2
			zpos				1010
			wide				780
			tall				35
			visible				0
			scaleImage			1
			rui					"ui/scoreboard_row_mp.rpak"
		}

		ScoreboardGamepadFooterButton
		{
			classname				ScoreboardGamepadFooterButtonClass
			zpos					3
			auto_wide_tocontents 	1
			tall 					36
			labelText				"DEFAULT"
			font					Default_28_ShadowGlow
			allcaps					1
			enabled					1
			visible					1
			activeInputExclusivePaint	gamepad
		}

		WorldHealthBar
		{
			wide					899
			tall					450
			visible					0
			clip 					1
		}
	}

	//////////////////// BORDERS //////////////////////////////
	// describes all the border types
	Borders
	{
		ScoreboardTeamLogoBorder
		{
			bordertype			scalable_image
			backgroundtype		2

			image					"ui/borders/scoreboard_teamlogo_border"
			src_corner_height		16				// pixels inside the image
			src_corner_width		16
			draw_corner_width		7				// screen size of the corners ( and sides ), proportional
			draw_corner_height 		7
		}

		ScoreboardPlayerBorder
		{
			bordertype				scalable_image
			backgroundtype			2

			image					"ui/borders/scoreboard_player_border"
			src_corner_height		2				// pixels inside the image
			src_corner_width		2
			draw_corner_width		2				// screen size of the corners ( and sides ), proportional
			draw_corner_height 		2
		}
	}
}
