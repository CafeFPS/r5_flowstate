#if CLIENT
global function DesertlandsTrainAnnouncer_Init
global function ServerCallback_SetDesertlandsTrainAtStation
global function SCB_DLandsTrain_SetCustomSpeakerIdx
#endif

#if SERVER || CLIENT
global function IsDesertlandsTrainAtStation
global function DesertlandsTrain_PreMapInit
#endif


#if SERVER
global function DesertlandsTrain_Precaches
global function DesertlandsTrain_Init
global function DesertlandsTrain_SetDriverState
global function DesertlandsTrain_InitMovement
global function TrainAnnouncer_PlaySingle
global function DesertlandsTrain_SetTrainDialogueAliasEnabled

global function DesertlandsTrain_SetMaxSpeed
global function DesertlandsTrain_SetAcceleration
global function DesertlandsTrain_SetWaitDuration
global function DesertlandsTrain_SetAboutToLeaveBuffer
global function DesertlandsTrain_SetAdditionalLeaveBuffer
global function DesertlandsTrain_GetAboutToLeaveBuffer
global function DesertlandsTrain_GetAdditionalLeaveBuffer


global function DesertlandsTrain_AddCallback_TrainArrivedAtStation
global function DesertlandsTrain_AddCallback_TrainAboutToLeaveStation
global function DesertlandsTrain_AddCallback_TrainLeavingFromStation
global function DesertlandsTrain_AddCallback_TrainAboutToArriveAtStation

global function DesertlandsTrain_GetTrainState
global function DesertlandsTrain_GetTrainOrigin
global function DesertlandsTrain_GetNextStationNode
global function DesertlandsTrain_GetCurrentPathNodes
global function DesertlandsTrain_GetTrain
global function DesertlandsTrain_GetStationNodes

global function DesertlandsTrain_ForceTrainLeaveStation

global function DesertlandsTrain_ClearAllowLeaveStation
global function DesertlandsTrain_SetAllowLeaveStation
global function DesertlandsTrain_GetTrainCarData

global function DesertlandsTrain_IsPlayerOnTrain
global function DesertlandsTrain_IsTeamOnTrain

#if DEVELOPER
global function DesertlandsTrain_SetStartStation
global function DesertlandsTrain_DisableSpotlight
global function DesertlandsTrain_ShowPath
#endif // DEVELOPER

#endif // SERVER

#if SERVER || CLIENT
global const string TRAIN_MOVER_NAME = "desertlands_train_mover"
const int TRAIN_CAR_COUNT = 6
#endif

#if SERVER
const string TRAIN_AT_STATION_SERVER_CALLBACK = "ServerCallback_SetDesertlandsTrainAtStation"
const string DESERTLANDS_TRAIN_LOOT_TABLE = "Desertlands_Train"

const string TRACK_CLASSNAME = "script_mover_train_node"
const string TRACK_SPLIT_INWARD_NAME = "train_track_node_split_inward"
const string TRACK_SPLIT_OUTWARD_NAME = "train_track_node_split_outward"
const string TRACK_SPLIT_ANNOUNCE_NAME = "train_track_node_pre_junction"
const string TRACK_SPLIT_NEW_START_NAME = "train_track_node_split_new_start"
const string TRACK_STATION_NAME = "train_track_node_station"
const string TRACK_BIN_MOVER_NAME = "train_station_bin_mover"
const string TRACK_BIN_DOORS_MODEL_NAME = "station_loot_bin_doors_model"
const string TRACK_BIN_TRIGGER_NAME = "station_loot_bin_trigger"
const string HELPER_SPLIT_NAME = "train_track_helper_junction"
const string HELPER_STATION_NAME = "train_track_helper_station"

const string SIGNAL_TRAIN_DECELERATING = "OnTrainStopping" // comes from code
const string SIGNAL_TRAIN_COMPLETELY_STOPPED = "OnTrainStopped" // comes from code
const string SIGNAL_TRAIN_ANNOUNCING = "TrainAnnouncerPlaying"
const string SIGNAL_TRAIN_START_FORWARD = "OnTrainMovingForward"
const string SIGNAL_TRAIN_SPOTLIGHT_BLINKING = "OnTrainSpotlightBlink"

const asset FX_TRAIN_MAIN_SPOTLIGHT = $"P_ar_loot_train_far"
const asset FX_TRAIN_SPOTLIGHT_BLINK = $"P_ar_loot_train_far_blink"

const string SFX_TRAIN_HORN = "Vehicles_Train_Horn"
const string SFX_TRAIN_ACCELERATE = "vehicles_train_start_accelerate"
const string SFX_TRAIN_DECELERATE = "vehicles_train_braking"
const string SFX_TRAIN_ENGINE_STOP = "vehicles_Train_Engine_Stop"
const string SFX_TRAIN_EMERGENCY_BRAKE_ACTIVATE = "Survival_Train_EmergencyPanel_Activate"
const string SFX_TRAIN_EMERGENCY_BRAKE_DEACTIVATE = "Survival_Train_EmergencyPanel_Activate"
const string SFX_TRAIN_STOP_PANEL_DENY = "Survival_Train_EmergencyPanel_Deny"
const string SFX_STATION_BIN_RAISE = "LootBin_TrainStation_Raise"
const string SFX_STATION_BIN_LOWER = "LootBin_TrainStation_Lower"

// keep TRAIN_MAX_SPEED divisible by TRAIN_ACCEL for clean durations usable by audio
const float TRAIN_MAX_SPEED = 608.0
const float TRAIN_ACCEL = 16.0
const float TRAIN_STATION_WAIT_DURATION = 30.0
const float TRAIN_STATION_ABOUT_TO_LEAVE_BUFFER = 5.0
const float TRAIN_BUFFER_ABLE_TO_MANUALLY_DECELERATE = 15.0
const float TIME_BEFORE_FULL_STOP_TO_PLAY_DECEL_SOUND = 15.0
const float TIME_BEFORE_FULL_STOP_TO_PLAY_STOP_SOUND = 3.0

const float STATION_LOOT_MOVETO_DURATION = 7.0

const bool PRINT_TRAIN_DEBUG = false
#endif // SERVER


// =================================================================================================================================
// =================================================================================================================================
// =================================================================================================================================
// =================================================================================================================================
//
//   ######  ######## ########  ##     ##  ######  ########  ######
//  ##    ##    ##    ##     ## ##     ## ##    ##    ##    ##    ##
//  ##          ##    ##     ## ##     ## ##          ##    ##
//   ######     ##    ########  ##     ## ##          ##     ######
//        ##    ##    ##   ##   ##     ## ##          ##          ##
//  ##    ##    ##    ##    ##  ##     ## ##    ##    ##    ##    ##
//   ######     ##    ##     ##  #######   ######     ##     ######
//
// =================================================================================================================================
// =================================================================================================================================
// =================================================================================================================================
// =================================================================================================================================


#if SERVER
global struct TrainCarData
{
	entity brush
	entity mover
	entity spotlightFX
	vector offsetSpotlight
	entity stopPanel
}


struct stationLootBinData
{
	entity mover
	entity brush
	entity binModel
	entity doorsModel
	entity trigger
	vector moverStartOrigin
}


global enum eTrainDriverGoals
{
	RANDOM_STATION,
	CHASE_CIRCLE,

	_COUNT
}


