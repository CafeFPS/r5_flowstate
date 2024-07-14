global function Sh_EvacShip_Init
global function EvacShip_RegisterNetworking

#if SERVER
	global function CreateEvacShipSequence
	global function GetEvacShipPassengers
	global function EvacShipForceEarlyDeparture
	global function AddEntityCallback_OnEvacShipBeginningApproach
	global function AddEntityCallback_OnEvacShipArrived
	global function AddEntityCallback_OnEvacShipDeparted
	global function AddEntityCallback_OnEvacShipPlayerBoarded
	global function AddEntityCallback_OnEvacShipDepartureCompleted
	global function EvacShipUseAltAttachments
	global function GetEvacShipDataForShip
	global function IsPlayerEvacShipPassenger
	
	#if DEVELOPER
		global function Dev_DebugEvacPos
		global function Dev_TestEvacAtCursorPosition
	#endif
#endif //SERVER

#if CLIENT
	global function EvacShip_ServerCallback_DisplayShipFullHint
#endif //CLIENT

#if (CLIENT || SERVER)
global function PrecacheObjectiveAsset_Model
global function GetObjectiveAsset_Model

global function PrecacheObjectiveAsset_FX
global function GetObjectiveAsset_FX
#endif // (CLIENT || SERVER)

global const string EVAC_DROPSHIP_TARGETNAME = "evac_dropship"

#if SERVER
	// Icon
	const asset ICON_DROPSHIP_EVAC = $"rui/hud/common/evac_location_friendly"
	// VFX
	const string VFX_ASSET_STRING_RED_RING_LIGHT = "FX_EVAC_RING_LIGHT_RED"
	const string VFX_ASSET_STRING_GREEN_RING_LIGHT = "FX_EVAC_RING_LIGHT_GREEN"
	const string VFX_ASSET_STRING_FLARE = "FX_EVAC_FLARE"
	const string VFX_ASSET_STRING_BEACON_PENDING = "FX_EVAC_SHIP_BEACON_PENDING"
	const string VFX_ASSET_STRING_BEACON_ARRIVED = "FX_EVAC_SHIP_BEACON_ARRIVED"
	// SFX
	const string SFX_STRING_FLARE = "sq_lz_flare_start_loop"
	const string SFX_STRING_EVACSHIP_FLYIN = "goblin_shadowsquad_evac_flyin"
	const string SFX_STRING_EVACSHIP_HOVER = "goblin_shadowsquad_evac_hover"
	const string SFX_STRING_EVACSHIP_FLYOUT = "goblin_shadowsquad_evac_flyout"
#endif //SERVER

global const int	EVAC_SHIP_PASSENGERS_MAX = 6
const float DEFAULT_TIME_UNTIL_SHIP_ARRIVES = 60
const float DEFAULT_TIME_UNTIL_SHIP_DEPARTS = 30
const float DEFAULT_EVAC_RADIUS = 256
const float EVAC_SHIP_Z_OFFSET = 128

#if CLIENT
const float EVACSHIP_ANNOUNCEMENT_DURATION = 5.0
#endif //CLIENT

#if SERVER
global struct EvacShipData
{
	entity evacShip
	entity evacShipTrigger
	entity evacFlareFx
	array <entity> evacZoneFx
	array <entity> passengers
	array <entity> wayPoints
	float timeToArrive
	float timeToDepart
	array<vector> ringFxPoints
	array<void functionref( entity )> callbacksOnArrived
	array<void functionref( entity )> callbacksOnDeparted
	array<void functionref( entity )> callbacksOnBeginningApproach
	array<void functionref( entity, entity )> callbacksOnPlayerBoarded
	array<void functionref( entity )> callbacksOnDepartureCompleted
	vector origin
	vector angles
	int friendlyTeamOrAlliance
	array<string> shipAttachments = [ "ATTACH_PLAYER_1", "ATTACH_PLAYER_2", "ATTACH_PLAYER_3", "ATTACH_PLAYER_4", "ATTACH_PLAYER_5", "ATTACH_PLAYER_6", "ATTACH_PLAYER_7", "ATTACH_PLAYER_8", "ATTACH_PLAYER_9", "ATTACH_PLAYER_10" ]
	array<string> shipAttachmentsAlt = [ "ALT_ATTACH_PLAYER_1", "ALT_ATTACH_PLAYER_2", "ALT_ATTACH_PLAYER_3", "ALT_ATTACH_PLAYER_4" ]
	int currentShipAttachIndex
	bool departing = false
	bool arrived = false
	bool beginningApproach = false
	bool displayEvacWaypointToAll = true
	bool useAltAttachments = false
	bool shouldDepartIfFull = false
}
#endif //SERVER


struct
{
	#if SERVER
		table<entity, EvacShipData>	evacShipDataStructs
	#endif //SERVER
} file

