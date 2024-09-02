// Flowstate DM
// Fork of the custom_tdm gamemode made by sal#3261

// Credits:

// CafeFPS 			- Main Developer
// AyeZee#6969 		-- Ctf voting phase to work off & droppods
// Zer0Bytes#4428 	-- Weapons randomizer rewrite
// makimakima#5561 	-- TDM Saved Weapon List, 1v1 gamemode
// michae\l/#1125 	-- flowstate admin
// mkos 			-- Developer #2 ( cafe's apprentice :D )
// everyone else 	-- advice

//TODO: Abstract gamemode specific logic into each gamemodes own file 
//		and make logic in this script modular ( template-like ) by setting up
//		callback systems and allowing logic to be defined outside of this file

global function _CustomTDM_Init
global function _RegisterLocation
global function CharSelect
global function CreateAnimatedLegend
global function Message
global function shuffleArray
global function WpnAutoReloadOnKill
global function GetTDMState
global function SetTdmStateToNextRound
global function SetTdmStateToInProgress
global function SetFallTriggersStatus
global function CreateShipRoomFallTriggers
global function GiveFlowstateOvershield
global function IsAdmin
global function Flowstate_ServerSaveChat
global function GetWhiteListedWeapons
global function GetWhiteListedAbilities
global function GiveRandomPrimaryWeaponMetagame
global function GiveRandomSecondaryWeaponMetagame
global function LoadCustomWeapon
global function getkd

global function ClientCommand_SpectateEnemies
global function	ClientCommand_RebalanceTeams
global function	ClientCommand_FlowstateKick
global function	ClientCommand_ShowLatency
global function WpnPulloutOnRespawn
global function ReCheckGodMode
global function GetBestPlayer
global function SendScoreboardToClient
global function GetMainRingBoundary
global function GetScoreboardShowingState
global function is1v1EnabledAndAllowed
global function ForceSaveOgSkyboxOrigin

//cool stuff
global function SpawnCyberdyne
global function SpawnLockout
global function SpawnChill
global function GiveRandomPrimaryWeaponHalo
global function GiveRandomSecondaryWeaponHalo
global function GetServerPropsInDmFile

global function HaloMod_Cyberdyne_CreateFanPusher
global function HisWattsons_HaloModFFA_KillStreakAnnounce
global function SetupInfiniteAmmoForWeapon
global function FSDM_GetSelectedLocation
global function Flowstate_GrantSpawnImmunity
global function GetBlackListedWeapons
global function DM__OnEntitiesDidLoad
global function DissolveItem

//R5R.DEV Tracker
global function ReturnChatArray //not really used yet
global function GetCurrentRound 
global function RotateMap
global function Tracker_SetChampionOnPersistenceLoad
global float g_fCurrentRoundEndTime
global function GetChampionShowingState
global function SetChampionShowingState
global function WaitForChampionToFinish
global const float SHORT_CHAMPION_CARD_TIME = 7.0

#if DEVELOPER
	global function DEV_NextRound
#endif

//Beginning of refactor( supposed to be for next, next release.. )
global function AddCallback_OnTdmStateEnter_InProgress


global function Message_New //deprecated, use LocalEventMsg() ~mkos
global function ServerMsgToBox //not used

global function SetPlayerCustomModel
global function ResetLoadedWeapons //tracker override

global function ClientCommand_SaveCurrentWeapons
global function ClientCommand_GiveWeapon

global function ValidateWeaponTgiveSettings

const string WHITE_SHIELD = "armor_pickup_lv1"
const string BLUE_SHIELD = "armor_pickup_lv2"
const string PURPLE_SHIELD = "armor_pickup_lv3"

global const int FLOWSTATE_START_TIME_DELAY = 7
bool debugging = false
global bool VOTING_PHASE_ENABLE = true
global bool SCOREBOARD_ENABLE = true

//TDM Saved Weapon List
global table<string,string> weaponlist
global table<string,string> skilllist //stored players skills
global array<int> characterslist = [0,4,5,6,7,8,9,10] //allowed character for normal players

global bool isBrightWaterByZer0 = false
global const float KILLLEADER_STREAK_ANNOUNCE_TIME = 5
table playersInfo

//solo mode
global function CheckForObservedTarget

struct {
	string scriptversion = ""
    int tdmState = eTDMState.IN_PROGRESS
    int nextMapIndex = 0
	bool mapIndexChanged = true
	array<entity> playerSpawnedProps
	array<ItemFlavor> characters
	int SameKillerStoredKills=0
	array<string> blacklistedWeapons
	array<string> blacklistedAbilities
	array<LocationSettings> locationSettings
    LocationSettings& selectedLocation
	array<vector> thisroundDroppodSpawns
    entity ringBoundary
	entity previousChampion
	entity previousChallenger
	int maxPlayers
	int maxTeams
	int currentRound = 1

	array<string> mAdmins
	int randomprimary
    int randomsecondary
    int randomult
    int randomtac

    entity supercooldropship
	bool isshipalive = false
	array<LocationSettings> droplocationSettings
    LocationSettings& dropselectedLocation
	
	array< int > haloModAvailableColors = [ 0, 1, 2, 3, 4, 5, 6, 7 ]

	bool FallTriggersEnabled = false
	bool mapSkyToggle = false
	array<string> allChatLines
	array<string> battlelog
	string authkey = "1234"
	bool isLoadingCustomMap = false
	vector ogSkyboxOrigin
	int winnerTeam
	
	array< void functionref() > tdmStateInProgressCallbacks
	bool bIsChampionShowing
	
} file

struct
{
    // Voting
    array<entity> votedPlayers // array of players that have already voted (bad var name idc)
    bool votingtime = false
	bool scoreboardShowing = false
    bool votestied = false
    array<int> mapVotes
    array<int> mapIds
    int mappicked = 0
} FS_DM

// ██████   █████  ███████ ███████     ███████ ██    ██ ███    ██  ██████ ████████ ██  ██████  ███    ██ ███████
// ██   ██ ██   ██ ██      ██          ██      ██    ██ ████   ██ ██         ██    ██ ██    ██ ████   ██ ██
// ██████  ███████ ███████ █████       █████   ██    ██ ██ ██  ██ ██         ██    ██ ██    ██ ██ ██  ██ ███████
// ██   ██ ██   ██      ██ ██          ██      ██    ██ ██  ██ ██ ██         ██    ██ ██    ██ ██  ██ ██      ██
// ██████  ██   ██ ███████ ███████     ██       ██████  ██   ████  ██████    ██    ██  ██████  ██   ████ ███████


struct 
{
	//bool settings
	bool ForceCharacter
	bool is_halo_gamemode
	bool RandomCharacterOnSpawn
	bool GiveAllOpticsToPlayer
	bool hackersVsPros
	bool enable_afk_thread
	bool enable_ping_kick
	bool BattleLogEnable
	bool BattleLog_Linux
	bool ChatLogEnable
	bool end_match_message
	bool rotate_map
	bool flowstate_1v1mode
	bool enable_oddball_gamemode
	bool patch_for_dropoff
	bool patch_waiting_area
	bool ReloadTacticalOnRespawn
	bool ReloadUltimateOnRespawn
	bool RandomHaloGuns
	bool DroppodsOnPlayerConnected
	bool EndlessFFAorTDM
	bool enable_global_chat
	bool allow_cfgs
	bool fs_lgduels_1v1
	bool give_random_custom_models_toall
	bool bIs1v1ModeEnabled
	bool show_short_champion_screen
	
	//string settings 
	string custom_match_ending_title
	string custom_match_ending_message
	string maplist
	string Admins
	
	//int settings 
	int endgame_delay
	
	//float settings
	float aimassist_magnet_pc
	float ring_radius_padding
	float default_ibmm_wait

} flowstateSettings

struct TrackerRecap
{
	string uid
	int kills 
	int damage 
	int score
	//int survivalTime
}

void function InitializePlaylistSettings()
{
	flowstateSettings.ForceCharacter 						= GetCurrentPlaylistVarBool( "flowstateForceCharacter", false )
	flowstateSettings.is_halo_gamemode 						= GetCurrentPlaylistVarBool( "is_halo_gamemode", false )
	flowstateSettings.RandomCharacterOnSpawn 				= GetCurrentPlaylistVarBool( "flowstateRandomCharacterOnSpawn", false )
	flowstateSettings.GiveAllOpticsToPlayer 				= GetCurrentPlaylistVarBool( "flowstateGiveAllOpticsToPlayer", false )
	flowstateSettings.hackersVsPros 						= GetCurrentPlaylistVarBool( "flowstate_hackersVsPros", false )
	flowstateSettings.enable_afk_thread 					= GetCurrentPlaylistVarBool( "enable_afk_thread", false )
	flowstateSettings.enable_ping_kick 						= GetCurrentPlaylistVarBool( "enable_ping_kick", false )
	flowstateSettings.aimassist_magnet_pc 					= GetCurrentPlaylistVarFloat( "aimassist_magnet_pc", 0.0 )
	flowstateSettings.BattleLogEnable 						= GetCurrentPlaylistVarBool( "flowstateBattleLogEnable", false )
	flowstateSettings.BattleLog_Linux 						= GetCurrentPlaylistVarBool( "flowstateBattleLog_Linux", false )
	flowstateSettings.ChatLogEnable 						= GetCurrentPlaylistVarBool( "flowstateChatLogEnable", false )
	flowstateSettings.custom_match_ending_title 			= GetCurrentPlaylistVarString( "custom_match_ending_title", "Server clean up incoming" )
	flowstateSettings.custom_match_ending_message 			= GetCurrentPlaylistVarString( "custom_match_ending_message", "Don't leave. Server is going to reload to avoid lag." )
	flowstateSettings.end_match_message 					= GetCurrentPlaylistVarBool( "end_match_message",true )
	flowstateSettings.rotate_map 							= GetCurrentPlaylistVarBool( "rotate_map", false )
	flowstateSettings.maplist 								= GetCurrentPlaylistVarString( "maplist", "" )
	flowstateSettings.ring_radius_padding 					= GetCurrentPlaylistVarFloat( "ring_radius_padding", 800 )
	flowstateSettings.Admins 								= GetCurrentPlaylistVarString( "Admins", "" )
	flowstateSettings.flowstate_1v1mode 					= GetCurrentPlaylistVarBool( "flowstate_1v1mode", false )
	flowstateSettings.enable_oddball_gamemode 				= GetCurrentPlaylistVarBool( "enable_oddball_gamemode", false )
	flowstateSettings.default_ibmm_wait 					= GetCurrentPlaylistVarFloat( "default_ibmm_wait", 0 )
	flowstateSettings.patch_for_dropoff 					= GetCurrentPlaylistVarBool( "patch_for_dropoff", false )
	flowstateSettings.patch_waiting_area 					= GetCurrentPlaylistVarBool( "patch_waiting_area", false )
	flowstateSettings.ReloadTacticalOnRespawn 				= GetCurrentPlaylistVarBool( "flowstateReloadTacticalOnRespawn", false )
	flowstateSettings.ReloadUltimateOnRespawn 				= GetCurrentPlaylistVarBool( "flowstateReloadUltimateOnRespawn", false )
	flowstateSettings.RandomHaloGuns 						= GetCurrentPlaylistVarBool( "flowstateRandomHaloGuns", false )
	flowstateSettings.DroppodsOnPlayerConnected 			= GetCurrentPlaylistVarBool( "flowstateDroppodsOnPlayerConnected", false )
	flowstateSettings.EndlessFFAorTDM 						= GetCurrentPlaylistVarBool( "flowstateEndlessFFAorTDM", false )
	flowstateSettings.endgame_delay 						= GetCurrentPlaylistVarInt( "endgame_delay", 8 )
	flowstateSettings.enable_global_chat 					= GetCurrentPlaylistVarBool( "enable_global_chat", true)
	flowstateSettings.allow_cfgs 							= GetCurrentPlaylistVarBool( "flowstate_allow_cfgs", false )					
	flowstateSettings.give_random_custom_models_toall		= GetCurrentPlaylistVarBool( "flowstate_give_random_custom_models_toall", false )
	flowstateSettings.show_short_champion_screen			= GetCurrentPlaylistVarBool( "show_short_champion_screen", true )
}

void function ResetLoadedWeapons( entity player )
{
	ClientCommand_ResetSavedWeapons( player, [] )
}

array<string> function ReturnChatArray()
{
	return file.allChatLines
}

int function GetCurrentRound() 
{ 
    return file.currentRound;
}


void function RotateMap()
{
	string to_map = GetMapName()
	
	array<string> maplist = split( flowstateSettings.maplist, "," )
	
	int countmaps = maplist.len()
	int i;

	if( countmaps > 0 )
	{
		for ( i = 0; i < countmaps; i++ ) 
		{
			if ( GetMapName() == maplist[i] ) 
			{
				int index = (i + 1) % countmaps	
				to_map = maplist[index]
				break
			}
		}
	}
	
	GameRules_ChangeMap( to_map , GameRules_GetGameMode() )	
}


bool function bIs1v1Mode()
{
	if ( !flowstateSettings.flowstate_1v1mode && !is3v3Mode() )
		return false

	// Commenting this for now as it's returning false for scenarios //that's probably because the map wasn't enabled in playlists? ~mkos

	if( GetCurrentPlaylistMapsCount() == 0 )
		return false

	if( GetPlaylistMaps( GetCurrentPlaylistName() ).contains( GetMapName() ) )
		return true

	return false
}


//Todo: Only enable core logic, then run callbacks registered with AddCallback_FlowstateGamemodeInit()
void function _CustomTDM_Init()
{
	InitializePlaylistSettings() //must be executed first
	file.scriptversion = FLOWSTATE_VERSION
	
	RegisterSignal( "EndScriptedPropsThread" )
	RegisterSignal( "FS_WaitForBlackScreen" )
	RegisterSignal( "FS_ForceDestroyAllLifts" )
	
	flowstateSettings.bIs1v1ModeEnabled = bIs1v1Mode()
	if( flowstateSettings.enable_global_chat )
		SetConVarBool("sv_forceChatToTeamOnly", false) //thanks rexx
	else
		SetConVarBool("sv_forceChatToTeamOnly", true)
	
	try{
	if( flowstateSettings.allow_cfgs ) // if you want to allow cfg abusers
		SetConVarInt( "sv_quota_scriptExecsPerSecond", 20 )
	else
		SetConVarInt( "sv_quota_scriptExecsPerSecond", 4 ) //is 4 acceptable, or wont this allow superglide? ~mkos
	}catch(e)

	if ( !Flowstate_IsMovementGym() )
		SurvivalFreefall_Init() //Enables freefall/skydive
	
	if( !is1v1EnabledAndAllowed() )
	{
		PrecacheCustomMapsProps()
		de_NCanals_precache()
		PrecacheZeesMapProps()
		PrecacheDEAFPSMapProps()
	}
	
	if( flowstateSettings.is_halo_gamemode )
	{
		PrecacheCyberdyne()
		PrecacheLockout()
		PrecacheBeavercreek()
		PrecacheChill()
		if( MapName() == eMaps.mp_flowstate )
		{
			VOTING_PHASE_ENABLE = false
		}
	}

	if( flowstateSettings.enable_oddball_gamemode )
	{
		VOTING_PHASE_ENABLE = false
		SCOREBOARD_ENABLE = false
	}

	if ( Flowstate_IsMovementGym() )
	{
		VOTING_PHASE_ENABLE = false
		SCOREBOARD_ENABLE = false
		PrecacheMovementGymProps()
	}

	if( flowstateSettings.flowstate_1v1mode || FlowState_LockPOI() )
	{
		VOTING_PHASE_ENABLE = false
		SCOREBOARD_ENABLE = true
	}

    __InitAdmins()

    AddCallback_EntitiesDidLoad( DM__OnEntitiesDidLoad )
	

    AddCallback_OnClientConnected( void function(entity player) {
        if (FlowState_SURF())
            _OnPlayerConnectedSURF(player)
        else
			thread _OnPlayerConnected(player)

        UpdatePlayerCounts()		
    })
	
	//Todo: Dissolve items by adding callback in mode init. ~mkos
	// if( !Flowstate_IsDmOddball() && !Flowstate_IsHalomodeOddball() )
		// AddSpawnCallback( "prop_survival", DissolveItem )


	//Todo: Add callback per mode.
    AddCallback_OnPlayerKilled
	(
		void function( entity victim, entity attacker, var damageInfo ) 
		{
			if ( FlowState_SURF() )
			{
				thread _OnPlayerDiedSURF( victim, attacker, damageInfo )
			}
			else if ( !is1v1EnabledAndAllowed() )
			{
				thread _OnPlayerDied( victim, attacker, damageInfo )
			}
		}
	)

	if ( FlowState_SURF() )
	{
		AddClientCommandCallback("next_round", ClientCommand_NextRoundSURF)
	} 
	else
	{
		if( !Flowstate_IsMovementGym() && !Flowstate_IsFS1v1() && !Flowstate_IsLGDuels() ){
			AddClientCommandCallback("spectate", ClientCommand_SpectateEnemies)
		}
		
		AddClientCommandCallback("teambal", ClientCommand_RebalanceTeams)
		AddClientCommandCallback("circlenow", ClientCommand_CircleNow)
		AddClientCommandCallback("god", ClientCommand_God)
		AddClientCommandCallback("ungod", ClientCommand_UnGod)
		AddClientCommandCallback("next_round", ClientCommand_NextRound)

		if( !Flowstate_IsMovementGym() && Playlist() != ePlaylists.fs_scenarios )
			AddClientCommandCallback("tgive", ClientCommand_GiveWeapon)
	}

	//AddClientCommandCallback("say", ClientCommand_Say)
	AddClientCommandCallback("adminlogin", ClientCommand_adminlogin)
	// Used for sending votes from client to server
    AddClientCommandCallback("VoteForMap", ClientCommand_VoteForMap)
	
	if( !FlowState_AdminTgive() && !Flowstate_IsMovementGym()	 )
	{
		AddClientCommandCallback("saveguns", ClientCommand_SaveCurrentWeapons)
		AddClientCommandCallback("saveskills", ClientCommand_Maki_SaveCurSkill)
		AddClientCommandCallback("resetskills", ClientCommand_Maki_ResetSkills)
	}
	
	if( !Flowstate_IsMovementGym() )
	{
		AddClientCommandCallback("resetguns", ClientCommand_ResetSavedWeapons)
	}
	
	if( flowstateSettings.hackersVsPros )
	{
		AddClientCommandCallback("startcameraman", ClientCommand_setspecplayer )
		AddClientCommandCallback("becomepro", ClientCommand_BecomePro )
	}
		
	for(int i = 0; GetCurrentPlaylistVarString("blacklisted_weapon_" + i.tostring(), "~~none~~") != "~~none~~"; i++)
	{
		file.blacklistedWeapons.append(GetCurrentPlaylistVarString("blacklisted_weapon_" + i.tostring(), "~~none~~"))
	}

	for(int i = 0; GetCurrentPlaylistVarString("blacklisted_ability_" + i.tostring(), "~~none~~") != "~~none~~"; i++)
	{
		file.blacklistedAbilities.append(GetCurrentPlaylistVarString("blacklisted_ability_" + i.tostring(), "~~none~~"))
	}

	if( FlowState_SURF() )
	{
		PrecacheModel( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl" )
		PrecacheModel( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl" )

		thread RunSURF()
	}else {
		thread RunTDM()
	}
		
	if( flowstateSettings.enable_oddball_gamemode )
	{
		FsOddballInit()
	}
	
	if( is1v1EnabledAndAllowed() ) //just call Gamemode1v1_Init, and move logic into gamemode1v1_init
	{		
		thread Gamemode1v1_Init( MapName() )
	}
}

void function __OnEntitiesDidLoadCTF()
{
	switch( MapName() )
    {	
		case eMaps.mp_flowstate:
			entity skyboxCamera = GetEnt( "skybox_cam_level" )
			file.ogSkyboxOrigin = skyboxCamera.GetOrigin()
		break
	}
}

void function DM__OnEntitiesDidLoad()
{
	if( Gamemode() == eGamemodes.CUSTOM_CTF && Flowstate_IsHaloMode() )
	{
		__OnEntitiesDidLoadCTF()
		return
	}

	switch( MapName() )
    {
    	case eMaps.mp_rr_canyonlands_staging:
		
    		if( !Flowstate_IsLGDuels() )
    			SpawnMapPropsFR()
    		break

    	case eMaps.mp_rr_arena_composite:
		
			if( flowstateSettings.patch_for_dropoff )
			{	
				Patch_Dropoff()
			} 
			else if( flowstateSettings.patch_waiting_area )
			{
				Patch_Barrier_Dropoff()
			} 

			array<entity> badMovers = GetEntArrayByClass_Expensive( "script_mover" )
			foreach(mover in badMovers)
				if( IsValid(mover) ) mover.Destroy()
			break
		
		case eMaps.mp_rr_aqueduct:
			if( flowstateSettings.patch_waiting_area )
			{
				Patch_Barrier_Overflow()
			} 
			break
		case eMaps.mp_flowstate:
			entity skyboxCamera = GetEnt( "skybox_cam_level" )
			file.ogSkyboxOrigin = skyboxCamera.GetOrigin()
		break
		
		case eMaps.mp_rr_canyonlands_64k_x_64k:

		if( flowstateSettings.is_halo_gamemode )
		{
			MapEditor_CreateRespawnableWeaponRack( <-10998.3535, -14660.9482, 3679.9812> , <0, 140, 0>, "mp_weapon_haloneedler", 0.5 )
			MapEditor_CreateRespawnableWeaponRack( <-8932.25488, -15722.7363, 3679.9812> , <0, 43.8712006, 0>, "mp_weapon_halobattlerifle", 0.5 )
			MapEditor_CreateRespawnableWeaponRack( <-10471.415, -16120.9883, 3679.9812> , <0, -135.00322, 0>, "mp_weapon_haloshotgun", 0.5 )
			MapEditor_CreateRespawnableWeaponRack( <-9103.41895, -15764.1025, 3111.98145> , <0, -44.5195236, 0>, "mp_weapon_halosniperrifle", 0.5 )
			MapEditor_CreateRespawnableWeaponRack( <-10305.9121, -16081.4854, 3111.98145> , <0, 123.199768, 0>, "mp_weapon_halosniperrifle", 0.5 )
			MapEditor_CreateRespawnableWeaponRack( <-10954.4912, -14820.9619, 3111.98145> , <0, 48.7156754, 0>, "mp_weapon_halosniperrifle", 0.5 )
			MapEditor_CreateRespawnableWeaponRack( <-9130.16797, -17664.502, 3106.05249> , <0, 22.4780464, 0>, "mp_weapon_halobattlerifle", 0.5 )
		}
		break
		
		case eMaps.mp_rr_desertlands_64k_x_64k:

		if( flowstateSettings.is_halo_gamemode )
		{
			MapEditor_CreateRespawnableWeaponRack( <11976.0313, 6755.27295, -4351.96875> , <0, 0, 0>, "mp_weapon_haloneedler", 0.5 )
			MapEditor_CreateRespawnableWeaponRack( <11427.2051, 6091.21631, -4351.96875> , <0, 180, 0>, "mp_weapon_halosniperrifle", 0.5 )
			MapEditor_CreateRespawnableWeaponRack( <9623.96094, 5478.40088, -4295.96875> , <0, 180, 0>, "mp_weapon_halosniperrifle", 0.5 )
			MapEditor_CreateRespawnableWeaponRack( <9341.77539, 5247.96094, -3895.96875> , <0, -90, 0>, "mp_weapon_halobattlerifle", 0.5 )
			MapEditor_CreateRespawnableWeaponRack( <9344.03906, 5790.82031, -3695.96875> , <0, 0, 0>, "mp_weapon_haloshotgun", 0.5 )
			MapEditor_CreateRespawnableWeaponRack( <-10954.4912, -14820.9619, 3111.98145> , <0, 45, 0>, "mp_weapon_halobattlerifle", 0.5 )
		}
		break
		case eMaps.mp_rr_party_crasher:

			Patch_Partycrasher_Restarea()
		break
    }
}

void function _RegisterLocation(LocationSettings locationSettings)
{
    file.locationSettings.append(locationSettings)
    file.droplocationSettings.append(locationSettings)
}

LocPair function _GetVotingLocation()
{
    switch( MapName() )
    {
		case eMaps.mp_rr_aqueduct_night:
        case eMaps.mp_rr_aqueduct:
             return NewLocPair(<4885, -4076, 400>, <0, -157, 0>)
        //case "mp_rr_canyonlands_staging":
        //     return NewLocPair(<26794, -6241, -27479>, <0, 0, 0>)
        case eMaps.mp_rr_canyonlands_64k_x_64k:
			return NewLocPair(<-19459, 2127, 18404>, <0, 180, 0>)
		case eMaps.mp_rr_ashs_redemption:
            return NewLocPair(<-20917, 5852, -26741>, <0, -90, 0>)
        case eMaps.mp_rr_canyonlands_mu1:
        case eMaps.mp_rr_canyonlands_mu1_night:
		    return NewLocPair(<-19459, 2127, 18404>, <0, 180, 0>)
        case eMaps.mp_rr_desertlands_64k_x_64k:
        case eMaps.mp_rr_desertlands_64k_x_64k_nx:
			return NewLocPair(<-19459, 2127, 6404>, <0, 180, 0>)
        case eMaps.mp_rr_arena_composite:
            return NewLocPair(<0, 4780, 220>, <0, -90, 0>)
		case eMaps.mp_rr_desertlands_64k_x_64k_tt:
            return NewLocPair(<-25197, -4278, -2138>, <0, -34, 0>)
		case eMaps.mp_rr_arena_skygarden:
			return NewLocPair(<4284.88037, -102.993355, 2671.03125>, <0, -179.447098, 0>)
		case eMaps.mp_rr_party_crasher:
			return NewLocPair(<1729.17407, -3585.65137, 581.736206>, <0, 103.168709, 0>)
		case eMaps.mp_flowstate:
			return NewLocPair(<0,0,0>, <0, -179.447098, 0>)
		case eMaps.mp_rr_olympus_mu1:
			return NewLocPair( <7008.73047, 7627.40234, -4623.99805>, <0,63,0> )
        default:
			mAssert(false, "No voting location for the map!")
    }
    unreachable
}

void function _OnPropDynamicSpawned(entity prop)
{
    file.playerSpawnedProps.append(prop)
}

array<entity> function GetServerPropsInDmFile()
{
	return file.playerSpawnedProps
}

int function GetTDMState()
{
	return file.tdmState
}

const array<int> IGNORE_FSDM_GAMESTATE =
[
	eGamemodes.fs_prophunt
]

void function SetTdmStateToNextRound()
{
	file.tdmState = eTDMState.NEXT_ROUND_NOW

	if( !IGNORE_FSDM_GAMESTATE.contains( Gamemode() )  )
		SetGlobalNetInt( "FSDM_GameState", file.tdmState )
}

void function SetTdmStateToInProgress()
{
	file.tdmState = eTDMState.IN_PROGRESS
	
	if( !IGNORE_FSDM_GAMESTATE.contains( Gamemode() )  )
		SetGlobalNetInt( "FSDM_GameState", file.tdmState )
		
	foreach( callbackFunc in file.tdmStateInProgressCallbacks )
		callbackFunc()
}

void function AddCallback_OnTdmStateEnter_InProgress( void functionref() callbackFunc )
{
	if( file.tdmStateInProgressCallbacks.contains( callbackFunc ) )
		mAssert( false, "Tried to add callbackFunc: " + string( callbackFunc ) + "() but already exists in tdmStateInProgressCallbacks" )

	file.tdmStateInProgressCallbacks.append( callbackFunc )
}

void function Flowstate_ServerSaveChat()
{
	if(file.allChatLines.len() == 0) return
	
	DevTextBufferClear()
	DevTextBufferWrite("=== Flowstate DM server - CHAT #" + GetUnixTimestamp() + " ===\n")
	
	int i = 0
	foreach(line in file.allChatLines)
	{
		DevTextBufferWrite(line + "\n")
		i++
	}

	
	file.allChatLines.clear()
	Warning("[!] CHAT WAS SAVED in /r5reloaded/platform/, CHAT LINES: " + i)
}

void function SetFallTriggersStatus(bool status){
	file.FallTriggersEnabled = status
}

LocPair function _GetAppropriateSpawnLocation(entity player)
{
	switch(GetGameState())
    {
        case eGameState.MapVoting:
			return _GetVotingLocation()
        case eGameState.Playing:

			if(IsFFAGame())
				return Flowstate_GetBestSpawnPointFFA()
			else
				return Flowstate_GetBestSpawnPointFFA() // !FIXME
    }
	return _GetVotingLocation() //this should be unreachable
}

LocPair function Flowstate_GetBestSpawnPointFFA()
{
	if(file.selectedLocation.spawns.len() == 0) return _GetVotingLocation()
	table<LocPair, float> SpawnsAndNearestEnemy = {}

	foreach(spawn in file.selectedLocation.spawns)
    {
		array<float> AllPlayersDistancesForThisSpawnPoint
		foreach(player in GetPlayerArray_Alive())
			AllPlayersDistancesForThisSpawnPoint.append(Distance(player.GetOrigin(), spawn.origin))
		AllPlayersDistancesForThisSpawnPoint.sort()
		SpawnsAndNearestEnemy[spawn] <- AllPlayersDistancesForThisSpawnPoint[0] //grab nearest player distance for each spawn point
	}

	LocPair finalLoc
	float compareDis = -1
	foreach(loc, dis in SpawnsAndNearestEnemy) //calculate the best spawn point which is the one with the furthest enemy of the nearest
	{
		if(dis > compareDis)
		{
			finalLoc = loc
			compareDis = dis
		}
	}
    return finalLoc
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
            minDist = dist ; enemyOrigin = player.GetOrigin()
    }

    return enemyOrigin
}

void function DestroyPlayerProps()
{
	Signal(svGlobal.levelEnt, "EndScriptedPropsThread")

    foreach(prop in file.playerSpawnedProps)
    {
        if(IsValid(prop))
            prop.Destroy()
    }
    file.playerSpawnedProps.clear()
}

void function HaloMod_Cyberdyne_CreateFanPusher(vector origin, vector angles2)
{
	EndSignal(svGlobal.levelEnt, "EndScriptedPropsThread")

	entity rotator = CreateEntity( "script_mover_lightweight" )
	{
		rotator.kv.solid = SOLID_VPHYSICS
		rotator.SetValueForModelKey( $"mdl/dev/empty_model.rmdl" )
		rotator.kv.fadedist = -1
		rotator.kv.SpawnAsPhysicsMover = 0
		rotator.e.isDoorBlocker = true
		rotator.SetOrigin(origin)
		rotator.SetAngles(angles2)
		rotator.SetScriptName("FanPusher")
		DispatchSpawn( rotator )
		file.playerSpawnedProps.append(rotator)
	}
	
	EmitSoundOnEntity(rotator, "HoverTank_Emit_EdgeWind")
	
	//Wind column effect, two so we complete a cylinder-like shape
	entity fx = StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( $"P_s2s_flap_wind" ), origin, Vector( angles2.x, 0, angles2.y ) )
	fx.SetParent(rotator)

	entity fx2 = StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( $"P_s2s_flap_wind" ), origin, Vector( angles2.x, 90, angles2.y ) )
	fx2.SetParent(rotator)
}

void function DissolveItem( entity prop )
{
	thread
	(
		void function( entity prop )
		{
			if( !IsValid( prop ) )
				return

			if( !flowstateSettings.is_halo_gamemode )
			{
				wait 4
			} else
				WaitFrame()

			if( !IsValid( prop ) )
				return

			entity par = prop.GetParent()

			if( IsValid( par ) && par.GetClassName() == "prop_physics" )
				prop.Dissolve( ENTITY_DISSOLVE_CORE, <0,0,0>, 200 )
		}
	)( prop )
}

