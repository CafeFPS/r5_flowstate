global function MpWeaponPhaseTunnel_Init
global function OnWeaponActivate_weapon_phase_tunnel
global function OnWeaponDeactivate_weapon_phase_tunnel
global function OnWeaponAttemptOffhandSwitch_weapon_phase_tunnel

global function OnWeaponChargeBegin_weapon_phase_tunnel
global function OnWeaponChargeEnd_weapon_phase_tunnel

global function OnWeaponPrimaryAttack_ability_phase_tunnel
#if SERVER
global function OnWeaponNPCPrimaryAttack_ability_phase_tunnel
#endif

const float CROUCH_HEIGHT = 48

const string SOUND_ACTIVATE_1P         = "Wraith_PhaseGate_FirstGate_DeviceActivate_1p" // Play (to 1p only) as soon as the "arm raise" animation for placing the first gate starts (basically as soon as the ability key is pressed and the ability successfully starts).
const string SOUND_ACTIVATE_3P         = "Wraith_PhaseGate_FirstGate_DeviceActivate_3p" // Play (to everyone except 1p) as soon as the 3p Wraith begins activating the ability to place the first gate.
const string SOUND_SUCCESS_1P          = "Wraith_PhaseGate_FirstGate_Place_1p" // Play (to 1p only) when the first gate (the "pre-portal" thing) gets placed.  Can be played on the gate or the player.
const string SOUND_SUCCESS_3P          = "Wraith_PhaseGate_FirstGate_Place_3p" // Play (to everyone except 1p) when the first gate (the "pre-portal" thing) gets placed.  Should play on the gate.
const string SOUND_PREPORTAL_LOOP      = "Wraith_PhaseGate_PrePortal_Loop" // Play (to everyone) when first gate is created.  Should play on the gate (pre-portal thing).  Should be stopped when the second gate is placed and the gates connect.
const string SOUND_PORTAL_OPEN         = "Wraith_PhaseGate_Portal_Open" // Play (to everyone) when second gate is created and gates connect.  Should play on each gate.  (Stop Wraith_PhaseGate_PrePortal_Loop when this plays.)
const string SOUND_PORTAL_LOOP         = "Wraith_PhaseGate_Portal_Loop" // Play (to everyone) when second gate is created and gates connect.  Should play on each gate.  Stop when gates expire.
const string SOUND_PORTAL_CLOSE        = "Wraith_PhaseGate_Portal_Expire" // Play (to everyone) when gates expire.  Should play on each gate.

global const string PHASETUNNEL_BLOCKER_SCRIPTNAME      = "phase_tunnel_blocker"
global const string PHASETUNNEL_PRE_BLOCKER_SCRIPTNAME  = "pre_phase_tunnel_blocker"

const float FRAME_TIME = 0.1

const asset PHASE_TUNNEL_3P_FX              = $"P_ps_gauntlet_arm_3P"
const asset PHASE_TUNNEL_PREPLACE_FX        = $"P_phasegate_pre_portal"
const asset PHASE_TUNNEL_FX                 = $"P_phasegate_portal"
const asset PHASE_TUNNEL_CROUCH_FX          = $"P_phasegate_portal_rnd"
const asset PHASE_TUNNEL_ABILITY_ACTIVE_FX  = $"P_phase_dash_start"
const asset PHASE_TUNNEL_1P_FX              = $"P_phase_tunnel_player"

const float PHASE_TUNNEL_WEAPON_DRAW_DELAY                 = 0.75

const float PHASE_TUNNEL_TRIGGER_RADIUS                    = 16.0
const float PHASE_TUNNEL_TRIGGER_HEIGHT                    = 32.0
const float PHASE_TUNNEL_TRIGGER_HEIGHT_CROUCH             = 16.0
const float PHASE_TUNNEL_TRIGGER_RADIUS_PROJECTILE         = 42.0
const float PHASE_TUNNEL_TRIGGER_RADIUS_PROJECTILE_CROUCH  = 24.0

//PHASE TUNNEL PLACEMENT VARS
const float PHASE_TUNNEL_PLACEMENT_HEIGHT_STANDING         = 45.0
const float PHASE_TUNNEL_PLACEMENT_HEIGHT_CROUCHING        = 20

//PHASE TUNNEL TELEPORT TIME VARS
const float PHASE_TUNNEL_LIFETIME                          = 60.0
const float PHASE_TUNNEL_TELEPORT_TRAVEL_TIME_MIN          = 0.3
const float PHASE_TUNNEL_TELEPORT_TRAVEL_TIME_MAX          = 2.0
const float PHASE_TUNNEL_TELEPORT_DBOUNCE                  = 0.5
const float PHASE_TUNNEL_TELEPORT_DBOUNCE_PROJECTILE       = 1.0
const float PHASE_TUNNEL_PATH_FOLLOW_TICK                  = 0.1
const float PHASE_TUNNEL_PATH_SNAPSHOT_INTERVAL            = 0.1

const float PHASE_TUNNEL_PLACEMENT_RADIUS                  = 4098.0
const float PHASE_TUNNEL_PLACEMENT_DIST                    = 4098.0
const float PHASE_TUNNEL_MIN_PORTAL_DIST_SQR               = 128.0 * 128.0
const float PHASE_TUNNEL_MIN_GEO_REVERSE_DIST              = 48.0

const bool	PHASE_TUNNEL_DEBUG_DRAW_PROJECTILE_TELEPORT  = false
const bool 	PHASE_TUNNEL_DEBUG_DRAW_PLAYER_TELEPORT      = false

struct PhaseTunnelPathNodeData
{
	vector origin
	vector angles
	vector velocity
	bool wasInContextAction
	bool wasCrouched
	bool validExit
	float time
}

struct PhaseTunnelPathData
{
	float                            pathDistance 	= 0
	float                            pathTime		= 0
	array< PhaseTunnelPathNodeData > pathNodes
}

struct PhaseTunnelPortalData
{
	vector                           startOrigin
	vector                           startAngles
	entity                           portalFX
	vector                           endOrigin
	vector                           endAngles
	bool							 crouchPortal
	PhaseTunnelPathData&			pathData
}

struct PhaseTunnelData
{
	entity                 tunnelEnt
	int                    activeUsers = 0
	table< entity, float > entPhaseTime
	PhaseTunnelPortalData& startPortal
	PhaseTunnelPortalData& endPortal
	bool                   expired
}

struct
{
	#if SERVER
		table < entity, PhaseTunnelData > tunnelData
		table< entity, float > phaseTime
		table< entity, PhaseTunnelPortalData > triggerStartpoint
		table< entity, PhaseTunnelPortalData > triggerEndpoint
		table< entity, PhaseTunnelPortalData > vortexStartpoint
		table< entity, PhaseTunnelPortalData > vortexEndpoint
	#endif //SERVER
} file

void function MpWeaponPhaseTunnel_Init()
{
	PrecacheParticleSystem( PHASE_TUNNEL_PREPLACE_FX )
	PrecacheParticleSystem( PHASE_TUNNEL_FX )
	PrecacheParticleSystem( PHASE_TUNNEL_CROUCH_FX )
	PrecacheParticleSystem( PHASE_TUNNEL_ABILITY_ACTIVE_FX )
	PrecacheParticleSystem( PHASE_TUNNEL_1P_FX )
	PrecacheParticleSystem( PHASE_TUNNEL_3P_FX )

	AddCallback_PlayerCanUseZipline( PhaseTunnel_CanUseZipline )

	#if SERVER
		RegisterSignal( "PhaseTunnel_CancelPlacement" )
		RegisterSignal( "PhaseTunnel_EndPlacement" )
		RegisterSignal( "PhaseTunnel_PathFollowCrouchPlayer" )
		Bleedout_AddCallback_OnPlayerStartBleedout( PhaseTunnel_OnPlayerStartBleedout )
	#endif //SERVER

	#if CLIENT
		RegisterSignal( "EndTunnelVisual" )

		AddCreateCallback( "prop_script", PhaseTunnel_OnPropScriptCreated )
		StatusEffect_RegisterEnabledCallback( eStatusEffect.placing_phase_tunnel, PhaseTunnel_OnBeginPlacement)
		StatusEffect_RegisterDisabledCallback( eStatusEffect.placing_phase_tunnel, PhaseTunnel_OnEndPlacement )

		StatusEffect_RegisterEnabledCallback( eStatusEffect.phase_tunnel_visual, TunnelVisualsEnabled )
		StatusEffect_RegisterDisabledCallback( eStatusEffect.phase_tunnel_visual, TunnelVisualsDisabled )

		AddCreateCallback( PLAYER_WAYPOINT_CLASSNAME, PlayerWaypoint_CreateCallback )
	#endif
}


void function OnWeaponActivate_weapon_phase_tunnel( entity weapon )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	
	if( !IsValid( ownerPlayer ) || !ownerPlayer.IsPlayer() )
		return
	
	float raise_time = weapon.GetWeaponSettingFloat( eWeaponVar.raise_time )

	#if SERVER
	ItemFlavor character = LoadoutSlot_GetItemFlavor( ToEHI( ownerPlayer ), Loadout_CharacterClass() )
	string charRef = ItemFlavor_GetHumanReadableRef( character )

	if( charRef == "character_wraith")
		PlayBattleChatterLineToSpeakerAndTeam( ownerPlayer, "bc_super" )
	EmitSoundOnEntityExceptToPlayer( ownerPlayer, ownerPlayer, SOUND_ACTIVATE_3P )
	#endif

	#if CLIENT
		if ( !InPrediction() ) //Stopgap fix for Bug 146443
			return

		EmitSoundOnEntity( ownerPlayer, SOUND_ACTIVATE_1P )
		//AddPlayerHint( 30.0, 0, $"", "#WPN_PHASE_TUNNEL_PLAYER_DEPLOY_START_HINT" )
	#endif

	StatusEffect_AddTimed( ownerPlayer, eStatusEffect.move_slow, 0.8, raise_time, raise_time )
}

