// Ported by @CafeFPS

global function MpAbilityCryptoDrone_Init

global function OnWeaponTossReleaseAnimEvent_ability_crypto_drone
global function OnWeaponAttemptOffhandSwitch_ability_crypto_drone
global function OnWeaponTossPrep_ability_crypto_drone
global function OnWeaponToss_ability_crypto_drone
global function OnWeaponRegenEnd_ability_crypto_drone
global function IsPlayerInCryptoDroneCameraView
global function CryptoDrone_SetMaxZ

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
global function TrackCryptoAnimatedTacticalRuiOffhandWeapon

global function AddCallback_OnEnterDroneView
global function RemoveCallback_OnEnterDroneView
global function AddCallback_OnLeaveDroneView
global function RemoveCallback_OnLeaveDroneView
global function AddCallback_OnRecallDrone
global function RemoveCallback_OnRecallDrone

global function ServerToClient_CryptoDroneAutoReloadDone
global function CryptoDrone_GetPlayerDrone
global function ServerCallback_ShouldExitDrone
#endif

#if SERVER
global function AddNeurolinkDetectionForPropScript
global function RemoveNeurolinkDetectionForPropScript
global function AddEMPDamageDevice
global function AddEMPDestroyDevice
global function AddEMPDestroyDeviceNoDissolve
global function AddEMPDisableDevice
global function GetNearbyEMPDamageDeviceArray
global function GetNearbyEMPDestroyDeviceArray
global function GetNearbyEMPDisableDeviceArray
global function EMPDeviceDisableCallback
global function CryptoDrone_GetNearbyTargetsForEMPRange
global function CryptoDroneHideCamera
global function CryptoDroneShowCamera
global function Drone_ExitView
global function SetForceExitDroneView
global function CryptoDrone_TrySetAllowExitSpeedBoost
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
const string DRONE_PROPULSION_1P_UPGRADE = "Char_11_TacticalA_E_Upgraded"
const string DRONE_PROPULSION_3P_UPGRADE = "Char_11_TacticalA_E_Upgraded_3p"
const string DRONE_EXPLOSION_3P = "Char_11_TacticalA_F_3p"
const string DRONE_EXPLOSION_1P = "Char_11_TacticalA_F"

const string DRONE_SCANNING_3P = "Char_11_TacticalA_E2_3p"

const string DRONE_ALERT_1P = "Char_11_TacticalA_Ping"			//normal 1P ping sound
const string DRONE_ALERT_DOWNED_1P = "Char_11_TacticalA_Ping"	//"downed player" 1P ping sound - jordanh to slot in the new sound at this point
const string DRONE_ALERT_3P = "Char_11_TacticalA_Ping"			//normal 3P ping sound (it's the same sound as the 1P)

const string TRANSITION_OUT_CAMERA_1P = "Char_11_TacticalA_D"
const string TRANSITION_OUT_CAMERA_3P = "Char_11_TacticalA_D"
const string HACK_SFX_1P = "Crypto_Drone_Antenna_Hack_1p" //Sound played on drone when it hacks a door/loot bin/banner card
const string HACK_SFX_3P = "Crypto_Drone_Antenna_Hack_3p" //Sound played on drone when it hacks a door/loot bin/banner card

//Need to handle player swapping view, "1P probably needs to be 3p on the entity under the hood"
const string DRONE_RECALL_1P = "Char_11_TacticalA_A"
const string DRONE_RECALL_3P = "Char_11_TacticalA_A"
const string DRONE_RECALL_CRYPTO_3P = "Char_11_TacticalA_A"

global const float EMP_RANGE = 1181.1
                    
global const float EMP_RANGE_UPGRADE_MULTIPLIER = 1.25
const float UPGRADE_DRONE_EXIT_SPEED_DURATION = 5.0
const float UPGRADE_DRONE_EXIT_SPEED_INCREASE = 0.15
      
global const float MAX_FLIGHT_RANGE = 7913 //~201m - needs to match crypto_cam_max_distance convar
const float WARNING_RANGE = 5906 //150m
const float CAMERA_FLIGHT_SPEED = 450 //Slightly reduced N / 1.1
global float CRYPTO_DRONE_DAMAGED_REENTER_DEBOUNCE = 1.4
const asset CAMERA_MAX_RANGE_SCREEN_FX = $"P_crypto_drone_screen_distort_CP"
const asset CAMERA_EXPLOSION_FX = $"P_crypto_drone_explosion"
const asset CAMERA_HIT_FX = $"P_drone_shield_hit"//$"wpn_arc_cannon_beam"
const asset CAMERA_HIT_ENEMY_FX = $"P_drone_shield_hit_enemy"//$"wpn_arc_cannon_beam"

const float NEUROLINK_VIEW_MINDOT = 80.0
const int CRYPTO_DRONE_HEALTH = 60
                               
const float DEPLOYABLE_CAMERA_THROW_POWER = 400.0
const float NEUROLINK_VIEW_MINDOT_BUFFED = 120.0
const int CRYPTO_DRONE_HEALTH_PROJECTILE = 50
const float CRYPTO_DRONE_STICK_RANGE = 670.0

//Matches GetCryptoCameraHullsize() in code.
const vector CRYPTO_DRONE_HULL_TRACE_MIN	= <-14, -14, 0>
const vector CRYPTO_DRONE_HULL_TRACE_MAX	= <14, 14, 14>

const asset CRYPTO_DRONE_SIGHTBEAM_FX = $"P_BT_scan_SML" //P_BT_scan_SML r5r version? //$"P_drone_scan_SML_no_streaks" // $"P_BT_scan_SML_no_streaks"
//const asset CRYPTO_DRONE_RANGE_NO_INTRO = $"P_heart_sensor_pulse_1p"

const bool CRYPTO_DRONE_USE_SONAR_FX = false
//const string CRYPTO_DRONE_ATTACH_SOUND_1P = "weapon_tethergun_attach_1p"
//const string CRYPTO_DRONE_ATTACH_SOUND_3P = "weapon_tethergun_attach_3p"
      

global const string CRYPTO_DRONE_SCRIPTNAME = "crypto_camera"
global const string CRYPTO_DRONE_TARGETNAME = "drone_no_minimap_object"

global const string DISABLE_WAYPOINT_SCRIPTNAME = "device_disable_waypoint"

#if SERVER
struct SpeedBoostStatusEffectIndexes
{
	int speedBoostID
	int speedBoostVisualsID
}
#endif
      

global enum eEmpDestroyType
{
	EMP_DESTROY_DISSOLVE,
	EMP_DESTROY_DAMAGE
}

struct
{
	#if CLIENT
		var            cameraRui
		var            cameraCircleStatusRui
		var            cryptoAnimatedTacticalRui
		                               
		var 			fakePlayerMarkerRui
        
		array <entity> allDrones
	//%if HAS_CRYPTO_DRONE_HUD_UPDATE
	//	int 		   droneRangeVFX
	//%endif
	#endif
	#if SERVER
		int                                         neurolinkRegisteredPropScriptsArrayID
		int                                         empDamageArrayID
		int                                         empDestroyArrayID
		int                                         empDisableArrayID
		table <entity, int>                         cameraSonarTeamID
		table <entity, table<entity, float> >       cameraDroneAlertTimes
		table <entity, array<int> >                 cameraDetectedStatusEffects
		table <entity, void functionref(entity) >   empDeviceDisabledCallbacks
		table <entity, float>                       lastTimeUsedVaultKey
	                               
		table <entity, entity> 						dummyPlayerProps
       
	                    
		table<entity, SpeedBoostStatusEffectIndexes> playerStatusEffects
		table<entity, bool> 						hasDroneExitSpeedBoost
		int crypto_drone_upgraded_health
	#endif

	float neurolinkRange
	float droneMaxZ = 100000
	int   droneHealth
	bool  ForceExitDroneView = false
	bool crypto_tactical_auto_reload_weapons = true

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
	PrecacheParticleSystem( CRYPTO_DRONE_SIGHTBEAM_FX )
	
	//PrecacheParticleSystem( CRYPTO_DRONE_RANGE_NO_INTRO )
	//PrecacheParticleSystem( $"lootpoint_far_beam_close_small" )
	// Remote_RegisterServerFunction( "ClientCallback_AttemptDroneRecall" )
	
	file.neurolinkRange = GetCurrentPlaylistVarFloat( "crypto_neurolink_range", EMP_RANGE )
	file.droneHealth = GetCurrentPlaylistVarInt( "crypto_drone_health", CRYPTO_DRONE_HEALTH_PROJECTILE )
	file.crypto_tactical_auto_reload_weapons = GetCurrentPlaylistVarBool( "crypto_tactical_auto_reload_weapons", true )	
	
	#if SERVER 
	file.crypto_drone_upgraded_health = GetCurrentPlaylistVarInt( "crypto_drone_upgraded_health", 100 )
	#endif
	
	#if SERVER
		RegisterSignal( "ExitCameraView" )
		RegisterSignal( "FinishDroneRecall" )
		//AddDamageCallback( "player", OnPlayerTookDamage ) //(mk): commented, added when entering drone view
		AddClientCommandCallbackNew( "ShouldExitDrone", ClientCommand_ShouldExitDrone )
		file.neurolinkRegisteredPropScriptsArrayID = CreateScriptManagedEntArray()
		file.empDamageArrayID = CreateScriptManagedEntArray()
		file.empDestroyArrayID = CreateScriptManagedEntArray()
		file.empDisableArrayID = CreateScriptManagedEntArray()
		
		AddClientCommandCallback( "AttemptDroneRecall", ClientCommand_AttemptDroneRecall )
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
		RegisterConCommandTriggeredCallback( "+scriptCommand5", AttemptDroneRecall )
		AddCallback_OnWeaponStatusUpdate( CryptoDrone_WeaponStatusCheck )
		AddCallback_OnPlayerLifeStateChanged( CryptoDrone_OnLifeStateChanged )

		AddCallback_CreatePlayerPassiveRui( CreateCameraCircleStatusRui )
		AddCallback_DestroyPlayerPassiveRui( DestroyCameraCircleStatusRui )

		AddCallback_CreatePlayerPassiveRui( CreateCryptoAnimatedTacticalRui )
		AddCallback_DestroyPlayerPassiveRui( DestroyCryptoAnimatedTacticalRui )

		// RegisterMinimapPackage( "prop_script", eMinimapObject_prop_script.CRYPTO_DRONE, MINIMAP_OBJECT_RUI, MinimapPackage_CryptoDrone, FULLMAP_OBJECT_RUI, MinimapPackage_CryptoDrone )
	                               
		//Crypto Dummy Update uncomment
		//RegisterMinimapPackage( "prop_script", eMinimapObject_prop_script.PLAYER_DUMMY, MINIMAP_OBJECT_RUI, MinimapPackage_PlayerDummy, FULLMAP_OBJECT_RUI, MinimapPackage_PlayerDummy )
	#endif

	if ( AutoReloadWhileInCryptoDroneCameraView() )
		Remote_RegisterClientFunction( "ServerToClient_CryptoDroneAutoReloadDone", "entity" )

	//testing different method for confirming immediate camera access
	RegisterSignal( "Crypto_Immediate_Camera_Access_Confirmed" )
	RegisterSignal( "Crypto_StopSendPointThink" )

	#if SERVER
	// AddCallback_OnPassiveChanged( ePassives.PAS_STOWED_DRONE_SCAN, StowedDroneScan_OnPassiveChanged )
	RegisterSignal( "RemoveStowedDrone" )
	#endif

}

#if SERVER
void function StowedDroneScan_OnPassiveChanged( entity player, int passive, bool didHave, bool nowHas )
{
	if ( nowHas )
	{
		entity offhandWeapon = player.GetOffhandWeapon( OFFHAND_LEFT )
		if( !(StatusEffect_GetSeverity( player, eStatusEffect.crypto_has_camera ) > 0) && offhandWeapon.GetWeaponPrimaryClipCount() >= offhandWeapon.GetAmmoPerShot() )
			thread CreateStowedDrone( player )
	}
	if ( didHave )
	{
		player.Signal( "RemoveStowedDrone" )
	}
}

void function CreateStowedDrone( entity player )
{
	vector position		= player.EyePosition()
	vector viewVector = player.GetViewForward()
	vector angles       =  VectorToAngles( -viewVector )
	entity cameraProxy  = CreateEntity( "player_vehicle" )
	cameraProxy.kv.fadedist    = -1.0
	cameraProxy.kv.renderamt   = 255
	cameraProxy.kv.rendercolor = "255 255 255"
	cameraProxy.kv.solid       = 0
	cameraProxy.Hide()


	cameraProxy.SetOrigin( position )
	cameraProxy.SetAngles( angles )
	cameraProxy.SetParent( player )

	cameraProxy.RemoveFromAllRealms()
	cameraProxy.AddToOtherEntitysRealms( player )

	DispatchSpawn( cameraProxy )

	cameraProxy.VehicleSetType( VEHICLE_NONE )
	cameraProxy.SetIgnorePredictedTriggerTypes( TT_JUMP_PAD )
	cameraProxy.e.originalLocalAngles = angles

	cameraProxy.SetOwner( player )
	player.Signal( "RemoveStowedDrone" )
	EndSignal( cameraProxy, "OnDestroy", "OnDeath" )
	EndSignal( player, "RemoveStowedDrone" )

	int team          = player.GetTeam()
	SetTeam( cameraProxy, team )
	thread NeurolinkThink( cameraProxy, false )

	OnThreadEnd(
		function() : ( cameraProxy )
		{
			if( IsValid( cameraProxy ) )
			{
				cameraProxy.Destroy()
			}
		}
	)

	while( IsValid( cameraProxy ) && IsValid( player ) )
	{
		viewVector = player.GetViewForward()
		angles       =  VectorToAngles( -viewVector )
		cameraProxy.SetAbsAngles( angles )
		WaitFrame()
	}

	//owner.p.cryptoActiveCamera = cameraProxy
}
#endif
      

//////////////////////////////////
////// ONWEAPON FUNCTIONS ////////
//////////////////////////////////

bool function OnWeaponAttemptOffhandSwitch_ability_crypto_drone( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	if( !IsValid( player ) )
		return false

	if ( IsPlayerInCryptoDroneCameraView( player ) )
		return false

	if ( StatusEffect_GetSeverity( player, eStatusEffect.script_helper )  > 0)
		return false

	if ( StatusEffect_GetSeverity( player, eStatusEffect.crypto_camera_is_recalling )  > 0)
		return false

	if ( !PlayerCanUseCamera( player, false ) )
		return false

	// Holospray_DisableForTime( player, 2.0 )
	return true
}

var function OnWeaponToss_ability_crypto_drone( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity player = weapon.GetWeaponOwner()

		Signal( player, "Crypto_Immediate_Camera_Access_Confirmed" )

		if ( !(StatusEffect_GetSeverity( player, eStatusEffect.crypto_has_camera ) > 0))
		{
				entity camera = CryptoDrone_ReleaseCamera( weapon, attackParams, Drone_GetDeployableCameraThrowPower( player ) )
				Signal( player, "Crypto_StopSendPointThink" )
         
			#if SERVER
				AnnounceNearbySquads( player )
			#endif // SERVER

			return -1
		}
		else
		{
			if ( weapon.HasMod( "crypto_drone_access" ) )
			{
				return -1
			}
			else
			{
			#if CLIENT
				ServerCallback_SurvivalHint( eSurvivalHints.CRYPTO_DRONE_ACCESS )
			#endif
				return 0
			}
		}
	return -1
}


float function Drone_GetDeployableCameraThrowPower( entity player )
{
	float throwPower = DEPLOYABLE_CAMERA_THROW_POWER

	return throwPower
}

