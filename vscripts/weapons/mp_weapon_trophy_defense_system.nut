//=========================================================
//	mp_weapon_trophy_defense_system.nut
//=========================================================

untyped

global function MpWeaponTrophy_Init
global function OnWeaponAttemptOffhandSwitch_weapon_trophy_defense_system

global function OnWeaponActivate_weapon_trophy_defense_system
global function OnWeaponDeactivate_weapon_trophy_defense_system
global function OnWeaponPrimaryAttack_weapon_trophy_defense_system

#if CLIENT
global function SCB_WattsonRechargeHint
#endif

// FX
const asset TROPHY_START_FX = $"P_wpn_trophy_loop_st"
const asset TROPHY_ELECTRICITY_FX = $"P_wpn_trophy_loop_1"
const asset TROPHY_INTERCEPT_PROJECTILE_SMALL_FX = $"P_wpn_trophy_imp_sm"//
const asset TROPHY_INTERCEPT_PROJECTILE_LARGE_FX = $"P_wpn_trophy_imp_lg"
const asset TROPHY_INTERCEPT_PROJECTILE_CLOSE_FX = $"P_wpn_trophy_imp_lite"
const asset TROPHY_DAMAGE_SPARK_FX = $"P_trophy_sys_dmg"
const asset TROPHY_DESTROY_FX = $"P_trophy_sys_exp"
const asset TROPHY_COIL_ON_FX = $"P_wpn_trophy_coil_spin"
const asset TROPHY_PLAYER_TACTICAL_CHARGE_FX = $"P_wat_menu_coil_loop"
const asset TROPHY_PLAYER_SHIELD_CHARGE_FX = $"P_armor_3P_loop_CP"
const asset TROPHY_RANGE_RADIUS_REMINDER_FX = $"P_wpn_trophy_ar_ring_flash"

#if SERVER || CLIENT
const asset TROPHY_PLACEMENT_RADIUS_FX 		= $"P_wpn_trophy_ar_ring"
#endif // SERVER || CLIENT

// FX Table
global const string TROPHY_SYSTEM_NAME = "trophy_system"
const TROPHY_TARGET_EXPLOSION_IMPACT_TABLE = "exp_medium"

// Model
const asset TROPHY_MODEL = $"mdl/props/wattson_trophy_system/wattson_trophy_system.rmdl"

// Sound
const string TROPHY_PLACEMENT_ACTIVATE_SOUND 	= "wattson_tactical_a"
const string TROPHY_PLACEMENT_DEACTIVATE_SOUND 	= "wattson_tactical_b"

const string TROPHY_EXPAND_SOUND		= "Wattson_Ultimate_E"
const string TROPHY_EXPAND_ENEMY_SOUND	= "Wattson_Ultimate_E_Enemy"
const string TROPHY_ELECTRIC_IDLE_SOUND = "Wattson_Ultimate_F"
const string TROPHY_TACTICAL_CHARGE_SOUND = "Wattson_Ultimate_G"

const string TROPHY_INTERCEPT_BEAM_SOUND 	= "Wattson_Ultimate_H"
const string TROPHY_INTERCEPT_LARGE			= "Wattson_Ultimate_I"
const string TROPHY_INTERCEPT_SMALL			= "Wattson_Ultimate_J"
const string TROPHY_DESTROY_SOUND			= "Wattson_Ultimate_K"
const string TROPHY_SHIELD_REPAIR_START     = "Wattson_Ultimate_L"
const string TROPHY_SHIELD_REPAIR_END       = "Wattson_Ultimate_N"

// Placement
const float TROPHY_PLACEMENT_RANGE_MAX = 94
const float TROPHY_PLACEMENT_RANGE_MIN = 64
const float TROPHY_PLACEMENT_SPACING_MIN = 64
const float TROPHY_PLACEMENT_SPACING_MIN_SQR = TROPHY_PLACEMENT_SPACING_MIN * TROPHY_PLACEMENT_SPACING_MIN
const vector TROPHY_BOUND_MINS = <-32,-32,0>
const vector TROPHY_BOUND_MAXS = <32,32,72>
const vector TROPHY_PLACEMENT_TRACE_OFFSET = <0,0,94>
const float TROPHY_PLACEMENT_MAX_GROUND_DIST = 12.0

