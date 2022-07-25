global function InitArenasBuyPanel4
global function returnWeaponButtons4

struct
{
	var menu
    var header
    var text
	bool tabsInitialized = false

	array<var> weaponButtons
} file

void function InitArenasBuyPanel4( var panel )
{
	var menu = panel

    AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, OnR5RSB_Show )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, OnR5RSB_Hide )

	var p2020 = Hud_GetChild( menu, "Volt" )
	RuiSetImage( Hud_GetRui( p2020 ), "basicImage", $"rui/weapon_icons/r5/weapon_volt" )
	AddEventHandlerToButton( menu, "VoltButton", UIE_CLICK, BuyP2020 )
	file.weaponButtons.append(Hud_GetChild( menu, "VoltButton" ))

	var mozam = Hud_GetChild( menu, "Rampage" )
	RuiSetImage( Hud_GetRui( mozam ), "basicImage", $"rui/weapon_icons/r5/weapon_spitfire" )
	AddEventHandlerToButton( menu, "RampageButton", UIE_CLICK, BuyMozam )
	file.weaponButtons.append(Hud_GetChild( menu, "RampageButton" ))

	var wingman = Hud_GetChild( menu, "Car" )
	RuiSetImage( Hud_GetRui( wingman ), "basicImage", $"rui/weapon_icons/r5/weapon_r97" )
	AddEventHandlerToButton( menu, "CarButton", UIE_CLICK, BuyWingman )
	file.weaponButtons.append(Hud_GetChild( menu, "CarButton" ))

	// var re45 = Hud_GetChild( menu, "RE45" )
	// RuiSetImage( Hud_GetRui( re45 ), "basicImage", $"rui/weapon_icons/r5/weapon_r45" )
	// AddEventHandlerToButton( menu, "RE45Button", UIE_CLICK, BuyRE45 )
	// file.weaponButtons.append(Hud_GetChild( menu, "RE45Button" ))

	// var alternator = Hud_GetChild( menu, "Alternator" )
	// RuiSetImage( Hud_GetRui( alternator ), "basicImage", $"rui/weapon_icons/r5/weapon_alternator" )
	// AddEventHandlerToButton( menu, "AlternatorButton", UIE_CLICK, BuyAlternator )
	// file.weaponButtons.append(Hud_GetChild( menu, "AlternatorButton" ))

	// var r99 = Hud_GetChild( menu, "R99" )
	// RuiSetImage( Hud_GetRui( r99 ), "basicImage", $"rui/weapon_icons/r5/weapon_r97" )
	// AddEventHandlerToButton( menu, "R99Button", UIE_CLICK, BuyR99 )
	// file.weaponButtons.append(Hud_GetChild( menu, "R99Button" ))

	// var eva8 = Hud_GetChild( menu, "EVA8" )
	// RuiSetImage( Hud_GetRui( eva8 ), "basicImage", $"rui/weapon_icons/r5/weapon_eva8" )
	// AddEventHandlerToButton( menu, "EVA8Button", UIE_CLICK, BuyEva8 )
	// file.weaponButtons.append(Hud_GetChild( menu, "EVA8Button" ))
	
	// var mastiff = Hud_GetChild( menu, "Mastiff" )
	// RuiSetImage( Hud_GetRui( mastiff ), "basicImage", $"rui/weapon_icons/r5/weapon_mastiff" )
	// AddEventHandlerToButton( menu, "MastiffButton", UIE_CLICK, BuyMastiff )
	// file.weaponButtons.append(Hud_GetChild( menu, "MastiffButton" ))
	
	// var peacekeeper = Hud_GetChild( menu, "Peacekeeper" )
	// RuiSetImage( Hud_GetRui( peacekeeper ), "basicImage", $"rui/weapon_icons/r5/weapon_peacekeeper" )
	// AddEventHandlerToButton( menu, "PeacekeeperButton", UIE_CLICK, BuyPeacekeeper )
	// file.weaponButtons.append(Hud_GetChild( menu, "PeacekeeperButton" ))
	CleanAllButtons()
}

array<var> function returnWeaponButtons4()
{
	return file.weaponButtons
}

// array<var> function ReturnVisibleAttachmentsBoxElements4()
// {
	// return file.visibleAttachmentsBoxElements
// }

void function OnR5RSB_Hide(var panel)
{
}

void function OnR5RSB_Show(var panel)
{
}
void function BuyP2020(var button)
{
	CleanAllButtons()
	RuiSetInt( Hud_GetRui( button ), "status", eFriendStatus.ONLINE_INGAME )
	RunClientScript( "UIToClient_MenuGiveWeapon", "mp_weapon_volt_smg" )
}

void function BuyMozam(var button)
{
	CleanAllButtons()
	RuiSetInt( Hud_GetRui( button ), "status", eFriendStatus.ONLINE_INGAME )
	RunClientScript( "UIToClient_MenuGiveWeapon", "mp_weapon_lmg" )
}

void function BuyWingman(var button)
{
	CleanAllButtons()	
	RuiSetInt( Hud_GetRui( button ), "status", eFriendStatus.ONLINE_INGAME )
	RunClientScript( "UIToClient_MenuGiveWeapon", "mp_weapon_r97" )
}

void function BuyRE45(var button)
{
	CleanAllButtons()	
	RuiSetInt( Hud_GetRui( button ), "status", eFriendStatus.ONLINE_INGAME )
	RunClientScript( "UIToClient_MenuGiveWeapon", "mp_weapon_autopistol" )
}

void function BuyAlternator(var button)
{
	CleanAllButtons()	
	RuiSetInt( Hud_GetRui( button ), "status", eFriendStatus.ONLINE_INGAME )
	RunClientScript( "UIToClient_MenuGiveWeapon", "mp_weapon_alternator_smg" )
}

void function BuyR99(var button)
{
	CleanAllButtons()	
	RuiSetInt( Hud_GetRui( button ), "status", eFriendStatus.ONLINE_INGAME )
	RunClientScript( "UIToClient_MenuGiveWeapon", "mp_weapon_r97" )
}

void function BuyEva8(var button)
{
	CleanAllButtons()	
	RuiSetInt( Hud_GetRui( button ), "status", eFriendStatus.ONLINE_INGAME )
	RunClientScript( "UIToClient_MenuGiveWeapon", "mp_weapon_shotgun" )
}

void function BuyMastiff(var button)
{
	CleanAllButtons()	
	RuiSetInt( Hud_GetRui( button ), "status", eFriendStatus.ONLINE_INGAME )
	RunClientScript( "UIToClient_MenuGiveWeapon", "mp_weapon_mastiff" )
}

void function BuyPeacekeeper(var button)
{
	CleanAllButtons()	
	RuiSetInt( Hud_GetRui( button ), "status", eFriendStatus.ONLINE_INGAME )
	RunClientScript( "UIToClient_MenuGiveWeapon", "mp_weapon_energy_shotgun" )
}