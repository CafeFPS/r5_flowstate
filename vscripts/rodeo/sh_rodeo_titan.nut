global function ShTitanRodeo_Init

#if SERVER
global function RodeoTitan_DoActionOfferItem

global function DisableTitanRodeo
global function EnableTitanRodeo
global function GiveFriendlyRodeoPlayerProtection
global function TakeAwayFriendlyRodeoPlayerProtection
#endif
global function AddOnRodeoTitanStartedCallback
global function AddOnRodeoTitanEndedCallback

global enum eRodeoSpots_Titan
{
	FRIENDLY_LEFT,
	FRIENDLY_RIGHT,
	FRIENDLY_FRONT,
	//ENEMY_FRONT,
	//ENEMY_REAR,

	CENTRAL_ACTIVITY,
}

global enum eRodeoTransitions_Titan
{
	ATTACH_FRIENDLY_LEFT_FROM_FRONT_LEFT_LOWER,
	ATTACH_FRIENDLY_LEFT_FROM_FRONT_LEFT_UPPER,
	ATTACH_FRIENDLY_LEFT_FROM_FRONT_RIGHT_LOWER,
	ATTACH_FRIENDLY_LEFT_FROM_FRONT_RIGHT_UPPER,
	ATTACH_FRIENDLY_LEFT_FROM_SIDE_LEFT_LOWER,
	ATTACH_FRIENDLY_LEFT_FROM_SIDE_LEFT_UPPER,
	ATTACH_FRIENDLY_LEFT_FROM_SIDE_RIGHT_LOWER,
	ATTACH_FRIENDLY_LEFT_FROM_SIDE_RIGHT_UPPER,
	ATTACH_FRIENDLY_LEFT_FROM_REAR_LEFT_LOWER,
	ATTACH_FRIENDLY_LEFT_FROM_REAR_LEFT_UPPER,
	ATTACH_FRIENDLY_LEFT_FROM_REAR_RIGHT_LOWER,
	ATTACH_FRIENDLY_LEFT_FROM_REAR_RIGHT_UPPER,
	SHIFT_FROM_FRIENDLY_LEFT_TO_FRIENDLY_RIGHT,
	SHIFT_FROM_FRIENDLY_LEFT_TO_FRIENDLY_FRONT,
	DETACH_FRIENDLY_LEFT,

	ATTACH_FRIENDLY_RIGHT_FROM_FRONT_LEFT_LOWER,
	ATTACH_FRIENDLY_RIGHT_FROM_FRONT_LEFT_UPPER,
	ATTACH_FRIENDLY_RIGHT_FROM_FRONT_RIGHT_LOWER,
	ATTACH_FRIENDLY_RIGHT_FROM_FRONT_RIGHT_UPPER,
	ATTACH_FRIENDLY_RIGHT_FROM_SIDE_LEFT_LOWER,
	ATTACH_FRIENDLY_RIGHT_FROM_SIDE_LEFT_UPPER,
	ATTACH_FRIENDLY_RIGHT_FROM_SIDE_RIGHT_LOWER,
	ATTACH_FRIENDLY_RIGHT_FROM_SIDE_RIGHT_UPPER,
	ATTACH_FRIENDLY_RIGHT_FROM_REAR_LEFT_LOWER,
	ATTACH_FRIENDLY_RIGHT_FROM_REAR_LEFT_UPPER,
	ATTACH_FRIENDLY_RIGHT_FROM_REAR_RIGHT_LOWER,
	ATTACH_FRIENDLY_RIGHT_FROM_REAR_RIGHT_UPPER,
	SHIFT_FROM_FRIENDLY_RIGHT_TO_FRIENDLY_LEFT,
	SHIFT_FROM_FRIENDLY_RIGHT_TO_FRIENDLY_FRONT,
	DETACH_FRIENDLY_RIGHT,

	ATTACH_FRIENDLY_FRONT_FROM_FRONT_LEFT_LOWER,
	ATTACH_FRIENDLY_FRONT_FROM_FRONT_LEFT_UPPER,
	ATTACH_FRIENDLY_FRONT_FROM_FRONT_RIGHT_LOWER,
	ATTACH_FRIENDLY_FRONT_FROM_FRONT_RIGHT_UPPER,
	ATTACH_FRIENDLY_FRONT_FROM_SIDE_LEFT_LOWER,
	ATTACH_FRIENDLY_FRONT_FROM_SIDE_LEFT_UPPER,
	ATTACH_FRIENDLY_FRONT_FROM_SIDE_RIGHT_LOWER,
	ATTACH_FRIENDLY_FRONT_FROM_SIDE_RIGHT_UPPER,
	ATTACH_FRIENDLY_FRONT_FROM_REAR_LEFT_LOWER,
	ATTACH_FRIENDLY_FRONT_FROM_REAR_LEFT_UPPER,
	ATTACH_FRIENDLY_FRONT_FROM_REAR_RIGHT_LOWER,
	ATTACH_FRIENDLY_FRONT_FROM_REAR_RIGHT_UPPER,
	SHIFT_FROM_FRIENDLY_FRONT_TO_FRIENDLY_LEFT,
	SHIFT_FROM_FRIENDLY_FRONT_TO_FRIENDLY_RIGHT,
	DETACH_FRIENDLY_FRONT,

	ATTACH_ENEMY_FRONT,
	DETACH_ENEMY_FRONT,

	ATTACH_ENEMY_REAR,
	DETACH_ENEMY_REAR,

	ACTION_OFFERITEM_FRIENDLY_LEFT,
	ACTION_OFFERITEM_FRIENDLY_RIGHT,
	ACTION_OFFERITEM_FRIENDLY_FRONT,
}

//global enum eRodeoActivities_Titan
//{
//	REPAIR_KIT,
//	AMMO_PACK,
//	HACK,
//}

struct
{
	RodeoVehicleFlavor& titanVehicleFlavor

	array<void functionref(entity, entity)> onTitanRodeoEndedCallbacks
	array<void functionref(entity, entity)> onTitanRodeoStartedCallbacks

	int numRodeoSlots = -1 // feels hacky

	#if SERVER
		table<entity, bool> riderWantsToChangeSpotsMap
	#endif
} file

