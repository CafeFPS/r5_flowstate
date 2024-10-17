global function MpWeaponDeployableMedic_Init

global function OnWeaponTossReleaseAnimEvent_weapon_deployable_medic
global function OnWeaponAttemptOffhandSwitch_weapon_deployable_medic
global function OnWeaponTossPrep_weapon_deployable_medic
global function GetHealDroneForHitEnt

#if SERVER
global function Set3pHealRopeVisibility
global function Set1pHealRopeVisibility
global function GetAllHealDrones
global function CanBeHealedByDroneMedic
global function HealRopeInit
                    
global function IsEntityInDeathField
      
#endif
#if CLIENT
global function CanDeployHealDrone
#endif

const asset DEPLOYABLE_MEDIC_DRONE_MODEL = $"mdl/props/lifeline_drone/lifeline_drone.rmdl"

//Deployment Vars
const float DEPLOYABLE_MEDIC_THROW_POWER = 1.0
const float DEPLOYABLE_MEDIC_ICON_HEIGHT = 32.0

//Heal Vars
const int DEPLOYABLE_MEDIC_HEAL_MAX_TARGETS = 3
const float DEPLOYABLE_MEDIC_HEAL_START_DELAY = 1.0
const float DEPLOYABLE_MEDIC_HEAL_RADIUS = 256.0 //128.0
const int DEPLOYABLE_MEDIC_HEAL_AMOUNT = 9999 //150
const float DEPLOYABLE_MEDIC_MAX_LIFETIME = 20
                    
const float DEPLOYABLE_MEDIC_HEAL_PER_SEC = 7

const ROPE_LENGTH = DEPLOYABLE_MEDIC_HEAL_RADIUS + 50
const ROPE_NODE_COUNT = 10
const ROPE_SHOOT_OUT_TIME = 0.25
const ROPE_REAL_IN_TIME = 0.25

const int DEPLOYABLE_MEDIC_RESOURCE_FULL_SKIN_INDEX = 0
const int DEPLOYABLE_MEDIC_RESOURCE_HALF_SKIN_INDEX = 2
const int DEPLOYABLE_MEDIC_RESOURCE_LOW_SKIN_INDEX = 1

const int DRONE_MEDIC_HOVER_TRACE_MASK = TRACE_MASK_NPCSOLID
const int DRONE_MEDIC_HOVER_COLLISION_GROUP = TRACE_COLLISION_GROUP_NPC

global const string DEPLOYABLE_MEDIC_SCRIPT_NAME = "deployable_medic"

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
const vector DRONE_VEHICLE_OFFSET = <0,0,10>

struct HealRopeData
{
	entity ropeStartEnt
	entity playerRope
	entity playerRopeEndEnt
	entity otherRope
	entity otherRopeEndEnt
}

struct HealData
{
	entity healTarget
	int	   healResourceID
}

struct SignalStruct
{
	entity droneMedic
	entity player
}

enum ePopulationMethod
{
	INSIDE_TRIGGER,
	_count
}
struct PopulationInfoForTarget
{
	bool[ePopulationMethod._count] activeMethods
}

struct HealDeployableData
{
	int                 healResource = DEPLOYABLE_MEDIC_HEAL_AMOUNT
	array<entity>       healTargets = []
	array<HealData>     healDataArray = []
	array<entity>       particles = []
	entity healTrigger

	table<entity, PopulationInfoForTarget> targetPopulationInfoMap
}

struct
{
	#if SERVER
		table< entity, HealDeployableData > deployableData
		array<SignalStruct>                 signalStructArray
		table< entity, array<entity> > playerRopes
		table< entity, array<entity> > otherRopes
	#else
		int healFxHandle
	#endif
} file

