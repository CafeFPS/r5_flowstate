untyped

global function ProtoBatteryCharger_Init
global function OnWeaponTossPrep_BatteryCharger
global function OnWeaponTossReleaseAnimEvent_BatteryCharger

global function OnWeaponActivate_battery_charger
global function OnWeaponDeactivate_battery_charger
global function OnWeaponOwnerChanged_battery_charger
global function OnWeaponChargeBegin_battery_charger
global function OnWeaponChargeEnd_battery_charger
global function OnWeaponPrimaryAttack_battery_charger

#if SERVER
	//global function OnWeaponNpcPrimaryAttack_battery_charger
	//global function OnWeaponNpcPreAttack_battery_charger
#endif //SERVER

const DEBUG_DRAW = false
const SERVER_EFFECTS = true

const SOUND_CHARGE_BEGIN_1P = "Weapon_BatteryGun_FireStart_1P"
const SOUND_CHARGE_BEGIN_3P = "Weapon_BatteryGun_FireStart_3P"
const SOUND_CHARGE_END = "Weapon_BatteryGun_FireStop_1P"
const SOUND_END_WARNING = "Weapon_BatteryGun_Fire_EndWarning_1P"
const SOUND_END_WARNING_DURATION = 2.1
const SOUND_CHARGE_END_DRAINED = "Weapon_BatteryGun_Fire_EnergyDrained_1P"

const BATTERY_CHARGER_SIGNAL_DEACTIVATED = "BatteryChargerDeactivated"
const BATTERY_CHARGER_SIGNAL_CHARGEEND = "BatteryChargerChargeEnd"

const MAX_BEAM_DISTANCE	= 1000

const CHARGE_BEAM_EFFECT_ENT = $"P_wpn_charge_tool_beam"
const CHARGE_BEAM_EFFECT_GEO = $"P_wpn_charge_tool_beam"
const CHARGE_BEAM_EFFECT_DUD = $"P_wpn_charge_tool_notarget"

global const CHARGE_TOOL = "mp_weapon_arc_tool"

struct BeamTarget
{
	entity target
	vector hitPos
	asset effectToPlay
}

function ProtoBatteryCharger_Init()
{
	PrecacheParticleSystem( $"wpn_muzzleflash_arc_cannon_fp" )
	PrecacheParticleSystem( $"wpn_muzzleflash_arc_cannon" )
	PrecacheParticleSystem( CHARGE_BEAM_EFFECT_ENT )
	PrecacheParticleSystem( CHARGE_BEAM_EFFECT_GEO )
	PrecacheParticleSystem( CHARGE_BEAM_EFFECT_DUD )
	PrecacheParticleSystem( $"wpn_laser_beam" )
	PrecacheParticleSystem( $"hud_ar_line" )

	#if CLIENT
		//AddDestroyCallback( CHARGE_TOOL, ClientDestroyCallback_BatteryCharger_Stop )
	#endif

	RegisterSignal( "BatteryChargerStopNPCChargeReset" )
	RegisterSignal( "BatteryChargerSignalNPCChargeReset" )
	RegisterSignal( BATTERY_CHARGER_SIGNAL_DEACTIVATED )
	RegisterSignal( BATTERY_CHARGER_SIGNAL_CHARGEEND )
}

void function OnWeaponActivate_battery_charger( entity weapon )
{
	#if SERVER
		//thread UpdateArcConnectorHints()
	#endif
}

void function OnWeaponDeactivate_battery_charger( entity weapon )
{
	#if SERVER
		//thread UpdateArcConnectorHints( true )
	#endif
	BatteryCharger_Stop( weapon )
}

void function OnWeaponOwnerChanged_battery_charger( entity weapon, WeaponOwnerChangedParams changeParams )
{
	if ( changeParams.newOwner == null && changeParams.oldOwner != null )
	{
		#if CLIENT
			if ( changeParams.oldOwner == GetLocalViewPlayer() )
				BatteryCharger_Stop( weapon )
		#else
			BatteryCharger_Stop( weapon )
		#endif
	}
}

