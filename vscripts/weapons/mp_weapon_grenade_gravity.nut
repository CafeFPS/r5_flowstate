global function OnProjectileCollision_weapon_grenade_gravity
global function MpWeaponGrenadeGravity_Init

const float MAX_WAIT_TIME = 6.0
const float POP_DELAY = 0.8
const float PULL_DELAY = 2.0
const float PUSH_DELAY = 0.2
const float POP_HEIGHT = 60
const float PULL_RANGE = 150.0
const float PULL_STRENGTH_MAX = 300.0
const float PULL_VERT_VEL = 220
const float PUSH_STRENGTH_MAX = 125.0
const float EXPLOSION_DELAY = 0.1
const float FX_END_CAP_TIME = 1.5
//const float PULL_VERTICAL_KNOCKUP_MAX = 75.0
//const float PULL_VERTICAL_KNOCKUP_MIN = 55.0
//const float PUSH_STRENGTH_MIN = 100.0
struct
{
	int cockpitFxHandle = -1
} file

const asset GRAVITY_VORTEX_FX = $"P_wpn_grenade_gravity"
//const asset GRAVITY_SCREEN_FX = $"P_gravity_mine_FP"

void function MpWeaponGrenadeGravity_Init()
{
	PrecacheParticleSystem( GRAVITY_VORTEX_FX )
	//PrecacheParticleSystem( GRAVITY_SCREEN_FX )
	RegisterSignal( "GravityMineTriggered" )
	RegisterSignal( "TouchVisible" )
	RegisterSignal( "LeftGravityMine" )

	#if CLIENT
 	StatusEffect_RegisterEnabledCallback( eStatusEffect.gravity_grenade_visual, GravityScreenFXEnable )
 	StatusEffect_RegisterDisabledCallback( eStatusEffect.gravity_grenade_visual, GravityScreenFXDisable )
	#endif
}

void function OnProjectileCollision_weapon_grenade_gravity( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical )
{
	bool didStick = PlantSuperStickyGrenade( projectile, pos, normal, hitEnt, hitbox )

	if ( !didStick )
		return
	#if SERVER
		if ( projectile.IsMarkedForDeletion() )
			return

		thread GravityGrenadeThink( projectile, hitEnt, normal, pos )
	#endif
}

#if SERVER
void function TriggerWait( entity trig, float maxtime )
{
	trig.CheckForLOS()
	trig.EndSignal( "TouchVisible" )
	wait maxtime
}

void function SetGravityGrenadeTriggerFilters( entity gravityMine, entity trig )
{
	trig.kv.triggerFilterNonCharacter = "0"
}

bool function GravityGrenadeTriggerThink( entity gravityMine )
{
	entity trig = CreateEntity( "trigger_cylinder" )
	trig.SetRadius( PULL_RANGE )
	trig.SetAboveHeight( PULL_RANGE )
	trig.SetBelowHeight( PULL_RANGE )
	trig.SetAbsOrigin( gravityMine.GetOrigin() )

	SetGravityGrenadeTriggerFilters( gravityMine, trig )

	DispatchSpawn( trig )
	trig.SearchForNewTouchingEntity()

	OnThreadEnd(
		function() : ( trig )
		{
			trig.Destroy()
		}
	)

	waitthread TriggerWait( trig, MAX_WAIT_TIME )

	return trig.IsTouched()
}


