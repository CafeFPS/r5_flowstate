global function Canyonlands_MapInit_Common
global function CodeCallback_PlayerEnterUpdraftTrigger
global function CodeCallback_PlayerLeaveUpdraftTrigger

#if SERVER && R5DEV
	global function HoverTankTestPositions

#endif

#if SERVER
	global function HoverTank_DebugFlightPaths
	global function TestCreateTooManyLinks
	global function InitWaterLeviathans
	global function Canyonlands_UpdraftInit_Common

	const int MAX_HOVERTANKS = 2
	const string HOVERTANK_START_NODE_NAME		= "hovertank_start_node"
	const string HOVERTANK_END_NODE_NAME		= "hovertank_end_node"
	const bool DEBUG_HOVERTANK_NODE_SELECTION	= false

	const string SIGNAL_HOVERTANK_AT_ENDPOINT = "HovertankAtEndpoint"

	const asset NESSY_MODEL = $"mdl/domestic/nessy_doll.rmdl"

	const asset ROCK_MODEL_FOR_CANYONLANDS_GEOFIX = $"mdl/rocks/rock_white_chalk_modular_flat_02.rmdl"

	//const asset HOVERTANK_PATH_FX = $"P_wpn_arcball_beam"
	//const asset HOVERTANK_END_FX = $"P_ar_call_beacon_ring_hovertank"

	const float SKYBOX_Z_OFFSET_STAGING_AREA = 30.0
	const vector SKYBOX_ANGLES_STAGING_AREA = <0, 60, 0>

	const int HOVER_TANKS_DEFAULT_CIRCLE_INDEX = 1
	const int HOVER_TANKS_TYPE_INTRO = 0
	const int HOVER_TANKS_TYPE_MID = 1

	global enum eCanyonlandsMapUpdatePreviewPhases
	{
		MAP_UNCHANGED,
		LEVIATHANS_MOVE_CLOSER,
		LEVIATHANS_MOVE_MUCH_CLOSER,
		//FLYERS_APPEAR,
		REPULSOR_TOWER_TURNS_ON,
		CRYPTO_TEASE,
	}
#endif

const int HOVER_TANKS_DEFAULT_COUNT_INTRO = 1
const int HOVER_TANKS_DEFAULT_COUNT_MID = 1
global const asset LEVIATHAN_MODEL = $"mdl/creatures/leviathan/leviathan_kingscanyon_preview_animated.rmdl"
//const asset FLYER_SWARM_MODEL = $"mdl/Creatures/flyer/flyer_kingscanyon_animated.rmdl"
global const string CANYONLANDS_LEVIATHAN1_NAME = "leviathan1"
global const string CANYONLANDS_LEVIATHAN2_NAME= "leviathan2"

global const asset MU1_LEVIATHAN_MODEL = $"mdl/Creatures/leviathan/leviathan_kingscanyon_animated.rmdl"

struct
{
	#if SERVER
		array<HoverTank> hoverTanksIntro
		array<HoverTank> hoverTanksMid
		table<HoverTank, entity> hovertankEndpointMapObjects
		array<entity> hoverTankEndNodesIntro
		array<entity> hoverTankEndNodesMid
		vector skyboxStartingOrigin
		vector skyboxStartingAngles
	#endif
	int numHoverTanksIntro = 0
	int numHoverTanksMid = 0

	#if CLIENT
		entity clientSideLeviathan1
		entity clientSideLeviathan2
		float lastLevAnimCycleChosen = -1.0
	#endif

} file

void function Canyonlands_MapInit_Common()
{
	printt( "Canyonlands_MapInit_Common" )

	PrecacheModel( LEVIATHAN_MODEL )
	//PrecacheModel( FLYER_SWARM_MODEL )

	SetVictorySequencePlatformModel( $"mdl/rocks/victory_platform.rmdl", < 0, 0, -10 >, < 0, 0, 0 > )

	file.numHoverTanksIntro = GetCurrentPlaylistVarInt( "hovertanks_count_intro", HOVER_TANKS_DEFAULT_COUNT_INTRO )
	#if SERVER
		printt( "HOVER TANKS INTRO MAX:", file.numHoverTanksIntro )
	#endif
	float chance = GetCurrentPlaylistVarFloat( "hovertanks_chance_intro", 1.0 ) * 100.0
	if ( RandomInt(100) > chance )
		file.numHoverTanksIntro = 0
	#if SERVER
		printt( "HOVER TANKS INTRO ACTUAL:", file.numHoverTanksIntro, "(was " + chance + "% chance)" )
	#endif

	file.numHoverTanksMid = GetCurrentPlaylistVarInt( "hovertanks_count_mid", HOVER_TANKS_DEFAULT_COUNT_MID )
	#if SERVER
		printt( "HOVER TANKS MID MAX:", file.numHoverTanksMid )
	#endif
	chance = GetCurrentPlaylistVarFloat( "hovertanks_chance_mid", 0.33 ) * 100.0
	if ( RandomInt(100) > chance )
		file.numHoverTanksMid = 0
	#if SERVER
		printt( "HOVER TANKS MID ACTUAL:", file.numHoverTanksMid, "(was " + chance + "% chance)" )
	#endif

	SupplyShip_Init()

	#if SERVER
        InitWaterLeviathans()
		LootTicks_Init()

		FlagSet( "DisableDropships" )

		svGlobal.evacEnabled = false //Need to disable this on a map level if it doesn't support it at all

		RegisterSignal( "NessyDamaged" )
		RegisterSignal( SIGNAL_HOVERTANK_AT_ENDPOINT )
		RegisterSignal( "PathFinished" )

		PrecacheModel( NESSY_MODEL )

		//SURVIVAL_AddOverrideCircleLocation_Nitro( <24744, 24462, 3980>, 2048 )

		AddCallback_EntitiesDidLoad( EntitiesDidLoad )
		AddCallback_AINFileBuilt( HoverTank_DebugFlightPaths )

		AddCallback_GameStateEnter( eGameState.Playing, HoverTanksOnGamestatePlaying )
		AddCallback_OnSurvivalDeathFieldStageChanged( HoverTanksOnDeathFieldStageChanged )

		SURVIVAL_SetPlaneHeight( 24000 )
		SURVIVAL_SetAirburstHeight( 8000 )
		SURVIVAL_SetMapCenter( <0, 0, 0> )
        SURVIVAL_SetMapDelta( 4900 )

        AddSpawnCallbackEditorClass( "prop_dynamic", "script_survival_pvpcurrency_container", OnPvpCurrencyContainerSpawned )    
        AddSpawnCallbackEditorClass( "prop_dynamic", "script_survival_upgrade_station", OnSurvivalUpgradeStationSpawned )  
		if ( GetMapName() == "mp_rr_canyonlands_staging" )
		{
			// adjust skybox for staging area
			AddCallback_GameStateEnter( eGameState.WaitingForPlayers, StagingArea_MoveSkybox )
			AddCallback_GameStateEnter( eGameState.PickLoadout, StagingArea_ResetSkybox )
		}
	#endif

	#if CLIENT
		// Doing this automatically since someone has to call InitWaterLeviathans() just to make the markers
		AddTargetNameCreateCallback( CANYONLANDS_LEVIATHAN1_NAME, OnLeviathanMarkerCreated ) //Created from the server to mark where the leviathans should be on the client
		AddTargetNameCreateCallback( CANYONLANDS_LEVIATHAN2_NAME, OnLeviathanMarkerCreated )
		AddTargetNameCreateCallback( "LeviathanMarker", OnLeviathanMarkerCreated  )
		AddTargetNameCreateCallback( "LeviathanStagingMarker", OnLeviathanMarkerCreated )

		Freefall_SetPlaneHeight( 24000 )
		Freefall_SetDisplaySeaHeightForLevel( -956.0 )

		if ( file.numHoverTanksIntro > 0 || file.numHoverTanksMid > 0 )
			SetMapFeatureItem( 500, "#HOVER_TANK", "#HOVER_TANK_DESC", $"rui/hud/gametype_icons/survival/sur_hovertank_minimap" )

		if ( !IsPVEMode() )
			SetMapFeatureItem( 300, "#SUPPLY_DROP", "#SUPPLY_DROP_DESC", $"rui/hud/gametype_icons/survival/supply_drop" )

		if ( GetMapName() == "mp_rr_canyonlands_mu1_night" )// TODO(AMOS): desertlands_nx
		{
			SetVictorySequenceLocation( <10472, 30000, 8500>, <0, 60, 0> )
			SetVictorySequenceSunSkyIntensity( 0.8, 0.0 )
		}
		else
		{
			SetVictorySequenceLocation( <11926.5957, -17612.0508, 11025.5176>, <0, 248.69014, 0> )
			SetVictorySequenceSunSkyIntensity( 1.3, 4.0 )
		}

		SetMinimapBackgroundTileImage( $"overviews/mp_rr_canyonlands_bg" )

		RegisterMinimapPackage( "prop_script", eMinimapObject_prop_script.HOVERTANK, MINIMAP_OBJECT_RUI, MinimapPackage_HoverTank, FULLMAP_OBJECT_RUI, MinimapPackage_HoverTank )
		RegisterMinimapPackage( "prop_script", eMinimapObject_prop_script.HOVERTANK_DESTINATION, MINIMAP_OBJECT_RUI, MinimapPackage_HoverTankDestination, FULLMAP_OBJECT_RUI, MinimapPackage_HoverTankDestination )
	#endif
}

