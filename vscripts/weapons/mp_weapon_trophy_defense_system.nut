untyped

global function MpWeaponTrophy_Init
global function OnWeaponAttemptOffhandSwitch_weapon_trophy_defense_system

global function OnWeaponActivate_weapon_trophy_defense_system
global function OnWeaponDeactivate_weapon_trophy_defense_system
global function OnWeaponPrimaryAttack_weapon_trophy_defense_system

#if CLIENT
global function SCB_WattsonRechargeHint
#endif

const vector TROPHY_RING_COLOR = <134, 182, 255>

                
const asset TROPHY_START_FX = $"P_wpn_trophy_loop_st"
const asset TROPHY_ELECTRICITY_FX = $"P_wpn_trophy_loop_1"
const asset TROPHY_INTERCEPT_PROJECTILE_SMALL_FX = $"P_wpn_trophy_imp_sm"                        
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
const float TROPHY_AR_EFFECT_SIZE = 768.0 
const float TROPHY_ENDTIME =  60
// FX Table
global const string TROPHY_SYSTEM_NAME = "trophy_system"
global const string TROPHY_SYSTEM_MOVER_NAME = "trophy_system_mover"

                     
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
const int statusEffect = eStatusEffect.placing_trophy_system

// Intersection
const vector TROPHY_INTERSECTION_BOUND_MINS = <-16,-16,0>
const vector TROPHY_INTERSECTION_BOUND_MAXS = <16,16,32>

// 
const int TROPHY_DEPLOY_COUNT = 3
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
const int TROPHY_SHIELD_REPAIR_AMOUNT = 1
const int TROPHY_DEPLOY_COUNT_UPDATE = 1
const float TROPHY_SHIELD_REPAIR_INTERVAL_UPDATE = 0.2
const int TROPHY_SHIELD_REPAIR_AMOUNT_UPDATE = 1
const float TROPHY_SHIELD_DAMAGED_DELAY = 1.0
const float TROPHY_LOS_CHARGE_TIMEOUT = 1.0
const asset TACTICAL_CHARGE_FX = $"P_player_boost_screen"//
const int TROPHY_SHIELD_AMOUNT = 250


// Trigger
const float TROPHY_REMINDER_TRIGGER_RADIUS = 512.0
const float TROPHY_REMINDER_TRIGGER_DBOUNCE = 30.0

// Animations, thanks @r-ex!
const string CLOSE = "prop_trophy_close"
const string EXPAND = "prop_trophy_expand"				// for placing
const string IDLE_CLOSED = "prop_trophy_idle_closed"
const string IDLE_OPEN = "prop_trophy_idle_open"		// actually makes it spin like in retail
const string SPIN = "prop_trophy_idle_open_spin"		// slow spin

// Debug
const bool TROPHY_DEBUG_DRAW = false
const bool TROPHY_DEBUG_DRAW_PLACEMENT = false
const bool TROPHY_DEBUG_DRAW_INTERSECTION = false

//Custom Stuff
const bool TROPHY_DESTROY_FRIENDLY_PROJECTILES = true
const bool SUPER_BUFF_THREATVISION = false
const bool SUPER_BUFF_SPEEDBOOST = false
const bool TROPHY_DESTROYS_EVERYTHING = false

#if CLIENT
const float TROPHY_ICON_HEIGHT = 96.0
#endif

struct TrophyPlacementInfo
{
	vector origin
	vector angles
	entity parentTo
	bool success = false
}


struct
{
	#if SERVER
	array<entity>	trophyDefenseSystems
	int				numActiveTrophyDefenseSystems
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

	//Needs to be registered on the server and client
	RegisterSignal( "EndTacticalShieldRepair" )
	RegisterSignal( "Trophy_StopPlacementProxy" )

	#if CLIENT
		PrecacheParticleSystem( TACTICAL_CHARGE_FX )
		PrecacheParticleSystem( TROPHY_PLACEMENT_RADIUS_FX )
		PrecacheParticleSystem( TROPHY_PLAYER_SHIELD_CHARGE_FX )
		
		StatusEffect_RegisterEnabledCallback( eStatusEffect.placing_trophy_system, Trophy_OnBeginPlacement)
		StatusEffect_RegisterDisabledCallback( eStatusEffect.placing_trophy_system, Trophy_OnEndPlacement )
	
		StatusEffect_RegisterEnabledCallback( eStatusEffect.trophy_tactical_charge, TacticalChargeVisualsEnabled )
		StatusEffect_RegisterDisabledCallback( eStatusEffect.trophy_tactical_charge, TacticalChargeVisualsDisabled )
		
		AddCreateCallback( "prop_script", Trophy_OnPropScriptCreated )

		RegisterSignal( "Trophy_StopPlacementProxy" )
		RegisterSignal( "EndTacticalChargeRepair" )
		RegisterSignal( "UpdateShieldRepair" )

		AddCallback_OnWeaponStatusUpdate( Trophy_OnWeaponStatusUpdate )
		AddCallback_MinimapEntShouldCreateCheck_Scriptname( TROPHY_SYSTEM_NAME, Minimap_DontCreateRuisForEnemies )
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
	
