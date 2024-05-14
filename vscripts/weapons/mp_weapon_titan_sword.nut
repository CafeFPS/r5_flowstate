//By @CafeFPS and Respawn

global function MpWeaponTitanSword_Init
global function OnWeaponPrimaryAttack_weapon_titan_sword
global function OnWeaponActivate_weapon_titan_sword
global function OnWeaponDeactivate_weapon_titan_sword
global function OnWeaponCustomActivityEnd_weapon_titan_sword

global function TitanSword_GetMainWeapon
global function TitanSword_ActiveWeaponIsTitanSword
global function TitanSword_WeaponIsTitanSword
global function TitanSword_WeaponRefIsTitanSword
global function TitanSword_DamageSourceIsTitanSword

global function TitanSword_TryUseFuel
global function TitanSword_HasFuel
global function TitanSword_FillFuel
global function TitanSword_LaunchEntity

global function TitanSword_SafelyAddAttackMod
global function TitanSword_ClearMods
global function TitanSword_Light_VictimHitOverride
global function FS_TitanSword_ModsShouldTriggerLunge

#if CLIENT
global function TitanSword_ClearHints
global function TitanSword_DisplayHint
global function TitanSword_ClientPredictCheck
global function FS_TitanSword_AddPlayerHint
#endif

global const string TITAN_SWORD_WEAPON_REF = "mp_weapon_titan_sword"
const string TITAN_SWORD_LIGHT_SUPER_MOD = "super_melee"

global const string SIG_TITAN_SWORD_DEACTIVATE = "TitanSword_Deactivate"
const string SIG_TITAN_SWORD_DESTROY_FUEL_RUI = "TitanSword_DestroyFuelRui"
const string SIG_TITAN_SWORD_SUPER_THREAD = "TitanSword_Super"

global const string SIG_TITAN_SWORD_DASH_ACTIVATED = "TitanSword_DashActivated"
global const string SIG_TITAN_SWORD_DASH_STOPPED = "TitanSword_DashStopped"
global const string SIG_TITAN_SWORD_DASH_ONACTIVATE = "TitanSword_SprintFx"

const int TITAN_SWORD_OFFHAND_SLOT = OFFHAND_MELEE

const float TITAN_SWORD_DASH_NOT_READY_DEBOUNCE_TIME_SEC = 1
const float TITAN_SWORD_MAIN_INSTRUCTIONS_DEBOUNCE_TIME = 45 
const float TITAN_SWORD_INSTRUCTIONS_DEBOUNCE_TIME = 10

const asset VFX_TITAN_SWORD_SPEED_TRAIL_BODY = $"P_dash_melee_start"
const string VFX_TITAN_SWORD_IMPACT = "titan_sword"    

// const asset FX_TITAN_SWORD_LIGHT_SWIPE_FP = $"P_pilot_sword_swipe_light_FP"
// const asset FX_TITAN_SWORD_LIGHT_SWIPE_3P = $"P_pilot_sword_swipe_light_3P"

const string SFX_TITAN_SWORD_FUEL_READY = "UI_InGame_FD_SliderExit"
const string SFX_TITAN_SWORD_FUEL_NOT_READY = "Survival_UI_Ability_NotReady"

const int GOING_THROUGH_FALSE = 0
const int GOING_THROUGH_TRUE = 1
const int GOING_THROUGH_FORCE_HIT = 2

struct
{
	#if CLIENT
		float debounceMainMsg
		float debounceInstructionMsg
		float debounceDashMsg = -1
		var quickRightMsg
		bool firstTime = true
	#elseif SERVER



	#endif
}file

