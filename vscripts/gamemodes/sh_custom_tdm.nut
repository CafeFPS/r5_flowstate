///////////////////////////////////////////
//                                       //
//          Custom TDM Gamemode          //
//                                       //
///////////////////////////////////////////
//                                       //
//    Credits:                           //
//      sal#3261 - main                  //
//      Shrugtal - score ui              //
//                                       //
///////////////////////////////////////////

global function CustomTDM_Init
#if CLIENT
global function ServerCallback_TDM_DoAnnouncement
global function ServerCallback_TDM_SetSelectedLocation
global function ServerCallback_TDM_DoLocationIntroCutscene
global function ServerCallback_TDM_PlayerKilled
#endif

#if SERVER
global function PlayerRoundRespawn
#endif

const TEAM_PREDS = 6

const array< int > teams = [ TEAM_IMC, TEAM_MILITIA ]
const MIN_NUMBER_OF_PLAYERS = 1
const VOTING_TIME = 5
const ROUND_TIME = 250
const NO_CHOICES = 2
const LOCATION_CUTSCENE_DURATION = 9
const SCORE_GOAL_TO_WIN = 15

#if CLIENT || SERVER
enum eTDMAnnounce
{
	NONE = 0
	WAITING_FOR_PLAYERS = 1
	ROUND_START = 2
	VOTING_PHASE = 3
	MAP_FLYOVER = 4
	IN_PROGRESS = 5
}
#endif

#if SERVER
enum eTDMState
{
	IN_PROGRESS = 0
	WINNER_DECIDED = 1
}
#endif

struct LocPair
{
    vector origin = <0, 0, 0>
    vector angles = <0, 0, 0>
}

struct LocationSettings {
    string name
    table< int, array<LocPair> > spawns
    vector cinematicCameraOffset
}

struct WeaponKit
{
    string weapon
    array<string> mods
}

struct {
    LocationSettings &selectedLocation
    array choices
    table playersChoiceIndex
    array<LocationSettings> locationSettings
    var scoreRui

    #if SERVER
    int tdmState = eTDMState.IN_PROGRESS
    array<entity> playerSpawnedProps
    #endif
} file;




