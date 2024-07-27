// WINTER EXPRESS
// ported by @CafeFPS
// mp_rr_desertlands_holiday map by zee_x64

// todo: make own ui for team points
// figure out why hovertank camera movers stopped working same as in halo ctf mod ( wtf )
// fix custom waypoint for train

global function WinterExpress_Init
global function WinterExpress_IsNarrowWin

#if SERVER
global function WinterExpress_CanSquadBeEliminated
global function WinterExpress_SpawnObjectiveFX
global function WinterExpress_GetCurrentRank
#endif

#if CLIENT
global function ServerCallback_CL_GameStartAnnouncement

global function ServerCallback_CL_RoundEnded
global function ServerCallback_CL_WinnerDetermined
global function ServerCallback_CL_ObjectiveStateChanged
global function ServerCallback_CL_SquadOnObjectiveStateChanged
global function ServerCallback_CL_SquadEliminationStateChanged
global function ServerCallback_CL_RespawnAnnouncement
global function ServerCallback_CL_ObserverModeSetToTrain
global function ServerCallback_CL_CameraLerpFromStationToHoverTank
global function ServerCallback_CL_CameraLerpTrain

global function UICallback_WinterExpress_OpenCharacterSelect
global function ServerCallback_CL_UpdateOpenMenuButtonCallbacks_Gameplay
global function ServerCallback_CL_DeregisterModeButtonPressedCallbacks
global function ServerCallback_CL_UpdateCurrentLoadoutHUD

global function WinterExpress_GetTeamScore
global function WinterExpress_IsTeamWinning
#endif

#if UI
global function UI_UpdateOpenMenuButtonCallbacks_Spectate
#endif

global enum eWinterExpressRoundState
{
	OBJECTIVE_ACTIVE,
	ABOUT_TO_CHANGE_STATIONS,
	CHANGING_STATIONS,
	ABOUT_TO_UNLOCK_STATION,
}

global enum eWinterExpressRoundEndCondition
{
	OBJECTIVE_CAPTURED,
	LAST_SQUAD_ALIVE,
	TIMER_EXPIRED,
	NO_SQUADS_ALIVE,
	OVERTIME_EXPIRED,
}

global enum eWinterExpressObjectiveState
{
	UNCONTROLLED,
	CONTESTED,
	CONTROLLED,
	INACTIVE,
}

const SPAWN_DIST = 3000
const SKY_DIVE_SPAWN_DIST = 10000
const SKY_DIVE_SPAWN_HEIGHT = 11000
const SKY_DIVE_CIRCLE_SPAWN_DIST = 10000
const SKY_DIVE_CIRCLE_SPAWN_HEIGHT = 7800
const SPAWN_MIN_RADIUS = 64
const SPAWN_MAX_RADIUS = 320
const SPAWN_MAX_TRY_COUNT = 40
const SPAWN_MAX_ARC = 45.0
const GRACE_PERIOD_SPAWN_DELAY = 5.0
const CHARACTER_SELECT_MIN_TIME = 5.0 // this should match the same const in winter_express.rui

const float WINTER_EXPRESS_TRAIN_MAX_SPEED = 500
const float WINTER_EXPRESS_TRAIN_ACCELERATION = 50
const float WINTER_EXPRESS_LEAVE_BUFFER = 12
const float WINTER_EXPRESS_FIRST_STATION_UNLOCK_DELAY = 10

// commentary
const float CONTESTED_LINE_DEBOUNCE = 10.0
const float HOLDING_LINE_DEBOUNCE = 10.0
const float REROLL_CHANCE = 50.0
global const array<string> WINTER_EXPRESS_DISABLED_BATTLE_CHATTER_EVENTS = [    "bc_anotherSquadAttackingUs",
	"bc_engagingEnemy",
	"bc_squadsLeft2 ",
	"bc_squadsLeft3 ",
	"bc_squadsLeftHalf",
	"bc_twoSquaddiesLeft",
	"bc_championEliminated",
	"bc_killLeaderNew",
	"bc_scatteredNag" ]

global const array<string> LONG_OR_FLAVORFUL_LINES = [    "Host_Mirage_SquadWinRoundByElim_03b_01",
	"Host_Mirage_SquadWinRoundByElim_03b_02",
	"Host_Mirage_TrainMoving_02b_01",
	"Host_Mirage_TrainMoving_02b_02",
	"Host_Mirage_TrainMoving_02b_03",
	"Host_Mirage_TrainMoving_04b_01",
	"Host_Mirage_TrainMoving_04b_02",
	"Host_Mirage_TrainMoving_04b_03",
	"Host_Mirage_WinnerCloseTimer_03b_01",
	"Host_Mirage_WinnerCloseTimer_03b_02",
	"Host_Mirage_WinnerFoundPointsNarrow_01b_01",
	"Host_Mirage_WinnerFoundPointsNarrow_01b_02",
	"Host_Mirage_WinnerFoundPointsWide_02b_01",
	"Host_Mirage_WinnerFoundPointsWide_02b_02",
	"Host_Mirage_PhoneLost_01b_01",
	"Host_Mirage_PhoneLost_01b_02",
	"Host_Mirage_PhoneLost_02b_01",
	"Host_Mirage_PhoneLost_02b_02",
	"Host_Mirage_PhoneLost_04b_01",
	"Host_Mirage_PhoneLost_04b_02",
	"Host_Mirage_TrainStop_03_01",
	"Host_Mirage_TrainStop_03_02",
	"Host_Mirage_TrainStop_03_03" ]

const vector OBJECTIVE_GREEN = <118, 224, 221>
const vector OBJECTIVE_RED = <164, 62, 62>
const vector OBJECTIVE_ORANGE = <240, 104, 64>
const vector OBJECTIVE_YELLOW = <245, 231, 110>

const string GAME_START_ANNOUNCEMENT = "#PL_GAME_START_ANNOUNCEMENT"
const string GAME_START_ANNOUNCEMENT_SUB = "#PL_GAME_START_ANNOUNCEMENT_SUB"

const string CAPTURED_THE_TRAIN = "#PL_CAPTURED_THE_TRAIN"
const string LOST_THE_TRAIN = "#PL_LOST_THE_TRAIN"
const string CONTESTING_THE_TRAIN = "#PL_CONTESTING_THE_TRAIN"
const string PL_OBJECTIVE_LOCKED = "#PL_INACTIVE_OBJECTIVE"

const string ROUND_END_OBJECTIVE_CAPTURED = "#PL_ROUND_END_OBJECTIVE_CAPTURED"
const string ROUND_END_OBJECTIVE_CAPTURED_SUB = "#PL_ROUND_END_OBJECTIVE_CAPTURED_SUB"
const string ROUND_END_LAST_SQUAD_ALIVE = "#PL_ROUND_END_LAST_SQUAD_ALIVE"
const string ROUND_END_LAST_SQUAD_ALIVE_SUB = "#PL_ROUND_END_LAST_SQUAD_ALIVE_SUB"
const string ROUND_END_TIMER_EXPIRED = "#PL_ROUND_END_TIMER_EXPIRED"
const string ROUND_END_OVERTIME_EXPIRED = "#PL_ROUND_END_OVERTIME_EXPIRED"
const string ROUND_END_OVERTIME_EXPIRED_SUB = "#PL_ROUND_END_OVERTIME_EXPIRED_SUB"
const string ROUND_END_TIMER_EXPIRED_SUB = "#PL_ROUND_END_TIMER_EXPIRED_SUB"
const string ROUND_END_NO_SQUADS = "PL_ROUND_END_NO_SQUADS"
const string ROUND_END_NO_SQUADS_SUB = "PL_ROUND_END_NO_SQUADS_SUB"

const string PL_ROUND_STARTED = "#PL_ROUND_STARTED"
const string PL_ROUND_STARTED_SUB = "#PL_ROUND_STARTED_SUB"

const string PL_OBJECTIVE_MOVING = "#PL_OBJECTIVE_MOVING"
const string PL_OBJECTIVE_MOVING_SUB = "#PL_OBJECTIVE_MOVING_SUB"

const string ROUND_STATE_ACTIVE = "#PL_ROUND_STATE_ACTIVE"
const string ROUND_STATE_CHANGING = "#PL_ROUND_STATE_CHANGING"
const string ROUND_ACTIVE_OBJECTIVE = "#PL_ROUND_ACTIVE_OBJECTIVE"
const string ROUND_CHANGING_OBJECTIVE = "#PL_ROUND_CHANGING_OBJECTIVE"
const string CURRENT_OBJECTIVE = "#PL_CURRENT_OBJECTIVE"
const string RESPAWNING_ALLOWED = "#PL_RESPAWNING_ALLOWED"
const string RESPAWNING_DISABLED = "#PL_RESPAWNING_DISABLED"

const string LOSER_ANNOUNCEMENT = "#PL_LOSER_ANNOUNCEMENT"
const string LOSER_ANNOUNCEMENT_SUB = "#PL_LOSER_ANNOUNCEMENT_SUB"

const asset CHAIR_GLOW_FX = $"P_item_bluelion"
const string SOUND_THROW_ITEM = "weapon_sentryfragdrone_throw_1p"
const asset RESPAWN_BEACON_MOBILE_MODEL = $"mdl/props/pathfinder_beacon_radar/pathfinder_beacon_radar_animated.rmdl"

//Holiday Hovertank
const float  HOLIDAY_HOVERTANK_ALT_CHECK 	= 0

struct {
	int           scoreLimit
	int           roundLimit
	entity        trainRef
	array<entity> trainTriggers

	table<int, int>             objectiveScore
	table< int, bool > 			isTeamOnMatchPoint
	table< int, bool > 			hasTeamGottenMatchPointAnnounce

	#if SERVER
		array< HoverTank > 			hoverTanks
		table< HoverTank, string > 	hoverTankToNodeGroup
		array<entity> 				playersOnHovertank

		entity skydiveSpawn
		entity trainWaypoint
		entity nextStationWaypoint

		array<entity>               respawningPlayers
		table<int, array<entity> >  skydiveTeamPlayerArray
		array<entity>               playersInGracePeriod

		table< entity, table<entity, bool> > isPlayerInTrainCar

		array<int>    objectiveOwners // teams who are on the train
		array<entity> lootOnTrain

		int   cachedObjectiveOwner = -1
		float cachedObjectivePercent = 0

		entity             currentObjectiveTrigger = null
		entity             currentObjectiveMover = null
		table<int, entity> currentObjectiveVisualPerTeam

		table<int, array<Point> > customSpawnPoints

		int           lastTeamToScore = TEAM_INVALID
		int			  lastValidTeamToScore
		array<entity> spawnOnTeamArray

		bool                           shouldStoreUltimateCharge = false
		table< entity, int >           playerToStoredUltimateCharge
		table< entity, ItemFlavor >    playerUltimateChargeValidation

		array<entity> jumptowerIndex

		array<vector> spectateCameraLocations
		array<vector> spectateCameraAngles
		int           currentSpectateCamera = 0
		array<entity> deadPlayers

		array<entity>       playersThatHaveHeardRespawnLine
		table< int, float > teamLastHeardContestedLineTimestamps
		table< int, float > teamLastHeardHoldingLineTimestamps

		bool hasReachedFirstStation

		//KEEP THIS IN ORDER OF STATIONS
		array<vector> stationArray = [ <18551, 28225, -4852>, // refinery
			<1171, 32380, -3232>, //derailment
			<-886, 19747, -3077>, // freight
			<11697, 6255, -3967>, //capitol
			<20473, 13677, -4449> ] //gulch
	#endif

	#if CLIENT
		table<int, var> scoreElements
		table<int, var> scoreElementsFullmap
		table<int, var> squadOnObjectiveElements

		bool gameStartRuiCreated = false

		int    bestSquadIndex = -1
		entity trainWaypoint

		var gameStartRui = null
		var activeSpectateMusic = null
		bool OpenMenuGameplayButtonCallbackRegistered = false
		var legendSelectMenuPromptRui = null
		var customCaptureProgressRui = null
	#endif
} file

void function WinterExpress_Init()
{
	file.scoreLimit = GetCurrentPlaylistVarInt( "winter_express_score_limit", 3 )
	file.roundLimit = GetCurrentPlaylistVarInt( "winter_express_round_limit", 30 )

	#if SERVER
		//Cafe was here
		SurvivalShip_Init()
		MapZones_SharedInit()
		SurvivalFreefall_Init()
		Sh_ArenaDeathField_Init()
		AddClientCommandCallback("Flowstate_AssignCustomCharacterFromMenu", ClientCommand_Flowstate_AssignCustomCharacterFromMenu)

		SetCallback_ObserverThreadOverride( WinterExpress_StartObserving )
		PrecacheParticleSystem( $"P_ar_cylinder_radius_CP_1x1" )
		SURVIVAL_AddOverrideCircleLocation( < 11887.877930, 19320.305664, -3403.129395 >, 10, true )
		SetupSpectateCameras()

		AddCallback_EntitiesDidLoad( OnEntitiesDidLoad )
		AddCallback_OnClientConnected( OnClientConnected )
		AddCallback_OnClientDisconnected( OnClientDisconnected )
		AddCallback_GameStateEnter( eGameState.WaitingForPlayers, OnWaitingForPlayers_Server )
		AddCallback_GameStateEnter( eGameState.Playing, OnGameStatePlaying )
		AddCallback_GameStateEnter( eGameState.WinnerDetermined, OnWinnerDetermined )
		AddCallback_OnPlayerKilled( OnPlayerKilled_Inventory )
		AddCallback_OnPlayerKilled( OnPlayerKilled_GameState )
		AddCallback_OnPlayerKilled( OnPlayerKilled_Respawn )
		AddCallback_OnPlayerKilled( OnPlayerKilled_Commentary )
		// Survival_AddCallback_PlayerFreefallEnd( WinterExpress_PlayerFreefallEnd )

		//Flowstate weapon selector
		AddClientCommandCallback("CC_MenuGiveAimTrainerWeapon", CC_MenuGiveAimTrainerWeapon ) 
		AddClientCommandCallback("CC_AimTrainer_SelectWeaponSlot", CC_AimTrainer_SelectWeaponSlot )
		AddClientCommandCallback("CC_AimTrainer_WeaponSelectorClose", CC_AimTrainer_CloseWeaponSelector )

		AddCallback_OnPlayerRespawned( WinterExpress_OnPlayerRespawned )

		DesertlandsTrain_AddCallback_TrainAboutToArriveAtStation( TrainAboutToArriveAtStation )
		DesertlandsTrain_AddCallback_TrainArrivedAtStation( TrainArrivedAtStation )
		DesertlandsTrain_AddCallback_TrainAboutToLeaveStation( TrainAboutToLeaveStation )
		DesertlandsTrain_AddCallback_TrainLeavingFromStation( TrainLeavingStation )

		// AddCallback_OnLeaveMatch( OnLeaveMatch )
		AddCallback_OnClientConnected( OnPlayerConnected )
		AddCallback_PlayerClassChanged( OnPlayerClassChanged )

		// AbilityCarePackage_SetContentOverrideCallback(WinterExpress_OverrideAbilityCarePackage)
		// if ( IsUsingLoadoutSelectionSystem() )
		// {
			// AddCallback_LoadoutSelection_OnLoadoutUpdated( WinterExpress_OnLoadoutUpdated )
			// AddCallback_LoadoutSelection_OnLoadoutSelected( WinterExpress_OnLoadoutSelected )
			// AddCallback_OnPlayerMatchStateChanged( OnPlayerMatchStateChanged )
		// }

		RegisterSignal( "WinterExpress_ObjectiveCaptureCancelled" )
		RegisterSignal( "WinterExpress_RoundOver" )
		RegisterSignal( "WinterExpress_WaveSpawn" )

		RegisterSignal( "WinterExpress_ObjectiveControlled" )
		RegisterSignal( "WinterExpress_ObjectiveContested" )
		RegisterSignal( "WinterExpress_ObjectiveUncontrolled" )
		RegisterSignal( "WinterExpress_ObjectiveInactive" )
		RegisterSignal( "ready_for_skydive" )
		RegisterSignal( "WinterExpress_LeftDropship" )

		FlagInit( "FirstPlayerDied" )
		FlagInit( "WinterExpress_ObjectiveActive" )

		if ( GetCurrentPlaylistVarBool( "winter_express_store_ultimate_charge", false ) )
		{
			file.shouldStoreUltimateCharge = true
			// AddCallback_OnPlayerKilled( StoreUltimateChargeForPlayer )
		}

		// Disabled commentary events for LTM
		SurvivalCommentary_SetEventEnabled( eSurvivalEventType.PILOT_KILL, false ) // will manually trigger first blood
		SurvivalCommentary_SetEventEnabled( eSurvivalEventType.CIRCLE_MOVING, false )
		SurvivalCommentary_SetEventEnabled( eSurvivalEventType.FINAL_CIRCLE_MOVING, false )
		SurvivalCommentary_SetEventEnabled( eSurvivalEventType.CIRCLE_CLOSING_TO_NOTHING, false )
		SurvivalCommentary_SetEventEnabled( eSurvivalEventType.CARE_PACKAGE_DROPPING, false )
		SurvivalCommentary_SetEventEnabled( eSurvivalEventType.FIRST_BLOOD, false )
		SurvivalCommentary_SetEventEnabled( eSurvivalEventType.HALF_PLAYERS_ALIVE, false )
		SurvivalCommentary_SetEventEnabled( eSurvivalEventType.HALF_SQUADS_ALIVE, false )
		SurvivalCommentary_SetEventEnabled( eSurvivalEventType.HOVER_TANK_INBOUND, false )
		SurvivalCommentary_SetEventEnabled( eSurvivalEventType.ROUND_TIMER_STARTED, false )
		SurvivalCommentary_SetEventEnabled( eSurvivalEventType.FIRST_CIRCLE_MOVING, false )
		SurvivalCommentary_SetEventEnabled( eSurvivalEventType.CIRCLE_MOVES_1MIN, false )
		SurvivalCommentary_SetEventEnabled( eSurvivalEventType.CIRCLE_MOVES_10SEC, false )
		SurvivalCommentary_SetEventEnabled( eSurvivalEventType.CIRCLE_MOVES_30SEC, false )
		SurvivalCommentary_SetEventEnabled( eSurvivalEventType.CIRCLE_MOVES_45SEC, false )
		RegisterDisabledBattleChatterEvents( WINTER_EXPRESS_DISABLED_BATTLE_CHATTER_EVENTS )
	#endif

	#if CLIENT
		//Cafe was here
		RegisterSignal( "ReviveRuiThread" )
		Sh_ArenaDeathField_Init()
		ClSurvivalCommentary_Init()
		BleedoutClient_Init()
		ClSurvivalShip_Init()
		SurvivalFreefall_Init()
		ClUnitFrames_Init()
		Cl_SquadDisplay_Init()

		CircleAnnouncementsEnable( false )
		SetMapFeatureItem( 300, "#WINTER_EXPRESS_TRAIN_OBJECTIVE", "#WINTER_EXPRESS_TRAIN_DESC", $"rui/hud/gametype_icons/sur_train_minimap" ) //$"rui/hud/gametype_icons/survival/objective_icon" )

		AddCallback_OnPlayerLifeStateChanged( WinterExpress_OnPlayerLifeStateChanged )

		AddCreateCallback( PLAYER_WAYPOINT_CLASSNAME, OnWaypointCreated )
		AddCallback_GameStateEnter( eGameState.WaitingForPlayers, OnWaitingForPlayers_Client )

		AddCallback_GameStateEnter( eGameState.PickLoadout, DestroyGameStartRuiForGamestate )
		AddCallback_GameStateEnter( eGameState.Playing, DestroyGameStartRuiForGamestate )
		// AddCallback_GameStateEnter( eGameState.Resolution, WinterExpress_OnResolution )
		AddCallback_GameStateEnter( eGameState.WinnerDetermined, Client_OnWinnerDetermined )
		AddCallback_OnPlayerChangedTeam( Client_OnTeamChanged )

		AddCallback_OnScoreboardCreated( FinishGamestateRui )
		AddCallback_EntitiesDidLoad( OnEntitiesDidLoad_Client )
		AddCallback_OnCharacterSelectMenuClosed( WinterExpress_OnCharacterSelectMenuClosed )
		Survival_SetVictorySoundPackageFunction( GetVictorySoundPackage )

		RegisterDisabledBattleChatterEvents( WINTER_EXPRESS_DISABLED_BATTLE_CHATTER_EVENTS )

		FlagInit( "WinterExpress_ObjectiveStateUpdated", false )
		FlagInit( "WinterExpress_ObjectiveOwnerUpdated", false )
	#endif

	WinterExpress_RegisterNetworking()
}


void function WinterExpress_RegisterNetworking()
{
	Remote_RegisterClientFunction( "ServerCallback_CL_GameStartAnnouncement" )

	Remote_RegisterClientFunction( "ServerCallback_CL_RoundEnded", "int", 0, 128, "int", -2, 10000, "int", 0, 10000 )
	Remote_RegisterClientFunction( "ServerCallback_CL_ObjectiveStateChanged", "int", 0, 128, "int", -1, 128 )
	Remote_RegisterClientFunction( "ServerCallback_CL_SquadOnObjectiveStateChanged", "int", 0, 128, "bool" )
	Remote_RegisterClientFunction( "ServerCallback_CL_WinnerDetermined", "int", -1, 128 )
	Remote_RegisterClientFunction( "ServerCallback_CL_SquadEliminationStateChanged", "int", -1, 128, "bool" )
	Remote_RegisterClientFunction( "ServerCallback_CL_RespawnAnnouncement" )
	Remote_RegisterClientFunction( "ServerCallback_CL_ObserverModeSetToTrain" )
	Remote_RegisterClientFunction( "ServerCallback_CL_CameraLerpFromStationToHoverTank", "entity", "entity", "entity", "entity", "bool" )
	Remote_RegisterClientFunction( "ServerCallback_CL_CameraLerpTrain", "entity", "vector", -32000.0, 32000.0, 32, "entity", "bool" )
	Remote_RegisterClientFunction( "ServerCallback_CL_UpdateOpenMenuButtonCallbacks_Gameplay", "bool" )
	Remote_RegisterClientFunction( "ServerCallback_CL_DeregisterModeButtonPressedCallbacks" )
	Remote_RegisterClientFunction( "ServerCallback_CL_UpdateCurrentLoadoutHUD" )
	// Remote_RegisterClientFunction( "ServerCallback_FlowstateCaptureProgressUI", "float", -1.0, 99999.0, 32, "float", -1.0, 99999.0, 32 )

	RegisterNetworkedVariable( "WinterExpress_RoundState", SNDC_GLOBAL, SNVT_INT, -1 )
	RegisterNetworkedVariable( "WinterExpress_RoundEnd", SNDC_GLOBAL, SNVT_TIME, -1 )
	RegisterNetworkedVariable( "WinterExpress_ObjectiveState", SNDC_GLOBAL, SNVT_INT, eWinterExpressObjectiveState.INACTIVE )
	RegisterNetworkedVariable( "WinterExpress_ObjectiveOwner", SNDC_GLOBAL, SNVT_INT, -1 )
	RegisterNetworkedVariable( "WinterExpress_UnlockDelayEndTime", SNDC_GLOBAL, SNVT_TIME, -1 )
	RegisterNetworkedVariable( "WinterExpress_CaptureEndTime", SNDC_GLOBAL, SNVT_TIME, -1 )
	RegisterNetworkedVariable( "WinterExpress_CaptureEndTimeCopy", SNDC_GLOBAL, SNVT_TIME, -1 )
	RegisterNetworkedVariable( "WinterExpress_TrainArrivalTime", SNDC_GLOBAL, SNVT_TIME, -1 )
	RegisterNetworkedVariable( "WinterExpress_TrainTravelTime", SNDC_GLOBAL, SNVT_TIME, -1 )
	RegisterNetworkedVariable( "WinterExpress_WaveRespawnTime", SNDC_GLOBAL, SNVT_TIME, -1 )
	RegisterNetworkedVariable( "WinterExpress_RoundRespawnTime", SNDC_GLOBAL, SNVT_TIME, -1 )
	RegisterNetworkedVariable( "WinterExpress_IsOvertime", SNDC_GLOBAL, SNVT_BOOL, false )
	RegisterNetworkedVariable( "WinterExpress_RoundCounter", SNDC_GLOBAL, SNVT_INT, 0 )
	RegisterNetworkedVariable( "WinterExpress_NarrowWin", SNDC_GLOBAL, SNVT_BOOL, false )
	RegisterNetworkedVariable( "WinterExpress_HasGracePeriodPermit", SNDC_PLAYER_GLOBAL, SNVT_BOOL, false )
	RegisterNetworkedVariable( "WinterExpress_IsPlayerAllowedLegendChange", SNDC_PLAYER_EXCLUSIVE, SNVT_BOOL, false )

	#if CLIENT
		RegisterNetworkedVariableChangeCallback_int( "WinterExpress_RoundState", OnServerVarChanged_RoundState )
		RegisterNetworkedVariableChangeCallback_int( "WinterExpress_ObjectiveState", OnServerVarChanged_ObjectiveState )
		RegisterNetworkedVariableChangeCallback_int( "WinterExpress_ObjectiveOwner", OnServerVarChanged_ObjectiveOwner )
		RegisterNetworkedVariableChangeCallback_int( "connectedPlayerCount", OnServerVarChanged_ConnectedPlayers )
		RegisterNetworkedVariableChangeCallback_time( "WinterExpress_CaptureEndTimeCopy", OnServerVarChanged_CaptureEndTime )
		RegisterNetworkedVariableChangeCallback_time( "WinterExpress_TrainArrivalTime", OnServerVarChanged_TrainArrival )
		RegisterNetworkedVariableChangeCallback_time( "WinterExpress_TrainTravelTime", OnServerVarChanged_TrainTravelTime )
		RegisterNetworkedVariableChangeCallback_bool( "WinterExpress_IsOvertime", OnServerVarChanged_OvertimeChanged )
	#endif
}

