// Designed by @CafeFPS
// stats - mkos

global function FS_Scenarios_Score_System_Init
global function FS_Scenarios_GetEventScoreFromDatatable

#if SERVER

	global function FS_Scenarios_UpdatePlayerScore
	global function ScenariosPersistence_GetScore
	global function ScenariosPersistence_FetchPlayerStatsTable
	
	//Fetcher functions for backend
	#if TRACKER 
		global function TrackerStats_ScenariosScore
		global function TrackerStats_ScenariosKills
		global function TrackerStats_ScenariosDeaths
		global function TrackerStats_ScenariosDowns
		global function TrackerStats_ScenariosTeamWipe
		global function TrackerStats_ScenariosTeamWins
		global function TrackerStats_ScenariosSoloWins
	#endif
	
#endif

struct
{
	table<int, int > scores = {}
	
	#if SERVER 
		table<string, table<int, int> > scenariosPlayerScorePersistence
		table<int,int> __scoreTemplate
	#endif 
} file

global enum FS_ScoreType { //change datatable if you change this
	PLAYERSCORE = -1,
	SURVIVAL_TIME,
	DOWNED,
	KILL,
	BONUS_DOUBLE_DOWNED,
	BONUS_TRIPLE_DOWNED,
	BONUS_TEAM_WIPE,
	TEAM_WIN,
	SOLO_WIN,
	PENALTY_DEATH,
	PENALTY_RING,
	PENALTY_DESERTER,
	BONUS_BECOMES_SOLO_PLAYER,
	BONUS_KILLED_SOLO_PLAYER,
}

#if SERVER 
	struct ScenariosRecapData
	{
		int type
		string keyField
		int value
		int count
		bool isValid = false
	}
#endif 

void function FS_Scenarios_Score_System_Init()
{
	var dataTable = GetDataTable( $"datatable/flowstate_scenarios_score_system.rpak" )
	
	for ( int i = 0; i < GetDatatableRowCount( dataTable ); i++ )
	{
		int event = GetDataTableInt( dataTable, i, GetDataTableColumnByName( dataTable, "event" ) )
		int points = GetDataTableInt( dataTable, i, GetDataTableColumnByName( dataTable, "points" ) )
		
		#if DEVELOPER
			printt( "Adding Scenario event", GetEnumString( "FS_ScoreType", event ), points )
		#endif
		
		if(event in file.scores)
			file.scores[event] = points
		else
			file.scores[event] <- points
	}
	
	#if SERVER
		ScenariosPersistence_GenerateTemplate()
		AddCallback_OnClientConnected( ScenariosPersistence_SetupPlayer )
	#endif
}


int function FS_Scenarios_GetEventScoreFromDatatable( int event )
{
	if( event in file.scores )
		return file.scores[event]
	else
		return 0
		
	unreachable
}

