///////////////////////////////////////////////////////
// ███████ ██       ██████  ██     ██     ███████ ████████  █████  ████████ ███████ 
// ██      ██      ██    ██ ██     ██     ██         ██    ██   ██    ██    ██      
// █████   ██      ██    ██ ██  █  ██     ███████    ██    ███████    ██    █████   
// ██      ██      ██    ██ ██ ███ ██          ██    ██    ██   ██    ██    ██      
// ██      ███████  ██████   ███ ███      ███████    ██    ██   ██    ██    ███████
///////////////////////////////////////////////////////                                                                   
//Credits: 
//CaféDeColombiaFPS (Retículo Endoplasmático#5955) -- owner/main dev
//michae\l/#1125 -- initial help
//AyeZee#6969 -- tdm/ffa dropships and droppods
//everyone else -- advice

global function _CustomTDM_Init
global function _RegisterLocation
global function _RegisterLocationPROPHUNT
global function CharSelect
global function CreateAnimatedLegend
global function Message
global function shuffleArray
global function PROPHUNT_GiveAndManageRandomProp
global bool isBrightWaterByZer0 = false
global function returnPropBool
global function checkforhighpingabuser
global function ClientCommand_ClientMsg
global function	ClientCommand_DispayChatHistory
global function	ClientCommand_RebalanceTeams
global function	ClientCommand_FlowstateKick
global function	ClientCommand_ShowLatency

string WHITE_SHIELD = "armor_pickup_lv1"
string BLUE_SHIELD = "armor_pickup_lv2"
string PURPLE_SHIELD = "armor_pickup_lv3"

#if SERVER
global function GiveFlowstateOvershield
#endif

bool plsTripleAudio = false;
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
	string scriptversion = "v3.0"
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
	array<vector> thisroundDroppodSpawns
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
	bool mapSkyToggle = false
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
array<entity> playerSpawnedProps
array<LocationSettings> locationSettings
array<LocationSettings> locationsShuffled
LocationSettings& selectedLocation
int nextMapIndex = 0
bool mapIndexChanged = true
bool cantUseChangeProp = false
bool InProgress = false
} prophunt



// ██████   █████  ███████ ███████     ███████ ██    ██ ███    ██  ██████ ████████ ██  ██████  ███    ██ ███████
// ██   ██ ██   ██ ██      ██          ██      ██    ██ ████   ██ ██         ██    ██ ██    ██ ████   ██ ██
// ██████  ███████ ███████ █████       █████   ██    ██ ██ ██  ██ ██         ██    ██ ██    ██ ██ ██  ██ ███████
// ██   ██ ██   ██      ██ ██          ██      ██    ██ ██  ██ ██ ██         ██    ██ ██    ██ ██  ██ ██      ██
// ██████  ██   ██ ███████ ███████     ██       ██████  ██   ████  ██████    ██    ██  ██████  ██   ████ ███████