bool function WinterExpress_IsNarrowWin()
{
	return GetGlobalNetBool( "WinterExpress_NarrowWin" )
}

#if SERVER
void function OnEntitiesDidLoad()
{
	array<entity> trainBrushes = GetEntArrayByScriptName( "train_brush" )
	foreach ( brush in trainBrushes )
	{
		AddCallback_LootPhysicsParented( brush, OnParentedToTrain )
	}

	file.trainRef = GetEntByScriptName( TRAIN_MOVER_NAME + "_0" )
	printf( "Train Ref is " + file.trainRef )

	foreach ( trigger in GetEntArrayByScriptName( "train_objective_holiday" ) )
	{
		file.trainTriggers.append( trigger )
		trigger.SetEnterCallback( OnEntityEnterObjectiveTrigger )
		trigger.SetLeaveCallback( OnEntityLeaveObjectiveTrigger )
		trigger.kv.triggerFilterTeamOther = 1
		trigger.Disable()
	}

	//	SetPlayerEliminationCheck( WinterExpress_ShouldPlayerBeEliminated ) // need to be here or survival init will stump it.

	DesertlandsTrain_SetMaxSpeed( WINTER_EXPRESS_TRAIN_MAX_SPEED )
	DesertlandsTrain_SetAcceleration( WINTER_EXPRESS_TRAIN_ACCELERATION )
	DesertlandsTrain_SetWaitDuration( GetCurrentPlaylistVarFloat( "winter_express_round_time", 180 ) + GetCurrentPlaylistVarFloat( "winter_express_cap_unlock_delay", 7 ) )
	DesertlandsTrain_SetAboutToLeaveBuffer( 0 )
	DesertlandsTrain_SetAdditionalLeaveBuffer( WINTER_EXPRESS_LEAVE_BUFFER )

	vector spawnPos     = SURVIVAL_GetDeathFieldCenter()
	float skydiveHeight = GetCurrentPlaylistVarFloat( "winter_express_respawn_skydive_height", 11000.0 )
	spawnPos += <0, 0, skydiveHeight>

	entity spawnEntity = CreatePropDynamicLightweight( RESPAWN_BEACON_MOBILE_MODEL, spawnPos )
	file.skydiveSpawn = spawnEntity
	file.skydiveSpawn.SetOrigin( file.skydiveSpawn.GetOrigin() + < 0, 0, -10000 > )

	file.jumptowerIndex = GetEntArrayByScriptName( "jump_tower" )

	DesertlandsTrain_SetTrainDialogueAliasEnabled( "Train_DepartNow", false )

	SpawnHoverTanks()
}

void function OnLeaveMatch( entity player )
{
	if ( !IsValid( player ) )
		return

	Remote_CallFunction_NonReplay( player, "ServerCallback_CL_DeregisterModeButtonPressedCallbacks" )

	if ( GetCurrentPlaylistVarBool( "winter_express_leave_match_fix", true ) )
		Remote_CallFunction_NonReplay( player, "ServerCallback_CL_WinnerDetermined", TEAM_INVALID )
}

#endif

#if CLIENT
void function Client_OnTeamChanged( entity player, int oldTeam, int newTeam )
{
	//SetCustomPlayerInfo( player )
	foreach ( entity p in GetPlayerArray() )
	{
		if ( !IsValid( p ) )
			continue

		// Squads_SetCustomPlayerInfo( p )
	}
}
#endif

#if CLIENT
void function OnEntitiesDidLoad_Client()
{
	// //Local players team
	// int uiTeam = TEAM_IMC
	// file.scoreElements[uiTeam] <- RuiCreateNested( ClGameState_GetRui(), "squadScore", $"ui/winter_express_squad_score_element.rpak" )
	// file.scoreElementsFullmap[uiTeam] <- RuiCreateNested( GetFullmapGamestateRui(), "squadScore", $"ui/winter_express_squad_score_element.rpak" )
	// file.squadOnObjectiveElements[uiTeam] <- RuiCreateNested( ClGameState_GetRui(), "squadOnObjective", $"ui/winter_express_squad_on_objective.rpak" )
	// RuiSetBool( file.squadOnObjectiveElements[uiTeam], "isMySquad", true )
	// RuiSetBool( file.squadOnObjectiveElements[uiTeam], "teamValid", true )

	// int mySquadIndex      = Squads_GetArrayIndexForTeam( uiTeam )
	// asset squadIcon  = Squads_GetSquadIcon( mySquadIndex )

	// RuiSetAsset( file.squadOnObjectiveElements[uiTeam], "squadImage",  squadIcon)
	// RuiSetAsset( file.scoreElements[uiTeam], "squadImage", squadIcon )
	// RuiSetColorAlpha( file.scoreElements[uiTeam], "teamColor", Squads_GetSquadColor( mySquadIndex ) , 1.0 )

	// RuiSetAsset( file.scoreElementsFullmap[uiTeam], "squadImage", squadIcon )
	// RuiSetColorAlpha( file.scoreElementsFullmap[uiTeam], "teamColor", Squads_GetSquadColor( mySquadIndex ) , 1.0 )


	// //enemy teams
	// foreach ( int i, int team in GetAllEnemyTeams( uiTeam ) )
	// {
		// int squadIndex = Squads_GetArrayIndexForTeam( team )

		// file.scoreElements[team] <- RuiCreateNested( ClGameState_GetRui(), "enemyScore" + i, $"ui/winter_express_enemy_score_element.rpak" )
		// file.scoreElementsFullmap[team] <- RuiCreateNested( GetFullmapGamestateRui(), "enemyScore" + i, $"ui/winter_express_enemy_score_element.rpak" )
		// RuiSetInt( file.scoreElements[team], "teamOrderIndex", i )
		// RuiSetInt( file.scoreElementsFullmap[team], "teamOrderIndex", i )

		// file.squadOnObjectiveElements[team] <- RuiCreateNested( ClGameState_GetRui(), "enemyOnObjective" + i, $"ui/winter_express_squad_on_objective.rpak" )
		// RuiSetInt( file.squadOnObjectiveElements[team], "teamOrderIndex", i )

		// if ( GetPlayerArrayOfTeam( team ).len() == 0 )
		// {
			// RuiSetBool( file.scoreElements[team], "teamValid", false )
			// RuiSetBool( file.scoreElementsFullmap[team], "teamValid", false )
			// RuiSetBool( file.squadOnObjectiveElements[team], "teamValid", false )
		// }
		// else
		// {
			// RuiSetBool( file.scoreElements[team], "teamValid", true )
			// RuiSetBool( file.scoreElementsFullmap[team], "teamValid", true )
			// RuiSetBool( file.squadOnObjectiveElements[team], "teamValid", true )
		// }

		// squadIcon = Squads_GetSquadIcon(squadIndex)
		// RuiSetAsset( file.squadOnObjectiveElements[team], "squadImage",  squadIcon)
		// RuiSetAsset( file.scoreElements[team], "squadImage", squadIcon )
		// RuiSetColorAlpha( file.scoreElements[team], "teamColor", Squads_GetSquadColor( squadIndex ), 1.0 )

		// RuiSetAsset( file.scoreElementsFullmap[team], "squadImage", squadIcon )
		// RuiSetColorAlpha( file.scoreElementsFullmap[team], "teamColor", Squads_GetSquadColor( squadIndex ), 1.0 )
	// }

	SurvivalCommentary_SetHost( eSurvivalHostType.MIRAGE )
}

void function FinishGamestateRui()
{
	// RuiSetFloat( ClGameState_GetRui(), "overtimeTimeLimit", GetCurrentPlaylistVarFloat( "winter_express_overtime_limit", 15 ) )
	// RuiSetFloat( ClGameState_GetRui(), "captureTimeRequired", GetCurrentPlaylistVarFloat( "winter_express_cap_time", 10 ) )
	// RuiSetFloat( ClGameState_GetRui(), "trainTravelTime", 10.0 )

	// RuiTrackInt( ClGameState_GetRui(), "roundState", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL_INT, GetNetworkedVariableIndex( "WinterExpress_RoundState" ) )
	// RuiTrackInt( ClGameState_GetRui(), "roundCounter", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL_INT, GetNetworkedVariableIndex( "WinterExpress_RoundCounter" ) )
	// RuiTrackFloat( ClGameState_GetRui(), "unlockEndTime", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL, GetNetworkedVariableIndex( "WinterExpress_UnlockDelayEndTime" ) )
	// RuiSetInt( ClGameState_GetRui(), "roundLimit", file.roundLimit )
}

void function OnServerVarChanged_ConnectedPlayers( entity player, int old, int new, bool actuallyChanged )
{
	// foreach ( team in GetAllTeams() )
	// {
		// int uiTeam = Squads_GetTeamsUIId( team )
		// if ( !(uiTeam in file.scoreElements) )
			// continue

		// if ( GetPlayerArrayOfTeam( team ).len() == 0 )
		// {
			// RuiSetBool( file.scoreElements[uiTeam], "teamValid", false )
			// RuiSetBool( file.scoreElementsFullmap[uiTeam], "teamValid", false )
			// RuiSetBool( file.squadOnObjectiveElements[uiTeam], "teamValid", false )
		// }
		// else
		// {
			// RuiSetBool( file.scoreElements[uiTeam], "teamValid", true )
			// RuiSetBool( file.scoreElementsFullmap[uiTeam], "teamValid", true )
			// RuiSetBool( file.squadOnObjectiveElements[uiTeam], "teamValid", true )
		// }
	// }

	// foreach ( entity p in GetPlayerArray() )
	// {
		// if ( !IsValid( p ) )
			// continue

		// // Squads_SetCustomPlayerInfo( p )
	// }

	// entity localPlayer = GetLocalViewPlayer()
	// if ( !IsValid( localPlayer ))
		// return

	// int myTeam = localPlayer.GetTeam()
	// if ( myTeam == TEAM_SPECTATOR )
		// return

	// if ( ClGameState_GetRui() != null )
	// {
		// int squadIndex = Squads_GetSquadUIIndex( myTeam )
		// RuiSetInt( ClGameState_GetRui(), "squadSize", GetPlayerArrayOfTeam( myTeam ).len())
		// RuiSetImage( ClGameState_GetRui(), "squadIcon",  Squads_GetSquadIcon(squadIndex))
		// RuiSetColorAlpha( ClGameState_GetRui(), "squadColor", Squads_GetSquadColor( squadIndex ) , 1.0 )
		// RuiSetString( ClGameState_GetRui(), "squadString", Squads_GetSquadName(squadIndex) )
	// }
}

string function WinterExpress_DeathScreenHeaderOverride()
{
	if ( GetGameState() != eGameState.Playing )
		return ""

	entity player            = GetLocalClientPlayer()
	float arrivalTime        = GetGlobalNetTime( "WinterExpress_TrainArrivalTime" )

	if ( Time() < arrivalTime && player.GetPlayerNetBool( "WinterExpress_HasGracePeriodPermit" ) )
		return "#WINTER_EXPRESS_DIED_IN_GRACE_PERIOD"

	return "#WINTER_EXPRESS_WAITING_TO_RESPAWN"
}

void function WinterExpress_OnResolution()
{
	// if ( GetNetWinningTeam() != TEAM_UNASSIGNED )
		// return

	// if a draw open the death screen and show the match summary

	Assert( !IsSquadDataPersistenceEmpty( GetLocalClientPlayer() ), "Persistence didn't get transmitted to the client in time!" )
	SetSquadDataToLocalTeam()    // since the winning team never gets eliminated the data isn't set from before.

	ShowDeathScreen( eDeathScreenPanel.SQUAD_SUMMARY )
	EnableDeathScreenTab( eDeathScreenPanel.SPECTATE, false )
	EnableDeathScreenTab( eDeathScreenPanel.DEATH_RECAP, !IsAlive( GetLocalClientPlayer() ) )
	SwitchDeathScreenTab( eDeathScreenPanel.SQUAD_SUMMARY )
}
#endif

#if CLIENT
void function Client_OnWinnerDetermined( )
{
	// int winningTeam = GetWinningTeam()
	// if ( winningTeam != TEAM_UNASSIGNED)
	// {
		// int squadIndex = Squads_GetSquadUIIndex( GetWinningTeam() )
		// SetVictoryScreenTeamName( Localize( Squads_GetSquadNameLong( squadIndex ) ) )
	// }
}
#endif

//////////////////////////////////////////////////
// Functions for Controlling Objective Triggers //
//////////////////////////////////////////////////
#if SERVER
void function OnClientConnected( entity player )
{
	Survival_OnClientConnected( player )

	table< entity, bool> triggerMatrix
	foreach ( trigger in file.trainTriggers )
	{
		triggerMatrix[trigger] <- false
	}
	file.isPlayerInTrainCar[player] <- triggerMatrix
	printt( "WINTER EXPRESS ON CLIENT CONNECTED", player )
}

void function OnClientDisconnected( entity player )
{
	if ( IsValid( player ) )
	{
		SpawnAmmoForCurrentWeapon( player )
		Remote_CallFunction_NonReplay( player, "ServerCallback_CL_DeregisterModeButtonPressedCallbacks" )
	}
}

void function OnParentedToTrain( entity ent, entity child )
{
	if ( file.lootOnTrain.len() > 50 )
	{
		for ( int i = 0; i < file.lootOnTrain.len(); i++ )
		{
			entity lootItem = file.lootOnTrain[i]
			if ( IsValid ( lootItem ) )
			{
				int lootIndex = lootItem.GetSurvivalInt()
				LootData data = SURVIVAL_Loot_GetLootDataByIndex( lootIndex )
				if ( data.lootType == eLootType.AMMO || data.lootType == eLootType.HEALTH || data.lootType == eLootType.ORDNANCE )
				{
					file.lootOnTrain.remove( i )
					lootItem.ClearParent()
					lootItem.Destroy()
					break
				}
			}
		}
	}

	file.lootOnTrain.append( child )
}
#endif





///////////////////////////////////////////////////////////////
// Functions for Controlling Objective ownership and scoring //
///////////////////////////////////////////////////////////////
#if SERVER

