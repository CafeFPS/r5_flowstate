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