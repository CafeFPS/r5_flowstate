// Designed by @CafeFPS
// stats/persistence/recaps - mkos

global function FS_Scenarios_Score_System_Init
global function FS_Scenarios_GetEventScoreValue
global function Scenarios_RegisterNetworking
	
#if CLIENT 
	global function UpdateStandingsScriptsFromClient
	global function Scenarios_SendPlayerScoreLeaders
	global function FS_Scenarios_ForceUpdatePlayerCount
#endif
	
#if SERVER

	global function FS_Scenarios_UpdatePlayerScore
	
	global function ScenariosPersistence_GetScore
	global function ScenariosPersistence_GetCount
	global function ScenariosPersistence_FetchPlayerScoreTable
	
	global function ScenariosPersistence_SendStandingsToClient
	global function ScenariosPersistence_ClearAllData
	
	//Fetcher functions for backend
	#if TRACKER 
		global function TrackerStats_ScenariosScore
		global function TrackerStats_ScenariosKills
		global function TrackerStats_ScenariosDeaths
		global function TrackerStats_ScenariosDowns
		global function TrackerStats_ScenariosTeamWipe
		global function TrackerStats_ScenariosTeamWins
		global function TrackerStats_ScenariosSoloWins
		global function TrackerStats_ScenariosRecentScore
	#endif
	
	#if DEVELOPER 
		global function DEV_PrintScores
	#endif 
	
#endif //SERVER

#if CLIENT 
	struct ClientRecapStruct
	{
		int value 
		int count
	}
#endif //CLIENT

const int STANDINGS_GLOBAL	= 1
const int STANDINGS_ROUND 	= 2
global const int SCORE_BOMBPLANTED_REWARD = 500
global const int SCORE_BOMBCARRIERKILLED_BONUS = 100
global const int SCORE_BOMBCARRIERKILLED = 100


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
		bool isTransmitting
	#endif
	
} file

global enum FS_ScoreType 
{ 
	//change datatable if you change this
	//if this order changes, the ui will not be correct for players. Always Append + comment index for reference
	
	PLAYERSCORE = -1, /* -1 */
	SURVIVAL_TIME, /* 0 */
	DOWNED, /* 1 */
	KILL, /* 2 */
	BONUS_DOUBLE_DOWNED, /* 3 */
	BONUS_TRIPLE_DOWNED, /* 4 */
	BONUS_TEAM_WIPE, /* 5 */
	TEAM_WIN, /* 6 */
	SOLO_WIN, /* 7 */
	PENALTY_DEATH, /* 8 */
	PENALTY_RING, /* 9 */
	PENALTY_DESERTER, /* 10 */
	BONUS_BECOMES_SOLO_PLAYER, /* 11 */
	BONUS_KILLED_SOLO_PLAYER, /* 12 */
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
	
	#if CLIENT
		if( Playlist() == ePlaylists.fs_scenarios )
			AddCallback_UIScriptReset( _UpdateStandingsScriptsFromClient )
	#endif
	
	#if SERVER
		ScenariosPersistence_GenerateTemplate()
		AddCallback_OnClientConnected( ScenariosPersistence_SetupPlayer )
		AddClientCommandCallback( "requestStandings", ClientCommand_ScenariosRequestStandings )
	#endif
}

