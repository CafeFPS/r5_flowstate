// Designed by @CafeFPS
// stats/persistence/recaps - mkos

global function FS_Scenarios_Score_System_Init
global function FS_Scenarios_GetEventScoreFromDatatable
global function Scenarios_RegisterNetworking

#if CLIENT 
	global function ServerCallback_SendScenariosStandings
	global function ServerCallback_SignalScenariosStandings
#endif
	
#if SERVER

	global function FS_Scenarios_UpdatePlayerScore
	global function ScenariosPersistence_GetScore
	global function ScenariosPersistence_FetchPlayerScoreTable
	global function Scenarios_SendStandingsToClient
	
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
	
#endif //SERVER

#if CLIENT 
	struct ClientRecapStruct
	{
		int value 
		int count
	}
#endif //CLIENT

const int STANDINGS_GLOBAL	= 0
const int STANDINGS_ROUND 	= 1
typedef ScenariosStructType table<string, table<int, int> > 

struct
{
	table<int, int > scores = {}
	
	#if SERVER
		ScenariosStructType scenariosPlayerScorePersistence
		ScenariosStructType scenariosPlayerRoundStandings
		table<int,int> __scoreTemplate
	#endif 
	
	#if CLIENT 
		table<int,ClientRecapStruct> localPlayerGlobalStandings
		table<int,ClientRecapStruct> localPlayerRoundSettings
		bool isTransmitting
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
#endif //SERVER

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
#endif //SERVER

//////////////////////////////////////////
//					stats				//
//////////////////////////////////////////

#if SERVER || CLIENT 

	void function Scenarios_RegisterNetworking()
	{
		//type, value, count
		Remote_RegisterClientFunction( "ServerCallback_SendScenariosStandings", "int", -1, 2, "int", INT_MIN, INT_MAX, "int", INT_MIN, INT_MAX, "int", INT_MIN, INT_MAX )
		Remote_RegisterClientFunction( "ServerCallback_SignalScenariosStandings" )
	}
	
#endif //SERVER || CLIENT

#if SERVER 
	void function ScenariosPersistence_GenerateTemplate()
	{
		table<int,int> newScoreTemplate = {}
		
		int maxIter = FS_ScoreType.len() - 1
		
		for( int iter = -1; iter < maxIter; iter++ )
			newScoreTemplate[ iter ] <- 0
		
		file.__scoreTemplate = newScoreTemplate
		disableoverwrite( file.__scoreTemplate )
		
		// #if DEVELOPER 
			// foreach( int type, int value in newScoreTemplate )
				// printt( "type = ", type, "-- value = ", value )
		// #endif 
	}

	bool function ScenariosPersistence_PlayerExists( string uid )
	{
		return ( uid in file.scenariosPlayerScorePersistence )
	}
	
