// Made by @CafeFPS

//-todo
// fix TRAIN_POI_BEAM
// recreate smooth points for next node from stop node
// clean up installed stopmover and created smooth points in path chain ?, connect lastnode to next path again and remove the new smooth points
// add timeout to manual stop, like, after being manually stopped some time it should restart auto after a while
// create stop enabler entity for each station (current method it's not precise and it's delayed)
// en las junctions realmente el tren se devuelve algunas unidades siempre, debido a que el link está antes ._.

//-Native functions

// Train_GetStopNode()
// Train_SetStopNode()
// Train_IsMovingToTrainNode()
// Train_GetLastSpeed()
// Train_GetGoalSpeed()
// Train_GetGoalTimeToGoalSpeed()
// Train_GetLastDistance()
// Train_GetCurrentSpeed()
// Train_GetLastNode()
// Train_ClearBreadcrumbs()
// Train_Follow()
// RegenerateSmoothPoints()
// GetTotalSmoothDistance()
// GetSmoothPositionAtDistance(float)

//-Sounds

// 33998,Vehicles_Train_Braking
// 33999,Vehicles_Train_EdgeWind
// 34000,Vehicles_Train_Engine_Stop
// 34001,vehicles_train_exterior
// 34002,Vehicles_Train_Exterior_Wind
// 34003,Vehicles_Train_ExteriorEngine
// 34004,Vehicles_Train_ExteriorEngine_3D
// 34005,Vehicles_Train_ExteriorEngine_Back
// 34006,Vehicles_Train_ExteriorEngine_Front
// 34007,Vehicles_Train_ExteriorEngine_Front_3D
// 34008,Vehicles_Train_ExteriorEngine_Front_OG
// 34009,Vehicles_Train_ExteriorEngine_Front_RoutedStereo
// 34010,Vehicles_Train_ExteriorEngine_OG
// 34011,Vehicles_Train_ExteriorEngine_RoutedStereo
// 34012,Vehicles_Train_ExteriorEngineCopy
// 34013,Vehicles_Train_Horn
// 34014,vehicles_train_interior
// 34015,Vehicles_Train_InteriorRattle_Large
// 34016,Vehicles_Train_InteriorRattle_Small
// 34017,vehicles_train_poleby
// 34018,Vehicles_Train_Start_Accelerate
// 34019,Vehicles_Train_StationAlert
// 34020,vehicles_train_tunnel

#if SERVER
global function DesertlandsTrain_Init

#if DEVELOPER
global function Dev_StartTrainMovement
global function Dev_StopTrainSmooth
global function Dev_TpPlayerZeroToTrain
global function Dev_DebugStationsLinks
#endif

#elseif CLIENT
global function DesertlandsTrainAnnouncer_Init
global function ServerCallback_SetDesertlandsTrainAtStation
global function SCB_DLandsTrain_SetCustomSpeakerIdx
#endif

global function IsDesertlandsTrainAtStation
global function DesertlandsTrain_PreMapInit

const string TRAIN_MOVER_NAME = "desertlands_train_mover"
const int TRAIN_CAR_COUNT = 6
bool TRAIN_DEBUG = false

#if SERVER
const int TRAIN_ACCELERATION = 50
const int TRAIN_INIT_SPEED = 500
const int TRAIN_MAX_SPEED = 500
const int TRAIN_CAR_OFFSET = 840
const asset TRAIN_POI_BEAM = $"P_ar_loot_train_far_blink"
const int TRAIN_DURATION_TO_DEPART = 40
const int TRAIN_DISTANCE_TO_BEGIN_STOP = 2500
const bool TRAIN_STOP_AT_STATIONS = true
const bool TRAIN_ENABLE_STOP_BUTTON = false
#endif

struct
{
	#if SERVER
		array<entity> trainStations
		array<entity> trainStationsAllMovementNodes
		array<entity> trainCars
		array<entity> binStations
		array<entity> trainTrackHelpers
		entity lastStationCrossed
		entity buttonEnt
		entity nextStation
		entity lastStopMoverEnt
		bool trainStoppedManually = false
		entity lastFixedJunct
	#endif
	bool trainStoppedAtStation = false
	int customQueueIdx
} file

#if SERVER
void function DesertlandsTrain_Init()
{
	PrecacheParticleSystem( TRAIN_POI_BEAM )
	
	AddCallback_EntitiesDidLoad( Train_StartTrainMovement )
	AddCallback_OnClientConnected( Train_OnPlayerConnected )
}

