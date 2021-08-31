// Credits
// sal#3261 -- main
// @Shrugtal -- score ui
// everyone else -- advice



global function Sh_CustomTDM_Init
global function NewLocationSettings
global function NewLocPair

global function Spectator_GetReplayIsEnabled
global function Spectator_GetReplayDelay
global function Deathmatch_GetRespawnDelay
global function Equipment_GetDefaultShieldHP
global function Deathmatch_GetOOBDamagePercent
global function Deathmatch_GetVotingTime
global function CMD_GetTGiveEnabled

global function Deathmatch_GetIntroCutsceneNumSpawns           
global function Deathmatch_GetIntroCutsceneSpawnDuration        
global function Deathmatch_GetIntroSpawnSpeed        


#if SERVER
global function Equipment_GetRespawnKitEnabled
global function Equipment_GetRespawnKit_PrimaryWeapon
global function Equipment_GetRespawnKit_SecondaryWeapon
global function Equipment_GetRespawnKit_Tactical
global function Equipment_GetRespawnKit_Ultimate
#endif


global const NO_CHOICES = 2
global const SCORE_GOAL_TO_WIN = 100

global enum eTDMAnnounce
{
	NONE = 0
	WAITING_FOR_PLAYERS = 1
	ROUND_START = 2
	VOTING_PHASE = 3
	MAP_FLYOVER = 4
	IN_PROGRESS = 5
}

global struct LocPair
{
    vector origin = <0, 0, 0>
    vector angles = <0, 0, 0>
}

global struct LocationSettings 
{
    string name
    array<LocPair> spawns
    vector cinematicCameraOffset
}

struct {
    LocationSettings &selectedLocation
    array choices
    array<LocationSettings> locationSettings
    var scoreRui

} file;




