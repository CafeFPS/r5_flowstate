#if(true)//

global function MpWeaponCarePackageWeapons_Init
global function OnWeaponPrimaryAttack_care_package_weapons

void function MpWeaponCarePackageWeapons_Init()
{
	#if SERVER

	#endif // SERVER
}

var function OnWeaponPrimaryAttack_care_package_weapons( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	Assert( ownerPlayer.IsPlayer() )

	CarePackagePlacementInfo placementInfo = GetCarePackagePlacementInfo( ownerPlayer )

	if ( placementInfo.failed )
		return 0

	#if SERVER










	#else
		SetCarePackageDeployed( true )
		ownerPlayer.Signal( "DeployableCarePackagePlacement" )
	#endif

	int ammoReq = weapon.GetAmmoPerShot()
	return ammoReq
}

#if SERVER














//

























#endif //

#endif //
