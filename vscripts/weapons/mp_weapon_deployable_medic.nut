global function MpWeaponDeployableMedic_Init

global function OnWeaponTossReleaseAnimEvent_weapon_deployable_medic
global function OnWeaponAttemptOffhandSwitch_weapon_deployable_medic
global function OnWeaponTossPrep_weapon_deployable_medic

#if CLIENT
global function CanDeployHealDrone
#endif

const asset DEPLOYABLE_MEDIC_DRONE_MODEL = $"mdl/props/lifeline_drone/lifeline_drone.rmdl"

//Deployment Vars
const float DEPLOYABLE_MEDIC_THROW_POWER = 25.0
const float DEPLOYABLE_MEDIC_ICON_HEIGHT = 32.0

//Heal Vars
const int DEPLOYABLE_MEDIC_HEAL_MAX_TARGETS = 3
const float DEPLOYABLE_MEDIC_HEAL_START_DELAY = 1.0
const float DEPLOYABLE_MEDIC_HEAL_RADIUS = 128.0
const int DEPLOYABLE_MEDIC_HEAL_AMOUNT = 150
const float DEPLOYABLE_MEDIC_MAX_LIFETIME = 20
//const float DEPLOYABLE_MEDIC_MIN_LIFETIME = 4
const float DEPLOYABLE_MEDIC_HEAL_PER_SEC = 5

const ROPE_LENGTH = DEPLOYABLE_MEDIC_HEAL_RADIUS + 50
const ROPE_NODE_COUNT = 10
const ROPE_SHOOT_OUT_TIME = 0.25
const ROPE_REAL_IN_TIME = 0.25

const int DEPLOYABLE_MEDIC_RESOURCE_FULL_SKIN_INDEX = 0
const int DEPLOYABLE_MEDIC_RESOURCE_HALF_SKIN_INDEX = 2
const int DEPLOYABLE_MEDIC_RESOURCE_LOW_SKIN_INDEX = 1

global const string DEPLOYABLE_MEDIC_HOVER_SOUND		= "Lifeline_Drone_Mvmt_Hover"
const string DEPLOYABLE_MEDIC_DEPLOY_CABLE_SOUND		= "Lifeline_Drone_Cable_Deploy_3P"
const string DEPLOYABLE_MEDIC_ATTACH_SOUND_1P			= "Lifeline_Drone_Attach_1P"
const string DEPLOYABLE_MEDIC_ATTACH_SOUND_3P			= "Lifeline_Drone_Attach_3P"
const string DEPLOYABLE_MEDIC_DETATCH_SOUND_1P			= "Lifeline_Drone_Detach_1P"
const string DEPLOYABLE_MEDIC_DETATCH_SOUND_3P			= "Lifeline_Drone_Detach_3P"
const string DEPLOYABLE_MEDIC_HEAL_LOOP_SOUND_1P		= "Lifeline_Drone_Healing_1P" //Plays on the player when being healed.
const string DEPLOYABLE_MEDIC_HEAL_LOOP_SOUND_3P		= "Lifeline_Drone_Healing_3P" //Plays on the drone when healing someone.
global const string DEPLOYABLE_MEDIC_DISSOLVE_SOUND		= "Lifeline_Drone_Dissolve"
global const string DEPLOYABLE_MEDIC_DEPLOY_SOUND 		= ""

const vector DRONE_MINS = <-9, -9, -10>
const vector DRONE_MAXS = <9, 9, 10>

const FX_DRONE_MEDIC_OPEN				= $"P_LL_med_drone_open"
const FX_DRONE_MEDIC_JET_CTR			= $"P_LL_med_drone_jet_ctr_loop"
const FX_DRONE_MEDIC_EYE				= $"P_LL_med_drone_eye"
const FX_DRONE_MEDIC_JET_LOOP			= $"P_LL_med_drone_jet_loop"

const FX_DRONE_MEDIC_HEAL_COCKPIT_FX	= $"P_heal_loop_screen"

struct HealRopeData
{
	entity ropeStartEnt
	entity playerRope
	entity playerRopeEndEnt
	entity otherRope
	entity otherRopeEndEnt
	int    statusEffectHandle
}

struct HealData
{
	entity healTarget
	int	   healResourceID
}

struct SignalStruct
{
	entity trigger
	entity player
}

struct HealDeployableData
{
	int                 healResource = DEPLOYABLE_MEDIC_HEAL_AMOUNT
	array<entity>       healTargets = []
	array<HealData>     healDataArray = []
	array<entity>       particles = []
}

struct
{
	#if SERVER
		table< entity, HealDeployableData > deployableData
		array<SignalStruct> signalStructArray
	#else
		int healFxHandle
	#endif
} file

void function MpWeaponDeployableMedic_Init()
{
	RegisterSignal( "DeployableMedic_HealDepleated" )
	RegisterSignal( "DeployableMedic_HealAborted" )
	RegisterSignal( "DeployableMedic_Attached" )
	RegisterSignal( "DeployableMedic_LeftHealingTrigger" )
	RegisterSignal( "CleanupAllDroneMedics" )

	PrecacheModel( DEPLOYABLE_MEDIC_DRONE_MODEL )
	PrecacheMaterial(  $"models/cable/drone_medic_cable"  )

	PrecacheParticleSystem( FX_DRONE_MEDIC_OPEN )
	PrecacheParticleSystem( FX_DRONE_MEDIC_JET_CTR )
	PrecacheParticleSystem( FX_DRONE_MEDIC_EYE )
	PrecacheParticleSystem( FX_DRONE_MEDIC_JET_LOOP	)

	PrecacheParticleSystem( FX_DRONE_MEDIC_HEAL_COCKPIT_FX	)

	#if SERVER
		AddDamageCallback( "player", DeployableMedic_PlayerOnDamage )
	#endif

	#if CLIENT
		AddCreateCallback( "script_mover", DeployableMedic_OnPropScriptCreated )

		StatusEffect_RegisterEnabledCallback( eStatusEffect.drone_healing, DeployableMedic_HealVisualsEnabled )
		StatusEffect_RegisterDisabledCallback( eStatusEffect.drone_healing, DeployableMedic_HealVisualsDisabled )
	#endif
}


bool function OnWeaponAttemptOffhandSwitch_weapon_deployable_medic( entity weapon )
{
	int ammoReq  = weapon.GetAmmoPerShot()
	int currAmmo = weapon.GetWeaponPrimaryClipCount()
	if ( currAmmo < ammoReq )
		return false

	entity player = weapon.GetWeaponOwner()
	if ( player.IsPhaseShifted() )
		return false

	return true
}


