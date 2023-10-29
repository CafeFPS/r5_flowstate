//Ported from retail scripts by @CafeFPS

//todo
//restrict weapon usage until player is on ground again

global function MpAbilityShadowPounceFree_Init
global function OnWeaponDeactivate_shadow_pounce_free
global function OnWeaponTossPrep_shadow_pounce_free
global function OnWeaponTossCancel_shadow_pounce_free
global function OnWeaponToss_shadow_pounce_free
global function OnWeaponTossReleaseAnimEvent_shadow_pounce_free
global function OnWeaponAttemptOffhandSwitch_shadow_pounce_free
global function OnWeaponOwnerChanged_shadow_pounce_free

const string SHADOW_POUNCE_CHARGE_PREP_SOUND_1P = "Revenant_Pounce_Windup_1P"
const string SHADOW_POUNCE_LAUNCH_SOUND_1P = "revenant_pounce_launch_1p"
const string SHADOW_POUNCE_CANCEL_SOUND_1P = "Revenant_Pounce_Cancel_1P"
const string SHADOW_POUNCE_FULL_CHARGE_SOUND_1P = "Revenant_Pounce_FullyCharged_1P"

const string SHADOW_POUNCE_CHARGE_PREP_SOUND_3P = "Revenant_Pounce_Windup_3P"
const string SHADOW_POUNCE_LAUNCH_SOUND_3P = "revenant_pounce_launch_3p"
const string SHADOW_POUNCE_AIR_MOVEMENT_SOUND_3P = "Revenant_Pounce_AirborneMvmt_3p"
const string SHADOW_POUNCE_CANCEL_SOUND_3P = "Revenant_Pounce_Cancel_3P"

const asset SHADOW_POUNCE_CHARGE_START_FX_1P = $"P_rev_reborn_FP_tac_charge_hands"
const asset SHADOW_POUNCE_CHARGE_START_ARM_FX_1P = $"P_rev_reborn_FP_tac_charge_arms"
const asset SHADOW_POUNCE_CHARGE_FULL_FX_1P = $"P_rev_reborn_FP_tac_full_charge"
const asset SHADOW_POUNCE_CHARGE_IDLE_FX_1P = $"P_rev_reborn_FP_tac_Idle_hands"
const asset SHADOW_POUNCE_LAUNCH_FX_1P = $"P_rev_reborn_FP_tac_activation_hands"

const asset SHADOW_POUNCE_CHARGE_FX_3P = $"P_rev_reborn_3p_tac_charge_hands"
const asset SHADOW_POUNCE_LAUNCH_FX_3P = $"P_rev_reborn_3p_tac_activation_hands"
const asset SHADOW_POUNCE_LAUNCH_BURST_FX_3P = $"P_rev_reborn_3p_tac_activate_jump"
const asset SHADOW_POUNCE_TRAIL_FX_3P = $"P_rev_tac_jump_3P_body_trail"

const string SHADOW_POUNCE_LAUNCH_IMPACT_FX_TABLE = "shadow_pounce_launch"

const string SHADOW_POUNCE_END_CHARGE_SIGNAL = "shadow_pounce_end_charge"
const string SHADOW_POUNCE_TARGET_INDICATOR_MOD = "shadow_pounce_target_indicator"

const int MAX_IDEAL_UP_ANGLE = -15 
const int MAX_DOWN_ANGLE = 75 
const int GROUND_CHECK_START_ANGLE = 20
const int MAX_VERTICAL_PITCH_ANGLE = -80 
const int MAX_EYE_ANGLE_INCREASE = 35 
const int VELOCITY_MULTIPLIER_MIN = 700
const int VELOCITY_MULTIPLIER_MAX = 1150
const float HIGH_ANGLE_VELOCITY_DIVISOR_MAX = 1.5
const float GROUND_CHECK_TRACE_DIST = 200.0
const float MAX_FOV_LERP_OFFSET = -7.0
const float MAX_CODE_FOV = 115.0 

const float SHADOW_POUNCE_MAX_HOLD_TIME = 1.3
const vector SHADOW_POUNCE_VIEWPUNCH = < 35, -35, 5 >
const float SHADOW_POUNCE_WALL_CLIMB_DISABLE_DURATION = 0.75
const int SHADOW_POUNCE_WALL_CLIMB_ONLY_FROM_WALL = 0
const int SHADOW_POUNCE_TARGET_INDICATOR = 0
const int SHADOW_POUNCE_CHARGE_UI = 0