void function OnWeaponDeactivate_weapon_phase_tunnel( entity weapon )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	Assert( ownerPlayer.IsPlayer() )
	#if CLIENT
		if ( !InPrediction() ) //Stopgap fix for Bug 146443
			return

		//HidePlayerHint( "#WPN_PHASE_TUNNEL_PLAYER_DEPLOY_START_HINT" )
	#endif
}

bool function OnWeaponAttemptOffhandSwitch_weapon_phase_tunnel( entity weapon )
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

bool function OnWeaponChargeBegin_weapon_phase_tunnel( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	float shiftTime = PHASE_TUNNEL_PLACEMENT_DURATION

	//printt( "STARTING CHARGE!!!" )

	if ( IsAlive( player ) )
	{
		if ( player.IsPlayer() )
		{
			PlayerUsedOffhand( player, weapon, false )
			int attachIndex = player.LookupAttachment( "R_FOREARM" )

			Assert( attachIndex > 0 )
			if ( attachIndex == 0 )
			{
				return false
			}

			#if SERVER
				LockWeaponsAndMelee( player )
				entity f = StartParticleEffectOnEntity_ReturnEntity( player, GetParticleSystemIndex( PHASE_TUNNEL_3P_FX ), FX_PATTACH_POINT_FOLLOW, player.LookupAttachment( "R_FOREARM" ) )
				f.SetOwner( player )
				SetTeam( f, player.GetTeam() )
				f.kv.VisibilityFlags = ENTITY_VISIBLE_TO_ENEMY | ENTITY_VISIBLE_TO_FRIENDLY
				weapon.w.fxHandles.append( f )

				float fade = 0.125
				thread PhaseTunnel_StartAbility( player, shiftTime + fade, weapon )
				EmitSoundOnEntityExceptToPlayer( player, player, "Wraith_PhaseGate_GauntletArcs_3p" )
			#elseif CLIENT
				AddPlayerHint( PHASE_TUNNEL_PLACEMENT_DURATION, 0, $"", "#WPN_PHASE_TUNNEL_PLAYER_DEPLOY_STOP_HINT" )
				HidePlayerHint( "#WPN_PHASE_TUNNEL_PLAYER_DEPLOY_START_HINT" )
				EmitSoundOnEntity( player, "Wraith_PhaseGate_GauntletArcs_1p" )
			#endif
		}
		//PhaseShift( player, 0, shiftTime, eShiftStyle.Balance, true )
	}
	return true
}

void function OnWeaponChargeEnd_weapon_phase_tunnel( entity weapon )
{
	entity player = weapon.GetWeaponOwner()

	//printt( "ENDING CHARGE!!!" )

	#if CLIENT
		HidePlayerHint( "#WPN_PHASE_TUNNEL_PLAYER_DEPLOY_STOP_HINT" )
		StopSoundOnEntity( player, "Wraith_PhaseGate_GauntletArcs_1p" )
	#endif //CLIENT

#if SERVER
	if ( IsAlive( player ) )
	{
		if ( player.IsPlayer() )
		{
			UnlockWeaponsAndMelee( player )
		}

		StopSoundOnEntity( player, "Wraith_PhaseGate_GauntletArcs_3p" )

		foreach ( fx in weapon.w.fxHandles )
		{
			EffectStop( fx )
		}
		weapon.w.fxHandles.clear()
	}
#endif
}

bool function PhaseTunnel_CanUseZipline( entity player,  entity zipline, vector ziplineClosestPoint )
{
	if ( StatusEffect_GetSeverity( player, eStatusEffect.placing_phase_tunnel ) )
		return false

	return true
}

#if SERVER
void function PhaseTunnel_ForceEnd( entity player )
{
	entity tunnelWeapon = player.GetOffhandWeapon( OFFHAND_INVENTORY )
	Assert ( tunnelWeapon.GetWeaponClassName() == "mp_weapon_phase_tunnel", "Trying to end sustained discharge on a diffrent weapon than we started with." )

	if ( tunnelWeapon.GetWeaponChargeFraction() > 0.1 )
	{
		player.Signal( "PhaseTunnel_EndPlacement" )
		tunnelWeapon.SetWeaponChargeFraction( 1 )
		tunnelWeapon.SetWeaponPrimaryClipCount( 0 )
		tunnelWeapon.ForceChargeEndNoAttack()
	}
}
#endif

var function OnWeaponPrimaryAttack_ability_phase_tunnel( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	//PlayWeaponSound( "fire" )
	entity player = weapon.GetWeaponOwner()

	float shiftTime = PHASE_TUNNEL_PLACEMENT_DURATION

	if ( IsAlive( player ) )
	{
		#if SERVER
			player.Signal( "PhaseTunnel_EndPlacement" )
		#endif //SERVER
	}

	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
}

#if SERVER
void function ForceTacticalEnd( entity player )
{
	entity tactical = player.GetOffhandWeapon( OFFHAND_LEFT )
	if ( IsValid( tactical ) )
	{
		if ( tactical.IsChargeWeapon() && tactical.IsWeaponCharging() )
			{
				tactical.ForceChargeEndNoAttack()
				tactical.SetWeaponPrimaryClipCount(  0 )
			}
	}

}

var function OnWeaponNPCPrimaryAttack_ability_phase_tunnel( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return OnWeaponPrimaryAttack_ability_phase_tunnel( weapon, attackParams )
}

void function PhaseTunnel_OnPlayerStartBleedout( entity player, entity attacker, var damageInfo )
{
	player.Signal( "PhaseTunnel_EndPlacement" )
}

void function PhaseTunnel_StartAbility( entity player, float duration, entity weapon )
{
	Assert( IsNewThread(), "Must be threaded off." )
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )
	weapon.EndSignal( "OnDestroy" )

	Embark_Disallow( player )

	array mods = player.GetExtraWeaponMods()
	mods.append( "ult_active" )
	player.SetExtraWeaponMods( mods )
	//player.ForceAutoSprintOn()

	array<int> ids
	ids.append( StatusEffect_AddEndless( player, eStatusEffect.speed_boost, 0.20 ) )
	ids.append( StatusEffect_AddEndless( player, eStatusEffect.phase_tunnel_visual, 1.0 ) )

	entity fx = PlayPhaseShiftDisappearFX( player, PHASE_TUNNEL_ABILITY_ACTIVE_FX )

	//AddButtonPressedPlayerInputCallback( player, IN_ZOOM_TOGGLE, PhaseTunnel_CancelPlacement )
	//AddButtonPressedPlayerInputCallback( player, IN_ZOOM, PhaseTunnel_CancelPlacement )

	EmitSoundOnEntityOnlyToPlayer( player, player, SOUND_SUCCESS_1P )
	EmitSoundOnEntityExceptToPlayer( player, player, SOUND_SUCCESS_3P )


	OnThreadEnd(
		function() : ( player, ids, fx )
		{
			if ( IsValid( player ) )
			{
				Embark_Allow( player )

				ForceTacticalEnd( player )
				if ( player.IsPhaseShifted() )
					CancelPhaseShift( player )
				array mods = player.GetExtraWeaponMods()
				mods.fastremovebyvalue( "ult_active" )
				player.SetExtraWeaponMods( mods )

				//player.ForceAutoSprintOff()
				//RemoveButtonPressedPlayerInputCallback( player, IN_ZOOM_TOGGLE, PhaseTunnel_CancelPlacement )
				//RemoveButtonPressedPlayerInputCallback( player, IN_ZOOM, PhaseTunnel_CancelPlacement )

				foreach ( id in ids )
					StatusEffect_Stop( player, id )

				if ( IsValid( fx ) )
				{
					//StopFX( fx )
					fx.Destroy()
				}
			}
		} )

	PhaseTunnelPathData startPath
	PhaseTunnelPathData endPath

	entity wpStart = CreateWaypoint_Ping_Location( player, ePingType.ABILITY_WORMHOLE, null, player.GetOrigin(), -1, true )
	wpStart.SetAbsOrigin( player.GetOrigin() + <0, 0, 48> )

	OnThreadEnd(
		function () : ( wpStart )
		{
			if ( IsValid( wpStart ) )
			{
				wpStart.Destroy()
			}
		}
	)

	thread PhaseTunnel_StartTrackingPositions( player, startPath, endPath )
	waitthread PhaseTunnel_InteruptablePlacementWaitDistance( player, PHASE_TUNNEL_PLACEMENT_DIST )

	//printt( "STARTING PATH LEN: " + startPath.len() )
	//printt( "ENDING PATH LEN: " + endPath.len() )
	//If the player didn't create a real path.

	//If the player doesn't place a valid path, refund the cost of the ability.
	if ( !startPath.pathNodes.len() || !endPath.pathNodes.len() )
	{
		weapon.SetWeaponPrimaryClipCount( weapon.GetWeaponPrimaryClipCountMax() )
		return
	}

	//If the player doesn't place a valid path, refund the cost of the ability.
	if ( startPath.pathDistance <= 128.0 || endPath.pathDistance <= 128.0 )
	{
		weapon.SetWeaponPrimaryClipCount( weapon.GetWeaponPrimaryClipCountMax() )
		return
	}

	PhaseTunnelPortalData startPortal 	= PhaseTunnel_CreatePortalData( startPath )
	startPortal.portalFX.RemoveFromAllRealms()
	startPortal.portalFX.AddToOtherEntitysRealms( player )
	PhaseTunnelPortalData endPortal 	= PhaseTunnel_CreatePortalData( endPath )
	endPortal.portalFX.RemoveFromAllRealms()
	endPortal.portalFX.AddToOtherEntitysRealms( player )

	PIN_PlayerAbility( player, weapon.GetWeaponClassName(), ABILITY_TYPE.ULTIMATE, null, {tunnel_start = startPortal.startOrigin, tunnel_end = endPortal.startOrigin} )

	PhaseTunnelData tunnelData
	tunnelData.startPortal 	= startPortal
	tunnelData.endPortal 	= endPortal
	thread PhaseTunnel_OpenTunnel( tunnelData, player )
}

