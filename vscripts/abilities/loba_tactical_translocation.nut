#if SERVER || CLIENT || UI 
global function LobaTacticalTranslocation_LevelInit
#endif

#if SERVER || CLIENT
global function OnWeaponAttemptOffhandSwitch_ability_translocation
global function OnWeaponActivate_ability_translocation
global function OnWeaponDeactivate_ability_translocation
global function OnWeaponTossPrep_ability_translocation
global function OnWeaponToss_ability_translocation
global function OnWeaponTossReleaseAnimEvent_ability_translocation
global function OnWeaponRedirectProjectile_ability_translocation
#endif

#if CLIENT
global function ServerToClient_Translocation_ClientProjectilePlantedHandler
global function ServerToClient_Translocation_TeleportFailed
#endif


#if SERVER || CLIENT
const int TRANSLOCATION_BACKTRACK_DIST = 150
const int TRANSLOCATION_BACKTRACK_DIST_SQR = TRANSLOCATION_BACKTRACK_DIST * TRANSLOCATION_BACKTRACK_DIST

const asset TRANSLOCATION_WARP_SCREEN_FX = $"P_ability_warp_screen"
const asset TRANSLOCATION_WARP_BEAM_FX = $"P_ability_warp_travel"
const asset TRANSLOCATION_WARP_WORLD_FX = $"P_warp_imp_default"
const string TRANSLOCATION_WARP_IMPACT_TABLE = "ability_warp"
const asset TRANSLOCATION_DROP_TO_GROUND_MARKER_FX = $"P_wrp_trl_grnd"
const asset TRANSLOCATION_DROP_TO_GROUND_ACTIVATE_FX = $"P_warp_proj_drop"
const asset TRANSLOCATION_DROP_TO_GROUND_DESTINATION_FX = $"P_warp_proj_drop_grnd"

const bool TRANSLOCATION_DEBUG = false

#if R5DEV
const bool TRANSLOCATION_BACKFACE_DEBUG = false
#endif

const float TRANSLOCATION_MIN_SAMPLE_DISTANCE_SQR = 2000
const float TRANSLOCATION_MAX_SAMPLE_DISTANCE_SQR = 10000
const float TRANSLOCATION_TRACK_BACK_DIST = 100
const int RUI_TRACK_GRENADE_DIST_FROM_IMPACT = 100

const bool FORCE_TELEPORT_FAIL = false

IntSet fallTriggerDamageSourceIdSet = {
	[eDamageSourceId.fall] = IN_SET,
	[eDamageSourceId.splat] = IN_SET,
	[eDamageSourceId.submerged] = IN_SET,
	[eDamageSourceId.turbine] = IN_SET,
	[eDamageSourceId.lasergrid] = IN_SET,
	[eDamageSourceId.damagedef_crush] = IN_SET,
}
#endif


#if CLIENT
enum eLobaCrosshairStage
{
	//
	HELD = 0
	TOSSED = 1
	REDIRECTED = 2
	PLANTED = 3
	TELEPORTED = 4
	FAILED = 5
}
#endif



#if SERVER || CLIENT || UI 
void function LobaTacticalTranslocation_LevelInit()
{
	#if SERVER || CLIENT
		PrecacheParticleSystem( TRANSLOCATION_WARP_BEAM_FX )
		PrecacheParticleSystem( TRANSLOCATION_WARP_WORLD_FX )
		PrecacheImpactEffectTable( TRANSLOCATION_WARP_IMPACT_TABLE )
		PrecacheParticleSystem( TRANSLOCATION_DROP_TO_GROUND_MARKER_FX )
		PrecacheParticleSystem( TRANSLOCATION_DROP_TO_GROUND_ACTIVATE_FX )
		PrecacheParticleSystem( TRANSLOCATION_DROP_TO_GROUND_DESTINATION_FX )

		RegisterNetworkedVariable( "Translocation_ActiveProjectile", SNDC_PLAYER_EXCLUSIVE, SNVT_ENTITY )

		Remote_RegisterClientFunction( "ServerToClient_Translocation_ClientProjectilePlantedHandler", "entity", "entity" )
		Remote_RegisterClientFunction( "ServerToClient_Translocation_TeleportFailed", "entity" )

		RegisterSignal( "Translocation_Deactivate" )

		AddCallback_PlayerCanUseZipline( CanUseZipline )
	#endif

	#if SERVER

#endif

	#if CLIENT
		RegisterSignal( "Translocation_StopVisualEffect" )
		RegisterSignal( "Translocation_RedirectProjectile" )
		PrecacheParticleSystem( TRANSLOCATION_WARP_SCREEN_FX )
		// StatusEffect_RegisterEnabledCallback( eStatusEffect.translocation_visual_effect, StartVisualEffect )
		// StatusEffect_RegisterDisabledCallback( eStatusEffect.translocation_visual_effect, StopVisualEffect )
	#endif
}
#endif


