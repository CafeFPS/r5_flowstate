///////////////////////////////////////////////////////
// ███████ ██       ██████  ██     ██     ███████ ████████  █████  ████████ ███████ 
// ██      ██      ██    ██ ██     ██     ██         ██    ██   ██    ██    ██      
// █████   ██      ██    ██ ██  █  ██     ███████    ██    ███████    ██    █████   
// ██      ██      ██    ██ ██ ███ ██          ██    ██    ██   ██    ██    ██      
// ██      ███████  ██████   ███ ███      ███████    ██    ██   ██    ██    ███████
///////////////////////////////////////////////////////
//APEX PROPHUNT GAMEMODE                                                                   
//Credits: 
//CaféDeColombiaFPS (Retículo Endoplasmático#5955) -- owner/main dev
//everyone else -- advice

global function _RegisterLocationPROPHUNT
global function PROPHUNT_GiveAndManageRandomProp
global function returnPropBool
global function RunPROPHUNT
global function _OnPlayerConnectedPROPHUNT
global function _OnPlayerDiedPROPHUNT
global function ClientCommand_NextRoundPROPHUNT
global function helpMessagePROPHUNT

struct{
float endTime = 0
array<entity> playerSpawnedProps
array<LocationSettings> locationSettings
array<LocationSettings> locationsShuffled
LocationSettings& selectedLocation
int nextMapIndex = 0
bool mapIndexChanged = true
bool cantUseChangeProp = false
bool InProgress = false
} prophunt

void function _RegisterLocationPROPHUNT(LocationSettings locationSettings)
{
    prophunt.locationSettings.append(locationSettings)
}

void function _OnPropDynamicSpawnedPROPHUNT(entity prop)
{
    prophunt.playerSpawnedProps.append(prop)
}

//prophunt start. Colombia
///////////////////////////////////////////////////////

