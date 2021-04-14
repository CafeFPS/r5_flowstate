global function ShHoverBike_Init
#if SERVER
global function DEV_SpawnHoverbike
#endif

const asset HOVERBIKE_MODEL = $"mdl/vehicle/hoverbike/proxy.rmdl"
//const float DEV_HOVERBIKE_MODEL_SCALE = 1.0//0.05
const vector DEV_HOVERBIKE_MODEL_ROT = < 90, 0, 0 >

global enum eRodeoSpots_Hoverbike
{
	DRIVER,
	PASSENGER_MIDDLE,
	PASSENGER_REAR,
}

global enum eRodeoTransitions_Hoverbike
{
	ATTACH_DRIVER,
	SHIFT_FROM_PASSENGER_MIDDLE_TO_DRIVER,
	SHIFT_FROM_PASSENGER_REAR_TO_DRIVER, // weird
	DETACH_DRIVER,

	ATTACH_PASSENGER_MIDDLE,
	SHIFT_FROM_DRIVER_TO_PASSENGER_MIDDLE,
	SHIFT_FROM_PASSENGER_REAR_TO_PASSENGER_MIDDLE,
	DETACH_PASSENGER_MIDDLE,

	ATTACH_PASSENGER_REAR,
	SHIFT_FROM_DRIVER_TO_PASSENGER_REAR, // weird
	SHIFT_FROM_PASSENGER_MIDDLE_TO_PASSENGER_REAR,
	DETACH_PASSENGER_REAR
}

struct
{
	RodeoVehicleFlavor& hoverbikeVehicleFlavor
	#if SERVER
		table<entity, bool> riderWantsToChangeSpotsMap
	#endif
} file

void function ShHoverBike_Init()
{
	PrecacheModel( $"mdl/titans/medium/titan_blackbox.rmdl" ) // todo(dw): !
	PrecacheModel( $"mdl/vehicle/straton/straton_imc_gunship_01.rmdl" ) // todo(dw): !

	PrecacheModel( HOVERBIKE_MODEL )

	#if SERVER
		RegisterSignal( "HoverbikeStartup" )
		AddCallback_EntitiesDidLoad( OnEntitiesDidLoad )
		// todo(dw): remove dev_spawn_hoverbike
		AddClientCommandCallback( "dev_spawn_hoverbike", ClientCommand_spawn_hoverbike ) // only exists because of an annoying debugger bug
	#endif

	#if CLIENT
		AddCreateCallback( "script_mover", OnScriptMoverCreated )
		AddCreateCallback( "npc_gunship", OnNpcGunshipCreated )
	#endif

	RodeoVehicleFlavor vf
	vf.getAttachTransition = GetAttachTransition
	vf.onRodeoStartingFunc = OnRodeoStarting
	vf.onRodeoFinishingFunc = OnRodeoFinishing
	#if SERVER
		vf.onRodeoTransitionStartingFunc = OnRodeoTransitionStarting
		vf.onRodeoRiderIdlesInSpotFunc = OnRodeoRiderIdlesInSpot
	#endif
	vf.jumpOffKey = IN_USE
	file.hoverbikeVehicleFlavor = vf

	{
		RodeoSpotFlavor sf = RodeoVehicleFlavor_AddSpot( vf, eRodeoSpots_Hoverbike.DRIVER )
		sf.attachPoint = "DRIVER"
		sf.thirdPersonIdleAnim = "pt_mount_idle"
		sf.firstPersonIdleAnim = "idle"
		sf.disableWeapons = true
	}
	{
		RodeoSpotFlavor sf = RodeoVehicleFlavor_AddSpot( vf, eRodeoSpots_Hoverbike.PASSENGER_MIDDLE )
		sf.attachPoint = "PASSENGER_MIDDLE"
		sf.thirdPersonIdleAnim = "pt_mount_idle"
		sf.firstPersonIdleAnim = "idle"
	}
	{
		RodeoSpotFlavor sf = RodeoVehicleFlavor_AddSpot( vf, eRodeoSpots_Hoverbike.PASSENGER_REAR )
		sf.attachPoint = "PASSENGER_REAR"
		sf.thirdPersonIdleAnim = "pt_mount_idle"
		sf.firstPersonIdleAnim = "idle"
	}

	{
		RodeoTransitionFlavor tf = RodeoVehicleFlavor_AddTransition( vf,
			eRodeoTransitions_Hoverbike.ATTACH_DRIVER, RODEO_SENTINEL_BEGIN_SPOT_ATTACH, eRodeoSpots_Hoverbike.DRIVER
		)
		tf.attachment = "DRIVER"
		tf.thirdPersonAnim = "pt_rodeo_entrance_F_front"
		tf.firstPersonAnim = "ptpov_rodeo_entrance_F_front"
		tf.worldSound = "Rodeo_Atlas_Rodeo_ClimbOn_Left_Exterior"
	}
	{
		RodeoTransitionFlavor tf = RodeoVehicleFlavor_AddTransition( vf,
			eRodeoTransitions_Hoverbike.ATTACH_PASSENGER_MIDDLE, RODEO_SENTINEL_BEGIN_SPOT_ATTACH, eRodeoSpots_Hoverbike.PASSENGER_MIDDLE
		)
		tf.attachment = "PASSENGER_MIDDLE"
		tf.thirdPersonAnim = "pt_rodeo_entrance_F_front"
		tf.firstPersonAnim = "ptpov_rodeo_entrance_F_front"
		tf.worldSound = "Rodeo_Atlas_Rodeo_ClimbOn_Left_Exterior"
	}
	{
		RodeoTransitionFlavor tf = RodeoVehicleFlavor_AddTransition( vf,
			eRodeoTransitions_Hoverbike.ATTACH_PASSENGER_REAR, RODEO_SENTINEL_BEGIN_SPOT_ATTACH, eRodeoSpots_Hoverbike.PASSENGER_REAR
		)
		tf.attachment = "PASSENGER_REAR"
		tf.thirdPersonAnim = "pt_rodeo_entrance_F_front"
		tf.firstPersonAnim = "ptpov_rodeo_entrance_F_front"
		tf.worldSound = "Rodeo_Atlas_Rodeo_ClimbOn_Left_Exterior"
	}
	{
		RodeoTransitionFlavor tf = RodeoVehicleFlavor_AddTransition( vf,
			eRodeoTransitions_Hoverbike.SHIFT_FROM_DRIVER_TO_PASSENGER_MIDDLE, eRodeoSpots_Hoverbike.DRIVER, eRodeoSpots_Hoverbike.PASSENGER_MIDDLE
		)
		tf.attachment = "PASSENGER_MIDDLE"
		tf.thirdPersonAnim = "pt_rodeo_trans_F2L"
		tf.firstPersonAnim = "ptpov_rodeo_trans_F2L"
		tf.worldSound = "Rodeo_Atlas_Rodeo_ClimbOn_Front_Exterior"
		tf.cockpitSound = "Rodeo_Atlas_Rodeo_ClimbOn_Front_Interior"
	}
	{
		RodeoTransitionFlavor tf = RodeoVehicleFlavor_AddTransition( vf,
			eRodeoTransitions_Hoverbike.SHIFT_FROM_DRIVER_TO_PASSENGER_REAR, eRodeoSpots_Hoverbike.DRIVER, eRodeoSpots_Hoverbike.PASSENGER_REAR
		)
		tf.attachment = "PASSENGER_REAR"
		tf.thirdPersonAnim = "pt_rodeo_trans_F2R"
		tf.firstPersonAnim = "ptpov_rodeo_trans_F2R"
		tf.worldSound = "Rodeo_Atlas_Rodeo_ClimbOn_Front_Exterior"
		tf.cockpitSound = "Rodeo_Atlas_Rodeo_ClimbOn_Front_Interior"
	}
	{
		RodeoTransitionFlavor tf = RodeoVehicleFlavor_AddTransition( vf,
			eRodeoTransitions_Hoverbike.SHIFT_FROM_PASSENGER_MIDDLE_TO_DRIVER, eRodeoSpots_Hoverbike.PASSENGER_MIDDLE, eRodeoSpots_Hoverbike.DRIVER
		)
		tf.attachment = "DRIVER"
		tf.thirdPersonAnim = "pt_rodeo_trans_L2F"
		tf.firstPersonAnim = "ptpov_rodeo_trans_L2F"
		tf.worldSound = "Rodeo_Atlas_Rodeo_ClimbOn_Front_Exterior"
		tf.cockpitSound = "Rodeo_Atlas_Rodeo_ClimbOn_Front_Interior"
	}
	{
		RodeoTransitionFlavor tf = RodeoVehicleFlavor_AddTransition( vf,
			eRodeoTransitions_Hoverbike.SHIFT_FROM_PASSENGER_MIDDLE_TO_PASSENGER_REAR, eRodeoSpots_Hoverbike.PASSENGER_MIDDLE, eRodeoSpots_Hoverbike.PASSENGER_REAR
		)
		tf.attachment = "PASSENGER_REAR"
		tf.thirdPersonAnim = "pt_rodeo_trans_L2R"
		tf.firstPersonAnim = "ptpov_rodeo_trans_L2R"
		tf.worldSound = "Rodeo_Atlas_Rodeo_ClimbOn_Front_Exterior"
		tf.cockpitSound = "Rodeo_Atlas_Rodeo_ClimbOn_Front_Interior"
	}
	{
		RodeoTransitionFlavor tf = RodeoVehicleFlavor_AddTransition( vf,
			eRodeoTransitions_Hoverbike.SHIFT_FROM_PASSENGER_REAR_TO_DRIVER, eRodeoSpots_Hoverbike.PASSENGER_REAR, eRodeoSpots_Hoverbike.DRIVER
		)
		tf.attachment = "DRIVER"
		tf.thirdPersonAnim = "pt_rodeo_trans_R2F"
		tf.firstPersonAnim = "ptpov_rodeo_trans_R2F"
		tf.worldSound = "Rodeo_Atlas_Rodeo_ClimbOn_Front_Exterior"
		tf.cockpitSound = "Rodeo_Atlas_Rodeo_ClimbOn_Front_Interior"
	}
	{
		RodeoTransitionFlavor tf = RodeoVehicleFlavor_AddTransition( vf,
			eRodeoTransitions_Hoverbike.SHIFT_FROM_PASSENGER_REAR_TO_PASSENGER_MIDDLE, eRodeoSpots_Hoverbike.PASSENGER_REAR, eRodeoSpots_Hoverbike.PASSENGER_MIDDLE
		)
		tf.attachment = "PASSENGER_MIDDLE"
		tf.thirdPersonAnim = "pt_rodeo_trans_R2L"
		tf.firstPersonAnim = "ptpov_rodeo_trans_R2L"
		tf.worldSound = "Rodeo_Atlas_Rodeo_ClimbOn_Front_Exterior"
		tf.cockpitSound = "Rodeo_Atlas_Rodeo_ClimbOn_Front_Interior"
	}
}


