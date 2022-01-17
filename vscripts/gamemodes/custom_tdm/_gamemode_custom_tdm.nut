///////////////////////////////////////////////////////
// ███████ ██       ██████  ██     ██     ███████ ████████  █████  ████████ ███████ 
// ██      ██      ██    ██ ██     ██     ██         ██    ██   ██    ██    ██      
// █████   ██      ██    ██ ██  █  ██     ███████    ██    ███████    ██    █████   
// ██      ██      ██    ██ ██ ███ ██          ██    ██    ██   ██    ██    ██      
// ██      ███████  ██████   ███ ███      ███████    ██    ██   ██    ██    ███████                                                                                 
// By Retículo Endoplasmático#5955
// & michae\l/#1125
// & AyeZee#6969
///////////////////////////////////////////////////////

global function _CustomTDM_Init
global function _RegisterLocation
global function _RegisterLocationPROPHUNT
global function CreateAnimatedLegend
global function Message
string WHITE_SHIELD = "armor_pickup_lv1"
string BLUE_SHIELD = "armor_pickup_lv2"
string PURPLE_SHIELD = "armor_pickup_lv3"
#if SERVER
global function CreateCustomLight
global function CreateEditorProp
global function CreateEditorPropRamps
global function GiveFlowstateOvershield
#endif

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
	string scriptversion = "v2.7"
    int tdmState = eTDMState.IN_PROGRESS
    int nextMapIndex = 0
	bool mapIndexChanged = true
	array<entity> playerSpawnedProps
	array<ItemFlavor> characters
	float lastTimeChatUsage
	float lastKillTimer
	entity lastKiller
	int SameKillerStoredKills=0
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
		
	bool FallTriggersEnabled = false
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


struct{
float endTime = 0
array<LocationSettings> locationSettings
LocationSettings& selectedLocation
int nextMapIndex = 0
bool mapIndexChanged = true
bool cantUseChangeProp = false
bool InProgress = false
} prophunt

const array<asset> prophuntAssetsWE =
[
	$"mdl/industrial/traffic_cone_01.rmdl",
	$"mdl/barriers/concrete/concrete_barrier_01.rmdl",
	$"mdl/eden/eden_electrical_transformer_01.rmdl",
	$"mdl/vehicles_r5/land/msc_truck_samson_v2/veh_land_msc_truck_samson_v2.rmdl",
	$"mdl/rocks/rock_lava_small_moss_desertlands_03.rmdl",
	$"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl",
	$"mdl/angel_city/vending_machine.rmdl",
	$"mdl/utilities/power_gen1.rmdl",
	$"mdl/angel_city/box_small_02.rmdl",
	$"mdl/colony/antenna_05_colony.rmdl",
	$"mdl/robots/marvin/marvin_gladcard.rmdl",
	$"mdl/garbage/garbage_bag_plastic_a.rmdl",
	$"mdl/garbage/trash_bin_single_wtrash_Blue.rmdl",
	$"mdl/angel_city/box_small_01.rmdl",
	$"mdl/garbage/dumpster_dirty_open_a_02.rmdl",
	$"mdl/containers/slumcity_oxygen_tank_red.rmdl",
	$"mdl/containers/box_shrinkwrapped.rmdl",
	$"mdl/colony/farmland_fridge_01.rmdl",
	$"mdl/furniture/chair_beanbag_01.rmdl",
	$"mdl/colony/farmland_crate_plastic_01_red.rmdl",
	$"mdl/IMC_base/generator_IMC_01.rmdl",
	$"mdl/garbage/trash_can_metal_02_b.rmdl",
	$"mdl/garbage/trash_bin_single_wtrash.rmdl"
]

// ██████   █████  ███████ ███████     ███████ ██    ██ ███    ██  ██████ ████████ ██  ██████  ███    ██ ███████
// ██   ██ ██   ██ ██      ██          ██      ██    ██ ████   ██ ██         ██    ██ ██    ██ ████   ██ ██
// ██████  ███████ ███████ █████       █████   ██    ██ ██ ██  ██ ██         ██    ██ ██    ██ ██ ██  ██ ███████
// ██   ██ ██   ██      ██ ██          ██      ██    ██ ██  ██ ██ ██         ██    ██ ██    ██ ██  ██ ██      ██
// ██████  ██   ██ ███████ ███████     ██       ██████  ██   ████  ██████    ██    ██  ██████  ██   ████ ███████



void function _CustomTDM_Init()
{
	SurvivalFreefall_Init()
	file.Hoster = FlowState_Hoster()
	file.admin1 = FlowState_Admin1()
	file.admin2 = FlowState_Admin2()
	file.admin3 = FlowState_Admin3()
	file.admin4 = FlowState_Admin4()
	PrecacheCustomMapsProps()
	AddCallback_OnClientConnected( void function(entity player) { 
	if(!FlowState_PROPHUNT()){
	thread _OnPlayerConnected(player) 
	} else {
	thread _OnPlayerConnectedPROPHUNT(player)	
	}
	})
	AddCallback_OnPlayerKilled(void function(entity victim, entity attacker, var damageInfo) {
	if(!FlowState_PROPHUNT()){
	thread _OnPlayerDied(victim, attacker, damageInfo)
	} else {
	thread _OnPlayerDiedPROPHUNT(victim, attacker, damageInfo)
	}
	})
	
	AddClientCommandCallback("latency", ClientCommand_ShowLatency)
	AddClientCommandCallback("adminsay", ClientCommand_AdminMsg)
	AddClientCommandCallback("commands", ClientCommand_Help)
	if(!FlowState_PROPHUNT()){
	AddClientCommandCallback("scoreboard", ClientCommand_Scoreboard)
	AddClientCommandCallback("spectate", ClientCommand_SpectateEnemies)
	AddClientCommandCallback("teambal", ClientCommand_RebalanceTeams)
	AddClientCommandCallback("circlenow", ClientCommand_CircleNow)
	AddClientCommandCallback("god", ClientCommand_God)
	AddClientCommandCallback("ungod", ClientCommand_UnGod)
	AddClientCommandCallback("next_round", ClientCommand_NextRound)
	} else {
	AddClientCommandCallback("next_round", ClientCommand_NextRoundPROPHUNT)
	AddClientCommandCallback("scoreboard", ClientCommand_ScoreboardPROPHUNT)
	AddClientCommandCallback("prop", ClientCommand_ChangePropPROPHUNT)
	}
	if(FlowState_AllChat()){
		AddClientCommandCallback("say", ClientCommand_ClientMsg)
		//3 slots ingame chat temp-bans. Usage: sayban 1 ColombiaFPS. sayunban 1
		AddClientCommandCallback("sayban", ClientCommand_ChatBan)
		AddClientCommandCallback("sayunban", ClientCommand_ChatUnBan)
	}
	
if(!FlowState_PROPHUNT()){
	if ( FlowState_AdminTgive() ){
	AddClientCommandCallback("admintgive", ClientCommand_GiveWeapon)
	} else {

    if( CMD_GetTGiveEnabled() )
    {
        AddClientCommandCallback("tgive", ClientCommand_GiveWeapon)
    } }
}
	// Whitelisted weapons
    for(int i = 0; GetCurrentPlaylistVarString("whitelisted_weapon_" + i.tostring(), "~~none~~") != "~~none~~"; i++)
    {
        file.whitelistedWeapons.append(GetCurrentPlaylistVarString("whitelisted_weapon_" + i.tostring(), "~~none~~"))
    }

    if(!FlowState_PROPHUNT()){
	thread RunTDM() 
	} else {
	thread RunPROPHUNT()
	}//Go to Game Loop
    }

void function _RegisterLocation(LocationSettings locationSettings)
{
    file.locationSettings.append(locationSettings)
    file.droplocationSettings.append(locationSettings)
}

