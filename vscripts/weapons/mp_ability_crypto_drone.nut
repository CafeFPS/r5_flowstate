global function MpAbilityCryptoDrone_Init
global function OnWeaponTossReleaseAnimEvent_ability_crypto_drone
global function OnWeaponAttemptOffhandSwitch_ability_crypto_drone
global function OnWeaponTossPrep_ability_crypto_drone

#if CLIENT
global function OnClientAnimEvent_ability_crypto_drone
#endif

#if SERVER
#endif

// global const asset CAMERA_MODEL            = $"mdl/props/crypto_drone/crypto_drone.rmdl"
// global const asset CAMERA_RIG              = $"mdl/props/editor_ref_camera/editor_ref_camera.rmdl"
global const asset CAMERA_FX               = $"P_drone_contrail"

global const asset VISOR_FX_3P             = $"P_crypto_visor_ui"

const string DRONE_PROPULSION_1P           = "Char_11_TacticalA_E"
const string DRONE_PROPULSION_3P           = "Char_11_TacticalA_E_3P"
const string DRONE_EXPLOSION_3P            = "Char_11_TacticalA_F_3p"
const string DRONE_EXPLOSION_1P            = "Char_11_TacticalA_F"

const string DRONE_SCANNING_3P             = "Char_11_TacticalA_E2_3p"

const string TRANSITION_INTO_CAMERA_1P     = "Char_11_TacticalA_D"
const string TRANSITION_OUT_CAMERA_1P      = "Char_11_TacticalA_D"
const string TRANSITION_INTO_CAMERA_3P     = "Char_11_TacticalA_D"
const string TRANSITION_OUT_CAMERA_3P      = "Char_11_TacticalA_D"
const string HACK_SFX_1P                   = "Coop_AmmoBox_AmmoRefill" //
const string HACK_SFX_3P                   = "Coop_AmmoBox_AmmoRefill" //

const string DRONE_RECALL_1P               = "Char_11_TacticalA_A"
const string DRONE_RECALL_3P               = "Char_11_TacticalA_A"
const string DRONE_RECALL_CRYPTO_3P        = "Char_11_TacticalA_A"

global const float NEUROLINK_RANGE         = 1181.1
global const float MAX_FLIGHT_RANGE        = 7913 //
global const float WARNING_RANGE           = 5906 //
const float DEPLOYABLE_CAMERA_THROW_POWER  = 25.0
const float CAMERA_FLIGHT_SPEED            = 450 //
const CAMERA_EXPLOSION_FX                  = $"P_crypto_drone_explosion"
const CAMERA_MAX_RANGE_SCREEN_FX           = $"P_crypto_drone_screen_distort_CP"

struct
{
	#if CLIENT
	var cameraRui
	var cryptoRui
	#endif
	#if SERVER

	#endif
} file

void function MpAbilityCryptoDrone_Init()
{
	// PrecacheModel( CAMERA_MODEL )
	// PrecacheModel( CAMERA_RIG )
	PrecacheParticleSystem( CAMERA_FX )
	PrecacheParticleSystem( CAMERA_EXPLOSION_FX )
	PrecacheParticleSystem( CAMERA_MAX_RANGE_SCREEN_FX )
	PrecacheParticleSystem( VISOR_FX_3P )

	#if SERVER




	#else
	RegisterSignal( "StopUpdatingCameraRui" )
	StatusEffect_RegisterEnabledCallback( eStatusEffect.camera_view, Camera_OnBeginView )
	StatusEffect_RegisterDisabledCallback( eStatusEffect.camera_view, Camera_OnEndView )
	StatusEffect_RegisterEnabledCallback( eStatusEffect.crypto_has_camera, Camera_OnCreate )
	StatusEffect_RegisterDisabledCallback( eStatusEffect.crypto_has_camera, Camera_OnDestroy )
	AddCreateCallback( "player_vehicle", CryptoDrone_OnPropScriptCreated )
	RegisterConCommandTriggeredCallback( "+scriptCommand5", AttemptDroneRecall )
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
	// TODO: implement this: see mp_ability_crypto_drone.nut from the VPK
}

void function AttemptDroneRecall( entity player )
{
	if ( player != GetLocalViewPlayer() || player != GetLocalClientPlayer() )
		return

	player.ClientCommand( "AttemptDroneRecall" )
}
#endif

#if SERVER
#endif

void function OnPlayerTookDamage( entity damagedEnt, var damageInfo )
{
	damagedEnt.Signal( "ExitCameraView" )
}

bool function OnWeaponAttemptOffhandSwitch_ability_crypto_drone( entity weapon )
{
	int ammoReq = weapon.GetAmmoPerShot()
	int currAmmo = weapon.GetWeaponPrimaryClipCount()
	if ( currAmmo < ammoReq )
		return false

	entity player = weapon.GetWeaponOwner()
	if ( player.IsPhaseShifted() )
		return false

	if ( StatusEffect_GetSeverity( player, eStatusEffect.camera_view ) > 0.0 )
		return false

	return PlayerCanUseCamera( player )
}

