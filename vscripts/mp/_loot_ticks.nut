global function LootTicks_Init
global function SpawnLootTick
global function SpawnLootTickAtCrosshair
global function DEV_TpToRandomTick

const asset LOOT_TICK_MODEL = $"mdl/robots/drone_frag/drone_frag_loot.rmdl"
const asset FX_LOOT_TICK_DEATH = $"P_loot_tick_exp_CP"
const asset FX_LOOT_TICK_IDLE = $"P_loot_tick_beam_idle_flash"
const int MAX_LOOT_TICKS_TO_SPAWN = 12

struct
{
	table<entity, array<string> > tickLootInside
	array<entity> lootticks
} file

void function LootTicks_Init()
{
    PrecacheModel(LOOT_TICK_MODEL)
    PrecacheParticleSystem(FX_LOOT_TICK_DEATH)
    PrecacheParticleSystem(FX_LOOT_TICK_IDLE)

    #if SERVER
    if(GetCurrentPlaylistVarBool("loot_ticks_enabled", true) && GameRules_GetGameMode() == SURVIVAL )
        AddCallback_EntitiesDidLoad( SpawnMultipleLootTicksForMap )
    #endif
}

void function SpawnMultipleLootTicksForMap()
{
    array<entity> tickSpawns

    foreach( lzEnt in GetEntArrayByClass_Expensive( "info_target" ) )
    {
        if( lzEnt.GetScriptName() == "static_loot_tick_spawn" )
            tickSpawns.push(lzEnt)
        else continue
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
        SpawnLootTick( lzEnt.GetOrigin() + <0, 0, 50>, Vector( 0, 0, 0 ) )
		#if DEVELOPER
		printt( "spawned tick at " + lzEnt.GetOrigin() )
		#endif
    }
	
	// int j = 0
	foreach( infoTarget in tickSpawns )
	{
		infoTarget.Destroy()
		// printt( "destroyed unused info target ent for lootticks, count: " + j )
		// j++
	}
}

entity function SpawnLootTick(vector origin, vector angles, array<string> Lootpool = ["POI_Ultra","POI_Ultra","POI_Ultra","POI_Ultra"])//["loottick_static_01", "loottick_static_02", "loottick_static_03", "loottick_static_03"])
{
    entity lootTick = CreateEntity( "npc_frag_drone" )
    {
		origin += Vector( 0,0,-50 )
        SetSpawnOption_AISettings( lootTick, "npc_frag_drone_treasure_tick" )
        lootTick.SetOrigin( origin )
        lootTick.SetAngles( angles )
        lootTick.SetDamageNotifications( false )
        SetTeam( lootTick, TEAM_UNASSIGNED)

		entity parentPoint = CreateEntity( "script_mover_lightweight" )
		{
			parentPoint.kv.solid = 0
			parentPoint.SetValueForModelKey( $"mdl/dev/editor_ref.rmdl" )
			parentPoint.kv.SpawnAsPhysicsMover = 0
			parentPoint.SetOrigin( origin )
			parentPoint.SetAngles( angles )
			DispatchSpawn( parentPoint )
			parentPoint.Hide()
			lootTick.SetParent(parentPoint)
		}
        AddEntityCallback_OnDamaged( lootTick, OnLootTickDamaged )
        AddEntityCallback_OnKilled( lootTick, OnLootTickKilled )

        file.tickLootInside[lootTick] <- []
        AddMultipleLootItemsToLootTick( lootTick, Lootpool )

        DispatchSpawn( lootTick )

		// lootTick.SetPhysics( MOVETYPE_FLY ) // doesn't actually make it move, but allows pushers to interact with it
		// lootTick.kv.contents = CONTENTS_PLAYERCLIP | CONTENTS_HITBOX | CONTENTS_BULLETCLIP | CONTENTS_SOLID
		// lootTick.Solid()
		// lootTick.SetCollisionAllowed( true )
		// lootTick.SetCollisionDetailHigh()
    }

	lootTick.EnableNPCFlag( NPC_IGNORE_ALL )
	lootTick.SetNoTarget( true )
	lootTick.EnableNPCFlag( NPC_DISABLE_SENSING )    // don't do traces to look for enemies or players

    thread PlayAnim( lootTick, "sd_closed_to_open" )
    thread LootTickParticleThink( lootTick )
	thread LootTickSoundThink( lootTick )
	file.lootticks.append( lootTick )
    return lootTick
}

void function DEV_TpToRandomTick()
{
	entity player = gp()[0]
	player.SetOrigin( file.lootticks.getrandom().GetOrigin() )
}

void function LootTickSoundThink( entity tick )
{
    tick.EndSignal( "OnDeath" )
    tick.EndSignal( "OnDestroy" )

    while( IsValid( tick ) )
    {
        array<string> ChirpSounds = [
            "LootTick_Vocal_Generic",
            "LootTick_Vocal_Cheerful",
            "LootTick_Vocal_Concerned",
            "LootTick_Vocal_Curious",
            "LootTick_Vocal_Fleeing"
        ]
        string RandomChirp = ChirpSounds[ RandomInt( ChirpSounds.len() ) ]

        EmitSoundOnEntity( tick, RandomChirp )

        wait RandomFloatRange(2, 6)
    }
}