	StatusEffect_StopAllOfType( ownerPlayer, statusEffect )
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
	{
		weapon.DoDryfire()
		
		return 0
	}

	#if SERVER
		printl("[pylon] server thing")
		thread WeaponMakesDefenseSystem(weapon, model, placementInfo)

	if( !IsValid( ownerPlayer ) || !ownerPlayer.IsPlayer() )
		return
	
	ItemFlavor character = LoadoutSlot_GetItemFlavor( ToEHI( ownerPlayer ), Loadout_CharacterClass() )
	string charRef = ItemFlavor_GetHumanReadableRef( character )

	if( charRef == "character_wattson")
		PlayBattleChatterLineToSpeakerAndTeam( ownerPlayer, "bc_super" )
	#endif
	printl("[pylon] after placement")
	StatusEffect_StopAllOfType( ownerPlayer, eStatusEffect.placing_trophy_system )
	PlayerUsedOffhand( ownerPlayer, weapon, true, null, {pos = placementInfo.origin} )

	int ammoReq = weapon.GetAmmoPerShot()
	return ammoReq
}

TrophyPlacementInfo function Trophy_GetPlacementInfo( entity player, entity proxy )
{
	vector eyePos              = player.EyePosition()
	vector viewVec             = player.GetViewVector()

	TrophyPlacementInfo info = _GetPlacementInfo( player, proxy, eyePos, viewVec )

	if ( !info.success && player.IsStanding() )
	{
		TrophyPlacementInfo crouchInfo = _GetPlacementInfo( player, proxy, eyePos - <0,0,32>, viewVec, false )

		if ( crouchInfo.success )
			return crouchInfo
	}

	return info
}