#if SERVER
void function AnnounceNearbySquads( entity player )
{
	thread function() : ( player )
	{
		wait 1.0
		if ( IsValid( player ) )
		{
			int count = GetNumberOfEnemySquadsInDroneRange( player )
			player.SetPlayerNetInt( "cameraNearbyEnemySquads", count )
			count = minint( count, 4 )
			entity teamEnt = GetTeamEnt( player.GetTeam() )
			// BroadcastCommsActionToTeam( player, eCommsAction.PING_BANNER_ENEMYCOUNT_0 + count, teamEnt, player.GetOrigin(), eCommsFlags.NONE, "" )
		}
	}()
}
#endif //SERVER

var function OnWeaponTossReleaseAnimEvent_ability_crypto_drone( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity player = weapon.GetWeaponOwner()

	#if SERVER
	#endif // SERVER
	PlayerUsedOffhand( player, weapon )
	if ( (StatusEffect_GetSeverity( player, eStatusEffect.crypto_has_camera ) > 0) && !(StatusEffect_GetSeverity( player, eStatusEffect.camera_view ) > 0) )
	{
		#if SERVER
			if ( !PlayerCanUseCamera( player, true ) )
				return 0
				// in the projectile version of this ability, the mantle is always disabled because the player always goes into Drone view immediately
				player.DisableMantle()
				AnnounceNearbySquads( player )
			thread SwapToCameraView_Thread( player, player.p.cryptoActiveCamera )
		#endif // SERVER
		return 0
	}

	int ammoReq = weapon.GetAmmoPerShot()
	if ( !weapon.HasMod( "crypto_has_camera" ) )
	{
		weapon.EmitWeaponSound_1p3p( "null_remove_soundhook", "null_remove_soundhook" )
		#if SERVER
			AnnounceNearbySquads( player )
		#endif // SERVER
	}

	#if SERVER
		return 0
	#endif // SERVER
}

void function OnWeaponTossPrep_ability_crypto_drone( entity weapon, WeaponTossPrepParams prepParams )
{
	#if CLIENT
		if ( InPrediction() )
	#endif // CLIENT
			weapon.AddMod( "crypto_drone_access" )

		entity player = weapon.GetOwner()
		if ( !(StatusEffect_GetSeverity( player, eStatusEffect.crypto_has_camera ) > 0) && !(StatusEffect_GetSeverity( player, eStatusEffect.camera_view ) > 0) )
			thread CryptoDrone_WeaponInputThink( weapon.GetWeaponOwner(), weapon )

	if ( weapon.HasMod( "crypto_has_camera" ) )
		weapon.EmitWeaponSound_1p3p( "Char_11_Tactical_Secondary_Deploy", "" )
	else
		weapon.EmitWeaponSound_1p3p( "Char_11_Tactical_Deploy", "Char_11_Tactical_Deploy_3p" )
}

void function OnWeaponRegenEnd_ability_crypto_drone( entity weapon )
{
	entity player = weapon.GetOwner()
	if ( !(StatusEffect_GetSeverity( player, eStatusEffect.crypto_has_camera ) > 0) )
		thread CryptoDrone_TestSendPoint_Think( player )

	#if SERVER
		// if( PlayerHasPassive( player, ePassives.PAS_STOWED_DRONE_SCAN ) )
		// {
			// thread CreateStowedDrone( player )
		// }
	#endif
       
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

	// "screen wipe" transition particle FX
	int systemIndex = playFastTransition ? GetParticleSystemIndex( SCREEN_FAST_FX ) : GetParticleSystemIndex( SCREEN_FX )
	int fxID1       = StartParticleEffectOnEntity( player, systemIndex, FX_PATTACH_POINT_FOLLOW, cockpit.LookupAttachment( "CAMERA" ) )
	EffectSetIsWithCockpit( fxID1, true )

	var transitionRui
	if ( playFastTransition )
	{
		transitionRui = CreateFullscreenRui( $"ui/camera_transition_fast.rpak", 1000 )
	}
	else
	{
		transitionRui = CreateFullscreenRui( $"ui/camera_transition.rpak", 1000 )
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

	//Stops the effect after the wait time
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
				RuiSetBool( file.cameraCircleStatusRui, "isVisible", true )

			if ( IsValid( file.cryptoAnimatedTacticalRui ) )
				RuiSetBool( file.cryptoAnimatedTacticalRui, "inTransition", false )
		}
	)

                   
		float endTime = playFastTransition ? 1.2 + Time() : 1.2 + Time()
      
                                                                   
       
	
	                               
		bool needsButtonHeldDown = !playFastTransition
       
	while( Time() < endTime )
	{
		                               
			// break out of the transition early if the button isn't held down
			// testing different method for confirming immediate camera accesss
			//if ( needsButtonHeldDown && !player.IsInputCommandHeld( IN_OFFHAND1 ) )
			//	break
        

		if ( IsValid( file.cameraRui ) )
			RuiSetBool( file.cameraRui, "inTransition", true )
		if ( IsValid( file.cameraCircleStatusRui ) )
			RuiSetBool( file.cameraCircleStatusRui, "isVisible", false )
		WaitFrame()
	}
}
#endif

/*
 ██████╗ █████╗ ███╗   ███╗███████╗██████╗  █████╗
██╔════╝██╔══██╗████╗ ████║██╔════╝██╔══██╗██╔══██╗
██║     ███████║██╔████╔██║█████╗  ██████╔╝███████║
██║     ██╔══██║██║╚██╔╝██║██╔══╝  ██╔══██╗██╔══██║
╚██████╗██║  ██║██║ ╚═╝ ██║███████╗██║  ██║██║  ██║
 ╚═════╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝
*/

#if CLIENT
void function AttemptDroneRecall( entity player )
{
	if ( player != GetLocalViewPlayer() || player != GetLocalClientPlayer() )
		return

	if( !PlayerHasPassive( player, ePassives.PAS_CRYPTO ) )
		return

	if ( IsControllerModeActive() )
	{
		if ( TryPingBlockingFunction( player, "quickchat" ) )
			return
	}

	player.ClientCommand( "AttemptDroneRecall" )
}

void function ServerCallback_ShouldExitDrone()
{
	entity player = GetLocalClientPlayer()

	if( !PlayerHasPassive( player, ePassives.PAS_CRYPTO ) )
		return
		
	if( IsValid( player ) )
	{
		if( PlayerSetting_DamageClosesMenu() )
		{
			player.ClientCommand("ShouldExitDrone")
		}
	}
}
#endif // CLIENT

#if SERVER
bool function ClientCommand_AttemptDroneRecall(entity player, array < string > args)
{
	if( !IsValid( player ) || !player.IsPlayer() )
		return false

	if ( !IsAlive( player ) )
		return false

	if ( !PlayerHasPassive( player, ePassives.PAS_CRYPTO ) )
		return false

	if ( !IsValid( player.p.cryptoActiveCamera ) )
		return false

	if ( StatusEffect_GetSeverity( player, eStatusEffect.crypto_camera_is_emp ) > 0 )
		return false

	if ( StatusEffect_GetSeverity( player, eStatusEffect.crypto_camera_is_recalling ) > 0  )
		return false

	if ( !(StatusEffect_GetSeverity( player, eStatusEffect.crypto_has_camera ) > 0 ) )
		return false

	Drone_RecallDrone( player )
	return true
}

void function ClientCommand_ShouldExitDrone( entity player, array<string> args )
{
	if( !IsValid( player ) || GetGameState() != eGameState.Playing )
		return
		
	Drone_ExitView( player )
}

void function OnPlayerTookDamage( entity damagedEnt, var damageInfo )
{
	if( !IsValid( damagedEnt ) )
		return

	int damageSourceId = DamageInfo_GetDamageSourceIdentifier( damageInfo )
	if ( damageSourceId == eDamageSourceId.deathField )
		return

	int playerTeam  = damagedEnt.GetTeam()
	entity attacker = DamageInfo_GetAttacker( damageInfo )
	if ( IsValid( attacker ) && IsFriendlyTeam( attacker.GetTeam(), playerTeam ) )
		return

	entity inflictor = DamageInfo_GetInflictor( damageInfo )
	if ( IsValid( inflictor ) && IsFriendlyTeam( inflictor.GetTeam(), playerTeam ) )
		return

	if ( IsPlayerInCryptoDroneCameraView( damagedEnt ) )
	{
		entity weapon = damagedEnt.GetOffhandWeapon( OFFHAND_TACTICAL )
		if ( IsValid( weapon ) )
			weapon.SetNextAttackAllowedTime( Time() + CRYPTO_DRONE_DAMAGED_REENTER_DEBOUNCE ) // Small debounce to prevent accidentally re-entering
	}

	if( PlayerHasPassive( damagedEnt, ePassives.PAS_CRYPTO ) )
		Remote_CallFunction_NonReplay( damagedEnt, "ServerCallback_ShouldExitDrone" ) //(mk): possibly get a clientsided ondamaged shared callback happening
}
#endif // SERVER

entity function CryptoDrone_ReleaseCamera( entity weapon, WeaponPrimaryAttackParams attackParams, float throwPower, vector ornull angularVelocity = null )
{
	#if CLIENT
		if ( !weapon.ShouldPredictProjectiles() )
			return null
	#endif // CLIENT

	entity player = weapon.GetWeaponOwner()
	vector angles   = VectorToAngles( attackParams.dir )
	entity deployable = ThrowDeployable_Retail( weapon, attackParams, throwPower, CryptoDrone_CameraImpact, CryptoDrone_CameraImpact, <0,0,0> )

	if ( deployable )
	{
		deployable.SetAngles( <0, angles.y - 180, 0> )
		deployable.kv.collisionGroup = TRACE_COLLISION_GROUP_PLAYER
		#if SERVER
			// if ( IsValid( player ) )
				// FiringRange_AddToRemoveOnCharacterChange( deployable, player )

			entity vehicleProxy = CryptoDrone_CreateFlyingCameraVehicle( player, deployable, true )
			thread Crypto_FlyingCameraThink( player )
		#endif // SERVER
	}

	return deployable
}

void function CryptoDrone_CameraImpact( entity projectile, DeployableCollisionParams collisionParams )
{
	if( GetCurrentPlaylistVarBool( "crypto_drone_spawn_at_origin_defensive_fix", true ) )
	{
		thread CryptoDrone_CameraImpact_Thread( projectile, collisionParams )
	}
	else
	{
		#if SERVER
			entity owner = projectile.GetOwner()
			array< entity > children = GetChildren( projectile )
			if ( children.len() <= 0 )
				return

			entity cameraVehicle = children[ 0 ]
			//EmitSoundOnEntityExceptToPlayer( cameraVehicle, owner, CRYPTO_DRONE_ATTACH_SOUND_1P )
			//EmitSoundOnEntityOnlyToPlayer( owner, owner, CRYPTO_DRONE_ATTACH_SOUND_3P )

			vector viewAngles = VectorToAngles( collisionParams.normal )
			if ( collisionParams.normal.z > 0.5 || collisionParams.normal.z < -0.5 )
					viewAngles = < 0, cameraVehicle.e.originalLocalAngles.y, 0 >

			Crypto_TryDestroyDroneProjectile( cameraVehicle, true, viewAngles )
			cameraVehicle.Anim_PlayOnly( "drone_active_idle" )

			if ( CRYPTO_DRONE_USE_SONAR_FX )
				thread CryptoDrone_Pulse_Think( cameraVehicle )
		#endif //SERVER
		projectile.SetVelocity( <0, 0, 0> )
	}
}

void function CryptoDrone_CameraImpact_Thread( entity projectile, DeployableCollisionParams collisionParams )
{
	Assert( IsNewThread(), "Must be threaded off" )

	if ( !IsValid( projectile ) )
		return

	projectile.EndSignal( "OnDestroy" )
	projectile.EndSignal( "OnDeath" )

	projectile.SetVelocity( <0, 0, 0> )

	#if SERVER
		//Defensive fix for - R5DEV-335323
		//Still not 100% sure what is causing this issue, best guess is a race condition where when you throw the drone directly into geo and are pressed up against said geo and moving into it we have the following happen on the same frame:
		//-Clearing the parent projectile because we've hit this callback
		//-Calling PutPlayerVehicleInSafeSpot after clearing the parent
		//-Having the CPlayer::UpdateNearbyPushers() loop run this frame which is catching the drone.
		//The UpdateNearbyPushers will make a call to GetAbsOrigin() inside of GetCollisionOrigin_Inline() which will call into CalcAbsolutePosition()
		//The TeleportEntity_Internal call from PutPlayerVehicleInSafeSpot will call SetAbsOrigin() which will also call into CalcAbsolutePosition()
		//There are locks etc setup to prevent this race condition that look ok.  I worked with Benny to even add some RecursiveMutex_LockScope calls to try and catch the race condition but those were unsuccessful.
		//So there is a chance that its not a race condition and some issue with the logic elsewhere.  The crux of the issue is that m_localOrigin is a local space origin only when parented, when unparented it should mirror the absOrigin.
		//The bug happens when we have the drone unparented, but we _somehow_ have a m_localOrigin that hasn't been set back to the absOrigin in time (via parenting_clearParentOriginFix convar) meaning that inside of CalcAbsolutePosition we assign our parented local origin of <0,0,0> into absOrigin:
		// (from void CBaseEntity::CalcAbsolutePosition() )
		//// no move parent, so just copy existing values
		//		SetPrevAbsOrigin( m_localOrigin );
		//		m_vecAbsOrigin = m_localOrigin;
		//		m_angAbsRotation = m_localAngles;
		//All this to say, if we just wait a frame on camera impact, it seems that the issue no longer occurs, so going with that ... for now.
		WaitFrame()
		entity owner = projectile.GetOwner()
		array< entity > children = GetChildren( projectile )
		if ( children.len() <= 0 )
			return

		// Fix for R5DEV-561562
		// Seems there are cases where the first child of the drone projectile isnt the drone itself, so instead we'll just check all the children
		entity cameraVehicle
		foreach( child in children )
		{
			if( child.GetClassName() == "player_vehicle" && child.GetScriptName() == CRYPTO_DRONE_SCRIPTNAME ) //Cafe was here
			{
				cameraVehicle = child
				break
			}
		}
		if( !IsValid( cameraVehicle ) )
		{
			projectile.Destroy()
			return
		}

		//EmitSoundOnEntityExceptToPlayer( cameraVehicle, owner, CRYPTO_DRONE_ATTACH_SOUND_1P )
		//EmitSoundOnEntityOnlyToPlayer( owner, owner, CRYPTO_DRONE_ATTACH_SOUND_3P )

		vector viewAngles = VectorToAngles( collisionParams.normal )
		if ( collisionParams.normal.z > 0.5 || collisionParams.normal.z < -0.5 )
			viewAngles = < 0, cameraVehicle.e.originalLocalAngles.y, 0 >

		Crypto_TryDestroyDroneProjectile( cameraVehicle, true, viewAngles )
		cameraVehicle.Anim_PlayOnly( "drone_active_idle" )

		if ( CRYPTO_DRONE_USE_SONAR_FX )
			thread CryptoDrone_Pulse_Think( cameraVehicle )
	#endif //SERVER

}

#if SERVER
void function CryptoDrone_Pulse_Think( entity cameraVehicle )
{
	wait 0.1

	if ( !IsValid( cameraVehicle ) )
		return

	entity owner = cameraVehicle.GetOwner()

	if ( !IsValid( owner ) )
		return

	Remote_CallFunction_Replay( owner, "ServerCallback_SonarPulseConeFromPosition", cameraVehicle.GetOrigin(), 200.0, cameraVehicle.GetForwardVector(), 100.0, owner.GetTeam(), 0.5, true, false )
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
	//testing different method for confirming immediate camera accesss
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
	#endif // CLIENT
			weapon.RemoveMod( "crypto_drone_access" )
	}
}
                                     

#if SERVER
void function Drone_ExitView( entity player )
{
	player.Signal( "ExitCameraView" )
	RemoveEntityCallback_OnDamaged( player, OnPlayerTookDamage )
	#if DEVELOPER 
		//printt( "Crypto RemoveEntityCallback_OnDamaged:", player )
	#endif 
}

