//Made by @CafeFPS

global function MpWeaponSentinel_Init
global function OnWeaponPrimaryAttack_weapon_sentinel
global function OnWeaponActivate_weapon_sentinel
global function OnWeaponDeactivate_weapon_sentinel
global function OnWeaponCustomActivityStart_weapon_sentinel
global function OnWeaponCustomActivityEnd_weapon_sentinel
global function OnWeaponStartZoomIn_weapon_sentinel
global function OnWeaponStartZoomOut_weapon_sentinel

const string SENTINEL_DEACTIVATE_SIGNAL = "SentinelDeactivate"
const string ENERGIZED_MOD = "energized"

void function MpWeaponSentinel_Init()
{
	RegisterSignal( SENTINEL_DEACTIVATE_SIGNAL )

	#if SERVER
	AddClientCommandCallback( "Sentinel_TryCharge", ClientCommand_TryCharge )
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

void function Flowstate_SentinelChargeHUD( entity player, entity weapon )
{
	printt( "Flowstate_SentinelChargeHUD" )
	EndSignal( weapon, SENTINEL_DEACTIVATE_SIGNAL )

	if ( !IsValid( player ) )
		return

	if ( !IsLocalViewPlayer( player ) )
		return

	EndSignal( weapon, SENTINEL_DEACTIVATE_SIGNAL )
	weapon.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )

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
	float duration = GetWeaponInfoFileKeyField_GlobalFloat( weapon.GetWeaponClassName(), "energized_duration" )
	float chargeEndTime = Time() + duration //save in weapon struct to reduce time on each shot

	while( Time() < chargeEndTime && IsValid ( weapon ) && IsValid( player ) && weapon.HasMod( ENERGIZED_MOD ) )
	{
		float superFrac       = Time() / chargeEndTime
		string chargeBarText  = "DISCHARGING " + int( (superFrac*100) ).tostring() + "%"

		SetWidth( Bar, superFrac )
		Hud_SetText( Text, chargeBarText )

		WaitFrame()
	}
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

#endif

void function Flowtate_SentinelCharging( entity player, entity weapon )
{
	EndSignal( weapon, "OnDestroy" )
	EndSignal( weapon, SENTINEL_DEACTIVATE_SIGNAL )

	float chargeEndTime = Time() + weapon.GetCustomActivityDuration()

	OnThreadEnd( function() : ( player, weapon ) 
	{
		if ( IsValid( weapon ) && weapon.IsInCustomActivity() )
		{
			weapon.StopCustomActivity()
			printt( "Charging was canceled" )
		}
		
		if( IsValid( weapon ) && !weapon.IsInCustomActivity() && weapon == player.GetActiveWeapon( eActiveInventorySlot.mainHand ) ) //is there a better way to do this?
		{
		    player.HolsterWeapon()
			player.DeployWeapon()
			weapon.AddMod( ENERGIZED_MOD )
			printt("Sentinel charging success, mod added")
			thread Flowtate_SentinelOnModAddedWatcher( weapon )
			
			// #if CLIENT
			// thread Flowstate_SentinelChargeHUD( player, weapon )
			// #endif
		}
	})

	printt("sentinel started charging. End Time:", chargeEndTime )
	while( Time() < chargeEndTime )
	{
		WaitFrame()
	}
}

void function Flowtate_SentinelOnModAddedWatcher( entity weapon )
{
	EndSignal( weapon, "OnDestroy" )

	float duration = GetWeaponInfoFileKeyField_GlobalFloat( weapon.GetWeaponClassName(), "energized_duration" )
	float chargeEndTime = Time() + duration //save in weapon struct to reduce time on each shot
	weapon.Signal( SENTINEL_DEACTIVATE_SIGNAL )

	OnThreadEnd( function() : ( weapon ) 
	{
		if( IsValid( weapon ) )
		{
			weapon.RemoveMod( ENERGIZED_MOD )
			printt("Sentinel energized ended, mod removed")
		}
	})

	printt("sentinel started mod watcher. End Time:", chargeEndTime )
	while( Time() < chargeEndTime )
	{
		WaitFrame()
	}
}

void function OnWeaponCustomActivityStart_weapon_sentinel( entity weapon )
{
	//why this is not being triggered on the client?
	if ( !IsValid( weapon ) )
		return

	entity player = weapon.GetWeaponOwner()
	if ( !IsValid( player ) )
		return 

	thread Flowtate_SentinelCharging( player, weapon )
}

void function OnWeaponCustomActivityEnd_weapon_sentinel( entity weapon )
{
	if ( !IsValid( weapon ) )
		return

	printt( "OnWeaponCustomActivityEnd_weapon_sentinel" )
}

void function OnWeaponStartZoomIn_weapon_sentinel( entity weapon )
{
	if ( !IsValid( weapon ) )
		return

	weapon.Signal( SENTINEL_DEACTIVATE_SIGNAL )
	printt( "OnWeaponStartZoomIn_weapon_sentinel" )
}

void function OnWeaponStartZoomOut_weapon_sentinel( entity weapon )
{
	if ( !IsValid( weapon ) )
		return

	weapon.Signal( SENTINEL_DEACTIVATE_SIGNAL )
	printt( "OnWeaponStartZoomOut_weapon_sentinel" )
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
	#if CLIENT
	DeregisterConCommandTriggeredCallback( "+scriptCommand3", Sentinel_TryCharge )
	#endif
}

void function OnWeaponActivate_weapon_sentinel( entity weapon )
{
	if ( !IsValid( weapon ) )
		return

	// weapon.Signal( SENTINEL_DEACTIVATE_SIGNAL )
	#if CLIENT
	RegisterConCommandTriggeredCallback( "+scriptCommand3", Sentinel_TryCharge )
	#endif
}