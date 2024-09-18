global function MpWeaponIncapShield_Init

global function OnWeaponChargeBegin_weapon_incap_shield
global function OnWeaponChargeEnd_weapon_incap_shield
global function OnWeaponOwnerChanged_weapon_incap_shield
global function OnWeaponPrimaryAttack_incap_shield
global function OnWeaponPrimaryAttackAnimEvent_incap_shield
global function OnWeaponActivate_incap_shield
global function OnWeaponDeactivate_incap_shield

#if CLIENT
global function OnCreateChargeEffect_incap_shield
#endif // #if CLIENT

// R5DEV-177545 - Persist the CPropShield entity instead of creating/destroying it on charge begin/end
const bool INCAP_SHIELD_PERSIST_LOGIC = true
const bool INCAP_SHIELD_DEBUG = false

const float INCAP_SHIELD_MOVE_SLOW_SEVERITY = 0.55

const INCAP_SHIELD_FX_WALL_FP = $"P_down_shield_CP" //$"P_gun_shield_gibraltar_3P"
const INCAP_SHIELD_FX_WALL = $"P_down_shield_CP" //$"P_gun_shield_gibraltar_3P"
const INCAP_SHIELD_FX_COL = $"mdl/fx/down_shield_01.rmdl" //$"mdl/fx/gibralter_gun_shield.rmdl"
const INCAP_SHIELD_FX_BREAK = $"P_down_shield_break_CP"

const string SOUND_PILOT_INCAP_SHIELD_3P = "BleedOut_Shield_Sustain_3p"
const string SOUND_PILOT_INCAP_SHIELD_1P = "BleedOut_Shield_Sustain_1p"

const string SOUND_PILOT_INCAP_SHIELD_END_3P = "BleedOut_Shield_Break_3P"
const string SOUND_PILOT_INCAP_SHIELD_END_1P = "BleedOut_Shield_Break_1P"


struct
{
} file

// =================================================================================================================================
// =================================================================================================================================
// =================================================================================================================================
// =================================================================================================================================
//
//   ######  ##     ##    ###    ########  ######## ########
//  ##    ## ##     ##   ## ##   ##     ## ##       ##     ##
//  ##       ##     ##  ##   ##  ##     ## ##       ##     ##
//   ######  ######### ##     ## ########  ######   ##     ##
//        ## ##     ## ######### ##   ##   ##       ##     ##
//  ##    ## ##     ## ##     ## ##    ##  ##       ##     ##
//   ######  ##     ## ##     ## ##     ## ######## ########
//
// =================================================================================================================================
// =================================================================================================================================
// =================================================================================================================================
// =================================================================================================================================

void function MpWeaponIncapShield_Init()
{
	PrecacheModel( INCAP_SHIELD_FX_COL )

	PrecacheParticleSystem( INCAP_SHIELD_FX_WALL_FP )
	PrecacheParticleSystem( INCAP_SHIELD_FX_WALL )
	PrecacheParticleSystem( INCAP_SHIELD_FX_BREAK )

	RegisterSignal( "IncapShieldBeginCharge" )

}


#if CLIENT
void function OnCreateChargeEffect_incap_shield( entity weapon, int fxHandle )
{
	int shieldEnergy = weapon.GetScriptInt0()
	if ( shieldEnergy <= 0 )
	{
		weapon.StopWeaponEffect( INCAP_SHIELD_FX_WALL_FP, INCAP_SHIELD_FX_WALL_FP )
		return
	}

	thread UpdateFirstPersonIncapShieldColor_Thread( weapon, fxHandle, INCAP_SHIELD_FX_WALL_FP )
}
#endif // #if CLIENT

// =================================================================================================================================
// =================================================================================================================================
// =================================================================================================================================
// =================================================================================================================================
//
//   #######  ########  ####  ######   #### ##    ##    ###    ##          ##        #######   ######   ####  ######
//  ##     ## ##     ##  ##  ##    ##   ##  ###   ##   ## ##   ##          ##       ##     ## ##    ##   ##  ##    ##
//  ##     ## ##     ##  ##  ##         ##  ####  ##  ##   ##  ##          ##       ##     ## ##         ##  ##
//  ##     ## ########   ##  ##   ####  ##  ## ## ## ##     ## ##          ##       ##     ## ##   ####  ##  ##
//  ##     ## ##   ##    ##  ##    ##   ##  ##  #### ######### ##          ##       ##     ## ##    ##   ##  ##
//  ##     ## ##    ##   ##  ##    ##   ##  ##   ### ##     ## ##          ##       ##     ## ##    ##   ##  ##    ##
//   #######  ##     ## ####  ######   #### ##    ## ##     ## ########    ########  #######   ######   ####  ######
//
// =================================================================================================================================
// =================================================================================================================================
// =================================================================================================================================
// =================================================================================================================================

