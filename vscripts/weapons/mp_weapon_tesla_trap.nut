untyped

global function MpWeaponTeslaTrap_Init
global function OnWeaponAttemptOffhandSwitch_weapon_tesla_trap
global function OnWeaponActivate_weapon_tesla_trap
global function OnWeaponDeactivate_weapon_tesla_trap
global function OnWeaponOwnerChanged_weapon_tesla_trap
global function OnWeaponPrimaryAttack_weapon_tesla_trap
global function CodeCallback_TeslaTrapCrossed

#if SERVER
#endif // SERVER

#if CLIENT
global function TeslaTrap_AreTrapsLinked
global function ClientCodeCallback_TeslaTrapLinked
global function ClientCodeCallback_TeslaTrapVisibilityChanged
global function RegisterTeslaTrapMinimapRui
global function TeslaTrap_OnPlayerTeamChanged
#endif //

global const string TESLA_TRAP_NAME = "tesla_trap"
global const string TESLA_TRAP_PROXY_NAME = "tesla_trap_proxy"
const int TESLA_TRAP_MAX_TRAPS = 12

const asset TESLA_TRAP_FX = $"P_wpn_arcTrap"
const asset TESLA_TRAP_IDLE_FX = $"P_arcTrap_light"
const asset TESLA_TRAP_START_FX = $"P_tesla_trap_start"
const asset TESLA_TRAP_ZAP_FX = $"P_tesla_trap_link_zap"
const asset TESLA_TRAP_LINK_FX = $"P_tesla_trap_link_CP"
const asset TESLA_TRAP_LINK_ENEMY_FX = $"P_tesla_trap_link_CP"
const asset TESLA_TRAP_DAMAGE_SPARK_FX = $"P_tesla_trap_dmg"
const asset TESLA_TRAP_DESTROY_FX = $"P_tesla_trap_exp"
const asset TESLA_TRAP_DESTROY_CLOSED_FX = $"P_tesla_trap_closed_exp"
const asset TESLA_TRAP_PLACE_FX = $"P_tesla_trap_place"

#if CLIENT
const asset TESLA_TRAP_PLACE_RANGE_FX = $"P_tesla_trap_ar_place"
#endif // CLIENT

const string TESLA_TRAP_PLACEMENT_SOUND = "wattson_tactical_c"

const string TESLA_TRAP_ACTIVATE_SOUND = "wattson_tactical_d"
const string TESLA_TRAP_POLE_RISE_SOUND = "wattson_tactical_e"

const string TESLA_TRAP_LINK_ACTIVE_SOUND = "wattson_tactical_f"
const string TESLA_TRAP_LINK_SEGMENT_SOUND = "wattson_tactical_g"
const string TESLA_TRAP_LINK_POST_SOUND = "wattson_tactical_j"
const string TESLA_TRAP_LINK_LOOP_SOUND = "wattson_tactical_k"

const string TESLA_TRAP_LINK_OBSTRUCT_SOUND = "wattson_tactical_h"
const string TESLA_TRAP_LINK_RECONNECT_POST_SOUND = "wattson_tactical_i"
const string TESLA_TRAP_LINK_RECONNECT_POST_ENEMY_SOUND = "wattson_tactical_i_enemy"
const string TESLA_TRAP_LINK_RECONNECT_SEGMENT_SOUND = "wattson_tactical_g"

const string TESLA_TRAP_DISSOLVE_SOUND = "wattson_tactical_l"

const string TESLA_TRAP_LINK_DAMAGE_1P_SOUND = "wattson_tactical_m_1p"
const string TESLA_TRAP_LINK_DAMAGE_3P_SOUND = "wattson_tactical_m_3p"

const string TESLA_TRAP_POST_COLLAPSE_SOUND = "wattson_tactical_o"

const string TESLA_TRAP_DESTROY_SOUND = "wattson_tactical_p"
const string TESLA_TRAP_DAMAGE_SPARK_SOUND = "wattson_tactical_q"

const asset TESLA_TRAP_MODEL = $"mdl/props/gibraltar_bubbleshield/gibraltar_bubbleshield.rmdl"
const asset TESLA_TRAP_PROXY_MODEL = $"mdl/props/wattson_electric_fence/wattson_electric_fence.rmdl"
const asset TESLA_TRAP_POLE_MODEL = $"mdl/props/pathfinder_zipline/pathfinder_zipline.rmdl"
const asset TESLA_TRAP_TRIGGER_RADIUS_MODEL = $"mdl/weapons_r5/weapon_tesla_trap/mp_weapon_tesla_trap_ar_trigger_radius.rmdl"

const string TESLA_TRAP_WARNING_SOUND = "weapon_vortex_gun_explosivewarningbeep"

const float TESLA_TRAP_CANCEL_DELAY = 0.1

const float TESLA_TRAP_PLACEMENT_RANGE_MAX = 198//
const float TESLA_TRAP_PLACEMENT_RANGE_MIN = 0
const float TESLA_TRAP_PLACEMENT_SPACING_MIN = 64
const float TESLA_TRAP_PLACEMENT_SPACING_MIN_SQR = TESLA_TRAP_PLACEMENT_SPACING_MIN * TESLA_TRAP_PLACEMENT_SPACING_MIN
const vector TESLA_TRAP_BOUND_MINS = <-8, -8, 0>
const vector TESLA_TRAP_BOUND_MAXS = <8, 8, 16>
const vector TESLA_TRAP_PLACEMENT_TRACE_OFFSET = <0, 0, 128>//
const float TESLA_TRAP_PLACEMENT_MAX_HEIGHT_DELTA = 8.0

const float TESLA_TRAP_HEALTH = 25
const float TESLA_TRAP_ANGLE_LIMIT = 0.55
const float TESLA_TRAP_RADIUS = 256.0
const float TESLA_TRAP_DEPLOY_DELAY = 1.0

const float TESLA_TRAP_RISE_DURATION = 0.5
const float TESLA_TRAP_RISE_HEIGHT = 40.0
const float TESLA_TRAP_DROP_DURATION = 0.5
const float TESLA_TRAP_DURATION = 0.6
const float TESLA_TRAP_COOLDOWN = 6.0
const float TESLA_TRAP_ACTIVATE_DELAY = 1.0
const float TESLA_TRAP_CONE_HEIGHT_OFFSET = 24.0

const float TESLA_TRAP_LINK_HEIGHT = 24.0
const float TESLA_TRAP_LINK_DIST = 768.0//
const float TESLA_TRAP_LINK_CANCEL_DIST = 1024.0
const float TESLA_TRAP_LINK_SNAP_DIST = 98.0
const float TESLA_TRAP_LINK_DIST_SQR = TESLA_TRAP_LINK_DIST * TESLA_TRAP_LINK_DIST
const int TESLA_TRAP_LINK_COUNT_MAX = 2
const int TESLA_TRAP_LINK_FX_COUNT = 4
const int TESLA_TRAP_LINK_FX_MIN = 3
const float TESLA_TRAP_LINK_MAX_DOT = 0.95
const float TESLA_TRAP_LINK_MIN_VIEW_RATING = 0.95
const float TESLA_TRAP_LINK_MAX_GROUND_DIST = 64.0
const float TESLA_TRAP_LINK_GROUND_CHECK_INTERVAL = 64.0
const int TESLA_TRAP_LINK_GROUND_CHECK_FAIL_COUNT = 2

const int TESLA_TRAP_LINK_DAMAGE_AMOUNT = 10
const int TESLA_TRAP_LINK_DAMAGE_AMOUNT_HEAVY_ARMOR = 250
const float TESLA_TRAP_LINK_DAMAGE_DIST_MIN = 16.0
const float TESLA_TRAP_LINK_DAMAGE_DIST_MIN_SQR = TESLA_TRAP_LINK_DAMAGE_DIST_MIN * TESLA_TRAP_LINK_DAMAGE_DIST_MIN
const float TESLA_TRAP_LINK_DAMAGE_DIST_MAX = 16.0
const float TESLA_TRAP_LINK_DAMAGE_DIST_MAX_SQR = TESLA_TRAP_LINK_DAMAGE_DIST_MAX * TESLA_TRAP_LINK_DAMAGE_DIST_MAX
const float TESLA_TRAP_LINK_DAMAGE_INTERVAL = 0.5

const float TESLA_TRAP_POSE_PARAMETER_HEIGHT_MAX = 5.0

const float TESLA_TRAP_LINK_PING_INTERVAL = 3.0

const float TESLA_TRAP_LINK_TRIGGER_RADIUS = 96.0

const float TESLA_TRAP_PING_VO_DBOUNCE = 6.0
const float TESLA_TRAP_LINK_VO_DBOUNCE = 3
const float TESLA_TRAP_PLACEMENT_END_VO_DBOUNCE = 15.0
const float TESLA_TRAP_CONSIDERED_FAR_DIST = 2953 //

const bool TESLA_TRAP_DEBUG_DRAW = false
const bool TESLA_TRAP_DEBUG_DRAW_PLACEMENT = false
const bool TESLA_TRAP_DEBUG_DRAW_GROUND_CLAMP_PLACEMENT = false
const bool TESLA_TRAP_DEBUG_DRAW_GROUND_CLEARANCE = false
const bool TESLA_TRAP_DEBUG_DRAW_POST_INTERSECTION = false

const int TESLA_TRAP_TRACE_MASK = TRACE_MASK_SHOT & ~TRACE_MASK_WATER

enum eDeployLinkFlags
{
	DLF_NONE 			= 0,
	DLF_FAIL			= 1,
	DLF_CAN_LINK		= 2,
}

#if CLIENT
const float TESLA_TRAP_ICON_HEIGHT = 16.0
const bool TESLA_TRAP_DEBUG_DRAW_CLIENT_TRAP_LINKING = false
#endif //

const asset TESLA_TRAP_ACTIVATED_ICON = $"rui/hud/tactical_icons/wattson_trap_enemy_collided"

struct TeslaTrapPlacementInfo
{
	entity 	connectionOwner
	vector 	origin
	vector 	angles
	entity 	parentTo
	entity 	snapTo
	entity 	forceLinkTo
	int 	beamCount = 0
	int 	deployLinkState = eDeployLinkFlags.DLF_NONE
	bool   	success = false
}

