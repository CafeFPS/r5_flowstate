//Made by Julefox#0050
//Fixes by @CafeFPS

global function ShZombieMysteryBoxWeapon_Init

#if SERVER
global function CreateWeaponInMysteryBox
global function GiveWeaponToPlayer
global function ServerWeaponWallUseSuccess
global function SetWeaponMysteryBoxUsable
global function GetWeaponIdx
#endif // SERVER

#if CLIENT
global function ServerCallback_SetWeaponMysteryBoxUsable
#endif // CLIENT

// Consts
const asset  NESSY_MODEL                          = $"mdl/domestic/nessy_doll.rmdl"
const float  MYSTERY_BOX_WEAPON_ON_USE_DURATION   = 0.0
const string MYSTERY_BOX_TAKE_WEAPON              = "to take %s\n"
global const string MYSTERY_BOX_WEAPON_SCRIPT_NAME       = "MysteryBoxWeaponScriptName"
const string USE                                  = "Press %use% "

#if CLIENT
const asset MYSTERY_BOX_DISPLAYRUI = $"ui/extended_use_hint.rpak"
#endif // CLIENT

// Init
void function ShZombieMysteryBoxWeapon_Init()
{
	#if SERVER
	PrecacheModel( NESSY_MODEL )
	#endif // SERVER
}

// Check by script name if it is a weapon in a mystery box
bool function IsValidWeaponMysteryBox( entity ent )
{
	if ( ent.GetScriptName() == MYSTERY_BOX_WEAPON_SCRIPT_NAME )
		return true

	return false
}

// Set weapon usable
#if SERVER
void function SetWeaponMysteryBoxUsable( entity weaponMysteryBox )
{
	if ( !IsValidWeaponMysteryBox( weaponMysteryBox ) )
		return

	weaponMysteryBox.SetUsable()
	weaponMysteryBox.SetUsableByGroup( "pilot" )
	weaponMysteryBox.SetUsableValue( USABLE_BY_ALL | USABLE_CUSTOM_HINTS ) //( USABLE_BY_ALL | USABLE_CUSTOM_HINTS )
	weaponMysteryBox.SetUsablePriority( USABLE_PRIORITY_MEDIUM )

	SetCallback_CanUseEntityCallback( weaponMysteryBox, WeaponMysteryBox_CanUse )
	AddCallback_OnUseEntity( weaponMysteryBox, OnUseProcessingWeaponMysteryBox )
}
#endif // SERVER

#if CLIENT
// Set weapon usable
void function ServerCallback_SetWeaponMysteryBoxUsable( entity weaponMysteryBox )
{
	if ( !IsValidWeaponMysteryBox( weaponMysteryBox ) )
		return

	SetCallback_CanUseEntityCallback( weaponMysteryBox, WeaponMysteryBox_CanUse )
	AddCallback_OnUseEntity( weaponMysteryBox, OnUseProcessingWeaponMysteryBox )

	AddEntityCallback_GetUseEntOverrideText( weaponMysteryBox, WeaponMysteryBox_TextOverride )
}
#endif

// If is usable
bool function WeaponMysteryBox_CanUse( entity player, entity weaponMysteryBox )
{
	entity mover = weaponMysteryBox.GetParent()
	entity lootbin = mover.GetParent()

	if( player.IsShadowForm() )
		return false

	if ( !SURVIVAL_PlayerCanUse_AnimatedInteraction( player, weaponMysteryBox ) )
		return false
	
	if( player != lootbin.GetOwner() )
		return false
	
	return true
}

// Callback if the weapon is used
void function OnUseProcessingWeaponMysteryBox( entity weaponMysteryBox, entity playerUser, int useInputFlags )
{
	if ( !( useInputFlags & USE_INPUT_LONG ) )
		return

	ExtendedUseSettings settings
	settings.duration             = MYSTERY_BOX_WEAPON_ON_USE_DURATION
	settings.useInputFlag         = IN_USE_LONG
	settings.successFunc          = WeaponMysteryBoxUseSuccess

	#if CLIENT
		settings.hint             = "#HINT_VAULT_UNLOCKING"
		settings.displayRui       = MYSTERY_BOX_DISPLAYRUI
		settings.displayRuiFunc   = MysteryBox_DisplayRui
	#endif // CLIENT

	thread ExtendedUse( weaponMysteryBox, playerUser, settings )
}

// If the callback is a success
void function WeaponMysteryBoxUseSuccess( entity weaponMysteryBox, entity player, ExtendedUseSettings settings )
{
	CustomZombieMysteryBox mysteryBoxStruct = GetMysteryBoxFromEnt( weaponMysteryBox )
	
	#if SERVER
		ServerWeaponWallUseSuccess( weaponMysteryBox, player )
	#endif // SERVER
}


