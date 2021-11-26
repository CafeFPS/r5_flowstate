global function LootTicks_Init
global function SpawnLootTick
global function SpawnLootTickAtCrosshair

const asset LOOT_TICK_MODEL = $"mdl/robots/drone_frag/drone_frag_loot.rmdl"
const asset FX_LOOT_TICK_DEATH = $"P_loot_tick_exp_CP"
const asset FX_LOOT_TICK_IDLE = $"P_loot_tick_beam_idle_flash"
const int MAX_LOOT_TICKS_TO_SPAWN = 12

struct
{
	table<entity, array<string> > tickLootInside
} file

void function LootTicks_Init()
{
    PrecacheModel(LOOT_TICK_MODEL)
    PrecacheParticleSystem(FX_LOOT_TICK_DEATH)
    PrecacheParticleSystem(FX_LOOT_TICK_IDLE)

    if(GetCurrentPlaylistVarBool("loot_ticks_enabled", true))
        AddCallback_EntitiesDidLoad( SpawnMultipleLootTicksForMap )
}

void function SpawnMultipleLootTicksForMap()
{
    array<entity> lzEnts = GetEntArrayByClass_Expensive( "info_target" )
    array<entity> tickSpawns
        
    foreach( lzEnt in lzEnts )
    {
        if( lzEnt.GetScriptName() != "static_loot_tick_spawn" )
            continue
        
        tickSpawns.push(lzEnt)
    }
    
    int maxTicksToSpawn = MAX_LOOT_TICKS_TO_SPAWN
    
    if(tickSpawns.len() == 0)
        return
        
    if(tickSpawns.len() < maxTicksToSpawn)
        maxTicksToSpawn = tickSpawns.len()
        
    tickSpawns.randomize()
    
    for(int i = 0; i < maxTicksToSpawn; i++)
    {
        entity lzEnt = tickSpawns[i]
        SpawnLootTick(lzEnt.GetOrigin() + <0, 0, 50>, lzEnt.GetAngles())
    }
}

void function SpawnLootTick(vector origin, vector angles)
{
    entity lootTick = CreateEntity( "npc_frag_drone" )
    SetSpawnOption_AISettings( lootTick, "npc_frag_drone_treasure_tick" )
    lootTick.SetOrigin( origin )
    lootTick.SetAngles( angles )
    lootTick.SetDamageNotifications( false )
    AddEntityCallback_OnDamaged(lootTick, OnLootTickDamaged)
    AddEntityCallback_OnKilled(lootTick, OnLootTickKilled)
    SetTeam(lootTick, TEAM_UNASSIGNED)
    file.tickLootInside[lootTick] <- []
    AddMultipleLootItemsToLootTick(lootTick, ["loottick_static_01", "loottick_static_02", "loottick_static_03"])
    DispatchSpawn( lootTick )   
    thread PlayAnim( lootTick, "sd_closed_to_open" )
    thread LootTickParticleThink(lootTick)
	thread LootTickSoundThink(lootTick)
}

void function LootTickSoundThink(entity ent)
{
    ent.EndSignal( "OnDeath" )
    ent.EndSignal( "OnDestroy" )
    
    while(true)
    {
        int soundIndex = RandomInt( 4 )
        string tickChirp

        switch(soundIndex)
        {
            case 0:
                tickChirp = "LootTick_Vocal_Generic"
                break
            case 1:
                tickChirp = "LootTick_Vocal_Cheerful"
                break
            case 2:
                tickChirp = "LootTick_Vocal_Concerned"
                break
            case 3: 
                tickChirp = "LootTick_Vocal_Curious"
                break
            case 4:
                tickChirp = "LootTick_Vocal_Fleeing"
                break
        }
        EmitSoundOnEntity( ent, tickChirp )
        wait RandomFloatRange(2, 6)
    }
}

int function GetLootTickRarity(entity ent)
{
    if(!IsValid(ent))
        return 0
    
    array<string> lootToSpawn = GetLootTickContents( ent )
    int lootTier  = 0
    foreach ( ref in lootToSpawn )
    {
        LootData lootData = SURVIVAL_Loot_GetLootDataByRef( ref )
        if(lootData.tier > lootTier)
            lootTier = lootData.tier
    }
    return lootTier
}