void function _RegisterLocationPROPHUNT(LocationSettings locationSettings)
{
    prophunt.locationSettings.append(locationSettings)
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
		case "mp_rr_ashs_redemption"://our second custom tdm map. FIRST WAS SKILL TRAINER
            return NewLocPair(<-20917, 5852, -26741>, <0, -90, 0>)
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
			if(FlowState_ForceCharacter()){
				CharSelect(player)}
    GivePassive(player, ePassives.PAS_PILOT_BLOOD)
	string nextlocation = file.selectedLocation.name
			if(FlowState_RandomGunsEverydie())
			{
			Message(player, "WELCOME TO FLOW STATE: FIESTA", helpMessage(), 10)}
			else if (FlowState_Gungame())
			{
			Message(player, "WELCOME TO FLOW STATE: GUNGAME", helpMessage(), 10)

			}
			else { 
			Message(player, "WELCOME TO FLOW STATE: FFA/TDM", helpMessage(), 10)
			}
	switch(GetGameState())
    {
    case eGameState.MapVoting:
	    if(IsValidPlayer(player) )
        {
			    if(!IsAlive(player))
			{
				_HandleRespawn(player)
			if(file.selectedLocation.name != "Surf Purgatory"){
					ClearInvincible(player)
				}
			}
			player.SetThirdPersonShoulderModeOn()
						if(FlowState_RandomGunsEverydie()){
			UpgradeShields(player, true)
			}
						if(FlowState_Gungame()){
				KillStreakAnnouncer(player, true)
			}
			player.UnforceStand()
			player.UnfreezeControlsOnServer()
		}
		break
	case eGameState.WaitingForPlayers:
			if(!IsAlive(player))
		{
			_HandleRespawn(player)
		if(file.selectedLocation.name != "Surf Purgatory"){
				ClearInvincible(player)
			}
		}
        player.UnfreezeControlsOnServer()
        break
    case eGameState.Playing:
	    if(IsValidPlayer(player))
        {
			player.UnfreezeControlsOnServer();
			array<vector> newdropshipspawns = GetNewFFADropShipLocations(file.selectedLocation.name, GetMapName())
			array<vector> shuffledspawnes = shuffleDropShipArray(newdropshipspawns, 50)
			int spawni = RandomIntRange(0, shuffledspawnes.len()-1)
			if(FlowState_RandomGunsEverydie()){
				UpgradeShields(player, true)
			}

			if(FlowState_Gungame()){
				KillStreakAnnouncer(player, true)
			}
	
			if(GetCurrentPlaylistVarBool("flowstateDroppodsOnPlayerConnected", false ) && file.selectedLocation.name != "Surf Purgatory" || GetCurrentPlaylistVarBool("flowstateDroppodsOnPlayerConnected", false ) && file.selectedLocation.name != "Skill trainer By Colombia")
			{
				player.SetPlayerGameStat( PGS_ASSAULT_SCORE, 2) //Using gamestat as bool lmao. 
				thread AirDropFireteam( shuffledspawnes[spawni] + <0,0,15000>, <0,180,0>, "idle", 0, "droppod_fireteam", player )
				_HandleRespawn(player, true)
				player.SetAngles( <0,180,0> )
				printl("player spawning in droppod")
			} else {
			_HandleRespawn(player)				
			}

			if(file.selectedLocation.name != "Surf Purgatory"){
					ClearInvincible(player)
				}

        	Remote_CallFunction_NonReplay(player, "ServerCallback_TDM_DoAnnouncement", 1, eTDMAnnounce.ROUND_START)
			try{
			if(file.locationSettings.name == "Surf Purgatory"){
			TakeAllWeapons( player )
			SetPlayerSettings(player, SURF_SETTINGS)
			MakeInvincible(player)
			player.GiveWeapon( "mp_weapon_semipistol", WEAPON_INVENTORY_SLOT_ANY )
			}else{
			SetPlayerSettings(player, TDM_PLAYER_SETTINGS)
			}
			}catch(e){}
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
	if (FlowState_RandomGunsEverydie())
			{		
	CreateFlowStateDeathBoxForPlayer(victim, attacker, damageInfo)
			}
	
	
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

	if(Time() - file.lastKillTimer < doubleKillTime && attacker == file.lastKiller && attacker == killeader){
	foreach (player in GetPlayerArray())
	{
	thread EmitSoundOnEntityOnlyToPlayer( player, player, "diag_ap_aiNotify_killLeaderDoubleKill" )

	}
	if(FlowState_ChosenCharacter() == 8)
	{
	thread EmitSoundOnEntityOnlyToPlayer( attacker, attacker, "diag_mp_wraith_bc_iDownedMultiple_1p" )
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
			
						if(FlowState_RandomGunsEverydie()){
			UpgradeShields(victim, true)
			}
			
			if(FlowState_Gungame())
			{
			KillStreakAnnouncer(victim, true)
			}
			
			} catch (e) {}

			wait max(0, Deathmatch_GetRespawnDelay() - reservedTime)
			try{
			if(IsValid(victim) )
			{
				int invscore = victim.GetPlayerGameStat( PGS_DEATHS );
				invscore++;
				victim.SetPlayerGameStat( PGS_DEATHS, invscore);
				
				//Add a death to the victim
                int invscore2 = victim.GetPlayerNetInt( "assists" )
				invscore2++;
				victim.SetPlayerNetInt( "assists", invscore2 )

				
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
				
			if(FlowState_KillshotEnabled()){
			DamageInfo_AddCustomDamageType( damageInfo, DF_KILLSHOT )
			thread EmitSoundOnEntityOnlyToPlayer( attacker, attacker, "flesh_bulletimpact_downedshot_1p_vs_3p" )
			}
			if(FlowState_Gungame())
			{
			GiveGungameWeapon(attacker)
			KillStreakAnnouncer(attacker, false)
			}		
			//Autoreload on kill without animation //By CaféDeColombiaFPS
            WpnAutoReloadOnKill(attacker)
            
			int score = GameRules_GetTeamScore(attacker.GetTeam());
            score++;
            GameRules_SetTeamScore(attacker.GetTeam(), score);

			// int invscore = attacker.GetPlayerNetInt( "kills" )
			// invscore++;
			// attacker.SetPlayerNetInt( "kills", invscore )
			
			//Heal
				if(FlowState_RandomGunsEverydie()){
			PlayerRestoreHPFIESTA(attacker, 100)
			UpgradeShields(attacker, false)
			} else {
			PlayerRestoreHP(attacker, 100, Equipment_GetDefaultShieldHP())
			}
			}
			} catch (e) {}
        }
		thread victimHandleFunc()
        thread attackerHandleFunc()
        foreach(player in GetPlayerArray()){
		try {Remote_CallFunction_NonReplay(player, "ServerCallback_TDM_PlayerKilled")}
    catch(exception){;}}
        break
    default:
    }

file.lastKillTimer = Time()
file.lastKiller = attacker
}


void function _HandleRespawn(entity player, bool isDroppodSpawn = false)
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
	
	if(IsValid( player ) && file.selectedLocation.name == "Surf Purgatory" && file.surfEnded == false)
    {

            if(!player.p.storedWeapons.len())
            {
				DecideRespawnPlayer(player, true)
				if(FlowState_ForceCharacter()){
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

    }else if(IsValid( player ) && !IsAlive(player))
    {
        if(Equipment_GetRespawnKitEnabled() && !FlowState_Gungame())
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
	if(!isDroppodSpawn){
	TpPlayerToSpawnPoint(player)}
	
    if(file.selectedLocation.name == "Surf Purgatory"){
	SetPlayerSettings(player, SURF_SETTINGS)
	}
	else {
	SetPlayerSettings(player, TDM_PLAYER_SETTINGS)
	}
	
	if(FlowState_RandomGunsEverydie()){
			PlayerRestoreShieldsFIESTA(player, player.GetShieldHealthMax())
			PlayerRestoreHPFIESTA(player, 100)
			} else {
    PlayerRestoreHP(player, 100, Equipment_GetDefaultShieldHP())
			}

		}
		} catch (e1) {}
	if (FlowState_RandomGuns() && !FlowState_Gungame())
    {
        TakeAllWeapons(player)
        GiveRandomPrimaryWeapon(file.randomprimary, player)
        GiveRandomSecondaryWeapon(file.randomsecondary, player)
        player.GiveWeapon( "mp_weapon_melee_survival", WEAPON_INVENTORY_SLOT_PRIMARY_2, [] )
        player.GiveOffhandWeapon( "melee_data_knife", OFFHAND_MELEE, [] )
    } else if(FlowState_RandomGunsMetagame() && !FlowState_Gungame())
	{
		TakeAllWeapons(player)
        GiveRandomPrimaryWeaponMetagame(file.randomprimary, player)
        GiveRandomSecondaryWeaponMetagame(file.randomsecondary, player)
        player.GiveWeapon( "mp_weapon_melee_survival", WEAPON_INVENTORY_SLOT_PRIMARY_2, [] )
        player.GiveOffhandWeapon( "melee_data_knife", OFFHAND_MELEE, [] )
	}
	if(FlowState_RandomTactical() || FlowState_GungameRandomAbilities())
	{
		player.TakeOffhandWeapon(OFFHAND_TACTICAL)
		file.randomtac = RandomIntRangeInclusive( 0, 7 )
        GiveRandomTac(file.randomtac, player)
	}
	if(FlowState_RandomUltimate() || FlowState_GungameRandomAbilities())
	{
    player.TakeOffhandWeapon(OFFHAND_ULTIMATE)
		file.randomult = RandomIntRangeInclusive( 0, 5 )
        GiveRandomUlt(file.randomult, player)
	}
	if(FlowState_RandomGunsEverydie() && !FlowState_Gungame()) //fiesta
    {
        file.randomprimary = RandomIntRangeInclusive( 0, 23 )
        file.randomsecondary = RandomIntRangeInclusive( 0, 18 )
        file.randomtac = RandomIntRangeInclusive( 0, 7 )
        file.randomult = RandomIntRangeInclusive( 0, 5 )
		TakeAllWeapons(player)
        GiveRandomPrimaryWeapon(file.randomprimary, player)
        GiveRandomSecondaryWeapon(file.randomsecondary, player)
        GiveRandomTac(file.randomtac, player)
        GiveRandomUlt(file.randomult, player)
        player.GiveWeapon( "mp_weapon_melee_survival", WEAPON_INVENTORY_SLOT_PRIMARY_2, [] )
        player.GiveOffhandWeapon( "melee_data_knife", OFFHAND_MELEE, [] )
    } 
	if(FlowState_Gungame())
	{
		GiveGungameWeapon(player)
		entity w1 = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 )
		entity w2 = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_1 )
		try {w1.SetWeaponPrimaryClipCount(w1.GetWeaponPrimaryClipCountMax())} catch(this_is_a_unique_string_dont_crash_u_bitch){}
		try {w2.SetWeaponPrimaryClipCount(w2.GetWeaponPrimaryClipCountMax())} catch(this_is_a_unique_string_dont_crash_u_bitch2){}
	}

	WpnPulloutOnRespawn(player)
}


void function PROPHUNT_GiveRandomProp(entity player)
///////////////////////////////////////////////////////
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
///////////////////////////////////////////////////////
{
    if (GetMapName() == "mp_rr_desertlands_64k_x_64k" || GetMapName() == "mp_rr_desertlands_64k_x_64k_nx")
	{
	asset selectedModel = prophuntAssetsWE[RandomIntRangeInclusive(0,(prophuntAssetsWE.len()-1))]
	player.SetBodyModelOverride( selectedModel )
	player.SetArmsModelOverride( selectedModel )
	}
}

void function _OnPlayerConnectedPROPHUNT(entity player)
///////////////////////////////////////////////////////
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
///////////////////////////////////////////////////////
{
	UpdatePlayerCounts()
    if(!IsValid(player)) return
    GivePassive(player, ePassives.PAS_PILOT_BLOOD)
	array<entity> IMCplayers = GetPlayerArrayOfTeam(TEAM_IMC)
	array<entity> MILITIAplayers = GetPlayerArrayOfTeam(TEAM_MILITIA)
	array<entity> playersON = GetPlayerArray_Alive()

	switch(GetGameState())
    {
		case eGameState.WaitingForPlayers:
					if(IsValidPlayer(player))
			{
						
				//player has a team assigned already, we need to fix it before spawn
				if (IMCplayers.len() == 0)
				{
				player.Code_SetTeam( TEAM_IMC )
				}	
				if (IMCplayers.len() == 1)
				{
				player.Code_SetTeam( TEAM_MILITIA )
				}	

				if(GetCurrentPlaylistVarBool("flowstatePROPHUNTDebug", false )){
				player.Code_SetTeam( TEAM_MILITIA )	
				}			
			
						if(FlowState_ForceCharacter()){CharSelect(player)}
				ItemFlavor playerCharacter = LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_CharacterClass() )
				asset characterSetFile = CharacterClass_GetSetFile( playerCharacter )
				player.SetPlayerSettingsWithMods( characterSetFile, [] )
				SetPlayerSettings(player, PROPHUNT_SETTINGS)
				DoRespawnPlayer( player, null )
				Survival_SetInventoryEnabled( player, true )
				player.SetPlayerNetInt( "respawnStatus", eRespawnStatus.NONE )
				player.SetPlayerNetBool( "pingEnabled", true )
				player.SetHealth( 100 )
								if (GetMapName() == "mp_rr_desertlands_64k_x_64k" || GetMapName() == "mp_rr_desertlands_64k_x_64k_nx")
					{
					player.SetOrigin(<-19459, 2127, 6404>)}
				else if(GetMapName() == "mp_rr_canyonlands_mu1" || GetMapName() == "mp_rr_canyonlands_mu1_night" || GetMapName() == "mp_rr_canyonlands_64k_x_64k")
					{
					player.SetOrigin(<-19459, 2127, 18404>)}
				player.kv.solid = 6
				player.kv.CollisionGroup = TRACE_COLLISION_GROUP_PLAYER
				player.AllowMantle()
				player.SetThirdPersonShoulderModeOn()
				player.UnforceStand()
				player.UnfreezeControlsOnServer()
				
			}
			break
		case eGameState.MapVoting:
					if(IsValidPlayer(player))
			{
								//player has a team assigned already, we need to fix it before spawn
				if (IMCplayers.len() == 0)
				{
				player.Code_SetTeam( TEAM_IMC )
				}	
				if (IMCplayers.len() == 1)
				{
				player.Code_SetTeam( TEAM_MILITIA )
				}	

				if(GetCurrentPlaylistVarBool("flowstatePROPHUNTDebug", false )){
				player.Code_SetTeam( TEAM_MILITIA )	
				}
				
				if(FlowState_ForceCharacter()){CharSelect(player)}
				ItemFlavor playerCharacter = LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_CharacterClass() )
				asset characterSetFile = CharacterClass_GetSetFile( playerCharacter )
				player.SetPlayerSettingsWithMods( characterSetFile, [] )
				SetPlayerSettings(player, PROPHUNT_SETTINGS)
				DoRespawnPlayer( player, null )
				Survival_SetInventoryEnabled( player, true )
				player.SetPlayerNetInt( "respawnStatus", eRespawnStatus.NONE )
				player.SetPlayerNetBool( "pingEnabled", true )
				player.SetHealth( 100 )
								if (GetMapName() == "mp_rr_desertlands_64k_x_64k" || GetMapName() == "mp_rr_desertlands_64k_x_64k_nx")
					{
					player.SetOrigin(<-19459, 2127, 6404>)}
				else if(GetMapName() == "mp_rr_canyonlands_mu1" || GetMapName() == "mp_rr_canyonlands_mu1_night" || GetMapName() == "mp_rr_canyonlands_64k_x_64k")
					{
					player.SetOrigin(<-19459, 2127, 18404>)}
				player.kv.solid = 6
				player.kv.CollisionGroup = TRACE_COLLISION_GROUP_PLAYER
				player.AllowMantle()	
				player.SetThirdPersonShoulderModeOn()
				player.UnforceStand()
				player.UnfreezeControlsOnServer()
			}
			break
		case eGameState.Playing: //wait round ends, set new player to spectate random player
			if(IsValidPlayer(player))
			{
				array<LocPair> prophuntSpawns = prophunt.selectedLocation.spawns
				try{
					if(FlowState_ForceCharacter()){CharSelect(player)}
				ItemFlavor playerCharacter = LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_CharacterClass() )
				asset characterSetFile = CharacterClass_GetSetFile( playerCharacter )
				player.SetPlayerSettingsWithMods( characterSetFile, [] )
				SetPlayerSettings(player, PROPHUNT_SETTINGS)
				DoRespawnPlayer( player, null )
				Survival_SetInventoryEnabled( player, true )
				player.SetPlayerNetInt( "respawnStatus", eRespawnStatus.NONE )
				player.SetPlayerNetBool( "pingEnabled", true )
				player.SetHealth( 100 )
				player.SetOrigin(prophuntSpawns[RandomInt(4)].origin)
				player.kv.solid = 6
				player.kv.CollisionGroup = TRACE_COLLISION_GROUP_PLAYER
				player.AllowMantle()
				Message(player, "APEX PROPHUNT", "Game is in progress. You'll spawn in the next round. \n ", 10)
				player.Code_SetTeam( 20 )
				player.SetObserverTarget( playersON[RandomInt(playersON.len()-1)] )
				player.SetSpecReplayDelay( 2 )
                player.StartObserverMode( OBS_MODE_IN_EYE )
				Remote_CallFunction_NonReplay(player, "ServerCallback_KillReplayHud_Activate")
				player.MakeInvisible()
				}catch(e){}
			}
			break
		default:
			break
	}
}