bool function OnWeaponChargeBegin_battery_charger( entity weapon )
{
	#if CLIENT
		if ( InPrediction() && !IsFirstTimePredicted() )
			return true
	#endif

	WeaponPrimaryAttackParams attackParams
	attackParams.dir = weapon.GetAttackDirection()
	attackParams.pos = weapon.GetAttackPosition()
	// HACK: this needs a code feature to work with prediction (may be low risk for SP though)
	thread ChargeBeamThink_BatteryCharger( weapon, attackParams )

	#if SERVER
		entity player = weapon.GetWeaponOwner()
		if ( IsValid( player ) && player.IsPlayer() && IsCloaked( player ) )
			DisableCloak( player )
	#endif // SERVER

	return true
}

void function OnWeaponChargeEnd_battery_charger( entity weapon )
{
	ArcToolChargeEnd( weapon )
}

void function ArcToolChargeEnd( entity weapon )
{
	#if CLIENT
		if ( InPrediction() && !IsFirstTimePredicted() )
			return
	#endif

	weapon.Signal( BATTERY_CHARGER_SIGNAL_CHARGEEND )

	weapon.StopWeaponSound( SOUND_CHARGE_BEGIN_1P )
	weapon.StopWeaponSound( SOUND_CHARGE_BEGIN_3P )

	if ( weapon.GetWeaponChargeFraction() >= 1.0 )
	{
		weapon.EmitWeaponSound( SOUND_CHARGE_END_DRAINED )
	}
	else
	{
		weapon.EmitWeaponSound( SOUND_CHARGE_END )
	}

	#if CLIENT
		StopSoundOnEntity( weapon, SOUND_END_WARNING )
	#endif // CLIENT

	weapon.StopWeaponEffect( CHARGE_BEAM_EFFECT_ENT, CHARGE_BEAM_EFFECT_ENT )
	weapon.StopWeaponEffect( CHARGE_BEAM_EFFECT_GEO, CHARGE_BEAM_EFFECT_GEO )
	weapon.StopWeaponEffect( CHARGE_BEAM_EFFECT_DUD, CHARGE_BEAM_EFFECT_DUD )
}

void function OnWeaponTossPrep_BatteryCharger( entity weapon, WeaponTossPrepParams tossPrepParams )
{
}

var function OnWeaponTossReleaseAnimEvent_BatteryCharger( entity weapon, WeaponPrimaryAttackParams attackParams )
{

}


