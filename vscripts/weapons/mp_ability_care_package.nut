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
		fx.RemoveFromAllRealms()
		fx.AddToOtherEntitysRealms( ownerPlayer )

		thread CreateCarePackageAirdrop(
			origin, angles,
			Flowstate_BuildLifelineCarePackageLoot( ownerPlayer ),
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

#if SERVER
array<string> function Flowstate_BuildLifelineCarePackageLoot(entity ownerPlayer) // this code can be improved by 1000x. Colombia
{
	// from my retail investigation:
	// siempre se entregan dos items mejorados, un escudo y un attachment ( si alguna arma tiene un attachment mejorable ) O un random mejorado entre el resto ( casco, maleta, knockdown shield )
	// tiene escudo menor a lvl2 o no tiene escudo? dar un lvl2, else agregar un nivel, si es nivel 4 no agregar escudo y agregar dos consumables large (también hacer checks para los teammates, se escoge el del tier más bajo)
	// tiene un arma con algún attachment mejorable? Agregar un attachment
	// else agregar un equipment mejorado ( casco, maleta, knockdown shield )
	// entre los situables a mejorar, escoger uno random
	// es menor a lvl2 o no tiene ese equipment? dar un lvl2, else agregar un nivel, si es nivel 4 no agregar y agregar un consumable large
	// si no hay nada por mejorar solo se mandan consumables large
	// nunca se entregan items blancos, solo azules como mínimo

	array< string > healthLarge = [
	"health_pickup_combo_large"
	"health_pickup_health_large"
	"health_pickup_combo_full"
	]
	
	bool canShieldBeImproved = false
	bool forceBlueShield = false
	LootData armorLoot
	array<LootData> armors = SURVIVAL_Loot_GetByType( eLootType.ARMOR )
	array<LootData> playerArmorLoot //upgrade for each player
	array<string> finalLoot

	foreach( mate in GetPlayerArrayOfTeam( ownerPlayer.GetTeam() ) )
	{
		string currentshield = EquipmentSlot_GetLootRefForSlot( mate, "armor" )
		int currentShieldTier = EquipmentSlot_GetEquipmentTier( mate, "armor" )

		bool found = false

		if( currentShieldTier >= 3 && !found )
		{
			LootData data

			if( GetCurrentPlaylistVarBool( "flowstate_evo_shields", false ) )
				data = SURVIVAL_Loot_GetLootDataByRef( "armor_pickup_lv1" )
			else
				data = SURVIVAL_Loot_GetLootDataByRef( "armor_pickup_lv3" )

			playerArmorLoot.append( data )
			found = true
			continue
		}

		foreach( armor in armors )
		{
			if( armor.tier == 1 )
			{
				if( GetCurrentPlaylistVarBool( "flowstate_evo_shields", false ) )
				{
					playerArmorLoot.append( armor )
					found = true
				}
				continue
			}
			
			if( found )
				continue

			if( SURVIVAL_IsLootRefAnUpgrade( mate, armor ) )
			{
				playerArmorLoot.append( armor )
				found = true
			}
		}
	}
	
	if( playerArmorLoot.len() > 0 )
	{
		playerArmorLoot.sort( SortLootByTier )
		playerArmorLoot.reverse()
		armorLoot = playerArmorLoot[0]
		finalLoot.append( armorLoot.ref ) 
	}
	else
	{
		finalLoot.append( SURVIVAL_Loot_GetLootDataByRef( healthLarge.getrandom() ).ref )
		finalLoot.append( SURVIVAL_Loot_GetLootDataByRef( healthLarge.getrandom() ).ref ) 
	}

	LootData healingitem1 = SURVIVAL_Loot_GetLootDataByRef( healthLarge.getrandom() )
	LootData healingitem2 = SURVIVAL_Loot_GetLootDataByRef( healthLarge.getrandom() ) 
	
	bool detectedImprovedAttachment = false
	
	array<LootData> attachmentItems = SURVIVAL_Loot_GetByType( eLootType.ATTACHMENT )
	// attachmentItems.randomize()
	// attachmentItems.sort( SortLootByTier )
	// attachmentItems.reverse()
	
	LootData attachment1
	array<entity> weapons = SURVIVAL_GetPrimaryWeaponsSorted( ownerPlayer )
	weapons.randomize()
	
	foreach( attachment in attachmentItems )
	{
		if( SURVIVAL_Loot_GetLootDataByRef( attachment.ref ).attachmentStyle == "sight" )
			continue
		
		if( attachment.tier == 1 )
			continue
				
		if( detectedImprovedAttachment )
			continue
		
		foreach ( weaponCandidate in weapons )
		{
			if ( CanAttachToWeapon( attachment.ref, GetWeaponClassName( weaponCandidate ) ) && IsAttachmentAnUpgradeForWeapon( ownerPlayer, attachment, weaponCandidate ) )
			{
				detectedImprovedAttachment = true
				attachment1 = attachment
				break
			}
		}
	}
	
	LootData attachment2 = SURVIVAL_Loot_GetLootDataByRef( healthLarge.getrandom() )
	
	array<LootData> equipmentLootGroup
	array<LootData> incapshields = SURVIVAL_Loot_GetByType( eLootType.INCAPSHIELD )
	array<LootData> backpacks = SURVIVAL_Loot_GetByType( eLootType.BACKPACK )
	array<LootData> helmets = SURVIVAL_Loot_GetByType( eLootType.HELMET )
	
	int firstToCheck = RandomIntRangeInclusive( 1, 3 )
	
	switch( firstToCheck )
	{
		case 1:
		equipmentLootGroup.extend( incapshields )
		equipmentLootGroup.extend( backpacks )
		equipmentLootGroup.extend( helmets )
		break
		
		case 2:
		equipmentLootGroup.extend( backpacks )
		equipmentLootGroup.extend( helmets )
		equipmentLootGroup.extend( incapshields )
		break
		
		case 3:
		equipmentLootGroup.extend( helmets )
		equipmentLootGroup.extend( incapshields )
		equipmentLootGroup.extend( backpacks )
		break
	}

	if ( !detectedImprovedAttachment )
	{
		attachment1 = SURVIVAL_Loot_GetLootDataByRef( healthLarge.getrandom() )
		
		bool found = false
		foreach( equipment in equipmentLootGroup )
		{
			if( equipment.tier == 1 )
				continue
			
			if( found )
				continue
			
			if( SURVIVAL_IsLootRefAnUpgrade( ownerPlayer, equipment ) )
			{
				attachment1 = equipment
				found = true
			}
		}
	}
	
	finalLoot.append( attachment1.ref )
	finalLoot.append( attachment2.ref )
	finalLoot.append( healingitem1.ref )
	finalLoot.append( healingitem2.ref )
	
	return finalLoot
}

int function SortLootByTier( LootData a, LootData b )
{
	if ( a.tier > b.tier )
		return -1
	if ( a.tier < b.tier )
		return 1	
	
	return 0
}

#endif