//ownership state machine
entity function WinterExpress_SpawnObjectiveFX( entity obj, int radius, int team )
{
	entity objFX = StartParticleEffectOnEntity_ReturnEntity( obj, GetParticleSystemIndex( $"P_ar_cylinder_radius_CP_1x1" ), FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
	EffectSetControlPointVector( objFX, 2, <255, 255, 255> )
	EffectSetControlPointVector( objFX, 1, <radius * 2, 0, 0> )
	SetTeam( objFX, team )
	objFX.kv.VisibilityFlags = ENTITY_VISIBLE_TO_FRIENDLY
	objFX.DisableHibernation()
	return objFX
}

void function SetupObjectiveAtStation()
{
	UpdateObjectiveStateForTeam( eWinterExpressObjectiveState.UNCONTROLLED, -1 )

	foreach ( trigger in file.trainTriggers )
		trigger.Enable()
}

void function SetupObjectiveAtStationForOvertime()
{
	int mostCentralIndex      = 0
	float mostCentralDistance = 1000000

	entity centerCar = GetEntByScriptName( TRAIN_MOVER_NAME + "_1" )

	for ( int i = 0; i < file.trainTriggers.len(); i++ )
	{
		float distanceCheck = Distance( file.trainTriggers[i].GetOrigin(), centerCar.GetOrigin() )
		if ( distanceCheck < mostCentralDistance )
		{
			mostCentralDistance = distanceCheck
			mostCentralIndex = i
		}
	}

	for ( int i = 0; i < file.trainTriggers.len(); i++ )
	{
		if ( i != mostCentralIndex )
			file.trainTriggers[i].Disable()
	}
}

void function DestroyObjectiveAtStation()
{
	foreach ( trigger in file.trainTriggers )
		trigger.Disable()

	file.objectiveOwners.clear()

	foreach ( player in GetConnectedPlayers() )
	{
		foreach ( team in GetAllValidPlayerTeams() )
			Remote_CallFunction_NonReplay( player, "ServerCallback_CL_SquadOnObjectiveStateChanged", team, false )
	}
}

void function OnEntityEnterObjectiveTrigger( entity trigger, entity ent )
{
	if ( !IsValidPlayer( ent ) || GetGameState() != eGameState.Playing)
		return

	printf( "WINTER EXPRESS: Player Entered Trigger" )
	file.isPlayerInTrainCar[ent][trigger] <- true

	bool alreadyOnTrain = false
	foreach ( objectiveTrigger in file.trainTriggers )
	{
		if ( objectiveTrigger == trigger )
			continue

		if ( file.isPlayerInTrainCar[ent][objectiveTrigger] )
		{
			alreadyOnTrain = true
			break
		}
	}

	if ( !alreadyOnTrain )
		OnEntityEnterTrain( ent )
}

void function OnEntityLeaveObjectiveTrigger( entity trigger, entity ent )
{
	if ( !IsValidPlayer( ent ) || GetGameState() != eGameState.Playing)
		return

	printf( "WINTER EXPRESS: Player Left Trigger" )
	file.isPlayerInTrainCar[ent][trigger] <- false

	bool stillOnTrain = false
	foreach ( objectiveTrigger in file.trainTriggers )
	{
		if ( objectiveTrigger == trigger )
			continue

		if ( file.isPlayerInTrainCar[ent][objectiveTrigger] )
		{
			stillOnTrain = true
			break
		}
	}

	if ( !stillOnTrain )
		OnEntityLeaveTrain( ent )
}

void function OnEntityEnterTrain( entity ent )
{
	printf( "WINTER EXPRESS: Player Entered Train" )

	int team = ent.GetTeam()
	//register objective owners
	if ( !file.objectiveOwners.contains( team ) )
	{
		file.objectiveOwners.append( team )
		foreach ( player in GetConnectedPlayers() )
			Remote_CallFunction_NonReplay( player, "ServerCallback_CL_SquadOnObjectiveStateChanged", team, true )
	}

	if ( file.objectiveOwners.len() == 1 )
	{
		thread ProcessControlledObjective( team )
	}
	else
	{
		thread ProcessContestedObjective()
	}
}

void function OnEntityLeaveTrain( entity ent )
{
	if ( GetGlobalNetInt( "WinterExpress_RoundState" ) == eWinterExpressRoundState.ABOUT_TO_CHANGE_STATIONS )
	{
		ProcessInactiveObjective()
		return
	}

	printt( "WINTER EXPRESS: Player Left Train" )

	int team              = ent.GetTeam()
	bool teamStillOnTrain = false
	foreach ( trigger in file.trainTriggers )
	{
		foreach ( thing in trigger.GetTouchingEntities() )
		{
			if ( IsValidPlayer( thing ) && thing.GetTeam() == team )
			{
				teamStillOnTrain = true
				break
			}
		}
	}

	if ( !teamStillOnTrain )
	{
		file.objectiveOwners.fastremovebyvalue( team )
		foreach ( player in GetConnectedPlayers() )
			Remote_CallFunction_NonReplay( player, "ServerCallback_CL_SquadOnObjectiveStateChanged", team, false )
	}

	if ( file.objectiveOwners.len() == 1 )
	{
		thread ProcessControlledObjective( file.objectiveOwners[0] )
	}
	else if ( file.objectiveOwners.len() != 0 )
	{
		thread ProcessContestedObjective()
	}
	else
	{
		ProcessUncontrolledObjective( -1 )
	}
}

void function UpdateObjectiveStateForTeam( int newState, int team )
{
	printt( "UpdateObjectiveStateForTeam - ", GetEnumString( "eWinterExpressObjectiveState", newState ), team )

	int currentState = GetGlobalNetInt( "WinterExpress_ObjectiveState" )
	if ( newState == eWinterExpressObjectiveState.INACTIVE )
		ResetObjectiveOwnership()
	if ( newState == eWinterExpressObjectiveState.UNCONTROLLED )
		ResetObjectiveOwnership()
	if ( newState == eWinterExpressObjectiveState.CONTROLLED && team != file.cachedObjectiveOwner )
		ResetObjectiveOwnership()

	if ( currentState == eWinterExpressObjectiveState.CONTROLLED && newState != eWinterExpressObjectiveState.CONTROLLED )
	{
		file.cachedObjectiveOwner = GetGlobalNetInt( "WinterExpress_ObjectiveOwner" )
		float capTime            = GetCurrentPlaylistVarFloat( "winter_express_cap_time", 10 )
		float timeLeftToCapture  = GetGlobalNetTime( "WinterExpress_CaptureEndTime" ) - Time()
		float percentageCaptured = (capTime - timeLeftToCapture) / capTime
		file.cachedObjectivePercent = percentageCaptured
	}

	if ( newState == eWinterExpressObjectiveState.CONTESTED )
		svGlobal.levelEnt.Signal( "WinterExpress_ObjectiveContested" )
	else if ( newState == eWinterExpressObjectiveState.CONTROLLED )
		svGlobal.levelEnt.Signal( "WinterExpress_ObjectiveControlled" )
	else if ( newState == eWinterExpressObjectiveState.UNCONTROLLED )
		svGlobal.levelEnt.Signal( "WinterExpress_ObjectiveUncontrolled" )
	else
		svGlobal.levelEnt.Signal( "WinterExpress_ObjectiveInactive" )

	SetGlobalNetInt( "WinterExpress_ObjectiveState", newState )
	SetGlobalNetInt( "WinterExpress_ObjectiveOwner", team )

	string matchPointAddendum = ""
	if ( team in file.isTeamOnMatchPoint && file.isTeamOnMatchPoint[team] )
		matchPointAddendum = "_MatchPoint"

	float seekTime = 0
	if ( currentState == eWinterExpressObjectiveState.CONTESTED && newState == eWinterExpressObjectiveState.CONTROLLED )
	{
		if ( team == file.cachedObjectiveOwner )
			seekTime = GetCurrentPlaylistVarFloat( "winter_express_cap_time", 10 ) * file.cachedObjectivePercent
	}

	seekTime = Clamp( seekTime, 0.0, 10.0 )


	foreach ( teamCheck in GetAllValidPlayerTeams() )
	{
		if ( newState == eWinterExpressObjectiveState.CONTROLLED )
		{
			if ( team == teamCheck )
			{
				if ( matchPointAddendum != "" )
					EmitSoundOnEntityToTeam( file.trainRef, "WXpress_Train_Capture_Status_MatchPoint_Start", teamCheck )
				foreach ( player in GetPlayerArrayOfTeam( teamCheck ) )
				{
					printf( "WINTER EXPRESS: playing friendly capture for " + player + " on team " + teamCheck + " with seek " + seekTime )
					EmitSoundOnEntityOnlyToPlayerWithSeek( file.trainRef, player, "WXpress_Train_Capture_Status" + matchPointAddendum, seekTime )
				}
			}
			else
			{
				if ( matchPointAddendum != "" )
					EmitSoundOnEntityToTeam( file.trainRef, "WXpress_Train_Capture_Status_MatchPoint_Start_Enemy", teamCheck )
				foreach ( player in GetPlayerArrayOfTeam( teamCheck ) )
				{
					printf( "WINTER EXPRESS: playing enemy capture for " + player + " on team " + teamCheck + " with seek " + seekTime )
					EmitSoundOnEntityOnlyToPlayerWithSeek( file.trainRef, player, "WXpress_Train_Capture_Status" + matchPointAddendum + "_Enemy", seekTime )
				}
			}
		}
		else
		{
			StopSoundOnEntity( file.trainRef, "WXpress_Train_Capture_Status" )
			StopSoundOnEntity( file.trainRef, "WXpress_Train_Capture_Status_Enemy" )
			StopSoundOnEntity( file.trainRef, "WXpress_Train_Capture_Status_MatchPoint" )
			StopSoundOnEntity( file.trainRef, "WXpress_Train_Capture_Status_MatchPoint_Enemy" )
		}
	}

	if ( newState == eWinterExpressObjectiveState.CONTESTED && currentState == eWinterExpressObjectiveState.CONTROLLED )
	{
		foreach ( int teamOnTrain in file.objectiveOwners )
		{
			if ( !(teamOnTrain in file.teamLastHeardContestedLineTimestamps) || Time() - file.teamLastHeardContestedLineTimestamps[teamOnTrain] > CONTESTED_LINE_DEBOUNCE )
			{
				file.teamLastHeardContestedLineTimestamps[teamOnTrain] <- Time()
				foreach ( entity player in GetPlayerArrayOfTeam( teamOnTrain ) )
				{
					EmitSoundOnEntityOnlyToPlayer( player, player, "diag_ap_aiNotify_trainMultipleSquads_3p" )
				}
			}
		}
	}

	if ( newState == eWinterExpressObjectiveState.CONTROLLED )
	{
		foreach ( int teamOnTrain in file.objectiveOwners )
		{
			if ( !(teamOnTrain in file.teamLastHeardHoldingLineTimestamps) || Time() - file.teamLastHeardHoldingLineTimestamps[teamOnTrain] > HOLDING_LINE_DEBOUNCE )
			{
				file.teamLastHeardHoldingLineTimestamps[teamOnTrain] <- Time()
				foreach ( entity player in GetPlayerArrayOfTeam( teamOnTrain ) )
				{
					//EmitSoundOnEntityOnlyToPlayer( player, player, "diag_ap_aiNotify_trainYourSquadHolds_3p" )
				}
			}
		}
	}
}

void function ResetObjectiveOwnership()
{
	// DumpStack()
	file.cachedObjectiveOwner = -1
	SetGlobalNetInt( "WinterExpress_ObjectiveOwner", -1 )
}

//callbacks
void function OnWaitingForPlayers_Server()
{
	SurvivalCommentary_SetHost( eSurvivalHostType.MIRAGE )
}

void function OnGameStatePlaying()
{
	thread Thread_OnGameStatePlaying()
}

void function Thread_OnGameStatePlaying()
{
	if ( GetNumTeamsExisting() > 1 )
		file.lastValidTeamToScore = (RandomIntRange(0, GetNumTeamsExisting() - 1) + TEAM_IMC)

	DesertlandsTrain_InitMovement()
	SetupHolidayHoverTank_OnGameStartedPlaying()
	SetDefaultObserverBehavior( GetBestObserverTarget_WinterExpress )

	//setup train objective waypoints
	entity trainCenter = GetEntByScriptName( TRAIN_MOVER_NAME + "_1" )
	// entity wp          = CreateWaypoint_ObjectiveEntLocation( trainCenter, ePingType.TRAIN ) //TRAIN_OBJECTIVE //FIXME cafe
	// file.trainWaypoint = wp
	// wp.SetParent( trainCenter )
	// wp.SetLocalOrigin( <0, 0, 150> )

	if ( IsWaveRespawn() )
	{
		float respawnInterval = GetWaveRespawnInterval()
		thread WaveRespawnIntervalThread( respawnInterval )
	}

	entity nextStation = DesertlandsTrain_GetNextStationNode()
	// entity stationWP   = CreateWaypoint_BasicEntLocation( nextStation, ePingType.STATION )
	// stationWP.SetParent( nextStation )
	// stationWP.SetLocalOrigin( <0, 0, 200> )
	// file.nextStationWaypoint = stationWP

	SetCurrentSpectateCameraClosestToTrain()
	// SetCurrentSpectateCameraToNextIndex()

	foreach( entity player in GetPlayerArray() )
	{
		player.ClearParent()
		PutPlayerInObserverModeWithOriginAngles( player, OBS_MODE_STATIC_LOCKED, file.spectateCameraLocations[file.currentSpectateCamera], file.spectateCameraAngles[file.currentSpectateCamera] )
		player.SetPhysics( MOVETYPE_OBSERVER )

		// AddCinematicFlag( player, CE_FLAG_HIDE_MAIN_HUD_INSTANT )
		// AddCinematicFlag( player, CE_FLAG_HIDE_PERMANENT_HUD )

		Remote_CallFunction_NonReplay( player, "ServerCallback_CL_ObserverModeSetToTrain" )
		
		thread function () : ( player )
		{
			EndSignal( player, "OnDestroy" )
			
			wait 1

			Remote_CallFunction_NonReplay( player, "ServerCallback_CL_GameStartAnnouncement" )
			EmitSoundOnEntityOnlyToPlayer( player, player, "diag_ap_aiNotify_trainRulesHint_3p" )
		}()
	}

	//Cafe was here
	if( IsRoundBasedRespawn() )
	{
		thread function () : () 
		{
			wait 20
			
			if( GetGameState() != eGameState.Playing )
				return

			RespawnAllDeadPlayers()
		}()
	}
	//transmit first train transmit time to clients
	array<entity> pathNodes = DesertlandsTrain_GetCurrentPathNodes()
	array<vector> path      = ConvertPathNodesToPath( pathNodes )
	entity train            = DesertlandsTrain_GetTrain()
	vector trainOrigin      = DesertlandsTrain_GetTrainOrigin()

	float currentDist = GetDistanceAlongPath( path, trainOrigin )
	float maxDist     = GetPathLength( path )
	float roughTravelTime           = maxDist / WINTER_EXPRESS_TRAIN_MAX_SPEED

	SetGlobalNetTime( "WinterExpress_TrainArrivalTime", Time() + roughTravelTime )
	SetGlobalNetTime( "WinterExpress_TrainTravelTime", roughTravelTime )
}

void function OnWinnerDetermined()
{
	foreach ( player in GetPlayerArray() )
	{
		if ( IsValid( player ) )
			Remote_CallFunction_NonReplay( player, "ServerCallback_CL_DeregisterModeButtonPressedCallbacks" )
	}

	if ( !IsValid(file.trainRef) )
		return

	StopSoundOnEntity( file.trainRef, "WXpress_Train_Capture_Status" )
	StopSoundOnEntity( file.trainRef, "WXpress_Train_Capture_Status_Enemy" )
}

void function OnPlayerKilled_GameState( entity victim, entity attacker, var attackerDamageInfo )
{
	if ( GetGlobalNetInt( "WinterExpress_RoundState" ) == eWinterExpressRoundState.OBJECTIVE_ACTIVE && GetGameState() == eGameState.Playing )
		thread ProcessLastSquadAlive( victim, attacker )

	if ( !IsValid( victim ) )
		return

	if ( IsTeamEliminated( victim.GetTeam() ) )
	{
		foreach ( player in GetConnectedPlayers() )
		{
			Remote_CallFunction_NonReplay( player, "ServerCallback_CL_SquadEliminationStateChanged", victim.GetTeam(), true )
		}

	}



	file.deadPlayers.append( victim )

	// Make sure loadout info is updated before it is displayed
	// if ( IsUsingLoadoutSelectionSystem() )
		// LoadoutSelection_UpdateLoadoutInfoForMenus( victim )
}

void function WinterExpress_StartObserving(entity player)
{
	if ( IsTeamEliminated( player.GetTeam() ) )
	{
		foreach (member in GetPlayerArrayOfTeam(player.GetTeam()))
		{
			player.SetPlayerNetInt( "spectatorTargetCount", 1 )
			thread TryPutPlayerInTrainObserverMode( member )
		}
	}
	else
	{
		entity observeTarget = GetBestObserverTarget_WinterExpress(player, false)
		if ( observeTarget != null )
		{
			array<entity> observeablePlayers = GetPlayerArrayOfTeam_Alive( player.GetTeam() )
			player.SetPlayerNetInt( "spectatorTargetCount", observeablePlayers.len() )

			player.SetObserverTarget( observeTarget )
			PutPlayerInObserverMode( player, OBS_MODE_IN_EYE )
		}
	}
}

void function TryPutPlayerInTrainObserverMode( entity victim )
{
	WaitFrame()

	if ( !IsValid( victim ) || !IsTeamEliminated(victim.GetTeam()) )
		return

	foreach( player in GetPlayerArrayOfTeam( victim.GetTeam() ))
	{
		if ( !IsValid( player ) )
			return

		player.ClearParent()
		PutPlayerInObserverModeWithOriginAngles( player, OBS_MODE_STATIC_LOCKED, file.spectateCameraLocations[file.currentSpectateCamera], file.spectateCameraAngles[file.currentSpectateCamera] )
		player.SetPhysics( MOVETYPE_OBSERVER )

		// AddCinematicFlag( player, CE_FLAG_HIDE_MAIN_HUD_INSTANT )
		// AddCinematicFlag( player, CE_FLAG_HIDE_PERMANENT_HUD )

		Remote_CallFunction_NonReplay( player, "ServerCallback_CL_ObserverModeSetToTrain" )
	}
}


void function TrainAboutToArriveAtStation()
{
	bool shouldPlayLine
	foreach( team, value in file.isTeamOnMatchPoint )
	{
		if ( team == TEAM_INVALID )
			continue

		if ( value )
		{
			if ( team in file.hasTeamGottenMatchPointAnnounce && file.hasTeamGottenMatchPointAnnounce[team] )
				continue

			shouldPlayLine = true
			file.hasTeamGottenMatchPointAnnounce[team] <- true
		}

	}

	if ( shouldPlayLine )
		thread PlayCommentaryLineToAllPlayers( PickCommentaryLineFromBucket_WinterExpressCustom ( eSurvivalCommentaryBucket.WINNER_CLOSE_POINTS ) )
}


void function TrainArrivedAtStation()
{
	thread TrainArrivedAtStation_Internal()
}

void function TrainArrivedAtStation_Internal()
{
	SetCurrentSpectateCameraClosestToTrain()

	if ( file.nextStationWaypoint != null )
		file.nextStationWaypoint.Destroy()
	file.nextStationWaypoint = null

	bool shouldPlayLine
	foreach( team, value in file.isTeamOnMatchPoint )
	{
		if ( team == TEAM_INVALID )
			continue

		if ( value )
		{
			if ( team in file.hasTeamGottenMatchPointAnnounce && file.hasTeamGottenMatchPointAnnounce[team] )
				continue

			shouldPlayLine = true
			file.hasTeamGottenMatchPointAnnounce[team] <- true
		}

	}

	if ( shouldPlayLine )
		thread PlayCommentaryLineToAllPlayers( PickCommentaryLineFromBucket_WinterExpressCustom ( eSurvivalCommentaryBucket.WINNER_CLOSE_POINTS ) )
	else
		thread PlayCommentaryLineWithMirageResponseIfOnSquad( PickCommentaryLineFromBucket_WinterExpressCustom( eSurvivalCommentaryBucket.TRAIN_STOP ) )

	float unlockDelay = GetCurrentPlaylistVarFloat( "winter_express_cap_unlock_delay", 7 )
	if(!file.hasReachedFirstStation)
	{
		file.hasReachedFirstStation = true
		unlockDelay += WINTER_EXPRESS_FIRST_STATION_UNLOCK_DELAY
	}

	SetGlobalNetTime( "WinterExpress_UnlockDelayEndTime", Time() + unlockDelay )
	SetGlobalNetInt( "WinterExpress_RoundState", eWinterExpressRoundState.ABOUT_TO_UNLOCK_STATION )
	wait unlockDelay

	SetupObjectiveAtStation()
	DesertlandsTrain_ClearAllowLeaveStation()

	if ( GetGlobalNetInt( "squadsRemainingCount" ) == 0 )
	{
		printf( "WINTER EXPRESS: Trying to end round with no squads alive" )
		thread TryDetermineRoundWinner( -1, eWinterExpressRoundEndCondition.NO_SQUADS_ALIVE )
		return
	}
	else if ( GetGlobalNetInt( "squadsRemainingCount" ) == 1 )
	{
		printf( "WINTER EXPRESS: Trying to check if alive player is last squad alive" )
		thread ProcessLastSquadAlive( null, GetPlayerArray_Alive()[0] )
		return
	}

	float roundEndTime = Time() + GetCurrentPlaylistVarFloat( "winter_express_round_time", 180 )
	SetGlobalNetTime( "WinterExpress_RoundEnd", roundEndTime )
	SetGlobalNetBool( "WinterExpress_IsOvertime", false )

	SetGlobalNetInt( "WinterExpress_RoundState", eWinterExpressRoundState.OBJECTIVE_ACTIVE )
	FlagSet( "WinterExpress_ObjectiveActive" )

	if ( !IsWaveRespawn() && !IsRoundBasedRespawn() && GetGameState() == eGameState.Playing )
		RespawnAllDeadPlayers()

	thread ProcessRound()
}

void function TrainAboutToLeaveStation()
{
	SetGlobalNetInt( "WinterExpress_RoundState", eWinterExpressRoundState.ABOUT_TO_CHANGE_STATIONS )
	FlagClear( "WinterExpress_ObjectiveActive" )
	DestroyObjectiveAtStation()

	if ( GetGameState() != eGameState.Playing )
		return

	foreach( tank in file.hoverTanks )
		HolidayHoverTank_FlyToNextStation( tank )

	if ( IsWaveRespawn() )
	{
		if ( file.lastTeamToScore == TEAM_INVALID )
		{
			float respawnInterval = DesertlandsTrain_GetAboutToLeaveBuffer() + DesertlandsTrain_GetAdditionalLeaveBuffer()
			thread WaveRespawnIntervalThread( respawnInterval )
		}

		RespawnTeamAfterDelay( file.lastTeamToScore, 2.0 )
	}

	//respawn winning team with everyone else
	/*if ( IsRoundBasedRespawn() )
	{
		RespawnTeam( file.lastTeamToScore )
	}*/
}

void function TrainLeavingStation()
{
	SetGlobalNetInt( "WinterExpress_RoundState", eWinterExpressRoundState.CHANGING_STATIONS )

	if ( GetGameState() == eGameState.Playing )
	{
		if ( IsWaveRespawn() )
		{
			if ( file.lastTeamToScore == TEAM_INVALID )
			{
				float respawnInterval = GetWaveRespawnInterval()
				thread WaveRespawnIntervalThread( respawnInterval )
			}
		}

		if ( IsRoundBasedRespawn() )
		{
			thread RespawnPlayerWhenTrainNearsDestination()
		}
		else
		{
			RespawnAllDeadPlayers()
		}

		thread PlayCommentaryLineWithMirageResponseIfOnSquad( PickCommentaryLineFromBucket_WinterExpressCustom( eSurvivalCommentaryBucket.TRAIN_MOVING ) )
	}

	if ( GetGameState() == eGameState.Playing )
	{
		entity nextStation = DesertlandsTrain_GetNextStationNode()
		// entity stationWP   = CreateWaypoint_BasicEntLocation( nextStation, ePingType.STATION )
		// stationWP.SetParent( nextStation )
		// stationWP.SetLocalOrigin( <0, 0, 200> )
		// file.nextStationWaypoint = stationWP
	}

	SetCurrentSpectateCameraToNextIndex()
}


//objective scoring processing
void function ProcessInactiveObjective()
{
	printf( "WINTER EXPRESS: Objective inactive" )

	file.objectiveOwners.clear()

	svGlobal.levelEnt.Signal( "WinterExpress_ObjectiveCaptureCancelled" )
	UpdateObjectiveStateForTeam( eWinterExpressObjectiveState.INACTIVE, -1 )

	foreach ( player in GetConnectedPlayers() )
		Remote_CallFunction_NonReplay( player, "ServerCallback_CL_ObjectiveStateChanged", eWinterExpressObjectiveState.INACTIVE, player.GetTeam() )
}

void function ProcessUncontrolledObjective( int team )
{
	printf( "WINTER EXPRESS: Objective uncontrolled" )

	UpdateObjectiveStateForTeam( eWinterExpressObjectiveState.UNCONTROLLED, -1 )
	svGlobal.levelEnt.Signal( "WinterExpress_ObjectiveCaptureCancelled" )
}

void function ProcessContestedObjective()
{
	FlagWait( "WinterExpress_ObjectiveActive" )
	printf( "WINTER EXPRESS: Objective contested" )

	svGlobal.levelEnt.Signal( "WinterExpress_ObjectiveCaptureCancelled" )
	UpdateObjectiveStateForTeam( eWinterExpressObjectiveState.CONTESTED, -1 )
}

void function ProcessControlledObjective( int team )
{
	if ( !IsValid( svGlobal.levelEnt ) )
		return

	float capPercentage = 0
	if ( team == file.cachedObjectiveOwner )
		capPercentage = file.cachedObjectivePercent
	float waitTime = GetCurrentPlaylistVarFloat( "winter_express_cap_time", 10 ) * (1 - capPercentage)

	printf( "WINTER EXPRESS: Cap wait time: " + waitTime + " with cached cap percentage " + capPercentage + " and cached objective owner " + file.cachedObjectiveOwner )

	UpdateObjectiveStateForTeam( eWinterExpressObjectiveState.CONTROLLED, team )
	foreach ( player in GetPlayerArrayOfTeam( team ) )
		Remote_CallFunction_NonReplay( player, "ServerCallback_CL_ObjectiveStateChanged", eWinterExpressObjectiveState.CONTROLLED, team )

	svGlobal.levelEnt.EndSignal( "WinterExpress_ObjectiveCaptureCancelled" )
	svGlobal.levelEnt.EndSignal( "WinterExpress_RoundOver" )

	FlagWait( "WinterExpress_ObjectiveActive" )
	printf( "WINTER EXPRESS: Objective capture started" )

	OnThreadEnd(
		function() : ()
		{
			printf( "WINTER EXPRESS: Objective Capture End Condition Cancelled" )
			SetGlobalNetTime( "WinterExpress_CaptureEndTimeCopy", -1 )
		}
	)

	SetGlobalNetTime( "WinterExpress_CaptureEndTime", Time() + waitTime )
	SetGlobalNetTime( "WinterExpress_CaptureEndTimeCopy", Time() + waitTime )
	wait waitTime

	thread TryDetermineRoundWinner( team, eWinterExpressRoundEndCondition.OBJECTIVE_CAPTURED )
}

void function ProcessRound()
{
	svGlobal.levelEnt.EndSignal( "WinterExpress_RoundOver" )


	OnThreadEnd(
		function() : ()
		{
			printf( "WINTER EXPRESS: Round Over End Condition Cancelled" )
		}
	)

	wait GetCurrentPlaylistVarFloat( "winter_express_round_time", 180 )

	if ( GetGlobalNetInt( "WinterExpress_ObjectiveState" ) != eWinterExpressObjectiveState.UNCONTROLLED )
	{
		thread ProcessOvertime()
		return
	}

	thread TryDetermineRoundWinner( TEAM_INVALID, eWinterExpressRoundEndCondition.TIMER_EXPIRED )
}

void function ProcessOvertime()
{
	svGlobal.levelEnt.EndSignal( "WinterExpress_RoundOver" )

	OnThreadEnd(
		function() : ()
		{
			printf( "WINTER EXPRESS: Overtime End Condition Cancelled" )
		}
	)

	SetupObjectiveAtStationForOvertime()
	SetGlobalNetBool( "WinterExpress_IsOvertime", true )

	thread PlayCommentaryLineToAllPlayers( PickCommentaryLineFromBucket_WinterExpressCustom( eSurvivalCommentaryBucket.TIME_ALMOST_EXPIRED ) )

	wait GetCurrentPlaylistVarFloat( "winter_express_overtime_limit", 15 )

	thread TryDetermineRoundWinner( TEAM_INVALID, eWinterExpressRoundEndCondition.OVERTIME_EXPIRED )
}

void function ProcessLastSquadAlive( entity victim, entity attacker )
{
	svGlobal.levelEnt.EndSignal( "WinterExpress_RoundOver" )

	int victimTeam   = -1
	int attackerTeam = -1

	if ( IsValidPlayer( victim ) )
		victimTeam = victim.GetTeam()
	if ( IsValidPlayer( attacker ) )
		attackerTeam = attacker.GetTeam()

	bool isLastSquadAlive = true
	int squadIndexCheck = -1

	if ( GetPlayerArray_Alive().len() > 0)
		squadIndexCheck = GetPlayerArray_Alive()[0].GetTeam()

	foreach ( player in GetPlayerArray_Alive() )
	{
		if ( player.GetTeam() != squadIndexCheck )
		{
			isLastSquadAlive = false
			break
		}
	}

	int lastSquadAliveIndex = TEAM_INVALID
	if ( isLastSquadAlive )
	{
		if ( GetPlayerArray_Alive().len() > 0)
			lastSquadAliveIndex = GetPlayerArray_Alive()[0].GetTeam()

		thread TryDetermineRoundWinner( lastSquadAliveIndex, eWinterExpressRoundEndCondition.LAST_SQUAD_ALIVE )
	}
}


//win checking for round/match
void function TryDetermineRoundWinner( int team, int endCondition )
{
	#if DEVELOPER
	// DumpStack()
	#endif

	if ( GetGlobalNetInt( "WinterExpress_RoundState" ) != eWinterExpressRoundState.OBJECTIVE_ACTIVE &&
	!(endCondition == eWinterExpressRoundEndCondition.NO_SQUADS_ALIVE || endCondition == eWinterExpressRoundEndCondition.LAST_SQUAD_ALIVE) )
		return

	if ( !GamePlayingOrSuddenDeath() )
		return

	printf( "WINTER EXPRESS: Round ended because of condition " + endCondition )

	//team won the round
	printf( "WINTER EXPRESS: Awarding round to team " + team )
	if ( team in file.objectiveScore )
		file.objectiveScore[team]++
	else
		file.objectiveScore[team] <- 1

	//updating match point state
	if ( team in file.objectiveScore && file.objectiveScore[team] == file.scoreLimit - 1 )
		file.isTeamOnMatchPoint[team] <- true

	if ( team != TEAM_INVALID && (endCondition == eWinterExpressRoundEndCondition.OBJECTIVE_CAPTURED || endCondition == eWinterExpressRoundEndCondition.LAST_SQUAD_ALIVE  ) )
	{
		foreach ( player in GetPlayerArrayOfTeam( team ) )
		{
			// if ( IsValid( player ) )
				// StatsHook_OnPlayerCapturedWinterExpress( player )
		}
	}

	file.lastTeamToScore = team
	if ( file.lastTeamToScore != TEAM_INVALID )
	{
		file.lastValidTeamToScore = team

		foreach ( player in GetPlayerArrayOfTeam( file.lastTeamToScore ) )
		{
			if ( IsValid( player ) && !IsAlive( player ) )
				SetPlayerRespawnOnTeam( player )
		}
	}

	svGlobal.levelEnt.Signal( "WinterExpress_RoundOver" )

	switch ( endCondition )
	{
		case eWinterExpressRoundEndCondition.OBJECTIVE_CAPTURED:
			thread PlayCommentaryLineToAllPlayers( PickCommentaryLineFromBucket_WinterExpressCustom( eSurvivalCommentaryBucket.ENEMY_CAP_TRAIN ) )
			break

		case eWinterExpressRoundEndCondition.LAST_SQUAD_ALIVE:
			thread PlayCommentaryLineToAllPlayers( PickCommentaryLineFromBucket_WinterExpressCustom( eSurvivalCommentaryBucket.ROUND_WIN_BY_ELIM ) )
			break

		case eWinterExpressRoundEndCondition.TIMER_EXPIRED:
		case eWinterExpressRoundEndCondition.OVERTIME_EXPIRED:
			thread PlayCommentaryLineToAllPlayers( PickCommentaryLineFromBucket_WinterExpressCustom( eSurvivalCommentaryBucket.TIME_EXPIRED ) )
			break

		default:
			break
	}

	SetGlobalNetInt( "WinterExpress_RoundCounter", GetGlobalNetInt( "WinterExpress_RoundCounter" ) + 1 )
	bool didMatchEnd = TryDetermineMatchWinner()

	if ( !didMatchEnd )
	{
		foreach ( player in GetConnectedPlayers() )
			Remote_CallFunction_NonReplay( player, "ServerCallback_CL_RoundEnded", endCondition, team, file.objectiveScore[team] )
	}
}


bool function TryDetermineMatchWinner()
{
	//check if game end conditions have been reached
	int maxScoreValue      = 0
	int maxTeamScoreIndex  = -1
	bool scoreLimitReached = false
	bool roundLimitReached = false
	bool playNearWinLine   = false

	foreach ( team, score in file.objectiveScore )
	{
		if ( team == -1 )
			continue

		//check for score limit end condition
		if ( score >= file.scoreLimit && team != -1 )
		{
			scoreLimitReached = true
		}

		//track which teams have the maximum score
		if ( score > maxScoreValue )
		{
			// a higher max score has been found, reset max score tracking
			maxScoreValue = score
			maxTeamScoreIndex = team
		}
	}

	if ( GetGlobalNetInt( "WinterExpress_RoundCounter" ) >= file.roundLimit )
		roundLimitReached = true

	// check for game end conditions
	if ( scoreLimitReached )
	{
		// SetWinner( maxTeamScoreIndex, eWinReason.SCORE_LIMIT, "#GAMEMODE_SCORE_LIMIT_REACHED", "#GAMEMODE_SCORE_LIMIT_REACHED" )
		foreach ( player in GetConnectedPlayers() )
		{
			Remote_CallFunction_NonReplay( player, "ServerCallback_CL_WinnerDetermined", maxTeamScoreIndex )
			SetGameState( eGameState.WinnerDetermined )
			Remote_CallFunction_NonReplay( player, "ServerCallback_MatchEndAnnouncement", true, maxTeamScoreIndex )
		}

		array<entity> losingPlayers

		foreach ( entity player in GetPlayerArray() )
		{
			if ( !IsValid( player ) )
				continue

			if ( player.GetTeam() != maxTeamScoreIndex )
				losingPlayers.append( player )
		}

		thread PlayCommentaryLineToPlayerArray( PickCommentaryLineFromBucket_WinterExpressCustom( eSurvivalCommentaryBucket.YOU_WINNER ), GetPlayerArrayOfTeam( maxTeamScoreIndex ) )
		thread PlayCommentaryLineToPlayerArray( PickCommentaryLineFromBucket_WinterExpressCustom( eSurvivalCommentaryBucket.WINNER ), losingPlayers )

		foreach ( team, score in file.objectiveScore )
		{
			if ( team == maxTeamScoreIndex )
				continue

			if ( score >= maxScoreValue - 1 )
				SetGlobalNetBool( "WinterExpress_NarrowWin", true )
		}

		return true
	}
	else if ( roundLimitReached )
	{
		//making sure invalid team wins in a game draw
		if ( TEAM_INVALID in file.objectiveScore )
			file.objectiveScore[TEAM_INVALID] = file.scoreLimit + 1
		else
			file.objectiveScore[TEAM_INVALID] <- file.scoreLimit + 1

		// SetWinner( TEAM_UNASSIGNED, eWinReason.DEFAULT, "#GAMEMODE_ROUND_LIMIT_REACHED", "#GAMEMODE_ROUND_LIMIT_REACHED" )
		foreach ( player in GetConnectedPlayers() )
		{
			Remote_CallFunction_NonReplay( player, "ServerCallback_CL_WinnerDetermined", TEAM_INVALID )
			SetGameState( eGameState.WinnerDetermined )
			Remote_CallFunction_NonReplay( player, "ServerCallback_MatchEndAnnouncement", true, TEAM_INVALID )
		}

		return true
	}
	else
	{
		DesertlandsTrain_SetAllowLeaveStation()
		DesertlandsTrain_ForceTrainLeaveStation()
		return false
	}

	unreachable
}

#endif //SERVER

#if SERVER
array< array<string> > function WinterExpress_OverrideAbilityCarePackage(entity player )
{
	array<string> left = ["armor_pickup_lv5_evolving"]
	array<string> right = ["armor_pickup_lv5_evolving"]
	array<string> center = ["armor_pickup_lv5_evolving"]

	return [ left, center, right ]
}
#endif //SERVER

////////////////////////////////////////
// Functions for handling Sonar items //
////////////////////////////////////////
#if SERVER
void function FlagSonarThread( entity flag )
{
	EndSignal( flag, "OnDestroy" )

	FireFlagSonarEffect( flag )
	float waypointUpdateInterval = GetCurrentPlaylistVarFloat( "winter_express_sonar_interval", 5.0 )
	while( true )
	{
		FireFlagSonarEffect( flag )
		wait waypointUpdateInterval
	}
}


void function FireFlagSonarEffect( entity flag )
{
	StartParticleEffectOnEntity( flag, GetParticleSystemIndex( $"P_chamber_celebration" ), FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
	EmitSoundOnEntity( flag, "sonargrenade_ping" )
}
#endif


#if SERVER
int function WinterExpress_GetCurrentRank( entity player )
{
	array<int> allTeams = GetTeamsForPlayers( GetPlayerArray_AliveConnected() )

	if ( GetGameState() < eGameState.WinnerDetermined )
		return GetCurrentPlaylistVarInt( "max_teams", 4 )

	if ( TEAM_INVALID in file.objectiveScore && file.objectiveScore[TEAM_INVALID] > file.scoreLimit )
		return GetCurrentPlaylistVarInt( "max_teams", 4 )

	int rank    = 1//GetNumTeamsExisting()	// start last
	int myTeam  = player.GetTeam()
	int myScore = (myTeam in file.objectiveScore) ? file.objectiveScore[ myTeam ] : 0

	foreach ( team in allTeams )
	{
		if ( (team in file.objectiveScore) && file.objectiveScore[ team ] > myScore )
			rank++
	}

	return rank
}
#endif


/////////////////////////////////////////////////////////////////////////
// Functions for handling skydiving, death, and controlling respawning //
/////////////////////////////////////////////////////////////////////////
#if SERVER
/*void function GameStartSkydive()
{
	Sur_SetPlaneEnt( file.skydiveSpawn )
	Sur_SetPlaneCenterEnt( file.skydiveSpawn )
	SetGlobalNetTime( "PlaneDoorsOpenTime", Time() + 8.0 )
	SetGlobalNetTime( "PlaneDoorsCloseTime", Time() + 8.0 )
	Survival_PutPlayersInPlane()

	SetUsingStaticJumpPoint( true )
	OpenAndClosePlaneDoor( file.skydiveSpawn, 8.0, 0.0 )
}*/

// Give loadouts to players that spawn on the hovertank or in the air, once they land. This avoids some weapon order issues and issues with grenades not equipping properly
void function OnPlayerMatchStateChanged( entity player, int newValue )
{
	if ( IsValid( player ) && newValue == ePlayerMatchState.NORMAL && player.GetPlayerNetBool( "WinterExpress_IsPlayerAllowedLegendChange" ) )
	{
		// Set the WinterExpress_IsPlayerAllowedLegendChange bool here to tell us that the player has landed from the hovertank and gotten their loadout so they should not be able to change it or get it again this life
		player.SetPlayerNetBool( "WinterExpress_IsPlayerAllowedLegendChange", false )
		// LoadoutSelection_GivePlayerInventoryAndLoadout( player, false, true, false )
	}
}
const array<string> STANDARD_INV_LOOT = [ "health_pickup_combo_small", "health_pickup_combo_large", "health_pickup_health_small", "health_pickup_health_large" ]

void function Flowstate_GivePlayerLoadoutOnGameStart_Copy( entity player, bool fromRespawning )
{
	if ( !IsValid( player ) )
		return
	
	SetPlayerInventory( player, [] )
	
	if( !fromRespawning )
	{
		TakeAllPassives( player )
		Flowstate_AssignUniqueCharacterForPlayer( player, true )
	} else
	{
		Survival_SetInventoryEnabled( player, true )
		GiveLoadoutRelatedWeapons( player )

		entity weapon = player.GetOffhandWeapon( OFFHAND_TACTICAL )
		if ( IsValid( weapon ) )
			weapon.SetWeaponPrimaryClipCount( weapon.GetWeaponPrimaryClipCountMax() )
	}

	player.TakeNormalWeaponByIndexNow( WEAPON_INVENTORY_SLOT_PRIMARY_2 )
	player.TakeOffhandWeapon( OFFHAND_MELEE )
	player.GiveWeapon( "mp_weapon_melee_survival", WEAPON_INVENTORY_SLOT_PRIMARY_2, [] )
	player.GiveOffhandWeapon( "melee_pilot_emptyhanded", OFFHAND_MELEE, [] )

	player.TakeOffhandWeapon( OFFHAND_SLOT_FOR_CONSUMABLES )
	player.GiveOffhandWeapon( CONSUMABLE_WEAPON_NAME, OFFHAND_SLOT_FOR_CONSUMABLES, [] )

	Inventory_SetPlayerEquipment( player, "incapshield_pickup_lv3", "incapshield")
	Inventory_SetPlayerEquipment(player, "armor_pickup_lv2", "armor")  
	Inventory_SetPlayerEquipment( player, "backpack_pickup_lv3", "backpack")

	ItemFlavor playerCharacter = LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_CharacterClass() )

	if( ItemFlavor_GetHumanReadableRef( playerCharacter ) != "character_gibraltar" )
	{
		player.TakeOffhandWeapon( OFFHAND_EQUIPMENT )
		player.GiveOffhandWeapon( "mp_ability_emote_projector", OFFHAND_EQUIPMENT )
	}

	foreach( item in STANDARD_INV_LOOT )
		SURVIVAL_AddToPlayerInventory(player, item, 2)

	PlayerRestoreHP_1v1(player, 100, player.GetShieldHealthMax().tofloat())

	if ( player.GetTeam() != TEAM_SPECTATOR )
	{
		player.SetNameVisibleToEnemy( true )
	}

	if ( GetCurrentPlaylistVarBool( "infinite_heal_items", false ) )
		GivePassive( player, ePassives.PAS_INFINITE_HEAL )
	
	if( IsValid( player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 ) ) )
		player.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_0)

	bool isPlayerOnHoverTankAtStart = file.playersOnHovertank.contains( player ) ? true : false

	if ( IsValid( player ) )
	{
		// Only assume the player state is normal if the player is still on the hovertank or never spawned on it.
		// Otherwise the player could be in a skydive state if they walked off the hovertank and we don't want to override that state
		if ( !isPlayerOnHoverTankAtStart || isPlayerOnHoverTankAtStart && file.playersOnHovertank.contains( player ) )
		{
			PlayerMatchState_Set( player, ePlayerMatchState.NORMAL )
		}
	}

	if ( IsValid( player ) && !file.playersThatHaveHeardRespawnLine.contains( player ) && fromRespawning )
	{
		file.playersThatHaveHeardRespawnLine.append( player )
		wait 2.0

		EmitSoundOnEntityOnlyToPlayer( player, player, "diag_ap_aiNotify_respawnFullGear_3p" )
	}

	//give weapons on landing only? Cafe
	if( GetCurrentPlaylistVarBool( "flowstate_weapon_selector_enabled", true ) && fromRespawning && file.playersOnHovertank.contains( player ) )
	{
		wait 4.0

		if ( !IsValid( player ) )
			return

		// Open Flowstate weapon selector
		// if ( isPlayerOnHoverTankAtStart )
			// wait 11.0

		if ( IsValid( player ) )
		{
			Remote_CallFunction_NonReplay( player, "OpenFRChallengesSettingsWpnSelector" )
		}
	} else
	{
		GiveRandomPrimaryWeaponMetagame( player )
		GiveRandomSecondaryWeaponMetagame( player )
	}

}