#if SERVER
void function OnPvpCurrencyContainerSpawned(entity ent)
{	
    if( GameRules_GetGameMode() != FREELANCE )
	{
        if(IsValid(ent))
            ent.Destroy()
    }
}

void function OnSurvivalUpgradeStationSpawned(entity ent)
{
    if( GameRules_GetGameMode() != FREELANCE )
	{
        if(IsValid(ent))
            ent.Destroy()
    }
}
void function InitWaterLeviathans()
{
	AddSpawnCallback_ScriptName( CANYONLANDS_LEVIATHAN1_NAME, CreateClientSideLeviathanMarkers )
	AddSpawnCallback_ScriptName( CANYONLANDS_LEVIATHAN2_NAME, CreateClientSideLeviathanMarkers)
	AddSpawnCallback_ScriptName( "leviathan_staging", CreateClientSideLeviathanMarkers)
}

void function EntitiesDidLoad()
{

	thread __EntitiesDidLoad()
}

void function __EntitiesDidLoad()
{
		if(GetMapName() != "mp_rr_canyonlands_staging"){
	SpawnEditorProps()
	}
		if( GameRules_GetGameMode() != FREELANCE )
	{
		waitthread FindHoverTankEndNodes()
		SpawnHoverTanks()
		if ( GetCurrentPlaylistVarInt( "enable_nessies", 1 ) == 1 )
			Nessies()
	}
}

void function Canyonlands_UpdraftInit_Common( entity player )
{
	//ApplyUpdraftModUntilTouchingGround( player )
	//thread PlayerSkydiveFromCurrentPosition( player )
}

void function CreateClientSideLeviathanMarkers( entity leviathan )
{
	leviathan.EndSignal( "OnDestroy" )

	vector leviathanOrigin = leviathan.GetOrigin()
	vector leviathanAngles = leviathan.GetAngles()

	if (  leviathan.GetScriptName() != "leviathan_staging" )
	{
		bool isLeviathan1 = leviathan.GetScriptName() == CANYONLANDS_LEVIATHAN1_NAME
		int previewPhase = GetCurrentPlaylistVarInt( "mu_preview_phase", eCanyonlandsMapUpdatePreviewPhases.MAP_UNCHANGED )
		switch ( previewPhase )
		{
			case eCanyonlandsMapUpdatePreviewPhases.LEVIATHANS_MOVE_CLOSER:
				leviathanOrigin = isLeviathan1 ? < 2599.376709, -48505.000000 , -1600 > : leviathanOrigin
				leviathanAngles = isLeviathan1 ? < 2.346743, 154.202164, 0 > : leviathanAngles
				break

			case eCanyonlandsMapUpdatePreviewPhases.LEVIATHANS_MOVE_MUCH_CLOSER:
				leviathanOrigin = isLeviathan1 ? < -44615.867188, -22612.208984, -1600 > : < 30792.123047, -45749.824219, -2784 >
				leviathanAngles = isLeviathan1 ? < 0, 70, 0 > : < 0, 117, 0 >
				break

			//case eCanyonlandsMapUpdatePreviewPhases.FLYERS_APPEAR:
			//	leviathanOrigin = isLeviathan1 ? < -46599.632813, 561.130737, -1600 > : < 30792.123047, -45749.824219, -2784 >
			//	leviathanAngles = isLeviathan1 ? < 0, 22, 0 > : < 0, 117, 0 >
			//	break

			case eCanyonlandsMapUpdatePreviewPhases.REPULSOR_TOWER_TURNS_ON:
				leviathanOrigin = isLeviathan1 ? < -46599.632813, 561.130737, -1600 > : < 30792.123047, -45749.824219, -2784 >
				leviathanAngles = isLeviathan1 ? < 3.686208, 169.509933, 0.000000 > : < 6.670253, -146.874985, 0.000000 >
				break

			case eCanyonlandsMapUpdatePreviewPhases.CRYPTO_TEASE:
				leviathanOrigin = isLeviathan1 ? < -46599.632813, 561.130737, -1600 > : < 30792.123047, -45749.824219, -2784 >
				leviathanAngles = isLeviathan1 ? < 3.686208, 169.509933, 0.000000 > : < 6.670253, -146.874985, 0.000000 >
				break


			case eCanyonlandsMapUpdatePreviewPhases.MAP_UNCHANGED:
			default:
				break
		}
	}

	entity ent = CreatePropDynamic_NoDispatchSpawn( $"mdl/dev/empty_model.rmdl", leviathanOrigin, leviathanAngles )
	SetTargetName( ent, leviathan.GetScriptName() )
	DispatchSpawn( ent )

	leviathan.Destroy()

	ent.EndSignal( "OnDestroy" )

	wait 3.0

	ent.Destroy()
}

void function FindHoverTankEndNodes()
{
	//FlagWait( "DeathFieldCalculationComplete" )

	file.hoverTankEndNodesMid = GetHoverTankEndNodes( file.numHoverTanksMid, HOVER_TANKS_TYPE_MID, [] )
	file.hoverTankEndNodesIntro = GetHoverTankEndNodes( file.numHoverTanksIntro, HOVER_TANKS_TYPE_INTRO, file.hoverTankEndNodesMid )

	printt( "HOVER TANK MID NODES:", file.hoverTankEndNodesMid.len() )
	printt( "HOVER TANK INTRO NODES:", file.hoverTankEndNodesIntro.len() )

	file.numHoverTanksIntro = int( min( file.numHoverTanksIntro, file.hoverTankEndNodesIntro.len() ) )
	file.numHoverTanksMid = int( min( file.numHoverTanksMid, file.hoverTankEndNodesMid.len() ) )

	HideUnusedHovertankSpecificGeo()
}

void function SpawnHoverTanks()
{
	// Spawn hover tanks at level load, even though they don't fly in yet, so they exist when loot is spawned.
	if ( file.numHoverTanksIntro == 0 && file.numHoverTanksMid == 0 )
		return

	if ( GetEntArrayByScriptName( "_hover_tank_mover" ).len() == 0 )
		return

	int numHoverTankSpawnersInMap = GetEntArrayByScriptName( "_hover_tank_mover" ).len()
	Assert( numHoverTankSpawnersInMap >= file.numHoverTanksIntro + file.numHoverTanksMid, "Playlist is trying to spawn too many hover tanks than the map can support. hovertanks_count_intro + hovertanks_count_mid must be <= " + numHoverTankSpawnersInMap )

	array<string> spawners = [ "HoverTank_1", "HoverTank_2" ]
	spawners.resize( file.numHoverTanksIntro + file.numHoverTanksMid )

	foreach( int i, string spawnerName in spawners )
	{
		HoverTank hoverTank = SpawnHoverTank_Cheap( spawnerName )
		hoverTank.playerRiding = true

		if ( i + 1 <= file.numHoverTanksIntro )
		{
			printt( "HOVER TANKS INTRO SPAWNER:", spawnerName )
			file.hoverTanksIntro.append( hoverTank )

		}
		else
		{
			printt( "HOVER TANKS MID SPAWNER:", spawnerName )
			file.hoverTanksMid.append( hoverTank )
		}
	}
}