const array<asset> prophuntAssetsWE =
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
[
	$"mdl/barriers/concrete/concrete_barrier_01.rmdl",
	$"mdl/vehicles_r5/land/msc_truck_samson_v2/veh_land_msc_truck_samson_v2.rmdl",
	$"mdl/angel_city/vending_machine.rmdl",
	$"mdl/utilities/power_gen1.rmdl",
	$"mdl/angel_city/box_small_02.rmdl",
	$"mdl/colony/antenna_05_colony.rmdl",
	$"mdl/robots/marvin/marvin_gladcard.rmdl",
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

array<LocationSettings> function shuffleLocationsArray(array<LocationSettings> arr)
// O(n) Durstenfeld / Knuth shuffle (https://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle)
//By michae\l/#1125.
{
	int i;
	int j;
	int b;
	LocationSettings tmp;

	for (i = arr.len() - 1; i > 0; i--) {
		j = RandomIntRangeInclusive(1, i)
		tmp = arr[b]
		arr[b] = arr[j]
		arr[j] = tmp
	}

	return arr
}

void function RunPROPHUNT()
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
{
    WaitForGameState(eGameState.Playing)
    AddSpawnCallback("prop_dynamic", _OnPropDynamicSpawnedPROPHUNT)
	
	prophunt.locationsShuffled = shuffleLocationsArray(prophunt.locationSettings)
	
    for(; ;)
    {
	ActualPROPHUNTLobby()
	ActualPROPHUNTGameLoop()
	}
    WaitForever()
}

void function _OnPlayerConnectedPROPHUNT(entity player)
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
{
	if(!IsValid(player)) return
	//CreatePanelText( player, "Flowstate", "", <-19766, 2111, 6541>, <0, 180, 0>, false, 2 )
	printt("Flowstate DEBUG - New player connected.", player)
	if(FlowState_ForceCharacter()){CharSelect(player)}
	GivePassive(player, ePassives.PAS_PILOT_BLOOD)
	UpdatePlayerCounts()
	array<entity> IMCplayers = GetPlayerArrayOfTeam(TEAM_IMC)
	array<entity> MILITIAplayers = GetPlayerArrayOfTeam(TEAM_MILITIA)
	array<entity> playersON = GetPlayerArray_Alive()
	playersON.fastremovebyvalue( player )
	ItemFlavor playerCharacter = LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_CharacterClass() )
	asset characterSetFile = CharacterClass_GetSetFile( playerCharacter )
	player.SetPlayerSettingsWithMods( characterSetFile, [] )
	SetPlayerSettings(player, PROPHUNT_SETTINGS)
	DoRespawnPlayer( player, null )
	Survival_SetInventoryEnabled( player, true )				
	player.SetPlayerNetInt( "respawnStatus", eRespawnStatus.NONE )
	player.SetPlayerNetBool( "pingEnabled", true )
	player.SetHealth( 100 )
	player.kv.solid = 6
	player.kv.CollisionGroup = TRACE_COLLISION_GROUP_PLAYER
	player.AllowMantle()
			
	switch(GetGameState())
    {
		case eGameState.WaitingForPlayers:
			if(IsValidPlayer(player))
			{
				printt("Flowstate DEBUG - Player connected waitingforplayers.", player)	
				//player has a team assigned already, we need to fix it before spawn
				GiveTeamToProphuntPlayer(player)

				if(GetCurrentPlaylistVarBool("flowstatePROPHUNTDebug", false )){
					SetTeam( player, TEAM_MILITIA )	
				}

				if (GetMapName() == "mp_rr_desertlands_64k_x_64k" || GetMapName() == "mp_rr_desertlands_64k_x_64k_nx")
					{
					player.SetOrigin(<-19459, 2127, 6404>)}
				else if(GetMapName() == "mp_rr_canyonlands_mu1" || GetMapName() == "mp_rr_canyonlands_mu1_night" || GetMapName() == "mp_rr_canyonlands_64k_x_64k")
					{
					player.SetOrigin(<-19459, 2127, 18404>)}
				player.SetThirdPersonShoulderModeOn()
				player.UnforceStand()
				player.UnfreezeControlsOnServer()
			}
			break
		case eGameState.MapVoting:
			if(IsValidPlayer(player))
			{
				printt("Flowstate DEBUG - Prophunt player connected mapvoting.", player)
				//player has a team assigned already, we need to fix it before spawn
				GiveTeamToProphuntPlayer(player)

				if (GetMapName() == "mp_rr_desertlands_64k_x_64k" || GetMapName() == "mp_rr_desertlands_64k_x_64k_nx")
					{
					player.SetOrigin(<-19459, 2127, 6404>)}
				else if(GetMapName() == "mp_rr_canyonlands_mu1" || GetMapName() == "mp_rr_canyonlands_mu1_night" || GetMapName() == "mp_rr_canyonlands_64k_x_64k")
					{
					player.SetOrigin(<-19459, 2127, 18404>)}

				player.SetThirdPersonShoulderModeOn()
				player.UnforceStand()
				player.UnfreezeControlsOnServer()
			}
			break
		case eGameState.Playing: //wait round ends, set new player to spectate random player
			if(IsValid(player))
			{
				printt("Flowstate DEBUG - Prophunt player connected midround, setting spectator.", player)
				array<LocPair> prophuntSpawns = prophunt.selectedLocation.spawns
				player.SetOrigin(prophuntSpawns[RandomIntRangeInclusive(0,prophuntSpawns.len()-1)].origin)
				player.MakeInvisible()
				player.p.PROPHUNT_isSpectatorDiedMidRound = false
				SetTeam(player, 20 )
				Message(player, "APEX PROPHUNT", "    Game is in progress, you'll spawn in the next round.\n       Change spectate target with mouse click.", 10)
				player.SetObserverTarget( playersON[RandomIntRangeInclusive(0,playersON.len()-1)] )
				player.SetSpecReplayDelay( 2 )
                player.StartObserverMode( OBS_MODE_IN_EYE )
				Remote_CallFunction_NonReplay(player, "ServerCallback_KillReplayHud_Activate")
				
				// foreach(sPlayer in playersON)
				// {
				// Message(player, "APEX PROPHUNT", "Player connected! He/she is going to spawn next round." + player.GetPlayerName(), 10)	
				// }
			}
			break
		default:
			break
	}

	
}

