//Updated by @CafeFPS based on S21 scripts

global function MpWeaponPhaseTunnel_Init
global function OnWeaponActivate_weapon_phase_tunnel
global function OnWeaponDeactivate_weapon_phase_tunnel
global function OnWeaponAttemptOffhandSwitch_weapon_phase_tunnel

global function OnWeaponChargeBegin_weapon_phase_tunnel
global function OnWeaponChargeEnd_weapon_phase_tunnel

global function OnWeaponPrimaryAttack_ability_phase_tunnel
#if SERVER
global function OnWeaponNPCPrimaryAttack_ability_phase_tunnel

global function PhaseTunnel_PrepareToMoveEntAlongTunnel
global function PhaseTunnel_RevertEntStateAfterMovingAlongTunnel
global function PhaseTunnel_ShouldPhaseEnt

global function PhaseTunnel_GetAllTunnelEnts
global function PhaseTunnel_IsTunnelValid
global function PhaseTunnel_GetTunnelStart
global function PhaseTunnel_GetTunnelEnd
global function PhaseTunnel_MarkForDelete

global function PhaseTunnel_CancelPlacement

global function PhaseTunnel_CreatePortalData
global function PhaseTunnel_CleanAndFinalizePath
global function PhaseTunnel_WaitForPhaseTunnelExpiration
global function PhaseTunnel_PhaseEntity
global function PhaseTunnel_SanitizeWeaponMods

#if DEVELOPER
global function DEV_PhaseTunnel_DestroyAll
#endif
#endif
global function PhaseTunnel_IsPortalExitPointValid

global const float PHASE_TUNNEL_CROUCH_HEIGHT = 48

const string SOUND_ACTIVATE_1P = "Wraith_PhaseGate_FirstGate_DeviceActivate_1p" // Play (to 1p only) as soon as the "arm raise" animation for placing the first gate starts (basically as soon as the ability key is pressed and the ability successfully starts).
const string SOUND_ACTIVATE_3P = "Wraith_PhaseGate_FirstGate_DeviceActivate_3p" // Play (to everyone except 1p) as soon as the 3p Wraith begins activating the ability to place the first gate.
const string SOUND_SUCCESS_1P = "Wraith_PhaseGate_FirstGate_Place_1p" // Play (to 1p only) when the first gate (the "pre-portal" thing) gets placed.  Can be played on the gate or the player.
const string SOUND_SUCCESS_3P = "Wraith_PhaseGate_FirstGate_Place_3p" // Play (to everyone except 1p) when the first gate (the "pre-portal" thing) gets placed.  Should play on the gate.
const string SOUND_PREPORTAL_LOOP = "Wraith_PhaseGate_PrePortal_Loop" // Play (to everyone) when first gate is created.  Should play on the gate (pre-portal thing).  Should be stopped when the second gate is placed and the gates connect.
const string SOUND_PORTAL_OPEN = "Wraith_PhaseGate_Portal_Open" // Play (to everyone) when second gate is created and gates connect.  Should play on each gate.  (Stop Wraith_PhaseGate_PrePortal_Loop when this plays.)
const string SOUND_PORTAL_LOOP = "Wraith_PhaseGate_Portal_Loop" // Play (to everyone) when second gate is created and gates connect.  Should play on each gate.  Stop when gates expire.
const string SOUND_PORTAL_CLOSE = "Wraith_PhaseGate_Portal_Expire" // Play (to everyone) when gates expire.  Should play on each gate.
const string SOUND_PORTAL_TRAVEL_1P = "Wraith_phasegate_Travel_1p"
const string SOUND_PORTAL_TRAVEL_3P = "Wraith_phasegate_Travel_3p"
const string SOUND_PORTAL_TRAVEL_1P_BREACH = "Ash_PhaseBreach_Travel_1p"
const string SOUND_PORTAL_TRAVEL_3P_BREACH = "Ash_PhaseBreach_Travel_3p"
             
const string SOUND_PORTAL_TRAVEL_1P_TRANSPORT = "Alter_Ult_Teleport_VoidEnter_1p"
const string SOUND_PORTAL_TRAVEL_3P_TRANSPORT = "Alter_Ult_Teleport_VoidEnter_3p"
      

#if SERVER
const asset TILE_MODEL =  $"mdl/props/mahjong_tile_01/mahjong_tile_01.rmdl"
#endif

global const string PHASETUNNEL_BLOCKER_SCRIPTNAME = "phase_tunnel_blocker"
global const string PHASETUNNEL_PRE_BLOCKER_SCRIPTNAME = "pre_phase_tunnel_blocker"
const string PHASETUNNEL_MOVER_SCRIPTNAME = "phase_tunnel_mover"

const float FRAME_TIME = 0.1

const asset PHASE_TUNNEL_3P_FX = $"P_ps_gauntlet_arm_3P"
const asset PHASE_TUNNEL_PREPLACE_FX = $"P_phasegate_pre_portal"
const asset PHASE_TUNNEL_FX = $"P_phasegate_portal"
const asset PHASE_TUNNEL_CROUCH_FX = $"P_phasegate_portal_rnd"
const asset PHASE_TUNNEL_ABILITY_ACTIVE_FX = $"P_phase_dash_start"
const asset PHASE_TUNNEL_1P_FX = $"P_phase_tunnel_player"

const float PHASE_TUNNEL_WEAPON_DRAW_DELAY = 0.75

global const float PHASE_TUNNEL_TRIGGER_RADIUS = 16.0
global const float PHASE_TUNNEL_TRIGGER_HEIGHT = 32.0
global const float PHASE_TUNNEL_TRIGGER_HEIGHT_CROUCH = 16.0
const float PHASE_TUNNEL_TRIGGER_RADIUS_PROJECTILE = 42.0
const float PHASE_TUNNEL_TRIGGER_RADIUS_PROJECTILE_CROUCH = 24.0

//PHASE TUNNEL PLACEMENT VARS
const float PHASE_TUNNEL_PLACEMENT_HEIGHT_STANDING = 45.0
const float PHASE_TUNNEL_PLACEMENT_HEIGHT_CROUCHING = 20

//PHASE TUNNEL TELEPORT TIME VARS
const float PHASE_TUNNEL_LIFETIME = 45.0 //todo: Replace original tuning post s15
const float PHASE_TUNNEL_MAX_DISTANCE = 6000.0
const float PHASE_TUNNEL_LONG_DISTANCE = 3000.0
const float PHASE_TUNNEL_SPEED_INCREMENT_AMOUNT = 0.1
const float PHASE_TUNNEL_SPEED_INCREMENT_PERCENT = 20
const float PHASE_TUNNEL_VALIDITY_TEST_TIME = 0.25
const float PHASE_TUNNEL_TELEPORT_TRAVEL_TIME_MIN = 0.3
const float PHASE_TUNNEL_TELEPORT_TRAVEL_TIME_LONG = 2.0
const float PHASE_TUNNEL_TELEPORT_TRAVEL_TIME_MAX = 3.5
const float PHASE_TUNNEL_TELEPORT_DBOUNCE = 0.5
const float PHASE_TUNNEL_TELEPORT_DBOUNCE_PROJECTILE = 1.0
const float PHASE_TUNNEL_USE_COOLDOWN_TIME = 0.25

const float PHASE_TUNNEL_MIN_PORTAL_DIST_SQR = 128.0 * 128.0
const float PHASE_TUNNEL_MIN_GEO_REVERSE_DIST = 48.0

const bool PHASE_TUNNEL_DEBUG_DRAW_PROJECTILE_TELEPORT = false
const bool PHASE_TUNNEL_DEBUG_DRAW_CREATE_TUNNEL = false
const bool PHASE_TUNNEL_DEBUG_DRAW_PLAYER_TRAVEL = false

const bool PHASE_TUNNEL_SPEED_INCREMENT_DEBUG = false
global struct PhaseTunnelPathNodeData
{
	vector origin
	vector angles
	vector velocity
	bool   wasInContextAction
	bool   wasCrouched
	bool   validExit
	float  time
}

global struct PhaseTunnelPathEndData
{
	PhaseTunnelPathNodeData nodeData
	vector safeRelativeOrigin
}

global struct PhaseTunnelTravelState
{
	bool                                                      completed
	bool                                                      thirdPersonShoulderModeWasOn
	bool                                                      holsterWeapons = true
	float                                                     holsterRemoveDelay
	float                                                     controlRestoreDelay
	int                                                       shiftStyle
	bool                                                      doEndSeekCheck = true
	int functionref( entity, array<PhaseTunnelPathNodeData>, int, int ) endSeekCheckOverrideFunc
	bool							  ignoreStuckCrouchCheck = false
}

global struct PhaseTunnelPathData
{
	float                            pathDistance = 0
	float                            pathTime = 0
	array< PhaseTunnelPathNodeData > pathNodes

	array< int >					 frameSteps
	float							 phaseTime
}

global struct PhaseTunnelPortalData
{
	vector               startOrigin
	vector               startAngles
	entity               portalFX
	vector               endOrigin
	vector               endAngles
	bool                 crouchPortal
	PhaseTunnelPathData& pathData
}

#if SERVER
enum eTunnelExpirationType
{
	LIFE_TIME_END = 0,
	INVALID_START_POS,
	INVALID_END_POS,
	INVALID_TUNNEL
}
#endif

global struct PhaseTunnelData
{
	int 					   shiftStyle
	entity                     tunnelEnt
	int                        activeUsers = 0
	array< entity >            entUsers
	table< entity, float >     entPhaseTime
	PhaseTunnelPortalData&     startPortal
	PhaseTunnelPortalData&     endPortal
	bool                       expired

	#if SERVER
		int expirationType

		                    
			array<entity> shieldedPlayers
        
	#endif
}

struct
{
	float maxPlacementDist
	float travelTimeMin
	float travelTimeMax
	float travelSpeed

	#if SERVER
		table < entity, PhaseTunnelData >       tunnelData
		table< entity, PhaseTunnelPortalData >  triggerStartpoint
		table< entity, PhaseTunnelPortalData >  triggerEndpoint
		table< entity, PhaseTunnelPortalData >  vortexStartpoint
		table< entity, PhaseTunnelPortalData >  vortexEndpoint
		array<entity>                           allTunnelEnts
		table<entity, bool>                     playerToHolsterState
		table< entity, bool > 					hasLockedWeaponsAndMelee
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
		RegisterSignal( "PhaseTunnel_ReturnWeaponsToPlayerAfterDelay" )
		RegisterSignal( "PhaseTunnel_CancelPlacement" )
		RegisterSignal( "PhaseTunnel_EndPlacement" )
		RegisterSignal( "PhaseTunnel_PathFollowCrouchPlayer" )
		RegisterSignal( "PhaseTunnel_DestroyPlacement" )
		RegisterSignal( "PhaseTunnel_CancelPhaseTunnelUse" )
		RegisterSignal( "PhaseTunnel_PhaseTunnelEntered" )
		RegisterSignal( "PhaseTunnel_DestroyTunnel" )

