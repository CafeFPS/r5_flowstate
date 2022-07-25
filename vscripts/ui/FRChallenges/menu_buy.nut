global function InitArenasBuyMenu
global function OpenBuyMenu
global function UpdateBuyMenu
global function SetBoughtWeapons
global function UpdateBuyMenuTimer
global function UpdateWeaponUpgrades

struct
{
	var menu
	var buymenu1
	var buymenu2
	var buymenu3

    var header
    var text

    var ArmorDisplay
    var HelmetDisplay

	string boughtprimary = ""
	string boughtsecondary = ""
    int primarylvl = 0
    int secondarylvl = 0

	bool tabsInitialized = false

} file

void function OpenBuyMenu()
{
	CloseAllMenus()
	AdvanceMenu( file.menu )
}

void function SetBoughtWeapons(string weapon, int slot)
{

	if (slot == 0)
	{
		file.boughtprimary = weapon
	}
	else if (slot == 1)
	{
		file.boughtsecondary = weapon
	}

	UpdateUIWeapons()
}

void function UpdateBuyMenu(int points, string primary, string secondary, int primarylvl, int secondarylvl)
{
	var menupoints = Hud_GetChild( file.menu, "PointsText" )
	Hud_SetText(menupoints, points.tostring())

	file.boughtprimary = primary
	file.boughtsecondary = secondary

    file.primarylvl = primarylvl
    file.secondarylvl = secondarylvl

	UpdateUIWeapons()
}

void function UpdateWeaponUpgrades(int upgradedlvl, string weapon)
{
    UpdateWeaponUpgradesMenu1(weapon, upgradedlvl)
}

void function UpdateBuyMenuTimer(int timeleft)
{
	var menutimer = Hud_GetChild( file.menu, "TimerText" )
	Hud_SetText(menutimer, timeleft.tostring())

	if (timeleft == 0)
	{
		var panel = GetPanel( "SurvivalQuickInventoryPanel" )
		if ( Hud_IsVisible( panel ) )
		{
			BuyPanel1_NavigateBack()
			return
		}

		CloseActiveMenu()
	}
}

void function UpdateUIWeapons()
{
	var primarytext = Hud_GetChild( file.menu, "PrimaryWeapon" )
    if(GetWeaponNameForUI(file.boughtprimary) == "") {
        Hud_SetText(primarytext, "Primary: " + GetWeaponNameForUI(file.boughtprimary))
    } else {
        Hud_SetText(primarytext, "Primary: " + GetWeaponNameForUI(file.boughtprimary) + " Lvl " + file.primarylvl)
    }

	var secondarytext = Hud_GetChild( file.menu, "SecondaryWeapon")
    if(GetWeaponNameForUI(file.boughtsecondary) == "") {
        Hud_SetText(secondarytext, "Secondary: " +  GetWeaponNameForUI(file.boughtsecondary))
    } else {
        Hud_SetText(secondarytext, "Secondary: " +  GetWeaponNameForUI(file.boughtsecondary) + " Lvl " + file.secondarylvl)
    }

	var PrimaryRUI = Hud_GetRui( Hud_GetChild( file.menu, "PrimaryWeaponImg" ) )
	RuiSetImage( PrimaryRUI, "basicImage", GetWeaponAssetFromName(file.boughtprimary) )

	var SecondaryRUI = Hud_GetRui( Hud_GetChild( file.menu, "SecondaryWeaponImg" ) )
	RuiSetImage( SecondaryRUI, "basicImage", GetWeaponAssetFromName(file.boughtsecondary) )
}