#if !INCAP_SHIELD_PERSIST_LOGIC
bool function OnWeaponChargeBegin_weapon_incap_shield( entity weapon )
{
	entity player = weapon.GetWeaponOwner()

	if ( player.IsPlayer() )
	{
#if SERVER
		PIN_PlayerUse( player, weapon.GetWeaponClassName(), "INCAP_SHIELD" )

		if( !IsValid( weapon.GetWeaponUtilityEntity() ) && !Bleedout_IsReceivingFirstAid( player ) && weapon.GetScriptInt0() > 0 )
			CreateIncapShield( player, weapon )
#endif // #if SERVER
	}

	return true
}

void function OnWeaponChargeEnd_weapon_incap_shield( entity weapon )
{
	weapon.Signal( "OnChargeEnd" )

	foreach( effect in weapon.w.statusEffects )
		StatusEffect_Stop( weapon.GetWeaponOwner(), effect )
}

void function OnWeaponOwnerChanged_weapon_incap_shield( entity weapon, WeaponOwnerChangedParams changeParams )
{
	entity newOwner = weapon.GetWeaponOwner()
	entity oldOwner = changeParams.oldOwner

#if SERVER
	if ( !IsValid( newOwner ) )
		weapon.Destroy()
	else
		weapon.SetScriptInt0( IncapShield_GetMaxShieldHealthFromTier( IncapShield_GetShieldTier( newOwner ) ))
#endif // #if SERVER
}

var function OnWeaponPrimaryAttack_incap_shield( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return 0
}

var function OnWeaponPrimaryAttackAnimEvent_incap_shield( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return 0
}

void function OnWeaponActivate_incap_shield( entity weapon )
{
}

void function OnWeaponDeactivate_incap_shield( entity weapon )
{
}

#if SERVER
void function CreateIncapShield( entity player, entity weapon )
{
	thread IncapShieldThink( player, weapon )
	weapon.w.statusEffects.append( StatusEffect_AddEndless( weapon.GetWeaponOwner(), eStatusEffect.move_slow, INCAP_SHIELD_MOVE_SLOW_SEVERITY ) )
}

void function IncapShieldThink( entity player, entity vortexWeapon )
{
	player.EndSignal( "BleedOut_OnReviveStart" )
	vortexWeapon.EndSignal( "OnChargeEnd" )
	vortexWeapon.EndSignal( "OnDestroy" )

	while( true )
	{
		entity utilityEnt = vortexWeapon.GetWeaponUtilityEntity()
		if ( !IsValid( utilityEnt ) )
		{
			if ( vortexWeapon.GetScriptInt0() > 0  )
				thread IncapShieldThread( player, vortexWeapon )
		}
		else
		{
			UpdateIncapShieldFX( utilityEnt, GetShieldHealthFraction( utilityEnt ) )
		}

		WaitFrame()
	}
}