// original function to open loadout menu etc... Cafe
void function GivePlayerLoadoutOnGameStart( entity player )
{
	if ( !IsValid( player ) )
		return

	// player.DisableWeaponTypes( WPT_MELEE )

	wait 4.0

	if ( !IsValid( player ) )
		return

	bool isPlayerOnHoverTankAtStart = file.playersOnHovertank.contains( player ) ? true : false

	// Open the Loadout Select Menu the first time players enter the game
	// if ( IsUsingLoadoutSelectionSystem() && !player.IsBot() )
	// {
		// if ( isPlayerOnHoverTankAtStart )
			// wait 11.0

		// if ( IsValid( player ) )
		// {
			// LoadoutSelection_UpdateLoadoutInfoForMenus( player )
			// Remote_CallFunction_UI( player, "LoadoutSelectionMenu_OpenLoadoutMenu", false )
			// player.WaitSignal( "LoadoutSelection_LoadoutSelectMenuClosed" )
		// }
	// }

	if ( IsValid( player ) )
	{
		// Only assume the player state is normal if the player is still on the hovertank or never spawned on it.
		// Otherwise the player could be in a skydive state if they walked off the hovertank and we don't want to override that state
		if ( !isPlayerOnHoverTankAtStart || isPlayerOnHoverTankAtStart && file.playersOnHovertank.contains( player ) )
		{
			PlayerMatchState_Set( player, ePlayerMatchState.NORMAL )
			// player.EnableWeaponTypes( WPT_MELEE )
		}
		
		// Still only give the player armor and equipment( no weapons) if they were on the hovertank at the start ( since we don't want to give them weapons while skydiving, they will get them on landing)
		ResetPlayerInventoryAndLoadoutOnRespawn( player )
	}

	wait 2.0

	if ( IsValid( player ) )
	{
		Remote_CallFunction_NonReplay( player, "ServerCallback_CL_GameStartAnnouncement" )
		EmitSoundOnEntityOnlyToPlayer( player, player, "diag_ap_aiNotify_trainRulesHint_3p" )
	}
}

void function ResetPlayerInventoryAndLoadoutOnRespawn( entity player, bool shouldOnlyGiveEquipmentLoadout = false )
{
	if ( !IsValid( player ) || !IsAlive(player))
		return

	ResetPlayerInventory( player )

	if ( player.GetTeam() != TEAM_SPECTATOR )
	{
		// GivePlayerSettingsMods( player, [ "targetinfo_ffa_squad" ] )

		player.SetNameVisibleToEnemy( true )
	}

	// Use the stored player data to give players back their inventory on respawn
	// if ( IsUsingLoadoutSelectionSystem() )
	// {
		// LoadoutSelection_GivePlayerInventoryAndLoadout( player, shouldOnlyGiveEquipmentLoadout, false, false )
	// }
	// else
	// {
		// CharacterLoadouts_GiveCurrentCharacterLoadoutToPlayer( player, true )
	// }

	if ( GetCurrentPlaylistVarBool( "infinite_heal_items", false ) )
		GivePassive( player, ePassives.PAS_INFINITE_HEAL )
}

// Loadout info has been updated for Clients, make sure weapon icons are updated on screens that use them
void function WinterExpress_OnLoadoutUpdated( entity player )
{
	if ( IsValid( player ) && !player.IsBot() )
		Remote_CallFunction_NonReplay( player, "ServerCallback_CL_UpdateCurrentLoadoutHUD" )
}

// Loadout Menu has closed, update the rui that shows the current selected loadout
void function WinterExpress_OnLoadoutSelected( entity player )
{
	if ( IsValid( player ) && !player.IsBot() )
		Remote_CallFunction_NonReplay( player, "ServerCallback_CL_UpdateCurrentLoadoutHUD" )
}

// Triggers when the player has respawned as a different character
void function OnPlayerClassChanged( entity player )
{
	if ( IsValid( player ) && !player.IsBot() )
		Remote_CallFunction_NonReplay( player, "ServerCallback_CL_UpdateCurrentLoadoutHUD" )
}

void function OnPlayerKilled_Inventory( entity victim, entity attacker, var attackerDamageInfo )
{
	attacker = DamageInfo_GetAttacker( attackerDamageInfo ) // Ensure we are using the same attacker entity that the SpawnAmmoForCurrentWeapon function does
	if ( !IsValid( attacker ) || !IsValid( victim ) )
		return

	if ( !attacker.IsPlayer() && !attacker.IsNPC() )
		return

	SpawnAmmoForCurrentWeapon( victim, attackerDamageInfo )
}

void function OnPlayerKilled_Respawn( entity victim, entity attacker, var attackerDamageInfo )
{
	if ( !IsValid( victim ) )
		return

	Remote_CallFunction_NonReplay( victim, "ServerCallback_CL_ObserverModeSetToTrain" )
	UpdatePlayerCounts()
	victim.SetPlayerNetBool( "WinterExpress_IsPlayerAllowedLegendChange", true )
	thread RespawnPlayerWithGracePeriodPermit( victim )
	thread UpdateRespawnTimer( victim )
}

void function OnPlayerKilled_Commentary( entity victim, entity attacker, var attackerDamageInfo )
{
	if ( !Flag( "FirstPlayerDied" ) )
	{
		FlagSet( "FirstPlayerDied" )

		//manually trigger "first blood" announcement since we are disabling all other pilot kill dialogue
		thread PlayCommentaryLineWithMirageResponseIfOnSquad( PickCommentaryLineFromBucket_WinterExpressCustom( eSurvivalCommentaryBucket.FIRST_BLOOD ) )
	}

	// SurvivalCommentary_KillLeaderUpdate( attacker )
}

void function WinterExpress_PlayerFreefallEnd( entity player )
{
	player.SetPlayerNetBool( "hasDeathFieldImmunity", false )
}


void function RespawnPlayerWhenTrainNearsDestination()
{
	const float RESPAWN_LEADUP_TIME = 45
	const float MIN_RESPAWN_LEADUP_TIME = 11

	array<entity> pathNodes = DesertlandsTrain_GetCurrentPathNodes()
	array<vector> path      = ConvertPathNodesToPath( pathNodes )
	entity train            = DesertlandsTrain_GetTrain()
	vector trainOrigin      = DesertlandsTrain_GetTrainOrigin()

	float currentDist = GetDistanceAlongPath( path, trainOrigin )
	float maxDist     = GetPathLength( path )

	float trueLeadupTime = RESPAWN_LEADUP_TIME
	float roughTravelTime           = maxDist / WINTER_EXPRESS_TRAIN_MAX_SPEED
	if ( RESPAWN_LEADUP_TIME > roughTravelTime - MIN_RESPAWN_LEADUP_TIME )
		trueLeadupTime = roughTravelTime - MIN_RESPAWN_LEADUP_TIME

	float distFromStationAtRespawn  = trueLeadupTime * WINTER_EXPRESS_TRAIN_MAX_SPEED
	float distToTravelBeforeRespawn = maxDist - distFromStationAtRespawn
	Assert( distToTravelBeforeRespawn > 0 )
	float travelTimeBeforeRespawn = distToTravelBeforeRespawn / WINTER_EXPRESS_TRAIN_MAX_SPEED

	SetGlobalNetTime( "WinterExpress_TrainArrivalTime", Time() + roughTravelTime )
	SetGlobalNetTime( "WinterExpress_TrainTravelTime", roughTravelTime )
	SetGlobalNetTime( "WinterExpress_RoundRespawnTime", Time() + travelTimeBeforeRespawn )

	ClearGracePeriodPermisions()

	wait travelTimeBeforeRespawn

	if ( GetGameState() == eGameState.Playing )
	{
		array<entity> livingPlayers = GetPlayerArray_AliveConnected()
		foreach ( player in livingPlayers )
		{
			PermitPlayerToSpawnInGracePeriod( player )
			Remote_CallFunction_NonReplay( player, "ServerCallback_CL_RespawnAnnouncement" )
		}

		RespawnAllDeadPlayers()
		SetCurrentSpectateCameraToNextIndex()
	}

	wait 27

	if ( file.nextStationWaypoint != null )
		file.nextStationWaypoint.Destroy()
	file.nextStationWaypoint = null
}


void function ClearGracePeriodPermisions()
{
	foreach ( player in file.playersInGracePeriod )
	{
		if ( IsValid( player ) )
			player.SetPlayerNetBool( "WinterExpress_HasGracePeriodPermit", false )
	}
	file.playersInGracePeriod.clear()
}


void function PermitPlayerToSpawnInGracePeriod( entity player )
{
	player.SetPlayerNetBool( "WinterExpress_HasGracePeriodPermit", true )
	file.playersInGracePeriod.append( player )
}


void function RespawnPlayerWithGracePeriodPermit( entity player )
{
	EndSignal( player, "OnRespawned" )
	EndSignal( player, "OnDestroy" )


	if ( !ShouldRespawnInGracePeriod( player ) )
		return

	wait GRACE_PERIOD_SPAWN_DELAY

	if ( !IsAlive( player ) && GetGameState() == eGameState.Playing )
		RespawnPlayer( player )
}


void function UpdateRespawnTimer( entity player )
{
	EndSignal( player, "OnRespawned" )
	EndSignal( player, "OnDestroy" )

	float previousRoundRespawnTime = 0
	float startTime = Time()

	while( !IsAlive( player ) && GetGameState() == eGameState.Playing  )
	{
		float roundRespawnTime = GetGlobalNetTime( "WinterExpress_RoundRespawnTime" )
		if( previousRoundRespawnTime != roundRespawnTime )
		{
			Remote_CallFunction_NonReplay( player, "ServerCallback_RespawnPodStarted", roundRespawnTime )
			previousRoundRespawnTime = roundRespawnTime
		}
		WaitFrame()
	}
}


bool function ShouldRespawnInGracePeriod( entity player )
{
	if ( !player.GetPlayerNetBool( "WinterExpress_HasGracePeriodPermit" ) )
		return false

	if ( !file.playersInGracePeriod.contains( player ) )
		return false

	float gracePeriodEndTime = GetGlobalNetTime( "WinterExpress_TrainArrivalTime" )

	return Time() < gracePeriodEndTime
}


void function WaveRespawnIntervalThread( float respawnInterval )
{
	Signal( level, "WinterExpress_WaveSpawn" )
	EndSignal( level, "WinterExpress_WaveSpawn" )

	// respawn all dead players every X seconds
	// call function again to restart the countdown if needed.

	while( GetGameState() == eGameState.Playing )
	{
		SetGlobalNetTime( "WinterExpress_WaveRespawnTime", Time() + respawnInterval )
		wait respawnInterval

		RespawnAllDeadPlayers()
	}
}


void function SetPlayerRespawnOnTeam( entity player )
{
	// if a player doesn't spawn between round he shouldn't be added twice.
	if ( !file.spawnOnTeamArray.contains( player ) )
		file.spawnOnTeamArray.append( player )
}


// void function ClientCallback_WinterExpress_TryRespawnPlayer( entity player )
// {
	// if ( IsWaveRespawn() || IsRoundBasedRespawn() )
		// return

	// if ( !IsAlive( player ) && GetGlobalNetInt( "WinterExpress_RoundState" ) == eWinterExpressRoundState.CHANGING_STATIONS )
	// {
		// RespawnPlayer( player )
	// }
// }


void function RespawnAllDeadPlayers()
{
	array<entity> players = GetPlayerArray()
	foreach ( player in players )
	{
		if ( IsValid( player ) && !IsAlive( player ) )
			RespawnPlayer( player )
	}

	file.deadPlayers.clear()
	SetCurrentSpectateCameraToNextIndex()

	foreach( team in GetAllValidPlayerTeams() )
	{
		foreach ( player in GetConnectedPlayers() )
		{
			Remote_CallFunction_NonReplay( player, "ServerCallback_CL_SquadEliminationStateChanged", team, false )
		}
	}
}