void function InitArenasBuyMenu( var newMenuArg )
{
	var menu = GetMenu( "BuyMenu" )
	file.menu = menu

    AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, OnR5RSB_Show )
	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnR5RSB_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnR5RSB_Close )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnR5RSB_NavigateBack )

	file.buymenu1 = GetPanel( "BuyMenu1" )
	file.buymenu2 = GetPanel( "BuyMenu2" )
	file.buymenu3 = GetPanel( "BuyMenu3" )

	var pointsbg = Hud_GetRui( Hud_GetChild( file.menu, "PointsBGImage" ) )
	RuiSetImage( pointsbg, "basicImage", $"rui/hud/gametype_icons/control/control_ratings" )

	var timerLB = Hud_GetRui( Hud_GetChild( file.menu, "TimerFrameLeftBracket" ) )
	RuiSetImage( timerLB, "basicImage", $"rui/menu/inventory/backpack_container_side_bracket" )

	var timerRB = Hud_GetRui( Hud_GetChild( file.menu, "TimerFrameRightBracket" ) )
	RuiSetImage( timerRB, "basicImage", $"rui/menu/inventory/backpack_container_side_bracket" )
	HudElem_SetChildRuiArg( file.menu, "TimerFrameRightBracket", "imageRotation", 0.5, eRuiArgType.FLOAT )


	var Ebtn1 = Hud_GetRui( Hud_GetChild( file.menu, "EquipmentButton4" ) )
	RuiSetImage( Ebtn1, "iconImage", $"rui/hud/loot/loot_stim_shield_small" )
    RuiSetInt( Ebtn1, "count", 8 )

	var Ebtn2 = Hud_GetRui( Hud_GetChild( file.menu, "EquipmentButton3" ) )
	RuiSetImage( Ebtn2, "iconImage", $"rui/hud/loot/loot_stim_shield_large" )
    RuiSetInt( Ebtn2, "count", 4 )

	var Ebtn3 = Hud_GetRui( Hud_GetChild( file.menu, "EquipmentButton2" ) )
	RuiSetImage( Ebtn3, "iconImage", $"rui/hud/loot/loot_stim_health_small" )
    RuiSetInt( Ebtn3, "count", 8 )

	var Ebtn4 = Hud_GetRui( Hud_GetChild( file.menu, "EquipmentButton1" ) )
	RuiSetImage( Ebtn4, "iconImage", $"rui/hud/loot/loot_stim_health_large" )
    RuiSetInt( Ebtn4, "count", 4 )

	var Ebtn5 = Hud_GetRui( Hud_GetChild( file.menu, "EquipmentButton8" ) )
	RuiSetImage( Ebtn5, "iconImage", $"rui/hud/loot/loot_stim_combo_full" )
    RuiSetInt( Ebtn5, "count", 2 )

	var Ebtn6 = Hud_GetRui( Hud_GetChild( file.menu, "EquipmentButton7" ) )
	RuiSetImage( Ebtn6, "iconImage", $"rui/ordnance_icons/grenade_frag" )
    RuiSetInt( Ebtn6, "count", 8 )

	var Ebtn7 = Hud_GetRui( Hud_GetChild( file.menu, "EquipmentButton6" ) )
	RuiSetImage( Ebtn7, "iconImage", $"rui/ordnance_icons/grenade_incendiary" )
    RuiSetInt( Ebtn7, "count", 8 )

	var Ebtn8 = Hud_GetRui( Hud_GetChild( file.menu, "EquipmentButton5" ) )
	RuiSetImage( Ebtn8, "iconImage", $"rui/ordnance_icons/grenade_arc" )
    RuiSetInt( Ebtn8, "count", 8 )

	file.ArmorDisplay = Hud_GetRui( Hud_GetChild( file.menu, "Armor" ) )
	RuiSetImage( file.ArmorDisplay, "iconImage", $"rui/hud/loot/loot_armor_3" )
	RuiSetInt( file.ArmorDisplay, "lootTier", 3 )
    RuiSetInt( file.ArmorDisplay, "count", 4 )

	file.HelmetDisplay = Hud_GetRui( Hud_GetChild( file.menu, "Helmet" ) )
	RuiSetImage( file.HelmetDisplay, "iconImage", $"rui/hud/loot/loot_helmet_3" )
	RuiSetInt( file.HelmetDisplay, "lootTier", 3 )
}

void function OnR5RSB_Show()
{
    //
}

void function OnR5RSB_Open()
{
    if ( !file.tabsInitialized )
	{
		TabData tabData = GetTabDataForPanel( file.menu )
		tabData.centerTabs = true
		AddTab( file.menu, file.buymenu1, "Pistols, Shotguns & SMGs" )
		AddTab( file.menu, file.buymenu2, "Assault Rifles & LMGs" )
		AddTab( file.menu, file.buymenu3, "Marksman & Snipers" )
		file.tabsInitialized = true
	}

	SetTabNavigationEnabled( file.menu, true )
	EmitUISound( "UI_InGame_Inventory_Open" )

	TabData tabData = GetTabDataForPanel( file.menu )
	ActivateTab( tabData, 0 )
}


void function OnR5RSB_Close()
{
	RunClientScript( "UIToClient_CloseBuyMenu")
}

void function OnR5RSB_NavigateBack()
{
	var panel = GetPanel( "SurvivalQuickInventoryPanel" )
	if ( Hud_IsVisible( panel ) )
	{
		BuyPanel1_NavigateBack()
		return
	}

	CloseActiveMenu()

    RunClientScript( "UIToClient_CloseBuyMenu")
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