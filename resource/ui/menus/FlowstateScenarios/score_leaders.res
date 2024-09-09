"platform/scripts/resource/ui/menus/FlowstateScenarios/score_leaders.res"
{
	//Screen
	//{
	//	ControlName		ImagePanel
	//	wide			%100
	//	tall			%100
	//}

	/////////////////////////////////////////////
	// 1
	//////////////////////////////////////////////
	
	Background
	{
		ControlName 			RuiPanel
		xpos					0
		ypos					0
		wide					266 //same as this CNest in parent
		tall					830 //same as this CNest in parent
		visible					1
		image 					"ui/menu/lobby/lobby_playlist_back_01"
		rui                     "ui/basic_border_box.rpak"
		scaleImage				1
	}
	
	//This can be offset to move the entire column and it's rows. ~mkos
	TopLine0
	{
		"ControlName"			"ImagePanel"
		"xpos"					"9"
		"ypos"					"8"
		"tall"					"2"
		"wide" 					"250"
		//"fillColor"				"84 84 84 200"
		//"drawColor"				"84 84 84 200"
		"//wrap"					"1"
		"zpos"					"3"
		
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}
	
	ScoreRow0
	{
		ControlName					"ImagePanel"
		wide						"250"
		tall						"80"
		"fillColor"					"36 36 36 200"
		"drawColor"					"36 36 36 200"
		
		pin_to_sibling				TopLine0
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}
	
	PlayerPlaceRow0
	{
		ControlName					"Label"
		labelText					"#1"
		xpos						"-10"
		ypos						"-25"
		wide						"35"
		tall						"30"
		fontHeight					"30"
		
		pin_to_sibling				ScoreRow0
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}
	
	PlayerNameRow0
	{
		ControlName					Label
		labelText					""
		textAlignment				center
		fgcolor_override			"113 148 193 255"
		xpos						0
		ypos						-5
		wide						250
		tall						30
		fontHeight					30
		
		pin_to_sibling				ScoreRow0
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}
	
	PlayerScoreRow0
	{
		ControlName					Label
		labelText					"673733"
		textAlignment				center
		fgcolor_override			"255 255 255 200"
		xpos						0
		ypos						-30
		wide						250
		tall						50
		fontHeight					50
		font						DefaultBold_17
		
		pin_to_sibling				ScoreRow0
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}

	//////////////////////////////////////////////
	// 2
	//////////////////////////////////////////////

	TopLine1
	{
		"ControlName"			"ImagePanel"
		"xpos"					"0"
		"ypos"					"0"
		"tall"					"2"
		"wide" 					"250"
		"fillColor"				"84 84 84 200"
		"drawColor"				"84 84 84 200"
		"//wrap"					"1"
		"zpos"					"3"
		
		pin_to_sibling				PlayerScoreRow0
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}
	
	ScoreRow1
	{
		ControlName					"ImagePanel"
		wide						"250"
		tall						"80"
		"fillColor"					"23 23 23 200"
		"drawColor"					"23 23 23 200"
		
		pin_to_sibling				TopLine1
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}
	
	PlayerPlaceRow1
	{
		ControlName					"Label"
		labelText					"#2"
		xpos						"-10"
		ypos						"-25"
		wide						"35"
		tall						"30"
		fontHeight					"30"
		
		pin_to_sibling				ScoreRow1
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}
	
	PlayerNameRow1
	{
		ControlName					Label
		labelText					""
		textAlignment				center
		fgcolor_override			"113 148 193 255"
		xpos						0
		ypos						-5
		wide						250
		tall						30
		fontHeight					30
		
		pin_to_sibling				ScoreRow1
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}
	
	PlayerScoreRow1
	{
		ControlName					Label
		labelText					"673733"
		textAlignment				center
		fgcolor_override			"255 255 255 200"
		xpos						0
		ypos						-30
		wide						250
		tall						50
		fontHeight					50
		font						DefaultBold_17
		
		pin_to_sibling				ScoreRow1
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}

	//////////////////////////////////////////////
	// 3
	//////////////////////////////////////////////
	
	TopLine2
	{
		"ControlName"			"ImagePanel"
		"xpos"					"0"
		"ypos"					"0"
		"tall"					"2"
		"wide" 					"250"
		"fillColor"				"84 84 84 200"
		"drawColor"				"84 84 84 200"
		"//wrap"					"1"
		"zpos"					"3"
		
		pin_to_sibling				PlayerScoreRow1
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}
	
	ScoreRow2
	{
		ControlName					"ImagePanel"
		wide						"250"
		tall						"80"
		"fillColor"					"36 36 36 200"
		"drawColor"					"36 36 36 200"
		
		pin_to_sibling				TopLine2
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}
	
	PlayerPlaceRow2
	{
		ControlName					"Label"
		labelText					"#3"
		xpos						"-10"
		ypos						"-25"
		wide						"35"
		tall						"30"
		fontHeight					"30"
		
		pin_to_sibling				ScoreRow2
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}
	
	PlayerNameRow2
	{
		ControlName					Label
		labelText					""
		textAlignment				center
		fgcolor_override			"113 148 193 255"
		xpos						0
		ypos						-5
		wide						250
		tall						30
		fontHeight					30
		
		pin_to_sibling				ScoreRow2
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}
	
	PlayerScoreRow2
	{
		ControlName					Label
		labelText					"673733"
		textAlignment				center
		fgcolor_override			"255 255 255 200"
		xpos						0
		ypos						-30
		wide						250
		tall						50
		fontHeight					50
		font						DefaultBold_17
		
		pin_to_sibling				ScoreRow2
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}

	//////////////////////////////////////////////
	// 4
	//////////////////////////////////////////////

	TopLine3
	{
		"ControlName"			"ImagePanel"
		"xpos"					"0"
		"ypos"					"0"
		"tall"					"2"
		"wide" 					"250"
		"fillColor"				"84 84 84 200"
		"drawColor"				"84 84 84 200"
		"//wrap"					"1"
		"zpos"					"3"
		
		pin_to_sibling				PlayerScoreRow2
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}
	
	ScoreRow3
	{
		ControlName					"ImagePanel"
		wide						"250"
		tall						"80"
		"fillColor"					"23 23 23 200"
		"drawColor"					"23 23 23 200"
		
		pin_to_sibling				TopLine3
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}
	
	PlayerPlaceRow3
	{
		ControlName					"Label"
		labelText					"#4"
		xpos						"-10"
		ypos						"-25"
		wide						"35"
		tall						"30"
		fontHeight					"30"
		
		pin_to_sibling				ScoreRow3
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}
	
	PlayerNameRow3
	{
		ControlName					Label
		labelText					""
		textAlignment				center
		fgcolor_override			"113 148 193 255"
		xpos						0
		ypos						-5
		wide						250
		tall						30
		fontHeight					30
		
		pin_to_sibling				ScoreRow3
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}
	
	PlayerScoreRow3
	{
		ControlName					Label
		labelText					"673733"
		textAlignment				center
		fgcolor_override			"255 255 255 200"
		xpos						0
		ypos						-30
		wide						250
		tall						50
		fontHeight					50
		font						DefaultBold_17
		
		pin_to_sibling				ScoreRow3
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}

	//////////////////////////////////////////////
	// 5
	//////////////////////////////////////////////
	
	TopLine4
	{
		"ControlName"			"ImagePanel"
		"xpos"					"0"
		"ypos"					"0"
		"tall"					"2"
		"wide" 					"250"
		"fillColor"				"84 84 84 200"
		"drawColor"				"84 84 84 200"
		"//wrap"					"1"
		"zpos"					"3"
		
		pin_to_sibling				PlayerScoreRow3
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}
	
	ScoreRow4
	{
		ControlName					"ImagePanel"
		wide						"250"
		tall						"80"
		"fillColor"					"36 36 36 200"
		"drawColor"					"36 36 36 200"
		
		pin_to_sibling				TopLine4
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}
	
	PlayerPlaceRow4
	{
		ControlName					"Label"
		labelText					"#5"
		xpos						"-10"
		ypos						"-25"
		wide						"35"
		tall						"30"
		fontHeight					"30"
		
		pin_to_sibling				ScoreRow4
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}
	
	PlayerNameRow4
	{
		ControlName					Label
		labelText					""
		textAlignment				center
		fgcolor_override			"113 148 193 255"
		xpos						0
		ypos						-5
		wide						250
		tall						30
		fontHeight					30
		
		pin_to_sibling				ScoreRow4
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}
	
	PlayerScoreRow4
	{
		ControlName					Label
		labelText					"673733"
		textAlignment				center
		fgcolor_override			"255 255 255 200"
		xpos						0
		ypos						-30
		wide						250
		tall						50
		fontHeight					50
		font						DefaultBold_17
		
		pin_to_sibling				ScoreRow4
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}

	//////////////////////////////////////////////
	// 6
	//////////////////////////////////////////////

	TopLine5
	{
		"ControlName"			"ImagePanel"
		"xpos"					"0"
		"ypos"					"0"
		"tall"					"2"
		"wide" 					"250"
		"fillColor"				"84 84 84 200"
		"drawColor"				"84 84 84 200"
		"//wrap"					"1"
		"zpos"					"3"
		
		pin_to_sibling				PlayerScoreRow4
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}
	
	ScoreRow5
	{
		ControlName					"ImagePanel"
		wide						"250"
		tall						"80"
		"fillColor"					"23 23 23 200"
		"drawColor"					"23 23 23 200"
		
		pin_to_sibling				TopLine5
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}
	
	PlayerPlaceRow5
	{
		ControlName					"Label"
		labelText					"#6"
		xpos						"-10"
		ypos						"-25"
		wide						"35"
		tall						"30"
		fontHeight					"30"
		
		pin_to_sibling				ScoreRow5
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}
	
	PlayerNameRow5
	{
		ControlName					Label
		labelText					""
		textAlignment				center
		fgcolor_override			"113 148 193 255"
		xpos						0
		ypos						-5
		wide						250
		tall						30
		fontHeight					30
		
		pin_to_sibling				ScoreRow5
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}
	
	PlayerScoreRow5
	{
		ControlName					Label
		labelText					"673733"
		textAlignment				center
		fgcolor_override			"255 255 255 200"
		xpos						0
		ypos						-30
		wide						250
		tall						50
		fontHeight					50
		font						DefaultBold_17
		
		pin_to_sibling				ScoreRow5
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}

	//////////////////////////////////////////////
	// 7
	//////////////////////////////////////////////
	
	TopLine6
	{
		"ControlName"			"ImagePanel"
		"xpos"					"0"
		"ypos"					"0"
		"tall"					"2"
		"wide" 					"250"
		"fillColor"				"84 84 84 200"
		"drawColor"				"84 84 84 200"
		"//wrap"					"1"
		"zpos"					"3"
		
		pin_to_sibling				PlayerScoreRow5
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}
	
	ScoreRow6
	{
		ControlName					"ImagePanel"
		wide						"250"
		tall						"80"
		"fillColor"					"36 36 36 200"
		"drawColor"					"36 36 36 200"
		
		pin_to_sibling				TopLine6
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}
	
	PlayerPlaceRow6
	{
		ControlName					"Label"
		labelText					"#7"
		xpos						"-10"
		ypos						"-25"
		wide						"35"
		tall						"30"
		fontHeight					"30"
		
		pin_to_sibling				ScoreRow6
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}
	
	PlayerNameRow6
	{
		ControlName					Label
		labelText					""
		textAlignment				center
		fgcolor_override			"113 148 193 255"
		xpos						0
		ypos						-5
		wide						250
		tall						30
		fontHeight					30
		
		pin_to_sibling				ScoreRow6
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}
	
	PlayerScoreRow6
	{
		ControlName					Label
		labelText					"673733"
		textAlignment				center
		fgcolor_override			"255 255 255 200"
		xpos						0
		ypos						-30
		wide						250
		tall						50
		fontHeight					50
		font						DefaultBold_17
		
		pin_to_sibling				ScoreRow6
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}

	//////////////////////////////////////////////
	// 8
	//////////////////////////////////////////////
	
	TopLine7
	{
		"ControlName"			"ImagePanel"
		"xpos"					"0"
		"ypos"					"0"
		"tall"					"2"
		"wide" 					"250"
		"fillColor"				"84 84 84 200"
		"drawColor"				"84 84 84 200"
		"//wrap"					"1"
		"zpos"					"3"
		
		pin_to_sibling				PlayerScoreRow6
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}
	
	ScoreRow7
	{
		ControlName					"ImagePanel"
		wide						"250"
		tall						"80"
		"fillColor"					"23 23 23 200"
		"drawColor"					"23 23 23 200"
		
		pin_to_sibling				TopLine7
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}
	
	PlayerPlaceRow7
	{
		ControlName					"Label"
		labelText					"#8"
		xpos						"-10"
		ypos						"-25"
		wide						"35"
		tall						"30"
		fontHeight					"30"
		
		pin_to_sibling				ScoreRow7
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}
	
	PlayerNameRow7
	{
		ControlName					Label
		labelText					""
		textAlignment				center
		fgcolor_override			"113 148 193 255"
		xpos						0
		ypos						-5
		wide						250
		tall						30
		fontHeight					30
		
		pin_to_sibling				ScoreRow7
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}
	
	PlayerScoreRow7
	{
		ControlName					Label
		labelText					"673733"
		textAlignment				center
		fgcolor_override			"255 255 255 200"
		xpos						0
		ypos						-30
		wide						250
		tall						50
		fontHeight					50
		font						DefaultBold_17
		
		pin_to_sibling				ScoreRow7
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}

	//////////////////////////////////////////////
	// 9
	//////////////////////////////////////////////
	
	TopLine8
	{
		"ControlName"			"ImagePanel"
		"xpos"					"0"
		"ypos"					"0"
		"tall"					"2"
		"wide" 					"250"
		"fillColor"				"84 84 84 200"
		"drawColor"				"84 84 84 200"
		"//wrap"					"1"
		"zpos"					"3"
		
		pin_to_sibling				PlayerScoreRow7
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}
	
	ScoreRow8
	{
		ControlName					"ImagePanel"
		wide						"250"
		tall						"80"
		"fillColor"					"36 36 36 200"
		"drawColor"					"36 36 36 200"
		
		pin_to_sibling				TopLine8
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}
	
	PlayerPlaceRow8
	{
		ControlName					"Label"
		labelText					"#9"
		xpos						"-10"
		ypos						"-25"
		wide						"35"
		tall						"30"
		fontHeight					"30"
		
		pin_to_sibling				ScoreRow8
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}
	
	PlayerNameRow8
	{
		ControlName					Label
		labelText					""
		textAlignment				center
		fgcolor_override			"113 148 193 255"
		xpos						0
		ypos						-5
		wide						250
		tall						30
		fontHeight					30
		
		pin_to_sibling				ScoreRow8
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}
	
	PlayerScoreRow8
	{
		ControlName					Label
		labelText					"673733"
		textAlignment				center
		fgcolor_override			"255 255 255 200"
		xpos						0
		ypos						-30
		wide						250
		tall						50
		fontHeight					50
		font						DefaultBold_17
		
		pin_to_sibling				ScoreRow8
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}
	
	//////////////////////////////////////////////
	// 10
	//////////////////////////////////////////////
	
	TopLine9
	{
		"ControlName"			"ImagePanel"
		"xpos"					"0"
		"ypos"					"0"
		"tall"					"2"
		"wide" 					"250"
		"fillColor"				"84 84 84 200"
		"drawColor"				"84 84 84 200"
		"//wrap"					"1"
		"zpos"					"3"
		
		pin_to_sibling				PlayerScoreRow8
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}

	ScoreRow9
	{
		ControlName					"ImagePanel"
		wide						"250"
		tall						"80"
		"fillColor"					"23 23 23 200"
		"drawColor"					"23 23 23 200"
		
		pin_to_sibling				TopLine9
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}
	
	PlayerPlaceRow9
	{
		ControlName					"Label"
		labelText					"#10"
		xpos						"-10"
		ypos						"-25"
		wide						"35"
		tall						"30"
		fontHeight					"30"
		
		pin_to_sibling				ScoreRow9
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}
	
	PlayerNameRow9
	{
		ControlName					Label
		labelText					""
		textAlignment				center
		fgcolor_override			"113 148 193 255"
		xpos						0
		ypos						-5
		wide						250
		tall						30
		fontHeight					30
		
		pin_to_sibling				ScoreRow9
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}
	
	PlayerScoreRow9
	{
		ControlName					Label
		labelText					"673733"
		textAlignment				center
		fgcolor_override			"255 255 255 200"
		xpos						0
		ypos						-30
		wide						250
		tall						50
		fontHeight					50
		font						DefaultBold_17
		
		pin_to_sibling				ScoreRow9
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}
}