struct TeslaTrapPlayerPlacementData
{
	int    maxLinks
	vector viewOrigin
	vector viewForward
	vector playerOrigin 
	vector playerForward

}

struct TeslaTrapSortingData
{
	entity trap
	float  sortingRating
	float  distSqr
}

struct FramePlacementInfo
{
	float 	frameTime
	TeslaTrapPlacementInfo& placementInfo
}

#if SERVER
#endif //

#if CLIENT
struct TrapMinimapData
{
	array<var> ruiArray
	array<entity> triggerArray
}
#endif //

struct
{
	#if SERVER
	#endif //

	table< entity, TeslaTrapSortingData > trapSortingData    //
	table< entity, entity >               focalTrap
	FramePlacementInfo&					  framePlacementInfo

	entity 								  proxyEnt

	#if CLIENT
		array<entity>                       allTraps
		table< int, array< int > >          linkFXs_client
		table< int, entity >                linkAGs_client
		int                                 currentFXID = 0
		entity                              recalTrap
		table< entity, var >				trapRui
		table< entity, TrapMinimapData >    trapMinimapData
		float 								proxyBaseOffset = -1.0
	#endif // CLIENT

	//
	array<string> parentToRoot = [
		"_hover_tank_interior"
	]

} file



function MpWeaponTeslaTrap_Init()
{
	PrecacheParticleSystem( TESLA_TRAP_FX )
	PrecacheParticleSystem( TESLA_TRAP_START_FX )
	PrecacheParticleSystem( TESLA_TRAP_IDLE_FX )
	PrecacheParticleSystem( TESLA_TRAP_ZAP_FX )
	PrecacheParticleSystem( TESLA_TRAP_LINK_FX )
	PrecacheParticleSystem( TESLA_TRAP_LINK_ENEMY_FX )
	PrecacheParticleSystem( TESLA_TRAP_DAMAGE_SPARK_FX )
	PrecacheParticleSystem( TESLA_TRAP_DESTROY_FX )
	PrecacheParticleSystem( TESLA_TRAP_DESTROY_CLOSED_FX )
	PrecacheParticleSystem( TESLA_TRAP_PLACE_FX )

	PrecacheModel( TESLA_TRAP_MODEL )
	PrecacheModel( TESLA_TRAP_PROXY_MODEL )
	PrecacheModel( TESLA_TRAP_POLE_MODEL )
	PrecacheModel( TESLA_TRAP_TRIGGER_RADIUS_MODEL )

	#if SERVER
	#endif //

	#if CLIENT
		PrecacheParticleSystem( TESLA_TRAP_PLACE_RANGE_FX )
		StatusEffect_RegisterEnabledCallback( eStatusEffect.placing_tesla_trap, TeslaTrap_OnBeginPlacement )
		StatusEffect_RegisterDisabledCallback( eStatusEffect.placing_tesla_trap, TeslaTrap_OnEndPlacement )
		AddCreateCallback( "prop_script", TeslaTrap_OnPropScriptCreated )
		AddDestroyCallback( "prop_script", TeslaTrap_OnPropScriptDestroyed )

		AddCreateCallback( "trigger_cylinder_heavy", TeslaTrap_OntriggerCreated )
		AddDestroyCallback( "trigger_cylinder_heavy", TeslaTrap_OntriggerDestroyed )

		RegisterSignal( "TeslaTrap_StopFocalTrapUpdate" )
		RegisterSignal( "TeslaTrap_StopFocalTrapCancelUpdate" )
		RegisterSignal( "TeslaTrap_StopPlacementProxy" )
		RegisterSignal( "TeslaTrap_StopHudIconUpdate" )

		// RegisterNetworkedVariableChangeCallback_ent( "focalTrap", OnFocusTrapChanged )

		AddCallback_PlayerClassActuallyChanged( TeslaTrap_OnPlayerClassChanged )
		AddCallback_OnPlayerChangedTeam( TeslaTrap_OnPlayerTeamChanged )
	#endif // CLIENT
}

#if SERVER
#endif // SERVER

#if CLIENT
void function TeslaTrap_OnPlayerClassChanged( entity player )
{
	entity localViewPlayer = GetLocalViewPlayer()
	entity localClientPlayer = GetLocalClientPlayer()
	bool playerIsLocalViewPlayer = (player == localViewPlayer)

	if ( playerIsLocalViewPlayer )
	{
		player.Signal( "TeslaTrap_StopFocalTrapUpdate" )
		player.Signal( "TeslaTrap_StopHudIconUpdate" )
	}
}
#endif // CLIENT

void function OnWeaponActivate_weapon_tesla_trap( entity weapon )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	Assert( ownerPlayer.IsPlayer() )
	#if CLIENT
		ownerPlayer.Signal( "TeslaTrap_StopFocalTrapUpdate" )

		//
		thread TeslaTrap_MaxDistanceAutoCancelUpdate( ownerPlayer )

		if ( !InPrediction() ) //
			return
	#endif

	int statusEffect = eStatusEffect.placing_tesla_trap
	StatusEffect_AddEndless( ownerPlayer, statusEffect, 1.0 )

	#if SERVER
	#endif
}

void function OnWeaponDeactivate_weapon_tesla_trap( entity weapon )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	Assert( ownerPlayer.IsPlayer() )
	#if CLIENT
		thread TeslaTrap_TrackFocalTrapForPlayer( ownerPlayer )
		ownerPlayer.Signal( "TeslaTrap_StopFocalTrapCancelUpdate" )

		if ( !InPrediction() ) //
			return
	#endif //

	StatusEffect_StopAllOfType( ownerPlayer, eStatusEffect.placing_tesla_trap )

	#if SERVER
	#endif // SERVER
}

void function OnWeaponOwnerChanged_weapon_tesla_trap( entity weapon, WeaponOwnerChangedParams changeParams )
{
	if ( IsValid( changeParams.oldOwner ) && changeParams.oldOwner in file.focalTrap )
		delete file.focalTrap[ changeParams.oldOwner ]

	#if CLIENT
		if ( IsValid( changeParams.oldOwner ) && IsValid( changeParams.newOwner ) )
		{
			changeParams.oldOwner.Signal( "TeslaTrap_StopFocalTrapUpdate" )
			changeParams.oldOwner.Signal( "TeslaTrap_StopHudIconUpdate" )
		}

		if ( IsValid( changeParams.newOwner ) && changeParams.newOwner == GetLocalViewPlayer() )
		{
			thread TeslaTrap_TrackFocalTrapForPlayer( changeParams.newOwner )
			thread TeslaTrap_UpdateHudMarkers( changeParams.newOwner )
		}
	#endif // SERVER
}

bool function OnWeaponAttemptOffhandSwitch_weapon_tesla_trap( entity weapon )
{
	//
	entity ownerPlayer = weapon.GetWeaponOwner()
	Assert( ownerPlayer.IsPlayer() )

	//
	if ( Bleedout_IsBleedingOut( ownerPlayer ) )
		return false

	entity player = weapon.GetWeaponOwner()
	if ( player.IsPhaseShifted() )
		return false

	//
	if ( player.IsZiplining() )
		return false

	asset model  = TESLA_TRAP_PROXY_MODEL
	entity proxy = TeslaTrap_CreateTrapPlacementProxy( model )

	TeslaTrap_UpdateFocalNodeForPlayer( ownerPlayer, proxy )

	if ( weapon == ownerPlayer.GetActiveWeapon( eActiveInventorySlot.mainHand ) )
		return true //

	//
	if ( !TeslaTrap_PlayerHasFocalTrap( ownerPlayer ) )
	{
		int ammoReq  = weapon.GetAmmoPerShot()
		int currAmmo = weapon.GetWeaponPrimaryClipCount()
		if ( currAmmo < ammoReq )
			return false
	}

#if SERVER
#endif // SERVER

	#if CLIENT
		ownerPlayer.Signal( "TeslaTrap_StopFocalTrapUpdate" )
	#endif // CLIENT

	return true
}

var function OnWeaponPrimaryAttack_weapon_tesla_trap( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	Assert( ownerPlayer.IsPlayer() )

	asset model = TESLA_TRAP_PROXY_MODEL

	entity proxy                         = TeslaTrap_CreateTrapPlacementProxy( model )
	TeslaTrapPlacementInfo placementInfo = TeslaTrap_GetPlacementInfo( ownerPlayer, proxy )

	if ( !placementInfo.success )
		return 0

	//
	int ammoReq  = weapon.GetAmmoPerShot()
	int currAmmo = weapon.GetWeaponPrimaryClipCount()
	if ( currAmmo < ammoReq && !IsValid( placementInfo.snapTo ) )
	{
		#if CLIENT
			printf( "mp_weapon_tesla_trap: No more ammo before placing trap. Switching out with 'invnext'." )
			ownerPlayer.ClientCommand( "invnext" )
		#endif //

		return 0
	}

	PlayerUsedOffhand( ownerPlayer, weapon, true, null, {pos = placementInfo.origin} )

	if ( IsValid( placementInfo.snapTo ) )
	{
		#if CLIENT
			if ( currAmmo < ammoReq )
			{
				printf( "mp_weapon_tesla_trap: No more ammo after placing trap. Switching out with 'invnext'." )
				ownerPlayer.ClientCommand( "invnext" )
			}
		#endif // CLIENT

		return 0
	}

	else
		printf("aaaaaaa")
		#if SERVER		
			thread WeaponMakesTeslaTrap(weapon, TESLA_TRAP_MODEL, placementInfo)
			// TODO: only play this line the first time place places her fence per tac use
			PlayBattleChatterLineToSpeakerAndTeam( ownerPlayer, "bc_tactical" )
		#endif 
		return  weapon.GetAmmoPerShot()
}