PhaseTunnelPortalData function PhaseTunnel_CreatePortalData( PhaseTunnelPathData pathData )
{
	int pathLength = pathData.pathNodes.len()
	PhaseTunnelPathNodeData startingPoint = pathData.pathNodes[ pathLength - 1 ]
	PhaseTunnelPathNodeData endingPoint = pathData.pathNodes[ 0 ]

	float zOffset = startingPoint.wasCrouched ? PHASE_TUNNEL_PLACEMENT_HEIGHT_CROUCHING : PHASE_TUNNEL_PLACEMENT_HEIGHT_STANDING
	asset portalFX = startingPoint.wasCrouched ? PHASE_TUNNEL_CROUCH_FX : PHASE_TUNNEL_FX

	int fxid = GetParticleSystemIndex( portalFX )
	PhaseTunnelPortalData portalData
	portalData.startOrigin = startingPoint.origin
	portalData.startAngles = startingPoint.angles
	portalData.endOrigin = endingPoint.origin
	portalData.endAngles = endingPoint.angles
	portalData.crouchPortal = startingPoint.wasCrouched
	portalData.portalFX	= StartParticleEffectInWorld_ReturnEntity( fxid, startingPoint.origin + ( <0,0,1> * zOffset ), startingPoint.angles + <0,90,90> )

	//TO DO: READ START AND END POSITION OUT OF THE PATH DATA.
	portalData.pathData = pathData

	return portalData
}

void function PhaseTunnel_InteruptablePlacementWaitTimed( entity player, float duration )
{
	Assert( IsNewThread(), "Must be threaded off." )
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDeath" )
	player.EndSignal( "PhaseTunnel_EndPlacement" )

	StatusEffect_AddTimed( player, eStatusEffect.placing_phase_tunnel, 1.0, PHASE_TUNNEL_PLACEMENT_DURATION, PHASE_TUNNEL_PLACEMENT_DURATION )
	wait duration
	player.Signal( "PhaseTunnel_EndPlacement" )
}

void function PhaseTunnel_InteruptablePlacementWaitRadius( entity player, vector origin, float distance )
{
	Assert( IsNewThread(), "Must be threaded off." )
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDeath" )
	player.EndSignal( "PhaseTunnel_EndPlacement" )

	entity tunnelWeapon = player.GetOffhandWeapon( OFFHAND_INVENTORY )
	Assert ( tunnelWeapon.GetWeaponClassName() == "mp_weapon_phase_tunnel", "Trying to end sustained discharge on a diffrent weapon than we started with." )
	tunnelWeapon.EndSignal( "OnDestroy" )

	table<int, int> statusEffectHandles
	statusEffectHandles[ eStatusEffect.placing_phase_tunnel ] <- -1

	OnThreadEnd(
		function() : ( player, statusEffectHandles )
		{
			if ( IsValid( player ) )
			{
				if ( statusEffectHandles[ eStatusEffect.placing_phase_tunnel ] != -1 )
					StatusEffect_Stop( player, statusEffectHandles[ eStatusEffect.placing_phase_tunnel ] )
			}
		} )

	while ( true )
	{
		float dist2DSqr = Distance2DSqr( player.GetOrigin(), origin )

		float frac = min( dist2DSqr / ( distance * distance ), 1.0 )

		if ( statusEffectHandles[ eStatusEffect.placing_phase_tunnel ] != -1 )
		{
			StatusEffect_Stop( player, statusEffectHandles[ eStatusEffect.placing_phase_tunnel ] )
			statusEffectHandles[ eStatusEffect.placing_phase_tunnel ] = -1
		}

		statusEffectHandles[ eStatusEffect.placing_phase_tunnel ] = StatusEffect_AddEndless( player, eStatusEffect.placing_phase_tunnel, 1.0 - frac )

		//printt( "DISTANCE 2D SQR: " + dist2DSqr )
		if ( dist2DSqr > distance * distance  )
			break

		WaitFrame()
	}

	player.Signal( "PhaseTunnel_EndPlacement" )
}

void function PhaseTunnel_InteruptablePlacementWaitDistance( entity player, float distance )
{
	Assert( IsNewThread(), "Must be threaded off." )
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDeath" )
	player.EndSignal( "PhaseTunnel_EndPlacement" )

	entity tunnelWeapon = player.GetOffhandWeapon( OFFHAND_INVENTORY )
	Assert ( tunnelWeapon.GetWeaponClassName() == "mp_weapon_phase_tunnel", "Trying to end sustained discharge on a diffrent weapon than we started with." )
	tunnelWeapon.EndSignal( "OnDestroy" )

	table<int, int> statusEffectHandles
	statusEffectHandles[ eStatusEffect.placing_phase_tunnel ] <- -1

	AddButtonPressedPlayerInputCallback( player, IN_ATTACK, PhaseTunnel_ForceEnd )

	OnThreadEnd(
		function() : ( player, tunnelWeapon, statusEffectHandles )
		{
			if ( IsValid( player ) )
			{
				RemoveButtonPressedPlayerInputCallback( player, IN_ATTACK, PhaseTunnel_ForceEnd )

				if ( statusEffectHandles[ eStatusEffect.placing_phase_tunnel ] != -1 )
					StatusEffect_Stop( player, statusEffectHandles[ eStatusEffect.placing_phase_tunnel ] )

				if ( IsValid( tunnelWeapon ) )
					tunnelWeapon.SetWeaponChargeFraction( 0.0 )
			}
		} )

	float totalDist   = 0
	vector lastOrigin = FlattenVector( player.GetOrigin() )
	while ( true )
	{
		vector origin = FlattenVector( player.GetOrigin() )
		totalDist += ( Length( lastOrigin - origin ) )
		//printt( "TOTAL DIST: " + totalDist )

		float frac = min( totalDist / distance, 1.0 )

		if ( statusEffectHandles[ eStatusEffect.placing_phase_tunnel ] != -1 )
		{
			StatusEffect_Stop( player, statusEffectHandles[ eStatusEffect.placing_phase_tunnel ] )
			statusEffectHandles[ eStatusEffect.placing_phase_tunnel ] = -1
		}

		statusEffectHandles[ eStatusEffect.placing_phase_tunnel ] = StatusEffect_AddEndless( player, eStatusEffect.placing_phase_tunnel, 1.0 - frac )

		if ( totalDist >= distance )
			break

		lastOrigin = origin

		WaitFrame()
	}

	player.Signal( "PhaseTunnel_EndPlacement" )
}

void function PhaseTunnel_OpenTunnel( PhaseTunnelData tunnelData, entity player )
{
	Assert ( IsNewThread(), "Must be threaded off." )
	int team = player.GetTeam()
	entity tunnelEnt = CreatePropScript( $"mdl/dev/empty_model.rmdl", tunnelData.startPortal.startOrigin )
	tunnelEnt.RemoveFromAllRealms()
	tunnelEnt.AddToOtherEntitysRealms( player )
	tunnelEnt.DisableHibernation()
	SetTeam( tunnelEnt, team )
	tunnelEnt.SetOwner( player )

	entity wpStart = CreateWaypoint_Ping_Location( player, ePingType.ABILITY_WORMHOLE, tunnelData.startPortal.portalFX, tunnelData.startPortal.startOrigin, -1, true )
	wpStart.SetAbsOrigin( tunnelData.startPortal.startOrigin + <0, 0, 45> )

	entity wpEnd = CreateWaypoint_Ping_Location( player, ePingType.ABILITY_WORMHOLE, tunnelData.endPortal.portalFX, tunnelData.endPortal.startOrigin, -1, true )
	wpEnd.SetAbsOrigin( tunnelData.endPortal.startOrigin + <0, 0, 45> )

	tunnelData.tunnelEnt = tunnelEnt

	file.tunnelData[ tunnelEnt ] <- tunnelData
	file.phaseTime[ tunnelEnt ] <- Time() + PHASE_TUNNEL_TELEPORT_DBOUNCE

	OnThreadEnd(
		function() : ( tunnelEnt, tunnelData, wpStart, wpEnd )
		{
			tunnelData.startPortal.portalFX.Destroy()
			tunnelData.endPortal.portalFX.Destroy()

			if ( IsValid( tunnelEnt ) )
			{
				delete file.tunnelData[ tunnelEnt ]
				delete file.phaseTime[ tunnelEnt ]
				tunnelEnt.Destroy()
			}

			if ( IsValid( wpStart ) )
			{
				wpStart.Destroy()
			}
			if ( IsValid( wpEnd ) )
			{
				wpEnd.Destroy()
			}
		} )

	TrackingVision_CreatePOI( eTrackingVisionNetworkedPOITypes.PLAYER_ABILITY_PHASE_GATE, player, tunnelData.startPortal.startOrigin, player.GetTeam(), player )
	TrackingVision_CreatePOI( eTrackingVisionNetworkedPOITypes.PLAYER_ABILITY_PHASE_GATE, player, tunnelData.endPortal.startOrigin, player.GetTeam(), player )

	//Create teleport triggers at the tunnel entrance.
	thread PhaseTunnel_CreateTriggerArea( tunnelEnt, tunnelData.startPortal, tunnelData.endPortal )
	thread PhaseTunnel_CreateTriggerArea( tunnelEnt, tunnelData.endPortal, tunnelData.startPortal )

	PlayBattleChatterLineToSpeakerAndTeam( player, "bc_wraith_superSet" )

	waitthread WaitForPhaseTunnelExpiration( player )

	//Don't close the tunnel while there are users in transit.
	while ( tunnelData.activeUsers )
		WaitFrame()
}