void function ShTitanRodeo_Init()
{
	#if SERVER
		AddCallback_OnTitanDoomed( OnTitanDoomed )
		AddSpawnCallback( "titan_soul", OnTitanSoulCreated )
		AddCallback_OnClientDisconnected( OnPlayerDestroyed )
		RegisterSignal( "WantsToChangeRodeoSpot" )
		RegisterSignal( "RodeoOfferingReady" )
		RegisterSignal( "RodeoOfferingAccepted" )
		RegisterSignal( "RodeoOfferingRejected" )
		RegisterSignal( "RodeoOfferingCancelled" )
	#endif

	#if CLIENT
		AddCreateCallback( "titan_soul", OnTitanSoulCreated )
		// todo(dw): temporary
		RegisterSignal( "UpdateRodeoAlert" )
	#endif

	RodeoVehicleFlavor vf
	vf.getAttachTransition = GetAttachTransition
	vf.onRodeoStartingFunc = OnRodeoStarting
	vf.onRodeoFinishingFunc = OnRodeoFinishing
	file.titanVehicleFlavor = vf

	InitAnims()


	// todo(dw): fix up rodeo animations
	RodeoSpotFlavor sf
	{
		sf = RodeoVehicleFlavor_AddSpot( vf, eRodeoSpots_Titan.FRIENDLY_LEFT )
		sf.attachPoint = "hijack"
		sf.thirdPersonIdleAnim = "pt_rodeo_ride_L_idle"
		sf.firstPersonIdleAnim = "ptpov_rodeo_ride_L_idle"

		sf = RodeoVehicleFlavor_AddSpot( vf, eRodeoSpots_Titan.FRIENDLY_RIGHT )
		sf.attachPoint = "hijack"
		sf.thirdPersonIdleAnim = "pt_rodeo_ride_R_idle"
		sf.firstPersonIdleAnim = "ptpov_rodeo_ride_R_idle"

		sf = RodeoVehicleFlavor_AddSpot( vf, eRodeoSpots_Titan.FRIENDLY_FRONT )
		sf.attachPoint = "hijack"
		sf.thirdPersonIdleAnim = "pt_rodeo_ride_F_idle"
		sf.firstPersonIdleAnim = "ptpov_rodeo_ride_F_idle"

		//sf = RodeoVehicleFlavor_AddSpot( vf, eRodeoSpots_Titan.ENEMY_FRONT )
		//sf.attachPoint = "hijack"
		//sf.thirdPersonIdleAnim = "pt_rodeo_ride_F_idle"
		//sf.firstPersonIdleAnim = "ptpov_rodeo_ride_F_idle"

		//sf = RodeoVehicleFlavor_AddSpot( vf, eRodeoSpots_Titan.ENEMY_REAR )
		//sf.thirdPersonIdleAnim = GetAnimFromAlias( "atlas", "pt_rodeo_back_right_idle" )
		//sf.firstPersonIdleAnim = GetAnimFromAlias( "atlas", "ptpov_rodeo_back_right_idle" )

		sf = RodeoVehicleFlavor_AddSpot( vf, eRodeoSpots_Titan.CENTRAL_ACTIVITY )
		sf.idleIsError = true
	}

	RodeoTransitionFlavor tf
	{
		tf = RodeoVehicleFlavor_AddTransition( vf,
			eRodeoTransitions_Titan.ATTACH_FRIENDLY_LEFT_FROM_FRONT_LEFT_LOWER, RODEO_SENTINEL_BEGIN_SPOT_ATTACH, eRodeoSpots_Titan.FRIENDLY_LEFT
		)
		tf.attachment = "hijack"
		tf.thirdPersonAnim = "pt_rodeo_entrance_L_left"
		tf.firstPersonAnim = "ptpov_rodeo_entrance_L_left"
		//tf.thirdPersonAnim = "pt_rodeo_move_atlas_left_entrance"
		//tf.firstPersonAnim = "ptpov_rodeo_move_atlas_left_entrance"
		tf.worldSound = "Rodeo_Atlas_Rodeo_ClimbOn_Left_Exterior"
		tf.cockpitSound = "Rodeo_Atlas_Rodeo_ClimbOn_Left_Interior"

		tf = RodeoVehicleFlavor_AddTransition( vf,
			eRodeoTransitions_Titan.ATTACH_FRIENDLY_RIGHT_FROM_FRONT_RIGHT_LOWER, RODEO_SENTINEL_BEGIN_SPOT_ATTACH, eRodeoSpots_Titan.FRIENDLY_RIGHT
		)
		tf.attachment = "hijack"
		tf.thirdPersonAnim = "pt_rodeo_entrance_R_right"
		tf.firstPersonAnim = "ptpov_rodeo_entrance_R_right"
		//tf.thirdPersonAnim = "pt_rodeo_move_atlas_right_entrance"
		//tf.firstPersonAnim = "ptpov_rodeo_move_atlas_right_entrance"
		tf.worldSound = "Rodeo_Atlas_Rodeo_ClimbOn_Right_Exterior"
		tf.cockpitSound = "Rodeo_Atlas_Rodeo_ClimbOn_Right_Interior"

		tf = RodeoVehicleFlavor_AddTransition( vf,
			eRodeoTransitions_Titan.ATTACH_FRIENDLY_FRONT_FROM_FRONT_LEFT_LOWER, RODEO_SENTINEL_BEGIN_SPOT_ATTACH, eRodeoSpots_Titan.FRIENDLY_FRONT
		)
		tf.attachment = "hijack"
		tf.thirdPersonAnim = "pt_rodeo_entrance_F_front"
		tf.firstPersonAnim = "ptpov_rodeo_entrance_F_front"
		//tf.thirdPersonAnim = "pt_rodeo_move_atlas_right_entrance"
		//tf.firstPersonAnim = "ptpov_rodeo_move_atlas_right_entrance"
		tf.worldSound = "Rodeo_Atlas_Rodeo_ClimbOn_Front_Exterior"
		tf.cockpitSound = "Rodeo_Atlas_Rodeo_ClimbOn_Front_Interior"

		//tf = RodeoVehicleFlavor_AddTransition( vf,
		//	eRodeoTransitions_Titan.ATTACH_ENEMY_FRONT, RODEO_SENTINEL_BEGIN_SPOT_ATTACH, eRodeoSpots_Titan.ENEMY_FRONT
		//)
		//tf.attachment = "hijack"
		//tf.thirdPersonAnim = "pt_rodeo_entrance_F_front"
		//tf.firstPersonAnim = "ptpov_rodeo_entrance_F_front"
		////tf.thirdPersonAnim = "pt_rodeo_move_atlas_right_entrance"
		////tf.firstPersonAnim = "ptpov_rodeo_move_atlas_right_entrance"
		//tf.worldSound = "Rodeo_Atlas_Rodeo_ClimbOn_Front_Exterior"
		//tf.cockpitSound = "Rodeo_Atlas_Rodeo_ClimbOn_Front_Interior"

		tf = RodeoVehicleFlavor_AddTransition( vf,
			eRodeoTransitions_Titan.SHIFT_FROM_FRIENDLY_LEFT_TO_FRIENDLY_RIGHT, eRodeoSpots_Titan.FRIENDLY_LEFT, eRodeoSpots_Titan.FRIENDLY_RIGHT
		)
		tf.attachment = "hijack"
		tf.thirdPersonAnim = "pt_rodeo_trans_L2R"
		tf.firstPersonAnim = "ptpov_rodeo_trans_L2R"
		tf.worldSound = "Rodeo_Atlas_Rodeo_ClimbOn_Front_Exterior"
		tf.cockpitSound = "Rodeo_Atlas_Rodeo_ClimbOn_Front_Interior"

		tf = RodeoVehicleFlavor_AddTransition( vf,
			eRodeoTransitions_Titan.SHIFT_FROM_FRIENDLY_LEFT_TO_FRIENDLY_FRONT, eRodeoSpots_Titan.FRIENDLY_LEFT, eRodeoSpots_Titan.FRIENDLY_FRONT
		)
		tf.attachment = "hijack"
		tf.thirdPersonAnim = "pt_rodeo_trans_L2F"
		tf.firstPersonAnim = "ptpov_rodeo_trans_L2F"
		tf.worldSound = "Rodeo_Atlas_Rodeo_ClimbOn_Front_Exterior"
		tf.cockpitSound = "Rodeo_Atlas_Rodeo_ClimbOn_Front_Interior"

		tf = RodeoVehicleFlavor_AddTransition( vf,
			eRodeoTransitions_Titan.SHIFT_FROM_FRIENDLY_RIGHT_TO_FRIENDLY_LEFT, eRodeoSpots_Titan.FRIENDLY_RIGHT, eRodeoSpots_Titan.FRIENDLY_LEFT
		)
		tf.attachment = "hijack"
		tf.thirdPersonAnim = "pt_rodeo_trans_R2L"
		tf.firstPersonAnim = "ptpov_rodeo_trans_R2L"
		tf.worldSound = "Rodeo_Atlas_Rodeo_ClimbOn_Front_Exterior"
		tf.cockpitSound = "Rodeo_Atlas_Rodeo_ClimbOn_Front_Interior"

		tf = RodeoVehicleFlavor_AddTransition( vf,
			eRodeoTransitions_Titan.SHIFT_FROM_FRIENDLY_RIGHT_TO_FRIENDLY_FRONT, eRodeoSpots_Titan.FRIENDLY_RIGHT, eRodeoSpots_Titan.FRIENDLY_FRONT
		)
		tf.attachment = "hijack"
		tf.thirdPersonAnim = "pt_rodeo_trans_R2F"
		tf.firstPersonAnim = "ptpov_rodeo_trans_R2F"
		tf.worldSound = "Rodeo_Atlas_Rodeo_ClimbOn_Front_Exterior"
		tf.cockpitSound = "Rodeo_Atlas_Rodeo_ClimbOn_Front_Interior"

		tf = RodeoVehicleFlavor_AddTransition( vf,
			eRodeoTransitions_Titan.SHIFT_FROM_FRIENDLY_FRONT_TO_FRIENDLY_LEFT, eRodeoSpots_Titan.FRIENDLY_FRONT, eRodeoSpots_Titan.FRIENDLY_LEFT
		)
		tf.attachment = "hijack"
		tf.thirdPersonAnim = "pt_rodeo_trans_F2L"
		tf.firstPersonAnim = "ptpov_rodeo_trans_F2L"
		tf.worldSound = "Rodeo_Atlas_Rodeo_ClimbOn_Front_Exterior"
		tf.cockpitSound = "Rodeo_Atlas_Rodeo_ClimbOn_Front_Interior"

		tf = RodeoVehicleFlavor_AddTransition( vf,
			eRodeoTransitions_Titan.SHIFT_FROM_FRIENDLY_FRONT_TO_FRIENDLY_RIGHT, eRodeoSpots_Titan.FRIENDLY_FRONT, eRodeoSpots_Titan.FRIENDLY_RIGHT
		)
		tf.attachment = "hijack"
		tf.thirdPersonAnim = "pt_rodeo_trans_F2R"
		tf.firstPersonAnim = "ptpov_rodeo_trans_F2R"
		tf.worldSound = "Rodeo_Atlas_Rodeo_ClimbOn_Front_Exterior"
		tf.cockpitSound = "Rodeo_Atlas_Rodeo_ClimbOn_Front_Interior"

		//tf = RodeoVehicleFlavor_AddTransition( vf,
		//	eRodeoTransitions_Titan.DETACH_FRIENDLY_LEFT, eRodeoSpots_Titan.FRIENDLY_LEFT, RODEO_SENTINEL_END_SPOT_DETACH
		//)
		//tf.attachment = "hijack"
		//tf.thirdPersonAnim = "pt_rodeo_trans_L2F"
		//tf.firstPersonAnim = "ptpov_rodeo_trans_L2F"
		//tf.worldSound = "Rodeo_Jump_Off"
		//tf.cockpitSound = "Rodeo_Jump_Off_Interior"
		//
		//tf = RodeoVehicleFlavor_AddTransition( vf,
		//	eRodeoTransitions_Titan.DETACH_FRIENDLY_RIGHT, eRodeoSpots_Titan.FRIENDLY_RIGHT, RODEO_SENTINEL_END_SPOT_DETACH
		//)
		//tf.attachment = "hijack"
		//tf.thirdPersonAnim = "pt_rodeo_trans_R2F"
		//tf.firstPersonAnim = "ptpov_rodeo_trans_R2F"
		//tf.worldSound = "Rodeo_Jump_Off"
		//tf.cockpitSound = "Rodeo_Jump_Off_Interior"
		//
		//tf = RodeoVehicleFlavor_AddTransition( vf,
		//	eRodeoTransitions_Titan.DETACH_FRIENDLY_FRONT, eRodeoSpots_Titan.FRIENDLY_FRONT, RODEO_SENTINEL_END_SPOT_DETACH
		//)
		//tf.attachment = "hijack"
		//tf.thirdPersonAnim = "pt_rodeo_trans_F2L"
		//tf.firstPersonAnim = "ptpov_rodeo_trans_F2L"
		//tf.worldSound = "Rodeo_Jump_Off"
		//tf.cockpitSound = "Rodeo_Jump_Off_Interior"

		//tf = RodeoVehicleFlavor_AddTransition( vf,
		//	eRodeoTransitions_Titan.DETACH_ENEMY_FRONT, eRodeoSpots_Titan.ENEMY_FRONT, RODEO_SENTINEL_END_SPOT_DETACH
		//)
		//tf.attachment = "hijack"
		//tf.thirdPersonAnim = "pt_rodeo_trans_F2L"
		//tf.firstPersonAnim = "ptpov_rodeo_trans_F2L"
		//tf.worldSound = "Rodeo_Jump_Off"
		//tf.cockpitSound = "Rodeo_Jump_Off_Interior"

		tf = RodeoVehicleFlavor_AddTransition( vf,
			eRodeoTransitions_Titan.ACTION_OFFERITEM_FRIENDLY_LEFT, eRodeoSpots_Titan.FRIENDLY_LEFT, eRodeoSpots_Titan.FRIENDLY_LEFT
		)
		tf.transientSpotIndexList = [ eRodeoSpots_Titan.CENTRAL_ACTIVITY ]
		tf.attachment = "hijack"
		tf.thirdPersonAnim = "pt_rodeo_ride_L_return_battery"
		tf.firstPersonAnim = "ptpov_rodeo_ride_L_return_battery"
		tf.worldSound = "rodeo_heavy_battery_return_ext"
		tf.cockpitSound = "rodeo_heavy_battery_return_int"
		tf.doBasicAnim = true
		tf.execFunc = InternalDoTransitionActionOfferItem

		tf = RodeoVehicleFlavor_AddTransition( vf,
			eRodeoTransitions_Titan.ACTION_OFFERITEM_FRIENDLY_RIGHT, eRodeoSpots_Titan.FRIENDLY_RIGHT, eRodeoSpots_Titan.FRIENDLY_RIGHT
		)
		tf.transientSpotIndexList = [ eRodeoSpots_Titan.CENTRAL_ACTIVITY ]
		tf.attachment = "hijack"
		tf.thirdPersonAnim = "pt_rodeo_ride_R_return_battery"
		tf.firstPersonAnim = "ptpov_rodeo_ride_R_return_battery"
		tf.worldSound = "rodeo_heavy_battery_return_ext"
		tf.cockpitSound = "rodeo_heavy_battery_return_int"
		tf.doBasicAnim = true
		tf.execFunc = InternalDoTransitionActionOfferItem

		tf = RodeoVehicleFlavor_AddTransition( vf,
			eRodeoTransitions_Titan.ACTION_OFFERITEM_FRIENDLY_FRONT, eRodeoSpots_Titan.FRIENDLY_FRONT, eRodeoSpots_Titan.FRIENDLY_FRONT
		)
		tf.transientSpotIndexList = [ eRodeoSpots_Titan.CENTRAL_ACTIVITY ]
		tf.attachment = "hijack"
		// todo(dw): fix rodeo offering animation for friendly front
		tf.thirdPersonAnim = "pt_rodeo_ride_R_return_battery"
		tf.firstPersonAnim = "ptpov_rodeo_ride_R_return_battery"
		tf.worldSound = "rodeo_heavy_battery_return_ext"
		tf.cockpitSound = "rodeo_heavy_battery_return_int"
		tf.doBasicAnim = true
		tf.execFunc = InternalDoTransitionActionOfferItem
	}

	file.numRodeoSlots = vf.spotMap.len()
}


