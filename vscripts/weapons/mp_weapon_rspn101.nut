global function OnWeaponActivate_R101
global function OnWeaponDeactivate_R101
global function OnWeaponPrimaryAttack_R101

//--------------------------------------------------
// R101 MAIN
//--------------------------------------------------

void function OnWeaponActivate_R101( entity weapon )
{
	OnWeaponActivate_weapon_basic_bolt( weapon )

	OnWeaponActivate_RUIColorSchemeOverrides( weapon )
	OnWeaponActivate_ReactiveKillEffects( weapon )
}

void function OnWeaponDeactivate_R101( entity weapon )
{
	OnWeaponDeactivate_ReactiveKillEffects( weapon )
}

var function OnWeaponPrimaryAttack_R101( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	if ( weapon.HasMod( "altfire_highcal" ) )
		thread PlayDelayedShellEject( weapon, RandomFloatRange( 0.03, 0.04 ) )

	weapon.FireWeapon_Default( attackParams.pos, attackParams.dir, 1.0, 1.0, false )

	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
}