void function WaitForPhaseTunnelExpiration( entity player )
{
	if ( IsValid( player ) )
	{
		player.EndSignal( "CleanupPlayerPermanents" )
	}

	wait PHASE_TUNNEL_LIFETIME
}

void function PhaseTunnel_CreateTriggerArea( entity tunnelEnt, PhaseTunnelPortalData startPointData, PhaseTunnelPortalData endPointData )
{
	Assert ( IsNewThread(), "Must be threaded off" )
	tunnelEnt.EndSignal( "OnDestroy" )
	endPointData.portalFX.EndSignal( "OnDestroy" )

	vector origin = endPointData.portalFX.GetOrigin()
	vector angles = endPointData.portalFX.GetAngles()
	float triggerHeight = endPointData.crouchPortal ? PHASE_TUNNEL_TRIGGER_HEIGHT_CROUCH : PHASE_TUNNEL_TRIGGER_HEIGHT
	float vortexRadius 	= endPointData.crouchPortal ? PHASE_TUNNEL_TRIGGER_RADIUS_PROJECTILE_CROUCH : PHASE_TUNNEL_TRIGGER_RADIUS_PROJECTILE

	entity trigger = CreateEntity( "trigger_cylinder" )
	trigger.RemoveFromAllRealms()
	trigger.AddToOtherEntitysRealms( tunnelEnt )
	trigger.SetOwner( tunnelEnt )
	trigger.SetRadius( PHASE_TUNNEL_TRIGGER_RADIUS )
	trigger.SetAboveHeight( triggerHeight )
	trigger.SetBelowHeight( triggerHeight )
	trigger.SetOrigin( origin )
	trigger.SetAngles( <0,0,0> )
	trigger.kv.triggerFilterNonCharacter = "0"
	DispatchSpawn( trigger )

	file.triggerStartpoint[ trigger ] 	<- startPointData
	file.triggerEndpoint[ trigger ] 	<- endPointData
	trigger.SetEnterCallback( OnPhaseTunnelTriggerEnter )

	trigger.SetOrigin( origin )
	trigger.SetAngles( <0,0,0> )

	//------------------------------
	// Vortex to detect bullets, projectiles, and mortars entering our defensive perimiter.
	//------------------------------
	//entity vortexSphere = CreateEntity( "vortex_sphere" )
	//
	//vortexSphere.kv.spawnflags = SF_BLOCK_OWNER_WEAPON
	//vortexSphere.kv.enabled = 0
	//vortexSphere.kv.radius = vortexRadius
	//vortexSphere.kv.height = vortexRadius
	//vortexSphere.kv.bullet_fov = 360
	//vortexSphere.kv.physics_pull_strength = 0//25
	//vortexSphere.kv.physics_side_dampening = 0//6
	//vortexSphere.kv.physics_fov = 360
	//vortexSphere.kv.physics_max_mass = 0//2
	//vortexSphere.kv.physics_max_size = 0//6
	//
	//vortexSphere.SetAngles( <0,0,0> ) // viewvec?
	//vortexSphere.SetOrigin( origin )
	//vortexSphere.SetMaxHealth( 100 )
	//vortexSphere.SetHealth( 100 )
	//
	//DispatchSpawn( vortexSphere )
	//
	////HACK: Until we get a better way to do this use the vortex's target name to specify that it is a vortex trigger that
	////will run a set callback when a projectile or bullet hits it instead of preforming its normal vortex logic.
	//Vortex_ConvertToVortexTriggerArea( vortexSphere )
	//SetCallback_VortexSphereTriggerOnBulletHit( vortexSphere, PhaseTunnel_OnBulletHitVortexTrigger )
	//SetCallback_VortexSphereTriggerOnProjectileHit( vortexSphere, PhaseTunnel_OnProjectileHitVortexTrigger )
	//
	//vortexSphere.Fire( "Enable" )
	//vortexSphere.SetInvulnerable() // make particle wall invulnerable to weapon damage. It will still drain over time
	//vortexSphere.SetOwner( tunnelEnt )
	//
	//file.vortexStartpoint[ vortexSphere ] 	<- startPointData
	//file.vortexEndpoint[ vortexSphere ] 	<- endPointData

	entity portalMarker = CreatePropScript( $"mdl/dev/empty_model.rmdl", origin, angles + <0,-90,-90>  )
	portalMarker.SetScriptName( "portal_marker" )
	portalMarker.DisableHibernation()

	entity traceBlocker = CreateTraceBlockerVolume( origin, 24.0, false, CONTENTS_NOGRAPPLE, tunnelEnt.GetTeam(), PHASETUNNEL_BLOCKER_SCRIPTNAME )
	//traceBlocker.RemoveFromAllRealms()
	//traceBlocker.AddToOtherEntitysRealms( tunnelEnt )

	EmitSoundOnEntity( portalMarker, SOUND_PORTAL_OPEN )
	EmitSoundOnEntity( portalMarker, SOUND_PORTAL_LOOP )

	OnThreadEnd(
		function() : ( trigger, portalMarker, traceBlocker )
		{
			if ( IsValid( trigger ) )
			{
				delete file.triggerStartpoint[ trigger ]
				delete file.triggerEndpoint[ trigger ]
				trigger.Destroy()
			}

			//if ( IsValid( vortexSphere ) )
			//{
			//	delete file.vortexStartpoint[ vortexSphere ]
			//	delete file.vortexEndpoint[ vortexSphere ]
			//	vortexSphere.Destroy()
			//}

			if ( IsValid( portalMarker ) )
			{
				StopSoundOnEntity( portalMarker, SOUND_PORTAL_LOOP )
				EmitSoundAtPosition( TEAM_UNASSIGNED, portalMarker.GetOrigin(), SOUND_PORTAL_CLOSE )
				portalMarker.Destroy()
			}

			if ( IsValid( traceBlocker ) )
				traceBlocker.Destroy()
		} )

	vector surfaceNormal = AnglesToUp( trigger.GetAngles() )

	if ( PHASE_TUNNEL_DEBUG_DRAW_PROJECTILE_TELEPORT )
	{
		DebugDrawLine( startPointData.portalFX.GetOrigin(), startPointData.portalFX.GetOrigin() + ( startPointData.portalFX.GetUpVector() * 64 ), 255, 0, 0, true, 30.0 ) //Grenade Entry Vel
	}

	WaitForever()
}

void function OnPhaseTunnelTriggerEnter( entity trigger, entity ent )
{
	entity tunnelEnt = trigger.GetOwner()
	//APPLY FORCE TO TARGET
	if ( PhaseTunnel_ShouldPhaseEnt( ent ) )
		thread PhaseTunnel_PhaseEntity( ent, tunnelEnt, trigger )
}

void function PhaseTunnel_OnBulletHitVortexTrigger( entity weapon, entity vortexSphere, var damageInfo )
{
	//printt( "BULLET HIT VORTEX TRIGGER" )
	return
}

