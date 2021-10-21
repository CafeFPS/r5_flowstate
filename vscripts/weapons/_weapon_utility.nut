untyped

//TODO: Should split this up into server, client and shared versions and just globalize_all_functions
global function WeaponUtility_Init

global function ApplyVectorSpread
global function DebugDrawMissilePath
global function DegreesToTarget
global function EntityCanHaveStickyEnts
global function EntityShouldStick
global function FireExpandContractMissiles
global function FireExpandContractMissiles_S2S
global function GetVectorFromPositionToCrosshair
global function GetVelocityForDestOverTime
global function GetPlayerVelocityForDestOverTime
global function GetWeaponBurnMods
global function InitMissileForRandomDriftForVortexLow
global function IsPilotShotgunWeapon
global function PlantStickyEntity
global function PlantStickyEntityThatBouncesOffWalls
global function PlantStickyEntityOnWorldThatBouncesOffWalls
global function PlantStickyGrenade
global function PlantSuperStickyGrenade
global function Player_DetonateSatchels
global function PROTO_CanPlayerDeployWeapon
global function ProximityCharge_PostFired_Init
global function EnergyChargeWeapon_OnWeaponChargeLevelIncreased
global function EnergyChargeWeapon_OnWeaponChargeBegin
global function EnergyChargeWeapon_OnWeaponChargeEnd
global function Fire_EnergyChargeWeapon
global function FireHitscanShotgunBlast
global function FireProjectileShotgunBlast
global function ProjectileShotgun_GetOuterSpread
global function ProjectileShotgun_GetInnerSpread
global function FireProjectileBlastPattern
global function FireGenericBoltWithDrop
global function OnWeaponPrimaryAttack_GenericBoltWithDrop_Player
global function OnWeaponPrimaryAttack_GenericMissile_Player
global function OnWeaponActivate_updateViewmodelAmmo
global function TEMP_GetDamageFlagsFromProjectile
global function WeaponCanCrit
global function GiveEMPStunStatusEffects
global function GetPrimaryWeapons
global function GetSidearmWeapons
global function GetATWeapons
global function GetPlayerFromTitanWeapon
global function GetMaxTrackerCountForTitan
global function FireBallisticRoundWithDrop
global function DoesModExist
global function DoesModExistFromWeaponClassName
global function IsModActive
global function PlayerUsedOffhand
global function GetDistanceString
global function IsWeaponInSingleShotMode
global function IsWeaponInBurstMode
global function IsWeaponOffhand
global function IsWeaponInAutomaticMode
global function OnWeaponReadyToFire_ability_tactical
global function GetMeleeWeapon
global function OnWeaponRegenEndGeneric
global function Ultimate_OnWeaponRegenBegin
global function OnWeaponActivate_RUIColorSchemeOverrides
global function PlayDelayedShellEject

#if SERVER
global function CreateDamageInflictorHelper
global function DelayedDestroyDamageInflictorHelper
global function SetPlayerCooldowns
global function ResetPlayerCooldowns
global function StoreOffhandData
global function CreateOncePerTickDamageInflictorHelper
global function WeaponHasCosmetics
#endif

#if CLIENT
global function ServerCallback_SetWeaponPreviewState
#endif

global function GetRadiusDamageDataFromProjectile
global function OnWeaponAttemptOffhandSwitch_Never

#if R5DEV
global function DevPrintAllStatusEffectsOnEnt
#endif // #if R5DEV

#if SERVER
global function PassThroughDamage
global function PROTO_CleanupTrackedProjectiles
global function PROTO_InitTrackedProjectile
global function PROTO_PlayTrapLightEffect
global function Satchel_PostFired_Init
global function StartClusterExplosions
global function TrapDestroyOnRoundEnd
global function TrapExplodeOnDamage
global function PROTO_DelayCooldown
global function PROTO_FlakCannonMissiles
global function GetBulletPassThroughTargets
global function IsValidPassThroughTarget
global function GivePlayerAmpedWeapon
global function GivePlayerAmpedWeaponAndSetAsActive
global function ReplacePlayerOffhand
global function ReplacePlayerOrdnance
global function DisallowWeaponDeploy
global function AllowWeaponDeploy
global function DisallowAllWeaponDeployment
global function AllowAllWeaponUsageDeployment
global function StartForceAllowSpecificWeaponDeployment
global function StopForceAllowSpecificWeaponDeployment
global function GetAllPlayerWeapons
global function WeaponAttackWave
global function AddActiveThermiteBurn
global function GetActiveThermiteBurnsWithinRadius
global function OnWeaponPrimaryAttack_GenericBoltWithDrop_NPC
global function OnWeaponPrimaryAttack_GenericMissile_NPC
global function EMP_DamagedPlayerOrNPC
global function EMP_FX
global function GetWeaponDPS
global function GetTTK
global function GetWeaponModsFromDamageInfo
global function Thermite_DamagePlayerOrNPCSounds
global function AddThreatScopeColorStatusEffect
global function RemoveThreatScopeColorStatusEffect
global function LimitVelocityHorizontal
global function GiveMatchingAkimboWeapon
global function TakeMatchingAkimboWeapon
global function GetDualPrimarySlotForWeapon
global function AddWeaponModChangedCallback
global function TryApplyingBurnDamage
global function AddEntityBurnDamageStack
global function ApplyBurnDamageTick

#if R5DEV
global function ToggleZeroingMode
#endif

#endif //SERVER

#if CLIENT
global function GlobalClientEventHandler
global function UpdateViewmodelAmmo
global function IsOwnerViewPlayerFullyADSed
global function ServerCallback_SatchelPlanted
#endif //CLIENT

global function AddCallback_OnPlayerAddWeaponMod
global function AddCallback_OnPlayerRemoveWeaponMod

global function CodeCallback_OnPlayerAddedWeaponMod
global function CodeCallback_OnPlayerRemovedWeaponMod

global const bool PROJECTILE_PREDICTED = true
global const bool PROJECTILE_NOT_PREDICTED = false

global const bool PROJECTILE_LAG_COMPENSATED = true
global const bool PROJECTILE_NOT_LAG_COMPENSATED = false

global const PRO_SCREEN_IDX_MATCH_KILLS 					= 1
global const PRO_SCREEN_IDX_AMMO_COUNTER_OVERRIDE_HACK 		= 2

const float DEFAULT_SHOTGUN_SPREAD_INNEREXCLUDE_FRAC 		= 0.4
const bool DEBUG_PROJECTILE_BLAST = false

const float EMP_SEVERITY_SLOWTURN 				= 0.35
const float EMP_SEVERITY_SLOWMOVE 				= 0.50
const float LASER_STUN_SEVERITY_SLOWTURN 		= 0.20
const float LASER_STUN_SEVERITY_SLOWMOVE 		= 0.30

const asset FX_EMP_BODY_HUMAN 				= $"P_emp_body_human"
const asset FX_EMP_BODY_TITAN 				= $"P_emp_body_titan"
const asset FX_VANGUARD_ENERGY_BODY_HUMAN 	= $"P_monarchBeam_body_human"
const asset FX_VANGUARD_ENERGY_BODY_TITAN 	= $"P_monarchBeam_body_titan"
const SOUND_EMP_REBOOT_SPARKS 				= "marvin_weld"
const FX_EMP_REBOOT_SPARKS 					= $"weld_spark_01_sparksfly"
const EMP_GRENADE_BEAM_EFFECT 				= $"wpn_arc_cannon_beam"
const DRONE_REBOOT_TIME 					= 5.0
const GUNSHIP_REBOOT_TIME 					= 5.0

const bool DEBUG_BURN_DAMAGE 				= false

const float BOUNCE_STUCK_DISTANCE 			= 5.0

global struct RadiusDamageData
{
	int   explosionDamage
	int   explosionDamageHeavyArmor
	float explosionRadius
	float explosionInnerRadius
}

global struct EnergyChargeWeaponData
{
	array<vector> blastPattern
	string        fx_barrel_glow_attach
	asset         fx_barrel_glow_final_1p
	asset         fx_barrel_glow_final_3p
}

#if SERVER

global struct PopcornInfo
{
	string weaponName
	array  weaponMods // could be array<string>
	int    damageSourceId
	int    count
	float  delay
	float  offset
	float  range
	vector normal
	float  duration
	int    groupSize
	bool   hasBase
}

struct ColorSwapStruct
{
	int    statusEffectId
	entity weaponOwner
}

global struct HoverSounds
{
	string liftoff_1p
	string liftoff_3p
	string hover_1p
	string hover_3p
	string descent_1p
	string descent_3p
	string landing_1p
	string landing_3p
}
#endif

struct
{
	#if SERVER
		float titanRocketLauncherTitanDamageRadius
		float titanRocketLauncherOtherDamageRadius

		int                    activeThermiteBurnsManagedEnts
		array<ColorSwapStruct> colorSwapStatusEffects

		table<string, array<void functionref( entity, string, bool )> > weaponModChangedCallbacks

		#if R5DEV
			bool inZeroingMode = false
		#endif

	#else // CLIENT
		var satchelHintRUI = null
	#endif

	array<void functionref( entity, entity, string )> playerAddWeaponModCallbacks
	array<void functionref( entity, entity, string )> playerRemoveWeaponModCallbacks
} file

global int HOLO_PILOT_TRAIL_FX


void function WeaponUtility_Init()
{
	level.weaponsPrecached <- {}

	// what classes can sticky thrown entities stick to?
	level.stickyClasses <- {}
	level.stickyClasses[ "worldspawn" ]                <- true
	level.stickyClasses[ "player" ]                    <- true
	level.stickyClasses[ "prop_dynamic" ]            <- true
	level.stickyClasses[ "prop_script" ]            <- true
	level.stickyClasses[ "func_brush" ]                <- true
	level.stickyClasses[ "func_brush_lightweight" ]    <- true
	level.stickyClasses[ "phys_bone_follower" ]        <- true
	level.stickyClasses[ "door_mover" ]                <- true
	level.stickyClasses[ "prop_door" ]                <- true
	level.stickyClasses[ "script_mover" ]                <- true
	level.stickyClasses[ "player_vehicle" ]                <- true

	level.trapChainReactClasses <- {}
	level.trapChainReactClasses[ "mp_weapon_frag_grenade" ]            <- true
	level.trapChainReactClasses[ "mp_weapon_satchel" ]                <- true
	level.trapChainReactClasses[ "mp_weapon_proximity_mine" ]        <- true
	level.trapChainReactClasses[ "mp_weapon_laser_mine" ]            <- true

	RegisterSignal( "Planted" )
	RegisterSignal( "OnKnifeStick" )
	RegisterSignal( "EMP_FX" )
	RegisterSignal( "ArcStunned" )
	RegisterSignal( "CleanupPlayerPermanents" )
	RegisterSignal( "PlayerChangedClass" )
	RegisterSignal( "OnSustainedDischargeEnd" )
	RegisterSignal( "EnergyWeapon_ChargeStart" )
	RegisterSignal( "EnergyWeapon_ChargeReleased" )
	RegisterSignal( "WeaponSignal_EnemyKilled" )

	PrecacheParticleSystem( EMP_GRENADE_BEAM_EFFECT )
	PrecacheParticleSystem( FX_EMP_BODY_TITAN )
	PrecacheParticleSystem( FX_EMP_BODY_HUMAN )
	PrecacheParticleSystem( FX_VANGUARD_ENERGY_BODY_HUMAN )
	PrecacheParticleSystem( FX_VANGUARD_ENERGY_BODY_TITAN )
	PrecacheParticleSystem( FX_EMP_REBOOT_SPARKS )

	PrecacheImpactEffectTable( CLUSTER_ROCKET_FX_TABLE )

	#if SERVER
		AddDamageCallbackSourceID( eDamageSourceId.mp_weapon_grenade_emp, EMP_DamagedPlayerOrNPC )
		AddDamageCallbackSourceID( eDamageSourceId.damagedef_ticky_arc_blast, EMP_DamagedPlayerOrNPC )
		AddCallback_OnPlayerRespawned( PROTO_TrackedProjectile_OnPlayerRespawned )
		AddCallback_OnPlayerKilled( PAS_CooldownReduction_OnKill )
		AddCallback_OnPlayerGetsNewPilotLoadout( OnPlayerGetsNewPilotLoadout )
		AddCallback_OnPlayerKilled( OnPlayerKilled )
		AddCallback_OnPlayerRespawned( WeaponAllowLogic_OnPlayerRespawed )
		AddCallback_OnPlayerInventoryChanged( WeaponAllowLogic_OnPlayerInventoryChanged )

		file.activeThermiteBurnsManagedEnts = CreateScriptManagedEntArray()

		AddCallback_EntitiesDidLoad( EntitiesDidLoad )
		PrecacheParticleSystem( $"wpn_laser_blink" )
		PrecacheParticleSystem( $"wpn_laser_blink_fast" )
		PrecacheParticleSystem( $"P_ordinance_icon_owner" )
	#endif

	HOLO_PILOT_TRAIL_FX = PrecacheParticleSystem( $"P_ar_holopilot_trail" )
}

#if SERVER
void function EntitiesDidLoad()
{
	// if we are going to do this, it should happen in the weapon, not globally
	//float titanRocketLauncherInnerRadius = expect float( GetWeaponInfoFileKeyField_Global( "mp_titanweapon_rocketeer_rocketstream", "explosion_inner_radius" ) )
	//float titanRocketLauncherOuterRadius = expect float( GetWeaponInfoFileKeyField_Global( "mp_titanweapon_rocketeer_rocketstream", "explosionradius" ) )
	//file.titanRocketLauncherTitanDamageRadius = titanRocketLauncherInnerRadius + ( ( titanRocketLauncherOuterRadius - titanRocketLauncherInnerRadius ) * 0.4 )
	//file.titanRocketLauncherOtherDamageRadius = titanRocketLauncherInnerRadius + ( ( titanRocketLauncherOuterRadius - titanRocketLauncherInnerRadius ) * 0.1 )
}
#endif

////////////////////////////////////////////////////////////////////

#if CLIENT
void function GlobalClientEventHandler( entity weapon, string name )
{
	if ( name == "ammo_update" )
		UpdateViewmodelAmmo( false, weapon )

	if ( name == "ammo_full" )
		UpdateViewmodelAmmo( true, weapon )
}

void function UpdateViewmodelAmmo( bool forceFull, entity weapon )
{
	Assert( weapon != null ) // used to be: if ( weapon == null ) weapon = this.self

	if ( !IsValid( weapon ) )
		return
	if ( !IsLocalViewPlayer( weapon.GetWeaponOwner() ) )
		return

	int bodyGroupCount = weapon.GetWeaponSettingInt( eWeaponVar.bodygroup_ammo_index_count )
	if ( bodyGroupCount <= 0 )
		return

	int rounds                = weapon.GetWeaponPrimaryClipCount()
	int maxRoundsForClipSize  = weapon.GetWeaponPrimaryClipCountMax()
	int maxRoundsForBodyGroup = (bodyGroupCount - 1)
	int maxRounds             = minint( maxRoundsForClipSize, maxRoundsForBodyGroup )

	if ( forceFull || (rounds > maxRounds) )
		rounds = maxRounds

	//printt( "ROUNDS:", rounds, "/", maxRounds )
	weapon.SetViewmodelAmmoModelIndex( rounds )
}
#endif // #if CLIENT

void function OnWeaponActivate_updateViewmodelAmmo( entity weapon )
{
	#if CLIENT
		UpdateViewmodelAmmo( false, weapon )
	#endif // #if CLIENT
}

void function OnWeaponActivate_RUIColorSchemeOverrides( entity weapon )
{
	#if SERVER
	#endif
}

int function Fire_EnergyChargeWeapon( entity weapon, WeaponPrimaryAttackParams attackParams, EnergyChargeWeaponData chargeWeaponData, bool playerFired = true, float patternScale = 1.0, bool ignoreSpread = true )
{
	int chargeLevel = EnergyChargeWeapon_GetChargeLevel( weapon )
	//printt( "LVL", chargeLevel )
	if ( chargeLevel == 0 )
		return 0

	// scale spread pattern for weapon charge level
	float spreadChokeFrac = 1.0
	// NOTE uses a switch instead of concatenating the string, so we can search for the same string that is in weaponsettings
	switch( chargeLevel )
	{
		case 1:
			spreadChokeFrac = expect float( weapon.GetWeaponInfoFileKeyField( "projectile_spread_choke_frac_1" ) )
			break

		case 2:
			spreadChokeFrac = expect float( weapon.GetWeaponInfoFileKeyField( "projectile_spread_choke_frac_2" ) )
			break

		case 3:
			spreadChokeFrac = expect float( weapon.GetWeaponInfoFileKeyField( "projectile_spread_choke_frac_3" ) )
			break

		case 4:
			spreadChokeFrac = expect float( weapon.GetWeaponInfoFileKeyField( "projectile_spread_choke_frac_4" ) )
			break

		default:
			Assert( false, "chargeLevel " + chargeLevel + " doesn't have matching weaponsetting for projectile_spread_choke_frac_" + chargeLevel )
	}
	patternScale *= spreadChokeFrac

	float speedScale = 1.0
	weapon.FireWeapon_Default( attackParams.pos, attackParams.dir, speedScale, patternScale, ignoreSpread )

	if ( weapon.IsChargeWeapon() )
		EnergyChargeWeapon_StopCharge( weapon, chargeWeaponData )

	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
}


int function EnergyChargeWeapon_GetChargeLevel( entity weapon )
{
	if ( !IsValid( weapon ) )
		return 0

	entity owner = weapon.GetWeaponOwner()
	if ( !IsValid( owner ) )
		return 0

	if ( !owner.IsPlayer() )
		return 1

	if ( !weapon.IsReadyToFire() )
		return 0

	if ( !weapon.IsChargeWeapon() )
		return 1

	int chargeLevel = weapon.GetWeaponChargeLevel()
	return chargeLevel
}


bool function EnergyChargeWeapon_OnWeaponChargeLevelIncreased( entity weapon, EnergyChargeWeaponData chargeWeaponData )
{
	#if CLIENT
		if ( InPrediction() && !IsFirstTimePredicted() )
			return true
#endif

#if SERVER
		//printt( "charge level", weapon.GetWeaponChargeLevel() )
	#endif

	int level    = weapon.GetWeaponChargeLevel()
	int maxLevel = weapon.GetWeaponChargeLevelMax()

	string tickSound
	string tickSound_3p

	if ( level == maxLevel )
	{
		tickSound = expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_leveltick_final" ) )
		tickSound_3p = expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_leveltick_final_3p" ) )
	}
	else
	{
		switch ( level )
		{
			case 1:
				tickSound = expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_leveltick_1" ) )
				tickSound_3p = expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_leveltick_1_3p" ) )

				break

			case 2:
				if ( chargeWeaponData.fx_barrel_glow_attach != "" )
					weapon.PlayWeaponEffect( chargeWeaponData.fx_barrel_glow_final_1p, chargeWeaponData.fx_barrel_glow_final_3p, chargeWeaponData.fx_barrel_glow_attach )

				tickSound = expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_leveltick_2" ) )
				tickSound_3p = expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_leveltick_2_3p" ) )

				break

			case 3:
				tickSound = expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_leveltick_3" ) )
				tickSound_3p = expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_leveltick_3_3p" ) )
				break
		}
	}

	if ( tickSound != "" || tickSound_3p != "" )
		weapon.EmitWeaponSound_1p3p( tickSound, tickSound_3p )

	return true
}