//Prototyping the hacking / drone gameplay. The current plan is to clean this up and have the vehicle use the normal use system.
void function Drone_AttemptUse( entity player )
{
	entity camera = player.p.cryptoActiveCamera
	if ( !IsValid( camera ) )
		return

	TraceResults trace = TraceLineHighDetail( camera.GetOrigin(), camera.GetOrigin() + camera.GetForwardVector() * 300, [camera], TRACE_MASK_SHOT | TRACE_MASK_BLOCKLOS, TRACE_COLLISION_GROUP_NONE, camera )
	if ( IsValid( trace.hitEnt ) )
	{
		entity isLootBin = GetLootBinForHitEnt( trace.hitEnt )
		entity isAirdrop = GetAirdropForHitEnt( trace.hitEnt )
		entity parentEnt = trace.hitEnt.GetParent()
		bool success     = false

		if ( IsDoor( trace.hitEnt ) && DroneCanOpenDoor( camera, trace.hitEnt ) || IsValid( parentEnt ) && IsDoor( parentEnt ) && DroneCanOpenDoor( camera, parentEnt ) )//Why is this needed? Cafe
		{
			if( IsValid( parentEnt ) && IsDoor( parentEnt ) ) //Why is this needed? Cafe
				trace.hitEnt = parentEnt

			if( IsCodeDoor( trace.hitEnt )  )
			{
				if ( trace.hitEnt.IsDoorOpen() )
					trace.hitEnt.CloseDoor( camera )
				else
					trace.hitEnt.OpenDoor( camera )
			}
			else
			{
				trace.hitEnt.Signal( "OnPlayerUse", { player = player } )
			}
			success = true
		}
		//fixme. Cafe

		// else if ( trace.hitEnt.GetTargetName() == PASSIVE_REINFORCE_REBUILT_DOOR_SCRIPT_NAME && IsReinforced( trace.hitEnt ) && IsFriendlyTeam( camera.GetTeam(), trace.hitEnt.GetTeam() ) )
		// {
			// BreakRebuiltDoor( trace.hitEnt )
			// success = true
		// }
		// else 
		if ( IsValid( isLootBin ) )
		{
			if ( LootBin_OnUse( isLootBin, player, USE_INPUT_DEFAULT ) )
				success = true
		}
		else if ( IsValid( isAirdrop ) )
		{
			if ( DropPod_OnUse( isAirdrop, player, USE_INPUT_DEFAULT ) )
				success = true
		}
		else if ( trace.hitEnt.GetTargetName() == DEATH_BOX_TARGETNAME && ShouldPickupDNAFromDeathBox( trace.hitEnt, player ) )
		{
			DeathBoxOnUse( trace.hitEnt, player, 0 )
			success = true
		}
              
		// else if ( IsVaultPanel( trace.hitEnt ) )
		// {
			// UniqueVaultData vaultData = GetUniqueVaultData( trace.hitEnt )

			// if ( HasVaultKey( player ) )
			// {
				// ForceVaultOpen( trace.hitEnt )
				// if ( !(player in file.lastTimeUsedVaultKey) )
					// file.lastTimeUsedVaultKey[player] <- 0

				// if ( Time() - file.lastTimeUsedVaultKey[player] > 5 )
				// {
					// SURVIVAL_RemoveFromPlayerInventory( player, vaultData.vaultKeylootType, 1 )
					// file.lastTimeUsedVaultKey[player] = Time()
				// }

				// if ( SURVIVAL_CountItemsInInventory( player, vaultData.vaultKeylootType ) == 0 )
				// {
					// HideDataVaultsFromPlayer( player )
				// }
				// success = true
			// }
		// }
        //not compatible with s3 one (path passive) survey beacon system needs update. Cafe (for later)
		// else if ( SurveyBeacon_IsSurveyBeacon( trace.hitEnt ) || ( IsValid( parentEnt ) && SurveyBeacon_IsSurveyBeacon( parentEnt ) ) )
		// {
			// entity surveyBeacon = SurveyBeacon_IsSurveyBeacon( trace.hitEnt ) ? trace.hitEnt : parentEnt
			// if ( ControlPanel_CanUseFunction( player, surveyBeacon, 0 ) && SurveyBeacon_CanUseFunction( player, surveyBeacon, 0 ) && SurveyBeacon_CanActivate( player, surveyBeacon ) )
			// {
				// surveyBeacon.Signal( "OnPlayerUse", { player = player } )
				// success = true
			// }
		// }

		if ( success )
		{
			EmitSoundOnEntityOnlyToPlayer( camera, player, HACK_SFX_1P )
			EmitSoundOnEntityExceptToPlayer( camera, player, HACK_SFX_3P )
		}
	}
}

void function Drone_AttemptUseLong( entity player )
{
	entity camera = player.p.cryptoActiveCamera
	if ( !IsValid( camera ) )
		return

	TraceResults trace = TraceLineHighDetail( camera.GetOrigin(), camera.GetOrigin() + camera.GetForwardVector() * 300, [camera], TRACE_MASK_SHOT | TRACE_MASK_BLOCKLOS, TRACE_COLLISION_GROUP_NONE, camera )
	if ( IsValid( trace.hitEnt ) )
	{
		bool isRecalling = StatusEffect_GetSeverity( player, eStatusEffect.crypto_camera_is_recalling ) > 0

		if ( IsRespawnBeacon( trace.hitEnt ) && CountTeammatesWaitingToBeRespawned( player.GetTeam() ) > 0 && trace.hitEnt.e.isBusy == false )
		{
			ExtendedUseSettings settings
			thread RespawnUserTeam( trace.hitEnt, player, settings )
		}
	}
}

void function Drone_TryEMP( entity player )
{
	if ( StatusEffect_GetSeverity( player, eStatusEffect.crypto_camera_is_recalling )  > 0 )
		return

	entity ult = player.GetOffhandWeapon( OFFHAND_ULTIMATE )
	if ( IsValid( ult ) )
	{
		int maxClipCount = ult.GetWeaponPrimaryClipCountMax()
		
		#if DEVELOPER
			printt( "\t| Drone TRY emp. Clip count good?", ult.GetWeaponPrimaryClipCount() == maxClipCount, "net bool is false?", player.GetPlayerNetBool( "isDoingEMPSequence" ) )	
		#endif
		
		if ( ult.GetWeaponPrimaryClipCount() == maxClipCount && !player.GetPlayerNetBool( "isDoingEMPSequence" ) )
		{
			PlayerUsedOffhand( player, ult, true ) //Unfortunately only called on the server if you're in the camera
			thread DroneEMP( player )
			ult.SetWeaponPrimaryClipCount( 0 )
		}
	}
}

bool function Drone_RecallDrone( entity player )
{
	entity camera = player.p.cryptoActiveCamera

	if ( !IsValid( camera ) )
		return false

	if ( DroneHasActiveAnimation( camera ) )
		return false

	thread Drone_RecallThink( camera, player )

	return true
}

void function Drone_RecallThink( entity camera, entity player )
{
	EndSignal( camera, "OnDestroy" )
	camera.Anim_Stop()
	camera.Anim_PlayOnly( "drone_recall" )

	entity owner = camera.GetOwner()
	if ( IsValid( owner ) )
	{
		PlayBattleChatterLineToSpeakerAndTeamWithDebounceTime( owner, "bc_droneRecall", 30.0, 60.0 )
		float animLength = camera.GetSequenceDuration( "animseq/props/crypto_drone/crypto_drone/drone_EMP.rseq" )
                  
		animLength = animLength / 3 //Not sure why this is necessary but the animLength as long as it actually is.

		StatusEffect_AddTimed( owner, eStatusEffect.crypto_camera_is_recalling, 1.0, animLength, animLength )
	}

	player.Signal( "OnContinousUseStopped" )

	Crypto_TryDestroyDroneProjectile( camera )
    
	entity recallFX = StartParticleEffectOnEntity_ReturnEntity( camera, GetParticleSystemIndex( DRONE_RECALL_START_FX_3P ), FX_PATTACH_POINT_FOLLOW, camera.LookupAttachment( "__illumPosition" ) )
	recallFX.SetOwner( owner )
	if ( IsPlayerInCryptoDroneCameraView( owner ) )
		recallFX.kv.VisibilityFlags = ENTITY_VISIBLE_TO_FRIENDLY | ENTITY_VISIBLE_TO_ENEMY
	else
		recallFX.kv.VisibilityFlags = ENTITY_VISIBLE_TO_EVERYONE
	camera.e.fxArray.append( recallFX )

	EmitSoundOnEntityOnlyToPlayer( owner, owner, DRONE_RECALL_1P ) // plays on owner, for owner

	WaittillAnimDone( camera )

	vector cameraOrigin = camera.GetOrigin()
	EmitSoundAtPosition( TEAM_UNASSIGNED, cameraOrigin, "Char_11_TacticalA_D", camera )

	StartParticleEffectInWorld( GetParticleSystemIndex( DRONE_RECALL_END_FX_3P ), cameraOrigin, <0, 0, 0> )

	thread CryptoDrone_TestSendPoint_Think( player )
    
	// if( PlayerHasPassive( owner, ePassives.PAS_STOWED_DRONE_SCAN ) )
	// {
		// thread CreateStowedDrone( player )
	// }
       
	if ( IsValid( owner ) && GetCurrentPlaylistVarBool( "enable_apex_screens", true ) )
		Remote_CallFunction_Replay( owner, "ServerToClient_ApexScreenRefreshAll" )

	Signal( camera, "FinishDroneRecall" )
	camera.Destroy()
}

void function AddExtraCharge( entity offhandWeapon )
{
	int ammoLeftToGive = offhandWeapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )

	if ( offhandWeapon.GetWeaponPrimaryClipCount() < offhandWeapon.GetWeaponPrimaryClipCountMax() )
	{
		int ammoToGive = minint( offhandWeapon.GetWeaponPrimaryClipCountMax() - offhandWeapon.GetWeaponPrimaryClipCount(), ammoLeftToGive )
		offhandWeapon.SetWeaponPrimaryClipCount( offhandWeapon.GetWeaponPrimaryClipCount() + ammoToGive )
		ammoLeftToGive -= ammoToGive
	}

	if ( ammoLeftToGive > 0 )
	{
		int ammoToGive = minint( ammoLeftToGive, offhandWeapon.GetWeaponPrimaryAmmoCountMax( AMMOSOURCE_STOCKPILE ) - offhandWeapon.GetWeaponPrimaryAmmoCount( AMMOSOURCE_STOCKPILE ) )

		offhandWeapon.SetWeaponPrimaryAmmoCount( AMMOSOURCE_STOCKPILE, offhandWeapon.GetWeaponPrimaryAmmoCount( AMMOSOURCE_STOCKPILE ) + ammoToGive )
	}
}

                               
bool function Crypto_TryDestroyDroneProjectile( entity cameraVehicle, bool useFacingOverride = false, vector facingOverride = < 0, 0, 0 > )
{
	if ( !IsValid( cameraVehicle ) )
		return false

	entity projectileParent = cameraVehicle.GetParent()
	if ( IsValid( projectileParent ) )
	{
		cameraVehicle.ClearParent()

		vector placementOrigin = cameraVehicle.GetOrigin()

		//R5DEV-354790 - Need to catch if the drone has been thrown underwater.  PutPlayerVehicleInSafeSpot will move around, but not up above the water if we're already under water from the drone grenade being thrown under there.  Need High Detail trace to hit water. //HighDetail trace hull not present in s3. Cafe
		TraceResults tr = TraceHull( cameraVehicle.GetOrigin() + <0,0,20>, cameraVehicle.GetOrigin() - <0,0,20>, CRYPTO_DRONE_HULL_TRACE_MIN, CRYPTO_DRONE_HULL_TRACE_MAX, [ cameraVehicle ], TRACE_MASK_NPCSOLID | CONTENTS_WATER, TRACE_COLLISION_GROUP_PLAYER )
		vector safeStart = cameraVehicle.GetOrigin()

		//if we detect we've hit something under us, then set the end of the trace as our safe starting position for PutPlayerVehicleInSafeSpot to use.
		if ( tr.fraction < 0.99 && !tr.startSolid && !tr.allSolid )
			safeStart = tr.endPos

		if( GetCurrentPlaylistVarBool( "crypto_drone_safe_spot_fix", true ) )
			PutPlayerVehicleInSafeSpot( cameraVehicle, null, null, safeStart, placementOrigin )
		else
			PutPlayerVehicleInSafeSpot( cameraVehicle, cameraVehicle.GetOwner(), null, safeStart, placementOrigin )

		if ( useFacingOverride )
		{
			cameraVehicle.SetAngles( facingOverride )
			cameraVehicle.e.originalLocalAngles = facingOverride
			SetCameraAngles( cameraVehicle, cameraVehicle.e.originalLocalAngles )
		}
		projectileParent.Destroy()
		cameraVehicle.SetVelocity( < 0, 0, 0 > )

		return true
	}
	return false
}
      

                    
int function CryptoDrone_GetUpgradedHealth() //(mk): not called yet
{
	return file.crypto_drone_upgraded_health
}
      

float function CryptoDrone_GetScanLingerTime( entity scannedEnt, entity cameraOwner )
{
	float result = GetCurrentPlaylistVarFloat( "crypto_drone_scan_linger", 0.0 )

	return result
}

int function CryptoDrone_GetDroneHealth( entity owner )
{
	int result = file.droneHealth

	return result
}