void function _OnPlayerConnected(entity player)
{
	float startTime = Time()
	
	while( IsDisconnected( player ) ) //defensive break
	{
		WaitFrame()
		
		if( Time() - startTime >= 3 )
		{
			#if DEVELOPER 
				Warning( "PLAYER DISCONNECTED BREAK LOOP" )
			#endif
			break
		}
	}

    if ( !IsValid( player ) ) 
		return

	if( flowstateSettings.hackersVsPros )
	{
		AssignCharacter(player, characterslist.getrandom())
	}

	if( MapName() == eMaps.mp_rr_aqueduct )
	{
	    CreatePanelText( player, "Flowstate", "", <3705.10547, -4487.96484, 470.03302>, <0, 190, 0>, false, 2 )
	    CreatePanelText( player, "Flowstate", "", <1111.36584, -5447.26221, 655.479858>, <0, -90, 0>, false, 2 )
	}

	player.p.lastTgiveUsedTime = Time()
	player.p.lastRestUsedTime = Time()
	
	// if(FlowState_RandomGunsEverydie())
	    // Message(player, "FLOWSTATE: FIESTA", "Type 'commands' in console to see the available console commands. ", 10)
	// else if (FlowState_Gungame())
	    // Message(player, "FLOWSTATE: GUNGAME", "Type 'commands' in console to see the available console commands. ", 10)
	// else 
	if (FlowState_EnableMovementGym())
	{
	    _MG_OnPlayerConnected( player )
		_HandleRespawn(player)
		return
	} 
	// else
	    // Message(player, "FLOWSTATE: DM", "Type 'commands' in console to see the available console commands. ", 10)

	if(IsValid(player))
	{
		switch(GetGameState())
		{
			case eGameState.MapVoting:
			    {
			    	// if(!IsAlive(player))
			    	// {
			    		// _HandleRespawn(player)
			    		// ClearInvincible(player)
			    	// }

			    	// player.SetThirdPersonShoulderModeOn()

			    	// if(FlowState_RandomGunsEverydie())
			    		// UpgradeShields(player, true)

			    	// // if(FlowState_Gungame())
			    		// // KillStreakAnnouncer(player, true)

			    	// player.UnforceStand()
			    	player.FreezeControlsOnServer()
			    }
			break
			case eGameState.WaitingForPlayers:
				{
					// _HandleRespawn(player)
					// ClearInvincible(player)
					player.FreezeControlsOnServer()
				}
			break
			case eGameState.Playing:
				{
					player.UnfreezeControlsOnServer()
					
					if( file.tdmState == eTDMState.NEXT_ROUND_NOW )
						break

					_HandleRespawn(player)

                    array<string> InValidMaps = [
						"mp_rr_canyonlands_staging",
						"Skill trainer By CafeFPS",
						"Custom map by Biscutz",
						"White Forest By Zer0Bytes",
						"Brightwater By Zer0bytes",
						"Overflow",
						"Drop-Off"
					]

					bool DropPodOnSpawn = flowstateSettings.DroppodsOnPlayerConnected
					bool IsStaging = InValidMaps.find( GetMapName() ) != -1
					bool IsMapValid = InValidMaps.find(file.selectedLocation.name) != -1
					if(file.tdmState == eTDMState.NEXT_ROUND_NOW || !DropPodOnSpawn || IsStaging || IsMapValid )
						_HandleRespawn(player)
					else
					{
						if(file.thisroundDroppodSpawns.len() > 0){
							player.p.isPlayerSpawningInDroppod = true
							thread AirDropFireteam( file.thisroundDroppodSpawns[RandomIntRangeInclusive(0, file.thisroundDroppodSpawns.len()-1)] + <0,0,15000>, <0,180,0>, "idle", 0, "droppod_fireteam", player )
							_HandleRespawn(player, true)
							player.SetAngles( <0,180,0> )
						}
						else
							_HandleRespawn(player)
					}

					ClearInvincible(player)
					if(FlowState_RandomGunsEverydie())
						UpgradeShields(player, true)

					// if(FlowState_Gungame())
						// KillStreakAnnouncer(player, true)
					if( flowstateSettings.hackersVsPros )
					{
						SetTeam(player, TEAM_IMC)
						BecomeHacker(player)
						
						thread function() : (player)
						{
							wait 12
							if(!IsValid(player) || player.GetTeam() != TEAM_IMC) return
							Message(player, "HACKERS VS PROS", "You're a Hacker")
						}()
					}
					
					if( file.selectedLocation.name == "Lockout" )
					{
						Remote_CallFunction_Replay(player, "FS_ForceAdjustSunFlareParticleOnClient", 0 )
					} else if( file.selectedLocation.name == "The Pit" )
					{
						Remote_CallFunction_Replay(player, "FS_ForceAdjustSunFlareParticleOnClient", 1 )
					} else if( file.selectedLocation.name == "Narrows" )
					{
						Remote_CallFunction_Replay(player, "FS_ForceAdjustSunFlareParticleOnClient", 2 )
					}
					
					if( MapName() == eMaps.mp_flowstate )
					{
						//Remote_CallFunction_NonReplay(player, "Minimap_DisableDraw_Internal")
						Remote_CallFunction_ByRef( player, "Minimap_DisableDraw_Internal" )
					}
					
				}
				break
			default:
				break
		}
	}

	if( !flowstateSettings.hackersVsPros )
		thread __HighPingCheck( player )
	
	if( flowstateSettings.enable_afk_thread )
	{
		thread Flowstate_InitAFKThreadForPlayer(player)
	}

	if( Playlist() == ePlaylists.fs_vamp_1v1 )
	{
		AddEntityCallback_OnDamaged( player, Vamp_OnPlayerDamaged )
		AddCallback_OnWeaponAttack( Vamp_OnWeaponAttack )
	}

	if( Flowstate_IsFastInstaGib() )
	{
		AddEntityCallback_OnDamaged( player, FS_Instagib_OnPlayerDamaged )
	}	
	
	if( Flowstate_IsHaloMode() )
	{
		AddEntityCallback_OnKilled
		(
			player,
			void function( entity player, var damageInfo )
			{
				if( !IsValid( player ) )
					return 
					
				entity attacker = InflictorOwner( DamageInfo_GetAttacker( damageInfo ) )
				
				if ( IsValid( attacker ) && attacker.IsPlayer() && IsAlive( attacker ) )
					ReloadTactical( attacker )
			}
		)
	}
	
	if( is1v1EnabledAndAllowed() )
	{
		thread soloModefixDelayStart( player )
	}
}

bool function is1v1EnabledAndAllowed()
{
	return flowstateSettings.bIs1v1ModeEnabled
}

void function __HighPingCheck(entity player)
{
	wait 12 //latency is always high when connecting?
	
    if( !IsValid(player) || IsValid(player) && IsAdmin(player) ) return

	if( flowstateSettings.enable_ping_kick && FlowState_KickHighPingPlayer() && (int(player.GetLatency()* 1000) - 40) > FlowState_MaxPingAllowed() )
	{
		player.FreezeControlsOnServer()
		player.ForceStand()
		HolsterAndDisableWeapons( player )
		
		//TODO: LocalVarMsg()
		//Message(player, "FLOWSTATE KICK", "Admin has enabled a ping limit: " + FlowState_MaxPingAllowed() + " ms. \n Your ping is too high: " + (int(player.GetLatency()* 1000) - 40) + " ms.", 3)
		LocalVarMsg( player, "#FS_AFK_KICK", eMsgUI.VAR_EVENT, 5, FlowState_MaxPingAllowed(), (int(player.GetLatency()* 1000) - 40)  )
		
		wait 5

		if ( !IsValid( player ) ) return
		Warning("[Flowstate] -> Kicking " + player.GetPlayerName() + ":" + player.GetPlatformUID() + " -> [High Ping!]")
		KickPlayerById( player.GetPlatformUID(), "Your ping is too high for admin limit" )
		UpdatePlayerCounts()
	}
	// else if( GameRules_GetGameMode() == "fs_dm" && !flowstateSettings.is_halo_gamemode ){
		// Message(player, "FLOWSTATE", "Your latency: " + (int(player.GetLatency()* 1000) - 40) + " ms." , 5)
	// }
}

void function Flowstate_AppendBattleLogEvent(entity killer, entity victim)
{	
	if (!IsValid(killer) || !IsValid(victim)) return
	if (!killer.IsPlayer() || !victim.IsPlayer()) return
	string killer_name = killer.GetPlayerName()
	string victim_name = victim.GetPlayerName()
	
	string attackerweapon1 = "null"
	string attackerweapon2 = "null"
	string victimweapon1 = "null"
	string victimweapon2 = "null"

	float aim_assist_value = flowstateSettings.aimassist_magnet_pc

	//string attacker_origin_id = killer.GetPlatformUID()
	
	string flowstate_gamemode = "fs_dm"
	if( is1v1EnabledAndAllowed() )
		flowstate_gamemode = "fs_1v1"
	
	if(IsValid(killer.GetLatestPrimaryWeapon( eActiveInventorySlot.mainHand )))
		attackerweapon1 = killer.GetLatestPrimaryWeapon( eActiveInventorySlot.mainHand ).GetWeaponClassName()
	
	if(IsValid(killer.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 )) && attackerweapon1 == killer.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 ).GetWeaponClassName() && IsValid(killer.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_1 )))
		attackerweapon2 = killer.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_1 ).GetWeaponClassName()
	else if(IsValid(killer.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_1 )) && attackerweapon1 == killer.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_1 ).GetWeaponClassName() && IsValid(killer.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 )))
		attackerweapon2 = killer.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 ).GetWeaponClassName()
	
	if(IsValid(victim.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 )))
		victimweapon1 = victim.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 ).GetWeaponClassName()
	
	if(IsValid(victim.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_1 )))
		victimweapon2 = victim.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_1 ).GetWeaponClassName()
	
	string is_controller_dog = killer.p.AmIController.tostring()
	if (!(killer_name.len()>0) || !(victim_name.len()>0) || !(is_controller_dog.len()>0)) return

	string log = killer_name +"&&"+
	victim_name+"&&"+
	attackerweapon1+"&&"+
	attackerweapon2+"&&"+
	victimweapon1+"&&"+
	victimweapon2+"&&"+
	GetUnixTimestamp().tostring()+"&&"+
	is_controller_dog+"&&"+
	aim_assist_value.tostring()+"&&"+
	flowstate_gamemode
	//+"&&"+
	//attacker_origin_id

	file.battlelog.append(log)
}

void function Flowstate_SaveBattleLogToFile()
{
	if(file.battlelog.len() == 0) return
	
	string to_save = ""
	
	foreach(log in file.battlelog)
		to_save += log + "\n"

	DevTextBufferClear()
	DevTextBufferWrite(to_save)
	DevP4Checkout( "Flowstate_BattleLog_" + GetUnixTimestamp() + ".txt" )
	DevTextBufferDumpToFile( "FlowstateDM_BattleLog/Flowstate_BattleLog_" + GetUnixTimestamp() + ".txt" )
	
	Warning("[Flowstate] -> Match log saved! Events: " + file.battlelog.len())
	
	file.battlelog.clear()
}

void function Flowstate_SaveBattleLogToFile_Linux() //Use parser
{
	if(file.battlelog.len() == 0) return

	foreach(log in file.battlelog)
		printt(" [BattleLog] " + log)
		
	printt("[Flowstate] -> Match log saved! Events: " + file.battlelog.len())
	
	file.battlelog.clear()
}

void function _OnPlayerDied(entity victim, entity attacker, var damageInfo)
{
	if (FlowState_RandomGunsEverydie() && FlowState_FIESTADeathboxes())
		CreateFlowStateDeathBoxForPlayer(victim, attacker, damageInfo)

	if( victim.p.isSpectating )
		return

	if( flowstateSettings.BattleLogEnable && victim != attacker)
		Flowstate_AppendBattleLogEvent(attacker, victim)

	switch(GetGameState())
    {
        case eGameState.Playing:
            // Víctim
            void functionref() victimHandleFunc = void function() : (victim, attacker, damageInfo) 
			{
				
				Remote_CallFunction_NonReplay( victim, "ForceScoreboardLoseFocus" )

				if( GetCurrentPlaylistVarBool( "is_halo_gamemode", false ) )
				{
					Remote_CallFunction_NonReplay( victim, "FS_ForceDestroyCustomAdsOverlay" )
				}

				entity weapon = victim.GetActiveWeapon( eActiveInventorySlot.mainHand )
				
				if( IsValid( weapon ) && weapon.w.isInAdsCustom )
				{
					weapon.w.isInAdsCustom = false
				}

				if( Flowstate_IsFastInstaGib() )
					victim.Gib( <0,0,100> )

				wait DEATHCAM_TIME_SHORT

				if( file.tdmState == eTDMState.NEXT_ROUND_NOW )
					return

				if( !IsValid(victim) )
					return
				
				if ( !Flowstate_IsLGDuels() )
				{
					if( victim == file.previousChallenger && victim != GetKillLeader() && victim != GetChampion() )
						PlayAnnounce( "diag_ap_aiNotify_challengerEliminated_01" )
				}
			
	    		if( victim == attacker || !IsValid(attacker))
				{
					thread function () : ( victim )
					{
						if( !Flowstate_IsFastInstaGib() )
							wait Deathmatch_GetRespawnDelay()
						else
							wait 1
						
						if(file.tdmState != eTDMState.IN_PROGRESS || !IsValid( victim ) )
							return

						_HandleRespawn( victim )
						ClearInvincible(victim)
					}()
					return
				}

	    		if(file.tdmState != eTDMState.NEXT_ROUND_NOW && IsValid(victim) && IsValid(attacker) && Spectator_GetReplayIsEnabled() && ShouldSetObserverTarget( attacker ) && attacker.IsPlayer() && !Flowstate_IsFastInstaGib() )
				{
					victim.FreezeControlsOnServer()
	    			victim.SetObserverTarget( attacker )
	    			victim.SetSpecReplayDelay( 2 + DEATHCAM_TIME_SHORT )
	    			victim.StartObserverMode( OBS_MODE_IN_EYE )
	    			//Remote_CallFunction_NonReplay(victim, "ServerCallback_KillReplayHud_Activate")
					Remote_CallFunction_ByRef( victim, "ServerCallback_KillReplayHud_Activate" )
					thread CheckForObservedTarget(victim)
	    		}

				if(FlowState_RandomGunsEverydie())
	    		    UpgradeShields(victim, true)

	    		//if(FlowState_Gungame())
	    		    //KillStreakAnnouncer(victim, true)

	    		if( file.tdmState != eTDMState.NEXT_ROUND_NOW && ShouldSetObserverTarget( attacker ) )
				{
					if( !Flowstate_IsFastInstaGib() )
						wait Deathmatch_GetRespawnDelay()
					else
						wait 1
				}
				
				if( !IsValid( victim ) ) return
				
				if( !IsAlive( victim ) )
					_HandleRespawn( victim )
				
				ClearInvincible( victim )
	    	}

            // Attacker
            void functionref() attackerHandleFunc = void function() : (victim, attacker, damageInfo)
	    	{
	    		if(IsValid(attacker) && attacker.IsPlayer() && IsAlive(attacker) && attacker != victim)
                {
	    			//Heal
	    			if(FlowState_RandomGunsEverydie() && FlowState_FIESTAShieldsStreak())
					{
	    			    PlayerRestoreHPFIESTA(attacker, 100)
	    			    UpgradeShields(attacker, false)
	    			} else 
					{
						PlayerRestoreHP(attacker, 100, Equipment_GetDefaultShieldHP())
					}

	    			if(FlowState_KillshotEnabled())
					{
	    			    DamageInfo_AddCustomDamageType( damageInfo, DF_KILLSHOT )
	    			    thread EmitSoundOnEntityOnlyToPlayer( attacker, attacker, "flesh_bulletimpact_downedshot_1p_vs_3p" )
	    			}

	    			if(FlowState_Gungame())
	    			{
	    			    GiveGungameWeapon(attacker)
	    			    //KillStreakAnnouncer(attacker, false)
	    			}

	    			WpnAutoReloadOnKill(attacker)
	    			GameRules_SetTeamScore(attacker.GetTeam(), GameRules_GetTeamScore(attacker.GetTeam()) + 1)
					
					//lg_duel mkos
					if ( !Flowstate_IsLGDuels() )
					{
						if( attacker == GetChampion() )
							PlayerKillStreakAnnounce( attacker, "diag_ap_aiNotify_championDoubleKill_01", "diag_ap_aiNotify_championTripleKill_01" )
						
						if( attacker == GetKillLeader() )
							PlayerKillStreakAnnounce( attacker, "diag_ap_aiNotify_killLeaderDoubleKill_01", "diag_ap_aiNotify_killLeaderTripleKill_01" )
	
						if( attacker == file.previousChallenger )
							PlayerKillStreakAnnounce( attacker, "diag_ap_aiNotify_challengerDoubleKill_01", "diag_ap_aiNotify_challengerTripleKill_01" )
						
					}
	
					if( flowstateSettings.is_halo_gamemode )
						HisWattsons_HaloModFFA_KillStreakAnnounce( attacker )
				}
            }
	    	thread victimHandleFunc()
            thread attackerHandleFunc()
        break
        default:
	    	_HandleRespawn(victim)
	    break

	}
	
	UpdatePlayerCounts()
}

void function PlayerKillStreakAnnounce( entity attacker, string doubleKill, string tripleKill )
{
	if( flowstateSettings.is_halo_gamemode )
		return

	if( Time() == attacker.p.lastDownedEnemyTime )
		return

	if( Time() - attacker.p.lastDownedEnemyTime >= KILLLEADER_STREAK_ANNOUNCE_TIME )
		attacker.p.downedEnemy = 0

	attacker.p.downedEnemy++
	
	if ( Time() - attacker.p.lastDownedEnemyTime <= KILLLEADER_STREAK_ANNOUNCE_TIME )
	{
		string announce
		switch( attacker.p.downedEnemy )
		{
			case 2:
				announce = doubleKill
				break
			
			case 3:
				announce = tripleKill
				break
		}

		PlayAnnounce( announce )
	}

	attacker.p.lastDownedEnemyTime = Time()
}

void function CheckForObservedTarget(entity player)
{
	OnThreadEnd(
		function() : ( player )
		{
			if( !IsValid(player) ) return
			
			if(IsValid(player.p.lastFrameObservedTarget))
			{
				player.p.lastFrameObservedTarget.SetPlayerNetInt( "playerObservedCount", max(0, player.p.lastFrameObservedTarget.GetPlayerNetInt( "playerObservedCount" ) - 1) )
				player.p.lastFrameObservedTarget = null
			}
			
			if(!IsValid( player.GetObserverTarget() ) && GetGameState() == eGameState.Playing )
			{
				player.p.isSpectating = false
				player.SetPlayerNetInt( "spectatorTargetCount", 0 )
				player.SetSpecReplayDelay( 0 )
				player.SetObserverTarget( null )
				player.StopObserverMode()
				player.p.lastTimeSpectateUsed = Time()
				_HandleRespawn( player )
			}
		}
	)
	
	entity observerTarget
	while(IsValid(player) && player.IsObserver() && IsValid( player.GetObserverTarget() ) )
	{		
		observerTarget = player.GetObserverTarget()
		if(observerTarget != player.p.lastFrameObservedTarget)
		{
			if(IsValid(player.p.lastFrameObservedTarget))
				player.p.lastFrameObservedTarget.SetPlayerNetInt( "playerObservedCount", max(0, player.p.lastFrameObservedTarget.GetPlayerNetInt( "playerObservedCount" ) - 1) )
			
			if(IsValid(observerTarget))
				observerTarget.SetPlayerNetInt( "playerObservedCount", observerTarget.GetPlayerNetInt( "playerObservedCount" ) + 1 )
		}
		player.p.lastFrameObservedTarget = player.GetObserverTarget()
		WaitFrame()
	}
}

//Todo: Unweave mode specific logic, set each mode to it's own handlerespawn func ~mkos
void function _HandleRespawn( entity player, bool isDroppodSpawn = false )
{
    if ( !IsValid( player ) || !player.IsPlayer() ) 
		return

	if( player.p.isSpectating )
		return

	if( player.IsObserver() )
    {
		player.SetSpecReplayDelay( 0 )
		player.SetObserverTarget( null )
		player.StopObserverMode()
        Remote_CallFunction_ByRef( player, "ServerCallback_KillReplayHud_Deactivate" )
		//Remote_CallFunction_NonReplay(player, "ServerCallback_KillReplayHud_Deactivate")
    }

	if( MapName() == eMaps.mp_flowstate )
		//Remote_CallFunction_NonReplay(player, "Minimap_DisableDraw_Internal")
		Remote_CallFunction_ByRef( player, "Minimap_DisableDraw_Internal" )
	else
		Remote_CallFunction_ByRef( player, "Minimap_EnableDraw_Internal" )
		//Remote_CallFunction_NonReplay(player, "Minimap_EnableDraw_Internal")

	if( flowstateSettings.ForceCharacter && !player.GetPlayerNetBool( "hasLockedInCharacter" ) || flowstateSettings.is_halo_gamemode )
	{
		CharSelect( player )
		player.SetPlayerNetBool( "hasLockedInCharacter", true )
	}

	if( !IsAlive( player ) )
    {
		if( flowstateSettings.RandomCharacterOnSpawn && !flowstateSettings.ForceCharacter && !player.GetPlayerNetBool( "hasLockedInCharacter" ) )
		{
			GivePlayerRandomCharacter( player )
			player.SetPlayerNetBool( "hasLockedInCharacter", true)
		}

        if( Equipment_GetRespawnKitEnabled() && !FlowState_Gungame() )
        {
			DecideRespawnPlayer( player, true )
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
                if( storedWeapon.weaponType == eStoredWeaponType.main)
					try{
					entity givenWeapon = player.GiveWeapon( storedWeapon.name, storedWeapon.inventoryIndex, storedWeapon.mods )
					SetupInfiniteAmmoForWeapon( player, givenWeapon )
					}catch(e420){}
                else
					try{
                    player.GiveOffhandWeapon( storedWeapon.name, storedWeapon.inventoryIndex, storedWeapon.mods )
					}catch(e420){}
            }
		}
        else
        {
            if( !player.p.storedWeapons.len() )
				DecideRespawnPlayer( player, true )
            else
            {
				DecideRespawnPlayer( player, false )
                GiveWeaponsFromStoredArray( player, player.p.storedWeapons )
            }	
        }
    }

	if( IsValid( player ) && IsAlive( player ) )
	{
		if( !isDroppodSpawn && !is1v1EnabledAndAllowed() )
		    TpPlayerToSpawnPoint(player)
		
		player.UnfreezeControlsOnServer()

		if(FlowState_RandomGunsEverydie() && FlowState_FIESTAShieldsStreak())
		{
			PlayerRestoreShieldsFIESTA(player, player.GetShieldHealthMax())
			PlayerRestoreHPFIESTA(player, 100)
		} 
		else if( Playlist() != ePlaylists.fs_scenarios )
		{
			player.SetShieldHealth( 0 )
			player.SetShieldHealthMax( 0 )
			Inventory_SetPlayerEquipment(player, "", "armor")
			
			thread function () : ( player )
			{
				EndSignal( player, "OnDestroy" )
				EndSignal( player, "OnDeath" )

				WaitFrame()

				player.SetShieldHealthMax( Equipment_GetDefaultShieldHP() )

				PlayerRestoreHP(player, 100, Equipment_GetDefaultShieldHP())
			}()
		}

		try{
			player.TakeNormalWeaponByIndexNow( WEAPON_INVENTORY_SLOT_PRIMARY_2 )
			player.TakeOffhandWeapon( OFFHAND_MELEE )
			
			// player.GiveWeapon( "mp_weapon_melee_survival", WEAPON_INVENTORY_SLOT_PRIMARY_2, [] )
			// player.GiveOffhandWeapon( "melee_pilot_emptyhanded", OFFHAND_MELEE, [] )

			if( flowstateSettings.is_halo_gamemode )
			{
				player.GiveWeapon( "mp_weapon_melee_halo", WEAPON_INVENTORY_SLOT_PRIMARY_2, [] )
				player.GiveOffhandWeapon( "melee_pilot_emptyhanded_halo", OFFHAND_MELEE, [] )
			}else
			{
				player.GiveWeapon( "mp_weapon_melee_survival", WEAPON_INVENTORY_SLOT_PRIMARY_2, [] )
				player.GiveOffhandWeapon( "melee_pilot_emptyhanded", OFFHAND_MELEE, [] )
			}
		}catch(e420){
		//AttachEdict rare crash
		}

		if( flowstateSettings.GiveAllOpticsToPlayer )
		{
			SetPlayerInventory( player, [] )
			Inventory_SetPlayerEquipment(player, "backpack_pickup_lv3", "backpack")
			array<string> optics = ["optic_cq_hcog_classic", "optic_cq_hcog_bruiser", "optic_cq_holosight", "optic_cq_threat", "optic_cq_holosight_variable", "optic_ranged_hcog", "optic_ranged_aog_variable", "optic_sniper_variable", "optic_sniper_threat"]
			foreach(optic in optics)
				SURVIVAL_AddToPlayerInventory(player, optic)
		}
	}

	if( flowstateSettings.is_halo_gamemode && IsValid( player ))
	{
		try{
		    player.TakeNormalWeaponByIndexNow( WEAPON_INVENTORY_SLOT_PRIMARY_0 )
            player.TakeNormalWeaponByIndexNow( WEAPON_INVENTORY_SLOT_PRIMARY_1 )

			GiveRandomPrimaryWeaponHalo(player)
			GiveRandomSecondaryWeaponHalo(player)
		} catch (e420) {}
	} 
	else if (FlowState_RandomGuns() && !FlowState_Gungame() && IsValid( player ))
    {
		try{
		    player.TakeNormalWeaponByIndexNow( WEAPON_INVENTORY_SLOT_PRIMARY_0 )
            player.TakeNormalWeaponByIndexNow( WEAPON_INVENTORY_SLOT_PRIMARY_1 )
		    player.TakeNormalWeaponByIndexNow( WEAPON_INVENTORY_SLOT_PRIMARY_2 )

			GiveRandomPrimaryWeapon(player)
			GiveRandomSecondaryWeapon(player)

            player.GiveWeapon( "mp_weapon_melee_survival", WEAPON_INVENTORY_SLOT_PRIMARY_2, [] )
            player.GiveOffhandWeapon( "melee_pilot_emptyhanded", OFFHAND_MELEE, [] )
		} catch (e420) {}
    }
	else if(FlowState_RandomGunsMetagame() && !FlowState_Gungame() && IsValid( player ))
	{
		try{
		    player.TakeNormalWeaponByIndexNow( WEAPON_INVENTORY_SLOT_PRIMARY_0 )
            player.TakeNormalWeaponByIndexNow( WEAPON_INVENTORY_SLOT_PRIMARY_1 )
		    player.TakeNormalWeaponByIndexNow( WEAPON_INVENTORY_SLOT_PRIMARY_2 )
			GiveRandomPrimaryWeaponMetagame(player)
			GiveRandomSecondaryWeaponMetagame(player)

            player.GiveWeapon( "mp_weapon_melee_survival", WEAPON_INVENTORY_SLOT_PRIMARY_2, [] )
            player.GiveOffhandWeapon( "melee_pilot_emptyhandede", OFFHAND_MELEE, [] )
		} catch (e420) {}
	}

	//wtf is this expression
	if( IsValid( player ) || FlowState_GungameRandomAbilities() && IsValid( player ))
	{
		if(FlowState_RandomTactical())
		{
			player.TakeOffhandWeapon(OFFHAND_TACTICAL)
			GiveRandomTac(player)
		}

		if(FlowState_RandomUltimate())
		{
			player.TakeOffhandWeapon(OFFHAND_ULTIMATE)
			GiveRandomUlt(player)
		}

	}

	if(FlowState_RandomGunsEverydie() && !FlowState_Gungame() && IsValid( player )) //fiesta
    {
		try{
		TakeAllWeapons(player)
        GiveRandomPrimaryWeapon(player)
        GiveRandomSecondaryWeapon( player)
        GiveRandomTac(player)
        GiveRandomUlt(player)
        player.GiveWeapon( "mp_weapon_melee_survival", WEAPON_INVENTORY_SLOT_PRIMARY_2, [] )
        player.GiveOffhandWeapon( "melee_pilot_emptyhanded", OFFHAND_MELEE, [] )
		}catch(e420){}
    } else if(FlowState_Gungame() && IsValid( player ))
		GiveGungameWeapon(player)

	if( flowstateSettings.hackersVsPros  )
	{
		TakeAllWeapons(player)
		GiveRandomPrimaryWeaponMetagame(player)
		GiveRandomSecondaryWeaponMetagame(player)	
		// player.GiveWeapon( "mp_weapon_melee_survival", WEAPON_INVENTORY_SLOT_PRIMARY_2, [] )
		// player.GiveOffhandWeapon( "melee_pilot_emptyhanded", OFFHAND_MELEE, [] )
		player.GiveWeapon( "mp_weapon_melee_survival", WEAPON_INVENTORY_SLOT_PRIMARY_2, [] )
		player.GiveOffhandWeapon( "melee_pilot_emptyhanded", OFFHAND_MELEE, [] )

		entity tactical = player.GetOffhandWeapon( OFFHAND_TACTICAL )
		
		if( IsValid( tactical ) ) 
			player.TakeOffhandWeapon( OFFHAND_TACTICAL )
		
		entity ultimate = player.GetOffhandWeapon( OFFHAND_ULTIMATE )
		
		if( IsValid( ultimate ) ) 
			player.TakeOffhandWeapon( OFFHAND_ULTIMATE )
		
		player.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL, [])
		
	}
	
	if( !player.HasPassive( ePassives.PAS_PILOT_BLOOD ) && 
		!Flowstate_IsFS1v1() && 
		!Flowstate_IsLGDuels() && 
		!Flowstate_IsFastInstaGib() )
	{
		GivePassive(player, ePassives.PAS_PILOT_BLOOD)
	}

	//allow healing items to be used	
	player.TakeOffhandWeapon( OFFHAND_SLOT_FOR_CONSUMABLES )
	player.GiveOffhandWeapon( CONSUMABLE_WEAPON_NAME, OFFHAND_SLOT_FOR_CONSUMABLES, [] )
	
	//give flowstate holo sprays
	player.TakeOffhandWeapon( OFFHAND_EQUIPMENT )
	player.GiveOffhandWeapon( "mp_ability_emote_projector", OFFHAND_EQUIPMENT )
	
	Survival_SetInventoryEnabled( player, true )
	SetPlayerInventory( player, [] )

	Inventory_SetPlayerEquipment( player, "backpack_pickup_lv3", "backpack")	

	if( Flowstate_IsFSDM() || flowstateSettings.is_halo_gamemode )
	{
		array<string> loot = ["mp_weapon_frag_grenade", "mp_weapon_grenade_emp", "health_pickup_combo_small", "health_pickup_combo_large", "health_pickup_health_small", "health_pickup_health_large", "health_pickup_combo_full"]
			foreach(item in loot)
				SURVIVAL_AddToPlayerInventory(player, item)

		SwitchPlayerToOrdnance( player, "mp_weapon_frag_grenade" )
		Remote_CallFunction_NonReplay( player, "ServerCallback_RefreshInventoryAndWeaponInfo" )
	}

	thread Flowstate_GrantSpawnImmunity(player, 2.5)

	if( !flowstateSettings.is_halo_gamemode )
	{
		WpnPulloutOnRespawn(player, 0)
		thread LoadCustomWeapon(player)		///TDM Auto-Reloaded Saved Weapons at Respawn
		//maki script
		thread LoadCustomSkill(player)	
		//maki script
	} else
		HaloMod_HandlePlayerModel( player )

	{
		player.ClearFirstDeployForAllWeapons()

		entity primary = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 )
		entity secondary = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_1 )

		if(IsValid(secondary) && secondary.UsesClipsForAmmo())
		{
			//secondary.DeployInstant()
			secondary.SetWeaponPrimaryClipCount( secondary.GetWeaponPrimaryClipCountMax())
			
		}
		
		if(IsValid(primary) && primary.UsesClipsForAmmo())
		{
			//primary.DeployInstant()
			primary.SetWeaponPrimaryClipCount(primary.GetWeaponPrimaryClipCountMax())
			player.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_0)
		}
	}
	
		
	if( FlowState_ChosenCharacter() > 10 && !flowstateSettings.give_random_custom_models_toall )
	{
		SetPlayerCustomModel( player, FlowState_ChosenCharacter() )
	} 

	if( Flowstate_IsFastInstaGib() )
		FS_Instagib_PlayerSpawn( player )
		
	#if DEVELOPER
		printt( "End of _HandleRespawn function" )//Cafe debugging halo mod stuff
	#endif
}