void function IncapShieldThread( entity player, entity weapon )
{
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "BleedOut_OnReviveStart" )
	weapon.EndSignal( "OnDestroy" )
	weapon.EndSignal( "OnChargeEnd" )

	entity shieldEnt = CreateIncapShieldEntity( player, weapon )

	//DEFENSIVE FIX FOR R5DEV-79438
	Assert( shieldEnt.GetMaxHealth() >= weapon.GetScriptInt0(), format("KO Shield attempting to set health to %i when max is %i", weapon.GetScriptInt0(), shieldEnt.GetMaxHealth()) )

	shieldEnt.SetHealth( weapon.GetScriptInt0() )
	shieldEnt.EndSignal( "OnDestroy" )
	weapon.SetWeaponUtilityEntity( shieldEnt )

	UpdateIncapShieldFX( shieldEnt, GetShieldHealthFraction( shieldEnt ) )

	EmitSoundOnEntityExceptToPlayer( player, player, SOUND_PILOT_INCAP_SHIELD_3P )
	EmitSoundOnEntityOnlyToPlayer( player, player, SOUND_PILOT_INCAP_SHIELD_1P )

	OnThreadEnd(
		function () : ( shieldEnt, weapon, player )
		{
			if ( IsValid( player ) )
			{
				StopSoundOnEntity( player, SOUND_PILOT_INCAP_SHIELD_1P )
				StopSoundOnEntity( player, SOUND_PILOT_INCAP_SHIELD_3P )
			}

			if ( IsValid( shieldEnt ) )
			{
				if ( IsValid( shieldEnt.e.shieldWallFX ) )
					EffectStop( shieldEnt.e.shieldWallFX )
				foreach ( fx in shieldEnt.e.fxControlPoints )
					EffectStop( fx )

				weapon.SetScriptInt0( shieldEnt.GetHealth() )
				shieldEnt.Destroy()
			}

			weapon.SetWeaponUtilityEntity( null )
		}
	)

	AddEntityCallback_OnPostDamaged( shieldEnt, IncapShield_OnDamaged )
	WaitForever()
}

void function IncapShield_OnDamaged( entity ent, var damageInfo )
{
	float damage = DamageInfo_GetDamage( damageInfo )
	entity attacker = DamageInfo_GetAttacker( damageInfo )
	vector damageOrigin = DamageInfo_GetDamagePosition( damageInfo )

	if ( damage > 0 )
	{
		if ( attacker.GetTeam() == ent.GetTeam() )
			DamageInfo_SetDamage( damageInfo, 0 )
	}

	damage = DamageInfo_GetDamage( damageInfo )
	if ( damage > 0 )
	{
		if ( IsValid( attacker ) && attacker.IsPlayer() )
			attacker.NotifyDidDamage( ent, 0, damageOrigin, 0, damage, DF_NO_HITBEEP | DAMAGEFLAG_VICTIM_HAS_VORTEX, 0, null, 0 )

		ent.SetHealth( maxint( 0, ent.GetHealth()-int( damage ) ) )

		entity player = ent.GetOwner()
		if ( IsValid( player ) )
		{
			UpdateIncapShieldFX( ent, GetShieldHealthFraction( ent ) )
			player.ViewPunch( damageOrigin, 2.0, 1.0, 1.0 )
		}

		entity weapon = ent.e.ownerWeapon
		if ( IsValid( weapon ) )
			weapon.SetScriptInt0( ent.GetHealth() )

		if ( IsValid( player ) )
		{
			if ( ent.GetHealth() <= 0 )
			{
				weapon.SetScriptInt0( 0 )
				weapon.SetWeaponPrimaryAmmoCount( AMMOSOURCE_STOCKPILE, 0 )
				entity fx = StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( INCAP_SHIELD_FX_BREAK ), player.GetAttachmentOrigin( player.LookupAttachment( "PROPGUN" )), player.GetAttachmentAngles( player.LookupAttachment( "PROPGUN" )) )
				EffectSetControlPointVector( fx, 2, GetIncapShieldTriLerpColor( 1.0, IncapShield_GetShieldTier( player ) ) )
				EmitSoundOnEntityExceptToPlayer( player, player, SOUND_PILOT_INCAP_SHIELD_END_3P )
				EmitSoundOnEntityOnlyToPlayer( player, player, SOUND_PILOT_INCAP_SHIELD_END_1P )
				ent.Destroy()
			}
		}
	}
}

entity function CreateIncapShieldEntity( entity player, entity weapon )
{
	GunShieldSettings gs
	gs.invulnerable = false
	gs.maxHealth = float( IncapShield_GetMaxShieldHealthFromTier( IncapShield_GetShieldTier( player ) ) )

	//DEFENSIVE FIX FOR R5DEV-79438
	if ( gs.maxHealth < weapon.GetScriptInt0() )
		gs.maxHealth = float( weapon.GetScriptInt0() )

	gs.impacteffectcolorID = IncapShield_GetShieldImpactColorID( player )
	gs.ownerWeapon = weapon
	gs.owner = player
	gs.shieldFX = INCAP_SHIELD_FX_WALL
	gs.parentEnt = player
	gs.parentAttachment = "PROPGUN"
	gs.useFriendlyEnemyFx = false
	gs.useFxColorOverride = true
	gs.fxColorOverride = GetIncapShieldColorFromInventory( player )
	gs.model = INCAP_SHIELD_FX_COL
	gs.modelHide = true
	gs.modelOverrideAngles = <91, 0, 0>
	gs.fxOverrideAngles = <1, 180, 0>

	entity shieldEnt = CreateGunAttachedShield_PropShield( gs )
	return shieldEnt
}

