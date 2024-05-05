global function Construct_MapInit_Common

global enum e_weaponClassToTag
{
	pistol = 0
	assault = 1
	shotgun = 2
	lmg = 3
	sniper = 4
	smg = 5
	launcher = 6
    marksman = 7
}

struct RackGroup
{
	entity point = null
	string ammoType = ""
	array<entity> racks = []
}

void function Construct_MapInit_Common() {
    printt("[Construct] MapInit_Common")

    FlagInit("PlayConveyerStartFX", true)
    //RegisterNetwork*edVariable( "IsPlayerInWater", SNDC_PLAYER_EXCLUSIVE, SNVT_BOOL, false )
    //RegisterNetworkedVariable( "IsPlayerInWater", SNDC_PLAYER_GLOBAL, SNVT_BOOL, false )

    AddCallback_EntitiesDidLoad( EntitiesDidLoad )

    #if SERVER
    SURVIVAL_SetPlaneHeight( -15327 )
    SURVIVAL_SetAirburstHeight( 2500 )
    SURVIVAL_SetMapCenter( <23500.00,19463.00,-18068.11> )

    if( IsDevGamemode() )
    {
        AddSpawnCallback("prop_death_box", OnObjectSpawned )
        AddSpawnCallback("prop_survival", OnObjectSpawned )
        AddCallback_OnClientConnected( OnPlayerRespawned )
        AddCallback_OnPlayerKilled( OnPlayerKilled )
    }

    thread function() : ()
    {
        while(true)
        {
            foreach(entity p in GetPlayerArray())
            {
                if( IsValid( p ) && !IsAlive( p ))
                    thread DevRespawnPlayer( p, false )

            }
            wait 5
        }

    }()

    AiDrone_Init()

    SetVictorySequencePlatformModel($"mdl/dev/empty_model.rmdl", < 0, 0, -10 > , < 0, 0, 0 > )


    #elseif CLIENT

    SetVictorySequenceLocation( <29582.457, 8460.06055, -17332.5371> , < 0, 45, 0 > )
    SetVictorySequenceSunSkyIntensity(1.0, 0.5)

    Freefall_SetPlaneHeight( -15327)
    Freefall_SetDisplaySeaHeightForLevel( -15327 )
    SetMinimapBackgroundTileImage($"overviews/mp_rr_canyonlands_bg")

    #endif

    PrecacheModel( $"mdl/vistas/canyonlands_drop_se.rmdl" )
    PrecacheModel( $"mdl/vistas/canyonlands_night_se.rmdl" )
    PrecacheModel( $"mdl/vistas/desertlands_se.rmdl" )

    PrecacheModel( $"mdl/robots/drone_frag/drone_frag_loot.rmdl" )
    PrecacheModel( $"mdl/containers/underbelly_cargo_container_128_blue_01.rmdl" )
    PrecacheModel( $"mdl/dev/editor_ambient_generic_node.rmdl" )
    PrecacheModel( $"mdl/foliage/grass_02_desert_large.rmdl" )
    PrecacheModel( $"mdl/foliage/grass_desert_02.rmdl" )
    PrecacheModel( $"mdl/eden/eden_electrical_bushing_01.rmdl" )
    PrecacheModel( $"mdl/canyonlands/godray_small_orange_01.rmdl" )
    PrecacheModel( $"mdl/mendoko/mendoko_rubber_floor_01.rmdl" )
    PrecacheModel( $"mdl/mendoko/mendoko_rubber_floor_04.rmdl" )
    PrecacheModel( $"mdl/desertlands/wall_city_pillar_concrete_01.rmdl" )
    PrecacheModel( $"mdl/military_base/militaryfort_wall_concrete_02_b.rmdl" )
    PrecacheModel( $"mdl/dev/editor_cover_stand.rmdl" )
	PrecacheModel( $"mdl/rocks/desertlands_sulfur_lake_crust_01.rmdl" )
	PrecacheModel( $"mdl/rocks/desertlands_sulfur_rock_05.rmdl" )
	PrecacheModel( $"mdl/levels_terrain/mp_rr_desertlands/desertlands_terrain_section_08_water_2.rmdl" )
	PrecacheModel( $"mdl/creatures/leviathan/leviathan_kingscanyon_preview_animated.rmdl" )
    PrecacheModel( $"mdl/imc_base/imc_portable_int_floor_128x128_01.rmdl" )
    PrecacheModel( $"mdl/thunderdome/survival_modular_flexscreens_04.rmdl" )
    PrecacheModel( $"mdl/dev/mp_spawn.rmdl" )
    PrecacheModel( $"mdl/military_base/militaryfort_wall_rooftop_01.rmdl" )


    PrecacheModel( $"mdl/humans/class/medium/pilot_medium_generic.rmdl" )
    PrecacheModel( $"mdl/Humans/class/medium/pilot_medium_bangalore.rmdl" )
    PrecacheModel( $"mdl/humans/class/medium/pilot_medium_bloodhound.rmdl" )
    PrecacheModel( $"mdl/humans/class/heavy/pilot_heavy_caustic.rmdl" )
    PrecacheModel( $"mdl/Humans/class/medium/pilot_medium_crypto.rmdl" )
    PrecacheModel( $"mdl/humans/class/heavy/pilot_heavy_gibraltar.rmdl" )
    PrecacheModel( $"mdl/humans/class/light/pilot_light_support.rmdl" )
    PrecacheModel( $"mdl/humans/class/medium/pilot_medium_holo.rmdl" )
    PrecacheModel( $"mdl/Humans/class/medium/pilot_medium_stim.rmdl" )
    PrecacheModel( $"mdl/humans/class/heavy/pilot_heavy_pathfinder.rmdl" )
    PrecacheModel( $"mdl/Humans/class/light/pilot_light_wattson.rmdl" )
    PrecacheModel( $"mdl/humans/class/light/pilot_light_wraith.rmdl" )


    PrecacheModel( $"mdl/creatures/spider/spider.rmdl" )
    PrecacheModel( $"mdl/Creatures/prowler/prowler_apex.rmdl" )

    PrecacheParticleSystem( $"P_3P_stim_liquid_splash" )

    #if SERVER
    SetConVarInt( "prevent_ammo_suck", 1 )
    #endif

    #if CLIENT
    SetConVarInt( "r_drawWorldMeshes", 0 )
    SetConVarInt( "r_lod", 0 )
    SetConVarFloat( "mat_envmap_scale", 0.25 )
    SetConVarInt( "shadow_esm_enable", 1 )

    AddCallback_OnPlayerDisconnected(
        void function( entity CPlayer) : ()
        {
            SetConVarToDefault( "r_drawWorldMeshes" )
            SetConVarToDefault( "dof_overrideParams" )
            SetConVarToDefault( "dof_farDepthStart" )
            SetConVarToDefault( "dof_farDepthEnd" )
            SetConVarToDefault( "mat_envmap_scale" )
            SetConVarToDefault( "shadow_esm_enable" )
        })
    #endif

    PrecacheWeapon("mp_weapon_nessy97")
    // PrecacheWeapon("mp_weapon_mobile_hmg")

}


