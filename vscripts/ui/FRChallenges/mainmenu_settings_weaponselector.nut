global function InitFRChallengesSettingsWpnSelector
global function OpenFRChallengesSettingsWpnSelector
global function CloseFRChallengesSettingsWpnSelector
global function GetWeaponClassByName
global function EnableBuyWeaponsMenuTabs
global function DisableBuyWeaponsMenuTabs

struct
{
	var menu
	var buymenu1
	var buymenu2
	var buymenu3
	var buymenu4
} file

void function OpenFRChallengesSettingsWpnSelector()
{
	EmitUISound( "UI_InGame_Inventory_Open" )
	AdvanceMenu( file.menu )
	TabData tabData = GetTabDataForPanel( file.menu )
	ActivateTab( tabData, 1 )
	ActivateTab( tabData, 0 )
}

void function CloseFRChallengesSettingsWpnSelector()
{
	CloseAllMenus()
}

void function InitFRChallengesSettingsWpnSelector( var newMenuArg )
{
	var menu = GetMenu( "FRChallengesSettingsWpnSelector" )
	file.menu = menu
	
    AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, OnR5RSB_Show )
	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnR5RSB_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnR5RSB_Close )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnR5RSB_NavigateBack )
	
	AddButtonEventHandler( Hud_GetChild( file.menu, "GoBackButton"), UIE_CLICK, GoBackButtonFunct )
	
	file.buymenu1 = GetPanel( "BuyMenu1" )
	file.buymenu2 = GetPanel( "BuyMenu2" )
	file.buymenu3 = GetPanel( "BuyMenu3" )
	file.buymenu4 = GetPanel( "BuyMenu4" )
	
	TabData tabData = GetTabDataForPanel( file.menu )
	tabData.centerTabs = true
	AddTab( file.menu, file.buymenu1, "Pistols, Shotguns & SMGs" )
	AddTab( file.menu, file.buymenu2, "Assault Rifles & LMGs" )
	AddTab( file.menu, file.buymenu3, "Marksman & Snipers" )
	AddTab( file.menu, file.buymenu4, "Custom" )

	SetTabNavigationEnabled( file.menu, true )
	EmitUISound( "UI_InGame_Inventory_Open" )

	ActivateTab( tabData, 1 )
	ActivateTab( tabData, 0 )
}

void function DisableBuyWeaponsMenuTabs()
{
	SetTabNavigationEnabled( file.menu, false )
}

void function EnableBuyWeaponsMenuTabs()
{
	SetTabNavigationEnabled( file.menu, true )
}

void function GoBackButtonFunct(var button)
{
	CloseAllMenus()
	RunClientScript("CloseFRChallengesSettingsWpnSelector")
	RunClientScript("ServerCallback_OpenFRChallengesSettings")	
}

void function OnR5RSB_Show()
{
    //
}

void function OnR5RSB_Open()
{
	//
}


void function OnR5RSB_Close()
{
	//
}

void function OnR5RSB_NavigateBack()
{
	CloseAllMenus()
	RunClientScript("CloseFRChallengesSettingsWpnSelector")
	RunClientScript("ServerCallback_OpenFRChallengesSettings")	
}


string function GetWeaponClassByName(string weapon)
{
	string finalClass

	switch(weapon)
    {
        case "mp_weapon_semipistol":
            finalClass = "pistol"
            break
        case "mp_weapon_shotgun_pistol":
            finalClass = "shotgun"
            break
        case "mp_weapon_wingman":
            finalClass = "pistol"
            break
        case "mp_weapon_autopistol":
            finalClass = "pistol"
            break
        case "mp_weapon_alternator_smg":
            finalClass = "smg"
            break
        case "mp_weapon_r97":
            finalClass = "smg"
            break
        case "mp_weapon_shotgun":
            finalClass = "shotgun"
            break
        case "mp_weapon_mastiff":
            finalClass = "shotgun"
            break
        case "mp_weapon_energy_shotgun":
            finalClass = "shotgun"
            break
        case "mp_weapon_energy_ar":
            finalClass = "ar"
            break
        case "mp_weapon_lstar":
            finalClass = "ar"
            break
        case "mp_weapon_esaw":
            finalClass = "lmg"
            break
        case "mp_weapon_hemlok":
            finalClass = "ar"
            break
        case "mp_weapon_vinson":
            finalClass = "ar"
            break
        case "mp_weapon_lmg":
            finalClass = "lmg"
            break
        case "mp_weapon_rspn101":
            finalClass = "ar"
            break
        case "mp_weapon_g2":
            finalClass = "marksman"
            break
        case "mp_weapon_dmr":
            finalClass = "sniper"
            break
        case "mp_weapon_doubletake":
            finalClass = "marksman"
            break
        case "mp_weapon_defender":
            finalClass = "sniper"
            break
        case "mp_weapon_sniper":
            finalClass = "sniper"
            break
		default:
			finalClass = ""
    }

	return finalClass
}