void function PhaseTunnel_OnProjectileHitVortexTrigger( entity weapon, entity vortexSphere, entity attacker, entity projectile, vector contactPos )
{
	//printt( "PROJECTILE HIT VORTEX TRIGGER" )
	entity tunnelEnt                      	= vortexSphere.GetOwner()
	PhaseTunnelPortalData startPortalData 	= file.vortexStartpoint[ vortexSphere ]
	PhaseTunnelPortalData endPortalData		= file.vortexEndpoint[ vortexSphere ]

	if ( !IsValid( tunnelEnt ) )
		return

	//Only teleport the projectiles we specify.
	if ( !PhaseTunnel_ShouldPhaseProjectile( projectile ) )
		return

	//Don't phase planted projectiles
	if ( projectile.proj.isPlanted )
		return

	vector velNorm           = Normalize( projectile.GetVelocity() )
	vector endPortalAngles   = VectorToAngles( endPortalData.portalFX.GetUpVector() )

	vector relativeAngles = CalcRelativeAngles( endPortalAngles, -startPortalData.portalFX.GetUpVector() )
	vector newDir       = RotateVector( velNorm, relativeAngles )

	//printt( "RELATIVE ANGLES: " + relativeAngles )

	//if we are going from a crouching portal to a standing portal or vice versa scale the projectile's z height offset accordingly
	float heightScalar = 1.0
	if ( endPortalData.crouchPortal && !startPortalData.crouchPortal )
		heightScalar = PHASE_TUNNEL_TRIGGER_RADIUS_PROJECTILE / PHASE_TUNNEL_TRIGGER_RADIUS_PROJECTILE_CROUCH
	else if ( !endPortalData.crouchPortal && startPortalData.crouchPortal )
		heightScalar = PHASE_TUNNEL_TRIGGER_RADIUS_PROJECTILE_CROUCH / PHASE_TUNNEL_TRIGGER_RADIUS_PROJECTILE

	vector endFXOrigin = startPortalData.portalFX.GetOrigin()
	vector impactPoint = PhaseTunnel_GetPointOnRectangularPlane( endPortalData.portalFX.GetOrigin(), endPortalData.portalFX.GetUpVector(), endPortalData.portalFX.GetRightVector(), 198, 128, contactPos )
	vector relOffset = ( impactPoint - endPortalData.portalFX.GetOrigin() )
	relOffset.z *= heightScalar
	vector exitPoint = RotateVector( relOffset, relativeAngles )

	//printt( "RELATIVE POINT: " + exitPoint )

	projectile.proj.lastTeleportTime = Time()
	projectile.SetOrigin( endFXOrigin + exitPoint )
	projectile.SetVelocity( newDir * Length( projectile.GetVelocity() ) )

	//printt( "TELEPORTING PROJECTILE" )

	if ( PHASE_TUNNEL_DEBUG_DRAW_PROJECTILE_TELEPORT )
	{
		DebugDrawLine( contactPos, contactPos + ( velNorm * 64 ), 255, 0, 0, true, 30.0 ) //Grenade Entry Vel
		DebugDrawLine( startPortalData.portalFX.GetOrigin(), startPortalData.portalFX.GetOrigin() + ( startPortalData.portalFX.GetUpVector() * 64 ), 0, 255, 0, true, 30.0 ) //Grenade Entry Vel

		DebugDrawLine( endPortalData.portalFX.GetOrigin(), impactPoint, 0, 255, 255, true, 30.0 ) //Grenade Entry Vel
		DebugDrawLine( endFXOrigin, endFXOrigin + exitPoint, 255, 0, 255, true, 30.0 ) //Grenade Entry Vel

		DebugDrawLine( contactPos, endFXOrigin + exitPoint, 255, 255, 0, true, 30.0 ) //Grenade Entry Vel

		DebugDrawLine( endFXOrigin, endFXOrigin + ( endPortalData.portalFX.GetUpVector() * 64 ), 0, 255, 0, true, 30.0 ) //Grenade Entry Vel
		DebugDrawLine( endFXOrigin + exitPoint, ( endFXOrigin + exitPoint ) + ( velNorm * 64 ), 255, 0, 0, true, 30.0 ) //Grenade Entry Vel
		DebugDrawLine( endFXOrigin + exitPoint, ( endFXOrigin + exitPoint ) + ( newDir * 128 ), 0, 0, 255, true, 30.0 ) //Grenade Entry Vel
	}

}

vector function PhaseTunnel_GetPointOnRectangularPlane( vector origin, vector planeNormal, vector planeUp, float height, float width, vector testPoint )
{
	float halfHeight = height / 2
	float halfWidth = width / 2
	vector planeRight = CrossProduct( planeNormal, planeUp )
	//Get point on Tri A
	vector triAPointA = origin + ( planeUp * -halfHeight ) + ( planeRight * halfWidth )
	vector triAPointB = origin + ( planeUp * halfHeight ) + ( planeRight * halfWidth )
	vector triAPointC = origin + ( planeUp * halfHeight ) + ( planeRight * -halfWidth )
	vector pointOnTriA = GetClosestPointOnPlane( triAPointA, triAPointB, triAPointC, testPoint, true )

	
	vector triBPointA = origin + ( planeUp * -halfHeight ) + ( planeRight * -halfWidth )
	vector triBPointB = origin + ( planeUp * halfHeight ) + ( planeRight * -halfWidth )
	vector triBPointC = origin + ( planeUp * -halfHeight ) + ( planeRight * halfWidth )
	vector pointOnTriB = GetClosestPointOnPlane( triBPointA, triBPointB, triBPointC, testPoint, true )

	if ( PHASE_TUNNEL_DEBUG_DRAW_PROJECTILE_TELEPORT )
	{
		DebugDrawLine( triAPointA, triAPointB, 255, 0, 0, true, 20.0 )
		DebugDrawLine( triAPointB, triAPointC, 255, 0, 0, true, 20.0 )
		DebugDrawLine( triAPointC, triAPointA, 255, 0, 0, true, 20.0 )

		DebugDrawLine( triBPointA, triBPointB, 0, 255, 0, true, 20.0 )
		DebugDrawLine( triBPointB, triBPointC, 0, 255, 0, true, 20.0 )
		DebugDrawLine( triBPointC, triBPointA, 0, 255, 0, true, 20.0 )
	}

	//Return the closer of the two points
	float distSqrA = DistanceSqr( testPoint, pointOnTriA )
	float distSqrB = DistanceSqr( testPoint, pointOnTriB )
	return distSqrA <= distSqrB ? pointOnTriA : pointOnTriB
}

void function PhaseTunnel_PhaseEntity( entity ent, entity tunnelEnt, entity trigger )
{
	Assert ( IsNewThread(), "Must be threaded off." )
	ent.EndSignal( "OnDeath" )
	ent.EndSignal( "OnDestroy" )
	tunnelEnt.EndSignal( "OnDestroy" )

	PhaseTunnelData tunnelData       = file.tunnelData[ tunnelEnt ]
	PhaseTunnelPortalData portalData = file.triggerEndpoint[ trigger ]

	//D-Bounce Phase Transition.
	if ( file.phaseTime[ tunnelEnt ] > Time() )
		return

	if ( !tunnelEnt.DoesShareRealms( ent ) )
		return

	bool entHasUsedTunnelBefore = false
	if ( ent in tunnelData.entPhaseTime )
	{
		entHasUsedTunnelBefore = true
		if ( tunnelData.entPhaseTime[ ent ] > Time() )
			return
		else
			tunnelData.entPhaseTime[ ent ] = Time() + PHASE_TUNNEL_TELEPORT_DBOUNCE
	}
	else
	{
		tunnelData.entPhaseTime[ ent ] <- Time() + PHASE_TUNNEL_TELEPORT_DBOUNCE
	}

	OnThreadEnd(
		function() : ( ent, tunnelData )
		{
			tunnelData.activeUsers--

			if ( IsValid( ent ) )
			{
				tunnelData.entPhaseTime[ ent ] = Time() + 1.0
			}

			if ( IsValid( tunnelData.tunnelEnt ) )
				file.phaseTime[ tunnelData.tunnelEnt ] = Time() + PHASE_TUNNEL_TELEPORT_DBOUNCE

		} )

	tunnelData.activeUsers++
	file.phaseTime[ tunnelEnt ] = Time() + PHASE_TUNNEL_TELEPORT_DBOUNCE
	StatsHook_PhaseTunnel_EntTraversed( ent, tunnelEnt, entHasUsedTunnelBefore )
	waitthread PhaseTunnel_MoveEntAlongPath( ent, portalData.pathData )
}

