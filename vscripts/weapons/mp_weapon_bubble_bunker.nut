global function MpWeaponBubbleBunker_Init

global function OnWeaponTossReleaseAnimEvent_WeaponBubbleBunker
global function OnWeaponAttemptOffhandSwitch_WeaponBubbleBunker
global function OnWeaponTossPrep_WeaponBubbleBunker
#if CLIENT
global function GetBubbleBunkerRui
#endif
global function GibraltarIsInDome

const float BUBBLE_BUNKER_DEPLOY_DELAY = 1.0
const float BUBBLE_BUNKER_DURATION_WARNING = 5.0

const bool BUBBLE_BUNKER_DAMAGE_ENEMIES = false

const float BUBBLE_BUNKER_ANGLE_LIMIT = 0.55

global const asset BUBBLE_BUNKER_BEAM_FX = $"P_wpn_BBunker_beam"
global const asset BUBBLE_BUNKER_BEAM_END_FX = $"P_wpn_BBunker_beam_end"
global const asset BUBBLE_BUNKER_SHIELD_FX = $"P_wpn_BBunker_shield"
global const asset BUBBLE_BUNKER_SHIELD_COLLISION_MODEL = $"mdl/fx/bb_shield.rmdl"
global const asset BUBBLE_BUNKER_SHIELD_PROJECTILE = $"mdl/props/gibraltar_bubbleshield/gibraltar_bubbleshield.rmdl"

global const string BUBBLE_BUNKER_SOUND_ENDING = "Gibraltar_BubbleShield_Ending"
global const string BUBBLE_BUNKER_SOUND_FINISH = "Gibraltar_BubbleShield_Deactivate"

const BUBBLE_BUNKER_THROW_POWER = 800.0
const BUBBLE_BUNKER_RADIUS = 240 //

struct FriendlyEnemyFXStruct
{
	entity friendlyColoredFX
	entity enemyColoredFX
	int team
}

struct
{
	#if CLIENT
	var bubbleBunkerRui
	#endif
} file


void function MpWeaponBubbleBunker_Init()
{
	PrecacheParticleSystem( BUBBLE_BUNKER_BEAM_END_FX )
	PrecacheParticleSystem( BUBBLE_BUNKER_BEAM_FX )
	PrecacheParticleSystem( BUBBLE_BUNKER_SHIELD_FX )
	PrecacheModel( BUBBLE_BUNKER_SHIELD_COLLISION_MODEL )
	PrecacheModel( BUBBLE_BUNKER_SHIELD_PROJECTILE )

	#if SERVER
	//RegisterSignal( "ActivateArcTrap" )
	RegisterSignal( "DeployBubbleBunker" )
	#else
	StatusEffect_RegisterEnabledCallback( eStatusEffect.bubble_bunker, BubbleBunker_EnterDome )
	StatusEffect_RegisterDisabledCallback( eStatusEffect.bubble_bunker, BubbleBunker_ExitDome )
	#endif
}

bool function OnWeaponAttemptOffhandSwitch_WeaponBubbleBunker( entity weapon )
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

var function OnWeaponTossReleaseAnimEvent_WeaponBubbleBunker( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	int ammoReq = weapon.GetAmmoPerShot()
	weapon.EmitWeaponSound_1p3p( GetGrenadeThrowSound_1p( weapon ), GetGrenadeThrowSound_3p( weapon ) )

	entity deployable = ThrowDeployable( weapon, attackParams, BUBBLE_BUNKER_THROW_POWER, OnBubbleBunkerPlanted )
	if ( deployable )
	{
		entity player = weapon.GetWeaponOwner()
		PlayerUsedOffhand( player, weapon, true, deployable )

		#if SERVER
		deployable.e.isDoorBlocker = true
		deployable.e.burnmeter_wasPreviouslyDeployed = weapon.e.burnmeter_wasPreviouslyDeployed

		string projectileSound = GetGrenadeProjectileSound( weapon )
		if ( projectileSound != "" )
			EmitSoundOnEntity( deployable, projectileSound )

		weapon.w.lastProjectileFired = deployable
		deployable.e.burnReward = weapon.e.burnReward
		#endif

		#if BATTLECHATTER_ENABLED && SERVER
			PlayBattleChatterLineToSpeakerAndTeam( player, "bc_tactical" )
		#endif
	}

	return ammoReq
}