TrophyPlacementInfo function _GetPlacementInfo( entity player, entity proxy, vector eyePos, vector viewVec, bool doUpTrace = true )
{
	vector angles              = < 0, VectorToAngles( viewVec ).y, 0 >
	array< entity > ignoreEnts = [player, proxy]

	float maxRange = TROPHY_PLACEMENT_RANGE_MAX

	TraceResults viewTraceResults = TraceLine( eyePos, eyePos + player.GetViewVector() * (TROPHY_PLACEMENT_RANGE_MAX * 2), ignoreEnts, TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_NONE, player )
	if ( viewTraceResults.fraction < 1.0 )
	{
		float slope = fabs( viewTraceResults.surfaceNormal.x ) + fabs( viewTraceResults.surfaceNormal.y )
		if ( slope < TROPHY_ANGLE_LIMIT )
			maxRange = min( Distance( eyePos, viewTraceResults.endPos ), TROPHY_PLACEMENT_RANGE_MAX )
	}

	int collisionGroup 	= TRACE_COLLISION_GROUP_PLAYER
	int traceMask		= TRACE_MASK_NPCSOLID

	vector idealPos          = player.GetOrigin() + (AnglesToForward( angles ) * TROPHY_PLACEMENT_RANGE_MAX)
	vector defaultUpVector   = < 0, 0, 1.0 >
	TraceResults fwdResults  = TraceHull( eyePos, eyePos + viewVec * maxRange, TROPHY_BOUND_MINS, TROPHY_BOUND_MAXS, ignoreEnts, traceMask, collisionGroup, defaultUpVector, player )
	TraceResults downResults = TraceHull( fwdResults.endPos, fwdResults.endPos - TROPHY_PLACEMENT_TRACE_OFFSET, TROPHY_BOUND_MINS, TROPHY_BOUND_MAXS, ignoreEnts, traceMask, collisionGroup, defaultUpVector, player )
	TraceResults useResults  = downResults

	bool isScriptedPlaceable = false
	bool isUpTraced = false

	vector upStart	= ( fwdResults.endPos + viewVec * 60.0 ) + <0, 0, 40.0>
	vector upEnd	= upStart - <0, 0, 80.0>
	TraceResults upResults = TraceHull( upStart, upEnd, TROPHY_BOUND_MINS, TROPHY_BOUND_MAXS, ignoreEnts, traceMask, collisionGroup, <0, 0, 1>, player )

	vector roofTraceEnd = <eyePos.x, eyePos.y, upResults.endPos.z> + ( <viewVec.x, viewVec.y, 0> * 20.0 )
	TraceResults roofTraceResults = TraceLine( eyePos, roofTraceEnd, ignoreEnts, TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_NONE, player )


	if ( doUpTrace && roofTraceResults.fraction >= 0.99 )
	{
		if ( IsValid( upResults.hitEnt ) )
			isScriptedPlaceable = Placement_IsHitEntScriptedPlaceable( upResults.hitEnt, 1 )

		if ( !upResults.startSolid && upResults.fraction < 1.0 && (upResults.hitEnt.IsWorld() || isScriptedPlaceable) )
		{
			useResults = upResults
			isUpTraced = true
		}
	}

	// if ( TROPHY_DEBUG_DRAW_PLACEMENT )
	// {
		// DebugDrawBox( fwdResults.endPos, TROPHY_BOUND_MINS, TROPHY_BOUND_MAXS, COLOR_GREEN, 1, 1.0 )                                 
		// DebugDrawBox( downResults.endPos, TROPHY_BOUND_MINS, TROPHY_BOUND_MAXS, COLOR_BLUE, 1, 1.0 )                                  
		// DebugDrawLine( eyePos + viewVec * min( TROPHY_PLACEMENT_RANGE_MIN, maxRange ), fwdResults.endPos, COLOR_GREEN, true, 1.0 )                    
		// DebugDrawLine( fwdResults.endPos, eyePos + viewVec * maxRange, COLOR_RED, true, 1.0 )                            
		// DebugDrawLine( fwdResults.endPos, downResults.endPos, COLOR_BLUE, true, 1.0 )                     
		// DebugDrawBox( upResults.endPos, TROPHY_BOUND_MINS, TROPHY_BOUND_MAXS, COLOR_CYAN, 1, 1.0 )                                  
		// DebugDrawLine( upStart, upResults.endPos, COLOR_CYAN, true, 1.0 )                     
		// DebugDrawLine( eyePos, roofTraceEnd, COLOR_MAGENTA, true, 1.0 )             
		// DebugDrawLine( player.GetOrigin(), player.GetOrigin() + (AnglesToForward( angles ) * TROPHY_PLACEMENT_RANGE_MAX), COLOR_GREEN, true, 1.0 )                     
		// DebugDrawLine( eyePos + <0, 0, 8>, eyePos + <0, 0, 8> + (viewVec * TROPHY_PLACEMENT_RANGE_MAX), COLOR_GREEN, true, 1.0 )                     
	// }

	                                                           
	if ( !isUpTraced && IsValid( useResults.hitEnt ) )
		isScriptedPlaceable = Placement_IsHitEntScriptedPlaceable( useResults.hitEnt, 1 )

	bool success = isUpTraced || ( !useResults.startSolid && useResults.fraction < 1.0 && (useResults.hitEnt.IsWorld() || isScriptedPlaceable) )

	entity parentTo
	if ( IsValid( useResults.hitEnt ) && (useResults.hitEnt.GetNetworkedClassName() == "func_brush" || useResults.hitEnt.GetNetworkedClassName() == "script_mover") )
	{
		parentTo = useResults.hitEnt
	}

	if ( downResults.startSolid && downResults.fraction < 1.0 && (downResults.hitEnt.IsWorld() || isScriptedPlaceable) )
	{
		TraceResults hullResults = TraceHull( downResults.endPos, downResults.endPos, TROPHY_BOUND_MINS, TROPHY_BOUND_MAXS, ignoreEnts, TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_NONE )
		if ( hullResults.startSolid )
			success = false
	}

	vector surfaceAngles = angles

	                        
	                                                                
	if ( !isUpTraced )
	{
		if ( success && !PlayerCanSeePos( player, useResults.endPos, true, 90 ) )
		{
			surfaceAngles = angles
			success = false
			                                                             
		}
	}

	              
	if ( success && viewTraceResults.hitEnt != null && (!viewTraceResults.hitEnt.IsWorld() && !isScriptedPlaceable) )
	{
		surfaceAngles = angles
		success = false
		  	                                                               
	}

	                                           
	if ( success && useResults.fraction < 1.0 )
	{
		surfaceAngles = AnglesOnSurface( useResults.surfaceNormal, AnglesToForward( angles ) )
		vector newUpDir = AnglesToUp( surfaceAngles )
		vector oldUpDir = AnglesToUp( angles )

		                   
		proxy.SetOrigin( useResults.endPos )
		proxy.SetAngles( surfaceAngles )

		vector right   = proxy.GetRightVector()
		vector forward = proxy.GetForwardVector()

		float length = Length( TROPHY_BOUND_MINS ) / 1.5
		length = length / 1.5

		array< vector > groundTestOffsets = [
			Normalize( right * 2 + forward ) * length,
			Normalize( -right * 2 + forward ) * length,
			Normalize( right * 2 + -forward ) * length,
			Normalize( -right * 2 + -forward ) * length
		]

		// if ( TROPHY_DEBUG_DRAW_PLACEMENT )
		// {
			// DebugDrawLine( proxy.GetOrigin(), proxy.GetOrigin() + (right * 64), COLOR_GREEN, true, 1.0 )                      
			// DebugDrawLine( proxy.GetOrigin(), proxy.GetOrigin() + (forward * 64), COLOR_BLUE, true, 1.0 )                        
		// }

		                                                 
		foreach ( vector testOffset in groundTestOffsets )
		{
			vector testPos           = proxy.GetOrigin() + testOffset
			TraceResults traceResult = TraceLine( testPos + (proxy.GetUpVector() * TROPHY_PLACEMENT_MAX_GROUND_DIST), testPos + (proxy.GetUpVector() * -TROPHY_PLACEMENT_MAX_GROUND_DIST), ignoreEnts, traceMask, collisionGroup )

			// if ( TROPHY_DEBUG_DRAW_PLACEMENT )
				// DebugDrawLine( testPos + (proxy.GetUpVector() * TROPHY_PLACEMENT_MAX_GROUND_DIST), traceResult.endPos, COLOR_RED, true, 1.0 )                   

			if ( traceResult.fraction == 1.0 )
			{
				surfaceAngles = angles
				success = false
				                                                                    
				break
			}
		}

		                     
		if ( success && DotProduct( newUpDir, oldUpDir ) < TROPHY_ANGLE_LIMIT )
		{
			                        
			success = false
			                                                        
		}
	}

	                           
	if ( success && IsValid( useResults.hitEnt ) && IsEntInvalidForPlacingPermanentOnto( useResults.hitEnt ) )
		success = false

	if ( success && IsOriginInvalidForPlacingPermanentOnto( useResults.endPos ) )
		success = false


	if( success )
	{
		TraceResults playerResults = TraceHull( useResults.endPos, useResults.endPos, TROPHY_BOUND_MINS, TROPHY_BOUND_MAXS, [proxy], TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_NONE, defaultUpVector, player  )
		if( IsValid( playerResults.hitEnt ) && playerResults.hitEnt.IsPlayer() )
			success = false
	}

	TrophyPlacementInfo placementInfo
	placementInfo.success = success
	placementInfo.origin = useResults.endPos
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
	proxy.Anim_PlayOnly( IDLE_CLOSED )
	proxy.Hide()

	return proxy
}