entity function CryptoDrone_CreateFlyingCameraVehicle( entity owner, entity parentEnt, bool projectileDrone )
{
	vector actualEyePos = owner.EyePosition()
	vector ownerOrigin  = owner.GetOrigin()
	vector eyePosition  = <ownerOrigin.x, ownerOrigin.y, actualEyePos.z> // player does a pitch offset on their eye so this isn't the center of the player which we need to test. So grab center and adjust
	vector viewVector   = owner.GetViewVector()
	vector origin       = eyePosition + viewVector * 30
	vector angles       = FlattenAngles( VectorToAngles( viewVector ) )
	entity cameraProxy  = CreateEntity( "player_vehicle" )
	cameraProxy.SetValueForModelKey( CAMERA_MODEL )
	cameraProxy.kv.fadedist    = -1.0
	cameraProxy.kv.renderamt   = 255
	cameraProxy.kv.rendercolor = "255 255 255"
	cameraProxy.kv.solid       = SOLID_BBOX
	cameraProxy.SetAimAssistAllowed( true )
	cameraProxy.e.isDoorBlocker = false
	// cameraProxy.e.ignoreSafePushMode = true
	owner.p.cryptoActiveCamera = cameraProxy

	// cameraProxy.SetDoOnBeingCrushedEntityCallback( true )
	// AddCallback_OnEntityBeingCrushed( cameraProxy, ShouldCryptoDroneBeCrushed )

	if ( projectileDrone && IsValid( parentEnt ) )
	{
		cameraProxy.SetOrigin( parentEnt.GetOrigin() )
		cameraProxy.SetAngles( parentEnt.GetAngles() )
	}
	else
	{
		cameraProxy.SetOrigin( eyePosition )
		cameraProxy.SetAngles( angles )
	}

	cameraProxy.RemoveFromAllRealms()
	cameraProxy.AddToOtherEntitysRealms( owner )

	DispatchSpawn( cameraProxy )

                               
	if ( projectileDrone && IsValid( parentEnt ) )
		cameraProxy.SetParent( parentEnt )
	else
      
		PutPlayerVehicleInSafeSpot( cameraProxy, owner, null, eyePosition, origin )

	cameraProxy.VehicleSetType( VEHICLE_FLYING_CAMERA )
	cameraProxy.SetIgnorePredictedTriggerTypes( TT_JUMP_PAD )

	cameraProxy.e.originalLocalAngles = VectorToAngles( viewVector )

	cameraProxy.DisableHibernation()
	cameraProxy.SetTakeDamageType( DAMAGE_YES )
	cameraProxy.SetMaxHealth( CryptoDrone_GetDroneHealth( owner ) )
	cameraProxy.SetHealth( CryptoDrone_GetDroneHealth( owner ) )
	cameraProxy.SetDamageNotifications( true )
	cameraProxy.SetDeathNotifications( false )
	cameraProxy.SetScriptName( CRYPTO_DRONE_SCRIPTNAME )
	SetTargetName( cameraProxy, CRYPTO_DRONE_TARGETNAME )
	cameraProxy.SetBlocksRadiusDamage( false )
	cameraProxy.kv.collisionGroup = TRACE_COLLISION_GROUP_BLOCK_WEAPONS
	cameraProxy.SetOwner( owner )
	cameraProxy.EnableAttackableByAI( 5, 0, AI_AP_FLAG_NONE )
	// cameraProxy.DisallowObjectPlacement()

	int team          = owner.GetTeam()
	entity minimapObj = CreatePropScript( $"mdl/dev/empty_model.rmdl", origin )
	SetTargetName( minimapObj, "crypto_camera" )
	minimapObj.SetOwner( owner )
	minimapObj.Minimap_SetCustomState( eMinimapObject_prop_script.CRYPTO_DRONE )
	minimapObj.Minimap_SetAlignUpright( false )
	minimapObj.Minimap_SetClampToEdge( true )
	minimapObj.DisableHibernation()
	minimapObj.SetParent( cameraProxy )
	minimapObj.SetLocalAngles( <-90, 0, 0> )
	minimapObj.Minimap_SetZOrder( MINIMAP_Z_OBJECT - 1 )
	array<entity> players = GetPlayerArray()
	foreach ( player in players )
	{
		minimapObj.Minimap_Hide( player.GetTeam(), null )
	}
	minimapObj.Minimap_AlwaysShow( team, null )

	// If we are in a mode where we allow communication between players near each other that are on the same team (but not the same squad); show the icon to nearby teammates
	// AllianceProximity_SetMinimapAlwaysShow_ForAlliance( team, minimapObj, owner )

	SetTeam( cameraProxy, team )
	AddEntityCallback_OnDamaged( cameraProxy, OnCameraDamaged )
	AddEntityCallback_OnPostDamaged( cameraProxy, OnCameraPostDamaged )
	AddEntityDestroyedCallback( cameraProxy, OnCameraDestroyed )
	AddEntityCallback_OnKilled( cameraProxy, OnCameraKilled )
	cameraProxy.SetCanBeMeleed( true )
	SetVisibleEntitiesInConeQueriableEnabled( cameraProxy, true )
	// thread TrapDestroyOnRoundEnd( owner, cameraProxy )
	cameraProxy.SetTouchTriggers( true ) //Make it destroyable by triggers e.g. Leviathan stomp
	cameraProxy.Highlight_Enable()
	cameraProxy.e.canBeDamagedFromGas = false
	cameraProxy.e.canBurn             = true
	AddSonarDetectionForPropScript( cameraProxy )
	AddEMPDestroyDevice( cameraProxy )

	thread NeurolinkThink( cameraProxy )
	thread UpdateNumberOfEnemySquadsInDroneRange_Thread( cameraProxy )
       
	Highlight_SetFriendlyHighlight( cameraProxy, "crypto_camera_friendly" )
	Highlight_SetOwnedHighlight( cameraProxy, "crypto_camera_friendly" )

	if ( GetCurrentPlaylistVarBool( "enable_apex_screens", true ) )
		Remote_CallFunction_Replay( owner, "ServerToClient_ApexScreenRefreshAll" )

	// Setting eye angles now so that it can start Neurolink scanning right away
	if ( projectileDrone && IsValid( parentEnt ) )
		SetCameraAngles( cameraProxy, cameraProxy.e.originalLocalAngles )

	if ( projectileDrone )
	{
		EmitSoundOnEntity( cameraProxy, DRONE_PROPULSION_3P ) //3P Sound
	}

	return cameraProxy
}

bool function ShouldCryptoDroneBeCrushed( entity pusher, entity pushed )
{
	if ( !IsValid( pusher ) || !IsValid( pushed ) )
		return false

	if ( pushed.GetScriptName() == CRYPTO_DRONE_SCRIPTNAME )
	{

		entity doorEnt = null

		//We don't want doors to crush the drone.
		if ( IsDoor( pusher ) )
			doorEnt = pusher
		else
		{
			//Sometimes it can be the phys_bone_follower doing the crushing.
			entity parentEnt = pusher.GetParent()

			if ( IsValid( parentEnt ) && IsDoor( parentEnt ) )
				doorEnt = parentEnt
		}

		if ( IsValid( doorEnt ) )
		{
			// AvoidBeingPutInsideDoorFromCrush( doorEnt, pushed )
			return false
		}
	}

	return true
}

void function Crypto_FlyingCameraThink( entity owner )
{
	EndSignal( owner, "OnDestroy", "OnDeath", "CleanUpPlayerAbilities" )
	EndThreadOn_PlayerChangedClass( owner )
	Set3pDroneVisibility( owner, false )

	if ( !IsValid( owner.p.cryptoActiveCamera ) )
		return

	entity cameraVehicle = owner.p.cryptoActiveCamera
	entity projectileParent = cameraVehicle.GetParent()
	EndSignal( cameraVehicle, "OnDestroy" )

	if ( !DroneHasActiveAnimation( cameraVehicle ) )
		cameraVehicle.Anim_PlayOnly( "drone_activate" )

	entity vortexSphere = CreateCameraVortexSphere( cameraVehicle )
	vortexSphere.SetBlocksRadiusDamage( false )

	OnThreadEnd(
		function() : ( owner, cameraVehicle, projectileParent, vortexSphere )
		{
			if ( IsValid( owner ) )
			{
				StatusEffect_StopAllOfType( owner, eStatusEffect.crypto_has_camera )
				StatusEffect_StopAllOfType( owner, eStatusEffect.crypto_camera_is_recalling )
				StatusEffect_StopAllOfType( owner, eStatusEffect.crypto_camera_is_emp )
				entity offhandWeapon = owner.GetOffhandWeapon( OFFHAND_LEFT )
				if ( IsValid( offhandWeapon ) )
					offhandWeapon.RemoveMod( "crypto_has_camera" )
				Set3pDroneVisibility( owner, true )
			}

			if ( IsValid( projectileParent ) )
				projectileParent.Destroy()

			if ( IsValid( cameraVehicle ) )
				cameraVehicle.Destroy()

			if ( IsValid( vortexSphere ) )
				vortexSphere.Destroy()
		}
	)

	//TraceResults tr = TraceLine( owner.EyePosition(), owner.EyePosition() + owner.GetPlayerOrNPCViewVector() * CRYPTO_DRONE_STICK_RANGE, [ owner ], TRACE_MASK_BLOCKLOS )
	TraceResults tr = TraceHull( owner.EyePosition(), owner.EyePosition() + ( owner.GetPlayerOrNPCViewVector() * CRYPTO_DRONE_STICK_RANGE ), CRYPTO_DRONE_HULL_TRACE_MIN, CRYPTO_DRONE_HULL_TRACE_MAX, [ owner ], TRACE_MASK_NPCSOLID, TRACE_COLLISION_GROUP_PLAYER )
	bool pointInRange = tr.fraction < 1.0
	thread CryptoDrone_ProjectileMovementThink( cameraVehicle, projectileParent, pointInRange )

	if ( CRYPTO_DRONE_USE_SONAR_FX )
		Remote_CallFunction_Replay( owner, "ServerCallback_SonarPulseConeFromPosition", projectileParent.GetOrigin(), 300.0, Normalize( projectileParent.GetVelocity() ), 100.0, owner.GetTeam(), 0.5, true, false )

	//TODO: CLEAN THIS UP
	// hackiest shit ever - need to delay the time until the status effect is applied until after the animation is finished
	// this won't be an issue once we get animation support (if we decide to ship this change)
	WaitTime( 1.25 )

	StatusEffect_AddEndless( owner, eStatusEffect.crypto_has_camera, 1.0 ) //Used for tracking existence of Drone on the client for EMP script.
	entity offhandWeapon = owner.GetOffhandWeapon( OFFHAND_LEFT )
	if ( IsValid( offhandWeapon ) )
		offhandWeapon.AddMod( "crypto_has_camera" )

	Crypto_TryAutoEnterDroneView( owner, offhandWeapon )

	while( true )
	{
		float distanceToCrypto = Distance( owner.GetOrigin(), cameraVehicle.GetOrigin() )
		if ( distanceToCrypto > MAX_FLIGHT_RANGE * 1.2 || cameraVehicle.GetOrigin().z > file.droneMaxZ )
		{
			if ( !(StatusEffect_GetSeverity( owner, eStatusEffect.crypto_camera_is_recalling )  > 0 )&& !( StatusEffect_GetSeverity( owner, eStatusEffect.crypto_camera_is_emp )  > 0 ))
				Drone_RecallDrone( owner )
		}
		WaitTime( 0.5 )
	}
}

void function CryptoDrone_ProjectileMovementThink( entity cameraVehicle, entity projectileParent, bool pointInRange )
{
	const float SLOW_TIME_HITGEO = 0.25
	const float SPEED_THROTTLE_HITGEO = 0.15
	const float SLOW_TIME_STD = 0.5
	const float SPEED_THROTTLE_STD = 0.25
	const float FLIGHT_TIME = 2.0

	if ( !IsValid( cameraVehicle ) || !IsValid( projectileParent ) )
		return

	EndSignal( projectileParent, "OnDestroy", "OnDeath" )

	OnThreadEnd(
		function() : ( cameraVehicle )
		{
			if ( IsValid( cameraVehicle ) )
				Crypto_TryDestroyDroneProjectile( cameraVehicle )
		}
	)

	float throwTimeStart = Time()
	float throwTimeEnd = throwTimeStart + FLIGHT_TIME
	bool stoppedHolding = false
	bool forceSlowdown = false
	bool checkedForForcedSlowdown = false
	while( IsValid( projectileParent ) && IsValid( cameraVehicle ) )
	{
		// For the hold-throw drone, stop the movement once we're sure it's not the tap-throw
		entity owner = projectileParent.GetOwner()
		if ( !stoppedHolding && IsValid( owner ) && owner.IsPlayer() )
		{
			if ( owner.IsInputCommandHeld( IN_OFFHAND1 ) == false )
			{
				stoppedHolding = true
			}
		}
		float timeSinceStart = Time() - throwTimeStart
		if ( timeSinceStart > 0.29 && !checkedForForcedSlowdown )	// 0.29 should always get us 3 server frames from the start, if we used 0.3 it might end up going 4 frames from float math
		{
			checkedForForcedSlowdown = true
			if ( !stoppedHolding )
			{
				forceSlowdown = true
			}
		}
		if ( forceSlowdown )
		{
			projectileParent.SetVelocity( <0,0,0> )
			WaitForever()
		}

		vector traceStart = cameraVehicle.GetCenter()
		vector traceEnd = traceStart + ( projectileParent.GetVelocity() * 0.25 )
		array<entity> ignoreArray = GetPlayerArray_Alive()
		ignoreArray.append( cameraVehicle )
		ignoreArray.append( projectileParent )
		TraceResults geoTrace = TraceHull( traceStart, traceEnd, CRYPTO_DRONE_HULL_TRACE_MIN, CRYPTO_DRONE_HULL_TRACE_MAX, ignoreArray, TRACE_MASK_NPCSOLID, TRACE_COLLISION_GROUP_PLAYER )

		if ( ( geoTrace.fraction < 1.0 ) && !pointInRange )
		{
			projectileParent.SetVelocity( projectileParent.GetVelocity() * SPEED_THROTTLE_HITGEO )
			WaitTime( SLOW_TIME_HITGEO )
			break
		}
		if ( Time() >= throwTimeEnd )
		{
			projectileParent.SetVelocity( projectileParent.GetVelocity() * SPEED_THROTTLE_STD )
			WaitTime( SLOW_TIME_STD )
			break
		}
		WaitFrame()
	}
}

void function Crypto_DeployFlyingCamera( entity owner )
{
	EndSignal( owner, "OnDestroy", "OnDeath" )
	EndThreadOn_PlayerChangedClass( owner )
	Set3pDroneVisibility( owner, false )

	entity cameraProxy = CryptoDrone_CreateFlyingCameraVehicle( owner, null, false )
	EndSignal( cameraProxy, "OnDestroy" )

	StatusEffect_AddEndless( owner, eStatusEffect.crypto_has_camera, 1.0 ) //Used for tracking existence of Drone on the client for EMP script.
	entity offhandWeapon = owner.GetOffhandWeapon( OFFHAND_LEFT )
	if ( IsValid( offhandWeapon ) )
		offhandWeapon.AddMod( "crypto_has_camera" )

	entity vortexSphere = CreateCameraVortexSphere( cameraProxy )
	vortexSphere.SetBlocksRadiusDamage( false )

	owner.p.cryptoActiveCamera = cameraProxy
	thread SwapToCameraView_Thread( owner, cameraProxy )

	OnThreadEnd(
		function() : ( owner, cameraProxy, vortexSphere )
		{
			if ( IsValid( owner ) )
			{
				StatusEffect_StopAllOfType( owner, eStatusEffect.crypto_has_camera )
				StatusEffect_StopAllOfType( owner, eStatusEffect.crypto_camera_is_recalling )
				StatusEffect_StopAllOfType( owner, eStatusEffect.crypto_camera_is_emp )
				entity offhandWeapon = owner.GetOffhandWeapon( OFFHAND_LEFT )
				if ( IsValid( offhandWeapon ) )
					offhandWeapon.RemoveMod( "crypto_has_camera" )
				Set3pDroneVisibility( owner, true )
			}

			if ( IsValid( cameraProxy ) )
				cameraProxy.Destroy()

			if ( IsValid( vortexSphere ) )
				vortexSphere.Destroy()
		}
	)

	while( true )
	{
		float distanceToCrypto = Distance( owner.GetOrigin(), cameraProxy.GetOrigin() )
		if ( distanceToCrypto > MAX_FLIGHT_RANGE * 1.2 || cameraProxy.GetOrigin().z > file.droneMaxZ )
		{
			if ( !(StatusEffect_GetSeverity( owner, eStatusEffect.crypto_camera_is_recalling )  > 0 ) && !(StatusEffect_GetSeverity( owner, eStatusEffect.crypto_camera_is_emp ) > 0) )
				Drone_RecallDrone( owner )
		}
		WaitTime( 0.5 )
	}
}

entity function CreateCameraVortexSphere( entity camera )
{
	entity vortexSphere = CreateEntity( "vortex_sphere" )

	vortexSphere.kv.spawnflags             = SF_ABSORB_BULLETS
	vortexSphere.kv.enabled                = 0
	vortexSphere.kv.radius                 = 16
	vortexSphere.kv.height                 = 16
	vortexSphere.kv.bullet_fov             = 360
	vortexSphere.kv.physics_pull_strength  = 0//25
	vortexSphere.kv.physics_side_dampening = 0//6
	vortexSphere.kv.physics_fov            = 360
	vortexSphere.kv.physics_max_mass       = 0//2
	vortexSphere.kv.physics_max_size       = 0//6

	vortexSphere.SetAngles( <0, 0, 0> ) // viewvec?
	int attachIndex = camera.LookupAttachment( "__illumPosition" )
	vortexSphere.SetOrigin( camera.GetAttachmentOrigin( attachIndex ) )
	vortexSphere.SetMaxHealth( 1000 )
	vortexSphere.SetHealth( 1000 )

	vortexSphere.RemoveFromAllRealms()
	vortexSphere.AddToOtherEntitysRealms( camera )

	DispatchSpawn( vortexSphere )

	Vortex_ConvertToVortexTriggerArea( vortexSphere )
	VortexFireEnable( vortexSphere )
	vortexSphere.SetOwner( camera )
	vortexSphere.SetParent( camera, "__illumPosition", true, 0.0 )

	return vortexSphere
}

