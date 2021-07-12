
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
                    "Train Yard",
                    {
                        [TEAM_IMC] = [
                            NewLocPair(<-15545, 3956, -2118>, <0, 0, 0>)
                        ],
                        [TEAM_MILITIA] = [
                            NewLocPair(<-10570, 4093, -2134>, <0, 180, 0>)
                        ]
                    },
                    <0, 0, 3000>
                )
            )

        default:
            Assert(false, "No TDM locations found for map!")
    }

    //Client Signals
    RegisterSignal( "CloseScoreRUI" )
    
    #if SERVER
    _CustomTDM_Init()
    #endif
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


