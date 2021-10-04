global function BirdClusterSharedInit

#if SERVER
	global function BirdClusterManager
	#if R5DEV
		global function ClusterDebug
		global function DEV_CreateBirdCluster
		global function AddFakeCluster
	#endif //DEV
#endif //SERVER
#if CLIENT
	global function BirdClusterPointSpawned
#endif //CLIENT

const vector TRACKING_ICON_OFFSET = <0,0,16>
const vector TRACKING_ICON_OFFSET_SHORT = <0,0,8>

const CLUSTER_SPAWN_MIN_RADIUS = 32
const CLUSTER_SPAWN_MAX_RADIUS = 192
const CLUSTER_TRIGGER_RADIUS = 512
const CLUSTER_TRIGGER_HEIGHT = 128
const CLUSTER_TRIGGER_DEPTH = 64
const CLUSTER_MAX_DIST = 2500
const CLUSTER_MID_DIST = 1500
const CLUSTER_MIN_DIST = 512
const CLUSTER_MAX_DIST_SQR = CLUSTER_MAX_DIST * CLUSTER_MAX_DIST
const CLUSTER_MID_DIST_SQR = CLUSTER_MID_DIST * CLUSTER_MID_DIST
const CLUSTER_MIN_DIST_SQR = CLUSTER_MIN_DIST * CLUSTER_MIN_DIST
const CLUSTER_NEAR_DIST_SQR = 768 * 768
const CLUSTER_LIFETIME = 60
const CLUSTER_ITERATION_INTERVAL = 0.25
const CLUSTER_SIZE_THRESHOLD = 5
const CLUSTER_MAX_TAKEOFF_DELAY = 0.3
const CLUSTER_USE_FAKE = false
const CLUSTER_DEBUG_CLUSTER = false

global const asset CLUSTER_BIRD_MODEL = $"mdl/creatures/bird/bird.rmdl"
global const CLUSTER_BIRD_DISSOLVE_VFX = $"dissolve_bird"

#if SERVER
struct BirdCluster
{
	entity        owner
	entity        trigger
	float         spawnTime
	vector        origin
	array<entity> pointArray
	bool          triggered
	bool          blocker
}
#endif //SERVER

#if CLIENT
struct BirdClusterInfo
{
	array<entity> birdArray
	entity birdClusterMainEnt
	entity ownerPlayer
}
#endif //CLIENT

struct
{
	#if SERVER
		array< BirdCluster > birdClusterArray
		#if R5DEV
			array<WaypointClusterInfo> fakeClusters
		#endif //DEV
	#endif //SERVER
	#if CLIENT
		array< BirdClusterInfo > birdClusterInfoArray
	#endif //CLIENT
} file

void function BirdClusterSharedInit()
{
	bool birdClusterEnabled = GetCurrentPlaylistVarBool( "bloodhound_bird_cluster", true )
	if ( !birdClusterEnabled )
		return

	#if SERVER
		PrecacheModel( CLUSTER_BIRD_MODEL )
		PrecacheParticleSystem( CLUSTER_BIRD_DISSOLVE_VFX )

		AddCallback_GameStateEnter( eGameState.WaitingForPlayers, BirdCluster_OnGameStateEnter_WaitingForPlayers )
	#endif
	#if CLIENT
		AddTargetNameCreateCallback( "bird_cluster_point", BirdClusterPointSpawned )
	#endif
}

#if SERVER
void function BirdCluster_OnGameStateEnter_WaitingForPlayers()
{
	thread BirdClusterManager()
	#if R5DEV
		thread ClusterDebug()
	#endif
}