void function _OnPlayerDiedPROPHUNT(entity victim, entity attacker, var damageInfo)
///////////////////////////////////////////////////////
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
///////////////////////////////////////////////////////
{

	file.deathPlayersCounter++
	array<entity> playersON = GetPlayerArray_Alive()
	
	if(file.deathPlayersCounter == 1 && playersON.len() > 2)
	{
	foreach (player in GetPlayerArray())
	{
	thread EmitSoundOnEntityExceptToPlayer( player, player, "diag_ap_aiNotify_diedFirst" )
	}
	}

	switch(GetGameState())
    {
    case eGameState.Playing:
        // Víctima
        void functionref() victimHandleFunc = void function() : (victim, attacker, damageInfo) {

			if(!IsValid(victim)) return
			try{
			wait 1
			if(IsValid(victim))
            {
                victim.SetObserverTarget( attacker )
				victim.SetSpecReplayDelay( 2 )
                victim.StartObserverMode( OBS_MODE_IN_EYE )
				Remote_CallFunction_NonReplay(victim, "ServerCallback_KillReplayHud_Activate")
            }
			
				int invscore = victim.GetPlayerGameStat( PGS_DEATHS );
				invscore++;
				victim.SetPlayerGameStat( PGS_DEATHS, invscore);
				//Add a death to the victim
                int invscore2 = victim.GetPlayerNetInt( "assists" )
				invscore2++;
				victim.SetPlayerNetInt( "assists", invscore2 )
			} catch (e) {}
		
		}

        // Atacante
        void functionref() attackerHandleFunc = void function() : (victim, attacker, damageInfo)
		{
            try{
			if(IsValid(attacker) && attacker.IsPlayer() && IsAlive(attacker) && attacker != victim)
            {
			DamageInfo_AddCustomDamageType( damageInfo, DF_KILLSHOT )
			thread EmitSoundOnEntityOnlyToPlayer( attacker, attacker, "flesh_bulletimpact_downedshot_1p_vs_3p" )		
			//Autoreload on kill without animation //By CaféDeColombiaFPS
            WpnAutoReloadOnKill(attacker)
			int score = GameRules_GetTeamScore(TEAM_IMC);
            score++;
            GameRules_SetTeamScore(TEAM_IMC, score);
			}
			array<entity> teamMILITIAplayersalive = GetPlayerArrayOfTeam_Alive( TEAM_MILITIA )
			if ( teamMILITIAplayersalive.len() == 0 )
			{
				file.tdmState = eTDMState.NEXT_ROUND_NOW
				SetGameState(eGameState.MapVoting)				
			}
			} catch (e) {}
		}
thread victimHandleFunc()
thread attackerHandleFunc()
        break
    default:
		break
    }
}

void function _HandleRespawnPROPHUNT(entity player)
///////////////////////////////////////////////////////
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
///////////////////////////////////////////////////////
{
	if(!IsValid(player)) return
	if( player.IsObserver())
    {
		player.StopObserverMode()
        Remote_CallFunction_NonReplay(player, "ServerCallback_KillReplayHud_Deactivate")
    }
	try {
	
	if(IsValid( player ))
			{
				if(FlowState_ForceCharacter()){CharSelect(player)}
				if(!IsAlive(player)) {DoRespawnPlayer( player, null )}
				
				if (GetMapName() == "mp_rr_desertlands_64k_x_64k" || GetMapName() == "mp_rr_desertlands_64k_x_64k_nx")
					{
					player.SetOrigin(<-19459, 2127, 6404>)}
				else if(GetMapName() == "mp_rr_canyonlands_mu1" || GetMapName() == "mp_rr_canyonlands_mu1_night" || GetMapName() == "mp_rr_canyonlands_64k_x_64k")
					{
					player.SetOrigin(<-19459, 2127, 18404>)}
				player.SetThirdPersonShoulderModeOn()
				Survival_SetInventoryEnabled( player, true )
				player.SetPlayerNetInt( "respawnStatus", eRespawnStatus.NONE )
				player.SetPlayerNetBool( "pingEnabled", true )
				player.SetHealth( 100 )
			}

	} catch (e) {}
	
}

void function RunPROPHUNT()
///////////////////////////////////////////////////////
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
///////////////////////////////////////////////////////
{
    WaitForGameState(eGameState.Playing)
    AddSpawnCallback("prop_dynamic", _OnPropDynamicSpawned)
    for(; ;)
    {
	ActualPROPHUNTLobby()
	ActualPROPHUNTGameLoop()
	}
    WaitForever()
}

void function ActualPROPHUNTLobby()
///////////////////////////////////////////////////////
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
///////////////////////////////////////////////////////
{
	SetGameState(eGameState.MapVoting)
	file.FallTriggersEnabled = true
	if(GetMapName() == "mp_rr_desertlands_64k_x_64k" || GetMapName() == "mp_rr_desertlands_64k_x_64k_nx" || GetMapName() == "mp_rr_canyonlands_mu1" || GetMapName() == "mp_rr_canyonlands_mu1_night" || GetMapName() == "mp_rr_canyonlands_64k_x_64k")
	{
		thread CreateShipRoomFallTriggers()
	}
if (FlowState_LockPOI()) {
	prophunt.nextMapIndex = FlowState_LockedPOI()
}else if (!prophunt.mapIndexChanged)
	{
	prophunt.nextMapIndex = (prophunt.nextMapIndex + 1 ) % prophunt.locationSettings.len()
	}
	
int choice = prophunt.nextMapIndex
prophunt.mapIndexChanged = false
prophunt.selectedLocation = prophunt.locationSettings[choice]
	
	
if(prophunt.selectedLocation.name == "Skill trainer By Colombia"){
    DestroyPlayerProps()
    wait 2
    SkillTrainerLoad()
} else {
	DestroyPlayerProps()
}

	foreach(player in GetPlayerArray())
	{
		try {
			if(IsValid(player))
			{
				player.UnforceStand()
				player.UnfreezeControlsOnServer()
				Message(player, "APEX PROPHUNT", "    Made by Colombia. Game is starting. \n\n" + helpMessagePROPHUNT(), 10)
			}
		}catch(e){}
	}
	wait 10

if(!GetCurrentPlaylistVarBool("flowstatePROPHUNTDebug", false )){
	while(true)
	{
		array<entity> playersON = GetPlayerArray_Alive()
		if(playersON.len() == 1 || playersON.len() == 0)
		{
			wait 15
			foreach(player in GetPlayerArray())
			{
				Message(player, "APEX PROPHUNT", "Waiting another player to start.", 5)
			}	
		} else {
						foreach(player in GetPlayerArray())
			{
			Message(player, "APEX PROPHUNT", "We have enough players, starting now.", 5, "diag_ap_aiNotify_circleMoves10sec")
			}
			wait 5
			break 
		}
		wait 1
	}
}
array<entity> IMCplayers = GetPlayerArrayOfTeam(TEAM_IMC)
array<entity> MILITIAplayers = GetPlayerArrayOfTeam(TEAM_MILITIA)
	foreach(player in MILITIAplayers)
	{
		try {
		Message(player, "ATTENTION", "You're a prop. Teleporting in 5 seconds!", 5)
		}catch(e){}
	}
wait 5
WaitFrame()
}

void function EmitSoundOnSprintingProp()
///////////////////////////////////////////////////////
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
///////////////////////////////////////////////////////
{
		while(prophunt.InProgress)
		{
		array<entity> MILITIAplayers = GetPlayerArrayOfTeam(TEAM_MILITIA)
			foreach(player in MILITIAplayers)
			{
				if(player.IsSprinting())
				{
				EmitSoundOnEntity( player, "husaria_sprint_default_3p" )
				} 
			}
		wait 0.2
		}
}