void function HoverTanksOnGamestatePlaying()
{
	if ( file.numHoverTanksIntro == 0 )
		return

	thread HoverTanksOnGamestatePlaying_Thread()
}

void function HoverTanksOnGamestatePlaying_Thread()
{
	FlagWait( "Survival_LootSpawned" )

	if ( GetCurrentPlaylistVarInt( "canyonlands_hovertank_flyin", 1 ) == 1 )
	{
		// Fly to final nodes
		FlyHoverTanksIntoPosition( file.hoverTanksIntro, HOVER_TANKS_TYPE_INTRO )
	}
	else
	{
		// Teleport to final nodes
		TeleportHoverTanksIntoPosition( file.hoverTanksIntro, HOVER_TANKS_TYPE_INTRO )
	}
}

void function HoverTanksOnDeathFieldStageChanged( int stage, float nextCircleStartTime )
{
	if ( file.numHoverTanksMid == 0 )
		return

	if ( stage == GetCurrentPlaylistVarInt( "canyonlands_hovertanks_circle_index", HOVER_TANKS_DEFAULT_CIRCLE_INDEX ) )
	{
		thread FlyHoverTanksIntoPosition( file.hoverTanksMid, HOVER_TANKS_TYPE_MID )
		wait 7.0
		AddSurvivalCommentaryEvent( eSurvivalEventType.HOVER_TANK_INBOUND )
	}
}

void function FlyHoverTanksIntoPosition( array<HoverTank> hoverTanks, int hoverTanksType )
{
	// Get start nodes and end nodes. Playlist vars change how these are selected.
	array<entity> startNodes
	array<entity> endNodes
	if ( hoverTanksType == HOVER_TANKS_TYPE_INTRO )
	{
		Assert( file.hoverTankEndNodesIntro.len() == hoverTanks.len(), "Not enough hover tank end locations found!" )
		startNodes = GetHoverTankStartNodes( file.hoverTankEndNodesIntro )
		endNodes = file.hoverTankEndNodesIntro
	}
	else if ( hoverTanksType == HOVER_TANKS_TYPE_MID )
	{
		Assert( file.hoverTankEndNodesMid.len() == hoverTanks.len(), "Not enough hover tank end locations found!" )
		startNodes = GetHoverTankStartNodes( file.hoverTankEndNodesMid )
		endNodes = file.hoverTankEndNodesMid
	}
	else
	{
		Assert( 0 )
	}

	Assert( startNodes.len() == hoverTanks.len(), "Not enough hover tank start locations found!" )

	if ( endNodes.len() == 0 )
		return

	foreach( int i, HoverTank hoverTank in hoverTanks )
	{
		CreateHoverTankMinimapIconForPlayers( hoverTank )

		entity tempNode = CreateEntity("info_target")
		tempNode.SetOrigin( <25568.2, 6651.55, 4966.23> )
		array<entity> nodeChain = [ //GetEntityChainOfType( endNodes[ i ] )
			tempNode

		]
		HoverTankTeleportToPosition( hoverTank, startNodes[i].GetOrigin(), startNodes[i].GetAngles() )
		//thread HoverTankDrawPathFX( hoverTank, nodeChain[ 0 ] )

		thread HoverTankAdjustSpeed( hoverTank )
		thread HoverTankForceBoost( hoverTank )

		thread HoverTankFlyNodeChain( hoverTank, nodeChain )
		thread HideMinimapEndpointsWhenHoverTankFinishesFlyin( hoverTank )
		CreateHoverTankEndpointIconForPlayers( nodeChain.top(), hoverTank )
	}
}

void function HoverTankAdjustSpeed( HoverTank hoverTank )
{
	EndSignal( hoverTank, "OnDestroy" )

	float startSlowTime = Time() + 10.0
	float decelEndTime = startSlowTime + 20.0
	float startSpeed = 1200.0
	float endSpeed = 300.0

	HoverTankSetCustomFlySpeed( hoverTank, startSpeed )

	while ( Time() < decelEndTime )
	{

		float speed = GraphCapped( Time(), startSlowTime, decelEndTime, startSpeed, endSpeed )
		HoverTankSetCustomFlySpeed( hoverTank, speed )
		WaitFrame()
	}

	HoverTankSetCustomFlySpeed( hoverTank, endSpeed )
}

void function HoverTankForceBoost( HoverTank hoverTank )
{
	EndSignal( hoverTank, "OnDestroy" )
	EndSignal( hoverTank, "PathFinished" )

	while ( 1 )
	{
		HoverTankEngineBoost( hoverTank )
		wait RandomFloatRange( 1.0 , 5.0 )
	}
}

void function TeleportHoverTanksIntoPosition( array<HoverTank> hoverTanks, int hoverTanksType )
{
	array<entity> endNodes
	if ( hoverTanksType == HOVER_TANKS_TYPE_INTRO )
		endNodes = file.hoverTankEndNodesIntro
	else if ( hoverTanksType == HOVER_TANKS_TYPE_MID )
		endNodes = file.hoverTankEndNodesMid
	Assert( endNodes.len() == MAX_HOVERTANKS, "Not enough hover tank end locations found!" )

	foreach( int i, HoverTank hoverTank in hoverTanks )
	{
		entity teleportNode = GetLastLinkedEntOfType( endNodes[i] )
		HoverTankTeleportToPosition( hoverTank, teleportNode.GetOrigin(), teleportNode.GetAngles() )
		FireHoverTankZiplines( hoverTank, teleportNode )
	}
}

void function HideUnusedHovertankSpecificGeo()
{
	//todo:
	return

	array<entity> hoverTankSpecificGeo
	array<entity> unusedEndNodes = GetAllHoverTankEndNodes()

	foreach( entity node in file.hoverTankEndNodesIntro )
		unusedEndNodes.fastremovebyvalue( node )

	foreach( entity node in file.hoverTankEndNodesMid )
		unusedEndNodes.fastremovebyvalue( node )

	foreach( entity node in unusedEndNodes )
	{
		entity lastNode = GetLastLinkedEntOfType( node )
		array<entity> endNodeLinkedEnts = lastNode.GetLinkEntArray() // [SERVER] Given object is not an entity (type = null)
		foreach( linkedEnt in endNodeLinkedEnts )
		{
			if ( linkedEnt.GetClassName() == "func_brush_lightweight" )
				linkedEnt.Destroy()
		}
	}
}

void function CreateHoverTankMinimapIconForPlayers( HoverTank hoverTank )
{
	vector hoverTankOrigin = hoverTank.interiorModel.GetOrigin()
	entity minimapObj = CreatePropScript( $"mdl/dev/empty_model.rmdl", hoverTankOrigin )
	minimapObj.Minimap_SetCustomState( eMinimapObject_prop_script.HOVERTANK )		// Minimap icon
	minimapObj.SetParent( hoverTank.interiorModel )
	minimapObj.SetLocalAngles( < 0, 0, 0 > )
	minimapObj.Minimap_SetZOrder( MINIMAP_Z_OBJECT + 10 ) // +10 to make it show up above the endpoint marker below
	SetTeam( minimapObj, TEAM_UNASSIGNED )
	SetTargetName( minimapObj, "hovertank" )		// Full map icon

	SetMinimapObjectVisibleToPlayers( minimapObj, true )
}

void function CreateHoverTankEndpointIconForPlayers( entity endpoint, HoverTank hoverTank )
{
	vector hoverTankOrigin = endpoint.GetOrigin()
	entity minimapObj = CreatePropScript( $"mdl/dev/empty_model.rmdl", hoverTankOrigin )
	minimapObj.Minimap_SetCustomState( eMinimapObject_prop_script.HOVERTANK_DESTINATION )		// Minimap icon
	minimapObj.Minimap_SetZOrder( MINIMAP_Z_OBJECT + 5 ) // +5 to make it show up above respawn beacons etc
	SetTeam( minimapObj, TEAM_UNASSIGNED )
	SetTargetName( minimapObj, "hovertankDestination" )		// Full map icon
	file.hovertankEndpointMapObjects[ hoverTank ] <- minimapObj

	SetMinimapObjectVisibleToPlayers( minimapObj, true )

	//foreach( entity player in GetPlayerArray_Alive() )
	//	Remote_CallFunction_NonReplay( player, "ServerCallback_SUR_PingMinimap", endpoint.GetOrigin(), 30.0, 500.0, 50.0, 2 )
}