var function OnWeaponTossReleaseAnimEvent_ability_crypto_drone( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity player = weapon.GetWeaponOwner()
	if ( StatusEffect_GetSeverity( player, eStatusEffect.crypto_has_camera ) > 0.0 && StatusEffect_GetSeverity( player, eStatusEffect.camera_view ) == 0.0 )
	{
		#if SERVER

		#endif
		return 0
	}

	int ammoReq = weapon.GetAmmoPerShot()
	weapon.EmitWeaponSound_1p3p( GetGrenadeThrowSound_1p( weapon ), GetGrenadeThrowSound_3p( weapon ) )

	entity deployable = ReleaseCamera( weapon, attackParams, DEPLOYABLE_CAMERA_THROW_POWER, OnFlyingCameraDeployed )
	if ( deployable )
	{
		PlayerUsedOffhand( player, weapon )

		#if SERVER
		#endif
	}

	return ammoReq
}

entity function ReleaseCamera( entity weapon, WeaponPrimaryAttackParams attackParams, float throwPower, void functionref(entity) deployFunc, vector ornull angularVelocity = null )
{
	#if CLIENT
		if ( !weapon.ShouldPredictProjectiles() )
			return null
	#endif

	entity player = weapon.GetWeaponOwner()

	vector attackPos
	if ( IsValid( player ) )
		attackPos = GetCameraThrowStartPos( player, attackParams.pos )
	else
		attackPos = attackParams.pos

	vector angles   = VectorToAngles( attackParams.dir )
	vector velocity = GetCameraThrowVelocity( player, angles, throwPower )
	if ( angularVelocity == null )
		angularVelocity = <600, RandomFloatRange( -300, 300 ), 0>
	expect vector( angularVelocity )

	float fuseTime = 0.0    //

	bool isPredicted = PROJECTILE_PREDICTED
	if ( player.IsNPC() )
		isPredicted = PROJECTILE_NOT_PREDICTED

	WeaponFireGrenadeParams fireGrenadeParams
	fireGrenadeParams.pos = attackPos
	fireGrenadeParams.vel = velocity
	fireGrenadeParams.angVel = angularVelocity
	fireGrenadeParams.fuseTime = fuseTime
	fireGrenadeParams.scriptTouchDamageType = damageTypes.explosive
	fireGrenadeParams.scriptExplosionDamageType = damageTypes.explosive
	fireGrenadeParams.clientPredicted = isPredicted
	fireGrenadeParams.lagCompensated = true
	fireGrenadeParams.useScriptOnDamage = true
	entity deployable = weapon.FireWeaponGrenade( fireGrenadeParams )

	if ( deployable )
	{
		deployable.SetAngles( <0, angles.y - 180, 0> )
	#if SERVER
	#endif
	}

	return deployable
}

vector function GetCameraThrowStartPos( entity player, vector baseStartPos )
{
	//
	vector attackPos = player.OffsetPositionFromView( baseStartPos, <20, 0, 2.5> )    //
	return attackPos
}

vector function GetCameraThrowVelocity( entity player, vector baseAngles, float throwPower )
{
	baseAngles += <-8, 0, 0>
	vector forward = AnglesToForward( baseAngles )

	if ( baseAngles.x < 80 )
		throwPower = GraphCapped( baseAngles.x, 0, 80, throwPower, throwPower * 3 )

	vector velocity = forward * throwPower

	return velocity
}

void function OnWeaponTossPrep_ability_crypto_drone( entity weapon, WeaponTossPrepParams prepParams )
{
	weapon.EmitWeaponSound_1p3p( GetGrenadeDeploySound_1p( weapon ), GetGrenadeDeploySound_3p( weapon ) )
}

void function OnFlyingCameraDeployed( entity projectile )
{
#if SERVER
#endif
}

#if SERVER
#endif //

#if CLIENT
void function Camera_OnCreate( entity player, int statusEffect, bool actuallyChanged )
{
	if ( player != GetLocalViewPlayer() )
		return

	file.cryptoRui = CreateFullscreenRui( $"ui/crypto_view.rpak" )
	RuiTrackFloat( file.cryptoRui, "empFrac", player, RUI_TRACK_STATUS_EFFECT_SEVERITY, eStatusEffect.crypto_camera_is_emp )
	RuiTrackFloat( file.cryptoRui, "recallFrac", player, RUI_TRACK_STATUS_EFFECT_SEVERITY, eStatusEffect.crypto_camera_is_recalling )
	RuiTrackFloat( file.cryptoRui, "cameraViewFrac", player, RUI_TRACK_STATUS_EFFECT_SEVERITY, eStatusEffect.camera_view )

	thread TempUpdateRuiDistance( player )
}