global enum eTrainStates
{
	START_FORWARD,
	START_FORWARD_CURRENT_PATH,
	ABLE_TO_MANUALLY_DECELERATE,
	DECELERATE,
	STOPPED_AT_UNKNOWN_SPOT,
	STOPPED_AT_STATION,
	ABOUT_TO_LEAVE_STATION,

	_COUNT
}
#endif // SERVER

struct
{
	#if SERVER
		entity              train
		array<TrainCarData> trainDatas

		bool manualDeceleratingEnabled

		array<entity>                              stationNodes
		table< entity, array<entity> >             junctionNodeGroups
		table< entity, array<stationLootBinData> > stationNodeBinGroups

		array<entity> currentPathNodes
		int           trainDriverState
		int           trainCurrentState
		bool          emergencyStopEngaged = false

		#if DEVELOPER
			entity devStartingStationNode
			bool   devDisableTrainSpotlight = false
			bool   devShowTrainPath = false
		#endif

		float true_trainMaxSpeed = TRAIN_MAX_SPEED
		float true_trainAccel = TRAIN_ACCEL
		float true_trainStationWaitDuration = TRAIN_STATION_WAIT_DURATION
		float true_trainStationAboutToLeaveBuffer = TRAIN_STATION_ABOUT_TO_LEAVE_BUFFER
		float true_trainStationAdditionalLeaveBuffer = 0.0
		float true_waitBufferToManuallyAccelerate = TRAIN_BUFFER_ABLE_TO_MANUALLY_DECELERATE
		float true_timeBeforeFullStopToPlayDecelSound = TIME_BEFORE_FULL_STOP_TO_PLAY_DECEL_SOUND
		float true_timeBeforeFullStopToPlayStopSound = TIME_BEFORE_FULL_STOP_TO_PLAY_STOP_SOUND

		array< void functionref() > callbacks_trainArrivedAtStation
		array< void functionref() > callbacks_trainLeavingFromStation
		array< void functionref() > callbacks_trainAboutToLeaveStation
		array< void functionref() > callbacks_trainAboutToArriveAtStation

		array< string > disabledAliasesList
	#endif

	#if SERVER || CLIENT
		bool trainStoppedAtStation = false
		int  true_trainCarCount = TRAIN_CAR_COUNT
	#endif

		int customQueueIdx

} file


// =================================================================================================================================
// =================================================================================================================================
// =================================================================================================================================
// =================================================================================================================================
//
//  #### ##    ## #### ########
//   ##  ###   ##  ##     ##
//   ##  ####  ##  ##     ##
//   ##  ## ## ##  ##     ##
//   ##  ##  ####  ##     ##
//   ##  ##   ###  ##     ##
//  #### ##    ## ####    ##
//
// =================================================================================================================================
// =================================================================================================================================
// =================================================================================================================================
// =================================================================================================================================


#if CLIENT
void function DesertlandsTrainAnnouncer_Init()
{
	RegisterCSVDialogue( $"datatable/dialogue/train_dialogue.rpak" )
	AddCallback_EntitiesDidLoad( InitTrainClientEnts )
	AddCallback_FullUpdate( TrainOnFullUpdate )
}
#endif


#if CLIENT
void function InitTrainClientEnts()
{
	if ( !Desertlands_IsTrainEnabled() )
		return


	// ambient generics on the train modulated by the train mover
	entity trainMover = GetEntByScriptName( format( "%s_%i", TRAIN_MOVER_NAME, 0 ) )
	foreach ( entity ambientGeneric in GetEntArrayByScriptName( "Vehicles_Train_SpeedController" ) )
		ambientGeneric.SetSoundCodeControllerEntity( trainMover )
}
#endif

void function DesertlandsTrain_PreMapInit()
{
	AddCallback_OnNetworkRegistration( DesertlandsTrain_OnNetworkRegistration )
}

void function DesertlandsTrain_OnNetworkRegistration()
{
	Remote_RegisterClientFunction( "SCB_DLandsTrain_SetCustomSpeakerIdx", "int", 0, NUM_TOTAL_DIALOGUE_QUEUES )
}

#if CLIENT
void function SCB_DLandsTrain_SetCustomSpeakerIdx( int speakerIdx )
{
	file.customQueueIdx = speakerIdx
	InitAnnouncerEnts()
}
#endif

#if CLIENT
void function InitAnnouncerEnts()
{
	int numTrainCars = GetCurrentPlaylistVarInt( "desertlands_script_train_car_count", TRAIN_CAR_COUNT )
	array<entity> customSpeakers1

	if ( numTrainCars >= 1 )
	{
		entity announcerTarget0 = GetEntByScriptName( "train_announcer_target_0" )
		customSpeakers1.append( announcerTarget0 )
	}

	if ( numTrainCars >= 3 )
	{
		entity announcerTarget2 = GetEntByScriptName( "train_announcer_target_2" )
		customSpeakers1.append( announcerTarget2 )
	}

	if ( numTrainCars >= 5 )
	{
		entity announcerTarget4 = GetEntByScriptName( "train_announcer_target_4" )
		customSpeakers1.append( announcerTarget4 )
	}

	if ( customSpeakers1.len() != 0 )
	{
		RegisterCustomDialogueQueueSpeakerEntities( file.customQueueIdx, customSpeakers1 )
	}
}
#endif


#if CLIENT
void function TrainOnFullUpdate()
{
	if ( !Desertlands_IsTrainEnabled() )
		return
}
#endif


#if SERVER
void function DesertlandsTrain_Precaches()
{
	RegisterCSVDialogue( $"datatable/dialogue/train_dialogue.rpak" )

	PrecacheParticleSystem( FX_TRAIN_MAIN_SPOTLIGHT )
	PrecacheParticleSystem( FX_TRAIN_SPOTLIGHT_BLINK )

	// Train signals
	RegisterSignal( "OnArriveAtTrainNode" )
	RegisterSignal( "OnTrainStopping" )
	RegisterSignal( "OnTrainStopped" )

	RegisterSignal( SIGNAL_TRAIN_START_FORWARD )
	RegisterSignal( SIGNAL_TRAIN_SPOTLIGHT_BLINKING )
	RegisterSignal( "ForceLeaveStation" )

	file.customQueueIdx = RequestCustomDialogueQueueIndex()
	AddCallback_OnClientConnected( OnClientConnected )
	// AddCallback_OnClientConnectionRestored( OnClientConnected )
}

void function DesertlandsTrain_Init()
{
	if ( !Desertlands_IsTrainEnabled() )
		return

	FlagWait( "Survival_LootSpawned" ) // gotta wait for the loot bins to be init'd before moving around the train and settin up the bin data at stations
	FlagInit( "AllowedToLeaveStation" )
	DesertlandsTrain_SetAllowLeaveStation()

	file.manualDeceleratingEnabled = GetCurrentPlaylistVarBool( "desertlands_script_train_stoppanel_enabled", true )
	file.true_trainCarCount = GetCurrentPlaylistVarInt( "desertlands_script_train_car_count", TRAIN_CAR_COUNT )

	SetupTrain()
	SetupTracks()

	DesertlandsTrain_SetDriverState( eTrainDriverGoals.RANDOM_STATION )

	WORKAROUND_DESERTLANDS_TRAIN = file.train

	#if PRINT_TRAIN_DEBUG
		printt( "TRAIN INITIALIZED" )
	#endif

	if( Gamemode() != eGamemodes.WINTEREXPRESS )
		thread DesertlandsTrain_InitMovement()
}

