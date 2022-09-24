global function OnWeaponPrimaryAttack_care_package_medic

struct AirdropContents
{
	array<string> left
	array<string> right
	array<string> center
}

struct LootPool
{
	//
	table< string, int > equipmentTable
	table< string, int > attachmentTable

	array<string> armorLootGroup
	array<string> equipmentLootGroup
	array<string> attachmentsLootGroup
}

enum eLootPoolType
{
	ARMOR
	OTHER_EQUIPMENT
	ATTACHMENTS
	SMALL_CONSUMABLE
	LARGE_CONSUMABLE

	_count
}

struct
{
	array<string> validSlots = [
		"armor",
		"helmet",
		"incapshield",
		"backpack",
	]

} file

var function OnWeaponPrimaryAttack_care_package_medic( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity ownerPlayer = weapon.GetWeaponOwner()

	if( !IsValid( ownerPlayer ) || !ownerPlayer.IsPlayer() )
		return 0

	if ( ownerPlayer.IsPhaseShifted() )
		return 0

	CarePackagePlacementInfo placementInfo = GetCarePackagePlacementInfo( ownerPlayer )

	if ( placementInfo.failed )
		return 0

	#if SERVER
		vector origin = placementInfo.origin
		vector angles = placementInfo.angles

        //Start the ground circle particle
		entity fx = StartParticleEffectInWorld_ReturnEntity(GetParticleSystemIndex( DROPPOD_SPAWN_FX ), origin, angles)

		thread CreateCarePackageAirdrop(
			origin, angles,
			["medic_super", "medic_super_side", "top_tier_inventory" ],
			fx, "droppod_loot_drop_lifeline",
			ownerPlayer, weapon.GetWeaponClassName()
		)
		ItemFlavor character = LoadoutSlot_GetItemFlavor( ToEHI( ownerPlayer ), Loadout_CharacterClass() )
		string charRef = ItemFlavor_GetHumanReadableRef( character )

		if( charRef == "character_lifeline")
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