var function OnWeaponTossReleaseAnimEvent_weapon_deployable_medic( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	int ammoReq = weapon.GetAmmoPerShot()
	weapon.EmitWeaponSound_1p3p( GetGrenadeThrowSound_1p( weapon ), GetGrenadeThrowSound_3p( weapon ) )

	entity deployable = ReleaseDrone( weapon, attackParams, DEPLOYABLE_MEDIC_THROW_POWER, OnDeployableMedicPlanted )
	if ( deployable )
	{
		entity player = weapon.GetWeaponOwner()
		PlayerUsedOffhand( player, weapon )

		#if SERVER
			deployable.e.burnmeter_wasPreviouslyDeployed = weapon.e.burnmeter_wasPreviouslyDeployed

			string projectileSound = GetGrenadeProjectileSound( weapon )
			if ( projectileSound != "" )
				EmitSoundOnEntity( deployable, projectileSound )

			weapon.w.lastProjectileFired = deployable
			deployable.e.burnReward = weapon.e.burnReward
		#endif
	}

	return ammoReq
}


entity function ReleaseDrone( entity weapon, WeaponPrimaryAttackParams attackParams, float throwPower, void functionref(entity) deployFunc, vector ornull angularVelocity = null )
{
	#if CLIENT
		if ( !weapon.ShouldPredictProjectiles() )
			return null
	#endif

	entity player = weapon.GetWeaponOwner()

	vector attackPos
	if ( IsValid( player ) )
		attackPos = GetDroneThrowStartPos( player, attackParams.pos )
	else
		attackPos = attackParams.pos

	vector angles   = VectorToAngles( attackParams.dir )
	vector velocity = GetDroneThrowVelocity( player, angles, throwPower )
	if ( angularVelocity == null )
		angularVelocity = <600, RandomFloatRange( -300, 300 ), 0>
	expect vector( angularVelocity )

	float fuseTime = 0.0    // infinite

	bool isPredicted = PROJECTILE_PREDICTED
	if ( player.IsNPC() )
		isPredicted = PROJECTILE_NOT_PREDICTED

	WeaponFireGrenadeParams fireGrenadeParams
	fireGrenadeParams.pos = attackPos
	fireGrenadeParams.vel = velocity
	fireGrenadeParams.angVel = angularVelocity
	fireGrenadeParams.fuseTime = fuseTime
	fireGrenadeParams.scriptTouchDamageType = damageTypes.explosive
	fireGrenadeParams.scriptExplosionDamageType = damageTypes.explosive
	fireGrenadeParams.clientPredicted = isPredicted
	fireGrenadeParams.lagCompensated = true
	fireGrenadeParams.useScriptOnDamage = true
	entity deployable = weapon.FireWeaponGrenade( fireGrenadeParams )

	if ( deployable )
	{
		deployable.SetAngles( <0, angles.y - 180, 0> )
	#if SERVER
		deployFunc( deployable )
	#endif
	}

	return deployable
}


vector function GetDroneThrowStartPos( entity player, vector baseStartPos )
{
	// shouldn't I be able to get the position of the viewmodel version so that they match perfectly. - Roger
	vector attackPos = player.OffsetPositionFromView( baseStartPos, <20, 0, 2.5> )    // forward, right, up
	return attackPos
}


vector function GetDroneThrowVelocity( entity player, vector baseAngles, float throwPower )
{
	baseAngles += <-8, 0, 0>
	vector forward = AnglesToForward( baseAngles )

	if ( baseAngles.x < 80 )
		throwPower = GraphCapped( baseAngles.x, 0, 80, throwPower, throwPower * 3 )

	vector velocity = forward * throwPower

	return velocity
}


void function OnWeaponTossPrep_weapon_deployable_medic( entity weapon, WeaponTossPrepParams prepParams )
{
	weapon.EmitWeaponSound_1p3p( GetGrenadeDeploySound_1p( weapon ), GetGrenadeDeploySound_3p( weapon ) )

	#if SERVER
	PlayBattleChatterLineToSpeakerAndTeam( weapon.GetWeaponOwner(), "bc_tactical" )
	#endif
}


void function OnDeployableMedicPlanted( entity projectile )
{
#if SERVER
	thread DeployMedicCanister( projectile )
#endif
}

#if SERVER
void function DeployMedicCanister( entity projectile )
{
	if ( !IsValid( projectile ) )
		return

	const PROJECTILE_DRIFT_TIME = 0.5
	wait PROJECTILE_DRIFT_TIME

	// can't EndSignal on the projectile because that will end the thread prematurely.
	if ( !IsValid( projectile ) )
		return

	vector origin   = projectile.GetOrigin()
	vector angles   = projectile.GetAngles()
	vector velocity = projectile.GetVelocity()
	entity owner    = projectile.GetOwner()
	entity _parent  = projectile.GetParent()

	if ( !IsValid( owner ) )
	{
		if ( IsValid( projectile ) )
			projectile.Destroy()
		return
	}

	owner.EndSignal( "OnDestroy" )
	owner.EndSignal( "CleanupAllDroneMedics" )

	if ( IsValid( projectile ) )
	{
		// Destroy the projectile in the next snapshot so the projectile will be in the final position
		// when it is removed from clients. This is used to prevent a pop between the projectile position and the
		// final script mover drone position.
		projectile.kv.solid = 0
		projectile.Hide()
		projectile.SetProjectileLifetime( .04 )
	}

	entity droneMedic = CreateEntity( "script_mover" )
	droneMedic.kv.solid = SOLID_VPHYSICS
	droneMedic.kv.fadedist = -1
	droneMedic.SetValueForModelKey( DEPLOYABLE_MEDIC_DRONE_MODEL )
	droneMedic.e.isDoorBlocker = true
	droneMedic.SetOrigin( origin )
	droneMedic.SetAngles( angles )
	DispatchSpawn( droneMedic )

	droneMedic.EndSignal( "OnDestroy" )

	droneMedic.kv.collisionGroup = TRACE_COLLISION_GROUP_BLOCK_WEAPONS
	droneMedic.DisableHibernation()
	droneMedic.SetMaxHealth( 100 )
	droneMedic.SetHealth( 100 )
	droneMedic.SetTakeDamageType( DAMAGE_EVENTS_ONLY )
	droneMedic.SetDamageNotifications( false )
	droneMedic.SetDeathNotifications( false )
	droneMedic.SetArmorType( ARMOR_TYPE_HEAVY )
	droneMedic.SetScriptName( "deployable_medic" )
	droneMedic.SetBlocksRadiusDamage( false )
	droneMedic.SetTitle( "" )
	droneMedic.SetOwner( owner )
	SetTeam( droneMedic, owner.GetTeam() )
	SetTargetName( droneMedic, "#WPN_TITAN_SLOW_TRAP" )
	SetObjectCanBeMeleed( droneMedic, false )
	SetVisibleEntitiesInConeQueriableEnabled( droneMedic, false )
	droneMedic.RemoveFromAllRealms()
	droneMedic.AddToOtherEntitysRealms( owner )
	thread TrapDestroyOnRoundEnd( owner, droneMedic )

	//make npc's fire at their own traps to cut off lanes
	if ( owner.IsNPC() )
	{
		owner.SetSecondaryEnemy( droneMedic )
		droneMedic.EnableAttackableByAI( AI_PRIORITY_NO_THREAT, 0, AI_AP_FLAG_NONE )        // don't let other AI target this
	}

	//Define a data struct for this healing device.
	HealDeployableData hData
	hData.healResource = DEPLOYABLE_MEDIC_HEAL_AMOUNT

	file.deployableData[ droneMedic ] <- hData

	//Register Canister so that it is detected by sonar.
	droneMedic.Highlight_Enable()
	AddSonarDetectionForPropScript( droneMedic )

	TrackingVision_CreatePOI( eTrackingVisionNetworkedPOITypes.PLAYER_ABILITY_DEPLOYABLE_MEDIC, owner, droneMedic.GetOrigin(), owner.GetTeam(), owner )

	thread DroneMedicHoverThink( droneMedic, velocity )

	thread DroneMedicAnims( droneMedic )

	entity wp = CreateWaypoint_Ping_Location( owner, ePingType.ABILITY_DRONEMEDIC, droneMedic, droneMedic.GetOrigin(), -1, false )
	wp.SetAbsOrigin( droneMedic.GetOrigin() + <0,0,8> )
	wp.SetParent( droneMedic )

	OnThreadEnd(
		function() : ( droneMedic, wp )
		{
			if ( IsValid( wp ) )
				wp.Destroy()

			foreach( particle in file.deployableData[ droneMedic ].particles )
				particle.Destroy()

			delete file.deployableData[ droneMedic ]

			if ( IsValid( droneMedic ) )
			{
				StopSoundOnEntity( droneMedic, DEPLOYABLE_MEDIC_HOVER_SOUND )
				EmitSoundAtPosition( TEAM_UNASSIGNED, droneMedic.GetOrigin(), DEPLOYABLE_MEDIC_DISSOLVE_SOUND )

				RemoveSonarDetectionForPropScript( droneMedic )
				droneMedic.ClearParent()
				droneMedic.Dissolve( ENTITY_DISSOLVE_CORE, <0, 0, 0>, 500 )
			}
		}
	)

	waitthread DeployableMedic_CreateHealTriggerArea( owner, droneMedic )
}