void function HideHoverTankEndpointIconForPlayers( HoverTank hoverTank )
{
	if ( hoverTank in file.hovertankEndpointMapObjects )
	{
		entity endpoint = delete file.hovertankEndpointMapObjects[ hoverTank ]
		SetMinimapObjectVisibleToPlayers( endpoint, false )
	}
}

void function HideMinimapEndpointsWhenHoverTankFinishesFlyin( HoverTank hoverTank )
{
	EndSignal( hoverTank, "OnDestroy" )

	WaitSignal( hoverTank, SIGNAL_HOVERTANK_AT_ENDPOINT )

	HideHoverTankEndpointIconForPlayers( hoverTank )
}

void function SetMinimapObjectVisibleToPlayers( entity minimapObj, bool visible )
{
	foreach ( player in GetPlayerArray() )
	{
		if( visible )
			minimapObj.Minimap_AlwaysShow( 0, player )
		else
			minimapObj.Minimap_Hide( 0, player )
	}
}

const int ZIP_ATTACH_RIGHT_IDX 		= 0
const int ZIP_ATTACH_LEFT_IDX 		= 1
const int ZIP_ATTACH_BACK_IDX 		= 2

const int NUM_ZIP_ATTACHMENTS		= 3
const float ZIPLINE_ATTACH_FOV		= 0.707
void function FireHoverTankZiplines( HoverTank hoverTank, entity endNode )
{
	if ( IsValid( hoverTank.flightMover ) )
	{
		hoverTank.flightMover.AllowZiplines()
	}

	array<entity> endNodeZiplineTargets = endNode.GetLinkEntArray()
	array<vector> endNodeZiplineTargetOrigins
	int numZiplineTargets
	foreach( targetEnt in endNodeZiplineTargets )
	{
		if ( targetEnt.GetClassName() != "info_target" )
			continue

		endNodeZiplineTargetOrigins.append( targetEnt.GetOrigin() )
		numZiplineTargets++
	}

	array<vector> hoverTankZiplineAttachOrigins
	entity extModel = hoverTank.flightMover
	int ziplineRAttach 	= extModel.LookupAttachment( "ZIPLINE_R" )
	int ziplineLAttach 	= extModel.LookupAttachment( "ZIPLINE_L" )
	int ziplineBAttach 	= extModel.LookupAttachment( "ZIPLINE_B" )
	hoverTankZiplineAttachOrigins.append( extModel.GetAttachmentOrigin( ziplineRAttach ) )
	hoverTankZiplineAttachOrigins.append( extModel.GetAttachmentOrigin( ziplineLAttach ) )
	hoverTankZiplineAttachOrigins.append( extModel.GetAttachmentOrigin( ziplineBAttach ) )

	array< array< vector > > zipAttachPairCandidates

	for( int i; i < NUM_ZIP_ATTACHMENTS; i++ )
	{
		zipAttachPairCandidates.append( [] )
		vector attachDir = GetZiplineAttachDirectionFromIndex( i, extModel )
		for( int j; j < numZiplineTargets; j++ )
		{
			vector attachOrigin = hoverTankZiplineAttachOrigins[ i ]
			vector hoverTankToPoint = Normalize( FlattenVector( endNodeZiplineTargetOrigins[ j ] - attachOrigin ) )
			float dot2D             = DotProduct( hoverTankToPoint, attachDir )
			if ( dot2D > ZIPLINE_ATTACH_FOV )
			{
				vector ziplineEndOrigin = endNodeZiplineTargetOrigins[ j ]
				zipAttachPairCandidates[ i ].append( ziplineEndOrigin )
				array<entity> ziplineEnts = CreateHovertankZipline( attachOrigin, ziplineEndOrigin )
				//thread HovertankZiplineLaunchSequence( ziplineEnts, attachOrigin, ziplineEndOrigin )
			}
		}
	}
}

vector function GetZiplineAttachDirectionFromIndex( int idx, entity model )
{
	switch( idx )
	{
		case ZIP_ATTACH_RIGHT_IDX:
			return model.GetRightVector() * -1
		case ZIP_ATTACH_LEFT_IDX:
			return model.GetRightVector()
		case ZIP_ATTACH_BACK_IDX:
			return model.GetForwardVector() * -1
	}

	unreachable
}

void function HovertankZiplineLaunchSequence( array<entity> ziplineEnts, vector startPos, vector endPos )
{
	printt( "Hovertank zipline launch sequence!" )
	float time
	while ( time < 10 )
	{
		DebugDrawSphere( ziplineEnts[ 1 ].GetOrigin(), 64, 255, 0, 0, true, 0.2 )
		time += 0.1
		wait 0.1
	}
	entity mover = CreateScriptMover( startPos )
	ziplineEnts[ 1 ].SetParent( mover )

	mover.NonPhysicsMoveTo( endPos, 0.5, 0, 0 )
	while ( time < 10.5 )
	{
		DebugDrawSphere( mover.GetOrigin(), 16, 255, 0, 255, true, 0.2 )
		DebugDrawSphere( ziplineEnts[ 1 ].GetOrigin(), 64, 255, 0, 0, true, 0.2 )
		time += 0.1
		wait 0.1
	}
	DebugDrawSphere( mover.GetOrigin(), 16, 255, 0, 255, true, 20 )
	DebugDrawSphere( ziplineEnts[ 1 ].GetOrigin(), 64, 255, 0, 0, true, 20 )
	mover.Destroy()
	ziplineEnts[ 0 ].Zipline_Enable()
}

array<entity> function CreateHovertankZipline( vector startPos, vector endPos )
{
	entity zipline_start = CreateEntity( "zipline" )
	zipline_start.kv.Material = "cable/zipline.vmt"
	zipline_start.kv.ZiplineAutoDetachDistance = "160"
	zipline_start.kv._zipline_rest_point_0 = startPos.x + " " + startPos.y + " " + startPos.z
	zipline_start.kv._zipline_rest_point_1 = endPos.x + " " + endPos.y + " " + endPos.z
	zipline_start.SetOrigin( startPos )

	entity zipline_end = CreateEntity( "zipline_end" )
	zipline_end.kv.ZiplineAutoDetachDistance = "160"
	zipline_end.SetOrigin( endPos )
	// Comment in if using zipline sequence
	//zipline_end.SetOrigin( startPos )

	zipline_start.LinkToEnt( zipline_end )

	DispatchSpawn( zipline_start )
	DispatchSpawn( zipline_end )

	// Comment in if using zipline sequence
	//zipline_start.Zipline_Disable()

	array<entity> ziplineEnts = [ zipline_start, zipline_end ]
	return ziplineEnts
}

