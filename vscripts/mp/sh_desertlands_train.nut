//=========================================================
//	sh_desertlands_train.nut
//=========================================================

#if CLIENT
global function DesertlandsTrainAnnouncer_Init
global function ServerCallback_SetDesertlandsTrainAtStation
global function SCB_DLandsTrain_SetCustomSpeakerIdx
#endif


global function IsDesertlandsTrainAtStation
global function DesertlandsTrain_PreMapInit



#if SERVER
global function DesertlandsTrain_Init
global function DesertlandsTrain_Dev_TpPlayerZeroToTrain
global function DesertlandsTrain_GetJunctionNext
global function DesertlandsTrain_ThreadCheckJuncs
#endif //


///////////////////////
///////////////////////
//// Private Types ////
///////////////////////
///////////////////////

const string TRAIN_MOVER_NAME = "desertlands_train_mover"
const int TRAIN_CAR_COUNT = 6


#if SERVER
const int TRAIN_ACCELERATION = 50;	
const int TRAIN_INIT_SPEED = 500;	// Has to be the same or we could get an offset because of the junction thread delay
const int TRAIN_MAX_SPEED = 500;
const int TRAIN_CAR_OFFSET = 850;	// Original seems to be 840, +10 to fix clipping on angles
const asset TRAIN_POI_BEAM = $"P_ar_hot_zone_far"
#endif //


#if SERVER

#endif //

struct
{
	#if SERVER
    #endif


		bool trainStoppedAtStation = false
		int  true_trainCarCount = TRAIN_CAR_COUNT


		int customQueueIdx
} file


/////////////////////////
/////////////////////////
//// Initialization ////
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
void function DesertlandsTrain_Dev_TpPlayerZeroToTrain()
{
	entity trainhead = GetEntByScriptName( format( "%s_%i", TRAIN_MOVER_NAME, 0 ))
	if(!trainhead)
	{
		printl("THERE IS NO TRAIN!")
		return
	}
	
	entity p = GetPlayerArray()[0];
	p.SetOrigin(trainhead.GetOrigin() + <0,0,256>)
}

void function DesertlandsTrain_ThreadCheckJuncs(array<entity> cars)
{	
	entity lastJunction = null;
	string nextDirection = ["left","right"].getrandom();
	// ^ at some point it'll have to be global to the scope to be controlled
	
	// Not a big fan of the constant check, it's messy.
	// In theory if we're on a _inward, there's another _inward after it, and the first one isn't connected to a junc
	// We can use this info to find the next one, and run this just in time
	// If we're going to fork to two tracks, we should find "script_name" "train_track_node_pre_junction", same as first _inward
	// it helps to know that the next node is on a junction
	while(true)
	{
		wait 0.02
		foreach(entity car in cars)
		{
			entity cur = car.Train_GetLastNode()
			
			if(expect string(cur.kv.script_name).find("_inward") > 0) // Merging, always has only one next node
			{
				entity nextNode = DesertlandsTrain_GetJunctionNext(car, cur)
				if(!nextNode) continue // Not a junction then
				
				car.Train_MoveToTrainNode(nextNode, TRAIN_MAX_SPEED, TRAIN_ACCELERATION)
			}
			else if(expect string(cur.kv.script_name).find("_outward") > 0) // Forking, chooses one between left and right
			{				
				if(lastJunction != cur)
				{
					nextDirection = ["left","right"].getrandom()	// not random on live?
					lastJunction = cur
				}
				entity nextNode = DesertlandsTrain_GetJunctionNext(car, cur, nextDirection)
				car.Train_MoveToTrainNode(nextNode, TRAIN_MAX_SPEED, TRAIN_ACCELERATION)
			}
		}
	}
}

entity function DesertlandsTrain_GetJunctionNext(entity car, entity node, string noteworthy = "")
{
	array<entity> junctions = GetEntArrayByScriptName( "train_track_helper_junction" )
	foreach(entity junc in junctions)
	{
		bool isOurJunc = false;
		array<entity> links = junc.GetLinkEntArray()
		foreach(entity link in links)
		{
			if(link == node)
			{
				isOurJunc = true;
				break
			}
		}
		
		if(!isOurJunc)
			continue
		
		foreach(entity link in links)
		{
			if(link == node)
				continue;
			
			if(link.GetClassName() == "script_mover_train_node")	
			{
				if(	link.HasKey("script_name") && 
					(expect string(link.kv.script_name).find("_outward") > 0 ||
					expect string(link.kv.script_name).find("_inward") > 0)
				)
					continue
				
				if(noteworthy != "")
				{
					if(link.HasKey("script_noteworthy") && expect string(link.kv.script_noteworthy) == noteworthy)
						return link;
					continue
				}
				
				return link
			}
		}
	}
	return null
}

