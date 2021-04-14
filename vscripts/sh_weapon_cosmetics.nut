global function ShWeaponCosmetics_LevelInit

global function Loadout_WeaponSkin
global function WeaponSkin_GetWorldModel
global function WeaponSkin_GetViewModel
global function WeaponSkin_GetSkinName
global function WeaponSkin_GetCamoIndex
global function WeaponSkin_GetSortOrdinal
global function WeaponSkin_GetWeaponFlavor
#if SERVER
global function AddCallback_UpdatePlayerWeaponCosmetics
#endif
#if SERVER || CLIENT
global function WeaponSkin_Apply
#endif
#if DEV && CLIENT
global function DEV_TestWeaponSkinData
#endif


//////////////////////
//////////////////////
//// Global Types ////
//////////////////////
//////////////////////
//


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

	table<ItemFlavor, int> cosmeticFlavorSortOrdinalMap

	#if SERVER || CLIENT
		table<ItemFlavor, table<asset, int> > weaponModelLegendaryIndexMapMap
		table<ItemFlavor, int>                weaponSkinLegendaryIndexMap
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
		array<ItemFlavor> skinList = RegisterReferencedItemFlavorsFromArray( weaponFlavor, "skins", "flavor" )
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
		#if SERVER && DEV
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


///////////////////
///////////////////
//// Internals ////
///////////////////
///////////////////
#if SERVER
void function UpdatePlayerWeaponCosmetics( entity player, ItemFlavor weaponFlavor, ItemFlavor skin )
{
	#if DEV
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


int function WeaponSkin_GetSortOrdinal( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.weapon_skin )

	return fileLevel.cosmeticFlavorSortOrdinalMap[flavor]
}


#if DEV && CLIENT
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