#if SERVER || CLIENT
bool function OnWeaponAttemptOffhandSwitch_ability_translocation( entity weapon )
{
	entity owner = weapon.GetWeaponOwner()

	if ( weapon == owner.GetActiveWeapon( eActiveInventorySlot.mainHand ) )
		return false

	if ( !IsPlayerTranslocationPermitted( owner ) )
		return false

	int ammoReq  = weapon.GetAmmoPerShot()
	int currAmmo = weapon.GetWeaponPrimaryClipCount()
	if ( currAmmo < ammoReq )
		return false

	return true
}
#endif


#if SERVER || CLIENT
void function OnWeaponActivate_ability_translocation( entity weapon )
{
	printt(VM_NAME(), FUNC_NAME())
	entity owner = weapon.GetWeaponOwner()
	Assert( IsValid( owner ) )

	#if SERVER







	#elseif CLIENT
		if ( !(InPrediction() && IsFirstTimePredicted()) )
			return

		weapon.w.translocate_predictedInitialProjectile = null
		weapon.w.translocate_predictedInitialProjectile = null
		weapon.w.translocate_impactRumbleObj = null
	#endif

	thread TranslocationLifetimeThread( owner, weapon )
}
#endif


#if SERVER || CLIENT
void function OnWeaponDeactivate_ability_translocation( entity weapon )
{
	#if CLIENT
		if ( !InPrediction() )
			return
	#endif

	Signal( weapon, "Translocation_Deactivate" )
}
#endif


#if SERVER || CLIENT
void function TranslocationLifetimeThread( entity owner, entity weapon )
{
	EndSignal( owner, "OnDeath" )
	EndSignal( weapon, "OnDestroy" )
	EndSignal( weapon, "Translocation_Deactivate" )

	var rui
	#if CLIENT
		// td
		// rui = CreateFullscreenRui( $"ui/crosshair_loba_translocation.rpak", 500 ) // oof this doesn't exist :(
		// RuiTrackFloat( rui, "weaponGrenadeDistToImpact", weapon, RUI_TRACK_GRENADE_DIST_FROM_IMPACT )
		// RuiSetFloat( rui, "estimatedMaxDist", GetLobaTacticalEstimatedMaxDistance() )
	#endif

	bool[1] haveLockedForToss = [false]

	OnThreadEnd( void function() : ( owner, weapon, rui, haveLockedForToss ) {
		if ( IsValid( weapon ) )
		{
			if ( weapon.w.translocate_isADSForced )
			{
				weapon.ClearForcedADS()
				weapon.w.translocate_isADSForced = false
			}
		}
		if ( IsValid( owner ) )
		{
			if ( haveLockedForToss[0] )
			{
				#if SERVER














#endif
			}
		}

		#if CLIENT
			// td
			//RuiDestroyIfAlive( rui )
		#endif
	} )

	Assert( !weapon.w.translocate_isADSForced )
	weapon.w.translocate_isADSForced = true
	weapon.SetForcedADS()

	int offhandSlot = weapon.GetWeaponSettingEnum( eWeaponVar.offhand_active_slot, eActiveInventorySlot )

	while ( true )
	{
		if ( owner.GetActiveWeapon( offhandSlot ) != weapon )
			break

		#if CLIENT
			int crosshairStage = eLobaCrosshairStage.HELD
		#endif

		entity currentProjectile = GetCurrentTranslocationProjectile( owner, weapon )
		if ( IsValid( currentProjectile ) )
		{
			#if CLIENT
				// td
				//if ( currentProjectile.IsGrenadeStatusFlagSet( GSF_PLANTED ) )
					crosshairStage = eLobaCrosshairStage.PLANTED
				// else if ( currentProjectile.IsGrenadeStatusFlagSet( GSF_REDIRECTED ) )
				// 	crosshairStage = eLobaCrosshairStage.REDIRECTED
				// else
				// 	crosshairStage = eLobaCrosshairStage.TOSSED
			#endif

			if ( !haveLockedForToss[0] )
			{
				#if SERVER//













#endif

				haveLockedForToss[0] = true
			}
		}
		else
		{
			#if CLIENT
				if ( weapon.GetWeaponActivity() == ACT_VM_PICKUP )
					crosshairStage = eLobaCrosshairStage.TELEPORTED
				else if ( weapon.GetWeaponActivity() == ACT_VM_MISSCENTER )
					crosshairStage = eLobaCrosshairStage.FAILED
			#endif
		}

		#if CLIENT
			// td
			//RuiSetInt( rui, "stage", crosshairStage )
			//
		#endif

		WaitFrame()
	}
}
#endif


