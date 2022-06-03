// Credits
// AyeZee#6969 -- ctf gamemode and ui
// sal#3261 -- base custom_tdm mode to work off
// Retículo Endoplasmático#5955 -- giving me the ctf sound names
// everyone else -- advice

global function Sh_CustomCTF_Init
global function NewCTFLocationSettings
global function NewCTFLocPair

global function CTF_GetRespawnDelay
global function CTF_Equipment_GetDefaultShieldHP
global function CTF_GetOOBDamagePercent
global function CTF_GetVotingTime

#if SERVER
global function CTF_Equipment_GetRespawnKitEnabled
global function CTF_Equipment_GetRespawnKit_PrimaryWeapon
global function CTF_Equipment_GetRespawnKit_SecondaryWeapon
global function CTF_Equipment_GetRespawnKit_Tactical
global function CTF_Equipment_GetRespawnKit_Ultimate
global function GetRandomPlayerSpawnOrigin
global function GetRandomPlayerSpawnAngles
global function GetFlagLocation
#endif

global int CTF_SCORE_GOAL_TO_WIN = 5
global int CTF_ROUNDTIME = 1500

//Custom Messages IDS
global int PickedUpFlag = 0
global int EnemyPickedUpFlag = 1
global int TeamReturnedFlag = 2

//PointHint IDS
global int CTF_Defend = 0
global int CTF_Capture = 1
global int CTF_Attack = 2
global int CTF_Escort = 3
global int CTF_Return = 4

global enum eCTFAnnounce
{
	NONE = 0
	WAITING_FOR_PLAYERS = 1
	ROUND_START = 2
	VOTING_PHASE = 3
	MAP_FLYOVER = 4
	IN_PROGRESS = 5
}

global struct LocPairCTF
{
    vector origin = <0, 0, 0>
    vector angles = <0, 0, 0>
}

global struct LocationSettingsCTF
{
    string name
    array<LocPairCTF> spawns
    vector cinematicCameraOffset
}

struct {
    LocationSettingsCTF &selectedLocation
    array choices
    array<LocationSettingsCTF> locationSettings
    var scoreRui

} file;