const int SHADOW_POUNCE_DISABLE_WEAPON_TYPES = 0 //WPT_ALL_EXCEPT_VIEWHANDS_OR_INCAP & ~WPT_TACTICAL

struct
{
	table<entity, string> cachedLastWeaponName
	table< entity, float > chargePercentage

	int pounceTargetFXHandle
	int pounceDamageRadiusFXHandle

	float maxChargeTime
	float wallClimbDisableDuration
	bool shadowPounce_TargetIndicator
	bool shadowPounce_ChargeUI
	bool wallClimbOnlyFromWall
	int maxIdealPitchAngle
	int maxVerticalPitchAngle
	int maxDownAngle
	int groundCheckStartAngle
	float groundCheckTraceDist
	int maxEyeAngleIncrease
	int minVelocityMultiplier
	int maxVelocityMultiplier
	float maxHighAngleVelocityDivisor
	float maxFovOffset
} file

global const string  REVENANT_SHADOW_POUNCE_FREE_WEAPON_NAME = "mp_ability_revenant_shadow_pounce_free"

void function MpAbilityShadowPounceFree_Init()
{
	// PrecacheParticleSystem( SHADOW_POUNCE_CHARGE_START_FX_1P )
	// PrecacheParticleSystem( SHADOW_POUNCE_CHARGE_START_ARM_FX_1P )
	// PrecacheParticleSystem( SHADOW_POUNCE_CHARGE_FULL_FX_1P )
	// PrecacheParticleSystem( SHADOW_POUNCE_CHARGE_IDLE_FX_1P )
	// PrecacheParticleSystem( SHADOW_POUNCE_LAUNCH_FX_1P )
	// PrecacheParticleSystem( SHADOW_POUNCE_CHARGE_FX_3P )
	// PrecacheParticleSystem( SHADOW_POUNCE_LAUNCH_FX_3P )
	// PrecacheParticleSystem( SHADOW_POUNCE_LAUNCH_BURST_FX_3P )
	// PrecacheParticleSystem( SHADOW_POUNCE_TRAIL_FX_3P )

	// PrecacheImpactEffectTable( SHADOW_POUNCE_LAUNCH_IMPACT_FX_TABLE )

	RegisterSignal( SHADOW_POUNCE_END_CHARGE_SIGNAL )

	
	file.maxChargeTime = GetCurrentPlaylistVarFloat( "shadow_pounce_max_charge_time", SHADOW_POUNCE_MAX_HOLD_TIME )
	file.wallClimbDisableDuration = GetCurrentPlaylistVarFloat( "shadow_pounce_wall_climb_disable_duration", SHADOW_POUNCE_WALL_CLIMB_DISABLE_DURATION )
	file.shadowPounce_TargetIndicator = ( GetCurrentPlaylistVarInt( "shadow_pounce_target_indicator", SHADOW_POUNCE_TARGET_INDICATOR ) > 0 ) ? true : false
	file.shadowPounce_ChargeUI = ( GetCurrentPlaylistVarInt( "shadow_pounce_charge_ui", SHADOW_POUNCE_CHARGE_UI ) > 0 ) ? true : false
	file.wallClimbOnlyFromWall = ( GetCurrentPlaylistVarInt( "shadow_pounce_wall_climb_from_wall", SHADOW_POUNCE_WALL_CLIMB_ONLY_FROM_WALL ) > 0 ) ? true : false

	file.maxIdealPitchAngle = GetCurrentPlaylistVarInt( "shadow_pounce_max_ideal_pitch_angle", MAX_IDEAL_UP_ANGLE )
	file.maxVerticalPitchAngle = GetCurrentPlaylistVarInt( "shadow_pounce_max_vertical_pitch_angle", MAX_VERTICAL_PITCH_ANGLE )
	file.maxDownAngle = GetCurrentPlaylistVarInt( "shadow_pounce_max_down_angle", MAX_DOWN_ANGLE )
	file.groundCheckStartAngle = GetCurrentPlaylistVarInt( "shadow_pounce_ground_check_start_angle", GROUND_CHECK_START_ANGLE )
	file.groundCheckTraceDist = GetCurrentPlaylistVarFloat( "shadow_pounce_ground_trace_dist", GROUND_CHECK_TRACE_DIST )
	file.maxEyeAngleIncrease = GetCurrentPlaylistVarInt( "shadow_pounce_max_eye_angle_increase", MAX_EYE_ANGLE_INCREASE )
	file.minVelocityMultiplier = GetCurrentPlaylistVarInt( "shadow_pounce_min_velocity_mod", VELOCITY_MULTIPLIER_MIN )
	file.maxVelocityMultiplier = GetCurrentPlaylistVarInt( "shadow_pounce_max_velocity_mod", VELOCITY_MULTIPLIER_MAX )
	file.maxHighAngleVelocityDivisor = GetCurrentPlaylistVarFloat( "shadow_pounce_max_high_angle_velocity_divisor", HIGH_ANGLE_VELOCITY_DIVISOR_MAX )
	file.maxFovOffset                = GetCurrentPlaylistVarFloat( "shadow_pounce_max_fov_offset", MAX_FOV_LERP_OFFSET )
}

