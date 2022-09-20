
global function MpWeaponDirtyBomb_Init

global function OnWeaponTossReleaseAnimEvent_weapon_dirty_bomb
global function OnWeaponTossPrep_weapon_dirty_bomb

global function OnWeaponAttemptOffhandSwitch_weapon_dirty_bomb
global function OnWeaponPrimaryAttack_weapon_dirty_bomb
global function OnWeaponActivate_weapon_dirty_bomb
global function OnWeaponDeactivate_weapon_dirty_bomb

#if SERVER
global function RemoveCausticDirtyBomb
#endif

global const string DIRTY_BOMB_TARGETNAME = "caustic_trap"

const asset DIRTY_BOMB_CANISTER_MODEL = $"mdl/props/caustic_gas_tank/caustic_gas_tank.rmdl"

const asset DIRTY_BOMB_CANISTER_EXP_FX = $"P_meteor_trap_EXP"
const asset DIRTY_BOMB_CANISTER_FX_ALL = $"P_gastrap_start"

const int DIRTY_BOMB_MAX_GAS_CANISTERS = 6

const string DIRTY_BOMB_WARNING_SOUND 	= "weapon_vortex_gun_explosivewarningbeep"

const float DIRTY_BOMB_GAS_RADIUS = 256.0
const float DIRTY_BOMB_GAS_DURATION = 12.5
const float DIRTY_BOMB_DETECTION_RADIUS = 140.0

const float DIRTY_BOMB_THROW_POWER = 1.0
const float DIRTY_BOMB_GAS_FX_HEIGHT = 45.0
const float DIRTY_BOMB_GAS_CLOUD_HEIGHT = 48.0

//TRAP PLACEMENT VARS
const float DIRTY_BOMB_ACTIVATE_DELAY = 0.2
const float DIRTY_BOMB_PLACEMENT_RANGE_MAX = 64
const float DIRTY_BOMB_PLACEMENT_RANGE_MIN = 32
const vector DIRTY_BOMB_BOUND_MINS = <-8,-8,-8>
const vector DIRTY_BOMB_BOUND_MAXS = <8,8,8>
const vector DIRTY_BOMB_PLACEMENT_TRACE_OFFSET = <0,0,128>
const float DIRTY_BOMB_ANGLE_LIMIT = 0.55
const float DIRTY_BOMB_PLACEMENT_MAX_HEIGHT_DELTA = 20.0

const bool CAUSTIC_DEBUG_DRAW_PLACEMENT = false

struct DirtyBombPlacementInfo
{
	vector origin
	vector angles
	entity parentTo
	bool success = false
	bool doDeployAnim = true
}

struct DirtyBombPlayerPlacementData
{
	vector viewOrigin	//The player's view origin when they placed the trap.
	vector viewForward	//The player's view forward when they placed the trap.
	vector playerOrigin //The player's world origin when they placed the trap.
	vector playerForward //The player's world forward when they placed the trap.
}

struct
{
	#if SERVER
	table< entity, int > triggerTargets
	#endif
} file

void function MpWeaponDirtyBomb_Init()
{
	DirtyBombPrecache()
}

void function DirtyBombPrecache()
{
	RegisterSignal( "DirtyBomb_Detonated" )
	RegisterSignal( "DirtyBomb_PickedUp" )
	RegisterSignal( "DirtyBomb_Disarmed" )
	RegisterSignal( "DirtyBomb_Active" )

	PrecacheParticleSystem( DIRTY_BOMB_CANISTER_EXP_FX )
	PrecacheParticleSystem( DIRTY_BOMB_CANISTER_FX_ALL )
	PrecacheModel( DIRTY_BOMB_CANISTER_MODEL )

	#if CLIENT
		RegisterSignal( "DirtyBomb_StopPlacementProxy" )
		StatusEffect_RegisterEnabledCallback( eStatusEffect.placing_caustic_barrel, DirtyBomb_OnBeginPlacement )
		StatusEffect_RegisterDisabledCallback( eStatusEffect.placing_caustic_barrel, DirtyBomb_OnEndPlacement )

		AddCreateCallback( "prop_script", DirtyBomb_OnPropScriptCreated )
	#endif
}

void function OnWeaponActivate_weapon_dirty_bomb( entity weapon )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	weapon.w.startChargeTime = Time()

	Assert( ownerPlayer.IsPlayer() )
	#if CLIENT
		if ( !InPrediction() ) //Stopgap fix for Bug 146443
			return
	#endif

	int statusEffect = eStatusEffect.placing_caustic_barrel

	StatusEffect_AddEndless( ownerPlayer, statusEffect, 1.0 )

	#if SERVER
		AddButtonPressedPlayerInputCallback( ownerPlayer, IN_OFFHAND1, DirtyBomb_CancelPlacement )
	#endif
}


void function OnWeaponDeactivate_weapon_dirty_bomb( entity weapon )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	Assert( ownerPlayer.IsPlayer() )
	#if CLIENT
		if ( !InPrediction() ) //Stopgap fix for Bug 146443
			return
	#endif
	StatusEffect_StopAllOfType( ownerPlayer, eStatusEffect.placing_caustic_barrel )

	#if SERVER
		RemoveButtonPressedPlayerInputCallback( ownerPlayer, IN_OFFHAND1, DirtyBomb_CancelPlacement )
	#endif
}