void function RespawnTeam( int team )
{
	if ( GetGameState() != eGameState.Playing )
		return

	// TEAM_INVALID is same as TEAM_ANY so don't use TEAM_INVALID if you expect to get an empty array
	if ( team == TEAM_INVALID )
		return

	array<entity> players = GetPlayerArrayOfTeam( team )
	foreach ( player in players )
	{
		if ( IsValid( player ) && !IsAlive( player ) )
			RespawnPlayer( player )
	}
}


void function RespawnTeamAfterDelay( int team, float delay )
{
	wait delay
	RespawnTeam( team )
}

void function RespawnPlayer( entity player )
{
	if ( GetGameState() != eGameState.Playing )
		return

	player.StopObserverMode()
	ClearPlayerEliminated( player )
	ResetPlayerInventory( player )
	player.p.respawnPodLanded = true // pretend this is a valid survival respawn via dropship, get match participation errors without it
	player.SetPhysics( MOVETYPE_FLY )

	player.SetPlayerNetBool( "WinterExpress_HasGracePeriodPermit", false )
	if ( file.playersInGracePeriod.contains( player ) )
		file.playersInGracePeriod.fastremovebyvalue( player )

	printf( "WINTER EXPRESS: Grace Period Permit removed from player " + player.GetPlayerName() )

	if ( !IsAlive( player ) )
	{
		DecideRespawnPlayer_Retail( player, false )
	}

	// RemoveCinematicFlag( player, CE_FLAG_HIDE_MAIN_HUD_INSTANT )
	// RemoveCinematicFlag( player, CE_FLAG_HIDE_PERMANENT_HUD )	
	thread WinterExpress_OnPlayerRespawnedThread( player )
}


void function WinterExpress_OnPlayerRespawned( entity player )
{
	// thread WinterExpress_OnPlayerRespawnedThread( player )
}


void function WinterExpress_OnPlayerRespawnedThread( entity player )
{
	// DumpStack()
	if ( !player.p.respawnPodLanded )
		return // we didn't respawn

	EndSignal( player, "OnDestroy" )

	// have to wait for other respawn callbacks to complete. Yes, I know it's bad, but I couldn't find a way not to, short of rewriting the whole respawn system from scratch.
	WaitEndFrame()

	player.p.respawnPodLanded = false // need to be reset before we die again, this is just bad.

	EndSignal( player, "OnDeath" )

	Remote_CallFunction_NonReplay( player, "ServerCallback_ClearHints" )
	PlayerMatchState_Set( player, ePlayerMatchState.NORMAL )

	int team              = player.GetTeam()
	int livingTeamMembers = GetPlayerArrayOfTeam_AliveConnected( team ).len()

	bool success = false
	printf("Winter Express: spawning this player current scoring team is: " + file.lastValidTeamToScore)
	printf("Winter Express: spawning player current actual team: " + team)

	if ( team == file.lastValidTeamToScore )
	{
		// spawn on train or near teammember
		//if ( DesertlandsTrain_IsTeamOnTrain( team ) )
			success = WinterExpress_RespawnOnTrain( player, true )

		//if ( success )
			//file.spawnOnTeamArray.fastremovebyvalue( player )

		/*if ( !success )
			success = WinterExpress_RespawnOnTeam( player )*/
	}

	if ( !success )
	{
		if ( GetCurrentPlaylistVarBool( "winter_express_hovertank_spawn", true ) )
		{
			//if last team to score wasn't able to respawn on train, put them into a skydive instead at the next station
			if ( team == file.lastValidTeamToScore )
			{
				WinterExpress_RespawnSkydive( player )
				//file.spawnOnTeamArray.fastremovebyvalue( player )
			}
			else
			{
				WinterExpress_RespawnHoverTank( player )
			}
		}
		else if ( GetCurrentPlaylistVarBool( "winter_express_skydive_spawn", false ) )
		{
			WinterExpress_RespawnSkydive( player )
		}
		else
		{
			WinterExpress_RespawnAroundStation( player )
		}
	}

	// if ( file.shouldStoreUltimateCharge )
		// RestoreChargesForPlayer( player )

	Flowstate_GivePlayerLoadoutOnGameStart_Copy( player, true )
}

int function GetLastValidTeamToScore()
{
	return file.lastValidTeamToScore
}

bool function WinterExpress_RespawnOnTrain( entity player, bool isGameStartLerp = false )
{
	if ( !IsValid( player ) )
		return false

	array<vector> carSpawnPoints = [ <-250, 0, 42 >, <150, 0, 42>, <0, 0, 256>, <0, 150, 42> ]
	carSpawnPoints.randomize()
	array<entity> trainCarMovers = GetTrainMoversSorted( player )

	const MIN_SPAWN_DIST_FROM_ENEMY = 640
	int team = player.GetTeam()

	vector mins = player.GetBoundingMins()
	vector maxs = player.GetBoundingMaxs()

	foreach ( key, mover in trainCarMovers )
	{
		foreach ( pos in carSpawnPoints )
		{
			vector relativeOrigin = LocalPosToWorldPos( pos, mover )

			TraceResults results = TraceLine( relativeOrigin + <0,0,24> , relativeOrigin + <0,0,256> )
			if ( !IsValid( results.hitEnt ) )
				relativeOrigin = relativeOrigin + <0,0,20>

			if ( PlayerCanTeleportHere( player, relativeOrigin ) && !IsEnemiesWithinRange( team, relativeOrigin, MIN_SPAWN_DIST_FROM_ENEMY ) )
			{
				vector angles = FlattenAngles( VectorToAngles( mover.GetOrigin() - relativeOrigin ) )

				entity closestEnemy = GetClosestEnemy( team, relativeOrigin )
				if ( IsValid( closestEnemy ) )
				{
					// find vector towards nearest enemy
					vector vec = FlattenVec( Normalize( closestEnemy.GetOrigin() - player.GetOrigin() ) )
					float frac = TraceLineSimple( relativeOrigin + <0,0,36>, relativeOrigin + <0,0,60> + vec * 96, null, null )

					if ( frac == 1 )
					{
						angles = VectorToAngles( vec )
					}
				}

				player.SnapToAbsOrigin( relativeOrigin )
				player.SnapEyeAngles( VectorToAngles( mover.GetForwardVector() ) )
				player.SnapFeetToEyes()
				player.SetGroundEntity( mover )

				//transmit first train transmit time to clients
				array<entity> pathNodes = DesertlandsTrain_GetCurrentPathNodes()
				array<vector> path      = ConvertPathNodesToPath( pathNodes )
				vector trainOrigin      = DesertlandsTrain_GetTrainOrigin()

				float currentDist = GetDistanceAlongPath( path, trainOrigin )
				vector pointAhead = GetPointAtDistanceAlongPath( path, currentDist + 2550 ) + ( Normalize( file.trainRef.GetRightVector() ) * 550 ) + <0, 0, 128>

				float lerpAdjustmentTime = 3
				if ( isGameStartLerp )
					lerpAdjustmentTime += 1.5

				// thread WinterExpress_AdjustEyesAfterDelay( lerpAdjustmentTime, player, false )
				// Remote_CallFunction_NonReplay( player, "ServerCallback_CL_CameraLerpTrain", player, pointAhead, file.trainRef, isGameStartLerp )
				thread ScreenFadeThread( player, lerpAdjustmentTime - 1 )
				// ResetPlayerInventoryAndLoadoutOnRespawn( player )

				player.SetPlayerNetBool( "WinterExpress_IsPlayerAllowedLegendChange", false )

				return true
			}
		}
	}
printf("winter express: Failing a train spawn falling back to something else")
	return false
}

void function ScreenFadeThread( entity player, float waitTime )
{
	player.SetInvulnerable()

	wait waitTime

	if ( !IsValidPlayer( player ) )
		return

	thread ScreenFadeToBlack( player, 0.5, 0.5 )
	wait 0.75

	if ( !IsValidPlayer( player ) )
		return
	else
		player.ClearInvulnerable()

	//wait for music to fade out
	wait 2

	// if ( IsValid( player ) )
		// StopAllMusicOnPlayer( player )
}


bool function IsEnemiesWithinRange( int team, vector origin, float range )
{
	float sqrRange = range * range

	array<entity> enemyArray = GetPlayerArrayOfEnemies_Alive( team )
	foreach( enemy in enemyArray )
	{
		float sqrDist = Distance2DSqr( origin, enemy.GetOrigin() )
		if ( sqrDist < sqrRange  )
			return true
	}

	return false
}


entity function GetClosestEnemy( int team, vector origin )
{
	array<entity> enemyArray = GetPlayerArrayOfEnemies_Alive( team )
	return GetClosest( enemyArray, origin, 1024 )
}

const int RESPAWN_ON_TEAM_HULL = HULL_TITAN

bool function WinterExpress_RespawnOnTeam( entity player )
{
	const NAV_POINT_COUNT = 6

	array<entity> teamMembers = GetPlayerArrayOfTeam_AliveConnected( player.GetTeam() )
	foreach ( playerEnt in teamMembers )
	{
		if ( player == playerEnt )
			continue

		vector spawnOrigin   = playerEnt.GetOrigin() + <0, 0, 8>
		vector stationOrigin = GetClosestStation( playerEnt.GetOrigin() )

		array<vector> navMeshOrigins = NavMesh_RandomPositions( playerEnt.GetOrigin(), RESPAWN_ON_TEAM_HULL, NAV_POINT_COUNT, SPAWN_MIN_RADIUS, SPAWN_MAX_RADIUS )
		foreach ( index, origin in navMeshOrigins )
		{
			if ( !PlayerCanTeleportHere( player, origin, player ) || !CanFindPathToGoal( origin, stationOrigin, index ) )
				continue

			spawnOrigin = origin
			break
		}

		vector spawnAngles = FlattenAngles( VectorToAngles( playerEnt.GetOrigin() - spawnOrigin ) )

		player.SnapToAbsOrigin( spawnOrigin + <0, 0, 2>)
		player.SnapEyeAngles( spawnAngles )
		player.SnapFeetToEyes()
		player.SetGroundEntity( playerEnt.GetGroundEntity() )

		return true
	}

	return false
}


void function WinterExpress_RespawnHoverTank( entity player, bool isGameStartLerp = false, int teamIndexOverride = -1, int playerIndexOverride = -1 )
{
	if ( !IsValid( player ) )
		return

	int teamIndex  = teamIndexOverride < 0 ? GetTeamIndex( player.GetTeam(), true ) : teamIndexOverride
	int spawnIndex = teamIndex % (MAX_TEAMS - 1)
	int playerIndex = playerIndexOverride < 0 ? player.GetTeamMemberIndex() : playerIndexOverride

	string spawnTank = spawnIndex == 0 ? "HoverTank_holiday" : "HoverTank_holiday02"
	entity hoverTank = GetEntByScriptNameInInstance( "_hover_tank_mover", spawnTank )

	printf( "WINTER EXPRESS: Spawning " + player.GetPlayerName() + " on " + spawnTank + " at index " + playerIndex  )

	vector spawnOffset = WinterExpress_GetHoverTankSpawnOffset( playerIndex )
	vector spawnOrigin = LocalPosToWorldPos( spawnOffset, hoverTank )
	spawnOrigin = spawnOrigin + <0,0,8>

	player.SnapToAbsOrigin( spawnOrigin )

	float lerpAdjustmentTime = 10
	if ( isGameStartLerp )
		lerpAdjustmentTime += 1.5

	// thread WinterExpress_AdjustEyesAfterDelay( lerpAdjustmentTime, player )
	
	//Why this mover stoppde working aaaa Cafe
	// Remote_CallFunction_NonReplay( player, "ServerCallback_CL_CameraLerpFromStationToHoverTank", player, DesertlandsTrain_GetNextStationNode(), GetClosestHovertankEnt_ToPlayer( player ), file.trainRef, isGameStartLerp )

	// ResetPlayerInventoryAndLoadoutOnRespawn( player )
}

void function WinterExpress_AdjustEyesAfterDelay( float delay, entity player, bool shouldSnapToStation = true )
{
	player.MovementDisable()

	wait delay

	if ( !IsValid( player ) )
		return

	vector objStationAvg = ( DesertlandsTrain_GetNextStationNode().GetOrigin() + file.trainRef.GetOrigin() ) / 2.0
	vector playerView = VectorToAngles( objStationAvg - player.EyePosition() )

	if ( shouldSnapToStation )
	{
		player.SnapEyeAngles( playerView )
		player.SnapFeetToEyes()
	}

	player.MovementEnable()
}


void function WinterExpress_RespawnSkydive( entity player )
{
	if ( !IsValid( player ) )
		return

	if ( IsRoundBasedRespawn() && !ShouldRespawnInGracePeriod( player ) && file.respawningPlayers.contains( player ) )
	{
		Signal( player, "ready_for_skydive" )
		return
	}

	Point spawnPoint = GetSkyDivePoint( player )

	player.SetOrigin( spawnPoint.origin )
	player.SetAngles( spawnPoint.angles )

	player.SetPlayerNetBool( "hasDeathFieldImmunity", true )
	// ResetPlayerInventoryAndLoadoutOnRespawn( player )
	//player.SetPlayerNetBool( "WinterExpress_IsPlayerAllowedLegendChange", true )
	PlayerMatchState_Set( player, ePlayerMatchState.SKYDIVE_FALLING )

	thread PlayerSkydiveFromCurrentPosition( player )
}


vector function WinterExpress_GetHoverTankSpawnOffset( int playerIndex )
{
	switch( playerIndex )
	{
		case 0:
			return <0, 0, 205>
		case 1:
			return <0, -60, 205>
		case 2:
			return <0, 60, 205>
		default:
			Warning( "WINTER EXPRESS: Trying to spawn player at playerIndex that does not exist" )
			return <0,0,0>
	}

	unreachable
}


void function TrackReadyForSkyDive( entity player )
{
	EndSignal( player, "OnDestroy" )

	if ( !file.respawningPlayers.contains( player ) )
		file.respawningPlayers.append( player )

	OnThreadEnd(
		function() : ( player )
		{
			file.respawningPlayers.fastremovebyvalue( player )

			if ( IsAlive( player ) )
			{
				int team = player.GetTeam()
				if ( !(team in file.skydiveTeamPlayerArray) )
					file.skydiveTeamPlayerArray[ team ] <- []
				file.skydiveTeamPlayerArray[ team ].append( player )
			}

			if ( file.respawningPlayers.len() == 0 )
				SkyDiveAllRespawnedSquads()
		}
	)

	WaitSignal( player, "ready_for_skydive" )
}


void function SkyDiveAllRespawnedSquads()
{
	foreach ( team, playerArray in file.skydiveTeamPlayerArray )
	{
		SkyDiveRespawnedTeamPlayers( playerArray, team )
	}
	file.skydiveTeamPlayerArray.clear()
}

void function SkyDiveRespawnedTeamPlayers( array<entity> jumpingPlayers, int team )
{
	Assert( jumpingPlayers.len() > 0 )

	jumpingPlayers.randomize()
	entity jumpMaster = jumpingPlayers[0]
	Assert( IsAlive( jumpMaster ) )

	SetJumpmaster( team, jumpMaster )

	Point skyDivePoint = GetSkyDivePoint( jumpMaster )

	vector driverViewVector = AnglesToForward( skyDivePoint.angles )
	foreach ( jumpingPlayer in jumpingPlayers )
	{
		jumpingPlayer.SetAbsOrigin( skyDivePoint.origin )
		jumpingPlayer.SetAbsAngles( skyDivePoint.angles )

		jumpingPlayer.p.skydiveDecoysFired = 0 //Resetting Mirage's decoy counter so he can use his hidden passive with skydive towers.
		jumpingPlayer.Zipline_Stop()
		SetPlayerIntroDropSettings( jumpingPlayer )

		jumpingPlayer.SetPlayerNetBool( "hasDeathFieldImmunity", true )

		thread PlayerSkyDive( jumpingPlayer, driverViewVector, jumpingPlayers, jumpMaster )
	}
}


Point function GetSkyDivePoint( entity player )
{
	if ( IsRoundBasedRespawn() )
	{
		return GetSkyDivePointCircularSpread( player )
	}

	return GetSkyDivePointHorizontalSpread( player )
}

array<vector> function ConvertPathNodesToPath( array<entity> pathNodes )
{
	array<vector> path
	for ( int i = 0; i < pathNodes.len(); i++ )
	{
		path.append( pathNodes[i].GetOrigin() )
	}
	return path
}


Point function GetSkyDivePointCircularSpread( entity player )
{
	/*
		We are getting a point along the train track and then we offset up and to the side depending on what team you are on etc.
		When the train is to close to the station we simply use the station as the center of the cirle.
	*/

	Point spawnPoint

	entity stationNode = DesertlandsTrain_GetNextStationNode()
	vector center      = GetClosestStation( stationNode.GetOrigin() )

	int teamIndex  = GetTeamIndex( player.GetTeam() )
	//	int timeIndex  = int( (Time() / 10) )
	//	int roundIndex = int( (Time() / 10) )
	//	int spawnIndex = (teamIndex + roundIndex) % MAX_TEAMS
	int spawnIndex = teamIndex % MAX_TEAMS

	float yawStep    = 360.0 / MAX_TEAMS
	float yaw        = (yawStep * spawnIndex) + 45.0
	vector direction = AnglesToForward( <0, yaw, 0> )

	spawnPoint.origin = center + direction * SKY_DIVE_CIRCLE_SPAWN_DIST + <0, 0, SKY_DIVE_CIRCLE_SPAWN_HEIGHT>
	spawnPoint.angles = VectorToAngles( Normalize( center - spawnPoint.origin ) )

	#if DEVELOPER
		//DebugDrawLine( spawnPoint.origin, center, COLOR_GREEN, true, 10 )
	#endif

	return spawnPoint
}


Point function GetSkyDivePointHorizontalSpread( entity player )
{
	/*
		We are getting a point along the train track and then we offset up and to the side depending on what team you are on etc.
		When the train is to close to the station we find a spot x units away towards the center of the map instead.
	*/

	Point spawnPoint

	entity train       = DesertlandsTrain_GetTrain()
	vector trainOrigin = train.GetOrigin()
	float trainSpeed
	if ( train.Train_IsMovingToTrainNode() )
		trainSpeed = train.Train_GetCurrentSpeed()

	array<entity> pathNodes = DesertlandsTrain_GetCurrentPathNodes()
	array<vector> path      = ConvertPathNodesToPath( pathNodes )
	Assert( path.len() > 1 )

	float currentDist = GetDistanceAlongPath( path, trainOrigin )
	float maxDist     = GetPathLength( path )
	float spawnDist   = min( maxDist, currentDist + SKY_DIVE_SPAWN_DIST )
	vector origin
	if ( spawnDist != maxDist )
		origin = GetPointAtDistanceAlongPath( path, spawnDist )
	else
	{
		vector center = SURVIVAL_GetDeathFieldCenter()
		vector towardsCenter = FlattenVec( Normalize( center - trainOrigin ) )
		origin = trainOrigin + towardsCenter * SKY_DIVE_SPAWN_DIST
	}
	vector forward = Normalize( FlattenVec( trainOrigin - origin ) )
	vector right   = AnglesToRight( VectorToAngles( forward ) )

	int teamIndex   = GetTeamIndex( player.GetTeam() )
	int playerIndex = GetPayerIndex( player )
	int timeIndex   = int( (Time() / 10) )
	int spawnIndex  = ((teamIndex + timeIndex) % MAX_TEAMS) - (MAX_TEAMS / 2)

	const TEAM_SHIFT_DIST = 1000
	const PLAYER_SHIFT_DIST = 64
	spawnPoint.origin = origin + <0, 0, SKY_DIVE_SPAWN_HEIGHT> + right * (TEAM_SHIFT_DIST * spawnIndex) + right * (PLAYER_SHIFT_DIST * (playerIndex - 1))
	spawnPoint.angles = VectorToAngles( Normalize( trainOrigin - spawnPoint.origin ) )

	return spawnPoint
}


bool function WinterExpress_RespawnAroundStation( entity player )
{
	if ( !IsValid( player ) )
		return false

	entity stationNode   = DesertlandsTrain_GetNextStationNode()
	vector stationOrigin = GetClosestStation( stationNode.GetOrigin() )

	// todo: fix this
	// since the station origin and the objective mover doesn't match at this point, we force spawns to be around the objective when the objective is active.
	if ( IsValid( file.currentObjectiveMover ) )
		stationOrigin = file.currentObjectiveMover.GetOrigin()

	array<Point> spawnPoints = GetSpawnPointArrayForTeamAroundStation( player.GetTeam(), stationOrigin )
	int spawnIndex           = GetPayerIndex( player )


	Assert( spawnPoints.len() >= 3, "Couldn't find spawnpoints around stationOrigin: " + stationOrigin )

	if( spawnPoints.len() < 3 )
	{
		printt( "ERROR CALCULATING SPAWN POITNS FOR TEAM", spawnPoints.len() )
		return false
	}
	player.SnapToAbsOrigin( spawnPoints[ spawnIndex ].origin + <0, 0, 2> )
	player.SnapEyeAngles( spawnPoints[ spawnIndex ].angles )
	player.SnapFeetToEyes()
	// ResetPlayerInventoryAndLoadoutOnRespawn( player )
	player.SetPlayerNetBool( "WinterExpress_IsPlayerAllowedLegendChange", false )

	return true
}


array<entity> function GetTrainMoversSorted( entity player )
{
	// return train car data sorted by distance to player team

	array<entity> teamMembers        = GetPlayerArrayOfTeam_AliveConnected( player.GetTeam() )
	array<TrainCarData> trainCarData = clone DesertlandsTrain_GetTrainCarData()
	array<entity> trainMoversSorted

	while( trainCarData.len() > 0 )
	{
		TrainCarData closestCar
		float closestDist = -1
		foreach ( car in trainCarData )
		{
			float dist = GetDistanceToTeam( car.mover.GetOrigin(), teamMembers, player )
			if ( dist < closestDist || closestDist == -1 )
			{
				closestCar = car
				closestDist = dist
			}
		}

		trainMoversSorted.append( closestCar.mover )
		trainCarData.fastremovebyvalue( closestCar )
	}

	return trainMoversSorted
}

float function GetDistanceToTeam( vector pos, array<entity> teamMembers, entity excludePlayer = null )
{
	float clostestDist = -1
	foreach ( player in teamMembers )
	{
		if ( player == excludePlayer )
			continue

		float dist = Distance( player.GetOrigin(), pos )
		if ( dist < clostestDist || clostestDist == -1 )
			clostestDist = dist
	}

	return clostestDist
}


int function GetPayerIndex( entity player )
{
	array<entity> playerArray = GetPlayerArrayOfTeam( player.GetTeam() )
	return playerArray.find( player )
}

vector function GetClosestStation( vector origin )
{
	int nearestIndex           = GetClosestVectorIndex( file.stationArray, origin, false )
	return file.stationArray[ nearestIndex ]
}

bool drawSpawns = false
array<Point> function GetSpawnPointArrayForTeamAroundStation( int team, vector stationOrigin )
{
	int teamIndex = GetTeamIndex( team )
	Assert( teamIndex != -1, "team " + team + " doesn't exist" )

	vector nodePos
	vector pos
	array<Point> navMeshPoints

	int teamCount = GetAllValidPlayerTeams().len()
	Assert( teamCount > 0 )

	if ( Distance( stationOrigin, <25286, 10481, -4559> ) > 1024 )
	{
		for ( int tryCount = 0; tryCount < SPAWN_MAX_TRY_COUNT / teamCount; tryCount++ )
		{
			navMeshPoints = GetNaveMeshPointsForTeam( teamIndex, stationOrigin, teamCount, tryCount )
			if ( navMeshPoints.len() > 0 )
				break
		}
	}

	#if DEVELOPER
		if ( drawSpawns )
		{
			foreach ( p in navMeshPoints )
			{
				DebugDrawSphere( p.origin, 1024.0, 255, 0, 0, true, 300.0, 10 )
			}
		}
	#endif

	return navMeshPoints
}

