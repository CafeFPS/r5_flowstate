"scripts/resource/ui/menus/R5R/privatematch.menu"
{
		"DarkenBackground"
		{
			"ControlName"			"Label"
			"wide"					"%100"
			"tall"					"%100"
			"labelText"				""
			"visible"				"1"
		}

		"CreateServerBG"
		{
			ControlName				ImagePanel
			"classname"				"CreateServerUI"
			ypos 			-100
			xpos			-20
			wide			490
			tall            280
			fillColor		"30 30 30 100"
			drawColor		"30 30 30 100"
			visible					1
			zpos					0
			pin_to_sibling				DarkenBackground
			pin_corner_to_sibling		TOP_LEFT
			pin_to_sibling_corner		TOP_LEFT
		}

		"CreateServerBGTopLine"
		{
			ControlName				ImagePanel
			"classname"				"CreateServerUI"
			wide			490
			tall            3
			fillColor		"195 29 38 200"
			drawColor		"195 29 38 200"
			visible					1
			zpos					0
			pin_to_sibling				CreateServerBG
			pin_corner_to_sibling		TOP
			pin_to_sibling_corner		BOTTOM
		}

		"CreateServerBGBottomLine"
		{
			ControlName				ImagePanel
			"classname"				"CreateServerUI"
			wide			490
			tall            40
			fillColor		"195 29 38 200"
			drawColor		"195 29 38 200"
			visible					1
			zpos					0
			pin_to_sibling				CreateServerBG
			pin_corner_to_sibling		BOTTOM
			pin_to_sibling_corner		TOP
		}

		ServerSettingsText
		{
			ControlName				Label
			"classname"				"CreateServerUI"
			labelText				"Server Settings"
			"font"					"DefaultBold_41"
			"allcaps"				"1"
			auto_wide_tocontents	1
			zpos 					10
			fontHeight				25
			xpos					0
			ypos					0
			"fgcolor_override"		"255 255 255 255"

			pin_to_sibling CreateServerBGBottomLine
			pin_corner_to_sibling CENTER
			pin_to_sibling_corner CENTER
		}

		ServerMapImg
		{
			ControlName		RuiPanel
			wide			680
			tall            370
			visible			1
			rui           	"ui/custom_loadscreen_image.rpak"
			ypos 			-125
			xpos			-25
			zpos 1

			pin_to_sibling				DarkenBackground
			pin_corner_to_sibling		BOTTOM_LEFT
			pin_to_sibling_corner		BOTTOM_LEFT
		}

		"ServerMapImgTopLine"
		{
			ControlName				ImagePanel
			wide			680
			tall            3
			fillColor		"195 29 38 200"
			drawColor		"195 29 38 200"
			visible					1
			zpos					0
			pin_to_sibling				ServerMapImg
			pin_corner_to_sibling		TOP
			pin_to_sibling_corner		BOTTOM
		}

		"ServerMapImgBottomLine"
		{
			ControlName				ImagePanel
			wide			680
			tall            3
			fillColor		"195 29 38 200"
			drawColor		"195 29 38 200"
			visible					1
			zpos					0
			pin_to_sibling				ServerMapImg
			pin_corner_to_sibling		BOTTOM
			pin_to_sibling_corner		TOP
		}

		LobbyChatBox
		{
			ControlName             CBaseHudChat
			InheritProperties       ChatBox

			bgcolor_override        "0 0 0 80"
			chatBorderThickness     1
			chatHistoryBgColor      "24 27 30 120"
			chatEntryBgColor        "24 27 30 120"
			chatEntryBgColorFocused "24 27 30 120"

			destination				    "global"
			hideInputBox			0
			visible                    1
			teamChat                   0
			stopMessageModeOnFocusLoss 1
			menuModeWithFade           0
			messageModeAlwaysOn		1

			xpos					32
			ypos					5
			zpos                    200

			tall 					261
			wide					650

			pin_to_sibling			ServerMapImg
			pin_corner_to_sibling	BOTTOM_LEFT
			pin_to_sibling_corner	BOTTOM_RIGHT
		}

		"ChatTopLine"
		{
			ControlName				ImagePanel
			wide			648
			tall            35
			ypos			-1
			xpos			0
			fillColor		"195 29 38 200"
			drawColor		"195 29 38 200"
			visible					1
			zpos					0
			pin_to_sibling				LobbyChatBox
			pin_corner_to_sibling		BOTTOM
			pin_to_sibling_corner		TOP
		}

		ChatRoomText
		{
			ControlName				Label
			labelText				"Chat Room"
			"font"					"DefaultBold_41"
			"allcaps"				"1"
			auto_wide_tocontents	1
			zpos 					3
			fontHeight				25
			xpos					0
			ypos					0
			"fgcolor_override"		"255 255 255 255"

			pin_to_sibling ChatTopLine
			pin_corner_to_sibling CENTER
			pin_to_sibling_corner CENTER
		}

		HostSettingUpGamePanel
		{
			ControlName				ImagePanel
			wide			680
			tall            40
			fillColor		"195 29 38 200"
			drawColor		"195 29 38 200"
			visible					1
			zpos					0
			xpos 0
			ypos 10

			pin_to_sibling			ServerMapImg
			pin_corner_to_sibling	BOTTOM_LEFT
			pin_to_sibling_corner	TOP_LEFT
		}

		HostSettingUpGamePanelText
		{
			ControlName				Label
			labelText				"Host is currently setting up the match"
			"font"					"DefaultBold_41"
			"allcaps"				"1"
			auto_wide_tocontents	1
			zpos 					3
			fontHeight				25
			xpos					0
			ypos					0
			"fgcolor_override"		"255 255 255 255"

			pin_to_sibling HostSettingUpGamePanel
			pin_corner_to_sibling CENTER
			pin_to_sibling_corner CENTER
		}

		StartGamePanel
		{
			ControlName RuiPanel
			"classname"				"CreateServerUI"
			wide 680
			tall 50
			xpos 0
			ypos 10

			rui "ui/control_options_description.rpak"

			visible 1
			zpos 0

			pin_to_sibling			ServerMapImg
			pin_corner_to_sibling	BOTTOM_LEFT
			pin_to_sibling_corner	TOP_LEFT
		}

		BtnStartGame
		{
			ControlName RuiButton
			InheritProperties RuiSmallButton
			"classname"				"CreateServerUI"
			wide 680
			tall 50
			xpos 0
			ypos 0
			zpos 6


			pin_to_sibling StartGamePanel
			pin_corner_to_sibling CENTER
			pin_to_sibling_corner CENTER
		}

		BtnStartGameText
		{
			ControlName				Label
			"classname"				"CreateServerUI"
			labelText				"Start Game"
			"font"					"DefaultBold_41"
			"allcaps"				"1"
			auto_wide_tocontents	1
			zpos 					3
			fontHeight				25
			xpos					0
			ypos					0
			"fgcolor_override"		"255 255 255 255"

			pin_to_sibling StartGamePanel
			pin_corner_to_sibling CENTER
			pin_to_sibling_corner CENTER
		}

		PlaylistNameBG
		{
			ControlName				ImagePanel
			xpos 0
			ypos -15
			tall					30
			wide 					225
			fillColor		"30 30 30 200"
			drawColor		"30 30 30 200"
			wrap					1
			visible					1
			zpos					6
			pin_to_sibling				ServerMapImg
			pin_corner_to_sibling		BOTTOM_RIGHT
			pin_to_sibling_corner		BOTTOM_RIGHT
		}

		PlaylistInfoEdit
		{
			ControlName				Label
			labelText				"custom_tdm"
			font					Default_27_Outline
			"allcaps"				"1"
			wide					225
			zpos 					7
			fontHeight				25
			textAlignment			"center"
			xpos					5
			ypos					0
			fgcolor_override		"240 240 240 255"
			bgcolor_override		"0 0 0 255"

			pin_to_sibling				PlaylistNameBG
			pin_corner_to_sibling		RIGHT
			pin_to_sibling_corner		RIGHT
		}

		MapServerNameBG
		{
			ControlName				ImagePanel
			xpos 0
			ypos -15
			tall					30
			wide 					680
			fillColor		"30 30 30 200"
			drawColor		"30 30 30 200"
			wrap					1
			visible					1
			zpos					6
			pin_to_sibling				ServerMapImg
			pin_corner_to_sibling		TOP_LEFT
			pin_to_sibling_corner		TOP_LEFT
		}

		MapServerNameInfoEdit
		{
			ControlName				Label
			labelText				"Some Server Name"
			font					Default_27_Outline
			"allcaps"				"1"
			wide					680
			zpos 					7
			fontHeight				25
			textAlignment			"center"
			xpos					0
			ypos					0
			fgcolor_override		"240 240 240 255"
			bgcolor_override		"0 0 0 255"

			pin_to_sibling				MapServerNameBG
			pin_corner_to_sibling		LEFT
			pin_to_sibling_corner		LEFT
		}

		VisBG
		{
			ControlName				ImagePanel
			xpos 0
			ypos -15
			tall					30
			wide 					125
			fillColor		"30 30 30 200"
			drawColor		"30 30 30 200"
			wrap					1
			visible					1
			zpos					6
			pin_to_sibling				ServerMapImg
			pin_corner_to_sibling		BOTTOM_LEFT
			pin_to_sibling_corner		BOTTOM_LEFT
		}

		VisInfoEdit
		{
			ControlName				Label
			labelText				"custom_tdm"
			font					Default_27_Outline
			"allcaps"				"1"
			wide					125
			zpos 					7
			fontHeight				25
			textAlignment			"center"
			xpos					0
			ypos					0
			fgcolor_override		"240 240 240 255"
			bgcolor_override		"0 0 0 255"

			pin_to_sibling				VisBG
			pin_corner_to_sibling		RIGHT
			pin_to_sibling_corner		RIGHT
		}

		ServerNamePanel
		{
			ControlName RuiPanel
			"classname"				"CreateServerUI"
			wide 480
			tall 50
			xpos 0
			ypos -5

			rui "ui/control_options_description.rpak"

			visible 1
			zpos 0

			pin_to_sibling			CreateServerBG
			pin_corner_to_sibling	TOP
			pin_to_sibling_corner	TOP
		}

		BtnServerName
		{
			ControlName RuiButton
			InheritProperties RuiSmallButton
			wide 480
			tall 50
			xpos 0
			ypos 0
			zpos 6
			classname			"createserverbuttons"
			"scriptID"					"3"


			pin_to_sibling ServerNamePanel
			pin_corner_to_sibling CENTER
			pin_to_sibling_corner CENTER
		}

		BtnServerNameTxT
		{
			ControlName				Label
			"classname"				"CreateServerUI"
			labelText				"Server Name"
			"font"					"DefaultBold_41"
			"allcaps"				"1"
			auto_wide_tocontents	1
			zpos 					3
			fontHeight				25
			xpos					0
			ypos					0
			"fgcolor_override"		"255 255 255 255"

			pin_to_sibling ServerNamePanel
			pin_corner_to_sibling CENTER
			pin_to_sibling_corner CENTER
		}

		ServerDescPanel
		{
			ControlName RuiPanel
			"classname"				"CreateServerUI"
			wide 480
			tall 50
			xpos 0
			ypos 5

			rui "ui/control_options_description.rpak"

			visible 1
			zpos 0

			pin_to_sibling			ServerNamePanel
			pin_corner_to_sibling	TOP
			pin_to_sibling_corner	BOTTOM
		}

		BtnServerDesc
		{
			ControlName RuiButton
			InheritProperties RuiSmallButton
			wide 480
			tall 50
			xpos 0
			ypos 0
			zpos 6
			classname			"createserverbuttons"
			"scriptID"					"4"


			pin_to_sibling ServerDescPanel
			pin_corner_to_sibling CENTER
			pin_to_sibling_corner CENTER
		}

		BtnServerDescTxT
		{
			ControlName				Label
			"classname"				"CreateServerUI"
			labelText				"Server Description"
			"font"					"DefaultBold_41"
			"allcaps"				"1"
			auto_wide_tocontents	1
			zpos 					3
			fontHeight				25
			xpos					0
			ypos					0
			"fgcolor_override"		"255 255 255 255"

			pin_to_sibling ServerDescPanel
			pin_corner_to_sibling CENTER
			pin_to_sibling_corner CENTER
		}

		MapPanel
		{
			ControlName RuiPanel
			"classname"				"CreateServerUI"
			wide 480
			tall 50
			xpos 0
			ypos 5

			rui "ui/control_options_description.rpak"

			visible 1
			zpos 0

			pin_to_sibling			ServerDescPanel
			pin_corner_to_sibling	TOP
			pin_to_sibling_corner	BOTTOM
		}

		BtnMap
		{
			ControlName RuiButton
			InheritProperties RuiSmallButton
			wide 480
			tall 50
			xpos 0
			ypos 0
			zpos 6
			classname			"createserverbuttons"
			"scriptID"					"0"


			pin_to_sibling MapPanel
			pin_corner_to_sibling CENTER
			pin_to_sibling_corner CENTER
		}

		BtnMapText
		{
			ControlName				Label
			"classname"				"CreateServerUI"
			labelText				"Select Map"
			"font"					"DefaultBold_41"
			"allcaps"				"1"
			auto_wide_tocontents	1
			zpos 					3
			fontHeight				25
			xpos					0
			ypos					0
			"fgcolor_override"		"255 255 255 255"

			pin_to_sibling MapPanel
			pin_corner_to_sibling CENTER
			pin_to_sibling_corner CENTER
		}

		PlaylistPanel
		{
			ControlName RuiPanel
			"classname"				"CreateServerUI"
			wide 480
			tall 50
			xpos 0
			ypos 5

			rui "ui/control_options_description.rpak"

			visible 1
			zpos 0

			pin_to_sibling			MapPanel
			pin_corner_to_sibling	TOP
			pin_to_sibling_corner	BOTTOM
		}

		BtnPlaylist
		{
			ControlName RuiButton
			InheritProperties RuiSmallButton
			wide 480
			tall 50
			xpos 0
			ypos 0
			zpos 6
			classname			"createserverbuttons"
			"scriptID"					"1"


			pin_to_sibling PlaylistPanel
			pin_corner_to_sibling CENTER
			pin_to_sibling_corner CENTER
		}

		BtnPlaylistText
		{
			ControlName				Label
			"classname"				"CreateServerUI"
			labelText				"Select Playlist"
			"font"					"DefaultBold_41"
			"allcaps"				"1"
			auto_wide_tocontents	1
			zpos 					3
			fontHeight				25
			xpos					0
			ypos					0
			"fgcolor_override"		"255 255 255 255"

			pin_to_sibling PlaylistPanel
			pin_corner_to_sibling CENTER
			pin_to_sibling_corner CENTER
		}

		VisPanel
		{
			ControlName RuiPanel
			"classname"				"CreateServerUI"
			wide 480
			tall 50
			xpos 0
			ypos 5

			rui "ui/control_options_description.rpak"

			visible 1
			zpos 0

			pin_to_sibling			PlaylistPanel
			pin_corner_to_sibling	TOP
			pin_to_sibling_corner	BOTTOM
		}

		BtnVis
		{
			ControlName RuiButton
			InheritProperties RuiSmallButton
			wide 480
			tall 50
			xpos 0
			ypos 0
			zpos 6
			classname			"createserverbuttons"
			"scriptID"					"2"


			pin_to_sibling VisPanel
			pin_corner_to_sibling CENTER
			pin_to_sibling_corner CENTER
		}

		BtnVisText
		{
			ControlName				Label
			"classname"				"CreateServerUI"
			labelText				"Select Visibility"
			"font"					"DefaultBold_41"
			"allcaps"				"1"
			auto_wide_tocontents	1
			zpos 					3
			fontHeight				25
			xpos					0
			ypos					0
			"fgcolor_override"		"255 255 255 255"

			pin_to_sibling VisPanel
			pin_corner_to_sibling CENTER
			pin_to_sibling_corner CENTER
		}

		"PlayersListTop"
		{
			ControlName				ImagePanel
			wide			490
			tall            40
			ypos            -20
			fillColor		"195 29 38 200"
			drawColor		"195 29 38 200"
			visible					1
			zpos					0
			pin_to_sibling				DarkenBackground
			pin_corner_to_sibling		TOP_RIGHT
			pin_to_sibling_corner		TOP_RIGHT
		}

		CurrentPlayersText
		{
			ControlName				Label
			labelText				"Current Players"
			"font"					"DefaultBold_41"
			"allcaps"				"1"
			auto_wide_tocontents	1
			zpos 					10
			fontHeight				25
			xpos					0
			ypos					0
			"fgcolor_override"		"255 255 255 255"

			pin_to_sibling PlayersListTop
			pin_corner_to_sibling CENTER
			pin_to_sibling_corner CENTER
		}

		PlayerList
		{
			ControlName				GridButtonListPanel
			xpos                    18
			ypos                    2
			columns                 1
			rows                    18
			buttonSpacing           6
			scrollbarSpacing        6
			scrollbarOnLeft         1
			visible					1
			tabPosition             1
			selectOnDpadNav         1

			ButtonSettings
			{
				rui                     "ui/generic_item_button.rpak"
				clipRui                 1
				wide					550
				tall					50
				cursorVelocityModifier  0.7
				rightClickEvents		1
				doubleClickEvents       1
				sound_focus             "UI_Menu_Focus_Small"
				sound_accept            ""
				sound_deny              ""
			}

			pin_to_sibling				PlayersListTop
			pin_corner_to_sibling		TOP_LEFT
			pin_to_sibling_corner		BOTTOM_LEFT
		}

		"R5RPlaylistPanel"
		{
			"ControlName"				"CNestedPanel"
			"ypos"						"-61"
			"xpos"                      "-520"
			"wide"						"490"
			"tall"						"560"
			"visible"					"0"
			"controlSettingsFile"		"scripts/resource/ui/menus/R5R/panels/playlist.res"
			"proportionalToParent"    	"1"
			"zpos"                      "10"

			"pin_to_sibling"          	"DarkenBackground"
			"pin_corner_to_sibling"		"TOP_LEFT"
			"pin_to_sibling_corner"		"TOP_LEFT"
		}

		"R5RMapPanel"
		{
			"ControlName"				"CNestedPanel"
			"ypos"						"-61"
			"xpos"                      "-520"
			"wide"						"490"
			"tall"						"560"
			"visible"					"0"
			"controlSettingsFile"		"scripts/resource/ui/menus/R5R/panels/map.res"
			"proportionalToParent"    	"1"
			"zpos"                      "10"

			"pin_to_sibling"          	"DarkenBackground"
			"pin_corner_to_sibling"		"TOP_LEFT"
			"pin_to_sibling_corner"		"TOP_LEFT"
		}

		"R5RVisPanel"
		{
			"ControlName"				"CNestedPanel"
			"ypos"						"-61"
			"xpos"                      "-520"
			"wide"						"500"
			"tall"						"220"
			"visible"					"1"
			"controlSettingsFile"		"scripts/resource/ui/menus/R5R/panels/visibility.res"
			"proportionalToParent"    	"1"
			"zpos"                      "10"

			"pin_to_sibling"          	"DarkenBackground"
			"pin_corner_to_sibling"		"TOP_LEFT"
			"pin_to_sibling_corner"		"TOP_LEFT"
		}
}