const string SIG_LEFTHEALINGPOPULATION = "DeployableMedic_LeftHealingPopulation"
void function MpWeaponDeployableMedic_Init()
{
	RegisterSignal( "DeployableMedic_HealDepleated" )
	RegisterSignal( "DeployableMedic_HealAborted" )
	RegisterSignal( "DeployableMedic_Attached" )
	RegisterSignal( SIG_LEFTHEALINGPOPULATION )
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

float function GetDeployableMedicHealRate( entity player )
{
	float result = DEPLOYABLE_MEDIC_HEAL_PER_SEC

	return result
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
			string projectileSound = GetGrenadeProjectileSound( weapon )
			if ( projectileSound != "" )
				EmitSoundOnEntity( deployable, projectileSound )

			weapon.w.lastProjectileFired = deployable
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
		float yAngle = Clamp( angles.y - 180, -360.0, 360.0 )
		deployable.SetAngles( <0, yAngle, 0> )
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

	vector originalLaunchPosition = projectile.GetOrigin()
	vector originalVelocity = projectile.GetVelocity()
	entity owner = projectile.GetOwner()
	vector dirVec = Normalize( originalVelocity )


	// offset the launch position so that the trace doesn't start inside walls, when you right up to one and try to deply the drone.
	// There is still the issue with the "projectile" just going straight through walls. I do not know why that is.
	originalLaunchPosition = originalLaunchPosition + dirVec * -8
	
	const PROJECTILE_DRIFT_TIME = 0.2
	wait PROJECTILE_DRIFT_TIME

	// can't EndSignal on the projectile because that will end the thread prematurely.
	if ( !IsValid( projectile ) )
		return

	vector origin   = projectile.GetOrigin()
	vector angles   = projectile.GetAngles()
	vector velocity = projectile.GetVelocity()
	owner    = projectile.GetOwner()
	entity _parent  = projectile.GetParent()
	string parentAttachment = projectile.GetParentAttachment()

	TraceResults traceResult = TraceHull( originalLaunchPosition, origin, DRONE_MINS, DRONE_MAXS, projectile, TRACE_MASK_NPCWORLDSTATIC, TRACE_COLLISION_GROUP_NONE )
	origin = traceResult.endPos

	if ( !IsValid( owner ) )
	{
		if ( IsValid( projectile ) )
			projectile.Destroy()
		return
	}

	owner.EndSignal( "OnDestroy" )
	owner.EndSignal( "CleanUpPlayerAbilities" )

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
	// droneMedic.kv.SpawnAsPhysicsMover = 0
	DispatchSpawn( droneMedic )

	droneMedic.EndSignal( "OnDestroy" )

	if ( IsValid( _parent ) )
	{
		droneMedic.SetParent( _parent, parentAttachment )
	}

	droneMedic.kv.collisionGroup = TRACE_COLLISION_GROUP_BLOCK_WEAPONS
	droneMedic.DisableHibernation()
	droneMedic.SetMaxHealth( 100 )
	droneMedic.SetHealth( 100 )
	droneMedic.SetTakeDamageType( DAMAGE_NO )
	droneMedic.SetDamageNotifications( false )
	droneMedic.SetDeathNotifications( false )
	droneMedic.SetArmorType( ARMOR_TYPE_HEAVY )
	droneMedic.SetScriptName( "deployable_medic" )
	droneMedic.SetBlocksRadiusDamage( false )
	droneMedic.SetTitle( "" )
	droneMedic.SetOwner( owner )
	droneMedic.SetIgnorePredictedTriggerTypes( TT_JUMP_PAD )
	SetTeam( droneMedic, owner.GetTeam() )
	SetTargetName( droneMedic, "#WPN_TITAN_SLOW_TRAP" )
	SetObjectCanBeMeleed( droneMedic, false )
	SetVisibleEntitiesInConeQueriableEnabled( droneMedic, false )
	droneMedic.RemoveFromAllRealms()
	droneMedic.AddToOtherEntitysRealms( owner )
	Highlight_SetOwnedHighlight( droneMedic, "sp_friendly_hero" )
	Highlight_SetFriendlyHighlight( droneMedic, "sp_friendly_hero" )

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
	AddEMPDestroyDeviceNoDissolve( droneMedic )

	TrackingVision_CreatePOI( eTrackingVisionNetworkedPOITypes.PLAYER_ABILITY_DEPLOYABLE_MEDIC, owner, droneMedic.GetOrigin(), owner.GetTeam(), owner )

	thread DroneMedicHoverThink( droneMedic, velocity )

	bool shouldAnimsSetOrigin = true
	thread DroneMedicAnims( droneMedic, shouldAnimsSetOrigin )

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
				EmitSoundAtPosition( TEAM_UNASSIGNED, droneMedic.GetOrigin(), DEPLOYABLE_MEDIC_DISSOLVE_SOUND, droneMedic )

				RemoveSonarDetectionForPropScript( droneMedic )

				Highlight_ClearOwnedHighlight( droneMedic )
				Highlight_ClearFriendlyHighlight( droneMedic )
				
				droneMedic.ClearParent()
				droneMedic.Dissolve( ENTITY_DISSOLVE_CORE, <0, 0, 0>, 500 )
			}
		}
	)

	waitthread DeployableMedic_CreateHealTriggerArea( owner, droneMedic )
}