void function Sh_EvacShip_Init()
{
	#if SERVER
		PrecacheObjectiveAsset_FX( VFX_ASSET_STRING_RED_RING_LIGHT, $"runway_light_red" )
		PrecacheObjectiveAsset_FX( VFX_ASSET_STRING_GREEN_RING_LIGHT, $"runway_light_green" )
		PrecacheObjectiveAsset_FX( VFX_ASSET_STRING_FLARE, $"P_road_flare" )
		PrecacheObjectiveAsset_FX( VFX_ASSET_STRING_BEACON_PENDING, $"P_lootcache_far_beam" )
		PrecacheObjectiveAsset_FX( VFX_ASSET_STRING_BEACON_ARRIVED, $"P_lootcache_far_beam" )
	#endif //SERVER
}

void function EvacShip_RegisterNetworking()
{
	Remote_RegisterClientFunction( "EvacShip_ServerCallback_DisplayShipFullHint" )
}


#if SERVER
entity function CreateEvacShipSequence( vector origin, vector angles, float evacRadius = DEFAULT_EVAC_RADIUS, int friendlyTeamOrAlliance = -1, float timeToArrive = DEFAULT_TIME_UNTIL_SHIP_ARRIVES, float timeToDepart = DEFAULT_TIME_UNTIL_SHIP_DEPARTS, bool displayEvacWaypoint = true, bool displayEvacWaypointToAll = true, bool showEvacRing = false, bool shouldDepartIfFull = false )
{
	#if DEVELOPER
		if ( GetPlayerArray_AliveConnected().len() == 0 )
			return null
	#endif


	Assert( friendlyTeamOrAlliance != -1, "Need to pass a valid friendly team or alliance" )

	///////////////////////////
	// Evac ship spawn and hide
	///////////////////////////
	//entity evacShip = CreateExpensiveScriptMoverModel( RESPAWN_DROPSHIP_MODEL, origin + <0, 0, 10000>, angles, SOLID_VPHYSICS, 999999 )
	entity evacShip = CreatePropDynamic( RESPAWN_DROPSHIP_MODEL, origin + <0, 0, 10000>, angles, SOLID_VPHYSICS, 99999 )
	evacShip.Highlight_Enable()
	evacShip.MakeInvisible()
	evacShip.NotSolid()
	evacShip.SetInvulnerable()
	evacShip.DisableHibernation()
	evacShip.DisableGrappleAttachment()
	evacShip.DisallowZiplines()
	evacShip.SetOrigin( origin )
	evacShip.SetAngles( angles )
	evacShip.SetShieldHealthMax( EVAC_SHIP_PASSENGERS_MAX )
	SetTargetName( evacShip, EVAC_DROPSHIP_TARGETNAME )

	///////////////////////////
	// Evac trigger
	///////////////////////////
	float triggerHeight = 600
	entity trig = CreateEntity( "trigger_cylinder" )
	trig.SetRadius( evacRadius )
	trig.SetAboveHeight( triggerHeight )
	trig.SetBelowHeight( 96 )
	trig.SetOrigin( origin )
	trig.kv.triggerFilterNpc = "none"
	trig.kv.triggerFilterPlayer = "all"
	trig.kv.triggerFilterNonCharacter = "0"

	DispatchSpawn( trig )


	///////////////////
	// Evac fx flare and ring
	////////////////////
	entity evacFlareFx = StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( GetObjectiveAsset_FX( VFX_ASSET_STRING_FLARE ) ), OriginToGround( origin + <0, 0, 128> ) + <0, 0, 4>, <0, 0, 0> )
	EmitSoundAtPosition( TEAM_ANY, evacFlareFx.GetOrigin(), SFX_STRING_FLARE, evacFlareFx )
	array <entity> evacZoneFx
	array<vector> ringFxPoints
	int friendlyTeam = friendlyTeamOrAlliance

	if ( showEvacRing )
	{
		ringFxPoints = GetPointsOnCircle( origin, <0,0,0>, evacRadius, 32 )
		foreach ( point in ringFxPoints )
			evacZoneFx.append( StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( GetObjectiveAsset_FX( VFX_ASSET_STRING_RED_RING_LIGHT ) ),OriginToGround( point + <0, 0, 128> ), <0, 0, 0> ) )

		entity beamFX = StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( GetObjectiveAsset_FX( VFX_ASSET_STRING_BEACON_PENDING ) ), origin, <0, 0, 0> )
		beamFX.DisableHibernation()
		evacZoneFx.append( beamFX )

		if ( !displayEvacWaypointToAll )
		{
			foreach( fx in evacZoneFx )
			{
				SetTeam( fx, friendlyTeam )
				fx.kv.VisibilityFlags = ( ENTITY_VISIBLE_TO_FRIENDLY )
			}
		}
	}

	///////////////////
	// Evac HUD and icons
	////////////////////

	entity wp = null
	if ( displayEvacWaypoint )
	{
		wp = CreateWaypoint_BasicLocation( origin + <0, 0, 64>, ePingType.EVAC_SHIP )
	}

	///////////////////
	// Data struct
	////////////////////
	EvacShipData evacShipData
	evacShipData.evacShip = evacShip
	evacShipData.evacShipTrigger = trig
	evacShipData.evacZoneFx= evacZoneFx
	evacShipData.evacFlareFx = evacFlareFx
	evacShipData.timeToArrive = timeToArrive
	evacShipData.timeToDepart = timeToDepart
	evacShipData.wayPoints.append( wp )
	evacShipData.ringFxPoints = ringFxPoints
	evacShipData.origin = origin
	evacShipData.angles = angles
	evacShipData.friendlyTeamOrAlliance = friendlyTeamOrAlliance
	evacShipData.displayEvacWaypointToAll = displayEvacWaypointToAll
	evacShipData.shouldDepartIfFull = shouldDepartIfFull

	file.evacShipDataStructs[ evacShip ] <- evacShipData
	thread EvacShipSequence( evacShipData )

	return evacShipData.evacShip
}
#endif