array<entity> function GetHoverTankStartNodes( array<entity> endNodes )
{
	if ( endNodes.len() == 1 )
	{
		array<entity> startNodes = GetEntArrayByScriptName( HOVERTANK_START_NODE_NAME )
		Assert( startNodes.len() >= 1 )
		startNodes.resize(1)
		return startNodes
	}

	const vector DEV_APPROX_Z_OFFSET = < 0, 0, 8000 >
	const float NODE_TO_TARGET_DIR_DOT_TOLERANCE = cos( PI / 4 ) 			// Start nodes to be considered for selection must be within 45 degrees of target dir

	Assert( endNodes.len() == 2, "Hover tank start location chooser only works with 2 hover tanks!" )
	array<entity> startNodes = GetEntArrayByScriptName( HOVERTANK_START_NODE_NAME )
	Assert( startNodes.len() >= 2 )

	array<vector> endNodeOrigins = [ endNodes[ 0 ].GetOrigin(), endNodes[ 1 ].GetOrigin() ]
	array<vector> endNodeOrigins2D
	foreach( origin in endNodeOrigins )
	{
		vector origin2D = origin
		origin2D.z = 0
		endNodeOrigins2D.append( origin2D )
	}

	vector endNodeBToA = endNodeOrigins2D[ 1 ] - endNodeOrigins2D[ 0 ]
	vector endNodesMiddlePoint = endNodeOrigins2D[ 0 ] + ( endNodeBToA * 0.5 )
	vector dirBToA = Normalize( endNodeBToA )
	vector orthoBToA = CrossProduct( dirBToA, < 0, 0, 1 > )

	array< array< table > > startNodesSplitByEndNodes
	for( int i; i < endNodes.len(); i++ ) // Crashes if declared as [ [], [] ]
	{
		startNodesSplitByEndNodes.append( [] )
	}

	// Split nodes into two halves, separated by the line between end nodes. Save dot product values for later.
	foreach( node in startNodes)
	{
		vector nodeOrigin2D = node.GetOrigin()
		nodeOrigin2D.z = 0

		vector nodeToMidpointDir = Normalize( endNodesMiddlePoint - nodeOrigin2D )
		float mapHalfDot = DotProduct( nodeToMidpointDir, orthoBToA )
		if ( mapHalfDot < 0 )
			startNodesSplitByEndNodes[ 1 ].append( { ent = node, dot = mapHalfDot } )		// Negative half
		else
			startNodesSplitByEndNodes[ 0 ].append( { ent = node, dot = mapHalfDot } )		// Positive half
	}

	// Pick a random half of the map to fly in from (using splits above). If not enough nodes in given half, use other half.
	int startNodeSplitToUse = RandomIntRangeInclusive( 0, 1 )

	if ( GetBugReproNum() == 31493 )
		startNodeSplitToUse = 0

	if ( startNodesSplitByEndNodes[ startNodeSplitToUse ].len() < 2 )
		startNodeSplitToUse = 1 - startNodeSplitToUse

	// Find the two start nodes closest to the vector orthogonal to vector connecting end nodes, stemming from the midpoint between both nodes.
	entity closestNode
	entity secondClosestNode
	float smallestDot = -1
	float secondSmallestDot = -1

	foreach( nodeData in startNodesSplitByEndNodes[ startNodeSplitToUse ] )
	{
		if ( DEBUG_HOVERTANK_NODE_SELECTION )
			DebugDrawCircle( expect entity(nodeData.ent).GetOrigin(), < 0, 0, 0 >, 1300.0, 0, 255, 0, true, 10 )

		float nodeDot = expect float( nodeData.dot )
		nodeDot = fabs( nodeDot )	// Since using a split half of the nodes, no issues if abs value this
		entity nodeEnt = expect entity( nodeData.ent )

		if ( (smallestDot < 0) || (nodeDot > smallestDot) )
		{
			secondSmallestDot = smallestDot
			secondClosestNode = closestNode
			smallestDot = nodeDot
			closestNode = nodeEnt
		}
		else if ( (secondSmallestDot < 0) || (nodeDot > secondSmallestDot) )
		{
			secondSmallestDot = nodeDot
			secondClosestNode = nodeEnt
		}
	}

	// Order the chosen start nodes to match end nodes. Make sure start node is paired with correct end node. If paths intersect, flip start -> node assignment
	array< entity > retArray		= [ secondClosestNode, closestNode ]
	bool intersect           = Do2DLinesIntersect( retArray[ 0 ].GetOrigin(), endNodes[ 0 ].GetOrigin(), retArray[ 1 ].GetOrigin(), endNodes[ 1 ].GetOrigin() )
	if ( intersect )
		retArray.reverse()

	if ( DEBUG_HOVERTANK_NODE_SELECTION )
	{
		DebugDrawCircle( closestNode.GetOrigin() + < 0, 0, 64 >, < 0, 0, 0 >, 1300.0, 255, 0, 255, true, 10 )
		DebugDrawCircle( secondClosestNode.GetOrigin() + < 0, 0, 64 >, < 0, 0, 0 >, 1300.0, 255, 0, 255, true, 10 )
		DebugDrawCircle( endNodeOrigins2D[ 0 ] + DEV_APPROX_Z_OFFSET, < 0, 0, 0 >, 1300.0, 0, 255, 255, true, 10 )
		DebugDrawCircle( endNodeOrigins2D[ 1 ] + DEV_APPROX_Z_OFFSET, < 0, 0, 0 >, 1300.0, 0, 255, 255, true, 10 )

		DebugDrawLine( endNodeOrigins2D[ 0 ] + DEV_APPROX_Z_OFFSET, endNodeOrigins2D[ 1 ] + DEV_APPROX_Z_OFFSET, 255, 255, 0, true, 10 )
		DebugDrawLine( endNodesMiddlePoint + (orthoBToA * 96000) + DEV_APPROX_Z_OFFSET, endNodesMiddlePoint + (orthoBToA * -96000) + DEV_APPROX_Z_OFFSET, 255, 120, 0, true, 10 )

		DebugDrawLine( retArray[ 0 ].GetOrigin(), endNodes[ 0 ].GetOrigin(), 255, 0, 0, true, 10 )
		DebugDrawLine( retArray[ 1 ].GetOrigin(), endNodes[ 1 ].GetOrigin(), 255, 0, 0, true, 10 )
		DebugDrawLine( closestNode.GetOrigin(), endNodesMiddlePoint + DEV_APPROX_Z_OFFSET, 255, 0, 0, true, 10 )
		DebugDrawLine( secondClosestNode.GetOrigin(), endNodesMiddlePoint + DEV_APPROX_Z_OFFSET, 255, 255, 0, true, 10 )

		DebugDrawSphere( endNodesMiddlePoint + DEV_APPROX_Z_OFFSET, 32, 255, 0, 255, true, 10 )
		DebugDrawSphere( endNodeOrigins2D[ 0 ] + DEV_APPROX_Z_OFFSET, 32, 255, 0, 255, true, 10 )
		DebugDrawSphere( endNodeOrigins2D[ 1 ] + DEV_APPROX_Z_OFFSET, 32, 125, 125, 255, true, 10 )
	}

	return retArray
}


array<entity> function GetHoverTankEndNodes( int count, int endNodeType, array<entity> excludeNodes )
{
	Assert( endNodeType == HOVER_TANKS_TYPE_INTRO || endNodeType == HOVER_TANKS_TYPE_MID )
	array<entity> potentialEndNodes = GetAllHoverTankEndNodes()

	// Remove exclude nodes
	foreach( entity node in excludeNodes )
		potentialEndNodes.fastremovebyvalue( node )

	if ( GetCurrentPlaylistVarInt( "canyonlands_dynamic_hovertank_locations", 1 ) != 1 )
	{
		// Don't use random locations, only use original end locations
		for ( int i = potentialEndNodes.len() - 1; i >= 0; i-- )
		{
			if ( !potentialEndNodes[i].HasKey( "original_tank_location" ) || (int( expect string( potentialEndNodes[i].kv.original_tank_location ) ) != 1) )
				potentialEndNodes.remove( i )
		}
	}
	potentialEndNodes.randomize()

	// Don't allow hover tank positions that will be within one of the final circles because they are OP positions for end game
	array<entity> nodesNotInFinalCircles
	DeathFieldStageData deathFieldStageDataSmall = GetDeathFieldStage( GetCurrentPlaylistVarInt( "canyonlands_hovertanks_circle_index", HOVER_TANKS_DEFAULT_CIRCLE_INDEX ) + 1 )
	float invalidRadius = deathFieldStageDataSmall.endRadius + HOVER_TANK_RADIUS
	for ( int i = potentialEndNodes.len() - 1; i >= 0; i-- )
	{
		if ( Distance2D( deathFieldStageDataSmall.endPos, potentialEndNodes[i].GetOrigin() ) <= invalidRadius )
			potentialEndNodes.remove( i )
	}

	if ( endNodeType == HOVER_TANKS_TYPE_MID )
	{
		// Exclude end nodes that are outside the current safe circle
		DeathFieldStageData deathFieldStageDataLarge = GetDeathFieldStage( GetCurrentPlaylistVarInt( "canyonlands_hovertanks_circle_index", HOVER_TANKS_DEFAULT_CIRCLE_INDEX ) )
		for ( int i = potentialEndNodes.len() - 1; i >= 0; i-- )
		{
			if ( Distance2D( deathFieldStageDataLarge.endPos, potentialEndNodes[i].GetOrigin() ) >= deathFieldStageDataLarge.endRadius )
				potentialEndNodes.remove( i )
		}
	}

	if ( potentialEndNodes.len() > 1 )
		potentialEndNodes.randomize()

	// Pick randomly from what we have left
	array<entity> endNodesToUse
	foreach( entity node in potentialEndNodes )
	{
		if ( endNodesToUse.len() >= count )
			break
		endNodesToUse.append( node )
	}
	return endNodesToUse
}