array<Point> function GetNaveMeshPointsForTeam( int teamIndex, vector stationOrigin, int teamCount, int tryCount )
{
	const TEAM_SIZE = 3
	const PLAYER_MINS = <-16, -16, 0>
	const PLAYER_MAXS = <16, 16, 80>

	array<Point> navMeshPoints

	int timeYaw = (int( Time() ) % 8) * (360 / 8)
	int tryYaw  = tryCount * (360 / SPAWN_MAX_TRY_COUNT)

	int steps = 360 / teamCount + 8
	int yaw   = teamIndex * steps
	yaw = (yaw + timeYaw + tryYaw) % 360
	vector direction = AnglesToForward( <0, yaw, 0> )
	vector pos       = stationOrigin + direction * SPAWN_DIST

	int navNode = NavMeshNode_GetNearestNodeToPos( pos )
	if ( navNode > 0 )
	{
		vector nodePos = NavMeshNode_GetNodePos( navNode )

		Assert( Distance( pos, nodePos ) < 1500, "Couldn't find a navmesh pos within range of " + pos )

		array<vector> navMeshOrigins = NavMesh_RandomPositions( nodePos, RESPAWN_ON_TEAM_HULL, TEAM_SIZE, SPAWN_MIN_RADIUS, SPAWN_MAX_RADIUS )
		Assert( navMeshOrigins.len() == TEAM_SIZE )

		vector angles = FlattenAngles( VectorToAngles( Normalize( stationOrigin - nodePos ) ) )

		foreach ( origin in navMeshOrigins )
		{
			if ( !WinterExpress_CanTeleportHere( origin, PLAYER_MINS, PLAYER_MAXS ) || !CanFindPathToGoal( origin, stationOrigin, tryCount ) )
				return []

			Point p
			p.origin = origin
			p.angles = angles

			navMeshPoints.append( p )
		}
	}

	return navMeshPoints
}

bool function WinterExpress_CanTeleportHere( vector testOrg, vector mins, vector maxs, array<entity> ignoreEnts = [] )
{
	// didn't have the player when I needed to test the position so assume it's a big player and trace based on that.

	int solidMask      = TRACE_MASK_PLAYERSOLID
	int collisionGroup = TRACE_COLLISION_GROUP_PLAYER

	TraceResults result

	result = TraceHull( testOrg, testOrg + <0, 0, 1>, mins, maxs, ignoreEnts, solidMask, collisionGroup )

	if ( result.startSolid )
		return false

	return true
}


bool function CanFindPathToGoal( vector origin, vector stationOrigin, int tryCount )
{
	// NavMesh_FindMeshPath_Result meshPath = NavMesh_FindPathForHumanPlayer( origin, stationOrigin )

	// if ( meshPath.points.len() < 1 )
	// {
		// #if DEVELOPER
			// if ( drawSpawns )
				// DrawStar( origin, 32, 2, true )
		// #endif
		// return false
	// }

	// float distFromFistNode = Distance( meshPath.points[0], meshPath.points[ meshPath.points.len() - 1] )
	// float distToStation    = Distance( stationOrigin, meshPath.points[ meshPath.points.len() - 1] )

	// if ( distFromFistNode < 256 || distToStation > 256 )
	// {
		// #if DEVELOPER
			// if ( drawSpawns )
			// {
				// DebugDrawText( origin + <0, 0, 16>, string( tryCount ), false, 2 )
				// // DebugDrawLine( origin, stationOrigin, <255, 0, 192>, true, 2 )
				// DrawPath( meshPath.points, <255, 0, 0> )
			// }
		// #endif
		// return false
	// }

	// #if DEVELOPER
		// if ( drawSpawns )
		// {
			// if ( tryCount > 0 )
			// {
				// // DebugDrawLine( origin, stationOrigin, <0, 128, 0>, true, 2 )
				// DebugDrawText( origin + <0, 0, 16>, string( tryCount ), false, 2 )
			// }
			// else
			// {
				// DrawStar( origin, 16, 2, true )
			// }
		// }
	// #endif

	return true
}


int function GetTeamIndex( int team, bool shouldExcludeLastValidWinner = false )
{
	array<int> allTeams = GetAllValidPlayerTeams()
	if ( shouldExcludeLastValidWinner )
		allTeams.removebyvalue( file.lastValidTeamToScore )
	int index           = allTeams.find( team )
	return index
}

#if DEVELOPER
void function DrawAllSpawnPoints()
{
	array<int> teams           = GetAllValidPlayerTeams()

	foreach ( stationOrigin in file.stationArray )
	{
		DrawAllSpawnPointsAroundOrigin( stationOrigin )
	}
}

void function DrawAllStations()
{
	int rVal = 0
	foreach ( stationOrigin in file.stationArray )
	{
		DebugDrawSphere( stationOrigin, 1024.0, rVal, 0, 0, true, 300.0, 8 )

		rVal += ( 255 / 5 )
	}
}

void function DrawAllSpawnPointsAroundOrigin( vector stationOrigin )
{
	if ( IsValid( file.currentObjectiveMover ) )
		stationOrigin = file.currentObjectiveMover.GetOrigin()

	drawSpawns = true
	array<int> teams = GetAllValidPlayerTeams()
	foreach ( team in teams )
	{
		GetSpawnPointArrayForTeamAroundStation( team, stationOrigin )
	}
	drawSpawns = false
}
#endif

bool function WinterExpress_CanSquadBeEliminated( entity player )
{
	return false //squads cannot currently be eliminated
}
#endif

//////////////////////////////////
// Functions to handle presents //
//////////////////////////////////
#if SERVER
void function SpawnAmmoForCurrentWeapon( entity player, var attackerDamageInfo = null )
{
	LootThrowData throwData
	throwData.throwAngle = 0
	throwData.throwScale = 1
	vector throwOrigin = player.GetOrigin()


	if ( attackerDamageInfo != null )
	{
		entity damageWeapon = DamageInfo_GetWeapon( attackerDamageInfo )
		if ( IsValid( damageWeapon ) && damageWeapon.GetActiveAmmoSource() == AMMOSOURCE_POOL )
		{
			string ammoType = GetWeaponAmmoTypeFromWeaponEnt( damageWeapon )

			for ( int i = 0; i < 2; i++ )
			{
				int countPerDrop = int( floor( SURVIVAL_Loot_GetLootDataByRef( ammoType ).countPerDrop ) )

				entity itemEnt = SpawnGenericLoot( ammoType, throwOrigin, < -1, -1, -1 >, countPerDrop )

				SetItemSpawnSource( itemEnt, eSpawnSource.PLAYER_DEATH, player )
				vector throwDir = <sin( throwData.throwAngle ), cos( throwData.throwAngle ), 0>
				float speed     = throwData.throwScale * sqrt( RandomFloatRange( 0.75, 1.0 ) ) * 150
				vector vel      = throwDir * speed
				thread FakePhysicsThrow_Retail( player, itemEnt, <vel.x, vel.y, 200>, true )
				throwData = SURVIVAL_DropLoot_IncrementThrowAngle( throwData )
			}
		}
	}
}

#endif

/////////////////////////////////////
// Functions for Custom Commentary //
/////////////////////////////////////
#if SERVER
void function PlayCommentaryLineWithMirageResponseIfOnSquad( string commentaryDialogueRef )
{
	string responseRef = "bc_mirage_winterReply"

	foreach ( int team in GetAllValidPlayerTeams() )
	{
		entity potentialMirage      = null
		array<entity> playersOnTeam = GetPlayerArrayOfTeam( team )

		foreach ( entity player in playersOnTeam )
		{
			if ( IsAlive( player ) && GetPlayerVoice( player ) == "mirage" )
				potentialMirage = player
		}

		bool teamGotRareLine = RandomInt( 100 ) < 12

		foreach ( entity player in playersOnTeam )
		{
			if ( IsValid( potentialMirage ) && teamGotRareLine )
				thread PlayDialogueForPlayer( commentaryDialogueRef, player, null, 0, COMMENTARY_ANNOUNCER_DIALOGUE_FLAGS, responseRef, potentialMirage )
			else
				thread PlayDialogueForPlayer( commentaryDialogueRef, player, null, 0, COMMENTARY_ANNOUNCER_DIALOGUE_FLAGS )
		}
	}
}
#endif

#if SERVER || CLIENT
string function PickCommentaryLineFromBucket_WinterExpressCustom( int commentaryBucket )
{
	string line = PickCommentaryLineFromBucket( commentaryBucket )

	if ( LONG_OR_FLAVORFUL_LINES.contains( line ) && RandomInt( 100 ) < REROLL_CHANCE )
		line = PickCommentaryLineFromBucket( commentaryBucket )
	printt("CHOSEN LINE", line )
	return line
}
#endif

/////////////////////////////////
// Functions for UI Management //
/////////////////////////////////

#if UI
void function UI_UpdateOpenMenuButtonCallbacks_Spectate( int newLifeState, bool shouldCloseMenu )
{
	if ( GetGameState() > eGameState.WinnerDetermined ) // || uiGlobal.isLevelShuttingDown )
		return

	if ( newLifeState == LIFE_ALIVE )
	{
		// if ( shouldCloseMenu )
			// RunClientScript( "CloseCharacterSelectMenu" )


		// if ( IsUsingLoadoutSelectionSystem() )
		// {
			// if ( shouldCloseMenu && LoadoutSelectionMenu_IsLoadoutMenuOpen())
				// LoadoutSelectionMenu_CloseLoadoutMenu()
		// }
	}
}

void function WinterExpress_UI_OpenCharacterSelect( var button )
{
	var deathScreenMenu = GetMenu( "DeathScreenMenu" )
	if ( GetActiveMenu() != deathScreenMenu )
		return

	if ( GetGameState() != eGameState.Playing )
		return

	RunClientScript( "UICallback_WinterExpress_OpenCharacterSelect" )
}

void function WinterExpress_TryRespawn( var button )
{
	var characterSelectMenu = GetMenu( "CharacterSelectMenu" )
	if ( GetActiveMenu() == characterSelectMenu )
		return

	// Remote_ServerCallFunction( "ClientCallback_WinterExpress_TryRespawnPlayer" )
}

// Open the Loadout Selection Menu
void function WinterExpress_UI_OpenLoadoutSelect( var button )
{
	var deathScreenMenu = GetMenu( "DeathScreenMenu" )
	if ( GetActiveMenu() != deathScreenMenu )
		return

	if ( GetGameState() != eGameState.Playing )
		return

	// LoadoutSelectionMenu_OpenLoadoutMenu( true )
}

#endif

#if CLIENT
// Deregister all button pressed callbacks when leaving the mode
void function ServerCallback_CL_DeregisterModeButtonPressedCallbacks()
{
	// Deregister buttons pressed callbacks for the buttons shown on the spectate screen and close the menus if they are open
	RunUIScript( "UI_UpdateOpenMenuButtonCallbacks_Spectate", LIFE_ALIVE, true )

	// Deregister buttons pressed callbacks for the buttons shown in gameplay ( on the hovertank)
	WinterExpress_UpdateOpenMenuButtonCallbacks_Gameplay( false )
}

void function ServerCallback_CL_UpdateOpenMenuButtonCallbacks_Gameplay( bool isLegendSelectAvailable )
{
	WinterExpress_UpdateOpenMenuButtonCallbacks_Gameplay( isLegendSelectAvailable )
}


// Display a Change Legend option and allow players to open the Legend Selection Menu or remove those options depending on gamestate
void function WinterExpress_UpdateOpenMenuButtonCallbacks_Gameplay( bool isLegendSelectAvailable )
{
	entity player = GetLocalClientPlayer()
	if ( !IsValid( player ) )
		return

	// if ( !isLegendSelectAvailable && file.OpenMenuGameplayButtonCallbackRegistered )
	// {
		// DeregisterConCommandTriggeredCallback( "+offhand1", WinterExpress_CL_TryOpenCharacterSelect )

		// // if( CharacterSelect_MenuIsOpen() )
			// // CloseCharacterSelectMenu()

		// if ( file.legendSelectMenuPromptRui != null )
		// {
			// RuiDestroy( file.legendSelectMenuPromptRui )
			// file.legendSelectMenuPromptRui = null
		// }

		// // if ( IsUsingLoadoutSelectionSystem() )
		// // {
			// // DeregisterConCommandTriggeredCallback( "+offhand4", WinterExpress_CL_TryOpenLoadoutSelect )
			// // RunUIScript( "LoadoutSelectionMenu_CloseLoadoutMenu" )

		// // }

		// file.OpenMenuGameplayButtonCallbackRegistered = false
	// }

	// if ( isLegendSelectAvailable && !file.OpenMenuGameplayButtonCallbackRegistered && player.GetPlayerNetBool( "WinterExpress_IsPlayerAllowedLegendChange" ) )
	// {
		// RegisterConCommandTriggeredCallback( "+offhand1", WinterExpress_CL_TryOpenCharacterSelect )

		// var rui = CreateFullscreenRui( $"ui/winter_express_change_prompt_screen.rpak", 100 )
		// file.legendSelectMenuPromptRui = rui

		// // if ( IsUsingLoadoutSelectionSystem() )
		// // {
			// // RegisterConCommandTriggeredCallback( "+offhand4", WinterExpress_CL_TryOpenLoadoutSelect )
		// // }

		// WinterExpress_UpdateCurrentLoadoutHUD()
		// file.OpenMenuGameplayButtonCallbackRegistered = true
	// }
}



// Request open character select screen on the Client
void function WinterExpress_CL_TryOpenCharacterSelect( var button )
{
	entity player = GetLocalClientPlayer()

	if ( !IsValid( player ) )
		return

	if ( GetGameState() != eGameState.Playing )
		return

	UICallback_WinterExpress_OpenCharacterSelect()
}

// Callback when the character select menu is closed, we need to wait a bit before updating the Hud to show the right character portrait
void function WinterExpress_OnCharacterSelectMenuClosed()
{
	thread WinterExpress_OnCharacterSelectMenuClosed_Thread()
}

void function WinterExpress_OnCharacterSelectMenuClosed_Thread()
{
	entity clientPlayer = GetLocalClientPlayer()
	clientPlayer.EndSignal( "OnDestroy" )

	OnThreadEnd(
		function() : ( clientPlayer )
		{
			if ( IsValid( clientPlayer ) )
				WinterExpress_UpdateCurrentLoadoutHUD()
		}
	)

	wait 0.3
}

// Server callback to Update the text/icons for the currently selected Loadout
void function ServerCallback_CL_UpdateCurrentLoadoutHUD()
{
	WinterExpress_UpdateCurrentLoadoutHUD()
}

// Update the text/icons for the currently selected Loadout or character
void function WinterExpress_UpdateCurrentLoadoutHUD()
{
	// entity player = GetLocalClientPlayer()

	// if ( !IsValid( player ) )
		// return

	// var legendSelectPromptRui = file.legendSelectMenuPromptRui

	// // Update loadout images
	// // if ( IsUsingLoadoutSelectionSystem() )
	// // {
		// // int currentLoadout = LoadoutSelection_GetSelectedLoadoutSlotIndex_CL_UI()

		// // if ( legendSelectPromptRui != null )
		// // {
			// // RuiSetBool( legendSelectPromptRui, "hasLoadoutSelect", true )
			// // RuiSetString( legendSelectPromptRui, "currentLoadoutHeaderText", LoadoutSelection_GetLocalizedLoadoutHeader( currentLoadout ) )
			// // RuiSetImage( legendSelectPromptRui, "weapon0Icon", LoadoutSelection_GetItemIcon( currentLoadout, 0, -1 ) )
			// // RuiSetInt( legendSelectPromptRui, "weapon0LootTier", LoadoutSelection_GetWeaponLootTeir( currentLoadout, 0) )
			// // RuiSetImage( legendSelectPromptRui, "weapon1Icon", LoadoutSelection_GetItemIcon( currentLoadout, 1, -1 ) )
			// // RuiSetInt( legendSelectPromptRui, "weapon1LootTier", LoadoutSelection_GetWeaponLootTeir( currentLoadout, 1) )
			// // RuiSetImage( legendSelectPromptRui, "consumable0Icon", LoadoutSelection_GetItemIcon( currentLoadout, -1, 0 ) )
			// // RuiSetImage( legendSelectPromptRui, "consumable1Icon", LoadoutSelection_GetItemIcon( currentLoadout, -1, 1 ) )
			// // RuiSetImage( legendSelectPromptRui, "consumable2Icon", LoadoutSelection_GetItemIcon( currentLoadout, -1, 2 ) )
			// // RuiSetBool( GetCompassRui(), "isVisible", false )
			// // file.legendSelectMenuPromptRui = legendSelectPromptRui
		// // }
		// // else
			// // RuiSetBool( GetCompassRui(), "isVisible", true )
	// // }

	// // Update character images
	// if ( legendSelectPromptRui != null && LoadoutSlot_IsReady( ToEHI( player ), Loadout_Character() ) )
	// {
		// ItemFlavor character = LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_Character() )
		// RuiSetBool( legendSelectPromptRui, "hasLegendSelect", true )
		// RuiSetImage( legendSelectPromptRui, "legendIcon", CharacterClass_GetGalleryPortrait( character ) )

		// file.legendSelectMenuPromptRui = legendSelectPromptRui
	// }
}

// Open the Loadout Selection Menu
void function WinterExpress_CL_TryOpenLoadoutSelect( var button )
{
	// if ( !IsUsingLoadoutSelectionSystem() )
		// return

	entity player = GetLocalClientPlayer()

	if ( !IsValid( player ) )
		return

	if ( GetGameState() != eGameState.Playing )
		return

	// RunUIScript( "LoadoutSelectionMenu_OpenLoadoutMenu", false )
}


void function OnWaitingForPlayers_Client()
{
	if ( file.gameStartRuiCreated )
		return

	SurvivalCommentary_SetHost( eSurvivalHostType.MIRAGE )

	// file.gameStartRui = RuiCreate( $"ui/winter_express_game_start.rpak", clGlobal.topoFullScreen, RUI_DRAW_POSTEFFECTS, 1 )
	// RuiSetString( file.gameStartRui, "gameModeString", GetCurrentPlaylistVarString( "name", "#PLAYLIST_UNAVAILABLE" ) )
	// RuiSetString( file.gameStartRui, "mapNameString", GetCurrentPlaylistVarString( "map_name", "#PLAYLIST_UNAVAILABLE" ) )
	// RuiSetImage( file.gameStartRui , "gameModeIcon", GetGamemodeLogoFromImageMap( GetCurrentPlaylistVarString( "gamemode_logo", "BATTLE_ROYALE" )) )

	// EmitSoundOnEntity( GetLocalClientPlayer(), GetAnyDialogueAliasFromName( PickCommentaryLineFromBucket_WinterExpressCustom( eSurvivalCommentaryBucket.MATCH_INTRO ) ) )

	file.gameStartRuiCreated = true
}

void function DestroyGameStartRuiForGamestate()
{
	if ( file.gameStartRui != null )
		RuiDestroy( file.gameStartRui )
	file.gameStartRui = null
}

void function OnWaypointCreated( entity wp )
{
	thread SetupObjectiveWaypoint( wp )
}

void function SetupObjectiveWaypoint( entity wp )
{
	if ( !IsValid( wp ) )
		return

	while ( IsValid( wp ) && wp.wp.ruiHud == null )
		WaitFrame()

	if ( !IsValid( wp ) )
		return

	// if ( wp.GetWaypointType() == eWaypoint.OBJECTIVE )
	// {
		// file.trainWaypoint = wp
		// RuiTrackInt( file.trainWaypoint.wp.ruiHud, "roundState", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL_INT, GetNetworkedVariableIndex( "WinterExpress_RoundState" ) )
		// RuiSetBool( file.trainWaypoint.wp.ruiHud, "useWinterExpressColors", true )
	// }
}


void function WinterExpress_OnPlayerLifeStateChanged( entity player, int oldState, int newState )
{
	entity clientPlayer = GetLocalClientPlayer()
	if ( player != clientPlayer || !IsValid( GetLocalClientPlayer() ) || IsWatchingKillReplay() )
		return

	switch( newState )
	{
		case LIFE_ALIVE:
			RunUIScript( "UI_UpdateOpenMenuButtonCallbacks_Spectate", newState, true )
			StopSoundOnEntity( GetLocalClientPlayer(), "Music_LTM32_SpectateCam" )
			break

		case LIFE_DEAD:
			thread WinterExpress_ManageCharacterSelectAvailability_Thread()
			if ( GetGameState() == eGameState.Playing && (file.activeSpectateMusic == null || !IsSoundStillPlaying( file.activeSpectateMusic )))
			{
				file.activeSpectateMusic = EmitSoundOnEntity( GetLocalClientPlayer(), "Music_LTM32_SpectateCam" )
			}
			break
	}
}

// While in a spectator state, manage when the menu buttons are available ( we don't want them available right after death or right before respawn)
void function WinterExpress_ManageCharacterSelectAvailability_Thread()
{
	entity clientPlayer = GetLocalClientPlayer()
	OnThreadEnd(
		function() : ( clientPlayer )
		{
			if ( IsValid( clientPlayer ) )
			{
				RunUIScript( "UI_UpdateOpenMenuButtonCallbacks_Spectate", LIFE_ALIVE, true )
			}
		}
	)

	// no character select during grace period
	float timeUntilSpawn = WinterExpress_GetTimeUntilSpawn()
	float gracePeriod = GetGlobalNetTime( "WinterExpress_TrainArrivalTime" ) - Time()
	bool inGracePeriod = timeUntilSpawn < 0 && gracePeriod > 0
	if ( inGracePeriod )
		wait gracePeriod

	// exit if the player is alive
	if ( IsAlive( clientPlayer ) )
		return

	// no character select 5 seconds before respawn
	timeUntilSpawn = WinterExpress_GetTimeUntilSpawn()
	if ( timeUntilSpawn > 0 && timeUntilSpawn < CHARACTER_SELECT_MIN_TIME )
		return

	RunUIScript( "UI_UpdateOpenMenuButtonCallbacks_Spectate", LIFE_DEAD, false )

	// Now we wait until we get a valid time to spawn
	while ( timeUntilSpawn < 0 )
	{
		if ( IsAlive( clientPlayer ) )
		{
			return
		}
		else
		{
			timeUntilSpawn = WinterExpress_GetTimeUntilSpawn()
			wait 1.0 // don't need to be super accurate, we should have a positive time around the 10 sec mark and don't shut off the buttons until the 5 sec mark
		}
	}

	clientPlayer.EndSignal( "OnDestroy" ) // Have to have this here otherwise the thread ends when the screen switches from player death to spectate causing an interuption if the loadout select screen is open
	// At this point we have a valid time to spawn, so we will wait until we are almost ready to spawn and then we will hide the menu options, deregister the buttons
	wait timeUntilSpawn - CHARACTER_SELECT_MIN_TIME
}

// Get the time until the player is allowed to spawn, get a negative value until around 10 secs to spawn when we actually know when spawn will occur
float function WinterExpress_GetTimeUntilSpawn()
{
	float roundRespawnTime = GetGlobalNetTime( "WinterExpress_RoundRespawnTime" )
	float timeUntilSpawn = roundRespawnTime - Time()
	return timeUntilSpawn
}

void function UICallback_WinterExpress_OpenCharacterSelect()
{
	entity clientPlayer = GetLocalClientPlayer()
	entity viewPlayer = GetLocalViewPlayer()

	//safety so if this gets called outside of the mode due to a button callback, we can cancel the state
	// if ( !GameModeVariant_IsActive( eGameModeVariants.SURVIVAL_WINTEREXPRESS ) )
		// return

	const bool browseMode = true
	const bool showLockedCharacters = true
	HideScoreboard()
	// OpenCharacterSelectMenu( browseMode, showLockedCharacters )
}

bool function WinterExpress_ShouldShowDeathScreen()
{
	return false
}

int function GetTeamRemappedForRui( int rawIndex )
{
	int myTeam = GetLocalViewPlayer().GetTeam()
	if( rawIndex == myTeam )
		return 0

	int i = 1
	foreach ( team in GetAllEnemyTeams( myTeam ) )
	{
		if ( team == rawIndex )
			return i

		i++
	}

	return -1
}