void function Train_StartTrainMovement()
{
	file.trainStations = GetEntArrayByScriptName( "train_track_node_station" )
	file.buttonEnt = GetEntByScriptName( "train_stop_panel" )
	file.trainStationsAllMovementNodes = GetEntArrayByClass_Expensive( "script_mover_train_node" )
	file.binStations = GetEntArrayByScriptName( "train_station_bin_mover" )
	file.trainTrackHelpers = GetEntArrayByScriptName( "train_track_helper_station" )
	
	if( TRAIN_ENABLE_STOP_BUTTON )
		AddTrainButtonProperties()
	else
		file.buttonEnt.Destroy()
	
	#if DEVELOPER
	// Draw HemiSpheres on all nodes
	foreach( station in file.trainStationsAllMovementNodes ) // it includes stations, fixer ents, cargobot paths, etc
	{
		DebugDrawHemiSphere( station.GetOrigin(), station.GetAngles(), 25.0, 20, 210, 255, false, 999.0 )
	}
	
	foreach( entity station in file.trainStations ) //spawn always in skyhook for easier debugging
	// Force skyhook start for debugging	
		if( expect string ( station.kv.script_noteworthy ) == "skyhook" )
			file.lastStationCrossed = station
	#else
	file.lastStationCrossed = file.trainStations.getrandom()
	#endif
	
	printt("TRAIN SPAWNING AT: " + file.lastStationCrossed.kv.script_noteworthy ) // + " - Train server script by @CafeFPS. ( WIP )")

	// Get all cars, don't add trainhead
	array<entity> cars = []
	for( int i = 1; i < TRAIN_CAR_COUNT; i++ )
	{
		array<entity> movers = GetEntArrayByScriptName( format( "%s_%i", TRAIN_MOVER_NAME, i ) )
		if(movers.len() == 1)
			cars.append(movers[0])
	}
	file.trainCars = cars
	
	// Parent loot bins
	array<entity> lootBins = GetEntArrayByClass_Expensive( "prop_dynamic" )
	array<entity> survivalItems = GetEntArrayByClass_Expensive( "prop_survival" )

	foreach(entity car in cars)
	{
		foreach(entity bin in lootBins)
		{
			if(bin.GetModelName().find("loot_bin_0") <= 0)
				continue

			float distance = Distance(car.GetOrigin(),bin.GetOrigin())
			if(distance > 300)
				continue

			if( GetCurrentPlaylistVarBool("lootbin_loot_enable", true) && GameRules_GetGameMode() == SURVIVAL)
			{
				ClearLootBinContents( bin )
				AddMultipleLootItemsToLootBin( bin, SURVIVAL_GetMultipleWeightedItemsFromGroup( "Zone_HotZone", 4 ) )
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

	entity trainhead = GetEntByScriptName( format( "%s_%i", TRAIN_MOVER_NAME, 0 ))
	trainhead.Train_ClearBreadcrumbs()
	
	// Create the fx
	entity fx = StartParticleEffectOnEntityWithPos_ReturnEntity( trainhead, GetParticleSystemIndex( TRAIN_POI_BEAM ), FX_PATTACH_CUSTOMORIGIN_FOLLOW_NOROTATE, -1, <0,0,0>, <0,0,0> )
	fx.SetParent( trainhead )
	//EffectSetControlPointVector( fx, 1, <1,1,1> )
	
	Flowstate_Train_SetupBinsAtStation()
	thread Flowstate_Train_CheckForJuncts()
	
	// Start train movement by moving only the head to next node
	trainhead.Train_MoveToTrainNodeEx(file.lastStationCrossed, 0, TRAIN_INIT_SPEED, TRAIN_MAX_SPEED, TRAIN_ACCELERATION)
	trainhead.Hide() // Hide debug ent
	
	// Make the cars follow the head
	for( int i = 0; i < cars.len(); i++ )
	{
		cars[i].Hide() // Hide debug ent
		cars[i].Train_Follow( trainhead, (i+1)*TRAIN_CAR_OFFSET )
	}
	
	file.trainStoppedAtStation = false

	// Main train thread
	if( TRAIN_STOP_AT_STATIONS )
		thread Flowstate_Train_TryUpdateNextStation()
}

void function Train_OnPlayerConnected( entity player )
{
	Remote_CallFunction_Replay( player, "ServerCallback_SetDesertlandsTrainAtStation", file.trainStoppedAtStation )
}

void function Flowstate_Train_SetupBinsAtStation()
{
	if( GameRules_GetGameMode() == "fs_infected" )
		return
	
	entity funcBrush
	entity doors
	entity lootBin
	entity binHolder
	
	foreach( binMover in file.binStations )
	{
		foreach( entLinkedToBinMover in binMover.GetLinkEntArray() )
		{
			if( entLinkedToBinMover.GetClassName() == "func_brush" )
			{
				funcBrush = entLinkedToBinMover
				continue
			}
			
			switch( entLinkedToBinMover.GetScriptName() )
			{
				case "station_loot_bin_doors_model":
				doors = entLinkedToBinMover
				binMover.UnlinkFromEnt( entLinkedToBinMover )
				continue
				
				case "station_loot_bin_trigger":
				binHolder = entLinkedToBinMover
				continue
				
				case "survival_lootbin_spawned":
				lootBin = entLinkedToBinMover
				continue
			}
		}
		
		// hack, why the original ent won't play the anim?
		vector originfordoor = doors.GetOrigin()
		vector anglesfordoor = doors.GetAngles()
		doors.Destroy()
		entity door = CreatePropDynamic( $"mdl/props/loot_bin/loot_bin_02_animated.rmdl", originfordoor, anglesfordoor, 6 )
		binMover.LinkToEnt( door )
		door.SetScriptName( "station_loot_bin_doors_model" )
		funcBrush.SetParent( binMover )
		
		entity parentPoint = CreateEntity( "script_mover_lightweight" )
		parentPoint.kv.solid = 0
		parentPoint.SetValueForModelKey( lootBin.GetModelName() )
		parentPoint.kv.SpawnAsPhysicsMover = 0
		parentPoint.SetOrigin( lootBin.GetOrigin() )
		parentPoint.SetAngles( lootBin.GetAngles() )
		DispatchSpawn( parentPoint )
		parentPoint.SetParent( funcBrush )
		parentPoint.Hide()
		lootBin.SetParent(parentPoint)
	}
}

void function Flowstate_OpenLootBinsAtStation( entity station )
{
	foreach( entity binMover in file.binStations )
	{
		thread function () : ( station, binMover )
		{
			if( Distance( station.GetOrigin(), binMover.GetOrigin() ) < 10000 )
			{
				entity door
				foreach( entLinkedToBinMover in binMover.GetLinkEntArray() )
				{
					if( entLinkedToBinMover.GetScriptName() == "station_loot_bin_doors_model" )
					{
						door = entLinkedToBinMover
					}
				}
				
				PlayAnim( door, "loot_bin_02_open" )
				binMover.NonPhysicsMoveTo( binMover.GetOrigin() + binMover.GetUpVector() * 80, 5, 0, 0 )
			}
		}()
	}
}

void function Flowstate_CloseLootBinsAtStation( entity station )
{
	foreach( entity binMover in file.binStations )
	{
		thread function () : ( station, binMover )
		{
			if( Distance( station.GetOrigin(), binMover.GetOrigin() ) < 10000 )
			{
				entity door
				entity lootBin
				
				foreach( entLinkedToBinMover in binMover.GetLinkEntArray() )
				{
					if( entLinkedToBinMover.GetScriptName() == "station_loot_bin_doors_model" )
					{
						door = entLinkedToBinMover
					} else if( entLinkedToBinMover.GetScriptName() == "survival_lootbin_spawned" )
					{
						lootBin = entLinkedToBinMover
					}
				}
				
				binMover.NonPhysicsMoveTo( binMover.GetOrigin() + binMover.GetUpVector() * -80, 5, 0, 0 )
				
				wait 5

				if ( LootBin_IsOpen( lootBin ) )
					thread LootBin_PlayCloseSequence( lootBin )
				PlayAnim( door, "loot_bin_02_close" )
			}
		}()
	}
}

void function AddTrainButtonProperties()
{
	entity button = file.buttonEnt
	
	if ( !IsValid( button ) )
		return

	button.SetUsable()
	button.SetOwner( GetEntByScriptName( format( "%s_%i", TRAIN_MOVER_NAME, 0 )) )
	button.SetUsableByGroup( "pilot" )
	button.SetUsableValue( USABLE_BY_ALL | USABLE_CUSTOM_HINTS )
	button.SetUsePrompts("Press %use% to Stop The Train.", "Press %use% to Stop The Train.")
	button.SetUsablePriority( USABLE_PRIORITY_MEDIUM )

	SetCallback_CanUseEntityCallback( button, TrainButton_CanUse )
	AddCallback_OnUseEntity( button, TrainCheckForStopOrRestart )
}

bool function TrainButton_CanUse(entity player, entity button)
{
	if(	!IsValid(player) || !IsValid(button) ) 
		return false
	
	if( IsTrainMovingToTrainNode() && Train_IsBraking() )
		return false
	
	if( IsTrainMovingToTrainNode() && Train_IsAccelerating() )
		return false
	
	if( file.trainStoppedAtStation )
		return false
	
	return true
}	

void function TrainCheckForStopOrRestart( entity button, entity player, int useInputFlags )
{
	if( file.trainStoppedManually )
		thread Flowstate_RestartTrainMovementFromStopNode()
	else
		thread Flowstate_CreateAndSetStopNodeAlongPath()
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
				entity nextNode = DesertlandsTrain_GetJunctionNext(cur)
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
				entity nextNode = DesertlandsTrain_GetJunctionNext(cur, nextDirection)
				car.Train_MoveToTrainNode(nextNode, TRAIN_MAX_SPEED, TRAIN_ACCELERATION)
			}
		}
	}
}
void function Flowstate_Train_CheckForJuncts()
{
	entity lastJunction = null
	string nextDirection = ["left", "right"].getrandom()
	// ^ at some point it'll have to be global to the scope to be controlled

	// Not a big fan of the constant check, it's messy.
	// In theory if we're on a _inward, there's another _inward after it, and the first one isn't connected to a junc
	// We can use this info to find the next one, and run this just in time
	// If we're going to fork to two tracks, we should find "script_name" "train_track_node_pre_junction", same as first _inward
	// it helps to know that the next node is on a junction

	// Decide path in advance, so when we stop the train we always have enough space to calculate the stop mover position. Colombia
	entity trainhead = GetEntByScriptName( format( "%s_%i", TRAIN_MOVER_NAME, 0 ))	
	array<entity> links
	entity previousMovingNode
	entity nextMovingNode
	while(true)
	{
		wait 0.02
		
		links.clear()
		nextMovingNode = trainhead.Train_GetLastNode().GetNextTrainNode()
		links.append( nextMovingNode )
		while ( true )
		{
			entity next = links[links.len() - 1].GetLinkEnt()
			
			if ( !IsValid( next ) || next == nextMovingNode )
				break
			
			if( links.len() == 7 ) //get up to 7 next nodes or until it's not valid anymore (a junct)
				break
			
			links.append( next )
		}
		
		foreach( pathEnt in links )
		{
			if(expect string(pathEnt.kv.script_name).find("_inward") > 0 && pathEnt != file.lastFixedJunct ) // Merging, always has only one next node
			{
				entity nextNode = DesertlandsTrain_GetJunctionNext( pathEnt )
				if(!nextNode) 
				{
					
					continue // Not a junction then
				}
				
				if( IsValid( pathEnt.GetLinkEnt() ) )
				{
					if( TRAIN_DEBUG )	
						printt(" Link " + pathEnt + " had valid ent linked " )
					pathEnt.UnlinkFromEnt( pathEnt.GetLinkEnt() )
				}
				#if DEVELOPER
				if( TRAIN_DEBUG )
					printt("Junction fixed in advance, was _inward" )
				#endif

				file.lastFixedJunct = pathEnt
				pathEnt.LinkToEnt( nextNode )				
				DebugDrawHemiSphere( pathEnt.GetOrigin(), Vector(0,0,0), 100, 10, 10, 10, false, 20 )
			}
			else  if(expect string(pathEnt.kv.script_name).find("_outward") > 0 && pathEnt != file.lastFixedJunct ) // Forking, chooses one between left and right
			{
				if(lastJunction != pathEnt)
				{
					nextDirection = ["left", "right"].getrandom()
					lastJunction = pathEnt
				}
				entity nextNode = DesertlandsTrain_GetJunctionNext(pathEnt, nextDirection)
				
				if( IsValid( pathEnt.GetLinkEnt() ) )
				{
					pathEnt.UnlinkFromEnt( pathEnt.GetLinkEnt() )
				}
				#if DEVELOPER
				if( TRAIN_DEBUG )
					printt("Junction fixed in advance, was _outward and we decided to go " + nextDirection )
				#endif
				file.lastFixedJunct = pathEnt
				pathEnt.LinkToEnt( nextNode )
				DebugDrawHemiSphere( pathEnt.GetOrigin(), Vector(0,0,0), 20, 10, 10, 10, false, 20 )
			}
			
		}
	}
}