void function OnWeaponTossPrep_WeaponBubbleBunker( entity weapon, WeaponTossPrepParams prepParams )
{
	weapon.EmitWeaponSound_1p3p( GetGrenadeDeploySound_1p( weapon ), GetGrenadeDeploySound_3p( weapon ) )
}

void function OnBubbleBunkerPlanted( entity projectile )
{
	#if SERVER
		Assert( IsValid( projectile ) )

		entity owner = projectile.GetOwner()

		if ( !IsValid( owner ) )
		{
			projectile.Destroy()
			return
		}

		vector origin = projectile.GetOrigin()

		vector endOrigin = origin - <0,0,32>
		vector surfaceAngles = projectile.proj.savedAngles
		vector oldUpDir = AnglesToUp( surfaceAngles )

		TraceResults traceResult = TraceLine( origin, endOrigin, [ projectile ], TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_BLOCK_WEAPONS_AND_PHYSICS )
		if ( traceResult.fraction < 1.0 )
		{
			vector forward = AnglesToForward( projectile.proj.savedAngles )
			surfaceAngles = AnglesOnSurface( traceResult.surfaceNormal, forward )

			vector newUpDir = AnglesToUp( surfaceAngles )
			if ( DotProduct( newUpDir, oldUpDir ) < BUBBLE_BUNKER_ANGLE_LIMIT )
				surfaceAngles = projectile.proj.savedAngles
		}

		entity oldParent = projectile.GetParent()
		projectile.ClearParent()

		origin = projectile.GetOrigin()
		asset model = BUBBLE_BUNKER_SHIELD_PROJECTILE// projectile.GetModelName()
		float duration = projectile.GetProjectileWeaponSettingFloat( eWeaponVar.fire_duration )

		entity newProjectile = CreatePropDynamic( model, origin, surfaceAngles )
		newProjectile.RemoveFromAllRealms()
		newProjectile.AddToOtherEntitysRealms( projectile )
		projectile.Destroy()

		newProjectile.SetOwner( owner )

		thread TrapDestroyOnRoundEnd( owner, newProjectile )

		if ( IsValid( traceResult.hitEnt ) )
		{
			newProjectile.SetParent( traceResult.hitEnt )
		}
		else if ( IsValid( oldParent ) )
		{
			newProjectile.SetParent( oldParent )
		}

		// collision for the bubble shield for sliding doors
		entity bubbleCollisionProxy = CreateEntity( "script_mover_lightweight" )
		bubbleCollisionProxy.kv.solid = SOLID_VPHYSICS
		bubbleCollisionProxy.kv.fadedist = -1
		bubbleCollisionProxy.SetValueForModelKey( BUBBLE_BUNKER_SHIELD_PROJECTILE )
		bubbleCollisionProxy.kv.SpawnAsPhysicsMover = 0
		bubbleCollisionProxy.e.isDoorBlocker = true

		bubbleCollisionProxy.SetOrigin( newProjectile.GetOrigin() )
		bubbleCollisionProxy.SetAngles( newProjectile.GetAngles() )


		DispatchSpawn( bubbleCollisionProxy )
		bubbleCollisionProxy.Hide()
		bubbleCollisionProxy.SetParent( newProjectile )
		bubbleCollisionProxy.SetOwner( owner )

		thread DeployBubbleBunker( newProjectile, duration )
	#endif
}

