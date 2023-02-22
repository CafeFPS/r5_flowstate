global function Sh_Init_WeaponMods

#if CLIENT
global function UpdateWeaponMods
global function CL_OnCloseWeaponModsMenu

const array<string> moddableweapons = [
    "mp_weapon_alternator_smg",
    "mp_weapon_dmr",
    "mp_weapon_doubletake",
    "mp_weapon_energy_shotgun",
    "mp_weapon_lmg",
    "mp_weapon_lstar",
    "mp_weapon_mastiff",
    "mp_weapon_shotgun",
    "mp_weapon_shotgun_pistol",
    "mp_weapon_sniper",
    "mp_weapon_r97",
    "mp_weapon_hemlok",
    "mp_weapon_autopistol",
    "mp_weapon_wingman",
    "mp_weapon_vinson",
    "mp_weapon_pdw",
    "mp_weapon_g2",
    "mp_weapon_energy_ar",
    "mp_weapon_esaw",
    "mp_weapon_semipistol",
    "mp_weapon_rspn101",
    "mp_weapon_defender",
    "mp_weapon_sentinel",
    "mp_weapon_volt_smg",
    "mp_weapon_smart_pistol"
]

struct
{
    entity camera
    entity weapon
    entity backpack
    entity light
} weaponworkshop
#endif

void function Sh_Init_WeaponMods()
{
	#if SERVER
		RegisterClientCommands()
	#endif

	#if CLIENT
		RegisterInputPressed()
	#endif
}

#if SERVER
void function RegisterClientCommands()
{
	AddClientCommandCallback("UpdateWeaponMods", ClientCommand_UpdateWeaponMods)
}

bool function ClientCommand_UpdateWeaponMods(entity player, array<string> args)
{
    if( !IsValid( player ) )
        return false

    if(args.len() == 0)
        return false

    int activeSlot = SURVIVAL_GetActiveWeaponSlot( player )

    array<string> blacklistedmods = split( GetCurrentPlaylistVarString( "weaponmodsmenu_blacklist", "" ), " " )
	foreach(string blacklistmod in blacklistedmods)
    {
        if(args.find(blacklistmod) != -1)
            return false
    }
    
    array<string> weaponmods
    foreach(int i, arg in args)
    {
        if(i != 0)
            weaponmods.append(arg)
    }

    entity activeWeapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
    int clipcount = activeWeapon.GetWeaponPrimaryClipCount()
    string weaponclassname = activeWeapon.GetWeaponClassName()
    player.TakeWeaponNow( weaponclassname )
    player.GiveWeapon( args[0], activeSlot, weaponmods )

    if(clipcount > player.GetActiveWeapon( eActiveInventorySlot.mainHand ).GetWeaponPrimaryClipCountMax())
        clipcount = player.GetActiveWeapon( eActiveInventorySlot.mainHand ).GetWeaponPrimaryClipCountMax()

    player.GetActiveWeapon( eActiveInventorySlot.mainHand ).SetWeaponPrimaryClipCount( clipcount )

    return true
}
#endif

#if CLIENT
void function RegisterInputPressed()
{
	RegisterConCommandTriggeredCallback( "weapon_inspect", OnInspectKeyPressed )
}

void function OnInspectKeyPressed( entity localPlayer )
{
    entity weapon = localPlayer.GetActiveWeapon( eActiveInventorySlot.mainHand )
    if ( !IsValid( weapon ) )
		return

    if(moddableweapons.find(weapon.GetWeaponClassName()) == -1)
        return

    string finishedmods = ""

    string blacklistedweaponmods = GetCurrentPlaylistVarString( "weaponmodsmenu_blacklist", "" )

    array<string> currentmods = weapon.GetMods()
    foreach(int i, string mod in currentmods)
        finishedmods += mod + " "

    DoF_SetFarDepth( 1, 600 )

    SetupWorkshop(localPlayer, weapon, currentmods)

    RunUIScript( "UpdateBlacklistedWeaponMenuMods", GetCurrentPlaylistVarString( "weaponmodsmenu_blacklist", "" ) )
    RunUIScript( "SetCurrentModsMenuWeapon", weapon.GetWeaponClassName(), rstrip(finishedmods) )
    RunUIScript( "OpenWeaponModsMenu" )
}

void function SetupWorkshop(entity localPlayer, entity weapon, array<string> mods)
{
    vector BaseOrigin = OriginToGround(localPlayer.GetOrigin() + <0, 0, 50>)
    //SetupTBackpack
    weaponworkshop.backpack = CreatePropDynamic( $"mdl/humans_r5/loot/w_loot_char_backpack_heavy.rmdl", BaseOrigin + < 0, -0.3665, 7.3965 >, < 73.7625, -90, 0 > )

    //SetupCamera
    weaponworkshop.camera = CreateClientSidePointCamera( BaseOrigin + < -15, -41.6000, 22 >, < 25.2111, 70, 0 >, 80 )
    localPlayer.SetMenuCameraEntityWithAudio( weaponworkshop.camera )

    //SetupWeapon
    vector offset = < 15, -12, 22 >
    switch(weapon.GetWeaponClassName())
    {
        case "mp_weapon_sentinel":
        case "mp_weapon_dmr":
        case "mp_weapon_g2":
        case "mp_weapon_doubletake":
            offset = < 13, 8, 60 >
            break;
        case "mp_weapon_sniper":
            offset = < 20, 8, 60 >
            break;
    }
    
    weaponworkshop.weapon = CreatePropDynamic( weapon.GetModelName(), BaseOrigin + offset, < 0, 164.1270, 23.9480 > )
    SetBodyGroupsForWeaponConfig( weaponworkshop.weapon, weapon.GetWeaponClassName(), mods )
}

void function UpdateWeaponMods(string mods)
{
    entity weapon = GetLocalClientPlayer().GetActiveWeapon( eActiveInventorySlot.mainHand )
    if ( !IsValid( weapon ) )
        return
    
    GetLocalClientPlayer().ClientCommand("UpdateWeaponMods " + weapon.GetWeaponClassName() + " " + mods)

    RunUIScript( "SetCurrentModsMenuWeapon", weapon.GetWeaponClassName(), mods )
    RunUIScript( "OnWeaponsMenuOpen")

    array<string> splitmods = split( mods, " " )
    SetBodyGroupsForWeaponConfig( weaponworkshop.weapon, weapon.GetWeaponClassName(), splitmods )
}

void function CL_OnCloseWeaponModsMenu()
{
    DoF_SetNearDepthToDefault()
	DoF_SetFarDepthToDefault()

    GetLocalClientPlayer().ClearMenuCameraEntity()

    if(IsValid(weaponworkshop.backpack))
        weaponworkshop.backpack.Destroy()
    
    if(IsValid(weaponworkshop.camera))
        weaponworkshop.camera.Destroy()

    if(IsValid(weaponworkshop.weapon))
        weaponworkshop.weapon.Destroy()
}
#endif