void function DroneMedicAnims( entity droneMedic )
{
	EndSignal( droneMedic, "OnDestroy" )

	entity owner = droneMedic.GetOwner()
	EndSignal( owner, "OnDestroy" )
	EndSignal( owner, "CleanupAllDroneMedics" )
	EndSignal( droneMedic, "DeployableMedic_HealDepleated" )

	droneMedic.SetSkin( 1)

	int fxID_VENT   = droneMedic.LookupAttachment( "VENT_BOT" )
	int fxID_EYE    = droneMedic.LookupAttachment( "EYEGLOW" )
	int fxID_RF     = droneMedic.LookupAttachment( "VENT_RF" )
	int fxID_LF     = droneMedic.LookupAttachment( "VENT_LF" )
	int fxID_RR     = droneMedic.LookupAttachment( "VENT_RR" )
	int fxID_LR     = droneMedic.LookupAttachment( "VENT_LR" )

	file.deployableData[ droneMedic ].particles.append( StartParticleEffectOnEntity_ReturnEntity( droneMedic, GetParticleSystemIndex( FX_DRONE_MEDIC_JET_CTR ), FX_PATTACH_POINT_FOLLOW, fxID_VENT ) )
	file.deployableData[ droneMedic ].particles.append( StartParticleEffectOnEntity_ReturnEntity( droneMedic, GetParticleSystemIndex( FX_DRONE_MEDIC_EYE ), FX_PATTACH_POINT_FOLLOW, fxID_EYE ) )

	EmitSoundOnEntity( droneMedic, DEPLOYABLE_MEDIC_HOVER_SOUND )

	waitthread PlayAnim( droneMedic, "lifeline_drone_arming" )

	// still looking for a repro of this. But these lines should stop the servers from crashing.
	Assert( droneMedic in file.deployableData )
	if ( !( droneMedic in file.deployableData ) )
		return

	file.deployableData[ droneMedic ].particles.append( StartParticleEffectOnEntity_ReturnEntity( droneMedic, GetParticleSystemIndex( FX_DRONE_MEDIC_JET_LOOP ), FX_PATTACH_POINT_FOLLOW, fxID_RF ) )
	file.deployableData[ droneMedic ].particles.append( StartParticleEffectOnEntity_ReturnEntity( droneMedic, GetParticleSystemIndex( FX_DRONE_MEDIC_JET_LOOP ), FX_PATTACH_POINT_FOLLOW, fxID_LF ) )
	file.deployableData[ droneMedic ].particles.append( StartParticleEffectOnEntity_ReturnEntity( droneMedic, GetParticleSystemIndex( FX_DRONE_MEDIC_JET_LOOP ), FX_PATTACH_POINT_FOLLOW, fxID_RR ) )
	file.deployableData[ droneMedic ].particles.append( StartParticleEffectOnEntity_ReturnEntity( droneMedic, GetParticleSystemIndex( FX_DRONE_MEDIC_JET_LOOP ), FX_PATTACH_POINT_FOLLOW, fxID_LR ) )

	droneMedic.Anim_Play( "lifeline_drone_floating" )
}

