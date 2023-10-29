// Updated by @CafeFPS

// en retail hay un delay cuando el drone pasa a ser válido para usar el recall, probablemente hasta el final de la anim, setear algo allí
// add idle living drone sound
// sometimes drone will be destroyed (the deployable ent)
// fix some sounds
// LOS check in scan feature?
// change icon rui?
// Fix hacked map banners randomly showing?
// Fix hacked map pings and enemies count

global function MpAbilityCryptoDrone_Init
global function OnWeaponTossReleaseAnimEvent_ability_crypto_drone
global function OnWeaponAttemptOffhandSwitch_ability_crypto_drone
global function OnWeaponTossPrep_ability_crypto_drone
global function OnWeaponToss_ability_crypto_drone
global function OnWeaponRegenEnd_ability_crypto_drone
global function IsPlayerInCryptoDroneCameraView
global function CryptoDrone_SetMaxZ
global function CryptoDrone_GetPlayerDrone

#if CLIENT
global function OnClientAnimEvent_ability_crypto_drone
global function UpdateCameraVisibility
global function CreateCameraCircleStatusRui
global function DestroyCameraCircleStatusRui
global function GetCameraCircleStatusRui
global function CreateCryptoAnimatedTacticalRui
global function DestroyCryptoAnimatedTacticalRui
global function GetCryptoAnimatedTacticalRui
global function CryptoDrone_OnPlayerTeamChanged
#endif

const asset CAMERA_MODEL = $"mdl/props/crypto_drone/crypto_drone.rmdl"

const asset CAMERA_FX = $"P_drone_camera"
const asset VISOR_FX_3P = $"P_crypto_visor_ui"
const asset DRONE_RECALL_START_FX_3P = $"P_drone_recall_start"
const asset DRONE_RECALL_END_FX_3P = $"P_drone_recall_end"
const asset SCREEN_FX = $"P_crypto_hud_boot"
const asset SCREEN_FAST_FX = $"P_crypto_hud_boot_fast"
const string DRONE_PROPULSION_1P = "Char_11_TacticalA_E"
const string DRONE_PROPULSION_3P = "Char_11_TacticalA_E_3P"
const string DRONE_EXPLOSION_3P = "Char_11_TacticalA_F_3p"
const string DRONE_EXPLOSION_1P = "Char_11_TacticalA_F"

const string DRONE_SCANNING_3P = "Char_11_TacticalA_E2_3p"

const string DRONE_ALERT_1P = "Char_11_TacticalA_Ping"
const string DRONE_ALERT_3P = "Char_11_TacticalA_Ping"

const float CAMERA_SCAN_RANGE = 1024
const float CAMERA_SCAN_FOV = 90

const string TRANSITION_OUT_CAMERA_1P = "Char_11_TacticalA_D"
const string TRANSITION_OUT_CAMERA_3P = "Char_11_TacticalA_D"
const string HACK_SFX_1P = "Coop_AmmoBox_AmmoRefill"
const string HACK_SFX_3P = "Coop_AmmoBox_AmmoRefill"


const string DRONE_RECALL_1P = "Char_11_TacticalA_A"
const string DRONE_RECALL_3P = "Char_11_TacticalA_A"
const string DRONE_RECALL_CRYPTO_3P = "Char_11_TacticalA_A"

global const float EMP_RANGE = 1181.1
global const float MAX_FLIGHT_RANGE = 7913
const float WARNING_RANGE = 5906
const float CAMERA_FLIGHT_SPEED = 450

global float CRYPTO_DRONE_DAMAGED_REENTER_DEBOUNCE = 1.4
const asset CAMERA_MAX_RANGE_SCREEN_FX = $"P_crypto_drone_screen_distort_CP"
const asset CAMERA_EXPLOSION_FX	= $"P_crypto_drone_explosion"
const asset CAMERA_HIT_FX = $"P_drone_shield_hit"
const asset CAMERA_HIT_ENEMY_FX = $"P_drone_shield_hit_enemy"
const float NEUROLINK_VIEW_MINDOT = 80.0
const int CRYPTO_DRONE_HEALTH = 60
const float DEPLOYABLE_CAMERA_THROW_POWER = 400.0
const float NEUROLINK_VIEW_MINDOT_BUFFED = 120.0
const int CRYPTO_DRONE_HEALTH_PROJECTILE = 50
const float CRYPTO_DRONE_STICK_RANGE = 670.0

const vector CRYPTO_DRONE_HULL_TRACE_MIN	= <-14, -14, 0>
const vector CRYPTO_DRONE_HULL_TRACE_MAX	= <14, 14, 14>
const asset CRYPTO_DRONE_SIGHTBEAM_FX = $"P_BT_scan_SML" //P_BT_scan_SML r5r version?

global const string CRYPTO_DRONE_SCRIPTNAME = "crypto_camera"
global const string CRYPTO_DRONE_TARGETNAME = "drone_no_minimap_object"

struct
{
	#if CLIENT
	var cameraRui
	var cameraCircleStatusRui
	var cryptoAnimatedTacticalRui
	var fakePlayerMarkerRui
	#endif
	
	array <entity> allDrones

	#if SERVER
	table< entity, array<int> > entitySonarHandles
	table< int, int > teamSonarCount
	array< void functionref( entity, vector, int, entity ) > SonarStartGrenadeCallbacks = []
	#endif
	
	float neurolinkRange
	float droneMaxZ = 100000
	int   droneHealth
	bool  ForceExitDroneView = false

	array<void functionref()> onEnterDroneViewCallbacks
	array<void functionref()> onLeaveDroneViewCallbacks
	array<void functionref()> onRecallDroneCallbacks


} file


void function MpAbilityCryptoDrone_Init()
{
	PrecacheModel( CAMERA_MODEL )
	PrecacheParticleSystem( CAMERA_FX )
	PrecacheParticleSystem( CAMERA_EXPLOSION_FX )
	PrecacheParticleSystem( CAMERA_MAX_RANGE_SCREEN_FX )
	PrecacheParticleSystem( VISOR_FX_3P )
	PrecacheParticleSystem( DRONE_RECALL_START_FX_3P )
	PrecacheParticleSystem( DRONE_RECALL_END_FX_3P )
	PrecacheParticleSystem( SCREEN_FX )
	PrecacheParticleSystem( SCREEN_FAST_FX )
	PrecacheParticleSystem( CAMERA_HIT_FX )
	PrecacheParticleSystem( CAMERA_HIT_ENEMY_FX )

	#if SERVER
		AddClientCommandCallback( "AttemptDroneRecall", Flowstate_ClientCommand_AttemptDroneRecall )
	#else
		RegisterSignal( "StopUpdatingCameraRui" )
		RegisterSignal( "CameraViewEnd" )
		RegisterSignal( "CameraViewStart" )
		StatusEffect_RegisterEnabledCallback( eStatusEffect.crypto_camera_is_recalling, Camera_OnBeginRecall )
		StatusEffect_RegisterDisabledCallback( eStatusEffect.crypto_camera_is_recalling, Camera_OnEndRecall )
		StatusEffect_RegisterEnabledCallback( eStatusEffect.camera_view, Camera_OnBeginView )
		StatusEffect_RegisterDisabledCallback( eStatusEffect.camera_view, Camera_OnEndView )
		StatusEffect_RegisterEnabledCallback( eStatusEffect.crypto_has_camera, Camera_OnCreate )
		StatusEffect_RegisterDisabledCallback( eStatusEffect.crypto_has_camera, Camera_OnDestroy )
		AddCreateCallback( "player_vehicle", CryptoDrone_OnPropScriptCreated )
		AddDestroyCallback( "player_vehicle", CryptoDrone_OnPropScriptDestroyed )
		AddCallback_OnPlayerChangedTeam( CryptoDrone_OnPlayerTeamChanged )

		if( !GetCurrentPlaylistVarBool( "enable_oddball_gamemode", false ) && GameRules_GetGameMode() != "custom_ctf" )
			RegisterConCommandTriggeredCallback( "+scriptCommand5", AttemptDroneRecall )

		AddCallback_OnWeaponStatusUpdate( CryptoDrone_WeaponStatusCheck )
		AddCallback_OnPlayerLifeStateChanged( CryptoDrone_OnLifeStateChanged )

		AddCallback_CreatePlayerPassiveRui( CreateCameraCircleStatusRui )
		AddCallback_DestroyPlayerPassiveRui( DestroyCameraCircleStatusRui )

		AddCallback_CreatePlayerPassiveRui( CreateCryptoAnimatedTacticalRui )
		AddCallback_DestroyPlayerPassiveRui( DestroyCryptoAnimatedTacticalRui )

	#endif

	file.neurolinkRange = GetCurrentPlaylistVarFloat( "crypto_neurolink_range", EMP_RANGE )
	RegisterSignal( "Crypto_Immediate_Camera_Access_Confirmed" )
	RegisterSignal( "Crypto_StopSendPointThink" )
	file.droneHealth = GetCurrentPlaylistVarInt( "crypto_drone_health", CRYPTO_DRONE_HEALTH_PROJECTILE )
}


