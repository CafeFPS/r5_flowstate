global function OnWeaponActivate_Vinson
global function OnWeaponDeactivate_Vinson
global function OnWeaponPrimaryAttack_Vinson

global function OnWeaponActivate_HaloAR
global function OnWeaponDeactivate_HaloAR
global function OnWeaponPrimaryAttack_HaloAR
global function OnWeaponReload_HaloAR
global function OnWeaponReload_HaloShotgun
global function OnWeaponPrimaryAttack_weapon_haloshotgun

global function OnWeaponZoomIn_HaloModBattleRifle
global function OnWeaponZoomOut_HaloModBattleRifle

global function OnWeaponZoomIn_HaloModMagnum
global function OnWeaponZoomOut_HaloModMagnum

global function OnWeaponZoomIn_HaloModSniper
global function OnWeaponZoomOut_HaloModSniper

#if CLIENT
global function FS_ForceDestroyCustomAdsOverlay
global function FS_ForceDestroyCustomAdsOverlay_Callback
#endif

void function OnWeaponActivate_Vinson( entity weapon )
{
	OnWeaponActivate_weapon_basic_bolt( weapon )
}

void function OnWeaponDeactivate_Vinson( entity weapon )
{
    
}

var function OnWeaponPrimaryAttack_Vinson( entity weapon, WeaponPrimaryAttackParams attackParams )
{

	if ( weapon.HasMod( "altfire_highcal" ) )
		thread PlayDelayedShellEject( weapon, RandomFloatRange( 0.03, 0.04 ) )

	weapon.FireWeapon_Default( attackParams.pos, attackParams.dir, 1.0, 1.0, false )

	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
}

//Halo ar
void function OnWeaponActivate_HaloAR( entity weapon )
{
	OnWeaponActivate_weapon_basic_bolt( weapon )
	
	HaloAR_UpdateAmmoWeaponHUD( weapon, false, true )
}

void function OnWeaponDeactivate_HaloAR( entity weapon )
{
	#if CLIENT
 	if( !GetCurrentPlaylistVarBool( "is_halo_gamemode", false ) )
	{
		Minimap_EnableDraw()
	}
	WeaponInspectHideHudElements( false )  
	#endif
}

void function OnWeaponReload_HaloAR( entity weapon, int milestoneIndex )
{
    HaloAR_UpdateAmmoWeaponHUD( weapon, true )
}

var function OnWeaponPrimaryAttack_HaloAR( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	weapon.FireWeapon_Default( attackParams.pos, attackParams.dir, 1.0, 1.0, false )

	thread HaloAR_UpdateAmmoWeaponHUD( weapon )

	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
}

void function HaloAR_UpdateAmmoWeaponHUD( entity weapon, bool fromReload = false, bool fromActivate = false )
{
	if( !IsValid( weapon ) )
		return

	#if SERVER
	int currentAmmo
	
	if( fromActivate )
		currentAmmo = weapon.GetWeaponPrimaryClipCount()
	else
		currentAmmo = int( max( 0, weapon.GetWeaponPrimaryClipCount() - 1 ) )
	
	if( fromReload )
		currentAmmo = weapon.GetWeaponPrimaryClipCountMax()

	//printt( weapon, " current ammo: ", currentAmmo )

	string ammoString = currentAmmo.tostring()
	
	string left = "0"
	string right = "0"
	
	if( ammoString.len() > 1 && ammoString.len() < 3 )
	{
		left = ammoString.slice( 0, 1 )
		right = ammoString.slice( 1, 2 )
	} else 
	{
		right = ammoString
	}

	//clean up
	foreach( string mod in GetWeaponMods_Global( weapon.GetWeaponClassName() ) )
	{
		array<string> splitName = split( mod, "_" )
		
		if( splitName.len() < 2 )
			continue
		
		if( splitName[0] == "ammoCounter" && weapon.HasMod( mod ) )
			weapon.RemoveMod( mod )
	}

	//sets left mod
	weapon.AddMod( "ammoCounter_izq" + left )

	//sets right mod
	weapon.AddMod( "ammoCounter_der" + right )
	#endif
}

void function OnWeaponReload_HaloShotgun( entity weapon, int milestoneIndex )
{
	// entity weapon = gp()[0].GetActiveWeapon( eActiveInventorySlot.mainHand )
	// entity vm = weapon.GetWeaponViewmodel()

	// try{
	// vm.Anim_Stop()
	// //vm.Anim_NonScriptedPlay("animseq/weapons/w1128/ptpov_w1128/drawfirst.rseq")
	// weapon.StartCustomActivity("ACT_VM_DRAWFIRST", 0)
	// vm.SetCycle( 0.1 )
	// //vm.Anim_SetPlaybackRate( 2 )
	// weapon.OverrideNextAttackTime( Time() + (weapon.GetSequenceDuration("ACT_VM_DRAWFIRST") - weapon.GetSequenceDuration("ACT_VM_DRAWFIRST")*0.1) - 1 )
	// }catch(e420){}
}