void function DesertlandsTrain_InitMovement()
{
	TrainStartAtRandomPosition()
	SetTrainState( eTrainStates.START_FORWARD )
}

void function SetupTrain()
{
	const float TRAIN_CAR_OFFSET = 832.0

	float trainCarOffsetTotal = 0.0
	for ( int idx = 0; idx < file.true_trainCarCount; idx++ )
	{
		TrainCarData data
		data.mover = GetEntByScriptName( format( "%s_%i", TRAIN_MOVER_NAME, idx ) )
		data.mover.SetPusher( true )
		// data.mover.SetPusherMovesNearbyVehicles( true )
		data.mover.DisallowZiplines()

		// get the train brush
		foreach ( entity linkEnt in data.mover.GetLinkEntArray() )
		{
			if ( linkEnt.GetClassName() == "func_brush" )
			{
				data.brush = linkEnt
				break
			}
		}

		// setup all other ents
		foreach ( entity linkEnt in data.mover.GetLinkEntArray() )
		{
			if ( !linkEnt.HasKey( "script_name" ) )
				continue

			string scriptName = linkEnt.GetScriptName()
			
			#if PRINT_TRAIN_DEBUG
				printt( "TRAIN Linked ENt has script name: " + scriptName )
			#endif

			if ( scriptName == "train_particle_main_spotlight" )
			{
				data.offsetSpotlight = linkEnt.GetOrigin() - data.brush.GetOrigin()
				data.spotlightFX = StartParticleEffectOnEntityWithPos_ReturnEntity( data.brush, GetParticleSystemIndex( FX_TRAIN_MAIN_SPOTLIGHT ), FX_PATTACH_ABSORIGIN_FOLLOW_NOROTATE, -1, data.offsetSpotlight, <0, 0, 0> )

				#if DEVELOPER
					if ( file.devDisableTrainSpotlight )
						data.spotlightFX.Destroy()
				#endif

				linkEnt.Destroy()
			}
			else if ( scriptName == "train_stop_panel" )
			{
				if ( file.manualDeceleratingEnabled )
				{
					linkEnt.AllowMantle()
					linkEnt.SetForceVisibleInPhaseShift( true )
					linkEnt.SetUsable()
					linkEnt.AddUsableValue( USABLE_CUSTOM_HINTS | USABLE_BY_OWNER | USABLE_BY_PILOTS | USABLE_BY_ENEMIES )
					linkEnt.SetUsablePriority( USABLE_PRIORITY_LOW )
					linkEnt.SetUsePrompts( "#TRAIN_ACCELERATING_HINT", "#TRAIN_ACCELERATING_HINT" )
					AddCallback_OnUseEntity( linkEnt, CreateTrainStopPanelFunc( linkEnt ) )
				}
				else
				{
					linkEnt.Hide()
					linkEnt.NotSolid()
				}

				data.stopPanel = linkEnt
			}
		}

		// create the file variables
		file.trainDatas.append( data )

		if ( idx == 0 )
		{
			file.train = data.mover
		}
		else
		{
			// offset each car from the first train car
			trainCarOffsetTotal += TRAIN_CAR_OFFSET
			data.mover.Train_Follow( file.train, trainCarOffsetTotal )
			entity previousMover = file.trainDatas[idx - 1].mover
			Assert( previousMover )
			Assert( IsValid( previousMover ) )
			// data.mover.Train_SetSimulateBeforeMeEntity( previousMover )
		}
	}
}


void function SetupTracks()
{
	// set up junction variables
	foreach ( entity junctionHelper in GetEntArrayByScriptName( HELPER_SPLIT_NAME ) )
	{
		array<entity> inwardJunctionNodes
		array<entity> outwardJunctionNodes
		array<entity> destinationNodes

		foreach ( entity linkEnt in junctionHelper.GetLinkEntArray() )
		{
			string scriptName = linkEnt.GetScriptName()

			if ( scriptName == TRACK_SPLIT_INWARD_NAME )
			{
				inwardJunctionNodes.append( linkEnt )
			}
			else if ( scriptName == TRACK_SPLIT_OUTWARD_NAME )
			{
				outwardJunctionNodes.append( linkEnt )
			}
			else
			{
				destinationNodes.append( linkEnt )
			}
		}

		Assert( destinationNodes.len() > 0 )

		array<entity> allJunctionNodes = inwardJunctionNodes
		allJunctionNodes.extend( outwardJunctionNodes )
		Assert( allJunctionNodes.len() > 0 )

		foreach ( entity node in allJunctionNodes )
			file.junctionNodeGroups[ node ] <- destinationNodes

		junctionHelper.Destroy()
	}

	// set up station nodes
	foreach ( entity stationHelper in GetEntArrayByScriptName( HELPER_STATION_NAME ) )
	{
		array<entity> stationNodes
		array<stationLootBinData> lootBinDatas

		foreach ( entity linkEnt in stationHelper.GetLinkEntArray() )
		{
			string scriptName = linkEnt.GetScriptName()

			if ( scriptName == TRACK_STATION_NAME )
			{
				stationNodes.append( linkEnt )
			}
			else if ( scriptName == TRACK_BIN_MOVER_NAME )
			{
				if ( GetCurrentPlaylistVarBool( "ignore_station_loot_bins", false ) || GetMapName() == "mp_rr_desertlands_holiday" )
					continue

				stationLootBinData data
				data.mover = linkEnt
				data.mover.SetPusher( true )
				// data.mover.SetPusherMovesNearbyVehicles( true )
				data.mover.EnableNonPhysicsMoveInterpolation( false )
				data.moverStartOrigin = data.mover.GetOrigin()

				foreach ( entity moverLinkEnt in data.mover.GetLinkEntArray() )
				{
					if ( moverLinkEnt.GetScriptName() == TRACK_BIN_DOORS_MODEL_NAME )
					{
						data.doorsModel = moverLinkEnt
					}
					else if ( moverLinkEnt.GetClassName() == "func_brush" )
					{
						data.brush = moverLinkEnt
						data.brush.SetParent( data.mover )
					}
					else if ( moverLinkEnt.GetScriptName() == LOOT_BIN_SCRIPTNAME )
					{
						data.binModel = moverLinkEnt
					}
					else if ( moverLinkEnt.GetScriptName() == TRACK_BIN_TRIGGER_NAME )
					{
						data.trigger = moverLinkEnt
					}
				}

				if( IsValid( data.binModel ) && IsValid( data.brush ) )
				{
					entity parentPoint = CreateEntity( "script_mover_lightweight" )
					parentPoint.kv.solid = 0
					parentPoint.SetValueForModelKey( data.binModel.GetModelName() )
					parentPoint.kv.SpawnAsPhysicsMover = 0
					parentPoint.SetOrigin( data.binModel.GetOrigin() )
					parentPoint.SetAngles( data.binModel.GetAngles() )
					DispatchSpawn( parentPoint )
					parentPoint.SetParent( data.brush )
					parentPoint.Hide()
					data.binModel.SetParent(parentPoint)
				}

				if ( !IsValid( data.binModel ) )
				{
					#if PRINT_TRAIN_DEBUG 
						Warning( "A train station loot bin was deleted as part of loot initialization at: " + data.mover.GetOrigin() )
					#endif
					
					if ( IsValid( data.mover ) )
						data.mover.Destroy()

					if ( IsValid( data.brush ) )
						data.brush.Destroy()
				}
				else
				{
					lootBinDatas.append( data )

					// delete any loot spawned during loot init
					// thread LootBin_ForceClose_Thread( data.binModel, true, true, true )
				}
			}
		}

		foreach ( entity stationNode in stationNodes )
		{
			file.stationNodeBinGroups[ stationNode ] <- lootBinDatas
			file.stationNodes.append( stationNode )
		}

		stationHelper.Destroy()
	}
}