void function Sh_CustomCTF_Init() 
{
    // Map locations
    //This is only used for the boundary bubble
    switch(GetMapName())
    {
    case "mp_rr_canyonlands_staging":
        Shared_RegisterLocationCTF(
            NewCTFLocationSettings(
                "Firing Range",
                [
                    NewCTFLocPair(<33560, -8992, -29126>, <0, 90, 0>),
					NewCTFLocPair(<34525, -7996, -28242>, <0, 100, 0>),
                    NewCTFLocPair(<33507, -3754, -29165>, <0, -90, 0>),
					NewCTFLocPair(<34986, -3442, -28263>, <0, -113, 0>),
                    NewCTFLocPair(<30567, -6373, -29041>, <0, -113, 0>)
                ],
                <0, 0, 3000>
            )
        )
        break
		
    case "mp_rr_ashs_redemption":
        Shared_RegisterLocationCTF(
            NewCTFLocationSettings(
                "Ash's Redemption",
                [
                    NewCTFLocPair(<-22104, 6009, -26929>, <0, 0, 0>),
					NewCTFLocPair(<-21372, 3709, -26955>, <-5, 55, 0>),
                    NewCTFLocPair(<-19356, 6397, -26861>, <-4, -166, 0>),
					NewCTFLocPair(<-20713, 7409, -26742>, <-4, -114, 0>)
                ],
                <0, 0, 1000>
            )
        )
        break

	case "mp_rr_canyonlands_mu1":
	case "mp_rr_canyonlands_mu1_night":
    case "mp_rr_canyonlands_64k_x_64k":
        Shared_RegisterLocationCTF(
            NewCTFLocationSettings(
                "Artillery",
                [
                    NewCTFLocPair(<9614, 30792, 4868>, <0, 90, 0>),
                    NewCTFLocPair(<6379, 30792, 4868>, <0, 18, 0>),
                    NewCTFLocPair(<3603, 30792, 4868>, <0, 180, 0>),
                    NewCTFLocPair(<6379, 29172, 4868>, <0, 50, 0>)
                ],
                <0, 0, 3000>
            )
        )

        Shared_RegisterLocationCTF(
            NewCTFLocationSettings(
                "Airbase",
                [
                    NewCTFLocPair(<-25775, 1599, 2583>, <0, 90, 0>),
                    NewCTFLocPair(<-24845,-5112,2571>, <0, 18, 0>),
                    NewCTFLocPair(<-28370, -2238, 2550>, <0, 180, 0>)
                ],
                <0, 0, 3000>
            )
        )

        Shared_RegisterLocationCTF(
            NewCTFLocationSettings(
                "Relay",
                [
                    NewCTFLocPair(<29625, 25371, 4216>, <0, 90, 0>),
                    NewCTFLocPair(<22958, 22128, 3914>, <0, 18, 0>),
                    NewCTFLocPair(<26825, 30767, 4790>, <0, 180, 0>)
                ],
                <0, 0, 3000>
            )
        )

        Shared_RegisterLocationCTF(
            NewCTFLocationSettings(
                "WetLands",
                [
                    NewCTFLocPair(<29585, 16597, 4641>, <0, 90, 0>),
                    NewCTFLocPair(<19983, 14582, 4670>, <0, 18, 0>),
                    NewCTFLocPair(<25244, 16658, 3871>, <0, 180, 0>)
                ],
                <0, 0, 3000>
            )
        )

        Shared_RegisterLocationCTF(
            NewCTFLocationSettings(
                "Repulsor",
                [
                    NewCTFLocPair(<20269, -14999, 4824>, <0, 90, 0>),
                    NewCTFLocPair(<29000, -15195, 4726>, <0, 18, 0>),
                    NewCTFLocPair(<24417, -15196, 5203>, <0, 180, 0>)
                ],
                <0, 0, 3000>
            )
        )

        Shared_RegisterLocationCTF(
            NewCTFLocationSettings(
                "Skull Town",
                [
                    NewCTFLocPair(<-12391, -19413, 3166>, <0, 90, 0>),
                    NewCTFLocPair(<-6706, -13383, 3174>, <0, 18, 0>),
                    NewCTFLocPair(<-9746, -16127, 4062>, <0, 180, 0>)
                ],
                <0, 0, 3000>
            )
        )

        break

        case "mp_rr_desertlands_64k_x_64k":
        case "mp_rr_desertlands_64k_x_64k_nx":
            Shared_RegisterLocationCTF(
                NewCTFLocationSettings(
                    "Overlook",
                    [
                        NewCTFLocPair(<26893, 13646, -3199>, <0, 40, 0>),
                        NewCTFLocPair(<30989, 8510, -3329>, <0, 90, 0>),
                        NewCTFLocPair(<32922, 9423, -3329>, <0, 90, 0>)
                    ],
                    <0, 0, 3000>
                )
            )

            Shared_RegisterLocationCTF(
                NewCTFLocationSettings(
                    "Refinery",
                    [
                        NewCTFLocPair(<22630, 21512, -4516>, <0, 40, 0>),
                        NewCTFLocPair(<19147, 30973, -4602>, <0, 90, 0>)
                    ],
                    <0, 0, 3000>
                )
            )

            Shared_RegisterLocationCTF(
                NewCTFLocationSettings(
                    "Capitol City",
                    [
                        NewCTFLocPair(<1750, 5158, -3334>, <0, 40, 0>),
                        NewCTFLocPair(<11690, 6300, -4065>, <0, 90, 0>)
                    ],
                    <0, 0, 3000>
                )
            )

            Shared_RegisterLocationCTF(
                NewCTFLocationSettings(
                    "Sorting Factory",
                    [
                        NewCTFLocPair(<1874, -25365, -3385>, <0, 40, 0>),
                        NewCTFLocPair(<10684, -18468, -3584>, <0, 90, 0>)
                    ],
                    <0, 0, 3000>
                )
            )

        
        default:
            Assert(false, "No TDM locations found for map!")
    }

    //Client Signals
    RegisterSignal( "CloseScoreRUI" )
    
}