void function BirdClusterManager()
{
	int max_clusters_total = GetCurrentPlaylistVarInt( "bloodhound_bird_cluster_max_count_total", 12 )
	int max_clusters_owner = GetCurrentPlaylistVarInt( "bloodhound_bird_cluster_max_count_owner", 3 )

	while( true )
	{
		PerfStart( PerfIndexServer.BirdCluster )

		RemoveExpiredBirdClusters()

		if ( GetNumberOfBirdClusters() >= max_clusters_total )
		{
			PerfEnd( PerfIndexServer.BirdCluster )
			wait CLUSTER_ITERATION_INTERVAL
			continue
		}


		array<entity> trackingPlayerArray = GetAllTrackingPlayers()
		foreach( player in trackingPlayerArray )
		{
			Assert( IsValid( player ) )

			int activeClusterCount = GetNumberOfBirdClustersForPlayer( player )
			if ( activeClusterCount >= max_clusters_owner )
				continue

			array<WaypointClusterInfo> waypointClusterArray = GetNewWaypointClusters( player, CLUSTER_SIZE_THRESHOLD )

			bool clusterCreated = false
			foreach( clusterData in waypointClusterArray )
			{
				BirdCluster ornull birdCluster = CreateBirdCluster( player, clusterData.clusterPos, 5 )
				if ( birdCluster == null )
					break

				expect BirdCluster( birdCluster )

				file.birdClusterArray.append( birdCluster )
				activeClusterCount++

				clusterCreated = true
				break
			}

			if ( clusterCreated )
				break
		}

		PerfEnd( PerfIndexServer.BirdCluster )
		wait CLUSTER_ITERATION_INTERVAL
	}
}

array<WaypointClusterInfo> function GetNewWaypointClusters( entity player, int minCount )
{
	vector playerOrigin = player.GetOrigin()
	array<WaypointClusterInfo> clusterArray

	array<WaypointClusterInfo> waypointClusterArray = GetServerWaypointClusters( playerOrigin, CLUSTER_MAX_DIST, minCount, player.GetTeam() )
	#if R5DEV
	if ( CLUSTER_USE_FAKE )
		waypointClusterArray = file.fakeClusters
	#endif

	foreach( cluster in waypointClusterArray )
	{
		float distSqr = DistanceSqr( playerOrigin,  cluster.clusterPos )

		// use this if we are using the fake stuff
		if ( CLUSTER_USE_FAKE && ( distSqr > CLUSTER_MAX_DIST_SQR || distSqr < CLUSTER_MIN_DIST_SQR ) )
			continue

		if ( distSqr < CLUSTER_MIN_DIST_SQR )
			continue

		if ( IsNearPlayerCluster( player, cluster.clusterPos, CLUSTER_NEAR_DIST_SQR ) )
			continue

		if ( distSqr < CLUSTER_MID_DIST_SQR && PlayerCanSeePos( player, cluster.clusterPos + <0,0,16>, true, 50 ) )
			continue

		clusterArray.append( cluster )
	}

	return clusterArray
}

BirdCluster ornull function CreateBirdCluster( entity player, vector origin, int count )
{
	array<entity> pointArray
	PerfStart( PerfIndexServer.BirdCluster_perch )
	array<Point> perchArray = GetRandomPerchPositions( origin, count, player )
	PerfEnd( PerfIndexServer.BirdCluster_perch )

	BirdCluster birdCluster

	if ( perchArray.len() == 0 )
	{
		// invalidate the location by adding a bird cluster marked as a blocker
		birdCluster.spawnTime = Time()
		birdCluster.origin = origin
		birdCluster.blocker = true
		return birdCluster
	}

	//printt( "CREATE A BIRD CLUSTER @", origin, ", with", perchArray.len(), "birds" )

	// only one of the points will have a player as an owner, the other will have that point as it's owner.
	// This	gived me the ability to group them on the client as they spawn.
	entity owner = player

	foreach( index, perch in perchArray )
	{
		PerfStart( PerfIndexServer.BirdCluster_spawn )

		entity info_target = CreateEntity( "info_target" )
		info_target.SetOrigin( perch.origin )
		info_target.SetAngles( perch.angles )
		info_target.kv.targetname = "bird_cluster_point"
		info_target.SetOwner( owner )
		SetSpawnflags( info_target, 2 )
		DispatchSpawn( info_target )

		if ( owner == player )
			owner = info_target

		pointArray.append( info_target )
		PerfEnd( PerfIndexServer.BirdCluster_spawn )
	}

	entity trigger = CreateTriggerCylinder( origin, CLUSTER_TRIGGER_RADIUS, CLUSTER_TRIGGER_HEIGHT, CLUSTER_TRIGGER_DEPTH )
	trigger.SetOwner( player )
	trigger.SetEnterCallback( OnEnterBirdTrigger )

	birdCluster.spawnTime = Time()
	birdCluster.origin = origin
	birdCluster.owner = player
	birdCluster.pointArray = pointArray
	birdCluster.trigger = trigger

	HeatMapStat( player, "bird_cluster_spawn", origin )

	return birdCluster
}