bool function OnWeaponAttemptOffhandSwitch_ability_crypto_drone( entity weapon )
{
	printt( "OnWeaponAttemptOffhandSwitch", weapon )
	
	//int ammoReq = weapon.GetAmmoPerShot()
	//int currAmmo = weapon.GetWeaponPrimaryClipCount()
	//if ( currAmmo < ammoReq )
	//	return false

	entity player = weapon.GetWeaponOwner()
	if( !IsValid( player ) )
		return false

	if ( IsPlayerInCryptoDroneCameraView( player ) )
		return false

	if ( StatusEffect_GetSeverity( player, eStatusEffect.script_helper ) > 0.0 )
		return false

	if ( StatusEffect_GetSeverity( player, eStatusEffect.crypto_camera_is_recalling ) > 0.0 )
		return false

	if ( !PlayerCanUseCamera( player, false ) )
		return false

	//Holospray_DisableForTime( player, 2.0 )
	return true
}



var function OnWeaponToss_ability_crypto_drone( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	printt( "OnWeaponToss", weapon )

	entity player = weapon.GetWeaponOwner()

	Signal( player, "Crypto_Immediate_Camera_Access_Confirmed" )

	if ( IsValid( CryptoDrone_GetPlayerDrone( player ) ) && !weapon.HasMod( "crypto_has_camera" ) )
		weapon.AddMod( "crypto_has_camera" )

	if ( !(StatusEffect_GetSeverity( player, eStatusEffect.crypto_has_camera ) > 0.0) )
	{
			entity camera = CryptoDrone_ReleaseCamera( weapon, attackParams, DEPLOYABLE_CAMERA_THROW_POWER )
			Signal( player, "Crypto_StopSendPointThink" )
			printt( "should throw deployable" )
		#if SERVER
																									  
		#endif          

		return -1
	}
	else
	{
		if ( weapon.HasMod( "crypto_drone_access" ) )
		{
			#if SERVER
			// GetPlayerInCamera( player ) 
			#endif
			return -1
		}
		else
		{
		//#if CLIENT
		//	ServerCallback_SurvivalHint( eSurvivalHints.CRYPTO_DRONE_ACCESS )
		//#endif
			return 0
		}
	}

	return -1
}
entity function CryptoDrone_ReleaseCamera( entity weapon, WeaponPrimaryAttackParams attackParams, float throwPower, vector ornull angularVelocity = null )
{
	#if CLIENT
		if ( !weapon.ShouldPredictProjectiles() )
			return null
	#endif          

	entity player = weapon.GetWeaponOwner()
	vector angles   = VectorToAngles( attackParams.dir )
	entity deployable = ThrowDeployable( weapon, attackParams, throwPower, CryptoDrone_CameraImpact, <0,0,0> )

	if ( deployable )
	{
		deployable.SetAngles( <0, angles.y - 180, 0> )
		deployable.kv.collisionGroup = TRACE_COLLISION_GROUP_PLAYER

		#if SERVER
			entity drone = CreateCryptoVehicle( weapon, player )
			drone.SetParent( deployable )
			deployable.Hide()

			thread function() : ( drone, attackParams, deployable )
			{
				OnThreadEnd(
					function() : ( drone )
					{
						if( !IsValid( drone ) )
							return
						
						if( IsValid( drone.GetParent() ) )
						{
							drone.ClearParent()
						}
						
						drone.SetAngles( <0, drone.GetAngles().y, 0> )
					}
				)

				deployable.EndSignal( "OnDestroy" )
				deployable.EndSignal( "OnDeath" )
				deployable.EndSignal( "Planted" )
				
				while( IsValid( drone ) && IsValid( deployable ) && !deployable.proj.isPlanted && Distance( attackParams.pos, deployable.GetOrigin() ) <= CRYPTO_DRONE_STICK_RANGE )
					WaitFrame()
				
				deployable.proj.isPlanted = true
				deployable.Signal( "Planted" )
			}()
		#endif          
	}

	return deployable
}

void function CryptoDrone_CameraImpact( entity projectile )
{
	printt( "CryptoDrone_CameraImpact", projectile )

	thread CryptoDrone_CameraImpact_Thread( projectile )
}

void function CryptoDrone_CameraImpact_Thread( entity projectile )
{
	printt( "CryptoDrone_CameraImpact_Thread", projectile )

	Assert( IsNewThread(), "Must be threaded off" )

	if ( !IsValid( projectile ) )
		return

	projectile.EndSignal( "OnDestroy" )
	projectile.EndSignal( "OnDeath" )

	projectile.SetVelocity( <0, 0, 0> )

	#if SERVER
	// bounce thing should go but idk how it works
	projectile.SetAngles( <0, projectile.GetAngles().y, 0> )
	projectile.StopPhysics()
	#endif         

}
var function OnWeaponTossReleaseAnimEvent_ability_crypto_drone( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	printt( "OnWeaponTossReleaseAnimEvent", weapon )
	
	entity player = weapon.GetWeaponOwner()

	#if SERVER
	// No clue
	#endif

	PlayerUsedOffhand( player, weapon )

	if ( StatusEffect_GetSeverity( player, eStatusEffect.crypto_has_camera ) > 0.0 && StatusEffect_GetSeverity( player, eStatusEffect.camera_view ) == 0.0 )
	{
		#if SERVER
	if ( weapon.HasMod( "crypto_drone_access" ) )
		{
		#if SERVER
		GetPlayerInCamera( player )
		#endif
		}
		#endif
		return 0
	}
	
		// if ( IsValid( CryptoDrone_GetPlayerDrone( owner ) ) && !weapon.HasMod( "crypto_has_camera" ) )
		// weapon.SetMods( ["crypto_has_camera"])

	// int ammoReq = weapon.GetAmmoPerShot()
	if ( !weapon.HasMod( "crypto_has_camera" ) )
	{
		weapon.EmitWeaponSound_1p3p( "null_remove_soundhook", "null_remove_soundhook" )
		#if SERVER
		// CreateCryptoVehicle( weapon, player )
		#endif
	}
	// else
	// {
		// // if ( weapon.HasMod( "crypto_drone_access" ) )
		// // {
		// #if SERVER
		// GetPlayerInCamera( player )
		// #endif
		// // }
	// }

	#if SERVER
	foreach( mod in weapon.GetMods() )
		printt( "debug weapon mods: ", mod )
	#endif

	//return 0 //ammoReq
}

void function OnWeaponTossPrep_ability_crypto_drone( entity weapon, WeaponTossPrepParams prepParams )
{
	printt( "OnWeaponTossPrep", weapon )
	
	#if CLIENT
	if ( InPrediction() )
	#endif          
		weapon.AddMod( "crypto_drone_access" )

	#if SERVER
	entity owner = weapon.GetOwner()
	if( !IsValid( owner ) )
		return

	#endif
	
	entity player = weapon.GetOwner()
	if ( !(StatusEffect_GetSeverity( player, eStatusEffect.crypto_has_camera ) > 0.0 ) && !(StatusEffect_GetSeverity( player, eStatusEffect.camera_view ) > 0.0 ) )
		thread CryptoDrone_WeaponInputThink( weapon.GetWeaponOwner(), weapon )

	if ( weapon.HasMod( "crypto_has_camera" ) )
	{
		weapon.EmitWeaponSound_1p3p( "Char_11_Tactical_Secondary_Deploy", "" )
		#if SERVER
		PlayBattleChatterLineToSpeakerAndTeam( weapon.GetOwner(), "bc_droneViewStart" )
		#endif
	}
	else
	{
		weapon.EmitWeaponSound_1p3p( "Char_11_Tactical_Deploy", "Char_11_Tactical_Deploy_3p" )
		#if SERVER
		PlayBattleChatterLineToSpeakerAndTeam( weapon.GetOwner(), "bc_tactical" )
		#endif
	}
}

