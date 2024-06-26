//By @CafeFPS and Respawn

global function MpWeaponTitanSword_Super_Init
global function TitanSword_Super_OnWeaponActivate
global function TitanSword_Super_OnWeaponDeactivate
global function TitanSword_Super_ClearMods
global function TitanSword_Super_IsFirstPickup
global function TitanSword_Super_HasCharge
global function TitanSword_Super_IsActive

#if CLIENT
global function ServerToClient_TitanSword_StartSuperFx
global function ServerToClient_TitanSword_StopSuperFx
global function ServerToClient_TitanSword_AddChargeFx
global function FS_TitanSword_Super_OnKeyPressed
global function ServerCallback_TitanSword_SuperReady
#endif

#if SERVER
global function FS_TitanSword_Super_Thread
global function	FS_TitanSword_ReduceSuperCooldown
#endif

const string TITAN_SWORD_SUPER_MOD = "super"

const string PVAR_TITAN_SWORD_MAX_SUPER = "titan_sword_super_max"
const string PVAR_TITAN_SWORD_SUPER_WHIFF_RESET = "titan_sword_super_whiff_reset"
const string PVAR_TITAN_SWORD_SUPER_TICK = "titan_sword_super_tick"
const string PVAR_TITAN_SWORD_SUPER_PER_TICK = "titan_sword_super_per_tick"
const string PVAR_TITAN_SWORD_SUPER_DECAY = "titan_sword_super_decay"

const string SIG_TITAN_SWORD_DESTROY_SUPER_RUI = "TitanSword_DestroySuperRui"
const string SIG_TITAN_SWORD_ALIVE_THREAD = "TitanSword_BeepThread"
const string SIG_TITAN_SWORD_SUPER_STOP = "TitanSword_Super_Stop"

const string NETVAR_TITAN_SWORD_SUPER = "TitanSwordSuper"

const array<int> TITAN_SWORD_SLOTS_TO_LOCK = [
	WEAPON_INVENTORY_SLOT_PRIMARY_0,
	WEAPON_INVENTORY_SLOT_PRIMARY_1,
	WEAPON_INVENTORY_SLOT_PRIMARY_2,
	WEAPON_INVENTORY_SLOT_PRIMARY_3
]

const float TITAN_SWORD_SUPER_ACTIVATION_DURATION = 2.33

const asset VFX_TITAN_SWORD_SUPER_ACTIVATE = $"P_pilot_powerup_flash"
const asset VFX_TITAN_SWORD_SUPER_1P = $"P_player_boost_screen"
const asset VFX_TITAN_SWORD_SUPER_3P = $"P_pilot_powerup_chest"
const asset VFX_TITAN_SWORD_SUPER_WEAPON_START_GLOWING_1P = $"P_pilot_sword_charging_FP" 
const asset VFX_TITAN_SWORD_SUPER_WEAPON_START_GLOWING_3P = $"P_pilot_sword_charging_3P" 
const asset VFX_TITAN_SWORD_SUPER_WEAPON_ACTIVATE_1P = $"P_pilot_sword_charged_FP" 
const asset VFX_TITAN_SWORD_SUPER_WEAPON_ACTIVATE_3P = $"P_pilot_sword_charged_3P"
const asset VFX_TITAN_SWORD_SUPER_WEAPON_CONTINUOUS_1P = $"P_pilot_sword_swipe_super_FP" 
const asset VFX_TITAN_SWORD_SUPER_WEAPON_CONTINUOUS_3P = $"P_pilot_sword_swipe_super_3P"

const string SFX_TITAN_SWORD_SUPER_READY = "Titan_Legion_Smart_Core_Unlocked_1P"
const string SFX_TITAN_SWORD_SUPER_START_1P = "titansword_special_super_start_1p"
const string SFX_TITAN_SWORD_SUPER_START_3P = "titansword_special_super_start_3p"
const string SFX_TITAN_SWORD_SUPER_ACTIVATE_1P = "Titan_Legion_Smart_Core_Activated_1P"
const string SFX_TITAN_SWORD_SUPER_ACTIVATE_3P = "Titan_Legion_Smart_Core_Activated_3P"
const string SFX_TITAN_SWORD_SUPER_ACTIVATE_3P_ENEMY = "Titan_Legion_Smart_Core_Activated_3P_enemy"

const asset RUI_TITAN_SWORD_SUPER_HUD = $"ui/weapon_hud_charged_gh.rpak"

