
global function OnWeaponPrimaryAttack_weapon_shotgun

#if SERVER
global function OnWeaponNpcPrimaryAttack_weapon_shotgun
#endif // #if SERVER


var function OnWeaponPrimaryAttack_weapon_shotgun( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	bool playerFired = true
	Fire_EVA_Shotgun( weapon, attackParams, playerFired )
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_weapon_shotgun( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	bool playerFired = false
	Fire_EVA_Shotgun( weapon, attackParams, playerFired )
}
#endif // #if SERVER

int function Fire_EVA_Shotgun( entity weapon, WeaponPrimaryAttackParams attackParams, bool playerFired = true )
{
	entity owner = weapon.GetWeaponOwner()

	float patternScale = 1.0
	if ( !playerFired )
		patternScale = weapon.GetWeaponSettingFloat( eWeaponVar.blast_pattern_npc_scale )

	float speedScale = 1.0
	bool ignoreSpread = true
	weapon.FireWeapon_Default( attackParams.pos, attackParams.dir, speedScale, patternScale, ignoreSpread )

	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
}