var function OnWeaponPrimaryAttack_weapon_dirty_bomb( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	Assert( ownerPlayer.IsPlayer() )

	asset model = DIRTY_BOMB_CANISTER_MODEL

	entity proxy = CreateProxyBombModel( model )
	DirtyBombPlacementInfo placementInfo = GetDirtyBombPlacementInfo( ownerPlayer, proxy )
	proxy.Destroy()

	if ( !placementInfo.success )
	{
		#if CLIENT
		EmitSoundOnEntity( ownerPlayer, "Wpn_ArcTrap_Beep" )
		#endif
		return 0
	}
	#if SERVER
		DirtyBombPlayerPlacementData placementData
		placementData.viewOrigin = ownerPlayer.EyePosition()
		placementData.viewForward 	= ownerPlayer.GetViewForward()
		placementData.playerOrigin 	= ownerPlayer.GetOrigin()
		placementData.playerForward	= FlattenVector( ownerPlayer.GetViewForward() )
		thread DeployCausticTrap( ownerPlayer, placementInfo )
	#endif

	PlayerUsedOffhand( ownerPlayer, weapon, true, null, {pos = placementInfo.origin} )
	return weapon.GetAmmoPerShot()
}

bool function OnWeaponAttemptOffhandSwitch_weapon_dirty_bomb( entity weapon )
{
	int ammoReq = weapon.GetAmmoPerShot()
	int currAmmo = weapon.GetWeaponPrimaryClipCount()
	if ( currAmmo < ammoReq )
		return false

	entity player = weapon.GetWeaponOwner()
	if ( player.IsPhaseShifted() )
		return false

	return true
}

#if SERVER
void function DirtyBomb_CancelPlacement( entity player )
{

	if ( player.IsUsingOffhandWeapon( eActiveInventorySlot.mainHand ) )
	{
		entity activeWeapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )

		if ( !IsValid( activeWeapon ) )
			return

		if ( activeWeapon.GetWeaponClassName() != "mp_weapon_dirty_bomb" )
			return

		if ( activeWeapon.w.startChargeTime + 0.1 > Time() )
			return
	}
	else
	{
		return
	}


	SwapToLastEquippedPrimary( player )
}