int function FS_Scenarios_GetEventScoreValue( int event )
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

	int score = ScenariosPersistence_GetScore( player.p.UID, FS_ScoreType.PLAYERSCORE )
	int eventScore = FS_Scenarios_GetEventScoreValue( event )
	int newScore = score + eventScore

	player.SetPlayerNetInt( "FS_Scenarios_PlayerScore", newScore )
	__ScenariosPersistence_IncrementStat( player, FS_ScoreType.PLAYERSCORE, eventScore )

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
			__ScenariosPersistence_IncrementStat( player, FS_ScoreType.SURVIVAL_TIME, survivalTimeScoreToAdd )
		break
		case FS_ScoreType.DOWNED:
			AddPlayerScore( player, "FS_Scenarios_EnemyDowned", victim, "", eventScore )
			__ScenariosPersistence_IncrementStat( player, FS_ScoreType.DOWNED, 1 )
		break
		case FS_ScoreType.KILL:
			AddPlayerScore( player, "FS_Scenarios_EnemyKilled", victim, "", eventScore )
			__ScenariosPersistence_IncrementStat( player, FS_ScoreType.KILL, 1 )
		break
		case FS_ScoreType.BONUS_DOUBLE_DOWNED:
			AddPlayerScore( player, "FS_Scenarios_EnemyDoubleDowned", victim, "", eventScore )
			__ScenariosPersistence_IncrementStat( player, FS_ScoreType.BONUS_DOUBLE_DOWNED, 1 )
		break
		case FS_ScoreType.BONUS_TRIPLE_DOWNED:
			AddPlayerScore( player, "FS_Scenarios_EnemyTripleDowned", victim, "", eventScore )
			__ScenariosPersistence_IncrementStat( player, FS_ScoreType.BONUS_TRIPLE_DOWNED, 1 )
		break
		case FS_ScoreType.BONUS_TEAM_WIPE:
			AddPlayerScore( player, "FS_Scenarios_BonusTeamWipe", victim, "", eventScore )
			__ScenariosPersistence_IncrementStat( player, FS_ScoreType.BONUS_TEAM_WIPE, 1 )
		break
		case FS_ScoreType.TEAM_WIN:
			AddPlayerScore( player, "FS_Scenarios_TeamWin", null, "", eventScore )
			__ScenariosPersistence_IncrementStat( player, FS_ScoreType.TEAM_WIN, 1 )
		break
		case FS_ScoreType.SOLO_WIN:
			AddPlayerScore( player, "FS_Scenarios_SoloWin", null, "", eventScore )
			__ScenariosPersistence_IncrementStat( player, FS_ScoreType.SOLO_WIN, 1 )
		break
		case FS_ScoreType.PENALTY_DEATH:
			AddPlayerScore( player, "FS_Scenarios_PenaltyDeath", null, "", eventScore )
			__ScenariosPersistence_IncrementStat( player, FS_ScoreType.PENALTY_DEATH, 1 )
		break
		case FS_ScoreType.PENALTY_RING:
			AddPlayerScore( player, "FS_Scenarios_PenaltyRing", null, "", eventScore )
			__ScenariosPersistence_IncrementStat( player, FS_ScoreType.PENALTY_RING, 1 )
		break
		case FS_ScoreType.PENALTY_DESERTER:
			
		break
		
		case FS_ScoreType.BONUS_BECOMES_SOLO_PLAYER:
			AddPlayerScore( player, "FS_Scenarios_BecomesSoloPlayer", null, "", eventScore )
			__ScenariosPersistence_IncrementStat( player, FS_ScoreType.BONUS_BECOMES_SOLO_PLAYER, 1 )
		break
		
		case FS_ScoreType.BONUS_KILLED_SOLO_PLAYER:
			AddPlayerScore( player, "FS_Scenarios_KilledSoloPlayer", victim, "", eventScore )
			__ScenariosPersistence_IncrementStat( player, FS_ScoreType.BONUS_KILLED_SOLO_PLAYER, 1 )
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
		//recap type, stat type, value, count
		Remote_RegisterUIFunction( "ServerCallback_SendScenariosStandings", "int", 0, 3, "int", INT_MIN, INT_MAX, "int", INT_MIN, INT_MAX, "int", INT_MIN, INT_MAX )
		Remote_RegisterUIFunction( "ServerCallback_SignalScenariosStandings" )
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
		
		int scoreValue = FS_Scenarios_GetEventScoreValue( type )
		int multiply = scoreValue != 0 ? scoreValue : 1
		
		return file.scenariosPlayerScorePersistence[ uid ][ type ] * multiply
	}
	
	int function Scenarios_CalculateScore( int type, int count )
	{
		int scoreValue = FS_Scenarios_GetEventScoreValue( type )
		int multiply = scoreValue != 0 ? scoreValue : 1
		
		return count * multiply
	}
	
	void function ScenariosPersistence_SetScore( string uid, int type, int value )
	{
		file.scenariosPlayerScorePersistence[ uid ][ type ] = value
	}
	
	void function ScenariosPersistence_AddRoundScore( string uid, int type, int value )
	{
		file.scenariosPlayerRoundStandings[ uid ][ type ] += value
	}
	
	void function ScenariosPersistence_AddMatchScore( string uid, int type, int value )
	{
		file.scenariosPlayerScorePersistence[ uid ][ type ] += value
	}
	
	int function ScenariosPersistence_GetCount( string uid, int type )
	{
		if( !ScenariosPersistence_PlayerExists( uid ) ) //Todo(dw): remove the need to check
			return 0
		
		return file.scenariosPlayerScorePersistence[ uid ][ type ]
	}

	void function __ScenariosPersistence_IncrementStat( entity player, int type, int value )
	{
		string uid = player.p.UID
		
		ScenariosPersistence_AddRoundScore( uid, type, value )
		ScenariosPersistence_AddMatchScore( uid, type, value )
	}
	
	table<int,int> function ScenariosPersistence_FetchPlayerScoreTable( string uid )
	{
		#if DEVELOPER 
			mAssert( ScenariosPersistence_PlayerExists( uid ) )
		#endif
		
		return file.scenariosPlayerScorePersistence[ uid ]
	}
	
	table<int,ScenariosRecapData> function Scenarios_FetchStandings( string uid, int standingType )
	{		
		switch( standingType )
		{
			case STANDINGS_GLOBAL:
				return Scenarios_FetchStandings_internal( file.scenariosPlayerScorePersistence[ uid ] )
				
			case STANDINGS_ROUND:
				return Scenarios_FetchStandings_internal( file.scenariosPlayerRoundStandings[ uid ] )
				
			default:
				mAssert( false, "Invalid standings type." )
		}
		
		unreachable
	}
	
	table<int,ScenariosRecapData> function Scenarios_FetchStandings_internal( table<int,int> recapInfo )
	{
		table<int,ScenariosRecapData> recapStruct
		
		foreach( int type, int statCount in recapInfo )
		{
			ScenariosRecapData recapData
			
			#if DEVELOPER 
				recapData.keyField = GetEnumString( "FS_ScoreType", type )
			#endif
			
			int scoreAward_temp = FS_Scenarios_GetEventScoreValue( type )
			int scoreAward = scoreAward_temp > 0 ? scoreAward_temp : 1
			
			recapData.type 		= type
			recapData.value 	= Scenarios_CalculateScore( type, statCount )
			recapData.count		= statCount
			recapData.isValid	= true

			recapStruct[ type ] <- recapData
		}
		
		return recapStruct
	}
	
	void function ScenariosPersistence_SendStandingsToClient( entity player )
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
				
			Remote_CallFunction_UI( player, "ServerCallback_SendScenariosStandings", STANDINGS_GLOBAL, statType, recapStruct.value, recapStruct.count )
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
			
			Remote_CallFunction_UI( player, "ServerCallback_SendScenariosStandings", STANDINGS_ROUND, statType, recapStruct.value, recapStruct.count )
		}
		
		_ClearRoundData( uid )
		
		Remote_CallFunction_UI( player, "ServerCallback_SignalScenariosStandings" )
	}
	
	void function _ClearRoundData( string uid )
	{
		foreach( k,v in file.scenariosPlayerRoundStandings[ uid ] )
			file.scenariosPlayerRoundStandings[ uid ][ k ] = 0
	}
	
	void function ScenariosPersistence_ClearAllData()
	{
		foreach( string uid, table<int,int> dataStruct in file.scenariosPlayerRoundStandings )
		{
			foreach( k,v in dataStruct )
				file.scenariosPlayerRoundStandings[ uid ][ k ] = 0
		}
		
		foreach( string uid, table<int,int> dataStruct in file.scenariosPlayerScorePersistence )
		{
			foreach( k,v in dataStruct )
				file.scenariosPlayerScorePersistence[ uid ][ k ] = 0
		}
	}
	
	bool function ClientCommand_ScenariosRequestStandings( entity player, array<string> args )
	{
		bool notify = true
		
		if( args.len() > 0 )
		{
			if( args[ 0 ] == "false" )
				notify = false
		}
		
		if( !CheckRate( player, notify, 5 ) )
			return true
			
		ScenariosPersistence_SendStandingsToClient( player )
		return true
	}
	
	#if DEVELOPER 
		void function DEV_PrintScores()
		{
			foreach( int type, int score in file.scores )
			{
				printt( "type:", type, "[" + GetEnumString( "FS_ScoreType", type ) + "]", "score=", score )
			}
		}
	#endif
	