struct
{
	#if CLIENT
		int superFxHandle
		int superFxHandle2
	#elseif SERVER
		bool wasactive = false
		bool showReadyHint = false
	#endif
	var superRui
}file


void function MpWeaponTitanSword_Super_Init()
{
	// PrecacheParticleSystem( VFX_TITAN_SWORD_SUPER_ACTIVATE )
	PrecacheParticleSystem( VFX_TITAN_SWORD_SUPER_1P )
	// PrecacheParticleSystem( VFX_TITAN_SWORD_SUPER_3P )
	// PrecacheParticleSystem( VFX_TITAN_SWORD_SUPER_WEAPON_START_GLOWING_1P )
	// PrecacheParticleSystem( VFX_TITAN_SWORD_SUPER_WEAPON_START_GLOWING_3P )
	// PrecacheParticleSystem( VFX_TITAN_SWORD_SUPER_WEAPON_ACTIVATE_1P )
	// PrecacheParticleSystem( VFX_TITAN_SWORD_SUPER_WEAPON_ACTIVATE_3P )
	// PrecacheParticleSystem( VFX_TITAN_SWORD_SUPER_WEAPON_CONTINUOUS_1P )
	// PrecacheParticleSystem( VFX_TITAN_SWORD_SUPER_WEAPON_CONTINUOUS_3P )

	Remote_RegisterClientFunction( "ServerToClient_TitanSword_StartSuperFx" )
	Remote_RegisterClientFunction( "ServerToClient_TitanSword_StopSuperFx" )
	// Remote_RegisterClientFunction( "ServerToClient_TitanSword_AddChargeFx" )
	#if SERVER
		RegisterSignal( SIG_TITAN_SWORD_ALIVE_THREAD )
		RegisterSignal( SIG_TITAN_SWORD_SUPER_STOP )
		AddClientCommandCallback( "FS_TitanSword_ActivateSuper", ClientCommand_OnActivateSuper )
	#elseif CLIENT
		RegisterSignal( SIG_TITAN_SWORD_DESTROY_SUPER_RUI )
		AddCallback_OnPrimaryWeaponStatusUpdate( OnPrimaryWeaponStatusUpdate_TitanSwordSuper )
	#endif
}

void function TitanSword_Super_StartGlowingVFX( entity weapon )
{
	// weapon.PlayWeaponEffect( VFX_TITAN_SWORD_SUPER_WEAPON_START_GLOWING_1P, VFX_TITAN_SWORD_SUPER_WEAPON_START_GLOWING_3P, "blade_mid" )
}

void function TitanSword_Super_StopGlowingVFX( entity weapon )
{
	// weapon.StopWeaponEffect( VFX_TITAN_SWORD_SUPER_WEAPON_START_GLOWING_1P, VFX_TITAN_SWORD_SUPER_WEAPON_START_GLOWING_3P )
}

void function TitanSword_Super_StartActivationVFX( entity weapon )
{
	// weapon.PlayWeaponEffect( VFX_TITAN_SWORD_SUPER_WEAPON_ACTIVATE_1P, VFX_TITAN_SWORD_SUPER_WEAPON_ACTIVATE_3P, "blade_mid" )
}

void function TitanSword_Super_StopActivationVFX( entity weapon )
{
	// weapon.StopWeaponEffect( VFX_TITAN_SWORD_SUPER_WEAPON_ACTIVATE_1P, VFX_TITAN_SWORD_SUPER_WEAPON_ACTIVATE_3P )
}


void function TitanSword_Super_StartContinuousVFX( entity weapon )
{
	
	// weapon.PlayWeaponEffect( VFX_TITAN_SWORD_SUPER_WEAPON_CONTINUOUS_1P, VFX_TITAN_SWORD_SUPER_WEAPON_CONTINUOUS_3P, "blade_mid", true )
}

void function TitanSword_Super_StopContinuousVFX( entity weapon )
{
	// weapon.StopWeaponEffect( VFX_TITAN_SWORD_SUPER_WEAPON_CONTINUOUS_1P, VFX_TITAN_SWORD_SUPER_WEAPON_CONTINUOUS_3P )
}