void function PhaseTunnel_MoveEntAlongPath( entity player, PhaseTunnelPathData pathData )
{
	player.EndSignal( "OnDeath" )

	//printt( "MOVING PLAYER " + player + " ALONG PATH!!!" )

	array< PhaseTunnelPathNodeData > pathNodeDataArray = clone pathData.pathNodes

	float pathTravelTime = pathData.pathTime
	player.Zipline_Stop()
	player.ClearTraverse()
	player.SetPredictionEnabled( false )
	player.FreezeControlsOnServer()

	//Don't re-enable weapons if player is carrying loot.
	if ( !SURVIVAL_IsPlayerCarryingLoot( player ) && !Bleedout_IsBleedingOut( player )  )
		HolsterAndDisableWeapons( player )

	entity mover = CreateScriptMover( player.GetOrigin(), player.GetAngles() )

	mover.EnableNonPhysicsMoveInterpolation( false ) // works around bug R5DEV-49571

	PhaseTunnelPathNodeData pathNodeData
	pathNodeData.origin = player.GetOrigin()
	pathNodeData.angles = player.GetAngles()
	pathNodeData.wasInContextAction = player.ContextAction_IsActive()
	pathNodeData.wasCrouched = player.IsCrouched()

	vector originAtStart = player.GetOrigin()

	player.e.isInPhaseTunnel = true

	OnThreadEnd(
		function() : ( player, mover, pathNodeData, originAtStart )
		{
			if ( IsValid( player ) )
			{

				if ( PHASE_TUNNEL_DEBUG_DRAW_PLAYER_TELEPORT )
				{
					DebugDrawLine( player.GetOrigin(), pathNodeData.origin, 255, 0, 0, true, 30.0 ) //Last Position to current Node
				}

				player.SetPredictionEnabled( true )
				player.e.isInPhaseTunnel = false

				// TODO: DeployAndEnableWeapons should really use a stack so we don't have to do weird if-else's
				if ( !SURVIVAL_IsPlayerCarryingLoot( player ) && !Bleedout_IsBleedingOut( player ) )
				{
					if ( Survival_IsPlayerHealing( player ) )
						EnableOffhandWeapons( player )
					else
						DeployAndEnableWeapons( player )
				}

				player.ClearParent()
				player.UnfreezeControlsOnServer()
				if ( pathNodeData.wasCrouched )
				{
				 	thread PhaseTunnel_PathFollowCrouchPlayer( player )
				}

				if ( pathNodeData.wasInContextAction && !PutEntityInSafeSpot( player, null, null, originAtStart, player.GetOrigin() ) )
					//Only do PutEntityInSafeSpot check() if the last saved position they were in a context action, since context actions can put you in normally illegal spots, e.g. behind geo. If you do the PutEntityInSafeSpot() check all the time you get false positives if you always use start position as safe starting spot
				{
					player.TakeDamage( player.GetHealth() + 1, player, player, { damageSourceId = eDamageSourceId.phase_shift, scriptType = DF_GIB | DF_BYPASS_SHIELD | DF_SKIPS_DOOMED_STATE } )
				}

				//printt( "STOPPED MOVING PLAYER " + player + " ALONG PATH!!!" )

			}

			if ( IsValid( mover ) )
				mover.Destroy()
		}
	)

	WaitEndFrame() // wait for the last save

	EmitSoundOnEntityOnlyToPlayer( player, player, "Wraith_PhaseGate_Travel_1p" )
	EmitSoundOnEntityExceptToPlayer( player, player, "Wraith_PhaseGate_Travel_3p" )

	OnThreadEnd(
	function() : ( player )
		{
			StopSoundOnEntity( player, "Wraith_PhaseGate_Travel_1p" )
			StopSoundOnEntity( player, "Wraith_PhaseGate_Travel_3p" )
		}
	)

	player.SetParent( mover, "REF", false )
	ViewConeZeroInstant( player )

	int pathLength = pathNodeDataArray.len()
	float snapshotFrameTime = pathTravelTime / pathLength
	int snapshotsPerFrame = int ( PHASE_TUNNEL_PATH_SNAPSHOT_INTERVAL / snapshotFrameTime )
	int partialCount = snapshotsPerFrame == 0 ? 0 : ( pathLength - 1 ) % snapshotsPerFrame
	int pathCount = snapshotsPerFrame == 0 ? pathLength : ( pathLength - partialCount ) / snapshotsPerFrame

	PIN_Interact( player, "wraith_portal", pathNodeDataArray[0].origin )

	/*
	printt( "PATH LENGTH: " + pathLength )
	printt( "SNAPSHOT FRAME TIME: " + snapshotFrameTime )
	printt( "SNAPSHOTS PER FRAME: " + snapshotsPerFrame )
	printt( "PARTIAL COUNT: " + partialCount )
	printt( "PATH COUNT: " + pathCount )
	printt( "PATH LENGTH END: " + ( ( pathCount * snapshotsPerFrame ) + partialCount ) )
	*/

	array<int> frameSteps
	if ( partialCount > 0 )
		frameSteps.append( partialCount )

	for ( int i = 0; i <= pathCount; i++ )
	{
		int snapshotStep = snapshotsPerFrame == 0 ? 1 : snapshotsPerFrame
		frameSteps.append( snapshotStep )
	}

	int frameStepLength = frameSteps.len()
	//printt( "FRAME STEP LENGTH: " + frameStepLength )

	float updateInterval = snapshotsPerFrame == 0 ? snapshotFrameTime : 0.0000001
	float lerpTime = snapshotsPerFrame == 0 ? PHASE_TUNNEL_PATH_FOLLOW_TICK : snapshotFrameTime * snapshotsPerFrame

	if ( PHASE_TUNNEL_DEBUG_DRAW_PLAYER_TELEPORT )
	{
		foreach ( PhaseTunnelPathNodeData nodeData in pathNodeDataArray )
		{
			if ( nodeData.validExit )
			{
				DebugDrawCircle( nodeData.origin, <0, 0, 0>, 16, 0, 255, 0, true, 30.0 )
			}
			else
			{
				DebugDrawCircle( nodeData.origin, <0, 0, 0>, 16, 255, 0, 0, true, 30.0 )
			}
		}
	}

	float phaseTime = frameSteps.len() * FRAME_TIME
	PhaseShift( player, 0.0, phaseTime + FRAME_TIME, eShiftStyle.Tunnel )

	float startTime = Time()
	int index = pathLength - 1
	vector nextPosition
	int stopPos = 0
	for ( int i=0; i<frameSteps.len(); i++ )
	{
		int step = frameSteps[i]

		if ( index < 0 )
			break

		int nextIndex = index - step
		vector anglesToUse = GetNextAngleToLookAt( index, step, pathNodeDataArray ) // nextIndex < 0 ? pathNodeDataArray[index].angles : VectorToAngles( pathNodeDataArray[nextIndex].origin - pathNodeDataArray[index].origin )
		float angleLerpTime = nextIndex < 0 ? lerpTime : lerpTime * 4.0

		if ( PHASE_TUNNEL_DEBUG_DRAW_PLAYER_TELEPORT )
		{
			if ( pathNodeDataArray[ index ].validExit )
			{
				DebugDrawLine( player.GetOrigin(), pathNodeDataArray[index].origin, 0, 255, 0, true, 30.0 ) //Last Position to current Node
			}
			else
			{
				DebugDrawLine( player.GetOrigin(), pathNodeDataArray[index].origin, 255, 0, 0, true, 30.0 ) //Last Position to current Node
			}
		}

		// BUILD LIST OF INDECES TO USE, index-0 is the last spot, moving towards our current position
		array<int> indeces
		for ( int j=index; j >= stopPos; j-=step )
		{
			indeces.insert(0,j)
		}

		// SEEK FROM END TO WHERE WE ARE
		for ( int j=0; j<indeces.len()-1; j++ )
		{
			int k = indeces[j]
			bool crouched = pathNodeDataArray[k].wasCrouched
			vector mins = GetBoundsMin( HULL_HUMAN )
			vector maxs = GetBoundsMax( HULL_HUMAN )
			if ( crouched )
				maxs = <maxs.x, maxs.y, CROUCH_HEIGHT>
			TraceResults results = TraceHull( pathNodeDataArray[k].origin, pathNodeDataArray[k].origin+<0,0,1>, mins, maxs, GetPlayerArray_Alive(), TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_NONE )
			if ( results.startSolid )
			{
				stopPos = indeces[j+1]
			}
			else
			{
				break
			}
		}

		if ( index >= stopPos )
		{
			//printt( "MOVING TO NODE: " + index )
			mover.NonPhysicsMoveTo( pathNodeDataArray[index].origin, lerpTime, 0, 0 )
			if ( index - step >= 0 )
			{
				mover.NonPhysicsRotateTo( anglesToUse, angleLerpTime, 0, 0 )
				pathNodeData.angles = anglesToUse //pathNodeDataArray[index].angles
			}
			pathNodeData.origin = pathNodeDataArray[index].origin
			player.SetVelocity( pathNodeDataArray[index].velocity )
			pathNodeData.velocity = pathNodeDataArray[index].velocity
			pathNodeData.wasInContextAction = pathNodeDataArray[index].wasInContextAction
			pathNodeData.wasCrouched = pathNodeDataArray[index].wasCrouched
			//printt( "wasCrouched?" + pathNodeData.wasCrouched )
			if ( pathNodeData.wasCrouched )
			{
				//printt( "PhaseTunnelCrouchPlayer" )
				thread PhaseTunnel_PathFollowCrouchPlayer( player )
			}
		}

		index -= step

		wait updateInterval
		//WaitFrame()
	}

	player.ClearParent()

	//HACK: If we clear the parent and set angles in the same frame, the player ends up facing in a random direction.
	WaitFrame()
	player.SetAbsOrigin( pathNodeData.origin )

	if ( pathNodeData.wasInContextAction && !PutEntityInSafeSpot( player, null, null, originAtStart, player.GetOrigin() ) )
		//Only do PutEntityInSafeSpot check() if the last saved position they were in a context action, since context actions can put you in normally illegal spots, e.g. behind geo. If you do the PutEntityInSafeSpot() check all the time you get false positives if you always use start position as safe starting spot
	{
		player.TakeDamage( player.GetHealth() + 1, player, player, { damageSourceId = eDamageSourceId.phase_shift, scriptType = DF_GIB | DF_BYPASS_SHIELD | DF_SKIPS_DOOMED_STATE } )
	}

}

vector function GetNextAngleToLookAt( int currentIndex, int step, array< PhaseTunnelPathNodeData > pathNodeDataArray )
{
	int lookAhead = 5
	int total = 1
	vector startPosition = pathNodeDataArray[currentIndex].origin
	int nextIndex = currentIndex - step

	if ( nextIndex < 0 )
		return pathNodeDataArray[currentIndex].angles

	vector nextPosition = startPosition

	while ( nextIndex >= 0 && lookAhead > 0 )
	{
		nextPosition = nextPosition + pathNodeDataArray[nextIndex].origin

		lookAhead--
		total++
		nextIndex = nextIndex - step
	}

	nextPosition = nextPosition / total

	if ( PHASE_TUNNEL_DEBUG_DRAW_PLAYER_TELEPORT )
	{
		DebugDrawSphere( startPosition, 2, 0,255,0, true, 10.0 )
		DebugDrawLine( startPosition, nextPosition, 255,0,0, true, 10.0 )
	}

	return VectorToAngles( nextPosition - startPosition )
}

void function PhaseTunnel_PathFollowCrouchPlayer( entity player )
{
	Signal( player, "PhaseTunnel_PathFollowCrouchPlayer" )
	EndSignal( player, "OnDeath" )
	EndSignal( player, "PhaseTunnel_PathFollowCrouchPlayer" )
	player.ForceCrouch()
	OnThreadEnd(
		function() : ( player )
		{
			if ( IsValid( player ) )
			{
				player.UnforceCrouch()
				PutEntityInSafeSpot( player, null, null, player.GetOrigin(), player.GetOrigin() )
			}
		}
	)
	wait 0.2
}