LocPairCTF function NewCTFLocPair(vector origin, vector angles)
{
    LocPairCTF locPair
    locPair.origin = origin
    locPair.angles = angles

    return locPair
}

LocationSettingsCTF function NewCTFLocationSettings(string name, array<LocPairCTF> spawns, vector cinematicCameraOffset)
{
    LocationSettingsCTF locationSettings
    locationSettings.name = name
    locationSettings.spawns = spawns
    locationSettings.cinematicCameraOffset = cinematicCameraOffset

    file.locationSettings.append(locationSettings)

    return locationSettings
}


void function Shared_RegisterLocationCTF(LocationSettingsCTF locationSettings)
{
    #if SERVER
    _CTFRegisterLocation(locationSettings)
    #endif

    #if CLIENT
    Cl_CTFRegisterLocation(locationSettings)
    #endif
}

#if SERVER

//Flag Spawn Locations
vector function GetFlagLocation(LocationSettingsCTF locationSettings, int team)
{
    vector spawnorg
    switch(locationSettings.name)
    {
        case "Firing Range":
            if (team == TEAM_IMC)
                spawnorg = <33076,-8916,-29125>
            if (team == TEAM_MILITIA)
                spawnorg = <32856,-3596,-29165>
            break
        case "Artillery":
            if (team == TEAM_IMC)
                spawnorg = <9400,30767,5028>
            if (team == TEAM_MILITIA)
                spawnorg = <3690,30767,5028>
            break
        case "Airbase":
            if (team == TEAM_IMC)
                spawnorg = <-25775, 1599, 2583>
            if (team == TEAM_MILITIA)
                spawnorg = <-24845,-5112,2571>
            break
        case "Relay":
            if (team == TEAM_IMC)
                spawnorg = <23258, 22476, 3914>
            if (team == TEAM_MILITIA)
                spawnorg = <30139,25359,4216>
            break
        case "WetLands":
            if (team == TEAM_IMC)
                spawnorg = <28495, 16316, 4206>
            if (team == TEAM_MILITIA)
                spawnorg = <19843, 14597, 4670>
            break
        case "Repulsor":
            if (team == TEAM_IMC)
                spawnorg = <21422, -14999, 4824>
            if (team == TEAM_MILITIA)
                spawnorg = <27967, -15195, 4726>
            break
        case "Skull Town":
            if (team == TEAM_IMC)
                spawnorg = <-12391, -19413, 3166>
            if (team == TEAM_MILITIA)
                spawnorg = <-6706, -13383, 3174>
            break
        case "Overlook":
            if (team == TEAM_IMC)
                spawnorg = <26893, 13646, -3199>
            if (team == TEAM_MILITIA)
                spawnorg = <30989, 8510, -3329>
            break
        case "Refinery":
            if (team == TEAM_IMC)
                spawnorg = <22630, 22243, -4516>
            if (team == TEAM_MILITIA)
                spawnorg = <19147, 30973, -4602>
            break
        case "Capitol City":
            if (team == TEAM_IMC)
                spawnorg = <1750, 5158, -3334>
            if (team == TEAM_MILITIA)
                spawnorg = <11690, 6300, -4065>
            break
        case "Sorting Factory":
            if (team == TEAM_IMC)
                spawnorg = <1874, -25365, -3385>
            if (team == TEAM_MILITIA)
                spawnorg = <10684, -18468, -3584>
            break
        
    }
    return spawnorg
}