void function CustomTDM_Init() 
{
    // Map locations

    switch(GetMapName())
    {
    case "mp_rr_canyonlands_64k_x_64k":
        Shared_RegisterLocation(
            NewLocationSettings(
                "Skull Town",
                {
                    [TEAM_IMC] = [
                        NewLocPair(<-9320, -13528, 3167>, <0, -100, 0>),
                        NewLocPair(<-7544, -13240, 3161>, <0, -115, 0>)
                    ],
                    [TEAM_MILITIA] = [
                        NewLocPair(<-10250, -18320, 3323>, <0, 100, 0>),
                        NewLocPair(<-13261, -18100, 3337>, <0, 20, 0>)
                    ]
                },
                <0, 0, 3000>
            )
        )
    
        Shared_RegisterLocation(
            NewLocationSettings(
                "Little Town",
                {
                    [TEAM_IMC] = [
                        NewLocPair(<-30190, 12473, 3186>, <0, -90, 0>),
                        NewLocPair(<-28773, 11228, 3210>, <0, 180, 0>)
                    ],
                    [TEAM_MILITIA] = [
                        NewLocPair(<-29802, 9886, 3217>, <0, 90, 0>),
                        NewLocPair(<-30895, 10733, 3202>, <0, 0, 0>)
                    ]
                },
                <0, 0, 3000>
            )
        )
    
        Shared_RegisterLocation(
            NewLocationSettings(
                "Market",
                {
                    [TEAM_IMC] = [
                        NewLocPair(<-110, -9977, 2987>, <0, 0, 0>),
                        NewLocPair(<-1605, -10300, 3053>, <0, -100, 0>)
                    ],
                    [TEAM_MILITIA] = [
                        NewLocPair(<4600, -11450, 2950>, <0, 180, 0>),
                        NewLocPair(<3150, -11153, 3053>, <0, 100, 0>)
                    ]
                },
                <0, 0, 3000>
            )
        )
    
        Shared_RegisterLocation(
            NewLocationSettings(
                "Runoff",
                {
                    [TEAM_IMC] = [
                        NewLocPair(<-23380, 9634, 3371>, <0, 90, 0>),
                        NewLocPair(<-24917, 11273, 3085>, <0, 0, 0>)
                    ],
                    [TEAM_MILITIA] = [
                        NewLocPair(<-23614, 13605, 3347>, <0, -90, 0>),
                        NewLocPair(<-24697, 12631, 3085>, <0, 0, 0>)
                    ]
                },
                <0, 0, 3000>
            )
        )
    
        Shared_RegisterLocation(
            NewLocationSettings(
                "Thunderdome",
                {
                    [TEAM_IMC] = [
                        NewLocPair(<-20216, -21612, 3191>, <0, -67, 0>),
                        NewLocPair(<-16035, -20591, 3232>, <0, -133, 0>)
                    ],
                    [TEAM_MILITIA] = [
                        NewLocPair(<-16584, -24859, 2642>, <0, 165, 0>),
                        NewLocPair(<-19019, -26209, 2640>, <0, 65, 0>)
                    ]
                },
                <0, 0, 2000>
            )
        )
        
        Shared_RegisterLocation(
            NewLocationSettings(
                "Water Treatment",
                {
                    [TEAM_IMC] = [
                        NewLocPair(<5583, -30000, 3070>, <0, 0, 0>),
                        NewLocPair(<7544, -29035, 3061>, <0, 130, 0>)
                    ],
                    [TEAM_MILITIA] = [
                        NewLocPair(<10091, -30000, 3070>, <0, 180, 0>),
                        NewLocPair(<8487, -28838, 3061>, <0, -45, 0>)
                    ]
                },
                <0, 0, 3000>
            )
        )
            
    
        Shared_RegisterLocation(
            NewLocationSettings(
                "The Pit",
                {
                    [TEAM_IMC] = [
                        NewLocPair(<-18558, 13823, 3605>, <0, 20, 0>),
                        NewLocPair(<-16514, 16184, 3772>, <0, -77, 0>)
                    ],
                    [TEAM_MILITIA] = [
                        NewLocPair(<-13826, 15325, 3749>, <0, 160, 0>),
                        NewLocPair(<-16160, 14273, 3770>, <0, 101, 0>)
                    ]
                },
                <0, 0, 7000>
            )
        )
    
        
        Shared_RegisterLocation(
            NewLocationSettings(
                "Airbase",
                {
                    [TEAM_IMC] = [
                        NewLocPair(<-24140, -4510, 2583>, <0, 90, 0>),
                        NewLocPair(<-28675, 612, 2600>, <0, 18, 0>)
                    ],
                    [TEAM_MILITIA] = [
                        NewLocPair(<-24688, 1316, 2583>, <0, 180, 0>),
                        NewLocPair(<-26492, -5197, 2574>, <0, 50, 0>)
                    ]
                },
                <0, 0, 3000>
            )
        )
        break

        case "mp_rr_desertlands_64k_x_64k":
            Shared_RegisterLocation(
                NewLocationSettings(
                    "TTV Building",
                    {
                        [TEAM_IMC] = [
                            NewLocPair(<11393, 5477, -4289>, <0, 90, 0>)
                        ],
                        [TEAM_MILITIA] = [
                            NewLocPair(<8105, 6156, -4266>, <0, -45, 0>)
                        ]
                    },
                    <0, 0, 3000>
                )
            )

        default:
            Assert(false, "No TDM locations found for map!")
    }
   

    // Get Deathfield


    //Client Signals
    RegisterSignal( "CloseScoreRUI" )
    
    #if SERVER

    KC_DeleteFlyers()


    // Callbacks

    AddCallback_OnPlayerKilled(SV_OnPlayerDied)
    AddCallback_OnClientConnected(SV_OnPlayerConnected)
    AddClientCommandCallback("next_round", ClientCommand_NextRound)
        
    thread RunTDM()

    #endif
}

WeaponKit function NewWeaponKit(string weapon, array<string> mods)
{
    WeaponKit weaponKit
    weaponKit.weapon = weapon
    weaponKit.mods = mods
    
    return weaponKit
}
LocPair function NewLocPair(vector origin, vector angles)
{
    LocPair locPair
    locPair.origin = origin
    locPair.angles = angles

    return locPair
}

