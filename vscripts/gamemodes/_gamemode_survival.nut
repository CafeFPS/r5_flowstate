// stub script

global function GamemodeSurvival_Init
global function RateSpawnpoints_Directional
global function Survival_SetFriendlyOwnerHighlight
global function SURVIVAL_AddSpawnPointGroup
global function SURVIVAL_IsCharacterClassLocked
global function SURVIVAL_IsValidCircleLocation
global function _GetSquadRank
global function JetwashFX
global function Survival_PlayerRespawnedTeammate
global function UpdateDeathBoxHighlight
// these probably doesn't belong here
global function DecideRespawnPlayer
//----------------------------------
global function Survival_GetMapFloorZ
global function SURVIVAL_GetClosestValidCircleEndLocation
global function SURVIVAL_CalculateAirdropPositions
global function SURVIVAL_GetPlaneHeight
global function SURVIVAL_GetAirburstHeight
global function SURVIVAL_AddLootBin
global function SURVIVAL_AddLootGroupRemapping
global function SURVIVAL_GetMultipleWeightedItemsFromGroup
global function SURVIVAL_DebugLoot
global function Survival_AddCallback_OnAirdropLaunched
global function Survival_CleanupPlayerPermanents
global function SURVIVAL_SetMapCenter


void function GamemodeSurvival_Init()
{
	SurvivalFreefall_Init()
	Sh_ArenaDeathField_Init()

	// init flags
	FlagInit( "DeathCircleActive", true )
	FlagInit( "DeathFieldPaused", false )
	FlagInit( "Survival_LootSpawned", true )
	FlagInit( "PathFinished", false )

	RegisterSignal( "SwitchToOrdnance" )
	RegisterSignal( "SwapToNextOrdnance" )
	// make sure that flags are set/cleared correctly
	FlagSet("DeathCircleActive")
	FlagClear("DeathFieldPaused")

	AddClientCommandCallback( "GoToMapPoint", ClientCommand_GoToMapPoint )
	AddCallback_OnPlayerKilled( OnPlayerKilled )

	// run deathfield
	RunArenaDeathField()
}

void function OnPlayerKilled( entity victim, entity attacker, var damageInfo )
{
	if( !IsValid( victim ) || !IsValid( attacker ) )
		return

	UpdateNetCounts()

	if( attacker.IsPlayer() )
	{
		attacker.SetPlayerNetInt( "kills" , attacker.GetPlayerNetInt( "kills" ) + 1 )
	}

	if( victim.IsPlayer() )
	{
		SetPlayerEliminated( victim )
	}
	
}

void function RunArenaDeathField()
{
	thread SURVIVAL_RunArenaDeathField()
}

void function Survival_SetFriendlyOwnerHighlight( entity player, entity characterModel )
{

}

void function SURVIVAL_AddSpawnPointGroup( string ref )
{

}

void function RateSpawnpoints_Directional( int checkClass, array<entity> spawnpoints, int team, entity player )
{

}

bool function SURVIVAL_IsCharacterClassLocked( entity player )
{
	return false
}

bool function SURVIVAL_IsValidCircleLocation( vector origin )
{
	return false
}

int function _GetSquadRank ( entity player )
{
	return 1
}

void function JetwashFX( entity dropship )
{

}

void function Survival_PlayerRespawnedTeammate( entity playersToSpawn, entity p )
{

}

void function UpdateDeathBoxHighlight( entity box )
{

}

void function DecideRespawnPlayer( entity player )
{

}

float function Survival_GetMapFloorZ( vector field )
{
	return 0.0
}

vector function SURVIVAL_GetClosestValidCircleEndLocation( vector origin )
{
	return origin
}

vector function SURVIVAL_CalculateAirdropPositions()
{
	// calculate airdrop pos here
	vector origin = <0, 0, 0>
	return origin
}

float function SURVIVAL_GetPlaneHeight()
{
	float height = 0.0
	return height
}

float function SURVIVAL_GetAirburstHeight()
{
	float height = 0.0
	return height
}

void function SURVIVAL_AddLootBin( entity lootbin )
{
	InitLootBin( lootbin )
}

void function SURVIVAL_AddLootGroupRemapping( string hovertank, string supplyship )
{
	
}

array<string> function SURVIVAL_GetMultipleWeightedItemsFromGroup( string lootGroup, int numLootItems )
{
	array<string> group = ["TODO"]
	return group
}

void function SURVIVAL_DebugLoot( string lootBinsLootInside, vector origin )
{

}

void function Survival_AddCallback_OnAirdropLaunched( void functionref( entity dropPod, vector origin ) callbackFunc )
{

}

void function Survival_CleanupPlayerPermanents( entity player )
{
	
}

void function SURVIVAL_SetMapCenter( vector center )
{
	
}

bool function ClientCommand_GoToMapPoint( entity player, array<string> args )
{
	if( !IsValid( player ) )
		return true

	float x = float( args[0] )
	float y = float( args[1] )
	float z = float( args[2] )

	vector origin = <x, y, z>

	if( z == 0 )
	{
		origin = OriginToGround( <x, y, 20000> )
	}

	player.SetOrigin( origin )

	return true

}