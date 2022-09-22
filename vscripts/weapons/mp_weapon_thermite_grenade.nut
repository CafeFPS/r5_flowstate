
global function MpWeaponThermiteGrenade_Init
global function OnProjectileCollision_weapon_thermite_grenade
global function OnWeaponActivate_ThermiteGrenade
global function OnWeaponDeactivate_ThermiteGrenade

const asset PREBURN_EFFECT_ASSET = $"mWall_CH_smoke_light"
const asset BURN_EFFECT_ASSET = $"P_wpn_meteor_wall"

#if SERVER
	const bool DEBUG_THERMITE_GRENADE_TRACES = false
#endif // SERVER

struct SegmentData
{
	//int index
	vector startPos
	vector endPos
	vector angles
	string sound
	entity moveParent
}

void function MpWeaponThermiteGrenade_Init()
{
	PrecacheParticleSystem( PREBURN_EFFECT_ASSET )
	PrecacheParticleSystem( BURN_EFFECT_ASSET )
}

void function OnWeaponActivate_ThermiteGrenade( entity weapon )
{
	#if CLIENT
		thread FadeModelIntensityOverTime( weapon, 2, 0, 255)
	#endif

	weapon.EmitWeaponSound_1p3p( "", "weapon_thermitegrenade_draw_3p" )
}

void function OnWeaponDeactivate_ThermiteGrenade( entity weapon )
{
	#if CLIENT
		thread FadeModelIntensityOverTime( weapon, 0.25, 255, 0 )
	#endif

	Grenade_OnWeaponDeactivate( weapon )
}

void function OnProjectileCollision_weapon_thermite_grenade( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical )
{
	entity player = projectile.GetOwner()
	if ( hitEnt == player )
		return

	projectile.proj.projectileBounceCount++
	//printt( "bounceCount:", projectile.proj.projectileBounceCount )

	int maxBounceCount = projectile.GetProjectileWeaponSettingInt( eWeaponVar.projectile_ricochet_max_count )

	bool forceExplode = false
	if ( projectile.proj.projectileBounceCount > maxBounceCount )
	{
		//printt( "max bounceCount hit, forcing explosion" )
		forceExplode = true
	}

	bool projectileIsOnGround = normal.Dot( <0,0,1> ) > 0.75
	if ( !projectileIsOnGround && !forceExplode )
		return

	//if ( !forceExplode )
	//	printt( "projectileIsOnGround with Dot:", normal.Dot( <0,0,1> ) )

	table collisionParams =
	{
		pos = pos,
		normal = normal,
		hitEnt = hitEnt,
		hitbox = hitbox
	}

	vector dir = projectile.proj.savedDir
	dir.z = 0
	dir = Normalize( dir )

	if ( !PlantStickyEntity( projectile, collisionParams ) && !forceExplode )
		return

	projectile.SetDoesExplode( false )

#if SERVER
	projectile.proj.onlyAllowSmartPistolDamage = false

	if ( !IsValid( player ) )
	{
		projectile.Destroy()
		return
	}
	bool shouldFlipDir = true
	array<string> mods = projectile.ProjectileGetMods()
	foreach ( mod in mods )
	{
		if ( mod == "vertical_firestar" )
			shouldFlipDir = false
	}

	if ( shouldFlipDir )
		dir = CrossProduct( dir, normal )

	BurnDamageSettings burnSettings
	burnSettings.damageSourceID 		= projectile.ProjectileGetDamageSourceID()
	burnSettings.preburnDuration 		= expect float( projectile.ProjectileGetWeaponInfoFileKeyField( "preburn_duration" ) )
	burnSettings.burnDuration 			= expect float( projectile.ProjectileGetWeaponInfoFileKeyField( "burn_duration" ) )
	burnSettings.burnDamage 			= expect int( projectile.ProjectileGetWeaponInfoFileKeyField( "burn_damage" ) )
	burnSettings.burnTime 				= expect float( projectile.ProjectileGetWeaponInfoFileKeyField( "burn_time" ) )
	burnSettings.burnTickRate 			= expect float( projectile.ProjectileGetWeaponInfoFileKeyField( "burn_tick_rate" ) )
	burnSettings.burnDamageRadius 		= expect float( projectile.ProjectileGetWeaponInfoFileKeyField( "burn_segment_radius" ) )
	burnSettings.burnDamageHeight 		= expect float( projectile.ProjectileGetWeaponInfoFileKeyField( "burn_segment_height" ) )
	burnSettings.soundBurnSegmentStart 	= expect string( projectile.ProjectileGetWeaponInfoFileKeyField( "sound_burn_segment_start" ) )
	burnSettings.soundBurnSegmentMiddle = expect string( projectile.ProjectileGetWeaponInfoFileKeyField( "sound_burn_segment_middle" ) )
	burnSettings.soundBurnSegmentEnd 	= expect string( projectile.ProjectileGetWeaponInfoFileKeyField( "sound_burn_segment_end" ) )
	burnSettings.soundBurnDamageTick_1P = expect string( projectile.ProjectileGetWeaponInfoFileKeyField( "sound_burn_damage_tick_1p" ) )
	burnSettings.burnStackDebounce 		= expect float( projectile.ProjectileGetWeaponInfoFileKeyField( "burn_stack_debounce" ) )
	burnSettings.burnStacksMax 			= expect int( projectile.ProjectileGetWeaponInfoFileKeyField( "burn_stacks_max" ) )
	burnSettings.segmentSpacingDist 	= expect float( projectile.ProjectileGetWeaponInfoFileKeyField( "burn_segment_spacing_dist" ) )

	int numSegments = expect int( projectile.ProjectileGetWeaponInfoFileKeyField( "burn_segments" ) )

	entity owner = projectile.GetOwner()
	entity inflictor = CreateOncePerTickDamageInflictorHelper( burnSettings.burnDuration )

	if ( shouldFlipDir )
	{
		thread BeginFire( owner, inflictor, projectile.GetOrigin(), dir, numSegments, false, burnSettings )
		thread BeginFire( owner, inflictor, projectile.GetOrigin(), -1 * dir, numSegments, true, burnSettings )
	}
	else
	{
		thread BeginFire( owner, inflictor, projectile.GetOrigin(), dir, numSegments * 2, false, burnSettings )
	}

	projectile.GrenadeExplode( normal )
#endif // SERVER
}