void function DesertlandsTrain_Init()
{	
	entity station = GetEntArrayByScriptName( "train_track_node_station" ).getrandom()
	
	printl("        |////////|       |/////////|       |//////L")	
	printl("  _____ |////////| _____ TRAIN  INIT _____ |////////>")	
	printl("------------------------------------------------------")	
	printl(" ")	
	printl("  - - - TRAIN SPAWNING AT: "+station.kv.script_noteworthy + " - - -")	
	printl(" ")	
	printl("        |////////|       |/////////|       |//////L")	
	printl("  _____ |////////| _____ TRAIN  INIT _____ |////////>")	
	printl("------------------------------------------------------")	
	
	// Get all cars
	array<entity> cars = [];
	for ( int idx = file.true_trainCarCount; idx > -1 ; idx-- )
	{
		array<entity> movers = GetEntArrayByScriptName( format( "%s_%i", TRAIN_MOVER_NAME, idx ) )
		if(movers.len() == 1)
			cars.append(movers[0])
	}
	
	// Deleted Button: while we don't know about it
	// TODO: Hook the button to stop and start the train instead
	GetEntByScriptName( "train_stop_panel" ).Destroy()	
	
	// Parent loot bins
	array<entity> lootBins = GetEntArrayByClass_Expensive( "prop_dynamic" )
	array<entity> survivalItems = GetEntArrayByClass_Expensive( "prop_survival" )
	
    int j = 0
	foreach(entity car in cars)
	{
		printl(">>>> " + car)
		foreach(entity bin in lootBins)
		{
			if(bin.GetModelName().find("loot_bin_0") <= 0)
				continue
			
			float distance = Distance(car.GetOrigin(),bin.GetOrigin())
			if(distance > 300)
				continue
			
            j++ //Spawn really good loot in the last car
            
            if( GetCurrentPlaylistVarBool("lootbin_loot_enable", true) == true)
            {   
                ClearLootBinContents( bin )
                if(j != 2)
                    AddMultipleLootItemsToLootBin( bin, SURVIVAL_GetMultipleWeightedItemsFromGroup( "Desertlands_Train", 4 ) )
                else
                    AddMultipleLootItemsToLootBin( bin, SURVIVAL_GetMultipleWeightedItemsFromGroup( "POI_Ultra", 4 ) )
            }
			
			entity parentPoint = CreateEntity( "script_mover_lightweight" )
			parentPoint.kv.solid = 0
			parentPoint.SetValueForModelKey( bin.GetModelName() )
			parentPoint.kv.SpawnAsPhysicsMover = 0
			parentPoint.SetOrigin( bin.GetOrigin() )
			parentPoint.SetAngles( bin.GetAngles() )
			DispatchSpawn( parentPoint )
			parentPoint.SetParent( car )
			parentPoint.Hide()
			
			bin.SetParent(parentPoint)
		}
		foreach(entity item in survivalItems)	// No survival items on the ground at this time, fix here if doesn't work
		{
			float distance = Distance(car.GetOrigin(),item.GetOrigin())
			if(distance > 320)
				continue
			
			item.SetParent(car)
		}
	}
	
	
	// Spawn Highlight Beam
	PrecacheParticleSystem( TRAIN_POI_BEAM )
	entity trainBeam =  StartParticleEffectInWorld_ReturnEntity(GetParticleSystemIndex( TRAIN_POI_BEAM ), cars[cars.len()-1].GetOrigin(), <90,0,0> )
	trainBeam.SetParent(cars[cars.len()-1])
	
	
	// Start the train
	for(int i = 0; i<file.true_trainCarCount; i++)
	{
		cars[i].Hide()
		cars[i].Train_MoveToTrainNodeEx(station, i*TRAIN_CAR_OFFSET, TRAIN_INIT_SPEED, TRAIN_MAX_SPEED, TRAIN_ACCELERATION)
	}
	
	thread DesertlandsTrain_ThreadCheckJuncs(cars)
}
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



bool function IsDesertlandsTrainAtStation()
{
	return file.trainStoppedAtStation
}


#if SERVER

#endif //