void function Camera_ShieldHitFX( entity camera, vector contactPos )
{
	entity controlPoint = CreateEntity( "info_placement_helper" )
	SetTargetName( controlPoint, UniqueString( "camera_shield_fx_helper" ) )
	controlPoint.SetOrigin( camera.GetOrigin() )
	controlPoint.SetAngles( camera.GetAngles() )
	DispatchSpawn( controlPoint )

	entity beamFX = CreateEntity( "info_particle_system" )
	beamFX.kv.cpoint1         = controlPoint.GetTargetName()
	beamFX.SetValueForEffectNameKey( CAMERA_HIT_FX )
	beamFX.kv.start_active    = 1
	beamFX.kv.VisibilityFlags = ENTITY_VISIBLE_TO_OWNER | ENTITY_VISIBLE_TO_FRIENDLY
	beamFX.SetOrigin( contactPos )
	SetTeam( beamFX, camera.GetTeam() )
	DispatchSpawn( beamFX )

	entity beamEnemyFX = CreateEntity( "info_particle_system" )
	beamEnemyFX.kv.cpoint1         = controlPoint.GetTargetName()
	beamEnemyFX.SetValueForEffectNameKey( CAMERA_HIT_ENEMY_FX )
	beamEnemyFX.kv.start_active    = 1
	beamEnemyFX.kv.VisibilityFlags = ENTITY_VISIBLE_TO_ENEMY
	beamEnemyFX.SetOrigin( contactPos )
	SetTeam( beamEnemyFX, camera.GetTeam() )
	DispatchSpawn( beamEnemyFX )

	OnThreadEnd(
		function () : ( beamFX, beamEnemyFX, controlPoint )
		{
			if ( IsValid( beamFX ) )
				beamFX.Destroy()

			if ( IsValid( beamEnemyFX ) )
				beamEnemyFX.Destroy()

			if ( IsValid( controlPoint ) )
				controlPoint.Destroy()
		}
	)

	wait 0.3
}

                               
void function Crypto_TryAutoEnterDroneView( entity player, entity weapon )
{
	if ( weapon.HasMod( "crypto_drone_access" ) && PlayerCanUseCamera( player, true ) )
		thread SwapToCameraView_Thread( player, player.p.cryptoActiveCamera )
}

void function Crypto_TryAddExitViewCommand( entity player )
{
	EndSignal( player, "OnDeath" )

	while ( player.IsInputCommandHeld( IN_OFFHAND1 ) )
		WaitFrame()

	AddButtonPressedPlayerInputCallback( player, IN_OFFHAND1, Drone_ExitView )
}
      

void function SwapToCameraView_Thread( entity owner, entity activeCamera )
{
	EndSignal( owner, "OnDestroy", "OnDeath", "StartPhaseShift", "BleedOut_OnStartDying" )
	EndSignal( activeCamera, "OnDestroy", "OnDeath" )

	if( isFreefallEnabled() )
		EndSignal( owner, "PlayerSkydiveFromCurrentPosition" )
	                     
		// if ( owner.IsDrivingVehicle() )
			// return

		// EndSignal( owner, SIG_VEHICLE_EMBARK_BEGIN )
       

	                
		// if ( Crafting_IsEnabled() )
		// {
			// if ( Crafting_IsPlayerAtWorkbench( owner ) )
				// return

			// EndSignal( owner, "CraftingPlayerAttaching" )
		// }
       

	                               
		Crypto_TryDestroyDroneProjectile( activeCamera )
       

	owner.e.originalLocalAngles = owner.GetAngles()

	StatusEffect_AddEndless( owner, eStatusEffect.camera_view, 0.5 )
	owner.ContextAction_SetInVehicle()
	AddCinematicFlag( owner, CE_FLAG_HIDE_MAIN_HUD_INSTANT )
                                 

		// if ( !( owner in file.dummyPlayerProps ) )
		// {
			// entity minimapObj = CreatePropScript( $"mdl/dev/empty_model.rmdl", owner.GetOrigin() )
			// SetTargetName( minimapObj, "player_dummy" )
			// minimapObj.Minimap_SetCustomState( eMinimapObject_prop_script.PLAYER_DUMMY )
			// minimapObj.Minimap_SetAlignUpright( false )
			// minimapObj.Minimap_SetClampToEdge( true )
			// minimapObj.DisableHibernation()
			// minimapObj.SetParent( owner )
			// minimapObj.SetLocalAngles( <-90, 0, 0> )
			// minimapObj.Minimap_SetZOrder( MINIMAP_Z_OBJECT - 1 )

			// file.dummyPlayerProps[ owner ] <- minimapObj
		// }
       
	activeCamera.VehicleSetDriver( owner )

	SetCameraAngles( activeCamera, activeCamera.e.originalLocalAngles )
	activeCamera.kv.VisibilityFlags = ENTITY_VISIBLE_TO_FRIENDLY | ENTITY_VISIBLE_TO_ENEMY

	foreach ( fx in activeCamera.e.fxArray )
	{
		if ( IsValid( fx ) )
			fx.kv.VisibilityFlags = ENTITY_VISIBLE_TO_FRIENDLY | ENTITY_VISIBLE_TO_ENEMY
	}
	foreach ( fx in activeCamera.e.friendlyFxArray )
	{
		if ( IsValid( fx ) )
			fx.kv.VisibilityFlags = ENTITY_VISIBLE_TO_FRIENDLY
	}
	foreach ( fx in activeCamera.e.enemyFxArray )
	{
		if ( IsValid( fx ) )
			fx.kv.VisibilityFlags = ENTITY_VISIBLE_TO_ENEMY
	}

	if ( !DroneHasActiveAnimation( activeCamera ) )
		activeCamera.Anim_PlayOnly( "drone_active_idle" )

	StopSoundOnEntity( activeCamera, DRONE_PROPULSION_3P_UPGRADE ) //3P Everyone Sound (Upgraded)
	StopSoundOnEntity( activeCamera, DRONE_PROPULSION_3P ) //3P Everyone Sound

	EmitSoundOnEntityExceptToPlayer( activeCamera, owner, DRONE_PROPULSION_3P ) //3P Only Sound
	EmitSoundOnEntityOnlyToPlayer( activeCamera, owner, DRONE_PROPULSION_1P ) //1P Only Sound

	if ( activeCamera.e.scanSoundPlaying )
	{
		StopSoundOnEntity( activeCamera, DRONE_SCANNING_3P )
		EmitSoundOnEntityExceptToPlayer( activeCamera, owner, DRONE_SCANNING_3P )
	}

		// threading off adding the below callback for the Crypto update here to AVOID the behavior below
		// won't duplicate this for the current functionality yet, since it's now seen as QOL.
		thread Crypto_TryAddExitViewCommand( owner )

	AddButtonPressedPlayerInputCallback( owner, IN_ATTACK, Drone_TryEMP )
	AddButtonPressedPlayerInputCallback( owner, IN_OFFHAND4, Drone_TryEMP )
	AddButtonPressedPlayerInputCallback( owner, IN_USE, Drone_AttemptUse )
	AddButtonPressedPlayerInputCallback( owner, IN_USE_LONG, Drone_AttemptUseLong )

	Set3pHealRopeVisibility( owner )

	EndSignal( owner, "ExitCameraView" )

	entity visorFX = StartParticleEffectOnEntity_ReturnEntity( owner, GetParticleSystemIndex( VISOR_FX_3P ), FX_PATTACH_POINT_FOLLOW, owner.LookupAttachment( "HEADFOCUS" ) )
	visorFX.SetStopType( "destroyImmediately" )

	bool wasAlreadyInShoulderMode = owner.IsThirdPersonShoulderModeOn()
	if ( wasAlreadyInShoulderMode )
		owner.SetThirdPersonShoulderModeOff()

	OnThreadEnd(
		function() : ( owner, activeCamera, visorFX, wasAlreadyInShoulderMode )
		{
			owner.Signal( "OnContinousUseStopped" )
			thread TransitionOutOfCamera( owner, activeCamera, visorFX, wasAlreadyInShoulderMode )
			SetForceExitDroneView(false)
		}
	)

	entity latestDeployedWeapon      = owner.GetLatestPrimaryWeaponForIndexZeroOrOne( eActiveInventorySlot.mainHand )
	array<int> primarySlots          = [ WEAPON_INVENTORY_SLOT_PRIMARY_0, WEAPON_INVENTORY_SLOT_PRIMARY_1 ]
	table<int, entity> slotWeaponMap = {}
	if ( AutoReloadWhileInCryptoDroneCameraView() )
	{
		foreach ( int slot in primarySlots )
		{
			slotWeaponMap[slot] <- owner.GetNormalWeapon( slot )
		}
		primarySlots.sort( int function( int slotA, int slotB ) : ( slotWeaponMap, latestDeployedWeapon ) {
			entity weaponA = slotWeaponMap[slotA]
			entity weaponB = slotWeaponMap[slotB]
			if ( weaponA == latestDeployedWeapon && weaponB != latestDeployedWeapon )
				return -1
			else if ( weaponB == latestDeployedWeapon && weaponA != latestDeployedWeapon )
				return 1

			return 0
		} )
	}
	entity currentlyReloadingWeapon = null
	float reloadEndTime = -1.0

	AddEntityCallback_OnDamaged( owner, OnPlayerTookDamage ) //(mk): adding damage callback here..
	#if DEVELOPER 
		//printt( "Crypto AddEntityCallback_OnDamaged:", owner )
	#endif 

	while( true )
	{
                                 
                                                                                                 
        

		if ( AutoReloadWhileInCryptoDroneCameraView() )
		{
			if ( !IsValid( currentlyReloadingWeapon ) )
			{
				foreach ( int slot in primarySlots )
				{
					entity slotWeapon = slotWeaponMap[slot]

					if ( !IsValid( slotWeapon ) )
						continue

					if ( !slotWeapon.UsesClipsForAmmo() )
						continue

					if ( slotWeapon.GetWeaponPrimaryClipCount() >= slotWeapon.GetWeaponPrimaryClipCountMax() )
						continue

					int ammoSource    = slotWeapon.GetActiveAmmoSource()
					int availableAmmo = slotWeapon.GetWeaponPrimaryAmmoCount( ammoSource )
					if ( availableAmmo <= 0 )
						continue

					currentlyReloadingWeapon = slotWeapon
					reloadEndTime            = Time() + GetWeaponReloadTime( slotWeapon, slotWeapon.GetWeaponPrimaryClipCount() )
					break
				}
			}

			if ( IsValid( currentlyReloadingWeapon ) )
			{
				if ( Time() > reloadEndTime )
				{
					int currClip          = currentlyReloadingWeapon.GetWeaponPrimaryClipCount()
					int maxClip           = currentlyReloadingWeapon.GetWeaponPrimaryClipCountMax()
					int ammoSource        = currentlyReloadingWeapon.GetActiveAmmoSource()
					int currAvailableAmmo = currentlyReloadingWeapon.GetWeaponPrimaryAmmoCount( ammoSource )
					int roomLeft          = maxClip - currClip
					int ammoTaken         = minint( currAvailableAmmo, roomLeft )
					int newClip           = currClip + ammoTaken
					int newAvailableAmmo  = currAvailableAmmo - ammoTaken

					if ( InfiniteAmmoEnabled() ) //GetInfiniteAmmo( currentlyReloadingWeapon ) )
					{
						currentlyReloadingWeapon.SetWeaponPrimaryClipCount( maxClip )
						currentlyReloadingWeapon.SetWeaponPrimaryAmmoCount( AMMOSOURCE_STOCKPILE,  currentlyReloadingWeapon.GetWeaponPrimaryAmmoCountMax( AMMOSOURCE_STOCKPILE ) )
					}
					else
					{
						currentlyReloadingWeapon.SetWeaponPrimaryClipCount( newClip )
						currentlyReloadingWeapon.SetWeaponPrimaryAmmoCount( ammoSource, newAvailableAmmo )
					}

					EmitSoundOnEntityOnlyToPlayer( activeCamera, owner, "survival_loot_attach_extended_ammo" )
					Remote_CallFunction_Replay( owner, "ServerToClient_CryptoDroneAutoReloadDone", currentlyReloadingWeapon )

					currentlyReloadingWeapon = null
				}
			}
			wait 0.4
		}
		else
		{
			wait 1.0
		}

		// if ( GetCurrentPlaylistVarBool( "crypto_drone_weapon_switch", true ) )
		// {
			// entity heldGadget    = owner.GetNormalWeapon( WEAPON_INVENTORY_SLOT_GADGET )
			// entity currentWeapon = owner.GetActiveWeapon( eActiveInventorySlot.mainHand )
			// if ( currentWeapon == heldGadget )
			// {
				// if ( IsValid( latestDeployedWeapon ) )
					// owner.SetActiveWeaponByName( eActiveInventorySlot.mainHand, latestDeployedWeapon.GetWeaponClassName() )
				// else
					// owner.SetActiveWeaponBySlot( eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_2 )
			// }
		// }

		if ( file.ForceExitDroneView )
		{
			Drone_ExitView( owner )
		}


	}
}

void function Set3pDroneVisibility( entity ent, bool visible )
{
	asset modelname = ent.GetModelName()

	int droneIdx = ent.FindBodygroup( "drone" )
	if ( droneIdx == -1 )
		return

	int visibleIdx = 0
	if ( !visible )
		visibleIdx = 1

	ent.SetBodygroupModelByIndex( droneIdx, visibleIdx )
}

int function GetNumberOfEnemySquadsInDroneRange( entity owner )
{
	array<entity> players = GetPlayerArrayEx( "any", TEAM_ANY, TEAM_ANY, owner.GetOrigin(), MAX_FLIGHT_RANGE )

	int ownerTeam = owner.GetTeam()
	IntSet nearbyEnemyTeams
	foreach ( player in players )
	{
		if ( !player.DoesShareRealms( owner ) )
			continue

		if ( player == owner )
			continue

		// Defensive fix for R5DEV-177090 -- don't have exact repro, but this should be good regardless
		if ( player.IsObserver() )
			continue

		int playerTeam = player.GetTeam()
		if ( IsFriendlyTeam( ownerTeam, playerTeam ) )
			continue

		if ( playerTeam == 0 || playerTeam == 1 )
			continue

		nearbyEnemyTeams[playerTeam] <- IN_SET
	}

	return nearbyEnemyTeams.len()
}