bool function Train_IsAccelerating()
{
	entity trainhead = GetEntByScriptName( format( "%s_%i", TRAIN_MOVER_NAME, 0 ))
	
	if( trainhead.Train_GetCurrentSpeed() != TRAIN_MAX_SPEED && trainhead.Train_GetGoalSpeed() == TRAIN_MAX_SPEED )
		return true
	
	return false
}

bool function Train_IsBraking()
{
	entity trainhead = GetEntByScriptName( format( "%s_%i", TRAIN_MOVER_NAME, 0 ))
	
	if( trainhead.Train_GetCurrentSpeed() != TRAIN_MAX_SPEED && trainhead.Train_GetGoalSpeed() == 0 )
		return true
	
	return false
}

bool function IsTrainMovingToTrainNode()
{
	entity trainhead = GetEntByScriptName( format( "%s_%i", TRAIN_MOVER_NAME, 0 ))
	return trainhead.Train_IsMovingToTrainNode()
}

entity function DesertlandsTrain_GetJunctionNext( entity node, string noteworthy = "")
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

void function Flowstate_Train_TryUpdateNextStation()
{
	entity nextMovingNode
	entity previousMovingNode
	entity trainheadLastNode
	float lastDistance
	float nextDistance	
	float nextDistanceStations
	float distancetocompareStations
	entity trainhead = GetEntByScriptName( format( "%s_%i", TRAIN_MOVER_NAME, 0 ))
	float totalSmoothDistance
	entity nextNode
	array<entity> links

	while( true )
	{
		if( file.trainStoppedManually )
		{
			WaitFrame()
			continue			
		}
		
		nextNode = trainhead.Train_GetLastNode().GetNextTrainNode()
		
		// Seed
		links.clear()
		
		links.append( nextNode )
		while ( true )
		{
			if( !IsValid( links[links.len() - 1] ) )
				continue
			
			entity next = links[links.len() - 1].GetLinkEnt()
			
			if ( !IsValid( next ) || next == nextNode )
				break
			
			if( links.len() == 50 )
				break
			
			links.append( next )
		}
	
		// Find first "track_node_station" ent along the path
		bool dontcheckformore = false
		foreach(entity link in links)
		{
			if( dontcheckformore )
				continue
			
			if( link.GetScriptName() == "train_track_node_station" && link != file.lastStationCrossed && link.HasKey("script_noteworthy") && link.HasKey("script_noteworthy") && expect string(link.kv.script_noteworthy) != expect string(file.lastStationCrossed.kv.script_noteworthy) )
			{
				file.nextStation = link
				dontcheckformore = true
				links.clear()
				continue
			}
			else
			{
				// file.nextStation = null
				// foreach( slink in GetEntityLinkLoop( link ) )
				// {
					// if( !links.contains( slink ) && link.GetScriptName() == "train_track_node_station" && link != file.lastStationCrossed && link.HasKey("script_noteworthy") && link.HasKey("script_noteworthy") && expect string(link.kv.script_noteworthy) != expect string(file.lastStationCrossed.kv.script_noteworthy))
						// links.append( slink )
				// }
			}
		}
	
		// if( !dontcheckformore ) 
			// file.nextStation = null
		
		trainheadLastNode = trainhead.Train_GetLastNode()
		lastDistance = trainhead.Train_GetLastDistance()
		previousMovingNode = trainheadLastNode.GetPreviousTrainNode()
		nextMovingNode = trainheadLastNode.GetNextTrainNode()
		entity nextStation = file.nextStation
		
		if( IsValid( trainheadLastNode ) && IsValid( nextMovingNode ) && IsValid( nextStation ) )
		{
			nextDistanceStations = Distance( trainhead.GetOrigin(), nextStation.GetOrigin() )
			nextDistance = trainheadLastNode.GetTotalSmoothDistance() - trainhead.Train_GetLastDistance() // smooth distance to next node from trainhead
			totalSmoothDistance = trainheadLastNode.GetTotalSmoothDistance()
			
			#if DEVELOPER
			if( TRAIN_DEBUG )
			{
				printt( "-------- DEBUG TRAIN HEAD NODES by @CafeFPS--------- " )
				printt( "LAST NODE: " + trainheadLastNode + " - Distance: " + lastDistance )
				printt( "NEXT NODE: " + nextMovingNode + " - Distance: " + nextDistance )
				printt( "PREVIOUS NODE: " + previousMovingNode )
				printt( "NEXT STATION: " + nextStation.kv.script_noteworthy + " - Distance: " + nextDistanceStations )
				printt( "LAST STATION: " + file.lastStationCrossed.kv.script_noteworthy )
				printt( "TOTAL SMOOTH DISTANCE: " + totalSmoothDistance )
				printt( "---------------------------------------------------- " )
			}
			#endif
		}
		
		if( IsValid( trainheadLastNode ) && trainhead.Train_IsMovingToTrainNode() && IsValid( nextStation ) && nextStation != file.lastStationCrossed && nextDistanceStations <= TRAIN_DISTANCE_TO_BEGIN_STOP && trainhead.Train_GetCurrentSpeed() == TRAIN_MAX_SPEED )
		{
			trainhead.Train_SetStopNode( nextStation )
			trainhead.Train_StopSmoothly()
			EmitSoundOnEntity( trainhead, "Vehicles_Train_Braking" )
			if( IsValid( file.buttonEnt ) )
			{
				file.buttonEnt.SetSkin(1)
				file.buttonEnt.SetUsePrompts("Train Already Stopping at Station.", "Train Already Stopping at Station.")
			}
			
			waitthread function() : ( nextStation, trainhead, trainheadLastNode)
			{
				while( trainhead.Train_IsMovingToTrainNode() )
				{
					#if DEVELOPER
					if( TRAIN_DEBUG )
						printt( "Train is stopping - current vel: " + trainhead.Train_GetLastSpeed() ) 
					#endif
					WaitFrame()
				}
				
				
				file.trainStoppedAtStation = true
				
				if( IsValid( file.buttonEnt ) )
				{
					file.buttonEnt.SetSkin(1)
					file.buttonEnt.SetUsePrompts("Train Stopped At Station.", "Train Stopped At Station.")
				}
				
				foreach( player in GetPlayerArray() )
					Remote_CallFunction_Replay( player, "ServerCallback_SetDesertlandsTrainAtStation", true )

				wait 2
				
				// Open Station bins
				Flowstate_OpenLootBinsAtStation( nextStation )
				
				wait TRAIN_DURATION_TO_DEPART - 2
				// choo choo
				
				file.lastStationCrossed = nextStation
				trainhead.Train_MoveToTrainNodeEx( nextStation, 0, 0, TRAIN_MAX_SPEED, TRAIN_ACCELERATION) 
				file.trainStoppedAtStation = false
				file.nextStation = null
				
				Flowstate_CloseLootBinsAtStation( nextStation )
				
				if( IsValid( file.buttonEnt ) )
				{
					file.buttonEnt.SetSkin(1)
					file.buttonEnt.SetUsePrompts("Train Is Already Accelerating.", "Train Is Already Accelerating.")
				}
				
				foreach( player in GetPlayerArray() )
					Remote_CallFunction_Replay( player, "ServerCallback_SetDesertlandsTrainAtStation", false )
				
				waitthread function () : ()
				{
					while( Train_IsAccelerating() )
						WaitFrame()
					
					if( IsValid( file.buttonEnt ) )
					{
						file.buttonEnt.SetSkin(0)
						file.buttonEnt.SetUsePrompts("Press %use% to Stop The Train.", "Press %use% to Stop The Train.")
					}
				}()
			}()
		}
		
		WaitFrame()
	}
}