#if SERVER
void function OnEntitiesDidLoad()
{
	if ( !GetCurrentPlaylistVarBool( "hoverbike_spawns_enabled", true ) )
		return

	foreach ( entity infoTarget in GetEntArrayByScriptName( "hoverbike_spawn_point" ) )
	{
		// todo(dw): spawn a limited number of bikes

		// todo(dw): ensure the bike can fit at the spawn location

		CreateHoverbike( infoTarget.GetOrigin(), infoTarget.GetAngles() )

		//infoTarget.Destroy() // Save on ents! // commented out for now because of a bug with GetEntArrayByScriptName
	}
}

void function DEV_SpawnHoverbike( vector pos )
{
	//CreateHoverbike( pos, <0, 0, 0> )
	//
	//entity test = CreateEntity( "prop_physics" )
	//test.SetOrigin( gp()[0].EyePosition() + gp()[0].GetViewVector() * 90.0 )
	//test.SetModelScale( 0.05 )
	//test.SetValueForModelKey( $"mdl/titans/medium/titan_blackbox.rmdl" )
	//test.kv.solid = SOLID_VPHYSICS
	//test.kv.renderamt = 0
	//test.SetPhysics( MOVETYPE_VPHYSICS )
	//test.SetModelScale( 0.05 )
	//DispatchSpawn( test )
	//test.SetModelScale( 0.05 )
	//test.SetPhysics( MOVETYPE_VPHYSICS )
	//test.SetVelocity( < 0, 30, 0 > )
	//test.SetModelScale( 0.05 )

	//entity test = CreateEntity( "npc_gunship" )
	//test.SetOrigin( gp()[0].EyePosition() + gp()[0].GetViewVector() * 90.0 )
	//DispatchSpawn( test )

	//entity gunship = GetNPCArrayByClass( "npc_gunship" )[0]
	//
	//vector ap = gunship.GetAttachmentOrigin( 1 )
	//vector p  = gunship.GetParent().GetOrigin()
	//
	//vector worldOffset = ap - p
	//vector localOffset = RotateVector( worldOffset, AnglesInverse( gunship.GetAngles() ) )
	//
	//printt( localOffset )

	//vector p = GetEntArrayByClass_Expensive("script_mover")[0].GetOrigin(), AnglesInvese(
}

bool function ClientCommand_spawn_hoverbike( entity player, array<string> args )
{
	vector ang      = <0, RandomFloatRange( -180, 180 ), 0>
	TraceResults tr = TraceHull(
		player.EyePosition(), player.EyePosition() + 300.0 * player.GetViewVector(),
		<-20, -20, -80>, <20, 20, 80>, [ player ], TRACE_MASK_NPCWORLDSTATIC, TRACE_COLLISION_GROUP_NONE,
		AnglesToForward( ang )
	)

	CreateHoverbike( tr.endPos, ang )

	return true
}