void function GravityGrenadeThink( entity projectile, entity hitEnt, vector normal, vector pos )
{
	projectile.EndSignal( "OnDestroy" )

	WaitFrame()

	SetTeam( projectile, TEAM_UNASSIGNED ) // TEMP TEST

	vector pullPosition
	if ( hitEnt == svGlobal.worldspawn )
		pullPosition = pos + normal * POP_HEIGHT
	else
		pullPosition = projectile.GetOrigin()

	entity gravTrig = CreateEntity( "trigger_point_gravity" )
	// pull inner radius, pull outer radius, reduce speed inner radius, reduce speed outer radius, pull accel, pull speed, 0
	gravTrig.SetParams( 0.0, PULL_RANGE * 2, 32, 128, 1500, 600 ) // more subtle pulling effect before popping up
	gravTrig.SetOrigin( projectile.GetOrigin() )
	projectile.ClearParent()
	projectile.SetParent( gravTrig )
	gravTrig.RoundOriginAndAnglesToNearestNetworkValue()

	entity trig = CreateEntity( "trigger_cylinder" )
	trig.SetRadius( PULL_RANGE )
	trig.SetAboveHeight( PULL_RANGE )
	trig.SetBelowHeight( PULL_RANGE )
	trig.SetOrigin( projectile.GetOrigin() )
	SetGravityGrenadeTriggerFilters( projectile, trig )
	trig.kv.triggerFilterPlayer = "none" // player effects
	trig.SetEnterCallback( OnGravGrenadeTrigEnter )
	trig.SetLeaveCallback( OnGravGrenadeTrigLeave )

	SetTeam( gravTrig, projectile.GetTeam() )
	SetTeam( trig, projectile.GetTeam() )
	DispatchSpawn( gravTrig )
	DispatchSpawn( trig )
	gravTrig.SearchForNewTouchingEntity()
	trig.SearchForNewTouchingEntity()

	EmitSoundOnEntity( projectile, "titan_death_explode" )
	entity FX = StartParticleEffectOnEntity_ReturnEntity( projectile, GetParticleSystemIndex( GRAVITY_VORTEX_FX ), FX_PATTACH_ABSORIGIN_FOLLOW, -1 )

	string noSpawnArea = CreateNoSpawnArea( TEAM_INVALID, projectile.GetTeam(), projectile.GetOrigin(), MAX_WAIT_TIME + POP_DELAY + PULL_DELAY + EXPLOSION_DELAY + 0.1, PULL_RANGE * 3.0 )

	OnThreadEnd(
		function() : ( gravTrig, trig, FX, noSpawnArea )
		{
			if ( IsValid( trig ) )
				trig.Destroy()
			if ( IsValid( gravTrig ) )
				gravTrig.Destroy()

			EntFireByHandle( FX, "kill", "", FX_END_CAP_TIME, null, null )

			DeleteNoSpawnArea( noSpawnArea )
		}
	)

	wait POP_DELAY

	entity mover = CreateOwnedScriptMover( projectile )
	projectile.SetParent( mover, "ref", true )
	EmitSoundOnEntity( projectile, "weapon_gravitystar_preexplo" )

	if ( hitEnt == svGlobal.worldspawn )
	{
		mover.NonPhysicsMoveTo( pullPosition, POP_DELAY, 0, POP_DELAY )
		gravTrig.SetOrigin( pullPosition )
		gravTrig.RoundOriginAndAnglesToNearestNetworkValue()
	}

	// full strength radius, outer radius, reduce vel radius, accel, maxvel
	gravTrig.SetParams( PULL_RANGE, PULL_RANGE * 2, 32, 128, 2000, 400 ) // more intense pull

	AI_CreateDangerousArea( projectile, projectile, PULL_RANGE * 2.0, TEAM_INVALID, true, false )

	wait PULL_DELAY

	projectile.SetGrenadeTimer( EXPLOSION_DELAY )
	wait EXPLOSION_DELAY - 0.1 // ensure gravTrig is destroyed before detonation
	thread DestroyAfterDelay( mover, 0.25 )
}