#if CLIENT
void function Trophy_OnBeginPlacement( entity player, int statusEffect, bool actuallyChanged )
{
	if ( player != GetLocalViewPlayer() )
		return
	printl("[pylon] beginning proxy")
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
	printl("[pylon] placing proxy")

	entity proxy = Trophy_CreateTrapPlacementProxy( model )
	proxy.EnableRenderAlways()
	proxy.Show()
	DeployableModelHighlight( proxy )

	int fxHandle = StartParticleEffectOnEntity( proxy, GetParticleSystemIndex( TROPHY_PLACEMENT_RADIUS_FX ), FX_PATTACH_POINT_FOLLOW, proxy.LookupAttachment( "REF" ) )
	printl("particle " + fxHandle)
	
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
}

#endif

#if SERVER
// Primary function to place Wattson's ult
void function WeaponMakesDefenseSystem( entity weapon, asset model, TrophyPlacementInfo placementInfo  ) {
	printf("[pylon] Placing the pylon!")

	entity owner = weapon.GetOwner()
	owner.EndSignal( "OnDestroy" )

	// sets up the pylon prop_script
	if( IsValid( owner.p.lastTrophy ) )
	{
		entity trophy = owner.p.lastTrophy
		entity expFx = StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( TROPHY_DESTROY_FX ), trophy.GetOrigin(), VectorToAngles( trophy.GetForwardVector() ) )
		trophy.e.isDisabled = true
		EmitSoundAtPosition( TEAM_ANY, trophy.GetOrigin(), TROPHY_DESTROY_SOUND )
		thread CreateAirShake( trophy.GetOrigin(), 2, 50, 1 )
		trophy.Destroy()
	}
	
	entity pylon = CreateEntity( "prop_script" )
	{
		pylon.SetValueForModelKey( model )
		pylon.kv.fadedist = -1
		pylon.kv.renderamt = 255
		pylon.kv.rendercolor = "255 255 255"
		pylon.kv.solid = 6

		//SetTeam( pylon, owner.GetTeam() )

		Highlight_SetOwnedHighlight( pylon, "sp_friendly_hero" )
		Highlight_SetFriendlyHighlight( pylon, "sp_friendly_hero" )
		pylon.SetOrigin( placementInfo.origin )
		pylon.SetAngles( placementInfo.angles )
		pylon.SetScriptName( TROPHY_SYSTEM_NAME )
		DispatchSpawn( pylon )
		owner.p.lastTrophy = pylon
		pylon.SetBossPlayer( owner )
		pylon.DisableHibernation()
		AddTrophyToMinimap( pylon )
		
		pylon.RemoveFromAllRealms()
		pylon.AddToOtherEntitysRealms( owner )
		
		pylon.SetMaxHealth( TROPHY_HEALTH_AMOUNT )
		pylon.SetHealth( TROPHY_HEALTH_AMOUNT )
		pylon.SetTakeDamageType( DAMAGE_EVENTS_ONLY )
		pylon.SetDamageNotifications( true )
		pylon.SetCanBeMeleed( true )		
		pylon.e.pylonhealth = TROPHY_HEALTH_AMOUNT
		pylon.EndSignal( "OnDestroy" )
		pylon.AllowMantle()
	}

	if( IsValid( placementInfo.parentTo ) ) // Parent to moving ents like train
	{
		entity parentPoint = CreateEntity( "script_mover_lightweight" )
		parentPoint.kv.solid = 0
		parentPoint.SetValueForModelKey( pylon.GetModelName() )
		parentPoint.kv.SpawnAsPhysicsMover = 0
		parentPoint.SetOrigin( placementInfo.origin )
		parentPoint.SetAngles( placementInfo.angles )
		DispatchSpawn( parentPoint )
		parentPoint.SetParent( placementInfo.parentTo )
		parentPoint.Hide()
		pylon.SetParent(parentPoint)
	}
			
	// can be detected by sonar
	pylon.Highlight_Enable()
	AddSonarDetectionForPropScript( pylon )

	TrackingVision_CreatePOI( eTrackingVisionNetworkedPOITypes.PLAYER_ABILITY_TROPHY_SYSTEM, owner, pylon.GetOrigin(), owner.GetTeam(), owner )

	TrophyDeathSetup( pylon )
	
	//Pylon Start FX and sound
	EmitSoundOnEntity(pylon, TROPHY_EXPAND_SOUND)
	StartParticleEffectOnEntity( pylon, GetParticleSystemIndex( TROPHY_START_FX ), FX_PATTACH_ABSORIGIN_FOLLOW, 0 )
	thread PlayAnim( pylon, EXPAND, pylon.GetParent() )
	
	wait pylon.GetSequenceDuration( EXPAND ) - 1.5
	
	thread Trophy_Watcher( pylon )
	thread Trophy_Anims( pylon )
	waitthread Trophy_CreateTriggerArea( pylon )
}