bool function PhaseTunnel_ShouldPhaseEnt( entity target )
{
	if ( !target.IsPlayer() )
		return false

	if ( target.IsTitan() )
		return false

	if ( target.IsPhaseShifted() )
		return false

	if ( target.ContextAction_IsReviving() )
		return false

	if ( target.ContextAction_IsBeingRevived() )
		return false

	//We can't go through a phase tunnel while placing a phase tunnel
	if ( StatusEffect_GetSeverity( target, eStatusEffect.placing_phase_tunnel ) )
		return false

	if ( IsSuperSpectre( target ) )
		return false

	if ( IsTurret( target ) )
		return false

	if ( IsDropship( target ) )
		return false

	if ( target.e.isInPhaseTunnel )
		return false

	return true
}

bool function PhaseTunnel_ShouldPhaseProjectile( entity projectile )
{
	if ( !IsValid( projectile ) )
		return false

	if ( projectile.proj.lastTeleportTime + PHASE_TUNNEL_TELEPORT_DBOUNCE_PROJECTILE >= Time() )
		return false

	string weaponClassName = projectile.ProjectileGetWeaponClassName()
	switch ( projectile.GetClassName() )
	{
		case "crossbow_bolt":
			return true
			break
		case "grenade":
			return true
			break
		case "rpg_missile":
			return true
			break
		default:
			return false
			break
	}
	unreachable
}

void function PhaseTunnel_StartTrackingPositions( entity player, PhaseTunnelPathData startPath, PhaseTunnelPathData endPath )
{
	player.EndSignal( "PhaseTunnel_CancelPlacement" )
	player.EndSignal( "OnDeath" )

	//StatusEffect_AddTimed( player, eStatusEffect.placing_phase_tunnel, 1.0, PHASE_TUNNEL_PLACEMENT_DURATION, PHASE_TUNNEL_PLACEMENT_DURATION )

	waitthread PhaseTunnel_StartTrackingPositions_Internal( player, startPath, endPath )

	if ( IsValid( player ) )
	{
		vector startingOrigin = player.GetOriginOutOfTraversal()
		if ( endPath.pathNodes.len() )
			startingOrigin = endPath.pathNodes[ 0 ].origin

		if ( !player.IsTitan() )
		{
			vector origin = player.GetOriginOutOfTraversal()
			vector angles = player.GetAngles()
			angles = <0, player.CameraAngles().y, 0>

			float distSqr = DistanceSqr( startingOrigin, origin )
			bool canTeleport = PhaseTunnel_ValidPortalExitPoint( player, origin, player )
			bool safeDist = distSqr >= PHASE_TUNNEL_MIN_PORTAL_DIST_SQR

			PhaseTunnelPathNodeData startPathData
			startPathData.origin = origin
			startPathData.angles = angles
			startPathData.velocity = player.GetVelocity()
			startPathData.wasInContextAction = player.ContextAction_IsActive()
			startPathData.wasCrouched = ( player.IsCrouched() && !player.CanStand() )
			startPathData.validExit = canTeleport && safeDist
			startPathData.time = Time()

			// printt( "----------" + data.wasCrouched + "----------" )

			PhaseTunnelPathNodeData endPathData
			endPathData.origin = origin
			endPathData.angles = AnglesCompose( angles, <0,180,0> )
			endPathData.velocity = player.GetVelocity()
			endPathData.wasInContextAction = player.ContextAction_IsActive()
			endPathData.wasCrouched = ( player.IsCrouched() && !player.CanStand() )
			endPathData.validExit = canTeleport && safeDist
			endPathData.time = Time()

			//If the exit direction of the portal is facing a wall. Reverse it so the player doesn't exit looking at a wall.
			vector playerCenter = player.GetWorldSpaceCenter()
			vector forwardDir = player.GetForwardVector()
			if ( !PhaseTunnel_BarrierInDirection( player, playerCenter, forwardDir, player ) )
			{
				startPathData.angles 	= AnglesCompose( angles, <0,180,0> )
				endPathData.angles 		= angles
			}

			startPath.pathNodes.insert( 0, startPathData )
			endPath.pathNodes.append( endPathData )
		}

		StatusEffect_StopAllOfType( player, eStatusEffect.placing_phase_tunnel )

	}

	PhaseTunnel_CleanAndFinalizePath( startPath )
	PhaseTunnel_CleanAndFinalizePath( endPath )

	Assert( fabs( startPath.pathDistance - endPath.pathDistance ) < 0.1 , "Start Path and End Path are not the same length: " + startPath.pathDistance + " vs " + endPath.pathDistance )
	Assert( fabs( startPath.pathTime - endPath.pathTime ) < 0.1, "Start Path and End Path do not have the same travel time: " + startPath.pathTime + " vs " + endPath.pathTime )
}

void function PhaseTunnel_StartTrackingPositions_Internal( entity player, PhaseTunnelPathData startPath, PhaseTunnelPathData endPath )
{
	player.EndSignal( "PhaseTunnel_CancelPlacement" )
	player.EndSignal( "PhaseTunnel_EndPlacement" )
	player.EndSignal( "OnDeath" )

	vector lastOrigin 	  = player.GetOriginOutOfTraversal()
	vector startingOrigin = player.GetOriginOutOfTraversal()
	bool firstNode = true

	array< entity > shutdownArray

	OnThreadEnd(
		function() : ( shutdownArray )
		{
			foreach ( entity ent in shutdownArray )
			{
				if ( IsValid( ent ) )
					ent.Destroy()
			}
		}
	)

	while ( 1 )
	{
		if ( !player.IsTitan() )
		{
			vector origin = player.GetOriginOutOfTraversal()
			vector angles = player.GetAngles()
			angles = <0, player.CameraAngles().y, 0>
			float distSqr = DistanceSqr( startingOrigin, origin )

			bool wasCrouched = player.IsCrouched() && !player.CanStand() //firstNode ? ( player.IsCrouched() && !player.CanStand() ) : player.IsCrouched()
			bool canTeleport = ( PhaseTunnel_ValidPortalExitPoint( player, origin, player ) )
			bool safeDist = distSqr >= PHASE_TUNNEL_MIN_PORTAL_DIST_SQR

			//Only record shapshots when player has moved.
			if ( ( lastOrigin != origin || firstNode ) && ( ( firstNode && canTeleport ) || !firstNode ) )
			{
				PhaseTunnelPathNodeData startPathData
				startPathData.origin = origin
				startPathData.angles = angles
				startPathData.velocity = player.GetVelocity()
				startPathData.wasInContextAction = player.ContextAction_IsActive()
				startPathData.wasCrouched = wasCrouched
				startPathData.validExit	= firstNode ? canTeleport : canTeleport && safeDist
				startPathData.time = Time()

				// printt( "----------" + data.wasCrouched + "----------" )

				PhaseTunnelPathNodeData endPathData
				endPathData.origin = origin
				endPathData.angles = AnglesCompose( angles, <0,180,0> )
				endPathData.velocity = player.GetVelocity()
				endPathData.wasInContextAction = player.ContextAction_IsActive()
				endPathData.wasCrouched = wasCrouched
				endPathData.validExit	= firstNode ? canTeleport : canTeleport && safeDist
				endPathData.time = Time()

				if ( firstNode )
				{
					startingOrigin = origin
					firstNode = false

					//If the exit direction of the portal is facing a wall. Reverse it so the player doesn't exit looking at a wall.
					vector playerCenter = player.GetWorldSpaceCenter()
					vector forwardDir = player.GetForwardVector()
					if ( !PhaseTunnel_BarrierInDirection( player, playerCenter, -forwardDir, player ) )
					{
						startPathData.angles 	= AnglesCompose( angles, <0,180,0> )
						endPathData.angles 		= angles
					}

					float prePlaceFXOffset = wasCrouched ? PHASE_TUNNEL_PLACEMENT_HEIGHT_CROUCHING : PHASE_TUNNEL_PLACEMENT_HEIGHT_STANDING
					int fxid = GetParticleSystemIndex( PHASE_TUNNEL_PREPLACE_FX )
					vector fxOrigin = player.GetOrigin() + ( <0,0,1> * prePlaceFXOffset )
					entity fx = StartParticleEffectInWorld_ReturnEntity( fxid, fxOrigin, player.GetAngles() + <0,90,90> )
					fx.RemoveFromAllRealms()
					fx.AddToOtherEntitysRealms( player )
					EmitSoundOnEntity( fx, SOUND_PREPORTAL_LOOP )

					OnThreadEnd(
					function() : ( fx )
						{
							if ( IsValid(fx) )
							{
								StopSoundOnEntity( fx, SOUND_PREPORTAL_LOOP )
							}
						}
					)

					shutdownArray.append( fx )

					entity traceBlocker = CreateTraceBlockerVolume( fxOrigin, 24.0, false, CONTENTS_NOGRAPPLE, player.GetTeam(), PHASETUNNEL_PRE_BLOCKER_SCRIPTNAME )
					//traceBlocker.RemoveFromAllRealms()
					//traceBlocker.AddToOtherEntitysRealms( player )
					shutdownArray.append( traceBlocker )
				}

				startPath.pathNodes.insert( 0, startPathData )
				endPath.pathNodes.append( endPathData )
			}

			lastOrigin = origin
		}

		wait PHASE_TUNNEL_PATH_SNAPSHOT_INTERVAL
		//WaitFrame()
	}
}

