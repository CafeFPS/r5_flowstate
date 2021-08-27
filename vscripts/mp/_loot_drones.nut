//=========================================================
//	_loot_drones.nut
//=========================================================

global function InitLootDrones
global function InitLootDronePaths

global function SpawnLootDrones


//////////////////////
//////////////////////
//// Global Types ////
//////////////////////
//////////////////////
global const string LOOT_DRONE_PATH_NODE_ENTNAME = "loot_drone_path_node"

global const float LOOT_DRONE_START_NODE_SELECTION_MIN_DISTANCE = 50


///////////////////////
///////////////////////
//// Private Types ////
///////////////////////
///////////////////////
struct {
	array<array<entity> > dronePaths

	table<entity, LootDroneData> droneData
} file


/////////////////////////
/////////////////////////
//// Initialiszation ////
/////////////////////////
/////////////////////////
void function InitLootDrones()
{
	RegisterSignal( SIGNAL_LOOT_DRONE_FALL_START )
	RegisterSignal( SIGNAL_LOOT_DRONE_STOP_PANIC )

	FlagInit( "DronePathsInitialized", false )
}

void function InitLootDronePaths()
{
	// Get all drone path nodes (mixed)
	array<entity> dronePathNodes = GetEntArrayByScriptName( LOOT_DRONE_PATH_NODE_ENTNAME )

	// No nodes on this map?
	if ( dronePathNodes.len() == 0 )
	{
		Warning( "%s() - No path nodes of script name %s found! Paths were not initialized.", FUNC_NAME(), LOOT_DRONE_PATH_NODE_ENTNAME )
		return
	}

	// Separate nodes into groups
	while ( dronePathNodes.len() > 0 )
	{
		// Get a random node
		entity node = dronePathNodes.getrandom()

		// Get all nodes associated with it
		array<entity> groupNodes = GetEntityLinkLoop( node )

		// Remove this group's nodes from the list
		foreach ( entity groupNode in groupNodes )
			dronePathNodes.fastremovebyvalue( groupNode )

		// Add the group to the path list
		file.dronePaths.append( groupNodes )
	}

	printf( "DronePaths: found %i paths", file.dronePaths.len() )

	// Mark drone paths as initialized
	FlagSet( "DronePathsInitialized" )
}


//////////////////////////
//////////////////////////
//// Global functions ////
//////////////////////////
//////////////////////////
array<LootDroneData> function SpawnLootDrones( int numToSpawn )
{
	array<LootDroneData> drones

	for ( int i = 0; i < numToSpawn; ++i )
		drones.append( LootDrones_SpawnLootDroneAtRandomPath() )

	return drones
}

//////////////////////////
//////////////////////////
/// Internal functions ///
//////////////////////////
//////////////////////////
array<entity> function LootDrones_GetRandomPath()
{
	Assert( !Flag( "DronePathsInitialized" ), "Trying to get a random path while having uninitialized paths!" )

	return file.dronePaths.getrandom()
}

LootDroneData function LootDrones_SpawnLootDroneAtRandomPath()
{
	LootDroneData data

	array<entity> path = LootDrones_GetRandomPath()
	if ( path.len() == 0 )
	{
		Assert( 0, "Got a random path with no nodes!" )
		return data
	}

	// Get available start node
	entity ornull startNode = LootDrones_GetAvailableStartNodeFromPath( path )

	if ( startNode == null )
	{
		Assert( 0, "Got a random path with no available start node!" )
		return data
	}

	expect entity( startNode )

	// Set path from this start node.
	data.path = GetEntityLinkLoop( startNode )
	foreach ( entity pathNode in data.path )
		data.pathVec.append( pathNode.GetOrigin() )

	// Create the visible drone model using the model const.
	// is this the correct way of doing this?
	entity model = CreatePropDynamic( LOOT_DRONE_MODEL, startNode.GetOrigin(), startNode.GetAngles(), 6 )

	model.SetMaxHealth( LOOT_DRONE_HEALTH_MAX )
	model.SetHealth( LOOT_DRONE_HEALTH_MAX )
	model.SetTakeDamageType( DAMAGE_EVENTS_ONLY )

	AddEntityCallback_OnDamaged( model, LootDrones_OnDamaged) 

	// Set model entity in the struct.
	data.model = model

	// Create script mover for moving. (not for now?)
	data.mover = CreateOwnedScriptMover( model )
	data.mover.DisableHibernation()
	data.model.SetParent( data.mover )
	
	// For easier console access
	// script gp()[0].SetOrigin(Entities_FindByName(null, 'loot_drone').GetOrigin())
	data.mover.kv.targetname = "loot_drone"

	// Use the same mover for rotating.
	data.rotator = data.mover

	// Sound entity should be our mover
	data.soundEntity = data.mover

	// Create and attach loot roller.
	// TODO

	file.droneData[ model ] <- data

	thread LootDroneState( data )
	thread LootDroneMove( data )

	return data
}

entity ornull function LootDrones_GetAvailableStartNodeFromPath( array<entity> path )
{
	foreach ( entity pathNode in path )
	{
		vector nodeOrigin = pathNode.GetOrigin()

		bool suitable = true

		foreach ( entity model, LootDroneData data in file.droneData )
		{
			// Too close?
			if ( Distance( nodeOrigin, model.GetOrigin() ) <= LOOT_DRONE_START_NODE_SELECTION_MIN_DISTANCE )
			{
				// Bail.
				suitable = false
				break
			}
		}

		if ( suitable )
			return pathNode
	}

	return null
}