void function FadeModelIntensityOverTime( entity model, float duration, int startColor = 255, int endColor = 0 )
{
	EndSignal( model, "OnDestroy" )

	float startTime = Time()
	float endTime = startTime + duration

	//model.kv.rendermode = 0

	while ( Time() <= endTime )
	{
		float alphaResult = GraphCapped( Time(), startTime, endTime, startColor, endColor )
		string colorString = alphaResult + " " + alphaResult + " " + alphaResult
		model.kv.rendercolor = colorString
		model.kv.renderamt = 255
		//printt ("Entity: " + model + " Time: " + Time() + " Color: " + colorString + " startColor:" + startColor + " endColor:" + endColor + " startTime: " + startTime + " EndTime: " + endTime)
		WaitFrame()
	}

	model.kv.rendercolor = endColor + " " + endColor + " " + endColor
	model.kv.renderamt = 255

}


#if SERVER
void function BeginFire( entity owner, entity inflictor, vector pos, vector dir, int numSegments, bool skipFirstStep, BurnDamageSettings burnSettings )
{
	owner.EndSignal( "OnDestroy" )

	array<SegmentData> segmentsArray = CreateSpreadPattern( owner, inflictor, pos, dir, numSegments, burnSettings )
	// don't try to use an empty array
	if ( !segmentsArray.len() )
		return

	if ( skipFirstStep )
		segmentsArray.remove( 0 )
	waitthread BurnSequence( owner, inflictor, segmentsArray, burnSettings )
}

