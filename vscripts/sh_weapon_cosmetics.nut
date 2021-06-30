global function ShWeaponCosmetics_LevelInit

global function Loadout_WeaponSkin
global function WeaponSkin_GetWorldModel
global function WeaponSkin_GetViewModel
global function WeaponSkin_GetSkinName
global function WeaponSkin_GetCamoIndex
global function WeaponSkin_GetHackyRUISchemeIdentifier
global function WeaponSkin_GetReactToKillsLevelCount
global function WeaponSkin_DoesReactToKills
global function WeaponSkin_GetReactToKillsDataForLevel
global function WeaponSkin_GetReactToKillsLevelIndexForKillCount
global function WeaponSkin_GetSortOrdinal
global function WeaponSkin_GetWeaponFlavor
global function WeaponSkin_GetVideo

global function Loadout_WeaponCharm
#if SERVER
global function AddCallback_UpdatePlayerWeaponCosmetics
#endif
#if SERVER || CLIENT
global function WeaponSkin_Apply
#endif
#if R5DEV && CLIENT
global function DEV_TestWeaponSkinData
#endif


//////////////////////
//////////////////////
//// Global Types ////
//////////////////////
//////////////////////
global struct WeaponReactiveKillsData
{
	int           killCount
	string        killSoundEvent1p
	string        killSoundEvent3p
	string        persistentSoundEvent1p
	string        persistentSoundEvent3p
	float         emissiveIntensity
	array<asset>  killFX1PList
	array<asset>  killFX3PList
	array<string> killFXAttachmentList
	array<asset>  persistentFX1PList
	array<asset>  persistentFX3PList
	array<string> persistentFXAttachmentList
}


///////////////////////
///////////////////////
//// Private Types ////
///////////////////////
///////////////////////
struct FileStruct_LifetimeLevel
{
	table<ItemFlavor, LoadoutEntry>             loadoutWeaponSkinSlotMap
	table<ItemFlavor, table<ItemFlavor, bool> > weaponSkinSetMap
	table<ItemFlavor, ItemFlavor>               skinWeaponMap

	table<ItemFlavor, LoadoutEntry>                loadoutWeaponCharmSlotMap
	table<ItemFlavor, table<ItemFlavor, bool> >    weaponCharmSetMap
	table<ItemFlavor, ItemFlavor>                  charmWeaponMap

	table<ItemFlavor, int> cosmeticFlavorSortOrdinalMap

	#if SERVER || CLIENT
		table<ItemFlavor, table<asset, int> > weaponModelLegendaryIndexMapMap
		table<ItemFlavor, int>                weaponSkinLegendaryIndexMap
	#endif

	#if CLIENT
		table<entity, entity>    menuWeaponCharmEntityMap
	#endif
}
FileStruct_LifetimeLevel& fileLevel

struct
{
	array< void functionref(entity, ItemFlavor, ItemFlavor) > callbacks_UpdatePlayerWeaponCosmetics
} file

////////////////////////
////////////////////////
//// Initialization ////
////////////////////////
////////////////////////
void function ShWeaponCosmetics_LevelInit()
{
	FileStruct_LifetimeLevel newFileLevel
	fileLevel = newFileLevel

	AddCallback_OnItemFlavorRegistered( eItemType.loot_main_weapon, OnItemFlavorRegistered_LootMainWeapon )
	//AddCallback_OnItemFlavorRegistered( eItemType.weapon_skin, OnItemFlavorRegistered_WeaponSkin ) // (dw): calling this manually instead of using this callback because we need WeaponSkin_GetWeaponFlavor to work
}