	void function ScenariosPersistence_SetupPlayer( entity player )
	{
		string uid = player.p.UID
		
		if ( !ScenariosPersistence_PlayerExists( uid ) )
		{
			file.scenariosPlayerScorePersistence[ uid ] <- clone file.__scoreTemplate
			file.scenariosPlayerRoundStandings[ uid ] <- clone file.__scoreTemplate
		}
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
	
	void function ScenariosPersistence_SetRoundScore( string uid, int type, int value )
	{
		file.scenariosPlayerRoundStandings[ uid ][ type ] += value
	}

	void function ScenariosPersistence_IncrementStat( entity player, int type, int value )
	{
		string uid = player.p.UID
		
		ScenariosPersistence_SetRoundScore( uid, type, value )
		
		int currentScore = ScenariosPersistence_GetScore( uid, type )
		ScenariosPersistence_SetScore( uid, type, currentScore + value )
	}
	
	table<int,int> function ScenariosPersistence_FetchPlayerScoreTable( string uid )
	{
		#if DEVELOPER 
			mAssert( ScenariosPersistence_PlayerExists( uid ) )
		#endif
		
		return file.scenariosPlayerScorePersistence[ uid ]
	}
	
	table<int,ScenariosRecapData> function Scenarios_FetchStandings( string uid, int standingType = STANDINGS_GLOBAL )
	{		
		table<int,ScenariosRecapData> recapStruct
		
		ScenariosStructType structRef
		
		switch( standingType )
		{
			case STANDINGS_GLOBAL:
				structRef = file.scenariosPlayerScorePersistence
				break 
				
			case STANDINGS_ROUND:
				structRef = file.scenariosPlayerRoundStandings
				break 
				
			default:
				mAssert( false, "Invalid standings type." )
		}
		
		foreach( int type, int statValue in structRef[ uid ] )
		{
			ScenariosRecapData recapData
			
			#if DEVELOPER 
				recapData.keyField = GetEnumString( "FS_ScoreType", type )
			#endif
			
			int scoreAward_temp = FS_Scenarios_GetEventScoreFromDatatable( type )
			int scoreAward = scoreAward_temp > 0 ? scoreAward_temp : 1
			
			recapData.type 		= type
			recapData.value 	= statValue
			recapData.count		= statValue / scoreAward
			recapData.isValid	= true

			recapStruct[ type ] <- recapData
		}
		
		return recapStruct
	}
	
	void function Scenarios_SendStandingsToClient( entity player )
	{
		string uid = player.p.UID
		
		////////////
		// GLOBAL //
		////////////
		table<int,ScenariosRecapData> currentGlobalStandings = Scenarios_FetchStandings( uid, STANDINGS_GLOBAL )
		
		foreach( int statType, ScenariosRecapData recapStruct in currentGlobalStandings )
		{
			#if DEVELOPER
				mAssert( recapStruct.isValid, "Invalid struct data for player " + string( player ) + " was invalid for statType: " + string( statType ) + " ENUMFIELD: " + GetEnumString( "FS_ScoreType", statType )  )
			#endif
				
			Remote_CallFunction_NonReplay( player, "ServerCallback_SendScenariosStandings", STANDINGS_GLOBAL, statType, recapStruct.value, recapStruct.count )
		}
		
		////////////
		//  ROUND //
		////////////
		table<int,ScenariosRecapData> currentRoundStandings = Scenarios_FetchStandings( uid, STANDINGS_ROUND )
		
		foreach( int statType, ScenariosRecapData recapStruct in currentRoundStandings )
		{
			#if DEVELOPER
				mAssert( recapStruct.isValid, "Invalid struct data for player " + string( player ) + " was invalid for statType: " + string( statType ) + " ENUMFIELD: " + GetEnumString( "FS_ScoreType", statType )  )
			#endif
				
			Remote_CallFunction_NonReplay( player, "ServerCallback_SendScenariosStandings", STANDINGS_ROUND, statType, recapStruct.value, recapStruct.count )
		}
		
		_ClearRoundData( uid )
		
		Remote_CallFunction_NonReplay( player, "ServerCallback_SignalScenariosStandings" )
	}
	
	void function _ClearRoundData( string uid )
	{
		foreach( k,v in file.scenariosPlayerRoundStandings[ uid ] )
			v = 0
	}
	
#endif //SERVER

#if CLIENT 
	
	void function ServerCallback_SendScenariosStandings( int standingType, int scoreType, int value, int count )
	{
		if( !file.isTransmitting )
			file.isTransmitting = true
			
		ClientRecapStruct recap
		
		recap.value = value 
		recap.count = count //probably should just calculate on client
		
		switch( standingType )
		{
			case STANDINGS_GLOBAL:
				file.localPlayerGlobalStandings[ scoreType ] <- recap
				break
				
			case STANDINGS_ROUND:
				file.localPlayerRoundSettings[ scoreType ] <- recap
				break 
				
			default:
				mAssert( false, "Server specified an incorrect standings type during recap transmission" )
		}
	}
	
	void function ServerCallback_SignalScenariosStandings()
	{
		file.isTransmitting = false
		
		entity player = GetLocalClientPlayer()
			
		#if DEVELOPER
			foreach( int scoreType, ClientRecapStruct data in file.localPlayerGlobalStandings )
				printt( "GLOBAL scoreType =", GetEnumString( "FS_ScoreType", scoreType ), "-- score:", data.value, "--Totals:", data.count )
				
			foreach( int scoreType, ClientRecapStruct data in file.localPlayerRoundSettings )
				printt( "ROUND scoreType =", GetEnumString( "FS_ScoreType", scoreType ), "-- score:", data.value, "--Totals:", data.count )
		#endif
		
		//RunUIScript( "UI_UpdateScenariosRecapMenu", file.localPlayerGlobalStandings, file.localPlayerRoundSettings )
	}
	
	ClientRecapStruct function Scenarios_GetLocalStanding( int standingType, int scoreType )
	{
		ClientRecapStruct inval
		
		switch( standingType )
		{
			case STANDINGS_GLOBAL:
			
				#if DEVELOPER
					mAssert( scoreType in file.localPlayerGlobalStandings )
				#endif
					return file.localPlayerGlobalStandings[ scoreType ]
				
				break 
				
			case STANDINGS_ROUND:
				
				#if DEVELOPER
					mAssert( scoreType in file.localPlayerRoundSettings )
				#endif
					return file.localPlayerRoundSettings[ scoreType ]
			
				break
				
			default:
				mAssert( false, "Server specified an incorrect standings type during recap transmission" )
				break
		}
		
		return inval
	}

#endif //CLIENT

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
		return abs( ScenariosPersistence_GetScore( uid, FS_ScoreType.PENALTY_DEATH ) ) / abs( FS_Scenarios_GetEventScoreFromDatatable( FS_ScoreType.PENALTY_DEATH ) )
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
	
#endif //SERVER && TRACKER 