void function PhaseTunnel_CleanAndFinalizePath( PhaseTunnelPathData pathData )
{
	int startIndex = 0
	for ( int i = 0; i < pathData.pathNodes.len(); i++ )
	{
		if ( pathData.pathNodes[ i ].validExit )
		{
			startIndex = i
			break
		}
	}

	int endIndex = 0
	for ( int i = pathData.pathNodes.len() - 1; i > 0; i-- )
	{
		if ( pathData.pathNodes[ i ].validExit )
		{
			endIndex = i
			break
		}
	}

//	printt( "STARTING INDEX: " + startIndex )
//	printt( "ENDING INDEX: " + endIndex )
//	printt( "INDEX COUNT: " + ( endIndex - startIndex ) )

	vector lastOrigin = pathData.pathNodes[ startIndex ].origin
	array<PhaseTunnelPathNodeData> finalPathNodeData
	for ( int i = startIndex; i <= endIndex; i++ )
	{
		vector origin = pathData.pathNodes[ i ].origin
		finalPathNodeData.append( pathData.pathNodes[ i ] )
		float moveDist = Length( lastOrigin - origin )
		pathData.pathDistance += moveDist
		lastOrigin = origin
	}

	pathData.pathNodes = finalPathNodeData
	pathData.pathTime = GraphCapped( pathData.pathDistance, 64.0, PHASE_TUNNEL_PLACEMENT_DIST, PHASE_TUNNEL_TELEPORT_TRAVEL_TIME_MIN, PHASE_TUNNEL_TELEPORT_TRAVEL_TIME_MAX )
}

bool function PhaseTunnel_ValidPortalExitPoint( entity player, vector testOrg, entity ignoreEnt = null )
{
	int solidMask = TRACE_MASK_PLAYERSOLID
	vector mins
	vector maxs
	int collisionGroup = TRACE_COLLISION_GROUP_PLAYER
	array<entity> ignoreEnts = [ player ]

	if ( IsValid( ignoreEnt ) )
		ignoreEnts.append( ignoreEnt )
	TraceResults result

	mins = player.GetPlayerMins()
	maxs = player.GetPlayerMaxs()
	result = TraceHull( testOrg, testOrg + <0,0,1>, mins, maxs, ignoreEnts, solidMask, collisionGroup )
	//PrintTraceResults( result )

	if ( result.startSolid || result.fraction < 1 || result.surfaceNormal != <0,0,0> )
	{
		if ( PHASE_TUNNEL_DEBUG_DRAW_PLAYER_TELEPORT )
			DebugDrawBox( result.endPos, mins, maxs, 255, 0, 0, 1, 20.0 )

		return false
	}

	if ( PHASE_TUNNEL_DEBUG_DRAW_PLAYER_TELEPORT )
		DebugDrawBox( result.endPos, mins, maxs, 0, 255, 0, 1, 20.0 )

	return true
}

bool function PhaseTunnel_BarrierInDirection( entity player, vector origin, vector dir, entity ignoreEnt = null )
{
	int solidMask = TRACE_MASK_PLAYERSOLID
	vector mins
	vector maxs
	int collisionGroup = TRACE_COLLISION_GROUP_PLAYER
	array<entity> ignoreEnts = [ player ]

	if ( IsValid( ignoreEnt ) )
		ignoreEnts.append( ignoreEnt )
	TraceResults result

	mins = player.GetPlayerMins()
	maxs = player.GetPlayerMaxs()
	//result = TraceHull( testOrg, testOrg + <0,0,1>, mins, maxs, ignoreEnts, solidMask, collisionGroup )
	result = TraceLineHighDetail( origin, origin + ( dir * PHASE_TUNNEL_MIN_GEO_REVERSE_DIST ), ignoreEnts, solidMask, collisionGroup )
	//PrintTraceResults( result )

	if ( result.fraction < 1 )
	{
		if ( PHASE_TUNNEL_DEBUG_DRAW_PLAYER_TELEPORT )
			DebugDrawLine( origin, result.endPos, 255, 0, 0, true, 20.0 )

		return false
	}

	if ( PHASE_TUNNEL_DEBUG_DRAW_PLAYER_TELEPORT )
		DebugDrawLine( origin, result.endPos, 0, 255, 0, true, 20.0 )

	return true
}

void function PhaseTunnel_CancelPlacement( entity player )
{
	entity weapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )

	if ( IsValid( weapon ) )
	{
		if ( weapon.IsChargeWeapon() && weapon.GetWeaponClassName() == "mp_weapon_phase_tunnel" )
		{
			weapon.ForceChargeEndNoAttack()
			player.Signal( "PhaseTunnel_CancelPlacement" )
			player.Signal( "PhaseTunnel_EndPlacement" )
		}
	}
}
#endif //SERVER

#if CLIENT
void function PlayerWaypoint_CreateCallback( entity wp )
{
	int pingType = Waypoint_GetPingTypeForWaypoint( wp )

	int wpType = wp.GetWaypointType()

	if ( WaypointOwnerIsMuted( wp ) )
		return

	if ( pingType == ePingType.ABILITY_WORMHOLE && wpType == eWaypoint.PING_LOCATION )
	{
		thread TrackIsVisible( wp )
	}
}


// !!!!!!!!!!!!!!!!! DO NOT COPY THIS !!!!!!!!!!!!!!!!!

// This is specifically written for Phase Tunnel assuming you will only ever see 2 tunnels max
// We do not want to be doing traces for every waypoint out there
// If we want to do this for other icons, we should get a code feature

// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

void function TrackIsVisible( entity wp )
{
	entity viewPlayer = GetLocalViewPlayer()

	if ( !IsValid( viewPlayer ) )
		return

	viewPlayer.EndSignal( "OnDeath" )

	while( IsValid( wp ) )
	{
		if ( wp.wp.ruiHud != null )
		{
			RuiSetBool( wp.wp.ruiHud, "hideIcon", PlayerCanSeePos( viewPlayer, wp.GetOrigin(), true, 25.0 ) )
		}

		WaitFrame()
	}
}

void function PhaseTunnel_OnPropScriptCreated( entity ent )
{
	switch ( ent.GetScriptName() )
	{
		case "portal_marker":
			//thread PhaseTunnel_CreateHUDMarker( ent )
			break
	}
}

void function PhaseTunnel_CreateHUDMarker( entity portalMarker )
{
	//printt( "CREATING PORTAL RUI" )

	entity localClientPlayer = GetLocalClientPlayer()

	portalMarker.EndSignal( "OnDestroy" )

	if ( !PhaseTunnel_ShouldShowIcon( localClientPlayer, portalMarker ) )
		return

	vector pos = portalMarker.GetOrigin()
	var topology = CreateRUITopology_Worldspace( portalMarker.GetOrigin(), portalMarker.GetAngles(), 24, 24 )
	var ruiPlane = RuiCreate( $"ui/phase_tunnel_timer.rpak", topology, RUI_DRAW_WORLD, 0 )
	RuiSetGameTime( ruiPlane, "startTime", Time() )
	RuiSetFloat( ruiPlane, "lifeTime", PHASE_TUNNEL_LIFETIME )

	OnThreadEnd(
		function() : ( ruiPlane, topology )
		{
			RuiDestroy( ruiPlane )
			RuiTopology_Destroy( topology )
		}
	)

	WaitForever()
}

bool function PhaseTunnel_ShouldShowIcon( entity localPlayer, entity portalMarker )
{
	if ( !GamePlayingOrSuddenDeath() )
		return false

	//if ( IsWatchingReplay() )
	//	return false

	//if ( localPlayer.GetTeam() != portalMarker.GetTeam() )
	//	return false

	return true
}

void function PhaseTunnel_OnBeginPlacement( entity player, int statusEffect, bool actuallyChanged )
{
	if ( player != GetLocalViewPlayer() )
		return
}

void function PhaseTunnel_OnEndPlacement( entity player, int statusEffect, bool actuallyChanged )
{
	if ( player != GetLocalViewPlayer() )
		return

	HidePlayerHint( "#WPN_PHASE_TUNNEL_PLAYER_DEPLOY_STOP_HINT" )
}

void function TunnelVisualsEnabled( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( ent != GetLocalViewPlayer() )
		return

	entity player = ent

	entity cockpit = player.GetCockpit()
	if ( !IsValid( cockpit ) )
		return

	int fxHandle = StartParticleEffectOnEntity( cockpit, GetParticleSystemIndex( PHASE_TUNNEL_1P_FX ), FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
	thread TunnelScreenFXThink( player, fxHandle, cockpit )
}

void function TunnelVisualsDisabled( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( ent != GetLocalViewPlayer() )
		return

	ent.Signal( "EndTunnelVisual" )
}

void function TunnelScreenFXThink( entity player, int fxHandle, entity cockpit )
{
	player.EndSignal( "EndTunnelVisual" )
	player.EndSignal( "OnDeath" )
	cockpit.EndSignal( "OnDestroy" )

	OnThreadEnd(
		function() : ( fxHandle )
		{
			if ( !EffectDoesExist( fxHandle ) )
				return

			EffectStop( fxHandle, false, true )
		}
	)

	for ( ;; )
	{
		float velocityX = Length( player.GetVelocity() )

		if ( !EffectDoesExist( fxHandle ) )
			break

		velocityX = GraphCapped( velocityX, 0.0, 360, 5, 200 )
		EffectSetControlPointVector( fxHandle, 1, <velocityX,999,0> )
		WaitFrame()
	}
}
#endif //CLIENT