void function SetPlayerCustomModel( entity player, int index )
{
	switch( index )
	{
		case 11:
		player.SetBodyModelOverride( $"mdl/Humans/pilots/w_blisk.rmdl" )
		player.SetArmsModelOverride( $"mdl/Humans/pilots/pov_blisk.rmdl" )
		break
		
		case 12:
		player.SetBodyModelOverride( $"mdl/Humans/pilots/w_phantom.rmdl" )
		player.SetArmsModelOverride( $"mdl/Humans/pilots/ptpov_phantom.rmdl" )
		break
		
		case 13:
		player.SetBodyModelOverride( $"mdl/Humans/pilots/w_amogino.rmdl" )
		player.SetArmsModelOverride( $"mdl/Humans/pilots/ptpov_amogino.rmdl" )
		break

		case 14:
		player.SetBodyModelOverride( $"mdl/Humans/pilots/w_rhapsody.rmdl" )
		player.SetArmsModelOverride( $"mdl/Humans/pilots/ptpov_rhapsody.rmdl" )
		break
		
		case 15:
		player.SetBodyModelOverride( $"mdl/Humans/pilots/w_ash_legacy.rmdl" )
		player.SetArmsModelOverride( $"mdl/Humans/pilots/pov_ash_legacy.rmdl" )
		break

		case 16:
		player.SetBodyModelOverride( $"mdl/Humans/pilots/w_jackcooper.rmdl" )
		player.SetArmsModelOverride( $"mdl/Humans/pilots/ptpov_jackcooper.rmdl" )
		break

		case 17:
		player.SetBodyModelOverride( $"mdl/Humans/pilots/pilot_medium_loba.rmdl" )
		player.SetArmsModelOverride( $"mdl/Humans/pilots/pov_pilot_medium_loba.rmdl" )
		break
		
		case 18:
		player.SetBodyModelOverride( $"mdl/Humans/pilots/pilot_heavy_revenant.rmdl" )
		player.SetArmsModelOverride( $"mdl/Humans/pilots/pov_pilot_heavy_revenant.rmdl" )
		break

		case 19: // ballistic
		player.SetBodyModelOverride( $"mdl/Humans/pilots/ballistic_base_w.rmdl" )
		player.SetArmsModelOverride( $"mdl/Humans/pilots/ballistic_base_v.rmdl" )
		break
		
		case 20: // mrvn
		player.SetBodyModelOverride( $"mdl/flowstate_custom/w_marvin.rmdl" )
		player.SetArmsModelOverride( $"mdl/Humans/pilots/ptpov_amogino.rmdl" )
		break

		case 21: // pete
		player.SetBodyModelOverride( $"mdl/flowstate_custom/w_pete_mri.rmdl" )
		player.SetArmsModelOverride( $"mdl/flowstate_custom/ptpov_pete_mri.rmdl" )
		break
	}	
}

void function ReCheckGodMode(entity player)
{
	wait 0.1
	if(!IsValid(player) || IsValid(player) && !IsAlive(player)) return
	
	player.MakeVisible()
	player.ClearInvulnerable()
	player.SetTakeDamageType( DAMAGE_YES )
	if( !flowstateSettings.hackersVsPros )
		Highlight_ClearEnemyHighlight( player )
}

void function TpPlayerToSpawnPoint(entity player)
{
	LocPair loc = _GetAppropriateSpawnLocation(player)

	if ( !IsValid( player ) ) return
    player.SetOrigin(loc.origin)
	player.SetAngles(loc.angles)
}

void function Flowstate_GrantSpawnImmunity(entity player, float duration)
{
	if(!IsValid(player) || !IsValid(player) && !player.IsPlayer() || is1v1EnabledAndAllowed() ) return //wtf?
	
	// thread WpnPulloutOnRespawn(player, duration)

	EmitSoundOnEntityOnlyToPlayer( player, player, "PhaseGate_Enter_1p" )
	EmitSoundOnEntityExceptToPlayer( player, player, "PhaseGate_Enter_3p" )

	StatusEffect_AddTimed( player, eStatusEffect.adrenaline_visuals, 1.0, duration, duration )
	StatusEffect_AddTimed( player, eStatusEffect.speed_boost, 0.3, duration, duration )
	StatusEffect_AddTimed( player, eStatusEffect.drone_healing, 1.0, duration, duration )
	StatusEffect_AddTimed( player, eStatusEffect.stim_visual_effect, 1.0, duration, duration )

	player.SetTakeDamageType( DAMAGE_NO )
	if( !flowstateSettings.hackersVsPros )
		Highlight_SetEnemyHighlight( player, "survival_enemy_skydiving" )
	player.SetInvulnerable()

	float endTime = Time() + duration
	
	while(Time() <= endTime)
		wait 0.1
	
	if ( !IsValid( player ) ) return
	
	player.MakeVisible()
	player.ClearInvulnerable()
	player.SetTakeDamageType( DAMAGE_YES )
	if( !flowstateSettings.hackersVsPros )
		Highlight_ClearEnemyHighlight( player )
	
	StatusEffect_StopAllOfType( player, eStatusEffect.adrenaline_visuals )
	StatusEffect_StopAllOfType( player, eStatusEffect.speed_boost )
	StatusEffect_StopAllOfType( player, eStatusEffect.drone_healing )
	StatusEffect_StopAllOfType( player, eStatusEffect.stim_visual_effect )
	
	wait 0.1
	ReCheckGodMode(player)
	//maki script
	wait 0.5
	try
	{
		highlightKdMoreThan2(player)

	}
	catch(err){}
	
	//maki script
}

void function WpnPulloutOnRespawn(entity player, float duration)
{
	if(!IsValid( player ) || !IsAlive(player) ) return
	//maki script
	// OnThreadEnd(
	// function() : ( player )
	// 	{
	// 		if( IsValid( player ) && file.tdmState != eTDMState.NEXT_ROUND_NOW )
	// 			DeployAndEnableWeapons( player )
	// 	}
	// )

	// if( IsValid( player ) && file.tdmState != eTDMState.NEXT_ROUND_NOW )
	// 	DeployAndEnableWeapons( player )
	player.ClearFirstDeployForAllWeapons()
	if( flowstateSettings.ReloadTacticalOnRespawn )
	{
		entity tactical = player.GetOffhandWeapon( OFFHAND_TACTICAL )
		//maki script
		if ( !IsValid( tactical ) ) return
		tactical.SetWeaponPrimaryClipCount( tactical.GetWeaponPrimaryClipCountMax() )
	}
	if( flowstateSettings.ReloadUltimateOnRespawn )
	{
		entity ultimate = player.GetOffhandWeapon( OFFHAND_ULTIMATE )
		//maki script
		if ( !IsValid( ultimate ) ) return
		ultimate.SetWeaponPrimaryClipCount( ultimate.GetWeaponPrimaryClipCountMax() )
	}

	if(IsValid( player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_1 )))
	{
		entity weapon = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_1 )
		
		if( weapon.LookupAttachment( "CHARM" ) != 0 )
			weapon.SetWeaponCharm( $"mdl/props/charm/charm_nessy.rmdl", "CHARM")
	}
	if(IsValid( player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 )))
	{
		entity weapon = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 )
		
		if( weapon.LookupAttachment( "CHARM" ) != 0 )
			weapon.SetWeaponCharm( $"mdl/props/charm/charm_nessy.rmdl", "CHARM")
			
		player.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_0)
	}
	
	player.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_1)
	player.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_0)
}

void function WpnAutoReloadOnKill( entity player )
{

	entity primary = player.GetLatestPrimaryWeapon( eActiveInventorySlot.mainHand )
	entity sec = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_1 )

	if (primary == sec) {
		sec = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 )
	}

	if (FlowState_AutoreloadOnKillPrimary() && IsValid(primary) && primary.GetWeaponClassName() != "mp_weapon_melee_survival") {
		if(primary.UsesClipsForAmmo())
			primary.SetWeaponPrimaryClipCount(primary.GetWeaponPrimaryClipCountMax())
		else
		{
			int ammoType = primary.GetWeaponAmmoPoolType()
			player.AmmoPool_SetCapacity( 999 )
			player.AmmoPool_SetCount( ammoType, 999)
		}
	}

	if (FlowState_AutoreloadOnKillSecondary() && IsValid(sec)) {
		if(sec.UsesClipsForAmmo())
			sec.SetWeaponPrimaryClipCount(sec.GetWeaponPrimaryClipCountMax())
		else
		{
			int ammoType = sec.GetWeaponAmmoPoolType()
			player.AmmoPool_SetCapacity( 999 )
			player.AmmoPool_SetCount( ammoType, 999)
		}
	}
}

void function SummonPlayersInACircle(entity player0)
{
	vector pos = player0.GetOrigin()
	pos.z += 5
	Message(player0,"CIRCLE FIGHT NOW!", "", 5)
    for(int i = 0 ; i < GetPlayerArray().len() ; i++)
	{
		entity p = GetPlayerArray()[i]
		if(!IsValid( p ) || p == player0)
		    continue

		float r = float(i) / float( GetPlayerArray().len() ) * 2 * PI
		TeleportFRPlayer(p, pos + 150.0 * <sin( r ), cos( r ), 0.0>, <0, 0, 0>)
		Message(p,"CIRCLE FIGHT NOW!", "", 5)
	}
}

void function __GiveWeapon( entity player, array<string> WeaponData, int slot, int select, bool isGungame = false)
{
	array<string> Data = split(WeaponData[select], " ")
	
	if ( Data.len() == 0 ) return 
	
	string weaponclass = Data[0]
	
	if(weaponclass == "tgive") return
	
	array<string> Mods
	foreach(string mod in Data)
	{
		if(strip(mod) != "" && strip(mod) != weaponclass)
		    Mods.append( strip(mod) )
	}
	
	try{
		entity weaponNew
		if(IsValid(player))
		{
			weaponNew = player.GiveWeapon( weaponclass , slot, Mods, false )
			
			if( !IsValid( weaponNew ) )
				return

			SetupInfiniteAmmoForWeapon( player, weaponNew )
			player.DeployWeapon()

			if ( GetCurrentPlaylistVarBool( "flowstate_giveskins_weapons", false ) )
			{
				ItemFlavor ornull weaponSkinOrNull = null
				array<string> fsCharmsToUse = [ "SAID00701640565", "SAID01451752993", "SAID01334887835", "SAID01993399691", "SAID00095078608", "SAID01439033541", "SAID00510535756", "SAID00985605729" ]
				int chosenCharm = ConvertItemFlavorGUIDStringToGUID( fsCharmsToUse.getrandom() )
				ItemFlavor ornull weaponCharmOrNull = GetItemFlavorByGUID( chosenCharm )
				ItemFlavor ornull weaponFlavor = GetWeaponItemFlavorByClass( weaponclass )

				if( weaponFlavor != null )
				{
					array<int> weaponLegendaryIndexMap = FS_ReturnLegendaryModelMapForWeaponFlavor( expect ItemFlavor( weaponFlavor ) )
					if( weaponLegendaryIndexMap.len() > 1 )
						weaponSkinOrNull = GetItemFlavorByGUID( weaponLegendaryIndexMap[RandomIntRangeInclusive(1,weaponLegendaryIndexMap.len()-1)] )
				}

				WeaponCosmetics_Apply( weaponNew, weaponSkinOrNull, weaponCharmOrNull )
			}
			if( weaponclass == "mp_weapon_lightninggun" && Flowstate_IsFastInstaGib() )
				weaponNew.AddMod( "noauto" )
		}
		else if(IsValid(player) && isGungame)
		{
			player.ReplaceActiveWeapon(slot, weaponclass, Mods)
			player.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_0)
			player.ClearFirstDeployForAllWeapons()			
		}
	}catch(e420){
		printt("Invalid weapon name for tgive command.")
	}
}

void function GiveRandomPrimaryWeaponHalo(entity player)
{
	int slot = WEAPON_INVENTORY_SLOT_PRIMARY_0

    array<string> Weapons = [
		"mp_weapon_halomagnum"
	]

	//R5RDEV-1
	
	// foreach(weapon in Weapons)
	// {
		// array<string> weaponfullstring = split( weapon , " ")
		// string weaponName = weaponfullstring[0]
		// if(file.blacklistedWeapons.find(weaponName) != -1)
				// Weapons.removebyvalue(weapon)
	// }
	
	Weapons = ValidateBlacklistedWeapons( Weapons )

	__GiveWeapon( player, Weapons, slot, RandomIntRange( 0, Weapons.len() ) )
}

void function GiveRandomSecondaryWeaponHalo(entity player)
{
	int slot = WEAPON_INVENTORY_SLOT_PRIMARY_1

	//todo: init outside func..
    array<string> Weapons = [
		"mp_weapon_halosmg",
		"mp_weapon_haloassaultrifle",
		"mp_weapon_halobattlerifle"
	]

	//R5RDEV-1
	// foreach(weapon in Weapons)
	// {
		// array<string> weaponfullstring = split( weapon , " ")
		// string weaponName = weaponfullstring[0]
		// if(file.blacklistedWeapons.find(weaponName) != -1)
				// Weapons.removebyvalue(weapon)
	// }
	
	Weapons = ValidateBlacklistedWeapons( Weapons )

	__GiveWeapon( player, Weapons, slot, RandomIntRange( 0, Weapons.len() ) )
}

void function SetupInfiniteAmmoForWeapon( entity player, entity weapon)
{
	if( !InfiniteAmmoEnabled() )
		return
	
	if( IsValid( weapon ) && weapon.UsesClipsForAmmo() )
	{
		int maxClipSize = weapon.UsesClipsForAmmo() ? weapon.GetWeaponSettingInt( eWeaponVar.ammo_clip_size ) : weapon.GetWeaponPrimaryAmmoCountMax( weapon.GetActiveAmmoSource() )
		int ammoType = weapon.GetWeaponAmmoPoolType()
		string ammoRef = AmmoType_GetRefFromIndex( ammoType )
		int currentAmmo = weapon.GetWeaponPrimaryClipCount()
		int maxAmmo = weapon.GetWeaponSettingInt( eWeaponVar.ammo_clip_size )
		int requiredAmmo = maxAmmo - currentAmmo
		int ammoInInventory = SURVIVAL_CountItemsInInventory( player, ammoRef )
		
		player.AmmoPool_SetCapacity( 65535 )
		player.AmmoPool_SetCount( ammoType, ammoInInventory + requiredAmmo + maxClipSize )

		weapon.SetWeaponPrimaryClipCount( weapon.GetWeaponPrimaryClipCountMax() )
	} else if( IsValid( weapon ) )
	{
		int ammoType = weapon.GetWeaponAmmoPoolType()
		player.AmmoPool_SetCapacity( 65535 )
		player.AmmoPool_SetCount( ammoType, 65535 )
	}
}

void function GiveRandomPrimaryWeaponMetagame(entity player)
{
	int slot = WEAPON_INVENTORY_SLOT_PRIMARY_0

	if( Flowstate_IsFastInstaGib() )
	{
		array<string> Weapons = [
			"mp_weapon_lightninggun"
		]
		
		__GiveWeapon( player, Weapons, slot, RandomIntRange( 0, Weapons.len() ) )
		return
	}

	//todo: init outside func

    array<string> Weapons = [
		"mp_weapon_alternator_smg optic_cq_threat bullets_mag_l2 stock_tactical_l2 laser_sight_l2"
		"mp_weapon_r97 laser_sight_l2 optic_cq_hcog_classic stock_tactical_l2 bullets_mag_l2",
		"mp_weapon_r97 laser_sight_l2 optic_cq_hcog_classic stock_tactical_l2 bullets_mag_l2",
		"mp_weapon_volt_smg laser_sight_l2 optic_cq_hcog_classic energy_mag_l2 stock_tactical_l2",
		"mp_weapon_energy_shotgun optic_cq_threat shotgun_bolt_l2 stock_tactical_l2",
		"mp_weapon_mastiff optic_cq_threat shotgun_bolt_l2 stock_tactical_l2",
		"mp_weapon_shotgun optic_cq_threat shotgun_bolt_l2 stock_tactical_l2"
	]

	//R5RDEV-1
	// foreach(weapon in Weapons)
	// {
		// array<string> weaponfullstring = split( weapon , " ")
		// string weaponName = weaponfullstring[0]
		// if(file.blacklistedWeapons.find(weaponName) != -1)
				// Weapons.removebyvalue(weapon)
	// }
	
	Weapons = ValidateBlacklistedWeapons( Weapons )

	__GiveWeapon( player, Weapons, slot, RandomIntRange( 0, Weapons.len() ) )
}

void function GiveRandomSecondaryWeaponMetagame(entity player)
{
	int slot = WEAPON_INVENTORY_SLOT_PRIMARY_1

	if( Flowstate_IsFastInstaGib() )
	{
		//todo: init outside func..
		array<string> Weapons = [
			"mp_weapon_lightninggun"
		]
		
		__GiveWeapon( player, Weapons, slot, RandomIntRange( 0, Weapons.len() ) )
		return
	}
	
	//todo: init outside func..
    array<string> Weapons = [
		"mp_weapon_wingman optic_cq_hcog_classic sniper_mag_l2 hopup_headshot_dmg",
		"mp_weapon_rspn101 barrel_stabilizer_l2 optic_cq_hcog_classic stock_tactical_l2 bullets_mag_l2",
		"mp_weapon_rspn101 barrel_stabilizer_l2 optic_cq_hcog_bruiser stock_tactical_l2 bullets_mag_l2",
		"mp_weapon_vinson optic_cq_hcog_bruiser stock_tactical_l2 highcal_mag_l2",
		"mp_weapon_vinson optic_cq_hcog_classic stock_tactical_l2 highcal_mag_l2",
		"mp_weapon_energy_ar optic_cq_hcog_classic energy_mag_l2 stock_tactical_l2 hopup_turbocharger",
		"mp_weapon_energy_ar optic_cq_hcog_bruiser energy_mag_l2 stock_tactical_l2 hopup_turbocharger"
	]

	//R5RDEV-1
	// foreach(weapon in Weapons)
	// {
		// array<string> weaponfullstring = split( weapon , " ")
		// string weaponName = weaponfullstring[0]
		// if(file.blacklistedWeapons.find(weaponName) != -1)
				// Weapons.removebyvalue(weapon)
	// }
	
	Weapons = ValidateBlacklistedWeapons( Weapons )

	__GiveWeapon( player, Weapons, slot, RandomIntRange( 0, Weapons.len() ) )
}

void function GiveRandomPrimaryWeapon(entity player)
{
	int slot = WEAPON_INVENTORY_SLOT_PRIMARY_0

	//todo: init outside func..
    array<string> Weapons = [
		"mp_weapon_wingman optic_cq_hcog_classic sniper_mag_l2",
		"mp_weapon_r97 optic_cq_threat bullets_mag_l2 stock_tactical_l2",
		"mp_weapon_wingman optic_cq_hcog_classic sniper_mag_l3",
		"mp_weapon_vinson stock_tactical_l2 highcal_mag_l3",
		"mp_weapon_hemlok optic_cq_hcog_classic stock_tactical_l2 highcal_mag_l2 barrel_stabilizer_l2",
		"mp_weapon_lmg barrel_stabilizer_l1 stock_tactical_l3",
        "mp_weapon_energy_ar energy_mag_l2 stock_tactical_l3",
        "mp_weapon_alternator_smg bullets_mag_l3 stock_tactical_l3",
        "mp_weapon_rspn101 stock_tactical_l2 bullets_mag_l2 barrel_stabilizer_l1"
	]

	//R5RDEV-1
	// foreach(weapon in Weapons)
	// {
		// array<string> weaponfullstring = split( weapon , " ")
		// string weaponName = weaponfullstring[0]
		// if(file.blacklistedWeapons.find(weaponName) != -1)
				// Weapons.removebyvalue(weapon)
	// }
	
	Weapons = ValidateBlacklistedWeapons( Weapons )

	__GiveWeapon( player, Weapons, slot, RandomIntRange( 0, Weapons.len() ) )
}

void function GiveRandomSecondaryWeapon( entity player)
{
	int slot = WEAPON_INVENTORY_SLOT_PRIMARY_1

	//todo: init outside func..
	
    array<string> Weapons = [
		"mp_weapon_r97 optic_cq_hcog_classic stock_tactical_l1 bullets_mag_l2",
		"mp_weapon_rspn101 optic_cq_hcog_classic stock_tactical_l1 bullets_mag_l2",
		"mp_weapon_vinson optic_cq_hcog_classic stock_tactical_l1 highcal_mag_l3",
		"mp_weapon_energy_ar optic_cq_hcog_classic hopup_turbocharger",
	]

	//R5RDEV-1
	// foreach(weapon in Weapons)
	// {
		// array<string> weaponfullstring = split( weapon , " ")
		// string weaponName = weaponfullstring[0]
		// if(file.blacklistedWeapons.find(weaponName) != -1)
				// Weapons.removebyvalue(weapon)
	// }
	
	Weapons = ValidateBlacklistedWeapons( Weapons )

	__GiveWeapon( player, Weapons, slot, RandomIntRange( 0, Weapons.len() ) )
}

void function GiveActualGungameWeapon(int index, entity player)
{
	int slot = WEAPON_INVENTORY_SLOT_PRIMARY_0

	//todo: init outside func..
	
    array<string> Weapons = [
		"mp_weapon_r97 optic_cq_hcog_classicstock_tactical_l3 bullets_mag_l2",
		"mp_weapon_wingman optic_cq_hcog_classic sniper_mag_l1",
		"mp_weapon_rspn101 optic_cq_hcog_bruiser stock_tactical_l3 bullets_mag_l2",
		"mp_weapon_energy_shotgun shotgun_bolt_l1",
		"mp_weapon_mastiff shotgun_bolt_l1",
		"mp_weapon_doubletake",
		//"mp_weapon_hemlok optic_cq_hcog_classic stock_tactical_l3 highcal_mag_l3 barrel_stabilizer_l4_flash_hider",
		//"mp_weapon_autopistol optic_cq_hcog_classic bullets_mag_l1",
		//"mp_weapon_lmg optic_cq_hcog_bruiser highcal_mag_l3 barrel_stabilizer_l3 stock_tactical_l3",
		//"mp_weapon_shotgun_pistol shotgun_bolt_l3",
		//"mp_weapon_defender optic_ranged_hcog stock_sniper_l2",
		//"mp_weapon_alternator_smg optic_cq_hcog_classic bullets_mag_l3 stock_tactical_l3",
		//"mp_weapon_semipistol",
		//"mp_weapon_esaw optic_cq_hcog_bruiser energy_mag_l1 barrel_stabilizer_l2",
		//"mp_weapon_doubletake energy_mag_l3",
		//"mp_weapon_rspn101 optic_cq_hcog_classic bullets_mag_l1 barrel_stabilizer_l1 stock_tactical_l1",
		//"mp_weapon_wingman sniper_mag_l1",
		//"mp_weapon_shotgun",
		//"mp_weapon_energy_shotgun",
		//"mp_weapon_vinson stock_tactical_l1 highcal_mag_l2",
		//"mp_weapon_r97 optic_cq_threat bullets_mag_l1 barrel_stabilizer_l3 stock_tactical_l1",
		//"mp_weapon_autopistol",
		//"mp_weapon_dmr optic_cq_hcog_bruiser sniper_mag_l2 barrel_stabilizer_l2 stock_sniper_l3",
		//"mp_weapon_esaw optic_cq_hcog_classic energy_mag_l1 barrel_stabilizer_l4_flash_hider",
		//"mp_weapon_alternator_smg optic_cq_hcog_classic barrel_stabilizer_l2",
		//"mp_weapon_sniper",
		//"mp_weapon_defender optic_sniper stock_sniper_l2",
		//"mp_weapon_esaw optic_cq_holosight_variable",
		//"mp_weapon_rspn101 optic_cq_holosight_variable",
		//"mp_weapon_semipistol bullets_mag_l2"
	]

	//R5RDEV-1
	// foreach(weapon in Weapons)
	// {
		// array<string> weaponfullstring = split( weapon , " ")
		// string weaponName = weaponfullstring[0]
		// if(file.blacklistedWeapons.find(weaponName) != -1)
				// Weapons.removebyvalue(weapon)
	// }
	
	Weapons = ValidateBlacklistedWeapons( Weapons )

	__GiveWeapon( player, Weapons, slot, index, true)
}

void function GiveRandomTac(entity player)
{
	//todo: init outside func..
    array<string> Weapons = [
		"mp_ability_grapple",
		"mp_ability_phase_walk",
		"mp_ability_heal",
		"mp_weapon_bubble_bunker",
		"mp_weapon_grenade_bangalore",
		"mp_ability_area_sonar_scan",
		"mp_weapon_grenade_sonar",
		"mp_weapon_deployable_cover",
		"mp_ability_holopilot",
		"mp_ability_cloak",
		"mp_ability_space_elevator_tac",
		"mp_ability_phase_rewind"
	]

	foreach(ability in file.blacklistedAbilities)
		Weapons.removebyvalue(ability)

	if(IsValid(player))
	    player.GiveOffhandWeapon(Weapons[ RandomIntRange( 0, Weapons.len()) ], OFFHAND_TACTICAL)
}

void function GiveRandomUlt(entity player )
{
    array<string> Weapons = [
		//"mp_weapon_grenade_gas",
		"mp_weapon_jump_pad",
		//"mp_weapon_phase_tunnel",
		"mp_ability_3dash",
		"mp_ability_hunt_mode",
		//"mp_weapon_grenade_creeping_bombardment",
		//"mp_weapon_grenade_defensive_bombardment"

	]

	foreach(ability in file.blacklistedAbilities)
		Weapons.removebyvalue(ability)

	if(IsValid(player))
	    player.GiveOffhandWeapon(Weapons[ RandomIntRange( 0, Weapons.len()) ],  OFFHAND_ULTIMATE)
}

void function OnShipButtonUsed( entity panel, entity player, int useInputFlags )
{
	player.MakeInvisible()
	player.StartObserverMode( OBS_MODE_CHASE )
	player.SetObserverTarget( file.supercooldropship )
}