void function _OnPlayerDiedPROPHUNT(entity victim, entity attacker, var damageInfo)
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
{
	UpdatePlayerCounts()
	printt("Flowstate DEBUG - Prophunt player killed.", victim, " -by- ", attacker)

	switch(GetGameState())
    {
    case eGameState.Playing:
        // Víctima
        void functionref() victimHandleFunc = void function() : (victim, attacker, damageInfo) {
				victim.Hide()
				entity effect = StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex($"P_ball_tick_exp_CP"), victim.GetOrigin(), <0, 0, 0> )
				EntFireByHandle( effect, "Kill", "", 2, null, null )

				array<entity> playersON = GetPlayerArray_Alive()
				playersON.fastremovebyvalue( victim )
	
			if(!IsValid(victim)) return
			
			wait 0.5
			if(IsValid(victim)){
				
				if(victim != attacker){
                victim.SetObserverTarget( attacker )
				victim.SetSpecReplayDelay( 2 )
                victim.StartObserverMode( OBS_MODE_IN_EYE )
				Remote_CallFunction_NonReplay(victim, "ServerCallback_KillReplayHud_Activate")
				}
				else {
				victim.SetObserverTarget( playersON[0] )
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
				victim.p.PROPHUNT_isSpectatorDiedMidRound = true
			 }
		}

        // Atacante
        void functionref() attackerHandleFunc = void function() : (victim, attacker, damageInfo)
		{
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
				SetTdmStateToNextRound()
				SetGameState(eGameState.MapVoting)				
			}
		}
thread victimHandleFunc()
thread attackerHandleFunc()
        break
    default:
		break
    }
}

void function _HandleRespawnPROPHUNT(entity player)
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
{
	if(!IsValid(player)) return
	printt("Flowstate DEBUG - Tping prophunt player to Lobby.", player)
	
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
				TakeAllWeapons(player)
			}
	
}

bool function returnPropBool(){
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
	return prophunt.cantUseChangeProp
}

void function GiveTeamToProphuntPlayer(entity player)
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
{
	array<entity> IMCplayers = GetPlayerArrayOfTeam(TEAM_IMC)
	array<entity> MILITIAplayers = GetPlayerArrayOfTeam(TEAM_MILITIA)
	

	
	if(IMCplayers.len() > MILITIAplayers.len())
	{
	SetTeam(player, TEAM_MILITIA )
	} else if (MILITIAplayers.len() > IMCplayers.len())
	{
	SetTeam(player, TEAM_IMC )
	} else {
		switch(RandomIntRangeInclusive(0,1))
		{
			case 0:
				SetTeam(player, TEAM_IMC )
				break;
			case 1:
				SetTeam(player, TEAM_MILITIA )
				break;
		}
	}
	printt("Flowstate DEBUG - Giving team to player.", player, player.GetTeam())
}


void function EmitSoundOnSprintingProp()
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
{
		while(prophunt.InProgress)
		{
		array<entity> MILITIAplayers = GetPlayerArrayOfTeam(TEAM_MILITIA)
			foreach(player in MILITIAplayers)
			{
				if(player.IsSprinting() && IsValid(player))
				{
				EmitSoundOnEntity( player, "husaria_sprint_default_3p" )
				} 
			}
		wait 0.2
		}
}


void function EmitWhistleOnProp()
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
{
		while(prophunt.InProgress)
		{
		wait 30 //40 s COD original value: 20.
		array<entity> MILITIAplayers = GetPlayerArrayOfTeam(TEAM_MILITIA)
			foreach(player in MILITIAplayers)
			{
				if(IsValid(player))
				{
				EmitSoundOnEntity( player, "husaria_sprint_default_3p" )
				EmitSoundOnEntity( player, "concrete_bulletimpact_1p_vs_3p" )
				EmitSoundOnEntity( player, "husaria_sprint_default_3p" )
				} 
			}
		}
}