//Player Spawn Origin
array<vector> function GetRandomPlayerSpawnOrigin(LocationSettingsCTF locationSettings, entity player)
{
    array<vector> spawnorg
    if (locationSettings.name == "Firing Range")
    {
        switch(player.GetTeam())
        {
            case TEAM_IMC:
                spawnorg.append(<34498, -8254, -28845>) //Ang: 0 130 0
                spawnorg.append(<31926, -8875, -29125>) //Ang: 0 105 0
                spawnorg.append(<34529, -9354, -28972>) //Ang: 0 145 0
                spawnorg.append(<32302, -9478, -29145>) //Ang: 0 60 0
            break
            case TEAM_MILITIA:
                spawnorg.append(<32240, -2723, -28903>) //Ang: 0 -50 0
                spawnorg.append(<34943, -3502, -28254>) //Ang: 0 -113 0
                spawnorg.append(<30857, -3860, -28729>) //Ang: 0 -30 0
                spawnorg.append(<31836, -4098, -29081>) //Ang: 0 -50 0
            break
        }
    }
    else if (locationSettings.name == "Artillery")
    {
        switch(player.GetTeam())
        {
            case TEAM_IMC:
                spawnorg.append(<10250, 30984, 4828>) //Ang: 0 -170 0
                spawnorg.append(<10237, 30573, 4828>) //Ang: 0 170 0
                spawnorg.append(<9127, 30626, 4832>) //Ang: 0 170 0
                spawnorg.append(<8997, 30943, 4828>) //Ang: 0 -170 0
            break
            case TEAM_MILITIA:
                spawnorg.append(<4402, 30619, 4828>) //Ang: 0 8 0
                spawnorg.append(<4148, 30573, 4828>) //Ang: 0 -8 0
                spawnorg.append(<3415, 30626, 4832>) //Ang: 0 -8 0
                spawnorg.append(<3263, 30943, 4828>) //Ang: 0 8 0
            break
        }
    }
    else if (locationSettings.name == "Airbase")
    {
        switch(player.GetTeam())
        {
            case TEAM_IMC:
                spawnorg.append(<-26435, 2024, 2568>) //Ang: 0 -70 0
                spawnorg.append(<-26870, 650, 2599>) //Ang: 0 -30 0
                spawnorg.append(<-24342, 51, 2568>) //Ang: 0 -125 0
                spawnorg.append(<-27234, -254, 2568>) //Ang: 0 -20 0
            break
            case TEAM_MILITIA:
                spawnorg.append(<-25699, -5971, 2580>) //Ang: 0 19 0
                spawnorg.append(<-23893, -4242, 2568>) //Ang: 0 90 0
                spawnorg.append(<-26251, -4939, 2573>) //Ang: 0 44 0
                spawnorg.append(<-27554, -4611, 2536>) //Ang: 0 45 0
            break
        }
    }
    else if (locationSettings.name == "Relay")
    {
        switch(player.GetTeam())
        {
            case TEAM_IMC:
                spawnorg.append(<24272, 21828, 3914>) //Ang: 0 40 0
                spawnorg.append(<23815, 23703, 4058>) //Ang: 0 35 0
                spawnorg.append(<22419, 23489, 4251>) //Ang: 0 0 0
                spawnorg.append(<21577, 22943, 4256>) //Ang: 0 -15 0
            break
            case TEAM_MILITIA:
                spawnorg.append(<30000, 26381, 4216>) //Ang: 0 -135 0
                spawnorg.append(<29036, 24253, 4216>) //Ang: 0 90 0
                spawnorg.append(<27698, 28291, 4102>) //Ang: 0 -160 0
                spawnorg.append(<27628, 25640, 4370>) //Ang: 0 160 0
            break
        }
    }
    else if (locationSettings.name == "WetLands")
    {
        switch(player.GetTeam())
        {
            case TEAM_IMC:
                spawnorg.append(<27589, 17568, 4206>) //Ang: 0 -160 0
                spawnorg.append(<27560, 15678, 4350>) //Ang: 0 180 0
                spawnorg.append(<29963, 17119, 4366>) //Ang: 0 165 0
                spawnorg.append(<29234, 15319, 4206>) //Ang: 0 135 0
            break
            case TEAM_MILITIA:
                spawnorg.append(<20337, 13229, 4670>) //Ang: 0 50 0
                spawnorg.append(<20230, 16421, 4670>) //Ang: 0 0 0
                spawnorg.append(<21194, 16925, 4518>) //Ang: 0 -60 0
                spawnorg.append(<22281, 13742, 4422>) //Ang: 0 40 0
            break
        }
    }
    else if (locationSettings.name == "Repulsor")
    {
        switch(player.GetTeam())
        {
            case TEAM_IMC:
                spawnorg.append(<21925, -12916, 4726>) //Ang: 0 -50 0
                spawnorg.append(<21925, -16826, 4726>) //Ang: 0 50 0
                spawnorg.append(<22251, -15589, 4598>) //Ang: 0 35 0
                spawnorg.append(<22251, -14171, 4598>) //Ang: 0 -35 0
            break
            case TEAM_MILITIA:
                spawnorg.append(<28347, -13383, 4726>) //Ang: 0 180 0
                spawnorg.append(<28347, -17113, 4726>) //Ang: 0 180 0
                spawnorg.append(<26507, -15813, 4730>) //Ang: 0 -135 0
                spawnorg.append(<26507, -14500, 4730>) //Ang: 0 135 0
            break
        }
    }
    else if (locationSettings.name == "Skull Town")
    {
        switch(player.GetTeam())
        {
            case TEAM_IMC:
                spawnorg.append(<-11246, -19126, 3285>) //Ang: 0 70 0
                spawnorg.append(<-12575, -18156, 3170>) //Ang: 0 0 0
                spawnorg.append(<-12125, -17650, 3186>) //Ang: 0 45 0
                spawnorg.append(<-11241, -18068, 3187>) //Ang: 0 45 0
            break
            case TEAM_MILITIA:
                spawnorg.append(<-6509, -14479, 3166>) //Ang: 0 -135 0
                spawnorg.append(<-7242, -13374, 3166>) //Ang: 0 170 0
                spawnorg.append(<-7573, -13783, 3186>) //Ang: 0 -100 0
                spawnorg.append(<-7472, -14763, 3183>) //Ang: 0 -150 0
            break
        }
    }
    else if (locationSettings.name == "Overlook")
    {
        switch(player.GetTeam())
        {
            case TEAM_IMC:
                spawnorg.append(<25997, 13028, -3139>) //Ang: 0 -30 0
                spawnorg.append(<28416, 13515, -3230>) //Ang: 0 -88 0
                spawnorg.append(<26215, 14402, -3081>) //Ang: 0 -65 0
                spawnorg.append(<27408, 14510, -3141>) //Ang: 0 -65 0
            break
            case TEAM_MILITIA:
                spawnorg.append(<31780, 8514, -3329>) //Ang: 0 137 0
                spawnorg.append(<30207, 7910, -3313>) //Ang: 0 101 0
                spawnorg.append(<31254, 9956, -3393>) //Ang: 0 90 0
                spawnorg.append(<32519, 9890, -3525>) //Ang: 0 166 0
            break
        }
    }
    else if (locationSettings.name == "Refinery")
    {
        switch(player.GetTeam())
        {
            case TEAM_IMC:
                spawnorg.append(<21618, 22558, -4499>) //Ang: 0 110 0
                spawnorg.append(<20873, 23929, -4557>) //Ang: 0 140 0
                spawnorg.append(<22247, 22785, -4523>) //Ang: 0 67 0
                spawnorg.append(<23384, 21955, -4523>) //Ang: 0 108 0
            break
            case TEAM_MILITIA:
                spawnorg.append(<18034, 30657, -4578>) //Ang: 0 -42 0
                spawnorg.append(<19757, 31462, -4340>) //Ang: 0 -63 0
                spawnorg.append(<18320, 29370, -4778>) //Ang: 0 -101 0
                spawnorg.append(<16344, 29093, -4441>) //Ang: 0 -13 0
            break
        }
    }
    else if (locationSettings.name == "Capitol City")
    {
        switch(player.GetTeam())
        {
            case TEAM_IMC:
                spawnorg.append(<2102, 5999, -4225>) //Ang: 0 0 0
                spawnorg.append(<1761, 5356, -3953>) //Ang: 0 -29 0
                spawnorg.append(<1392, 4444, -3006>) //Ang: 0 40 0
                spawnorg.append(<2979, 4051, -4225>) //Ang: 0 50 0
            break
            case TEAM_MILITIA:
                spawnorg.append(<12050, 7446, -4281>) //Ang: 0 170 0
                spawnorg.append(<12122, 5159, -4225>) //Ang: 0 -170 0
                spawnorg.append(<10679, 4107, -4225>) //Ang: 0 120 0
                spawnorg.append(<12185, 6412, -4281>) //Ang: 0 -130 0
            break
        }
    }
    else if (locationSettings.name == "Sorting Factory")
    {
        switch(player.GetTeam())
        {
            case TEAM_IMC:
                spawnorg.append(<1747, -22990, -3561>) //Ang: 0 31 0
                spawnorg.append(<3904, -25013, -3561>) //Ang: 0 0 0
                spawnorg.append(<2110, -25117, -3037>) //Ang: 0 50 0
                spawnorg.append(<2242, -21858, -3657>) //Ang: 0 -25 0
            break
            case TEAM_MILITIA:
                spawnorg.append(<9020, -18238, -3563>) //Ang: 0 -118 0
                spawnorg.append(<10076, -19642, -2889>) //Ang: 0 -148 0
                spawnorg.append(<7793, -17583, -3657>) //Ang: 0 -80 0
                spawnorg.append(<9377, -20718, -3569>) //Ang: 0 -179 0
            break
        }
    }
    return spawnorg
}