#if SERVER
void function EvacShipSequence( EvacShipData evacShipData )
{
	AssertIsNewThread()

	entity evacShip = evacShipData.evacShip
	entity evacShipTrigger = evacShipData.evacShipTrigger
	vector animOrigin = evacShipData.origin + <0, 0, EVAC_SHIP_Z_OFFSET> //don't animate right to the evac node or it will clip into ground
	vector animAngles = evacShipData.angles

	string animArrive = "dropship_VTOL_evac_start"
	string animIdle  = "dropship_VTOL_evac_idle_no_motion"
	string animLeave = "dropship_VTOL_evac_end"
	string animLeave2 = "dropship_VTOL_evac_end_nodoors"


	/////////////
	// Cleanup
	/////////////
	OnThreadEnd( function() : ( evacShipData )
	{
		StopEvacFx( evacShipData )

		if ( IsValid( evacShipData.evacShipTrigger ) )
			evacShipData.evacShipTrigger.Destroy()

	})

	/////////////
	// Trigger
	/////////////
	evacShipTrigger.SetEnterCallback( OnTriggerEnterEvacTrigger )
	evacShipTrigger.ConnectOutput( "OnTrigger", OnTriggerEvacTrigger )
	evacShipTrigger.LinkToEnt( evacShip )

	/////////////////
	// Wait to arrive
	/////////////////
	float bufferTime = 2
	wait ( evacShipData.timeToArrive - bufferTime )

	///////////////////////
	// Evac ship flies in
	///////////////////////
	evacShipData.beginningApproach = true
	foreach ( callbackFunc in evacShipData.callbacksOnBeginningApproach )
		callbackFunc( evacShip )

	//ring goes from red to green...everyone can see it now
	StopEvacFx( evacShipData )
	foreach ( point in evacShipData.ringFxPoints )
		evacShipData.evacZoneFx.append( StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( GetObjectiveAsset_FX( VFX_ASSET_STRING_GREEN_RING_LIGHT ) ), OriginToGround( point + <0, 0, 128> ), <0, 0, 0> ) )



	if ( !evacShipData.displayEvacWaypointToAll )
	{
		//delete waypoint that was only displayed to friendly team and replace with one that can be seen by all
		foreach( wp in evacShipData.wayPoints )
		{
			if ( IsValid( wp ) )
				wp.Destroy()
		}
		evacShipData.wayPoints = []

		entity legendWaypoint = CreateWaypoint_BasicLocation( evacShipData.origin + <0, 0, 128>, ePingType.EVAC_SHIP )
		entity shadowWaypoint = CreateWaypoint_BasicLocation( evacShipData.origin + <0, 0, 128>, ePingType.EVAC_ZONE )

		legendWaypoint.RemoveFromAllRealms()
		shadowWaypoint.RemoveFromAllRealms()
		legendWaypoint.AddToRealm( LEGEND_REALM )
		shadowWaypoint.AddToRealm( SHADOW_REALM )

		evacShipData.wayPoints.append( legendWaypoint )
		evacShipData.wayPoints.append( shadowWaypoint )

		evacShip.LinkToEnt( legendWaypoint )

		evacShipData.evacZoneFx.append( StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( GetObjectiveAsset_FX( VFX_ASSET_STRING_BEACON_PENDING ) ), evacShipData.origin, <0, 0, 0> ) )
	}

	entity beamFX = StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( GetObjectiveAsset_FX( VFX_ASSET_STRING_BEACON_ARRIVED ) ), evacShipData.origin, <0, 0, 0> )
	beamFX.DisableHibernation()
	evacShipData.evacZoneFx.append( beamFX )

	wait bufferTime
	evacShip.MakeVisible()
	evacShip.Solid()
	Highlight_SetEnemyHighlight( evacShip, "dropship_enemy" )
	Highlight_SetFriendlyHighlight( evacShip, "dropship_friendly" )
	Highlight_SetNeutralHighlight( evacShip, "dropship_friendly" )
	EmitSoundOnEntity( evacShip, SFX_STRING_EVACSHIP_FLYIN )
	thread JetwashFX( evacShip )
	waitthread PlayAnimTeleport( evacShip, animArrive, animOrigin, animAngles )


	///////////////////////
	// Evac ship arrived and waiting
	///////////////////////
	// Added via AddEntityCallback_OnEvacShipArrived
	evacShipData.arrived = true
	evacShipTrigger.SearchForNewTouchingEntity()
	thread EvacTriggerFailsafe( evacShipTrigger )
	foreach ( callbackFunc in evacShipData.callbacksOnArrived )
		callbackFunc( evacShip )

	thread PlayAnim( evacShip, animIdle, animOrigin, animAngles )

	evacShip.EnableGrappleAttachment()
	evacShip.AllowZiplines()
	StopSoundOnEntity( evacShip, SFX_STRING_EVACSHIP_FLYIN )
	EmitSoundOnEntity( evacShip, SFX_STRING_EVACSHIP_HOVER  )

	waitthread WaitTillEvacShipToldToDepart( evacShip, evacShipData.timeToDepart )

	////////////////////////
	// Evac ship departing!
	////////////////////////
	StopEvacFx( evacShipData )

	foreach( wp in evacShipData.wayPoints )
	{
		if ( IsValid( wp ) )
			wp.Destroy()
	}

	evacShipData.evacShipTrigger.SetParent( evacShip, "", true ) //parent trigger to allow last minute evac as doors close
	evacShipData.departing = true
	thread DeleteEvacShipTriggerDelayed( evacShipData.evacShipTrigger, 1.5 )
	// Added via AddEntityCallback_OnEvacShipDeparted
	foreach ( callbackFunc in evacShipData.callbacksOnDeparted )
		callbackFunc( evacShip )

	StopSoundOnEntity( evacShip, SFX_STRING_EVACSHIP_HOVER )
	evacShip.DisableGrappleAttachment()
	evacShip.DisallowZiplines()
	Highlight_ClearNeutralHighlight( evacShip )
	Highlight_ClearFriendlyHighlight( evacShip )
	Highlight_ClearEnemyHighlight( evacShip )
	//evacShip.SetFadeDistance( 512 )
	EmitSoundOnEntity( evacShip, SFX_STRING_EVACSHIP_FLYOUT )
	waitthread PlayAnim( evacShip, animLeave, animOrigin, animAngles )

	foreach( func in evacShipData.callbacksOnDepartureCompleted )
		func( evacShip )

	//hack...blend into another anim so ship keeps flying while victory gets sorted out
	waitthread PlayAnim( evacShip, animLeave2, evacShip.GetOrigin(), AnglesCompose( evacShip.GetAngles(), <0, -90, 0> ), 2.0 )
	waitthread PlayAnim( evacShip, animLeave2, evacShip.GetOrigin(), AnglesCompose( evacShip.GetAngles(), <0, -90, 0> ), 2.0 )
}
#endif //SERVER