float function GetShieldHealthFraction( entity shieldEnt )
{
	float currentHealth = float( shieldEnt.GetHealth() )
	float maxHealth = float( shieldEnt.GetMaxHealth() )

	return currentHealth / maxHealth
}
#endif // #if SERVER
#endif // #if !INCAP_SHIELD_PERSIST_LOGIC

// =================================================================================================================================
// =================================================================================================================================
// =================================================================================================================================
// =================================================================================================================================
//
//  ########  ######## ########   ######  ####  ######  ########    ##        #######   ######   ####  ######
//  ##     ## ##       ##     ## ##    ##  ##  ##    ##    ##       ##       ##     ## ##    ##   ##  ##    ##
//  ##     ## ##       ##     ## ##        ##  ##          ##       ##       ##     ## ##         ##  ##
//  ########  ######   ########   ######   ##   ######     ##       ##       ##     ## ##   ####  ##  ##
//  ##        ##       ##   ##         ##  ##        ##    ##       ##       ##     ## ##    ##   ##  ##
//  ##        ##       ##    ##  ##    ##  ##  ##    ##    ##       ##       ##     ## ##    ##   ##  ##    ##
//  ##        ######## ##     ##  ######  ####  ######     ##       ########  #######   ######   ####  ######
//
// =================================================================================================================================
// =================================================================================================================================
// =================================================================================================================================
// =================================================================================================================================

#if INCAP_SHIELD_PERSIST_LOGIC

var function OnWeaponPrimaryAttack_incap_shield( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return 0
}

var function OnWeaponPrimaryAttackAnimEvent_incap_shield( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return 0
}

void function OnWeaponOwnerChanged_weapon_incap_shield( entity weapon, WeaponOwnerChangedParams changeParams )
{
#if SERVER
	entity newOwner = weapon.GetWeaponOwner()
	if ( IsValid( newOwner ) )
		weapon.SetScriptInt0( IncapShield_GetMaxShieldHealthFromTier( IncapShield_GetShieldTier( newOwner ) ))
	else
		weapon.Destroy()
#endif // #if SERVER
}

void function OnWeaponActivate_incap_shield( entity weapon )
{
#if SERVER
	entity oldShieldEnt = weapon.GetWeaponUtilityEntity()
	if ( IsValid( oldShieldEnt ) )
	{
		// Remove any stale CShieldProp entity
		oldShieldEnt.Destroy()
		weapon.SetWeaponUtilityEntity( null )
	}

	entity weaponOwner = weapon.GetWeaponOwner()
	if ( !weaponOwner.IsPlayer() )
		return

	// if ( PlayerHasPassive( weaponOwner, ePassives.PAS_AXIOM ) )
	// {
		// int maxReviveShieldHealth = ReviveShield_GetMaxShieldHealthFromTier( IncapShield_GetShieldTier( weaponOwner ), weaponOwner )
		// int maxIncapShieldHealth = IncapShield_GetMaxShieldHealthFromTier( IncapShield_GetShieldTier( weaponOwner ) )

		// int healthDiff = maxIncapShieldHealth - maxReviveShieldHealth
		// if( healthDiff < 0 )
			// healthDiff = 0

		// weapon.SetScriptInt0( PassiveAxiom_GetAxiomKDShieldHealth( weaponOwner ) + healthDiff )
	// }

	float shieldMaxHealth = float( IncapShield_GetMaxShieldHealthFromTier( IncapShield_GetShieldTier( weaponOwner ) ) )
	if ( shieldMaxHealth <= 0 )
	{
		if ( INCAP_SHIELD_DEBUG )
			printt( "IncapShield_Activate     NO MAX ENERGY for", weaponOwner )
			
		return
	}
	
	int shieldEnergy = weapon.GetScriptInt0()
	if ( shieldEnergy <= 0 )
	{
		if ( INCAP_SHIELD_DEBUG )
			printt( "IncapShield_Activate     NO ENERGY LEFT for", weaponOwner )

		return
	}

	GunShieldSettings gs
	gs.invulnerable			= false
	gs.maxHealth			= shieldMaxHealth
	gs.impacteffectcolorID	= IncapShield_GetShieldImpactColorID( weaponOwner )
	gs.ownerWeapon			= weapon
	gs.owner				= weaponOwner
	gs.parentEnt			= weaponOwner
	gs.parentAttachment		= "PROPGUN"
	gs.model				= INCAP_SHIELD_FX_COL
	gs.modelHide			= true
	gs.modelOverrideAngles	= <91, 0, 0>

	entity shieldEnt = CreateGunAttachedShield_PropShield( gs )

	shieldEnergy = minint( shieldEnergy, shieldEnt.GetMaxHealth() )
	shieldEnt.SetHealth( shieldEnergy )

	if ( INCAP_SHIELD_DEBUG )
		printt( "IncapShield_Activate    ", shieldEnergy, "energy for", shieldEnt )

	IncapShield_SetShieldEntCollision( shieldEnt, false )

	weapon.SetWeaponUtilityEntity( shieldEnt )
	AddEntityCallback_OnPostDamaged( shieldEnt, IncapShield_OnShieldEntDamaged )
#endif // #if SERVER
}

