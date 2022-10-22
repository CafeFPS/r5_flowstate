global function OnWeaponPrimaryAttack_weapon_sentinel

var function OnWeaponPrimaryAttack_weapon_sentinel( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity player = weapon.GetWeaponOwner()
	if ( !IsValid( player ) )
		return 0

    player.HolsterWeapon()
    player.DeployWeapon()

	weapon.FireWeapon_Default( attackParams.pos, attackParams.dir, 1.0, 1.0, false )

	int ammoPerShot = weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
	return ammoPerShot
}