///////////////////////////////////////////////////////
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
///////////////////////////////////////////////////////

global function InitLootRollers
global function SpawnLootRoller_Parented
global function SpawnDeathbox_Parented
global function SpawnLootRoller_NoDispatchSpawn
global function SpawnFlyerDeathbox_NoDispatchSpawn
global const string LOOT_ROLLER_MODEL_SCRIPTNAME   = "LootRollerModel"

struct{
	array<LootData> ItemsTier1
	array<LootData> ItemsTier2
	array<LootData> ItemsTier3
	array<LootData> ItemsTier4
} file

void function InitLootRollers()
///////////////////////////////////////////////////////
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
///////////////////////////////////////////////////////
{

	file.ItemsTier1 = SURVIVAL_Loot_GetByTier(1)
	file.ItemsTier2 = SURVIVAL_Loot_GetByTier(2)
	file.ItemsTier3 = SURVIVAL_Loot_GetByTier(3)
	file.ItemsTier4 = SURVIVAL_Loot_GetByTier(4)

	if(GetMapName() == "mp_rr_desertlands_64k_x_64k" || GetMapName() == "mp_rr_desertlands_64k_x_64k_nx" )
	{
		PrecacheModel( $"mdl/props/loot_sphere/loot_sphere.rmdl" )
	} else if (GetMapName() == "mp_rr_canyonlands_mu1" || GetMapName() == "mp_rr_canyonlands_mu1_night" || GetMapName() == "mp_rr_canyonlands_64k_x_64k"){
		PrecacheModel( $"mdl/props/death_box/death_box_01.rmdl" )
	}

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

entity function SpawnDeathbox_Parented( entity drone )
///////////////////////////////////////////////////////
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
///////////////////////////////////////////////////////
{
    entity roller = SpawnFlyerDeathbox_NoDispatchSpawn( drone.GetOrigin(), <0,0,0> )
	SetTargetName( roller, DEATH_BOX_TARGETNAME )
	roller.SetParent( drone )
    DispatchSpawn( roller )
    return roller
}

entity function SpawnFlyerDeathbox_NoDispatchSpawn( vector origin, vector angles )
///////////////////////////////////////////////////////
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
///////////////////////////////////////////////////////
{
	entity roller = CreatePropDeathBox_NoDispatchSpawn(DEATH_BOX, origin, angles, 6 )
	roller.kv.fadedist = 50000
    roller.SetOrigin(origin + < -60, 0, -10> ) //Deathbox on flyer origin fix
    roller.kv.CollisionGroup = TRACE_COLLISION_GROUP_NONE
	Highlight_SetNeutralHighlight( roller, "sp_objective_entity" ) //Is this even necessary lol
	Highlight_ClearNeutralHighlight( roller )
	switch(RandomIntRangeInclusive(1,4)) //Reducir la probabilidad para el loottier mayor pls
	{
		case 1:
			Highlight_SetFlyerDeathboxHighlight( roller, SURVIVAL_GetHighlightForTier( 1 ) )
			break
		case 2:
			Highlight_SetFlyerDeathboxHighlight( roller, SURVIVAL_GetHighlightForTier( 2 ) )
			break
		case 3:
			Highlight_SetFlyerDeathboxHighlight( roller, SURVIVAL_GetHighlightForTier( 3 ) )
			break
		case 4:
			Highlight_SetFlyerDeathboxHighlight( roller, SURVIVAL_GetHighlightForTier( 4 ) )
			break
	}
    return roller
}

entity function SpawnLootRoller_NoDispatchSpawn( vector origin, vector angles )
///////////////////////////////////////////////////////
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
///////////////////////////////////////////////////////
{
    entity roller = CreateEntity( "prop_physics" )

	if(GetMapName() == "mp_rr_desertlands_64k_x_64k" && !GetCurrentPlaylistVarBool("flowstateFlyersOverride", false ) || GetMapName() == "mp_rr_desertlands_64k_x_64k_nx" && !GetCurrentPlaylistVarBool("flowstateFlyersOverride", false ))
	{
		roller.SetValueForModelKey( $"mdl/props/loot_sphere/loot_sphere.rmdl" )
	} else if (GetMapName() == "mp_rr_canyonlands_mu1" || GetMapName() == "mp_rr_canyonlands_mu1_night" || GetMapName() == "mp_rr_canyonlands_64k_x_64k" || GetCurrentPlaylistVarBool("flowstateFlyersOverride", false )){
		roller.SetValueForModelKey( $"mdl/props/death_box/death_box_01.rmdl" )
	}

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
///////////////////////////////////////////////////////
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
///////////////////////////////////////////////////////
{
    vector origin = ent.GetOrigin()
	EmitSoundAtPosition( TEAM_ANY, origin, "LootTick_Explosion" )

	entity effect = StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex(FX_LOOT_ROLLER_EXPLOSION), origin, <0, 0, 0> )
    EntFireByHandle( effect, "Kill", "", 2, null, null )
	int j
	if(!GetCurrentPlaylistVarBool("flowstatePROPHUNT", false )){
		if (ent.e.enemyHighlight == "survival_item_common_cargobot")
		{
			for ( j = 0; j < 5; ++j ){
			LootData data3 = file.ItemsTier1[RandomIntRangeInclusive(0,file.ItemsTier1.len()-1)]
			entity loot3 = SpawnGenericLoot( data3.ref, origin, <0, 0, 0>, 1 )
			FakePhysicsThrow( null, loot3, <RandomFloatRange(0, 360), RandomFloatRange(0, 360), RandomFloatRange(0, 360)> )}

		} else if (ent.e.enemyHighlight == "survival_item_rare_cargobot")
		{
			for ( j = 0; j < 3; ++j ){
			LootData data2 = file.ItemsTier2[RandomIntRangeInclusive(0,file.ItemsTier2.len()-1)]
			entity loot2 = SpawnGenericLoot( data2.ref, origin, <0, 0, 0>, 1 )
			FakePhysicsThrow( null, loot2, <RandomFloatRange(0, 360), RandomFloatRange(0, 360), RandomFloatRange(0, 360)> )}
			for ( j = 0; j < 3; ++j ){
			LootData data3 = file.ItemsTier1[RandomIntRangeInclusive(0,file.ItemsTier1.len()-1)]
			entity loot3 = SpawnGenericLoot( data3.ref, origin, <0, 0, 0>, 1 )
			FakePhysicsThrow( null, loot3, <RandomFloatRange(0, 360), RandomFloatRange(0, 360), RandomFloatRange(0, 360)> )}

		} else if (ent.e.enemyHighlight == "survival_item_epic_cargobot")
		{
			LootData data = file.ItemsTier3[RandomIntRangeInclusive(0,file.ItemsTier3.len()-1)]
			entity loot = SpawnGenericLoot( data.ref, origin, <0, 0, 0>, 1 )
			FakePhysicsThrow( null, loot, <RandomFloatRange(0, 360), RandomFloatRange(0, 360), RandomFloatRange(0, 360)> )
			for ( j = 0; j < 3; ++j ){
			LootData data2 = file.ItemsTier2[RandomIntRangeInclusive(0,file.ItemsTier2.len()-1)]
			entity loot2 = SpawnGenericLoot( data2.ref, origin, <0, 0, 0>, 1 )
			FakePhysicsThrow( null, loot2, <RandomFloatRange(0, 360), RandomFloatRange(0, 360), RandomFloatRange(0, 360)> )}
			for ( j = 0; j < 3; ++j ){
			LootData data3 = file.ItemsTier1[RandomIntRangeInclusive(0,file.ItemsTier1.len()-1)]
			entity loot3 = SpawnGenericLoot( data3.ref, origin, <0, 0, 0>, 1 )
			FakePhysicsThrow( null, loot3, <RandomFloatRange(0, 360), RandomFloatRange(0, 360), RandomFloatRange(0, 360)> )}
		}
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