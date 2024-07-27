global function Olympus_MapInit_Common

#if SERVER
global function Olympus_SetRiftParams
#endif

const float RIFT_INNER_RADIUS = 850.0
const float RIFT_OUTER_RADIUS = 1200.0
const float RIFT_REDUCE_SPEED_INNER = 250.0
const float RIFT_REDUCE_SPEED_OUTER = 500.0
const float RIFT_PULL_SPEED = 1500.0
const float RIFT_SWIRL_ACCEL = 1200.0
const float RIFT_TRIGGER_BOX_SIZE = 350.0

global struct OlympusRiftParams
{
	float innerRadius = RIFT_INNER_RADIUS
	float outerRadius = RIFT_OUTER_RADIUS
	float reduceSpeedInner = RIFT_REDUCE_SPEED_INNER
	float reduceSpeedOuter = RIFT_REDUCE_SPEED_OUTER
	float pullSpeed = RIFT_PULL_SPEED
	float swirlAccel = RIFT_SWIRL_ACCEL
	float triggerBoxSize = RIFT_TRIGGER_BOX_SIZE
}

const string LIFELINETT_PLAYLIST_ENABLE_MEDKIT_SPAWNS = "lifeline_tt_medkit_spawns"
const string LIFELINETT_LOOT_KEYWORD = "lifeline_tt_loot"

struct
{
	table< entity, int > riftHandles
	OlympusRiftParams &riftParams
} file

void function Olympus_MapInit_Common()
{
	printf( "%s()", FUNC_NAME() )

	#if CLIENT
		Freefall_SetPlaneHeight( 12500 )
		Freefall_SetDisplaySeaHeightForLevel( -11500 )
	#endif

	#if SERVER
		InitVehicleARBarriers()

		if ( GetCurrentPlaylistVarBool( "olympus_rift_enabled", true ) )
		{
			AddSpawnCallback( "info_target", Rift_Init )
		}

		thread KillPlayersUnderMap_Thread( MAP_KILL_VOLUME_OFFSET_OLYMPUS ) //-28320       

		// if ( GetCurrentPlaylistVarInt( "deathfield_end_on_script_locations", 0 ) == 1 )
			AddCircleOverrideLocations()
	#endif

	#if SERVER && DEVELOPER
		AddCallback_EntitiesDidLoad( EntitiesDidLoad )
	#endif

	//#if CLIENT
	//	SetMinimapBackgroundTileImage( $"overviews/mp_rr_olympus_bg" )
	//#endif
}

#if SERVER && DEVELOPER
void function EntitiesDidLoad()
{

       
}
#endif


#if SERVER

void function InitVehicleARBarriers()
{
	AddSpawnCallback( "func_brush", void function ( entity brush )
	{
		//printf( "Vehicle AR Barriers - tn:'%s', ec:'%s'", brush.GetTargetName(), GetEditorClass( brush ) )
		if ( brush.GetScriptName() != "vehicle_fence_01" )
			return

		brush.NotSolid()
	} )
}

///// Olympus rift /////

void function Rift_Init( entity ent )
{
	if ( ent.GetTargetName() != "z4_antigrav" )
		return

	entity trigger = CreateEntity( "trigger_point_gravity" )
	trigger.SetOrigin( ent.GetOrigin() )
	trigger.SetAngles( ent.GetAngles() )
	trigger.SetParams( file.riftParams.innerRadius, file.riftParams.outerRadius, file.riftParams.reduceSpeedInner, file.riftParams.reduceSpeedOuter, file.riftParams.swirlAccel, file.riftParams.pullSpeed )
	trigger.SetEnterCallback( OnEntityEnterRiftTrigger )
	trigger.SetLeaveCallback( OnEntityLeaveRiftTrigger )
	trigger.kv.triggerFilterPlayer = "all"
	trigger.kv.triggerFilterPhaseShift = "any"

	DispatchSpawn( trigger )

	// trigger.SetHasConstantPullStregnth( true )
	// trigger.SetAndEnableTriggerSize( file.riftParams.triggerBoxSize )

	trigger.Enable()
}