#if SERVER
void function DeleteEvacShipTriggerDelayed( entity trigger, float delay )
{
	wait delay

	if ( IsValid( trigger ) )
		trigger.Destroy()
}
#endif //SERVER


#if SERVER
void function OnTriggerEvacTrigger( entity trigger, entity ent, entity caller, var value )
{
	OnTriggerEnterEvacTrigger( trigger, ent )
}
#endif //SERVER

#if SERVER
void function OnTriggerEnterEvacTrigger( entity trigger, entity ent )
{
		string failMsg
		if ( !IsValid( ent ) )
		{
			failMsg = "ent not valid: " + ent
			return
		}


		if ( !ent.IsPlayer() )
		{
			failMsg = "ent not a player: " + ent
			return
		}

		entity evacShip = trigger.GetLinkEnt()
		if ( !IsValid( evacShip ) )
		{
			return
		}

		EvacShipData shipData = GetEvacShipDataForShip( evacShip )

		if ( !shipData.arrived )
		{
			failMsg = "evac ship not here yet: " + ent
			return
		}


		if ( !IsValid( trigger ) )
		{
			failMsg = "trigger not valid for player: " + ent
			return
		}


		if ( !CanPlayerBoardEvacShip( ent, shipData ) )
			return

		thread PlayerBoardsEvacShip( ent, shipData )

}
#endif

#if SERVER
void function EvacTriggerFailsafe( entity trigger )
{
	AssertIsNewThread()
	//workaround/failsafe for seeing playtests where players were clearly inside the trigger but not getting detected
	trigger.EndSignal( "OnDestroy" )

	float triggerRadius = DEFAULT_EVAC_RADIUS // trigger.GetCylinderRadius()
	float triggerAboveHeight = trigger.GetAboveHeight()
	float triggerBelowHeight = trigger.GetBelowHeight()
	float minDistSq = ( triggerRadius * triggerRadius )

	entity evacShip = trigger.GetLinkEnt()
	if ( !IsValid( evacShip ) )
	{
		return
	}

	EvacShipData shipData = GetEvacShipDataForShip( evacShip )

	while ( true )
	{
		wait 0.25

		foreach( player in GetPlayerArray_Alive() )
		{
			if ( !IsAlive( player ) )
				continue
			if ( !IsPlayerFriendlyToEvacShip( player, shipData  ))
				continue

			//failsafe in case the onTrigger events get hosed
			if ( trigger.IsTouching( player ) )
			{
				OnTriggerEnterEvacTrigger( trigger, player )
				continue
			}

			//is touching may be unreliable with a million shadow legends mulling around in the trigger
			if ( DistanceSqr( player.GetOrigin(), trigger.GetOrigin() ) < minDistSq )
			{
				OnTriggerEnterEvacTrigger( trigger, player )
				continue
			}
		}
	}
}
#endif //SERVER

