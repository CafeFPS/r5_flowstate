// stub script

global function GameState_GetTimeLimitOverride

global function GetConnectedPlayers
global function AllTeamsConnected

global function IsRoundBasedGameOver
global function ShouldRunEvac
global function GiveTitanToPlayer
global function GetTimeLimit_ForGameMode
global function SetGameState
global function GameState_EntitiesDidLoad

float function GameState_GetTimeLimitOverride()
{
	return 100
}

array<entity> function GetConnectedPlayers()
{
	array<entity> players = GetPlayerArray()
	array<entity> guys
	foreach ( player in players )
	{
		if ( !player.hasConnected )
			continue

		guys.append( player )
	}

	return guys
}

bool function AllTeamsConnected()
{
	if ( IsFFAGame() )
		return true

	table<int, int> teamToPlayerCountTable

	array<entity> players = GetPlayerArray()
	foreach ( player in players )
	{
		if ( !player.hasConnected )
			continue

		int playerTeam = player.GetTeam()
		if ( playerTeam in teamToPlayerCountTable )
		{
			teamToPlayerCountTable[ playerTeam ]++
		}
		else
		{
			teamToPlayerCountTable[ playerTeam ] <- 1
			if ( teamToPlayerCountTable.len() == MAX_TEAMS )
				return true
		}
	}

	return false
}

bool function IsRoundBasedGameOver()
{
	return false
}

bool function ShouldRunEvac()
{
	return true
}

void function GiveTitanToPlayer(entity player)
{

}

float function GetTimeLimit_ForGameMode()
{
	return 100.0
}

void function SetGameState( int newState )
{
	RegisterSignal( "GameStateChanged" )
	level.nv.gameStateChangeTime = Time()
	level.nv.gameState = newState
	svGlobal.levelEnt.Signal( "GameStateChanged" )
	SetServerVar( "gameState", newState )

	#if DEVELOPER
	printt( "GAME STATE CHANGED TO: ", DEV_GetEnumStringSafe( "eGameState", newState ) ) //debug game state. Cafe
	#endif

	if( Flag( "EntitiesDidLoad" ) && Gamemode() != eGamemodes.SURVIVAL )
		SetGlobalNetInt( "gameState", newState )

	// added in AddCallback_GameStateEnter
	foreach ( callbackFunc in svGlobal.gameStateEnterCallbacks[ newState ] )
	{
		callbackFunc()
	}

	LiveAPI_OnGameStateChanged( newState )
}

void function GameState_EntitiesDidLoad()
{

}