void function TitanSword_Super_OnWeaponActivate( entity player, entity weapon )
{
	#if CLIENT
		thread TitanSword_SuperRui_Thread( weapon, player )

		if ( !InPrediction() )
			return

		
	#endif

	entity melee = GetPlayerMeleeOffhandWeapon( player )

	if ( TitanSword_Super_IsActive( player ) )
	{
		TitanSword_Super_StartContinuousVFX( weapon )
		if ( !weapon.HasMod( TITAN_SWORD_SUPER_MOD ) )
		{
			weapon.AddMod( TITAN_SWORD_SUPER_MOD )
		}
		
		if( IsValid( melee ) && melee.GetWeaponClassName() == "melee_titan_sword" && !melee.HasMod( TITAN_SWORD_SUPER_MOD ) )
		{
			melee.AddMod( TITAN_SWORD_SUPER_MOD )
		}
	}
	else
	{
		if ( weapon.HasMod( TITAN_SWORD_SUPER_MOD ) )
		{
			weapon.RemoveMod( TITAN_SWORD_SUPER_MOD )
		}

		if( IsValid( melee ) && melee.GetWeaponClassName() == "melee_titan_sword" && melee.HasMod( TITAN_SWORD_SUPER_MOD ) )
		{
			melee.RemoveMod( TITAN_SWORD_SUPER_MOD )
		}
	}
}
void function TitanSword_Super_OnWeaponDeactivate( entity player, entity weapon )
{
	TitanSword_Super_StopGlowingVFX( weapon )
	TitanSword_Super_StopActivationVFX( weapon )
	TitanSword_Super_StopContinuousVFX( weapon )
}

void function TitanSword_Super_ClearMods( entity weapon )
{
}

float function TitanSword_Super_GetCharge( entity player )
{
	return player.GetPlayerNetTime( NETVAR_TITAN_SWORD_SUPER )
}

bool function TitanSword_Super_HasCharge( entity player )
{
	return Time() >= TitanSword_Super_GetCharge( player )
}

bool function TitanSword_Super_ChargingStopped( entity player )
{
	return player.GetPlayerNetTime( NETVAR_TITAN_SWORD_SUPER ) <= -1.0
}

bool function TitanSword_Super_IsFirstPickup( entity player )
{
	return player.GetPlayerNetTime( NETVAR_TITAN_SWORD_SUPER ) <= -2.0
}

float function TitanSword_Super_GetChargeScale( entity player )
{
	if ( TitanSword_Super_IsActive( player ) )
	{
		float active = StatusEffect_GetTimeRemaining( player, eStatusEffect.titan_sword_super )
		float diff   = active / GetWeaponInfoFileKeyField_GlobalFloat( TITAN_SWORD_WEAPON_REF, "super_active_sec" )
		return clamp( diff, 0.0, 1.0 )
	}

	if ( TitanSword_Super_ChargingStopped( player ) )
		return 0.0

	if ( TitanSword_Super_HasCharge( player ) )
		return 1.0

	float charge = TitanSword_Super_GetCharge( player ) - Time()
	
	float diff   = charge / GetWeaponInfoFileKeyField_GlobalFloat( TITAN_SWORD_WEAPON_REF, "super_cooldown_sec" )

	return clamp( 1.0 - diff, 0.0, 1.0 )
}

bool function TitanSword_Super_IsActive( entity player )
{
	return StatusEffect_GetSeverity( player, eStatusEffect.titan_sword_super ) > 0
}

#if CLIENT
void function FS_TitanSword_Super_OnKeyPressed( entity player )
{
	if ( player != GetLocalViewPlayer() )
		return

	if ( !TryActivateSuper( player ) )
		return

	player.ClientCommand( "FS_TitanSword_ActivateSuper" ) //Do the server checks and start mod

	entity activeWeapon = TitanSword_GetMainWeapon( player )
	if ( IsValid( activeWeapon ) )
		TitanSword_Super_StartGlowingVFX( activeWeapon )

	string hintBase = "Speed Increased.\nDamage Reduced.\nATB Unlocked.\nLimit Break Activated."
	
	TitanSword_ClearHints()
	AnnouncementMessageRight( player, hintBase, "", <1, 1, 0>, $"", 5.0 )

	if ( !InPrediction() || (InPrediction() && IsFirstTimePredicted()) )
	{
		EmitSoundOnEntity( player, SFX_TITAN_SWORD_SUPER_ACTIVATE_1P )
	}
}