void function HoverTankFlyNodeChain( HoverTank hoverTank, array<entity> nodes )
{
	EndSignal( hoverTank, "OnDestroy" )
	EndSignal( hoverTank.flightMover, "OnDestroy" )

	int numNodes = nodes.len()
	for ( int i = 0; i < numNodes; i++ )
	{
		waitthread HoverTankFlyToNode( hoverTank, nodes[ i ] )
	}

	Signal( hoverTank, SIGNAL_HOVERTANK_AT_ENDPOINT )

	FireHoverTankZiplines( hoverTank, nodes.top() )
}

array<entity> function GetAllHoverTankEndNodes()
{
	return GetEntArrayByScriptName( HOVERTANK_END_NODE_NAME )
}

void function HoverTank_DebugFlightPaths()
{
	thread HoverTank_DebugFlightPaths_Thread()
}

void function HoverTank_DebugFlightPaths_Thread()
{
	printt( "++++--------------------------------------------------------------------------------------------------------------------------++++" )
	printt( ">>>>>>>>>>>>>>>>>>>>>>>>>>>>> DEBUGGING HOVERTANK FLIGHT PATH PERMUTATIONS ON CANYONLANDS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<" )
	printt( "++++--------------------------------------------------------------------------------------------------------------------------++++" )

	array<entity> endNodes = GetAllHoverTankEndNodes()
	array<entity> startNodes = GetEntArrayByScriptName( HOVERTANK_START_NODE_NAME )
	int numEndNodes = endNodes.len()
	int numStartNodes = startNodes.len()
	int numChecksPerFrame = 10
	int numChecksDone = 0

	for( int i = 0; i < numStartNodes; i++ )
	{
		entity currentStartNode = startNodes[ i ]

		for( int j = 0; j < numEndNodes; j++ )
		{
			entity currentEndNode = endNodes[ j ]
			if ( !HoverTankCanFlyPath( currentStartNode.GetOrigin(), currentEndNode ) )
			{
				Warning( "HoverTank can't fly from " + currentStartNode.GetOrigin() + " to " + currentEndNode.GetOrigin() + " because the path is broken" )
				DebugDrawLine( currentStartNode.GetOrigin(), currentEndNode.GetOrigin(), 255, 0, 0, true, 20.0 )
			}
			numChecksDone++
			if ( numChecksDone >= numChecksPerFrame )
			{
				numChecksDone = 0
				WaitFrame()
			}
		}
	}
	printt( "++++--------------------------------------------------------------------------------------------------------------------------++++" )
	printt( "++++--------------------------------------------------------------------------------------------------------------------------++++" )
}

#if SERVER && R5DEV
void function HoverTankTestPositions()
{
	entity player = GetPlayerArray()[0]

	HoverTank hoverTank = SpawnHoverTank_Cheap( "HoverTank_1" )
	hoverTank.playerRiding = true
	//file.hoverTanksMid.append( hoverTank )

	array<entity> endNodes = GetAllHoverTankEndNodes()

	foreach( entity node in endNodes )
	{
		//DebugDrawSphere( node.GetOrigin(), 1024, 255, 0, 0, true, 9999.0 )
		entity teleportNode = GetLastLinkedEntOfType( node )
		HoverTankTeleportToPosition( hoverTank, teleportNode.GetOrigin(), teleportNode.GetAngles() )
		FireHoverTankZiplines( hoverTank, teleportNode )

		player.SetOrigin( teleportNode.GetOrigin() + < 0, 0, 1024 > )
		player.SetAngles( teleportNode.GetAngles() )

		while( player.IsInputCommandHeld( IN_SPEED ) || player.IsInputCommandHeld( IN_ZOOM ) )
			WaitFrame()

		while( !player.IsInputCommandHeld( IN_SPEED ) || !player.IsInputCommandHeld( IN_ZOOM ) )
			WaitFrame()
	}
}
#endif

void function TestCreateTooManyLinks()
{
	wait 1
	entity fromEntity = GetEntByIndex( 1 );
	if ( IsValid( fromEntity ) )
	{
		for ( int i = 0; i < 100; ++i )
		{
			for ( int j = 0; j < 100; ++j )
			{
				int index = (i * 100) + j + 1
				entity toEntity = GetEntByIndex( index )
				if ( IsValid( toEntity ) )
				{
					if ( !fromEntity.IsLinkedToEnt( toEntity ) )
					{
						printt( "Linking " + fromEntity + " to " + toEntity )
						fromEntity.LinkToEnt( toEntity )
					}
				}
			}
			wait 0
		}
	}
}

void function StagingArea_MoveSkybox()
{
	thread StagingArea_MoveSkybox_Thread()
}


void function StagingArea_MoveSkybox_Thread()
{
	FlagWait( "EntitiesDidLoad" )

	entity skyboxCamera = GetEnt( "skybox_cam_level" )

	file.skyboxStartingOrigin = skyboxCamera.GetOrigin()
	file.skyboxStartingAngles = skyboxCamera.GetAngles()
	skyboxCamera.SetOrigin( skyboxCamera.GetOrigin() + <0, 0, SKYBOX_Z_OFFSET_STAGING_AREA> )

	skyboxCamera.SetAngles( SKYBOX_ANGLES_STAGING_AREA )
}


void function StagingArea_ResetSkybox()
{
	thread StagingArea_ResetSkybox_Thread()
}


void function StagingArea_ResetSkybox_Thread()
{
	FlagWait( "EntitiesDidLoad" )

	entity skyboxCamera = GetEnt( "skybox_cam_level" )

	skyboxCamera.SetOrigin( file.skyboxStartingOrigin )
	skyboxCamera.SetAngles( file.skyboxStartingAngles )
}

void function Nessies()
{
	entity skyboxCam = GetEnt( "skybox_cam_level" )
	if ( !IsValid( skyboxCam ) )
		return

	array<entity> nessies
	int i = 1
	while( true )
	{
		array<entity> ents = GetEntArrayByScriptName( "nessy" + i )
		if ( ents.len() != 1 )
			break
		entity nessy = ents.pop()
		nessy.Hide()
		nessy.NotSolid()
		nessies.append( nessy )
		i++
	}

	if ( nessies.len() == 0 )
		return

	int nessiesRequired = GetCurrentPlaylistVarInt( "nessies_required", nessies.len() )

	foreach( entity nessy in nessies )
	{
		nessy.Show()
		nessy.Solid()
		AddEntityCallback_OnDamaged( nessy, NessyDamageCallback )

		WaitSignal( nessy, "NessyDamaged" )
		nessy.Destroy()

		nessiesRequired--
		if ( nessiesRequired <= 0 )
			break

		foreach( entity player in GetPlayerArray() )
			Remote_CallFunction_NonReplay( player, "ServerCallback_NessyMessage", 0 )
	}

	foreach( entity player in GetPlayerArray() )
		Remote_CallFunction_NonReplay( player, "ServerCallback_NessyMessage", 1 )

	entity nessy = CreateScriptMoverModel( NESSY_MODEL, skyboxCam.GetOrigin() + <90,10,-20>, <0,90,0> )
	nessy.NonPhysicsMoveTo( skyboxCam.GetOrigin() + <60,10,-4>, 30.0, 4.0, 4.0 )
	nessy.NonPhysicsRotateTo( <0,110,0>, 15, 5, 5 )
	wait 15.0
	nessy.NonPhysicsRotateTo( <0,90,0>, 20, 5, 5 )
	wait 20.0
	nessy.NonPhysicsMoveTo( skyboxCam.GetOrigin() + <60,10,-20>, 20.0, 4.0, 4.0 )
	nessy.NonPhysicsRotateTo( <0,-90,0>, 20, 8, 8 )
	wait 20.0
	nessy.Destroy()
}