TeslaTrapPlacementInfo function TeslaTrap_GetPlacementInfo( entity player, entity proxy, bool ignorePlacedTraps = false, int maxFallbacks = 3 )
{
	if ( IsValid( file.framePlacementInfo ) )
	{
		if ( file.framePlacementInfo.frameTime == Time() )
			return file.framePlacementInfo.placementInfo
	}

	vector eyePos  = player.EyePosition()
	vector viewVec = player.GetViewVector()
	vector angles  = < 0, VectorToAngles( viewVec ).y, 0 >

	float maxRange = TESLA_TRAP_PLACEMENT_RANGE_MAX

	array<entity> ignoreEnts = TeslaTrap_GetAllDead()
	ignoreEnts.extend( GetFriendlySquadArrayForPlayer_AliveConnected( player ) )
	ignoreEnts.append( player )
	ignoreEnts.append( proxy )

	if ( ignorePlacedTraps )
		ignoreEnts.extend( TeslaTrap_GetAll() )

	TraceResults viewTraceResults = TraceLine( eyePos, eyePos + player.GetViewVector() * (TESLA_TRAP_PLACEMENT_RANGE_MAX * 2), ignoreEnts, TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_NONE )
	if ( viewTraceResults.fraction < 1.0 )
	{
		float slope = fabs( viewTraceResults.surfaceNormal.x ) + fabs( viewTraceResults.surfaceNormal.y )
		if ( slope < TESLA_TRAP_ANGLE_LIMIT )
			maxRange = min( Distance( eyePos, viewTraceResults.endPos ), TESLA_TRAP_PLACEMENT_RANGE_MAX )
	}

	vector idealPos          = player.GetOrigin() + (AnglesToForward( angles ) * TESLA_TRAP_PLACEMENT_RANGE_MAX)
	TraceResults fwdResults  = TraceHull( eyePos + viewVec * min( TESLA_TRAP_PLACEMENT_RANGE_MIN, maxRange ), eyePos + viewVec * maxRange, TESLA_TRAP_BOUND_MINS, TESLA_TRAP_BOUND_MAXS, ignoreEnts, TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_NONE )
	TraceResults downResults = TraceHull( fwdResults.endPos, fwdResults.endPos - TESLA_TRAP_PLACEMENT_TRACE_OFFSET, TESLA_TRAP_BOUND_MINS, TESLA_TRAP_BOUND_MAXS, ignoreEnts, TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_NONE )

	if ( TESLA_TRAP_DEBUG_DRAW_PLACEMENT )
	{
		DebugDrawBox( fwdResults.endPos, TESLA_TRAP_BOUND_MINS, TESLA_TRAP_BOUND_MAXS, 0, 255, 0, 1, 1.0 ) //
		DebugDrawBox( downResults.endPos, TESLA_TRAP_BOUND_MINS, TESLA_TRAP_BOUND_MAXS, 0, 0, 255, 1, 1.0 ) //
		DebugDrawLine( eyePos + viewVec * min( TESLA_TRAP_PLACEMENT_RANGE_MIN, maxRange ), fwdResults.endPos, 0, 255, 0, true, 1.0 ) //
		DebugDrawLine( fwdResults.endPos, eyePos + viewVec * maxRange, 255, 0, 0, true, 1.0 ) //
		DebugDrawLine( fwdResults.endPos, downResults.endPos, 0, 0, 255, true, 1.0 ) //
		DebugDrawLine( player.GetOrigin(), player.GetOrigin() + (AnglesToForward( angles ) * TESLA_TRAP_PLACEMENT_RANGE_MAX), 0, 255, 0, true, 1.0 ) //
		DebugDrawLine( eyePos + <0, 0, 8>, eyePos + <0, 0, 8> + (viewVec * TESLA_TRAP_PLACEMENT_RANGE_MAX), 0, 255, 0, true, 1.0 ) //

		DebugDrawLine( eyePos + <0, 0, 4>, viewTraceResults.endPos + <0, 0, 4>, 0, 255, 0, true, 1.0 ) //
	}

	TeslaTrapPlacementInfo placementInfo = TeslaTrap_GetPlacementInfoFromTraceResults( player, proxy, downResults, viewTraceResults, ignoreEnts, idealPos )

	int attempts       = 0
	vector fallbackPos = fwdResults.endPos
	while ( !placementInfo.success && attempts < maxFallbacks )
	{
		fallbackPos = fallbackPos - (viewVec * (Length( TESLA_TRAP_BOUND_MINS )))
		TraceResults downFallbackResults = TraceHull( fallbackPos, fallbackPos - TESLA_TRAP_PLACEMENT_TRACE_OFFSET, TESLA_TRAP_BOUND_MINS, TESLA_TRAP_BOUND_MAXS, ignoreEnts, TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_NONE )

		if ( TESLA_TRAP_DEBUG_DRAW_PLACEMENT )
		{
			DebugDrawBox( downFallbackResults.endPos, TESLA_TRAP_BOUND_MINS, TESLA_TRAP_BOUND_MAXS, 255, 0, 0, 1, 1.0 ) //
		}

		placementInfo = TeslaTrap_GetPlacementInfoFromTraceResults( player, proxy, downFallbackResults, viewTraceResults, ignoreEnts, idealPos )
		attempts++
	}

	if ( placementInfo.success && TeslaTrap_PlayerHasFocalTrap( player ) && !IsValid( placementInfo.snapTo ) )
	{
		entity focalTrap = TeslaTrap_GetFocalTrapForPlayer( player )
		if ( !TeslaTrap_CanDeploy( proxy, placementInfo.origin, AnglesToUp( placementInfo.angles ), focalTrap, placementInfo ) )
			placementInfo.success = false
	}

	FramePlacementInfo framePlacementInfo
	framePlacementInfo.frameTime = Time()
	framePlacementInfo.placementInfo = placementInfo
	file.framePlacementInfo = framePlacementInfo

	return placementInfo
}

TeslaTrapPlacementInfo function TeslaTrap_GetPlacementInfoFromTraceResults( entity player, entity proxy, TraceResults hullTraceResults, TraceResults viewTraceResults, array<entity> ignoreEnts, vector idealPos )
{
	vector viewVec = player.GetViewVector()
	vector angles  = < 0, VectorToAngles( viewVec ).y, 0 >

	bool isScriptedPlaceable = false
	if ( IsValid( hullTraceResults.hitEnt ) )
	{
		var hitEntClassname = hullTraceResults.hitEnt.GetNetworkedClassName()
		if ( hitEntClassname == "func_brush" || hitEntClassname == "script_mover" || hitEntClassname == "func_brush_lightweight" )
		{
			isScriptedPlaceable = true
		}
		else if ( hitEntClassname == "prop_script" )
		{
			if ( hullTraceResults.hitEnt.GetScriptPropFlags() == PROP_IS_VALID_FOR_TURRET_PLACEMENT )
				isScriptedPlaceable = true
		}
	}


	bool success = !hullTraceResults.startSolid && hullTraceResults.fraction < 1.0 && (hullTraceResults.hitEnt.IsWorld() || isScriptedPlaceable)

	entity parentTo
	if ( IsValid( hullTraceResults.hitEnt ) && (hullTraceResults.hitEnt.GetNetworkedClassName() == "func_brush" || hullTraceResults.hitEnt.GetNetworkedClassName() == "script_mover" || hullTraceResults.hitEnt.GetNetworkedClassName() == "func_brush_lightweight") )
	{
		parentTo = hullTraceResults.hitEnt

		if ( file.parentToRoot.contains( parentTo.GetScriptName() ) )
		{
			entity parentAbove = parentTo.GetParent()
			while ( IsValid( parentAbove ) )
			{
				parentTo = parentAbove
				parentAbove = parentTo.GetParent()
			}
		}
	}

	vector surfaceAngles = angles
	vector proxyTestPos = <0, 0, 0>
	vector proxyTestAngles = <0, 0, 0>

	if ( success )
	{
		#if CLIENT
			proxy.SetOrigin( hullTraceResults.endPos )
			proxy.SetAngles( surfaceAngles )
		#endif

		proxyTestPos = hullTraceResults.endPos
		proxyTestAngles = surfaceAngles
	}

	if ( success && hullTraceResults.hitEnt != null && (!hullTraceResults.hitEnt.IsWorld() && !isScriptedPlaceable) )
	{
		surfaceAngles = angles
		success = false
	}

	if ( success && !TeslaTrap_PlayerReachPos( player, hullTraceResults.endPos, true, 90, ignoreEnts ) )
	{
		surfaceAngles = angles
		success = false
	}

	vector surfaceNormals = <0, 0, 0>
	if ( success && hullTraceResults.fraction < 1.0 )
	{
		vector up      	= hullTraceResults.surfaceNormal
		vector forward 	= CrossProduct( up, <1, 0, 0> )
		vector right 	= CrossProduct( forward, up )

		float length = Length( TESLA_TRAP_BOUND_MINS )

		array< vector > groundTestOffsets = [
			<0, 0, 0>,
			(-right * 6) + (forward * 6),
			(-right * 6) + (-forward * 6),
			(right * 6) + (forward * 6),
			(right * 6) + (-forward * 6),
		]

		surfaceAngles = <0, 0, 0>
		vector testNormal = <0, 0, 1>
		vector bestNormal = <0, 0, -1>
		float bestDot     = -1.0
		foreach ( int i, vector testOffset in groundTestOffsets )
		{
			vector testPos           = proxyTestPos + testOffset
			TraceResults traceResult = TraceLine( testPos + (up * TESLA_TRAP_PLACEMENT_MAX_HEIGHT_DELTA), testPos + (up * -TESLA_TRAP_PLACEMENT_MAX_HEIGHT_DELTA), ignoreEnts, TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_NONE )

			if ( TESLA_TRAP_DEBUG_DRAW_GROUND_CLAMP_PLACEMENT )
			{
				DebugDrawLine( testPos, traceResult.endPos, 255, 0, 0, true, 0.05 )
			}

			float dot = DotProduct( testNormal, traceResult.surfaceNormal )

			if ( dot >= bestDot )
			{
				bestDot = dot
				bestNormal = traceResult.surfaceNormal

				if ( bestDot >= 0.8 )
					break
			}
		}

		surfaceNormals = bestNormal
		surfaceAngles = AnglesOnSurface( bestNormal, AnglesToRight( angles ) )
	}

	if ( hullTraceResults.fraction < 1.0 )
	{
		surfaceAngles = AnglesOnSurface( surfaceNormals, angles )
		vector newUpDir = AnglesToUp( surfaceAngles )
		vector oldUpDir = AnglesToUp( angles )

		if ( DotProduct( newUpDir, oldUpDir ) < TESLA_TRAP_ANGLE_LIMIT )
		{
			surfaceAngles = angles
			success = false
		}
	}

	if ( success )
	{
		#if CLIENT
			proxy.SetOrigin( hullTraceResults.endPos )
			proxy.SetAngles( surfaceAngles )
		#endif

		proxyTestPos = hullTraceResults.endPos
		proxyTestAngles = surfaceAngles

		TraceResults traceResult = TraceLine( proxyTestPos + (hullTraceResults.surfaceNormal * 2), proxyTestPos + (hullTraceResults.surfaceNormal * -2), ignoreEnts, TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_NONE )
		if ( traceResult.fraction == 1.0 )
		{
			surfaceAngles = angles
			success = false
		}
	}

	if ( success )
	{
		vector startPos = hullTraceResults.endPos + (surfaceNormals * TESLA_TRAP_LINK_HEIGHT * 0.5)
		vector endPos = hullTraceResults.endPos + (surfaceNormals * (TESLA_TRAP_LINK_HEIGHT * TESLA_TRAP_LINK_FX_COUNT))
		TraceResults clearanceTraceResults = TraceLineHighDetail( startPos, endPos, ignoreEnts, TESLA_TRAP_TRACE_MASK, TRACE_COLLISION_GROUP_NONE )

		float height = (TESLA_TRAP_LINK_HEIGHT * TESLA_TRAP_LINK_FX_COUNT) * clearanceTraceResults.fraction
		int linkCount = int( height / TESLA_TRAP_LINK_HEIGHT )
		success = success && linkCount >= TESLA_TRAP_LINK_FX_MIN

	}


	TeslaTrapPlacementInfo placementInfo
	placementInfo.connectionOwner = player
	placementInfo.success = success
	placementInfo.origin = hullTraceResults.endPos
	placementInfo.angles = surfaceAngles
	placementInfo.parentTo = parentTo

	bool canSnap = TelsaTrap_AttemptSnapToNeighbor( player, hullTraceResults.endPos, placementInfo )

	if ( success && TeslaTrap_PlayerHasFocalTrap( player ) && !canSnap )
	{
		entity focalTrap = TeslaTrap_GetFocalTrapForPlayer( player )
		if ( !TeslaTrap_CanLink( proxy, placementInfo.origin, AnglesToUp( placementInfo.angles ), focalTrap, placementInfo ) )
		{
			placementInfo.success = false
			placementInfo.deployLinkState = eDeployLinkFlags.DLF_FAIL
		}
	}

	return placementInfo
}

