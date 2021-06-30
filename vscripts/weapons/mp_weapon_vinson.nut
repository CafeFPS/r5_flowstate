global function OnWeaponActivate_Vinson
global function OnWeaponDeactivate_Vinson
global function OnWeaponPrimaryAttack_Vinson

void function OnWeaponActivate_Vinson( entity weapon )
{
	OnWeaponActivate_weapon_basic_bolt( weapon )
	#if SERVER
	#endif //
}

void function OnWeaponDeactivate_Vinson( entity weapon )
{
    
}

var function OnWeaponPrimaryAttack_Vinson( entity weapon, WeaponPrimaryAttackParams attackParams )
{

	if ( weapon.HasMod( "altfire_highcal" ) )
		thread PlayDelayedShellEject( weapon, RandomFloatRange( 0.03, 0.04 ) )

	weapon.FireWeapon_Default( attackParams.pos, attackParams.dir, 1.0, 1.0, false )

	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
}