int function GetLootTickRarity( entity tick )
{
    if( !IsValid(tick) )
        return 0

    array<string> lootToSpawn = GetLootTickContents( tick )
    int lootTier  = 0
    foreach ( ref in lootToSpawn )
    {
        LootData lootData = SURVIVAL_Loot_GetLootDataByRef( ref )
        if(lootData.tier > lootTier)
            lootTier = lootData.tier
    }
    return lootTier
}

void function LootTickParticleThink( entity tick )
{
    tick.EndSignal( "OnDeath" )
    tick.EndSignal( "OnDestroy" )

    int lootTier = GetLootTickRarity(tick)
    float ParticleDuration = 0.5
    while( IsValid( tick ) )
    {
        array<entity> FxHandles = [
            PlayFXOnEntity( $"P_loot_tick_beam_idle_flash", tick, "FX_L_EYE" ), // left eye
            PlayFXOnEntity( $"P_loot_tick_beam_idle_flash", tick, "FX_C_EYE" ), // center eye
            PlayFXOnEntity( $"P_loot_tick_beam_idle_flash", tick, "FX_R_EYE" )  // right eye
        ]

        foreach(entity FxHandle in FxHandles)
        {
            EffectSetControlPointVector( FxHandle, 1, GetFXRarityColorForTier(lootTier) )
            EntFireByHandle( FxHandle, "Kill", "", ParticleDuration, null, null )
        }

        wait ParticleDuration
    }
}

void function OnLootTickDamaged( entity tick, var damageInfo )
{
    DamageInfo_SetDamage( damageInfo, 0 )
    tick.Die()
}

void function OnLootTickKilled( entity tick, var damageInfo )
{
    EmitSoundOnEntity( tick, "LootTick_Vocal_Death" )

	EmitSoundAtPosition( TEAM_ANY, tick.GetOrigin(), "LootTick_Explosion" )
	CreateShake( tick.GetOrigin(), 10, 105, 1.25, 768 )

    entity FxHandle = PlayFX( FX_LOOT_TICK_DEATH, tick.GetWorldSpaceCenter() )
    {
        EffectSetControlPointVector( FxHandle, 1, GetFXRarityColorForTier (GetLootTickRarity(tick) ) )
        EntFireByHandle( FxHandle, "Kill", "", 5, null, null )
    }

    //Spawn loot
    foreach ( ref in GetLootTickContents( tick ) )
        SpawnLootTickLoot( tick, ref )

    //Used to do .Destroy() on the frag drones immediately, but this meant you can't display the obiturary correctly. Instead, since it's dead already just hide it
    tick.Gib( <0, 0, 100> )
}

void function SpawnLootTickLoot( entity tick, string ref )
{
	LootData data = SURVIVAL_Loot_GetLootDataByRef( ref )

	entity loot = SpawnGenericLoot( ref, tick.GetOrigin() + <0, 0, 10>, tick.GetAngles(), data.countPerDrop )
    FakePhysicsThrow( null, loot, <RandomFloatRange(0, 360), RandomFloatRange(0, 360), RandomFloatRange(0, 360)>, 5 )
}

void function AddMultipleLootItemsToLootTick( entity tick, array<string> refs )
{
	int numRefs = refs.len()
	for ( int j; j < numRefs; j++ )
	{
		
		for(int i = 0; i < 1; i++)
		{
			string itemRef = SURVIVAL_GetWeightedItemFromGroup( refs[ i ] )
			
			bool weaponalready = false
			foreach( item in file.tickLootInside[ tick ] )
			{
				LootData lootData2 = SURVIVAL_Loot_GetLootDataByRef( item )
				
				if( lootData2.lootType == eLootType.MAINWEAPON )
				{
					weaponalready = true
				}
			}
			LootData lootData = SURVIVAL_Loot_GetLootDataByRef( itemRef )
			
			if( file.tickLootInside[ tick ].contains( itemRef ) )
			{
				i--
				continue
			}
			if( ( lootData.lootType == eLootType.INCAPSHIELD || lootData.lootType == eLootType.BACKPACK || lootData.lootType == eLootType.HELMET ) && lootData.tier <= 2 || lootData.lootType == eLootType.ARMOR )
			{
				i--
				continue
			}
			if( lootData.lootType == eLootType.MAINWEAPON && lootData.tier != 4 || lootData.lootType == eLootType.MAINWEAPON && weaponalready )
			{
				i--
				continue
			}			
			if( lootData.attachmentType == eWeaponAttachmentType.HOPUP || lootData.lootType == eLootType.ATTACHMENT && lootData.tier <= 2 )
			{
				i--
				continue
			}
			
			if( itemRef == "health_pickup_combo_full" )
			{
				i--
				continue
			}
			AddLootToLootTick( tick, itemRef )
		}
		
	}
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
	thread SpawnLootTick( GetPlayerCrosshairOrigin(GetPlayerArray()[ 0 ]) , <0,0,0>)
}