void function TransitionOutOfCamera( entity owner, entity activeCamera, entity visorFX, bool wasAlreadyInShoulderMode )
{
	if ( IsValid( owner ) )
	{
		RemoveButtonPressedPlayerInputCallback( owner, IN_OFFHAND1, Drone_ExitView )
		RemoveButtonPressedPlayerInputCallback( owner, IN_ATTACK, Drone_TryEMP )
		RemoveButtonPressedPlayerInputCallback( owner, IN_OFFHAND4, Drone_TryEMP )
		RemoveButtonPressedPlayerInputCallback( owner, IN_USE, Drone_AttemptUse )
		RemoveButtonPressedPlayerInputCallback( owner, IN_USE_LONG, Drone_AttemptUseLong )

		if ( !(owner.IsPhaseShifted() || !owner.IsOnGround()) )
		{
			float fadeInTime = 0.2
			ScreenFade( owner, 255, 255, 255, 255, fadeInTime, 0.2, (FFADE_OUT | FFADE_PURGE) )
			wait fadeInTime
		}
		Set1pHealRopeVisibility( owner )
		if ( IsValid( owner ) )
			owner.EnableMantle()
	}

	if ( IsValid( visorFX ) )
	{
		visorFX.kv.VisibilityFlags = ENTITY_VISIBLE_TO_NOBODY
		EffectStop( visorFX )
		visorFX.Destroy()
	}

	if ( IsValid( activeCamera ) )
	{
		activeCamera.kv.VisibilityFlags = ENTITY_VISIBLE_TO_EVERYONE
		foreach ( fx in activeCamera.e.fxArray )
		{
			if ( IsValid( fx ) )
				fx.kv.VisibilityFlags = ENTITY_VISIBLE_TO_EVERYONE
		}
		foreach ( fx in activeCamera.e.friendlyFxArray )
		{
			if ( IsValid( fx ) )
				fx.kv.VisibilityFlags = ENTITY_VISIBLE_TO_FRIENDLY | ENTITY_VISIBLE_TO_OWNER
		}
		foreach ( fx in activeCamera.e.enemyFxArray )
		{
			if ( IsValid( fx ) )
				fx.kv.VisibilityFlags = ENTITY_VISIBLE_TO_ENEMY
		}
		if ( !DroneHasActiveAnimation( activeCamera ) )
			activeCamera.Anim_PlayOnly( "drone_active_twitch" )
		activeCamera.e.originalLocalAngles = activeCamera.GetAngles()
		StopSoundOnEntity( activeCamera, DRONE_PROPULSION_1P_UPGRADE ) //1P Only Sound (Upgraded)
		StopSoundOnEntity( activeCamera, DRONE_PROPULSION_3P_UPGRADE ) //3P Only Sound (Upgraded)
		StopSoundOnEntity( activeCamera, DRONE_PROPULSION_1P ) //1P Only Sound
		StopSoundOnEntity( activeCamera, DRONE_PROPULSION_3P ) //3P Only Sound

		EmitSoundOnEntity( activeCamera, DRONE_PROPULSION_3P ) //3P Everyone Sound

		if ( activeCamera.e.scanSoundPlaying )
		{
			StopSoundOnEntity( activeCamera, DRONE_SCANNING_3P )
			EmitSoundOnEntity( activeCamera, DRONE_SCANNING_3P )
		}

		if ( IsValid( owner ) )
		{
			activeCamera.VehicleRemoveDriver()
			owner.Anim_Stop()
		}
	}

	if ( IsValid( owner ) )
	{
		ScreenFade( owner, 255, 255, 255, 255, 0.1, 0.1, (FFADE_IN | FFADE_PURGE) )
		EmitSoundOnEntityOnlyToPlayer( owner, owner, TRANSITION_OUT_CAMERA_1P )
		EmitSoundOnEntityExceptToPlayer( owner, owner, TRANSITION_OUT_CAMERA_3P )
		owner.AnimViewEntity_SetLerpOutTime( 0.3 )
		owner.AnimViewEntity_Clear()
		//MovementEnable( owner )
		owner.EnablePrediction()
		StatusEffect_StopAllOfType( owner, eStatusEffect.camera_view )
		RemoveCinematicFlag( owner, CE_FLAG_HIDE_MAIN_HUD_INSTANT )
                                  
                                                           
        

		StatusEffect_AddTimed( owner, eStatusEffect.script_helper, 1.0, 0.25, 0.25 ) //Need something to prevent re-entering the camera when you leave it.
		owner.ContextAction_ClearInVehicle()
		if ( GetCurrentPlaylistVarBool( "enable_apex_screens", true ) )
			Remote_CallFunction_Replay( owner, "ServerToClient_ApexScreenRefreshAll" )
		owner.SetPlayerNetInt( "cameraNearbyEnemySquads", 0 )

		if ( IsValid( activeCamera ) )
			PlayBattleChatterLineToSpeakerAndTeamWithDebounceTime( owner, "bc_droneViewEnd", 30.0, 60.0 )

		if ( wasAlreadyInShoulderMode )
			owner.SetThirdPersonShoulderModeOn()
	}
}

                    
void function CryptoDrone_TryExitCameraSpeedBoost( entity player )
{
	if ( !IsValid( player ) )
		return

	if ( !player.IsPlayer() || !IsAlive( player ) || Bleedout_IsBleedingOut( player ) )
		return

	if( !player.HasPassive( ePassives.PAS_CRYPTO ) )
		return

	if( !(player in file.hasDroneExitSpeedBoost) )
		return

	if( !file.hasDroneExitSpeedBoost[player] )
		return

	if( !( player in file.playerStatusEffects) )
	{
		SpeedBoostStatusEffectIndexes statusEffectIndexes
		file.playerStatusEffects[ player ] <- statusEffectIndexes
	}

	// no need to check both status effect, since he should never have one without the other.
	if ( StatusEffect_GetTimeRemaining( player, eStatusEffect.speed_boost ) > 0 )
	{
		StatusEffect_SetDuration( player, file.playerStatusEffects[ player ].speedBoostVisualsID, UPGRADE_DRONE_EXIT_SPEED_DURATION )
		StatusEffect_SetDuration( player, file.playerStatusEffects[ player ].speedBoostID, UPGRADE_DRONE_EXIT_SPEED_DURATION )
	}
	else
	{
		file.playerStatusEffects[ player ].speedBoostVisualsID = StatusEffect_AddTimed( player, eStatusEffect.adrenaline_visuals, 1, UPGRADE_DRONE_EXIT_SPEED_DURATION, UPGRADE_DRONE_EXIT_SPEED_DURATION )
		file.playerStatusEffects[ player ].speedBoostID = StatusEffect_AddTimed( player, eStatusEffect.speed_boost, UPGRADE_DRONE_EXIT_SPEED_INCREASE, UPGRADE_DRONE_EXIT_SPEED_DURATION, 0.25 )
	}

	file.hasDroneExitSpeedBoost[player] = false

}

void function CryptoDrone_TrySetAllowExitSpeedBoost( entity player )
{
	if( !player.HasPassive( ePassives.PAS_CRYPTO ) )
		return

	file.hasDroneExitSpeedBoost[player] <- true

	if ( !(StatusEffect_GetSeverity( player, eStatusEffect.camera_view )  > 0))
		CryptoDrone_TryExitCameraSpeedBoost( player )
}

void function OnCameraDamaged( entity camera, var damageInfo )
{
	entity attacker    = DamageInfo_GetAttacker( damageInfo )
	entity inflictor   = DamageInfo_GetInflictor( damageInfo )
	int damageType     = DamageInfo_GetDamageType( damageInfo )
	int damageSourceId = DamageInfo_GetDamageSourceIdentifier( damageInfo )

	bool isFriendly = false

	if ( IsValid( attacker ) && IsValid( inflictor ) )
	{
		// defensive fix dklein: in the case of Caustic barrels, the attacker is entity(0: worldspawn [0])
		if ( IsFriendlyTeam( attacker.GetTeam(), camera.GetTeam() ) || IsFriendlyTeam( inflictor.GetTeam(), camera.GetTeam() ) )
		{
			DamageInfo_SetDamage( damageInfo, 0 )
			isFriendly = true
		}
		else if ( damageSourceId == eDamageSourceId.mp_weapon_grenade_emp )
		{
			// fix for R5DEV-132076
			if ( damageType != DMG_BLAST )
				DamageInfo_ScaleDamage( damageInfo, 0.25 )
		}
		else if ( damageSourceId == eDamageSourceId.burn )
		{
			// fix for R5DEV-132076
			EmitSoundOnEntity( camera, "flesh_thermiteburn_1p_vs_3p" )
		}
	}
}

void function OnCameraPostDamaged( entity camera, var damageInfo )
{
	entity attacker    = DamageInfo_GetAttacker( damageInfo )
	entity inflictor   = DamageInfo_GetInflictor( damageInfo )
	entity weapon      = DamageInfo_GetWeapon ( damageInfo )
	int damageType     = DamageInfo_GetDamageType( damageInfo )
	int damageSourceId = DamageInfo_GetDamageSourceIdentifier( damageInfo )

	if ( DamageInfo_GetDamage( damageInfo ) <= 0 )
		return

	vector contactPos = DamageInfo_GetDamagePosition( damageInfo )
	float posDelta    = Distance( contactPos, camera.GetOrigin() )
	if ( posDelta > 50 )
		contactPos = camera.GetOrigin()

	EmitSoundAtPosition( TEAM_UNASSIGNED, contactPos, "Crypto_Drone_FireDamage_1p", camera )

	thread Camera_ShieldHitFX( camera, contactPos )

	if ( IsAlive( attacker ) && attacker.IsPlayer() )
		attacker.NotifyDidDamage( camera, DamageInfo_GetHitBox( damageInfo ),
			DamageInfo_GetDamagePosition( damageInfo ),
			DamageInfo_GetCustomDamageType( damageInfo ),
			DamageInfo_GetDamage( damageInfo ),
			DamageInfo_GetDamageFlags( damageInfo ) | DF_NO_HITBEEP,
			DamageInfo_GetHitGroup( damageInfo ),
			DamageInfo_GetWeapon( damageInfo ),
			DamageInfo_GetDistFromAttackOrigin( damageInfo ) )
}

void function OnCameraDestroyed( entity cameraProxy )
{
	Assert( IsValid( cameraProxy ) || IsInvalidButMemberVarsStillValid( cameraProxy ) )

	if ( cameraProxy.GetHealth() > 0 && !cameraProxy.IsDissolving() ) //Dissolving means it was destroyed by an EMP
		return

	vector cameraPosition = cameraProxy.GetOrigin()
	PlayFX( CAMERA_EXPLOSION_FX, cameraPosition )
	EmitSoundAtPosition( TEAM_UNASSIGNED, cameraPosition, DRONE_EXPLOSION_3P, cameraProxy )

	entity owner = cameraProxy.GetOwner()
	if ( IsValid( owner ) )
	{
		owner.p.cryptoActiveCamera = null
		entity offhandWeapon = owner.GetOffhandWeapon( OFFHAND_LEFT )

		if ( IsValid( offhandWeapon ) )
			offhandWeapon.SetWeaponPrimaryClipCount( 0 )

		if ( GetCurrentPlaylistVarBool( "enable_apex_screens", true ) )
			Remote_CallFunction_Replay( owner, "ServerToClient_ApexScreenRefreshAll" )

		// cancel the swap since the offhand is now disabled
		// entity selectedOffhand = owner.GetSelectedOffhand( OFFHAND_RIGHT )
		// if( IsValid( selectedOffhand ) )
		// {
			// if ( selectedOffhand == offhandWeapon )
				// owner.CancelOffhandWeapon( selectedOffhand.GetInventoryIndex() )
		// }
	}
}

void function OnCameraKilled( entity cameraProxy, var damageInfo )
{
	Assert( IsValid( cameraProxy ) || IsInvalidButMemberVarsStillValid( cameraProxy ) )

	if ( cameraProxy.GetHealth() > 0 && !cameraProxy.IsDissolving() ) //Dissolving means it was destroyed by an EMP
		return

	entity owner = cameraProxy.GetOwner()
	if ( IsValid( owner ) )
	{
		entity attacker = DamageInfo_GetAttacker( damageInfo )

		if( IsValid( attacker ) && attacker.IsPlayer() )
		{
			PlayBattleChatterLineToTeamButNotSpeaker( owner, "bc_droneDestroyed" )
			thread PlayBattleChatterLineDelayedToPlayer( owner, "bc_droneDestroyed", 0.4 )
		}
		else
		{
			PlayBattleChatterLineToTeamButNotSpeaker( owner, "bc_droneDestroyed_Env" )
			thread PlayBattleChatterLineDelayedToPlayer( owner, "bc_droneDestroyed_Env", 0.4 )
		}
	}
}

void function SetCameraAngles( entity camera, vector localAngles )
{
	camera.SetAbsAnglesSmooth( localAngles )
	camera.Vehicle_SetEyeAngles( localAngles )
}
#endif //SERVER

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

	player.Signal( "StopUpdatingCameraRui" )

	if ( IsValid( file.cryptoAnimatedTacticalRui ) )
	{
		RuiSetFloat( file.cryptoAnimatedTacticalRui, "loopStartTime", Time() )
		RuiSetFloat( file.cryptoAnimatedTacticalRui, "recallTransitionEndTime", Time() + 0.66 )
		RuiSetFloat( file.cryptoAnimatedTacticalRui, "distanceToCrypto", 0 )
	}
}

void function AddCallback_OnEnterDroneView( void functionref() cb )
{
	Assert( !file.onEnterDroneViewCallbacks.contains( cb ) )
	file.onEnterDroneViewCallbacks.append( cb )
}

