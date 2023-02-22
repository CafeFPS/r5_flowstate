scripts/resource/ui/menus/CustomLobby/panels/serverbrowser.res
{
	"DarkenBackground"
	{
		"ControlName"			"Label"
		"xpos"					"0"
		"ypos"					"0"
		"wide"					"%100"
		"tall"					"%100"
		"labelText"				""
		"bgcolor_override"		"0 0 0 0"
		"visible"				"1"
		"paintbackground"		"1"
	}

	"ServerBrowserBG"
	{
		"ControlName"			"ImagePanel"
		"xpos"					"-245"
		"ypos"					"-40"
		"tall"					"50"
		"wide" 					"1395"
		fillColor		"195 29 38 200"
        drawColor		"195 29 38 200"
		"wrap"					"1"
		"visible"				"1"
		"zpos"					"3"

		"pin_to_sibling"		"DarkenBackground"
		"pin_corner_to_sibling"	"TOP"
		"pin_to_sibling_corner"	"TOP"
	}

	"ServersBG"
	{
		"ControlName"			"ImagePanel"
		"xpos"					"0"
		"ypos"					"0"
		"tall"					"600"
		"wide" 					"1395"
		"fillColor"				"30 30 30 120"
        "drawColor"				"30 30 30 120"
		"wrap"					"1"
		"visible"				"1"
		"zpos"					"0"

		"pin_to_sibling"		"ServerBrowserBG"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"BOTTOM_LEFT"
	}

	"ServerBrowserBGBottom"
	{
		"ControlName"			"ImagePanel"
		"xpos"					"0"
		"ypos"					"10"
		"tall"					"240"
		"wide" 					"1395"
		"fillColor"				"30 30 30 200"
        "drawColor"				"30 30 30 200"
		"wrap"					"1"
		"visible"				"1"
		"zpos"					"0"

		"pin_to_sibling"		"ServersBG"
		"pin_corner_to_sibling"	"TOP"
		"pin_to_sibling_corner"	"BOTTOM"
	}

	"BtnSearchLabel"
	{
		"ControlName"			"Label"
		"labelText"				"Search:"
		"xpos"					"-23"
		"ypos"					"-16"
		"auto_wide_tocontents"	"1"
		"zpos" 					"10"
		"fontHeight"			"30"

		ruiArgs
		{
			buttonText "Search:"
		}

		pin_to_sibling 			ServerBrowserBGBottom
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}

	BtnServerSearch
	{
		ControlName				TextEntry
		zpos 100 // This works around input weirdness when the control is constructed by code instead of VGUI blackbox.
		xpos 10
		ypos 0
		wide 1275
		tall 40
		zpos					70
		allowRightClickMenu		0
		allowSpecialCharacters	0
		unicode					1

		visible					1
		enabled					1
		textHidden				0
		editable				1
		maxchars				100
		textAlignment			"center"
		ruiFont                 TitleRegularFont
		ruiFontHeight           22
		ruiMinFontHeight        16
		bgcolor_override		"30 30 30 200"

		pin_to_sibling 			BtnSearchLabel
		pin_corner_to_sibling LEFT
		pin_to_sibling_corner RIGHT
	}

	SwtBtnSelectGamemode
	{
		ControlName RuiButton
		InheritProperties SwitchButton
		style                   DialogListButton
		ConVar "match_rankedSwitchETA"
		wide 670
		ypos 15

		ruiArgs
		{
			buttonText "Playlist Filter"
		}

		pin_to_sibling BtnSearchLabel
		pin_corner_to_sibling TOP_LEFT
		pin_to_sibling_corner BOTTOM_LEFT

		childGroupAlways        MultiChoiceButtonAlways
	}

	SwtBtnSelectMap
	{
		ControlName RuiButton
		InheritProperties SwitchButton
		style                   DialogListButton
		ConVar "match_rankedMaxPing"
		wide 670
		ypos 0
		xpos 10

		ruiArgs
		{
			buttonText "Map Filter"
		}

		pin_to_sibling SwtBtnSelectGamemode
		pin_corner_to_sibling TOP_LEFT
		pin_to_sibling_corner TOP_RIGHT

		childGroupAlways        MultiChoiceButtonAlways
	}

	SwtBtnHideEmpty
	{
		ControlName RuiButton
		InheritProperties SwitchButton
		style                   DialogListButton
		ConVar "grx_hasUnknownItems"
		classname FilterPanelChild
		wide 1349
		ypos 10

		ruiArgs
		{
			buttonText "Hide Empty Servers"
		}

		list
		{
			"No" 0
			"Yes" 1
		}

		pin_to_sibling SwtBtnSelectGamemode
		pin_corner_to_sibling TOP_LEFT
		pin_to_sibling_corner BOTTOM_LEFT

		childGroupAlways        ChoiceButtonAlways
	}

	"NoServersLbl"
	{
		"ControlName"			"Label"
		"labelText"				"No Servers Found"
		"xpos"					"0"
		"ypos"					"-15"
		"auto_wide_tocontents"	"1"
		"zpos" 					"10"
		"fontHeight"			"40"

		"pin_to_sibling"		"ServersBG"
		"pin_corner_to_sibling"	"CENTER"
		"pin_to_sibling_corner"	"CENTER"
	}

	"RefreshServers"
	{
		"ControlName"				"RuiButton"
		"style"						"RuiButton"
		"wide"						"200"
		"tall"						"35"
		"xpos"						"-5"
		"ypos"						"0"
		"visible"					"1"
		"enabled"					"1"
		"zpos" 						"10"
        "rui"						"ui/tab_button.rpak"
		"cursorVelocityModifier"  	"0.7"

		ruiArgs
		{
			buttonText ""
		}

		"pin_to_sibling"			"ServerBrowserBGBottom"
		"pin_corner_to_sibling"		"BOTTOM_LEFT"
		"pin_to_sibling_corner"		"BOTTOM_LEFT"
	}

	"RefreshServersText"
	{
		"ControlName"			"Label"
		"labelText"				"Refresh Servers"
		"font"					"DefaultBold_41"
		"allcaps"				"1"
		"auto_wide_tocontents"	"1"
		"zpos" 					"0"
		"fontHeight"			"25"
		"xpos"					"0"
		"ypos"					"0"
		"zpos" 					"9"
		"fgcolor_override"		"255 255 255 255"

		"pin_to_sibling"		"RefreshServers"
		"pin_corner_to_sibling"	"CENTER"
		"pin_to_sibling_corner"	"CENTER"
	}

	"ClearFliters"
	{
		"ControlName"				"RuiButton"
		"style"						"RuiButton"
		"wide"						"200"
		"tall"						"35"
		"xpos"						"5"
		"ypos"						"0"
		"visible"					"1"
		"enabled"					"1"
		"zpos" 						"10"
        "rui"						"ui/tab_button.rpak"
		"cursorVelocityModifier"  	"0.7"

		ruiArgs
		{
			buttonText ""
		}

		"pin_to_sibling"			"RefreshServers"
		"pin_corner_to_sibling"		"BOTTOM_LEFT"
		"pin_to_sibling_corner"		"BOTTOM_RIGHT"
	}

	"ClearFlitersText"
	{
		"ControlName"			"Label"
		"labelText"				"Clear Filters"
		"font"					"DefaultBold_41"
		"allcaps"				"1"
		"auto_wide_tocontents"	"1"
		"zpos" 					"0"
		"fontHeight"			"25"
		"xpos"					"0"
		"ypos"					"0"
		"zpos" 					"9"
		"fgcolor_override"		"255 255 255 255"

		"pin_to_sibling"		"ClearFliters"
		"pin_corner_to_sibling"	"CENTER"
		"pin_to_sibling_corner"	"CENTER"
	}

	"ListSliderBG"
	{
		"ControlName"			"ImagePanel"
		wide 32
		tall 649
		xpos 2
		ypos 50
		zpos 0
        "fillColor"				"195 29 38 150"
		scaleImage				1
		"visible"				"0"

		pin_to_sibling ServersBG
		pin_corner_to_sibling TOP_LEFT
		pin_to_sibling_corner TOP_RIGHT
	}

	BtnServerListSlider
	{
		ControlName RuiButton
		InheritProperties RuiSmallButton
		//labelText "V"
		wide 30
		tall 550
		xpos 2
		ypos 0
		zpos 0

		image "vgui/hud/white"
		drawColor "255 255 255 255"

		pin_to_sibling ServersBG
		pin_corner_to_sibling TOP_LEFT
		pin_to_sibling_corner TOP_RIGHT
	}

	BtnServerListSliderPanel
	{
		ControlName RuiPanel
		wide 30
		tall 550
		xpos 2
		ypos 0
		zpos 100

		rui "ui/control_options_description.rpak"

		visible 1
		zpos -1

		pin_to_sibling ServersBG
		pin_corner_to_sibling TOP_LEFT
		pin_to_sibling_corner TOP_RIGHT
	}

	// sh_menu_models.gnut has a global function which gets called when
	// left mouse button gets called while hovering and has mouse
	// deltaX; deltaY which we can yoink for ourselfes
	MouseMovementCapture
	{
		ControlName CMouseMovementCapturePanel
		wide 30
		tall 550
		xpos 2
		ypos 1
		zpos 100

		pin_to_sibling ServersBG
		pin_corner_to_sibling TOP_LEFT
		pin_to_sibling_corner TOP_RIGHT
	}

	BtnServerListUpArrow
	{
		ControlName RuiButton
		InheritProperties RuiSmallButton
		//labelText "A"
		wide 30
		tall 45
		xpos 0
		ypos 0
		zpos 5

		image "vgui/hud/white"
		drawColor "255 255 255 128"

		pin_to_sibling ListSliderBG
		pin_corner_to_sibling TOP_LEFT
		pin_to_sibling_corner TOP_LEFT
	}

	BtnServerListUpArrowPanel
	{
		ControlName RuiPanel
		wide 30
		tall 45
		xpos 0
		ypos 0

		rui "ui/control_options_description.rpak"

		visible 1
		zpos 4

		pin_to_sibling ListSliderBG
		pin_corner_to_sibling TOP_LEFT
		pin_to_sibling_corner TOP_LEFT
	}

	BtnServerListDownArrow
	{
		ControlName RuiButton
		InheritProperties RuiSmallButton
		//labelText "A"
		wide 30
		tall 45
		xpos 0
		ypos 0
		zpos 5

		image "vgui/hud/white"
		drawColor "255 255 255 128"

		pin_to_sibling ListSliderBG
		pin_corner_to_sibling BOTTOM_LEFT
		pin_to_sibling_corner BOTTOM_LEFT
	}

	BtnServerListDownArrowPanel
	{
		ControlName RuiPanel
		wide 30
		tall 45
		xpos 0
		ypos 0

		rui "ui/control_options_description.rpak"

		visible 1
		zpos 4

		pin_to_sibling ListSliderBG
		pin_corner_to_sibling BOTTOM_LEFT
		pin_to_sibling_corner BOTTOM_LEFT
	}

	"ServersCount"
	{
		"ControlName"			"Label"
		"labelText"				"Servers: 0"
		"font"					"DefaultBold_41"
		"allcaps"				"1"
		"auto_wide_tocontents"	"1"
		"zpos" 					"7"
		"fontHeight"			"25"
		"xpos"					"-5"
		"ypos"					"0"
		"fgcolor_override"		"255 255 255 255"

		"pin_to_sibling"		"ServerBrowserBGBottom"
		"pin_corner_to_sibling"	"BOTTOM_RIGHT"
		"pin_to_sibling_corner"	"BOTTOM_RIGHT"
	}
	
	"PlayersCount"
	{
		"ControlName"			"Label"
		"labelText"				"Players: 0"
		"font"					"DefaultBold_41"
		"allcaps"				"1"
		"auto_wide_tocontents"	"1"
		"zpos" 					"7"
		"visible"				"1"
		"fontHeight"			"25"
		"xpos"					"30"
		"ypos"					"0"
		"fgcolor_override"		"255 255 255 255"

		"pin_to_sibling"		"ServersCount"
		"pin_corner_to_sibling"	"RIGHT"
		"pin_to_sibling_corner"	"LEFT"
	}

	"ServerNameLbl"
	{
		"ControlName"			"Label"
		"labelText"				"Server Name"
		"xpos"					"-15"
		"ypos"					"0"
		"zpos"					"6"
		"textalignment"			"center"
		"wide"					"150"
		"zpos" 					"4"
		"fontHeight"			"35"
		"tall"					"35"

		"pin_to_sibling"		"ServerBrowserBG"
		"pin_corner_to_sibling"	"LEFT"
		"pin_to_sibling_corner"	"LEFT"
	}

	"PlayerCountLbl"
	{
		"ControlName"			"Label"
		"labelText"				"Players"
		"xpos"					"-670"
		"ypos"					"0"
		"zpos"					"6"
		"textalignment"			"center"
		"wide"					"110"
		"zpos" 					"4"
		"fontHeight"			"35"
		"tall"					"35"

		"pin_to_sibling"		"ServerBrowserBG"
		"pin_corner_to_sibling"	"LEFT"
		"pin_to_sibling_corner"	"LEFT"
	}

	"PlaylistLbl"
	{
		"ControlName"			"Label"
		"labelText"				"Playlist"
		"xpos"					"-800"
		"ypos"					"0"
		"zpos"					"6"
		"textalignment"			"center"
		"wide"					"230"
		"fontHeight"			"35"
		"tall"					"35"

		"pin_to_sibling"		"ServerBrowserBG"
		"pin_corner_to_sibling"	"LEFT"
		"pin_to_sibling_corner"	"LEFT"
	}

	"MapLbl"
	{
		"ControlName"			"Label"
		"labelText"				"Map"
		"xpos"					"-1050"
		"ypos"					"0"
		"zpos"					"6"
		"textalignment"			"center"
		"wide"					"330"
		"fontHeight"			"35"
		"tall"					"35"

		"pin_to_sibling"		"ServerBrowserBG"
		"pin_corner_to_sibling"	"LEFT"
		"pin_to_sibling_corner"	"LEFT"
	}

	"ServerNameLine"
	{
		"ControlName"			"ImagePanel"
		"xpos"					"0"
		"ypos"					"0"
		"tall"					"600"
		"wide" 					"2"
		"fillColor"				"155 155 155 200"
        "drawColor"				"155 155 155 200"
		"wrap"					"1"
		"visible"				"1"
		"zpos"					"3"

		"pin_to_sibling"		"ServerBrowserBG"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"BOTTOM_LEFT"
	}

	"PlayerCountLine"
	{
		"ControlName"			"ImagePanel"
		"xpos"					"-660"
		"ypos"					"0"
		"tall"					"600"
		"wide" 					"2"
		"fillColor"				"155 155 155 200"
        "drawColor"				"155 155 155 200"
		"wrap"					"1"
		"visible"				"1"
		"zpos"					"3"

		"pin_to_sibling"		"ServerBrowserBG"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"BOTTOM_LEFT"
	}

	"PlaylistLine"
	{
		"ControlName"			"ImagePanel"
		"xpos"					"-790"
		"ypos"					"0"
		"tall"					"600"
		"wide" 					"2"
		"fillColor"				"155 155 155 200"
        "drawColor"				"155 155 155 200"
		"wrap"					"1"
		"visible"				"1"
		"zpos"					"3"

		"pin_to_sibling"		"ServerBrowserBG"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"BOTTOM_LEFT"
	}

	"MapLine"
	{
		"ControlName"			"ImagePanel"
		"xpos"					"-1040"
		"ypos"					"0"
		"tall"					"600"
		"wide" 					"2"
		"fillColor"				"155 155 155 200"
        "drawColor"				"155 155 155 200"
		"wrap"					"1"
		"visible"				"1"
		"zpos"					"3"

		"pin_to_sibling"		"ServerBrowserBG"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"BOTTOM_LEFT"
	}

	"RightLine"
	{
		"ControlName"			"ImagePanel"
		"xpos"					"0"
		"ypos"					"0"
		"tall"					"600"
		"wide" 					"2"
		"fillColor"				"155 155 155 200"
        "drawColor"				"155 155 155 200"
		"wrap"					"1"
		"visible"				"1"
		"zpos"					"3"

		"pin_to_sibling"		"ServerBrowserBG"
		"pin_corner_to_sibling"	"TOP_RIGHT"
		"pin_to_sibling_corner"	"BOTTOM_RIGHT"
	}

	"BottomLine"
	{
		"ControlName"			"ImagePanel"
		"xpos"					"0"
		"ypos"					"0"
		"tall"					"2"
		"wide" 					"1395"
		"fillColor"				"155 155 155 200"
        "drawColor"				"155 155 155 200"
		"wrap"					"1"
		"visible"				"1"
		"zpos"					"3"

		"pin_to_sibling"		"ServersBG"
		"pin_corner_to_sibling"	"BOTTOM_LEFT"
		"pin_to_sibling_corner"	"BOTTOM_LEFT"
	}

	"TopLine"
	{
		"ControlName"			"ImagePanel"
		"xpos"					"0"
		"ypos"					"0"
		"tall"					"2"
		"wide" 					"1395"
		"fillColor"				"155 155 155 200"
        "drawColor"				"155 155 155 200"
		"wrap"					"1"
		"visible"				"1"
		"zpos"					"3"

		"pin_to_sibling"		"ServersBG"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"TOP_LEFT"
	}

	"ServerMapImg"
	{
		"ControlName"			"RuiPanel"
		"wide"					"450"
		"tall"            		"250"
		"visible"				"1"
		"rui"           		"ui/custom_loadscreen_image.rpak"
		"ypos" 					"0"
		"xpos"					"40"
		"zpos" 					"4"

		"pin_to_sibling"		"ServerBrowserBG"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"TOP_RIGHT"
	}

	"ServerInfoBG"
	{
		"ControlName"			"ImagePanel"
		"xpos" 					"0"
		"ypos" 					"0"
		"tall"					"560"
		"wide" 					"450"
		"fillColor"				"30 30 30 200"
        "drawColor"				"30 30 30 200"
		"wrap"					"1"
		"visible"				"1"
		"zpos"					"3"
		"pin_to_sibling"		"ServerMapImg"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"BOTTOM_LEFT"
	}

	"ServerNameInfoEdit"
	{
		"ControlName"			"Label"
		"labelText"				""
		"font"					"Default_27_Outline"
		"allcaps"				"1"
		"wide"					"420"
		"zpos" 					"7"
		"fontHeight"			"25"
		"xpos"					"0"
		"ypos"					"-5"
		"textAlignment"			"center"
		fgcolor_override		"240 240 240 255"
		"bgcolor_override"		"0 0 0 255"

		"pin_to_sibling"		"ServerInfoBG"
		"pin_corner_to_sibling"	"TOP"
		"pin_to_sibling_corner"	"TOP"
	}

	"ServerCurrentMap"
	{
		"ControlName"			"Label"
		"labelText"				""
		"font"					"Default_27_Outline"
		"allcaps"				"1"
		"wide"					"100"
		"zpos" 					"7"
		"fontHeight"			"20"
		"xpos"					"-15"
		"ypos"					"-35"
		"textAlignment"			"left"
		fgcolor_override		"240 240 240 255"
		"bgcolor_override"		"0 0 0 255"

		"pin_to_sibling"		"ServerInfoBG"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"TOP_LEFT"
	}

	"ServerCurrentMapEdit"
	{
		"ControlName"			"Label"
		"textAlignment"			"east"
		"labelText"				""
		"font"					"Default_27_Outline"
		"allcaps"				"1"
		"wide"					"270"
		"zpos" 					"7"
		"fontHeight"			"20"
		"xpos"					"-15"
		"ypos"					"-35"
		fgcolor_override		"240 240 240 255"
		"bgcolor_override"		"0 0 0 255"

		"pin_to_sibling"		"ServerInfoBG"
		"pin_corner_to_sibling"	"TOP_RIGHT"
		"pin_to_sibling_corner"	"TOP_RIGHT"
	}

	"ServerCurrentPlaylist"
	{
		"ControlName"			"Label"
		"labelText"				""
		"font"					"Default_27_Outline"
		"allcaps"				"1"
		"wide"					"130"
		"zpos" 					"7"
		"fontHeight"			"20"
		"xpos"					"-15"
		"ypos"					"-65"
		"textAlignment"			"left"
		fgcolor_override		"240 240 240 255"
		"bgcolor_override"		"0 0 0 255"

		"pin_to_sibling"		"ServerInfoBG"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"TOP_LEFT"
	}

	"PlaylistInfoEdit"
	{
		"ControlName"			"Label"
		"labelText"				""
		"font"					"Default_27_Outline"
		"allcaps"				"1"
		"wide"					"270"
		"zpos" 					"7"
		"fontHeight"			"20"
		"xpos"					"-15"
		"ypos"					"-65"
		"textAlignment"			"east"
		"fgcolor_override"		"240 240 240 255"
		"bgcolor_override"		"0 0 0 255"

		"pin_to_sibling"		"ServerInfoBG"
		"pin_corner_to_sibling"	"TOP_RIGHT"
		"pin_to_sibling_corner"	"TOP_RIGHT"
	}

	"ServerDesc"
	{
		"ControlName"			"Label"
		"labelText"				""
		"wide"					"390"
		"tall"					"130"
		"wrap"					"1"
		"zpos" 					"7"
		"fontHeight"			"25"
		"xpos"					"-15"
		"ypos"					"-105"
		"textAlignment"			"north-west"
		"fgcolor_override"		"255 255 255 255"

		"pin_to_sibling"		"ServerInfoBG"
		"pin_corner_to_sibling"	"TOP_LEFT"
		"pin_to_sibling_corner"	"TOP_LEFT"
	}

	"ConnectButtonBG"
	{
		"ControlName"			"ImagePanel"
		"xpos" 					"0"
		"ypos" 					"0"
		"tall"					"90"
		"wide" 					"450"
		"fillColor"				"195 29 38 200"
        "drawColor"				"195 29 38 200"
		"visible"				"1"
		"zpos"					"1"

		"pin_to_sibling"		"ServerInfoBG"
		"pin_corner_to_sibling"	"TOP"
		"pin_to_sibling_corner"	"BOTTOM"
	}

	"ConnectButtonText"
	{
		"ControlName"			"Label"
		"labelText"				"Connect"
		"font"					"Default_27_Outline"
		"allcaps"				"1"
		"wide"					"200"
		"zpos" 					"3"
		"fontHeight"			"50"
		"tall"					"50"
		"xpos"					"0"
		"ypos"					"0"
		"textAlignment"			"center"
		fgcolor_override		"240 240 240 255"
		"bgcolor_override"		"0 0 0 255"

		"pin_to_sibling"		"ConnectButtonBG"
		"pin_corner_to_sibling"	"CENTER"
		"pin_to_sibling_corner"	"CENTER"
	}

	"ConnectButton"
	{
		ControlName RuiButton
		InheritProperties RuiSmallButton
		wide 450
		tall 90
		xpos 0
		ypos 0
		zpos 6


		pin_to_sibling ConnectButtonBG
		pin_corner_to_sibling CENTER
		pin_to_sibling_corner CENTER
	}

	"ServerButton0"
	{
		"ControlName"				"RuiButton"
		"classname"					"ServBtn"
		"wide"						"1395"
		"tall"						"40"
		"doubleClickEvents"       	"1"
		"visible"					"1"
		"enabled"					"1"
		"style"						"RuiButton"
        "rui"						"ui/tab_button.rpak"
		"labelText"					""
		"cursorVelocityModifier"  	"0.7"
		"zpos"						"1"
		"scriptID"					"0"
		

		"pin_to_sibling"			"ServerBrowserBG"
		"pin_corner_to_sibling"		"TOP_LEFT"
		"pin_to_sibling_corner"		"BOTTOM_LEFT"
	}

	"ServerButton1"
	{
		"ControlName"				"RuiButton"
		"classname"					"ServBtn"
		"wide"						"1395"
		"tall"						"40"
		"doubleClickEvents"       	"1"
		"visible"					"1"
		"enabled"					"1"
		"style"						"RuiButton"
        "rui"						"ui/tab_button.rpak"
		"labelText"					""
		"cursorVelocityModifier"  	"0.7"
		"zpos"						"1"
		"scriptID"					"1"

		"pin_to_sibling"			"ServerButton0"
		"pin_corner_to_sibling"		"TOP_LEFT"
		"pin_to_sibling_corner"		"BOTTOM_LEFT"
	}

	"ServerButton2"
	{
		"ControlName"				"RuiButton"
		"classname"					"ServBtn"
		"wide"						"1395"
		"tall"						"40"
		"doubleClickEvents"       	"1"
		"visible"					"1"
		"enabled"					"1"
		"style"						"RuiButton"
        "rui"						"ui/tab_button.rpak"
		"labelText"					""
		"cursorVelocityModifier"  	"0.7"
		"zpos"						"1"
		"scriptID"					"2"

		"pin_to_sibling"			"ServerButton1"
		"pin_corner_to_sibling"		"TOP_LEFT"
		"pin_to_sibling_corner"		"BOTTOM_LEFT"
	}

	"ServerButton3"
	{
		"ControlName"				"RuiButton"
		"classname"					"ServBtn"
		"wide"						"1395"
		"tall"						"40"
		"doubleClickEvents"       	"1"
		"visible"					"1"
		"enabled"					"1"
		"style"						"RuiButton"
        "rui"						"ui/tab_button.rpak"
		"labelText"					""
		"cursorVelocityModifier"  	"0.7"
		"zpos"						"1"
		"scriptID"					"3"

		"pin_to_sibling"			"ServerButton2"
		"pin_corner_to_sibling"		"TOP_LEFT"
		"pin_to_sibling_corner"		"BOTTOM_LEFT"
	}

	"ServerButton4"
	{
		"ControlName"				"RuiButton"
		"classname"					"ServBtn"
		"wide"						"1395"
		"tall"						"40"
		"doubleClickEvents"       	"1"
		"visible"					"1"
		"enabled"					"1"
		"style"						"RuiButton"
        "rui"						"ui/tab_button.rpak"
		"labelText"					""
		"cursorVelocityModifier"  	"0.7"
		"zpos"						"1"
		"scriptID"					"4"

		"pin_to_sibling"			"ServerButton3"
		"pin_corner_to_sibling"		"TOP_LEFT"
		"pin_to_sibling_corner"		"BOTTOM_LEFT"
	}

	"ServerButton5"
	{
		"ControlName"				"RuiButton"
		"classname"					"ServBtn"
		"wide"						"1395"
		"tall"						"40"
		"doubleClickEvents"       	"1"
		"visible"					"1"
		"enabled"					"1"
		"style"						"RuiButton"
        "rui"						"ui/tab_button.rpak"
		"labelText"					""
		"cursorVelocityModifier"  	"0.7"
		"zpos"						"1"
		"scriptID"					"5"

		"pin_to_sibling"			"ServerButton4"
		"pin_corner_to_sibling"		"TOP_LEFT"
		"pin_to_sibling_corner"		"BOTTOM_LEFT"
	}

	"ServerButton6"
	{
		"ControlName"				"RuiButton"
		"classname"					"ServBtn"
		"wide"						"1395"
		"tall"						"40"
		"doubleClickEvents"       	"1"
		"visible"					"1"
		"enabled"					"1"
		"style"						"RuiButton"
        "rui"						"ui/tab_button.rpak"
		"labelText"					""
		"cursorVelocityModifier"  	"0.7"
		"zpos"						"1"
		"scriptID"					"6"

		"pin_to_sibling"			"ServerButton5"
		"pin_corner_to_sibling"		"TOP_LEFT"
		"pin_to_sibling_corner"		"BOTTOM_LEFT"
	}

	"ServerButton7"
	{
		"ControlName"				"RuiButton"
		"classname"					"ServBtn"
		"wide"						"1395"
		"tall"						"40"
		"doubleClickEvents"       	"1"
		"visible"					"1"
		"enabled"					"1"
		"style"						"RuiButton"
        "rui"						"ui/tab_button.rpak"
		"labelText"					""
		"cursorVelocityModifier"  	"0.7"
		"zpos"						"1"
		"scriptID"					"7"

		"pin_to_sibling"			"ServerButton6"
		"pin_corner_to_sibling"		"TOP_LEFT"
		"pin_to_sibling_corner"		"BOTTOM_LEFT"
	}

	"ServerButton8"
	{
		"ControlName"				"RuiButton"
		"classname"					"ServBtn"
		"wide"						"1395"
		"tall"						"40"
		"doubleClickEvents"       	"1"
		"visible"					"1"
		"enabled"					"1"
		"style"						"RuiButton"
        "rui"						"ui/tab_button.rpak"
		"labelText"					""
		"cursorVelocityModifier"  	"0.7"
		"zpos"						"1"
		"scriptID"					"8"

		"pin_to_sibling"			"ServerButton7"
		"pin_corner_to_sibling"		"TOP_LEFT"
		"pin_to_sibling_corner"		"BOTTOM_LEFT"
	}

	"ServerButton9"
	{
		"ControlName"				"RuiButton"
		"classname"					"ServBtn"
		"wide"						"1395"
		"tall"						"40"
		"doubleClickEvents"       	"1"
		"visible"					"1"
		"enabled"					"1"
		"style"						"RuiButton"
        "rui"						"ui/tab_button.rpak"
		"labelText"					""
		"cursorVelocityModifier"  	"0.7"
		"zpos"						"1"
		"scriptID"					"9"

		"pin_to_sibling"			"ServerButton8"
		"pin_corner_to_sibling"		"TOP_LEFT"
		"pin_to_sibling_corner"		"BOTTOM_LEFT"
	}

	"ServerButton10"
	{
		"ControlName"				"RuiButton"
		"classname"					"ServBtn"
		"wide"						"1395"
		"tall"						"40"
		"doubleClickEvents"       	"1"
		"visible"					"1"
		"enabled"					"1"
		"style"						"RuiButton"
        "rui"						"ui/tab_button.rpak"
		"labelText"					""
		"cursorVelocityModifier"  	"0.7"
		"zpos"						"1"
		"scriptID"					"10"

		"pin_to_sibling"			"ServerButton9"
		"pin_corner_to_sibling"		"TOP_LEFT"
		"pin_to_sibling_corner"		"BOTTOM_LEFT"
	}

	"ServerButton11"
	{
		"ControlName"				"RuiButton"
		"classname"					"ServBtn"
		"wide"						"1395"
		"tall"						"40"
		"doubleClickEvents"       	"1"
		"visible"					"1"
		"enabled"					"1"
		"style"						"RuiButton"
        "rui"						"ui/tab_button.rpak"
		"labelText"					""
		"cursorVelocityModifier"  	"0.7"
		"zpos"						"1"
		"scriptID"					"11"

		"pin_to_sibling"			"ServerButton10"
		"pin_corner_to_sibling"		"TOP_LEFT"
		"pin_to_sibling_corner"		"BOTTOM_LEFT"
	}

	"ServerButton12"
	{
		"ControlName"				"RuiButton"
		"classname"					"ServBtn"
		"wide"						"1395"
		"tall"						"40"
		"doubleClickEvents"       	"1"
		"visible"					"1"
		"enabled"					"1"
		"style"						"RuiButton"
        "rui"						"ui/tab_button.rpak"
		"labelText"					""
		"cursorVelocityModifier"  	"0.7"
		"zpos"						"1"
		"scriptID"					"12"

		"pin_to_sibling"			"ServerButton11"
		"pin_corner_to_sibling"		"TOP_LEFT"
		"pin_to_sibling_corner"		"BOTTOM_LEFT"
	}

	"ServerButton13"
	{
		"ControlName"				"RuiButton"
		"classname"					"ServBtn"
		"wide"						"1395"
		"tall"						"40"
		"doubleClickEvents"       	"1"
		"visible"					"1"
		"enabled"					"1"
		"style"						"RuiButton"
        "rui"						"ui/tab_button.rpak"
		"labelText"					""
		"cursorVelocityModifier"  	"0.7"
		"zpos"						"1"
		"scriptID"					"13"

		"pin_to_sibling"			"ServerButton12"
		"pin_corner_to_sibling"		"TOP_LEFT"
		"pin_to_sibling_corner"		"BOTTOM_LEFT"
	}

	"ServerButton14"
	{
		"ControlName"				"RuiButton"
		"classname"					"ServBtn"
		"wide"						"1395"
		"tall"						"40"
		"doubleClickEvents"       	"1"
		"visible"					"1"
		"enabled"					"1"
		"style"						"RuiButton"
        "rui"						"ui/tab_button.rpak"
		"labelText"					""
		"cursorVelocityModifier"  	"0.7"
		"zpos"						"1"
		"scriptID"					"14"

		"pin_to_sibling"			"ServerButton13"
		"pin_corner_to_sibling"		"TOP_LEFT"
		"pin_to_sibling_corner"		"BOTTOM_LEFT"
	}

	"ServerName0"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-15"
		"ypos"						"0"
		"zpos"						"0"
		"wide"						"630"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton0"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"ServerName1"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-15"
		"ypos"						"0"
		"zpos"						"0"
		"wide"						"630"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton1"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"ServerName2"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-15"
		"ypos"						"0"
		"zpos"						"0"
		"wide"						"630"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton2"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"ServerName3"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-15"
		"ypos"						"0"
		"zpos"						"0"
		"wide"						"630"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton3"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"ServerName4"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-15"
		"ypos"						"0"
		"zpos"						"0"
		"wide"						"630"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton4"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"ServerName5"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-15"
		"ypos"						"0"
		"zpos"						"0"
		"wide"						"630"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton5"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"ServerName6"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-15"
		"ypos"						"0"
		"zpos"						"0"
		"wide"						"630"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton6"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"ServerName7"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-15"
		"ypos"						"0"
		"zpos"						"0"
		"wide"						"630"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton7"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"ServerName8"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-15"
		"ypos"						"0"
		"zpos"						"0"
		"wide"						"630"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton8"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"ServerName9"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-15"
		"ypos"						"0"
		"zpos"						"0"
		"wide"						"630"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton9"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"ServerName10"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-15"
		"ypos"						"0"
		"zpos"						"0"
		"wide"						"630"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton10"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"ServerName11"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-15"
		"ypos"						"0"
		"zpos"						"0"
		"wide"						"630"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton11"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"ServerName12"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-15"
		"ypos"						"0"
		"zpos"						"0"
		"wide"						"630"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton12"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"ServerName13"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-15"
		"ypos"						"0"
		"zpos"						"0"
		"wide"						"630"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton13"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"ServerName14"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-15"
		"ypos"						"0"
		"zpos"						"0"
		"wide"						"630"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton14"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Playlist0"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-800"
		"ypos"						"0"
		"zpos"						"0"
		"textAlignment"				"center"
		"wide"						"230"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton0"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Playlist1"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-800"
		"ypos"						"0"
		"zpos"						"0"
		"textalignment"				"center"
		"wide"						"230"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton1"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Playlist2"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-800"
		"ypos"						"0"
		"zpos"						"0"
		"textalignment"				"center"
		"wide"						"230"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton2"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Playlist3"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-800"
		"ypos"						"0"
		"zpos"						"0"
		"textalignment"				"center"
		"wide"						"230"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton3"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Playlist4"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-800"
		"ypos"						"0"
		"zpos"						"0"
		"textalignment"				"center"
		"wide"						"230"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton4"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Playlist5"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-800"
		"ypos"						"0"
		"zpos"						"0"
		"textalignment"				"center"
		"wide"						"230"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton5"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Playlist6"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-800"
		"ypos"						"0"
		"zpos"						"0"
		"textalignment"				"center"
		"wide"						"230"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton6"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Playlist7"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-800"
		"ypos"						"0"
		"zpos"						"0"
		"textalignment"				"center"
		"wide"						"230"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton7"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Playlist8"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-800"
		"ypos"						"0"
		"zpos"						"0"
		"textalignment"				"center"
		"wide"						"230"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton8"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Playlist9"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-800"
		"ypos"						"0"
		"zpos"						"0"
		"textalignment"				"center"
		"wide"						"230"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton9"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Playlist10"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-800"
		"ypos"						"0"
		"zpos"						"0"
		"textalignment"				"center"
		"wide"						"230"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton10"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Playlist11"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-800"
		"ypos"						"0"
		"zpos"						"0"
		"textalignment"				"center"
		"wide"						"230"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton11"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Playlist12"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-800"
		"ypos"						"0"
		"zpos"						"0"
		"textalignment"				"center"
		"wide"						"230"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton12"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Playlist13"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-800"
		"ypos"						"0"
		"zpos"						"0"
		"textalignment"				"center"
		"wide"						"230"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton13"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Playlist14"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-800"
		"ypos"						"0"
		"zpos"						"0"
		"textalignment"				"center"
		"wide"						"230"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton14"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"PlayerCount0"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-670"
		"ypos"						"0"
		"zpos"						"0"
		"textAlignment"				"center"
		"wide"						"110"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton0"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"PlayerCount1"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-670"
		"ypos"						"0"
		"zpos"						"0"
		"textalignment"				"center"
		"wide"						"110"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton1"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"PlayerCount2"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-670"
		"ypos"						"0"
		"zpos"						"0"
		"textalignment"				"center"
		"wide"						"110"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton2"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"PlayerCount3"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-670"
		"ypos"						"0"
		"zpos"						"0"
		"textalignment"				"center"
		"wide"						"110"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton3"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"PlayerCount4"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-670"
		"ypos"						"0"
		"zpos"						"0"
		"textalignment"				"center"
		"wide"						"110"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton4"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"PlayerCount5"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-670"
		"ypos"						"0"
		"zpos"						"0"
		"textalignment"				"center"
		"wide"						"110"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton5"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"PlayerCount6"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-670"
		"ypos"						"0"
		"zpos"						"0"
		"textalignment"				"center"
		"wide"						"110"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton6"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"PlayerCount7"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-670"
		"ypos"						"0"
		"zpos"						"0"
		"textalignment"				"center"
		"wide"						"110"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton7"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"PlayerCount8"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-670"
		"ypos"						"0"
		"zpos"						"0"
		"textalignment"				"center"
		"wide"						"110"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton8"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"PlayerCount9"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-670"
		"ypos"						"0"
		"zpos"						"0"
		"textalignment"				"center"
		"wide"						"110"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton9"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"PlayerCount10"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-670"
		"ypos"						"0"
		"zpos"						"0"
		"textalignment"				"center"
		"wide"						"110"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton10"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"PlayerCount11"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-670"
		"ypos"						"0"
		"zpos"						"0"
		"textalignment"				"center"
		"wide"						"110"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton11"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"PlayerCount12"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-670"
		"ypos"						"0"
		"zpos"						"0"
		"textalignment"				"center"
		"wide"						"110"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton12"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"PlayerCount13"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-670"
		"ypos"						"0"
		"zpos"						"0"
		"textalignment"				"center"
		"wide"						"110"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton13"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"PlayerCount14"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-670"
		"ypos"						"0"
		"zpos"						"0"
		"textalignment"				"center"
		"wide"						"110"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton14"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Map0"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-1050"
		"ypos"						"0"
		"zpos"						"0"
		"textalignment"				"center"
		"wide"						"330"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton0"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Map1"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-1050"
		"ypos"						"0"
		"zpos"						"0"
		"textalignment"				"center"
		"wide"						"330"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton1"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Map2"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-1050"
		"ypos"						"0"
		"zpos"						"0"
		"textalignment"				"center"
		"wide"						"330"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton2"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Map3"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-1050"
		"ypos"						"0"
		"zpos"						"0"
		"textalignment"				"center"
		"wide"						"330"
		"zpos" 						"4"
		"fontHeight"				"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton3"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Map4"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-1050"
		"ypos"						"0"
		"zpos"						"0"
		"textalignment"				"center"
		"wide"						"330"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton4"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Map5"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-1050"
		"ypos"						"0"
		"zpos"						"0"
		"textalignment"				"center"
		"wide"						"330"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton5"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Map6"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-1050"
		"ypos"						"0"
		"zpos"						"0"
		"textalignment"				"center"
		"wide"						"330"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton6"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Map7"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-1050"
		"ypos"						"0"
		"zpos"						"0"
		"textalignment"				"center"
		"wide"						"330"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton7"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Map8"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-1050"
		"ypos"						"0"
		"zpos"						"0"
		"textalignment"				"center"
		"wide"						"330"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton8"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Map9"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-1050"
		"ypos"						"0"
		"zpos"						"0"
		"textalignment"				"center"
		"wide"						"330"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton9"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Map10"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-1050"
		"ypos"						"0"
		"zpos"						"0"
		"textalignment"				"center"
		"wide"						"330"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton10"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Map11"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-1050"
		"ypos"						"0"
		"zpos"						"0"
		"textalignment"				"center"
		"wide"						"330"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton11"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Map12"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-1050"
		"ypos"						"0"
		"zpos"						"0"
		"textalignment"				"center"
		"wide"						"330"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton12"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Map13"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-1050"
		"ypos"						"0"
		"zpos"						"0"
		"textalignment"				"center"
		"wide"						"330"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton13"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}

	"Map14"
	{
		"ControlName"				"Label"
		"labelText"					""
		"xpos"						"-1050"
		"ypos"						"0"
		"zpos"						"0"
		"textalignment"				"center"
		"wide"						"330"
		"zpos" 						"4"
		"fontHeight"				"30"
		"tall"						"30"
		"classname"					"ServerLabels"

		"pin_to_sibling"			"ServerButton14"
		"pin_corner_to_sibling"		"LEFT"
		"pin_to_sibling_corner"		"LEFT"
	}
}

