//=========================================================
//	mp_ability_crypto_drone.nut
//=========================================================

global function MpAbilityCryptoDrone_Init
global function OnWeaponTossReleaseAnimEvent_ability_crypto_drone
global function OnWeaponAttemptOffhandSwitch_ability_crypto_drone
global function OnWeaponTossPrep_ability_crypto_drone

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

#if SERVER
global function GetPlayerCamera









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

const int DRONE_HEALTH = 1
const float CAMERA_SCAN_RANGE = 1024
const float CAMERA_SCAN_FOV = 90

//
//
const string TRANSITION_OUT_CAMERA_1P = "Char_11_TacticalA_D"
const string TRANSITION_OUT_CAMERA_3P = "Char_11_TacticalA_D"
const string HACK_SFX_1P = "Coop_AmmoBox_AmmoRefill" //
const string HACK_SFX_3P = "Coop_AmmoBox_AmmoRefill" //

//
const string DRONE_RECALL_1P = "Char_11_TacticalA_A"
const string DRONE_RECALL_3P = "Char_11_TacticalA_A"
const string DRONE_RECALL_CRYPTO_3P = "Char_11_TacticalA_A"

global const float NEUROLINK_RANGE = 1181.1
global const float MAX_FLIGHT_RANGE = 7913 //
const float WARNING_RANGE = 5906 //
const float DEPLOYABLE_CAMERA_THROW_POWER = 25.0
const float CAMERA_FLIGHT_SPEED = 450 //
const asset CAMERA_MAX_RANGE_SCREEN_FX = $"P_crypto_drone_screen_distort_CP"
const asset CAMERA_EXPLOSION_FX	= $"P_crypto_drone_explosion"
const asset CAMERA_HIT_FX = $"P_drone_shield_hit"//
const asset CAMERA_HIT_ENEMY_FX = $"P_drone_shield_hit_enemy"//

global const string CRYPTO_DRONE_TARGETNAME = "drone_no_minimap_object"

struct
{
	#if CLIENT
	var cameraRui
	var cameraCircleStatusRui
	var cryptoAnimatedTacticalRui
	array <entity> allDrones
	#endif
	#if SERVER


	table< entity, array<int> > entitySonarHandles
	table< int, int > teamSonarCount
	array< void functionref( entity, vector, int, entity ) > SonarStartGrenadeCallbacks = []


#endif
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






#else
	RegisterSignal( "StopUpdatingCameraRui" )
	RegisterSignal( "CameraViewEnd" )
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

	thread PlayScreenTransition( weaponOwner, weapon.HasMod( "crypto_has_camera" ) )
}

void function PlayScreenTransition( entity player, bool playFastTransition )
{
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )

	entity cockpit = player.GetCockpit()
	if ( !IsValid( cockpit ) )
		return
	//


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

	//
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

/*






*/

#if CLIENT
void function AttemptDroneRecall( entity player )
{
	if ( player != GetLocalViewPlayer() || player != GetLocalClientPlayer() )
		return

	if ( IsControllerModeActive() )
	{
//		if ( TryPingBlockingFunction( player, "quickchat" ) )
//			return
	}

	player.ClientCommand( "AttemptDroneRecall" )
}
#endif

#if SERVER





















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

bool function OnWeaponAttemptOffhandSwitch_ability_crypto_drone( entity weapon )
{
	int ammoReq = weapon.GetAmmoPerShot()
	int currAmmo = weapon.GetWeaponPrimaryClipCount()
	if ( currAmmo < ammoReq )
		return false

	entity player = weapon.GetWeaponOwner()

	if ( StatusEffect_GetSeverity( player, eStatusEffect.camera_view ) > 0.0 )
		return false

	if ( StatusEffect_GetSeverity( player, eStatusEffect.script_helper ) > 0.0 )
		return false

	if ( StatusEffect_GetSeverity( player, eStatusEffect.crypto_camera_is_recalling ) > 0.0 )
		return false

	return PlayerCanUseCamera( player )
}