void function BurnSequence( entity owner, entity inflictor, array<SegmentData> segmentsArray, BurnDamageSettings burnSettings )
{
	owner.EndSignal( "OnDestroy" )

	foreach ( segment in segmentsArray )
	{
		thread DoSegment( owner, inflictor, segment, burnSettings )
		WaitFrame()
	}
}

void function DoSegment( entity owner, entity inflictor, SegmentData segment, BurnDamageSettings burnSettings )
{
	owner.EndSignal( "OnDestroy" )

	entity preburnEffect = CreateSegmentEffect( PREBURN_EFFECT_ASSET, owner, segment.startPos, segment.endPos, segment.angles, burnSettings.preburnDuration )

	wait burnSettings.preburnDuration

	entity burnEffect = CreateSegmentEffect( BURN_EFFECT_ASSET, owner, segment.startPos, segment.endPos, segment.angles, burnSettings.burnDuration )
	AI_CreateDangerousArea_Static( burnEffect, inflictor, burnSettings.burnDamageRadius, TEAM_INVALID, true, true, segment.endPos )
	thread FireSegment_DamageThink( burnEffect, owner, inflictor, burnSettings )

	if ( segment.sound != "" )
		EmitSoundOnEntity( burnEffect, segment.sound )
}

array<SegmentData> function CreateSpreadPattern( entity owner, entity inflictor, vector pos, vector dir, int stepCount, BurnDamageSettings burnSettings )
{
	owner.EndSignal( "OnDestroy" )

	int count = 0
	vector lastDownPos = pos
	bool firstTrace = true
	array<SegmentData> segmentsArray

	dir.z = 0
	dir = Normalize( dir )
	vector angles = VectorToAngles( dir )

	bool staggerDirState = CoinFlip()
	float staggerDegrees = 0.0
	vector staggerOffsetVec
	vector staggerDir

	for ( int i = 0; i < stepCount; i++ )
	{
		if ( staggerDirState )
			staggerOffsetVec = <0,staggerDegrees,0>
		else
			staggerOffsetVec = <0,-staggerDegrees,0>

		if ( i == 1 ) // half offset for 2nd placement
			staggerOffsetVec *= 0.5

		staggerDir = Normalize( VectorRotate( dir, staggerOffsetVec ) )
		staggerDirState = !staggerDirState

		vector newPos = pos
		if ( !firstTrace )
			newPos += staggerDir * burnSettings.segmentSpacingDist

		vector traceStart = pos
		vector traceEndUnder = newPos
		vector traceEndOver = newPos

		if ( !firstTrace )
		{
			traceStart = lastDownPos + <0,0,80>
			traceEndUnder = <newPos.x, newPos.y, traceStart.z - 40>
			traceEndOver = <newPos.x, newPos.y, traceStart.z + burnSettings.segmentSpacingDist * 0.57735056839> // The over height is to cover the case of a sheer surface that then continues gradually upwards (like mp_box)
		}
		firstTrace = false

		#if DEVELOPER && DEBUG_THERMITE_GRENADE_TRACES
			DebugDrawLine( traceStart, traceEndUnder, 0, 255, 0, true, 25.0 )
		#endif

		array ignoreArray = []
		if ( IsValid( inflictor ) && inflictor.GetOwner() != null )
			ignoreArray.append( inflictor.GetOwner() )

		TraceResults forwardTrace = TraceLine( traceStart, traceEndUnder, ignoreArray, TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_BLOCK_WEAPONS )
		if ( forwardTrace.fraction == 1.0 )
		{
			#if DEVELOPER && DEBUG_THERMITE_GRENADE_TRACES
				DebugDrawLine( forwardTrace.endPos, forwardTrace.endPos + <0,0,-225>, 255, 0, 0, true, 25.0 )
			#endif

			TraceResults downTrace = TraceLine( forwardTrace.endPos, forwardTrace.endPos + <0,0,-225>, ignoreArray, TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_BLOCK_WEAPONS )
			if ( downTrace.fraction == 1.0 )
				continue

			SegmentData segment
			//segment.index = i
			segment.startPos = lastDownPos
			segment.endPos = downTrace.endPos
			segment.angles = angles
			segment.sound = GetSoundForSegment( i, stepCount, burnSettings )
			//printt( "i:", i, "stepCount:", stepCount, "segment.sound:", segment.sound )
			segmentsArray.append( segment )

			lastDownPos = downTrace.endPos
			pos = forwardTrace.endPos

			continue
		}

		TraceResults upwardTrace = TraceLine( traceStart, traceEndOver, ignoreArray, TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_BLOCK_WEAPONS )

		#if DEVELOPER && DEBUG_THERMITE_GRENADE_TRACES
			DebugDrawLine( traceStart, traceEndOver, 0, 0, 255, true, 25.0 )
		#endif

		if ( upwardTrace.fraction < 1.0 && IsValid( upwardTrace.hitEnt ) && upwardTrace.hitEnt.IsWorld() )
		{
			continue
		}
		else
		{
			TraceResults downTrace = TraceLine( upwardTrace.endPos, upwardTrace.endPos + <0,0,-1000>, ignoreArray, TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_BLOCK_WEAPONS )
			if ( downTrace.fraction == 1.0 )
				continue

			SegmentData segment
			//segment.index = i
			segment.startPos = lastDownPos
			segment.endPos = downTrace.endPos
			segment.angles = angles
			segment.sound = GetSoundForSegment( i, stepCount, burnSettings )
			//printt( "i:", i, "stepCount:", stepCount, "segment.sound:", segment.sound )
			segmentsArray.append( segment )

			lastDownPos = downTrace.endPos
			pos = forwardTrace.endPos
		}
	}

	#if DEVELOPER && DEBUG_THERMITE_GRENADE_TRACES
		printt( "Total segments:", segmentsArray.len() )
	#endif

	return segmentsArray
}

