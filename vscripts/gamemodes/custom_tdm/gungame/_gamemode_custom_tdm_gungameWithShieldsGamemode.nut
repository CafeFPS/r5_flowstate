//////////////////////////////////////////////////////
//Mechanics Grinding DM v1.4
//By Retículo Endoplasmático#5955
//& michae\l/#1125
///////////////////////////////////////////////////////

string WHITE_SHIELD = "armor_pickup_lv1"
string BLUE_SHIELD = "armor_pickup_lv2"
string PURPLE_SHIELD = "armor_pickup_lv3"

global function _CustomTDM_Init
global function _RegisterLocation
table playersInfo

enum eTDMState
{
	IN_PROGRESS = 0
	WINNER_DECIDED = 1
}

struct {
	string scriptversion = "v1.4"
    int tdmState = eTDMState.IN_PROGRESS
    int nextMapIndex = 0
	bool mapIndexChanged = true
	array<entity> playerSpawnedProps
	array<ItemFlavor> characters
	array<string> whitelistedWeapons
	array<LocationSettings> locationSettings
    LocationSettings& selectedLocation
    entity bubbleBoundary
	entity previousChampion
	entity previousChallenger
	int deathPlayersCounter=0
	///////////TDM SETTINGS////////////
	int RoundTime = 900 // Round time!! It must be greater than 620 seconds!!
	string bubblecolor = "94 0 145" //Also this ^^ find in google "rgb color picker" and take the values, dont put commas.	
	string Hoster = "-hoster-" //Also modify this. ^^
	int PersonajeEscogido = 8 // Char select, char list below. You can use RandomInt(10) 
	///////////////////////////////////
} file

///////////////////////////////////////////////////////
// Characters list!, put the number in "int PersonajeEscogido = 8". Wraith is 8, so is default.
// 0 Bang
// 1 Bloodhound
// 2 Caustic
// 3 Gibby
// 4 Lifeline
// 5 Mirage
// 6 Octane
// 7 Pathy
// 8 Wraith
// 9 Watty
// 10 Crypto
///////////////////////////////////////////////////////

struct PlayerInfo 
{
	string name
	int team
	int score
	int deaths
	float kd
	int damage
}
	
// ██████   █████  ███████ ███████     ███████ ██    ██ ███    ██  ██████ ████████ ██  ██████  ███    ██ ███████ 
// ██   ██ ██   ██ ██      ██          ██      ██    ██ ████   ██ ██         ██    ██ ██    ██ ████   ██ ██      
// ██████  ███████ ███████ █████       █████   ██    ██ ██ ██  ██ ██         ██    ██ ██    ██ ██ ██  ██ ███████ 
// ██   ██ ██   ██      ██ ██          ██      ██    ██ ██  ██ ██ ██         ██    ██ ██    ██ ██  ██ ██      ██ 
// ██████  ██   ██ ███████ ███████     ██       ██████  ██   ████  ██████    ██    ██  ██████  ██   ████ ███████ 