#if SERVER
void function FS_Scenarios_UpdatePlayerScore( entity player, int event, entity victim = null, float value0 = -1 )
{
	if( !IsValid( player ) )
		return

	int score = player.GetPlayerNetInt( "FS_Scenarios_PlayerScore" )
	int eventScore = FS_Scenarios_GetEventScoreFromDatatable( event )
	int newScore = score + eventScore

	player.SetPlayerNetInt( "FS_Scenarios_PlayerScore", newScore )
	ScenariosPersistence_IncrementStat( player, FS_ScoreType.PLAYERSCORE, newScore )

	#if DEVELOPER
		printt( "NEW SCORE", player.GetPlayerNetInt( "FS_Scenarios_PlayerScore" ), player, GetEnumString( "FS_ScoreType", event ) )
	#endif

	switch( event )
	{
		case FS_ScoreType.SURVIVAL_TIME:
			int survivalTimeScoreToAdd = eventScore
			if( value0 != -1 && value0 > 1 )
				survivalTimeScoreToAdd *= int( value0 / 2 )
				
			AddPlayerScore( player, "FS_Scenarios_SurvivalTime", null, "", survivalTimeScoreToAdd )
			ScenariosPersistence_IncrementStat( player, FS_ScoreType.SURVIVAL_TIME, survivalTimeScoreToAdd )
		break
		case FS_ScoreType.DOWNED:
			AddPlayerScore( player, "FS_Scenarios_EnemyDowned", victim, "", eventScore )
			ScenariosPersistence_IncrementStat( player, FS_ScoreType.DOWNED, eventScore )
		break
		case FS_ScoreType.KILL:
			AddPlayerScore( player, "FS_Scenarios_EnemyKilled", victim, "", eventScore )
			ScenariosPersistence_IncrementStat( player, FS_ScoreType.KILL, eventScore )
		break
		case FS_ScoreType.BONUS_DOUBLE_DOWNED:
			AddPlayerScore( player, "FS_Scenarios_EnemyDoubleDowned", victim, "", eventScore )
			ScenariosPersistence_IncrementStat( player, FS_ScoreType.BONUS_DOUBLE_DOWNED, eventScore )
		break
		case FS_ScoreType.BONUS_TRIPLE_DOWNED:
			AddPlayerScore( player, "FS_Scenarios_EnemyTripleDowned", victim, "", eventScore )
			ScenariosPersistence_IncrementStat( player, FS_ScoreType.BONUS_TRIPLE_DOWNED, eventScore )
		break
		case FS_ScoreType.BONUS_TEAM_WIPE:
			AddPlayerScore( player, "FS_Scenarios_BonusTeamWipe", victim, "", eventScore )
			ScenariosPersistence_IncrementStat( player, FS_ScoreType.BONUS_TEAM_WIPE, eventScore )
		break
		case FS_ScoreType.TEAM_WIN:
			AddPlayerScore( player, "FS_Scenarios_TeamWin", null, "", eventScore )
			ScenariosPersistence_IncrementStat( player, FS_ScoreType.TEAM_WIN, eventScore )
		break
		case FS_ScoreType.SOLO_WIN:
			AddPlayerScore( player, "FS_Scenarios_SoloWin", null, "", eventScore )
			ScenariosPersistence_IncrementStat( player, FS_ScoreType.SOLO_WIN, eventScore )
		break
		case FS_ScoreType.PENALTY_DEATH:
			AddPlayerScore( player, "FS_Scenarios_PenaltyDeath", null, "", eventScore )
			ScenariosPersistence_IncrementStat( player, FS_ScoreType.PENALTY_DEATH, eventScore )
		break
		case FS_ScoreType.PENALTY_RING:
			AddPlayerScore( player, "FS_Scenarios_PenaltyRing", null, "", eventScore )
			ScenariosPersistence_IncrementStat( player, FS_ScoreType.PENALTY_RING, eventScore )
		break
		case FS_ScoreType.PENALTY_DESERTER:
			
		break
		
		case FS_ScoreType.BONUS_BECOMES_SOLO_PLAYER:
			AddPlayerScore( player, "FS_Scenarios_BecomesSoloPlayer", null, "", eventScore )
			ScenariosPersistence_IncrementStat( player, FS_ScoreType.BONUS_BECOMES_SOLO_PLAYER, eventScore )
		break
		
		case FS_ScoreType.BONUS_KILLED_SOLO_PLAYER:
			AddPlayerScore( player, "FS_Scenarios_KilledSoloPlayer", victim, "", eventScore )
			ScenariosPersistence_IncrementStat( player, FS_ScoreType.BONUS_KILLED_SOLO_PLAYER, eventScore )
		break
	}
}
#endif

//////////////////////////////////////////
//					stats				//
//////////////////////////////////////////