void function DeployCausticTrap( entity owner, DirtyBombPlacementInfo placementInfo )
{
	if ( !IsValid( owner ) )
		return

	vector origin = placementInfo.origin
	vector angles = placementInfo.angles

	owner.EndSignal( "OnDestroy" )

	int team = owner.GetTeam()
	entity canisterProxy = CreatePropScript( DIRTY_BOMB_CANISTER_MODEL, origin, angles, SOLID_CYLINDER )
	//canisterProxy.kv.collisionGroup = TRACE_COLLISION_GROUP_BLOCK_WEAPONS
	canisterProxy.DisableHibernation()
	canisterProxy.SetMaxHealth( 100 )
	canisterProxy.SetHealth( 100 )
	canisterProxy.SetDamageNotifications( false )
	canisterProxy.SetDeathNotifications( false )
	canisterProxy.SetArmorType( ARMOR_TYPE_HEAVY )
	canisterProxy.SetScriptName( DIRTY_BOMB_TARGETNAME )
	canisterProxy.SetBlocksRadiusDamage( false )
	SetTargetName( canisterProxy, DIRTY_BOMB_TARGETNAME )
	canisterProxy.EndSignal( "OnDestroy" )
	canisterProxy.SetBossPlayer( owner )
	canisterProxy.e.isGasSource = true
	canisterProxy.e.noOwnerFriendlyFire = false
	canisterProxy.e.isBusy = false
	canisterProxy.RemoveFromAllRealms()
	canisterProxy.AddToOtherEntitysRealms( owner )
//	SetTeam( canisterProxy, team )
	canisterProxy.Minimap_SetCustomState( eMinimapObject_prop_script.DIRTY_BOMB )
	canisterProxy.Minimap_AlwaysShow( team, null )
	canisterProxy.Minimap_SetAlignUpright( true )
	canisterProxy.Minimap_SetZOrder( MINIMAP_Z_OBJECT-1 )
	canisterProxy.SetTakeDamageType( DAMAGE_NO )
	canisterProxy.NotSolid()
	canisterProxy.SetPhysics( MOVETYPE_FLY ) // doesn't actually make it move, but allows pushers to interact with it
	canisterProxy.SetScriptName("gas_trap")
	Highlight_SetOwnedHighlight( canisterProxy, "sp_friendly_hero" )
	Highlight_SetFriendlyHighlight( canisterProxy, "sp_friendly_hero" )

	MakeEntityAsGasEmitter( canisterProxy )

	//EmitSoundOnEntityOnlyToPlayer( canisterProxy, owner, "GasTrap_Throw_1p" )
	//EmitSoundOnEntityExceptToPlayer( canisterProxy, owner, "GasTrap_Throw_3p" )

	string noSpawnIdx = CreateNoSpawnArea( TEAM_INVALID, team, origin, -1.0, DIRTY_BOMB_GAS_RADIUS )
	SetObjectCanBeMeleed( canisterProxy, false )
	SetVisibleEntitiesInConeQueriableEnabled( canisterProxy, false )
	thread TrapDestroyOnRoundEnd( owner, canisterProxy )

	if ( IsValid( placementInfo.parentTo ) )
	{
		canisterProxy.SetParent( placementInfo.parentTo )
	}

	//make npc's fire at their own traps to cut off lanes
	if ( owner.IsNPC() )
	{
		owner.SetSecondaryEnemy( canisterProxy )
		canisterProxy.EnableAttackableByAI( AI_PRIORITY_NO_THREAT, 0, AI_AP_FLAG_NONE )		// don't let other AI target this
	}

	//Register Canister so that it is detected by sonar.
	canisterProxy.Highlight_Enable()
	AddSonarDetectionForPropScript( canisterProxy )

	//Create a threat zone for the passive voices and store the ID so we can clean it up later.
	int threatZoneID = ThreatDetection_CreateThreatZoneForTrap( owner, canisterProxy.GetOrigin(), team )

	// Landing sound handled in impact table: exp_dirty_bomb.txt
	// EmitSoundOnEntity( canisterProxy, "GasTrap_Land_Default" )

	entity mover

	if ( placementInfo.parentTo != null )
	{
		mover = CreateScriptMover( origin, angles )
		mover.SetParent( placementInfo.parentTo )
		canisterProxy.SetParent( mover )
	}
	else
	{
		mover = canisterProxy
	}

	OnThreadEnd(
	function() : ( owner, canisterProxy, mover, noSpawnIdx, threatZoneID )
		{
			DeleteNoSpawnArea( noSpawnIdx )

			//Remove the threat zone for this trap.
			ThreatDetection_DestroyThreatZone( threatZoneID )

			if ( IsValid( owner ) )
			{
				for ( int i=owner.e.activeTraps.len()-1; i>=0 ; i-- )
				{
					if ( owner.e.activeTraps[i] == canisterProxy )
					{
						owner.e.activeTraps.remove( i )
					}
				}
			}

			thread RemoveCanister( canisterProxy, mover )
		}
	)

	canisterProxy.EndSignal( "OnDestroy" )
	canisterProxy.EndSignal( "DirtyBomb_Detonated" )
	canisterProxy.EndSignal( "DirtyBomb_PickedUp" )
	canisterProxy.EndSignal( "DirtyBomb_Disarmed" )

	if ( placementInfo.doDeployAnim )
		waitthread PlayAnim( canisterProxy, "prop_caustic_gastank_predeploy", mover )
	thread PlayAnim( canisterProxy, "prop_caustic_gastank_predeploy_idle", mover )

	float radius = canisterProxy.GetBoundingMaxs().x * 0.75

	//entity trigger = CreateEntity( "trigger_cylinder" )
	//trigger.SetRadius( radius )
	//trigger.SetAboveHeight( 128 )
	//trigger.SetBelowHeight( 32 )
	//trigger.kv.triggerFilterUseNew = 1
	//trigger.kv.triggerFilterPlayer = "all"
	//trigger.kv.triggerFilterPhaseShift = "any"
	//trigger.kv.triggerFilterNpc = "none"
	//trigger.kv.triggerFilterNonCharacter = 0
	//trigger.kv.triggerFilterTeamMilitia = 1
	//trigger.kv.triggerFilterTeamIMC = 1
	//trigger.kv.triggerFilterTeamNeutral = 1
	//trigger.kv.triggerFilterTeamBeast = 1
	//trigger.kv.triggerFilterTeamOther = 1 // this is key for survival
	//trigger.RemoveFromAllRealms()
	//trigger.AddToOtherEntitysRealms( owner )
	//DispatchSpawn( trigger )
	//trigger.SetOrigin( canisterProxy.GetOrigin() )
	//trigger.SetParent( canisterProxy, "", false )
	//
	//OnThreadEnd(
	//	function() : ( trigger )
	//	{
	//		if ( IsValid( trigger ) )
	//		{
	//			trigger.Destroy()
	//		}
	//	}
	//)
	//
	//trigger.SearchForNewTouchingEntity() //JFS: trigger.GetTouchingEntities() will not return entities already in the trigger unless this is called. See bug 202843
	//
	//while ( trigger.GetTouchingEntities().len() > 0 )
	//{
	//	WaitFrame()
	//}
	//
	//trigger.Destroy()

	canisterProxy.Solid()

	waitthread PlayAnim( canisterProxy, "prop_caustic_gastank_deploy", mover )

	thread WaitForCanisterPickup( canisterProxy )
	thread CreateDirtyBombTriggerArea( canisterProxy, team )

	AddEntityCallback_OnDamaged( canisterProxy, OnDirtyBombCanisterDamaged )
	canisterProxy.SetTakeDamageType( DAMAGE_EVENTS_ONLY )

	owner.e.activeTraps.insert( 0, canisterProxy )

	while ( owner.e.activeTraps.len() > DIRTY_BOMB_MAX_GAS_CANISTERS )
	{
		entity entToDelete = owner.e.activeTraps.pop()
		if ( IsValid( entToDelete ) )
		{
			entToDelete.Destroy()
		}
	}

	WaitForever()
}

void function RemoveCanister( entity canisterProxy, entity mover )
{
	OnThreadEnd(
		function () : (mover, canisterProxy)
		{
			if ( IsValid( mover ) )
			{
				mover.Destroy()
			}
			if ( IsValid( canisterProxy ) )
			{
				canisterProxy.Destroy()
			}
		}
	)

	if ( IsValid( canisterProxy ) )
	{
		canisterProxy.EndSignal( "OnDestroy" )
		canisterProxy.SetTakeDamageType( DAMAGE_NO )
		canisterProxy.NotSolid()

		float duration = canisterProxy.GetSequenceDuration( "prop_caustic_gastank_destroy" )
		Highlight_ClearOwnedHighlight( canisterProxy )
		Highlight_ClearFriendlyHighlight( canisterProxy )
		thread PlayAnim( canisterProxy, "prop_caustic_gastank_destroy", mover)
		//canisterProxy.Dissolve( ENTITY_DISSOLVE_CORE, <0,0,0>, 500 )
		waitthread PROTO_FadeModelAlphaOverTime( canisterProxy, duration )
	}
}

// Global interface
void function RemoveCausticDirtyBomb( entity canisterProxy, entity mover )
{
	thread RemoveCanister( canisterProxy, mover )
}