void function OnEntityEnterRiftTrigger( entity trigger, entity ent )
{
	printf( "Rift: Entity entered" )

	// PreparePlayerForPositionReset here and in sh_warp_gates.gnut

	if ( IsValid( ent ) ) //&& ent.IsPlayerVehicle() && ent.VehicleGetType() == VEHICLE_FLYING_CAMERA )
		ent.TakeDamage( ent.GetMaxHealth(), svGlobal.worldspawn, svGlobal.worldspawn, { damageSourceId = eDamageSourceId.crushed, scriptType =  DF_BYPASS_SHIELD | DF_SKIPS_DOOMED_STATE }   )

	if ( IsValidPlayer( ent ) )
		GravityAirControl( ent )
}

void function OnEntityLeaveRiftTrigger( entity trigger, entity ent )
{
	printf( "Rift: Entity leaving" )

	if ( IsValidPlayer( ent ) )
		DisableGravityAirControl( ent )
}

void function GravityAirControl( entity player )
{
	// file.riftHandles[player] <- StatusEffect_AddEndless(player, eStatusEffect.in_olympus_rift, 1.0)
	player.kv.airSpeed = 500
	player.kv.airAcceleration = 10000
}

void function DisableGravityAirControl( entity player )
{
	// StatusEffect_Stop(player, file.riftHandles[player] )
	player.kv.airSpeed = player.GetPlayerSettingFloat( "airSpeed" )
	player.kv.airAcceleration = player.GetPlayerSettingFloat( "airAcceleration" )
}

void function Olympus_SetRiftParams( OlympusRiftParams params )
{
	file.riftParams = params
}            

void function AddCircleOverrideLocations()
{
	SURVIVAL_AddOverrideCircleLocation( <-18165, 30989, -6171>, 0, true )    // Docks
	SURVIVAL_AddOverrideCircleLocation( <-14786, 22705, -6672>, 0, true )    // Docks - Pathfinder
	SURVIVAL_AddOverrideCircleLocation( <-27500, 23265, -6504>, 0, true )    // Carrier
	SURVIVAL_AddOverrideCircleLocation( <-34216, 14719, -5528>, 0, true )    // Oasis
	SURVIVAL_AddOverrideCircleLocation( <-24134, 12428, -5760>, 0, true )    // East of Oasis
	SURVIVAL_AddOverrideCircleLocation( <-22569, 153, -5568>, 0, true )    // Estates
	SURVIVAL_AddOverrideCircleLocation( <-34150, -523, -4344>, 0, true )    // Marina-ish
	SURVIVAL_AddOverrideCircleLocation( <-33188, -16372, -3496>, 0, true )    // Hydroponics
	SURVIVAL_AddOverrideCircleLocation( <-25588, -10407, -4455>, 0, true )	// NE of Hydroponics
	SURVIVAL_AddOverrideCircleLocation( <-2946, -24898, -4464>, 0, true )    // Bonsai Plaza
	SURVIVAL_AddOverrideCircleLocation( <-13309, -20101, -4383>, 0, true )    // Houses NW of Bonsai
	SURVIVAL_AddOverrideCircleLocation( <563, -14158, -6061>, 0, true )    // Solar Array
	SURVIVAL_AddOverrideCircleLocation( <22762, -16177, -4998>, 0, true )    // Orbital Cannon
	SURVIVAL_AddOverrideCircleLocation( <11516, -18020, -5684>, 0, true )		// NW of Cannon
	SURVIVAL_AddOverrideCircleLocation( <17913, -2511, -5112>, 0, true )    // Grow Towers
	SURVIVAL_AddOverrideCircleLocation( <16907, 8456, -3624>, 0, true )    // Gardens
	SURVIVAL_AddOverrideCircleLocation( <9012, 18621, -5865>, 0, true )    // Rift (outer)
	SURVIVAL_AddOverrideCircleLocation( <650, 8502, -5000>, 0, true )    // Energy Depot
	SURVIVAL_AddOverrideCircleLocation( <5237, -4233, -4301>, 0, true )    // Near Phase Runner
	SURVIVAL_AddOverrideCircleLocation( <-3920, -3602, -6122>, 0, true )    // Hammond Labs
	SURVIVAL_AddOverrideCircleLocation( <-14139, -4043, -5552>, 0, true )    // Between Labs and Estates
	SURVIVAL_AddOverrideCircleLocation( <-13504, 11612, -6558>, 0, true )    // Turbine
	SURVIVAL_AddOverrideCircleLocation( <-4818, 27611, -6108>, 0, true )    // Power Grid (outer)
	SURVIVAL_AddOverrideCircleLocation( <-4969, 18418, -5892>, 0, true )    // Power Grid (inner)
}
#endif