var function OnWeaponTossReleaseAnimEvent_ability_crypto_drone( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity player = weapon.GetWeaponOwner()
	PlayerUsedOffhand( player, weapon )

	if ( StatusEffect_GetSeverity( player, eStatusEffect.crypto_has_camera ) > 0.0 && StatusEffect_GetSeverity( player, eStatusEffect.camera_view ) == 0.0 )
	{
#if SERVER

		// No clue

#endif
//		return 0
	}

	// int ammoReq = weapon.GetAmmoPerShot()
	if ( !weapon.HasMod( "crypto_has_camera" ) )
	{
		weapon.EmitWeaponSound_1p3p( "null_remove_soundhook", "null_remove_soundhook" )
#if SERVER
		entity vehicle = CreateEntity( "player_vehicle" )
		vehicle.SetScriptName( "crypto_camera" )
		vehicle.SetOwner( player )
        vehicle.SetOrigin( player.EyePosition() )
        vehicle.VehicleSetType( VEHICLE_FLYING_CAMERA )
        vehicle.SetModel( CAMERA_MODEL )
        vehicle.kv.teamnumber = player.GetTeam()
        vehicle.kv.CollisionGroup = TRACE_COLLISION_GROUP_BLOCK_WEAPONS_AND_PHYSICS

		vehicle.SetHealth( DRONE_HEALTH )
		vehicle.SetMaxHealth( DRONE_HEALTH )
		vehicle.SetTakeDamageType( DAMAGE_YES )
		vehicle.SetDamageNotifications( true )

        DispatchSpawn( vehicle )

		vehicle.e.attachedEnts.append( CreateScanTrigger( vehicle ) )

		vehicle.Anim_Play( "drone_active_twitch" )

		thread DroneCheck_Thread( vehicle )

		weapon.SetMods( ["crypto_has_camera"])

		StatusEffect_AddEndless( player, eStatusEffect.crypto_has_camera, 1.0 )
		EmitSoundOnEntity( vehicle, DRONE_PROPULSION_3P )

		AddEntityCallback_OnKilled( vehicle, OnDroneKilled )
		AddEntityCallback_OnDamaged( vehicle, OnDroneDamaged) 

		// TODO: 
		//		- Make +scriptcommand5 recall the drone when deployed
		//  	- Implement scan feature
		// 		- Fix hacked map banners randomly showing
		//		- Find why it starts looking at 0 0 0, setting vehicle angles initially doesn't do anything

		
		/* TEMP */ vector camAng = player.CameraAngles()

		GetPlayerInCamera( player )
		
		// TEMP Duct-Tape fix to set the view angles
		thread (void function( entity p, vector a )
		{ 
			wait 0.11 
			p.SetAngles( a ) 
		})( player, camAng )

#endif
	}
	else
	{
#if SERVER
		GetPlayerInCamera( player )
#endif
	}

#if SERVER

#endif

	return 0 //ammoReq
}

void function OnWeaponTossPrep_ability_crypto_drone( entity weapon, WeaponTossPrepParams prepParams )
{

#if SERVER
	entity owner = weapon.GetOwner()
	if( !IsValid( owner ) )
		return

	// If we end up finding a camera anyway, don't create a new one and fix the weapon
	// Can happen if people play around with switching abilities / legends
	if ( GetPlayerCamera( owner ) && !weapon.HasMod( "crypto_has_camera" ) )
		weapon.SetMods( ["crypto_has_camera"])
#endif


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

#if SERVER


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

	entity camera = GetPlayerCamera( player )
	if ( !IsValid( camera ) )
		return

	if(emp.GetAmmoPerShot() != emp.GetWeaponPrimaryClipCount())
		return

	DroneFireEMP( emp )

	emp.SetWeaponPrimaryClipCount(0)
}

void function GetPlayerOutOfCameraManual( entity player )
{
	entity weapon = player.GetOffhandWeapon( OFFHAND_LEFT )
	weapon.SetWeaponPrimaryClipCount(weapon.GetAmmoPerShot()-10)

	PlayBattleChatterLineToSpeakerAndTeam( player, "bc_droneViewEnd" )
	GetPlayerOutOfCamera( player )
}