void function MpWeaponTitanSword_Init()
{
	PrecacheWeapon( TITAN_SWORD_WEAPON_REF )
	PrecacheImpactEffectTable( VFX_TITAN_SWORD_IMPACT )
	
	PrecacheParticleSystem( VFX_TITAN_SWORD_SPEED_TRAIL_BODY )
	// PrecacheParticleSystem( FX_TITAN_SWORD_LIGHT_SWIPE_FP )
	// PrecacheParticleSystem( FX_TITAN_SWORD_LIGHT_SWIPE_3P )

	RegisterSignal( SIG_TITAN_SWORD_DEACTIVATE )

	MpWeaponTitanSword_Block_Init()
	MpWeaponTitanSword_Dash_Init()
	MpWeaponTitanSword_Heavy_Init()
	MpWeaponTitanSword_Launcher_Init()
	MpWeaponTitanSword_Slam_Init()
	MpWeaponTitanSword_Super_Init()
	MpWeaponTitanSword_Light_Init()

	#if CLIENT
		StatusEffect_RegisterDisabledCallback( eStatusEffect.titan_sword_fuel, TitanSword_OnFuelFull )
		AddCallback_OnPrimaryWeaponStatusUpdate( OnPrimaryWeaponStatusUpdate_TitanSword )
	#endif

	RegisterSignal( SIG_TITAN_SWORD_DESTROY_FUEL_RUI )
	
	#if SERVER
	AddDamageFinalCallback( "player", TitanSword_Owner_Damaged )
	#endif
}

var function OnWeaponPrimaryAttack_weapon_titan_sword( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return 0
}

void function MpWeaponTitanSword_Light_Init( )
{
	
}

void function TitanSword_Light_StartVFX( entity weapon )
{
	// entity player = weapon.GetWeaponOwner()
	// {
	// weapon.PlayWeaponEffect( FX_TITAN_SWORD_LIGHT_SWIPE_FP, FX_TITAN_SWORD_LIGHT_SWIPE_3P, "blade_tip" )
	// }
}

void function TitanSword_Light_StopVFX( entity weapon )
{
	// entity player = weapon.GetWeaponOwner()
	
	// {
	// weapon.StopWeaponEffect( FX_TITAN_SWORD_LIGHT_SWIPE_FP, FX_TITAN_SWORD_LIGHT_SWIPE_3P )
	// }
}

void function OnWeaponActivate_weapon_titan_sword( entity weapon )
{
	weapon.kv.rendercolor = <171, 52, 235>
	entity player = weapon.GetWeaponOwner()
	if ( !IsValid( player ) )
		return

	#if SERVER
	Warning( "ACTIVATE " + weapon.GetWeaponClassName() + ". Mods: " + weapon.GetMods().len() + " Melee Attack Active?: " + player.PlayerMelee_IsAttackActive() )
	foreach( mod in weapon.GetMods() )
		Warning( "act " + mod )
	#endif

	//Offhand
	/////////////////////////////////////////////////////////////
	if( weapon.GetWeaponClassName() == "melee_titan_sword" )
		return
	/////////////////////////////////////////////////////////////

	#if SERVER
		thread FS_TitanSword_Super_Thread( player, weapon )
		// TitanSword_Slam_OnWeaponDectivate( player, weapon )

	#endif

	TitanSword_Block_OnWeaponActivate( player, weapon )
	TitanSword_Dash_OnWeaponActivate( player, weapon )
	TitanSword_Heavy_OnWeaponActivate( player, weapon )
	TitanSword_Launcher_OnWeaponActivate( player, weapon )
	TitanSword_Slam_OnWeaponActivate( player, weapon )
	TitanSword_Super_OnWeaponActivate( player, weapon )

	TitanSword_UpdateFuelCrosshair( player, weapon )

	#if CLIENT
		RegisterConCommandTriggeredCallback( "+use_alt", FS_MeleeSecondaryKey_Pressed )
		RegisterConCommandTriggeredCallback( "+scriptcommand3", FS_SuperKey_Pressed )

		AddCallback_OnPrimaryWeaponStatusUpdate( OnPrimaryWeaponStatusUpdate_TitanSword )
		
		TitanSword_DisplayHint( player, "%attack% Heavy %zoom% Block", 5.0, TITAN_SWORD_MAIN_INSTRUCTIONS_DEBOUNCE_TIME )
		thread TitanSword_FuelMeterRui_Thread( weapon, player )
	#endif
	
	#if SERVER
		AddButtonPressedPlayerInputCallback( player, IN_USE_ALT, FS_MeleeSecondaryKey_Pressed )
	#endif
}

#if SERVER
void function TitanSword_Owner_Damaged( entity player, var damageInfo )
{
	if ( !IsValid( player ) )
		return

	float damageScale = GetDamageScaleForOwner( player, damageInfo )

	if ( damageScale == 1.0 )
		return

	DamageInfo_ScaleDamage( damageInfo, damageScale )
}

const float owner_damage_scale = 0.85
const float owner_damage_scale_super = 0.7
const float owner_damage_scale_fort = 1.0
const float owner_damage_scale_super_fort = 0.82