void function OnEnterBirdTrigger( entity trigger, entity player )
{
	if ( trigger.GetOwner() != player )
		return

	BirdCluster birdCluster = GetBirdClusterFromTrigger( trigger )

	if ( birdCluster.triggered )
		return

	foreach( index, pointEnt in birdCluster.pointArray )
		pointEnt.Destroy()

	birdCluster.pointArray.clear()
	birdCluster.triggered = true

	HeatMapStat( player, "bird_cluster_triggered", trigger.GetOrigin() )

	// Note: the cluster will be deleted when it times out or if the owner get far enough away.
	// Keeping the triggered cluster around stops new clusters from spawning where one was just triggered.
}

void function BirdScareThread( entity player, entity bird, int order )
{
	bird.EndSignal( "OnDestroy" )

	float delay = RandomFloatRange( 0, CLUSTER_MAX_TAKEOFF_DELAY * order )
	//printt( order, delay, CLUSTER_MAX_TAKEOFF_DELAY * order )
	wait delay

	entity mover = CreateScriptMover( bird.GetOrigin(), bird.GetAngles() )
	mover.EndSignal( "OnDestroy" )

	OnThreadEnd(
		function() : ( bird, mover )
		{
			//printt( "endon" )
			if ( IsValid( bird ) )
				bird.Destroy()

			if ( IsValid( mover ) )
				mover.Destroy()
		}
	)

	float duration = bird.GetSequenceDuration( "Bird_react_fly_small" )
	Assert( duration > 2, "fly away anim must be more then 2 seconds long" )

	bird.SetParent( mover, "ref", false, 0.0 )
	thread PlayAnim( bird, "Bird_react_fly_small", mover, "ref" )

	wait ( duration - 2 )
	bird.Dissolve( ENTITY_DISSOLVE_BIRD, <0,0,0>, 200 )

	WaitForever() // this will end when the dissolve is done.
}


array<Point> function GetRandomPerchPositions( vector origin, int count, entity player )
{
	const MAX_SURFACE_ANGLE = 20

	vector ornull clampedOrigin = NavMesh_ClampPointForHullWithExtents( origin, HULL_MEDIUM, <256,256,32> )
	if ( clampedOrigin == null )
		return []
	expect vector( clampedOrigin )

	array<vector> originArray = NavMesh_RandomPositions( clampedOrigin, HULL_MEDIUM, count, CLUSTER_SPAWN_MIN_RADIUS, CLUSTER_SPAWN_MAX_RADIUS )
	array<Point> perchArray

	foreach( perchOrigin in originArray )
	{
		Point perch

		PerfStart( PerfIndexServer.BirdCluster_perch_trace )
		TraceResults result = TraceLineHighDetail( perchOrigin + <0,0,72>, perchOrigin + <0,0,-32>, null, TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_NONE )
		PerfEnd( PerfIndexServer.BirdCluster_perch_trace )

		if ( result.surfaceName == "water" )
			continue

		// no point spawning birds on grass, you won't be able to see them anyway
		if ( result.surfaceName == "grass" )
			continue

		if ( !IsValid( result.hitEnt ) || result.hitEnt.HasPusherAncestor() )
			continue

		perch.origin = result.endPos

		PerfStart( PerfIndexServer.BirdCluster_perch_angle )
		perch.angles = GetFlightAngles( result.endPos, player )
		PerfEnd( PerfIndexServer.BirdCluster_perch_angle )

		{
			// this is special stuff to make them look good on slanted surfaces. Can it be done in a different way?
			// it sort of breaks the flight angles based on the aimation fitting

			float dot = DotProduct( <0,0,1>, result.surfaceNormal )
			if ( dot != 0 && DotToAngle( dot ) > MAX_SURFACE_ANGLE )
			{
				vector forward = FlattenVector( result.surfaceNormal )
				vector right = CrossProduct( result.surfaceNormal, forward )
				perch.angles = CoinFlip() ? VectorToAngles( right ) : VectorToAngles( right * -1 )
				perch.angles = ClampAngles( perch.angles + <0, RandomFloatRange( -25, 25 ), 0 > )

				//DebugDrawLine( result.endPos, result.endPos + result.surfaceNormal * 64, 0, 0, 255, true, 5 )
				//DebugDrawLine( result.endPos, result.endPos + right * 64, 0, 255, 0, true, 5 )
				//DebugDrawLine( result.endPos, result.endPos + AnglesToForward( perch.angles ) * 72, 255, 128, 128, true, 5 )
			}

		}


		Assert( perch.angles.y < 360 )
		perchArray.append( perch )
	}

	return perchArray
}