// Intersection
const vector TROPHY_INTERSECTION_BOUND_MINS = <-16,-16,0>
const vector TROPHY_INTERSECTION_BOUND_MAXS = <16,16,32>

// 
const float TROPHY_ANGLE_LIMIT = 0.74
const float TROPHY_DEPLOY_DELAY = 1.0

// Damage
const int TROPHY_HEALTH_AMOUNT = 150
const float TROPHY_DAMAGE_FX_INTERVAL = 0.25

// Projectile
const float TROPHY_INTERCEPT_PROJECTILE_RANGE = 512.0
const float TROPHY_INTERCEPT_PROJECTILE_RANGE_MIN = 256.0 //
const float TROPHY_INTERCEPT_PROJECTILE_RANGE_MIN_SQR = TROPHY_INTERCEPT_PROJECTILE_RANGE_MIN * TROPHY_INTERCEPT_PROJECTILE_RANGE_MIN

// 
const float TROPHY_ARC_SCREEN_EFFECT_RADIUS = TROPHY_INTERCEPT_PROJECTILE_RANGE
const float WATTSON_TROPHY_CHARGE_POPUP_COOLDOWN = 3.5

// Redeploy
const float TROPHY_SHIELD_REPAIR_INTERVAL = 0.5
const int 	TROPHY_SHIELD_REPAIR_AMOUNT	= 1
const float TROPHY_LOS_CHARGE_TIMEOUT = 1.0
const asset TACTICAL_CHARGE_FX = $"P_player_boost_screen"//

// Max
const int TROPHY_MAX_COUNT = 1

// Trigger
const float TROPHY_REMINDER_TRIGGER_RADIUS = 300.0
const float TROPHY_REMINDER_TRIGGER_DBOUNCE = 30.0

// Debug
const bool TROPHY_DEBUG_DRAW = false
const bool TROPHY_DEBUG_DRAW_PLACEMENT = false
const bool TROPHY_DEBUG_DRAW_INTERSECTION = false


#if CLIENT
const float TROPHY_ICON_HEIGHT = 68.0
#endif //

struct TrophyPlacementInfo
{
	vector origin
	vector angles
	entity parentTo
	bool success = false
}

#if SERVER




#endif // SERVER


struct
{
	#if SERVER
	#else
	int tacticalChargeFXHandle
	#endif
} file

function MpWeaponTrophy_Init()
{
	PrecacheParticleSystem( TROPHY_START_FX )
	PrecacheParticleSystem( TROPHY_ELECTRICITY_FX )
	PrecacheParticleSystem( TROPHY_INTERCEPT_PROJECTILE_SMALL_FX )
	PrecacheParticleSystem( TROPHY_INTERCEPT_PROJECTILE_LARGE_FX )
	PrecacheParticleSystem( TROPHY_INTERCEPT_PROJECTILE_CLOSE_FX )
	PrecacheParticleSystem( TROPHY_DAMAGE_SPARK_FX )
	PrecacheParticleSystem( TROPHY_DESTROY_FX )
	PrecacheParticleSystem( TROPHY_COIL_ON_FX )
	PrecacheParticleSystem( TROPHY_PLAYER_TACTICAL_CHARGE_FX )
	PrecacheParticleSystem( TROPHY_PLAYER_SHIELD_CHARGE_FX )
	PrecacheParticleSystem( TROPHY_RANGE_RADIUS_REMINDER_FX )

	PrecacheModel( TROPHY_MODEL )

	#if SERVER




	#endif //

	#if CLIENT
		PrecacheParticleSystem( TACTICAL_CHARGE_FX )
		PrecacheParticleSystem( TROPHY_PLACEMENT_RADIUS_FX )
		StatusEffect_RegisterEnabledCallback( eStatusEffect.placing_trophy_system, Trophy_OnBeginPlacement)
		StatusEffect_RegisterDisabledCallback( eStatusEffect.placing_trophy_system, Trophy_OnEndPlacement )
		AddCreateCallback( "prop_script", Trophy_OnPropScriptCreated )

		RegisterSignal( "Trophy_StopPlacementProxy" )
		RegisterSignal( "EndTacticalChargeRepair" )
		RegisterSignal( "EndTacticalShieldRepair" )
		RegisterSignal( "UpdateShieldRepair" )

		StatusEffect_RegisterEnabledCallback( eStatusEffect.trophy_tactical_charge, TacticalChargeVisualsEnabled)
		StatusEffect_RegisterDisabledCallback( eStatusEffect.trophy_tactical_charge, TacticalChargeVisualsDisabled )

		StatusEffect_RegisterEnabledCallback( eStatusEffect.trophy_shield_repair, ShieldRepairVisualsEnabled )
		StatusEffect_RegisterDisabledCallback( eStatusEffect.trophy_shield_repair, ShieldRepairVisualsDisabled )

		AddCallback_OnWeaponStatusUpdate( Trophy_OnWeaponStatusUpdate )
	#endif // CLIENT

	thread MpWeaponTrophyLate_Init()
}

