// Open this with a code viewer software

//////////////////////////////////////////////////////
//Flow State DM
//By Retículo Endoplasmático#5955
//& michae\l/#1125
//& AyeZee#6969
///////////////////////////////////////////////////////

global function _CustomTDM_Init
global function _RegisterLocation
global function CreateAnimatedLegend
table playersInfo
const int chatLines = 3
int currentChatLine = 0
string currentChat = ""
enum eTDMState
{
	IN_PROGRESS = 0
	NEXT_ROUND_NOW = 1
}

struct {
	string scriptversion = "v2.3"
    int tdmState = eTDMState.IN_PROGRESS
    int nextMapIndex = 0
	bool mapIndexChanged = true
	array<entity> playerSpawnedProps
	array<ItemFlavor> characters
	float lastTimeChatUsage
	float lastKillTimer
	entity lastKiller
	int SameKillerStoredKills=0
	
	array<string> whitelistedWeapons
	array<LocationSettings> locationSettings
    LocationSettings& selectedLocation
    entity bubbleBoundary
	entity previousChampion
	entity previousChallenger
	int deathPlayersCounter=0
	int maxPlayers
	int maxTeams

	string Hoster
	string admin1
	string admin2
	string admin3
	string admin4
	
	string tempBanned1
	string tempBanned2
	string tempBanned3
	
	int randomprimary
    int randomsecondary
    int randomult
    int randomtac

    entity supercooldropship
	bool isshipalive = false
	array<LocationSettings> droplocationSettings
    LocationSettings& dropselectedLocation
} file

struct PlayerInfo
{
	string name
	int team
	int score
	int deaths
	float kd
	int damage
	int lastLatency
}

// ██████   █████  ███████ ███████     ███████ ██    ██ ███    ██  ██████ ████████ ██  ██████  ███    ██ ███████
// ██   ██ ██   ██ ██      ██          ██      ██    ██ ████   ██ ██         ██    ██ ██    ██ ████   ██ ██
// ██████  ███████ ███████ █████       █████   ██    ██ ██ ██  ██ ██         ██    ██ ██    ██ ██ ██  ██ ███████
// ██   ██ ██   ██      ██ ██          ██      ██    ██ ██  ██ ██ ██         ██    ██ ██    ██ ██  ██ ██      ██
// ██████  ██   ██ ███████ ███████     ██       ██████  ██   ████  ██████    ██    ██  ██████  ██   ████ ███████


