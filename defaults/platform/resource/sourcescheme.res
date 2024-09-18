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
		White						"255 255 255 255"
		OffWhite					"232 232 232 255"
		DullWhite					"142 142 142 255"
		Selection					"72 83 149 255"
		TransparentBlack			"0 0 0 128"
		Black						"0 0 0 255"
		Blank						"0 0 0 0"

		SteamLightGreen 			"157 194 80 255"
		AchievementsLightGrey		"79 79 79 255"
		AchievementsDarkGrey		"55 55 55 255"
		AchievementsInactiveFG	    "130 130 130 255"

		ScrollBarGrey				"51 51 51 255"
		ScrollBarHilight			"110 110 110 255"
		ScrollBarDark				"38 38 38 255"
	}

	///////////////////// BASE SETTINGS ////////////////////////
	// default settings for all panels
	// controls use these to determine their settings
	BaseSettings
	{
		// vgui_controls color specifications
		Border.Bright					"120 120 120 196"	// the lit side of a control
		Border.Dark						"40 40 40 196"		// the dark/unlit side of a control
		Border.Selection				"0 0 0 196"			// the additional border color for displaying the default/selected button

		Button.TextColor				OffWhite
		Button.BgColor					Blank
		Button.ArmedTextColor			OffWhite
		Button.ArmedBgColor				Blank
		Button.DepressedTextColor		OffWhite
		Button.DepressedBgColor			Blank
		Button.FocusBorderColor			Black

		CheckButton.TextColor			OffWhite
		CheckButton.SelectedTextColor	OffWhite
		CheckButton.BgColor				TransparentBlack
		CheckButton.Border1  			Border.Dark 		// the left checkbutton border
		CheckButton.Border2  			Border.Bright		// the right checkbutton border
		CheckButton.Check				OffWhite			// color of the check itself
		CheckButton.DisabledFgColor		"130 130 130 255"	// disabled check color
		CheckButton.DisabledBgColor		"62 70 55 255"
		CheckButton.ArmedBgColor		"62 70 55 255"
		CheckButton.DepressedBgColor	"62 70 55 255"
		CheckButton.HighlightFgColor	OffWhite

		ComboBoxButton.ArrowColor		DullWhite
		ComboBoxButton.ArmedArrowColor	White
		ComboBoxButton.BgColor			Blank
		ComboBoxButton.DisabledBgColor	Blank

		Frame.TitleTextInsetX				16
		Frame.ClientInsetX					8
		Frame.ClientInsetY					6
		Frame.BgColor						"80 80 80 255"
		Frame.OutOfFocusBgColor				"80 80 80 255"
		Frame.FocusTransitionEffectTime		0					// time it takes for a window to fade in/out on focus/out of focus
		Frame.TransitionEffectTime			0					// time it takes for a window to fade in/out on open/close
		Frame.AutoSnapRange					0
		FrameGrip.Color1					"200 200 200 196"
		FrameGrip.Color2					"0 0 0 196"
		FrameTitleButton.FgColor			"200 200 200 196"
		FrameTitleButton.BgColor			Blank
		FrameTitleButton.DisabledFgColor	"255 255 255 192"
		FrameTitleButton.DisabledBgColor	Blank
		FrameSystemButton.FgColor			Blank
		FrameSystemButton.BgColor			Blank
		FrameSystemButton.Icon				""
		FrameSystemButton.DisabledIcon		""
		FrameTitleBar.Font					DefaultLarge
		FrameTitleBar.TextColor				OffWhite
		FrameTitleBar.BgColor				Blank
		FrameTitleBar.DisabledTextColor		"255 255 255 192"
		FrameTitleBar.DisabledBgColor		Blank

		GraphPanel.FgColor					White
		GraphPanel.BgColor					TransparentBlack

		Label.TextDullColor					DullWhite
		Label.TextColor						OffWhite
		Label.TextBrightColor				White
		Label.SelectedTextColor				White
		Label.BgColor						Blank
		Label.DisabledFgColor1				"117 117 117 255"
		Label.DisabledFgColor2				"30 30 30 255"

		ListPanel.TextColor					OffWhite
		ListPanel.TextBgColor				Blank
		ListPanel.BgColor					TransparentBlack
		ListPanel.SelectedTextColor			Black
		ListPanel.SelectedBgColor			Selection
		ListPanel.SelectedOutOfFocusBgColor	"55 23 200 128"
		ListPanel.EmptyListInfoTextColor	OffWhite

		FileOpenDialog.SelectedBgColor 		"170 128 0 255"

		Menu.TextColor						OffWhite
		Menu.BgColor						"80 80 80 255"
		Menu.ArmedTextColor					OffWhite
		Menu.ArmedBgColor					Selection
		Menu.TextInset						6

		Panel.FgColor						DullWhite
		Panel.BgColor						Blank

		ProgressBar.FgColor					White
		ProgressBar.BgColor					TransparentBlack

		PropertySheet.TextColor				OffWhite
		PropertySheet.SelectedTextColor		White
		PropertySheet.TransitionEffectTime	0.25	// time to change from one tab to another

		RadioButton.TextColor				OffWhite
		RadioButton.SelectedTextColor		OffWhite

		RichText.TextColor					OffWhite
		RichText.BgColor					"0 0 0 255"
		RichText.SelectedTextColor			OffWhite
		RichText.SelectedBgColor			Selection

		ScrollBar.Wide						17
	  	ScrollBarNobBorder.Outer 			ScrollBarDark
		ScrollBarNobBorder.Inner 			ScrollBarGrey
		ScrollBarNobBorderHover.Inner 		ScrollBarGrey
		ScrollBarNobBorderDragging.Inner 	ScrollBarHilight

		ScrollBarButton.FgColor				ScrollBarHilight
		ScrollBarButton.BgColor				ScrollBarGrey
		ScrollBarButton.ArmedFgColor		ScrollBarHilight
		ScrollBarButton.ArmedBgColor		ScrollBarGrey
		ScrollBarButton.DepressedFgColor	ScrollBarHilight
		ScrollBarButton.DepressedBgColor	ScrollBarGrey

		ScrollBarSlider.Inset				1					// Number of pixels to inset scroll bar nob
		ScrollBarSlider.FgColor				ScrollBarGrey		// nob color
		ScrollBarSlider.BgColor				ScrollBarDark		// slider background color
		ScrollBarSlider.NobFocusColor		ScrollBarHilight	// nob mouseover color
		ScrollBarSlider.NobDragColor		ScrollBarHilight	// nob active drag color

		SectionedListPanel.HeaderTextColor				White
		SectionedListPanel.HeaderBgColor				Blank
		SectionedListPanel.DividerColor					Black
		SectionedListPanel.TextColor					DullWhite
		SectionedListPanel.BrightTextColor				White
		SectionedListPanel.BgColor						TransparentBlack
		SectionedListPanel.SelectedTextColor			Black
		SectionedListPanel.SelectedBgColor				Selection
		SectionedListPanel.OutOfFocusSelectedTextColor	Black
		SectionedListPanel.OutOfFocusSelectedBgColor	"255 155 0 128"

		Slider.NobColor						"108 108 108 255"
		Slider.NobFocusColor				"200 200 200 255"
		Slider.TextColor					"180 180 180 255"
		Slider.TrackColor					"31 31 31 255"
		Slider.DisabledTextColor1			"117 117 117 255"
		Slider.DisabledTextColor2			"30 30 30 255"

		TextEntry.TextColor					OffWhite
		TextEntry.BgColor					"64 64 64 80"
		TextEntry.CursorColor				OffWhite
		TextEntry.DisabledTextColor			DullWhite
		TextEntry.DisabledBgColor			Blank
		TextEntry.SelectedTextColor			OffWhite
		TextEntry.SelectedBgColor			Selection
		TextEntry.FocusedBgColor			"64 64 64 80"
		TextEntry.OutOfFocusSelectedBgColor	"55 23 200 128"
		TextEntry.FocusEdgeColor			"0 0 0 196"

		ToggleButton.SelectedTextColor		White

		Tooltip.TextColor					"0 0 0 196"
		Tooltip.BgColor						Selection

		TreeView.BgColor					TransparentBlack

		WizardSubPanel.BgColor				Blank

		// scheme-specific colors
		MainMenu.TextColor					White
		MainMenu.ArmedTextColor				"200 200 200 255"
		MainMenu.DepressedTextColor			"192 186 80 255"
		MainMenu.MenuItemHeight				30
		MainMenu.MenuItemHeight_hidef		32				[$GAMECONSOLE]
		MainMenu.Inset						32
		MainMenu.Backdrop					"0 0 0 156"

		Console.TextColor					OffWhite
		Console.DevTextColor				White

		NewGame.TextColor					White
		NewGame.FillColor					"0 0 0 255"
		NewGame.SelectionColor				Selection
		NewGame.DisabledColor				"128 128 128 196"

		MessageDialog.MatchmakingBG			"46 43 42 255"	[$GAMECONSOLE]
		MessageDialog.MatchmakingBGBlack	"22 22 22 255"	[$GAMECONSOLE]
	}

	InheritableProperties
	{
		// this is where you setup InheritableProperties for HudMain.res.
//		LeaguePointsSpinner
//		{
//			xpos			0
//			ypos			0
//			wide			32
//			tall			32
//			visible			0
//			image			vgui/HUD/star_spinner
//			scaleImage		1
//			zpos			149
//		}
	}

	//////////////////////// FONTS /////////////////////////////
	//
	// describes all the fonts
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
				tall		10			[!$GAMECONSOLE]
				tall		14			[$GAMECONSOLE]
				antialias   1
			}
		}

		DebugFixedSmall
		{
			1
			{
				name		"Lucida Console"
				tall		7				[!$GAMECONSOLE]
				tall		10			[$GAMECONSOLE]
				antialias   1
			}
		}

		DefaultFixedOutline
		{
			1
			{
				name		"Lucida Console"
				tall		10			[!$GAMECONSOLE]
				tall		14			[$GAMECONSOLE]
				weight	    0
				antialias	1
				outline	    1
			}
		}

		DefaultFixed
		{
			1
			{
				name		"Lucida Console"
				tall		10			[!$GAMECONSOLE]
				tall		14			[$GAMECONSOLE]
				weight	    0
				antialias   1
			}
		}

		DefaultFixedDropShadow
		{
			1
			{
				name		"Lucida Console"
				tall		10
				weight	    0
				antialias   1
				dropshadow  1
			}
		}

		Default
		{
			1
			{
				name		Tahoma
				tall		16
				weight	    500
			}
		}

		DefaultBold
		{
			1
			{
				name		Tahoma
				tall		16
				weight	    1000
			}
		}

		DefaultUnderline
		{
			1
			{
				name		Tahoma
				tall		16
				weight	    500
				underline   1
			}
		}

		// "Almost" dev only. ListPanels use this which we are showing on the datacenter dialog.
		// TODO: Make the ListPanel and console use different font definitions.
		DefaultSmall
		{
			1
			{
				name		Default
				tall		13             [!$JAPANESE && !$TCHINESE]
				tall		18             [$JAPANESE || $TCHINESE]

				antialias   1
			}
		}

		DefaultSmallDropShadow
		{
			1
			{
				name		Tahoma
				tall		13
				weight	    0
				dropshadow  1
			}
		}

		DefaultVerySmall
		{
			1
			{
				name		Tahoma
				tall		12
				weight	    0
			}
		}

		DefaultLarge
		{
			1
			{
				name		Tahoma
				tall		18
				weight	    0
			}
		}

		MenuLarge
		{
			1
			{
				name		Tahoma
				tall		16
				weight	    600
				antialias   1
			}
		}

		ConsoleText
		{
			1
			{
				name		"Lucida Console"
				tall		14
				antialias   1
			}
		}

		// this is the symbol font
		Marlett
		{
			1
			{
				name		Marlett
				tall		14
				weight	    0
				symbol	    1
			}
		}

		// HUD numbers
		// We use multiple fonts to 'pulse' them in the HUD, hence the need for many of near size
		HUDNumber [!$GAMECONSOLE]
		{
			1
			{
				name		Default
				tall		31
				weight	    900
			}
		}

		HUDNumber1 [!$GAMECONSOLE]
		{
			1
			{
				name		Default
				tall		31
				weight	    900
			}
		}

		HUDNumber2 [!$GAMECONSOLE]
		{
			1
			{
				name		Default
				tall		32
				weight	    900
			}
		}

		HUDNumber3 [!$GAMECONSOLE]
		{
			1
			{
				name		Default
				tall		33
				weight	    900
			}
		}

		HUDNumber4 [!$GAMECONSOLE]
		{
			1
			{
				name		Default
				tall		33
				weight	    900
			}
		}

		HUDNumber5 [!$GAMECONSOLE]
		{
			1
			{
				name		Default
				tall		34
				weight	    900
			}
		}

		CloseCaption_StartupMovie
		{
			1
			{
				name		Default
				tall		22
				weight		500
				antialias	1
			}
		}
	}

	//
	//////////////////// BORDERS //////////////////////////////
	//
	// describes all the border types
	Borders
	{
		BaseBorder		DepressedBorder
		ButtonBorder	RaisedBorder
		ComboBoxBorder	DepressedBorder
		MenuBorder		RaisedBorder
		BrowserBorder	DepressedBorder
		PropertySheetBorder	RaisedBorder

		FrameBorder
		{
			// rounded corners for frames
			backgroundtype 2
		}

		DepressedBorder
		{
			inset "0 0 1 1"
			Left
			{
				1
				{
					color Border.Dark
					offset "0 1"
				}
			}

			Right
			{
				1
				{
					color Border.Bright
					offset "1 0"
				}
			}

			Top
			{
				1
				{
					color Border.Dark
					offset "0 0"
				}
			}

			Bottom
			{
				1
				{
					color Border.Bright
					offset "0 0"
				}
			}
		}
		RaisedBorder
		{
			inset "0 0 1 1"
			Left
			{
				1
				{
					color Border.Bright
					offset "0 1"
				}
			}

			Right
			{
				1
				{
					color Border.Dark
					offset "0 0"
				}
			}

			Top
			{
				1
				{
					color Border.Bright
					offset "0 1"
				}
			}

			Bottom
			{
				1
				{
					color Border.Dark
					offset "0 0"
				}
			}
		}

		TitleButtonBorder
		{
			backgroundtype 0
		}

		TitleButtonDisabledBorder
		{
			backgroundtype 0
		}

		TitleButtonDepressedBorder
		{
			backgroundtype 0
		}

		ScrollBarButtonBorder
		{
			inset "2 2 0 0"
			Left
			{
				1
				{
					color Border.Dark
					offset "0 1"
				}
			}

			Right
			{
				1
				{
					color Border.Dark
					offset "1 0"
				}
			}

			Top
			{
				1
				{
					color Border.Dark
					offset "0 0"
				}
			}

			Bottom
			{
				1
				{
					color Border.Dark
					offset "0 0"
				}
			}
		}

		ScrollBarButtonDepressedBorder
		{
			inset "2 2 0 0"
			Left
			{
				1
				{
					color Border.Dark
					offset "0 1"
				}
			}

			Right
			{
				1
				{
					color Border.Bright
					offset "1 0"
				}
			}

			Top
			{
				1
				{
					color Border.Dark
					offset "0 0"
				}
			}

			Bottom
			{
				1
				{
					color Border.Bright
					offset "0 0"
				}
			}
		}

		ScrollBarSliderBorder
		{
			inset "2 2 0 0"
			Left
			{
				1
				{
					color ScrollBarHilight
					offset "0 1"
				}
			}

			Right
			{
				1
				{
					color ScrollBarDark
					offset "1 0"
				}
			}

			Top
			{
				1
				{
					color ScrollBarHilight
					offset "0 0"
				}
			}

			Bottom
			{
				1
				{
					color ScrollBarDark
					offset "0 0"
				}
			}
		}

		ScrollBarSliderBorderHover ScrollBarSliderBorder
		ScrollBarSliderBorderDragging ScrollBarSliderBorder

		TabBorder
		{
			inset "0 0 1 1"
			Left
			{
				1
				{
					color Border.Bright
					offset "0 1"
				}
			}

			Right
			{
				1
				{
					color Border.Dark
					offset "1 0"
				}
			}

			Top
			{
				1
				{
					color Border.Bright
					offset "0 0"
				}
			}

		}

		TabActiveBorder
		{
			inset "0 0 1 0"
			Left
			{
				1
				{
					color Border.Bright
					offset "0 0"
				}
			}

			Right
			{
				1
				{
					color Border.Dark
					offset "1 0"
				}
			}

			Top
			{
				1
				{
					color Border.Bright
					offset "0 0"
				}
			}
		}

		ToolTipBorder
		{
			inset "0 0 1 0"
			Left
			{
				1
				{
					color Border.Dark
					offset "0 0"
				}
			}

			Right
			{
				1
				{
					color Border.Dark
					offset "1 0"
				}
			}

			Top
			{
				1
				{
					color Border.Dark
					offset "0 0"
				}
			}

			Bottom
			{
				1
				{
					color Border.Dark
					offset "0 0"
				}
			}
		}

		// this is the border used for default buttons (the button that gets pressed when you hit enter)
		ButtonKeyFocusBorder
		{
			inset "0 0 1 1"
			Left
			{
				1
				{
					color Border.Selection
					offset "0 0"
				}
				2
				{
					color Border.Bright
					offset "0 1"
				}
			}
			Top
			{
				1
				{
					color Border.Selection
					offset "0 0"
				}
				2
				{
					color Border.Bright
					offset "1 0"
				}
			}
			Right
			{
				1
				{
					color Border.Selection
					offset "0 0"
				}
				2
				{
					color Border.Dark
					offset "1 0"
				}
			}
			Bottom
			{
				1
				{
					color Border.Selection
					offset "0 0"
				}
				2
				{
					color Border.Dark
					offset "0 0"
				}
			}
		}

		ButtonDepressedBorder
		{
			inset "2 1 1 1"
			Left
			{
				1
				{
					color Border.Dark
					offset "0 1"
				}
			}

			Right
			{
				1
				{
					color Border.Bright
					offset "1 0"
				}
			}

			Top
			{
				1
				{
					color Border.Dark
					offset "0 0"
				}
			}

			Bottom
			{
				1
				{
					color Border.Bright
					offset "0 0"
				}
			}
		}
	}

	// This controls loading only. See fontfiletable.txt for language-based font remapping.
	CustomFontFiles
	{
	    1       "resource/MetronicPro-Regular.vfont"
	    2       "resource/MetronicPro-SemiBold.vfont"
	    3       "resource/Titanfall-Regular.vfont"      [!$JAPANESE && !$TCHINESE && !$RUSSIAN]

	    3       "resource/NotoSansJP-Regular.vfont"     [$JAPANESE]
	    3       "resource/NotoSansTC-Regular.vfont"     [$TCHINESE]
	}
}