void function OnWeaponRegenEnd_ability_crypto_drone( entity weapon )
{
	printt( "OnWeaponRegenEnd", weapon )
}

#if CLIENT
void function OnClientAnimEvent_ability_crypto_drone( entity weapon, string name )
{
	if ( name != "screen_transition" )
		return

	entity localViewPlayer = GetLocalViewPlayer()
	if ( !IsValid( localViewPlayer ) )
		return

	entity weaponOwner = weapon.GetWeaponOwner()
	if ( weaponOwner != localViewPlayer )
		return

	Crypto_TryPlayScreenTransition( weaponOwner, weapon, weapon.HasMod( "crypto_has_camera" ) )
}

void function Crypto_TryPlayScreenTransition( entity player, entity weapon, bool playFastTransition )
{
	if ( weapon.HasMod( "crypto_drone_access" ) )
		thread PlayScreenTransition( player, weapon, playFastTransition )
}
      

void function PlayScreenTransition( entity player, entity weapon, bool playFastTransition )
{
	if ( !IsValid( player ) || !IsValid( weapon ) )
		return

	entity drone = CryptoDrone_GetPlayerDrone( player )

	if ( !IsValid( drone ) )
		return

	EndSignal( player, "OnDeath", "OnDestroy" )
	EndSignal( weapon, "OnDeath", "OnDestroy" )
	EndSignal( drone, "OnDeath", "OnDestroy" )

	entity cockpit = player.GetCockpit()
	if ( !IsValid( cockpit ) )
		return

	int systemIndex = playFastTransition ? GetParticleSystemIndex( SCREEN_FAST_FX ) : GetParticleSystemIndex( SCREEN_FX )
	int fxID1 = StartParticleEffectOnEntity( player, systemIndex, FX_PATTACH_POINT_FOLLOW, cockpit.LookupAttachment( "CAMERA" ) )
	EffectSetIsWithCockpit( fxID1, true )

	var transitionRui
	if ( playFastTransition )
	{
		transitionRui = CreateFullscreenRui( $"ui/camera_transition_fast.rpak" )
	}
	else
	{
		transitionRui = CreateFullscreenRui( $"ui/camera_transition.rpak" )
		if ( IsValid( file.cryptoAnimatedTacticalRui ) )
		{
			RuiSetFloat( file.cryptoAnimatedTacticalRui, "loopStartTime", Time() )
			RuiSetFloat( file.cryptoAnimatedTacticalRui, "transitionEndTime", Time() + 0.66 )
			RuiSetBool( file.cryptoAnimatedTacticalRui, "inTransition", true )
			entity offhandWeapon = player.GetOffhandWeapon( OFFHAND_LEFT )
			if ( IsValid( offhandWeapon ) )
				RuiTrackFloat( file.cryptoAnimatedTacticalRui, "clipAmmoFrac", offhandWeapon, RUI_TRACK_WEAPON_CLIP_AMMO_FRACTION )
		}
	}

	OnThreadEnd(
		function() : ( player, fxID1, transitionRui )
		{
			if ( IsValid( player ) && IsAlive( player ) )
			{
				if ( EffectDoesExist( fxID1 ) )
					EffectStop( fxID1, false, true )
			}
			RuiDestroyIfAlive( transitionRui )
			if ( IsValid( file.cameraRui ) )
				RuiSetBool( file.cameraRui, "inTransition", false )
			if ( IsValid( file.cameraCircleStatusRui ) )
			{
				RuiSetBool( file.cameraCircleStatusRui, "isVisible", true )
			}

			if ( IsValid( file.cryptoAnimatedTacticalRui ) )
			{
				RuiSetBool( file.cryptoAnimatedTacticalRui, "inTransition", false )
			}
		}
	)

	float endTime = playFastTransition ? 1.4 + Time() : 1.75 + Time()
	while( Time() < endTime )
	{
		if ( IsValid( file.cameraRui ) )
			RuiSetBool( file.cameraRui, "inTransition", true )
		if ( IsValid( file.cameraCircleStatusRui ) )
			RuiSetBool( file.cameraCircleStatusRui, "isVisible", false )
		WaitFrame()
	}
}
#endif

#if CLIENT
void function AttemptDroneRecall( entity player )
{
	if ( player != GetLocalViewPlayer() || player != GetLocalClientPlayer() )
		return

	if ( IsControllerModeActive() )
	{
		if ( TryPingBlockingFunction( player, "quickchat" ) )
			return
	}

	player.ClientCommand( "AttemptDroneRecall" )
}
#endif

void function OnPlayerTookDamage( entity damagedEnt, var damageInfo )
{
	int damageSourceId = DamageInfo_GetDamageSourceIdentifier( damageInfo )
	if ( damageSourceId == eDamageSourceId.deathField )
		return

	int playerTeam = damagedEnt.GetTeam()
	entity attacker = DamageInfo_GetAttacker( damageInfo )
	if ( IsValid( attacker ) && attacker.GetTeam() == playerTeam )
		return

	entity inflictor = DamageInfo_GetInflictor( damageInfo )
	if ( IsValid( inflictor ) && inflictor.GetTeam() == playerTeam )
		return

	damagedEnt.Signal( "ExitCameraView" )
}

#if SERVER
entity function CreateCryptoVehicle( entity weapon, entity player )
{
	entity vehicle = CreateEntity( "player_vehicle" )
	vehicle.SetScriptName( CRYPTO_DRONE_SCRIPTNAME )
	vehicle.SetOwner( player )
	vehicle.SetOrigin( player.EyePosition() )
	vehicle.VehicleSetType( VEHICLE_FLYING_CAMERA )
	vehicle.SetModel( CAMERA_MODEL )
	SetTeam( vehicle, player.GetTeam() )
	vehicle.kv.CollisionGroup = TRACE_COLLISION_GROUP_BLOCK_WEAPONS_AND_PHYSICS

	vehicle.SetHealth( CRYPTO_DRONE_HEALTH )
	vehicle.SetMaxHealth( CRYPTO_DRONE_HEALTH )
	vehicle.SetTakeDamageType( DAMAGE_YES )
	vehicle.SetDamageNotifications( true )

	DispatchSpawn( vehicle )

	vehicle.e.attachedEnts.append( CreateScanTrigger( vehicle ) )

	vehicle.Anim_Play( "drone_active_twitch" )

	thread DroneCheck_Thread( vehicle )
	
	// weapon.AddMod( "crypto_has_camera")

	StatusEffect_AddEndless( player, eStatusEffect.crypto_has_camera, 1.0 )
	EmitSoundOnEntity( vehicle, DRONE_PROPULSION_3P )

	AddEntityCallback_OnKilled( vehicle, OnDroneKilled )
	AddEntityCallback_OnDamaged( vehicle, OnDroneDamaged) 
	
	file.allDrones.append( vehicle )

	Highlight_SetFriendlyHighlight( player, "crypto_camera_friendly" )
	return vehicle
}
#endif

bool function CryptoDrone_WeaponInputCheck( entity player, entity weapon )
{
	if ( !IsValid( player ) || !IsValid( weapon ) )
		return false

	return player.IsInputCommandHeld( IN_OFFHAND1 )
}

void function CryptoDrone_WeaponInputThink( entity player, entity weapon )
{
	EndSignal( player, "Crypto_Immediate_Camera_Access_Confirmed" )

	if ( !IsValid( player ) || !IsValid( weapon ) )
		return

	EndSignal( player, "OnDestroy" )
	EndSignal( weapon, "OnDestroy" )

	while ( player.IsInputCommandHeld( IN_OFFHAND1 ) && weapon.HasMod( "crypto_drone_access" ) )
		WaitFrame()

	if ( weapon.HasMod( "crypto_drone_access" ) )
	{
		#if CLIENT
			if ( InPrediction() )
		#endif          
		weapon.RemoveMod( "crypto_drone_access" )
	}
}