LocationSettings function NewLocationSettings(string name, table< int, array<LocPair> > spawns, vector cinematicCameraOffset)
{
    LocationSettings locationSettings
    locationSettings.name = name
    locationSettings.spawns = spawns
    locationSettings.cinematicCameraOffset = cinematicCameraOffset

    return locationSettings
}


void function Shared_RegisterLocation(LocationSettings locationSettings)
{
    file.locationSettings.append(locationSettings)

}


#if SERVER

void function DEBUG_TestSpawnLocs(entity player)
{
    foreach(locationSetting in file.locationSettings)
    {
        foreach(teamSpawnsArray in locationSetting.spawns)
        {
            foreach(spawn in teamSpawnsArray)
            {
                player.SetOrigin(OriginToGround(spawn.origin))
                player.SetAngles(spawn.angles)
                wait 2
                if(!IsAlive(player)) {
                    WaitForever()
                    DoRespawnPlayer(player, null)
                }
            }
        }
    }
}

LocPair function SV_GetVotingLocation()
{
    switch(GetMapName())
    {
        case "mp_rr_canyonlands_64k_x_64k":
            return NewLocPair(<-6252, -16500, 3296>, <0, 0, 0>)
        case "mp_rr_desertlands_64k_x_64k":
            return NewLocPair(<1763, 5463, -3145>, <5, -95, 0>)
        default:
            Assert(false, "No voting location for the map!")
    }
    unreachable
}
void function SV_OnPropDynamicSpawned(entity prop)
{
    file.playerSpawnedProps.append(prop)
    
}
void function RunTDM()
{
    WaitPrematch()
    AddSpawnCallback("prop_dynamic", SV_OnPropDynamicSpawned)
    wait 5
    for(; ; )
    {
        VotingPhase();
        StartRound();
    }
    WaitForever()
}

void function WaitPrematch() 
{
    array<entity> players = GetPlayerArray()
    while(players.len() < MIN_NUMBER_OF_PLAYERS)
    {
        foreach(player in players)
        {
            Remote_CallFunction_NonReplay(player, "ServerCallback_TDM_DoAnnouncement", 200, eTDMAnnounce.WAITING_FOR_PLAYERS)
        }
        wait 3
        players = GetPlayerArray()
    }
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
    SetTDMRoundInProgress(false)
    
    //Reset scores
    GameRules_SetTeamScore(TEAM_IMC, 0)
    GameRules_SetTeamScore(TEAM_MILITIA, 0)
    
    foreach(player in GetPlayerArray()) 
    {
        if(!IsValid(player)) continue;
        if(!IsAlive(player))
        {
            DoRespawnPlayer(player, null)
        }
        MakeInvincible(player)
		HolsterAndDisableWeapons( player )
        player.ForceStand()
        player.SetHealth( 100 )
        Remote_CallFunction_NonReplay(player, "ServerCallback_TDM_DoAnnouncement", 2, eTDMAnnounce.VOTING_PHASE)
        TpPlayerToSpawnPoint(player)
        file.playersChoiceIndex[player] <- 0
    }
    wait VOTING_TIME

    int choice = RandomIntRangeInclusive(0, file.locationSettings.len() - 1)

    file.selectedLocation = file.locationSettings[choice]
    
    foreach(player in GetPlayerArray())
    {
        Remote_CallFunction_NonReplay(player, "ServerCallback_TDM_SetSelectedLocation", choice)
    }
}

void function StartRound() 
{
    SetTDMRoundInProgress(true)

    foreach(player in GetPlayerArray())
    {
        Remote_CallFunction_NonReplay(player, "ServerCallback_TDM_DoLocationIntroCutscene")
        thread ScreenFadeToFromBlack(player)
    }
    wait 1
    foreach(player in GetPlayerArray())
    {
        if(!IsAlive(player))
        {
            DoRespawnPlayer(player, null)
            player.SetHealth( 100 )
        }
        TpPlayerToSpawnPoint(player)
        
    }
    foreach(player in GetPlayerArray())
    {
        Remote_CallFunction_NonReplay(player, "ServerCallback_TDM_DoAnnouncement", 4, eTDMAnnounce.MAP_FLYOVER)
    }
    wait LOCATION_CUTSCENE_DURATION
    // foreach(player in GetPlayerArray())
    // {
    //     thread ScreenFadeToFromBlack(player)
    // }
    wait 2
    foreach(player in GetPlayerArray())
    {
        Remote_CallFunction_NonReplay(player, "ServerCallback_TDM_DoAnnouncement", 5, eTDMAnnounce.ROUND_START)
        ClearInvincible(player)
        DeployAndEnableWeapons(player)
        player.UnforceStand()
        
    }
    float endTime = Time() + ROUND_TIME
    while( Time() <= endTime )
	{
        if(file.tdmState == eTDMState.WINNER_DECIDED)
            break
		WaitFrame()
	}
    file.tdmState = eTDMState.IN_PROGRESS
}