void function CreateDirtyBombTriggerArea( entity canisterProxy, int team )
{
	Assert ( IsNewThread(), "Must be threaded off" )
	canisterProxy.EndSignal( "OnDestroy" )
	canisterProxy.EndSignal( "DirtyBomb_Active" )
	canisterProxy.EndSignal( "DirtyBomb_PickedUp" )
	canisterProxy.EndSignal( "DirtyBomb_Disarmed" )

	vector origin = canisterProxy.GetOrigin()

	entity trigger = CreateEntity( "trigger_cylinder" )
	trigger.SetOwner( canisterProxy )
	trigger.SetRadius( DIRTY_BOMB_DETECTION_RADIUS )
	trigger.SetAboveHeight( 128 )
	trigger.SetBelowHeight( 128 )
	trigger.SetOrigin( origin )
	SetTeam( trigger, team )
	trigger.kv.triggerFilterNonCharacter = "0"
	trigger.RemoveFromAllRealms()
	trigger.AddToOtherEntitysRealms( canisterProxy )
	DispatchSpawn( trigger )

	file.triggerTargets[ trigger ] <- 0

	trigger.SetEnterCallback( OnDirtyBombAreaEnter )

	trigger.SetOrigin( origin )

	trigger.SetParent( canisterProxy, "", true, 0.0 )

	OnThreadEnd(
	function() : ( trigger )
	{
		delete file.triggerTargets[ trigger ]
		trigger.Destroy()
	} )

	WaitForever()
}

void function OnDirtyBombAreaEnter( entity trigger, entity ent )
{
	array<entity> touchingEnts = trigger.GetTouchingEntities()
	array<entity> filteredEnts

	int team = trigger.GetTeam()
	foreach ( entity touchingEnt in touchingEnts )
	{
		if ( touchingEnt.GetTeam() != team )
			filteredEnts.append( touchingEnt )
	}

	//if we have any hostile targets, start update
	if ( filteredEnts.len() && file.triggerTargets[ trigger ] == 0 )
		thread DirtyBombProximityActivationUpdate( trigger )
}

void function DirtyBombProximityActivationUpdate( entity trigger )
{
	Assert ( IsNewThread(), "Must be threaded off." )
	trigger.EndSignal( "OnDestroy" )

	vector offsetOrigin = trigger.GetOrigin() + <0,0,DIRTY_BOMB_GAS_CLOUD_HEIGHT>

	float maxDist		= DIRTY_BOMB_DETECTION_RADIUS
	int traceMask 		= TRACE_MASK_PLAYERSOLID
	int visConeFlags	= VIS_CONE_ENTS_TEST_HITBOXES | VIS_CONE_RETURN_HIT_VORTEX
	entity antilagPlayer = null

	int team = trigger.GetTeam()

	//printt( "STARTING UPDATE FOR TRIGGER" )

	array<entity> touchingEnts = trigger.GetTouchingEntities()
	while( touchingEnts.len() )
	{
		touchingEnts = trigger.GetTouchingEntities()
		array<entity> targetEnts
		array<entity> ignoreEnts = []

		foreach ( entity touchingEnt in touchingEnts )
		{
			if ( touchingEnt.GetTeam() != team )
				targetEnts.append( touchingEnt )
			else
				ignoreEnts.append( touchingEnt )
		}

		//printt( "TARGETS IN TRIGGER: " + targetEnts.len() )
		//if we are not touching any targets end update.
		file.triggerTargets[ trigger ] = targetEnts.len()
		if ( file.triggerTargets[ trigger ] == 0 )
			return

		array<entity> gasSources = GetEntArrayByScriptName( "dirty_bomb" )
		ignoreEnts.extend( gasSources )

		//printt( ignoreEnts.len() )

		foreach ( entity ent in targetEnts )
		{
			//Don't trigger on phase shifted targets.
			if ( ent.IsPhaseShifted() )
				continue

			//Don't trigger on cloaked targets.
			if ( IsCloaked( ent ) )
				continue

			//Don't trigger on titans
			if ( ent.IsTitan() )
				continue

			if ( !ent.DoesShareRealms( trigger ) )
				continue

			//printt( "CASTING CONE FOR " + ent )
			vector dir = Normalize( ent.GetOrigin() - offsetOrigin )
			array<VisibleEntityInCone> results = FindVisibleEntitiesInCone( offsetOrigin, dir, maxDist, 45, ignoreEnts, traceMask, visConeFlags, antilagPlayer )
			foreach ( result in results )
			{
				//printt( result.ent )
				if ( !targetEnts.contains( result.ent ) )
					continue

				//printt( "TARGET FOUND" )

				//A target has set off the dirty bomb
				entity canisterProxy = trigger.GetOwner()
				EmitSoundOnEntity( canisterProxy, DIRTY_BOMB_WARNING_SOUND )
				thread DetonateDirtyBombCanister( canisterProxy )
				return
			}
		}

		WaitFrame()
	}
}

void function OnDirtyBombCanisterDamaged( entity canisterProxy, var damageInfo )
{
	if(canisterProxy.e.isBusy)
		return
	
	//HACK - Should use damage flags, but we might be capped?
	int damageSourceID = DamageInfo_GetDamageSourceIdentifier( damageInfo )
	switch ( damageSourceID )
	{
		case eDamageSourceId.damagedef_grenade_gas:
		case eDamageSourceId.damagedef_gas_exposure:
			return
	}

	int damageFlags = DamageInfo_GetCustomDamageType( damageInfo )
	if ( damageFlags & DF_EXPLOSION )
	{
		thread DetonateDirtyBombCanister( canisterProxy )
		return
	}


	//Check hitBoxes
	int hitBox = DamageInfo_GetHitBox( damageInfo )
	entity attacker = DamageInfo_GetAttacker( damageInfo )
	if( !IsValid( attacker ) )
		return
	
	canisterProxy.e.isBusy = true

	if ( hitBox > 0 ) //Normal Hit
	{
		thread DetonateDirtyBombCanister( canisterProxy )
	}
	else
	{
		canisterProxy.Signal( "DirtyBomb_Disarmed" )
	}

}