void function DroneMedicAnims( entity droneMedic, bool shouldAnimsSetOrigin )
{
	EndSignal( droneMedic, "OnDestroy" )

	entity owner = droneMedic.GetOwner()
	EndSignal( owner, "OnDestroy" )
	EndSignal( owner, "CleanUpPlayerAbilities" )
	EndSignal( owner, "EMP_Destroy" )
	EndSignal( droneMedic, "DeployableMedic_HealDepleated" )
	EndThreadOn_PlayerChangedClass( owner )

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

	if ( shouldAnimsSetOrigin )
		droneMedic.Anim_Play( "lifeline_drone_arming" )
	else
		droneMedic.Anim_PlayOnly( "lifeline_drone_arming" )
		
	WaittillAnimDone( droneMedic )

	if ( !(droneMedic in file.deployableData) )
		return

	file.deployableData[ droneMedic ].particles.append( StartParticleEffectOnEntity_ReturnEntity( droneMedic, GetParticleSystemIndex( FX_DRONE_MEDIC_JET_LOOP ), FX_PATTACH_POINT_FOLLOW, fxID_RF ) )
	file.deployableData[ droneMedic ].particles.append( StartParticleEffectOnEntity_ReturnEntity( droneMedic, GetParticleSystemIndex( FX_DRONE_MEDIC_JET_LOOP ), FX_PATTACH_POINT_FOLLOW, fxID_LF ) )
	file.deployableData[ droneMedic ].particles.append( StartParticleEffectOnEntity_ReturnEntity( droneMedic, GetParticleSystemIndex( FX_DRONE_MEDIC_JET_LOOP ), FX_PATTACH_POINT_FOLLOW, fxID_RR ) )
	file.deployableData[ droneMedic ].particles.append( StartParticleEffectOnEntity_ReturnEntity( droneMedic, GetParticleSystemIndex( FX_DRONE_MEDIC_JET_LOOP ), FX_PATTACH_POINT_FOLLOW, fxID_LR ) )

	if ( shouldAnimsSetOrigin )
		droneMedic.Anim_Play( "lifeline_drone_floating" )
	else
		droneMedic.Anim_PlayOnly( "lifeline_drone_floating" )
}