vector function ShipSpot()
{
	switch(RandomIntRange(0,11))
	{
	    case 0: return <0,0,30>
	    case 1: return <35,0,30>
	    case 2: return <-35,0,30>
	    case 3: return <0,35,30>
	    case 4: return <35,35,30>
	    case 5: return <-35,35,30>
	    case 6: return <0,70,30>
	    case 7: return <35,70,30>
	    case 8: return <-35,70,30>
	    case 9: return <0,105,30>
	    case 10: return <35,105,30>
	    case 11: return <-35,105,30>
		default: return <0,0,30>
	}
	unreachable
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
		foreach( touchingEnt in trigger.GetTouchingEntities()  )
		{
			if(touchingEnt.IsPlayer() && touchingEnt.GetParent() != file.supercooldropship)
			{
				touchingEnt.SetThirdPersonShoulderModeOff()
				vector shipspot = ShipSpot()
				touchingEnt.SetAbsOrigin( file.supercooldropship.GetOrigin() + shipspot )
				touchingEnt.SetParent(file.supercooldropship)
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

	if ( MapName() == eMaps.mp_rr_desertlands_64k_x_64k || MapName() == eMaps.mp_rr_desertlands_64k_x_64k_nx )
		trigger.SetOrigin( <-19459, 2127, 5404> )
	else if( MapName() == eMaps.mp_rr_canyonlands_mu1 || MapName() == eMaps.mp_rr_canyonlands_mu1_night || MapName() == eMaps.mp_rr_canyonlands_64k_x_64k )
		trigger.SetOrigin( <-19459, 2127, 17404> )

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
		foreach( touchingEnt in trigger.GetTouchingEntities() )
		{
			if( touchingEnt.IsPlayer() )
			{
				if ( MapName() == eMaps.mp_rr_desertlands_64k_x_64k || MapName() == eMaps.mp_rr_desertlands_64k_x_64k_nx )
					touchingEnt.SetOrigin( <-19459, 2127, 6404> )
				else if( MapName() == eMaps.mp_rr_canyonlands_mu1 || MapName() == eMaps.mp_rr_canyonlands_mu1_night || MapName() == eMaps.mp_rr_canyonlands_64k_x_64k )
					touchingEnt.SetOrigin( <-19459, 2127, 18404> )
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
		if( invItem.type == 44 || invItem.type == 45 || invItem.type == 46 || invItem.type == 47 || invItem.type == 48 || invItem.type == 53 || invItem.type == 54 || invItem.type == 55 || invItem.type == 56 )
		    continue
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
		box.SetNetInt( "characterIndex", ConvertItemFlavorToLoadoutSlotContentsIndex( Loadout_CharacterClass() , LoadoutSlot_GetItemFlavor( ToEHI( player ) , Loadout_CharacterClass() ) ) )
	}

	if ( hasCard )
	{
		Highlight_SetNeutralHighlight( box, "sp_objective_entity" )
		Highlight_ClearNeutralHighlight( box )

		vector restPos = box.GetOrigin()
		vector fallPos = restPos + < 0, 0, 54 >

		thread (void function( entity box , vector restPos , vector fallPos) {
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

		}) ( box , restPos , fallPos)

		thread (void function( entity box) {
			wait 20
			if(IsValid(box))
				box.Destroy()
		}) ( box )
	}

	return box
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

void function UpgradeShields(entity player, bool died)
{
    if (!IsValid(player)) return

    if (died && FlowState_FIESTAShieldsStreak()) {
        player.SetPlayerGameStat( PGS_TITAN_KILLS, 0 )
        Inventory_SetPlayerEquipment(player, BLUE_SHIELD, "armor")
    } else if (FlowState_FIESTAShieldsStreak())
	{
        player.SetPlayerGameStat( PGS_TITAN_KILLS, player.GetPlayerGameStat( PGS_TITAN_KILLS ) + 1)

        switch (player.GetPlayerGameStat( PGS_TITAN_KILLS ))
		{
	    	case 1:
            case 2:
            case 3:
			case 4:
			    Inventory_SetPlayerEquipment(player, BLUE_SHIELD, "armor")
			break
			case 5:
				Inventory_SetPlayerEquipment(player, PURPLE_SHIELD, "armor")
				foreach(sPlayer in GetPlayerArray())
				    LocalMsg( sPlayer, "#FS_KILL_STREAK", "#FS_5_KILL_STREAK", eMsgUI.DEFAULT, 4, "", player.p.name )
					//Message(sPlayer,"KILL STREAK", player.GetPlayerName() + " got 5 kill streak!", 4, "")
            break
            case 6:
			case 7:
				Inventory_SetPlayerEquipment(player, PURPLE_SHIELD, "armor")
            break
			case 8:
				foreach(sPlayer in GetPlayerArray())
				    LocalMsg( sPlayer, "#FS_EXTRA_KILL_STREAK_TITLE", "#FS_EXTRA_KILL_STREAK_SUBSTR", eMsgUI.DEFAULT, 5, "", player.p.name )
					//Message(sPlayer,"EXTRA SHIELD KILL STREAK", player.GetPlayerName() + " got 8 kill streak and extra shield!", 5, "")
			break
			case 15:
				foreach(sPlayer in GetPlayerArray())
				    LocalMsg( sPlayer, "#FS_15_KILL_STREAK_TITLE", "#FS_15_KILL_STREAK_SUBSTR", eMsgUI.DEFAULT, 5, "", player.p.name )
					//Message(sPlayer,"15 KILL STREAK", player.GetPlayerName() + " got 15 kill streak!", 5, "")
			break
			case 20:
				foreach(sPlayer in GetPlayerArray())
				    LocalMsg( sPlayer, "#FS_20_KILL_STREAK_TITLE", "#FS_20_KILL_STREAK_SUBSTR", eMsgUI.DEFAULT, 5, "", player.p.name )
					//Message(sPlayer,"20 BOMB KILL STREAK", player.GetPlayerName() + " got a 20 bomb!", 5, "")
			break
			case 25:
				foreach(sPlayer in GetPlayerArray())
				    LocalMsg( sPlayer, "#FS_30_KILL_STREAK_TITLE", "#FS_30_KILL_STREAK_SUBSTR", eMsgUI.DEFAULT, 5, "", player.p.name )
					//Message(sPlayer,"LEGENDARY KILL STREAK", player.GetPlayerName() + " got 30 kill streak!", 5, "")
			break
			case 35:
				foreach(sPlayer in GetPlayerArray())
				    LocalMsg( sPlayer, "#FS_PRED_SUMPREMACY_TITLE", "#FS_35_KILL_STREAK_SUBSTR", eMsgUI.DEFAULT, 5, "", player.p.name )
					//Message(sPlayer,"PREDATOR SUPREMACY", player.GetPlayerName() + " got 35 kill streak!", 5, "")
			break
			case 50:
				foreach(sPlayer in GetPlayerArray())
				    LocalMsg( sPlayer, "#FS_50_KILL_STREAK_TITLE", "#FS_50_KILL_STREAK_SUBSTR", eMsgUI.DEFAULT, 5, "", player.p.name )
					//Message(sPlayer,"CHEATER DETECTED!", player.GetPlayerName() + " got 50 kill streak, report him!", 5, "")
            break
			default:
            break
        }

		GiveFlowstateOvershield(player)

    } else if (!FlowState_FIESTAShieldsStreak())
	    PlayerRestoreHP(player, 100, Equipment_GetDefaultShieldHP())
	else if (FlowState_FIESTAShieldsStreak()){
        PlayerRestoreShieldsFIESTA(player, player.GetShieldHealthMax())
        PlayerRestoreHPFIESTA(player, 100)
	}
}

void function KillStreakAnnouncer(entity player, bool died) {

    if (!IsValid(player)) return

    if (died)
        player.SetPlayerGameStat( PGS_TITAN_KILLS, 0 )
    else {
        switch (player.GetPlayerGameStat( PGS_TITAN_KILLS )) {
			case 5:
				foreach(sPlayer in GetPlayerArray())
				    LocalMsg( sPlayer, "#FS_KILL_STREAK", "#FS_5_KILL_STREAK", eMsgUI.DEFAULT, 4, "", player.p.name )
					//Message(sPlayer,"KILL STREAK", player.GetPlayerName() + " got 5 kill streak!", 4, "")
			case 10:
				GiveFlowstateOvershield(player)
				foreach(sPlayer in GetPlayerArray())
				    LocalMsg( sPlayer, "#FS_EXTRA_KILL_STREAK_TITLE", "#FS_EXTRA_KILL_STREAK_SUBSTR", eMsgUI.DEFAULT, 5, "", player.p.name )
					//Message(sPlayer,"EXTRA SHIELD KILL STREAK", player.GetPlayerName() + " got 10 kill streak and extra shield!", 5, "")
            break
			case 15:
				GiveFlowstateOvershield(player)
				foreach(sPlayer in GetPlayerArray())
				    LocalMsg( sPlayer, "#FS_15_KILL_STREAK_TITLE", "#FS_15_KILL_STREAK_SUBSTR", eMsgUI.DEFAULT, 5, "", player.p.name )
					//Message(sPlayer,"15 KILL STREAK", player.GetPlayerName() + " got 15 kill streak and extra shield!", 5, "")
			case 20:
				GiveFlowstateOvershield(player)
				foreach(sPlayer in GetPlayerArray())
				    LocalMsg( sPlayer, "#FS_20_KILL_STREAK_TITLE", "#FS_20_KILL_STREAK_SUBSTR", eMsgUI.DEFAULT, 5, "", player.p.name )
					//Message(sPlayer,"20 BOMB KILL STREAK", player.GetPlayerName() + " got a 20 bomb and extra shield!", 5, "")
            break
			case 25:
				GiveFlowstateOvershield(player)
				foreach(sPlayer in GetPlayerArray())
					LocalMsg( sPlayer, "FS_PRED_SUMPREMACY_TITLE", "#FS_25_PREDATORY_SUPREMACY", eMsgUI.DEFAULT, 5, "", player.p.name )
				//Message(sPlayer,"PREDATOR SUPREMACY", player.GetPlayerName() + " got 25 kill streak and extra shield!", 5, "")
            break
			default:
                break
        }
    }
}


void function GiveFlowstateOvershield( entity player, bool isOvershieldFromGround = false)
{
	player.SetShieldHealthMax( FlowState_ExtrashieldValue() )
	player.SetShieldHealth( FlowState_ExtrashieldValue() )
	if(isOvershieldFromGround){
			foreach(sPlayer in GetPlayerArray()){
			LocalMsg( sPlayer, "#FS_EXTRA_SHIELD_TITLE", "#FS_EXTRA_SHIELD_SUBSTR", eMsgUI.DEFAULT, 5, "", player.p.name )
			//Message(sPlayer,"EXTRA SHIELD PROVIDED", player.GetPlayerName() + " has 50 extra shield.", 5, "")
		}
	}
}


void function GiveGungameWeapon(entity player) 
{
	// int WeaponIndex = player.GetPlayerNetInt( "kills" )
	// int realweaponIndex = WeaponIndex
	// int MaxWeapons = 41
	// if (WeaponIndex > MaxWeapons)
	// {
        // file.tdmState = eTDMState.NEXT_ROUND_NOW
		// foreach (sPlayer in GetPlayerArray())
		// {
			// sPlayer.SetPlayerNetInt("kills", 0) //Reset for kills
	    	// sPlayer.SetPlayerNetInt("deaths", 0) //Reset for deaths
			// sPlayer.p.playerDamageDealt = 0.0
		// }
	// }

	// if(!FlowState_GungameRandomAbilities())
	// {
		// string tac = GetCurrentPlaylistVarString("flowstateGUNGAME_tactical", "~~none~~")
		// string ult = GetCurrentPlaylistVarString("flowstateGUNGAME_ultimate", "~~none~~")

		// entity tactical = player.GetOffhandWeapon( OFFHAND_TACTICAL )
        // entity ultimate = player.GetOffhandWeapon( OFFHAND_ULTIMATE )

		// float oldTacticalChargePercent = 0.0
                // if( IsValid( tactical ) ) {
                    // player.TakeOffhandWeapon( OFFHAND_TACTICAL )
                    // oldTacticalChargePercent = float( tactical.GetWeaponPrimaryClipCount()) / float(tactical.GetWeaponPrimaryClipCountMax() )
                // }
				// if(tac != "~~none~~" && tac != "")
					// player.GiveOffhandWeapon(tac, OFFHAND_TACTICAL)

				// entity newTactical = player.GetOffhandWeapon( OFFHAND_TACTICAL )
				// if(IsValid(newTactical))
					// newTactical.SetWeaponPrimaryClipCount( int( newTactical.GetWeaponPrimaryClipCountMax() * oldTacticalChargePercent ) )

				// if( IsValid( ultimate ) ) player.TakeOffhandWeapon( OFFHAND_ULTIMATE )

				// if(ult != "~~none~~" && ult != "")
					// player.GiveOffhandWeapon(ult, OFFHAND_ULTIMATE)
	// }
	// try{
	// //give gungame weapon
	// player.TakeNormalWeaponByIndexNow( WEAPON_INVENTORY_SLOT_PRIMARY_0 )
	// GiveActualGungameWeapon(realweaponIndex, player)
	// //give secondary
	// string sec = GetCurrentPlaylistVarString("flowstateGUNGAMESecondary", "~~none~~")
	// player.TakeNormalWeaponByIndexNow( WEAPON_INVENTORY_SLOT_PRIMARY_1 )
	// player.GiveWeapon( sec, WEAPON_INVENTORY_SLOT_PRIMARY_1)

	// if (sec != "") {
			// array<string> attachments = []

			// for(int i = 0; GetCurrentPlaylistVarString("flowstateGUNGAMESecondary" + "_" + i.tostring(), "~~none~~") != "~~none~~"; i++)
			// {
				// if(GetCurrentPlaylistVarString("flowstateGUNGAMESecondary" + "_" + i.tostring(), "~~none~~") == ""){
				// continue
				// }
				// else{
				// attachments.append(GetCurrentPlaylistVarString("flowstateGUNGAMESecondary" + "_" + i.tostring(), "~~none~~"))}
			// }
			// player.TakeNormalWeaponByIndexNow( WEAPON_INVENTORY_SLOT_PRIMARY_1 )
			// player.GiveWeapon(sec, WEAPON_INVENTORY_SLOT_PRIMARY_1, attachments)
	// }
	// //entity primary = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 )
	// //if( IsValid( primary ) && !primary.IsWeaponOffhand() ) player.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, GetSlotForWeapon(player, primary))
		// }catch(e113){}
}

//  ██████   █████  ███    ███ ███████     ██       ██████   ██████  ██████
// ██       ██   ██ ████  ████ ██          ██      ██    ██ ██    ██ ██   ██
// ██   ███ ███████ ██ ████ ██ █████       ██      ██    ██ ██    ██ ██████
// ██    ██ ██   ██ ██  ██  ██ ██          ██      ██    ██ ██    ██ ██
//  ██████  ██   ██ ██      ██ ███████     ███████  ██████   ██████  ██
//gameloop

void function RunTDM()
{
    WaitForGameState(eGameState.Playing)
	SetTdmStateToNextRound()
    AddSpawnCallback("prop_dynamic", _OnPropDynamicSpawned)

	if(!Flowstate_DoorsEnabled()){
		array<entity> doors = GetAllPropDoors()

		foreach(entity door in doors)
			if(IsValid(door))
				door.Destroy()
	}

	if( file.locationSettings.len() > 0 && !FlowState_LockPOI() )
		file.locationSettings.randomize()

    while(true)
	{
		//VotingPhase()
		SimpleChampionUI()
		WaitFrame()
	}
	
    WaitForever()
}

const array<int> FALL_TRIGGERS_ENABLED_FOR_MAPS = 
[
	eMaps.mp_rr_desertlands_64k_x_64k,
	eMaps.mp_rr_desertlands_64k_x_64k_nx,
	eMaps.mp_rr_canyonlands_mu1,
	eMaps.mp_rr_canyonlands_mu1_night,
	eMaps.mp_rr_canyonlands_64k_x_64k
]

/////////////@CafeFPS CafeFPS///////////////////
void function SimpleChampionUI()
{
	//printt("Flowstate DEBUG - Game is starting.")
	
	if( file.currentRound > 1 )
	{
		foreach( entity player in GetPlayerArray() )
		{
			if(IsValid(player))
			{
				thread function () : ( player ) 
				{
					ScreenFade( player, 0, 0, 0, 255, 0, 5, FFADE_IN | FFADE_PURGE ) //let's do this before destroy player props so it looks good in custom maps
				}()
			}
		}

		thread function () : ()
		{
			wait 4
			Signal( svGlobal.levelEnt, "FS_WaitForBlackScreen" )
		}()
	}
	
	if( file.playerSpawnedProps.len() > 0 )
	{
		Signal( svGlobal.levelEnt, "FS_ForceDestroyAllLifts" )
		DestroyPlayerProps()
		wait 1
	}
    
	isBrightWaterByZer0 = false

	file.FallTriggersEnabled = true

	if (!file.mapIndexChanged)
	{
		file.nextMapIndex = ( file.nextMapIndex + 1 ) % file.locationSettings.len()
	}

	int choice = file.nextMapIndex
	file.mapIndexChanged = false

	if( !VOTING_PHASE_ENABLE )
	{
		if( choice in file.locationSettings )
		{
			file.selectedLocation = file.locationSettings[ choice ]
		}
		
		if( FlowState_LockPOI() )
			file.selectedLocation = file.locationSettings[ FlowState_LockedPOI() ]
	} 
	else
	{
		file.selectedLocation = file.locationSettings[ FS_DM.mappicked ]
	}

	file.thisroundDroppodSpawns = GetNewFFADropShipLocations( file.selectedLocation.name, GetMapName() )
	//printt("Flowstate DEBUG - Next round location is: " + file.selectedLocation.name)

	if( FALL_TRIGGERS_ENABLED_FOR_MAPS.contains( MapName() ) )
	{
		thread CreateShipRoomFallTriggers()
	}

	if ( FlowState_RandomGuns() )
    {
        file.randomprimary = RandomIntRangeInclusive( 0, 15 )
        file.randomsecondary = RandomIntRangeInclusive( 0, 6 )
    }
	else if ( FlowState_RandomGunsMetagame() )
	{
		file.randomprimary = RandomIntRangeInclusive( 0, 2 )
        file.randomsecondary = RandomIntRangeInclusive( 0, 4 )
	}
	else if( flowstateSettings.RandomHaloGuns )
	{
		file.randomprimary = RandomIntRangeInclusive( 0, 1 )
        file.randomsecondary = RandomIntRangeInclusive( 0, 1 )
	}
	else if ( FlowState_RandomGunsEverydie() )
	{
		file.randomprimary = RandomIntRangeInclusive( 0, 23 )
        file.randomsecondary = RandomIntRangeInclusive( 0, 18 )
	}
	
	file.isLoadingCustomMap = true
	
	switch( file.selectedLocation.name )
	{
		case "Skill trainer By CafeFPS":
		thread SkillTrainerLoad()
		break
		
		case "Brightwater By Zer0bytes":
		//printt("Flowstate DEBUG - creating props for Brightwater.")
		isBrightWaterByZer0 = true
		thread WorldEntities()
		wait 1
		thread BrightwaterLoad()
		wait 1.5
		thread BrightwaterLoad2()
		wait 1.5
		thread BrightwaterLoad3()
		break
		
		case "Cave By BlessedSeal":
		thread SpawnEditorPropsSeal()
		break
		
		case "Gaunlet":
		if(FlowState_ExtrashieldsEnabled())
			CreateFlowStateGroundMedKit( <-21289, -12030, 3060>, ZERO_VECTOR, 3 , FlowState_ExtrashieldsSpawntime() )
		break
		
		case "White Forest By Zer0Bytes":
		thread SpawnWhiteForestProps()
		break
		
		case "Custom map by Biscutz":
		thread LoadMapByBiscutz1()
		thread LoadMapByBiscutz2()
		break
		
		case "Shipment By AyeZee":
		thread Shipment()
		break
		
		case "Killhouse By AyeZee":
		thread Killhouse()
		break
		
		case "Nuketown By AyeZee":
		thread nuketown()
		break
		
		case "Killyard":
        DestroyPlayerProps()
		thread Killyard()
		break
		
		case "Dustment by DEAFPS":
		thread Dustment()
		break
		
		case "Shoothouse by DEAFPS":
		thread Shoothouse()
		break
		
		case "Rust By DEAFPS":
		thread Rust()
		break
		
		case "Noshahr Canals by DEAFPS":
		thread de_NCanals()
		break
		
		case "Movement Gym":
		thread MovementGym()
		break
		
		case "The Pit":
		thread SpawnCyberdyne()
		break
		
		case "Lockout":
		thread SpawnLockout()
		break

		case "Narrows":
		thread SpawnChill()
		break

		case "Beaver Creek":
		thread SpawnBeavercreek()
		break
	}
	
	if( file.currentRound > 1 )
		WaitSignal( svGlobal.levelEnt, "FS_WaitForBlackScreen" )

	if( Flowstate_IsFSDM() || flowstateSettings.is_halo_gamemode )
		SetGlobalNetTime( "flowstate_DMStartTime", Time() + FLOWSTATE_START_TIME_DELAY )
	
	if( Flowstate_IsMovementGym() )
	{
		foreach( entity player in GetPlayerArray() )
		{
			if( !IsValid(player) ) continue
			try 
			{
				RemoveCinematicFlag(player, CE_FLAG_HIDE_MAIN_HUD | CE_FLAG_EXECUTION)
				player.SetThirdPersonShoulderModeOff()
				_HandleRespawn(player)
				player.MovementEnable()
				DeployAndEnableWeapons( player )
				player.UnfreezeControlsOnServer()
				// Remote_CallFunction_Replay(player, "ServerCallback_FSDM_OpenVotingPhase", false)
				//Remote_CallFunction_NonReplay(player, "Minimap_DisableDraw_Internal")
				Remote_CallFunction_ByRef( player, "Minimap_DisableDraw_Internal" )
				MakeInvincible( player )

				player.SetPlayerNetBool( "pingEnabled", false )
				player.AddToRealm(1)
				StatusEffect_StopAllOfType(player, eStatusEffect.stim_visual_effect)
				StatusEffect_StopAllOfType(player, eStatusEffect.speed_boost)
				TakeAllWeapons( player )
				TakeAllPassives( player )
				player.GiveOffhandWeapon("mp_ability_phase_walk", OFFHAND_TACTICAL)
				player.PhaseShiftCancel()
				
				player.GiveWeapon( "mp_weapon_melee_survival", WEAPON_INVENTORY_SLOT_PRIMARY_2, [] )
				player.GiveOffhandWeapon( "melee_pilot_emptyhanded", OFFHAND_MELEE, [] )

			} catch(e3){}
		}
	}
	else
	{
		foreach( entity player in GetPlayerArray() )
		{
			if( !IsValid( player ) ) 
				continue
			
			try 
			{
				RemoveCinematicFlag(player, CE_FLAG_HIDE_MAIN_HUD | CE_FLAG_EXECUTION)
				player.SetThirdPersonShoulderModeOff()
				_HandleRespawn(player)
				player.UnforceStand()

				player.HolsterWeapon()
				player.Server_TurnOffhandWeaponsDisabledOn()
				Remote_CallFunction_Replay(player, "ServerCallback_FSDM_OpenVotingPhase", false)
						
				ClearInvincible(player)

				thread function () : ( player )
				{
					if( IsValid( player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_1 ) ) )
						player.SetActiveWeaponBySlot( eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_1 )

					player.MovementDisable()
					player.DeployWeapon()
					player.LockWeaponChange()
					player.FreezeControlsOnServer()

					// #if !DEVELOPER
					if( Flowstate_IsFSDM() || flowstateSettings.is_halo_gamemode )
						wait FLOWSTATE_START_TIME_DELAY
					// #endif

					if( flowstateSettings.enable_oddball_gamemode )
					{

						// if( !debugging )
						// {
							// SetGlobalNetTime( "FSIntro_StartTime", Time() + 3 )
							// SetGlobalNetTime( "FSIntro_EndTime", Time() + 10 + max( GetPlayerArrayOfTeam(TEAM_IMC).len(), GetPlayerArrayOfTeam(TEAM_MILITIA).len() ) * 3 )

							// while( Time() < GetGlobalNetTime( "FSIntro_EndTime" ) )
								// WaitFrame()

							// foreach(player in GetPlayerArray())
							// {
								// Remote_CallFunction_NonReplay(player, "FSIntro_ForceEnd")
							// }
						// }

						//Message( player, "Oddball", file.selectedLocation.name, 5, "" )
						LocalMsg( player, "#FS_Oddball", "", eMsgUI.DEFAULT, 5, "", file.selectedLocation.name )
						// Remote_CallFunction_NonReplay( player, "DM_HintCatalog", 2, 0)
						thread function ( ) : ( player )
						{
							wait 2 // -.-

							if( GetGameState() != eGameState.Playing ) // O.O
								return

							thread ResetBallInBallSpawner()

							foreach( player in GetPlayerArray() )
								LocalMsg( player, "#FS_OddballReady", "", eMsgUI.DEFAULT, 3, "", "", "UI_InGame_FD_SliderExit" )
								//Message( player, "BALL READY", "", 3, "UI_InGame_FD_SliderExit" )
						}()
					}
					else if( !is1v1EnabledAndAllowed() )
						LocalMsg( player, "#FS_Deathmatch", "", eMsgUI.DEFAULT, 5, "", file.selectedLocation.name )
						//Message( player, "Deathmatch", file.selectedLocation.name, 5, "" )

					if( !IsValid( player ) || !IsAlive( player ) )
						return
					
					if( MapName() == eMaps.mp_flowstate )
						Remote_CallFunction_ByRef( player, "Minimap_DisableDraw_Internal" )
						//Remote_CallFunction_NonReplay(player, "Minimap_DisableDraw_Internal")
					else //if( GetMapName() != "mp_flowstate" )
						Remote_CallFunction_ByRef( player, "Minimap_EnableDraw_Internal" )
						//Remote_CallFunction_NonReplay(player, "Minimap_EnableDraw_Internal")

					player.MovementEnable()
					player.UnlockWeaponChange()
					player.Server_TurnOffhandWeaponsDisabledOff()
					player.UnfreezeControlsOnServer()
				
					entity primary = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 )
					entity secondary = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_1 )
					entity tactical = player.GetOffhandWeapon( OFFHAND_INVENTORY )
					entity ultimate = player.GetOffhandWeapon( OFFHAND_LEFT )

					if(IsValid(primary) && primary.UsesClipsForAmmo())
						primary.SetWeaponPrimaryClipCount(primary.GetWeaponPrimaryClipCountMax())
					if(IsValid(secondary) && secondary.UsesClipsForAmmo())
						secondary.SetWeaponPrimaryClipCount( secondary.GetWeaponPrimaryClipCountMax())
					if(IsValid(tactical) && tactical.UsesClipsForAmmo())
						tactical.SetWeaponPrimaryClipCount( tactical.GetWeaponPrimaryClipCountMax() )
					if(IsValid(ultimate) && ultimate.UsesClipsForAmmo())
						ultimate.SetWeaponPrimaryClipCount( ultimate.GetWeaponPrimaryClipCountMax() )
				}()

			} catch(e3){}
		}
	}
	
	switch( file.selectedLocation.name )
	{
		case "Lockout":
		file.playerSpawnedProps.append( AddDeathTriggerWithParams( Vector(42000, -10000, -19900) - <0,0,2800>, 5000 ) )
		break
		
		case "Narrows":
		file.playerSpawnedProps.append( AddDeathTriggerWithParams( <42099.9922, -9965.91016, -21099.1738>, 7000 ) )
		break
		
		case "Beaver Creek":
		file.playerSpawnedProps.append( AddDeathTriggerWithParams( <42014.6719, -10264.7627, -26246>, 7000 ) )
		break

		case "The Pit":
		file.playerSpawnedProps.append( AddDeathTriggerWithParams( <41974.3789, -9356.3877, -20371.6523>, 7000 ) )
		break
	}

	string subtext = "Starting in " + FLOWSTATE_START_TIME_DELAY + " seconds."

	////////////////////////////////
	///// 		SET CHAMPION 	////
	////////////////////////////////

	entity bestPlayer = GetBestPlayer()
	bool bClearChampion
	
	if( bestPlayer != null ) // wont be null if this is another flowstate round.
	{
		SetChampion( bestPlayer ) //round based
		file.previousChampion = bestPlayer
		file.previousChallenger = PlayerWithMostDamage()
		bClearChampion = true
	}
	else
	{
		#if TRACKER //onboarding handles tracker persistence multi-server based winner
			FlagSet( "DeterminePreviousChampion" )
			FlagWait( "PreviousChampionDetermined" )
		#else
			FSDM_ReturnBestPlayers_FromChampions( GetPlayerArray() )
		#endif
	}
	
	bool presentChampion = false
	
	if( flowstateSettings.show_short_champion_screen && GetChampion() )
	{
		presentChampion = true
		thread
		(
			void function()
			{
				SetChampionShowingState( true, Time() + SHORT_CHAMPION_CARD_TIME )
				
				OnThreadEnd
				(
					void function()
					{
						SetChampionShowingState( false )
					}
				)
				
				WaitForChampionToFinish()
			}
		)()
	}
	
	////////////////////////////////
	//////// 	CLEAR DATA 	////////
	////////////////////////////////

	SurvivalCommentary_ResetAllData()
	
	if( Playlist() == ePlaylists.fs_scenarios )
		ScenariosPersistence_ClearAllData()

	//printt("Flowstate DEBUG - Clearing last round stats.")
	foreach( player in GetPlayerArray() )
	{
		if( !IsValid( player ) ) 
			continue
		
		if( presentChampion )
			Remote_CallFunction_ByRef( player, "Tracker_ShowChampion" )
			
		FSDM_SetMatchPersistentVarsForPlayer( player ) //sets current round stats since we are about to clear that data. ~mkos
			
		SetPlayerStatBool( player.GetPlatformUID(), "previous_champion", false )

		GameRules_SetTeamScore( player.GetTeam(), 0 )

		if( Flowstate_IsDmOddball() || Flowstate_IsHalomodeOddball() )
		{
			Oddball_RestorePlayerStats( player )
		}
		
		if( flowstateSettings.enable_oddball_gamemode )
		{
			if( !IsValid( player ) )
				continue

			int maxplayers = GetPlayerArray().len()
			int idealMilitia = int ( ceil( float( maxplayers ) /2 ) )

			if(GetPlayerArrayOfTeam(TEAM_MILITIA).len() < idealMilitia)
				SetTeam(player, TEAM_MILITIA )
			else
				SetTeam(player, TEAM_IMC )

		}
		
		player.p.playerDamageDealt = 0.0
		player.SetPlayerNetInt( "damage", 0 )
		player.p.assignedMasterChief = -1
		if ( FlowState_ResetKillsEachRound() || is1v1EnabledAndAllowed() )
		{
			player.SetPlayerNetInt( "kills", 0 ) //Reset for kills
			player.SetPlayerNetInt( "assists", 0 ) //Reset for assists
			player.SetPlayerNetInt( "deaths", 0 ) //Reset for deaths
			player.SetPlayerGameStat( PGS_KILLS, 0 )
			player.SetPlayerGameStat( PGS_DEATHS, 0 )

			if( Playlist() == ePlaylists.fs_scenarios )
			{
				player.SetPlayerNetInt( "FS_Scenarios_PlayerScore", 0 )
				player.SetPlayerNetInt( "FS_Scenarios_MatchesWins", 0 )
			}
		}

		if( Flowstate_IsLGDuels() )
		{
			player.SetPlayerNetInt( "accuracy", 0 )
			player.p.totalLGHits = 0
			player.p.totalLGHits = 0
		}

		if( FlowState_Gungame() )
		{
			player.SetPlayerGameStat( PGS_TITAN_KILLS, 0 )
			// KillStreakAnnouncer(player, true)
		}

		if( FlowState_RandomGunsEverydie() )
		{
			player.SetPlayerGameStat( PGS_TITAN_KILLS, 0 )
			UpgradeShields(player, true)
		}	

		thread Flowstate_GrantSpawnImmunity(player, 2.5)
	}
	
	ResetAllPlayerStats()
	ResetMapVotes()
	file.winnerTeam = -1
	file.ringBoundary = CreateRingBoundary( file.selectedLocation )
	//printt("Flowstate DEBUG - Bubble created, executing SimpleChampionUI.")

	//printt("Flowstate DEBUG - TDM/FFA gameloop Round started.")
	
	//printt("Flowstate DEBUG - TDM/FFA gameloop Round started.")

	if( flowstateSettings.hackersVsPros )
	{
		// ResetAllPlayerStats() //was already performed? ~mkos
		int i
		int maxHackers = 3
		
		array<entity> allplayers = GetPlayerArray()
		allplayers.randomize()
		
		foreach (entity p in allplayers)
		{
			if (!IsValid(p)) continue

			// if(i >= maxHackers)
			// {
				// SetTeam(p, TEAM_MILITIA)
				// ClearHackerOrBecomePro(p)
				
				// thread function() : (p)
				// {
					// wait 12
					// if ( !IsValid( p ) ) return
					// Message(p, "HACKERS VS PROS", "You're a Pro")
				// }()			
			// }
			// else
			// {
				SetTeam(p, TEAM_IMC)
				BecomeHacker(p)
				
				thread function() : (p)
				{
					wait 12
					if ( !IsValid( p ) ) return
					Message(p, "HACKERS VS PROS", "You're a Hacker")
				}()
			// }
			// i++
		}
	}
	
	
	////////////////////////////////
	//// 		START DELAY 	////
	////////////////////////////////
	
	if( Flowstate_IsFSDM() || flowstateSettings.is_halo_gamemode )
		wait FLOWSTATE_START_TIME_DELAY
	
	////////////////////////////////
	//////// 	SET STATE 	////////
	////////////////////////////////
	
	SetTdmStateToInProgress()
	
	foreach( player in GetPlayerArray() )
	{
		if( !IsValid( player ) )
			continue

		if( !IsAlive( player ) )
			_HandleRespawn( player )

	}

	if( flowstateSettings.enable_oddball_gamemode )
	{
		SpawnBallSpawnerAtMapLocation( file.selectedLocation.name )
	}
	
	////////////////////////////////
	//////// 	TIMER BEGIN 	////
	////////////////////////////////

	float endTime = Time() + FlowState_RoundTime()
	g_fCurrentRoundEndTime = endTime //set global for server

	if( flowstateSettings.EndlessFFAorTDM )
	{
		WaitForever()
	}

	if ( FlowState_Timer() )
	{
		int round = 0
		bool isFinalRound = false
		if( file.currentRound == Flowstate_AutoChangeLevelRounds() && Flowstate_EnableAutoChangeLevel() )
		{
			round = 7
			isFinalRound = true
		}
		
		SetGlobalNetTime( "flowstate_DMRoundEndTime", endTime )
		// SetGlobalNetInt( "currentDeathFieldStage", round )
		// SetGlobalNetTime( "nextCircleStartTime", endTime )
		// SetGlobalNetTime( "circleCloseTime", endTime + 8 )

		// if( isFinalRound )
			// AddSurvivalCommentaryEvent( eSurvivalEventType.ROUND_TIMER_STARTED )
		// else
			// PlayAnnounce( "diag_ap_aiNotify_circleTimerStartNext_02" )
		
		if( file.currentRound > 1 && is1v1EnabledAndAllowed() )//only work after round 1 and 1v1 gamemode
		{
			foreach ( eachPlayer in GetPlayerArray() )
			{
				ResetPlayerStats( eachPlayer )
				
				if( !isPlayerInRestingList( eachPlayer ) ) //don't remove players who are in rest, only progress. 
				{
					soloModePlayerToWaitingList(eachPlayer)
				}

				try
				{
					eachPlayer.p.lastKiller = null
					eachPlayer.Die( null, null, { damageSourceId = eDamageSourceId.damagedef_despawn } )
				}
				catch (error)
				{}
			}
		}
		
		
		////////////////////////////////
		//// 	CORE TIMER LOOP 	////
		////////////////////////////////
		
		while( Time() <= endTime ) //Todo: Execute callbacks for gamemode and add via AddCallback_ShouldTimerEnd( int timeRemaining, bool functionref() condFunc )
		{
			if( flowstateSettings.hackersVsPros )
			{
				foreach(player in GetPlayerArray())
				{
					if ( !IsValid( player ) ) continue
					
					if(player.GetPlayerGameStat( PGS_KILLS ) >= HACKERS_VS_PRO_MAX_KILLS )
					{
						SetTdmStateToNextRound()
						break
					}
				}
			}

			if( flowstateSettings.enable_oddball_gamemode )
			{
				table< int,int > totalTeamsScore
				
				foreach(player in GetPlayerArray())
				{
					if ( !IsValid( player ) ) continue

					if( !( player.GetTeam() in totalTeamsScore ) )
					{
						totalTeamsScore[ player.GetTeam() ] <- player.GetPlayerNetInt( "oddball_ballHeldTime" )
					} else
					{
						totalTeamsScore[ player.GetTeam() ] += player.GetPlayerNetInt( "oddball_ballHeldTime" )
					}
				}

				foreach( team, score in totalTeamsScore )
				{
					if( score >= ODDBALL_POINTS_TO_WIN )
					{
						//set team as winner, show ui screen
						if( flowstateSettings.enable_oddball_gamemode && IsValid( GetBallCarrier() ) && IsAlive( GetBallCarrier() ) )
						{
							ClearBallCarrierPlayerSetup( GetBallCarrier() )
							SetEmptyBallInBallSpawner()
							SetBallCarrier( null )
						}

						SetTdmStateToNextRound()

						file.winnerTeam = team
						break
					}
				}
			}

			if( Time() == endTime - 60 )
				PlayAnnounce( "diag_ap_aiNotify_circleMoves60sec_01" )

			if( Time() == endTime - 30 )
				PlayAnnounce( "diag_ap_aiNotify_circleMoves30sec_01" )

			if( Time() == endTime - 10 )
				PlayAnnounce( "diag_ap_aiNotify_circleMoves10sec_01" )

			wait 1
		}
	}
	else if ( !FlowState_Timer() )
	{
		while( Time() <= endTime )
		{
			wait 1
		}
	}
	
	////////////////////////////////
	//////// 	TIMER END 	////////
	////////////////////////////////

	if( flowstateSettings.enable_oddball_gamemode && file.winnerTeam == -1 )
	{
		table< int,int > totalTeamsScore
		
		foreach(player in GetPlayerArray())
		{
			if ( !IsValid( player ) ) continue

			if( !( player.GetTeam() in totalTeamsScore ) )
			{
				totalTeamsScore[ player.GetTeam() ] <- player.GetPlayerNetInt( "oddball_ballHeldTime" )
			} else
			{
				totalTeamsScore[ player.GetTeam() ] += player.GetPlayerNetInt( "oddball_ballHeldTime" )
			}
		}
		
		int winnerTeam = -1
		int lastScore = 0
		bool isTie = false

		foreach( team, score in totalTeamsScore )
		{
			if( score > lastScore )
			{
				winnerTeam = team
				lastScore = score
			}
		}

		foreach( team, score in totalTeamsScore )
		{
			if( team == winnerTeam )
				continue
			
			if( lastScore == score )
			{
				isTie = true
			}
		}

		if( isTie )
			winnerTeam = -2

		file.winnerTeam = winnerTeam

		if( IsValid( GetBallCarrier() ) && IsAlive( GetBallCarrier() ) )
		{
			ClearBallCarrierPlayerSetup( GetBallCarrier() )
			SetEmptyBallInBallSpawner()
			SetBallCarrier( null )
		}
	}

	SetGlobalNetTime( "flowstate_DMRoundEndTime", -1 )
	SetTdmStateToNextRound()

	if( GetBestPlayer() != null )
		SurvivalCommentary_HostAnnounce( eSurvivalCommentaryBucket.WINNER )
	
	wait 1

	foreach( player in GetPlayerArray() )
	{
		if ( !IsValid( player ) ) 
			continue

		if( !IsAlive(player) && !player.p.isSpectating )
		{
			_HandleRespawn(player)
			ClearInvincible(player)
		}

		if( FlowState_RandomGunsEverydie() && FlowState_FIESTAShieldsStreak() )
		{
			PlayerRestoreShieldsFIESTA(player, player.GetShieldHealthMax())
			PlayerRestoreHPFIESTA(player, 100)
		} 
		else
			PlayerRestoreHP(player, 100, Equipment_GetDefaultShieldHP())
		
		ClientCommand( player, "-zoom" )
		//Remote_CallFunction_NonReplay(player, "Minimap_DisableDraw_Internal")
		Remote_CallFunction_ByRef( player, "Minimap_DisableDraw_Internal" )
		
		player.SetThirdPersonShoulderModeOn()
		player.HolsterWeapon()
		player.Server_TurnOffhandWeaponsDisabledOn()
		
		if( flowstateSettings.enable_oddball_gamemode  )
		{
			AddCinematicFlag( player, CE_FLAG_HIDE_MAIN_HUD | CE_FLAG_EXECUTION )

			if( file.winnerTeam >= -1 )
			{
				Remote_CallFunction_NonReplay( player, "FSDM_CustomWinnerScreen_Start", file.winnerTeam, 0 )
			} 
			else if( file.winnerTeam < -1 )
			{
				Remote_CallFunction_NonReplay( player, "FSDM_CustomWinnerScreen_Start", file.winnerTeam, 1 )
			}
			
			SetBallEntity( null )
		}
	}
	
	////////////////////////////////
	////	 	CHAMPION	 	////
	////////////////////////////////
	
	//set the champion even if reloading the map ~mkos
	int TeamWon = 69
	
	if( GetPlayerArray().len() == 1 && IsValid( gp()[0] ) )
		TeamWon = gp()[0].GetTeam() //DEBUG VALUE
	
	entity champion = GetBestPlayer()
	
	if( IsValid( champion ) )
	{
		TeamWon = champion.GetTeam()
		
		#if TRACKER
			Tracker_SetPlayerAsChampion( champion )
		#endif
	}
	
	foreach( roundPlayer in GetPlayerArray() )
		FSDM_SetMatchPersistentVarsForPlayer( roundPlayer )

	PIN_RoundEnd( file.currentRound ) //must be after champion determined.
	wait (2)
	// end ship
	
	////////////////////////////////
	//////// 	SCORE BOARD 	////
	////////////////////////////////

	if( SCOREBOARD_ENABLE )
		thread SendScoreboardToClient()
	
	wait flowstateSettings.endgame_delay

	if( flowstateSettings.BattleLogEnable )
		if( flowstateSettings.BattleLog_Linux )
			thread Flowstate_SaveBattleLogToFile_Linux()
		else
			thread Flowstate_SaveBattleLogToFile()

	if( flowstateSettings.ChatLogEnable )
		Flowstate_ServerSaveChat()

	// foreach( player in GetPlayerArray() )
	// {
		// if( !IsValid( player ) ) continue
		// RemoveCinematicFlag( player, CE_FLAG_HIDE_MAIN_HUD | CE_FLAG_EXECUTION )
		// if( GetCurrentPlaylistName() == "fs_movementgym" ) {
					// Message( player,"Movement Gym", "\n\n               Made by twitter.com/DEAFPS_ \n\n        With help from AyeZee#6969, Julefox#0050 & @CafeFPS", 7, "UI_Menu_RoundSummary_Results" )
				// }
		// player.SetThirdPersonShoulderModeOff()	
		// player.FreezeControlsOnServer()
	// }

	////////////////////////////////
	//// 		VOTING 			////
	////////////////////////////////

	if( !VOTING_PHASE_ENABLE )
	{
		WaitFrame()
	} 
	else
	{
		thread function() : ()
		{
			if(file.locationSettings.len() < NUMBER_OF_MAP_SLOTS_FSDM) 
			{
				VOTING_PHASE_ENABLE = false
				return
			}

			for( int i = 0; i < NUMBER_OF_MAP_SLOTS_FSDM; ++i )
			{
				while( true )
				{
					// Get a random location id from the available locations
					int randomId = RandomIntRange(0, file.locationSettings.len())

					// If the map already isnt picked for voting then append it to the array, otherwise keep looping till it finds one that isnt picked yet
					if( !FS_DM.mapIds.contains( randomId ) )
					{
						FS_DM.mapIds.append( randomId )
						break
					}
				}
			}
		}()		
	}
	
	////////////////////////////////
	//////// 	ROUND OVER 	////////
	////////////////////////////////
		
	if( file.currentRound == Flowstate_AutoChangeLevelRounds() && Flowstate_EnableAutoChangeLevel() )
	{
		foreach( player in GetPlayerArray() )
		{
			if ( player.p.isSpectating )
				endSpectate( player )
		}
		
		string matchEndingTitle = flowstateSettings.custom_match_ending_title
		string matchEndingMessage = flowstateSettings.custom_match_ending_message
		
		if( flowstateSettings.end_match_message )
		{
			foreach( player in GetPlayerArray() )
				Message( player, matchEndingTitle, matchEndingMessage, 6.0 )

			wait 6
		}
		
		if( FlowState_EnableMovementGymLogs() && FlowState_EnableMovementGym() )
				MovementGymSaveTimesToFile()
		
		
		////////////////////////////////
		////		SIGNAL STATS	////
		////////////////////////////////
		
		if( bLog() )
			FlagEnd( "START_LOG" ) //Shut down stats for this round.
		
		
		////////////////////////////////
		//////// 	NEXT MAP 	////////
		////////////////////////////////
		
		//cycle map /mkos
		string to_map = GetMapName()

		if ( flowstateSettings.rotate_map )
		{
			array<string> maplist = split( flowstateSettings.maplist, "," )
			int countmaps = maplist.len()
			int i;

			for ( i = 0; i < countmaps; i++ ) 
			{
				if ( GetMapName() == maplist[i] ) 
				{
					int index = (i + 1) % countmaps	
					to_map = maplist[index]
					break
				}
			}
		}

		waitthread g__InternalCheckReload()
		
		GameRules_ChangeMap( to_map, GetCurrentPlaylistName() )
	} //flowstate rounds
	
	
	////////////////////////////////
	//////// 	NEXT ROUND 	////////
	////////////////////////////////
	
	if( IsValid( file.ringBoundary ) )
		file.ringBoundary.Destroy()
	
	SetDeathFieldParams( <0,0,0>, 100000, 0, 90000, 99999 )
	
	if( is3v3Mode() )
	{
		FS_DM.scoreboardShowing = true
		FS_Scenarios_ForceAllRoundsToFinish()
	}
	else if( is1v1EnabledAndAllowed() )
		waitthread ForceAllRoundsToFinish_solomode()
	
	
	////////////////////////////////
	//////// 	SCOREBOARD 	////////
	////////////////////////////////
	if( SCOREBOARD_ENABLE )
	{
		FS_DM.scoreboardShowing = true
		
		foreach( player in GetPlayerArray() )
		{
			if( !IsValid( player ) )
				continue
			
			Remote_CallFunction_NonReplay( player, "ForceScoreboardLoseFocus" )
			
			if( flowstateSettings.is_halo_gamemode )
				Remote_CallFunction_NonReplay( player, "FS_ForceDestroyCustomAdsOverlay" )

			entity weapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
			
			if( IsValid( weapon ) && weapon.w.isInAdsCustom )
				weapon.w.isInAdsCustom = false

			Remote_CallFunction_Replay(player, "ServerCallback_FSDM_OpenVotingPhase", true)
			//Remote_CallFunction_NonReplay(player, "ServerCallback_FSDM_CoolCamera")
			Remote_CallFunction_ByRef( player, "ServerCallback_FSDM_CoolCamera" )
			Remote_CallFunction_Replay(player, "ServerCallback_FSDM_SetScreen", eFSDMScreen.ScoreboardUI, TeamWon, eFSDMScreen.NotUsed, eFSDMScreen.NotUsed)
			EmitSoundOnEntityOnlyToPlayer(player, player, "UI_Menu_RoundSummary_Results")
		}		

		wait 6
		
		if( !VOTING_PHASE_ENABLE )
		{
			// Close the votemenu for each player
			foreach( player in GetPlayerArray() )
			{
				if( !IsValid( player ) )
					continue
				
				ScreenFadeToBlack( player, 0.5, 0.6 ) // a little extra so we stay black
				// wait EMBARK_FADE_TIME
				// ScreenFadeFromBlack( player, EMBARK_FADE_TIME, EMBARK_FADE_TIME )
				// Remote_CallFunction_Replay(player, "ServerCallback_FSDM_OpenVotingPhase", false)
			}

			wait 0.7
			
			// foreach( player in GetPlayerArray() )
			// {
				// if( !IsValid( player ) )
					// continue
				
				// ScreenFadeToBlack( player, EMBARK_FADE_TIME, EMBARK_FADE_TIME + 0.2 ) // a little extra so we stay black
				// wait EMBARK_FADE_TIME
				// ScreenFadeFromBlack( player, EMBARK_FADE_TIME, EMBARK_FADE_TIME )
				// Remote_CallFunction_Replay(player, "ServerCallback_FSDM_OpenVotingPhase", false)
			// }
		}
		
		FS_DM.scoreboardShowing = false
	}
	
	
	////////////////////////////////////////////
	// 		SET STATE FOR INTERNAL CHECKS 	  //
	////////////////////////////////////////////
	
	waitthread g__InternalCheckReload()

	
	////////////////////////////////
	//////// 	VOTING 		////////
	////////////////////////////////

	if( VOTING_PHASE_ENABLE )
	{
			// Set voting to be allowed
			FS_DM.votingtime = true
			float endtimeVotingTime = Time() + 16
			
			// For each player, set voting screen and update maps that are picked for voting
			foreach( player in GetPlayerArray() )
			{
				if( !IsValid( player ) )
					continue
				//reset votes
				Remote_CallFunction_Replay(player, "ServerCallback_FSDM_UpdateMapVotesClient", FS_DM.mapVotes[0], FS_DM.mapVotes[1], FS_DM.mapVotes[2], FS_DM.mapVotes[3])
				
				Remote_CallFunction_Replay(player, "ServerCallback_FSDM_UpdateVotingMaps", FS_DM.mapIds[0], FS_DM.mapIds[1], FS_DM.mapIds[2], FS_DM.mapIds[3])
				Remote_CallFunction_Replay(player, "ServerCallback_FSDM_SetScreen", eFSDMScreen.VoteScreen, endtimeVotingTime, eFSDMScreen.NotUsed, eFSDMScreen.NotUsed)
			}

			wait 16

			FS_DM.votestied = false
			bool anyVotes = false

			// Make voting not allowed
			FS_DM.votingtime = false

			// See if there was any votes in the first place
			foreach( int votes in FS_DM.mapVotes )
			{
				if( votes > 0 )
				{
					anyVotes = true
					break
				}
			}

			if ( anyVotes )
			{
				// store the highest vote count for any of the maps
				int highestVoteCount = -1

				// store the last map id of the map that has the highest vote count
				int highestVoteId = -1

				// store map ids of all the maps with the highest vote count
				array<int> mapsWithHighestVoteCount


				for(int i = 0; i < NUMBER_OF_MAP_SLOTS_FSDM; ++i)
				{
					int votes = FS_DM.mapVotes[i]
					if( votes > highestVoteCount )
					{
						highestVoteCount = votes
						highestVoteId = FS_DM.mapIds[i]

						// we have a new highest, so clear the array
						mapsWithHighestVoteCount.clear()
						mapsWithHighestVoteCount.append(FS_DM.mapIds[i])
					}
					else if( votes == highestVoteCount ) // if this map also has the highest vote count, add it to the array
					{
						mapsWithHighestVoteCount.append(FS_DM.mapIds[i])
					}
				}

				// if there are multiple maps with the highest vote count then it's a tie
				if( mapsWithHighestVoteCount.len() > 1 )
				{
					FS_DM.votestied = true
				}
				else // else pick the map with the highest vote count
				{
					// Set the vote screen for each player to show the chosen location
					foreach( player in GetPlayerArray() )
					{
						if( !IsValid( player ) )
							continue

						Remote_CallFunction_Replay(player, "ServerCallback_FSDM_SetScreen", eFSDMScreen.SelectedScreen, eFSDMScreen.NotUsed, highestVoteId, eFSDMScreen.NotUsed)
					}

					// Set the location to the location that won
					FS_DM.mappicked = highestVoteId
				}

				if ( FS_DM.votestied )
				{
					foreach( player in GetPlayerArray() )
					{
						if( !IsValid( player ) )
							continue

						Remote_CallFunction_Replay(player, "ServerCallback_FSDM_SetScreen", eFSDMScreen.TiedScreen, eFSDMScreen.NotUsed, 42069, eFSDMScreen.NotUsed)
					}

					mapsWithHighestVoteCount.randomize()
					waitthread RandomizeTiedLocations(mapsWithHighestVoteCount)
				}
			}
			else // No one voted so pick random map
			{
				// Pick a random location id from the aviable locations
				FS_DM.mappicked = RandomIntRange(0, file.locationSettings.len() - 1)

				// Set the vote screen for each player to show the chosen location
				foreach( player in GetPlayerArray() )
				{
					if( !IsValid( player ) )
						continue

					Remote_CallFunction_Replay(player, "ServerCallback_FSDM_SetScreen", eFSDMScreen.SelectedScreen, eFSDMScreen.NotUsed, FS_DM.mappicked, eFSDMScreen.NotUsed)
				}
			}

			//wait for timing
			wait 5

			// Close the votemenu for each player
			foreach( player in GetPlayerArray() )
			{
				if( !IsValid( player ) )
					continue
				
				//ScreenCoverTransition_Player(player, Time() + 1)
				Remote_CallFunction_Replay(player, "ServerCallback_FSDM_OpenVotingPhase", false)
			}
		//wait 2
		// }
		
		// Clear players the voted for next voting
		FS_DM.votedPlayers.clear()

		// Clear mapids for next voting
		FS_DM.mapIds.clear()	
	}

	// foreach( player in GetPlayerArray() )
	// {
		// if( !IsValid( player ) ) continue
		
		// ClearInvincible( player )
		// //RemoveCinematicFlag( player, CE_FLAG_HIDE_MAIN_HUD | CE_FLAG_EXECUTION )
		// player.SetThirdPersonShoulderModeOff()
		// player.UnfreezeControlsOnServer()
	// }
	
	
	////////////////////////////////
	/////	 NEXT ROUND NOW 	////
	////////////////////////////////

	SetChampion( null )
	file.currentRound++
}

entity function GetMainRingBoundary()
{
	return file.ringBoundary
}

// purpose: display the UI for randomization of tied maps at the end of voting
void function RandomizeTiedLocations(array<int> maps)
{
    bool donerandomizing = false
    int randomizeammount = RandomIntRange(50, 75)
    int i = 0
    int mapslength = maps.len()
    int currentmapindex = 0
    int selectedamp = 0

    while (!donerandomizing)
    {
        // If currentmapindex is out of range set to 0
        if (currentmapindex >= mapslength)
            currentmapindex = 0

        // Update Randomizer ui for each player
        foreach( player in GetPlayerArray() )
        {
            if( !IsValid( player ) )
                continue

            Remote_CallFunction_Replay(player, "ServerCallback_FSDM_SetScreen", eFSDMScreen.TiedScreen, 69, maps[currentmapindex], 0)
        }

        // stop randomizing once the randomize ammount is done
        if (i >= randomizeammount)
        {
            donerandomizing = true
            selectedamp = currentmapindex
        }

        i++
        currentmapindex++

        if (i >= randomizeammount - 15 && i < randomizeammount - 5) // slow down voting randomizer speed
        {
            wait 0.15
        }
        else if (i >= randomizeammount - 5) // slow down voting randomizer speed
        {
            wait 0.25
        }
        else // default voting randomizer speed
        {
            wait 0.05
        }
    }

    // Show final selected map
    foreach( player in GetPlayerArray() )
    {
        if( !IsValid( player ) )
            continue

        Remote_CallFunction_Replay(player, "ServerCallback_FSDM_SetScreen", eFSDMScreen.TiedScreen, 69, maps[selectedamp], 1)
    }

    // Pause on selected map for a sec for visuals
    wait 0.5

    // Procede to final location picked screen
    foreach( player in GetPlayerArray() )
    {
        if( !IsValid( player ) )
            continue

        Remote_CallFunction_Replay(player, "ServerCallback_FSDM_SetScreen", eFSDMScreen.SelectedScreen, 69, maps[selectedamp], eFSDMScreen.NotUsed)
    }

    // Set selected location on server
    FS_DM.mappicked = maps[selectedamp]
}

void function ResetMapVotes()
{
    FS_DM.mapVotes.clear()
    FS_DM.mapVotes.resize( NUMBER_OF_MAP_SLOTS_FSDM )
}

//       ██ ██████  ██ ███    ██  ██████  ██
//      ██  ██   ██ ██ ████   ██ ██        ██
//      ██  ██████  ██ ██ ██  ██ ██   ███  ██
//      ██  ██   ██ ██ ██  ██ ██ ██    ██  ██
//       ██ ██   ██ ██ ██   ████  ██████  ██
// Purpose: Create The RingBoundary
entity function CreateRingBoundary(LocationSettings location)

{
    array<LocPair> spawns = location.spawns

    vector ringCenter
    foreach( spawn in spawns )
    {
        ringCenter += spawn.origin
    }

    ringCenter /= spawns.len() > 0 ? spawns.len() : 1 ;

    float ringRadius = 0

    foreach( LocPair spawn in spawns )
    {
        if( Distance( spawn.origin, ringCenter ) > ringRadius )
            ringRadius = Distance(spawn.origin, ringCenter)
    }

    ringRadius += flowstateSettings.ring_radius_padding

    if ( file.selectedLocation.name == "Shipment By AyeZee" )
        ringRadius += 20000
	
    if ( file.selectedLocation.name == "Killhouse By AyeZee" )
        ringRadius += 20000

    if ( file.selectedLocation.name == "Nuketown By AyeZee" )
        ringRadius += 20000

    if ( file.selectedLocation.name == "Killyard" )
        ringRadius += 20000
	
    if ( file.selectedLocation.name == "Dustment by DEAFPS" )
        ringRadius += 20000
	
    if ( file.selectedLocation.name == "Shoothouse by DEAFPS" )
        ringRadius += 20000
	
    if ( file.selectedLocation.name == "Rust By DEAFPS" )
        ringRadius += 20000
	
    if ( file.selectedLocation.name == "Noshahr Canals by DEAFPS" )
        ringRadius += 20000
	
    if ( file.selectedLocation.name == "Movement Gym" )
        ringRadius = 99999

    if ( file.selectedLocation.name == "The Pit" || file.selectedLocation.name == "Lockout"  || file.selectedLocation.name == "Narrows" )
        ringRadius = 99999
	
	if( file.selectedLocation.name == "Beaver Creek" )
		ringRadius += 5000

    if( is1v1EnabledAndAllowed() ) //we dont need rings in 1v1 mode
    	ringRadius = 99999

	//We watch the ring fx with this entity in the threads
	entity circle = CreateEntity( "prop_script" )
	circle.SetValueForModelKey( $"mdl/fx/ar_survival_radius_1x100.rmdl" )
	circle.kv.fadedist = -1
	circle.kv.modelscale = ringRadius
	circle.kv.renderamt = 255
	circle.kv.rendercolor = FlowState_RingColor()
	circle.kv.solid = 0
	circle.kv.VisibilityFlags = ENTITY_VISIBLE_TO_EVERYONE
	circle.SetOrigin( ringCenter )
	circle.SetAngles( <0, 0, 0> )
	circle.NotSolid()
	circle.DisableHibernation()
    circle.Minimap_SetObjectScale( min(ringRadius / SURVIVAL_MINIMAP_RING_SCALE, 1) )
    circle.Minimap_SetAlignUpright( true )
    circle.Minimap_SetZOrder( 2 )
    circle.Minimap_SetClampToEdge( true )
    circle.Minimap_SetCustomState( eMinimapObject_prop_script.OBJECTIVE_AREA )
	SetTargetName( circle, "hotZone" )
	DispatchSpawn(circle)

    foreach ( player in GetPlayerArray() )
    {
        circle.Minimap_AlwaysShow( 0, player )
    }

	SetDeathFieldParams( ringCenter, ringRadius, ringRadius, 90000, 99999 ) // This function from the API allows client to read ringRadius from server so we can use visual effects in shared function. Colombia

	//Audio thread for ring
	if( ringRadius != 99999 && !Flowstate_IsMovementGym() ){
		foreach(sPlayer in GetPlayerArray())
			thread AudioThread(circle, sPlayer, ringRadius)
	}

	//Damage thread for ring
	thread RingDamage(circle, ringRadius)

    return circle
}

void function AudioThread(entity circle, entity player, float radius)

{
	EndSignal(player, "OnDestroy")
	entity audio
	string soundToPlay = "Survival_Circle_Edge_Small"
	OnThreadEnd(
		function() : ( soundToPlay, audio)
		{

			if(IsValid(audio)) audio.Destroy()
		}
	)
	audio = CreateScriptMover()
	audio.SetOrigin( circle.GetOrigin() )
	audio.SetAngles( <0, 0, 0> )
	EmitSoundOnEntity( audio, soundToPlay )

	while(IsValid(circle)){
		if ( !IsValid( player ) ) continue
		vector fwdToPlayer   = Normalize( <player.GetOrigin().x, player.GetOrigin().y, 0> - <circle.GetOrigin().x, circle.GetOrigin().y, 0> )
		vector circleEdgePos = circle.GetOrigin() + (fwdToPlayer * radius)
		circleEdgePos.z = player.EyePosition().z
		if ( fabs( circleEdgePos.x ) < 61000 && fabs( circleEdgePos.y ) < 61000 && fabs( circleEdgePos.z ) < 61000 )
		{
			audio.SetOrigin( circleEdgePos )
		}
		WaitFrame()
	}

	StopSoundOnEntity(audio, soundToPlay)
}

void function RingDamage( entity circle, float currentRadius)

{
	WaitFrame()
	const float DAMAGE_CHECK_STEP_TIME = 1.5

	while ( IsValid(circle) )
	{
		foreach ( dummy in GetNPCArray() )
		{
			if ( dummy.IsPhaseShifted() )
				continue

			float playerDist = Distance2D( dummy.GetOrigin(), circle.GetOrigin() )
			if ( playerDist > currentRadius )
			{
				dummy.TakeDamage( int( Deathmatch_GetOOBDamagePercent() / 100 * float( dummy.GetMaxHealth() ) ), null, null, { scriptType = DF_BYPASS_SHIELD | DF_DOOMED_HEALTH_LOSS, damageSourceId = eDamageSourceId.deathField } )
			}
		}

		foreach ( player in GetPlayerArray_Alive() )
		{
			if ( player.IsPhaseShifted() )
				continue

			float playerDist = Distance2D( player.GetOrigin(), circle.GetOrigin() )
			if ( playerDist > currentRadius )
			{
				Remote_CallFunction_Replay( player, "ServerCallback_PlayerTookDamage", 0, 0, 0, 0, DF_BYPASS_SHIELD | DF_DOOMED_HEALTH_LOSS, eDamageSourceId.deathField, null )
				player.TakeDamage( int( Deathmatch_GetOOBDamagePercent() / 100 * float( player.GetMaxHealth() ) ), null, null, { scriptType = DF_BYPASS_SHIELD | DF_DOOMED_HEALTH_LOSS, damageSourceId = eDamageSourceId.deathField } )
			}
		}
		wait DAMAGE_CHECK_STEP_TIME
	}
}

void function PlayerRestoreHP(entity player, float health, float shields)
{
	if ( !IsValid( player ) ) return
	if( !IsAlive( player) ) return

	player.SetHealth( health )
	Inventory_SetPlayerEquipment(player, "helmet_pickup_lv3", "helmet")
	if(shields == 0) return
	else if(shields <= 50)
		Inventory_SetPlayerEquipment(player, "armor_pickup_lv1", "armor")
	else if(shields <= 75)
		Inventory_SetPlayerEquipment(player, "armor_pickup_lv2", "armor")
	else if(shields <= 100)
		Inventory_SetPlayerEquipment(player, "armor_pickup_lv3", "armor")
	else if(shields <= 125)
		Inventory_SetPlayerEquipment(player, "armor_pickup_lv5", "armor")
	player.SetShieldHealth( shields )
}

 // ██████  ██████  ███████ ███    ███ ███████ ████████ ██  ██████ ███████     ███████ ██    ██ ███    ██  ██████ ████████ ██  ██████  ███    ██ ███████
// ██      ██    ██ ██      ████  ████ ██         ██    ██ ██      ██          ██      ██    ██ ████   ██ ██         ██    ██ ██    ██ ████   ██ ██
// ██      ██    ██ ███████ ██ ████ ██ █████      ██    ██ ██      ███████     █████   ██    ██ ██ ██  ██ ██         ██    ██ ██    ██ ██ ██  ██ ███████
// ██      ██    ██      ██ ██  ██  ██ ██         ██    ██ ██           ██     ██      ██    ██ ██  ██ ██ ██         ██    ██ ██    ██ ██  ██ ██      ██
 // ██████  ██████  ███████ ██      ██ ███████    ██    ██  ██████ ███████     ██       ██████  ██   ████  ██████    ██    ██  ██████  ██   ████ ███████

void function HaloMod_HandlePlayerModel( entity player )
{
	int assignedColor
	
	if( player.p.assignedMasterChief == -1 )
	{
		printt( "new master chief assigned, color:", assignedColor, player )

		if( RandomInt( 15 ) == 0 )
			assignedColor = 420
		else
		{
			if( file.haloModAvailableColors.len() > 0 )
				assignedColor = file.haloModAvailableColors.getrandom()
			else
			{
				file.haloModAvailableColors = [ 0, 1, 2, 3, 4, 5, 6, 7 ]
				assignedColor = file.haloModAvailableColors.getrandom()
			}

			file.haloModAvailableColors.fastremovebyvalue( assignedColor )
		}

		player.p.assignedMasterChief = assignedColor
	} else
		assignedColor = player.p.assignedMasterChief

	switch( assignedColor )
	{
		case 0:
		player.SetBodyModelOverride( $"mdl/Humans/pilots/w_master_chief_yellow.rmdl" )
		player.SetArmsModelOverride( $"mdl/Humans/pilots/ptpov_master_chief_yellow.rmdl" )
		break
		
		case 1:
		player.SetBodyModelOverride( $"mdl/Humans/pilots/w_master_chief_white.rmdl" )
		player.SetArmsModelOverride( $"mdl/Humans/pilots/ptpov_master_chief_white.rmdl" )
		break
		
		case 2:
		player.SetBodyModelOverride( $"mdl/Humans/pilots/w_master_chief_red.rmdl" )
		player.SetArmsModelOverride( $"mdl/Humans/pilots/ptpov_master_chief_red.rmdl" )
		break
		
		case 3:
		player.SetBodyModelOverride( $"mdl/Humans/pilots/w_master_chief_purple.rmdl" )
		player.SetArmsModelOverride( $"mdl/Humans/pilots/ptpov_master_chief_purple.rmdl" )
		break
		
		case 4:
		player.SetBodyModelOverride( $"mdl/Humans/pilots/w_master_chief_pink.rmdl" )
		player.SetArmsModelOverride( $"mdl/Humans/pilots/ptpov_master_chief_pink.rmdl" )
		break
		
		case 5:
		player.SetBodyModelOverride( $"mdl/Humans/pilots/w_master_chief_orange.rmdl" )
		player.SetArmsModelOverride( $"mdl/Humans/pilots/ptpov_master_chief_orange.rmdl" )
		break
		
		case 6:
		player.SetBodyModelOverride( $"mdl/Humans/pilots/w_master_chief_blue.rmdl" )
		player.SetArmsModelOverride( $"mdl/Humans/pilots/ptpov_master_chief_blue.rmdl" )
		break

		case 7:
		player.SetBodyModelOverride( $"mdl/Humans/pilots/w_master_chief.rmdl" )
		player.SetArmsModelOverride( $"mdl/Humans/pilots/ptpov_master_chief.rmdl" )
		break
		
		case 420:
		player.SetBodyModelOverride( $"mdl/flowstate_custom/w_haloelite.rmdl" )
		player.SetArmsModelOverride( $"mdl/flowstate_custom/ptpov_haloelite.rmdl" )
		break
	}

	#if DEVELOPER
	if( player.GetPlayerName() == "7bt2ft55kl7i" || player.GetPlayerName() == "r5r_ColombiaFPS" )
	{
		player.SetBodyModelOverride( $"mdl/flowstate_custom/w_haloelite.rmdl" )
		player.SetArmsModelOverride( $"mdl/flowstate_custom/ptpov_haloelite.rmdl" )
	}
	#endif
}

void function CharSelect( entity player)
{
	DumpStack()
	//Char select.
	file.characters = clone GetAllCharacters()
	if(FlowState_ForceAdminCharacter() && IsAdmin(player))
	{
		ItemFlavor PersonajeEscogido = file.characters[FlowState_ChosenAdminCharacter()]
		CharacterSelect_AssignCharacter( ToEHI( player ), PersonajeEscogido )
	} else if( !flowstateSettings.is_halo_gamemode )
	{
		int chosen = FlowState_ChosenCharacter()
		
		if( FlowState_ChosenCharacter() > 10 )
			chosen = 5
		
		ItemFlavor PersonajeEscogido = file.characters[ chosen ]
		CharacterSelect_AssignCharacter( ToEHI( player ), PersonajeEscogido )
	}

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
	
	if( !is1v1EnabledAndAllowed() )
	{
		player.GiveWeapon( "mp_weapon_melee_survival", WEAPON_INVENTORY_SLOT_PRIMARY_2, [] )
		player.GiveOffhandWeapon( "melee_pilot_emptyhanded", OFFHAND_MELEE, [] )
	}

	//Give master chief skin and assign a color
	if( flowstateSettings.is_halo_gamemode )
	{
		CharacterSelect_AssignCharacter( ToEHI( player ), GetAllCharacters()[5] )

		ItemFlavor playerCharacter = LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_CharacterClass() )
		asset characterSetFile = CharacterClass_GetSetFile( playerCharacter )
		player.SetPlayerSettingsWithMods( characterSetFile, [] )

		player.TakeOffhandWeapon(OFFHAND_TACTICAL)
		player.TakeOffhandWeapon(OFFHAND_ULTIMATE)
		TakeAllPassives(player)
	}
}