void function OnGravGrenadeTrigEnter( entity trigger, entity ent )
{
	if ( ent.GetTeam() == trigger.GetTeam() ) // trigger filters handle this except in FFA
		return

	if ( ent.IsNPC() && ( IsGrunt( ent ) || IsSpectre( ent ) || IsStalker( ent ) ) && IsAlive( ent ) && !ent.ContextAction_IsActive() && ent.IsInterruptable() )
	{
		ent.ContextAction_SetBusy()
		ent.Anim_ScriptedPlayActivityByName( "ACT_FALL", true, 0.2 )

		if ( IsGrunt( ent ) )
			EmitSoundOnEntity( ent, "diag_efforts_gravStruggle_gl_grunt_3p" )

		thread EndNPCGravGrenadeAnim( ent )
	}
}

void function OnGravGrenadeTrigLeave( entity trigger, entity ent )
{
	if ( IsValid( ent ) )
	{
		ent.Signal( "LeftGravityMine" )
	}
}

void function EndNPCGravGrenadeAnim( entity ent )
{
	ent.EndSignal( "OnDestroy" )
	ent.EndSignal( "OnAnimationInterrupted" )
	ent.EndSignal( "OnAnimationDone" )

	ent.WaitSignal( "LeftGravityMine", "OnDeath" )

	ent.ContextAction_ClearBusy()
	ent.Anim_Stop()
}

void function Proto_SetEnemyVelocity_Pull( entity enemy, vector projOrigin )
{
	if ( enemy.IsPhaseShifted() )
		return
	vector enemyOrigin = enemy.GetOrigin()
	vector dir = Normalize( projOrigin - enemy.GetOrigin() )
	float dist = Distance( enemyOrigin, projOrigin )
	float distZ = enemyOrigin.z - projOrigin.z
	vector newVelocity = enemy.GetVelocity() * GraphCapped( dist, 50, PULL_RANGE, 0, 1 ) + dir * GraphCapped( dist, 50, PULL_RANGE, 0, PULL_STRENGTH_MAX ) + < 0, 0, GraphCapped( distZ, -50, 0, PULL_VERT_VEL, 0 )>
	if ( enemy.IsTitan() )
		newVelocity.z = 0
	enemy.SetVelocity( newVelocity )
}

array<entity> function GetNearbyEnemiesForGravGrenade( entity projectile )
{
	int team = projectile.GetTeam()
	entity owner = projectile.GetOwner()
	vector origin = projectile.GetOrigin()
	array<entity> nearbyEnemies
	array<entity> guys = GetPlayerArrayEx( "any", TEAM_ANY, TEAM_ANY, origin, PULL_RANGE )
	foreach ( guy in guys )
	{
		if ( !IsAlive( guy ) )
			continue

		if ( IsEnemyTeam( team, guy.GetTeam() ) || (IsValid( owner ) && guy == owner) )
			nearbyEnemies.append( guy )
	}

	array<entity> ai = GetNPCArrayEx( "any", TEAM_ANY, team, origin, PULL_RANGE )
	foreach ( guy in ai )
	{
		if ( IsAlive( guy ) )
			nearbyEnemies.append( guy )
	}

	return nearbyEnemies
}

array<entity> function GetNearbyProjectilesForGravGrenade( entity gravGrenade )
{
	int team = gravGrenade.GetTeam()
	entity owner = gravGrenade.GetOwner()
	vector origin = gravGrenade.GetOrigin()

	array<entity> projectiles = GetProjectileArrayEx( "any", TEAM_ANY, TEAM_ANY, origin, PULL_RANGE )

	array<entity> affectedProjectiles

	entity projectileOwner
	foreach( projectile in projectiles )
	{
		if ( projectile == gravGrenade )
			continue

		projectileOwner = projectile.GetOwner()
		if ( IsEnemyTeam( team, projectile.GetTeam() ) || ( IsValid( projectileOwner ) && projectileOwner == owner ) )
			affectedProjectiles.append( projectile )
	}

	return affectedProjectiles
}