void function DroneMedicHoverThink( entity droneMedic, vector velocity )
{
	EndSignal( droneMedic, "OnDestroy" )

	const DECEL_TIME = 0.5
	const SETTLE_HEIGHT = 56
	const TRACE_HEIGHT = 128
	const TRACE_HEIGHT_HIGH = 1024
	const CLEAR_HOVER_DIST = 48
	const YAW_RATE = 2000
	const BOB_FREQUENCY = 2
	const BOB_SCALE = 1
	const MAX_SPEED = 256
	const MAX_SPEED_DIST = 192 * 192
	const BASE_SPEED_DIST = 32 * 32
	const RESET_DIST = 66

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
			float frac = TraceLineSimple( owner.EyePosition(), owner.EyePosition() + <0, 0, -TRACE_HEIGHT>, owner )
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
	entity groundEnt               = groundTraceResult.hitEnt ? groundTraceResult.hitEnt.GetRootMoveParent() : null
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

	// DebugDrawLine( deployOrigin, deployDest, 255, 0, 0, true, 2 )
	// DebugDrawLine( deployDest, groundTraceResult.endPos, 0, 255, 0, true, 2 )
	// DrawStar( moveToPosition, 2, 5, true )

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

			vector ornull clearVector = GetClearHoverVector( droneMedic, hoverOrigin, CLEAR_HOVER_DIST )
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
		else if ( IsValid( newGroundEnt ) &&
					( groundEnt != newGroundEnt || Distance( droneMedic.GetMoveToPositionWorld(), hoverOrigin ) > RESET_DIST ) )
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
	owner.EndSignal( "CleanUpPlayerAbilities" )
	EndThreadOn_PlayerChangedClass( owner )

	vector origin = droneMedic.GetOrigin()

	entity trigger = CreateEntity( "trigger_cylinder" )
	trigger.SetOwner( droneMedic )
	trigger.SetRadius( DEPLOYABLE_MEDIC_HEAL_RADIUS )
	trigger.SetAboveHeight( 92 )
	trigger.SetBelowHeight( 80 )
	trigger.SetOrigin( origin )
	trigger.SetPhaseShiftCanTouch( false )
	DispatchSpawn( trigger )

	file.deployableData[droneMedic].healTrigger = trigger

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


PopulationInfoForTarget function GetPopulationInfoForPlayer( entity droneMedic, entity player )
{
	if ( !(player in file.deployableData[droneMedic].targetPopulationInfoMap) )
	{
		PopulationInfoForTarget newInfo
		file.deployableData[droneMedic].targetPopulationInfoMap[player] <- newInfo
	}

	return file.deployableData[droneMedic].targetPopulationInfoMap[player]
}

bool function PlayerIsInDronePopulation( entity player, entity droneMedic )
{
	PopulationInfoForTarget pi = GetPopulationInfoForPlayer( droneMedic, player )
	for( int idx = 0; idx < ePopulationMethod._count; ++idx )
	{
		if ( pi.activeMethods[idx] )
			return true
	}

	return false
}

void function OnDronePopulationOfType_Starting( entity player, entity droneMedic, int populationMethod )
{
	bool wasInPopulation = PlayerIsInDronePopulation( player, droneMedic )
	PopulationInfoForTarget pi = GetPopulationInfoForPlayer( droneMedic, player )
	pi.activeMethods[populationMethod] = true
	if ( wasInPopulation )
		return

	thread PlayerHealUpdateThread( droneMedic, player )
}

void function OnDronePopulationOfType_Ending( entity player, entity droneMedic, int populationMethod )
{
	PopulationInfoForTarget pi = GetPopulationInfoForPlayer( droneMedic, player )
	pi.activeMethods[populationMethod] = false
	if ( PlayerIsInDronePopulation( player, droneMedic ) )
		return

	SignalSignalStruct( droneMedic, player, SIG_LEFTHEALINGPOPULATION )
}
void function OnDeployableMedicHealAreaEnter( entity trigger, entity ent )
{
	// this could be removed once the trigger no longer gets triggered by ents in different realms. bug R5DEV-46753
	if ( !trigger.DoesShareRealms( ent ) )
		return
	entity droneMedic = trigger.GetOwner()
	if ( !IsPossibleDroneMedicTriggerTarget( ent, droneMedic ) )
		return

	OnDronePopulationOfType_Starting( ent, droneMedic, ePopulationMethod.INSIDE_TRIGGER )
}

void function OnDeployableMedicHealAreaLeave( entity trigger, entity ent )
{
	entity droneMedic = trigger.GetOwner()
	if ( !IsPossibleDroneMedicTriggerTarget( ent, droneMedic ) )
		return

	OnDronePopulationOfType_Ending( ent, droneMedic, ePopulationMethod.INSIDE_TRIGGER )
}

bool function CanBeHealedByDroneMedic( entity player )
{
	if ( !player.IsPlayer() )
	{
		if ( IsSurvivalTraining() && player.GetScriptName() == "survival_training_target_dummy" )
			return true

		return false
	}

	if ( player.IsShadowForm() ) //&& !IsInForgedShadows( player ) )
		return false

	if ( StatusEffect_GetSeverity( player, eStatusEffect.immune_to_abilities ) > 0.0 )
		return false

	                    
	if ( IsEntityInDeathField(player) )
		return false
       

	return true
}

     
bool function IsEntityInDeathField(entity ent)
{
	//DeathFieldData deathFieldData = SURVIVAL_GetDeathFieldData()
	return !(SURVIVAL_PosInsideDeathField( ent.GetOrigin() ) ) //|| StatusEffect_HasSeverity( ent, eStatusEffect.ring_immunity ) || StatusEffect_HasSeverity( ent, eStatusEffect.in_void_ring )) // first part = is safe
}
      

bool function IsPossibleDroneMedicTriggerTarget( entity target, entity droneMedic )
{
	if ( !target.IsPlayer() )
		return IsSurvivalTraining() && ( target.GetScriptName() == "survival_training_target_dummy" )
       

	return true
}

SignalStruct function CreateSignalStruct( entity droneMedic, entity player )
{
	SignalStruct signalStruct
	signalStruct.player = player
	signalStruct.droneMedic = droneMedic
	file.signalStructArray.append( signalStruct )
	return signalStruct
}

void function SignalSignalStruct( entity droneMedic, entity player, string signal )
{
	foreach( signalStruct in file.signalStructArray )
	{
		if ( (signalStruct.droneMedic == droneMedic) && (signalStruct.player == player) )
			Signal( signalStruct, signal )
	}
}

void function DestroySignalStruct( SignalStruct signalStruct )
{
	file.signalStructArray.fastremovebyvalue( signalStruct )
}

struct UpdateThreadVars
{
	int statusEffectHandle
}

void function PlayerHealUpdateThread( entity droneMedic, entity player )
{
	entity trigger = file.deployableData[droneMedic].healTrigger

	SignalStruct signalStruct = CreateSignalStruct( droneMedic, player )
	EndSignal( signalStruct, SIG_LEFTHEALINGPOPULATION )

	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )
	trigger.EndSignal( "OnDestroy" )

	droneMedic.EndSignal( "DeployableMedic_HealDepleated" )

	UpdateThreadVars threadVars
	//HealRopeData ropeData = DeployableMedic_CreateHealRope( droneMedic )
	OnThreadEnd(
		function() : ( player, droneMedic, threadVars, signalStruct )
		{
			//thread DeployableMedic_RetractHealRope( ropeData )
			if ( IsValid( player ) && player.IsPlayer() )
				StatusEffect_Stop( player, threadVars.statusEffectHandle )

			if ( IsValid( droneMedic ) && IsValid( player ) )
			{
				if ( (droneMedic in file.deployableData) && file.deployableData[droneMedic].healTargets.contains( player ) )
					DeployableMedic_ReleasePlayerAsHealTarget( droneMedic, player )
			}

			DestroySignalStruct( signalStruct )
		}
	)

	RunHealingUpdateRopeThread( droneMedic, player, signalStruct )

	float startTime = Time()
	while ( PlayerIsInDronePopulation( player, droneMedic ) )
	{
		WaitFrame()
		//Wait until a heal slot opens up for this player.
		if ( DeployableMedic_GetHealTargetCount( droneMedic ) >= DEPLOYABLE_MEDIC_HEAL_MAX_TARGETS )
		{
			startTime = Time()
			continue
		}
		if ( !DeployableMedic_ShouldAttemptHeal( player, droneMedic ) )
		{
			startTime = Time()
			continue
		}
		if ( (Time() - startTime) < DEPLOYABLE_MEDIC_HEAL_START_DELAY )
			continue
		if ( HasMaxNumberOfDroneConnections( player ) )
			continue

		//Claim this player as a heal target
		EmitSoundOnEntity( droneMedic, DEPLOYABLE_MEDIC_DEPLOY_CABLE_SOUND )
		DeployableMedic_ClaimPlayerAsHealTarget( droneMedic, player )
		//thread DeployableMedic_DeployHealRope( ropeData, player )
		if ( player.IsPlayer() )
			threadVars.statusEffectHandle = StatusEffect_AddEndless( player, eStatusEffect.drone_healing, 1 )

		waitthread DeployableMedic_WaitForHeal( player, droneMedic, trigger )

		DeployableMedic_ReleasePlayerAsHealTarget( droneMedic, player )
		//thread DeployableMedic_RetractHealRope( ropeData )
		if ( player.IsPlayer() )
			StatusEffect_Stop( player, threadVars.statusEffectHandle )
		startTime = Time()
	}
}
bool function ShouldDrawHealRopeToPlayer( entity player, entity droneMedic )
{
	if ( file.deployableData[droneMedic].healTargets.contains( player ) == false )
		return false

	// No rope if the drone is healing through a vehicle:
	// PopulationInfoForTarget pi = GetPopulationInfoForPlayer( droneMedic, player )
	// if ( pi.activeMethods[ePopulationMethod.SHARING_VEHICLE] )
		// return false

	return true
}