#if SERVER
bool function Flowstate_ClientCommand_AttemptDroneRecall(entity player, array < string > args)
{
	if( !IsValid( player ) || !player.IsPlayer() )
		return false

	entity vehicle = CryptoDrone_GetPlayerDrone( player )
	
	if( !IsValid( vehicle ) || vehicle.e.droneRecalling )
		return false
	
	entity owner = vehicle.GetOwner()

	if( !IsValid(owner) || !IsAlive( player ) || owner != player )
		return false

	vehicle.SetTakeDamageType( DAMAGE_NO )
	vehicle.NotSolid()

	thread function () : ( owner, vehicle )
	{
		int team = vehicle.GetTeam()
		vehicle.e.droneRecalling = true

		if( owner.ContextAction_IsInVehicle() ) //this is bad please fix
		{
			EmitSoundOnEntityOnlyToPlayer( vehicle, owner, "Char_11_TacticalA_A" )
			EmitSoundOnEntityOnlyToPlayer( owner, owner, "Char_11_TacticalA_A" )
		}
		else
			EmitSoundOnEntityOnlyToPlayer( owner, owner, "Char_11_TacticalA_A" )
			
		PlayBattleChatterLineToSpeakerAndTeam( owner, "bc_droneRecall" )
		StatusEffect_AddTimed( owner, eStatusEffect.crypto_camera_is_recalling, 1.0, vehicle.GetSequenceDuration( "drone_recall" ), vehicle.GetSequenceDuration( "drone_recall" ) )
		vehicle.Anim_Play( "drone_recall" )
		
		EndSignal( vehicle, "OnDeath" )
		EndSignal( vehicle, "OnDestroy" )

		wait vehicle.GetSequenceDuration( "drone_recall" )

		if( !IsValid( vehicle ) )
			return

		entity firstFx = StartParticleEffectOnEntity_ReturnEntity( vehicle, GetParticleSystemIndex( DRONE_RECALL_START_FX_3P ), FX_PATTACH_ABSORIGIN_FOLLOW, -1 )

		DecrementSonarPerTeamGrenade( team )

		foreach( entity e in vehicle.e.attachedEnts )
			if( IsValid( e ) )
				e.Destroy()

		StatusEffect_StopAllOfType( owner, eStatusEffect.crypto_has_camera )

		StartParticleEffectInWorld( GetParticleSystemIndex( DRONE_RECALL_END_FX_3P ), vehicle.GetOrigin(), <0,0,0> )

		GetPlayerOutOfCamera( owner )

		entity ability = GetDroneWeapon( owner )

		if( !IsValid(ability) )
			return true

		ability.SetMods( [] )
		ability.SetWeaponPrimaryClipCount( ability.GetWeaponPrimaryClipCountMax() )

		if( file.allDrones.contains( vehicle ) )
			file.allDrones.fastremovebyvalue( vehicle )

		vehicle.Destroy()
	}()
	
	return true
}

entity function GetDroneWeapon( entity owner )
{
	foreach(entity w in GetAllPlayerWeapons(owner))
	{
		if(w.GetWeaponClassName() == "mp_ability_crypto_drone")
			return w
	}
    return null
}

entity function GetEMPWeapon( entity owner )
{
	foreach(entity w in GetAllPlayerWeapons(owner))
	{
		if(w.GetWeaponClassName() == "mp_ability_crypto_drone_emp")
			return w
	}
    return null
}

void function FireUltimate( entity player )
{
	entity emp = GetEMPWeapon( player )
	if ( !IsValid( emp ) )
		return

	entity camera = CryptoDrone_GetPlayerDrone( player )
	if ( !IsValid( camera ) )
		return

	if(emp.GetAmmoPerShot() != emp.GetWeaponPrimaryClipCount())
		return

	DroneFireEMP( emp )

	emp.SetWeaponPrimaryClipCount(0)
}

void function GetPlayerOutOfCameraManual( entity player )
{
	if( !IsValid( player ) || !IsAlive( player ) || player.p.lastTimeEnteredCryptosDrone + 0.1 > Time() )
		return

	entity weapon = player.GetOffhandWeapon( OFFHAND_LEFT )
	weapon.SetWeaponPrimaryClipCount(weapon.GetAmmoPerShot()-10)

	PlayBattleChatterLineToSpeakerAndTeam( player, "bc_droneViewEnd" )
	GetPlayerOutOfCamera( player )
}

void function GetPlayerOutOfCamera( entity player )
{
	entity vehicle = CryptoDrone_GetPlayerDrone( player )

	if( !IsValid( vehicle ) || !IsValid( player ) || !IsAlive( player ) || !player.ContextAction_IsInVehicle() )
		return

	printt( "player get out of camera", player )

	// Supposed to use EndSignal "ExitCameraView" ?

	vehicle.kv.VisibilityFlags = ENTITY_VISIBLE_TO_EVERYONE

	RemoveButtonPressedPlayerInputCallback( player, IN_OFFHAND1, GetPlayerOutOfCameraManual )
	RemoveButtonPressedPlayerInputCallback( player, IN_OFFHAND4, FireUltimate )
	RemoveButtonPressedPlayerInputCallback( player, IN_ATTACK, FireUltimate )

	// If player was in vehicle
	try{ vehicle.VehicleRemoveDriver() } 
	catch( error ){ return	}

	player.ContextAction_ClearInVehicle()
	player.p.lastTimeEnteredCryptosDrone = -1

	// Temp Effects
	StatusEffect_AddTimed( player, eStatusEffect.hunt_mode_visuals, 1.0, 0.1, 0.1)
	StatusEffect_AddTimed( player, eStatusEffect.timeshift_visual_effect, 1.0, 1.0, 1.0)
	// - - -

	RemoveCinematicFlag( player, CE_FLAG_TITAN_3P_CAM )
	StatusEffect_StopAllOfType( player, eStatusEffect.camera_view )

	EmitSoundOnEntityOnlyToPlayer( player, player, TRANSITION_OUT_CAMERA_1P )
	EmitSoundOnEntityExceptToPlayer( player, player, TRANSITION_OUT_CAMERA_3P )
}

void function GetPlayerInCamera( entity player )
{
	entity vehicle = CryptoDrone_GetPlayerDrone( player )

	if( !IsValid( vehicle ) || !IsValid( player ) || !IsAlive( player ) || vehicle.e.droneRecalling)
		return

	// printt( vehicle, player )
	// printt( "get player in camera", player )

	int enemyTeams = 0
	array<int> checkedTeams

	foreach( sPlayer in GetPlayerArray_Alive() )
	{
		if( sPlayer.GetTeam() == player.GetTeam() )
			continue
		
		if( checkedTeams.contains( sPlayer.GetTeam() ) )
			continue

		if( Distance( sPlayer.GetOrigin(), player.GetOrigin() ) < 10500 ) //200m
		{
			enemyTeams++
			checkedTeams.append( sPlayer.GetTeam() )
		}
	}
	
	player.SetPlayerNetInt( "cameraNearbyEnemySquads", enemyTeams )
	
	entity parentEnt = vehicle.GetParent()
	if( IsValid( parentEnt ) )
	{
		vehicle.ClearParent()
		parentEnt.Destroy()
	}

	vehicle.VehicleSetDriver( player )
	player.p.lastTimeEnteredCryptosDrone = Time()
	player.ContextAction_SetInVehicle()

	vehicle.kv.VisibilityFlags = ENTITY_VISIBLE_TO_EVERYONE ^ ENTITY_VISIBLE_TO_OWNER

	AddCinematicFlag( player, CE_FLAG_TITAN_3P_CAM )
	StatusEffect_AddEndless( player, eStatusEffect.camera_view, 1.0 )

	AddButtonPressedPlayerInputCallback( player, IN_OFFHAND1, GetPlayerOutOfCameraManual )
	AddButtonPressedPlayerInputCallback( player, IN_OFFHAND4, FireUltimate )
	AddButtonPressedPlayerInputCallback( player, IN_ATTACK, FireUltimate )
}

void function DroneCheck_Thread( entity vehicle )
{
	while( true )
	{
		wait 1

		if(!IsValid( vehicle ))
			return

		entity owner = vehicle.GetOwner()
		
		if( !IsValid( owner ) || !IsAlive( owner ) )
			break
	}

	entity worldSpawn = GetEnt( "worldspawn" )

	vehicle.TakeDamage( CRYPTO_DRONE_HEALTH, worldSpawn, worldSpawn, {} )
}