void function CreateHoverbike( vector origin, vector angles )
{
	entity vehicle = CreateEntity( "script_mover" )
	vehicle.SetScriptName( "hoverbike" )
	//vehicle.SetValueForModelKey( HOVERBIKE_MODEL )
	vehicle.SetValueForModelKey( $"mdl/titans/medium/titan_blackbox.rmdl" )
	vehicle.SetOrigin( origin )
	//vehicle.SetAngles( angles )
	vehicle.kv.SpawnAsPhysicsMover = 0
	vehicle.SetAngles( DEV_HOVERBIKE_MODEL_ROT )
	DispatchSpawn( vehicle )

	entity vehicleRodeoProxy = CreateEntity( "npc_gunship" )
	vehicleRodeoProxy.SetScriptName( "hoverbike_rodeo_proxy" )
	vehicleRodeoProxy.kv.solid = 0
	vehicleRodeoProxy.SetOrigin( vehicle.GetOrigin() + < 0.0, 0.0, -7.0 > )
	//vehicleRodeoProxy.SetAngles( vehicle.GetAngles() )
	vehicleRodeoProxy.SetAngles( < 0, 0, 0 > )
	//vehicleRodeoProxy.SetModelScale( DEV_HOVERBIKE_MODEL_SCALE )
	DispatchSpawn( vehicleRodeoProxy )
	//vehicleRodeoProxy.SetModel( $"mdl/dev/empty_model.rmdl" )
	vehicleRodeoProxy.SetModel( HOVERBIKE_MODEL )
	vehicleRodeoProxy.SetParent( vehicle )
	vehicleRodeoProxy.Freeze()
	//vehicleRodeoProxy.NotSolid()
	vehicleRodeoProxy.SetHullType( "HULL_SMALL" )
	vehicleRodeoProxy.SetInvulnerable()

	vehicleRodeoProxy.SetRodeoAllowed( true )
	Rodeo_RegisterVehicle( vehicleRodeoProxy, file.hoverbikeVehicleFlavor )

	vehicle.SetOwner( vehicleRodeoProxy )

	vehicle.SetAngles( AnglesCompose( angles, DEV_HOVERBIKE_MODEL_ROT ) )

	OnHoverbikeCreated( vehicle )
}
#endif


#if CLIENT
void function OnScriptMoverCreated( entity ent )
{
	if ( ent.GetScriptName() == "hoverbike" )
	{
		OnHoverbikeCreated( ent )
	}
}
void function OnNpcGunshipCreated( entity ent )
{
	if ( ent.GetScriptName() == "hoverbike_rodeo_proxy" )
	{
		Rodeo_RegisterVehicle( ent, file.hoverbikeVehicleFlavor )
	}
}
#endif


void function OnHoverbikeCreated( entity vehicle )
{
	#if SERVER
		thread HoverbikeThink( vehicle ) // server only for now
	#endif
}


