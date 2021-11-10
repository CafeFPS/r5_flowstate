// Open this with a code viewer software

//////////////////////////////////////////////////////
//Flow State DM v2.0 stable
//By Retículo Endoplasmático#5955
//& michae\l/#1125
///////////////////////////////////////////////////////

global function _CustomTDM_Init
global function _RegisterLocation
global function CreateAnimatedLegend
table playersInfo

enum eTDMState
{
	IN_PROGRESS = 0
	NEXT_ROUND_NOW = 1
}







///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
// MODIFY THESE VALUES TO YOUR LIKING. Please read each description.
	struct {

	//1. MUST EDIT
	string Hoster = "" // fill this string with whatever you want your host alias to be. otherwise, script will just grab your R5 username.
	int RoundTime = 1200 // Round time (seconds)!! Now it can be any value!!! "next_round # now" is working. (# is the array index of the desired POI)
	string bubblecolor = "94 0 145" //Find in google "rgb color picker" and take the values, dont put commas.

	//2. ROUND + SERVER SETTINGS
	bool RESET_GLOBAL_KILLS_EACH_ROUND = true //resets the global kill counter at top right of screen each round. for accurate kill leader voicelines
	bool QUICK_LOBBY = true // quick lobby.
	bool SCOREBOARD_ENABLED = false // this setting toggles mid-round scoreboard + time remaining announcements. scoreboard will still display at end of game and through "scoreboard" console command.
	bool LOCK_POI_ENABLED = false // if enabled, map level will never change on round end. specify which index of the map config to use in var "LOCKED_POI"
	int LOCKED_POI = 0 // TTV (streamer) building in Flow State map config
	bool ADMIN_TGIVE_ENABLED = false // enables "admintgive", tgive will be disabled for the users (clients). If false, it will take the value from cmd file
	bool ALL_CHAT_ENABLED = true // enables "say" console command, which allows any player to send global announcements. working on real all chat :(
	float ChatCooldown = 10 // GLOBAL cooldown for public chat (if another player sends a message, ALL players must wait). ALL_CHAT_ENABLED must be true for this feature to work.

	//3. CHARACTER SETTINGS // 0 Bang, 1 Bloodhound, 2 Caustic, 3 Gibby, 4 Lifeline, 5 Mirage, 6 Octane, 7 Pathy, 8 Wraith, 9 Watty, 10 Crypto
	bool FORCE_CHARACTER_ENABLED = true //force all players in the game to be the selected character in var PersonajeEscogido?
	int PersonajeEscogido = 8 //Chosen character. FORCE_CHARACTER must be true for this to apply. select the character number from the given list.

	//4. GAMEPLAY MECHANICS
	bool AUTORELOAD_PRIMARY_ON_KILL = true //auto-reload most recently used gun on kill
	bool AUTORELOAD_SECONDARY_ON_KILL = true //auto-reload the other one
	bool FULLHEAL_ON_KILL = true //restores HP and shields on kill
} userSettings
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////







struct {
	string scriptversion = "v2.0 stable"
    int tdmState = eTDMState.IN_PROGRESS
    int nextMapIndex = 0
	bool mapIndexChanged = true
	array<entity> playerSpawnedProps
	array<ItemFlavor> characters
	float lastTimeChatUsage
	float lastKillTimer
	entity lastKiller
	int SameKillerStoredKills=0
	bool loadoutChanged = false
	bool surfEnded = false
	array<string> whitelistedWeapons
	array<LocationSettings> locationSettings
    LocationSettings& selectedLocation
    entity bubbleBoundary
	entity previousChampion
	entity previousChallenger
	int deathPlayersCounter=0
	int maxPlayers
	int maxTeams
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

bool function IsFFA()
///////////////////////////////////////////////////////
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
///////////////////////////////////////////////////////
{
file.maxPlayers = GetCurrentPlaylistVarInt( "max_players", 1 )
file.maxTeams = GetCurrentPlaylistVarInt( "max_teams", 1 )
float division = float (file.maxPlayers) / float(file.maxTeams)

if(division == 1.0){
return true}
else{return false}
unreachable
}

void function PrecacheCustomMapsProps()
{
if(GetMapName() == "mp_rr_desertlands_64k_x_64k"){

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


void function _CustomTDM_Init()
{

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
	AddClientCommandCallback("pritoall", ClientCommand_GiveWeaponsToEveryone)
	AddClientCommandCallback("sectoall",ClientCommand_GiveWeaponsToEveryone2)
	AddClientCommandCallback("teambal", ClientCommand_RebalanceTeams)
	AddClientCommandCallback("circlenow", ClientCommand_CircleNow)

		if(userSettings.ALL_CHAT_ENABLED){
		AddClientCommandCallback("say", ClientCommand_ClientMsg)
	}

	if ( userSettings.ADMIN_TGIVE_ENABLED ){
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

    thread RunTDM() //Go to Game Loop
    }

void function _RegisterLocation(LocationSettings locationSettings)
{
    file.locationSettings.append(locationSettings)
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
			return NewLocPair(<-6252, -16500, 3296>, <0, 0, 0>)
        case "mp_rr_canyonlands_mu1":
        case "mp_rr_canyonlands_mu1_night":
		    return NewLocPair(<-19026, 3749, 4460>, <0, 2, 0>)
        case "mp_rr_desertlands_64k_x_64k":
        case "mp_rr_desertlands_64k_x_64k_nx":
			//return NewLocPair(<-8846, -30401, 2496>, <0, 60, 0>)
			return NewLocPair(<-25789, 3246, 1798>, <0, 40, 0>)
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
	if(file.selectedLocation.name != "Surf Purgatory"){
			ClearInvincible(player)
		}
    }
	string nextlocation = file.selectedLocation.name
		Message(player,"WELCOME TO TDM/FFA!", "\nHosted by " + getHoster() + "\n\nFlow State DM " + file.scriptversion + " by CaféDeColombiaFPS and empathogenwarlord." + helpMessage(), 15)
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
	try{
	if(file.locationSettings.name == "Surf Purgatory"){
	player.TakeOffhandWeapon(OFFHAND_TACTICAL)
    player.TakeOffhandWeapon(OFFHAND_ULTIMATE)
    TakeAllWeapons( player )
    SetPlayerSettings(player, SURF_SETTINGS)
    MakeInvincible(player)
	player.Code_SetTeam( TEAM_IMC + 1 )
	player.GiveWeapon( "mp_weapon_semipistol", WEAPON_INVENTORY_SLOT_ANY )
	}}catch(e){}
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
	float tripleKillTime = 8.5
	file.deathPlayersCounter++
	file.SameKillerStoredKills++
	if(file.deathPlayersCounter == 1)
	{
	foreach (player in GetPlayerArray())
	{
	thread EmitSoundOnEntityExceptToPlayer( player, player, "diag_ap_aiNotify_diedFirst" )
	}
	}

	if (victim == champion && victim != killeader)
	{
		foreach (player in GetPlayerArray())
	{
	thread EmitSoundOnEntityOnlyToPlayer( player, player, "diag_ap_aiNotify_championEliminated_01" )
	}
	}

	if(Time() - file.lastKillTimer < doubleKillTime && attacker == file.lastKiller && attacker == killeader){
	foreach (player in GetPlayerArray())
	{
	thread EmitSoundOnEntityOnlyToPlayer( player, player, "diag_ap_aiNotify_killLeaderDoubleKill" )
	}
	file.SameKillerStoredKills++
	}

	if(Time() - file.lastKillTimer < tripleKillTime && attacker == file.lastKiller && attacker == killeader && file.SameKillerStoredKills > 2){
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
			if(Spectator_GetReplayIsEnabled() && IsValid(victim) && ShouldSetObserverTarget( attacker ) && file.selectedLocation.name != "Surf Purgatory")
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
			//Heal
			if (userSettings.FULLHEAL_ON_KILL) {
				PlayerRestoreHP(attacker, 100, Equipment_GetDefaultShieldHP())
			}
			//Autoreload on kill without animation //By CaféDeColombiaFPS
            WpnAutoReloadOnKill(attacker)
            }
			} catch (e) {}
        }
		thread victimHandleFunc()
        thread attackerHandleFunc()
        foreach(player in GetPlayerArray()){
        Remote_CallFunction_NonReplay(player, "ServerCallback_TDM_PlayerKilled")
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
        if(Equipment_GetRespawnKitEnabled() && !file.loadoutChanged)
        {
			DecideRespawnPlayer(player, true)
			if(userSettings.FORCE_CHARACTER_ENABLED){
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
				if(userSettings.FORCE_CHARACTER_ENABLED){
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
				if(userSettings.FORCE_CHARACTER_ENABLED){
			CharSelect(player)}
                GiveWeaponsFromStoredArray(player, player.p.storedWeapons)
            }

        }
    }


	if(IsValid( player ) && file.selectedLocation.name == "Surf Purgatory" && file.surfEnded == false|| forceGive)
    {
        if(Equipment_GetRespawnKitEnabled())
        {
				DecideRespawnPlayer(player, true)
				if(userSettings.FORCE_CHARACTER_ENABLED){
				CharSelect(player)}
				player.TakeOffhandWeapon(OFFHAND_TACTICAL)
				player.TakeOffhandWeapon(OFFHAND_ULTIMATE)
				TakeAllWeapons( player )
				player.TakeNormalWeaponByIndexNow( WEAPON_INVENTORY_SLOT_PRIMARY_2 )
				player.TakeOffhandWeapon( OFFHAND_MELEE )
				player.TakeOffhandWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_2 )
				player.GiveWeapon( "mp_weapon_melee_survival", WEAPON_INVENTORY_SLOT_PRIMARY_2, [] )
				player.GiveWeapon( "mp_weapon_semipistol", WEAPON_INVENTORY_SLOT_PRIMARY_0, [] )
				player.GiveOffhandWeapon( "melee_data_knife", OFFHAND_MELEE, [] )
				MakeInvincible(player)
        }
        else
        {
            if(!player.p.storedWeapons.len())
            {
				DecideRespawnPlayer(player, true)
				if(userSettings.FORCE_CHARACTER_ENABLED){
				CharSelect(player)}
				player.TakeOffhandWeapon(OFFHAND_TACTICAL)
				player.TakeOffhandWeapon(OFFHAND_ULTIMATE)
				TakeAllWeapons( player )
				player.TakeNormalWeaponByIndexNow( WEAPON_INVENTORY_SLOT_PRIMARY_2 )
				player.TakeOffhandWeapon( OFFHAND_MELEE )
				player.TakeOffhandWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_2 )
				player.GiveWeapon( "mp_weapon_melee_survival", WEAPON_INVENTORY_SLOT_PRIMARY_2, [] )
				player.GiveWeapon( "mp_weapon_semipistol", WEAPON_INVENTORY_SLOT_PRIMARY_0, [] )
				player.GiveOffhandWeapon( "melee_data_knife", OFFHAND_MELEE, [] )
				MakeInvincible(player)
            }
            else
            {
				DecideRespawnPlayer(player, false)
				if(userSettings.FORCE_CHARACTER_ENABLED){
				CharSelect(player)}
				player.TakeOffhandWeapon(OFFHAND_TACTICAL)
				player.TakeOffhandWeapon(OFFHAND_ULTIMATE)
				TakeAllWeapons( player )
				player.TakeNormalWeaponByIndexNow( WEAPON_INVENTORY_SLOT_PRIMARY_2 )
				player.TakeOffhandWeapon( OFFHAND_MELEE )
				player.TakeOffhandWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_2 )
				player.GiveWeapon( "mp_weapon_melee_survival", WEAPON_INVENTORY_SLOT_PRIMARY_2, [] )
				player.GiveWeapon( "mp_weapon_semipistol", WEAPON_INVENTORY_SLOT_PRIMARY_0, [] )
				player.GiveOffhandWeapon( "melee_data_knife", OFFHAND_MELEE, [] )
				MakeInvincible(player)
            }

        }
    }


	} catch (e) {}
	try {
	if( IsValidPlayer( player ) && IsAlive(player))
        {
	TpPlayerToSpawnPoint(player)


    if(file.selectedLocation.name == "Surf Purgatory"){
	SetPlayerSettings(player, SURF_SETTINGS)
	}
	else {
	SetPlayerSettings(player, TDM_PLAYER_SETTINGS)
	}
    PlayerRestoreHP(player, 100, Equipment_GetDefaultShieldHP())
			if(file.loadoutChanged){
		player.TakeOffhandWeapon(OFFHAND_TACTICAL)
				player.TakeOffhandWeapon(OFFHAND_ULTIMATE)
				array<StoredWeapon> weapons = [
					Equipment_GetRespawnKit_Tactical(),
					Equipment_GetRespawnKit_Ultimate()
				]
				foreach (storedWeapon in weapons)
				{
						player.GiveOffhandWeapon( storedWeapon.name, storedWeapon.inventoryIndex, storedWeapon.mods )
				}

		}
		}
		} catch (e1) {}
	WpnPulloutOnRespawn(player)
	try {
	entity weapon1 = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 )
weapon1.SetWeaponCharm( $"mdl/props/charm/charm_nessy.rmdl", "CHARM")
	entity weapon2 = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_1 )