void function OnWeaponDeactivate_incap_shield( entity weapon )
{
#if SERVER
	entity oldShieldEnt = weapon.GetWeaponUtilityEntity()
	if ( IsValid( oldShieldEnt ) )
	{
		oldShieldEnt.Destroy()
		weapon.SetWeaponUtilityEntity( null )
	}
#endif // #if SERVER
}

bool function OnWeaponChargeBegin_weapon_incap_shield( entity weapon )
{
#if SERVER
	entity weaponOwner = weapon.GetWeaponOwner()
	if ( !weaponOwner.IsPlayer() )
		return true

	thread IncapShield_ChargeThread( weapon, weaponOwner )
#endif // #if SERVER

	return true
}

void function OnWeaponChargeEnd_weapon_incap_shield( entity weapon )
{
	weapon.Signal( "OnChargeEnd" )
}

#if SERVER
void function IncapShield_OnShieldEntDamaged( entity shieldEnt, var damageInfo )
{
	int damage			= int( DamageInfo_GetDamage( damageInfo ) )
	entity attacker		= DamageInfo_GetAttacker( damageInfo )
	vector damageOrigin	= DamageInfo_GetDamagePosition( damageInfo )

	if ( damage <= 0 )
		return

	if ( IsValid( attacker ) )
	{
		if ( IsFriendlyTeam( attacker.GetTeam(), shieldEnt.GetTeam() ) )
			return

		if ( attacker.IsPlayer() )
			attacker.NotifyDidDamage( shieldEnt, 0, damageOrigin, 0, damage, DF_NO_HITBEEP | DAMAGEFLAG_VICTIM_HAS_VORTEX, 0, null, 0 )
	}

	int newHealth = maxint( shieldEnt.GetHealth() - damage, 0 )

	if ( INCAP_SHIELD_DEBUG )
		printt( FUNC_NAME(), "for", shieldEnt, "took", damage, "damage, new health:", newHealth )

	shieldEnt.SetHealth( newHealth )

	if ( newHealth == 0 )
		shieldEnt.SetCollisionAllowed( false )

	entity weapon = shieldEnt.e.ownerWeapon
	entity player = shieldEnt.GetOwner()

	if ( IsValid( weapon ) && IsValid( player ) )
	{
		weapon.SetScriptInt0( newHealth )

		player.ViewPunch( damageOrigin, 2.0, 1.0, 1.0 )
		if ( newHealth == 0 )
		{
			weapon.SetWeaponPrimaryAmmoCount( AMMOSOURCE_STOCKPILE, 0 )

			int fxIdx			= GetParticleSystemIndex( INCAP_SHIELD_FX_BREAK )
			int attachIdx		= player.LookupAttachment( "PROPGUN" )
			vector attachOrigin	= player.GetAttachmentOrigin( attachIdx )
			vector attachAngles	= player.GetAttachmentAngles( attachIdx )

			entity fxEnt = StartParticleEffectInWorld_ReturnEntity( fxIdx, attachOrigin, attachAngles )
			EffectSetControlPointVector( fxEnt, 2, GetIncapShieldTriLerpColor( 1.0, IncapShield_GetShieldTier( player ) ) )

			EmitSoundOnEntityExceptToPlayer( player, player, SOUND_PILOT_INCAP_SHIELD_END_3P )
			EmitSoundOnEntityOnlyToPlayer( player, player, SOUND_PILOT_INCAP_SHIELD_END_1P )

#if SERVER
	//WeaponStatsHook_OnPlayerIncapShieldBreak( player, damageInfo )
#endif
		}
	}
}

