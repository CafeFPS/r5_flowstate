
global function InitScoreboardPanel

const MAX_TEAM_ELEMS = 8

enum eTeamRelationship
{
	MIXED,
	FRIENDLY,
	ENEMY
}

struct
{
	var menu
	var panel
	var modeAndMap
	var columnTitles
	array<var> rows
	array<var> teamDisplays
	table<var,string> buttonXuids
	table<var,string> buttonNames
} file


void function InitScoreboardPanel( var panel )
{
	file.panel = GetPanel( "ScoreboardPanel" )
	file.menu = GetParentMenu( file.panel )

	SetPanelTabTitle( file.panel, "#POSTGAME_SCOREBOARD" )

	AddPanelEventHandler( file.panel, eUIEvent.PANEL_SHOW, OnShowScoreboardPanel )
	//

	file.modeAndMap = Hud_GetChild( file.panel, "ModeAndMap" )
	file.columnTitles = Hud_GetChild( file.panel, "ColumnTitles" )
	file.teamDisplays.append( Hud_GetChild( file.panel, "TeamDisplay0" ) )
	file.teamDisplays.append( Hud_GetChild( file.panel, "TeamDisplay1" ) )

	file.rows = GetElementsByClassname( file.menu, "PostGameScoreboardRowClass" )
	foreach ( row in file.rows )
		Hud_AddEventHandler( row, UIE_CLICK, OnPostGameScoreboardRow_Activate )

	AddPanelFooterOption( file.panel, LEFT, BUTTON_A, false, "#A_BUTTON_VIEW_PROFILE", "", null, IsPostGameViewProfileValid )
	AddPanelFooterOption( file.panel, LEFT, BUTTON_B, false, "#B_BUTTON_CLOSE", "#CLOSE" )
	AddPanelFooterOption( file.panel, LEFT, BUTTON_BACK, false, "", "", ClosePostGameMenu )
}

void function OnShowScoreboardPanel( var panel )
{
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
}

void function UpdateColumnTitles( postGameDataDef matchData )
{
	string gameModeString = PersistenceGetEnumItemNameForIndex( "gameModes", matchData.gameMode )
	array<string> columnTitles = GameMode_GetScoreboardColumnTitles( gameModeString )

	var rui = Hud_GetRui( file.columnTitles )
	RuiSetInt( rui, "numColumns", columnTitles.len() )

	array<string> titleArgs = [ "title1", "title2", "title3", "title4" ]

	int i = 0
	foreach ( columnTitle in columnTitles )
	{
		RuiSetString( rui, titleArgs[i], columnTitle )
		i++
	}
}

void function UpdateRowsForTeam( postGameDataDef matchData, postGameTeamDef teamData, int relationship, bool won = false )
{
	int first
	int last

	if ( relationship == eTeamRelationship.MIXED )
	{
		relationship = eTeamRelationship.ENEMY
		first = 0
		last = MAX_TEAM_ELEMS * 2
	}
	else if ( won )
	{
		first = 0
		last = first + MAX_TEAM_ELEMS
	}
	else
	{
		first = MAX_TEAM_ELEMS
		last = first + MAX_TEAM_ELEMS
	}

	array<var> rows
	for ( int i = first; i < last; i++ )
		rows.append( file.rows[i] )

	array<string> scoreArgs = [ "playerScore1", "playerScore2", "playerScore3", "playerScore4" ]

	for ( int i = 0; i < rows.len(); i++ )
	{
		var row = rows[i]
		var rui = Hud_GetRui( row )

		if ( i < teamData.playersData.len() ) //
		{
			Hud_SetEnabled( row, true )
			RuiSetBool( rui, "isVisible", true )
			RuiSetBool( rui, "isEmpty", false )
			RuiSetString( rui, "playerName", teamData.playersData[i].name )

			if ( teamData.playersData[i].xuid == matchData.myXuid )
				RuiSetInt( rui, "relationship", 0 )
			else
				RuiSetInt( rui, "relationship", relationship )

			RuiSetInt( rui, "numColumns", teamData.playersData[i].scores.len() )

			foreach ( scoreIndex, score in teamData.playersData[i].scores )
				RuiSetInt( rui, scoreArgs[scoreIndex], score )

			file.buttonXuids[ row ] <- teamData.playersData[i].xuid
			file.buttonNames[ row ] <- teamData.playersData[i].name
		}
		else if ( i < teamData.maxTeamSize ) //
		{
			Hud_SetEnabled( row, false )
			RuiSetBool( rui, "isVisible", true )
			RuiSetBool( rui, "isEmpty", true )
			RuiSetInt( rui, "relationship", relationship )
		}
		else //
		{
			Hud_SetEnabled( row, false )
			RuiSetBool( rui, "isVisible", false )
		}
	}
}

void function OnPostGameScoreboardRow_Activate( var button )
{
	string xuid = file.buttonXuids[ button ]
	if ( xuid != "" )
	{
		#if(PC_PROG)
			if ( Origin_IsOverlayAvailable() )
				ShowPlayerProfileCardForUID( file.buttonXuids[ button ] )
		#else
			ShowPlayerProfileCardForUID( file.buttonXuids[ button ] )
		#endif
	}
}

bool function IsPostGameViewProfileValid()
{
	#if(PC_PROG)
		if ( !Origin_IsOverlayAvailable() )
			return false
	#endif //

	return true
}