weapon2.SetWeaponCharm( $"mdl/props/charm/charm_nessy.rmdl", "CHARM")} catch (e2) {}
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

	if (userSettings.AUTORELOAD_PRIMARY_ON_KILL) {
    try {primary.SetWeaponPrimaryClipCount(primary.GetWeaponPrimaryClipCountMax())} catch(e){}
	}

	if (userSettings.AUTORELOAD_SECONDARY_ON_KILL) {
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


void function SummonPlayersInACircle()
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
{
	entity player0 = GetPlayerArray()[0]
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
	//}
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

wait 1
    foreach(player in GetPlayerArray())
	{
		try {
			if(IsValid(player))
			player.SetThirdPersonShoulderModeOn()
			_HandleRespawn(player)
			player.UnforceStand()
			player.UnfreezeControlsOnServer()
			HolsterAndDisableWeapons( player )
			    }
    catch(e){}
    }
wait 5

if(userSettings.QUICK_LOBBY == true){
foreach(player in GetPlayerArray())
    {
        if(IsValidPlayer(player))
        {
		Message(player,"- QUICK LOBBY IS ON -", "", 4, "Wraith_PhaseGate_Travel_1p")
		ScreenFade( player, 0, 0, 0, 255, 4.0, 4.0, FFADE_OUT | FFADE_PURGE )
	}}
if (!file.mapIndexChanged)
    {
			if (userSettings.LOCK_POI_ENABLED) {
				file.nextMapIndex = userSettings.LOCKED_POI % file.locationSettings.len()
			}
			else {
				file.nextMapIndex = (file.nextMapIndex + 1 ) % file.locationSettings.len()
			}

    }
    int choice = file.nextMapIndex
    file.mapIndexChanged = false
    file.selectedLocation = file.locationSettings[choice]

	if(file.selectedLocation.name == "Surf Purgatory"){
	file.surfEnded = false
	DestroyPlayerProps()
    wait 2
    SurfPurgatoryLoad()
	}

	if(file.selectedLocation.name == "Skill trainer By Colombia"){
	DestroyPlayerProps()
    wait 2
    SkillTrainerLoad()
	}

    foreach(player in GetPlayerArray())
    {
	try {
        Remote_CallFunction_NonReplay(player, "ServerCallback_TDM_SetSelectedLocation", choice)
    }
    catch(e){}
	}
wait 4
}

if(userSettings.QUICK_LOBBY == false){
if(GetBestPlayer()==PlayerWithMostDamage())
{
foreach(player in GetPlayerArray())
    {
        if(IsValid(player))
        {
			Message(player,"- CHAMPION AND CHALLENGER -", "\n " + GetBestPlayerName() + " is the champion and challenger: number 1 in kills and damage with " + GetBestPlayerScore() + " kills and " + GetDamageOfPlayerWithMostDamage() + " of damage.  \n \n               Waiting for players...", 13, "diag_ap_aiNotify_introChallengerChampion_01")
			//Rev voice
			//Message(player,"- THIS IS YOUR CHAMPION -", "\n The champion is " + GetBestPlayerName() + " with " + GetBestPlayerScore() + " kills in the previous round.  \n \n The champion also got the most damage: " + GetDamageOfPlayerWithMostDamage() + "\n\n             WAITING FOR PLAYERS...", 8, "diag_ap_nocNotify_introChampion_04_02_3p")
	}}
wait 9
}
else{
foreach(player in GetPlayerArray())
    {
        if(IsValid(player))
        {
			Message(player,"- THIS IS YOUR CHAMPION -", "\n " + GetBestPlayerName() + " with " + GetBestPlayerScore() + " was the player with most kills. \n             Waiting for players...", 8, "diag_ap_ainotify_introchampion_01_02")
			//Rev voice
			//Message(player,"- THIS IS YOUR CHAMPION -", "\n " + GetBestPlayerName() + " with " + GetBestPlayerScore() + " kills in the previous round.  \n\n             WAITING FOR PLAYERS...", 5, "diag_ap_nocNotify_introChampion_04_02_3p")
	}}
wait 5
	foreach(player in GetPlayerArray())
    {
        if(IsValid(player))
        {
			Message(player,"- THIS IS YOUR CHALLENGER -", "\n " + PlayerWithMostDamageName() + " with " + GetDamageOfPlayerWithMostDamage() + " was the player with the most damage. \n \n             WAITING FOR PLAYERS...", 5, "diag_ap_aiNotify_introChallenger_01_02")
}}
wait 5}

if (!file.mapIndexChanged)
    {
			if (userSettings.LOCK_POI_ENABLED) {
				file.nextMapIndex = userSettings.LOCKED_POI % file.locationSettings.len()
			}
			else {
				file.nextMapIndex = (file.nextMapIndex + 1 ) % file.locationSettings.len()
			}
    }
    int choice = file.nextMapIndex
    file.mapIndexChanged = false
    file.selectedLocation = file.locationSettings[choice]

	if(file.selectedLocation.name == "Surf Purgatory"){
	file.surfEnded = false
	DestroyPlayerProps()
    wait 2
    SurfPurgatoryLoad()
	}

	if(file.selectedLocation.name == "Skill trainer By Colombia"){
	DestroyPlayerProps()
    wait 2
    SkillTrainerLoad()
	}

    foreach(player in GetPlayerArray())
    {
	try {
        Remote_CallFunction_NonReplay(player, "ServerCallback_TDM_SetSelectedLocation", choice)
    }
    catch(e1){}
	}
foreach(player in GetPlayerArray())
    {
        if(IsValid(player))
        {
		AddCinematicFlag(player, CE_FLAG_HIDE_MAIN_HUD | CE_FLAG_EXECUTION)
		Message(player,"NEXT LOCATION IS: " + file.selectedLocation.name, "             Previous final scoreboard: \n \n Name:    K  |   D   |   KD   |   Damage dealt \n \n " + ScoreboardFinal() + "\n Kills made by everyone in the previous round: " + file.deathPlayersCounter , 9, "diag_ap_aiNotify_circleMoves10sec")
	 }}
wait 8
foreach(player in GetPlayerArray())
    {
	try {
        if(IsValid(player))
        {
thread EmitSoundOnEntityOnlyToPlayer( player, player, "Wraith_PhaseGate_Travel_1p")
ScreenFade( player, 0, 0, 0, 255, 3.0, 3.0, FFADE_OUT | FFADE_PURGE )
	}}catch(e5){}
	}
wait 4

}
try {
        PlayerTrail(GetBestPlayer(),0)
    } catch(e2){}
SetGameState(eGameState.Playing)
file.tdmState = eTDMState.IN_PROGRESS
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
		if(file.selectedLocation.name != "Surf Purgatory"){
			ClearInvincible(player)
		}
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

try {
if(GetBestPlayer()==PlayerWithMostDamage())
{
	foreach(player in GetPlayerArray())
    {
		string nextlocation = file.selectedLocation.name
		if(file.selectedLocation.name == "Surf Purgatory"){
		Message(player, "WELCOME TO SURF PURGATORY", "Map by Zee#0134", 15, "diag_ap_aiNotify_circleTimerStartNext_02")
		player.Code_SetTeam( TEAM_IMC + 1 )
		} else {
		Message(player, file.selectedLocation.name + ": ROUND START!", "\n           " + GetBestPlayerName() + " is the champion with " + GetBestPlayerScore() + " kills in the previous round. \n         The champion also got the most damage: " + GetDamageOfPlayerWithMostDamage() + helpMessage(), 15, "diag_ap_aiNotify_circleTimerStartNext_02")
		}
		file.previousChampion=GetBestPlayer()
		file.previousChallenger=PlayerWithMostDamage()
		GameRules_SetTeamScore(player.GetTeam(), 0)
		file.deathPlayersCounter = 0
	}
}
else{
	foreach(player in GetPlayerArray())
    {
		string nextlocation = file.selectedLocation.name
		if(file.selectedLocation.name == "Surf Purgatory"){
		Message(player, "WELCOME TO SURF PURGATORY", "Map by Zee#0134", 15, "diag_ap_aiNotify_circleTimerStartNext_02")
		player.Code_SetTeam( TEAM_IMC + 1 )
		} else {
		Message(player, file.selectedLocation.name + ": ROUND START!", "\n           " + GetBestPlayerName() + " is the champion with " + GetBestPlayerScore() + " kills in the previous round. \n      " + PlayerWithMostDamageName() + " is the challenger with " + GetDamageOfPlayerWithMostDamage() + " of damage in the previous round." + helpMessage(), 15, "diag_ap_aiNotify_circleTimerStartNext_02")
		}
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
if (userSettings.RESET_GLOBAL_KILLS_EACH_ROUND && IsValidPlayer(player)) {
	player.SetPlayerNetInt("kills", 0) //Reset for kills in top right counter
}
	}
ResetAllPlayerStats()
file.bubbleBoundary = CreateBubbleBoundary(file.selectedLocation)
WaitFrame()
}

void function SimpleChampionUI(){
//////////////////////////////////////////////////////////////////////////////
/////////////Retículo Endoplasmático#5955 CaféDeColombiaFPS///////////////////
//////////////////////////////////////////////////////////////////////////////
float endTime = Time() + userSettings.RoundTime

if(file.selectedLocation.name == "Surf Purgatory"){
file.bubbleBoundary.Destroy()
}

if (userSettings.SCOREBOARD_ENABLED){
while( Time() <= endTime )
	{
    if(Time() == endTime-900)
	{
			foreach(player in GetPlayerArray())
			{
				if(IsValid(player))
				{
					Message(player,"15 MINUTES REMAINING!","\n Name:    K  |   D   |   KD   |   Damage dealt \n" + Scoreboard(), 5)
				}
			}
		}
		if(Time() == endTime-600)
		{
			foreach(player in GetPlayerArray())
			{
				if(IsValid(player))
				{
					Message(player,"10 MINUTES REMAINING!","\n Name:    K  |   D   |   KD   |   Damage dealt \n" + Scoreboard(), 5)
				}
			}
		}
		if(Time() == endTime-300)
		{
			foreach(player in GetPlayerArray())
			{
				if(IsValid(player))
				{
					Message(player,"5 MINUTES REMAINING!","\n Name:    K  |   D   |   KD   |   Damage dealt \n" + Scoreboard(), 5)
				}
			}
		}
		if(Time() == endTime-120)
		{
			foreach(player in GetPlayerArray())
			{
				if(IsValid(player))
				{
					Message(player,"2 MINUTES REMAINING!","\n Name:    K  |   D   |   KD   |   Damage dealt \n" + Scoreboard(), 5)
				}
			}
		}
		if(Time() == endTime-60)
		{
			foreach(player in GetPlayerArray())
			{
				if(IsValid(player))
				{
					Message(player,"1 MINUTE REMAINING!","\n Name:    K  |   D   |   KD   |   Damage dealt \n" + Scoreboard(), 5, "diag_ap_aiNotify_circleMoves60sec")
				}
			}
		}
		if(Time() == endTime-30)
		{
			foreach(player in GetPlayerArray())
			{
				if(IsValid(player))
				{
					Message(player,"30 SECONDS REMAINING!", "\n Name:    K  |   D   |   KD   |   Damage dealt \n" + Scoreboard(), 5, "diag_ap_aiNotify_circleMoves30sec")
				}
			}
		}
		if(Time() == endTime-10)
		{
			foreach(player in GetPlayerArray())
			{
				if(IsValid(player))
				{
					Message(player,"10 SECONDS REMAINING!", "\n The battle is almost over.", 8, "diag_ap_aiNotify_circleMoves10sec")
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
		Message(player,"- CHAMPION DECIDED! -", "\n " + GetBestPlayerName() + " is the champion: number 1 in kills and damage \n with " + GetBestPlayerScore() + " kills and " + GetDamageOfPlayerWithMostDamage() + " of damage.  \n \n Champion is literally on fire! Weapons disabled! Please tbag.", 10, "UI_InGame_ChampionVictory")
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
		Message(player,"- CHAMPION DECIDED! -", "\n The champion is " + GetBestPlayerName() + " with " + GetBestPlayerScore() + " kills. Champion is literally on fire! \n \n The player with most damage was " + PlayerWithMostDamageName() + " with " + GetDamageOfPlayerWithMostDamage() + " and now is the CHALLENGER! \n\n          Weapons disabled! Please tbag.", 10, "UI_InGame_ChampionVictory")}
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
	 Message(player,"- FINAL SCOREBOARD -", "\n         Name:    K  |   D   |   KD   |   Damage dealt \n \n" + ScoreboardFinal() + "\n Flow State " + file.scriptversion + " by CaféDeColombiaFPS and empathogenwarlord", 12, "UI_Menu_RoundSummary_Results")}
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
	if(file.selectedLocation.name == "Surf Purgatory"){
		file.surfEnded = true
		ClearInvincible(player)
		TakeAllWeapons(player)
		player.TakeDamage(player.GetMaxHealth() + 1, null, null, { damageSourceId=damagedef_suicide, scriptType=DF_BYPASS_SHIELD })
		}
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
    bubbleShield.kv.rendercolor = userSettings.bubblecolor
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
ItemFlavor PersonajeEscogido = file.characters[userSettings.PersonajeEscogido]
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


bool function ClientCommand_SetCharm(entity player, array<string> args)
//by Retículo Endoplasmático#5955
{
// mdl/props/charm/charm_clown.rmdl
// mdl/props/charm/charm_crow.rmdl
// mdl/props/charm/charm_fireball.rmdl
// mdl/props/charm/charm_gas_canister.rmdl
// mdl/props/charm/charm_jester.rmdl
// mdl/props/charm/charm_lifeline_drone.rmdl
// mdl/props/charm/charm_nessy.rmdl
// mdl/props/charm/charm_nessy_ghost.rmdl
// mdl/props/charm/charm_pumpkin.rmdl
// mdl/props/charm/charm_rank_diamond.rmdl
// mdl/props/charm/charm_rank_gold.rmdl
// mdl/props/charm/charm_rank_platinum.rmdl
// mdl/props/charm/charm_rank_predator.rmdl
// mdl/props/charm/charm_witch.rmdl
// mdl/props/charm/charm_yeti.rmdl
//todo: assets array lazy today

try{entity weapon1 = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 )
weapon1.SetWeaponCharm( $"mdl/props/charm/charm_nessy.rmdl", "CHARM")
entity weapon2 = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_1 )
weapon2.SetWeaponCharm( $"mdl/props/charm/charm_nessy.rmdl", "CHARM")}catch(e){}
return true
}

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
	if(!IsServer()) return false;
	string playerName = player.GetPlayerName()
	string str = ""
	foreach (s in args)
		str += " " + s

    string sendMessage = str

    foreach(sPlayer in GetPlayerArray())
    {
Message( sPlayer, "Admin message", playerName + " says: "  + sendMessage, 6)
    }
	return true
}


string function helpMessage()
//by michae\l/#1125
{
	return "\n\n          CONSOLE COMMANDS:\n1. 'kill_self': if you get stuck.\n2. 'scoreboard': displays full scoreboard to user. (Kills, deaths, KD ratio, damage)\n3. 'latency': displays ping of all players to user.\n4. 'say [MESSAGE]': send a public message! (" + userSettings.ChatCooldown.tostring() + "s global cooldown, admin disabled by default.)\n5.'spectate': spectate enemies! (beta) \n6. 'commands': display this message again."
}


bool function ClientCommand_Help(entity player, array<string> args)
//by michae\l/#1125
{
	if(IsValid(player)) {
		try{
		Message(player, "WELCOME TO FLOW STATE!", helpMessage(), 10)
		}catch(e) {}
	}
	return true
}


bool function ClientCommand_ClientMsg(entity player, array<string> args)
//by Retículo Endoplasmático#5955
{
    float cooldown = userSettings.ChatCooldown
	if( Time() - file.lastTimeChatUsage < cooldown )
    {
		return false
	}
	string playerName = player.GetPlayerName()
	string str = ""
	foreach (s in args)
		str += " " + s
    string sendMessage = str

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
	Message( sPlayer, "Trollbox", playerName + " says: "  + sendMessage, 4)
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

bool function ClientCommand_GiveWeaponsToEveryone(entity player, array<string> args)
//by Retículo Endoplasmático#5955
{
if(!IsServer()){
return false
}
entity weapon
if (args.len())
	{
		foreach(sPlayer in GetPlayerArray())
		{
		try{
			sPlayer.TakeNormalWeaponByIndexNow(WEAPON_INVENTORY_SLOT_PRIMARY_0)
			sPlayer.GiveWeapon(args[0], WEAPON_INVENTORY_SLOT_PRIMARY_0)
			weapon = sPlayer.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 )
			weapon.SetMods(args.slice(1, args.len()))
			Remote_CallFunction_Replay( player, "ServerCallback_UpdateHudWeaponData", weapon )
			weapon.SetWeaponPrimaryClipCount(weapon.GetWeaponPrimaryClipCountMax())
			sPlayer.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_0)
			}catch(e1){}
			Message(sPlayer, "PRIMARY WEAPON CHANGED", "", 3)
		}
   }
file.loadoutChanged = true
return true
}

bool function ClientCommand_GiveWeaponsToEveryone2(entity player, array<string> args)
//by Retículo Endoplasmático#5955
{
if(!IsServer()){
return false
}
entity weapon
if (args.len())
	{
		foreach(sPlayer in GetPlayerArray())
		{
		try{
			sPlayer.TakeNormalWeaponByIndexNow(WEAPON_INVENTORY_SLOT_PRIMARY_1)
			sPlayer.GiveWeapon(args[0], WEAPON_INVENTORY_SLOT_PRIMARY_1)
			weapon = sPlayer.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_1 )
			weapon.SetMods(args.slice(1, args.len()))
			Remote_CallFunction_Replay( player, "ServerCallback_UpdateHudWeaponData", weapon )
			weapon.SetWeaponPrimaryClipCount(weapon.GetWeaponPrimaryClipCountMax())
			sPlayer.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_1)
			}catch(e1){}
			Message(sPlayer, "SECONDARY WEAPON CHANGED", "", 3)
		}
   }
file.loadoutChanged = true
return true
}

bool function ClientCommand_GiveWeapon(entity player, array<string> args)
//Modified by Retículo Endoplasmático#5955 and michae\l/#1125
{
    if ( userSettings.ADMIN_TGIVE_ENABLED == true && !IsServer())
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
       if(!IsServer()) {
        if (player == GetPlayerArray()[0]) {
            print("switching round")
        } else {
            print("ERROR: only the host can switch rounds")
            return false;
        }
    }

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
    return true
}

bool function ClientCommand_God(entity player, array<string> args)
///////////////////////////////////////////////////////
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
///////////////////////////////////////////////////////
{
	if(!IsServer()) {
	return false
	}

	if (player == GetPlayerArray()[0]) {
		try{
		player.MakeInvisible()
		MakeInvincible(player)
		HolsterAndDisableWeapons(player)
		}catch(e) {}
	}
	return true
}

bool function ClientCommand_CircleNow(entity player, array<string> args)
///////////////////////////////////////////////////////
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
///////////////////////////////////////////////////////
{
	if(!IsServer()) {
	return false
	}

	if (player == GetPlayerArray()[0]) {
		try{
		SummonPlayersInACircle()
		}catch(e) {}
	}
	return true
}

bool function ClientCommand_UnGod(entity player, array<string> args)
///////////////////////////////////////////////////////
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
///////////////////////////////////////////////////////
{
	if(!IsServer()) {
	return false
	}
	if (player == GetPlayerArray()[0]) {
		try{
		player.MakeVisible()
		ClearInvincible(player)
		DeployAndEnableWeapons(player)
		// player.TakeDamage(player.GetMaxHealth() + 1, null, null, { damageSourceId=damagedef_suicide, scriptType=DF_BYPASS_SHIELD })
		}catch(e) {}
	}
	return true
}

string function getHoster()
{
	if (userSettings.Hoster == "") {return GetPlayerArray()[0].GetPlayerName()}
	return userSettings.Hoster
}

bool function ClientCommand_Scoreboard(entity player, array<string> args)
//by michae\l/#1125
{
	float ping = player.GetLatency() * 1000 - 40
	if(IsValid(player)) {
		try{
		Message(player, "- CURRENT SCOREBOARD - ", "\n Name:    K  |   D   |   KD   |   Damage dealt \n" + ScoreboardFinal(true) + "\n\nYour ping: " + ping.tointeger() + "ms. \n\nHosted by: " + getHoster(), 4)
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
    if (player != GetPlayerArray()[0]) {return false}
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
#endif

#if SERVER
void function SurfRampsHighlight( entity e )
{
	float rampr = RandomFloatRange( 0.0, 1.0 )
       float rampg = RandomFloatRange( 0.0, 1.0 )
       float rampb = RandomFloatRange( 0.0, 1.0 )
    e.Highlight_ShowInside( 1.0 )
	e.Highlight_ShowOutline( 1.0 )
    e.Highlight_SetFunctions( 0, 136, false, 136, 8.0, 2, false )
    e.Highlight_SetParam( 0, 0, <rampr, rampg, rampb> )
}
#endif

#if SERVER
entity function CreateEditorPropRamps(asset a, vector pos, vector ang, bool mantle = false, float fade = 2000)
{
	entity e = CreatePropDynamic(a,pos,ang,SOLID_VPHYSICS,fade)
	e.kv.fadedist = fade
    e.kv.renderamt = 255
	e.kv.rendermode = 3
	e.kv.rendercolor = "255 255 255 255"
        SurfRampsHighlight(e)
	if(mantle) e.AllowMantle()
    file.playerSpawnedProps.append(e)
	return e
}
#endif

void function TeleportFRPlayerSurf(entity player, vector pos, vector ang)
{
    if(IsValid(player))
    {
	    player.SetOrigin(pos)
	    player.SetAngles(ang)
    }
}

void function SurfPurgatoryLoad()
{
    SurfPurgatory()
    thread SurfPurgatoryTriggerSetup()
}

void function SurfPurgatoryTriggerSetup()
{
	entity fall = CreateEntity( "trigger_cylinder" )
	fall.SetRadius( 100000 )
	fall.SetAboveHeight( 25 )
	fall.SetBelowHeight( 25 )
	fall.SetOrigin( <3299,7941,16384> )
	DispatchSpawn( fall )

	fall.SetEnterCallback( SurfPurgatoryTrigger_OnAreaEnter )

    entity finishdoor = CreateEntity( "trigger_cylinder" )
	finishdoor.SetRadius( 20 )
	finishdoor.SetAboveHeight( 25 )
	finishdoor.SetBelowHeight( 25 )
	finishdoor.SetOrigin( <2403, 15865, 17230> )
	DispatchSpawn( finishdoor )

	finishdoor.SetEnterCallback( SurfPurgatoryFinishDoor_OnAreaEnter )

    entity finish = CreateEntity( "trigger_cylinder" )
	finish.SetRadius( 1000 )
	finish.SetAboveHeight( 300 )
	finish.SetBelowHeight( 1 )
    finish.SetAngles( <0, 90, 0> )
	finish.SetOrigin( <2403, 15865, 17230> )
	DispatchSpawn( finish )

	finish.SetEnterCallback( SurfPurgatoryFinishFinished_OnAreaEnter )

    file.playerSpawnedProps.append(fall)
    file.playerSpawnedProps.append(finishdoor)
    file.playerSpawnedProps.append(finish)

	OnThreadEnd(
		function() : ( fall )
		{
			fall.Destroy()
		} )

	WaitForever()
}

void function SurfPurgatoryTrigger_OnAreaEnter( entity trigger, entity player )
{
    TeleportFRPlayerSurf(player,<3225,9084,21476>,<0,-90,0>)
}

void function SurfPurgatoryFinishDoor_OnAreaEnter( entity trigger, entity player )
{
    TeleportFRPlayerSurf(player,<3225,9084,21476>,<0,-90,0>)
}

void function SurfPurgatoryFinishFinished_OnAreaEnter( entity trigger, entity player )
{
    Message( player, "Map Finished", "Congrats you finished surf_purgatory", 5.0 )
}

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


#if SERVER
void function SurfPurgatory()
{
    // CreateCustomLight( <3791, 8737,21562>, <0,0,0>, "255 255 0", 1 )
    // CreateCustomLight( <2678, 8737,21562>, <0,0,0>, "255 255 0", 1 )
    // CreateCustomLight( <3214, 5599, 21061>, <0,0,0>, "255 255 0", 1 )
    // CreateCustomLight( <1844, 5176, 21077>, <0,0,0>, "255 255 0", 1 )
    // CreateCustomLight( <4560, 5176, 21077>, <0,0,0>, "255 255 0", 1 )
    // CreateCustomLight( <2524, 9470, 21084>, <0,0,0>, "255 255 0", 1 )
    // CreateCustomLight( <3820, 9470, 21084>, <0,0,0>, "255 255 0", 1 )
    // CreateCustomLight( <5644, 11773, 20764>, <0,0,0>, "255 255 0", 1 )
    // CreateCustomLight( <5481, 9081, 19361>, <0,0,0>, "255 255 0", 1 )
    // CreateCustomLight( <2558, 9480, 19307>, <0,0,0>, "255 255 0", 1 )
    // CreateCustomLight( <-441, 9340, 18819>, <0,0,0>, "255 255 0", 1 )
    // CreateCustomLight( <1712, 10112, 18776>, <0,0,0>, "255 255 0", 1 )
    // CreateCustomLight( <-1782, 10750, 18744>, <0,0,0>, "255 255 0", 1 )
    // CreateCustomLight( <-2337, 7680, 18771>, <0,0,0>, "255 255 0", 1 )
    // CreateCustomLight( <-2309, 9954, 18772>, <0,0,0>, "255 255 0", 1 )
    // CreateCustomLight( <1937, 19559, 18279>, <0,0,0>, "255 0 0", 1 )
    // CreateCustomLight( <2183, 19559, 18279>, <0,0,0>, "0 255 0", 1 )
    // CreateCustomLight( <2437, 19559, 18279>, <0,0,0>, "255 0 255", 1 )
    // CreateCustomLight( <2700, 19559, 18279>, <0,0,0>, "255 255 0", 1 )
    // CreateCustomLight( <2956, 19559, 18279>, <0,0,0>, "255 0 255", 1 )
    // CreateCustomLight( <2429, 20521, 17672>, <0,0,0>, "255 255 255", 1 )

   // Written by mostly fireproof. Let me know if there are any issues!
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2688,8832,21120>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2944,8832,21120>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3200,8832,21120>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3456,8832,21120>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3712,8832,21120>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3712,9088,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3456,9088,21120>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3200,9088,21120>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2944,9088,21120>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2688,9088,21120>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,8832,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,9088,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3712,9216,21120>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3456,9216,21120>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3200,9216,21120>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,9216,21120>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,9216,21120>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,9088,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,8832,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,8832,21376>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,9088,21376>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,9216,21376>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,9216,21376>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3200,9216,21376>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3456,9216,21376>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3712,9216,21376>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,9088,21376>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,8832,21376>, <0,90,0>, false, 8000 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3712,8832,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3712,9088,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3456,9088,21632>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3200,9088,21632>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2944,9088,21632>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2688,9088,21632>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2688,8832,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2944,8832,21632>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3200,8832,21632>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3456,8832,21632>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,9088,21376>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3328,9088,21376>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3200,8960,21376>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,8576,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,8576,21376>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,8320,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,8320,21376>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,8064,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,8064,21376>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,7808,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,7808,21376>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,7552,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,7552,21376>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,7296,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,7296,21376>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,7040,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,7040,21376>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,6784,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,6784,21376>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,6528,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,6528,21376>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,8576,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,8320,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,8064,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,7808,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,7552,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,7296,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,7040,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,6784,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,6528,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,6272,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,6016,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,6272,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,6016,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,6016,21376>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,6272,21376>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,6016,21376>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,6272,21376>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,6528,21376>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,6784,21376>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,7040,21376>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,7296,21376>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,7552,21376>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,7808,21376>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,8064,21376>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,8320,21376>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,8576,21376>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,8704,20864>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,8704,20864>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3200,8704,20864>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3456,8704,20864>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3712,8704,20864>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3712,8704,20608>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3456,8704,20608>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3200,8704,20608>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,8704,20608>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,8704,20608>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,8704,20352>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,8704,20352>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3200,8704,20352>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3456,8704,20352>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3712,8704,20352>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3712,8704,20096>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3456,8704,20096>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3200,8704,20096>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,8704,20096>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,8704,20096>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,8704,19840>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,8704,19840>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3200,8704,19840>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3456,8704,19840>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3712,8704,19840>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,8576,19840>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,8320,19840>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,8064,19840>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,7808,19840>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,7552,19840>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,7296,19840>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,7040,19840>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,6784,19840>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,6528,19840>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,6272,19840>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,6016,19840>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,5760,19840>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,5760,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,5760,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,5760,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,5760,20864>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,5760,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,5760,21376>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,8576,19840>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,8320,19840>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,8064,19840>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,7808,19840>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,7552,19840>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,7296,19840>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,7040,19840>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,6784,19840>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,6528,19840>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,6272,19840>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,6016,19840>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,5760,19840>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,5760,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,5760,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,5760,20608>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,5760,20864>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,5760,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,5760,21376>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,6016,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,6272,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,6528,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,6784,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,7040,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,7296,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,7552,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,7808,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,8064,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,8320,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,8576,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,8576,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,8320,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,8064,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,7808,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,7552,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,7296,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,7040,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,6784,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,6528,20352>, <0,-90,0>, false, 8000 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,6272,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,6016,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,6016,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,6272,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,6528,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,6784,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,7040,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,7296,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,7552,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,7808,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,8064,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,8320,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,8576,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,8576,20864>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,8320,20864>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,8064,20864>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,7808,20864>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,7552,20864>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,7296,20864>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,7040,20864>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,6784,20864>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,6528,20864>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,6272,20864>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,6016,20864>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,8576,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,8256,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,8320,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,8064,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,7808,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,7552,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,7296,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,7040,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,6784,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,6528,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,6272,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,6016,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,6016,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,6272,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,6528,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,6784,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,7040,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,7232,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,7296,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,7552,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,7808,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,8064,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,8320,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,8576,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,8576,20608>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,8320,20608>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,8064,20608>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,7808,20608>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,7552,20608>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,7296,20608>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,7040,20608>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,6784,20608>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,6528,20608>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,6272,20608>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,6016,20608>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,6016,20864>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,6272,20864>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,6528,20864>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,6784,20864>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,7104,20864>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,6976,20864>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,7296,20864>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,7552,20864>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,7808,20864>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,8064,20864>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,8320,20864>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,8576,20864>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2688,8576,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2688,8320,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2688,8064,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2688,7744,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2688,7808,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2688,7488,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2688,7232,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2688,6976,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2688,6720,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2688,6464,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2688,6208,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2688,5952,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2688,5760,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2944,8576,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2944,8320,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2944,8064,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2944,7808,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2944,7744,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2944,7488,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2944,7232,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2944,6976,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2944,6720,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2944,6464,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2944,6208,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2944,5952,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2944,5760,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3200,5760,21632>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3456,5760,21632>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3712,5760,21632>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3200,8576,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3456,8576,21632>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3712,8576,21632>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3712,8320,21632>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3456,8320,21632>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3200,8320,21632>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3200,8064,21632>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3456,8064,21632>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3712,8064,21632>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3712,7808,21632>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3456,7808,21632>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3200,7808,21632>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3200,7744,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3456,7744,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3712,7744,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3200,7488,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3200,7232,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3200,6976,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3200,6720,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3200,6464,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3200,6208,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3200,5952,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3520,7488,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3456,7488,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3456,7232,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3456,6976,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3456,6720,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3456,6464,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3456,6208,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3456,5952,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3712,7488,21632>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3712,7232,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3712,6976,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3712,6784,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3712,6720,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3712,6464,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3712,6208,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3712,5952,21632>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,8832,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,9088,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,9216,20352>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,9216,20352>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3200,9216,20352>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3456,9216,20352>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3712,9216,20352>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,9088,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,8832,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,8832,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,8832,20864>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,8832,20608>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,8832,20864>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,9088,20608>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,9088,20864>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,8832,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,9088,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,8832,19840>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,9088,19840>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,9216,20096>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,9216,20096>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3200,9216,20096>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3456,9216,20096>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3712,9216,20096>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3712,9216,19840>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3456,9216,19840>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3200,9216,19840>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,9216,19840>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,9216,19840>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,9216,20608>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,9216,20608>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3200,9216,20608>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3456,9216,20608>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3712,9216,20608>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,9088,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,9088,20864>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3712,9216,20864>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3456,9216,20864>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3200,9216,20864>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,9216,20864>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,9216,20864>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,9344,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,9600,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,9728,20352>, <0,0,0>, false, 8000 )



    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3712,9728,20352>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,9600,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,9344,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,9088,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,8832,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,8832,19840>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,9088,19840>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,9344,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,9600,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,9728,21120>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,9728,21120>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3200,9728,21120>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3456,9728,21120>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3712,9728,21120>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,9600,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,9344,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3712,9728,20608>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3712,9728,20864>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,9728,20864>, <0,0,0>, false, 8000 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,9728,20608>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,9344,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,9600,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,9344,19840>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,9600,19840>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,9728,19840>, <0,0,0>, false, 8000 )



    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3712,9728,19840>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,9600,19840>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,9344,19840>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,9344,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,9600,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3712,9728,20096>, <0,0,0>, false, 8000 )



    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,9728,20096>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,9344,21376>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,9600,21376>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3712,9728,21376>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3456,9728,21376>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3200,9728,21376>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,9728,21376>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,9728,21376>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,9600,21376>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,9344,21376>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2688,9344,21632>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2944,9344,21632>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3200,9344,21632>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3456,9344,21632>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3712,9344,21632>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3712,9600,21632>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3456,9600,21632>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3200,9600,21632>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2944,9600,21632>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2688,9600,21632>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,9856,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,9856,20864>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3584,9856,20608>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3584,9856,20864>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3456,9856,21120>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3200,9856,21120>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2944,9856,21120>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,10112,20608>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,10368,20608>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,10624,20608>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,10624,20864>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,10368,20864>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,10112,20864>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,9856,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,10112,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,10368,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,10624,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3584,9856,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3584,10112,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3584,10368,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3584,10624,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3584,10624,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3584,10368,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3584,10112,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3584,10112,20864>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3584,10368,20864>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3584,10624,20864>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3456,10112,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3200,10112,21120>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2944,10112,21120>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3456,10368,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3456,10624,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3200,10368,21120>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2944,10368,21120>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2944,10624,21120>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3200,10624,21120>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,5632,21376>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,5632,21376>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3200,5632,21376>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3456,5632,21376>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3712,5632,21376>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3712,5632,21120>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3456,5632,21120>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3200,5632,21120>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,5632,21120>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,5632,21120>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2432,5632,20864>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2176,5632,20864>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1920,5632,20864>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,5760,20864>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,6016,20864>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,6272,20864>, <0,90,0>, false, 8000 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,6528,20864>, <0,90,0>, false, 8000 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,6784,20864>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,7040,20864>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,7296,20864>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,7552,20864>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,7808,20864>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,8064,20864>, <0,90,0>, false, 8000 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,8320,20864>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,8576,20864>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,8832,20864>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,9088,20864>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,9344,20864>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,9600,20864>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2432,9728,20864>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2176,9728,20864>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1920,9728,20864>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2432,9600,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2432,9344,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2432,9088,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2432,8832,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2432,8576,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2432,8320,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2432,8064,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2432,7808,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2432,7552,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2432,7296,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2432,7040,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2432,6784,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2432,6528,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2432,6272,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2432,6016,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2432,5760,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2176,5760,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2176,6016,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2176,6272,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2176,6528,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2176,6784,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2176,7040,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2176,7296,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2176,7552,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2176,7808,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2176,8064,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2176,8320,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2176,8576,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2176,8832,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2176,9088,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2176,9344,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2176,9600,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1920,9600,21120>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1920,9344,21120>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1920,9088,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1920,8832,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1920,8576,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1920,8320,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1920,8064,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1920,7808,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1920,7552,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1920,7296,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1920,7040,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1920,6784,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1920,6528,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1920,6272,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1920,6016,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1920,5760,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,5760,20608>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,5760,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,5760,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,5760,19840>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,6016,19840>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,6272,19840>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,6528,19840>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,6784,19840>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,7040,19840>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,7296,19840>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,7552,19840>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,7808,19840>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,8064,19840>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,8320,19840>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,8576,19840>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,8832,19840>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,9088,19840>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,9344,19840>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,9600,19840>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1920,9728,19840>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2176,9728,19840>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2432,9728,19840>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2432,9728,20096>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2176,9728,20096>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1920,9728,20096>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1920,9728,20352>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2176,9728,20352>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2432,9728,20352>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2432,9728,20608>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2176,9728,20608>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1920,9728,20608>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,9600,20608>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,9344,20608>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,9088,20608>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,8832,20608>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,8576,20608>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,8320,20608>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,8064,20608>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,7808,20608>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,7552,20608>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,7296,20608>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,7040,20608>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,6784,20608>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,6528,20608>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,6272,20608>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,6016,20608>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,6016,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,6272,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,6528,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,6784,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,7040,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,7296,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,7552,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,7808,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,8064,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,8320,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,8576,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,8832,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,9088,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,9344,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,9600,20352>, <0,90,0>, false, 8000 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,6016,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,6272,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,6528,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,6784,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,7040,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,7296,20096>, <0,90,0>, false, 8000 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,7552,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,7808,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,8064,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,8320,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,8576,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,8832,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,9088,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,9344,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,9600,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,5504,19840>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,5248,19840>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1920,5120,19840>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2176,5120,19840>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2432,5120,19840>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,5120,19840>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,5120,19840>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3200,5120,19840>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3456,5120,19840>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3712,5120,19840>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3968,5120,19840>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4224,5120,19840>, <0,180,0>, false, 8000 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4480,5120,19840>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,5504,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,5504,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,5504,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,5248,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1920,5120,20096>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2176,5120,20096>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2432,5120,20096>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,5120,20096>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,5120,20096>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3200,5120,20096>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3456,5120,20096>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3712,5120,20096>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3968,5120,20096>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4224,5120,20096>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4480,5120,20096>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4480,5120,20352>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4480,5120,20608>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4480,5120,20864>, <0,180,0>, false, 8000 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4224,5120,20864>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3968,5120,20864>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3712,5120,20864>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3456,5120,20864>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3200,5120,20864>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,5120,20864>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,5120,20864>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2432,5120,20864>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2176,5120,20864>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1920,5120,20864>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,5504,20864>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,5248,20864>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,5248,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,5248,20608>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1920,5120,20352>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2176,5120,20352>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2432,5120,20352>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,5120,20352>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,5120,20352>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3200,5120,20352>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3456,5120,20352>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3712,5120,20352>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3968,5120,20352>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4224,5120,20352>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4224,5120,20608>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3968,5120,20608>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3712,5120,20608>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3456,5120,20608>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3200,5120,20608>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,5120,20608>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,5120,20608>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2432,5120,20608>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2176,5120,20608>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1920,5120,20608>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2432,5504,21120>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2176,5504,21120>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1920,5504,21120>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1920,5248,21120>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2176,5248,21120>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2432,5248,21120>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2688,5504,21120>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2688,5248,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2944,5248,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3200,5248,21120>, <0,-90,0>, false, 8000 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2944,5504,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3200,5504,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3456,5248,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3456,5504,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3712,5504,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3712,5248,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3968,5504,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4224,5504,21120>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4480,5504,21120>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4480,5248,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4224,5248,21120>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3968,5248,21120>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,5248,20864>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,5504,20864>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,5248,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,5504,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,5248,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,5504,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,5248,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,5504,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,5248,19840>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,5504,19840>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,5760,19840>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,6016,19840>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,6272,19840>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,6528,19840>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,6784,19840>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,7040,19840>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,7296,19840>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,7552,19840>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,7808,19840>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,8064,19840>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,8320,19840>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,8576,19840>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,8832,19840>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,9088,19840>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,9344,19840>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,9600,19840>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,9600,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,9600,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,9600,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,9600,20864>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,9344,20864>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4480,9728,19840>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4224,9728,19840>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3968,9728,19840>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3968,9728,20096>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4224,9728,20096>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4480,9728,20096>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4480,9728,20352>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4224,9728,20352>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3968,9728,20352>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3968,9728,20608>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4224,9728,20608>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4480,9728,20608>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4480,9728,20864>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4224,9728,20864>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3968,9728,20864>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,9088,20864>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,8832,20864>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,8576,20864>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,8320,20864>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,8064,20864>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,7808,20864>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,7552,20864>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,7296,20864>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,7040,20864>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,6784,20864>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,6528,20864>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,6272,20864>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,6016,20864>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,5760,20864>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,5760,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,6016,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,6272,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,6528,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,6784,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,7040,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,7296,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,7552,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,7808,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,8064,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,8320,20096>, <0,-90,0>, false, 8000 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,8832,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,9088,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,9344,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,9344,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,9088,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,8832,20352>, <0,-90,0>, false, 8000 )


    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,8576,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,8320,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,8064,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,7808,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,7552,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,7296,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,7040,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,6784,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,6528,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,6272,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,6016,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,5760,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,5760,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,6016,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,6272,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,6528,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,6784,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,7040,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,7296,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,7552,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,7808,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,8064,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,8320,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,8576,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,8832,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,9088,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,9344,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4480,5760,21120>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4224,5760,21120>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3968,5760,21120>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3968,6016,21120>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4224,6016,21120>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4480,6016,21120>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4480,6272,21120>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4224,6272,21120>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3968,6272,21120>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3968,6528,21120>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3968,6784,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3968,7040,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3968,7296,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3968,7552,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3968,7808,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3968,8064,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3968,8320,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3968,8576,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3968,8832,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3968,9088,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3968,9344,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3968,9600,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4224,9600,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4224,9344,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4224,9088,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4224,8832,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4224,8576,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4224,8320,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4224,8064,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4224,7808,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4224,7552,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4224,7296,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4224,7040,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4224,6784,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4224,6528,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4480,6528,21120>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4480,6784,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4480,7040,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4480,7296,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4480,7552,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4480,7808,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4480,8064,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4480,8320,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4480,8576,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4480,8832,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4480,9088,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4480,9344,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4480,9600,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,10880,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,11136,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,11392,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,11520,20352>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3200,11520,20352>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3456,11520,20352>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3584,11392,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3584,11136,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3584,10880,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3584,10880,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3584,11136,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3584,11392,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3584,11392,20864>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3584,11136,20864>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3584,10880,20864>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,10880,20608>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,11136,20608>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,11392,20608>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,11392,20864>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,11136,20864>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,10880,20864>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3456,10880,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3456,11136,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3456,11392,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3200,11392,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3200,11136,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3200,10880,21120>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2944,10880,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2944,11136,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2944,11392,21120>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3456,11520,20864>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3200,11520,20864>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,11520,20864>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,11648,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,11904,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,12032,20352>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3200,12032,20352>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3456,12032,20352>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3712,12032,20352>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3968,12032,20352>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4224,12032,20352>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4480,12032,20352>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3712,12032,20096>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3968,12032,20096>, <0,180,0>, false, 8000 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4224,12032,20096>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4480,12032,20096>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3456,12032,20096>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3200,12032,20096>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,12032,20096>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,11904,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,11648,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,11520,20096>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3200,11520,20096>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3456,11520,20096>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3712,11520,20096>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3968,11520,20096>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4224,11520,20096>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3712,11520,20352>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3968,11520,20352>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4224,11520,20352>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4224,11520,20608>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3968,11520,20608>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3712,11520,20608>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,11648,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,11904,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,12032,20608>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3200,12032,20608>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3456,12032,20608>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3712,12032,20608>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3968,12032,20608>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4224,12032,20608>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4480,12032,20608>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4480,11520,20096>, <0,0,0>, false, 8000 )


    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4480,11520,20352>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4480,11520,20608>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4736,11520,20096>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4992,11520,20096>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5248,11520,20096>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5248,11520,20352>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4992,11520,20352>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4736,11520,20352>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4736,11520,20608>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4992,11520,20608>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5248,11520,20608>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4736,12032,20096>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4992,12032,20096>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5248,12032,20096>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5248,12032,20352>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4992,12032,20352>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4736,12032,20352>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4736,12032,20608>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4992,12032,20608>, <0,180,0>, false, 8000 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5248,12032,20608>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5504,12032,20096>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5760,12032,20096>, <0,0,0>, false, 8000 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5888,11904,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5888,11648,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5888,11392,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5888,11136,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5888,10880,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5888,10624,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5888,10368,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5888,10112,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5376,11392,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5376,11136,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5376,10880,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5376,10624,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5376,10368,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5376,10112,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5504,12032,20352>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5760,12032,20352>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5760,12032,20608>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5504,12032,20608>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5888,11904,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5888,11648,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5888,11392,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5888,11136,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5888,10880,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5888,10624,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5888,10368,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5888,10112,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5376,10112,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5376,10368,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5376,10624,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5376,10880,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5376,11136,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5376,11392,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5888,11904,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5888,11648,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5888,11392,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5888,11136,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5888,10880,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5888,10624,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5888,10368,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5888,10112,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5376,10112,20608>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5376,10368,20608>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5376,10624,20608>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5376,10880,20608>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5376,11136,20608>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5376,11392,20608>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2944,11648,20864>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3200,11648,20864>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3456,11648,20864>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3712,11648,20864>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3968,11648,20864>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4224,11648,20864>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4480,11648,20864>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4736,11648,20864>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4992,11648,20864>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <5248,11648,20864>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <5504,11648,20864>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <5760,11648,20864>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <5760,11904,20864>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <5504,11904,20864>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <5248,11904,20864>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4992,11904,20864>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4736,11904,20864>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4480,11904,20864>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4224,11904,20864>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3968,11904,20864>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3712,11904,20864>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3456,11904,20864>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3200,11904,20864>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2944,11904,20864>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <5760,11392,20864>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <5760,11136,20864>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <5760,10880,20864>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <5760,10624,20864>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <5760,10368,20864>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <5760,10112,20864>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <5504,10112,20864>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <5504,10368,20864>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <5504,10624,20864>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <5504,10880,20864>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <5504,11136,20864>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <5504,11392,20864>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5376,9856,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5376,9600,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5504,9472,20096>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5760,9472,20096>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5888,9600,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5888,9856,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5888,9856,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5888,9600,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5376,9600,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5376,9856,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5888,9856,20608>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5888,9600,20608>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5376,9600,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5376,9856,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5504,9472,20608>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5760,9472,20608>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5376,9344,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5376,9344,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5376,9344,19840>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5376,9088,19840>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5376,9088,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5376,9088,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5376,8832,19840>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5376,8832,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5376,8832,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5504,8704,19840>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5760,8704,19840>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5504,8704,20096>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5760,8704,20096>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5760,8704,20352>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5504,8704,20352>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6016,9472,20352>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6016,9472,20096>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5504,9472,19840>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5760,9472,19840>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6016,9472,19840>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6016,8704,19840>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6016,8704,20096>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6016,8704,20352>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6144,8832,20352>, <0,90,0>, false, 8000 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6144,9344,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5376,9344,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5376,9088,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5376,8832,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5504,8704,20608>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5760,8704,20608>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6016,8704,20608>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6144,8832,20608>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6144,9088,20608>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6144,9344,20608>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6016,9472,20608>, <0,180,0>, false, 8000 )


    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <5504,9856,20864>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <5504,9600,20864>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <5504,9344,20864>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <5504,9088,20864>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <5504,8832,20864>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <5760,8832,20864>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <5760,9088,20864>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <5760,9344,20864>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <6016,9344,20864>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <6016,9088,20864>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <6016,8832,20864>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <5760,9600,20864>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <5760,9856,20864>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6016,9472,19584>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6016,9472,19328>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6016,9472,19072>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6016,9472,18816>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5760,9472,18816>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5504,9472,18816>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5504,9472,19072>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5504,9472,19328>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5504,9472,19584>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5760,9472,19584>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5760,9472,19328>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5760,9472,19072>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6016,8704,19584>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5760,8704,19584>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5504,8704,19584>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5504,8704,19328>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5760,8704,19328>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6016,8704,19328>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6016,8704,19072>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5760,8704,19072>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5504,8704,19072>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5504,8704,18816>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5760,8704,18816>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6016,8704,18816>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6144,9600,18816>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6144,9856,18816>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6272,9984,18816>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6528,9984,18816>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6784,9984,18816>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7040,9984,18816>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7296,9984,18816>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7552,9984,18816>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7808,9984,18816>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8064,9984,18816>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8320,9984,18816>, <0,180,0>, false, 8000 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8576,9984,18816>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8832,9984,18816>, <0,180,0>, false, 8000 )


    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8960,9856,18816>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8960,9600,18816>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8960,9344,18816>, <0,90,0>, false, 8000 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8960,8832,18816>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8960,8576,18816>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8960,8320,18816>, <0,90,0>, false, 8000 )


    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6144,8576,18816>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6144,8320,18816>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6272,8192,18816>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6528,8192,18816>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6784,8192,18816>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7040,8192,18816>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7296,8192,18816>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7552,8192,18816>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7808,8192,18816>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8064,8192,18816>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8320,8192,18816>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8576,8192,18816>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8832,8192,18816>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6144,9600,19072>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6144,9856,19072>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6144,9856,19328>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6144,9600,19328>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6144,9600,19584>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6144,9856,19584>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6144,9856,19840>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6144,9600,19840>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6144,9600,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6144,9856,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6144,9600,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6144,9856,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6144,8576,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6144,8320,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6144,8576,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6144,8320,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6144,8576,19840>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6144,8320,19840>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6144,8576,19584>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6144,8320,19584>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6144,8576,19328>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6144,8320,19328>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6144,8320,19072>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6144,8576,19072>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6272,8192,19072>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6528,8192,19072>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6784,8192,19072>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7040,8192,19072>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7296,8192,19072>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7552,8192,19072>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7808,8192,19072>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8064,8192,19072>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8320,8192,19072>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8576,8192,19072>, <0,0,0>, false, 8000 )


    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8832,8192,19072>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8832,8192,19328>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8832,8192,19584>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8832,8192,19840>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8832,8192,20096>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6272,8192,20352>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6528,8192,20352>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6784,8192,20352>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7040,8192,20352>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7296,8192,20352>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7552,8192,20352>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7808,8192,20352>, <0,0,0>, false, 8000 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8064,8192,20352>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8320,8192,20352>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8576,8192,20352>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8832,8192,20352>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8576,8192,20096>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8320,8192,20096>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8064,8192,20096>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7808,8192,20096>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7552,8192,20096>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7296,8192,20096>, <0,0,0>, false, 8000 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7040,8192,20096>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6784,8192,20096>, <0,0,0>, false, 8000 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6528,8192,20096>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6272,8192,20096>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6272,8192,19840>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6528,8192,19840>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6784,8192,19840>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7040,8192,19840>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7296,8192,19840>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7552,8192,19840>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7808,8192,19840>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8064,8192,19840>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8320,8192,19840>, <0,0,0>, false, 8000 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8576,8192,19840>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8576,8192,19584>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8320,8192,19584>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8064,8192,19584>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7808,8192,19584>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7552,8192,19584>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7296,8192,19584>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7040,8192,19584>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6784,8192,19584>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6528,8192,19584>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6272,8192,19584>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6272,8192,19328>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6528,8192,19328>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6784,8192,19328>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7040,8192,19328>, <0,0,0>, false, 8000 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7296,8192,19328>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7552,8192,19328>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7808,8192,19328>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8064,8192,19328>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8320,8192,19328>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8576,8192,19328>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6272,9984,19072>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6528,9984,19072>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6784,9984,19072>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7040,9984,19072>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7296,9984,19072>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7552,9984,19072>, <0,180,0>, false, 8000 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7808,9984,19072>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8064,9984,19072>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8320,9984,19072>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8576,9984,19072>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8832,9984,19072>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8832,9984,19328>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8832,9984,19584>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8832,9984,19840>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8832,9984,20096>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6272,9984,20352>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6528,9984,20352>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6784,9984,20352>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7040,9984,20352>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7296,9984,20352>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7552,9984,20352>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7808,9984,20352>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8064,9984,20352>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8320,9984,20352>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8576,9984,20352>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8832,9984,20352>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8576,9984,19328>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8320,9984,19328>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8064,9984,19328>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7808,9984,19328>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7552,9984,19328>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7296,9984,19328>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7040,9984,19328>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6784,9984,19328>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6528,9984,19328>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6272,9984,19328>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6272,9984,19584>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6528,9984,19584>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6784,9984,19584>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7040,9984,19584>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7296,9984,19584>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7552,9984,19584>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7808,9984,19584>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8064,9984,19584>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8320,9984,19584>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8576,9984,19584>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8576,9984,19840>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8576,9984,20096>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8320,9984,20096>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8064,9984,20096>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7808,9984,20096>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7552,9984,20096>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7296,9984,20096>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7040,9984,20096>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6784,9984,20096>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6528,9984,20096>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6272,9984,20096>, <0,180,0>, false, 8000 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6272,9984,19840>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6528,9984,19840>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6784,9984,19840>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7040,9984,19840>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7296,9984,19840>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7552,9984,19840>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7808,9984,19840>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8064,9984,19840>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8320,9984,19840>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8960,8320,19072>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8960,8320,19328>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8960,8320,19584>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8960,8320,19840>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8960,8320,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8960,8320,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8960,8576,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8960,8832,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8960,9088,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8960,9344,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8960,9600,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8960,9856,20352>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8960,9856,19072>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8960,9600,19072>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8960,9344,19072>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8960,9088,19072>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8960,8832,19072>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8960,8576,19072>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8960,8576,19328>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8960,8832,19328>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8960,9088,19328>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8960,9344,19328>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8960,9600,19328>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8960,9856,19328>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8960,9856,19584>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8960,9600,19584>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8960,9344,19584>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8960,9088,19584>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8960,8832,19584>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8960,8576,19584>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8960,8576,19840>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8960,8832,19840>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8960,9088,19840>, <0,90,0>, false, 8000 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8960,9344,19840>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8960,9600,19840>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8960,9856,19840>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8960,9856,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8960,9600,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8960,9344,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8960,9088,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8960,8832,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8960,8576,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <6272,8320,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <6272,8576,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <6272,8832,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <6272,9088,20608>, <0,-90,0>, false, 8000 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <6272,9344,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <6272,9600,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <6272,9856,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <6528,9856,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <6528,9600,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <6528,9344,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <6528,9088,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <6528,8832,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <6528,8576,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <6528,8320,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <6784,8320,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <6784,8576,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <6784,8832,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <6784,9088,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <6784,9344,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <6784,9600,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <6784,9856,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <7040,9856,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <7040,9600,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <7040,9344,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <7040,9088,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <7040,8832,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <7040,8576,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <7040,8320,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <7296,8320,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <7296,8576,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <7296,8832,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <7296,9088,20608>, <0,-90,0>, false, 8000 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <7296,9344,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <7296,9600,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <7296,9856,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <7552,9856,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <7552,9600,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <7552,9344,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <7552,9088,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <7552,8832,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <7552,8576,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <7552,8320,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <7808,8320,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <7808,8576,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <7808,8832,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <7808,9088,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <7808,9344,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <7808,9600,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <7808,9856,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <8064,9856,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <8064,9600,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <8064,9344,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <8064,9088,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <8064,8832,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <8064,8576,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <8064,8320,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <8320,8320,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <8320,8576,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <8320,8832,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <8320,9088,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <8320,9344,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <8320,9600,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <8320,9856,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <8576,9856,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <8576,9600,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <8576,9344,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <8576,9088,20608>, <0,-90,0>, false, 8000 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <8576,8832,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <8576,8576,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <8576,8320,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <8832,8320,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <8832,8576,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <8832,8832,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <8832,9088,20608>, <0,-90,0>, false, 8000 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <8832,9344,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <8832,9600,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <8832,9856,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5376,8832,19584>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5376,9088,19584>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5376,9344,19584>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5376,9344,19328>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5376,9088,19328>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5376,8832,19328>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3712,9088,19840>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3712,8832,19840>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3456,9088,19840>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3200,9088,19840>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2944,9088,19840>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2688,9088,19840>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2688,8832,19840>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2944,8832,19840>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3200,8832,19840>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3456,8832,19840>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <5248,8832,19328>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4992,8832,19328>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4736,8832,19328>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <5248,9088,19328>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <5248,9344,19328>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4992,9344,19328>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4992,9088,19328>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4736,9344,19328>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4736,9088,19328>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,8832,19584>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,8832,19328>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,9088,19328>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,9344,19328>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4736,8704,19328>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4992,8704,19328>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5248,8704,19328>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5248,8704,19584>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4992,8704,19584>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4736,8704,19584>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,8576,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8960,9088,18816>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,9088,19584>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,9344,19584>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4736,9472,19328>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4992,9472,19328>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5248,9472,19328>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5248,9472,19584>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4992,9472,19584>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4736,9472,19584>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5248,9472,19840>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4992,9472,19840>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4736,9472,19840>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4736,8704,19840>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4992,8704,19840>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5248,8704,19840>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <5248,8832,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <5248,9088,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <5248,9344,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4992,9344,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4736,9344,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4736,9088,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4992,9088,20096>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4736,8832,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <4992,8832,20096>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5248,9472,18816>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5248,9472,19072>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4992,9472,18816>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4992,9472,19072>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4736,9472,19072>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4736,9472,18816>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4736,8704,19072>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4992,8704,19072>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5248,8704,19072>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5248,8704,18816>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4992,8704,18816>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4736,8704,18816>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3712,8704,19584>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3456,8704,19584>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3200,8704,19584>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,8704,19584>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,8704,19584>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,8704,19328>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,8704,19328>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3200,8704,19328>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3456,8704,19328>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3712,8704,19328>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3712,8704,19072>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3456,8704,19072>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3200,8704,19072>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,8704,19072>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,8704,19072>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3712,8704,18816>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3456,8704,18816>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3200,8704,18816>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,8704,18816>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,8704,18816>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3712,9216,19584>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3456,9216,19584>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3200,9216,19584>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,9216,19584>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,9216,19584>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,9216,19328>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,9216,19328>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3200,9216,19328>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3456,9216,19328>, <0,180,0>, false, 8000 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3712,9216,19328>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3712,9216,19072>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3456,9216,19072>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3200,9216,19072>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,9216,19072>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,9216,19072>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,9216,18816>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,9216,18816>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3200,9216,18816>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3456,9216,18816>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3712,9216,18816>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,8832,19584>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,9088,19584>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,8832,19328>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,9088,19328>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,8832,19584>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,9088,19584>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,8832,19328>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,9088,19328>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,9088,18816>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,8832,18816>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,8832,19072>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,9088,19072>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,8832,18816>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,9088,18816>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,9088,19072>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,8832,19072>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,9600,19584>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,9344,19584>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,9088,19584>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,9088,19328>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,9344,19328>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,9600,19328>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,9600,19072>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,9344,19072>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,9088,19072>, <0,90,0>, false, 8000 )



    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,9088,18304>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,9344,18304>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,9600,18304>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1920,9728,19584>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2176,9728,19584>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2432,9728,19584>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,9600,19584>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,9344,19584>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,9344,19328>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,9600,19328>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,9728,19584>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,9728,19328>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,9728,19072>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,9728,18816>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3712,9728,19584>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2432,9728,19328>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2176,9728,19328>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1920,9728,19328>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1920,9728,19072>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2176,9728,19072>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2432,9728,19072>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1920,9728,18816>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2176,9728,18816>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2432,9728,18816>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1920,9728,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1920,9728,18304>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2176,9728,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1664,8960,18304>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1664,8960,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1664,8960,18816>, <0,180,0>, false, 8000 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,8832,19584>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,8832,19328>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,8832,19072>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,8576,19584>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,8320,19584>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,8576,19328>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1664,9728,18304>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1664,9728,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1664,9728,18816>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1664,9600,19072>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1664,9344,19072>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1664,9088,19072>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3712,9728,19328>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3712,9728,19072>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3712,9728,18816>, <0,180,0>, false, 8000 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3968,9728,18816>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4224,9728,18816>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4480,9728,18816>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4480,9728,19072>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4480,9728,19328>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4480,9728,19584>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4224,9728,19584>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3968,9728,19584>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3968,9728,19072>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4224,9728,19072>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4224,9728,19328>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3968,9728,19328>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,9600,18816>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,9600,19072>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,9600,19328>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,9600,19584>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,8576,19328>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,8576,19584>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4608,8320,19584>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,8576,19328>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,8576,19584>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,8320,19584>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,9344,19584>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3840,9600,19584>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3584,11392,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3584,11136,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3584,10880,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3584,10624,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3584,10368,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3584,10112,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3584,9856,20096>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,9856,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,10112,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,10368,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,10624,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,10880,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,11136,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,11392,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1664,9728,18048>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,9600,18048>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,9344,18048>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,9088,18048>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1664,8960,18048>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1408,8960,18048>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1152,8960,18048>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <896,8960,18048>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <640,8960,18048>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <384,8960,18048>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <128,8960,18048>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-128,8960,18048>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-384,8960,18048>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1408,8960,18304>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1152,8960,18304>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <896,8960,18304>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <640,8960,18304>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <384,8960,18304>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <128,8960,18304>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-128,8960,18304>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-384,8960,18304>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1408,8960,18560>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1408,8960,18816>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1152,8960,18816>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <896,8960,18816>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <640,8960,18816>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <384,8960,18816>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <128,8960,18816>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-128,8960,18816>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-384,8960,18816>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-384,8960,18560>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-128,8960,18560>, <0,180,0>, false, 8000 )

    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <128,8960,18560>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <384,8960,18560>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <640,8960,18560>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <896,8960,18560>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1152,8960,18560>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1408,9728,18048>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1152,9728,18048>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <896,9728,18048>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <640,9728,18048>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <384,9728,18048>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <128,9728,18048>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-128,9728,18048>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-384,9728,18048>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-384,9728,18304>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-128,9728,18304>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <128,9728,18304>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <384,9728,18304>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <640,9728,18304>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <896,9728,18304>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1152,9728,18304>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1408,9728,18304>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1408,9728,18560>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1152,9728,18560>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <896,9728,18560>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <640,9728,18560>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <384,9728,18560>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <128,9728,18560>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-128,9728,18560>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-384,9728,18560>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-384,9728,18816>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-128,9728,18816>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <128,9728,18816>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <384,9728,18816>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <640,9728,18816>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <896,9728,18816>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1152,9728,18816>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1408,9728,18816>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1408,9600,19072>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1408,9344,19072>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1408,9088,19072>, <0,90,0>, false, 8000 )

    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1152,9344,19072>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1152,9088,19072>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1152,9600,19072>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <896,9344,19072>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <896,9088,19072>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <896,9600,19072>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <640,9344,19072>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <640,9088,19072>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <640,9600,19072>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <384,9344,19072>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <384,9088,19072>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <384,9600,19072>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <128,9344,19072>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <128,9088,19072>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <128,9600,19072>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-128,9344,19072>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-128,9088,19072>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-128,9600,19072>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-384,9344,19072>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-384,9600,19072>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-384,9088,19072>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-512,9088,18048>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-512,9344,18048>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-512,9600,18048>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-512,9600,18816>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-512,9344,18816>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-512,9088,18816>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-512,9856,18816>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-512,10112,18816>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-512,10368,18816>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-512,9856,18048>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-512,10112,18048>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-512,10368,18048>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-384,10496,18048>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-128,10496,18048>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <128,10496,18048>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <384,10496,18048>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <640,10496,18048>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <896,10496,18048>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1152,10496,18048>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1408,10496,18048>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1664,10496,18048>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1664,10496,18304>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1408,10496,18304>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1152,10496,18304>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <896,10496,18304>, <0,0,0>, false, 8000 )

    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <640,10496,18304>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <384,10496,18304>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <128,10496,18304>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-128,10496,18304>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-384,10496,18304>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-384,10496,18560>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-384,10496,18816>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-128,10496,18816>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <128,10496,18816>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <384,10496,18816>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <640,10496,18816>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <896,10496,18816>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1152,10496,18816>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1408,10496,18816>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1664,10496,18816>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1664,10496,18560>, <0,0,0>, false, 8000 )

    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1408,10496,18560>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1152,10496,18560>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <896,10496,18560>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <640,10496,18560>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <384,10496,18560>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <128,10496,18560>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-128,10496,18560>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-384,9856,19072>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-384,10112,19072>, <0,-90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-384,10368,19072>, <0,-90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-128,10112,19072>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <128,10112,19072>, <0,-90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <384,10112,19072>, <0,-90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <640,10112,19072>, <0,-90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <896,10112,19072>, <0,-90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1152,10112,19072>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1408,10112,19072>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1664,10112,19072>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1664,9856,19072>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1408,9856,19072>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1152,9856,19072>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <896,9856,19072>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <640,9856,19072>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <384,9856,19072>, <0,0,0>, false, 8000 )

    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <128,9856,19072>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-128,9856,19072>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-128,10368,19072>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <128,10368,19072>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <384,10368,19072>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <640,10368,19072>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <896,10368,19072>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1152,10368,19072>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1408,10368,19072>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1664,10368,19072>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-640,9728,18048>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-640,9728,18304>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-640,9728,18560>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-640,9728,18816>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-640,8960,18048>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-896,8960,18048>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1152,8960,18048>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1408,8960,18048>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1536,9088,18048>, <0,-90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1536,9344,18048>, <0,-90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1536,9600,18048>, <0,-90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1536,9856,18048>, <0,-90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1536,10112,18048>, <0,-90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1536,10368,18048>, <0,-90,0>, false, 8000 )



    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1408,10496,18048>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1152,10496,18048>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-896,10496,18048>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-640,10496,18048>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-640,10496,18304>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-896,10496,18304>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1152,10496,18304>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1408,10496,18304>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1536,10368,18304>, <0,-90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1536,10112,18304>, <0,-90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1536,9856,18304>, <0,-90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1536,9600,18304>, <0,-90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1536,9344,18304>, <0,-90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1536,9088,18304>, <0,-90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1408,8960,18304>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1152,8960,18304>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-896,8960,18304>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-640,8960,18304>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-640,8960,18560>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-896,8960,18560>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1152,8960,18560>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1408,8960,18560>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1536,9088,18560>, <0,-90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1536,9344,18560>, <0,-90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1536,9600,18560>, <0,-90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1536,9856,18560>, <0,-90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1536,10112,18560>, <0,-90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1536,10368,18560>, <0,-90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1408,10496,18560>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1152,10496,18560>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-896,10496,18560>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-640,10496,18560>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-640,10496,18816>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-896,10496,18816>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1152,10496,18816>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1408,10496,18816>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1536,10368,18816>, <0,-90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1536,10112,18816>, <0,-90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1536,9856,18816>, <0,-90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1536,9600,18816>, <0,-90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1536,9344,18816>, <0,-90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1536,9088,18816>, <0,-90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1408,8960,18816>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1152,8960,18816>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-896,8960,18816>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-640,8960,18816>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-640,9088,19072>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-640,9344,19072>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-640,9600,19072>, <0,90,0>, false, 8000 )

    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-640,9856,19072>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-640,10112,19072>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-640,10368,19072>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-896,10368,19072>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-896,10112,19072>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-896,9856,19072>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-896,9600,19072>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-896,9344,19072>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-896,9088,19072>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-1152,9088,19072>, <0,90,0>, false, 8000 )

    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-1152,9344,19072>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-1152,9600,19072>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-1152,9856,19072>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-1152,10112,19072>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-1152,10368,19072>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-1408,10368,19072>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-1408,10112,19072>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-1408,9856,19072>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-1408,9600,19072>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-1408,9344,19072>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-1408,9088,19072>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,9856,18816>, <0,-90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,10112,18816>, <0,-90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,10368,18816>, <0,-90,0>, false, 8000 )


    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1664,11008,18560>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1664,11008,18304>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1664,11008,18048>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1408,11008,18048>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1152,11008,18048>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <896,11008,18048>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <640,11008,18048>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <384,11008,18048>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <128,11008,18048>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-128,11008,18048>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-384,11008,18048>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-640,11008,18048>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-896,11008,18048>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1152,11008,18048>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1408,11008,18048>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1664,11008,18048>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1920,11008,18048>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2048,10880,18048>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2048,10624,18048>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2048,10368,18048>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2048,10112,18048>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2048,9856,18048>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2048,9600,18048>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2048,9344,18048>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2048,9088,18048>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1408,11008,18304>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1152,11008,18304>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <896,11008,18304>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <640,11008,18304>, <0,0,0>, false, 8000 )


    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <384,11008,18304>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <128,11008,18304>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-128,11008,18304>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-384,11008,18304>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-640,11008,18304>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-896,11008,18304>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1152,11008,18304>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1408,11008,18304>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1664,11008,18304>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1920,11008,18304>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1408,11008,18560>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1152,11008,18560>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <896,11008,18560>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <640,11008,18560>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <384,11008,18560>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <128,11008,18560>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-128,11008,18560>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-384,11008,18560>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-640,11008,18560>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-896,11008,18560>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1152,11008,18560>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1408,11008,18560>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1664,11008,18560>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1920,11008,18560>, <0,0,0>, false, 8000 )

    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1920,9728,18048>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2176,9728,18048>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2176,9728,18304>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2304,9856,18048>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2304,10112,18048>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2304,10368,18048>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2304,10624,18048>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2304,10880,18048>, <0,90,0>, false, 8000 )



    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1920,11008,18048>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2176,11008,18048>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1920,11008,18304>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2176,11008,18304>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2304,10880,18304>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2304,10624,18304>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2304,10368,18304>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2304,10112,18304>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2304,9856,18304>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2304,9856,18560>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2304,10112,18560>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2304,10368,18560>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2304,10624,18560>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2304,10880,18560>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2176,11008,18560>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1920,11008,18560>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1664,10880,18816>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1664,10624,18816>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1920,10624,18816>, <0,-90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1920,10368,18816>, <0,-90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1920,10112,18816>, <0,-90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1920,9856,18816>, <0,-90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2176,9856,18816>, <0,-90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2176,10112,18816>, <0,-90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2176,10368,18816>, <0,-90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2176,10624,18816>, <0,-90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2176,10880,18816>, <0,-90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1920,10880,18816>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1408,10880,18816>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1152,10880,18816>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <896,10880,18816>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <640,10880,18816>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <384,10880,18816>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <128,10880,18816>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-128,10880,18816>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-384,10880,18816>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-640,10880,18816>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-896,10880,18816>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-1152,10880,18816>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-1408,10880,18816>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-1408,10624,18816>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-1152,10624,18816>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-896,10624,18816>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-640,10624,18816>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-384,10624,18816>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-128,10624,18816>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <128,10624,18816>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <384,10624,18816>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <640,10624,18816>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <896,10624,18816>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1152,10624,18816>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1408,10624,18816>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2048,10880,18304>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2048,10624,18304>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2048,10368,18304>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2048,10112,18304>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2048,9856,18304>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2048,9600,18304>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2048,9344,18304>, <0,90,0>, false, 8000 )

    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2048,9088,18304>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2048,9088,18560>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2048,9344,18560>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2048,9600,18560>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2048,9856,18560>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2048,10112,18560>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2048,10368,18560>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2048,10624,18560>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2048,10880,18560>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-1664,10880,18816>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-1664,10624,18816>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-1664,10368,18816>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-1664,10112,18816>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-1664,9856,18816>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-1664,9600,18816>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-1664,9344,18816>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-1664,9088,18816>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-1920,9088,18816>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-1920,9344,18816>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-1920,9600,18816>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-1920,9856,18816>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-1920,10112,18816>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-1920,10368,18816>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-1920,10624,18816>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-1920,10880,18816>, <0,90,0>, false, 8000 )

    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3712,9088,18816>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3712,8832,18816>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3456,9088,18816>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3456,8832,18816>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3200,9088,18816>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <3200,8832,18816>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2944,9088,18816>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2944,8832,18816>, <0,90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2688,9088,18816>, <0,180,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2688,8832,18816>, <0,0,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,8576,19584>, <0,-90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,8320,19584>, <0,-90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,8576,19328>, <0,-90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2048,8832,18048>, <0,-90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2048,8576,18048>, <0,-90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2048,8320,18048>, <0,-90,0>, false, 8000 )
    // CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2048,8064,18048>, <0,-90,0>, false, 8000 )


    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2048,8064,18304>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2048,8320,18304>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2048,8576,18304>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2048,8832,18304>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2048,8832,18560>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2048,8576,18560>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2048,8320,18560>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2048,8064,18560>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2176,7424,18048>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2432,7424,18048>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2176,7936,18304>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2176,7936,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2432,7936,18304>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2432,7936,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2176,7936,18048>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2432,7936,18048>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2176,7424,18304>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2432,7424,18304>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2432,7424,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2176,7424,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-2176,7808,18816>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-2432,7808,18816>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-2432,7552,18816>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-2176,7552,18816>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-1920,7552,18816>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-1920,7808,18816>, <0,-90,0>, false, 8000 )


    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-1664,7808,18816>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-1664,8064,18816>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-1664,8320,18816>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-1664,8576,18816>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-1664,8832,18816>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-1920,8832,18816>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-1920,8576,18816>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-1920,8320,18816>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-1920,8064,18816>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,8064,18048>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,8320,18048>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,8320,18304>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,8064,18304>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,8064,18560>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,8320,18560>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2688,7424,18048>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1536,8832,18048>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1536,8576,18048>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1536,8320,18048>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1536,8064,18048>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1536,7808,18048>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1536,7552,18048>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1920,7424,18048>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1664,7424,18048>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1536,8832,18304>, <0,90,0>, false, 8000 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1536,8576,18304>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1536,8320,18304>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1536,8064,18304>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1536,7808,18304>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1536,7552,18304>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1664,7424,18304>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1920,7424,18304>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1920,7424,18560>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1664,7424,18560>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1536,7552,18560>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1536,7808,18560>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1536,8064,18560>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1536,8320,18560>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1536,8576,18560>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1536,8832,18560>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2688,7424,18304>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2688,7424,18560>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2944,7424,18048>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2944,7424,18304>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2944,7424,18560>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-3072,7552,18048>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-3072,7808,18048>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-3072,8064,18048>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-3072,8320,18048>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-3072,8576,18048>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-3072,8832,18048>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-3072,9088,18048>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,8576,18048>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,8832,18048>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,9088,18048>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,8576,18304>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,8832,18304>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,9088,18304>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,9088,18560>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,8832,18560>, <0,90,0>, false, 8000 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,8576,18560>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-3072,7552,18304>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-3072,7808,18304>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-3072,8064,18304>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-3072,8320,18304>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-3072,8576,18304>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-3072,8832,18304>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-3072,9088,18304>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-3072,9088,18560>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-3072,8832,18560>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-3072,8576,18560>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-3072,8320,18560>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-3072,8064,18560>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-3072,7808,18560>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-3072,7552,18560>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-2688,7552,18816>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-2944,7552,18816>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-2944,7808,18816>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-2688,7808,18816>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-2688,8064,18816>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-2944,8064,18816>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-2944,8320,18816>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-2944,8576,18816>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-2944,8832,18816>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-2944,9088,18816>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-2688,9088,18816>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-2688,8832,18816>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-2688,8576,18816>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-2688,8320,18816>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2432,9216,18048>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2176,9216,18048>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2176,9216,18304>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2432,9216,18304>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2432,9216,18560>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2176,9216,18560>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-3072,9344,18048>, <0,-90,0>, false, 8000 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-3072,9600,18048>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-3072,9856,18048>, <0,-90,0>, false, 8000 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2944,9984,18048>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2688,9984,18048>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,10112,18048>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,10368,18048>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,10624,18048>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,10880,18048>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,11136,18048>, <0,-90,0>, false, 8000 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-3072,9344,18304>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-3072,9600,18304>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-3072,9856,18304>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2944,9984,18304>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2688,9984,18304>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,10112,18304>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,10368,18304>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,10624,18304>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,10880,18304>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,11136,18304>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,11136,18560>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,10880,18560>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,10624,18560>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,10368,18560>, <0,-90,0>, false, 8000 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,10112,18560>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2688,9984,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2944,9984,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-3072,9856,18560>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-3072,9600,18560>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-3072,9344,18560>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-2944,9344,18816>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-2688,9344,18816>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-2432,9344,18816>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-2176,9344,18816>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-2176,9600,18816>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-2432,9600,18816>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-2688,9600,18816>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-2944,9600,18816>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-2944,9856,18816>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-2688,9856,18816>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-2432,9856,18816>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-2176,9856,18816>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-2432,10112,18816>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-2432,10368,18816>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-2432,10624,18816>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-2432,10880,18816>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-2432,11136,18816>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-2176,11136,18816>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-2176,10880,18816>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-2176,10624,18816>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-2176,10368,18816>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-2176,10112,18816>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-640,11008,17792>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-896,11008,17792>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1152,11008,17792>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-384,11008,17792>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-128,11008,17792>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <128,11008,17792>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <384,11008,17792>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <640,11008,17792>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <896,11008,17792>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1152,11008,17792>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1408,11008,17792>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1664,11008,17792>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1920,11008,17792>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2176,11008,17792>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1408,11008,17792>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1664,11008,17792>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1920,11008,17792>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2432,19712,17536>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2688,19712,17536>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2944,19712,17536>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2176,19712,17536>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1920,19712,17536>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1920,19968,17536>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2176,19968,17536>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2432,19968,17536>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2688,19968,17536>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2944,19968,17536>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2944,20224,17536>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2688,20224,17536>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2432,20224,17536>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2176,20224,17536>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1920,20224,17536>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1920,20480,17536>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2176,20480,17536>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2432,20480,17536>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2688,20480,17536>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2944,20480,17536>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,20480,17536>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,20224,17536>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,19968,17536>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,19712,17536>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,20608,17536>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,20608,17536>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2432,20608,17536>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2176,20608,17536>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1920,20608,17536>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,20480,17536>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,20224,17536>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,19968,17536>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,19712,17536>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1920,19584,17280>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2176,19584,17280>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2432,19584,17280>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,19584,17280>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,19584,17280>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,19584,17024>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,19584,17024>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2432,19584,17024>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2176,19584,17024>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1920,19584,17024>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1920,19584,16768>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2176,19584,16768>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2432,19584,16768>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,19584,16768>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,19584,16768>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,19584,16512>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,19584,16512>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2432,19584,16512>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2176,19584,16512>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1920,19584,16512>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1920,20608,17792>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2176,20608,17792>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2432,20608,17792>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,20608,17792>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,20608,17792>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,20480,17792>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,20224,17792>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,19968,17792>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,19712,17792>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,20480,17792>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,20224,17792>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,19968,17792>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,19712,17792>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,19712,18048>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,19968,18048>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,20224,18048>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,20480,18048>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1920,20608,18048>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2176,20608,18048>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2432,20608,18048>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,20608,18048>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,20608,18048>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,20480,18048>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,20224,18048>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,19968,18048>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,19712,18048>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,19712,18304>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,19968,18304>, <0,-90,0>, false, 8000 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,20224,18304>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,20480,18304>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1920,20608,18304>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2176,20608,18304>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2432,20608,18304>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,20608,18304>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,20608,18304>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,20480,18304>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,20224,18304>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,19968,18304>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,19712,18304>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2944,20480,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2688,20480,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2432,20480,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2176,20480,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1920,20480,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1920,20224,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2176,20224,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2432,20224,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2688,20224,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2944,20224,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2944,19968,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2688,19968,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2432,19968,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2176,19968,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1920,19968,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1920,19712,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2176,19712,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2432,19712,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2688,19712,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2944,19712,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,19456,16512>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,19200,16512>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,18944,16512>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,18688,16512>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,18432,16512>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,18176,16512>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,17920,16512>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,17664,16512>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,17408,16512>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,17152,16512>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,16896,16512>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,16640,16512>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,16384,16512>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,16128,16512>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,15872,16512>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,15616,16512>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,15360,16512>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,15104,16512>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,14848,16512>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,14592,16512>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,14336,16512>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,14080,16512>, <0,90,0>, false, 8000 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,13824,16512>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,13568,16512>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,13312,16512>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,13056,16512>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,12800,16512>, <0,90,0>, false, 8000 )


    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1664,12672,16512>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1408,12672,16512>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1152,12672,16512>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <896,12672,16512>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <640,12672,16512>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <384,12672,16512>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <128,12672,16512>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-128,12672,16512>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-384,12672,16512>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-640,12672,16512>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-896,12672,16512>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1152,12672,16512>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1408,12672,16512>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1664,12672,16512>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1920,12672,16512>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2176,12672,16512>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2432,12672,16512>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,12544,16512>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,12288,16512>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,12032,16512>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,11776,16512>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,11520,16512>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,11264,16512>, <0,90,0>, false, 8000 )


    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,11136,17792>, <0,90,0>, false, 8000 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,11136,17536>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,11136,17280>, <0,90,0>, false, 8000 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,11136,17024>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,11136,16768>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,11136,16512>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2048,10880,17792>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2048,10624,17792>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2176,11008,17536>, <0,0,0>, false, 8000 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,19456,16512>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,19200,16512>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,18944,16512>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,18688,16512>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,18432,16512>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,18176,16512>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,17920,16512>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,17664,16512>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,17408,16512>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,17152,16512>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,16896,16512>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,16640,16512>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,16384,16512>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,16128,16512>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,15872,16512>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,15616,16512>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,15360,16512>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,15104,16512>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,14848,16512>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,14592,16512>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,14336,16512>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,14080,16512>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,13824,16512>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,13568,16512>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,13312,16512>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,13056,16512>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,12800,16512>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,12544,16512>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,12288,16512>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,12032,16512>, <0,-90,0>, false, 8000 )



    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,11904,16512>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,11904,16512>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2432,11904,16512>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2304,11776,16512>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2304,11520,16512>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2304,11264,16512>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2176,11008,17280>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2176,11008,17024>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2176,11008,16768>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2176,11008,16512>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2304,11136,16512>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,12032,19840>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,11904,19840>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,11648,19840>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,11392,19840>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,11136,19840>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,10880,19840>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,10624,19840>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,10368,19840>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,10112,19840>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,9856,19840>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3200,12032,19840>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3456,12032,19840>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3712,12032,19840>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3968,12032,19840>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4224,12032,19840>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4480,12032,19840>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4736,12032,19840>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4992,12032,19840>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5248,12032,19840>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5504,12032,19840>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5760,12032,19840>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1920,11008,16512>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1664,11008,16512>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1408,11008,16512>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1152,11008,16512>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <896,11008,16512>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <640,11008,16512>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <384,11008,16512>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <128,11008,16512>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-128,11008,16512>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-384,11008,16512>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-640,11008,16512>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-896,11008,16512>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1152,11008,16512>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1408,11008,16512>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1664,11008,16512>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1920,11008,16512>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1920,11008,16768>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1920,11008,17024>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1920,11008,17280>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1920,11008,17536>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2048,10880,16768>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2048,10880,17024>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2048,10624,17024>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2048,10880,17280>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2048,10624,17280>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2048,10368,17280>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2048,10880,17536>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2048,10624,17536>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2048,10368,17536>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2048,10112,17536>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2048,10368,17792>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2048,10112,17792>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2048,9856,17792>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,10880,16768>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,10880,17024>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,10624,17024>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,10880,17280>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,10624,17280>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,10368,17280>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,10880,17536>, <0,-90,0>, false, 8000 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,10624,17536>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,10368,17536>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,10112,17536>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,10112,17792>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,10368,17792>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,10624,17792>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,10880,17792>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2688,9984,17792>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1664,11008,16768>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1408,11008,16768>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1152,11008,16768>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-896,11008,16768>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-640,11008,16768>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-384,11008,16768>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-128,11008,16768>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <128,11008,16768>, <0,0,0>, false, 8000 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <384,11008,16768>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <640,11008,16768>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <896,11008,16768>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1152,11008,16768>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1408,11008,16768>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1664,11008,16768>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1920,11008,16768>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1920,11008,17024>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1664,11008,17024>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1408,11008,17024>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1152,11008,17024>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <896,11008,17024>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <640,11008,17024>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <384,11008,17024>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <128,11008,17024>, <0,0,0>, false, 8000 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-128,11008,17024>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-384,11008,17024>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-640,11008,17024>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-896,11008,17024>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1152,11008,17024>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1408,11008,17024>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1664,11008,17024>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1664,11008,17280>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1408,11008,17280>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1152,11008,17280>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-896,11008,17280>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-640,11008,17280>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-384,11008,17280>, <0,0,0>, false, 8000 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-128,11008,17280>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <128,11008,17280>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <384,11008,17280>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <640,11008,17280>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <896,11008,17280>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1152,11008,17280>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1408,11008,17280>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1664,11008,17280>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1920,11008,17280>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1920,11008,17536>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1664,11008,17536>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1408,11008,17536>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1152,11008,17536>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <896,11008,17536>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <640,11008,17536>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <384,11008,17536>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <128,11008,17536>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-128,11008,17536>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-384,11008,17536>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-640,11008,17536>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-896,11008,17536>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1152,11008,17536>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1408,11008,17536>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1664,11008,17536>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2304,11136,16768>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2304,11392,16768>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2304,11648,16768>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2304,11776,16768>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2432,11904,16768>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,11904,16768>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,11904,16768>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,11904,17024>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,11904,17024>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2432,11904,17024>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2304,11136,17024>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2304,11392,17024>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2304,11648,17024>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2304,11776,17024>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2304,11136,17280>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2304,11392,17280>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2304,11648,17280>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2304,11776,17280>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2304,11136,17536>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2304,11392,17536>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2304,11648,17536>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2304,11776,17536>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2304,11136,17792>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2304,11392,17792>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2304,11648,17792>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2304,11776,17792>, <0,90,0>, false, 8000 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2304,11392,18048>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2304,11648,18048>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2304,11776,18048>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2304,11136,18304>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2304,11392,18304>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2304,11648,18304>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2304,11776,18304>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2304,11136,18560>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2304,11392,18560>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2304,11648,18560>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2304,11776,18560>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2432,11904,17280>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,11904,17280>, <0,0,0>, false, 8000 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,11904,17280>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,11904,17536>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,11904,17536>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2432,11904,17536>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2432,11904,17792>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,11904,17792>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,11904,17792>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,11904,18048>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,11904,18048>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2432,11904,18048>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2432,11904,18304>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,11904,18304>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,11904,18304>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,11904,18560>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,11904,18560>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2432,11904,18560>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,12032,16768>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,12288,16768>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,12544,16768>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,12800,16768>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,13056,16768>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,13312,16768>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,13568,16768>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,13824,16768>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,14080,16768>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,14336,16768>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,14592,16768>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,14848,16768>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,15104,16768>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,15360,16768>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,15616,16768>, <0,-90,0>, false, 8000 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,15872,16768>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,16128,16768>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,16384,16768>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,16640,16768>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,16896,16768>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,17152,16768>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,17408,16768>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,17664,16768>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,17920,16768>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,18176,16768>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,18432,16768>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,18688,16768>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,18944,16768>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,19200,16768>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,19456,16768>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,19456,17024>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,19200,17024>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,18944,17024>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,18688,17024>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,18432,17024>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,18176,17024>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,17920,17024>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,17664,17024>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,17408,17024>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,17152,17024>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,16896,17024>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,16640,17024>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,16384,17024>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,16128,17024>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,15872,17024>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,15616,17024>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,15360,17024>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,15104,17024>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,14848,17024>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,14592,17024>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,14336,17024>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,14080,17024>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,13824,17024>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,13568,17024>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,13312,17024>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,13056,17024>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,12800,17024>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,12544,17024>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,12288,17024>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,12032,17024>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,12032,17280>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,12288,17280>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,12544,17280>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,12800,17280>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,13056,17280>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,13312,17280>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,13568,17280>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,13824,17280>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,14080,17280>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,14336,17280>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,14592,17280>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,14848,17280>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,15104,17280>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,15360,17280>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,15616,17280>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,15872,17280>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,16128,17280>, <0,-90,0>, false, 8000 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,16384,17280>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,16640,17280>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,16896,17280>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,17152,17280>, <0,-90,0>, false, 8000 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,17408,17280>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,17664,17280>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,17920,17280>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,18176,17280>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,18432,17280>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,18688,17280>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,18944,17280>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,19200,17280>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,19456,17280>, <0,-90,0>, false, 8000 )
	 CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2304,11136,18048>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-1664,7552,18816>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,11904,18816>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,11904,19072>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,11904,19328>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,11904,19584>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,11904,19840>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,11904,20096>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,11904,20352>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,11904,20608>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,12032,17536>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,12032,17792>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,12032,18048>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,12032,18304>, <0,-90,0>, false, 8000 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,12032,18560>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,12032,18816>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,12032,19072>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,12032,19328>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,12032,19584>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,12032,19840>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,12032,20096>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,12032,20352>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,12032,20608>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,12288,17536>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,12544,17536>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,12800,17536>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,13056,17536>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,12288,17792>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,12544,17792>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,12800,17792>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,12544,18048>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,12288,18048>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,12288,18304>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3200,12032,19584>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3456,12032,19584>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3712,12032,19584>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3968,12032,19584>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4224,12032,19584>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3968,12032,19328>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3712,12032,19328>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3456,12032,19328>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3200,12032,19328>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3200,12032,19072>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3456,12032,19072>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3712,12032,19072>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3200,12032,18816>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3456,12032,18816>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3200,12032,18560>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,11776,19584>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,11520,19584>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,11264,19584>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,11008,19584>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,10752,19584>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,10496,19584>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,10240,19584>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,9984,19584>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,9856,19584>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,9856,19328>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,10112,19328>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,10368,19328>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,10624,19328>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,10880,19328>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,11136,19328>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,11392,19328>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,11648,19328>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,11776,19328>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,9856,18816>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,10112,18816>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,10368,18816>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,10624,18816>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,10880,18816>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,11136,18816>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,11392,18816>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,11648,18816>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,11776,18816>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,11776,19072>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,11712,19072>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,11456,19072>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,11200,19072>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,10944,19072>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,10688,19072>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,10432,19072>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,10176,19072>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,9920,19072>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,9856,19072>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,19456,17536>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,19200,17536>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,18944,17536>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,18688,17536>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,18432,17536>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,18432,17792>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,18688,17792>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,18944,17792>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,19200,17792>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,19456,17792>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,19456,18048>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,19200,18048>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,18944,18048>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,18688,18048>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,18432,18048>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,18432,18304>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,18688,18304>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,18944,18304>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,19200,18304>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,19456,18304>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1920,19584,18304>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2176,19584,18304>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2432,19584,18304>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,19584,18304>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,19584,18304>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,19456,16768>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,19200,16768>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,18944,16768>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,18688,16768>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,18432,16768>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,18176,16768>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,17920,16768>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,17664,16768>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,18432,17024>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,18432,17280>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,18432,17536>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,18432,17792>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,18432,18048>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,18432,18304>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,18688,18304>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,18944,18304>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,19200,18304>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,19456,18304>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,19456,17024>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,19200,17024>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,18944,17024>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,18688,17024>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,18688,17280>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,18944,17280>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,19200,17280>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,19456,17280>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,19456,17536>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,19200,17536>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,18944,17536>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,18688,17536>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,18688,17792>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,18944,17792>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,19200,17792>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,19456,17792>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,19456,18048>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,19200,18048>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,18944,18048>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,18688,18048>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,18176,17024>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,17920,17024>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,17664,17024>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,17408,16768>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,17152,16768>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,16896,16768>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,16640,16768>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,16384,16768>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,16128,16768>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,15872,16768>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,15616,16768>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,15360,16768>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,15104,16768>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,14848,16768>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,14592,16768>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,14336,16768>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,14080,16768>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,13824,16768>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,13568,16768>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,13312,16768>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,13056,16768>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,12800,16768>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1664,12672,16768>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1408,12672,16768>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1152,12672,16768>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <896,12672,16768>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <640,12672,16768>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <384,12672,16768>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <128,12672,16768>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-128,12672,16768>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-384,12672,16768>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-640,12672,16768>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-896,12672,16768>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1152,12672,16768>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1408,12672,16768>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1664,12672,16768>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1920,12672,16768>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2176,12672,16768>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2432,12672,16768>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,12544,16768>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,12288,16768>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,12032,16768>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,11776,16768>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,11520,16768>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,11264,16768>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,11264,17024>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,11520,17024>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,11776,17024>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,12032,17024>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,12288,17024>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,12544,17024>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2432,12672,17024>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2176,12672,17024>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1920,12672,17024>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1664,12672,17024>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1408,12672,17024>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1152,12672,17024>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-896,12672,17024>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-640,12672,17024>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-384,12672,17024>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-128,12672,17024>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <128,12672,17024>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <384,12672,17024>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <640,12672,17024>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <896,12672,17024>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1152,12672,17024>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1408,12672,17024>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1664,12672,17024>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,12800,17024>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,13056,17024>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,13312,17024>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,13568,17024>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,13824,17024>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,14080,17024>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,14336,17024>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,14592,17024>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,14848,17024>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,15104,17024>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,15360,17024>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,15616,17024>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,15872,17024>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,16128,17024>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,16384,17024>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,16640,17024>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,16896,17024>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,17152,17024>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,17408,17024>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,18176,17280>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,17920,17280>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,17664,17280>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,17408,17280>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,17152,17280>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,16896,17280>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,16640,17280>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,16384,17280>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,16128,17280>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,15872,17280>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,15616,17280>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,15360,17280>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,15104,17280>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,14848,17280>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,14592,17280>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,14336,17280>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,14080,17280>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,13824,17280>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,13568,17280>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,13312,17280>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,13056,17280>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,12800,17280>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1664,12672,17280>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1408,12672,17280>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1152,12672,17280>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <896,12672,17280>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <640,12672,17280>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <384,12672,17280>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <128,12672,17280>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-128,12672,17280>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-384,12672,17280>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-640,12672,17280>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-896,12672,17280>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1152,12672,17280>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1408,12672,17280>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1664,12672,17280>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1920,12672,17280>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2176,12672,17280>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2432,12672,17280>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,12544,17280>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,12288,17280>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,12032,17280>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,11776,17280>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,11520,17280>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,11264,17280>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,11264,17536>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,11264,17792>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,11520,17536>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,11776,17536>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,11520,17792>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2560,11264,18048>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,13312,17536>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,13056,17536>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,12800,17536>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1664,12672,17536>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1408,12672,17536>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1152,12672,17536>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1408,12672,17792>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1664,12672,17792>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,12800,17792>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,13056,17792>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1792,12800,18048>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1664,12672,18048>, <0,0,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1920,19456,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2176,19456,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2432,19456,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2688,19456,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2944,19456,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2944,19200,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2688,19200,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2432,19200,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2176,19200,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1920,19200,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1920,18944,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2176,18944,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2432,18944,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2688,18944,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2944,18944,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2944,18688,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2688,18688,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2432,18688,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2176,18688,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1920,18688,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <1920,18432,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2176,18432,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2432,18432,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2688,18432,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2944,18432,18560>, <0,180,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2304,20480,17536>, <0,-90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,20480,17536>, <0,90,0>, false, 8000 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <2432,20480,17792>, <0,180,0>, false, 8000 )


    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3392,8384,20928>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,8384,20928>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3072,8128,20928>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3392,8128,20928>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,8128,20736>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3520,8128,20736>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3520,7872,20736>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,7872,20736>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,7872,20544>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,7616,20544>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,7360,20544>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,7104,20544>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,6848,20544>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,6592,20544>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,6336,20544>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,6080,20544>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2816,5824,20544>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3648,7872,20544>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3648,7616,20544>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3648,7360,20544>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3648,7104,20544>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3648,6848,20544>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3648,6592,20544>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3648,6336,20544>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3648,6080,20544>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3648,5824,20544>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2176,5760,20352>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2176,6016,20352>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2176,6272,20352>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2176,6528,20352>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2176,6784,20352>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2176,7040,20352>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2176,7296,20352>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2176,7552,20352>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2176,7808,20352>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2176,8064,20352>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2176,8320,20352>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2176,8576,20352>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2176,8832,20352>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2176,9088,20352>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3008,9920,20352>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3328,9920,20352>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3328,10176,20352>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3328,10432,20352>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3328,10688,20352>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3008,10176,20352>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3008,10432,20352>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3008,10688,20352>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4224,5760,20288>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4224,6016,20288>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4224,6272,20288>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4224,6528,20288>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4224,6784,20288>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4224,7040,20288>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4224,7296,20288>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4224,7552,20288>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4224,7808,20288>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4224,8064,20288>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4224,8320,20288>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4224,8576,20288>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4224,8832,20288>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4224,9088,20288>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3328,10944,20352>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3328,11200,20352>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3008,10944,20352>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3008,11200,20352>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5248,11904,20160>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4992,11904,20160>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4736,11904,20160>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4480,11904,20160>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5248,11648,20160>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4992,11648,20160>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4736,11648,20160>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4480,11648,20160>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5504,11904,20160>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5760,11904,20160>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5504,11392,20160>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5504,11136,20160>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5504,10880,20160>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5504,10624,20160>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5504,10368,20160>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5504,10112,20160>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5760,11904,20160>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5760,11648,20160>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5760,11392,20160>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5760,11136,20160>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5760,10880,20160>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5760,10624,20160>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5760,10368,20160>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5760,10112,20160>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6272,8896,19840>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6272,9216,19840>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6528,9216,19840>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6528,8896,19840>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6528,8768,19648>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6784,8768,19648>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6784,8640,19456>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7040,8640,19456>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7040,8512,19264>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7296,8512,19264>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7296,8384,19072>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7552,8384,19072>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6528,9344,19648>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6784,9344,19648>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6784,9472,19456>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7040,9472,19456>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7040,9600,19264>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7296,9600,19264>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7296,9728,19072>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7552,9728,19072>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8832,8896,18816>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8832,9216,18816>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8576,9216,18816>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8320,9216,18816>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8064,9216,18816>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7808,9216,18816>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7552,9216,18816>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7296,9216,18816>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7040,9216,18816>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6784,9216,18816>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6528,9216,18816>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6272,9216,18816>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6016,9216,18816>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5760,9216,18816>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5504,9216,18816>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5248,9216,18816>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4992,9216,18816>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4736,9216,18816>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8576,8896,18816>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8320,8896,18816>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <8064,8896,18816>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7808,8896,18816>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7552,8896,18816>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7296,8896,18816>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <7040,8896,18816>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6784,8896,18816>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6528,8896,18816>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6272,8896,18816>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <6016,8896,18816>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5760,8896,18816>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5504,8896,18816>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <5248,8896,18816>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4992,8896,18816>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <4736,8896,18816>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3712,9344,18880>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3456,9344,18880>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <3200,9344,18880>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2944,9344,18880>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2688,9344,18880>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1536,9536,18304>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1536,9216,18304>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1280,9536,18304>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1280,9216,18304>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1024,9216,18304>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <768,9216,18304>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1024,9536,18304>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <768,9536,18304>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <512,9536,18304>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <256,9536,18304>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-256,9536,18304>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <512,9216,18304>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <256,9216,18304>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-256,9216,18304>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-256,10304,18112>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-256,9920,18112>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <256,9920,18112>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <512,9920,18112>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <768,9920,18112>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1024,9920,18112>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1280,9920,18112>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1536,9920,18112>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <256,10304,18112>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <512,10304,18112>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <768,10304,18112>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1024,10304,18112>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1280,10304,18112>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1536,10304,18112>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1664,10688,18048>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1408,10688,18048>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1152,10688,18048>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <896,10688,18048>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <640,10688,18048>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <384,10688,18048>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <128,10688,18048>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-128,10688,18048>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-384,10688,18048>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-640,10688,18048>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-896,10688,18048>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1152,10688,18048>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1408,10688,18048>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1728,10368,18048>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1728,10112,18048>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1728,9856,18048>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1728,9600,18048>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1728,9344,18048>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1728,9088,18048>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1664,10816,18048>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1408,10816,18048>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1152,10816,18048>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <896,10816,18048>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <640,10816,18048>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <384,10816,18048>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <128,10816,18048>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-128,10816,18048>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-384,10816,18048>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-640,10816,18048>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-896,10816,18048>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1152,10816,18048>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1408,10816,18048>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1664,10816,18048>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1920,10816,18048>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1920,10816,18048>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1920,10560,18048>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1920,10304,18048>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1920,10048,18048>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1920,9792,18048>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1920,9536,18048>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1920,9280,18048>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1920,9088,18048>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1664,7616,18112>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1920,7616,18112>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2176,7616,18112>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2432,7616,18112>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2688,7616,18112>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2944,7616,18112>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2688,8064,18048>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2688,8320,18048>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2688,8576,18048>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2688,8832,18048>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2688,9088,18048>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2944,9088,18048>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2944,8832,18048>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2944,8576,18048>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2944,8320,18048>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2944,8064,18048>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2240,9856,18048>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2240,10112,18048>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2240,10368,18048>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2240,10624,18048>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-2240,10880,18048>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-640,11328,17856>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-384,11328,17856>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-384,11456,17664>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-128,11456,17664>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-128,11584,17472>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <128,11584,17472>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <128,11712,17280>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <384,11712,17280>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <384,11840,17088>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <640,11840,17088>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <640,11968,16896>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <896,11968,16896>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <384,11968,16896>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <128,11840,17088>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-128,11712,17280>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-384,11584,17472>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-640,11456,17664>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-896,11328,17856>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1152,11968,16896>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <1408,11968,16896>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2240,13312,16896>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2240,13568,16896>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2240,13824,16896>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2240,14080,16896>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2240,14336,16896>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2240,14592,16896>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2240,14848,16896>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2240,15104,16896>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2240,15360,16896>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2240,15616,16896>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2240,15872,16896>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2240,16128,16896>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2240,16384,16896>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,16384,16896>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,16128,16896>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,15872,16896>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,15616,16896>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,15360,16896>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,15104,16896>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,14848,16896>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,14592,16896>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,14336,16896>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,14080,16896>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,13824,16896>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,13568,16896>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,13312,16896>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1.11901e-05,9216,18304>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2.23802e-05,9536,18304>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2.23802e-05,10304,18112>, <0,0,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-1.11901e-05,9920,18112>, <0,180,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,16640,16896>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2560,16896,16896>, <0,-90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2240,16640,16896>, <0,90,35>, false, 8000 )
    CreateEditorPropRamps( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <2240,16896,16896>, <0,90,35>, false, 8000 )
}
#endif