void function RunHealingUpdateRopeThread( entity droneMedic, entity player, SignalStruct signalStruct )
{
	thread function() : (droneMedic, player, signalStruct)
	{
		entity trigger = file.deployableData[droneMedic].healTrigger

		EndSignal( signalStruct, SIG_LEFTHEALINGPOPULATION )
		player.EndSignal( "OnDeath" )
		player.EndSignal( "OnDestroy" )
		trigger.EndSignal( "OnDestroy" )
		droneMedic.EndSignal( "DeployableMedic_HealDepleated" )

		HealRopeData ropeData = DeployableMedic_CreateHealRope( droneMedic )
		OnThreadEnd( function() : ( ropeData )
		{
			thread DeployableMedic_RetractHealRope( ropeData )
		} )

		for ( ;; )
		{
			if ( !ShouldDrawHealRopeToPlayer( player, droneMedic ) )
			{
				WaitFrame()
				continue
			}

			thread DeployableMedic_DeployHealRope( ropeData, player )
			while ( ShouldDrawHealRopeToPlayer( player, droneMedic ) )
			{
				SetRopeLength( player, droneMedic, ropeData )
				WaitFrame()
			}
			thread DeployableMedic_RetractHealRope( ropeData )
		}
	}()

}

void function DeployableMedic_WaitForHeal( entity player, entity droneMedic, entity trigger )
{
	EndSignal( player, "DeployableMedic_HealAborted" )

	if ( DeployableMedic_ShouldAttemptHeal( player, droneMedic ) && player.IsPlayer() )
		EmitSoundOnEntityOnlyToPlayer( player, player, DEPLOYABLE_MEDIC_HEAL_LOOP_SOUND_1P )

	OnThreadEnd( function() : ( player )
	{
		if ( IsValid( player ) )
			StopSoundOnEntity( player, DEPLOYABLE_MEDIC_HEAL_LOOP_SOUND_1P )
	} )

	for ( ;; )
	{
		if ( !DeployableMedic_ShouldAttemptHeal( player, droneMedic ) )
			break
		if ( !PlayerIsInDronePopulation( player, droneMedic ) )
			break

		WaitFrame()
	}
}