#if SERVER
void function PlayerBoardsEvacShip( entity player, EvacShipData evacShipData )
{
	if ( !IsValid( player ) )
		return

	player.EndSignal( "OnDeath" )

	//Kick out of zipline
	if ( player.IsZiplining() )
		player.Zipline_Stop()

	//kick out of portal placement
	if ( StatusEffect_GetSeverity( player, eStatusEffect.placing_phase_tunnel ) > 0 )
	{
		player.Signal( "PhaseTunnel_CancelPlacement" )
		/*
		entity weapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
		if ( IsValid( weapon ) )
		{
			if ( weapon.IsChargeWeapon() && weapon.GetWeaponClassName() == "mp_weapon_phase_tunnel" )
			{
				weapon.SetWeaponChargeFraction( 1 )
				weapon.SetWeaponPrimaryClipCount( 0 )
				weapon.ForceChargeEndNoAttack()
				player.Signal( "PhaseTunnel_CancelPlacement" )
				player.Signal( "PhaseTunnel_EndPlacement" )
			}
		}
		*/
	}

	// // Kick out of turret
	// entity turret = player.GetTurret()
	// if ( IsValid( turret ) )
		// MountedTurretPlaceable_ClearDriver_ForOtherReason( turret )

	// Bleedout_ForceStop( player )
	// Bleedout_ReviveForceStop( player )
	Signal( player, "BleedOut_OnRevive" )
	if ( player.GetHealth() < 5 )
		player.SetHealth( 5 )
	//player.SetHealth( player.GetMaxHealth() )

	if ( !player.IsInvulnerable() )
		player.SetInvulnerable()
	
	//fixme Cafe
	//if crypto in evac trigger while flying around in his drone, get out
	// if ( !player.IsBot() && IsValid( player.p.cryptoActiveCamera ) )
		// player.p.cryptoActiveCamera.Destroy()

	//don't want to deal with crypto drones, phasing, etc during evac
	//player.TakeOffhandWeapon( OFFHAND_TACTICAL )
	//player.TakeOffhandWeapon( OFFHAND_ULTIMATE )
	// player.DisableWeaponTypes( WPT_ULTIMATE | WPT_TACTICAL )
	player.Server_TurnOffhandWeaponsDisabledOn()
	Survival_SetInventoryEnabled( player, false )

	player.NotSolid()
	player.SetNoTarget( true )
	player.SetCanBeMeleed( false )
	player.SetAimAssistAllowed( false )
	player.SetIsValidAIMeleeTarget( false )
	evacShipData.passengers.append( player )
	evacShipData.evacShip.SetShieldHealth( evacShipData.passengers.len() )

	///////////////////////////////////////////
	// Run callback(s) for player boarding ship
	///////////////////////////////////////////
	// Added via AddEntityCallback_OnEvacShipPlayerBoarded
	entity evacShip = evacShipData.evacShip
	foreach ( callbackFunc in evacShipData.callbacksOnPlayerBoarded )
		callbackFunc( player, evacShip )

	/////////////////////////////////////////////
	// Quick fade to cover transition to ship
	/////////////////////////////////////////////
	ScreenFadeToBlack( player, 0.5, 0.0 )
	wait 0.4

	//////////////////////////
	// Attach player to ship
	//////////////////////////
	int attachmentIndex = evacShipData.currentShipAttachIndex
	array<string> attachments = (evacShipData.useAltAttachments ? evacShipData.shipAttachmentsAlt : evacShipData.shipAttachments)
	string attachmentTag = attachments[attachmentIndex]
	evacShipData.currentShipAttachIndex++

	int attachID = evacShip.LookupAttachment( attachmentTag )
	vector attachOrigin = evacShip.GetAttachmentOrigin( attachID )
	vector attachAngles = evacShip.GetAttachmentAngles( attachID )

	player.EndSignal( "OnDestroy" )
	evacShip.EndSignal( "OnDestroy" )

	if ( player.p.isSkydiving )
	{
		Signal( player, "PlayerSkyDive" )
		player.Anim_Stop()
		WaitFrame()
		WaitFrame()
	}

	// DisableEntityOutOfBounds( player )
	player.SetOrigin( attachOrigin )
	player.SetAngles( attachAngles )
	player.SetParent( evacShip, attachmentTag, false, 1.0 )
	player.SetGroundEntity( evacShip )
	player.SnapEyeAngles( FlattenAngles( attachAngles ) )
	// if ( AttachmentTagShouldForceCrouch( attachmentTag ) )
	// {
		// player.PushForcedStance( FORCE_STANCE_CROUCH )
	// }

	AddCinematicFlag( player, CE_FLAG_HIDE_MAIN_HUD )

	//scorched earth failsafe fix to make absolutely sure player doesn't die in evac ship
	//for bug R5DEV-107416
	AddEntityCallback_OnDamaged( player,
		void function ( entity player, var damageInfo ) : ()
		{
			if ( !IsValid( player ) )
				return

			int damageType      = DamageInfo_GetCustomDamageType( damageInfo )
			int damageSourceID   = DamageInfo_GetDamageSourceIdentifier( damageInfo )
			printl( "SS ERROR: invulnerable player taking damage while inside evac ship at " + player.GetOrigin() + " //player: " + player + " //damageSourceID: " + GetRefFromDamageSourceID( damageSourceID ) + " //damageType: " + damageType )

			DamageInfo_SetDamage( damageInfo, 0 )
		}
	)

	//debug info in case player is somehow killed during evac
	AddEntityCallback_OnKilled( player,
		void function( entity player, var damageInfo ) : ()
		{
			int damageType      = DamageInfo_GetCustomDamageType( damageInfo )
			int damageSourceID   = DamageInfo_GetDamageSourceIdentifier( damageInfo )
			printl( "SS ERROR: invulnerable player killed while inside evac ship at " + player.GetOrigin() + " //player: " + player + " //damageSourceID: " + GetRefFromDamageSourceID( damageSourceID ) + " //damageType: " + damageType )
		}
	)

	ScreenFadeFromBlack( player, 0.25, 0.25 )

	//tell ship to depart if full
	if ( evacShipData.shouldDepartIfFull && evacShipData.passengers.len() == EVAC_SHIP_PASSENGERS_MAX )
	{
		EvacShipForceEarlyDeparture( evacShipData.evacShip )
		return
	}

	// Prompt to yell to your friends:
	if ( AnyTeamatesNotOnBoardYet( player, evacShipData ) )
		Remote_CallFunction_NonReplay( player, "ServerCallback_PromptSayGetOnTheDropship" )
}