void function ScreenFadeToFromBlack(entity player, float fadeTime = 1, float holdTime = 1)
{
    ScreenFadeToBlack(player, fadeTime / 2, holdTime / 2)
    wait fadeTime
    ScreenFadeFromBlack(player, fadeTime / 2, holdTime / 2)
}

bool function ClientCommand_NextRound(entity player, array<string> args)
{
    file.tdmState = eTDMState.WINNER_DECIDED
    return true
}


void function FillPlayerToNeedyTeam(entity player)
{
    Assert(teams.len() > 0, "You need to define at least one team!")
    int minTeam = teams[0]
    int minPlayersOfTeam = GetPlayerArrayOfTeam(minTeam).len()
    
    foreach(team in teams)
    {
        printt("TEAM ", team, ": ")
        foreach(pl in GetPlayerArrayOfTeam(team))
            printt(pl, ", ")

        print("\n")
        int playersOfTeam = GetPlayerArrayOfTeam(team).len()
        if(playersOfTeam < minPlayersOfTeam)
        {
            minPlayersOfTeam = playersOfTeam
            minTeam = team
        }
    }
    SetTeam(player, minTeam)
}

void function SV_OnPlayerConnected(entity player)
{
    // set index of team
    int index = GetPlayerArrayOfTeam(player.GetTeam()).len() - 1
    player.SetTeamMemberIndex(index)

    // Give passive regen (pilot blood)
    GivePassive(player, ePassives.PAS_PILOT_BLOOD)

    // Set player settings (bloodhound)
    player.SetPlayerSettingsWithMods( $"settings/player/mp/pilot_survival_tracker.rpak", [] )	


    if(GetTDMRoundInProgress())
    {
        Remote_CallFunction_NonReplay(player, "ServerCallback_TDM_DoAnnouncement", 5, eTDMAnnounce.ROUND_START)
    }
    thread PlayerRoundRespawn(player)
}


void function SV_OnPlayerDied(entity victim, entity attacker, var damageInfo) 
{
    if(!GetTDMRoundInProgress()) return;

    if(IsValid(victim) && !IsAlive(victim))
    {
        array<entity> weapons = GetPrimaryWeapons(victim)
        array<string> weaponNames = []

        foreach(weapon in weapons)
        {
            weaponNames.push(weapon.GetWeaponClassName())
        }
        thread PlayerRoundRespawn(victim, weaponNames)
    }

    if(attacker.IsPlayer() && IsAlive(attacker))
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
        attacker.SetHealth(100)
        attacker.SetShieldHealth(100)
    }
    
    //Tell each player to update their Score RUI
    foreach(player in GetPlayerArray())
    {
        Remote_CallFunction_NonReplay(player, "ServerCallback_TDM_PlayerKilled")
    }
}