void functionref( entity panel, entity player, int useInputFlags ) function CreateTrainStopPanelFunc( entity panel )
{
	return void function( entity panel, entity player, int useInputFlags ) : ()
	{
		OnTrainStopPanelActivate( panel, player, useInputFlags )
	}
}


void function OnTrainStopPanelActivate( entity panel, entity player, int useInputFlags )
{
	#if PRINT_TRAIN_DEBUG
		printt( "Attempting to emergency brake. Train current state is: %s", GetNameForEnum( eTrainStates, file.trainCurrentState ) )
	#endif
	
	// TODO: defensive fix for R5DEV-109051 with adding Train_IsMovingToTrainNode()
	if ( file.trainCurrentState == eTrainStates.ABLE_TO_MANUALLY_DECELERATE && file.train.Train_IsMovingToTrainNode() )
		TrainInitiateEmergencyStop()

	else if ( file.trainCurrentState == eTrainStates.STOPPED_AT_UNKNOWN_SPOT )
		SetTrainState( eTrainStates.START_FORWARD_CURRENT_PATH )

	else
		TrainSound_EmergencyBrakeDeny( player )
}


void function TrainInitiateEmergencyStop()
{
	file.emergencyStopEngaged = true
	file.train.Train_StopSmoothly()
	TrainSound_EmergencyBrakeEngaged()
	TrainAnnouncer_PlaySingle( "Train_EmergencyBrake", 2.0 )
	thread ResumeTrainAfterEmergencyStop()

	#if DEVELOPER
		if ( file.devShowTrainPath )
			DebugDrawSphere( file.train.GetOrigin(), 64.0, 128, 128, 255, false, 60.0 )
	#endif
}


void function ResumeTrainAfterEmergencyStop()
{
	EndSignal( file.train, "OnDestroy" )
	EndSignal( file.train, SIGNAL_TRAIN_START_FORWARD )

	const float TRAIN_EMERGENCY_STOP_DURATION = 60.0

	wait TRAIN_EMERGENCY_STOP_DURATION

	SetTrainState( eTrainStates.START_FORWARD_CURRENT_PATH )
}
#endif // SERVER


// =================================================================================================================================
// =================================================================================================================================
// =================================================================================================================================
// =================================================================================================================================
//
//   ######  ########    ###    ######## ########  ######
//  ##    ##    ##      ## ##      ##    ##       ##    ##
//  ##          ##     ##   ##     ##    ##       ##
//   ######     ##    ##     ##    ##    ######    ######
//        ##    ##    #########    ##    ##             ##
//  ##    ##    ##    ##     ##    ##    ##       ##    ##
//   ######     ##    ##     ##    ##    ########  ######
//
// =================================================================================================================================
// =================================================================================================================================
// =================================================================================================================================
// =================================================================================================================================


#if SERVER
void function SetTrainState( int desiredTrainState )
{
	#if DEVELOPER && PRINT_TRAIN_DEBUG
		printt( "Train switching state to: %s", GetNameForEnum( eTrainStates, desiredTrainState ) )
	#endif

	switch ( desiredTrainState )
	{
		case eTrainStates.START_FORWARD:
			thread TrainFollowPathForward( true )
			break

		case eTrainStates.START_FORWARD_CURRENT_PATH:
			thread TrainFollowPathForward( false )
			break

		case eTrainStates.ABLE_TO_MANUALLY_DECELERATE:
			file.trainDatas[0].stopPanel.SetUsePrompts( "#TRAIN_CAN_STOP_HINT", "#TRAIN_CAN_STOP_HINT" )
			file.trainDatas[0].stopPanel.SetSkin( 0 )
			break

		case eTrainStates.DECELERATE:
			thread TrainBeginDeceleration()
			break

		case eTrainStates.STOPPED_AT_STATION:
			thread TrainReachedStation()
			break

		case eTrainStates.STOPPED_AT_UNKNOWN_SPOT:
			thread TrainStoppedAtUnknownSpot()
			break

		case eTrainStates.ABOUT_TO_LEAVE_STATION:
			thread TrainAboutToLeaveStation()
			break
	}

	file.trainCurrentState = desiredTrainState
}


const float TRAIN_NEXT_DESTINATION_ANNOUNCE_DELAY = 4.5


void function TrainFollowPathForward( bool shouldGetNewPath )
{
	Assert( !file.train.Train_IsMovingToTrainNode() )

	Signal( file.train, SIGNAL_TRAIN_START_FORWARD )

	if ( shouldGetNewPath )
	{
		ClearTrainPathConnections()
		file.currentPathNodes = GetTrainPath()
	}
	else
	{
		TrainSound_EmergencyBrakeDeactivated()
	}

	entity endNode = file.currentPathNodes.top()

	file.train.Train_MoveToTrainNodeEx( file.train.Train_GetLastNode(), file.train.Train_GetLastDistance(), 0, file.true_trainMaxSpeed, file.true_trainAccel )
	file.train.Train_SetStopNode( endNode )

	file.emergencyStopEngaged = false
	file.trainStoppedAtStation = false

	array<entity> playerArray = GetPlayerArray()
	foreach ( player in playerArray )
		Remote_CallFunction_Replay( player, TRAIN_AT_STATION_SERVER_CALLBACK, false )

	foreach ( func in file.callbacks_trainLeavingFromStation )
		func()

	file.trainDatas[0].stopPanel.SetUsePrompts( "#TRAIN_ACCELERATING_HINT", "#TRAIN_ACCELERATING_HINT" )
	file.trainDatas[0].stopPanel.SetSkin( 1 )

	thread TrainWait_AbleToManuallyDecelerate()
	thread TrainWait_Decelerate()
	thread TrainWait_Stopped()
	thread TrainWait_AboutToJunction()

	TrainSound_AccelerateStart()
			TrainAnnouncer_PlaySingle( "Train_DepartNow" )

	                      
	if ( Gamemode() == eGamemodes.WINTEREXPRESS )
		return
       

	string destinationNoteworthy = endNode.GetValueForKey( "script_noteworthy" )
	TrainAnnouncer_PlaySingle( "Train_NextStop", 2.0 )
	string stationAlias = TrainAnnouncer_GetAliasForStationNoteworthy( endNode.GetValueForKey( "script_noteworthy" ) )
	if ( stationAlias != "" )
		TrainAnnouncer_PlaySingle( stationAlias, TRAIN_NEXT_DESTINATION_ANNOUNCE_DELAY )
}


void function TrainWait_AbleToManuallyDecelerate()
{
	if ( !file.manualDeceleratingEnabled )
		return

	EndSignal( file.train, "OnDestroy" )
	EndSignal( file.train, SIGNAL_TRAIN_DECELERATING )

	//wait TRAIN_MAX_SPEED / TRAIN_ACCEL
	wait file.true_waitBufferToManuallyAccelerate

	SetTrainState( eTrainStates.ABLE_TO_MANUALLY_DECELERATE )
}