void function DeployableMedic_DeployableHealUpdate( entity trigger, entity droneMedic )
{
	Assert ( IsNewThread(), "Must be threaded off." )
	trigger.EndSignal( "OnDestroy" )
	droneMedic.EndSignal( "OnDestroy" )
	droneMedic.EndSignal( "DeployableMedic_HealDepleated" )
	droneMedic.EndSignal( "EMP_Destroy" )

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
	entity owner = droneMedic.GetOwner()

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

			if ( targetCount > 0 && healResource > 0 )
			{
				int healAmount     = healResource / targetCount
				float healDuration = healAmount / GetDeployableMedicHealRate( owner )

				foreach( player in playerHealTargetArray )
				{
					if ( !IsValid( player ) || !player.IsPlayer() )
						continue
          

					float healPerSec = 0
					if ( healDuration > 0 )
						healPerSec = healAmount / healDuration

                                      
                  
                                                                
           

					HealData healData
					healData.healTarget = player
					healData.healResourceID = EntityHealResource_Add( player, healDuration, healPerSec, 0, "mp_weapon_deployable_medic", droneMedic.GetOwner() )
					Assert( healData.healResourceID != ENTITY_HEAL_RESOURCE_INVALID )
					file.deployableData[ droneMedic ].healDataArray.append( healData )
				}
			}
		}

		//Set skin index based on amount of heal resource left.
		//In the end it would be good to have an in-world bar on the device that drains as the heal resource is used up.

		float resourceFrac = file.deployableData[ droneMedic ].healResource / float( DEPLOYABLE_MEDIC_HEAL_AMOUNT )
		droneMedic.SetSoundCodeControllerValue( resourceFrac * 100.0 )

		//if we have exausted our heal resource or run out of time, end our update.
		if ( (targetCount == 0 && Time() > droneMedicEndTime) || file.deployableData[ droneMedic ].healResource <= 0 )
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
					int finalHealth   = minint( target.GetMaxHealth(), currentHealth + remainingHeal )
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
		case eDamageSourceId.deathField:
			if ( DeathField_IsActive() )
			{
				float stormDist = DeathField_PointDistanceFromFrontier( player.EyePosition() )
				if ( stormDist > 0 )
					Signal( player, "DeployableMedic_HealAborted" )
					break
			}
			break
		case eDamageSourceId.damagedef_gas_exposure:
			//seems really dumb that it has to be set up this way, but gas damage doesn't play by the rules
			if ( !IsFriendlyTeam( DamageInfo_GetInflictor( damageInfo ).GetTeam(), player.GetTeam() ) )
			{
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
	
	//(mk): enabling this check
	if ( IsGasCausingDamage( player ) )
	{
		//	printt( "DON'T HEAL: PLAYER " + player + " IS IN GAS." )
		return false
	}

	//If bleedout logic is active and the player is bleeding we should not heal them.
	if ( Bleedout_IsBleedoutLogicActive() && Bleedout_IsBleedingOut( player ) )
		return false

	// can't be executing and get healed.
	if ( player.IsPlayer() && (player.ContextAction_IsMeleeExecution() || player.ContextAction_IsMeleeExecutionTarget()) )
		return false

	//We can't heal players who have full health
	if ( player.GetHealth() == player.GetMaxHealth() )
		return false

	if ( PlayerHealResourceDepleated( player, droneMedic ) )
		return false
	if ( !CanBeHealedByDroneMedic( player ) )
		return false
	float distThresholdSqr = pow( DEPLOYABLE_MEDIC_HEAL_RADIUS*1.25, 2 )
	float distSqr = DistanceSqr( player.GetOrigin(), droneMedic.GetOrigin() )
	if ( distSqr > distThresholdSqr )
		return false

	array<entity> ignoreEnts = [droneMedic]
                     
	entity droneParent = droneMedic.GetParent()

	TraceResults trace
	vector playerPos = ( player.IsPlayer() && player.ContextAction_IsInVehicle() ) ? player.GetWorldSpaceCenter() : player.EyePosition()
	trace = TraceLine( droneMedic.GetOrigin(), playerPos, ignoreEnts, TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_BLOCK_WEAPONS, droneMedic )
	if ( (trace.hitEnt == player) || (trace.hitEnt == null) )
		return true
       

	return false
}