void function EnergyChargeWeapon_StopCharge( entity weapon, EnergyChargeWeaponData chargeWeaponData )
{
	if ( chargeWeaponData.fx_barrel_glow_attach != "" )
		weapon.StopWeaponEffect( chargeWeaponData.fx_barrel_glow_final_1p, chargeWeaponData.fx_barrel_glow_final_3p )

	weapon.StopWeaponSound( expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_loop" ) ) )
	weapon.StopWeaponSound( expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_loop_3p" ) ) )

	#if CLIENT
		// NOTE: sounds weird to wind down if we didn't charge for very long, so let at least one charge cycle pass before winding down
		float chargeTime          = weapon.GetWeaponSettingFloat( eWeaponVar.charge_time )
		int chargeLevels          = weapon.GetWeaponSettingInt( eWeaponVar.charge_levels )
		int chargeLevelBase       = weapon.GetWeaponSettingInt( eWeaponVar.charge_level_base )
		float weaponMinChargeTime = chargeTime / (chargeLevels - chargeLevelBase).tofloat()

		if ( Time() - weapon.w.startChargeTime >= weaponMinChargeTime )
		{
			weapon.EmitWeaponSound( expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_end" ) ) )
		}
	#elseif SERVER
		entity owner = weapon.GetWeaponOwner()
		if ( IsValid( owner ) )
		{
			EmitSoundOnEntityExceptToPlayer( weapon, owner, expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_end_3p" ) ) )
		}
	#endif
}


bool function EnergyChargeWeapon_OnWeaponChargeBegin( entity weapon )
{
	weapon.Signal( "EnergyWeapon_ChargeStart" )

	if ( weapon.GetWeaponChargeFraction() == 0 )
	{
		weapon.w.startChargeTime = Time()

		string chargeStart    = expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_start" ) )
		string chargeStart_3p = expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_start_3p" ) )
		weapon.EmitWeaponSound_1p3p( chargeStart, chargeStart_3p )
	}

	string chargeLoop    = expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_loop" ) )
	string chargeLoop_3p = expect string( weapon.GetWeaponInfoFileKeyField( "sound_energy_charge_loop_3p" ) )
	weapon.EmitWeaponSound_1p3p( chargeLoop, chargeLoop_3p )

	return true
}


void function EnergyChargeWeapon_OnWeaponChargeEnd( entity weapon, EnergyChargeWeaponData chargeWeaponData )
{
	//printt( "charge end")
	weapon.Signal( "EnergyWeapon_ChargeReleased" )

	thread EnergyChargeWeapon_StopCharge_Think( weapon, chargeWeaponData )
}


void function EnergyChargeWeapon_StopCharge_Think( entity weapon, EnergyChargeWeaponData chargeWeaponData )
{
	weapon.EndSignal( "OnDestroy" )
	weapon.EndSignal( "EnergyWeapon_ChargeStart" )
	weapon.EndSignal( "EnergyWeapon_ChargeReleased" )

	while ( 1 )
	{
		WaitFrame()

		if ( EnergyChargeWeapon_GetChargeLevel( weapon ) <= 1 )
			break
	}

	EnergyChargeWeapon_StopCharge( weapon, chargeWeaponData )
}


void function FireHitscanShotgunBlast( entity weapon, vector pos, vector dir, int numBlasts, int damageType, float damageScaler = 1.0, float ornull maxAngle = null, float ornull maxDistance = null )
{
	Assert( numBlasts > 0 )
	int numBlastsOriginal = numBlasts

	/*
	Debug ConVars:
		visible_ent_cone_debug_duration_client - Set to non-zero to see debug output
		visible_ent_cone_debug_duration_server - Set to non-zero to see debug output
		visible_ent_cone_debug_draw_radius - Size of trace endpoint debug draw
	*/

	if ( maxDistance == null )
		maxDistance = weapon.GetMaxDamageFarDist()
	expect float( maxDistance )

	if ( maxAngle == null )
		maxAngle = weapon.GetAttackSpreadAngle() * 0.5
	expect float( maxAngle )

	entity owner                  = weapon.GetWeaponOwner()
	array<entity> ignoredEntities = [ owner ]
	int traceMask                 = TRACE_MASK_SHOT
	int visConeFlags              = VIS_CONE_ENTS_TEST_HITBOXES | VIS_CONE_ENTS_CHECK_SOLID_BODY_HIT | VIS_CONE_ENTS_APPOX_CLOSEST_HITBOX | VIS_CONE_RETURN_HIT_VORTEX

	entity antilagPlayer
	if ( owner.IsPlayer() )
	{
		if ( owner.IsPhaseShifted() )
			return

		antilagPlayer = owner
	}

	//JFS - Bug 198500
	Assert( maxAngle > 0.0, "JFS returning out at this instance. We need to investigate when a valid mp_titanweapon_laser_lite weapon returns 0 spread" )
	if ( maxAngle == 0.0 )
		return

	array<VisibleEntityInCone> results = FindVisibleEntitiesInCone( pos, dir, maxDistance, (maxAngle * 1.1), ignoredEntities, traceMask, visConeFlags, antilagPlayer, weapon )
	foreach ( result in results )
	{
		float angleToHitbox = 0.0
		if ( !result.solidBodyHit )
			angleToHitbox = DegreesToTarget( pos, dir, result.approxClosestHitboxPos )

		numBlasts -= HitscanShotgunBlastDamageEntity( weapon, pos, dir, result, angleToHitbox, maxAngle, numBlasts, damageType, damageScaler )
		if ( numBlasts <= 0 )
			break
	}

	//Something in the TakeDamage above is triggering the weapon owner to become invalid.
	owner = weapon.GetWeaponOwner()
	if ( !IsValid( owner ) )
		return

	// maxTracer limit set in /r1dev/src/game/client/c_player.h
	const int MAX_TRACERS = 16
	bool didHitAnything   = ((numBlastsOriginal - numBlasts) != 0)
	bool doTraceBrushOnly = (!didHitAnything)
	if ( numBlasts > 0 )
	{
		WeaponFireBulletSpecialParams fireBulletParams
		fireBulletParams.pos = pos
		fireBulletParams.dir = dir
		fireBulletParams.bulletCount = minint( numBlasts, MAX_TRACERS )
		fireBulletParams.scriptDamageType = damageType
		fireBulletParams.skipAntiLag = false
		fireBulletParams.dontApplySpread = false
		fireBulletParams.doDryFire = true
		fireBulletParams.noImpact = false
		fireBulletParams.noTracer = false
		fireBulletParams.activeShot = false
		fireBulletParams.doTraceBrushOnly = doTraceBrushOnly
		weapon.FireWeaponBullet_Special( fireBulletParams )
	}
}


vector function ApplyVectorSpread( vector vecShotDirection, float spreadDegrees, float bias = 1.0 )
{
	vector angles   = VectorToAngles( vecShotDirection )
	vector vecUp    = AnglesToUp( angles )
	vector vecRight = AnglesToRight( angles )

	float sinDeg = deg_sin( spreadDegrees / 2.0 )

	// get circular gaussian spread
	float x
	float y
	float z

	if ( bias > 1.0 )
		bias = 1.0
	else if ( bias < 0.0 )
		bias = 0.0

	// code gets these values from cvars ai_shot_bias_min & ai_shot_bias_max
	float shotBiasMin = -1.0
	float shotBiasMax = 1.0

	// 1.0 gaussian, 0.0 is flat, -1.0 is inverse gaussian
	float shotBias = ((shotBiasMax - shotBiasMin) * bias) + shotBiasMin
	float flatness = (fabs( shotBias ) * 0.5)

	while ( true )
	{
		x = RandomFloatRange( -1.0, 1.0 ) * flatness + RandomFloatRange( -1.0, 1.0 ) * (1 - flatness)
		y = RandomFloatRange( -1.0, 1.0 ) * flatness + RandomFloatRange( -1.0, 1.0 ) * (1 - flatness)
		if ( shotBias < 0 )
		{
			x = (x >= 0) ? 1.0 - x : -1.0 - x
			y = (y >= 0) ? 1.0 - y : -1.0 - y
		}
		z = x * x + y * y

		if ( z <= 1 )
			break
	}

	vector addX        = vecRight * (x * sinDeg)
	vector addY        = vecUp * (y * sinDeg)
	vector m_vecResult = vecShotDirection + addX + addY

	return m_vecResult
}


float function DegreesToTarget( vector origin, vector forward, vector targetPos )
{
	vector dirToTarget = targetPos - origin
	dirToTarget = Normalize( dirToTarget )
	float dot         = DotProduct( forward, dirToTarget )
	float degToTarget = (acos( dot ) * 180 / PI)

	return degToTarget
}


const SHOTGUN_ANGLE_MIN_FRACTION = 0.1
const SHOTGUN_ANGLE_MAX_FRACTION = 1.0
const SHOTGUN_DAMAGE_SCALE_AT_MIN_ANGLE = 0.8
const SHOTGUN_DAMAGE_SCALE_AT_MAX_ANGLE = 0.1

int function HitscanShotgunBlastDamageEntity( entity weapon, vector barrelPos, vector barrelVec, VisibleEntityInCone result, float angle, float maxAngle, int numPellets, int damageType, float damageScaler )
{
	entity target = result.ent

	//The damage scaler is currently only > 1 for the Titan Shotgun alt fire.
	if ( !target.IsTitan() && damageScaler > 1 )
		damageScaler = max( damageScaler * 0.4, 1.5 )

	entity owner = weapon.GetWeaponOwner()
	// Ent in cone not valid
	if ( !IsValid( target ) || !IsValid( owner ) )
		return 0

	// Fire fake bullet towards entity for visual purposes only
	vector hitLocation = result.visiblePosition
	vector vecToEnt    = (hitLocation - barrelPos)
	vecToEnt.Norm()
	if ( Length( vecToEnt ) == 0 )
		vecToEnt = barrelVec

	// This fires a fake bullet that doesn't do any damage. Currently it triggeres a damage callback with 0 damage which is bad.
	WeaponFireBulletSpecialParams fireBulletParams
	fireBulletParams.pos = barrelPos
	fireBulletParams.dir = vecToEnt
	fireBulletParams.bulletCount = 1
	fireBulletParams.scriptDamageType = damageType
	fireBulletParams.skipAntiLag = true
	fireBulletParams.dontApplySpread = true
	fireBulletParams.doDryFire = true
	fireBulletParams.noImpact = false
	fireBulletParams.noTracer = false
	fireBulletParams.activeShot = false
	fireBulletParams.doTraceBrushOnly = false
	weapon.FireWeaponBullet_Special( fireBulletParams ) // fires perfect bullet with no antilag and no spread

	#if SERVER
		// Determine how much damage to do based on distance
		float distanceToTarget = Distance( barrelPos, hitLocation )

		if ( !result.solidBodyHit ) // non solid hits take 1 blast more
			distanceToTarget += 130

		int extraMods = result.extraMods
		float damageAmount = CalcWeaponDamage( owner, target, weapon, distanceToTarget, extraMods )

		// vortex needs to scale damage based on number of rounds absorbed
		string className = weapon.GetWeaponClassName()
		if ( (className == "mp_titanweapon_vortex_shield") || (className == "mp_titanweapon_vortex_shield_ion") || (className == "mp_titanweapon_heat_shield") )
		{
			damageAmount *= numPellets
			//printt( "scaling vortex hitscan output damage by", numPellets, "pellets for", weaponNearDamageTitan, "damage vs titans" )
		}

		float coneScaler = 1.0
		//if ( angle > 0 )
		//	coneScaler = GraphCapped( angle, (maxAngle * SHOTGUN_ANGLE_MIN_FRACTION), (maxAngle * SHOTGUN_ANGLE_MAX_FRACTION), SHOTGUN_DAMAGE_SCALE_AT_MIN_ANGLE, SHOTGUN_DAMAGE_SCALE_AT_MAX_ANGLE )

		// Calculate the final damage abount to inflict on the target. Also scale it by damageScaler which may have been passed in by script ( used by alt fire mode on titan shotgun to fire multiple shells )
		float finalDamageAmount = damageAmount * coneScaler * damageScaler
		//printt( "angle:", angle, "- coneScaler:", coneScaler, "- damageAmount:", damageAmount, "- damageScaler:", damageScaler, "  = finalDamageAmount:", finalDamageAmount )

		// Calculate impulse force to apply based on damage
		float maxImpulseForce = weapon.GetWeaponSettingFloat( eWeaponVar.impulse_force )
		float impulseForce    = maxImpulseForce * coneScaler * damageScaler
		vector impulseVec     = barrelVec * impulseForce

		int damageSourceID = weapon.GetDamageSourceID()

		//
		float critScale   = weapon.GetWeaponSettingFloat( eWeaponVar.critical_hit_damage_scale )
		float shieldScale = weapon.GetWeaponSettingFloat( eWeaponVar.damage_shield_scale )
		target.TakeDamage( finalDamageAmount, owner, weapon, { origin = hitLocation, force = impulseVec, scriptType = damageType, damageSourceId = damageSourceID, weapon = weapon, hitbox = result.visibleHitbox, criticalHitScale = critScale, shieldDamageScale = shieldScale } )
		if ( IsVortexSphere( target ) )
			VortexSphereDrainHealthForDamage( target, finalDamageAmount )

		//printt( "-----------" )
		//printt( "    distanceToTarget:", distanceToTarget )
		//printt( "    damageAmount:", damageAmount )
		//printt( "    coneScaler:", coneScaler )
		//printt( "    impulseForce:", impulseForce )
		//printt( "    impulseVec:", impulseVec.x + ", " + impulseVec.y + ", " + impulseVec.z )
		//printt( "        finalDamageAmount:", finalDamageAmount )
		//PrintTable( result )
	#endif // #if SERVER

	return 1
}


void function FireProjectileShotgunBlast( entity weapon, WeaponPrimaryAttackParams attackParams, bool playerFired, float outerSpread, float innerSpread, int numProjectiles )
{
	vector vecFwd   = attackParams.dir
	vector vecRight = AnglesToRight( VectorToAngles( attackParams.dir ) )

	array<vector> spreadVecs = GetProjectileShotgunBlastVectors( attackParams.pos, vecFwd, vecRight, outerSpread, innerSpread, numProjectiles )

	for ( int i = 0; i < spreadVecs.len(); i++ )
	{
		vector spreadVec = spreadVecs[i]
		attackParams.dir = spreadVec

		bool ignoreSpread = true  // don't use the normal code spread for this weapon (ie, slightly adjusting outgoing round angle within spread cone)
		bool deferred     = i > (spreadVecs.len() / 2)
		entity bolt       = FireBallisticRoundWithDrop( weapon, attackParams.pos, attackParams.dir, playerFired, ignoreSpread, i, deferred )
	}
}


array<vector> function GetProjectileShotgunBlastVectors( vector pos, vector forward, vector right, float outerSpread, float innerSpead, int numSegments )
{
	#if DEBUG_PROJECTILE_BLAST
		DebugDrawLine( pos, pos + forward * 250, 255, 0, 0, true, 3.0 )
		array<vector> outerVecs
		array<vector> innerVecs
	#endif

	int numRadialSegments = numSegments - 1

	float degPerSegment = 360.0 / numRadialSegments
	array<vector> randVecs

	// PROJECTILES RADIALLY SCATTERED AROUND CENTER
	for ( int i = 0 ; i < numRadialSegments ; i++ )
	{
		vector randVec = VectorRotateAxis( forward, right, RandomFloatRange( innerSpead, outerSpread ) )
		randVec = VectorRotateAxis( randVec, forward, RandomFloatRange( degPerSegment * i, degPerSegment * (i + 1) ) )
		randVec.Norm()
		randVecs.append( randVec )

		#if DEBUG_PROJECTILE_BLAST
			vector innerVec = VectorRotateAxis( forward, right, innerSpead )
			innerVec = VectorRotateAxis( innerVec, forward, degPerSegment * i )
			innerVec.Norm()
			innerVecs.append( innerVec )

			vector outerVec = VectorRotateAxis( forward, right, outerSpread )
			outerVec = VectorRotateAxis( outerVec, forward, degPerSegment * i )
			outerVec.Norm()
			outerVecs.append( outerVec )
		#endif
	}

	// CENTER PROJECTILE
	// For random vec inside center...
	//vector randVec = VectorRotateAxis( forward, right, RandomFloat( innerSpead ) )
	//randVec = VectorRotateAxis( randVec, forward, RandomFloat( 360.0 ) )
	//randVec.Norm()

	// Trying first: always have the center projectile fly straight
	randVecs.append( forward )

	#if DEBUG_PROJECTILE_BLAST
		for ( int i = 0 ; i < numRadialSegments ; i++ )
		{
			vector o1 = pos + outerVecs[i] * 250
			vector o2 = (i == numRadialSegments - 1) ? pos + outerVecs[0] * 250 : pos + outerVecs[i + 1] * 250
			vector i1 = pos + innerVecs[i] * 250
			vector i2 = (i == numRadialSegments - 1) ? pos + innerVecs[0] * 250 : pos + innerVecs[i + 1] * 250

			DebugDrawLine( o1, o2, 255, 255, 0, true, 3.0 )
			DebugDrawLine( i1, i2, 255, 255, 0, true, 3.0 )
			DebugDrawLine( i1, o1, 255, 255, 0, true, 3.0 )
		}

		foreach( vector vec in randVecs )
		{
			DebugDrawSphere( pos + vec * 250, 1.0, 255, 0, 0, true, 3.0, 3 )
		}
	#endif

	return randVecs
}


float function ProjectileShotgun_GetOuterSpread( entity weapon )
{
	return weapon.GetAttackSpreadAngle()
}


float function ProjectileShotgun_GetInnerSpread( entity weapon )
{
	float innerSpread = 0

	var innerSpreadVar = expect float ornull( weapon.GetWeaponInfoFileKeyField( "shotgun_spread_radial_innerexclude" ) )
	if ( innerSpreadVar == null )
		innerSpread = ProjectileShotgun_GetOuterSpread( weapon ) * DEFAULT_SHOTGUN_SPREAD_INNEREXCLUDE_FRAC
	else
		innerSpread = expect float ( weapon.GetWeaponInfoFileKeyField( "shotgun_spread_radial_innerexclude" ) )

	return innerSpread
}


void function FireProjectileBlastPattern( entity weapon, WeaponPrimaryAttackParams attackParams, bool playerFired, array<vector> blastPattern, float patternScale = 1.0, bool ignoreSpread = true )
{
	if ( !IsValid( weapon ) )
		return

	int projectilesPerShot = weapon.GetProjectilesPerShot()
	int patternLength      = blastPattern.len()
	Assert( projectilesPerShot <= patternLength, "Not enough blast pattern points (" + patternLength + ") for " + projectilesPerShot + " projectiles per shot" )

	float defaultPatternScale = expect float( weapon.GetWeaponInfoFileKeyField( "projectile_blast_pattern_default_scale" ) )
	patternScale *= defaultPatternScale
	#if DEBUG_PROJECTILE_BLAST
		printt( "blast pattern scale:", defaultPatternScale )
	#endif

	array<vector> scaledBlastPattern = clone blastPattern

	if ( patternScale != 1.0 )
	{
		for ( int i = 0; i < scaledBlastPattern.len(); i++ )
		{
			scaledBlastPattern[i] *= patternScale
		}
	}

	float patternZeroDistance = expect float( weapon.GetWeaponInfoFileKeyField( "projectile_blast_pattern_zero_distance" ) )

	array<vector> spreadVecs = GetProjectileBlastPatternVectors( attackParams, scaledBlastPattern, patternZeroDistance )

	for ( int i = 0; i < projectilesPerShot; i++ )
	{
		vector spreadVec = spreadVecs[i]
		attackParams.dir = spreadVec

		bool deferred = i > (spreadVecs.len() / 2)
		entity bolt   = FireBallisticRoundWithDrop( weapon, attackParams.pos, attackParams.dir, playerFired, ignoreSpread, i, deferred )
	}
}


array<vector> function GetProjectileBlastPatternVectors( WeaponPrimaryAttackParams attackParams, array<vector> blastPattern, float patternZeroDistance )
{
	vector startPos            = attackParams.pos
	vector forward             = attackParams.dir
	vector right               = AnglesToRight( VectorToAngles( attackParams.dir ) )
	vector up                  = AnglesToUp( VectorToAngles( forward ) )
	vector patternCenterAtZero = startPos + (forward * patternZeroDistance)

	array<vector> patternVecs

	foreach ( offsetVec in blastPattern )
	{
		vector offsetPos = patternCenterAtZero + (right * offsetVec.x)
		offsetPos += (up * offsetVec.y)

		vector vecToTarget = Normalize( offsetPos - startPos )
		patternVecs.append( vecToTarget )

		#if DEBUG_PROJECTILE_BLAST
			DebugDrawLine( startPos, offsetPos, 255, 0, 0, true, 3.0 )
		#endif
	}

	return patternVecs
}


entity function FireBallisticRoundWithDrop( entity weapon, vector pos, vector dir, bool isPlayerFired, bool ignoreSpread, int projectileIndex, bool deferred )
{
	int boltSpeed   = int( weapon.GetWeaponSettingFloat( eWeaponVar.projectile_launch_speed ) )
	int damageFlags = weapon.GetWeaponDamageFlags()

	float boltGravity  = 0.0
	vector originalDir = dir
	if ( weapon.GetWeaponSettingBool( eWeaponVar.bolt_gravity_enabled ) )
	{
		var zeroDistance = weapon.GetWeaponSettingFloat( eWeaponVar.bolt_zero_distance )
		if ( zeroDistance == null )
			zeroDistance = 4096.0

		expect float( zeroDistance )

		boltGravity = weapon.GetWeaponSettingFloat( eWeaponVar.projectile_gravity_scale )
		float worldGravity = GetConVarFloat( "sv_gravity" ) * boltGravity
		float time         = zeroDistance / float( boltSpeed )

		if ( DEBUG_BULLET_DROP <= 1 )
			dir += (GetZVelocityForDistOverTime( zeroDistance, time, worldGravity ) / boltSpeed)
	}

	WeaponFireBoltParams fireBoltParams
	fireBoltParams.pos = pos
	fireBoltParams.dir = dir
	fireBoltParams.speed = 1
	fireBoltParams.scriptTouchDamageType = damageFlags
	fireBoltParams.scriptExplosionDamageType = damageFlags
	fireBoltParams.clientPredicted = isPlayerFired
	fireBoltParams.additionalRandomSeed = 0
	fireBoltParams.dontApplySpread = ignoreSpread
	fireBoltParams.projectileIndex = projectileIndex
	fireBoltParams.deferred = deferred
	entity bolt = weapon.FireWeaponBoltAndReturnEntity( fireBoltParams )

	#if CLIENT
	Chroma_FiredWeapon( weapon )
	#endif

	if ( bolt != null )
	{
		bolt.proj.savedDir = originalDir
		bolt.proj.savedShotTime = Time()

		#if SERVER
			bolt.proj.ownerStringDebug = string( weapon.GetOwner() )
			bolt.proj.ownerLocationDebug = weapon.GetOrigin()
		#endif
	}

	return bolt
}


string function GetDistanceString( float distInches )
{
	float distFeet   = distInches / 12.0
	float distYards  = distInches / 36.0
	float distMeters = distInches / 39.3701

	return format( "%.2fm %.2fy %.2ff %.2fin", distMeters, distYards, distFeet, distInches )
}


vector function GetZVelocityForDistOverTime( float distance, float duration, float gravity )
{
	vector startPoint = <0, 0, 0>
	vector endPoint   = <distance, 0, 0>

	float vox = distance / duration
	float voz = 0.5 * gravity * duration * duration / duration
	return <0, 0, voz>

	//float vox = (endPoint.x - startPoint.x) / duration
	//float voy = (endPoint.y - startPoint.y) / duration
	//float voz = (endPoint.z + 0.5 * gravity * duration * duration - startPoint.z) / duration
	//return <vox ,voy, voz>
}


int function FireGenericBoltWithDrop( entity weapon, WeaponPrimaryAttackParams attackParams, bool isPlayerFired )
{
	#if CLIENT
		if ( !weapon.ShouldPredictProjectiles() )
			return 1
	#endif // #if CLIENT

	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )

	const float PROJ_SPEED_SCALE = 1
	const float PROJ_GRAVITY = 1
	int damageFlags = weapon.GetWeaponDamageFlags()
	WeaponFireBoltParams fireBoltParams
	fireBoltParams.pos = attackParams.pos
	fireBoltParams.dir = attackParams.dir
	fireBoltParams.speed = PROJ_SPEED_SCALE
	fireBoltParams.scriptTouchDamageType = damageFlags
	fireBoltParams.scriptExplosionDamageType = damageFlags
	fireBoltParams.clientPredicted = isPlayerFired
	fireBoltParams.additionalRandomSeed = 0
	entity bolt = weapon.FireWeaponBoltAndReturnEntity( fireBoltParams )
	if ( bolt != null )
	{
		bolt.kv.gravity = PROJ_GRAVITY
		bolt.kv.rendercolor = "0 0 0"
		bolt.kv.renderamt = 0
		bolt.kv.fadedist = 1
	}
	#if CLIENT
	Chroma_FiredWeapon( weapon )
	#endif


	return 1
}


var function OnWeaponPrimaryAttack_GenericBoltWithDrop_Player( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return FireGenericBoltWithDrop( weapon, attackParams, true )
}


var function OnWeaponPrimaryAttack_EPG( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	WeaponFireMissileParams fireMissileParams
	fireMissileParams.pos = attackParams.pos
	fireMissileParams.dir = attackParams.dir
	fireMissileParams.speed = 1
	fireMissileParams.scriptTouchDamageType = damageTypes.largeCaliberExp
	fireMissileParams.scriptExplosionDamageType = damageTypes.largeCaliberExp
	fireMissileParams.doRandomVelocAndThinkVars = false
	fireMissileParams.clientPredicted = false
	entity missile = weapon.FireWeaponMissile( fireMissileParams )
	if ( missile )
	{
		EmitSoundOnEntity( missile, "Weapon_Sidwinder_Projectile" )
		missile.InitMissileForRandomDriftFromWeaponSettings( attackParams.pos, attackParams.dir )
	}

	return missile
}

#if SERVER
var function OnWeaponPrimaryAttack_GenericBoltWithDrop_NPC( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return FireGenericBoltWithDrop( weapon, attackParams, false )
}
#endif // #if SERVER


var function OnWeaponPrimaryAttack_GenericMissile_Player( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )

	vector bulletVec = ApplyVectorSpread( attackParams.dir, weapon.GetAttackSpreadAngle() - 1.0 )
	attackParams.dir = bulletVec

	if ( IsServer() || weapon.ShouldPredictProjectiles() )
	{
		WeaponFireMissileParams fireMissileParams
		fireMissileParams.pos = attackParams.pos
		fireMissileParams.dir = attackParams.dir
		fireMissileParams.speed = 1.0
		fireMissileParams.scriptTouchDamageType = weapon.GetWeaponDamageFlags()
		fireMissileParams.scriptExplosionDamageType = weapon.GetWeaponDamageFlags()
		fireMissileParams.doRandomVelocAndThinkVars = false
		fireMissileParams.clientPredicted = true
		entity missile = weapon.FireWeaponMissile( fireMissileParams )
		if ( missile )
		{
			missile.InitMissileForRandomDriftFromWeaponSettings( attackParams.pos, attackParams.dir )
		}
	}
}

#if SERVER
var function OnWeaponPrimaryAttack_GenericMissile_NPC( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )

	WeaponFireMissileParams fireMissileParams
	fireMissileParams.pos = attackParams.pos
	fireMissileParams.dir = attackParams.dir
	fireMissileParams.speed = 1.0
	fireMissileParams.scriptTouchDamageType = weapon.GetWeaponDamageFlags()
	fireMissileParams.scriptExplosionDamageType = weapon.GetWeaponDamageFlags()
	fireMissileParams.doRandomVelocAndThinkVars = true
	fireMissileParams.clientPredicted = false
	entity missile = weapon.FireWeaponMissile( fireMissileParams )
	if ( missile )
	{
		missile.InitMissileForRandomDriftFromWeaponSettings( attackParams.pos, attackParams.dir )
	}
}
#endif // #if SERVER

bool function PlantStickyEntityOnWorldThatBouncesOffWalls( entity ent, table collisionParams, float bounceDot, vector angleOffset = <0, 0, 0> )
{
	entity hitEnt = expect entity( collisionParams.hitEnt )
	if ( hitEnt && (hitEnt.IsWorld() || hitEnt.HasPusherAncestor()) )
	{
		float dot = expect vector( collisionParams.normal ).Dot( <0, 0, 1> )

		if ( dot < bounceDot )
		{
			#if SERVER
				if ( ent.e.lastBouncePosition == <0, 0, 0> )
				{
					ent.e.lastBouncePosition = ent.GetOrigin()
					return false
				}

				float dist = Distance( ent.e.lastBouncePosition, ent.GetOrigin() )
				ent.e.lastBouncePosition = ent.GetOrigin()

				if ( dist > BOUNCE_STUCK_DISTANCE )
					return false
			#else
				return false
			#endif
		}

		return PlantStickyEntity( ent, collisionParams, angleOffset )
	}

	return false
}


bool function PlantStickyEntityThatBouncesOffWalls( entity ent, table collisionParams, float bounceDot, vector angleOffset = <0, 0, 0> )
{
	// Satchel hit the world
	float dot = expect vector( collisionParams.normal ).Dot( <0, 0, 1> )

	if ( dot < bounceDot )
		return false

	return PlantStickyEntity( ent, collisionParams, angleOffset )
}


bool function PlantStickyEntity( entity ent, table collisionParams, vector angleOffset = <0, 0, 0> )
{
	if ( !EntityShouldStick( ent, expect entity( collisionParams.hitEnt ) ) )
		return false

	// Don't allow parenting to another "sticky" entity to prevent them parenting onto each other
	if ( collisionParams.hitEnt.IsProjectile() )
		return false

	// Update normal from last bouce so when it explodes it can orient the effect properly
	vector plantAngles   = AnglesCompose( VectorToAngles( collisionParams.normal ), angleOffset )
	vector plantPosition = expect vector( collisionParams.pos )

	vector up = AnglesToUp( ent.GetAngles() )
	vector normal = expect vector( collisionParams.normal )
	float dot = DotProduct( up, normal )

	vector fwd = AnglesToForward( ent.GetAngles() )

	if ( !LegalOrigin( plantPosition ) )
		return false

	#if SERVER
		ent.SetAbsOrigin( plantPosition )
		ent.SetAbsAngles( plantAngles )
		ent.proj.isPlanted = true
	#else
		ent.SetOrigin( plantPosition )
		ent.SetAngles( plantAngles )
	#endif
	ent.SetVelocity( <0, 0, 0> )

	//printt( " - Hitbox is:", collisionParams.hitbox, " IsWorld:", collisionParams.hitEnt )
	if ( !collisionParams.hitEnt.IsWorld() )
	{
		if ( !ent.IsMarkedForDeletion() && !collisionParams.hitEnt.IsMarkedForDeletion() )
		{
			if ( collisionParams.hitbox > 0 )
			{
				ent.SetParentWithHitbox( collisionParams.hitEnt, collisionParams.hitbox, true )
			}
			// Hit a func_brush
			else
			{
				//
				ent.SetParent( collisionParams.hitEnt )
			}

			if ( collisionParams.hitEnt.IsPlayer() )
			{
				thread HandleDisappearingParent( ent, expect entity( collisionParams.hitEnt ) )
			}
		}
	}
	else
	{
		ent.SetVelocity( <0, 0, 0> )
		ent.StopPhysics()
	}
#if CLIENT
	if ( ent instanceof C_BaseGrenade )
#else
	if ( ent instanceof CBaseGrenade )
#endif
	ent.MarkAsAttached()

	ent.Signal( "Planted" )

	return true
}


bool function PlantStickyGrenade( entity ent, vector pos, vector normal, entity hitEnt, int hitbox, float depth = 0.0, bool allowBounce = true, bool allowEntityStick = true, bool onlyTitansAllowed = true )
{
	if ( IsFriendlyTeam( ent.GetTeam(), hitEnt.GetTeam() ) )
		return false

	if ( ent.IsMarkedForDeletion() || hitEnt.IsMarkedForDeletion() )
		return false

	vector plantAngles   = VectorToAngles( normal )
	vector plantPosition = pos + normal * -depth

	if ( !allowBounce )
		ent.SetVelocity( <0, 0, 0> )

	if ( !LegalOrigin( plantPosition ) )
		return false

	#if SERVER
		ent.SetAbsOrigin( plantPosition )
		ent.SetAbsAngles( plantAngles )
		ent.proj.isPlanted = true
	#else
		ent.SetOrigin( plantPosition )
		ent.SetAngles( plantAngles )
	#endif

	if ( !hitEnt.IsWorld() && !hitEnt.IsFuncBrush() && ((onlyTitansAllowed && !hitEnt.IsTitan()) || !allowEntityStick) )
		return false

	// SetOrigin might be causing the ent to get markedForDeletion.
	if ( ent.IsMarkedForDeletion() )
		return false

	ent.SetVelocity( <0, 0, 0> )

	if ( hitEnt.IsWorld() )
	{
		ent.SetParent( hitEnt, "", true )
		ent.StopPhysics()
	}
	else
	{
		if ( hitbox > 0 )
			ent.SetParentWithHitbox( hitEnt, hitbox, true )
		else // Hit a func_brush
			ent.SetParent( hitEnt )

		if ( hitEnt.IsPlayer() )
		{
			thread HandleDisappearingParent( ent, hitEnt )
		}
	}

	#if CLIENT
		if ( ent instanceof C_BaseGrenade )
			ent.MarkAsAttached()
	#else
		if ( ent instanceof CBaseGrenade )
			ent.MarkAsAttached()
	#endif

	return true
}


bool function PlantSuperStickyGrenade( entity ent, vector pos, vector normal, entity hitEnt, int hitbox )
{
	if ( IsFriendlyTeam( ent.GetTeam(), hitEnt.GetTeam() ) )
		return false

	vector plantAngles   = VectorToAngles( normal )
	vector plantPosition = pos

	if ( !LegalOrigin( plantPosition ) )
		return false

	#if SERVER
		ent.SetAbsOrigin( plantPosition )
		ent.SetAbsAngles( plantAngles )
		ent.NotSolid() // Without this, shooting the same spot with the softball would cause later shots to fail to stick
		ent.proj.isPlanted = true
	#else
		ent.SetOrigin( plantPosition )
		ent.SetAngles( plantAngles )
	#endif

	if ( !hitEnt.IsWorld() && !hitEnt.IsPlayer() && !hitEnt.IsNPC() )
		return false

	ent.SetVelocity( <0, 0, 0> )

	if ( hitEnt.IsWorld() )
	{
		ent.StopPhysics()
	}
	else
	{
		if ( !ent.IsMarkedForDeletion() && !hitEnt.IsMarkedForDeletion() )
		{
			if ( hitbox > 0 )
				ent.SetParentWithHitbox( hitEnt, hitbox, true )
			else // Hit a func_brush
				ent.SetParent( hitEnt )

			if ( hitEnt.IsPlayer() )
			{
				thread HandleDisappearingParent( ent, hitEnt )
			}
		}
	}

	#if CLIENT
		if ( ent instanceof C_BaseGrenade )
			ent.MarkAsAttached()
	#else
		if ( ent instanceof CBaseGrenade )
			ent.MarkAsAttached()
	#endif

	return true
}

#if SERVER
void function HandleDisappearingParent( entity ent, entity parentEnt )
{
	parentEnt.EndSignal( "OnDeath" )
	ent.EndSignal( "OnDestroy" )

	OnThreadEnd(
		function() : ( ent )
		{
			ent.ClearParent()
		}
	)

	parentEnt.WaitSignal( "StartPhaseShift" )
}
#else
void function HandleDisappearingParent( entity ent, entity parentEnt )
{
	parentEnt.EndSignal( "OnDeath" )
	ent.EndSignal( "OnDestroy" )

	parentEnt.WaitSignal( "StartPhaseShift" )

	ent.ClearParent()
}
#endif

bool function EntityShouldStick( entity stickyEnt, entity hitent )
{
	if ( !EntityCanHaveStickyEnts( stickyEnt, hitent ) )
		return false

	if ( hitent == stickyEnt )
		return false

	if ( hitent == stickyEnt.GetParent() )
		return false

	return true
}


bool function EntityCanHaveStickyEnts( entity stickyEnt, entity ent )
{
	if ( !IsValid( ent ) )
		return false

	if ( ent.GetModelName() == $"" ) // valid case, other projectiles bullets, etc.. sometimes have no model
		return false

	var entClassname = ent.GetNetworkedClassName()
	if ( entClassname == null || !(string( entClassname ) in level.stickyClasses) && !ent.IsNPC() )
		return false

#if CLIENT
	if ( stickyEnt instanceof C_Projectile )
#else
	if ( stickyEnt instanceof CProjectile )
#endif
	{
		string weaponClassName = stickyEnt.ProjectileGetWeaponClassName()
		local stickPlayer      = GetWeaponInfoFileKeyField_Global( weaponClassName, "stick_pilot" )
		local stickTitan       = GetWeaponInfoFileKeyField_Global( weaponClassName, "stick_titan" )
		local stickNPC         = GetWeaponInfoFileKeyField_Global( weaponClassName, "stick_npc" )
		local stickDrone       = GetWeaponInfoFileKeyField_Global( weaponClassName, "stick_drone" )

		if ( ent.IsTitan() && stickTitan == 0 )
			return false
		else if ( ent.IsPlayer() && stickPlayer == 0 )
			return false
		else if ( ent.IsNPC() && stickNPC == 0 )
			return false
		else if ( ent.GetScriptName() == "crypto_camera" && stickDrone == 0 )
			return false
	}

	return true
}

#if SERVER
// shared with the vortex script which also needs to create satchels
void function Satchel_PostFired_Init( entity satchel, entity player )
{
	satchel.proj.onlyAllowSmartPistolDamage = false
	thread SatchelThink( satchel, player )
}

void function SatchelThink( entity satchel, entity player )
{
	player.EndSignal( "OnDestroy" )
	satchel.EndSignal( "OnDestroy" )

	int satchelHealth = 15
	thread TrapExplodeOnDamage( satchel, satchelHealth )

	#if R5DEV
		// temp HACK for FX to use to figure out the size of the particle to play
		if ( Flag( "ShowExplosionRadius" ) )
			thread ShowExplosionRadiusOnExplode( satchel )
	#endif

	player.EndSignal( "OnDeath" )

	OnThreadEnd(
		function() : ( satchel )
		{
			if ( IsValid( satchel ) )
			{
				satchel.Destroy()
			}
		}
	)

	WaitForever()
}

#endif // SERVER

void function ProximityCharge_PostFired_Init( entity proximityMine, entity player )
{
	#if SERVER
		proximityMine.proj.onlyAllowSmartPistolDamage = false
	#endif
}

void function ExplodePlantedGrenadeAfterDelay( entity grenade, float delay )
{
	grenade.EndSignal( "OnDeath" )
	grenade.EndSignal( "OnDestroy" )

	float endTime = Time() + delay

	while ( Time() < endTime )
	{
		EmitSoundOnEntity( grenade, DEFAULT_WARNING_SFX )
		wait 0.1
	}

	grenade.GrenadeExplode( grenade.GetForwardVector() )
}


void function Player_DetonateSatchels( entity player )
{
	player.Signal( "DetonateSatchels" )

	#if SERVER
		Assert( IsServer() )

		array<entity> traps = GetScriptManagedEntArray( player.s.activeTrapArrayId )
		traps.sort( CompareCreationReverse )
		foreach ( index, satchel in traps )
		{
			if ( IsValidSatchel( satchel ) )
			{
				thread PROTO_ExplodeAfterDelay( satchel, index * 0.25 )
			}
		}
	#endif
}

#if SERVER
bool function IsValidSatchel( entity satchel )
{
	if ( satchel.ProjectileGetWeaponClassName() != "mp_weapon_satchel" )
		return false

	if ( satchel.e.isDisabled == true )
		return false

	return true
}

void function PROTO_ExplodeAfterDelay( entity satchel, float delay )
{
	satchel.EndSignal( "OnDestroy" )

	while ( !satchel.proj.isPlanted )
		WaitFrame()

	wait delay

	satchel.GrenadeExplode( satchel.GetForwardVector() )
}
#endif // SERVER

#if R5DEV
void function ShowExplosionRadiusOnExplode( entity ent )
{
	ent.WaitSignal( "OnDestroy" )

	float innerRadius = expect float( ent.GetWeaponInfoFileKeyField( "explosion_inner_radius" ) )
	float outerRadius = expect float( ent.GetWeaponInfoFileKeyField( "explosionradius" ) )

	vector org    = ent.GetOrigin()
	vector angles = <0, 0, 0>
	thread DebugDrawCircle( org, angles, innerRadius, 255, 255, 51, true, 3.0 )
	thread DebugDrawCircle( org, angles, outerRadius, 255, 255, 255, true, 3.0 )
}
#endif // DEV

#if SERVER
// shared between nades, satchels and laser mines
void function TrapExplodeOnDamage( entity trapEnt, int trapEntHealth = 50, float waitMin = 0.0, float waitMax = 0.0 )
{
	Assert( IsValid( trapEnt ), "Given trapEnt entity is not valid, fired from: " + trapEnt.ProjectileGetWeaponClassName() )
	EndSignal( trapEnt, "OnDestroy" )

	trapEnt.SetDamageNotifications( true )
	var results //Really should be a struct
	entity attacker
	entity inflictor

	while ( true )
	{
		if ( !IsValid( trapEnt ) )
			return

		results = WaitSignal( trapEnt, "OnDamaged" )
		attacker = expect entity( results.activator )
		inflictor = expect entity( results.inflictor )

		if ( IsValid( inflictor ) && inflictor == trapEnt )
			continue

		bool shouldDamageTrap = false
		if ( IsValid( attacker ) )
		{
			if ( trapEnt.proj.onlyAllowSmartPistolDamage )
			{
				if ( attacker.IsNPC() || attacker.IsPlayer() )
				{
					foreach ( weapon in attacker.GetAllActiveWeapons() )
					{
						if ( WeaponIsSmartPistolVariant( weapon ) )
						{
							shouldDamageTrap = true
							break
						}
					}
				}
			}
			else
			{
				if ( IsFriendlyTeam( trapEnt.GetTeam(), attacker.GetTeam() ) )
				{
					if ( trapEnt.GetOwner() != attacker )
						shouldDamageTrap = false
					else
						shouldDamageTrap = !ProjectileIgnoresOwnerDamage( trapEnt )
				}
				else
				{
					shouldDamageTrap = true
				}
			}
		}

		if ( shouldDamageTrap )
			trapEntHealth -= int( results.value ) //TODO: This returns float even though it feels like it should return int

		if ( trapEntHealth <= 0 )
			break
	}

	if ( !IsValid( trapEnt ) )
		return

	inflictor = expect entity( results.inflictor ) // waiting on code feature to pass inflictor with OnDamaged signal results table

	if ( waitMin >= 0 && waitMax > 0 )
	{
		float waitTime = RandomFloatRange( waitMin, waitMax )

		if ( waitTime > 0 )
			wait waitTime
	}
	else if ( IsValid( inflictor ) && (inflictor.IsProjectile() || (inflictor instanceof CWeaponX)) )
	{
		int dmgSourceID
		if ( inflictor.IsProjectile() )
			dmgSourceID = inflictor.ProjectileGetDamageSourceID()
		else
			dmgSourceID = inflictor.GetDamageSourceID()

		string inflictorClass = GetObitFromDamageSourceID( dmgSourceID )

		if ( inflictorClass in level.trapChainReactClasses )
		{
			// chain reaction delay
			Wait( RandomFloatRange( 0.2, 0.275 ) )
		}
	}

	if ( !IsValid( trapEnt ) )
		return

	if ( IsValid( attacker ) )
	{
		if ( attacker.IsPlayer() )
		{
			AddPlayerScoreForTrapDestruction( attacker, trapEnt )
			trapEnt.SetOwner( attacker )
		}
		else
		{
			entity lastAttacker = GetLastAttacker( attacker )
			if ( IsValid( lastAttacker ) )
			{
				// for chain explosions, figure out the attacking player that started the chain
				trapEnt.SetOwner( lastAttacker )
			}
		}
	}

	trapEnt.GrenadeExplode( trapEnt.GetForwardVector() )
}

bool function ProjectileIgnoresOwnerDamage( entity projectile )
{
	var ignoreOwnerDamage = projectile.ProjectileGetWeaponInfoFileKeyField( "projectile_ignore_owner_damage" )

	if ( ignoreOwnerDamage == null )
		return false

	return ignoreOwnerDamage == 1
}

bool function WeaponIsSmartPistolVariant( entity weapon )
{
	var isSP = weapon.GetWeaponInfoFileKeyField( "is_smart_pistol" )

	//printt( isSP )

	if ( isSP == null )
		return false

	return (isSP == 1)
}

// NOTE: we should stop using this
void function TrapDestroyOnRoundEnd( entity player, entity trapEnt )
{
	trapEnt.EndSignal( "OnDestroy" )
	waitthread WaitForTrapDestroyTriggers( player, trapEnt )
	if ( IsValid( trapEnt ) )
		trapEnt.Destroy()
}

void function WaitForTrapDestroyTriggers( entity player, entity trapEnt )
{
	player.EndSignal( "CleanupPlayerPermanents" )

	svGlobal.levelEnt.WaitSignal( "ClearedPlayers" )
}

void function AddPlayerScoreForTrapDestruction( entity player, entity trapEnt )
{
	// don't get score for killing your own trap
	if ( "originalOwner" in trapEnt.s && trapEnt.s.originalOwner == player )
		return

	string trapClass = trapEnt.ProjectileGetWeaponClassName()
	if ( trapClass == "" )
		return

	string scoreEvent
	if ( trapClass == "mp_weapon_satchel" )
		scoreEvent = "Destroyed_Satchel"
	else if ( trapClass == "mp_weapon_proximity_mine" )
		scoreEvent = "Destored_Proximity_Mine"

	if ( scoreEvent == "" )
		return

	AddPlayerScore( player, scoreEvent, trapEnt )
}

table function GetBulletPassThroughTargets( entity attacker, WeaponBulletHitParams hitParams )
{
	//HACK requires code later
	table passThroughInfo = {
		endPos = null
		targetArray = []
	}

	TraceResults result
	array<entity> ignoreEnts = [ attacker, hitParams.hitEnt ]

	while ( true )
	{
		vector vec = (hitParams.hitPos - hitParams.startPos) * 1000
		ArrayRemoveInvalid( ignoreEnts )
		result = TraceLine( hitParams.startPos, vec, ignoreEnts, TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_NONE )

		if ( result.hitEnt == svGlobal.worldspawn )
			break

		ignoreEnts.append( result.hitEnt )

		if ( IsValidPassThroughTarget( result.hitEnt, attacker ) )
			passThroughInfo.targetArray.append( result.hitEnt )
	}
	passThroughInfo.endPos = result.endPos

	return passThroughInfo
}
#endif // SERVER

bool function WeaponCanCrit( entity weapon )
{
	// player sometimes has no weapon during titan exit, mantle, etc...
	if ( !weapon )
		return false

	return weapon.GetWeaponSettingBool( eWeaponVar.critical_hit )
}


#if SERVER
bool function IsValidPassThroughTarget( entity target, entity attacker )
{
	//Tied to PassThroughHack function remove when supported by code.
	if ( target == svGlobal.worldspawn )
		return false

	if ( !IsValid( target ) )
		return false

	if ( IsFriendlyTeam( target.GetTeam(), attacker.GetTeam() ) )
		return false

	if ( target.GetTeam() != TEAM_IMC && target.GetTeam() != TEAM_MILITIA )
		return false

	return true
}

void function PassThroughDamage( entity weapon, targetArray )
{
	//Tied to PassThroughHack function remove when supported by code.

	int damageSourceID = weapon.GetDamageSourceID()
	entity owner       = weapon.GetWeaponOwner()

	foreach ( ent in targetArray )
	{
		expect entity( ent )

		float distanceToTarget = Distance( weapon.GetOrigin(), ent.GetOrigin() )
		float damageToDeal     = CalcWeaponDamage( owner, ent, weapon, distanceToTarget, 0 )

		ent.TakeDamage( damageToDeal, owner, weapon.GetWeaponOwner(), { damageSourceId = damageSourceID } )
	}
}
#endif // SERVER

vector function GetVectorFromPositionToCrosshair( entity player, vector startPos )
{
	Assert( IsValid( player ) )

	// See where we're looking
	vector traceStart        = player.EyePosition()
	vector traceEnd          = traceStart + (player.GetViewVector() * 20000)
	array<entity> ignoreEnts = [ player ]
	TraceResults traceResult = TraceLine( traceStart, traceEnd, ignoreEnts, TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_NONE )

	// Return vec from startPos to where we are looking
	vector vec = traceResult.endPos - startPos
	vec = Normalize( vec )
	return vec
}

/*
function InitMissileForRandomDriftBasic( missile, startPos, startDir )
{
	missile.s.RandomFloatRange <- RandomFloat( 1.0 )
	missile.s.startPos <- startPos
	missile.s.startDir <- startDir
}
*/

void function InitMissileForRandomDriftForVortexHigh( entity missile, vector startPos, vector startDir )
{
	missile.InitMissileForRandomDrift( startPos, startDir, 8, 2.5, 0, 0, 100, 100, 0 )
}


void function InitMissileForRandomDriftForVortexLow( entity missile, vector startPos, vector startDir )
{
	missile.InitMissileForRandomDrift( startPos, startDir, 0.3, 0.085, 0, 0, 0.5, 0.5, 0 )
}

/*
function InitMissileForRandomDrift( missile, startPos, startDir )
{
	InitMissileForRandomDriftBasic( missile, startPos, startDir )

	missile.s.drift_windiness <- missile.ProjectileGetWeaponInfoFileKeyField( "projectile_drift_windiness" )
	missile.s.drift_intensity <- missile.ProjectileGetWeaponInfoFileKeyField( "projectile_drift_intensity" )

	missile.s.straight_time_min <- missile.ProjectileGetWeaponInfoFileKeyField( "projectile_straight_time_min" )
	missile.s.straight_time_max <- missile.ProjectileGetWeaponInfoFileKeyField( "projectile_straight_time_max" )

	missile.s.straight_radius_min <- missile.ProjectileGetWeaponInfoFileKeyField( "projectile_straight_radius_min" )
	if ( missile.s.straight_radius_min < 1 )
		missile.s.straight_radius_min = 1
	missile.s.straight_radius_max <- missile.ProjectileGetWeaponInfoFileKeyField( "projectile_straight_radius_max" )
	if ( missile.s.straight_radius_max < 1 )
		missile.s.straight_radius_max = 1
}

function SmoothRandom( x )
{
	return 0.25 * (sin(x) + sin(x * 0.762) + sin(x * 0.363) + sin(x * 0.084))
}

function MissileRandomDrift( timeElapsed, timeStep, windiness, intensity )
{
	// This function makes the missile go in a random direction.
	// Windiness is how frequently the missile changes direction.
	// Intensity is how strongly the missile steers in the direction it has chosen.

	local sampleTime = timeElapsed - timeStep * 0.5

	intensity *= timeStep

	local offset = self.s.RandomFloatRange * 1000

	local offsetx = intensity * SmoothRandom( offset     +       sampleTime * windiness )
	local offsety = intensity * SmoothRandom( offset * 2 + 100 + sampleTime * windiness )

	local right = self.GetRightVector()
	local up = self.GetUpVector()

	//DebugDrawLine( self.GetOrigin(), self.GetOrigin() + right * 100, 255,255,255, true, 0 )
	//DebugDrawLine( self.GetOrigin(), self.GetOrigin() + up * 100, 255,128,255, true, 0 )

	local dir = self.GetVelocity()
	float speed = Length( dir )
	dir = Normalize( dir )
	dir += right * offsetx
	dir += up * offsety
	dir = Normalize( dir )
	dir *= speed

	return dir
}

// designed to be called every frame (GetProjectileVelocity callback) on projectiles that are flying through the air
function ApplyMissileControlledDrift( missile, timeElapsed, timeStep )
{
	// If we have a target, don't do anything fancy; just let code do the homing behavior
	if ( missile.GetMissileTarget() )
		return missile.GetVelocity()

	local s = missile.s
	return MissileControlledDrift( timeElapsed, timeStep, s.drift_windiness, s.drift_intensity, s.straight_time_min, s.straight_time_max, s.straight_radius_min, s.straight_radius_max )
}

function MissileControlledDrift( timeElapsed, timeStep, windiness, intensity, pathTimeMin, pathTimeMax, pathRadiusMin, pathRadiusMax )
{
	// Start with random drift.
	local vel = MissileRandomDrift( timeElapsed, timeStep, windiness, intensity )

	// Straighten our velocity back along our original path if we're below pathTimeMax.
	// Path time is how long it tries to stay on a straight path.
	// Path radius is how far it can get from its straight path.
	if ( timeElapsed < pathTimeMax )
	{
		local org = self.GetOrigin()
		local alongPathLen = self.s.startDir.Dot( org - self.s.startPos )
		local alongPathPos = self.s.startPos + self.s.startDir * alongPathLen
		local offPathOffset = org - alongPathPos
		float pathDist = Length( offPathOffset )

		float speed = Length( vel )

		local lerp = 1
		if ( timeElapsed > pathTimeMin )
			lerp = 1.0 - (timeElapsed - pathTimeMin) / (pathTimeMax - pathTimeMin)

		local pathRadius = pathRadiusMax + (pathRadiusMin - pathRadiusMax) * lerp

		// This circle shows the radius the missile is allowed to be in.
		//if ( IsServer() )
		//	DebugDrawCircle( alongPathPos, VectorToAngles( AnglesToUp( VectorToAngles( self.s.startDir ) ) ), pathRadius, 255,255,255, true, 0.0 )

		local backToPathVel = offPathOffset * -1
		// Cap backToPathVel at speed
		if ( pathDist > pathRadius )
			backToPathVel *= speed / pathDist
		else
			backToPathVel *= speed / pathRadius

		if ( pathDist < pathRadius )
		{
			backToPathVel += self.s.startDir * (speed * (1.0 - pathDist / pathRadius))
		}

		//DebugDrawLine( org, org + vel * 0.1, 255,255,255, true, 0 )
		//DebugDrawLine( org, org + backToPathVel * intensity * lerp * 0.1, 128,255,128, true, 0 )

		vel += backToPathVel * (intensity * timeStep)
		vel = Normalize( vel )
		vel *= speed
	}

	return vel
}
*/

#if SERVER
void function StartClusterExplosions( entity projectile, entity owner, PopcornInfo popcornInfo, string customFxTable = "" )
{
	Assert( IsValid( owner ) )
	owner.EndSignal( "OnDestroy" )

	string weaponName = popcornInfo.weaponName
	float innerRadius
	float outerRadius
	int explosionDamage
	int explosionDamageHeavyArmor

	innerRadius = projectile.GetProjectileWeaponSettingFloat( eWeaponVar.explosion_inner_radius )
	outerRadius = projectile.GetProjectileWeaponSettingFloat( eWeaponVar.explosionradius )
	if ( owner.IsPlayer() )
	{
		explosionDamage = projectile.GetProjectileWeaponSettingInt( eWeaponVar.explosion_damage )
		explosionDamageHeavyArmor = projectile.GetProjectileWeaponSettingInt( eWeaponVar.explosion_damage_heavy_armor )
	}
	else
	{
		explosionDamage = projectile.GetProjectileWeaponSettingInt( eWeaponVar.npc_explosion_damage )
		explosionDamageHeavyArmor = projectile.GetProjectileWeaponSettingInt( eWeaponVar.npc_explosion_damage_heavy_armor )
	}

	local explosionDelay = projectile.ProjectileGetWeaponInfoFileKeyField( "projectile_explosion_delay" )

	if ( owner.IsPlayer() )
		owner.EndSignal( "OnDestroy" )

	vector origin = projectile.GetOrigin()

	vector rotateFX        = <90, 0, 0>
	entity placementHelper = CreateScriptMover()
	placementHelper.SetOrigin( origin )
	placementHelper.SetAngles( VectorToAngles( popcornInfo.normal ) )
	SetTeam( placementHelper, owner.GetTeam() )

	array<entity> players = GetPlayerArray()
	foreach ( player in players )
	{
		Remote_CallFunction_NonReplay( player, "SCB_AddGrenadeIndicatorForEntity", owner.GetTeam(), owner.GetEncodedEHandle(), placementHelper.GetEncodedEHandle(), outerRadius )
	}

	int particleSystemIndex = GetParticleSystemIndex( CLUSTER_BASE_FX )
	int attachId            = placementHelper.LookupAttachment( "REF" )
	entity fx

	if ( popcornInfo.hasBase )
	{
		fx = StartParticleEffectOnEntity_ReturnEntity( placementHelper, particleSystemIndex, FX_PATTACH_POINT_FOLLOW, attachId )
		EmitSoundOnEntity( placementHelper, "Explo_ThermiteGrenade_Impact_3P" ) // TODO: wants a custom sound
	}

	OnThreadEnd(
		function() : ( fx, placementHelper )
		{
			if ( IsValid( fx ) )
				EffectStop( fx )
			placementHelper.Destroy()
		}
	)

	if ( explosionDelay )
		wait explosionDelay

	waitthread ClusterRocketBursts( origin, explosionDamage, explosionDamageHeavyArmor, innerRadius, outerRadius, owner, popcornInfo, customFxTable )

	if ( IsValid( projectile ) )
		projectile.Destroy()
}

//------------------------------------------------------------
// ClusterRocketBurst() - does a "popcorn airburst" explosion effect over time around the origin. Total distance is based on popRangeBase
// - returns the entity in case you want to parent it
//------------------------------------------------------------
void function ClusterRocketBursts( vector origin, int damage, int damageHeavyArmor, float innerRadius, float outerRadius, entity owner, PopcornInfo popcornInfo, string customFxTable = "" )
{
	owner.EndSignal( "OnDestroy" )

	// this ent remembers the weapon mods
	entity clusterExplosionEnt = CreateEntity( "info_target" )
	DispatchSpawn( clusterExplosionEnt )

	if ( popcornInfo.weaponMods.len() > 0 )
		clusterExplosionEnt.s.weaponMods <- popcornInfo.weaponMods

	clusterExplosionEnt.SetOwner( owner )
	clusterExplosionEnt.SetOrigin( origin )

	AI_CreateDangerousArea_Static( clusterExplosionEnt, null, outerRadius, TEAM_INVALID, true, true, origin )

	OnThreadEnd(
		function() : ( clusterExplosionEnt )
		{
			clusterExplosionEnt.Destroy()
		}
	)

	// No Damage - Only Force
	// Push players
	// Test LOS before pushing
	int flags = 11
	// create a blast that knocks pilots out of the way
	CreatePhysExplosion( origin, outerRadius, PHYS_EXPLOSION_LARGE, flags )

	int count = popcornInfo.groupSize
	for ( int index = 0; index < count; index++ )
	{
		thread ClusterRocketBurst( clusterExplosionEnt, origin, damage, damageHeavyArmor, innerRadius, outerRadius, owner, popcornInfo, customFxTable )
		WaitFrame()
	}

	wait CLUSTER_ROCKET_DURATION
}

void function ClusterRocketBurst( entity clusterExplosionEnt, vector origin, damage, damageHeavyArmor, innerRadius, outerRadius, entity owner, PopcornInfo popcornInfo, string customFxTable = "" )
{
	clusterExplosionEnt.EndSignal( "OnDestroy" )
	Assert( IsValid( owner ), "ClusterRocketBurst had invalid owner" )

	// first explosion always happens where you fired
	//int eDamageSource = popcornInfo.damageSourceId
	int numBursts           = popcornInfo.count
	float popRangeBase      = popcornInfo.range
	float popDelayBase      = popcornInfo.delay
	float popDelayRandRange = popcornInfo.offset
	float duration          = popcornInfo.duration
	int groupSize           = popcornInfo.groupSize

	int counter   = 0
	vector randVec
	float randRangeMod
	float popRange
	vector popVec
	vector popOri = origin
	float popDelay
	float colTrace

	float burstDelay = duration / (numBursts / groupSize)

	vector clusterBurstOrigin = origin + (popcornInfo.normal * 8.0)
	entity clusterBurstEnt    = CreateClusterBurst( clusterBurstOrigin )

	OnThreadEnd(
		function() : ( clusterBurstEnt )
		{
			if ( IsValid( clusterBurstEnt ) )
			{
				foreach ( fx in clusterBurstEnt.e.fxArray )
				{
					if ( IsValid( fx ) )
						fx.Destroy()
				}
				clusterBurstEnt.Destroy()
			}
		}
	)

	while ( IsValid( clusterBurstEnt ) && counter <= numBursts / popcornInfo.groupSize )
	{
		randVec = RandomVecInDome( popcornInfo.normal )
		randRangeMod = RandomFloat( 1.0 )
		popRange = popRangeBase * randRangeMod
		popVec = randVec * popRange
		popOri = origin + popVec
		popDelay = popDelayBase + RandomFloatRange( -popDelayRandRange, popDelayRandRange )

		colTrace = TraceLineSimple( origin, popOri, null )
		if ( colTrace < 1 )
		{
			popVec = popVec * colTrace
			popOri = origin + popVec
		}

		clusterBurstEnt.SetOrigin( clusterBurstOrigin )

		vector velocity = GetVelocityForDestOverTime( clusterBurstEnt.GetOrigin(), popOri, burstDelay - popDelay )
		clusterBurstEnt.SetVelocity( velocity )

		clusterBurstOrigin = popOri

		counter++

		wait burstDelay - popDelay

		Explosion(
			clusterBurstOrigin,
			owner,
			clusterExplosionEnt,
			damage,
			damageHeavyArmor,
			innerRadius,
			outerRadius,
			SF_ENVEXPLOSION_NOSOUND_FOR_ALLIES,
			clusterBurstOrigin,
			damage,
			damageTypes.explosive,
			popcornInfo.damageSourceId,
			customFxTable )
	}
}


entity function CreateClusterBurst( vector origin )
{
	entity prop_physics = CreateEntity( "prop_physics" )
	prop_physics.SetValueForModelKey( $"mdl/weapons/bullets/projectile_rocket.rmdl" )
	prop_physics.kv.spawnflags = 4 // 4 = SF_PHYSPROP_DEBRIS
	prop_physics.kv.fadedist = 2000
	prop_physics.kv.renderamt = 255
	prop_physics.kv.rendercolor = "255 255 255"
	prop_physics.kv.CollisionGroup = TRACE_COLLISION_GROUP_DEBRIS

	prop_physics.kv.minhealthdmg = 9999
	prop_physics.kv.nodamageforces = 1
	prop_physics.kv.inertiaScale = 1.0

	prop_physics.SetOrigin( origin )
	DispatchSpawn( prop_physics )
	prop_physics.SetModel( $"mdl/weapons/grenades/m20_f_grenade.rmdl" )

	entity fx = PlayFXOnEntity( $"P_wpn_dumbfire_burst_trail", prop_physics )
	prop_physics.e.fxArray.append( fx )

	return prop_physics
}
#endif // SERVER

vector function GetVelocityForDestOverTime( vector startPoint, vector endPoint, float duration )
{
	const GRAVITY = 750

	float vox = (endPoint.x - startPoint.x) / duration
	float voy = (endPoint.y - startPoint.y) / duration
	float voz = (endPoint.z + 0.5 * GRAVITY * duration * duration - startPoint.z) / duration

	return <vox, voy, voz>
}


vector function GetPlayerVelocityForDestOverTime( vector startPoint, vector endPoint, float duration )
{
	// Same as above but accounts for player gravity setting not being 1.0

	float gravityScale = GetGlobalSettingsFloat( DEFAULT_PILOT_SETTINGS, "gravityScale" )
	float GRAVITY      = 750 * gravityScale // adjusted for new gravity scale

	float vox = (endPoint.x - startPoint.x) / duration
	float voy = (endPoint.y - startPoint.y) / duration
	float voz = (endPoint.z + 0.5 * GRAVITY * duration * duration - startPoint.z) / duration

	return <vox, voy, voz>
}


bool function HasLockedTarget( entity weapon )
{
	if ( weapon.SmartAmmo_IsEnabled() )
	{
		array< SmartAmmoTarget > targets = weapon.SmartAmmo_GetTargets()
		if ( targets.len() > 0 )
		{
			foreach ( target in targets )
			{
				if ( target.fraction == 1 )
					return true
			}
		}
	}
	return false
}


bool function CanWeaponShootWhileRunning( entity weapon )
{
	if ( "primary_fire_does_not_block_sprint" in weapon.s )
		return expect bool( weapon.s.primary_fire_does_not_block_sprint )

	if ( weapon.GetWeaponSettingBool( eWeaponVar.primary_fire_does_not_block_sprint ) )
	{
		weapon.s.primary_fire_does_not_block_sprint <- true
		return true
	}

	weapon.s.primary_fire_does_not_block_sprint <- false
	return false
}

#if CLIENT

bool function IsOwnerViewPlayerFullyADSed( entity weapon )
{
	entity owner = weapon.GetOwner()
	if ( !IsValid( owner ) )
		return false

	if ( !owner.IsPlayer() )
		return false

	if ( owner != GetLocalViewPlayer() )
		return false

	float zoomFrac = owner.GetZoomFrac()
	if ( zoomFrac < 1.0 )
		return false

	return true
}
#endif // CLIENT

array<entity> function FireExpandContractMissiles( entity weapon, WeaponPrimaryAttackParams attackParams, vector attackPos, vector attackDir, int damageType, int explosionDamageType, bool shouldPredict, int rocketsPerShot, missileSpeed, launchOutAng, launchOutTime, launchInAng, launchInTime, launchInLerpTime, launchStraightLerpTime, applyRandSpread, int burstFireCountOverride = -1, debugDrawPath = false )
{
	array<table> missileVecs = GetExpandContractRocketTrajectories( weapon, attackParams.burstIndex, attackPos, attackDir, rocketsPerShot, launchOutAng, launchInAng, burstFireCountOverride )
	entity owner             = weapon.GetWeaponOwner()
	array<entity> firedMissiles

	vector missileEndPos = owner.EyePosition() + (attackDir * 5000)

	for ( int i = 0; i < rocketsPerShot; i++ )
	{
		WeaponFireMissileParams fireMissileParams
		fireMissileParams.pos = attackPos
		fireMissileParams.dir = attackDir
		fireMissileParams.speed = expect float( missileSpeed )
		fireMissileParams.scriptTouchDamageType = damageType
		fireMissileParams.scriptExplosionDamageType = explosionDamageType
		fireMissileParams.doRandomVelocAndThinkVars = false
		fireMissileParams.clientPredicted = shouldPredict
		entity missile = weapon.FireWeaponMissile( fireMissileParams )

		if ( missile )
		{
			/*
			missile.s.flightData <- {
								launchOutVec = missileVecs[i].outward,
								launchOutTime = launchOutTime,
								launchInLerpTime = launchInLerpTime,
								launchInVec = missileVecs[i].inward,
								launchInTime = launchInTime,
								launchStraightLerpTime = launchStraightLerpTime,
								endPos = missileEndPos,
								applyRandSpread = applyRandSpread
							}
			*/

			missile.InitMissileExpandContract( missileVecs[i].outward, missileVecs[i].inward, launchOutTime, launchInLerpTime, launchInTime, launchStraightLerpTime, missileEndPos, applyRandSpread )

			if ( IsServer() && debugDrawPath )
				thread DebugDrawMissilePath( missile )

			//InitMissileForRandomDrift( missile, attackPos, attackDir )
			missile.InitMissileForRandomDriftFromWeaponSettings( attackPos, attackDir )

			firedMissiles.append( missile )
		}
	}

	return firedMissiles
}


array<entity> function FireExpandContractMissiles_S2S( entity weapon, WeaponPrimaryAttackParams attackParams, vector attackPos, vector attackDir, bool shouldPredict, int rocketsPerShot, missileSpeed, launchOutAng, launchOutTime, launchInAng, launchInTime, launchInLerpTime, launchStraightLerpTime, applyRandSpread, int burstFireCountOverride = -1, debugDrawPath = false )
{
	array<table> missileVecs = GetExpandContractRocketTrajectories( weapon, attackParams.burstIndex, attackPos, attackDir, rocketsPerShot, launchOutAng, launchInAng, burstFireCountOverride )
	entity owner             = weapon.GetWeaponOwner()
	array<entity> firedMissiles

	vector missileEndPos = attackPos + (attackDir * 5000)

	for ( int i = 0; i < rocketsPerShot; i++ )
	{
		WeaponFireMissileParams fireMissileParams
		fireMissileParams.pos = attackPos
		fireMissileParams.dir = attackDir
		fireMissileParams.speed = expect float( missileSpeed )
		fireMissileParams.scriptTouchDamageType = DF_GIB | DF_IMPACT
		fireMissileParams.scriptExplosionDamageType = damageTypes.explosive
		fireMissileParams.doRandomVelocAndThinkVars = false
		fireMissileParams.clientPredicted = shouldPredict
		entity missile = weapon.FireWeaponMissile( fireMissileParams )
		missile.SetOrigin( attackPos )//HACK why do I have to do this?
		if ( missile )
		{
			/*
			missile.s.flightData <- {
								launchOutVec = missileVecs[i].outward,
								launchOutTime = launchOutTime,
								launchInLerpTime = launchInLerpTime,
								launchInVec = missileVecs[i].inward,
								launchInTime = launchInTime,
								launchStraightLerpTime = launchStraightLerpTime,
								endPos = missileEndPos,
								applyRandSpread = applyRandSpread
							}
			*/

			missile.InitMissileExpandContract( missileVecs[i].outward, missileVecs[i].inward, launchOutTime, launchInLerpTime, launchInTime, launchStraightLerpTime, missileEndPos, applyRandSpread )

			if ( IsServer() && debugDrawPath )
				thread DebugDrawMissilePath( missile )

			//InitMissileForRandomDrift( missile, attackPos, attackDir )
			missile.InitMissileForRandomDriftFromWeaponSettings( attackPos, attackDir )

			firedMissiles.append( missile )
		}
	}

	return firedMissiles
}


array<table> function GetExpandContractRocketTrajectories( entity weapon, int burstIndex, vector attackPos, vector attackDir, int rocketsPerShot, launchOutAng, launchInAng, int burstFireCount = -1 )
{
	bool DEBUG_DRAW_MATH = false

	if ( burstFireCount == -1 )
		burstFireCount = weapon.GetWeaponBurstFireCount()

	float additionalRotation = ((360.0 / rocketsPerShot) / burstFireCount) * burstIndex
	//printt( "burstIndex:", burstIndex )
	//printt( "rocketsPerShot:", rocketsPerShot )
	//printt( "burstFireCount:", burstFireCount )

	vector ang     = VectorToAngles( attackDir )
	vector forward = AnglesToForward( ang )
	vector right   = AnglesToRight( ang )
	vector up      = AnglesToUp( ang )

	if ( DEBUG_DRAW_MATH )
		DebugDrawLine( attackPos, attackPos + (forward * 1000), 255, 0, 0, true, 30.0 )

	// Create points on circle
	float offsetAng = 360.0 / rocketsPerShot
	for ( int i = 0; i < rocketsPerShot; i++ )
	{
		float a    = offsetAng * i + additionalRotation
		vector vec = <0, 0, 0>
		vec += up * deg_sin( a )
		vec += right * deg_cos( a )

		if ( DEBUG_DRAW_MATH )
			DebugDrawLine( attackPos, attackPos + (vec * 50), 10, 10, 10, true, 30.0 )
	}

	// Create missile points
	vector x  = right * deg_sin( launchOutAng )
	vector y  = up * deg_sin( launchOutAng )
	vector z  = forward * deg_cos( launchOutAng )
	vector rx = right * deg_sin( launchInAng )
	vector ry = up * deg_sin( launchInAng )
	vector rz = forward * deg_cos( launchInAng )
	array<table> missilePoints
	for ( int i = 0; i < rocketsPerShot; i++ )
	{
		table points

		// Outward vec
		float a       = offsetAng * i + additionalRotation
		float s       = deg_sin( a )
		float c       = deg_cos( a )
		vector vecOut = z + x * c + y * s
		vecOut = Normalize( vecOut )
		points.outward <- vecOut

		// Inward vec
		vector vecIn = rz + rx * c + ry * s
		points.inward <- vecIn

		// Add to array
		missilePoints.append( points )

		if ( DEBUG_DRAW_MATH )
		{
			DebugDrawLine( attackPos, attackPos + (vecOut * 50), 255, 255, 0, true, 30.0 )
			DebugDrawLine( attackPos + vecOut * 50, attackPos + vecOut * 50 + (vecIn * 50), 255, 0, 255, true, 30.0 )
		}
	}

	return missilePoints
}


void function DebugDrawMissilePath( entity missile )
{
	EndSignal( missile, "OnDestroy" )
	vector lastPos = missile.GetOrigin()
	while ( true )
	{
		WaitFrame()
		if ( !IsValid( missile ) )
			return
		DebugDrawLine( lastPos, missile.GetOrigin(), 0, 255, 0, true, 20.0 )
		lastPos = missile.GetOrigin()
	}
}


bool function IsPilotShotgunWeapon( string weaponName )
{
	if ( IsWeaponKeyFieldDefined( weaponName, "weaponSubClass" ) && GetWeaponInfoFileKeyField_GlobalString( weaponName, "weaponSubClass" ) == "shotgun" )
		return true

	return false
}


array<string> function GetWeaponBurnMods( string weaponClassName )
{
	array<string> burnMods = []
	array<string> mods     = GetWeaponMods_Global( weaponClassName )
	string prefix          = "burn_mod"
	foreach ( mod in mods )
	{
		if ( mod.find( prefix ) == 0 )
			burnMods.append( mod )
	}

	return burnMods
}


int function TEMP_GetDamageFlagsFromProjectile( entity projectile )
{
	var damageFlagsString = projectile.ProjectileGetWeaponInfoFileKeyField( "damage_flags" )
	if ( damageFlagsString == null )
		return 0
	expect string( damageFlagsString )

	return TEMP_GetDamageFlagsFromString( damageFlagsString )
}


int function TEMP_GetDamageFlagsFromString( string damageFlagsString )
{
	int damageFlags = 0

	array<string> damageFlagTokens = split( damageFlagsString, "|" )
	foreach ( token in damageFlagTokens )
	{
		damageFlags = damageFlags | getconsttable()[strip( token )]
	}

	return damageFlags
}

#if SERVER
void function PROTO_InitTrackedProjectile( entity projectile )
{
	// HACK: accessing ProjectileGetWeaponInfoFileKeyField or ProjectileGetWeaponClassName during CodeCallback_OnSpawned causes a code assert
	projectile.EndSignal( "OnDestroy" )
	WaitFrame()

	entity owner = projectile.GetOwner()

	if ( !IsValid( owner ) || !owner.IsPlayer() )
		return

	int maxDeployed = projectile.GetProjectileWeaponSettingInt( eWeaponVar.projectile_max_deployed )
	if ( maxDeployed != 0 )
	{
		AddToTrackedEnts( owner, projectile )

		array<entity> traps = GetScriptManagedEntArray( owner.s.activeTrapArrayId )
		array<entity> sameTypeTrapEnts
		foreach ( ent in traps )
		{
			if ( ent.ProjectileGetWeaponClassName() != projectile.ProjectileGetWeaponClassName() )
				continue

			sameTypeTrapEnts.append( ent )
		}

		int numToDestroy = sameTypeTrapEnts.len() - maxDeployed
		if ( numToDestroy > 0 )
		{
			sameTypeTrapEnts.sort( CompareCreation )
			foreach ( ent in sameTypeTrapEnts )
			{
				ent.Destroy()
				numToDestroy--

				if ( !numToDestroy )
					break
			}
		}
	}
}

void function AddToTrackedEnts( entity player, entity ent )
{
	AddToScriptManagedEntArray( player.s.activeTrapArrayId, ent )
}

void function PROTO_CleanupTrackedProjectiles( entity player )
{
	array<entity> traps = GetScriptManagedEntArray( player.s.activeTrapArrayId )
	foreach ( ent in traps )
	{
		ent.Destroy()
	}
}

int function CompareCreation( entity a, entity b )
{
	if ( a.GetProjectileCreationTime() > b.GetProjectileCreationTime() )
		return 1

	return -1
}

int function CompareCreationReverse( entity a, entity b )
{
	if ( a.GetProjectileCreationTime() > b.GetProjectileCreationTime() )
		return 1

	return -1
}

void function PROTO_TrackedProjectile_OnPlayerRespawned( entity player )
{
	thread PROTO_TrackedProjectile_OnPlayerRespawned_Internal( player )
}

void function PROTO_TrackedProjectile_OnPlayerRespawned_Internal( entity player )
{
	player.EndSignal( "OnDeath" )

	if ( player.e.inGracePeriod )
		player.WaitSignal( "GracePeriodDone" )

	entity ordnance = player.GetOffhandWeapon( OFFHAND_ORDNANCE )

	array<entity> traps = GetScriptManagedEntArray( player.s.activeTrapArrayId )
	foreach ( ent in traps )
	{
		if ( ordnance && ent.ProjectileGetWeaponClassName() == ordnance.GetWeaponClassName() )
			continue

		ent.Destroy()
	}
}

void function PROTO_PlayTrapLightEffect( entity ent, string tag, int team )
{
	asset ownerFx = ent.ProjectileGetWeaponInfoFileKeyFieldAsset( "trap_warning_owner_fx" )
	if ( ownerFx != $"" )
	{
		entity ownerFxEnt = CreateServerEffect_Owner( ownerFx, ent.GetOwner() )
		SetServerEffectControlPoint( ownerFxEnt, 0, FRIENDLY_COLOR )
		StartServerEffectOnEntity( ownerFxEnt, ent, tag )
	}

	asset friendlyFx = ent.ProjectileGetWeaponInfoFileKeyFieldAsset( "trap_warning_friendly_fx" )
	if ( friendlyFx != $"" )
	{
		entity friendlyFxEnt = CreateServerEffect_Friendly( friendlyFx, team )
		SetServerEffectControlPoint( friendlyFxEnt, 0, FRIENDLY_COLOR_FX )
		StartServerEffectOnEntity( friendlyFxEnt, ent, tag )
	}

	asset enemyFx = ent.ProjectileGetWeaponInfoFileKeyFieldAsset( "trap_warning_enemy_fx" )
	if ( enemyFx != $"" )
	{
		entity enemyFxEnt = CreateServerEffect_Enemy( enemyFx, team )
		SetServerEffectControlPoint( enemyFxEnt, 0, ENEMY_COLOR_FX )
		StartServerEffectOnEntity( enemyFxEnt, ent, tag )
	}
}

string function GetCooldownBeepPrefix( entity weapon )
{
	var reloadBeepPrefix = weapon.GetWeaponInfoFileKeyField( "cooldown_sound_prefix" )
	if ( reloadBeepPrefix == null )
		return ""

	return expect string( reloadBeepPrefix )
}

void function PROTO_DelayCooldown( entity weapon )
{
	weapon.s.nextCooldownTime = Time() + weapon.s.cooldownDelay
}

string function GetBeepSuffixForAmmo( int currentAmmo, int maxAmmo )
{
	float frac = float( currentAmmo ) / float( maxAmmo )

	if ( frac >= 1.0 )
		return "_full"

	if ( frac >= 0.25 )
		return ""

	return "_low"
}

#endif //SERVER

bool function PROTO_CanPlayerDeployWeapon( entity player )
{
	if ( player.IsPhaseShifted() )
		return false

	if ( player.ContextAction_IsActive() == true )
	{
		if ( player.IsZiplining() )
			return true
		else
			return false
	}

	return true
}

#if SERVER
void function PROTO_FlakCannonMissiles( entity projectile, float speed )
{
	projectile.EndSignal( "OnDestroy" )

	float radius      = projectile.GetProjectileWeaponSettingFloat( eWeaponVar.explosionradius )
	vector velocity   = projectile.GetVelocity()
	vector currentPos = projectile.GetOrigin()
	int team          = projectile.GetTeam()

	float waitTime            = 0.1
	float distanceInterval    = speed * waitTime
	int forwardDistanceChecks = int( ceil( distanceInterval / radius ) )
	bool forceExplosion       = false
	while ( forceExplosion == false )
	{
		currentPos = projectile.GetOrigin()
		for ( int i = 0; i < forwardDistanceChecks; i++ )
		{
			float frac = float( i ) / float( forwardDistanceChecks )
			if ( PROTO_FlakCannon_HasNearbyEnemies( currentPos + velocity * waitTime * frac, team, radius ) )
			{
				if ( i == 0 )
				{
					forceExplosion = true
					break
				}
				else
				{
					projectile.SetVelocity( velocity * (frac - 0.05) )
					break
				}
			}
		}

		if ( forceExplosion == false )
			wait waitTime
	}

	projectile.MissileExplode()
}

bool function PROTO_FlakCannon_HasNearbyEnemies( vector origin, int team, float radius )
{
	float worldSpaceCenterBuffer = 200

	array<entity> guys = GetPlayerArrayEx( "any", TEAM_ANY, team, origin, radius + worldSpaceCenterBuffer )
	foreach ( guy in guys )
	{
		if ( IsAlive( guy ) && Distance( origin, guy.GetWorldSpaceCenter() ) < radius )
			return true
	}

	array<entity> ai = GetNPCArrayEx( "any", TEAM_ANY, team, origin, radius + worldSpaceCenterBuffer )
	foreach ( guy in ai )
	{
		if ( IsAlive( guy ) && Distance( origin, guy.GetWorldSpaceCenter() ) < radius )
			return true
	}

	return false
}
#endif // #if SERVER

void function GiveEMPStunStatusEffects( entity ent, float duration, float fadeoutDuration = 0.5, float slowTurn = EMP_SEVERITY_SLOWTURN, float slowMove = EMP_SEVERITY_SLOWMOVE )
{
	entity target = ent
	int slowEffect = StatusEffect_AddTimed( target, eStatusEffect.turn_slow, slowTurn, duration, fadeoutDuration )
	int turnEffect = StatusEffect_AddTimed( target, eStatusEffect.move_slow, slowMove, duration, fadeoutDuration )

	#if SERVER
		if ( ent.IsPlayer() )
		{
			ent.p.empStatusEffectsToClearForPhaseShift.append( slowEffect )
			ent.p.empStatusEffectsToClearForPhaseShift.append( turnEffect )
		}
	#endif
}

#if R5DEV
string ornull function FindEnumNameForValue( table searchTable, int searchVal )
{
	foreach ( string keyname, int value in searchTable )
	{
		if ( value == searchVal )
			return keyname
	}
	return null
}

void function DevPrintAllStatusEffectsOnEnt( entity ent )
{
	printt( "Effects:", ent )
	array<float> effects = StatusEffect_GetAllSeverity( ent )
	int length           = effects.len()
	int found            = 0
	for ( int idx = 0; idx < length; idx++ )
	{
		float severity = effects[idx]
		if ( severity <= 0.0 )
			continue
		string ornull name = FindEnumNameForValue( eStatusEffect, idx )
		Assert( name )
		expect string( name )
		printt( " eStatusEffect." + name + ": " + severity )
		found++
	}
	printt( found + " effects active.\n" )
}
#endif // #if R5DEV

entity function GetMeleeWeapon( entity player )
{
	array<entity> weapons = player.GetMainWeapons()
	foreach ( weaponEnt in weapons )
	{
		printt("ismelee", weaponEnt.IsWeaponMelee())
		if ( weaponEnt.IsWeaponMelee() )
			return weaponEnt
	}

	return null
}


array<entity> function GetPrimaryWeapons( entity player )
{
	array<entity> primaryWeapons
	array<entity> weapons = player.GetMainWeapons()
	foreach ( weaponEnt in weapons )
	{
		int weaponType = weaponEnt.GetWeaponType()
		if ( weaponType == WT_SIDEARM || weaponType == WT_ANTITITAN )
			continue

		primaryWeapons.append( weaponEnt )
	}
	return primaryWeapons
}


array<entity> function GetSidearmWeapons( entity player )
{
	array<entity> sidearmWeapons
	array<entity> weapons = player.GetMainWeapons()
	foreach ( weaponEnt in weapons )
	{
		if ( weaponEnt.GetWeaponType() != WT_SIDEARM )
			continue

		sidearmWeapons.append( weaponEnt )
	}
	return sidearmWeapons
}


array<entity> function GetATWeapons( entity player )
{
	array<entity> atWeapons
	array<entity> weapons = player.GetMainWeapons()
	foreach ( weaponEnt in weapons )
	{
		if ( weaponEnt.GetWeaponType() != WT_ANTITITAN )
			continue

		atWeapons.append( weaponEnt )
	}
	return atWeapons
}


entity function GetPlayerFromTitanWeapon( entity weapon )
{
	entity titan = weapon.GetWeaponOwner()
	entity player

	if ( titan == null )
		return null

	if ( !titan.IsPlayer() )
		player = titan.GetBossPlayer()
	else
		player = titan

	return player
}

#if SERVER
void function GivePlayerAmpedWeapon( entity player, string weaponName )
{
	array<entity> weapons = player.GetMainWeapons()
	int numWeapons        = weapons.len()
	if ( numWeapons == 0 )
		return

	//Figure out what weapon to take away.
	//This is more complicated than it should be because of rules of what weapons can be in what slots, e.g.  your anti-titan weapon can't be replaced by non anti-titan weapons
	if ( HasWeapon( player, weaponName ) )
	{
		//Simplest case:
		//Take away the currently existing version of the weapon you already have.
		player.TakeWeaponNow( weaponName )
	}
	else
	{
		bool ampedWeaponIsAntiTitan = GetWeaponInfoFileKeyField_Global( weaponName, "weaponType" ) == "anti_titan"
		if ( ampedWeaponIsAntiTitan )
		{
			foreach ( weapon in weapons )
			{
				string currentWeaponClassName = weapon.GetWeaponClassName()
				if ( GetWeaponInfoFileKeyField_Global( currentWeaponClassName, "weaponType" ) == "anti_titan" )
				{
					player.TakeWeaponNow( currentWeaponClassName )
					break
				}
			}

			unreachable //We had no anti-titan weapon? Shouldn't ever be possible
		}
		else
		{
			string currentActiveWeaponClassName = player.GetActiveWeapon( eActiveInventorySlot.mainHand ).GetWeaponClassName()
			if ( ShouldReplaceWeaponInFirstSlot( player, currentActiveWeaponClassName ) )
			{
				//Current weapon is anti_titan, but amped weapon we are trying to give is not. Just replace the weapon that is in the first slot.
				//Assumes that weapon in first slot is not an anti-titan weapon
				//We could get even fancier and look to see if the amped weapon is a primary weapon or a sidearm and replace the slot accordingly, but
				//that makes it more complicated, plus there are cases where you can have no primary weapons/no side arms etc
				string firstWeaponClassName = weapons[ 0 ].GetWeaponClassName()
				Assert( GetWeaponInfoFileKeyField_Global( firstWeaponClassName, "weaponType" ) != "anti_titan" )
				player.TakeWeaponNow( firstWeaponClassName )
			}
			else
			{
				player.TakeWeaponNow( currentActiveWeaponClassName )
			}
		}
	}

	array<string> burnMods = GetWeaponBurnMods( weaponName )
	entity ampedWeapon     = player.GiveWeapon( weaponName, WEAPON_INVENTORY_SLOT_ANY, burnMods )
	ampedWeapon.SetWeaponPrimaryClipCount( ampedWeapon.GetWeaponPrimaryClipCountMax() ) //Needed for weapons that give a mod with extra clip size
}

bool function ShouldReplaceWeaponInFirstSlot( entity player, string currentActiveWeaponClassName )
{
	if ( GetWeaponInfoFileKeyField_Global( currentActiveWeaponClassName, "weaponType" ) == "anti_titan" ) //Active weapon is anti-titan weapon. Can't replace anti-titan weapon slot with non-anti-titan weapon
		return true

	if ( currentActiveWeaponClassName == player.GetOffhandWeapon( OFFHAND_ORDNANCE ).GetWeaponClassName() )
		return true

	return false
}

void function GivePlayerAmpedWeaponAndSetAsActive( entity player, string weaponName )
{
	GivePlayerAmpedWeapon( player, weaponName )
	player.SetActiveWeaponByName( eActiveInventorySlot.mainHand, weaponName )
}

void function ReplacePlayerOffhand( entity player, string offhandName, array<string> mods = [] )
{
	player.TakeOffhandWeapon( OFFHAND_SPECIAL )
	player.GiveOffhandWeapon( offhandName, OFFHAND_SPECIAL, mods )
}

void function ReplacePlayerOrdnance( entity player, string ordnanceName, array<string> mods = [] )
{
	player.TakeOffhandWeapon( OFFHAND_ORDNANCE )
	player.GiveOffhandWeapon( ordnanceName, OFFHAND_ORDNANCE, mods )
}

void function PAS_CooldownReduction_OnKill( entity victim, entity attacker, var damageInfo )
{
	if ( !IsAlive( attacker ) || !IsPilot( attacker ) )
		return

	array<string> weaponMods = GetWeaponModsFromDamageInfo( damageInfo )

	if ( GetCurrentPlaylistVarInt( "featured_mode_tactikill", 0 ) > 0 )
	{
		entity weapon = attacker.GetOffhandWeapon( OFFHAND_LEFT )

		switch ( weapon.GetWeaponSettingEnum( eWeaponVar.cooldown_type, eWeaponCooldownType ) )
		{
			case eWeaponCooldownType.grapple:
				attacker.SetSuitGrapplePower( attacker.GetSuitGrapplePower() + 100 )
				break

			case eWeaponCooldownType.ammo:
			case eWeaponCooldownType.ammo_instant:
			case eWeaponCooldownType.ammo_deployed:
			case eWeaponCooldownType.ammo_timed:
				int maxAmmo = weapon.GetWeaponPrimaryClipCountMax()
				if ( maxAmmo > 0 )
					weapon.SetWeaponPrimaryClipCountNoRegenReset( maxAmmo )
				break

			case eWeaponCooldownType.chargeFrac:
				weapon.SetWeaponChargeFraction( 0 )
				break

				//		case "mp_ability_ground_slam":
				//			break

			default:
				Assert( false, weapon.GetWeaponClassName() + " needs to be updated to support cooldown_type setting" )
				break
		}
	}
}

void function RunWeaponAllowLogic( entity weapon )
{
	entity owner = weapon.GetWeaponOwner()
	if ( weapon.w.disallowDeployStackCount > 0 || (IsValid( owner ) && owner.p.allWeaponsDisallowDeployStackCount > 0) )
	{
		if ( !IsValid( owner ) || owner.p.forceAllowDeployOfWeapon != weapon )
			weapon.AllowUse( false )
	}
	else
	{
		weapon.AllowUse( true )
	}
}

void function WeaponAllowLogic_OnPlayerRespawed( entity player )
{
	player.SetInventoryChangedCallbackEnabled( true )
	WeaponAllowLogic_OnPlayerInventoryChanged( player )
}

bool function WeaponAllowLogic_CheckWeaponOwner( entity weapon )
{
	entity currentOwner = weapon.GetWeaponOwner()
	if ( weapon.w.lastKnownOwner != currentOwner )
	{
		weapon.w.lastKnownOwner = currentOwner
		weapon.w.disallowDeployStackCount = 0
		return true
	}
	return false
}

void function WeaponAllowLogic_OnPlayerInventoryChanged( entity player )
{
	foreach ( weapon in GetAllPlayerWeapons( player ) )
	{
		if ( WeaponAllowLogic_CheckWeaponOwner( weapon ) )
			RunWeaponAllowLogic( weapon )
	}
}

void function DisallowWeaponDeploy( entity weapon )
{
	WeaponAllowLogic_CheckWeaponOwner( weapon )
	weapon.w.disallowDeployStackCount++
	Assert( weapon.w.disallowDeployStackCount <= 99, "Potential DisallowWeaponDeploy/AllowWeaponDeploy mismatch (weapon disabled over 99 times!)" )
	if ( weapon.w.disallowDeployStackCount == 1 )
		RunWeaponAllowLogic( weapon )
}

void function AllowWeaponDeploy( entity weapon )
{
	WeaponAllowLogic_CheckWeaponOwner( weapon )
	weapon.w.disallowDeployStackCount--
	Assert( weapon.w.disallowDeployStackCount >= 0, "Called AllowWeaponDeploy on a weapon more times than DisallowWeaponDeploy was called" )
	if ( weapon.w.disallowDeployStackCount == 0 )
		RunWeaponAllowLogic( weapon )
}

void function DisallowAllWeaponDeployment( entity player )
{
	player.p.allWeaponsDisallowDeployStackCount++
	Assert( player.p.allWeaponsDisallowDeployStackCount <= 99, "Potential DisallowAllWeaponUsage/AllowAllWeaponUsageDeployment mismatch (all weapons disabled over 99 times!)" )
	if ( player.p.allWeaponsDisallowDeployStackCount == 1 )
	{
		foreach ( weapon in GetAllPlayerWeapons( player ) )
			RunWeaponAllowLogic( weapon )
	}
}

void function AllowAllWeaponUsageDeployment( entity player )
{
	player.p.allWeaponsDisallowDeployStackCount--
	Assert( player.p.allWeaponsDisallowDeployStackCount >= 0, "Called AllowAllWeaponUsageDeployment on a player more times than DisallowAllWeaponUsage was called" )
	if ( player.p.allWeaponsDisallowDeployStackCount == 0 )
	{
		foreach ( weapon in GetAllPlayerWeapons( player ) )
			RunWeaponAllowLogic( weapon )
	}
}

void function StartForceAllowSpecificWeaponDeployment( entity weapon )
{
	WeaponAllowLogic_CheckWeaponOwner( weapon )
	entity owner = weapon.GetWeaponOwner()
	Assert( IsValid( owner ), "Tried to call StartForceAllowSpecificWeaponDeployment on a weapon with an invalid owner." )
	Assert( owner.p.forceAllowDeployOfWeapon == null, "Tried to call StartForceAllowSpecificWeaponDeployment on a player twice" )
	owner.p.forceAllowDeployOfWeapon = weapon

	RunWeaponAllowLogic( weapon )
}

void function StopForceAllowSpecificWeaponDeployment( entity weapon )
{
	WeaponAllowLogic_CheckWeaponOwner( weapon )
	entity owner = weapon.GetWeaponOwner()
	Assert( IsValid( owner ), "Tried to call StopForceAllowSpecificWeaponDeployment on a weapon with an invalid owner." )
	Assert( owner.p.forceAllowDeployOfWeapon != null, "Tried to call StopForceAllowSpecificWeaponDeployment without first calling StartForceAllowSpecificWeaponDeployment." )
	Assert( owner.p.forceAllowDeployOfWeapon == weapon, "Tried to call StopForceAllowSpecificWeaponDeployment on a weapon that was not the current force-allow-weapon." )
	owner.p.forceAllowDeployOfWeapon = null

	RunWeaponAllowLogic( weapon )
}

array<entity> function GetAllPlayerWeapons( entity player )
{
	array<entity> weapons = player.GetMainWeapons()
	weapons.extend( player.GetOffhandWeapons() )

	return weapons
}


void function WeaponAttackWave( entity ent, int projectileCount, entity inflictor, vector pos, vector dir, bool functionref( entity, int, entity, entity, vector, vector, int ) waveFunc )
{
	ent.EndSignal( "OnDestroy" )

	entity weapon
	entity projectile
	int maxCount
	float step
	entity owner
	int damageNearValueTitanArmor
	int count       = 0
	vector lastDownPos
	bool firstTrace = true

	dir.z = 0
	dir = Normalize( dir )
	vector angles = VectorToAngles( dir )

	if ( ent.IsProjectile() )
	{
		projectile = ent
		string chargedPrefix = ""
		if ( ent.proj.isChargedShot )
			chargedPrefix = "charge_"

		maxCount = expect int( ent.ProjectileGetWeaponInfoFileKeyField( chargedPrefix + "wave_max_count" ) )
		step = expect float( ent.ProjectileGetWeaponInfoFileKeyField( chargedPrefix + "wave_step_dist" ) )
		owner = ent.GetOwner()
		damageNearValueTitanArmor = projectile.GetProjectileWeaponSettingInt( eWeaponVar.damage_near_value_titanarmor )
	}
	else
	{
		weapon = ent
		maxCount = expect int( ent.GetWeaponInfoFileKeyField( "wave_max_count" ) )
		step = expect float( ent.GetWeaponInfoFileKeyField( "wave_step_dist" ) )
		owner = ent.GetWeaponOwner()
		damageNearValueTitanArmor = weapon.GetWeaponSettingInt( eWeaponVar.damage_near_value_titanarmor )
	}

	owner.EndSignal( "OnDestroy" )

	for ( int i = 0; i < maxCount; i++ )
	{
		vector newPos = pos + dir * step

		vector traceStart    = pos
		vector traceEndUnder = newPos
		vector traceEndOver  = newPos

		if ( !firstTrace )
		{
			traceStart = lastDownPos + <0, 0, 80>
			traceEndUnder = <newPos.x, newPos.y, traceStart.z - 40>
			traceEndOver = <newPos.x, newPos.y, traceStart.z + step * 0.57735056839> // The over height is to cover the case of a sheer surface that then continues gradually upwards (like mp_box)
		}
		firstTrace = false

		VortexBulletHit ornull vortexHit = VortexBulletHitCheck( owner, traceStart, traceEndOver )
		if ( vortexHit )
		{
			expect VortexBulletHit( vortexHit )
			entity vortexWeapon = vortexHit.vortex.GetOwnerWeapon()

			if ( vortexWeapon && vortexWeapon.GetWeaponClassName() == "mp_titanweapon_vortex_shield" )
				VortexDrainedByImpact( vortexWeapon, weapon, projectile ) // drain the vortex shield
			else if ( IsVortexSphere( vortexHit.vortex ) )
				VortexSphereDrainHealthForDamage( vortexHit.vortex, damageNearValueTitanArmor )

			WaitFrame()
			continue
		}

		//DebugDrawLine( traceStart, traceEndUnder, 0, 255, 0, true, 25.0 )
		array ignoreArray = []
		if ( IsValid( inflictor ) && inflictor.GetOwner() != null )
			ignoreArray.append( inflictor.GetOwner() )

		TraceResults forwardTrace = TraceLine( traceStart, traceEndUnder, ignoreArray, TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_BLOCK_WEAPONS )
		if ( forwardTrace.fraction == 1.0 )
		{
			//DebugDrawLine( forwardTrace.endPos, forwardTrace.endPos + <0,0,-1000>, 255, 0, 0, true, 25.0 )
			TraceResults downTrace = TraceLine( forwardTrace.endPos, forwardTrace.endPos + <0, 0, -1000>, ignoreArray, TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_BLOCK_WEAPONS )
			if ( downTrace.fraction == 1.0 )
				break

			entity movingGeo = null
			if ( downTrace.hitEnt && downTrace.hitEnt.HasPusherAncestor() && !downTrace.hitEnt.IsMarkedForDeletion() )
				movingGeo = downTrace.hitEnt

			if ( !waveFunc( ent, projectileCount, inflictor, movingGeo, downTrace.endPos, angles, i ) )
				return

			lastDownPos = downTrace.endPos
			pos = forwardTrace.endPos

			WaitFrame()
			continue
		}
		else
		{
			if ( IsValid( forwardTrace.hitEnt ) && (StatusEffect_GetSeverity( forwardTrace.hitEnt, eStatusEffect.pass_through_amps_weapon ) > 0) && !CheckPassThroughDir( forwardTrace.hitEnt, forwardTrace.surfaceNormal, forwardTrace.endPos ) )
				break
		}

		TraceResults upwardTrace = TraceLine( traceStart, traceEndOver, ignoreArray, TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_BLOCK_WEAPONS )
		//DebugDrawLine( traceStart, traceEndOver, 0, 0, 255, true, 25.0 )
		if ( upwardTrace.fraction < 1.0 )
		{
			if ( IsValid( upwardTrace.hitEnt ) )
			{
				if ( upwardTrace.hitEnt.IsWorld() || upwardTrace.hitEnt.IsPlayer() || upwardTrace.hitEnt.IsNPC() )
					break
			}
		}
		else
		{
			TraceResults downTrace = TraceLine( upwardTrace.endPos, upwardTrace.endPos + <0, 0, -1000>, ignoreArray, TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_BLOCK_WEAPONS )
			if ( downTrace.fraction == 1.0 )
				break

			entity movingGeo = null
			if ( downTrace.hitEnt && downTrace.hitEnt.HasPusherAncestor() && !downTrace.hitEnt.IsMarkedForDeletion() )
				movingGeo = downTrace.hitEnt

			if ( !waveFunc( ent, projectileCount, inflictor, movingGeo, downTrace.endPos, angles, i ) )
				return

			lastDownPos = downTrace.endPos
			pos = forwardTrace.endPos
		}

		WaitFrame()
	}
}

void function AddActiveThermiteBurn( entity ent )
{
	AddToScriptManagedEntArray( file.activeThermiteBurnsManagedEnts, ent )
}

array<entity> function GetActiveThermiteBurnsWithinRadius( vector origin, float dist, int team = TEAM_ANY )
{
	return GetScriptManagedEntArrayWithinCenter( file.activeThermiteBurnsManagedEnts, team, origin, dist )
}

void function EMP_DamagedPlayerOrNPC( entity ent, var damageInfo )
{
	Elecriticy_DamagedPlayerOrNPC( ent, damageInfo, FX_EMP_BODY_HUMAN, FX_EMP_BODY_TITAN, EMP_SEVERITY_SLOWTURN, EMP_SEVERITY_SLOWMOVE )
}

void function VanguardEnergySiphon_DamagedPlayerOrNPC( entity ent, var damageInfo )
{
	entity attacker = DamageInfo_GetAttacker( damageInfo )
	if ( IsValid( attacker ) && IsFriendlyTeam( attacker.GetTeam(), ent.GetTeam() ) )
		return

	Elecriticy_DamagedPlayerOrNPC( ent, damageInfo, FX_VANGUARD_ENERGY_BODY_HUMAN, FX_VANGUARD_ENERGY_BODY_TITAN, LASER_STUN_SEVERITY_SLOWTURN, LASER_STUN_SEVERITY_SLOWMOVE )
}

void function Elecriticy_DamagedPlayerOrNPC( entity ent, var damageInfo, asset humanFx, asset titanFx, float slowTurn, float slowMove )
{
	if ( !IsValid( ent ) )
		return

	if ( DamageInfo_GetCustomDamageType( damageInfo ) & DF_DOOMED_HEALTH_LOSS )
		return

	entity inflictor = DamageInfo_GetInflictor( damageInfo )
	if ( !IsValid( inflictor ) )
		return

	// Do electrical effect on this ent that everyone can see if they are a titan
	string tag = ""
	asset effect

	if ( ent.IsTitan() )
	{
		tag = "exp_torso_front"
		effect = titanFx
	}
	else if ( IsStalker( ent ) || IsSpectre( ent ) )
	{
		tag = "CHESTFOCUS"
		effect = humanFx
		if ( !ent.ContextAction_IsActive() && IsAlive( ent ) && ent.IsInterruptable() )
		{
			ent.Anim_ScriptedPlayActivityByName( "ACT_STUNNED", true, 0.1 )
		}
	}
	else if ( IsSuperSpectre( ent ) )
	{
		tag = "CHESTFOCUS"
		effect = humanFx

		if ( ent.GetParent() == null && !ent.ContextAction_IsActive() && IsAlive( ent ) && ent.IsInterruptable() )
		{
			ent.Anim_ScriptedPlayActivityByName( "ACT_STUNNED", true, 0.1 )
		}
	}
	else if ( IsGrunt( ent ) )
	{
		tag = "CHESTFOCUS"
		effect = humanFx
		if ( !ent.ContextAction_IsActive() && IsAlive( ent ) && ent.IsInterruptable() )
		{
			ent.Anim_ScriptedPlayActivityByName( "ACT_STUNNED", true, 0.1 )
			ent.EnableNPCFlag( NPC_PAIN_IN_SCRIPTED_ANIM )
		}
	}
	else if ( IsPilot( ent ) )
	{
		tag = "CHESTFOCUS"
		effect = humanFx
	}
	else if ( IsAirDrone( ent ) )
	{
		if ( GetDroneType( ent ) == "drone_type_marvin" )
			return

		if ( GetDroneType( ent ) == "drone_type_flame" )
			return

		tag = "HEADSHOT"
		effect = humanFx
		thread NpcEmpRebootPrototype( ent, damageInfo, humanFx, titanFx )
	}
	else if ( IsGunship( ent ) )
	{
		tag = "ORIGIN"
		effect = titanFx
		thread NpcEmpRebootPrototype( ent, damageInfo, humanFx, titanFx )
	}

	ent.Signal( "ArcStunned" )

	if ( tag != "" )
	{
		Assert( inflictor == DamageInfo_GetInflictor( damageInfo ) )
		Assert( !(inflictor instanceof CEnvExplosion) )
		if ( IsValid( inflictor ) )
		{
			float duration = EMP_GRENADE_PILOT_SCREEN_EFFECTS_DURATION_MAX
			if ( inflictor instanceof CBaseGrenade )
			{
				vector entCenter   = ent.GetWorldSpaceCenter()
				float dist         = Distance( DamageInfo_GetDamagePosition( damageInfo ), entCenter )
				float damageRadius = inflictor.GetDamageRadius()
				duration = GraphCapped( dist, damageRadius * 0.5, damageRadius, EMP_GRENADE_PILOT_SCREEN_EFFECTS_DURATION_MIN, EMP_GRENADE_PILOT_SCREEN_EFFECTS_DURATION_MAX )
			}
			thread EMP_FX( effect, ent, tag, duration )
		}
	}

	if ( StatusEffect_GetSeverity( ent, eStatusEffect.destroyed_by_emp ) )
		DamageInfo_SetDamage( damageInfo, ent.GetHealth() )

	// Don't do arc beams to entities that are on the same team... except the owner or if the damage type is specified to ignore friendly fire protection.
	entity attacker = DamageInfo_GetAttacker( damageInfo )
	if ( IsValid( attacker ) && IsFriendlyTeam( attacker.GetTeam(), ent.GetTeam() ) && (attacker != ent) && !DamageIgnoresFriendlyFire( damageInfo ) )
		return

	if ( ent.IsPlayer() )
	{
		thread EMPGrenade_EffectsPlayer( ent, damageInfo )
	}
	else if ( ent.IsTitan() )
	{
		EMPGrenade_AffectsShield( ent, damageInfo )
		GiveEMPStunStatusEffects( ent, 2.5, 1.0, slowTurn, slowMove )
		thread EMPGrenade_AffectsAccuracy( ent )
	}
	else if ( ent.IsMechanical() )
	{
		GiveEMPStunStatusEffects( ent, 2.5, 1.0, slowTurn, slowMove )
		DamageInfo_ScaleDamage( damageInfo, 2.05 )
	}
	else if ( ent.IsHuman() )
	{
		DamageInfo_ScaleDamage( damageInfo, 0.99 )
	}

	if ( inflictor instanceof CBaseGrenade )
	{
		if ( !ent.IsPlayer() || ent.IsTitan() ) //Beam should hit cloaked targets, when cloak is updated make IsCloaked() function.
			EMPGrenade_ArcBeam( DamageInfo_GetDamagePosition( damageInfo ), ent )
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// HACK: might make sense to move this to code
void function NpcEmpRebootPrototype( entity npc, var damageInfo, asset humanFx, asset titanFx )
{
	if ( !IsValid( npc ) )
		return

	npc.EndSignal( "OnDeath" )
	npc.EndSignal( "OnDestroy" )

	if ( !("rebooting" in npc.s) )
		npc.s.rebooting <- null

	if ( npc.s.rebooting ) // npc already knocked down and in rebooting process
		return

	float rebootTime
	vector groundPos
	vector origin    = npc.GetOrigin()
	string classname = npc.GetClassName()
	string soundPowerDown
	string soundPowerUp

	//------------------------------------------------------
	// Custom stuff depending on AI type
	//------------------------------------------------------
	switch ( classname )
	{
		case "npc_drone":
			soundPowerDown = "Drone_Power_Down"
			soundPowerUp = "Drone_Power_On"
			rebootTime = DRONE_REBOOT_TIME
			break

		case "npc_gunship":
			soundPowerDown = "Gunship_Power_Down"
			soundPowerUp = "Gunship_Power_On"
			rebootTime = GUNSHIP_REBOOT_TIME
			break

		default:
			Assert( 0, "Unhandled npc type: " + classname )
	}

	//------------------------------------------------------
	// NPC stunned and is rebooting
	//------------------------------------------------------
	npc.Signal( "OnStunned" )
	npc.s.rebooting = true


	//TODO: make drone/gunship slowly drift to the ground while rebooting
	/*
	groundPos = OriginToGround( origin )
	groundPos += <0,0,32>


	//DebugDrawLine(origin, groundPos, 255, 0, 0, true, 15 )

	//thread AssaultOrigin( drone, groundPos, 16 )
	//thread PlayAnim( drone, "idle" )
	*/


	thread EmpRebootFxPrototype( npc, humanFx, titanFx )
	npc.EnableNPCFlag( NPC_IGNORE_ALL )
	npc.SetNoTarget( true )
	npc.EnableNPCFlag( NPC_DISABLE_SENSING )    // don't do traces to look for enemies or players

	if ( IsAttackDrone( npc ) )
		npc.SetAttackMode( false )

	EmitSoundOnEntity( npc, soundPowerDown )

	wait rebootTime

	EmitSoundOnEntity( npc, soundPowerUp )
	npc.DisableNPCFlag( NPC_IGNORE_ALL )
	npc.SetNoTarget( false )
	npc.DisableNPCFlag( NPC_DISABLE_SENSING )    // don't do traces to look for enemies or players

	if ( IsAttackDrone( npc ) )
		npc.SetAttackMode( true )

	npc.s.rebooting = false
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// HACK: might make sense to move this to code
void function EmpRebootFxPrototype( entity npc, asset humanFx, asset titanFx )
{
	if ( !IsValid( npc ) )
		return

	npc.EndSignal( "OnDeath" )
	npc.EndSignal( "OnDestroy" )

	string classname = npc.GetClassName()
	vector origin
	float delayDuration
	entity fxHandle
	asset fxEMPdamage
	string fxTag
	float rebootTime
	string soundEMPdamage

	//------------------------------------------------------
	// Custom stuff depending on AI type
	//------------------------------------------------------
	switch ( classname )
	{
		case "npc_drone":
			if ( GetDroneType( npc ) == "drone_type_marvin" )
				return
			if ( GetDroneType( npc ) == "drone_type_flame" )
				return
			fxEMPdamage = humanFx
			fxTag = "HEADSHOT"
			rebootTime = DRONE_REBOOT_TIME
			soundEMPdamage = "Titan_Blue_Electricity_Cloud"
			break

		case "npc_gunship":
			fxEMPdamage = titanFx
			fxTag = "ORIGIN"
			rebootTime = GUNSHIP_REBOOT_TIME
			soundEMPdamage = "Titan_Blue_Electricity_Cloud"
			break

		default:
			Assert( 0, "Unhandled npc type: " + classname )
	}

	//------------------------------------------------------
	// Play Fx/Sound till reboot finishes
	//------------------------------------------------------
	fxHandle = ClientStylePlayFXOnEntity( fxEMPdamage, npc, fxTag, rebootTime )
	EmitSoundOnEntity( npc, soundEMPdamage )

	while ( npc.s.rebooting == true )
	{
		delayDuration = RandomFloatRange( 0.4, 1.2 )
		origin = npc.GetOrigin()


		EmitSoundAtPosition( npc.GetTeam(), origin, SOUND_EMP_REBOOT_SPARKS )
		PlayFX( FX_EMP_REBOOT_SPARKS, origin )
		PlayFX( FX_EMP_REBOOT_SPARKS, origin )

		OnThreadEnd(
			function() : ( fxHandle, npc, soundEMPdamage )
			{
				if ( IsValid( fxHandle ) )
					fxHandle.Fire( "StopPlayEndCap" )
				if ( IsValid( npc ) )
					StopSoundOnEntity( npc, soundEMPdamage )
			}
		)

		wait (delayDuration)
	}
}

void function EMP_FX( asset effect, entity ent, string tag, float duration )
{
	if ( !IsAlive( ent ) )
		return

	ent.Signal( "EMP_FX" )
	ent.EndSignal( "OnDestroy" )
	ent.EndSignal( "OnDeath" )
	ent.EndSignal( "StartPhaseShift" )
	ent.EndSignal( "EMP_FX" )

	bool isPlayer = ent.IsPlayer()

	int fxId     = GetParticleSystemIndex( effect )
	int attachId = ent.LookupAttachment( tag )

	entity fxHandle = StartParticleEffectOnEntity_ReturnEntity( ent, fxId, FX_PATTACH_POINT_FOLLOW, attachId )
	fxHandle.kv.VisibilityFlags = ENTITY_VISIBLE_TO_FRIENDLY | ENTITY_VISIBLE_TO_ENEMY
	fxHandle.SetOwner( ent )

	OnThreadEnd(
		function() : ( fxHandle, ent )
		{
			if ( IsValid( fxHandle ) )
			{
				EffectStop( fxHandle )
			}

			if ( IsValid( ent ) )
				StopSoundOnEntity( ent, "Titan_Blue_Electricity_Cloud" )
		}
	)

	if ( !isPlayer )
	{
		EmitSoundOnEntity( ent, "Titan_Blue_Electricity_Cloud" )
		wait duration
	}
	else
	{
		EmitSoundOnEntityExceptToPlayer( ent, ent, "Titan_Blue_Electricity_Cloud" )

		var endTime        = Time() + duration
		bool effectsActive = true
		while ( endTime > Time() )
		{
			if ( ent.IsPhaseShifted() )
			{
				if ( effectsActive )
				{
					effectsActive = false
					if ( IsValid( fxHandle ) )
						EffectSleep( fxHandle )

					if ( IsValid( ent ) )
						StopSoundOnEntity( ent, "Titan_Blue_Electricity_Cloud" )
				}
			}
			else if ( effectsActive == false )
			{
				EffectWake( fxHandle )
				EmitSoundOnEntityExceptToPlayer( ent, ent, "Titan_Blue_Electricity_Cloud" )
				effectsActive = true
			}

			WaitFrame()
		}
	}
}

void function EMPGrenade_AffectsShield( entity titan, var damageInfo )
{
	//#if TITANS_CLASSIC_GAMEPLAY
	//	int shieldHealth = titan.GetTitanSoul().GetShieldHealth()
	//	int shieldDamage = int( titan.GetTitanSoul().GetShieldHealthMax() * 0.5 )
	//
	//	titan.GetTitanSoul().SetShieldHealth( maxint( 0, shieldHealth - shieldDamage ) )
	//
	//	// attacker took down titan shields
	//	if ( shieldHealth && !titan.GetTitanSoul().GetShieldHealth() )
	//	{
	//		entity attacker = DamageInfo_GetAttacker( damageInfo )
	//		if ( attacker && attacker.IsPlayer() )
	//			EmitSoundOnEntityOnlyToPlayer( attacker, attacker, "titan_energyshield_down" )
	//	}
	//#endif // #if TITANS_CLASSIC_GAMEPLAY
}

void function EMPGrenade_AffectsAccuracy( entity npcTitan )
{
	npcTitan.EndSignal( "OnDestroy" )

	npcTitan.kv.AccuracyMultiplier = 0.5
	wait EMP_GRENADE_PILOT_SCREEN_EFFECTS_DURATION_MAX
	npcTitan.kv.AccuracyMultiplier = 1.0
}

void function EMPGrenade_EffectsPlayer( entity player, var damageInfo )
{
	player.Signal( "OnEMPPilotHit" )
	player.EndSignal( "OnEMPPilotHit" )

	if ( player.IsPhaseShifted() )
		return

	entity inflictor   = DamageInfo_GetInflictor( damageInfo )
	float dist         = Distance( DamageInfo_GetDamagePosition( damageInfo ), player.GetWorldSpaceCenter() )
	float damageRadius = 128
	if ( inflictor instanceof CBaseGrenade )
		damageRadius = inflictor.GetDamageRadius()
	float frac            = GraphCapped( dist, damageRadius * 0.5, damageRadius, 1.0, 0.0 )
	float strength        = EMP_GRENADE_PILOT_SCREEN_EFFECTS_MIN + ((EMP_GRENADE_PILOT_SCREEN_EFFECTS_MAX - EMP_GRENADE_PILOT_SCREEN_EFFECTS_MIN) * frac)
	float fadeoutDuration = EMP_GRENADE_PILOT_SCREEN_EFFECTS_FADE * frac
	float duration        = EMP_GRENADE_PILOT_SCREEN_EFFECTS_DURATION_MIN + ((EMP_GRENADE_PILOT_SCREEN_EFFECTS_DURATION_MAX - EMP_GRENADE_PILOT_SCREEN_EFFECTS_DURATION_MIN) * frac) - fadeoutDuration
	//vector origin = inflictor.GetOrigin()

	int dmgSource = DamageInfo_GetDamageSourceIdentifier( damageInfo )

	if ( player.IsTitan() )
	{
		// Hit player should do EMP screen effects locally
		Remote_CallFunction_Replay( player, "ServerCallback_TitanCockpitEMP", duration )

		EMPGrenade_AffectsShield( player, damageInfo )
	}
	else
	{
		if ( IsCloaked( player ) )
			player.SetCloakFlicker( 0.5, duration )

		// duration = 0
		// fadeoutDuration = 0

		//DamageInfo_SetDamage( damageInfo, 0 )
	}

	StatusEffect_AddTimed( player, eStatusEffect.emp, strength, duration, fadeoutDuration )
	GiveEMPStunStatusEffects( player, (duration + fadeoutDuration), fadeoutDuration )

	EmitSoundOnEntityOnlyToPlayer( player, player, "Arcstar_visualimpair" )
}

void function EMPGrenade_ArcBeam( vector grenadePos, entity ent )
{
	if ( !ent.IsPlayer() && !ent.IsNPC() )
		return

	Assert( IsValid( ent ) )
	float lifeDuration = 0.5

	// Control point sets the end position of the effect
	entity cpEnd = CreateEntity( "info_placement_helper" )
	SetTargetName( cpEnd, UniqueString( "emp_grenade_beam_cpEnd" ) )
	cpEnd.SetOrigin( grenadePos )
	DispatchSpawn( cpEnd )

	entity zapBeam = CreateEntity( "info_particle_system" )
	zapBeam.kv.cpoint1 = cpEnd.GetTargetName()
	zapBeam.SetValueForEffectNameKey( EMP_GRENADE_BEAM_EFFECT )
	zapBeam.kv.start_active = 0
	zapBeam.SetOrigin( ent.GetWorldSpaceCenter() )
	if ( !ent.IsMarkedForDeletion() ) // TODO: This is a hack for shipping. Should not be parenting to deleted entities
	{
		zapBeam.SetParent( ent, "", true, 0.0 )
	}

	DispatchSpawn( zapBeam )

	zapBeam.Fire( "Start" )
	zapBeam.Fire( "StopPlayEndCap", "", lifeDuration )
	zapBeam.Kill_Deprecated_UseDestroyInstead( lifeDuration )
	cpEnd.Kill_Deprecated_UseDestroyInstead( lifeDuration )
}

void function GetWeaponDPS( int activeSlot, bool vsTitan = false )
{
	entity player = GetPlayerArray()[0]
	entity weapon = player.GetActiveWeapon( activeSlot )

	float fire_rate        = weapon.GetWeaponSettingFloat( eWeaponVar.fire_rate )
	int burst_fire_count   = weapon.GetWeaponSettingInt( eWeaponVar.burst_fire_count )
	float burst_fire_delay = weapon.GetWeaponSettingFloat( eWeaponVar.burst_fire_delay )

	int damage_near_value = weapon.GetWeaponSettingInt( eWeaponVar.damage_near_value )
	int damage_far_value  = weapon.GetWeaponSettingInt( eWeaponVar.damage_far_value )

	if ( vsTitan )
	{
		damage_near_value = weapon.GetWeaponSettingInt( eWeaponVar.damage_near_value_titanarmor )
		damage_far_value = weapon.GetWeaponSettingInt( eWeaponVar.damage_far_value_titanarmor )
	}

	if ( burst_fire_count )
	{
		float timePerShot    = 1 / fire_rate
		float timePerBurst   = (timePerShot * burst_fire_count) + burst_fire_delay
		float burstPerSecond = 1 / timePerBurst

		printt( timePerBurst )

		printt( "DPS Near", (burstPerSecond * burst_fire_count) * damage_near_value )
		printt( "DPS Far ", (burstPerSecond * burst_fire_count) * damage_far_value )
	}
	else
	{
		printt( "DPS Near", fire_rate * damage_near_value )
		printt( "DPS Far ", fire_rate * damage_far_value )
	}
}

void function GetTTK( string weaponRef, float health = 100.0 )
{
	float fire_rate        = GetWeaponInfoFileKeyField_GlobalFloat( weaponRef, "fire_rate" )
	local burst_fire_count = GetWeaponInfoFileKeyField_Global( weaponRef, "burst_fire_count" )
	if ( burst_fire_count != null )
		burst_fire_count = float( burst_fire_count )

	float burst_fire_delay = GetWeaponInfoFileKeyField_GlobalFloat( weaponRef, "burst_fire_delay" )

	int damage_near_value = GetWeaponInfoFileKeyField_GlobalInt( weaponRef, "damage_near_value" )
	int damage_far_value  = GetWeaponInfoFileKeyField_GlobalInt( weaponRef, "damage_far_value" )

	float nearBodyShots = ceil( health / damage_near_value ) - 1
	float farBodyShots  = ceil( health / damage_far_value ) - 1

	float delayAdd = 0
	if ( burst_fire_count && burst_fire_count < nearBodyShots )
		delayAdd += burst_fire_delay

	printt( "TTK Near", (nearBodyShots * (1 / fire_rate)) + delayAdd, " (" + (nearBodyShots + 1) + ")" )

	delayAdd = 0
	if ( burst_fire_count && burst_fire_count < farBodyShots )
		delayAdd += burst_fire_delay

	printt( "TTK Far ", (farBodyShots * (1 / fire_rate)) + delayAdd, " (" + (farBodyShots + 1) + ")" )
}

array<string> function GetWeaponModsFromDamageInfo( var damageInfo )
{
	entity weapon    = DamageInfo_GetWeapon( damageInfo )
	entity inflictor = DamageInfo_GetInflictor( damageInfo )
	int damageType   = DamageInfo_GetCustomDamageType( damageInfo )

	if ( IsValid( weapon ) )
	{
		return weapon.GetMods()
	}
	else if ( IsValid( inflictor ) )
	{
		if ( "weaponMods" in inflictor.s && inflictor.s.weaponMods )
		{
			array<string> temp
			foreach ( string mod in inflictor.s.weaponMods )
			{
				temp.append( mod )
			}

			return temp
		}
		else if ( inflictor.IsProjectile() )
			return inflictor.ProjectileGetMods()
		else if ( damageType & DF_EXPLOSION && inflictor.IsPlayer() && IsValid( inflictor.GetActiveWeapon( eActiveInventorySlot.mainHand ) ) )
			return inflictor.GetActiveWeapon( eActiveInventorySlot.mainHand ).GetMods()
		//Hack - Splash damage doesn't pass mod weapon through. This only works under the assumption that offhand weapons don't have mods.
	}
	return []
}

void function OnPlayerGetsNewPilotLoadout( entity player, PilotLoadoutDef loadout )
{
	SetPlayerCooldowns( player )

	if ( GetCurrentPlaylistVarInt( "featured_mode_amped_tacticals", 0 ) >= 1 )
	{
		GiveExtraWeaponMod( player, "amped_tacticals" )
	}

	if ( GetCurrentPlaylistVarInt( "featured_mode_all_grapple", 0 ) >= 1 )
	{
		GiveExtraWeaponMod( player, "all_grapple" )
	}
}

void function SetPlayerCooldowns( entity player, array<int> offhandIndices = [ OFFHAND_LEFT, OFFHAND_RIGHT ] )
{
	if ( player.IsTitan() )
		return

	foreach ( index in offhandIndices )
	{
		float lastUseTime    = player.p.lastPilotOffhandUseTime[ index ]
		float lastChargeFrac = player.p.lastPilotOffhandChargeFrac[ index ]
		float lastClipFrac   = player.p.lastPilotClipFrac[ index ]

		// if ( lastUseTime >= 0.0 )
		{
			entity weapon = player.GetOffhandWeapon( index )
			if ( !IsValid( weapon ) )
				continue

			string weaponClassName = weapon.GetWeaponClassName()

			switch ( weapon.GetWeaponSettingEnum( eWeaponVar.cooldown_type, eWeaponCooldownType ) )
			{
				case eWeaponCooldownType.grapple:
					// GetPlayerSettingsField isn't working for moddable fields? - Bug 129567
					float powerRequired = 100.0 // GetPlayerSettingsField( "grapple_power_required" )
					float regenRefillDelay = 3.0 // GetPlayerSettingsField( "grapple_power_regen_delay" )
					float regenRefillRate = 5.0 // GetPlayerSettingsField( "grapple_power_regen_rate" )
					float suitPowerToRestore = powerRequired - player.p.lastSuitPower
					float regenRefillTime = suitPowerToRestore / regenRefillRate

					float regenStartTime = lastUseTime + regenRefillDelay

					float newSuitPower = GraphCapped( Time() - regenStartTime, 0.0, regenRefillTime, player.p.lastSuitPower, powerRequired )

					player.SetSuitGrapplePower( newSuitPower )
					break

				case eWeaponCooldownType.ammo:
				case eWeaponCooldownType.ammo_instant:
				case eWeaponCooldownType.ammo_deployed:
				case eWeaponCooldownType.ammo_timed:
					int maxAmmo = weapon.GetWeaponPrimaryClipCountMax()

					if ( maxAmmo > 0 )
					{
						float fireDuration     = weapon.GetWeaponSettingFloat( eWeaponVar.fire_duration )
						float regenRefillDelay = weapon.GetWeaponSettingFloat( eWeaponVar.regen_ammo_refill_start_delay )
						float regenRefillRate  = weapon.GetWeaponSettingFloat( eWeaponVar.regen_ammo_refill_rate )

						if ( regenRefillRate == 0 )
							continue

						int startingClipCount = int( lastClipFrac * maxAmmo )
						int ammoToRestore     = maxAmmo - startingClipCount
						float regenRefillTime = ammoToRestore / regenRefillRate

						float regenStartTime = lastUseTime + fireDuration + regenRefillDelay

						int newAmmo = int( GraphCapped( Time() - regenStartTime, 0.0, regenRefillTime, startingClipCount, maxAmmo ) )

						weapon.SetWeaponPrimaryClipCountAbsolute( newAmmo )
					}
					break

				case eWeaponCooldownType.chargeFrac:
					float chargeCooldownDelay = weapon.GetWeaponSettingFloat( eWeaponVar.charge_cooldown_delay )
					float chargeCooldownTime = weapon.GetWeaponSettingFloat( eWeaponVar.charge_cooldown_time )
					float regenRefillTime = lastChargeFrac * chargeCooldownTime
					float regenStartTime = lastUseTime + chargeCooldownDelay

					float newCharge = GraphCapped( Time() - regenStartTime, 0.0, regenRefillTime, lastChargeFrac, 0.0 )

					weapon.SetWeaponChargeFraction( newCharge )
					break

				default:
					printt( weaponClassName + " needs to be updated to support cooldown_type setting" )
					break
			}
		}
	}
}

void function ResetPlayerCooldowns( entity player )
{
	if ( player.IsTitan() )
		return

	array<int> offhandIndices = [ OFFHAND_LEFT, OFFHAND_RIGHT ]

	foreach ( index in offhandIndices )
	{
		float lastUseTime    = -99.0//player.p.lastPilotOffhandUseTime[ index ]
		float lastChargeFrac = -1.0//player.p.lastPilotOffhandChargeFrac[ index ]
		float lastClipFrac   = 1.0//player.p.lastPilotClipFrac[ index ]

		entity weapon = player.GetOffhandWeapon( index )
		if ( !IsValid( weapon ) )
			continue

		string weaponClassName = weapon.GetWeaponClassName()

		switch ( weapon.GetWeaponSettingEnum( eWeaponVar.cooldown_type, eWeaponCooldownType ) )
		{
			case eWeaponCooldownType.grapple:
				// GetPlayerSettingsField isn't working for moddable fields? - Bug 129567
				float powerRequired = 100.0 // GetPlayerSettingsField( "grapple_power_required" )
				player.SetSuitGrapplePower( powerRequired )
				break

			case eWeaponCooldownType.ammo:
			case eWeaponCooldownType.ammo_instant:
			case eWeaponCooldownType.ammo_deployed:
			case eWeaponCooldownType.ammo_timed:
				int maxAmmo = weapon.GetWeaponPrimaryClipCountMax()
				if ( maxAmmo > 0 )
					weapon.SetWeaponPrimaryClipCountAbsolute( maxAmmo )
				break

			case eWeaponCooldownType.chargeFrac:
				weapon.SetWeaponChargeFraction( 1.0 )
				break

			default:
				printt( weaponClassName + " needs to be updated to support cooldown_type setting" )
				break
		}
	}
}

void function OnPlayerKilled( entity player, entity attacker, var damageInfo )
{
	StoreOffhandData( player )
}

void function StoreOffhandData( entity player, bool waitEndFrame = true, array<int> offhandIndices = [ OFFHAND_LEFT, OFFHAND_RIGHT ] )
{
	thread StoreOffhandDataThread( player, waitEndFrame, offhandIndices )
}

void function StoreOffhandDataThread( entity player, bool waitEndFrame, array<int> offhandIndices )
{
	if ( !IsValid( player ) )
		return

	player.EndSignal( "OnDestroy" )

	if ( waitEndFrame )
		WaitEndFrame() // Need to WaitEndFrame so clip counts can be updated if player is dying the same frame

	// Reset all values for full cooldown
	player.p.lastSuitPower = 0.0

	foreach ( index in offhandIndices )
	{
		player.p.lastPilotOffhandChargeFrac[ index ] = 1.0
		player.p.lastPilotClipFrac[ index ] = 1.0

		player.p.lastTitanOffhandChargeFrac[ index ] = 1.0
		player.p.lastTitanClipFrac[ index ] = 1.0
	}

	if ( player.IsTitan() )
		return

	foreach ( index in offhandIndices )
	{
		entity weapon = player.GetOffhandWeapon( index )
		if ( !IsValid( weapon ) )
			continue

		string weaponClassName = weapon.GetWeaponClassName()

		switch ( weapon.GetWeaponSettingEnum( eWeaponVar.cooldown_type, eWeaponCooldownType ) )
		{
			case eWeaponCooldownType.grapple:
				player.p.lastSuitPower = player.GetSuitGrapplePower()
				break

			case eWeaponCooldownType.ammo:
			case eWeaponCooldownType.ammo_instant:
			case eWeaponCooldownType.ammo_deployed:
			case eWeaponCooldownType.ammo_timed:

				if ( player.IsTitan() )
				{
					if ( !weapon.IsWeaponRegenDraining() )
						player.p.lastTitanClipFrac[ index ] = weapon.GetWeaponPrimaryClipCount() / float( weapon.GetWeaponPrimaryClipCountMax() )
					else
						player.p.lastTitanClipFrac[ index ] = 0.0
				}
				else
				{
					if ( !weapon.IsWeaponRegenDraining() )
						player.p.lastPilotClipFrac[ index ] = weapon.GetWeaponPrimaryClipCount() / float( weapon.GetWeaponPrimaryClipCountMax() )
					else
						player.p.lastPilotClipFrac[ index ] = 0.0
				}
				break

			case eWeaponCooldownType.chargeFrac:
				if ( player.IsTitan() )
					player.p.lastTitanOffhandChargeFrac[ index ] = weapon.GetWeaponChargeFraction()
				else
					player.p.lastPilotOffhandChargeFrac[ index ] = weapon.GetWeaponChargeFraction()
				break

			default:
				printt( weaponClassName + " needs to be updated to support cooldown_type setting" )
				break
		}
	}
}
#endif //SERVER


#if CLIENT
void function ServerCallback_SatchelPlanted()
{
	entity player = GetLocalViewPlayer()
	thread SatchelDetonationHint( player )
}

void function SatchelDetonationHint( entity player )
{
	player.EndSignal( "OnDeath" )
	player.EndSignal( "DetonateSatchels" )

	OnThreadEnd(
		function() : ( player )
		{
			if ( IsValid( player ) )
				SatchelDetonationHint_Destroy( player )
		}
	)

	string satchelClassName = "mp_weapon_satchel"

	if ( SHOW_SATCHEL_DETONATION_HINT_WITH_CLACKER )
		SatchelDetonationHint_Show( player )

	while ( PlayerHasWeapon( player, satchelClassName ) )
	{
		wait 0.1

		if ( !SHOW_SATCHEL_DETONATION_HINT_WITH_CLACKER )
		{
			// only show when detonator isn't actively held
			if ( player.GetActiveWeapon( OFFHAND_ORDNANCE ).GetWeaponClassName() != satchelClassName )
			{
				SatchelDetonationHint_Show( player )
			}
			else
			{
				SatchelDetonationHint_Destroy( player )
			}
		}
	}
}

void function SatchelDetonationHint_Show( entity player )
{
	if ( file.satchelHintRUI != null )
		return

	SatchelDetonationHint_Destroy( player )

	int sorting = 0
	file.satchelHintRUI = RuiCreate( $"ui/satchel_detonation_hint.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, sorting )
}

void function SatchelDetonationHint_Destroy( entity player )
{
	if ( file.satchelHintRUI != null )
		RuiDestroyIfAlive( file.satchelHintRUI )

	file.satchelHintRUI = null
}
#endif //CLIENT


void function PlayerUsedOffhand( entity player, entity offhandWeapon, bool sendPINEvent = true, entity trackedProjectile = null, table pinAdditionalData = {} )
{
	#if SERVER
		array<int> offhandIndices = [ OFFHAND_TACTICAL, OFFHAND_ULTIMATE, OFFHAND_LEFT, OFFHAND_RIGHT, OFFHAND_ANTIRODEO, OFFHAND_INVENTORY, OFFHAND_EQUIPMENT ]

		foreach ( func in svGlobal.onPlayerUsedOffhandCallbacks )
		{
			func( player, offhandWeapon )
		}

		foreach ( index in offhandIndices )
		{
			entity weapon = player.GetOffhandWeapon( index )
			if ( !IsValid( weapon ) )
				continue

			if ( weapon != offhandWeapon )
				continue

			if ( player.IsTitan() )
				player.p.lastTitanOffhandUseTime[ index ] = Time()
			else
				player.p.lastPilotOffhandUseTime[ index ] = Time()
			StoreOffhandData( player, true, [index] )

			// PIN
			if ( sendPINEvent )
			{
				string weaponName = offhandWeapon.GetWeaponClassName()
				if ( index == OFFHAND_TACTICAL )
					PIN_PlayerAbility( player, weaponName, ABILITY_TYPE.TACTICAL, trackedProjectile, pinAdditionalData )
				else if ( index == OFFHAND_ULTIMATE )
					PIN_PlayerAbility( player, weaponName, ABILITY_TYPE.ULTIMATE, trackedProjectile, pinAdditionalData )
			}

			return
		}

	#endif // SERVER

	#if CLIENT
		if ( offhandWeapon == player.GetOffhandWeapon( OFFHAND_ULTIMATE ) )
			UltimateWeaponStateSet( eUltimateState.ACTIVE )
		Chroma_PlayerUsedAbility( player, offhandWeapon )
	#endif //CLIENT
}


RadiusDamageData function GetRadiusDamageDataFromProjectile( entity projectile, entity owner )
{
	RadiusDamageData radiusDamageData

	radiusDamageData.explosionDamage = -1
	radiusDamageData.explosionDamageHeavyArmor = -1

	if ( owner.IsNPC() )
	{
		radiusDamageData.explosionDamage = projectile.GetProjectileWeaponSettingInt( eWeaponVar.npc_explosion_damage )
		radiusDamageData.explosionDamageHeavyArmor = projectile.GetProjectileWeaponSettingInt( eWeaponVar.npc_explosion_damage_heavy_armor )
	}

	if ( radiusDamageData.explosionDamage == -1 )
		radiusDamageData.explosionDamage = projectile.GetProjectileWeaponSettingInt( eWeaponVar.explosion_damage )

	if ( radiusDamageData.explosionDamageHeavyArmor == -1 )
		radiusDamageData.explosionDamageHeavyArmor = projectile.GetProjectileWeaponSettingInt( eWeaponVar.explosion_damage_heavy_armor )

	radiusDamageData.explosionRadius = projectile.GetProjectileWeaponSettingFloat( eWeaponVar.explosionradius )
	radiusDamageData.explosionInnerRadius = projectile.GetProjectileWeaponSettingFloat( eWeaponVar.explosion_inner_radius )

	Assert( radiusDamageData.explosionRadius > 0, "Created RadiusDamageData with 0 radius" )
	Assert( radiusDamageData.explosionDamage > 0 || radiusDamageData.explosionDamageHeavyArmor > 0, "Created RadiusDamageData with 0 damage" )
	return radiusDamageData
}


void function AddCallback_OnPlayerAddWeaponMod( void functionref( entity, entity, string ) callbackFunc )
{
	file.playerAddWeaponModCallbacks.append( callbackFunc )
}


void function AddCallback_OnPlayerRemoveWeaponMod( void functionref( entity, entity, string ) callbackFunc )
{
	file.playerRemoveWeaponModCallbacks.append( callbackFunc )
}


void function CodeCallback_OnPlayerAddedWeaponMod( entity player, entity weapon, string mod )
{
	if ( !IsValid( player ) )
		return

	foreach ( callback in file.playerAddWeaponModCallbacks )
	{
		callback( player, weapon, mod )
	}

	//printt( "weapon mod added to", weapon.GetWeaponClassName(), "-", mod )

	#if SERVER
		bool modAdded = true
		RunWeaponModChangedCallbacks( weapon, mod, modAdded )
	#endif
}


void function CodeCallback_OnPlayerRemovedWeaponMod( entity player, entity weapon, string mod )
{
	if ( !IsValid( player ) )
		return

	foreach ( callback in file.playerRemoveWeaponModCallbacks )
	{
		callback( player, weapon, mod )
	}

	//printt( "weapon mod removed from", weapon.GetWeaponClassName(), "-", mod )

	#if SERVER
		bool modAdded = false
		RunWeaponModChangedCallbacks( weapon, mod, modAdded )
	#endif
}


#if SERVER
bool function WeaponHasCosmetics( entity weapon )
{
	if ( weapon.GetSkin() != 0 )
		return true

	asset modelWithMods    = GetWeaponInfoFileKeyFieldAsset_WithMods_Global( weapon.GetWeaponClassName(), weapon.GetMods(), "playermodel" )
	asset modelWithoutMods = GetWeaponInfoFileKeyFieldAsset_Global( weapon.GetWeaponClassName(), "playermodel" )

	return modelWithMods != modelWithoutMods
}


void function Thermite_DamagePlayerOrNPCSounds( entity ent )
{
	if ( ent.IsTitan() )
	{
		if ( ent.IsPlayer() )
		{
			EmitSoundOnEntityOnlyToPlayer( ent, ent, "titan_thermiteburn_3p_vs_1p" )
			EmitSoundOnEntityExceptToPlayer( ent, ent, "titan_thermiteburn_1p_vs_3p" )
		}
		else
		{
			EmitSoundOnEntity( ent, "titan_thermiteburn_1p_vs_3p" )
		}
	}
	else
	{
		if ( ent.IsPlayer() )
		{
			EmitSoundOnEntityOnlyToPlayer( ent, ent, "flesh_thermiteburn_3p_vs_1p" )
			EmitSoundOnEntityExceptToPlayer( ent, ent, "flesh_thermiteburn_1p_vs_3p" )
		}
		else
		{
			EmitSoundOnEntity( ent, "flesh_thermiteburn_1p_vs_3p" )
		}
	}
}

void function RemoveThreatScopeColorStatusEffect( entity player )
{
	for ( int i = file.colorSwapStatusEffects.len() - 1; i >= 0; i-- )
	{
		entity owner = file.colorSwapStatusEffects[i].weaponOwner
		if ( !IsValid( owner ) )
		{
			file.colorSwapStatusEffects.remove( i )
			continue
		}

		if ( owner == player )
		{
			StatusEffect_Stop( player, file.colorSwapStatusEffects[i].statusEffectId )
			file.colorSwapStatusEffects.remove( i )
		}
	}
}

void function AddThreatScopeColorStatusEffect( entity player )
{
	ColorSwapStruct info
	info.weaponOwner = player
	info.statusEffectId = StatusEffect_AddTimed( player, eStatusEffect.cockpitColor, COCKPIT_COLOR_THREAT, 100000, 0 )
	file.colorSwapStatusEffects.append( info )
}

vector function LimitVelocityHorizontal( vector vel, float speed )
{
	vector horzVel = <vel.x, vel.y, 0>
	if ( Length( horzVel ) <= speed )
		return vel

	horzVel = Normalize( horzVel )
	horzVel *= speed
	vel.x = horzVel.x
	vel.y = horzVel.y
	return vel
}

entity function CreateDamageInflictorHelper( float lifetime )
{
	entity inflictor = CreateEntity( "info_target" )
	DispatchSpawn( inflictor )
	inflictor.e.onlyDamageEntitiesOnce = true
	if ( lifetime > 0.0 )
		thread DelayedDestroyDamageInflictorHelper( inflictor, lifetime )
	return inflictor
}

entity function CreateOncePerTickDamageInflictorHelper( float lifetime )
{
	entity inflictor = CreateEntity( "info_target" )
	DispatchSpawn( inflictor )
	inflictor.e.onlyDamageEntitiesOncePerTick = true
	if ( lifetime > 0.0 )
		thread DelayedDestroyDamageInflictorHelper( inflictor, lifetime )
	return inflictor
}

void function DelayedDestroyDamageInflictorHelper( entity inflictor, float lifetime )
{
	inflictor.EndSignal( "OnDestroy" )
	wait lifetime
	inflictor.Destroy()
}


void function GiveMatchingAkimboWeapon( entity weapon, array<string> mods, float startDelay = 0.0 )
{
	if ( startDelay > 0 )
		wait startDelay

	if ( !IsValid( weapon ) )
		return

	entity player = weapon.GetWeaponOwner()
	if ( !IsAlive( player ) )
		return

	string akimboClassName = weapon.GetWeaponClassName()

	array<entity> mainWeapons = player.GetMainWeapons()
	int foundWeapons          = 0
	foreach ( w in mainWeapons )
		if ( w.GetWeaponClassName() == akimboClassName )
			foundWeapons++

	if ( foundWeapons > 1 )
		return  // already have an akimbo weapon

	int slot = weapon.GetInventoryIndex()
	if ( slot > WEAPON_INVENTORY_SLOT_PRIMARY_2 ) // HACK
		return  // only give matching akimbo weapon if this weapon isn't itself in an akimbo slot

	int dualslot = GetDualPrimarySlotForWeapon( weapon )

	player.GiveWeapon( akimboClassName, dualslot, mods )
}

void function TakeMatchingAkimboWeapon( entity weapon )
{
	if ( !IsValid( weapon ) )
		return

	entity player = weapon.GetWeaponOwner()
	if ( !IsAlive( player ) )
		return

	int slot = weapon.GetInventoryIndex()
	if ( slot > WEAPON_INVENTORY_SLOT_PRIMARY_2 ) // HACK
		return  // only take matching akimbo weapon if this isn't itself in an akimbo slot

	int dualslot = GetDualPrimarySlotForWeapon( weapon )

	player.TakeNormalWeaponByIndex( dualslot )
}

int function GetDualPrimarySlotForWeapon( entity weapon )
{
	int slot = weapon.GetInventoryIndex()

	int dualslot = WEAPON_INVENTORY_SLOT_DUALPRIMARY_0
	if ( slot == 1 )
		dualslot = WEAPON_INVENTORY_SLOT_DUALPRIMARY_1
	else if ( slot == 2 )
		dualslot = WEAPON_INVENTORY_SLOT_DUALPRIMARY_2

	return dualslot
}

void function AddWeaponModChangedCallback( string weaponClassName, void functionref( entity, string, bool ) callbackFunc )
{
	if ( !(weaponClassName in file.weaponModChangedCallbacks) )
		file.weaponModChangedCallbacks[weaponClassName] <- []

	file.weaponModChangedCallbacks[weaponClassName].append( callbackFunc )
}

// modAdded: true= was added; false = was removed
void function RunWeaponModChangedCallbacks( entity weapon, string mod, bool modAdded )
{
	string className = weapon.GetWeaponClassName()
	if ( !(className in file.weaponModChangedCallbacks) )
		return

	foreach ( callbackFunc in file.weaponModChangedCallbacks[className] )
		callbackFunc( weapon, mod, modAdded )
}

bool function EntityCanBurnOverTime( entity ent )
{
	if ( !IsAlive( ent ) )
		return false

	if ( IsDoor(ent) )
		return true

	if ( ent.IsPlayer() && !ent.IsPlayerDecoy() )
		return true
	else if ( ent.IsNPC() )
		return true

	return false
}

void function TryApplyingBurnDamage( entity ent, entity owner, entity inflictor, BurnDamageSettings burnSettings )
{
	if ( EntityCanAcceptNewBurnDamageStack( ent, burnSettings ) )
	{
		AddEntityBurnDamageStack( ent, owner, inflictor, burnSettings )
	}
	else if ( ent.IsPlayerDecoy() )
	{
		// just apply all the damage at once since it should only tick once on a decoy
		ApplyBurnDamageTick( ent, burnSettings.burnDamage, owner, inflictor, burnSettings.damageSourceID )
	}
}

bool function EntityCanAcceptNewBurnDamageStack( entity ent, BurnDamageSettings burnSettings )
{
	if ( !EntityCanBurnOverTime( ent ) )
		return false

	if ( EntityHasMaxBurnDamageStacks( ent, burnSettings ) )
		return false

	// don't add another stack before it's time
	foreach ( stack in GetEntityBurnDamageStacks( ent ) )
		if ( (Time() - stack.startTime) < burnSettings.burnStackDebounce )
			return false

	return true
}

void function AddEntityBurnDamageStack( entity ent, entity owner, entity inflictor, BurnDamageSettings burnSettings )
{
	Assert( IsDoor(ent) || ent.IsPlayer() || ent.IsNPC() , "Burn damage currently only supports players, NPCs and doors." )

	BurnDamageStack stack
	stack.owner = owner
	stack.inflictor = inflictor
	stack.startTime = Time()
	stack.endTime = stack.startTime + burnSettings.burnTime
	stack.tickInterval = burnSettings.burnTickRate / burnSettings.burnTime
	int numIntervals = int( burnSettings.burnTime / stack.tickInterval )
	stack.damagePerTick = burnSettings.burnDamage / numIntervals
	stack.burnSettings = burnSettings

	if ( IsDoor(ent) )
		ent.e.burnDamageStacks.append( stack )
	else if ( ent.IsPlayer() )
		ent.p.burnDamageStacks.append( stack )
	else if ( ent.IsNPC() )
		ent.ai.burnDamageStacks.append( stack )

	#if R5DEV && DEBUG_BURN_DAMAGE
		printt( "tickInterval:", stack.tickInterval )
		printt( "numIntervals:", numIntervals )
		printt( "damagePerTick:", stack.damagePerTick )
		printt( "burn stack added, total:", GetEntityBurnDamageStackCount( ent ) )
	#endif

	if ( !EntityIsBurning( ent ) )
		thread EntityBurnDamageThread( ent )
}

void function RemoveEntityBurnDamageStack( entity ent, int stackIdx )
{
	if ( IsDoor(ent) )
		ent.e.burnDamageStacks.remove( stackIdx )
	else if ( ent.IsPlayer() )
		ent.p.burnDamageStacks.remove( stackIdx )
	else if ( ent.IsNPC() )
		ent.ai.burnDamageStacks.remove( stackIdx )

	#if R5DEV && DEBUG_BURN_DAMAGE
		printt( "burn stack removed, num stacks is now:", GetEntityBurnDamageStackCount( ent ) )
	#endif
}

void function EntityBurnDamageThread( entity ent )
{
	ent.EndSignal( "OnDeath" )

	SetEntityIsBurning( ent, true )

	OnThreadEnd(
		function () : ( ent )
		{
			#if R5DEV && DEBUG_BURN_DAMAGE
				printt( "EntityBurnDamageThread ended" )
			#endif

			if ( IsValid( ent ) )
				SetEntityIsBurning( ent, false )
		}
	)

	while ( GetEntityBurnDamageStackCount( ent ) > 0 )
	{
		array<int> removeIndices

		foreach ( idx, BurnDamageStack stack in GetEntityBurnDamageStacks( ent ) )
		{
			int dmgThisTick = 0

			if ( Time() >= stack.endTime )
			{
				// add to remove list
				removeIndices.append( idx )

				// process any remaining damage
				int remainderDmg = stack.burnSettings.burnDamage - stack.damageDealt
				if ( remainderDmg > 0 )
				{
					dmgThisTick += remainderDmg
					stack.damageDealt += remainderDmg

					#if R5DEV && DEBUG_BURN_DAMAGE
						printt( "applying", remainderDmg, "burn damage remainder, total damage dealt:", stack.damageDealt )
					#endif
				}
			}
			else if ( (Time() - stack.lastDamageTime) >= stack.tickInterval )
			{
				dmgThisTick += stack.damagePerTick
				stack.damageDealt += stack.damagePerTick
				stack.lastDamageTime = Time()

				#if R5DEV && DEBUG_BURN_DAMAGE
					printt( "applying", stack.damagePerTick, "burn damage, total damage dealt:", stack.damageDealt )
				#endif
			}

			if ( dmgThisTick > 0 )
			{
				if ( ent.IsPlayer() )
				{
					EmitSoundOnEntityOnlyToPlayer( ent, ent, stack.burnSettings.soundBurnDamageTick_1P )
				}

				ApplyBurnDamageTick( ent, dmgThisTick, stack.owner, stack.inflictor, stack.burnSettings.damageSourceID )

				// TickDamageInflictorHelper ent only allows one damage event per frame
				if ( GetBugReproNum() != 42069 )
					break
			}
		}

		// process remove list
		foreach ( idxToRemove in removeIndices )
			RemoveEntityBurnDamageStack( ent, idxToRemove )

		WaitFrame()
	}
}

void function ApplyBurnDamageTick( entity ent, int damage, entity owner, entity inflictor, int damageSourceID )
{
	ent.TakeDamage( damage, owner, inflictor, { damageSourceId = damageSourceID } )
}

bool function EntityHasMaxBurnDamageStacks( entity ent, BurnDamageSettings burnSettings )
{
	return GetEntityBurnDamageStackCount( ent ) >= burnSettings.burnStacksMax
}

array<BurnDamageStack> function GetEntityBurnDamageStacks( entity ent )
{
	if ( IsDoor(ent) )
		return ent.e.burnDamageStacks
	else if ( ent.IsPlayer() )
		return ent.p.burnDamageStacks

	return ent.ai.burnDamageStacks
}

int function GetEntityBurnDamageStackCount( entity ent )
{
	if ( !IsAlive(ent) )
		return 0

	if ( IsDoor(ent) )
		return ent.e.burnDamageStacks.len()
	else if ( ent.IsPlayer() )
		return ent.p.burnDamageStacks.len()

	return ent.ai.burnDamageStacks.len()
}

bool function EntityIsBurning( entity ent )
{
	if ( IsDoor(ent) )
		return ent.e.isBurning
	else if ( ent.IsPlayer() )
		return ent.p.isBurning

	return ent.ai.isBurning
}

void function SetEntityIsBurning( entity ent, bool isBurning )
{
	if ( IsDoor(ent) )
		ent.e.isBurning = isBurning
	else if ( ent.IsPlayer() )
		ent.p.isBurning = isBurning
	else 
		ent.ai.isBurning = isBurning
}


#if R5DEV
void function ToggleZeroingMode()
{
	if ( !GetPlayerArray().len() )
		return

	entity player = GetPlayerArray()[0]

	if ( file.inZeroingMode )
	{
		RunClientCommandOnPlayer( player, "weapon_sway 1" )
		RunClientCommandOnPlayer( player, "viewDrift 1" )
		RunClientCommandOnPlayer( player, "weaponViewKick 1" )

		file.inZeroingMode = false

		printt( "LEFT ZEROING MODE" )
	}
	else
	{
		RunClientCommandOnPlayer( player, "weapon_sway 0" )
		RunClientCommandOnPlayer( player, "viewDrift 0" )
		RunClientCommandOnPlayer( player, "weaponViewKick 0" )

		file.inZeroingMode = true

		printt( "ENTERED ZEROING MODE" )
	}
}
#endif //DEV


#endif // SERVER

int function GetMaxTrackerCountForTitan( entity titan )
{
	array<entity> primaryWeapons = titan.GetMainWeapons()
	if ( primaryWeapons.len() > 0 && IsValid( primaryWeapons[0] ) )
	{
		if ( primaryWeapons[0].HasMod( "pas_lotech_helper" ) )
			return 4
	}

	return 3
}


bool function DoesModExist( entity weapon, string modName )
{
	array<string> mods = GetWeaponMods_Global( weapon.GetWeaponClassName() )
	return mods.contains( modName )
}


bool function DoesModExistFromWeaponClassName( string weaponName, string modName )
{
	array<string> mods = GetWeaponMods_Global( weaponName )
	return mods.contains( modName )
}


bool function IsModActive( entity weapon, string modName )
{
	array<string> activeMods = weapon.GetMods()
	return activeMods.contains( modName )
}


bool function IsWeaponInSingleShotMode( entity weapon )
{
	if ( weapon.GetWeaponSettingBool( eWeaponVar.attack_button_presses_melee ) )
		return false

	if ( !weapon.GetWeaponSettingBool( eWeaponVar.is_semi_auto ) )
		return false

	return weapon.GetWeaponSettingInt( eWeaponVar.burst_fire_count ) == 0
}


bool function IsWeaponInBurstMode( entity weapon )
{
	return weapon.GetWeaponSettingInt( eWeaponVar.burst_fire_count ) > 1
}


bool function IsWeaponOffhand( entity weapon )
{
	switch( weapon.GetWeaponSettingEnum( eWeaponVar.fire_mode, eWeaponFireMode ) )
	{
		case eWeaponFireMode.offhand:
		case eWeaponFireMode.offhandInstant:
		case eWeaponFireMode.offhandHybrid:
			return true
	}
	return false
}


bool function IsWeaponInAutomaticMode( entity weapon )
{
	return !weapon.GetWeaponSettingBool( eWeaponVar.is_semi_auto )
}

bool function OnWeaponAttemptOffhandSwitch_Never( entity weapon )
{
	return false
}


#if CLIENT
void function ServerCallback_SetWeaponPreviewState( bool newState )
{
	#if R5DEV
		entity player = GetLocalClientPlayer()

		if ( newState )
		{
			printt( "Weapon Skin Preview Enabled" )
			player.ClientCommand( "bind LEFT \"WeaponPreviewPrevSkin\"" )
			player.ClientCommand( "bind RIGHT \"WeaponPreviewNextSkin\"" )
			player.ClientCommand( "bind UP \"WeaponPreviewNextCamo\"" )
			player.ClientCommand( "bind DOWN \"WeaponPreviewPrevCamo\"" )

			player.ClientCommand( "bind_held LEFT weapon_inspect" )
		}
		else
		{
			player.ClientCommand( "bind LEFT \"+ability 12\"" )
			player.ClientCommand( "bind RIGHT \"+ability 13\"" )
			player.ClientCommand( "bind UP \"+ability 10\"" )
			player.ClientCommand( "bind DOWN \"+ability 11\"" )

			SetStandardAbilityBindingsForPilot( player )
			printt( "Weapon Skin Preview Disabled" )
		}
	#endif
}
#endif

void function OnWeaponReadyToFire_ability_tactical( entity weapon )
{
	#if SERVER
		PIN_PlayerAbilityReady( weapon.GetWeaponOwner(), ABILITY_TYPE.TACTICAL )
	#endif
}

void function OnWeaponRegenEndGeneric( entity weapon )
{
	#if SERVER
	if ( !IsValid( weapon ) )
		return
	ReportOffhandWeaponRegenEnded( weapon )
	#endif
	#if CLIENT
		entity owner = weapon.GetWeaponOwner()
		if ( !IsValid( owner ) || !owner.IsPlayer() )
			return
		if ( owner.GetOffhandWeapon( OFFHAND_ULTIMATE ) == weapon )
			Chroma_UltimateReady()
	#endif
}

void function Ultimate_OnWeaponRegenBegin( entity weapon )
{
	#if CLIENT
		UltimateWeaponStateSet( eUltimateState.CHARGING )
	#endif
}


#if SERVER
void function ReportOffhandWeaponRegenEnded( entity weapon )
{
	entity owner = weapon.GetWeaponOwner()
	if ( !IsValid( owner ) || !owner.IsPlayer() )
		return

	if ( !weapon.IsWeaponOffhand() )
		return

	if ( owner.GetOffhandWeapon( OFFHAND_TACTICAL ) == weapon )
		PIN_PlayerAbilityReady( owner, ABILITY_TYPE.TACTICAL )
	else if ( owner.GetOffhandWeapon( OFFHAND_ULTIMATE ) == weapon )
		PIN_PlayerAbilityReady( owner, ABILITY_TYPE.ULTIMATE )
}
#endif
void function PlayDelayedShellEject( entity weapon, float time, int count = 1, bool persistent = false )
{
	AssertIsNewThread()

	weapon.EndSignal( "OnDestroy" )

	asset vmShell = weapon.GetWeaponSettingAsset( eWeaponVar.fx_shell_eject_view )
	asset worldShell = weapon.GetWeaponSettingAsset( eWeaponVar.fx_shell_eject_world )
	string shellAttach = weapon.GetWeaponSettingString( eWeaponVar.fx_shell_eject_attach )

	if ( shellAttach == "" )
		return

	for ( int i = 0; i < count; i++ )
	{
		wait time

		if ( !IsValid( weapon ) )
			return
		entity viewmodel = weapon.GetWeaponViewmodel()
		if ( !IsValid( viewmodel ) )
			return
		weapon.PlayWeaponEffect( vmShell, worldShell, shellAttach, persistent )
	}
}