bool function TeslaTrap_PlayerReachPos( entity player, vector pos, bool doTrace, float degrees, array<entity> ignoreEnts )
{
	float minDot = deg_cos( degrees )
	float dot    = DotProduct( Normalize( pos - player.EyePosition() ), player.GetViewVector() )
	if ( dot < minDot )
		return false

	if ( doTrace )
	{
		TraceResults trace = TraceLine( player.EyePosition(), pos, ignoreEnts, TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_NONE )
		if ( trace.fraction < 0.99 )
			return false
	}

	return true
}

bool function TeslaTrap_OriginTooCloseToNeighbor( vector origin )
{
	array<entity> traps = TeslaTrap_GetAll()
	foreach ( entity trap in traps )
	{
		float distSqr = DistanceSqr( origin, trap.GetOrigin() )
		if ( distSqr <= TESLA_TRAP_PLACEMENT_SPACING_MIN_SQR )
			return true
	}

	return false
}

bool function TelsaTrap_AttemptSnapToNeighbor( entity player, vector origin, TeslaTrapPlacementInfo placementInfo )
{
	if ( !TeslaTrap_PlayerHasFocalTrap( player ) )
		return false

	entity focalTrap = TeslaTrap_GetFocalTrapForPlayer( player )

	entity closestTrap
	float closestDist = TESLA_TRAP_PLACEMENT_SPACING_MIN_SQR

	array<entity> traps = TeslaTrap_GetAllLinkable()
	foreach ( entity trap in traps )
	{
		if ( trap == focalTrap )
			continue

		float distSqr = DistanceSqr( origin, trap.GetOrigin() )
		if ( distSqr > closestDist )
			continue

		if ( IsValid( placementInfo.parentTo ) && focalTrap.GetParent() != placementInfo.parentTo )
			continue

		if ( TeslaTrap_AreTrapsLinked( focalTrap, trap ) )
			continue

		if ( !TeslaTrap_CanDeploy( focalTrap, focalTrap.GetOrigin(), focalTrap.GetUpVector(), trap, placementInfo ) )
		{
			continue
		}

		int team = player.GetTeam()
		if ( focalTrap.GetTeam() != team && trap.GetTeam() != team )
			continue

		if ( distSqr <= closestDist )
		{
			closestTrap = trap
			closestDist = distSqr
		}
	}

	if ( IsValid( closestTrap ) )
	{
		placementInfo.origin = closestTrap.GetOrigin()
		placementInfo.angles = closestTrap.GetAngles()
		placementInfo.snapTo = closestTrap
		placementInfo.success = true

		return true
	}

	return false
}

entity function TeslaTrap_CreateTrapPlacementProxy( asset modelName )
{
	if ( !IsValid( file.proxyEnt ) )
	{
		#if SERVER
			entity proxy = CreatePropDynamic( modelName, <0, 0, 0>, <0, 0, 0> )
		#else
			entity proxy = CreateClientSidePropDynamic( <0, 0, 0>, <0, 0, 0>, modelName )
		#endif
		proxy.kv.renderamt = 255
		proxy.kv.rendermode = 3
		proxy.kv.rendercolor = "255 255 255 255"
		proxy.Hide()

		file.proxyEnt = proxy
	}
	else
	{
		file.proxyEnt.SetOrigin( <0, 0, 0> )
		file.proxyEnt.SetAngles( <0, 0, 0> )
	}

	return file.proxyEnt
}

#if SERVER
#endif // SERVER

int function TeslaTrap_GetPlacementMaxLinks( entity player )
{
	if ( !IsValid( player ) )
		return -1

	entity weapon = player.GetOffhandWeapon( OFFHAND_TACTICAL )

	if ( !IsValid( weapon ) )
		return -1

	string className = weapon.GetWeaponClassName()
	if ( className != "mp_weapon_tesla_trap" )
		return -1

	if ( weapon.GetScriptFlags0() > 0 )
	{
		array<string> mods = weapon.GetMods()
		foreach ( mod in mods )
		{
			if ( mod == "double_link_mod" )
				return TESLA_TRAP_LINK_COUNT_MAX
		}
	}

	return weapon.GetScriptFlags0()
}

#if CLIENT
void function TeslaTrap_OnBeginPlacement( entity player, int statusEffect, bool actuallyChanged )
{
	if ( player != GetLocalViewPlayer() )
		return

	asset model = TESLA_TRAP_PROXY_MODEL

	thread TeslaTrap_PlacementProxy( player, model )
}

void function TeslaTrap_OnEndPlacement( entity player, int statusEffect, bool actuallyChanged )
{
	if ( player != GetLocalViewPlayer() )
		return

	player.Signal( "TeslaTrap_StopPlacementProxy" )
}