void function AssignCharacter( entity player, int index )
{
	ItemFlavor PersonajeEscogido = GetAllCharacters()[index]
	CharacterSelect_AssignCharacter( ToEHI( player ), PersonajeEscogido )		
	
	ItemFlavor playerCharacter = LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_CharacterClass() )
	asset characterSetFile = CharacterClass_GetSetFile( playerCharacter )
	player.SetPlayerSettingsWithMods( characterSetFile, [] )

	TakeAllWeapons(player)
}
// ███████  ██████  ██████  ██████  ███████ ██████   ██████   █████  ██████  ██████
// ██      ██      ██    ██ ██   ██ ██      ██   ██ ██    ██ ██   ██ ██   ██ ██   ██
// ███████ ██      ██    ██ ██████  █████   ██████  ██    ██ ███████ ██████  ██   ██
     // ██ ██      ██    ██ ██   ██ ██      ██   ██ ██    ██ ██   ██ ██   ██ ██   ██
// ███████  ██████  ██████  ██   ██ ███████ ██████   ██████  ██   ██ ██   ██ ██████

void function Message( entity player, string text, string subText = "", float duration = 7.0, string sound = "" )
{
	if( !IsValid( player )) return
	if( !player.IsPlayer() ) return //mkos ( crash fix )
	if ( !player.p.isConnected ) return
	if ( ( text.len() + subText.len() ) >= 599 ) return //mkos (added code rock prevention)

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

void function Message_New( entity player, string text, float duration = 7.0, string sound = "" )
{
	if( !IsValid( player ) || !player.p.isConnected )
		return
	
	string sendMessage = text
	for ( int i = 0; i < sendMessage.len(); i++ )
	{
		Remote_CallFunction_NonReplay( player, "fs_NewBoxBuildMessage", 0, sendMessage[i] )
	}

	Remote_CallFunction_NonReplay( player, "fs_NewBoxShowMessage", duration )

	if ( sound != "" )
		thread EmitSoundOnEntityOnlyToPlayer( player, player, sound )
}
// The challenger
entity function PlayerWithMostDamage()
{
    int bestDamage = 0
	entity bestPlayer

    foreach(player in GetPlayerArray()) {
        if ( !IsValid( player ) ) continue
        if (int(player.p.playerDamageDealt) > bestDamage) {
            bestDamage = int(player.p.playerDamageDealt)
            bestPlayer = player

        }
    }
    return bestPlayer
}

// challenger's score
int function GetDamageOfPlayerWithMostDamage()
{
    int bestDamage = 0
    foreach(player in GetPlayerArray()) {
        if ( !IsValid( player ) ) continue
        if (int(player.p.playerDamageDealt) > bestDamage) bestDamage = int(player.p.playerDamageDealt)
    }
    return bestDamage
}

//By @CafeFPS (CafeFPS)
string function PlayerWithMostDamageName()
{
	entity player = PlayerWithMostDamage()
	if ( !IsValid( player ) )
		return "-still nobody-"

	return player.GetPlayerName()
}

// the champion
entity function GetBestPlayer()
{
    int bestScore = 0
	entity bestPlayer

    foreach( player in GetPlayerArray() )
	{
        if ( !IsValid( player ) )
			continue
		
		switch( Playlist() )
		{
			case ePlaylists.fs_scenarios:
				
				int evalScore = ScenariosPersistence_GetScore( player.GetPlatformUID(), FS_ScoreType.PLAYERSCORE )
				
				if ( evalScore > bestScore )
				{
					bestScore = evalScore
					bestPlayer = player
				}
			break
			
			default:
			
				if ( player.GetPlayerGameStat( PGS_KILLS ) > bestScore ) 
				{
					bestScore = player.GetPlayerGameStat( PGS_KILLS )
					bestPlayer = player
				}
				
			break
		}
    }
	
	if( bestScore == 0 )
		bestPlayer = null
		
    return bestPlayer
}

//Todo: Deprecate( not used )
// champion's score
int function GetBestPlayerScore()
{
    int bestScore = 0
    foreach(player in GetPlayerArray())
	{
        if ( !IsValid( player ) )
			continue

        if (player.GetPlayerGameStat( PGS_KILLS ) > bestScore)
			bestScore = player.GetPlayerGameStat( PGS_KILLS )
    }
    return bestScore
}

//Todo: Deprecate( not used )
string function GetBestPlayerName()
{
	entity player = GetBestPlayer()
	if ( !IsValid( player ) )
		return "-still nobody-"
	string champion = player.GetPlayerName()
	return champion
}

//By michae\l/#1125 & @CafeFPS
float function getkd(int kills, int deaths)
{

	if(deaths == 0)
		return kills.tofloat();

	float kd = kills.tofloat() / deaths.tofloat()
	kd = kd*100

	int floorkd = int(floor(kd+0.5))
	kd = (float(floorkd))/100
	return kd
}

void function SendScoreboardToClient()
{
	foreach(entity sPlayer in GetPlayerArray())
	{
		if ( !IsValid( sPlayer ) ) continue
		
		Remote_CallFunction_NonReplay(sPlayer, "ServerCallback_ClearScoreboardOnClient")
		
		thread function() : (sPlayer)
		{
			foreach(entity player in GetPlayerArray())
			{
				if ( !IsValid( player ) ) continue
				
				PlayerInfo p
				p.eHandle = player.GetEncodedEHandle()
				p.score = player.GetPlayerGameStat( PGS_KILLS )
				p.deaths = player.GetPlayerGameStat( PGS_DEATHS )
				p.kd = getkd(p.score,p.deaths)
				p.damage = int(player.p.playerDamageDealt)
				p.lastLatency = int(player.GetLatency()* 1000)
				
				Remote_CallFunction_NonReplay(sPlayer, "ServerCallback_SendScoreboardToClient", p.eHandle, p.score, p.deaths, p.kd, p.damage, p.lastLatency)
			}
		}()
	}
	
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
		// p.team = player.GetTeam()
		p.score = player.GetPlayerGameStat( PGS_KILLS )
		p.deaths = player.GetPlayerGameStat( PGS_DEATHS )
		p.kd = getkd(p.score,p.deaths)
		p.damage = int(player.p.playerDamageDealt)
		// p.lastLatency = int(player.GetLatency()* 1000)

		if (fromConsole && player.p.isSpectating && IsAlive(player))
			spectators.append(p)
		else
			playersInfo.append(p)
	}
	playersInfo.sort(ComparePlayerInfo)
	string msg = ""
	for(int i = 0; i < min(6, playersInfo.len()); i++)
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

					if (fromConsole && player.p.isSpectating && IsAlive(player)) {spectators.append(p)}
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

void function ResetAllPlayerStats()
{
    foreach( player in GetPlayerArray() ) 
	{
        if ( !IsValid( player ) ) 
			continue
			
        ResetPlayerStats( player )
    }
}

void function ResetPlayerStats( entity player )
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
	player.p.playerDamageDealt = 0
}