void function Sh_CustomTDM_Init() 
{


    // Map locations

    switch(GetMapName())
    {
    case "mp_rr_canyonlands_staging":
        Shared_RegisterLocation(
            NewLocationSettings(
                "Firing Range",
                [
                    NewLocPair(<33560, -8992, -29126>, <0, 90, 0>),
					NewLocPair(<34525, -7996, -28242>, <0, 100, 0>),
                    NewLocPair(<33507, -3754, -29165>, <0, -90, 0>),
					NewLocPair(<34986, -3442, -28263>, <0, -113, 0>)
                ],
                <0, 0, 3000>
            )
        )
        break

	case "mp_rr_canyonlands_mu1":
	case "mp_rr_canyonlands_mu1_night":
    case "mp_rr_canyonlands_64k_x_64k":
        Shared_RegisterLocation(
            NewLocationSettings(
                "Interstellar Relay",
                [
                    //North Relay Building
                    NewLocPair(<26420, 31700, 4790>, <0, -90, 0>),
                    
                    //West Relay Building
                        //North Spawn
                        NewLocPair(<29260, 26245, 4210>, <0, 45, 0>),
                        //South Spawn
                        NewLocPair(<29255, 24360, 4210>, <0, 0, 0>),
                    
                    //North West Cliff Building
                    NewLocPair(<24445, 28970, 4340>, <0, -90, 0>),
                    
                    //North East Cliff Building
                    NewLocPair(<27735, 27880, 4370>, <0, 180, 0>),
                    
                    //South East Cliff Building
                    NewLocPair(<25325, 25725, 4270>, <0, 0, 0>),
                    
                    //South West Cliff Building
                    NewLocPair(<27675, 25745, 4370>, <0, 0, 0>),
                    
                    //West Cliff Building
                    NewLocPair(<24375, 27050, 4325>, <0, 180, 0>),
                    
                    //North River Building
                    NewLocPair(<24000, 23650, 4050>, <0, 135, 0>),
                    
                    //South River Building
                    NewLocPair(<23935, 22080, 4200>, <0, 15, 0>)
                ],
                <0, 0, 3000>
            )
        )

        Shared_RegisterLocation(
            NewLocationSettings(
                "Slum Lakes",
                [                   
                    //East Huge Building
                        //Inside
                        NewLocPair(<-20060, 23800, 2655>, <0, 110, 0>),
                        //Balcony
                        NewLocPair(<-20245, 24475, 2810>, <0, -160, 0>),
                    
                    //West Huge Building
                        //Inside
                        NewLocPair(<-25650, 22025, 2270>, <0, 20, 0>),
                        //Rooftop
                        NewLocPair(<-25550, 21635, 2590>, <0, 20, 0>),
                        
                    //North West Tiny Building
                    NewLocPair(<-25030, 24670, 2410>, <0, -75, 0>),
                    
                    //North Big Building
                    NewLocPair(<-23125, 25320, 2410>, <0, -20, 0>),
                    
                    //South Long Building
                    NewLocPair(<-21925, 21120, 2390>, <0, 180, 0>)
                ],
                <0, 0, 3000>
            )
        )
        
        Shared_RegisterLocation(
            NewLocationSettings(
                "Skull Town",
                [
                    NewLocPair(<-9320, -13528, 3167>, <0, -100, 0>),
                    NewLocPair(<-7544, -13240, 3161>, <0, -115, 0>),
                    NewLocPair(<-10250, -18320, 3323>, <0, 100, 0>),
                    NewLocPair(<-13261, -18100, 3337>, <0, 20, 0>)
                ],
                <0, 0, 3000>
            )
        )
    
        Shared_RegisterLocation(
            NewLocationSettings(
                "Little Town",
                [
                    NewLocPair(<-30190, 12473, 3186>, <0, -90, 0>),
                    NewLocPair(<-28773, 11228, 3210>, <0, 180, 0>),
                    NewLocPair(<-29802, 9886, 3217>, <0, 90, 0>),
                    NewLocPair(<-30895, 10733, 3202>, <0, 0, 0>)
                ],
                <0, 0, 3000>
            )
        )
    
        Shared_RegisterLocation(
            NewLocationSettings(
                "Market",
                [
                    NewLocPair(<-110, -9977, 2987>, <0, 0, 0>),
                    NewLocPair(<-1605, -10300, 3053>, <0, -100, 0>),
                    NewLocPair(<4600, -11450, 2950>, <0, 180, 0>),
                    NewLocPair(<3150, -11153, 3053>, <0, 100, 0>)
                ],
                <0, 0, 3000>
            )
        )
    
        Shared_RegisterLocation(
            NewLocationSettings(
                "Runoff",
                [
                    NewLocPair(<-23380, 9634, 3371>, <0, 90, 0>),
                    NewLocPair(<-24917, 11273, 3085>, <0, 0, 0>),
                    NewLocPair(<-23614, 13605, 3347>, <0, -90, 0>),
                    NewLocPair(<-24697, 12631, 3085>, <0, 0, 0>)
                ],
                <0, 0, 3000>
            )
        )
    
        Shared_RegisterLocation(
            NewLocationSettings(
                "Thunderdome",
                [
                    NewLocPair(<-20216, -21612, 3191>, <0, -67, 0>),
                    NewLocPair(<-16035, -20591, 3232>, <0, -133, 0>),
                    NewLocPair(<-16584, -24859, 2642>, <0, 165, 0>),
                    NewLocPair(<-19019, -26209, 2640>, <0, 65, 0>)
                ],
                <0, 0, 2000>
            )
        )
        
        Shared_RegisterLocation(
            NewLocationSettings(
                "Water Treatment",
                [
                    NewLocPair(<5583, -30000, 3070>, <0, 0, 0>),
                    NewLocPair(<7544, -29035, 3061>, <0, 130, 0>),
                    NewLocPair(<10091, -30000, 3070>, <0, 180, 0>),
                    NewLocPair(<8487, -28838, 3061>, <0, -45, 0>)
                ],
                <0, 0, 3000>
            )
        )
            
    
        Shared_RegisterLocation(
            NewLocationSettings(
                "The Pit",
                [
                    NewLocPair(<-18558, 13823, 3605>, <0, 20, 0>),
                    NewLocPair(<-16514, 16184, 3772>, <0, -77, 0>),
                    NewLocPair(<-13826, 15325, 3749>, <0, 160, 0>),
                    NewLocPair(<-16160, 14273, 3770>, <0, 101, 0>)
                ],
                <0, 0, 7000>
            )
        )
    
        
        Shared_RegisterLocation(
            NewLocationSettings(
                "Airbase",
                [
                    NewLocPair(<-24140, -4510, 2583>, <0, 90, 0>),
                    NewLocPair(<-28675, 612, 2600>, <0, 18, 0>),
                    NewLocPair(<-24688, 1316, 2583>, <0, 180, 0>),
                    NewLocPair(<-26492, -5197, 2574>, <0, 50, 0>)
                ],
                <0, 0, 3000>
            )
        )

        break

        case "mp_rr_desertlands_64k_x_64k":
        case "mp_rr_desertlands_64k_x_64k_nx":
	        Shared_RegisterLocation(
                NewLocationSettings(
                    "Refinery",
                    [
                        NewLocPair(<22970, 27159, -4612.43>, <0, 135, 0>),
                        NewLocPair(<20430, 26361, -4140>, <0, 135, 0>),
                        NewLocPair(<19142, 30982, -4612>, <0, -45, 0>),
                        NewLocPair(<18285, 28502, -4140>, <0, -45, 0>),
                        NewLocPair(<19228, 25592, -4821>, <0, 135, 0>),
                        NewLocPair(<19495, 29283, -4821>, <0, -45, 0>),
                        NewLocPair(<18470, 28330, -4315>, <0, 135, 0>),
                        NewLocPair(<18431, 28405, -4139>, <0, 45, 0>),
                        NewLocPair(<18284, 28492, -3992>, <0, -45, 0>),
                        NewLocPair(<19428, 27190, -4140>, <0, -45, 0>),
                        NewLocPair(<20435, 26254, -4139>, <0, -175, 0>),
                        NewLocPair(<20222, 26549, -4316>, <0, 135, 0>),
                        NewLocPair(<19547, 25558, -4600>, <0, 45, 0>),
                        NewLocPair(<21751, 29980, -4226>, <0, -135, 0>),
                        NewLocPair(<17570, 26915, -4637>, <0, -90, 0>),
                        NewLocPair(<16382, 28296, -4588>, <0, -45, 0>),
                        NewLocPair(<16618, 28848, -4451>, <0, 40, 0>),
                    ],
                    <0, 0, 6500>
                )
            )
			
            // Shared_RegisterLocation(
            //     NewLocationSettings(
            //         "Geyser Cave",
            //         [
            //             NewLocPair(<26330, -3506, -3933>, <8, -177, 0>),
            //             NewLocPair(<24159, -4296, -3915>, <-2.5, 92, 0>),
            //             NewLocPair(<22322, -3326, -3920>, <0, 0, 0>),
            //             NewLocPair(<24199, -2370, -3914>, <0, -90, 0>)
            //         ],
            //         <0, 0, 250>
            //     )
            // )

            
            Shared_RegisterLocation(
                NewLocationSettings(
                    "Banana",
                    [
                        NewLocPair(<9213, -22942, -3571>, <0, -120, 0>),
                        NewLocPair(<7825, -24577, -3547>, <0, -165, 0>),
                        NewLocPair(<5846, -25513, -3523>, <0, 180, 0>),
                        NewLocPair(<4422, -25937, -3571>, <0, 90, 0>),
                        NewLocPair(<4056, -25017, -3571>, <0, -170, 0>),
                        NewLocPair(<1970, -25267, -3627>, <-5, 45, 0>),
                        NewLocPair(<2068, -25171, -3318>, <15, 45, 0>),
                        NewLocPair(<2197, -22687, -3572>, <-3, -90, 0>),
                        NewLocPair(<7081, -23051, -3667>, <0, 45, 0>),
                        NewLocPair(<8922, -22135, -3119>, <0, 180, 0>),
                        NewLocPair(<5436, -22436, -3188>, <0, 90, 0>),
                        NewLocPair(<4254, -23031, -3522>, <0, 45, 0>),
                        NewLocPair(<8211, -21413, -3667>, <0, -140, 0>),
                        NewLocPair(<4277, -24101, -3571>, <0, -60, 0>)
                    ],
                    <0, 0, 3000>
                )
            )


            Shared_RegisterLocation(
                NewLocationSettings(
                    "TTV Building",
                    [
                        NewLocPair(<11393, 5477, -4289>, <0, 90, 0>),
                        NewLocPair(<12027, 7121, -4290>, <0, -120, 0>),
                        NewLocPair(<8105, 6156, -4266>, <0, -45, 0>),
                        NewLocPair(<7965.0, 5976.0, -4266.0>, <0, -135, 0>),
                        NewLocPair(<9420, 5528, -4236>, <0, 90, 0>),
                        NewLocPair(<9862, 5561, -3832>, <0, 180, 0>),
                        NewLocPair(<9800, 5347, -3507>, <0, 134, 0>),
                        NewLocPair(<8277, 6304, -3940>, <0, 0, 0>),
                        NewLocPair(<8186, 5513, -3828>, <0, 0, 0>),
                        NewLocPair(<8243, 4537, -4235>, <-13, 32, 0>),
                        NewLocPair(<10176, 4245, -4239>, <0, 100, 0>),
                        NewLocPair(<11700, 6207, -4435>, <-10, 90, 0>),
                        NewLocPair(<11181, 5862, -3900>, <0, -180, 0>),
                        NewLocPair(<10410, 5211, -4243>, <0, -90, 0>),
                        NewLocPair(<9043, 5866, -4171>, <0, 90, 0>),
                        NewLocPair(<10107, 3843, -3951>, <0, 90, 0>),
                        NewLocPair(<11210, 4164, -4235>, <0, 90, 0>)
                    ],
                    <0, 0, 3000>
                )
            )

            Shared_RegisterLocation(
                NewLocationSettings(
                    "Thermal Station",
                    [
                        NewLocPair(<-20091, -17683, -3984>, <0, -90, 0>),
						NewLocPair(<-22919, -20528, -4010>, <0, 0, 0>),
						NewLocPair(<-17140, -20710, -3973>, <0, -180, 0>),
                        NewLocPair(<-21054, -23399, -3850>, <0, 90, 0>),
                        NewLocPair(<-20938, -23039, -4252>, <0,90, 0>),
                        NewLocPair(<-19361, -23083, -4252>, <0, 100, 0>),
                        NewLocPair(<-19264, -23395, -3850>, <0, 100, 0>),
                        NewLocPair(<-16756, -20711, -3982>, <0, 180, 0>),
                        NewLocPair(<-17066, -20746, -4233>, <0, 180, 0>),
                        NewLocPair(<-17113, -19622, -4269>, <10, -170, 0>),
                        NewLocPair(<-20092, -17684, -4252>, <0, -90, 0>),
                        NewLocPair(<-23120, -20694, -4216>, <-11, 146, 0>),
                        NewLocPair(<-20109, -20675, -4252>, <0, -90, 0>)
                    ],
                    <0, 0, 11000>
                )
            )
			
            Shared_RegisterLocation(
                NewLocationSettings(
                    "Lava Fissure",
                    [
                        NewLocPair(<-26550, 13746, -3048>, <0, -134, 0>),
						NewLocPair(<-28877, 12943, -3109>, <0, -88.70, 0>),
                        NewLocPair(<-29881, 9168, -2905>, <-1.87, -2.11, 0>),
						NewLocPair(<-27590, 9279, -3109>, <0, 90, 0>),
                        
                    ],
                    <0, 0, 2500>
                )
            )

            Shared_RegisterLocation(
                NewLocationSettings(
                    "Lava City",
                    [
                        NewLocPair(<22663, -28134, -2706>, <0, 40, 0>),
                        NewLocPair(<22844, -28222, -3030>, <0, 90, 0>),
                        NewLocPair(<22687, -27605, -3434>, <0, -90, 0>),
                        NewLocPair(<22610, -26999, -2949>, <0, 90, 0>),
                        NewLocPair(<22607, -26018, -2749>, <0, -90, 0>),
                        NewLocPair(<22975, -25792, -3437>, <0, -120, 0>),
                        NewLocPair(<24235, -27378, -3305>, <0, -100, 0>),
                        NewLocPair(<24345, -28872, -3433>, <0, -144, 0>),
                        NewLocPair(<24446, -28628, -3252>, <13, 0, 0>),
                        NewLocPair(<23931, -28043, -3265>, <0, 0, 0>),
                        NewLocPair(<27399, -28588, -3721>, <0, 130, 0>),
                        NewLocPair(<26610, -25784, -3300>, <0, -90, 0>),
                        NewLocPair(<26757, -26639, -3673>, <-10, 90, 0>),
                        NewLocPair(<26750, -26202, -3929>, <-10, -90, 0>)
                    ],
                    <0, 0, 3000>
                )
            )
			
            // Shared_RegisterLocation(
            //     NewLocationSettings(
            //         "The Dome",
            //         [
            //             NewLocPair(<17445.83, -36838.45, -2160.64>, <-2.20, -37.85, 0>),
			// 			NewLocPair(<17405.53, -39860.60, -2248>, <-6, -52, 0>),
            //             NewLocPair(<21700.48, -40169, -2164.30>, <2, 142, 0>),
			// 			NewLocPair(<20375.39, -36068.25, -2248>, <-1, -128, 0>)
            //         ],
            //         <0, 0, 2850>
            //     )
            // )

        
        default:
            Assert(false, "No TDM locations found for map!")
    }

    //Client Signals
    RegisterSignal( "CloseScoreRUI" )
    
}