entity function CreateSegmentEffect( asset effectAsset, entity owner, vector startPos, vector endPos, vector angles, float duration )
{
	Assert( IsValid( owner ) )

	entity effect = StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( effectAsset ), endPos, angles )
	effect.SetOwner( owner )
	AddToUltimateRealm( owner, effect )

	EffectSetControlPointVector( effect, 1, startPos )

	if ( duration > 0 )
		EntFireByHandle( effect, "Kill", "", duration, null, null )

	return effect
}

void function FireSegment_DamageThink( entity effect, entity owner, entity inflictor, BurnDamageSettings burnSettings )
{
	Assert( IsValid( owner ) )

	float topDelta = burnSettings.burnDamageHeight
	float bottomDelta = 0
	entity trig = CreateTriggerCylinderMultiple( effect.GetOrigin(), burnSettings.burnDamageRadius, topDelta, bottomDelta, [], TRIG_FLAG_NONE )
	trig.RemoveFromAllRealms()
	trig.AddToOtherEntitysRealms( owner )
	ScriptTriggerSetEnabled( trig, true )

	effect.EndSignal( "OnDestroy" )
	trig.EndSignal( "OnDestroy" )
	inflictor.EndSignal( "OnDestroy" )

	OnThreadEnd(
		function() : ( effect, trig )
		{
			EffectStop( effect )

			if ( IsValid( trig ) )
				trig.Destroy()
		}
	)

	while ( 1 )
	{
		array<entity> touchingEnts = GetAllEntitiesInTrigger( trig )
		ArrayRemoveDead( touchingEnts )

		foreach ( ent in touchingEnts )
			TryApplyingBurnDamage( ent, owner, inflictor, burnSettings )

		WaitFrame()
	}
}

string function GetSoundForSegment( int index, int max, BurnDamageSettings burnSettings )
{
	string weaponSettingKey = ""
	string soundAlias = ""

	if ( index == 0 )
		soundAlias = burnSettings.soundBurnSegmentStart
	else if ( index == ( max - 1 ) )
		soundAlias = burnSettings.soundBurnSegmentEnd
	else if ( index == max / 2 )
		soundAlias = burnSettings.soundBurnSegmentMiddle

	return soundAlias
}

#endif // SERVER