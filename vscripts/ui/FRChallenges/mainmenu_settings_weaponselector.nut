global function InitFRChallengesSettingsWpnSelector
global function OpenFRChallengesSettingsWpnSelector
global function CloseFRChallengesSettingsWpnSelector
global function EnableBuyWeaponsMenuTabs
global function DisableBuyWeaponsMenuTabs
global function GetWeaponNameForUI
global function SetWeaponSwitcherVisible

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
	Hud_SetText( Hud_GetChild( file.menu, "Title" ), Gamemode() == eGamemodes.WINTEREXPRESS ? "" : "FLOWSTATE AIM TRAINER" )
	Hud_SetText( Hud_GetChild( file.menu, "MadeBy" ), Gamemode() == eGamemodes.WINTEREXPRESS ? "R5R Winter Express implemented by @CafeFPS %$rui/flowstate_custom/colombia_flag_papa%" : "v1.31 | %$rui/flowstate_custom/colombia_flag_papa% Made in Colombia by @CafeFPS" )
	EmitUISound( "UI_InGame_Inventory_Open" )
	AdvanceMenu( file.menu )
	TabData tabData = GetTabDataForPanel( file.menu )
	ActivateTab( tabData, 1 )
	ActivateTab( tabData, 0 )
	
	Hud_SetSelected( Hud_GetChild( file.menu, "SelectPrimaryWeapon"), true )
	Hud_SetSelected( Hud_GetChild( file.menu, "SelectSecondaryWeapon"), false )
	RunClientScript("SetWeaponSlot", 1)	
	SetWeaponSwitcherVisible( true )
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
	
	AddButtonEventHandler( Hud_GetChild( file.menu, "SelectPrimaryWeapon"), UIE_CLICK, SelectPrimaryWeaponFunct )
	AddButtonEventHandler( Hud_GetChild( file.menu, "SelectSecondaryWeapon"), UIE_CLICK, SelectSecondaryWeaponFunctFunct )
	
	Hud_SetSelected( Hud_GetChild( file.menu, "SelectPrimaryWeapon"), true )
}

void function SetWeaponSwitcherVisible( bool visible )
{
	Hud_SetVisible( Hud_GetChild( file.menu, "SelectPrimaryWeapon"), visible )
	Hud_SetVisible( Hud_GetChild( file.menu, "SelectSecondaryWeapon"), visible )
}

void function DisableBuyWeaponsMenuTabs()
{
	SetTabNavigationEnabled( file.menu, false )
}

void function EnableBuyWeaponsMenuTabs()
{
	SetTabNavigationEnabled( file.menu, true )
}

void function SelectPrimaryWeaponFunct(var button)
{
	Hud_SetSelected( Hud_GetChild( file.menu, "SelectPrimaryWeapon"), true )
	Hud_SetSelected( Hud_GetChild( file.menu, "SelectSecondaryWeapon"), false )
	RunClientScript("SetWeaponSlot", 1)
}

void function SelectSecondaryWeaponFunctFunct(var button)
{
	Hud_SetSelected( Hud_GetChild( file.menu, "SelectPrimaryWeapon"), false )
	Hud_SetSelected( Hud_GetChild( file.menu, "SelectSecondaryWeapon"), true )
	RunClientScript("SetWeaponSlot", 2)
}

void function GoBackButtonFunct(var button)
{
	CloseAllAttachmentsBoxes()
	CloseAllMenus()
	
	if(IsConnected() && GetCurrentPlaylistVarBool( "firingrange_aimtrainerbycolombia", false ))
	{
		RunClientScript("CloseFRChallengesSettingsWpnSelector")
		RunClientScript("ServerCallback_OpenFRChallengesSettings")
	}
	RunClientScript("WeaponSelectorClose")
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
	
	if(IsConnected() && GetCurrentPlaylistVarBool( "firingrange_aimtrainerbycolombia", false ))
	{
		RunClientScript("CloseFRChallengesSettingsWpnSelector")
		RunClientScript("ServerCallback_OpenFRChallengesSettings")	
	}
	RunClientScript("WeaponSelectorClose")
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
        case "mp_weapon_pdw":
            weaponname = "Prowler"
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
		case "mp_weapon_car":
			weaponname = "Car"
			break
		case "mp_weapon_lightninggun":
			weaponname = "Hitscan"
			break
		case "mp_weapon_lightninggun_auto":
			weaponname = "Hitscan Auto"
			break
		default:
			weaponname = ""
    }

	return weaponname
}