// void function CreateDirtyBombCanisterExplosion( vector origin, entity canister, entity owner )
// {
// 	if ( !IsValid( owner ) )
// 		return

// 	//Explosion_DamageDefSimple( damagedef_dirty_bomb_explosion, origin, owner, owner, origin )

// 	Explosion_DamageDef(
// 	damagedef_dirty_bomb_explosion, //damageDefID
// 	origin, 						//center
// 	owner,							//attacker
// 	canister, 						//inflictor
// 	750,							//damage
// 	2000,							//damageHeavyArmor
// 	256, 							//innerRadius
// 	256,							//outerRadius
// 	origin							//projectileLaunchOrigin
// 	)

// 	int flags = 0
// 	CreatePhysExplosion( origin, 256, PHYS_EXPLOSION_LARGE, flags )

// 	entity initialExplosion = StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( DIRTY_BOMB_CANISTER_EXP_FX ), origin, <0,0,0> )
// 	EntFireByHandle( initialExplosion, "Kill", "", 3.0, null, null )
// 	EmitSoundAtPosition( TEAM_UNASSIGNED, origin, "GasTrap_Activate" )
// 	printt( "Playing activate sound" )

// 	entity shake = CreateShake( origin, 5, 150, 1, 512 )
// 	shake.kv.spawnflags = 4 // SF_SHAKE_INAIR
// 	shake.Destroy()
// }

void function DetonateDirtyBombCanister( entity canisterProxy )
{
	if ( !IsValid( canisterProxy ) )
		return
	
	canisterProxy.e.isBusy = true

	Assert( IsNewThread(), "Must be threaded off." )
	canisterProxy.EndSignal( "OnDestroy" )
	canisterProxy.Signal( "DirtyBomb_Active" )

	entity owner = canisterProxy.GetBossPlayer()
	//If the owner is alive we should use the owner, otherwise world is attacker
	entity attacker = IsValid( owner ) ? owner : svGlobal.worldspawn

	if ( !IsValid( attacker ) )
		return

	if ( IsValid( owner ) )
		StatsHook_DirtyBomb_OnDetonate( owner, attacker )

	EmitSoundOnEntity( canisterProxy, "GasTrap_Activate" )
	EmitSoundOnEntity( canisterProxy, "GasTrap_TrapLoop" ) // Sweetener for gas trap -- cloud has its own sound in sh_gas.gnut
	entity fx = PlayLoopFXOnEntity( DIRTY_BOMB_CANISTER_FX_ALL, canisterProxy, "fx_top" )
	canisterProxy.SetTakeDamageType( DAMAGE_NO )
	Highlight_SetOwnedHighlight( canisterProxy, "caustic_gas_canister" )
	Highlight_SetFriendlyHighlight( canisterProxy, "caustic_gas_canister" )

	wait DIRTY_BOMB_ACTIVATE_DELAY

	attacker = IsValid( attacker ) ? attacker : svGlobal.worldspawn

	TrackingVision_CreatePOI( eTrackingVisionNetworkedPOITypes.PLAYER_ABILITIES_GAS, canisterProxy, canisterProxy.GetOrigin(), attacker.GetTeam(), attacker )
	CreateGasCloudMediumAtOrigin( canisterProxy, attacker, canisterProxy.GetOrigin() + <0,0,DIRTY_BOMB_GAS_CLOUD_HEIGHT>, DIRTY_BOMB_GAS_DURATION )

	wait DIRTY_BOMB_GAS_DURATION - 5.0

	thread BeepSound( canisterProxy )

	wait 5.0

	if ( IsValid( fx ) )
		fx.Destroy()
	StopSoundOnEntity( canisterProxy, "GasTrap_TrapLoop" )
	canisterProxy.Signal( "DirtyBomb_Detonated" )
}

void function BeepSound( entity canister )
{
	canister.EndSignal( "OnDestroy" )
	canister.EndSignal( "DirtyBomb_Detonated" )

	while ( 1 )
	{
		EmitSoundOnEntity( canister, "Wpn_ArcTrap_Beep" )
		wait 1.0
	}
}

void function WaitForCanisterPickup( entity canisterProxy )
{
	Assert( IsNewThread(), "Must be threaded off." )
	canisterProxy.EndSignal( "OnDestroy" )
	canisterProxy.EndSignal( "DirtyBomb_PickedUp" )
	canisterProxy.EndSignal( "DirtyBomb_Disarmed" )
	canisterProxy.EndSignal( "DirtyBomb_Active" )

	canisterProxy.SetUsable()
	//canister.SetUsableByGroup( "owner pilot" )
	canisterProxy.AddUsableValue( USABLE_CUSTOM_HINTS | USABLE_BY_OWNER | USABLE_CUSTOM_HINTS ) //Update hint text every server frame so that we can keep unique client texts up to date.
 	canisterProxy.SetUsePrompts( "#WPN_DIRTY_BOMB_DYNAMIC", "#WPN_DIRTY_BOMB_DYNAMIC" )

	OnThreadEnd(
	function() : ( canisterProxy )
		{
			if ( IsValid( canisterProxy ) )
			{
				canisterProxy.UnsetUsable()
			}
		}
	)

 	while( true )
 	{
 		entity player = expect entity( canisterProxy.WaitSignal( "OnPlayerUse" ).player )

 		//Titans cannot interact with dirty bomb.
 		if ( player.IsTitan() )
 			continue

		entity owner = canisterProxy.GetBossPlayer()

 		if ( player == owner )
 		{
 			if ( PickUpCanister( player ) )
	 		{
	 			canisterProxy.Signal( "DirtyBomb_PickedUp" )
	 		}
 		}
 	}
}