void function DroneMedicHoverThink( entity droneMedic, vector velocity )
{
	EndSignal( droneMedic, "OnDestroy" )

	const DECEL_TIME = 0.5
	const SETTLE_HEIGHT = 24
	const TRACE_HEIGHT = 128
	const TRACE_HEIGHT_HIGH = 1024
	const CLEAR_HOVER_DIST = 48
	const YAW_RATE = 2000
	const BOB_FREQUENCY = 2
	const BOB_SCALE = 1
	const MAX_SPEED = 256
	const MAX_SPEED_DIST = 192*192
	const BASE_SPEED_DIST = 32*32

	float traceHeight = TRACE_HEIGHT
	entity owner = droneMedic.GetOwner()
	if ( IsValid( owner) && owner.IsPlayer() )
	{
		//  if the player is using the drone while jumping off a building or some such.
		bool useTraceHeightHigh = false
		float zDiff = owner.GetOrigin().z - droneMedic.GetOrigin().z

		if ( zDiff < -TRACE_HEIGHT )
			useTraceHeightHigh = true

		if ( !useTraceHeightHigh && !owner.IsOnGround() )
		{
			float frac = TraceLineSimple( owner.EyePosition(), owner.EyePosition() + <0,0,-TRACE_HEIGHT>, owner )
			if ( frac == 1 )
				useTraceHeightHigh = true
		}

		if ( useTraceHeightHigh )
			traceHeight = TRACE_HEIGHT_HIGH
	}

	float baseSpeed = Length( velocity )
	vector deployVec = Normalize( velocity )
	vector deployOrigin = droneMedic.GetOrigin()
	vector deployDest   = deployOrigin + (velocity * (DECEL_TIME / 2.0))

	TraceResults groundTraceResult = TraceHull( deployDest, deployDest - <0, 0, traceHeight>, DRONE_MINS, DRONE_MAXS, droneMedic, TRACE_MASK_NPCWORLDSTATIC, TRACE_COLLISION_GROUP_NONE )
	entity groundEnt = groundTraceResult.hitEnt ? groundTraceResult.hitEnt.GetRootMoveParent() : null
	droneMedic.SetGroundEntity( groundEnt ) // Setting the ground entity allows it to stay on top of moving geo
	droneMedic.SetYawRate( YAW_RATE )
	droneMedic.SetDesiredYaw( droneMedic.GetAngles().y )
	droneMedic.SetBobScale( BOB_SCALE )
	droneMedic.SetBobFrequency( BOB_FREQUENCY )
	droneMedic.SetMaxSpeed( baseSpeed )
	droneMedic.SetMinimalHeightGround( SETTLE_HEIGHT, CLEAR_HOVER_DIST )

	vector moveToPosition = droneMedic.GetOrigin()
	if ( IsValid( groundEnt ) )
		moveToPosition = groundTraceResult.endPos + < 0, 0, SETTLE_HEIGHT >

	droneMedic.SetMoveToPositionGround( moveToPosition, groundEnt )

	//DebugDrawLine( deployOrigin, deployDest, 255, 0, 0, true, 2 )
	//DebugDrawLine( deployDest, groundTraceResult.endPos, 0, 255, 0, true, 2 )
	//DrawStar( moveToPosition, 2, 5, true )

	bool wasStuck = false
	while( true )
	{
		bool isHealing = DeployableMedic_GetHealTargetCount( droneMedic ) > 0

		// trace to ground
		groundTraceResult = TraceHull( droneMedic.GetOrigin(), droneMedic.GetOrigin() - <0, 0, traceHeight>, DRONE_MINS, DRONE_MAXS, droneMedic, TRACE_MASK_NPCWORLDSTATIC, TRACE_COLLISION_GROUP_NONE )
		vector hoverOrigin = groundTraceResult.endPos + <0, 0, SETTLE_HEIGHT>

		entity newGroundEnt = groundTraceResult.hitEnt ? groundTraceResult.hitEnt.GetRootMoveParent() : null
		if ( !isHealing && !CanDroneHoverTo( droneMedic, hoverOrigin ) )
		{
			// lets the drone hover lower
			if ( !wasStuck )
				droneMedic.SetMinimalHeightGround( 12, CLEAR_HOVER_DIST )
			wasStuck = true

			vector ornull clearVector = GetClearHoverVector( droneMedic, deployOrigin, CLEAR_HOVER_DIST )
			if ( clearVector == null )
			{
				// lets try for ever
				WaitFrame()
				continue
			}
			expect vector( clearVector )

			groundEnt = newGroundEnt
			droneMedic.SetGroundEntity( newGroundEnt )
			vector hoverDest = droneMedic.GetOrigin() + clearVector * CLEAR_HOVER_DIST
			droneMedic.SetMoveToPositionGround( hoverDest, newGroundEnt )
		}
		else if ( groundEnt != newGroundEnt && IsValid( newGroundEnt ) )
		{
			groundEnt = newGroundEnt
			droneMedic.SetGroundEntity( groundEnt )
			droneMedic.SetMoveToPositionGround( groundTraceResult.endPos + <0, 0, SETTLE_HEIGHT>, groundEnt )
		}
		else if ( isHealing )
		{
			droneMedic.SetMoveToPositionGround( droneMedic.GetOrigin(), groundEnt )
		}
		else if ( wasStuck )
		{
			droneMedic.SetMinimalHeightGround( SETTLE_HEIGHT, CLEAR_HOVER_DIST )
			wasStuck = false
		}

		float distSqr = DistanceSqr( droneMedic.GetMoveToPositionWorld(), droneMedic.GetOrigin() )
		float speed = GraphCapped( distSqr, BASE_SPEED_DIST, MAX_SPEED_DIST, baseSpeed, MAX_SPEED )
		droneMedic.SetMaxSpeed( speed )

		//DrawStar( droneMedic.GetMoveToPositionWorld(), 2, 0.5, true )
		WaitFrame()
	}
}

vector ornull function GetClearHoverVector( entity droneMedic, vector deployOrigin, float minClearDist )
{
	const TRACE_LENGTH = 64
	const ANGLE_STEP = 360 / 8

	float minFrac = minClearDist / TRACE_LENGTH

	vector traceVec = < 1, 0, 0 >
	for ( int angle = 0; angle < 360; angle += ANGLE_STEP )
	{
		vector traceOrigin = droneMedic.GetOrigin() + traceVec * TRACE_LENGTH
		float frac = TraceHullSimple( droneMedic.GetOrigin(), traceOrigin, DRONE_MINS, DRONE_MAXS, droneMedic )

		//DebugDrawLine( droneMedic.GetOrigin(), traceOrigin, 92, 92, 255, true, 2.0 )
		vector endPoint = droneMedic.GetOrigin() + traceVec * TRACE_LENGTH * frac
		//DebugDrawLine( endPoint, endPoint + <0,0,16>, 255, 0, 0, true, 2.0 )


		if ( frac >= minFrac )
			return traceVec
		traceVec = RotateVector( traceVec, < 0, ANGLE_STEP, 0 > )
	}

	return null
}

bool function CanDroneHoverTo( entity droneMedic, vector destOrigin )
{
	TraceResults result = TraceHull( droneMedic.GetOrigin(), destOrigin, DRONE_MINS, DRONE_MAXS, droneMedic, TRACE_MASK_NPCWORLDSTATIC, TRACE_COLLISION_GROUP_NONE )
	//	float frac = TraceHullSimple( droneMedic.GetOrigin(), destOrigin, DRONE_MINS, DRONE_MAXS, droneMedic )

	if ( result.fraction == 1.0 && !result.startSolid )
		return true

	return false
}

//This heal mechanic is team agnostic meaning that any player can be healed even if they are an enemy of the medic who dropped it.
void function DeployableMedic_CreateHealTriggerArea( entity owner, entity droneMedic )
{
	Assert ( IsNewThread(), "Must be threaded off" )
	droneMedic.EndSignal( "OnDestroy" )
	droneMedic.EndSignal( "DeployableMedic_HealDepleated" )
	owner.EndSignal( "CleanupAllDroneMedics" )

	vector origin = droneMedic.GetOrigin()

	entity trigger = CreateEntity( "trigger_cylinder" )
	trigger.SetOwner( droneMedic )
	trigger.SetRadius( DEPLOYABLE_MEDIC_HEAL_RADIUS )
	trigger.SetAboveHeight( 92 )
	trigger.SetBelowHeight( 48 )
	trigger.SetOrigin( origin )
	trigger.SetPhaseShiftCanTouch( false )
	//	trigger.kv.triggerFilterPhaseShift = "nonphaseshift"
	//	trigger.kv.triggerFilterNonCharacter = "0"
	DispatchSpawn( trigger )

	//DebugDrawCylinder( origin, < -90,0,0 >, DEPLOYABLE_MEDIC_HEAL_RADIUS, 128, 255, 0, 0, true, 20.0 )
	//DebugDrawCylinder( origin, < 90,0,0 >, DEPLOYABLE_MEDIC_HEAL_RADIUS, 128, 255, 0, 0, true, 20.0 )

	trigger.RemoveFromAllRealms()
	trigger.AddToOtherEntitysRealms( droneMedic )

	trigger.SetEnterCallback( OnDeployableMedicHealAreaEnter )
	trigger.SetLeaveCallback( OnDeployableMedicHealAreaLeave )

	trigger.SetOrigin( origin )

	//Parent trigger to health kit so trigger will follow moving geo.
	trigger.SetParent( droneMedic, "", true, 0.0 )
	trigger.SearchForNewTouchingEntity()

	OnThreadEnd(
		function() : ( trigger )
		{
			if ( IsValid( trigger ) )
				trigger.Destroy()
		}
	)

	waitthread DeployableMedic_DeployableHealUpdate( trigger, droneMedic )
}