#if SERVER
void function DeployBubbleBunker( entity projectile, float duration )
{
	projectile.EndSignal( "OnDestroy" )

	entity owner = projectile.GetOwner()

	if ( !IsValid( owner ) )
	{
		projectile.Destroy()
		return
	}
	int team = owner.GetTeam()

	entity wp = CreateWaypoint_Ping_Location( owner, ePingType.ABILITY_DOMESHIELD, projectile, projectile.GetOrigin(), -1, false )
	if ( IsValid( wp ) )
	{
		wp.SetAbsOrigin( projectile.GetOrigin() + <0, 0, 35> )
		wp.SetParent( projectile )
	}

	TrackingVision_CreatePOI( eTrackingVisionNetworkedPOITypes.PLAYER_ABILITY_BUBBLE_BUNKER, owner, projectile.GetOrigin(), owner.GetTeam(), owner )

	entity mover = CreateScriptMover( projectile.GetOrigin(), projectile.GetAngles() )

	entity oldParent = projectile.GetParent()

	if ( IsValid( oldParent ) )
		mover.SetParent( oldParent )

	projectile.SetParent( mover )
	waitthread PlayAnim( projectile, "prop_bubbleshield_deploy", mover )
	thread BubbleShieldIdleAnims( projectile, mover )

	//projectile.Anim_Play( "prop_bubbleshield_deploy" )
	//WaittillAnimDone( projectile )
	//projectile.Anim_Play( "prop_bubbleshield_deploy_idle" )

	int startAttachID = projectile.LookupAttachment( "fx_beam" )
	vector beamFXOrigin = projectile.GetAttachmentOrigin( startAttachID )

	owner.Signal( "DeployBubbleBunker" )

	owner.EndSignal( "OnDestroy" )
	mover.EndSignal( "OnDestroy" )

//	EmitSoundOnEntity( projectile, "Wpn_ArcTrap_Land" )

	OnThreadEnd(
		function() : ( mover, projectile, wp, oldParent )
		{
			if ( IsValid( projectile ) )
			{
				if ( IsValid( oldParent ) )
					projectile.SetParent( oldParent )
				else
					projectile.ClearParent()

				thread ProjectileShutdown( projectile )
			}

			if ( IsValid( wp ) )
			{
				wp.Destroy()
			}

			if ( IsValid( mover ) )
			{
				mover.Destroy()
			}
		}
	)

	FriendlyEnemyFXStruct effects = CreateFriendlyEnemyFX( projectile, BUBBLE_BUNKER_BEAM_FX, beamFXOrigin, <-90,0,0>, team)

	waitthread CreateBubbleShieldAroundProjectile( projectile, team, duration, effects )
}

void function BubbleShieldIdleAnims( entity projectile, entity mover )
{
	projectile.EndSignal( "OnDestroy" )
	mover.EndSignal( "OnDestroy" )

	waitthread PlayAnim( projectile, "prop_bubbleshield_deploy_trans", mover )
	thread PlayAnim( projectile, "prop_bubbleshield_deploy_idle", mover )
}

void function CreateBubbleShieldAroundProjectile( entity projectile, int team, float duration,  FriendlyEnemyFXStruct oldEffects )
{
	projectile.EndSignal( "OnDestroy" )

	entity owner = projectile.GetOwner()

	if ( !IsValid( owner ) )
		return

	owner.EndSignal( "CleanupPlayerPermanents" )

	entity bubbleShield = CreateBubbleShieldWithSettings( owner.GetTeam(), projectile.GetOrigin(), <0,0,0>/*projectile.GetAngles()*/, owner, duration, BUBBLE_BUNKER_DAMAGE_ENEMIES, BUBBLE_BUNKER_SHIELD_FX, BUBBLE_BUNKER_SHIELD_COLLISION_MODEL )
	bubbleShield.RemoveFromAllRealms()
	bubbleShield.AddToOtherEntitysRealms( projectile )

	bubbleShield.SetParent( projectile, "", true )
	bubbleShield.SetCollisionDetailHigh()

	AddEntityCallback_OnPostDamaged( bubbleShield, void function( entity bubbleShield, var damageInfo ) : ( owner ) {
		if ( IsValid( owner ) )
			StatsHook_BubbleShield_OnDamageAbsorbed( owner, damageInfo )
	})

	OnThreadEnd(
		function() : ( oldEffects, bubbleShield )
		{

			if ( IsValid( oldEffects.friendlyColoredFX ) )
				EffectStop( oldEffects.friendlyColoredFX )
			if ( IsValid( oldEffects.enemyColoredFX ) )
				EffectStop( oldEffects.enemyColoredFX )
			if ( IsValid( bubbleShield ) )
				DestroyBubbleShield( bubbleShield )
		}
	)

	//Wait until we are getting close to ending the shield
	wait duration - BUBBLE_BUNKER_DURATION_WARNING

	if ( IsValid( oldEffects.friendlyColoredFX ) )
		EffectStop( oldEffects.friendlyColoredFX )
	if ( IsValid( oldEffects.enemyColoredFX ) )
		EffectStop( oldEffects.enemyColoredFX )

	int startAttachID = projectile.LookupAttachment( "fx_beam" )
	vector beamFXOrigin = projectile.GetAttachmentOrigin( startAttachID )

	FriendlyEnemyFXStruct effects = CreateFriendlyEnemyFX( projectile, BUBBLE_BUNKER_BEAM_END_FX, beamFXOrigin, <-90,0,0>, team)

	OnThreadEnd(
		function() : ( effects, projectile )
		{
			if ( IsValid( effects.friendlyColoredFX ) )
				EffectStop( effects.friendlyColoredFX )
			if ( IsValid( effects.enemyColoredFX ) )
				EffectStop( effects.enemyColoredFX )

			if ( IsValid( projectile ) )
				StopSoundOnEntity( projectile, BUBBLE_BUNKER_SOUND_ENDING )
		}
	)

	EmitSoundOnEntity( projectile, BUBBLE_BUNKER_SOUND_ENDING )

	//wait rest of shield life duration
	wait BUBBLE_BUNKER_DURATION_WARNING

}