#endif //SERVER

#if CLIENT 
	
	void function _UpdateStandingsScriptsFromClient() //ran with callback to trigger notify
	{
		UpdateStandingsScriptsFromClient( true )
	}
	
	void function UpdateStandingsScriptsFromClient( bool notify )
	{
		entity player = GetLocalClientPlayer()
		
		if( IsValid( player ) )
		{
			string notifyParam = notify ? " true" : " false"
			
			RunUIScript( "UI_ScenariosTemplate_Init", ( file.scores.len() - 1 ) )
			player.ClientCommand( "requestStandings" + notifyParam )
		}
	}
	
	#if DEVELOPER 
		void function print_entity_array( array<entity> arr )
		{
			foreach( entity player in arr )
				printt( player )
				
			printt( "COUNT = ", arr.len() )
		}
	#endif 
	
	
	void function Scenarios_SendPlayerScoreLeaders()
	{
		array<entity> playerScores = GetPlayerArray()
		
		playerScores.sort
		( 
			int function( entity y, entity z )
			{
				int a = y.GetPlayerNetInt( "FS_Scenarios_PlayerScore" )
				int b = z.GetPlayerNetInt( "FS_Scenarios_PlayerScore" )
				
				if ( a > b )
					return -1
				if ( a < b )
					return 1
				return 0
			}
		)
		
		playerScores.resize( minint( 10, GetPlayerArray().len() ) )
		
		foreach( entity player in playerScores )
		{
			if( !IsValid( player ) )
				continue
			
			string playerName = player.GetPlayerName()
			
			if( playerName.find( "[" ) != -1 )
				continue
				
			RunUIScript( "Scenarios_ClientToUi_ScoreLeaders", playerName, player.GetPlayerNetInt( "FS_Scenarios_PlayerScore" ) )
		}
			
		RunUIScript( "Scenarios_SetScoreLeaders" )
	}
	
	void function FS_Scenarios_ForceUpdatePlayerCount() //getting rid of networked int for this game mode, so we can show proper enemy player count (each team should have a different value, networked int will show only one value) Colombia
	{
		var statusRui = ClGameState_GetRui()
		if( statusRui != null )
		{
			array<entity> players = GetPlayerArrayOfEnemies_Alive( GetLocalClientPlayer().GetTeam() )
			ArrayRemoveOutOfRealmAndLobbyPlayers( players )
			// printt( "FS_Scenarios_ForceUpdatePlayerCount", players.len() )
			RuiSetInt( statusRui, "livingPlayerCount", players.len() )
			RuiSetInt( statusRui, "squadsRemainingCount", players.len() )
		}
	}

	void function ArrayRemoveOutOfRealmAndLobbyPlayers( array<entity> ents )
	{
		entity player = GetLocalClientPlayer()
		for ( int i = ents.len() - 1; i >= 0; i-- )
		{
			if ( IsValid( ents[ i ] ) && IsValid( player ) && !ents[ i ].DoesShareRealms( player ) || IsValid( ents[ i ] ) && ents[ i ].GetRealms().len() > 1 ) //more than one realm means they are in lobby ( all realms )
				ents.remove( i )
		}
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
	
	var function TrackerStats_ScenariosRecentScore( string uid )
	{
		return ScenariosPersistence_GetScore( uid, FS_ScoreType.PLAYERSCORE )
	}

	var function TrackerStats_ScenariosKills( string uid )
	{
		return ScenariosPersistence_GetCount( uid, FS_ScoreType.KILL )
	}

	var function TrackerStats_ScenariosDeaths( string uid )
	{
		return ScenariosPersistence_GetCount( uid, FS_ScoreType.PENALTY_DEATH )
	}
	
	var function TrackerStats_ScenariosDowns( string uid )
	{
		return ScenariosPersistence_GetCount( uid, FS_ScoreType.DOWNED )
	}
	
	var function TrackerStats_ScenariosTeamWipe( string uid )
	{
		return ScenariosPersistence_GetCount( uid, FS_ScoreType.BONUS_TEAM_WIPE )
	}
	
	var function TrackerStats_ScenariosTeamWins( string uid )
	{
		return ScenariosPersistence_GetCount( uid, FS_ScoreType.TEAM_WIN )
	}
	
	var function TrackerStats_ScenariosSoloWins( string uid )
	{
		return ScenariosPersistence_GetCount( uid, FS_ScoreType.SOLO_WIN )
	}
	
#endif //SERVER && TRACKER 