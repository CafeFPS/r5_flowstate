"Resource/UI/HudScoreboard.res"
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

	ScoreboardGametypeAndMap
	{
		ControlName				RuiPanel
		pin_to_sibling			Screen
		pin_corner_to_sibling	TOP_CENTER
		pin_to_sibling_corner	TOP_CENTER
		xpos 					-700
		ypos					-176
		zpos					1012
		wide					513
		tall					50
		visible					1

		scaleImage			1
		rui					"ui/scoreboard_title_mp.rpak"
	}
	ScoreboardHeaderGametypeDesc
	{
		ControlName				RuiPanel
		pin_to_sibling			ScoreboardGametypeAndMap
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		zpos					1012
		wide					513
		tall					80
		visible					1

		scaleImage			1
		rui					"ui/scoreboard_subtitle_mp.rpak"
	}

	// My team info
	ScoreboardMyTeamLogo
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardTeamLogo
		xpos					114
		pin_to_sibling			ScoreboardHeaderGametypeDesc
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardMyTeamScore
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardTeamScore
		pin_to_sibling			ScoreboardMyTeamLogo
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}

	// Enemy team info
	ScoreboardEnemyTeam1Logo
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardTeamLogo
		xpos					114
		pin_to_sibling			ScoreboardHeaderGametypeDesc
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardEnemyTeam1Score
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardTeamScore
		pin_to_sibling			ScoreboardEnemyTeam1Logo
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}

	ScoreboardScoreHeader
	{
		ControlName				RuiPanel
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		xpos					0
		pin_to_sibling			ScoreboardHeaderGametypeDesc
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	BOTTOM_RIGHT
		visible					1
		xpos					0
		ypos					0
		tall					135
		wide					780
		rui						"ui/score_header.rpak"
		zpos					2000
	}

	// Friendly players
	ScoreboardTeammateBackground0
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardMyTeamLogo
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		xpos					153
		ypos					12
	}
	ScoreboardTeammateBackground1
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardTeammateBackground0
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardTeammateBackground2
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardTeammateBackground1
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardTeammateBackground3
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardTeammateBackground2
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardTeammateBackground4
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardTeammateBackground3
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardTeammateBackground5
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardTeammateBackground4
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardTeammateBackground6
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardTeammateBackground5
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardTeammateBackground7
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardTeammateBackground6
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardTeammateBackground8
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardTeammateBackground7
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardTeammateBackground9
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardTeammateBackground8
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardTeammateBackground10
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardTeammateBackground9
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardTeammateBackground11
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardTeammateBackground10
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardTeammateBackground12
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardTeammateBackground11
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardTeammateBackground13
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardTeammateBackground12
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardTeammateBackground14
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardTeammateBackground13
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardTeammateBackground15
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardTeammateBackground14
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardTeammateBackground16
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardTeammateBackground15
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardTeammateBackground17
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardTeammateBackground16
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardTeammateBackground18
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardTeammateBackground17
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardTeammateBackground19
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardTeammateBackground18
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}

	// Enemy players
	ScoreboardOpponentTeam1Background0
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardEnemyTeam1Logo
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		xpos					153
		ypos					12
	}
	ScoreboardOpponentTeam1Background1
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardOpponentTeam1Background0
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardOpponentTeam1Background2
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardOpponentTeam1Background1
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardOpponentTeam1Background3
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardOpponentTeam1Background2
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardOpponentTeam1Background4
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardOpponentTeam1Background3
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardOpponentTeam1Background5
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardOpponentTeam1Background4
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardOpponentTeam1Background6
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardOpponentTeam1Background5
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardOpponentTeam1Background7
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardOpponentTeam1Background6
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardOpponentTeam1Background8
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardOpponentTeam1Background7
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardOpponentTeam1Background9
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardOpponentTeam1Background8
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardOpponentTeam1Background10
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardOpponentTeam1Background9
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardOpponentTeam1Background11
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardOpponentTeam1Background10
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardOpponentTeam1Background12
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardOpponentTeam1Background11
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardOpponentTeam1Background13
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardOpponentTeam1Background12
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardOpponentTeam1Background14
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardOpponentTeam1Background13
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardOpponentTeam1Background15
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardOpponentTeam1Background14
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardOpponentTeam1Background16
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardOpponentTeam1Background15
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardOpponentTeam1Background17
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardOpponentTeam1Background16
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardOpponentTeam1Background18
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardOpponentTeam1Background17
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardOpponentTeam1Background19
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardOpponentTeam1Background18
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}

	// Enemy team info
	ScoreboardEnemyTeam2Logo
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardTeamLogo
		xpos					114
		pin_to_sibling			ScoreboardHeaderGametypeDesc
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardEnemyTeam2Score
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardTeamScore
		pin_to_sibling			ScoreboardEnemyTeam2Logo
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}

	//Limiting to Team size of 5 for now to avoid adding too many elements

	ScoreboardOpponentTeam2Background0
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardEnemyTeam2Logo
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		xpos					153
		ypos					12
	}
	ScoreboardOpponentTeam2Background1
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardOpponentTeam2Background0
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardOpponentTeam2Background2
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardOpponentTeam2Background1
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardOpponentTeam2Background3
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardOpponentTeam2Background2
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardOpponentTeam2Background4
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardOpponentTeam2Background3
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardOpponentTeam2Background5
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardOpponentTeam2Background4
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}

	ScoreboardEnemyTeam3Logo
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardTeamLogo
		xpos					114
		pin_to_sibling			ScoreboardHeaderGametypeDesc
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardEnemyTeam3Score
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardTeamScore
		pin_to_sibling			ScoreboardEnemyTeam3Logo
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}

	//Limiting to Team size of 5 for now to avoid adding too many elements

	ScoreboardOpponentTeam3Background0
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardEnemyTeam3Logo
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		xpos					153
		ypos					12
	}
	ScoreboardOpponentTeam3Background1
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardOpponentTeam3Background0
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardOpponentTeam3Background2
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardOpponentTeam3Background1
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardOpponentTeam3Background3
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardOpponentTeam3Background2
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardOpponentTeam3Background4
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardOpponentTeam3Background3
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardOpponentTeam3Background5
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardOpponentTeam3Background4
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}

	ScoreboardEnemyTeam4Logo
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardTeamLogo
		xpos					114
		pin_to_sibling			ScoreboardHeaderGametypeDesc
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardEnemyTeam4Score
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardTeamScore
		pin_to_sibling			ScoreboardEnemyTeam4Logo
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}

	//Limiting to Team size of 5 for now to avoid adding too many elements

	ScoreboardOpponentTeam4Background0
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardEnemyTeam4Logo
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		xpos					153
		ypos					12
	}
	ScoreboardOpponentTeam4Background1
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardOpponentTeam4Background0
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardOpponentTeam4Background2
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardOpponentTeam4Background1
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardOpponentTeam4Background3
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardOpponentTeam4Background2
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardOpponentTeam4Background4
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardOpponentTeam4Background3
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardOpponentTeam4Background5
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardOpponentTeam4Background4
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}



	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	ScoreboardBadRepPresentMessage
	{
		ControlName				Label
		pin_to_sibling 			ScoreboardBackground
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		ypos 					4
		auto_wide_tocontents	1
		auto_tall_tocontents	1
		visible 				0
		font 					Default_28_ShadowGlow
		labelText				""
		fgcolor_override 		"255 50 50 255"
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	ScoreboardPingText
	{
		ControlName				RuiPanel
		pin_to_sibling			ScoreboardGamepadFooter
		pin_corner_to_sibling	BOTTOM
		pin_to_sibling_corner	TOP
		ypos 					0
		wide					513
		tall					35
		visible 				1
		rui						"ui/scoreboard_ping.rpak"
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	ScoreboardGamepadFooter
	{
		ControlName				RuiPanel
		pin_to_sibling			ScoreboardHeaderGametypeDesc
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		ypos 					580
		wide					513
		tall					35
		visible 				1
		rui						"ui/scoreboard_footer.rpak"
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}