void function PlayAnnounce( string sound )
{
	foreach( player in GetPlayerArray_Alive() )
	{
		EmitSoundAtPositionOnlyToPlayer( TEAM_ANY, player.GetOrigin() + < 500, 500, 500 >, player, sound )
		EmitSoundAtPositionOnlyToPlayer( TEAM_ANY, player.GetOrigin() + < 1000, 500, 1000 >, player, sound )
	}
}

//  ██████ ██      ██ ███████ ███    ██ ████████      ██████  ██████  ███    ███ ███    ███ ███    ███  █████  ███    ██ ██████  ███████
// ██      ██      ██ ██      ████   ██    ██        ██      ██    ██ ████  ████ ████  ████ ████  ████ ██   ██ ████   ██ ██   ██ ██
// ██      ██      ██ █████   ██ ██  ██    ██        ██      ██    ██ ██ ████ ██ ██ ████ ██ ██ ████ ██ ███████ ██ ██  ██ ██   ██ ███████
// ██      ██      ██ ██      ██  ██ ██    ██        ██      ██    ██ ██  ██  ██ ██  ██  ██ ██  ██  ██ ██   ██ ██  ██ ██ ██   ██      ██
//  ██████ ███████ ██ ███████ ██   ████    ██         ██████  ██████  ██      ██ ██      ██ ██      ██ ██   ██ ██   ████ ██████  ███████

void function __InitAdmins()
{
	array<string> Split = split( flowstateSettings.Admins , " ")

	foreach(string data in Split)
	{
		string username = strip(data)
		if(username != " " && file.mAdmins.find(username) == -1)
		file.mAdmins.append(username)
	}
}

bool function ClientCommand_adminlogin(entity player, array < string > args) 
{
	if(!IsValid(player) || file.authkey == "" || args.len() != 1 || file.mAdmins.find(player.GetPlayerName()) == -1 || args[0] != file.authkey) return false

	player.p.isAdmin = true
	Message(player, "Log in successful")
	return true
}

string function GetOwnerName()
{
	if(file.mAdmins.len() != 0)
		return file.mAdmins[0]
	else
		return ""

	unreachable
}

bool function IsAdmin( entity player )
{
	if(file.authkey == "") return false
	
	return player.p.isAdmin
}

bool function ClientCommand_VoteForMap(entity player, array<string> args)
{
	if ( !IsValid( player ) )
		return false
	
	if( args.len() != 1 )
		return false

    // don't allow multiple votes
    if ( FS_DM.votedPlayers.contains( player ) )
        return false

    // dont allow votes if its not voting time
    if ( !FS_DM.votingtime )
        return false

    // get map id from args
    int mapid = args[0].tointeger()

    // reject map ids that are outside of the range
    if ( mapid >= NUMBER_OF_MAP_SLOTS_FSDM || mapid < 0 )
        return false

    // add a vote for selected maps
    FS_DM.mapVotes[mapid]++

    // update current amount of votes for each map
    foreach( p in GetPlayerArray() )
    {
        if( !IsValid( p ) )
            continue

        Remote_CallFunction_Replay(p, "ServerCallback_FSDM_UpdateMapVotesClient", FS_DM.mapVotes[0], FS_DM.mapVotes[1], FS_DM.mapVotes[2], FS_DM.mapVotes[3])
    }

    // append player to the list of players the voted so they cant vote again
    FS_DM.votedPlayers.append(player)

    return true
}

bool function CC_TDM_Weapon_Selector_Open( entity player, array<string> args )
{
	//green highlight?
	
	return true
}

float function getcontrollerratio(int count, int kills)
//By michae\l/#1125 & @CafeFPS
{
	float cCount
	int floorcCount
	if(count == 0) return 0
	cCount = count.tofloat()/kills.tofloat() 
	cCount = cCount*100
	floorcCount = int(floor(cCount+0.5))
	cCount = (float(floorcCount))/100
	return cCount
}

bool function ClientCommand_FlowstateKick(entity player, array < string > args) {
    if ( !IsValid(player) || !IsAdmin(player) || args.len() == 0 ) return false

    foreach(sPlayer in GetPlayerArray()) {
        if (sPlayer.GetPlayerName() == args[0]) 
		{
			Warning("[Flowstate] -> Kicking " + sPlayer.GetPlayerName() + ":" + sPlayer.GetPlatformUID() + " -> [By Admin!]")
			KickPlayerById( sPlayer.GetPlatformUID(), "Kicked by admin" )
            return true
        }
    }
    return false
}


bool function ClientCommand_SpectateEnemies(entity player, array<string> args)
{
	if( !IsValid(player) )
		return false

	if( flowstateSettings.flowstate_1v1mode )
		return false
	
    if ( GetGameState() == eGameState.MapVoting || GetGameState() == eGameState.WaitingForPlayers || file.tdmState == eTDMState.NEXT_ROUND_NOW || !player.p.isSpectating && !IsAlive( player ) )
        return false

	if( Time() - player.p.lastTimeSpectateUsed < 3 )
	{
		//Message( player, "An error has occured", "It is in cool down. Please try again later." )
		LocalMsg( player, "#FS_ERROR_OCCURED", "#FS_COOLDOWN" )
		return false
	}
	
    array<entity> enemiesArray = GetPlayerArray_Alive()
	enemiesArray.fastremovebyvalue( player )
    
	if ( enemiesArray.len() > 0 )
    {
        entity specTarget = enemiesArray.getrandom()

        if( !IsValid(specTarget) )
        {
            //printf("error: try again")
			//Message( player, "An error has occured", "You could not specate the player you were trying to spectate. Please try again later." )
            LocalMsg( player, "#FS_ERROR_OCCURED", "#FS_COULD_NOT_SPECTATE" )
			return false
        }

        if( IsValid(player) && player.GetPlayerNetInt( "spectatorTargetCount" ) > 0 && player.p.isSpectating )
        {
			player.p.isSpectating = false
			player.SetPlayerNetInt( "spectatorTargetCount", 0 )
	        player.SetSpecReplayDelay( 0 )
			player.SetObserverTarget( null )
            player.StopObserverMode()
			player.p.lastTimeSpectateUsed = Time()
			_HandleRespawn( player )
        }
        else if( IsValid(player) && player.GetPlayerNetInt( "spectatorTargetCount" ) == 0 && IsValid(specTarget) )
        {
			try{
				player.p.isSpectating = true
				player.Die( null, null, { damageSourceId = eDamageSourceId.damagedef_suicide } )
				player.SetPlayerNetInt( "spectatorTargetCount", GetPlayerArray().len() )
				player.SetObserverTarget( specTarget )
				player.SetSpecReplayDelay( 5 )
				player.StartObserverMode( OBS_MODE_IN_EYE )				
				thread CheckForObservedTarget(player)
				player.p.lastTimeSpectateUsed = Time()
			} 
			catch(e420)
			{
				LocalMsg( player, "#FS_ERROR_OCCURED", "#FS_ERROR_OCCURED2" )
				//Message( player, "An error has occured", "Unknown error occurred. Please try again later." )
			}
        }
    }
    else
    {
        //printt("There is no one to spectate!")
		//Message( player, "An error has occured", "There are no players available to spectate. Please try again later." )
		LocalMsg( player, "#FS_ERROR_OCCURED", "#FS_NO_PLAYERS_TO_SPEC" )
	}
    return true
}

string function helpMessage()
{
	return "\n\n           CONSOLE COMMANDS:\n\n " +
	"1. 'kill_self': if you get stuck.\n" +
	"2. 'spectate': spectate enemies!\n" +
	"3. 'commands': display this message again"
}

bool function ClientCommand_Say(entity player, array<string> args)
{
    if (!IsValid(player) || args.len() == 0) return false

	string finalMsg = player.GetPlayerName() + " "
	
	foreach(arg in args)
	{
		if(arg == "say") continue
		
		finalMsg+=arg
	}
	
	file.allChatLines.append(finalMsg)
	
	return true
}

bool function ClientCommand_ShowLatency(entity player, array<string> args)
{
	if( !IsValid(player) )
		return false
	
    try{
    	Message(player,"Latency board", LatencyBoard(), 8.420)
    }catch(e) {}

    return true
}

array<string> function GetWhiteListedWeapons()
{
	return file.blacklistedWeapons
}

array<string> function GetWhiteListedAbilities()
{
	return file.blacklistedAbilities
}

bool function IsForcedlyDisabledWeapon( string weapon ) 
{
	switch( weapon )
	{
		case "mp_weapon_raygun":
		case "mp_weapon_throwingknife":
		case "mp_weapon_pdw":
		case "mp_weapon_lstar":
		//case "mp_weapon_sniper":
		return true
	}
	
	return false
}

bool function ClientCommand_GiveWeapon(entity player, array<string> args)
{	
	bool bRestFlag = false
	
	if( !IsValid( player ) || !IsAlive( player ) || args.len() < 2 )
		return true
	
	int uiType = eMsgUI.DEFAULT
	
	if( args[0] == "wepmenu" )
	{
		args.remove(0)
		uiType = eMsgUI.WAVE
	}
	
	#if DEVELOPER 
		print_string_array( args )
	#endif

    if ( FlowState_AdminTgive() && !IsAdmin(player) )
	{
		//Message(player, "ERROR", "Admin has disabled TDM Weapons dev menu.")
		LocalMsg( player, "#FS_ERROR", "#FS_DisabledTDMWeps", uiType )
		return true
	}

	if(args.len() < 2) return true

	if( is1v1EnabledAndAllowed() && isPlayerInRestingList( player ) )
	{	
		bRestFlag = true
		//Message( player, "NOT ALLOWED IN RESTING MODE" )
		//return false
	}
	
	if( is1v1EnabledAndAllowed() && isPlayerInWaitingList( player ) )
	{
		//Message( player, "NOT ALLOWED IN WAITING MODE" )
		LocalMsg( player, "#FS_NotAllowedWaiting", "", uiType )
		return true
	}
	
	if( is1v1EnabledAndAllowed() && !isCustomWeaponAllowed() && !isPlayerInChallenge( player ) )
	{
		LocalMsg( player, "#FS_CustomWepChalOnly", "", uiType )
		return true
	}

	if( is1v1EnabledAndAllowed() && args[0] != "p" && args[0] != "s" )
		return true

	if( !SURVIVAL_Loot_IsRefValid( args[1] ) || IsForcedlyDisabledWeapon( args[1] ) )
	{
		//Message( player, "WEAPON NOT ALLOWED :(" )
		LocalMsg( player, "#FS_WepNotAllowed", "", uiType )
		return true
	}

    if(file.blacklistedWeapons.len() && file.blacklistedWeapons.find(args[1]) != -1)
	{
		//Message(player, "WEAPON BLACKLISTED")
		LocalMsg( player, "#FS_WepBlacklisted", "", uiType )
		return true
	}

	if( file.blacklistedAbilities.len() && file.blacklistedAbilities.find(args[1]) != -1 )
	{
		//Message(player, "ABILITY BLACKLISTED")
		LocalMsg( player, "FS_AbilityBlacklisted", "", uiType )
		return true
	}

	if( Time() < player.p.lastTgiveUsedTime + FlowState_TgiveDelay() )
	{
		//Message(player, "TGIVE COOLDOWN")
		LocalMsg( player, "#FS_TgiveCooldown", "", uiType )
		return true
	}
	
	entity weapon

	try 
	{
		switch(args[0])
		{
			case "p":
			case "primary":

				LootData data = SURVIVAL_Loot_GetLootDataByRef( args[1] )
				if ( data.lootType != eLootType.MAINWEAPON )
					return true

				entity primary = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 )
				if( IsValid( primary ) )
					player.TakeWeaponByEntNow( primary )

				weapon = player.GiveWeapon(args[1], WEAPON_INVENTORY_SLOT_PRIMARY_0)

				SetupInfiniteAmmoForWeapon( player, weapon )
			break
			case "s":
			case "secondary":

				LootData data = SURVIVAL_Loot_GetLootDataByRef( args[1] )
				if ( data.lootType != eLootType.MAINWEAPON )
					return true

				entity secondary = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_1 )
				if( IsValid( secondary ) )
					player.TakeWeaponByEntNow( secondary )

				weapon = player.GiveWeapon(args[1], WEAPON_INVENTORY_SLOT_PRIMARY_1)

				SetupInfiniteAmmoForWeapon( player, weapon )
			break
			case "t":
			case "tactical":
				entity tactical = player.GetOffhandWeapon( OFFHAND_LEFT )
				if ( IsValid( tactical ) )
					player.TakeOffhandWeapon( OFFHAND_TACTICAL )

				tactical = player.GiveOffhandWeapon(args[1], OFFHAND_TACTICAL)
			break
			case "u":
			case "ultimate":
				entity ultimate = player.GetOffhandWeapon( OFFHAND_ULTIMATE )
				if( IsValid( ultimate ) )
					player.TakeOffhandWeapon( OFFHAND_ULTIMATE )

				ultimate = player.GiveOffhandWeapon(args[1], OFFHAND_ULTIMATE)
			break
		}
	} 
	catch( e420 ) 
	{
		// printt("Invalid weapon name for tgive command.")
    }

    if( IsValid(weapon) && !weapon.IsWeaponOffhand() && args.len() > 2 )
    {
		for(int i = 2; i < args.len(); i++)
		{
			if( !IsValidAttachment( args[i] ) )
				continue

			if( !SURVIVAL_Loot_IsRefValid( args[i] ) )
				continue

			string attachPoint = GetAttachPointForAttachmentOnWeapon( GetWeaponClassNameWithLockedSet( weapon ), args[i] )

			if( attachPoint == "" )
				continue

			string installed = GetInstalledWeaponAttachmentForPoint( weapon, attachPoint )
			LootData attachedData

			// revisar si hay un attachment en el puesto donde va a estar modToRemove ( que en este caso es el mod a agregar )
			if ( SURVIVAL_Loot_IsRefValid( installed ) )
			{
				weapon.RemoveMod( installed )
			}

			try {
				weapon.AddMod(args[i])
			}
			catch( e2 ) {
				// printt( "Invalid mod. - ", args[i] )
				weapon.RemoveMod( args[i] )
			}
		}
    }
    if( IsValid(weapon) && !weapon.IsWeaponOffhand() )
	{
		player.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, GetSlotForWeapon(player, weapon))
		player.ClearFirstDeployForAllWeapons()
	}

	player.p.lastTgiveUsedTime = Time()
	
		string subToken = ""
		string sWepName = ""
	
		if( !isCustomWeaponAllowed() && !isPlayerInChallenge( player ) )
			subToken = "#FS_CUSTOM_WEAPON_CHAL_ONLY"
	
		if( ClientCommand_SaveCurrentWeapons( player, ["1"] ) )
			sWepName = weapon.GetWeaponSettingString( eWeaponVar.printname )		
		
		LocalMsg( player, "#FS_WEAPONSAVED", subToken, uiType, 5, sWepName )
			
		if (bRestFlag)
			HolsterAndDisableWeapons( player )

    return true
}

///Save TDM Current Weapons
bool function ClientCommand_SaveCurrentWeapons(entity player, array<string> args)
{	
	if ( !IsValid( player ) ) return false
	
	bool single_save = false 
	
	if( args.len() > 0 )
	{
		single_save = true
	}
	
	entity weapon1
	entity weapon2
	string optics1
	string optics2
	array<string> mods1
	array<string> mods2
	string weaponname1
	string weaponname2
	
	try
	{
		weapon1 = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 )
		weapon2 = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_1 )
			
		mods1 = IsValid(weapon1) ? GetWeaponMods( weapon1 ) : [""];
		mods2 = IsValid(weapon2) ? GetWeaponMods( weapon2 ) : [""];
		
		foreach (mod in mods1)
			optics1 = mod + " " + optics1
		foreach (mod in mods2)
			optics2 = mod + " " + optics2

		
		if(IsValid(weapon1))
		{
			weaponname1 = weapon1.GetWeaponClassName()+" " + optics1;	
		}
		else 
		{	
			#if DEVELOPER
				sqerror("Player: " + player.GetPlatformUID() + " Weapon 1 invalid, setting to empty ") 
			#endif
			
			weaponname1 = " ";
		}
		
		if(IsValid(weapon2))
		{
			weaponname2 = weapon2.GetWeaponClassName()+" " + optics2
		}
		else 
		{	
			#if DEVELOPER
				sqerror("Player: " + player.GetPlatformUID() + " Weapon 2 invalid, setting to empty")
			#endif		
			
			weaponname2 = "";
		}
		
		
	}
	catch(error)
	{	
		#if DEVELOPER
			sqerror("Error: " + error )
		#endif
	}
	
	if ( !isPlayerInRestingList( player ) )
	{
		if( trim( weaponname1 ) == "" || trim( weaponname2 ) == "" )
		{	
			#if DEVELOPER
				if (weaponname1 == ""){ sqerror("Player: " + player.GetPlatformUID() + " weaponname1 empty") }
				if (weaponname2 == ""){ sqerror("Player: " + player.GetPlatformUID() + " weaponname2 empty") }
			#endif
			
			//Message( player, "FAILED TO SAVE" )
			LocalMsg( player, "#FS_FAILEDSAVE" )
			return false //dont save if player is dead
		}
	}
	
	#if DEVELOPER 
		sqprint( "Player: " + player.GetPlatformUID() + " weaponname1: " + weaponname1 + " weaponname2: " + weaponname2 )
	#endif 
	
	string concatenate_weps = weaponname1 + "; " + weaponname2;
	
	if( !single_save && trim( weaponname1 ) == "" && trim( weaponname2 ) == "" )
	{
		LocalMsg( player, "#FS_FAILEDSAVE" )
		return true
	}
	else if ( !single_save )
	{
		string subToken = "";
		if( !isCustomWeaponAllowed() && !isPlayerInChallenge( player ) )
		{
			subToken = "#FS_CUSTOM_WEAPON_CHAL_ONLY"
		}
			
		LocalMsg( player, "#FS_ALL_WEPS_SAVED", subToken )
	}
	
		weaponlist[player.GetPlayerName()] <- concatenate_weps;
		SavePlayerData( player, "saved_weapons", concatenate_weps )
	
	return true
}

//Limit mod for weapons in LoadCustomWeapon
string function modChecker( string weaponMods )
{	
	//sqprint("weaponMods: " + weaponMods)
	if( trim(weaponMods) == "") return "";  //return empty weapon mods
	
	array<string> weaponMod = split(weaponMods , " ")
	array<string> rifles = ["mp_weapon_energy_ar","mp_weapon_esaw","mp_weapon_rspn101","mp_weapon_vinson","mp_weapon_lmg","mp_weapon_g2","mp_weapon_hemlok"]
	array<string> smgs = ["mp_weapon_r97","mp_weapon_volt_smg","mp_weapon_pdw","mp_weapon_car"]
	if ( weaponMod.len() > 0 && weaponMod[0] == "mp_weapon_energy_ar"||weaponMod[0] == "mp_weapon_esaw")//this weapon is energy gun
	{
		for (int i = 1; i < weaponMod.len(); i++)
		{
			if ("energy_mag_l3" == weaponMod[i] )//force player using energy_mag_l2
				weaponMod[i] = "energy_mag_l2"
		}
	}

	if ( weaponMod.len() > 0 && rifles.contains(weaponMod[0]))//this weapon is rifle
	{
		for (int i = 1; i < weaponMod.len(); i++)
		{
			if( i >= weaponMod.len() )
				continue

			if ("stock_tactical_l3" == weaponMod[i] || "stock_tactical_l2" == weaponMod[i]  )//force player using stock_tactical_l1
				weaponMod[i] = "stock_tactical_l1"
			if ("bullets_mag_l3" == weaponMod[i]   )//force player using bullets_mag_l2
				weaponMod[i] = "bullets_mag_l2"
			if ("highcal_mag_l3" == weaponMod[i] || "highcal_mag_l2" == weaponMod[i]  )//force player using highcal_mag_l1
				weaponMod[i] = "highcal_mag_l1"
			if ("energy_mag_l3" == weaponMod[i] || "energy_mag_l2" == weaponMod[i]  )//force player using energy_mag_l1
				weaponMod[i] = "energy_mag_l1"
			if ("barrel_stabilizer_l4_flash_hider" == weaponMod[i] || "barrel_stabilizer_l3" == weaponMod[i] || "barrel_stabilizer_l2" == weaponMod[i] ||"barrel_stabilizer_l1" == weaponMod[i])//去除枪管
				weaponMod.remove(i)
		}
	}

	if ( weaponMod.len() > 0 && smgs.contains(weaponMod[0]))//this weapon is smg
	{
		for (int i = 1; i < weaponMod.len(); i++)
		{
			if( i >= weaponMod.len() )
				continue

			if ("stock_tactical_l3" == weaponMod[i] || "stock_tactical_l2" == weaponMod[i]  )//force player using stock_tactical_l1
				weaponMod[i] = "stock_tactical_l1"
			if ("bullets_mag_l3" == weaponMod[i]   )//force player using bullets_mag_l2
				weaponMod[i] = "bullets_mag_l2"
			if ("highcal_mag_l3" == weaponMod[i]   )//force player using highcal_mag_l2
				weaponMod[i] = "highcal_mag_l2"
			if ("energy_mag_l3" == weaponMod[i]   )//force player using energy_mag_l2
				weaponMod[i] = "energy_mag_l2"
			if ("barrel_stabilizer_l4_flash_hider" == weaponMod[i] || "barrel_stabilizer_l3" == weaponMod[i] || "barrel_stabilizer_l2" == weaponMod[i] ||"barrel_stabilizer_l1" == weaponMod[i] )//去除枪管
				weaponMod.remove(i)
		}
	}

	weaponMod.reverse()
	string returnweapon
	foreach (i in weaponMod) {
		returnweapon = i+" "+returnweapon
	}

	return returnweapon
}

//Auto-load TDM Saved Weapons on Respawn
void function LoadCustomWeapon(entity player)
{
	if ( !IsValid( player )) return
	
	if (player.GetPlayerName() in weaponlist)
	{
		// TakeAllWeapons(player)
		array<string> weapons =  split(weaponlist[player.GetPlayerName()] , ";")
		player.TakeNormalWeaponByIndexNow( WEAPON_INVENTORY_SLOT_PRIMARY_0 )
		player.TakeNormalWeaponByIndexNow( WEAPON_INVENTORY_SLOT_PRIMARY_1 )
		//check if weapon's mods is allowed by server
		foreach(index,weapon in weapons)
		{	
			if ( trim(weapon) == "" ) continue
			
            weapon =modChecker(weapon)
			weapons[index]=weapon
		}

		foreach (index,rweapon in weapons)
		{	
			#if DEVELOPER && HAS_TRACKER_DLL
				sqprint(rweapon)
			#endif
			
			if ( trim(rweapon) == "" ) continue
			
			int slot
			if(index == 0)
			{
				slot = WEAPON_INVENTORY_SLOT_PRIMARY_0
			}
			else
			{
				slot = WEAPON_INVENTORY_SLOT_PRIMARY_1
			}

			__GiveWeapon( player, weapons, slot, index )
		}
		
		WaitFrame()
		
		if(!IsValid(player)) { return }			
			
		if(IsValid(player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 )))
		{
			player.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_0)
		}
		else if (IsValid(player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_1 )))
		{
			player.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_1)
		}
		else 
		{
			#if DEVELOPER && HAS_TRACKER_DLL
				sqerror("Player: " + player.GetPlatformUID() + " has no valid weapon to set: Active" )
			#endif
		}
		
	}
}