void function ServerToClient_TitanSword_StartSuperFx()
{
	entity player = GetLocalViewPlayer()

	entity cockpit = player.GetCockpit()
	if ( !IsValid( cockpit ) )
		return

	int fxID = GetParticleSystemIndex( VFX_TITAN_SWORD_SUPER_1P )
	file.superFxHandle = StartParticleEffectOnEntity( cockpit, fxID, FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
	EffectSetIsWithCockpit( file.superFxHandle, true )

	int fxID2 = GetParticleSystemIndex( $"P_sprint_FP" )
	file.superFxHandle2 = StartParticleEffectOnEntity( cockpit, fxID2, FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
	EffectSetIsWithCockpit( file.superFxHandle2, true )

	entity weapon = TitanSword_GetMainWeapon ( player )
	if ( IsValid( weapon ) )
	{
		TitanSword_Super_StopGlowingVFX( weapon )
		TitanSword_Super_StartActivationVFX( weapon )
		TitanSword_Super_StartContinuousVFX( weapon )
	}
}

void function ServerToClient_TitanSword_StopSuperFx()
{
	if ( EffectDoesExist( file.superFxHandle ) )
	{
		EffectStop( file.superFxHandle, false, true )
	}

	if ( EffectDoesExist( file.superFxHandle2 ) )
	{
		EffectStop( file.superFxHandle2, false, true )
	}

	entity player = GetLocalViewPlayer()

	entity weapon = TitanSword_GetMainWeapon ( player )
	if ( IsValid( weapon ) )
	{
		TitanSword_Super_StopGlowingVFX( weapon )
		TitanSword_Super_StopActivationVFX( weapon )
		TitanSword_Super_StopContinuousVFX( weapon )
	}
}

void function ServerCallback_TitanSword_SuperReady( entity player )
{
	#if DEVELOPER
		printt( "SUPER READY: " + player + " :: " + GetLocalViewPlayer() )
	#endif 
	
	if ( player != GetLocalViewPlayer() )
		return

	FS_TitanSword_AddPlayerHint( "%scriptCommand3% Activate Limit Break", 8.0 )

	if ( !InPrediction() || (InPrediction() && IsFirstTimePredicted()) )
	{
		EmitSoundOnEntity( player, SFX_TITAN_SWORD_SUPER_READY )
	}
}

void function ServerToClient_TitanSword_AddChargeFx()
{
	// if ( file.superRui != null )
		// RuiSetGameTime( file.superRui, "flashStartTime", Time() )
}
#endif

#if SERVER
void function FS_TitanSword_Super_Thread( entity player, entity weapon )
{
	if( !IsValid( player ) )
		return

	Signal( player, SIG_TITAN_SWORD_ALIVE_THREAD )
	EndSignal( player, SIG_TITAN_SWORD_ALIVE_THREAD )

	float activeTime = GetWeaponInfoFileKeyField_GlobalFloat( TITAN_SWORD_WEAPON_REF, "super_active_sec" ) //20
	float cooldown = GetWeaponInfoFileKeyField_GlobalFloat( TITAN_SWORD_WEAPON_REF, "super_cooldown_sec" ) //200

	while( true )
	{
		wait 0.1

		if( !IsValid( player ) )
			break

		if( !IsAlive( player ) || !IsValid( weapon ) )
		{
			player.SetPlayerNetTime( "TitanSwordSuper", -2 )
			EmitSoundOnEntityOnlyToPlayer( player, player, "ui_lobby_starearned_empty" )
			StopSoundOnEntity( player, "Titan_Legion_Smart_Core_ActiveLoop_1P" )
			Remote_CallFunction_NonReplay( player, "ServerToClient_TitanSword_StopSuperFx" )
			break
		}

		if( TitanSword_Super_IsFirstPickup( player ) )
		{
			player.SetPlayerNetTime( "TitanSwordSuper", Time() + cooldown )
			
				#if DEVELOPER
					printt( "Super thread started, Super will be available in ", cooldown, " cooldown."  )
				#endif
			continue
		}

		if( !TitanSword_Super_IsActive( player ) && file.wasactive )
		{
			weapon.RemoveMod( TITAN_SWORD_SUPER_MOD )

			entity melee = GetPlayerMeleeOffhandWeapon( player )
			if( IsValid( melee ) && melee.GetWeaponClassName() == "melee_titan_sword" )
			{
				melee.RemoveMod( TITAN_SWORD_SUPER_MOD )
			}

			player.SetPlayerNetTime( "TitanSwordSuper", Time() + cooldown )
			file.wasactive = false
			file.showReadyHint = false
			EmitSoundOnEntityOnlyToPlayer( player, player, "ui_lobby_starearned_empty" )
			StopSoundOnEntity( player, "Titan_Legion_Smart_Core_ActiveLoop_1P" )
			Remote_CallFunction_NonReplay( player, "ServerToClient_TitanSword_StopSuperFx" )
			continue
		}

		if( !TitanSword_Super_IsActive( player ) && TitanSword_Super_HasCharge( player ) && !file.showReadyHint && !TitanSword_Super_IsFirstPickup( player ) )
		{
			Remote_CallFunction_NonReplay( player, "ServerCallback_TitanSword_SuperReady", player )
			file.showReadyHint = true
			continue
		}

		if( TitanSword_Super_IsActive( player ) && !file.wasactive )
		{
			file.wasactive = true
			continue
		}
	}
}

void function FS_TitanSword_ReduceSuperCooldown( entity player, int type = -1)
{
	if( TitanSword_Super_IsActive( player ) || TitanSword_Super_HasCharge( player ) )
		return

	float currentNextSuperTime = TitanSword_Super_GetCharge( player )
	float toIncrease = type == 0 ? 0.02 : 0.05
	float cooldown = GetWeaponInfoFileKeyField_GlobalFloat( TITAN_SWORD_WEAPON_REF, "super_cooldown_sec" ) //200

	player.SetPlayerNetTime( "TitanSwordSuper", currentNextSuperTime - ( cooldown * toIncrease ) )
}

bool function ClientCommand_OnActivateSuper( entity player, array<string> args )
{
	#if DEVELOPER
		printt( "FLOWSTATE SERVER - OnSuperKeyPressed TryToActivateSuper" )
	#endif

	if( !IsValid( player ) )
		return false

	if ( !TryActivateSuper( player ) )
		return false

	thread function() : ( player )
	{
		player.LockWeaponChange()
		// player.DisableWeaponWithSlowHolster()
		
		player.p.startingSuperAlready = true

		entity melee = GetPlayerMeleeOffhandWeapon( player )
		entity main = TitanSword_GetMainWeapon( player )

		if( !IsValid( melee ) || melee.GetWeaponClassName() != "melee_titan_sword" || !IsValid( main ) || main.GetWeaponClassName() != "mp_weapon_titan_sword" )
			return

		main.SetNextAttackAllowedTime( Time() + TITAN_SWORD_SUPER_ACTIVATION_DURATION )
		melee.SetNextAttackAllowedTime( Time() + TITAN_SWORD_SUPER_ACTIVATION_DURATION )
			
		main.StartCustomActivity("ACT_VM_DRAWFIRST", 0)

		foreach(sPlayer in GetPlayerArray() )
		{
			if( sPlayer == player )
				continue
			
			if( player.GetTeam() == sPlayer.GetTeam() )
				EmitSoundOnEntityOnlyToPlayer( player, sPlayer, SFX_TITAN_SWORD_SUPER_ACTIVATE_3P )
			else
				EmitSoundOnEntityOnlyToPlayer( player, sPlayer, SFX_TITAN_SWORD_SUPER_ACTIVATE_3P_ENEMY )
		}

		wait TITAN_SWORD_SUPER_ACTIVATION_DURATION
		
		if( !IsValid( player ) || !IsValid( melee ) || melee.GetWeaponClassName() != "melee_titan_sword" || !IsValid( main ) || main.GetWeaponClassName() != "mp_weapon_titan_sword" || !IsAlive( player ) )
		{
			player.EnableWeapon()
			player.p.startingSuperAlready = false
			player.UnlockWeaponChange()
			return
		}

		EmitSoundOnEntityExceptToPlayer( player, player, SFX_TITAN_SWORD_SUPER_START_3P )
		EmitSoundOnEntityOnlyToPlayer( player, player, SFX_TITAN_SWORD_SUPER_START_1P )
		EmitSoundOnEntityOnlyToPlayer( player, player, "Titan_Legion_Smart_Core_ActiveLoop_1P" )
		Remote_CallFunction_NonReplay( player, "ServerToClient_TitanSword_StartSuperFx" )

		player.p.startingSuperAlready = false
		// player.EnableWeapon()
		if( main.IsInCustomActivity() )
			main.StopCustomActivity()

		player.UnlockWeaponChange()
		// main.Deploy()

		float cooldown = GetWeaponInfoFileKeyField_GlobalFloat( TITAN_SWORD_WEAPON_REF, "super_active_sec" )
		StatusEffect_AddTimed( player, eStatusEffect.titan_sword_super, 1.0, cooldown, 0.0 )

		TitanSword_FillFuel( player )

		if( IsValid( melee ) && melee.GetWeaponClassName() == "melee_titan_sword" && IsValid( main ) && main.GetWeaponClassName() == "mp_weapon_titan_sword" )
		{
			if( !main.HasMod( TITAN_SWORD_SUPER_MOD ) )
			{
				main.AddMod( TITAN_SWORD_SUPER_MOD )
				// main.Raise()
			}

			if( !melee.HasMod( TITAN_SWORD_SUPER_MOD ) )
			{
				melee.AddMod( TITAN_SWORD_SUPER_MOD )
			}
		}

		#if DEVELOPER
			printt( "SUPER ACTIVATED FOR PLAYER - ", player )
		#endif
	}()

	return true
}
#endif

bool function TryActivateSuper( entity player )
{
	#if SERVER
	if( player.p.startingSuperAlready )
		return false
	#endif

	if ( TitanSword_Super_IsActive( player ) )
		return false

	if ( !TitanSword_Super_HasCharge( player ) )
		return false

	if ( player.IsMantling() || player.IsWallRunning() || player.IsWallHanging() )
		return false

	entity activeWeapon = TitanSword_GetMainWeapon( player )
	if ( !IsValid( activeWeapon ) )
		return false

	if ( !activeWeapon.IsReadyToFire() )
		return false

	if ( activeWeapon.HasMod( TITAN_SWORD_SUPER_MOD ) )
		return false
	
	return true
}

#if CLIENT
void function OnPrimaryWeaponStatusUpdate_TitanSwordSuper( entity selectedWeapon, var weaponRui )
{
	if ( !IsValid( selectedWeapon ) )
		return

	entity activeWeapon         = GetLocalViewPlayer().GetActiveWeapon( eActiveInventorySlot.mainHand )
	bool switchToMeleeOrGrenade = ( selectedWeapon.GetWeaponTypeFlags() & WPT_GRENADE ) > 0
	if ( IsValid( activeWeapon ) && activeWeapon != selectedWeapon )
	{
		if ( !(TitanSword_WeaponIsTitanSword( activeWeapon ) && switchToMeleeOrGrenade) )
			activeWeapon.Signal( SIG_TITAN_SWORD_DESTROY_SUPER_RUI )
	}

	if ( TitanSword_WeaponIsTitanSword( selectedWeapon ) )
	{
		entity player = selectedWeapon.GetWeaponOwner()
		thread TitanSword_SuperRui_Thread( selectedWeapon, player )
	}
}

void function TitanSword_SuperRui_Thread( entity weapon, entity player )
{
	if ( !IsValid( player ) )
		return

	if ( !IsLocalViewPlayer( player ) )
		return

	if ( weapon != player.GetActiveWeapon( eActiveInventorySlot.mainHand ) )
		return

	weapon.Signal( SIG_TITAN_SWORD_DESTROY_SUPER_RUI )
	weapon.EndSignal( SIG_TITAN_SWORD_DESTROY_SUPER_RUI )
	weapon.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )

	var Border = HudElement( "TitanSword_SuperElementBorder")
	RuiSetImage( Hud_GetRui( Border ), "basicImage", $"rui/flowstate_custom/fs_titan_swod/1_border")
	Hud_SetVisible( Border, true )

	var Bg = HudElement( "TitanSword_SuperElementBg")
	RuiSetImage( Hud_GetRui( Bg ), "basicImage", $"rui/flowstate_custom/fs_titan_swod/1_bg")
	Hud_SetVisible( Bg, true )

	var Bar = HudElement( "TitanSword_SuperElementBar")
	RuiSetImage( Hud_GetRui( Bar ), "basicImage", $"rui/flowstate_custom/fs_titan_swod/1_bar")
	Hud_SetVisible( Bar, true )

	var Text = HudElement( "TitanSword_SuperElementText")
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

	while( IsValid ( weapon ) && IsValid( player ) )
	{
		float superFrac       = TitanSword_Super_GetChargeScale( player )
		string chargeBarText  = ""
		bool superIsActive    = TitanSword_Super_IsActive( player )

		if ( !superIsActive )
		{
			if ( superFrac >= 1.0 )
			{
				chargeBarText = "%scriptCommand3% ACTIVATE"
			}
			else
			{
				chargeBarText = "LIMIT BREAK " + int( (superFrac*100) ).tostring() + "%"
			}
		}

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

vector function GetSuperColor( float frac )
{
	if ( frac < 1.0 )
		return <255, 234, 0>

	return <255, 0, 255>
}
#endif