void function _CustomTDM_Init()
{
	AddCallback_OnClientConnected( void function(entity player) { thread _OnPlayerConnected(player) } )
    AddCallback_OnPlayerKilled(void function(entity victim, entity attacker, var damageInfo) {thread _OnPlayerDied(victim, attacker, damageInfo)})
	AddClientCommandCallback("god", ClientCommand_God)
	AddClientCommandCallback("ungod", ClientCommand_UnGod)
    AddClientCommandCallback("next_round", ClientCommand_NextRound)

    if( CMD_GetTGiveEnabled() )
    {
        AddClientCommandCallback("tgive", ClientCommand_GiveWeapon)
    }
    
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
			return NewLocPair(<-8846, -30401, 2496>, <0, 60, 0>)
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
		ResetPlayerStats(player)
        _HandleRespawn(player)
		ClearInvincible(player)
    }
	string nextlocation = file.selectedLocation.name
	Message(player,"WELCOME TO TDM/FFA!", "\n            Hosted by " + file.Hoster + "\n \n Mechanics Grinding DM " + file.scriptversion + " by CaféDeColombiaFPS.", 15)
	GrantSpawnImmunity(player,2)
	    switch(GetGameState())
    {
    case eGameState.MapVoting:     
	    if(IsValid(player) )
        {
			player.SetThirdPersonShoulderModeOn()
			HolsterAndDisableWeapons( player )
			UpgradeShields(player, true)
			player.UnforceStand()  
			player.UnfreezeControlsOnServer()
		}
		break
	case eGameState.WaitingForPlayers:
        player.FreezeControlsOnServer()
        break
    case eGameState.Playing:      
	    if(IsValid(player))
        {
		player.UnfreezeControlsOnServer();
		UpgradeShields(player, true)
        Remote_CallFunction_NonReplay(player, "ServerCallback_TDM_DoAnnouncement", 5, eTDMAnnounce.ROUND_START)
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
	
	file.deathPlayersCounter++
	if(file.deathPlayersCounter == 1)
	{
	foreach (player in GetPlayerArray())
	{
	thread EmitSoundOnEntityExceptToPlayer( player, player, "diag_ap_aiNotify_diedFirst" )
	}		
	}

	// if(victim == challenger && attacker == champion)
	// {
	// foreach (player in GetPlayerArray())
	// {
	// thread EmitSoundOnEntityOnlyToPlayer( player, player, "diag_ap_aiNotify_championKilledChallenger_01" )
	// }		
	// }
	
	// if(victim == champion && attacker == challenger)
	// {
	// foreach (player in GetPlayerArray())
	// {
	// thread EmitSoundOnEntityOnlyToPlayer( player, player, "diag_ap_aiNotify_challengerKilledChampion_01" )
	// }		
	// }
	
	// if (victim == killeader && victim == challenger)
// {
		// foreach (player in GetPlayerArray())
	// {
	// thread EmitSoundOnEntityOnlyToPlayer( player, player, "diag_ap_aiNotify_killLeaderEliminated" )
	// }	
	// }
	
	if (victim == champion && victim == killeader)
	{
		foreach (player in GetPlayerArray())
	{
	thread EmitSoundOnEntityOnlyToPlayer( player, player, "diag_ap_aiNotify_championEliminated" )
	}	
	}
	
	if (victim == killeader && victim !=  champion)
	{
		foreach (player in GetPlayerArray())
	{
	thread EmitSoundOnEntityOnlyToPlayer( player, player, "diag_ap_aiNotify_killLeaderEliminated" )
	}	
	}
	
	switch(GetGameState())
    {
    case eGameState.Playing:
        // Víctima
        void functionref() victimHandleFunc = void function() : (victim, attacker, damageInfo) {
           
			if(!IsValid(victim)) return
			UpgradeShields(victim, true)
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
				victim.SetPlayerGameStat( PGS_DEATHS, invscore);
				_HandleRespawn( victim )
				ClearInvincible(victim)
			}} catch (e2) {}
		}
wait 0.5
        // Atacante
        void functionref() attackerHandleFunc = void function() : (victim, attacker, damageInfo)  
		{
            try{
			if(IsValid(attacker) && attacker.IsPlayer() && IsAlive(attacker) && attacker != victim)
            {
			//Variable que usa el scoreboard del lado del cliente (cl file) para mostrar los resultados
			int score = GameRules_GetTeamScore(attacker.GetTeam());
            score++;
            GameRules_SetTeamScore(attacker.GetTeam(), score);
			//Gungame giveweapons
			GiveWeapons(attacker)
			//Autoreload on kill without animation //By CaféDeColombiaFPS
            //WpnAutoReloadOnKill(attacker)
			//Heal
			PlayerRestoreHP(attacker, 100)
			UpgradeShields(attacker, false)
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
}

void function _HandleRespawn(entity player, bool forceGive = false)
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
	if(IsValid( player ) && !IsAlive(player) || forceGive)
    {
        if(Equipment_GetRespawnKitEnabled())
        {
			DecideRespawnPlayer(player, true)
			CharSelect(player)
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
				CharSelect(player)
            }
            else
            {
				DecideRespawnPlayer(player, false)
				CharSelect(player)
                GiveWeaponsFromStoredArray(player, player.p.storedWeapons)
            }
            
        }
    }
	} catch (e) {}
	try {
	if( IsValid( player ) && IsAlive(player))
        {
	TpPlayerToSpawnPoint(player)
	MakeInvincible(player)
	GiveWeapons(player)
	GiveAbilities(player)
    SetPlayerSettings(player, TDM_PLAYER_SETTINGS)
	PlayerRestoreHP(player, 100)
	PlayerRestoreShields(player, player.GetShieldHealthMax())
		}
		} catch (e1) {}
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
    if(!IsValid(player)) return;
    MakeInvincible(player)
    wait duration
    if(!IsValid(player)) return;
    ClearInvincible(player)
}