void function ProjectileShutdown( entity projectile )
{
	entity mover = CreateScriptMover( projectile.GetOrigin(), projectile.GetAngles() )

	entity oldParent = projectile.GetParent()

	if ( IsValid( oldParent ) )
		mover.SetParent( oldParent )

	projectile.SetParent( mover )

	projectile.EndSignal( "OnDestroy" )

	OnThreadEnd(
		function() : ( mover )
		{
			if ( IsValid( mover ) )
				mover.Destroy()
		}
	)

	EmitSoundOnEntity( projectile, BUBBLE_BUNKER_SOUND_FINISH )
	waitthread PlayAnim( projectile, "prop_bubbleshield_shutdown", mover )
	projectile.Dissolve( ENTITY_DISSOLVE_CORE, <0, 0, 0>, 500 )
	WaitSignal( projectile, "OnDestroy" )
}

FriendlyEnemyFXStruct function CreateFriendlyEnemyFX( entity projectile, asset particleSystem, vector origin, vector rotation, int team)
{
	int particleSystemID = GetParticleSystemIndex( particleSystem )

	//Create friendly and enemy colored particle systems
	entity friendlyColoredFX =  StartParticleEffectInWorld_ReturnEntity( particleSystemID, origin, rotation )
	friendlyColoredFX.SetParent( projectile )
	SetTeam( friendlyColoredFX, team )
	friendlyColoredFX.kv.VisibilityFlags = ENTITY_VISIBLE_TO_FRIENDLY
	EffectSetControlPointVector( friendlyColoredFX, 1, FRIENDLY_COLOR_FX )
	friendlyColoredFX.RemoveFromAllRealms()
	friendlyColoredFX.AddToOtherEntitysRealms( projectile )

	entity enemyColoredFX = StartParticleEffectInWorld_ReturnEntity( particleSystemID, origin, rotation )
	enemyColoredFX.SetParent( projectile )
	SetTeam( enemyColoredFX, team )
	enemyColoredFX.kv.VisibilityFlags = ENTITY_VISIBLE_TO_ENEMY
	EffectSetControlPointVector( enemyColoredFX, 1, ENEMY_COLOR_FX )
	enemyColoredFX.RemoveFromAllRealms()
	enemyColoredFX.AddToOtherEntitysRealms( projectile )

	FriendlyEnemyFXStruct effects
	effects.friendlyColoredFX = friendlyColoredFX
	effects.enemyColoredFX = enemyColoredFX
	effects.team = team

	return effects
}

#endif

#if CLIENT
void function BubbleBunker_EnterDome( entity player, int statusEffect, bool actuallyChanged )
{
	if ( player != GetLocalViewPlayer() )
		return

	file.bubbleBunkerRui = CreateCockpitRui( $"ui/bubble_bunker.rpak", HUD_Z_BASE )
	RuiTrackFloat( file.bubbleBunkerRui, "bleedoutEndTime", player, RUI_TRACK_SCRIPT_NETWORK_VAR, GetNetworkedVariableIndex( "bleedoutEndTime" ) )
	RuiTrackFloat( file.bubbleBunkerRui, "reviveEndTime", player, RUI_TRACK_SCRIPT_NETWORK_VAR, GetNetworkedVariableIndex( "reviveEndTime" ) )
}

void function BubbleBunker_ExitDome( entity player, int statusEffect, bool actuallyChanged )
{
	if ( player != GetLocalViewPlayer() )
		return

	RuiDestroyIfAlive( file.bubbleBunkerRui )
	file.bubbleBunkerRui = null
}

var function GetBubbleBunkerRui()
{
	return file.bubbleBunkerRui
}
#endif //CLIENT


bool function GibraltarIsInDome( entity player )
{
	if ( !PlayerHasPassive( player, ePassives.PAS_ADS_SHIELD ) )
		return false

	return StatusEffect_GetSeverity( player, eStatusEffect.bubble_bunker ) > 0.0
}