global function _CustomTDM_Init
global function _RegisterLocation


enum eTDMState
{
	IN_PROGRESS = 0
	WINNER_DECIDED = 1
}

struct {
    int tdmState = eTDMState.IN_PROGRESS
    array<entity> playerSpawnedProps
    LocationSettings& selectedLocation

    array<LocationSettings> locationSettings

    
    array<string> whitelistedWeapons

    entity bubbleBoundary
} file;


void function _CustomTDM_Init()
{

    AddCallback_OnClientConnected( void function(entity player) { thread _OnPlayerConnected(player) } )
    AddCallback_OnPlayerKilled(void function(entity victim, entity attacker, var damageInfo) {thread _OnPlayerDied(victim, attacker, damageInfo)})

    AddClientCommandCallback("next_round", ClientCommand_NextRound)
    if( CMD_GetTGiveEnabled() )
    {
        AddClientCommandCallback("tgive", ClientCommand_GiveWeapon)
    }
    
    thread RunTDM()

    // Whitelisted weapons
    for(int i = 0; GetCurrentPlaylistVarString("whitelisted_weapon_" + i.tostring(), "~~none~~") != "~~none~~"; i++)
    {
        file.whitelistedWeapons.append(GetCurrentPlaylistVarString("whitelisted_weapon_" + i.tostring(), "~~none~~"))
    }

}

void function _RegisterLocation(LocationSettings locationSettings)
{
    file.locationSettings.append(locationSettings)
}

LocPair function _GetVotingLocation()
{
    switch(GetMapName())
    {
        case "mp_rr_canyonlands_staging":
            return NewLocPair(<26794, -6241, -27479>, <0, 0, 0>)
        case "mp_rr_canyonlands_64k_x_64k":
        case "mp_rr_canyonlands_mu1":
        case "mp_rr_canyonlands_mu1_night":
            return NewLocPair(<-6252, -16500, 3296>, <0, 0, 0>)
        case "mp_rr_desertlands_64k_x_64k":
        case "mp_rr_desertlands_64k_x_64k_nx":
                return NewLocPair(<1763, 5463, -3145>, <5, -95, 0>)
        default:
            Assert(false, "No voting location for the map!")
    }
    unreachable
}