void function WpnAutoReloadOnKill( entity player )
///////////////////////////////////////////////////////
//By Retículo Endoplasmático#5955 and michae\l/#1125 //
///////////////////////////////////////////////////////
{
    entity weapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
    try {weapon.SetWeaponPrimaryClipCount(weapon.GetWeaponPrimaryClipCountMax())} catch(e){}
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


void function GiveWeapons(entity player) {
	int WeaponIndex = player.GetPlayerGameStat( PGS_KILLS )
	int MaxWeapons = GetCurrentPlaylistVarInt("maxweapons", 0)
		if (WeaponIndex > MaxWeapons) {
        return
		}
	else {
	string currentweapon = GetCurrentPlaylistVarString("weapon" + WeaponIndex, "")
	entity primary = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 )
	entity weapon
	
		if (currentweapon != "") {
			array<string> attachments = []
			
			for(int i = 0; GetCurrentPlaylistVarString("weapon" + WeaponIndex + "_" + i.tostring(), "~~none~~") != "~~none~~"; i++)
			{
				attachments.append(GetCurrentPlaylistVarString("weapon" + WeaponIndex + "_" + i.tostring(), "~~none~~"))
			}
			
			if( IsValid( primary ) ) player.TakeWeaponByEntNow( primary )
			player.GiveWeapon(currentweapon, WEAPON_INVENTORY_SLOT_PRIMARY_0, attachments)
	}

	if( IsValid( weapon) && !weapon.IsWeaponOffhand() ) player.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, GetSlotForWeapon(player, weapon))
}
}


void function GiveAbilities(entity player) {
	string ability0 = GetCurrentPlaylistVarString("tactical_ability", "")
	string ability1 = GetCurrentPlaylistVarString("ultimate_ability", "")

		if (ability0 != "") {
			player.TakeOffhandWeapon( OFFHAND_TACTICAL )
			player.GiveOffhandWeapon(ability0, OFFHAND_TACTICAL)
	}
		if (ability1 != "") {
			player.TakeOffhandWeapon( OFFHAND_ULTIMATE )
			player.GiveOffhandWeapon(ability1, OFFHAND_ULTIMATE)
	}
}


void function PlayerRestoreShields(entity player, int shields) {
    if(IsValid(player) && IsAlive( player ))
        player.SetShieldHealth(shielddd(shields, 0, player.GetShieldHealthMax()))
}

void function PlayerRestoreHP(entity player, int health) {
    if(IsValid(player) && IsAlive( player ))
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

    //If player to upgrade died, then dont do killstreak upgrade, just reset their shield
    if (died) {
        player.SetPlayerGameStat( PGS_TITAN_KILLS, 0 )
        Inventory_SetPlayerEquipment(player, WHITE_SHIELD, "armor")
    } else {
        player.SetPlayerGameStat( PGS_TITAN_KILLS, player.GetPlayerGameStat( PGS_TITAN_KILLS ) + 1)

        switch (player.GetPlayerGameStat( PGS_TITAN_KILLS )) {
	    	case 1:
                Inventory_SetPlayerEquipment(player, WHITE_SHIELD, "armor")
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
            break
            default:
                Inventory_SetPlayerEquipment(player, PURPLE_SHIELD, "armor")
                break
        }
    }


    PlayerRestoreShields(player, player.GetShieldHealthMax())
    PlayerRestoreHP(player, 100)
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
    {VotingPhase()}
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
if(GetBestPlayer()==PlayerWithMostDamage())
{
foreach(player in GetPlayerArray())
    {
        if(IsValid(player))
        {
			//Message(player,"- CHAMPION AND CHALLENGER -", "\n " + GetBestPlayerName() + " is the champion and challenger: number 1 in kills and damage with " + GetBestPlayerScore() + " kills and " + GetDamageOfPlayerWithMostDamage() + " of damage.  \n \n               Waiting for players...", 13, "diag_ap_aiNotify_introChallengerChampion_01")
			//Rev voice
			Message(player,"- THIS IS YOUR CHAMPION -", "\n The champion is " + GetBestPlayerName() + " with " + GetBestPlayerScore() + " kills in the previous round.  \n \n The champion also got the most damage: " + GetDamageOfPlayerWithMostDamage() + "\n\n             Waiting for players...", 8, "diag_ap_nocNotify_introChampion_04_02_3p")
	}}
wait 18
}
else{
foreach(player in GetPlayerArray())
    {
        if(IsValid(player))
        {
			// Message(player,"- THIS IS YOUR CHAMPION -", "\n " + GetBestPlayerName() + " with " + GetBestPlayerScore() + " was the player with most kills. \n             Waiting for players...", 8, "diag_ap_ainotify_introchampion_01_02")
			//Rev voice
			Message(player,"- THIS IS YOUR CHAMPION -", "\n " + GetBestPlayerName() + " with " + GetBestPlayerScore() + " kills in the previous round.  \n\n             Waiting for players...", 8, "diag_ap_nocNotify_introChampion_04_02_3p")
	}}
wait 8
	foreach(player in GetPlayerArray())
    {
        if(IsValid(player))
        {
		Message(player,"- THIS IS YOUR CHALLENGER -", "\n " + PlayerWithMostDamageName() + " with " + GetDamageOfPlayerWithMostDamage() + " was the player with the most damage. \n \n             Waiting for players...", 8, "diag_ap_aiNotify_introChallenger_01_02")	
}}
wait 10}

if (!file.mapIndexChanged) 
    {
        file.nextMapIndex = (file.nextMapIndex + 1 ) % file.locationSettings.len()
    } 
    int choice = file.nextMapIndex
    file.mapIndexChanged = false	
    file.selectedLocation = file.locationSettings[choice]
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
wait 10
try {
        PlayerTrail(GetBestPlayer(),0)
    } catch(e2){}
SetGameState(eGameState.Playing)
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
    }
	} catch(e3){}
}