void function MpWeaponTrophyLate_Init()
{
	WaitEndFrame()

	#if CLIENT
		AddCallback_OnEquipSlotTrackingIntChanged( "armor", ArmorChanged )
	#endif // CLIENT
}

void function OnWeaponActivate_weapon_trophy_defense_system( entity weapon )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	Assert( ownerPlayer.IsPlayer() )
	#if CLIENT
		if ( !InPrediction() ) //
			return
	#endif

	int statusEffect = eStatusEffect.placing_trophy_system
	StatusEffect_AddEndless( ownerPlayer, statusEffect, 1.0 )
}

void function OnWeaponDeactivate_weapon_trophy_defense_system( entity weapon )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	Assert( ownerPlayer.IsPlayer() )
	#if CLIENT
		if ( !InPrediction() ) //
			return
	#endif

	StatusEffect_StopAllOfType( ownerPlayer, eStatusEffect.placing_trophy_system )
}

bool function OnWeaponAttemptOffhandSwitch_weapon_trophy_defense_system( entity weapon )
{
	int ammoReq = weapon.GetAmmoPerShot()
	int currAmmo = weapon.GetWeaponPrimaryClipCount()
	if ( currAmmo < ammoReq )
		return false

	entity player = weapon.GetWeaponOwner()
	if ( player.IsPhaseShifted() )
		return false

	if ( player.IsZiplining() )
		return false

	return true
}

var function OnWeaponPrimaryAttack_weapon_trophy_defense_system( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	Assert( ownerPlayer.IsPlayer() )

	asset model = TROPHY_MODEL

	entity proxy                      = Trophy_CreateTrapPlacementProxy( model )
	TrophyPlacementInfo placementInfo = Trophy_GetPlacementInfo( ownerPlayer, proxy )
	proxy.Destroy()

	if ( !placementInfo.success )
		return 0

	#if SERVER

	#endif
	StatusEffect_StopAllOfType( ownerPlayer, eStatusEffect.placing_trophy_system )
	PlayerUsedOffhand( ownerPlayer, weapon, true, null, {pos = placementInfo.origin} )

	int ammoReq = weapon.GetAmmoPerShot()
	return ammoReq
}

/*






*/

