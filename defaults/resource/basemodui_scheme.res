///////////////////////////////////////////////////////////
// Object Control Panel scheme resource file
//
// sections:
//		Colors			- all the colors used by the scheme
//		BaseSettings	- contains settings for app to use to draw controls
//		Fonts			- list of all the fonts used by app
//		Borders			- description of all the borders
//
// hit ctrl-alt-shift-R in the app to reload this file
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
		White					"255 255 255 255"
		OffWhite				"221 221 221 255"
		DullWhite				"211 211 211 255"
		Gray					"64 64 64 255"
		Orange					"255 155 0 255"
		Red						"255 0 0 255"
		LightBlue				"103 117 127 255"
		TransparentBlack		"0 0 0 100"
		Black					"0 0 0 255"
		Blank					"0 0 0 0"
		Green					"0 128 0 255"
		ScrollBarBase			"103 117 127 255"
		ScrollBarHover			"205 236 255 255"
		ScrollBarHold			"205 236 255 255"
		Disabled 				"0 0 0 150"
		TextBackground			"24 27 30 255"
	}

	///////////////////// BASE SETTINGS ////////////////////////
	// default settings for all panels
	// controls use these to determine their settings
	BaseSettings
	{
		// vgui_controls color specifications
		Border.Bright						"200 200 200 196"	// the lit side of a control
		Border.Dark							"40 40 40 196"		// the dark/unlit side of a control
		Border.Selection					"0 0 0 196"			// the additional border color for displaying the default/selected button
		Border.White						White

		Button.TextColor					White
		Button.BgColor						Blank
		Button.ArmedTextColor				White
		Button.ArmedBgColor					Blank
		Button.DepressedTextColor			"255 255 0 255"
		Button.DepressedBgColor				Blank
		Button.FocusBorderColor				Black
		Button.CursorPriority				1

		CheckButton.TextColor				OffWhite
		CheckButton.SelectedTextColor		White
		CheckButton.BgColor					TransparentBlack
		CheckButton.Border1  				Border.Dark 		// the left checkbutton border
		CheckButton.Border2  				Border.Bright		// the right checkbutton border
		CheckButton.Check					White				// color of the check itself

		ComboBoxButton.ArrowColor			DullWhite
		ComboBoxButton.ArmedArrowColor		White
		ComboBoxButton.BgColor				Blank
		ComboBoxButton.DisabledBgColor		Blank

		GenericPanelList.BgColor			Blank

		Frame.TitleTextInsetX				12
		Frame.ClientInsetX					6
		Frame.ClientInsetY					4
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
		FrameTitleBar.TextColor				White
		FrameTitleBar.BgColor				Blank
		FrameTitleBar.DisabledTextColor		"255 255 255 192"
		FrameTitleBar.DisabledBgColor		Blank

		GraphPanel.FgColor					White
		GraphPanel.BgColor					TransparentBlack

		GridButtonListPanel.MaxScrollVel			1000.0
		GridButtonListPanel.JoystickDeadZone		0.15

		Label.TextDullColor					Black
		Label.TextColor						OffWhite
		Label.TextBrightColor				LightBlue
		Label.SelectedTextColor				White
		Label.BgColor						Blank
		Label.DisabledFgColor1				"117 117 117 0"
		Label.DisabledFgColor2				Disabled
		Label.RuiFont 						DefaultRegularFont
		Label.RuiFontHeight 				26
		Label.CursorPriority				-1

		ListPanel.TextColor					OffWhite
		ListPanel.BgColor					TransparentBlack
		ListPanel.SelectedTextColor			Black
		ListPanel.SelectedBgColor			"254 184 0 255"
		ListPanel.MouseOverBgColor			"128 128 128 255"
		ListPanel.SelectedOutOfFocusBgColor	"255 255 255 25"
		ListPanel.EmptyListInfoTextColor	LightBlue
		ListPanel.JoystickDeadZone			0.15
		ListPanel.MaxScrollVel				100.0
		ListPanel.CursorPriority			1

		ImagePanel.fillcolor				Blank

		Menu.TextColor						White
		Menu.BgColor						"160 160 160 255"
		Menu.ArmedTextColor					Black
		Menu.ArmedBgColor					LightBlue
		Menu.TextInset						6

		Panel.FgColor						DullWhite
		Panel.BgColor						Blank


		ProgressBar.FgColor					White
		ProgressBar.BgColor					TransparentBlack

		PropertySheet.TextColor				OffWhite
		PropertySheet.SelectedTextColor		White
		PropertySheet.TransitionEffectTime	0.25	// time to change from one tab to another
		PropertySheet.TabFont				DefaultLarge

		RadioButton.TextColor				DullWhite
		RadioButton.SelectedTextColor		White

		RichText.TextColor					OffWhite
		RichText.BgColor					TextBackground
		RichText.SelectedTextColor			OffWhite
		RichText.SelectedBgColor			LightBlue
		RichText.InsetX						20
		RichText.InsetY						0

		Chat.FriendlyFontColor				"55 233 255 255"
		Chat.EnemyFontColor					"230 83 14 255"
		Chat.NeutralFontColor				OffWhite
		Chat.RuiFont 						DefaultRegularFont
		Chat.RuiAsianFont					DefaultAsianFont
		Chat.RuiFontHeight					28
		Chat.RuiMinFontHeight				16
		Chat.RuiAsianBoxHeight				36

		ScrollBar.Wide						16

		ScrollBarButton.FgColor				"255 255 255 100"
		ScrollBarButton.BgColor				"0 0 0 65"
		ScrollBarButton.ArmedFgColor		White
		ScrollBarButton.ArmedBgColor		"0 0 0 80"
		ScrollBarButton.DepressedFgColor	White
		ScrollBarButton.DepressedBgColor	"255 255 255 100"

		ScrollBarSlider.FgColor				"255 255 255 100"	// nob color
		ScrollBarSlider.BgColor				"255 255 255 10"	// slider background color
		ScrollBarSlider.NobFocusColor		White
		ScrollBarSlider.NobDragColor		White
		ScrollBarSlider.Inset				0

		SectionedListPanel.HeaderTextColor				White
		SectionedListPanel.HeaderBgColor				Blank
		SectionedListPanel.DividerColor					"221 221 221 60"
		SectionedListPanel.TextColor					White
		SectionedListPanel.BrightTextColor				"255 255 255 255"
		SectionedListPanel.BgColor						TransparentBlack
		SectionedListPanel.SelectedTextColor			"255 255 255 255"
		SectionedListPanel.SelectedBgColor				"221 221 221 50"
		SectionedListPanel.OutOfFocusSelectedTextColor	"240 240 240 255"
		SectionedListPanel.OutOfFocusSelectedBgColor	"221 221 221 60"
		SectionedListPanel.MouseOverBgColor				"221 221 221 60"
		SectionedListPanel.ColumnBgColor				"221 221 221 30"
		SectionedListPanel.JoystickDeadZone				0.15
		SectionedListPanel.MaxScrollVel					1000.0
		SectionedListPanel.ButtonCursorPriority			1

		TextEntry.TextColor					OffWhite
		TextEntry.BgColor					"0 0 0 64"
		TextEntry.CursorColor				OffWhite
		TextEntry.DisabledTextColor			Disabled
		TextEntry.DisabledBgColor			Blank
		TextEntry.FocusedBgColor			"64 64 64 150"
		TextEntry.SelectedTextColor			Black
		TextEntry.SelectedBgColor			"0 0 0 255"
		TextEntry.OutOfFocusSelectedBgColor	LightBlue
		TextEntry.FocusEdgeColor			"0 0 0 196"
		TextEntry.LangIdBgColor				LightBlue
		TextEntry.LangIdFontHeight			16
		TextEntry.ButtonFontRui 			DefaultRegularFont
		TextEntry.ButtonFontHeightRui		16

		ToggleButton.SelectedTextColor		OffWhite

		Tooltip.TextColor					"0 0 0 196"
		Tooltip.BgColor						LightBlue

		TreeView.BgColor					TransparentBlack

		WizardSubPanel.BgColor				Blank

		Console.TextColor					OffWhite
		Console.DevTextColor				White

		//
		// portal2
		//
		Logo.X								75	[$GAMECONSOLE && ($GAMECONSOLEWIDE && !$ANAMORPHIC)]
		Logo.X								50	[$GAMECONSOLE && (!$GAMECONSOLEWIDE || $ANAMORPHIC)]
		Logo.X								75	[!$GAMECONSOLE && $WIN32WIDE]
		Logo.X								50	[!$GAMECONSOLE && !$WIN32WIDE]
		Logo.Y								35
		Logo.Width							240
		Logo.Height							60

		FooterPanel.ButtonFont				GameUIButtonsMini
		FooterPanel.ButtonFontRui 			DefaultRegularFont
		FooterPanel.ButtonFontHeightRui		40
		FooterPanel.TextFont				DialogButton
		FooterPanel.TextFontRui 			DefaultRegularFont
		FooterPanel.TextFontHeightRui		40
		FooterPanel.TextOffsetX				0
		FooterPanel.TextOffsetY				0
		FooterPanel.TextColor				"140 140 140 255"
		FooterPanel.InGameTextColor			"200 200 200 255"
		FooterPanel.ButtonGapX				12					[!$GAMECONSOLE]
		FooterPanel.ButtonGapX				20					[$GAMECONSOLE && ($ENGLISH || $GAMECONSOLEWIDE)]
		FooterPanel.ButtonGapX				16					[$GAMECONSOLE && (!$ENGLISH && !$GAMECONSOLEWIDE)]
		FooterPanel.ButtonGapY				25
		FooterPanel.ButtonPaddingX			20					[!$GAMECONSOLE]
		FooterPanel.OffsetY					8
		FooterPanel.BorderColor				"0 0 0 255"			[!$GAMECONSOLE]
		FooterPanel.BorderArmedColor		"0 0 0 255"			[!$GAMECONSOLE]
		FooterPanel.BorderDepressedColor	"0 0 0 255"			[!$GAMECONSOLE]

		FooterPanel.AvatarSize				32
		FooterPanel.AvatarBorderSize		40
		FooterPanel.AvatarOffsetY			47
		FooterPanel.AvatarNameY				49
		FooterPanel.AvatarFriendsY			66
		FooterPanel.AvatarTextFont			Default

		Dialog.TitleFont					DialogTitle
		Dialog.TitleColor					"0 0 0 255"
		Dialog.MessageBoxTitleColor			"232 232 232 255"
		Dialog.TitleOffsetX					10
		Dialog.TitleOffsetY					9
		Dialog.TileWidth					50
		Dialog.TileHeight					50
		Dialog.PinFromBottom				75
		Dialog.PinFromLeft					100	[$GAMECONSOLE && ($GAMECONSOLEWIDE && !$ANAMORPHIC)]
		Dialog.PinFromLeft					75	[$GAMECONSOLE && (!$GAMECONSOLEWIDE || $ANAMORPHIC)]
		Dialog.PinFromLeft					100	[!$GAMECONSOLE && $WIN32WIDE]
		Dialog.PinFromLeft					75	[!$GAMECONSOLE && !$WIN32WIDE]
		Dialog.ButtonFont					GameUIButtonsMini

		// Other properties defined in SliderControl.res
		SliderControl.InsetX				-68
		SliderControl.MarkColor				"105 118 132 255"
		SliderControl.MarkFocusColor		"105 118 132 255"
		SliderControl.ForegroundColor		"232 232 232 0"
		SliderControl.BackgroundColor		"0 0 0 0"
		SliderControl.ForegroundFocusColor	"255 255 255 0"
		SliderControl.BackgroundFocusColor	"0 0 0 0"
        SliderControl.CursorPriority        2

		Slider.NobColor						"108 108 108 255"
		Slider.TextColor					"127 140 127 255"
		Slider.TrackColor					"31 31 31 255"
		Slider.DisabledTextColor1			"117 117 117 255"
		Slider.DisabledTextColor2			"30 30 30 255"

		LoadingProgress.NumDots				0
		LoadingProgress.DotGap				0
		LoadingProgress.DotWidth			18
		LoadingProgress.DotHeight			7

		ConfirmationDialog.TextFont			ConfirmationText
		ConfirmationDialog.TextFontRui		DefaultRegularFont
		ConfirmationDialog.TextFontRuiHeight	40
		ConfirmationDialog.TextOffsetX		5
		ConfirmationDialog.IconOffsetY		0

		KeyBindings.ActionColumnWidth		624
		KeyBindings.KeyColumnWidth			192
		KeyBindings.HeaderFont				DefaultBold_30
		KeyBindings.KeyFont					Default_23

		InlineEditPanel.FillColor			"221 221 221 60"
		InlineEditPanel.DashColor			White
		InlineEditPanel.LineSize			3
		InlineEditPanel.DashLength			2
		InlineEditPanel.GapLength			0

		//////////////////////// HYBRID BUTTON STYLES /////////////////////////////
		// A button set to use a specific style will use values defined by it, and will otherwise use the DefaultButton style.
		// If a style does not define all properties, HybridButton values will be used.
		// The .Style property tells code what type of behavior to apply to a button.

		HybridButton.TextColor						"255 255 255 127"
		HybridButton.FocusColor						Black
		HybridButton.SelectedColor					"255 128 32 255"
		HybridButton.CursorColor					"50 72 117 0"
		HybridButton.DisabledColor					Disabled
		HybridButton.FocusDisabledColor				Disabled
		HybridButton.Font							Default_28
		HybridButton.SymbolFont						MarlettLarge
		HybridButton.TextInsetX						0
		HybridButton.TextInsetY						16
		HybridButton.AllCaps						0
		HybridButton.CursorHeight					45
		HybridButton.MultiLine						56
		HybridButton.ListButtonActiveColor			"255 255 200 255"
		HybridButton.ListButtonInactiveColor		"232 232 232 255"
		HybridButton.ListInsetX						0
		// Special case properties for only a few menus
		HybridButton.LockedColor					Disabled
		HybridButton.BorderColor 					"0 0 0 255"
		HybridButton.RuiFont 						MetronicProRegularFont
		HybridButton.RuiFontHeight 					25

		RuiLabel.CursorPriority						-1

		RuiButton.Style                             0
		RuiButton.CursorHeight		                0
		RuiButton.TextColor                         Blank
		RuiButton.LockedColor                       Blank
		RuiButton.FocusColor                        Blank
		RuiButton.SelectedColor                     Blank
		RuiButton.DisabledColor                     Blank
		RuiButton.FocusDisabledColor                Blank
		RuiButton.CursorPriority					1


		DefaultButton.Style							0   // BUTTON_DEFAULT
		DefaultButton.TextInsetX					79
		DefaultButton.TextInsetY					7

		//MainMenuButton.Style						1   // BUTTON_MAINMENU - Obsolete

		SliderButton.Style					    	2   // BUTTON_LEFTINDIALOG - inside a dialog, left aligned, optional RHS component anchored to right edge. Used primarily in slider controls
		SliderButton.CursorHeight			    	60
		SliderButton.TextInsetX				    	12
		SliderButton.TextInsetY					    4
        SliderButton.CursorPriority                 1

		DialogListButton.Style						3   // BUTTON_DIALOGLIST - inside a dialog, left aligned, RHS list anchored to right edge
		DialogListButton.CursorHeight				60
		DialogListButton.TextInsetX					12
		DialogListButton.TextInsetY					12
		DialogListButton.TextColor					"255 255 255 127"
		DialogListButton.FocusColor					Black
		DialogListButton.ListButtonActiveColor		Black
		DialogListButton.ListButtonInactiveColor	"0 0 0 127"

		FlyoutMenuButton.Style						4   // BUTTON_FLYOUTITEM - inside of a flyout menu only
		DropDownButton.Style						5   // BUTTON_DROPDOWN - inside a dialog, contains a RHS value, usually causes a flyout
		//GameModeButton.Style						6   // BUTTON_GAMEMODE - not used, specialized button previously used in L4D game mode carousel
		//VirtualNavigationButton.Style				7   // BUTTON_VIRTUALNAV - does nothing in code
		//MixedCaseButton.Style						8   // BUTTON_MIXEDCASE - not used, menus where mixed case is used for button text (Steam link dialog)
		//MixedCaseDefaultButton.Style				9   // BUTTON_MIXEDCASEDEFAULT - not used
		//BitmapButton.Style						10  // BUTTON_BITMAP - not used or useful

		RuiButton.Style                             0
		RuiButton.CursorHeight		                0
		RuiButton.TextColor                         Blank
		RuiButton.LockedColor                       Blank
		RuiButton.FocusColor                        Blank
		RuiButton.SelectedColor                     Blank
		RuiButton.DisabledColor                     Blank
		RuiButton.FocusDisabledColor                Blank

		LoadoutButton.Style							0
		LoadoutButton.CursorHeight					40
		LoadoutButton.TextInsetX					12
		LoadoutButton.TextInsetY					3

		CompactButton.Style							0
		CompactButton.CursorHeight					40
		CompactButton.TextInsetX					79
		CompactButton.TextInsetY					4

		SmallButton.Style							0
		SmallButton.CursorHeight					40
		SmallButton.TextInsetX						12
		SmallButton.TextInsetY						4

		RuiSmallButton.Style						0
		RuiSmallButton.CursorHeight					40
		RuiSmallButton.TextInsetX					12
		RuiSmallButton.TextInsetY					4
		RuiSmallButton.TextColor                    Blank
		RuiSmallButton.LockedColor                  Blank
		RuiSmallButton.FocusColor					Blank
		RuiSmallButton.SelectedColor				Blank
		RuiSmallButton.DisabledColor				Blank
		RuiSmallButton.FocusDisabledColor			Blank

		RuiFooterButton.Style						0
		RuiFooterButton.CursorHeight				36
		RuiFooterButton.TextInsetX					12 // ?
		RuiFooterButton.TextInsetY					4 // ?
		RuiFooterButton.TextColor                   Blank
		RuiFooterButton.LockedColor                 Blank
		RuiFooterButton.FocusColor					Blank
		RuiFooterButton.SelectedColor				Blank
		RuiFooterButton.DisabledColor				Blank
		RuiFooterButton.FocusDisabledColor			Blank

		ComboButton.Style							0
		ComboButton.CursorHeight					40
		ComboButton.TextInsetY						50
//		ComboButton.TextColor                       "160 160 160 255"
//		ComboButton.FocusColor                      "255 255 255 255"

		LargeButton.Style							0
		LargeButton.Font							Default_44
		LargeButton.TextInsetX						12
		LargeButton.TextInsetY						0
		LargeButton.CursorHeight					56

		CenterButton.Style 							0
		CenterButton.TextInsetX 					0
		CenterButton.TextInsetY						7

		SubmenuButton.Style 						0
		SubmenuButton.TextInsetX					79
		SubmenuButton.TextInsetY					7

		KeyBindingsButton.Style 					0
		KeyBindingsButton.TextInsetX				11
        KeyBindingsButton.TextInsetY				0
		KeyBindingsButton.CursorHeight				36

		StatsLevelListButton.Style 					0
		StatsLevelListButton.AllCaps				1
		StatsLevelListButton.CursorHeight			135
		StatsLevelListButton.TextColor 				"204 234 255 255"
		StatsLevelListButton.FocusColor 			"0 0 0 255"
		StatsLevelListButton.SelectedColor 			"255 255 255 255"
		StatsLevelListButton.DisabledColor 			"204 234 255 255"
		StatsLevelListButton.FocusDisabledColor		"204 234 255 255"
		StatsLevelListButton.TextInsetX				79
		StatsLevelListButton.TextInsetY				7

		LobbyPlayerButton.Style						0
		LobbyPlayerButton.Font						Default_27
		LobbyPlayerButton.TextInsetX				48
		LobbyPlayerButton.TextInsetY				2
		LobbyPlayerButton.CursorHeight				37
		LobbyPlayerButton.SelectedColor				"210 170 0 255"

		ChatroomPlayerLook.Style					0
		ChatroomPlayerLook.Font						Default_27
		ChatroomPlayerLook.TextInsetX				32
		ChatroomPlayerLook.TextInsetY				-2
		ChatroomPlayerLook.CursorHeight				27
		ChatroomPlayerLook.SelectedColor			"210 170 0 255"

		CommunityItemLook.Style						0
		CommunityItemLook.Font						Default_27
		CommunityItemLook.TextInsetX				32
		CommunityItemLook.TextInsetY				-2
		CommunityItemLook.CursorHeight				27
		CommunityItemLook.SelectedColor				"210 170 0 255"

		MapButton.Style								0
		MapButton.CursorHeight						89
		MapButton.TextInsetX						79
		MapButton.TextInsetY						7

		PCFooterButton.Style						0
		PCFooterButton.CursorHeight					36
		PCFooterButton.TextInsetX					11

		GridButton.Style 							0
		GridButton.CursorHeight						30
		GridButton.TextInsetX						0
		GridButton.TextInsetY						0

		TitanDecalButton.Style 						0
		TitanDecalButton.CursorHeight				126
		TitanDecalButton.TextInsetX					79
		TitanDecalButton.TextInsetY					7

		Test2Button.Style 					    	0
		Test2Button.CursorHeight			    	96

		CoopStoreButton.Style 						0
		CoopStoreButton.CursorHeight				56
		CoopStoreButton.TextInsetX					79
		CoopStoreButton.TextInsetY					7

		// used by MenuArrowButton
	 	MenuArrowButtonStyle.Style					0
	 	MenuArrowButtonStyle.CursorHeight			90
	}

	//////////////////////// CRITICAL FONTS ////////////////////////////////
	// Very specifc console optimization that precaches critical glyphs to prevent hitching.
	// Adding descriptors here causes super costly memory font pages to be instantly built.
	// CAUTION: Each descriptor could be up to N fonts, due to resolution, proportionality state, etc,
	// so the font page explosion could be quite drastic.
	CriticalFonts
	{
		Default
		{
			uppercase		1
			lowercase		1
			punctuation		1
		}

		InstructorTitle
		{
			commonchars		1
		}

		InstructorKeyBindings
		{
			commonchars		1
		}

		InstructorKeyBindingsSmall
		{
			commonchars		1
		}

		CloseCaption_Console
		{
			commonchars		1
			asianchars		1
			skipifasian		0
			russianchars	1
			uppercase		1
			lowercase		1
		}

		ConfirmationText
		{
			commonchars		1
		}

		DialogTitle
		{
			commonchars		1
		}

		DialogButton
		{
			commonchars		1
		}
	}

	//////////////////////// BITMAP FONT FILES /////////////////////////////
	// Bitmap Fonts are ****VERY*** expensive static memory resources so they are purposely sparse
	BitmapFontFiles
	{
		ControllerButtons		"materials/vgui/fonts/controller_buttons.vbf"			[$DURANGO || $WINDOWS]
		ControllerButtons		"materials/vgui/fonts/controller_buttons_ps4.vbf"		[$PS4]
	}

	//////////////////////// FONTS /////////////////////////////
	// Font Options
	// tall: 		The font size. At 1080, character glyphs will be this many pixels tall including linespace above and below.
	// antialias: 	Smooths font edges.
	// dropshadow: 	Adds a single pixel thick shadow on the bottom and right edges.
	// outline: 	Adds a single pixel thick black outline.
	// blur: 		Blurs the character glyphs. The blur amount can be controlled by the value given.
	// italic: 		Generates italicized glpyhs by slanting the characters.
	// shadowglow: 	Adds a blurry black shadow behind characters. The shadow size can be controlled by the value given.
	// additive:	Renders the text additively.
	// scanlines: 	Adds horizontal scanlines. May need to be additive also to see the effect.
	// underline:	Adds a line under all characters. May no longer work.
	// strikeout: 	Adds a line across all characters. May no longer work.
	// rotary: 		Adds a line across all characters. Doesn't seem very useful.
	// symbol:		Uses the symbol character set when generating the font. Only used with Marlett.
	// bitmap: 		Used with bitmap fonts which is how gamepad button images are shown.
	// custom:		?
	//
	// By default, the game will make a proportional AND a nonproportional version of each
	// font. If you know ahead of time that the font will only ever be used proportionally
	// or nonproportionally, you can conserve resources by telling the engine so with the
	// "isproportional" key. can be one of: "no", "only", or "both".
	// "both" is the default behavior.
	// "only" means ONLY a proportional version will be made.
	// "no" means NO proportional version will be made.
	// this key should come after the named font glyph sets -- eg, it should be inside "Default" and
	// after "1", "2", "3", etc -- *not* inside the "1","2",.. size specs. That is, it should be
	// at the same indent level as "1", not the same indent level as "yres".

	Fonts
	{
		//////////////////////////////////// Font definitions referenced by code ////////////////////////////////////

		Default
		{
			"1"
			{
				name		Default
				tall		28
				antialias 	1
			}
		}

		DefaultBold
		{
			"1"
			{
				name		Default
				tall		12
				weight		1000
			}
		}

		DefaultRegularFont_28
		{
			isproportional	only
			"1"
			{
				name		DefaultRegularFont
				tall		28
				antialias	1
			}
		}

		TitleRegularFont_28
		{
			isproportional	only
			"1"
			{
				name		TitleRegularFont
				tall		28
				antialias	1
			}
		}

		DefaultUnderline
		{
			"1"
			{
				name		Default
				tall		12
				weight		500
				underline 	1
			}
		}

		DefaultSmall
		{
			"1"
			{
				name		Default
				tall		9
				weight		0
			}
		}

		DefaultSmallDropShadow
		{
			"1"
			{
				name		Default
				tall		10
				weight		0
				dropshadow 	1
			}
		}

		DefaultVerySmall
		{
			"1"
			{
				name		Default
				tall		9
				weight		0
			}
		}

		DefaultLarge
		{
			"1"
			{
				name		Default
				tall		13
				weight		0
			}
		}

		MenuLarge
		{
			"1"
			{
				name		Default
				tall		12
				weight		600
				antialias 	1
			}
		}

		ConsoleText
		{
			"1"
			{
				name		"Lucida Console"
				tall		22
				weight		500
			}
		}
		ConsoleTextSmall
		{
			"1"
			{
				name		"Lucida Console"
				tall		14
				weight		250
				antialias	1
			}
		}

		// Dev only - Used for Debugging UI, overlays, etc
		DefaultSystemUI
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		31
				antialias	1
			}
		}

		ChatFont
		{
			isproportional	no
			"1"
			{
				name		Default
				tall		13
				yres		"480 1079"
				antialias	1
				shadowglow	3
			}
			"2"
			{
				name		Default
				tall		16
				yres		"1080 1199"
				antialias	1
				shadowglow	3
			}
			"3"
			{
				name		Default
				tall		19
				yres		"1200 10000"
				antialias	1
				shadowglow	3
			}
		}

		ChatroomFont
		{
			isproportional	no
			"1"
			{
				name		Default
				tall		19
				yres		"480 1079"
				antialias	1
//				shadowglow	3
			}
			"2"
			{
				name		Default
				tall		24
				yres		"1080 1199"
				antialias	1
//				shadowglow	3
			}
			"3"
			{
				name		Default
				tall		28
				yres		"1200 10000"
				antialias	1
//				shadowglow	3
			}
		}

		// this is the symbol font
		MarlettLarge
		{
			"1"
			{
				name		Marlett
				tall		30
				weight		0
				symbol		1
				range		"0x0000 0x007F"	//	Basic Latin
				antialias	1
			}
		}

		// this is the symbol font
		Marlett
		{
			"1"
			{
				name		Marlett
				tall		16
				weight		0
				symbol		1
				range		"0x0000 0x007F"	//	Basic Latin
				antialias	1
			}
		}

		// this is the symbol font
		MarlettSmall
		{
			"1"
			{
				name		Marlett
				tall		8
				weight		0
				symbol		1
				range		"0x0000 0x007F"	//	Basic Latin
				antialias	1
			}
		}

		GameUIButtons
		{
			"1"
			{
				bitmap		1
				name		ControllerButtons
				scalex		0.4
				scaley		0.4
			}
		}

		GameUIButtonsMini
		{
			"1"
			{
				bitmap		1
				name		ControllerButtons
				scalex		0.74
				scaley		0.74
			}
		}

		GameUIButtonsTiny
		{
			"1"
			{
				bitmap		1
				name		ControllerButtons
				scalex		0.56
				scaley		0.56
			}
		}

		// the title heading for a primary menu
		DialogTitle
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		20
				antialias	1
			}
		}

		// an LHS/RHS item appearing on a dialog menu
		DialogButton
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		13
				antialias	1
			}
		}

		// text for the confirmation
		ConfirmationText
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		18
				antialias	1
			}
		}

		CloseCaption_Normal
		{
			"1"
			{
				name		Default
				tall		22
				weight		500
				antialias	1
			}
		}

		CloseCaption_Italic
		{
			"1"
			{
				name		Default
				tall		31
				weight		500
				italic		1
				antialias	1
			}
		}

		CloseCaption_Bold
		{
			"1"
			{
				name		DefaultBold
				tall		31
				weight		900
				antialias	1
			}
		}

		CloseCaption_BoldItalic
		{
			"1"
			{
				name		DefaultBold
				tall		31
				weight		900
				italic		1
				antialias	1
			}
		}

		InstructorTitle
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		13
				antialias	1
			}
		}

		InstructorButtons
		{
			"1"
			{
				bitmap		1
				name		ControllerButtons
				scalex		0.4
				scaley		0.4
			}
		}

		InstructorKeyBindings
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		9
				antialias 	1
			}
		}

		InstructorKeyBindingsSmall
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		7
				antialias 	1
			}
		}

		CenterPrintText
		{
			"1"
			{
				name		Default
				tall		34
				antialias 	1
				additive	1
			}
		}

		//////////////////////////////////// Default font variations ////////////////////////////////////

		Default_9
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		9
				antialias	1
			}
		}

		Default_16
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		16
				antialias	1
			}
		}

		Default_17
		{
			isproportional	only
			"1"
			{
				name 		Default
				tall		17
				antialias	1
			}
		}
		Default_17_Italic
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		17
				antialias 	1
				italic		1
			}
		}

		Default_19
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		19
				antialias	1
			}
		}
		Default_19_DropShadow
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		19
				antialias	1
				dropshadow	1
			}
		}

		Default_21
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		21
				antialias	1
			}
		}
		Default_21_ShadowGlow
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		21
				antialias	1
				shadowglow	7
			}
		}
		Default_21_Outline
		{
			isproportional	only
			"1"
			{
				name 		Default
				tall		21
				antialias	1
				outline 	1
			}
		}
		Default_21_DropShadow
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		21
				antialias	1
				dropshadow	1
			}
		}
		Default_21_Italic
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		21
				antialias 	1
				italic		1
			}
		}

		Default_22
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		22
				antialias	1
			}
		}

		Default_23
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		23
				antialias	1
			}
		}
		Default_23_Outline
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		23
				antialias	1
				outline 	1
			}
		}

		Default_27
		{
			isproportional	only
			"1"
			{
				name 		Default
				tall		27
				antialias	1
			}
		}
		Default_27_ShadowGlow
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		27
				antialias	1
				shadowglow	4
			}
		}
		Default_27_DropShadow
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		27
				antialias	1
				dropshadow 	1
			}
		}

		Default_28
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		28
				antialias	1
			}
		}
		Default_28_ShadowGlow
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		28
				antialias	1
				shadowglow	4
			}
		}
		Default_28_Outline
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		28
				antialias	1
				outline 	1
			}
		}
		Default_28_DropShadow
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		28
				antialias	1
				dropshadow	1
			}
		}

		Default_29
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		29
				antialias	1
			}
		}

		Default_31
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		31
				antialias	1
			}
		}
		Default_31_ShadowGlow
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		31
				antialias	1
				shadowglow	7
			}
		}
		Default_31_Outline
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		31
				antialias	1
				outline 	1
			}
		}

		Default_34
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		34
				antialias	1
			}
		}
		Default_34_ShadowGlow
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		34
				antialias	1
				shadowglow	7
			}
		}

		Default_38
		{
			isproportional	only
			"1"
			{
				name 		Default
				tall		38
				antialias	1
			}
		}

		Default_39
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		39
				antialias	1
			}
		}

		Default_41
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		41
				antialias	1
			}
		}

		Default_43
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		43
				antialias	1
			}
		}
		Default_43_DropShadow
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		43
				antialias	1
				dropshadow	1
			}
		}

		Default_44
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		44
				antialias	1
			}
		}
		Default_44_DropShadow
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		44
				antialias	1
				dropshadow	1
			}
		}

		Default_49
		{
			isproportional	only
			"1"
			{
				name 		Default
				tall		49
				antialias	1
			}
		}

		Default_59
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		59
				antialias	1
			}
		}

		Default_69_DropShadow
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		69
				antialias 	1
				dropshadow	1
			}
		}

		//////////////////////////////////// Default bold font variations ////////////////////////////////////

		DefaultBold_17
		{
			isproportional	only
			"1"
			{
				name		DefaultBold
				tall		17
				antialias	1
			}
		}

		DefaultBold_21
		{
			isproportional	only
			"1"
			{
				name		DefaultBold
				tall		21
				antialias	1
			}
		}

		DefaultBold_22
		{
			isproportional	only
			"1"
			{
				name		DefaultBold
				tall		22
				antialias	1
			}
		}

		DefaultBold_23
		{
			isproportional	only
			"1"
			{
				name		DefaultBold
				tall		23
				antialias	1
			}
		}
		DefaultBold_23_Outline
		{
			isproportional	only
			"1"
			{
				name		DefaultBold
				tall		23
				antialias	1
				outline 	1
			}
		}

		DefaultBold_27_DropShadow
		{
			isproportional	only
			"1"
			{
				name		DefaultBold
				tall		27
				antialias 	1
				dropshadow	1
			}
		}

		DefaultBold_30
		{
			isproportional	only
			"1"
			{
				name		DefaultBold
				tall		30
				antialias	1
			}
		}

		DefaultBold_33
		{
			isproportional	only
			"1"
			{
				name		DefaultBold
				tall		33
				antialias	1
			}
		}

		DefaultBold_34
		{
			isproportional	only
			"1"
			{
				name		DefaultBold
				tall		34
				antialias 	1
			}
		}

		DefaultBold_38
		{
			isproportional	only
			"1"
			{
				name		DefaultBold
				tall		38
				antialias	1
			}
		}

		DefaultBold_41
		{
			isproportional	only
			"1"
			{
				name		DefaultBold
				tall		41
				antialias	1
			}
		}

		DefaultBold_43
		{
			isproportional	only
			"1"
			{
				name		DefaultBold
				tall		43
				antialias	1
			}
		}

		DefaultBold_44
		{
			isproportional	only
			"1"
			{
				name		DefaultBold
				tall		44
				antialias	1
			}
		}
		DefaultBold_44_DropShadow
		{
			isproportional	only
			"1"
			{
				name		DefaultBold
				tall		44
				antialias 	1
				dropshadow	1
			}
		}

		DefaultBold_49
		{
			isproportional	only
			"1"
			{
				name		DefaultBold
				tall		49
				antialias	1
			}
		}

		DefaultBold_51
		{
			isproportional	only
			"1"
			{
				name		DefaultBold
				tall		51
				antialias	1
			}
		}

		DefaultBold_51_Outline
		{
			isproportional	only
			"1"
			{
				name		DefaultBold
				tall		51
				antialias	1
				outline 	1
			}
		}

		DefaultBold_53
		{
			isproportional	only
			"1"
			{
				name		DefaultBold
				tall		53
				antialias	1
			}
		}
		DefaultBold_53_DropShadow
		{
			isproportional	only
			"1"
			{
				name		DefaultBold
				tall		53
				antialias	1
				dropshadow 	1
			}
		}

		DefaultBold_65
		{
			isproportional	only
			"1"
			{
				name		DefaultBold
				tall		65
				antialias	1
			}
		}

		DefaultBold_65_ShadowGlow
		{
			isproportional	only
			"1"
			{
				name		DefaultBold
				tall		65
				antialias	1
				shadowglow	7
			}
		}

		DefaultBold_80
		{
			isproportional	only
			"1"
			{
				name		DefaultBold
				tall		80
				antialias	1
			}
		}

		//////////////////////////////////// Titanfall font variations ////////////////////////////////////

		Titanfall_67
		{
			isproportional	only
			"1"
			{
				name 		Titanfall
				tall		67
				antialias	1
			}
		}

		//////////////////////////////////// Special-case definitions ////////////////////////////////////

		LoadScreenMapDesc
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		28 [!$JAPANESE]
				tall		20 [$JAPANESE]
				antialias	1
			}
		}

		PlaylistHeaderFont
		{
			isproportional	only
			"1"
			{
				name		Default
				tall		43 [!$JAPANESE]
				tall		30 [$JAPANESE]
				antialias	1
			}
		}
	}

	//////////////////// BORDERS //////////////////////////////
	// describes all the border types
	Borders
	{
		ButtonBorder			NoBorder
		PropertySheetBorder		RaisedBorder

		FrameBorder
		{
			backgroundtype		0
		}

		BaseBorder
		{
			inset 	"0 0 1 1"

			Left
			{
				"1"
				{
					color 	Border.Dark
					offset	"0 1"
				}
			}
			Right
			{
				"1"
				{
					color 	Border.Bright
					offset	"1 0"
				}
			}
			Top
			{
				"1"
				{
					color 	Border.Dark
					offset 	"0 0"
				}
			}
			Bottom
			{
				"1"
				{
					color 	Border.Bright
					offset 	"0 0"
				}
			}
		}

		RaisedBorder
		{
			inset 	"0 0 1 1"

			Left
			{
				"1"
				{
					color 	Border.Bright
					offset 	"0 1"
				}
			}
			Right
			{
				"1"
				{
					color 	Border.Dark
					offset 	"0 0"
				}
			}
			Top
			{
				"1"
				{
					color 	Border.Bright
					offset 	"0 1"
				}
			}
			Bottom
			{
				"1"
				{
					color 	Border.Dark
					offset 	"0 0"
				}
			}
		}

		TitleButtonBorder
		{
			inset 	"0 0 1 1"

			Left
			{
				"1"
				{
					color 	BorderBright
					offset 	"0 1"
				}
			}
			Right
			{
				"1"
				{
					color 	BorderDark
					offset 	"1 0"
				}
			}
			Top
			{
				"4"
				{
					color 	BorderBright
					offset 	"0 0"
				}
			}
			Bottom
			{
				"1"
				{
					color 	BorderDark
					offset 	"0 0"
				}
			}
		}

		TitleButtonDisabledBorder
		{
			inset 	"0 0 1 1"

			Left
			{
				"1"
				{
					color 	BgColor
					offset 	"0 1"
				}
			}
			Right
			{
				"1"
				{
					color 	BgColor
					offset 	"1 0"
				}
			}
			Top
			{
				"1"
				{
					color 	BgColor
					offset 	"0 0"
				}
			}

			Bottom
			{
				"1"
				{
					color 	BgColor
					offset 	"0 0"
				}
			}
		}

		TitleButtonDepressedBorder
		{
			inset 	"1 1 1 1"

			Left
			{
				"1"
				{
					color 	BorderDark
					offset 	"0 1"
				}
			}
			Right
			{
				"1"
				{
					color 	BorderBright
					offset 	"1 0"
				}
			}
			Top
			{
				"1"
				{
					color 	BorderDark
					offset 	"0 0"
				}
			}
			Bottom
			{
				"1"
				{
					color 	BorderBright
					offset 	"0 0"
				}
			}
		}

		NoBorder
		{
			inset "0 0 0 0"
			Left {}
			Right {}
			Top {}
			Bottom {}
		}

		ScrollBarButtonBorder
		{
			inset "0 0 0 0"
			Left {}
			Right {}
			Top {}
			Bottom {}
		}
		ScrollBarButtonDepressedBorder ScrollBarButtonBorder

		ScrollBarSliderBorder
		{
			inset "0 0 0 0"
			Left {}
			Right {}
			Top {}
			Bottom {}
		}
		ScrollBarSliderBorderHover ScrollBarSliderBorder
		ScrollBarSliderBorderDragging ScrollBarSliderBorder

		ButtonBorder	//[0]
		{
			inset 	"0 0 1 1"

			Left
			{
				"1"
				{
					color 	BorderBright
					offset 	"0 1"
				}
			}
			Right
			{
				"1"
				{
					color 	BorderDark
					offset 	"0 0"
				}
			}
			Top
			{
				"1"
				{
					color 	BorderBright
					offset 	"0 1"
				}
			}
			Bottom
			{
				"1"
				{
					color 	BorderDark
					offset 	"0 0"
				}
			}
		}

		TabBorder
		{
			inset 	"0 0 1 1"

			Left
			{
				"1"
				{
					color 	Border.Bright
					offset 	"0 1"
				}
			}
			Right
			{
				"1"
				{
					color 	Border.Dark
					offset 	"1 0"
				}
			}
			Top
			{
				"1"
				{
					color 	Border.Bright
					offset 	"0 0"
				}
			}
			Bottom
			{
				"1"
				{
					color 	Border.Bright
					offset 	"0 0"
				}
			}
		}

		TabActiveBorder
		{
			inset 	"0 0 1 0"

			Left
			{
				"1"
				{
					color 	Border.Bright
					offset 	"0 0"
				}
			}
			Right
			{
				"1"
				{
					color 	Border.Dark
					offset 	"1 0"
				}
			}
			Top
			{
				"1"
				{
					color 	Border.Bright
					offset 	"0 0"
				}
			}
			Bottom
			{
				"1"
				{
					color 	ControlBG
					offset 	"6 2"
				}
			}
		}

		ToolTipBorder
		{
			inset 	"0 0 1 0"

			Left
			{
				"1"
				{
					color 	BorderDark
					offset 	"0 0"
				}
			}
			Right
			{
				"1"
				{
					color 	BorderDark
					offset 	"1 0"
				}
			}
			Top
			{
				"1"
				{
					color 	BorderDark
					offset 	"0 0"
				}
			}
			Bottom
			{
				"1"
				{
					color 	BorderDark
					offset 	"0 0"
				}
			}
		}

		// this is the border used for default buttons (the button that gets pressed when you hit enter)
		ButtonKeyFocusBorder
		{
			inset 	"0 0 1 1"

			Left
			{
				"1"
				{
					color 	Border.Selection
					offset 	"0 0"
				}
				"2"
				{
					color 	Border.Bright
					offset 	"0 1"
				}
			}
			Top
			{
				"1"
				{
					color 	Border.Selection
					offset 	"0 0"
				}
				"2"
				{
					color 	Border.Bright
					offset 	"1 0"
				}
			}
			Right
			{
				"1"
				{
					color 	Border.Selection
					offset 	"0 0"
				}
				"2"
				{
					color 	Border.Dark
					offset 	"1 0"
				}
			}
			Bottom
			{
				"1"
				{
					color 	Border.Selection
					offset 	"0 0"
				}
				"2"
				{
					color 	Border.Dark
					offset 	"0 0"
				}
			}
		}

		ButtonDepressedBorder
		{
			inset "0 0 0 0"
			Left {}
			Right {}
			Top {}
			Bottom {}
		}

		ComboBoxBorder
		{
			inset 	"0 0 1 1"

			Left
			{
				"1"
				{
					color 	BorderDark
					offset 	"0 1"
				}
			}
			Right
			{
				"1"
				{
					color 	BorderBright
					offset 	"1 0"
				}
			}
			Top
			{
				"1"
				{
					color 	BorderDark
					offset 	"0 0"
				}
			}
			Bottom
			{
				"1"
				{
					color 	BorderBright
					offset 	"0 0"
				}
			}
		}

		MenuBorder
		{
			inset 	"1 1 1 1"

			Left
			{
				"1"
				{
					color 	BorderBright
					offset 	"0 1"
				}
			}
			Right
			{
				"1"
				{
					color 	BorderDark
					offset 	"1 0"
				}
			}
			Top
			{
				"1"
				{
					color 	BorderBright
					offset 	"0 0"
				}
			}
			Bottom
			{
				"1"
				{
					color 	BorderDark
					offset 	"0 0"
				}
			}
		}
	}

	InheritableProperties
	{
		ChatBox
		{
			wide					630
			tall					155

			bgcolor_override 		"0 0 0 180"

			chatBorderThickness		3

			chatHistoryBgColor		"24 27 30 200"
			chatEntryBgColor		"24 27 30 200"
			chatEntryBgColorFocused	"24 27 30 200"
		}

		FS_ChatBox_Modded
		{
			wide					1200
			tall					300

			bgcolor_override 		"0 0 0 210"

			chatBorderThickness		15

			chatHistoryBgColor		"31 159 161 200"
			chatEntryBgColor		"161 31 98 200"
			chatEntryBgColorFocused	"235 52 152 200"
		}

		CreditsJobTitle
		{
			ControlName				Label
			xpos					c-686
			ypos					0
			wide					300
			tall					45
			textAlignment			"east"
			//bgcolor_override		"60 60 60 255"
			fgcolor_override		"160 224 250 255"
			font					Default_28
			visible 				0
			labelText				"Title"
		}

		CreditsName
		{
			ControlName				Label
			xpos					22
			wide					674
			tall					45
			textAlignment			"west"
			//bgcolor_override		"60 60 100 255"
			font					Default_28
			pin_corner_to_sibling	TOP_LEFT
			pin_to_sibling_corner	TOP_RIGHT
			visible 				0
			labelText				"First Last"
		}

		CreditsCentered
		{
			ControlName				Label
			xpos					c-674
			wide					1349
			tall					45
			textAlignment			center
			//bgcolor_override		"60 60 100 255"
			font					Default_28
			visible 				0
			labelText				"First Last"
		}

		CreditsDepartment
		{
			ControlName				Label
			xpos					c-461
			ypos					0
			zpos					100
			wide					922
			tall					67
			textAlignment			"center"
			//bgcolor_override		"100 60 60 255"
			fgcolor_override		"255 180 75 255"
			font					DefaultBold_34
			visible 				0
			labelText				"Department"
		}

		CreditsDepartmentScan
		{
			ControlName				ImagePanel
			ypos 					27
			zpos					90
			wide					922
			tall					67
			image					"vgui/HUD/flare_announcement"
			visible					0
			scaleImage				1
			pin_corner_to_sibling	CENTER
			pin_to_sibling_corner	CENTER
		}

		EndMenuCongratsLine
		{
			ControlName				Label
			xpos					0
			ypos					0
			wide					600
			tall					30
			textAlignment			"west"
			fgcolor_override		"160 224 250 255"
			//fgcolor_override		"255 180 75 255"
			//bgcolor_override		"100 60 60 100"
			font					Default_17
			visible 				0
		}

		EndMenuCongratsLineShadow
		{
			ControlName				Label
			xpos					-2
			ypos					-2
			zpos 					-1
			wide					600
			tall					30
			textAlignment			"west"
			fgcolor_override		"40 40 40 150"
			font					Default_17
			visible 				0

			pin_corner_to_sibling	TOP_LEFT
			pin_to_sibling_corner	TOP_LEFT
		}

		DefaultButton
		{
			wide					674
			tall					45
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
			style					DefaultButton
			childGroupNormal		DefaultButtonNormalGroup
			childGroupFocused		DefaultButtonFocusGroup
			childGroupLocked		DefaultButtonLockedGroup
			childGroupNew			DefaultButtonNewGroup
		}

		CompactButton
		{
			wide					674
			tall					40
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
			style					CompactButton
			childGroupNormal		CompactButtonNormalGroup
			childGroupFocused		CompactButtonFocusGroup
			childGroupLocked		CompactButtonLockedGroup
			childGroupNew			CompactButtonNewGroup
			childGroupSelected		CompactButtonSelectedGroup
		}

		SmallButton
		{
			wide					540
			tall					40
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
			style					SmallButton
			childGroupNormal		SmallButtonNormalGroup
			childGroupFocused		SmallButtonFocusGroup
			childGroupSelected		SmallButtonSelectedGroup
			childGroupLocked        SmallButtonLockedGroup
		}

		SpotlightButtonLarge
		{
			wide					540
			tall					254
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
            rui						"ui/spotlight_button_large.rpak"
			labelText				""
			style					RuiButton
		}

		SpotlightButtonSmall
		{
			wide					267
			tall					124
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
            rui						"ui/spotlight_button_small.rpak"
			labelText				""
			style	                RuiButton
		}

		RuiSmallButton
		{
			wide					540
			tall					40
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
            rui						"ui/test_button.rpak"
			labelText				""
			style					SmallButton
		}

		RuiInboxButton
		{
			wide					660
			tall					68
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
            rui						"ui/menu_inbox_button.rpak"
			labelText				""
			style					RuiButton
		}

		RuiKNBSubjectButton
		{
			wide					540
			tall					48
			zpos					3
			visible					1
			enabled					1
            rui						"ui/knb_subject_button.rpak"
			labelText				""
			style					RuiButton
		}

		RuiMixtapeChecklistButton
		{
			wide					620
			tall					60
			zpos					3
			visible					1
			enabled					1
            rui						"ui/mixtape_checklist_button.rpak"
			labelText				""
			style					RuiButton
		}

		RuiMixtapeChecklistIconButton
		{
			wide					96
			tall					120
			zpos					3
			visible					1
			enabled					1
            rui						"ui/mixtape_checklist_small_button.rpak"
			labelText				""
			style					RuiButton
		}

		RuiGamepadBindButton
		{
			wide					500
			tall					60
			zpos					3
			visible					1
			enabled					1
            rui						"ui/gamepad_bindlist_button.rpak"
			labelText				""
			style					RuiButton
		}

		RuiStartMatchButton
		{
			wide					500
			tall					56
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
            rui						"ui/start_match_button.rpak"
			labelText				""
			style					RuiButton
		}

		RuiStoreButtonFront
		{
			wide					720
			tall					60
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
            rui						"ui/store_button_front.rpak"
			labelText				""
			style					RuiButton
            clip 					0
		}

		RuiStoreButtonBundle
		{
			wide					900
			tall					60
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
            rui						"ui/store_button_bundle.rpak"
			labelText				""
			style					RuiButton
            clip 					0
		}

		RuiStoreButtonWeaponSkinSet
		{
			wide					900
			tall					60
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
            rui						"ui/store_button_weapon_skin_set.rpak"
			labelText				""
			style					RuiButton
            clip 					0
		}

		RuiStoreButtonWeapon
		{
			wide					800
			tall					60
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
            rui						"ui/store_button_weapon.rpak"
			labelText				""
			style					RuiButton
            clip 					0
		}

		RuiStoreButtonPrime
		{
			wide					680
			tall					60
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
            rui						"ui/store_button_prime.rpak"
			labelText				""
			style					RuiButton
            clip 					0
		}

		RuiStoreBuyButton
		{
			wide					320
			tall					128
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
            rui						"ui/store_buy_button.rpak"
			labelText				""
			style					RuiButton
            clip 					0
		}

		RuiMenuButtonSmall
		{
			wide					288
			tall					40
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
            rui						"ui/menu_button_small.rpak"
			labelText				""
			style					RuiSmallButton
            clip 					0
			childGroupLocked        SmallButtonLockedGroup
		}

		StoreMenuButtonSmall
		{
			wide					288
			tall					40
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
            rui						"ui/menu_button_small.rpak"
			labelText				""
			style					RuiSmallButton
            clip 					0
		}

		RuiLoadoutSelectionButton
		{
			wide					224
			tall					56
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
            rui						"ui/loadout_selection_button.rpak"
			labelText				""
			style					RuiButton
            clip 					0
		}

		RuiPilotSelectionButton
		{
			wide					224
			tall					75
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
            rui						"ui/pilot_selection_button.rpak"
			labelText				""
			style					RuiButton
            clip 					0
		}

		RuiComboSelectButton
		{
			wide					288
			tall					40
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
            rui						"ui/combo_select_button.rpak"
			labelText				""
			style					RuiSmallButton
            clip 					0
		}

		RuiLoadoutType
		{
			wide					800
			tall					27
			visible					1
            rui						"ui/loadout_type_label.rpak"
		}

		RuiLoadoutLabel
		{
			wide					800
			tall					27
			visible					1
            rui						"ui/loadout_label.rpak"
		}

		RuiBindLabel
		{
			wide					600
			tall					27
			visible					1
            rui						"ui/bind_label.rpak"
		}

		RuiCheckBox
		{
			wide					40
			tall					40
			visible					1
			enabled					1
            rui						"ui/button_checkbox.rpak"
			labelText				""
			style					RuiButton
		}

		RuiSkipLabel
		{
			wide					800
			tall					29
			visible					1
            rui						"ui/skip_label.rpak"
		}

		RuiDialogSpinner
		{
			wide					106
			tall					106
			visible					1
            rui						"ui/dialog_spinner.rpak"
		}

		ComboButtonLarge
		{
            auto_wide_tocontents    1
			tall				    100
            textAlignment			west
			zpos					3 // Needed or clicking on the background can hide this
			font					Default_28 [!$JAPANESE && !$TCHINESE]
			font					Default_38 [$TCHINESE]
			font					Default_38 [$JAPANESE]
			enabled					1
			TextInsetX              30
			allCaps                 0
			style					ComboButton
			visible					0
			childGroupAlways        ComboButtonLargeAlways
//			fgcolor_override        "255 255 0 64"
//			bgcolor_override        "255 255 0 64"
//			drawColor               "255 255 0 64"
            clip 					0
		}

		ComboButtonTitleLarge
		{
            wide                    560
            tall                    70
			font					DefaultBold_51_Outline
			textAlignment			north-west
			allcaps					1
			visible					0
			zpos                    4

			pin_corner_to_sibling	TOP_LEFT
			pin_to_sibling_corner	TOP_LEFT
		}

		LoadoutButton
		{
			wide					540
			tall					40
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
			style					LoadoutButton
			childGroupNormal		LoadoutButtonNormalGroup
			childGroupFocused		LoadoutButtonFocusGroup
			//childGroupLocked		DefaultButtonLockedGroup
			//childGroupNew			DefaultButtonNewGroup
		}

		LargeButton
		{
			wide					540
			tall					56
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
			style					LargeButton
			childGroupNormal		LargeButtonNormalGroup
			childGroupFocused		LargeButtonFocusGroup
			childGroupLocked		LargeButtonLockedGroup
			childGroupNew	        LargeButtonNewGroup
		}

		SubmenuButton
		{
			wide					540
			tall					45
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
			style					SubmenuButton
			childGroupNormal		SubmenuButtonNormalGroup
			childGroupFocused		SubmenuButtonFocusGroup
			childGroupLocked		SubmenuButtonLockedGroup
			childGroupNew			SubmenuButtonNewGroup
			childGroupSelected		SubmenuButtonSelectedGroup
		}

		DialogButton
		{
			wide					780
			tall					45
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
			style					DefaultButton
			textAlignment			center
			childGroupNormal		DialogButtonNormalGroup
			childGroupFocused		DialogButtonFocusGroup
		}

		CenterButton
		{
			wide					450
			tall					45
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
			style					CenterButton
			textAlignment			center
			childGroupNormal		CenterButtonNormalGroup
			childGroupFocused		CenterButtonFocusGroup
		}

        FullSizer
        {
            //ControlName           Panel
            proportionalToParent    1
            xpos                    0
            ypos                    0
            zpos                    0
            enabled                 0
            wide                    %100
            tall                    %100
            rui                     "ui/basic_image.rpak"
            ruiArgs
            {
                basicImageAlpha     0.0
            }
            visible                 0
        }

        SettingsScrollFrame
        {
            xpos					0
            ypos					0
            wide					1064
            tall					704
            visible					1
            proportionalToParent	1
        }

        SettingsPanelFull
        {
		    classname				"TabPanelClass"
		    xpos					0
		    ypos					0
			wide					%100
			tall					1028
		    visible					0
		    controlSettingsFile		"resource/ui/menus/panels/settings.res"
		    clip                    1
            tabPosition				1
        }

        SettingsTabPanel
        {
            xpos                    64
            ypos					-128//-64
            wide					1728 //%100
            tall					836//740
            visible				    0
            clip                    1
            proportionalToParent	1
        }

        SettingsScrollBar
        {
            xpos                    8
            ypos                    0
            wide					24
            tall					836//740
            visible					1
            enabled 				1
            rui						"ui/survival_scroll_bar.rpak"
            zpos                    101
        }

        SettingsContentPanel
        {
            xpos					0
            ypos					0
            wide					%100
            tall					836//740
            visible					1
            proportionalToParent	1
        }

        SettingsDetailsPanel
        {
            xpos				    564//-1568
            ypos					-128//-64
            wide					548
            tall					836//740
            visible					1
            rui                     "ui/settings_details.rpak"
        }

		WideButton
		{
			wide					1040
			tall					60
			visible					1
			enabled					1
			style					SmallButton
            rui                     "ui/generic_item_button.rpak"
            clipRui					1
			labelText				""
			ypos                    4
		}

		ThinButton
		{
			wide					528
			tall					50
			visible					1
			enabled					1
			style					SmallButton
            rui                     "ui/generic_item_button.rpak"
            clipRui					1
			labelText				""
			ypos                    4
		}

		SettingBasicButton
		{
			font                    Default_28
			wide					1040
			tall					60
			zpos					3
			ypos                    2
			visible					1
			enabled					1
			rui						"ui/settings_base_button.rpak"
			clipRui					1
			labelText               ""
            cursorVelocityModifier  0.7

            sound_accept            "UI_Menu_Accept"
		}

		SwitchButton
		{
			font                    Default_28
			wide					1040
			tall					60
			zpos					3
			ypos                    2
			visible					1
			enabled					1
			style					DialogListButton
			rui						"ui/settings_base_button.rpak"
			clipRui					1
			labelText               ""
			nonDefaultColor	"244 213 166 255"
            cursorVelocityModifier  0.7
		}

		SwitchButtonThin
		{
			font                    Default_28
			wide					1040
			tall					40
			zpos					3
			ypos                    4
			visible					1
			enabled					1
			style					DialogListButton
			rui						"ui/settings_base_button.rpak"
			clipRui					1
			labelText               ""
			nonDefaultColor	"244 213 166 255"
            cursorVelocityModifier  0.7
		}

		SliderControl
		{
			wide					1040
			tall					60
			zpos					3 // Needed or clicking on the background can hide this
			ypos                    2
			visible					1
			enabled					1
            cursorVelocityModifier  0.7
		}

		SliderControlThin
		{
			wide					1040
			tall					40
			zpos					3 // Needed or clicking on the background can hide this
			ypos                    4
			visible					1
			enabled					1
            cursorVelocityModifier  0.7
		}

		SliderControlTextEntry
		{
            xpos                    -8
            zpos					100 // This works around input weirdness when the control is constructed by code instead of VGUI blackbox.
            wide					48
            tall					48
            visible					1
            enabled					1
            textHidden				0
            editable				1
            maxchars				4
            NumericInputOnly		1
            textAlignment			"center"
            ruiFont                 TitleRegularFont
            ruiFontHeight           22
            ruiMinFontHeight        10
            keyboardTitle			"#ENTER_YOUR_EMAIL"
            keyboardDescription		"#ENTER_YOUR_EMAIL_DESC"
            allowRightClickMenu		0
            allowSpecialCharacters	0
            unicode					0
            showConVarAsFloat		1
            selectOnFocus           1
            cursorVelocityModifier  0.7
		}
		
		SliderControlTextEntrySmall
		{
            xpos                    -4
            zpos					100 // This works around input weirdness when the control is constructed by code instead of VGUI blackbox.
            ypos					2 // meh
			wide					60
            tall					44
            visible					1
            enabled					1
            textHidden				0
            editable				1
            maxchars				10
            NumericInputOnly		1
            textAlignment			"center"
            ruiFont                 TitleRegularFont
            ruiFontHeight           10
            ruiMinFontHeight        10
            keyboardTitle			"#ENTER_YOUR_EMAIL"
            keyboardDescription		"#ENTER_YOUR_EMAIL_DESC"
            allowRightClickMenu		0
            allowSpecialCharacters	0
            unicode					0
            showConVarAsFloat		1
            selectOnFocus           1
            cursorVelocityModifier  0.7
		}

		CommunityEditButton
		{
			wide					840
			tall					40
			zpos					3
			visible					1
			enabled					1
			style					DialogListButton
			rui						"ui/wide_button.rpak"
			clipRui					1
			labelText               ""
		}

		AdvocateLine
		{
			classname 				AdvocateLine
			tall					36
			auto_wide_tocontents	1
			visible					1
			font					Default_28
			textAlignment			west
			fgcolor_override		"204 234 255 255"
			labelText				"--"
		}

		RankedPlayDetailsProperties
		{
			classname 				RankedPlayDetails
			wide					386
			zpos					40
			ypos					4

			auto_tall_tocontents 	1
			wrap					1
			visible 				1
			font 					DefaultSmall
			allcaps					0
			fgcolor_override		"163 187 204 255"
			textAlignment			north-west
		}

		SwitchCommunityList
		{
			wide					1163
			tall					595
			paintborder				0
			NoWrap					0
			panelBorder				0
			clip 					0
		}

		SwitchCommunityListButton
		{
			wide					1163
			tall					27
			visible					1
			enabled					1
			scaleImage				1
			style					CommunityItemLook
			childGroupAlways		CommunityAlwaysGroup
			childGroupNormal		CommunityNormalGroup
			childGroupFocused		CommunityFocusGroup
			clip 					0
		}

		LobbyPlayerListBackground
		{
			wide					500
			tall					312
		}

		LobbyPlayerList
		{
			wide					476
			tall					288
			paintborder				0
			NoWrap					0
			panelBorder				0
			clip 					0
			bgcolor_override		"0 0 0 0"
		}

		LobbyNeutralSlot
		{
			wide					476
			tall					35
			visible					1
			scaleImage				1
			image 					"ui/menu/lobby/neutral_slot"
		}

		LobbyFriendlySlot
		{
			inheritProperties LobbyNeutralSlot
			image 					"ui/menu/lobby/friendly_slot"
		}

		LobbyEnemySlot
		{
			inheritProperties LobbyNeutralSlot
			image 					"ui/menu/lobby/enemy_slot"
		}

		LobbyFriendlyButton
		{
			wide					476
			tall					37
			visible					1
			enabled					1
			style					LobbyPlayerButton
			scriptid				PlayerListButton
			childGroupAlways		LobbyFriendlyAlwaysGroup
			childGroupNormal		LobbyPlayerNormalGroup
			childGroupFocused		LobbyFriendlyFocusGroup
			clip 					0
		}

		ChatroomPlayerButton
		{
			wide					259
			tall					27
			visible					1
			enabled					1
			scaleImage				1
			style					ChatroomPlayerLook
			childGroupAlways		ChatroomAlwaysGroup
			childGroupNormal		ChatroomNormalGroup
			childGroupFocused		ChatroomFocusGroup
			clip 					0
		}

		LobbyEnemyButton
		{
			wide					476
			tall					37
			visible					1
			enabled					1
			style					LobbyPlayerButton
			scriptid				PlayerListButton
			childGroupAlways		LobbyEnemyAlwaysGroup
			childGroupNormal		LobbyPlayerNormalGroup
			childGroupFocused		LobbyEnemyFocusGroup
			clip 					0
		}

		MapButton
		{
			wide					158
			tall					89
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
			style					MapButton
			allcaps					1
			childGroupAlways		MapButtonAlwaysGroup
			childGroupNormal		MapButtonNormalGroup
			childGroupFocused		MapButtonFocusGroup
			childGroupLocked		MapButtonLockedGroup
		}

		TabButton
		{
			classname				TabButtonClass
			wide					300
			tall					40
			visible					1
			enabled					1
			style					RuiButton
            rui						"ui/tab_button.rpak"
			labelText				""
			cursorVelocityModifier  0.7
		}

		TabShoulder
		{
            wide                    72
            tall					68
            visible					1
            rui                     "ui/shoulder_navigation_shortcut.rpak"
            activeInputExclusivePaint	gamepad

			style					RuiButton
		}

		TabButtonLobby
		{
			classname				TabButtonClass
			wide					284
    		polyShape               "0.0 0.0 0.71 0.0 1.0 1.0 0.29 1.0" // height / width to determine offsets
			tall					84
			visible					1
			enabled					1
			style					RuiButton
            rui						"ui/tab_button_lobby.rpak"
			labelText				""
			cursorVelocityModifier  0.7
			sound_focus             "UI_Menu_Focus_Large"
			sound_accept            "UI_Menu_ApexTab_Select"
		}

		TabButtonStore
		{
			classname				TabButtonClass
			wide					260
			tall					44
    		polyShape               "0.0 0.0 0.831 0.0 1.0 1.0 0.169 1.0" // height / width to determine offsets
			visible					1
			enabled					1
			style					RuiButton
            rui						"ui/tab_button_store.rpak"
			labelText				""
			cursorVelocityModifier  0.7
			zpos                    10
			sound_focus             "UI_Menu_Focus_Large"
			sound_accept            "UI_Menu_StoreTab_Select"
		}

		TabButtonCharacterCustomize
		{
			classname				TabButtonClass
			wide					260
			tall					44
			polyShape               "0.0 0.0 0.831 0.0 1.0 1.0 0.169 1.0" // height / width to determine offsets
			visible					1
			enabled					1
			style					RuiButton
            rui						"ui/tab_button_character_customize.rpak"
			labelText				""
			cursorVelocityModifier  0.7
			sound_accept            "UI_Menu_LegendTab_Select"
		}

		TabButtonSettings
		{
			classname				TabButtonClass
			wide					284
    		polyShape               "0.0 0.0 0.71 0.0 1.0 1.0 0.29 1.0" // height / width to determine offsets
			tall					84
			visible					1
			enabled					1
			style					RuiButton
            rui						"ui/tab_button_lobby.rpak"
			labelText				""
			cursorVelocityModifier  0.7
			sound_focus             "UI_Menu_Focus_Large"
			sound_accept            "UI_Menu_SettingsTab_Select"
		}

		TabButtonWeaponCustomize
		{
			classname				TabButtonClass
			wide					260
			tall					44
			polyShape               "0.0 0.0 0.831 0.0 1.0 1.0 0.169 1.0" // height / width to determine offsets
			visible					1
			enabled					1
			style					RuiButton
            rui						"ui/tab_button_character_customize.rpak"
			labelText				""
			cursorVelocityModifier  0.7
			sound_accept            "UI_Menu_ArmoryTab_Select"
		}

		InviteButton
		{
            wide					148
            tall					148
            rui                     "ui/invite_button.rpak"
            labelText               ""
            visible					1
            cursorVelocityModifier  0.7

            proportionalToParent    1

			sound_focus             "UI_Menu_Focus"
            sound_accept            "UI_Menu_InviteFriend_Open"
		}

		CornerButton
		{
			classname               MenuButton
            wide					60
            tall					60
            rui                     "ui/generic_icon_button.rpak"
            labelText               ""
            visible					1
            cursorVelocityModifier  0.7

            proportionalToParent    1

			sound_focus             "UI_Menu_Focus_Small"
		}

		LootInspectButton
		{
            wide					375
            tall					770
            zpos					3
            rui						"ui/loot_inspect_button.rpak"
            labelText				""
            visible					1
            enabled					0
            sound_accept            "UI_Menu_LootPreview"
        }

		StatsLevelListButton
		{
			xpos					0
			ypos					0
			zpos					100
			wide					337
			tall					135
			visible					1
			enabled					1
			style					StatsLevelListButton
			allcaps					1
			textAlignment			center
			labelText				""
			childGroupNormal		StatsLevelListButtonNormalGroup
			childGroupFocused		StatsLevelListButtonFocusedGroup
			childGroupSelected		StatsLevelListButtonSelectedGroup
			childGroupDisabled		StatsLevelListButtonNormalGroup
		}

		SP_Level_Button
		{
			xpos					0
			ypos					0
			zpos					2
			wide					64
			tall					64
			visible					1
			enabled					1
			style					TitanDecalButton
			allcaps					0
			textAlignment			left
            rui						"ui/mission_select_button.rpak"
			labelText 				""
		}

		SP_Difficulty_Select
		{
			xpos					0
			ypos					0
			zpos					2
			wide					64
			tall					64
			visible					1
			enabled					1
			style					TitanDecalButton
			allcaps					0
			textAlignment			left
            rui						"ui/sp_difficulty_select.rpak"
			labelText 				""
		}

		SP_TitanLoadout
		{
			xpos					0
			ypos					0
			zpos					2
			wide					64
			tall					64
			visible					1
			enabled					1
			allcaps					0
			textAlignment			left
			labelText 				""
			childGroupAlways		SP_TitanLoadout_Always
			childGroupFocused		SP_Level_Hover
			childGroupLocked		SP_Level_Locked
		}

		Playlist_Button
		{
			xpos					0
			ypos					0
			zpos					2
			wide					64
			tall					64
			visible					1
			enabled					1
			style					TitanDecalButton
			allcaps					0
			textAlignment			left
			labelText 				""
            rui						"ui/playlist_button.rpak"
		}

		PvE_Button
		{
			xpos					0
			ypos					0
			zpos					2
			wide					64
			tall					64
			visible					1
			enabled					1
			style					TitanDecalButton
			allcaps					0
			textAlignment			left
			labelText 				""
            rui						"ui/pve_button.rpak"
		}

		GridButton
		{
			xpos					0
			ypos					0
			zpos					2
			wide					64
			tall					64
			visible					1
			enabled					1
			style					TitanDecalButton
			allcaps					0
			textAlignment			left
			labelText 				""
			childGroupAlways		GridButtonAlwaysGroup
			childGroupFocused		GridButtonFocusedGroup
			childGroupSelected		GridButtonSelectedGroup
//			childGroupLocked		GridButtonLockedGroup
			childGroupNew			GridButtonNewGroup
		}

		BurnCardButton
		{
			xpos					0
			ypos					0
			zpos					2
			wide					64
			tall					64
			visible					1
			enabled					1
			style					RuiButton
			allcaps					0
			textAlignment			left
			labelText 				""
			rui						"ui/burn_card_button.rpak"
		}

		BoostStoreButton
		{
			xpos					0
			ypos					0
			zpos					2
			wide					64
			tall					64
			visible					1
			enabled					1
			style					RuiButton
			allcaps					0
			textAlignment			left
			labelText 				""
			rui						"ui/boost_store_button.rpak"
		}

		CamoButton
		{
			xpos					0
			ypos					0
			zpos					2
			wide					64
			tall					64
			visible					1
			enabled					1
			style					RuiButton
			allcaps					0
			textAlignment			left
			labelText 				""
			rui						"ui/camo_button.rpak"
		}

		CustomizeGridButton
		{
			xpos					0
			ypos					0
			zpos					2
			wide					64
			tall					64
			visible					1
			enabled					1
			style					RuiButton
			allcaps					0
			textAlignment			left
			labelText 				""
			rui						"ui/prototype_customize_grid_button.rpak"
		}

		SurvivalInventoryButton
		{
			xpos					0
			ypos					0
			zpos					2
			wide					32
			tall					64
			visible					1
			enabled					1
			style					RuiButton
			allcaps					0
			textAlignment			left
			labelText 				""
			rui						"ui/survival_inventory_button.rpak"
			rightClickEvents		1
		}

		SurvivalInventoryGridButton
		{
			xpos					0
			ypos					0
			zpos					2
			wide					32
			tall					64
			visible					1
			enabled					1
			style					RuiButton
			allcaps					0
			textAlignment			left
			labelText 				""
			rui						"ui/survival_inventory_grid_button_v2.rpak"
			rightClickEvents		1

			cursorVelocityModifier  0.6

			sound_focus             "UI_InGame_Inventory_Hover"
			sound_accept            ""
			sound_deny              ""
		}

		SurvivalInventoryListButton
		{
			xpos					0
			ypos					0
			zpos					2
			wide					320
			tall					48
			visible					1
			enabled					1
			style					RuiButton
			allcaps					0
			textAlignment			left
			labelText 				""
			rui						"ui/survival_inventory_list_button.rpak"
			clipRui					1
			rightClickEvents		1

			cursorVelocityModifier  0.6
		}

		SurvivalUpgradeCounter
		{
		    wide                    512
		    tall                    96
		    visible                 1
		    enabled                 1
		    rui						"ui/survival_upgrade_currency_counter.rpak"
            labelText 				""
		}

		SurvivalUpgradeButton
        {
            wide					512
            tall					96
            visible					1
            enabled					1
            style					RuiButton
            rui						"ui/survival_upgrade_purchase_button.rpak"
            labelText 				""

            cursorVelocityModifier  0.6
        }

		SurvivalEquipmentButton
		{
			wide					84
			tall					84
			visible					1
			enabled					1
			style					RuiButton
            rui						"ui/survival_equipment_button_v2.rpak"
			labelText 				""

			cursorVelocityModifier  0.6
		}

		SurvivalAttachmentButton
		{
			wide					68
			tall					68
			visible					1
			enabled					1
			style					RuiButton
			rui						"ui/survival_inventory_grid_button_v2.rpak"
			rightClickEvents		1

			cursorVelocityModifier  0.6
		}

		SurvivalWeaponButtonWide
		{
			wide					320
			tall					140
			visible					1
			enabled					1
			style					RuiButton
			rui						"ui/survival_equipment_button_wide.rpak"
			rightClickEvents		1

			cursorVelocityModifier  0.6
		}


        PaginationButton
        {
            classname               "PaginationButton MenuButton"
            rui                     "ui/generic_selectable_button.rpak"
            wide					48
            tall					48
            visible					1
        }


		FriendGridButton
		{
			xpos					0
			ypos					0
			zpos					2
			wide					400
			tall					80
			visible					1
			enabled					1
			style					RuiButton
			allcaps					0
			textAlignment			left
			labelText 				""
			rui						"ui/generic_friend_button.rpak"
			rightClickEvents		1
			cursorVelocityModifier  0.7
            //sound_accept            "UI_Menu_InviteFriend_Send" // Buttons are always disabled?
		}

        ToolTip
        {
            classname               "ToolTip"
            zpos                    999
            wide					512
            tall					192
            visible				    0
            rui                     "ui/generic_tooltip.rpak"
            enabled                 0

            proportionalToParent    1
        }

		CallsignIconButton
		{
			xpos					0
			ypos					0
			zpos					2
			wide					32
			tall					64
			visible					1
			enabled					1
			style					RuiButton
			allcaps					0
			textAlignment			left
			labelText 				""
			rui						"ui/callsign_icon_button.rpak"
		}

		CallsignIconStore
		{
			xpos					0
			ypos					0
			zpos					2
			wide					32
			tall					64
			visible					1
			enabled					1
			style					RuiButton
			allcaps					0
			textAlignment			left
			labelText 				""
			rui						"ui/callsign_icon_store.rpak"
		}

		CallsignCardButton
		{
			xpos					0
			ypos					0
			zpos					2
			wide					64
			tall					64
			visible					1
			enabled					1
			style					RuiButton
			allcaps					0
			textAlignment			left
			labelText 				""
			rui						"ui/callsign_card_button.rpak"
		}

		FactionButton
		{
			xpos					0
			ypos					0
			zpos					2
			wide					64
			tall					64
			visible					1
			enabled					1
			style					RuiButton
			allcaps					0
			textAlignment			left
			labelText 				""
			rui						"ui/faction_button.rpak"
		}

		GridPageCircleButton
		{
			xpos					0
			ypos					0
			zpos					2
			wide					30
			tall					30
			visible					1
			enabled					1
			style					GridButton
			allcaps					0
			textAlignment			left
			labelText 				""
			childGroupAlways		GridPageCircleButtonAlways
			childGroupFocused		GridPageCircleButtonFocused
			childGroupSelected		GridPageCircleButtonSelected
		}

		GridPageArrowButtonLeft
		{
			xpos					0
			ypos					0
			zpos					2
			wide					32
			tall					128
			visible					1
			enabled					1
			style					GridButton
			allcaps					0
			textAlignment			left
			labelText 				""
			rui						"ui/arrow_button_left.rpak"
		}

		GridPageArrowButtonRight
		{
			xpos					0
			ypos					0
			zpos					2
			wide					32
			tall					128
			visible					1
			enabled					1
			style					GridButton
			allcaps					0
			textAlignment			left
			labelText 				""
			rui						"ui/arrow_button_right.rpak"
		}

		GridPageArrowButtonUp
		{
			xpos					0
			ypos					0
			zpos					2
			wide					128
			tall					32
			visible					1
			enabled					1
			style					GridButton
			allcaps					0
			textAlignment			left
			labelText 				""
			rui						"ui/arrow_button_up.rpak"
		}

		GridPageArrowButtonDown
		{
			xpos					0
			ypos					0
			zpos					2
			wide					128
			tall					32
			visible					1
			enabled					1
			style					GridButton
			allcaps					0
			textAlignment			left
			labelText 				""
			rui						"ui/arrow_button_down.rpak"
		}

		UserInfo
		{
			classname               UserInfo
			rui                     "ui/userinfo.rpak"
			wide                    394
			tall                    84
			visible                 1
			sound_focus             ""
			sound_accept            ""
		}

        ItemDetails
        {
            wide                    650
			tall					650
            rui						"ui/item_details.rpak"
        }

        NameProperties
        {
            tall 					48
            font					Default_43
            labelText				"ITEM NAME"
            fgcolor_override		"254 184 0 255"
            visible					1
        }

		UnlockReqProperties
		{
			ControlName             Label
	        wide                    650
	        tall                    27
	        visible                 1
	        font                    Default_23
	        wrap                    1
	        fgcolor_override        "255 184 0 255"
	        labelText               ""
	        textAlignment           north-west
		}

		LoadoutButtonLarge
		{
			wide					224
			tall					112
			visible					1
			enabled					1
			style					RuiButton
            rui						"ui/loadout_button_large.rpak"
			labelText 				""
		}

		LoadoutButtonMedium
		{
			wide					96
			tall					96
			visible					1
			enabled					1
			style					RuiButton
            rui						"ui/loadout_button_medium.rpak"
			labelText 				""
		}

		LoadoutButtonSmall
		{
			wide					72
			tall					72
			visible					1
			enabled					1
			style					RuiButton
			rui						"ui/loadout_button_small.rpak"
			labelText 				""
		}

		SurvivalAbilityButton
		{
			wide					224
			tall					112
			visible					1
			enabled					1
			style					RuiButton
            rui						"ui/survival_ability_button.rpak"
			labelText 				""
		}

		LobbyCharacterButton
		{
            classname               CharacterButtonClass
			wide					194
			tall					126
			visible					0
			enabled					1
            rui						"ui/lobby_character_button.rpak"
			labelText				""
			style					RuiButton
			polyShape               "0.375 0.0 1.0 0.0 0.625 1.0 0.0 1.0"
			rightClickEvents		1
			middleClickEvents       1
			sound_focus             "UI_Menu_Focus"
			sound_accept			""
            cursorVelocityModifier  0.7

            pin_corner_to_sibling	TOP_LEFT
            pin_to_sibling_corner	TOP_LEFT
		}

		MatchCharacterButton
		{
            zpos					10
			wide					194
			tall					126
			visible					0
			enabled					1
            rui						"ui/character_select_class_button_new.rpak"
			labelText				""
			style					RuiButton
			polyShape               "0.375 0.0 1.0 0.0 0.625 1.0 0.0 1.0"
			rightClickEvents		1
			sound_focus             "UI_Menu_Focus_LegendSelectScreen"
			sound_accept			""
            cursorVelocityModifier  0.7

            pin_corner_to_sibling	TOP_LEFT
            pin_to_sibling_corner	TOP_LEFT
		}

		StoreCharacterButton
		{
			wide					280//194
			tall					183//126
			visible					1
			enabled					1
            rui						"ui/store_character_button.rpak"
			labelText				""
			style					RuiButton
			polyShape               "0.375 0.0 1.0 0.0 0.625 1.0 0.0 1.0"
			rightClickEvents		1
		}

		BonusCharacterButton
		{
			wide					242
			tall					158
			visible					1
			enabled					1
//            rui						"ui/lobby_character_button.rpak"
            rui                     "ui/bonus_character_button.rpak"
			labelText				""
			style					RuiButton
			polyShape               "0.375 0.0 1.0 0.0 0.625 1.0 0.0 1.0"
			rightClickEvents		1
			middleClickEvents       1
			sound_focus             "UI_Menu_Focus"
			sound_accept			""
		}

		WeaponCategoryButton
		{
            wide					572
            tall					275
			visible					1
			enabled					1
            rui						"ui/weapon_category_button.rpak"
			labelText				""
			style					RuiButton
			polyShape               "0.2725 0.0 1.0 0.0 0.7275 1.0 0.0 1.0"
			sound_focus             "UI_Menu_Focus"
			sound_accept            "UI_Menu_WeaponClass_Select"
			cursorVelocityModifier  0.7
		}

		MiscCustomizeButton
        {
            wide					600
            tall					120
            visible					1
            enabled					1
            rui						"ui/misc_customize_button.rpak"
            labelText				""
            style					RuiButton
            //polyShape               "0.2725 0.0 1.0 0.0 0.7275 1.0 0.0 1.0"
            sound_focus             "UI_Menu_Focus"
            sound_accept            "UI_Menu_WeaponClass_Select"
            cursorVelocityModifier  0.7
        }

		UltimateButton
		{
			wide					112
			tall					112
			visible					1
			enabled					1
			style					RuiButton
            rui						"ui/suit_button.rpak"
			labelText 				""
		}

		TacticalButton
		{
			wide					224
			tall					112
			visible					1
			enabled					1
			style					RuiButton
            rui						"ui/suit_button.rpak"
			labelText 				""
		}

		Test2Button
		{
			wide					96
			tall					96
			visible					1
			enabled					0
			style					Test2Button
			labelText 				""
			childGroupAlways		Test2ButtonAlwaysGroup
			childGroupFocused		Test2ButtonFocusedGroup
			childGroupNew			Test2ButtonNewGroup
		}

		CoopStoreButton
		{
			xpos					-4
			ypos					0
			zpos					110
			wide					56
			tall					56
			visible					1
			enabled					1
			style					CoopStoreButton
			allcaps					0
			textAlignment			center
			labelText 				""
			childGroupAlways		CoopStoreButtonAlwaysGroup
			childGroupFocused		CoopStoreButtonFocusedGroup
			childGroupSelected		CoopStoreButtonSelectedGroup
			childGroupLocked		CoopStoreButtonLockedGroup
			childGroupNew			CoopStoreButtonNewGroup
		}

		KeyBindingsButton
		{
			zpos					30
			auto_wide_tocontents 	1
			tall					36
			labelText				"DEFAULT"
			font					Default_28
			textinsetx				22
			use_proportional_insets	1
			enabled					1
			visible					1
			style					KeyBindingsButton
			childGroupFocused		KeyBindingsButtonFocusGroup
			activeInputExclusivePaint	keyboard
		}

		MenuTopBar
		{
			xpos					0
			ypos					130
			wide					%100
			tall					8
			image 					"ui/menu/common/menu_title_bar"
			visible					1
			scaleImage				1
		}

		MenuVignette
		{
			xpos					0
			ypos					0
			wide					%100
			tall					%100
			image 					"rui/menu/common/menu_vignette"
			visible					1
			scaleImage				1
			disableMouseFocus		1
		}

		MenuTitle
		{
			xpos					106 // include n pixels for the combo button inset
			ypos					54
			auto_wide_tocontents 	1
			tall					97
			visible					1
			font					DefaultBold_65
			allcaps					1
			fgcolor_override		"255 255 255 255"
			classname				MenuTitle
		}

		MenuScreenFrame
		{
			disableMouseFocus		1
		}

		FooterButtons
		{
			xpos					0
			ypos					r90 //5% safe area plus this things height of 36
			zpos					20
			wide					f0
			tall					36
			visible					1
			controlSettingsFile		"resource/ui/menus/panels/footer_buttons.res"
		}

        DialogFooterButtons
        {
            xpos					-211
            ypos                    -32
            wide					f0
            tall					60
            visible					1
            controlSettingsFile		"resource/ui/menus/panels/dialog_footer_buttons.res"
        }

        PromoFooterButtons
        {
            xpos					-211
            ypos                    -32
            wide					f0
            tall					60
            visible					1
            controlSettingsFile		"resource/ui/menus/panels/promo_footer_buttons.res"
        }

        DialogFooterButtonsR2
        {
            xpos					-368
            ypos                    -38
            wide					f0
            tall					56
            visible					1
            controlSettingsFile		"resource/ui/menus/panels/dialog_footer_buttons_r2.res"
        }

		R2_ContentDescriptionTitle
		{
			xpos					0
			ypos					65
			zpos					3 // Needed or clicking on the background can hide this
			auto_wide_tocontents 	1
			tall					60
			visible					1
			font					DefaultBold_44_DropShadow
			allcaps					1
			fgcolor_override		"245 245 245 255"
		}

		R2_ContentDescription
		{
			visible					1
			font					Default_27
			allcaps					0
			fgcolor_override		"245 245 245 255"
		}

		R2_ContentBackground
		{
			scaleImage				1
			image					"vgui/HUD/white"
			drawColor				"0 0 0 150"
		}

		AdvControlsLabel
		{
			font					Default_27
			allcaps					0
			auto_wide_tocontents 	1
			fgcolor_override		"244 213 166 255"
		}

		SubheaderBackground
		{
			wide 					660
			tall					45
			visible					1
			image 					"ui/menu/common/menu_header_bar"
			visible					1
			scaleImage				1
		}
		SubheaderBackgroundWide
		{
            wide 					%60
			tall					45
			visible					1
			image 					"ui/menu/common/menu_header_bar_wide"
			visible					1
			scaleImage				1
		}
		SubheaderText
		{
			zpos					3 // Needed or clicking on the background can hide this
			auto_wide_tocontents 	1
			tall					40
			visible					1
			font					DefaultBoldFont
			fontHeight 				30
			allcaps					1
			fgcolor_override		"245 245 245 255"
		}

		LeftFooterSizer // TODO: Remove when old dialogs are gone
		{
			classname				LeftFooterSizerClass
			zpos					3
			auto_wide_tocontents 	1
			tall 					36
			labelText				"DEFAULT"
			font					DefaultRegularFont
			fontHeight 				32
			textinsetx				18
			use_proportional_insets	1
			enabled					1
			visible					1
			ruiVisible				0
		}

		LeftRuiFooterButton
		{
		    classname				LeftRuiFooterButtonClass
			style					RuiFooterButton
            rui						"ui/footer_button.rpak"
			zpos					3
			tall					36
			font                    Default_28
			labelText				"DEFAULT"
			enabled					1
			visible					1
			auto_wide_tocontents 	1
            behave_as_label         1
            ruiDefaultHeight        36
            fontHeight              32
		}

		RightRuiFooterButton
		{
		    classname				RightRuiFooterButtonClass
			style					RuiFooterButton
            rui						"ui/footer_button.rpak"
			zpos					3
			tall					36
			font                    Default_28
			labelText				"DEFAULT"
			enabled					1
			visible					1
			auto_wide_tocontents 	1
            behave_as_label         1
            ruiDefaultHeight        36
            fontHeight              32
		}

		MouseFooterButton
		{
			classname				MouseFooterButtonClass
			zpos					4
			auto_wide_tocontents 	1
			tall 					36
			labelText				"DEFAULT"
			font					Default_28
			textinsetx				22
			use_proportional_insets	1
			enabled					1
			visible					1
			IgnoreButtonA			1
			style					PCFooterButton
			childGroupFocused		PCFooterButtonFocusGroup
			activeInputExclusivePaint	keyboard
		}

		SubitemSelectItemName
		{
			wide 					697
			tall 					45
			zpos					7
			visible					1
			font					Default_23
			allcaps					1
			fgcolor_override		"204 234 255 255"
		}

		AbilityDesc
		{
			wide 					360
			tall 					64
			zpos					4 // Needed or clicking on the background can hide this
			visible					1
			textAlignment			north-west
			font					Default_26
			wrap 					1
			fgcolor_override		"64 64 64 255"
		}

		ButtonTooltip
		{
			classname				ButtonTooltip
			xpos					0
			ypos					0
			zpos					500
			wide					450
			tall					67
			visible					0
			controlSettingsFile		"resource/UI/menus/button_locked_tooltip.res"
		}

		LobbyFriendlyBackground
		{
			wide					476
			tall					35
			image 					"ui/menu/lobby/friendly_player"
			visible					1
			scaleImage				1
		}

		LobbyEnemyBackground
		{
			wide					476
			tall					35
			image 					"ui/menu/lobby/enemy_player"
			visible					1
			scaleImage				1
		}

		ChatroomPlayerBackground
		{
			wide					259
			tall					28
			image 					"ui/menu/lobby/chatroom_player"
			visible					1
			scaleImage				1
		}

		ChatroomPlayerFocus
		{
			zpos 					5
			wide					259
			tall					28
			visible					1
			image					"ui/menu/lobby/chatroom_hover"
			scaleImage				1
		}

		ChatroomPlayerMic
		{
			zpos 					4
			wide					28
			tall					28
			visible					1
			image					"ui/icon_mic_active"
			scaleImage				1
		}

		CommunityBackground
		{
			wide					1163
			tall					30
			image 					"ui/menu/lobby/chatroom_player"
			visible					1
			scaleImage				1
		}

		CommunityFocus
		{
			zpos 					5
			wide					1163
			tall					28
			image					"ui/menu/lobby/chatroom_hover"
			visible					1
			scaleImage				1
		}

		LobbyNeutralBackground
		{
			wide					476
			tall					35
			image 					"ui/menu/lobby/neutral_player"
			visible					1
			scaleImage				1
		}

		LobbyColumnLine
		{
			wide 					2
			tall					45
			visible					1
			labelText				""
			bgcolor_override 		"18 22 26 255"
			//bgcolor_override 		"255 0 255 127"
		}

		LobbyPlayerMic
		{
			zpos 					4
			wide					47
			tall					35
			visible					1
			image					"ui/icon_mic_active"
			scaleImage				1
		}

		LobbyPlayerPartyLeader
		{
			zpos 					4
			wide					4
			tall					35
			visible					0
			image					"vgui/hud/white"
			drawColor				"179 255 204 255"
			scaleImage				1
		}

		LobbyPlayerGenImage
		{
			zpos 					3
			wide				 	0
			tall				 	45
			visible					1
			image					"ui/menu/generation_icons/generation_1"
			scaleImage				1
			fillcolor				"0 0 0 255"
		}

		LobbyPlayerGenOverlayImage
		{
			zpos 					4
			wide				 	0
			tall				 	45
			visible					1
			image					""
			scaleImage				1
		}

		LobbyPlayerGenLabel
		{
			zpos 					5
			wide				 	0
			tall				 	45
			visible					1
			font					Default_31_ShadowGlow
			labelText				""
			textAlignment			"center"
			fgcolor_override 		"230 230 230 255"
		}

		LobbyPlayerLevel
		{
			zpos 					4
			wide				 	0
			tall				 	45
			visible					1
			font					Default_27
			labelText				"99"
			textAlignment			"center"
			bgcolor_override		"0 0 0 255"
		}

		LobbyPlayerFocus
		{
			zpos 					5
			wide					476
			tall					35
			visible					1
			image					"ui/menu/lobby/player_hover"
			scaleImage				1
		}

        Logo
        {
            classname               LogoRui
            xpos					-48
            ypos					0
            zpos					10
            wide					123
            tall					143
            visible					1
            proportionalToParent    1
            rui 					"ui/tab_logo.rpak"
        }

		MenuArrowButtonUp
		{
			zpos					3 // Needed or clicking on the background can hide this
			wide					90
			visible					1
			enabled					1
			style					MenuArrowButtonStyle
			labelText				""
			allcaps					1
			childGroupNormal		MenuArrowChildGroupUpNormal
			childGroupFocused		MenuArrowChildGroupUpFocused
		}

		MenuArrowButtonDown
		{
			zpos					3 // Needed or clicking on the background can hide this
			wide					90
			visible					1
			enabled					1
			style					MenuArrowButtonStyle
			labelText				""
			allcaps					1
			childGroupNormal		MenuArrowChildGroupDownNormal
			childGroupFocused		MenuArrowChildGroupDownFocused
		}

		StatName
		{
			xpos 					0
			ypos 					0
			zpos					200
			tall					14
			wide 					110
			visible					1
			font					Default_21
			textAlignment			west
			allcaps					1
			labelText				"[stat name]"
			fgcolor_override		"204 234 255 255"
			//bgcolor_override		"255 0 0 255"
		}

		StatValue
		{
			xpos 					0
			ypos					0
			zpos					200
			wide					70
			tall					14
			visible					1
			font					Default_21
			textAlignment			east
			labelText				"[stat value]"
			allcaps					1
			fgcolor_override		"230 161 23 255"
			//bgcolor_override		"0 255 0 255"
		}

		OptionMenuTooltip
		{
			font					Default_27_ShadowGlow
			allCaps					0
			tall					562
			wide 					719
			xpos					-854
			ypos					31
			zpos					0
			wrap					1
			labelText				""
			textAlignment			"north-west"
			fgcolor_override		"192 192 192 255"
			bgcolor_override		"0 0 0 60"
			visible					1
			enabled					1
		}

		MenuTooltipLarge
		{
			rui						"ui/control_options_description.rpak"
			tall					370
			wide 					844

			xpos					975
			ypos					193
		}

		ScoreboardTeamLogo
		{
			zpos				1012
			wide				72
			tall				72
			visible				1
			scaleImage			1
			//border				ScoreboardTeamLogoBorder
			//drawColor			"255 255 255 255"
		}

        PostGameScoreboardRow
        {
            classname               PostGameScoreboardRowClass
            wide				    852
            tall				    35
            visible				    1
            enabled					1
            style					RuiButton
            rui					    "ui/postgame_scoreboard_row.rpak"
            labelText 				""
        }

        MatchmakingStatus
        {
            classname		        MatchmakingStatusRui
            wide                    560
            tall                    82
            visible			        1
            rui                     "ui/matchmaking_status.rpak"
        }

		DeathScreenRecapBlock
		{
			wide					540
			tall					55
			rui                     "ui/death_recap_damage_block.rpak"
			xpos                    0
			ypos                    3
			zpos                    0
			visible                 1
			enabled                 1
			cursorVelocityModifier  0.6
			pin_corner_to_sibling   BOTTOM
			pin_to_sibling_corner   TOP
		}
	}

	ButtonChildGroups
	{
		MenuArrowChildGroupUpNormal
		{
			Arrow
			{
				ControlName				ImagePanel
				wide					47
				tall					47
				xpos					22
				ypos					40
				zpos					10
				visible					1
				image					"ui/menu/common/menu_arrow_up_off"
				scaleImage				1
			}
		}

		MenuArrowChildGroupUpFocused
		{
			Arrow
			{
				ControlName				ImagePanel
				wide					47
				tall					47
				xpos					22
				ypos					40
				zpos					10
				visible					1
				image					"ui/menu/common/menu_arrow_up_on"
				scaleImage				1
			}
		}

		MenuArrowChildGroupDownNormal
		{
			Arrow
			{
				ControlName				ImagePanel
				wide					47
				tall					47
				xpos					22
				ypos					40
				zpos					10
				visible					1
				image					"ui/menu/common/menu_arrow_down_off"
				scaleImage				1
			}
		}

		MenuArrowChildGroupDownFocused
		{
			Arrow
			{
				ControlName				ImagePanel
				wide					47
				tall					47
				xpos					22
				ypos					40
				zpos					10
				visible					1
				image					"ui/menu/common/menu_arrow_down_on"
				scaleImage				1
			}
		}

		DefaultButtonNormalGroup
		{
			FocusFade
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					636
				tall					45
				visible					1
				image					"ui/menu/common/menu_hover_left_default_anim"
				scaleImage				1
				drawColor				"255 255 255 0"
			}
		}
		DefaultButtonFocusGroup
		{
			Focus
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					636
				tall					45
				visible					1
				image					"ui/menu/common/menu_hover_left_default"
				scaleImage				1
			}
		}
		DefaultButtonLockedGroup
		{
			LockImage
			{
				ControlName				ImagePanel
				xpos					12
				ypos					0
				wide					45
				tall					45
				visible					1
				image					"ui/menu/common/locked_icon"
				scaleImage				1
			}
		}
		DefaultButtonNewGroup
		{
			NewIcon
			{
				ControlName				ImagePanel
				xpos					12
				ypos					0
				wide					45
				tall					45
				visible					1
				image					"ui/menu/common/newitemicon"
				scaleImage				1
			}
		}

		LoadoutButtonNormalGroup
		{
			FocusFade
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					540
				tall					40
				visible					1
				image					"ui/menu/common/menu_hover_left_default_anim_new"
				scaleImage				1
				drawColor				"255 255 255 0"
			}
		}
		LoadoutButtonFocusGroup
		{
			Focus
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					540
				tall					40
				visible					1
				image					"ui/menu/common/menu_hover_left_default_new"
				scaleImage				1
			}
		}

		CompactButtonNormalGroup
		{
			FocusFade
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					636
				tall					40
				visible					1
				image					"ui/menu/common/menu_hover_left_default_anim"
				scaleImage				1
				drawColor				"255 255 255 0"
			}
		}
		CompactButtonFocusGroup
		{
			Focus
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					636
				tall					40
				visible					1
				image					"ui/menu/common/menu_hover_left_default"
				scaleImage				1
			}
		}
		CompactButtonLockedGroup
		{
			TestImage1
			{
				ControlName				ImagePanel
				xpos					27
				ypos					0
				wide					45
				tall					45
				visible					1
				image					"ui/menu/common/locked_icon"
				scaleImage				1
			}
		}
		CompactButtonNewGroup
		{
			NewIcon
			{
				ControlName				ImagePanel
				xpos					27
				ypos					0
				wide					45
				tall					45
				visible					1
				image					"ui/menu/common/newitemicon"
				scaleImage				1
			}
		}
		CompactButtonSelectedGroup
		{
			TestImage1
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					636
				tall					40
				visible					1
				image					"ui/menu/common/menu_hover_left_default"
				scaleImage				1
				drawColor				"255 255 255 40"
			}
		}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		SmallButtonNormalGroup
		{
			FocusFade
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					540
				tall					40
				visible					1
				image					"ui/menu/common/menu_hover_left_default_anim_new"
				scaleImage				1
				drawColor				"255 255 255 0"
			}
		}
		SmallButtonFocusGroup
		{
			Focus
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					540
				tall					40
				visible					1
				image					"ui/menu/common/menu_hover_left_default_new"
				scaleImage				1
			}
		}
		SmallButtonSelectedGroup
		{
			TestImage1
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					540
				tall					40
				visible					1
				image					"ui/menu/common/menu_hover_left_default_new"
				scaleImage				1
				drawColor				"255 255 255 40"
			}
		}
        SmallButtonLockedGroup
        {
            LockImage
            {
                ControlName				ImagePanel
                xpos					-44
                ypos					0
                wide					48
                tall					48
                visible					1
                image					"ui/menu/common/locked_icon"
                scaleImage				1
            }
        }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		LargeButtonNormalGroup
		{
			FocusFade
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
	    		wide					540
    			tall					56
				visible					1
				image					"ui/menu/common/menu_hover_left_default_anim_new"
				scaleImage				1
				drawColor				"255 255 255 0"
			}
		}
		LargeButtonFocusGroup
		{
			FocusImage
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
	    		wide					540
    			tall					56
				visible					1
				image					"ui/menu/common/menu_hover_left_default_new"
				scaleImage				1
			}
		}

		ComboButtonLargeAlways
		{
			RuiLabel
			{
				ControlName				RuiPanel
                rui                     "ui/combo_button_large.rpak"
				classname 				"ComboButtonAlways"
				ypos                    0
	    		wide					512
    			tall                    100
    			zpos                    -100
    			enabled                 0
				visible					1
			}
		}

		LargeButtonLockedGroup
		{
			TestImage1
			{
				ControlName				ImagePanel
				xpos					27
				ypos					4
				wide					45
				tall					45
				visible					1
				image					"ui/menu/common/locked_icon"
				scaleImage				1
			}
		}
		LargeButtonNewGroup
		{
			NewIcon
			{
				ControlName				ImagePanel
				xpos					27
				ypos					4
				wide					45
				tall					45
				visible					1
				image					"ui/menu/common/newitemicon"
				scaleImage				1
			}
		}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		DialogButtonNormalGroup
		{
			FocusFade
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					780
				tall					45
				visible					1
				image					"ui/menu/common/menu_hover_left_default_anim"
				scaleImage				1
				drawColor				"255 255 255 0"
			}
		}
		DialogButtonFocusGroup
		{
			Focus
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					780
				tall					45
				visible					1
				image					"ui/menu/common/menu_hover_center_controls"
				scaleImage				1
			}
		}

		CenterButtonNormalGroup
		{
			FocusFade
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					450
				tall					45
				visible					1
				image					"ui/menu/common/menu_hover_left_default_anim"
				scaleImage				1
				drawColor				"255 255 255 0"
			}
		}
		CenterButtonFocusGroup
		{
			Focus
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					450
				tall					45
				visible					1
				image					"ui/menu/common/menu_hover_center_controls"
				scaleImage				1
			}
		}

		// TODO: %100 should size automatically based on parent
		PCFooterButtonFocusGroup
		{
			Focus
			{
				ControlName				Label
				wide					674 //%100
				tall					36 //%100
				labelText				""
				visible					1
		        bgcolor_override		"255 255 255 127"
        		paintbackground 		1
			}
		}

		KeyBindingsButtonFocusGroup
		{
			Focus
			{
				ControlName				Label
				wide					180
				tall					36
				labelText				""
				visible					1
		        bgcolor_override		"255 255 255 127"
        		paintbackground 		1
			}
		}

		LobbyPlayerNormalGroup
		{
			FocusFade
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					450
				tall					45
				visible					1
				image					"ui/menu/common/menu_hover_left_default_anim"
				scaleImage				1
				drawColor				"255 255 255 0"
			}
		}

		LobbyFriendlyAlwaysGroup
		{
			ImgBackground
			{
				ControlName				ImagePanel
				InheritProperties		LobbyFriendlyBackground
			}
			ImgBackgroundNeutral
			{
				ControlName				ImagePanel
				InheritProperties		LobbyNeutralBackground
			}
			ImgMic
			{
				ControlName				ImagePanel
				InheritProperties		LobbyPlayerMic
				pin_to_sibling			ImgBackground
				pin_corner_to_sibling	TOP_LEFT
				pin_to_sibling_corner	TOP_LEFT
			}
			ColumnLineMic
			{
				ControlName				Label
				InheritProperties		LobbyColumnLine
				pin_to_sibling			ImgMic
				pin_corner_to_sibling	TOP_LEFT
				pin_to_sibling_corner	TOP_RIGHT
			}
			ImgGen
			{
				ControlName				ImagePanel
				InheritProperties		LobbyPlayerGenImage
				pin_to_sibling			ColumnLineMic
				pin_corner_to_sibling	TOP_LEFT
				pin_to_sibling_corner	TOP_RIGHT
			}
			ImgGenOverlay
			{
				ControlName				ImagePanel
				InheritProperties		LobbyPlayerGenOverlayImage
				pin_to_sibling			ImgGen
				pin_corner_to_sibling	TOP_LEFT
				pin_to_sibling_corner	TOP_LEFT
			}
			LblGen
			{
				ControlName				Label
				InheritProperties		LobbyPlayerGenLabel
				pin_to_sibling			ImgGen
				pin_corner_to_sibling	TOP_LEFT
				pin_to_sibling_corner	TOP_LEFT
			}
			LblLevel
			{
				ControlName				Label
				InheritProperties		LobbyPlayerLevel
				pin_to_sibling			ImgGen
				pin_corner_to_sibling	TOP_LEFT
				pin_to_sibling_corner	TOP_RIGHT
			}
			CoopIcon
			{
				ControlName				ImagePanel
				InheritProperties		LobbyPlayerMic
				pin_to_sibling			ImgBackground
				pin_corner_to_sibling	TOP_RIGHT
				pin_to_sibling_corner	TOP_RIGHT
				visible					0
				enabled					0
			}
			ColumnLineLevel
			{
				ControlName				Label
				InheritProperties		LobbyColumnLine
				pin_to_sibling			LblLevel
				pin_corner_to_sibling	TOP_LEFT
				pin_to_sibling_corner	TOP_RIGHT
			}
			ImgPartyLeader
			{
				ControlName				ImagePanel
				InheritProperties		LobbyPlayerPartyLeader
				pin_to_sibling			ImgBackground
				pin_corner_to_sibling	TOP_LEFT
				pin_to_sibling_corner	TOP_LEFT
			}
		}

		LobbyFriendlyFocusGroup
		{
			ImgFocused
			{
				ControlName				ImagePanel
				InheritProperties		LobbyPlayerFocus
			}
		}

		LobbyEnemyAlwaysGroup
		{
			ImgBackground
			{
				ControlName				ImagePanel
				InheritProperties		LobbyEnemyBackground
			}
			ImgBackgroundNeutral
			{
				ControlName				ImagePanel
				InheritProperties		LobbyNeutralBackground
			}
			ImgMic
			{
				ControlName				ImagePanel
				InheritProperties		LobbyPlayerMic
				pin_to_sibling			ImgBackground
				pin_corner_to_sibling	TOP_LEFT
				pin_to_sibling_corner	TOP_LEFT
			}
			ColumnLineMic
			{
				ControlName				Label
				InheritProperties		LobbyColumnLine
				pin_to_sibling			ImgMic
				pin_corner_to_sibling	TOP_LEFT
				pin_to_sibling_corner	TOP_RIGHT
			}
			ImgGen
			{
				ControlName				ImagePanel
				InheritProperties		LobbyPlayerGenImage
				pin_to_sibling			ColumnLineMic
				pin_corner_to_sibling	TOP_LEFT
				pin_to_sibling_corner	TOP_RIGHT
			}
			ImgGenOverlay
			{
				ControlName				ImagePanel
				InheritProperties		LobbyPlayerGenOverlayImage
				pin_to_sibling			ImgGen
				pin_corner_to_sibling	TOP_LEFT
				pin_to_sibling_corner	TOP_LEFT
			}
			LblGen
			{
				ControlName				Label
				InheritProperties		LobbyPlayerGenLabel
				pin_to_sibling			ImgGen
				pin_corner_to_sibling	TOP_LEFT
				pin_to_sibling_corner	TOP_LEFT
			}
			LblLevel
			{
				ControlName				Label
				InheritProperties		LobbyPlayerLevel
				pin_to_sibling			ImgGen
				pin_corner_to_sibling	TOP_LEFT
				pin_to_sibling_corner	TOP_RIGHT
			}
			ColumnLineLevel
			{
				ControlName				Label
				InheritProperties		LobbyColumnLine
				pin_to_sibling			LblLevel
				pin_corner_to_sibling	TOP_LEFT
				pin_to_sibling_corner	TOP_RIGHT
			}
			ImgPartyLeader
			{
				ControlName				ImagePanel
				InheritProperties		LobbyPlayerPartyLeader
				pin_to_sibling			ImgBackground
				pin_corner_to_sibling	TOP_LEFT
				pin_to_sibling_corner	TOP_LEFT
			}
		}

		LobbyEnemyFocusGroup
		{
			ImgFocused
			{
				ControlName				ImagePanel
				InheritProperties		LobbyPlayerFocus
			}
		}

		ChatroomNormalGroup
		{
			FocusFade
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					450
				tall					27
				visible					1
				image					"ui/menu/common/menu_hover_left_default_anim"
				scaleImage				1
				drawColor				"255 255 255 0"
			}
		}

		ChatroomAlwaysGroup
		{
			ImgBackground
			{
				ControlName				ImagePanel
				InheritProperties		ChatroomPlayerBackground
			}
			ImgMic
			{
				ControlName				ImagePanel
				InheritProperties		ChatroomPlayerMic
				pin_to_sibling			ImgBackground
				pin_corner_to_sibling	TOP_LEFT
				pin_to_sibling_corner	TOP_LEFT
			}
			ColumnLineMic
			{
				ControlName				Label
				InheritProperties		LobbyColumnLine
				pin_to_sibling			ImgMic
				pin_corner_to_sibling	TOP_LEFT
				pin_to_sibling_corner	TOP_RIGHT
			}
		}

		ChatroomFocusGroup
		{
			ImgFocused
			{
				ControlName				ImagePanel
				InheritProperties		ChatroomPlayerFocus
			}
		}

		CommunityNormalGroup
		{
			FocusFade
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					1163
				tall					27
				visible					1
				image					"ui/menu/common/menu_hover_left_default_anim"
				scaleImage				1
				drawColor				"255 255 255 0"
			}
		}

		ChoiceButtonAlways
		{
            FULL
            {
                ControlName         RuiPanel
                InheritProperties   FullSizer
                zpos                -1
            }

            RightButton
            {
                ControlName				RuiButton
                rui						"ui/settings_choice_button.rpak"
                ruiArgs
                {
                    isRightOption       1
                }
                wide					178
                tall					60
                visible					1
                enabled					1
                style					DefaultButton
                zpos                    4

                sound_accept			""

                command                 "DialogListSelect1"

                pin_corner_to_sibling	RIGHT
                pin_to_sibling			FULL
                pin_to_sibling_corner	RIGHT
            }

            LeftButton
            {
                ControlName				RuiButton
                rui						"ui/settings_choice_button.rpak"
                xpos                    4
                wide					178
                tall					60
                visible					1
                enabled					1
                style					DefaultButton
                zpos                    4

                sound_accept			""

                command                 "DialogListSelect0"

                pin_corner_to_sibling	TOP_RIGHT
                pin_to_sibling			RightButton
                pin_to_sibling_corner	TOP_LEFT
            }

            ValueButton
            {
                ControlName				RuiPanel
                rui						"ui/settings_multichoice_value.rpak"
                wide					0
                tall					0
                visible					0
                enabled					1
                style					DefaultButton
                zpos                    4

                pin_corner_to_sibling	TOP_RIGHT
                pin_to_sibling			LeftButton
                pin_to_sibling_corner	TOP_LEFT
            }
		}

		MultiChoiceButtonAlways
		{
            FULL
            {
                ControlName         RuiPanel
                InheritProperties   FullSizer
                zpos                -1
            }

            RightButton
            {
                ControlName				RuiButton
                rui						"ui/settings_change_button.rpak"
                ruiArgs
                {
                    isRightOption       1
                }
                wide					60
                tall					60
                visible					1
                enabled					1
                style					DefaultButton
                zpos                    4

                sound_accept			""

                command                 "DialogListNext"

                pin_corner_to_sibling	RIGHT
                pin_to_sibling			FULL
                pin_to_sibling_corner	RIGHT

                cursorVelocityModifier  0.7
            }

            LeftButton
            {
                ControlName				RuiButton
                rui						"ui/settings_change_button.rpak"
                wide					60
                tall					60
                visible					1
                enabled					1
                style					DefaultButton
                zpos                    4
                xpos                    4

                sound_accept			""

                command                 "DialogListPrev"

                pin_corner_to_sibling	TOP_RIGHT
                pin_to_sibling			ValueButton
                pin_to_sibling_corner	TOP_LEFT

                cursorVelocityModifier  0.7
            }

            ValueButton
            {
                ControlName				RuiPanel
                rui						"ui/settings_multichoice_value.rpak"
                xpos                    4
                wide					232
                tall					60
                visible					1
                enabled					1
                style					DefaultButton
                zpos                    4

                pin_corner_to_sibling	TOP_RIGHT
                pin_to_sibling			RightButton
                pin_to_sibling_corner	TOP_LEFT
            }
		}

		SliderControlAlways
		{
            BtnDropButton
            {
                ControlName				RuiButton
                InheritProperties		SwitchButton
                clip 					0
                autoResize				1
                pinCorner				0
                visible					1
                enabled					1
                style					SliderButton
                command					""

                cursorVelocityModifier  0.7
            }

            LblSliderText
            {
                ControlName				Label
                fieldName				LblSliderText
                wide					450
                tall					60
                autoResize				0
                pinCorner				0
                visible					1
                enabled					1
                tabPosition				0
                labelText				""
            }

            PrgValue
            {
                ControlName				RuiPanel
                fieldName				PrgValue
                zpos					5
                wide					296
                tall					60
                visible					1
                enabled					1
                tabPosition				0
                rui                     "ui/settings_slider.rpak"
            }

            PnlDefaultMark
            {
                ControlName				RuiPanel
                ypos 					0
                zpos					10
                wide					12
                tall					60
                rui                     "ui/settings_slider_default.rpak"
                ruiArgs
                {
                    basicImageAlpha     0.15
                }
                visible					1
                scaleImage				1
                pin_corner_to_sibling	CENTER
                pin_to_sibling_corner	CENTER
            }
		}

		CommunityAlwaysGroup
		{
			ImgBackground
			{
				ControlName				ImagePanel
				InheritProperties		CommunityBackground
			}
		}

		CommunityFocusGroup
		{
			ImgFocused
			{
				ControlName				ImagePanel
				InheritProperties		CommunityFocus
			}
		}

		MapButtonAlwaysGroup
		{
			MapImage
			{
				ControlName				ImagePanel
				classname 				MapImageClass
				wide					158
				tall					89
				visible					1
				scaleImage				1
			}
		}
		MapButtonNormalGroup
		{
			FocusFade
			{
				ControlName				ImagePanel
				zpos 					1
				wide					158
				tall					89
				visible					1
				scaleImage				1
				image					"ui/menu/campaign_menu/map_button_hover"
				drawColor				"255 255 255 0"
			}
		}
		MapButtonFocusGroup
		{
			MapNameBG
			{
				ControlName				ImagePanel
				xpos					1
				ypos					1
				zpos 					2
				wide					156
				tall					32
				visible					0
				scaleImage				1
				image					"ui/menu/campaign_menu/map_name_background"
			}

			MapName
			{
				ControlName				Label
				ypos 					7
				zpos					3
				wide					158
				tall					89
				visible					0
				labelText				"Name"
				font 					Default_9
				textAlignment			north
				allcaps					1
				fgcolor_override		"204 234 255 255"
			}

			Focus
			{
				ControlName				ImagePanel
				zpos 					1
				wide					158
				tall					89
				visible					1
				scaleImage				1
				image					"ui/menu/campaign_menu/map_button_hover"
			}
		}
		MapButtonLockedGroup
		{
			DarkenOverlay
			{
				ControlName				ImagePanel
				wide					158
				tall					89
				visible					1
				scaleImage				1
				image					"ui/menu/campaign_menu/map_button_darken_overlay"
			}
		}

		SubmenuButtonNormalGroup
		{
			FocusFade
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					540
				tall					45
				visible					1
				image					"ui/menu/common/menu_hover_left_default_anim"
				scaleImage				1
				drawColor				"255 255 255 0"
			}
		}
		SubmenuButtonFocusGroup
		{
			Focus
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					540
				tall					45
				visible					1
				image					"ui/menu/common/menu_hover_left_default"
				scaleImage				1
			}
		}
		SubmenuButtonLockedGroup
		{
			TestImage1
			{
				ControlName				ImagePanel
				xpos					27
				ypos					0
				wide					45
				tall					45
				visible					1
				image					"ui/menu/common/locked_icon"
				scaleImage				1
			}
		}
		SubmenuButtonNewGroup
		{
			NewIcon
			{
				ControlName				ImagePanel
				xpos					27
				ypos					0
				wide					45
				tall					45
				visible					1
				image					"ui/menu/common/newitemicon"
				scaleImage				1
			}
		}
		SubmenuButtonSelectedGroup
		{
			TestImage1
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					540
				tall					45
				visible					1
				image					"ui/menu/common/menu_hover_left_default"
				scaleImage				1
				drawColor				"255 255 255 40"
			}
		}

		GridPageCircleButtonAlways
		{
			ImageNormal
			{
				ControlName				ImagePanel
				wide					30
				tall					30
				xpos 					0
				ypos					0
				zpos					110
				image 					"vgui/combat_ring"
				visible					1
				scaleImage				1
			}
		}

		GridPageCircleButtonFocused
		{
			ImageFocused
			{
				ControlName				ImagePanel
				wide					30
				tall					30
				xpos 					0
				ypos					0
				zpos					110
				image 					"vgui/gradient_circle"
				drawColor				"255 255 255 64"
				visible					1
				scaleImage				1
			}
		}

		GridPageCircleButtonSelected
		{
			ImageSelected
			{
				ControlName				ImagePanel
				wide					30
				tall					30
				xpos 					0
				ypos					0
				zpos					110
				image 					"vgui/gradient_circle"
				visible					1
				scaleImage				1
			}
		}

		SP_TitanLoadout_Always
		{
			LevelImage
			{
				ControlName				ImagePanel
				wide					%100
				tall					%100
				xpos 					0
				ypos					0
				zpos					100
				image					"loadscreens/mp_arid_widescreen"
				drawColor				"255 255 255 255"
				visible					1
				scaleImage				1
			}

			LevelImageFade
			{
				ControlName				ImagePanel
				wide					%100
				tall					%100
				xpos 					0
				ypos					0
				zpos					100
				image					"vgui/HUD/vignette"
				drawColor				"255 255 255 0"
				visible					1
				scaleImage				1

				pin_to_sibling			LevelImage
				pin_corner_to_sibling	CENTER
				pin_to_sibling_corner	CENTER
			}

		}

		SP_Level_Hover
		{
			LevelImageHover
			{
				ControlName				ImagePanel
				wide					%100
				tall					%75
				xpos 					0
				ypos					3
				zpos					100
				image					"vgui/HUD/vignette"
				drawColor				"255 255 255 255"
				visible					1
				scaleImage				1

				pin_to_sibling			LevelImage
				pin_corner_to_sibling	CENTER
				pin_to_sibling_corner	CENTER
			}
		}

		SP_Level_Locked
		{
			LevelImageLocked
			{
				ControlName				ImagePanel
				wide					%100
				tall					%75
				xpos 					0
				ypos					3
				zpos					100
				image					"vgui/HUD/capture_point_status_c_locked"
				drawColor				"255 255 255 150"
				visible					1
				scaleImage				1

				pin_to_sibling			LevelImage
				pin_corner_to_sibling	CENTER
				pin_to_sibling_corner	CENTER
			}
		}

		GridButtonAlwaysGroup
		{
			BackgroundNormal
			{
				ControlName				ImagePanel
				wide					126
				tall					126
				xpos 					0
				ypos					0
				zpos					101
				image 					"vgui/HUD/capture_point_status_a"
				visible					1
				scaleImage				1
			}

			ImageNormal
			{
				ControlName				ImagePanel
				wide					90
				tall					90
				xpos 					18
				ypos					18
				zpos					110
				image 					"vgui/HUD/capture_point_status_blue_a"
				visible					1
				scaleImage				1
			}
		}

		GridButtonFocusedGroup
		{
			BackgroundFocused
			{
				ControlName				ImagePanel
				wide					126
				tall					126
				xpos 					0
				ypos					0
				zpos					102
				image 					"ui/menu/titanDecal_menu/decalSlot_hover"
				visible					1
				scaleImage				1
			}
		}

		GridButtonSelectedGroup
		{
			BackgroundSelected
			{
				ControlName				ImagePanel
				wide					126
				tall					126
				xpos 					0
				ypos					0
				zpos					103
				image 					"ui/menu/titanDecal_menu/decalSlot_selected"
				visible					1
				scaleImage				1
			}
		}

		GridButtonLockedGroup
		{
			BackgroundLocked
			{
				ControlName				ImagePanel
				wide					67
				tall					67
				xpos					0
				ypos					58
				zpos 					120
				image					"ui/menu/common/locked_icon"
				visible					1
				scaleImage				1
			}
		}

		GridButtonNewGroup
		{
			NewIcon
			{
				ControlName				ImagePanel
				wide					58
				tall					58
				xpos					4
				ypos					63
				zpos 					119
				image					"ui/menu/common/newitemicon"
				visible					1
				scaleImage				1
			}
		}

		Test2ButtonAlwaysGroup
		{
			Background
			{
				ControlName				ImagePanel
				wide					96
				tall					96
				zpos					101
				image 					"rui/menu/loadout_boxes/kit_box_bg"
				visible					1
				scaleImage				1
			}

			Item
			{
				ControlName				ImagePanel
				wide					96
				tall					96
				zpos					110
				image 					"ui/test_button_item"
				visible					1
				scaleImage				1
			}
		}

		Test2ButtonFocusedGroup
		{
			Focused
			{
				ControlName				ImagePanel
				wide					96
				tall					96
				zpos					102
				image 					"rui/menu/loadout_boxes/kit_box_bg_inverse"
				visible					1
				scaleImage				1
			}
		}

        Test2ButtonNewGroup
        {
			NewEffect
			{
				ControlName				ImagePanel
				wide					96
				tall					96
				zpos					102
				image 					"ui/test_button_new"
				visible					1
				scaleImage				1
			}
        }

		CoopStoreButtonAlwaysGroup
		{
			BackgroundNormal
			{
				ControlName				ImagePanel
				wide					56
				tall					56
				xpos 					0
				ypos					0
				zpos					101
				image 					"ui/menu/titanDecal_menu/decalSlot_default"
				visible					1
				scaleImage				1
			}

			UnlockNormal
			{
				ControlName				ImagePanel
				wide					40
				tall					40
				xpos 					8
				ypos					8
				zpos					110
				image 					"models/titans/custom_decals/decal_pack_01/wings_custom_decal_menu"
				visible					1
				scaleImage				1
			}
		}

		CoopStoreButtonFocusedGroup
		{
			BackgroundFocused
			{
				ControlName				ImagePanel
				wide					56
				tall					56
				xpos 					0
				ypos					0
				zpos					102
				image 					"ui/menu/titanDecal_menu/decalSlot_hover"
				visible					1
				scaleImage				1
			}
		}

		CoopStoreButtonSelectedGroup
		{
			BackgroundSelected
			{
				ControlName				ImagePanel
				wide					56
				tall					56
				xpos 					0
				ypos					0
				zpos					103
				image 					"ui/menu/titanDecal_menu/decalSlot_selected"
				visible					1
				scaleImage				1
			}
		}

		CoopStoreButtonLockedGroup
		{
			LockIcon
			{
				ControlName				ImagePanel
				wide					30
				tall					30
				xpos					0
				ypos					26
				zpos 					120
				image					"ui/menu/common/locked_icon"
				visible					1
				scaleImage				1
			}
		}

		CoopStoreButtonNewGroup
		{
			NewIcon
			{
				ControlName				ImagePanel
				wide					26
				tall					26
				xpos					2
				ypos					28
				zpos 					119
				image					"ui/menu/coop_store/maxedItemIcon"
				visible					1
				scaleImage				1
			}
		}

		StatsLevelListButtonNormalGroup
		{
			Image1
			{
				ControlName				ImagePanel
				xpos					34
				ypos					22
				wide					202
				tall					90
				visible					1
				image					"ui/menu/personal_stats/weapon_stats/ps_w_thumbnail_back"
				scaleImage				1
			}

			LevelImageNormal
			{
				ControlName				ImagePanel
				xpos					34
				ypos					22
				wide					202
				tall					90
				visible					1
				image 					"ui/menu/challenges/challenge_box_dim_overlay"
				scaleImage				1
			}

			DimOverlay
			{
				ControlName				ImagePanel
				xpos					31
				ypos					11
				wide					207
				tall					112
				visible					1
				image 					"ui/menu/challenges/challenge_box_dim_overlay"
				scaleImage				1
			}
		}

		StatsLevelListButtonFocusedGroup
		{
			Image1
			{
				ControlName				ImagePanel
				xpos					34
				ypos					22
				wide					202
				tall					90
				visible					1
				image					"ui/menu/personal_stats/weapon_stats/ps_w_thumbnail_back"
				scaleImage				1
			}

			LevelImageFocused
			{
				ControlName				ImagePanel
				xpos					34
				ypos					22
				wide					202
				tall					90
				visible					1
				image 					"ui/menu/challenges/challenge_box_dim_overlay"
				scaleImage				1
			}
		}

		StatsLevelListButtonSelectedGroup
		{
			Image1
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					315
				tall					135
				visible					1
				image					"ui/menu/personal_stats/weapon_stats/ps_w_thumbnail_indicator"
				scaleImage				1
			}

			LevelImageSelected
			{
				ControlName				ImagePanel
				xpos					34
				ypos					22
				wide					202
				tall					90
				visible					1
				image 					"ui/menu/challenges/challenge_box_dim_overlay"
				scaleImage				1
			}

			Arrow
			{
				ControlName				ImagePanel
				xpos					263
				ypos					34
				wide					45
				tall					67
				visible					1
				image 					"ui/menu/personal_stats/weapon_stats/ps_w_main_arrow"
				scaleImage				1
			}
		}
	}
}