void function OnDeployableMedicHealAreaEnter( entity trigger, entity ent )
{
	// this could be removed once the trigger no longer gets triggered by ents in different realms. bug R5DEV-46753
	if ( !trigger.DoesShareRealms( ent ) )
		return

	if ( ent.IsPlayer() )
	{
		//	printt( "PLAYER " + ent + " STARTED TOUCHING TRIGGER " + trigger )
		thread DeployableMedic_PlayerHealUpdate( trigger, ent )
	}
	else if ( IsSurvivalTraining() && ent.GetScriptName() == "survival_training_target_dummy" ) // need to check share realm?
	{
		thread DeployableMedic_PlayerHealUpdate( trigger, ent )
	}
}

void function OnDeployableMedicHealAreaLeave( entity trigger, entity ent )
{
	SignalSignalStruct( trigger, ent, "DeployableMedic_LeftHealingTrigger" )
}

SignalStruct function CreateSignalStruct( entity trigger, entity player )
{
	SignalStruct singalStruct
	singalStruct.player = player
	singalStruct.trigger = trigger
	file.signalStructArray.append( singalStruct )

	return singalStruct
}

void function SignalSignalStruct( entity trigger, entity player, string signal )
{
	foreach( signalStruct in file.signalStructArray )
	{
		if ( signalStruct.trigger == trigger && signalStruct.player == player )
			Signal( signalStruct, signal )
	}
}

void function DestroySignalStruct( SignalStruct singalStruct )
{
	file.signalStructArray.fastremovebyvalue( singalStruct )
}

void function DeployableMedic_PlayerHealUpdate( entity trigger, entity player )
{
	Assert ( IsNewThread(), "Must be threaded off." )

	printt( "STARTING HEAL UPDATE FOR PLAYER " + player + " FOR TRIGGER " + trigger )
	//printt( "PLAYER " + player + " IS PHASESHIFTED: " + player.IsPhaseShifted() )

	SignalStruct singalStruct = CreateSignalStruct( trigger, player )
	EndSignal( singalStruct, "DeployableMedic_LeftHealingTrigger" )

	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )
	trigger.EndSignal( "OnDestroy" )

	entity droneMedic = trigger.GetOwner()
	droneMedic.EndSignal( "DeployableMedic_HealDepleated" )

	HealRopeData ropeData = DeployableMedic_CreateHealRope( droneMedic )

	OnThreadEnd(
		function() : ( player, droneMedic, ropeData, singalStruct )
		{
			thread DeployableMedic_RetractHealRope( ropeData )
			if ( IsValid( player ) && player.IsPlayer() )
				StatusEffect_Stop( player, ropeData.statusEffectHandle )

			if ( IsValid( droneMedic ) && IsValid( player ) )
			{
				if ( droneMedic in file.deployableData && file.deployableData[ droneMedic ].healTargets.contains( player ) )
					DeployableMedic_ReleasePlayerAsHealTarget( droneMedic, player )
			}

			DestroySignalStruct( singalStruct )
		}
	)

	float startTime = Time()

	while( trigger.IsTouching( player ) )
	{
		//printt( "PLAYER " + player + " IS TOUCHING TRIGGER" )
		WaitFrame()

		//Wait until a heal slot opens up for this player.
		if ( DeployableMedic_GetHealTargetCount( droneMedic ) >= DEPLOYABLE_MEDIC_HEAL_MAX_TARGETS || !DeployableMedic_ShouldAttemptHeal( player, droneMedic ) )
		{
			startTime = Time()
			continue
		}

		if ( Time() - startTime < DEPLOYABLE_MEDIC_HEAL_START_DELAY )
		{
			//This player hasn't been in the heal area long enough
			continue
		}
		else
		{
			//Claim this player as a heal target
			EmitSoundOnEntity( droneMedic, DEPLOYABLE_MEDIC_DEPLOY_CABLE_SOUND )
			DeployableMedic_ClaimPlayerAsHealTarget( droneMedic, player )
			thread DeployableMedic_DeployHealRope( ropeData, player )
			if ( player.IsPlayer() )
				ropeData.statusEffectHandle = StatusEffect_AddEndless( player, eStatusEffect.drone_healing, 1 )
		}

		waitthread DeployableMedic_WaitForHeal( player, droneMedic, ropeData, trigger )

		//Release this player as a heal target.
		DeployableMedic_ReleasePlayerAsHealTarget( droneMedic, player )
		thread DeployableMedic_RetractHealRope( ropeData )
		if ( player.IsPlayer() )
			StatusEffect_Stop( player, ropeData.statusEffectHandle )
		startTime = Time()
	}
}

void function DeployableMedic_WaitForHeal( entity player, entity droneMedic, HealRopeData ropeData, entity trigger )
{
	EndSignal( player, "DeployableMedic_HealAborted" )

	if ( DeployableMedic_ShouldAttemptHeal( player, droneMedic ) && player.IsPlayer() )
		EmitSoundOnEntityOnlyToPlayer( player, player, DEPLOYABLE_MEDIC_HEAL_LOOP_SOUND_1P )

	OnThreadEnd(
	function() : ( player )
		{
			if ( IsValid( player ) )
				StopSoundOnEntity( player, DEPLOYABLE_MEDIC_HEAL_LOOP_SOUND_1P )
		}
	)

	while( DeployableMedic_ShouldAttemptHeal( player, droneMedic ) && trigger.IsTouching( player ) )
	{
		SetRopeLength( player, droneMedic, ropeData )
		WaitFrame()
	}
}