TrophyPlacementInfo function Trophy_GetPlacementInfo( entity player, entity proxy )
{
	vector eyePos  = player.EyePosition()
	vector viewVec = player.GetViewVector()
	vector angles  = < 0, VectorToAngles( viewVec ).y, 0 >

	float maxRange = TROPHY_PLACEMENT_RANGE_MAX

	TraceResults viewTraceResults = TraceLine( eyePos, eyePos + player.GetViewVector() * ( TROPHY_PLACEMENT_RANGE_MAX * 2), [player, proxy], TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_NONE )
	if ( viewTraceResults.fraction < 1.0 )
	{
		float slope = fabs( viewTraceResults.surfaceNormal.x ) + fabs( viewTraceResults.surfaceNormal.y )
		if ( slope < TROPHY_ANGLE_LIMIT )
			maxRange = min( Distance( eyePos, viewTraceResults.endPos ), TROPHY_PLACEMENT_RANGE_MAX )
	}

	vector idealPos = player.GetOrigin() + ( AnglesToForward( angles ) * TROPHY_PLACEMENT_RANGE_MAX )
	TraceResults fwdResults = TraceHull( eyePos + viewVec * min( TROPHY_PLACEMENT_RANGE_MIN, maxRange ), eyePos + viewVec * maxRange, TROPHY_BOUND_MINS, TROPHY_BOUND_MAXS, [player, proxy], TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_NONE )
	TraceResults downResults = TraceHull( fwdResults.endPos, fwdResults.endPos - TROPHY_PLACEMENT_TRACE_OFFSET, TROPHY_BOUND_MINS, TROPHY_BOUND_MAXS, [player, proxy], TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_NONE )

	if ( TROPHY_DEBUG_DRAW_PLACEMENT )
	{
		DebugDrawBox( fwdResults.endPos, TROPHY_BOUND_MINS, TROPHY_BOUND_MAXS, 0, 255, 0, 1, 1.0 ) //
		DebugDrawBox( downResults.endPos, TROPHY_BOUND_MINS, TROPHY_BOUND_MAXS, 0, 0, 255, 1, 1.0 ) //
		DebugDrawLine( eyePos + viewVec * min( TROPHY_PLACEMENT_RANGE_MIN, maxRange ), fwdResults.endPos, 0, 255, 0, true, 1.0 ) //
		DebugDrawLine( fwdResults.endPos, eyePos + viewVec * maxRange, 255, 0, 0, true, 1.0 ) //
		DebugDrawLine( fwdResults.endPos, downResults.endPos, 0, 0, 255, true, 1.0 ) //
		DebugDrawLine( player.GetOrigin(), player.GetOrigin() + ( AnglesToForward( angles ) * TROPHY_PLACEMENT_RANGE_MAX ), 0, 255, 0, true, 1.0 ) //
		DebugDrawLine( eyePos + <0,0,8>, eyePos + <0,0,8> + ( viewVec * TROPHY_PLACEMENT_RANGE_MAX ), 0, 255, 0, true, 1.0 ) //
	}

	//
	bool isScriptedPlaceable = false
	if ( IsValid( downResults.hitEnt ) )
	{
		var hitEntClassname = downResults.hitEnt.GetNetworkedClassName()

		if ( hitEntClassname == "func_brush" || hitEntClassname == "script_mover" )
		{
			isScriptedPlaceable = true
		}
		else if ( hitEntClassname == "prop_script" )
		{
			if ( downResults.hitEnt.GetScriptPropFlags() == PROP_IS_VALID_FOR_TURRET_PLACEMENT )
				isScriptedPlaceable = true
		}
	}

	bool success = !downResults.startSolid && downResults.fraction < 1.0 && ( downResults.hitEnt.IsWorld() || isScriptedPlaceable )

	entity parentTo
	if ( IsValid( downResults.hitEnt ) && ( downResults.hitEnt.GetNetworkedClassName() == "func_brush" || downResults.hitEnt.GetNetworkedClassName() == "script_mover" ) )
	{
		parentTo = downResults.hitEnt
	}

	if ( downResults.startSolid && downResults.fraction < 1.0 && ( downResults.hitEnt.IsWorld() || isScriptedPlaceable ) )
	{
		TraceResults upResults = TraceHull( downResults.endPos, downResults.endPos, TROPHY_BOUND_MINS, TROPHY_BOUND_MAXS, [player, proxy], TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_NONE )
		if ( !upResults.startSolid )
		{
			success = true
		}
		else
		{
			//
		}
	}

	vector surfaceAngles = angles

	//
	//
	if ( success && !PlayerCanSeePos( player, downResults.endPos, true, 90 ) )
	{
		surfaceAngles = angles
		success = false
		//
	}

	//
	if ( success && viewTraceResults.hitEnt != null && ( !viewTraceResults.hitEnt.IsWorld() && !isScriptedPlaceable ) )
	{
		surfaceAngles = angles
		success = false
	//
	}

	//
	if ( success && downResults.fraction < 1.0 )
	{
		surfaceAngles 	= AnglesOnSurface( downResults.surfaceNormal, AnglesToForward( angles ) )
		vector newUpDir = AnglesToUp( surfaceAngles )
		vector oldUpDir = AnglesToUp( angles )

		//
		proxy.SetOrigin( downResults.endPos )
		proxy.SetAngles( surfaceAngles )

		vector right = proxy.GetRightVector()
		vector forward = proxy.GetForwardVector()

		float length = Length( TROPHY_BOUND_MINS )

		array< vector > groundTestOffsets = [
			Normalize( right * 2 + forward ) * length,
			Normalize( -right * 2 + forward ) * length,
			Normalize( right * 2 + -forward ) * length,
			Normalize( -right * 2 + -forward ) * length
		]

		if ( TROPHY_DEBUG_DRAW_PLACEMENT )
		{
			DebugDrawLine( proxy.GetOrigin(), proxy.GetOrigin() + ( right * 64 ), 0, 255, 0, true, 1.0 ) //
			DebugDrawLine( proxy.GetOrigin(), proxy.GetOrigin() + ( forward * 64 ), 0, 0, 255, true, 1.0 ) //
		}

		//
		foreach ( vector testOffset in groundTestOffsets )
		{
			vector testPos = proxy.GetOrigin() + testOffset
			TraceResults traceResult = TraceLine( testPos + ( proxy.GetUpVector() * TROPHY_PLACEMENT_MAX_GROUND_DIST ), testPos + ( proxy.GetUpVector() * -TROPHY_PLACEMENT_MAX_GROUND_DIST ), [player, proxy], TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_NONE )

			if ( TROPHY_DEBUG_DRAW_PLACEMENT )
				DebugDrawLine( testPos + ( proxy.GetUpVector() * TROPHY_PLACEMENT_MAX_GROUND_DIST ), traceResult.endPos, 255, 0, 0, true, 1.0 ) //

			if ( traceResult.fraction == 1.0 )
			{
				surfaceAngles = angles
				success = false
				//
				break
			}
		}

		//
		if ( success && DotProduct( newUpDir, oldUpDir ) < TROPHY_ANGLE_LIMIT )
		{
			//
			success = false
			//
		}
	}

	TrophyPlacementInfo placementInfo
	placementInfo.success = success
	placementInfo.origin = downResults.endPos //
	placementInfo.angles = surfaceAngles
	placementInfo.parentTo = parentTo

	return placementInfo
}