void function TeslaTrap_PlacementProxy( entity player, asset model )
{
	player.EndSignal( "TeslaTrap_StopPlacementProxy" )

	entity proxy = TeslaTrap_CreateTrapPlacementProxy( model )
	proxy.EnableRenderAlways()
	proxy.Show()
	DeployableModelHighlight( proxy )

	var placementRui        = CreateCockpitPostFXRui( $"ui/tesla_trap_placement.rpak", RuiCalculateDistanceSortKey( player.EyePosition(), proxy.GetOrigin() ) )
	int placementAttachment = proxy.LookupAttachment( "BASE_POINT" )

	RuiSetInt( placementRui, "trapLimit", TESLA_TRAP_MAX_TRAPS )
	RuiTrackFloat3( placementRui, "mainTrapPos", proxy, RUI_TRACK_POINT_FOLLOW, placementAttachment )
	RuiKeepSortKeyUpdated( placementRui, true, "mainTrapPos" )

	int attachment = proxy.LookupAttachment( "BASE_POINT" )
	var linkRui    = CreateCockpitRui( $"ui/tesla_trap_link.rpak", 0 )
	RuiSetBool( linkRui, "showAll", false )
	RuiTrackFloat3( linkRui, "mainTrapPos", proxy, RUI_TRACK_POINT_FOLLOW, attachment )
	RuiSetFloat( linkRui, "maxDist", TESLA_TRAP_LINK_DIST )
	RuiKeepSortKeyUpdated( linkRui, true, "otherTrapPos" )

	int fxHandle = -1
	table<entity, int> proxyRangeTable
	proxyRangeTable[ proxy ] <- fxHandle

	OnThreadEnd(
		function() : ( proxy, proxyRangeTable, placementRui, linkRui )
		{
			RuiDestroy( placementRui )
			RuiDestroy( linkRui )

			int fxHandle = proxyRangeTable[ proxy ]
			if ( EffectDoesExist( fxHandle ) )
				EffectStop( fxHandle, true, false )

			if ( IsValid( proxy ) )
				proxy.Hide()

			file.recalTrap = null
		}
	)

	entity lastFocalTrap
	while ( true )
	{
		proxy.ClearParent()
		TeslaTrapPlacementInfo placementInfo = TeslaTrap_GetPlacementInfo( player, proxy )

		proxy.SetOrigin( placementInfo.origin )
		proxy.SetAngles( placementInfo.angles )

		if ( IsValid( placementInfo.parentTo ) )
			proxy.SetParent( placementInfo.parentTo )

		entity weapon = player.GetOffhandWeapon( OFFHAND_TACTICAL )
		int ammoReq   = weapon.GetAmmoPerShot()
		int currAmmo  = weapon.GetWeaponPrimaryClipCount()
		if ( currAmmo < ammoReq && !IsValid( placementInfo.snapTo ) )
			placementInfo.success = false

		array<entity> linkTraps
		bool canRecall = false
		file.recalTrap = null

		bool hasFocalTrap = TeslaTrap_PlayerHasFocalTrap( player )
		if ( hasFocalTrap )
		{
			entity focalTrap = TeslaTrap_GetFocalTrapForPlayer( player )
			linkTraps = TeslaTrap_AttemptTrapLinkOnClient( proxy, focalTrap, placementInfo )

			RuiSetFloat3( linkRui, "otherTrapPos", focalTrap.GetOrigin() + <0, 0, 6> )

			float distSqr = DistanceSqr( placementInfo.origin, focalTrap.GetOrigin() )
			if ( distSqr <= (TESLA_TRAP_PLACEMENT_RANGE_MAX * TESLA_TRAP_PLACEMENT_RANGE_MAX) )
			{
				canRecall = true
				file.recalTrap = focalTrap
			}
		}

		if ( !placementInfo.success )
			DeployableModelInvalidHighlight( proxy )
		else if ( placementInfo.success )
			DeployableModelHighlight( proxy )

		TeslaTrapPlayerPlacementData placementData
		placementData.maxLinks = TeslaTrap_GetPlacementMaxLinks( player )
		placementData.viewOrigin = player.EyePosition()
		placementData.viewForward = player.GetViewForward()
		placementData.playerOrigin = player.GetOrigin()
		placementData.playerForward = FlattenVector( player.GetViewForward() )

		bool tacticalChargeActive = StatusEffect_GetSeverity( player, eStatusEffect.trophy_tactical_charge ) > 0
		RuiSetBool( placementRui, "boostActive", tacticalChargeActive )

		RuiSetBool( placementRui, "success", placementInfo.success )
		RuiSetBool( placementRui, "canRecall", canRecall )
		RuiSetInt( placementRui, "maxLinkCount", placementData.maxLinks )
		RuiSetInt( placementRui, "linkCount", linkTraps.len() )
		RuiSetInt( placementRui, "linkCountAvailable", linkTraps.len() )
		RuiSetInt( placementRui, "trapCount", TeslaTrap_GetOwnedLivingTrapCountOnClient( player ) )
		RuiSetBool( placementRui, "snapTo", IsValid( placementInfo.snapTo ) )

		RuiTrackFloat( placementRui, "chargeFrac", weapon, RUI_TRACK_WEAPON_CLIP_AMMO_FRACTION )

		RuiSetBool( linkRui, "showAll", false )
		RuiSetBool( linkRui, "success", placementInfo.success )

		if ( hasFocalTrap )
		{
			entity focalTrap = TeslaTrap_GetFocalTrapForPlayer( player )

			RuiSetBool( linkRui, "showAll", true )
			RuiSetBool( linkRui, "success", placementInfo.success )
			RuiSetFloat3( linkRui, "otherTrapPos", focalTrap.GetOrigin() + <0, 0, 6> )

			RuiSetBool( linkRui, "showDial", true )

			if ( TESLA_TRAP_DEBUG_DRAW_CLIENT_TRAP_LINKING )
			{
				DebugDrawLine( proxy.GetOrigin(), focalTrap.GetOrigin(), 0, 255, 0, true, 0.1 )
			}

			if ( lastFocalTrap != focalTrap )
			{
				fxHandle = proxyRangeTable[ proxy ]
				if ( EffectDoesExist( fxHandle ) )
				{
					EffectStop( fxHandle, true, false )
					proxyRangeTable[ proxy ] = -1
				}

				fxHandle = StartParticleEffectOnEntity( focalTrap, GetParticleSystemIndex( TESLA_TRAP_PLACE_RANGE_FX ), FX_PATTACH_POINT_FOLLOW, focalTrap.LookupAttachment( "REF" ) )
				proxyRangeTable[ proxy ] = fxHandle
			}

			lastFocalTrap = focalTrap
		}
		else
		{
			//
			if ( EffectDoesExist( fxHandle ) )
			{
				EffectStop( fxHandle, true, false )
				proxyRangeTable[ proxy ] = -1
			}
		}

		WaitFrame()
	}
}
#endif //

/*
███████╗██╗██╗  ██╗    ████████╗██╗  ██╗██╗███████╗       ███████╗███████╗███████╗     ██████╗ ██╗████████╗    ██████╗ ██╗███████╗███████╗
██╔════╝██║╚██╗██╔╝    ╚══██╔══╝██║  ██║██║██╔════╝       ██╔════╝██╔════╝██╔════╝    ██╔════╝ ██║╚══██╔══╝    ██╔══██╗██║██╔════╝██╔════╝
█████╗  ██║ ╚███╔╝        ██║   ███████║██║███████╗       ███████╗█████╗  █████╗      ██║  ███╗██║   ██║       ██║  ██║██║█████╗  █████╗
██╔══╝  ██║ ██╔██╗        ██║   ██╔══██║██║╚════██║       ╚════██║██╔══╝  ██╔══╝      ██║   ██║██║   ██║       ██║  ██║██║██╔══╝  ██╔══╝
██║     ██║██╔╝ ██╗       ██║   ██║  ██║██║███████║██╗    ███████║███████╗███████╗    ╚██████╔╝██║   ██║       ██████╔╝██║██║     ██║  ██╗
╚═╝     ╚═╝╚═╝  ╚═╝       ╚═╝   ╚═╝  ╚═╝╚═╝╚══════╝╚═╝    ╚══════╝╚══════╝╚══════╝     ╚═════╝ ╚═╝   ╚═╝       ╚═════╝ ╚═╝╚═╝     ╚═╝  ╚═╝
*/

#if SERVER
#endif //

entity function TeslaTrap_CalculateFocalTrap( entity player, entity trap )
{
	TeslaTrapPlayerPlacementData placementData
	placementData.maxLinks = TESLA_TRAP_LINK_COUNT_MAX
	placementData.viewOrigin = player.EyePosition()
	placementData.viewForward = player.GetViewForward()
	placementData.playerOrigin = player.GetOrigin()
	placementData.playerForward = FlattenVector( player.GetViewForward() )

	if ( placementData.maxLinks == 0 )
	{
		entity focalTrap
		return focalTrap
	}

	array<entity> filteredTraps

	int distanceExcluded = 0
	int viewExcluded = 0
	int linkExcluded = 0

	foreach ( entity otherTrap in TeslaTrap_GetAllLinkable() )
	{
		float distSqr = DistanceSqr( player.GetOrigin(), otherTrap.GetOrigin() )
		if ( distSqr > ( ( TESLA_TRAP_LINK_DIST + TESLA_TRAP_LINK_SNAP_DIST ) * ( TESLA_TRAP_LINK_DIST + TESLA_TRAP_LINK_SNAP_DIST ) ) )
		{
			distanceExcluded++
			continue
		}

		float viewRating = TeslaTrap_GetTrapViewRating( placementData, otherTrap )
		if ( viewRating < TESLA_TRAP_LINK_MIN_VIEW_RATING && distSqr > (TESLA_TRAP_LINK_SNAP_DIST * TESLA_TRAP_LINK_SNAP_DIST ) )
		{
			viewExcluded++
			continue
		}

		TeslaTrapSortingData sortingData = file.trapSortingData[ otherTrap ]
		sortingData.sortingRating = viewRating
		sortingData.distSqr = Distance2DSqr( placementData.playerOrigin, otherTrap.GetOrigin() )

		filteredTraps.append( otherTrap )
	}

	if ( !filteredTraps.len() )
	{
		entity focalTrap
		return focalTrap
	}

	filteredTraps.sort( TeslaTrap_LinkTrapSort )

	TeslaTrapPlacementInfo placementInfo = TeslaTrap_GetPlacementInfo( player, trap, true, 0 ) //

	entity focalTrap
	foreach ( entity otherTrap in filteredTraps )
	{
		if ( TeslaTrap_CanLink( trap, placementInfo.origin, AnglesToUp( placementInfo.angles ), otherTrap, placementInfo ) )
		{
			focalTrap = otherTrap
			break
		}
		else
		{
			linkExcluded++
		}
	}

	return focalTrap
}

#if CLIENT
void function TeslaTrap_TrackFocalTrapForPlayer( entity player )
{
	Assert ( IsNewThread(), "Must be threaded off." )

	if ( !IsValid( player ) )
		return

	if ( player != GetLocalViewPlayer() )
		return

	player.Signal( "TeslaTrap_StopFocalTrapUpdate" )
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "TeslaTrap_StopFocalTrapUpdate" )

	asset model  = TESLA_TRAP_PROXY_MODEL
	entity proxy = TeslaTrap_CreateTrapPlacementProxy( model )

	while ( true )
	{
		TeslaTrap_UpdateFocalNodeForPlayer( player, proxy )
		WaitFrame()
	}
}
#endif //

void function TeslaTrap_UpdateFocalNodeForPlayer( entity player, entity proxy )
{
	entity focalTrap = TeslaTrap_CalculateFocalTrap( player, proxy )

	if ( IsValid( focalTrap ) )
	{
		if ( TeslaTrap_GetAll().contains( focalTrap ) )
		{
			TeslaTrap_SetFocalTrapForPlayer( player, focalTrap )
		}
	}
	else
	{
		TeslaTrap_ClearFocalTrapForPlayer( player )
	}
}
#if CLIENT
void function TeslaTrap_OnPlayerTeamChanged( entity player, int oldTeam, int newTeam )
{
	foreach( array<int>fxIDs in file.linkFXs_client )
	{
		foreach( int fxID in fxIDs )
		{
			EffectWake( fxID )
		}
	}
}
#endif //

void function TeslaTrap_SetFocalTrapForPlayer( entity player, entity focalTrap )
{
	if ( player in file.focalTrap )
		file.focalTrap[ player ] = focalTrap
	else
		file.focalTrap[ player ] <- focalTrap

	#if SERVER

	#endif //
}

void function TeslaTrap_ClearFocalTrapForPlayer( entity player )
{
	if ( player in file.focalTrap )
		delete file.focalTrap[ player ]

	#if SERVER

	#endif //
}