void function ServerCallback_CL_GameStartAnnouncement()
{
	AnnouncementMessageSweepWinterExpress( GetLocalClientPlayer(), Localize( GAME_START_ANNOUNCEMENT ), Localize( GAME_START_ANNOUNCEMENT_SUB ), < 214, 214, 214 >, "WXpress_Train_Update", 7.0, $"", $"", $"", true, false )
}

void function ServerCallback_CL_RoundEnded( int endCondition, int winningTeam, int newScore )
{
	string winningSquad      = ""
	vector announcementColor = <1, 1, 1>

	int uiWinningTeam     = Squads_GetTeamsUIId( winningTeam )
	int squadWinningIndex = -1
	if	(winningTeam >= TEAM_IMC)
	{
		squadWinningIndex  = Squads_GetSquadUIIndex( winningTeam )
	}


	asset borderIcon         = $""
	string soundAlias        = "WXpress_Train_Update"

	if ( squadWinningIndex < 0)
	{
		borderIcon = $""//$"rui/hud/gametype_icons/winter_express/icon_announcement_fail"
	}
	else if ( uiWinningTeam == TEAM_IMC ) // local team won
	{
		winningSquad = Localize( "#PL_YOUR_SQUAD" )
		announcementColor = Squads_GetNonLinearSquadColor( squadWinningIndex )
		borderIcon = $""//$"rui/hud/gametype_icons/winter_express/legend_icon_round_won"
		soundAlias = "WXpress_Train_Capture"
	}
	else  // local team lost 
	{
		int winningSquadRuiIndex = GetTeamRemappedForRui( winningTeam )
		winningSquad = Localize( Squads_GetSquadNameLong( squadWinningIndex ) )
		announcementColor = Squads_GetNonLinearSquadColor( squadWinningIndex )
		borderIcon = $""//winningSquadRuiIndex == 1 ? $"rui/hud/gametype_icons/winter_express/icon_announcement_fail" : $"rui/hud/gametype_icons/winter_express/icon_announcement_fail_alt"
		soundAlias = "WXpress_Train_Capture_Enemy"
	}

	if ( endCondition == eWinterExpressRoundEndCondition.OBJECTIVE_CAPTURED )
	{
		AnnouncementMessageSweepWinterExpress( GetLocalClientPlayer(), Localize( ROUND_END_OBJECTIVE_CAPTURED, winningSquad ), Localize( ROUND_END_OBJECTIVE_CAPTURED_SUB, "`1" + winningSquad + "`0", newScore, Localize( newScore > 1 ? "#PL_ROUND_MULTIPLE" : "#PL_ROUND_SINGULAR" ) ), announcementColor, soundAlias, 5.0, $"", borderIcon, borderIcon, false )
		Obituary_Print_Localized( Localize( ROUND_END_OBJECTIVE_CAPTURED, "`1" + winningSquad + "`0" ), announcementColor )
	}
	else if ( endCondition == eWinterExpressRoundEndCondition.LAST_SQUAD_ALIVE )
	{
		AnnouncementMessageSweepWinterExpress( GetLocalClientPlayer(), Localize( ROUND_END_LAST_SQUAD_ALIVE, winningSquad ), Localize( ROUND_END_LAST_SQUAD_ALIVE_SUB , "`1" + winningSquad + "`0", newScore, Localize( newScore > 1 ? "#PL_ROUND_MULTIPLE" : "#PL_ROUND_SINGULAR" ) ), announcementColor, soundAlias, 5.0, $"", borderIcon, borderIcon, false )
		Obituary_Print_Localized( Localize( ROUND_END_LAST_SQUAD_ALIVE, "`1" + winningSquad + "`0" ), announcementColor )
	}
	else if ( endCondition == eWinterExpressRoundEndCondition.TIMER_EXPIRED )
	{
		AnnouncementMessageSweepWinterExpress( GetLocalClientPlayer(), Localize( ROUND_END_TIMER_EXPIRED ), Localize( ROUND_END_TIMER_EXPIRED_SUB ), announcementColor, soundAlias, 5.0, $"", borderIcon, borderIcon, true )
		Obituary_Print_Localized( Localize( ROUND_END_TIMER_EXPIRED ), announcementColor )
	}
	else if ( endCondition == eWinterExpressRoundEndCondition.OVERTIME_EXPIRED )
	{
		AnnouncementMessageSweepWinterExpress( GetLocalClientPlayer(), Localize( ROUND_END_OVERTIME_EXPIRED ), Localize( ROUND_END_OVERTIME_EXPIRED_SUB ), announcementColor, soundAlias, 5.0, $"", borderIcon, borderIcon, true )
		Obituary_Print_Localized( Localize( ROUND_END_OVERTIME_EXPIRED ), announcementColor )
	}
	else
	{
		AnnouncementMessageSweepWinterExpress( GetLocalClientPlayer(), Localize( ROUND_END_NO_SQUADS ), Localize( ROUND_END_NO_SQUADS_SUB ), announcementColor, soundAlias, 5.0, $"", borderIcon, borderIcon, true )
		Obituary_Print_Localized( Localize( ROUND_END_NO_SQUADS ), announcementColor )
	}

	CL_ScoreUpdate( winningTeam, newScore )
}

void function CL_ScoreUpdate( int team, int score )
{
	int uiTeam     = Squads_GetTeamsUIId( team )
	file.objectiveScore[uiTeam] <- score

	//update match point state
	if ( file.objectiveScore[uiTeam] == file.scoreLimit - 1 )
		file.isTeamOnMatchPoint[uiTeam] <- true

	if ( !(uiTeam in file.scoreElements) )
		return

	// RuiSetInt( file.scoreElements[uiTeam], "score", score )
	// RuiSetInt( file.scoreElementsFullmap[uiTeam], "score", score )
}

int function WinterExpress_GetTeamScore( int uiTeam )
{
	if ( !( uiTeam in file.objectiveScore ) )
		return 0

	return  file.objectiveScore[ uiTeam ]
}

bool function WinterExpress_IsTeamWinning( int uiTeamToCheck )
{
	if ( !( uiTeamToCheck in file.objectiveScore ) )
		return false

	int teamToCheckScore = file.objectiveScore[ uiTeamToCheck ]
	bool isWinning = true

	foreach ( uiTeam, score in file.objectiveScore)
	{
		if ( teamToCheckScore < score )
		{
			isWinning = false
			break
		}
	}

	return isWinning
}

void function OnServerVarChanged_RoundState( entity player, int old, int new, bool actuallyChanged )
{
	if ( GetGameState() != eGameState.Playing )
		return

	printf( "WINTER EXPRESS: server var changed: " + new )

	if ( new == eWinterExpressRoundState.OBJECTIVE_ACTIVE )
		thread DisplayRoundStart()
	else if ( new == eWinterExpressRoundState.CHANGING_STATIONS )
		thread DisplayRoundChanging()
	else if ( new == eWinterExpressRoundState.ABOUT_TO_CHANGE_STATIONS )
		thread DisplayRoundFinished()
	else if ( new == eWinterExpressRoundState.ABOUT_TO_UNLOCK_STATION )
		thread DisplayUnlockDelay()
}

void function DisplayRoundStart()
{
	asset borderIcon = $""//$"rui/hud/gametype_icons/winter_express/objective_gold_left"

	if ( IsWaveRespawn() )
		AnnouncementMessageSweepWinterExpress( GetLocalClientPlayer(), Localize( PL_ROUND_STARTED ), "", < 214, 214, 214 >, "WXpress_Train_Update", 5.0 )
	if ( IsRoundBasedRespawn() )
		AnnouncementMessageSweepWinterExpress( GetLocalClientPlayer(), Localize( PL_ROUND_STARTED ), Localize( PL_ROUND_STARTED_SUB ), < 214, 214, 214 >, "WXpress_Train_Update", 5.0, $"", borderIcon, borderIcon, true, false )
	else
		AnnouncementMessageSweepWinterExpress( GetLocalClientPlayer(), Localize( PL_ROUND_STARTED ), Localize( PL_ROUND_STARTED_SUB ), < 214, 214, 214 >, "WXpress_Train_Update", 5.0, $"", borderIcon, borderIcon, true, false )

	// RuiSetGameTime( ClGameState_GetRui(), "roundStateChangedTime", Time() )
	// RuiSetGameTime( ClGameState_GetRui(), "roundEndTime", GetGlobalNetTime( "WinterExpress_RoundEnd" ) )
	// RuiSetInt( ClGameState_GetRui(), "roundState", eWinterExpressRoundState.OBJECTIVE_ACTIVE )

	// foreach ( team, rui in file.squadOnObjectiveElements )
		// RuiSetInt( rui, "roundState", eWinterExpressRoundState.OBJECTIVE_ACTIVE )
}

void function DisplayRoundFinished()
{
	// RuiSetGameTime( ClGameState_GetRui(), "roundStateChangedTime", Time() )
	// RuiSetInt( ClGameState_GetRui(), "roundState", eWinterExpressRoundState.ABOUT_TO_CHANGE_STATIONS )

	// foreach ( team, rui in file.squadOnObjectiveElements )
		// RuiSetInt( rui, "roundState", eWinterExpressRoundState.ABOUT_TO_CHANGE_STATIONS )
}

void function DisplayRoundChanging()
{
	// RuiSetGameTime( ClGameState_GetRui(), "roundStateChangedTime", Time() )
	// RuiSetInt( ClGameState_GetRui(), "roundState", eWinterExpressRoundState.CHANGING_STATIONS )

	// foreach ( team, rui in file.squadOnObjectiveElements )
		// RuiSetInt( rui, "roundState", eWinterExpressRoundState.CHANGING_STATIONS )

		wait 5.0

	asset borderIcon = $""//$"rui/hud/gametype_icons/winter_express/icon_announcement_changing_stations"
	AnnouncementMessageSweepWinterExpress( GetLocalClientPlayer(), Localize( PL_OBJECTIVE_MOVING ), "", < 214, 214, 214 >, "WXpress_Train_Update", 5.0, $"", borderIcon, borderIcon, true, false )
}

void function DisplayUnlockDelay()
{
	// RuiSetGameTime( ClGameState_GetRui(), "roundStateChangedTime", Time() )
	// RuiSetInt( ClGameState_GetRui(), "roundState", eWinterExpressRoundState.ABOUT_TO_UNLOCK_STATION )

	bool shouldShowMatchPoint
	int uiMatchTeam = -1
	foreach( uiTeam, value in file.isTeamOnMatchPoint )
	{
		if ( uiTeam == TEAM_INVALID )
			continue

		if ( value )
		{
			if ( uiTeam in file.hasTeamGottenMatchPointAnnounce && file.hasTeamGottenMatchPointAnnounce[uiTeam] )
				continue

			shouldShowMatchPoint = true
			file.hasTeamGottenMatchPointAnnounce[uiTeam] <- true
			uiMatchTeam          = uiTeam
			break
		}
	}

	if ( shouldShowMatchPoint )
	{
		int uiSquadIndex  = Squads_GetArrayIndexForTeam( uiMatchTeam )
		string matchSquad = uiSquadIndex == 0 ? "#PL_YOUR_SQUAD" : Localize( Squads_GetSquadNameLong( uiSquadIndex ) )
		matchSquad = "`3" + Localize( matchSquad ) + "`0"

		vector announcementColor = Squads_GetSquadColor( uiSquadIndex )
		AnnouncementMessageRight( GetLocalClientPlayer(), Localize( "#PL_MATCH_POINT", matchSquad ), "", announcementColor, $"", 4, "WXpress_Train_Update_Small", announcementColor )
	}
}

void function OnServerVarChanged_ObjectiveState( entity player, int old, int new, bool actuallyChanged )
{
	FlagSet( "WinterExpress_ObjectiveStateUpdated" )

	printf( "WINTER EXPRESS: Setting your train status to: " + new )
	// RuiSetInt( ClGameState_GetRui(), "yourTrainStatus", new )
	// if ( file.trainWaypoint != null && file.trainWaypoint.wp.ruiHud != null )
		// RuiSetInt( file.trainWaypoint.wp.ruiHud, "yourObjectiveStatus", new )

	// if ( new == eWinterExpressObjectiveState.CONTROLLED )
	// {
		// RuiSetGameTime( ClGameState_GetRui(), "captureEndTime", GetGlobalNetTime( "WinterExpress_CaptureEndTime" ) )
		// RuiSetFloat( ClGameState_GetRui(), "captureTimeRequired", GetCurrentPlaylistVarFloat( "winter_express_cap_time", 10 ) )
	// }
	// else
	// {
		// RuiSetGameTime( ClGameState_GetRui(), "captureEndTime", GetGlobalNetTime( "WinterExpress_CaptureEndTime" ) - Time() )
	// }

	// if ( file.trainWaypoint != null && file.trainWaypoint.wp.ruiHud != null )
	// {
		// if ( new == eWinterExpressObjectiveState.CONTROLLED )
		// {
			// RuiSetGameTime( file.trainWaypoint.wp.ruiHud, "captureEndTime", GetGlobalNetTime( "WinterExpress_CaptureEndTime" ) )
			// RuiSetFloat( file.trainWaypoint.wp.ruiHud, "captureTimeRequired", GetCurrentPlaylistVarFloat( "winter_express_cap_time", 10 ) )
		// }
		// else
		// {
			// RuiSetGameTime( file.trainWaypoint.wp.ruiHud, "captureEndTime", GetGlobalNetTime( "WinterExpress_CaptureEndTime" ) - Time() )
		// }
	// }
}

void function OnServerVarChanged_ObjectiveOwner( entity player, int old, int new, bool actuallyChanged )
{
	FlagSet( "WinterExpress_ObjectiveOwnerUpdated" )

	// entity viewPlayer = GetLocalViewPlayer()
	// if ( !IsValid( viewPlayer ) )
		// return

	// int localTeam  = viewPlayer.GetTeam()
	// int squadIndex = new >=0 ? Squads_GetSquadUIIndex( new ) : 0

	// var gamestateRui = ClGameState_GetRui()
	// if ( gamestateRui == null )
		// return

	// RuiSetInt( gamestateRui, "yourTeamIndex", GetTeamRemappedForRui( localTeam ) )
	// RuiSetInt( gamestateRui, "currentControllingTeam", GetTeamRemappedForRui( new ) )

	// RuiSetString( gamestateRui, "currentControllingTeamName", Squads_GetSquadNameLong( squadIndex ) )
	// RuiSetColorAlpha( gamestateRui, "currentControllingTeamColor", Squads_GetSquadColor( squadIndex ) , 1.0 )

	printf( "WINTER EXPRESS: Setting current controlling team to: " + new )

	// if ( file.trainWaypoint != null && file.trainWaypoint.wp.ruiHud != null )
	// {
		// RuiSetInt( file.trainWaypoint.wp.ruiHud, "yourTeamIndex", GetTeamRemappedForRui( localTeam ) )
		// RuiSetInt( file.trainWaypoint.wp.ruiHud, "currentControllingTeam", GetTeamRemappedForRui( new ) )
		// RuiSetColorAlpha( file.trainWaypoint.wp.ruiHud, "currentControllingTeamColor", Squads_GetSquadColor( squadIndex ) , 1.0 )
	// }
}

void function ClearObjectiveUpdate()
{
	FlagClear( "WinterExpress_ObjectiveStateUpdated" )
	FlagClear( "WinterExpress_ObjectiveOwnerUpdated" )
}

void function OnServerVarChanged_TrainArrival( entity player, float old, float new, bool actuallyChanged )
{
	// RuiSetGameTime( ClGameState_GetRui(), "trainArrivalTime", new )
}

void function OnServerVarChanged_TrainTravelTime( entity player, float old, float new, bool actuallyChanged )
{
	// RuiSetFloat( ClGameState_GetRui(), "trainTravelTime", new )
}

void function OnServerVarChanged_OvertimeChanged( entity player, bool old, bool new, bool actuallyChanged )
{
	if ( new == true )
	{
		asset borderIcon = $""//$"rui/hud/gametype_icons/winter_express/objective_gold_left"
		EmitSoundOnEntity( GetLocalClientPlayer(), "WXpress_Train_Capture_Overtime" )
		AnnouncementMessageSweepWinterExpress( GetLocalClientPlayer(), Localize( "#PL_OVERTIME_OBJECTIVE_CHANGED" ), "", < 214, 214, 214 >, "WXpress_Train_Update", 5.0, $"", borderIcon, borderIcon, true, false )
	}
}

void function ServerCallback_CL_SquadOnObjectiveStateChanged( int team, bool isOnObjective )
{
	// int uiTeam = Squads_GetTeamsUIId( team )
	// RuiSetBool( file.squadOnObjectiveElements[uiTeam], "isSquadOnObjective", isOnObjective )
}

void function ServerCallback_CL_SquadEliminationStateChanged( int team, bool eliminationState )
{
	// int uiTeam = Squads_GetTeamsUIId( team )
	// RuiSetBool( file.squadOnObjectiveElements[uiTeam], "isEliminated", eliminationState )
}

void function ServerCallback_CL_ObjectiveStateChanged( int newState, int team )
{
	if ( GetLocalViewPlayer().GetTeam() == team )
	{
		if ( newState == eWinterExpressObjectiveState.CONTROLLED )
		{
			AnnouncementMessageRight( GetLocalClientPlayer(), Localize( CAPTURED_THE_TRAIN ), "", OBJECTIVE_GREEN, $"", 2, "WXpress_Train_Update_Small" )
		}

		if ( newState == eWinterExpressObjectiveState.UNCONTROLLED )
		{
			AnnouncementMessageRight( GetLocalClientPlayer(), Localize( LOST_THE_TRAIN ), "", OBJECTIVE_RED, $"", 2, "WXpress_Train_Update_Small" )
		}

		if ( newState == eWinterExpressObjectiveState.CONTESTED )
		{
			AnnouncementMessageRight( GetLocalClientPlayer(), Localize( CONTESTING_THE_TRAIN ), "", OBJECTIVE_YELLOW, $"", 2, "WXpress_Train_Update_Small" )
		}

		if ( newState == eWinterExpressObjectiveState.INACTIVE )
		{
			AnnouncementMessageRight( GetLocalClientPlayer(), Localize( PL_OBJECTIVE_LOCKED ), "", < 214, 214, 214 >, $"", 2, "WXpress_Train_Update_Small" )
		}
	}
}

void function ServerCallback_CL_WinnerDetermined( int team )
{
	RunUIScript( "UI_UpdateOpenMenuButtonCallbacks_Spectate", LIFE_ALIVE, true )
	StopSoundOnEntity( GetLocalClientPlayer(), "Music_LTM32_SpectateCam" )
	// SetSummaryDataDisplayStringsCallback( WinterExpress_PopulateSummaryDataStrings )
	CL_ScoreUpdate( team, 3 )
}


void function ServerCallback_CL_RespawnAnnouncement()
{
	AnnouncementMessageSweepWinterExpress( GetLocalClientPlayer(), Localize( "#WINTER_EXPRESS_RESPAWN_MSG" ), "", <255, 255, 255>, "WXpress_Mode_Update_Respawn", 5.0 )
}

void function ServerCallback_CL_ObserverModeSetToTrain()
{
	if ( !IsValid( GetLocalClientPlayer() ) )
		return

	UpdateMainHudVisibility( GetLocalClientPlayer() )
	DeathScreen_SpectatorTargetChanged( GetLocalClientPlayer(), null, null )

	ShowDeathScreen( eDeathScreenPanel.SPECTATE )
	EnableDeathScreenTab( eDeathScreenPanel.SPECTATE, true )
	EnableDeathScreenTab( eDeathScreenPanel.DEATH_RECAP, !IsAlive( GetLocalClientPlayer() ) )
	EnableDeathScreenTab( eDeathScreenPanel.SQUAD_SUMMARY, false )
	SwitchDeathScreenTab( eDeathScreenPanel.SPECTATE )
}


void function AnnouncementMessageSweepWinterExpress( entity player, string messageText, string subText, vector titleColor, string soundAlias, float duration, asset icon = $"", asset leftIcon = $"", asset rightIcon = $"", bool useColorOnText = false, bool useColorOnHeader = true )
{
	AnnouncementData announcement = Announcement_Create( messageText )
	announcement.drawOverScreenFade = true
	Announcement_SetSubText( announcement, subText )
	Announcement_SetHideOnDeath( announcement, true )
	Announcement_SetDuration( announcement, duration )
	Announcement_SetPurge( announcement, true )
	Announcement_SetStyle( announcement, ANNOUNCEMENT_STYLE_SWEEP )
	Announcement_SetSoundAlias( announcement, soundAlias )
	Announcement_SetTitleColor( announcement, titleColor )
	Announcement_SetIcon( announcement, icon )
	Announcement_SetLeftIcon( announcement, leftIcon )
	Announcement_SetRightIcon( announcement, rightIcon )
	//Announcement_SetVerticalOffset( announcement, 50 )
	// Announcement_SetUseColorOnAnnouncementText( announcement, useColorOnHeader )
	// Announcement_SetUseColorOnSubtext( announcement, useColorOnText )
	AnnouncementFromClass( player, announcement )
}

#endif //CLIENT

#if SERVER || CLIENT || UI
float function GetWaveRespawnInterval()
{
	return GetCurrentPlaylistVarFloat( "winter_express_wave_respawn_interval", 10 )
}

bool function IsWaveRespawn()
{
	// Assert ( !GetCurrentPlaylistVarBool( "winter_express_wave_respawn", false ) || (GetCurrentPlaylistVarBool( "winter_express_wave_respawn", false ) && GetWaveRespawnInterval() > 0) )

	return GetCurrentPlaylistVarBool( "winter_express_wave_respawn", true )
}

bool function IsRoundBasedRespawn()
{
	return GetCurrentPlaylistVarBool( "winter_express_round_based_respawn", false )
}
#endif //SERVER || CLIENT || UI




////////////////////////////////////////////////
///// Functions for Spectate functionality /////
////////////////////////////////////////////////

#if SERVER
entity function GetBestObserverTarget_WinterExpress( entity observer, bool reverse )
{
	if ( observer.GetTeam() == TEAM_SPECTATOR )
		return null

	if ( IsTeamEliminated( observer.GetTeam() )  )
	{
		foreach (member in GetPlayerArrayOfTeam(observer.GetTeam()))
		{
			member.SetPlayerNetInt( "spectatorTargetCount", 1 )
			thread TryPutPlayerInTrainObserverMode( member )
		}
		return null
	}

	return PickBestObserverTarget_WinterExpress( observer, (reverse ? -1 : 1) )
}

entity function PickBestObserverTarget_WinterExpress( entity player, int cycleDirection = 0 )
{
	entity observerTarget            = player.GetObserverTarget()
	array<entity> observeablePlayers = GetPlayerArrayOfTeam_Alive( player.GetTeam() )

	if ( observeablePlayers.len() != 0 )
	{
		return PickBestPlayerOnteamToObserve( observeablePlayers, player, cycleDirection )
	}

	return null
}

void function SetupSpectateCameras()
{
	file.spectateCameraLocations = [ <11063.123, 5142.43457, -3833.6084>, // capitol station
									<11066.5996, 8514.27734, -3917.91846>, // capitol to valley
									<19626.5586, 12304.6553, -3830.88745>, // valley station
									<22468.0625, 16443.9004, -4333.00684>, // valley to refinery
									<19743.2715, 26162.7656, -4725.04541>, // refinery station
									<15360.8145, 33049.1133, -4255.99756>, // refinery to derail
									<-386.579102, 33094.2461, -2151.74902>, //derail
									<-749.786316, 32684.7363, -2427.51611>, //derail to waystation
									<-1652.09351, 20061.5684, -2706.43774>, //waystation
									<-1820.6311, 14971.9365, -3430.10864> ] // waystation to capitol

	file.spectateCameraAngles = [ <7.938097, 41.2921753, 0>, // capitol station
								<-14.5343828, -57.8916283, 0>, // capitol to valley
								<20.8208523, 60.3704262, 0>, // valley station
								<6.74402618, -150.326569, 0>, // valley to refinery
								<8.94840813, 89.0634384, 0>, // refinery station
								<-2.75115943, -67.5009537, 0>, // refinery to derail
								<28.9231777, -20.6929264, 0>, //derail
								<17.1399822, -58.3305016, 0>, //derail to waystation
								<19.5338459, -39.83601, 0>, // waystation
								<-3.43757153, 83.4900208, 0> ] // waystation to capitol
}