entity function Trophy_CreateTrapPlacementProxy( asset modelName )
{
	#if SERVER
		entity proxy = CreatePropDynamic( modelName, <0,0,0>, <0,0,0> )
	#else
		entity proxy = CreateClientSidePropDynamic( <0,0,0>, <0,0,0>, modelName )
	#endif
	proxy.EnableRenderAlways()
	proxy.kv.rendermode = 3
	proxy.kv.renderamt = 1
	proxy.Anim_PlayOnly( "prop_trophy_idle_closed" )
	proxy.Hide()

	return proxy
}

#if CLIENT
void function Trophy_OnBeginPlacement( entity player, int statusEffect, bool actuallyChanged )
{
	if ( player != GetLocalViewPlayer() )
		return

	EmitSoundOnEntity( player, TROPHY_PLACEMENT_ACTIVATE_SOUND )

	asset model = TROPHY_MODEL

	thread Trophy_PlacementProxy( player, model )
}

void function Trophy_OnEndPlacement( entity player, int statusEffect, bool actuallyChanged )
{
	if ( player != GetLocalViewPlayer() )
		return

	EmitSoundOnEntity( player, TROPHY_PLACEMENT_DEACTIVATE_SOUND )

	player.Signal( "Trophy_StopPlacementProxy" )
}