		Bleedout_AddCallback_OnPlayerStartBleedout( PhaseTunnel_OnPlayerStartBleedout )
		// AddCallback_OnPlayerPositionReset( OnPlayerPositionReset )
	#endif //SERVER

	#if CLIENT
		RegisterSignal( "EndTunnelVisual" )

		AddCreateCallback( "prop_script", PhaseTunnel_OnPropScriptCreated )
		StatusEffect_RegisterEnabledCallback( eStatusEffect.placing_phase_tunnel, PhaseTunnel_OnBeginPlacement )
		StatusEffect_RegisterDisabledCallback( eStatusEffect.placing_phase_tunnel, PhaseTunnel_OnEndPlacement )

		StatusEffect_RegisterEnabledCallback( eStatusEffect.phase_tunnel_visual, TunnelVisualsEnabled )
		StatusEffect_RegisterDisabledCallback( eStatusEffect.phase_tunnel_visual, TunnelVisualsDisabled )

		AddCreateCallback( PLAYER_WAYPOINT_CLASSNAME, PlayerWaypoint_CreateCallback )
	#endif

	//const float file.maxPlacementDist = 4098.0
	//const float PHASE_TUNNEL_TELEPORT_TRAVEL_TIME_MIN = 0.3
	//const float PHASE_TUNNEL_TELEPORT_TRAVEL_TIME_MAX = 2.0
	file.maxPlacementDist = GetCurrentPlaylistVarFloat( "wraith_portal_max_distance", PHASE_TUNNEL_MAX_DISTANCE )
	//file.travelTimeMin    = GetCurrentPlaylistVarFloat( "wraith_portal_min_travel_time", 0.2 )
	//file.travelTimeMax    = GetCurrentPlaylistVarFloat( "wraith_portal_max_travel_time", 4.0 )
	file.travelSpeed      = GetCurrentPlaylistVarFloat( "wraith_portal_max_travel_speed", 1024.0 )
}

#if SERVER
void function OnPlayerPositionReset( entity player )
{
	player.Signal( "PhaseTunnel_CancelPhaseTunnelUse" )
}
#endif

void function OnWeaponActivate_weapon_phase_tunnel( entity weapon )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	Assert( ownerPlayer.IsPlayer() )

	float raise_time = weapon.GetWeaponSettingFloat( eWeaponVar.raise_time )

	#if SERVER
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
	entity ownerPlayer = weapon.GetWeaponOwner()
	if ( !IsValid(ownerPlayer) )
		return false

	// Need this here because we shouldnt be able to start the phase tunnel when in phase.
	// While the weapon code prevents us from switching to this weapon in phase,
	// this check passes and we start Phase Tunnel as soon as we exit phase without this.
	// R5DEV-446068
	if( ownerPlayer.IsPhaseShifted() )
		return false

	return true
}


bool function OnWeaponChargeBegin_weapon_phase_tunnel( entity weapon )
{
	entity player   = weapon.GetWeaponOwner()
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
				// Defensive fix for R5DEV-70839
				if ( StatusEffect_GetSeverity( player, eStatusEffect.placing_phase_tunnel ) )
					return false

				// Defensive fix for R5DEV-70839
				array mods = player.GetExtraWeaponMods()
				if ( mods.contains( "ult_active" ) )
					return false

				entity f = StartParticleEffectOnEntity_ReturnEntity( player, GetParticleSystemIndex( PHASE_TUNNEL_3P_FX ), FX_PATTACH_POINT_FOLLOW, attachIndex )
				f.SetOwner( player )
				SetTeam( f, player.GetTeam() )
				f.kv.VisibilityFlags = ENTITY_VISIBLE_TO_ENEMY | ENTITY_VISIBLE_TO_FRIENDLY
				weapon.w.fxHandles.append( f )

				float fade = 0.125
				thread PhaseTunnel_StartAbility( player, shiftTime + fade, weapon )
			#elseif CLIENT
				AddPlayerHint( PHASE_TUNNEL_PLACEMENT_DURATION, 0, $"", "#WPN_PHASE_TUNNEL_PLAYER_DEPLOY_STOP_HINT" )
				HidePlayerHint( "#WPN_PHASE_TUNNEL_PLAYER_DEPLOY_START_HINT" )
			#endif
		}
		//PhaseShift( player, 0, shiftTime, PHASETYPE_BALANCE, true )
	}
	return true
}


void function OnWeaponChargeEnd_weapon_phase_tunnel( entity weapon )
{
	entity player = weapon.GetWeaponOwner()

	//printt( "ENDING CHARGE!!!" )

	#if CLIENT
		HidePlayerHint( "#WPN_PHASE_TUNNEL_PLAYER_DEPLOY_STOP_HINT" )
	#endif //CLIENT

	#if SERVER
		foreach ( fx in weapon.w.fxHandles )
		{
			EffectStop( fx )
		}
		weapon.w.fxHandles.clear()
		if ( player in file.hasLockedWeaponsAndMelee && file.hasLockedWeaponsAndMelee[player]  )
		{
			if ( IsValid(player) )
				UnlockWeaponsAndMelee( player )
			file.hasLockedWeaponsAndMelee[player] <- false
		}
	#endif
}


bool function PhaseTunnel_CanUseZipline( entity player, entity zipline, vector ziplineClosestPoint )
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

var function OnWeaponNPCPrimaryAttack_ability_phase_tunnel( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return OnWeaponPrimaryAttack_ability_phase_tunnel( weapon, attackParams )
}

void function PhaseTunnel_OnPlayerStartBleedout( entity player, entity attacker, var damageInfo )
{
	player.Signal( "PhaseTunnel_CancelPlacement" )
}

// defensive fix for R5DEV-575688
// this becomes an issue if extra player weapon mods seep into the main weapon,
// which can happen if we grab ALL the mods affecting the weapon (including player extra mods) and set it on the weapon
// this causes the mods to persist after we remove the player extra mods, which can break things with mods being applied on top of each other when we don't expect
// its impossible to make sure other script doesn't bleed the mods onto the main weapon, so just do a sanity check here everytime we modify the mods on the tac
// to make sure it doesn't have any mods that have bled over at some point
void function PhaseTunnel_SanitizeWeaponMods( entity weapon )
{
	if( !IsValid( weapon ) )
		return
	array<string> mods = weapon.GetMods()
	if( mods.contains( "ult_active" ) )
	{
		weapon.RemoveMod( "ult_active" )
	}
}