void function TrainBeginDeceleration()
{
	foreach ( func in file.callbacks_trainAboutToArriveAtStation )
		func()

	file.trainDatas[0].stopPanel.SetUsePrompts( "#TRAIN_DECELERATING_HINT", "#TRAIN_DECELERATING_HINT" )
	file.trainDatas[0].stopPanel.SetSkin( 1 )

	TrainSound_Horn()
	thread TrainSpotlightBlink()
	thread TrainWaitPlayDecelerateSound()
	thread TrainWaitPlayStoppedSound()

	if ( file.emergencyStopEngaged )
		return

	if ( Gamemode() == eGamemodes.WINTEREXPRESS )
		return

	entity endNode = file.currentPathNodes.top()
	string destinationNoteworthy = endNode.GetValueForKey( "script_noteworthy" )
	TrainAnnouncer_PlaySingle( "Train_NowArriving", 2.0 )

	string stationAlias = TrainAnnouncer_GetAliasForStationNoteworthy( endNode.GetValueForKey( "script_noteworthy" ) )
	if ( stationAlias != "" )
		TrainAnnouncer_PlaySingle( stationAlias, TRAIN_NEXT_DESTINATION_ANNOUNCE_DELAY )
}


void function TrainWaitPlayDecelerateSound()
{
	OnThreadEnd(
		function () : ()
		{
			TrainSound_AccelerateStop()
			TrainSound_DecelerateStart()
		}
	)

	float goalVelocity = TRAIN_ACCEL * file.true_timeBeforeFullStopToPlayDecelSound

	WaitUntilTrainReachGoalVelocity( goalVelocity )
}


void function TrainWaitPlayStoppedSound()
{
	OnThreadEnd(
		function () : ()
		{
			TrainSound_FullyStopped()
		}
	)

	float goalVelocity = TRAIN_ACCEL * file.true_timeBeforeFullStopToPlayStopSound

	WaitUntilTrainReachGoalVelocity( goalVelocity )
}


void function WaitUntilTrainReachGoalVelocity( float goalVelocity )
{
	EndSignal( file.train, SIGNAL_TRAIN_COMPLETELY_STOPPED )

	// TODO: defensive fix for R5DEV-109512
	if ( !file.train.Train_IsMovingToTrainNode() )
		return

	float durationUntilReachGoalVelocity = fabs( (goalVelocity - file.train.Train_GetCurrentSpeed()) / TRAIN_ACCEL )
	float durationUntilReachZeroVelocity = fabs( (0.0 - file.train.Train_GetCurrentSpeed()) / TRAIN_ACCEL )

	if ( durationUntilReachGoalVelocity < durationUntilReachZeroVelocity )
		wait durationUntilReachGoalVelocity
}


void function TrainSpotlightBlink()
{
	#if DEVELOPER
		if ( file.devDisableTrainSpotlight )
			return
	#endif

	Signal( file.train, SIGNAL_TRAIN_SPOTLIGHT_BLINKING )

	EndSignal( file.train, "OnDestroy" )
	EndSignal( file.train, SIGNAL_TRAIN_SPOTLIGHT_BLINKING )

	const TRAIN_SPOTLIGHT_BLINK_DURATION = 12.0

	TrainCarData data = file.trainDatas[0]

	data.spotlightFX.Destroy()
	data.spotlightFX = StartParticleEffectOnEntityWithPos_ReturnEntity( data.brush, GetParticleSystemIndex( FX_TRAIN_SPOTLIGHT_BLINK ), FX_PATTACH_ABSORIGIN_FOLLOW_NOROTATE, -1, data.offsetSpotlight, <0, 0, 0> )

	wait TRAIN_SPOTLIGHT_BLINK_DURATION

	data.spotlightFX.Destroy()
	data.spotlightFX = StartParticleEffectOnEntityWithPos_ReturnEntity( data.brush, GetParticleSystemIndex( FX_TRAIN_MAIN_SPOTLIGHT ), FX_PATTACH_ABSORIGIN_FOLLOW_NOROTATE, -1, data.offsetSpotlight, <0, 0, 0> )
}


void function TrainReachedStation()
{
	Assert( !file.train.Train_IsMovingToTrainNode() )

	EndSignal( file.train, "OnDestroy" )

	file.trainStoppedAtStation = true

	array<entity> playerArray = GetPlayerArray()
	foreach ( player in playerArray )
		Remote_CallFunction_Replay( player, TRAIN_AT_STATION_SERVER_CALLBACK, true )

	file.trainDatas[0].stopPanel.SetUsePrompts( "#TRAIN_STOPPED_AT_STATION_HINT", "#TRAIN_STOPPED_AT_STATION_HINT" )
	file.trainDatas[0].stopPanel.SetSkin( 1 )

	//allow train to leave station early
	EndSignal( file.train, "ForceLeaveStation" )

	foreach ( func in file.callbacks_trainArrivedAtStation )
		func()

	TrainSound_DecelerateStop()
	TrainAnnouncer_PlaySingle( "Train_MindTheGap", 1.0 )

	thread StationLootBinsRise()

	OnThreadEnd(
		function() : ()
		{
			if ( IsValid( file.train ) )
			{
				thread TrainLeavingStation()
			}
		}
	)

	wait file.true_trainStationWaitDuration - file.true_trainStationAboutToLeaveBuffer

	FlagWait( "AllowedToLeaveStation" )
}

void function TrainLeavingStation()
{
	Assert( !file.train.Train_IsMovingToTrainNode() )

	foreach ( func in file.callbacks_trainAboutToLeaveStation )
		func()

	Assert( !file.train.Train_IsMovingToTrainNode() )

	SetTrainState( eTrainStates.ABOUT_TO_LEAVE_STATION )

	wait file.true_trainStationAboutToLeaveBuffer
	wait file.true_trainStationAdditionalLeaveBuffer

	SetTrainState( eTrainStates.START_FORWARD )
}


void function TrainStoppedAtUnknownSpot()
{
	file.trainDatas[0].stopPanel.SetUsePrompts( "#TRAIN_CAN_START_HINT", "#TRAIN_CAN_START_HINT" )
	file.trainDatas[0].stopPanel.SetSkin( 0 )

	TrainSound_DecelerateStop()
	TrainAnnouncer_PlaySingle( "Train_StoppedAtUnknownSpot", 1.0 )
}


void function TrainAboutToLeaveStation()
{
	TrainSound_Horn()
	thread StationLootBinsLower()
}
#endif // SERVER


// =================================================================================================================================
// =================================================================================================================================
// =================================================================================================================================
// =================================================================================================================================
//
//  ##     ##    ###    #### ##    ##
//  ###   ###   ## ##    ##  ###   ##
//  #### ####  ##   ##   ##  ####  ##
//  ## ### ## ##     ##  ##  ## ## ##
//  ##     ## #########  ##  ##  ####
//  ##     ## ##     ##  ##  ##   ###
//  ##     ## ##     ## #### ##    ##
//
// =================================================================================================================================
// =================================================================================================================================
// =================================================================================================================================
// =================================================================================================================================