void function OnTitanSoulCreated( entity soul )
{
	if ( !IsValid( soul ) )
	{
		// todo(dw): remove this check
		Warning( "AddSpawnCallback( \"titan_soul\", ... ) callbacks were called with an INVALID soul entity: " + string( soul ) )
		return
	}

	thread RegisterTitanWhenExists( soul )
}


void function RegisterTitanWhenExists( entity soul )
{
	while( true )
	{
		if ( !IsValid( soul ) )
			return // the titan_soul may get destroyed immediately

		if ( soul.GetTitan() != null )
			break // wait for titan_soul to have an associated npc_titan or player

		WaitFrame() // todo(dw): find out if there's a better way to do this
	}
	Rodeo_RegisterVehicle( soul.GetTitan(), file.titanVehicleFlavor )
}


void function OnRodeoStarting( entity rider, entity vehicle )
{
	#if SERVER
		thread WatchForPlayerSwitchingSpots( rider )
		thread PROTO_PlayerConeThink( rider )
	#endif
	// todo(dw): predict spot change on client
	#if CLIENT
		if ( rider == GetLocalClientPlayer() )
		{
			AddPlayerHint( 7.0, 1.0, $"", "Press %jump% to detach\nPress %duck% to switch positions" ) // todo(dw): !
		}
	#endif

	foreach ( void functionref(entity, entity) callbackFunc in file.onTitanRodeoStartedCallbacks )
	{
		callbackFunc( rider, vehicle )
	}
}


void function OnRodeoFinishing( entity rider, entity vehicle )
{
	#if CLIENT
		if ( rider == GetLocalClientPlayer() )
		{
			HidePlayerHint( "Press %jump% to detach\nPress %duck% to switch positions" ) // todo(dw): !
		}
	#endif

	foreach ( void functionref(entity, entity) callbackFunc in file.onTitanRodeoEndedCallbacks )
	{
		callbackFunc( rider, vehicle ) // todo(dw): check AddOnRodeoTitanEndedCallback callbacks are being called at the right point (ending vs ended)
	}
}

