// By (--__GimmYnkia__--)#2995 and @CafeFPS

global function MpPortableBeacon_Init

global function OnWeaponPrimaryAttack_weapon_beacon

global function OnWeaponActivate_beacon
global function OnWeaponDeactivate_beacon


const asset MOBILE_DROP_FX = $"P_ar_ping_squad_CP"
const asset RING_FX = $"P_ar_ping_squad_CP"

void function MpPortableBeacon_Init()
{
	#if SERVER
	PrecacheModel( MOBILE_RESPAWN_BEACON_MODEL )
	RegisterSignal( "DeployablePortableBeacon" )
	PrecacheParticleSystem(MOBILE_DROP_FX)
	PrecacheParticleSystem($"P_fire_jet_med_nomdl")
	PrecacheParticleSystem($"P_phase_shift_out")
	RegisterSignal("ForceEndJetWashFX")
	PrecacheParticleSystem($"P_ar_ping_arrow_CP")
	PrecacheParticleSystem( RING_FX )
	#endif

	#if CLIENT
		StatusEffect_RegisterEnabledCallback( eStatusEffect.placing_respawn_beacon, OnBeginPlacingBeacon )
		StatusEffect_RegisterDisabledCallback( eStatusEffect.placing_respawn_beacon, OnEndPlacingBeacon )
	#endif
}

void function OnWeaponActivate_beacon( entity weapon )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	Assert( ownerPlayer.IsPlayer() )

	#if CLIENT
		SetCarePackageDeployed( false )
		if ( !InPrediction() ) //Stopgap fix for Bug 146443
			return
	#endif


	#if SERVER
		StatusEffect_AddEndless( ownerPlayer, eStatusEffect.placing_respawn_beacon, 1.0 )
		//ownerPlayer.Server_TurnOffhandWeaponsDisabledOn()
	#endif
}


void function OnWeaponDeactivate_beacon( entity weapon )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	Assert( ownerPlayer.IsPlayer() )

	#if CLIENT
		if ( !InPrediction() ) //Stopgap fix for Bug 146443
			return
	ownerPlayer.Signal( "DeployableCarePackagePlacement" )
	#endif

	#if SERVER
		StatusEffect_StopAllOfType( ownerPlayer, eStatusEffect.placing_respawn_beacon )
		//ownerPlayer.Server_TurnOffhandWeaponsDisabledOff()
	#endif
}


var function OnWeaponPrimaryAttack_weapon_beacon( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	Assert( ownerPlayer.IsPlayer() )

	if ( ownerPlayer.IsPhaseShifted() )
		return 0

	CarePackagePlacementInfo placementInfo = GetCarePackagePlacementInfo( ownerPlayer )

	if ( placementInfo.failed )
		return 0

	#if SERVER
		vector origin = placementInfo.origin
		vector angles = placementInfo.angles

        //Start the ground circle particle
		entity fx = StartParticleEffectInWorld_ReturnEntity(GetParticleSystemIndex( RING_FX ), origin, angles)
		EffectSetControlPointVector( fx, 1, TEAM_COLOR_FRIENDLY )
		
		thread CreateBeacondrop(
			origin, angles,
			fx, "droppod_loot_drop_lifeline",
			ownerPlayer, weapon.GetWeaponClassName()
		)


		PlayerUsedOffhand( ownerPlayer, weapon, true, null, {pos = origin} )
	#else
		PlayerUsedOffhand( ownerPlayer, weapon )
		SetCarePackageDeployed( true )
		#if SERVER
		ownerPlayer.Signal( "DeployablePortableBeacon" )
		#endif
	#endif

	int ammoReq = weapon.GetAmmoPerShot()
	return ammoReq
}


#if CLIENT
void function OnBeginPlacingBeacon( entity player, int statusEffect, bool actuallyChanged )
{
	if ( player != GetLocalViewPlayer() )
		return

	thread DeployablePortableBeacon( player, $"mdl/props/mobile_respawn_beacon/mobile_respawn_beacon_animated.rmdl" )
}

void function OnEndPlacingBeacon( entity player, int statusEffect, bool actuallyChanged )
{
	if ( player != GetLocalViewPlayer() )
		return

	#if SERVER
	//player.Signal( "DeployablePortableBeacon" )
	#endif
}

void function DeployablePortableBeacon( entity player, asset beaconModel )
{

	player.EndSignal( "DeployableCarePackagePlacement" )


	entity portableBeacon = CreateBeaconProxy( beaconModel )
	portableBeacon.EnableRenderAlways()
	portableBeacon.Show()
	DeployableModelHighlight( portableBeacon )

	OnThreadEnd(
		function() : ( portableBeacon )
		{
			if ( IsValid( portableBeacon ) )
				thread DestroyBeaconProxy( portableBeacon )

			HidePlayerHint( "%attack% Deploy Respawn Beacon" )
		}
	)

	AddPlayerHint( 3.0, 0.25, $"", "%attack% Deploy Respawn Beacon" )

	while ( true )
	{
		CarePackagePlacementInfo placementInfo = GetCarePackagePlacementInfo( player )

		portableBeacon.SetOrigin( placementInfo.origin )
		portableBeacon.SetAngles( placementInfo.angles )

		if ( !placementInfo.failed )
			DeployableModelHighlight( portableBeacon )
		else
			DeployableModelInvalidHighlight( portableBeacon )

		if ( placementInfo.hide )
			portableBeacon.Hide()
		else
			portableBeacon.Show()

		WaitFrame()
	}
}


entity function CreateBeaconProxy( asset modelName ) //TODO: Needs work if we do different turret models
{
	entity portableBeacon = CreateClientSidePropDynamic( <0,0,0>, <0,0,0>, modelName )
	portableBeacon.kv.renderamt = 255
	portableBeacon.kv.rendercolor = "255 255 255 255"
	portableBeacon.Anim_Play( "ref" )
	portableBeacon.Hide()
	return portableBeacon
}

void function DestroyBeaconProxy( entity ent )
{
	Assert( IsNewThread(), "Must be threaded off" )
	ent.EndSignal( "OnDestroy" )

	if(IsValid(ent))
	ent.Destroy()
}
#endif