void function Trophy_PlacementProxy( entity player, asset model )
{
	player.EndSignal( "Trophy_StopPlacementProxy" )

	entity proxy = Trophy_CreateTrapPlacementProxy( model )
	proxy.EnableRenderAlways()
	proxy.Show()
	DeployableModelHighlight( proxy )

	int fxHandle = StartParticleEffectOnEntity( proxy, GetParticleSystemIndex( TROPHY_PLACEMENT_RADIUS_FX ), FX_PATTACH_POINT_FOLLOW, proxy.LookupAttachment( "REF" ) )

	var placementRui        = CreateCockpitPostFXRui( $"ui/trophy_placement.rpak", RuiCalculateDistanceSortKey( player.EyePosition(), proxy.GetOrigin() ) )

	int placementAttachment = proxy.LookupAttachment( "REF" )
	RuiTrackFloat3( placementRui, "trophyPos", proxy, RUI_TRACK_POINT_FOLLOW, placementAttachment )

	OnThreadEnd(
		function() : ( proxy, fxHandle, placementRui )
		{

			RuiDestroy( placementRui )

			if ( EffectDoesExist( fxHandle ) )
				EffectStop( fxHandle, true, false )

			if ( IsValid( proxy ) )
				proxy.Destroy()

		}
	)

	while ( true )
	{
		proxy.ClearParent()

		TrophyPlacementInfo placementInfo = Trophy_GetPlacementInfo( player, proxy )

		RuiSetBool( placementRui, "success", placementInfo.success )

		if ( !placementInfo.success )
		{
			DeployableModelInvalidHighlight( proxy )
		}
		else if ( placementInfo.success )
		{
			DeployableModelHighlight( proxy )
		}

		proxy.SetOrigin( placementInfo.origin )
		proxy.SetAngles( placementInfo.angles )

		if ( IsValid( placementInfo.parentTo ) )
			proxy.SetParent( placementInfo.parentTo )

		//

		WaitFrame()
	}
}

void function Trophy_UpdateRadiusVisibility( int fxHandle, bool success )
{
	if ( success )
	{
		EffectWake( fxHandle )
	}
	else
	{
		EffectSleep( fxHandle )
	}
}

