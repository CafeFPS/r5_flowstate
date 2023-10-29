global function MpWeaponDefender_Init
global function OnWeaponActivate_weapon_defender_railgun
global function OnWeaponReload_weapon_defender_railgun
global function OnWeaponPrimaryAttack_weapon_defender_railgun
global function OnWeaponChargeBegin_weapon_defender_railgun


const asset DEFENDER_FX_RELOAD_1P = $"P_wpn_defender_reload_FP"
const asset DEFENDER_FX_RELOAD_3P = $"P_wpn_defender_reload"


void function MpWeaponDefender_Init()
{
	PrecacheParticleSystem( DEFENDER_FX_RELOAD_1P )
	PrecacheParticleSystem( DEFENDER_FX_RELOAD_3P )
}

void function OnWeaponActivate_weapon_defender_railgun( entity weapon )
{

}

void function OnWeaponReload_weapon_defender_railgun( entity weapon, int milestoneIndex )
{
	weapon.PlayWeaponEffect( DEFENDER_FX_RELOAD_1P, DEFENDER_FX_RELOAD_3P, "shell" )
	weapon.PlayWeaponEffect( DEFENDER_FX_RELOAD_1P, DEFENDER_FX_RELOAD_3P, "shell2" )
}

var function OnWeaponPrimaryAttack_weapon_defender_railgun( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	if ( weapon.GetWeaponChargeFraction() < 1.0 )
		return 0

	return FireDefender( weapon, attackParams )
}

bool function OnWeaponChargeBegin_weapon_defender_railgun( entity weapon )
{
	if ( weapon.GetWeaponChargeFraction() == 0.0 )
		weapon.EmitWeaponSound_1p3p( "Weapon_ChargeRifle_TriggerOn", "" )
	else
		weapon.EmitWeaponSound_1p3p( "weapon_chargerifle_chargeupclick_1p", "" )

	return true
}


int function FireDefender( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )

	weapon.FireWeapon_Default( attackParams.pos, attackParams.dir, 1.0, 1.0, false )

	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
}