void function GetPlayerOutOfCamera( entity player )
{
	entity vehicle = GetPlayerCamera( player )

	if( !IsValid( vehicle ) )
		return

	// Supposed to use EndSignal "ExitCameraView" ?

	vehicle.kv.VisibilityFlags = ENTITY_VISIBLE_TO_EVERYONE

	RemoveButtonPressedPlayerInputCallback( player, IN_OFFHAND1, GetPlayerOutOfCameraManual )
	RemoveButtonPressedPlayerInputCallback( player, IN_OFFHAND4, FireUltimate )
	RemoveButtonPressedPlayerInputCallback( player, IN_ATTACK, FireUltimate )

	// If player was in vehicle
	try{ vehicle.VehicleRemoveDriver() } 
	catch( error ){ return	}

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
	entity vehicle = GetPlayerCamera( player )

	if( !IsValid( vehicle ) )
		return

	vehicle.VehicleSetDriver( player )
	vehicle.kv.VisibilityFlags = ENTITY_VISIBLE_TO_EVERYONE ^ ENTITY_VISIBLE_TO_OWNER

	AddCinematicFlag( player, CE_FLAG_TITAN_3P_CAM )
	StatusEffect_AddEndless( player, eStatusEffect.camera_view, 1.0 )

	AddButtonPressedPlayerInputCallback( player, IN_OFFHAND1, GetPlayerOutOfCameraManual )
	AddButtonPressedPlayerInputCallback( player, IN_OFFHAND4, FireUltimate )
	AddButtonPressedPlayerInputCallback( player, IN_ATTACK, FireUltimate )
}

entity function GetPlayerCamera( entity player )
{
	array<entity> cameras = GetEntArrayByScriptName( "crypto_camera" )
	foreach( camera in cameras )
		if ( camera.GetOwner() == player )
			return camera

	return null
}

void function DroneCheck_Thread( entity vehicle )
{
	while( true )
	{
		wait 1

		if(!IsValid( vehicle ))
			return

		entity owner = vehicle.GetOwner()
		
		if( !IsValid( owner ) )
			break
		
		if( owner.GetHealth() < 1 )
			break
	}

	entity worldSpawn = GetEnt( "worldspawn" )

	vehicle.TakeDamage( DRONE_HEALTH, worldSpawn, worldSpawn, {} )
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
	
	trigger.SetEnterCallback( OnScanTriggerEnter )
	trigger.SetLeaveCallback( OnScanTriggerLeave )

	trigger.SetParent( drone )
	trigger.SearchForNewTouchingEntity()

	IncrementSonarPerTeamGrenade( drone.GetTeam() )

	return trigger
}

void function OnScanTriggerEnter( entity trigger, entity ent )
{
	if ( !IsEnemyTeam( trigger.GetTeam(), ent.GetTeam() ) )
		return

	if ( ent.e.sonarTriggers.contains( trigger ) )
		return

	ent.e.sonarTriggers.append( trigger )
	SonarStartGrenade( ent, trigger.GetOrigin(), trigger.GetTeam(), trigger.GetOwner() )
}

void function OnScanTriggerLeave( entity trigger, entity ent )
{
	int triggerTeam = trigger.GetTeam()
	if ( !IsEnemyTeam( triggerTeam, ent.GetTeam() ) )
		return

	OnSonarTriggerLeaveInternalGrenade( trigger, ent )
}









































//































//




















































//























//































//

//
//
//
//







//










//
//
//
//
//
//
//

//

//





















































//



//























//































//

//
//
//
//







//










//
//
//
//
//
//
//

//

//

















































//
//

//
//

//
























































































































//






















//
//
//







//
//
//











//










































































































//
//
//

































//






















//













//