void function RemoveCallback_OnEnterDroneView( void functionref() cb )
{
	Assert( file.onEnterDroneViewCallbacks.contains( cb ) )
	file.onEnterDroneViewCallbacks.removebyvalue( cb )
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
	
	float preventInfiniteLoop = Time()
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
		
		if ( Time() - preventInfiniteLoop > 3 ) //(mk): for if all entities get destroyed at a bad time (for say at the execution of this loop)
		{
			Warning("infinite loop prevented in " + FUNC_NAME() + "()  -- file: " + FILE_NAME() )
			return
		}
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

	// ClGameState_SetHasScreenBorder( false )

	                               
		Minimap_SetSizeScale( 1.0 )
		// Minimap_SetMasterTint( < 1.0, 1.0, 1.0 > )
		// Minimap_SetOffset( 0.0, 0.0 )
		// if ( GetCompassRui() != null )
			// RuiSetBool( GetCompassRui(), "isVisible", true )

		entity drone = CryptoDrone_GetPlayerDrone( player )
		if ( IsValid( drone ) )
			thread CryptoDrone_CreateHUDMarker( drone )

		//if ( EffectDoesExist( file.droneRangeVFX ) )
		//	EffectStop( file.droneRangeVFX, false, true )

		//int rangeVFX  = StartParticleEffectOnEntity( player, GetParticleSystemIndex( CRYPTO_DRONE_RANGE_NO_INTRO ), FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
		//EffectSetControlPointVector( rangeVFX, 1, <file.neurolinkRange, 0, 0> )
		//file.droneRangeVFX = rangeVFX

		if ( file.fakePlayerMarkerRui != null )
		{
			Minimap_CommonCleanup( file.fakePlayerMarkerRui )
			file.fakePlayerMarkerRui = null
		}
		// Minimap_StopTrackVehicleData()
       

	///Minimap_SetVisiblityCone( false )

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


//Should optimize to use the same thing as weapon scopes instead of doing a trace.
void function TempUpdateRuiDistance( entity player )
{
	EndSignal( player,  "OnDestroy", "StopUpdatingCameraRui" )

	entity activeCamera
	while( !IsValid( activeCamera ) )
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

	EndSignal( activeCamera, "OnDestroy" )
	OnThreadEnd(
		function() : ( activeCamera )
		{
			if ( EffectDoesExist( activeCamera.e.cameraMaxRangeFXHandle ) )
				EffectStop( activeCamera.e.cameraMaxRangeFXHandle, true, false )
		}
	)
	bool outOfRange          = false
	bool inWarningRange      = false
	bool useInputWasDownLast = player.IsUserCommandButtonHeld( IN_USE )
	while( true )
	{
		bool useInputIsDown  = player.IsUserCommandButtonHeld( IN_USE )
		bool useInputPressed = (useInputIsDown && !useInputWasDownLast)
		useInputWasDownLast = useInputIsDown

		bool flightModeInputIsHeld = player.IsUserCommandButtonHeld( IN_ZOOM | IN_ZOOM_TOGGLE )

		float distanceToCrypto = Distance( player.GetOrigin(), activeCamera.GetOrigin() )
		inWarningRange = distanceToCrypto > WARNING_RANGE || activeCamera.GetOrigin().z > file.droneMaxZ - 400.0
		if ( activeCamera.e.cameraMaxRangeFXHandle > -1 && (!inWarningRange || !IsValid( file.cameraRui )) ) //If the camera is not in warning range yet
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
			TraceResults trace  = TraceLineHighDetail( activeCamera.GetOrigin(), activeCamera.GetOrigin() + activeCamera.GetForwardVector() * 300, [activeCamera], TRACE_MASK_SHOT | TRACE_MASK_BLOCKLOS, TRACE_COLLISION_GROUP_NONE )
			if ( IsValid( trace.hitEnt ) )
			{
				entity isLootBin = GetLootBinForHitEnt( trace.hitEnt )
				entity isAirdrop = GetAirdropForHitEnt( trace.hitEnt )
				entity parentEnt = trace.hitEnt.GetParent()
				if ( IsDoor( trace.hitEnt ) && DroneCanOpenDoor( activeCamera,  trace.hitEnt ) )
				{
					targetString = "#CAMERA_INTERACT_DOOR"
				}
				else if ( IsValid( parentEnt ) && IsDoor( parentEnt ) && DroneCanOpenDoor( activeCamera, parentEnt ) )
				{
					targetString = "#CAMERA_INTERACT_DOOR"
				}
				//fixme. Cafe 
				// // else if ( trace.hitEnt.GetTargetName() == PASSIVE_REINFORCE_REBUILT_DOOR_SCRIPT_NAME && IsReinforced( trace.hitEnt ) && IsFriendlyTeam( activeCamera.GetTeam(), trace.hitEnt.GetTeam() ) )
				// // {
					// // targetString = "#ABL_REINFORCE_BREAK_REBUILT"
				// // }
              
				// else if ( (IsVaultPanel( trace.hitEnt ) || IsVaultPanel( parentEnt )) )
				// {
					// UniqueVaultData vaultData = GetUniqueVaultData( trace.hitEnt )
					// if ( HasVaultKey( player ) )
						// targetString = vaultData.hintVaultKeyUse
				// }
                    
				else if ( IsValid( isLootBin ) && !LootBin_IsBusy( isLootBin ) && !GradeFlagsHas( isLootBin, eGradeFlags.IS_OPEN ) )
				{
					targetString = "#CAMERA_INTERACT_LOOT_BIN"
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
				// // else if ( IsBunkerLoreScreen( trace.hitEnt ) && !IsBunkerLoreScreenHacked( trace.hitEnt, player ) )
				// // {
					// // targetString = "#CAMERA_HOLD_INTERACT_LORE_MESSAGE"
				// // }
				// else if ( SurveyBeacon_IsSurveyBeacon( trace.hitEnt ) || ( IsValid( parentEnt ) && SurveyBeacon_IsSurveyBeacon( parentEnt ) ) )
				// {
                       
					// entity surveyBeacon = SurveyBeacon_IsSurveyBeacon( trace.hitEnt ) ? trace.hitEnt : parentEnt
					// if( ControlPanel_CanUseFunction( player, surveyBeacon, 0 ) )
					// {
						// if( SurveyBeacon_CanUseFunction( player, surveyBeacon, 0 ) && SurveyBeacon_CanActivate( player, surveyBeacon ) )
						// {
							// targetString = "#CAMERA_INTERACT_SURVEY_BEACON"
						// }
						// else
						// {
							// string scriptName = surveyBeacon.GetScriptName()
							// if( scriptName == ENEMY_SURVEY_BEACON_SCRIPTNAME )
							// {
								// targetString = "#SURVEY_ENEMY_ALREADY_ACTIVE"
							// }
							// else
							// {
								// targetString = "#CONTROLLER_SURVEY_TEAM_MESSAGE"
							// }
						// }
					// }
				// }

				if ( (targetString != "") && useInputPressed )
					RuiSetGameTime( file.cameraRui, "playerAttemptedUse", Time() )
			}

			RuiSetString( file.cameraRui, "interactHint", targetString )
			RuiSetFloat( file.cameraRui, "distanceToCrypto", distanceToCrypto )
			RuiSetFloat( file.cameraRui, "maxFlightRange", MAX_FLIGHT_RANGE )
			RuiSetBool( file.cameraRui, "flightModeInputIsHeld", flightModeInputIsHeld )
			RuiSetFloat3( file.cameraRui, "cameraOrigin", activeCamera.GetOrigin() )

			vector cameraVel   = activeCamera.GetVehicleVelocity()
			vector cameraVel2D = < cameraVel.x, cameraVel.y, 0.0 >
			float cameraSpeed  = Length( cameraVel2D ) / 350.0
			RuiSetFloat( file.cameraRui, "velocityScale", cameraSpeed )
		}
		if ( IsValid( file.cryptoAnimatedTacticalRui ) )
		{
			RuiSetFloat( file.cryptoAnimatedTacticalRui, "distanceToCrypto", distanceToCrypto )
		}
		WaitFrame()
	}
}
#endif //CLIENT

bool function PlayerCanUseCamera( entity ownerPlayer, bool needsValidCamera )
{
	if ( ownerPlayer.IsTraversing() )
		return false

	if ( ownerPlayer.ContextAction_IsActive() ) //Stops every single context action from letting decoy happen, including rodeo, melee, embarking etc
		return false

	if ( ownerPlayer.IsPhaseShifted() )
		return false

	if( Bleedout_IsBleedingOut( ownerPlayer ) )
		return false

	if ( needsValidCamera && !IsValid( ownerPlayer.p.cryptoActiveCamera ) )
		return false

	                     
		// if ( ownerPlayer.IsDrivingVehicle() )
			// return false
       

	// array <entity> activeWeapons = ownerPlayer.GetAllActiveWeapons()
	// if ( activeWeapons.len() > 1 )
	// {
		// entity offhandWeapon = activeWeapons[1]

		// if ( IsValid( offhandWeapon ) && offhandWeapon.GetWeaponClassName() == HOLO_PROJECTOR_WEAPON_NAME )
		// {
			// return false
		// }
	// }

	return true
}

#if SERVER
void function CryptoDroneHideCamera( entity player )
{
	Set3pDroneVisibility( player, false )
}

void function CryptoDroneShowCamera( entity player )
{
	if ( !(StatusEffect_GetSeverity( player, eStatusEffect.crypto_has_camera )  > 0) )
		Set3pDroneVisibility( player, true )
}
#endif

/*
███╗   ██╗███████╗██╗   ██╗██████╗  ██████╗ ██╗     ██╗███╗   ██╗██╗  ██╗
████╗  ██║██╔════╝██║   ██║██╔══██╗██╔═══██╗██║     ██║████╗  ██║██║ ██╔╝
██╔██╗ ██║█████╗  ██║   ██║██████╔╝██║   ██║██║     ██║██╔██╗ ██║█████╔╝
██║╚██╗██║██╔══╝  ██║   ██║██╔══██╗██║   ██║██║     ██║██║╚██╗██║██╔═██╗
██║ ╚████║███████╗╚██████╔╝██║  ██║╚██████╔╝███████╗██║██║ ╚████║██║  ██╗
╚═╝  ╚═══╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝
*/

///////////////////////////////////
////// NEUROLINK FUNCTIONS ////////
///////////////////////////////////

#if SERVER
void function AddNeurolinkDetectionForPropScript( entity propScript )
{
	// propScript.SetVehicleSpottable( true )
}

void function RemoveNeurolinkDetectionForPropScript( entity propScript )
{
	// propScript.SetVehicleSpottable( false )
}

void function AddEMPDamageDevice( entity device )
{
	AddToScriptManagedEntArray( file.empDamageArrayID, device )
}

void function RemoveEMPDamageDevice( entity device )
{
	RemoveFromScriptManagedEntArray( file.empDamageArrayID, device )
}

void function AddEMPDestroyDevice( entity device, int destroyType = eEmpDestroyType.EMP_DESTROY_DISSOLVE )
{
	AddToScriptManagedEntArray( file.empDestroyArrayID, device )

	thread EMP_Destroy( device, destroyType )
}

void function AddEMPDestroyDeviceNoDissolve( entity device )
{
	AddToScriptManagedEntArray( file.empDestroyArrayID, device )
}

void function RemoveEMPDestroyDevice( entity device )
{
	RemoveFromScriptManagedEntArray( file.empDestroyArrayID, device )
}

void function AddEMPDisableDevice( entity device, void functionref( entity ) disableCallback )
{
	AddToScriptManagedEntArray( file.empDisableArrayID, device )
	file.empDeviceDisabledCallbacks[ device ] <- disableCallback
}

void function RemoveEMPDisableDevice( entity device )
{
	RemoveFromScriptManagedEntArray( file.empDisableArrayID, device )
}

void function EMPDeviceDisableCallback( entity device )
{
	Assert( device in file.empDeviceDisabledCallbacks, "Attempted to disable device that isn't registered!" )
	file.empDeviceDisabledCallbacks[ device ]( device )
}

const PLAYER_MINS = <-16, -16, 0>
const PLAYER_MAXS = <16, 16, 80>
void function NeurolinkThink( entity camera, bool attachFx = true )
{
	EndSignal( camera, "OnDestroy", "FinishDroneRecall" )
	entity cameraOwner = camera.GetOwner()
	cameraOwner.EndSignal( "OnDestroy" )

	if ( !(cameraOwner in file.cameraDroneAlertTimes) )
		file.cameraDroneAlertTimes[cameraOwner] <- {}

	array<entity> sonarEnts			//entities that are being tracked by the sonar
	array<entity> HUDWarningEnts	//entities that are given the HUD warning status effect (subset of sonarEnts)

	entity sightBeam
                               
	if( attachFx )
	{
		sightBeam                    = StartParticleEffectOnEntity_ReturnEntity( camera, GetParticleSystemIndex( CRYPTO_DRONE_SIGHTBEAM_FX ), FX_PATTACH_POINT_FOLLOW, camera.LookupAttachment( "EYE_POINT_ROTATED" ) )
		sightBeam.SetOwner( cameraOwner )
		sightBeam.kv.VisibilityFlags = ENTITY_VISIBLE_TO_OWNER
	}
      

	file.cameraSonarTeamID[cameraOwner] <- camera.GetTeam()

	OnThreadEnd(
		function() : ( sonarEnts, camera, cameraOwner, HUDWarningEnts, sightBeam )
		{
			if ( IsValid( sightBeam ) )
				sightBeam.Destroy()

			//check stuff that was previously tracked
			foreach ( sonarEnt in sonarEnts )
			{
				if ( IsValid( sonarEnt ) )
				{
					SonarEnd( sonarEnt, file.cameraSonarTeamID[cameraOwner], cameraOwner )
					if ( sonarEnt in file.cameraDetectedStatusEffects && HUDWarningEnts.contains( sonarEnt ) )
					{
						StatusEffect_Stop( sonarEnt, file.cameraDetectedStatusEffects[sonarEnt].pop() )
					}
				}
			}
		}
	)

	//Here be monsters - script differs look away!
	camera.e.scanSoundPlaying = false
	table<entity, float> lastTimeScannedEntity

	while( true )
	{
		// Team Change occurred, so clean up and start fresh
		if ( file.cameraSonarTeamID[cameraOwner] != camera.GetTeam() )
		{
			//check stuff that was previously tracked
			foreach ( sonarEnt in sonarEnts )
			{
				if ( IsValid( sonarEnt ) )
				{
					SonarEnd( sonarEnt, file.cameraSonarTeamID[cameraOwner], cameraOwner )
					if ( HUDWarningEnts.contains( sonarEnt ) )
						HUDWarningEnts = RemoveEntityFromWarningEntitiesArray( sonarEnt, HUDWarningEnts )
				}
			}

			sonarEnts.clear()
			HUDWarningEnts.clear()

			file.cameraSonarTeamID[cameraOwner] = camera.GetTeam()
		}

		if( IsValid( sightBeam ) )
		{
			if ( IsValid( cameraOwner ) && IsPlayerInCryptoDroneCameraView( cameraOwner ) )
				sightBeam.kv.VisibilityFlags = ENTITY_VISIBLE_TO_NOBODY
			else
				sightBeam.kv.VisibilityFlags = ENTITY_VISIBLE_TO_OWNER
		}

		array<entity> nearbyEntities = []

		//Cafe was here. Retail implementation uses VehicleGetPlayersInViewArray and VehicleGetNpcsInViewArray code functs that we don't have in s3.
		//I suppose that function check for LOS and by min dot, so let's do that.
		float minDot = deg_cos( NEUROLINK_VIEW_MINDOT_BUFFED )

		nearbyEntities.extend( GetPlayerArrayEx( "any", TEAM_ANY, TEAM_ANY, camera.GetOrigin(), GetNeurolinkRange( camera.GetOwner() ) ) )
		nearbyEntities.extend( GetNPCArrayEx( "any", TEAM_ANY, TEAM_ANY, camera.GetOrigin(), GetNeurolinkRange( camera.GetOwner() ) ) )
		nearbyEntities.fastremovebyvalue( cameraOwner )

		for ( int i = nearbyEntities.len() - 1; i >= 0; i-- )
		{
			vector origin = camera.GetOrigin()
			vector fwd    = AnglesToForward( camera.GetAngles() )

			vector entCenter = nearbyEntities[i].GetCenter()
			vector v1        = Normalize( entCenter - origin )
			float dot        = DotProduct2D( fwd, v1 )

			// printt( "checking los for target by cafe", nearbyEntities[i], dot, minDot )

			TraceResults results = TraceLine( origin, entCenter, [ camera ], TRACE_MASK_VISIBLE, TRACE_COLLISION_GROUP_NONE )

			bool shouldremove = results.fraction < 0.99 || dot < minDot || !nearbyEntities[i].DoesShareRealms( cameraOwner )

			if( shouldremove )
				nearbyEntities.remove( i )
		}

		// nearbyEntities.extend( GetScannableObjectsArray( camera, viewMinDot, true ) )

		if ( camera.e.scanSoundPlaying && nearbyEntities.len() == 0 )
		{
			camera.e.scanSoundPlaying = false
			StopSoundOnEntity( camera, DRONE_SCANNING_3P ) //Update to not be heard in 1P
		}
		else if ( !camera.e.scanSoundPlaying && nearbyEntities.len() > 0 && attachFx )
		{
			if ( IsPlayerInCryptoDroneCameraView( cameraOwner ) )
				EmitSoundOnEntityExceptToPlayer( camera, cameraOwner, DRONE_SCANNING_3P )
			else
				EmitSoundOnEntity( camera, DRONE_SCANNING_3P ) //Update to not be heard in 1P
			camera.e.scanSoundPlaying = true
		}

		//CLEAN THIS UP - For loop with index to not use fastremovebyvalue. One iteration probably all that's necessary. //----(mk): DONE
		float now = Time()

		foreach ( nearbyEnt in nearbyEntities )
		{
			if ( !IsValid( nearbyEnt ) )
				continue

			//update the last scanned time and continue.
			if ( sonarEnts.contains( nearbyEnt ) )
			{
				lastTimeScannedEntity[nearbyEnt] <- now
				if ( !(HUDWarningEnts.contains( nearbyEnt )) )
				{
					if ( nearbyEnt.IsPlayer() )
						HUDWarningEnts = AddEntityToWarningEntitiesArray( nearbyEnt, HUDWarningEnts )
				}
				continue
			}

			//otherwise, start the scan on this newly-found nearby entity
			SonarStart( nearbyEnt, nearbyEnt.GetOrigin(), file.cameraSonarTeamID[cameraOwner], cameraOwner )
			
			#if DEVELOPER
				printt("should start sonar" )
			#endif
			
			if ( nearbyEnt.IsPlayer() || nearbyEnt.IsNPC() )
			{
				// StatsHook_DroneEnemiesScanned( nearbyEnt, cameraOwner )

				if ( nearbyEnt in file.cameraDroneAlertTimes[cameraOwner] )
				{
					if ( file.cameraDroneAlertTimes[cameraOwner][nearbyEnt] + 10.0 < Time() )
					{
						EmitDroneAlertSoundForTeam( nearbyEnt, cameraOwner )
						file.cameraDroneAlertTimes[cameraOwner][nearbyEnt] = Time()
					}
				}
				else
				{
					EmitDroneAlertSoundForTeam( nearbyEnt, cameraOwner )
					file.cameraDroneAlertTimes[cameraOwner][nearbyEnt] <- Time()
				}
				lastTimeScannedEntity[nearbyEnt] <- now

				// creating the HUD warning
				if ( nearbyEnt.IsPlayer() )
					HUDWarningEnts = AddEntityToWarningEntitiesArray( nearbyEnt, HUDWarningEnts )
			}
			sonarEnts.append( nearbyEnt )
		}

		//check for all currently-detected entities to see if they need to be removed
		
		//R5RDEV-1
		// foreach ( sonarEnt in sonarEnts )
		// {
			// if ( !IsValid( sonarEnt ) )
			// {
				// sonarEnts.fastremovebyvalue( sonarEnt )
				// continue
			// }

			// if ( nearbyEntities.contains( sonarEnt ) )
			// {
				// bool flagForRemoval = false

				// if( !flagForRemoval )
					// continue
			// }

			// if ( sonarEnt in lastTimeScannedEntity )
			// {
				// float scanDuration = CryptoDrone_GetScanLingerTime( sonarEnt, cameraOwner )
				// bool scanLingerTimeExpired = IsValid( sonarEnt ) ? lastTimeScannedEntity[sonarEnt] + scanDuration < now : true

				// if ( scanLingerTimeExpired && HUDWarningEnts.contains( sonarEnt ) )
					// HUDWarningEnts = RemoveEntityFromWarningEntitiesArray( sonarEnt, HUDWarningEnts )

				// if ( scanLingerTimeExpired )
          
				// {
					// SonarEnd( sonarEnt, file.cameraSonarTeamID[cameraOwner], cameraOwner )
					// sonarEnts.fastremovebyvalue( sonarEnt )
				// }
			// }
		// }
		
		int maxIter = sonarEnts.len() - 1
		
		for( int i = maxIter; i >= 0; i-- )
		{
			entity sonarEnt = sonarEnts[ i ] 
			
			if ( !IsValid( sonarEnt ) )
			{
				sonarEnts.remove( i )
				continue
			}

			if ( nearbyEntities.contains( sonarEnt ) )
			{
				bool flagForRemoval = false

				if( !flagForRemoval )
					continue
			}

			if ( sonarEnt in lastTimeScannedEntity )
			{
				float scanDuration = CryptoDrone_GetScanLingerTime( sonarEnt, cameraOwner )
				bool scanLingerTimeExpired = IsValid( sonarEnt ) ? lastTimeScannedEntity[sonarEnt] + scanDuration < now : true

				if ( scanLingerTimeExpired && HUDWarningEnts.contains( sonarEnt ) )
					HUDWarningEnts = RemoveEntityFromWarningEntitiesArray( sonarEnt, HUDWarningEnts )

				if ( scanLingerTimeExpired )
          
				{
					SonarEnd( sonarEnt, file.cameraSonarTeamID[cameraOwner], cameraOwner )
					sonarEnts.remove( i )
				}
			}
		}

		WaitFrame()
	}
}

void function UpdateNumberOfEnemySquadsInDroneRange_Thread( entity camera )
{
	EndSignal( camera, "OnDestroy", "FinishDroneRecall" )
	entity cameraOwner = camera.GetOwner()
	EndSignal( cameraOwner, "OnDestroy" )

	if ( !IsValid( cameraOwner ) )
		return

	OnThreadEnd( function() : ( cameraOwner ) {
		//print_dev( cameraOwner + " drone recalled/destroyed" )
	} )

	while ( cameraOwner.p.cryptoActiveCamera )
	{
		cameraOwner.SetPlayerNetInt( "cameraNearbyEnemySquads", GetNumberOfEnemySquadsInDroneRange( cameraOwner ) )
		wait 1.0
	}
}
      

array<entity> function AddEntityToWarningEntitiesArray( entity nearbyEnt, array<entity> HUDWarningEnts )
{
	int statusEffectHandle = StatusEffect_AddEndless( nearbyEnt, eStatusEffect.camera_detected, 1.0 )

	if ( !HUDWarningEnts.contains( nearbyEnt ) )
		HUDWarningEnts.append( nearbyEnt )

	if ( nearbyEnt in file.cameraDetectedStatusEffects )
		file.cameraDetectedStatusEffects[nearbyEnt].append( statusEffectHandle )
	else
		file.cameraDetectedStatusEffects[nearbyEnt] <- [statusEffectHandle]

	return HUDWarningEnts
}

array<entity> function RemoveEntityFromWarningEntitiesArray(entity sonarEnt, array<entity> HUDWarningEnts )
{
	StatusEffect_Stop( sonarEnt, file.cameraDetectedStatusEffects[sonarEnt].pop() )

	if ( !( sonarEnt in file.cameraDetectedStatusEffects ) )
		HUDWarningEnts.fastremovebyvalue( sonarEnt )

	return HUDWarningEnts
}

void function EmitDroneAlertSoundForTeam( entity nearbyEnt, entity cameraOwner )
{
	array<entity> players = GetFriendlySquadArrayForPlayer( cameraOwner )

	string alertSound = DRONE_ALERT_1P
	if ( Bleedout_IsBleedingOut( nearbyEnt ) )
		alertSound = DRONE_ALERT_DOWNED_1P

	foreach ( player in players )
		EmitSoundOnEntityOnlyToPlayer( nearbyEnt, player, alertSound )
}

array<entity> function CryptoDrone_GetNearbyTargetsForEMPRange( entity camera )
{
	array<entity> results = GetPlayerArrayEx( "any", TEAM_ANY, TEAM_ANY, camera.GetOrigin(), GetNeurolinkRange( camera.GetOwner() ) )
	results.extend( GetNPCArrayEx( "any", TEAM_ANY, TEAM_ANY, camera.GetOrigin(), GetNeurolinkRange( camera.GetOwner() ) ) )

	// results.extend( GetHoverVehicleArrayEx( camera.GetOrigin(), GetNeurolinkRange( camera.GetOwner() ) ) )
     
	array<int> badList
	foreach ( int index, entity ent in results )
	{
		if 	(
			!ent.DoesShareRealms( camera )
			|| (!IsHumanSized( ent ) && !(ent.IsNPC() && !ent.IsNonCombatAI()) ) //&& !ent.IsPlayerVehicle())
			)
			badList.append( index )
	}

	int badListLen = badList.len()
	for ( int idx = 0; idx < badListLen; ++idx )
	{
		int badIndex = badList[badListLen - 1 - idx]
		results.remove( badIndex )
	}

	return results
}

array<entity> function GetScannableObjectsArray( entity camera, float minDot, bool enemyOnly = false )
{
	vector cameraOrigin            = camera.GetOrigin()
	array<entity> scannableObjects = [] //GetVehicleSpottableEnts( cameraOrigin, GetNeurolinkRange( camera.GetOwner() ), camera, true, minDot ) //fixme Cafe

	// foreach ( entity object in scannableObjects )
	// {
		// if ( EntIsHoverVehicle( object ) )
			// scannableObjects.extend( object.VehicleGetPlayerArray() )
	// }

	if ( enemyOnly )
	{
		array<entity> alliedObjectsToRemove

		foreach ( object in scannableObjects )
		{
			if ( IsFriendlyTeam( object.GetTeam(), camera.GetTeam() ) && !IsCodeDoor( object ) )
				alliedObjectsToRemove.append( object )
		}

		foreach ( removeCandidate in alliedObjectsToRemove )
		{
			scannableObjects.fastremovebyvalue( removeCandidate )
		}
	}

	return scannableObjects
}

array<entity> function GetNearbyEMPDamageDeviceArray( entity camera, float range )
{
	return GetScriptManagedEntArrayWithinCenter( file.empDamageArrayID, TEAM_ANY, camera.GetOrigin(), range )
}

array<entity> function GetNearbyEMPDestroyDeviceArray( entity camera, float range  )
{
	return GetScriptManagedEntArrayWithinCenter( file.empDestroyArrayID, TEAM_ANY, camera.GetOrigin(), range )
}

array<entity> function GetNearbyEMPDisableDeviceArray( entity camera, float range  )
{
	return GetScriptManagedEntArrayWithinCenter( file.empDisableArrayID, TEAM_ANY, camera.GetOrigin(), range )
}

bool function DroneHasActiveAnimation( entity camera )
{
	string currentSequenceName = camera.GetCurrentSequenceName()

	if ( currentSequenceName == "animseq/props/crypto_drone/crypto_drone/drone_EMP.rseq" )
		return true

	if ( currentSequenceName == "animseq/props/crypto_drone/crypto_drone/drone_recall.rseq" )
		return true

	return false
}
#endif // #if SERVER

/*
██╗  ██╗██╗   ██╗██████╗
██║  ██║██║   ██║██╔══██╗
███████║██║   ██║██║  ██║
██╔══██║██║   ██║██║  ██║
██║  ██║╚██████╔╝██████╔╝
╚═╝  ╚═╝ ╚═════╝ ╚═════╝
*/

/////////////////////////////
////// HUD FUNCTIONS ////////
/////////////////////////////

                               
void function CryptoDrone_TestSendPoint_Think( entity player )
{
	EndSignal( player, "OnDestroy", "Crypto_StopSendPointThink" )

	OnThreadEnd(
		function() : ( player )
		{
			entity weapon = player.GetOffhandWeapon( OFFHAND_TACTICAL )
			bool isPredictedOrServer = InPrediction() && IsFirstTimePredicted()
			#if SERVER
				isPredictedOrServer = true
			#endif //SERVER

			if ( isPredictedOrServer )
			{
				if ( IsValid( weapon ) )
					weapon.SetScriptInt0( 0 )
			}
		}
	)

	while ( true )
	{
		//TraceResults tr = TraceLine( player.EyePosition(), player.EyePosition() + player.GetPlayerOrNPCViewVector() * CRYPTO_DRONE_STICK_RANGE, [ player ], TRACE_MASK_BLOCKLOS )
		TraceResults tr = TraceHull( player.EyePosition(), player.EyePosition() + player.GetPlayerOrNPCViewVector() * CRYPTO_DRONE_STICK_RANGE, CRYPTO_DRONE_HULL_TRACE_MIN, CRYPTO_DRONE_HULL_TRACE_MAX, [ player ], TRACE_MASK_NPCSOLID, TRACE_COLLISION_GROUP_PLAYER )
		int pointInRange = tr.fraction < 1.0 ? 1 : 0

		entity weapon = player.GetOffhandWeapon( OFFHAND_TACTICAL )

		bool isPredictedOrServer = InPrediction() && IsFirstTimePredicted()
		#if SERVER
			isPredictedOrServer = true
		#endif //SERVER

		if ( isPredictedOrServer )
		{
			if ( IsValid( weapon ) )
				weapon.SetScriptInt0( pointInRange )
		}
		WaitFrame()
	}


}
      

#if CLIENT
void function CryptoDrone_OnPropScriptCreated( entity ent )
{
	if ( ent.GetScriptName() == CRYPTO_DRONE_SCRIPTNAME )
	{
		ModelFX_EnableGroup( ent, "thrusters_friend" )
		ModelFX_EnableGroup( ent, "thrusters_foe" )
		if ( ent.GetOwner() == GetLocalViewPlayer() )
			thread CryptoDrone_CreateHUDMarker( ent )

		file.allDrones.append( ent )

		entity localViewPlayer = GetLocalViewPlayer()
		if ( !IsValid( localViewPlayer ) )
			return
		if( !PlayerHasPassive( localViewPlayer, ePassives.PAS_CRYPTO ) )
			return
		if ( ent.GetOwner() == GetLocalViewPlayer() )
			localViewPlayer.p.cryptoActiveCamera = ent
	}
}

void function CryptoDrone_OnPropScriptDestroyed( entity ent )
{
	if ( ent.GetTargetName() == CRYPTO_DRONE_TARGETNAME ) // class crypto_camera drone_no_minimap_object
	{
		file.allDrones.fastremovebyvalue( ent )

		entity localViewPlayer = GetLocalViewPlayer()
		if ( !IsValid( localViewPlayer ) )
			return
		if( !PlayerHasPassive( localViewPlayer, ePassives.PAS_CRYPTO ) )
			return
		if ( ent.GetOwner() == GetLocalViewPlayer() )
			localViewPlayer.p.cryptoActiveCamera = null
	}
}

void function CryptoDrone_OnPlayerTeamChanged( entity player, int oldTeam, int newTeam )
{
	foreach ( drone in file.allDrones )
	{
		if ( IsValid( drone ) )
		{
			// Update the vfx, so they play the correct vfx for the new team
			ModelFX_DisableGroup( drone, "thrusters_friend" )
			ModelFX_DisableGroup( drone, "thrusters_foe" )

			ModelFX_EnableGroup( drone, "thrusters_friend" )
			ModelFX_EnableGroup( drone, "thrusters_foe" )
		}
	}
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

void function CryptoDrone_CreateHUDMarker( entity drone )
{
	#if DEVELOPER
		printt( "create hud marker")
	#endif 
	
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


void function TrackCryptoAnimatedTacticalRuiOffhandWeapon()
{
	if ( file.cryptoAnimatedTacticalRui != null )
	{
		entity localViewPlayer = GetLocalViewPlayer()
		if ( IsValid( localViewPlayer ) )
		{
			entity offhandWeapon = localViewPlayer.GetOffhandWeapon( OFFHAND_LEFT )
			if ( IsValid( offhandWeapon ) )
			{
				RuiTrackFloat( file.cryptoAnimatedTacticalRui, "clipAmmoFrac", offhandWeapon, RUI_TRACK_WEAPON_CLIP_AMMO_FRACTION )
			}
		}
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
				RuiTrackFloat( file.cryptoAnimatedTacticalRui, "clipAmmoFrac", offhandWeapon, RUI_TRACK_WEAPON_CLIP_AMMO_FRACTION )
			}
			RuiSetBool( rui, "isVisible", false )
			break

		case OFFHAND_INVENTORY:
			if ( !(StatusEffect_GetSeverity( player, eStatusEffect.crypto_has_camera ) > 0) ) //This should handle a case of the drone getting killed while the weapon is raising and hasn't fired yet.
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
#endif // #if CLIENT

#if CLIENT
void function ServerToClient_CryptoDroneAutoReloadDone( entity weapon )
{
	if ( !IsValid( weapon ) )
		return

	if ( file.cameraRui == null )
		return

	AnnouncementMessageRight( GetLocalClientPlayer(), Localize( "#CRYPTO_AUTO_RELOAD_DONE", Localize( weapon.GetWeaponClassName() ) ), "", <1, 1, 1>, $"", 1.0 )
}
#endif

bool function IsPlayerInCryptoDroneCameraView( entity player )
{
	return StatusEffect_GetSeverity( player, eStatusEffect.camera_view ) > 0
}

bool function AutoReloadWhileInCryptoDroneCameraView()
{
	return file.crypto_tactical_auto_reload_weapons
}

float function GetNeurolinkRange( entity player )
{
	return file.neurolinkRange
}

bool function DroneCanOpenDoor( entity drone, entity door )
{
	if ( HACK_IsVaultDoor( door ) )
		return false

	// if( IsReinforced( door ) && !IsFriendlyTeam( drone.GetTeam(), door.GetTeam() ) )
		// return false

	return !IsDoorLocked( door )
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

#if CLIENT
void function MinimapPackage_PlayerDummy( entity ent, var rui )
{
	RuiSetImage( rui, "defaultIcon", $"rui/hud/minimap/compass_icon_player" )
	RuiSetImage( rui, "clampedDefaultIcon", $"rui/hud/minimap/compass_icon_player_clamped" )
	RuiSetBool( rui, "useTeamColor", false )
	RuiSetFloat( rui, "iconBlend", 0.0 )
	RuiSetBool( rui, "invertCameraViewFrac", false )

	RuiTrackFloat( rui, "cameraViewFrac", ent, RUI_TRACK_STATUS_EFFECT_SEVERITY, eStatusEffect.camera_view )
}

void function MinimapPackage_CryptoDrone( entity ent, var rui )
{
	RuiSetImage( rui, "defaultIcon", $"rui/hud/tactical_icons/tactical_crypto" )
	RuiSetImage( rui, "clampedDefaultIcon", $"rui/hud/tactical_icons/tactical_crypto" )
	RuiSetBool( rui, "useTeamColor", false )
	RuiSetFloat( rui, "iconBlend", 0.0 )
}
#endif