void function OnItemFlavorRegistered_LootMainWeapon( ItemFlavor weaponFlavor )
{
	// skins
	{
		array<ItemFlavor> skinList = RegisterReferencedItemFlavorsFromArray( weaponFlavor, "skins", "flavor", "featureFlag" )
		fileLevel.weaponSkinSetMap[weaponFlavor] <- MakeItemFlavorSet( skinList, fileLevel.cosmeticFlavorSortOrdinalMap )
		foreach( ItemFlavor skin in skinList )
		{
			fileLevel.skinWeaponMap[skin] <- weaponFlavor
			SetupWeaponSkin( skin )
		}

		LoadoutEntry entry = RegisterLoadoutSlot( eLoadoutEntryType.ITEM_FLAVOR, "weapon_skin_for_" + ItemFlavor_GetGUIDString( weaponFlavor ) )
		entry.DEV_category = "weapon_skins"
		entry.DEV_name = ItemFlavor_GetHumanReadableRef( weaponFlavor ) + " Skin"
		entry.defaultItemFlavor = skinList[0]
		entry.validItemFlavorList = skinList
		entry.isSlotLocked = bool function( EHI playerEHI ) {
			return !IsLobby()
		}
		entry.networkTo = eLoadoutNetworking.PLAYER_EXCLUSIVE
		#if SERVER && R5DEV
			entry.isCurrentlyRelevant = bool function( EHI playerEHI ) : ( weaponFlavor ) {
				entity player          = FromEHI( playerEHI )
				string weaponClassName = WeaponItemFlavor_GetClassname( weaponFlavor )

				if ( IsValid( player.p.DEV_lastDroppedSurvivalWeaponProp ) && player.p.DEV_lastDroppedSurvivalWeaponProp.GetWeaponName() == weaponClassName )
					return true

				foreach( entity weapon in player.GetAllActiveWeapons() )
				{
					if ( weapon.GetWeaponClassName() == weaponClassName )
						return true
				}
				return false
			}
		#endif
		AddCallback_ItemFlavorLoadoutSlotDidChange_AnyPlayer( entry, void function( EHI playerEHI, ItemFlavor skin ) : ( weaponFlavor, entry ) {
			#if SERVER
				UpdatePlayerWeaponCosmetics( FromEHI( playerEHI ), weaponFlavor, skin )
			#endif
		} )
		fileLevel.loadoutWeaponSkinSlotMap[weaponFlavor] <- entry
	}
}


void function SetupWeaponSkin( ItemFlavor skin )
{
	asset worldModel = WeaponSkin_GetWorldModel( skin )
	asset viewModel  = WeaponSkin_GetViewModel( skin )

	#if SERVER || CLIENT
		PrecacheModel( worldModel )
		PrecacheModel( viewModel )

		ItemFlavor weaponFlavor = WeaponSkin_GetWeaponFlavor( skin )

		if ( !(weaponFlavor in fileLevel.weaponModelLegendaryIndexMapMap) )
			fileLevel.weaponModelLegendaryIndexMapMap[weaponFlavor] <- {}

		table<asset, int> weaponLegendaryIndexMap = fileLevel.weaponModelLegendaryIndexMapMap[weaponFlavor]

		if ( !(worldModel in weaponLegendaryIndexMap) )
		{
			int skinLegendaryIndex = weaponLegendaryIndexMap.len()
			weaponLegendaryIndexMap[worldModel] <- skinLegendaryIndex

			SetWeaponLegendaryModel( WeaponItemFlavor_GetClassname( weaponFlavor ), skinLegendaryIndex, viewModel, worldModel )
		}

		fileLevel.weaponSkinLegendaryIndexMap[skin] <- weaponLegendaryIndexMap[worldModel]
	#endif
}


//////////////////////////
//////////////////////////
//// Global functions ////
//////////////////////////
//////////////////////////
LoadoutEntry function Loadout_WeaponSkin( ItemFlavor weaponFlavor )
{
	return fileLevel.loadoutWeaponSkinSlotMap[weaponFlavor]
}

LoadoutEntry function Loadout_WeaponCharm( ItemFlavor weaponFlavor )
{
	return fileLevel.loadoutWeaponCharmSlotMap[weaponFlavor]
}

///////////////////
///////////////////
//// Internals ////
///////////////////
///////////////////
#if SERVER
void function UpdatePlayerWeaponCosmetics( entity player, ItemFlavor weaponFlavor, ItemFlavor skin )
{
	#if R5DEV
		string weaponClassName = WeaponItemFlavor_GetClassname( weaponFlavor )

		foreach( entity weapon in player.GetMainWeapons() )
		{
			if ( weapon.GetWeaponClassName() == weaponClassName )
				WeaponSkin_Apply( weapon, skin )
		}

		if ( IsValid( player.p.DEV_lastDroppedSurvivalWeaponProp ) && player.p.DEV_lastDroppedSurvivalWeaponProp.GetWeaponName() == weaponClassName )
			WeaponSkin_Apply( player.p.DEV_lastDroppedSurvivalWeaponProp, skin )
	#endif

	foreach( callbackFunc in file.callbacks_UpdatePlayerWeaponCosmetics )
		callbackFunc( player, weaponFlavor, skin )
}