#if SERVER 
	void function ScenariosPersistence_GenerateTemplate()
	{
		table<int,int> newScoreTemplate = {}
		
		int maxIter = FS_ScoreType.len() - 2
		
		for( int iter = -1; iter < maxIter; iter++ )
			newScoreTemplate[ iter ] <- 0
		
		file.__scoreTemplate = newScoreTemplate
		disableoverwrite( file.__scoreTemplate )
	}

	bool function ScenariosPersistence_PlayerExists( string uid )
	{
		return ( uid in file.scenariosPlayerScorePersistence )
	}
	
	void function ScenariosPersistence_SetupPlayer( entity player )
	{
		if ( !ScenariosPersistence_PlayerExists( player.p.UID ) )
			file.scenariosPlayerScorePersistence[ player.p.UID ] <- clone file.__scoreTemplate
	}
	
	int function ScenariosPersistence_GetScore( string uid, int type )
	{
		if( !ScenariosPersistence_PlayerExists( uid ) )
			return 0
		
		return file.scenariosPlayerScorePersistence[ uid ][ type ]
	}
	
	void function ScenariosPersistence_SetScore( string uid, int type, int value )
	{
		file.scenariosPlayerScorePersistence[ uid ][ type ] = value
	}

	void function ScenariosPersistence_IncrementStat( entity player, int type, int value )
	{
		string uid = player.p.UID
		
		int currentScore = ScenariosPersistence_GetScore( uid, type )
		ScenariosPersistence_SetScore( uid, type, currentScore + value )
	}
	
	table<int,int> function ScenariosPersistence_FetchPlayerStatsTable( string uid )
	{
		#if DEVELOPER 
			mAssert( ScenariosPersistence_PlayerExists( uid ) )
		#endif
		
		return file.scenariosPlayerScorePersistence[ uid ]
	}
	
	table<int,ScenariosRecapData> function Scenarios_CurrentStandings( string uid )
	{		
		table<int,ScenariosRecapData> recapStruct
		
		foreach( int type, int statValue in file.scenariosPlayerScorePersistence.uid )
		{
			ScenariosRecapData recapData
			
			recapData.type 		= type 
			recapData.keyField 	= GetEnumString( "FS_ScoreType", type )
			recapData.value 	= statValue
			recapData.count		= statValue / FS_Scenarios_GetEventScoreFromDatatable( type )
			recapData.isValid	= true

			recapStruct[ type ] <- recapData
		}
		
		return recapStruct
	}
	
	//todo:
	// function for each round
	// add recap menu for rounds to menu options and load it based on stats table, 
#endif

////////////////////////////////////////////////////////
//////// 			STATS SHIPPING 				////////
////////////////////////////////////////////////////////

#if SERVER && TRACKER 

	var function TrackerStats_ScenariosScore( string uid )
	{
		return ScenariosPersistence_GetScore( uid, FS_ScoreType.PLAYERSCORE )
	}

	var function TrackerStats_ScenariosKills( string uid )
	{
		return ScenariosPersistence_GetScore( uid, FS_ScoreType.KILL ) / FS_Scenarios_GetEventScoreFromDatatable( FS_ScoreType.KILL )
	}

	var function TrackerStats_ScenariosDeaths( string uid )
	{
		return ScenariosPersistence_GetScore( uid, FS_ScoreType.PENALTY_DEATH ) / FS_Scenarios_GetEventScoreFromDatatable( FS_ScoreType.PENALTY_DEATH )
	}
	
	var function TrackerStats_ScenariosDowns( string uid )
	{
		return ScenariosPersistence_GetScore( uid, FS_ScoreType.DOWNED ) / FS_Scenarios_GetEventScoreFromDatatable( FS_ScoreType.DOWNED )
	}
	
	var function TrackerStats_ScenariosTeamWipe( string uid )
	{
		return ScenariosPersistence_GetScore( uid, FS_ScoreType.BONUS_TEAM_WIPE ) / FS_Scenarios_GetEventScoreFromDatatable( FS_ScoreType.BONUS_TEAM_WIPE )
	}
	
	var function TrackerStats_ScenariosTeamWins( string uid )
	{
		return ScenariosPersistence_GetScore( uid, FS_ScoreType.TEAM_WIN ) / FS_Scenarios_GetEventScoreFromDatatable( FS_ScoreType.TEAM_WIN )
	}
	
	var function TrackerStats_ScenariosSoloWins( string uid )
	{
		return ScenariosPersistence_GetScore( uid, FS_ScoreType.SOLO_WIN ) / FS_Scenarios_GetEventScoreFromDatatable( FS_ScoreType.SOLO_WIN )
	}
	
#endif