vector function GetFlightAngles( vector perchPosition, entity player )
{
	const TRACE_COUNT = 6
	const ANGLE_STEP = 360 / TRACE_COUNT
	const TRACE_DIST = 128
	const TRACE_RAISE = 64

	vector startAngles = <0,RandomFloatRange( -180, 180 ),0>
	vector forward = AnglesToForward( startAngles )
	int bestTrace = 0
	float bestFrac = -1

	perchPosition += <0,0,8>

	for( int trace = 0; trace < TRACE_COUNT; trace++ )
	{
		vector traceOrigin = perchPosition + forward * TRACE_DIST + <0,0,TRACE_RAISE>
		float frac = TraceLineSimple( perchPosition, traceOrigin, null )
		TraceResults result = TraceLine( perchPosition, traceOrigin, null, TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_NONE )
		frac = result.fraction

		#if R5DEV
			if ( CLUSTER_DEBUG_CLUSTER && player == GP() )
			{
				DebugDrawText( traceOrigin, string( trace ), false, 3 )
				DebugDrawLine( perchPosition, result.endPos, 0,255,0, true, 3 )
				DebugDrawLine( result.endPos, traceOrigin, 255,0,0, true, 3 )
			}
		#endif //DEV

		if ( frac == 1 )
		{
			return ClampAngles( startAngles + <0, ANGLE_STEP * trace, 0> )
		}
		else if ( frac > bestFrac )
		{
			bestTrace = trace
			bestFrac = frac
		}

		forward = VectorRotate(forward, <0,ANGLE_STEP,0> )
	}

	return ClampAngles( startAngles + <0, (ANGLE_STEP * bestTrace), 0> )
}

bool function IsNearPlayerCluster( entity player, vector clusterOrigin, float nearDistSqr )
{
	foreach( birdCluster in file.birdClusterArray )
	{
		// gotta check this logic out
		if ( !birdCluster.blocker && ( birdCluster.owner != player && player != null ) )
			continue

		//		if ( birdCluster.owner == null || ( birdCluster.owner != player && player != null ) )
		//			continue


		if ( DistanceSqr( clusterOrigin, birdCluster.origin ) < nearDistSqr )
			return true
	}

	return false
}

BirdCluster function GetBirdClusterFromTrigger( entity trigger )
{
	foreach( birdCluster in file.birdClusterArray )
	{
		if ( birdCluster.trigger == trigger )
			return birdCluster
	}

	unreachable
}

void function RemoveExpiredBirdClusters()
{
	foreach( birdCluster in clone file.birdClusterArray )
	{
		if ( ShouldRemoveBirdCluster( birdCluster ) )
			RemoveBirdCluster( birdCluster )
	}
}