#if SERVER
void function TrainStartAtRandomPosition()
{
	entity randomStartNode = file.stationNodes.getrandom()

	#if DEVELOPER
		if ( IsValid( file.devStartingStationNode ) )
			randomStartNode = file.devStartingStationNode
	#endif

	file.train.Train_MoveToTrainNode( randomStartNode, file.true_trainMaxSpeed, file.true_trainAccel )
	file.train.Train_StopImmediately()
}


void function TrainWait_Decelerate()
{
	EndSignal( file.train, "OnDestroy" )

	WaitSignal( file.train, SIGNAL_TRAIN_DECELERATING )

	SetTrainState( eTrainStates.DECELERATE )
}


void function TrainWait_Stopped()
{
	EndSignal( file.train, "OnDestroy" )

	WaitSignal( file.train, SIGNAL_TRAIN_COMPLETELY_STOPPED )

	if ( file.stationNodes.contains( file.train.Train_GetLastNode() ) && !file.emergencyStopEngaged )
		SetTrainState( eTrainStates.STOPPED_AT_STATION )

	else if ( file.emergencyStopEngaged )
		SetTrainState( eTrainStates.STOPPED_AT_UNKNOWN_SPOT )

	else
	{
		entity startNode = file.currentPathNodes[0]
		entity endNode   = file.currentPathNodes.top()
		
		#if PRINT_TRAIN_DEBUG
			printt( "Train path start node pos: %f, %f, %f", startNode.GetOrigin().x, startNode.GetOrigin().y, startNode.GetOrigin().z )
			printt( "Train path end node pos: %f, %f, %f", endNode.GetOrigin().x, endNode.GetOrigin().y, endNode.GetOrigin().z )
			printt( "Train current state: %s", GetNameForEnum( eTrainStates, file.trainCurrentState ) )
			mAssert( false, "Train stopped for unknown reason. It should only stop at stations or because of the emergency brake." )
		#endif
	}
}


void function TrainWait_AboutToJunction()
{
	EndSignal( file.train, "OnDestroy" )
	EndSignal( file.train, SIGNAL_TRAIN_COMPLETELY_STOPPED )

	// function assumes nodes are iterated in order of the train path
	// assumes that there will always be a pair of announcement nodes to post-junction nodes

	array<entity> announceNodes
	array<entity> postJunctionNodes

	foreach ( entity node in file.currentPathNodes )
	{
		string scriptName = node.GetScriptName()

		if ( scriptName == TRACK_SPLIT_ANNOUNCE_NAME )
		{
			announceNodes.append( node )
			continue
		}

		if ( scriptName == TRACK_SPLIT_NEW_START_NAME )
		{
			postJunctionNodes.append( node )
			continue
		}
	}

	Assert( announceNodes.len() == postJunctionNodes.len(), "Couldn't find equal pairs for pre and post junction nodes for the train announcer." )

	for ( int idx = 0; idx < announceNodes.len(); idx++ )
	{
		WaitSignal( announceNodes[ idx ], "OnArriveAtTrainNode" )

		string noteworthy = postJunctionNodes[ idx ].GetValueForKey( "script_noteworthy" )

		if ( noteworthy == "right" )
			TrainAnnouncer_PlaySingle( "Train_TurningRight" )
	}
}


const vector SFX_TRAIN_STATION_LOOT_BIN_OFFSET = <0, 0, 240>
const vector LOOT_BIN_MOVETO_OFFSET = <0, 0, 82>


void function StationLootBinsRise()
{
	entity stationNode = file.currentPathNodes.top()

	//TODO: defensive fix for R5DEV-109074
	if ( !(stationNode in file.stationNodeBinGroups) )
		return

	// bin elevators open
	float animLength
	foreach ( stationLootBinData data in file.stationNodeBinGroups[ stationNode ] )
	{
		animLength = data.doorsModel.GetSequenceDuration( "animseq/props/loot_bin/loot_bin_02_open.rseq" )
		CleanupPermanentsOnStationLootBin( data )
		thread PlayAnim( data.doorsModel, "animseq/props/loot_bin/loot_bin_02_open.rseq" )
		EmitSoundAtPosition( TEAM_UNASSIGNED, data.moverStartOrigin + SFX_TRAIN_STATION_LOOT_BIN_OFFSET, SFX_STATION_BIN_RAISE, stationNode )

		// refresh the loot
		array<string> newRefs = SURVIVAL_GetMultipleWeightedItemsFromGroup( DESERTLANDS_TRAIN_LOOT_TABLE, 3 )
		// LootBin_PutMultipleLootItemsInside( data.binModel, eLootBinCompartment.REGULAR, newRefs )
	}

	wait animLength

	// bins rise up
	foreach ( stationLootBinData data in file.stationNodeBinGroups[ stationNode ] )
		data.mover.NonPhysicsMoveTo( data.moverStartOrigin + LOOT_BIN_MOVETO_OFFSET, STATION_LOOT_MOVETO_DURATION, STATION_LOOT_MOVETO_DURATION * 0.125, STATION_LOOT_MOVETO_DURATION * 0.25 )
}


void function StationLootBinsLower()
{
	entity stationNode = file.currentPathNodes.top()

	//TODO: defensive fix for R5DEV-109074
	if ( !(stationNode in file.stationNodeBinGroups) )
		return

	wait 2 // buffer between hearing train horn and bins going down

	// move bins down
	foreach ( stationLootBinData data in file.stationNodeBinGroups[ stationNode ] )
	{
		data.mover.NonPhysicsMoveTo( data.moverStartOrigin, STATION_LOOT_MOVETO_DURATION, STATION_LOOT_MOVETO_DURATION * 0.125, STATION_LOOT_MOVETO_DURATION * 0.25 )
		EmitSoundAtPosition( TEAM_UNASSIGNED, data.moverStartOrigin + SFX_TRAIN_STATION_LOOT_BIN_OFFSET, SFX_STATION_BIN_LOWER, stationNode )
	}

	wait STATION_LOOT_MOVETO_DURATION

	// close bin lids and delete loot
	foreach ( stationLootBinData data in file.stationNodeBinGroups[ stationNode ] )
		if( LootBin_IsOpen( data.binModel ) )
			thread LootBin_PlayCloseSequence( data.binModel )

	wait 0.5

	// bin elevators close
	foreach ( stationLootBinData data in file.stationNodeBinGroups[ stationNode ] )
		thread PlayAnim( data.doorsModel, "animseq/props/loot_bin/loot_bin_02_close.rseq" )
}

void function CleanupPermanentsOnStationLootBin( stationLootBinData data )
{
	if ( !IsValid( data.trigger ) )
		return

	foreach ( entity ent in data.trigger.GetTouchingEntities() )
	{
		string targetName = ent.GetTargetName()
		string scriptName = ent.GetScriptName()

		if ( targetName == DIRTY_BOMB_TARGETNAME )
		{
			RemoveCausticDirtyBomb( ent, null )
		} else if ( targetName == TROPHY_SYSTEM_NAME || scriptName == TESLA_TRAP_NAME )
		{
			ent.Destroy()
		}
	}
}
#endif // SERVER


// =================================================================================================================================
// =================================================================================================================================
// =================================================================================================================================
// =================================================================================================================================
//
//  ########     ###    ######## ##     ##
//  ##     ##   ## ##      ##    ##     ##
//  ##     ##  ##   ##     ##    ##     ##
//  ########  ##     ##    ##    #########
//  ##        #########    ##    ##     ##
//  ##        ##     ##    ##    ##     ##
//  ##        ##     ##    ##    ##     ##
//
// =================================================================================================================================
// =================================================================================================================================
// =================================================================================================================================
// =================================================================================================================================