//Reset TDM Saved Weapons
bool function ClientCommand_ResetSavedWeapons( entity player, array<string> args )
{
	if( !IsValid( player ) )
		return false 
		
	if ( player.GetPlayerName() in weaponlist )
	{
		delete weaponlist[ player.GetPlayerName() ]
	}
	
	SavePlayerData( player, "saved_weapons", "NA" )
	player.p.weapon_loadout = "NA";
	
	LocalMsg( player, "#FS_WEAPONS_RESET" )
	
	return true
}

bool function ClientCommand_NextRound(entity player, array<string> args)
{
	if ( !CheckRate( player ) ) 
		return false
	
	if( !IsAdmin( player) || args.len() == 0 ) //checkrate already checks for validity
		return false
	
	if (args[0] == "now")
	{
	   file.tdmState = eTDMState.NEXT_ROUND_NOW ; file.mapIndexChanged = false
	   return true
	}

	int mapIndex = int(args[0])
	file.nextMapIndex = (((mapIndex >= 0 ) && (mapIndex < file.locationSettings.len())) ? mapIndex : RandomIntRangeInclusive(0, file.locationSettings.len() - 1))
	file.mapIndexChanged = true

	if(args.len() > 1){
		if (args[1] == "now")
		   file.tdmState = eTDMState.NEXT_ROUND_NOW
	}

	return true
}
bool function ClientCommand_adminnoclip( entity player, array<string> args )
{
	if( !IsValid(player) )
		return false 
		
	if( !IsAdmin(player) ) 
		return false

	if ( player.IsNoclipping() )
		player.SetPhysics( MOVETYPE_WALK )
	else
		player.SetPhysics( MOVETYPE_NOCLIP )
	return true
}

bool function ClientCommand_CircleNow(entity player, array<string> args)
{
	if( !IsValid(player) || !IsAdmin( player)) 
		return false

	SummonPlayersInACircle(player)

	return true
}

#if DEVELOPER 
	void function DEV_NextRound( int mapIndex )
	{
		file.nextMapIndex = (((mapIndex >= 0 ) && (mapIndex < file.locationSettings.len())) ? mapIndex : RandomIntRangeInclusive(0, file.locationSettings.len() - 1))
		file.mapIndexChanged = true
		file.tdmState = eTDMState.NEXT_ROUND_NOW
	}
#endif 

bool function ClientCommand_God(entity player, array<string> args)
{
	if( !IsValid(player) || !IsAdmin(player) ) 
		return false

	player.MakeInvisible()
	MakeInvincible(player)
	HolsterAndDisableWeapons(player)

	return true
}


bool function ClientCommand_UnGod(entity player, array<string> args)
{
	if( !IsValid(player) || !IsAdmin(player) ) 
		return false

	player.MakeVisible()
	ClearInvincible(player)
	EnableOffhandWeapons( player )
	DeployAndEnableWeapons(player)

	return true
}

bool function ClientCommand_Scoreboard(entity player, array<string> args)
{
	if (!CheckRate( player )) return false

	float ping = player.GetLatency() * 1000 - 40

	Message(player,
	"- CURRENT SCOREBOARD - ",
	"\n               CHAMPION: " + GetBestPlayerName() + " / " + GetBestPlayerScore() + " kills.\n" +
	"\n Name:    K  |   D   |   KD   |   Damage dealt\n" +
	ScoreboardFinal(true) + "\n" +
	"\nYour ping: " + ping.tointeger() + "ms.\n" +
	"Hosted by: " + GetOwnerName()
	, 4)

	return true
}

bool function ClientCommand_ScoreboardPROPHUNT(entity player, array<string> args)
{
	if (!CheckRate( player )) return false

	float ping = player.GetLatency() * 1000 - 40

	Message(player,
	"- PROPHUNT SCOREBOARD - ",
	"Name:    K  |   D   \n" +
	ScoreboardFinalPROPHUNT(true) + "\n" +
	"Your ping: " + ping.tointeger() + "ms. \n" +
	"Hosted by: " + GetOwnerName()
	, 5)

	return true
}

array<entity> function shuffleArray(array<entity> arr)
{
    // O(n) Durstenfeld / Knuth shuffle (https://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle)
	int i; int j; entity tmp;

	for (i = arr.len() - 1; i > 0; i--) {
		j = RandomIntRangeInclusive(1, i)
		tmp = arr[i]
		arr[i] = arr[j]
		arr[j] = tmp
		}

	return arr
}

bool function ClientCommand_RebalanceTeams(entity player, array<string> args)
{
	if( !IsValid(player) || !IsAdmin( player) || args.len() == 0 )
		return false

	int currentTeam = 2
	int numTeams = int(args[0])
	array<entity> allplayers = GetPlayerArray()
	allplayers.randomize()
	foreach (p in allplayers)
	{
		if (!IsValid(p)) continue
		SetTeam(p,TEAM_IMC + 2 + (currentTeam % numTeams))
		currentTeam += 1
		//Message(p, "TEAMS REBALANCED", "We have now " + numTeams + " teams.", 4)
		LocalMsg( p, "#FS_TEAMSBALANCED", "#FS_TEAMSBALANCED_SUBSTR", 0, 4, "", numTeams.tostring() )
	}

	return true
}
bool function ClientCommand_BecomePro(entity p, array<string> args)
{
	SetTeam(p, TEAM_MILITIA)
	ClearHackerOrBecomePro(p)
	
	thread function() : (p)
	{
		wait 1
		if ( !IsValid( p ) ) return
		Message(p, "HACKERS VS PROS", "You're a Pro")
	}()
	return true
}

void function CreateAnimatedLegend(asset a, vector pos, vector ang , int solidtype = 0, float size = 1.0)
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

void function AnimationTiming( entity legend, float cycle )
{
	array<string> animationStrings = ["ACT_MP_MENU_LOBBY_CENTER_IDLE", "ACT_MP_MENU_READYUP_INTRO", "ACT_MP_MENU_LOBBY_SELECT_IDLE", "ACT_VICTORY_DANCE"]
	while( IsValid(legend) )
	{
		legend.SetCycle( cycle )
		legend.Anim_Play( animationStrings[RandomInt(animationStrings.len())] )
		WaittillAnimDone(legend)
	}
}

void function LoadCustomSkill(entity player)
{
	if (!IsValid(player))
		return

	if (player.GetPlayerName() in skilllist) //列表里存在该玩家数据
	{	
		array<string> splited = split(skilllist[player.GetPlayerName()] , ";")
        	ClientCommand( player, "tgive t "+ splited[0] )
        	ClientCommand( player, "tgive u "+ splited[1] )
	}
}

bool function ClientCommand_Maki_SaveCurSkill(entity player, array<string> args)
{
	if( !IsValid(player) )
		return false
	
	try
	{
		entity ultimate = player.GetOffhandWeapon( OFFHAND_INVENTORY )
		entity tactical = player.GetOffhandWeapon( OFFHAND_LEFT )
		string skillname = tactical.GetWeaponClassName() + ";"
		string ultname = ultimate.GetWeaponClassName()
		skilllist[player.GetPlayerName()] <- skillname + ultname
	}
	catch(error)
	{}	
	
	return true
} 
bool function ClientCommand_Maki_ResetSkills(entity player, array<string> args)
{	
	if ( !IsValid(player) ) 
		return false
	
	if (player.GetPlayerName() in skilllist)
	{
		delete skilllist[player.GetPlayerName()]
	}
	return true
}
////////////////////////////////////////////////////////////////////////////////////////


void function GivePlayerRandomCharacter(entity player)
{
	if ( !IsValid( player ) ) 
		return
	
	array<ItemFlavor> characters = GetAllCharacters()
	int random_character_index = RandomIntRangeInclusive(0,characterslist.len()-1)
	ItemFlavor random_character = characters[characterslist[random_character_index]]
	CharacterSelect_AssignCharacter( ToEHI( player ), random_character )
	TakeAllWeapons(player)
    GiveRandomPrimaryWeaponMetagame(player)
	GiveRandomSecondaryWeaponMetagame(player)
	player.GiveWeapon( "mp_weapon_melee_survival", WEAPON_INVENTORY_SLOT_PRIMARY_2, [] )
	player.GiveOffhandWeapon( "melee_pilot_emptyhanded", OFFHAND_MELEE, [] )
    GiveRandomTac(player)
    GiveRandomUlt(player)
}
void function highlightKdMoreThan2(entity player)
{	
	return //disable for solo mode
	if (getkd(player.GetPlayerGameStat( PGS_KILLS ),player.GetPlayerGameStat( PGS_DEATHS )) >= 2)
	{
		Highlight_SetEnemyHighlight(player, "crypto_camera_friendly")
	}
	else
	{
		Highlight_ClearEnemyHighlight( player )
	}
}

//Hackers vs pros

void function BecomeHacker(entity player)
{
	if( player.GetTeam() != TEAM_IMC ) return
	
	// AddButtonPressedPlayerInputCallback( player, IN_USE, CheckForHoldInput_Thread )
	
	// Remote_CallFunction_NonReplay( player, "DM_HintCatalog", 0, 0)
	
	// entity tactical = player.GetOffhandWeapon( OFFHAND_TACTICAL )
	
	// if( IsValid( tactical ) ) 
		// player.TakeOffhandWeapon( OFFHAND_TACTICAL )
	
	// entity ultimate = player.GetOffhandWeapon( OFFHAND_ULTIMATE )
	
	// if( IsValid( ultimate ) ) 
		// player.TakeOffhandWeapon( OFFHAND_ULTIMATE )
	
	// player.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL, [])
	
	Highlight_SetFriendlyHighlight( player, "infection_survivor_teammate" )
	Highlight_ClearEnemyHighlight( player )
	
	player.ClearFirstDeployForAllWeapons()
}

void function ClearHackerOrBecomePro(entity player)
{
	// if( player.GetTeam() != TEAM_MILITIA ) return
	
	// RemoveButtonPressedPlayerInputCallback( player, IN_USE, CheckForHoldInput_Thread )
	
	// entity tactical = player.GetOffhandWeapon( OFFHAND_TACTICAL )
	
	// if( IsValid( tactical ) ) 
		// player.TakeOffhandWeapon( OFFHAND_TACTICAL )
	
	// entity ultimate = player.GetOffhandWeapon( OFFHAND_ULTIMATE )
	
	// if( IsValid( ultimate ) ) 
		// player.TakeOffhandWeapon( OFFHAND_ULTIMATE )
	
	// player.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL, [])
	
	player.ClearFirstDeployForAllWeapons()
	
	thread function() : (player)
	{
		wait 1
		if ( !IsValid( player ) ) return
		Highlight_SetFriendlyHighlight( player, "infection_survivor_teammate" )
		Highlight_ClearFriendlyHighlight( player )
		Highlight_SetEnemyHighlight( player, "hackers_wallhack" )
	}()
	
	//Remote_CallFunction_NonReplay( player, "UpdateRUITest")
	Remote_CallFunction_ByRef( player, "UpdateRUITest" )
}

void function CheckForHoldInput_Thread( entity player ) //, entity weapon )
{
	thread function () : (player)//, weapon)
	{
		player.EndSignal( "OnDeath" )
		player.EndSignal( "OnDestroy" )

		OnThreadEnd(
			function() : ( player )//, weapon  )
			{
				player.p.enableAimbot = false

				Remote_CallFunction_NonReplay( player, "DM_HintCatalog", 0, 0)

			}
		)

		while ( player.IsInputCommandHeld( IN_USE ) )
		{
			if(!player.p.enableAimbot)
				Remote_CallFunction_NonReplay( player, "DM_HintCatalog", 1, 0)
			
			player.p.enableAimbot = true
			
			WaitFrame()
		}
	}()
}

entity function GetNearestPlayer(entity player)
{
	entity returnEntity 
	float dist = 2000
	float tempdist 
	
	array<entity> enemies
	
	enemies.extend(GetPlayerArrayOfTeam_Alive(TEAM_MILITIA))
	enemies.extend(GetNPCArray())
	enemies.removebyvalue(player) //could be fastremove
	
	foreach(target in enemies)
	{
		tempdist = Distance(target.GetOrigin(), player.GetOrigin())
		if(tempdist < dist)
		{
			returnEntity = target
			dist = tempdist
		}	
	}
	
	return returnEntity
}

void function AimBot(entity player)
//Made by my Chinese friend Makimakima
{
	while(IsValid(player))
	{
		//printt("aimbot")
		try
		{
			entity target = GetNearestPlayer(player)
			if(!player.p.enableAimbot || !IsValid(target)) 
			{
				WaitFrame()
				continue
			}
			vector targetOrigin = target.GetOrigin()
			vector playerOrigin = player.GetOrigin()

			float tempAngleY = atan((playerOrigin.y-targetOrigin.y)/(playerOrigin.x-targetOrigin.x))*180/PI // -90<x<90
			float playerAnglesY = 0


			//判断象限
			//++1
			if ((targetOrigin.x - playerOrigin.x) > 0 && (targetOrigin.y - playerOrigin.y) > 0 )
			{
				// print("0<x<90")
				playerAnglesY = tempAngleY
			}//第一象限
				
			//-+2
			if ((targetOrigin.x - playerOrigin.x) < 0 && (targetOrigin.y - playerOrigin.y) > 0 )
			{
				// print("90<x<180")
				playerAnglesY = 180 + tempAngleY 
			}//第二象限
				
			//--3
			if ((targetOrigin.x - playerOrigin.x) < 0 && (targetOrigin.y - playerOrigin.y) < 0 )
			{
				// print("-180<x<-90")
				playerAnglesY = 180 + tempAngleY
			}//第三象限
				
			//+-4
			if ((targetOrigin.x - playerOrigin.x) > 0 && (targetOrigin.y - playerOrigin.y) < 0 )
			{
				// print("-90<x<0")
				playerAnglesY = tempAngleY
			}//第四象限
			
			float playerAnglesZ
			float zAngle = fabs(targetOrigin.z - 10)  - fabs(playerOrigin.z)

			float testv = sqrt(pow(targetOrigin.x - playerOrigin.x ,2)+pow(targetOrigin.y  - playerOrigin.y,2))
			playerAnglesZ = atan(zAngle/testv)*180/PI //x轴角度
			player.SetAbsAnglesSmooth(<playerAnglesZ,playerAnglesY,0>)
		}
		catch (error)
		{}
		WaitFrame()
	}
}

bool function ClientCommand_setspecplayer( entity player, array<string> args )
{
    // array<string> allowedPlayers = split(GetCurrentPlaylistVarString("allowedCameraPlayers", ""), " ")

    // if( !(allowedPlayers.contains(player.GetPlayerName())) )
        // return false
	
	SetConVarFloat( "sv_noclipspeed", 3 )
	SetConVarFloat( "sv_noclipspeed_fast", 20 )
	SetConVarFloat( "sv_noclipspeed_slow", 1 )
	
	TakeAllWeapons( player )
    player.MakeInvisible()
    player.SetPhysics( MOVETYPE_NOCLIP )
    SetTeam( player, TEAM_SPECTATOR )
    
	UpdatePlayerCounts()
	//Remote_CallFunction_NonReplay( player, "UpdateRUITest")
	Remote_CallFunction_ByRef( player, "UpdateRUITest" )
    return true
}

bool function GetScoreboardShowingState()
{
	return FS_DM.scoreboardShowing
}

void function SetCommonLinesForMapProp( entity chunk, float scale )
{
    chunk.kv.fadedist = 999999
    chunk.kv.rendermode = 0
    chunk.kv.renderamt = 1
    chunk.kv.solid = 0
    chunk.kv.CollisionGroup = TRACE_COLLISION_GROUP_PLAYER
	chunk.SetModelScale(scale)
    chunk.kv.solid = 0
	chunk.kv.contents = CONTENTS_PLAYERCLIP | CONTENTS_MONSTERCLIP
}

void function HisWattsons_HaloModFFA_KillStreakAnnounce( entity attacker )
{
	float thisKillTime = Time()
	
	// if( thisKillTime == attacker.p.lastDownedEnemyTime ) //insta double then?
	// {		
		// attacker.p.downedEnemy += 2
	// }

	if( attacker.p.downedEnemy > 0 && thisKillTime > attacker.p.allowedTimeForNextKill )
		attacker.p.downedEnemy = 0

	attacker.p.downedEnemy++
	attacker.p.allowedTimeForNextKill = thisKillTime + KILLLEADER_STREAK_ANNOUNCE_TIME
	
	if( attacker.p.downedEnemy > 10 ) // max multi kill badge is killionarie at 10 kills
		return

	if ( thisKillTime <= attacker.p.allowedTimeForNextKill && attacker.p.downedEnemy > 1 )
	{
		if( attacker.p.downedEnemy == 3 )
		{
			EmitSoundOnEntityOnlyToPlayerWithSeek( attacker, attacker, "diag_ap_aiNotify_killLeaderTripleKill", 1.8 )
		} else if( attacker.p.downedEnemy == 2 )
		{
			EmitSoundOnEntityOnlyToPlayerWithSeek( attacker, attacker, "diag_ap_aiNotify_killLeaderDoubleKill", 2 )
		}

		Remote_CallFunction_NonReplay(attacker, "FSHaloMod_CreateKillStreakAnnouncement", attacker.p.downedEnemy )
	}

	attacker.p.lastDownedEnemyTime = thisKillTime
}

void function SpawnCyberdyne() //Halo 3 The Pit
{
	vector startingpos = Vector(42000, -10000, -19900)

	if( MapName() != eMaps.mp_flowstate )
		startingpos = Vector(0, 0, 9000)

	vector startingang = Vector(0,-90,0)
	float scale = 80
	
	//outside
	entity outside = MapEditor_CreateProp( $"mdl/custom_maps/mp_rr_cyberdyne/outside.rmdl", startingpos, startingang,  false, -1)
	SetCommonLinesForMapProp( outside, scale )

	//roof
	entity roof = MapEditor_CreateProp( $"mdl/custom_maps/mp_rr_cyberdyne/roof.rmdl", startingpos, startingang,  true, 50000)
	SetCommonLinesForMapProp( roof, scale )
	
	//base
	entity base = MapEditor_CreateProp( $"mdl/custom_maps/mp_rr_cyberdyne/base.rmdl", startingpos, startingang,  true, 50000)
	SetCommonLinesForMapProp( base, scale )
	
	//base2
	entity base2 = MapEditor_CreateProp( $"mdl/custom_maps/mp_rr_cyberdyne/base2.rmdl", startingpos, startingang,  true, 50000)
	SetCommonLinesForMapProp( base2, scale )
	
	//interior_a
	entity interior_a = MapEditor_CreateProp( $"mdl/custom_maps/mp_rr_cyberdyne/interior_a.rmdl", startingpos, startingang,  true, 50000)
	SetCommonLinesForMapProp( interior_a, scale )
	
	//interior_b
	entity interior_b = MapEditor_CreateProp( $"mdl/custom_maps/mp_rr_cyberdyne/interior_b.rmdl", startingpos, startingang,  true, 50000)
	SetCommonLinesForMapProp( interior_b, scale )
	
	//interior_c
	entity interior_c = MapEditor_CreateProp( $"mdl/custom_maps/mp_rr_cyberdyne/interior_c.rmdl", startingpos, startingang,  true, 50000)
	SetCommonLinesForMapProp( interior_c, scale )
	
	array<entity> cyberdyneCollisionModel
	cyberdyneCollisionModel.extend( Cyberdyne_Load(startingpos + Vector(-3400,-6623,0) ) )
	cyberdyneCollisionModel.extend( Cyberdyne_Load2(startingpos + Vector(-3400,-6623,0) ) )
	
	if( MapName() == eMaps.mp_flowstate )
		file.playerSpawnedProps.append( AddOutOfBoundsTriggerWithParams( <41977.8359, -10601.9141, -19263.0371>, 5000 ) )
	else
		file.playerSpawnedProps.append( AddOutOfBoundsTriggerWithParams( <-2.35747147, -574.164307, 9636.9624>, 5000 ) )

	thread function () : ( startingpos )
	{
		#if DEVELOPER
		FlagWait( "EntitiesDidLoad" ) //for when I load the map via _mapspawn

		ForceSaveOgSkyboxOrigin()
		#endif
		
		if( MapName() == eMaps.mp_flowstate )
		{
			//Rotate skybox for The Pit map.
			entity skyboxCamera = GetEnt( "skybox_cam_level" )
			skyboxCamera.SetOrigin( file.ogSkyboxOrigin + <0, 0, 85> )
			skyboxCamera.SetAngles( <0, 120, 0> ) //The Pit
			
			//Adjust sun flare for rotated skybox.
			foreach( player in GetPlayerArray() )
			{
				if( !IsValid( player ) )
					continue
				
				Remote_CallFunction_Replay( player, "FS_ForceAdjustSunFlareParticleOnClient", 1 )
			}
		}
		//Lightning.
		FS_ResetMapLightning()
		SetConVarFloat( "mat_sky_scale", 1.5 )
		SetConVarFloat( "mat_sun_scale", 1.5 )

		//Add weapon racks.
		file.playerSpawnedProps.append( MapEditor_CreateRespawnableWeaponRack( < 3402.5, 7035.9, 124.2 > + startingpos + Vector(-3400,-6623,0) , < 0, 90, 0 >, "mp_weapon_haloneedler", 0.5 ) )
		file.playerSpawnedProps.append( MapEditor_CreateRespawnableWeaponRack( < 1932.3, 7304.9, -108.5 > + startingpos + Vector(-3400,-6623,0) , < 0, 0, 0 >, "mp_weapon_halosniperrifle", 0.5 ) )
		file.playerSpawnedProps.append( MapEditor_CreateRespawnableWeaponRack( < 4890, 7244.6, -108.5 > + startingpos + Vector(-3400,-6623,0) , < 0, -180, 0 >, "mp_weapon_halosniperrifle", 0.5 ) )
		file.playerSpawnedProps.append( MapEditor_CreateRespawnableWeaponRack( <40277.7734, -11311.5322, -19776.1563>, < 0, -135, 0 >, "mp_weapon_haloshotgun", 0.5 ) )
		file.playerSpawnedProps.append( MapEditor_CreateRespawnableWeaponRack( <43670.707, -11374.5322, -19776.1563>, < 0, -45, 0 >, "mp_weapon_haloshotgun", 0.5 ) )
		file.playerSpawnedProps.append( MapEditor_CreateRespawnableWeaponRack( <41593.3945, -11011, -19726.1758>, < 0, 180, 0 >, "mp_weapon_halobattlerifle", 0.5 ) )
		file.playerSpawnedProps.append( MapEditor_CreateRespawnableWeaponRack( <42367.168, -11011, -19726.1563>, < 0, 0, 0 >, "mp_weapon_halobattlerifle", 0.5 ) )
		file.playerSpawnedProps.append( MapEditor_CreateRespawnableWeaponRack( <41296.8711, -10499.9189, -19726.2383> , <0, 0, 0>, "mp_weapon_halosmg", 0.5 ) )
		file.playerSpawnedProps.append( MapEditor_CreateRespawnableWeaponRack( <42694.0391, -10514.124, -19726.2383> , <0, 180, 0>, "mp_weapon_halosmg", 0.5 ) )
		file.playerSpawnedProps.append( MapEditor_CreateRespawnableWeaponRack( <43614.4766, -10339.4316, -19928.1563> , <0, -90, 0>, "mp_weapon_halodmr", 0.5 ) )
		file.playerSpawnedProps.append( MapEditor_CreateRespawnableWeaponRack( <40391.9219, -10283.1338, -19928.1563> , <0, -90, 0>, "mp_weapon_halodmr", 0.5 ) )

	}()
}

void function SpawnLockout() //Halo 2 Encerrona
{
	if( MapName() != eMaps.mp_flowstate )
		return

	vector startingpos = Vector(42000, -10000, -19900)

	vector startingang = Vector(0,-90,0)
	float scale = 350
	
	//outside
	entity outside = CreatePropDynamic_NoDispatchSpawn( $"mdl/custom_maps/mp_rr_lockout.rmdl", startingpos, startingang,  SOLID_VPHYSICS, -1 )
	SetCommonLinesForMapProp( outside, scale )
	DispatchSpawn( outside )

	array < entity > collisionModel
	collisionModel.extend( Lockout_Load1( startingpos ) )
	collisionModel.extend( Lockout_Load2( startingpos ) )
	collisionModel.extend( Lockout_Load3( startingpos ) )

	thread function () : ( startingpos )
	{
		#if DEVELOPER
		FlagWait( "EntitiesDidLoad" ) //for when I load the map via _mapspawn
		
		ForceSaveOgSkyboxOrigin()
		#endif

		//Spawn Lift.
		CreateLockoutLiftAtOrigin( <43300, -9840.33008, -21201.3379>, null, true )
		
		//Rotate skybox.
		entity skyboxCamera = GetEnt( "skybox_cam_level" )
		skyboxCamera.SetOrigin( file.ogSkyboxOrigin + <0, 0, 110> )
		skyboxCamera.SetAngles( <0, 0, 0> ) //lockout
		
		//Lightning.
		FS_ResetMapLightning()
		SetConVarFloat( "mat_autoexposure_max", 1.0 )
		SetConVarFloat( "mat_autoexposure_max_multiplier", 0.3 )
		SetConVarFloat( "mat_autoexposure_min", 0.7 )
		SetConVarFloat( "mat_autoexposure_min_multiplier", 1.0 )

		SetConVarFloat( "mat_sky_scale", 1.0 )
		SetConVarString( "mat_sky_color", "1.0 1.0 1.0 1.0" )
		SetConVarFloat( "mat_sun_scale", 3.0 )
		SetConVarString( "mat_sun_color", "1.0 1.5 2.0 1.0" )
		
		//Add some OOB triggers.
		file.playerSpawnedProps.append( AddOutOfBoundsTriggerWithParams( <41605.0508, -9183.5791, -20123.3379>, 350 ) )
		file.playerSpawnedProps.append( AddOutOfBoundsTriggerWithParams( <43149.0039, -9835.28516, -20316.2344>, 550 ) )
		file.playerSpawnedProps.append( AddOutOfBoundsTriggerWithParams( <42786.1133, -9841.4375, -20059.3379>, 550 ) )

		//Adjust sun flare for rotated skybox.
		foreach( player in GetPlayerArray() )
		{
			if( !IsValid( player ) )
				continue
			
			Remote_CallFunction_Replay( player, "FS_ForceAdjustSunFlareParticleOnClient", 0 ) //lockout
		}
		
		//Add weapon racks.
		file.playerSpawnedProps.append( MapEditor_CreateRespawnableWeaponRack( < -303.7, 275.4, -1105.8 > + startingpos, < 0, 0, 0 >, "mp_weapon_halosmg", 0.5 ) )
		file.playerSpawnedProps.append( MapEditor_CreateRespawnableWeaponRack( < -986, -724.5, -892.6 > + startingpos, < 0, 0, 0 >, "mp_weapon_halodmr", 0.5 ) )
		file.playerSpawnedProps.append(MapEditor_CreateRespawnableWeaponRack( < -316.4, -937.6, -628.8 > + startingpos, < 0, 0, 0 >, "mp_weapon_haloshotgun", 0.5 ) )
		file.playerSpawnedProps.append( MapEditor_CreateRespawnableWeaponRack( < -346.2, 731.8, -693.4 > + startingpos, < 0, -90, 0 >, "mp_weapon_halobattlerifle", 0.5 ) )
		file.playerSpawnedProps.append( MapEditor_CreateRespawnableWeaponRack( < -519.2, 947.1, -1088.1 > + startingpos, < 0, 0, 0 >, "mp_weapon_haloneedler", 0.5 ) )
		file.playerSpawnedProps.append( MapEditor_CreateRespawnableWeaponRack( < -377.4, 475.6, -894 > + startingpos, < 0, -45, 0 >, "mp_weapon_halosniperrifle", 0.5 ) )
		// MapEditor_CreateRespawnableWeaponRack( < 1041.7, 159.4, -1375.3 > + startingpos, < 0, -180, 0 >, "mp_weapon_r97", 0.5 )
		// MapEditor_CreateRespawnableWeaponRack( < 14.9, -833.7, -1130.6 > + startingpos, < 0, -180, 0 >, "mp_weapon_r97", 0.5 )
	
		//Spawn snow fog.
		file.playerSpawnedProps.append( StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( $"P_snow_atmo_512" ), <41419.9414, -8873.05762, -20634.1875>, <0,0,0> ) )
		file.playerSpawnedProps.append( StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( $"P_snow_atmo_512" ), <42825.4961, -9075.6543, -21068.293>, <0,0,0> ) )
		file.playerSpawnedProps.append( StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( $"P_snow_atmo_512" ), <42009.2734, -10263.9111, -21064.6504>, <0,0,0> ) )
		file.playerSpawnedProps.append( StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( $"P_snow_atmo_512" ), <42197.5, -11365.9932, -20704.9375>, <0,0,0> ) )
		file.playerSpawnedProps.append( StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( $"P_snow_atmo_512" ), <41468.4336, -11108.3555, -20748.1895>, <0,0,0> ) )
		file.playerSpawnedProps.append( StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( $"P_snow_atmo_512" ), <41533.2148, -10549.3389, -21105.168>, <0,0,0> ) )
		file.playerSpawnedProps.append( StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( $"P_snow_atmo_512" ), <42398.1875, -9843.76758, -20955.9746>, <0,0,0> ) )
		file.playerSpawnedProps.append( StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( $"P_snow_atmo_512" ), <41289.9258, -9688.5918, -20597.6895>, <0,0,0> ) )
		file.playerSpawnedProps.append( StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( $"P_snow_atmo_512" ), <41856.8594, -8431.65137, -20965.791>, <0,0,0> ) )
		file.playerSpawnedProps.append( StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( $"P_snow_atmo_512" ), <41419.9414, -8873.05762, -20634.1875>, <0,0,0> ) )
		file.playerSpawnedProps.append( StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( $"P_snow_atmo_512" ), <42825.4961, -9075.6543, -21068.293>, <0,0,0> ) )
		file.playerSpawnedProps.append( StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( $"P_snow_atmo_512" ), <42009.2734, -10263.9111, -21064.6504>, <0,0,0> ) )
		file.playerSpawnedProps.append( StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( $"P_snow_atmo_512" ), <42197.5, -11365.9932, -20704.9375>, <0,0,0> ) )
		file.playerSpawnedProps.append( StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( $"P_snow_atmo_512" ), <41468.4336, -11108.3555, -20748.1895>, <0,0,0> ) )
		file.playerSpawnedProps.append( StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( $"P_snow_atmo_512" ), <41533.2148, -10549.3389, -21105.168>, <0,0,0> ) )
		file.playerSpawnedProps.append( StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( $"P_snow_atmo_512" ), <42398.1875, -9843.76758, -20955.9746>, <0,0,0> ) )
		file.playerSpawnedProps.append( StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( $"P_snow_atmo_512" ), <41289.9258, -9688.5918, -20597.6895>, <0,0,0> ) )
		file.playerSpawnedProps.append( StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( $"P_snow_atmo_512" ), <41856.8594, -8431.65137, -20965.791>, <0,0,0> ) )
	}()
}