#if SERVER || CLIENT
bool function CanUseZipline( entity player, entity zipline, vector ziplineClosestPoint )
{
	entity mainHandWeapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
	if ( IsValid( mainHandWeapon ) && mainHandWeapon.GetWeaponClassName() == "mp_ability_translocation" )
		return GetLobaTacticalAllowZiplineWhileDeployed()

	return true
}
#endif


#if SERVER || CLIENT
void function OnWeaponTossPrep_ability_translocation( entity weapon, WeaponTossPrepParams prepParams )
{
	entity owner = weapon.GetWeaponOwner()

	#if CLIENT
		if ( !(InPrediction() && IsFirstTimePredicted()) )
			return
	#endif

	weapon.EmitWeaponSound_1p3p( GetGrenadeDeploySound_1p( weapon ), GetGrenadeDeploySound_3p( weapon ) )

	printt(VM_NAME(), FUNC_NAME())

	#if CLIENT
		// td
		//Rumble_Play( "loba_tactical_pull", {} )
	#endif
}
#endif


#if SERVER || CLIENT
var function OnWeaponToss_ability_translocation( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity owner = weapon.GetWeaponOwner()

	printt(VM_NAME(), FUNC_NAME())

	return weapon.GetAmmoPerShot()
}
#endif


#if SERVER || CLIENT
var function OnWeaponTossReleaseAnimEvent_ability_translocation( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity owner = weapon.GetWeaponOwner()

	#if SERVER
//
#elseif CLIENT
		if ( !(InPrediction() && IsFirstTimePredicted()) )
			return
	#endif

	weapon.EmitWeaponSound_1p3p( GetGrenadeThrowSound_1p( weapon ), GetGrenadeThrowSound_3p( weapon ) )

	#if SERVER

#endif

	printt(VM_NAME(), FUNC_NAME())

	entity projectile = ThrowDeployableLB( weapon, attackParams, 1, OnProjectilePlanted, OnProjectileBounce, null ) // ThrowDeployable( weapon, attackParams, 1, OnProjectilePlanted, OnProjectileBounce, null )
	if ( IsValid( projectile ) )
	{
		PlayerUsedOffhand( owner, weapon, true, projectile )

		#if SERVER
















#elseif CLIENT
			weapon.w.translocate_predictedInitialProjectile = projectile
			//
		#endif

		//
		vector ownerPos = owner.GetOrigin(), ownerAng = owner.EyeAngles()
		printf( "TRANSLOCATION: Toss from   setpos %f %f %f; setang %f %f %f", ownerPos.x, ownerPos.y, ownerPos.z, ownerAng.x, ownerAng.y, ownerAng.z )
		//

		printt(VM_NAME(), FUNC_NAME(), "TLTossedThread")

		thread TranslocationTossedThread( owner, weapon )
	}

	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot ) //
}
#endif