float function GetDamageScaleForOwner( entity player, var damageInfo )
{
	entity weapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
	if ( !IsValid( weapon ) || weapon.GetWeaponClassName() != "melee_titan_sword" && weapon.GetWeaponClassName() != "mp_weapon_titan_sword" )
	{
		// printt( "swordblock: no valid activeweapon" )
		return 1.0
	}
	
	if( PlayerHasPassive( player, ePassives.PAS_FORTIFIED) )
	{
		if( TitanSword_Super_IsActive( player ) )
			return owner_damage_scale_super_fort
		else if( !TitanSword_Super_IsActive( player ) )
			return owner_damage_scale_fort
	} else
	{
		if( TitanSword_Super_IsActive( player ) )
			return owner_damage_scale_super
		else if( !TitanSword_Super_IsActive( player ) )
			return owner_damage_scale
	}
	
	return 1.0
}
#endif

void function OnWeaponDeactivate_weapon_titan_sword( entity weapon )
{
	weapon.kv.rendercolor = <171, 52, 235>

	entity player = weapon.GetWeaponOwner()
	if ( !IsValid( player ) )
		return

	#if SERVER
	Warning( "DEACTIVATE " + weapon.GetWeaponClassName() + ". Mods: " + weapon.GetMods().len() + " Melee Attack Active?: " + player.PlayerMelee_IsAttackActive() )
	foreach( mod in weapon.GetMods() )
		Warning( "deac " + mod )
	#endif
	
	//Offhand
	/////////////////////////////////////////////////////////////
	if( weapon.GetWeaponClassName() == "melee_titan_sword" )
	{
		// weapon.RemoveMod( "slam" )
		// if( player.PlayerMelee_IsAttackActive() )
			// player.PlayerMelee_EndAttack()

		TitanSword_ClearMods( weapon )
		entity main = TitanSword_GetMainWeapon( player )
		if( IsValid( main ) )
			TitanSword_ClearMods( main )

		// TitanSword_Dash_OnWeaponDeactivate( player, weapon )
		// TitanSword_Slam_OnWeaponDectivate( player, weapon )
		// TitanSword_Super_OnWeaponDeactivate( player, weapon )
		return
	}
	/////////////////////////////////////////////////////////////

	#if CLIENT
		DeregisterConCommandTriggeredCallback( "+use_alt", FS_MeleeSecondaryKey_Pressed )
		DeregisterConCommandTriggeredCallback( "+scriptcommand3", FS_SuperKey_Pressed )
		
		weapon.Signal( SIG_TITAN_SWORD_DEACTIVATE )
	#endif

	#if SERVER
		RemoveButtonPressedPlayerInputCallback( player, IN_USE_ALT, FS_MeleeSecondaryKey_Pressed )
	#endif
}

void function OnWeaponCustomActivityEnd_weapon_titan_sword( entity weapon )
{
	// int activity = weapon.GetWeaponActivity()
	// switch( activity )
	// {
		// case ACT_VM_MELEE_ATTACK1:
		// case ACT_VM_MELEE_ATTACK2:
		// case ACT_VM_MELEE_ATTACK3:
		// case ACT_VM_MELEE_CHARGE:
		// case ACT_VM_MELEE_KNIFE:
		// case ACT_VM_MELEE_KNIFE_FIRST:
			// TitanSword_ClearMods( weapon )
			// break
	// }
}

void function TitanSword_SafelyAddAttackMod( entity weapon, string mod )
{
	#if CLIENT
		if ( !InPrediction() )
			return
	#endif
	
	if( !IsValid( weapon ) )
		return

	TitanSword_ClearMods(weapon)

	try
	{
		weapon.AddMod( mod )
		printt( mod + ". - mod added" )
	}catch(e420)
	{
		printt( "--------------------------------- DEBUG DEBUG DEBUG -> ", mod )
	}
}

void function TitanSword_ClearMods( entity weapon )
{
	#if CLIENT
		if ( !InPrediction() )
			return
	#endif

	TitanSword_Block_ClearMods( weapon )
	TitanSword_Dash_ClearMods( weapon )
	TitanSword_Slam_ClearMods( weapon )
	TitanSword_Heavy_ClearMods( weapon )
	TitanSword_Launcher_ClearMods( weapon )
	TitanSword_Super_ClearMods( weapon )

	// TitanSword_Light_StopVFX( weapon )
	weapon.RemoveMod( TITAN_SWORD_LIGHT_SUPER_MOD )
	
	printt("Removed all mods for weapon ", weapon.GetWeaponClassName() )
}