try {
if(GetBestPlayer()==PlayerWithMostDamage())
{
	foreach(player in GetPlayerArray())
    {
		string nextlocation = file.selectedLocation.name
		Message(player, file.selectedLocation.name + ": ROUND START!", "\n           " + GetBestPlayerName() + " is the champion with " + GetBestPlayerScore() + " kills in the previous round. \n         The champion also got the most damage: " + GetDamageOfPlayerWithMostDamage(), 20, "diag_ap_aiNotify_circleTimerStartNext_02")
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
		Message(player, file.selectedLocation.name + ": ROUND START!", "\n           " + GetBestPlayerName() + " is the champion with " + GetBestPlayerScore() + " kills in the previous round. \n      " + PlayerWithMostDamageName() + " is the challenger with " + GetDamageOfPlayerWithMostDamage() + " of damage in the previous round.", 20, "diag_ap_aiNotify_circleTimerStartNext_02")
		file.previousChampion=GetBestPlayer()
		file.previousChallenger=PlayerWithMostDamage()
		GameRules_SetTeamScore(player.GetTeam(), 0)
		file.deathPlayersCounter = 0
	}
}
} catch(e4){}
ResetAllPlayerStats()
try {
foreach(player in GetPlayerArray())
    {
player.p.playerDamageDealt = 0.0
GiveAbilities(player)
GiveWeapons(player)
UpgradeShields(player, true)
PlayerRestoreShields(player, player.GetShieldHealthMax())
WpnPulloutOnRespawn(player)
	}
} catch(e5){}
file.bubbleBoundary = CreateBubbleBoundary(file.selectedLocation)
SimpleChampionUI()
}