void function ActualPROPHUNTGameLoop()
///////////////////////////////////////////////////////
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
///////////////////////////////////////////////////////
{
entity bubbleBoundary = CreateBubbleBoundaryPROPHUNT(prophunt.selectedLocation)
file.tdmState = eTDMState.IN_PROGRESS
prophunt.InProgress = true
thread EmitSoundOnSprintingProp()
SetGameState(eGameState.Playing)

float endTime = Time() + GetCurrentPlaylistVarFloat("flowstatePROPHUNTLimitTime", 300 )
	array<entity> IMCplayers = GetPlayerArrayOfTeam(TEAM_IMC)
	array<entity> MILITIAplayers = GetPlayerArrayOfTeam(TEAM_MILITIA)

array<LocPair> prophuntSpawns = prophunt.selectedLocation.spawns

//this is for debuggin, so I can changelevel and still have enemy(two instances of the game)
if (IMCplayers.len() == 2 && MILITIAplayers.len() == 0 && GetCurrentPlaylistVarBool("flowstatePROPHUNTDebug", false ))
{
entity playerNewTeam = IMCplayers[0]
playerNewTeam.Code_SetTeam( TEAM_MILITIA )
} else if (IMCplayers.len() == 0 && MILITIAplayers.len() == 2 && GetCurrentPlaylistVarBool("flowstatePROPHUNTDebug", false ))
{
entity playerNewTeam = MILITIAplayers[0]
playerNewTeam.Code_SetTeam( TEAM_IMC )	
}

		file.deathPlayersCounter = 0
		prophunt.cantUseChangeProp = false
foreach(player in GetPlayerArray())
    {
        if(IsValidPlayer(player))
        {
			Inventory_SetPlayerEquipment(player, WHITE_SHIELD, "armor")
			ClearInvincible(player)
			player.SetPlayerGameStat( PGS_ASSAULT_SCORE, 0)
			player.p.playerDamageDealt = 0.0
			if(player.GetTeam() == TEAM_MILITIA){
			player.SetOrigin(prophuntSpawns[RandomInt(prophuntSpawns.len()-1)].origin)
			player.SetAngles( <0,90,0> )
			PROPHUNT_GiveRandomProp(player)
			player.kv.solid = 6
			player.kv.CollisionGroup = TRACE_COLLISION_GROUP_PLAYER
			player.SetThirdPersonShoulderModeOn()
			player.TakeOffhandWeapon(OFFHAND_TACTICAL)
			player.GiveOffhandWeapon("mp_ability_heal", OFFHAND_TACTICAL)
			} else if(player.GetTeam() == TEAM_IMC){
			Message(player, "PROPS ARE HIDING", "Teleporting in 30 seconds.", 10)}
		}
	}
wait 25
foreach(player in GetPlayerArray())
    {
if(player.GetTeam() == TEAM_IMC){
ScreenFade( player, 0, 0, 0, 255, 4.0, 4.0, FFADE_OUT | FFADE_PURGE )}
	}
wait 4
file.FallTriggersEnabled = false
foreach(player in GetPlayerArray())
    {
        if(IsValidPlayer(player))
        {
		if (player.GetTeam() == TEAM_MILITIA){
			Message(player, "ATTENTION", "The attackers have arrived.", 10) }
			else if (player.GetTeam() == TEAM_IMC){
			array<entity> MILITIAplayersAlive = GetPlayerArrayOfTeam_Alive(TEAM_MILITIA)
			Message(player, "ATTENTION", "Kill the props. Props alive: " + MILITIAplayersAlive.len(), 10)
			}				
		}
		
	}
prophunt.cantUseChangeProp = true
foreach(player in GetPlayerArray())
    {
		        if(IsValidPlayer(player))
        {
if(player.GetTeam() == TEAM_IMC){
					Inventory_SetPlayerEquipment(player, WHITE_SHIELD, "armor")
					ClearInvincible(player)
					player.SetOrigin(prophuntSpawns[RandomInt(4)].origin)
					player.kv.solid = 6
					player.kv.CollisionGroup = TRACE_COLLISION_GROUP_PLAYER
					player.SetThirdPersonShoulderModeOff()
					string sec = GetCurrentPlaylistVarString("flowstatePROPHUNTweapon", "~~none~~")
					player.TakeNormalWeaponByIndexNow( WEAPON_INVENTORY_SLOT_PRIMARY_0 )
					player.TakeOffhandWeapon(OFFHAND_TACTICAL)
					player.GiveWeapon( sec, WEAPON_INVENTORY_SLOT_PRIMARY_0, [] )
					player.GiveOffhandWeapon("mp_ability_heal", OFFHAND_TACTICAL)
					//if a player punch a prop, they will crash. This is a workaround. Colombia
					//player.GiveWeapon( "mp_weapon_melee_survival", WEAPON_INVENTORY_SLOT_PRIMARY_2, [] )
					//player.GiveOffhandWeapon( "melee_data_knife", OFFHAND_MELEE, [] )
					DeployAndEnableWeapons(player)
			}
	}
	}

while( Time() <= endTime )
	{
		if(Time() == endTime-120)
		{
			foreach(player in GetPlayerArray())
			{
				if(IsValid(player))
				{
					array<entity> MILITIAplayersAlive = GetPlayerArrayOfTeam_Alive(TEAM_MILITIA)
					Message(player,"2 MINUTES REMAINING!", "Props alive: " + MILITIAplayersAlive.len(), 5)
				}
			}
		}
		if(Time() == endTime-60)
		{
			foreach(player in GetPlayerArray())
			{
				if(IsValid(player))
				{
					array<entity> MILITIAplayersAlive = GetPlayerArrayOfTeam_Alive(TEAM_MILITIA)
					Message(player,"1 MINUTE REMAINING!", "Props alive: " + MILITIAplayersAlive.len(), 5, "diag_ap_aiNotify_circleMoves60sec")
				}
			}
		}
		if(Time() == endTime-30)
		{
			foreach(player in GetPlayerArray())
			{
				if(IsValid(player))
				{
					array<entity> MILITIAplayersAlive = GetPlayerArrayOfTeam_Alive(TEAM_MILITIA)
					Message(player,"30 SECONDS REMAINING!", "Props alive: " + MILITIAplayersAlive.len(), 5, "diag_ap_aiNotify_circleMoves30sec")
				}
			}
		}
		if(Time() == endTime-10)
		{
			foreach(player in GetPlayerArray())
			{
				if(IsValid(player))
				{
					array<entity> MILITIAplayersAlive = GetPlayerArrayOfTeam_Alive(TEAM_MILITIA)
					Message(player,"10 SECONDS REMAINING!",  "Props alive: " + MILITIAplayersAlive.len(), 5, "diag_ap_aiNotify_circleMoves10sec")
				}
			}
		}
		if(file.tdmState == eTDMState.NEXT_ROUND_NOW)
		{break}
		wait 0.01
		WaitFrame()	
	}

array<entity> MILITIAplayersAlive = GetPlayerArrayOfTeam_Alive(TEAM_MILITIA)	
if(MILITIAplayersAlive.len() > 0){
foreach(player in GetPlayerArray())
    {
		Message(player, "PROPS TEAM WIN", "Props alive: " + MILITIAplayersAlive.len(), 5)
		player.SetThirdPersonShoulderModeOn()		
	}
} else {
foreach(player in GetPlayerArray())
    {
		Message(player, "ATTACKERS TEAM WIN", "All props are dead. ", 5)
		player.SetThirdPersonShoulderModeOn()		
	}	
}
wait 5
foreach(player in GetPlayerArray())
    {
		Message(player, "SWAPPING TEAMS", "Next round is starting.", 5)
		}
wait 5
UpdatePlayerCounts()
bubbleBoundary.Destroy()
prophunt.InProgress = false
foreach(player in GetPlayerArray())
    {	
		TakeAllWeapons(player)
		player.SetThirdPersonShoulderModeOn()
		if(player.GetTeam() == TEAM_IMC){
				player.Code_SetTeam( TEAM_MILITIA )
				_HandleRespawnPROPHUNT(player)
		} else if(player.GetTeam() == TEAM_MILITIA){
				player.Code_SetTeam( TEAM_IMC )	
				_HandleRespawnPROPHUNT(player)
		} else {
			player.StopObserverMode()
			Remote_CallFunction_NonReplay(player, "ServerCallback_KillReplayHud_Deactivate")
			player.MakeVisible()
			player.UnforceStand()
			player.UnfreezeControlsOnServer()
			GiveTeamToSpectator(player) //give team to player connected midgame
			_HandleRespawnPROPHUNT(player)
		}
}
WaitFrame()
}

void function GiveTeamToSpectator(entity player)
///////////////////////////////////////////////////////
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
///////////////////////////////////////////////////////
{
	array<entity> IMCplayers = GetPlayerArrayOfTeam(TEAM_IMC)
	array<entity> MILITIAplayers = GetPlayerArrayOfTeam(TEAM_MILITIA)

	if(IMCplayers.len() > MILITIAplayers.len())
	{
	player.Code_SetTeam( TEAM_MILITIA )
	} else if (MILITIAplayers.len() > IMCplayers.len())
	{
	player.Code_SetTeam( TEAM_IMC )	
	} else {
		switch(RandomIntRangeInclusive(0,1))
		{
			case 0:
				player.Code_SetTeam( TEAM_IMC )
				break;
			case 1:
				player.Code_SetTeam( TEAM_MILITIA )
				break;
		}
	}
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
	wait 0.7
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
    }
}

void function GiveRandomSecondaryWeaponMetagame(int random, entity player)
{
    switch(random)
    {
        case 0:
            player.GiveWeapon( "mp_weapon_wingman", WEAPON_INVENTORY_SLOT_PRIMARY_1, ["optic_cq_hcog_classic", "highcal_mag_l2"] )
            break;
        case 1:
            player.GiveWeapon( "mp_weapon_energy_shotgun", WEAPON_INVENTORY_SLOT_PRIMARY_1, ["shotgun_bolt_l2"] )
            break;
        case 2:
            player.GiveWeapon( "mp_weapon_shotgun", WEAPON_INVENTORY_SLOT_PRIMARY_1, ["shotgun_bolt_l2"] )
            break;
        case 3:
            player.GiveWeapon( "mp_weapon_mastiff", WEAPON_INVENTORY_SLOT_PRIMARY_1)
            break;
		case 4:
            player.GiveWeapon( "mp_weapon_wingman", WEAPON_INVENTORY_SLOT_PRIMARY_1, ["optic_cq_hcog_classic", "highcal_mag_l1"] )
            break;
    }
}