#if SERVER
struct VehicleSim
{
	float  startGametime
	float  time
	vector pos
	vector vel
	vector ang
	vector angVel
	bool   isEngineStarted = false
	float  engineStartTime
	bool   didCollide
	bool   wasColliding
	bool   isResting
}
void function HoverbikeThink( entity vehicle )
{
	vehicle.EndSignal( "OnDestroy" )

	// todo(dw): move these to consts
	float gravity             = 850
	float goalLateralVelocity = 840.0 // what is the top speed of the bike
	float maxEngineForce      = 1200.0 // how quickly the bike can accelerate
	float maxUpwardForce      = 2000.0
	float extraBrakingForce   = 150.0 // how much extra force is available for braking
	float goalYawVelocity     = 90.0 // how many degrees per second the player can turn
	float maxYawForce         = 1400.0 // how responsive is the turning
	float maxClimbHeight      = 140.0 // using maxUpwardForce, the bike may not be able to reach this height, but it will try. This is the height it will try at full speed.
	float lookaheadTime       = 0.22
	float idleHoverHeight     = 44.0
	float pusherAnnoyForce    = 900.0//180.0

	float pusherSize       = 2.0
	float vehicleLength    = 140.0
	float vehicleWidth     = 32.0
	float vehicleHeight    = 32.0
	float hullHeightOffset = 6.0

	VehicleSim sim
	sim.startGametime = Time()
	sim.time = 0.0
	sim.pos = vehicle.GetOrigin()
	sim.vel = < 0, 0, 0 >
	sim.ang = AnglesCompose( vehicle.GetAngles(), AnglesInverse( DEV_HOVERBIKE_MODEL_ROT ) )
	sim.angVel = < 0, 0, 0 >
	sim.isEngineStarted = false
	sim.engineStartTime = -9999.0
	sim.didCollide = false
	sim.wasColliding = false

	vector pusherMins = <-pusherSize / 2.0, -pusherSize / 2.0, -pusherSize>
	vector pusherMaxs = <pusherSize / 2.0, pusherSize / 2.0, 0.0>

	while( true )
	{
		WaitFrame()

		entity rodeoProxy = vehicle.GetOwner()
		entity driver     = RodeoState_GetRiderInSpot( rodeoProxy, eRodeoSpots_Hoverbike.DRIVER )
		if ( !IsValid( driver ) )
			driver = null

		float dt = (sim.isEngineStarted ? 0.022 : 0.033)

		float goalSimTime = (Time() - sim.startGametime)
		if ( goalSimTime - sim.time > 50.0 * dt )
		{
			sim.time = goalSimTime - 40.0 * dt // if server lags, don't make it worse
			Warning( "Hoverbike lagging" )
		}
		int stepsThisFrameCount = 0
		bool didStep            = false
		while( sim.time <= goalSimTime )
		{
			stepsThisFrameCount++
			didStep = true
			sim.time += dt

			if ( !sim.isEngineStarted )
			{
				//rodeoProxy.WaitSignal( "HoverbikeStartup" )

				if ( driver != null )
				{
					sim.isEngineStarted = true
					sim.isResting = false
					sim.engineStartTime = sim.time

					EmitSoundOnEntity( vehicle, "Drone_Mvmt_Hover_Hero" )
					continue
				}
			}
			else if ( driver == null && Length( sim.vel ) < 215.0 )
			{
				sim.isEngineStarted = false
				sim.didCollide = false
				StopSoundOnEntity( vehicle, "Drone_Mvmt_Hover_Hero" )
			}

			if ( sim.isResting )
				continue

			if ( sim.didCollide )
			{
				if ( !sim.wasColliding )
				{
					EmitSoundOnEntity( vehicle, "titan_energyshield_damage" )
					EmitSoundOnEntity( vehicle, "Robot.Land.MetalVent_3P" )
				}
				sim.wasColliding = true
			}
			else
			{
				sim.wasColliding = false
			}

			vector posPrev = sim.pos
			vector angPrev = sim.ang

			vector externalAccel    = < 0, 0, -gravity >
			vector externalAngAccel = < 0, 0, 0 >

			//vel *= pow( 0.97, dt )
			//vel *= pow( 0.96, dt )
			//angVel *= pow( 0.94, dt )
			externalAccel -= 0.04 * sim.vel // friction

			if ( driver != null )
				externalAngAccel -= 0.04 * sim.angVel // ang friction only if driver

			if ( driver == null )
			{
				//externalAccel -= GraphCapped( Length( sim.vel ), 240.0, 0.0, 0.10, 0.50 ) * sim.vel // extra friction if shutdown and slow
				externalAccel -= 0.58 * sim.vel
				//sim.vel *= 0.7
			}


			vector naiveGoalAccel = <0, 0, 0>
			bool haveGoal         = false
			vector inputGoalVel   = <0, 0, 0>
			float inputYawGoalVel = 0.0

			if ( driver != null )
			{
				haveGoal = true
				vector inputGoalVelDir = AnglesToForward( sim.ang )

				float inputGoalVelMag = goalLateralVelocity * driver.GetInputAxisForward()
				if ( inputGoalVelMag < 0.0 )
				{
					inputGoalVelMag = -inputGoalVelMag
					inputGoalVelDir = -inputGoalVelDir
				}
				inputGoalVel = inputGoalVelDir * inputGoalVelMag

				vector requiredVelChangeToReachInputGoalVel = inputGoalVel - sim.vel
				vector requiredDirToReachInputGoalDir       = Normalize( requiredVelChangeToReachInputGoalVel )

				float force = GraphCapped( Length( requiredVelChangeToReachInputGoalVel ), 0.05, 10.0, 0.0, maxEngineForce )
				naiveGoalAccel = force * requiredDirToReachInputGoalDir

				inputYawGoalVel = goalYawVelocity * -driver.GetInputAxisRight()

				//float goalVelMag = 260.0 * driver.GetInputAxisForward()
				//vector goalDir   = AnglesToForward( ang )
				//float goalFrac   = 0.0
				//if ( goalVelMag > 0.0 )
				//{
				//	goalFrac = Length( vel ) * DotProduct( vel, goalDir ) / goalVelMag
				//	driver.SetFOV( 1.0 + 2.0 * Clamp( goalFrac, 0.0, 1.0 ), dt )
				//}

				//accel += goalDir

				//angAccel.y -= 190.0 * driver.GetInputAxisRight()

				//printt( accel )
			}

			// todo(dw): air resistance??

			// todo(dw): hovering

			// todo(dw): damping

			// todo(dw): tilting/keep-upright

			// todo(dw): angular damping

			// todo(dw): "tipping" (throw riders off)

			// todo(dw): have rotating "pushers" on the base of the bike that compensate for tilted terrain

			array<entity> ignoreEnts = RodeoState_GetPlayersRodeingVehicle( rodeoProxy )
			ignoreEnts.append( vehicle )
			ignoreEnts.append( rodeoProxy )

			vector lateralVel = sim.vel
			lateralVel.z = 0
			float hoverHeight = GraphCapped( Length( lateralVel ), 0.0, goalLateralVelocity, idleHoverHeight, 0.8 * idleHoverHeight )

			float maxTotalGroundPusherForce = maxUpwardForce
			float groundPusherForce         = 0.0

			array<vector> pusherRowsMaxHeights
			array<vector> pusherColsMaxHeights

			if ( true )
			{
				float groundPusherZeroDist = hoverHeight * 4.0
				float groundPusherFullDist = hoverHeight * 0.4
				int pushersRowCount        = 4
				int pushersColCount        = 3
				pusherRowsMaxHeights.resize( pushersRowCount, <0, sim.pos.z - groundPusherZeroDist, 0> )
				pusherColsMaxHeights.resize( pushersColCount, <0, sim.pos.z - groundPusherZeroDist, 0> )
				int pusherCount = pushersRowCount * pushersColCount

				for ( int pusherRow = 0; pusherRow < pushersRowCount; pusherRow++ )
				{
					float pusherRowFrac = float( pusherRow ) / float( pushersRowCount - 1 )

					for ( int pusherCol = 0; pusherCol < pushersColCount ; pusherCol++ )
					{
						float pusherColFrac = float( pusherCol ) / float( pushersColCount - 1 )

						vector pusherLocalPos = <
								1.08 * Graph( pusherRowFrac, 0.0, 1.0, -vehicleLength / 2.0, vehicleLength / 2.0 ),
								1.05 * Graph( pusherCol, 0.0, 1.0, -vehicleWidth / 2.0, vehicleWidth / 2.0 ),
										-vehicleHeight / 2.0 + hullHeightOffset
						>
						vector startLocalPos  = pusherLocalPos + < 0.0, 0.0, vehicleHeight>
						vector endLocalPos    = pusherLocalPos + < 0.0, 0.0, -groundPusherZeroDist>

						vector pusherWorldPos = sim.pos + RotateVector( pusherLocalPos, sim.ang )
						vector startWorldPos  = sim.pos + RotateVector( startLocalPos, sim.ang )

						//TraceResults feelerUpTrace = TraceLine( pusherWorldPos, startWorldPos, ignoreEnts, TRACE_MASK_NPCWORLDSTATIC, TRACE_COLLISION_GROUP_NONE )
						//startWorldPos = feelerUpTrace.endPos - <0, 0, 1>

						vector endWorldPos = sim.pos + RotateVector( endLocalPos, sim.ang )

						//TraceResults pusherTrace = TraceLine( startWorldPos, endWorldPos, ignoreEnts, TRACE_MASK_NPCWORLDSTATIC, TRACE_COLLISION_GROUP_NONE )
						TraceResults pusherTrace = TraceHull( startWorldPos, endWorldPos, pusherMins, pusherMaxs, ignoreEnts, TRACE_MASK_NPCWORLDSTATIC, TRACE_COLLISION_GROUP_NONE )

						//if ( pusherTrace.fraction < 0.99 )
						//	DebugDrawLine( startWorldPos, pusherTrace.endPos, 255, 0, 0, false, 0.1 )
						//else
						//	DebugDrawLine( startWorldPos, pusherTrace.endPos, 0, 255, 0, false, 0.1 )

						vector hitPos = pusherTrace.endPos

						pusherRowsMaxHeights[pusherRow] = <pusherLocalPos.x, max( pusherRowsMaxHeights[pusherRow].y, hitPos.z ), 0>
						pusherColsMaxHeights[pusherCol] = <pusherLocalPos.y, max( pusherColsMaxHeights[pusherCol].y, hitPos.z ), 0>

						hitPos.z = min( hitPos.z, pusherWorldPos.z )

						float dist      = Distance( pusherWorldPos, hitPos )
						float powerFrac = GraphCapped( dist, groundPusherZeroDist, groundPusherFullDist, 0.0, 1.0 )
						if ( dist + sim.vel.y * lookaheadTime < 0.0 )
							powerFrac = 2.0
						powerFrac *= DotProduct( pusherTrace.surfaceNormal, <0, 0, 1> )
						groundPusherForce += powerFrac * maxTotalGroundPusherForce / float( pusherCount )

						vector annoyForce = pusherTrace.surfaceNormal * powerFrac * pusherAnnoyForce / float( pusherCount )
						annoyForce.z = 0
						externalAccel += annoyForce

						// if ( !isEngineStarted )
						// {
						// 	sim.angVel.y += ??
						// }
					}
				}

				if ( sim.didCollide )
				{
					groundPusherForce = maxTotalGroundPusherForce
				}
			}

			vector estimatedAccel = externalAccel + naiveGoalAccel// + prevInternalAccel
			vector estimatedVel   = sim.vel + estimatedAccel * lookaheadTime
			vector estimatedPos   = sim.pos + (estimatedVel + 0.5 * estimatedAccel * lookaheadTime) * lookaheadTime
			vector estimatedAng   = sim.ang + (sim.angVel + 0.5 * externalAngAccel * lookaheadTime) * lookaheadTime
			estimatedAng.x = 0
			estimatedAng.z = 0

			float highestZ = -999999.0//estimatedPos.z - hoverHeight
			float raisedZ  = estimatedPos.z - hoverHeight

			if ( true )
			{
				int feelersRowMaxCount = 12
				int feelersColCount    = 2
				for ( int feelerRow = 0; feelerRow < feelersRowMaxCount; feelerRow++ )
				{
					float feelerRowOffset = (feelerRow - 2) * vehicleLength * 0.4

					if ( feelerRowOffset > Distance( sim.pos, estimatedPos ) )
						break

					for ( int feelerCol = 0; feelerCol < feelersColCount ; feelerCol++ )
					{
						float feelerColFrac = float( feelerCol ) / float( feelersColCount - 1 )

						vector feelerLocalPos = <
						feelerRowOffset,
						Graph( feelerCol, 0.0, 1.0, -vehicleWidth / 2.0, vehicleWidth / 2.0 ),
										-vehicleHeight / 2.0 + hullHeightOffset
						>
						vector startLocalPos  = feelerLocalPos + < 0.0, 0.0, 300.0 >
						vector endLocalPos    = feelerLocalPos + < 0.0, 0.0, -200.0>

						vector raisedPos = estimatedPos
						raisedPos.z = raisedZ + hoverHeight

						vector feelerWorldPos = raisedPos + RotateVector( feelerLocalPos, estimatedAng )
						vector startWorldPos  = raisedPos + RotateVector( startLocalPos, estimatedAng )
						vector endWorldPos    = raisedPos + RotateVector( endLocalPos, estimatedAng )

						TraceResults feelerTrace = TraceLine( startWorldPos, endWorldPos, ignoreEnts, TRACE_MASK_NPCWORLDSTATIC, TRACE_COLLISION_GROUP_NONE )

						//if ( feelerTrace.fraction < 0.99 )
						//	DebugDrawLine( feelerWorldPos, startWorldPos, 255, 0, 0, false, 0.1 )
						//else
						//	DebugDrawLine( feelerWorldPos, feelerTrace.endPos, 0, 255, 0, false, 0.1 )

						vector hitPos = feelerTrace.endPos

						if ( !feelerTrace.startSolid )
						{
							highestZ = max( highestZ, hitPos.z )
							raisedZ = highestZ
						}

						//if ( feelerTrace.fraction < 0.99 )
						//{
						//	float pushForce
						//	vector pushDir
						//	if ( hitPos.z > feelerWorldPos.z && !feelerTrace.startSolid )
						//	{
						//		pushForce = 0.05 * pow( gravity, 2.0 )
						//		pushDir = <0.0, 0.0, 1.0>
						//	}
						//	else
						//	{
						//		pushForce = GraphCapped( Length( feelerWorldPos - hitPos ), 19.0, 110.0, 0.001 * pow( gravity, 2.0 ), 0.0 )
						//		pushForce *= GraphCapped( simTime - engineStartTime, 0.0, 2.0, 0.0, 1.0 )
						//		//pushForce *= DotProduct( Normalize( vel ), <0, 0, 1> )
						//		pushDir = Normalize( estimatedPos - hitPos )
						//	}
						//	pushForce *= DotProduct( feelerTrace.surfaceNormal, <0, 0, 1> )
						//	accel += pushForce * feelerTrace.surfaceNormal
						//}
					}
				}
			}

			highestZ = min( highestZ, estimatedPos.z + maxClimbHeight * GraphCapped( Length( sim.vel ), 0, goalLateralVelocity, 0.3, 1.0 ) )

			vector goalPos = estimatedPos
			goalPos.z = highestZ + hoverHeight

			//DebugDrawMark( estimatedPos, 20.0, [244, 244, 69], true, 0.15 )
			//DebugDrawMark( sim.pos, 20.0, [66, 244, 69], true, 0.15 )
			//DebugDrawMark( goalPos, 20.0, [232, 232, 204], true, 0.15 )

			vector internalAccel    = < 0, 0, 0 >
			vector internalAngAccel = < 0, 0, 0 >

			if ( sim.isEngineStarted )
			{
				float goalHeightChange = (goalPos.z - sim.pos.z) - sim.vel.z * dt * 5.0

				if ( goalHeightChange > 0.0 )
					goalHeightChange *= 2.3 // magic
				else
					goalHeightChange *= 0.3

				float upwardForce = -externalAccel.z + goalHeightChange * (groundPusherForce + externalAccel.z)
				upwardForce = Clamp( upwardForce, -groundPusherForce, groundPusherForce )

				if ( upwardForce < 0.0 )
					upwardForce = 0.8 * -externalAccel.z // magic

				internalAccel += upwardForce * <0, 0, 1>

				//DebugScreenText( 0.01, 0.4 + 0.05 * stepsThisFrameCount, "H: " + (sim.pos.z - highestZ) + "\nU: " + upwardForce + "\nG:" + (highestZ + hoverHeight) )

				//vector requiredVelChangeToReachGoalVel = (goalVel - vel)
				//vector requiredAccelDirToReachGoalDir  = Normalize( requiredVelChangeToReachGoalVel )

				if ( haveGoal )
				{
					vector lateralGoalVel = inputGoalVel
					lateralGoalVel.z = 0

					vector requiredVelChangeToReachLateralGoalVel = lateralGoalVel - lateralVel
					vector requiredDirToReachInputGoalDir         = Normalize( requiredVelChangeToReachLateralGoalVel )

					float computedMaxLateralForce = maxEngineForce + GraphCapped( DotProduct( requiredDirToReachInputGoalDir, -sim.vel ), 0.7, 0.9, 0.0, extraBrakingForce )
					computedMaxLateralForce -= upwardForce * 0.9

					float lateralForce = Length( requiredVelChangeToReachLateralGoalVel )

					lateralForce *= 1.2 // magic
					lateralForce = Clamp( lateralForce, 0.0, computedMaxLateralForce )
					internalAccel += lateralForce * requiredDirToReachInputGoalDir

					//DebugScreenText( 0.01, 0.4 + 0.05 * stepsThisFrameCount, "F: " + lateralForce + "\nMF: " + computedMaxLateralForce )


					float yawGoalVel           = inputYawGoalVel
					float requiredYawVelChange = yawGoalVel - sim.angVel.y

					requiredYawVelChange *= 5.0 // magic

					bool isYawBraking         = (signum( requiredYawVelChange ) != sim.angVel.y)
					float computedMaxYawForce = maxYawForce * (1.0 + (isYawBraking ? 0.3 : 0.0))
					float yawForce            = Clamp( requiredYawVelChange, -computedMaxYawForce, computedMaxYawForce )
					internalAngAccel += <0, yawForce, 0>

					//DebugScreenText( 0.01, 0.4 + 0.05 * stepsThisFrameCount, "V: " + sim.angVel.y + "\nF: " + yawForce )
				}


				//float maxLateralForce = 200.0
				//
				//requiredAccelDirToReachGoalDir.z = 0
				//requiredVelChangeToReachGoalVel.z = 0
				//float lateralForce = GraphCapped( lateralResponsiveness * Length( requiredVelChangeToReachGoalVel ), 0.05, 0.1 + softenDist * lookaheadTime, 0.0, maxLateralForce )
				//internalAccel += naiveGoalAccel//lateralForce * requiredAccelDirToReachGoalDir


				//internalAccel -= 0.003 * (internalAccel - prevInternalAccel) / dt
				//internalAccel += 0.8 * (internalAccel - prevInternalAccel) * dt

				//DebugDrawLine( pos, pos + (upwardForce * <0, 0, 1> + lateralForce * requiredAccelDirToReachGoalDir) / 10.0, 255, 255, 255, true, 0.1 )
			}

			float lengthGradient = Clamp( 0.7 * atan( -CalcLeastSquaresGradient( pusherRowsMaxHeights ) ), -45, 45 )
			float widthGradient  = Clamp( 0.5 * atan( CalcLeastSquaresGradient( pusherColsMaxHeights ) ), -45, 45 )

			//if ( !sim.isEngineStarted )
			//{
			//	lengthGradient = 0.0
			//	widthGradient = 0.0
			//}
			//DebugScreenText( 0.01, 0.4 + 0.05 * stepsThisFrameCount, "A: " + sim.ang.x + "\nG: " + (RAD_TO_DEG * lengthGradient) )

			if ( true )
			{
				float goalDeg = RAD_TO_DEG * lengthGradient

				float extraTilt = GraphCapped( Length( internalAccel ), 50.0, maxEngineForce - gravity, 0.0, 11.0 )
				extraTilt *= DotProduct( Normalize( internalAccel ), AnglesToForward( sim.ang ) )
				goalDeg += extraTilt

				float requiredDegVelChange = (goalDeg - sim.ang.x) - sim.angVel.x * dt * 8.0

				requiredDegVelChange *= 100.0 // magic

				bool isDegBraking         = (signum( requiredDegVelChange ) != sim.angVel.x)
				float computedMaxDegForce = 1000.0 * (1.0 + (isDegBraking ? 0.2 : 0.0))
				float force               = Clamp( requiredDegVelChange, -computedMaxDegForce, computedMaxDegForce )
				//DebugScreenText( 0.11, 0.4 + 0.05 * stepsThisFrameCount, "F: " + force + "\nMF: " + computedMaxDegForce + "\nR: " + requiredDegVelChange )
				internalAngAccel += <force, 0.0, 0.0>
			}
			if ( true )
			{
				float goalDeg              = RAD_TO_DEG * widthGradient
				float requiredDegVelChange = (goalDeg - sim.ang.z) - sim.angVel.z * dt * 8.0

				float extraTilt = GraphCapped( Length( internalAccel ), 50.0, maxEngineForce - gravity, 0.0, 7.0 )
				extraTilt *= DotProduct( Normalize( internalAccel ), AnglesToRight( sim.ang ) )
				goalDeg += extraTilt

				requiredDegVelChange *= 80.0 // magic

				bool isDegBraking         = (signum( requiredDegVelChange ) != sim.angVel.x)
				float computedMaxDegForce = 1000.0 * (1.0 + (isDegBraking ? 0.2 : 0.0))
				float force               = Clamp( requiredDegVelChange, -computedMaxDegForce, computedMaxDegForce )
				//DebugScreenText( 0.11, 0.4 + 0.05 * stepsThisFrameCount, "F: " + force + "\nMF: " + computedMaxDegForce + "\nR: " + requiredDegVelChange )
				internalAngAccel += <0.0, 0.0, force>
			}

			// integrate over dt
			vector accel = externalAccel + internalAccel
			sim.pos += (sim.vel + 0.5 * accel * dt) * dt
			sim.vel += accel * dt

			vector angAccel = externalAngAccel + internalAngAccel
			sim.ang += (sim.angVel + 0.5 * angAccel * dt) * dt
			sim.angVel += angAccel * dt

			//vector niceAng = sim.ang
			//niceAng.x = GraphCapped( Length( internalAccel ), 0.0, maxLateralForce, 0.0, 0.003 ) * DotProduct( internalAccel, AnglesToForward( sim.ang ) )
			//niceAng.z = GraphCapped( Length( internalAccel ), 0.0, maxLateralForce, 0.0, 0.003 ) * DotProduct( internalAccel, AnglesToRight( sim.ang ) )
			//sim.ang = niceAng // can't assign components of vectors in structs

			vector maxs            = < vehicleHeight / 2.0, vehicleWidth / 2.0, vehicleLength / 2.0 >
			vector mins            = -maxs
			vector hullUpDir       = AnglesToForward( sim.ang )
			vector hullOffset      = <0, 0, hullHeightOffset>
			TraceResults collTrace = TraceHull( posPrev + hullOffset, sim.pos + hullOffset, mins, maxs, ignoreEnts, TRACE_MASK_NPCWORLDSTATIC, TRACE_COLLISION_GROUP_NONE, hullUpDir )

			//DrawAngledBox( posPrev + hullOffset, AnglesCompose( angPrev, <90, 0, 0> ), mins, maxs, 255, 140, 80, false, 0.1 )
			//DrawAngledBox( sim.pos + hullOffset, AnglesCompose( sim.ang, <90, 0, 0> ), mins, maxs, 70, 255, 80, false, 0.1 )

			if ( collTrace.fraction < 0.99 || collTrace.startSolid )
			{
				vector hitNormal = collTrace.surfaceNormal
				if ( Length( hitNormal ) < 1.0 )
					hitNormal = -Normalize( sim.vel )

				sim.pos += 1.0 * hitNormal

				if ( sim.isEngineStarted )
				{
					vector velReflected = VectorReflectionAcrossNormal( sim.vel, hitNormal )
					float bounceFactor  = 0.6
					sim.vel = < bounceFactor * velReflected.x, bounceFactor * velReflected.y, 0.2 * velReflected.z >

					sim.angVel = 0.8 * -sim.angVel
				}
				else
				{
					sim.vel *= 0.0
					sim.angVel *= 0.0
					sim.isResting = true
				}

				if ( collTrace.startSolid || collTrace.fraction < 0.02 )
				{
					if ( Length( collTrace.surfaceNormal ) > 0.0 )
						sim.pos += 3.0 * collTrace.surfaceNormal
					else
						PutEntityInSafeSpot( vehicle, null, null, posPrev, sim.pos )

					//DebugScreenText( 0.4, 0.4 + 0.05 * stepsThisFrameCount, "HOVERBIKE STUCK " + collTrace.surfaceNormal )

					sim.ang = angPrev
				}
				else
				{
					sim.pos = LerpVector( posPrev, sim.pos, collTrace.fraction - 0.1 )
					sim.ang = angPrev
				}

				if ( !sim.didCollide )
				{
					EmitSoundOnEntity( vehicle, "titan_energyshield_down" )
					sim.didCollide = true

					// todo(dw): throw riders off
				}

				//vehicle.SetOrigin( pos )
				//vehicle.SetAngles( AnglesCompose( ang, DEV_HOVERBIKE_MODEL_ROT ) )
			}
			else
			{
				sim.didCollide = false
			}

			//PutEntityInSafeSpot( vehicle, null, null, vehicle.GetOrigin(), vehicle.GetOrigin() + 0.5 * accel * dt * dt )
			//vehicle.SetVelocity( vehicle.GetVelocity() + accel * dt )
			// todo(dw): prediction

			// todo(dw): check GetWorldSpaceCenter is correct
			// array<entity> ignoreEnts = RodeoState_GetPlayersRodeingVehicle( vehicle )
			// ignoreEnts.append( vehicle )
			// int mask = TRACE_MASK_SOLID
			// int cg = TRACE_COLLISION_GROUP_NONE
			// // front left, front right, rear left, rear right
			// TraceResults flFeeler = TraceHull( centerPos + < feelersLength/2.0, -feelersWidth/2.0, 0.0>, ignoreEnts, mask, cg )
			// TraceResults frFeeler = TraceHull( centerPos + < feelersLength/2.0,  feelersWidth/2.0, 0.0>, ignoreEnts, mask, cg )
			// TraceResults rlFeeler = TraceHull( centerPos + <-feelersLength/2.0, -feelersWidth/2.0, 0.0>, ignoreEnts, mask, cg )
			// TraceResults rrFeeler = TraceHull( centerPos + <-feelersLength/2.0,  feelersWidth/2.0, 0.0>, ignoreEnts, mask, cg )
		}
		if ( didStep )
		{
			vehicle.NonPhysicsMoveTo( sim.pos, dt * 4.0, 0.0, 0.0 )
			vehicle.NonPhysicsRotateTo( AnglesCompose( sim.ang, DEV_HOVERBIKE_MODEL_ROT ), dt * 4.0, 0.0, 0.0 )
		}
	}
}
float function CalcLeastSquaresGradient( array<vector> list )
{
	float sumX        = 0.0
	float sumXSquared = 0.0
	float sumXYMul    = 0.0
	float sumY        = 0.0
	float sumYSquared = 0.0

	for ( int i = 0; i < list.len(); i++ )
	{
		vector p = list[i]
		sumX += p.x
		sumXSquared += pow( p.x, 2.0 )
		sumXYMul += p.x * p.y
		sumY += p.y
		sumYSquared += pow( p.y, 2.0 )
	}

	float d = list.len() * sumXSquared - pow( sumX, 2.0 )
	if ( fabs( d ) < 0.0001 )
	{
		return 0.0
	}

	return (list.len() * sumXYMul - sumX * sumY) / d
}
#endif