bool function TeslaTrap_PlayerHasFocalTrap( entity player )
{
	if ( player in file.focalTrap )
	{
		entity focalTrap = file.focalTrap[ player ]
		if ( IsValid( focalTrap ) )
		{
			//
			if ( focalTrap.GetScriptName() == "tesla_trap" )
				return true
		}
	}

	return false
}

entity function TeslaTrap_GetFocalTrapForPlayer( entity player )
{
	entity focalTrap = null
	if ( player in file.focalTrap )
	{
		focalTrap = file.focalTrap[ player ]
	}

	return focalTrap
}

#if CLIENT
void function OnFocusTrapChanged( entity player, entity oldEnt, entity newEnt, bool actuallyChanged )
{
	entity localViewPlayer = GetLocalViewPlayer()
	if ( !IsValid( localViewPlayer ) )
		return

	if ( !IsValid( newEnt ) )
	{
		TeslaTrap_ClearFocalTrapForPlayer( localViewPlayer )
		return
	}

	TeslaTrap_SetFocalTrapForPlayer( localViewPlayer, newEnt )
}
#endif //


#if SERVER
#endif //

int function TeslaTrap_LinkTrapSort( entity trapA, entity trapB )
{
	TeslaTrapSortingData trapASort = file.trapSortingData[ trapA ]
	TeslaTrapSortingData trapBSort = file.trapSortingData[ trapB ]

	if ( trapASort.sortingRating < trapBSort.sortingRating )
		return 1
	else if ( trapASort.sortingRating > trapBSort.sortingRating )
		return -1
	return 0
}

int function TeslaTrap_LinkMultiTrapSort( entity trapA, entity trapB )
{
	TeslaTrapSortingData trapASort = file.trapSortingData[ trapA ]
	TeslaTrapSortingData trapBSort = file.trapSortingData[ trapB ]

	if ( trapASort.distSqr < trapBSort.distSqr )
		return 1
	else if ( trapASort.distSqr > trapBSort.distSqr )
		return -1
	return 0
}

float function TeslaTrap_GetTrapViewRating( TeslaTrapPlayerPlacementData mainPlacementData, entity otherTrap )
{
	vector otherOrigin   = otherTrap.GetOrigin()
	vector viewToOther   = Normalize( otherOrigin - mainPlacementData.viewOrigin )
	vector playerToOther = Normalize( otherOrigin - mainPlacementData.playerOrigin )

	float viewDot    = DotProduct( viewToOther, mainPlacementData.viewForward )
	float viewRating = GraphCapped( viewDot, -1.0, 1.0, 0.0, 1.0 )

	return viewDot

	float feetDot    = DotProduct2D( playerToOther, mainPlacementData.playerForward )
	float feetRating = GraphCapped( feetDot, -1.0, 1.0, 0.0, 1.0 )

	float weightDot  = DotProduct( <0, 0, -1>, mainPlacementData.viewForward )
	float feetWeight = GraphCapped( weightDot, 0.5, 0.85, 0.0, 1.0 )
	float viewWeight = 1.0 - feetWeight

	feetRating *= feetWeight
	viewRating *= viewWeight

	return (viewRating + feetRating)
}

bool function TeslaTrap_CanUse( entity player, entity ent )
{
	if ( Bleedout_IsBleedingOut( player ) )
		return false

	if ( player.IsPhaseShifted() )
		return false

	return true
}

array<entity> function TeslaTrap_GetAll()
{
	#if SERVER
		array<entity> temp
		return temp
	#elseif CLIENT
		array<entity> allTraps = file.allTraps
		return allTraps
	#endif
}

array<entity> function TeslaTrap_GetAllLinkable()
{
	#if SERVER
		array<entity> temp
		return temp
	#elseif CLIENT
		array<entity> allTraps = file.allTraps
		array<entity> linkableTraps
		foreach ( entity trap in allTraps )
		{
			if ( trap.GetLinkEntArray().len() < TESLA_TRAP_LINK_COUNT_MAX )
				linkableTraps.append( trap )
		}
		return linkableTraps
	#endif
}

array<entity> function TeslaTrap_GetAllDead()
{
	#if SERVER
		array<entity> temp
		return temp
	#elseif CLIENT
		array<entity> allTraps = file.allTraps
		array<entity> deadTraps
		foreach ( entity trap in allTraps )
		{
			if ( trap.GetScriptName() == "tesla_trap_dead" )
				deadTraps.append( trap )
		}
		return deadTraps
	#endif
}

#if CLIENT
void function TeslaTrap_MaxDistanceAutoCancelUpdate( entity player )
{
	Assert ( IsNewThread(), "Must be threaded off." )
	player.Signal( "TeslaTrap_StopFocalTrapCancelUpdate" )
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "TeslaTrap_StopFocalTrapCancelUpdate" )

	asset model  = TESLA_TRAP_PROXY_MODEL
	entity proxy = TeslaTrap_CreateTrapPlacementProxy( model )

	while ( true )
	{
		if ( TeslaTrap_PlayerHasFocalTrap( player ) )
		{
			entity focalTrap                     = TeslaTrap_GetFocalTrapForPlayer( player )
			float playerDistSqr                    = DistanceSqr( focalTrap.GetOrigin(), player.GetOrigin() )
			if ( playerDistSqr >= (TESLA_TRAP_LINK_CANCEL_DIST * TESLA_TRAP_LINK_CANCEL_DIST) )
			{
				TeslaTrapPlacementInfo placementInfo = TeslaTrap_GetPlacementInfo( player, proxy, false, 0 )//
				float trapDistSqr                    = DistanceSqr( focalTrap.GetOrigin(), placementInfo.origin )
				if ( trapDistSqr >= (TESLA_TRAP_LINK_CANCEL_DIST * TESLA_TRAP_LINK_CANCEL_DIST) )
					player.ClientCommand( "invnext" )
			}
		}

		WaitFrame()
	}
}

void function TeslaTrap_OntriggerCreated( entity trigger )
{
	if ( trigger.GetTriggerType() != TT_TESLA_TRAP )
		return

	entity startTrap = trigger.GetTeslaTrapStart()
	entity endTrap = trigger.GetTeslaTrapEnd()

	CreateTrapMinimapData( startTrap )
	CreateTrapMinimapData( endTrap )

	//
	file.trapMinimapData[ startTrap ].triggerArray.append( trigger )
	Assert( file.trapMinimapData[ startTrap ].triggerArray.len() <= 2 )

	file.trapMinimapData[ endTrap ].triggerArray.append( trigger )
	Assert( file.trapMinimapData[ endTrap ].triggerArray.len() <= 2 )

	thread RefreshTrapTriggerMinimapConnection( startTrap )
	thread RefreshTrapTriggerMinimapConnection( endTrap )
}

void function TeslaTrap_OntriggerDestroyed( entity trigger )
{
	if ( trigger.GetTriggerType() != TT_TESLA_TRAP )
		return

	entity startTrap = trigger.GetTeslaTrapStart()
	entity endTrap = trigger.GetTeslaTrapEnd()

	if ( startTrap in file.trapMinimapData )
		file.trapMinimapData[ startTrap ].triggerArray.fastremovebyvalue( trigger )
	if ( endTrap in file.trapMinimapData )
		file.trapMinimapData[ endTrap ].triggerArray.fastremovebyvalue( trigger )

	thread RefreshTrapTriggerMinimapConnection( startTrap )
	thread RefreshTrapTriggerMinimapConnection( endTrap )
}

void function TeslaTrap_OnPropScriptCreated( entity ent )
{
	switch ( ent.GetScriptName() )
	{
		case "tesla_trap":

			TeslaTrapSortingData sortingData
			file.trapSortingData[ ent ] <- sortingData

			CreateTrapMinimapData( ent )

			file.allTraps.append( ent )
			thread TeslaTrap_CreateHUDMarker( ent )
			AddEntityCallback_GetUseEntOverrideText( ent, TeslaTrap_UseTextOverride )
			SetCallback_CanUseEntityCallback( ent, TeslaTrap_CanUse )
			break
	}
}

void function TeslaTrap_OnPropScriptDestroyed( entity ent )
{
	DestroyTrapMinimapData( ent )

	if ( file.allTraps.contains( ent ) )
		file.allTraps.fastremovebyvalue( ent )
	if ( ent in file.trapSortingData )
		delete file.trapSortingData[ ent ]
}

void function CreateTrapMinimapData( entity trap )
{
	if ( trap in file.trapMinimapData )
		return

	TrapMinimapData data
	file.trapMinimapData[ trap ] <- data
}

void function DestroyTrapMinimapData( entity trap )
{
	if ( !(trap in file.trapMinimapData) )
		return

	delete file.trapMinimapData[ trap ]
}

array<entity> function TeslaTrap_AttemptTrapLinkOnClient( entity trap, entity otherTrap, TeslaTrapPlacementInfo placementInfo )
{
	array<entity> linkTraps
	if ( TeslaTrap_CanLink( trap, trap.GetOrigin(), trap.GetUpVector(), otherTrap, placementInfo ) )
		linkTraps.append( otherTrap )

	return linkTraps
}

void function TeslaTrap_CreateHUDMarker( entity trap )
{
	entity localClientPlayer = GetLocalClientPlayer()

	trap.EndSignal( "OnDestroy" )
	localClientPlayer.EndSignal( "OnDestroy" )

	if ( !TeslaTrap_ShouldShowIcon( localClientPlayer, trap ) )
		return

	int attachment = trap.LookupAttachment( "muzzle_flash" )
	vector pos     = trap.GetOrigin() + (trap.GetUpVector() * TESLA_TRAP_ICON_HEIGHT)
	var rui        = CreateCockpitRui( $"ui/tesla_trap_marker_icons.rpak", 0 )
	RuiTrackFloat3( rui, "pos", trap, RUI_TRACK_POINT_FOLLOW, attachment )
	RuiSetBool( rui, "linkMode", false )
	RuiTrackInt( rui, "teamRelation", trap, RUI_TRACK_TEAM_RELATION_VIEWPLAYER )
	RuiKeepSortKeyUpdated( rui, true, "pos" )

	asset icon = $"rui/menu/boosts/boost_icon_tesla_trap"
	RuiSetImage( rui, "iconImage", icon )

	file.trapRui[ trap ] <- rui

	OnThreadEnd(
		function() : ( rui, trap )
		{
			if ( IsValid( trap ) )
				delete file.trapRui[ trap ]

			RuiDestroy( rui )
		}
	)

	WaitForever()
}