#if CLIENT
// Text override
string function WeaponMysteryBox_TextOverride( entity weaponMysteryBox )
{
	int weaponIdx       = GetWeaponIdx( weaponMysteryBox )
	string weaponName   = eWeaponZombieName[ weaponIdx ][ 1 ]
	
	return USE + format( MYSTERY_BOX_TAKE_WEAPON, weaponName )
}
#endif // CLIENT


#if SERVER
// Create weapon in mystery box
entity function CreateWeaponInMysteryBox( int index, vector pos, vector ang, string targetName)
{
	entity weapon = CreateEntity( "prop_dynamic" )
	weapon.SetModel( eWeaponZombieModel[ index ] )
	weapon.SetModelScale( 1.25 )
	weapon.SetScriptName( MYSTERY_BOX_WEAPON_SCRIPT_NAME )
	weapon.NotSolid()
	weapon.SetFadeDistance( 20000 )
	weapon.SetOrigin( pos )
	weapon.SetAngles( ang )
	SetTargetName( weapon, targetName )

	DispatchSpawn( weapon )

	return weapon
}

// Gives a weapon depending on the configuration of the player's inventory
void function ServerWeaponWallUseSuccess( entity usableWeaponWall, entity player )
{
	entity weapon
	int weaponIdx = GetWeaponIdx( usableWeaponWall )
	string weaponName = eWeaponZombieName[ weaponIdx ][ 0 ]

	entity primary = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 )
	entity secondary = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_1 )
	int activeWeaponInt = SURVIVAL_GetActiveWeaponSlot( player )
	entity activeWeapon = player.GetNormalWeapon( activeWeaponInt )

	if  ( primary == null || !player.p.hasSecondaryWeaponPerk) 
	{
		if(IsValid(primary && !player.p.hasSecondaryWeaponPerk))
		{
			player.TakeNormalWeaponByIndexNow( WEAPON_INVENTORY_SLOT_PRIMARY_0 )
		}
		weapon = GiveWeaponToPlayer( player, weaponName, WEAPON_INVENTORY_SLOT_PRIMARY_0 )
	}
	else if ( secondary == null && player.p.hasSecondaryWeaponPerk) 
	{
		weapon = GiveWeaponToPlayer( player, weaponName, WEAPON_INVENTORY_SLOT_PRIMARY_1 )
	}
	else if ( IsValid( activeWeapon ) )
	{
		weapon = SwapWeaponToPlayer( player, activeWeapon, weaponName, activeWeaponInt )
	}

	// if ( weapon != null ) weapon.AddMod( "survival_finite_ammo" )

	if ( PlayerHasWeapon( player, weaponName ) ) player.SetActiveWeaponByName( eActiveInventorySlot.mainHand, weaponName )

	Remote_CallFunction_NonReplay( player, "ServerCallback_RefreshInventory" )
	
	if(IsValid(usableWeaponWall))
		usableWeaponWall.Destroy()
	
	if( IsValid(weapon) && player.p.hasQuickReloadPerk )
	{
		array<string> mods = weapon.GetMods()
		mods.append( "infectionPerkQuickReload" )
		try{weapon.SetMods( mods )} catch(e42069){printt(weapon.GetWeaponClassName() + " failed to put quick reload mod.")}
	}
	
	if( IsValid(weapon) && player.p.hasBetterMagsPerk )
	{
		array<string> mods = weapon.GetMods()
		foreach(mag in InfectionMags)
		{
			if( CanAttachToWeapon( mag, weapon.GetWeaponClassName() ) )
				mods.append( mag )
		}
		try{weapon.SetMods( mods )} catch(e42069){printt(weapon.GetWeaponClassName() + " failed to put mag mod.")}
	}
}

// Give a weapon to the player without swap
entity function GiveWeaponToPlayer( entity player, string weaponName, int inventorySlot )
{
	entity weapon
	entity pickup
	
	weapon = player.GiveWeapon( weaponName, inventorySlot )

	return weapon
}


// Give a weapon to the player with swap
entity function SwapWeaponToPlayer( entity player, entity weaponSwap, string weaponName, int inventorySlot )
{
	entity weapon

	player.TakeWeaponByEntNow( weaponSwap )
	weapon = player.GiveWeapon( weaponName, inventorySlot )

	return weapon
}
#endif // SERVER

// Get the weapon index
int function GetWeaponIdx( entity usableWeaponWall )
{
	int weaponIdx ; asset modelName = usableWeaponWall.GetModelName()

	for ( int i = 0 ; i < eWeaponZombieModel.len() ; i++  )
	{
		if ( modelName == eWeaponZombieModel[ i ] )
			weaponIdx = i
	}

	return weaponIdx
}