#endif //

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
	if ( player != GetLocalViewPlayer() )
		return

	file.cameraRui = CreateFullscreenRui( $"ui/camera_view.rpak" )
	RuiTrackFloat( file.cameraRui, "empFrac", player, RUI_TRACK_STATUS_EFFECT_SEVERITY, eStatusEffect.crypto_camera_is_emp )
	RuiTrackFloat( file.cameraRui, "recallFrac", player, RUI_TRACK_STATUS_EFFECT_SEVERITY, eStatusEffect.crypto_camera_is_recalling )
	RuiTrackFloat( file.cameraRui, "playerHealthFrac", player, RUI_TRACK_HEALTH )
	RuiTrackFloat( file.cameraRui, "playerShieldFrac", player, RUI_TRACK_SHIELD_FRACTION )
	RuiTrackFloat3( file.cameraRui, "playerAngles", player, RUI_TRACK_CAMANGLES_FOLLOW )
	RuiTrackFloat3( file.cameraRui, "playerOrigin", player, RUI_TRACK_ABSORIGIN_FOLLOW )
	RuiSetFloat( file.cameraRui, "shieldSegments", float( player.GetShieldHealthMax() / 25 ) )
	RuiSetBool( file.cameraRui, "isVisible", !Fullmap_IsVisible() )

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

void function Camera_OnEndView( entity player, int statusEffect, bool actuallyChanged )
{
	if ( player != GetLocalViewPlayer() )
		return

	player.Signal( "CameraViewEnd" )

	if ( IsValid( file.cameraCircleStatusRui ) )
		RuiSetBool( file.cameraCircleStatusRui, "isVisible", false )

	RuiDestroyIfAlive( file.cameraRui )
	file.cameraRui = null
}
//
void function TempUpdateRuiDistance( entity player )
{
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "StopUpdatingCameraRui" )

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
		inWarningRange = distanceToCrypto > WARNING_RANGE
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
				outOfRange = distanceToCrypto > MAX_FLIGHT_RANGE
				if ( outOfRange )
				{
					EffectSetControlPointVector( activeCamera.e.cameraMaxRangeFXHandle, 1, <1,0,0> )
				}
				else
				{
					EffectSetControlPointVector( activeCamera.e.cameraMaxRangeFXHandle, 1, <0.1,0,0> )
				}
			}
			float distanceToTarget = Distance( player.GetCrosshairTraceEndPos(), activeCamera.GetOrigin() )
			RuiSetFloat( file.cameraRui, "crossDist", distanceToTarget )
			string targetString = ""
			TraceResults trace = TraceLineHighDetail( activeCamera.GetOrigin(), activeCamera.GetOrigin() + activeCamera.GetForwardVector() * 300, [activeCamera], TRACE_MASK_SHOT | TRACE_MASK_BLOCKLOS, TRACE_COLLISION_GROUP_NONE )
			if ( IsValid( trace.hitEnt ) )
			{
				entity isLootBin = GetLootBinForHitEnt( trace.hitEnt )
				entity parentEnt = trace.hitEnt.GetParent()
				bool holdToUse = ( GetConVarInt( "gamepad_use_type" ) == eGamepadUseSchemeType.HOLD_TO_USE_TAP_TO_RELOAD ) && IsControllerModeActive()
				if ( IsDoor( trace.hitEnt ) && !HACK_IsVaultDoor( trace.hitEnt ) )
				{
					targetString = holdToUse ? "#CAMERA_HOLD_INTERACT_DOOR" : "#CAMERA_INTERACT_DOOR"
				}
				else if ( IsValid( parentEnt ) && IsDoor( parentEnt ) && !HACK_IsVaultDoor( parentEnt ) )
				{
					targetString = holdToUse ? "#CAMERA_HOLD_INTERACT_DOOR" : "#CAMERA_INTERACT_DOOR"
				}
				else if ( IsValid( isLootBin ) && !LootBin_IsBusy( isLootBin ) && !LootBin_IsOpen( isLootBin ) )
				{
					targetString = holdToUse ? "#CAMERA_HOLD_INTERACT_LOOT_BIN" : "#CAMERA_INTERACT_LOOT_BIN"
				}
				else if ( trace.hitEnt.GetTargetName() == DEATH_BOX_TARGETNAME && ShouldPickupDNAFromDeathBox( trace.hitEnt, player ) )
				{
					if ( trace.hitEnt.GetCustomOwnerName() != "" )
						targetString = holdToUse ? Localize( "#CAMERA_HOLD_INTERACT_DEATHBOX", trace.hitEnt.GetCustomOwnerName() ) : Localize( "#CAMERA_HOLD_INTERACT_DEATHBOX", trace.hitEnt.GetCustomOwnerName() )
					else
						targetString = holdToUse ? Localize( "#CAMERA_HOLD_INTERACT_DEATHBOX", trace.hitEnt.GetOwner().GetPlayerName() ) : Localize( "#CAMERA_HOLD_INTERACT_DEATHBOX", trace.hitEnt.GetOwner().GetPlayerName() )
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
#endif //

bool function PlayerCanUseCamera( entity ownerPlayer ) //
{
	if ( ownerPlayer.IsZiplining() )
		return false

	if ( ownerPlayer.IsTraversing() )
		return false

	if ( ownerPlayer.ContextAction_IsActive() ) //
		return false

	if ( ownerPlayer.IsPhaseShifted() )
		return false

	return true
}

#if SERVER










#endif

/*






*/

#if SERVER


















































































//



//

























//
//



//






//



//











































































//

















































































































//

















//

























#endif //

/*






*/

#if CLIENT
void function CryptoDrone_OnPropScriptCreated( entity ent )
{
	if ( ent.GetScriptName() == "crypto_camera" )
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
	if ( ent.GetScriptName() == "crypto_camera" )
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
			//
			ModelFX_DisableGroup( drone, "thrusters_friend" )
			ModelFX_DisableGroup( drone, "thrusters_foe" )

			ModelFX_EnableGroup( drone, "thrusters_friend" )
			ModelFX_EnableGroup( drone, "thrusters_foe" )
		}
	}
}

