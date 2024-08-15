// Credits
// AyeZee#6969 -- ctf gamemode and ui
// CafeFPS -- Server/client/ui Rework and multiple code fixes
// sal#3261 -- base custom_tdm mode to work off
// everyone else -- advice

global function Sh_CustomCTF_Init
global function NewCTFLocationSettings
global function NewCTFLocPair

global function CTF_Equipment_GetDefaultShieldHP
global function CTF_GetOOBDamagePercent
global function FSIntro_GetVictorySquadFormationPosition

global int CTF_SCORE_GOAL_TO_WIN
global int CTF_ROUNDTIME

//Dont change these as the ui isnt built for it atm
global const int NUMBER_OF_MAP_SLOTS = 4
global const int NUMBER_OF_CLASS_SLOTS = 6

global const float FSINTRO_TIMEPERPLAYER = 2.5
global bool USE_LEGEND_ABILITYS
global int CTF_RESPAWN_TIMER

// Custom Messages IDS
global enum eCTFMessage
{
	PickedUpFlag = 0
	EnemyPickedUpFlag = 1
	TeamReturnedFlag = 2
	YourTeamFlagHasBeenReset = 3
	EnemyTeamsFlagHasBeenReset = 4
	FlagNeedsToBeAtBase = 5
	EnemyTeamReturnedFlag = 6
}

// PointHint IDS
global enum eCTFFlag
{
	Defend = 0
	Capture = 1
	Attack = 2
	Escort = 3
	Return = 4
}

// PointHint IDS
global enum eCTFClassSlot
{
	Primary = 0
	Secondary = 1
	Tactical = 2
	Ultimate = 3
}

// Screen IDS
global enum eCTFScreen
{
	WinnerScreen = 0
	VoteScreen = 1
	TiedScreen = 2
	SelectedScreen = 3
	NextRoundScreen = 4
	NotUsed = 230
}

// Stats IDS
global enum eCTFStats
{
	Clear = 0
	Captures = 1
	Kills = 2
}

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
	array<LocPairCTF> ringspots
	vector imcflagspawn
	vector milflagspawn
	array<LocPairCTF> imcspawns
	array<LocPairCTF> milspawns
	LocPairCTF &deathcam
	LocPairCTF &victorypos
	int undermap
}

global struct CTFClasses
{
	string name
	string primary
	string secondary
	array<string> primaryattachments
	array<string> secondaryattachments
	string tactical
	string ult
}

global struct CTFPlaylistWeapons
{
	string name
	array<string> mods
}

struct {
	LocationSettingsCTF &selectedLocation
	array choices
	array<LocationSettingsCTF> locationSettings
	array<CTFClasses> ctfclasses
	var scoreRui
	int colorCorrection
} file;

CTFClasses function NewCTFClass(string name, string primary, array<string> primaryattachments, string secondary, array<string> secondaryattachments, string tactical, string ult)
{
	CTFClasses ctfclass
	ctfclass.name = name
	ctfclass.primary = primary
	ctfclass.secondary = secondary
	ctfclass.primaryattachments = primaryattachments
	ctfclass.secondaryattachments = secondaryattachments
	ctfclass.tactical = tactical
	ctfclass.ult = ult

	file.ctfclasses.append(ctfclass)

	return ctfclass
}

void function Shared_RegisterCTFClass(CTFClasses ctfclass)
{
	#if SERVER
	_CTFRegisterCTFClass(ctfclass)
	#endif

	#if CLIENT
	Cl_CTFRegisterCTFClass(ctfclass)
	#endif
}