//Player Spawn Angles
array<vector> function GetRandomPlayerSpawnAngles(LocationSettingsCTF locationSettings, entity player)
{
    array<vector> spawnang
    if (locationSettings.name == "Firing Range")
    {
        switch(player.GetTeam())
        {
            case TEAM_IMC:
                spawnang.append(<0, 130, 0>) //Ang: 0 130 0
                spawnang.append(<0, 105, 0>) //Ang: 0 105 0
                spawnang.append(<0, 145, 0>) //Ang: 0 145 0
                spawnang.append(<0, 60, 0>) //Ang: 0 60 0
            break
            case TEAM_MILITIA:
                spawnang.append(<0, -50, 0>) //Ang: 0 -50 0
                spawnang.append(<0, -113, 0>) //Ang: 0 -113 0
                spawnang.append(<0, -30, 0>) //Ang: 0 -30 0
                spawnang.append(<0, -50, 0>) //Ang: 0 -50 0
            break
        }
    }
    else if (locationSettings.name == "Artillery")
    {
        switch(player.GetTeam())
        {
            case TEAM_IMC:
                spawnang.append(<0, -170, 0>) //Ang: 0 -170 0
                spawnang.append(<0, 170, 0>) //Ang: 0 170 0
                spawnang.append(<0, 170, 0>) //Ang: 0 170 0
                spawnang.append(<0, -170, 0>) //Ang: 0 -170 0
            break
            case TEAM_MILITIA:
                spawnang.append(<0, 8, 0>) //Ang: 0 8 0
                spawnang.append(<0, -8, 0>) //Ang: 0 -8 0
                spawnang.append(<0, -8, 0>) //Ang: 0 -8 0
                spawnang.append(<0, 8, 0>) //Ang: 0 8 0
            break
        }
    }
    else if (locationSettings.name == "Airbase")
    {
        switch(player.GetTeam())
        {
            case TEAM_IMC:
                spawnang.append(<0, -70, 0>) //Ang: 0 -70 0
                spawnang.append(<0, -30, 0>) //Ang: 0 -30 0
                spawnang.append(<0, -125, 0>) //Ang: 0 -125 0
                spawnang.append(<0, -20, 0>) //Ang: 0 -20 0
            break
            case TEAM_MILITIA:
                spawnang.append(<0, 19, 0>) //Ang: 0 19 0
                spawnang.append(<0, 90, 0>) //Ang: 0 90 0
                spawnang.append(<0, 44, 0>) //Ang: 0 44 0
                spawnang.append(<0, 45, 0>) //Ang: 0 45 0
            break
        }
    }
    else if (locationSettings.name == "Relay")
    {
        switch(player.GetTeam())
        {
            case TEAM_IMC:
                spawnang.append(<0, 40, 0>) //Ang: 0 40 0
                spawnang.append(<0, 35, 0>) //Ang: 0 35 0
                spawnang.append(<0, 180, 0>) //Ang: 0 180 0
                spawnang.append(<0, -15, 0>) //Ang: 0 -15 0
            break
            case TEAM_MILITIA:
                spawnang.append(<0, -135, 0>) //Ang: 0 -135 0
                spawnang.append(<0, 90, 0>) //Ang: 0 90 0
                spawnang.append(<0, -160, 0>) //Ang: 0 -160 0
                spawnang.append(<0, 160, 0>) //Ang: 0 160 0
            break
        }
    }
    else if (locationSettings.name == "WetLands")
    {
        switch(player.GetTeam())
        {
            case TEAM_IMC:
                spawnang.append(<0, -160, 0>) //Ang: 0 -160 0
                spawnang.append(<0, 0, 0>) //Ang: 0 0 0
                spawnang.append(<0, 165, 0>) //Ang: 0 165 0
                spawnang.append(<0, 135, 0>) //Ang: 0 135 0
            break
            case TEAM_MILITIA:
                spawnang.append(<0, 50, 0>) //Ang: 0 50 0
                spawnang.append(<0, 0, 0>) //Ang: 0 0 0
                spawnang.append(<0, -60, 0>) //Ang: 0 -60 0
                spawnang.append(<0, 40, 0>) //Ang: 0 40 0
            break
        }
    }
    else if (locationSettings.name == "Repulsor")
    {
        switch(player.GetTeam())
        {
            case TEAM_IMC:
                spawnang.append(<0, -50, 0>) //Ang: 0 -50 0
                spawnang.append(<0, 50, 0>) //Ang: 0 50 0
                spawnang.append(<0, 35, 0>) //Ang: 0 35 0
                spawnang.append(<0, -35, 0>) //Ang: 0 -35 0
            break
            case TEAM_MILITIA:
                spawnang.append(<0, 180, 0>) //Ang: 0 180 0
                spawnang.append(<0, 180, 0>) //Ang: 0 180 0
                spawnang.append(<0, -135, 0>) //Ang: 0 -135 0
                spawnang.append(<0, 135, 0>) //Ang: 0 135 0
            break
        }
    }
    else if (locationSettings.name == "Skull Town")
    {
        switch(player.GetTeam())
        {
            case TEAM_IMC:
                spawnang.append(<0, 70, 0>) //Ang: 0 70 0
                spawnang.append(<0, 0, 0>) //Ang: 0 0 0
                spawnang.append(<0, 45, 0>) //Ang: 0 45 0
                spawnang.append(<0, 45, 0>) //Ang: 0 45 0
            break
            case TEAM_MILITIA:
                spawnang.append(<0, -135, 0>) //Ang: 0 -135 0
                spawnang.append(<0, 170, 0>) //Ang: 0 170 0
                spawnang.append(<0, -100, 0>) //Ang: 0 -100 0
                spawnang.append(<0, -150, 0>) //Ang: 0 -150 0
            break
        }
    }
    else if (locationSettings.name == "Overlook")
    {
        switch(player.GetTeam())
        {
            case TEAM_IMC:
                spawnang.append(<0, -30, 0>) //Ang: 0 -30 0
                spawnang.append(<0, -88, 0>) //Ang: 0 -88 0
                spawnang.append(<0, -65, 0>) //Ang: 0 -65 0
                spawnang.append(<0, -65, 0>) //Ang: 0 -65 0
            break
            case TEAM_MILITIA:
                spawnang.append(<0, 137, 0>) //Ang: 0 137 0
                spawnang.append(<0, 101, 0>) //Ang: 0 101 0
                spawnang.append(<0, 90, 0>) //Ang: 0 90 0
                spawnang.append(<0, 166, 0>) //Ang: 0 166 0
            break
        }
    }
    else if (locationSettings.name == "Refinery")
    {
        switch(player.GetTeam())
        {
            case TEAM_IMC:
                spawnang.append(<0, 110, 0>) //Ang: 0 110 0
                spawnang.append(<0, 140, 0>) //Ang: 0 140 0
                spawnang.append(<0, 67, 0>) //Ang: 0 67 0
                spawnang.append(<0, 108, 0>) //Ang: 0 108 0
            break
            case TEAM_MILITIA:
                spawnang.append(<0, -42, 0>) //Ang: 0 -42 0
                spawnang.append(<0, -63, 0>) //Ang: 0 -63 0
                spawnang.append(<0, -101, 0>) //Ang: 0 -101 0
                spawnang.append(<0, -13, 0>) //Ang: 0 -13 0
            break
        }
    }
    else if (locationSettings.name == "Capitol City")
    {
        switch(player.GetTeam())
        {
            case TEAM_IMC:
                spawnang.append(<0, 0, 0>) //Ang: 0 0 0
                spawnang.append(<0, -29, 0>) //Ang: 0 -29 0
                spawnang.append(<0, 40, 0>) //Ang: 0 40 0
                spawnang.append(<0, 50, 0>) //Ang: 0 50 0
            break
            case TEAM_MILITIA:
                spawnang.append(<0, 170, 0>) //Ang: 0 170 0
                spawnang.append(<0, -170, 0>) //Ang: 0 -170 0
                spawnang.append(<0, 120, 0>) //Ang: 0 120 0
                spawnang.append(<0, -130, 0>) //Ang: 0 -130 0
            break
        }
    }
    else if (locationSettings.name == "Sorting Factory")
    {
        switch(player.GetTeam())
        {
            case TEAM_IMC:
                spawnang.append(<0, 31, 0>) //Ang: 0 31 0
                spawnang.append(<0, 0, 0>) //Ang: 0 0 0
                spawnang.append(<0, 50, 0>) //Ang: 0 50 0
                spawnang.append(<0, -25, 0>) //Ang: 0 -25 0
            break
            case TEAM_MILITIA:
                spawnang.append(<0, -118, 0>) //Ang: 0 -118 0
                spawnang.append(<0, -148, 0>) //Ang: 0 -148 0
                spawnang.append(<0, -80, 0>) //Ang: 0 -80 0
                spawnang.append(<0, -179, 0>) //Ang: 0 -179 0
            break
        }
    }

    return spawnang
}