void function AddCallback_UpdatePlayerWeaponCosmetics( void functionref(entity, ItemFlavor, ItemFlavor) callbackFunc )
{
	Assert( !file.callbacks_UpdatePlayerWeaponCosmetics.contains( callbackFunc ), "Already added " + string( callbackFunc ) + " with AddCallback_UpdatePlayerWeaponCosmetics" )
	file.callbacks_UpdatePlayerWeaponCosmetics.append( callbackFunc )
}
#endif // SERVER


ItemFlavor function WeaponSkin_GetWeaponFlavor( ItemFlavor skin )
{
	Assert( ItemFlavor_GetType( skin ) == eItemType.weapon_skin )

	return fileLevel.skinWeaponMap[skin]
}


asset function WeaponSkin_GetWorldModel( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.weapon_skin )

	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( flavor ), "worldModel" )
}


asset function WeaponSkin_GetViewModel( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.weapon_skin )

	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( flavor ), "viewModel" )
}


string function WeaponSkin_GetSkinName( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.weapon_skin )

	return GetGlobalSettingsString( ItemFlavor_GetAsset( flavor ), "skinName" )
}


int function WeaponSkin_GetCamoIndex( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.weapon_skin )

	return GetGlobalSettingsInt( ItemFlavor_GetAsset( flavor ), "camoIndex" )
}


int function WeaponSkin_GetHackyRUISchemeIdentifier( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.weapon_skin )

	return GetGlobalSettingsInt( ItemFlavor_GetAsset( flavor ), "hackyRUISchemeIdentifier" )
}


bool function WeaponSkin_DoesReactToKills( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.weapon_skin )

	return GetGlobalSettingsBool( ItemFlavor_GetAsset( flavor ), "featureReactsToKills" )
}


int function WeaponSkin_GetReactToKillsLevelCount( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.weapon_skin )
	Assert( WeaponSkin_DoesReactToKills( flavor ) )

	var skinBlock = ItemFlavor_GetSettingsBlock( flavor )
	return GetSettingsArraySize( GetSettingsBlockArray( skinBlock, "featureReactsToKillsLevels" ) )
}


WeaponReactiveKillsData function WeaponSkin_GetReactToKillsDataForLevel( ItemFlavor flavor, int levelIdx )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.weapon_skin )
	Assert( WeaponSkin_DoesReactToKills( flavor ) )

	var skinBlock           = ItemFlavor_GetSettingsBlock( flavor )
	var reactsToKillsLevels = GetSettingsBlockArray( skinBlock, "featureReactsToKillsLevels" )
	Assert( levelIdx < GetSettingsArraySize( reactsToKillsLevels ) )
	var levelBlock = GetSettingsArrayElem( reactsToKillsLevels, levelIdx )

	WeaponReactiveKillsData rtked
	rtked.killCount = GetSettingsBlockInt( levelBlock, "killCount" )
	rtked.killSoundEvent1p = GetSettingsBlockString( levelBlock, "killSoundEvent1p" )
	rtked.killSoundEvent3p = GetSettingsBlockString( levelBlock, "killSoundEvent3p" )
	rtked.persistentSoundEvent1p = GetSettingsBlockString( levelBlock, "persistentSoundEvent1p" )
	rtked.persistentSoundEvent3p = GetSettingsBlockString( levelBlock, "persistentSoundEvent3p" )
	rtked.emissiveIntensity = GetSettingsBlockFloat( levelBlock, "emissiveIntensity" )
	foreach ( var killFXBlock in IterateSettingsArray( GetSettingsBlockArray( levelBlock, "killFXList" ) ) )
	{
		rtked.killFX1PList.append( GetSettingsBlockStringAsAsset( killFXBlock, "fx1p" ) )
		rtked.killFX3PList.append( GetSettingsBlockStringAsAsset( killFXBlock, "fx3p" ) )
		rtked.killFXAttachmentList.append( GetSettingsBlockString( killFXBlock, "attachment" ) )
	}
	foreach ( var persistentFXBlock in IterateSettingsArray( GetSettingsBlockArray( levelBlock, "persistentFXList" ) ) )
	{
		rtked.persistentFX1PList.append( GetSettingsBlockStringAsAsset( persistentFXBlock, "fx1p" ) )
		rtked.persistentFX3PList.append( GetSettingsBlockStringAsAsset( persistentFXBlock, "fx3p" ) )
		rtked.persistentFXAttachmentList.append( GetSettingsBlockString( persistentFXBlock, "attachment" ) )
	}
	return rtked
}