void function Sh_CustomCTF_Init()
{
	//CTF Custom Deathfield
	#if CLIENT
	AddCreatePilotCockpitCallback( CTFCustomDeathfield )
	file.colorCorrection = ColorCorrection_Register( "materials/correction/outside_ring.raw_hdr" )
	#endif		
	
	// Set Playlist Vars
	CTF_SCORE_GOAL_TO_WIN = GetCurrentPlaylistVarInt( "max_score", 5 )
	CTF_ROUNDTIME = GetCurrentPlaylistVarInt( "round_time", 1500 )
	USE_LEGEND_ABILITYS = GetCurrentPlaylistVarBool( "use_legend_abilitys", false )
	CTF_RESPAWN_TIMER = GetCurrentPlaylistVarInt( "respawn_timer", 10 )

	// Round time
	int mins_to_seconds = floor( GetCurrentPlaylistVarInt( "round_time", 25 ) * 60 ).tointeger()
	CTF_ROUNDTIME = mins_to_seconds

	// Register Classes
	for(int i = 1; i < 6; i++ ) {
		Shared_RegisterCTFClass(
			NewCTFClass(
				CTF_Equipment_GetClass_PrimaryWeapon("ctf_respawn_class" + i + "_name").name,
				CTF_Equipment_GetClass_PrimaryWeapon("ctf_respawn_class" + i + "_primary").name,
				CTF_Equipment_GetClass_PrimaryWeapon("ctf_respawn_class" + i + "_primary").mods,
				CTF_Equipment_GetClass_SecondaryWeapon("ctf_respawn_class" + i + "_secondary").name,
				CTF_Equipment_GetClass_SecondaryWeapon("ctf_respawn_class" + i + "_secondary").mods,
				CTF_Equipment_GetClass_Tactical("ctf_respawn_class" + i + "_tactical").name,
				CTF_Equipment_GetClass_Ultimate("ctf_respawn_class" + i + "_ultimate").name
			)
		)
	}

	// dtbl pls
	// Map locations, flag spawns, team spawns, deathcam, victory pos, and undermap Z
	switch( MapName() )
	{
		case eMaps.mp_flowstate:

			Shared_RegisterLocationCTF(
				NewCTFLocationSettings(
					"The Pit",
					[ // ringspots
						NewCTFLocPair(<0,0,0>, <0,0,0>),
						NewCTFLocPair(<0,0,0>, <0,0,0>),
						NewCTFLocPair(<0,0,0>, <0,0,0>),
						NewCTFLocPair(<0,0,0>, <0,0,0>),
						NewCTFLocPair(<0,0,0>, <0,0,0>)
					],
					<43846.9258, -10528.1387, -19928.1563>, // imc flag spawn
					<40144.1875, -10484.1914, -19928.1563>, // mil flag spawn
					[ // imc spawns
						NewCTFLocPair(<43744.4063, -11417.9092, -19776.1563> , <0, -179.263229, 0>),
						NewCTFLocPair(<43809.1797, -10693.9688, -19928.1563> , <0, 127.732773, 0>),
						NewCTFLocPair(<43393.8945, -9495.96387, -19682.0391> , <0, 85.6177597, 0>)
					],
					[ // mil spawns
						NewCTFLocPair(<40148.1484, -10618.4873, -19928.1563> , <0, 47.8334274, 0>),
						NewCTFLocPair(<40583.9453, -9414.48828, -19682.0371> , <0, 84.4184952, 0>),
						NewCTFLocPair(<40204.5703, -11342.1201, -19776.1563> , <0, -4.65609407, 0>)
					],
					NewCTFLocPair(<0,0,0>, <0, 0, 0>), // deathcam angle and height
					NewCTFLocPair(<0,0,0>, <0, 0, 0>), // Victory Pos
					-20500 // Undermap Z
				)
			)
	
			Shared_RegisterLocationCTF(
				NewCTFLocationSettings(
					"Narrows",
					[ // ringspots
						NewCTFLocPair(<0,0,0>, <0,0,0>),
						NewCTFLocPair(<0,0,0>, <0,0,0>),
						NewCTFLocPair(<0,0,0>, <0,0,0>),
						NewCTFLocPair(<0,0,0>, <0,0,0>),
						NewCTFLocPair(<0,0,0>, <0,0,0>)
					],
					<44466.7773, -9996.7627, -20430.7383>, // imc flag spawn
					<39525.0586, -10000.9443, -20430.7383>, // mil flag spawn
					[ // imc spawns
						NewCTFLocPair(<44283.6914, -10554.7461, -20494.6563> , <0, 180, 0>),
						NewCTFLocPair(<44283.6914, -10554.7461, -20494.6563> , <0, 180, 0>),
						NewCTFLocPair(<44034.75, -9440.18555, -20431.0566> , <0, 180, 0>),
						NewCTFLocPair(<44034.75, -9440.18555, -20431.0566> , <0, 180, 0>)
					],
					[ // mil spawns
						NewCTFLocPair(<39965.9688, -9465.57813, -20431.0566> , <0, 0, 0>),
						NewCTFLocPair(<39965.9688, -9465.57813, -20431.0566> , <0, 0, 0>),
						NewCTFLocPair(<39809.4609, -10554.8604, -20494.6563> , <0, 0, 0>),
						NewCTFLocPair(<39809.4609, -10554.8604, -20494.6563> , <0, 0, 0>)
					],
					NewCTFLocPair(<0,0,5000>, <90,180,0>), // deathcam angle and height
					NewCTFLocPair(<32575,-5068, -28845>, <0, 0, 0>), // Victory Pos
					-21000 // Undermap Z
				)
			)
			break

		case eMaps.mp_rr_canyonlands_staging:
			Shared_RegisterLocationCTF(
				NewCTFLocationSettings(
					"Firing Range",
					[ // ringspots
						NewCTFLocPair(<33560, -8992, -29126>, <0, 90, 0>),
						NewCTFLocPair(<34525, -7996, -28242>, <0, 100, 0>),
						NewCTFLocPair(<33507, -3754, -29165>, <0, -90, 0>),
						NewCTFLocPair(<34986, -3442, -28263>, <0, -113, 0>),
						NewCTFLocPair(<30567, -6373, -29041>, <0, -113, 0>)
					],
					<33076, -8916, -29125>, // imc flag spawn
					<32856, -3596, -29165>, // mil flag spawn
					[ // imc spawns
						NewCTFLocPair(<34498, -8254, -28845>, <0, 130, 0>),
						NewCTFLocPair(<31926, -8875, -29125>, <0, 105, 0>),
						NewCTFLocPair(<34529, -9354, -28972>, <0, 145, 0>),
						NewCTFLocPair(<32302, -9478, -29145>, <0, 60, 0>)
					],
					[ // mil spawns
						NewCTFLocPair(<32240, -2723, -28903>, <0, -50, 0>),
						NewCTFLocPair(<34943, -3502, -28254>, <0, -113, 0>),
						NewCTFLocPair(<30857, -3860, -28729>, <0, -30, 0>),
						NewCTFLocPair(<31836, -4098, -29081>, <0, -50, 0>)
					],
					NewCTFLocPair(<0,0,5000>, <90,180,0>), // deathcam angle and height
					NewCTFLocPair(<32575,-5068, -28845>, <0, 0, 0>), // Victory Pos
					-29446 // Undermap Z
				)
			)
			break

		case eMaps.mp_rr_aqueduct:
		case eMaps.mp_rr_aqueduct_night:
			Shared_RegisterLocationCTF(
				NewCTFLocationSettings(
					"Overflow",
					[ // ringspots
						NewCTFLocPair(<4859, -4097, 351>, <0, 0, 0>),
						NewCTFLocPair(<-3436, -4097, 351>, <0, 0, 0>)
					],
					<4859, -4097, 351>, // imc flag spawn
					<-3436, -4097, 351>, // mil flag spawn
					[ // imc spawns
						NewCTFLocPair(<4386, -3185, 332>, <0, -145, 0>),
						NewCTFLocPair(<4372, -5591, 460>, <0, 161, 0>),
						NewCTFLocPair(<4528, -4683, 332>, <0, -130, 0>),
						NewCTFLocPair(<4208, -3785, 332>, <0, -165, 0>)
					],
					[ // mil spawns
						NewCTFLocPair(<-2914, -5607, 460>, <0, 0, 0>),
						NewCTFLocPair(<-3205, -4625, 332>, <0, -14, 0>),
						NewCTFLocPair(<-2870, -3833, 332>, <0, -37, 0>),
						NewCTFLocPair(<-2997, -3094, 332>, <0, -19, 0>)
					],
					NewCTFLocPair(<0,0,5000>, <90,-90,0>), // deathcam angle and height
					NewCTFLocPair(<8212, -3014, 783>, <0, 120, 0>), // Victory Pos
					-408 // Undermap Z
				)
			)
			break

		case eMaps.mp_rr_arena_composite:
			Shared_RegisterLocationCTF(
				NewCTFLocationSettings(
					"Drop Off",
					[ // ringspots
						NewCTFLocPair(<4133, 660, 365>, <0, 0, 0>),
						NewCTFLocPair(<-4178, 617, 289>, <0, 0, 0>),
						NewCTFLocPair(<0, 6140, 76>, <0, 0, 0>)
					],
					<3227, 1357, 204>, // imc flag spawn
					<-3227, 1357, 204>, // mil flag spawn
					[ // imc spawns
						NewCTFLocPair(<3287, 2126, 191>, <0, 134, 0>),
						NewCTFLocPair(<3828, 2408, 191>, <0, 170, 0>),
						NewCTFLocPair(<2173, 618, 226>, <0, 158, 0>),
						NewCTFLocPair(<2142, 1035, 231>, <0, 231, 0>)
					],
					[ // mil spawns
						NewCTFLocPair(<-3259, 2192, 191>, <0, 47, 0>),
						NewCTFLocPair(<-3765, 2462, 191>, <0, 5, 0>),
						NewCTFLocPair(<-2178, 634, 225>, <0, 23, 0>),
						NewCTFLocPair(<-2179, 1020, 226>, <0, 0, 0>)
					],
					NewCTFLocPair(<0, 6208, 3162>, <40,-90,0>), // deathcam angle and height
					NewCTFLocPair(<0, 512,184>, <0, 90, 0>), // Victory Pos
					-175 // Undermap Z
				)
			)
			break

		case eMaps.mp_rr_ashs_redemption:
			Shared_RegisterLocationCTF(
				NewCTFLocationSettings(
					"Ash's Redemption",
					[ // ringspots
						NewCTFLocPair(<-22104, 6009, -26929>, <0, 0, 0>),
						NewCTFLocPair(<-21372, 3709, -26955>, <-5, 55, 0>),
						NewCTFLocPair(<-19356, 6397, -26861>, <-4, -166, 0>),
						NewCTFLocPair(<-20713, 7409, -26742>, <-4, -114, 0>)
					],
					<-20127, 7319, -27038>, // imc flag spawn
					<-21784, 4144, -27039>, // mil flag spawn
					[ // imc spawns
						NewCTFLocPair(<-19363, 6818, -27054>, <0, -130, 0>),
						NewCTFLocPair(<-19544, 7284, -26833>, <0, -117, 0>),
						NewCTFLocPair(<-19199, 6382, -27059>, <0, -116, 0>),
						NewCTFLocPair(<-20866, 6935, -27006>, <0, 173, 0>)
					],
					[ // mil spawns
						NewCTFLocPair(<-22452, 4873, -26918>, <0, 93, 0>),
						NewCTFLocPair(<-21644, 3908, -27033>, <0, 89, 0>),
						NewCTFLocPair(<-22439, 5075, -26994>, <0, 73, 0>),
						NewCTFLocPair(<-22024, 4408, -26938>, <0, -35, 0>)
					],
					NewCTFLocPair(<0,0,3000>, <90,4,0>), // deathcam angle and height
					NewCTFLocPair(<-20904, 5797, -26745>, <0, -75, 0>), // Victory Pos
					-27272 // Undermap Z
				)
			)
			break

		case eMaps.mp_rr_canyonlands_mu1:
		case eMaps.mp_rr_canyonlands_mu1_night:
		case eMaps.mp_rr_canyonlands_64k_x_64k:
			Shared_RegisterLocationCTF(
				NewCTFLocationSettings(
					"Relay",
					[ // ringspots
						NewCTFLocPair(<29625, 25371, 4216>, <0, 90, 0>),
						NewCTFLocPair(<22958, 22128, 3914>, <0, 18, 0>),
						NewCTFLocPair(<26825, 30767, 4790>, <0, 180, 0>)
					],
					<23258, 22476, 3914>, // imc flag spawn
					<30139, 25359, 4216>, // mil flag spawn
					[ // imc spawns
						NewCTFLocPair(<24272, 21828, 3914>, <0, 40, 0>),
						NewCTFLocPair(<23815, 23703, 4058>, <0, 35, 0>),
						NewCTFLocPair(<22419, 23489, 4251>, <0, 180, 0>),
						NewCTFLocPair(<21577, 22943, 4256>, <0, -15, 0>)
					],
					[ // mil spawns
						NewCTFLocPair(<30000, 26381, 4216>, <0, -135, 0>),
						NewCTFLocPair(<29036, 24253, 4216>, <0, 90, 0>),
						NewCTFLocPair(<27698, 28291, 4102>, <0, -160, 0>),
						NewCTFLocPair(<27628, 25640, 4370>, <0, 160, 0>)
					],
					NewCTFLocPair(<0,0,6000>, <90,-70,0>), // deathcam angle and height
					NewCTFLocPair(<29665, 26180, 4206>, <0, -90, 0>), // Victory Pos
					3330 // Undermap Z
				)
			)

			Shared_RegisterLocationCTF(
				NewCTFLocationSettings(
					"Artillery",
					[ // ringspots
						NewCTFLocPair(<9614, 30792, 4868>, <0, 90, 0>),
						NewCTFLocPair(<6379, 30792, 4868>, <0, 18, 0>),
						NewCTFLocPair(<3603, 30792, 4868>, <0, 180, 0>),
						NewCTFLocPair(<6379, 29172, 4868>, <0, 50, 0>)
					],
					<9400, 30767, 5028>, // imc flag spawn
					<3690, 30767, 5028>, // mil flag spawn
					[ // imc spawns
						NewCTFLocPair(<10250, 30984, 4828>, <0, -170, 0>),
						NewCTFLocPair(<10237, 30573, 4828>, <0, 170, 0>),
						NewCTFLocPair(<9127, 30626, 4832>, <0, 170, 0>),
						NewCTFLocPair(<8997, 30943, 4828>, <0, -170, 0>)
					],
					[ // mil spawns
						NewCTFLocPair(<4402, 30619, 4828>, <0, 8, 0>),
						NewCTFLocPair(<4148, 30573, 4828>, <0, -8, 0>),
						NewCTFLocPair(<3415, 30626, 4832>, <0, -8, 0>),
						NewCTFLocPair(<3263, 30943, 4828>, <0, 8, 0>)
					],
					NewCTFLocPair(<0,0,5000>, <90,90,0>), // deathcam angle and height
					NewCTFLocPair(<6547, 31977, 5470>, <0, -90, 0>), // Victory Pos
					4683 // Undermap Z
				)
			)

			Shared_RegisterLocationCTF(
				NewCTFLocationSettings(
					"Airbase",
					[ // ringspots
						NewCTFLocPair(<-25775, 1599, 2583>, <0, 90, 0>),
						NewCTFLocPair(<-24845,-5112,2571>, <0, 18, 0>),
						NewCTFLocPair(<-28370, -2238, 2550>, <0, 180, 0>)
					],
					<-25775, 1599, 2583>, // imc flag spawn
					<-24845, -5112, 2571>, // mil flag spawn
					[ // imc spawns
						NewCTFLocPair(<-26435, 2024, 2568>, <0, -70, 0>),
						NewCTFLocPair(<-26870, 650, 2599>, <0, -30, 0>),
						NewCTFLocPair(<-24342, 51, 2568>, <0, -125, 0>),
						NewCTFLocPair(<-27234, -254, 2568>, <0, -20, 0>)
					],
					[ // mil spawns
						NewCTFLocPair(<-25699, -5971, 2580>, <0, 19, 0>),
						NewCTFLocPair(<-23893, -4242, 2568>, <0, 90, 0>),
						NewCTFLocPair(<-26251, -4939, 2573>, <0, 44, 0>),
						NewCTFLocPair(<-27554, -4611, 2536>, <0, 45, 0>)
					],
					NewCTFLocPair(<0,0,5000>, <90,0,0>), // deathcam angle and height
					NewCTFLocPair(<-29300, -4209, 2540>, <0, 100, 0>), // Victory Pos
					2183 // Undermap Z
				)
			)

			Shared_RegisterLocationCTF(
				NewCTFLocationSettings(
					"Wetlands",
					[ // ringspots
						NewCTFLocPair(<29585, 16597, 4641>, <0, 90, 0>),
						NewCTFLocPair(<19983, 14582, 4670>, <0, 18, 0>),
						NewCTFLocPair(<25244, 16658, 3871>, <0, 180, 0>)
					],
					<28495, 16316, 4206>, // imc flag spawn
					<19843, 14597, 4670>, // mil flag spawn
					[ // imc spawns
						NewCTFLocPair(<27589, 17568, 4206>, <0, -160, 0>),
						NewCTFLocPair(<27560, 15678, 4350>, <0, 180, 0>),
						NewCTFLocPair(<29963, 17119, 4366>, <0, 165, 0>),
						NewCTFLocPair(<29234, 15319, 4206>, <0, 135, 0>)
					],
					[ // mil spawns
						NewCTFLocPair(<20337, 13229, 4670>, <0, 50, 0>),
						NewCTFLocPair(<20230, 16421, 4670>, <0, 0, 0>),
						NewCTFLocPair(<21194, 16925, 4518>, <0, -60, 0>),
						NewCTFLocPair(<22281, 13742, 4422>, <0, 40, 0>)
					],
					NewCTFLocPair(<0,0,7000>, <90,90,0>), // deathcam angle and height
					NewCTFLocPair(<22867, 14375, 4412>, <0, 90, 0>), // Victory Pos
					3072 // Undermap Z
				)
			)

			Shared_RegisterLocationCTF(
				NewCTFLocationSettings(
					"Repulsor",
					[ // ringspots
						NewCTFLocPair(<20269, -14999, 4824>, <0, 90, 0>),
						NewCTFLocPair(<29000, -15195, 4726>, <0, 18, 0>),
						NewCTFLocPair(<24417, -15196, 5203>, <0, 180, 0>)
					],
					<21422, -14999, 4824>, // imc flag spawn
					<27967, -15195, 4726>, // mil flag spawn
					[ // imc spawns
						NewCTFLocPair(<21925, -12916, 4726>, <0, -50, 0>),
						NewCTFLocPair(<21925, -16826, 4726>, <0, 50, 0>),
						NewCTFLocPair(<22251, -15589, 4598>, <0, 35, 0>),
						NewCTFLocPair(<22251, -14171, 4598>, <0, -35, 0>)
					],
					[ // mil spawns
						NewCTFLocPair(<28347, -13383, 4726>, <0, 180, 0>),
						NewCTFLocPair(<28347, -17113, 4726>, <0, 180, 0>),
						NewCTFLocPair(<26507, -15813, 4730>, <0, -135, 0>),
						NewCTFLocPair(<26507, -14500, 4730>, <0, 135, 0>)
					],
					NewCTFLocPair(<0,0,7000>, <90,90,0>), // deathcam angle and height
					NewCTFLocPair(<23495, -17625, 5424>, <0, 90, 0>), // Victory Pos
					3879 // Undermap Z
				)
			)

			Shared_RegisterLocationCTF(
				NewCTFLocationSettings(
					"Skull Town",
					[ // ringspots
						NewCTFLocPair(<-12391, -19413, 3166>, <0, 90, 0>),
						NewCTFLocPair(<-6706, -13383, 3174>, <0, 18, 0>),
						NewCTFLocPair(<-9746, -16127, 4062>, <0, 180, 0>)
					],
					<-12391, -19413, 3166>, // imc flag spawn
					<-6706, -13383, 3174>, // mil flag spawn
					[ // imc spawns
						NewCTFLocPair(<-11246, -19126, 3285>, <0, 70, 0>),
						NewCTFLocPair(<-12575, -18156, 3170>, <0, 0, 0>),
						NewCTFLocPair(<-12125, -17650, 3186>, <0, 45, 0>),
						NewCTFLocPair(<-11241, -18068, 3187>, <0, 45, 0>)
					],
					[ // mil spawns
						NewCTFLocPair(<-6509, -14479, 3166>, <0, -135, 0>),
						NewCTFLocPair(<-7242, -13374, 3166>, <0, 170, 0>),
						NewCTFLocPair(<-7573, -13783, 3186>, <0, -100, 0>),
						NewCTFLocPair(<-7472, -14763, 3183>, <0, -150, 0>)
					],
					NewCTFLocPair(<0,0,7000>, <90,-45,0>), // deathcam angle and height
					NewCTFLocPair(<-9774, -15325, 4056>, <0, 135, 0>), // Victory Pos
					2762 // Undermap Z
				)
			)

			Shared_RegisterLocationCTF(
				NewCTFLocationSettings(
					"Tunnel",
					[ // ringspots
						NewCTFLocPair(<770, 30495, 4835>, <0, 0, 0>),
						NewCTFLocPair(<-3298, 27005, 4835>, <0, 0, 0>)
					],
					<770, 30495, 4835>, // imc flag spawn
					<-3298, 27005, 4835>, // mil flag spawn
					[ // imc spawns
						NewCTFLocPair(<555, 30966, 4892>, <0, -148, 0>),
						NewCTFLocPair(<626, 30006, 4835>, <0, 167, 0>),
						NewCTFLocPair(<89, 30026, 4835>, <0, 169, 0>),
						NewCTFLocPair(<580, 30274, 4835>, <0, -162, 0>)
					],
					[ // mil spawns
						NewCTFLocPair(<-2828, 27144, 4835>, <0, 92, 0>),
						NewCTFLocPair(<-2811, 27374, 4835>, <0, 92, 0>),
						NewCTFLocPair(<-3743, 27144, 4892>, <0, 66, 0>),
						NewCTFLocPair(<-3597, 27462, 4835>, <0, 75, 0>)
					],
					NewCTFLocPair(<-1208,30559,5079>, <12,-61,0>), // deathcam angle and height
					NewCTFLocPair(<-1771, 29459, 4835>, <0, 135, 0>), // Victory Pos
					4600 // Undermap Z
				)
			)

			Shared_RegisterLocationCTF(
				NewCTFLocationSettings(
					"Watch Tower",
					[ // ringspots
						NewCTFLocPair(<-1542, 19654, 4380>, <0, 0, 0>),
						NewCTFLocPair(<2336, 23735, 4188>, <0, 0, 0>)
					],
					<-1542, 19654, 4380>, // imc flag spawn
					<2336, 23735, 4188>, // mil flag spawn
					[ // imc spawns
						NewCTFLocPair(<-1362, 19638, 4630>, <0, 38, 0>),
						NewCTFLocPair(<-1538, 19815, 4630>, <0, 52, 0>),
						NewCTFLocPair(<-746, 19892, 4380>, <0, 118, 0>),
						NewCTFLocPair(<-1652, 20027, 4348>, <0, 33, 0>)
					],
					[ // mil spawns
						NewCTFLocPair(<2089, 23868, 4188>, <0, -139, 0>),
						NewCTFLocPair(<2474, 23495, 4188>, <0, -124, 0>),
						NewCTFLocPair(<2291, 22911, 3996>, <0, -125, 0>),
						NewCTFLocPair(<1463, 23680, 3996>, <0, -117, 0>)
					],
					NewCTFLocPair(<0,0,5000>, <90,-42,0>), // deathcam angle and height
					NewCTFLocPair(<1456, 22294, 4304>, <0, 136, 0>), // Victory Pos
					2343 // Undermap Z
				)
			)

			break
		case eMaps.mp_rr_olympus_mu1:
			Shared_RegisterLocationCTF(
				NewCTFLocationSettings(
					"Gardens",
					[ // ringspots
						NewCTFLocPair(<16279.9443, 13022.3496, -3591.96875>, <0, -93.9162674, 0>),
						NewCTFLocPair(<15700.4648, 4015.26831, -3591.96875>, <0, 88.1664734, 0>),
						NewCTFLocPair(<19953.1934, 8301.0957, -3028.84399>, <0, 172.557816, 0>)
					],
					<16232.7793, 12178.1436, -3591.96875>, // imc flag spawn
					<15827.2217, 4953.29297, -3591.96875>, // mil flag spawn
					[ // imc spawns
						NewCTFLocPair(<17395.084, 12189.5537, -3591.96875>, <0, -94.7524567, 0>),
						NewCTFLocPair(<15127.5156, 12389.5801, -3579.75586>, <0, -91.9276581, 0>),
						NewCTFLocPair(<14703.4482, 11041.8711, -3487.39014>, <0, -98.3109512, 0>),
						NewCTFLocPair(<17430.2402, 11183.5928, -3487.39014>, <0, -84.2348175, 0>)
					],
					[ // mil spawns
						NewCTFLocPair(<14670.6592, 4912.80273, -3591.96875>, <0, 87.3093185, 0>),
						NewCTFLocPair(<17030.5293, 4793.00488, -3591.96875>, <0, 87.364563, 0>),
						NewCTFLocPair(<14473.1006, 5982.35059, -3487.39014>, <0, 81.9205856, 0>),
						NewCTFLocPair(<17525.3906, 6092.90088, -3487.39014>, <0, 84.3147583, 0>)
					],
					NewCTFLocPair(<16137.8916, 8448.7793, 1112.35474>, <0, 174.990341, 0>), // deathcam angle and height //<-11968.6592, 10692.5781, 3963.90991> <0, -77.5005569, 0>

					NewCTFLocPair(<14500.2412, 5929.81494, -3487.39014>, <0, 23.6395264, 0>), // Victory Pos
					-3780 // Undermap Z
				)
			)

			Shared_RegisterLocationCTF(
				NewCTFLocationSettings(
					"Turbine",
					[ // ringspots
						NewCTFLocPair(<-10178.1816, 7338.68408, -5887.62793>, <0, 120.838982, 0>),
						NewCTFLocPair(<-15231.8418, 12333.5508, -6399.63477>, <0, -32.3907623, 0>),
						NewCTFLocPair(<-8425.39941, 12467.876, -5877.44678>, <0, -157.88298, 0>)
					],
					<-14124.1426, 9829.75488, -6543.95068>, // imc flag spawn
					<-9459.69336, 11944.6963, -6049.47266>, // mil flag spawn
					[ // imc spawns
						NewCTFLocPair(<-14633.3203, 11222.1494, -6559.63477>, <0, -58.4951973, 0>),
						NewCTFLocPair(<-13012.0166, 8264.48926, -6224.89355>, <0, 7.37708473, 0>),
						NewCTFLocPair(<-15519.1943, 9790.82129, -6399.84082>, <0, 1.22403598, 0>),
						NewCTFLocPair(<-14893.6074, 8657.10059, -6399.96875>, <0, 22.6704369, 0>)
					],
					[ // mil spawns
						NewCTFLocPair(<-10170.4111, 11851.2695, -6175.61865>, <0, -67.3220367, 0>),
						NewCTFLocPair(<-8362.85742, 12449.0439, -5877.44678>, <0, -156.566605, 0>),
						NewCTFLocPair(<-9218.04688, 10373.4824, -6150.27051>, <0, 152.563736, 0>),
						NewCTFLocPair(<-10959.998, 13389.7871, -6175.61963>, <0, -115.083687, 0>)
					],
					NewCTFLocPair(<-11968.6592, 10692.5781, 3963.90991>, <0, -77.5005569, 0>), // deathcam angle and height //<-11968.6592, 10692.5781, 3963.90991> <0, -77.5005569, 0>

					NewCTFLocPair(<-17077.5449, 8725.19434, -6402.74561>, <0,71,0>), // Victory Pos
					-6800 // Undermap Z
				)
			)
			break
		case eMaps.mp_rr_desertlands_64k_x_64k:
		case eMaps.mp_rr_desertlands_64k_x_64k_nx:
			Shared_RegisterLocationCTF(
				NewCTFLocationSettings(
					"Overlook",
					[ // ringspots
						NewCTFLocPair(<26893, 13646, -3199>, <0, 40, 0>),
						NewCTFLocPair(<30989, 8510, -3329>, <0, 90, 0>),
						NewCTFLocPair(<32922, 9423, -3329>, <0, 90, 0>)
					],
					<26893, 13646, -3199>, // imc flag spawn
					<30989, 8510, -3329>, // mil flag spawn
					[ // imc spawns
						NewCTFLocPair(<25997, 13028, -3139>, <0, -30, 0>),
						NewCTFLocPair(<28416, 13515, -3230>, <0, -88, 0>),
						NewCTFLocPair(<26215, 14402, -3081>, <0, -65, 0>),
						NewCTFLocPair(<27408, 14510, -3141>, <0, -65, 0>)
					],
					[ // mil spawns
						NewCTFLocPair(<31780, 8514, -3329>, <0, 137, 0>),
						NewCTFLocPair(<30207, 7910, -3313>, <0, 101, 0>),
						NewCTFLocPair(<31254, 9956, -3393>, <0, 90, 0>),
						NewCTFLocPair(<32519, 9890, -3525>, <0, 166, 0>)
					],
					NewCTFLocPair(<0,0,5000>, <90,27,0>), // deathcam angle and height
					NewCTFLocPair(<3990,7540,-4242>, <0,90,0>), // Victory Pos
					-3893 // Undermap Z
				)
			)

			Shared_RegisterLocationCTF(
				NewCTFLocationSettings(
					"Refinery",
					[ // ringspots
						NewCTFLocPair(<22630, 21512, -4516>, <0, 40, 0>),
						NewCTFLocPair(<19147, 30973, -4602>, <0, 90, 0>)
					],
					<22630, 22243, -4516>, // imc flag spawn
					<19147, 30973, -4602>, // mil flag spawn
					[ // imc spawns
						NewCTFLocPair(<21618, 22558, -4499>, <0, 110, 0>),
						NewCTFLocPair(<20873, 23929, -4557>, <0, 140, 0>),
						NewCTFLocPair(<22247, 22785, -4523>, <0, 67, 0>),
						NewCTFLocPair(<23384, 21955, -4523>, <0, 108, 0>)
					],
					[ // mil spawns
						NewCTFLocPair(<18034, 30657, -4578>, <0, -42, 0>),
						NewCTFLocPair(<19757, 31462, -4340>, <0, -63, 0>),
						NewCTFLocPair(<18320, 29370, -4778>, <0, -101, 0>),
						NewCTFLocPair(<16344, 29093, -4441>, <0, -13, 0>)
					],
					NewCTFLocPair(<0,0,7000>, <90,-165,0>),// deathcam angle and height
					NewCTFLocPair(<3990,7540,-4242>, <0,90,0>), // Victory Pos
					-5123 // Undermap Z
				)
			)

			Shared_RegisterLocationCTF(
				NewCTFLocationSettings(
					"Capitol City",
					[ // ringspots
						NewCTFLocPair(<1750, 5158, -3334>, <0, 40, 0>),
						NewCTFLocPair(<11690, 6300, -4065>, <0, 90, 0>)
					],
					<1750, 5158, -3334>, // imc flag spawn
					<11690, 6300, -4065>, // mil flag spawn
					[ // imc spawns
						NewCTFLocPair(<2102, 5999, -4225>, <0, 0, 0>),
						NewCTFLocPair(<1761, 5356, -3953>, <0, -29, 0>),
						NewCTFLocPair(<1392, 4444, -3006>, <0, 40, 0>),
						NewCTFLocPair(<2979, 4051, -4225>, <0, 50, 0>)
					],
					[ // mil spawns
						NewCTFLocPair(<12050, 7446, -4281>, <0, 170, 0>),
						NewCTFLocPair(<12122, 5159, -4225>, <0, -170, 0>),
						NewCTFLocPair(<10679, 4107, -4225>, <0, 120, 0>),
						NewCTFLocPair(<12185, 6412, -4281>, <0, -130, 0>)
					],
					NewCTFLocPair( < 0, 0, 7000 > , < 90, -85, 0 > ), // deathcam angle and height
					NewCTFLocPair(<3990,7540,-4242>, <0,90,0>), // Victory Pos
					-4754 // Undermap Z
				)
			)

			Shared_RegisterLocationCTF(
				NewCTFLocationSettings(
					"Sorting Factory",
					[ // ringspots
						NewCTFLocPair(<1874, -25365, -3385>, <0, 40, 0>),
						NewCTFLocPair(<10684, -18468, -3584>, <0, 90, 0>)
					],
					<1874, -25365, -3385>, // imc flag spawn
					<10684, -18468, -3584>, // mil flag spawn
					[ // imc spawns
						NewCTFLocPair(<1747, -22990, -3561>, <0, 31, 0>),
						NewCTFLocPair(<3904, -25013, -3561>, <0, 0, 0>),
						NewCTFLocPair(<2110, -25117, -3037>, <0, 50, 0>),
						NewCTFLocPair(<2242, -21858, -3657>, <0, -25, 0>)
					],
					[ // mil spawns
						NewCTFLocPair(<9020, -18238, -3563>, <0, -118, 0>),
						NewCTFLocPair(<10076, -19642, -2889>, <0, -148, 0>),
						NewCTFLocPair(<7793, -17583, -3657>, <0, -80, 0>),
						NewCTFLocPair(<9377, -20718, -3569>, <0, -179, 0>)
					],
					NewCTFLocPair( < 0, 0, 7000 > , < 90, -45, 0 > ), // deathcam angle and height
					NewCTFLocPair(<3990,7540,-4242>, <0,90,0>), // Victory Pos
					-4808 // Undermap Z
				)
			)

		default:
			Assert(false, "No CTF locations found for map!")
	}

	// Client Signals
	RegisterSignal( "CloseScoreRUI" )

}

