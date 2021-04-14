global function OnWeaponPrimaryAttack_care_package_medic

var function OnWeaponPrimaryAttack_care_package_medic( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	Assert( ownerPlayer.IsPlayer() )

	CarePackagePlacementInfo placementInfo = GetCarePackagePlacementInfo( ownerPlayer )

	if ( placementInfo.failed )
		return 0

	#if SERVER
		vector origin = placementInfo.origin
		vector angles = placementInfo.angles

		thread CreateCarePackageAirdrop(
			origin, angles,
			["medic_super", "medic_super_side", "top_tier_inventory" ],
			null, "droppod_loot_drop_lifeline",
			ownerPlayer, weapon.GetWeaponClassName()
		)
		PlayBattleChatterLineToSpeakerAndTeam( ownerPlayer, "bc_super" )

		PlayerUsedOffhand( ownerPlayer, weapon, true, null, {pos = origin} )
	#else
		PlayerUsedOffhand( ownerPlayer, weapon )
		SetCarePackageDeployed( true )
		ownerPlayer.Signal( "DeployableCarePackagePlacement" )
	#endif

	int ammoReq = weapon.GetAmmoPerShot()
	return ammoReq
}