#if SERVER || CLIENT
bool function OnWeaponRedirectProjectile_ability_translocation( entity weapon, WeaponRedirectParams params )
{
	entity owner = weapon.GetWeaponOwner()

	if ( !GetLobaTacticalAllowDropToGround() )
		return false

	float dropToGroundMinimumTime = GetCurrentPlaylistVarFloat( "loba_tactical_drop_minimum_time", 0.24 )
	if ( Time() < params.projectile.GetProjectileCreationTimeServer() + dropToGroundMinimumTime )
		return false

	// todo:
	// if ( params.projectile.HasWeaponMod( "redirect_mod" ) )
	// 	return false

	#if SERVER


#endif

	//
	vector ownerPos = owner.GetOrigin(), ownerAng = owner.EyeAngles()
	printf( "TRANSLOCATION: Redirect at   setpos %f %f %f", params.projectilePos.x, params.projectilePos.y, params.projectilePos.z )
	//

	weapon.StartCustomActivity( "ACT_VM_HITCENTER", WCAF_NONE )

	WeaponPrimaryAttackParams attackParams
	attackParams.pos = params.projectilePos
	attackParams.dir = <0.0, 0.0, -1.0>
	attackParams.firstTimePredicted = false
	attackParams.burstIndex = 0
	attackParams.barrelIndex = 0

	weapon.AddMod( "redirect_mod" )
	entity projectile = ThrowDeployableLB( weapon, attackParams, 1, OnProjectilePlanted, OnProjectileBounce, null )
	weapon.RemoveMod( "redirect_mod" )

	if ( !IsValid( projectile ) )
		return false

	// projectile.AddGrenadeStatusFlag( GSF_REDIRECTED )

	string projectileSound = GetGrenadeProjectileSound( weapon )
	if ( projectileSound != "" )
		EmitSoundOnEntity( projectile, projectileSound )

	#if SERVER












#elseif CLIENT
		weapon.w.translocate_predictedRedirectedProjectile = projectile

		if ( !InPrediction() || IsFirstTimePredicted() )
		{
			thread DropToGroundFXThread( owner, projectile, params.projectile, params.projectilePos )
			EmitSoundOnEntity( projectile, "Loba_TeleportRing_ForceDown_3P" )
		}
	#endif

	return true
}
#endif


#if SERVER || CLIENT
void function TranslocationTossedThread( entity owner, entity weapon )
{
	EndSignal( owner, "OnDeath" )
	EndSignal( weapon, "OnDestroy" )
	EndSignal( weapon, "Translocation_Deactivate" )

	array<int> fxIds
	table[1] rumbleHandle = [{}]

	OnThreadEnd( void function() : ( owner, weapon, fxIds, rumbleHandle ) {
		#if SERVER























//


//







//




//







//




#elseif CLIENT
			//
			//

			CleanupFXArray( fxIds, true, false )

			rumbleHandle[0].loop = false
		#endif
	} )

	#if CLIENT
		rumbleHandle[0] = expect table(Rumble_Play( "loba_tactical_toss_loop", { loop = true, } ))
		//

		int dropTargetFXId = -1
		if ( GetLobaTacticalAllowDropToGround() )
		{
			dropTargetFXId = StartParticleEffectInWorldWithHandle( GetParticleSystemIndex( TRANSLOCATION_DROP_TO_GROUND_MARKER_FX ),
				weapon.GetAttackPosition(), <-90, VectorToAngles( weapon.GetAttackDirection() ).y, 0> )
			if ( dropTargetFXId != -1 )
				fxIds.append( dropTargetFXId )
		}
	#endif

	bool didDrop        = false
	bool dropInProgress = false

	float tossTime     = Time()
	float timeoutDelay = weapon.GetWeaponSettingFloat( eWeaponVar.grenade_fuse_time )
	while( true )
	{
		entity currentProjectile = GetCurrentTranslocationProjectile( owner, weapon )
		if ( !IsValid( currentProjectile ) )
			break

		#if SERVER
//















//

//




#elseif CLIENT
			if ( dropTargetFXId != 1 )
				EffectSetControlPointVector( dropTargetFXId, 0, OriginToGround( currentProjectile.GetOrigin(), TRACE_MASK_NPCWORLDSTATIC, currentProjectile ) + <0, 0, 5> )
		#endif

		//
		if ( !IsPlayerTranslocationPermitted( owner ) )
			break

		//

		WaitFrame()
	}

	#if SERVER


#endif
}
#endif