void function SimpleChampionUI(){
//////////////////////////////////////////////////////////////////////////////
/////////////Retículo Endoplasmático#5955 CaféDeColombiaFPS///////////////////
//////////////////////////////////////////////////////////////////////////////
wait file.RoundTime/2
foreach(player in GetPlayerArray())
    {
        if(IsValid(player))
        {
	Message(player,"HALF ROUND!!","\n Name:    K  |   D   |   KD   |   Damage dealt \n" + Scoreboard(), 15)
}}
wait (file.RoundTime/2)-300
foreach(player in GetPlayerArray())
    {
        if(IsValid(player))
        {
	Message(player,"5 MINUTES REMAINING!","\n Name:    K  |   D   |   KD   |   Damage dealt \n" + Scoreboard(), 15)
}}
wait 180
foreach(player in GetPlayerArray())
    {
        if(IsValid(player))
        {
	Message(player,"2 MINUTES REMAINING!","\n Name:    K  |   D   |   KD   |   Damage dealt \n" + Scoreboard(), 15)
}}
wait 60
foreach(player in GetPlayerArray())
    {
        if(IsValid(player))
        {
	Message(player,"1 MINUTE REMAINING!","\n Name:    K  |   D   |   KD   |   Damage dealt \n" + Scoreboard(), 15, "diag_ap_aiNotify_circleMoves60sec")
}}
wait 30
foreach(player in GetPlayerArray())
    {
        if(IsValid(player))
        {
	Message(player,"30 SECONDS REMAINING!", "\n Name:    K  |   D   |   KD   |   Damage dealt \n" + Scoreboard(), 15, "diag_ap_aiNotify_circleMoves30sec")
}}
wait 20
foreach(player in GetPlayerArray())
    {
        if(IsValid(player))
        {
	Message(player,"10 SECONDS REMAINING!", "\n The battle is almost over.", 10, "diag_ap_aiNotify_circleMoves10sec")
}}
wait 10
foreach(player in GetPlayerArray())
    {
	if(IsValid(player) && !IsAlive(player)){
			_HandleRespawn(player)
			ClearInvincible(player)
			MakeInvincible( player )
	}}
wait 1
foreach(player in GetPlayerArray())
    {
try{       
	   if(IsValid(player) && IsAlive(player))
        {
			PlayerRestoreHP(player, 100)
			PlayerRestoreShields(player, player.GetShieldHealthMax())
			player.SetThirdPersonShoulderModeOn()
			HolsterAndDisableWeapons( player )				
	}} catch (e) {}
	}
try{
if(GetBestPlayer()==PlayerWithMostDamage())
{

foreach(player in GetPlayerArray())
    {
	  
	 if(IsValid(player))
        {			
		Message(player,"- CHAMPION DECIDED! -", "\n " + GetBestPlayerName() + " is the champion: number 1 in kills and damage \n with " + GetBestPlayerScore() + " kills and " + GetDamageOfPlayerWithMostDamage() + " of damage.  \n \n        Champion is literally on fire! Weapons disabled! \n Please tbag.", 10, "UI_InGame_ChampionVictory")
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
			thread EmitSoundOnEntityOnlyToPlayer( champion, champion, "diag_ap_nocNotify_victorySolo_04_3p" )
			thread EmitSoundOnEntityExceptToPlayer( champion, champion, "diag_ap_nocNotify_winnerDecided_01_02_3p" )
        PlayerTrail(champion,1)
		}}
	}catch(e2){}
	}
wait 10
foreach(player in GetPlayerArray())
    {
	try{
	 if(IsValid(player)){
	 AddCinematicFlag(player, CE_FLAG_HIDE_MAIN_HUD | CE_FLAG_EXECUTION)			
	 Message(player,"- FINAL SCOREBOARD -", "\n         Name:    K  |   D   |   KD   |   Damage dealt \n \n" + ScoreboardFinal() + "\n \n Scripts by CaféDeColombiaFPS \n and empathogenwarlord", 12, "UI_Menu_RoundSummary_Results")}
	}catch(e3){}
	}
wait 12
foreach(player in GetPlayerArray())
    {
        try{
		if(IsValid(player)){
		ClearInvincible(player)
		RemoveCinematicFlag(player, CE_FLAG_HIDE_MAIN_HUD | CE_FLAG_EXECUTION)
		player.SetThirdPersonShoulderModeOff()
	}}catch(e4){}}
WaitFrame()
file.tdmState = eTDMState.IN_PROGRESS
file.bubbleBoundary.Destroy()	
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
    bubbleShield.kv.rendercolor = file.bubblecolor
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

// void function PlayerRestoreHP(entity player, float health, float shields)
// {
    // player.SetHealth( health )
    // // Inventory_SetPlayerEquipment(player, "helmet_pickup_lv4_abilities", "helmet")
	// // disabled cuz helmets not working :(
    // if(shields == 0) return;
    // else if(shields <= 50)
        // Inventory_SetPlayerEquipment(player, "armor_pickup_lv1", "armor")
    // else if(shields <= 75)
        // Inventory_SetPlayerEquipment(player, "armor_pickup_lv2", "armor")
    // else if(shields <= 100)
        // Inventory_SetPlayerEquipment(player, "armor_pickup_lv3", "armor")
    // player.SetShieldHealth( shields )
// }

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
ItemFlavor PersonajeEscogido = file.characters[file.PersonajeEscogido]
array<ItemFlavor> characterSkins = GetValidItemFlavorsForLoadoutSlot( ToEHI( player ), Loadout_CharacterSkin( PersonajeEscogido ) )
CharacterSelect_AssignCharacter( ToEHI( player ), PersonajeEscogido )

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
	
string function ScoreboardFinal()
//Este muestra el scoreboard completo
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

bool function ClientCommand_GiveWeapon(entity player, array<string> args)
{	
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
///////////////////////
//Thanks Archtux#9300//
///////////////////////
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
                file.tdmState = eTDMState.WINNER_DECIDED
            }
        } catch(e1) {}

        try{
            string now = args[1]
            if (now == "now")
            {
                file.tdmState = eTDMState.WINNER_DECIDED
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
	if(!IsServer()) return false;
	try{MakeInvincible(player)}catch(e) {}
    return true
}

bool function ClientCommand_UnGod(entity player, array<string> args) 
///////////////////////////////////////////////////////
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
///////////////////////////////////////////////////////
{
	if(!IsServer()) return false;
	try{ClearInvincible(player)}catch(e) {}
    return true
}