void function CheckForPlayersPlaying()
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
{
	
	while(prophunt.InProgress)
	{
			if(GetPlayerArray().len() == 1)
			{
				SetTdmStateToNextRound()
				foreach(player in GetPlayerArray()){
					Message(player, "ATTENTION", "Not enough players. Round is ending.", 5)
				}
			}
	WaitFrame()	
	}
	printt("Flowstate DEBUG - Ending round cuz not enough players midround")
}

void function PropWatcher(entity prop, entity player)
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
{
	while(prophunt.InProgress && !player.p.PROPHUNT_DestroyProp) 
	{
	WaitFrame()}
	
	if(IsValid(prop))
		prop.Destroy()
}

void function DestroyPlayerPropsPROPHUNT()
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
{
    foreach(prop in prophunt.playerSpawnedProps)
    {
        if(IsValid(prop))
            prop.Destroy()
    }
    prophunt.playerSpawnedProps.clear()
}


void function PROPHUNT_GiveAndManageRandomProp(entity player, bool anglesornah = false)
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
{
			// Using gamestat as boolean Destroy prop y otras cosas más
			//  player.SetPlayerGameStat( PGS_DEFENSE_SCORE, 20)    true 
			//  player.SetPlayerGameStat( PGS_DEFENSE_SCORE, 10)    false
			player.p.PROPHUNT_DestroyProp = true
			if(!anglesornah && IsValid(player)){
					WaitFrame()
					asset selectedModel = prophuntAssetsWE[RandomIntRangeInclusive(0,(prophuntAssetsWE.len()-1))]
					player.p.PROPHUNT_LastModel = selectedModel
					player.kv.solid = 6
					player.kv.CollisionGroup = TRACE_COLLISION_GROUP_PLAYER
					entity prop = CreatePropDynamic(selectedModel, player.GetOrigin(), player.GetAngles(), 6, -1)
					prop.kv.CollisionGroup = TRACE_COLLISION_GROUP_PLAYER
					prop.kv.solid = 6
					prop.SetDamageNotifications( true )
					prop.SetTakeDamageType( DAMAGE_YES )
					prop.AllowMantle()
					prop.SetCanBeMeleed( true )
					prop.SetBoundingBox( < -150, -75, 0 >, <150, 75, 100 >  )
					prop.SetMaxHealth( 100 )
					prop.SetHealth( 100 )
					prop.SetParent(player)
					AddEntityCallback_OnDamaged(prop, NotifyDamageOnProp)
					player.p.PROPHUNT_DestroyProp = false
					WaitFrame()
					thread PropWatcher(prop, player) 
			} else if(anglesornah && IsValid(player)){
					player.p.PROPHUNT_DestroyProp = true
					player.Show()
					player.SetBodyModelOverride( player.p.PROPHUNT_LastModel )
					player.SetArmsModelOverride( player.p.PROPHUNT_LastModel )
					Message(player, "prophunt", "Angles locked.", 1)
					player.kv.solid = SOLID_BBOX
					player.kv.CollisionGroup = TRACE_COLLISION_GROUP_PLAYER
					player.AllowMantle()
					player.SetDamageNotifications( true )
					player.SetTakeDamageType( DAMAGE_YES )
			}
}


void function PlayerwithLockedAngles_OnDamaged(entity ent, var damageInfo)
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
{
	entity attacker = DamageInfo_GetAttacker(damageInfo)
	float damage = DamageInfo_GetDamage( damageInfo )
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
	float NextHealth = ent.GetHealth() - DamageInfo_GetDamage( damageInfo )
	if (NextHealth > 0 && IsValid(ent)){
		ent.SetHealth(NextHealth)
	} else if (IsValid(ent)){
	ent.SetTakeDamageType( DAMAGE_NO )
	ent.SetHealth(0)
	ent.kv.solid = 0
	// ent.SetOwner( attacker )
	// ent.kv.teamnumber = attacker.GetTeam()
	}
}