entity function TitanSword_GetMainWeapon( entity player )
{
	array<entity> wpns = player.GetMainWeapons()
	entity main
	foreach( wpn in wpns )
	{
		if( wpn.GetWeaponClassName() == "mp_weapon_titan_sword" )
			main = wpn
	}
	return main
}

bool function TitanSword_ActiveWeaponIsTitanSword( entity player )
{
	entity weapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
	if ( !IsValid( weapon ) )
		return false

	return TitanSword_WeaponIsTitanSword( weapon )
}

bool function TitanSword_WeaponIsTitanSword( entity weapon )
{
	return TitanSword_WeaponRefIsTitanSword( weapon.GetWeaponClassName() )
}

bool function TitanSword_WeaponRefIsTitanSword( string ref )
{
	return ref == TITAN_SWORD_WEAPON_REF
}

bool function TitanSword_DamageSourceIsTitanSword( int damageSourceId )
{
	return damageSourceId == eDamageSourceId.mp_weapon_titan_sword || damageSourceId == eDamageSourceId.melee_titan_sword || damageSourceId == eDamageSourceId.mp_weapon_titan_sword_slam
}

#if CLIENT
void function TitanSword_ClearHints()
{
	// ClearAnnouncements()
	HidePlayerHint( "Speed Increased.\nDamage Reduced.\nATB Unlocked.\nLimit Break Activated.")
	HidePlayerHint( "%scriptcommand3% Activate Super" )
	HidePlayerHint( "%attack% Heavy %zoom% Block" )
	HidePlayerHint( "%attack% SLAM" )
	HidePlayerHint( "Dash charging" )
	
	FS_TitanSword_AddPlayerHint( "", -1 )
}

void function TitanSword_DisplayHint( entity player, string message, float time = 6.0, float debounce = 0.0 )
{
	if ( !IsLocalViewPlayer( player ) )
		return

	switch( message )
	{
		case "%attack% SLAM":
		case "%attack& DASH":
			if ( Time() < file.debounceInstructionMsg )
				return
			file.debounceInstructionMsg = Time() + debounce
			break

		case "%attack% Heavy %zoom% Block":
			if ( Time() < file.debounceMainMsg )
				return
			file.debounceMainMsg = Time() + debounce
			break

		default:
			break
	}

	TitanSword_ClearHints()
	AddPlayerHint( time, 0.5, $"", message )
}

void function OnPrimaryWeaponStatusUpdate_TitanSword( entity selectedWeapon, var weaponRui )
{
	if ( !IsValid( selectedWeapon ) )
		return

	
	entity activeWeapon = GetLocalViewPlayer().GetActiveWeapon( eActiveInventorySlot.mainHand  )
	bool switchToMeleeOrGrenade = ( selectedWeapon.GetWeaponTypeFlags() & WPT_GRENADE ) > 0
	if ( IsValid( activeWeapon ) && activeWeapon != selectedWeapon )
	{
		if ( !( TitanSword_WeaponIsTitanSword( activeWeapon ) && switchToMeleeOrGrenade ) )
			activeWeapon.Signal( SIG_TITAN_SWORD_DESTROY_FUEL_RUI )
	}

	if ( TitanSword_WeaponIsTitanSword( selectedWeapon ) )
	{
		entity player = selectedWeapon.GetWeaponOwner()
		thread TitanSword_FuelMeterRui_Thread( selectedWeapon, player )
	}
}

bool function TitanSword_ClientPredictCheck( string power )
{
	// if ( !GetCurrentPlaylistVarBool( "titan_sword_predict_" + power, true ) )
		// return true
	
	if ( !InPrediction() || (InPrediction() && IsFirstTimePredicted()) )
		return true

	return false
}
#endif

void function TitanSword_UpdateFuelCrosshair( entity player, entity weapon )
{
	#if CLIENT
		if ( !InPrediction() || !IsFirstTimePredicted() )
			return
	#endif

	float scale = TitanSword_GetFuelScale( player )
	weapon.SetWeaponPrimaryClipCountNoRegenReset( weapon.GetWeaponSettingInt( eWeaponVar.ammo_clip_size ) * scale )
}