void function _CustomTDM_Init()
{
	printt("Flowstate DEBUG - Executing _CustomTDM_Init")
	SurvivalFreefall_Init() //Enables freefall/skydive
	PrecacheCustomMapsProps()
	
	if(!FlowState_SURF()){
		file.Hoster = FlowState_Hoster()
		file.admin1 = FlowState_Admin1()
		file.admin2 = FlowState_Admin2()
		file.admin3 = FlowState_Admin3()
		file.admin4 = FlowState_Admin4()
	}	

	//gamemodes selection and callbacks. Colombia
	if (GetMapName() == "mp_rr_canyonlands_staging")
		{
		AddCallback_EntitiesDidLoad( OnEntitiesDidLoadFR )
		}
	AddClientCommandCallback("screenshotDevNet_noRPROF", ClientCommand_IsthisevenCrashfixtest)
	AddClientCommandCallback("SetNextHealModType", ClientCommand_IsthisevenCrashfixtest)
	AddCallback_OnClientConnected( void function(entity player) { 
	
	if(FlowState_PROPHUNT()){
		thread _OnPlayerConnectedPROPHUNT(player)	
	} else if (FlowState_SURF()){
		thread _OnPlayerConnectedSURF(player)		
	} else {
		thread _OnPlayerConnected(player) 
	}
		UpdatePlayerCounts()
	})
	
	AddSpawnCallback( "prop_survival", DissolveItem )
	
	AddCallback_OnPlayerKilled(void function(entity victim, entity attacker, var damageInfo) {
	
	if(FlowState_PROPHUNT()){
		thread _OnPlayerDiedPROPHUNT(victim, attacker, damageInfo)
	} else if (FlowState_SURF()){
		thread _OnPlayerDiedSURF(victim, attacker, damageInfo)	
	} else {
		thread _OnPlayerDied(victim, attacker, damageInfo)
	}
	
	})
	//AddClientCommandCallback("mapsky", ClientCommand_ChangeMapSky)
	AddClientCommandCallback("latency", ClientCommand_ShowLatency)
	AddClientCommandCallback("flowstatekick", ClientCommand_FlowstateKick)
	//AddClientCommandCallback("adminnoclip", ClientCommand_adminnoclip)
	AddClientCommandCallback("adminsay", ClientCommand_AdminMsg)
	AddClientCommandCallback("commands", ClientCommand_Help)

	if(FlowState_PROPHUNT()){
		AddClientCommandCallback("next_round", ClientCommand_NextRoundPROPHUNT)
		AddClientCommandCallback("scoreboard", ClientCommand_ScoreboardPROPHUNT)
	} else if (FlowState_SURF()){
		AddClientCommandCallback("spectate", ClientCommand_SpectateSURF) //todo fix this
		AddClientCommandCallback("next_round", ClientCommand_NextRoundSURF)
	} else{
		AddClientCommandCallback("scoreboard", ClientCommand_Scoreboard)
		AddClientCommandCallback("spectate", ClientCommand_SpectateEnemies)
		AddClientCommandCallback("teambal", ClientCommand_RebalanceTeams)
		AddClientCommandCallback("circlenow", ClientCommand_CircleNow)
		AddClientCommandCallback("god", ClientCommand_God)
		AddClientCommandCallback("ungod", ClientCommand_UnGod)
		AddClientCommandCallback("next_round", ClientCommand_NextRound)
	}
	if(FlowState_AllChat() && !FlowState_SURF()){
		AddClientCommandCallback("say", ClientCommand_ClientMsg)
		AddClientCommandCallback("sayhistory", ClientCommand_DispayChatHistory)
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

    if(FlowState_PROPHUNT()){
		thread RunPROPHUNT()
	} else if(FlowState_SURF()){
		thread RunSURF()	
	}else {
		thread RunTDM()}
	
	printt("Flowstate DEBUG - _CustomTDM_Init: All callbacks added, running gamemode thread.")
}

void function OnEntitiesDidLoadFR()
{
	SpawnMapPropsFR()
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
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
{
     switch(GetMapName())
    {
        case "mp_rr_canyonlands_staging":
             return NewLocPair(<26794, -6241, -27479>, <0, 0, 0>)
        case "mp_rr_canyonlands_64k_x_64k":
			return NewLocPair(<-19459, 2127, 18404>, <0, 180, 0>)
		case "mp_rr_ashs_redemption":
            return NewLocPair(<-20917, 5852, -26741>, <0, -90, 0>)
        case "mp_rr_canyonlands_mu1":
        case "mp_rr_canyonlands_mu1_night":
		    return NewLocPair(<-19459, 2127, 18404>, <0, 180, 0>)
        case "mp_rr_desertlands_64k_x_64k":
        case "mp_rr_desertlands_64k_x_64k_nx":
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

void function _OnPropDynamicSpawnedPROPHUNT(entity prop)
{
    prophunt.playerSpawnedProps.append(prop)
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

// void function Flowstate_Stats_Save( entity player )
// {

// }

void function DissolveItem(entity prop)
{
thread DissolveItem_Thread(prop)
}

void function DissolveItem_Thread(entity prop)
{
	wait 4
	if(prop == null || !IsValid(prop))
		return

	entity par = prop.GetParent()
	if(par && par.GetClassName() == "prop_physics" && IsValid(prop))
		prop.Dissolve(ENTITY_DISSOLVE_CORE, <0,0,0>, 200)
}

void function _OnPlayerConnected(entity player)
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
{
    if(!IsValid(player)) return

		printt("Flowstate DEBUG - New player connected. This is called from Custom_TDM flowstate script.", player)
		if(FlowState_ForceCharacter()){
				player.SetPlayerNetBool( "hasLockedInCharacter", true)
				CharSelect(player)
				}
	//CreatePanelText( player, "Flowstate", "", <-19766, 2111, 6541>, <0, 180, 0>, false, 2 )
    GivePassive(player, ePassives.PAS_PILOT_BLOOD)
	SetPlayerSettings(player, TDM_PLAYER_SETTINGS)
			if(FlowState_RandomGunsEverydie())
			{
			Message(player, "FLOWSTATE: FIESTA", "Type 'commands' in console to see the available console commands. ", 10)}
			else if (FlowState_Gungame())
			{
			Message(player, "FLOWSTATE: GUNGAME", "Type 'commands' in console to see the available console commands. ", 10)

			} 
			else { 
			Message(player, "FLOWSTATE: FFA/TDM", "Type 'commands' in console to see the available console commands. ", 10)
			}
	
	switch(GetGameState())
    {
    case eGameState.MapVoting:
			if(IsValid(player) )
			{
				printt("Flowstate DEBUG - Player connected mapvoting.", player)
			    if(!IsAlive(player))
			{
			_HandleRespawn(player)
			ClearInvincible(player)
			}
			player.SetThirdPersonShoulderModeOn()
						if(FlowState_RandomGunsEverydie()){
			UpgradeShields(player, true)
			}
						if(FlowState_Gungame()){
			KillStreakAnnouncer(player, true)
			}
			player.UnforceStand()
			player.FreezeControlsOnServer()
			}
		break
	case eGameState.WaitingForPlayers:
		if(IsValid(player))
		{
			printt("Flowstate DEBUG - Player connected waitingforplayers.", player)
			_HandleRespawn(player)
			ClearInvincible(player)
			player.UnfreezeControlsOnServer()
		}
        break
    case eGameState.Playing:
	    if(IsValid(player))
        {
			printt("Flowstate DEBUG - Player connected midround.", player)
			player.UnfreezeControlsOnServer()
			
			_HandleRespawn(player)
			if(file.tdmState == eTDMState.NEXT_ROUND_NOW || !GetCurrentPlaylistVarBool("flowstateDroppodsOnPlayerConnected", false ) || GetMapName() == "mp_rr_canyonlands_staging" || file.selectedLocation.name == "Skill trainer By Colombia" || file.selectedLocation.name == "Custom map by Biscutz" || file.selectedLocation.name == "White Forest By Zer0Bytes" || file.selectedLocation.name == "Brightwater By Zer0bytes" )
			{
	
					printt("Flowstate DEBUG - Can't spawn player in droppod. Droppods disabled, or we are changing map. Spawning with normal mode", player)
					_HandleRespawn(player)

			} else {
				
				printt("Flowstate DEBUG: Map index:" + file.nextMapIndex + "end")
				printt("Flowstate DEBUG: Map index:" + file.selectedLocation.name + "end")
				printt("Flowstate DEBUG - Spawning player in droppod", player)
				player.p.isPlayerSpawningInDroppod = true
				thread AirDropFireteam( file.thisroundDroppodSpawns[RandomIntRangeInclusive(0, file.thisroundDroppodSpawns.len()-1)] + <0,0,15000>, <0,180,0>, "idle", 0, "droppod_fireteam", player )
				_HandleRespawn(player, true)
				player.SetAngles( <0,180,0> )
			}
			ClearInvincible(player)
			if(FlowState_RandomGunsEverydie()){
				UpgradeShields(player, true)
			}

			if(FlowState_Gungame()){
				KillStreakAnnouncer(player, true)
			}

			}
        break
    default:
			printt("Flowstate DEBUG - This is unreachable.", player)
        break
    }
	//thread debugplayerlatency(player)			
		
				// player.SetPersistentVar( "FlowstateSTATS[1].eHandle", player.GetEncodedEHandle() )
				// player.SetPersistentVar( "FlowstateSTATS[1].kills", 9999999 )
				//printt("Flowstate DEBUG - SAVED KIILS FOR THIS USER: ", player.GetPlayerName(), player.GetPersistentVarAsInt( "FlowstateSTATS[1].kills"))
				// info.uid = player.GetPlatformUID()
				// info.hardware = player.GetHardware()
				
				
	thread checkforhighpingabuser(player)
}

void function checkforhighpingabuser(entity player)
{
				//kick players with high ping
				wait 12		
				if(!IsValid(player)) return
				if ((int(player.GetLatency()* 1000) - 40) > FlowState_MaxPingAllowed() && IsValid(player) && FlowState_KickHighPingPlayer()){

					player.FreezeControlsOnServer()
					player.ForceStand()
					HolsterAndDisableWeapons( player )
					Message(player, "FLOWSTATE KICK", "Your ping is too high: " + (int(player.GetLatency()* 1000) - 40), 3)
					wait 3
					if(IsValid(player)) printt("Flowstate DEBUG - Disconnecting a high ping abuser: ", player)
					if(IsValid(player)) ClientCommand( player, "disconnect" )
					UpdatePlayerCounts()
				} else if(IsValid(player) && GameRules_GetGameMode() == "custom_tdm"){
					Message(player, "APEX FLOWSTATE", "             Enjoy your stay, " + player.GetPlayerName() + "\n Your latency: " + (int(player.GetLatency()* 1000) - 40) + " - Your OriginID: " + player.GetPlatformUID() + ".", 5)
				}
}

void function doubletriplekillaudio(entity victim, entity attacker)
{
	entity champion = file.previousChampion
	entity challenger = file.previousChallenger
	entity killeader = GetBestPlayer()
	float doubleKillTime = 5.0
	float tripleKillTime = 8.0
	
	if(!IsValid(attacker)) return
	
	if(attacker == file.lastKiller && attacker == killeader && !plsTripleAudio){
		attacker.p.downedEnemyAtOneTime = 2
		printt("Flowstate DEBUG - A player did a DOUBLE kill.", attacker)
	} else if (attacker == file.lastKiller && attacker == killeader && plsTripleAudio)
	{
		attacker.p.downedEnemyAtOneTime = 3	
	}
	if((Time() - attacker.p.lastKillTimer) < doubleKillTime && attacker == file.lastKiller && attacker == killeader && attacker.p.downedEnemyAtOneTime == 2){
		foreach (player in GetPlayerArray())
		{
		thread EmitSoundOnEntityOnlyToPlayer( player, player, "diag_ap_aiNotify_killLeaderDoubleKill" )
		}
		if(FlowState_ChosenCharacter() == 8)
		{
			thread EmitSoundOnEntityOnlyToPlayer( attacker, attacker, "diag_mp_wraith_bc_iDownedMultiple_1p" )
		}
		plsTripleAudio = true;
	}
	
	if((Time() - attacker.p.lastKillTimer) < tripleKillTime && attacker == file.lastKiller && attacker == killeader && attacker.p.downedEnemyAtOneTime == 3){
		attacker.p.downedEnemyAtOneTime = 0
		wait 1
		printt("Flowstate DEBUG - A player did a TRIPLE kill.", attacker)
		foreach (player in GetPlayerArray())
		{
		thread EmitSoundOnEntityOnlyToPlayer( player, player, "diag_ap_aiNotify_killLeaderTripleKill" )
		}
		plsTripleAudio = false;
	}
}

void function _OnPlayerDied(entity victim, entity attacker, var damageInfo)
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
{
	if (FlowState_RandomGunsEverydie() && FlowState_FIESTADeathboxes())
			{		
			CreateFlowStateDeathBoxForPlayer(victim, attacker, damageInfo)
			}
		printt("Flowstate DEBUG - _OnPlayerDied. ", victim, " - by - ", attacker)
		
	switch(GetGameState())
    {
    case eGameState.Playing:
        // Víctima
        void functionref() victimHandleFunc = void function() : (victim, attacker, damageInfo) {
				wait 1
				if(!IsValid(victim)) return
				if(file.tdmState != eTDMState.NEXT_ROUND_NOW){
					if(Spectator_GetReplayIsEnabled() && IsValid(victim) && IsValid(attacker) && ShouldSetObserverTarget( attacker )){
						victim.SetObserverTarget( attacker )
						victim.SetSpecReplayDelay( 4 )
						victim.StartObserverMode( OBS_MODE_IN_EYE )
						Remote_CallFunction_NonReplay(victim, "ServerCallback_KillReplayHud_Activate")
					}
				}
				
				int invscore = victim.GetPlayerGameStat( PGS_DEATHS )
					invscore++
					victim.SetPlayerGameStat( PGS_DEATHS, invscore)
					
					//Add a death to the victim
					int invscore2 = victim.GetPlayerNetInt( "assists" )
					invscore2++
					victim.SetPlayerNetInt( "assists", invscore2 )

									if(FlowState_RandomGunsEverydie()){
						UpgradeShields(victim, true)
						}
						
						if(FlowState_Gungame())
						{
						KillStreakAnnouncer(victim, true)
						}
						
				if(file.tdmState != eTDMState.NEXT_ROUND_NOW){
				wait 8 }
				
				if(IsValid(victim) )
				{
				_HandleRespawn( victim )
				ClearInvincible(victim)
				}
		}

        // Atacante
        void functionref() attackerHandleFunc = void function() : (victim, attacker, damageInfo)
		{
			if(IsValid(attacker) && attacker.IsPlayer() && IsAlive(attacker) && attacker != victim)
            {		
				//Heal
				if(FlowState_RandomGunsEverydie() && FlowState_FIESTAShieldsStreak()){
				PlayerRestoreHPFIESTA(attacker, 100)
				UpgradeShields(attacker, false)
				} else {
				PlayerRestoreHP(attacker, 100, Equipment_GetDefaultShieldHP())
				}
				
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
				
				if(attacker.IsPlayer()) attacker.p.lastKillTimer = Time()
			}
        }
		thread victimHandleFunc()
        thread attackerHandleFunc()
		
        break
    default:
		_HandleRespawn(victim)
		break
    }
	
	file.deathPlayersCounter++
	if(file.deathPlayersCounter == 1 )
	{
			foreach (player in GetPlayerArray())
			{
				thread EmitSoundOnEntityExceptToPlayer( player, player, "diag_ap_aiNotify_diedFirst" )
			}
	}
	
	if(attacker.IsPlayer()) {
	//thread doubletriplekillaudio(victim,attacker)
	file.lastKiller = attacker
	}
	UpdatePlayerCounts()
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

	if(IsValid( player ) && !IsAlive(player))
    {
		
        if(Equipment_GetRespawnKitEnabled() && !FlowState_Gungame())
        {
			DecideRespawnPlayer(player, true)
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
                GiveWeaponsFromStoredArray(player, player.p.storedWeapons)
            }
        }
    }
	
	if( IsValid( player ) && IsAlive(player)){
		
			if(!isDroppodSpawn){
			printt("Flowstate DEBUG - TPing player to spawn point from _HandleRespawn", player)
			TpPlayerToSpawnPoint(player)}
			
		player.UnfreezeControlsOnServer()

		if(FlowState_RandomGunsEverydie() && FlowState_FIESTAShieldsStreak()){
				PlayerRestoreShieldsFIESTA(player, player.GetShieldHealthMax())
				PlayerRestoreHPFIESTA(player, 100)
				} else {
		PlayerRestoreHP(player, 100, Equipment_GetDefaultShieldHP())
				}

		player.TakeNormalWeaponByIndexNow( WEAPON_INVENTORY_SLOT_PRIMARY_2 )
		player.TakeOffhandWeapon( OFFHAND_MELEE )
		player.TakeOffhandWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_2 )
		player.GiveWeapon( "mp_weapon_melee_survival", WEAPON_INVENTORY_SLOT_PRIMARY_2, [] )
		player.GiveOffhandWeapon( "melee_data_knife", OFFHAND_MELEE, [] )

		}
		
	if (FlowState_RandomGuns() && !FlowState_Gungame() && IsValid( player ))
    {
		try{
		player.TakeNormalWeaponByIndexNow( WEAPON_INVENTORY_SLOT_PRIMARY_0 )
        player.TakeNormalWeaponByIndexNow( WEAPON_INVENTORY_SLOT_PRIMARY_1 )
		player.TakeNormalWeaponByIndexNow( WEAPON_INVENTORY_SLOT_PRIMARY_2 )
        GiveRandomPrimaryWeapon(file.randomprimary, player)
        GiveRandomSecondaryWeapon(file.randomsecondary, player)
        player.GiveWeapon( "mp_weapon_melee_survival", WEAPON_INVENTORY_SLOT_PRIMARY_2, [] )
        player.GiveOffhandWeapon( "melee_data_knife", OFFHAND_MELEE, [] )
		} catch (e) {}
    } else if(FlowState_RandomGunsMetagame() && !FlowState_Gungame() && IsValid( player ))
	{
		try{
		player.TakeNormalWeaponByIndexNow( WEAPON_INVENTORY_SLOT_PRIMARY_0 )
		player.TakeNormalWeaponByIndexNow( WEAPON_INVENTORY_SLOT_PRIMARY_1 )
		player.TakeNormalWeaponByIndexNow( WEAPON_INVENTORY_SLOT_PRIMARY_2 )
        GiveRandomPrimaryWeaponMetagame(file.randomprimary, player)
        GiveRandomSecondaryWeaponMetagame(file.randomsecondary, player)
        player.GiveWeapon( "mp_weapon_melee_survival", WEAPON_INVENTORY_SLOT_PRIMARY_2, [] )
        player.GiveOffhandWeapon( "melee_data_knife", OFFHAND_MELEE, [] )
		} catch (e) {}
	}
	if(FlowState_RandomTactical() && IsValid( player ) || FlowState_GungameRandomAbilities() && IsValid( player ))
	{
		player.TakeOffhandWeapon(OFFHAND_TACTICAL)
		file.randomtac = RandomIntRangeInclusive( 0, 7 )
        GiveRandomTac(file.randomtac, player)
	}
	if(FlowState_RandomUltimate() && IsValid( player ) || FlowState_GungameRandomAbilities() && IsValid( player ))
	{
    player.TakeOffhandWeapon(OFFHAND_ULTIMATE)
		file.randomult = RandomIntRangeInclusive( 0, 5 )
        GiveRandomUlt(file.randomult, player)
	}
	if(FlowState_RandomGunsEverydie() && !FlowState_Gungame() && IsValid( player )) //fiesta
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
	if(FlowState_Gungame() && IsValid( player ))
	{
		GiveGungameWeapon(player)
	}
	
	thread WpnPulloutOnRespawn(player)
	//try { player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 ).SetWeaponPrimaryClipCount( player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 ).GetWeaponPrimaryClipCountMax())} catch(this_is_a_unique_string_dont_crash_u_bitch){}
	//try { player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_1 ).SetWeaponPrimaryClipCount( player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_1 ).GetWeaponPrimaryClipCountMax())} catch(this_is_a_unique_string_dont_crash_u_bitch2){}
	printt("Flowstate DEBUG - _HandleRespawn finished for player.", player)
	// try { player.GetOffhandWeapon( OFFHAND_INVENTORY ).SetWeaponPrimaryClipCount( player.GetOffhandWeapon( OFFHAND_INVENTORY ).GetWeaponPrimaryClipCountMax() )} catch(this_is_a_unique_string_dont_crash_u_bitch3){}
	// try { player.GetOffhandWeapon( OFFHAND_LEFT ).SetWeaponPrimaryClipCount( player.GetOffhandWeapon( OFFHAND_LEFT ).GetWeaponPrimaryClipCountMax() )} catch(this_is_a_unique_string_dont_crash_u_bitch4){}
}

void function TpPlayerToSpawnPoint(entity player)
{
	LocPair loc = _GetAppropriateSpawnLocation(player)
    player.SetOrigin(loc.origin)
    player.SetAngles(loc.angles)
    //PutEntityInSafeSpot( player, null, null, player.GetOrigin() + <0,0,100>, player.GetOrigin() )
}

void function GrantSpawnImmunity(entity player, float duration)
{
	if(!IsValid(player)) return
	
    MakeInvincible(player)	
	wait duration

	if(IsValid(player))
		ClearInvincible(player)
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

	if (FlowState_AutoreloadOnKillPrimary() && IsValid(primary)) {
		primary.SetWeaponPrimaryClipCount(primary.GetWeaponPrimaryClipCountMax())
	}

	if (FlowState_AutoreloadOnKillSecondary() && IsValid(primary)) {
		sec.SetWeaponPrimaryClipCount(sec.GetWeaponPrimaryClipCountMax())
	}
}

void function WpnPulloutOnRespawn(entity player)
///////////////////////////////////////////////////////
//By Retículo Endoplasmático#5955 and michae\l/#1125 //
///////////////////////////////////////////////////////
{
	if( IsValid( player ) && IsAlive(player))
        {
		entity primary = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 )
		entity sec = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_1 )
		if(IsValid(sec))
			player.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_1)
		wait 0.7
		if(IsValid(primary))
			player.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_0)
		}
}