void function Flowstate_CreateAndSetStopNodeAlongPath()
{
	entity trainhead = GetEntByScriptName( format( "%s_%i", TRAIN_MOVER_NAME, 0 ))
	
	entity lastNode = trainhead.Train_GetLastNode()
	
	if( file.trainStoppedManually )
	{
		if( TRAIN_DEBUG )
			printt( "TRAIN IS ALREADY STOPPING" )
		return
	}
	
	if( trainhead.Train_GetCurrentSpeed() != TRAIN_MAX_SPEED )
	{
		if( TRAIN_DEBUG )
			printt( "TRAIN IS NOT AT MAX SPEED" ) 
		return
	}

	// Predict train end pos when it finishes the stopping, we need to assign Train_SetStopNode before Train_StopSmoothly
	// if distance is less than TRAIN_DISTANCE_TO_BEGIN_STOP to the NEXT node and train is at max speed, then use the distance for next node + TRAIN_DISTANCE_TO_BEGIN_STOP to calculate endpoint
	// endPos depende de la velocidad también, solo será TRAIN_DISTANCE_TO_BEGIN_STOP si el train va a máxima velocidad
	entity nextMovingNode = lastNode.GetNextTrainNode()

	float nextDistance = lastNode.GetTotalSmoothDistance() - trainhead.Train_GetLastDistance()
	float distanceAccumulated = 0
	float distanceAccumulatedToSubtract = 0
	
	float lastDistance = trainhead.Train_GetLastDistance()
	
	vector endPos
	bool canUseThisNode = nextDistance > TRAIN_DISTANCE_TO_BEGIN_STOP ? true : false
	
	if( !canUseThisNode )
	{
		distanceAccumulated = nextDistance //initial distance between trainhead and next node, it should be less than TRAIN_DISTANCE_TO_BEGIN_STOP
		distanceAccumulatedToSubtract = nextDistance
		
		for( int i = 0; i < 1; i++ )	
		{
			distanceAccumulated += nextMovingNode.GetTotalSmoothDistance() // does this add enough space to get a point? if not, keep adding
			
			#if DEVELOPER
			if( TRAIN_DEBUG )
			{					
				printt( "CAN'T CREATE STOP NODE IN CURRENT LASTNODE PATH, USING NEXT NODES TO CREATE A NEW ONE" )
				printt( "SMOOTH DISTANCE FOR NEXT NODE : " + nextDistance + " SHOULD BE HIGHER THAN 2500 TO CREATE A NODE WITHOUT USING NEXT NODES TO CALCULATE IT " )
				printt( "ALL NEXT DISTANCE IS " + nextMovingNode.GetTotalSmoothDistance() + " LET'S ADD IT AND TRY AGAIN " )
				printt( "IS " + distanceAccumulated + " HIGHER THAN 2500? IF YES, THEN GET THE SMOOTH POSITION FROM THIS NEXTMOVINGNODE" )
			}
			#endif 
			
			if( distanceAccumulated > 2500 )
			{
				endPos = nextMovingNode.GetSmoothPositionAtDistance( TRAIN_DISTANCE_TO_BEGIN_STOP - distanceAccumulatedToSubtract)
			}
			else
			{
				distanceAccumulatedToSubtract += nextMovingNode.GetTotalSmoothDistance()
				nextMovingNode = nextMovingNode.GetNextTrainNode()
				i--
			}				
		}
	} else
	{
		endPos = lastNode.GetSmoothPositionAtDistance( trainhead.Train_GetLastDistance() + TRAIN_DISTANCE_TO_BEGIN_STOP )
	}
	
	// Cuánta distancia queda para el siguiente nodo?
	// Por cada 100  unidades, crear un smooth point?, el primero emparentarlo a lastNode, el último emparentarlo a slink
	// guardar slink para quitarle los links después, destruir los smooth points creados y volverlo al inkear con lastNode
	
	entity stopMover = CreateEntity( "script_mover_train_node" )
	stopMover.kv.tangent_type = 0
	stopMover.kv.num_smooth_points = 10
	stopMover.kv.script_noteworthy = "stopped_manually"
	stopMover.kv.script_name = "train_track_node_station"
	stopMover.kv.perfect_circular_rotation = 0
	DispatchSpawn( stopMover )
	stopMover.SetOrigin( endPos )
	
	#if DEVELOPER
	// printt( "DEBUG lastNode totalSmoothDistance " + totalSmoothDistance )
	DebugDrawHemiSphere( stopMover.GetOrigin(), Vector(0,0,0), 50, 15, 15, 255, false, 999.0 )
	#endif
	
	file.lastStopMoverEnt = stopMover
	
	trainhead.Train_SetStopNode( stopMover )
	trainhead.Train_StopSmoothly()
	EmitSoundOnEntity( trainhead, "Vehicles_Train_Braking" )
	
	if( IsValid( file.buttonEnt ) )
	{
		file.buttonEnt.SetSkin(1)
		file.buttonEnt.SetUsePrompts("Train Is Already Stopping.", "Train Is Already Stopping.")
	}
	
	file.trainStoppedManually = true

	while( trainhead.Train_IsMovingToTrainNode() )
	{
		#if DEVELOPER
		if( TRAIN_DEBUG )
			printt( "Train is stopping - current vel: " + trainhead.Train_GetLastSpeed() )
		#endif
		WaitFrame()		
	}
	
	if( IsValid( file.buttonEnt ) )
	{
		file.buttonEnt.SetSkin(0)
		file.buttonEnt.SetUsePrompts("Press %use% to Start Train.", "Press %use% to Start Train.")	
	}
	
	lastNode = trainhead.Train_GetLastNode()

	// Install it in the path chain
	nextMovingNode = lastNode.GetNextTrainNode()
	foreach( slink in lastNode.GetLinkEntArray( ) )
	{
		#if DEVELOPER
		if( TRAIN_DEBUG )
			printt(" DEBUG LINKS TO ATTACH " + slink )
		#endif
		stopMover.LinkToEnt ( slink ) //sometimes this is linked to the wrong node in the path ?
		lastNode.UnlinkFromEnt( slink ) 
		slink.RegenerateSmoothPoints()
	}
	
	lastNode.LinkToEnt( stopMover )
	
	// Create smooth points using smooth distance from last node
	
	// Important so train can start in same place
	stopMover.RegenerateSmoothPoints()
}