void function Trophy_Watcher( entity trophy )
{
	EndSignal( trophy, "OnDestroy" )
	
	entity player = trophy.GetBossPlayer()
	// EndSignal( player, "OnDeath" )
	// EndSignal( player, "OnDestroy" )
	
	//float endtime = Time() + TROPHY_ENDTIME
	
	OnThreadEnd(
		function() : ( trophy )
		{
			StartParticleEffectInWorld( GetParticleSystemIndex( TROPHY_DESTROY_FX ), trophy.GetOrigin(), VectorToAngles( trophy.GetForwardVector() ) )
			trophy.e.isDisabled = true
			EmitSoundAtPosition( TEAM_ANY, trophy.GetOrigin(), TROPHY_DESTROY_SOUND )
			thread CreateAirShake( trophy.GetOrigin(), 2, 50, 1 )
			trophy.Destroy()
		}
	)
	
	while( IsValid( trophy ) ) //&& IsValid( player ) && IsAlive( player ) ) //&& Time() < endtime )
		WaitFrame()
}

void function AddTrophyToMinimap( entity trophy )
{
	entity player = trophy.GetBossPlayer()
	entity minimapObj = trophy
	minimapObj.Minimap_SetCustomState( eMinimapObject_prop_script.TROPHY_SYSTEM )
	minimapObj.Minimap_AlwaysShow( player.GetTeam(), null )
	minimapObj.Minimap_SetAlignUpright( true )
	minimapObj.Minimap_SetZOrder( MINIMAP_Z_OBJECT-1 )
}

// spins and makes particles
void function Trophy_Anims( entity pylon ) {
	EndSignal( pylon, "OnDestroy" )

	//Pylon Idle FX and sound
	StartParticleEffectOnEntityWithPos( pylon, GetParticleSystemIndex( TROPHY_ELECTRICITY_FX ), FX_PATTACH_CUSTOMORIGIN_FOLLOW, -1, <0, 0, 60>, <0, 0, 0> )
	EmitSoundOnEntity( pylon, TROPHY_ELECTRIC_IDLE_SOUND )
	thread PlayAnim( pylon, IDLE_OPEN, pylon.GetParent()  )
}

// Creates the active area 
// based on the code i'm copying (deployable_medic.nut), this is team agnostic
// Intercepts projectiles, charges shields
void function Trophy_CreateTriggerArea( entity pylon ) {
	printl("[pylon] Trigger area created")
	Assert ( IsNewThread(), "Must be threaded" )
	pylon.EndSignal( "OnDestroy" )

	vector origin = pylon.GetOrigin()

	// Creates a trigger for shields
	entity trigger = CreateEntity( "trigger_cylinder" )
	trigger.SetOwner( pylon )
	trigger.SetRadius( TROPHY_REMINDER_TRIGGER_RADIUS )
	trigger.SetAboveHeight( TROPHY_REMINDER_TRIGGER_RADIUS )
	trigger.SetBelowHeight( 48 )
	trigger.SetOrigin( origin )
	trigger.SetPhaseShiftCanTouch( false )
	DispatchSpawn( trigger )

	trigger.RemoveFromAllRealms()
	trigger.AddToOtherEntitysRealms( pylon )

	trigger.SetEnterCallback( OnTrophyShieldAreaEnter )
	trigger.SetLeaveCallback( OnTrophyShieldAreaLeave )
	
	trigger.SetParent( pylon )
	trigger.SetOrigin( origin )

	// Creates a trigger for projectiles
	entity vortexSphere = CreateEntity( "vortex_sphere" )
	int spawnFlags = SF_ABSORB_CYLINDER | SF_BLOCK_OWNER_WEAPON //SF_ABSORB_BULLETS | SF_BLOCK_NPC_WEAPON_LOF |
	vortexSphere.kv.height = TROPHY_INTERCEPT_PROJECTILE_RANGE
	vortexSphere.kv.spawnflags = spawnFlags
	vortexSphere.kv.enabled = 1
	vortexSphere.kv.radius = TROPHY_INTERCEPT_PROJECTILE_RANGE
	vortexSphere.kv.bullet_fov = 105
	vortexSphere.kv.physics_pull_strength = 25
	vortexSphere.kv.physics_side_dampening = 6
	vortexSphere.kv.physics_fov = 360
	vortexSphere.kv.physics_max_mass = 2
	vortexSphere.kv.physics_max_size = 6
	
	vortexSphere.RemoveFromAllRealms()
	vortexSphere.AddToOtherEntitysRealms( pylon )	
	
	SetCallback_VortexSphereTriggerOnProjectileHit( vortexSphere, Pylon_OnProjectilesTriggerTouch ) //normal bullets + grenades
	SetTargetName( vortexSphere, VORTEX_TRIGGER_AREA )
	
	DispatchSpawn( vortexSphere )

	vortexSphere.SetOwner( pylon )
	vortexSphere.SetOrigin( origin )
	vortexSphere.SetParent( pylon )
	vortexSphere.SetAbsAngles( <0,0,0> ) //Setting local angles on a parented object is not supported
	vortexSphere.LinkToEnt( trigger )

	OnThreadEnd(
		function() : ( trigger, vortexSphere )
		{
			if ( IsValid( trigger ) )
				trigger.Destroy()
			
			if( IsValid( vortexSphere ) )
				vortexSphere.Destroy()
		}
	)
	
	waitthread Trophy_ShieldUpdate( trigger, pylon )
}