void function SummonPlayersInACircle(entity player0)
{
	printt("Flowstate DEBUG - Circle fight invoked.", player0)
	vector pos = player0.GetOrigin()
	pos.z += 5
	int i = 0
	Message(player0,"CIRCLE FIGHT NOW!", "", 5)
	foreach ( player in GetPlayerArray() )
	{
		if(!IsValid(player)) continue
		if ( player == player0 ) continue
		
		float r = float(i) / float(GetPlayerArray().len()) * 2 * PI
		TeleportFRPlayer(player, pos + 150.0 * <sin( r ), cos( r ), 0.0>, <0, 0, 0>)
		Message(player,"CIRCLE FIGHT NOW!", "", 5)
		i++
	}
}

void function GiveRandomPrimaryWeaponMetagame(int random, entity player)
{
	printt("Flowstate DEBUG - Giving random primary weapon metagame. Index " + random)
    switch(random)
    {
        case 0:
            player.GiveWeapon( "mp_weapon_r97", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_classic", "barrel_stabilizer_l4_flash_hider", "stock_tactical_l3", "bullets_mag_l3"] )
            break
        case 1:
            player.GiveWeapon( "mp_weapon_rspn101", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_bruiser", "barrel_stabilizer_l4_flash_hider", "stock_tactical_l3", "bullets_mag_l3"] )
            break
        case 2:
            player.GiveWeapon( "mp_weapon_vinson", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_bruiser", "stock_tactical_l3", "highcal_mag_l3"] )
            break
    }
}

void function GiveRandomSecondaryWeaponMetagame(int random, entity player)
{
	printt("Flowstate DEBUG - Giving random secondary weapon metagame.", player)	
    switch(random)
    {
        case 0:
            player.GiveWeapon( "mp_weapon_wingman", WEAPON_INVENTORY_SLOT_PRIMARY_1, ["optic_cq_hcog_classic", "highcal_mag_l2"] )
            break
        case 1:
            player.GiveWeapon( "mp_weapon_energy_shotgun", WEAPON_INVENTORY_SLOT_PRIMARY_1, ["shotgun_bolt_l2"] )
            break
        case 2:
            player.GiveWeapon( "mp_weapon_shotgun", WEAPON_INVENTORY_SLOT_PRIMARY_1, ["shotgun_bolt_l2"] )
            break
        case 3:
            player.GiveWeapon( "mp_weapon_mastiff", WEAPON_INVENTORY_SLOT_PRIMARY_1)
            break
		case 4:
            player.GiveWeapon( "mp_weapon_wingman", WEAPON_INVENTORY_SLOT_PRIMARY_1, ["optic_cq_hcog_classic", "highcal_mag_l1"] )
            break
    }
}

void function GiveRandomPrimaryWeapon(int random, entity player)
{
	printt("Flowstate DEBUG - Giving random primary weapon.", player)
    switch(random)
    {
        case 0:
            player.GiveWeapon( "mp_weapon_r97", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_classic", "barrel_stabilizer_l4_flash_hider", "stock_tactical_l3", "bullets_mag_l2"] )
            break
        case 1:
            player.GiveWeapon( "mp_weapon_rspn101", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_bruiser", "barrel_stabilizer_l4_flash_hider", "stock_tactical_l3", "bullets_mag_l2"] )
            break
        case 2:
            player.GiveWeapon( "mp_weapon_vinson", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_bruiser", "stock_tactical_l3", "highcal_mag_l3"] )
            break
        case 3:
            player.GiveWeapon( "mp_weapon_hemlok", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_bruiser", "stock_tactical_l3", "highcal_mag_l3", "barrel_stabilizer_l4_flash_hider"] )
            break
        case 4:
            player.GiveWeapon( "mp_weapon_pdw", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_classic", "stock_tactical_l3", "highcal_mag_l3"] )
            break
		case 5:
			player.GiveWeapon( "mp_weapon_lmg", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_bruiser", "highcal_mag_l3", "barrel_stabilizer_l3", "stock_tactical_l3" ] )
            break 
		case 6:
            player.GiveWeapon( "mp_weapon_rspn101", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_classic", "stock_tactical_l1", "bullets_mag_l2"] )
            break
		case 7:
            player.GiveWeapon( "mp_weapon_energy_ar", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_bruiser", "energy_mag_l3", "stock_tactical_l3", "hopup_turbocharger"] )
            break
		case 8:
            player.GiveWeapon( "mp_weapon_alternator_smg", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_classic", "bullets_mag_l3", "stock_tactical_l3"] )
            break
		case 9:
            player.GiveWeapon( "mp_weapon_lstar", WEAPON_INVENTORY_SLOT_PRIMARY_0)
            break
		case 10:
            player.GiveWeapon( "mp_weapon_esaw", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_bruiser", "energy_mag_l1", "barrel_stabilizer_l2"] )
            break
		case 11:
            player.GiveWeapon( "mp_weapon_rspn101", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_classic", "bullets_mag_l1", "barrel_stabilizer_l1", "stock_tactical_l1"] )
            break
		case 12:
            player.GiveWeapon( "mp_weapon_wingman", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["highcal_mag_l1"] )
            break
		case 13:
            player.GiveWeapon( "mp_weapon_vinson", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["stock_tactical_l1", "highcal_mag_l2"] )
            break
		case 14:
            player.GiveWeapon( "mp_weapon_r97", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_threat", "bullets_mag_l1", "barrel_stabilizer_l3", "stock_tactical_l1"] )
            break
		case 15:
            player.GiveWeapon( "mp_weapon_dmr", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_bruiser", "highcal_mag_l2", "barrel_stabilizer_l2", "stock_sniper_l3"] )
            break
		case 16:
            player.GiveWeapon( "mp_weapon_pdw", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["stock_tactical_l1", "highcal_mag_l1"] )
            break
		case 17:
            player.GiveWeapon( "mp_weapon_esaw", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_classic", "energy_mag_l1", "barrel_stabilizer_l4_flash_hider"] )
            break
		case 18:
            player.GiveWeapon( "mp_weapon_alternator_smg", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_classic", "barrel_stabilizer_l2"] )
            break
		case 19:
            player.GiveWeapon( "mp_weapon_sniper", WEAPON_INVENTORY_SLOT_PRIMARY_0)
            break
		case 20:
            player.GiveWeapon( "mp_weapon_esaw", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_holosight_variable"])
            break
		case 21:
            player.GiveWeapon( "mp_weapon_rspn101", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_holosight_variable"])
            break
		case 22:
            player.GiveWeapon( "mp_weapon_vinson", WEAPON_INVENTORY_SLOT_PRIMARY_0)
            break
		case 23:
            player.GiveWeapon( "mp_weapon_r97", WEAPON_INVENTORY_SLOT_PRIMARY_0 )
            break

    }
}

void function GiveRandomSecondaryWeapon(int random, entity player)
{
	printt("Flowstate DEBUG - Giving random secondary weapon.", player)
    switch(random)
    {
        case 0:
            player.GiveWeapon( "mp_weapon_wingman", WEAPON_INVENTORY_SLOT_PRIMARY_1, ["optic_cq_hcog_classic", "highcal_mag_l1"] )
            break
        case 1:
            player.GiveWeapon( "mp_weapon_energy_shotgun", WEAPON_INVENTORY_SLOT_PRIMARY_1, ["shotgun_bolt_l1"] )
            break
        case 2:
            player.GiveWeapon( "mp_weapon_shotgun", WEAPON_INVENTORY_SLOT_PRIMARY_1, ["shotgun_bolt_l1"] )
            break
        case 3:
            player.GiveWeapon( "mp_weapon_mastiff", WEAPON_INVENTORY_SLOT_PRIMARY_1)
            break
		case 4:
            player.GiveWeapon( "mp_weapon_autopistol", WEAPON_INVENTORY_SLOT_PRIMARY_1, ["optic_cq_hcog_classic", "bullets_mag_l1"] )
            break
		case 5:
            player.GiveWeapon( "mp_weapon_shotgun_pistol", WEAPON_INVENTORY_SLOT_PRIMARY_1, ["shotgun_bolt_l3"] )
            break
		case 6:
            player.GiveWeapon( "mp_weapon_defender", WEAPON_INVENTORY_SLOT_PRIMARY_1, ["optic_ranged_hcog", "stock_sniper_l2"] )
            break
		case 7:
            player.GiveWeapon( "mp_weapon_wingman", WEAPON_INVENTORY_SLOT_PRIMARY_1)
            break
        case 8:
            player.GiveWeapon( "mp_weapon_energy_shotgun", WEAPON_INVENTORY_SLOT_PRIMARY_1)
            break
        case 9:
            player.GiveWeapon( "mp_weapon_shotgun", WEAPON_INVENTORY_SLOT_PRIMARY_1)
            break
        case 10:
            player.GiveWeapon( "mp_weapon_mastiff", WEAPON_INVENTORY_SLOT_PRIMARY_1)
            break
		case 11:
            player.GiveWeapon( "mp_weapon_autopistol", WEAPON_INVENTORY_SLOT_PRIMARY_1)
            break
		case 12:
            player.GiveWeapon( "mp_weapon_shotgun_pistol", WEAPON_INVENTORY_SLOT_PRIMARY_1)
            break
		case 13:
            player.GiveWeapon( "mp_weapon_defender", WEAPON_INVENTORY_SLOT_PRIMARY_1, ["optic_sniper", "stock_sniper_l2"] )
            break
		case 14:
            player.GiveWeapon( "mp_weapon_doubletake", WEAPON_INVENTORY_SLOT_PRIMARY_1, ["energy_mag_l3"] )
            break
		case 15:
            player.GiveWeapon( "mp_weapon_g2", WEAPON_INVENTORY_SLOT_PRIMARY_1, ["bullets_mag_l3", "barrel_stabilizer_l4_flash_hider", "stock_sniper_l3", "hopup_double_tap"] )
            break
		case 16:
            player.GiveWeapon( "mp_weapon_g2", WEAPON_INVENTORY_SLOT_PRIMARY_1)
            break
		case 17:
            player.GiveWeapon( "mp_weapon_semipistol", WEAPON_INVENTORY_SLOT_PRIMARY_1, ["bullets_mag_l2"] )
            break
		case 18:
            player.GiveWeapon( "mp_weapon_semipistol", WEAPON_INVENTORY_SLOT_PRIMARY_1)
            break
    }
}

void function GiveActualGungameWeapon(int index, entity player)
{
	printt("Flowstate DEBUG - Giving gungame weapon.", player, index)
    switch(index)
    {
        case 0:
            player.GiveWeapon( "mp_weapon_r97", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_classic", "barrel_stabilizer_l4_flash_hider", "stock_tactical_l3", "bullets_mag_l2"] )
            break
        case 1:
            player.GiveWeapon( "mp_weapon_wingman", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_classic", "highcal_mag_l1"] )
            break
        case 2:
            player.GiveWeapon( "mp_weapon_rspn101", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_bruiser", "barrel_stabilizer_l4_flash_hider", "stock_tactical_l3", "bullets_mag_l2"] )
            break
		case 3:
            player.GiveWeapon( "mp_weapon_energy_shotgun", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["shotgun_bolt_l1"] )
            break
        case 4:
            player.GiveWeapon( "mp_weapon_vinson", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_bruiser", "stock_tactical_l3", "highcal_mag_l3"] )
            break
        case 5:
            player.GiveWeapon( "mp_weapon_shotgun", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["shotgun_bolt_l1"] )
            break
        case 6:
            player.GiveWeapon( "mp_weapon_hemlok", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_bruiser", "stock_tactical_l3", "highcal_mag_l3", "barrel_stabilizer_l4_flash_hider"] )
            break
        case 7:
            player.GiveWeapon( "mp_weapon_mastiff", WEAPON_INVENTORY_SLOT_PRIMARY_0)
            break
        case 8:
            player.GiveWeapon( "mp_weapon_pdw", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_classic", "stock_tactical_l3", "highcal_mag_l3"] )
            break
		case 9:
            player.GiveWeapon( "mp_weapon_autopistol", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_classic", "bullets_mag_l1"] )
            break
		case 10:
			player.GiveWeapon( "mp_weapon_lmg", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_bruiser", "highcal_mag_l3", "barrel_stabilizer_l3", "stock_tactical_l3" ] )
            break 
		case 11:
            player.GiveWeapon( "mp_weapon_shotgun_pistol", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["shotgun_bolt_l3"] )
            break
		case 12:
            player.GiveWeapon( "mp_weapon_rspn101", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_classic", "stock_tactical_l1", "bullets_mag_l2"] )
            break
		case 13:
            player.GiveWeapon( "mp_weapon_defender", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_ranged_hcog", "stock_sniper_l2"] )
            break
		case 14:
            player.GiveWeapon( "mp_weapon_energy_ar", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_bruiser", "energy_mag_l3", "stock_tactical_l3", "hopup_turbocharger"] )
            break
		case 15:
            player.GiveWeapon( "mp_weapon_wingman", WEAPON_INVENTORY_SLOT_PRIMARY_0)
            break
		case 16:
            player.GiveWeapon( "mp_weapon_alternator_smg", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_classic", "bullets_mag_l3", "stock_tactical_l3"] )
            break
		case 17:
            player.GiveWeapon( "mp_weapon_semipistol", WEAPON_INVENTORY_SLOT_PRIMARY_0)
            break
		case 18:
            player.GiveWeapon( "mp_weapon_lstar", WEAPON_INVENTORY_SLOT_PRIMARY_0)
            break
		case 19:
            player.GiveWeapon( "mp_weapon_g2", WEAPON_INVENTORY_SLOT_PRIMARY_0)
            break
		case 20:
            player.GiveWeapon( "mp_weapon_shotgun_pistol", WEAPON_INVENTORY_SLOT_PRIMARY_0)
            break
		case 21:
            player.GiveWeapon( "mp_weapon_esaw", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_bruiser", "energy_mag_l1", "barrel_stabilizer_l2"] )
            break
		case 22:
            player.GiveWeapon( "mp_weapon_doubletake", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["energy_mag_l3"] )
            break
		case 23:
            player.GiveWeapon( "mp_weapon_rspn101", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_classic", "bullets_mag_l1", "barrel_stabilizer_l1", "stock_tactical_l1"] )
            break
		case 24:
            player.GiveWeapon( "mp_weapon_wingman", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["highcal_mag_l1"] )
            break
		case 25:
            player.GiveWeapon( "mp_weapon_shotgun", WEAPON_INVENTORY_SLOT_PRIMARY_0)
            break
        case 26:
            player.GiveWeapon( "mp_weapon_energy_shotgun", WEAPON_INVENTORY_SLOT_PRIMARY_0)
            break
		case 27:
            player.GiveWeapon( "mp_weapon_vinson", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["stock_tactical_l1", "highcal_mag_l2"] )
            break
		case 28:
            player.GiveWeapon( "mp_weapon_r97", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_threat", "bullets_mag_l1", "barrel_stabilizer_l3", "stock_tactical_l1"] )
            break
		case 29:
            player.GiveWeapon( "mp_weapon_autopistol", WEAPON_INVENTORY_SLOT_PRIMARY_0)
            break
		case 30:
            player.GiveWeapon( "mp_weapon_mastiff", WEAPON_INVENTORY_SLOT_PRIMARY_0)
            break
		case 31:
            player.GiveWeapon( "mp_weapon_dmr", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_bruiser", "highcal_mag_l2", "barrel_stabilizer_l2", "stock_sniper_l3"] )
            break
		case 32:
            player.GiveWeapon( "mp_weapon_pdw", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["stock_tactical_l1", "highcal_mag_l1"] )
            break
		case 33:
            player.GiveWeapon( "mp_weapon_esaw", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_classic", "energy_mag_l1", "barrel_stabilizer_l4_flash_hider"] )
            break
		case 34:
            player.GiveWeapon( "mp_weapon_alternator_smg", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_hcog_classic", "barrel_stabilizer_l2"] )
            break
		case 35:
            player.GiveWeapon( "mp_weapon_sniper", WEAPON_INVENTORY_SLOT_PRIMARY_0)
            break
		case 36:
            player.GiveWeapon( "mp_weapon_defender", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_sniper", "stock_sniper_l2"] )
            break
		case 37:
            player.GiveWeapon( "mp_weapon_esaw", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_holosight_variable"])
            break
		case 38:
            player.GiveWeapon( "mp_weapon_rspn101", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["optic_cq_holosight_variable"])
            break
		case 39:
            player.GiveWeapon( "mp_weapon_vinson", WEAPON_INVENTORY_SLOT_PRIMARY_0)
            break
		case 40:
            player.GiveWeapon( "mp_weapon_r97", WEAPON_INVENTORY_SLOT_PRIMARY_0 )
            break
		case 41:
            player.GiveWeapon( "mp_weapon_g2", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["bullets_mag_l3", "barrel_stabilizer_l4_flash_hider", "stock_sniper_l3", "hopup_double_tap"] )
            break
		case 42:
            player.GiveWeapon( "mp_weapon_semipistol", WEAPON_INVENTORY_SLOT_PRIMARY_0, ["bullets_mag_l2"] )
            break

    }
}

void function GiveRandomTac(int random, entity player)
{
	printt("Flowstate DEBUG - Giving random tactical.", player)
    switch(random)
    {
        case 0:
            player.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
            break
        case 1:
            player.GiveOffhandWeapon("mp_ability_phase_walk", OFFHAND_TACTICAL)
            break
        case 2:
            player.GiveOffhandWeapon("mp_ability_heal", OFFHAND_TACTICAL)
            break
		case 3:
            player.GiveOffhandWeapon("mp_weapon_bubble_bunker", OFFHAND_TACTICAL)
            break
		case 4:
            player.GiveOffhandWeapon("mp_weapon_grenade_bangalore", OFFHAND_TACTICAL)
            break
		case 5:
            player.GiveOffhandWeapon("mp_ability_area_sonar_scan", OFFHAND_TACTICAL)
            break
		case 6:
            player.GiveOffhandWeapon("mp_weapon_grenade_sonar", OFFHAND_TACTICAL)
            break
		case 7:
            player.GiveOffhandWeapon("mp_weapon_deployable_cover", OFFHAND_TACTICAL)
            break			
    }
}

void function GiveRandomUlt(int random, entity player )
{
		printt("Flowstate DEBUG - Giving random ultimate.", player)

    switch(random)
    {
        case 0:
            player.GiveOffhandWeapon("mp_weapon_grenade_gas", OFFHAND_ULTIMATE)
            break
        case 1:
            player.GiveOffhandWeapon("mp_weapon_jump_pad", OFFHAND_ULTIMATE)
            break
        case 2:
            player.GiveOffhandWeapon("mp_weapon_phase_tunnel", OFFHAND_ULTIMATE)
            break
		case 3:
            player.GiveOffhandWeapon("mp_ability_3dash", OFFHAND_ULTIMATE)
            break
		case 4:
            player.GiveOffhandWeapon("mp_ability_hunt_mode", OFFHAND_ULTIMATE)
            break
		case 5:
            player.GiveOffhandWeapon("mp_weapon_grenade_defensive_bombardment", OFFHAND_ULTIMATE)
            break
			
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
	printt("Flowstate DEBUG - Retrieving ship spot vector for player.")
	vector shipspot
	int num = RandomIntRange(0,11)
	switch(num)
	{
	case 0:
		shipspot = <0,0,30>
		break
	case 1:
		shipspot = <35,0,30>
		break
	case 2:
		shipspot = <-35,0,30>
		break
	case 3:
		shipspot = <0,35,30>
		break
	case 4:
		shipspot = <35,35,30>
		break
	case 5:
		shipspot = <-35,35,30>
		break
	case 6:
		shipspot = <0,70,30>
		break
	case 7:
		shipspot = <35,70,30>
		break
	case 8:
		shipspot = <-35,70,30>
		break
	case 9:
		shipspot = <0,105,30>
		break
	case 10:
		shipspot = <35,105,30>
		break
	case 11:
		shipspot = <-35,105,30>
		break
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
		wait 0.01
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
		//Message(victim,"DEBUG", invItem.type.tostring(), 10)
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
	if(IsValid(box))
		box.Destroy()
}


void function FlowStateDeathBoxFakePhysics( entity box )
{
	vector restPos = box.GetOrigin()
	vector fallPos = restPos + < 0, 0, 54 >

	entity mover = CreateScriptMover( restPos, box.GetAngles(), 0 )
	if ( IsValid( box ) )
		{
		box.SetParent( mover, "", true )
		mover.NonPhysicsMoveTo( fallPos, 0.5, 0.0, 0.5 )
		}
	wait 0.5
	if ( IsValid( box ) )
		mover.NonPhysicsMoveTo( restPos, 0.5, 0.5, 0.0 )
	wait 0.5
	if ( IsValid( box ) )
		box.ClearParent()
	if ( IsValid( mover ) )
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
	
    if (died && FlowState_FIESTAShieldsStreak()) {
        player.SetPlayerGameStat( PGS_TITAN_KILLS, 0 )
        Inventory_SetPlayerEquipment(player, BLUE_SHIELD, "armor")
    } else if (FlowState_FIESTAShieldsStreak()){
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
    } else if (!FlowState_FIESTAShieldsStreak()){
	PlayerRestoreHP(player, 100, Equipment_GetDefaultShieldHP())
	} else if (FlowState_FIESTAShieldsStreak()){
    PlayerRestoreShieldsFIESTA(player, player.GetShieldHealthMax())
    PlayerRestoreHPFIESTA(player, 100)
	}
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
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
{
	player.SetShieldHealthMax( FlowState_ExtrashieldValue() )
	player.SetShieldHealth( FlowState_ExtrashieldValue() )
	if(isOvershieldFromGround){
			foreach(sPlayer in GetPlayerArray()){
			Message(sPlayer,"EXTRA SHIELD PROVIDED", player.GetPlayerName() + " has 50 extra shield.", 5, "")
		}		
	}
}
#endif

void function GiveGungameWeapon(entity player) {
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
	int WeaponIndex = player.GetPlayerNetInt( "kills" )
	int realweaponIndex = WeaponIndex
	int MaxWeapons = 42
		if (WeaponIndex > MaxWeapons) {
        file.tdmState = eTDMState.NEXT_ROUND_NOW
		foreach (sPlayer in GetPlayerArray())
			{
			sPlayer.SetPlayerNetInt("kills", 0) //Reset for kills
	    	sPlayer.SetPlayerNetInt("assists", 0) //Reset for deaths
			sPlayer.p.playerDamageDealt = 0.0
			}
		}
		
	if(!FlowState_GungameRandomAbilities())
	{
		string tac = GetCurrentPlaylistVarString("flowstateGUNGAME_tactical", "~~none~~")
		string ult = GetCurrentPlaylistVarString("flowstateGUNGAME_ultimate", "~~none~~")
		
		entity tactical = player.GetOffhandWeapon( OFFHAND_TACTICAL )
        entity ultimate = player.GetOffhandWeapon( OFFHAND_ULTIMATE )

		float oldTacticalChargePercent = 0.0
                if( IsValid( tactical ) ) {
                    player.TakeOffhandWeapon( OFFHAND_TACTICAL )
                    oldTacticalChargePercent = float( tactical.GetWeaponPrimaryClipCount()) / float(tactical.GetWeaponPrimaryClipCountMax() )
                }
                player.GiveOffhandWeapon(tac, OFFHAND_TACTICAL)
				entity newTactical = player.GetOffhandWeapon( OFFHAND_TACTICAL )
				if(IsValid(newTactical))
					newTactical.SetWeaponPrimaryClipCount( int( newTactical.GetWeaponPrimaryClipCountMax() * oldTacticalChargePercent ) )

				if( IsValid( ultimate ) ) player.TakeOffhandWeapon( OFFHAND_ULTIMATE )
					player.GiveOffhandWeapon(ult, OFFHAND_ULTIMATE)
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
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
{
    WaitForGameState(eGameState.Playing)
    AddSpawnCallback("prop_dynamic", _OnPropDynamicSpawned)
	
		if(!Flowstate_DoorsEnabled()){
	array<entity> doors = GetAllPropDoors()
	foreach(entity door in doors)
		if(IsValid(door)){
		door.Destroy()}
	}

    for(; ;)
    {
	VotingPhase()
	SimpleChampionUI()
	}
    WaitForever()
}

void function VotingPhase()
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
{
	printt("Flowstate DEBUG - mapvoting is starting.")
    DestroyPlayerProps()
	isBrightWaterByZer0 = false
    SetGameState(eGameState.MapVoting)
	file.FallTriggersEnabled = true
	
	foreach(player in GetPlayerArray())
	{
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
			WaitFrame()
	}

	if (!file.mapIndexChanged)
		{
			file.nextMapIndex = (file.nextMapIndex + 1 ) % file.locationSettings.len()
		}
		
	if (FlowState_LockPOI()) {
		file.nextMapIndex = FlowState_LockedPOI()
	}

	int choice = file.nextMapIndex
	file.mapIndexChanged = false
	file.selectedLocation = file.locationSettings[choice]
	WaitFrame()
	file.thisroundDroppodSpawns = GetNewFFADropShipLocations(file.selectedLocation.name, GetMapName())
	printt("Flowstate DEBUG - Next round location is: " + file.selectedLocation.name)

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
		file.randomprimary = RandomIntRangeInclusive( 0, 2 )
        file.randomsecondary = RandomIntRangeInclusive( 0, 4 )
	} else if (FlowState_RandomGunsEverydie())
	{
		file.randomprimary = RandomIntRangeInclusive( 0, 23 )
        file.randomsecondary = RandomIntRangeInclusive( 0, 18 )
	}
	
	printt("Flowstate DEBUG - checking flowstateenabledropship.")

wait 3

if(file.selectedLocation.name == "TTV Building" && FlowState_ExtrashieldsEnabled()){
	DestroyPlayerProps()
	CreateGroundMedKit(<10725, 5913,-4225>)
} else if(file.selectedLocation.name == "Skill trainer By Colombia" && FlowState_ExtrashieldsEnabled()){
    DestroyPlayerProps()
    WaitFrame()
	CreateGroundMedKit(<17247,31823,-310>)
    thread SkillTrainerLoad()
} else if(file.selectedLocation.name == "Skill trainer By Colombia" )
{
	printt("Flowstate DEBUG - creating props for Skill Trainer.")
    DestroyPlayerProps()
    WaitFrame()
    thread SkillTrainerLoad()	
} else if(file.selectedLocation.name == "Brightwater By Zer0bytes" )
{
	printt("Flowstate DEBUG - creating props for Brightwater.")
	isBrightWaterByZer0 = true
    DestroyPlayerProps()
	WaitFrame()
	thread WorldEntities()
	wait 1
    thread BrightwaterLoad()
	wait 1.5
	thread BrightwaterLoad2()
	wait 1.5
	thread BrightwaterLoad3()
} else if(file.selectedLocation.name == "Cave By BlessedSeal" ){
	printt("Flowstate DEBUG - creating props for Cave.")
    DestroyPlayerProps()
    WaitFrame()
    thread SpawnEditorPropsSeal()	
} else if(file.selectedLocation.name == "Gaunlet" && FlowState_ExtrashieldsEnabled()){
	DestroyPlayerProps()
	printt("Flowstate DEBUG - creating Gaunlet Extrashield.")
	CreateGroundMedKit(<-21289, -12030, 3060>)
} else if (file.selectedLocation.name == "White Forest By Zer0Bytes"){
	DestroyPlayerProps()
	printt("Flowstate DEBUG - creating props for White Forest.")
	WaitFrame()
	thread SpawnWhiteForestProps()
} else if (file.selectedLocation.name == "Custom map by Biscutz"){
	DestroyPlayerProps()
	printt("Flowstate DEBUG - creating props for Map by Biscutz.")
	WaitFrame()
	thread LoadMapByBiscutz1()
	thread LoadMapByBiscutz2()
}

//TODO MORE POIS

if(GetCurrentPlaylistVarBool("flowstateenabledropship", false ))
{
	printt("Flowstate DEBUG - Dropships ON.")
	file.dropselectedLocation = file.droplocationSettings[choice]
	if(GetMapName() == "mp_rr_desertlands_64k_x_64k" || GetMapName() == "mp_rr_desertlands_64k_x_64k_nx" || GetMapName() == "mp_rr_canyonlands_mu1" || GetMapName() == "mp_rr_canyonlands_mu1_night" || GetMapName() == "mp_rr_canyonlands_64k_x_64k")
	{
    foreach(player in GetPlayerArray())
    {
        if(IsValidPlayer(player))
        {
		    Message(player, "Please standby", "Dropship is on the way!", 4)
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
		    Message(player, file.selectedLocation.name, "Dropship is ready, get in!", 5)
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
	printt("Flowstate DEBUG - Dropships OFF.")
    foreach(player in GetPlayerArray())
    {
        if(IsValidPlayer(player))
        {
		    Message(player,"Starting match...", "", 4, "Wraith_PhaseGate_Travel_1p")
		    ScreenFade( player, 0, 0, 0, 255, 4.0, 4.0, FFADE_OUT | FFADE_PURGE )
	    }
    }
	wait 4
}

try {
    PlayerTrail(GetBestPlayer(),0)
} catch(e2){}

SetGameState(eGameState.Playing)
file.tdmState = eTDMState.IN_PROGRESS

if(GetCurrentPlaylistVarBool("flowstateenabledropship", false ) )
{
	printt("Flowstate DEBUG - Tping players Dropships ON (traveling).")

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
			if (GetCurrentPlaylistVarBool("flowstateffaortdm", true ))
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

							ScreenFadeFromBlack( player, 1.0, 1.0 )

							int rndnum = RandomIntRangeInclusive(0, maxspawns)
							
							if (!FlowState_DummyOverride()) {
							thread RespawnPlayersInDropshipAtPoint2( player, spawns[rndnum].origin + <0,0,500>, AnglesCompose( spawns[rndnum].angles, <0,0,0> ) ) 
							printt("Flowstate DEBUG - Dropships delivering players to map.")	
							EnableOffhandWeapons( player )
							_HandleRespawn(player,true)
							}
							else {
							printt("Flowstate DEBUG - Can't use Dropships to arrive cuz we have dummies as character models.")	
							_HandleRespawn(player)
							DeployAndEnableWeapons(player)
							EnableOffhandWeapons( player )
							ClearInvincible(player)
							}
						

							try { player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 ).SetWeaponPrimaryClipCount( player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 ).GetWeaponPrimaryClipCountMax())} catch(this_is_a_unique_string_dont_crash_u_bitch){}
							try { player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_1 ).SetWeaponPrimaryClipCount( player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_1 ).GetWeaponPrimaryClipCountMax())} catch(this_is_a_unique_string_dont_crash_u_bitch2){}
							try { player.GetOffhandWeapon( OFFHAND_INVENTORY ).SetWeaponPrimaryClipCount( player.GetOffhandWeapon( OFFHAND_INVENTORY ).GetWeaponPrimaryClipCountMax() )} catch(this_is_a_unique_string_dont_crash_u_bitch3){}
							try { player.GetOffhandWeapon( OFFHAND_LEFT ).SetWeaponPrimaryClipCount( player.GetOffhandWeapon( OFFHAND_LEFT ).GetWeaponPrimaryClipCountMax() )} catch(this_is_a_unique_string_dont_crash_u_bitch4){}
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
					//Remote_CallFunction_NonReplay(player, "ServerCallback_TDM_DoAnnouncement", 1, eTDMAnnounce.ROUND_START)

					try { player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 ).SetWeaponPrimaryClipCount( player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 ).GetWeaponPrimaryClipCountMax())} catch(this_is_a_unique_string_dont_crash_u_bitch){}
					try { player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_1 ).SetWeaponPrimaryClipCount( player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_1 ).GetWeaponPrimaryClipCountMax())} catch(this_is_a_unique_string_dont_crash_u_bitch2){}
					try { player.GetOffhandWeapon( OFFHAND_INVENTORY ).SetWeaponPrimaryClipCount( player.GetOffhandWeapon( OFFHAND_INVENTORY ).GetWeaponPrimaryClipCountMax() )} catch(this_is_a_unique_string_dont_crash_u_bitch3){}
					try { player.GetOffhandWeapon( OFFHAND_LEFT ).SetWeaponPrimaryClipCount( player.GetOffhandWeapon( OFFHAND_LEFT ).GetWeaponPrimaryClipCountMax() )} catch(this_is_a_unique_string_dont_crash_u_bitch4){}
    			}
		}
	}
	}
	else
	{
		foreach(player in GetPlayerArray())
    	{
            if(IsValid(player))
            {
		        RemoveCinematicFlag(player, CE_FLAG_HIDE_MAIN_HUD | CE_FLAG_EXECUTION)
		        player.SetThirdPersonShoulderModeOff()
		        ClearInvincible(player)
		        _HandleRespawn(player)
		        ClearInvincible(player)
		        DeployAndEnableWeapons(player)
				EnableOffhandWeapons( player )
		        //Remote_CallFunction_NonReplay(player, "ServerCallback_TDM_DoAnnouncement", 1, eTDMAnnounce.ROUND_START)
		        ScreenFade( player, 0, 0, 0, 255, 1.0, 1.0, FFADE_IN | FFADE_PURGE )

				try { player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 ).SetWeaponPrimaryClipCount( player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 ).GetWeaponPrimaryClipCountMax())} catch(this_is_a_unique_string_dont_crash_u_bitch){}
				try { player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_1 ).SetWeaponPrimaryClipCount( player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_1 ).GetWeaponPrimaryClipCountMax())} catch(this_is_a_unique_string_dont_crash_u_bitch2){}
				try { player.GetOffhandWeapon( OFFHAND_INVENTORY ).SetWeaponPrimaryClipCount( player.GetOffhandWeapon( OFFHAND_INVENTORY ).GetWeaponPrimaryClipCountMax() )} catch(this_is_a_unique_string_dont_crash_u_bitch3){}
				try { player.GetOffhandWeapon( OFFHAND_LEFT ).SetWeaponPrimaryClipCount( player.GetOffhandWeapon( OFFHAND_LEFT ).GetWeaponPrimaryClipCountMax() )} catch(this_is_a_unique_string_dont_crash_u_bitch4){}
            }
    	}
	}
}
else
{
			printt("Flowstate DEBUG - Tping players Dropships OFF.")

    foreach(player in GetPlayerArray())
    {
        try {
            if(IsValid(player))
            {
		        RemoveCinematicFlag(player, CE_FLAG_HIDE_MAIN_HUD | CE_FLAG_EXECUTION)
		        player.SetThirdPersonShoulderModeOff()
		        _HandleRespawn(player)
				ClearInvincible(player)
		        DeployAndEnableWeapons(player)
				EnableOffhandWeapons( player )
		        //Remote_CallFunction_NonReplay(player, "ServerCallback_TDM_DoAnnouncement", 1, eTDMAnnounce.ROUND_START)
		        ScreenFade( player, 0, 0, 0, 255, 1.0, 1.0, FFADE_IN | FFADE_PURGE )
							
				try { player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 ).SetWeaponPrimaryClipCount( player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 ).GetWeaponPrimaryClipCountMax())} catch(this_is_a_unique_string_dont_crash_u_bitch){}
				try { player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_1 ).SetWeaponPrimaryClipCount( player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_1 ).GetWeaponPrimaryClipCountMax())} catch(this_is_a_unique_string_dont_crash_u_bitch2){}
				try { player.GetOffhandWeapon( OFFHAND_INVENTORY ).SetWeaponPrimaryClipCount( player.GetOffhandWeapon( OFFHAND_INVENTORY ).GetWeaponPrimaryClipCountMax() )} catch(this_is_a_unique_string_dont_crash_u_bitch3){}
				try { player.GetOffhandWeapon( OFFHAND_LEFT ).SetWeaponPrimaryClipCount( player.GetOffhandWeapon( OFFHAND_LEFT ).GetWeaponPrimaryClipCountMax() )} catch(this_is_a_unique_string_dont_crash_u_bitch4){}
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
		Message(player, file.selectedLocation.name, "\n           CHAMPION: " + GetBestPlayerName() + " / " + GetBestPlayerScore() + " kills. / " + GetDamageOfPlayerWithMostDamage() + " damage.", 25, "diag_ap_aiNotify_circleTimerStartNext_02")
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
		Message(player, file.selectedLocation.name, "\n           CHAMPION: " + GetBestPlayerName() + " / " + GetBestPlayerScore() + " kills. \n    CHALLENGER:  " + PlayerWithMostDamageName() + " / " + GetDamageOfPlayerWithMostDamage() + " damage.", 25, "diag_ap_aiNotify_circleTimerStartNext_02")
		file.previousChampion=GetBestPlayer()
		file.previousChallenger=PlayerWithMostDamage()
		GameRules_SetTeamScore(player.GetTeam(), 0)
		file.deathPlayersCounter = 0
	}
}
} catch(e4){}
printt("Flowstate DEBUG - Clearing last round stats.")
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
printt("Flowstate DEBUG - Bubble created, executing SimpleChampionUI.")
WaitFrame()
}

void function SimpleChampionUI(){
/////////////Retículo Endoplasmático#5955 CaféDeColombiaFPS///////////////////
float endTime = Time() + FlowState_RoundTime()
printt("Flowstate DEBUG - TDM/FFA gameloop Round started.")

		
foreach(player in GetPlayerArray())
    {
thread WpnPulloutOnRespawn(player)
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
		if(file.tdmState == eTDMState.NEXT_ROUND_NOW){ 
					printt("Flowstate DEBUG - tdmState is eTDMState.NEXT_ROUND_NOW Loop ended.")

		break}
		WaitFrame()
	}
}
else if (!FlowState_Timer() ){
while( Time() <= endTime )
	{
	if(file.tdmState == eTDMState.NEXT_ROUND_NOW) {
		printt("Flowstate DEBUG - tdmState is eTDMState.NEXT_ROUND_NOW Loop ended.")
	break}
		WaitFrame()
	}
} 


foreach(player in GetPlayerArray())
    {
		if(IsValid(player) && !IsAlive(player)){
				_HandleRespawn(player)
				ClearInvincible(player)
				player.SetThirdPersonShoulderModeOn()
				HolsterAndDisableWeapons( player )
		}else if(IsValid(player) && IsAlive(player))
			{
				if(FlowState_RandomGunsEverydie() && FlowState_FIESTAShieldsStreak()){
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
}

wait 1
foreach(entity champion in GetPlayerArray())
    {
		try {
		if(GetBestPlayer() == champion) {
		if(IsValid(champion))
        {
			 thread EmitSoundOnEntityOnlyToPlayer( champion, champion, "diag_ap_aiNotify_winnerFound_10" )
			 thread EmitSoundOnEntityExceptToPlayer( champion, champion, "diag_ap_aiNotify_winnerFound" )
        PlayerTrail(champion,1)
		}}
	}catch(e2){}
	}

foreach(player in GetPlayerArray())
    {

	 if(IsValid(player)){
	 AddCinematicFlag(player, CE_FLAG_HIDE_MAIN_HUD | CE_FLAG_EXECUTION)
	 Message(player,"- FINAL SCOREBOARD -", "\n         Name:    K  |   D   |   KD   |   Damage dealt \n \n" + ScoreboardFinal() + "\n Flowstate " + file.scriptversion + " by ColombiaFPS, empathogenwarlord & AyeZeeBB", 7, "UI_Menu_RoundSummary_Results")}
	wait 0.1
	}
wait 7
foreach(player in GetPlayerArray())
    {
		if(IsValid(player)){
		ClearInvincible(player)
		RemoveCinematicFlag(player, CE_FLAG_HIDE_MAIN_HUD | CE_FLAG_EXECUTION)
		player.SetThirdPersonShoulderModeOff()
		}
	}
WaitFrame()

file.bubbleBoundary.Destroy()
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
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
            if(Distance(player.GetOrigin(), bubbleCenter) > bubbleRadius && player.p.isPlayerSpawningInDroppod == false)
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
	if(IsValid(player) && IsAlive( player )){
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
    player.SetShieldHealth( shields )}
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
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
{
if(!FlowState_PROPHUNT())
{
//Char select.
file.characters = clone GetAllCharacters()
ItemFlavor PersonajeEscogido = file.characters[FlowState_ChosenCharacter()]
CharacterSelect_AssignCharacter( ToEHI( player ), PersonajeEscogido )}

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
file.characters = clone GetAllCharacters()
ItemFlavor PersonajeEscogido = file.characters[RandomInt(9)]
CharacterSelect_AssignCharacter( ToEHI( player ), PersonajeEscogido )
TakeAllWeapons(player)
}
}

// ███████  ██████  ██████  ██████  ███████ ██████   ██████   █████  ██████  ██████
// ██      ██      ██    ██ ██   ██ ██      ██   ██ ██    ██ ██   ██ ██   ██ ██   ██
// ███████ ██      ██    ██ ██████  █████   ██████  ██    ██ ███████ ██████  ██   ██
     // ██ ██      ██    ██ ██   ██ ██      ██   ██ ██    ██ ██   ██ ██   ██ ██   ██
// ███████  ██████  ██████  ██   ██ ███████ ██████   ██████  ██   ██ ██   ██ ██████

void function Message( entity player, string text, string subText = "", float duration = 7.0, string sound = "" )
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
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
                     msg = msg + "    1. " + p.name + ":   " + p.score + " | " + p.deaths + "\n"
					break
                case 1:
                    msg = msg + "     2. " + p.name + ":   " + p.score + " | " + p.deaths + "\n"
                    break
                case 2:
                    msg = msg + "     3. " + p.name + ":   " + p.score + " | " + p.deaths + "\n"
                    break
                default:
					msg = msg + "     " + p.name + ":   " + p.score + " | " + p.deaths + "\n"
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
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
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
// Taken from Pebbers' Gungame Script
{
    foreach(player in GetPlayerArray()) {
        if(!IsValid(player)) continue
        ResetPlayerStats(player)
    }
}

void function ResetPlayerStats(entity player)
// Taken from Pebbers' Gungame Script
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

bool function ClientCommand_FlowstateKick(entity player, array<string> args)
{
	
	if(player.GetPlayerName() == file.Hoster || player.GetPlayerName() == file.admin1 || player.GetPlayerName() == file.admin2 || player.GetPlayerName() == file.admin3 || player.GetPlayerName() == file.admin4) {
		foreach(sPlayer in GetPlayerArray()){
				if(sPlayer.GetPlayerName() == args[0])
				{
				printt("Flowstate DEBUG - Kicking player from flowstate.", sPlayer.GetPlayerName())
				ClientCommand( sPlayer, "disconnect" )
				return true
				}
		}
		return false
	}
	return false		
}

bool function ClientCommand_ChangeMapSky(entity player, array<string> args)
{
	printt("Flowstate DEBUG - Changing sky color!")
	#if SERVER
	if(!file.mapSkyToggle) {
			SetConVarFloat( "mat_autoexposure_max", 1.0 )
			SetConVarFloat( "mat_autoexposure_max_multiplier", 0.4 )
			SetConVarFloat( "mat_autoexposure_min", 0.1 )
			SetConVarFloat( "mat_autoexposure_min_multiplier", 1.0 )
			SetConVarFloat( "mat_sky_scale", 1.0 )
			SetConVarString( "mat_sky_color", "1.0 1.0 1.0 1.0" )
			SetConVarFloat( "mat_sun_scale", 1.0 )
			SetConVarString( "mat_sun_color", "1.0 1.5 2.0 1.0" ) 
			file.mapSkyToggle = true}
			else {
			SetConVarToDefault( "mat_autoexposure_max" )
			SetConVarToDefault( "mat_autoexposure_max_multiplier" )
			SetConVarToDefault( "mat_autoexposure_min" )
			SetConVarToDefault( "mat_autoexposure_min_multiplier" )
			SetConVarToDefault( "mat_sky_scale" )
			SetConVarToDefault( "mat_sky_color" )
			SetConVarToDefault( "mat_sun_scale" )
			SetConVarToDefault( "mat_sun_color" )
			file.mapSkyToggle = true	
			}
	return true
	#endif
	unreachable
}

bool function ClientCommand_IsthisevenCrashfixtest(entity player, array<string> args)
{
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
	        player.StartObserverMode( OBS_MODE_IN_EYE )
	        player.SetObserverTarget( specTarget )
            printf("Spectating!")
        }
    }
    else
    {
        print("There is no one to spectate!")
    }
    return true
}

bool function ClientCommand_SpectateSURF(entity player, array<string> args)
//Thanks Zee#0134
//Modified By CaféDeColombiaFPS
{
    if ( GetGameState() == eGameState.WaitingForPlayers ) {
        return false
    }

    if ( GetGameState() == eGameState.MapVoting ) {
        return false
    }
	
    array<entity> playersON = GetPlayerArray_Alive()
	playersON.fastremovebyvalue( player )
	
    if ( playersON.len() > 1 && IsValid(player))
    {
        entity specTarget = playersON[0]

        if( specTarget.IsObserver())
        {
            printf("error: try again")
            return false
        }

        if( player.GetPlayerNetInt( "spectatorTargetCount" ) > 0)
        {
            player.SetPlayerNetInt( "spectatorTargetCount", 0 )
	        //player.SetSpecReplayDelay( 2 )
            player.StopObserverMode()
			TpPlayerToSpawnPoint(player)
            printf("Respawned!")
        }
        else
        {
			TpPlayerToSpawnPoint(player)
            player.SetPlayerNetInt( "spectatorTargetCount", playersON.len() )
	        player.SetSpecReplayDelay( 2 )
	        player.StartObserverMode( OBS_MODE_IN_EYE )
	        player.SetObserverTarget( specTarget )
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
///////////////////////////////////////////////////////
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
///////////////////////////////////////////////////////
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
	return " Use your ULTIMATE to CHANGE PROP up to 3 times. \n Use your ULTIMATE to LOCK ANGLES as attackers arrive. "
}

bool function ClientCommand_Help(entity player, array<string> args)
//by michae\l/#1125
{
	if(IsValid(player)) {
			if(FlowState_RandomGunsEverydie())
			{
				Message(player, "WELCOME TO FLOWSTATE: FIESTA", helpMessage(), 10)}
			else if (FlowState_Gungame())
			{
				Message(player, "WELCOME TO FLOWSTATE: GUNGAME", helpMessage(), 10)

			} else if (FlowState_PROPHUNT())
			{
				Message(player, "WELCOME TO FLOWSTATE: PROPHUNT", helpMessagePROPHUNT(), 10)	
			} else if (FlowState_SURF())
			{
				Message(player, "Apex SURF", "", 5)	
			} else{ 
				Message(player, "WELCOME TO FLOWSTATE: FFA/TDM", helpMessage(), 10)
			}
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

		}

	else {
	return false
	}
	return true
}

bool function ClientCommand_ChatUnBan(entity player, array<string> args)
{

if(player.GetPlayerName() == file.Hoster || player.GetPlayerName() == file.admin1 || player.GetPlayerName() == file.admin2 || player.GetPlayerName() == file.admin3 || player.GetPlayerName() == file.admin4) {
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

if(IsValidPlayer(player))
        {
foreach(sPlayer in GetPlayerArray())
    {
	Message( sPlayer, "Trollbox", currentChat, 5)
    }
file.lastTimeChatUsage = Time()
		}


	return true
}

bool function ClientCommand_DispayChatHistory(entity player, array<string> args)
//by Retículo Endoplasmático#5955
{
if(IsValidPlayer(player))
        {
foreach(sPlayer in GetPlayerArray())
    {
	Message( sPlayer, "TROLLBOX HISTORY", currentChat, 5)
    }
file.lastTimeChatUsage = Time()
		}


	return true
}


bool function ClientCommand_ShowLatency(entity player, array<string> args)
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
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
        entity primary = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 )
        entity secondary = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_1 )
        entity tactical = player.GetOffhandWeapon( OFFHAND_TACTICAL )
        entity ultimate = player.GetOffhandWeapon( OFFHAND_ULTIMATE )
		
        switch(args[0])
        {
            case "p":
            case "primary":
			
                if( IsValid( primary ) ){
					player.TakeWeaponByEntNow( primary )
					weapon = player.GiveWeapon(args[1], WEAPON_INVENTORY_SLOT_PRIMARY_0)
				}			
                break
            case "s":
            case "secondary":
			
                if( IsValid( secondary ) ) {
					player.TakeWeaponByEntNow( secondary )
					weapon = player.GiveWeapon(args[1], WEAPON_INVENTORY_SLOT_PRIMARY_1)
				}
                break
            case "t":
            case "tactical":
                float oldTacticalChargePercent = 0.0
                
				if( IsValid( tactical ) ) {
					player.TakeOffhandWeapon( OFFHAND_TACTICAL )
					oldTacticalChargePercent = float( tactical.GetWeaponPrimaryClipCount()) / float(tactical.GetWeaponPrimaryClipCountMax() )                
					weapon = player.GiveOffhandWeapon(args[1], OFFHAND_TACTICAL)
					entity newTactical = player.GetOffhandWeapon( OFFHAND_TACTICAL )
					newTactical.SetWeaponPrimaryClipCount( int( newTactical.GetWeaponPrimaryClipCountMax() * oldTacticalChargePercent ) )
				}
                break
            case "u":
            case "ultimate":			
                if( IsValid( ultimate ) ) 
				{
					player.TakeOffhandWeapon( OFFHAND_ULTIMATE )
					weapon = player.GiveOffhandWeapon(args[1], OFFHAND_ULTIMATE)
				}
                break
        }

    if( args.len() > 2 )
    {
        try {
            weapon.SetMods(args.slice(2, args.len()))
        }
        catch( e2 ) {
            print("invalid mod")
        }
    }
    if( IsValid(weapon) && !weapon.IsWeaponOffhand() ) 
		player.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, GetSlotForWeapon(player, weapon))
	
    return true
}

bool function ClientCommand_NextRoundPROPHUNT(entity player, array<string> args)
//Thanks Archtux#9300
//Modified by Retículo Endoplasmático#5955 and michae\l/#1125
{
	if(player.GetPlayerName() == file.Hoster || player.GetPlayerName() == file.admin1 || player.GetPlayerName() == file.admin2 || player.GetPlayerName() == file.admin3 || player.GetPlayerName() == file.admin4) {
		
		if (args.len()) {
				int mapIndex = int(args[0])
				prophunt.nextMapIndex = (((mapIndex >= 0 ) && (mapIndex < prophunt.locationSettings.len())) ? mapIndex : RandomIntRangeInclusive(0, prophunt.locationSettings.len() - 1))
				prophunt.mapIndexChanged = true

				string now = args[0]
				if (now == "now")
				{
				   file.tdmState = eTDMState.NEXT_ROUND_NOW
				   prophunt.mapIndexChanged = false
				   prophunt.InProgress = false
				   SetGameState(eGameState.MapVoting)
				}

				now = args[1]
				if (now == "now")
				{
				   file.tdmState = eTDMState.NEXT_ROUND_NOW
				   prophunt.InProgress = false
				}
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

            string now = args[0]
            if (now == "now")
            {
               file.tdmState = eTDMState.NEXT_ROUND_NOW
			   file.mapIndexChanged = false
			   return true
            }

            int mapIndex = int(args[0])
            file.nextMapIndex = (((mapIndex >= 0 ) && (mapIndex < file.locationSettings.len())) ? mapIndex : RandomIntRangeInclusive(0, file.locationSettings.len() - 1))
            file.mapIndexChanged = true
            
			now = args[1]
            if (now == "now")
            {
               file.tdmState = eTDMState.NEXT_ROUND_NOW
            }
		}
	}
	else {
	return false
	}
	return true
}
bool function ClientCommand_adminnoclip( entity player, array<string> args )
{
	if(!IsValid(player)) return false
	
	if(player.GetPlayerName() == file.Hoster || player.GetPlayerName() == file.admin1 || player.GetPlayerName() == file.admin2 || player.GetPlayerName() == file.admin3 || player.GetPlayerName() == file.admin4) {
		if ( player.IsNoclipping() )
			player.SetPhysics( MOVETYPE_WALK )
		else 
			player.SetPhysics( MOVETYPE_NOCLIP )
		
		return true
	}
	return true
}

bool function ClientCommand_God(entity player, array<string> args)
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
{
	if(!IsValid(player)) return false
	
	if(player.GetPlayerName() == file.Hoster || player.GetPlayerName() == file.admin1 || player.GetPlayerName() == file.admin2 || player.GetPlayerName() == file.admin3 || player.GetPlayerName() == file.admin4) {
			player.MakeInvisible()
			MakeInvincible(player)
			HolsterAndDisableWeapons(player)
	}
	else {
	return false
	}
	return true
}

bool function ClientCommand_CircleNow(entity player, array<string> args)
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
{
	if(!IsValid(player)) return false
	
	if(player.GetPlayerName() == file.Hoster || player.GetPlayerName() == file.admin1 || player.GetPlayerName() == file.admin2 || player.GetPlayerName() == file.admin3 || player.GetPlayerName() == file.admin4) {
		SummonPlayersInACircle(player)
	}
	return true
}

bool function ClientCommand_UnGod(entity player, array<string> args)
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
{
	if(!IsValid(player)) return false
	
	if(player.GetPlayerName() == file.Hoster || player.GetPlayerName() == file.admin1 || player.GetPlayerName() == file.admin2 || player.GetPlayerName() == file.admin3 || player.GetPlayerName() == file.admin4) {
		player.MakeVisible()
		ClearInvincible(player)
		EnableOffhandWeapons( player )
		DeployAndEnableWeapons(player)
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
		Message(player, "- CURRENT SCOREBOARD - ", "\n               CHAMPION: " + GetBestPlayerName() + " / " + GetBestPlayerScore() + " kills. \n\n Name:    K  |   D   |   KD   |   Damage dealt \n" + ScoreboardFinal(true) + "\n\nYour ping: " + ping.tointeger() + "ms. \nHosted by: " + getHoster(), 4)
	}
	return true
}

bool function ClientCommand_ScoreboardPROPHUNT(entity player, array<string> args)
//by michae\l/#1125
{
	float ping = player.GetLatency() * 1000 - 40
	if(IsValid(player)) {
		Message(player, "- PROPHUNT SCOREBOARD - ", "Name:    K  |   D   \n" + ScoreboardFinalPROPHUNT(true) + "\nYour ping: " + ping.tointeger() + "ms. \nHosted by: " + getHoster(), 5)
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
        if (IsValid(p)) {SetTeam(p,TEAM_IMC + 2 + (currentTeam % numTeams))}
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
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
{
	array<string> animationStrings = ["ACT_MP_MENU_LOBBY_CENTER_IDLE", "ACT_MP_MENU_READYUP_INTRO", "ACT_MP_MENU_LOBBY_SELECT_IDLE", "ACT_VICTORY_DANCE"]
	while( IsValid(legend) )
	{
		legend.SetCycle( cycle )
		legend.Anim_Play( animationStrings[RandomInt(animationStrings.len())] )
		WaittillAnimDone(legend)
	}
}

void function CreateAnimatedLegend(asset a, vector pos, vector ang , int solidtype = 0, float size = 1.0)  // solidtype 0 = no collision, 2 = bounding box, 6 = use vPhysics, 8 = hitboxes only
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
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
#endif


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
				file.tdmState = eTDMState.NEXT_ROUND_NOW
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
				file.tdmState = eTDMState.NEXT_ROUND_NOW
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
	file.FallTriggersEnabled = true
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
				Message(player, "APEX PROPHUNT", "                Made by Colombia. Game is starting.\n\n" + helpMessagePROPHUNT(), 10)
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
file.tdmState = eTDMState.IN_PROGRESS
printt("Flowstate DEBUG - tdmState is eTDMState.IN_PROGRESS Starting round.")
entity bubbleBoundary = CreateBubbleBoundaryPROPHUNT(prophunt.selectedLocation)
SetGameState(eGameState.Playing)

float endTime = Time() + GetCurrentPlaylistVarFloat("flowstatePROPHUNTLimitTime", 300 )
	array<entity> IMCplayers = GetPlayerArrayOfTeam(TEAM_IMC)
	array<entity> MILITIAplayers = GetPlayerArrayOfTeam(TEAM_MILITIA)

array<LocPair> prophuntSpawns = prophunt.selectedLocation.spawns

file.deathPlayersCounter = 0
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
file.FallTriggersEnabled = false
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
		if(file.tdmState == eTDMState.NEXT_ROUND_NOW)
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

//prophunt end. Colombia
//////////////////////////////////////////////////////