void function DeployableMedic_DeployableHealUpdate( entity trigger, entity droneMedic )
{
	Assert ( IsNewThread(), "Must be threaded off." )
	trigger.EndSignal( "OnDestroy" )
	droneMedic.EndSignal( "OnDestroy" )

	OnThreadEnd(
		function() : ( droneMedic )
		{
			if ( IsValid( droneMedic ) )
			{
				StopSoundOnEntity( droneMedic, DEPLOYABLE_MEDIC_HEAL_LOOP_SOUND_3P )

				array<HealData> healOverTimeArray = file.deployableData[ droneMedic ].healDataArray
				foreach( healData in healOverTimeArray )
				{
					if ( IsValid( healData.healTarget ) )
						EntityHealResource_Remove( healData.healTarget, healData.healResourceID )
				}
				file.deployableData[ droneMedic ].healDataArray.clear()
			}
		}
	)

	int lastTargetCount     = DeployableMedic_GetHealTargetCount( trigger )
	float droneMedicEndTime = Time() + DEPLOYABLE_MEDIC_MAX_LIFETIME

	while ( true )
	{
		//If we have heal targets
		array<entity> playerHealTargetArray = DeployableMedic_GetPlayerHealTargetArray( droneMedic )
		int targetCount                     = playerHealTargetArray.len()
		if ( targetCount != lastTargetCount )
		{
			//printt( "targetCount Differ", targetCount, lastTargetCount )
			int healResource = file.deployableData[ droneMedic ].healResource

			// cancel all heal in progress and start new ones as needed
			int newHealResource = 0
			bool healCanceled = false
			array<HealData> healDataArray = file.deployableData[ droneMedic ].healDataArray
			foreach( healData in healDataArray )
			{
				healCanceled = true
				if ( IsValid( healData.healTarget ) )
				{
					newHealResource += EntityHealResource_GetRemainingHeals( healData.healTarget, healData.healResourceID )
					EntityHealResource_Remove( healData.healTarget, healData.healResourceID )
				}
			}

			if ( healCanceled )
				healResource = newHealResource

			file.deployableData[ droneMedic ].healDataArray.clear()
			file.deployableData[ droneMedic ].healResource = healResource

			if ( targetCount && healResource > 0 )
			{
				int healAmount     = healResource / targetCount
				float healDuration = healAmount / DEPLOYABLE_MEDIC_HEAL_PER_SEC
				//droneMedicEndTime  = Time() + healDuration

				foreach( player in playerHealTargetArray )
				{
					if ( !IsValid( player ) || !player.IsPlayer() )
						continue

					float healPerSec = healAmount / healDuration
					HealData healData
					healData.healTarget = player
					healData.healResourceID = EntityHealResource_Add( player, healDuration, healPerSec, 0, "mp_weapon_deployable_medic", droneMedic.GetOwner() )
					Assert( healData.healResourceID != ENTITY_HEAL_RESOURCE_INVALID )
					file.deployableData[ droneMedic ].healDataArray.append( healData )
				}
			}
			//else
			//{
			//	float healResourceFrac = healResource / float( DEPLOYABLE_MEDIC_HEAL_AMOUNT )
			//	droneMedicEndTime = Time() + max( DEPLOYABLE_MEDIC_MAX_LIFETIME * healResourceFrac, DEPLOYABLE_MEDIC_MIN_LIFETIME )
			//	//printt( "Additional lifetime", max( DEPLOYABLE_MEDIC_MAX_LIFETIME * healResourceFrac, DEPLOYABLE_MEDIC_MIN_LIFETIME ) )
			//}
		}

		//Set skin index based on amount of heal resource left.
		//In the end it would be good to have an in-world bar on the device that drains as the heal resource is used up.

		float resourceFrac = file.deployableData[ droneMedic ].healResource / float( DEPLOYABLE_MEDIC_HEAL_AMOUNT )
		droneMedic.SetSoundCodeControllerValue( resourceFrac * 100.0 )

		//if ( resourceFrac >= 0.66 )
		//	droneMedic.SetSkin( DEPLOYABLE_MEDIC_RESOURCE_FULL_SKIN_INDEX )
		//else if ( resourceFrac >= 0.33 )
		//	droneMedic.SetSkin( DEPLOYABLE_MEDIC_RESOURCE_HALF_SKIN_INDEX )
		//else
		//	droneMedic.SetSkin( DEPLOYABLE_MEDIC_RESOURCE_LOW_SKIN_INDEX )

		//if we have exausted our heal resource or run out of time, end our update.
		if ( ( targetCount == 0 && Time() > droneMedicEndTime ) || file.deployableData[ droneMedic ].healResource <= 0 )
		{
			array<HealData> healDataArray = file.deployableData[ droneMedic ].healDataArray
			foreach( healData in healDataArray )
			{
				// due to health being an int and time a float we sometimes have a tiny bit more health left to add before we are done
				entity target = healData.healTarget
				if ( IsAlive( target ) )
				{
					int remainingHeal = EntityHealResource_GetRemainingHeals( target, healData.healResourceID )
					int currentHealth = target.GetHealth()
					int finalHealth = minint( target.GetMaxHealth(), currentHealth + remainingHeal )
					target.SetHealth( finalHealth )

					// todo(dw): I'm pretty sure this whole part of dishing out the final heal amounts is unnecessary (and complicates this stat hook)
					int diff = finalHealth - currentHealth
					if ( diff > 0 )
						StatsHook_MedicDeployableDrone_OnEntityHealResourceFinished( target, diff, "mp_weapon_deployable_medic", droneMedic.GetOwner() )
				}
			}

			droneMedic.Signal( "DeployableMedic_HealDepleated" )
			return
		}

		if ( targetCount == 0 && lastTargetCount > 0 )
		{
			StopSoundOnEntity( droneMedic, DEPLOYABLE_MEDIC_HEAL_LOOP_SOUND_3P )
		}
		else if ( targetCount > 0 && lastTargetCount == 0 )
		{
			EmitSoundOnEntity( droneMedic, DEPLOYABLE_MEDIC_HEAL_LOOP_SOUND_3P )
		}

		lastTargetCount = targetCount
		WaitFrame()
	}
}

void function DeployableMedic_PlayerOnDamage( entity player, var damageInfo )
{
	Assert( IsValid( player ), "Player ent got a damage callback but it wasn't vaild." )

	int damageSourceID = DamageInfo_GetDamageSourceIdentifier( damageInfo )

	switch( damageSourceID )
	{
		case eDamageSourceId.outOfBounds:
			if ( DeathField_IsActive() )
			{
				float stormDist = DeathField_PointDistanceFromFrontier( player.EyePosition() )
				if ( stormDist > 0 )
					Signal( player, "DeployableMedic_HealAborted" )
					break
			}
			break

		default:
			Signal( player, "DeployableMedic_HealAborted" )
			break
	}
}

bool function DeployableMedic_ShouldAttemptHeal( entity player, entity droneMedic )
{
	//We can't heal titans
	if ( player.IsTitan() )
	{
		//	printt( "DON'T HEAL: PLAYER " + player + " IS A TITAN." )
		return false
	}

	//We can't heal phase shifted players
	if ( player.IsPhaseShifted() )
	{
		//	printt( "DON'T HEAL: PLAYER " + player + " PHASE SHIFTED." )
		return false
	}

	//todo: Caustic Gas doesn't work for now so I will disable this (until a fix for daddy Caustic)
	//We can't heal a player who is currently in a cloud of gas
	//if ( IsGasCausingDamage( player ) )
	//{
	//	//	printt( "DON'T HEAL: PLAYER " + player + " IS IN GAS." )
	//	return false
	//}

	//If bleedout logic is active and the player is bleeding we should not heal them.
	if ( Bleedout_IsBleedoutLogicActive() )
	{
		if ( Bleedout_IsBleedingOut( player ) )
			return false
	}

	// can't be executing and get healed.
	if ( player.IsPlayer() )
	{
		if ( player.ContextAction_IsMeleeExecution() || player.ContextAction_IsMeleeExecutionTarget() )
			return false
	}

	//We can't heal players who have full health
	if ( player.GetHealth() == player.GetMaxHealth() )
		return false

	TraceResults trace
	trace = TraceLine( droneMedic.GetOrigin(), player.EyePosition(), [ droneMedic ], TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_BLOCK_WEAPONS, droneMedic )
	if ( trace.hitEnt == player || trace.hitEnt == null )
		return true

	return true
}

