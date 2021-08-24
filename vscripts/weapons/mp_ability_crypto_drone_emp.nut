#if(true)//

//
//
//

//

global function MpAbilityCryptoDroneEMP_Init
global function OnWeaponAttemptOffhandSwitch_ability_crypto_drone_emp
global function OnWeaponPrimaryAttack_ability_crypto_drone_emp
#if SERVER
global function DroneFireEMP
#endif

const asset AREA_SCAN_ACTIVATION_SCREEN_FX = $"P_sonar"
const asset EMP_CHARGE_UP_FX = $"P_emp_chargeup"
const CAMERA_EMP_EXPLOSION = "exp_drone_emp"
const asset FX_EMP_BODY_HUMAN = $"P_emp_body_human"
const asset FX_EMP_SUPPORT_FX = $"P_emp_explosion"
const int MAX_SHIELD_DAMAGE = 50
const asset EMP_WARNING_FX_SCREEN = $"P_emp_screen_player"
const asset EMP_WARNING_FX_3P = $"P_emp_body_human"
const asset EMP_WARNING_FX_GROUND = $"P_emp_body_human"
const asset EMP_RADIUS_FX = $"P_emp_charge_radius_MDL"

const float EMP_TIME_TO_DETONATE = 2.6	// guessed + video ref
const float EMP_RADIUS = 1024	// guessed

//
const string EMP_CHARGING_3P = "Char11_UltimateA_A_3p"
const string EMP_CHARGING_CRYPTO_3P = "Char11_UltimateA_A_3p"
const string EMP_CHARGING_1P = "Char11_UltimateA_A"

struct
{
	#if CLIENT
	int colorCorrection
	int screenFxHandle
	#endif //
} file

void function MpAbilityCryptoDroneEMP_Init()
{
	PrecacheParticleSystem( EMP_CHARGE_UP_FX )
	PrecacheParticleSystem( FX_EMP_SUPPORT_FX )
	PrecacheImpactEffectTable( CAMERA_EMP_EXPLOSION )
	PrecacheParticleSystem( FX_EMP_BODY_HUMAN )
	PrecacheParticleSystem( EMP_WARNING_FX_SCREEN )
	PrecacheParticleSystem( EMP_WARNING_FX_3P )
	PrecacheParticleSystem( EMP_RADIUS_FX )
	RegisterSignal( "Emp_Detonated" )
	RegisterSignal( "EMP_Destroy" )
	#if CLIENT
		RegisterSignal( "EndEMPWarningFX" )
		StatusEffect_RegisterEnabledCallback( eStatusEffect.crypto_emp_warning, EMPWarningVisualsEnabled)
		StatusEffect_RegisterDisabledCallback( eStatusEffect.crypto_emp_warning, EMPWarningVisualsDisabled )
	#endif

	#if SERVER
		AddDamageCallbackSourceID( eDamageSourceId.mp_ability_crypto_drone_emp, DroneEMP_HandleDamageSource )
	#endif
}

#if SERVER

void function DroneEMP_HandleDamageSource( entity target, var damageInfo )
{
	float duration = 2.0

	StatusEffect_AddTimed( target, eStatusEffect.move_slow, 1.0, duration, duration )
	StatusEffect_AddTimed( target, eStatusEffect.turn_slow, 1.0, duration, duration )
	StatusEffect_AddTimed( target, eStatusEffect.emp, 1.0, duration, duration )
}