void function GiveRandomPrimaryWeapon(int random, entity player)
{
    switch(random)
    {
        case 0:
            player.GiveWeapon( "mp_weapon_r97", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_classic", "barrel_stabilizer_l4_flash_hider", "stock_tactical_l3", "bullets_mag_l2"] )
            break;
        case 1:
            player.GiveWeapon( "mp_weapon_rspn101", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_bruiser", "barrel_stabilizer_l4_flash_hider", "stock_tactical_l3", "bullets_mag_l2"] )
            break;
        case 2:
            player.GiveWeapon( "mp_weapon_vinson", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_bruiser", "stock_tactical_l3", "highcal_mag_l3"] )
            break;
        case 3:
            player.GiveWeapon( "mp_weapon_hemlok", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_bruiser", "stock_tactical_l3", "highcal_mag_l3", "barrel_stabilizer_l4_flash_hider"] )
            break;
        case 4:
            player.GiveWeapon( "mp_weapon_pdw", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_classic", "stock_tactical_l3", "highcal_mag_l3"] )
            break;
		case 5:
			player.GiveWeapon( "mp_weapon_lmg", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_bruiser", "highcal_mag_l3", "barrel_stabilizer_l3", "stock_tactical_l3" ] )
            break; 
		case 6:
            player.GiveWeapon( "mp_weapon_rspn101", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_classic", "stock_tactical_l1", "bullets_mag_l2"] )
            break;
		case 7:
            player.GiveWeapon( "mp_weapon_energy_ar", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_bruiser", "energy_mag_l3", "stock_tactical_l3", "hopup_turbocharger"] )
            break;
		case 8:
            player.GiveWeapon( "mp_weapon_alternator_smg", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_classic", "bullets_mag_l3", "stock_tactical_l3"] )
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
            player.GiveWeapon( "mp_weapon_vinson", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["stock_tactical_l1", "highcal_mag_l2"] )
            break;
		case 14:
            player.GiveWeapon( "mp_weapon_r97", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_threat", "bullets_mag_l1", "barrel_stabilizer_l3", "stock_tactical_l1"] )
            break;
		case 15:
            player.GiveWeapon( "mp_weapon_dmr", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_bruiser", "highcal_mag_l2", "barrel_stabilizer_l2", "stock_sniper_l3"] )
            break;
		case 16:
            player.GiveWeapon( "mp_weapon_pdw", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["stock_tactical_l1", "highcal_mag_l1"] )
            break;
		case 17:
            player.GiveWeapon( "mp_weapon_esaw", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_classic", "energy_mag_l1", "barrel_stabilizer_l4_flash_hider"] )
            break;
		case 18:
            player.GiveWeapon( "mp_weapon_alternator_smg", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_classic", "barrel_stabilizer_l2"] )
            break;
		case 19:
            player.GiveWeapon( "mp_weapon_sniper", WEAPON_INVENTORY_SLOT_PRIMARY_0)
            break;
		case 20:
            player.GiveWeapon( "mp_weapon_esaw", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_holosight_variable"])
            break;
		case 21:
            player.GiveWeapon( "mp_weapon_rspn101", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_holosight_variable"])
            break;
		case 22:
            player.GiveWeapon( "mp_weapon_vinson", WEAPON_INVENTORY_SLOT_PRIMARY_0)
            break;
		case 23:
            player.GiveWeapon( "mp_weapon_r97", WEAPON_INVENTORY_SLOT_PRIMARY_0 )
            break;

    }
}

void function GiveRandomSecondaryWeapon(int random, entity player)
{
    switch(random)
    {
        case 0:
            player.GiveWeapon( "mp_weapon_wingman", WEAPON_INVENTORY_SLOT_PRIMARY_1, ["optic_cq_hcog_classic", "highcal_mag_l1"] )
            break;
        case 1:
            player.GiveWeapon( "mp_weapon_energy_shotgun", WEAPON_INVENTORY_SLOT_PRIMARY_1, ["shotgun_bolt_l1"] )
            break;
        case 2:
            player.GiveWeapon( "mp_weapon_shotgun", WEAPON_INVENTORY_SLOT_PRIMARY_1, ["shotgun_bolt_l1"] )
            break;
        case 3:
            player.GiveWeapon( "mp_weapon_mastiff", WEAPON_INVENTORY_SLOT_PRIMARY_1)
            break;
		case 4:
            player.GiveWeapon( "mp_weapon_autopistol", WEAPON_INVENTORY_SLOT_PRIMARY_1, ["optic_cq_hcog_classic", "bullets_mag_l1"] )
            break;
		case 5:
            player.GiveWeapon( "mp_weapon_shotgun_pistol", WEAPON_INVENTORY_SLOT_PRIMARY_1, ["shotgun_bolt_l3"] )
            break;
		case 6:
            player.GiveWeapon( "mp_weapon_defender", WEAPON_INVENTORY_SLOT_PRIMARY_1, ["optic_ranged_hcog", "stock_sniper_l2"] )
            break;
		case 7:
            player.GiveWeapon( "mp_weapon_wingman", WEAPON_INVENTORY_SLOT_PRIMARY_1)
            break;
        case 8:
            player.GiveWeapon( "mp_weapon_energy_shotgun", WEAPON_INVENTORY_SLOT_PRIMARY_1)
            break;
        case 9:
            player.GiveWeapon( "mp_weapon_shotgun", WEAPON_INVENTORY_SLOT_PRIMARY_1)
            break;
        case 10:
            player.GiveWeapon( "mp_weapon_mastiff", WEAPON_INVENTORY_SLOT_PRIMARY_1)
            break;
		case 11:
            player.GiveWeapon( "mp_weapon_autopistol", WEAPON_INVENTORY_SLOT_PRIMARY_1)
            break;
		case 12:
            player.GiveWeapon( "mp_weapon_shotgun_pistol", WEAPON_INVENTORY_SLOT_PRIMARY_1)
            break;
		case 13:
            player.GiveWeapon( "mp_weapon_defender", WEAPON_INVENTORY_SLOT_PRIMARY_1, ["optic_sniper", "stock_sniper_l2"] )
            break;
		case 14:
            player.GiveWeapon( "mp_weapon_doubletake", WEAPON_INVENTORY_SLOT_PRIMARY_1, ["energy_mag_l3"] )
            break;
		case 15:
            player.GiveWeapon( "mp_weapon_g2", WEAPON_INVENTORY_SLOT_PRIMARY_1, ["bullets_mag_l3", "barrel_stabilizer_l4_flash_hider", "stock_sniper_l3", "hopup_double_tap"] )
            break;
		case 16:
            player.GiveWeapon( "mp_weapon_g2", WEAPON_INVENTORY_SLOT_PRIMARY_1)
            break;
		case 17:
            player.GiveWeapon( "mp_weapon_semipistol", WEAPON_INVENTORY_SLOT_PRIMARY_1, ["bullets_mag_l2"] )
            break;
		case 18:
            player.GiveWeapon( "mp_weapon_semipistol", WEAPON_INVENTORY_SLOT_PRIMARY_1)
            break;
    }
}

void function GiveActualGungameWeapon(int index, entity player)
{
    switch(index)
    {
        case 0:
            player.GiveWeapon( "mp_weapon_r97", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_classic", "barrel_stabilizer_l4_flash_hider", "stock_tactical_l3", "bullets_mag_l2"] )
            break;
        case 1:
            player.GiveWeapon( "mp_weapon_wingman", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_classic", "highcal_mag_l1"] )
            break;
        case 2:
            player.GiveWeapon( "mp_weapon_rspn101", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_bruiser", "barrel_stabilizer_l4_flash_hider", "stock_tactical_l3", "bullets_mag_l2"] )
            break;
		case 3:
            player.GiveWeapon( "mp_weapon_energy_shotgun", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["shotgun_bolt_l1"] )
            break;
        case 4:
            player.GiveWeapon( "mp_weapon_vinson", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_bruiser", "stock_tactical_l3", "highcal_mag_l3"] )
            break;
        case 5:
            player.GiveWeapon( "mp_weapon_shotgun", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["shotgun_bolt_l1"] )
            break;
        case 6:
            player.GiveWeapon( "mp_weapon_hemlok", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_bruiser", "stock_tactical_l3", "highcal_mag_l3", "barrel_stabilizer_l4_flash_hider"] )
            break;
        case 7:
            player.GiveWeapon( "mp_weapon_mastiff", WEAPON_INVENTORY_SLOT_PRIMARY_0)
            break;
        case 8:
            player.GiveWeapon( "mp_weapon_pdw", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_classic", "stock_tactical_l3", "highcal_mag_l3"] )
            break;
		case 9:
            player.GiveWeapon( "mp_weapon_autopistol", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_classic", "bullets_mag_l1"] )
            break;
		case 10:
			player.GiveWeapon( "mp_weapon_lmg", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_bruiser", "highcal_mag_l3", "barrel_stabilizer_l3", "stock_tactical_l3" ] )
            break; 
		case 11:
            player.GiveWeapon( "mp_weapon_shotgun_pistol", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["shotgun_bolt_l3"] )
            break;
		case 12:
            player.GiveWeapon( "mp_weapon_rspn101", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_classic", "stock_tactical_l1", "bullets_mag_l2"] )
            break;
		case 13:
            player.GiveWeapon( "mp_weapon_defender", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_ranged_hcog", "stock_sniper_l2"] )
            break;
		case 14:
            player.GiveWeapon( "mp_weapon_energy_ar", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_bruiser", "energy_mag_l3", "stock_tactical_l3", "hopup_turbocharger"] )
            break;
		case 15:
            player.GiveWeapon( "mp_weapon_wingman", WEAPON_INVENTORY_SLOT_PRIMARY_0)
            break;
		case 16:
            player.GiveWeapon( "mp_weapon_alternator_smg", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_classic", "bullets_mag_l3", "stock_tactical_l3"] )
            break;
		case 17:
            player.GiveWeapon( "mp_weapon_semipistol", WEAPON_INVENTORY_SLOT_PRIMARY_0)
            break;
		case 18:
            player.GiveWeapon( "mp_weapon_lstar", WEAPON_INVENTORY_SLOT_PRIMARY_0)
            break;
		case 19:
            player.GiveWeapon( "mp_weapon_g2", WEAPON_INVENTORY_SLOT_PRIMARY_0)
            break;
		case 20:
            player.GiveWeapon( "mp_weapon_shotgun_pistol", WEAPON_INVENTORY_SLOT_PRIMARY_0)
            break;
		case 21:
            player.GiveWeapon( "mp_weapon_esaw", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_bruiser", "energy_mag_l1", "barrel_stabilizer_l2"] )
            break;
		case 22:
            player.GiveWeapon( "mp_weapon_doubletake", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["energy_mag_l3"] )
            break;
		case 23:
            player.GiveWeapon( "mp_weapon_rspn101", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_classic", "bullets_mag_l1", "barrel_stabilizer_l1", "stock_tactical_l1"] )
            break;
		case 24:
            player.GiveWeapon( "mp_weapon_wingman", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["highcal_mag_l1"] )
            break;
		case 25:
            player.GiveWeapon( "mp_weapon_shotgun", WEAPON_INVENTORY_SLOT_PRIMARY_0)
            break;
        case 26:
            player.GiveWeapon( "mp_weapon_energy_shotgun", WEAPON_INVENTORY_SLOT_PRIMARY_0)
            break;
		case 27:
            player.GiveWeapon( "mp_weapon_vinson", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["stock_tactical_l1", "highcal_mag_l2"] )
            break;
		case 28:
            player.GiveWeapon( "mp_weapon_r97", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_threat", "bullets_mag_l1", "barrel_stabilizer_l3", "stock_tactical_l1"] )
            break;
		case 29:
            player.GiveWeapon( "mp_weapon_autopistol", WEAPON_INVENTORY_SLOT_PRIMARY_0)
            break;
		case 30:
            player.GiveWeapon( "mp_weapon_mastiff", WEAPON_INVENTORY_SLOT_PRIMARY_0)
            break;
		case 31:
            player.GiveWeapon( "mp_weapon_dmr", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_bruiser", "highcal_mag_l2", "barrel_stabilizer_l2", "stock_sniper_l3"] )
            break;
		case 32:
            player.GiveWeapon( "mp_weapon_pdw", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["stock_tactical_l1", "highcal_mag_l1"] )
            break;
		case 33:
            player.GiveWeapon( "mp_weapon_esaw", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_classic", "energy_mag_l1", "barrel_stabilizer_l4_flash_hider"] )
            break;
		case 34:
            player.GiveWeapon( "mp_weapon_alternator_smg", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_classic", "barrel_stabilizer_l2"] )
            break;
		case 35:
            player.GiveWeapon( "mp_weapon_sniper", WEAPON_INVENTORY_SLOT_PRIMARY_0)
            break;
		case 36:
            player.GiveWeapon( "mp_weapon_defender", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_sniper", "stock_sniper_l2"] )
            break;
		case 37:
            player.GiveWeapon( "mp_weapon_esaw", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_holosight_variable"])
            break;
		case 38:
            player.GiveWeapon( "mp_weapon_rspn101", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_holosight_variable"])
            break;
		case 39:
            player.GiveWeapon( "mp_weapon_vinson", WEAPON_INVENTORY_SLOT_PRIMARY_0)
            break;
		case 40:
            player.GiveWeapon( "mp_weapon_r97", WEAPON_INVENTORY_SLOT_PRIMARY_0 )
            break;
		case 41:
            player.GiveWeapon( "mp_weapon_g2", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["bullets_mag_l3", "barrel_stabilizer_l4_flash_hider", "stock_sniper_l3", "hopup_double_tap"] )
            break;
		case 42:
            player.GiveWeapon( "mp_weapon_semipistol", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["bullets_mag_l2"] )
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
		case 6:
            player.GiveOffhandWeapon("mp_weapon_grenade_sonar", OFFHAND_TACTICAL)
            break;
		case 7:
            player.GiveOffhandWeapon("mp_weapon_deployable_cover", OFFHAND_TACTICAL)
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
		case 5:
            player.GiveOffhandWeapon("mp_weapon_grenade_defensive_bombardment", OFFHAND_ULTIMATE)
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
		while ( file.FallTriggersEnabled )
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

array<ConsumableInventoryItem> function FlowStateGetAllDroppableItems( entity player )
{
	array<ConsumableInventoryItem> final = []

	// Consumable inventory
	final.extend( SURVIVAL_GetPlayerInventory( player ) )

	// Weapon related items
	foreach ( weapon in SURVIVAL_GetPrimaryWeapons( player ) )
	{
		LootData data = SURVIVAL_GetLootDataFromWeapon( weapon )
		if ( data.ref == "" )
			continue

		// Add the weapon
		ConsumableInventoryItem item
		
		item.type = data.index
		item.count = weapon.GetWeaponPrimaryClipCount()

		final.append( item )

		foreach ( esRef, mod in GetAllWeaponAttachments( weapon ) )
		{
			if ( !SURVIVAL_Loot_IsRefValid( mod ) )
				continue
			
			if ( data.baseMods.contains( mod ) )
				continue

			LootData attachmentData = SURVIVAL_Loot_GetLootDataByRef( mod )

			// Add the attachment
			ConsumableInventoryItem attachmentItem
			
			attachmentItem.type = attachmentData.index
			attachmentItem.count = 1

			final.append( attachmentItem )
		}
	}

	// Non-weapon equipment slots
	foreach ( string ref, EquipmentSlot es in EquipmentSlot_GetAllEquipmentSlots() )
	{
		if ( EquipmentSlot_IsMainWeaponSlot( ref ) || EquipmentSlot_IsAttachmentSlot( ref ) )
			continue

		LootData data = EquipmentSlot_GetEquippedLootDataForSlot( player, ref )
		if ( data.ref == "" )
			continue

		// Add the equipped loot
		ConsumableInventoryItem equippedItem

		equippedItem.type = data.index
		equippedItem.count = 1

		final.append( equippedItem )
	}

	return final
}


void function CreateFlowStateDeathBoxForPlayer( entity victim, entity attacker, var damageInfo )
{
	entity deathBox = FlowState_CreateDeathBox( victim, true )

	foreach ( invItem in FlowStateGetAllDroppableItems( victim ) )
	{
		if( invItem.type == 44 || invItem.type == 45 || invItem.type == 46 || invItem.type == 47 || invItem.type == 48 || invItem.type == 53 || invItem.type == 54 || invItem.type == 55 || invItem.type == 56 ) { //don't add shields to deathboxes, debug this wasnt ez :p Colombia
		continue}
		else{
		LootData data = SURVIVAL_Loot_GetLootDataByIndex( invItem.type )
		entity loot = SpawnGenericLoot( data.ref, deathBox.GetOrigin(), deathBox.GetAngles(), invItem.count )
		AddToDeathBox( loot, deathBox )
		}
	}

	UpdateDeathBoxHighlight( deathBox )

	foreach ( func in svGlobal.onDeathBoxSpawnedCallbacks )
		func( deathBox, attacker, damageInfo != null ? DamageInfo_GetDamageSourceIdentifier( damageInfo ) : 0 )
}


entity function FlowState_CreateDeathBox( entity player, bool hasCard )
{
	entity box = CreatePropDeathBox_NoDispatchSpawn( DEATH_BOX, player.GetOrigin(), <0, 45, 0>, 6 )
	box.kv.fadedist = 10000
	if ( hasCard )
		SetTargetName( box, DEATH_BOX_TARGETNAME )

	DispatchSpawn( box )

	box.RemoveFromAllRealms()
	box.AddToOtherEntitysRealms( player )

	box.Solid()

	box.SetUsable()
	box.SetUsableValue( USABLE_BY_ALL | USABLE_CUSTOM_HINTS )
	
	box.SetOwner( player )
	box.SetNetInt( "ownerEHI", player.GetEncodedEHandle() )

	if ( hasCard )
	{
		box.SetNetBool( "overrideRUI", false )

		box.SetCustomOwnerName( player.GetPlayerName() )

		 EHI playerEHI = ToEHI( player )

		 LoadoutEntry characterLoadoutEntry = Loadout_CharacterClass()
		 ItemFlavor character = LoadoutSlot_GetItemFlavor( playerEHI, characterLoadoutEntry )
		 box.SetNetInt( "characterIndex", ConvertItemFlavorToLoadoutSlotContentsIndex( characterLoadoutEntry, character ) )
	}

	if ( hasCard )
	{
		Highlight_SetNeutralHighlight( box, "sp_objective_entity" )
		Highlight_ClearNeutralHighlight( box )

		thread FlowStateDeathBoxFakePhysics( box )
		thread FlowStateDeathBoxWatcher(box)
	}

	return box
}

void function FlowStateDeathBoxWatcher(entity box)
{
	wait 20
	box.Destroy()
}


void function FlowStateDeathBoxFakePhysics( entity box )
{
	vector restPos = box.GetOrigin()
	vector fallPos = restPos + < 0, 0, 54 >

	entity mover = CreateScriptMover( restPos, box.GetAngles(), 0 )
	box.SetParent( mover, "", true )

	mover.NonPhysicsMoveTo( fallPos, 0.5, 0.0, 0.5 )
	wait 0.5
	mover.NonPhysicsMoveTo( restPos, 0.5, 0.5, 0.0 )
	wait 0.5
	if ( IsValid( box ) )
		box.ClearParent()
	mover.Destroy()
}

void function PlayerRestoreShieldsFIESTA(entity player, int shields) {
    if(IsValidPlayer(player) && IsAlive( player ))
        player.SetShieldHealth(shielddd(shields, 0, player.GetShieldHealthMax()))
}

void function PlayerRestoreHPFIESTA(entity player, int health) {
    if(IsValidPlayer(player) && IsAlive( player ))
        player.SetHealth( health )
}

int function shielddd(int value, int min, int max) {
    if(value < min) return min
    else if (value > max) return max
    else return value

    unreachable
}

void function UpgradeShields(entity player, bool died) {

    if (!IsValid(player)) return
    if (died) {
        player.SetPlayerGameStat( PGS_TITAN_KILLS, 0 )
        Inventory_SetPlayerEquipment(player, BLUE_SHIELD, "armor")
    } else {
        player.SetPlayerGameStat( PGS_TITAN_KILLS, player.GetPlayerGameStat( PGS_TITAN_KILLS ) + 1)

        switch (player.GetPlayerGameStat( PGS_TITAN_KILLS )) {
	    	case 1:
                Inventory_SetPlayerEquipment(player, BLUE_SHIELD, "armor")
                break
            case 2:
			     Inventory_SetPlayerEquipment(player, BLUE_SHIELD, "armor")
                break
            case 3:
				Inventory_SetPlayerEquipment(player, BLUE_SHIELD, "armor")
                break
			case 4:
				Inventory_SetPlayerEquipment(player, BLUE_SHIELD, "armor")
			case 5:
				Inventory_SetPlayerEquipment(player, PURPLE_SHIELD, "armor")
								foreach(sPlayer in GetPlayerArray()){
				Message(sPlayer,"KILL STREAK", player.GetPlayerName() + " got 5 kill streak!", 4, "")
				}
            break
            case 6:
				Inventory_SetPlayerEquipment(player, PURPLE_SHIELD, "armor")
            break
			case 7:
				Inventory_SetPlayerEquipment(player, PURPLE_SHIELD, "armor")
            break
			case 8:
				GiveFlowstateOvershield(player)
				foreach(sPlayer in GetPlayerArray()){
				Message(sPlayer,"EXTRA SHIELD KILL STREAK", player.GetPlayerName() + " got 8 kill streak and extra shield!", 5, "")
				}
            break
			case 15:
				GiveFlowstateOvershield(player)
				foreach(sPlayer in GetPlayerArray()){
				Message(sPlayer,"15 KILL STREAK", player.GetPlayerName() + " got 15 kill streak!", 5, "")
				}
			case 20:
				GiveFlowstateOvershield(player)
				foreach(sPlayer in GetPlayerArray()){
				Message(sPlayer,"20 BOMB KILL STREAK", player.GetPlayerName() + " got a 20 bomb!", 5, "")
				}
            break
			case 25:
				GiveFlowstateOvershield(player)
				foreach(sPlayer in GetPlayerArray()){
				Message(sPlayer,"LEGENDARY KILL STREAK", player.GetPlayerName() + " got 30 kill streak!", 5, "")
				}
            break
			case 35:
				GiveFlowstateOvershield(player)
				foreach(sPlayer in GetPlayerArray()){
				Message(sPlayer,"PREDATOR SUPREMACY", player.GetPlayerName() + " got 35 kill streak!", 5, "")
				}
            break
			case 50:
				GiveFlowstateOvershield(player)
				foreach(sPlayer in GetPlayerArray()){
				Message(sPlayer,"CHEATER DETECTED!", player.GetPlayerName() + " got 50 kill streak, report him!", 5, "")
				}
            break
			default:
                GiveFlowstateOvershield(player)
                break
        }
    }
    PlayerRestoreShieldsFIESTA(player, player.GetShieldHealthMax())
    PlayerRestoreHPFIESTA(player, 100)
}

void function KillStreakAnnouncer(entity player, bool died) {

    if (!IsValid(player)) return
    if (died) {
        player.SetPlayerGameStat( PGS_TITAN_KILLS, 0 )
    } else {
		//is Custom Damageinfo Killshot adding a kill in pgs titan kills?
        //player.SetPlayerGameStat( PGS_TITAN_KILLS, player.GetPlayerGameStat( PGS_TITAN_KILLS ) + 1)
        switch (player.GetPlayerGameStat( PGS_TITAN_KILLS )) {
			case 5:
				foreach(sPlayer in GetPlayerArray()){
				Message(sPlayer,"KILL STREAK", player.GetPlayerName() + " got 5 kill streak!", 4, "")
				}
			case 10:
				GiveFlowstateOvershield(player)
				foreach(sPlayer in GetPlayerArray()){
				Message(sPlayer,"EXTRA SHIELD KILL STREAK", player.GetPlayerName() + " got 10 kill streak and extra shield!", 5, "")
				}
            break
			case 15:
				GiveFlowstateOvershield(player)
				foreach(sPlayer in GetPlayerArray()){
				Message(sPlayer,"15 KILL STREAK", player.GetPlayerName() + " got 15 kill streak and extra shield!", 5, "")
				}
			case 20:
				GiveFlowstateOvershield(player)
				foreach(sPlayer in GetPlayerArray()){
				Message(sPlayer,"20 BOMB KILL STREAK", player.GetPlayerName() + " got a 20 bomb and extra shield!", 5, "")
				}
            break
			case 25:
				GiveFlowstateOvershield(player)
				foreach(sPlayer in GetPlayerArray()){
				Message(sPlayer,"PREDATOR SUPREMACY", player.GetPlayerName() + " got 25 kill streak and extra shield!", 5, "")
				}
            break
			default:
                break
        }
    }
}

#if SERVER
void function GiveFlowstateOvershield( entity player, bool isOvershieldFromGround = false)
{
	player.SetShieldHealthMax( FlowState_ExtrashieldValue() )
	player.SetShieldHealth( FlowState_ExtrashieldValue() )
	//DelayShieldDecayTime( soul, 1 )
	if(isOvershieldFromGround){
			foreach(sPlayer in GetPlayerArray()){
			Message(sPlayer,"EXTRA SHIELD PROVIDED", player.GetPlayerName() + " has 50 extra shield.", 5, "")
		}		
	}
}
#endif

void function GiveGungameWeapon(entity player) {
//By CaféDeColombiaFPS
	int WeaponIndex = player.GetPlayerNetInt( "kills" )
	int realweaponIndex = WeaponIndex
	int MaxWeapons = 42
		if (WeaponIndex > MaxWeapons) {
        realweaponIndex = RandomInt(42)
		}
		
	if(!FlowState_GungameRandomAbilities())
	{
		entity weapon
		string tac = GetCurrentPlaylistVarString("flowstateGUNGAME_tactical", "~~none~~")
		string ult = GetCurrentPlaylistVarString("flowstateGUNGAME_ultimate", "~~none~~")
		
		entity tactical = player.GetOffhandWeapon( OFFHAND_TACTICAL )
        entity ultimate = player.GetOffhandWeapon( OFFHAND_ULTIMATE )
		try{
		
		float oldTacticalChargePercent = 0.0
                if( IsValid( tactical ) ) {
                    player.TakeOffhandWeapon( OFFHAND_TACTICAL )
                    oldTacticalChargePercent = float( tactical.GetWeaponPrimaryClipCount()) / float(tactical.GetWeaponPrimaryClipCountMax() )
                }
                weapon = player.GiveOffhandWeapon(tac, OFFHAND_TACTICAL)
				entity newTactical = player.GetOffhandWeapon( OFFHAND_TACTICAL )
                newTactical.SetWeaponPrimaryClipCount( int( newTactical.GetWeaponPrimaryClipCountMax() * oldTacticalChargePercent ) )
				}catch(e111){}
				try{
				                if( IsValid( ultimate ) ) player.TakeOffhandWeapon( OFFHAND_ULTIMATE )
                weapon = player.GiveOffhandWeapon(ult, OFFHAND_ULTIMATE)
		}catch(e112){}
	}
	try{
	//give gungame weapon
	player.TakeNormalWeaponByIndexNow( WEAPON_INVENTORY_SLOT_PRIMARY_0 )
	GiveActualGungameWeapon(realweaponIndex, player)
	//give secondary
	string sec = GetCurrentPlaylistVarString("flowstateGUNGAMESecondary", "~~none~~")
	player.TakeNormalWeaponByIndexNow( WEAPON_INVENTORY_SLOT_PRIMARY_1 )
	player.GiveWeapon( sec, WEAPON_INVENTORY_SLOT_PRIMARY_1)
	
	if (sec != "") {
			array<string> attachments = []
			
			for(int i = 0; GetCurrentPlaylistVarString("flowstateGUNGAMESecondary" + "_" + i.tostring(), "~~none~~") != "~~none~~"; i++)
			{
				if(GetCurrentPlaylistVarString("flowstateGUNGAMESecondary" + "_" + i.tostring(), "~~none~~") == ""){
				continue
				}
				else{
				attachments.append(GetCurrentPlaylistVarString("flowstateGUNGAMESecondary" + "_" + i.tostring(), "~~none~~"))}
			}
			player.TakeNormalWeaponByIndexNow( WEAPON_INVENTORY_SLOT_PRIMARY_1 )
			player.GiveWeapon(sec, WEAPON_INVENTORY_SLOT_PRIMARY_1, attachments)
	}
	//entity primary = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 )
	//if( IsValid( primary ) && !primary.IsWeaponOffhand() ) player.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, GetSlotForWeapon(player, primary))
		}catch(e113){}
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
	file.FallTriggersEnabled = true
	
	if(GetMapName() == "mp_rr_desertlands_64k_x_64k" || GetMapName() == "mp_rr_desertlands_64k_x_64k_nx" || GetMapName() == "mp_rr_canyonlands_mu1" || GetMapName() == "mp_rr_canyonlands_mu1_night" || GetMapName() == "mp_rr_canyonlands_64k_x_64k")
	{
		thread CreateShipRoomFallTriggers()
	}
	if (FlowState_RandomGuns() )
    {
        file.randomprimary = RandomIntRangeInclusive( 0, 15 )
        file.randomsecondary = RandomIntRangeInclusive( 0, 6 )
    } else if (FlowState_RandomGunsMetagame())
	{
		file.randomprimary = RandomIntRangeInclusive( 0, 3 )
        file.randomsecondary = RandomIntRangeInclusive( 0, 4 )
	} else if (FlowState_RandomGunsEverydie())
	{
		file.randomprimary = RandomIntRangeInclusive( 0, 23 )
        file.randomsecondary = RandomIntRangeInclusive( 0, 18 )
	}
	
wait 1

foreach(player in GetPlayerArray())
{
    try {
		if(IsValid(player))
        {
			player.SetThirdPersonShoulderModeOn()
			_HandleRespawn(player)
			if(FlowState_Gungame())
{
	GiveGungameWeapon(player)
}
			player.UnforceStand()
			player.UnfreezeControlsOnServer()
			HolsterAndDisableWeapons( player )
        }
	}catch(e){}
//CreatePanelText( player, "test", "test", <-19459, 2127, 6404>, <0, 180, 0>, true, 2 )
}


wait 5

	if (!file.mapIndexChanged)
		{
			file.nextMapIndex = (file.nextMapIndex + 1 ) % file.locationSettings.len()
			//surf will never be in normal playlist mode
			if(file.nextMapIndex == 12 && GetMapName() == "mp_rr_desertlands_64k_x_64k" || file.nextMapIndex == 12 && GetMapName() == "mp_rr_desertlands_64k_x_64k_nx" )
			{
			file.nextMapIndex = 0
			}
		}
		
	if (FlowState_LockPOI()) {
		file.nextMapIndex = FlowState_LockedPOI()
	}
	
	
	if(FlowState_SURF()){
	file.nextMapIndex = 12}
	
int choice = file.nextMapIndex
file.mapIndexChanged = false
file.selectedLocation = file.locationSettings[choice]
file.dropselectedLocation = file.droplocationSettings[choice]


if(file.selectedLocation.name == "TTV Building" && FlowState_ExtrashieldsEnabled()){
	DestroyPlayerProps()
	CreateGroundMedKit(<10725, 5913,-4225>)
} else if(file.selectedLocation.name == "Skill trainer By Colombia"){
    DestroyPlayerProps()
    wait 1
	CreateGroundMedKit(<17247,31823,-310>)
    SkillTrainerLoad()
} else if(file.selectedLocation.name == "Surf Purgatory"){
	file.surfEnded = false
	DestroyPlayerProps()
    wait 1
    SurfPurgatoryLoad()
} else if(file.selectedLocation.name == "Gaunlet"){
	DestroyPlayerProps()
	CreateGroundMedKit(<-21289, -12030, 3060>)
	}

//TODO MORE POIS



if(GetCurrentPlaylistVarBool("flowstateenabledropship", false ) == false && !FlowState_SURF())
{
    foreach(player in GetPlayerArray())
    {
        if(IsValidPlayer(player))
        {
		    Message(player,"Starting match...", "", 4, "Wraith_PhaseGate_Travel_1p")
		    ScreenFade( player, 0, 0, 0, 255, 4.0, 4.0, FFADE_OUT | FFADE_PURGE )
	    }
    }
}

if(GetCurrentPlaylistVarBool("flowstateenabledropship", false ) && !FlowState_SURF())
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

	wait 2

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

	wait 5

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
			Remote_CallFunction_Replay( player, "ServerCallback_PlayScreenFXWarpJump" )
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

if(GetCurrentPlaylistVarBool("flowstateenabledropship", false ) && !FlowState_SURF())
{
	if(GetMapName() == "mp_rr_desertlands_64k_x_64k" || GetMapName() == "mp_rr_desertlands_64k_x_64k_nx" || GetMapName() == "mp_rr_canyonlands_mu1" || GetMapName() == "mp_rr_canyonlands_mu1_night" || GetMapName() == "mp_rr_canyonlands_64k_x_64k")
	{
		int maxspawns = -1
		array<LocPair> spawns = file.dropselectedLocation.spawns
		foreach(spawn in spawns)
		{
    		maxspawns++
		}

		// array<vector> newdropshipspawns = GetNewFFADropShipLocations(file.selectedLocation.name, GetMapName())
		// array<vector> shuffledspawnes = shuffleDropShipArray(newdropshipspawns, 50)
		 int spawni = 0

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
					
					if (!FlowState_DummyOverride()) {
					thread RespawnPlayersInDropshipAtPoint2( player, spawns[rndnum].origin + <0,0,500>, AnglesCompose( spawns[rndnum].angles, <0,0,0> ) ) }
					else {
					DeployAndEnableWeapons(player)
					ClearInvincible(player)
					}
				
					Remote_CallFunction_NonReplay(player, "ServerCallback_TDM_DoAnnouncement", 1, eTDMAnnounce.ROUND_START)
					// reload weapons when tp'ing to next location
					entity w1 = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 )
					entity w2 = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_1 )
					try {w1.SetWeaponPrimaryClipCount(w1.GetWeaponPrimaryClipCountMax())} catch(this_is_a_unique_string_dont_crash_u_bitch){}
					try {w2.SetWeaponPrimaryClipCount(w2.GetWeaponPrimaryClipCountMax())} catch(this_is_a_unique_string_dont_crash_u_bitch2){}
    			}
		}
		spawni++
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
}   

try {
if(GetBestPlayer()==PlayerWithMostDamage())
{
	foreach(player in GetPlayerArray())
    {
		string nextlocation = file.selectedLocation.name
		if(file.selectedLocation.name == "Surf Purgatory"){
		Message(player, "WELCOME TO SURF PURGATORY", "", 15, "diag_ap_aiNotify_circleTimerStartNext_02")
		player.Code_SetTeam( TEAM_IMC )
		} else {
		Message(player, file.selectedLocation.name + ": ROUND START!", "\n           CHAMPION: " + GetBestPlayerName() + " / " + GetBestPlayerScore() + " kills. / " + GetDamageOfPlayerWithMostDamage() + " damage.", 25, "diag_ap_aiNotify_circleTimerStartNext_02")
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
		int playerEHandle = player.GetEncodedEHandle()
		string nextlocation = file.selectedLocation.name
		if(file.selectedLocation.name == "Surf Purgatory"){
		Message(player, "WELCOME TO SURF PURGATORY", "", 15, "diag_ap_aiNotify_circleTimerStartNext_02")
		player.Code_SetTeam( TEAM_IMC )
		} else {
		Message(player, file.selectedLocation.name + ": ROUND START!", "\n           CHAMPION: " + GetBestPlayerName() + " / " + GetBestPlayerScore() + " kills. \n    CHALLENGER:  " + PlayerWithMostDamageName() + " / " + GetDamageOfPlayerWithMostDamage() + " damage.", 25, "diag_ap_aiNotify_circleTimerStartNext_02")
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
			player.p.playerDamageDealt = 0.0
			if (FlowState_ResetKillsEachRound() && IsValidPlayer(player)) 
			{
				player.SetPlayerNetInt("kills", 0) //Reset for kills
	    		player.SetPlayerNetInt("assists", 0) //Reset for deaths
			}
			
			if(FlowState_Gungame())
			{
			player.SetPlayerGameStat( PGS_TITAN_KILLS, 0)
			KillStreakAnnouncer(player, true)
			}
			
			if(FlowState_RandomGunsEverydie()){
			player.SetPlayerGameStat( PGS_TITAN_KILLS, 0)
			UpgradeShields(player, true)
			} 
		}
	}
file.FallTriggersEnabled = false
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

if(file.selectedLocation.name == "Surf Purgatory"){
file.bubbleBoundary.Destroy()
}
foreach(player in GetPlayerArray())
    {
WpnPulloutOnRespawn(player)
	}
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
			if(FlowState_RandomGunsEverydie()){
			PlayerRestoreShieldsFIESTA(player, player.GetShieldHealthMax())
			PlayerRestoreHPFIESTA(player, 100)
			player.SetThirdPersonShoulderModeOn()
			HolsterAndDisableWeapons( player )
			} else {
			PlayerRestoreHP(player, 100, Equipment_GetDefaultShieldHP())
			player.SetThirdPersonShoulderModeOn()
			HolsterAndDisableWeapons( player )
			}
	}
	} catch (e) {}
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
		Message(player,"- CHAMPION DECIDED! -", "\n " + GetBestPlayerName() + " is the champion. " + GetBestPlayerScore() + " kills and " + GetDamageOfPlayerWithMostDamage() + " of damage.  \n \n        Champion is literally on fire! Weapons disabled! Please tbag.", 10, "UI_InGame_ChampionVictory")
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
            if(Distance(player.GetOrigin(), bubbleCenter) > bubbleRadius && player.GetPlayerGameStat( PGS_ASSAULT_SCORE ) != 2)
            {
				Remote_CallFunction_Replay( player, "ServerCallback_PlayerTookDamage", 0, 0, 0, 0, DF_BYPASS_SHIELD | DF_DOOMED_HEALTH_LOSS, eDamageSourceId.deathField, null )
                player.TakeDamage( int( Deathmatch_GetOOBDamagePercent() / 100 * float( player.GetMaxHealth() ) ), null, null, { scriptType = DF_BYPASS_SHIELD | DF_DOOMED_HEALTH_LOSS, damageSourceId = eDamageSourceId.deathField } )
            }
        }
        wait 1
    }
}


entity function CreateBubbleBoundaryPROPHUNT(LocationSettings location)
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
    bubbleRadius += 200
    entity bubbleShield = CreateEntity( "prop_dynamic" )
	bubbleShield.SetValueForModelKey( BUBBLE_BUNKER_SHIELD_COLLISION_MODEL )
    bubbleShield.SetOrigin(bubbleCenter)
    bubbleShield.SetModelScale(bubbleRadius / 235)
    bubbleShield.kv.CollisionGroup = 0
    bubbleShield.kv.rendercolor = FlowState_BubbleColor()
    DispatchSpawn( bubbleShield )
    thread MonitorBubbleBoundaryPROPHUNT(bubbleShield, bubbleCenter, bubbleRadius)
    return bubbleShield
}

void function MonitorBubbleBoundaryPROPHUNT(entity bubbleShield, vector bubbleCenter, float bubbleRadius)
{
	wait 31
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

//Dummies
if (FlowState_DummyOverride()) {
	player.SetBodyModelOverride( $"mdl/humans/class/medium/pilot_medium_generic.rmdl" )
	player.SetArmsModelOverride( $"mdl/humans/class/medium/pilot_medium_generic.rmdl" )
	player.SetSkin(player.GetTeam())
}

//Data knife
player.TakeNormalWeaponByIndexNow( WEAPON_INVENTORY_SLOT_PRIMARY_2 )
player.TakeOffhandWeapon( OFFHAND_MELEE )
player.TakeOffhandWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_2 )
player.GiveWeapon( "mp_weapon_melee_survival", WEAPON_INVENTORY_SLOT_PRIMARY_2, [] )
player.GiveOffhandWeapon( "melee_data_knife", OFFHAND_MELEE, [] )
if(FlowState_PROPHUNT())
{
TakeAllWeapons(player)
}
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

string function ScoreboardFinalPROPHUNT(bool fromConsole = false)
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
                     msg = msg + "1. " + p.name + ":   " + p.score + " | " + p.deaths + "\n"
					break
                case 1:
                    msg = msg + "2. " + p.name + ":   " + p.score + " | " + p.deaths + "\n"
                    break
                case 2:
                    msg = msg + "3. " + p.name + ":   " + p.score + " | " + p.deaths + "\n"
                    break
                default:
					msg = msg + p.name + ":   " + p.score + " | " + p.deaths + "\n"
                    break
            }
        }

		if (fromConsole && spectators.len() > 0) {
			msg += "\n\n Players waiting for respawn:\n"
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
bool function ClientCommand_ChangePropPROPHUNT(entity player, array<string> args)
{
	if(prophunt.cantUseChangeProp || player.GetTeam() == TEAM_IMC){
		return false
	}
	int newscore = player.GetPlayerGameStat(PGS_ASSAULT_SCORE) + 1 	
	player.SetPlayerGameStat( PGS_ASSAULT_SCORE, newscore)

	if (player.GetPlayerGameStat(PGS_ASSAULT_SCORE) <= 3){
	PROPHUNT_GiveRandomProp(player)	

	return true}
	else{
	return false}
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
	return "\n\n           CONSOLE COMMANDS:\n\n 1. 'kill_self': if you get stuck.\n2. 'scoreboard': displays scoreboard to user. \n3. 'latency': displays ping of all players to user.\n4. 'say [MESSAGE]': send a public message! (" + FlowState_ChatCooldown().tostring() + "s global cooldown) \n5.'spectate': spectate enemies! \n6. 'commands': display this message again."
}

string function helpMessagePROPHUNT()
//by michae\l/#1125
{
	return "           Prophunt console commands: \n\n 1. 'prop': change prop up to 3 times before attackers arrive. \n2. 'scoreboard': displays scoreboard to user. \n3. 'latency': displays ping of all players to user.\n4. 'say [MESSAGE]': send a public message! \n5. 'commands': display this message again."
}

bool function ClientCommand_Help(entity player, array<string> args)
//by michae\l/#1125
{
	if(IsValid(player)) {
		try{
			if(FlowState_RandomGunsEverydie())
			{
			Message(player, "WELCOME TO FLOW STATE: FIESTA", helpMessage(), 10)}
			else if (FlowState_Gungame())
			{
			Message(player, "WELCOME TO FLOW STATE: GUNGAME", helpMessage(), 10)

			} else if (FlowState_PROPHUNT())
			{
			Message(player, "WELCOME TO FLOW STATE: PROPHUNT", helpMessagePROPHUNT(), 10)	
			} else{ 
			Message(player, "WELCOME TO FLOW STATE: FFA/TDM", helpMessage(), 10)
			}
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
	
	if(!FlowState_PROPHUNT()){
	
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
    }} else {

if(IsValidPlayer(player))
        {
foreach(sPlayer in GetPlayerArray())
    {
	Message( sPlayer, "Trollbox", currentChat, 5)
    }
file.lastTimeChatUsage = Time()
		}

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
    if ( FlowState_AdminTgive() && player.GetPlayerName() != file.Hoster )
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

bool function ClientCommand_NextRoundPROPHUNT(entity player, array<string> args)
//Thanks Archtux#9300
//Modified by Retículo Endoplasmático#5955 and michae\l/#1125
{
if(player.GetPlayerName() == file.Hoster || player.GetPlayerName() == file.admin1 || player.GetPlayerName() == file.admin2 || player.GetPlayerName() == file.admin3 || player.GetPlayerName() == file.admin4) {
	
    if (args.len()) {
        try{
            int mapIndex = int(args[0])
            prophunt.nextMapIndex = (((mapIndex >= 0 ) && (mapIndex < prophunt.locationSettings.len())) ? mapIndex : RandomIntRangeInclusive(0, prophunt.locationSettings.len() - 1))
            prophunt.mapIndexChanged = true
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

bool function ClientCommand_NextRound(entity player, array<string> args)
//Thanks Archtux#9300
//Modified by Retículo Endoplasmático#5955 and michae\l/#1125
{
if(player.GetPlayerName() == file.Hoster || player.GetPlayerName() == file.admin1 || player.GetPlayerName() == file.admin2 || player.GetPlayerName() == file.admin3 || player.GetPlayerName() == file.admin4) {
	
    if (args.len()) {

        try{
            string now = args[0]
            if (now == "now")
            {
               file.tdmState = eTDMState.NEXT_ROUND_NOW
			   file.mapIndexChanged = false
			   return true
            }
        } catch(e1) {}

        try{
            int mapIndex = int(args[0])
            file.nextMapIndex = (((mapIndex >= 0 ) && (mapIndex < file.locationSettings.len())) ? mapIndex : RandomIntRangeInclusive(0, file.locationSettings.len() - 1))
            file.mapIndexChanged = true
        } catch (e) {}

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

bool function ClientCommand_ScoreboardPROPHUNT(entity player, array<string> args)
//by michae\l/#1125
{
	float ping = player.GetLatency() * 1000 - 40
	if(IsValid(player)) {
		try{
		Message(player, "- PROPHUNT SCOREBOARD - ", "Name:    K  |   D   \n" + ScoreboardFinalPROPHUNT(true) + "\nYour ping: " + ping.tointeger() + "ms. \nHosted by: " + getHoster(), 5)
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

array<vector> function shuffleDropShipArray(array<vector> arr, int ammount)
//By AyeZeeBB#6969
// michae\l/#1125's wasnt working for this
{
	int i;
	int j;
	int b;
	vector tmp;

	for (i = ammount; i > 0; i--) {
		j = RandomIntRangeInclusive(0, arr.len() - 1)
		b = RandomIntRangeInclusive(0, arr.len() - 1)
		tmp = arr[b]
		arr[b] = arr[j]
		arr[j] = tmp
	}

	return arr
}

bool function ClientCommand_RebalanceTeams(entity player, array<string> args)
//By michae\l/#1125 & Retículo Endoplasmático#5955.
{
if(player.GetPlayerName() == file.Hoster || player.GetPlayerName() == file.admin1 || player.GetPlayerName() == file.admin2 || player.GetPlayerName() == file.admin3 || player.GetPlayerName() == file.admin4) {
    int currentTeam = 2 //2
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
}

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