void function  EntitiesDidLoad() {
    printt("[Construct] CLIENT & SERVER : EntitiesDidLoad")
    thread Spawn_MP_Construct()
}

void function Spawn_MP_Construct()
{
    thread Construct_MAPDATA()
#if SERVER
    printt("[Construct] Server : Spawned Data")
#endif
}

#if SERVER

void function OnObjectSpawned( entity ent)
{
    thread( void function() : ( ent )
    {
        wait 3

        if( !IsValid(ent) ) return

        entity par = ent.GetParent()
        if ( IsValid( ent ) && IsValid( par ) && par.GetClassName() == "prop_physics" || ent.GetClassName() == "prop_death_box")
            ent.Dissolve(ENTITY_DISSOLVE_CORE, < 0, 0, 0 > , 200)
    }())
}


void function OnPlayerKilled( entity victim, entity attacker, var damageInfo)
{
    thread function() : ( victim )
    {
        while ( IsValid( victim ) && !IsAlive( victim ) )
            WaitFrame()

        OnPlayerRespawned( victim )
    }()
}

void function OnPlayerRespawned( entity player ) {

    if( IsDevGamemode() && IsValid( player ) && GetPlaylistVarBool( GetCurrentPlaylistName(), "respawn_players", true ))
    {
        /*
        entity weapon = player.GetNormalWeapon( 0 )
        if( IsValid( weapon ) )
            player.TakeWeaponByEntNow( weapon )

        entity primary = player.GiveWeapon("mp_weapon_3030", 0 )
        primary.SetMods( [] )

        weapon = player.GetNormalWeapon( 1 )
        if( IsValid( weapon ) )
            player.TakeWeaponByEntNow( weapon )

        entity secondary = player.GiveWeapon("mp_weapon_throwingknife", 1 )
        secondary.SetMods( [] )

        player.SetActiveWeaponBySlot( eActiveInventorySlot.mainHand, 0 )

        table PLAYER_SETTINGS_DEFAULT = {
            ["doublejump"] = 1,
            ["wallrun"] = 1,
        }

        SetPlayerSettings(player, PLAYER_SETTINGS_DEFAULT)
        */


        player.SetOrigin( GetEnt("info_player_start").GetOrigin() )
        player.SetAngles( GetEnt("info_player_start").GetAngles() )
    }
}
#endif
