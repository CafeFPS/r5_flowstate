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
		Orange								"178 82 22 255"
		White								"235 235 235 255"
		Red									"192 28 0 140"
		Blue								"0 28 162 140"
		Yellow								"251 235 202 255"
		Black								"46 43 42 255" //"0 0 0 255" Changed black to a NTSC safe color
		TransparentBlack					"0 0 0 196"
		Gray								"178 178 178 255"
		Blank								"0 0 0 0"
		TanDark								"117 107 94 255"
		TanLight							"235 226 202 255"
	}

	///////////////////// BASE SETTINGS ////////////////////////
	// default settings for all panels
	// controls use these to determine their settings
	BaseSettings
	{
		Label.TextDullColor					TanDark
		Label.TextColor						TanLight
		Label.TextBrightColor				TanLight
		Label.SelectedTextColor				White
		Label.BgColor						Blank
		Label.DisabledFgColor1				Blank
		Label.DisabledFgColor2				"255 255 225 255"

		Frame.TopBorderImage				"vgui/menu_backgroud_top"
		Frame.BottomBorderImage				"vgui/menu_backgroud_bottom"
		Frame.SmearColor					"0 0 0 180"

		FgColor								"248 255 248 200"
		BgColor								"39 63 82 0"

		Panel.FgColor						"248 255 248 200"
		Panel.BgColor						"39 63 82 0"

		// checkboxes and radio buttons
		BaseText							OffWhite
		BrightControlText					White
		CheckBgColor						TransparentBlack
		CheckButtonBorder1 					Border.Dark 		// the left checkbutton border
		CheckButtonBorder2  				Border.Bright		// the right checkbutton border
		CheckButtonCheck					White				// color of the check itself

		// HL1-style QuickHUD colors
		Yellowish							"255 160 0 255"
		Normal								"255 255 225 128"
		Caution								"255 48 0 255"

		// Top-left corner of the menu on the main screen
		Main.Menu.X							32
		Main.Menu.X_hidef					76
		Main.Menu.Y							340
		Main.Menu.Color						"168 97 64 255"
		Menu.TextColor						"0 0 0 255"
		Menu.BgColor						"125 125 125 255"

		ScrollBar.Wide						12

		ScrollBarButton.FgColor				Black
		ScrollBarButton.BgColor				Blank
		ScrollBarButton.ArmedFgColor		White
		ScrollBarButton.ArmedBgColor		Blank
		ScrollBarButton.DepressedFgColor	White
		ScrollBarButton.DepressedBgColor	Blank

		ScrollBarSlider.FgColor				"0 0 0 255"			// nob color
		ScrollBarSlider.BgColor				"0 0 0 40"			// slider background color
		ScrollBarSlider.NobFocusColor		White
		ScrollBarSlider.NobDragColor		White
		ScrollBarSlider.Inset				3

		ClosedCaption.RuiFont 				DefaultRegularFont
	 	ClosedCaption.RuiFontHeight 		32
	 	ClosedCaption.RuiFontHeightLarge	40
	 	ClosedCaption.RuiFontHeightHuge		48
	}

	//////////////////////// FONTS /////////////////////////////
	// describes all the fonts

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

		DebugFixed
		{
			1
			{
				name		"Lucida Console"
				tall		14
				antialias 	1
			}
		}

		DebugFixedSmall
		{
			1
			{
				name		"Lucida Console"
				tall		14
				antialias 	1
			}
		}

		DebugOverlay
		{
			1
			{
				name		"Lucida Console"
				tall		14
				antialias 	1
				outline		1
			}
		}

		DebugBoldOutline
		{
			1
			{
				name		DefaultBold
				tall		16	// Some values of tall don't work with 'outline' on Durango, please leave this value at 20
				antialias	1
				outline		1
			}
		}

		Default
		{
			1
			{
				name			Tahoma
				tall			9		[!$GAMECONSOLE]
				weight			700		[!$GAMECONSOLE]
				tall			14		[$GAMECONSOLE]
				weight			900		[$GAMECONSOLE]
				antialias 		1
			}
		}

		DefaultSmall
		{
			1
			{
				name		Tahoma
				tall		12
				weight		0
				range		"0x0000 0x017F"
				yres		"480 599"
			}
			2
			{
				name		Tahoma
				tall		13
				weight		0
				range		"0x0000 0x017F"
				yres		"600 767"
			}
			3
			{
				name		Tahoma
				tall		14
				weight		0
				range		"0x0000 0x017F"
				yres		"768 1023"
				antialias	1
			}
			4
			{
				name		Tahoma
				tall		20
				weight		0
				range		"0x0000 0x017F"
				yres		"1024 1199"
				antialias	1
			}
			5
			{
				name		Tahoma
				tall		24
				weight		0
				range		"0x0000 0x017F"
				yres		"1200 6000"
				antialias	1
			}
			6
			{
				name		Tahoma
				tall		12
				range 		"0x0000 0x00FF"
				weight		0
			}
		}

		DefaultVerySmall
		{
			1
			{
				name		Tahoma
				tall		12
				weight		0
				range		"0x0000 0x017F" //	Basic Latin, Latin-1 Supplement, Latin Extended-A
				yres		"480 599"
			}
			2
			{
				name		Tahoma
				tall		13
				weight		0
				range		"0x0000 0x017F" //	Basic Latin, Latin-1 Supplement, Latin Extended-A
				yres		"600 767"
			}
			3
			{
				name		Tahoma
				tall		14
				weight		0
				range		"0x0000 0x017F" //	Basic Latin, Latin-1 Supplement, Latin Extended-A
				yres		"768 1023"
				antialias	1
			}
			4
			{
				name		Tahoma
				tall		20
				weight		0
				range		"0x0000 0x017F" //	Basic Latin, Latin-1 Supplement, Latin Extended-A
				yres		"1024 1199"
				antialias	1
			}
			5
			{
				name		Tahoma
				tall		24
				weight		0
				range		"0x0000 0x017F" //	Basic Latin, Latin-1 Supplement, Latin Extended-A
				yres		"1200 6000"
				antialias	1
			}
			6
			{
				name		Tahoma
				tall		12
				range 		"0x0000 0x00FF"
				weight		0
			}
			7
			{
				name		Tahoma
				tall		11
				range 		"0x0000 0x00FF"
				weight		0
			}
		}

		HudNumbers
		{
			1
			{
				name		Default
				tall		49
				antialias	1
				additive	1
			}
		}

		HudNumbersGlow
		{
			1
			{
				name		Default
				tall		49
				weight		0
				blur		2
				scanlines	2
				antialias 	1
				additive	1
			}
		}

		HudNumbersSmall
		{
			1
			{
				name		Default
				tall		24
				weight		1000
				additive	1
				antialias 	1
			}
		}

		// this is the symbol font
		Marlett
		{
			1
			{
				name		Marlett
				tall		14
				weight		0
				symbol		1
			}
		}

		CenterPrint
		{
			1
			{
				name		Default
				tall		19
				weight		900
				antialias 	1
				additive	1
			}
		}

		XpText
		{
			1
			{
				name		Default
				tall		16
				antialias	1
			}
		}

		PlayerNames
		{
			1
			{
				name		Default
				tall		13
				weight		100
				antialias	1
				shadowglow	4
			}
		}

		KillShot
		{
			1
			{
				name		Default
				tall		19
				antialias	1
			}
		}

		GameUIButtons
		{
			1
			{
				bitmap		1
				name		"ControllerButtons"
				scalex		0.843
				scaley		0.843
			}
		}

		HUDPrompt
		{
			1
			{
				name		Default
				tall		34
				antialias	1
				shadowglow	7
			}
		}

		KillShotGlow
		{
			1
			{
				name		Default
				tall		19
				weight		0
				antialias	1
	  			blur		2
  				additive	1
				scanlines	2
			}
		}

		Default_9
		{
			isproportional		only
			1
			{
				name		Default
				tall		9
				antialias	1
			}
		}

		Default_9_Additive_Blur_Scanlines
		{
			isproportional		only
			1
			{
				name		Default
				tall		9
				weight		0
				antialias	1
  				blur		2
  				additive	1
				scanlines	2
			}
		}

		MPObituary
		{
			1
			{
				name		Default
				tall		9
				antialias	1
			}
		}

		CapturePointStatusHUD
		{
			1
			{
				name		Default
				tall		16
				antialias	1
			}
		}

		MPScoreBarLarge
		{
			1
			{
				name		Default
				tall		12
				antialias	1
			}
		}

		MPScoreBarSmall
		{
			1
			{
				name		Default
				tall		9
				antialias	1
			}
		}

		TitanHUD
		{
			1
			{
				name		Default
				tall		16
				antialias	1
			}
		}

		SmartPistolStatus
		{
			1
			{
				name		Default
				tall		9
				antialias	1
			}
		}

		SmartPistolStatusGlow
		{
			1
			{
				name		Default
				tall		9
				weight		0
				antialias	1
  				blur		2
  				additive	1
				scanlines	2
			}
		}

		FlyoutDescription
		{
			1
			{
				name		Default
				tall		11
				antialias	1
			}
		}

		FlyoutDescriptionGlow
		{
			1
			{
				name		Default
				tall		11
				weight		0
				antialias	1
  				blur		2
  				additive	1
				scanlines	2
			}
		}
	}

	//////////////////// BORDERS //////////////////////////////
	// describes all the border types
	Borders
	{
	}
}