#if SERVER
void function ClearTrainPathConnections()
{
	foreach ( entity junctionNode, array<entity> junctionDestinationNodes in file.junctionNodeGroups )
	{
		foreach ( entity destinationNode in junctionDestinationNodes )
		{
			if ( junctionNode.IsLinkedToEnt( destinationNode ) )
			{
				junctionNode.UnlinkFromEnt( destinationNode )
			}
		}
	}
}


array<entity> function GetTrainPath()
{
	array<entity> nodes

	// go from our current node to a random station
	if ( file.trainDriverState == eTrainDriverGoals.RANDOM_STATION )
	{
		entity currentNode = file.train.Train_GetLastNode()
		nodes.append( currentNode )

		Assert( file.stationNodes.contains( currentNode ), "Initial node for train path must be a train station node. Incorrect node pos: " + currentNode.GetOrigin() )

		while( true )
		{
			array<entity> nextNodes = currentNode.GetLinkEntArray()
			entity nextNode

			if ( nextNodes.len() > 0 )
			{
				// normal case, just get the next node in the chain
				nextNode = nextNodes[0]
			}
			else
			{
				Assert( currentNode in file.junctionNodeGroups, "Train path connections should only end at junctions. No dead ends allowed." )

				// create the connection between points at a junction node
				nextNode = file.junctionNodeGroups[ currentNode ].getrandom()
				currentNode.LinkToEnt( nextNode )
				currentNode.RegenerateSmoothPoints()

				#if DEVELOPER
					if ( file.devShowTrainPath )
					{
						DebugDrawSphere( currentNode.GetOrigin(), 128.0, 255, 255,   0, false, 180.0 )
						DebugDrawSphere( nextNode.GetOrigin(), 128.0, 255,   0, 255, false, 180.0 )
					}
				#endif
			}

			Assert( IsValid( nextNode ) )

			nodes.append( nextNode )

			// only a station node should end the path in this state
			if ( file.stationNodes.contains( nextNode ) )
				break

			currentNode = nextNode
		}
	}

	Assert( nodes.len() > 1, "Train needs at least two nodes to travel between." )

	#if DEVELOPER
		// if ( file.devShowTrainPath )
			DrawTrainPath( nodes )
	#endif

	return nodes
}


void function DrawTrainPath( array<entity> nodes )
{
	for ( int idx = 0; idx < nodes.len(); idx++ )
	{
		if ( idx + 1 < nodes.len() )
			DebugDrawLine( nodes[idx].GetOrigin(), nodes[ idx + 1 ].GetOrigin(), 0, 0, 255, true, 5 )
	}
}
#endif // SERVER


// =================================================================================================================================
// =================================================================================================================================
// =================================================================================================================================
// =================================================================================================================================
//
//   ######   #######  ##     ## ##    ## ########   ######
//  ##    ## ##     ## ##     ## ###   ## ##     ## ##    ##
//  ##       ##     ## ##     ## ####  ## ##     ## ##
//   ######  ##     ## ##     ## ## ## ## ##     ##  ######
//        ## ##     ## ##     ## ##  #### ##     ##       ##
//  ##    ## ##     ## ##     ## ##   ### ##     ## ##    ##
//   ######   #######   #######  ##    ## ########   ######
//
// =================================================================================================================================
// =================================================================================================================================
// =================================================================================================================================
// =================================================================================================================================


#if SERVER
void function TrainSound_Horn()
{
	EmitSoundOnEntity( file.train, SFX_TRAIN_HORN )
}


void function TrainSound_AccelerateStart()
{
	EmitSoundOnEntity( file.train, SFX_TRAIN_ACCELERATE )
}


void function TrainSound_AccelerateStop()
{
	StopSoundOnEntity( file.train, SFX_TRAIN_ACCELERATE )
}


void function TrainSound_DecelerateStart()
{
	EmitSoundOnEntity( file.train, SFX_TRAIN_DECELERATE )
}


void function TrainSound_DecelerateStop()
{
	StopSoundOnEntity( file.train, SFX_TRAIN_DECELERATE )
}


void function TrainSound_FullyStopped()
{
	EmitSoundOnEntity( file.train, SFX_TRAIN_ENGINE_STOP )
}


void function TrainSound_EmergencyBrakeEngaged()
{
	EmitSoundOnEntity( file.trainDatas[0].stopPanel, SFX_TRAIN_EMERGENCY_BRAKE_ACTIVATE )
}


void function TrainSound_EmergencyBrakeDeactivated()
{
	EmitSoundOnEntity( file.trainDatas[0].stopPanel, SFX_TRAIN_EMERGENCY_BRAKE_DEACTIVATE )
}


void function TrainSound_EmergencyBrakeDeny( entity player )
{
	EmitSoundOnEntityOnlyToPlayer( file.trainDatas[0].stopPanel, player, SFX_TRAIN_STOP_PANEL_DENY )
}


string function TrainAnnouncer_GetAliasForStationNoteworthy( string noteworthy )
{
	string alias

	switch ( noteworthy )
	{
		case "train_yard":
			alias = "Train_TrainYard"
			break

		case "capitol_city":
			alias = "Train_CapitolCity"
			break

		case "skyhook":
			alias = "Train_Skyhook"
			break

		case "refinery":
			alias = "Train_Refinery"
			break

		case "thermal_station":
			alias = "Train_ThermalStation"
			break

		case "sorting_factory":
			alias = "Train_SortingFactory"
			break

		case "holiday_1":
			alias = ""
			break

		case "holiday_2":
			alias = ""
			break

		case "holiday_3":
			alias = ""
			break

		default:
			Assert( false, "Invalid script_noteworthy for train destination dialogue: " + noteworthy )
	}

	return alias
}


void function TrainAnnouncer_PlaySingle( string dialogueAlias, float delay = 0.0 )
	{
	int dialogueFlags = 0 //eDialogueFlags.USE_CUSTOM_QUEUE | eDialogueFlags.USE_CUSTOM_SPEAKERS

	if ( file.disabledAliasesList.contains( dialogueAlias ) )
		return

	foreach ( entity player in GetPlayerArray() )
	{
		if ( player.p.isSkydiving )
			continue

		if ( player.GetPlayerNetBool( "playerInPlane" ) )
			continue

		thread PlayDialogueForPlayer( dialogueAlias, player, null, delay, dialogueFlags, "", null ) //, file.customQueueIdx )
	}
}

void function DesertlandsTrain_SetTrainDialogueAliasEnabled( string dialogueAlias, bool enabled )
{
	if ( enabled )
	{
		if ( file.disabledAliasesList.contains( dialogueAlias ) )
		{
			file.disabledAliasesList.removebyvalue( dialogueAlias )
		}
	}
	else
	{
		if ( !file.disabledAliasesList.contains( dialogueAlias ) )
		{
			file.disabledAliasesList.append( dialogueAlias )
		}
	}
}
#endif // SERVER