void function SpawnChill()
{
	if( MapName() != eMaps.mp_flowstate )
		return

	vector startingpos = Vector(42000, -10000, -26000) //Vector( 0,0,2000 ) // 
	vector startingang = Vector(0,-90,0)
	float scale = 300

	//anillo
	entity anillo = CreatePropDynamic_NoDispatchSpawn( $"mdl/custom_maps/mp_rr_chill/mp_rr_chill_anillo.rmdl", startingpos, startingang,  SOLID_VPHYSICS, -1 )
	SetCommonLinesForMapProp( anillo, scale/10 )
	DispatchSpawn( anillo )

	//seccion1
	entity seccion1 = CreatePropDynamic_NoDispatchSpawn( $"mdl/custom_maps/mp_rr_chill/mp_rr_chill_seccion1.rmdl", startingpos, startingang,  SOLID_VPHYSICS, -1 )
	SetCommonLinesForMapProp( seccion1, scale )
	DispatchSpawn( seccion1 )

	//seccion2
	entity seccion2 = CreatePropDynamic_NoDispatchSpawn( $"mdl/custom_maps/mp_rr_chill/mp_rr_chill_seccion2.rmdl", startingpos, startingang,  SOLID_VPHYSICS, -1 )
	SetCommonLinesForMapProp( seccion2, scale )
	DispatchSpawn( seccion2 )
	
	//seccion3
	entity seccion3 = CreatePropDynamic_NoDispatchSpawn( $"mdl/custom_maps/mp_rr_chill/mp_rr_chill_seccion3.rmdl", startingpos, startingang,  SOLID_VPHYSICS, -1 )
	SetCommonLinesForMapProp( seccion3, scale )
	DispatchSpawn( seccion3 )
	
	//seccion4
	entity seccion4 = CreatePropDynamic_NoDispatchSpawn( $"mdl/custom_maps/mp_rr_chill/mp_rr_chill_seccion4.rmdl", startingpos, startingang,  SOLID_VPHYSICS, -1 )
	SetCommonLinesForMapProp( seccion4, scale )
	DispatchSpawn( seccion4 )
	
	//secccion5
	entity seccion5 = CreatePropDynamic_NoDispatchSpawn( $"mdl/custom_maps/mp_rr_chill/mp_rr_chill_seccion5.rmdl", startingpos, startingang,  SOLID_VPHYSICS, -1 )
	SetCommonLinesForMapProp( seccion5, scale )
	DispatchSpawn( seccion5 )

	//seccion6
	entity seccion6 = CreatePropDynamic_NoDispatchSpawn( $"mdl/custom_maps/mp_rr_chill/mp_rr_chill_seccion6.rmdl", startingpos, startingang,  SOLID_VPHYSICS, -1 )
	SetCommonLinesForMapProp( seccion6, scale )
	DispatchSpawn( seccion6 )
	
	//seccion7
	entity seccion7 = CreatePropDynamic_NoDispatchSpawn( $"mdl/custom_maps/mp_rr_chill/mp_rr_chill_seccion7.rmdl", startingpos, startingang,  SOLID_VPHYSICS, -1 )
	SetCommonLinesForMapProp( seccion7, scale )
	DispatchSpawn( seccion7 )
	
	//seccion8
	entity seccion8 = CreatePropDynamic_NoDispatchSpawn( $"mdl/custom_maps/mp_rr_chill/mp_rr_chill_seccion8.rmdl", startingpos, startingang,  SOLID_VPHYSICS, -1 )
	SetCommonLinesForMapProp( seccion8, scale )
	DispatchSpawn( seccion8 )
	
	//seccion9
	entity seccion9 = CreatePropDynamic_NoDispatchSpawn( $"mdl/custom_maps/mp_rr_chill/mp_rr_chill_seccion9.rmdl", startingpos, startingang,  SOLID_VPHYSICS, -1 )
	SetCommonLinesForMapProp( seccion9, scale )
	DispatchSpawn( seccion9 )
	
	//seccion10
	entity seccion10 = CreatePropDynamic_NoDispatchSpawn( $"mdl/custom_maps/mp_rr_chill/mp_rr_chill_seccion10.rmdl", startingpos, startingang,  SOLID_VPHYSICS, -1 )
	SetCommonLinesForMapProp( seccion10, scale )
	DispatchSpawn( seccion10 )
	
	//collision
	array < entity > collisionModel
	collisionModel.extend( Chill_Load1( startingpos ) )
	collisionModel.extend( Chill_Load2( startingpos ) )

	
	thread function () : ( startingpos )
	{
		#if DEVELOPER
		FlagWait( "EntitiesDidLoad" ) //for when I load the map via _mapspawn
		
		ForceSaveOgSkyboxOrigin()
		#endif
		//Lightning.
		FS_ResetMapLightning()
		WaitFrame()

		SetConVarFloat( "jump_graceperiod", 0 )
		SetConVarFloat( "mat_envmap_scale", 0.12 )

		SetConVarFloat( "mat_autoexposure_max", 1.0 )
		SetConVarFloat( "mat_autoexposure_max_multiplier", 3 )
		SetConVarFloat( "mat_autoexposure_min_multiplier", 3.0 )
		SetConVarFloat( "mat_autoexposure_min", 1.7 )

		SetConVarFloat( "mat_sky_scale", 0.01 )
		SetConVarString( "mat_sky_color", "2.0 1.2 0.5 1.0" )
		SetConVarFloat( "mat_sun_scale", 1 )
		SetConVarString( "mat_sun_color", "1.0 1.0 1.0 1.0" )
		SetConVarFloat( "mat_bloom_max_lighting_value", 0.2 )

		//cannons
		file.playerSpawnedProps.append( FSCannon_Create( <40676.5586, -10610.1416, -20472.6426>, 48, <1.0, 0.0, 1.0>) )
		file.playerSpawnedProps.append( FSCannon_Create( <43311.0898, -10610.4277, -20470.5313>, 48, <-1.0, 0.0, 1.0>) )
	
		//Wind column effect, two so we complete a cylinder-like shape
		file.playerSpawnedProps.append( StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( $"P_s2s_flap_wind" ), <40676.5586, -10610.1416, -20435>, Vector( -30, 0, 0 ) ) )
		file.playerSpawnedProps.append( StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( $"P_s2s_flap_wind" ), <43311.0898, -10610.4277, -20435>, Vector( -30, -180, 0 ) ) )

		//Add weapon racks.
		file.playerSpawnedProps.append( MapEditor_CreateRespawnableWeaponRack( <43266.2695, -9999.79004, -20494.6563>, <0, 180, 0>, "mp_weapon_halosniperrifle", 0.5 ) )
		file.playerSpawnedProps.append( MapEditor_CreateRespawnableWeaponRack( <40727.457, -9998.79199, -20494.6563>, <0, 0, 0>, "mp_weapon_halosniperrifle", 0.5 ) )
		file.playerSpawnedProps.append(MapEditor_CreateRespawnableWeaponRack( <40859.6367, -10779.4385, -20586.4375>, <0, 90, 0>, "mp_weapon_haloneedler", 0.5 ) )
		file.playerSpawnedProps.append( MapEditor_CreateRespawnableWeaponRack( <43127.5742, -10779.4648, -20586.4375>, <0, 90, 0>, "mp_weapon_haloneedler", 0.5 ) )
		
		file.playerSpawnedProps.append( MapEditor_CreateRespawnableWeaponRack( <43896.0391, -10764.7637, -20494.6563>, <0, 90, 0>, "mp_weapon_halosmg", 0.5 ) )
		file.playerSpawnedProps.append( MapEditor_CreateRespawnableWeaponRack( <40098.2461, -10769.7568, -20494.6563>, <0, 90, 0>, "mp_weapon_halosmg", 0.5 ) )
		file.playerSpawnedProps.append( MapEditor_CreateRespawnableWeaponRack( <40013.0664, -9757.24805, -20464.0566>, <0, 180, 0>, "mp_weapon_halobattlerifle", 0.5 ) )
		file.playerSpawnedProps.append( MapEditor_CreateRespawnableWeaponRack( <40013.0586, -10243.4219, -20464.0566>, <0, -180, 0>, "mp_weapon_halobattlerifle", 0.5 ) )
		file.playerSpawnedProps.append(MapEditor_CreateRespawnableWeaponRack( <43987.5313, -10241.0508, -20464.0566>, <0, 0, 0>, "mp_weapon_halobattlerifle", 0.5 ) )
		file.playerSpawnedProps.append( MapEditor_CreateRespawnableWeaponRack( <43986.7383, -9755.34863, -20464.0566>, <0, 0, 0>, "mp_weapon_halobattlerifle", 0.5 ) )
		file.playerSpawnedProps.append( MapEditor_CreateRespawnableWeaponRack( <43902.8867, -9319.55664, -20431.0566>, <0, -90, 0>, "mp_weapon_halodmr", 0.5 ) )
		file.playerSpawnedProps.append( MapEditor_CreateRespawnableWeaponRack( <40100.6602, -9312.33887, -20431.0566>, <0, -90, 0>, "mp_weapon_halodmr", 0.5 ) )
		file.playerSpawnedProps.append( MapEditor_CreateRespawnableWeaponRack( <42050.5703, -9994.34082, -20213.0469>, <0, 0, 0>, "mp_weapon_haloshotgun", 0.5 ) )
		file.playerSpawnedProps.append( MapEditor_CreateRespawnableWeaponRack( <41947.1797, -9995.0625, -20212.5527>, <0, -180, 0>, "mp_weapon_haloshotgun", 0.5 ) )
		
		// Adjust sun flare for rotated skybox.
		foreach( player in GetPlayerArray() )
		{
			if( !IsValid( player ) )
				continue
			
			Remote_CallFunction_Replay( player, "FS_ForceAdjustSunFlareParticleOnClient", 2 ) //chill 
		}

		if( MapName() == eMaps.mp_flowstate )
		{
			//Rotate skybox for Chill map.
			entity skyboxCamera = GetEnt( "skybox_cam_level" )
			skyboxCamera.SetOrigin( file.ogSkyboxOrigin + <0, 0, 85> )
			skyboxCamera.SetAngles( <0, 67, 0> ) //Chill
		}
	}()
}

void function SpawnBeavercreek()
{
	if( MapName() != eMaps.mp_flowstate )
		return

	vector startingpos = Vector(42000, -10000, -26000) //Vector( 0,0,2000 ) // 
	vector startingang = Vector(0,-90,0)
	float scale = 3000

	//seccion1
	entity seccion1 = CreatePropDynamic_NoDispatchSpawn( $"mdl/custom_maps/mp_rr_beavercreek/mp_rr_beavercreek_parte1.rmdl", startingpos, startingang,  SOLID_VPHYSICS, -1 )
	SetCommonLinesForMapProp( seccion1, scale )
	DispatchSpawn( seccion1 )

	//seccion2
	entity seccion2 = CreatePropDynamic_NoDispatchSpawn( $"mdl/custom_maps/mp_rr_beavercreek/mp_rr_beavercreek_parte2.rmdl", startingpos, startingang,  SOLID_VPHYSICS, -1 )
	SetCommonLinesForMapProp( seccion2, scale )
	DispatchSpawn( seccion2 )
	
	LoadBeavercreek1( startingpos )
	LoadBeavercreek2( startingpos )
	
	thread function () : ( startingpos )
	{
		#if DEVELOPER
		FlagWait( "EntitiesDidLoad" ) //for when I load the map via _mapspawn
		
		ForceSaveOgSkyboxOrigin()
		#endif
		//Lightning.
		FS_ResetMapLightning()
		WaitFrame()

		SetConVarFloat( "jump_graceperiod", 0 )
		SetConVarFloat( "mat_envmap_scale", 0.12 )

		SetConVarFloat( "mat_autoexposure_max", 1.0 )
		SetConVarFloat( "mat_autoexposure_max_multiplier", 3 )
		SetConVarFloat( "mat_autoexposure_min_multiplier", 3.0 )
		SetConVarFloat( "mat_autoexposure_min", 1.7 )

		SetConVarFloat( "mat_sky_scale", 0.01 )
		SetConVarString( "mat_sky_color", "2.0 1.2 0.5 1.0" )
		SetConVarFloat( "mat_sun_scale", 1 )
		SetConVarString( "mat_sun_color", "1.0 1.0 1.0 1.0" )
		SetConVarFloat( "mat_bloom_max_lighting_value", 0.2 )

		//TODO ADD WEAPON RACKS
		FS_BuildBeaverCreekTeleporters()

		//Add some OOB triggers.
		file.playerSpawnedProps.append( AddOutOfBoundsTriggerWithParams( <41779.8359, -10134.5674, -25237.0918>, 5000 ) )
		
		//Adjust sun flare for rotated skybox.
		foreach( player in GetPlayerArray() )
		{
			if( !IsValid( player ) )
				continue
			
			Remote_CallFunction_Replay( player, "FS_ForceAdjustSunFlareParticleOnClient", 2 ) //chill 
		}

		if( MapName() == eMaps.mp_flowstate )
		{
			//Rotate skybox for Chill map.
			entity skyboxCamera = GetEnt( "skybox_cam_level" )
			skyboxCamera.SetOrigin( file.ogSkyboxOrigin + <0, 0, 85> )
			skyboxCamera.SetAngles( <0, 67, 0> ) //Chill
		}
	}()
}

//who cares. Cafe
vector tp1 = <41997.957, -11697.3643, -26018.1563>
vector tp1Angs = <0, -88.7698135, 0>
vector tp2 = <41991.0234, -8477.37012, -26018.1563>
vector tp2Angs = <0, 85.6242523, 0>

void function FS_BuildBeaverCreekTeleporters()
{
	entity tp1Ent = CreateInfoTarget( tp1, <0,0,0> )
	entity tp2Ent = CreateInfoTarget( tp2, <0,0,0> )
	
	file.playerSpawnedProps.append( tp1Ent )
	file.playerSpawnedProps.append( tp2Ent )

	entity tp1Trigger = CreateEntity( "trigger_cylinder" )
	tp1Trigger.SetRadius( 10 )
	tp1Trigger.SetAboveHeight( 36 )
	tp1Trigger.SetBelowHeight( 36 )
	tp1Trigger.SetOrigin( tp1 )
	tp1Trigger.SetParent( tp1Ent )
	DispatchSpawn( tp1Trigger )

	tp1Trigger.SetEnterCallback( tp1_OnAreaEnter )

	entity tp2Trigger = CreateEntity( "trigger_cylinder" )
	tp2Trigger.SetRadius( 10 )
	tp2Trigger.SetAboveHeight( 36 )
	tp2Trigger.SetBelowHeight( 36 )
	tp2Trigger.SetOrigin( tp2 )
	tp2Trigger.SetParent( tp2Ent )
	DispatchSpawn( tp2Trigger )

	tp2Trigger.SetEnterCallback( tp2_OnAreaEnter )
}

void function tp1_OnAreaEnter( entity trigger, entity player )
{
	if( !IsValid( player ) || !IsAlive( player ) || !IsValid( trigger ) )
		return
		
	player.SetVelocity(<0,0,0>)
	player.SetOrigin( tp2 )
	player.SetAngles( tp2Angs )
	EmitSoundOnEntityOnlyToPlayer( player, player, "PhaseGate_Enter_1p" )
	EmitSoundOnEntityExceptToPlayer( player, player, "PhaseGate_Enter_3p" )
}

void function tp2_OnAreaEnter( entity trigger, entity player )
{
	if( !IsValid( player ) || !IsAlive( player ) || !IsValid( trigger ) )
		return
		
	player.SetVelocity(<0,0,0>)
	player.SetOrigin( tp1 )
	player.SetAngles( tp1Angs )
	EmitSoundOnEntityOnlyToPlayer( player, player, "PhaseGate_Enter_1p" )
	EmitSoundOnEntityExceptToPlayer( player, player, "PhaseGate_Enter_3p" )
}

void function FS_ResetMapLightning()
{
	SetConVarToDefault( "mat_sun_color" )
	SetConVarToDefault( "mat_sun_scale" )
	SetConVarToDefault( "mat_sky_color" )
	SetConVarToDefault( "mat_sky_scale" )
	SetConVarToDefault( "mat_autoexposure_min_multiplier" )
	SetConVarToDefault( "mat_autoexposure_min" )
	SetConVarToDefault( "mat_autoexposure_max_multiplier" )
	SetConVarToDefault( "mat_autoexposure_max" )
	SetConVarToDefault( "mat_bloom_max_lighting_value" )
	// SetConVarToDefault( "jump_graceperiod" )
	SetConVarToDefault( "mat_envmap_scale" )
}

void function ForceSaveOgSkyboxOrigin()
{
	entity skyboxCamera = GetEnt( "skybox_cam_level" )
	file.ogSkyboxOrigin = skyboxCamera.GetOrigin()
}

LocationSettings function FSDM_GetSelectedLocation()
{
	return file.selectedLocation
}

array<string> function GetBlackListedWeapons()
{
	return file.blacklistedWeapons
}

//Instagib
void function FS_Instagib_PlayerSpawn( entity player )
{
	if( !IsValid( player ) )
		return

	//Force Default Player Settings
	SetPlayerSettings(player, INSTAGIB_PLAYER_SETTINGS)
	// player.SetMoveSpeedScale( 1 )
	// player.SetAccelerationScale( 2 )
	// player.SetPowerRegenRateScale( 2 )
}

void function FS_Instagib_OnPlayerDamaged(entity victim, var damageInfo)
{
	if ( !IsValid(victim) || !victim.IsPlayer() || Bleedout_IsBleedingOut(victim) ) 
		return

	entity attacker = DamageInfo_GetAttacker( damageInfo )

	if ( !IsAlive( attacker ) ||  !attacker.IsPlayer() )
		return

	vector origin = victim.GetWorldSpaceCenter()
	EmitSoundAtPosition( victim.GetTeam(), origin, "ai_reaper_nukedestruct_explo_3p" )
	PlayFX( $"P_plasma_exp_SM", origin, victim.GetAngles() )
	
	victim.Die( attacker, attacker, { damageSourceId = eDamageSourceId.mp_weapon_lightninggun } )
	// DamageInfo_SetDamage( damageInfo, victim.GetHealth() + 1 )
}

void function ServerMsgToBox( entity player, string text, float Width = 600, float duration = 7.0, string sound = "", string subText = "")
{
	if( !IsValid( player ) || !player.p.isConnected )
		return
	
	string sendMessage
	for ( int textType = 0 ; textType < 2 ; textType++ )
	{
		sendMessage = textType == 0 ? text : subText

		for ( int i = 0; i < sendMessage.len(); i++ )
		{
			Remote_CallFunction_NonReplay( player, "fs_ServerMsgsToChatBox_BuildMessage", textType, sendMessage[i] )
		}
	}
	Remote_CallFunction_NonReplay( player, "fs_ServerMsgsToChatBox_ShowMessage", Width, duration )

	if ( sound != "" )
		return
}
	
	
bool function ValidateWeaponTgiveSettings( entity player, string weaponRef )
{
	int uiType = eMsgUI.WAVE
	
	if ( FlowState_AdminTgive() && !IsAdmin(player) )
	{
		LocalMsg( player, "#FS_ERROR", "#FS_DisabledTDMWeps", uiType )
		return false
	}
	
	if( is1v1EnabledAndAllowed() && isPlayerInWaitingList( player ) )
	{
		LocalMsg( player, "#FS_NotAllowedWaiting", "", uiType )
		return false
	}
	
	if( is1v1EnabledAndAllowed() && !isCustomWeaponAllowed() && !isPlayerInChallenge( player ) )
	{
		LocalMsg( player, "#FS_CustomWepChalOnly", "#FS_CUSTOM_WEAPON_CHAL_ONLY", uiType )
		return false
	}

	if( Time() < player.p.lastTgiveUsedTime + FlowState_TgiveDelay() )
	{
		LocalMsg( player, "#FS_TgiveCooldown", "", uiType )
		return false
	}
	
	if( !SURVIVAL_Loot_IsRefValid( weaponRef ) || IsForcedlyDisabledWeapon( weaponRef ) )
	{
		LocalMsg( player, "#FS_WepNotAllowed", "", uiType )
		return false
	}

    if( file.blacklistedWeapons.len() && file.blacklistedWeapons.find( weaponRef ) != -1 )
	{
		LocalMsg( player, "#FS_WepBlacklisted", "", uiType )
		return false
	}

	if( file.blacklistedAbilities.len() && file.blacklistedAbilities.find( weaponRef ) != -1 )
	{
		LocalMsg( player, "FS_AbilityBlacklisted", "", uiType )
		return false
	}
	
	return true
}

void function Vamp_OnPlayerDamaged(entity victim, var damageInfo)
{
	if ( !IsValid(victim) || !victim.IsPlayer() || !IsAlive( victim ) ) 
		return

	entity attacker = InflictorOwner( DamageInfo_GetAttacker(damageInfo) )
	
	if( !IsValid( attacker ) || !attacker.IsPlayer() || !IsAlive( attacker ) )
		return

	int sourceId = DamageInfo_GetDamageSourceIdentifier( damageInfo )
	float damage = DamageInfo_GetDamage( damageInfo )

	float attshield = float( attacker.GetShieldHealth() )
	float atthealth = float( attacker.GetHealth() )
	
	if ( atthealth < attacker.GetMaxHealth() )
	{
		attacker.SetHealth( min( atthealth + damage, float( attacker.GetMaxHealth() ) ) )
	} 
	else if ( attshield < attacker.GetShieldHealthMax() )
	{
		attacker.SetShieldHealth( min( attshield + damage, float( attacker.GetShieldHealthMax() ) ) )
	}
}

void function Vamp_OnWeaponAttack( entity player, entity weapon, string weaponName, int ammoUsed, vector attackOrigin, vector attackDir )
{
	// if( !IsValid( player ) )  //Is this necessary to perform a valid check per bullet.. ?
		// return
		
	player.RefillAllAmmo()
}

void function Tracker_SetChampionOnPersistenceLoad()
{
	if( !bLog() || !Flowstate_IsTrackerSupportedMode() )
	{
		FlagSet( "PreviousChampionDetermined" )
		return
	}
		
	thread
	(	
		void function() : () 
		{
			FlagWait( "DeterminePreviousChampion" )
			
			array<entity> championCandidates
			
			foreach( player in GetPlayerArray() )
			{
				string uid = player.GetPlatformUID()
				
				#if DEVELOPER
					printt( player, GetPlayerStatBool( uid, "previous_champion" ) )
				#endif
				
				if( GetPlayerStatBool( uid, "previous_champion" ) )
					championCandidates.append( player )
			}

			if( championCandidates.len() > 0 )
			{							
				array<entity> bestChampions = Tracker_DetermineBestChampions( championCandidates )
				
				bool bFoundChampion = false
				if( !bestChampions.len() )
				{
					file.previousChampion = null
					file.previousChallenger = null
				}
				else 
				{
					if( bestChampions.len() == 1 )
						file.previousChallenger = null
						
					foreach( champion in bestChampions )
					{
						if( !IsValid( champion ) )
							continue
						
						if( !bFoundChampion )
						{
							SetChampion( champion )
							#if DEVELOPER 
								Warning( "Champion set from tracker as: " + string( champion ) )
							#endif
							
							file.previousChampion = champion
							bFoundChampion = true
						}
						else 
						{
							file.previousChallenger = champion
							break
						}
					}
				}	
			}
			
			FlagSet( "PreviousChampionDetermined" ) //let waiting tdm loop know to proceed
		}
	)()
}

//Todo: Probably use better or custom new pdef fields. ~mkos
void function FSDM_SetMatchPersistentVarsForPlayer( entity player )
{
	GameSummarySquadData statSummaryData = GameSummary_GetPlayerData( player )
	
	int i = 0
	
	player.SetPersistentVar( "lastGameSquadStats[" + i + "].platformUid", player.GetPlatformUID() )
	player.SetPersistentVar( "lastGameSquadStats[" + i + "].kills", statSummaryData.kills )
	player.SetPersistentVar( "lastGameSquadStats[" + i + "].damageDealt", statSummaryData.damageDealt )
	player.SetPersistentVar( "lastGameSquadStats[" + i + "].survivalTime", statSummaryData.survivalTime )
	player.SetPersistentVar( "lastGameSquadStats[" + i + "].revivesGiven", statSummaryData.revivesGiven )
	player.SetPersistentVar( "lastGameSquadStats[" + i + "].respawnsGiven", statSummaryData.respawnsGiven )
	
	#if DEVELOPER 
		printt( "\n\n\n" )
		printt( "-------- SAVING DATA ----------" )
		printt( "player", player )
		printt( "uid", player.GetPlatformUID() )
		printt( "kills", statSummaryData.kills )
		printt( "damageDealt", statSummaryData.damageDealt )
		printt( "survivalTime", statSummaryData.survivalTime )
		printt( "revivesGiven", statSummaryData.revivesGiven )
		printt( "respawnsGiven", statSummaryData.respawnsGiven )
		printt( "\n\n\n" )
	#endif 
}

GameSummarySquadData function FSDM_GetPreivousMatch_PersistentData( entity player )
{
	GameSummarySquadData statsSummaryData
	
	int i = 0 
	
	statsSummaryData.uid = expect string( player.GetPersistentVar( "lastGameSquadStats[" + i + "].platformUid" ) )
	statsSummaryData.kills = player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].kills" )
	statsSummaryData.damageDealt = player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].damageDealt" )
	statsSummaryData.survivalTime = player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].survivalTime" )
	statsSummaryData.revivesGiven = player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].revivesGiven" )
	statsSummaryData.respawnsGiven = player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].respawnsGiven" )

	#if DEVELOPER 
		printt( "\n\n\n" )
		printt( "-------- READING PLAYERS ----------" )
		printt( "player", player )
		printt( "uid", statsSummaryData.uid )
		printt( "kills", statsSummaryData.kills )
		printt( "damageDealt", statsSummaryData.damageDealt )
		printt( "survivalTime", statsSummaryData.survivalTime )
		printt( "revivesGiven", statsSummaryData.revivesGiven )
		printt( "respawnsGiven", statsSummaryData.respawnsGiven )
		printt( "\n\n\n" )
	#endif

	return statsSummaryData
}

array<entity> function FSDM_ReturnBestPlayers_FromChampions( array<entity> champions )
{
	array<GameSummarySquadData> allSummaryData
	
	ArrayRemoveInvalid( champions )
	
	foreach( player in champions )
		allSummaryData.append( FSDM_GetPreivousMatch_PersistentData( player ) )	
		
	#if DEVELOPER 
		foreach( GameSummarySquadData data in allSummaryData )
		{
			printt( "\n\n\n" )
			printt( "-------- SHOWING CHAMPIONS ----------" )
			printt( "uid", data.uid )
			printt( "kills", data.kills )
			printt( "damageDealt", data.damageDealt )
			printt( "survivalTime", data.survivalTime )
			printt( "revivesGiven", data.revivesGiven )
			printt( "respawnsGiven", data.respawnsGiven )
			printt( "\n\n\n" )
		}
	#endif
		
	//determine champion based on current mode. //Todo: Make better sorts for various modes + utilize more data
	
	switch( Playlist() )
	{
		case ePlaylists.fs_survival:
		case ePlaylists.fs_survival_solos:
		case ePlaylists.fs_survival_duos:
		case ePlaylists.fs_survival_trios:
		case ePlaylists.SURVIVAL:
			
			allSummaryData.sort( FS_SortSurvival )
			break 
			
		case ePlaylists.fs_dm:
		case ePlaylists.fs_1v1:
		case ePlaylists.fs_tdm:
		case ePlaylists.fs_lgduels_1v1:
		case ePlaylists.winterexpress:
		case ePlaylists.fs_vamp_1v1:
		case ePlaylists.fs_1v1_headshots_only:
		case ePlaylists.fs_scenarios:
		
			allSummaryData.sort( FS_SortDM )
			break
			
		default:
			#if DEVELOPER 
				Warning( "No champion sort method provided for playlist, using DM" )
			#endif
			
			allSummaryData.sort( FS_SortDM )
			break
	}
	
	array<entity> players
	
	foreach( GameSummarySquadData data in allSummaryData )
	{
		players.append( GetPlayerEntityByUID( data.uid ) )
	}
	
	return players
}

int function FS_SortSurvival( GameSummarySquadData a, GameSummarySquadData b )
{
	if ( a.survivalTime > b.survivalTime )
		return -1
	if ( a.survivalTime < b.survivalTime )
		return 1
	if ( a.kills > b.kills )
		return -1
	if ( a.kills < b.kills )
		return 1
	if ( a.damageDealt > b.damageDealt )
		return -1
	if ( a.damageDealt < b.damageDealt )
		return 1
	return 0
}

int function FS_SortDM( GameSummarySquadData a, GameSummarySquadData b )
{
	if ( a.kills > b.kills )
		return -1
	if ( a.kills < b.kills )
		return 1
	if ( a.damageDealt > b.damageDealt )
		return -1
	if ( a.damageDealt < b.damageDealt )
		return 1
		
	return 0
}

TrackerRecap function Tracker_GetChampionRecap( entity player )
{
	string uid = player.GetPlatformUID()
	
	TrackerRecap recap
	
	recap.uid = uid
	recap.kills = GetPlayerStatInt( uid, "previous_kills" )
	recap.damage = GetPlayerStatInt( uid, "previous_damage" )
	recap.score = GetPlayerStatInt( uid, "previous_score" )
	//recap.survivalTime = GetPlayerStatInt( uid, "previous_survival_time" )
	
	return recap
}

array<entity> function Tracker_DetermineBestChampions( array<entity> championCandidates )
{
	array<TrackerRecap> allSummaryData
	
	ArrayRemoveInvalid( championCandidates )
	
	foreach( player in championCandidates )
		allSummaryData.append( Tracker_GetChampionRecap( player ) )	
		
	#if DEVELOPER 
		foreach( TrackerRecap data in allSummaryData )
		{
			printt( "\n\n\n" )
			printt( "-------- SHOWING TRACKER CHAMPIONS ----------" )
			printt( "uid", data.uid )
			printt( "kills", data.kills )
			printt( "damage", data.damage )
			//printt( "survivalTime", data.survivalTime )
			printt( "\n\n\n" )
		}
	#endif
		
	//determine champion based on current mode. //Todo: Make better sorts for various modes + utilize more data
	
	switch( Playlist() )
	{
		case ePlaylists.fs_survival:
		case ePlaylists.fs_survival_solos:
		case ePlaylists.fs_survival_duos:
		case ePlaylists.fs_survival_trios:
		case ePlaylists.SURVIVAL:
			
			allSummaryData.sort( FS_SortSurvival_Tracker )
			break
			
		case ePlaylists.fs_dm:
		case ePlaylists.fs_1v1:
		case ePlaylists.fs_tdm:
		case ePlaylists.fs_lgduels_1v1:
		case ePlaylists.winterexpress:
		case ePlaylists.fs_vamp_1v1:
		case ePlaylists.fs_1v1_headshots_only:
		
			allSummaryData.sort( FS_SortDM_Tracker )
			break
			
		case ePlaylists.fs_scenarios:
			allSummaryData.sort( FS_SortScenarios_Tracker )
			break
			
		default:
			#if DEVELOPER 
				Warning( "No champion sort method provided for playlist, using DM" )
			#endif
			
			allSummaryData.sort( FS_SortDM_Tracker )
			break
	}
	
	array<entity> players
	
	foreach( TrackerRecap data in allSummaryData )
	{
		players.append( GetPlayerEntityByUID( data.uid ) )
	}
	
	return players
}

int function FS_SortSurvival_Tracker( TrackerRecap a, TrackerRecap b )
{
	// if ( a.survivalTime > b.survivalTime )
		// return -1
	// if ( a.survivalTime < b.survivalTime )
		// return 1
	if ( a.kills > b.kills )
		return -1
	if ( a.kills < b.kills )
		return 1
	if ( a.damage > b.damage )
		return -1
	if ( a.damage < b.damage )
		return 1
	return 0
}

int function FS_SortDM_Tracker( TrackerRecap a, TrackerRecap b )
{
	if ( a.kills > b.kills )
		return -1
	if ( a.kills < b.kills )
		return 1
	if ( a.damage > b.damage )
		return -1
	if ( a.damage < b.damage )
		return 1
		
	return 0
}

int function FS_SortScenarios_Tracker( TrackerRecap a, TrackerRecap b )
{
	if ( a.score > b.score )
		return -1
	if ( a.score < b.score )
		return 1
	if ( a.kills > b.kills )
		return -1
	if ( a.kills < b.kills )
		return 1
	if ( a.damage > b.damage )
		return -1
	if ( a.damage < b.damage )
		return 1
		
	return 0
}

bool function GetChampionShowingState()
{
	return file.bIsChampionShowing
}

void function SetChampionShowingState( bool setting, float newTime = -1.0 )
{
	SetGlobalNetTime( "championDisplayEndTime", newTime )
	file.bIsChampionShowing = setting
}

void function WaitForChampionToFinish()
{
	while( Time() < GetGlobalNetTime( "championDisplayEndTime" ) )
		WaitFrame()
}