void function PrecacheCustomMapsProps()
{
if(GetMapName() == "mp_rr_desertlands_64k_x_64k" || GetMapName() == "mp_rr_desertlands_64k_x_64k_nx"){	
CreateAnimatedLegend($"mdl/humans/class/light/pilot_light_wraith.rmdl",<8443, 4459, -4293>,<0, 0, 0>, 0, 2)
CreateAnimatedLegend($"mdl/humans/class/light/pilot_light_support.rmdl",<11238, 4238,-4293>,<0, -90, 0>, 0, 2)
CreateAnimatedLegend($"mdl/humans/class/heavy/pilot_heavy_pathfinder.rmdl",<12099, 6976,-4350>,<0, -90, 0>,  0, 2)

Spawnwatingroomlegends()

//surf
PrecacheModel( $"mdl/robots/marvin/marvin_gladcard.rmdl" )
PrecacheModel( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl" )
PrecacheModel( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl" )
PrecacheModel( $"mdl/desertlands/desertlands_lobby_sign_01.rmdl" )
PrecacheModel( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl" )
PrecacheModel( $"mdl/benches/bench_single_modern_dirty.rmdl" )
PrecacheModel( $"mdl/mendoko/mendoko_handscanner_01_dmg.rmdl" )
PrecacheModel( $"mdl/angel_city/vending_machine.rmdl" )
PrecacheModel( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl" )
PrecacheModel( $"mdl/desertlands/research_station_stairs_big_building_01.rmdl" )
PrecacheModel( $"mdl/signs/street_sign_arrow.rmdl" )
PrecacheModel( $"mdl/signs/Sign_no_tresspasing.rmdl" )
PrecacheModel( $"mdl/lamps/halogen_light_ceiling.rmdl" )
PrecacheModel( $"mdl/utilities/halogen_lightbulb_case.rmdl" )
PrecacheModel( $"mdl/utilities/halogen_lightbulbs.rmdl" )
//skill trainer
PrecacheModel( $"mdl/lamps/warning_light_ON_red.rmdl" )
PrecacheModel( $"mdl/desertlands/construction_bldg_platform_01.rmdl" )
PrecacheModel( $"mdl/desertlands/construction_bldg_platform_02.rmdl" )
PrecacheModel( $"mdl/colony/farmland_domicile_table_02.rmdl" )
PrecacheModel( $"mdl/fx/turret_shield_wall_02.rmdl" )
PrecacheModel( $"mdl/fx/bb_shield_p4.rmdl" )
PrecacheModel( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl" )
PrecacheModel( $"mdl/colony/farmland_crate_md_80x64x72_03.rmdl" )
PrecacheModel( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl" )
PrecacheModel( $"mdl/desertlands/industrial_cargo_container_320_01_open.rmdl" )
PrecacheModel( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl" )
PrecacheModel( $"mdl/domestic/cigarette_cluster.rmdl" )
PrecacheModel( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl" )
PrecacheModel( $"mdl/vehicles_r5/land/msc_truck_mod_lrg/veh_land_msc_truck_mod_police_lrg_01_closed_static.rmdl" )
PrecacheModel( $"mdl/vehicles_r5/land/msc_suv_partum/veh_land_msc_suv_partum_static.rmdl" )
PrecacheModel( $"mdl/barriers/concrete/concrete_barrier_01.rmdl" )
PrecacheModel( $"mdl/foliage/icelandic_moss_grass_02.rmdl" )
PrecacheModel( $"mdl/foliage/desertlands_alien_tree_leaf_small_01.rmdl" )
PrecacheModel( $"mdl/foliage/desertlands_alien_tree_leaf_small_01.rmdl" )
PrecacheModel( $"mdl/foliage/brute_small_tiger_plant_02.rmdl" )
PrecacheModel( $"mdl/floating_village/lagoon_window_metal_shutters_open_80x128.rmdl" )
PrecacheModel( $"mdl/foliage/tree_brush_yellow_large_03.rmdl" )
PrecacheModel( $"mdl/foliage/icelandic_ground_plant_02.rmdl" )
PrecacheModel( $"mdl/desertlands/industrial_cargo_container_small_03.rmdl" )
PrecacheModel( $"mdl/foliage/desertlands_alien_tree_leaf_small_02.rmdl" )
PrecacheModel( $"mdl/vehicle/goblin_dropship/goblin_dropship_holo.rmdl" )
PrecacheModel( $"mdl/foliage/desertlands_alien_tree_large_root_01.rmdl" )
PrecacheModel( $"mdl/desertlands/research_station_small_building_floor_01.rmdl" )
PrecacheModel( $"mdl/desertlands/industrial_cargo_container_small_01.rmdl" )
PrecacheModel( $"mdl/desertlands/industrial_cargo_container_small_02.rmdl" )
PrecacheModel( $"mdl/desertlands/research_station_stairs_bend_01.rmdl" )
PrecacheModel( $"mdl/desertlands/research_station_stairs_corner_02.rmdl" )
PrecacheModel( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl" )
PrecacheModel( $"mdl/pipes/slum_pipe_large_yellow_512_01.rmdl" )
PrecacheModel( $"mdl/foliage/grass_icelandic_04.rmdl" )
PrecacheModel( $"mdl/foliage/grass_icelandic_03.rmdl" )
PrecacheModel( $"mdl/foliage/desertlands_alien_tree_02.rmdl" )
PrecacheModel( $"mdl/barriers/concrete/concrete_barrier_fence.rmdl" )
PrecacheModel( $"mdl/foliage/desertlands_alien_tree_large_root_01.rmdl" )
PrecacheModel( $"mdl/desertlands/research_station_small_building_floor_01.rmdl" )
PrecacheModel( $"mdl/desertlands/research_station_container_big_01.rmdl" )
PrecacheModel( $"mdl/IMC_base/cargo_container_imc_01_white_open.rmdl" )
PrecacheModel( $"mdl/IMC_base/cargo_container_imc_01_red.rmdl" )
PrecacheModel( $"mdl/IMC_base/cargo_container_imc_01_blue.rmdl" )
PrecacheModel( $"mdl/fx/medic_shield_wall.rmdl" )
PrecacheModel( $"mdl/industrial/traffic_cone_01.rmdl" )
PrecacheModel( $"mdl/foliage/icelandic_moss_grass_01.rmdl" )
PrecacheModel( $"mdl/foliage/plant_tobacco_large_03.rmdl" )
PrecacheModel( $"mdl/foliage/plant_tropical_ground_leafy_01.rmdl" )
PrecacheModel( $"mdl/foliage/plant_agave_01.rmdl" )
PrecacheModel( $"mdl/foliage/tree_brush_yellow_large_03.rmdl" )
PrecacheModel( $"mdl/foliage/tree_acacia_small_03.rmdl" )
PrecacheModel( $"mdl/foliage/holy_e_ear_plant.rmdl" )
PrecacheModel( $"mdl/haven/haven_bamboo_tree_02.rmdl" )
PrecacheModel( $"mdl/garbage/trash_can_metal_02_b.rmdl" )
PrecacheModel( $"mdl/garbage/trash_bin_single_wtrash_Blue.rmdl" )
PrecacheModel( $"mdl/garbage/garbage_bag_plastic_a.rmdl" )
PrecacheModel( $"mdl/industrial/cafe_coffe_machine.rmdl" )
PrecacheModel( $"mdl/industrial/construction_materials_cart_03.rmdl" )
PrecacheModel( $"mdl/industrial/landing_mat_metal_03_large.rmdl" )
PrecacheModel( $"mdl/lamps/warning_light_ON_red.rmdl" )
PrecacheModel( $"mdl/props/death_box/death_box_01_gladcard.rmdl" )
PrecacheModel( $"mdl/rocks/rock_lava_cluster_desertlands_03.rmdl" )
PrecacheModel( $"mdl/garbage/trash_bin_single_wtrash.rmdl" )
PrecacheModel( $"mdl/industrial/traffic_barrel_02.rmdl" )
PrecacheModel( $"mdl/garbage/dumpster_dirty_open_a_02.rmdl" )
PrecacheModel( $"mdl/vehicles_r5/land/msc_truck_samson_v2/veh_land_msc_truck_samson_v2.rmdl" )
PrecacheModel( $"mdl/vehicles_r5/land/msc_suv_partum/veh_land_msc_suv_partum_static.rmdl" )
PrecacheModel( $"mdl/vehicles_r5/land/msc_forklift_imc_v2/veh_land_msc_forklift_imc_v2_static.rmdl" )
PrecacheModel( $"mdl/water/water_puddle_decal_01.rmdl" )
PrecacheModel( $"mdl/containers/container_medium_tanks_blue.rmdl" )
PrecacheModel( $"mdl/containers/lagoon_roof_tanks_02.rmdl" )
PrecacheModel( $"mdl/IMC_base/cargo_container_imc_01_blue.rmdl" )
PrecacheModel( $"mdl/pipes/slum_pipe_large_blue_512_01.rmdl" )
PrecacheModel( $"mdl/thaw/thaw_rock_horizontal_01.rmdl" )
PrecacheModel( $"mdl/vehicle/dropship/dropship_afterburner.rmdl" )
}
}

void function Spawnwatingroomlegends()
{
	CreateAnimatedLegend($"mdl/humans/class/light/pilot_light_support.rmdl", <-19715,1573,6480>, <0,77,0>)
}


void function _CustomTDM_Init()
{
	file.Hoster = FlowState_Hoster()
	file.admin1 = FlowState_Admin1()
	file.admin2 = FlowState_Admin2()
	file.admin3 = FlowState_Admin3()
	file.admin4 = FlowState_Admin4()
	PrecacheCustomMapsProps()
	AddCallback_OnClientConnected( void function(entity player) { thread _OnPlayerConnected(player) } )
	AddCallback_OnPlayerKilled(void function(entity victim, entity attacker, var damageInfo) {thread _OnPlayerDied(victim, attacker, damageInfo)})
	AddClientCommandCallback("god", ClientCommand_God)
	AddClientCommandCallback("ungod", ClientCommand_UnGod)
	AddClientCommandCallback("next_round", ClientCommand_NextRound)
	AddClientCommandCallback("scoreboard", ClientCommand_Scoreboard)
	AddClientCommandCallback("latency", ClientCommand_ShowLatency)
	AddClientCommandCallback("adminsay", ClientCommand_AdminMsg)
	AddClientCommandCallback("commands", ClientCommand_Help)
	AddClientCommandCallback("spectate", ClientCommand_SpectateEnemies)
	AddClientCommandCallback("teambal", ClientCommand_RebalanceTeams)
	AddClientCommandCallback("circlenow", ClientCommand_CircleNow)

	if(FlowState_AllChat()){
		AddClientCommandCallback("say", ClientCommand_ClientMsg)
		//3 slots ingame chat temp-bans. Usage: sayban 1 ColombiaFPS. sayunban 1
		AddClientCommandCallback("sayban", ClientCommand_ChatBan)
		AddClientCommandCallback("sayunban", ClientCommand_ChatUnBan)
	}

	if ( FlowState_AdminTgive() ){
	AddClientCommandCallback("admintgive", ClientCommand_GiveWeapon)
	} else {

    if( CMD_GetTGiveEnabled() )
    {
        AddClientCommandCallback("tgive", ClientCommand_GiveWeapon)
    } }

	// Whitelisted weapons
    for(int i = 0; GetCurrentPlaylistVarString("whitelisted_weapon_" + i.tostring(), "~~none~~") != "~~none~~"; i++)
    {
        file.whitelistedWeapons.append(GetCurrentPlaylistVarString("whitelisted_weapon_" + i.tostring(), "~~none~~"))
    }

	if(GetMapName() == "mp_rr_desertlands_64k_x_64k" || GetMapName() == "mp_rr_desertlands_64k_x_64k_nx" || GetMapName() == "mp_rr_canyonlands_mu1" || GetMapName() == "mp_rr_canyonlands_mu1_night" || GetMapName() == "mp_rr_canyonlands_64k_x_64k")
	{
		thread CreateShipRoomFallTriggers()
	}

    thread RunTDM() //Go to Game Loop
    }

void function _RegisterLocation(LocationSettings locationSettings)
{
    file.locationSettings.append(locationSettings)
    file.droplocationSettings.append(locationSettings)
}

LocPair function _GetVotingLocation()
///////////////////////////////////////////////////////
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
///////////////////////////////////////////////////////
{
     switch(GetMapName())
    {
        case "mp_rr_canyonlands_staging":
             return NewLocPair(<26794, -6241, -27479>, <0, 0, 0>)
        case "mp_rr_canyonlands_64k_x_64k":
			return NewLocPair(<-19459, 2127, 18404>, <0, 180, 0>)
        case "mp_rr_canyonlands_mu1":
        case "mp_rr_canyonlands_mu1_night":
		    return NewLocPair(<-19459, 2127, 18404>, <0, 180, 0>)
        case "mp_rr_desertlands_64k_x_64k":
        case "mp_rr_desertlands_64k_x_64k_nx":
			//return NewLocPair(<-8846, -30401, 2496>, <0, 60, 0>)
			return NewLocPair(<-19459, 2127, 6404>, <0, 180, 0>)
        default:
            Assert(false, "No voting location for the map!")
    }
    unreachable
}

void function _OnPropDynamicSpawned(entity prop)
{
    file.playerSpawnedProps.append(prop)
}

LocPair function _GetAppropriateSpawnLocation(entity player)
{
    bool needSelectRespawn = true
    if(!IsValid(player))
    {
        needSelectRespawn = false
    }
    int ourTeam = 0;

    if(needSelectRespawn)
    {
        ourTeam = player.GetTeam()
    }
    LocPair selectedSpawn = _GetVotingLocation()
    switch(GetGameState())
    {
    case eGameState.MapVoting:
        selectedSpawn = _GetVotingLocation()
        break
    case eGameState.Playing:
        float maxDistToEnemy = 0
        foreach(spawn in file.selectedLocation.spawns)
        {
			if (needSelectRespawn)
            {
            vector enemyOrigin = GetClosestEnemyToOrigin(spawn.origin, ourTeam)
            float distToEnemy = Distance(spawn.origin, enemyOrigin)

            if(distToEnemy > maxDistToEnemy)
            {
                maxDistToEnemy = distToEnemy
                selectedSpawn = spawn
            }
        }
		else
            {
               selectedSpawn = spawn
            }
        }
        break

    }
    return selectedSpawn
}

vector function GetClosestEnemyToOrigin(vector origin, int ourTeam)
{
    float minDist = -1
    vector enemyOrigin = <0, 0, 0>

    foreach(player in GetPlayerArray_Alive())
    {
        if(player.GetTeam() == ourTeam) continue

        float dist = Distance(player.GetOrigin(), origin)
        if(dist < minDist || minDist < 0)
        {
            minDist = dist
            enemyOrigin = player.GetOrigin()
        }
    }

    return enemyOrigin
}

void function DestroyPlayerProps()
{
    foreach(prop in file.playerSpawnedProps)
    {
        if(IsValid(prop))
            prop.Destroy()
    }
    file.playerSpawnedProps.clear()
}

void function _OnPlayerConnected(entity player)
///////////////////////////////////////////////////////
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
///////////////////////////////////////////////////////
{
    if(!IsValid(player)) return
    GivePassive(player, ePassives.PAS_PILOT_BLOOD)
    if(!IsAlive(player))
    {
        _HandleRespawn(player)
			ClearInvincible(player)
    }
	string nextlocation = file.selectedLocation.name
		Message(player,"WELCOME TO FLOW STATE", helpMessage(), 15)
	GrantSpawnImmunity(player,2)
	    switch(GetGameState())
    {
    case eGameState.MapVoting:
	    if(IsValidPlayer(player) )
        {
			player.SetThirdPersonShoulderModeOn()
			HolsterAndDisableWeapons( player )
			player.UnforceStand()
			player.UnfreezeControlsOnServer()
		}
		break
	case eGameState.WaitingForPlayers:
        player.FreezeControlsOnServer()
        break
    case eGameState.Playing:
	    if(IsValidPlayer(player))
        {
		player.UnfreezeControlsOnServer();
        Remote_CallFunction_NonReplay(player, "ServerCallback_TDM_DoAnnouncement", 1, eTDMAnnounce.ROUND_START)
		}
        break
    default:
        break
    }
}

void function _OnPlayerDied(entity victim, entity attacker, var damageInfo)
///////////////////////////////////////////////////////
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
///////////////////////////////////////////////////////
{
	entity champion = file.previousChampion
	entity challenger = file.previousChallenger
	entity killeader = GetBestPlayer()
	float doubleKillTime = 5.0
	float tripleKillTime = 9.0
	file.deathPlayersCounter++
	file.SameKillerStoredKills++
	if(file.deathPlayersCounter == 1)
	{
	foreach (player in GetPlayerArray())
	{
	thread EmitSoundOnEntityExceptToPlayer( player, player, "diag_ap_aiNotify_diedFirst" )
	}
	}

	if(Time() - file.lastKillTimer < doubleKillTime && attacker == file.lastKiller && attacker == killeader){
	foreach (player in GetPlayerArray())
	{
	thread EmitSoundOnEntityOnlyToPlayer( player, player, "diag_ap_aiNotify_killLeaderDoubleKill" )
	}
	file.SameKillerStoredKills++
	}
	
	if(Time() - file.lastKillTimer < tripleKillTime && attacker == file.lastKiller && attacker == killeader && file.SameKillerStoredKills == 3){
	file.SameKillerStoredKills = 0
	wait 3
	foreach (player in GetPlayerArray())
	{
	thread EmitSoundOnEntityOnlyToPlayer( player, player, "diag_ap_aiNotify_killLeaderTripleKill" )
	}

	}

	switch(GetGameState())
    {
    case eGameState.Playing:
        // Víctima
        void functionref() victimHandleFunc = void function() : (victim, attacker, damageInfo) {

			if(!IsValid(victim)) return
			victim.p.storedWeapons = StoreWeapons(victim)
			int reservedTime = 2
            wait reservedTime
			try{
			if(Spectator_GetReplayIsEnabled() && IsValid(victim) && ShouldSetObserverTarget( attacker ))
            {
                victim.SetObserverTarget( attacker )
                victim.SetSpecReplayDelay( Spectator_GetReplayDelay() )
                victim.StartObserverMode( OBS_MODE_IN_EYE )
				Remote_CallFunction_NonReplay(victim, "ServerCallback_KillReplayHud_Activate")
            }
			} catch (e) {}
			try{
            if(IsValid(attacker) && attacker.IsPlayer())
            {
                Remote_CallFunction_NonReplay(attacker, "ServerCallback_TDM_PlayerKilled")
            }} catch (e1) {}
			wait max(0, Deathmatch_GetRespawnDelay() - reservedTime)
			try{
			if(IsValid(victim) )
			{
				int invscore = victim.GetPlayerGameStat( PGS_DEATHS );
				invscore++;

				//Add a death to the victim
                int invscore2 = victim.GetPlayerNetInt( "assists" )
				invscore2++;
				victim.SetPlayerNetInt( "assists", invscore2 )

				victim.SetPlayerGameStat( PGS_DEATHS, invscore);
				_HandleRespawn( victim )
				ClearInvincible(victim)
			}} catch (e2) {}
		}

        // Atacante
        void functionref() attackerHandleFunc = void function() : (victim, attacker, damageInfo)
		{
            try{
			if(IsValid(attacker) && attacker.IsPlayer() && IsAlive(attacker) && attacker != victim)
            {
			int score = GameRules_GetTeamScore(attacker.GetTeam());
            score++;
            GameRules_SetTeamScore(attacker.GetTeam(), score);

			int invscore = attacker.GetPlayerNetInt( "kills" )
			invscore++;
			attacker.SetPlayerNetInt( "kills", invscore )
			
			//Heal
			PlayerRestoreHP(attacker, 100, Equipment_GetDefaultShieldHP())
			
			//Autoreload on kill without animation //By CaféDeColombiaFPS
            WpnAutoReloadOnKill(attacker)
            }
			} catch (e) {}
        }
		thread victimHandleFunc()
        thread attackerHandleFunc()
        foreach(player in GetPlayerArray()){
		try {
        Remote_CallFunction_NonReplay(player, "ServerCallback_TDM_PlayerKilled")
		}
    catch(exception){;}
		}
        break
    default:
    }

file.lastKillTimer = Time()
file.lastKiller = attacker
}

void function _HandleRespawn(entity player, bool forceGive = false)
///////////////////////////////////////////////////////
//By Retículo Endoplasmático#5955 and michae\l/#1125 //
///////////////////////////////////////////////////////
{
    if(!IsValid(player)) return
	if( player.IsObserver())
    {
		player.StopObserverMode()
        Remote_CallFunction_NonReplay(player, "ServerCallback_KillReplayHud_Deactivate")
    }
	try {
	if(IsValid( player ) && !IsAlive(player) || forceGive)
    {
        if(Equipment_GetRespawnKitEnabled())
        {
			DecideRespawnPlayer(player, true)
			if(FlowState_ForceCharacter()){
			CharSelect(player)}
            player.TakeOffhandWeapon(OFFHAND_TACTICAL)
            player.TakeOffhandWeapon(OFFHAND_ULTIMATE)
            array<StoredWeapon> weapons = [
                Equipment_GetRespawnKit_PrimaryWeapon(),
                Equipment_GetRespawnKit_SecondaryWeapon(),
                Equipment_GetRespawnKit_Tactical(),
                Equipment_GetRespawnKit_Ultimate()
            ]
            foreach (storedWeapon in weapons)
            {
                if ( !storedWeapon.name.len() ) continue
                printl(storedWeapon.name + " " + storedWeapon.weaponType)
                if( storedWeapon.weaponType == eStoredWeaponType.main)
                    player.GiveWeapon( storedWeapon.name, storedWeapon.inventoryIndex, storedWeapon.mods )
                else
                    player.GiveOffhandWeapon( storedWeapon.name, storedWeapon.inventoryIndex, storedWeapon.mods )
            }
		}
        else
        {
            if(!player.p.storedWeapons.len())
            {
                DecideRespawnPlayer(player, true)
				if(FlowState_ForceCharacter()){
			CharSelect(player)}
			array<StoredWeapon> weapons = [
                Equipment_GetRespawnKit_PrimaryWeapon(),
                Equipment_GetRespawnKit_SecondaryWeapon(),
            ]
            foreach (storedWeapon in weapons)
            {
                player.GiveWeapon( storedWeapon.name, storedWeapon.inventoryIndex, storedWeapon.mods )

            }

            }
            else
            {
				DecideRespawnPlayer(player, false)
				if(FlowState_ForceCharacter()){
			CharSelect(player)}
                GiveWeaponsFromStoredArray(player, player.p.storedWeapons)
            }

        }
    }

	
	} catch (e) {}
	try {
	if( IsValidPlayer( player ) && IsAlive(player))
        {
	TpPlayerToSpawnPoint(player)
	
	SetPlayerSettings(player, TDM_PLAYER_SETTINGS)
	
    PlayerRestoreHP(player, 100, Equipment_GetDefaultShieldHP())

		}
		} catch (e1) {}
	if (FlowState_RandomGuns())
    {
        TakeAllWeapons(player)
        GiveRandomPrimaryWeapon(file.randomprimary, player)
        GiveRandomSecondaryWeapon(file.randomsecondary, player)
        GiveRandomTac(file.randomtac, player)
        GiveRandomUlt(file.randomult, player)
        player.GiveWeapon( "mp_weapon_melee_survival", WEAPON_INVENTORY_SLOT_PRIMARY_2, [] )
        player.GiveOffhandWeapon( "melee_data_knife", OFFHAND_MELEE, [] )
    } else if(FlowState_RandomGunsMetagame())
	{
		TakeAllWeapons(player)
        GiveRandomPrimaryWeaponMetagame(file.randomprimary, player)
        GiveRandomSecondaryWeaponMetagame(file.randomsecondary, player)
        GiveRandomTac(file.randomtac, player)
        GiveRandomUlt(file.randomult, player)
        player.GiveWeapon( "mp_weapon_melee_survival", WEAPON_INVENTORY_SLOT_PRIMARY_2, [] )
        player.GiveOffhandWeapon( "melee_data_knife", OFFHAND_MELEE, [] )
	}
	
	if (FlowState_RandomGunsEverydie())
    {
        file.randomprimary = RandomIntRange( 0, 18 )
        file.randomsecondary = RandomIntRange( 0, 6 )
        file.randomtac = RandomIntRange( 0, 5 )
        file.randomult = RandomIntRange( 0, 4 )
		TakeAllWeapons(player)
        GiveRandomPrimaryWeapon(file.randomprimary, player)
        GiveRandomSecondaryWeapon(file.randomsecondary, player)
        GiveRandomTac(file.randomtac, player)
        GiveRandomUlt(file.randomult, player)
        player.GiveWeapon( "mp_weapon_melee_survival", WEAPON_INVENTORY_SLOT_PRIMARY_2, [] )
        player.GiveOffhandWeapon( "melee_data_knife", OFFHAND_MELEE, [] )
    }

	WpnPulloutOnRespawn(player)
}

void function TpPlayerToSpawnPoint(entity player)
{
	LocPair loc = _GetAppropriateSpawnLocation(player)
    player.SetOrigin(loc.origin)
    player.SetAngles(loc.angles)
    PutEntityInSafeSpot( player, null, null, player.GetOrigin() + <0,0,100>, player.GetOrigin() )
}

void function GrantSpawnImmunity(entity player, float duration)
{
    try{
	if(!IsValid(player)) return;
    MakeInvincible(player)
    } catch (e) {}
	wait duration

	try{
	if(!IsValid(player)) return;
    ClearInvincible(player)
	} catch (e1) {}
}

void function WpnAutoReloadOnKill( entity player )
///////////////////////////////////////////////////////
//By Retículo Endoplasmático#5955 and michae\l/#1125 //
///////////////////////////////////////////////////////
{
	entity primary = player.GetLatestPrimaryWeapon( eActiveInventorySlot.mainHand )
	entity sec = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_1 )

	if (primary == sec) {
		sec = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 )
	}

	if (FlowState_AutoreloadOnKillPrimary()) {
    try {primary.SetWeaponPrimaryClipCount(primary.GetWeaponPrimaryClipCountMax())} catch(e){}
	}

	if (FlowState_AutoreloadOnKillSecondary()) {
		try {sec.SetWeaponPrimaryClipCount(sec.GetWeaponPrimaryClipCountMax())} catch(e){}
	}
}

void function WpnPulloutOnRespawn(entity player)
///////////////////////////////////////////////////////
//By Retículo Endoplasmático#5955 and michae\l/#1125 //
///////////////////////////////////////////////////////
{
	try {
	if( IsValid( player ) && IsAlive(player))
        {
	player.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_1)
	wait 0.5
	player.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_0)
}}catch(e){}}


void function SummonPlayersInACircle(entity player0)
{
	vector pos = player0.GetOrigin()
	pos.z += 5
	int i = 0
	Message(player0,"CIRCLE FIGHT NOW!", "", 5)
	foreach ( player in GetPlayerArray() )
	{
		if ( player == player0 && IsValidPlayer(player)) continue
		float r = float(i) / float(GetPlayerArray().len()) * 2 * PI
			 TeleportFRPlayer(player, pos + 150.0 * <sin( r ), cos( r ), 0.0>, <0, 0, 0>)
			 Message(player,"CIRCLE FIGHT NOW!", "", 5)
		i++
	}
}

void function GiveRandomPrimaryWeaponMetagame(int random, entity player)
{
    switch(random)
    {
        case 0:
            player.GiveWeapon( "mp_weapon_r97", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_classic", "barrel_stabilizer_l4_flash_hider", "stock_tactical_l3", "bullets_mag_l3"] )
            break;
        case 1:
            player.GiveWeapon( "mp_weapon_rspn101", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_bruiser", "barrel_stabilizer_l4_flash_hider", "stock_tactical_l3", "bullets_mag_l3"] )
            break;
        case 2:
            player.GiveWeapon( "mp_weapon_vinson", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_bruiser", "stock_tactical_l3", "highcal_mag_l3"] )
            break;
		case 3:
            player.GiveWeapon( "mp_weapon_alternator_smg", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_classic", "bullets_mag_l3", "barrel_stabilizer_l4_flash_hider", "stock_tactical_l3"] )
            break;
    }
}

void function GiveRandomSecondaryWeaponMetagame(int random, entity player)
{
    switch(random)
    {
        case 0:
            player.GiveWeapon( "mp_weapon_wingman", WEAPON_INVENTORY_SLOT_PRIMARY_1, ["optic_cq_hcog_classic", "highcal_mag_l3"] )
            break;
        case 1:
            player.GiveWeapon( "mp_weapon_energy_shotgun", WEAPON_INVENTORY_SLOT_PRIMARY_1, ["shotgun_bolt_l3"] )
            break;
        case 2:
            player.GiveWeapon( "mp_weapon_shotgun", WEAPON_INVENTORY_SLOT_PRIMARY_1, ["shotgun_bolt_l3"] )
            break;
        case 3:
            player.GiveWeapon( "mp_weapon_mastiff", WEAPON_INVENTORY_SLOT_PRIMARY_1)
            break;
		case 4:
            player.GiveWeapon( "mp_weapon_wingman", WEAPON_INVENTORY_SLOT_PRIMARY_1, ["optic_cq_hcog_classic", "highcal_mag_l3"] )
            break;
    }
}

void function GiveRandomPrimaryWeapon(int random, entity player)
{
    switch(random)
    {
        case 0:
            player.GiveWeapon( "mp_weapon_r97", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_classic", "barrel_stabilizer_l4_flash_hider", "stock_tactical_l3", "bullets_mag_l3"] )
            break;
        case 1:
            player.GiveWeapon( "mp_weapon_rspn101", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_bruiser", "barrel_stabilizer_l4_flash_hider", "stock_tactical_l3", "bullets_mag_l3"] )
            break;
        case 2:
            player.GiveWeapon( "mp_weapon_vinson", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_bruiser", "stock_tactical_l3", "highcal_mag_l3"] )
            break;
        case 3:
            player.GiveWeapon( "mp_weapon_hemlok", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_classic", "stock_tactical_l3", "highcal_mag_l3", "barrel_stabilizer_l4_flash_hider"] )
            break;
        case 4:
            player.GiveWeapon( "mp_weapon_pdw", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_classic", "stock_tactical_l3", "highcal_mag_l3"] )
            break;
		case 5:
			player.GiveWeapon( "mp_weapon_lmg", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_bruiser", "highcal_mag_l1", "barrel_stabilizer_l1", "stock_tactical_l1" ] )
            break; 
		case 6:
            player.GiveWeapon( "mp_weapon_rspn101", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_classic", "barrel_stabilizer_l4_flash_hider", "stock_tactical_l3", "bullets_mag_l3"] )
            break;
		case 7:
            player.GiveWeapon( "mp_weapon_energy_ar", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_bruiser", "energy_mag_l3", "stock_tactical_l3", "hopup_turbocharger"] )
            break;
		case 8:
            player.GiveWeapon( "mp_weapon_alternator_smg", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_classic", "bullets_mag_l3", "barrel_stabilizer_l4_flash_hider", "stock_tactical_l3"] )
            break;
		case 9:
            player.GiveWeapon( "mp_weapon_lstar", WEAPON_INVENTORY_SLOT_PRIMARY_0)
            break;
		case 10:
            player.GiveWeapon( "mp_weapon_esaw", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_bruiser", "energy_mag_l1", "barrel_stabilizer_l2"] )
            break;
		case 11:
            player.GiveWeapon( "mp_weapon_rspn101", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_classic", "bullets_mag_l1", "barrel_stabilizer_l1", "stock_tactical_l1"] )
            break;
		case 12:
            player.GiveWeapon( "mp_weapon_wingman", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["highcal_mag_l1"] )
            break;
		case 13:
            player.GiveWeapon( "mp_weapon_vinson", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_ranged_hcog", "stock_tactical_l1", "highcal_mag_l2"] )
            break;
		case 14:
            player.GiveWeapon( "mp_weapon_r97", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_threat", "bullets_mag_l2", "barrel_stabilizer_l2", "stock_tactical_l2"] )
            break;
		case 15:
            player.GiveWeapon( "mp_weapon_dmr", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_bruiser", "highcal_mag_l2", "barrel_stabilizer_l2", "stock_sniper_l3"] )
            break;
		case 16:
            player.GiveWeapon( "mp_weapon_pdw", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_classic", "stock_tactical_l1", "highcal_mag_l1"] )
            break;
		case 17:
            player.GiveWeapon( "mp_weapon_esaw", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_classic", "energy_mag_l3", "barrel_stabilizer_l4_flash_hider"] )
            break;
		case 18:
            player.GiveWeapon( "mp_weapon_alternator_smg", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_classic", "energy_mag_l1", "barrel_stabilizer_l2"] )
            break;
    }
}

void function GiveRandomSecondaryWeapon(int random, entity player)
{
    switch(random)
    {
        case 0:
            player.GiveWeapon( "mp_weapon_wingman", WEAPON_INVENTORY_SLOT_PRIMARY_1, ["optic_cq_hcog_classic", "highcal_mag_l3"] )
            break;
        case 1:
            player.GiveWeapon( "mp_weapon_energy_shotgun", WEAPON_INVENTORY_SLOT_PRIMARY_1, ["shotgun_bolt_l3"] )
            break;
        case 2:
            player.GiveWeapon( "mp_weapon_shotgun", WEAPON_INVENTORY_SLOT_PRIMARY_1, ["shotgun_bolt_l3"] )
            break;
        case 3:
            player.GiveWeapon( "mp_weapon_mastiff", WEAPON_INVENTORY_SLOT_PRIMARY_1)
            break;
		case 4:
            player.GiveWeapon( "mp_weapon_autopistol", WEAPON_INVENTORY_SLOT_PRIMARY_1, ["optic_cq_hcog_classic", "bullets_mag_l3", "barrel_stabilizer_l4_flash_hider" ] )
            break;
		case 5:
            player.GiveWeapon( "mp_weapon_shotgun_pistol", WEAPON_INVENTORY_SLOT_PRIMARY_1, ["optic_cq_hcog_classic" "shotgun_bolt_l3"] )
            break;
		case 6:
            player.GiveWeapon( "mp_weapon_defender", WEAPON_INVENTORY_SLOT_PRIMARY_1, ["optic_ranged_hcog" "stock_sniper_l2"] )
            break;
    }
}

void function GiveRandomTac(int random, entity player)
{
    switch(random)
    {
        case 0:
            player.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
            break;
        case 1:
            player.GiveOffhandWeapon("mp_ability_phase_walk", OFFHAND_TACTICAL)
            break;
        case 2:
            player.GiveOffhandWeapon("mp_ability_heal", OFFHAND_TACTICAL)
            break;
		case 3:
            player.GiveOffhandWeapon("mp_weapon_bubble_bunker", OFFHAND_TACTICAL)
            break;
		case 4:
            player.GiveOffhandWeapon("mp_weapon_grenade_bangalore", OFFHAND_TACTICAL)
            break;
		case 5:
            player.GiveOffhandWeapon("mp_ability_area_sonar_scan", OFFHAND_TACTICAL)
            break;
    }
}

void function GiveRandomUlt(int random, entity player )
{
    switch(random)
    {
        case 0:
            player.GiveOffhandWeapon("mp_weapon_grenade_gas", OFFHAND_ULTIMATE)
            break;
        case 1:
            player.GiveOffhandWeapon("mp_weapon_jump_pad", OFFHAND_ULTIMATE)
            break;
        case 2:
            player.GiveOffhandWeapon("mp_weapon_phase_tunnel", OFFHAND_ULTIMATE)
            break;
		case 3:
            player.GiveOffhandWeapon("mp_ability_3dash", OFFHAND_ULTIMATE)
            break;
		case 4:
            player.GiveOffhandWeapon("mp_ability_hunt_mode", OFFHAND_ULTIMATE)
            break;
			
    }
}

void function OnShipButtonUsed( entity panel, entity player, int useInputFlags )
{
	player.MakeInvisible()
	player.StartObserverMode( OBS_MODE_CHASE )
	player.SetObserverTarget( file.supercooldropship )
}

vector function ShipSpot()
{
	vector shipspot
	int num = RandomIntRange(0,11)
	switch(num)
	{
	case 0:
		shipspot = <0,0,30>
		break;
	case 1:
		shipspot = <35,0,30>
		break;
	case 2:
		shipspot = <-35,0,30>
		break;
	case 3:
		shipspot = <0,35,30>
		break;
	case 4:
		shipspot = <35,35,30>
		break;
	case 5:
		shipspot = <-35,35,30>
		break;
	case 6:
		shipspot = <0,70,30>
		break;
	case 7:
		shipspot = <35,70,30>
		break;
	case 8:
		shipspot = <-35,70,30>
		break;
	case 9:
		shipspot = <0,105,30>
		break;
	case 10:
		shipspot = <35,105,30>
		break;
	case 11:
		shipspot = <-35,105,30>
		break;
	}

	return shipspot
}

void function CreateDropShipTriggerArea()
{
	entity trigger = CreateEntity( "trigger_cylinder" )
	trigger.SetRadius( 100 )
	trigger.SetAboveHeight( 100 ) //Still not quite a sphere, will see if close enough
	trigger.SetBelowHeight( 100 )
	trigger.SetOrigin( file.supercooldropship.GetOrigin() )
	trigger.SetParent( file.supercooldropship )
	DispatchSpawn( trigger )

	trigger.SearchForNewTouchingEntity()

	OnThreadEnd(
	function() : ( trigger )
		{
			trigger.Destroy()
		}
	)

	while ( file.isshipalive )
	{
		array<entity> touchingEnts = trigger.GetTouchingEntities()

		foreach( touchingEnt in touchingEnts  )
		{
			if( touchingEnt.IsPlayer() )
			{
				if(touchingEnt.GetParent() != file.supercooldropship)
				{
					touchingEnt.SetThirdPersonShoulderModeOff()
					vector shipspot = ShipSpot()
					touchingEnt.SetAbsOrigin( file.supercooldropship.GetOrigin() + shipspot )
					touchingEnt.SetParent(file.supercooldropship)
				}
			}
		}
		wait 0.1
	}
}

void function CreateShipRoomFallTriggers()
{
	entity trigger = CreateEntity( "trigger_cylinder" )
	trigger.SetRadius( 2000 )
	trigger.SetAboveHeight( 25 ) //Still not quite a sphere, will see if close enough
	trigger.SetBelowHeight( 25 )

	if (GetMapName() == "mp_rr_desertlands_64k_x_64k" || GetMapName() == "mp_rr_desertlands_64k_x_64k_nx")
	{
		trigger.SetOrigin( <-19459, 2127, 5404> )
	}
	else if(GetMapName() == "mp_rr_canyonlands_mu1" || GetMapName() == "mp_rr_canyonlands_mu1_night" || GetMapName() == "mp_rr_canyonlands_64k_x_64k")
	{
		trigger.SetOrigin( <-19459, 2127, 17404> )
	}

	DispatchSpawn( trigger )

	trigger.SearchForNewTouchingEntity()

	OnThreadEnd(
	function() : ( trigger )
		{
			trigger.Destroy()
		}
	)

	bool enabled = true

	while ( enabled )
	{
		array<entity> touchingEnts = trigger.GetTouchingEntities()

		foreach( touchingEnt in touchingEnts  )
		{
			if( touchingEnt.IsPlayer() )
			{
				if (GetMapName() == "mp_rr_desertlands_64k_x_64k" || GetMapName() == "mp_rr_desertlands_64k_x_64k_nx")
				{
					touchingEnt.SetOrigin( <-19459, 2127, 6404> )
				}
				else if(GetMapName() == "mp_rr_canyonlands_mu1" || GetMapName() == "mp_rr_canyonlands_mu1_night" || GetMapName() == "mp_rr_canyonlands_64k_x_64k")
				{
					touchingEnt.SetOrigin( <-19459, 2127, 18404> )
				}
			}
		}
		wait 0.01
	}
}


 // ██████   █████  ███    ███ ███████     ██       ██████   ██████  ██████
// ██       ██   ██ ████  ████ ██          ██      ██    ██ ██    ██ ██   ██
// ██   ███ ███████ ██ ████ ██ █████       ██      ██    ██ ██    ██ ██████
// ██    ██ ██   ██ ██  ██  ██ ██          ██      ██    ██ ██    ██ ██
 // ██████  ██   ██ ██      ██ ███████     ███████  ██████   ██████  ██

void function RunTDM()
{
    WaitForGameState(eGameState.Playing)
    AddSpawnCallback("prop_dynamic", _OnPropDynamicSpawned)
    for(; ;)
    {
	VotingPhase()
	SimpleChampionUI()
	}
    WaitForever()
}

void function VotingPhase()
///////////////////////////////////////////////////////
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
///////////////////////////////////////////////////////
{
    DestroyPlayerProps();
    SetGameState(eGameState.MapVoting)
	if (FlowState_RandomGuns())
    {
        file.randomprimary = RandomIntRange( 0, 18 )
        file.randomsecondary = RandomIntRange( 0, 6 )
        file.randomtac = RandomIntRange( 0, 5 )
        file.randomult = RandomIntRange( 0, 4 )
    } else if (FlowState_RandomGunsMetagame())
	{
		file.randomprimary = RandomIntRange( 0, 3 )
        file.randomsecondary = RandomIntRange( 0, 4 )
        file.randomtac = RandomIntRange( 0, 5 )
        file.randomult = RandomIntRange( 0, 4 )
	}
wait 1


foreach(player in GetPlayerArray())
{
    try {
		if(IsValid(player))
        {
			player.SetThirdPersonShoulderModeOn()
			_HandleRespawn(player)
			player.UnforceStand()
			player.UnfreezeControlsOnServer()
			HolsterAndDisableWeapons( player )
        }
	}catch(e){}
}


wait 5


if(GetCurrentPlaylistVarBool("flowstateenabledropship", false ) == false)
{
    foreach(player in GetPlayerArray())
    {
        if(IsValidPlayer(player))
        {
		    Message(player,"Waiting for players", "", 4, "Wraith_PhaseGate_Travel_1p")
		    ScreenFade( player, 0, 0, 0, 255, 4.0, 4.0, FFADE_OUT | FFADE_PURGE )
	    }
    }
}


if (!file.mapIndexChanged)
{
	if (FlowState_LockPOI()) {
		file.nextMapIndex = FlowState_LockedPOI() % file.locationSettings.len()
	}
	else 
    {
		file.nextMapIndex = (file.nextMapIndex + 1 ) % file.locationSettings.len()
	}
}

int choice = file.nextMapIndex
file.mapIndexChanged = false
file.selectedLocation = file.locationSettings[choice]
file.dropselectedLocation = file.droplocationSettings[choice]

if(file.selectedLocation.name == "Skill trainer By Colombia")
{
    DestroyPlayerProps()
    wait 2
    SkillTrainerLoad()
}

if(GetCurrentPlaylistVarBool("flowstateenabledropship", false ))
{
	if(GetMapName() == "mp_rr_desertlands_64k_x_64k" || GetMapName() == "mp_rr_desertlands_64k_x_64k_nx" || GetMapName() == "mp_rr_canyonlands_mu1" || GetMapName() == "mp_rr_canyonlands_mu1_night" || GetMapName() == "mp_rr_canyonlands_64k_x_64k")
	{
    foreach(player in GetPlayerArray())
    {
        if(IsValidPlayer(player))
        {
		    Message(player, "Please Standby", "Dropship is on the way!", 4)
	    }
    }

	wait 10

	if(GetMapName() == "mp_rr_desertlands_64k_x_64k" || GetMapName() == "mp_rr_desertlands_64k_x_64k_nx")
	{
		try {file.supercooldropship.Destroy()}catch(e69){}
		file.supercooldropship = CreateDropShipProp( $"mdl/vehicle/goblin_dropship/goblin_dropship.rmdl", <-27496,-188,9450>, <0,0,0>, true, 8000, -1 )

		//Warp In DropShip
		file.supercooldropship.Hide()
		waitthread __WarpInEffectShared( <-27496,-188,9450>, <0,0,0>, "dropship_warpin", 0.0 )
		file.supercooldropship.Show()

		EmitSoundOnEntity( file.supercooldropship, "goblin_imc_evac_hover" )
		waitthread PlayAnim( file.supercooldropship, "dropship_VTOL_evac_start", <-20650,2115,6223>, <0,0,0>)
		thread PlayAnim( file.supercooldropship, "dropship_VTOL_evac_idle", <-20650,2115,6223>, <0,0,0>)
	}
	else if(GetMapName() == "mp_rr_canyonlands_mu1" || GetMapName() == "mp_rr_canyonlands_mu1_night")
	{

		try {file.supercooldropship.Destroy()}catch(e69){}
		file.supercooldropship = CreateDropShipProp( $"mdl/vehicle/goblin_dropship/goblin_dropship.rmdl", <-27496,-188,21450>, <0,0,0>, true, 8000, -1 )
		EmitSoundOnEntity( file.supercooldropship, "goblin_imc_evac_hover" )
		waitthread PlayAnim( file.supercooldropship, "dropship_VTOL_evac_start", <-20650,2115,18223>, <0,0,0>)
		thread PlayAnim( file.supercooldropship, "dropship_VTOL_evac_idle", <-20650,2115,18223>, <0,0,0>)
	}
	else if(GetMapName() == "mp_rr_canyonlands_64k_x_64k")
	{
		try {file.supercooldropship.Destroy()}catch(e69){}
		file.supercooldropship = CreateDropShipProp( $"mdl/vehicle/goblin_dropship/goblin_dropship.rmdl", <-27496,-188,21450>, <0,0,0>, true, 8000, -1 )
		EmitSoundOnEntity( file.supercooldropship, "goblin_imc_evac_hover" )
		waitthread PlayAnim( file.supercooldropship, "dropship_VTOL_evac_start", <-20650,2115,18223>, <0,0,0>)
		thread PlayAnim( file.supercooldropship, "dropship_VTOL_evac_idle", <-20650,2115,18223>, <0,0,0>)
	}

	foreach(player in GetPlayerArray())
    {
        if(IsValidPlayer(player))
        {
		    Message(player, "Next Location: " + file.selectedLocation.name, "Dropship is ready, Get in!", 6)
	    }
    }

	file.isshipalive = true
	thread CreateDropShipTriggerArea()

	wait 10

	foreach(player in GetPlayerArray())
    {
        if(IsValidPlayer(player))
        {
			if ( player.GetParent() != file.supercooldropship )
			{

				player.SetThirdPersonShoulderModeOff()
				vector shipspot = ShipSpot()
				player.SetAbsOrigin( file.supercooldropship.GetOrigin() + shipspot )
				player.SetParent(file.supercooldropship)
			}
		}
	}

	wait 1
	foreach(player in GetPlayerArray())
    {
        if(IsValidPlayer(player))
        {
		    Message(player, "Heading To New Location", "Hold on tight!", 3)
	    }
    }
	file.isshipalive = false
	if(GetMapName() == "mp_rr_desertlands_64k_x_64k" || GetMapName() == "mp_rr_desertlands_64k_x_64k_nx")
	{
		thread PlayAnim( file.supercooldropship, "dropship_VTOL_evac_end", <-20600,2115,6223>, <0,0,0>)
	}
	else if(GetMapName() == "mp_rr_canyonlands_mu1" || GetMapName() == "mp_rr_canyonlands_mu1_night")
	{
		thread PlayAnim( file.supercooldropship, "dropship_VTOL_evac_end", <-20650,2115,18223>, <0,0,0>)
	}
	else if(GetMapName() == "mp_rr_canyonlands_64k_x_64k")
	{
		thread PlayAnim( file.supercooldropship, "dropship_VTOL_evac_end", <-20650,2115,18223>, <0,0,0>)
	}

	wait 3

	foreach(player in GetPlayerArray())
    {
        if(IsValidPlayer(player))
        {
		    ScreenFadeToBlackForever(player, 1.7)
			//Remote_CallFunction_Replay( player, "ServerCallback_PlayScreenFXWarpJump" )
	    }
    }
    wait 3
	}
	else
	{
		wait 3
	}
}
else
{
    wait 4
}

try {
    PlayerTrail(GetBestPlayer(),0)
} catch(e2){}

SetGameState(eGameState.Playing)
file.tdmState = eTDMState.IN_PROGRESS

if(GetCurrentPlaylistVarBool("flowstateenabledropship", false ))
{
	if(GetMapName() == "mp_rr_desertlands_64k_x_64k" || GetMapName() == "mp_rr_desertlands_64k_x_64k_nx" || GetMapName() == "mp_rr_canyonlands_mu1" || GetMapName() == "mp_rr_canyonlands_mu1_night" || GetMapName() == "mp_rr_canyonlands_64k_x_64k")
	{
		int maxspawns = -1
		array<LocPair> spawns = file.dropselectedLocation.spawns
		foreach(spawn in spawns)
		{
    		maxspawns++
		}

	//true == FFA
	if (GetCurrentPlaylistVarBool("flowstateffaortdm", false ) == true)
	{
		foreach(player in GetPlayerArray())
		{
        		if(IsValid(player))
       			{
					MakeInvincible(player)

					if (player.GetParent() == file.supercooldropship)
					{
						player.ClearParent()
					}

					RemoveCinematicFlag(player, CE_FLAG_HIDE_MAIN_HUD | CE_FLAG_EXECUTION)
					player.SetThirdPersonShoulderModeOff()
					_HandleRespawn(player)

					ScreenFadeFromBlack( player, 1.0, 1.0 )

					int rndnum = RandomIntRange(0, maxspawns)

					thread RespawnPlayersInDropshipAtPoint2( player, spawns[rndnum].origin + <0,0,500>, AnglesCompose( spawns[rndnum].angles, <0,0,0> ) )

					Remote_CallFunction_NonReplay(player, "ServerCallback_TDM_DoAnnouncement", 1, eTDMAnnounce.ROUND_START)

					// reload weapons when tp'ing to next location
					entity w1 = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 )
					entity w2 = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_1 )
					try {w1.SetWeaponPrimaryClipCount(w1.GetWeaponPrimaryClipCountMax())} catch(this_is_a_unique_string_dont_crash_u_bitch){}
					try {w2.SetWeaponPrimaryClipCount(w2.GetWeaponPrimaryClipCountMax())} catch(this_is_a_unique_string_dont_crash_u_bitch2){}
    			}
		}
	}
	else
	{
		foreach(player in GetPlayerArray())
		{
        		if(IsValid(player))
       			{
					MakeInvincible(player)

					if (player.GetParent() == file.supercooldropship)
					{
						player.ClearParent()
					}

					RemoveCinematicFlag(player, CE_FLAG_HIDE_MAIN_HUD | CE_FLAG_EXECUTION)
					player.SetThirdPersonShoulderModeOff()
					_HandleRespawn(player)

					ScreenFadeFromBlack( player, 1.0, 1.0 )
    			}
		}

		array<entity> IMCplayers = GetPlayerArrayOfTeam( TEAM_IMC )
		int sizeofimcteam = -1

		foreach(players in IMCplayers)
		{
			sizeofimcteam++
		}

		array<entity> IMCplayersShip1
		array<entity> IMCplayersShip2
		array<entity> IMCplayersShip3
		array<entity> IMCplayersShip4

		IMCplayersShip1.clear()
		IMCplayersShip2.clear()
		IMCplayersShip3.clear()
		IMCplayersShip4.clear()

		//Ship1
		if(sizeofimcteam >= 0)
		{
			IMCplayersShip1.append(IMCplayers[0])
		}
		if(sizeofimcteam >= 1)
		{
			IMCplayersShip1.append(IMCplayers[1])
		}
		if(sizeofimcteam >= 2)
		{
			IMCplayersShip1.append(IMCplayers[2])
		}

		//Ship2
		if(sizeofimcteam >= 3)
		{
			IMCplayersShip2.append(IMCplayers[3])
		}
		if(sizeofimcteam >= 4)
		{
			IMCplayersShip2.append(IMCplayers[4])
		}
		if(sizeofimcteam >= 5)
		{
			IMCplayersShip2.append(IMCplayers[5])
		}

		//Ship3
		if(sizeofimcteam >= 6)
		{
			IMCplayersShip3.append(IMCplayers[6])
		}
		if(sizeofimcteam >= 7)
		{
			IMCplayersShip3.append(IMCplayers[7])
		}
		if(sizeofimcteam >= 8)
		{
			IMCplayersShip3.append(IMCplayers[8])
		}

		//Ship4
		if(sizeofimcteam >= 9)
		{
			IMCplayersShip4.append(IMCplayers[9])
		}
		if(sizeofimcteam >= 10)
		{
			IMCplayersShip4.append(IMCplayers[10])
		}
		if(sizeofimcteam >= 11)
		{
			IMCplayersShip4.append(IMCplayers[11])
		}

		array<entity> MILITIAplayers = GetPlayerArrayOfTeam( TEAM_MILITIA )

		int sizeofmilitiateam = -1

		foreach(players in MILITIAplayers)
		{
			sizeofmilitiateam++
		}

		array<entity> MILITIAplayersShip1
		array<entity> MILITIAplayersShip2
		array<entity> MILITIAplayersShip3
		array<entity> MILITIAplayersShip4

		MILITIAplayersShip1.clear()
		MILITIAplayersShip2.clear()
		MILITIAplayersShip3.clear()
		MILITIAplayersShip4.clear()

		//Ship1
		if(sizeofmilitiateam >= 0)
		{
			MILITIAplayersShip1.append(MILITIAplayers[0])
		}
		if(sizeofmilitiateam >= 1)
		{
			MILITIAplayersShip1.append(MILITIAplayers[1])
		}
		if(sizeofmilitiateam >= 2)
		{
			MILITIAplayersShip1.append(MILITIAplayers[2])
		}

		//Ship2
		if(sizeofmilitiateam >= 3)
		{
			MILITIAplayersShip2.append(MILITIAplayers[3])
		}
		if(sizeofmilitiateam >= 4)
		{
			MILITIAplayersShip2.append(MILITIAplayers[4])
		}
		if(sizeofmilitiateam >= 5)
		{
			MILITIAplayersShip2.append(MILITIAplayers[5])
		}

		//Ship3
		if(sizeofmilitiateam >= 6)
		{
			MILITIAplayersShip3.append(MILITIAplayers[6])
		}
		if(sizeofmilitiateam >= 7)
		{
			MILITIAplayersShip3.append(MILITIAplayers[7])
		}
		if(sizeofmilitiateam >= 8)
		{
			MILITIAplayersShip3.append(MILITIAplayers[8])
		}

		//Ship4
		if(sizeofmilitiateam >= 9)
		{
			MILITIAplayersShip4.append(MILITIAplayers[9])
		}
		if(sizeofmilitiateam >= 10)
		{
			MILITIAplayersShip4.append(MILITIAplayers[10])
		}
		if(sizeofmilitiateam >= 11)
		{
			MILITIAplayersShip4.append(MILITIAplayers[11])
		}

		float randomrange1 = RandomFloatRange(-360.0, 360.0)
        vector finishedangles = spawns[0].angles + <0,randomrange1,0>

		if (finishedangles.x > 360.0)
        {
            finishedangles.x = 359.0
        }

		if (finishedangles.y > 360.0)
        {
            finishedangles.y = 359.0
        }

		if (finishedangles.z > 360.0)
        {
            finishedangles.z = 359.0
        }

		thread RespawnPlayersInDropshipAtPointTDM( IMCplayersShip1, spawns[0].origin + <0,0,500>, AnglesCompose( spawns[0].angles, <0,0,0> ) )
		thread RespawnPlayersInDropshipAtPointTDM( MILITIAplayersShip1, spawns[maxspawns].origin + <0,0,500>, AnglesCompose( spawns[maxspawns].angles, <0,0,0> ) )
		wait 1
		if(sizeofmilitiateam >= 3 || sizeofimcteam >= 3)
		{
			thread RespawnPlayersInDropshipAtPointTDM( IMCplayersShip2, spawns[0].origin + <200,0,500>, AnglesCompose( spawns[0].angles, <0,30,0> ) )
			thread RespawnPlayersInDropshipAtPointTDM( MILITIAplayersShip2, spawns[maxspawns].origin + <200,0,500>, AnglesCompose( spawns[maxspawns].angles, <0,30,0> ) )
		}
		wait 1
		if(sizeofmilitiateam >= 6 || sizeofimcteam >= 6)
		{
			thread RespawnPlayersInDropshipAtPointTDM( IMCplayersShip3, spawns[0].origin + <400,0,500>, AnglesCompose( spawns[0].angles, <0,60,0> ) )
			thread RespawnPlayersInDropshipAtPointTDM( MILITIAplayersShip3, spawns[maxspawns].origin + <400,0,500>, AnglesCompose( spawns[maxspawns].angles, <0,60,0> ) )
		}
		wait 1
		if(sizeofmilitiateam >= 9 || sizeofimcteam >= 9)
		{
			thread RespawnPlayersInDropshipAtPointTDM( IMCplayersShip4, spawns[0].origin + <600,0,500>, AnglesCompose( spawns[0].angles, <0,90,0> ) )
			thread RespawnPlayersInDropshipAtPointTDM( MILITIAplayersShip4, spawns[maxspawns].origin + <600,0,500>, AnglesCompose( spawns[maxspawns].angles, <0,90,0> ) ) 
		}
		
		foreach(player in GetPlayerArray())
		{
        		if(IsValid(player))
       			{
					Remote_CallFunction_NonReplay(player, "ServerCallback_TDM_DoAnnouncement", 1, eTDMAnnounce.ROUND_START)

					// reload weapons when tp'ing to next location
					entity w1 = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 )
					entity w2 = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_1 )
					try {w1.SetWeaponPrimaryClipCount(w1.GetWeaponPrimaryClipCountMax())} catch(this_is_a_unique_string_dont_crash_u_bitch){}
					try {w2.SetWeaponPrimaryClipCount(w2.GetWeaponPrimaryClipCountMax())} catch(this_is_a_unique_string_dont_crash_u_bitch2){}
    			}
		}
	}
	}
	else
	{
		foreach(player in GetPlayerArray())
    	{
        try {
            if(IsValid(player))
            {
		        RemoveCinematicFlag(player, CE_FLAG_HIDE_MAIN_HUD | CE_FLAG_EXECUTION)
		        player.SetThirdPersonShoulderModeOff()
		        ClearInvincible(player)
		        DeployAndEnableWeapons(player)
		        _HandleRespawn(player)

		        ClearInvincible(player)
		
		        DeployAndEnableWeapons(player)
		        Remote_CallFunction_NonReplay(player, "ServerCallback_TDM_DoAnnouncement", 1, eTDMAnnounce.ROUND_START)
		        ScreenFade( player, 0, 0, 0, 255, 1.0, 1.0, FFADE_IN | FFADE_PURGE )

		        // reload weapons when tp'ing to next location
		        entity w1 = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 )
		        entity w2 = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_1 )
		        try {w1.SetWeaponPrimaryClipCount(w1.GetWeaponPrimaryClipCountMax())} catch(this_is_a_unique_string_dont_crash_u_bitch){}
		        try {w2.SetWeaponPrimaryClipCount(w2.GetWeaponPrimaryClipCountMax())} catch(this_is_a_unique_string_dont_crash_u_bitch2){}
            }
	    } catch(e3){}
    	}
	}
}
else
{
    foreach(player in GetPlayerArray())
    {
        try {
            if(IsValid(player))
            {
		        RemoveCinematicFlag(player, CE_FLAG_HIDE_MAIN_HUD | CE_FLAG_EXECUTION)
		        player.SetThirdPersonShoulderModeOff()
		        ClearInvincible(player)
		        DeployAndEnableWeapons(player)
		        _HandleRespawn(player)

		        ClearInvincible(player)
		
		        DeployAndEnableWeapons(player)
		        Remote_CallFunction_NonReplay(player, "ServerCallback_TDM_DoAnnouncement", 1, eTDMAnnounce.ROUND_START)
		        ScreenFade( player, 0, 0, 0, 255, 1.0, 1.0, FFADE_IN | FFADE_PURGE )

		        // reload weapons when tp'ing to next location
		        entity w1 = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 )
		        entity w2 = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_1 )
		        try {w1.SetWeaponPrimaryClipCount(w1.GetWeaponPrimaryClipCountMax())} catch(this_is_a_unique_string_dont_crash_u_bitch){}
		        try {w2.SetWeaponPrimaryClipCount(w2.GetWeaponPrimaryClipCountMax())} catch(this_is_a_unique_string_dont_crash_u_bitch2){}
            }
	    } catch(e3){}
    }
}   

try {
if(GetBestPlayer()==PlayerWithMostDamage())
{
	foreach(player in GetPlayerArray())
    {
		string nextlocation = file.selectedLocation.name

		Message(player, file.selectedLocation.name + ": ROUND START!", "\n           CHAMPION: " + GetBestPlayerName() + " / " + GetBestPlayerScore() + " kills. / " + GetDamageOfPlayerWithMostDamage() + " damage.", 25, "diag_ap_aiNotify_circleTimerStartNext_02")
		
		file.previousChampion=GetBestPlayer()
		file.previousChallenger=PlayerWithMostDamage()
		GameRules_SetTeamScore(player.GetTeam(), 0)
		file.deathPlayersCounter = 0
	}
}
else{
	foreach(player in GetPlayerArray())
    {
		int playerEHandle = player.GetEncodedEHandle()
		string nextlocation = file.selectedLocation.name

		Message(player, file.selectedLocation.name + ": ROUND START!", "\n           CHAMPION: " + GetBestPlayerName() + " / " + GetBestPlayerScore() + " kills. \n    CHALLENGER:  " + PlayerWithMostDamageName() + " / " + GetDamageOfPlayerWithMostDamage() + " damage.", 25, "diag_ap_aiNotify_circleTimerStartNext_02")
		
		file.previousChampion=GetBestPlayer()
		file.previousChallenger=PlayerWithMostDamage()
		GameRules_SetTeamScore(player.GetTeam(), 0)
		file.deathPlayersCounter = 0
	}
}
} catch(e4){}

foreach(player in GetPlayerArray())
    {
        if(IsValidPlayer(player))
        {
			player.p.playerDamageDealt = 0.0}
			if (FlowState_ResetKillsEachRound() && IsValidPlayer(player)) 
			{
				player.SetPlayerNetInt("kills", 0) //Reset for kills
	    		player.SetPlayerNetInt("assists", 0) //Reset for deaths
			}
	}

try {file.supercooldropship.Destroy()}catch(e69){}

ResetAllPlayerStats()
file.bubbleBoundary = CreateBubbleBoundary(file.selectedLocation)
WaitFrame()
}

void function SimpleChampionUI(){
//////////////////////////////////////////////////////////////////////////////
/////////////Retículo Endoplasmático#5955 CaféDeColombiaFPS///////////////////
//////////////////////////////////////////////////////////////////////////////
float endTime = Time() + FlowState_RoundTime()


if (FlowState_Timer()){
while( Time() <= endTime )
	{
    if(Time() == endTime-900)
	{
			foreach(player in GetPlayerArray())
			{
				if(IsValid(player))
				{
					Message(player,"15 MINUTES REMAINING!","", 5)
				}
			}
		}
		if(Time() == endTime-600)
		{
			foreach(player in GetPlayerArray())
			{
				if(IsValid(player))
				{
					Message(player,"10 MINUTES REMAINING!","", 5)
				}
			}
		}
		if(Time() == endTime-300)
		{
			foreach(player in GetPlayerArray())
			{
				if(IsValid(player))
				{
					Message(player,"5 MINUTES REMAINING!","", 5)
				}
			}
		}
		if(Time() == endTime-120)
		{
			foreach(player in GetPlayerArray())
			{
				if(IsValid(player))
				{
					Message(player,"2 MINUTES REMAINING!","", 5)
				}
			}
		}
		if(Time() == endTime-60)
		{
			foreach(player in GetPlayerArray())
			{
				if(IsValid(player))
				{
					Message(player,"1 MINUTE REMAINING!","", 5, "diag_ap_aiNotify_circleMoves60sec")
				}
			}
		}
		if(Time() == endTime-30)
		{
			foreach(player in GetPlayerArray())
			{
				if(IsValid(player))
				{
					Message(player,"30 SECONDS REMAINING!","", 5, "diag_ap_aiNotify_circleMoves30sec")
				}
			}
		}
		if(Time() == endTime-10)
		{
			foreach(player in GetPlayerArray())
			{
				if(IsValid(player))
				{
					Message(player,"10 SECONDS REMAINING!", "\n The battle is over.", 8, "diag_ap_aiNotify_circleMoves10sec")
				}
			}
		}
		if(file.tdmState == eTDMState.NEXT_ROUND_NOW) break
		WaitFrame()
	}
}
else{
while( Time() <= endTime )
	{
	if(file.tdmState == eTDMState.NEXT_ROUND_NOW) break
		WaitFrame()
	}
}
foreach(player in GetPlayerArray())
    {
try{
	   if(IsValid(player) && IsAlive(player))
        {
			PlayerRestoreHP(player, 100, Equipment_GetDefaultShieldHP())
			player.SetThirdPersonShoulderModeOn()
			HolsterAndDisableWeapons( player )
	}} catch (e) {}
	}
foreach(player in GetPlayerArray())
    {
	try{
	if(IsValid(player) && !IsAlive(player)){
			_HandleRespawn(player)
			ClearInvincible(player)
			MakeInvincible( player )
	}
	} catch (e5) {}
	}
wait 1
try{
if(GetBestPlayer()==PlayerWithMostDamage())
{

foreach(player in GetPlayerArray())
    {

	 if(IsValid(player))
        {
		Message(player,"- CHAMPION DECIDED! -", "\n " + GetBestPlayerName() + " is the champion: number 1 in kills and damage \n with " + GetBestPlayerScore() + " kills and " + GetDamageOfPlayerWithMostDamage() + " of damage.  \n \n        Champion is literally on fire! Weapons disabled! Please tbag.", 10, "UI_InGame_ChampionVictory")
		}
	}
wait 1
}
else
{
foreach(player in GetPlayerArray())
    {
	 if(IsValid(player))
        {
		Message(player,"- CHAMPION DECIDED! -", "\n The champion is " + GetBestPlayerName() + " with " + GetBestPlayerScore() + " kills. Champion is literally on fire! \n \n The player with most damage was " + PlayerWithMostDamageName() + " with " + GetDamageOfPlayerWithMostDamage() + " and now is the CHALLENGER. \n\n          Weapons disabled! Please tbag.", 5, "UI_InGame_ChampionVictory")}
	}
wait 1
}
} catch (e1) {}

foreach(entity champion in GetPlayerArray())
    {
		try {
		if(GetBestPlayer() == champion) {
				if(IsValid(champion))
        {
			 thread EmitSoundOnEntityOnlyToPlayer( champion, champion, "diag_ap_aiNotify_winnerFound_10" )
			//thread EmitSoundOnEntityOnlyToPlayer( champion, champion, "diag_ap_nocNotify_victorySolo_04_3p" )
			 thread EmitSoundOnEntityExceptToPlayer( champion, champion, "diag_ap_aiNotify_winnerFound" )
			//thread EmitSoundOnEntityExceptToPlayer( champion, champion, "diag_ap_nocNotify_winnerDecided_01_02_3p" )
        PlayerTrail(champion,1)
		}}
	}catch(e2){}
	}
wait 5
foreach(player in GetPlayerArray())
    {
	try{
	 if(IsValid(player)){
	 AddCinematicFlag(player, CE_FLAG_HIDE_MAIN_HUD | CE_FLAG_EXECUTION)
	 Message(player,"- FINAL SCOREBOARD -", "\n         Name:    K  |   D   |   KD   |   Damage dealt \n \n" + ScoreboardFinal() + "\n Flow State DM " + file.scriptversion + " by ColombiaFPS, empathogenwarlord & AyeZeeBB", 6, "UI_Menu_RoundSummary_Results")}
	}catch(e3){}
	}
wait 6
foreach(player in GetPlayerArray())
    {
        try{
		if(IsValid(player)){
		ClearInvincible(player)
		RemoveCinematicFlag(player, CE_FLAG_HIDE_MAIN_HUD | CE_FLAG_EXECUTION)
		player.SetThirdPersonShoulderModeOff()

	}}catch(e4){}}
WaitFrame()


try{
file.bubbleBoundary.Destroy()
}catch(e5){}
///////////////////////////////////////////////////////
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
///////////////////////////////////////////////////////
// Making this scoreboard from the server side has made me very happy, it makes the game more competitive !!
}

// ██████  ██    ██ ██████  ██████  ██      ███████      ██ ██████  ██ ███    ██  ██████  ██
// ██   ██ ██    ██ ██   ██ ██   ██ ██      ██          ██  ██   ██ ██ ████   ██ ██        ██
// ██████  ██    ██ ██████  ██████  ██      █████       ██  ██████  ██ ██ ██  ██ ██   ███  ██
// ██   ██ ██    ██ ██   ██ ██   ██ ██      ██          ██  ██   ██ ██ ██  ██ ██ ██    ██  ██
// ██████   ██████  ██████  ██████  ███████ ███████      ██ ██   ██ ██ ██   ████  ██████  ██

entity function CreateBubbleBoundary(LocationSettings location)
{
    array<LocPair> spawns = location.spawns
    vector bubbleCenter
    foreach(spawn in spawns)
    {
        bubbleCenter += spawn.origin
    }
    bubbleCenter /= spawns.len()
    float bubbleRadius = 0
    foreach(LocPair spawn in spawns)
    {
        if(Distance(spawn.origin, bubbleCenter) > bubbleRadius)
        bubbleRadius = Distance(spawn.origin, bubbleCenter)
    }
    bubbleRadius += GetCurrentPlaylistVarFloat("bubble_radius_padding", 730)
    entity bubbleShield = CreateEntity( "prop_dynamic" )
	bubbleShield.SetValueForModelKey( BUBBLE_BUNKER_SHIELD_COLLISION_MODEL )
    bubbleShield.SetOrigin(bubbleCenter)
    bubbleShield.SetModelScale(bubbleRadius / 235)
    bubbleShield.kv.CollisionGroup = 0
    bubbleShield.kv.rendercolor = FlowState_BubbleColor()
    DispatchSpawn( bubbleShield )
    thread MonitorBubbleBoundary(bubbleShield, bubbleCenter, bubbleRadius)
    return bubbleShield
}

void function MonitorBubbleBoundary(entity bubbleShield, vector bubbleCenter, float bubbleRadius)
{
    while(IsValid(bubbleShield))
    {
        foreach(player in GetPlayerArray_Alive())
        {
            if(!IsValid(player)) continue
            if(Distance(player.GetOrigin(), bubbleCenter) > bubbleRadius)
            {
				Remote_CallFunction_Replay( player, "ServerCallback_PlayerTookDamage", 0, 0, 0, 0, DF_BYPASS_SHIELD | DF_DOOMED_HEALTH_LOSS, eDamageSourceId.deathField, null )
                player.TakeDamage( int( Deathmatch_GetOOBDamagePercent() / 100 * float( player.GetMaxHealth() ) ), null, null, { scriptType = DF_BYPASS_SHIELD | DF_DOOMED_HEALTH_LOSS, damageSourceId = eDamageSourceId.deathField } )
            }
        }
        wait 1
    }
}

void function PlayerRestoreHP(entity player, float health, float shields)
{
    player.SetHealth( health )
    // Inventory_SetPlayerEquipment(player, "helmet_pickup_lv4_abilities", "helmet")
	// disabled cuz helmets not working :(
    if(shields == 0) return;
    else if(shields <= 50)
        Inventory_SetPlayerEquipment(player, "armor_pickup_lv1", "armor")
    else if(shields <= 75)
        Inventory_SetPlayerEquipment(player, "armor_pickup_lv2", "armor")
    else if(shields <= 100)
        Inventory_SetPlayerEquipment(player, "armor_pickup_lv3", "armor")
    player.SetShieldHealth( shields )
}

 // ██████  ██████  ███████ ███    ███ ███████ ████████ ██  ██████ ███████     ███████ ██    ██ ███    ██  ██████ ████████ ██  ██████  ███    ██ ███████
// ██      ██    ██ ██      ████  ████ ██         ██    ██ ██      ██          ██      ██    ██ ████   ██ ██         ██    ██ ██    ██ ████   ██ ██
// ██      ██    ██ ███████ ██ ████ ██ █████      ██    ██ ██      ███████     █████   ██    ██ ██ ██  ██ ██         ██    ██ ██    ██ ██ ██  ██ ███████
// ██      ██    ██      ██ ██  ██  ██ ██         ██    ██ ██           ██     ██      ██    ██ ██  ██ ██ ██         ██    ██ ██    ██ ██  ██ ██      ██
 // ██████  ██████  ███████ ██      ██ ███████    ██    ██  ██████ ███████     ██       ██████  ██   ████  ██████    ██    ██  ██████  ██   ████ ███████

void function PlayerTrail(entity player, int onoff)
///////////////////
//Thanks Zee#0134//
///////////////////
{
    if (onoff == 1 )
    {
        int smokeAttachID = player.LookupAttachment( "CHESTFOCUS" )
	    vector smokeColor = <255,255,255>
		entity smokeTrailFX = StartParticleEffectOnEntityWithPos_ReturnEntity( player, GetParticleSystemIndex( $"P_grenade_thermite_trail"), FX_PATTACH_ABSORIGIN_FOLLOW, smokeAttachID, <0,0,0>, VectorToAngles( <0,0,-1> ) )

		EffectSetControlPointVector( smokeTrailFX, 1, smokeColor )
        player.p.DEV_lastDroppedSurvivalWeaponProp = smokeTrailFX
    }
	else
    {
        player.p.DEV_lastDroppedSurvivalWeaponProp.Destroy()
    }
}

void function CharSelect( entity player)
///////////////////////////////////////////////////////
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
///////////////////////////////////////////////////////
{
//Char select.
file.characters = clone GetAllCharacters()
ItemFlavor PersonajeEscogido = file.characters[FlowState_ChosenCharacter()]
CharacterSelect_AssignCharacter( ToEHI( player ), PersonajeEscogido )

//Data knife
player.TakeNormalWeaponByIndexNow( WEAPON_INVENTORY_SLOT_PRIMARY_2 )
player.TakeOffhandWeapon( OFFHAND_MELEE )
player.TakeOffhandWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_2 )
player.GiveWeapon( "mp_weapon_melee_survival", WEAPON_INVENTORY_SLOT_PRIMARY_2, [] )
player.GiveOffhandWeapon( "melee_data_knife", OFFHAND_MELEE, [] )
}

// ███████  ██████  ██████  ██████  ███████ ██████   ██████   █████  ██████  ██████
// ██      ██      ██    ██ ██   ██ ██      ██   ██ ██    ██ ██   ██ ██   ██ ██   ██
// ███████ ██      ██    ██ ██████  █████   ██████  ██    ██ ███████ ██████  ██   ██
     // ██ ██      ██    ██ ██   ██ ██      ██   ██ ██    ██ ██   ██ ██   ██ ██   ██
// ███████  ██████  ██████  ██   ██ ███████ ██████   ██████  ██   ██ ██   ██ ██████

void function Message( entity player, string text, string subText = "", float duration = 7.0, string sound = "" )
///////////////////////////////////////////////////////
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
///////////////////////////////////////////////////////
{
	string sendMessage
	for ( int textType = 0 ; textType < 2 ; textType++ )
	{
		sendMessage = textType == 0 ? text : subText

		for ( int i = 0; i < sendMessage.len(); i++ )
		{
			Remote_CallFunction_NonReplay( player, "Dev_BuildClientMessage", textType, sendMessage[i] )
		}
	}
	Remote_CallFunction_NonReplay( player, "Dev_PrintClientMessage", duration )
	if ( sound != "" )
		thread EmitSoundOnEntityOnlyToPlayer( player, player, sound )
}

entity function PlayerWithMostDamage()
//The challenger
//Taken from Gungame Script
{

    int bestDamage = 0
	entity bestPlayer

    foreach(player in GetPlayerArray()) {
        if(!IsValid(player)) continue
        if (int(player.p.playerDamageDealt) > bestDamage) {
            bestDamage = int(player.p.playerDamageDealt)
            bestPlayer = player

        }
    }
    return bestPlayer
}

int function GetDamageOfPlayerWithMostDamage()
//Challenger's score
//Taken from Gungame Script
{
    int bestDamage = 0
    foreach(player in GetPlayerArray()) {
        if(!IsValid(player)) continue
        if (int(player.p.playerDamageDealt) > bestDamage) bestDamage = int(player.p.playerDamageDealt)
    }
    return bestDamage
}

string function PlayerWithMostDamageName()
///////////////////////////////////////////////////////
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
///////////////////////////////////////////////////////
{
entity player = PlayerWithMostDamage()
if(!IsValid(player)) return "-still nobody-"
string damagechampion = player.GetPlayerName()
return damagechampion
}

entity function GetBestPlayer()
//The champion
//Taken from Gungame Script
{
    int bestScore = 0
	entity bestPlayer

    foreach(player in GetPlayerArray()) {
        if(!IsValid(player)) continue
        if (player.GetPlayerGameStat( PGS_KILLS ) > bestScore) {
            bestScore = player.GetPlayerGameStat( PGS_KILLS )
            bestPlayer = player

        }
    }
    return bestPlayer
}

int function GetBestPlayerScore()
//Champion's score
//Taken from Gungame Script
{
    int bestScore = 0
    foreach(player in GetPlayerArray()) {
        if(!IsValid(player)) continue
        if (player.GetPlayerGameStat( PGS_KILLS ) > bestScore) bestScore = player.GetPlayerGameStat( PGS_KILLS )
    }
    return bestScore
}

string function GetBestPlayerName()
///////////////////////////////////////////////////////
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
///////////////////////////////////////////////////////
{
entity player = GetBestPlayer()
if(!IsValid(player)) return "-still nobody-"
string champion = player.GetPlayerName()
return champion
}

float function getkd(int kills, int deaths)
//By michae\l/#1125 & Retículo Endoplasmático#5955
{
float kd
int floorkd
if(deaths == 0) return kills.tofloat();
kd = kills.tofloat() / deaths.tofloat()
kd = kd*100
floorkd = int(floor(kd+0.5))
kd = (float(floorkd))/100
return kd
}

string function Scoreboard()
//Este solo muestra los tres primeros
//Thanks marumaru（vesslanG）#3285
{
array<PlayerInfo> playersInfo = []
        foreach(player in GetPlayerArray())
        {
            PlayerInfo p
            p.name = player.GetPlayerName()
            p.team = player.GetTeam()
			p.score = player.GetPlayerGameStat( PGS_KILLS )
			p.deaths = player.GetPlayerGameStat( PGS_DEATHS )
			p.kd = getkd(p.score,p.deaths)
			p.damage = int(player.p.playerDamageDealt)
			p.lastLatency = int(player.GetLatency()* 1000)
            playersInfo.append(p)
        }
        playersInfo.sort(ComparePlayerInfo)

		string msg = ""
		for(int i = 0; i < playersInfo.len(); i++)
	    {
		    PlayerInfo p = playersInfo[i]
            switch(i)
            {
                case 0:
                    msg = msg + "1. " + p.name + ":     " + p.score + "  |  " + p.deaths + "  |  " + p.kd + "  |  " + p.damage + "\n"
					break
                case 1:
                    msg = msg + "2. " + p.name + ":     " + p.score + "  |  " + p.deaths + "  |  " + p.kd + "  |  " + p.damage + "\n"
                    break
                case 2:
                    msg = msg + "3. " + p.name + ":     " + p.score + "  |  " + p.deaths + "  |  " + p.kd + "  |  " + p.damage + "\n"
                    break
                default:
                    break
            }
        }
		return msg
}

string function ScoreboardFinal(bool fromConsole = false)
//Este muestra el scoreboard completo
//Thanks marumaru（vesslanG）#3285
{
array<PlayerInfo> playersInfo = []
array<PlayerInfo> spectators = []
        foreach(player in GetPlayerArray())
        {
          PlayerInfo p
          p.name = player.GetPlayerName()
          p.team = player.GetTeam()
					p.score = player.GetPlayerGameStat( PGS_KILLS )
					p.deaths = player.GetPlayerGameStat( PGS_DEATHS )
					p.kd = getkd(p.score,p.deaths)
					p.damage = int(player.p.playerDamageDealt)
					p.lastLatency = int(player.GetLatency()* 1000)

					if (fromConsole && player.IsObserver() && IsAlive(player)) {spectators.append(p)}
					else {playersInfo.append(p)}

        }
        playersInfo.sort(ComparePlayerInfo)
		string msg = ""
		for(int i = 0; i < playersInfo.len(); i++)
	    {
		    PlayerInfo p = playersInfo[i]
            switch(i)
            {
                case 0:
                     msg = msg + "1. " + p.name + ":   " + p.score + " | " + p.deaths + " | " + p.kd + " | " + p.damage + "\n"
					break
                case 1:
                    msg = msg + "2. " + p.name + ":   " + p.score + " | " + p.deaths + " | " + p.kd + " | " + p.damage + "\n"
                    break
                case 2:
                    msg = msg + "3. " + p.name + ":   " + p.score + " | " + p.deaths + " | " + p.kd + " | " + p.damage + "\n"
                    break
                default:
					msg = msg + p.name + ":   " + p.score + " | " + p.deaths + " | " + p.kd + " | " + p.damage + "\n"
                    break
            }
        }

		if (fromConsole && spectators.len() > 0) {
			msg += "\n\nSpectating Players:\n"
			for(int i = 0; i < spectators.len(); i++)
		  {
			    PlayerInfo p = spectators[i]
					msg += p.name + "\n"
			}
		}
	return msg
}

string function LatencyBoard()
//By Café
{
array<PlayerInfo> playersInfo = []
        foreach(player in GetPlayerArray())
        {
            PlayerInfo p
            p.name = player.GetPlayerName()
			p.score = player.GetPlayerGameStat( PGS_KILLS )
			p.lastLatency = int(player.GetLatency()* 1000) - 40
            playersInfo.append(p)
        }
        playersInfo.sort(ComparePlayerInfo)
		string msg = ""
		for(int i = 0; i < playersInfo.len(); i++)
	    {
		    PlayerInfo p = playersInfo[i]
            switch(i)
            {
                case 0:
                     msg = msg + "1. " + p.name + ":   " + p.lastLatency  + "ms \n"
					break
                case 1:
                    msg = msg + "2. " + p.name + ":   " + p.lastLatency  + "ms \n"
                    break
                case 2:
                    msg = msg + "3. " + p.name + ":   " + p.lastLatency  + "ms \n"
                    break
                default:
					msg = msg + p.name + ":   " + p.lastLatency + "ms \n"
                    break
            }
        }
		return msg
}

int function ComparePlayerInfo(PlayerInfo a, PlayerInfo b)
//Thanks marumaru（vesslanG）#3285
{
	if(a.score < b.score) return 1;
	else if(a.score > b.score) return -1;
	return 0;
}

void function ResetAllPlayerStats()
// Taken from Gungame Script
{
    foreach(player in GetPlayerArray()) {
        if(!IsValid(player)) continue
        ResetPlayerStats(player)
    }
}

void function ResetPlayerStats(entity player)
// Taken from Gungame Script
{
    player.SetPlayerGameStat( PGS_SCORE, 0 )
    player.SetPlayerGameStat( PGS_DEATHS, 0)
    player.SetPlayerGameStat( PGS_TITAN_KILLS, 0)
    player.SetPlayerGameStat( PGS_KILLS, 0)
    player.SetPlayerGameStat( PGS_PILOT_KILLS, 0)
    player.SetPlayerGameStat( PGS_ASSISTS, 0)
    player.SetPlayerGameStat( PGS_ASSAULT_SCORE, 0)
    player.SetPlayerGameStat( PGS_DEFENSE_SCORE, 0)
    player.SetPlayerGameStat( PGS_ELIMINATED, 0)
}

//  ██████ ██      ██ ███████ ███    ██ ████████      ██████  ██████  ███    ███ ███    ███ ███    ███  █████  ███    ██ ██████  ███████
// ██      ██      ██ ██      ████   ██    ██        ██      ██    ██ ████  ████ ████  ████ ████  ████ ██   ██ ████   ██ ██   ██ ██
// ██      ██      ██ █████   ██ ██  ██    ██        ██      ██    ██ ██ ████ ██ ██ ████ ██ ██ ████ ██ ███████ ██ ██  ██ ██   ██ ███████
// ██      ██      ██ ██      ██  ██ ██    ██        ██      ██    ██ ██  ██  ██ ██  ██  ██ ██  ██  ██ ██   ██ ██  ██ ██ ██   ██      ██
//  ██████ ███████ ██ ███████ ██   ████    ██         ██████  ██████  ██      ██ ██      ██ ██      ██ ██   ██ ██   ████ ██████  ███████



bool function ClientCommand_SpectateEnemies(entity player, array<string> args)
//Thanks Zee#0134
//Modified By CaféDeColombiaFPS
{
    if ( GetGameState() == eGameState.WaitingForPlayers ) {
        return false
    }

    if ( GetGameState() == eGameState.MapVoting ) {
        return false
    }
    array<entity> enemiesArray = GetPlayerArray_Alive()
	enemiesArray.fastremovebyvalue( player )
    if ( enemiesArray.len() > 0 )
    {
        entity specTarget = enemiesArray.getrandom()

        if( specTarget.IsObserver())
        {
            printf("error: try again")
            return false
        }

        if( player.GetPlayerNetInt( "spectatorTargetCount" ) > 0)
        {
            player.SetPlayerNetInt( "spectatorTargetCount", 0 )
	        player.SetSpecReplayDelay( 0 )
            player.StopObserverMode()
			if(IsValidPlayer(player))
			player.TakeDamage(player.GetMaxHealth() + 1, null, null, { damageSourceId=damagedef_suicide, scriptType=DF_BYPASS_SHIELD })
            printf("Respawned!")
        }
        else
        {
			player.MakeInvisible()
            player.SetPlayerNetInt( "spectatorTargetCount", enemiesArray.len() )
	        player.SetSpecReplayDelay( Spectator_GetReplayDelay() )
			try{
	        player.StartObserverMode( OBS_MODE_IN_EYE )
	        player.SetObserverTarget( specTarget )
			}catch(e){}
            printf("Spectating!")
        }
    }
    else
    {
        print("There is no one to spectate!")
    }
    return true
}

bool function ClientCommand_AdminMsg(entity player, array<string> args)
//by Retículo Endoplasmático#5955
{
	if(player.GetPlayerName() == file.Hoster || player.GetPlayerName() == file.admin1 || player.GetPlayerName() == file.admin2 || player.GetPlayerName() == file.admin3 || player.GetPlayerName() == file.admin4) {
		
	string playerName = player.GetPlayerName()
	string str = ""
	foreach (s in args)
		str += " " + s

    string sendMessage = str

    foreach(sPlayer in GetPlayerArray())
    {
Message( sPlayer, "Admin message", playerName + " says: "  + sendMessage, 6)
    }
	}
	else {
	return false
	}
	return true
}


string function helpMessage()
//by michae\l/#1125
{
	return "\n\n CONSOLE COMMANDS:\n\n 1. 'kill_self': if you get stuck.\n2. 'scoreboard': displays scoreboard to user. \n3. 'latency': displays ping of all players to user.\n4. 'say [MESSAGE]': send a public message! (" + FlowState_ChatCooldown().tostring() + "s global cooldown) \n5.'spectate': spectate enemies! \n6. 'commands': display this message again."
}


bool function ClientCommand_Help(entity player, array<string> args)
//by michae\l/#1125
{
	if(IsValid(player)) {
		try{
		Message(player, "WELCOME TO FLOW STATE DM", helpMessage(), 10)
		}catch(e) {}
	}
	return true
}

bool function ClientCommand_ChatBan(entity player, array<string> args)
{
		string str = ""
		foreach (s in args)
		{
			str += " " + s
		}
		str = str.slice(3)

if(player.GetPlayerName() == file.Hoster || player.GetPlayerName() == file.admin1 || player.GetPlayerName() == file.admin2 || player.GetPlayerName() == file.admin3 || player.GetPlayerName() == file.admin4) {
	try{
		switch(args[0])
        {
            case "1":
			file.tempBanned1 = str
			Message(player, "banhammer", str + " is banned from chat in slot 1.", 3)
			break
			case "2":
			file.tempBanned2 = str
			Message(player, "banhammer", str + " is banned from chat in slot 2.", 3)
			break
			case "3":
			file.tempBanned3 = str
			Message(player, "banhammer", str + " is banned from chat in slot 3.", 3)
			break
		}
		
		}catch(e) {}
		}

	else {
	return false
	}
	return true
}

bool function ClientCommand_ChatUnBan(entity player, array<string> args)
{

if(player.GetPlayerName() == file.Hoster || player.GetPlayerName() == file.admin1 || player.GetPlayerName() == file.admin2 || player.GetPlayerName() == file.admin3 || player.GetPlayerName() == file.admin4) {
	try{
		switch(args[0])
        {
            case "1":
			Message(player, "banhammer", file.tempBanned1 + " is unbanned from chat in slot 1.", 3)
			file.tempBanned1 = ""
			break
			case "2":
			Message(player, "banhammer", file.tempBanned2 + " is unbanned from chat in slot 2.", 3)
			file.tempBanned2 = ""
			break
			case "3":
			Message(player, "banhammer", file.tempBanned3 + " is unbanned from chat in slot 3.", 3)
			file.tempBanned3 = ""
			break
		}
		}catch(e) {}
		}

	else {
	return false
	}
	return true
}

bool function ClientCommand_ClientMsg(entity player, array<string> args)
//by Retículo Endoplasmático#5955
{
	//ghetto bans XD
	if (player.GetPlayerName() == file.tempBanned1 || player.GetPlayerName() == file.tempBanned2 || player.GetPlayerName() == file.tempBanned3 || player.GetPlayerName() == GetCurrentPlaylistVarString("flowstateBannedFromChat1", "") || player.GetPlayerName() == GetCurrentPlaylistVarString("flowstateBannedFromChat2", "") || player.GetPlayerName() == GetCurrentPlaylistVarString("flowstateBannedFromChat3", "") || player.GetPlayerName() == GetCurrentPlaylistVarString("flowstateBannedFromChat4", "") || player.GetPlayerName() == GetCurrentPlaylistVarString("flowstateBannedFromChat5", "") || player.GetPlayerName() == GetCurrentPlaylistVarString("flowstateBannedFromChat6", "") || player.GetPlayerName() == GetCurrentPlaylistVarString("flowstateBannedFromChat7", "") || player.GetPlayerName() == GetCurrentPlaylistVarString("flowstateBannedFromChat8", "") || player.GetPlayerName() == GetCurrentPlaylistVarString("flowstateBannedFromChat9", "") || player.GetPlayerName() == GetCurrentPlaylistVarString("flowstateBannedFromChat10", "") )
	{
		Message( player, "Trollbox", "YOU ARE BANNED FROM FLOWSTATE GLOBAL MESSAGES.", 5)
		return false
	}
	
    float cooldown = FlowState_ChatCooldown()
	if( Time() - file.lastTimeChatUsage < cooldown )
    {
		return false
	}
	string str = ""
	foreach (s in args)
		str += " " + s
		
	string finalChat = player.GetPlayerName() + ": " + str + "\n"

	if(currentChatLine < chatLines)
	{
		currentChat = currentChat + finalChat
	}
	else
	{
		currentChat =  finalChat
		currentChatLine = 0
	}

	currentChatLine++
	str = ""
	
	
	switch(GetGameState())
    {
    case eGameState.MapVoting:
		break
	case eGameState.WaitingForPlayers:
        break
    case eGameState.Playing:
	    if(IsValidPlayer(player))
        {
foreach(sPlayer in GetPlayerArray())
    {
	Message( sPlayer, "Trollbox", currentChat, 5)
    }
file.lastTimeChatUsage = Time()
		}
        break
    default:
        break
    }
	return true
}

bool function ClientCommand_ShowLatency(entity player, array<string> args)
//by Retículo Endoplasmático#5955
{
try{
	Message(player,"Latency board", LatencyBoard(), 8)
	}catch(e) {}

return true
}
bool function ClientCommand_GiveWeapon(entity player, array<string> args)
//Modified by Retículo Endoplasmático#5955 and michae\l/#1125
{
    if ( FlowState_AdminTgive() )
	{
		return false
	}

	if(args.len() < 2) return false;
    bool foundMatch = false

	    foreach(weaponName in file.whitelistedWeapons)
    {
        if(args[1] == weaponName)
        {
            foundMatch = true
            break
        }
    }

    if(file.whitelistedWeapons.find(args[1]) == -1 && file.whitelistedWeapons.len()) return false

    entity weapon
    try {
        entity primary = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 )
        entity secondary = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_1 )
        entity tactical = player.GetOffhandWeapon( OFFHAND_TACTICAL )
        entity ultimate = player.GetOffhandWeapon( OFFHAND_ULTIMATE )
        switch(args[0])
        {
            case "p":
            case "primary":
                if( IsValid( primary ) ) player.TakeWeaponByEntNow( primary )
                weapon = player.GiveWeapon(args[1], WEAPON_INVENTORY_SLOT_PRIMARY_0)
                break
            case "s":
            case "secondary":
                if( IsValid( secondary ) ) player.TakeWeaponByEntNow( secondary )
                weapon = player.GiveWeapon(args[1], WEAPON_INVENTORY_SLOT_PRIMARY_1)
                break
            case "t":
            case "tactical":
                 float oldTacticalChargePercent = 0.0
                if( IsValid( tactical ) ) {
                    player.TakeOffhandWeapon( OFFHAND_TACTICAL )
                    oldTacticalChargePercent = float( tactical.GetWeaponPrimaryClipCount()) / float(tactical.GetWeaponPrimaryClipCountMax() )
                }
                weapon = player.GiveOffhandWeapon(args[1], OFFHAND_TACTICAL)
				entity newTactical = player.GetOffhandWeapon( OFFHAND_TACTICAL )
                newTactical.SetWeaponPrimaryClipCount( int( newTactical.GetWeaponPrimaryClipCountMax() * oldTacticalChargePercent ) )
                break
            case "u":
            case "ultimate":
                if( IsValid( ultimate ) ) player.TakeOffhandWeapon( OFFHAND_ULTIMATE )
                weapon = player.GiveOffhandWeapon(args[1], OFFHAND_ULTIMATE)
                break
        }
    }
    catch( e1 ) { }

    if( args.len() > 2 )
    {
        try {
            weapon.SetMods(args.slice(2, args.len()))
        }
        catch( e2 ) {
            print(e2)
        }
    }
    if( IsValid(weapon) && !weapon.IsWeaponOffhand() ) player.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, GetSlotForWeapon(player, weapon))
    return true
}

bool function ClientCommand_NextRound(entity player, array<string> args)
//Thanks Archtux#9300
//Modified by Retículo Endoplasmático#5955 and michae\l/#1125
{
if(player.GetPlayerName() == file.Hoster || player.GetPlayerName() == file.admin1 || player.GetPlayerName() == file.admin2 || player.GetPlayerName() == file.admin3 || player.GetPlayerName() == file.admin4) {
	
    if (args.len()) {
        try{
            int mapIndex = int(args[0])
            file.nextMapIndex = (((mapIndex >= 0 ) && (mapIndex < file.locationSettings.len())) ? mapIndex : RandomIntRangeInclusive(0, file.locationSettings.len() - 1))
            file.mapIndexChanged = true
        } catch (e) {}

        try{
            string now = args[0]
            if (now == "now")
            {
               file.tdmState = eTDMState.NEXT_ROUND_NOW
            }
        } catch(e1) {}

        try{
            string now = args[1]
            if (now == "now")
            {
               file.tdmState = eTDMState.NEXT_ROUND_NOW
            }
        } catch(e2) {}
    }
	}
	else {
	return false
	}
	return true
}

bool function ClientCommand_God(entity player, array<string> args)
///////////////////////////////////////////////////////
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
///////////////////////////////////////////////////////
{
if(player.GetPlayerName() == file.Hoster || player.GetPlayerName() == file.admin1 || player.GetPlayerName() == file.admin2 || player.GetPlayerName() == file.admin3 || player.GetPlayerName() == file.admin4) {
		try{
		player.MakeInvisible()
		MakeInvincible(player)
		HolsterAndDisableWeapons(player)
		}catch(e) {}
}
	else {
	return false
	}
	return true
}

bool function ClientCommand_CircleNow(entity player, array<string> args)
///////////////////////////////////////////////////////
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
///////////////////////////////////////////////////////
{

	if(player.GetPlayerName() == file.Hoster || player.GetPlayerName() == file.admin1 || player.GetPlayerName() == file.admin2 || player.GetPlayerName() == file.admin3 || player.GetPlayerName() == file.admin4) {
		try{
		SummonPlayersInACircle(player)
		}catch(e) {}
	}
	return true
}

bool function ClientCommand_UnGod(entity player, array<string> args)
///////////////////////////////////////////////////////
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
///////////////////////////////////////////////////////
{
	if(player.GetPlayerName() == file.Hoster || player.GetPlayerName() == file.admin1 || player.GetPlayerName() == file.admin2 || player.GetPlayerName() == file.admin3 || player.GetPlayerName() == file.admin4) {
		try{
		player.MakeVisible()
		ClearInvincible(player)
		DeployAndEnableWeapons(player)
		// player.TakeDamage(player.GetMaxHealth() + 1, null, null, { damageSourceId=damagedef_suicide, scriptType=DF_BYPASS_SHIELD })
		}catch(e) {}
	
	}
	else {
	return false
	}
	return true
}

string function getHoster()
{
	return file.Hoster
}

bool function ClientCommand_Scoreboard(entity player, array<string> args)
//by michae\l/#1125
{
	float ping = player.GetLatency() * 1000 - 40
	if(IsValid(player)) {
		try{
		Message(player, "- CURRENT SCOREBOARD - ", "\n               CHAMPION: " + GetBestPlayerName() + " / " + GetBestPlayerScore() + " kills. \n\n Name:    K  |   D   |   KD   |   Damage dealt \n" + ScoreboardFinal(true) + "\n\nYour ping: " + ping.tointeger() + "ms. \nHosted by: " + getHoster(), 4)
		}catch(e) {}
	}
	return true
}

array<entity> function shuffleArray(array<entity> arr)
// O(n) Durstenfeld / Knuth shuffle (https://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle)
//By michae\l/#1125.
{
	int i;
	int j;
	entity tmp;

	for (i = arr.len() - 1; i > 0; i--) {
		j = RandomIntRangeInclusive(1, i)
		tmp = arr[i]
		arr[i] = arr[j]
		arr[j] = tmp
		}

	return arr
}

bool function ClientCommand_RebalanceTeams(entity player, array<string> args)
//By michae\l/#1125 & Retículo Endoplasmático#5955.
{
if(player.GetPlayerName() == file.Hoster || player.GetPlayerName() == file.admin1 || player.GetPlayerName() == file.admin2 || player.GetPlayerName() == file.admin3 || player.GetPlayerName() == file.admin4) {
    int currentTeam = 0 //2
    int numTeams = int(args[0])
        int oldTeam = player.GetTeam()
    int i
    array<entity> randomizedPlayers = shuffleArray(GetPlayerArray())

    foreach (p in randomizedPlayers)
    {
        if (IsValid(p)) {p.Code_SetTeam(TEAM_IMC + 2 + (currentTeam % numTeams))}
                currentTeam += 1
    }

	foreach (sPlayer in GetPlayerArray()){
	Message(sPlayer, "TEAMS REBALANCED", "We have now " + numTeams + " teams.", 4)
	}
      
	}
	else {
	return false
	}
	return true
}


#if SERVER
void function CreateFloor(int x, int y, int z, int width, int length)
//By michae\l/#1125.
{
	int i;
	int j;
	for(i = y; i <= y + (length * 256); i += 256)
	{
		for(j = x; j <= x + (width * 256); j += 256)
		{
			CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <j, i, z>, <0,0,0>)
		}
    }
}
#endif

#if SERVER
void function CreateWall(int x, int y, int z, int length, int height, int angle, bool gates = true)
//a gate = block without prop
//By michae\l/#1125 & Retículo Endoplasmático#5955
// incredibly optimized. i am speed
{
    int i;
    int j;

    // angle MUST be 0 or 90
    //assert(angle == 90 | angle == 0)

    int start = (angle == 90) ? y : x
    int end = start + (length * 256)
    for(i = start; i <= end; i += 256)
    {
        for(j = z; j <= z + (height * 256); j += 256)
        {
            // a gate is always at minimum height, at second to last position on each side of the wall. obviously cannot have gates if length <= 2
            if((start - i == 256 || end - i == 256) && j == z && gates == true) continue;

            else if(angle == 90) CreateFRProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <x, i, j>, <0,90,0>);

            else if (angle == 0) CreateFRProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <i, y, j>, <0,0,0>);
        }
  }
}
#endif

#if SERVER
//By Retículo Endoplasmático#5955 CaféDeColombiaFPS. Tomado del firing range.
entity function CreateFRProp(asset a, vector pos, vector ang, bool mantle = true, float fade = -1)
{
	entity e = CreatePropDynamic(a,pos,ang,SOLID_VPHYSICS,15000)

	e.kv.fadedist = 10000
	e.SetSkin( 0 )
	e.kv.renderamt = 255
	e.kv.rendercolor = "138 255 122"

	if(mantle) e.AllowMantle()
	return e
}
#endif


#if SERVER
//By Retículo Endoplasmático#5955 CaféDeColombiaFPS. Tomado del firing range.
entity function CreateFRProp2(asset a, vector pos, vector ang, bool mantle = true, float fade = -1)
{
	entity e = CreatePropDynamic(a,pos,ang,SOLID_VPHYSICS,15000)

	e.kv.fadedist = 10000
	e.SetSkin( 0 )
	e.kv.renderamt = 255
	e.kv.rendercolor = "127 73 37"

	if(mantle) e.AllowMantle()
	return e
}
#endif


#if SERVER
void function TeleportFRPlayer(entity player, vector pos, vector ang)
//By Retículo Endoplasmático#5955 CaféDeColombiaFPS. Tomado del firing range.
{
	player.SetOrigin(pos)
	player.SetAngles(ang)
	EmitSoundOnEntityOnlyToPlayer( player, player, "PhaseGate_Enter_1p" )
	EmitSoundOnEntityExceptToPlayer( player, player, "PhaseGate_Enter_3p" )
}
#endif


#if SERVER
entity function CreateFRButton(vector pos, vector ang, string prompt)
//By Retículo Endoplasmático#5955 CaféDeColombiaFPS. Tomado del firing range.
{
	entity button = CreateEntity("prop_dynamic")
	button.kv.solid = 6
	button.SetValueForModelKey($"mdl/props/global_access_panel_button/global_access_panel_button_console_w_stand.rmdl")
	button.SetOrigin(pos)
	button.SetAngles(ang)
	DispatchSpawn(button)
	button.SetUsable()
	button.SetUsableByGroup("pilot")
	button.SetUsePrompts(prompt, prompt)
	return button
}
#endif

#if SERVER
void function SpawnSingleDoor(vector doorpos, vector doorang)
//By Retículo Endoplasmático#5955 CaféDeColombiaFPS. Adaptado del firing range.
 {
	entity singleDoor = CreateEntity("prop_door")
	singleDoor.SetValueForModelKey($"mdl/door/canyonlands_door_single_02.rmdl")
	singleDoor.SetOrigin(doorpos)
	singleDoor.SetAngles(doorang)
	DispatchSpawn(singleDoor)
}
#endif

#if SERVER
//By Retículo Endoplasmático#5955 CaféDeColombiaFPS. Adaptado del firing range.
void function SpawnDoubleDoor(vector doorpos, vector doorang)
 {
	entity ddl = CreateEntity("prop_door")
	ddl.SetValueForModelKey($"mdl/door/canyonlands_door_single_02.rmdl")
	ddl.SetAngles(doorang)
	ddl.SetOrigin(doorpos + ddl.GetRightVector() * 60)
	DispatchSpawn(ddl)
	entity ddr = CreateEntity("prop_door")
	ddr.SetValueForModelKey($"mdl/door/canyonlands_door_single_02.rmdl")
	ddr.SetAngles(doorang + <0,180,0>)
	ddr.SetOrigin(doorpos + ddr.GetRightVector() * 60)
	ddr.LinkToEnt( ddl )
	DispatchSpawn(ddr)
 }
#endif


#if SERVER
void function CreateZiplineAAA( vector startPos, vector endPos )
//Thanks Zee#0134.
{
	string startpointName = UniqueString( "rope_startpoint" )
	string endpointName = UniqueString( "rope_endpoint" )
	entity rope_start = CreateEntity( "move_rope" )
	SetTargetNameAAA( rope_start, startpointName )
	rope_start.kv.NextKey = endpointName
	rope_start.kv.MoveSpeed = 64
	rope_start.kv.Slack = 25
	rope_start.kv.Subdiv = "2"
	rope_start.kv.Width = "3"
	rope_start.kv.Type = "0"
	rope_start.kv.TextureScale = "1"
	rope_start.kv.RopeMaterial = "cable/zipline.vmt"
	rope_start.kv.PositionInterpolator = 2
	rope_start.kv.Zipline = "1"
	rope_start.kv.ZiplineAutoDetachDistance = "150"
	rope_start.kv.ZiplineSagEnable = "0"
	rope_start.kv.ZiplineSagHeight = "50"
	rope_start.SetOrigin( startPos )
	entity rope_end = CreateEntity( "keyframe_rope" )
	SetTargetNameAAA( rope_end, endpointName )
	rope_end.kv.MoveSpeed = 64
	rope_end.kv.Slack = 25
	rope_end.kv.Subdiv = "2"
	rope_end.kv.Width = "3"
	rope_end.kv.Type = "0"
	rope_end.kv.TextureScale = "1"
	rope_end.kv.RopeMaterial = "cable/zipline.vmt"
	rope_end.kv.PositionInterpolator = 2
	rope_end.kv.Zipline = "1"
	rope_end.kv.ZiplineAutoDetachDistance = "150"
	rope_end.kv.ZiplineSagEnable = "0"
	rope_end.kv.ZiplineSagHeight = "50"
	rope_end.SetOrigin( endPos )
	DispatchSpawn( rope_start )
	DispatchSpawn( rope_end )
}
#endif




#if SERVER
void function SetTargetNameAAA( entity ent, string name )
{
	ent.SetValueForKey( "targetname", name )
}
#endif

#if SERVER
entity function CreateCustomLight( vector origin, vector angles, string lightcolor, float scale )
{

	entity env_sprite = CreateEntity( "env_sprite" )
	env_sprite.SetScriptName( UniqueString( "molotov_sprite" ) )
	env_sprite.kv.rendermode = 5
	env_sprite.kv.origin = origin
	env_sprite.kv.angles = angles
	env_sprite.kv.fadedist = -1
	env_sprite.kv.rendercolor = lightcolor
	env_sprite.kv.renderamt = 255
	env_sprite.kv.framerate = "10.0"
	env_sprite.SetValueForModelKey( $"sprites/glow_05.vmt" )
	env_sprite.kv.scale = string( scale )
	env_sprite.kv.spawnflags = 1
	env_sprite.kv.GlowProxySize = 15.0
	env_sprite.kv.HDRColorScale = 15.0
	DispatchSpawn( env_sprite )
	EntFireByHandle( env_sprite, "ShowSprite", "", 0, null, null )

    file.playerSpawnedProps.append(env_sprite)

	return env_sprite
}
#endif

#if SERVER
void function AnimationTiming( entity legend, float cycle )
//By Retículo Endoplasmático#5955 CaféDeColombiaFPS.
{
	array<string> animationStrings = ["ACT_MP_MENU_LOBBY_CENTER_IDLE", "ACT_MP_MENU_READYUP_INTRO", "ACT_MP_MENU_LOBBY_SELECT_IDLE", "ACT_VICTORY_DANCE"]
	while( true )
	{
		legend.SetCycle( cycle )
		legend.Anim_Play( animationStrings[RandomInt(animationStrings.len())] )
		WaittillAnimDone(legend)
	}
	WaitForever()
}
#endif

#if SERVER
void function CreateAnimatedLegend(asset a, vector pos, vector ang , int solidtype = 0, float size = 1.0)  // solidtype 0 = no collision, 2 = bounding box, 6 = use vPhysics, 8 = hitboxes only
//By Retículo Endoplasmático#5955 CaféDeColombiaFPS.
{
	entity Legend = CreatePropScript(a, pos, ang, solidtype)
	Legend.kv.teamnumber = 99
	Legend.kv.fadedist = 5000
    Legend.kv.renderamt = 255
	Legend.kv.rendermode = 3
	Legend.kv.rendercolor = "255 255 255 255"
	Legend.SetModelScale( size )
	thread AnimationTiming(Legend, 8.0)
}
#endif

#if SERVER
entity function CreateEditorProp(asset a, vector pos, vector ang, bool mantle = false, float fade = 2000)
{
	entity e = CreatePropDynamic(a,pos,ang,SOLID_VPHYSICS,fade)
	e.kv.fadedist = fade
    e.kv.renderamt = 255
	e.kv.rendermode = 3
	e.kv.rendercolor = "255 255 255 255"
	if(mantle) e.AllowMantle()
    file.playerSpawnedProps.append(e)
	return e
}

entity function CreateDropShipProp(asset a, vector pos, vector ang, bool mantle = false, float fade = 2000, int realm = -1)
{
    entity e = CreatePropDynamic(a,pos,ang,SOLID_VPHYSICS,fade)
    e.kv.fadedist = fade
    if(mantle) e.AllowMantle()

    if (realm > -1) {
        e.RemoveFromAllRealms()
        e.AddToRealm(realm)
    }

    string positionSerialized = pos.x.tostring() + "," + pos.y.tostring() + "," + pos.z.tostring()
    string anglesSerialized = ang.x.tostring() + "," + ang.y.tostring() + "," + ang.z.tostring()

    e.SetScriptName("zoomship")
    e.e.gameModeId = realm
    printl("[editor]" + string(a) + ";" + positionSerialized + ";" + anglesSerialized + ";" + realm)

    return e
}
#endif


                           // 888
                           // 888
                           // 888
 // .d8888b 888  888 .d8888b  888888 .d88b.  88888b.d88b.       88888b.  888d888 .d88b.  88888b.  .d8888b
// d88P"    888  888 88K      888   d88""88b 888 "888 "88b      888 "88b 888P"  d88""88b 888 "88b 88K
// 888      888  888 "Y8888b. 888   888  888 888  888  888      888  888 888    888  888 888  888 "Y8888b.
// Y88b.    Y88b 888      X88 Y88b. Y88..88P 888  888  888      888 d88P 888    Y88..88P 888 d88P      X88
 // "Y8888P  "Y88888  88888P'  "Y888 "Y88P"  888  888  888      88888P"  888     "Y88P"  88888P"   88888P'
                                                             // 888                      888


#if SERVER
void function SkillTrainerLoad()
//////////////////////////////////////////////////
//Retículo Endoplasmático#5955 CaféDeColombiaFPS//
//////////////////////////////////////////////////
{

////////////////////////////////////////////////
//Retículo Endoplasmático#5955 CaféDeColombiaFPS//
////////////////////////////////////////////////
//Piso
CreateFloor(13800, 29000, -869, 25, 25)
CreateFloor(17300,32000, 2200, 2, 2)

//Paredes
CreateWall(14673, 29595, -869, 19, 5, 0)
CreateWall(14673, 33943, -869, 19, 5, 0)
CreateWall(19665, 29450, -869, 17, 5, 90)
CreateWall(14545, 29450, -869, 17, 5, 90)

//Botón de pánico
entity boton = CreateFRButton(<17572, 31978, -340>, <0,-90,0>, "%&use% PANIC BUTTON")
AddCallback_OnUseEntity( boton, void function(entity panel, entity user, int input) {TeleportFRPlayer(user,<17058, 31742, -796>,<13, 0, 0>)})
entity boton2 = CreateFRButton(<16878, 31504, -340>, <0,180,0>, "%&use% PANIC BUTTON")
AddCallback_OnUseEntity( boton2, void function(entity panel, entity user, int input) {TeleportFRPlayer(user,<17058, 31742, -796>,<13, 0, 0>)})
entity boton3 = CreateFRButton(<17660, 32035, -850>, <0,-45,0>, "%&use% PANIC BUTTON")
AddCallback_OnUseEntity( boton3, void function(entity panel, entity user, int input) {TeleportFRPlayer(user,<17235, 31999, -270>,<0, -88, 0>)})

//Puertas
SpawnSingleDoor(<16380, 31232, -340>, <0, 90, 0>)
SpawnSingleDoor(<15870, 31040, -780>, <0, 90, 0>)

//SpawnDoubleDoor(<x,x,x>, <0, 90, 0>)

//Ziplines
CreateZiplineAAA( <18825,30629,-93>, <18109, 32394, -192> )
CreateZiplineAAA( <16129, 30853, -216>, <15525, 29757, -733> )
CreateZiplineAAA( <16882, 33065, -162>, <17797,30755,-162> )
CreateZiplineAAA( <15541, 31860, -95>, <16840, 33043, -85> )
CreateZiplineAAA( <15664, 31759, -97>, <15279, 31256, -884> )
CreateZiplineAAA( <18743, 30536, -101>, <18032,30367,-250> )
CreateZiplineAAA( <17329, 31328, 182>, <16675,30688,-887> )
CreateZiplineAAA( <18391, 33802, -740>, <18119,33144,-218> )
CreateZiplineAAA( <18649,30000,-743>, <18032,30367,-250> )
CreateZiplineAAA( <15633,33794,-705>, <16861,33053,-153> )
CreateZiplineAAA( <17543,31803,-863>, <17986,31242, 178> )
//
CreateZiplineAAA( <17247,31823,2500>, <17248,31824,-890> )
//Zipline del centro con 1 pixel de diferencia para que se pueda usar.
//TODO: Esto se puede mejorar, la zipline se siente rara.
//La función se debe rehacer para que la zipline se sienta igual que la de los edificios. Es usable de todas formas.


//Techo
//CreateFloor(14673, 29719, 155, 20, 20)

//Mesas para las granadas (spawn de granadas y armas en EntitiesDidLoad() function)
CreateEditorProp( $"mdl/colony/farmland_domicile_table_02.rmdl", <19040,33360,-852>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/colony/farmland_domicile_table_02.rmdl", <18912,29968,-852>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/colony/farmland_domicile_table_02.rmdl", <15376,30144,-852>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/colony/farmland_domicile_table_02.rmdl", <15376,33600,-852>, <0,90,0>, true, 8000 )

//Escudos de Spawn
CreateFRProp( $"mdl/fx/turret_shield_wall_02.rmdl", <15008, 30032, -950>, <0,-135,0>)
CreateFRProp( $"mdl/fx/turret_shield_wall_02.rmdl", <14976, 33568, -950>, <0,135,0>)
CreateFRProp( $"mdl/fx/turret_shield_wall_02.rmdl", <19264, 33520, -950>, <0,45,0>)
CreateFRProp( $"mdl/fx/turret_shield_wall_02.rmdl", <19264, 30016, -950>, <0,-45,0>)

//Semi-Bubbles
CreateFRProp2( $"mdl/fx/bb_shield_p4.rmdl", <17248,31824,-370>, <0,135,0>)
CreateFRProp2( $"mdl/fx/bb_shield_p4.rmdl", <17248,31824,-880>, <0,135,0>)

//Luces
//Rojas
CreateCustomLight( <17247, 31823, 2500>, <0,-89,0>, "255 0 0", 1 )
CreateCustomLight( <17247, 31823, 2000>, <0,-89,0>, "255 0 0", 1 )
CreateCustomLight( <17247, 31823, 1500>, <0,-89,0>, "255 0 0", 1 )
CreateCustomLight( <17247, 31823, 1000>, <0,-89,0>, "255 0 0", 1 )
CreateCustomLight( <17247, 31823, 500>, <0,-89,0>, "255 0 0", 1 )
CreateCustomLight( <17247, 31823, 100>, <0,-89,0>, "255 0 0", 1 )
CreateCustomLight( <17247, 31823, -395>, <0,-89,0>, "255 0 0", 1 )
//Verdes
CreateCustomLight( <15008, 30032, -550>, <0,-89,0>, "0 128 0", 1 )
CreateCustomLight( <14976, 33568, -550>, <0,-89,0>, "0 128 0", 1 )
CreateCustomLight( <19264, 33520, -550>, <0,-89,0>, "0 128 0", 1 )
CreateCustomLight( <19264, 30016, -550>, <0,-89,0>, "0 128 0", 1 )

//////////////////////////////////////////////////
//Retículo Endoplasmático#5955 CaféDeColombiaFPS//
//////////////////////////////////////////////////

//Plataforma
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <16209, 30487, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <16465, 30487, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <16721, 30487, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <16977, 30487, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <17233, 30487, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <17489, 30487, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <17745, 30487, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <18001, 30487, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <16209, 30743, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <16465, 30743, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <16721, 30743, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <16977, 30743, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <17233, 30743, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <17489, 30743, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <17745, 30743, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <18001, 30743, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <16209, 30999, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <16465, 30999, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <16721, 30999, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <17233, 30999, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <17489, 30999, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <17745, 30999, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <18001, 30999, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <16209, 31255, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <16465, 31255, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <16721, 31255, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <16977, 31255, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <17233, 31255, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <17489, 31255, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <17745, 31255, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <18001, 31255, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <16209, 31511, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <16465, 31511, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <16721, 31511, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <16977, 31511, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <17233, 31511, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <17489, 31511, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <18001, 31511, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <16209, 31767, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <16465, 31767, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <16721, 31767, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <16977, 31767, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <17233, 31767, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <17489, 31767, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <17745, 31767, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <18001, 31767, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <16977, 31767, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <17489, 31767, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <16209, 32023, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <16465, 32023, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <16721, 32023, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <16977, 32023, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <17233, 32023, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <17489, 32023, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <17745, 32023, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <18001, 32023, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <16209, 32279, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <16465, 32279, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <16721, 32279, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <16977, 32279, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <17233, 32279, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <17489, 32279, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <17745, 32279, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <18001, 32279, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <16209, 32535, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <16465, 32535, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <16721, 32535, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <16977, 32535, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <17489, 32535, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <17745, 32535, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <18001, 32535, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <16209, 32791, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <16465, 32791, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <16721, 32791, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <16977, 32791, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <17233, 32791, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <17489, 32791, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <17745, 32791, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <18001, 32791, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <16209, 33047, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <16465, 33047, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <16721, 33047, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <16977, 33047, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <17233, 33047, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <17489, 33047, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <17745, 33047, -357>, <0,0,0>)
CreateFRProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <18001, 33047, -357>, <0,0,0>)
//////////////////////////////////////////////////
//Retículo Endoplasmático#5955 CaféDeColombiaFPS//
//////////////////////////////////////////////////
//Objetos
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <17184,30416,-870>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <18120,33088,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <18120,32960,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <18120,32832,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <18120,32704,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <18120,32576,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <18120,32448,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <18080,32320,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <18080,32192,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <18080,32064,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <18080,31936,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <18080,31808,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <18080,31680,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <18080,31552,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <18080,31424,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <18080,31296,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <18080,31168,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <18080,31040,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <18080,30912,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <16130,33088,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <16130,32960,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <16130,32832,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <16130,32704,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <16130,32576,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <16130,32448,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <16130,32320,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <16130,32192,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <16130,32064,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <16130,31936,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <16130,31808,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <16130,31680,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <16130,31552,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <16130,31424,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <16130,31296,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <16130,31168,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <16130,31040,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <16130,30912,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/colony/farmland_crate_md_80x64x72_03.rmdl", <16896,32144,-340>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/colony/farmland_crate_md_80x64x72_03.rmdl", <16528,31856,-340>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/colony/farmland_crate_md_80x64x72_03.rmdl", <16176,32000,-340>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_320_01_open.rmdl", <16144,32384,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", <16144,31296,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_small_03.rmdl", <16944,32992,-340>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_small_03.rmdl", <17760,31072,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_small_03.rmdl", <17728,30656,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_small_03.rmdl", <16592,30560,-340>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_small_03.rmdl", <16304,31216,-340>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <16192,31680,-340>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/domestic/cigarette_cluster.rmdl", <15552,32432,-736>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/domestic/cigarette_cluster.rmdl", <15552,32432,-752>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/domestic/cigarette_cluster.rmdl", <15552,32432,-768>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/domestic/cigarette_cluster.rmdl", <15392,32464,-752>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <17152,32944,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <16816,31472,-340>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicles_r5/land/msc_truck_mod_lrg/veh_land_msc_truck_mod_police_lrg_01_closed_static.rmdl", <17856,32048,-340>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicles_r5/land/msc_suv_partum/veh_land_msc_suv_partum_static.rmdl", <17136,30512,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicles_r5/land/msc_suv_partum/veh_land_msc_suv_partum_static.rmdl", <16336,30832,-340>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <16944,31472,-340>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <16576,30992,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <16992,30512,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_01.rmdl", <16400,32208,-340>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16752,32928,-340>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16736,32896,-340>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/desertlands_alien_tree_leaf_small_01.rmdl", <16736,32976,-340>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/desertlands_alien_tree_leaf_small_01.rmdl", <16720,32944,-340>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/desertlands_alien_tree_leaf_small_01.rmdl", <16720,32912,-340>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/desertlands_alien_tree_leaf_small_01.rmdl", <16768,32944,-340>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/desertlands_alien_tree_leaf_small_01.rmdl", <16768,32896,-340>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/desertlands_alien_tree_leaf_small_01.rmdl", <16736,32880,-340>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/desertlands_alien_tree_leaf_small_01.rmdl", <16688,32352,-340>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/desertlands_alien_tree_leaf_small_01.rmdl", <17152,29696,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/domestic/cigarette_cluster.rmdl", <16352,30576,-752>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/domestic/cigarette_cluster.rmdl", <16352,30576,-768>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/domestic/cigarette_cluster.rmdl", <16352,30576,-784>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/domestic/cigarette_cluster.rmdl", <16352,30576,-800>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/desertlands_alien_tree_leaf_small_01.rmdl", <17248,31952,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/desertlands_alien_tree_leaf_small_01.rmdl", <17120,31808,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/desertlands_alien_tree_leaf_small_02.rmdl", <17184,31712,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/desertlands_alien_tree_leaf_small_02.rmdl", <16704,32928,-340>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/desertlands_alien_tree_leaf_small_02.rmdl", <16768,32880,-340>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/desertlands_alien_tree_leaf_small_02.rmdl", <16736,32928,-340>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/brute_small_tiger_plant_02.rmdl", <16688,32880,-340>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/brute_small_tiger_plant_02.rmdl", <16480,32336,-340>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/brute_small_tiger_plant_02.rmdl", <17360,31792,-340>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/floating_village/lagoon_window_metal_shutters_open_80x128.rmdl", <17856,31872,-340>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/floating_village/lagoon_window_metal_shutters_open_80x128.rmdl", <17856,32224,-340>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/tree_brush_yellow_large_03.rmdl", <16752,32928,-340>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_ground_plant_02.rmdl", <16720,32896,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/grass_icelandic_04.rmdl", <17312,31936,-340>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/grass_icelandic_04.rmdl", <17120,31776,-340>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/grass_icelandic_04.rmdl", <17280,31696,-340>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/grass_icelandic_04.rmdl", <17168,31904,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/grass_icelandic_04.rmdl", <17296,31712,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/grass_icelandic_03.rmdl", <17376,31824,-850>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/grass_icelandic_03.rmdl", <17200,31936,-340>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/desertlands_alien_tree_02.rmdl", <18528,32128,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <16960,31376,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <17088,31376,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <17216,31376,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <17344,31376,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <17472,31376,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <16896,30976,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <16896,31104,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <15808,31168,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <15680,31184,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <16080,32416,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <16208,32400,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <16336,32400,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <15936,31168,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <16880,31232,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <16816,32144,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <16896,32224,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/domestic/cigarette_cluster.rmdl", <16256,30672,-752>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/domestic/cigarette_cluster.rmdl", <16256,30672,-768>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/domestic/cigarette_cluster.rmdl", <16256,30672,-784>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/domestic/cigarette_cluster.rmdl", <16256,30672,-800>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <16976,32304,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <17424,32752,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_small_03.rmdl", <17664,32112,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_small_03.rmdl", <17792,31504,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_small_03.rmdl", <17328,30976,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/goblin_dropship/goblin_dropship_holo.rmdl", <14992,30016,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/goblin_dropship/goblin_dropship_holo.rmdl", <19264,30000,-850>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/goblin_dropship/goblin_dropship_holo.rmdl", <19264,33520,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/goblin_dropship/goblin_dropship_holo.rmdl", <14976,33584,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence.rmdl", <17024,31120,-340>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence.rmdl", <16912,31120,-340>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence.rmdl", <17296,32400,-340>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence.rmdl", <17184,32400,-340>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence.rmdl", <17296,32656,-340>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence.rmdl", <17184,32656,-340>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence.rmdl", <17040,30864,-340>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence.rmdl", <16928,30864,-340>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence.rmdl", <17808,31376,-340>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence.rmdl", <17696,31376,-340>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence.rmdl", <17808,31632,-340>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence.rmdl", <17696,31632,-340>, <0,90,0>, true, 8000 )
CreateFRProp( $"mdl/vehicle/goblin_dropship/goblin_dropship.rmdl", <15616, 31808, -200>, <0,0,0>)
CreateFRProp( $"mdl/vehicle/goblin_dropship/goblin_dropship.rmdl", <18736, 30624, -200>, <0,135,0>)
CreateEditorProp( $"mdl/foliage/desertlands_alien_tree_large_root_01.rmdl", <19584,30880,176>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/desertlands_alien_tree_large_root_01.rmdl", <14544,30272,96>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/desertlands_alien_tree_large_root_01.rmdl", <17824,33696,176>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/goblin_dropship/goblin_dropship.rmdl", <16976,32848,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/desertlands/research_station_small_building_floor_01.rmdl", <18352,30192,-855>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/desertlands/research_station_small_building_floor_01.rmdl", <19168,32976,-855>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_small_01.rmdl", <17984,32720,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_small_01.rmdl", <17984,32464,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_small_02.rmdl", <16128,33792,-855>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_small_02.rmdl", <16288,29744,-855>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_small_02.rmdl", <18128,31072,-855>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/desertlands/research_station_stairs_bend_01.rmdl", <19136,32112,-855>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/desertlands/research_station_stairs_bend_01.rmdl", <16608,32400,-335>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/domestic/cigarette_cluster.rmdl", <15392,32464,-768>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/domestic/cigarette_cluster.rmdl", <15392,32464,-784>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/domestic/cigarette_cluster.rmdl", <19088,31904,-736>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/domestic/cigarette_cluster.rmdl", <19088,31904,-752>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/domestic/cigarette_cluster.rmdl", <19088,31904,-768>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/desertlands/research_station_stairs_corner_02.rmdl", <15232,32064,-855>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", <18800,30144,-860>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", <18400,30240,-860>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", <15200,32368,-860>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", <15600,32480,-860>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", <19168,32896,-860>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", <16768,32224,-340>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", <16224,30528,-860>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/pipes/slum_pipe_large_yellow_512_01.rmdl", <17792,30768,-340>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/domestic/cigarette_cluster.rmdl", <15168,32368,-624>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/domestic/cigarette_cluster.rmdl", <15168,32368,-640>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/domestic/cigarette_cluster.rmdl", <15168,32368,-656>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/domestic/cigarette_cluster.rmdl", <19360,32752,-752>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/domestic/cigarette_cluster.rmdl", <19360,32752,-768>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/domestic/cigarette_cluster.rmdl", <19360,32752,-784>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/domestic/cigarette_cluster.rmdl", <18432,30560,-656>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/domestic/cigarette_cluster.rmdl", <18432,30560,-672>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/domestic/cigarette_cluster.rmdl", <18432,30560,-688>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/domestic/cigarette_cluster.rmdl", <16112,30320,-720>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/domestic/cigarette_cluster.rmdl", <16112,30320,-736>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/pipes/slum_pipe_large_yellow_512_01.rmdl", <16432,31248,-340>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/pipes/slum_pipe_large_yellow_512_01.rmdl", <16864,33040,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_320_01_open.rmdl", <15424,32208,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_320_01_open.rmdl", <16128,30528,-770>, <0,-45,25>, true, 8000 )
CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_320_01_open.rmdl", <19104,31872,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_320_01_open.rmdl", <16848,32192,-250>, <0,135,35>, true, 8000 )
CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_320_01_open.rmdl", <17872,32784,-250>, <0,-90,25>, true, 8000 )
CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_320_01_open.rmdl", <18432,30560,-770>, <0,-45,-25>, true, 8000 )
CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_320_01_open.rmdl", <15984,30720,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_320_01_open.rmdl", <15184,32368,-730>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_320_01_open.rmdl", <16304,32880,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/desertlands/research_station_container_big_01.rmdl", <16512,31552,-340>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/desertlands/research_station_container_big_01.rmdl", <16512,30608,-340>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/desertlands/research_station_container_big_01.rmdl", <19168,32336,-860>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/desertlands/research_station_container_big_01.rmdl", <18704,30480,-860>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/desertlands/research_station_container_big_01.rmdl", <15088,30608,-860>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/IMC_base/cargo_container_imc_01_white_open.rmdl", <17728,33072,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/IMC_base/cargo_container_imc_01_white_open.rmdl", <16224,32928,-340>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/IMC_base/cargo_container_imc_01_white_open.rmdl", <17984,30416,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/IMC_base/cargo_container_imc_01_white_open.rmdl", <14608,30784,-860>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/IMC_base/cargo_container_imc_01_red.rmdl", <15232,32576,-860>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/IMC_base/cargo_container_imc_01_red.rmdl", <15648,32480,-860>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/IMC_base/cargo_container_imc_01_blue.rmdl", <19616,30752,-860>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/IMC_base/cargo_container_imc_01_blue.rmdl", <19616,30880,-860>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/IMC_base/cargo_container_imc_01_blue.rmdl", <19616,31008,-860>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/domestic/cigarette_cluster.rmdl", <18864,30208,-736>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/domestic/cigarette_cluster.rmdl", <18864,30208,-752>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/domestic/cigarette_cluster.rmdl", <18864,30208,-768>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/domestic/cigarette_cluster.rmdl", <16208,30416,-688>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/domestic/cigarette_cluster.rmdl", <16208,30416,-704>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/domestic/cigarette_cluster.rmdl", <16208,30416,-720>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/IMC_base/cargo_container_imc_01_blue.rmdl", <19616,31136,-860>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_small_01.rmdl", <17648,33232,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_small_01.rmdl", <17520,33232,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_small_01.rmdl", <17392,33232,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", <17395,33304,-656>, <0,-90,90>, true, 8000 )
CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", <16848,32368,-700>, <0,45,90>, true, 8000 )
CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_small_03.rmdl", <16816,32352,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_small_03.rmdl", <17280,33296,-496>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/colony/farmland_crate_md_80x64x72_03.rmdl", <17808,31008,-340>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/colony/farmland_crate_md_80x64x72_03.rmdl", <16848,31248,-340>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/colony/farmland_crate_md_80x64x72_03.rmdl", <16496,32784,-340>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/colony/farmland_crate_md_80x64x72_03.rmdl", <17488,33088,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <19648,33920,55>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/fx/medic_shield_wall.rmdl", <19648,33920,70>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/industrial/traffic_cone_01.rmdl", <19552,33872,72>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/industrial/traffic_cone_01.rmdl", <19600,33808,72>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/industrial/traffic_cone_01.rmdl", <19520,33904,72>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/industrial/traffic_cone_01.rmdl", <19584,33840,72>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/industrial/traffic_cone_01.rmdl", <19632,33792,72>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/fx/medic_shield_wall.rmdl", <14592,33920,-64>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/fx/medic_shield_wall.rmdl", <14576,29600,-448>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/fx/medic_shield_wall.rmdl", <19616,29600,-112>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <19632,29600,-112>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <14560,29600,-460>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <14576,33920,-64>, <0,135,0>, true, 8000 )
//////////////////////////////////////////////////
//Retículo Endoplasmático#5955 CaféDeColombiaFPS//
//////////////////////////////////////////////////
//Pasto-Grass
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19168,33120,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17232,31648,-333>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17136,31712,-333>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17136,31824,-333>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17232,31776,-333>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17328,31680,-333>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17392,31760,-333>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17408,31856,-333>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17344,31920,-333>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17232,31968,-333>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17168,31904,-333>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17264,31840,-333>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17296,31744,-333>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17088,31792,-333>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17088,31872,-333>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17312,31984,-333>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17152,31984,-333>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17232,31648,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17136,31712,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17136,31824,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17232,31776,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17328,31680,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17392,31760,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17408,31856,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17344,31920,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17232,31968,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17168,31904,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17264,31840,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17296,31744,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17088,31792,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17088,31872,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17312,31984,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17152,31984,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15344,32512,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15408,32576,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15472,32640,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15536,32704,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15568,32736,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16288,30400,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16208,30336,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16064,30544,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16064,30624,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18608,30272,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18688,30336,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18528,30384,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18608,30400,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18448,30448,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18800,30416,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18560,30480,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18400,30528,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19168,31984,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19168,31888,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19168,31792,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19168,31712,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19168,33216,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19168,33312,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18560,29984,-850>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18240,30096,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18208,30048,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18272,30512,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18192,30464,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18144,30400,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18112,30288,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18112,30192,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18128,30096,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18272,29936,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18352,29936,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18416,29936,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18496,29936,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18160,29984,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18640,29936,-850>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18768,29952,-850>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18784,30032,-850>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18864,30080,-850>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18880,30128,-850>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18928,30160,-850>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18992,30224,-850>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19024,30336,-850>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18896,30448,-850>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18976,30416,-850>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19264,31728,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19264,31824,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19280,31872,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19280,31936,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19280,32096,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19280,32048,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19040,32000,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19024,31920,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19024,31840,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19024,31792,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19040,31744,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19072,31680,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19152,31664,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19152,32112,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19056,32064,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19024,32704,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19104,32704,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19152,32704,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19216,32688,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19264,32688,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19312,32704,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15456,32256,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15504,32336,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15552,32368,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15552,32256,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15648,32304,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15648,32384,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15712,32448,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15760,32496,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15760,32560,-850>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15824,32656,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15776,32736,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15744,32768,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15632,32784,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15808,32608,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15264,32272,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15200,32304,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15152,32336,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15120,32384,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15088,32400,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15056,32448,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <14976,32544,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15056,32592,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15136,32640,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15280,32624,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15216,32688,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18912,32720,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18880,32816,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18880,32880,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18896,32960,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18912,33040,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19024,33120,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19120,33184,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19392,32736,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19424,32896,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19440,32768,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19424,33008,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19424,33072,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19360,33120,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19328,33200,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19264,33216,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16752,32016,-333>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16704,32064,-333>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16656,32112,-333>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16608,32160,-333>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16592,32192,-333>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16528,32224,-333>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16464,32320,-333>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16448,32384,-333>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16480,32496,-333>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16544,32528,-333>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16624,32464,-333>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16704,32384,-333>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16784,32288,-333>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16848,32208,-333>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16912,32160,-333>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16944,32080,-333>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16912,32000,-333>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16816,31952,-333>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16368,30320,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16464,30416,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16416,30352,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16544,30480,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16496,30512,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16448,30576,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16432,30624,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16352,30688,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16304,30736,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16224,30784,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16128,30848,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16064,30768,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16016,30688,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16000,30464,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15920,30352,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15968,30304,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16016,30256,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16096,30256,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16208,30288,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16272,30256,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16144,30208,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16544,32400,-333>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16592,32384,-333>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16528,32336,-333>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", <17360,29680,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", <17312,29680,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", <17280,29680,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", <17264,29696,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", <17216,29696,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", <17200,29680,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", <17168,29696,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", <17136,29696,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", <17104,29696,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", <17120,29712,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", <17120,29744,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", <17120,29776,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", <17136,29792,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", <17152,29776,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", <17152,29744,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", <17200,29728,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", <17200,29760,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", <17216,29808,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", <17232,29792,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", <17248,29792,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", <17264,29760,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", <17280,29712,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", <17296,29712,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", <17328,29712,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", <17360,29712,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", <17360,29744,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", <17328,29776,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", <17296,29776,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", <17168,29792,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", <17280,29776,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", <17120,29648,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", <17200,29664,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", <17152,29648,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", <17216,29664,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", <17200,29632,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", <17232,29632,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", <17280,29600,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", <17360,29632,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", <17296,29648,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", <17312,29616,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16208,32016,-338>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16544,30608,-338>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16464,30640,-338>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17776,30960,-338>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17840,30992,-338>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17856,31856,-338>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17856,32240,-338>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18048,32912,-338>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18048,32928,-338>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17824,31104,-338>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17776,31104,-338>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17888,31024,-338>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17888,31104,-338>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17744,31040,-338>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17776,30704,-338>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16576,30992,-338>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17616,31984,-338>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16912,31424,-338>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16896,31456,-338>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17744,32096,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17696,32016,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17776,32848,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16496,31840,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16496,31568,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16496,31760,-850>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16480,31664,-850>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16400,31760,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15088,30624,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15136,30608,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <14896,30016,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <14912,29968,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <14960,29920,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15024,29920,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15088,29952,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15104,30016,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15088,30080,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15040,30112,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <14960,30112,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <14912,30064,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <14992,30016,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <14992,30016,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19360,30016,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19344,30064,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19296,30080,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19248,30064,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19200,30032,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19168,30016,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19168,29968,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19200,29936,-850>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19232,29904,-850>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19280,29888,-850>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19296,29904,-850>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19328,29936,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19344,29968,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19280,29984,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19280,29984,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19200,30096,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19248,30128,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19312,30112,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19248,33632,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19200,33600,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19168,33536,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19184,33488,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19232,33440,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19296,33440,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19344,33472,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19360,33536,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19312,33600,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19280,33520,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19280,33520,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19312,33616,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19360,33568,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17328,33312,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17344,33136,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15952,33920,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15872,33920,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <14912,33680,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <14864,33632,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <14864,33568,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <14896,33520,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <14928,33488,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15008,33472,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15056,33488,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15088,33536,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15072,33616,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15008,33680,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <14944,33536,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15008,33536,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <14896,33488,-850>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <14960,33440,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <14928,33648,-850>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19184,33632,-850>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19168,33584,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19152,33504,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19168,33440,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19216,33392,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19280,33392,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19328,33408,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19376,33472,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19392,33536,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19232,33280,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18624,32560,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18656,32432,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18624,32416,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18656,32304,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18704,32320,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18688,32240,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18672,32144,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18672,32112,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18608,32000,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18496,31936,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18560,32000,-850>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18560,31984,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18432,32032,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18464,31984,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18400,32064,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18384,32128,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18400,32192,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18400,32240,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18400,32304,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18432,32384,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18496,32480,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18544,32544,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18560,32352,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18528,32400,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18464,32432,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18480,32464,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17984,33072,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18112,33200,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <18048,33136,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17312,33232,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17328,33184,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17424,33072,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17824,32768,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17984,31856,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17456,30976,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17472,30944,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17504,30912,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17024,30304,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17024,30336,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16960,30384,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16992,30448,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17008,30512,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17072,30576,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17120,30512,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17120,30464,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17120,30336,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17120,30256,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17056,30272,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16208,30432,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16144,30544,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16112,30592,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16112,30384,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16032,30384,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16080,30480,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15920,30416,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16400,31584,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16400,31664,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15360,32208,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15584,32448,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19136,30080,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19216,30144,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19296,30144,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19360,30096,-850>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19392,30032,-850>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19392,30000,-850>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19376,29968,-850>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19232,29904,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19200,29920,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <19136,30000,-850>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15008,29904,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15056,29920,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15104,29952,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15136,30000,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15104,30080,-850>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15056,30144,-850>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <14944,30144,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <14880,30080,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15072,30544,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15024,30592,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15248,32288,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15200,32272,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15152,32272,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <14832,33600,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <14848,33504,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <14912,33456,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15008,33440,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15088,33488,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15104,33584,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15056,33696,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <14944,33712,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <14976,33712,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15088,33648,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15504,33568,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15504,33520,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15552,33504,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15552,33472,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15584,33408,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15568,33328,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15504,33280,-850>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15456,33296,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15424,33392,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15424,33440,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15648,33728,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15920,33824,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <15936,33920,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16288,33888,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16272,33840,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16320,33792,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17648,32096,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17664,32048,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17904,31936,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17888,31872,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17920,31952,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17904,32800,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17600,33088,-850>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17872,32880,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17488,33088,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17424,32736,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17376,32784,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17424,31872,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17456,31824,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17392,31712,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17360,31680,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17312,31648,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17232,31632,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17168,31664,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17136,31696,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17104,31728,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17088,31744,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17072,31792,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17088,31920,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17104,31968,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17216,31984,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17344,31968,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17408,31872,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17264,31808,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17408,31904,-340>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17392,31952,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17264,31984,-340>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17200,32000,-340>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17104,31936,-340>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17072,31872,-340>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17072,31776,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17136,31680,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17248,31648,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17408,31696,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17328,31648,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17424,31792,-340>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17840,31968,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17856,32048,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <17840,32112,-340>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", <16272,30896,-340>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/plant_tobacco_large_03.rmdl", <17328,29696,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/plant_tropical_ground_leafy_01.rmdl", <17264,29664,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/plant_tobacco_large_03.rmdl", <17152,29648,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/plant_agave_01.rmdl", <17136,29728,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/tree_brush_yellow_large_03.rmdl", <17280,29744,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/tree_acacia_small_03.rmdl", <17200,29712,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/holy_e_ear_plant.rmdl", <17200,29776,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/haven/haven_bamboo_tree_02.rmdl", <17216,29680,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/haven/haven_bamboo_tree_02.rmdl", <17328,29744,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/garbage/trash_can_metal_02_b.rmdl", <17312,29776,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/garbage/trash_bin_single_wtrash_Blue.rmdl", <17152,29760,-850>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/garbage/garbage_bag_plastic_a.rmdl", <17248,29728,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/industrial/cafe_coffe_machine.rmdl", <16160,30368,-800>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/industrial/cafe_coffe_machine.rmdl", <16304,30624,-800>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/industrial/cafe_coffe_machine.rmdl", <15296,32448,-800>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/industrial/cafe_coffe_machine.rmdl", <15504,32384,-800>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/industrial/cafe_coffe_machine.rmdl", <19392,32848,-800>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/industrial/cafe_coffe_machine.rmdl", <19232,31888,-800>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/industrial/cafe_coffe_machine.rmdl", <18816,30160,-800>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/industrial/construction_materials_cart_03.rmdl", <16784,31984,-340>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/industrial/construction_materials_cart_03.rmdl", <16608,32144,-340>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/industrial/construction_materials_cart_03.rmdl", <18080,31232,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/industrial/construction_materials_cart_03.rmdl", <18224,31232,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/industrial/construction_materials_cart_03.rmdl", <18848,32848,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", <19184,32672,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", <19312,31952,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", <18464,30416,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/industrial/traffic_barrel_02.rmdl", <16288,33808,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/industrial/traffic_barrel_02.rmdl", <16128,33712,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/industrial/traffic_barrel_02.rmdl", <15952,33792,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/industrial/traffic_barrel_02.rmdl", <17232,31776,-340>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/industrial/traffic_barrel_02.rmdl", <17232,31808,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/lamps/warning_light_ON_red.rmdl", <17152,31696,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/lamps/warning_light_ON_red.rmdl", <17088,31792,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/lamps/warning_light_ON_red.rmdl", <17328,31904,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/lamps/warning_light_ON_red.rmdl", <17312,31664,-850>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/lamps/warning_light_ON_red.rmdl", <17360,31728,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/lamps/warning_light_ON_red.rmdl", <17280,31888,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/lamps/warning_light_ON_red.rmdl", <17088,31856,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/props/death_box/death_box_01_gladcard.rmdl", <18032,32192,-340>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/props/death_box/death_box_01_gladcard.rmdl", <18032,31872,-340>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/rocks/rock_lava_cluster_desertlands_03.rmdl", <18816,33040,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/rocks/rock_lava_cluster_desertlands_03.rmdl", <19024,31792,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/rocks/rock_lava_cluster_desertlands_03.rmdl", <17248,31920,-850>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/rocks/rock_lava_cluster_desertlands_03.rmdl", <16128,30832,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/rocks/rock_lava_cluster_desertlands_03.rmdl", <15792,32512,-850>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/rocks/rock_lava_cluster_desertlands_03.rmdl", <15584,32784,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/garbage/trash_bin_single_wtrash.rmdl", <19024,32736,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/garbage/trash_bin_single_wtrash.rmdl", <16448,30528,-850>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/garbage/trash_bin_single_wtrash.rmdl", <14592,31696,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/garbage/trash_bin_single_wtrash.rmdl", <15616,32704,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/garbage/garbage_bag_plastic_a.rmdl", <17312,31712,-340>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/garbage/garbage_bag_plastic_a.rmdl", <17248,31952,-340>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/garbage/garbage_bag_plastic_a.rmdl", <17200,31824,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/garbage/garbage_bag_plastic_a.rmdl", <17376,31792,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/garbage/trash_can_metal_02_b.rmdl", <17344,31760,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/garbage/trash_can_metal_02_b.rmdl", <17184,31904,-340>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/garbage/trash_can_metal_02_b.rmdl", <17216,31744,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/garbage/trash_can_metal_02_b.rmdl", <17360,31904,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/plant_agave_01.rmdl", <16288,30352,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/plant_agave_01.rmdl", <16016,30272,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/plant_agave_01.rmdl", <16048,30512,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/plant_agave_01.rmdl", <16336,30720,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/plant_agave_01.rmdl", <16400,30624,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/plant_agave_01.rmdl", <15168,32288,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/plant_agave_01.rmdl", <15072,32400,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/plant_agave_01.rmdl", <15344,32560,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/plant_agave_01.rmdl", <15456,32688,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/plant_agave_01.rmdl", <15584,32304,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/plant_agave_01.rmdl", <15808,32592,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/plant_agave_01.rmdl", <17296,31776,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/plant_agave_01.rmdl", <17152,31760,-340>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/plant_agave_01.rmdl", <16736,31984,-340>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/plant_agave_01.rmdl", <16512,32128,-340>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/plant_agave_01.rmdl", <16816,32256,-340>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/plant_agave_01.rmdl", <19056,31872,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/plant_agave_01.rmdl", <19264,31824,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/plant_agave_01.rmdl", <19168,31792,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/plant_agave_01.rmdl", <19184,32688,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/plant_agave_01.rmdl", <18816,32944,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/plant_agave_01.rmdl", <19104,33232,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/plant_agave_01.rmdl", <19376,33072,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/plant_agave_01.rmdl", <19440,32784,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/garbage/dumpster_dirty_open_a_02.rmdl", <17024,29632,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/plant_agave_01.rmdl", <18960,30416,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/plant_agave_01.rmdl", <18864,30128,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/plant_agave_01.rmdl", <18576,29936,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/plant_agave_01.rmdl", <18224,30064,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/plant_agave_01.rmdl", <18112,30352,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/foliage/plant_agave_01.rmdl", <18640,30288,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicles_r5/land/msc_truck_mod_lrg/veh_land_msc_truck_mod_police_lrg_01_closed_static.rmdl", <15168,31072,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicles_r5/land/msc_truck_mod_lrg/veh_land_msc_truck_mod_police_lrg_01_closed_static.rmdl", <18880,31696,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicles_r5/land/msc_truck_samson_v2/veh_land_msc_truck_samson_v2.rmdl", <17456,30976,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicles_r5/land/msc_truck_samson_v2/veh_land_msc_truck_samson_v2.rmdl", <18064,33152,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicles_r5/land/msc_suv_partum/veh_land_msc_suv_partum_static.rmdl", <15504,32752,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicles_r5/land/msc_forklift_imc_v2/veh_land_msc_forklift_imc_v2_static.rmdl", <16512,33760,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicles_r5/land/msc_forklift_imc_v2/veh_land_msc_forklift_imc_v2_static.rmdl", <16704,33744,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicles_r5/land/msc_forklift_imc_v2/veh_land_msc_forklift_imc_v2_static.rmdl", <16896,33728,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicles_r5/land/msc_forklift_imc_v2/veh_land_msc_forklift_imc_v2_static.rmdl", <17088,33712,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicles_r5/land/msc_forklift_imc_v2/veh_land_msc_forklift_imc_v2_static.rmdl", <17280,33696,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicles_r5/land/msc_forklift_imc_v2/veh_land_msc_forklift_imc_v2_static.rmdl", <18048,29776,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicles_r5/land/msc_forklift_imc_v2/veh_land_msc_forklift_imc_v2_static.rmdl", <17872,29744,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicles_r5/land/msc_forklift_imc_v2/veh_land_msc_forklift_imc_v2_static.rmdl", <17648,29744,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicles_r5/land/msc_forklift_imc_v2/veh_land_msc_forklift_imc_v2_static.rmdl", <16288,31008,-340>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/water/water_puddle_decal_01.rmdl", <17760,29728,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/water/water_puddle_decal_01.rmdl", <17968,29728,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/water/water_puddle_decal_01.rmdl", <17376,29760,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/thaw/thaw_rock_horizontal_01.rmdl", <17056,30448,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/thaw/thaw_rock_horizontal_01.rmdl", <15136,32400,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/thaw/thaw_rock_horizontal_01.rmdl", <15488,33440,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/containers/container_medium_tanks_blue.rmdl", <18096,33056,-850>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/containers/container_medium_tanks_blue.rmdl", <15264,31136,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/containers/container_medium_tanks_blue.rmdl", <18096,31040,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/containers/container_medium_tanks_blue.rmdl", <19200,32736,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/containers/container_medium_tanks_blue.rmdl", <17488,31056,-850>, <0,-45,0>, true, 8000 )
CreateEditorProp( $"mdl/containers/lagoon_roof_tanks_02.rmdl", <17632,32384,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/containers/lagoon_roof_tanks_02.rmdl", <16496,31728,-850>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/containers/lagoon_roof_tanks_02.rmdl", <17440,30912,-340>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/containers/lagoon_roof_tanks_02.rmdl", <14624,32256,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/containers/lagoon_roof_tanks_02.rmdl", <14624,31968,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/containers/lagoon_roof_tanks_02.rmdl", <14624,32496,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/containers/lagoon_roof_tanks_02.rmdl", <17744,33824,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/containers/lagoon_roof_tanks_02.rmdl", <18016,33824,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/containers/lagoon_roof_tanks_02.rmdl", <18288,33824,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/containers/lagoon_roof_tanks_02.rmdl", <15776,33824,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/containers/lagoon_roof_tanks_02.rmdl", <15648,29696,-850>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/containers/lagoon_roof_tanks_02.rmdl", <19568,31552,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/IMC_base/cargo_container_imc_01_blue.rmdl", <16496,32960,-850>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <16480,31824,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <17600,32192,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <17600,32064,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <17600,31936,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <16480,31952,-340>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <17488,30352,-340>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <17360,30352,-340>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <17232,30352,-340>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <17104,30352,-340>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <16976,30352,-340>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/colony/farmland_crate_md_80x64x72_03.rmdl", <16816,32992,-340>, <0,45,0>, true, 8000 )
CreateEditorProp( $"mdl/pipes/slum_pipe_large_blue_512_01.rmdl", <17952,31904,-850>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/pipes/slum_pipe_large_blue_512_01.rmdl", <17856,32832,-850>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/pipes/slum_pipe_large_blue_512_01.rmdl", <16544,30848,-850>, <0,90,0>, true, 8000 )
//////////////////////////////////////////////////
//Retículo Endoplasmático#5955 CaféDeColombiaFPS//
//////////////////////////////////////////////////
//Lámparas
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <14672,29600,-560>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <14928,29600,-560>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <15184,29600,-560>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <15440,29600,-560>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <15696,29600,-560>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <15952,29600,-560>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <16208,29600,-560>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <16464,29600,-560>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <16720,29600,-560>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <16976,29600,-560>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <17232,29600,-560>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <17488,29600,-560>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <17744,29600,-560>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <18000,29600,-560>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <18256,29600,-560>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <18512,29600,-560>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <18768,29600,-560>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <19024,29600,-560>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <19280,29600,-560>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <19536,29600,-560>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <19648,29712,-560>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <19648,29968,-560>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <19648,30224,-560>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <19648,30480,-560>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <19648,30736,-560>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <19648,31008,-560>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <19648,31264,-560>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <19648,31504,-560>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <19648,31760,-560>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <19648,32016,-560>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <19648,32288,-560>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <19648,32528,-560>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <19648,32784,-560>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <19648,33040,-560>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <19648,33296,-560>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <19648,33552,-560>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <19648,33808,-560>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <19536,33920,-560>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <19280,33920,-560>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <19024,33920,-560>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <18768,33920,-560>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <18512,33920,-560>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <18256,33920,-560>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <18000,33920,-560>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <17744,33920,-560>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <17488,33920,-560>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <17232,33920,-560>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <16976,33920,-560>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <16720,33920,-560>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <16464,33920,-560>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <16208,33920,-560>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <15952,33920,-560>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <15696,33920,-560>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <15440,33920,-560>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <15184,33920,-560>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <14928,33920,-560>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <14672,33920,-560>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <14544,33808,-560>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <14544,33552,-560>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <14544,33296,-560>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <14544,33040,-560>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <14544,32784,-560>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <14544,32528,-560>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <14544,32272,-560>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <14544,32016,-560>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <14544,31760,-560>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <14544,31504,-560>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <14544,31248,-560>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <14544,30992,-560>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <14544,30736,-560>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <14544,30480,-560>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <14544,30224,-560>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <14544,29968,-560>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <14544,29712,-560>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <14672,29600,-90>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <14928,29600,-90>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <15184,29600,-90>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <15440,29600,-90>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <15696,29600,-90>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <15952,29600,-90>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <16208,29600,-90>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <16464,29600,-90>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <16720,29600,-90>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <16976,29600,-90>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <17232,29600,-90>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <17488,29600,-90>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <17744,29600,-90>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <18000,29600,-90>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <18256,29600,-90>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <18512,29600,-90>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <18768,29600,-90>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <19024,29600,-90>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <19280,29600,-90>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <19536,29600,-90>, <0,-90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <19648,29712,-90>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <19648,29968,-90>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <19648,30224,-90>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <19648,30480,-90>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <19648,30736,-90>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <19648,31008,-90>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <19648,31264,-90>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <19648,31504,-90>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <19648,31760,-90>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <19648,32016,-90>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <19648,32288,-90>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <19648,32528,-90>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <19648,32784,-90>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <19648,33040,-90>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <19648,33296,-90>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <19648,33552,-90>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <19648,33808,-90>, <0,0,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <19536,33920,-90>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <19280,33920,-90>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <19024,33920,-90>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <18768,33920,-90>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <18512,33920,-90>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <18256,33920,-90>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <18000,33920,-90>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <17744,33920,-90>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <17488,33920,-90>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <17232,33920,-90>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <16976,33920,-90>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <16720,33920,-90>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <16464,33920,-90>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <16208,33920,-90>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <15952,33920,-90>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <15696,33920,-90>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <15440,33920,-90>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <15184,33920,-90>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <14928,33920,-90>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <14672,33920,-90>, <0,90,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <14544,33808,-90>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <14544,33552,-90>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <14544,33296,-90>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <14544,33040,-90>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <14544,32784,-90>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <14544,32528,-90>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <14544,32272,-90>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <14544,32016,-90>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <14544,31760,-90>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <14544,31504,-90>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <14544,31248,-90>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <14544,30992,-90>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <14544,30736,-90>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <14544,30480,-90>, <0,-135,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <14544,30224,-90>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <14544,29968,-90>, <0,135,0>, true, 8000 )
CreateEditorProp( $"mdl/vehicle/dropship/dropship_afterburner.rmdl", <14544,29712,-90>, <0,135,0>, true, 8000 )


}
#endif
