
// sal#3261 -- main
// @Shrugtal -- score ui
// everyone else -- advice



global function Sh_CustomTDM_Init
global function NewLocationSettings
global function NewLocPair
global function NewWeaponKit


global const TEAM_PREDS = 6

global const array< int > teams = [ TEAM_IMC, TEAM_MILITIA ]
global const MIN_NUMBER_OF_PLAYERS = 1
global const VOTING_TIME = 5
global const ROUND_TIME = 250
global const NO_CHOICES = 2
global const LOCATION_CUTSCENE_DURATION = 9
global const SCORE_GOAL_TO_WIN = 15

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

global struct LocationSettings {
    string name
    table< int, array<LocPair> > spawns
    vector cinematicCameraOffset
}

global struct WeaponKit
{
    string weapon
    array<string> mods
    int slot
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
	case "mp_rr_canyonlands_mu1":
	case "mp_rr_canyonlands_mu1_night":
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
        case "mp_rr_desertlands_64k_x_64k_nx":
	        Shared_RegisterLocation(
                NewLocationSettings(
                    "Refinery",
                    {
                        [TEAM_IMC] = [
                            NewLocPair(<22970, 27159, -4612.43>, <0, 135, 0>),
                            NewLocPair(<20430, 26361, -4140>, <0, 135, 0>)
                        ],
                        [TEAM_MILITIA] = [

                            NewLocPair(<19142, 30982, -4612>, <0, -45, 0>),
                            NewLocPair(<18285, 28502, -4140>, <0, -45, 0>)
                        ]
                    },
                    <0, 0, 6500>
                )
            )
			
            Shared_RegisterLocation(
                NewLocationSettings(
                    "Geyser Cave",
                    {
                        [TEAM_IMC] = [
                            NewLocPair(<26330, -3506, -3933>, <8, -177, 0>),
                            NewLocPair(<24159, -4296, -3915>, <-2.5, 92, 0>)
                        ],
                        [TEAM_MILITIA] = [
                            NewLocPair(<22322, -3326, -3920>, <0, 0, 0>),
                            NewLocPair(<24199, -2370, -3914>, <0, -90, 0>)
                        ]
                    },
                    <0, 0, 250>
                )
            )

            Shared_RegisterLocation(
                NewLocationSettings(
                    "TTV Building",
                    {
                        [TEAM_IMC] = [
                            NewLocPair(<11393, 5477, -4289>, <0, 90, 0>),
                            NewLocPair(<12027, 7121, -4290>, <0, -120, 0>)
                        ],
                        [TEAM_MILITIA] = [
                            NewLocPair(<8105, 6156, -4266>, <0, -45, 0>),
                            NewLocPair(<7965.0, 5976.0, -4266.0>, <0, -135, 0>)
                        ]
                    },
                    <0, 0, 3000>
                )
            )

            Shared_RegisterLocation(
                NewLocationSettings(
                    "Thermal Station",
                    {
                        [TEAM_IMC] = [
                            NewLocPair(<-20091, -17683, -3984>, <0, -90, 0>)
							NewLocPair(<-22919, -20528, -4010>, <0, 0, 0>)
                        ],
                        [TEAM_MILITIA] = [
                            NewLocPair(<-20109, -23193, -4252>, <0, 90, 0>)
							NewLocPair(<-17140, -20710, -3973>, <0, -180, 0>)
                        ]
                    },
                    <0, 0, 11000>
                )
            )
			
            Shared_RegisterLocation(
                NewLocationSettings(
                    "Lava Fissure",
                    {
                        [TEAM_IMC] = [
                            NewLocPair(<-26550, 13746, -3048>, <0, -134, 0>)
							NewLocPair(<-28877, 12943, -3109>, <0, -88.70, 0>)
                        ],
                        [TEAM_MILITIA] = [
                            NewLocPair(<-29881, 9168, -2905>, <-1.87, -2.11, 0>)
							NewLocPair(<-27590, 9279, -3109>, <0, 90, 0>)
                        ]
                    },
                    <0, 0, 2500>
                )
            )
			
            Shared_RegisterLocation(
                NewLocationSettings(
                    "The Dome",
                    {
                        [TEAM_IMC] = [
                            NewLocPair(<17445.83, -36838.45, -2160.64>, <-2.20, -37.85, 0>)
							NewLocPair(<17405.53, -39860.60, -2248>, <-6, -52, 0>)
                        ],
                        [TEAM_MILITIA] = [
                            NewLocPair(<21700.48, -40169, -2164.30>, <2, 142, 0>)
							NewLocPair(<20375.39, -36068.25, -2248>, <-1, -128, 0>)
                        ]
                    },
                    <0, 0, 2850>
                )
            )

        
        default:
            Assert(false, "No TDM locations found for map!")
    }

    //Client Signals
    RegisterSignal( "CloseScoreRUI" )
    
}

WeaponKit function NewWeaponKit(string weapon, array<string> mods, int slot)
{
    WeaponKit weaponKit
    weaponKit.weapon = weapon
    weaponKit.mods = mods
    weaponKit.slot = slot
    
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
    #if SERVER
    _RegisterLocation(locationSettings)
    #endif


    #if CLIENT
    Cl_RegisterLocation(locationSettings)
    #endif


}


