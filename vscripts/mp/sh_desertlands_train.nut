//=========================================================
//	sh_desertlands_train.nut
//=========================================================

#if CLIENT
global function DesertlandsTrainAnnouncer_Init
global function ServerCallback_SetDesertlandsTrainAtStation
#endif

#if CLIENT
global function IsDesertlandsTrainAtStation
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
const int TRAIN_CAR_COUNT     = 6
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
	#endif

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
	InitAnnouncerEnts()

	//
	entity trainMover = GetEntByScriptName( format( "%s_%i", TRAIN_MOVER_NAME, 0 ) )
	foreach ( entity ambientGeneric in GetEntArrayByScriptName( "Vehicles_Train_SpeedController" ) )
		ambientGeneric.SetSoundCodeControllerEntity( trainMover )
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
		CustomSpeakers1ListInit( customSpeakers1 )
}
#endif


#if CLIENT
void function TrainOnFullUpdate()
{
	InitAnnouncerEnts()
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