bool function ShouldRemoveBirdCluster( BirdCluster birdCluster )
{
	bool expired
	if ( birdCluster.spawnTime + CLUSTER_LIFETIME < Time() )
		expired = true

	if ( birdCluster.blocker )
		return expired

	if ( !IsValid( birdCluster.owner ) || !IsValid( birdCluster.trigger ) )
		return true

	float distSqr = DistanceSqr( birdCluster.owner.GetOrigin(), birdCluster.trigger.GetOrigin()  )
	int deleteDist = expired ? CLUSTER_MIN_DIST_SQR : CLUSTER_MAX_DIST_SQR
	if ( distSqr > deleteDist )
		return true

	return false
}

void function RemoveBirdCluster( BirdCluster birdCluster )
{
	if ( birdCluster.blocker == false )
	{
		birdCluster.trigger.Destroy()

		if ( !birdCluster.triggered )
		{
			foreach( point in birdCluster.pointArray )
				point.Destroy()
		}
	}

	file.birdClusterArray.fastremovebyvalue( birdCluster )
}


int function GetNumberOfBirdClusters()
{
	return file.birdClusterArray.len()
}

int function GetNumberOfBirdClustersForPlayer( entity player )
{
	int count = 0
	foreach( birdCluster in file.birdClusterArray )
	{
		if ( birdCluster.owner == player && !birdCluster.triggered )
			count++
	}

	return count
}

int function GetNumberOfBirdClustersBirds()
{
	int count = 0
	foreach( birdCluster in file.birdClusterArray )
	{
		count += birdCluster.pointArray.len()
	}

	return count
}
#endif //SERVER

#if R5DEV && SERVER
void function DEV_CreateBirdCluster( entity owner = null )
{
	entity viewPlayer = GP()
	owner = IsValid( owner ) ? owner : GP()
	vector traceOrigin = viewPlayer.EyePosition() + viewPlayer.GetViewVector() * 5000

	BirdCluster ornull birdCluster = CreateBirdCluster( owner, TraceLine( viewPlayer.EyePosition(), traceOrigin , null, TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_NONE ).endPos, 5 )
	if ( birdCluster == null )
	{
		Warning( "Failed to create a bird cluster" )
		return
	}

	expect BirdCluster( birdCluster )

	file.birdClusterArray.append( birdCluster )

}

void function ClusterDebug()
{
	if ( !CLUSTER_DEBUG_CLUSTER )
		return

	FlagWait( "GamePlaying" )
	//printt( "ClusterDebug" )

	GP().EndSignal( "OnDestroy" )

	while( true )
	{
		// get more or less all clusters in the map
		array<WaypointClusterInfo> waypointClusterArray = GetServerWaypointClusters( <0,0,0>, 50000, 1, TEAM_UNASSIGNED )
		#if R5DEV
		if ( CLUSTER_USE_FAKE )
			waypointClusterArray = file.fakeClusters
		#endif

		foreach( cluster in waypointClusterArray )
		{
			bool nearCluster = IsNearPlayerCluster( null, cluster.clusterPos, CLUSTER_NEAR_DIST_SQR )
			if ( nearCluster )
			{
				DebugDrawCircle( cluster.clusterPos, <180,0,0>, 64, 255, 0, 0, true, 0.1 )
			}
			else
			{
				DebugDrawCircle( cluster.clusterPos, <180,0,0>, 64, 128, 0, 255, true, 0.1 )
			}
			DebugDrawText( cluster.clusterPos + <0,0,-4>, format( "c:%i\nd:%i", cluster.numPointsNear, Distance(GP().GetOrigin(),cluster.clusterPos) ), false, 0.1 )
		}

		foreach( birdCluster in file.birdClusterArray )
		{
			if ( birdCluster.owner == null )
			{
				DebugDrawCircle( birdCluster.origin, <180,0,0>, CLUSTER_SPAWN_MAX_RADIUS, 255, 0, 0, true, 0.1 )
				continue
			}

			if ( birdCluster.owner != GP() )
			{
				float dist = Distance( birdCluster.owner.GetOrigin(), birdCluster.origin )
				DebugDrawText( birdCluster.origin + <0,0,16>, format( "%.2f\n%s", Time() - birdCluster.spawnTime, birdCluster.owner.GetPlayerName() ), false, 0.1 )
				if ( birdCluster.triggered )
					DebugDrawCircle( birdCluster.origin + <0,0,8>, <180,0,0>, CLUSTER_SPAWN_MAX_RADIUS, 64, 64, 192, true, 0.1 )
				else
					DebugDrawCircle( birdCluster.origin + <0,0,8>, <180,0,0>, CLUSTER_SPAWN_MAX_RADIUS, 64, 192, 64, true, 0.1 )
			}
			else
			{
				float dist = Distance( birdCluster.owner.GetOrigin(), birdCluster.origin )
				DebugDrawText( birdCluster.origin + <0,0,16>, format( "%.2f\n%i\n%s", Time() - birdCluster.spawnTime, dist, birdCluster.owner.GetPlayerName() ), false, 0.1 )
				if ( birdCluster.triggered )
					DebugDrawCircle( birdCluster.origin, <180,0,0>, CLUSTER_SPAWN_MAX_RADIUS, 0, 128, 255, true, 0.1 )
				else
					DebugDrawCircle( birdCluster.origin, <180,0,0>, CLUSTER_SPAWN_MAX_RADIUS, 128, 255, 0, true, 0.1 )
			}
		}

		WaitFrame()
	}
}