bool function OnWeaponAttemptOffhandSwitch_shadow_pounce_free( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	if ( !IsValid( player ) )
		return false
	weapon.w.fromWall = player.IsWallRunning()

	entity mainHandWeapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
	if ( IsValid( mainHandWeapon) )
	{
		if ( mainHandWeapon.GetWeaponTypeFlags() & WPT_TACTICAL )
			file.cachedLastWeaponName[player] <- mainHandWeapon.GetWeaponClassName()
	}

	return true
}

void function OnWeaponDeactivate_shadow_pounce_free( entity weapon )
{
	entity weaponOwner = weapon.GetWeaponOwner()

	if ( IsValid( weaponOwner ) )
	{
		weaponOwner.Signal( SHADOW_POUNCE_END_CHARGE_SIGNAL )
	}

	#if CLIENT
		if ( !(InPrediction() && weapon.ShouldPredictProjectiles()) )
			return
	#endif

	if( !weapon.w.wasFired )
		ClearWallClimbStatusEffect( weapon )
}

void function OnWeaponOwnerChanged_shadow_pounce_free( entity weapon, WeaponOwnerChangedParams changeParams )
{

}

void function OnWeaponTossPrep_shadow_pounce_free( entity weapon, WeaponTossPrepParams prepParams )
{
	//printt( "preparing launch")
	entity player = weapon.GetWeaponOwner()
	Assert( player.IsPlayer() )

	#if CLIENT
		if ( !(InPrediction() && weapon.ShouldPredictProjectiles()) )
			return
	#endif

	player.Signal( SHADOW_POUNCE_END_CHARGE_SIGNAL )
	weapon.w.wasFired = false
	ClearWallClimbStatusEffect( weapon )

	weapon.w.startChargeTime = Time() + weapon.GetWeaponSettingFloat( eWeaponVar.toss_pullout_time )
	if( !file.wallClimbOnlyFromWall || weapon.w.fromWall )
	{
		int wallClimbID = StatusEffect_AddEndless( player, eStatusEffect.disable_wall_run_and_double_jump, 1.0 )
		weapon.w.statusEffects.append( wallClimbID )
	}

	#if CLIENT
		// if( file.shadowPounce_ChargeUI )
			// thread ShadowPounce_ChargeUI_Thread( player, weapon )
		// if( file.shadowPounce_TargetIndicator )
			// thread ShadowPounce_UpdateIndicator( player, weapon )
		// if( file.maxFovOffset != 0.0 )
			// thread ShadowPounce_ChargeFov_Thread( player, weapon )
	#endif

}

var function OnWeaponTossCancel_shadow_pounce_free( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	//8 lines
	return 0
}

var function OnWeaponToss_shadow_pounce_free( entity weapon, WeaponPrimaryAttackParams attackParams )
{	
	entity player = weapon.GetWeaponOwner()

	if( player in file.chargePercentage )
		file.chargePercentage[player] = Clamp( (Time() - weapon.w.startChargeTime ) / file.maxChargeTime, 0.25, 1.0 )
	else
		file.chargePercentage[player] <- Clamp( (Time() - weapon.w.startChargeTime ) / file.maxChargeTime, 0.25, 1.0 )
	
	if( player in file.chargePercentage )
		printt( "launch tactical charge: " + file.chargePercentage[player] )

	player.Signal( SHADOW_POUNCE_END_CHARGE_SIGNAL )
}