void function LootTickParticleThink(entity ent)
{
    ent.EndSignal( "OnDeath" )
    ent.EndSignal( "OnDestroy" )
    
    int lootTier = GetLootTickRarity(ent)
    while(true)
    {
        int attachID = ent.LookupAttachment( "FX_L_EYE" )
        entity newFxL = StartParticleEffectOnEntity_ReturnEntity( ent, GetParticleSystemIndex( $"P_loot_tick_beam_idle_flash" ), FX_PATTACH_POINT_FOLLOW, attachID )
        EffectSetControlPointVector( newFxL, 1, GetFXRarityColorForTier(lootTier) )
        
        attachID = ent.LookupAttachment( "FX_C_EYE" )
        entity newFxC = StartParticleEffectOnEntity_ReturnEntity( ent, GetParticleSystemIndex( $"P_loot_tick_beam_idle_flash" ), FX_PATTACH_POINT_FOLLOW, attachID )
        EffectSetControlPointVector( newFxC, 1, GetFXRarityColorForTier(lootTier) )
        
        attachID = ent.LookupAttachment( "FX_R_EYE" )
           
        entity newFxR = StartParticleEffectOnEntity_ReturnEntity( ent, GetParticleSystemIndex( $"P_loot_tick_beam_idle_flash" ), FX_PATTACH_POINT_FOLLOW, attachID )
        EffectSetControlPointVector( newFxR, 1, GetFXRarityColorForTier(lootTier) )
        wait 0.5
        
        if ( IsValid( newFxL ) )
			newFxL.Destroy()
        if ( IsValid( newFxC ) )
			newFxC.Destroy()
        if ( IsValid( newFxR ) )
			newFxR.Destroy()
    }
}

void function OnLootTickDamaged(entity ent, var damageInfo)
{
    DamageInfo_SetDamage( damageInfo, 0 )
    ent.Die()
}

void function OnLootTickKilled(entity ent, var damageInfo)
{
	int expFX = GetParticleSystemIndex( FX_LOOT_TICK_DEATH )
    
    vector pos = ent.GetOrigin()
    int tagID = ent.LookupAttachment( "CHESTFOCUS" )
	vector fxOrg = ent.GetAttachmentOrigin( tagID )
    
	EmitSoundAtPosition( TEAM_ANY, pos, "LootTick_Explosion" )
	CreateShake( pos, 10, 105, 1.25, 768 )
	entity newFx = StartParticleEffectInWorld_ReturnEntity( expFX, fxOrg, <0, 0, 0> )
    EffectSetControlPointVector( newFx, 1, GetFXRarityColorForTier(GetLootTickRarity(ent)) )
    EmitSoundOnEntity( ent, "LootTick_Vocal_Death" )
    
    //Spawn loot
    array<string> lootToSpawn = GetLootTickContents( ent )
    foreach ( ref in lootToSpawn )
    {
        SpawnLootTickLoot( ent, ref )
    }
    
	ent.Gib( <0, 0, 100> ) //Used to do .Destroy() on the frag drones immediately, but this meant you can't display the obiturary correctly. Instead, since it's dead already just hide it
}

void function SpawnLootTickLoot(entity ent, string ref)
{
    vector origin       = ent.GetOrigin() + <0, 0, 10>
    vector angles = ent.GetAngles()
	LootData data = SURVIVAL_Loot_GetLootDataByRef( ref )

	entity loot   = SpawnGenericLoot( ref, origin, angles, data.countPerDrop )
    FakePhysicsThrow( null, loot, <RandomFloatRange(0, 360), RandomFloatRange(0, 360), RandomFloatRange(0, 360)>, true )
}


void function AddMultipleLootItemsToLootTick( entity tick, array<string> refs )
{
	int numRefs = refs.len()
	for ( int i; i < numRefs; i++ )
		AddLootToLootTick( tick, SURVIVAL_GetWeightedItemFromGroup(refs[ i ]) )
}

void function AddLootToLootTick( entity tick, string ref )
{
	file.tickLootInside[ tick ].append( ref )
}

array<string> function GetLootTickContents( entity tick )
{
	for ( int i = file.tickLootInside[ tick ].len() - 1; i >= 0; i-- )
	{
		if ( file.tickLootInside[ tick ][i] == "blank" )
			file.tickLootInside[ tick ].remove( i )
	}

	return file.tickLootInside[ tick ]
}

void function SpawnLootTickAtCrosshair()
{
	entity player = GetPlayerArray()[ 0 ]

	vector origin = GetPlayerCrosshairOrigin( player )
	vector angles = Vector( 0, 0, 0 )

	thread SpawnLootTick(origin, angles)
}