asset function GetWeaponAssetFromName(string weapon)
{
	asset weaponasset

	switch(weapon)
    {
        case "mp_weapon_semipistol":
            weaponasset = $"rui/weapon_icons/r5/weapon_p2020"
            break
        case "mp_weapon_shotgun_pistol":
            weaponasset = $"rui/weapon_icons/r5/weapon_mozambique"
            break
        case "mp_weapon_wingman":
            weaponasset = $"rui/weapon_icons/r5/weapon_wingman"
            break
        case "mp_weapon_autopistol":
            weaponasset = $"rui/weapon_icons/r5/weapon_r45"
            break
        case "mp_weapon_alternator_smg":
            weaponasset = $"rui/weapon_icons/r5/weapon_alternator"
            break
        case "mp_weapon_r97":
            weaponasset = $"rui/weapon_icons/r5/weapon_r97"
            break
        case "mp_weapon_shotgun":
            weaponasset = $"rui/weapon_icons/r5/weapon_eva8"
            break
        case "mp_weapon_mastiff":
            weaponasset = $"rui/weapon_icons/r5/weapon_mastiff"
            break
        case "mp_weapon_energy_shotgun":
            weaponasset = $"rui/weapon_icons/r5/weapon_peacekeeper"
            break
        case "mp_weapon_energy_ar":
            weaponasset = $"rui/weapon_icons/r5/weapon_energy_ar"
            break
        case "mp_weapon_lstar":
            weaponasset = $"rui/weapon_icons/r5/weapon_lstar"
            break
        case "mp_weapon_esaw":
            weaponasset = $"rui/weapon_icons/r5/weapon_devotion"
            break
        case "mp_weapon_hemlok":
            weaponasset = $"rui/weapon_icons/r5/weapon_hemlock"
            break
        case "mp_weapon_vinson":
            weaponasset = $"rui/weapon_icons/r5/weapon_flatline"
            break
        case "mp_weapon_lmg":
            weaponasset = $"rui/weapon_icons/r5/weapon_spitfire"
            break
        case "mp_weapon_rspn101":
            weaponasset = $"rui/weapon_icons/r5/weapon_r301"
            break
        case "mp_weapon_g2":
            weaponasset = $"rui/weapon_icons/r5/weapon_g7"
            break
        case "mp_weapon_dmr":
            weaponasset = $"rui/weapon_icons/r5/weapon_longbow"
            break
        case "mp_weapon_doubletake":
            weaponasset = $"rui/weapon_icons/r5/weapon_triple_take"
            break
        case "mp_weapon_defender":
            weaponasset = $"rui/weapon_icons/r5/weapon_charge_rifle"
            break
		default:
			weaponasset = $""
    }

	return weaponasset
}

string function GetWeaponNameForUI(string weapon)
{
	string weaponname

	switch(weapon)
    {
        case "mp_weapon_semipistol":
            weaponname = "P2020"
            break
        case "mp_weapon_shotgun_pistol":
            weaponname = "Mozambique"
            break
        case "mp_weapon_wingman":
            weaponname = "Wingman"
            break
        case "mp_weapon_autopistol":
            weaponname = "RE-45"
            break
        case "mp_weapon_alternator_smg":
            weaponname = "Alternator"
            break
        case "mp_weapon_r97":
            weaponname = "R-99"
            break
        case "mp_weapon_shotgun":
            weaponname = "EVA-8"
            break
        case "mp_weapon_mastiff":
            weaponname = "Mastiff"
            break
        case "mp_weapon_energy_shotgun":
            weaponname = "PeaceKeeper"
            break
        case "mp_weapon_energy_ar":
            weaponname = "Havoc"
            break
        case "mp_weapon_lstar":
            weaponname = "L-Star"
            break
        case "mp_weapon_esaw":
            weaponname = "Devotion"
            break
        case "mp_weapon_hemlok":
            weaponname = "Hemlock"
            break
        case "mp_weapon_vinson":
            weaponname = "Flatline"
            break
        case "mp_weapon_lmg":
            weaponname = "Spitfire"
            break
        case "mp_weapon_rspn101":
            weaponname = "R-301"
            break
        case "mp_weapon_g2":
            weaponname = "G7 Scout"
            break
        case "mp_weapon_dmr":
            weaponname = "Longbow"
            break
        case "mp_weapon_doubletake":
            weaponname = "Triple Take"
            break
        case "mp_weapon_defender":
            weaponname = "Charge Rifle"
            break
		default:
			weaponname = ""
    }

	return weaponname
}