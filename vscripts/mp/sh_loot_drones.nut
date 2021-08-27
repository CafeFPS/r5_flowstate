//=========================================================
//	sh_loot_drones.nut
//=========================================================

global function ShLootDrones_Init
global function IsValidLootDrone
global function IsValidLootDroneMover

#if CLIENT
global function ServerCallback_AddDroneClientData
global function ServerCallback_SetLootDroneTrailFXType
global function ServerCallback_ClearLootDroneTrailFXType
global function ServerCallback_ClearAllLootDroneFX
#endif


//////////////////////
//////////////////////
//// Global Types ////
//////////////////////
//////////////////////
global const asset LOOT_DRONE_MODEL = $"mdl/props/loot_drone/loot_drone.rmdl" //

global const float LOOT_DRONE_START_FALL_HEALTH_FRAC = 0.95
global const float LOOT_DRONE_HEALTH_MAX             = 1.0

global const string LOOT_DRONE_FX_ATTACH_NAME   = "fx_center"
global const asset LOOT_DRONE_FX_EXPLOSION      = $"P_loot_drone_explosion"
global const asset LOOT_DRONE_FX_TRAIL          = $"P_loot_drone_exhaust"
global const asset LOOT_DRONE_FX_TRAIL_PANIC    = $"P_loot_drone_exhaust_afterburn"
global const asset LOOT_DRONE_FX_TRAIL_FALL     = $"p_loot_drone_body_trail"
global const asset LOOT_DRONE_FX_FALL_EXPLOSION = $"P_loot_drone_explosion_air"

global const string LOOT_DRONE_LIVING_SOUND     = "LootDrone_Mvmt_Flying"
global const string LOOT_DRONE_DEATH_SOUND      = "LootDrone_KillShot"
global const string LOOT_DRONE_CRASHING_SOUND   = "LootDrone_Mvmt_Crashing"
global const string LOOT_DRONE_CRASHED_SOUND    = "LootDrone_Explo"

global const string LOOT_DRONE_DAMAGE_VO        = "bc_cargoBotDamaged"

global const float LOOT_DRONE_FLIGHT_SPEED_MAX   = 175.0
global const float LOOT_DRONE_FLIGHT_ACCEL       = 100.0
global const float LOOT_DRONE_FLIGHT_SPEED_PANIC = 500.0
global const float LOOT_DRONE_PANIC_DURATION     = 5.0

global const float LOOT_DRONE_FALLING_SPEED_MAX        = 800.0
global const float LOOT_DRONE_FALLING_ACCEL            = 300.0
global const float LOOT_DRONE_FALLING_GRAVITY          = 350.0
global const float LOOT_DRONE_FALL_TRACE_DIST          = 1024.0
global const float LOOT_DRONE_MIN_FALL_DIST_TO_SURFACE = 32.0

global const float LOOT_DRONE_RAND_TOSS_MIN            = 700.0
global const float LOOT_DRONE_RAND_TOSS_MAX            = 700.0

global const string SIGNAL_LOOT_DRONE_FALL_START  = "signalLootDroneSpiral"
global const string SIGNAL_LOOT_DRONE_STOP_PANIC  = "lootDroneStopPanicking"

global const string LOOT_DRONE_MODEL_SCRIPTNAME   = "LootDroneModel"
global const string LOOT_DRONE_MOVER_SCRIPTNAME   = "LootDroneMover"
global const string LOOT_DRONE_ROTATOR_SCRIPTNAME = "LootDroneRotator"

global enum eDroneTrailFXType
{
	TRAIL,
	PANIC,
	FALL,

	_count
}

global struct LootDroneData
{
	entity model
	entity mover
	entity rotator
	array<entity> path
	array<vector> pathVec
	entity roller
	entity soundEntity
	vector lastSafeRollerPosition
	float health        = LOOT_DRONE_HEALTH_MAX
	bool __isDead
	float __speed
	float __accel       = LOOT_DRONE_FLIGHT_ACCEL
	float __maxSpeed    = LOOT_DRONE_FLIGHT_SPEED_MAX
	float __panicSpeed  = LOOT_DRONE_FLIGHT_SPEED_PANIC
	bool isPanicking
	float lastPanicTime = 0.0
}

#if CLIENT
global struct LootDroneClientData
{
	entity model
	int trailFXHandle
	int panicFXHandle
	int fallFXHandle
}
#endif


///////////////////////
///////////////////////
//// Private Types ////
///////////////////////
///////////////////////
struct
{
	#if CLIENT
	table<entity, LootDroneClientData> droneToClientData
	#endif
} file


/////////////////////////
/////////////////////////
//// Initialiszation ////
/////////////////////////
/////////////////////////
void function ShLootDrones_Init()
{
	PrecacheModel( LOOT_DRONE_MODEL )
	PrecacheParticleSystem( LOOT_DRONE_FX_TRAIL )
	PrecacheParticleSystem( LOOT_DRONE_FX_TRAIL_PANIC )
	PrecacheParticleSystem( LOOT_DRONE_FX_EXPLOSION )
	PrecacheParticleSystem( LOOT_DRONE_FX_FALL_EXPLOSION )
	PrecacheParticleSystem( LOOT_DRONE_FX_TRAIL_FALL )

	#if SERVER
	AddSpawnCallback( "prop_dynamic", LootDroneSpawned )
	#endif
	#if CLIENT
	AddCreateCallback( "prop_dynamic", LootDroneSpawned )
	#endif
}