TraceResults function HACK_TraceLineRealm( entity realmEnt, vector startPos, vector endPos, var ignoreEntOrArrayOfEnts = null, int traceMask = 0, int collisionGroup = 0 )
{
	array<entity> ignoreEntArray
	if ( type( ignoreEntOrArrayOfEnts ) == "array" )
	{
		foreach( ent in expect array( ignoreEntOrArrayOfEnts ) )
			ignoreEntArray.append( expect entity( ent ) )
	}
	else if ( IsValid( expect entity( ignoreEntOrArrayOfEnts ) ) )
	{
		ignoreEntArray.append( expect entity( ignoreEntOrArrayOfEnts ) )
	}

	TraceResults trace
	while( true )
	{
		trace = TraceLine( startPos, endPos, ignoreEntArray, traceMask, collisionGroup )
		if ( trace.hitEnt == null )
			break
		if ( realmEnt.DoesShareRealms( trace.hitEnt ) )
			break

		ignoreEntArray.append( trace.hitEnt )
	}

	return trace
}

int function DeployableMedic_GetHealTargetCount( entity droneMedic )
{
	if ( !( droneMedic in file.deployableData ) )
		return 0

	return file.deployableData[ droneMedic ].healTargets.len()
}

void function DeployableMedic_ClaimPlayerAsHealTarget( entity droneMedic, entity player )
{
	//	printt( "CLAIMING PLAYER " + player + " AS HEAL TARGET FOR TRIGGER " + trigger )

	//HACK: UNTIL WE GET CODE FIX THAT PREVENTS PHASE SHIFTED CHARACTERS FROM TRIGGERING THE TRIGGER CALLBACK TWICE IN SUCESSION, WE NEED TO CHECK IF THE PLAYER IS ALREAY A HEAL TARGET
	if ( file.deployableData[ droneMedic ].healTargets.contains( player ) )
		return

	Assert ( !file.deployableData[ droneMedic ].healTargets.contains( player ), "Player is already a heal target." )
	file.deployableData[ droneMedic ].healTargets.append( player )
}

array<entity> function DeployableMedic_GetPlayerHealTargetArray( entity droneMedic )
{
	return file.deployableData[ droneMedic ].healTargets
}

void function DeployableMedic_ReleasePlayerAsHealTarget( entity droneMedic, entity player )
{
	//	printt( "RELEASING PLAYER " + player + " AS HEAL TARGET FOR TRIGGER " + trigger )

	//HACK: UNTIL WE GET CODE FIX THAT PREVENTS PHASE SHIFTED CHARACTERS FROM TRIGGERING THE TRIGGER CALLBACK TWICE IN SUCESSION, WE NEED TO CHECK IF THE PLAYER IS A HEAL TARGET BECAUSE THEY CAN GET REMOVED TWICE IN SUCESSION.
	if ( !file.deployableData[ droneMedic ].healTargets.contains( player ) )
		return

	Assert ( file.deployableData[ droneMedic ].healTargets.contains( player ), "Player is not a heal target." )
	int index = file.deployableData[ droneMedic ].healTargets.find( player )
	file.deployableData[ droneMedic ].healTargets.fastremove( index )
}

HealRopeData function DeployableMedic_CreateHealRope( entity droneMedic )
{
	HealRopeData ropeData

	ropeData.ropeStartEnt = droneMedic

	return ropeData
}

void function DeployableMedic_DeployHealRope( HealRopeData ropeData, entity player )
{
	Assert( IsValid( ropeData.ropeStartEnt ) )

	EndSignal( player, "OnDeath" )
	EndSignal( player, "OnDestroy" )

	int droneAttchmentId = ropeData.ropeStartEnt.LookupAttachment( "rope" )

	// player rope
	ropeData.playerRopeEndEnt = CreateExpensiveScriptMover( ropeData.ropeStartEnt.GetOrigin() )
	ropeData.playerRopeEndEnt.RenderWithViewModels( true )
	SetForceDrawWhileParented( ropeData.playerRopeEndEnt, true )
	ropeData.playerRopeEndEnt.SetParent( player )

	vector playerOrigin = <0,0,-11>
	vector localOrigin = <0,0,0>

	ropeData.playerRopeEndEnt.SetLocalOrigin( playerOrigin )
	ropeData.playerRopeEndEnt.kv.VisibilityFlags = ENTITY_VISIBLE_TO_EVERYONE | ENTITY_VISIBLE_ONLY_PARENT_PLAYER

	entity playerRope = CreateRope( <0, 0, 0>, <0, 0, 0>, ROPE_LENGTH, ropeData.ropeStartEnt, ropeData.playerRopeEndEnt, droneAttchmentId, 0, 1, "models/cable/drone_medic_cable", ROPE_NODE_COUNT )
	ropeData.playerRope = playerRope
	HealRopeInit( playerRope, player, true )

	// other rope
	ropeData.otherRopeEndEnt = CreateExpensiveScriptMover( ropeData.ropeStartEnt.GetOrigin() )
	SetForceDrawWhileParented( ropeData.otherRopeEndEnt, true )
	ropeData.otherRopeEndEnt.SetParent( player, "CHESTFOCUS", true, 0.0 )
	ropeData.otherRopeEndEnt.kv.VisibilityFlags = ENTITY_VISIBLE_TO_EVERYONE | ENTITY_VISIBLE_EXCLUDE_PARENT_PLAYER

	entity rope = CreateRope( <0, 0, 0>, <0, 0, 0>, ROPE_LENGTH, ropeData.ropeStartEnt, ropeData.otherRopeEndEnt, droneAttchmentId, 0, 1, "models/cable/drone_medic_cable", ROPE_NODE_COUNT )
	ropeData.otherRope = rope
	HealRopeInit( rope, player, true )

	SetRopeLength( player, ropeData.ropeStartEnt, ropeData )

	ropeData.playerRopeEndEnt.NonPhysicsMoveInWorldSpaceToLocalPos( playerOrigin, ROPE_SHOOT_OUT_TIME, 0, ROPE_SHOOT_OUT_TIME )
	ropeData.otherRopeEndEnt.NonPhysicsMoveInWorldSpaceToLocalPos( localOrigin, ROPE_SHOOT_OUT_TIME, 0, ROPE_SHOOT_OUT_TIME )

	wait ROPE_SHOOT_OUT_TIME

	if ( IsSurvivalTraining() )
	{
		EmitSoundOnEntity( player, DEPLOYABLE_MEDIC_ATTACH_SOUND_3P )
		Signal( player, "DeployableMedic_Attached" )
	}
	else
	{
		EmitSoundOnEntityOnlyToPlayer( player, player, DEPLOYABLE_MEDIC_ATTACH_SOUND_1P )
		EmitSoundOnEntityExceptToPlayer( player, player, DEPLOYABLE_MEDIC_ATTACH_SOUND_3P )
	}
}