var function OnWeaponPrimaryAttack_weapon_haloshotgun( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	if( weapon.GetNextAttackAllowedTime() - Time() > 0 )
		return

	bool playerFired = true
	
	entity owner = weapon.GetWeaponOwner()

	float patternScale = 1.0
	if ( !playerFired )
		patternScale = weapon.GetWeaponSettingFloat( eWeaponVar.blast_pattern_npc_scale )

	float speedScale = 1.0
	bool ignoreSpread = true

	weapon.FireWeapon_Default( attackParams.pos, attackParams.dir, speedScale, patternScale, ignoreSpread )

	// entity vm = weapon.GetWeaponViewmodel()

	// try{
		// weapon.StartCustomActivity("ACT_VM_DRAWFIRST", 0)
		// weapon.OverrideNextAttackTime( Time() + (weapon.GetSequenceDuration("ACT_VM_DRAWFIRST") ) )
	// }catch(e420){}

    owner.HolsterWeapon()
    owner.DeployWeapon()
	
	#if SERVER
	owner.ForceWeaponReload()
	#endif
	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
	
}

void function OnWeaponZoomIn_HaloModBattleRifle( entity weapon )
{
	if( weapon.w.isInAdsCustom )
		return

	entity player = weapon.GetWeaponOwner()

	#if CLIENT
	var BRAds = HudElement( "FS_HaloMod_BattleRifleAdsOverlay")
	RuiSetImage( Hud_GetRui( BRAds ), "basicImage", $"rui/flowstate_custom/battlerifle_ads" )
	Hud_SetVisible( BRAds, true )

	weapon.HideWeapon()
	
	if( !GetCurrentPlaylistVarBool( "is_halo_gamemode", false ) && GetMapName() == "mp_flowstate" )
	{
		Minimap_DisableDraw()
	}
	
	//Hide the HUD.
	var gamestateRui = ClGameState_GetRui()
	RuiSetBool( gamestateRui, "weaponInspect", true )
	PlayerHudSetWeaponInspect( true )
	WeaponStatusSetWeaponInspect( true )
	#endif
	
	weapon.w.isInAdsCustom = true
}

void function OnWeaponZoomOut_HaloModBattleRifle( entity weapon )
{
	if( !weapon.w.isInAdsCustom )
		return

	entity player = weapon.GetWeaponOwner()

	#if CLIENT
	var BRAds = HudElement( "FS_HaloMod_BattleRifleAdsOverlay")
	Hud_SetVisible( BRAds, false )

	weapon.ShowWeapon()

	if( !GetCurrentPlaylistVarBool( "is_halo_gamemode", false ) && GetMapName() == "mp_flowstate" )
	{
		Minimap_EnableDraw()
	}
	
	//Hide the HUD.
	var gamestateRui = ClGameState_GetRui()
	RuiSetBool( gamestateRui, "weaponInspect", false )
	PlayerHudSetWeaponInspect( false )
	WeaponStatusSetWeaponInspect( false )
	#endif

	weapon.w.isInAdsCustom = false
}

void function OnWeaponZoomIn_HaloModMagnum( entity weapon )
{
	if( weapon.w.isInAdsCustom )
		return

	entity player = weapon.GetWeaponOwner()

	#if CLIENT
	var BRAds = HudElement( "FS_HaloMod_BattleRifleAdsOverlay")
	RuiSetImage( Hud_GetRui( BRAds ), "basicImage", $"rui/flowstate_custom/weapon/halo_magnum_pistol" )
	Hud_SetVisible( BRAds, true )

	weapon.HideWeapon()
	
	if( !GetCurrentPlaylistVarBool( "is_halo_gamemode", false ) && GetMapName() == "mp_flowstate" )
	{
		Minimap_DisableDraw()
	}
	
	//Hide the HUD.
	var gamestateRui = ClGameState_GetRui()
	RuiSetBool( gamestateRui, "weaponInspect", true )
	PlayerHudSetWeaponInspect( true )
	WeaponStatusSetWeaponInspect( true )
	#endif
	
	weapon.w.isInAdsCustom = true
}