void function AddFakeCluster()
{
	vector forward = GP().GetViewVector()
	TraceResults results = TraceLine( GP().EyePosition(), GP().EyePosition() + forward * 3000, GP(), TRACE_MASK_BLOCKLOS, TRACE_COLLISION_GROUP_NONE )
	if  ( results.fraction == 1 )
		return

	WaypointClusterInfo cluster
	cluster.clusterPos = results.endPos
	cluster.numPointsNear = 5
	file.fakeClusters.append( cluster )
}
#endif //DEV && SERVER

#if CLIENT
void function BirdClusterPointSpawned( entity info_target )
{
	__BirdClusterPointSpawned( info_target )
}

void function __BirdClusterPointSpawned( entity info_target )
{
	entity owner = info_target.GetOwner()
	if ( !IsValid( owner ) )
		return

	const array<string> BIRD_ANIM_ARRAY = ["Bird_eating_idle","Bird_casual_idle","Bird_cleaning_idle" ]

	entity mainEnt
	entity ownerPlayer

	if( owner.IsPlayer() )
	{
		mainEnt = info_target
		ownerPlayer = owner
	}
	else
	{
		mainEnt = owner
		ownerPlayer = mainEnt.GetOwner()
		if ( !IsValid( ownerPlayer ) )
			return
	}

	if ( GetLocalViewPlayer() != ownerPlayer )
		return

	BirdClusterInfo clusterInfo
	clusterInfo = CreateOrReturnExistingBirdClusterInfo( mainEnt, ownerPlayer )
	//	clusterInfo.birdClusterPoints.append( info_target )

	entity bird = CreateClientSidePropDynamic( info_target.GetOrigin(), info_target.GetAngles(), CLUSTER_BIRD_MODEL )
	bird.SetFadeDistance( CLUSTER_MAX_DIST )

	int animIndex = clusterInfo.birdArray.len() % BIRD_ANIM_ARRAY.len()

	float duration = bird.GetSequenceDuration( BIRD_ANIM_ARRAY[ animIndex ] )
	float initialTime = RandomFloatRange( 0, duration )
	thread PlayAnim( bird, BIRD_ANIM_ARRAY[ animIndex ], null, null, 0.0, initialTime )

	//printt( "bird", bird )
	clusterInfo.birdArray.append( bird )
}

array<entity> function GetAllBrids()
{
	array<entity> birds
	foreach( cluster in file.birdClusterInfoArray )
		birds.extend( cluster.birdArray )

	return birds
}

