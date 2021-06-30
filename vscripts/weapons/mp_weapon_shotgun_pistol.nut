global function OnWeaponPrimaryAttack_weapon_shotgun_pistol

#if SERVER
global function OnWeaponNpcPrimaryAttack_weapon_shotgun_pistol
#endif // #if SERVER


var function OnWeaponPrimaryAttack_weapon_shotgun_pistol( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	bool playerFired = true
	return Fire_ShotgunPistol( weapon, attackParams, playerFired )
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_weapon_shotgun_pistol( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	bool playerFired = false
	return Fire_ShotgunPistol( weapon, attackParams, playerFired )
}
#endif // #if SERVER

int function Fire_ShotgunPistol( entity weapon, WeaponPrimaryAttackParams attackParams, bool playerFired = true )
{
	float patternScale = 1.0
	if ( playerFired )
	{
		// scale spread pattern based on ADS
		entity owner = weapon.GetWeaponOwner()
		float maxAdsPatternScale = expect float( weapon.GetWeaponInfoFileKeyField( "blast_pattern_ads_scale" ) )
		patternScale *= GraphCapped( owner.GetZoomFrac(), 0.0, 1.0, 1.0, maxAdsPatternScale )
	}
	else
	{
		patternScale = weapon.GetWeaponSettingFloat( eWeaponVar.blast_pattern_npc_scale )
	}

	float speedScale = 1.0
	bool ignoreSpread = true
	weapon.FireWeapon_Default( attackParams.pos, attackParams.dir, speedScale, patternScale, ignoreSpread )

	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
}
