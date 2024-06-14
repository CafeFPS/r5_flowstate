// Designed by @CafeFPS

global function FS_Scenarios_Score_System_Init
global function FS_Scenarios_GetEventScoreFromDatatable

#if SERVER
global function FS_Scenarios_UpdatePlayerScore
#endif

struct
{
	table<int, int > scores = {}
} file

global enum FS_ScoreType { //change datatable if you change this
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
	BONUS_KILLED_SOLO_PLAYER
}

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

	player.SetPlayerNetInt( "FS_Scenarios_PlayerScore", score + eventScore )

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
		break
		case FS_ScoreType.DOWNED:
			AddPlayerScore( player, "FS_Scenarios_EnemyDowned", victim, "", eventScore )
		break
		case FS_ScoreType.KILL:
			AddPlayerScore( player, "FS_Scenarios_EnemyKilled", victim, "", eventScore )
		break
		case FS_ScoreType.BONUS_DOUBLE_DOWNED:
			AddPlayerScore( player, "FS_Scenarios_EnemyDoubleDowned", victim, "", eventScore )
		break
		case FS_ScoreType.BONUS_TRIPLE_DOWNED:
			AddPlayerScore( player, "FS_Scenarios_EnemyTripleDowned", victim, "", eventScore )
		break
		case FS_ScoreType.BONUS_TEAM_WIPE:
			AddPlayerScore( player, "FS_Scenarios_BonusTeamWipe", victim, "", eventScore )
		break
		case FS_ScoreType.TEAM_WIN:
			AddPlayerScore( player, "FS_Scenarios_TeamWin", null, "", eventScore )
		break
		case FS_ScoreType.SOLO_WIN:
			AddPlayerScore( player, "FS_Scenarios_SoloWin", null, "", eventScore )
		break
		case FS_ScoreType.PENALTY_DEATH:
			AddPlayerScore( player, "FS_Scenarios_PenaltyDeath", null, "", eventScore )
		break
		case FS_ScoreType.PENALTY_RING:
			AddPlayerScore( player, "FS_Scenarios_PenaltyRing", null, "", eventScore )
		break
		case FS_ScoreType.PENALTY_DESERTER:
			
		break
		
		case FS_ScoreType.BONUS_BECOMES_SOLO_PLAYER:
			AddPlayerScore( player, "FS_Scenarios_BecomesSoloPlayer", null, "", eventScore )
		break
		
		case FS_ScoreType.BONUS_KILLED_SOLO_PLAYER:
			AddPlayerScore( player, "FS_Scenarios_KilledSoloPlayer", victim, "", eventScore )
		break
	}
}
#endif