void function IncapShield_ChargeThread( entity weapon, entity player )
{
	Assert( weapon )
	Assert( player )
	Assert ( IsNewThread(), "Must be threaded off" )

	entity shieldEnt = weapon.GetWeaponUtilityEntity()
	if ( !IsValid( shieldEnt ) )
	{
		if ( INCAP_SHIELD_DEBUG )
			printt( FUNC_NAME(), "shieldEnt is INVALID for", player )

		return
	}

	// Only one thread ever exists for this weapon
	weapon.Signal( "IncapShieldBeginCharge" )
	weapon.EndSignal( "IncapShieldBeginCharge" )

	weapon.EndSignal( "OnChargeEnd" )
	weapon.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDeath" )
	player.EndSignal( "BleedOut_OnReviveStart" )
	shieldEnt.EndSignal( "OnDestroy" )

	// DO NOT REMOVE, this WaitFrame is EXTREMELY important
	// shieldEnt collision will be broken without it
	if ( GetBugReproNum() != 201218 )
		WaitFrame()

	if ( INCAP_SHIELD_DEBUG )
		printt( "IncapShield_ChargeThread BEGIN for", shieldEnt )

	PIN_PlayerUse( player, weapon.GetWeaponClassName(), "INCAP_SHIELD" )

	// Collision
	IncapShield_SetShieldEntCollision( shieldEnt, true )

	while ( Bleedout_IsPlayerSelfReviving( player ) )
	{
		wait 0.2
	}

	// VFX
	GunShieldSettings gs
	gs.owner				= player
	gs.shieldFX				= INCAP_SHIELD_FX_WALL
	gs.useFriendlyEnemyFx	= false
	gs.useFxColorOverride	= true
	gs.fxColorOverride		= GetIncapShieldColorFromInventory( player )
	gs.fxOverrideAngles		= <1, 180, 0>
	entity shieldFxEnt		= StartGunAttachedShieldFX( gs, shieldEnt )
	// shieldFxEnt is already added to shieldEnt.e.fxControlPoints

	// SFX
	EmitSoundOnEntityOnlyToPlayer( player, player, SOUND_PILOT_INCAP_SHIELD_1P )
	EmitSoundOnEntityExceptToPlayer( player, player, SOUND_PILOT_INCAP_SHIELD_3P )

	float slowSeverity = INCAP_SHIELD_MOVE_SLOW_SEVERITY
	                    
		// if( PlayerHasPassive( player, ePassives.PAS_REVENANT_REWORK ) && PlayerHasPassive( player, ePassives.PAS_PAS_UPGRADE_ONE ) )
		// {
			// // magic number to get us to the same knockdown shield move speed as normal.
			// // is there a better way to derive this instead?
			// slowSeverity = .84
		// }
       

	// Slow movement
	int slowMovementHandle = StatusEffect_AddEndless( player, eStatusEffect.move_slow, slowSeverity )

	OnThreadEnd(
		function () : ( shieldEnt, weapon, player, slowMovementHandle )
		{
			if ( INCAP_SHIELD_DEBUG )
				printt( "IncapShield_ChargeThread END   for", shieldEnt )

			if ( IsValid( shieldEnt ) )
			{
				IncapShield_SetShieldEntCollision( shieldEnt, false )

				foreach ( fxEnt in shieldEnt.e.fxControlPoints )
					EffectStop( fxEnt )

				shieldEnt.e.fxControlPoints.clear()
			}

			if ( IsValid( player ) )
			{
				StopSoundOnEntity( player, SOUND_PILOT_INCAP_SHIELD_1P )
				StopSoundOnEntity( player, SOUND_PILOT_INCAP_SHIELD_3P )

				StatusEffect_Stop( player, slowMovementHandle )
			}
		}
	)

	while ( true )
	{
		UpdateIncapShieldFX( shieldEnt, GetHealthFrac( shieldEnt ) )

		WaitFrame()
	}
}

#endif // #if SERVER

#endif // #if INCAP_SHIELD_PERSIST_LOGIC