void function Pylon_OnProjectilesTriggerTouch( entity vortexSphere, entity vortexTrigger, entity attacker, entity projectile, vector aPosition )
{
	if( !IsValid(vortexTrigger) )
		return

	if( !IsValid( projectile ) )
		return
	
	entity pylonowner = vortexTrigger.GetOwner()
	entity pylon = vortexTrigger.GetParent()
	entity playersTrigger = vortexTrigger.GetLinkEnt()
	
	if( !IsValid( playersTrigger ) )
		return

	//If TROPHY_DESTROY_FRIENDLY_PROJECTILES is set to false dont destroy teammates projectiles
	if(!TROPHY_DESTROY_FRIENDLY_PROJECTILES)
	{
		if( projectile.GetTeam() == pylonowner.GetTeam() )
			continue
	}

	//Check if the player threw the projectile in the trigger range
	//If so dont zap this entity
	entity player = projectile.GetOwner()
	
	if( !IsValid( player ) || !IsAlive( player ) )
		return

	if( playersTrigger.IsTouching( player ))
	{
		if (projectile.GetOwner() == player)
		{
			return
		}
	}

	HandleProjectileDestruction( player, pylon, projectile )
}

void function HandleProjectileDestruction( entity player, entity pylon, entity projectile ) 
{
	if( !IsValid( projectile) || projectile.IsMarkedForDeletion() || !IsValid( pylon ) )
		return
	
	//Get weaponclassname from ent
	string pclassname = projectile.ProjectileGetWeaponClassName()

	if( TROPHY_DESTROYS_EVERYTHING )
	{
		printt( "[pylon] Projectile destroyed! " + projectile )
	
		//Sound for zap
		EmitSoundOnEntity( pylon, TROPHY_INTERCEPT_SMALL )

		//Effects for zap
		entity zap = StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( TROPHY_INTERCEPT_PROJECTILE_CLOSE_FX ), projectile.GetOrigin(), projectile.GetAngles() )
		vector pyloncenter = pylon.GetOrigin() + <0, 0, 60>
		EffectSetControlPointVector( zap, 1, pyloncenter )

		//Destroy ent
		projectile.Destroy()	
		return
	}

	switch ( pclassname )
	{
		case "mp_weapon_grenade_gas":
			//Reset ult to no charge if used
			player.GetOffhandWeapon( OFFHAND_INVENTORY ).SetWeaponPrimaryClipCount( 0 )
		case "mp_weapon_grenade_defensive_bombardment":
			//Reset ult to no charge if used
			player.GetOffhandWeapon( OFFHAND_INVENTORY ).SetWeaponPrimaryClipCount( 0 )
		case "mp_weapon_grenade_creeping_bombardment":
			//Reset ult to no charge if used
			player.GetOffhandWeapon( OFFHAND_INVENTORY ).SetWeaponPrimaryClipCount( 0 )
		case "mp_weapon_grenade_emp":
		case "mp_weapon_frag_grenade":
		case "mp_weapon_thermite_grenade":
		case "mp_weapon_dirty_bomb":
		case "mp_weapon_grenade_bangalore":
		case "mp_weapon_bubble_bunker":
			//Sound for zap
			EmitSoundOnEntity( pylon, TROPHY_INTERCEPT_SMALL )
	
			//Effects for zap
			entity zap = StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( TROPHY_INTERCEPT_PROJECTILE_CLOSE_FX ), projectile.GetOrigin(), projectile.GetAngles() )
			vector pyloncenter = pylon.GetOrigin() + <0, 0, 60>
			EffectSetControlPointVector( zap, 1, pyloncenter )

			printt( "[pylon] Projectile destroyed! " + projectile )
	
			//Destroy ent
			projectile.Destroy()	
			return
		default:
			break
	}
	
		
	if( projectile.GetClassName() == "grenade" )
	{
		//Sound for zap
		EmitSoundOnEntity( pylon, TROPHY_INTERCEPT_SMALL )

		//Effects for zap
		entity zap = StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( TROPHY_INTERCEPT_PROJECTILE_CLOSE_FX ), projectile.GetOrigin(), projectile.GetAngles() )
		vector pyloncenter = pylon.GetOrigin() + <0, 0, 60>
		EffectSetControlPointVector( zap, 1, pyloncenter )

		printt( "[pylon] Projectile destroyed! " + projectile )

		//Destroy ent
		projectile.Destroy()
	}
}