LocPairCTF function NewCTFLocPair(vector origin, vector angles)
{
	LocPairCTF locPair
	locPair.origin = origin
	locPair.angles = angles

	return locPair
}

LocationSettingsCTF function NewCTFLocationSettings(string name, array < LocPairCTF > ringspots, vector imcflagspawn, vector milflagspawn, array < LocPairCTF > imcspawns, array < LocPairCTF > milspawns, LocPairCTF deathcam, LocPairCTF victorypos, int undermap)
{
	LocationSettingsCTF locationSettings
	locationSettings.name = name
	locationSettings.ringspots = ringspots
	locationSettings.imcflagspawn = imcflagspawn
	locationSettings.milflagspawn = milflagspawn
	locationSettings.imcspawns = imcspawns
	locationSettings.milspawns = milspawns
	locationSettings.deathcam = deathcam
	locationSettings.victorypos = victorypos
	locationSettings.undermap = undermap

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

// Playlist GET
float function CTF_Equipment_GetDefaultShieldHP() { return GetCurrentPlaylistVarFloat("default_shield_hp", 100) }
float function CTF_GetOOBDamagePercent() { return GetCurrentPlaylistVarFloat("oob_damage_percent", 25) }

CTFPlaylistWeapons function CTF_Equipment_GetClass_PrimaryWeapon(string playlistvar)
{
	return Equipment_GetClass_Weapon(GetCurrentPlaylistVarString(playlistvar, "~~none~~"))
}

CTFPlaylistWeapons function CTF_Equipment_GetClass_SecondaryWeapon(string playlistvar)
{
	return Equipment_GetClass_Weapon(GetCurrentPlaylistVarString(playlistvar, "~~none~~"))
}

CTFPlaylistWeapons function CTF_Equipment_GetClass_Tactical(string playlistvar)
{
	return Equipment_GetClass_Weapon(GetCurrentPlaylistVarString(playlistvar, "~~none~~"))
}

CTFPlaylistWeapons function CTF_Equipment_GetClass_Ultimate(string playlistvar)
{
	return Equipment_GetClass_Weapon(GetCurrentPlaylistVarString(playlistvar, "~~none~~"))
}

CTFPlaylistWeapons function Equipment_GetClass_Weapon(string input)
{
	CTFPlaylistWeapons weapon
	if(input == "~~none~~") return weapon

	array<string> args = split(input, " ")

	if(args.len() == 0) return weapon

	weapon.name = args[0]
	weapon.mods = args.slice(1, args.len())

	return weapon
}

#if CLIENT
void function CTFCustomDeathfield( entity cockpit, entity player )
{
	thread CTFCustomDeathfield_Internal( cockpit, player )
}

void function CTFCustomDeathfield_Internal( entity cockpit, entity player )
{
	player.EndSignal( "OnDestroy" )
	cockpit.EndSignal( "OnDestroy" )

	bool wasShowingDeathFieldFx = false
	int screenFx

	OnThreadEnd(
		function() : ( screenFx, player )
		{
			ColorCorrection_SetWeight( file.colorCorrection, 0.0 )
			Chroma_EnteredRing()

			if ( EffectDoesExist( screenFx ) )
			{
				EffectStop( screenFx, true, true )
			}
		}
	)

	ColorCorrection_SetExclusive( file.colorCorrection, true )

	while ( 1 )
	{
		bool shouldShowDeathFieldFx = CTFShouldShowDeathFieldEffects( player )

		if ( wasShowingDeathFieldFx != shouldShowDeathFieldFx )
		{
			if ( shouldShowDeathFieldFx )
			{

				if ( !EffectDoesExist( screenFx ) )
				{
					screenFx = StartParticleEffectOnEntity( cockpit, GetParticleSystemIndex( $"P_ring_FP_hit_01" ), FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
					EffectSetIsWithCockpit( screenFx, true )
				}

				ColorCorrection_SetWeight( file.colorCorrection, 1.0 )

				Chroma_LeftRing()
			}
			else
			{

				if ( EffectDoesExist( screenFx ) )
				{
					EffectStop( screenFx, true, true )
				}

				ColorCorrection_SetWeight( file.colorCorrection, 0.0 )

				Chroma_EnteredRing()
			}
			wasShowingDeathFieldFx = shouldShowDeathFieldFx
		}

		WaitFrame()
	}
}

bool function CTFShouldShowDeathFieldEffects( entity player )
{
	bool shouldShow = true

	if ( !IsAlive( player ) )
		shouldShow = false

	if ( player.ContextAction_IsInVehicle() )
	{
		if ( DeathField_PointDistanceFromFrontier( player.EyePosition() ) >= 0 )
			shouldShow = false
	}
	else
	{
		if ( DeathField_PointDistanceFromFrontier( player.GetOrigin() ) >= 0 )
			shouldShow = false
	}
	if ( IsViewingSquadSummary() || IsViewingDeathRecap() )
		shouldShow = false

	return shouldShow
}
#endif

vector function FSIntro_GetVictorySquadFormationPosition( vector mainPosition, vector angles, int index )
{
	index += 1

	float internalGroupOffsetSide = 45.0																						   
	float internalGroupOffsetBack = -40.0																			  

	//fix me
	if( index == 1 || index == 2 )
	{
		internalGroupOffsetSide = 23
		internalGroupOffsetBack = 0
	} else
	{
		internalGroupOffsetSide *= ceil( float( index ) / 2 )
		internalGroupOffsetBack *= ceil( float( index ) / 2 )
	}

	float finalOffsetSide = internalGroupOffsetSide * ( index % 2 == 0 ? 1 : -1 )
	float finalOffsetBack = internalGroupOffsetBack

	// file.charactersModels.append( finalOffsetSide )

	#if DEVELOPER
		printt( "building position for player in victory screen:", mainPosition, index, finalOffsetSide, finalOffsetBack )
	#endif
	
	vector offset = < finalOffsetSide, finalOffsetBack, -8 >
	return OffsetPointRelativeToVector( mainPosition, offset, AnglesToForward( angles ) )
}
