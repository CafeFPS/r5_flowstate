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
	roller.SetMaxHealth( 30 )
	roller.SetHealth( 30 )
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
	entity attacker = DamageInfo_GetAttacker( damageInfo )

    // Don't get damaged by the drone crashing on it
    if( DamageInfo_GetDamageSourceIdentifier( damageInfo ) == LOOT_DRONE_EXPLOSION_DAMAGEID )
        return

    // Only players can break it
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

	// Handle damage, prop_physics doesn't want to lose health somehow even with DAMAGE_YES
	float nextHealth = ent.GetHealth() - DamageInfo_GetDamage( damageInfo )
	ent.SetHealth(nextHealth > 0.0 ? nextHealth : 0.0)
}