BirdClusterInfo function CreateOrReturnExistingBirdClusterInfo( entity mainEnt, entity ownerPlayer )
{
	foreach( clusterInfo in file.birdClusterInfoArray )
	{
		if ( clusterInfo.birdClusterMainEnt == mainEnt )
			return clusterInfo
	}

	BirdClusterInfo newClusterInfo
	newClusterInfo.birdClusterMainEnt = mainEnt
	newClusterInfo.ownerPlayer = ownerPlayer

	file.birdClusterInfoArray.append( newClusterInfo )

	AddEntityDestroyedCallback( mainEnt, BirdClusterInfoOnDestroy )

	//printt( "New bird cluster", mainEnt )

	return newClusterInfo
}

void function BirdClusterInfoOnDestroy( entity info_target )
{
	__BirdClusterInfoOnDestroy( info_target )
}

void function __BirdClusterInfoOnDestroy( entity info_target )
{
	BirdClusterInfo clusterInfo
	foreach( _clusterInfo in file.birdClusterInfoArray )
	{
		if ( _clusterInfo.birdClusterMainEnt == info_target )
			clusterInfo = _clusterInfo
	}

	if ( !IsValid( clusterInfo.ownerPlayer ) )
	{
		DeleteBirdCluster( clusterInfo )
		return	// should delete all birds in the clusterInfo
	}

	Assert( clusterInfo.birdClusterMainEnt == info_target )
	Assert( clusterInfo.ownerPlayer == GetLocalViewPlayer() )

	float distSqr = DistanceSqr( info_target.GetOrigin(), clusterInfo.ownerPlayer.GetOrigin() )

	//printt( "Cluster Destroyed", info_target.GetOwner(), sqrt( distSqr ) )

	if ( distSqr > CLUSTER_MID_DIST_SQR )
	{
		// don't bother with fx and flight since birds are too far away
		DeleteBirdCluster( clusterInfo )
		return
	}

	foreach( index, bird in clusterInfo.birdArray )
		thread BirdFlightThread( bird, index )

	// entites will get cleaned up inside the flight thread
	file.birdClusterInfoArray.fastremovebyvalue( clusterInfo )
}

void function BirdFlightThread( entity bird, int order )
{
	bird.EndSignal( "OnDestroy" )

	float delay = RandomFloatRange( 0, CLUSTER_MAX_TAKEOFF_DELAY * order )
	//printt( order, delay, CLUSTER_MAX_TAKEOFF_DELAY * order )
	wait delay

	float duration = bird.GetSequenceDuration( "Bird_react_fly_small" )
	Assert( duration > 2, "fly away anim must be more then 2 seconds long" )

	//printt( "Bird takeoff" )

	entity refEnt = CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", bird.GetOrigin(), bird.GetAngles() )
	bird.SetParent( refEnt )

	OnThreadEnd(
		function() : ( bird, refEnt )
		{
			if ( IsValid( refEnt ) )
				refEnt.Destroy()

			if ( IsValid( bird ) )
				bird.Destroy()
		}
	)


	thread PlayAnim( bird, "Bird_react_fly_small", refEnt )
	wait duration - 2.0

	int fxId = GetParticleSystemIndex( CLUSTER_BIRD_DISSOLVE_VFX )
	int fxHandle = StartParticleEffectOnEntity( bird, fxId, FX_PATTACH_ABSORIGIN_FOLLOW, 0 )
	waitthread fadeModelAlphaOutOverTime( bird, 1 )

	wait 1

	//printt( "Bird flew" )
}


void function fadeModelAlphaOutOverTime( entity model, float duration )
{
	EndSignal( model, "OnDestroy" )

	float startTime = Time()
	float endTime = startTime + duration
	int startAlpha = 255
	int endAlpha = 0

	model.kv.rendermode = 4 //Rendmode TransAlpha

	while ( Time() <= endTime )
	{
		float alphaResult = GraphCapped( Time(), startTime, endTime, startAlpha, endAlpha )
		model.kv.renderamt = alphaResult
		printt ("Alpha = " + alphaResult)
		WaitFrame()
	}
}


void function DeleteBirdCluster( BirdClusterInfo clusterInfo )
{
	foreach( bird in clusterInfo.birdArray )
	{
		if ( IsValid( bird ) )
			bird.Destroy()
	}

	file.birdClusterInfoArray.fastremovebyvalue( clusterInfo )
}
#endif //CLIENT