void function NotifyDamageOnProp(entity ent, var damageInfo)
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
{
//props health bleedthrough
	entity attacker = DamageInfo_GetAttacker(damageInfo)
	entity victim = ent.GetParent()
	float damage = DamageInfo_GetDamage( damageInfo )
	
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
	
	float playerNextHealth = ent.GetHealth() - DamageInfo_GetDamage( damageInfo )
	
	if (playerNextHealth > 0 && IsValid(victim) && IsAlive(victim)){
	victim.SetHealth(playerNextHealth)} else {
	ent.ClearParent()
	victim.SetHealth(0)
	ent.Destroy()}
}

void function ActualPROPHUNTLobby()
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
{
	WaitFrame()
	DestroyPlayerPropsPROPHUNT()
	SetGameState(eGameState.MapVoting)
	SetFallTriggersStatus(true)
	if(GetMapName() == "mp_rr_desertlands_64k_x_64k" || GetMapName() == "mp_rr_desertlands_64k_x_64k_nx" || GetMapName() == "mp_rr_canyonlands_mu1" || GetMapName() == "mp_rr_canyonlands_mu1_night" || GetMapName() == "mp_rr_canyonlands_64k_x_64k")
	{
		thread CreateShipRoomFallTriggers()
	}
	printt("Flowstate DEBUG - Fall triggers created.")

if (FlowState_LockPOI()) {
	prophunt.nextMapIndex = FlowState_LockedPOI()
}else if (!prophunt.mapIndexChanged)
	{
	prophunt.nextMapIndex = (prophunt.nextMapIndex + 1 ) % prophunt.locationsShuffled.len()
	}
	
int choice = prophunt.nextMapIndex
prophunt.mapIndexChanged = false
prophunt.selectedLocation = prophunt.locationsShuffled[choice]
	printt("Flowstate DEBUG - Next location selected: ", prophunt.selectedLocation.name)
	
if(prophunt.selectedLocation.name == "Skill trainer By Colombia"){
    DestroyPlayerPropsPROPHUNT()
    wait 2
	thread SkillTrainerLoad()
	printt("Flowstate DEBUG - Skill trainer loading.")
}
	foreach(player in GetPlayerArray())
	{
			if(IsValid(player))
			{
				player.p.PROPHUNT_isSpectatorDiedMidRound = false
				player.p.PROPHUNT_Max3changes = 0
				player.p.PROPHUNT_DestroyProp = false
				player.UnforceStand()
				player.UnfreezeControlsOnServer()
				Message(player, "APEX PROPHUNT", "                Made by CaféDeColombiaFPS. Game is starting.\n\n" + helpMessagePROPHUNT(), 10)
			}
	WaitFrame()
	}
	wait 10

if(!GetCurrentPlaylistVarBool("flowstatePROPHUNTDebug", false )){
	while(true)
	{
		array<entity> playersON = GetPlayerArray_Alive()
		if(playersON.len() > 1 )
		{
			foreach(player in GetPlayerArray())
			{
			Message(player, "APEX PROPHUNT", "We have enough players, starting now.", 5, "diag_ap_aiNotify_circleMoves10sec")
			}
			wait 5
			break
		} else {
			foreach(player in GetPlayerArray())
			{
				Message(player, "APEX PROPHUNT", "Waiting another player to start. Please wait.", 1)
			}
			wait 5			
		}
		WaitFrame()
	}
}
array<entity> IMCplayers = GetPlayerArrayOfTeam(TEAM_IMC)
array<entity> MILITIAplayers = GetPlayerArrayOfTeam(TEAM_MILITIA)
	foreach(player in MILITIAplayers)
	{
		Message(player, "ATTENTION", "            You're a prop. Teleporting in 5 seconds! \n Use your ULTIMATE to CHANGE PROP up to 3 times. ", 5)
	}
wait 5
}