bool function AnyTeamatesNotOnBoardYet( entity player, EvacShipData esd )
{
	array<entity> liveTeammates = GetPlayerArrayOfTeam_Alive( player.GetTeam() )
	foreach ( teammate in liveTeammates )
	{
		if ( !esd.passengers.contains( teammate ) )
			return true
	}
	return false
}
#endif //SERVER

#if SERVER
bool function AttachmentTagShouldForceCrouch( string attachmentTag )
{
	// if you are a big character, some of the tags will
	// have your head clipping through some random interior ship hardware
	switch( attachmentTag )
	{
		case "ATTACH_PLAYER_1":
		case "ATTACH_PLAYER_2":
		case "ALT_ATTACH_PLAYER_1":
		case "ALT_ATTACH_PLAYER_2":
		case "ALT_ATTACH_PLAYER_3":
		case "ALT_ATTACH_PLAYER_4":
			return true
	}

	return false
}
#endif //SERVER



/*
=======================================================================================================================
=======================================================================================================================
=======================================================================================================================

   ##     ## ######## #### ##       #### ######## ##    ##
   ##     ##    ##     ##  ##        ##     ##     ##  ##
   ##     ##    ##     ##  ##        ##     ##      ####
   ##     ##    ##     ##  ##        ##     ##       ##
   ##     ##    ##     ##  ##        ##     ##       ##
   ##     ##    ##     ##  ##        ##     ##       ##
    #######     ##    #### ######## ####    ##       ##

=======================================================================================================================
=======================================================================================================================
=======================================================================================================================
*/

#if SERVER
EvacShipData function GetEvacShipDataForShip( entity evacShip )
{
	Assert( IsValid( evacShip ) )
	foreach( testShip, dataStruct in file.evacShipDataStructs )
	{
		if ( testShip == evacShip )
			return dataStruct
	}

	Assert( false, "Unable to find data for ship " + evacShip + " in file.evacShipDataStructs" )

	unreachable
}
#endif //SERVER


#if SERVER
void function StopEvacFx( EvacShipData evacShipData )
{
	foreach( fx in evacShipData.evacZoneFx )
	{
		if ( !IsValid( fx ) )
			continue
		fx.SetStopType( "destroyImmediately" )
		fx.Destroy()
	}
}
#endif //SERVER



#if SERVER
void function WaitTillEvacShipToldToDepart( entity evacShip, float timeToDepart )
{
	AssertIsNewThread()

	RegisterSignal( "ForceEarlyDeparture" )
	evacShip.EndSignal( "ForceEarlyDeparture" )

	wait timeToDepart
}
#endif //SERVER

#if SERVER
array<entity> function GetEvacShipPassengers( entity evacShip )
{
	Assert( IsValid( evacShip ) )
	EvacShipData evacShipData = GetEvacShipDataForShip( evacShip )
	ArrayRemoveDead( evacShipData.passengers )

	return evacShipData.passengers
}

void function EvacShipUseAltAttachments( entity evacShip )
{
	Assert( IsValid( evacShip ) )
	EvacShipData esd = GetEvacShipDataForShip( evacShip )
	esd.useAltAttachments = true
}
#endif //SERVER



