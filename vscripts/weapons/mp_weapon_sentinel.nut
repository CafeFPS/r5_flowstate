//Made by @CafeFPS

global function MpWeaponSentinel_Init
global function OnWeaponPrimaryAttack_weapon_sentinel
global function OnWeaponActivate_weapon_sentinel
global function OnWeaponDeactivate_weapon_sentinel
global function OnWeaponCustomActivityStart_weapon_sentinel
global function OnWeaponCustomActivityEnd_weapon_sentinel
global function OnWeaponStartZoomIn_weapon_sentinel
global function OnWeaponStartZoomOut_weapon_sentinel

#if CLIENT
global function Flowstate_SentinelChargeHUD
#endif

const string SENTINEL_DEACTIVATE_SIGNAL = "SentinelDeactivate"
const string ENERGIZED_MOD = "energized"

void function MpWeaponSentinel_Init()
{
	RegisterSignal( SENTINEL_DEACTIVATE_SIGNAL )

	if( !GetCurrentPlaylistVarBool( "sentinel_enable_charging", true ) )
		return

	#if SERVER
	AddClientCommandCallback( "Sentinel_TryCharge", ClientCommand_TryCharge )
	#endif

	#if CLIENT
	RegisterConCommandTriggeredCallback( "+scriptCommand3", Sentinel_TryCharge )
	#endif
	
}

#if CLIENT
void function Sentinel_TryCharge( entity player )
{
	if( !IsValid(player) ) 
		return
		
	if ( player != GetLocalViewPlayer() )
		return
	
	entity weapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )

	if ( !IsValid( weapon ) )
		return

	if ( weapon.GetWeaponClassName() != "mp_weapon_sentinel" )
		return
	
	//has battery?
	
	player.ClientCommand( "Sentinel_TryCharge" )
}

void function Flowstate_SentinelChargeHUD( float chargeEndTime )
{
	//printt "Flowstate_SentinelChargeHUD" )
	thread function () : ( chargeEndTime )
	{
		entity weapon
		entity player = GetLocalViewPlayer()

		array<entity> weapons = player.GetMainWeapons()
		foreach ( sWeapon in weapons )
		{
			string weaponRef = sWeapon.GetWeaponClassName()
			if( weaponRef == "mp_weapon_sentinel" )
				weapon = sWeapon
		}

		if ( !IsValid( weapon ) )
			return

		weapon.EndSignal( "OnDestroy" )

		var Border = HudElement( "Sentinel_ChargeElementBorder")
		RuiSetImage( Hud_GetRui( Border ), "basicImage", $"rui/flowstate_custom/fs_titan_swod/1_border")
		Hud_SetVisible( Border, true )

		var Bg = HudElement( "Sentinel_ChargeElementBg")
		RuiSetImage( Hud_GetRui( Bg ), "basicImage", $"rui/flowstate_custom/fs_titan_swod/1_bg")
		Hud_SetVisible( Bg, true )

		var Bar = HudElement( "Sentinel_ChargeElementBar")
		RuiSetImage( Hud_GetRui( Bar ), "basicImage", $"rui/flowstate_custom/fs_titan_swod/1_bar")
		Hud_SetVisible( Bar, true )

		var Text = HudElement( "Sentinel_ChargeElementText")
		Hud_SetVisible( Text, true )

		OnThreadEnd(
			function() : ( Border, Bg, Bar, Text )
			{
				Hud_SetVisible( Border, false )
				Hud_SetVisible( Bg, false )
				Hud_SetVisible( Bar, false )
				Hud_SetVisible( Text, false )
				SetWidth( Bar, 1.0 )
			}
		)

		while( Time() < chargeEndTime && IsValid ( weapon ) && IsValid( player ) && weapon.HasMod( ENERGIZED_MOD ) )
		{
			float superFrac       = 1 - ( Time() / chargeEndTime )
			string chargeBarText  = "SENTINEL DISCHARGING " + int( (superFrac*100) ).tostring() + "%"

			SetWidth( Bar, superFrac )
			Hud_SetText( Text, chargeBarText )

			WaitFrame()
		}
	}()
}

void function SetWidth(var element, float chargeFraction)
{
	int baseWidth = Hud_GetBaseWidth( element )
	Hud_SetWidth( element, baseWidth*chargeFraction)
}
#endif

#if SERVER
bool function ClientCommand_TryCharge( entity player, array<string> args )
{
	if ( !IsValid( player ) )
		return false

	entity weapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )

	if ( !IsValid( weapon ) )
		return false

	if ( weapon.GetWeaponClassName() != "mp_weapon_sentinel" )
		return false

	if( weapon.IsInCustomActivity() )
		return false
		
	if( weapon.HasMod( ENERGIZED_MOD ) )
		return false
	//has battery?

	weapon.StartCustomActivity("ACT_VM_CHARGE_VER4", 0)	
	return true
}

