global function MpWeaponEnergyAR_Init
global function OnWeaponActivate_Energy_AR
global function OnWeaponDeactivate_Energy_AR
global function OnWeaponPrimaryAttack_Energy_AR
#if SERVER
global function OnWeaponNpcPrimaryAttack_Energy_AR
#endif // #if SERVER

const string HACK_FLASH_FX_REF_1 = $"P_havok_leg_orng_lvl1"
const string HACK_FLASH_FX_REF_2 = $"P_havok_leg_orng_lvl2"
const string HACK_FLASH_FX_REF_3 = $"P_havok_leg_orng_lvl3"
const string HACK_FLASH_FX_REF_4 = $"P_havok_leg_orng_eye_lvl1"
const string HACK_FLASH_FX_REF_5 = $"P_havok_leg_orng_eye_lvl2"
const string HACK_FLASH_FX_REF_6 = $"P_havok_leg_orng_eye_lvl3"
const string HACK_FLASH_FX_REF_7 = $"P_havok_leg_orng_nose_1"
const string HACK_FLASH_FX_REF_8 = $"P_havok_leg_orng_nose_2"
const string HACK_FLASH_FX_REF_9 = $"P_havok_leg_orng_eye_flash"
const string HACK_FLASH_FX_REF_10 = $"P_havok_leg_orng_flash"
const string HACK_FLASH_FX_REF_11 = $"P_havok_leg_orng_lvl2_3P"
const string HACK_FLASH_FX_REF_12 = $"P_havok_leg_orng_eye_lvl2_3P"
const string HACK_FLASH_FX_REF_13 = $"P_havok_leg_orng_flash_3P"
const string HACK_FLASH_FX_REF_14 = $"P_havok_leg_orng_eye_flash_3P"
const string HACK_FLASH_FX_REF_15 = $"P_havok_leg_orng_nose_loop_1"
const string HACK_FLASH_FX_REF_16 = $"P_havok_leg_orng_nose_loop_2"
const string HACK_FLASH_FX_REF_17 = $"P_havok_leg_orng_nose_1_3P"
const string HACK_FLASH_FX_REF_18 = $"P_havok_leg_orng_nose_2_3P"
const string HACK_FLASH_FX_REF_19 = $"P_havok_leg_orng_eye_lvl3_3P"
const string HACK_FLASH_FX_REF_20 = $"P_havok_leg_blue_nose_loop_2"
const string HACK_FLASH_FX_REF_21 = $"P_havok_leg_blue_nose_loop_1"
const string HACK_FLASH_FX_REF_22 = $"P_havok_leg_blue_nose_2"
const string HACK_FLASH_FX_REF_23 = $"P_havok_leg_blue_nose_1"
const string HACK_FLASH_FX_REF_24 = $"P_havok_leg_blue_nose_2_3P"
const string HACK_FLASH_FX_REF_25 = $"P_havok_leg_blue_lvl3_3P"
const string HACK_FLASH_FX_REF_26 = $"P_havok_leg_blue_lvl3"
const string HACK_FLASH_FX_REF_27 = $"P_havok_leg_blue_lvl2_3P"
const string HACK_FLASH_FX_REF_28 = $"P_havok_leg_blue_lvl2"
const string HACK_FLASH_FX_REF_29 = $"P_havok_leg_blue_lvl1"
const string HACK_FLASH_FX_REF_30 = $"P_havok_leg_blue_flash_3P"
const string HACK_FLASH_FX_REF_31 = $"P_havok_leg_blue_flash"
const string HACK_FLASH_FX_REF_32 = $"P_havok_leg_blue_eye_lvl3"
const string HACK_FLASH_FX_REF_33 = $"P_havok_leg_blue_eye_lvl2"
const string HACK_FLASH_FX_REF_34 = $"P_havok_leg_blue_eye_lvl1"
const string HACK_FLASH_FX_REF_35 = $"P_havok_leg_blue_eye_flash"
const string HACK_FLASH_FX_REF_36 = $"P_havok_leg_green_nose_loop_2"
const string HACK_FLASH_FX_REF_37 = $"P_havok_leg_green_nose_loop_1"
const string HACK_FLASH_FX_REF_38 = $"P_havok_leg_green_nose_2"
const string HACK_FLASH_FX_REF_39 = $"P_havok_leg_green_nose_1"
const string HACK_FLASH_FX_REF_40 = $"P_havok_leg_green_nose_2_3P"
const string HACK_FLASH_FX_REF_41 = $"P_havok_leg_green_lvl3_3P"
const string HACK_FLASH_FX_REF_42 = $"P_havok_leg_green_lvl3"
const string HACK_FLASH_FX_REF_43 = $"P_havok_leg_green_lvl2_3P"
const string HACK_FLASH_FX_REF_44 = $"P_havok_leg_green_lvl2"
const string HACK_FLASH_FX_REF_45 = $"P_havok_leg_green_lvl1"
const string HACK_FLASH_FX_REF_46 = $"P_havok_leg_green_flash_3P"
const string HACK_FLASH_FX_REF_47 = $"P_havok_leg_green_flash"
const string HACK_FLASH_FX_REF_48 = $"P_havok_leg_green_eye_lvl3"
const string HACK_FLASH_FX_REF_49 = $"P_havok_leg_green_eye_lvl2"
const string HACK_FLASH_FX_REF_50 = $"P_havok_leg_green_eye_lvl1"
const string HACK_FLASH_FX_REF_51 = $"P_havok_leg_green_eye_flash"
const string HACK_FLASH_FX_REF_52 = $"P_havok_leg_green_lvl1_3P"
const string HACK_FLASH_FX_REF_53 = $"P_havok_leg_orng_lvl1_3P"
const string HACK_FLASH_FX_REF_54 = $"P_havok_leg_blue_lvl1_3P"
const string HACK_FLASH_FX_REF_56 = $"P_havok_leg_orng_lvl3_3P"