#if SERVER
bool function CanPlayerBoardEvacShip( entity player, EvacShipData evacShipData  )
{
	if ( evacShipData.passengers.contains( player ) )
		return false

	if ( !IsAlive( player ) )
	{
		printf( "%s() - player can't board evac ship - not alive: '%s'", FUNC_NAME(), string( player ) )
		return false
	}

	if ( !IsValid( player ) )
	{
		printf( "%s() - player can't board evac ship - invalid: '%s'", FUNC_NAME(), string( player ) )
		return false
	}

	if ( player.IsPhaseShifted() )
	{
		printf( "%s() - player can't board evac ship - phase shifted: '%s'", FUNC_NAME(), string( player ) )
		return false
	}

	if ( !IsPlayerFriendlyToEvacShip( player, evacShipData  ) ) // only allow players on approved alliance or team to board
	{
		printf( "%s() - player can't board evac ship - not on friendly team or alliance: '%s'", FUNC_NAME(), string( player ) )
		return false
	}

	if ( evacShipData.evacShip.GetShieldHealth() >= evacShipData.evacShip.GetShieldHealthMax() )
	{
		printf( "%s() - player can't board evac ship - it is full: '%s'", FUNC_NAME(), string( player ) )
		Remote_CallFunction_NonReplay( player, "EvacShip_ServerCallback_DisplayShipFullHint" )
		return false
	}

	return true
}
#endif //SERVER

#if SERVER
bool function IsPlayerFriendlyToEvacShip( entity player, EvacShipData evacShipData  )
{
	if ( !IsValid( player ) )
		return false

	int playerTeam = player.GetTeam()

	if ( !IsFriendlyTeam( playerTeam, evacShipData.friendlyTeamOrAlliance ) ) // only allow players on approved teams to board
		return false

	return true
}
#endif //SERVER

#if CLIENT
// Trigger a hint telling the player that the Evac Ship is full
void function EvacShip_ServerCallback_DisplayShipFullHint()
{
	AddPlayerHint( EVACSHIP_ANNOUNCEMENT_DURATION, 0.5, $"", Localize( "#EVAC_SHIP_FULL_HINT" ) )
}
#endif //CLIENT

#if SERVER && DEVELOPER
// Trigger an Evac sequence at the cursor position, used to test out different positions to make sure they work with the ship animation
void function Dev_TestEvacAtCursorPosition( bool showEvacRing = false, bool showIconForEvacShip = false )
{
	entity player = GP()
	if ( IsValid( player ) )
	{
		vector origin = EyeTraceVec( player )
		vector angles = player.EyeAngles()
		angles = < 0, angles.y, 0 >
		printt("Running Debug Command to spawn evac at cursor position, Origin: " + origin + " Angles: " + angles )
		thread Dev_DebugEvacPos( origin, angles, showEvacRing, showIconForEvacShip )
	}
	else
	{
		printt("Failed to run Debug Command to spawn evac at cursor position, player InValid")
	}
}
#endif //SERVER && DEVELOPER

#if SERVER && DEVELOPER
void function Dev_DebugEvacPos( vector origin, vector angles, bool showEvacRing = false, bool showIconForEvacShip = true )
{
	AssertIsNewThread()

	if ( showIconForEvacShip )
		entity wp = CreateWaypoint_BasicPos( origin + <0, 0, 64>, "#SHADOW_SQUAD_EVAC_ICON", ICON_DROPSHIP_EVAC )

	// Spawn ring vfx if enabled ( disabled by default in most cases now )
	if ( showEvacRing )
	{
		array<vector> ringFxPoints = GetPointsOnCircle( origin, <0,0,0>, 256, 32 )
		foreach ( point in ringFxPoints )
			StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( GetObjectiveAsset_FX( VFX_ASSET_STRING_GREEN_RING_LIGHT ) ),OriginToGround( point + <0, 0, 128> ), <0, 0, 0> )
	}

	// Trigger flare and beam vfx as we would in the real sequence
	entity evacFlareFx = StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( GetObjectiveAsset_FX( VFX_ASSET_STRING_FLARE ) ), OriginToGround( origin + <0, 0, 128> ) + <0, 0, 4>, <0, 0, 0> )
	EmitSoundAtPosition( TEAM_ANY, evacFlareFx.GetOrigin(), SFX_STRING_FLARE, evacFlareFx )
	entity beamFX = StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( GetObjectiveAsset_FX( VFX_ASSET_STRING_BEACON_ARRIVED ) ), origin, <0, 0, 0> )
	beamFX.DisableHibernation()

	// Trigger Evac Ship Animations
	entity evacShip = CreateExpensiveScriptMoverModel( RESPAWN_DROPSHIP_MODEL, origin + <0, 0, 10000>, angles, SOLID_VPHYSICS, 9999999 )
	//entity evacShip = CreatePropDynamic( RESPAWN_DROPSHIP_MODEL, origin + <0, 0, 10000>, angles, SOLID_VPHYSICS )
	evacShip.NotSolid()
	evacShip.SetOrigin( origin )
	evacShip.SetAngles( angles )

	vector animOrigin = origin + <0, 0, EVAC_SHIP_Z_OFFSET> //don't animate right to the evac node or it will clip into ground
	vector animAngles = angles

	string animArrive = "dropship_VTOL_evac_start"
	string animIdle  = "dropship_VTOL_evac_idle"
	string animLeave = "dropship_VTOL_evac_end"
	string animLeave2 = "dropship_VTOL_evac_end_nodoors"

	while( true )
	{
		EmitSoundOnEntity( evacShip, SFX_STRING_EVACSHIP_FLYIN )
		thread JetwashFX( evacShip )
		waitthread PlayAnimTeleport( evacShip, animArrive, animOrigin, animAngles )
		thread PlayAnim( evacShip, animIdle, animOrigin, animAngles )
		StopSoundOnEntity( evacShip, SFX_STRING_EVACSHIP_FLYIN )
		EmitSoundOnEntity( evacShip, SFX_STRING_EVACSHIP_HOVER )
		wait 5
		StopSoundOnEntity( evacShip, SFX_STRING_EVACSHIP_HOVER )
		EmitSoundOnEntity( evacShip, SFX_STRING_EVACSHIP_FLYOUT )
		waitthread PlayAnim( evacShip, animLeave, animOrigin, animAngles )
		waitthread PlayAnim( evacShip, animLeave2, evacShip.GetOrigin(), AnglesCompose( evacShip.GetAngles(), <0, -90, 0> ), 2.0 )
	}
}
#endif //SERVER && DEVELOPER