void function PlayerRoundRespawn(entity victim, array<string> weaponNames = [])
{
    wait 1.5

    if(!IsValid(victim)) return;
    DoRespawnPlayer(victim, null)

    victim.SetHealth( 100 )
    Inventory_SetPlayerEquipment(victim, "armor_pickup_lv3", "armor")
    Inventory_SetPlayerEquipment(victim, "helmet_pickup_lv4_abilities", "helmet")
    victim.SetShieldHealth( 100 )

    TpPlayerToSpawnPoint(victim)
    
    foreach(weaponName in weaponNames)
    {
        victim.GiveWeapon(weaponName, WEAPON_INVENTORY_SLOT_ANY)
    }
    // array<WeaponKit> weaponsGood = [
    //     NewWeaponKit("mp_weapon_energy_shotgun", ["optic_cq_hcog_classic"]),
    //     NewWeaponKit("mp_weapon_lmg", ["optic_cq_hcog_bruiser"]),
    //     NewWeaponKit("mp_weapon_shotgun", ["optic_cq_hcog_classic"]),
    //     NewWeaponKit("mp_weapon_sniper", []),
    //     NewWeaponKit("mp_weapon_r97", ["optic_cq_hcog_classic"]),
    //     NewWeaponKit("mp_weapon_hemlok", ["optic_cq_hcog_bruiser"]),
    //     NewWeaponKit("mp_weapon_wingman", ["optic_cq_hcog_classic"]),
    //     NewWeaponKit("mp_weapon_pdw", ["optic_cq_hcog_classic"]),
    //     NewWeaponKit("mp_weapon_energy_ar", ["optic_cq_hcog_bruiser"]),
    //     NewWeaponKit("mp_weapon_esaw", ["optic_cq_hcog_bruiser"]),
    //     NewWeaponKit("mp_weapon_rspn101", ["optic_cq_hcog_bruiser"])
    // ]

    // array<WeaponKit> weaponsBad = [
    //     NewWeaponKit("mp_weapon_semipistol", ["optic_cq_hcog_classic"]),
    //     NewWeaponKit("mp_weapon_g2", ["optic_ranged_hcog"]),
    //     NewWeaponKit("mp_weapon_autopistol", ["optic_cq_hcog_classic"]),
    //     NewWeaponKit("mp_weapon_alternator_smg", ["optic_cq_hcog_classic"]),
    //     NewWeaponKit("mp_weapon_dmr", ["optic_ranged_hcog"]),
    //     NewWeaponKit("mp_weapon_doubletake", ["optic_ranged_hcog"])
    // ]

    array<string> tacticals = [
        // "mp_ability_area_sonar_scan",
        // "mp_weapon_deployable_medic",
        // "mp_ability_grapple"
        "mp_ability_phase_walk",
        // "mp_weapon_bubble_bunker",
        // "mp_weapon_grenade_bangalore",
        // "mp_weapon_grenade_sonar",
        // "mp_weapon_deployable_cover"
        //"mp_ability_3dash"
    ]

    // array<string> ultimates = [
    //     "mp_weapon_zipline",
    //     "mp_weapon_jump_pad"
    // ]

    array<string> ordnances = [
        "mp_weapon_frag_grenade",
        // "mp_weapon_grenade_electric_smoke"
    ]

    // WeaponKit weaponKit1 = weaponsGood[RandomIntRangeInclusive(0, weaponsGood.len() - 1)]
    // WeaponKit weaponKit2 = weaponsBad[RandomIntRangeInclusive(0, weaponsBad.len() - 1)]

    // entity weapon1 = victim.GiveWeapon( weaponKit1.weapon, WEAPON_INVENTORY_SLOT_ANY )
	// entity weapon2 = victim.GiveWeapon( weaponKit2.weapon, WEAPON_INVENTORY_SLOT_ANY )

    // weapon1.SetMods(weaponKit1.mods)
    // weapon2.SetMods(weaponKit2.mods)
    
	victim.GiveWeapon(ordnances[RandomIntRangeInclusive(0, ordnances.len() - 1)] , WEAPON_INVENTORY_SLOT_ANY )
	// victim.GiveWeapon( "mp_weapon_melee_survival", WEAPON_INVENTORY_SLOT_PRIMARY_2 )
	GivePassive( victim, ePassives.PAS_OCTANE )
	// victim.GiveOffhandWeapon( "melee_pilot_emptyhanded", OFFHAND_MELEE )
	victim.GiveOffhandWeapon( tacticals[RandomIntRangeInclusive(0, tacticals.len() - 1)], OFFHAND_SPECIAL )
	// victim.GiveOffhandWeapon( ultimates[RandomIntRangeInclusive(0, ultimates.len() - 1)], OFFHAND_INVENTORY )
	// victim.GiveOffhandWeapon( CONSUMABLE_WEAPON_NAME, OFFHAND_SLOT_FOR_CONSUMABLES )

	// EnableOffhandWeapons( victim )

    
	// entity ultimateAbility = victim.GetOffhandWeapon( OFFHAND_INVENTORY )
	// int ammoMax = ultimateAbility.GetWeaponPrimaryClipCountMax()
	// ultimateAbility.SetWeaponPrimaryClipCount( ammoMax )
    

    if(!IsValid(victim)) return;
    MakeInvincible(victim)
    wait 3
    if(!IsValid(victim)) return;
    ClearInvincible(victim)
}