#endif


// Playlist GET
float function CTF_GetRespawnDelay()                          { return GetCurrentPlaylistVarFloat("respawn_delay", 8) }
float function CTF_Equipment_GetDefaultShieldHP()                        { return GetCurrentPlaylistVarFloat("default_shield_hp", 100) }
float function CTF_GetOOBDamagePercent()                      { return GetCurrentPlaylistVarFloat("oob_damage_percent", 25) }
float function CTF_GetVotingTime()                            { return GetCurrentPlaylistVarFloat("voting_time", 5) }
      
#if SERVER      
bool function CTF_Equipment_GetRespawnKitEnabled()                       { return GetCurrentPlaylistVarBool("respawn_kit_enabled", false) }

StoredWeapon function CTF_Equipment_GetRespawnKit_PrimaryWeapon()
{ 
    return Equipment_GetRespawnKit_Weapon(
        GetCurrentPlaylistVarString("respawn_kit_primary_weapon", "~~none~~"),
        eStoredWeaponType.main,
        WEAPON_INVENTORY_SLOT_PRIMARY_0
    ) 
}
StoredWeapon function CTF_Equipment_GetRespawnKit_SecondaryWeapon()
{ 
    return Equipment_GetRespawnKit_Weapon(
        GetCurrentPlaylistVarString("respawn_kit_secondary_weapon", "~~none~~"),
        eStoredWeaponType.main,
        WEAPON_INVENTORY_SLOT_PRIMARY_1
    )
}
StoredWeapon function CTF_Equipment_GetRespawnKit_Tactical()
{ 
    return Equipment_GetRespawnKit_Weapon(
        GetCurrentPlaylistVarString("respawn_kit_tactical", "~~none~~"),
        eStoredWeaponType.offhand,
        OFFHAND_TACTICAL
    )
}
StoredWeapon function CTF_Equipment_GetRespawnKit_Ultimate()
{ 
    return Equipment_GetRespawnKit_Weapon(
        GetCurrentPlaylistVarString("respawn_kit_ultimate", "~~none~~"),
        eStoredWeaponType.offhand,
        OFFHAND_ULTIMATE
    )
}

#endif