void function NessyDamageCallback( entity ent, var damageInfo )
{
	entity attacker = DamageInfo_GetAttacker( damageInfo )
	if ( IsValid( attacker ) && attacker.IsPlayer() )
	{
		Signal( ent, "NessyDamaged" )
		PlayerDamageFeedback( ent, damageInfo, 0 )
	}
}
#endif

#if CLIENT


void function OnLeviathanMarkerCreated( entity marker )
{
	string markerTargetName = marker.GetTargetName()
	printt( "OnLeviathanMarkerCreated, targetName: " + markerTargetName  )
	#if R5DEV
		if ( IsValid( file.clientSideLeviathan1 ) && markerTargetName == CANYONLANDS_LEVIATHAN1_NAME )
		{
			printt( "Destroying clientSideLeviathan1 with markerName: " + markerTargetName  )
			file.clientSideLeviathan1.Destroy()
		}

		if ( IsValid( file.clientSideLeviathan2 ) && markerTargetName == CANYONLANDS_LEVIATHAN2_NAME )
		{
			printt( "Destroying clientSideLeviathan2 with markerName: " +  markerTargetName )
			file.clientSideLeviathan2.Destroy()
		}

	#endif

	entity leviathan = CreateClientSidePropDynamic( marker.GetOrigin(), marker.GetAngles(), LEVIATHAN_MODEL )

	if ( markerTargetName == CANYONLANDS_LEVIATHAN1_NAME )
		file.clientSideLeviathan1 = leviathan
	else if ( markerTargetName == CANYONLANDS_LEVIATHAN2_NAME )
		file.clientSideLeviathan2 = leviathan

	bool stagingOnly = markerTargetName == "leviathan_staging"
	if ( stagingOnly  )
		SetAnimateInStaticShadow( leviathan, true )
	else
		SetAnimateInStaticShadow( leviathan, true )

	thread LeviathanThink( marker, leviathan, stagingOnly )
}



void function LeviathanThink( entity marker, entity leviathan, bool stagingOnly )
{
	marker.EndSignal( "OnDestroy" )
	leviathan.EndSignal( "OnDestroy" )

	OnThreadEnd(
		function () : ( leviathan )
		{
			if ( IsValid( leviathan ) )
			{
				leviathan.Destroy()
			}
		}
	)

	leviathan.Anim_Play( "ACT_IDLE"  )

	int count = 0
	int liftCount = RandomIntRange( 3, 10 )

	// Prevent rare bug where leviathan anims sync up
	const float CYCLE_BUFFER_DIST = 0.3
	Assert( CYCLE_BUFFER_DIST < 0.5, "Warning! Impossible to get second leviathan random animation cycle if cycle buffer distance is 0.5 or greater!" )

	float randCycle
	if ( file.lastLevAnimCycleChosen < 0 )
		randCycle = RandomFloat( 1.0 )
	else
	{
		// Get the range that remains when the full buffer range is subtracted, then roll within that range.
		// Add that roll to the buffer top end (last chosen val + buffer), use modulo to clamp within 0 - 1
		float randomRoll = RandomFloat( 1.0 - ( CYCLE_BUFFER_DIST * 2 ) )
		float adjustedRandCycle = ( file.lastLevAnimCycleChosen + CYCLE_BUFFER_DIST + randomRoll ) % 1.0
		randCycle = adjustedRandCycle
	}

	file.lastLevAnimCycleChosen = randCycle

	leviathan.SetCycle( randCycle )
	WaitForever()

	while ( 1 )
	{
		if ( stagingOnly && GetGameState() >= eGameState.Playing )
			return

		if ( count < liftCount )
		{
			if ( CoinFlip() )
				waitthread PlayAnim( leviathan, "lev_idle_lookup_noloop_kingscanyon_preview" )
			else
				waitthread PlayAnim( leviathan, "lev_idle_noloop_kingscanyon_preview_0" )
			count++
		}
		else
		{
			waitthread PlayAnim( leviathan, "lev_idle_lookup_noloop_kingscanyon_preview" )
			count = 0
			liftCount = RandomIntRange( 3, 10 )
		}
	}

}

array<entity> function GetClientSideLeviathans()
{
	return [ file.clientSideLeviathan1, file.clientSideLeviathan2  ]
}

entity function GetClientSideLeviathan1()
{
	return file.clientSideLeviathan1

}

entity function GetClientSideLeviathan2()
{
	return file.clientSideLeviathan2

}
#endif

void function CodeCallback_PlayerEnterUpdraftTrigger( entity trigger, entity player )
{
	//float entZ = player.GetOrigin().z
	//OnEnterUpdraftTrigger( trigger, player, entZ + 100 )
}


void function CodeCallback_PlayerLeaveUpdraftTrigger( entity trigger, entity player )
{
//	OnLeaveUpdraftTrigger( trigger, player )
}
#if CLIENT

void function MinimapPackage_HoverTank( entity ent, var rui )
{
	#if DEV
		printt( "Adding 'rui/hud/gametype_icons/survival/sur_hovertank_minimap' icon to minimap" )
	#endif
	RuiSetImage( rui, "defaultIcon", $"rui/hud/gametype_icons/survival/sur_hovertank_minimap" )
	RuiSetImage( rui, "clampedDefaultIcon", $"" )
	RuiSetBool( rui, "useTeamColor", false )
}


void function MinimapPackage_HoverTankDestination( entity ent, var rui )
{
	#if DEV
		printt( "Adding 'rui/hud/gametype_icons/survival/sur_hovertank_minimap_destination' icon to minimap" )
	#endif
	RuiSetImage( rui, "defaultIcon", $"rui/hud/gametype_icons/survival/sur_hovertank_minimap_destination" )
	RuiSetImage( rui, "clampedDefaultIcon", $"" )
	RuiSetBool( rui, "useTeamColor", false )
}
#endif

#if SERVER
entity function CreateEditorPropKCLobby(asset a, vector pos, vector ang, bool mantle = false, float fade = 2000, int realm = -1)
{
	vector newpos = pos + <0,0,12000>
    entity e = CreatePropDynamic(a,newpos,ang,SOLID_VPHYSICS,fade)
    e.kv.fadedist = fade
    if(mantle) e.AllowMantle()

    if (realm > -1) {
        e.RemoveFromAllRealms()
        e.AddToRealm(realm)
    }

    string positionSerialized = newpos.x.tostring() + "," + newpos.y.tostring() + "," + newpos.z.tostring()
    string anglesSerialized = ang.x.tostring() + "," + ang.y.tostring() + "," + ang.z.tostring()

    e.SetScriptName("editor_placed_prop")
    e.e.gameModeId = realm
    printl("[editor]" + string(a) + ";" + positionSerialized + ";" + anglesSerialized + ";" + realm)

    return e
}