#if SERVER
void function RodeoTitan_DoActionOfferItem( entity rider )
{
	int currentSpot = RodeoState_GetRiderCurrentSpot( rider )
	if ( currentSpot == eRodeoSpots_Titan.FRIENDLY_LEFT )
	{
		Rodeo_TriggerTransitionAndWait( rider, eRodeoTransitions_Titan.ACTION_OFFERITEM_FRIENDLY_LEFT )
	}
	else if ( currentSpot == eRodeoSpots_Titan.FRIENDLY_RIGHT )
	{
		Rodeo_TriggerTransitionAndWait( rider, eRodeoTransitions_Titan.ACTION_OFFERITEM_FRIENDLY_RIGHT )
	}
	else if ( currentSpot == eRodeoSpots_Titan.FRIENDLY_FRONT )
	{
		Rodeo_TriggerTransitionAndWait( rider, eRodeoTransitions_Titan.ACTION_OFFERITEM_FRIENDLY_FRONT )
	}
	else
		Assert( false )
}
#endif


void function InternalDoTransitionActionOfferItem( entity rider, entity titanSoul )
{
	entity titanPlayer = titanSoul.GetTitan()
	Assert( titanPlayer.IsPlayer() )

	rider.EndSignal( "RodeoTransitionEnded" )
	rider.EndSignal( "RodeoEnding" )
	titanPlayer.EndSignal( "RodeoOfferingEnded" )

	OnThreadEnd( function() : ( rider ) {
		//
	} )

	// todo(dw): yeah, this is hacky, but it will change when we get new animations
	float holdCycle = 0.47
	wait rider.GetSequenceDuration( "pt_rodeo_ride_L_return_battery" ) * holdCycle

	thread PROTO_HoldBatteryAnimation( rider, titanPlayer )

	titanPlayer.Signal( "RodeoOfferingReady" )

	table offerResult = titanPlayer.WaitSignal( "RodeoOfferingAccepted", "RodeoOfferingRejected" )

	if ( offerResult.signal == "RodeoOfferingAccepted" )
	{
		// todo(dw): .
	}
	else
	{
		// todo(dw): .
	}
}


void function PROTO_HoldBatteryAnimation( entity rider, entity titanPlayer )
{
	rider.EndSignal( "RodeoTransitionEnded" )
	rider.EndSignal( "RodeoEnding" )
	titanPlayer.EndSignal( "RodeoOfferingEnded", "RodeoOfferingAccepted", "RodeoOfferingRejected" )

	while ( true )
	{
		rider.SetCycle( 0.47 )
		rider.GetFirstPersonProxy().SetCycle( 0.47 )
		WaitFrame()
	}
}

//bool function RodeoTitan_IsRiderDoingOfferItemAction( entity rider )
//{
//	int currentTransitionIndex = RodeoState_GetRiderCurrentTransition( rider )
//	return (
//							currentTransitionIndex == eRodeoTransitions_Titan.ACTION_OFFERITEM_FRIENDLY_LEFT
//					|| currentTransitionIndex == eRodeoTransitions_Titan.ACTION_OFFERITEM_FRIENDLY_RIGHT
//					|| currentTransitionIndex == eRodeoTransitions_Titan.ACTION_OFFERITEM_FRIENDLY_FRONT
//			)
//}

#if SERVER
void function PROTO_PlayerConeThink( entity rider )
{
	rider.EndSignal( "RodeoEnded" )
	table threadState = {
		areWeaponsEnabled = true,
	}
	OnThreadEnd(
		function() : ( rider, threadState )
		{
			if ( !threadState.areWeaponsEnabled )
			{
				DeployAndEnableWeapons( rider )
			}
		}
	)
	while( true )
	{
		int currentSpot            = RodeoState_GetRiderCurrentSpot( rider )
		float threshold            = 0.09
		vector spotForwardRelAngle = <0, 0, 0>
		if ( currentSpot == eRodeoSpots_Titan.FRIENDLY_LEFT )
		{
			spotForwardRelAngle = <0, -15, 0>
		}
		else if ( currentSpot == eRodeoSpots_Titan.FRIENDLY_RIGHT )
		{
			spotForwardRelAngle = <0, 15, 0>
		}
		else if ( currentSpot == eRodeoSpots_Titan.FRIENDLY_FRONT )
		{
			spotForwardRelAngle = <0, 180, 0>
		}

		entity vehicle             = RodeoState_GetPlayerCurrentRodeoVehicle( rider ) // titan may have morphed from npc_titan to player
		vector spotForwardAbsAngle = AnglesCompose( <0, vehicle.EyeAngles().y, 0>, spotForwardRelAngle )
		vector spotForwardAbsDir   = AnglesToForward( spotForwardAbsAngle )
		vector riderDir            = AnglesToForward( rider.EyeAngles() )
		if ( !RodeoState_IsRiderBusy( rider ) && DotProduct( riderDir, spotForwardAbsDir ) < 0.2 )
		{
			if ( threadState.areWeaponsEnabled )
			{
				HolsterAndDisableWeapons( rider )
				threadState.areWeaponsEnabled = false
			}
			//rider.PlayerCone_SetMinYaw( 0 )
			//rider.PlayerCone_SetMaxYaw( 0 )
			//rider.PlayerCone_SetMinPitch( 0 )
			//rider.PlayerCone_SetMaxPitch( 0 )
			//rider.PlayerCone_SetSpecific( spotForwardAbsAngle )
		}
		else if ( !threadState.areWeaponsEnabled )
		{
			DeployAndEnableWeapons( rider )
			threadState.areWeaponsEnabled = true
			//rider.PlayerCone_Disable() // let the player look around
		}

		WaitFrame()
	}
}

void function OnPlayerDestroyed( entity player )
{
	//
}

void function OnPlayerPressedChangeSpotsKey( entity rider )
{
	file.riderWantsToChangeSpotsMap[rider] = true
	rider.Signal( "WantsToChangeRodeoSpot" )
}
void function OnPlayerReleasedChangeSpotsKey( entity rider )
{
	file.riderWantsToChangeSpotsMap[rider] = false
}
void function WatchForPlayerSwitchingSpots( entity rider )
{
	rider.EndSignal( "OnDeath" )
	rider.EndSignal( "RodeoEnding" )

	file.riderWantsToChangeSpotsMap[rider] <- false

	AddButtonPressedPlayerInputCallback( rider, IN_DUCK, OnPlayerPressedChangeSpotsKey )
	AddButtonPressedPlayerInputCallback( rider, IN_DUCKTOGGLE, OnPlayerPressedChangeSpotsKey )

	AddButtonReleasedPlayerInputCallback( rider, IN_DUCK, OnPlayerReleasedChangeSpotsKey )
	AddButtonReleasedPlayerInputCallback( rider, IN_DUCKTOGGLE, OnPlayerReleasedChangeSpotsKey )

	OnThreadEnd( function() : ( rider ) {
		delete file.riderWantsToChangeSpotsMap[rider]

		RemoveButtonPressedPlayerInputCallback( rider, IN_DUCK, OnPlayerPressedChangeSpotsKey )
		RemoveButtonPressedPlayerInputCallback( rider, IN_DUCKTOGGLE, OnPlayerPressedChangeSpotsKey )

		RemoveButtonReleasedPlayerInputCallback( rider, IN_DUCK, OnPlayerReleasedChangeSpotsKey )
		RemoveButtonReleasedPlayerInputCallback( rider, IN_DUCKTOGGLE, OnPlayerReleasedChangeSpotsKey )
	} )

	while( true )
	{
		if ( file.riderWantsToChangeSpotsMap[rider] )
		{
			if ( !RodeoState_IsRiderBusy( rider ) )
			{
				entity vehicle  = RodeoState_GetPlayerCurrentRodeoVehicle( rider ) // titan may have morphed from npc_titan to player
				int currentSpot = RodeoState_GetRiderCurrentSpot( rider )
				if ( currentSpot == eRodeoSpots_Titan.FRIENDLY_LEFT )
				{
					if ( RodeoState_CheckSpotsAreAvailable( vehicle, eRodeoSpots_Titan.FRIENDLY_RIGHT ) )
						Rodeo_TriggerTransitionAndWait( rider, eRodeoTransitions_Titan.SHIFT_FROM_FRIENDLY_LEFT_TO_FRIENDLY_RIGHT )
					else if ( RodeoState_CheckSpotsAreAvailable( vehicle, eRodeoSpots_Titan.FRIENDLY_FRONT ) )
						Rodeo_TriggerTransitionAndWait( rider, eRodeoTransitions_Titan.SHIFT_FROM_FRIENDLY_LEFT_TO_FRIENDLY_FRONT )
				}
				else if ( currentSpot == eRodeoSpots_Titan.FRIENDLY_RIGHT )
				{
					if ( RodeoState_CheckSpotsAreAvailable( vehicle, eRodeoSpots_Titan.FRIENDLY_FRONT ) )
						Rodeo_TriggerTransitionAndWait( rider, eRodeoTransitions_Titan.SHIFT_FROM_FRIENDLY_RIGHT_TO_FRIENDLY_FRONT )
					else if ( RodeoState_CheckSpotsAreAvailable( vehicle, eRodeoSpots_Titan.FRIENDLY_LEFT ) )
						Rodeo_TriggerTransitionAndWait( rider, eRodeoTransitions_Titan.SHIFT_FROM_FRIENDLY_RIGHT_TO_FRIENDLY_LEFT )
				}
				else if ( currentSpot == eRodeoSpots_Titan.FRIENDLY_FRONT )
				{
					if ( RodeoState_CheckSpotsAreAvailable( vehicle, eRodeoSpots_Titan.FRIENDLY_LEFT ) )
						Rodeo_TriggerTransitionAndWait( rider, eRodeoTransitions_Titan.SHIFT_FROM_FRIENDLY_FRONT_TO_FRIENDLY_LEFT )
					else if ( RodeoState_CheckSpotsAreAvailable( vehicle, eRodeoSpots_Titan.FRIENDLY_RIGHT ) )
						Rodeo_TriggerTransitionAndWait( rider, eRodeoTransitions_Titan.SHIFT_FROM_FRIENDLY_FRONT_TO_FRIENDLY_RIGHT )
				}
			}
			WaitFrame()
		}
		else
		{
			rider.WaitSignal( "WantsToChangeRodeoSpot" )
		}
	}
}

