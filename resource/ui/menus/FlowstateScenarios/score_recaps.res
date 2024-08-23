"platform/scripts/resource/ui/menus/FlowstateScenarios/score_recaps.res"
{
	//Screen
	//{
	//	ControlName		ImagePanel
	//	wide			%100
	//	tall			%100
	//}
	
	////////////////
	// DISCLAIMER //
	////////////////
	// The number in the Names of Elements are used by the script to 
	// auto correlate enum fields with their display counterpart.
	// They must match the enum value for FS_ScoreTypes for their field.
	
	
	Background
	{
		ControlName 			RuiPanel
		xpos					0
		ypos					0
		wide					1064 //same as this CNest in parent
		tall					830 //same as this CNest in parent
		visible					1
		image 					"ui/menu/lobby/lobby_playlist_back_01"
		rui                     "ui/basic_border_box.rpak"
		scaleImage				1
	}
	
	
	/////////////////////////////////////////////
	// Buttons
	/////////////////////////////////////////////
	
	
	PreviousRoundButton
	{
		ControlName				RuiButton
		classname               MenuButton
		wide					324
		tall					60
		ypos                    -20
		xpos					-210
		rui                     "ui/generic_popup_button.rpak"
		labelText               ""
		visible					1
		cursorVelocityModifier  0.7

		ruiArgs
		{
			buttonText          "#FS_PREVIOUS_ROUND"
			solidBackground     1
			isSelected			1
		}

		//proportionalToParent    1

		pin_to_sibling			Background
		pin_corner_to_sibling	TOP
		pin_to_sibling_corner	TOP
	}
	
	
	AllRoundsButton
	{
		ControlName				RuiButton
		classname               MenuButton
		wide					324
		tall					60
		ypos                    -20
		xpos					210
		rui                     "ui/generic_popup_button.rpak"
		labelText               ""
		visible					1
		cursorVelocityModifier  0.7

		ruiArgs
		{
			buttonText          "#FS_ALL_ROUNDS"
			solidBackground     0
			isSelected			0
		}

		//proportionalToParent    1

		pin_to_sibling			Background
		pin_corner_to_sibling	TOP
		pin_to_sibling_corner	TOP
	}
	
	
	/////////////////////////////////////////////
	// Table Lines
	/////////////////////////////////////////////
	
	
	TopLine
	{
		ControlName				ImagePanel
		xpos					-16
		ypos					-100
		tall					2
		wide 					1034 //Slightly less than this->CNest container
		fillColor				"84 84 84 200"
		drawColor				"84 84 84 200"
		//wrap					1
		zpos					3
		
		pin_to_sibling			Background
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}
	
	BottomLine
	{
		ControlName				ImagePanel
		xpos					-16
		ypos					-20
		tall					2
		wide 					1034 //Slightly less than this->CNest container
		fillColor				"84 84 84 200"
		drawColor				"84 84 84 200"
		//wrap					1
		zpos					3
		
		pin_to_sibling			Background
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	
	LeftLine
	{
		ControlName				ImagePanel
		xpos					-16
		ypos					-20
		tall					710 //Slightly less than this->CNest container
		wide 					2 
		fillColor				"84 84 84 200"
		drawColor				"84 84 84 200"
		//wrap					1
		zpos					3
		
		pin_to_sibling			Background
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	
	RightLine
	{
		ControlName				ImagePanel
		xpos					-14
		ypos					-20
		tall					710 //Slightly less than this->CNest container
		wide 					2 
		fillColor				"84 84 84 200"
		drawColor				"84 84 84 200"
		//wrap					1
		zpos					3
		
		pin_to_sibling			Background
		pin_corner_to_sibling	BOTTOM_RIGHT
		pin_to_sibling_corner	BOTTOM_RIGHT
	}
	
	
	/////////////////////////////////////////////
	// Table Columns -all rows pinned to each col
	/////////////////////////////////////////////
	
	
	ColumnStat
	{
		ControlName					"ImagePanel"
		wide						"344"
		tall						"710"
		"fillColor"					"36 36 36 200"
		"drawColor"					"36 36 36 200"
		
		pin_to_sibling				TopLine
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}
	
	ColumnScore
	{
		xpos						-344
		ControlName					"ImagePanel"
		wide						"344"
		tall						"710"
		"fillColor"					"46 46 46 200"
		"drawColor"					"46 46 46 200"
		
		pin_to_sibling				TopLine
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}
	
	ColumnTotals
	{
		xpos						-688
		ControlName					"ImagePanel"
		wide						"344"
		tall						"710"
		"fillColor"					"36 36 36 200"
		"drawColor"					"36 36 36 200"
		
		pin_to_sibling				TopLine
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}
	
	
	/////////////////////////////////////////////
	// Table Rows -all rows pinned to each col
	/////////////////////////////////////////////
	
	
	///////////////
	// Stat rows //////////////////////////////////
	///////////////
	
	StatRowTitle //stat title
	{
		ControlName					Label
		labelText					"#FS_STAT"
		wide						344
		tall						70
		fontHeight					50
		textAlignment				center
		fgcolor_override			"255 127 39 200"	
		bgcolor_override			"23 23 23 200"
		paintbackground				1
		
		pin_to_sibling				ColumnStat
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}
	
	StatRow2 //kills
	{
		ControlName					Label
		labelText					"#FS_KILLS"
		wide						344
		tall						70
		fontHeight					50
		textAlignment				center
		fgcolor_override			"225 225 225 200"
		
		//bgcolor_override			"70 70 70 0"
		//paintbackground				1
		
		pin_to_sibling				StatRowTitle
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}
	
	StatRow8 //deaths
	{
		ControlName					Label
		labelText					"#FS_DEATHS"
		wide						344
		tall						70
		fontHeight					50
		textAlignment				center
		fgcolor_override			"225 225 225 200"
		
		//bgcolor_override			"70 70 70 0"
		//paintbackground				1
		
		pin_to_sibling				StatRow2
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}
	
	StatRow1 //downs
	{
		ControlName					Label
		labelText					"#FS_DOWNS"
		wide						344
		tall						70
		fontHeight					50
		textAlignment				center
		fgcolor_override			"225 225 225 200"
		
		//bgcolor_override			"70 70 70 0"
		//paintbackground				1
		
		pin_to_sibling				StatRow8
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}
	
	StatRow3 //double downs
	{
		ControlName					Label
		labelText					"#FS_DOUBLE_DOWNS"
		wide						344
		tall						70
		fontHeight					50
		textAlignment				center
		fgcolor_override			"225 225 225 200"
		
		//bgcolor_override			"70 70 70 0"
		//paintbackground				1
		
		pin_to_sibling				StatRow1
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}
	
	StatRow4 //tripple downs
	{
		ControlName					Label
		labelText					"#FS_TRIPPLE_DOWNS"
		wide						344
		tall						70
		fontHeight					50
		textAlignment				center
		fgcolor_override			"225 225 225 200"
		
		//bgcolor_override			"70 70 70 0"
		//paintbackground				1
		
		pin_to_sibling				StatRow3
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}
	
	StatRow5 //team wipe
	{
		ControlName					Label
		labelText					"#FS_TEAM_WIPE"
		wide						344
		tall						70
		fontHeight					50
		textAlignment				center
		fgcolor_override			"225 225 225 200"
		
		//bgcolor_override			"70 70 70 0"
		//paintbackground				1
		
		pin_to_sibling				StatRow4
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}
	
	StatRow6 //team win
	{
		ControlName					Label
		labelText					"#FS_TEAM_WIN"
		wide						344
		tall						70
		fontHeight					50
		textAlignment				center
		fgcolor_override			"225 225 225 200"
		
		//bgcolor_override			"70 70 70 0"
		//paintbackground				1
		
		pin_to_sibling				StatRow5
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}
	
	StatRow7 //solo win
	{
		ControlName					Label
		labelText					"#FS_SOLO_WIN"
		wide						344
		tall						70
		fontHeight					50
		textAlignment				center
		fgcolor_override			"225 225 225 200"
		
		//bgcolor_override			"70 70 70 0"
		//paintbackground				1
		
		pin_to_sibling				StatRow6
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}
	
	StatRow9 //ring penalty
	{
		ControlName					Label
		labelText					"#FS_Ring_Penalty"
		wide						344
		tall						70
		fontHeight					50
		textAlignment				center
		fgcolor_override			"225 225 225 200"
		
		//bgcolor_override			"70 70 70 0"
		//paintbackground				1
		
		pin_to_sibling				StatRow7
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}
	
	
	////////////////
	// Score rows ////////////////////////////////////////////
	////////////////
	
	
	ScoreRowTitle
	{
		ControlName					Label
		labelText					"#FS_SCORE"
		wide						344
		tall						70
		fontHeight					50
		textAlignment				center
		fgcolor_override			"255 127 39 200"	
		bgcolor_override			"23 23 23 200"
		paintbackground				1
		
		pin_to_sibling				ColumnScore
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}
	
	ScoreRow2 //kills
	{
		ControlName					Label
		labelText					"0"
		wide						344
		tall						70
		fontHeight					50
		textAlignment				center
		fgcolor_override			"225 225 225 200"
		
		//bgcolor_override			"70 70 70 0"
		//paintbackground				1
		
		pin_to_sibling				ScoreRowTitle
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}
	
	ScoreRow8 //deaths
	{
		ControlName					Label
		labelText					"0"
		wide						344
		tall						70
		fontHeight					50
		textAlignment				center
		fgcolor_override			"225 225 225 200"
		
		//bgcolor_override			"70 70 70 0"
		//paintbackground				1
		
		pin_to_sibling				ScoreRow2
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}
	
	ScoreRow1 //downs
	{
		ControlName					Label
		labelText					"0"
		wide						344
		tall						70
		fontHeight					50
		textAlignment				center
		fgcolor_override			"225 225 225 200"
		
		//bgcolor_override			"70 70 70 0"
		//paintbackground				1
		
		pin_to_sibling				ScoreRow8
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}
	
	ScoreRow3 //double downs
	{
		ControlName					Label
		labelText					"0"
		wide						344
		tall						70
		fontHeight					50
		textAlignment				center
		fgcolor_override			"225 225 225 200"
		
		//bgcolor_override			"70 70 70 0"
		//paintbackground				1
		
		pin_to_sibling				ScoreRow1
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}
	
	ScoreRow4 //tripple downs
	{
		ControlName					Label
		labelText					"0"
		wide						344
		tall						70
		fontHeight					50
		textAlignment				center
		fgcolor_override			"225 225 225 200"
		
		//bgcolor_override			"70 70 70 0"
		//paintbackground				1
		
		pin_to_sibling				ScoreRow3
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}
	
	ScoreRow5 //team wipe
	{
		ControlName					Label
		labelText					"0"
		wide						344
		tall						70
		fontHeight					50
		textAlignment				center
		fgcolor_override			"225 225 225 200"
		
		//bgcolor_override			"70 70 70 0"
		//paintbackground				1
		
		pin_to_sibling				ScoreRow4
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}
	
	ScoreRow6 //team win
	{
		ControlName					Label
		labelText					"0"
		wide						344
		tall						70
		fontHeight					50
		textAlignment				center
		fgcolor_override			"225 225 225 200"
		
		//bgcolor_override			"70 70 70 0"
		//paintbackground				1
		
		pin_to_sibling				ScoreRow5
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}
	
	ScoreRow7 //solo win
	{
		ControlName					Label
		labelText					"0"
		wide						344
		tall						70
		fontHeight					50
		textAlignment				center
		fgcolor_override			"225 225 225 200"
		
		//bgcolor_override			"70 70 70 0"
		//paintbackground				1
		
		pin_to_sibling				ScoreRow6
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}
	
	ScoreRow9 //ring penalty
	{
		ControlName					Label
		labelText					"0"
		wide						344
		tall						70
		fontHeight					50
		textAlignment				center
		fgcolor_override			"225 225 225 200"
		
		//bgcolor_override			"70 70 70 0"
		//paintbackground				1
		
		pin_to_sibling				ScoreRow7
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}
	
	
	/////////////////
	// Totals rows ///////////////////////////////////////////
	/////////////////
	
	
	TotalsRowTitle
	{
		ControlName					Label
		labelText					"#FS_TOTALS"
		wide						344
		tall						70
		fontHeight					50
		textAlignment				center
		fgcolor_override			"255 127 39 200"	
		bgcolor_override			"23 23 23 200"
		paintbackground				1
		
		pin_to_sibling				ColumnTotals
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}
	
	TotalsRow2 //kills
	{
		ControlName					Label
		labelText					"0"
		wide						344
		tall						70
		fontHeight					50
		textAlignment				center
		fgcolor_override			"225 225 225 200"
		
		//bgcolor_override			"70 70 70 0"
		//paintbackground				1
		
		pin_to_sibling				TotalsRowTitle
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}
	
	TotalsRow8 //deaths
	{
		ControlName					Label
		labelText					"0"
		wide						344
		tall						70
		fontHeight					50
		textAlignment				center
		fgcolor_override			"225 225 225 200"
		
		//bgcolor_override			"70 70 70 0"
		//paintbackground				1
		
		pin_to_sibling				TotalsRow2
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}
	
	TotalsRow1 //downs
	{
		ControlName					Label
		labelText					"0"
		wide						344
		tall						70
		fontHeight					50
		textAlignment				center
		fgcolor_override			"225 225 225 200"
		
		//bgcolor_override			"70 70 70 0"
		//paintbackground				1
		
		pin_to_sibling				TotalsRow8
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}
	
	TotalsRow3 //double downs
	{
		ControlName					Label
		labelText					"0"
		wide						344
		tall						70
		fontHeight					50
		textAlignment				center
		fgcolor_override			"225 225 225 200"
		
		//bgcolor_override			"70 70 70 0"
		//paintbackground				1
		
		pin_to_sibling				TotalsRow1
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}
	
	TotalsRow4 //tripple downs
	{
		ControlName					Label
		labelText					"0"
		wide						344
		tall						70
		fontHeight					50
		textAlignment				center
		fgcolor_override			"225 225 225 200"
		
		//bgcolor_override			"70 70 70 0"
		//paintbackground				1
		
		pin_to_sibling				TotalsRow3
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}
	
	TotalsRow5 //team wipe
	{
		ControlName					Label
		labelText					"0"
		wide						344
		tall						70
		fontHeight					50
		textAlignment				center
		fgcolor_override			"225 225 225 200"
		
		//bgcolor_override			"70 70 70 0"
		//paintbackground				1
		
		pin_to_sibling				TotalsRow4
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}
	
	TotalsRow6 //team win
	{
		ControlName					Label
		labelText					"0"
		wide						344
		tall						70
		fontHeight					50
		textAlignment				center
		fgcolor_override			"225 225 225 200"
		
		//bgcolor_override			"70 70 70 0"
		//paintbackground				1
		
		pin_to_sibling				TotalsRow5
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}
	
	TotalsRow7 //solo win
	{
		ControlName					Label
		labelText					"0"
		wide						344
		tall						70
		fontHeight					50
		textAlignment				center
		fgcolor_override			"225 225 225 200"
		
		//bgcolor_override			"70 70 70 0"
		//paintbackground				1
		
		pin_to_sibling				TotalsRow6
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}
	
	TotalsRow9 //ring penalty
	{
		ControlName					Label
		labelText					"0"
		wide						344
		tall						70
		fontHeight					50
		textAlignment				center
		fgcolor_override			"225 225 225 200"
		
		//bgcolor_override			"70 70 70 0"
		//paintbackground				1
		
		pin_to_sibling				TotalsRow7
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}
}