bool function TitanSword_TryUseFuel( entity player, bool playMessage = false )
{
	if ( !TitanSword_HasFuel( player ) )
	{
		#if CLIENT
			if ( Time() > file.debounceDashMsg )
			{
				
				if ( playMessage )
				{
					EmitSoundOnEntity( player, SFX_TITAN_SWORD_FUEL_NOT_READY )
					TitanSword_DisplayHint( player, "Dash charging", TITAN_SWORD_DASH_NOT_READY_DEBOUNCE_TIME_SEC + 0.5 )
				}
				file.debounceDashMsg = Time() + TITAN_SWORD_DASH_NOT_READY_DEBOUNCE_TIME_SEC
			}
		#endif
		return false
	}

	if ( !TitanSword_Super_IsActive( player ) )
	{
		#if CLIENT
			file.debounceDashMsg = Time() + TITAN_SWORD_DASH_NOT_READY_DEBOUNCE_TIME_SEC
		#endif

		float fuelCooldown = GetWeaponInfoFileKeyField_GlobalFloat( TITAN_SWORD_WEAPON_REF, "fuel_cooldown_sec" )
		StatusEffect_AddTimed( player, eStatusEffect.titan_sword_fuel, 1.0, fuelCooldown, 0.0 )

		entity weapon = TitanSword_GetMainWeapon( player )
		if ( IsValid( weapon ) )
			TitanSword_UpdateFuelCrosshair( player, weapon )
		
		#if SERVER




		#endif
	}
	return true
}

bool function TitanSword_HasFuel( entity player )
{
	return StatusEffect_GetSeverity( player, eStatusEffect.titan_sword_fuel ) == 0 || TitanSword_Super_IsActive( player )
}

void function TitanSword_FillFuel( entity player )
{
	#if CLIENT
		if ( InPrediction() )
			return
	#endif

	StatusEffect_StopAllOfType( player, eStatusEffect.titan_sword_fuel )
	entity weapon = TitanSword_GetMainWeapon( player )
	if ( IsValid( weapon ) )
		TitanSword_UpdateFuelCrosshair( player, weapon )
	
	printt( "Fuel Filled" )
}

float function TitanSword_GetFuelScale( entity player )
{
	if ( TitanSword_HasFuel( player ) )
		return 1.0

	float fuel = StatusEffect_GetTimeRemaining( player, eStatusEffect.titan_sword_fuel )
	float diff = fuel / GetWeaponInfoFileKeyField_GlobalFloat( TITAN_SWORD_WEAPON_REF, "fuel_cooldown_sec" )
	return 1.0 - diff
}

#if CLIENT
void function TitanSword_OnFuelFull( entity player, int statusEffect, bool actuallyChanged )
{
	printt( "TitanSword_OnFuelFull" )
	if ( !actuallyChanged )
		return

	if ( !IsLocalViewPlayer( player ) )
		return

	EmitSoundOnEntity( player, SFX_TITAN_SWORD_FUEL_READY )
}

void function TitanSword_FuelMeterRui_Thread( entity weapon, entity player )
{
	if ( !IsValid( weapon ) )
		return

	if ( weapon != player.GetActiveWeapon( eActiveInventorySlot.mainHand ) )
		return

	if ( !IsValid( player ) || !IsLocalViewPlayer( player ) )
		return

	weapon.Signal( SIG_TITAN_SWORD_DESTROY_FUEL_RUI )
	weapon.EndSignal( SIG_TITAN_SWORD_DESTROY_FUEL_RUI )
	weapon.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )
	
	var Border = HudElement( "TitanSword_FuelElementBorder")
	RuiSetImage( Hud_GetRui( Border ), "basicImage", $"rui/flowstate_custom/fs_titan_swod/2_border")
	Hud_SetVisible( Border, true )

	var Bg = HudElement( "TitanSword_FuelElementBg")
	RuiSetImage( Hud_GetRui( Bg ), "basicImage", $"rui/flowstate_custom/fs_titan_swod/2_bg")
	Hud_SetVisible( Bg, true )

	var Bar = HudElement( "TitanSword_FuelElementBar")
	RuiSetImage( Hud_GetRui( Bar ), "basicImage", $"rui/flowstate_custom/fs_titan_swod/2_bar")
	Hud_SetVisible( Bar, true )

	var Text = HudElement( "TitanSword_FuelElementText")
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
	
	if( file.firstTime )
		wait 2.15

	file.firstTime = false

	while( IsValid( player ) && IsValid( weapon ) )
	{
		float dashFrac = TitanSword_GetFuelScale( player )
		bool fuelFull = dashFrac >= 1.0
		bool hasUnlimitedDash = TitanSword_Super_IsActive( player )
		bool isBlocking = TitanSword_Block_IsBlocking( weapon )
		bool canLaunch = fuelFull && player.IsOnGround()
		string hintText = ""

		if ( isBlocking )
		{
			if ( fuelFull || hasUnlimitedDash )
			{
				hintText = "%attack% DASH"
			}
			else
			{
				hintText = "Dash charging"
			}
		}
		else
		{
			if ( canLaunch )
			{
				hintText = "%use_alt% LAUNCH"
			}
			else
			{
				hintText = "%use_alt% LIGHT ATTACK"
			}
		}

		SetWidth( Bar, dashFrac )
		Hud_SetText( Text, hintText )

		WaitFrame()
	}
}