void function _OnPropDynamicSpawned(entity prop)
{
    file.playerSpawnedProps.append(prop)
    
}
void function RunTDM()
{
    WaitForGameState(eGameState.Playing)
    AddSpawnCallback("prop_dynamic", _OnPropDynamicSpawned)

    for(; ; )
    {
        VotingPhase();
        StartRound();
    }
    WaitForever()
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



void function VotingPhase()
{
    DestroyPlayerProps();
    SetGameState(eGameState.MapVoting)
    
    //Reset scores
    GameRules_SetTeamScore(TEAM_IMC, 0)
    GameRules_SetTeamScore(TEAM_MILITIA, 0)
    
    foreach(player in GetPlayerArray()) 
    {
        if(!IsValid(player)) continue;
        _HandleRespawn(player)
        MakeInvincible(player)
		HolsterAndDisableWeapons( player )
        player.ForceStand()
        Remote_CallFunction_NonReplay(player, "ServerCallback_TDM_DoAnnouncement", 2, eTDMAnnounce.VOTING_PHASE)
        TpPlayerToSpawnPoint(player)
        player.UnfreezeControlsOnServer();      
    }
    wait Deathmatch_GetVotingTime()
    int choice = RandomIntRangeInclusive(0, file.locationSettings.len() - 1)

    file.selectedLocation = file.locationSettings[choice]
    
    foreach(player in GetPlayerArray())
    {
        Remote_CallFunction_NonReplay(player, "ServerCallback_TDM_SetSelectedLocation", choice)
    }
}

void function StartRound() 
{
    SetGameState(eGameState.Playing)
    
    foreach(player in GetPlayerArray())
    {
        if(IsValid(player))
        {
            thread ScreenFadeToFromBlack(player)
            AddCinematicFlag(player, CE_FLAG_HIDE_MAIN_HUD | CE_FLAG_INTRO)
            player.FreezeControlsOnServer()
        }
        
    }
    wait 1
    foreach(player in GetPlayerArray())
    {
        if(IsValid(player))
            Remote_CallFunction_NonReplay(player, "ServerCallback_TDM_DoLocationIntroCutscene")
        
    }
    

    foreach(player in GetPlayerArray())
    {
        if(IsValid(player))
            Remote_CallFunction_NonReplay(player, "ServerCallback_TDM_DoAnnouncement", 4, eTDMAnnounce.MAP_FLYOVER)
    }
    wait Deathmatch_GetIntroCutsceneSpawnDuration() * Deathmatch_GetIntroCutsceneNumSpawns()
    

    foreach(player in GetPlayerArray())
    {   
        if( IsValid( player ) )
        {
            thread ScreenFadeFromBlack(player, 0.5, 0.5)
            RemoveCinematicFlag(player, CE_FLAG_HIDE_MAIN_HUD | CE_FLAG_INTRO)

            Remote_CallFunction_NonReplay(player, "ServerCallback_TDM_DoAnnouncement", 5, eTDMAnnounce.ROUND_START)
            ClearInvincible(player)
            DeployAndEnableWeapons(player)
            player.UnforceStand()  
            player.UnfreezeControlsOnServer()   
            TpPlayerToSpawnPoint(player)

            //AddPlayerMovementEventCallback(player, ePlayerMovementEvents.TOUCH_GROUND, _HandleRespawnOnLand)
        }
        
    }

    
    file.bubbleBoundary = CreateBubbleBoundary(file.selectedLocation)

    foreach(team, v in GetPlayerTeamCountTable())
    {
        array<entity> squad = GetPlayerArrayOfTeam(team)
        //thread RespawnPlayersInDropshipAtPoint(squad, squad[0].GetOrigin(), squad[0].GetAngles())
    }
    float endTime = Time() + GetCurrentPlaylistVarFloat("round_time", 480)
    while( Time() <= endTime )
	{
        if(file.tdmState == eTDMState.WINNER_DECIDED)
            break
		WaitFrame()
	}
    file.tdmState = eTDMState.IN_PROGRESS

    file.bubbleBoundary.Destroy()
    
}

void function _HandleRespawnOnLand(entity player)
{
    RemovePlayerMovementEventCallback(player, ePlayerMovementEvents.TOUCH_GROUND, _HandleRespawnOnLand)

    //thread f()
    
}
void function ScreenFadeToFromBlack(entity player, float fadeTime = 1, float holdTime = 1)
{
    if( IsValid( player ) )
        ScreenFadeToBlack(player, fadeTime / 2, holdTime / 2)
    wait fadeTime
    if( IsValid( player ) )
        ScreenFadeFromBlack(player, fadeTime / 2, holdTime / 2)
}

bool function ClientCommand_NextRound(entity player, array<string> args)
{
    if( !IsServer() ) return false;
    file.tdmState = eTDMState.WINNER_DECIDED
    return true
}

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
                if( IsValid( tactical ) ) player.TakeOffhandWeapon( OFFHAND_TACTICAL )
                weapon = player.GiveOffhandWeapon(args[1], OFFHAND_TACTICAL)
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
    
    if( IsValid( weapon) && !weapon.IsWeaponOffhand() ) player.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, GetSlotForWeapon(player, weapon))
    return true
    
}



void function _OnPlayerConnected(entity player)
{
    if(!IsValid(player)) return

    //Give passive regen (pilot blood)
    GivePassive(player, ePassives.PAS_PILOT_BLOOD)
    //SetPlayerSettings(player, TDM_PLAYER_SETTINGS)

    if(!IsAlive(player))
    {
        _HandleRespawn(player)
    }

    
    switch(GetGameState())
    {

    case eGameState.WaitingForPlayers:
        player.FreezeControlsOnServer()
        break
    case eGameState.Playing:
        player.UnfreezeControlsOnServer();
        Remote_CallFunction_NonReplay(player, "ServerCallback_TDM_DoAnnouncement", 5, eTDMAnnounce.ROUND_START)

        break
    default: 
        break
    }
}