void function TeslaTrap_UpdateHudMarkers( entity localClientPlayer )
{

	localClientPlayer.Signal( "TeslaTrap_StopHudIconUpdate" )
	localClientPlayer.EndSignal( "OnDestroy" )
	localClientPlayer.EndSignal( "TeslaTrap_StopHudIconUpdate" )

	asset icon = $"rui/menu/boosts/boost_icon_tesla_trap"

	OnThreadEnd(
		function() : ()
		{
			foreach ( entity trap, var rui in file.trapRui )
			{
				if ( IsValid( trap ) )
				{
					RuiSetBool( rui, "shouldDraw", false )
					RuiSetBool( rui, "extendMode", false )
				}
			}
		}
	)

	while ( true )
	{
		entity localViewPlayer = GetLocalViewPlayer()
		array<entity> traps = TeslaTrap_GetAll()
		entity focalTrap = TeslaTrap_GetFocalTrapForPlayer( localViewPlayer )
		entity weapon = localViewPlayer.GetOffhandWeapon( OFFHAND_TACTICAL )

		foreach ( entity trap, var rui in file.trapRui )
		{
			if ( !IsValid( trap ) )
				continue

			if ( trap.GetTeam() != localViewPlayer.GetTeam() )
				continue

			if ( !IsValid( weapon ) || weapon.GetWeaponClassName() != "mp_weapon_tesla_trap" || trap.GetLinkEntArray().len() >= TESLA_TRAP_LINK_COUNT_MAX )
			{
				RuiSetImage( rui, "iconImage", icon )
				RuiSetBool( rui, "shouldDraw", false )
				RuiSetBool( rui, "extendMode", false )
			}
			else if ( focalTrap == trap )
			{
				if ( Bleedout_IsBleedingOut( localViewPlayer ) )
				{
					RuiSetImage( rui, "iconImage", icon )
					RuiSetBool( rui, "shouldDraw", false )
					RuiSetBool( rui, "extendMode", false )
				}
				else if ( StatusEffect_GetSeverity( localClientPlayer, eStatusEffect.placing_tesla_trap ) )
				{
					RuiSetImage( rui, "iconImage", icon )
					RuiSetBool( rui, "shouldDraw", true )
					RuiSetBool( rui, "extendMode", false )
				}
				else
				{
					RuiSetImage( rui, "iconImage", icon )
					RuiSetBool( rui, "shouldDraw", true )
					RuiSetBool( rui, "extendMode", true )
				}
			}
			else
			{
				if ( Bleedout_IsBleedingOut( localViewPlayer ) )
				{
					RuiSetImage( rui, "iconImage", icon )
					RuiSetBool( rui, "shouldDraw", false )
					RuiSetBool( rui, "linkMode", false )
					RuiSetBool( rui, "extendMode", false )
				}
				else
				{
					RuiSetImage( rui, "iconImage", icon )
					RuiSetBool( rui, "shouldDraw", true )
					RuiSetBool( rui, "linkMode", false )
					RuiSetBool( rui, "extendMode", false )
				}
			}

			RuiSetBool( rui, "recalPossible", trap == file.recalTrap )
		}

		WaitFrame()
	}
}

bool function TeslaTrap_ShouldShowIcon( entity localPlayer, entity trapProxy )
{
	if ( !GamePlayingOrSuddenDeath() )
		return false
	if ( IsEnemyTeam( localPlayer.GetTeam(), trapProxy.GetTeam() ) )
		return false

	return true
}

string function TeslaTrap_UseTextOverride( entity ent )
{
	entity player = GetLocalViewPlayer()

	if ( player.IsTitan() )
		return "#WPN_DIRTY_BOMB_NO_INTERACTION"

	if ( player == ent.GetOwner() )
	{
		return ""
	}

	return "#WPN_DIRTY_BOMB_NO_INTERACTION"
}

int function TeslaTrap_GetOwnedLivingTrapCountOnClient( entity player )
{
	int count
	array<entity> traps = TeslaTrap_GetAll()
	foreach ( entity trap in traps )
	{
		if ( trap.GetScriptName() == "tesla_trap_dead" )
			continue

		if ( trap.GetOwner() == player )
			count++
	}

	return count
}

void function TeslaTrap_CreateClientEffects( entity trigger, entity start, entity end, int actualBeamCount )
{
	int triggerFXID = trigger.GetTeslaLinkFXIdx()

	int fxIDTeam = GetParticleSystemIndex( TESLA_TRAP_LINK_FX )
	int fxIDEnemy = GetParticleSystemIndex( TESLA_TRAP_LINK_ENEMY_FX )
	vector colorFriendly = GetKeyColor( COLORID_FRIENDLY )
	vector colorEnemy = GetKeyColor( COLORID_ENEMY )

	vector startUp = start.GetUpVector()
	vector endUp   = end.GetUpVector()

	for ( int i = 1; i <= actualBeamCount; i++ )
	{
		float heightOffset = TESLA_TRAP_LINK_HEIGHT * i

		int fxIdxTeam = StartParticleEffectOnEntityWithPos( start, fxIDTeam, FX_PATTACH_ABSORIGIN_FOLLOW, -1, (startUp * (heightOffset + file.proxyBaseOffset)), <0, 0, 0> )
		EffectSetPlayFriendlyOnly( fxIdxTeam )
		EffectSetDontKillForReplay( fxIdxTeam )
		EffectAddTrackingForControlPoint( fxIdxTeam, 1, end, FX_PATTACH_ABSORIGIN_FOLLOW, -1, (endUp * (heightOffset + file.proxyBaseOffset)) )
		EffectSetControlPointVector( fxIdxTeam, 2, colorFriendly )

		int fxIdxEnemy = StartParticleEffectOnEntityWithPos( start, fxIDEnemy, FX_PATTACH_ABSORIGIN_FOLLOW, -1, (startUp * (heightOffset + file.proxyBaseOffset)), <0, 0, 0> )
		EffectSetPlayEnemyOnly( fxIdxEnemy )
		EffectSetDontKillForReplay( fxIdxEnemy )
		EffectAddTrackingForControlPoint( fxIdxEnemy, 1, end, FX_PATTACH_ABSORIGIN_FOLLOW, -1, (endUp * (heightOffset + file.proxyBaseOffset)) )
		EffectSetControlPointVector( fxIdxEnemy, 2, colorEnemy )

		file.linkFXs_client[triggerFXID].append( fxIdxTeam )
		file.linkFXs_client[triggerFXID].append( fxIdxEnemy )
	}
}

void function ClientCodeCallback_TeslaTrapLinked( entity trigger, entity start, entity end )
{
	if ( !IsValid( trigger ) ) //
		return
	thread TeslaTrap_CreateClientTeslaTrapEffects( trigger, start, end )
}

void function TeslaTrap_CreateClientTeslaTrapEffects( entity trigger, entity start, entity end )
{
	int finalBeamCount = int( trigger.GetTeslaTrapHeight() / TESLA_TRAP_LINK_HEIGHT )

	if ( finalBeamCount == 0 )
		return

	WaitFrame()

	if ( file.proxyBaseOffset == -1.0 )
	{
		entity localViewPlayer 	= GetLocalViewPlayer()
		asset model           	= TESLA_TRAP_PROXY_MODEL
		entity proxy       		= TeslaTrap_CreateTrapPlacementProxy( model )

		int attachID      = proxy.LookupAttachment( "BASE_POINT" )
		vector basePos    = proxy.GetAttachmentOrigin( attachID )
		float proxyOffset = basePos.z - proxy.GetOrigin().z
		file.proxyBaseOffset = proxyOffset
	}

	int actualBeamCount = int( ceil( trigger.GetTeslaTrapHeight() - file.proxyBaseOffset ) / TESLA_TRAP_LINK_HEIGHT )

	int currentFXID = file.currentFXID++
	trigger.SetTeslaLinkFXIdx( currentFXID )

	if ( !(currentFXID in file.linkFXs_client) )
		file.linkFXs_client[currentFXID] <- []

	int halfCount   = finalBeamCount / 2
	entity clientAG = CreateClientSideAmbientGeneric( start.GetOrigin(), TESLA_TRAP_LINK_LOOP_SOUND, 0 )
	SetTeam( clientAG, trigger.GetTeam() )
	clientAG.SetSegmentEndpoints( start.GetOrigin() + (start.GetUpVector() * (halfCount * TESLA_TRAP_LINK_HEIGHT)), end.GetOrigin() + (end.GetUpVector() * (halfCount * TESLA_TRAP_LINK_HEIGHT)) )
	clientAG.SetEnabled( true )
	clientAG.RemoveFromAllRealms()
	clientAG.AddToOtherEntitysRealms( trigger )
	file.linkAGs_client[ currentFXID ] <- clientAG

	bool startObstructed = (trigger.GetObstructedEndTime() > Time())

	if ( startObstructed )
	{
		trigger.SetObstructedEndTime( trigger.GetObstructedEndTime() )
		clientAG.SetEnabled( false )
	}
	else
	{
		TeslaTrap_CreateClientEffects( trigger, start, end, actualBeamCount )
	}

	WaitFrame()
}

void function RegisterTeslaTrapMinimapRui( entity trapEnt, var rui )
{
	if ( trapEnt.GetScriptName() != "tesla_trap" )
		return

	Assert( trapEnt in file.trapMinimapData )
	file.trapMinimapData[ trapEnt ].ruiArray.append( rui )
}