void function Camera_OnDestroy( entity player, int statusEffect, bool actuallyChanged )
{
	if ( player != GetLocalViewPlayer() )
		return

	player.Signal( "StopUpdatingCameraRui")

	RuiDestroyIfAlive( file.cryptoRui )
	file.cryptoRui = null
}

void function Camera_OnBeginView( entity player, int statusEffect, bool actuallyChanged )
{
	if ( player != GetLocalViewPlayer() )
		return

	file.cameraRui = CreateFullscreenRui( $"ui/camera_view.rpak" )
	RuiTrackFloat( file.cameraRui, "empFrac", player, RUI_TRACK_STATUS_EFFECT_SEVERITY, eStatusEffect.crypto_camera_is_emp )
	RuiTrackFloat( file.cameraRui, "recallFrac", player, RUI_TRACK_STATUS_EFFECT_SEVERITY, eStatusEffect.crypto_camera_is_recalling )

	entity offhandWeapon = player.GetOffhandWeapon( OFFHAND_ULTIMATE )
	if ( IsValid( offhandWeapon ) )
		RuiTrackFloat( file.cameraRui, "clipAmmoFrac", offhandWeapon, RUI_TRACK_WEAPON_CLIP_AMMO_FRACTION )
	if ( IsControllerModeActive() )
		RuiSetString( file.cameraRui, "ultimateHint", "#WPN_CAMERA_EMP_CONTROLLER" )
	else
		RuiSetString( file.cameraRui, "ultimateHint", "#WPN_CAMERA_EMP" )
}

void function Camera_OnEndView( entity player, int statusEffect, bool actuallyChanged )
{
	if ( player != GetLocalViewPlayer() )
		return

	RuiDestroyIfAlive( file.cameraRui )
	file.cameraRui = null
}

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
	while( true )
	{
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
			TraceResults trace = TraceLineHighDetail( activeCamera.GetOrigin(), activeCamera.GetOrigin() + activeCamera.GetForwardVector() * 300, [activeCamera], TRACE_MASK_BLOCKLOS, TRACE_COLLISION_GROUP_NONE )
			if ( IsValid( trace.hitEnt ) )
			{
				entity isLootBin = GetLootBinForHitEnt( trace.hitEnt )
				entity parentEnt = trace.hitEnt.GetParent()
				if ( IsDoor( trace.hitEnt ) )
				{
					targetString = "#CAMERA_INTERACT_DOOR"
				}
				else if ( IsValid( parentEnt ) && IsDoor( parentEnt ) )
				{
					targetString = "#CAMERA_INTERACT_DOOR"
				}
				else if ( IsValid( isLootBin ) && !LootBin_IsBusy( isLootBin ) && !LootBin_IsOpen( isLootBin ) )
				{
					targetString = "#CAMERA_INTERACT_LOOT_BIN"
				}
				else if ( trace.hitEnt.GetTargetName() == DEATH_BOX_TARGETNAME && ShouldPickupDNAFromDeathBox( trace.hitEnt, player ) )
				{
					if ( trace.hitEnt.GetCustomOwnerName() != "" )
						targetString = Localize( "#CAMERA_INTERACT_DEATHBOX", trace.hitEnt.GetCustomOwnerName() )
					else
						targetString = Localize( "#CAMERA_INTERACT_DEATHBOX", trace.hitEnt.GetOwner().GetPlayerName() )
				}
			}
			RuiSetString( file.cameraRui, "interactHint", targetString )
			RuiSetFloat( file.cameraRui, "distanceToCrypto", distanceToCrypto )
		}
		if ( IsValid( file.cryptoRui ) )
		{
			RuiSetFloat( file.cryptoRui, "distanceToCrypto", distanceToCrypto )
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
#endif //

#if CLIENT
void function CryptoDrone_OnPropScriptCreated( entity ent )
{
	if ( ent.GetScriptName() == "crypto_camera" )
	{
		if ( ent.GetOwner() == GetLocalViewPlayer() )
		{
			thread CryptoDrone_CreateHUDMarker( ent )
		}
	}
}

void function CryptoDrone_CreateHUDMarker( entity drone )
{
	drone.EndSignal( "OnDestroy" )
	entity localViewPlayer = GetLocalViewPlayer()

	var rui = CreateCockpitRui( $"ui/crytpo_drone_offscreen.rpak", RuiCalculateDistanceSortKey( localViewPlayer.EyePosition(), drone.GetOrigin() ) )
	RuiSetImage( rui, "icon", $"rui/pilot_loadout/ordnance/tick" )
	RuiSetBool( rui, "isVisible", true )
	RuiSetBool( rui, "pinToEdge", true )
	RuiSetBool( rui, "showClampArrow", true )
	RuiTrackFloat3( rui, "pos", drone, RUI_TRACK_OVERHEAD_FOLLOW )

	OnThreadEnd(
		function() : ( rui )
		{
			RuiDestroy( rui )
		}
	)

	WaitForever()
}
#endif //