void function DroneFireEMP( entity weapon )
{
	entity owner = weapon.GetWeaponOwner()
	entity camera = GetPlayerCamera( owner )
	
	// Shouldn't have happened, give their ult charge back!
	if( !IsValid( camera ) )
	{
		weapon.SetWeaponPrimaryClipCount( weapon.GetWeaponPrimaryClipCountMax() )
		return
	}

	PlayBattleChatterLineToSpeakerAndTeam( owner, "bc_super" )

	
	// TODO: Fix particles not displaying correctly, glow shows from chargeFX, radius doesn't seem to do anything
	// Likely params for them are missing, need to check inside the .pcf

	entity chargeFX = StartParticleEffectOnEntity_ReturnEntity( camera, GetParticleSystemIndex( EMP_CHARGE_UP_FX ), FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
	SetTeam( chargeFX, camera.GetTeam() )

//	entity radiusFX = StartParticleEffectOnEntity_ReturnEntity( camera, GetParticleSystemIndex( EMP_RADIUS_FX ), FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
//	SetTeam( radiusFX, camera.GetTeam() )

	// - - -

	camera.Anim_Play( "drone_EMP" )

	EmitSoundOnEntity( camera, EMP_CHARGING_3P )

	thread DroneFireEMP_Thread( weapon, camera )
}

void function DroneFireEMP_Thread( entity weapon, entity camera )
{
	wait EMP_TIME_TO_DETONATE

	// Drone destroyed or user dead / weapon removed -> don't explode
	if( !IsValid(camera) || !IsValid(weapon))
		return

	entity owner = camera.GetOwner()
	vector pos = camera.GetOrigin()

	StartParticleEffectOnEntity( camera, GetParticleSystemIndex( FX_EMP_SUPPORT_FX ), FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
	/*Sound*/ PlayImpactFXTable( pos, owner, CAMERA_EMP_EXPLOSION )

	foreach(entity target in GetPlayersNpcsInRadius(pos, EMP_RADIUS))
	{
		target.TakeDamage( MAX_SHIELD_DAMAGE, owner, weapon, 
		{ 
			scriptType = DF_SHIELD_DAMAGE, 
			damageSourceId = eDamageSourceId.mp_ability_crypto_drone_emp 
		})
	}
	
	camera.Anim_Play( "drone_active_twitch" )
}
array<entity> function GetPlayersNpcsInRadius(vector origin, float radius)
{
	array<entity> targets = GetNPCArray()
	targets.extend(GetPlayerArray())

	array<entity> validTargets = []
	foreach(entity target in targets)
	{
		if( !IsValid( target ) || !IsAlive( target ) )
			continue

		if( Distance( target.GetOrigin(), origin ) < radius )
			validTargets.append( target )
	}
	return validTargets
}
#endif


bool function OnWeaponAttemptOffhandSwitch_ability_crypto_drone_emp( entity weapon )
{
	int ammoReq = weapon.GetAmmoPerShot()
	int currAmmo = weapon.GetWeaponPrimaryClipCount()
	if ( currAmmo < ammoReq )
		return false

	entity player = weapon.GetWeaponOwner()
	if ( player.IsPhaseShifted() )
		return false

	if ( StatusEffect_GetSeverity( player, eStatusEffect.crypto_has_camera ) == 0.0 )
	{
		#if CLIENT
		AddPlayerHint( 1.0, 0.25, $"rui/hud/tactical_icons/tactical_crypto", "#CRYPTO_ULTIMATE_CAMERA_NOT_READY" )
		#endif
		return false
	}

	if ( StatusEffect_GetSeverity( player, eStatusEffect.crypto_camera_is_recalling ) > 0.0 )
	{
		//
		return false
	}

	return true
}

var function OnWeaponPrimaryAttack_ability_crypto_drone_emp( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity weaponOwner = weapon.GetWeaponOwner()
	if ( StatusEffect_GetSeverity( weaponOwner, eStatusEffect.crypto_has_camera ) == 0.0 )
		return 0

#if SERVER
	DroneFireEMP( weapon )
#endif

	PlayerUsedOffhand( weaponOwner, weapon )

	int ammoReq = weapon.GetAmmoPerShot()
	return ammoReq
}

#if SERVER




//



//





//


















//





















//































































































#endif
/*

























































*/

#if CLIENT

void function EMPWarningVisualsEnabled( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( ent != GetLocalViewPlayer() )
		return

	entity player = ent

	entity cockpit = player.GetCockpit()
	if ( !IsValid( cockpit ) )
		return

	thread EMPWarningFXThink( player, cockpit )
}

void function EMPWarningVisualsDisabled( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( ent != GetLocalViewPlayer() )
		return

	ent.Signal( "EndEMPWarningFX" )
}

void function EMPWarningFXThink( entity player, entity cockpit )
{
	player.EndSignal( "OnDeath" )
	cockpit.EndSignal( "OnDestroy" )

	int fxHandle = StartParticleEffectOnEntity( cockpit, GetParticleSystemIndex( EMP_WARNING_FX_SCREEN ), FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
	EffectSetIsWithCockpit( fxHandle, true )
	EmitSoundOnEntity( player, "Wattson_Ultimate_G" )
	vector controlPoint = <1,1,1>
	EffectSetControlPointVector( fxHandle, 1, controlPoint )

	//
	int fxHandleGround = StartParticleEffectOnEntity( player, GetParticleSystemIndex( EMP_WARNING_FX_GROUND ), FX_PATTACH_ABSORIGIN_FOLLOW, -1 )

	player.WaitSignal( "EndEMPWarningFX" )

	if ( EffectDoesExist( fxHandle ) )
		EffectStop( fxHandle, true, false )

	if ( EffectDoesExist( fxHandleGround ) )
		EffectStop( fxHandleGround, true, false )
}
#endif //

#endif //