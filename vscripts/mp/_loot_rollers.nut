// Updated by @CafeFPS

global function InitLootRollers
global function SpawnLootRoller_Parented
global function SpawnLootRoller_NoDispatchSpawn
global const string LOOT_ROLLER_MODEL_SCRIPTNAME   = "LootRollerModel"

struct{
	array<LootData> ItemsTier1
	array<LootData> ItemsTier2
	array<LootData> ItemsTier3
	array<LootData> ItemsTier4
} file

void function InitLootRollers()
{

	file.ItemsTier1 = SURVIVAL_Loot_GetByTier(1)
	file.ItemsTier2 = SURVIVAL_Loot_GetByTier(2)
	file.ItemsTier3 = SURVIVAL_Loot_GetByTier(3)
	file.ItemsTier4 = SURVIVAL_Loot_GetByTier(4)

	PrecacheModel( $"mdl/props/loot_sphere/loot_sphere.rmdl" )

    PrecacheParticleSystem(LOOT_ROLLER_EYE_FX)
    PrecacheParticleSystem(FX_LOOT_ROLLER_EXPLOSION)
}

entity function SpawnLootRoller_Parented( entity drone )
{
    entity roller = SpawnLootRoller_NoDispatchSpawn( drone.GetOrigin(), <0,0,0> )
    roller.SetParent( drone )
    DispatchSpawn( roller )
    return roller
}

entity function SpawnLootRoller_NoDispatchSpawn( vector origin, vector angles )
{
    entity roller = CreateEntity( "prop_physics" )
	roller.SetValueForModelKey( $"mdl/props/loot_sphere/loot_sphere.rmdl" )

    roller.SetScriptName( LOOT_ROLLER_MODEL_SCRIPTNAME )
    roller.SetOrigin(origin)
    roller.SetAngles(angles)

    // Health is handled by callbacks
	roller.SetMaxHealth( 100 )
	roller.SetHealth( 100 )
	roller.SetTakeDamageType( DAMAGE_EVENTS_ONLY )
	AddEntityCallback_OnKilled( roller, LootRollers_OnKilled)
	AddEntityCallback_OnDamaged( roller, LootRollers_OnDamaged)
    roller.kv.CollisionGroup = TRACE_COLLISION_GROUP_NONE
    return roller
}

void function LootRollers_OnKilled(entity ent, var damageInfo)
{
    vector origin = ent.GetOrigin()
	EmitSoundAtPosition( TEAM_ANY, origin, "LootTick_Explosion" )
	
	entity effect = StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex(FX_LOOT_ROLLER_EXPLOSION), origin, <0, 0, 0> )
    EntFireByHandle( effect, "Kill", "", 2, null, null )

	foreach( loot in Flowstate_ReturnDroneLootForCurrentTier( ent ) )
	{
		printt(" Spawning loot in cargobot: " + loot )
		entity lootent = SpawnGenericLoot( loot, origin, <0, 0, 0>, 1 )
		FakePhysicsThrow( null, lootent, <RandomFloatRange(0, 360), RandomFloatRange(0, 360), RandomFloatRange(0, 360)>, -1, true)
	}
}

void function LootRollers_OnDamaged(entity ent, var damageInfo)
{
	if( !IsValid( ent ) )
		return
	
    // Don't get damaged by the drone crashing on it
    if( DamageInfo_GetDamageSourceIdentifier( damageInfo ) == LOOT_DRONE_EXPLOSION_DAMAGEID )
        return
	
	entity attacker = DamageInfo_GetAttacker( damageInfo )

    // Only players can break it
	if( !IsValid( attacker ) || !attacker.IsPlayer() )
		return

	LootDroneData droneData = ReturnDroneDataFromRoller( ent )
	
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
	
	// the following implementation does not work
	// if( Time() > droneData.lastPanicTime + LOOT_DRONE_PANIC_DURATION )
		// LootDrone_Panic( droneData )
	
	// Handle damage, props get destroyed on death, we don't want that.
	float nextHealth = max( 0, ent.GetHealth() - DamageInfo_GetDamage( damageInfo ) ) 
	DamageInfo_SetDamage( damageInfo, 0 )

	if( nextHealth <= 0 )
	{
		if( IsValid( droneData.model ) )
		{
			droneData.model.TakeDamage( LOOT_DRONE_HEALTH_MAX, attacker, null, DamageInfo_GetDamageSourceIdentifier( damageInfo ) )
			droneData.model.SetTakeDamageType( DAMAGE_NO )
			return
		}
	}

	ent.SetHealth(nextHealth)
}

void function LootDrone_Panic( LootDroneData data )
{
	data.lastPanicTime = Time()
	
	entity firstStopMover = CreateTrainSmoothPoint( data.mover.GetOrigin() )

	entity lastNode = data.mover.Train_GetLastNode()
	entity nextMovingNode = lastNode.GetNextTrainNode()
	//Regenerate smooth points until next node
	array< vector > smoothPoints //need to be saved before used cuz then it can't calculate smooth points due to broken link in the progress until the end of the loop. Colombia
	for( int i = 1; i < 10; i++)
	{
		vector smoothPoint = lastNode.GetSmoothPositionAtDistance( data.mover.Train_GetLastDistance() + (Distance2D( data.mover.GetOrigin(), nextMovingNode.GetOrigin() ) / 10 ) * i )
		smoothPoints.append( smoothPoint )
	}
	
	foreach( slink in lastNode.GetLinkEntArray( ) )
	{
		//firstStopMover.LinkToEnt ( slink )
		lastNode.UnlinkFromEnt( slink )
	}
	
	lastNode.LinkToEnt( firstStopMover )

	lastNode = firstStopMover
	entity newNode

	foreach( smoothPoint in smoothPoints )
	{
		newNode = CreateTrainSmoothPoint( smoothPoint )

		newNode.LinkToEnt ( lastNode )
		
		lastNode.LinkToEnt( newNode )
		
		lastNode = newNode
		
		DebugDrawHemiSphere( smoothPoint, Vector( 0,0,0 ), 25.0, 20, 210, 255, false, 999.0 )
	}
	
	//link the last one to next node
	newNode.LinkToEnt( nextMovingNode )
	
	// Important so train can start in same place
	firstStopMover.RegenerateSmoothPoints()

	data.mover.Train_MoveToTrainNodeEx( firstStopMover, 0, LOOT_DRONE_FLIGHT_SPEED_PANIC, LOOT_DRONE_FLIGHT_SPEED_PANIC, LOOT_DRONE_FLIGHT_ACCEL )
	data.mover.Train_AutoRoll( 5.0, 45.0, 1024.0 )
}

entity function CreateTrainSmoothPoint( vector origin )
{
	entity stopMover = CreateEntity( "script_mover_train_node" )
	stopMover.kv.tangent_type = 0
	stopMover.kv.num_smooth_points = 10 // ?? doesn't work
	stopMover.kv.perfect_circular_rotation = 0
	DispatchSpawn( stopMover )
	stopMover.SetOrigin( origin )
	
	return stopMover
}