// =================================================================================================================================
// =================================================================================================================================
// =================================================================================================================================
// =================================================================================================================================
//
//  ##     ## ######## #### ##       #### ######## ##    ##
//  ##     ##    ##     ##  ##        ##     ##     ##  ##
//  ##     ##    ##     ##  ##        ##     ##      ####
//  ##     ##    ##     ##  ##        ##     ##       ##
//  ##     ##    ##     ##  ##        ##     ##       ##
//  ##     ##    ##     ##  ##        ##     ##       ##
//   #######     ##    #### ######## ####    ##       ##
//
// =================================================================================================================================
// =================================================================================================================================
// =================================================================================================================================
// =================================================================================================================================


#if SERVER || CLIENT
bool function Desertlands_IsTrainEnabled()
{
	if ( GetCurrentPlaylistVarBool( "desertlands_script_train_enable", true ) )
	{
		bool entitiesExist = true
		for ( int idx = 0; idx < file.true_trainCarCount; idx++ )
		{
			array<entity> movers = GetEntArrayByScriptName( format( "%s_%i", TRAIN_MOVER_NAME, idx ) )
			if ( movers.len() < 1 )
			{
				entitiesExist = false
				break
			}
		}

		if ( entitiesExist )
			return true
		else
			return false
	}

	return false
}
#endif // SERVER || CLIENT


#if SERVER
void function DesertlandsTrain_SetDriverState( int state )
{
	Assert( state < eTrainDriverGoals._COUNT, "Train driver state is not a valid enum from eTrainDriverGoals." )

	file.trainDriverState = state
}


#if DEVELOPER
void function DesertlandsTrain_SetStartStation( string stationId, bool directionA )
{
	array<entity> allStationNodes
	array<entity> bothStationNodes

	foreach ( entity stationHelper in GetEntArrayByScriptName( HELPER_STATION_NAME ) )
	{
		foreach ( entity linkEnt in stationHelper.GetLinkEntArray() )
		{
			if ( linkEnt.GetScriptName() == TRACK_STATION_NAME )
				allStationNodes.append( linkEnt )
		}
	}

	foreach ( entity node in allStationNodes )
	{
		if ( !node.HasKey( "script_noteworthy" ) )
			continue

		if ( node.GetValueForKey( "script_noteworthy" ) == stationId )
			bothStationNodes.append( node )
	}

	if ( stationId == "sorting_factory" )
	{
		file.devStartingStationNode = bothStationNodes[0]
		return
	}

	Assert( bothStationNodes.len() == 2, "Number of station nodes isn't 2 at: " + stationId )

	if ( directionA )
		file.devStartingStationNode = bothStationNodes[0]
	else
		file.devStartingStationNode = bothStationNodes[1]
}


void function DesertlandsTrain_DisableSpotlight()
{
	file.devDisableTrainSpotlight = true

	if ( file.trainDatas.len() == 0 )
		return

	if ( IsValid( file.trainDatas[0].spotlightFX ) )
	{
		Signal( file.train, SIGNAL_TRAIN_SPOTLIGHT_BLINKING )

		file.trainDatas[0].spotlightFX.Destroy()
	}
}


void function DesertlandsTrain_ShowPath()
{
	file.devShowTrainPath = true
}
#endif // SERVER && DEVELOPER


#endif // SERVER


#if CLIENT
void function ServerCallback_SetDesertlandsTrainAtStation( bool isAtStation )
{
	file.trainStoppedAtStation = isAtStation
}
#endif


#if SERVER || CLIENT
bool function IsDesertlandsTrainAtStation()
{
	return file.trainStoppedAtStation
}
#endif // SERVER || CLIENT

#if SERVER
void function DesertlandsTrain_SetMaxSpeed( float newMaxSpeed )
{
	file.true_trainMaxSpeed = newMaxSpeed
}

void function DesertlandsTrain_SetAcceleration( float newAcceleration )
{
	file.true_trainAccel = newAcceleration
}

void function DesertlandsTrain_SetWaitDuration( float newWaitDuration )
{
	file.true_trainStationWaitDuration = newWaitDuration
}

void function DesertlandsTrain_SetAboutToLeaveBuffer( float newBuffer )
{
	file.true_trainStationAboutToLeaveBuffer = newBuffer
}

float function DesertlandsTrain_GetAboutToLeaveBuffer()
{
	return file.true_trainStationAboutToLeaveBuffer
}

void function DesertlandsTrain_SetAdditionalLeaveBuffer( float newBuffer )
{
	file.true_trainStationAdditionalLeaveBuffer = newBuffer
}

float function DesertlandsTrain_GetAdditionalLeaveBuffer()
{
	return file.true_trainStationAdditionalLeaveBuffer
}

void function DesertlandsTrain_AddCallback_TrainArrivedAtStation( void functionref() callbackFunc )
{
	file.callbacks_trainArrivedAtStation.append( callbackFunc )
}

void function DesertlandsTrain_AddCallback_TrainAboutToLeaveStation( void functionref() callbackFunc )
{
	file.callbacks_trainAboutToLeaveStation.append( callbackFunc )
}

void function DesertlandsTrain_AddCallback_TrainLeavingFromStation( void functionref() callbackFunc )
{
	file.callbacks_trainLeavingFromStation.append( callbackFunc )
}

void function DesertlandsTrain_AddCallback_TrainAboutToArriveAtStation( void functionref() callbackFunc )
{
	file.callbacks_trainAboutToArriveAtStation.append( callbackFunc )
}

int function DesertlandsTrain_GetTrainState()
{
	return file.trainCurrentState
}

vector function DesertlandsTrain_GetTrainOrigin()
{
	return file.train.GetOrigin()
}

entity function DesertlandsTrain_GetNextStationNode()
{
	return file.currentPathNodes[ file.currentPathNodes.len() - 1 ]
}

array<entity> function DesertlandsTrain_GetCurrentPathNodes()
{
	return file.currentPathNodes
}

entity function DesertlandsTrain_GetTrain()
{
	return file.train
}

array<entity> function DesertlandsTrain_GetStationNodes()
{
	return file.stationNodes
}


array<TrainCarData> function DesertlandsTrain_GetTrainCarData()
{
	return file.trainDatas
}

bool function DesertlandsTrain_IsPlayerOnTrain( entity player )
{
	// entity groundEnt = player.GetGroundEntity()
	// entity pusher    = GetPusherEnt( groundEnt )

	// if ( !IsValid( pusher ) || !pusher.GetPusher() )
		// return false

	// foreach ( car in file.trainDatas )
	// {
		// if ( pusher == car.mover )
			// return true
	// }
	return false
}

bool function DesertlandsTrain_IsTeamOnTrain( int team )
{
	array<entity> teamMembers = GetPlayerArrayOfTeam_AliveConnected( team )
	foreach ( player in teamMembers )
	{
		if ( DesertlandsTrain_IsPlayerOnTrain( player ) )
			return true
	}
	return false
}


void function DesertlandsTrain_ForceTrainLeaveStation()
{
	if ( file.trainCurrentState == eTrainStates.STOPPED_AT_STATION )
	{
		Signal( file.train, "ForceLeaveStation" )
	}
}

void function DesertlandsTrain_ClearAllowLeaveStation()
{
	FlagClear( "AllowedToLeaveStation" )
}

void function DesertlandsTrain_SetAllowLeaveStation()
{
	FlagSet( "AllowedToLeaveStation" )
}
#endif

#if SERVER
void function OnClientConnected( entity player )
{
	Remote_CallFunction_NonReplay( player, "SCB_DLandsTrain_SetCustomSpeakerIdx", file.customQueueIdx )
}
#endif