void function OnTrophyShieldAreaEnter( entity trigger, entity ent )
{
	printl("[pylon] entered - " + ent)
	
	entity trophy = trigger.GetParent() 

	if( ent.GetClassName()  == "grenade" )
	{
		HandleProjectileDestruction( null, trophy, ent )
		return
	}

	if ( ent.IsPlayer() )
	{
		thread NewTacticalShieldRepairFXStart(ent)
		thread RadiusReminderFX( trophy )
		EmitSoundOnEntityOnlyToPlayer( ent, ent, TROPHY_SHIELD_REPAIR_START )
	}
}

void function OnTrophyShieldAreaLeave( entity trigger, entity ent )
{
	if ( !ent.IsPlayer() )
		return

	printl("[pylon] leaving - " + ent)

	EmitSoundOnEntityOnlyToPlayer( ent, ent, TROPHY_SHIELD_REPAIR_END)

	//Kill Particals and FX from player once they leave the trigger
	ent.Signal( "EndTacticalShieldRepair" )
}

//Regen shields function
void function Trophy_ShieldUpdate( entity trigger, entity pylon )
{
	Assert ( IsNewThread(), "Must be threaded off." )
	trigger.EndSignal( "OnDestroy" )
	pylon.EndSignal( "OnDestroy" )

	OnThreadEnd(
		function() : ( pylon )
		{
			if ( IsValid( pylon ) )
			{
				StopSoundOnEntity( pylon, TROPHY_SHIELD_REPAIR_START )
			}
		}
	)

	while(IsValid(trigger))
    {
		if( IsValid( pylon ) && pylon.e.shieldAmountCount >= TROPHY_SHIELD_AMOUNT )
		{
			trigger.Destroy()
			break
		}
		
        foreach(player in GetPlayerArray_Alive())
        {
            if(!IsValid(player)) continue
            if(Distance(player.GetOrigin(), pylon.GetOrigin()) < TROPHY_REMINDER_TRIGGER_RADIUS)
            {
				if (player.GetShieldHealth() < player.GetShieldHealthMax())
				{
					int currentplayersheilds = player.GetShieldHealth()
					int newplayersheilds = currentplayersheilds + TROPHY_SHIELD_REPAIR_AMOUNT
					player.SetShieldHealth( newplayersheilds )
					pylon.e.shieldAmountCount+= float( TROPHY_SHIELD_REPAIR_AMOUNT )
				}
            }
        }
		wait TROPHY_SHIELD_REPAIR_INTERVAL
    }
}

//FX, sounds, and status effects function
void function NewTacticalShieldRepairFXStart( entity player )
{
	player.Signal( "EndTacticalShieldRepair" )
	player.EndSignal( "EndTacticalShieldRepair" )
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )

	//Armor 3P Repair FX
	int oldArmorTier = -1
	int AttachID = player.LookupAttachment( "CHESTFOCUS" )
	entity fxID = StartParticleEffectOnEntity_ReturnEntity( player, GetParticleSystemIndex( TROPHY_PLAYER_SHIELD_CHARGE_FX ), FX_PATTACH_ABSORIGIN_FOLLOW, AttachID )
	fxID.SetOwner( player )
	fxID.kv.VisibilityFlags = (ENTITY_VISIBLE_TO_FRIENDLY | ENTITY_VISIBLE_TO_ENEMY)	// everyone but owner

	array<int> ids = []
	//Status Effects
	ids.append( StatusEffect_AddEndless( player, eStatusEffect.trophy_shield_repair, 1 ) )
	
	{
		entity tacticalWeapon = player.GetOffhandWeapon( OFFHAND_TACTICAL )

		if ( IsValid( tacticalWeapon ) )
		{
			string weaponName = tacticalWeapon.GetWeaponClassName()
			
			if ( weaponName == "mp_weapon_tesla_trap" )	
			{
				ids.append( StatusEffect_AddEndless( player, eStatusEffect.trophy_tactical_charge, 1 ) )
				if( !tacticalWeapon.HasMod( "interception_pylon_super_charge" ) )
					tacticalWeapon.AddMod( "interception_pylon_super_charge" )
			}
		}
	}
	// if (SUPER_BUFF_THREATVISION) {	ids.append( StatusEffect_AddEndless( player, eStatusEffect.threat_vision, 1 ) )}
	// if (SUPER_BUFF_SPEEDBOOST) {	ids.append( StatusEffect_AddEndless( player, eStatusEffect.speed_boost, 0.2 ) ) }

	OnThreadEnd(
		function() : ( ids, fxID, player )
		{
			foreach ( id in ids )
				StatusEffect_Stop( player, id )
			entity tacticalWeapon = player.GetOffhandWeapon( OFFHAND_TACTICAL )

			if( IsValid( tacticalWeapon ) && tacticalWeapon.HasMod( "interception_pylon_super_charge" ) )
				tacticalWeapon.RemoveMod( "interception_pylon_super_charge" )
				
			//Remove 3P Repair Effects
			if (fxID != null)
				fxID.Destroy()
		}
	)

	//Dectect if player has changed armor levels
	while( true )
	{
		int armorTier = EquipmentSlot_GetEquipmentTier( player, "armor" )
		if ( armorTier != oldArmorTier )
		{
			vector shieldColor = GetFXRarityColorForTier( armorTier )
			EffectSetControlPointVector( fxID, 2, shieldColor )
		}
		wait 1
	}
}