void function ActualPROPHUNTGameLoop()
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
{
SetTdmStateToInProgress()
printt("Flowstate DEBUG - tdmState is eTDMState.IN_PROGRESS Starting round.")
entity bubbleBoundary = CreateBubbleBoundaryPROPHUNT(prophunt.selectedLocation)
SetGameState(eGameState.Playing)

float endTime = Time() + GetCurrentPlaylistVarFloat("flowstatePROPHUNTLimitTime", 300 )
	array<entity> IMCplayers = GetPlayerArrayOfTeam(TEAM_IMC)
	array<entity> MILITIAplayers = GetPlayerArrayOfTeam(TEAM_MILITIA)

array<LocPair> prophuntSpawns = prophunt.selectedLocation.spawns

ResetDeathPlayersCounterForFirstBloodAnnouncer()
prophunt.cantUseChangeProp = false
prophunt.InProgress = true
thread EmitSoundOnSprintingProp()

printt("Flowstate DEBUG - Tping props team.")
foreach(player in GetPlayerArray())
    {
        if(IsValidPlayer(player))
        {
			//try{TakePassive(player, ePassives.PAS_PILOT_BLOOD)}catch(e420){}
			//Inventory_SetPlayerEquipment(player, WHITE_SHIELD, "armor") //props dont like shields FX
			ClearInvincible(player)
			player.p.playerDamageDealt = 0.0
			if(player.GetTeam() == TEAM_MILITIA){
				vector lastPosForCoolParticles = player.GetOrigin()
				vector lastAngForCoolParticles = player.GetAngles()
				StartParticleEffectInWorld( GetParticleSystemIndex( $"P_impact_shieldbreaker_sparks" ), lastPosForCoolParticles, lastAngForCoolParticles )
				StartParticleEffectInWorld( GetParticleSystemIndex( $"P_impact_shieldbreaker_sparks" ), lastPosForCoolParticles, lastAngForCoolParticles )
				EmitSoundOnEntityOnlyToPlayer( player, player, "PhaseGate_Enter_1p" )
				EmitSoundOnEntityExceptToPlayer( player, player, "PhaseGate_Enter_3p" )
				player.SetOrigin(prophuntSpawns[RandomIntRangeInclusive(0,prophuntSpawns.len()-1)].origin)
				asset selectedModel = prophuntAssetsWE[RandomIntRangeInclusive(0,(prophuntAssetsWE.len()-1))]
				player.p.PROPHUNT_LastModel = selectedModel
				player.kv.solid = 6
				player.kv.CollisionGroup = TRACE_COLLISION_GROUP_PLAYER
				player.Hide()
				entity prop = CreatePropDynamic(selectedModel, player.GetOrigin(), player.GetAngles(), 6, -1)
				prop.kv.solid = 6
				prop.kv.CollisionGroup = TRACE_COLLISION_GROUP_PLAYER
				prop.AllowMantle()
				prop.SetDamageNotifications( true )
				prop.SetTakeDamageType( DAMAGE_YES )
				prop.SetMaxHealth( 100 )	
				prop.SetHealth( 100 )
				prop.SetParent(player)
					AddEntityCallback_OnDamaged(prop, NotifyDamageOnProp)
				player.p.PROPHUNT_DestroyProp = false
					thread PropWatcher(prop, player) //destroys prop on end round and restores player model.
				player.SetThirdPersonShoulderModeOn()
				player.TakeOffhandWeapon(OFFHAND_TACTICAL)
				player.TakeOffhandWeapon(OFFHAND_ULTIMATE)
				player.GiveOffhandWeapon("mp_ability_heal", OFFHAND_TACTICAL)
				player.GiveOffhandWeapon("mp_ability_phase_walk", OFFHAND_ULTIMATE)
				DeployAndEnableWeapons(player)
			} else if(player.GetTeam() == TEAM_IMC){
			Message(player, "PROPS ARE HIDING", "Teleporting in 30 seconds. Please wait.", 10)}
		}
	wait 0.2
	}
if(!GetCurrentPlaylistVarBool("flowstatePROPHUNTDebug", false )){
wait 25} else {wait 2}
foreach(player in GetPlayerArray())
    {
if(player.GetTeam() == TEAM_IMC && IsValid(player)){
ScreenFade( player, 0, 0, 0, 255, 4.0, 1, FFADE_OUT | FFADE_PURGE )}
	}
wait 4
SetFallTriggersStatus(false)
foreach(player in GetPlayerArray())
    {
        if(IsValidPlayer(player))
        {
		if (player.GetTeam() == TEAM_MILITIA){
			Message(player, "ATTENTION", "The attackers have arrived. Use your ULTIMATE to PLACE PROP (lock angles).", 20, "Survival_UI_Ultimate_Ready") }
			else if (player.GetTeam() == TEAM_IMC){
			array<entity> MILITIAplayersAlive = GetPlayerArrayOfTeam_Alive(TEAM_MILITIA)
			Message(player, "ATTENTION", "Kill the props. Props alive: " + MILITIAplayersAlive.len(), 20)
			}				
		}
		
	}
prophunt.cantUseChangeProp = true
printt("Flowstate DEBUG - Tping attackers team.")
foreach(player in IMCplayers)
    {
		if(IsValidPlayer(player))
        {
					//Inventory_SetPlayerEquipment(player, WHITE_SHIELD, "armor")
					ClearInvincible(player)
					EmitSoundOnEntityOnlyToPlayer( player, player, "PhaseGate_Enter_1p" )
					EmitSoundOnEntityExceptToPlayer( player, player, "PhaseGate_Enter_3p" )
					player.SetOrigin(prophuntSpawns[RandomIntRangeInclusive(0,prophuntSpawns.len()-1)].origin)
					player.kv.solid = 6
					player.kv.CollisionGroup = TRACE_COLLISION_GROUP_PLAYER
					player.SetThirdPersonShoulderModeOff()
					string pri = GetCurrentPlaylistVarString("flowstatePROPHUNTweapon1", "~~none~~")
					string sec = GetCurrentPlaylistVarString("flowstatePROPHUNTweapon2", "~~none~~")
					player.TakeNormalWeaponByIndexNow( WEAPON_INVENTORY_SLOT_PRIMARY_0 )
					player.GiveWeapon( pri, WEAPON_INVENTORY_SLOT_PRIMARY_0, [] )
					player.TakeNormalWeaponByIndexNow( WEAPON_INVENTORY_SLOT_PRIMARY_1 )
					player.GiveWeapon( sec, WEAPON_INVENTORY_SLOT_PRIMARY_1, [] )
					player.TakeOffhandWeapon(OFFHAND_TACTICAL)
					player.GiveOffhandWeapon("mp_ability_heal", OFFHAND_TACTICAL)
					//if a player punch a prop, he/she will crash. This is a workaround. Colombia
					//player.GiveWeapon( "mp_weapon_melee_survival", WEAPON_INVENTORY_SLOT_PRIMARY_2, [] )
					//player.GiveOffhandWeapon( "melee_data_knife", OFFHAND_MELEE, [] )
					DeployAndEnableWeapons(player)
		
		}
	}

if(!GetCurrentPlaylistVarBool("flowstatePROPHUNTDebug", false )){	

thread CheckForPlayersPlaying()}
thread EmitWhistleOnProp()

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
		if(GetTDMState() == 1)//eTDMState.NEXT_ROUND_NOW)
		{
			printt("Flowstate DEBUG - tdmState is eTDMState.NEXT_ROUND_NOW Loop ended.")
			break}
		WaitFrame()	
	}