int function GetAttachTransition( entity rider, entity vehicle )
{
	// if ( RodeoState_GetIsVehicleBeingRodeoed( vehicle, eeAllegiance.ENEMY_ONLY ) )
	//     return RODEO_SENTINEL_TRANSITION_NONE // don't let the player hop on if there's an enemy already on it

	if ( RodeoState_CheckSpotsAreAvailable( vehicle, eRodeoSpots_Hoverbike.DRIVER ) )
	{
		return eRodeoTransitions_Hoverbike.ATTACH_DRIVER
	}

	if ( RodeoState_CheckSpotsAreAvailable( vehicle, eRodeoSpots_Hoverbike.PASSENGER_MIDDLE ) )
	{
		return eRodeoTransitions_Hoverbike.ATTACH_PASSENGER_MIDDLE
	}

	if ( RodeoState_CheckSpotsAreAvailable( vehicle, eRodeoSpots_Hoverbike.PASSENGER_REAR ) )
	{
		return eRodeoTransitions_Hoverbike.ATTACH_PASSENGER_REAR
	}

	return RODEO_SENTINEL_TRANSITION_NONE
}


void function OnRodeoStarting( entity rider, entity vehicle )
{
	#if SERVER
		thread WatchForPlayerSwitchingSpots( rider )
		//thread PROTO_PlayerViewConeThink( rider )
	#endif
	// todo(dw): predict spot change on client
	#if CLIENT
		if ( rider == GetLocalClientPlayer() )
		{
			AddPlayerHint( 7.0, 1.0, $"", "%&use% to detach\nPress %duck% to switch between driver/passenger" ) // todo(dw): !
		}
	#endif
}