void function OnDroneKilled( entity vehicle, var damageInfo )
{
	entity owner = vehicle.GetOwner()

	DecrementSonarPerTeamGrenade( vehicle.GetTeam() )

	foreach( entity e in vehicle.e.attachedEnts )
		if( IsValid( e ) )
			e.Destroy()

	if(!IsValid(owner))
		return

	StatusEffect_StopAllOfType( owner, eStatusEffect.crypto_has_camera )

	if( owner.GetHealth() > 0 )
		PlayBattleChatterLineToSpeakerAndTeam( owner, "bc_droneDestroyed" )

	EmitSoundAtPosition( TEAM_ANY, vehicle.GetOrigin(), DRONE_EXPLOSION_3P )
	StartParticleEffectInWorld( GetParticleSystemIndex( CAMERA_EXPLOSION_FX ), vehicle.GetOrigin(), <0,0,0> )

	GetPlayerOutOfCamera( owner )

	entity ability = GetDroneWeapon( owner )

	if( !IsValid(ability) )
		return

	ability.SetMods( [] )
	ability.SetWeaponPrimaryClipCount( 0 )

	if( file.allDrones.contains( vehicle ) )
		file.allDrones.fastremovebyvalue( vehicle )
}

void function OnDroneDamaged(entity drone, var damageInfo)
{
	entity attacker = DamageInfo_GetAttacker(damageInfo);
	
	if( !IsValid( attacker ) || !attacker.IsPlayer() )
		return
	
	attacker.NotifyDidDamage
	(
		drone,
		DamageInfo_GetHitBox( damageInfo ),
		DamageInfo_GetDamagePosition( damageInfo ), 
		DamageInfo_GetCustomDamageType( damageInfo ),
		DamageInfo_GetDamage( damageInfo ),
		DamageInfo_GetDamageFlags( damageInfo ), 
		DamageInfo_GetHitGroup( damageInfo ),
		DamageInfo_GetWeapon( damageInfo ), 
		DamageInfo_GetDistFromAttackOrigin( damageInfo )
	)
}

entity function CreateScanTrigger( entity drone )
{
	entity trigger = CreateEntity( "trigger_cylinder" )
	trigger.SetRadius( CAMERA_SCAN_RANGE )
	trigger.SetAboveHeight( CAMERA_SCAN_RANGE/2 ) //Still not quite a sphere, will see if close enough
	trigger.SetBelowHeight( CAMERA_SCAN_RANGE/2 )
	SetTeam( trigger, drone.GetTeam() )
	trigger.SetOwner( drone.GetOwner() )
	trigger.RemoveFromAllRealms()
	trigger.AddToOtherEntitysRealms( drone )
	trigger.SetOrigin( drone.GetOrigin() )

	DispatchSpawn( trigger )

	trigger.SetParent( drone )
	trigger.SearchForNewTouchingEntity()
	
	thread Flowstate_StartCryptoScanFromTrigger_Thread( trigger )
	return trigger
}

void function Flowstate_StartCryptoScanFromTrigger_Thread( entity trigger )
{
	array<entity> touchingEnts = []
	array<entity> targetEnts = []
	array<entity> targetEnts_Old = []
	array<entity> ignoreEnts = []
	int team = trigger.GetTeam()
	
	float maxDist = CAMERA_SCAN_RANGE
	int traceMask = TRACE_MASK_PLAYERSOLID | TRACE_MASK_SHOT
	entity antilagPlayer = null
	
	while( true )
	{
		WaitFrame()	
		
		if( !IsValid( trigger ) )
			break

		entity owner = trigger.GetOwner()
			
		if( !IsValid( owner ) || !IsAlive( owner ) )
			break
		
		entity vehicle = trigger.GetParent()
		
		if( !IsValid( vehicle ) )
			break

		//cleanup ents highlight
		//remove highlights for entities that are too far now and had highlight before
		foreach( oldTouchedEnt in touchingEnts )
		{
			if( !IsValid( oldTouchedEnt ) || !IsHostileSonarTarget( owner, oldTouchedEnt ) || !IsEnemyTeam( team, oldTouchedEnt.GetTeam() ) || !oldTouchedEnt.e.sonarTriggers.contains( trigger ) )
				continue

			if( !( trigger.GetTouchingEntities().contains( oldTouchedEnt ) ) )
			{
				if( oldTouchedEnt.e.sonarTriggers.contains(trigger) )
					oldTouchedEnt.e.sonarTriggers.fastremovebyvalue( trigger )
				else
					continue
				
				// printt( "destroying highlight in thread for ent ", oldTouchedEnt)
				SonarEnd( oldTouchedEnt, team, true )
				DecrementSonarPerTeam( team )
			}
		}
		
		//remove highlights for entities that aren't visibles
		foreach( failedTracedEnt in ignoreEnts )
		{
			if( !IsValid( failedTracedEnt ) || !failedTracedEnt.e.sonarTriggers.contains( trigger ) )
				continue

			if( failedTracedEnt.e.sonarTriggers.contains(trigger) )
				failedTracedEnt.e.sonarTriggers.fastremovebyvalue( trigger )
			else
				continue
				
			// printt( "destroying highlight in thread for ent ", failedTracedEnt )
			SonarEnd( failedTracedEnt, team, true )
			DecrementSonarPerTeam( team )
		}
		
		//start new check
		touchingEnts = trigger.GetTouchingEntities()
		targetEnts.clear()
		ignoreEnts.clear()

		
		//Do traces to see if enemy inside trigger is visible
		foreach ( entity touchingEnt in touchingEnts )
		{
			if ( !IsValid( touchingEnt ) || !IsEnemyTeam( trigger.GetTeam(), touchingEnt.GetTeam() ) || !IsHostileSonarTarget( owner, touchingEnt ) )
				continue

			vector traceStart = vehicle.GetOrigin()
			vector traceEnd = traceStart + ( Normalize( touchingEnt.GetWorldSpaceCenter() - vehicle.GetOrigin() ) * 56756 ) // longest possible trace given our map size limits

			TraceResults traceResult = TraceLine( traceStart, traceEnd, [ vehicle ], traceMask, TRACE_COLLISION_GROUP_NONE )
			
			#if DEVELOPER
			DebugDrawLine( traceStart, traceResult.endPos, 0, 255, 0, true, 0.1 )
			DebugDrawLine( traceResult.endPos, traceEnd, 255, 0, 0, true, 0.1 )
			#endif

			if ( IsValid( traceResult.hitEnt ) && touchingEnt == traceResult.hitEnt )
				targetEnts.append( touchingEnt )
			else
				ignoreEnts.append( touchingEnt ) 
		}
	
		if( targetEnts.len() > 0 )
		{
			targetEnts_Old.clear()
			targetEnts_Old = clone targetEnts
		}else
		{
			trigger.e.sonarConeDetections = 0 //resets first target adquired sound
		}
		
		//Add highlight for valid visibles and touching targets
		foreach ( entity ent in targetEnts )
		{
			if ( !IsValid( ent ) || ent.e.sonarTriggers.contains( trigger ))
				continue

			if ( trigger.e.sonarConeDetections == 0 )
				EmitSoundOnEntityOnlyToPlayer( owner, owner, "SonarScan_AcquireTarget_1p" )

			trigger.e.sonarConeDetections++
			ent.e.sonarTriggers.append( trigger )
			
			// printt( "added highlight in thread for ent ", ent)

			IncrementSonarPerTeam( team )
			SonarStart( ent, ent.GetOrigin(), team, owner )
			
			// remote call the sonar target if it's a player
			if ( ent.IsPlayer() )
				Remote_CallFunction_Replay( ent, "ServerCallback_SonarAreaScanTarget", ent, owner )
		}
	}
	
	//when trigger stops being valid, destroy highlight for the entities that were highlighted at that time
	foreach( oldTouchedEnt in targetEnts_Old )
	{
		if( !IsValid( oldTouchedEnt ) || !IsEnemyTeam( team, oldTouchedEnt.GetTeam() ))
			continue

		foreach( triggers in oldTouchedEnt.e.sonarTriggers )
		{
			if( !IsValid( triggers ) )
				oldTouchedEnt.e.sonarTriggers.fastremovebyvalue( triggers )
		}
		// printt( "destroying highlight thread end")
		SonarEnd( oldTouchedEnt, team )
		DecrementSonarPerTeam( team )
	}
}
#endif