void function OnWeaponZoomOut_HaloModMagnum( entity weapon )
{
	if( !weapon.w.isInAdsCustom )
		return

	entity player = weapon.GetWeaponOwner()

	#if CLIENT
	var BRAds = HudElement( "FS_HaloMod_BattleRifleAdsOverlay")
	Hud_SetVisible( BRAds, false )

	weapon.ShowWeapon()

	if( !GetCurrentPlaylistVarBool( "is_halo_gamemode", false ) && GetMapName() == "mp_flowstate" )
	{
		Minimap_EnableDraw()
	}
	
	//Hide the HUD.
	var gamestateRui = ClGameState_GetRui()
	RuiSetBool( gamestateRui, "weaponInspect", false )
	PlayerHudSetWeaponInspect( false )
	WeaponStatusSetWeaponInspect( false )
	#endif

	weapon.w.isInAdsCustom = false
}

void function OnWeaponZoomIn_HaloModSniper(  entity weapon )
{
	if( weapon.w.isInAdsCustom )
		return

	entity player = weapon.GetWeaponOwner()

	#if CLIENT
	var BRAds = HudElement( "FS_HaloMod_BattleRifleAdsOverlay")
	RuiSetImage( Hud_GetRui( BRAds ), "basicImage", $"rui/flowstate_custom/weapon/halo_sniper_ads" )
	Hud_SetVisible( BRAds, true )

	weapon.HideWeapon()
	
	if( !GetCurrentPlaylistVarBool( "is_halo_gamemode", false ) && GetMapName() == "mp_flowstate" )
	{
		Minimap_DisableDraw()
	}
	
	//Hide the HUD.
	var gamestateRui = ClGameState_GetRui()
	RuiSetBool( gamestateRui, "weaponInspect", true )
	PlayerHudSetWeaponInspect( true )
	WeaponStatusSetWeaponInspect( true )
	#endif
	
	weapon.w.isInAdsCustom = true
}

void function OnWeaponZoomOut_HaloModSniper(  entity weapon )
{
	if( !weapon.w.isInAdsCustom )
		return

	entity player = weapon.GetWeaponOwner()

	#if CLIENT
	var BRAds = HudElement( "FS_HaloMod_BattleRifleAdsOverlay")
	Hud_SetVisible( BRAds, false )

	weapon.ShowWeapon()

	if( !GetCurrentPlaylistVarBool( "is_halo_gamemode", false ) && GetMapName() == "mp_flowstate" )
	{
		Minimap_EnableDraw()
	}
	
	//Show the HUD.
	var gamestateRui = ClGameState_GetRui()
	RuiSetBool( gamestateRui, "weaponInspect", false )
	PlayerHudSetWeaponInspect( false )
	WeaponStatusSetWeaponInspect( false )
	#endif

	weapon.w.isInAdsCustom = false
}

#if CLIENT
void function FS_ForceDestroyCustomAdsOverlay()
{
	printt( "You died! Removing custom overlay and restoring HUD visibility." )
	var BRAds = HudElement( "FS_HaloMod_BattleRifleAdsOverlay")
	Hud_SetVisible( BRAds, false )

	//Show the HUD.
	var gamestateRui = ClGameState_GetRui()
	RuiSetBool( gamestateRui, "weaponInspect", false )
	PlayerHudSetWeaponInspect( false )
	WeaponStatusSetWeaponInspect( false )
	
	entity player = GetLocalClientPlayer()
	entity weapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
	
	if( IsValid( weapon ) && weapon.w.isInAdsCustom )
	{
		weapon.ShowWeapon()
		weapon.w.isInAdsCustom = false
	}
}

void function FS_ForceDestroyCustomAdsOverlay_Callback( entity attacker, float healthFrac, int damageSourceId, float recentHealthDamage )
{
	if( GameRules_GetGameMode() == "fs_dm" )
		return

	printt( "You died! Removing custom overlay and restoring HUD visibility. - From callback." )
	var BRAds = HudElement( "FS_HaloMod_BattleRifleAdsOverlay")
	Hud_SetVisible( BRAds, false )
	
	//Show the HUD.
	var gamestateRui = ClGameState_GetRui()
	RuiSetBool( gamestateRui, "weaponInspect", false )
	PlayerHudSetWeaponInspect( false )
	WeaponStatusSetWeaponInspect( false )

	entity player = GetLocalClientPlayer()
	entity weapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
	
	if( IsValid( weapon ) && weapon.w.isInAdsCustom )
	{
		weapon.ShowWeapon()
		weapon.w.isInAdsCustom = false
	}
}
#endif