void function Flowstate_RestartTrainMovementFromStopNode()
{
	entity trainhead = GetEntByScriptName( format( "%s_%i", TRAIN_MOVER_NAME, 0 ))
	
	if( IsTrainMovingToTrainNode() && trainhead.Train_GetCurrentSpeed() != 0 )
		return
	
	trainhead.Train_MoveToTrainNodeEx( trainhead.Train_GetStopNode(), 0, 0, TRAIN_MAX_SPEED, TRAIN_ACCELERATION) 
	file.trainStoppedManually = false
	
	if( IsValid( file.buttonEnt ) )
	{
		file.buttonEnt.SetSkin(1)
		file.buttonEnt.SetUsePrompts("Train Is Already Accelerating.", "Train Is Already Accelerating.")
	}
	
	waitthread function () : ()
	{
		while( Train_IsAccelerating() )
			WaitFrame()
		if( IsValid( file.buttonEnt ) )
		{
			file.buttonEnt.SetSkin(0)
			file.buttonEnt.SetUsePrompts("Press %use% to Stop The Train.", "Press %use% to Stop The Train.")
		}
	}()
}

#if DEVELOPER
void function Dev_StartTrainMovement()
{
	entity trainhead = GetEntByScriptName( format( "%s_%i", TRAIN_MOVER_NAME, 0 ))
	trainhead.Train_MoveToTrainNodeEx( trainhead.Train_GetStopNode(), 0, 0, TRAIN_MAX_SPEED, TRAIN_ACCELERATION) 
	file.trainStoppedManually = false
}