void function RefreshTrapTriggerMinimapConnection( entity trap )
{
	AssertIsNewThread()

	if ( !IsValid( trap ) )
		return

	EndSignal( trap, "OnDestroy" )

	WaitFrame()

	int linkCount = file.trapMinimapData[ trap ].triggerArray.len()

	for ( int index = 0; index < 2; index++ )
	{
		entity _trigger
		if ( file.trapMinimapData[ trap ].triggerArray.len() > index )
			_trigger = file.trapMinimapData[ trap ].triggerArray[ index ]

		bool enabled = ( IsValid( _trigger ) && _trigger.GetTeslaTrapEnd() != trap )

		foreach( rui in file.trapMinimapData[ trap ].ruiArray )
		{
			if ( enabled )
				RuiTrackFloat3( rui, "link" + (index+1) + "EndPos", _trigger.GetTeslaTrapEnd(), RUI_TRACK_ABSORIGIN_FOLLOW )
			RuiSetBool( rui, "link" + (index+1) + "Enabled", enabled )
		}
	}

	foreach( rui in file.trapMinimapData[ trap ].ruiArray )
	{
		RuiSetInt( rui, "linkCount", linkCount )
	}
}

void function UpdateTrapTriggerMinimapConnection( entity trigger, bool isVisible )
{

	entity startTrap = trigger.GetTeslaTrapStart()

	if ( !( startTrap in file.trapMinimapData ) )
	{
		return
	}

	foreach ( index, _trigger in file.trapMinimapData[ startTrap ].triggerArray )
	{
		if ( trigger != _trigger )
			continue

		foreach( rui in file.trapMinimapData[ startTrap ].ruiArray )
		{
			RuiSetBool( rui, "link" + (index+1) + "Enabled", isVisible )
		}
	}
}

void function ClientCodeCallback_TeslaTrapVisibilityChanged( entity trigger, entity start, entity end, bool isVisible, int fxIdx )
{
	int triggerFXID = fxIdx
	if ( triggerFXID < 0 )
		return

	if ( !IsValid( start ) || !IsValid( end ) ) //
	{
		foreach( int fxID in file.linkFXs_client[triggerFXID] )
			EffectStop( fxID, false, true )
		delete file.linkFXs_client[triggerFXID]

		entity ambientGeneric = file.linkAGs_client[ triggerFXID ]

		if ( IsValid( ambientGeneric ) )
			ambientGeneric.Destroy()
		delete file.linkAGs_client[ triggerFXID ]
		return
	}

	if ( !IsValid( trigger ) )
		return

	Assert( trigger )
	UpdateTrapTriggerMinimapConnection( trigger, isVisible )

	if ( isVisible )
	{
		int actualBeamCount = int( ceil( trigger.GetTeslaTrapHeight() - file.proxyBaseOffset ) / TESLA_TRAP_LINK_HEIGHT )
		TeslaTrap_CreateClientEffects( trigger, start, end, actualBeamCount )

		if ( triggerFXID in file.linkAGs_client )
		{
			entity ambientGeneric = file.linkAGs_client[ triggerFXID ]
			if ( IsValid( ambientGeneric ) )
				ambientGeneric.SetEnabled( true )
		}

		vector origin = trigger.GetOrigin()
		EmitSoundAtPosition( TEAM_UNASSIGNED, origin, TESLA_TRAP_LINK_RECONNECT_SEGMENT_SOUND )

		entity localViewPlayer = GetLocalViewPlayer()

		if ( localViewPlayer.GetTeam() == start.GetTeam() )
			EmitSoundOnEntity( start, TESLA_TRAP_LINK_RECONNECT_POST_SOUND )
		else
			EmitSoundOnEntity( start, TESLA_TRAP_LINK_RECONNECT_POST_ENEMY_SOUND )

		if ( localViewPlayer.GetTeam() == end.GetTeam() )
			EmitSoundOnEntity( end, TESLA_TRAP_LINK_RECONNECT_POST_SOUND )
		else
			EmitSoundOnEntity( end, TESLA_TRAP_LINK_RECONNECT_POST_ENEMY_SOUND )
	}
	else
	{
		foreach( int fxID in file.linkFXs_client[triggerFXID] )
			EffectStop( fxID, false, true )
		
		file.linkFXs_client[triggerFXID] <- []

		if ( triggerFXID in file.linkAGs_client )
		{
			entity ambientGeneric = file.linkAGs_client[ triggerFXID ]
			if ( IsValid( ambientGeneric ) )
				ambientGeneric.SetEnabled( false )
		}
	}
}
#endif //

void function CodeCallback_TeslaTrapCrossed( entity trigger, entity start, entity end, entity crossingEnt )
{
	#if SERVER
	#endif

	#if CLIENT
		if ( trigger.IsTeslaTrapObstructed() )
			return

		if ( start.GetTeam() != crossingEnt.GetTeam() )
			return

		trigger.SetObstructedEndTime( Time() + 1.0 )

		UpdateTrapTriggerMinimapConnection( trigger, false )

		EmitSoundAtPosition( TEAM_UNASSIGNED, trigger.GetOrigin(), TESLA_TRAP_LINK_OBSTRUCT_SOUND )

		int triggerFXID = trigger.GetTeslaLinkFXIdx()
		foreach( int fxID in file.linkFXs_client[triggerFXID] )
			EffectStop( fxID, false, true )
			
		file.linkFXs_client[triggerFXID] <- []

		entity ambientGeneric = file.linkAGs_client[ triggerFXID ]
		ambientGeneric.SetEnabled( false )
	#endif //
}

bool function TeslaTrap_AreTrapsLinked( entity mainTrap, entity otherTrap )
{
	array<entity> mainLinks  = mainTrap.GetLinkEntArray()
	array<entity> otherLinks = otherTrap.GetLinkEntArray()

	if ( mainLinks.contains( otherTrap ) && otherLinks.contains( mainTrap ) )
		return true

	return false
}

//
bool function TeslaTrap_CanLink( entity trap, vector trapPos, vector trapUp, entity otherTrap, TeslaTrapPlacementInfo placementInfo )
{
	if ( trap == otherTrap )
		return false

	if ( otherTrap.GetScriptName() == "tesla_trap_dead" )
		return false

	if ( otherTrap.GetLinkEntArray().len() >= TESLA_TRAP_LINK_COUNT_MAX )
		return false

	if ( trap.GetLinkEntArray().len() >= TESLA_TRAP_LINK_COUNT_MAX )
		return false

	if ( placementInfo.deployLinkState != eDeployLinkFlags.DLF_NONE )
		return placementInfo.deployLinkState == eDeployLinkFlags.DLF_CAN_LINK

	entity otherParent = otherTrap.GetParent()
	if ( IsValid( placementInfo.parentTo ) )
	{
		if ( IsValid( otherParent ) && otherParent != placementInfo.parentTo )
			return false
		else if ( !IsValid( otherParent ) )
			return false
	}
	else if ( IsValid( otherParent ) )
		return false

	vector otherOrigin = otherTrap.GetOrigin()
	float distSqr = DistanceSqr( trapPos, otherOrigin )

	if ( distSqr > TESLA_TRAP_LINK_DIST_SQR )
		return false

	int beamCount = TeslaTrap_GetLinkLOSBeamCount( trapPos, trapUp, otherOrigin, otherTrap.GetUpVector() )
	if ( beamCount < TESLA_TRAP_LINK_FX_MIN )
		return false

	placementInfo.beamCount = beamCount
	placementInfo.deployLinkState = eDeployLinkFlags.DLF_CAN_LINK

	return true
}

bool function TeslaTrap_CanDeploy( entity trap, vector testPos, vector testUp, entity otherTrap, TeslaTrapPlacementInfo placementInfo )
{
	if ( !TeslaTrap_CanLink( trap, testPos, testUp, otherTrap, placementInfo ) )
	{
		placementInfo.deployLinkState = eDeployLinkFlags.DLF_FAIL
		return false
	}

	if ( TeslaTrap_IsLinkAngleTooSteep( testPos, otherTrap ) )
	{
		return false
	}

	return true
}

int function TeslaTrap_GetLinkLOSBeamCount( vector mainOrigin, vector mainUp, vector otherOrigin, vector otherUp )
{
	if ( IsValid( file.framePlacementInfo ) )
	{
		if ( file.framePlacementInfo.frameTime == Time() && file.framePlacementInfo.placementInfo.deployLinkState != eDeployLinkFlags.DLF_NONE )
			return file.framePlacementInfo.placementInfo.beamCount
	}

	array<entity> ignoreEnts = GetPlayerArray_Alive()
	ignoreEnts.extend( GetAllPropDoors() )
	ignoreEnts.extend( GetAllDeathBoxes() )

	for ( int i = 1; i <= TESLA_TRAP_LINK_FX_COUNT; i++ )
	{
		vector startOffset   = mainOrigin + (mainUp * (TESLA_TRAP_LINK_HEIGHT * i))
		vector endOffset     = otherOrigin + (otherUp * (TESLA_TRAP_LINK_HEIGHT * i))
		TraceResults results = TraceLineHighDetail( startOffset, endOffset, ignoreEnts, TESLA_TRAP_TRACE_MASK, TRACE_COLLISION_GROUP_BLOCK_WEAPONS )

		if ( TESLA_TRAP_DEBUG_DRAW )
		{
			DebugDrawLine( results.endPos, endOffset, 255, 0, 0, true, 20.0 )
			DebugDrawLine( startOffset, results.endPos, 0, 255, 0, true, 20.0 )
		}

		if ( results.fraction < 1.0 )
			return i - 1
	}

	return TESLA_TRAP_LINK_FX_COUNT
}

bool function TeslaTrap_IsLinkAngleTooSteep( vector proxyTestPos, entity otherTrap )
{
	vector otherToProxy = Normalize( proxyTestPos - otherTrap.GetOrigin() )
	array<entity> links = otherTrap.GetLinkEntArray()


	foreach ( entity trap in links )
	{
		vector otherToTrap = Normalize( trap.GetOrigin() - otherTrap.GetOrigin() )
		float dot = DotProduct2D( otherToProxy, otherToTrap )

		if ( dot > TESLA_TRAP_LINK_MAX_DOT )
		{
			return true
		}
	}

	return false
}

#if SERVER
// This is the serverside function to actually place the fence node.
// Written by mostlyfireproof
void function WeaponMakesTeslaTrap( entity weapon, asset model, TeslaTrapPlacementInfo placementInfo ) {
	printf("Placing a node")
	entity trap = CreatePropDynamic(model, placementInfo.origin, placementInfo.angles, 0)
	trap.SetScriptName("fence_node")

}
#endif