bool function PlayerHealResourceDepleated( entity player, entity droneMedic )
{
	array<HealData> healDataArray = file.deployableData[ droneMedic ].healDataArray
	foreach( healData in healDataArray )
	{
		if ( IsValid( healData.healTarget ) && healData.healTarget == player )
		{
			int remainingHeals = EntityHealResource_GetRemainingHeals( healData.healTarget, healData.healResourceID )
			if ( remainingHeals == 0 )
				return true
			break
		}
	}

	return false
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

	if ( player.IsPlayer() )
		player.p.connectedLifelineDrones++

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

	if ( player.IsPlayer() )
		player.p.connectedLifelineDrones--

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

void function Set3pHealRopeVisibility( entity player )
{
	if ( !( player in file.playerRopes ) || !( player in file.otherRopes ) )
		return

	ArrayRemoveInvalid( file.playerRopes[player] )
	ArrayRemoveInvalid( file.otherRopes[player] )

	foreach( ropeEnt in file.playerRopes[player] )
	{
		ropeEnt.kv.VisibilityFlags = ENTITY_VISIBLE_TO_NOBODY
	}
	foreach( ropeEnt in file.otherRopes[player] )
	{
		ropeEnt.kv.VisibilityFlags = ENTITY_VISIBLE_TO_EVERYONE
	}
}

void function Set1pHealRopeVisibility( entity player )
{
	if ( !( player in file.playerRopes ) || !( player in file.otherRopes ) )
		return

	ArrayRemoveInvalid( file.playerRopes[player] )
	ArrayRemoveInvalid( file.otherRopes[player] )

	foreach( ropeEnt in file.playerRopes[player] )
	{
		ropeEnt.kv.VisibilityFlags = ENTITY_VISIBLE_TO_OWNER
	}
	foreach( ropeEnt in file.otherRopes[player] )
	{
		ropeEnt.kv.VisibilityFlags = ENTITY_VISIBLE_TO_FRIENDLY | ENTITY_VISIBLE_TO_ENEMY
	}
}

void function DeployableMedic_DeployHealRope( HealRopeData ropeData, entity player )
{
	Assert( IsValid( ropeData.ropeStartEnt ) )

	EndSignal( player, "OnDeath" )
	EndSignal( player, "OnDestroy" )

	int droneAttchmentId = ropeData.ropeStartEnt.LookupAttachment( "rope" )

	if ( !( player in file.playerRopes ) )
		file.playerRopes[player] <- []
	if ( !( player in file.otherRopes ) )
		file.otherRopes[player] <- []

	// player rope
	ropeData.playerRopeEndEnt = CreateExpensiveScriptMover( ropeData.ropeStartEnt.GetOrigin() )
	ropeData.playerRopeEndEnt.RenderWithViewModels( true )
	SetForceDrawWhileParented( ropeData.playerRopeEndEnt, true )
	ropeData.playerRopeEndEnt.SetParent( player, "CHESTFOCUS" )

	vector playerOrigin = <0, 0, 0>
	vector localOrigin  = <0, 0, 0>

	entity playerRope = CreateRope( <0, 0, 0>, <0, 0, 0>, ROPE_LENGTH, ropeData.ropeStartEnt, ropeData.playerRopeEndEnt, droneAttchmentId, 0, 1, "models/cable/drone_medic_cable", ROPE_NODE_COUNT )
	ropeData.playerRope = playerRope
	HealRopeInit( playerRope, player, true )
	playerRope.kv.VisibilityFlags = ( player.IsPlayer() && player.ContextAction_IsInVehicle() ) ? ENTITY_VISIBLE_TO_NOBODY : ENTITY_VISIBLE_TO_OWNER

	// other rope
	ropeData.otherRopeEndEnt = CreateExpensiveScriptMover( ropeData.ropeStartEnt.GetOrigin() )
	SetForceDrawWhileParented( ropeData.otherRopeEndEnt, true )
	ropeData.otherRopeEndEnt.SetParent( player, "CHESTFOCUS", true, 0.0 )

	entity rope = CreateRope( <0, 0, 0>, <0, 0, 0>, ROPE_LENGTH, ropeData.ropeStartEnt, ropeData.otherRopeEndEnt, droneAttchmentId, 0, 1, "models/cable/drone_medic_cable", ROPE_NODE_COUNT )
	ropeData.otherRope = rope
	HealRopeInit( rope, player, true )
	rope.kv.VisibilityFlags = ( player.IsPlayer() && player.ContextAction_IsInVehicle() ) ? ENTITY_VISIBLE_TO_EVERYONE : ENTITY_VISIBLE_TO_FRIENDLY | ENTITY_VISIBLE_TO_ENEMY

	SetRopeLength( player, ropeData.ropeStartEnt, ropeData )

	ropeData.playerRopeEndEnt.NonPhysicsMoveInWorldSpaceToLocalPos( playerOrigin, ROPE_SHOOT_OUT_TIME, 0, ROPE_SHOOT_OUT_TIME )
	ropeData.otherRopeEndEnt.NonPhysicsMoveInWorldSpaceToLocalPos( localOrigin, ROPE_SHOOT_OUT_TIME, 0, ROPE_SHOOT_OUT_TIME )

	file.playerRopes[player].append( playerRope )
	file.otherRopes[player].append( rope )

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
	rope.SetOwner( player )

	rope.RemoveFromAllRealms()
	rope.AddToOtherEntitysRealms( player )
}

void function SetRopeLength( entity player, entity droneMedic, HealRopeData ropeData )
{
	if( !IsValid( ropeData.otherRope ) || !IsValid( ropeData.playerRope ) )
		return
	
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


bool function HasMaxNumberOfDroneConnections( entity player )
{
	if ( !IsValid( player ) || !player.IsPlayer() )
		return false

	return player.p.connectedLifelineDrones >= 2
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
	
	thread DeployableMedic_HealVisualsThread( player, file.healFxHandle, statusEffect )
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

void function DeployableMedic_HealVisualsThread( entity viewPlayer, int fxHandle, int statusEffect )
{
	EndSignal( viewPlayer, "OnDeath" )

	OnThreadEnd(
		function() : ( viewPlayer, fxHandle )
		{
			if ( EffectDoesExist( fxHandle ) )
				EffectStop( fxHandle, false, true )

			if ( file.healFxHandle != -1 )
				file.healFxHandle = -1
		}
	)

	while ( StatusEffect_GetSeverity( viewPlayer, statusEffect ) > 0 )
		WaitFrame()
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

#if SERVER
array<entity> function GetAllHealDrones()
{
	array<entity> drones
	foreach ( drone,data in file.deployableData )
	{
		drones.append(drone)
	}
	return drones
}
#endif
#if SERVER || CLIENT
entity function GetHealDroneForHitEnt( entity hitEnt )
{
	if ( hitEnt.GetScriptName() == DEPLOYABLE_MEDIC_SCRIPT_NAME )
		return hitEnt

	entity parentEnt = hitEnt.GetParent()
	if ( IsValid( parentEnt ) && parentEnt.GetScriptName() == DEPLOYABLE_MEDIC_SCRIPT_NAME )
		return parentEnt

	return null
}
#endif