void function KC_DeleteFlyers()
{
    array<entity> flyers = GetEntArrayByClass_Expensive("prop_dynamic")
    foreach(flyer in flyers)
    {
        if(flyer.GetModelName() == $"mdl/creatures/flyer/flyer_kingscanyon_animated.rmdl") // found the flyer
        {
            flyer.Destroy() // burn
        }
    }
}

LocPair function SV_GetAppropriateSpawnLocation(entity player)
{
    int ourTeam = player.GetTeam()

    LocPair selectedSpawn
    if(!GetTDMRoundInProgress()) selectedSpawn = SV_GetVotingLocation() 
    else {
        float maxDistToEnemy = 0
        foreach(spawn in file.selectedLocation.spawns[ourTeam])
        {
            vector enemyOrigin = GetClosestEnemyToOrigin(spawn.origin, ourTeam)
            float distToEnemy = Length2D(spawn.origin - enemyOrigin)

            if(distToEnemy > maxDistToEnemy)
            {
                maxDistToEnemy = distToEnemy
                selectedSpawn = spawn
            }
        }
    }
    return selectedSpawn
}

vector function GetClosestEnemyToOrigin(vector origin, int ourTeam)
{
    float minDist = -1
    vector enemyOrigin = <0, 0, 0>

    foreach(team in teams)
    {
        if(ourTeam == team) continue;

        foreach(player in GetPlayerArrayOfTeam(team))
        {
            float dist = Length2D(player.GetOrigin() - origin)
            if(dist < minDist || minDist < 0)
            {
                minDist = dist
                enemyOrigin = player.GetOrigin()
            }
        }
    }

    return enemyOrigin
}

void function TpPlayerToSpawnPoint(entity player)
{
	
	LocPair loc = SV_GetAppropriateSpawnLocation(player)

    player.SetOrigin(loc.origin)
    player.SetAngles(loc.angles)

    
    PutEntityInSafeSpot( player, null, null, player.GetOrigin() + <0,0,128>, player.GetOrigin() )
}

bool function GetTDMRoundInProgress()
{
    return expect bool(GetServerVar("TDMRoundInProgress"));
}
void function SetTDMRoundInProgress(bool val)
{
    SetServerVar("TDMRoundInProgress", val);
}
#endif


#if CLIENT

void function MakeScoreRUI()
{
    if ( file.scoreRui != null)
    {
        RuiSetString( file.scoreRui, "messageText", "Team IMC: 0  ||  Team MIL: 0" )
        return
    }
    clGlobal.levelEnt.EndSignal( "CloseScoreRUI" )

    UISize screenSize = GetScreenSize()
    var screenAlignmentTopo = RuiTopology_CreatePlane( <( screenSize.width * 0.25),( screenSize.height * 0.31 ), 0>, <float( screenSize.width ), 0, 0>, <0, float( screenSize.height ), 0>, false )
    var rui = RuiCreate( $"ui/announcement_quick_right.rpak", screenAlignmentTopo, RUI_DRAW_HUD, RUI_SORT_SCREENFADE + 1 )
    
    RuiSetGameTime( rui, "startTime", Time() )
    RuiSetString( rui, "messageText", "Team IMC: 0  ||  Team MIL: 0" )
    RuiSetString( rui, "messageSubText", "Text 2")
    RuiSetFloat( rui, "duration", 9999999 )
    RuiSetFloat3( rui, "eventColor", SrgbToLinear( <128, 188, 255> ) )
	
    file.scoreRui = rui
    
    OnThreadEnd(
		function() : ( rui )
		{
			RuiDestroy( rui )
			file.scoreRui = null
		}
	)
    
    WaitForever()
}