#if SERVER
void function EvacShipForceEarlyDeparture( entity evacShip )
{
	if ( !IsValid( evacShip ) )
		return

	evacShip.Signal( "ForceEarlyDeparture" )
}
#endif //SERVER

#if SERVER
void function AddEntityCallback_OnEvacShipArrived( entity evacShip, void functionref( entity ) callbackFunc )
{
	EvacShipData evacShipData = GetEvacShipDataForShip( evacShip )

	#if DEVELOPER
		foreach ( func in  evacShipData.callbacksOnArrived )
		{
			Assert( func != callbackFunc, "Already added " + string( callbackFunc ) + " to evac ship" )
		}
	#endif

	evacShipData.callbacksOnArrived.append( callbackFunc )
}
#endif //SERVER



#if SERVER
void function AddEntityCallback_OnEvacShipBeginningApproach( entity evacShip, void functionref( entity ) callbackFunc )
{
	EvacShipData evacShipData = GetEvacShipDataForShip( evacShip )

	#if DEVELOPER
		foreach ( func in  evacShipData.callbacksOnBeginningApproach )
		{
			Assert( func != callbackFunc, "Already added " + string( callbackFunc ) + " to evac ship" )
		}
	#endif

	evacShipData.callbacksOnBeginningApproach.append( callbackFunc )
}
#endif //SERVER



#if SERVER
void function AddEntityCallback_OnEvacShipDeparted( entity evacShip, void functionref( entity ) callbackFunc )
{
	EvacShipData evacShipData = GetEvacShipDataForShip( evacShip )

	#if DEVELOPER
		foreach ( func in  evacShipData.callbacksOnDeparted )
		{
			Assert( func != callbackFunc, "Already added " + string( callbackFunc ) + " to evac ship" )
		}
	#endif

	evacShipData.callbacksOnDeparted.append( callbackFunc )
}
#endif //SERVER



#if SERVER
void function AddEntityCallback_OnEvacShipDepartureCompleted( entity evacShip, void functionref( entity ) callbackFunc )
{
	EvacShipData evacShipData = GetEvacShipDataForShip( evacShip )

	#if DEVELOPER
		foreach ( func in  evacShipData.callbacksOnDepartureCompleted )
		{
			Assert( func != callbackFunc, "Already added " + string( callbackFunc ) + " to evac ship" )
		}
	#endif

	evacShipData.callbacksOnDepartureCompleted.append( callbackFunc )
}
#endif //SERVER



#if SERVER
void function AddEntityCallback_OnEvacShipPlayerBoarded( entity evacShip, void functionref( entity, entity ) callbackFunc )
{
	EvacShipData evacShipData = GetEvacShipDataForShip( evacShip )

	#if DEVELOPER
		foreach ( func in  evacShipData.callbacksOnPlayerBoarded )
		{
			Assert( func != callbackFunc, "Already added " + string( callbackFunc ) + " to evac ship" )
		}
	#endif

	evacShipData.callbacksOnPlayerBoarded.append( callbackFunc )
}
#endif //SERVER

#if SERVER
bool function IsPlayerEvacShipPassenger( entity player )
{
	foreach( ship, data in file.evacShipDataStructs )
	{
		if ( data.passengers.contains( player ) )
			return true
	}

	return false
}
#endif


#if (CLIENT || SERVER)

table<string, asset> s_models
void function PrecacheObjectiveAsset_Model( string name, asset model )
{
	Assert( !(name in s_models), format( "Objective model asset '%s' has already been registered with asset '%s'.", name, string( s_models[name] ) ) )
	s_models[name] <- model
	PrecacheModel( model )
}
asset function GetObjectiveAsset_Model( string name )
{
	Assert( (name in s_models), format( "Objective model asset '%s' has not been registered.", name ) )
	return s_models[name]
}

table<string, asset> s_fxs
void function PrecacheObjectiveAsset_FX( string name, asset fx )
{
	Assert( !(name in s_fxs), format( "Objective fx asset '%s' has already been registered with asset '%s'.", name, string( s_fxs[name] ) ) )
	s_fxs[name] <- fx
	// PrecacheObjectiveAsset_FX( fx )
	PrecacheParticleSystem( fx )
}
asset function GetObjectiveAsset_FX( string name )
{
	Assert( (name in s_fxs), format( "Objective fx asset '%s' has not been registered.", name ) )
	return s_fxs[name]
}

#endif // (CLIENT || SERVER)