var function OnWeaponPrimaryAttack_battery_charger( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity weaponOwner = weapon.GetOwner()

	if ( !IsValid( weaponOwner ) )
		return 0

	PlayerUsedOffhand( weaponOwner, weapon )

	return 1
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_battery_charger( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	thread NPCFireArcToolOnce( weapon, attackParams )
	return 1
}

void function NPCFireArcToolOnce( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	thread ChargeBeamThink_BatteryCharger( weapon, attackParams, false )
	wait 0.8
	if ( IsValid( weapon ) )
		ArcToolChargeEnd( weapon )
}
#endif

void function BatteryCharger_Stop( weapon )
{
	weapon.Signal( BATTERY_CHARGER_SIGNAL_DEACTIVATED )
}

#if SERVER
void function OnWeaponNpcPreAttack_battery_charger( entity weapon )
{
	thread DoNPCPreAttackFX( weapon )
}

void function DoNPCPreAttackFX( entity weapon )
{
	weapon.EndSignal( "OnDestroy" )
	entity weaponOwner = weapon.GetWeaponOwner()
	weaponOwner.EndSignal( "OnDestroy" )

	thread BatteryChargerNPCChargeReset( weaponOwner, weapon )
}

void function BatteryChargerNPCChargeReset( entity weaponOwner, entity weapon )
{
	if ( !IsAlive( weaponOwner ) )
		return

	weaponOwner.EndSignal( "OnDeath" )
	weaponOwner.EndSignal( "OnDestroy" )
	weaponOwner.EndSignal( "BatteryChargerStopNPCChargeReset" )
	thread StopNPCWeaponEffect( weaponOwner, weapon )

	OnThreadEnd(
		function() : ( weaponOwner )
		{
			if ( IsValid( weaponOwner ) )
			{
				weaponOwner.Signal( "BatteryChargerSignalNPCChargeReset" )
			}
		}
	)

	wait 1.5 //charge time for NPC
}

function StopNPCWeaponEffect( weaponOwner, weapon )
{
	WaitSignal( weaponOwner, "OnDeath", "BatteryChargerStopNPCChargeReset", "BatteryChargerSignalNPCChargeReset" )

	if ( !IsValid( weapon ) )
		return
}
/*
void function GunGetsSmallChargeFromSwitch( entity weapon )
{
	if ( !IsValid( weapon ) )
		return
	entity owner = weapon.GetWeaponOwner()
	if ( !IsValid( owner ) || !IsAlive( owner ) )
		return

	EndSignal( weapon, BATTERY_CHARGER_SIGNAL_CHARGEEND )
	EndSignal( owner, "OnDeath" )
	EndSignal( owner, "OnDestroy" )

	while( IsValid( weapon ) && IsValid( owner ) )
	{
		WaitSignal( owner, "ActivatedArcSwitch" )
		float fraction = weapon.GetWeaponChargeFraction()
		fraction = max( fraction - 0.2, 0.0 )
		weapon.SetWeaponChargeFraction( fraction )
	}
}
*/
#endif // SERVER

#if CLIENT
void function ClientDestroyCallback_BatteryCharger_Stop( entity ent )
{
	BatteryCharger_Stop( ent )
}

// hacky (temp I hope) fix for starting and stopping an effect on the same frame not actually stopping the effect.
void function HACK_EffectStopNextFrame( int handle, bool doRemoveAllParticlesNow, bool doPlayEndCap )
{
	WaitFrame()
	if ( EffectDoesExist( handle ) )
	{
		printt( "stop beem effect a frame later", handle )
		EffectStop( handle, doRemoveAllParticlesNow, doPlayEndCap )
	}
}
#endif // CLIENT

void function ChargeBeamThink_BatteryCharger( entity weapon, WeaponPrimaryAttackParams attackParams, bool playerFired = true )
{
	table e
	e.handle <- 0
	OnThreadEnd(
		function() : ( weapon, e )
		{
			if ( IsValid( weapon ) )
			{
				weapon.StopWeaponEffect( CHARGE_BEAM_EFFECT_ENT, CHARGE_BEAM_EFFECT_ENT )
				weapon.StopWeaponEffect( CHARGE_BEAM_EFFECT_GEO, CHARGE_BEAM_EFFECT_GEO )
				weapon.StopWeaponEffect( CHARGE_BEAM_EFFECT_DUD, CHARGE_BEAM_EFFECT_DUD )
			}
		}
	)
	EndSignal( weapon, BATTERY_CHARGER_SIGNAL_CHARGEEND )

	//wait 0.15 // so a little charge doesn't play at start

	weapon.StopWeaponSound( SOUND_CHARGE_END )
	weapon.StopWeaponSound( SOUND_CHARGE_END_DRAINED )

	if ( playerFired )
		weapon.EmitWeaponSound( SOUND_CHARGE_BEGIN_1P )

	weapon.EmitWeaponSound( SOUND_CHARGE_BEGIN_3P )

	bool endWarningPlayed = false
	BeamTarget beamTarget = GetBeamTarget( weapon, attackParams )
	asset lastEffectToPlay = beamTarget.effectToPlay

#if SERVER
	weapon.PlayWeaponEffect( beamTarget.effectToPlay, $"", "muzzle_flash" )
#else
	e.handle = weapon.PlayWeaponEffectReturnViewEffectHandle( beamTarget.effectToPlay, $"", "muzzle_flash" )
#endif

	float startTime = Time()

	#if SERVER
		table serverBeam = { cpEnd = null, beamSystem = null }
		if ( SERVER_EFFECTS )
		{
			serverBeam.cpEnd = CreateEntity( "info_placement_helper" )
			SetTargetName( expect entity( serverBeam.cpEnd ), UniqueString( "battery_gun_beam_cpEnd" ) )
			serverBeam.cpEnd.SetOrigin( beamTarget.hitPos )
			DispatchSpawn( serverBeam.cpEnd )

			serverBeam.beamSystem = CreateServerBeamWithControlPoint( weapon, beamTarget.effectToPlay, serverBeam.cpEnd )
		}
		OnThreadEnd(
		function() : ( serverBeam )
			{
				if ( IsValid( serverBeam.beamSystem ) )
					serverBeam.beamSystem.Destroy()
				if ( IsValid( serverBeam.cpEnd ) )
					serverBeam.cpEnd.Destroy()
			}
		)
	#endif //SERVER

	while ( IsValid( weapon ) && IsValid( weapon.GetWeaponOwner() ) )
	{
		if ( weapon.GetWeaponOwner().IsPlayer() )
		{
			attackParams.dir = weapon.GetAttackDirection()
			attackParams.pos = weapon.GetAttackPosition()
		}
		beamTarget = GetBeamTarget( weapon, attackParams )
		//beamTarget.hitPos

		#if CLIENT
			float chargeTimeRemaining = weapon.GetWeaponChargeTimeRemaining()
			if ( !endWarningPlayed && chargeTimeRemaining <= SOUND_END_WARNING_DURATION && chargeTimeRemaining > 0 )
			{
				float leadin = SOUND_END_WARNING_DURATION - chargeTimeRemaining
				endWarningPlayed = true
				EmitSoundOnEntityWithSeek( weapon, SOUND_END_WARNING, leadin )
			}

			if ( DEBUG_DRAW )
			{
				if ( IsValid( beamTarget.target ) )
					DebugDrawSphere( beamTarget.hitPos, 16, 255, 0, 0, true, 0.1 )
				else
					DebugDrawSphere( beamTarget.hitPos, 16, 255, 255, 255, true, 0.1 )
			}

			if ( lastEffectToPlay != beamTarget.effectToPlay )
			{
				weapon.StopWeaponEffect( CHARGE_BEAM_EFFECT_ENT, CHARGE_BEAM_EFFECT_ENT )
				weapon.StopWeaponEffect( CHARGE_BEAM_EFFECT_GEO, CHARGE_BEAM_EFFECT_GEO )
				weapon.StopWeaponEffect( CHARGE_BEAM_EFFECT_DUD, CHARGE_BEAM_EFFECT_DUD )
				int oldHandle = expect int( e.handle )
				e.handle = weapon.PlayWeaponEffectReturnViewEffectHandle( beamTarget.effectToPlay, $"", "muzzle_flash" )
				if ( EffectDoesExist( oldHandle ) )
				{
					EffectStop( oldHandle, true, false )
				}
			}
			lastEffectToPlay = beamTarget.effectToPlay

			if ( EffectDoesExist( e.handle ) )
				EffectSetControlPointVector( e.handle, 1, beamTarget.hitPos )

		#endif // CLIENT

		#if SERVER
			if ( SERVER_EFFECTS )
			{
				serverBeam.cpEnd.SetOrigin( beamTarget.hitPos )
				if ( lastEffectToPlay != beamTarget.effectToPlay )
				{
					serverBeam.beamSystem.Destroy()
					serverBeam.beamSystem = CreateServerBeamWithControlPoint( weapon, beamTarget.effectToPlay, serverBeam.cpEnd )
				}
				lastEffectToPlay = beamTarget.effectToPlay
			}

			if ( Time() > startTime + 0.05 )
			{
				// Only damage stuff after the beam has been created for a moment

				if ( IsValid( beamTarget.target ) && beamTarget.target != weapon.GetWeaponOwner() )
				{
					entity owner = weapon.GetWeaponOwner()
					beamTarget.target.TakeDamage( weapon.GetWeaponSettingInt( eWeaponVar.damage_far_value ), owner, owner, { origin = owner.GetOrigin(), force = <0,0,0>, scriptType = DF_INSTANT | DF_ELECTRICAL | DF_DISSOLVE, weapon = weapon, damageSourceId = eDamageSourceId.mp_weapon_defender } )
				}
			}

		#endif // SERVER

		WaitFrame()
	}
}

BeamTarget function GetBeamTarget( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	vector weaponPos = attackParams.pos
	vector weaponVec = attackParams.dir

	//#########################################################
	// If smart ammo is targeting something return that target
	//#########################################################

	if ( weapon.SmartAmmo_IsEnabled() )
	{
		array< SmartAmmoTarget > targets = weapon.SmartAmmo_GetTargets()
		foreach( target in targets )
		{
			if ( target.fraction < 1 )
				continue
			if ( !target.visible )
				continue

			BeamTarget smartTarget
			smartTarget.target = target.ent
			smartTarget.hitPos = target.ent.GetWorldSpaceCenter()
			smartTarget.effectToPlay = CHARGE_BEAM_EFFECT_ENT

			return smartTarget
		}
	}
	else
	{
		//#####################################
		// Get best entity in a cone from code
		//#####################################

		BeamTarget beamTargetConeCheck
		entity owner 				= weapon.GetWeaponOwner()
		float angleToAxis 			= owner.IsPlayer() ? 8.0 : 15.0
		array<entity> ignoredEntities = [ owner, weapon ]
		int traceMask 			= TRACE_MASK_SHOT
		int flags					= VIS_CONE_ENTS_IGNORE_VORTEX
		entity antilagPlayer		= null
		if ( owner.IsPlayer() )
			antilagPlayer = owner
		int ownerTeam = owner.GetTeam()

		array<VisibleEntityInCone> results = FindVisibleEntitiesInCone( weaponPos, weaponVec, MAX_BEAM_DISTANCE, angleToAxis, ignoredEntities, traceMask, flags, antilagPlayer )
		entity coneResultEntity
		foreach( result in results )
		{
			entity visibleEnt = result.ent
			if ( !IsValid( visibleEnt ) )
				continue

			if ( visibleEnt.IsPhaseShifted() )
				continue

		    #if SERVER
			string classname = visibleEnt.GetClassName()
			if ( ArcCannonTargetClassnames.find( classname ) == -1)
				continue
			#endif

			if ( "GetTeam" in visibleEnt )
			{
				int visibleEntTeam = visibleEnt.GetTeam()
				if ( visibleEntTeam == ownerTeam )
					continue

				if ( IsEntANeutralMegaTurret( visibleEnt, ownerTeam ) )
					continue
			}

			beamTargetConeCheck.target = visibleEnt
			beamTargetConeCheck.hitPos = result.visiblePosition
			beamTargetConeCheck.effectToPlay = CHARGE_BEAM_EFFECT_ENT
			break
		}
	}

	// If we didn't find an entity target then just do a trace forward
	entity player = weapon.GetWeaponOwner()
	vector traceStartPos = player.EyePosition() + <0,-22,0>
	vector traceEndPos = traceStartPos + ( weaponVec * MAX_BEAM_DISTANCE )
	TraceResults traceResults = TraceLineHighDetail( traceStartPos, traceEndPos, weapon, (TRACE_MASK_SHOT | TRACE_MASK_BLOCKLOS), TRACE_COLLISION_GROUP_NONE )

	//DebugDrawLine( traceStartPos, traceResults.endPos, 255, 255, 0, true, 0.1 )

	BeamTarget beamTarget

	beamTarget.target = null
	if ( IsValid ( traceResults.hitEnt ) && traceResults.hitEnt != GetEntByIndex( 0 ) )
		beamTarget.target = traceResults.hitEnt

	beamTarget.hitPos = traceResults.endPos
	if ( IsValid( beamTarget.target ) )
		beamTarget.effectToPlay = CHARGE_BEAM_EFFECT_ENT
	else if ( traceResults.fraction < 1.0 )
		beamTarget.effectToPlay = CHARGE_BEAM_EFFECT_GEO
	else
		beamTarget.effectToPlay = CHARGE_BEAM_EFFECT_DUD

	return beamTarget
}

#if SERVER
entity function CreateServerBeamWithControlPoint( entity weapon, asset effect, var controlPoint )
{
	entity beamSystem = CreateEntity( "info_particle_system" )
	beamSystem.kv.cpoint1 = controlPoint.GetTargetName()
	beamSystem.SetValueForEffectNameKey( effect )
	beamSystem.kv.start_active = 0
	beamSystem.SetOwner( weapon.GetWeaponOwner() )


	if(!weapon.GetOwner().IsThirdPersonShoulderModeOn())
	    beamSystem.kv.VisibilityFlags = (ENTITY_VISIBLE_TO_FRIENDLY | ENTITY_VISIBLE_TO_ENEMY)	// everyone but owner

	beamSystem.SetParent( weapon.GetWeaponOwner().GetActiveWeapon(eActiveInventorySlot.mainHand), "muzzle_flash", false, 0.0 )
	DispatchSpawn( beamSystem )

	beamSystem.Fire( "Start" )

	return beamSystem
}
#endif //SERVER