LocPair function NewLocPair(vector origin, vector angles)
{
    LocPair locPair
    locPair.origin = origin
    locPair.angles = angles

    return locPair
}

LocationSettings function NewLocationSettings(string name, array<LocPair> spawns, vector cinematicCameraOffset)
{
    LocationSettings locationSettings
    locationSettings.name = name
    locationSettings.spawns = spawns
    locationSettings.cinematicCameraOffset = cinematicCameraOffset

    return locationSettings
}


void function Shared_RegisterLocation(LocationSettings locationSettings)
{
    #if SERVER
    _RegisterLocation(locationSettings)
    #endif


    #if CLIENT
    Cl_RegisterLocation(locationSettings)
    #endif


}


// Playlist GET

float function Deathmatch_GetIntroCutsceneNumSpawns()                { return GetCurrentPlaylistVarFloat("intro_cutscene_num_spawns", 5)}
float function Deathmatch_GetIntroCutsceneSpawnDuration()            { return GetCurrentPlaylistVarFloat("intro_cutscene_spawn_duration", 5)}
float function Deathmatch_GetIntroSpawnSpeed()                       { return GetCurrentPlaylistVarFloat("intro_cutscene_spawn_speed", 40)}
bool function Spectator_GetReplayIsEnabled()                         { return GetCurrentPlaylistVarBool("replay_enabled", false ) } 
float function Spectator_GetReplayDelay()                            { return GetCurrentPlaylistVarFloat("replay_delay", 5 ) } 
float function Deathmatch_GetRespawnDelay()                          { return GetCurrentPlaylistVarFloat("respawn_delay", 8) }
float function Equipment_GetDefaultShieldHP()                        { return GetCurrentPlaylistVarFloat("default_shield_hp", 100) }
float function Deathmatch_GetOOBDamagePercent()                      { return GetCurrentPlaylistVarFloat("oob_damage_percent", 25) }
float function Deathmatch_GetVotingTime()                            { return GetCurrentPlaylistVarFloat("voting_time", 5) }
bool function CMD_GetTGiveEnabled()                                  { return GetCurrentPlaylistVarBool("tgive_enabled", true) }
      