asset function WeaponSkin_GetVideo( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.weapon_skin )

	return GetGlobalSettingsStringAsAsset( ItemFlavor_GetAsset( flavor ), "video" )
}

#if SERVER || CLIENT
void function WeaponSkin_Apply( entity ent, ItemFlavor skin )
{
	Assert( ItemFlavor_GetType( skin ) == eItemType.weapon_skin )

	ent.e.__itemFlavorNetworkId = ItemFlavor_GetNetworkIndex_DEPRECATED( skin )
	ent.SetSkin( 0 ) // Lame that we need this, but this avoids invalid skin errors when the model changes and the currently shown skin index doesn't exist for the new model

	#if SERVER
		if ( ent.GetNetworkedClassName() == "prop_survival" )
		{
			ent.SetModel( WeaponSkin_GetWorldModel( skin ) ) // in the world, we want to show the worldmodel

			ent.SetSurvivalProperty( ent.e.__itemFlavorNetworkId ) // TODO: real network values
		}
		else if ( ent.GetNetworkedClassName() == "weaponx" )
		{
			//Assert( ent.GetWeaponClassName() == WeaponItemFlavor_GetClassname( WeaponSkin_GetWeaponFlavor( skin ) ) ) // gold weapons
			ent.SetModel( WeaponSkin_GetWorldModel( skin ) )
			ent.SetLegendaryModelIndex( fileLevel.weaponSkinLegendaryIndexMap[skin] )

			ent.SetGrade( ent.e.__itemFlavorNetworkId ) // TODO: real network values
		}
		else
		{
			Assert( false, "Attempted to apply weapon skin to unexpected entity: " + string(ent.GetNetworkedClassName()) )
		}
	#elseif CLIENT
		Assert( ent.IsClientOnly(), ent + " isn't client only" )
		Assert( ent.GetCodeClassName() == "dynamicprop", ent + " has classname \"" + ent.GetCodeClassName() + "\" instead of \"dynamicprop\"" )

		ent.SetModel( WeaponSkin_GetViewModel( skin ) ) // in the menus, we want to show the viewmodel, because it's the highest LOD
	#endif

	int skinIndex = ent.GetSkinIndexByName( WeaponSkin_GetSkinName( skin ) )
	int camoIndex = WeaponSkin_GetCamoIndex( skin )

	if ( skinIndex == -1 )
	{
		skinIndex = 0
		camoIndex = 0
	}

	ent.SetSkin( skinIndex )
	ent.SetCamo( camoIndex )
}
#endif // SERVER || CLIENT


int function WeaponSkin_GetReactToKillsLevelIndexForKillCount( ItemFlavor flavor, int killCount )
{
	//
	Assert( ItemFlavor_GetType( flavor ) == eItemType.weapon_skin )
	Assert( WeaponSkin_DoesReactToKills( flavor ) )

	var skinBlock = ItemFlavor_GetSettingsBlock( flavor )

	var levelsArr = GetSettingsBlockArray( skinBlock, "featureReactsToKillsLevels" )
	for ( int levelIndex = GetSettingsArraySize( levelsArr ) - 1; levelIndex >= 0; levelIndex-- )
	{
		var levelBlock = GetSettingsArrayElem( levelsArr, levelIndex )
		if ( killCount >= GetSettingsBlockInt( levelBlock, "killCount" ) )
		{
			return levelIndex
		}
	}

	return -1
}


int function WeaponSkin_GetSortOrdinal( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.weapon_skin )

	return fileLevel.cosmeticFlavorSortOrdinalMap[flavor]
}


#if R5DEV && CLIENT
void function DEV_TestWeaponSkinData()
{
	entity model = CreateClientSidePropDynamic( <0, 0, 0>, <0, 0, 0>, $"mdl/dev/empty_model.rmdl" )

	foreach ( weapon in GetAllWeaponItemFlavors() )
	{
		array<ItemFlavor> weaponSkins = GetValidItemFlavorsForLoadoutSlot( LocalClientEHI(), Loadout_WeaponSkin( weapon ) )

		foreach ( skin in weaponSkins )
		{
			printt( ItemFlavor_GetHumanReadableRef( skin ), "skinName:", WeaponSkin_GetSkinName( skin ) )
			WeaponSkin_Apply( model, skin )
		}
	}

	model.Destroy()
}
#endif // DEV && CLIENT