#if CLIENT
void function Camera_OnCreate( entity player, int statusEffect, bool actuallyChanged )
{
	if ( player != GetLocalViewPlayer() )
		return

	thread TempUpdateRuiDistance( player )
}

void function Camera_OnDestroy( entity player, int statusEffect, bool actuallyChanged )
{
	if ( player != GetLocalViewPlayer() )
		return

	player.Signal( "StopUpdatingCameraRui")

	if ( IsValid( file.cryptoAnimatedTacticalRui ) )
	{
		RuiSetFloat( file.cryptoAnimatedTacticalRui, "loopStartTime", Time() )
		RuiSetFloat( file.cryptoAnimatedTacticalRui, "recallTransitionEndTime", Time() + 0.66 )
		RuiSetFloat( file.cryptoAnimatedTacticalRui, "distanceToCrypto", 0 )
	}
}

void function Camera_OnBeginView( entity player, int statusEffect, bool actuallyChanged )
{
	thread Camera_OnBeginView_Think( player, statusEffect, actuallyChanged )
}

void function Camera_OnBeginView_Think( entity player, int statusEffect, bool actuallyChanged )
{
	if ( player != GetLocalViewPlayer() )
		return

	foreach ( void functionref() cb in file.onEnterDroneViewCallbacks )
		cb()

	entity activeCamera
	while ( !IsValid( activeCamera ) )
	{
		array<entity> cameras = GetEntArrayByScriptName( CRYPTO_DRONE_SCRIPTNAME )
		foreach ( camera in cameras )
		{
			if ( camera.GetOwner() == player )
			{
				activeCamera = camera
				break
			}
		}
		WaitFrame()
	}

	Signal( activeCamera, "CameraViewStart" )
	file.cameraRui = CreateFullscreenRui( $"ui/camera_view.rpak" )
	RuiTrackFloat( file.cameraRui, "empFrac", player, RUI_TRACK_STATUS_EFFECT_SEVERITY, eStatusEffect.crypto_camera_is_emp )
	RuiTrackFloat( file.cameraRui, "recallFrac", player, RUI_TRACK_STATUS_EFFECT_SEVERITY, eStatusEffect.crypto_camera_is_recalling )
	RuiTrackFloat( file.cameraRui, "playerHealthFrac", player, RUI_TRACK_HEALTH )
	RuiTrackFloat( file.cameraRui, "playerShieldFrac", player, RUI_TRACK_SHIELD_FRACTION )
	RuiTrackFloat3( file.cameraRui, "playerAngles", player, RUI_TRACK_CAMANGLES_FOLLOW )
	RuiTrackFloat3( file.cameraRui, "playerOrigin", player, RUI_TRACK_ABSORIGIN_FOLLOW )
	RuiSetFloat( file.cameraRui, "shieldSegments", float( player.GetShieldHealthMax() / 25 ) )
	RuiSetBool( file.cameraRui, "isVisible", !Fullmap_IsVisible() )
	ChangeHUDVisibilityWhenInCryptoDrone( true )
	Minimap_SetSizeScale( 0.7 )

	entity offhandWeapon = player.GetOffhandWeapon( OFFHAND_ULTIMATE )
	if ( IsValid( offhandWeapon ) )
	{
		RuiTrackFloat( file.cameraRui, "clipAmmoFrac", offhandWeapon, RUI_TRACK_WEAPON_CLIP_AMMO_FRACTION )
		RuiSetFloat( file.cameraRui, "refillRate", offhandWeapon.GetWeaponSettingFloat( eWeaponVar.regen_ammo_refill_rate ) )
	}
	if ( IsControllerModeActive() )
		RuiSetString( file.cameraRui, "ultimateHint", "#WPN_CAMERA_EMP_CONTROLLER" )
	else
		RuiSetString( file.cameraRui, "ultimateHint", "#WPN_CAMERA_EMP" )

	thread CameraView_CreateHUDMarker( player )
}

void function UpdateCameraVisibility()
{
	if ( file.cameraRui != null )
	{
		RuiSetBool( file.cameraRui, "isVisible", !Fullmap_IsVisible() )
	}
	if ( file.cameraCircleStatusRui != null )
	{
		bool isVisible = !Fullmap_IsVisible() && file.cameraRui != null
		RuiSetBool( file.cameraCircleStatusRui, "isVisible", isVisible )
	}
}

void function AddCallback_OnLeaveDroneView( void functionref() cb )
{
	Assert( !file.onLeaveDroneViewCallbacks.contains( cb ) )
	file.onLeaveDroneViewCallbacks.append( cb )
}

void function RemoveCallback_OnLeaveDroneView( void functionref() cb )
{
	Assert( file.onLeaveDroneViewCallbacks.contains( cb ) )
	file.onLeaveDroneViewCallbacks.removebyvalue( cb )
}

void function Camera_OnEndView( entity player, int statusEffect, bool actuallyChanged )
{
	if ( player != GetLocalViewPlayer() )
		return

	player.Signal( "CameraViewEnd" )

	foreach ( void functionref() cb in file.onLeaveDroneViewCallbacks )
		cb()
	if ( IsValid( file.cameraCircleStatusRui ) )
		RuiSetBool( file.cameraCircleStatusRui, "isVisible", false )

		Minimap_SetSizeScale( 1.0 )
		entity drone = CryptoDrone_GetPlayerDrone( player )
		if ( IsValid( drone ) )
			thread CryptoDrone_CreateHUDMarker( drone )
	if ( file.cameraRui != null )
	{
		RuiDestroyIfAlive( file.cameraRui )
		file.cameraRui = null
		if ( file.cryptoAnimatedTacticalRui != null )
			ChangeHUDVisibilityWhenInCryptoDrone(false)
	}
}

void function AddCallback_OnRecallDrone( void functionref() cb )
{
	Assert( !file.onRecallDroneCallbacks.contains( cb ) )
	file.onRecallDroneCallbacks.append( cb )
}

void function RemoveCallback_OnRecallDrone( void functionref() cb )
{
	Assert( file.onRecallDroneCallbacks.contains( cb ) )
	file.onRecallDroneCallbacks.removebyvalue( cb )
}

void function Camera_OnBeginRecall( entity player, int statusEffect, bool actuallyChanged )
{
	foreach ( void functionref() cb in file.onRecallDroneCallbacks )
		cb()
}

void function Camera_OnEndRecall( entity player, int statusEffect, bool actuallyChanged )
{
}