bool function PickUpCanister( entity player )
{
	entity weapon = player.GetOffhandWeapon( OFFHAND_TACTICAL )

	string className = weapon.GetWeaponClassName()
	if ( className != "mp_weapon_dirty_bomb" )
		return false

	if ( Bleedout_IsBleedingOut( player ) )
		return false

	int ammoPerShot = weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
	int maxAmmo = weapon.GetWeaponPrimaryClipCountMax()
	int curAmmo = weapon.GetWeaponPrimaryClipCount(  )
	int newAmmo = minint( curAmmo + ammoPerShot, maxAmmo )

	weapon.SetWeaponPrimaryClipCount( newAmmo )

	return true
}
#endif // SERVER

#if CLIENT
	void function DirtyBomb_OnPropScriptCreated( entity ent )
	{
		switch ( ent.GetScriptName() )
		{
			case DIRTY_BOMB_TARGETNAME:
				AddEntityCallback_GetUseEntOverrideText( ent, DirtyBomb_UseTextOverride )
				//thread DirtyBomb_CreateBombHUDMarker( ent )
			break
		}
	}

	string function DirtyBomb_UseTextOverride( entity ent )
	{
		entity player = GetLocalViewPlayer()

		if ( player.IsTitan() )
			return "#WPN_DIRTY_BOMB_NO_INTERACTION"

		if ( player == ent.GetBossPlayer() )
		{
			return ""
		}

		//if ( player.GetTeam() != ent.GetTeam() )
		//{
		//	return "#WPN_DIRTY_BOMB_DISARM_DYNAMIC"
		//}

		return "#WPN_DIRTY_BOMB_NO_INTERACTION"
	}

	void function DirtyBomb_CreateBombHUDMarker( entity bomb )
	{
		entity localClientPlayer = GetLocalClientPlayer()

		bomb.EndSignal( "OnDestroy" )

		if ( !ShouldShowBombIcon( localClientPlayer, bomb ) )
			return

		vector pos = bomb.GetOrigin() + <0,0,DIRTY_BOMB_GAS_CLOUD_HEIGHT>
		var rui = CreateCockpitRui( $"ui/dirty_bomb_marker_icons.rpak", RuiCalculateDistanceSortKey( localClientPlayer.EyePosition(), pos ) )
		RuiSetGameTime( rui, "startTime", Time() )
		RuiTrackFloat( rui, "healthFrac", bomb, RUI_TRACK_HEALTH )
		RuiTrackFloat3( rui, "pos", bomb, RUI_TRACK_POINT_FOLLOW, bomb.LookupAttachment( "fx_top" ) )
		RuiKeepSortKeyUpdated( rui, true, "pos" )

		RuiSetImage( rui, "bombImage", $"rui/hud/gametype_icons/raid/bomb_icon_friendly" )
		RuiSetImage( rui, "triggeredImage", $"rui/pilot_loadout/ordnance/electric_smoke" )

		OnThreadEnd(
		function() : ( rui )
		{
			RuiDestroy( rui )
		}
		)

		WaitForever()
	}

bool function ShouldShowBombIcon( entity localPlayer, entity bomb )
{
	if ( !GamePlayingOrSuddenDeath() )
		return false

	//if ( IsWatchingReplay() )
	//	return false
	entity owner = bomb.GetBossPlayer()
	if ( !IsValid( owner ) )
		return false

	if ( localPlayer.GetTeam() != owner.GetTeam() )
		return false

	return true
}

void function DirtyBomb_OnBeginPlacement( entity player, int statusEffect, bool actuallyChanged )
{
	if ( player != GetLocalViewPlayer() )
		return

	thread DirtyBombPlacement( player )
}

void function DirtyBomb_OnEndPlacement( entity player, int statusEffect, bool actuallyChanged )
{
	if ( player != GetLocalViewPlayer() )
		return

	player.Signal( "DirtyBomb_StopPlacementProxy" )
}

void function DirtyBombPlacement( entity player )
{
	player.EndSignal( "DirtyBomb_StopPlacementProxy" )

	entity bomb = CreateProxyBombModel( DIRTY_BOMB_CANISTER_MODEL )
	bomb.EnableRenderAlways()
	bomb.Show()
	DeployableModelHighlight( bomb )

	var placementRui = CreateCockpitRui( $"ui/generic_trap_placement.rpak", RuiCalculateDistanceSortKey( player.EyePosition(), bomb.GetOrigin() ) )
	int placementAttachment = bomb.LookupAttachment( "fx_top" )
	RuiSetBool( placementRui, "staticPosition", true )
	RuiSetInt( placementRui, "trapLimit", DIRTY_BOMB_MAX_GAS_CANISTERS )
	RuiTrackFloat3( placementRui, "mainTrapPos", bomb, RUI_TRACK_POINT_FOLLOW, placementAttachment )
	RuiKeepSortKeyUpdated( placementRui, true, "mainTrapPos" )
	RuiSetImage( placementRui, "trapIcon", $"rui/pilot_loadout/ordnance/electric_smoke" )

	OnThreadEnd(
		function() : ( bomb, placementRui )
		{
			if ( IsValid( bomb ) )
				bomb.Destroy()

			RuiDestroy( placementRui )
		}
	)

	while ( true )
	{
		DirtyBombPlacementInfo placementInfo = GetDirtyBombPlacementInfo( player, bomb )

		if ( !placementInfo.success )
			DeployableModelInvalidHighlight( bomb )
		else if ( placementInfo.success )
			DeployableModelHighlight( bomb )

		RuiSetBool( placementRui, "success", placementInfo.success )
		RuiSetInt( placementRui, "trapCount", DirtyBomb_GetOwnedTrapCountOnClient( player ) )

		bomb.SetOrigin( placementInfo.origin )
		bomb.SetAngles( placementInfo.angles )

		WaitFrame()
	}
}

