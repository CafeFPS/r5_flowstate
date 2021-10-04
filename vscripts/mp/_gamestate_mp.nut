// stub script

global function GameState_GetTimeLimitOverride
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

	// added in AddCallback_GameStateEnter
	foreach ( callbackFunc in svGlobal.gameStateEnterCallbacks[ newState ] )
	{
		callbackFunc()
	}
}

void function GameState_EntitiesDidLoad()
{

}
