//=========================================================
//	sh_desertlands_train.nut
//=========================================================

#if CLIENT
global function DesertlandsTrainAnnouncer_Init
global function ServerCallback_SetDesertlandsTrainAtStation
global function SCB_DLandsTrain_SetCustomSpeakerIdx
#endif

#if CLIENT
global function IsDesertlandsTrainAtStation
global function DesertlandsTrain_PreMapInit
#endif


#if SERVER

#endif //


///////////////////////
///////////////////////
//// Private Types ////
///////////////////////
///////////////////////
#if CLIENT
const string TRAIN_MOVER_NAME = "desertlands_train_mover"
const int TRAIN_CAR_COUNT = 82
#endif

#if SERVER

#endif //


#if SERVER

#endif //

struct
{
	#if SERVER
    #endif

	#if CLIENT
		bool trainStoppedAtStation = false
		int  true_trainCarCount = TRAIN_CAR_COUNT
	#endif

		int customQueueIdx
} file


/////////////////////////
/////////////////////////
//// Initialiszation ////
/////////////////////////
/////////////////////////
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


	//
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
	Remote_RegisterClientFunction( "SCB_DLandsTrain_SetCustomSpeakerIdx", "int", 0 )
}

#if(CLIENT)
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

#endif //


//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//


#if SERVER

#endif //


//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//


#if SERVER

#endif //


//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//


#if SERVER

#endif //


//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//


#if SERVER

#endif //


//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//


#if SERVER

#endif //


#if CLIENT
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
void function ServerCallback_SetDesertlandsTrainAtStation( bool isAtStation )
{
	file.trainStoppedAtStation = isAtStation
}
#endif


#if CLIENT
bool function IsDesertlandsTrainAtStation()
{
	return file.trainStoppedAtStation
}
#endif //

#if SERVER

#endif //