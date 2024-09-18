"resource/ui/menus/panels/match_info.res"
{
	Background
	{
		ControlName 			RuiPanel
		wide					780
		tall					230
		visible					1
		image 					"ui/menu/lobby/lobby_playlist_back_01"
		scaleImage				1
        rui                     "ui/basic_border_box.rpak"
 	}

	Match
	{
		ControlName				Label
		ypos					5
		wide					770
		tall					35
		textAlignment		    center
		visible					1
		labelText				"#PARTY_IN_MATCH"
		font 					Default_33
		fgcolor_override	    "254 184 0 255"
	}

	PlaylistLabel
	{
		ControlName				Label
		pin_to_sibling				Match
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			BOTTOM_LEFT
		tall 					30
		labelText				"#PLAYLIST_LABEL"
		wide					200
		font					Default_27
		textinsetx				11
		textinsety				1
		allcaps					1
		visible					1
		textAlignment				"east"
		fgcolor_override			"255 255 255 255"
	}

	PlaylistName
	{
		ControlName				Label
		pin_to_sibling				PlaylistLabel
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			TOP_RIGHT
		wide					250
		tall					30
		visible					1
		font 					Default_27
	}

	MapLabel
	{
		ControlName				Label
		pin_to_sibling				PlaylistLabel
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			BOTTOM_LEFT
		tall 					30
		labelText				"#MAP_LABEL"
		wide					200
		font					Default_27
		textinsetx				11
		textinsety				1
		allcaps					1
		visible					1
		textAlignment				"east"
		fgcolor_override			"255 255 255 255"
	}

	MapName
	{
		ControlName				Label
		pin_to_sibling				MapLabel
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			TOP_RIGHT
		wide					250
		tall					30
		visible					1
		font 					Default_27
	}

	ModeLabel
	{
		ControlName				Label
		pin_to_sibling				MapLabel
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			BOTTOM_LEFT
		tall 					30
		labelText				"#MODE_LABEL"
		wide					200
		font					Default_27
		textinsetx				11
		textinsety				1
		allcaps					1
		visible					1
		textAlignment				"east"
		fgcolor_override			"255 255 255 255"
	}

	ModeName
	{
		ControlName				Label
		pin_to_sibling				ModeLabel
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			TOP_RIGHT
		wide					250
		tall					30
		visible					1
		font 					Default_27
	}

	TimeLeftLabel
	{
		ControlName				Label
		pin_to_sibling				ModeLabel
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			BOTTOM_LEFT
		tall 					30
		labelText				"#TIME_LEFT_LABEL"
		wide					200
		font					Default_27
		textinsetx				11
		textinsety				1
		allcaps					1
		visible					1
		textAlignment				"east"
		fgcolor_override			"255 255 255 255"
	}

	TimeLeft
	{
		ControlName				Label
		pin_to_sibling				TimeLeftLabel
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			TOP_RIGHT
		wide					250
		tall					30
		visible					1
		font 					Default_27
	}

	ScoreLimitLabel
	{
		ControlName				Label
		pin_to_sibling				TimeLeftLabel
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			BOTTOM_LEFT
		tall 					30
		labelText				"#SCORE_LIMIT_LABEL"
		wide					200
		font					Default_27
		textinsetx				11
		textinsety				1
		allcaps					1
		visible					1
		textAlignment				"east"
		fgcolor_override			"255 255 255 255"
	}

	ScoreLimit
	{
		ControlName				Label
		pin_to_sibling				ScoreLimitLabel
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			TOP_RIGHT
		wide					250
		tall					30
		visible					1
		font 					Default_27
	}

	Team1ScoreLabel
	{
		ControlName				Label
		pin_to_sibling				ScoreLimitLabel
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			BOTTOM_LEFT
		tall 					30
		labelText				"#TEAM1_SCORE_LABEL"
		wide					200
		font					Default_27
		textinsetx				11
		textinsety				1
		allcaps					1
		visible					1
		textAlignment				"east"
		fgcolor_override			"255 255 255 255"
	}

	Team1Score
	{
		ControlName				Label
		pin_to_sibling				Team1ScoreLabel
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			TOP_RIGHT
		wide					80
		tall					30
		visible					1
		font 					Default_27
	}

	Team1Player1
	{
		ControlName				CNestedPanel
		pin_to_sibling				Team1ScoreLabel
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			BOTTOM_LEFT
		wide					390
		tall					30
		xpos					-10
		visible					0
		controlSettingsFile			"resource/ui/menus/panels/match_info_player.res"
	}

	Team1Player2
	{
		ControlName				CNestedPanel
		pin_to_sibling				Team1Player1
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			BOTTOM_LEFT
		wide					390
		tall					30
		visible					0
		controlSettingsFile			"resource/ui/menus/panels/match_info_player.res"
	}

	Team1Player3
	{
		ControlName				CNestedPanel
		pin_to_sibling				Team1Player2
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			BOTTOM_LEFT
		wide					390
		tall					30
		visible					0
		controlSettingsFile			"resource/ui/menus/panels/match_info_player.res"
	}

	Team1Player4
	{
		ControlName				CNestedPanel
		pin_to_sibling				Team1Player3
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			BOTTOM_LEFT
		wide					390
		tall					30
		visible					0
		controlSettingsFile			"resource/ui/menus/panels/match_info_player.res"
	}

	Team1Player5
	{
		ControlName				CNestedPanel
		pin_to_sibling				Team1Player4
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			BOTTOM_LEFT
		wide					390
		tall					30
		visible					0
		controlSettingsFile			"resource/ui/menus/panels/match_info_player.res"
	}

	Team1Player6
	{
		ControlName				CNestedPanel
		pin_to_sibling				Team1Player5
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			BOTTOM_LEFT
		wide					390
		tall					30
		visible					0
		controlSettingsFile			"resource/ui/menus/panels/match_info_player.res"
	}

	Team1Player7
	{
		ControlName				CNestedPanel
		pin_to_sibling				Team1Player6
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			BOTTOM_LEFT
		wide					390
		tall					30
		visible					0
		controlSettingsFile			"resource/ui/menus/panels/match_info_player.res"
	}

	Team1Player8
	{
		ControlName				CNestedPanel
		pin_to_sibling				Team1Player7
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			BOTTOM_LEFT
		wide					390
		tall					30
		visible					0
		controlSettingsFile			"resource/ui/menus/panels/match_info_player.res"
	}

// TEAM 2


	Team2ScoreLabel
	{
		ControlName				Label
		pin_to_sibling				Team1Score
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			TOP_RIGHT
		xpos					100
		tall 					30
		labelText				"#TEAM2_SCORE_LABEL"
		wide					200
		font					Default_27
		textinsetx				11
		textinsety				1
		allcaps					1
		visible					1
		textAlignment				"east"
		fgcolor_override			"255 255 255 255"
	}

	Team2Score
	{
		ControlName				Label
		pin_to_sibling				Team2ScoreLabel
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			TOP_RIGHT
		wide					80
		tall					30
		visible					1
		font 					Default_27
	}

	Team2Player1
	{
		ControlName				CNestedPanel
		pin_to_sibling				Team2ScoreLabel
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			BOTTOM_LEFT
		wide					390
		tall					30
		xpos					-10
		visible					0
		controlSettingsFile			"resource/ui/menus/panels/match_info_player.res"
	}

	Team2Player2
	{
		ControlName				CNestedPanel
		pin_to_sibling				Team2Player1
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			BOTTOM_LEFT
		wide					390
		tall					30
		visible					0
		controlSettingsFile			"resource/ui/menus/panels/match_info_player.res"
	}

	Team2Player3
	{
		ControlName				CNestedPanel
		pin_to_sibling				Team2Player2
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			BOTTOM_LEFT
		wide					390
		tall					30
		visible					0
		controlSettingsFile			"resource/ui/menus/panels/match_info_player.res"
	}

	Team2Player4
	{
		ControlName				CNestedPanel
		pin_to_sibling				Team2Player3
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			BOTTOM_LEFT
		wide					390
		tall					30
		visible					0
		controlSettingsFile			"resource/ui/menus/panels/match_info_player.res"
	}

	Team2Player5
	{
		ControlName				CNestedPanel
		pin_to_sibling				Team2Player4
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			BOTTOM_LEFT
		wide					390
		tall					30
		visible					0
		controlSettingsFile			"resource/ui/menus/panels/match_info_player.res"
	}

	Team2Player6
	{
		ControlName				CNestedPanel
		pin_to_sibling				Team2Player5
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			BOTTOM_LEFT
		wide					390
		tall					30
		visible					0
		controlSettingsFile			"resource/ui/menus/panels/match_info_player.res"
	}

	Team2Player7
	{
		ControlName				CNestedPanel
		pin_to_sibling				Team2Player6
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			BOTTOM_LEFT
		wide					390
		tall					30
		visible					0
		controlSettingsFile			"resource/ui/menus/panels/match_info_player.res"
	}

	Team2Player8
	{
		ControlName				CNestedPanel
		pin_to_sibling				Team2Player7
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			BOTTOM_LEFT
		wide					390
		tall					30
		visible					0
		controlSettingsFile			"resource/ui/menus/panels/match_info_player.res"
	}

}