prophunt.InProgress = false
array<entity> MILITIAplayersAlive = GetPlayerArrayOfTeam_Alive(TEAM_MILITIA)	
if(MILITIAplayersAlive.len() > 0){
foreach(player in GetPlayerArray())
    {
		Message(player, "PROPS TEAM WIN", "Props alive: " + MILITIAplayersAlive.len() + ". Swapping teams.", 7, "diag_ap_aiNotify_winnerFound")
		player.SetThirdPersonShoulderModeOn()
		HolsterAndDisableWeapons(player)
	}
} else {
foreach(player in GetPlayerArray())
    {
		Message(player, "ATTACKERS TEAM WIN", "All props are dead. Swapping teams.", 7, "diag_ap_aiNotify_winnerFound")
		player.SetThirdPersonShoulderModeOn()	
		HolsterAndDisableWeapons(player)		
	}	
}
wait 7
UpdatePlayerCounts()
bubbleBoundary.Destroy()
printt("Flowstate DEBUG - Prophunt round finished Swapping teams.")

foreach(player in GetPlayerArray())
    {	
		if(IsValid(player)){
					player.Show()
					//for connected players spectators
				if( player.IsObserver() && !player.p.PROPHUNT_isSpectatorDiedMidRound)
				{
						player.StopObserverMode()
						Remote_CallFunction_NonReplay(player, "ServerCallback_KillReplayHud_Deactivate")
						TakeAllWeapons(player)
						player.SetThirdPersonShoulderModeOn()
						player.MakeVisible()
						GiveTeamToProphuntPlayer(player)
						WaitFrame()
						_HandleRespawnPROPHUNT(player)
						player.UnforceStand()
						player.UnfreezeControlsOnServer()
						
						//for ded players midround
				} else if ( player.IsObserver() && player.p.PROPHUNT_isSpectatorDiedMidRound){
						player.StopObserverMode()
						Remote_CallFunction_NonReplay(player, "ServerCallback_KillReplayHud_Deactivate")
						if(player.GetTeam() == TEAM_IMC){
								TakeAllWeapons(player)
								player.SetThirdPersonShoulderModeOn()
								SetTeam(player, TEAM_MILITIA )
								WaitFrame()
								_HandleRespawnPROPHUNT(player)
								player.MakeVisible()
								player.UnforceStand()
								player.UnfreezeControlsOnServer()
						} else if(player.GetTeam() == TEAM_MILITIA){
								TakeAllWeapons(player)
								player.SetThirdPersonShoulderModeOn()
								SetTeam(player, TEAM_IMC )
								WaitFrame()
								_HandleRespawnPROPHUNT(player)
								player.MakeVisible()
								player.UnforceStand()
								player.UnfreezeControlsOnServer()
						}
					} else {
				 //for alive players swap teams
						if(player.GetTeam() == TEAM_IMC){
								TakeAllWeapons(player)
								player.SetThirdPersonShoulderModeOn()
								SetTeam(player, TEAM_MILITIA )
								WaitFrame()
								_HandleRespawnPROPHUNT(player)
								player.MakeVisible()
								player.UnforceStand()
								player.UnfreezeControlsOnServer()
						
						} else if(player.GetTeam() == TEAM_MILITIA){
								TakeAllWeapons(player)
								player.SetThirdPersonShoulderModeOn()
								SetTeam(player, TEAM_IMC )
								WaitFrame()
								_HandleRespawnPROPHUNT(player)
								player.MakeVisible()
								player.UnforceStand()
								player.UnfreezeControlsOnServer()
						}

					}
		WaitFrame()
	}
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

bool function ClientCommand_NextRoundPROPHUNT(entity player, array<string> args)
{
	if(player.GetPlayerName() == FlowState_Hoster() || player.GetPlayerName() == FlowState_Admin1() || player.GetPlayerName() == FlowState_Admin2() || player.GetPlayerName() == FlowState_Admin3() || player.GetPlayerName() == FlowState_Admin4()) {
		
		if (args.len()) {
				int mapIndex = int(args[0])
				prophunt.nextMapIndex = (((mapIndex >= 0 ) && (mapIndex < prophunt.locationSettings.len())) ? mapIndex : RandomIntRangeInclusive(0, prophunt.locationSettings.len() - 1))
				prophunt.mapIndexChanged = true

				string now = args[0]
				if (now == "now")
				{
				   SetTdmStateToNextRound()
				   prophunt.mapIndexChanged = false
				   prophunt.InProgress = false
				   SetGameState(eGameState.MapVoting)
				}
				
				if(args.len() > 1){
					now = args[1]
					if (now == "now")
					{
					   SetTdmStateToNextRound()
					   prophunt.InProgress = false
					}
				}
		}
	}
	else {
	return false
	}
	return true
}

string function helpMessagePROPHUNT()
//by michae\l/#1125
{
	return " Use your ULTIMATE to CHANGE PROP up to 3 times. \n Use your ULTIMATE to LOCK ANGLES as attackers arrive. "
}