int function DirtyBomb_GetOwnedTrapCountOnClient( entity player )
{
	int count
	array<entity> traps = GetEntArrayByScriptName( "dirty_bomb" )
	foreach ( entity trap in traps )
	{
		if ( trap.GetBossPlayer() == player )
			count++
	}

	return count
}

#endif //CLIENT

entity function CreateProxyBombModel( asset modelName )
{
	#if SERVER
		entity proxy = CreatePropDynamic( modelName, <0,0,0>, <0,0,0> )
	#else
		entity proxy = CreateClientSidePropDynamic( <0,0,0>, <0,0,0>, modelName )
	#endif
	proxy.kv.renderamt = 255
	proxy.kv.rendermode = 3
	proxy.kv.rendercolor = "255 255 255 255"
	proxy.Hide()

	return proxy
}

DirtyBombPlacementInfo function GetDirtyBombPlacementInfo( entity player, entity bombModel )
{
	vector eyePos = player.EyePosition()
	vector viewVec = player.GetViewVector()
	vector angles = < 0, VectorToAngles( viewVec ).y, 0 >
	//viewVec = AnglesToForward( angles )

	float maxRange = DIRTY_BOMB_PLACEMENT_RANGE_MAX

	TraceResults viewTraceResults = TraceLine( eyePos, eyePos + player.GetViewVector() * (DIRTY_BOMB_PLACEMENT_RANGE_MAX * 2), [player, bombModel], TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_BLOCK_WEAPONS )
	if ( viewTraceResults.fraction < 1.0 )
	{
		float slope = fabs( viewTraceResults.surfaceNormal.x ) + fabs( viewTraceResults.surfaceNormal.y )
		if ( slope < 0.707 )
			maxRange = min( Distance2D( eyePos, viewTraceResults.endPos ), DIRTY_BOMB_PLACEMENT_RANGE_MAX )
	}

	vector idealPos = player.GetOrigin() + ( AnglesToForward( angles ) * DIRTY_BOMB_PLACEMENT_RANGE_MAX )

	vector fwdStart = eyePos + viewVec * min( DIRTY_BOMB_PLACEMENT_RANGE_MIN, maxRange )
	TraceResults fwdResults = TraceHull( fwdStart, eyePos + viewVec * maxRange, DIRTY_BOMB_BOUND_MINS, <30,30,1>, player, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_BLOCK_WEAPONS )
	TraceResults downResults = TraceHull( fwdResults.endPos, fwdResults.endPos - DIRTY_BOMB_PLACEMENT_TRACE_OFFSET, DIRTY_BOMB_BOUND_MINS, DIRTY_BOMB_BOUND_MAXS, player, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_BLOCK_WEAPONS )

	//DebugDrawLine( fwdStart, fwdResults.endPos, 255,0,0, true, 0.05 )
	//DebugDrawLine( fwdStart, fwdResults.endPos, 255,0,0, true, 0.05 )
	//DebugDrawSphere( fwdResults.endPos, 16, 255,0,0, true, 0.05 )
	//DebugDrawLine( fwdResults.endPos, fwdResults.endPos - DIRTY_BOMB_PLACEMENT_TRACE_OFFSET, 255,0,0, true, 0.05 )

	DirtyBombPlacementInfo placementInfo = DirtyBomb_GetPlacementInfoFromTraceResults( player, bombModel, downResults, viewTraceResults, idealPos )

	if ( !placementInfo.success )
	{
		//printt( "TRYING TO USE FALLBACK POSITION" )
		vector fallbackPos = fwdResults.endPos - ( viewVec * Length( DIRTY_BOMB_BOUND_MINS ) )
		TraceResults downFallbackResults = TraceHull( fallbackPos, fallbackPos - DIRTY_BOMB_PLACEMENT_TRACE_OFFSET, DIRTY_BOMB_BOUND_MINS, DIRTY_BOMB_BOUND_MAXS, [player, bombModel], TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_BLOCK_WEAPONS )

		placementInfo = DirtyBomb_GetPlacementInfoFromTraceResults( player, bombModel, downFallbackResults, viewTraceResults, idealPos )
	}

	return placementInfo
}