void function Dev_StopTrainSmooth()
{
	thread Flowstate_CreateAndSetStopNodeAlongPath( )
}

void function Dev_DebugStationsLinks()
{
	thread function() : ( )
	{
		for( int i = 0; i < file.trainStations.len(); i++ )
		{
			printt( "++++--------------------------------------------------------------------------------------------------------------------------++++" )
			printt( ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> EXPLORING LINKS FOR NODE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<" )
			printt( "++++--------------------------------------------------------------------------------------------------------------------------++++" )
			
			wait 2
			entity station = file.trainStations[i]
			vector cOrigin = station.GetOrigin()
			
			GetPlayerArray()[0].SetOrigin( cOrigin )
			Message( gp()[0], "MAIN STATION NODE", "tpin to links")
			wait 4
			
			array<entity> links = station.GetLinkEntArray()
			foreach(entity link in links)
			{
				printt( link )
				GetPlayerArray()[0].SetOrigin( link.GetOrigin() )
				wait 2
			}

			printt( "++++--------------------------------------------------------------------------------------------------------------------------++++" )
			printt( "++++--------------------------------------------------------------------------------------------------------------------------++++" )
		}
	}()
}

void function Dev_TpPlayerZeroToTrain()
{
	entity trainhead = GetEntByScriptName( format( "%s_%i", TRAIN_MOVER_NAME, 0 ))
	if(!trainhead)
	{
		printl("THERE IS NO TRAIN!")
		return
	}

	entity p = GetPlayerArray()[0];
	p.SetOrigin(trainhead.GetOrigin() + <0,0,256>)
	
	printt( "player tp to train ent " + trainhead ) 
}

#endif // if DEVELOPER

#endif // #if SERVER

#if CLIENT
void function DesertlandsTrainAnnouncer_Init()
{
	RegisterCSVDialogue( $"datatable/dialogue/train_dialogue.rpak" )
	AddCallback_EntitiesDidLoad( InitTrainClientEnts )
	AddCallback_FullUpdate( TrainOnFullUpdate )
}

void function InitTrainClientEnts()
{
	if ( !Desertlands_IsTrainEnabled() )
		return
	
	entity trainMover = GetEntByScriptName( format( "%s_%i", TRAIN_MOVER_NAME, 0 ) )
	foreach ( entity ambientGeneric in GetEntArrayByScriptName( "Vehicles_Train_SpeedController" ) )
		ambientGeneric.SetSoundCodeControllerEntity( trainMover )
}

// S2C - set speaker idx
void function SCB_DLandsTrain_SetCustomSpeakerIdx( int speakerIdx )
{
	file.customQueueIdx = speakerIdx
	InitAnnouncerEnts()
}

void function InitAnnouncerEnts()
{
	int numTrainCars = TRAIN_CAR_COUNT
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

void function TrainOnFullUpdate()
{
	if ( !Desertlands_IsTrainEnabled() )
		return
}

bool function Desertlands_IsTrainEnabled()
{
	if ( GetCurrentPlaylistVarBool( "desertlands_script_train_enable", true ) )
	{
		bool entitiesExist = true
		for ( int idx = 0; idx < TRAIN_CAR_COUNT; idx++ )
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
#endif //if CLIENT

void function DesertlandsTrain_PreMapInit()
{
	AddCallback_OnNetworkRegistration( DesertlandsTrain_OnNetworkRegistration )
}

void function DesertlandsTrain_OnNetworkRegistration()
{
	Remote_RegisterClientFunction( "SCB_DLandsTrain_SetCustomSpeakerIdx", "int", 0 )
}

bool function IsDesertlandsTrainAtStation()
{
	return file.trainStoppedAtStation
}