global function InitFRChallengesSettingsWpnSelector
global function OpenFRChallengesSettingsWpnSelector
global function CloseFRChallengesSettingsWpnSelector
global function EnableBuyWeaponsMenuTabs
global function DisableBuyWeaponsMenuTabs
global function GetWeaponNameForUI

struct
{
	var menu
	var buymenu1
	var buymenu2
	var buymenu3
	var buymenu4
	var buymenu5
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
	file.buymenu5 = GetPanel( "BuyMenu5" )
	
	TabData tabData = GetTabDataForPanel( file.menu )
	tabData.centerTabs = true
	
	AddTab( file.menu, file.buymenu1, "Pistols & Shotguns" )
	AddTab( file.menu, file.buymenu5, "SMGs" )
	AddTab( file.menu, file.buymenu2, "Assault Rifles & LMGs" )
	AddTab( file.menu, file.buymenu3, "Marksman & Snipers" )
	AddTab( file.menu, file.buymenu4, "Hitscan Weapons" )
	
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
	CloseAllAttachmentsBoxes()
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
	CloseAllAttachmentsBoxes()
	CloseAllMenus()
	RunClientScript("CloseFRChallengesSettingsWpnSelector")
	RunClientScript("ServerCallback_OpenFRChallengesSettings")	
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
            weaponname = "Peacekeeper"
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
            weaponname = "Hemlok"
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
		case "mp_weapon_sniper":
			weaponname = "Kraber"
			break
		case "mp_weapon_volt_smg":
			weaponname = "Volt"
			break
		case "mp_weapon_dragon_lmg":
			weaponname = "Rampage"
			break
		case "mp_weapon_car":
			weaponname = "Car"
			break
		case "mp_weapon_clickweapon":
			weaponname = "Hitscan"
			break
		case "mp_weapon_clickweaponauto":
			weaponname = "Hitscan Auto"
			break
		default:
			weaponname = ""
    }

	return weaponname
}