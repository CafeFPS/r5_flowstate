global function MpWeaponEnergyAR_Init
global function OnWeaponPrimaryAttack_Energy_AR
#if SERVER
global function OnWeaponNpcPrimaryAttack_Energy_AR
#endif // #if SERVER

void function MpWeaponEnergyAR_Init()
{
	//PrecacheParticleSystem( $"P_wpn_defender_charge_FP" )
	//PrecacheParticleSystem( $"P_wpn_defender_charge" )
	//PrecacheParticleSystem( $"defender_charge_CH_dlight" )
	//PrecacheParticleSystem( $"wpn_muzzleflash_arc_cannon_fp" )
	//PrecacheParticleSystem( $"wpn_muzzleflash_arc_cannon" )
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