#if SERVER || CLIENT
void function OnProjectileBounce( entity projectile, DeployableCollisionParams collisionParams )
{
	#if SERVER






















#endif
}
#endif

#if SERVER




















//



























#endif

#if SERVER || CLIENT
void function OnProjectilePlanted( entity projectile, DeployableCollisionParams collisionParams )
{
	entity owner = projectile.GetOwner()
	if ( !IsValid( owner ) )
		return

	entity weapon = projectile.GetWeaponSource()
	if ( !IsValid( weapon ) )
		return

	#if SERVER














#elseif CLIENT
		ClientProjectilePlantHandler( weapon, projectile ) //
	#endif
}
#endif


#if CLIENT
void function ServerToClient_Translocation_ClientProjectilePlantedHandler( entity weapon, entity projectile )
{
	if ( !IsValid( weapon ) || !IsValid( projectile ) )
		return

	ClientProjectilePlantHandler( weapon, projectile )
}
#endif


#if CLIENT
void function ClientProjectilePlantHandler( entity weapon, entity projectile )
{
	//

	if ( weapon.w.translocate_impactRumbleObj == null )
		weapon.w.translocate_impactRumbleObj = expect table(Rumble_Play( "loba_tactical_impact_and_teleport", {} ))
}
#endif


#if CLIENT
void function ServerToClient_Translocation_TeleportFailed( entity weapon )
{
	if ( !IsValid( weapon ) )
		return

	if ( weapon.w.translocate_impactRumbleObj == null )
		return

	table impactRumbleObj = expect table(weapon.w.translocate_impactRumbleObj)
	impactRumbleObj.scale = 0.0
	weapon.w.translocate_impactRumbleObj = null
}
#endif


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


































#endif


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



















#endif


#if SERVER || CLIENT
bool function IsPlayerTranslocationPermitted( entity player )
{
	if ( IsValid( player.GetParent() ) ) // && !player.IsPlayerInAnyVehicle() )
		return false

	if ( IsPlayingFirstPersonAnimation( player ) )
		return false

	if ( IsPlayingFirstAndThirdPersonAnimation( player ) )
		return false

	if ( player.IsPhaseShifted() )
		return false

	if ( Bleedout_IsBleedingOut( player ) )
		return false

	bool allowDeployWhileZiplining = GetLobaTacticalAllowDeployWhileZiplining()
	bool allowZiplineWhileDeployed = GetLobaTacticalAllowZiplineWhileDeployed()
	bool isZiplining               = player.ContextAction_IsZipline()

	if ( player.GetWeaponDisableFlags() & WEAPON_DISABLE_FLAGS_MAIN )
	{
		if ( allowZiplineWhileDeployed && isZiplining )
		{
			//
			//
		}
		else
		{
			return false
		}
	}

	if ( player.ContextAction_IsActive() )
	{
		if ( (allowDeployWhileZiplining || allowZiplineWhileDeployed) && isZiplining )
		{
			//
			//
		}
		else
		{
			return false
		}
	}

	if ( player.ContextAction_IsMeleeExecution() || player.ContextAction_IsMeleeExecutionTarget() )
		return false

	return true
}
#endif


#if SERVER






























#endif


#if SERVER || CLIENT
void function DropToGroundFXThread( entity player, entity existingProjectile, entity predictedRedirectedProjectile, vector currentProjectilePos )
{
	if ( !IsValid( predictedRedirectedProjectile ) || predictedRedirectedProjectile.IsMarkedForDeletion() )
		return

	TraceResults tr = TraceLineHighDetail( currentProjectilePos, currentProjectilePos - <0, 0, 2500>,
		[ existingProjectile, predictedRedirectedProjectile ], TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_NONE, predictedRedirectedProjectile )

	FXHandle flashFX = StartEntityFXWithHandle( predictedRedirectedProjectile, TRANSLOCATION_DROP_TO_GROUND_ACTIVATE_FX, FX_PATTACH_ABSORIGIN_FOLLOW, -1 )

	FXHandle lineFX = StartWorldFXWithHandle( TRANSLOCATION_DROP_TO_GROUND_DESTINATION_FX, currentProjectilePos, <0, predictedRedirectedProjectile.GetAngles().y, 0> )
	entity lineFXEnt = StartWorldFXWithHandleReturnEnt( TRANSLOCATION_DROP_TO_GROUND_DESTINATION_FX, currentProjectilePos, <0, predictedRedirectedProjectile.GetAngles().y, 0> )
	
	#if SERVER
	EffectSetControlPointVector( lineFXEnt, 1, tr.endPos )
	#elseif CLIENT
	EffectSetControlPointVector( lineFX, 1, tr.endPos )
	#endif

	OnThreadEnd( function () : ( flashFX, lineFX ) {
		CleanupFXHandle( flashFX )
		CleanupFXHandle( lineFX )
	} )

	wait 2.0
}
#endif


