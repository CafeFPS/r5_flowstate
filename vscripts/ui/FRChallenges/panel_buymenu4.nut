global function InitArenasBuyPanel4
global function returnWeaponButtons4
global function returnVisibleAttachmentsBox4

struct
{
	var menu
    var header
    var text
	bool tabsInitialized = false

	array<var> weaponButtons
	
	array<var> visibleAttachmentsBoxElements
} file

void function InitArenasBuyPanel4( var panel )
{
	var menu = panel

    AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, OnR5RSB_Show )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, OnR5RSB_Hide )

	AddEventHandlerToButton( menu, "ClickWeaponButton", UIE_CLICK, BuyClickWeapon )
	file.weaponButtons.append(Hud_GetChild( menu, "ClickWeaponButton" ))

	AddEventHandlerToButton( menu, "HitscanAutoButton", UIE_CLICK, BuyClickWeaponAuto )
	file.weaponButtons.append(Hud_GetChild( menu, "HitscanAutoButton" ))

	CleanAllButtons()
}

array<var> function returnWeaponButtons4()
{
	return file.weaponButtons
}

array<var> function returnVisibleAttachmentsBox4()
{
	return file.visibleAttachmentsBoxElements
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

void function BuyClickWeapon(var button)
{
	CleanAllButtons()	
	RuiSetInt( Hud_GetRui( button ), "status", eFriendStatus.ONLINE_INGAME )
	RunClientScript( "UIToClient_MenuGiveWeapon", "mp_weapon_clickweapon" )
	PlayerCurrentWeapon = GetWeaponNameForUI("mp_weapon_clickweapon")
}

void function BuyClickWeaponAuto(var button)
{
	CleanAllButtons()	
	RuiSetInt( Hud_GetRui( button ), "status", eFriendStatus.ONLINE_INGAME )
	RunClientScript( "UIToClient_MenuGiveWeapon", "mp_weapon_clickweaponauto" )
	PlayerCurrentWeapon = GetWeaponNameForUI("mp_weapon_clickweaponauto")
}