void function SpawnEditorProps()
{
    // Written by mostly fireproof. Let me know if there are any issues!
    printl("---- NEW EDITOR DATA ----")
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19392,1472,6208>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19392,1728,6208>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19136,1472,6208>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19136,1728,6208>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19392.2,1343.06,6207.72>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19136.1,1343.04,6207.72>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19648,1472,6208>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19648,1728,6208>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19904,1728,6208>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19904,1472,6208>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19904,1984,6208>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19904,2240,6208>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19648,2240,6208>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19392,2240,6208>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19136,1984,6208>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19392,1984,6208>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19648,1984,6208>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19904,2496,6208>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19904,2752,6208>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19648,2752,6208>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19648,2496,6208>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19392,2496,6208>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19136,2496,6208>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19392,2752,6208>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19136,2752,6208>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-20160,2240,6208>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-20160,1984,6208>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-20416,1984,6208>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-20416,2240,6208>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-20031.1,1727.99,6207.54>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-20031.1,1471.99,6207.57>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19904,1344.94,6207.67>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19648,1344.95,6207.68>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-20033,2496.07,6207.78>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-20033,2752.03,6207.79>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19904.4,2880.72,6207.42>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19648,2880.8,6207.4>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19392,2880.8,6207.39>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19136,2880.8,6207.4>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-20031,1727.86,6463.97>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-20031,1983.95,6464>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-20031,2239.98,6464>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-20031,2495.98,6464>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-20031,2751.98,6464>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-20031,1471.98,6464>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19904,1345,6464>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19648,1345,6464.01>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19392,1345,6464.01>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19136,1345,6464>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19008.7,1472,6207.33>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19008.7,1728,6207.33>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19008.7,2496.01,6207.33>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19008.7,2752.05,6207.34>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19009,2752.23,6464.06>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19009,2496.03,6464.07>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19009,2240.03,6464.07>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19009,1984.03,6464.07>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19009,1728.03,6464.04>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19009,1472.03,6464.04>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19136,2879,6464.02>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19392,2879,6464.02>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19648,2879,6464.02>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19904,2879,6464.02>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19136,1472,6464>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19392,1472,6464>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19648,1472,6464>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19904,1472,6464>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19904,1728,6464>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19904,1984,6464>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19904,2240,6464>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19904,2496,6464>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19904,2752,6464>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19648,2752,6464>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19392,2752,6464>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19136,2752,6464>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19136,1728,6464>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19136,1984,6464>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19136,2240,6464>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19136,2496,6464>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/ola/sewer_railing_01_corner_out.rmdl", <-20544.1,1855.03,6207.75>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/ola/sewer_railing_01_128.rmdl", <-20415.3,1855.38,6207.75>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/ola/sewer_railing_01_128.rmdl", <-20287.1,1855.6,6207.72>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/ola/sewer_railing_01_128.rmdl", <-20159.1,1855.73,6207.78>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/ola/sewer_railing_01_128.rmdl", <-20160.8,2368.17,6207.37>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/ola/sewer_railing_01_128.rmdl", <-20288.8,2368.2,6207.5>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/ola/sewer_railing_01_128.rmdl", <-20416.9,2368.12,6207.61>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/ola/sewer_railing_01_corner_in.rmdl", <-20544.1,2368.33,6207.06>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/ola/sewer_railing_01_corner_in.rmdl", <-19263.3,2624.63,6463.58>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/ola/sewer_railing_01_corner_in.rmdl", <-19263.5,1599.32,6463.49>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/ola/sewer_railing_01_corner_in.rmdl", <-19776.9,1599.7,6463.76>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/ola/sewer_railing_01_corner_in.rmdl", <-19776.4,2624.9,6463.91>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/ola/sewer_railing_01_128.rmdl", <-19647.2,2624.61,6463.81>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/ola/sewer_railing_01_128.rmdl", <-19519.2,2624.59,6463.86>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/ola/sewer_railing_01_128.rmdl", <-19391.2,2624.65,6463.95>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/ola/sewer_railing_01_128.rmdl", <-19263.3,2495.27,6464.01>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/ola/sewer_railing_01_128.rmdl", <-19263.4,2367.18,6464.01>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/ola/sewer_railing_01_128.rmdl", <-19263.4,2239.21,6464.03>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/ola/sewer_railing_01_128.rmdl", <-19263.3,2111.24,6464.04>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/ola/sewer_railing_01_128.rmdl", <-19263.3,1983.26,6464.03>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/ola/sewer_railing_01_128.rmdl", <-19263.3,1855.28,6464.03>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/ola/sewer_railing_01_128.rmdl", <-19263.3,1727.28,6464.03>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/ola/sewer_railing_01_128.rmdl", <-19392.7,1599.34,6464>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/ola/sewer_railing_01_128.rmdl", <-19520.7,1599.31,6464.01>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/ola/sewer_railing_01_128.rmdl", <-19648.8,1599.35,6464.01>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/ola/sewer_railing_01_128.rmdl", <-19776.7,1728.73,6463.91>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/ola/sewer_railing_01_128.rmdl", <-19776.5,1856.84,6463.96>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/ola/sewer_railing_01_128.rmdl", <-19776.6,1984.8,6463.98>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/ola/sewer_railing_01_128.rmdl", <-19776.7,2112.71,6464>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/ola/sewer_railing_01_128.rmdl", <-19776.7,2240.71,6464>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/ola/sewer_railing_01_128.rmdl", <-19776.7,2368.75,6464.01>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/ola/sewer_railing_01_128.rmdl", <-19776.7,2496.72,6464.03>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-18880,2240,6208>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-18880,1984,6208>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-18880,1728,6208>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-18624,1728,6208>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-18624,1984,6208>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-18624,2240,6208>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-18624,2496,6208>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-18880,2496,6208>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-18368,2496,6208>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-18368,2240,6208>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-18368,1984,6208>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-18368,1728,6208>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/containers/box_shrinkwrapped.rmdl", <-19071.2,1411.41,6223.84>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/containers/box_shrinkwrapped.rmdl", <-19159.4,1399.24,6223.82>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/containers/box_shrinkwrapped.rmdl", <-19064.1,1515.01,6223.9>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/containers/box_shrinkwrapped.rmdl", <-19135.8,1387.19,6299.45>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/containers/box_shrinkwrapped.rmdl", <-19063.2,1479.79,6299.39>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/containers/box_shrinkwrapped.rmdl", <-19163.4,1487.26,6223.69>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/signs/signage_plates_metal/sign_plate_a.rmdl", <-20024.7,2391.26,6332.05>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/signs/signage_plates_metal/sign_plate_a.rmdl", <-20024.6,1831.21,6331.85>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/utilities/power_gen1.rmdl", <-18940.5,2568.71,6223.51>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/utilities/wire_ground_coils_03.rmdl", <-18964.8,2472.43,6223.58>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/utilities/wires_ground_coils_01.rmdl", <-18912.6,2416.07,6223.21>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/utilities/wires_ground_coils_01.rmdl", <-18852,2528.88,6223.53>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/utilities/wire_ground_coils_03.rmdl", <-18908.5,2472.55,6223.35>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/utilities/wall_Waterpipe.rmdl", <-19000.6,2399.29,6259.72>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/IMC_base/generator_IMC_01.rmdl", <-18952.5,1656.7,6223.5>, <0,180,0>, true, 8000, -1 )

    CreateEditorPropKCLobby( $"mdl/vehicle/goblin_dropship/goblin_dropship.rmdl", <-18604,2115.18,6223.43>, <0,0,0>, true, 8000, -1 )
    
	CreateEditorPropKCLobby( $"mdl/vehicles_r5/land/msc_forklift_imc_v2/veh_land_msc_forklift_imc_v2_static.rmdl", <-18668,2536.64,6223.23>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19136,1472,6720>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19136,1728,6720>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19136,1984,6720>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19136,2240,6720>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19136,2496,6720>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19136,2752,6720>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19392,2752,6720>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19648,2752,6720>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19904,2752,6720>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19904,2496,6720>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19904,2240,6720>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19904,1984,6720>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19904,1728,6720>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19904,1472,6720>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19648,1472,6720>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19392,1472,6720>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19648,1728,6720>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19648,1984,6720>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19648,2240,6720>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19648,2496,6720>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19392,2240,6720>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19392,2496,6720>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19392,1984,6720>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19392,1728,6720>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19136,2240,6208>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/beacon/construction_scaff_128_64_64.rmdl", <-18435.6,2552.81,6223.55>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/beacon/construction_plastic_mat_white_01.rmdl", <-19376.8,1947.43,6227.73>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/beacon/construction_plastic_mat_black_01.rmdl", <-19685,2271.89,6223.86>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/beacon/construction_plastic_mat_black_01.rmdl", <-18560.2,2556.98,6224.04>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/beacon/construction_plastic_mat_black_01.rmdl", <-18644.1,2525,6223.97>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/canyonlands/canyonlands_zone_sign_03b.rmdl", <-20032.2,2240.89,6719.59>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/industrial/security_fence_post.rmdl", <-19967.9,1408.71,6719.31>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/industrial/security_fence_post.rmdl", <-19027.8,1360.8,6735.44>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/industrial/UTG_spire.rmdl", <-19040.6,2851.51,6735.38>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropKCLobby( $"mdl/industrial/UTG_spire.rmdl", <-19984.6,2843.49,6735.42>, <0,-90,0>, true, 8000, -1 )
}
#endif