void function MpWeaponEnergyAR_Init()
{
	//PrecacheParticleSystem( $"P_wpn_defender_charge_FP" )
	//PrecacheParticleSystem( $"P_wpn_defender_charge" )
	//PrecacheParticleSystem( $"defender_charge_CH_dlight" )
	//PrecacheParticleSystem( $"wpn_muzzleflash_arc_cannon_fp" )
	//PrecacheParticleSystem( $"wpn_muzzleflash_arc_cannon" )
}

void function OnWeaponActivate_Energy_AR( entity weapon )
{
	OnWeaponActivate_RUIColorSchemeOverrides( weapon )
	OnWeaponActivate_ReactiveKillEffects( weapon )
}

void function OnWeaponDeactivate_Energy_AR( entity weapon )
{
	OnWeaponDeactivate_ReactiveKillEffects( weapon )
}

bool function CanFire_EnergyAR( entity weapon )
{
	if ( weapon.GetWeaponChargeFraction() < 1.0 )
		return false

	return true
}

var function OnWeaponPrimaryAttack_Energy_AR( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	if ( !CanFire_EnergyAR( weapon ) )
		return 0

	return Fire_EnergyAR( weapon, attackParams )
}


#if SERVER
var function OnWeaponNpcPrimaryAttack_Energy_AR( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	if ( !CanFire_EnergyAR( weapon ) )
		return 0

	return Fire_EnergyAR( weapon, attackParams )
}
#endif // #if SERVER


int function Fire_EnergyAR( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	// alt-fire (charge rifle) behavior
	if ( weapon.HasMod( "altfire" ) )
	{
		int chargeShotDamageFlags = weapon.GetWeaponDamageFlags()
		weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )
		weapon.FireWeaponBullet( attackParams.pos, attackParams.dir, 1, chargeShotDamageFlags )
	}
	// primary fire (AR) behavior
	else
	{
		OnWeaponPrimaryAttack_weapon_basic_bolt( weapon, attackParams )
	}

	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
}