//point_push version - hard to control motion with this.
/*
void function CreateGravitationalForce( float mag, vector org )
{
	entity point_push = CreateEntity( "point_push" )
	point_push.kv.spawnflags = 31
	point_push.kv.enabled = 1
	point_push.kv.magnitude = mag
	point_push.kv.radius = PULL_RANGE
	point_push.SetOrigin( org )
	DispatchSpawn( point_push )
	point_push.Fire( "Enable" )
	point_push.Fire( "Kill", "", 0.2 )
}
*/
//Script mover version
/*
array<entity> nearbyEnemies = GetNearbyEnemiesForGravGrenade( projectile )
foreach ( enemy in nearbyEnemies )
{
	if ( enemy.IsPlayer() )
		EmitSoundOnEntityOnlyToPlayer( enemy, enemy, "explo_softball_impact_3p" )

	if ( !enemy.IsTitan() )
		thread PROTO_GravGrenadePull( enemy, projectile )
}
void function PROTO_GravGrenadePull( entity enemy, entity projectile )
{
	enemy.EndSignal( "OnDestroy" )

	entity mover = CreateOwnedScriptMover( enemy )
	enemy.SetParent( mover, "ref", true )

	OnThreadEnd(
	function() : ( enemy, mover )
		{
			if ( IsValid( enemy ) )
				enemy.ClearParent()

			if ( IsValid( mover ) )
				mover.Destroy()
		}
	)

	if ( enemy.IsPlayer() )
		enemy.StunMovementBegin( POP_DELAY )

	vector mins = enemy.GetBoundingMins()
	vector maxs = enemy.GetBoundingMaxs()
	vector org1 = enemy.GetOrigin()
	vector org2 = projectile.GetOrigin()
	vector additonalHeight = < 0, 0, GraphCapped( Distance( org1, org2 ), 0, PULL_RANGE, PULL_VERTICAL_KNOCKUP_MIN, PULL_VERTICAL_KNOCKUP_MAX ) >
	vector newPosition = org1 + ( org2 - org1 ) / 2.0 + additonalHeight
	TraceResults result = TraceHull( org1, newPosition, mins, maxs, [enemy,mover], TRACE_MASK_SOLID_BRUSHONLY, TRACE_COLLISION_GROUP_NONE )
	mover.NonPhysicsMoveTo( ( newPosition - org1 ) * result.fraction + org1 + result.surfaceNormal, PULL_DELAY, 0, 0 )

	wait PULL_DELAY

	org1 = mover.GetOrigin()
	vector dir = Normalize( org1 - org2 )
	newPosition = org1 + dir * RandomFloatRange( PUSH_STRENGTH_MIN, PUSH_STRENGTH_MAX )
	result = TraceHull( org1, newPosition, mins, maxs, [enemy,mover], TRACE_MASK_SOLID_BRUSHONLY, TRACE_COLLISION_GROUP_NONE )
	mover.NonPhysicsMoveTo( ( newPosition - org1 ) * result.fraction + org1 + result.surfaceNormal, PUSH_DELAY, 0, 0 )

	wait PUSH_DELAY
}
*/
#endif

#if CLIENT
void function GravityScreenFXEnable( entity ent, int statusEffect, bool actuallyChanged )
{
	printt( "GravityScreenFXEnable" )
	if ( !actuallyChanged )
		return

	if ( ent == GetLocalViewPlayer() )
	{
		entity cockpit =GetLocalViewPlayer().GetCockpit()
		//if ( IsValid( cockpit ) )
		//{
		//	file.cockpitFxHandle = StartParticleEffectOnEntity( cockpit, GetParticleSystemIndex( GRAVITY_SCREEN_FX ), FX_PATTACH_POINT_FOLLOW, cockpit.LookupAttachment("CAMERA") )
		//}
	}
}

void function GravityScreenFXDisable( entity ent, int statusEffect, bool actuallyChanged )
{
	printt( "GravityScreenFXDisable" )
	if ( !actuallyChanged )
		return

	if ( ent == GetLocalViewPlayer() )
	{
		EffectStop( file.cockpitFxHandle, false, true )
	}
}
#endif