DirtyBombPlacementInfo function DirtyBomb_GetPlacementInfoFromTraceResults( entity player, entity bombModel, TraceResults hullTraceResults, TraceResults viewTraceResults, vector idealPos )
{
	vector viewVec = player.GetViewVector()
	vector angles  = < 0, VectorToAngles( viewVec ).y, 0 >

	bool isScriptedPlaceable = false
	if ( IsValid( hullTraceResults.hitEnt ) )
	{
		var hitEntClassname = hullTraceResults.hitEnt.GetNetworkedClassName()

		if ( hitEntClassname == "prop_script" )
		{
			if ( hullTraceResults.hitEnt.GetScriptPropFlags() == PROP_IS_VALID_FOR_TURRET_PLACEMENT )
				isScriptedPlaceable = true
		}
	}

	bool success = !hullTraceResults.startSolid && hullTraceResults.fraction < 1.0 && ( hullTraceResults.hitEnt.IsWorld() || hullTraceResults.hitEnt.GetNetworkedClassName() == "func_brush" || isScriptedPlaceable )

	entity parentTo
	if ( IsValid( hullTraceResults.hitEnt ) && hullTraceResults.hitEnt.GetNetworkedClassName() == "func_brush" )
	{
		parentTo = hullTraceResults.hitEnt
	}

	if ( hullTraceResults.startSolid && hullTraceResults.fraction < 1.0 && ( hullTraceResults.hitEnt.IsWorld() || isScriptedPlaceable ) )
	{
		TraceResults upResults = TraceHull( hullTraceResults.endPos, hullTraceResults.endPos, DIRTY_BOMB_BOUND_MINS, DIRTY_BOMB_BOUND_MAXS, player, TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_BLOCK_WEAPONS )
		if ( !upResults.startSolid )
			success = true
	}

	if ( success )
	{
		bombModel.SetOrigin( hullTraceResults.endPos )
		bombModel.SetAngles( angles )
	}

	if ( !player.IsOnGround() )
		success = false

	//EVEN GROUND CHECK AND SURFACE ANGLE CHECK
	if ( success && hullTraceResults.fraction < 1.0 )
	{
		vector right = bombModel.GetRightVector()
		vector forward = bombModel.GetForwardVector()
		vector up = bombModel.GetUpVector()

		float length = Length( DIRTY_BOMB_BOUND_MINS )

		array< vector > groundTestOffsets = [
			Normalize( right + forward ) * length,
			Normalize( -right + forward ) * length,
			Normalize( right + -forward ) * length,
			Normalize( -right + -forward ) * length
		]

		foreach ( vector testOffset in groundTestOffsets )
		{
			vector testPos = bombModel.GetOrigin() + testOffset
			TraceResults traceResult = TraceLine( testPos + ( up * DIRTY_BOMB_PLACEMENT_MAX_HEIGHT_DELTA ), testPos + ( up * -DIRTY_BOMB_PLACEMENT_MAX_HEIGHT_DELTA ), [player, bombModel], TRACE_MASK_PLAYERSOLID, TRACE_COLLISION_GROUP_BLOCK_WEAPONS )

			if ( traceResult.fraction == 1.0 )
			{
				success = false
				break
			}
		}
	}

	if ( success && hullTraceResults.hitEnt != null && ( !hullTraceResults.hitEnt.IsWorld() && !isScriptedPlaceable ) )
	{
		//printt( "PLACEMENT FAILED: PLAYER DID NOT HIT VALID ENT!!!" )
		//surfaceAngles = angles
		success = false
	}

	//BOOL SHOULD BE TRUE - This is causing issues with the sight blocker effect of smoke, so it's temporarily disabled. This results in the bug mentioned below.
	if ( success && !PlayerCanSeePos( player, hullTraceResults.endPos, false, 90 ) ) //Just to stop players from putting turrets through thin walls
		success = false

	vector org = success ? hullTraceResults.endPos - <0,0,DIRTY_BOMB_BOUND_MAXS.z> : idealPos
	DirtyBombPlacementInfo placementInfo
	placementInfo.success = success
	placementInfo.origin = org
	placementInfo.angles = angles
	placementInfo.parentTo = parentTo

	return placementInfo
}

////////////////////////////////////////////////////////////////////////
//			TOSS
////////////////////////////////////////////////////////////////////////

var function OnWeaponTossReleaseAnimEvent_weapon_dirty_bomb( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	int ammoReq = weapon.GetAmmoPerShot()
	weapon.EmitWeaponSound_1p3p( GetGrenadeThrowSound_1p( weapon ), GetGrenadeThrowSound_3p( weapon ) )

	entity deployable = ThrowDeployable( weapon, attackParams, DIRTY_BOMB_THROW_POWER, OnDirtyBombPlanted )
	if ( deployable )
	{
		entity player = weapon.GetWeaponOwner()
		PlayerUsedOffhand( player, weapon )

		#if SERVER
			string projectileSound = GetGrenadeProjectileSound( weapon )
			if ( projectileSound != "" )
				EmitSoundOnEntity( deployable, projectileSound )

			weapon.w.lastProjectileFired = deployable
		#endif

		#if BATTLECHATTER_ENABLED && SERVER
			TryPlayWeaponBattleChatterLine( player, weapon )
		#endif

	}

	return ammoReq
}


void function OnWeaponTossPrep_weapon_dirty_bomb( entity weapon, WeaponTossPrepParams prepParams )
{
	weapon.EmitWeaponSound_1p3p( GetGrenadeDeploySound_1p( weapon ), GetGrenadeDeploySound_3p( weapon ) )
}

void function OnDirtyBombPlanted( entity projectile )
{
	#if SERVER
		DirtyBombPlacementInfo placementInfo
		placementInfo.origin = projectile.GetOrigin()
		placementInfo.angles = projectile.GetAngles()

		placementInfo.success = true
		placementInfo.doDeployAnim = false
		placementInfo.parentTo = projectile.GetParent()

		vector start = projectile.GetOrigin() - <0,0,DIRTY_BOMB_BOUND_MINS.z>
		TraceResults trace = TraceHull( start + <0,0,DIRTY_BOMB_BOUND_MAXS.z>, start + <0,0,8>, DIRTY_BOMB_BOUND_MINS, DIRTY_BOMB_BOUND_MAXS, [ projectile ], TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_NONE )

		thread DeployCausticTrap( projectile.GetOwner(), placementInfo )
		projectile.Destroy()
	#endif
}