//Radius reminder fx
void function RadiusReminderFX( entity pylon )
{
	pylon.EndSignal( "OnDestroy" )

	OnThreadEnd(
		function() : ( pylon )
		{
			if ( IsValid( pylon ) && IsValid( pylon.e.reminderFx ))
			{
				pylon.e.reminderFx.Destroy()
				pylon.e.reminderFx = null
			}
		}
	)
	
	if( !IsValid( pylon.e.reminderFx ) )
		pylon.e.reminderFx = StartParticleEffectOnEntity_ReturnEntity( pylon, GetParticleSystemIndex(TROPHY_RANGE_RADIUS_REMINDER_FX), FX_PATTACH_ABSORIGIN_FOLLOW, 0 )
	else
		return
	
	wait 3
}
#endif //SERVER


#if SERVER
// Copied from sh_loot_creeps.gnut, sets this up to take damage and die
void function TrophyDeathSetup( entity pylon )
{
	// todo: maybe find a better health system for the pylon

	asset deathFx = TROPHY_DESTROY_FX

	AddEntityCallback_OnDamaged( pylon,
		void function ( entity pylon, var damageInfo ) : ( deathFx )
		{
			if ( !IsValid( pylon ) )
				return

			if ( pylon.e.isDisabled ) //already in the process of being killed
				return

			float damage = DamageInfo_GetDamage( damageInfo )
			int damageSourceId = DamageInfo_GetDamageSourceIdentifier( damageInfo )
			if ( !IsValid( damageSourceId ) )
				return

			switch( damageSourceId )
			{
				case eDamageSourceId.mp_weapon_frag_grenade:
				case eDamageSourceId.mp_weapon_grenade_emp:
					if ( damage < 40 )
						return
				break
			}

			entity attacker = DamageInfo_GetAttacker( damageInfo )

			if ( !IsValid( attacker ) )
				return
			//printl("Damaged Pylon For " + damage + " Damage")

			//subtract damage from current pylon health
			pylon.e.pylonhealth = pylon.e.pylonhealth - damage
			
			// makes damage numbers appear
			if ( attacker.IsPlayer() && attacker != pylon.GetBossPlayer() )
			{
				attacker.NotifyDidDamage
				(
					pylon,
					DamageInfo_GetHitBox( damageInfo ),
					DamageInfo_GetDamagePosition( damageInfo ), 
					0,
					DamageInfo_GetDamage( damageInfo ),
					DamageInfo_GetDamageFlags( damageInfo ), 
					DamageInfo_GetHitGroup( damageInfo ),
					DamageInfo_GetWeapon( damageInfo ), 
					DamageInfo_GetDistFromAttackOrigin( damageInfo )
				)
			}

			if (pylon.e.pylonhealth > 0)
			{
				StartParticleEffectOnEntityWithPos( pylon, GetParticleSystemIndex( TROPHY_DAMAGE_SPARK_FX ), FX_PATTACH_CUSTOMORIGIN_FOLLOW, -1, <0, 0, 60>, <0, 0, 0> )
			}
			else if ( pylon.e.pylonhealth <= 0 )
			{
				StartParticleEffectInWorld( GetParticleSystemIndex( TROPHY_DESTROY_FX ), pylon.GetOrigin(), VectorToAngles( pylon.GetForwardVector() ) )
								
				pylon.e.isDisabled = true

				EmitSoundAtPosition( TEAM_ANY, pylon.GetOrigin(), TROPHY_DESTROY_SOUND )

				thread CreateAirShake( pylon.GetOrigin(), 2, 50, 1 )
				int attach_id = pylon.LookupAttachment( "REF" )
				vector effectOrigin = pylon.GetAttachmentOrigin( attach_id )
				vector effectAngles = pylon.GetAttachmentAngles( attach_id )
				
				pylon.Destroy()
			}
		}
	)
}

#endif

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
	if( ent.GetScriptName() != TROPHY_SYSTEM_NAME )
		return
	
	thread Trophy_CreateHUDMarker( ent )

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
	return false
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

void function FullmapPackage_TrophySystem( entity ent, var rui )
{
	RuiSetImage( rui, "defaultIcon", $"rui/hud/gametype_icons/survival/wattson_ult_map_icon" )
	RuiSetImage( rui, "clampedDefaultIcon", $"" )
}

void function ArmorChanged( entity player, string equipSlot, int new )
{
	player.Signal( "UpdateShieldRepair" )
}
#endif //