void function SCB_WattsonRechargeHint()
{
	if ( !IsAlive( GetLocalClientPlayer() ) )
		return

	CreateTransientCockpitRui( $"ui/wattson_ult_charge_tactical.rpak", HUD_Z_BASE )
	//
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


#if CLIENT
void function Trophy_OnWeaponStatusUpdate( entity player, var rui, int slot )
{
	if ( slot != OFFHAND_TACTICAL )
		return

	entity tacticalWeapon = player.GetOffhandWeapon( OFFHAND_TACTICAL )
	if ( !IsValid( tacticalWeapon ) )
		return

	string weaponName = tacticalWeapon.GetWeaponClassName()
	if ( weaponName != "mp_weapon_tesla_trap" )
		return

	bool activeSuperChargeApplied = tacticalWeapon.HasMod( "interception_pylon_super_charge" )
	RuiSetBool( rui, "rechargeBoosted", activeSuperChargeApplied )
}
#endif


#if CLIENT
void function Trophy_OnPropScriptCreated( entity ent )
{
	switch ( ent.GetScriptName() )
	{
		case "trophy_system":
			//
			break
	}
}

void function Trophy_CreateHUDMarker( entity trophy )
{
	trophy.EndSignal( "OnDestroy" )

	entity localViewPlayer = GetLocalViewPlayer()
	if ( !Trophy_ShouldShowIcon( localViewPlayer, trophy ) )
		return

	vector pos = trophy.GetOrigin() + ( trophy.GetUpVector() * TROPHY_ICON_HEIGHT )
	var rui = CreateCockpitRui( $"ui/dirty_bomb_marker_icons.rpak", RuiCalculateDistanceSortKey( localViewPlayer.EyePosition(), pos ) )
	RuiSetGameTime( rui, "startTime", Time() )
	RuiTrackFloat3( rui, "pos", trophy, RUI_TRACK_OVERHEAD_FOLLOW )
	RuiKeepSortKeyUpdated( rui, true, "pos" )

	asset icon = $"rui/hud/ultimate_icons/ultimate_wattson_in_world"

	RuiSetImage( rui, "bombImage", icon )
	RuiSetImage( rui, "triggeredImage", icon )

	OnThreadEnd(
		function() : ( rui )
		{
			RuiDestroy( rui )
		}
	)

	WaitForever()
}

bool function Trophy_ShouldShowIcon( entity localViewPlayer, entity trapProxy )
{
	if ( !IsValid( localViewPlayer ) )
		return false

	if ( localViewPlayer.GetTeam() != trapProxy.GetTeam() )
		return false

	if ( !GamePlayingOrSuddenDeath() )
		return false

	return true
}

void function TacticalChargeVisualsEnabled( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( ent != GetLocalViewPlayer() )
		return

	entity player = ent

	entity cockpit = player.GetCockpit()
	if ( !IsValid( cockpit ) )
		return

	thread TacticalChargeFXThink( player, cockpit )
}

void function TacticalChargeVisualsDisabled( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( ent != GetLocalViewPlayer() )
		return

	ent.Signal( "EndTacticalChargeRepair" )
}

void function TacticalChargeFXThink( entity player, entity cockpit )
{
	player.EndSignal( "EndTacticalChargeRepair" )
	player.EndSignal( "OnDeath" )
	cockpit.EndSignal( "OnDestroy" )

	entity tacticalWeapon = player.GetOffhandWeapon( OFFHAND_TACTICAL )

	if ( !IsValid( tacticalWeapon ) )
		return

	string weaponName = tacticalWeapon.GetWeaponClassName()
	if ( weaponName != "mp_weapon_tesla_trap" )
		return

	tacticalWeapon.EndSignal( "OnDestroy" )

	OnThreadEnd(
		function() : ()
		{
			if ( !EffectDoesExist( file.tacticalChargeFXHandle ) )
				return

			EffectStop( file.tacticalChargeFXHandle, false, true )
		}
	)

	for ( ;; )
	{
		if ( !EffectDoesExist( file.tacticalChargeFXHandle ) )
		{
			file.tacticalChargeFXHandle = StartParticleEffectOnEntity( cockpit, GetParticleSystemIndex( TACTICAL_CHARGE_FX ), FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
			EffectSetIsWithCockpit( file.tacticalChargeFXHandle, true )
			EmitSoundOnEntity( player, TROPHY_TACTICAL_CHARGE_SOUND )
		}

		vector controlPoint = <1,1,1>
		EffectSetControlPointVector( file.tacticalChargeFXHandle, 1, controlPoint )
		WaitFrame()
	}
}


void function ShieldRepairVisualsEnabled( entity player, int statusEffect, bool actuallyChanged )
{
	if ( player == GetLocalViewPlayer() )
	{
		EmitSoundOnEntity( player, TROPHY_SHIELD_REPAIR_START )
		return
	}

	thread TacticalShieldRepairFXStart( player )
}

void function ShieldRepairVisualsDisabled( entity player, int statusEffect, bool actuallyChanged )
{
	if ( player == GetLocalViewPlayer() )
	{
		if ( player.GetShieldHealth() == player.GetShieldHealthMax() )
			EmitSoundOnEntity( player, TROPHY_SHIELD_REPAIR_END )
	}

	player.Signal( "EndTacticalShieldRepair" )
}

void function TacticalShieldRepairFXStart( entity player )
{
	player.Signal( "EndTacticalShieldRepair" )
	player.EndSignal( "EndTacticalShieldRepair" )
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )

	int oldArmorTier = -1
	int attachID         = player.LookupAttachment( "CHESTFOCUS" )
	int shieldChargeFXID = GetParticleSystemIndex( TROPHY_PLAYER_SHIELD_CHARGE_FX )
	int fxID = StartParticleEffectOnEntity( player, shieldChargeFXID, FX_PATTACH_POINT_FOLLOW, attachID )

	OnThreadEnd(
		function() : ( fxID )
		{
			if ( EffectDoesExist( fxID ) )
				EffectStop( fxID, true, true )
		}
	)

	while( true )
	{
		int armorTier = EquipmentSlot_GetEquipmentTier( player, "armor" )
		if ( armorTier != oldArmorTier )
		{
			oldArmorTier = armorTier
			vector shieldColor = GetFXRarityColorForTier( armorTier )
			EffectSetControlPointVector( fxID, 2, shieldColor )
		}

		WaitSignal( player, "UpdateShieldRepair" )
	}
}

void function ArmorChanged( entity player, string equipSlot, int new )
{
	player.Signal( "UpdateShieldRepair" )
}
#endif //