#if SERVER
void function OnRodeoTransitionStarting( entity rider, entity vehicle, int beginSpotIndex, int endSpotIndex, int transitionIndex )
{
	if ( endSpotIndex == eRodeoSpots_Hoverbike.DRIVER )
	{
		vehicle.Signal( "HoverbikeStartup" )
	}
}
#endif

#if SERVER
void function OnRodeoRiderIdlesInSpot( entity rider, entity vehicle, int spotIndex )
{
	thread Blah( rider, vehicle, spotIndex )
}
void function Blah( entity rider, entity vehicle, int spotIndex )
{
	//int attachmentIndex
	//if ( spotIndex == eRodeoSpots_Hoverbike.DRIVER )
	//{
	//	attachmentIndex = vehicle.LookupAttachment( "DRIVER" )
	//}
	//else if ( spotIndex == eRodeoSpots_Hoverbike.PASSENGER_MIDDLE )
	//{
	//	attachmentIndex = vehicle.LookupAttachment( "PASSENGER_MIDDLE" )
	//}
	//else if ( spotIndex == eRodeoSpots_Hoverbike.PASSENGER_REAR )
	//{
	//	attachmentIndex = vehicle.LookupAttachment( "PASSENGER_REAR" )
	//}

	//vector localAttachmentOffset = RotateVector( vehicle.GetAttachmentOrigin( attachmentIndex ) - vehicle.GetOrigin(), AnglesInverse( vehicle.GetAngles() ) )
	//vector localAttachmentAngles = vehicle.GetAttachmentAngles( attachmentIndex )
	//vector worldAttachmentOffset = vehicle.GetAttachmentOrigin( attachmentIndex )
	//vector worldAttachmentAngles = vehicle.GetAttachmentAngles( attachmentIndex )
	//
	//rider.Anim_DisableUpdatePosition()
	//rider.GetFirstPersonProxy().Anim_DisableUpdatePosition()
	//rider.SetAbsOrigin( worldAttachmentOffset )
	//rider.SetAbsAngles( worldAttachmentAngles )
	//rider.GetFirstPersonProxy().SetAbsOrigin( worldAttachmentOffset )
	//rider.GetFirstPersonProxy().SetAbsAngles( worldAttachmentAngles )

	if ( spotIndex == eRodeoSpots_Hoverbike.DRIVER )
	{
		thread PROTO_ManageDriverCamera( rider, vehicle )

		rider.GetFirstPersonProxy().Anim_DisableUpdatePosition()
		rider.GetFirstPersonProxy().SetAbsOrigin( rider.GetFirstPersonProxy().GetOrigin() - 39.0 * AnglesToUp( vehicle.GetAngles() ) )
	}
	else
	{
		rider.GetFirstPersonProxy().Anim_DisableUpdatePosition()
		rider.GetFirstPersonProxy().SetAbsOrigin( rider.GetFirstPersonProxy().GetOrigin() - 22.0 * AnglesToUp( vehicle.GetAngles() ) )
	}
}
void function PROTO_ManageDriverCamera( entity rider, entity vehicle )
{
	vehicle.EndSignal( "OnDeath" )
	rider.EndSignal( "OnDeath" )
	rider.EndSignal( "RodeoEnding" )
	rider.EndSignal( "RodeoTransitionStarting" )

	entity camera// = CreateEntity( "point_viewcontrol" )

	OnThreadEnd(
		function() : ( rider, camera )
		{
			//if ( IsValid( rider ) )
			//{
			//	rider.ClearViewEntity()
			//}
			//if ( IsValid( camera ) )
			//{
			//	camera.Destroy()
			//}

			//rider.SetFOV( 1.0, 0.5 )
		}
	)

	//camera.kv.spawnflags = 56 // infinite hold time, snap to goal angles, make player non-solid
	//camera.SetOrigin( vehicle.GetWorldSpaceCenter() + RotateVector( <25, 0, 40>, vehicle.GetAngles() ) )
	//camera.SetAngles( vehicle.GetAngles() )
	//DispatchSpawn( camera )
	//camera.SetParent( vehicle )

	//rider.ClearParent()
	//rider.SetOrigin( camera.GetOrigin() )
	//rider.SetAngles( camera.GetAngles() )
	//rider.SetParent( camera )

	rider.DisableWorldSpacePlayerEyeAngles()

	//ViewConeZero( rider )

	rider.PlayerCone_SetLerpTime( 1.1 )
	rider.PlayerCone_FromAnim()
	rider.PlayerCone_SetMinYaw( 0 )
	rider.PlayerCone_SetMaxYaw( 0 )
	rider.PlayerCone_SetMinPitch( 6 )
	rider.PlayerCone_SetMaxPitch( 6 )

	wait 0.5

	//ViewConeNarrow( rider )

	//rider.SetViewEntity( camera, false )

	WaitForever()
}
#endif