var function OnWeaponTossReleaseAnimEvent_shadow_pounce_free( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity player = weapon.GetWeaponOwner()

	#if CLIENT
		if ( !(InPrediction() && weapon.ShouldPredictProjectiles()) )
			return 0
	#endif

	player.Signal( SHADOW_POUNCE_END_CHARGE_SIGNAL )
	thread ClearWallClimbStatusEffectAfterDelay_Thread( player, weapon )

	ShadowPounce_LaunchPlayer( player, weapon.w.startChargeTime  )
	weapon.w.wasFired = true

	// 9 lines

	PlayerUsedOffhand( player, weapon )

	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
}

void function ShadowPounce_LaunchPlayer( entity player, float startTime )
{
	if( !IsValid( player ) )
		return

	#if SERVER
		vector launchVelocity = ShadowPounce_CalcLaunchVelocity( player, startTime )

		printt("launch velocity is:", launchVelocity)

		// player.ViewPunch( player.EyePosition(), SHADOW_POUNCE_VIEWPUNCH.x, SHADOW_POUNCE_VIEWPUNCH.y, SHADOW_POUNCE_VIEWPUNCH.z )
		player.SetVelocity( player.GetVelocity() + launchVelocity )
	#endif

	#if CLIENT
		EmitSoundOnEntity( player, SHADOW_POUNCE_LAUNCH_SOUND_1P )
	#endif
}

vector function ShadowPounce_CalcLaunchVelocity( entity player, float startTime )
{
	vector launchVelocity = ZERO_VECTOR
	if( !IsValid( player ) )
		return launchVelocity

	vector eyeAngles = player.EyeAngles()
	float pitch = eyeAngles.x

	vector modifiedEyeAngles = eyeAngles

	if( pitch >= file.groundCheckStartAngle )
	{
		printt( "checking ground trace" )
		vector traceEnd   = player.EyePosition() + ( AnglesToForward( eyeAngles ) * file.groundCheckTraceDist )
		TraceResults groundTrace = TraceLine( player.EyePosition(), traceEnd, player, TRACE_MASK_SOLID )

		if( IsValid( groundTrace.hitEnt ) )
			pitch = float( file.groundCheckStartAngle )
	}
	
	if( pitch == clamp( pitch, file.maxIdealPitchAngle, file.maxDownAngle ) )
	{
		float modifiedPitch = pitch - file.maxEyeAngleIncrease 
		modifiedEyeAngles = < modifiedPitch, eyeAngles.y, eyeAngles.z >
	}
	
	else if( pitch < file.maxIdealPitchAngle )
	{
		float modifiedPitch = pitch - GraphCapped( pitch, file.maxIdealPitchAngle, file.maxVerticalPitchAngle, file.maxEyeAngleIncrease, 0 )
		modifiedEyeAngles = < modifiedPitch, eyeAngles.y, eyeAngles.z >
	}

	float chargePercentage = 0.0
	if( player in file.chargePercentage )
		chargePercentage = file.chargePercentage[player]

	float velocity = file.minVelocityMultiplier + ( ( file.maxVelocityMultiplier - file.minVelocityMultiplier ) * chargePercentage ) 

	
	float modifiedVelocity = velocity
	if( file.maxIdealPitchAngle >= pitch )
	{
		modifiedVelocity = velocity / GraphCapped( pitch, file.maxIdealPitchAngle, file.maxVerticalPitchAngle, 1.0, file.maxHighAngleVelocityDivisor )
	}

	launchVelocity = AnglesToForward( modifiedEyeAngles ) * modifiedVelocity

	return launchVelocity
}

void function ClearWallClimbStatusEffect( entity weapon )
{
	if( !IsValid( weapon ) )
		return

	#if CLIENT
		if ( !(InPrediction() && weapon.ShouldPredictProjectiles()) )
			return
	#endif

	entity weaponOwner = weapon.GetWeaponOwner()
	if ( IsValid( weaponOwner ) )
	{
		weaponOwner.Signal( SHADOW_POUNCE_END_CHARGE_SIGNAL )
		foreach( effect in weapon.w.statusEffects )
			StatusEffect_Stop( weaponOwner, effect )
	}

	weapon.w.statusEffects.clear()
}