int function GetClosestCameraToTrain()
{
	int closestIndex      = 0
	float closestDistance = 1000000000
	for ( int i = 0; i < file.spectateCameraLocations.len(); i++ )
	{
		float distance = Distance( file.spectateCameraLocations[i], file.trainRef.GetOrigin() )
		if ( distance < closestDistance && i % 2 == 0 )
		{
			closestIndex = i
			closestDistance = distance
		}
	}

	return closestIndex
}

int function GoToNextCamera()
{
	int nextIndex = file.currentSpectateCamera + 1
	if ( nextIndex >= file.spectateCameraLocations.len() )
		nextIndex = 0

	return nextIndex
}

void function SetCurrentSpectateCameraClosestToTrain()
{
	int cameraIndex = GetClosestCameraToTrain()
	file.currentSpectateCamera = cameraIndex

	// DumpStack()
	thread SendDeadPlayersToSpectateCamera( file.currentSpectateCamera )
}

void function SetCurrentSpectateCameraToNextIndex()
{
	int cameraIndex = GoToNextCamera()
	file.currentSpectateCamera = cameraIndex

	// DumpStack()
	thread SendDeadPlayersToSpectateCamera( file.currentSpectateCamera )
}

void function SendDeadPlayersToSpectateCamera( int index )
{
	WaitFrame()

	printf( "Winter Express: Sending dead players to camera " + index )

	foreach ( player in file.deadPlayers )
	{
		if ( !IsValid( player ) )
			continue

		if ( !IsTeamEliminated( player.GetTeam() ) )
			continue

		printf( "Winter express: Player " + player.GetPlayerName() + " is dead without living teammates. Sending to new camera" )

		player.ClearParent()
		PutPlayerInObserverModeWithOriginAngles( player, OBS_MODE_STATIC_LOCKED, file.spectateCameraLocations[file.currentSpectateCamera], file.spectateCameraAngles[file.currentSpectateCamera] )
		player.SetPhysics( MOVETYPE_OBSERVER )

		// AddCinematicFlag( player, CE_FLAG_HIDE_MAIN_HUD_INSTANT )
		// AddCinematicFlag( player, CE_FLAG_HIDE_PERMANENT_HUD )

		Remote_CallFunction_NonReplay( player, "ServerCallback_CL_ObserverModeSetToTrain" )
	}
}
#endif

#if CLIENT
VictorySoundPackage function GetVictorySoundPackage()
{
	VictorySoundPackage victorySoundPackage

	string winAlias = ""
	if ( WinterExpress_IsNarrowWin() )
	{
		winAlias = GetAnyDialogueAliasFromName( PickCommentaryLineFromBucket( eSurvivalCommentaryBucket.NARROW_WINNER ) )
	}
	else
	{
		winAlias = GetAnyDialogueAliasFromName( PickCommentaryLineFromBucket( eSurvivalCommentaryBucket.WIDE_WINNER ) )
	}

	victorySoundPackage.youAreChampPlural = winAlias
	victorySoundPackage.youAreChampSingular = winAlias
	victorySoundPackage.theyAreChampPlural = winAlias
	victorySoundPackage.theyAreChampSingular = winAlias

	return victorySoundPackage
}
#endif



















///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////// HOLIDAY HOVER TANK SHIT ////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#if SERVER
void function OnPlayerConnected( entity player )
{
	thread SetupPlayerThread( player )
}

void function SetupPlayerThread( entity player )
{
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )

	while ( !IsValidPlayer(player) || !IsAlive(player) || GetGameState() != eGameState.Playing )
		WaitFrame()

	if ( player.p.hasStagingAreaDamageProtection )
	{
		// RemoveEntityCallback_OnDamaged( player, StagingAreaPlayerTookDamageCallback )
		player.p.hasStagingAreaDamageProtection = false
	}

	ClearPlayerIntroDropSettings( player )

	if ( GetCurrentPlaylistVarBool( "infinite_heal_items", false ) )
		GivePassive( player, ePassives.PAS_INFINITE_HEAL )

	if ( player.GetTeam() == file.lastValidTeamToScore )
		WinterExpress_RespawnOnTrain( player, true )
	else
		WinterExpress_RespawnHoverTank( player, true )

	thread Flowstate_GivePlayerLoadoutOnGameStart_Copy( player, false )
}

void function SpawnHoverTanks()
{
	if ( GetEntArrayByScriptName( "_hover_tank_mover" ).len() == 0 )
		return

	array<string> spawners = [ "HoverTank_holiday", "HoverTank_holiday02" ]

	foreach( int i, string spawnerName in spawners )
	{
		string pathGroup = "all"
		if ( spawnerName == "HoverTank_holiday" )
			pathGroup = "red_group"
		else if ( spawnerName == "HoverTank_holiday02" )
			pathGroup = "blue_group"

		HoverTank hoverTank = SpawnHoverTank_Cheap( spawnerName, pathGroup )
		hoverTank.playerRiding = true

		printt( "HOVER TANKS HOLIDAY SPAWNER:", spawnerName )
		file.hoverTanks.append( hoverTank )
		file.hoverTankToNodeGroup[ hoverTank ] <- pathGroup
	}
}


void function SetupHolidayHoverTank_OnGameStartedPlaying()
{
	//spawn hovertanks on waypoint closest to next train station
	entity stationNode = DesertlandsTrain_GetNextStationNode()

	foreach( tank in file.hoverTanks )
	{
		entity spawnNode = HolidayHoverTank_GetClosestStationNodeToPosition( file.hoverTankToNodeGroup[tank], stationNode.GetOrigin() )
		SetupHovertankForFlight( tank, spawnNode )
	}

	HoverTank_AddCallback_OnPlayerExitedVolume( PutPlayerIntoSkydiveWhenLeavingHovertank )
	HoverTank_AddCallback_OnPlayerEnteredVolume( DisablePlayerWeaponsAndAbilities )
	printt( "SetupHolidayHoverTank_OnGameStartedPlaying" )
}

void function SetupHovertankForFlight( HoverTank hoverTank, entity startNode )
{
	CreateHoverTankMinimapIconForPlayers( hoverTank )
	HoverTankTeleportToPosition( hoverTank, startNode.GetOrigin(), startNode.GetAngles() )
	//HoverTankTeleportToPosition( hoverTank, <0,0,0>, <0,0,0> )

	thread HoverTankAdjustSpeed( hoverTank )
	thread HoverTankForceBoost( hoverTank )
}


void function HoverTankAdjustSpeed( HoverTank hoverTank )
{
	EndSignal( hoverTank, "OnDestroy" )

	float startSlowTime = Time() + 10.0
	float decelEndTime = startSlowTime + 20.0
	float startSpeed = 1200.0
	float endSpeed = 300.0

	HoverTankSetCustomFlySpeed( hoverTank, startSpeed )

	while ( Time() < decelEndTime )
	{

		float speed = GraphCapped( Time(), startSlowTime, decelEndTime, startSpeed, endSpeed )
		HoverTankSetCustomFlySpeed( hoverTank, speed )
		WaitFrame()
	}

	HoverTankSetCustomFlySpeed( hoverTank, endSpeed )
}


void function HoverTankForceBoost( HoverTank hoverTank )
{
	EndSignal( hoverTank, "OnDestroy" )
	EndSignal( hoverTank, "PathFinished" )

	while ( true )
	{
		HoverTankEngineBoost( hoverTank )
		wait RandomFloatRange( 1.0 , 5.0 )
	}
}


void function CreateHoverTankMinimapIconForPlayers( HoverTank hoverTank )
{
	vector hoverTankOrigin = hoverTank.interiorModel.GetOrigin()
	entity minimapObj = CreatePropScript( $"mdl/dev/empty_model.rmdl", hoverTankOrigin )
	minimapObj.Minimap_SetCustomState( eMinimapObject_prop_script.HOVERTANK )		// Minimap icon
	minimapObj.SetParent( hoverTank.interiorModel )
	minimapObj.SetLocalAngles( < 0, 0, 0 > )
	minimapObj.Minimap_SetZOrder( MINIMAP_Z_OBJECT + 10 ) // +10 to make it show up above the endpoint marker below
	SetTeam( minimapObj, TEAM_UNASSIGNED )
	SetTargetName( minimapObj, "hovertank" )		// Full map icon

	minimapObj.Minimap_AlwaysShow( TEAM_UNASSIGNED, null )
}


void function HolidayHoverTank_FlyToNextStation( HoverTank tank )
{
	vector currentStation = GetClosestStation( file.trainRef.GetOrigin() )
	int currentStationIdx = file.stationArray.find( currentStation )

	int nextStationIdx = currentStationIdx + 1
	if ( nextStationIdx >= file.stationArray.len() )
		nextStationIdx = 0

	entity stationTankNode = HolidayHoverTank_GetClosestStationNodeToPosition( file.hoverTankToNodeGroup[tank], file.stationArray[nextStationIdx] )
	thread HolidayHoverTank_FlyToNode( tank, stationTankNode )
}


void function HolidayHoverTank_FlyToNode( HoverTank tank, entity node )
{
	waitthread HoverTankFlyToNode( tank, node, true )
}


entity function HolidayHoverTank_GetClosestStationNodeToPosition( string nodeGroup, vector position )
{
	array<entity> hovertankNodes = GetAllHovertankNodes()
	array<entity> groupNodes

	foreach( node in hovertankNodes )
	{
		if ( node.HasKey( "script_group" ) )
		{
			if ( node.GetValueForKey( "script_group" ) == nodeGroup )
				groupNodes.append( node )
		}
	}

	array<entity> stationNodesInGroup

	foreach( node in groupNodes )
	{
		if ( node.HasKey( "script_name" ) )
		{
			if ( node.GetValueForKey( "script_name" ) == "hovertank_station" )
				stationNodesInGroup.append( node )
		}
	}

	entity closestNode = stationNodesInGroup[0]
	foreach( node in stationNodesInGroup )
	{
		if ( Distance( position, node.GetOrigin() ) < Distance( position, closestNode.GetOrigin() ) )
			closestNode = node
	}

	return closestNode
}


void function DisablePlayerWeaponsAndAbilities( entity player )
{
	printf( "WINTER EXPRESS: Player entering hovertank" )
	if ( !file.playersOnHovertank.contains( player ) )
		file.playersOnHovertank.append( player )
	thread DelayedDisablePlayerWeaponsAndAbilities( player, PlayerMatchState_GetFor( player ) == ePlayerMatchState.SKYDIVE_FALLING )
}

void function DelayedDisablePlayerWeaponsAndAbilities( entity player, bool shouldWaitForNormalState = false )
{
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "WinterExpress_LeftDropship" )

	// player.DisableWeaponTypes( WPT_ALL_EXCEPT_VIEWHANDS_OR_INCAP )

	// Wait for skydive to finish (in the rare case we enter the hovership's airspace while in a skydive)
	while ( PlayerMatchState_GetFor( player ) != ePlayerMatchState.NORMAL || player.p.hasDropSettings == true )
		WaitFrame()

	// *** Intentionally won't run the rest of this if the thread is ended, to handle the case that DelayedPutPlayerIntoSkydiveFromHovertank() fires first because we were waiting for skydive to finish ***
	printf( "WINTER EXPRESS: hover tank contains player" + file.playersOnHovertank.contains( player ) )
	if ( IsValid( player ) && file.playersOnHovertank.contains( player ) )
	{
		player.SetAimAssistAllowed( false )
		Survival_SetInventoryEnabled( player, false )
		player.SetInvulnerable()
		// SetPlayerCanGroundEmote( player, false )

		wait 14.0 // approximate time for the camera cut to the hovertank
		// Allow players to open the Legend Select Menu while on the Hovertank
		if ( IsValid( player ) && file.playersOnHovertank.contains( player ) )
		{
			//  TODO: Reenable this when hovertank respawn stuff is fixed
			player.SetPlayerNetBool( "WinterExpress_IsPlayerAllowedLegendChange", true )
			Remote_CallFunction_NonReplay( player, "ServerCallback_CL_UpdateOpenMenuButtonCallbacks_Gameplay", true )
		}
	}
}

void function PutPlayerIntoSkydiveWhenLeavingHovertank( entity player )
{
	printf( "WINTER EXPRESS: Player leaving hovertank" )
	if ( file.playersOnHovertank.contains( player ) )
		file.playersOnHovertank.fastremovebyvalue( player )
	thread DelayedPutPlayerIntoSkydiveFromHovertank( player )
}

void function DelayedPutPlayerIntoSkydiveFromHovertank( entity player )
{
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )

	OnThreadEnd(
		function() : ( player )
		{
			if ( IsValid( player ) )
			{
				player.Signal( "WinterExpress_LeftDropship" )
				player.ClearInvulnerable()
				Survival_SetInventoryEnabled( player, true )
				player.SetAimAssistAllowed( true )
				// player.EnableWeaponTypes( WPT_ALL_EXCEPT_VIEWHANDS_OR_INCAP )
				player.SetActiveWeaponBySlot( eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_0 )
				//player.DeployWeapon()
				PlayerMatchState_Set( player, ePlayerMatchState.SKYDIVE_FALLING )

				if ( GetCurrentPlaylistVarBool( "infinite_heal_items", false ) )
					GivePassive( player, ePassives.PAS_INFINITE_HEAL )

				// Remove the option to open the Legend Selection Menu when players leave the Hover Tank
				Remote_CallFunction_NonReplay( player, "ServerCallback_CL_UpdateOpenMenuButtonCallbacks_Gameplay", false )

				thread PlayerSkydiveFromCurrentPosition( player )
			}
		}
	)

	entity closestHoverTank = GetClosestHovertankEnt_ToPlayer( player )
	while ( closestHoverTank.GetOrigin().z - player.GetOrigin().z < 500 )
		WaitFrame()
}

entity function GetClosestHovertankEnt_ToPlayer( entity player )
{
	//get closest hovertank
	entity closestHovertank = HolidayHoverTank_GetHovertankEnt( 0 )
	for( int i = 1; i < file.hoverTanks.len(); i++ )
	{
		entity hoverTankEnt = HolidayHoverTank_GetHovertankEnt( i )
		if ( Distance( hoverTankEnt.GetOrigin(), player.GetOrigin() ) < Distance( closestHovertank.GetOrigin(), player.GetOrigin() ) )
			closestHovertank = hoverTankEnt
	}

	return closestHovertank
}

entity function HolidayHoverTank_GetHovertankEnt( int index )
{
	if ( file.hoverTanks.len() == 0 )
		return null

	return file.hoverTanks[index].flightMover
}
#endif


#if CLIENT

// void function WinterExpress_PopulateSummaryDataStrings( SquadSummaryPlayerData data )
// {
	// data.modeSpecificSummaryData[0].displayString = "#DEATH_SCREEN_SUMMARY_KILLS"
	// data.modeSpecificSummaryData[1].displayString = "#DEATH_SCREEN_SUMMARY_ASSISTS"
	// data.modeSpecificSummaryData[2].displayString = ""
	// data.modeSpecificSummaryData[3].displayString = "#DEATH_SCREEN_SUMMARY_DAMAGE_DEALT"
	// data.modeSpecificSummaryData[4].displayString = ""
	// data.modeSpecificSummaryData[5].displayString = ""
	// data.modeSpecificSummaryData[6].displayString = ""
// }

#endif

#if CLIENT
//Cafe was here
void function OnServerVarChanged_CaptureEndTime( entity player, float old, float new, bool actuallyChanged )
{
	printt( "OnServerVarChanged_CaptureEndTime", old, new )

	float capTime            = GetCurrentPlaylistVarFloat( "winter_express_cap_time", 10 )
	float timeLeftToCapture  = new - Time()
	float percentageCaptured = (capTime - timeLeftToCapture) / capTime
	float starttime = Time() - ( capTime * percentageCaptured )

	FS_CaptureProgressUI( starttime, new )
}

void function FS_CaptureProgressUI( float starttime, float endtime )
{
	if( endtime == -1 && file.customCaptureProgressRui != null )
	{
		RuiDestroyIfAlive( file.customCaptureProgressRui )
		file.customCaptureProgressRui = null
		
		if( endtime == -1 )
			return
	}

	if( file.customCaptureProgressRui != null  )
	{
		RuiSetGameTime( file.customCaptureProgressRui, "startTime", starttime )
		RuiSetGameTime( file.customCaptureProgressRui, "endTime", endtime )
		return
	}

	file.customCaptureProgressRui = CreateCockpitRui( $"ui/health_use_progress.rpak" )
	RuiSetBool( file.customCaptureProgressRui, "isVisible", true )
	RuiSetImage( file.customCaptureProgressRui, "icon", $"rui/hud/gametype_icons/sur_train_minimap" )
	RuiSetGameTime( file.customCaptureProgressRui, "startTime", starttime )
	RuiSetGameTime( file.customCaptureProgressRui, "endTime", endtime )
	RuiSetString( file.customCaptureProgressRui, "hintKeyboardMouse", "Train is being captured" )
	RuiSetString( file.customCaptureProgressRui, "hintController", "Train is being captured" )	
}

void function ServerCallback_CL_CameraLerpFromStationToHoverTank( entity player, entity stationNode, entity hoverTankMover, entity trainMover, bool isGameStartLerp )
{
	vector stationLookPosition = stationNode.GetOrigin() + <1500, 1500, 2000>
	vector stationLookAngles = VectorToAngles( stationNode.GetOrigin() - stationLookPosition )

	float randomVal1 = RandomFloatRange( -750.0, -500.0 )
	float randomVal2 = RandomFloatRange( 500.0, 750.0 )

	vector playerLookAtOpt1 = player.GetOrigin() + < randomVal1, randomVal2, 650>
	vector playerLookAtOpt2 = player.GetOrigin() + < -1 * randomVal1, randomVal2, 650>
	vector playerLookAtOpt3 = player.GetOrigin() + < randomVal1, -1 * randomVal2, 650>
	vector playerLookAtOpt4 = player.GetOrigin() + < -1 * randomVal1, -1 * randomVal2, 650>

	array<vector> lookAtOptions
	lookAtOptions.append( playerLookAtOpt1 )
	lookAtOptions.append( playerLookAtOpt2 )
	lookAtOptions.append( playerLookAtOpt3 )
	lookAtOptions.append( playerLookAtOpt4 )

	vector closestLookAt = lookAtOptions[0]
	foreach( opt in lookAtOptions )
	{
		if ( Distance( stationLookPosition, opt ) < Distance( stationLookPosition, closestLookAt ) )
			closestLookAt = opt
	}

	vector playerLookAngles = VectorToAngles( player.GetOrigin() - closestLookAt )

	thread CameraLerpHovertankThread( player, stationLookPosition, stationLookAngles, closestLookAt, playerLookAngles, hoverTankMover, trainMover, isGameStartLerp )
}

void function CameraLerpHovertankThread( entity player, vector stationPos, vector stationAng, vector endPos, vector endAng, entity hoverTankMover, entity trainMover, bool isGameStartLerp )
{
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )

	vector startPos = trainMover.GetOrigin() + <1500, 1500, 1500>
	vector startAng = VectorToAngles( trainMover.GetOrigin() - startPos )

	entity cameraMover = CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", startPos, startAng )
	entity camera      = CreateClientSidePointCamera( startPos, startAng, 100 )
	player.SetMenuCameraEntity( camera )
	// player.SetMenuCameraBloomAmountOverride( GetMapBloomSettings().winterExpress )
	camera.SetTargetFOV( 100, true, EASING_CUBIC_INOUT, 0.0 )
	camera.SetParent( cameraMover, "", false )

	OnThreadEnd(
		function() : ( player, camera, cameraMover )
		{
			if ( IsValid( camera ) )
			{
				if ( IsValid( player ) )
					player.ClearMenuCameraEntity()
				camera.Destroy()
				cameraMover.Destroy()
			}
		}
	)

	wait 1.5

	if ( isGameStartLerp )
	{
		player.SetMenuCameraEntity( camera )
		// player.SetMenuCameraBloomAmountOverride( GetMapBloomSettings().winterExpress )
		wait 1.5
	}

	if ( RandomInt( 100 ) > 97 )
		EmitSoundOnEntity( GetLocalClientPlayer(), GetAnyDialogueAliasFromName( PickCommentaryLineFromBucket_WinterExpressCustom( eSurvivalCommentaryBucket.PHONE_LOST ) ) )

	float camera_move_duration = 8
	vector predictedEndLocation = endPos + ( hoverTankMover.GetVelocity() * ( camera_move_duration * 2.5 )  )
	vector predictedEndAng = VectorToAngles( player.GetOrigin() - predictedEndLocation )

	cameraMover.NonPhysicsMoveTo( stationPos, camera_move_duration / 2.0, camera_move_duration / 4.0, camera_move_duration / 4.0 )
	cameraMover.NonPhysicsRotateTo( stationAng, camera_move_duration / 2.0, camera_move_duration / 4.0, camera_move_duration / 4.0 )

	wait camera_move_duration / 2.0
	wait 1.5

	cameraMover.NonPhysicsMoveTo( predictedEndLocation, camera_move_duration / 2.0, camera_move_duration / 4.0, camera_move_duration / 4.0 )
	cameraMover.NonPhysicsRotateTo( predictedEndAng, camera_move_duration / 2.0, camera_move_duration / 4.0, camera_move_duration / 4.0 )
	camera.SetTargetFOV( 100, true, EASING_CUBIC_INOUT, camera_move_duration / 2.0 )

	wait (camera_move_duration / 2.0) + 1.5

	wait 0.5

	float maxDistance = Distance( cameraMover.GetOrigin(), player.GetOrigin() )
	while ( Distance( cameraMover.GetOrigin(), player.GetOrigin() ) > 100 )
	{
		float currDistance = Distance( cameraMover.GetOrigin(), player.GetOrigin() )
		float percToLerp = ( maxDistance - ( currDistance * 0.8 ) ) / maxDistance

		vector endLocation = LerpVector( cameraMover.GetOrigin(), player.EyePosition(), percToLerp )
		vector endAngles = ClampAngles( LerpVector( cameraMover.GetAngles(), player.EyeAngles(), percToLerp ) )

		cameraMover.NonPhysicsMoveTo( endLocation, 0.15, 0.0, 0.0 )
		cameraMover.NonPhysicsRotateTo( endAngles, 0.15, 0.0, 0.0 )

		wait 0.15
	}
}

void function ServerCallback_CL_CameraLerpTrain(  entity player, vector estimatedCameraStart, entity trainMover, bool isGameStartLerp  )
{
	thread CameraLerpTrainThread( player, estimatedCameraStart, trainMover, isGameStartLerp )
}

void function CameraLerpTrainThread( entity player, vector estimatedCameraStart, entity trainMover, bool isGameStartLerp )
{
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )

	vector startAng = VectorToAngles( trainMover.GetOrigin() - estimatedCameraStart )

	entity cameraMover = CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", estimatedCameraStart, startAng )
	entity camera      = CreateClientSidePointCamera( estimatedCameraStart, startAng, 100 )
	player.SetMenuCameraEntity( camera )
	// player.SetMenuCameraBloomAmountOverride( GetMapBloomSettings().winterExpress )
	camera.SetTargetFOV( 100, true, EASING_CUBIC_INOUT, 0.0 )
	camera.SetParent( cameraMover, "", false )

	OnThreadEnd(
		function() : ( player, camera, cameraMover )
		{
			if ( IsValid( camera ) )
			{
				if ( IsValid( player ) )
					player.ClearMenuCameraEntity()
				camera.Destroy()
				cameraMover.Destroy()
			}
		}
	)

	wait 1.5

	if ( isGameStartLerp )
	{
		player.SetMenuCameraEntity( camera )
		// player.SetMenuCameraBloomAmountOverride( GetMapBloomSettings().winterExpress )
		wait 1.5
	}

	if ( RandomInt( 100 ) > 97 )
		EmitSoundOnEntity( GetLocalClientPlayer(), GetAnyDialogueAliasFromName( PickCommentaryLineFromBucket_WinterExpressCustom( eSurvivalCommentaryBucket.PHONE_LOST ) ) )


	wait 1
}

#endif