void function OnRodeoFinishing( entity rider, entity vehicle )
{
	#if SERVER
		rider.SetVelocity( <0, 0, 0> )
	#endif
	#if CLIENT
		if ( rider == GetLocalClientPlayer() )
		{
			HidePlayerHint( "%&use% to detach\nPress %duck% to switch between driver/passenger" ) // todo(dw): !
		}
	#endif
}


#if SERVER
void function OnPlayerPressedChangeSpotsKey( entity rider )
{
	file.riderWantsToChangeSpotsMap[rider] = true
	rider.Signal( "WantsToChangeRodeoSpot" ) // registered in sh_titan_rodeo.nut ¯\_(ツ)_/¯
}
void function OnPlayerReleasedChangeSpotsKey( entity rider )
{
	file.riderWantsToChangeSpotsMap[rider] = false
}
void function WatchForPlayerSwitchingSpots( entity rider )
{
	rider.EndSignal( "OnDeath" )
	rider.EndSignal( "RodeoEnding" )

	file.riderWantsToChangeSpotsMap[rider] <- false

	AddButtonPressedPlayerInputCallback( rider, IN_DUCK, OnPlayerPressedChangeSpotsKey )
	AddButtonPressedPlayerInputCallback( rider, IN_DUCKTOGGLE, OnPlayerPressedChangeSpotsKey )

	AddButtonReleasedPlayerInputCallback( rider, IN_DUCK, OnPlayerReleasedChangeSpotsKey )
	AddButtonReleasedPlayerInputCallback( rider, IN_DUCKTOGGLE, OnPlayerReleasedChangeSpotsKey )

	OnThreadEnd( function() : ( rider ) {
		delete file.riderWantsToChangeSpotsMap[rider]

		RemoveButtonPressedPlayerInputCallback( rider, IN_DUCK, OnPlayerPressedChangeSpotsKey )
		RemoveButtonPressedPlayerInputCallback( rider, IN_DUCKTOGGLE, OnPlayerPressedChangeSpotsKey )

		RemoveButtonReleasedPlayerInputCallback( rider, IN_DUCK, OnPlayerReleasedChangeSpotsKey )
		RemoveButtonReleasedPlayerInputCallback( rider, IN_DUCKTOGGLE, OnPlayerReleasedChangeSpotsKey )
	} )

	while( true )
	{
		if ( file.riderWantsToChangeSpotsMap[rider] )
		{
			if ( !RodeoState_IsRiderBusy( rider ) )
			{
				entity vehicle  = RodeoState_GetPlayerCurrentRodeoVehicle( rider )
				int currentSpot = RodeoState_GetRiderCurrentSpot( rider )
				if ( currentSpot == eRodeoSpots_Hoverbike.DRIVER )
				{
					if ( RodeoState_CheckSpotsAreAvailable( vehicle, eRodeoSpots_Hoverbike.PASSENGER_MIDDLE ) )
						Rodeo_TriggerTransitionAndWait( rider, eRodeoTransitions_Hoverbike.SHIFT_FROM_DRIVER_TO_PASSENGER_MIDDLE )
					else if ( RodeoState_CheckSpotsAreAvailable( vehicle, eRodeoSpots_Hoverbike.PASSENGER_REAR ) )
						Rodeo_TriggerTransitionAndWait( rider, eRodeoTransitions_Hoverbike.SHIFT_FROM_DRIVER_TO_PASSENGER_REAR )
				}
				else if ( currentSpot == eRodeoSpots_Hoverbike.PASSENGER_MIDDLE )
				{
					if ( RodeoState_CheckSpotsAreAvailable( vehicle, eRodeoSpots_Hoverbike.DRIVER ) )
						Rodeo_TriggerTransitionAndWait( rider, eRodeoTransitions_Hoverbike.SHIFT_FROM_PASSENGER_MIDDLE_TO_DRIVER )
					else if ( RodeoState_CheckSpotsAreAvailable( vehicle, eRodeoSpots_Hoverbike.PASSENGER_REAR ) )
						Rodeo_TriggerTransitionAndWait( rider, eRodeoTransitions_Hoverbike.SHIFT_FROM_PASSENGER_MIDDLE_TO_PASSENGER_REAR )
				}
				else if ( currentSpot == eRodeoSpots_Hoverbike.PASSENGER_REAR )
				{
					if ( RodeoState_CheckSpotsAreAvailable( vehicle, eRodeoSpots_Hoverbike.DRIVER ) )
						Rodeo_TriggerTransitionAndWait( rider, eRodeoTransitions_Hoverbike.SHIFT_FROM_PASSENGER_REAR_TO_DRIVER )
					else if ( RodeoState_CheckSpotsAreAvailable( vehicle, eRodeoSpots_Hoverbike.PASSENGER_MIDDLE ) )
						Rodeo_TriggerTransitionAndWait( rider, eRodeoTransitions_Hoverbike.SHIFT_FROM_PASSENGER_REAR_TO_PASSENGER_MIDDLE )
				}
			}
			WaitFrame()
		}
		else
		{
			rider.WaitSignal( "WantsToChangeRodeoSpot" )
		}
	}
}
#endif

//#if SERVER
//void function PROTO_PlayerViewConeThink( entity rider )
//{
//	rider.EndSignal( "RodeoEnded" )
//
//	OnThreadEnd( function() : ( rider ) {
//		rider.PlayerCone_Disable() // let the player look around
//	} )
//
//	while( true )
//	{
//		int currentSpot = RodeoState_GetRiderCurrentSpot( rider )
//		if ( currentSpot == eRodeoSpots_Hoverbike.DRIVER )
//		{
//			entity vehicle = RodeoState_GetPlayerCurrentRodeoVehicle( rider )
//			rider.PlayerCone_SetMinYaw( 0 )
//			rider.PlayerCone_SetMaxYaw( 0 )
//			rider.PlayerCone_SetMinPitch( 0 )
//			rider.PlayerCone_SetMaxPitch( 0 )
//			rider.PlayerCone_SetSpecific( AnglesCompose( vehicle.GetAngles(), <0, 0, 0> ) )
//		}
//		else
//		{
//			rider.PlayerCone_Disable() // let the player look around
//		}
//
//		WaitFrame()
//	}
//}
//#endif