void function EnableTitanRodeo( entity titan )
{
	Assert( titan.IsTitan(), "tried calling EnableTitanRodeo on non-titan" )

	entity titanSoul = titan.GetTitanSoul()

	Assert( IsValid( titanSoul ) )

	titanSoul.SetIsValidRodeoTarget( true ) //Lets rodeo happen on them.
}

void function DisableTitanRodeo( entity titan )
{
	Assert( titan.IsTitan(), "tried calling DisableTitanRodeo( on non-titan" )

	entity titanSoul = titan.GetTitanSoul()

	Assert( IsValid( titanSoul ) )

	titanSoul.SetIsValidRodeoTarget( false ) //Stops rodeo from happening on them.
}

void function GiveFriendlyRodeoPlayerProtection( entity titan )
{
	//Assert( false ) // todo(dw): fix rodeo protection
}
void function TakeAwayFriendlyRodeoPlayerProtection( entity titan )
{
	//Assert( false ) // todo(dw): fix rodeo protection
}
#endif

void function AddOnRodeoTitanStartedCallback( void functionref(entity, entity) callbackFunc )
{
	Assert( !(file.onTitanRodeoStartedCallbacks.contains( callbackFunc )) )
	file.onTitanRodeoStartedCallbacks.append( callbackFunc )
}


void function AddOnRodeoTitanEndedCallback( void functionref(entity, entity) callbackFunc )
{
	Assert( !(file.onTitanRodeoEndedCallbacks.contains( callbackFunc )) )
	file.onTitanRodeoEndedCallbacks.append( callbackFunc )
}


int function GetAttachTransition( entity rider, entity titan )
{
	entity soul = titan.GetTitanSoul()
	if ( soul.IsEjecting() )
		return RODEO_SENTINEL_TRANSITION_NONE

	FrontRightDotProductsStruct dots = GetFrontRightDots( titan, rider )

	//if ( rider.GetTeam() != titan.GetTeam() )
	//{
	//	// enemy
	//	bool frontPreferred = (dots.forwardDot > 0)
	//	bool frontAvailable = RodeoState_CheckSpotsAreAvailable( titan, eRodeoSpots_Titan.ENEMY_FRONT )
	//	if ( frontAvailable && frontPreferred )
	//	{
	//		return eRodeoTransitions_Titan.ATTACH_ENEMY_FRONT
	//	}
	//	// todo(dw): add enemy rear
	//	return RODEO_SENTINEL_TRANSITION_NONE
	//}

	// friendly
	bool frontPreferred = (dots.forwardDot > 0)
	bool leftPreferred  = (dots.rightDot < 0)
	bool rightPreferred = (dots.rightDot >= 0)

	bool frontAvailable = RodeoState_CheckSpotsAreAvailable( titan, eRodeoSpots_Titan.FRIENDLY_FRONT )
	bool leftAvailable  = RodeoState_CheckSpotsAreAvailable( titan, eRodeoSpots_Titan.FRIENDLY_LEFT )
	bool rightAvailable = RodeoState_CheckSpotsAreAvailable( titan, eRodeoSpots_Titan.FRIENDLY_RIGHT )

	if ( frontAvailable && frontPreferred )
	{
		return eRodeoTransitions_Titan.ATTACH_FRIENDLY_FRONT_FROM_FRONT_LEFT_LOWER
	}
	if ( leftAvailable && leftPreferred )
	{
		return eRodeoTransitions_Titan.ATTACH_FRIENDLY_LEFT_FROM_FRONT_LEFT_LOWER
	}
	if ( rightAvailable && !leftPreferred )
	{
		return eRodeoTransitions_Titan.ATTACH_FRIENDLY_RIGHT_FROM_FRONT_RIGHT_LOWER
	}

	// todo(dw): check rodeo spot preferences
	if ( frontAvailable )
	{
		return eRodeoTransitions_Titan.ATTACH_FRIENDLY_FRONT_FROM_FRONT_LEFT_LOWER
	}
	if ( leftAvailable )
	{
		return eRodeoTransitions_Titan.ATTACH_FRIENDLY_LEFT_FROM_FRONT_LEFT_LOWER
	}
	if ( rightAvailable )
	{
		return eRodeoTransitions_Titan.ATTACH_FRIENDLY_RIGHT_FROM_FRONT_RIGHT_LOWER
	}

	return RODEO_SENTINEL_TRANSITION_NONE
}

#if SERVER
void function OnTitanDoomed( entity victim, var damageInfo )
{
	//
}
#endif

//
//void function TitanBeingRodeoed_Start( RodeoRiderState riderState )
//{
//	entity soul  = riderState.vehicleStateEnt
//	entity titan = soul.GetTitan()
//
//	if ( soul.GetShieldHealth() > 0.0 )
//		// This was not evaluating properly with 0 being an int, so make it a float which works
//		GiveFriendlyRodeoPlayerProtection( titan )
//
//
//	//if ( !sameTeam && !PlayerHasStealthMovement( riderState.rider ) )
//	//	soul.SetLastRodeoHitTime( Time() ) // Alert Titan immediately if you don't have passive
//
//	//soul.soul.batteryMovedDown = false
//	//if ( ShouldThrowGrenadeInHatch( riderState.rider, vehicle ) )
//	//	//Either player is going to apply a battery, or it's going to throw a grenade. In either case, we want the battery to move
//	//{
//	//	Rodeo_MoveBatteryDown( soul )
//	//}
//	//
//	//soul.soul.batteryContainerBeingUsed = true //All rodeo points mark batteryContainer as being true, various exit points mark it as being false when they are done cleaning it up (e.g. playing the appropriate battery going up/down anims)
//
//	if ( riderState.rider.GetTeam() != titan.GetTeam() )
//	{
//		#if FACTION_DIALOGUE_ENABLED
//			thread PlayRodeoFactionDialogueAfterDelay( riderState.rider, 0.5 )
//		#endif
//		TitanVO_AlertTitansVehicleingThisTitanOfRodeo( riderState.rider, soul )
//	}
//
//	if ( !(riderState.rider in soul.soul.rodeoRiderTracker) )
//	{
//		soul.soul.rodeoRiderTracker[ riderState.rider ] <- true
//		if ( IsFriendlyTeam( titan.GetTeam(), riderState.rider.GetTeam() ) )
//		{
//			AddPlayerScore( riderState.rider, "HitchRide" )
//			AddPlayerScore( titan, "GiveRide" )
//		}
//		else
//		{
//			AddPlayerScore( riderState.rider, "RodeoEnemyTitan" )
//
//#if HAS_STATS
//			UpdatePlayerStat( riderState.rider, "misc_stats", "rodeos" )
//
//			if ( riderState.playerWasEjecting )
//				UpdatePlayerStat( riderState.rider, "misc_stats", "rodeosFromEject" )
//#endif
//
//			#if (MP && !MP_CAMPAIGNCOOP)
//				PIN_AddToPlayerCountStat( riderState.rider, "rodeos" )
//				if ( titan.IsPlayer() )
//					PIN_AddToPlayerCountStat( titan, "rodeo_receives" )
//			#endif
//		}
//	}
//}
//
//
//void function TitanBeingRodeoed_End( RodeoRiderState riderState )
//{
//	entity soul  = riderState.vehicleStateEnt
//	entity titan = soul.GetTitan()
//
//	foreach ( callbackFunc in file.onTitanRodeoEndedCallbacks )
//	{
//		callbackFunc( riderState.rider, titan )
//	}
//
//	if ( soul.soul.batteryContainerBeingUsed && riderState.playerHadBatteryAtStartOfRodeo )
//	{
//		// i.e. rodeo got interruped early
//		string titanType        = GetSoulTitanSubClass( soul )
//		entity batteryContainer = soul.soul.batteryContainer
//		batteryContainer.Anim_Play( GetAnimFromAlias( titanType, "hatch_rodeo_up" ) )
//		soul.soul.batteryContainerBeingUsed = false
//	}
//
//	// if the player is invalid, we still need to enable rodeo on the titan
//	// normally this would happen in Rodeo_Detach(), but that only works if the player is valid
//	if ( !IsValid( riderState.rider ) )
//	{
//		EnableTitanRodeo( titan )
//	}
//}

