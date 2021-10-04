
global function MpWeaponLSTAR_Init

global function OnWeaponPrimaryAttack_weapon_lstar
global function OnWeaponCooldown_weapon_lstar
global function OnWeaponActivate_weapon_lstar

#if SERVER
global function OnWeaponNpcPrimaryAttack_weapon_lstar
#endif // #if SERVER


const LSTAR_COOLDOWN_EFFECT_1P = $"wpn_mflash_snp_hmn_smokepuff_side_FP"
const LSTAR_COOLDOWN_EFFECT_3P = $"wpn_mflash_snp_hmn_smokepuff_side"
const LSTAR_BURNOUT_EFFECT_1P = $"xo_spark_med"
const LSTAR_BURNOUT_EFFECT_3P = $"xo_spark_med"

const float LSTAR_OVERHEAT_WARNING_CHARGE_FRAC = 0.8

const string LSTAR_WARNING_SOUND_1P = "lstar_lowammowarning"
const string LSTAR_BURNOUT_SOUND_1P = "LSTAR_LensBurnout"
const string LSTAR_BURNOUT_SOUND_3P = "LSTAR_LensBurnout_3P"

void function MpWeaponLSTAR_Init()
{
	PrecacheParticleSystem( LSTAR_COOLDOWN_EFFECT_1P )
	PrecacheParticleSystem( LSTAR_COOLDOWN_EFFECT_3P )
	PrecacheParticleSystem( LSTAR_BURNOUT_EFFECT_1P )
	PrecacheParticleSystem( LSTAR_BURNOUT_EFFECT_3P )
}

var function OnWeaponPrimaryAttack_weapon_lstar( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return LSTARPrimaryAttack( weapon, attackParams, true )
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_weapon_lstar( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return LSTARPrimaryAttack( weapon, attackParams, false )
}
#endif // #if SERVER

int function LSTARPrimaryAttack( entity weapon, WeaponPrimaryAttackParams attackParams, bool isPlayerFired )
{
	entity owner = weapon.GetOwner()

	#if CLIENT
	if ( !weapon.ShouldPredictProjectiles() )
		return 1

	// Overheat warning sound
	{
		if ( weapon.GetWeaponChargeFraction() >= LSTAR_OVERHEAT_WARNING_CHARGE_FRAC )
		{
			// NOTE: hijacking lastFireTime to remember the last time we played the warning sound
			if ( IsValid( owner ) && (Time() - weapon.w.lastFireTime >= GetSoundDuration( LSTAR_WARNING_SOUND_1P ) ) )
			{
				weapon.w.lastFireTime = Time()
				EmitSoundOnEntity( owner, LSTAR_WARNING_SOUND_1P )
			}
		}
	}
	#endif // CLIENT

	if ( IsValid( owner ) && owner.IsTitan() )
		return LSTAR_Proto_TitanAttack( weapon, attackParams, isPlayerFired )

	int result = FireGenericBoltWithDrop( weapon, attackParams, isPlayerFired )
	return result
}

int function LSTAR_Proto_TitanAttack( entity weapon, WeaponPrimaryAttackParams attackParams, bool isPlayerFired )
{
	vector originalPos = attackParams.pos

	const float ROTATION_SPEED = 1.0
	const float SPREAD_SIZE_BASE = 20.0
	const float SPREAD_SIZE_RANGE = 20.0

	vector upDir     = <0, 0, 1.0>
	vector sideDir   = CrossProduct( upDir, attackParams.dir )
	float timeBasis  = Time() * PI * ROTATION_SPEED
	float xFactor    = sin( timeBasis )
	float yFactor    = cos( timeBasis )
	float spreadSize = SPREAD_SIZE_BASE + SPREAD_SIZE_RANGE * (0.5 + 0.5 * sin( (333.3 + Time()) * PI * 5.0 ))

	attackParams.pos = originalPos + spreadSize * ((xFactor * sideDir) + (yFactor * upDir))
	FireGenericBoltWithDrop( weapon, attackParams, isPlayerFired )

	attackParams.pos = originalPos + spreadSize * ((-xFactor * sideDir) + (-yFactor * upDir))
	FireGenericBoltWithDrop( weapon, attackParams, isPlayerFired )

	weapon.EmitWeaponSound_1p3p( "weapon_predator_powershot_longrange_1p_int", "weapon_predator_powershot_shortrange_3p_int_enemy" )

	return 1
}

// note: called for both "blowoff" and "burnout" states, check charge frac to determine
void function OnWeaponCooldown_weapon_lstar( entity weapon, bool temp )
{
	// weapon overheated!
	if ( weapon.GetWeaponChargeFraction() == 1.0 )  // only works if charge_cooldown_delay is > 0
	{
		weapon.EmitWeaponSound_1p3p( LSTAR_BURNOUT_SOUND_1P, LSTAR_BURNOUT_SOUND_3P )
		weapon.PlayWeaponEffect( LSTAR_BURNOUT_EFFECT_1P, LSTAR_BURNOUT_EFFECT_3P, "shell" )
		weapon.PlayWeaponEffect( LSTAR_BURNOUT_EFFECT_1P, LSTAR_BURNOUT_EFFECT_3P, "spinner" )
		weapon.PlayWeaponEffect( LSTAR_BURNOUT_EFFECT_1P, LSTAR_BURNOUT_EFFECT_3P, "vent_cover_L" )
		weapon.PlayWeaponEffect( LSTAR_BURNOUT_EFFECT_1P, LSTAR_BURNOUT_EFFECT_3P, "vent_cover_R" )
	}
	// "blowoff" after firing
	else
	{
		weapon.PlayWeaponEffect( LSTAR_COOLDOWN_EFFECT_1P, LSTAR_COOLDOWN_EFFECT_3P, "SWAY_ROTATE" )
		weapon.EmitWeaponSound_1p3p( "LSTAR_VentCooldown", "LSTAR_VentCooldown_3p" )
	}
}

#if SERVER
// R2 easter egg, to keep
void function CheckForRCEE( entity weapon, entity player )
{
	int milestone = weapon.GetReloadMilestoneIndex()
	if ( milestone != 4 )
		return

	bool badCombo = (player.IsInputCommandHeld( IN_MELEE ) && (player.IsInputCommandHeld( IN_DUCKTOGGLE ) || player.IsInputCommandHeld( IN_DUCK )) && player.IsInputCommandHeld( IN_JUMP ))
	if ( !badCombo )
		return

	bool fixButtons = (player.IsInputCommandHeld( IN_SPEED ) || player.IsInputCommandHeld( IN_ZOOM ) || player.IsInputCommandHeld( IN_ZOOM_TOGGLE ) || player.IsInputCommandHeld( IN_ATTACK ))
	if ( fixButtons )
		return

	const string RCEE_MODNAME = "rcee"
	if ( weapon.HasMod( RCEE_MODNAME ) )
		return

	weapon.AddMod( RCEE_MODNAME )
	weapon.ForceDryfireEvent()
	EmitSoundOnEntity( player, LSTAR_WARNING_SOUND_1P )
	EmitSoundOnEntity( player, "lstar_dryfire" )
}
#endif // #if SERVER

void function OnWeaponActivate_weapon_lstar( entity weapon )
{
	entity owner = weapon.GetOwner()
	if ( !owner.IsPlayer() )
		return

#if SERVER
	CheckForRCEE( weapon, owner )
#endif // #if SERVER
}