void function ServerCallback_TDM_DoAnnouncement(float duration, int type)
{
    string message = ""
    string subtext = ""
    switch(type)
    {
        case eTDMAnnounce.WAITING_FOR_PLAYERS: 
        {
            message = "Waiting For Players"
            subtext = GetPlayerArray().len().tostring() + "/" + MIN_NUMBER_OF_PLAYERS.tostring()
            break
        }
        case eTDMAnnounce.ROUND_START:
        {
            thread MakeScoreRUI();
            message = "Round start"
            break
        }
        case eTDMAnnounce.VOTING_PHASE:
        {
            clGlobal.levelEnt.Signal( "CloseScoreRUI" )
            message = "Voting phase"
            break
        }
        case eTDMAnnounce.MAP_FLYOVER:
        {
            
            if(file.locationSettings.len())
                message = file.selectedLocation.name
            break
        }
    }
	AnnouncementData announcement = Announcement_Create( message )
    Announcement_SetSubText(announcement, subtext)
	// Announcement_SetSoundAlias( announcement, CIRCLE_CLOSING_SOUND )
	Announcement_SetStyle( announcement, ANNOUNCEMENT_STYLE_CIRCLE_WARNING )
	Announcement_SetPurge( announcement, true )
	Announcement_SetOptionalTextArgsArray( announcement, [ "true" ] )
	Announcement_SetPriority( announcement, 200 ) //Be higher priority than Titanfall ready indicator etc
	announcement.duration = duration
	AnnouncementFromClass( GetLocalViewPlayer(), announcement )
}

void function ServerCallback_TDM_DoLocationIntroCutscene()
{
    thread ServerCallback_TDM_DoLocationIntroCutscene_Body()
}

void function ServerCallback_TDM_DoLocationIntroCutscene_Body()
{
    float playerFOV = GetLocalClientPlayer().GetFOV()
    
    entity camera = CreateClientSidePointCamera(file.selectedLocation.spawns[teams[0]][0].origin + file.selectedLocation.cinematicCameraOffset, <90, 90, 0>, 17)
    camera.SetFOV(90)
    
    entity cutsceneMover = CreateClientsideScriptMover($"mdl/dev/empty_model.rmdl", file.selectedLocation.spawns[teams[0]][0].origin + file.selectedLocation.cinematicCameraOffset, <90, 90, 0>)
    camera.SetParent(cutsceneMover)
    wait 1

	GetLocalClientPlayer().SetMenuCameraEntity( camera )


    for(int i = 0; i < teams.len(); i++)
    {
        entity spawn = CreateClientSidePropDynamic(OriginToGround(file.selectedLocation.spawns[teams[i]][0].origin), <0, 0, 0>, $"mdl/dev/empty_model.rmdl" )
        thread CreateTemporarySpawnRUI(spawn, LOCATION_CUTSCENE_DURATION + 2)
    }

    for(int i = 1; i < teams.len(); i++)
    {

        float duration = LOCATION_CUTSCENE_DURATION / max(1, teams.len() - 1)
        cutsceneMover.NonPhysicsMoveTo(file.selectedLocation.spawns[teams[i]][0].origin + file.selectedLocation.cinematicCameraOffset, duration, 1, 1)
        wait duration
    }

    wait 1
    cutsceneMover.NonPhysicsMoveTo(GetLocalClientPlayer().GetOrigin() + <0, 0, 100>, 2, 1, 1)
    cutsceneMover.NonPhysicsRotateTo(GetLocalClientPlayer().GetAngles(), 2, 1, 1)
	camera.SetTargetFOV(playerFOV, true, EASING_CUBIC_INOUT, 2 )

    wait 2
    GetLocalClientPlayer().ClearMenuCameraEntity()
    cutsceneMover.Destroy()
    
    camera.Destroy()
}

void function ServerCallback_TDM_SetSelectedLocation(int sel)
{
    file.selectedLocation = file.locationSettings[sel]
}

void function ServerCallback_TDM_PlayerKilled()
{
    if(file.scoreRui)
        RuiSetString( file.scoreRui, "messageText", "Team IMC: " + GameRules_GetTeamScore(TEAM_IMC) + "  ||  Team MIL: " + GameRules_GetTeamScore(TEAM_MILITIA) );
}

var function CreateTemporarySpawnRUI(entity parentEnt, float duration)
{
	var rui = AddOverheadIcon( parentEnt, RESPAWN_BEACON_ICON, false, $"ui/overhead_icon_respawn_beacon.rpak" )
	RuiSetFloat2( rui, "iconSize", <80,80,0> )
	RuiSetFloat( rui, "distanceFade", 50000 )
	RuiSetBool( rui, "adsFade", true )
	RuiSetString( rui, "hint", "SPAWN POINT" )

    wait duration

    parentEnt.Destroy()
}

#endif //