#if SERVER      
bool function Equipment_GetRespawnKitEnabled()                       { return GetCurrentPlaylistVarBool("respawn_kit_enabled", false) }

StoredWeapon function Equipment_GetRespawnKit_PrimaryWeapon()
{ 
    return Equipment_GetRespawnKit_Weapon(
        GetCurrentPlaylistVarString("respawn_kit_primary_weapon", "~~none~~"),
        eStoredWeaponType.main,
        WEAPON_INVENTORY_SLOT_PRIMARY_0
    ) 
}
StoredWeapon function Equipment_GetRespawnKit_SecondaryWeapon()
{ 
    return Equipment_GetRespawnKit_Weapon(
        GetCurrentPlaylistVarString("respawn_kit_secondary_weapon", "~~none~~"),
        eStoredWeaponType.main,
        WEAPON_INVENTORY_SLOT_PRIMARY_1
    )
}
StoredWeapon function Equipment_GetRespawnKit_Tactical()
{ 
    return Equipment_GetRespawnKit_Weapon(
        GetCurrentPlaylistVarString("respawn_kit_tactical", "~~none~~"),
        eStoredWeaponType.offhand,
        OFFHAND_TACTICAL
    )
}
StoredWeapon function Equipment_GetRespawnKit_Ultimate()
{ 
    return Equipment_GetRespawnKit_Weapon(
        GetCurrentPlaylistVarString("respawn_kit_ultimate", "~~none~~"),
        eStoredWeaponType.offhand,
        OFFHAND_ULTIMATE
    )
}

StoredWeapon function Equipment_GetRespawnKit_Weapon(string input, int type, int index)
{
    StoredWeapon weapon
    if(input == "~~none~~") return weapon

    array<string> args = split(input, " ")

    if(args.len() == 0) return weapon

    weapon.name = args[0]
    weapon.weaponType = type
    weapon.inventoryIndex = index
    weapon.mods = args.slice(1, args.len())

    return weapon
}
#endif