void function LootDroneState( LootDroneData data )
{
	Assert( IsNewThread(), "Must be threaded off" )

	data.model.EndSignal( "OnDestroy" )
	data.model.EndSignal( "OnDeath" )

	// TODO: Find why idle sound isn't playing, only when spammed and close
	// Doesn't seem to loop either, might be related to a specific entity behavior
	// Could be PVS too.. no clue yet.
	//
	// https://developer.valvesoftware.com/wiki/PVS
	//
	// Train works fine, look into how the train works

	OnThreadEnd(
		function() : ( data )
		{
			if ( IsValid( data.soundEntity ) )
				StopSoundOnEntity( data.soundEntity, LOOT_DRONE_LIVING_SOUND )
		}
	)

	EmitSoundOnEntity( data.soundEntity, LOOT_DRONE_LIVING_SOUND )

	WaitForever()
}

void function LootDroneMove( LootDroneData data )
{
	Assert( IsNewThread(), "Must be threaded off" )
	Assert( data.path.len() > 0, "Path must have at least one node" )

	data.model.EndSignal( "OnDestroy" )
	data.model.EndSignal( SIGNAL_LOOT_DRONE_FALL_START )

	OnThreadEnd( 
		function() : ( data )
		{
			if ( IsValid( data.mover ) )
				data.mover.Train_StopImmediately()
		}
	)

	// Start the movement using the shared constants
	data.mover.Train_MoveToTrainNodeEx( data.path[0], 0, LOOT_DRONE_FLIGHT_SPEED_MAX, LOOT_DRONE_FLIGHT_SPEED_MAX, LOOT_DRONE_FLIGHT_ACCEL )

	// Make the drone roll on turns
	// (rollStrengh, rollMax, lookAheadDist) ? nothing in shared consts, values seem fine just like this.
	data.mover.Train_AutoRoll( 5.0, 45.0, 1024.0 )
	
	WaitForever()
}

// void function LootDroneSound( LootDroneData data )
// {
// 	Assert( IsNewThread(), "Must be threaded off" )

// 	EmitSoundOnEntity( data.model, LOOT_DRONE_LIVING_SOUND )

// 	data.model.WaitSignal( "OnDeath" )

// 	StopSoundOnEntity( data.model, LOOT_DRONE_LIVING_SOUND )
// 	EmitSoundOnEntity( data.model, LOOT_DRONE_DEATH_SOUND )

// 	data.model.WaitSignal( SIGNAL_LOOT_DRONE_FALL_START )

// 	EmitSoundOnEntity( data.model, LOOT_DRONE_CRASHING_SOUND )

// 	data.model.WaitSignal( "OnDestroy" )
	
// 	StopSoundOnEntity( data.model, LOOT_DRONE_CRASHING_SOUND )
// 	EmitSoundOnEntity( data.model, LOOT_DRONE_CRASHED_SOUND )
// }


void function LootDrones_OnDamaged(entity ent, var damageInfo)
{
	entity attacker = DamageInfo_GetAttacker(damageInfo);
	
	if( !IsValid( attacker ) || !attacker.IsPlayer() )
		return
	
	attacker.NotifyDidDamage
	(
		ent,
		DamageInfo_GetHitBox( damageInfo ),
		DamageInfo_GetDamagePosition( damageInfo ), 
		DamageInfo_GetCustomDamageType( damageInfo ),
		DamageInfo_GetDamage( damageInfo ),
		DamageInfo_GetDamageFlags( damageInfo ), 
		DamageInfo_GetHitGroup( damageInfo ),
		DamageInfo_GetWeapon( damageInfo ), 
		DamageInfo_GetDistFromAttackOrigin( damageInfo )
	)

	// Handle damage, props get destroyed on death, we don't want that.
	// Not really needed since it has 1 HP, but we do it anyway.
	float nextHealth = ent.GetHealth() - DamageInfo_GetDamage( damageInfo )
	if( nextHealth > 0 )
	{
		ent.SetHealth(nextHealth)
		return
	}

	// Drone ""died""
	// Don't take damage anymore
	ent.SetTakeDamageType( DAMAGE_NO )
	ent.Signal( SIGNAL_LOOT_DRONE_FALL_START )

	EmitSoundOnEntity( ent, LOOT_DRONE_DEATH_SOUND )
	EmitSoundOnEntity( ent, LOOT_DRONE_CRASHING_SOUND )

	entity effect = StartParticleEffectOnEntity_ReturnEntity
	( 
		ent, 
		GetParticleSystemIndex( LOOT_DRONE_FX_FALL_EXPLOSION ), 
		FX_PATTACH_ABSORIGIN_FOLLOW, 0 
	)
	// Kill the particles after a few secs, entity stays in the map indefinitely it seems
	EntFireByHandle( effect, "Kill", "", 2, null, null )

	// TODO: Make the drone crash and kill it when it lands
	// Use the attacker to damage other players so they get credits for it
	// Make sure to kill the rest of the entities from the data struct

	// TEMP removeal
	thread( 
		void function() : (ent)
		{
			wait 2
			ent.Destroy()
		}
	)()
}