void function TempUpdateRuiDistance( entity player )
{
	EndSignal( player,  "OnDestroy", "StopUpdatingCameraRui" )

	entity activeCamera
	while( !IsValid( activeCamera ) )
	{
		array<entity> cameras = GetEntArrayByScriptName( "crypto_camera" )
		foreach( camera in cameras )
		{
			if ( camera.GetOwner() == player )
			{
				activeCamera = camera
				break
			}
		}
		WaitFrame()
	}

	activeCamera.EndSignal( "OnDestroy")
	OnThreadEnd(
	function() : ( activeCamera )
		{
			if ( EffectDoesExist( activeCamera.e.cameraMaxRangeFXHandle ) )
				EffectStop( activeCamera.e.cameraMaxRangeFXHandle, true, false )
		}
	)
	bool outOfRange = false
	bool inWarningRange = false
	bool useInputWasDownLast = player.IsUserCommandButtonHeld( IN_USE )
	while( true )
	{
		bool useInputIsDown = player.IsUserCommandButtonHeld( IN_USE )
		bool useInputPressed = (useInputIsDown && !useInputWasDownLast)
		useInputWasDownLast = useInputIsDown

		bool flightModeInputIsHeld = player.IsUserCommandButtonHeld( IN_ZOOM | IN_ZOOM_TOGGLE )

		float distanceToCrypto = Distance( player.GetOrigin(), activeCamera.GetOrigin() )
		inWarningRange = distanceToCrypto > WARNING_RANGE || activeCamera.GetOrigin().z > file.droneMaxZ - 400.0
		if ( activeCamera.e.cameraMaxRangeFXHandle > -1 && ( !inWarningRange || !IsValid( file.cameraRui ) ) ) //
		{
			if ( EffectDoesExist( activeCamera.e.cameraMaxRangeFXHandle ) )
				EffectStop( activeCamera.e.cameraMaxRangeFXHandle, true, false )
			activeCamera.e.cameraMaxRangeFXHandle = -1
		}
		if ( IsValid( file.cameraRui ) )
		{
			if ( inWarningRange )
			{
				if ( activeCamera.e.cameraMaxRangeFXHandle == -1 )
				{
					entity cockpit = player.GetCockpit()
					if ( IsValid( cockpit ) )
					{
						activeCamera.e.cameraMaxRangeFXHandle = StartParticleEffectOnEntity( cockpit, GetParticleSystemIndex( CAMERA_MAX_RANGE_SCREEN_FX ), FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
						EffectSetIsWithCockpit( activeCamera.e.cameraMaxRangeFXHandle, true )
					}
				}
				outOfRange = distanceToCrypto > MAX_FLIGHT_RANGE || activeCamera.GetOrigin().z > file.droneMaxZ
				if ( EffectDoesExist( activeCamera.e.cameraMaxRangeFXHandle ) )
				{
					if ( outOfRange )
						EffectSetControlPointVector( activeCamera.e.cameraMaxRangeFXHandle, 1, <1, 0, 0> )
					else
						EffectSetControlPointVector( activeCamera.e.cameraMaxRangeFXHandle, 1, <0.1, 0, 0> )
				}
			}
			float distanceToTarget = Distance( player.GetCrosshairTraceEndPos(), activeCamera.GetOrigin() )
			RuiSetFloat( file.cameraRui, "crossDist", distanceToTarget )
			string targetString = ""
			TraceResults trace = TraceLineHighDetail( activeCamera.GetOrigin(), activeCamera.GetOrigin() + activeCamera.GetForwardVector() * 300, [activeCamera], TRACE_MASK_SHOT | TRACE_MASK_BLOCKLOS, TRACE_COLLISION_GROUP_NONE )
			if ( IsValid( trace.hitEnt ) )
			{
				entity isLootBin = GetLootBinForHitEnt( trace.hitEnt )
				entity isAirdrop = GetAirdropForHitEnt( trace.hitEnt )
				entity parentEnt = trace.hitEnt.GetParent()

				if ( IsDoor( trace.hitEnt ) && !HACK_IsVaultDoor( trace.hitEnt ) )
				{
					targetString = "#CAMERA_INTERACT_DOOR"
				}
				else if ( IsValid( parentEnt ) && IsDoor( parentEnt ) && !HACK_IsVaultDoor( parentEnt ) )
				{
					targetString = "#CAMERA_INTERACT_DOOR"
				}
				else if ( IsValid( isLootBin ) && !LootBin_IsBusy( isLootBin ) && !LootBin_IsOpen( isLootBin ) )
				{
					targetString = "#CAMERA_INTERACT_LOOT_BIN"
				}
				else if ( (IsVaultPanel( trace.hitEnt ) || IsVaultPanel( parentEnt )) )
				{
					//UniqueVaultData vaultData = GetUniqueVaultData( trace.hitEnt )
					//if ( player.GetPlayerNetBool( vaultData.hasVaultKeyString ) )
					//	targetString = vaultData.hintVaultKeyUse
				}
				else if ( IsValid( isAirdrop ) && !GradeFlagsHas( isAirdrop, eGradeFlags.IS_BUSY ) && !isAirdrop.e.isBusy )
				{
					targetString = "#CAMERA_INTERACT_AIRDROP"
				}
				else if ( trace.hitEnt.GetTargetName() == DEATH_BOX_TARGETNAME && ShouldPickupDNAFromDeathBox( trace.hitEnt, player ) )
				{
					if ( trace.hitEnt.GetCustomOwnerName() != "" )
						targetString = Localize( "#CAMERA_INTERACT_DEATHBOX", trace.hitEnt.GetCustomOwnerName() )
					else
						targetString = Localize( "#CAMERA_INTERACT_DEATHBOX", trace.hitEnt.GetOwner().GetPlayerName() )
				}
				else if ( IsRespawnBeacon( trace.hitEnt ) && CountTeammatesWaitingToBeRespawned( player.GetTeam() ) > 0 && trace.hitEnt.e.isBusy == false )
				{
					targetString = "#CAMERA_INTERACT_RESPAWN"
				}

				if ( (targetString != "") && useInputPressed )
					RuiSetGameTime( file.cameraRui, "playerAttemptedUse", Time() )
			}

			RuiSetString( file.cameraRui, "interactHint", targetString )
			RuiSetFloat( file.cameraRui, "distanceToCrypto", distanceToCrypto )
			RuiSetFloat( file.cameraRui, "maxFlightRange", MAX_FLIGHT_RANGE )
			RuiSetBool( file.cameraRui, "flightModeInputIsHeld", flightModeInputIsHeld )
			RuiSetFloat3( file.cameraRui, "cameraOrigin", activeCamera.GetOrigin() )

			vector cameraVel = activeCamera.GetVehicleVelocity()
			vector cameraVel2D = < cameraVel.x, cameraVel.y, 0.0 >
			float cameraSpeed = Length( cameraVel2D ) / 350.0
			RuiSetFloat( file.cameraRui, "velocityScale", cameraSpeed )
		}
		if ( IsValid( file.cryptoAnimatedTacticalRui ) )
		{
			RuiSetFloat( file.cryptoAnimatedTacticalRui, "distanceToCrypto", distanceToCrypto )
		}
		WaitFrame()
	}
}
#endif

bool function PlayerCanUseCamera( entity ownerPlayer, bool needsValidCamera = false )
{
	if ( ownerPlayer.IsTraversing() )
		return false

	if ( ownerPlayer.ContextAction_IsActive() )
		return false

	if ( ownerPlayer.IsZiplining() )
		return false

	if ( ownerPlayer.IsPhaseShifted() )
		return false

	if( Bleedout_IsBleedingOut( ownerPlayer ) )
		return false

	//if ( needsValidCamera && !IsValid( ownerPlayer.p.cryptoActiveCamera ) )
	//	return false

	array <entity> activeWeapons = ownerPlayer.GetAllActiveWeapons()
	if ( activeWeapons.len() > 1 )
	{
		entity offhandWeapon = activeWeapons[1]

		if ( IsValid( offhandWeapon ) && offhandWeapon.GetWeaponClassName() == "mp_weapon_emote_projector" )
		{
			return false
		}
	}
	return true
}

entity function CryptoDrone_GetPlayerDrone( entity player )
{
	foreach ( drone in file.allDrones )
	{
		if ( !IsValid( drone ) )
			continue

		entity owner = drone.GetOwner()

		if ( !IsValid( owner ) )
			continue

		if ( owner == player )
			return drone
	}

	return null
}

#if CLIENT
void function CryptoDrone_OnPropScriptCreated( entity ent )
{
	if ( ent.GetScriptName() == CRYPTO_DRONE_SCRIPTNAME )
	{
		ModelFX_EnableGroup( ent, "thrusters_friend" )
		ModelFX_EnableGroup( ent, "thrusters_foe" )
		if ( ent.GetOwner() == GetLocalViewPlayer() )
		{
			thread CryptoDrone_CreateHUDMarker( ent )
		}

		file.allDrones.append( ent )
	}
}

void function CryptoDrone_OnPropScriptDestroyed( entity ent )
{
	if ( ent.GetScriptName() == CRYPTO_DRONE_SCRIPTNAME )
	{
		file.allDrones.fastremovebyvalue( ent )
	}
}

void function CryptoDrone_OnPlayerTeamChanged( entity player, int oldTeam, int newTeam )
{
	foreach( drone in file.allDrones )
	{
		if ( IsValid( drone ) )
		{
			ModelFX_DisableGroup( drone, "thrusters_friend" )
			ModelFX_DisableGroup( drone, "thrusters_foe" )

			ModelFX_EnableGroup( drone, "thrusters_friend" )
			ModelFX_EnableGroup( drone, "thrusters_foe" )
		}
	}
}

void function CryptoDrone_CreateHUDMarker( entity drone )
{
	printt( "create hud marker")
	EndSignal( drone, "OnDestroy", "CameraViewStart" )
	entity localViewPlayer = GetLocalViewPlayer()

	var rui = CreateFullscreenRui( $"ui/crytpo_drone_offscreen.rpak", RuiCalculateDistanceSortKey( localViewPlayer.EyePosition(), drone.GetOrigin() ) )
	RuiSetImage( rui, "icon", $"rui/hud/tactical_icons/tactical_crypto" )
	RuiSetBool( rui, "isVisible", true )
	RuiSetBool( rui, "pinToEdge", true )
	RuiSetBool( rui, "showClampArrow", true )
	RuiSetBool( rui, "adsFade", true )
	RuiTrackFloat3( rui, "pos", drone, RUI_TRACK_OVERHEAD_FOLLOW )

	RuiSetBool( rui, "showIconOnScreen", true )
	
	OnThreadEnd(
		function() : ( rui )
		{
			RuiDestroy( rui )
		}
	)

	WaitForever()
}

void function CameraView_CreateHUDMarker( entity player )
{
	EndSignal( player, "OnDestroy", "CameraViewEnd" )

	var rui = CreateFullscreenRui( $"ui/crytpo_drone_offscreen.rpak", RuiCalculateDistanceSortKey( player.EyePosition(), player.GetOrigin() ) )
	RuiSetImage( rui, "icon", $"rui/hud/common/crypto_logo" )
	RuiSetBool( rui, "isVisible", true )
	RuiSetBool( rui, "pinToEdge", true )
	RuiSetBool( rui, "showClampArrow", true )
	RuiSetBool( rui, "showIconOnScreen", true )
	RuiSetFloat2( rui, "iconSize", <32.0,32.0,0.0> )
	RuiTrackFloat3( rui, "pos", player, RUI_TRACK_POINT_FOLLOW, player.LookupAttachment( "CHESTFOCUS" ) )

	OnThreadEnd(
		function() : ( rui )
		{
			RuiDestroy( rui )
		}
	)

	WaitForever()
}

var function GetCameraCircleStatusRui()
{
	return file.cameraCircleStatusRui
}

void function CreateCameraCircleStatusRui( entity player )
{
	if ( file.cameraCircleStatusRui != null )
		return

	if ( PlayerHasPassive( player, ePassives.PAS_CRYPTO ) )
	{
		file.cameraCircleStatusRui = CreateFullscreenRui( $"ui/camera_circle_status.rpak" )

		entity localViewPlayer = GetLocalViewPlayer()
		RuiTrackFloat( file.cameraCircleStatusRui, "deathfieldDistance", localViewPlayer, RUI_TRACK_DEATHFIELD_DISTANCE )
		RuiTrackFloat( file.cameraCircleStatusRui, "cameraViewFrac", localViewPlayer, RUI_TRACK_STATUS_EFFECT_SEVERITY, eStatusEffect.camera_view )
	}
}

void function DestroyCameraCircleStatusRui( entity player )
{
	if ( !PlayerHasPassive( player, ePassives.PAS_CRYPTO ) )
	{
		if ( file.cameraCircleStatusRui != null )
		{
			RuiDestroyIfAlive( file.cameraCircleStatusRui )
			file.cameraCircleStatusRui = null
		}
	}
}

var function GetCryptoAnimatedTacticalRui()
{
	return file.cryptoAnimatedTacticalRui
}

void function CreateCryptoAnimatedTacticalRui( entity player )
{
	if( file.cryptoAnimatedTacticalRui != null )
		return

	if ( PlayerHasPassive( player, ePassives.PAS_CRYPTO ) )
	{
		file.cryptoAnimatedTacticalRui = CreateCockpitPostFXRui( $"ui/crypto_tactical.rpak", HUD_Z_BASE )
		UpdateCryptoAnimatedTacticalRui()
	}
}

void function UpdateCryptoAnimatedTacticalRui()
{
	entity localViewPlayer = GetLocalViewPlayer()
	if ( IsValid( localViewPlayer ) )
	{
		RuiTrackFloat( file.cryptoAnimatedTacticalRui, "empFrac", localViewPlayer, RUI_TRACK_STATUS_EFFECT_SEVERITY, eStatusEffect.crypto_camera_is_emp )
		RuiTrackFloat( file.cryptoAnimatedTacticalRui, "recallFrac", localViewPlayer, RUI_TRACK_STATUS_EFFECT_SEVERITY, eStatusEffect.crypto_camera_is_recalling )
		RuiTrackFloat( file.cryptoAnimatedTacticalRui, "hasCamera", localViewPlayer, RUI_TRACK_STATUS_EFFECT_SEVERITY, eStatusEffect.crypto_has_camera )
		RuiSetFloat( file.cryptoAnimatedTacticalRui, "maxFlightRange", MAX_FLIGHT_RANGE )
		RuiTrackFloat( file.cryptoAnimatedTacticalRui, "bleedoutEndTime", localViewPlayer, RUI_TRACK_SCRIPT_NETWORK_VAR, GetNetworkedVariableIndex( "bleedoutEndTime" ) )
		RuiTrackFloat( file.cryptoAnimatedTacticalRui, "reviveEndTime", localViewPlayer, RUI_TRACK_SCRIPT_NETWORK_VAR, GetNetworkedVariableIndex( "reviveEndTime" ) )

		entity offhandWeapon = localViewPlayer.GetOffhandWeapon( OFFHAND_LEFT )
		if ( IsValid( offhandWeapon ) )
			RuiTrackFloat( file.cryptoAnimatedTacticalRui, "clipAmmoFrac", offhandWeapon, RUI_TRACK_WEAPON_CLIP_AMMO_FRACTION )
	}
}


void function DestroyCryptoAnimatedTacticalRui( entity player )
{
	if( !PlayerHasPassive( player, ePassives.PAS_CRYPTO ) )
	{
		if ( file.cryptoAnimatedTacticalRui != null )
		{
			RuiDestroy( file.cryptoAnimatedTacticalRui )
			file.cryptoAnimatedTacticalRui = null
		}
	}
}

void function CryptoDrone_WeaponStatusCheck( entity player, var rui, int slot )
{
	if ( !PlayerHasPassive( player, ePassives.PAS_CRYPTO ) )
		return

	switch ( slot )
	{
		case OFFHAND_LEFT:
			entity offhandWeapon = player.GetOffhandWeapon( OFFHAND_LEFT )
			if ( IsValid( offhandWeapon ) && file.cryptoAnimatedTacticalRui != null )
			{
				UpdateCryptoAnimatedTacticalRui()
			}
			RuiSetBool( rui, "isVisible", false )
			break

		case OFFHAND_INVENTORY:
			if ( StatusEffect_GetSeverity( player, eStatusEffect.crypto_has_camera ) == 0.0 )
				RuiSetString( rui, "hintText", Localize( "#CRYPTO_DRONE_REQUIRED" ) )
			break
	}
}

void function CryptoDrone_OnLifeStateChanged( entity player, int oldLifeState, int newLifeState )
{
	entity localViewPlayer = GetLocalViewPlayer()
	if ( player != localViewPlayer )
		return

	if ( newLifeState != LIFE_ALIVE )
		return

	if ( IsValid( file.cryptoAnimatedTacticalRui ) )
	{
		entity offhandWeapon = localViewPlayer.GetOffhandWeapon( OFFHAND_LEFT )
		if ( IsValid( offhandWeapon ) )
			RuiTrackFloat( file.cryptoAnimatedTacticalRui, "clipAmmoFrac", offhandWeapon, RUI_TRACK_WEAPON_CLIP_AMMO_FRACTION )
	}
}
#endif

bool function IsPlayerInCryptoDroneCameraView( entity player )
{
	return StatusEffect_GetSeverity( player, eStatusEffect.camera_view ) > 0.0
}

float function GetNeurolinkRange( entity player )
{
	return file.neurolinkRange
}

void function CryptoDrone_SetMaxZ( float maxZ )
{
	file.droneMaxZ = maxZ
}

void function SetForceExitDroneView (bool forcing)
{
	file.ForceExitDroneView = forcing
}

bool function DroneHasMaxZ()
{
	return file.droneMaxZ < 60000
}