#if CLIENT
void function StartVisualEffect( entity player, int statusEffect, bool actuallyChanged )
{
	if ( player != GetLocalViewPlayer() || (GetLocalViewPlayer() == GetLocalClientPlayer() && !actuallyChanged) )
		return

	thread (void function() : ( player, statusEffect ) {
		EndSignal( player, "OnDeath" )
		EndSignal( player, "Translocation_StopVisualEffect" )

		int fxHandle = StartParticleEffectOnEntityWithPos( player,
			GetParticleSystemIndex( TRANSLOCATION_WARP_SCREEN_FX ),
			FX_PATTACH_ABSORIGIN_FOLLOW, -1, player.EyePosition(), <0, 0, 0> )

		EffectSetIsWithCockpit( fxHandle, true )

		OnThreadEnd( function() : ( fxHandle ) {
			CleanupFXHandle( fxHandle, false, true )
		} )

		while( true )
		{
			if ( !EffectDoesExist( fxHandle ) )
				break

			float severity = StatusEffect_GetSeverity( player, statusEffect )
			//
			EffectSetControlPointVector( fxHandle, 1, <severity, 999, 0> )

			WaitFrame()
		}
	})()
}
#endif


#if SERVER || CLIENT
entity function GetCurrentTranslocationProjectile( entity owner, entity weapon )
{
	#if SERVER










#elseif CLIENT
		if ( IsValid( weapon.w.translocate_predictedRedirectedProjectile ) )
		{
			return weapon.w.translocate_predictedRedirectedProjectile
		}
		else if ( IsValid( weapon.w.translocate_predictedInitialProjectile ) )
		{
			return weapon.w.translocate_predictedInitialProjectile
		}
		else
		{
			entity serverProjectile = owner.GetPlayerNetEnt( "Translocation_ActiveProjectile" )
			if ( IsValid( serverProjectile ) )
				return serverProjectile
		}
	#endif

	return null
}
#endif


#if CLIENT
void function StopVisualEffect( entity player, int statusEffect, bool actuallyChanged )
{
	if ( player != GetLocalViewPlayer() || (GetLocalViewPlayer() == GetLocalClientPlayer() && !actuallyChanged) )
		return

	player.Signal( "Translocation_StopVisualEffect" )
}
#endif


#if CLIENT
float function GetLobaTacticalEstimatedMaxDistance()
{
	return GetCurrentPlaylistVarFloat( "loba_tactical_estimated_max_distance", 72.0 )
}
#endif


#if SERVER || CLIENT
bool function GetLobaTacticalAllowDropToGround()
{
	return GetCurrentPlaylistVarBool( "loba_tactical_allow_drop_to_ground", true )
}
#endif


#if SERVER || CLIENT
bool function GetLobaTacticalAllowMantle()
{
	return GetCurrentPlaylistVarBool( "loba_tactical_allow_mantle", true )
}
#endif


#if SERVER || CLIENT
bool function GetLobaTacticalAllowZiplineWhileDeployed()
{
	return GetCurrentPlaylistVarBool( "loba_tactical_allow_zipline_while_deployed", false )
}
#endif


#if SERVER || CLIENT
bool function GetLobaTacticalAllowDeployWhileZiplining()
{
	return GetCurrentPlaylistVarBool( "loba_tactical_allow_deploy_while_ziplining", true )
}
#endif