void function SetWidth(var element, float chargeFraction)
{
	int baseWidth = Hud_GetBaseWidth( element )
	Hud_SetWidth( element, baseWidth*chargeFraction)
}
#endif

bool function TitanSword_Light_VictimHitOverride( entity weapon, entity attacker, entity victim, vector velocity )
{
	if ( !IsFriendlyTeam( attacker.GetTeam(), victim.GetTeam() ) )
	{
		#if SERVER
		FS_TitanSword_ReduceSuperCooldown( attacker, 0 )
		#endif
		if ( !victim.IsOnGround() && !attacker.IsOnGround() )
		{
			TitanSword_LaunchEntity( attacker, <0, 0, 150> )
			TitanSword_LaunchEntity( victim, <0, 0, 250> )

			printt( "Light attack on Air" )
			return true
		}
	}
	return false
}

void function TitanSword_LaunchEntity( entity victim, vector velocity )
{
	#if SERVER
	if ( victim.IsPlayer() )
	{
		victim.SetVelocity( velocity )
	}
	#endif
}

bool function FS_TitanSword_ModsShouldTriggerLunge( entity player, entity meleeWeapon )
{
	int currentUsedSlot = SURVIVAL_GetActiveWeaponSlot( gp()[0] )
	entity weapon
	if( currentUsedSlot != -1 )
		weapon = player.GetNormalWeapon( currentUsedSlot  )

	if( !IsValid( weapon ) || weapon.GetWeaponClassName() != "mp_weapon_titan_sword" )
		return false

	array<string> mods = clone weapon.GetMods()

	if( mods.len() == 0 )
		return true

	foreach ( mod in mods )
	{
		if ( mod == "launcher" || mod == "super_melee" )
			return true
	}

	return false
}

#if CLIENT
void function FS_SuperKey_Pressed( entity player )
{
	if( !IsValid( player ) )
		return

	printt( "Flowstate TitanSword Start - Super key was pressed" )
	FS_TitanSword_Super_OnKeyPressed( player )
}
#endif

void function FS_MeleeSecondaryKey_Pressed( entity player )
{
	if( !IsValid( player ) ) // || player.PlayerMelee_IsAttackActive() )
		return
	
	player.p.isSecondaryMeleeAttack = true

	#if CLIENT
	player.ClientCommand( "+melee" )
	player.ClientCommand( "-melee" )
	#endif
}

#if CLIENT
void function FS_TitanSword_AddPlayerHint( string msg, float duration )
{
	if ( file.quickRightMsg != null || msg == "" && file.quickRightMsg != null )
	{
		RuiDestroyIfAlive( file.quickRightMsg )
		file.quickRightMsg = null

		if( msg == "" )
			return

	}

	file.quickRightMsg = CreateFullscreenRui( $"ui/wraith_comms_hint.rpak" )
	RuiSetGameTime( file.quickRightMsg, "startTime", Time() )
	RuiSetGameTime( file.quickRightMsg, "endTime", Time() + duration )
	RuiSetBool( file.quickRightMsg, "commsMenuOpen", false )
	RuiSetString( file.quickRightMsg, "msg", msg )
}
#endif