void function Flowstate_SentinelCharging( entity player, entity weapon )
{
	EndSignal( weapon, "OnDestroy" )
	// EndSignal( weapon, SENTINEL_DEACTIVATE_SIGNAL )

	float chargeEndTime = Time() + weapon.GetCustomActivityDuration()

	OnThreadEnd( function() : ( player, weapon ) 
	{
		if( IsValid( weapon ) && weapon != player.GetActiveWeapon( eActiveInventorySlot.mainHand ) )
			return

		if ( IsValid( weapon ) && weapon.IsInCustomActivity() )
		{
			weapon.StopCustomActivity()
			//printt "Charging was canceled" )
		}
		
		if( IsValid( weapon ) && !weapon.IsInCustomActivity() && IsValid( player ) && weapon == player.GetActiveWeapon( eActiveInventorySlot.mainHand ) ) //is there a better way to do this?
		{
		    player.HolsterWeapon()
			player.DeployWeapon()
			weapon.AddMod( ENERGIZED_MOD )
			//printt"Sentinel charging success, mod added")

			thread Flowstate_SentinelOnModAddedWatcher( player, weapon )
		}
	})

	//printt"sentinel started charging. End Time:", chargeEndTime )
	while( Time() < chargeEndTime && IsValid( weapon ) && weapon == player.GetActiveWeapon( eActiveInventorySlot.mainHand ) )
	{
		WaitFrame()
	}
}

void function Flowstate_SentinelOnModAddedWatcher( entity player, entity weapon )
{
	EndSignal( weapon, "OnDestroy" )

	float duration = GetWeaponInfoFileKeyField_GlobalFloat( weapon.GetWeaponClassName(), "energized_duration" )
	float chargeEndTime = Time() + duration //save in weapon struct to increase time on each shot?? Cafe
	weapon.Signal( SENTINEL_DEACTIVATE_SIGNAL )

	Remote_CallFunction_NonReplay( player, "Flowstate_SentinelChargeHUD", chargeEndTime )

	OnThreadEnd( function() : ( weapon ) 
	{
		if( IsValid( weapon ) )
		{
			weapon.RemoveMod( ENERGIZED_MOD )
			//printt"Sentinel energized ended, mod removed")
		}
	})

	//printt"sentinel started mod watcher. End Time:", chargeEndTime )
	while( Time() < chargeEndTime && weapon.HasMod( ENERGIZED_MOD ) )
	{
		//printt"sentinel energized time remaining:", chargeEndTime - Time() )
		wait 1
	}
}
#endif

void function OnWeaponCustomActivityStart_weapon_sentinel( entity weapon )
{
	if ( !IsValid( weapon ) )
		return

	entity player = weapon.GetWeaponOwner()
	if ( !IsValid( player ) )
		return 

	#if SERVER
	thread Flowstate_SentinelCharging( player, weapon )
	#endif
}

void function OnWeaponCustomActivityEnd_weapon_sentinel( entity weapon )
{
	if ( !IsValid( weapon ) )
		return

	//printt "OnWeaponCustomActivityEnd_weapon_sentinel" )
}

void function OnWeaponStartZoomIn_weapon_sentinel( entity weapon )
{
	if ( !IsValid( weapon ) )
		return

	weapon.Signal( SENTINEL_DEACTIVATE_SIGNAL )
	//printt "OnWeaponStartZoomIn_weapon_sentinel" )
}

void function OnWeaponStartZoomOut_weapon_sentinel( entity weapon )
{
	if ( !IsValid( weapon ) )
		return

	weapon.Signal( SENTINEL_DEACTIVATE_SIGNAL )
	//printt "OnWeaponStartZoomOut_weapon_sentinel" )
}

var function OnWeaponPrimaryAttack_weapon_sentinel( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity player = weapon.GetWeaponOwner()
	if ( !IsValid( player ) )
		return 0

    player.HolsterWeapon()
    player.DeployWeapon()

	weapon.FireWeapon_Default( attackParams.pos, attackParams.dir, 1.0, 1.0, false )

	int ammoPerShot = weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
	return ammoPerShot
}

void function OnWeaponDeactivate_weapon_sentinel( entity weapon )
{
	if ( !IsValid( weapon ) )
		return

	weapon.Signal( SENTINEL_DEACTIVATE_SIGNAL )
}

void function OnWeaponActivate_weapon_sentinel( entity weapon )
{
	if ( !IsValid( weapon ) )
		return

	// weapon.Signal( SENTINEL_DEACTIVATE_SIGNAL )

}