void function PhaseTunnel_StartAbility( entity player, float duration, entity weapon )
{
	Assert( IsNewThread(), "Must be threaded off." )
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "PhaseTunnel_CancelPlacement" )
	player.EndSignal( "BleedOut_OnStartDying" )
	player.EndSignal( "CleanUpPlayerAbilities" )
	weapon.EndSignal( "OnDestroy" )
	EndThreadOn_PlayerChangedClass( player )

	Embark_Disallow( player )

	array mods = player.GetExtraWeaponMods()
	// Defensive fix for R5DEV-70839
	if ( !(mods.contains( "ult_active" ) ) )
	{
		PhaseTunnel_SanitizeWeaponMods( weapon )
		mods.append( "ult_active" )
	}

	player.SetExtraWeaponMods( mods )
	ForceAutoSprintOn( player )
	LockWeaponsAndMelee( player )
	file.hasLockedWeaponsAndMelee[player] <- true

	array<int> ids
	ids.append( StatusEffect_AddEndless( player, eStatusEffect.speed_boost, 0.2 ) )
	ids.append( StatusEffect_AddEndless( player, eStatusEffect.phase_tunnel_visual, 1.0 ) )

	entity fx = PlayPhaseShiftDisappearFX( player, PHASE_TUNNEL_ABILITY_ACTIVE_FX )

	//AddButtonPressedPlayerInputCallback( player, IN_ZOOM_TOGGLE, PhaseTunnel_CancelPlacement )
	//AddButtonPressedPlayerInputCallback( player, IN_ZOOM, PhaseTunnel_CancelPlacement )

	EmitSoundOnEntityOnlyToPlayer( player, player, SOUND_SUCCESS_1P )
	EmitSoundOnEntityExceptToPlayer( player, player, SOUND_SUCCESS_3P )


	OnThreadEnd(
		function() : ( player, ids, fx, weapon )
		{
			if ( IsValid( player ) )
			{
				Embark_Allow( player )

				ChargeTactical_ForceEnd( player )
				if ( player.IsPhaseShifted() )
					CancelPhaseShift( player )
				array mods = player.GetExtraWeaponMods()
				mods.fastremovebyvalue( "ult_active" )

				player.SetExtraWeaponMods( mods )

				ForceAutoSprintOff( player )

				if ( player in file.hasLockedWeaponsAndMelee && file.hasLockedWeaponsAndMelee[player]  )
				{
					UnlockWeaponsAndMelee( player )
					file.hasLockedWeaponsAndMelee[player] <- false
				}
				//RemoveButtonPressedPlayerInputCallback( player, IN_ZOOM_TOGGLE, PhaseTunnel_CancelPlacement )
				//RemoveButtonPressedPlayerInputCallback( player, IN_ZOOM, PhaseTunnel_CancelPlacement )

				foreach ( id in ids )
					StatusEffect_Stop( player, id )

				if ( IsValid( fx ) )
				{
					//StopFX( fx )
					fx.Destroy()
				}

				//If the player is bleeding out when the ability ended, take their ammo as if they used the ability.
				if ( IsValid( weapon ) && Bleedout_IsBleedingOut( player ) )
					weapon.SetWeaponPrimaryClipCount( 0 )
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
	waitthread PhaseTunnel_InteruptablePlacementWaitDistance( player, GetMaxDistForPlayer( player ) )

	//printt( "STARTING PATH LEN: " + startPath.len() )
	//printt( "ENDING PATH LEN: " + endPath.len() )
	//If the player didn't create a real path.

	//If the player doesn't place a valid path, refund the cost of the ability.
	if ( startPath.pathNodes.len() == 0 || endPath.pathNodes.len() == 0 )
	{
		weapon.SetWeaponPrimaryClipCount( weapon.GetWeaponPrimaryClipCountMax() )
		return
	}

	//If the player didn't move far enough, refund the cost of the ability.
	if ( startPath.pathDistance <= 128.0 || endPath.pathDistance <= 128.0 )
	{
		weapon.SetWeaponPrimaryClipCount( weapon.GetWeaponPrimaryClipCountMax() )
		return
	}

	PhaseTunnelPortalData startPortal = PhaseTunnel_CreatePortalData( startPath )
	startPortal.portalFX.RemoveFromAllRealms()
	startPortal.portalFX.AddToOtherEntitysRealms( player )
	PhaseTunnelPortalData endPortal = PhaseTunnel_CreatePortalData( endPath )
	endPortal.portalFX.RemoveFromAllRealms()
	endPortal.portalFX.AddToOtherEntitysRealms( player )

	PIN_PlayerAbility( player, weapon.GetWeaponClassName(), ABILITY_TYPE.ULTIMATE, null, {tunnel_start = startPortal.startOrigin, tunnel_end = endPortal.startOrigin} )

	PhaseTunnelData tunnelData
	tunnelData.startPortal = startPortal
	tunnelData.endPortal   = endPortal
	tunnelData.shiftStyle  = eShiftStyle.Tunnel

	thread PhaseTunnel_OpenTunnel( tunnelData, player )
}

PhaseTunnelPortalData function PhaseTunnel_CreatePortalData( PhaseTunnelPathData pathData )
{
	int pathLength                        = pathData.pathNodes.len()
	PhaseTunnelPathNodeData startingPoint = pathData.pathNodes[ pathLength - 1 ]
	PhaseTunnelPathNodeData endingPoint   = pathData.pathNodes[ 0 ]

	float zOffset  = startingPoint.wasCrouched ? PHASE_TUNNEL_PLACEMENT_HEIGHT_CROUCHING : PHASE_TUNNEL_PLACEMENT_HEIGHT_STANDING
	asset portalFX = startingPoint.wasCrouched ? PHASE_TUNNEL_CROUCH_FX : PHASE_TUNNEL_FX

	int fxid = GetParticleSystemIndex( portalFX )
	PhaseTunnelPortalData portalData
	portalData.startOrigin  = startingPoint.origin
	portalData.startAngles  = startingPoint.angles
	portalData.endOrigin    = endingPoint.origin
	portalData.endAngles    = endingPoint.angles
	portalData.crouchPortal = startingPoint.wasCrouched
	portalData.portalFX     = StartParticleEffectInWorld_ReturnEntity( fxid, startingPoint.origin + (<0, 0, 1> * zOffset), startingPoint.angles + <0, 90, 90> )

	//TO DO: READ START AND END POSITION OUT OF THE PATH DATA.
	portalData.pathData = pathData

	return portalData
}

/*
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
*/

void function PhaseTunnel_InteruptablePlacementWaitDistance( entity player, float distance )
{
	Assert( IsNewThread(), "Must be threaded off." )
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDeath" )
	player.EndSignal( "PhaseTunnel_EndPlacement" )
	player.EndSignal( "PhaseTunnel_CancelPlacement" )
	EndThreadOn_PlayerChangedClass( player )

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
	vector lastOrigin = FlattenVec( player.GetOrigin() )
	while ( true )
	{
		vector origin = FlattenVec( player.GetOrigin() )
		totalDist += (Length( lastOrigin - origin ))
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
	int team         = player.GetTeam()
	entity tunnelEnt = CreatePropScript( $"mdl/dev/empty_model.rmdl", tunnelData.startPortal.startOrigin )
	tunnelEnt.RemoveFromAllRealms()
	tunnelEnt.AddToOtherEntitysRealms( player )
	tunnelEnt.DisableHibernation()
	SetTeam( tunnelEnt, team )
	tunnelEnt.SetOwner( player )

	ArrayRemoveInvalid( file.allTunnelEnts )
	file.allTunnelEnts.append( tunnelEnt )

	entity tunnelWeapon = player.GetOffhandWeapon( OFFHAND_INVENTORY )
	Assert ( tunnelWeapon.GetWeaponClassName() == "mp_weapon_phase_tunnel", "Trying to end sustained discharge on a diffrent weapon than we started with." )

	// Defensive fix for R5DEV-70839
	tunnelWeapon.SetWeaponPrimaryClipCount( 0 )

	entity wpStart = CreateWaypoint_Ping_Location( player, ePingType.ABILITY_WORMHOLE, tunnelData.startPortal.portalFX, tunnelData.startPortal.startOrigin, -1, true )
	wpStart.SetAbsOrigin( tunnelData.startPortal.startOrigin + <0, 0, 45> )

	entity wpEnd = CreateWaypoint_Ping_Location( player, ePingType.ABILITY_WORMHOLE, tunnelData.endPortal.portalFX, tunnelData.endPortal.startOrigin, -1, true )
	wpEnd.SetAbsOrigin( tunnelData.endPortal.startOrigin + <0, 0, 45> )

	// VoidVisionSetExitEnt( tunnelData.startPortal.pathData, tunnelData.endPortal.portalFX )
	// VoidVisionSetExitEnt( tunnelData.endPortal.pathData, tunnelData.startPortal.portalFX )
       

	tunnelData.tunnelEnt = tunnelEnt

	table < entity, float > playerPhaseTime
	playerPhaseTime[ player ] <- Time() + PHASE_TUNNEL_TELEPORT_DBOUNCE

	tunnelData.entPhaseTime = playerPhaseTime
	file.tunnelData[ tunnelEnt ] <- tunnelData

	OnThreadEnd(
		function() : ( tunnelEnt, tunnelData, wpStart, wpEnd )
		{
			tunnelData.startPortal.portalFX.Destroy()
			tunnelData.endPortal.portalFX.Destroy()

			if ( IsValid( tunnelEnt ) )
			{
				delete file.tunnelData[ tunnelEnt ]
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

	bool DEBUG_DRAW_PHASE_TUNNEL_WAIT = false
	waitthread PhaseTunnel_WaitForPhaseTunnelExpiration( player, tunnelData, PHASE_TUNNEL_LIFETIME, DEBUG_DRAW_PHASE_TUNNEL_WAIT )
}

#if DEVELOPER
void function DEV_PhaseTunnel_DestroyAll()
{
	foreach ( ent, portal in file.tunnelData )
	{
		Signal( portal.tunnelEnt, "PhaseTunnel_DestroyTunnel" )
	}
}
#endif

void function PhaseTunnel_WaitForPhaseTunnelExpiration( entity player, PhaseTunnelData tunnelData, float lifetime, bool DEBUG_DRAW = false )
{
	tunnelData.expirationType = eTunnelExpirationType.LIFE_TIME_END
	vector startPos = tunnelData.startPortal.startOrigin
	vector endPos = tunnelData.endPortal.startOrigin // vector endPos = (tunnelData.shiftStyle == PHASETYPE_BREACH) ? tunnelData.startPortal.endOrigin : tunnelData.endPortal.startOrigin

	if ( IsValid( tunnelData.tunnelEnt ) )
	{
		tunnelData.tunnelEnt.EndSignal( "PhaseTunnel_DestroyTunnel" )
		tunnelData.tunnelEnt.EndSignal( "OnDestroy" )

		player.EndSignal( "CleanUpPlayerAbilities" )
		player.EndSignal( "PhaseTunnel_DestroyPlacement" )

		EndThreadOn_PlayerChangedClass( player )
	}

	float endTime = Time() + lifetime
	while( Time() < endTime )
	{
		if ( !IsValid( player ) || !IsAlive( player ) )
		{
			float remainingTime = endTime - Time()
			wait remainingTime
			break
		}

		bool validStart = PhaseTunnel_IsPortalExitPointValid( player, startPos, player, true, tunnelData.startPortal.crouchPortal, DEBUG_DRAW )
		bool validEnd   = PhaseTunnel_IsPortalExitPointValid( player, endPos, player, true, tunnelData.endPortal.crouchPortal, DEBUG_DRAW )

		if ( !validStart )
		{
			if ( validEnd )
			{
				tunnelData.expirationType = eTunnelExpirationType.INVALID_START_POS
				break
			}
			else
			{
				tunnelData.expirationType = eTunnelExpirationType.INVALID_TUNNEL
				break
			}
		}
		else if ( !validEnd )
		{
			tunnelData.expirationType = eTunnelExpirationType.INVALID_END_POS
			break
		}

		float waitTime = PHASE_TUNNEL_VALIDITY_TEST_TIME
		float timeLeft = endTime - Time()
		if ( waitTime > timeLeft )
			waitTime = timeLeft

		wait waitTime
	}

	tunnelData.expired = true
	ArrayRemoveInvalid( tunnelData.entUsers )

	if ( tunnelData.expirationType == eTunnelExpirationType.LIFE_TIME_END )
	{
		//Don't close the tunnel while there are users in transit.
		while ( tunnelData.activeUsers > 0 )
			WaitFrame()
	}
	else
	{
		foreach ( entity user in tunnelData.entUsers )
		{
			if ( PhaseTunnel_IsPortalExitPointValid( user, user.GetOrigin(), user, true, false, DEBUG_DRAW ) )
			{
				PutPlayerInSafeSpot( user, null, null, user.GetOrigin(), user.GetOrigin() )
			}
			else if ( tunnelData.expirationType == eTunnelExpirationType.INVALID_START_POS )
			{
				PutPlayerInSafeSpot( user, null, null, endPos, user.GetOrigin() )
			}
			else if ( tunnelData.expirationType == eTunnelExpirationType.INVALID_END_POS )
			{
				PutPlayerInSafeSpot( user, null, null, startPos, user.GetOrigin() )
			}
			else
			{
				vector closestAirDrop = GetClosestAirdropPoint( user.GetOrigin() ).origin
				PutPlayerInSafeSpot( user, null, null, closestAirDrop, closestAirDrop )
			}
		}
	}
}

void function PhaseTunnel_CreateTriggerArea( entity tunnelEnt, PhaseTunnelPortalData startPointData, PhaseTunnelPortalData endPointData )
{
	Assert ( IsNewThread(), "Must be threaded off" )
	tunnelEnt.EndSignal( "OnDestroy" )
	endPointData.portalFX.EndSignal( "OnDestroy" )

	vector origin       = endPointData.portalFX.GetOrigin()
	vector angles       = endPointData.portalFX.GetAngles()
	float triggerHeight = endPointData.crouchPortal ? PHASE_TUNNEL_TRIGGER_HEIGHT_CROUCH : PHASE_TUNNEL_TRIGGER_HEIGHT
	float vortexRadius  = endPointData.crouchPortal ? PHASE_TUNNEL_TRIGGER_RADIUS_PROJECTILE_CROUCH : PHASE_TUNNEL_TRIGGER_RADIUS_PROJECTILE

	entity trigger = CreateEntity( "trigger_cylinder" )
	trigger.RemoveFromAllRealms()
	trigger.AddToOtherEntitysRealms( tunnelEnt )
	trigger.SetOwner( tunnelEnt )
	trigger.SetRadius( PHASE_TUNNEL_TRIGGER_RADIUS )
	trigger.SetAboveHeight( triggerHeight )
	trigger.SetBelowHeight( triggerHeight )
	trigger.SetOrigin( origin )
	trigger.SetAngles( <0, 0, 0> )

	// if ( GameModeVariant_IsActive( eGameModeVariants.SURVIVAL_FIRING_RANGE ) && IsT1Active() )
		// trigger.kv.triggerFilterNonCharacter = "1"
	// else
		trigger.kv.triggerFilterNonCharacter = "0"

	trigger.kv.triggerFilterPhaseShift   = "nonphaseshift"
	DispatchSpawn( trigger )

	file.triggerStartpoint[ trigger ]    <- startPointData
	file.triggerEndpoint[ trigger ]    <- endPointData
	trigger.SetEnterCallback( OnPhaseTunnelTriggerEnter )

	trigger.SetOrigin( origin )
	trigger.SetAngles( <0, 0, 0> )

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

	entity portalMarker = CreatePropScript( $"mdl/dev/empty_model.rmdl", origin, angles + <0, -90, -90> )
	portalMarker.SetScriptName( "portal_marker" )
	portalMarker.DisableHibernation()
	portalMarker.RemoveFromAllRealms()
	portalMarker.AddToOtherEntitysRealms( tunnelEnt )

	entity traceBlocker = CreateTraceBlockerVolume( origin, 24.0, false, CONTENTS_BLOCK_PING, tunnelEnt.GetTeam(), PHASETUNNEL_BLOCKER_SCRIPTNAME )
	traceBlocker.RemoveFromAllRealms()
	traceBlocker.AddToOtherEntitysRealms( tunnelEnt )
	traceBlocker.SetTouchTriggers( true )
	traceBlocker.SetOwner( tunnelEnt )

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
				EmitSoundAtPosition( TEAM_UNASSIGNED, portalMarker.GetOrigin(), SOUND_PORTAL_CLOSE, trigger )
				portalMarker.Destroy()
			}

			if ( IsValid( traceBlocker ) )
				traceBlocker.Destroy()
		} )

	vector surfaceNormal = AnglesToUp( trigger.GetAngles() )

	if ( PHASE_TUNNEL_DEBUG_DRAW_PROJECTILE_TELEPORT )
	{
		DebugDrawLine( startPointData.portalFX.GetOrigin(), startPointData.portalFX.GetOrigin() + (startPointData.portalFX.GetUpVector() * 64), COLOR_RED, true, 30.0 ) //Grenade Entry Vel
	}

	WaitForever()
}

void function OnPhaseTunnelTriggerEnter( entity trigger, entity ent )
{
	if ( PhaseTunnel_ShouldPhaseEnt( ent ) )
		thread OnPhaseTunnelTriggerEnter_Internal( trigger, ent )
}

void function OnPhaseTunnelTriggerEnter_Internal( entity trigger, entity ent )
{
	entity tunnelEnt = trigger.GetOwner()

	ent.EndSignal( "OnDestroy", "OnDeath" )

	if ( !(trigger in file.triggerEndpoint ) )
		return

	PhaseTunnelPortalData portalData = file.triggerEndpoint[ trigger ]

	// if ( IsVoidVisionEnabled_PhaseTunnel() )
	// {
		// VoidVision_GrantVoidVision( ent )

		// OnThreadEnd(
			// function() : ( ent )
			// {
				// VoidVision_TakeVoidVision( ent )
			// } )
	// }

	PhaseTunnelTravelState travelState
	travelState.shiftStyle = eShiftStyle.Tunnel

	//todo-iholstead: remove me once R5DEV-578675 is closed
	printf("OnPhaseTunnelTriggerEnter_Internal called on "+ ent )

	waitthread PhaseTunnel_PhaseEntity( ent, tunnelEnt, file.tunnelData[ tunnelEnt ], portalData, travelState )
}

void function PhaseTunnel_OnBulletHitVortexTrigger( entity weapon, entity vortexSphere, var damageInfo )
{
	//printt( "BULLET HIT VORTEX TRIGGER" )
	return
}

void function PhaseTunnel_OnProjectileHitVortexTrigger( entity weapon, entity vortexSphere, entity attacker, entity projectile, vector contactPos )
{
	//printt( "PROJECTILE HIT VORTEX TRIGGER" )
	entity tunnelEnt                      = vortexSphere.GetOwner()
	PhaseTunnelPortalData startPortalData = file.vortexStartpoint[ vortexSphere ]
	PhaseTunnelPortalData endPortalData   = file.vortexEndpoint[ vortexSphere ]

	if ( !IsValid( tunnelEnt ) )
		return

	//Only teleport the projectiles we specify.
	if ( !PhaseTunnel_ShouldPhaseProjectile( projectile ) )
		return

	//Don't phase planted projectiles
	if ( projectile.proj.isPlanted )
		return

	vector velNorm         = Normalize( projectile.GetVelocity() )
	vector endPortalAngles = VectorToAngles( endPortalData.portalFX.GetUpVector() )

	vector relativeAngles = CalcRelativeAngles( endPortalAngles, -startPortalData.portalFX.GetUpVector() )
	vector newDir         = RotateVector( velNorm, relativeAngles )

	//printt( "RELATIVE ANGLES: " + relativeAngles )

	//if we are going from a crouching portal to a standing portal or vice versa scale the projectile's z height offset accordingly
	float heightScalar = 1.0
	if ( endPortalData.crouchPortal && !startPortalData.crouchPortal )
		heightScalar = PHASE_TUNNEL_TRIGGER_RADIUS_PROJECTILE / PHASE_TUNNEL_TRIGGER_RADIUS_PROJECTILE_CROUCH
	else if ( !endPortalData.crouchPortal && startPortalData.crouchPortal )
		heightScalar = PHASE_TUNNEL_TRIGGER_RADIUS_PROJECTILE_CROUCH / PHASE_TUNNEL_TRIGGER_RADIUS_PROJECTILE

	vector endFXOrigin = startPortalData.portalFX.GetOrigin()
	vector impactPoint = PhaseTunnel_GetPointOnRectangularPlane( endPortalData.portalFX.GetOrigin(), endPortalData.portalFX.GetUpVector(), endPortalData.portalFX.GetRightVector(), 198, 128, contactPos )
	vector relOffset   = (impactPoint - endPortalData.portalFX.GetOrigin())
	relOffset.z *= heightScalar
	vector exitPoint = RotateVector( relOffset, relativeAngles )

	//printt( "RELATIVE POINT: " + exitPoint )

	projectile.proj.lastTeleportTime = Time()
	projectile.SetOrigin( endFXOrigin + exitPoint )
	projectile.SetVelocity( newDir * Length( projectile.GetVelocity() ) )

	//printt( "TELEPORTING PROJECTILE" )

	if ( PHASE_TUNNEL_DEBUG_DRAW_PROJECTILE_TELEPORT )
	{
		DebugDrawLine( contactPos, contactPos + (velNorm * 64), COLOR_RED, true, 30.0 ) //Grenade Entry Vel
		DebugDrawLine( startPortalData.portalFX.GetOrigin(), startPortalData.portalFX.GetOrigin() + (startPortalData.portalFX.GetUpVector() * 64), COLOR_GREEN, true, 30.0 ) //Grenade Entry Vel

		DebugDrawLine( endPortalData.portalFX.GetOrigin(), impactPoint, COLOR_CYAN, true, 30.0 ) //Grenade Entry Vel
		DebugDrawLine( endFXOrigin, endFXOrigin + exitPoint, COLOR_MAGENTA, true, 30.0 ) //Grenade Entry Vel

		DebugDrawLine( contactPos, endFXOrigin + exitPoint, COLOR_YELLOW, true, 30.0 ) //Grenade Entry Vel

		DebugDrawLine( endFXOrigin, endFXOrigin + (endPortalData.portalFX.GetUpVector() * 64), COLOR_GREEN, true, 30.0 ) //Grenade Entry Vel
		DebugDrawLine( endFXOrigin + exitPoint, (endFXOrigin + exitPoint) + (velNorm * 64), COLOR_RED, true, 30.0 ) //Grenade Entry Vel
		DebugDrawLine( endFXOrigin + exitPoint, (endFXOrigin + exitPoint) + (newDir * 128), COLOR_BLUE, true, 30.0 ) //Grenade Entry Vel
	}
}

vector function PhaseTunnel_GetPointOnRectangularPlane( vector origin, vector planeNormal, vector planeUp, float height, float width, vector testPoint )
{
	float halfHeight   = height / 2
	float halfWidth    = width / 2
	vector planeRight  = CrossProduct( planeNormal, planeUp )
	//Get point on Tri A
	vector triAPointA  = origin + (planeUp * -halfHeight) + (planeRight * halfWidth)  //mainTrapData.trap.GetOrigin() + ( mainTrapData.trap.GetUpVector() * TESLA_TRAP_LINK_HEIGHT )
	vector triAPointB  = origin + (planeUp * halfHeight) + (planeRight * halfWidth)
	vector triAPointC  = origin + (planeUp * halfHeight) + (planeRight * -halfWidth)//otherTrapData.trap.GetOrigin() + ( otherTrapData.trap.GetUpVector() * TESLA_TRAP_LINK_HEIGHT )
	vector pointOnTriA = GetClosestPointOnPlane( triAPointA, triAPointB, triAPointC, testPoint, true )

	//Get point on Tri B
	vector triBPointA  = origin + (planeUp * -halfHeight) + (planeRight * -halfWidth)//otherTrapData.trap.GetOrigin() + ( otherTrapData.trap.GetUpVector() * TESLA_TRAP_LINK_HEIGHT )
	vector triBPointB  = origin + (planeUp * halfHeight) + (planeRight * -halfWidth)//otherTrapData.trap.GetOrigin() + ( otherTrapData.trap.GetUpVector() * ( TESLA_TRAP_LINK_HEIGHT * TESLA_TRAP_LINK_FX_COUNT ) )
	vector triBPointC  = origin + (planeUp * -halfHeight) + (planeRight * halfWidth)//mainTrapData.trap.GetOrigin() + ( mainTrapData.trap.GetUpVector() * ( TESLA_TRAP_LINK_HEIGHT * TESLA_TRAP_LINK_FX_COUNT ) )
	vector pointOnTriB = GetClosestPointOnPlane( triBPointA, triBPointB, triBPointC, testPoint, true )

	if ( PHASE_TUNNEL_DEBUG_DRAW_PROJECTILE_TELEPORT )
	{
		DebugDrawLine( triAPointA, triAPointB, COLOR_RED, true, 20.0 )
		DebugDrawLine( triAPointB, triAPointC, COLOR_RED, true, 20.0 )
		DebugDrawLine( triAPointC, triAPointA, COLOR_RED, true, 20.0 )

		DebugDrawLine( triBPointA, triBPointB, COLOR_GREEN, true, 20.0 )
		DebugDrawLine( triBPointB, triBPointC, COLOR_GREEN, true, 20.0 )
		DebugDrawLine( triBPointC, triBPointA, COLOR_GREEN, true, 20.0 )
	}

	//Return the closer of the two points
	float distSqrA = DistanceSqr( testPoint, pointOnTriA )
	float distSqrB = DistanceSqr( testPoint, pointOnTriB )
	return distSqrA <= distSqrB ? pointOnTriA : pointOnTriB
}

void function PhaseTunnel_PhaseEntity( entity ent, entity tunnelEnt, PhaseTunnelData tunnelData, PhaseTunnelPortalData portalData, PhaseTunnelTravelState travelState )
{
	//todo-iholstead: remove me once R5DEV-578675 is closed
	printf("PhaseTunnel_PhaseEntity called on "+ ent + " for portal " + portalData.portalFX )

	Assert ( IsNewThread(), "Must be threaded off." )
	ent.EndSignal( "OnDeath" )
	ent.EndSignal( "OnDestroy" )
	ent.EndSignal( "PhaseTunnel_CancelPhaseTunnelUse" )
	tunnelEnt.EndSignal( "OnDestroy" )

	if ( tunnelData.expired )
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

	Signal( ent, "PhaseTunnel_PhaseTunnelEntered" )

	OnThreadEnd(
		function() : ( ent, tunnelData )
		{
			tunnelData.activeUsers--

			if ( IsValid( ent ) )
			{
				tunnelData.entUsers.fastremovebyvalue( ent )
				tunnelData.entPhaseTime[ ent ] = Time() + 1.0
			}
		} )

	tunnelData.activeUsers++
	tunnelData.entUsers.append( ent )

	if ( travelState.shiftStyle == eShiftStyle.Tunnel )
	{
		// LiveAPI_SendOnePlayerEvent( eLiveAPI_EventTypes.wraithPortal, ent )
		StatsHook_PhaseTunnel_EntTraversed( ent, tunnelEnt, entHasUsedTunnelBefore )
	}
	// else if ( travelState.shiftStyle == PHASETYPE_BREACH )
	// {
		// StatsHook_AshPlayersPortaled( tunnelEnt.GetOwner() )
	// }
	             
	// else if ( travelState.shiftStyle == PHASETYPE_TRANSPORT )
	// {
		// //TODO-iholstead
	// }
       

	waitthread PhaseTunnel_MoveEntAlongPath( ent, portalData.pathData, travelState )
}

void function PhaseTunnel_MoveEntAlongPath( entity player, PhaseTunnelPathData pathData, PhaseTunnelTravelState travelState )
{
	player.EndSignal( "OnDeath" )
	player.EndSignal( "PhaseTunnel_CancelPhaseTunnelUse" )
	player.EndSignal( "CleanUpPlayerAbilities" )

	entity mover = CreateScriptMover_NEW( PHASETUNNEL_MOVER_SCRIPTNAME, player.GetOrigin(), player.GetAngles() )

	PhaseTunnelPathEndData pathNodeData
	pathNodeData.nodeData.origin             = player.GetOrigin()
	pathNodeData.nodeData.angles             = player.GetAngles()
	pathNodeData.nodeData.wasInContextAction = player.ContextAction_IsActive()
	pathNodeData.nodeData.wasCrouched        = player.IsCrouched()
	pathNodeData.safeRelativeOrigin = player.GetOrigin()

	// Clean up mover. pathNodeData is like a persistent state that tracks with the player during the tunnel sequence. This applies some exit-portal-state stuff to the player when they leave portal.
	OnThreadEnd(
		function(): ( mover, player, pathNodeData, travelState )
		{
			vector mins = player.GetBoundingMins()
			vector maxs = player.GetBoundingMaxs()

			bool mightBeStuck = false

			if ( !pathNodeData.nodeData.wasCrouched )
			{
				if ( !travelState.ignoreStuckCrouchCheck )
				{
					TraceResults results = TraceHull( player.GetOrigin(), player.GetOrigin() + <0, 0, 1>, mins, maxs, GetPlayerArray_Alive(), TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_NONE )
					mightBeStuck = results.startSolid
					if ( mightBeStuck )
						printt( "mightBeStuck" )
				}
			}

			if ( IsValid( player ) )
			{
				if ( pathNodeData.nodeData.wasCrouched || mightBeStuck )
				{
					thread PhaseTunnel_PathFollowCrouchPlayer( player, pathNodeData.nodeData.wasInContextAction ? 0.2 : 0.0 )
				}
			}

			if ( !travelState.completed )
			{
				vector oldAngles = player.GetAngles()
				player.ClearParent()
				player.SetAbsAngles( oldAngles )	// Clearing the parent often leaves you at odd angles for incomplete phases
			}

			if ( pathNodeData.nodeData.wasInContextAction && !PutPlayerInSafeSpot( player, null, null, pathNodeData.safeRelativeOrigin, player.GetOrigin() ) )
				//Only do PutPlayerInSafeSpot check() if the last saved position they were in a context action, since context actions can put you in normally illegal spots, e.g. behind geo. If you do the PutPlayerInSafeSpot() check all the time you get false positives if you always use start position as safe starting spot
			{
				player.TakeDamage( player.GetHealth() + 1, player, player, { damageSourceId = eDamageSourceId.phase_shift, scriptType = DF_GIB | DF_BYPASS_SHIELD | DF_SKIPS_DOOMED_STATE } )
			}

			if ( IsValid( mover ) )
				mover.Destroy()

			PhaseTunnel_RevertEntStateAfterMovingAlongTunnel( player, travelState )
		}
	)

	thread PhaseTunnel_PrepareToMoveEntAlongTunnel( player, travelState )

	vector oldAngle = player.GetAngles()
	player.SetParent( mover, "REF", false )
	player.SetAbsAngles( oldAngle );

	// JFS: Not sure if this is also needed for what's below. Safe play: Leave it in.
	WaitEndFrame() // wait for the last save

	array< PhaseTunnelPathNodeData > pathNodeDataArray = pathData.pathNodes
	array< int > frameSteps                            = pathData.frameSteps

	if ( PHASE_TUNNEL_DEBUG_DRAW_PLAYER_TRAVEL )
	{
		const float PATH_DRAW_TIME = 15.0

		DebugDrawText( pathNodeDataArray[pathNodeDataArray.len()-1].origin + <0,0,10>, ("PathNodes: " + pathNodeDataArray.len()), false, PATH_DRAW_TIME )
		foreach ( PhaseTunnelPathNodeData nodeData in pathNodeDataArray )
		{
			vector color = COLOR_YELLOW
			if ( !nodeData.validExit )
			{
				color = COLOR_ORANGE
				DebugDrawText( nodeData.origin, "NOT validExit", false, PATH_DRAW_TIME )
			}
			DebugDrawCircle( nodeData.origin, <0, 0, 0>, 10, color, false, PATH_DRAW_TIME )
		}
		//DebugDrawScreenTextWithColor( 0.85, 0.5, "PATH NODES", COLOR_YELLOW )
	}

	PhaseShift( player, 0.0, pathData.phaseTime, travelState.shiftStyle )
	PIN_Interact( player, "wraith_portal", pathNodeDataArray[0].origin )

	                   
	// VoidVisionStartPhaseShiftPathData( player, pathData )
       


	int prevPathIndex    = -1
	int currentPathIndex = pathNodeDataArray.len() - 1
	vector prevPosition  = player.GetOrigin()
	int stopPathIndex    = 0
	for ( int i = 0; i < frameSteps.len(); i++ )
	{
		int step = frameSteps[i]

		if ( currentPathIndex < 0 )
			break

		int nextIndex       = currentPathIndex - step
		vector anglesToUse  = GetNextAngleToLookAt( currentPathIndex, step, pathNodeDataArray ) // nextIndex < 0 ? pathNodeDataArray[currentPathIndex].angles : VectorToAngles( pathNodeDataArray[nextIndex].origin - pathNodeDataArray[currentPathIndex].origin )

		if ( PHASE_TUNNEL_DEBUG_DRAW_PLAYER_TRAVEL )
		{
			const float DRAW_TIME = 10.0
			DebugDrawLine( prevPosition, player.GetOrigin(), COLOR_GREEN, false, DRAW_TIME ) //Prev Player Position to current Pos
			prevPosition = player.GetOrigin()
			// if ( prevPathIndex != currentPathIndex )
				// DebugDrawSphere( pathNodeDataArray[currentPathIndex].origin, 6, COLOR_GREEN, false, DRAW_TIME )

		}

		if ( travelState.doEndSeekCheck )
		{
			if ( travelState.endSeekCheckOverrideFunc != null )
			{
				if ( nextIndex > 0 && currentPathIndex >= stopPathIndex )
					stopPathIndex = travelState.endSeekCheckOverrideFunc( player, pathNodeDataArray, currentPathIndex, nextIndex )
			}
			else
			{
				bool endBlocked = false
				// SEEK FROM END TO WHERE WE ARE
				for ( int j = stopPathIndex; j <= currentPathIndex; j++ )
				{
					PhaseTunnelPathNodeData pathNode = pathNodeDataArray[j]

					bool crouched = pathNode.wasCrouched
					vector mins   = GetBoundsMin( HULL_HUMAN )
					vector maxs   = GetBoundsMax( HULL_HUMAN )
					if ( crouched )
						maxs.z = min( maxs.z, PHASE_TUNNEL_CROUCH_HEIGHT )

					TraceResults results = TraceHull( pathNode.origin, pathNode.origin + <0, 0, 1>, mins, maxs, GetPlayerArray_Alive(), TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_NONE )
					bool thisPathNodeBlocked = results.startSolid
					if ( thisPathNodeBlocked )
					{
						endBlocked = true
						stopPathIndex = minint( j+1, pathNodeDataArray.len()-1 )

						if ( PHASE_TUNNEL_DEBUG_DRAW_PLAYER_TRAVEL )
						{
							DebugDrawBox( pathNode.origin, mins, maxs, COLOR_RED,1,10.0)
							DebugDrawText( pathNode.origin + <0,0,maxs.z/2>, "Blocked",false, 10.0)
							printt( "PHASE TUNNEL - BLOCKED BY SOMETHING, checking previous point. Blocked: "+j + " Trying: " + stopPathIndex )
						}
					}
					else
					{
						if ( endBlocked )
						{
							endBlocked = false
							if ( PHASE_TUNNEL_DEBUG_DRAW_PLAYER_TRAVEL )
							{
								DebugDrawBox( pathNode.origin, mins, maxs, COLOR_GREEN, 1, 10.0 )
								DebugDrawText( pathNode.origin + <0, 0, maxs.z / 2>, "Unblocked!", false, 10.0 )
								printt( "PHASE TUNNEL - UNBLOCKED!, Index: " + stopPathIndex )
							}
						}

						break
					}
				}
			}
		}

		if ( stopPathIndex > nextIndex )
			 nextIndex = maxint( nextIndex, stopPathIndex )

		if ( currentPathIndex >= stopPathIndex )
		{
			//printt( "MOVING TO NODE: " + currentPathIndex )
			mover.NonPhysicsMoveTo( pathNodeDataArray[currentPathIndex].origin, FRAME_TIME, 0, 0 )
			if ( nextIndex >= 0 )
			{
				float angleLerpTime = FRAME_TIME * 4.0
				mover.NonPhysicsRotateTo( <AngleNormalize(anglesToUse.x), AngleNormalize(anglesToUse.y), AngleNormalize(anglesToUse.z)>, angleLerpTime, 0, 0 )
				pathNodeData.nodeData.angles = anglesToUse //pathNodeDataArray[currentPathIndex].angles
			}
			pathNodeData.nodeData.origin             = pathNodeDataArray[currentPathIndex].origin
			player.SetVelocity( pathNodeDataArray[currentPathIndex].velocity )
			pathNodeData.nodeData.velocity           = pathNodeDataArray[currentPathIndex].velocity
			pathNodeData.nodeData.wasInContextAction = pathNodeDataArray[currentPathIndex].wasInContextAction
			pathNodeData.nodeData.wasCrouched        = pathNodeDataArray[currentPathIndex].wasCrouched
			//printt( "wasCrouched?" + pathNodeData.wasCrouched )
			if ( pathNodeData.nodeData.wasCrouched )
			{
				//printt( "PhaseTunnelCrouchPlayer" )
				thread PhaseTunnel_PathFollowCrouchPlayer( player )
			}

			if( !pathNodeData.nodeData.wasInContextAction )
			{
				pathNodeData.safeRelativeOrigin = pathNodeData.nodeData.origin
			}
		}

		currentPathIndex = nextIndex
		WaitFrame()
	}

	player.ClearParent()
	travelState.completed = true

	//HACK: If we clear the parent and set angles in the same frame, the player ends up facing in a random direction.
	//FOLLOWUP: Even though this doesn't set angles anymore, removing the WaitFrame still makes you face odd directions (maybe the long rotate lerp time?)
	WaitFrame()
	player.SetAbsOrigin( pathNodeData.nodeData.origin )

	// if ( PHASE_TUNNEL_DEBUG_DRAW_PLAYER_TRAVEL )
	// {
		// const float DRAW_TIME = 10.0
		// float dist = Distance( player.GetOrigin(), pathNodeDataArray[stopPathIndex].origin ) * INCHES_TO_METERS
		// int distInt = int(dist*100)
		// dist = distInt/100.0

		// DebugDrawText( player.GetOrigin(), ("Final Pos: " + dist + "m"), false, DRAW_TIME )
		// DebugDrawSphere( player.GetOrigin(), 10, COLOR_BLUE,false, DRAW_TIME )
		// DebugDrawSphere( pathNodeDataArray[stopPathIndex].origin, 6, COLOR_LIGHT_BLUE, false, DRAW_TIME )
		// DebugDrawLine( player.GetOrigin(),pathNodeDataArray[stopPathIndex].origin, COLOR_LIGHT_BLUE, false, DRAW_TIME )
	// }

	if ( pathNodeData.nodeData.wasInContextAction && !PutPlayerInSafeSpot( player, null, null, pathNodeData.safeRelativeOrigin, player.GetOrigin() ) )
		//Only do PutPlayerInSafeSpot check() if the last saved position they were in a context action, since context actions can put you in normally illegal spots, e.g. behind geo. If you do the PutPlayerInSafeSpot() check all the time you get false positives if you always use start position as safe starting spot
	{
		player.TakeDamage( player.GetHealth() + 1, player, player, { damageSourceId = eDamageSourceId.phase_shift, scriptType = DF_GIB | DF_BYPASS_SHIELD | DF_SKIPS_DOOMED_STATE } )
	}
}

void function PhaseTunnel_PrepareToMoveEntAlongTunnel( entity player, PhaseTunnelTravelState travelState )
{
	EndSignal( player, "OnDeath" )
	player.Zipline_Stop()
	player.ClearTraverse()
	player.SetPredictionEnabled( false )
	player.FreezeControlsOnServer()
	// EndPlayerSkyDive( player )
	Signal( player, "PlayerSkyDive" )

	//disable ping
	player.SetPlayerNetBool( "pingEnabled", false )

	if ( player.IsPhaseShifted() )
	{
		CancelPhaseShift( player )
	}

	// PlayerMelee_ClearPlayerAsLungeTarget( player, true )
	// player.Server_InvalidateMeleeLungeLagCompensationRecords() // EXTREMELY DANGEROUS - Talk to Code before using!!!

	// if ( player.ContextAction_IsEmoting() )
		// Emote_StopEmoteNow( player )

	travelState.thirdPersonShoulderModeWasOn = player.IsThirdPersonShoulderModeOn()
	if ( travelState.thirdPersonShoulderModeWasOn )
		player.SetThirdPersonShoulderModeOff()

	player.Signal( "PhaseTunnel_ReturnWeaponsToPlayerAfterDelay" )

	//todo-iholstead: remove me once R5DEV-578675 is closed
	printf("PhaseTunnel_PrepareToMoveEntAlongTunnel called on "+ player )

	Assert( !(player in file.playerToHolsterState), "Error! Preparing ent to move through phase tunnel when it hasn't left another!" )
	file.playerToHolsterState[ player ] <- false

	//Don't re-enable weapons if player is carrying loot.
	if ( !SURVIVAL_IsPlayerCarryingLoot( player ) && !Bleedout_IsBleedingOut( player ) && travelState.holsterWeapons )
	{
		file.playerToHolsterState[ player ] <- true
		HolsterAndDisableWeapons( player )
	}


	player.e.isInPhaseTunnel = true

	WaitEndFrame() // wait for the last save

	if ( travelState.shiftStyle == eShiftStyle.Tunnel )
	{
		EmitDifferentSoundsOnEntityForPlayerAndWorld( SOUND_PORTAL_TRAVEL_1P, SOUND_PORTAL_TRAVEL_3P, player, player )
	}
	// else if ( travelState.shiftStyle == PHASETYPE_BREACH )
	// {
		// EmitDifferentSoundsOnEntityForPlayerAndWorld( SOUND_PORTAL_TRAVEL_1P_BREACH, SOUND_PORTAL_TRAVEL_3P_BREACH, player, player )
	// }
	             
	// else if ( travelState.shiftStyle == PHASETYPE_TRANSPORT )
	// {
		// EmitDifferentSoundsOnEntityForPlayerAndWorld( SOUND_PORTAL_TRAVEL_1P_TRANSPORT, SOUND_PORTAL_TRAVEL_3P_TRANSPORT, player, player )
	// }
       

	ViewConeZeroInstant( player )
}

void function PhaseTunnel_RevertEntStateAfterMovingAlongTunnel( entity player, PhaseTunnelTravelState travelState )
{
	if ( IsValid( player ) && !IsDisconnected( player ) )
	{
		Assert( player in file.playerToHolsterState )

		player.SetPredictionEnabled( true )
		player.e.isInPhaseTunnel = false
		player.e.phaseTunnelExitTime = Time()

		//enable ping
		player.SetPlayerNetBool( "pingEnabled", true )

		thread PhaseTunnel_ReturnWeaponsToPlayerAfterDelay( player, travelState.holsterRemoveDelay )

		//player.ClearParent()
		if ( travelState.controlRestoreDelay == 0.0 )
			player.UnfreezeControlsOnServer()
		else
			thread PhaseTunnel_ReturnControlToPlayerAfterDelay( player, travelState.controlRestoreDelay )

		if ( travelState.thirdPersonShoulderModeWasOn && IsAlive( player ) )
			player.SetThirdPersonShoulderModeOn()

		if ( travelState.shiftStyle == eShiftStyle.Tunnel )
		{
			StopSoundOnEntity( player, SOUND_PORTAL_TRAVEL_1P )
			StopSoundOnEntity( player, SOUND_PORTAL_TRAVEL_3P )
		}
		// else if( travelState.shiftStyle == PHASETYPE_BREACH )
		// {
			// StopSoundOnEntity( player, SOUND_PORTAL_TRAVEL_1P_BREACH )
			// StopSoundOnEntity( player, SOUND_PORTAL_TRAVEL_3P_BREACH )
		// }
		             
		// else if ( travelState.shiftStyle == PHASETYPE_TRANSPORT )
		// {
			// StopSoundOnEntity( player, SOUND_PORTAL_TRAVEL_1P )
			// StopSoundOnEntity( player, SOUND_PORTAL_TRAVEL_3P )
		// }
        
	}
}

void function PhaseTunnel_ReturnWeaponsToPlayerAfterDelay( entity player, float delay )
{
	player.EndSignal( "PhaseTunnel_ReturnWeaponsToPlayerAfterDelay" )
	player.EndSignal( "OnDeath" )

	bool shouldDeployAndEnable
	if ( player in file.playerToHolsterState )
	{
		if ( file.playerToHolsterState[ player ] )
			shouldDeployAndEnable = true

		delete file.playerToHolsterState[ player ]
	}

	if ( !shouldDeployAndEnable )
		return


	OnThreadEnd( function() : ( player ) {
		if ( IsValid( player ) )
			DeployAndEnableWeapons( player )
	} )

	wait delay
}

void function PhaseTunnel_ReturnControlToPlayerAfterDelay( entity player, float delay )
{
	EndSignal( player, "OnDeath" )

	OnThreadEnd( function() : ( player ) {
		if ( IsValid( player ) )
			player.UnfreezeControlsOnServer()
	} )

	wait delay
}

vector function GetNextAngleToLookAt( int currentIndex, int step, array< PhaseTunnelPathNodeData > pathNodeDataArray )
{
	int lookAhead        = 5
	int total            = 1
	vector startPosition = pathNodeDataArray[currentIndex].origin
	int nextIndex        = currentIndex - step

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

	// bool DEBUG_DRAW_LOOK_AT = false
	// if ( DEBUG_DRAW_LOOK_AT )
	// {
		// DebugDrawSphere( startPosition, 2, COLOR_GREEN, true, 10.0 )
		// DebugDrawLine( startPosition, nextPosition, COLOR_RED, true, 10.0 )
	// }

	return VectorToAngles( nextPosition - startPosition )
}

void function PhaseTunnel_PathFollowCrouchPlayer( entity player, float delay = 0.2 )
{
	Signal( player, "PhaseTunnel_PathFollowCrouchPlayer" )
	EndSignal( player, "OnDeath" )
	EndSignal( player, "PhaseTunnel_PathFollowCrouchPlayer" )
	int forceCrouchHandle = 0 //player.PushForcedStance( FORCE_STANCE_CROUCH )
	player.ForceCrouch()
	OnThreadEnd(
		function() : ( player, forceCrouchHandle )
		{
			if ( IsValid( player ) )
			{
				player.UnforceCrouch()
				// player.RemoveForcedStance( forceCrouchHandle )
				if ( !player.ContextAction_IsActive() && !player.Anim_IsActive() )
					PutPlayerInSafeSpot( player, null, null, player.GetOrigin(), player.GetOrigin() )
			}
		}
	)
	wait delay
}

bool function PhaseTunnel_ShouldPhaseEnt( entity target )
{
	//todo-iholstead: remove me once R5DEV-578675 is closed
	printf("PhaseTunnel_ShouldPhaseEnt called on "+ target +", from + " + GetStack(3) )

	if ( target.e.lootRef == "fr_nessie_large" )
	{
		return true
	}

	if ( !target.IsPlayer() )
		return false

	if ( target.IsTitan() )
		return false

	//if ( target.IsPhaseShifted() )
	//	return false

	if ( target.ContextAction_IsMeleeExecution() || target.ContextAction_IsMeleeExecutionTarget() )
		return false
	
	if( target.ContextAction_IsLeeching() )
		return false

	//players shouldn't be able to warp if they're attached to a vehicle
	if ( target.GetParent() != null && target.GetParent().GetClassName() == "player_vehicle" )
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

	if ( target.IsPhaseShifted() )
		return false

	if ( Time() - target.e.phaseTunnelExitTime  < PHASE_TUNNEL_USE_COOLDOWN_TIME )
		return false

	// if ( IsValid( target.GetTurret() ) )
		// return false

	// if ( target.p.totemRecallTime + 2.0 > Time() )
		// return false

	                            
		// if ( ExplosiveHold_IsPlayerPlantingGrenade( target ) )
			// return false
       

	                
		// if ( GondolasAreActive() && IsPlayerInsideGondola( target ) )
			// return false
       

	//todo-iholstead: remove me once R5DEV-578675 is closed
	printf("PhaseTunnel_ShouldPhaseEnt PASSED for "+ target )

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
	player.EndSignal( "CleanUpPlayerAbilities" )
	EndThreadOn_PlayerChangedClass( player )

	//StatusEffect_AddTimed( player, eStatusEffect.placing_phase_tunnel, 1.0, PHASE_TUNNEL_PLACEMENT_DURATION, PHASE_TUNNEL_PLACEMENT_DURATION )

	waitthread PhaseTunnel_StartTrackingPositions_Internal( player, startPath, endPath )

	if ( IsValid( player ) )
	{
		vector startingOrigin = player.GetOriginOutOfTraversal()
		if ( endPath.pathNodes.len() > 0 )
			startingOrigin = endPath.pathNodes[ 0 ].origin

		if ( !player.IsTitan() )
		{
			vector origin = player.GetOriginOutOfTraversal()
			vector angles = player.GetAngles()
			angles = <0, player.CameraAngles().y, 0>

			bool isCrouched = player.IsCrouched() && !player.CanStand()//(player.IsCrouched() && !player.StandingPlayerFits())

			float distSqr    = DistanceSqr( startingOrigin, origin )
			bool canTeleport = PhaseTunnel_IsPortalExitPointValid( player, origin, player, false, isCrouched, PHASE_TUNNEL_DEBUG_DRAW_CREATE_TUNNEL )
			bool safeDist    = distSqr >= PHASE_TUNNEL_MIN_PORTAL_DIST_SQR

			PhaseTunnelPathNodeData startPathData
			startPathData.origin             = origin
			startPathData.angles             = angles
			startPathData.velocity           = player.GetVelocity()
			startPathData.wasInContextAction = player.ContextAction_IsActive()
			startPathData.wasCrouched        = isCrouched
			startPathData.validExit          = canTeleport && safeDist
			startPathData.time               = Time()

			// printt( "----------" + data.wasCrouched + "----------" )

			PhaseTunnelPathNodeData endPathData
			endPathData.origin             = origin
			endPathData.angles             = AnglesCompose( angles, <0, 180, 0> )
			endPathData.velocity           = player.GetVelocity()
			endPathData.wasInContextAction = player.ContextAction_IsActive()
			endPathData.wasCrouched        = isCrouched
			endPathData.validExit          = canTeleport && safeDist
			endPathData.time               = Time()

			//If the exit direction of the portal is facing a wall. Reverse it so the player doesn't exit looking at a wall.
			vector playerCenter = player.GetWorldSpaceCenter()
			vector forwardDir   = player.GetForwardVector()
			if ( !PhaseTunnel_BarrierInDirection( player, playerCenter, forwardDir, player ) )
			{
				startPathData.angles = AnglesCompose( angles, <0, 180, 0> )
				endPathData.angles   = angles
			}

			startPath.pathNodes.insert( 0, startPathData )
			endPath.pathNodes.append( endPathData )
		}

		StatusEffect_StopAllOfType( player, eStatusEffect.placing_phase_tunnel )
	}

	PhaseTunnel_CleanAndFinalizePath( startPath, file.travelSpeed, PHASE_TUNNEL_TELEPORT_TRAVEL_TIME_MIN, PHASE_TUNNEL_TELEPORT_TRAVEL_TIME_LONG, false, ePassives.PAS_VOICES )
	PhaseTunnel_CleanAndFinalizePath( endPath, file.travelSpeed, PHASE_TUNNEL_TELEPORT_TRAVEL_TIME_MIN, PHASE_TUNNEL_TELEPORT_TRAVEL_TIME_LONG, false, ePassives.PAS_VOICES )

	Assert( fabs( startPath.pathDistance - endPath.pathDistance ) < 0.2, "Start Path and End Path are not the same length: " + startPath.pathDistance + " vs " + endPath.pathDistance )
	Assert( fabs( startPath.pathTime - endPath.pathTime ) < 0.1, "Start Path and End Path do not have the same travel time: " + startPath.pathTime + " vs " + endPath.pathTime )
}

void function PhaseTunnel_StartTrackingPositions_Internal( entity player, PhaseTunnelPathData startPath, PhaseTunnelPathData endPath )
{
	player.EndSignal( "PhaseTunnel_CancelPlacement" )
	player.EndSignal( "PhaseTunnel_EndPlacement" )
	player.EndSignal( "OnDeath" )
	player.EndSignal( "CleanUpPlayerAbilities" )

	vector lastOrigin     = player.GetOriginOutOfTraversal()
	vector startingOrigin = player.GetOriginOutOfTraversal()
	bool firstNode        = true

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
	//todo: Merge thread ends above and clean

	table< entity, int > speedBoostStatusEffectID
	float curDistPercent = 0
	float speedBoost = 0.1

	OnThreadEnd(
		function() : ( player, speedBoostStatusEffectID )
		{
			if( IsValid( player ) )
			{
				if( player in speedBoostStatusEffectID )
				{
					if ( speedBoostStatusEffectID[player] != -1 )
						StatusEffect_Stop( player, speedBoostStatusEffectID[player] )
				}
			}
		}
	)

	while ( true )
	{
		if ( !player.IsTitan() )
		{
			vector origin = player.GetOriginOutOfTraversal()
			vector angles = player.GetAngles()
			angles = <0, player.CameraAngles().y, 0>
			float distSqr = DistanceSqr( startingOrigin, origin )

			bool wasCrouched = firstNode ? ( player.IsCrouched() && !player.CanStand() ) : player.IsCrouched() //player.IsCrouched() && !player.StandingPlayerFits() //
			bool canTeleport = (PhaseTunnel_IsPortalExitPointValid( player, origin, player, false, wasCrouched, PHASE_TUNNEL_DEBUG_DRAW_CREATE_TUNNEL ))
			bool safeDist    = distSqr >= PHASE_TUNNEL_MIN_PORTAL_DIST_SQR

			//Only record shapshots when player has moved.
			if ( (lastOrigin != origin || firstNode) && ((firstNode && canTeleport) || !firstNode) )
			{
				PhaseTunnelPathNodeData startPathData
				startPathData.origin             = origin
				startPathData.angles             = angles
				startPathData.velocity           = player.GetVelocity()
				startPathData.wasInContextAction = player.ContextAction_IsActive()
				startPathData.wasCrouched        = wasCrouched
				startPathData.validExit          = firstNode ? canTeleport : canTeleport && safeDist
				startPathData.time               = Time()

				// printt( "----------" + data.wasCrouched + "----------" )

				PhaseTunnelPathNodeData endPathData
				endPathData.origin             = origin
				endPathData.angles             = AnglesCompose( angles, <0, 180, 0> )
				endPathData.velocity           = player.GetVelocity()
				endPathData.wasInContextAction = player.ContextAction_IsActive()
				endPathData.wasCrouched        = wasCrouched
				endPathData.validExit          = firstNode ? canTeleport : canTeleport && safeDist
				endPathData.time               = Time()

				if ( firstNode )
				{
					startingOrigin = origin
					firstNode      = false

					//If the exit direction of the portal is facing a wall. Reverse it so the player doesn't exit looking at a wall.
					vector playerCenter = player.GetWorldSpaceCenter()
					vector forwardDir   = player.GetForwardVector()
					if ( !PhaseTunnel_BarrierInDirection( player, playerCenter, -forwardDir, player ) )
					{
						startPathData.angles = AnglesCompose( angles, <0, 180, 0> )
						endPathData.angles   = angles
					}

					float prePlaceFXOffset = wasCrouched ? PHASE_TUNNEL_PLACEMENT_HEIGHT_CROUCHING : PHASE_TUNNEL_PLACEMENT_HEIGHT_STANDING
					int fxid               = GetParticleSystemIndex( PHASE_TUNNEL_PREPLACE_FX )
					vector fxOrigin        = player.GetOrigin() + (<0, 0, 1> * prePlaceFXOffset)
					entity fx              = StartParticleEffectInWorld_ReturnEntity( fxid, fxOrigin, player.GetAngles() + <0, 90, 90> )
					fx.RemoveFromAllRealms()
					fx.AddToOtherEntitysRealms( player )
					EmitSoundOnEntity( fx, SOUND_PREPORTAL_LOOP )

					OnThreadEnd(
						function() : ( fx )
						{
							if ( IsValid( fx ) )
							{
								StopSoundOnEntity( fx, SOUND_PREPORTAL_LOOP )
							}
						}
					)

					shutdownArray.append( fx )

					entity traceBlocker = CreateTraceBlockerVolume( fxOrigin, 24.0, false, CONTENTS_NOGRAPPLE, player.GetTeam(), PHASETUNNEL_PRE_BLOCKER_SCRIPTNAME )
					traceBlocker.RemoveFromAllRealms()
					traceBlocker.AddToOtherEntitysRealms( player )
					traceBlocker.SetOwner( player )
					shutdownArray.append( traceBlocker )
				}

					float portalDistance = Distance( startingOrigin, origin )
					float perMaxDist = GraphCapped( portalDistance, 0, file.maxPlacementDist , 0, 100 )

					if( perMaxDist > curDistPercent + PHASE_TUNNEL_SPEED_INCREMENT_PERCENT )
					{
						if( IsValid( player ) )
						{
							if( player in speedBoostStatusEffectID )
							{
								if ( speedBoostStatusEffectID[player] != -1 )
								{
									StatusEffect_Stop( player, speedBoostStatusEffectID[player] )
								} // 0.0 means not active
							}

							curDistPercent = perMaxDist
							speedBoost = speedBoost + PHASE_TUNNEL_SPEED_INCREMENT_AMOUNT
							speedBoostStatusEffectID[player] <- StatusEffect_AddEndless( player, eStatusEffect.speed_boost, speedBoost )
						}
					}

				startPath.pathNodes.insert( 0, startPathData )
				endPath.pathNodes.append( endPathData )
			}

			lastOrigin = origin
		}

		WaitFrame()
	}
}

void function PhaseTunnel_CleanAndFinalizePath( PhaseTunnelPathData pathData, float travelSpeed, float minTime, float maxTime, bool skipCleaning, int creatorPassive = ePassives.INVALID )
{
	if ( !skipCleaning )
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
	}
	//Wraith-specific - with s16 longer portals change we want to scale the max travel time beyond the original path distance max
	if( creatorPassive == ePassives.PAS_VOICES )
	{
		if( pathData.pathDistance > PHASE_TUNNEL_LONG_DISTANCE )
			maxTime = GraphCapped( pathData.pathDistance, PHASE_TUNNEL_LONG_DISTANCE, PHASE_TUNNEL_MAX_DISTANCE, PHASE_TUNNEL_TELEPORT_TRAVEL_TIME_LONG, PHASE_TUNNEL_TELEPORT_TRAVEL_TIME_MAX )
	}

	pathData.pathTime  = pathData.pathDistance / travelSpeed
	pathData.pathTime  = clamp( pathData.pathTime, minTime, maxTime )

	int pathLength         = pathData.pathNodes.len() - 1
	int numPathFrames      = minint( int( pathData.pathTime / FRAME_TIME + 0.5 ), pathLength )
	if ( numPathFrames == 0 )
		return

	float avgNodesPerFrame = float( pathLength ) / float( numPathFrames )
	int minNodesPerFrame   = maxint( int( floor( avgNodesPerFrame ) ), 1 )
	int maxNodesPerFrame   = int( ceil( avgNodesPerFrame ) )

	pathData.frameSteps.clear()
	// Calculate the number of nodes we jump each frame
	int remainingNodes = pathLength
	for ( int i = 0; i < numPathFrames; i++ )
	{
		pathData.frameSteps.append( minNodesPerFrame )
		remainingNodes -= minNodesPerFrame
	}

	int indexToAdjust = (numPathFrames - remainingNodes) / 2
	while( remainingNodes > 0 && indexToAdjust < pathData.frameSteps.len() )
	{
		pathData.frameSteps[indexToAdjust] = maxNodesPerFrame
		remainingNodes -= ( maxNodesPerFrame - minNodesPerFrame )
		indexToAdjust++
	}

	Assert( remainingNodes == 0, "Created portal frame steps without fulling using all nodes" )
	pathData.frameSteps.append( 1 )										// Need one last step so we can move to index 0, otherwise we stop short
	pathData.phaseTime = FRAME_TIME * (pathData.frameSteps.len() + 1)	// Extra frame covers the post-tunnel WaitFrame before setting player origin
}
#endif


entity function GetDoorForHitEnt( entity hitEnt )
{
	if ( IsDoor( hitEnt ) )
		return hitEnt

	entity parentEnt = hitEnt.GetParent()
	if ( IsValid( parentEnt ) && IsDoor( parentEnt ) )
		return parentEnt

	return null
}

bool function IsValidWorldExitPos( TraceResults results )
{
	if ( !IsValid( results.hitEnt ) )
		return true

	if ( results.hitEnt.GetNetworkedClassName() == "prop_death_box" )
		return true

	// if ( results.hitEnt.IsPlayerVehicle() )
		// return true

	entity hitDoor = GetDoorForHitEnt( results.hitEnt )
	if ( IsValid( hitDoor ) )
		return true

	// if ( results.hitEnt.GetScriptName() == BASE_WALL_SCRIPT_NAME )
		// return true

	// if ( results.hitEnt.GetScriptName() == MOUNTED_TURRET_PLACEABLE_SCRIPT_NAME )
		// return true

	return false
}

array< entity > function PhaseTunnel_GetPortalIgnoreEnts()
{
	array< entity > ignoreEnts
	return ignoreEnts
}


bool function PhaseTunnel_IsPortalExitPointValid( entity player, vector testOrg, entity ignoreEnt = null, bool onlyCheckWorld = false, bool isCrouched = false, bool DEBUG_DRAW = false )
{
	int solidMask            = onlyCheckWorld ? TRACE_MASK_PLAYERSOLID_BRUSHONLY : TRACE_MASK_PLAYERSOLID
	vector mins
	vector maxs
	int collisionGroup       = TRACE_COLLISION_GROUP_PLAYER
	array<entity> ignoreEnts = [ player ]

	if ( IsValid( ignoreEnt ) )
		ignoreEnts.append( ignoreEnt )
	                     
		// entity vehicle = HoverVehicle_GetVehicleOccupiedByPlayer( player )
		// if ( IsValid( vehicle ) )
			// ignoreEnts.append( vehicle )
                            

	ignoreEnts.extend( PhaseTunnel_GetPortalIgnoreEnts() )

	TraceResults result

	mins   = player.GetBoundingMins()
	maxs   = player.GetBoundingMaxs()

	if ( isCrouched )
		maxs = < maxs.x, maxs.y, PHASE_TUNNEL_CROUCH_HEIGHT >

	result = TraceHull( testOrg, testOrg + <0, 0, 1>, mins, maxs, ignoreEnts, solidMask, collisionGroup )

	if ( result.startSolid || result.fraction < 1 || result.surfaceNormal != <0, 0, 0> )
	{
		if ( !onlyCheckWorld )
			return false

		if ( !IsValidWorldExitPos( result ) )
			return false
	}

	return true
}

#if SERVER
bool function PhaseTunnel_BarrierInDirection( entity player, vector origin, vector dir, entity ignoreEnt = null )
{
	int solidMask            = TRACE_MASK_PLAYERSOLID
	vector mins
	vector maxs
	int collisionGroup       = TRACE_COLLISION_GROUP_PLAYER
	array<entity> ignoreEnts = [ player ]

	if ( IsValid( ignoreEnt ) )
		ignoreEnts.append( ignoreEnt )
	TraceResults result

	mins   = player.GetBoundingMins()
	maxs   = player.GetBoundingMaxs()
	//result = TraceHull( testOrg, testOrg + <0,0,1>, mins, maxs, ignoreEnts, solidMask, collisionGroup )
	result = TraceLineHighDetail( origin, origin + (dir * PHASE_TUNNEL_MIN_GEO_REVERSE_DIST), ignoreEnts, solidMask, collisionGroup )
	//PrintTraceResults( result )

	if ( result.fraction < 1 )
		return false

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

	vector pos   = portalMarker.GetOrigin()
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

	for ( ; ; )
	{
		float velocityX = Length( player.GetVelocity() )

		if ( !EffectDoesExist( fxHandle ) )
			break

		velocityX = GraphCapped( velocityX, 0.0, 360, 5, 200 )
		EffectSetControlPointVector( fxHandle, 1, <velocityX, 999, 0> )
		WaitFrame()
	}
}
#endif //CLIENT

#if SERVER
array<entity> function PhaseTunnel_GetAllTunnelEnts()
{
	ArrayRemoveInvalid( file.allTunnelEnts )
	return file.allTunnelEnts
}

bool function PhaseTunnel_IsTunnelValid( entity tunnelEnt )
{
	return (tunnelEnt in file.tunnelData)
}

vector function PhaseTunnel_GetTunnelStart( entity tunnelEnt )
{
	return file.tunnelData[ tunnelEnt ].startPortal.endOrigin
}

vector function PhaseTunnel_GetTunnelEnd( entity tunnelEnt )
{
	return file.tunnelData[ tunnelEnt ].endPortal.endOrigin
}

void function PhaseTunnel_MarkForDelete( entity tunnelEnt )
{
	PhaseTunnelData data = file.tunnelData[ tunnelEnt ]
	data.expired = true

	{
		data.startPortal.portalFX.Destroy()
		vector origin = data.startPortal.startOrigin
		vector angles = data.startPortal.startAngles
		float prePlaceFXOffset = data.startPortal.crouchPortal ? PHASE_TUNNEL_PLACEMENT_HEIGHT_CROUCHING : PHASE_TUNNEL_PLACEMENT_HEIGHT_STANDING
		int fxid               = GetParticleSystemIndex( PHASE_TUNNEL_PREPLACE_FX )
		vector fxOrigin        = origin + (<0, 0, 1> * prePlaceFXOffset)
		entity fx              = StartParticleEffectInWorld_ReturnEntity( fxid, fxOrigin, angles + <0, 90, 90> )
		data.startPortal.portalFX = fx
	}

	{
		data.endPortal.portalFX.Destroy()
		vector origin = data.endPortal.startOrigin
		vector angles = data.endPortal.startAngles
		float prePlaceFXOffset = data.endPortal.crouchPortal ? PHASE_TUNNEL_PLACEMENT_HEIGHT_CROUCHING : PHASE_TUNNEL_PLACEMENT_HEIGHT_STANDING
		int fxid               = GetParticleSystemIndex( PHASE_TUNNEL_PREPLACE_FX )
		vector fxOrigin        = origin + (<0, 0, 1> * prePlaceFXOffset)
		entity fx              = StartParticleEffectInWorld_ReturnEntity( fxid, fxOrigin, angles + <0, 90, 90> )
		data.endPortal.portalFX = fx
	}
}

float function GetMaxDistForPlayer( entity player )
{
	return file.maxPlacementDist
}
#endif