void function ClearWallClimbStatusEffectAfterDelay_Thread( entity player, entity weapon )
{
	Assert( IsNewThread(), "Must be threaded off" )
	EndSignal( player, "OnDeath", "OnDestroy", "BleedOut_OnStartDying" )

	OnThreadEnd(
		function() : ( weapon )
		{
			ClearWallClimbStatusEffect( weapon )


		}
	)

	wait file.wallClimbDisableDuration
}

//250 lines

// void function ShadowPounce_ChargeUI_Thread( entity player, entity weapon )
// {
	// Assert( IsNewThread(), "Must be threaded off" )
	// if( !IsValid( player ) )
		// return

	// EndSignal( player, "OnDeath", "OnDestroy", "BleedOut_OnStartDying", SHADOW_POUNCE_END_CHARGE_SIGNAL )

	// var rui = CreateFullscreenRui( $"ui/shadow_pounce_charge_indicator.rpak", HUD_Z_BASE )

	// RuiSetGameTime( rui, "startTime", Time() )

	// OnThreadEnd(
		// function() : ( rui )
		// {
			// RuiDestroyIfAlive( rui )
		// }
	// )

	// while( true )
	// {
		// float chargeTime = clamp( Time() - weapon.w.startChargeTime, 0.0, file.maxChargeTime )
		// float chargeFrac = chargeTime/file.maxChargeTime
		// RuiSetFloat( rui, "chargeFrac", chargeFrac )
		// WaitFrame()
	// }
// }

// void function ShadowPounce_ChargeFov_Thread( entity player, entity weapon )
// {
	// Assert( IsNewThread(), "Must be threaded off" )
	// if( !IsValid( player ) )
		// return

	// EndSignal( player, "OnDeath", "OnDestroy", "BleedOut_OnStartDying", SHADOW_POUNCE_END_CHARGE_SIGNAL )

	// float maxFovOffset = min( MAX_CODE_FOV - player.GetFOV(), file.maxFovOffset )

	// OnThreadEnd( function() : ( player, weapon, maxFovOffset ) {
		// if ( IsValid( player ) )
		// {
			// if( IsAlive( player ) && IsValid( weapon ) )
			// {
				// float chargeTime = clamp( Time() - weapon.w.startChargeTime, 0.0, file.maxChargeTime )
				// float chargeFrac = chargeTime/file.maxChargeTime
				// thread ShadowPounce_LerpOutFov_Thread( player, chargeFrac, maxFovOffset )
			// }
			// else
			// {
				// player.SetFOVOffset( 0.0 )
			// }
		// }
	// } )

	// while( true )
	// {
		// float chargeTime = clamp( Time() - weapon.w.startChargeTime, 0.0, file.maxChargeTime )
		// float chargeFrac = chargeTime/file.maxChargeTime
		// player.SetFOVOffset( chargeFrac * maxFovOffset )
		// WaitFrame()
	// }
// }

// void function ShadowPounce_LerpOutFov_Thread( entity player, float initialOffsetFrac, float maxOffset )
// {
	// EndSignal( player, "OnDeath", "OnDestroy" )

	// OnThreadEnd( function() : ( player ) {
		// if ( IsValid( player ) )
		// {
			// player.SetFOVOffset( 0.0 )
		// }
	// } )

	// float initialTime = Time()
	// float curOffsetFrac = initialOffsetFrac
	// while( curOffsetFrac > 0 )
	// {
		// float progress = ( Time() - initialTime ) / 0.2
		// curOffsetFrac = LerpFloat( initialOffsetFrac, 0, progress )
		// player.SetFOVOffset( curOffsetFrac * maxOffset )
		// WaitFrame()
	// }
// }

// void function ShadowPounce_UpdateIndicator( entity player, entity weapon )
// {
	// EndSignal( player, SHADOW_POUNCE_END_CHARGE_SIGNAL )
	// EndSignal( weapon, "OnDestroy" )

	// OnThreadEnd( function() : ( weapon ) {
		// if ( IsValid( weapon ) )
		// {
			// weapon.ClearIndicatorEffectOverrides()
		// }
	// } )

	// while( true )
	// {
		// vector vel = ShadowPounce_CalcLaunchVelocity( player, weapon.w.startChargeTime )
		// weapon.SetIndicatorEffectVelocityOverride( vel )
		// WaitFrame()
	// }
// }