//////////////////////////
//////////////////////////
//// Global functions ////
//////////////////////////
//////////////////////////
void function LootDroneSpawned( entity droneEnt )
{
	if ( droneEnt.GetModelName().tolower() != LOOT_DRONE_MODEL.tolower() )
		return

	#if CLIENT
		printf( "LootDroneClientDebug: Adding Drone to Client Data" )
		AddDroneClientData( droneEnt )
	#endif // CLIENT
}

#if CLIENT
void function ServerCallback_AddDroneClientData( entity droneEnt )
{
	printf( "LootDroneClientDebug: ServerCallback_AddDroneClientData" )
	AddDroneClientData( droneEnt )
}

void function AddDroneClientData( entity droneEnt )
{
	if ( droneEnt.GetModelName().tolower() != LOOT_DRONE_MODEL.tolower() )
		return

	if ( droneEnt in file.droneToClientData )
		return

	printf( "LootDroneClientDebug: Adding Clientside Drone Data entry" )
	LootDroneClientData clientData
	clientData.model = droneEnt
	SetLootDroneTrailFX( clientData )

	file.droneToClientData[ droneEnt ] <- clientData
}

LootDroneClientData function GetDroneClientData( entity droneEnt )
{
	Assert( IsValidLootDrone( droneEnt ), "Requested Loot Drone client data from invalid entity!" )
	Assert( (droneEnt in file.droneToClientData), "Requested entity not part of Loot Drone client table!" )

	return file.droneToClientData[ droneEnt ]
}

void function SetLootDroneTrailFX( LootDroneClientData droneData )
{
	entity droneEnt = droneData.model

	int fxId          = GetParticleSystemIndex( LOOT_DRONE_FX_TRAIL )
	int attachIdx     = droneEnt.LookupAttachment( LOOT_DRONE_FX_ATTACH_NAME )
	int trailFXHandle = StartParticleEffectOnEntity( droneEnt, fxId, FX_PATTACH_POINT_FOLLOW, attachIdx )

	droneData.trailFXHandle = trailFXHandle
}

void function ServerCallback_SetLootDroneTrailFXType( entity droneEnt, int trailType )
{
	printf( "LootDroneClientDebug: ServerCallback_SetLootDroneTrailFXType" )
	if ( !IsValidLootDrone( droneEnt ) )
		return

	asset fxAsset
	int fxHandle
	LootDroneClientData clientData = GetDroneClientData( droneEnt )
	switch( trailType )
	{
		case eDroneTrailFXType.PANIC:
			fxAsset = LOOT_DRONE_FX_TRAIL_PANIC
			fxHandle = clientData.panicFXHandle
			break
		case eDroneTrailFXType.FALL:
			fxAsset = LOOT_DRONE_FX_TRAIL_FALL
			fxHandle = clientData.fallFXHandle
			break
		case eDroneTrailFXType.TRAIL:
		default:
			fxAsset = LOOT_DRONE_FX_TRAIL
			fxHandle = clientData.trailFXHandle
	}

	if ( EffectDoesExist( fxHandle ) )
		return

	int fxId = GetParticleSystemIndex( fxAsset )
	int attachIdx = droneEnt.LookupAttachment( ( LOOT_DRONE_FX_ATTACH_NAME ) )
	int trailFXHandle = StartParticleEffectOnEntity( droneEnt, fxId, FX_PATTACH_POINT_FOLLOW, attachIdx )

	switch( trailType )
	{
		case eDroneTrailFXType.PANIC:
			clientData.panicFXHandle = trailFXHandle
			break
		case eDroneTrailFXType.FALL:
			clientData.fallFXHandle = trailFXHandle
			break
		case eDroneTrailFXType.TRAIL:
		default:
			clientData.trailFXHandle = trailFXHandle
	}
}

void function ServerCallback_ClearLootDroneTrailFXType( entity droneEnt, int trailType )
{
	printf( "LootDroneClientDebug: ServerCallback_ClearLootDroneTrailFXType" )

	if ( !IsValidLootDrone( droneEnt ) )
		return

	int fxHandle
	LootDroneClientData clientData = GetDroneClientData( droneEnt )
	switch( trailType )
	{
		case eDroneTrailFXType.TRAIL:
			fxHandle = clientData.trailFXHandle
			break
		case eDroneTrailFXType.PANIC:
			fxHandle = clientData.panicFXHandle
			break
		case eDroneTrailFXType.FALL:
			fxHandle = clientData.fallFXHandle
			break
	}

	if( !EffectDoesExist( fxHandle ) )
		return

	EffectStop( fxHandle, false, true )
}

void function ServerCallback_ClearAllLootDroneFX( entity droneEnt )
{
	printf( "LootDroneClientDebug: ServerCallback_ClearAllLootDroneFX" )
	LootDroneClientData clientData = GetDroneClientData( droneEnt )
	if ( EffectDoesExist( clientData.trailFXHandle ) )
		EffectStop( clientData.trailFXHandle, false, true )
	if ( EffectDoesExist( clientData.panicFXHandle ) )
		EffectStop( clientData.panicFXHandle, false, true )
	if ( EffectDoesExist( clientData.fallFXHandle ) )
		EffectStop( clientData.fallFXHandle, false, true )
}
#endif //

bool function IsValidLootDrone( entity ent )
{
	if ( !IsValid( ent ) )
		return false

	return ent.GetScriptName() == LOOT_DRONE_MODEL_SCRIPTNAME
}

bool function IsValidLootDroneMover( entity ent )
{
	if ( !IsValid( ent ) )
		return false

	string scriptName = ent.GetScriptName()

	if ( scriptName == LOOT_DRONE_MOVER_SCRIPTNAME )
		return true

	if ( scriptName == LOOT_DRONE_ROTATOR_SCRIPTNAME )
		return true

	return false
}