void function _OnPlayerDied(entity victim, entity attacker, var damageInfo) 
{

    
    switch(GetGameState())
    {
    case eGameState.Playing:

        // What happens to victim 
        void functionref() victimHandleFunc = void function() : (victim, attacker, damageInfo) {

            if(!IsValid(victim)) return
            

            victim.p.storedWeapons = StoreWeapons(victim)
            
            if(Spectator_GetReplayIsEnabled() && IsValid(victim) && ShouldSetObserverTarget( attacker ))
            {
                victim.SetObserverTarget( attacker )
                victim.SetSpecReplayDelay( Spectator_GetReplayDelay() )
                victim.StartObserverMode( OBS_MODE_IN_EYE )
                Remote_CallFunction_NonReplay(victim, "ServerCallback_KillReplayHud_Activate")
            }
            
            wait Deathmatch_GetRespawnDelay()

             

            if(IsValid(victim) )
            {
                _HandleRespawn( victim )
            }

        }

        
        // What happens to attacker
        void functionref() attackerHandleFunc = void function() : (victim, attacker, damageInfo)  {
            if(IsValid(attacker) && attacker.IsPlayer() && IsAlive(attacker) && attacker != victim)
            {
                int score = GameRules_GetTeamScore(attacker.GetTeam());
                score++;
                GameRules_SetTeamScore(attacker.GetTeam(), score);
                if(score >= SCORE_GOAL_TO_WIN)
                {
                    foreach( entity player in GetPlayerArray() )
                    {
                        thread EmitSoundOnEntityOnlyToPlayer( player, player, "diag_ap_aiNotify_winnerFound" )
                    }
                    file.tdmState = eTDMState.WINNER_DECIDED
                }
                PlayerRestoreHP(attacker, 100, Equipment_GetDefaultShieldHP())
            }
        }
        
        thread victimHandleFunc()
        thread attackerHandleFunc()
        //Tell each player to update their Score RUI
        foreach(player in GetPlayerArray())
        {
            Remote_CallFunction_NonReplay(player, "ServerCallback_TDM_PlayerKilled")
        }
        break
    default:

    }
}

void function _HandleRespawn(entity player, bool forceGive = false)
{
    if(!IsValid(player)) return

    if( player.IsObserver())
    {
        player.StopObserverMode()
        Remote_CallFunction_NonReplay(player, "ServerCallback_KillReplayHud_Deactivate")
    }

    if(!IsAlive(player) || forceGive)
    {

        if(Equipment_GetRespawnKitEnabled())
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
            player.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_0)
        }
        else 
        {
            if(!player.p.storedWeapons.len())
            {
                DecideRespawnPlayer(player, true)
            }
            else
            {
                DecideRespawnPlayer(player, false)
                GiveWeaponsFromStoredArray(player, player.p.storedWeapons)
            }
            
        }
    }
    
    SetPlayerSettings(player, TDM_PLAYER_SETTINGS)
    PlayerRestoreHP(player, 100, Equipment_GetDefaultShieldHP())
                
    TpPlayerToSpawnPoint(player)
    thread GrantSpawnImmunity(player, 3)
}


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
    
    bubbleRadius += GetCurrentPlaylistVarFloat("bubble_radius_padding", 800)

    entity bubbleShield = CreateEntity( "prop_dynamic" )
	bubbleShield.SetValueForModelKey( BUBBLE_BUNKER_SHIELD_COLLISION_MODEL )
    bubbleShield.SetOrigin(bubbleCenter)
    bubbleShield.SetModelScale(bubbleRadius / 235)
    bubbleShield.kv.CollisionGroup = 0
    bubbleShield.kv.rendercolor = "127 73 37"
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
    Inventory_SetPlayerEquipment(player, "helmet_pickup_lv4_abilities", "helmet")

    if(shields == 0) return;
    else if(shields <= 50)
        Inventory_SetPlayerEquipment(player, "armor_pickup_lv1", "armor")
    else if(shields <= 75)
        Inventory_SetPlayerEquipment(player, "armor_pickup_lv2", "armor")
    else if(shields <= 100)
        Inventory_SetPlayerEquipment(player, "armor_pickup_lv3", "armor")
    player.SetShieldHealth( shields )

}

void function GrantSpawnImmunity(entity player, float duration)
{
    if(!IsValid(player)) return;
    MakeInvincible(player)
    wait duration
    if(!IsValid(player)) return;
    ClearInvincible(player)
}


LocPair function _GetAppropriateSpawnLocation(entity player)
{
    int ourTeam = player.GetTeam()

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
            vector enemyOrigin = GetClosestEnemyToOrigin(spawn.origin, ourTeam)
            float distToEnemy = Distance(spawn.origin, enemyOrigin)

            if(distToEnemy > maxDistToEnemy)
            {
                maxDistToEnemy = distToEnemy
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

void function TpPlayerToSpawnPoint(entity player)
{
	
	LocPair loc = _GetAppropriateSpawnLocation(player)

    player.SetOrigin(loc.origin)
    player.SetAngles(loc.angles)

    
    PutEntityInSafeSpot( player, null, null, player.GetOrigin() + <0,0,128>, player.GetOrigin() )
}