void function InitAnims()
{
	// Movement anims
	AddAnimAlias( "ogre", "ptpov_rodeo_move_back_idle", "ptpov_rodeo_move_ogre_back_idle" )
	AddAnimAlias( "ogre", "ptpov_rodeo_move_back_entrance", "ptpov_rodeo_move_ogre_back_entrance" )
	AddAnimAlias( "ogre", "ptpov_rodeo_move_right_entrance", "ptpov_rodeo_move_ogre_right_entrance" )
	AddAnimAlias( "ogre", "ptpov_rodeo_move_front_entrance", "ptpov_rodeo_move_ogre_front_entrance" )
	AddAnimAlias( "ogre", "ptpov_rodeo_move_front_lower_entrance", "ptpov_rodeo_move_ogre_front_lower_entrance" )
	AddAnimAlias( "ogre", "ptpov_rodeo_move_back_mid_entrance", "ptpov_rodeo_move_ogre_back_mid_entrance" )
	AddAnimAlias( "ogre", "ptpov_rodeo_move_back_lower_entrance", "ptpov_rodeo_move_ogre_back_lower_entrance" )
	AddAnimAlias( "ogre", "ptpov_rodeo_move_left_entrance", "ptpov_rodeo_move_ogre_left_entrance" )
	AddAnimAlias( "ogre", "pt_rodeo_move_back_idle", "pt_rodeo_move_ogre_back_idle" )
	AddAnimAlias( "ogre", "pt_rodeo_move_right_entrance", "pt_rodeo_move_ogre_right_entrance" )
	AddAnimAlias( "ogre", "pt_rodeo_move_back_entrance", "pt_rodeo_move_ogre_back_entrance" )
	AddAnimAlias( "ogre", "pt_rodeo_move_front_entrance", "pt_rodeo_move_ogre_front_entrance" )
	AddAnimAlias( "ogre", "pt_rodeo_move_front_lower_entrance", "pt_rodeo_move_ogre_front_lower_entrance" )
	AddAnimAlias( "ogre", "pt_rodeo_move_back_mid_entrance", "pt_rodeo_move_ogre_back_mid_entrance" )
	AddAnimAlias( "ogre", "pt_rodeo_move_back_lower_entrance", "pt_rodeo_move_ogre_back_lower_entrance" )
	AddAnimAlias( "ogre", "pt_rodeo_move_left_entrance", "pt_rodeo_move_ogre_left_entrance" )

	AddAnimAlias( "atlas", "ptpov_rodeo_move_back_idle", "ptpov_rodeo_move_atlas_back_idle" )
	AddAnimAlias( "atlas", "ptpov_rodeo_move_back_entrance", "ptpov_rodeo_move_atlas_back_entrance" )
	AddAnimAlias( "atlas", "ptpov_rodeo_move_front_entrance", "ptpov_rodeo_move_atlas_front_entrance" )
	AddAnimAlias( "atlas", "ptpov_rodeo_move_front_lower_entrance", "ptpov_rodeo_move_atlas_front_lower_entrance" )
	AddAnimAlias( "atlas", "ptpov_rodeo_move_back_mid_entrance", "ptpov_rodeo_move_atlas_back_mid_entrance" )
	AddAnimAlias( "atlas", "ptpov_rodeo_move_back_lower_entrance", "ptpov_rodeo_move_atlas_back_lower_entrance" )
	AddAnimAlias( "atlas", "ptpov_rodeo_move_left_entrance", "ptpov_rodeo_move_atlas_left_entrance" )
	AddAnimAlias( "atlas", "ptpov_rodeo_move_right_entrance", "ptpov_rodeo_move_atlas_right_entrance" )
	AddAnimAlias( "atlas", "pt_rodeo_move_back_idle", "pt_rodeo_move_atlas_back_idle" )
	AddAnimAlias( "atlas", "pt_rodeo_move_back_entrance", "pt_rodeo_move_atlas_back_entrance" )
	AddAnimAlias( "atlas", "pt_rodeo_move_front_entrance", "pt_rodeo_move_atlas_front_entrance" )
	AddAnimAlias( "atlas", "pt_rodeo_move_front_lower_entrance", "pt_rodeo_move_atlas_front_lower_entrance" )
	AddAnimAlias( "atlas", "pt_rodeo_move_back_mid_entrance", "pt_rodeo_move_atlas_back_mid_entrance" )
	AddAnimAlias( "atlas", "pt_rodeo_move_back_lower_entrance", "pt_rodeo_move_atlas_back_lower_entrance" )
	AddAnimAlias( "atlas", "pt_rodeo_move_left_entrance", "pt_rodeo_move_atlas_left_entrance" )    // needs update
	AddAnimAlias( "atlas", "pt_rodeo_move_right_entrance", "pt_rodeo_move_atlas_right_entrance" )    // needs update

	AddAnimAlias( "buddy", "ptpov_rodeo_move_back_idle", "ptpov_rodeo_move_buddy_back_idle" )
	AddAnimAlias( "buddy", "ptpov_rodeo_move_back_entrance", "ptpov_rodeo_move_buddy_back_entrance" )
	AddAnimAlias( "buddy", "ptpov_rodeo_move_front_entrance", "ptpov_rodeo_move_buddy_front_entrance" )
	AddAnimAlias( "buddy", "ptpov_rodeo_move_front_lower_entrance", "ptpov_rodeo_move_buddy_front_lower_entrance" )
	AddAnimAlias( "buddy", "ptpov_rodeo_move_back_mid_entrance", "ptpov_rodeo_move_buddy_back_mid_entrance" )
	AddAnimAlias( "buddy", "ptpov_rodeo_move_back_lower_entrance", "ptpov_rodeo_move_buddy_back_lower_entrance" )
	AddAnimAlias( "buddy", "ptpov_rodeo_move_left_entrance", "ptpov_rodeo_move_buddy_left_entrance" )
	AddAnimAlias( "buddy", "ptpov_rodeo_move_right_entrance", "ptpov_rodeo_move_buddy_right_entrance" )
	AddAnimAlias( "buddy", "pt_rodeo_move_back_idle", "pt_rodeo_move_buddy_back_idle" )
	AddAnimAlias( "buddy", "pt_rodeo_move_back_entrance", "pt_rodeo_move_buddy_back_entrance" )
	AddAnimAlias( "buddy", "pt_rodeo_move_front_entrance", "pt_rodeo_move_buddy_front_entrance" )
	AddAnimAlias( "buddy", "pt_rodeo_move_front_lower_entrance", "pt_rodeo_move_buddy_front_lower_entrance" )
	AddAnimAlias( "buddy", "pt_rodeo_move_back_mid_entrance", "pt_rodeo_move_buddy_back_mid_entrance" )
	AddAnimAlias( "buddy", "pt_rodeo_move_back_lower_entrance", "pt_rodeo_move_buddy_back_lower_entrance" )
	AddAnimAlias( "buddy", "pt_rodeo_move_left_entrance", "pt_rodeo_move_buddy_left_entrance" )    // needs update
	AddAnimAlias( "buddy", "pt_rodeo_move_right_entrance", "pt_rodeo_move_buddy_right_entrance" )    // needs update

	AddAnimAlias( "stryder", "ptpov_rodeo_move_back_idle", "ptpov_rodeo_move_stryder_back_idle" )
	AddAnimAlias( "stryder", "ptpov_rodeo_move_back_entrance", "ptpov_rodeo_move_stryder_back_entrance" )
	AddAnimAlias( "stryder", "ptpov_rodeo_move_right_entrance", "ptpov_rodeo_move_stryder_right_entrance" )
	AddAnimAlias( "stryder", "ptpov_rodeo_move_front_entrance", "ptpov_rodeo_move_stryder_front_entrance" )
	AddAnimAlias( "stryder", "ptpov_rodeo_move_front_lower_entrance", "ptpov_rodeo_move_stryder_front_lower_entrance" )
	AddAnimAlias( "stryder", "ptpov_rodeo_move_back_mid_entrance", "ptpov_rodeo_move_stryder_back_mid_entrance" )
	AddAnimAlias( "stryder", "ptpov_rodeo_move_back_lower_entrance", "ptpov_rodeo_move_stryder_back_lower_entrance" )
	AddAnimAlias( "stryder", "ptpov_rodeo_move_left_entrance", "ptpov_rodeo_move_stryder_left_entrance" )
	AddAnimAlias( "stryder", "pt_rodeo_move_back_idle", "pt_rodeo_move_stryder_back_idle" )
	AddAnimAlias( "stryder", "pt_rodeo_move_back_entrance", "pt_rodeo_move_stryder_back_entrance" )
	AddAnimAlias( "stryder", "pt_rodeo_move_right_entrance", "pt_rodeo_move_stryder_right_entrance" )
	AddAnimAlias( "stryder", "pt_rodeo_move_front_entrance", "pt_rodeo_move_stryder_front_entrance" )
	AddAnimAlias( "stryder", "pt_rodeo_move_front_lower_entrance", "pt_rodeo_move_stryder_front_lower_entrance" )
	AddAnimAlias( "stryder", "pt_rodeo_move_back_mid_entrance", "pt_rodeo_move_stryder_back_mid_entrance" )
	AddAnimAlias( "stryder", "pt_rodeo_move_back_lower_entrance", "pt_rodeo_move_stryder_back_lower_entrance" )
	AddAnimAlias( "stryder", "pt_rodeo_move_left_entrance", "pt_rodeo_move_stryder_left_entrance" )

	// Panel rip anims
	AddAnimAlias( "atlas", "pt_rodeo_panel_fire", "pt_rodeo_panel_fire" )
	AddAnimAlias( "atlas", "at_rodeo_panel_opening", "hatch_rodeo_R_hijack_battery" )
	AddAnimAlias( "atlas", "at_rodeo_panel_close_idle", "hatch_rodeo_panel_close_idle" )
	AddAnimAlias( "atlas", "at_Rodeo_Panel_Damage_State_0_Idle", "hatch_Rodeo_Panel_Damage_State_0_Idle" )
	AddAnimAlias( "atlas", "at_Rodeo_Panel_Damage_State_1_Idle", "hatch_Rodeo_Panel_Damage_State_1_Idle" )
	AddAnimAlias( "atlas", "at_Rodeo_Panel_Damage_State_2_Idle", "hatch_Rodeo_Panel_Damage_State_2_Idle" )
	AddAnimAlias( "atlas", "at_Rodeo_Panel_Damage_State_3_Idle", "hatch_Rodeo_Panel_Damage_State_3_Idle" )
	AddAnimAlias( "atlas", "at_Rodeo_Panel_Damage_State_4_Idle", "hatch_Rodeo_Panel_Damage_State_final_Idle" )
	AddAnimAlias( "atlas", "pt_rodeo_panel_opening", "pt_rodeo_ride_R_hijack_battery" )
	AddAnimAlias( "atlas", "pt_rodeo_panel_aim_idle", "pt_rodeo_ride_R_idle" )
	AddAnimAlias( "atlas", "pt_rodeo_player_side_lean", "pt_rodeo_player_side_lean" )
	AddAnimAlias( "atlas", "ptpov_rodeo_panel_opening", "ptpov_rodeo_ride_R_hijack_battery" )
	AddAnimAlias( "atlas", "ptpov_rodeo_panel_aim_idle", "ptpov_rodeo_ride_R_idle" )
	AddAnimAlias( "atlas", "ptpov_rodeo_panel_aim_idle_move", "ptpov_rodeo_panel_aim_idle_move" )
	AddAnimAlias( "atlas", "ptpov_rodeo_player_side_lean_enemy", "ptpov_rodeo_player_side_lean" )

	AddAnimAlias( "buddy", "pt_rodeo_panel_fire", "pt_rodeo_panel_fire" )
	AddAnimAlias( "buddy", "at_rodeo_panel_opening", "hatch_rodeo_panel_opening" )
	AddAnimAlias( "buddy", "at_rodeo_panel_close_idle", "hatch_rodeo_panel_close_idle" )
	AddAnimAlias( "buddy", "at_Rodeo_Panel_Damage_State_0_Idle", "hatch_Rodeo_Panel_Damage_State_0_Idle" )
	AddAnimAlias( "buddy", "at_Rodeo_Panel_Damage_State_1_Idle", "hatch_Rodeo_Panel_Damage_State_1_Idle" )
	AddAnimAlias( "buddy", "at_Rodeo_Panel_Damage_State_2_Idle", "hatch_Rodeo_Panel_Damage_State_2_Idle" )
	AddAnimAlias( "buddy", "at_Rodeo_Panel_Damage_State_3_Idle", "hatch_Rodeo_Panel_Damage_State_3_Idle" )
	AddAnimAlias( "buddy", "at_Rodeo_Panel_Damage_State_4_Idle", "hatch_Rodeo_Panel_Damage_State_final_Idle" )
	AddAnimAlias( "buddy", "pt_rodeo_panel_opening", "pt_rodeo_panel_opening" )
	AddAnimAlias( "buddy", "pt_rodeo_panel_aim_idle", "pt_rodeo_panel_aim_idle_move" )
	AddAnimAlias( "buddy", "pt_rodeo_player_side_lean", "pt_rodeo_player_side_lean" )
	AddAnimAlias( "buddy", "ptpov_rodeo_panel_opening", "ptpov_rodeo_panel_opening" )
	AddAnimAlias( "buddy", "ptpov_rodeo_panel_aim_idle", "ptpov_rodeo_panel_aim_idle" )
	AddAnimAlias( "buddy", "ptpov_rodeo_panel_aim_idle_move", "ptpov_rodeo_panel_aim_idle_move" )
	AddAnimAlias( "buddy", "ptpov_rodeo_player_side_lean_enemy", "ptpov_rodeo_player_side_lean" )

	AddAnimAlias( "ogre", "pt_rodeo_panel_fire", "pt_rodeo_ogre_panel_fire" )
	AddAnimAlias( "ogre", "at_rodeo_panel_opening", "hatch_rodeo_R_hijack_battery" )
	AddAnimAlias( "ogre", "at_rodeo_panel_close_idle", "hatch_rodeo_panel_close_idle" )
	AddAnimAlias( "ogre", "at_Rodeo_Panel_Damage_State_0_Idle", "hatch_Rodeo_Panel_Damage_State_0_Idle" )
	AddAnimAlias( "ogre", "at_Rodeo_Panel_Damage_State_1_Idle", "hatch_Rodeo_Panel_Damage_State_1_Idle" )
	AddAnimAlias( "ogre", "at_Rodeo_Panel_Damage_State_2_Idle", "hatch_Rodeo_Panel_Damage_State_2_Idle" )
	AddAnimAlias( "ogre", "at_Rodeo_Panel_Damage_State_3_Idle", "hatch_Rodeo_Panel_Damage_State_3_Idle" )
	AddAnimAlias( "ogre", "at_Rodeo_Panel_Damage_State_4_Idle", "hatch_Rodeo_Panel_Damage_State_final_Idle" )
	AddAnimAlias( "ogre", "pt_rodeo_panel_opening", "pt_rodeo_ogre_hijack_battery" )
	AddAnimAlias( "ogre", "pt_rodeo_panel_aim_idle", "pt_rodeo_ogre_panel_aim_idle_move" )
	AddAnimAlias( "ogre", "pt_rodeo_player_side_lean", "pt_rodeo_ogre_player_side_lean" )
	AddAnimAlias( "ogre", "ptpov_rodeo_panel_opening", "ptpov_rodeo_ogre_R_hijack_battery" )
	AddAnimAlias( "ogre", "ptpov_rodeo_panel_aim_idle", "ptpov_ogre_rodeo_panel_aim_idle" )
	AddAnimAlias( "ogre", "ptpov_rodeo_panel_aim_idle_move", "ptpov_ogre_rodeo_panel_aim_idle_move" )
	AddAnimAlias( "ogre", "ptpov_rodeo_player_side_lean_enemy", "ptpov_Rodeo_ogre_player_side_lean" )

	AddAnimAlias( "stryder", "pt_rodeo_panel_fire", "pt_rodeo_stryder_panel_fire" )
	AddAnimAlias( "stryder", "at_rodeo_panel_opening", "hatch_rodeo_panel_opening" )
	AddAnimAlias( "stryder", "at_rodeo_panel_close_idle", "hatch_rodeo_panel_close_idle" )
	AddAnimAlias( "stryder", "at_Rodeo_Panel_Damage_State_0_Idle", "hatch_Rodeo_Panel_Damage_State_0_Idle" )
	AddAnimAlias( "stryder", "at_Rodeo_Panel_Damage_State_1_Idle", "hatch_Rodeo_Panel_Damage_State_1_Idle" )
	AddAnimAlias( "stryder", "at_Rodeo_Panel_Damage_State_2_Idle", "hatch_Rodeo_Panel_Damage_State_2_Idle" )
	AddAnimAlias( "stryder", "at_Rodeo_Panel_Damage_State_3_Idle", "hatch_Rodeo_Panel_Damage_State_3_Idle" )
	AddAnimAlias( "stryder", "at_Rodeo_Panel_Damage_State_4_Idle", "hatch_Rodeo_Panel_Damage_State_final_Idle" )
	AddAnimAlias( "stryder", "pt_rodeo_panel_opening", "pt_rodeo_stryder_panel_opening" )
	AddAnimAlias( "stryder", "pt_rodeo_panel_aim_idle", "pt_rodeo_stryder_panel_aim_idle_move" )
	AddAnimAlias( "stryder", "pt_rodeo_player_side_lean", "pt_rodeo_stryder_player_side_lean" )
	AddAnimAlias( "stryder", "ptpov_rodeo_panel_opening", "ptpov_rodeo_stryder_panel_opening" )
	AddAnimAlias( "stryder", "ptpov_rodeo_panel_aim_idle", "ptpov_stryder_rodeo_panel_aim_idle" )
	AddAnimAlias( "stryder", "ptpov_rodeo_panel_aim_idle_move", "ptpov_stryder_rodeo_panel_aim_idle_move" )
	AddAnimAlias( "stryder", "ptpov_rodeo_player_side_lean_enemy", "ptpov_Rodeo_stryder_player_side_lean" )

	//Battery Style rodeo
	AddAnimAlias( "atlas", "pt_rodeo_back_right_hijack_battery", "pt_rodeo_ride_R_hijack_battery" )
	AddAnimAlias( "atlas", "pt_rodeo_back_right_apply_battery", "pt_rodeo_ride_R_return_battery" )
	AddAnimAlias( "atlas", "pt_rodeo_back_right_idle", "pt_rodeo_ride_R_idle" )
	AddAnimAlias( "atlas", "pt_rodeo_grenade", "pt_rodeo_medium_grenade_1st" )
	AddAnimAlias( "atlas", "ptpov_rodeo_back_right_hijack_battery", "ptpov_rodeo_ride_R_hijack_battery" )
	AddAnimAlias( "atlas", "ptpov_rodeo_back_right_apply_battery", "ptpov_rodeo_ride_R_return_battery" )
	AddAnimAlias( "atlas", "ptpov_rodeo_back_right_idle", "ptpov_rodeo_ride_R_idle" )
	AddAnimAlias( "atlas", "ptpov_rodeo_grenade", "ptpov_rodeo_medium_grenade_1st" )

	AddAnimAlias( "atlas", "hatch_rodeo_up_idle", "hatch_rodeo_medium_up_idle" )
	AddAnimAlias( "atlas", "hatch_rodeo_up", "hatch_rodeo_medium_up" )
	AddAnimAlias( "atlas", "hatch_rodeo_down_idle", "hatch_rodeo_medium_down_idle" )
	AddAnimAlias( "atlas", "hatch_rodeo_down", "hatch_rodeo_medium_down" )

	AddAnimAlias( "ogre", "pt_rodeo_back_right_hijack_battery", "pt_rodeo_ogre_hijack_battery" )
	AddAnimAlias( "ogre", "pt_rodeo_back_right_apply_battery", "pt_rodeo_ogre_return_battery" )
	AddAnimAlias( "ogre", "pt_rodeo_back_right_idle", "pt_rodeo_ogre_panel_aim_idle_move" )
	AddAnimAlias( "ogre", "pt_rodeo_grenade", "pt_rodeo_heavy_grenade_1st" )
	AddAnimAlias( "ogre", "ptpov_rodeo_back_right_hijack_battery", "ptpov_rodeo_ogre_R_hijack_battery" )
	AddAnimAlias( "ogre", "ptpov_rodeo_back_right_apply_battery", "ptpov_rodeo_ogre_R_return_battery" )
	AddAnimAlias( "ogre", "ptpov_rodeo_back_right_idle", "ptpov_ogre_rodeo_panel_aim_idle" )
	AddAnimAlias( "ogre", "ptpov_rodeo_grenade", "ptpov_rodeo_heavy_grenade_1st" )
	AddAnimAlias( "ogre", "hatch_rodeo_up_idle", "hatch_rodeo_heavy_up_idle" )
	AddAnimAlias( "ogre", "hatch_rodeo_up", "hatch_rodeo_heavy_up" )
	AddAnimAlias( "ogre", "hatch_rodeo_down_idle", "hatch_rodeo_heavy_down_idle" )
	AddAnimAlias( "ogre", "hatch_rodeo_down", "hatch_rodeo_heavy_down" )

	AddAnimAlias( "stryder", "pt_rodeo_back_right_hijack_battery", "pt_rodeo_stryder_ride_R_hijack_battery" )
	AddAnimAlias( "stryder", "pt_rodeo_back_right_apply_battery", "pt_rodeo_stryder_ride_R_return_battery" )
	AddAnimAlias( "stryder", "pt_rodeo_back_right_idle", "pt_rodeo_stryder_panel_aim_idle_move" )
	AddAnimAlias( "stryder", "pt_rodeo_grenade", "pt_rodeo_light_grenade_1st" )
	AddAnimAlias( "stryder", "ptpov_rodeo_back_right_hijack_battery", "ptpov_rodeo_stryder_R_hijack_battery" )
	AddAnimAlias( "stryder", "ptpov_rodeo_back_right_apply_battery", "ptpov_rodeo_stryder_R_return_battery" )
	AddAnimAlias( "stryder", "ptpov_rodeo_back_right_idle", "ptpov_stryder_rodeo_panel_aim_idle" )
	AddAnimAlias( "stryder", "ptpov_rodeo_grenade", "ptpov_rodeo_light_grenade_1st" )
	AddAnimAlias( "stryder", "hatch_rodeo_up_idle", "hatch_rodeo_light_up_idle" )
	AddAnimAlias( "stryder", "hatch_rodeo_up", "hatch_rodeo_light_up" )
	AddAnimAlias( "stryder", "hatch_rodeo_down_idle", "hatch_rodeo_light_down_idle" )
	AddAnimAlias( "stryder", "hatch_rodeo_down", "hatch_rodeo_light_down" )

	AddAnimAlias( "atlas", "pt_nuke_rodeo_back_right_apply_battery", "pt_nuke_rodeo_ride_R_return_battery" )
	AddAnimAlias( "atlas", "ptpov_nuke_rodeo_back_right_apply_battery", "ptpov_nuke_rodeo_ride_R_return_battery" )
	AddAnimAlias( "ogre", "pt_nuke_rodeo_back_right_apply_battery", "pt_nuke_rodeo_ogre_return_battery" )
	AddAnimAlias( "ogre", "ptpov_nuke_rodeo_back_right_apply_battery", "ptpov_nuke_rodeo_ogre_R_return_battery" )
	AddAnimAlias( "stryder", "pt_nuke_rodeo_back_right_apply_battery", "pt_nuke_rodeo_stryder_ride_R_return_battery" )
	AddAnimAlias( "stryder", "ptpov_nuke_rodeo_back_right_apply_battery", "ptpov_nuke_rodeo_stryder_R_return_battery" )
}