void function HealRopeInit( entity rope, entity player, bool isPlayerRope )
{
	rope.Rope_SetSlack( 0 )
	rope.Rope_SetCollisionEnabled( true )
	//rope.Rope_SetGravityEnabled( false )
	rope.Rope_SetTension( .5 )
	rope.Rope_SetPhysicsDampening( .001 )
	rope.Rope_ActivateStartDirectionConstraints( true )
	rope.Rope_SetDirectionConstraintFalloff( ceil( ROPE_LENGTH / ROPE_NODE_COUNT ) ) // make sure one node is impacted by the constraint
	rope.Rope_SetDirectionConstraintStrength( .35 )
	rope.Rope_SetSubdivisionSliceCount( 10 )
	rope.Rope_SetSubdivisionStackCount( 6 )
	rope.Rope_SetCanEnterRestingState( false )
	rope.SetFadeDistance( 490 )
	rope.RopeWiggle( ROPE_LENGTH, 0.01, 10, ROPE_SHOOT_OUT_TIME, ROPE_SHOOT_OUT_TIME ) // rope length, magnitude, speed, DURATION, fade DURATION

	rope.RemoveFromAllRealms()
	rope.AddToOtherEntitysRealms( player )
}

void function SetRopeLength( entity player, entity droneMedic, HealRopeData ropeData )
{
	const MIN_DIST = DEPLOYABLE_MEDIC_HEAL_RADIUS / 3.0
	const MIN_ROPE_LENGTH = ROPE_LENGTH * 0.7

	// update rope length to avoid it looking like it's connecting to the crotch of the player when the drone is close.
	vector chestOrigin = player.GetAttachmentOrigin( player.LookupAttachment( "CHESTFOCUS" ) )
	float dist = Distance( ropeData.ropeStartEnt.GetOrigin(), chestOrigin )
	float ropeLength = GraphCapped( dist, MIN_DIST, DEPLOYABLE_MEDIC_HEAL_RADIUS, MIN_ROPE_LENGTH, ROPE_LENGTH )

	ropeData.playerRope.Rope_SetLength( ropeLength )
	ropeData.otherRope.Rope_SetLength( ropeLength )
}

void function DeployableMedic_RetractHealRope( HealRopeData ropeData )
{
	if ( IsValid( ropeData.ropeStartEnt ) && IsValid( ropeData.playerRope ) && IsValid( ropeData.otherRope ) )
	{
		entity player = ropeData.playerRopeEndEnt.GetParent()
		if ( IsValid( player ) && player.IsPlayer() )
		{
			EmitSoundOnEntityOnlyToPlayer( player, player, DEPLOYABLE_MEDIC_DETATCH_SOUND_1P )
			EmitSoundOnEntityExceptToPlayer( player, player, DEPLOYABLE_MEDIC_DETATCH_SOUND_3P )
		}

		Assert( IsValid( ropeData.playerRopeEndEnt ) )
		Assert( IsValid( ropeData.otherRopeEndEnt ) )

		ropeData.playerRope.RopeWiggle( ROPE_LENGTH, 0.01, 10, ROPE_REAL_IN_TIME, ROPE_REAL_IN_TIME / 2 )    // rope length, magnitude, speed, DURATION, fade DURATION
		ropeData.playerRopeEndEnt.ClearParent()
		ropeData.playerRopeEndEnt.NonPhysicsMoveTo( ropeData.ropeStartEnt.GetOrigin(), ROPE_REAL_IN_TIME, 0, ROPE_REAL_IN_TIME / 2 )
		ropeData.playerRope.Rope_SetGravityEnabled( false )
		ropeData.playerRope.Rope_SetLength( 5 )

		ropeData.otherRope.RopeWiggle( ROPE_LENGTH, 0.01, 10, ROPE_REAL_IN_TIME, ROPE_REAL_IN_TIME / 2 )    // rope length, magnitude, speed, DURATION, fade DURATION
		ropeData.otherRopeEndEnt.ClearParent()
		ropeData.otherRopeEndEnt.NonPhysicsMoveTo( ropeData.ropeStartEnt.GetOrigin(), ROPE_REAL_IN_TIME, 0, ROPE_REAL_IN_TIME / 2 )
		ropeData.otherRope.Rope_SetGravityEnabled( false )
		ropeData.otherRope.Rope_SetLength( 5 )

		wait ROPE_REAL_IN_TIME
	}

	if ( IsValid( ropeData.playerRope ) )
		ropeData.playerRope.Destroy()
	if ( IsValid( ropeData.playerRopeEndEnt ) )
		ropeData.playerRopeEndEnt.Destroy()

	if ( IsValid( ropeData.otherRope ) )
		ropeData.otherRope.Destroy()
	if ( IsValid( ropeData.otherRopeEndEnt ) )
		ropeData.otherRopeEndEnt.Destroy()
}

#endif // SERVER

#if CLIENT
void function DeployableMedic_OnPropScriptCreated( entity ent )
{
}

void function DeployableMedic_HealVisualsEnabled( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( !actuallyChanged )
		return

	if ( ent != GetLocalViewPlayer() )
		return

	entity player = ent

	entity cockpit = player.GetCockpit()
	if ( !IsValid( cockpit ) )
		return

	Assert( !EffectDoesExist( file.healFxHandle ), "tried to start a second screen fx" )

	int fxID = GetParticleSystemIndex( FX_DRONE_MEDIC_HEAL_COCKPIT_FX )
	file.healFxHandle = StartParticleEffectOnEntity( cockpit, fxID, FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
	EffectSetIsWithCockpit( file.healFxHandle, true )

	Chroma_StartHealingDroneEffect()
}

void function DeployableMedic_HealVisualsDisabled( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( !actuallyChanged )
		return

	if ( ent != GetLocalViewPlayer() )
		return

	if ( !EffectDoesExist( file.healFxHandle ) )
		return

	EffectStop( file.healFxHandle, false, true )

	Chroma_EndHealingDroneEffect()
}

bool function CanDeployHealDrone( entity player )
{
	if ( !player.HasPassive( ePassives.PAS_MEDIC ) )
		return false

	entity weapon = player.GetOffhandWeapon( OFFHAND_TACTICAL )

	if ( !IsValid( weapon ) )
		return false

	if ( weapon.GetWeaponClassName() != "mp_weapon_deployable_medic" )
		return false

	int ammoReq = weapon.GetAmmoPerShot()
	int currAmmo = weapon.GetWeaponPrimaryClipCount()
	if ( currAmmo < ammoReq )
		return false

	return true
}

#endif //CLIENT