void function CryptoDrone_CreateHUDMarker( entity drone )
{
	drone.EndSignal( "OnDestroy" )
	entity localViewPlayer = GetLocalViewPlayer()

	var rui = CreateCockpitRui( $"ui/crytpo_drone_offscreen.rpak", RuiCalculateDistanceSortKey( localViewPlayer.EyePosition(), drone.GetOrigin() ) )
	RuiSetImage( rui, "icon", $"rui/hud/tactical_icons/tactical_crypto" )
	RuiSetBool( rui, "isVisible", true )
	RuiSetBool( rui, "pinToEdge", true )
	RuiSetBool( rui, "showClampArrow", true )
	RuiSetBool( rui, "adsFade", true )
	RuiTrackFloat3( rui, "pos", drone, RUI_TRACK_OVERHEAD_FOLLOW )

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
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "CameraViewEnd" )

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

var function CreateCameraCircleStatusRui()
{
	file.cameraCircleStatusRui = CreateFullscreenRui( $"ui/camera_circle_status.rpak" )
	entity localViewPlayer = GetLocalViewPlayer()
	RuiTrackFloat( file.cameraCircleStatusRui, "deathfieldDistance", localViewPlayer, RUI_TRACK_DEATHFIELD_DISTANCE )
	RuiTrackFloat( file.cameraCircleStatusRui, "cameraViewFrac", localViewPlayer, RUI_TRACK_STATUS_EFFECT_SEVERITY, eStatusEffect.camera_view )
	return file.cameraCircleStatusRui
}

void function DestroyCameraCircleStatusRui()
{
	if ( file.cameraCircleStatusRui != null )
	{
		RuiDestroyIfAlive( file.cameraCircleStatusRui )
		file.cameraCircleStatusRui = null
	}
}

var function GetCryptoAnimatedTacticalRui()
{
	return file.cryptoAnimatedTacticalRui
}

var function CreateCryptoAnimatedTacticalRui()
{
	file.cryptoAnimatedTacticalRui = CreateCockpitPostFXRui( $"ui/crypto_tactical.rpak", HUD_Z_BASE )
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
	return file.cryptoAnimatedTacticalRui
}

void function DestroyCryptoAnimatedTacticalRui()
{
	if ( file.cryptoAnimatedTacticalRui != null )
	{
		RuiDestroyIfAlive( file.cryptoAnimatedTacticalRui )
		file.cryptoAnimatedTacticalRui = null
	}
}

void function CryptoDrone_WeaponStatusCheck( entity player, var rui, int slot )
{
	if ( !PlayerHasPassive( player, ePassives.PAS_CRYPTO ) )
		return

	switch ( slot )
	{
		case OFFHAND_LEFT:
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

#endif //