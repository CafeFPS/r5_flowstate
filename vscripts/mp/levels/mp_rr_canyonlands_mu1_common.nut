#if SERVER
global function Canyonlands_MU1_CommonMapInit
global function LeviathansInit
global function GetLeviathans
global function GetZone6Leviathan
global function GetZone9Leviathan

// Called by MU1 and MU2
global function InitWraithAudioLog
global function InitOctaneTownTakeover
global function PlaceOctaneTownTakeoverLoot
global function CreateOctaneTTRingOfFireStatsTrigger

#if DEVELOPER
global function LeviathanTeleportBug

global function TestZone6LeviathanFootStomp
global function TestZone9LeviathanFootStomp

global function DEV_LeviathanAllowRoar

global function TeleportPlayerZeroIntoLeviathanFoot
global function RecreateLeviathanDeathTriggers
#endif // DEVELOPER
#endif // SERVER

//global const asset MU1_LEVIATHAN_MODEL = $"mdl/Creatures/leviathan/leviathan_kingscanyon_animated.rmdl"

#if SERVER
const asset FX_LEVIATHAN_CLOUD = $"P_cloud_leviathan_01"
const LEVIATHAN_MAX_HEALTH = 1000 //Could be any positive number really, we never set health to 0, and we don't decrement it based on what hit the leviathan

const float MAX_LANDING_Z = 8900.0 // height below which players can no longer interact with upper leviathan bone followers

const float LEVIATHAN_LARGEST_LOOK_AT_PITCH_ADJUSTMENT = 35.0
const float LEVIATHAN_SMALLEST_LOOK_AT_PITCH_ADJUSTMENT = -30.0
const float LEVIATHAN_LARGEST_LOOK_AT_YAW_ADJUSTMENT = 80.0
const float LEVIATHAN_SMALLEST_LOOK_AT_YAW_ADJUSTMENT = -80.0

const float LEVIATHAN_UPPER_AREA_Z = 6000.0 // about where the tip of the tail is when idle

const float LEVIATHAN_DAMAGE_DECAY_RATE = 10; // damage per second to stop caring about

const float LEVIATHAN_LOOK_DAMAGE_THRESHOLD = 300
const float LEVIATHAN_SHAKE_DAMAGE_THRESHOLD = 200
const float LEVIATHAN_SHAKE_DAMAGE_REDUCE = 200

const float LEVIATHAN_SUPER_ANGRY_DAMAGE_AMOUNT_MIN = 700
const float LEVIATHAN_SUPER_ANGRY_DAMAGE_AMOUNT_MAX = 1000
const float LEVIATHAN_SUPER_ANGRY_DAMAGE_INCREASE_MIN = 200
const float LEVIATHAN_SUPER_ANGRY_DAMAGE_INCREASE_MAX = 400

const float LEVIATHAN_STOMP_DAMAGE_AMOUNT_MIN = 50
const float LEVIATHAN_STOMP_DAMAGE_AMOUNT_MAX = 1200 // very high so it's rare
const float LEVIATHAN_STOMP_DAMAGE_INCREASE_MIN = 500 // very high so it's really hard to make it happen more than once
const float LEVIATHAN_STOMP_DAMAGE_INCREASE_MAX = 2000

const int LEVIATHAN_ULT_ADJUSTMENT_RADIUS = 9000

// Wraith audiolog
const float WRAITH_TT_AUDIO_LOG_DEBOUNCE = 5.0
const float WRAITH_TT_AUDIO_LOG_LENGTH = 36

// Relay rock fix
const asset RELAY_ROCK_FIX_MODEL = $"mdl/rocks/rock_white_chalk_modular_wallrun_02.rmdl"

// Octane fire ring
const asset FX_OCTANE_TT_GUN_BG = $"chamber_dark_background"

enum LeviathanState
{
	IDLE,
	LOOK,
	SHAKE,
	ROAR,
	STOMP,
	STAND,

	_COUNT
}

struct LeviathanDamageInfo
{
	vector frompos
	entity attacker
	float lastTime
	float damage // accumulates
}

struct LeviathanDataStruct
{
	asset[LeviathanState._COUNT] stateAnims

	entity looktarget
	float lookendtime
	vector lookang
	vector lookvel

	LeviathanDamageInfo allDamageInfo
	LeviathanDamageInfo footDamageInfo
	array< LeviathanDamageInfo > damageInfos

	//float lookPitchLerpOffset

	int state
	int roarSide

	float superAngryDamageThreshold
	float stompDamageThreshold
	float nextDamageReactionTime
	float nextRoarTime
	float nextShakeTime
	float nextLookTime
}
struct LeviathanStompDataStruct
{
	float cylinderAboveHeight
	float cylinderBelowHeight
	float radius
	float staticTriggerRadiusReduction = 0.0
	vector offset
}

struct{
	array<entity>                      leviathans //Fine for now, want to be able to differentiate between the 2 eventually.
	entity                             leviathan_zone_6
	entity                             leviathan_zone_9
	table<entity, LeviathanDataStruct> leviathanToDataStructTable
	table<string, LeviathanStompDataStruct > zone6Leviathan_AttachmentToStompDataStructTable
	table<string, LeviathanStompDataStruct > zone9Leviathan_AttachmentToStompDataStructTable

	array<Point>  leviathanStompSafeSpotsForDeathBox
	array<entity> leviathansDeathTriggers

	bool randomLeviathanRoarThisGame
	bool randomLeviathanRoarNextLook
} file

// Use for MU1/direct MU1 spinoffs (like night map)
void function Canyonlands_MU1_CommonMapInit()
{
	//SetFlyersToSpawn( 8 )

		Canyonlands_MapInit_Common()

		MapZones_RegisterDataTable( $"datatable/map_zones/zones_mp_rr_canyonlands_mu1.rpak" )

		AddCallback_EntitiesDidLoad( MU1_EntitiesDidLoad )

		AddCallback_GameStateEnter( eGameState.Playing, Leviathan_OptimizeUpperBoneFollowersWhenAllPlayersHaveLanded )
		AddSpawnCallback_ScriptName( "leviathan_staging", CreateClientSideLeviathanMarkers)
		Survival_SetCallback_Leviathan_ConsiderLookAtEnt( Leviathan_ConsiderLookAtEnt_Callback )

	InitOctaneTownTakeover()

	//if ( RelayRockFixEnabled() )
		//RegisterGeoFixAsset( RELAY_ROCK_FIX_MODEL )
}

void function MU1_EntitiesDidLoad()
{
	LeviathansInit()

	if ( RelayRockFixEnabled() )
		SpawnRelayRockFix()
}


void function InitOctaneTownTakeover()
{
	PrecacheParticleSystem( FX_OCTANE_TT_GUN_BG )
	AddDamageCallbackSourceID( eDamageSourceId.burn, PlayerTookBurnTriggerDamage )
}

void function InitWraithAudioLog()
{
	const string WRAITH_AUDIO_LOG_SCRIPTNAME = "wraith_audio_log_target"
	if ( GetEntArrayByScriptName( WRAITH_AUDIO_LOG_SCRIPTNAME ).len() < 1 )
		return

	entity audioLogTarget = GetEntByScriptName( WRAITH_AUDIO_LOG_SCRIPTNAME )
	audioLogTarget.SetUsable()
	audioLogTarget.SetFadeDistance( 100000 )
	audioLogTarget.AddUsableValue( USABLE_CUSTOM_HINTS | USABLE_BY_OWNER | USABLE_BY_PILOTS | USABLE_BY_ENEMIES )
	audioLogTarget.SetUsablePriority( USABLE_PRIORITY_LOW )
	audioLogTarget.SetUsePrompts( "#WRAITH_LOG_USE", "#WRAITH_LOG_USE_PC" )
	AddCallback_OnUseEntity( audioLogTarget, WraithTTAudioLog_OnUse )
}


void function WraithTTAudioLog_OnUse( entity log, entity player, int useInputFlags )
{
	if ( (useInputFlags & USE_INPUT_DEFAULT) == 0 )
		return

	log.UnsetUsable()
	thread WraithTTAudioLog_PlayLog( log )

	thread WraithTTAudioLog_SetUsableAfterDelay( log, WRAITH_TT_AUDIO_LOG_LENGTH + WRAITH_TT_AUDIO_LOG_DEBOUNCE )
}

void function WraithTTAudioLog_PlayLog( entity log )
{
	EmitSoundAtPosition( TEAM_UNASSIGNED, log.GetCenter(), "Laptop_Log_Activate" )
	wait 0.5

	EmitSoundAtPosition( TEAM_UNASSIGNED, log.GetCenter(), "diag_mp_wraith_tt_01_3p" )
}

void function WraithTTAudioLog_SetUsableAfterDelay( entity log, float delay )
{
	wait delay
	log.SetUsable()
}

void function PlaceOctaneTownTakeoverLoot()
{
	array<entity> itemSpawn = GetEntArrayByScriptName( "octane_tt_hanging_item_spawn" )
	if ( itemSpawn.len() != 1 )
		return

	entity target  = itemSpawn[ 0 ]
	string itemRef = SURVIVAL_GetWeightedItemFromGroup( "POI_OctaneTT" )

	//entity spawnedItem = SpawnGenericLoot( itemRef, target.GetOrigin(), < -1, -1, -1 > )
	//spawnedItem.RemoveUsableValue( USABLE_USE_VERTICAL_LINE )
	//spawnedItem.RemoveUsableValue( USABLE_HORIZONTAL_FOV )
	//spawnedItem.AddUsableValue( USABLE_USE_DISTANCE_OVERRIDE )
	//spawnedItem.SetUsableDistanceOverride( 300.0 )

	//vector boundingSize = spawnedItem.GetBoundingMaxs() - spawnedItem.GetBoundingMins()
	//float originOffset  = boundingSize.z * 0.8
	//if ( boundingSize.x > boundingSize.z )
	//{
	//	vector angles = spawnedItem.GetAngles()
	//	spawnedItem.SetAngles( < angles.x + 90, angles.y, angles.z > )
	//	originOffset = boundingSize.x * 0.5
	//}

	//vector targetToCenter = spawnedItem.GetCenter() - target.GetOrigin()
	//spawnedItem.SetOrigin( target.GetOrigin() - < 0, 0, boundingSize.z * 0.5 > )

	//int bgFxId = GetParticleSystemIndex( FX_OCTANE_TT_GUN_BG )
	//StartParticleEffectOnEntityWithPos( spawnedItem, bgFxId, FX_PATTACH_ABSORIGIN_FOLLOW, -1, < -45, 0, 0 >, < 0, 0, 0 > )
}


void function CreateOctaneTTRingOfFireStatsTrigger()
{
	array<entity> itemSpawn = GetEntArrayByScriptName( "octane_tt_hanging_item_spawn" )
	if ( itemSpawn.len() != 1 )
		return
	entity target        = itemSpawn[0]
	vector ringOfFirePos = target.GetOrigin() // (dw): Using this to locate where the ring of fire is

	entity trigger = CreateEntity( "trigger_cylinder" )
	//trigger.SetCylinderRadius( 100.0 )
	trigger.SetAboveHeight( 85.0 )
	trigger.SetBelowHeight( 85.0 )
	trigger.SetOrigin( ringOfFirePos )
	trigger.SetAngles( <0, 0, 0> )
	trigger.kv.triggerFilterNonCharacter = "0"
	DispatchSpawn( trigger )

	// (dw): Using leave instead of enter to handle the player grabbing armor while flying through the ring.
	trigger.SetLeaveCallback( void function( entity trigger, entity ent ) {
		if ( !IsValid( ent ) || !ent.IsPlayer() )
			return

		if ( !IsAlive( ent ) )
			return // (dw): To handle if the player is killed while in the ring of fire (quite easy to do if you stand on the flaming bottom part).

		//StatsHook_PlayerUsedMapFeature( ent, "octanett_ringoffire" )
	} )
}

void function LeviathansInit()
{

	file.leviathan_zone_6 = GetEntByScriptName( "leviathan_zone_6" )
	file.leviathan_zone_9 = GetEntByScriptName( "leviathan_zone_9" )

	PrecacheParticleSystem( FX_LEVIATHAN_CLOUD )
	RegisterSignal( "LeviathanLook"  )
	RegisterSignal( "LeviathanTookDamage" )

	// setting targetname so that we can use AddTargetNameCreateCallback(...) on the client
	SetTargetName( file.leviathan_zone_6, "leviathan_zone_6" )
	SetTargetName( file.leviathan_zone_9, "leviathan_zone_9" )

	AddAirdropTraceIgnoreEnt( file.leviathan_zone_6 )
	AddAirdropTraceIgnoreEnt( file.leviathan_zone_9 )

	LeviathanStompDataStruct zone6LeftFrontFootStompDataStruct
	zone6LeftFrontFootStompDataStruct.radius = 410
	zone6LeftFrontFootStompDataStruct.cylinderAboveHeight = 70.0
	zone6LeftFrontFootStompDataStruct.cylinderBelowHeight = 450.0
	zone6LeftFrontFootStompDataStruct.offset = < 60, 30, 0>
	zone6LeftFrontFootStompDataStruct.staticTriggerRadiusReduction = 60.0

	LeviathanStompDataStruct zone6LeftFrontFootSupplemental
	zone6LeftFrontFootSupplemental.radius = 120
	zone6LeftFrontFootSupplemental.cylinderAboveHeight = 70.0
	zone6LeftFrontFootSupplemental.cylinderBelowHeight = 0.0
	zone6LeftFrontFootSupplemental.offset = < -50, -375, 0>

	LeviathanStompDataStruct zone6LeftFrontFootSupplemental2
	zone6LeftFrontFootSupplemental2.radius = 125
	zone6LeftFrontFootSupplemental2.cylinderAboveHeight = 70.0
	zone6LeftFrontFootSupplemental2.cylinderBelowHeight = 0.0
	zone6LeftFrontFootSupplemental2.offset = < -240, -250, 0>

	LeviathanStompDataStruct zone6LeftFrontFootSupplemental3
	zone6LeftFrontFootSupplemental3.radius = 165
	zone6LeftFrontFootSupplemental3.cylinderAboveHeight = 70.0
	zone6LeftFrontFootSupplemental3.cylinderBelowHeight = 0.0
	zone6LeftFrontFootSupplemental3.offset = < -100, 300, 0>

	LeviathanStompDataStruct zone6LeftFrontFootSupplemental4
	zone6LeftFrontFootSupplemental4.radius = 90
	zone6LeftFrontFootSupplemental4.cylinderAboveHeight = 70.0
	zone6LeftFrontFootSupplemental4.cylinderBelowHeight = 0.0
	zone6LeftFrontFootSupplemental4.offset = < 100, -345, 0>

	LeviathanStompDataStruct zone6LeftFrontFootSupplemental5
	zone6LeftFrontFootSupplemental5.radius = 50
	zone6LeftFrontFootSupplemental5.cylinderAboveHeight = 70.0
	zone6LeftFrontFootSupplemental5.cylinderBelowHeight = 0.0
	zone6LeftFrontFootSupplemental5.offset = < 50, -435, 0>


	LeviathanStompDataStruct zone6RightFrontFootStompDataStruct
	zone6RightFrontFootStompDataStruct.radius = 410
	zone6RightFrontFootStompDataStruct.cylinderAboveHeight = 70.0
	zone6RightFrontFootStompDataStruct.cylinderBelowHeight = 450.0
	zone6RightFrontFootStompDataStruct.offset = < 0, -50, 0>
	zone6RightFrontFootStompDataStruct.staticTriggerRadiusReduction = 40.0

	LeviathanStompDataStruct zone9LeftFrontFootStompDataStruct
	zone9LeftFrontFootStompDataStruct.radius = 390.0
	zone9LeftFrontFootStompDataStruct.cylinderAboveHeight = 70.0
	zone9LeftFrontFootStompDataStruct.cylinderBelowHeight = 450.0
	zone9LeftFrontFootStompDataStruct.offset = < 50, -30, 0>
	zone9LeftFrontFootStompDataStruct.staticTriggerRadiusReduction = 95.0

	LeviathanStompDataStruct zone9LeftFrontFootStompDataStructSupplemental
	zone9LeftFrontFootStompDataStructSupplemental.radius = 125.0
	zone9LeftFrontFootStompDataStructSupplemental.cylinderAboveHeight = 70.0
	zone9LeftFrontFootStompDataStructSupplemental.cylinderBelowHeight = 0
	zone9LeftFrontFootStompDataStructSupplemental.offset = < 250, 250, 0>

	LeviathanStompDataStruct zone9LeftFrontFootStompDataStructSupplemental2
	zone9LeftFrontFootStompDataStructSupplemental2.radius = 125.0
	zone9LeftFrontFootStompDataStructSupplemental2.cylinderAboveHeight = 70.0
	zone9LeftFrontFootStompDataStructSupplemental2.cylinderBelowHeight = 0
	zone9LeftFrontFootStompDataStructSupplemental2.offset = < 0, -250, 0>

	LeviathanStompDataStruct zone9LeftFrontFootStompDataStructSupplemental3
	zone9LeftFrontFootStompDataStructSupplemental3.radius = 125.0
	zone9LeftFrontFootStompDataStructSupplemental3.cylinderAboveHeight = 70.0
	zone9LeftFrontFootStompDataStructSupplemental3.cylinderBelowHeight = 0
	zone9LeftFrontFootStompDataStructSupplemental3.offset = < 350, 70, 0>

	LeviathanStompDataStruct zone9LeftFrontFootStompDataStructSupplemental4
	zone9LeftFrontFootStompDataStructSupplemental4.radius = 125.0
	zone9LeftFrontFootStompDataStructSupplemental4.cylinderAboveHeight = 70.0
	zone9LeftFrontFootStompDataStructSupplemental4.cylinderBelowHeight = 0
	zone9LeftFrontFootStompDataStructSupplemental4.offset = < -310, 90, 0>

	LeviathanStompDataStruct zone9LeftFrontFootStompDataStructSupplemental5
	zone9LeftFrontFootStompDataStructSupplemental5.radius = 100.0
	zone9LeftFrontFootStompDataStructSupplemental5.cylinderAboveHeight = 70.0
	zone9LeftFrontFootStompDataStructSupplemental5.cylinderBelowHeight = 0
	zone9LeftFrontFootStompDataStructSupplemental5.offset = < -350, -110, 0>




	if ( IsValid( file.leviathan_zone_6 ) )
	{
		file.leviathans.append( file.leviathan_zone_6 )

		LeviathanDataStruct data
		data.stateAnims[LeviathanState.IDLE] = $"animseq/creatures/leviathan/leviathan_animated/leviathan_kingscanyon_mu1_zone6_munching_idle.rseq"
		data.stateAnims[LeviathanState.LOOK] = data.stateAnims[LeviathanState.IDLE] // $"animseq/creatures/leviathan/leviathan_animated/leviathan_kingscanyon_mu1_zone6_head_neutral.rseq"
		data.stateAnims[LeviathanState.SHAKE] = $"animseq/creatures/leviathan/leviathan_animated/leviathan_kingscanyon_mu1_zone6_shake.rseq"
		data.stateAnims[LeviathanState.ROAR] = $"animseq/creatures/leviathan/leviathan_animated/leviathan_kingscanyon_mu1_zone6_roar.rseq"

		if ( GetCurrentPlaylistVarBool( "evil_leviathans", false ) )
			data.stateAnims[LeviathanState.ROAR] = $"animseq/creatures/leviathan/leviathan_animated/leviathan_kingscanyon_mu1_zone6_roar_shadow.rseq"

		data.stateAnims[LeviathanState.STOMP] = $"animseq/creatures/leviathan/leviathan_animated/leviathan_kingscanyon_mu1_zone6_leg_lift.rseq"
		data.stateAnims[LeviathanState.STAND] = $"animseq/creatures/leviathan/leviathan_animated/leviathan_kingscanyon_mu1_zone6_stand.rseq"

		file.leviathanToDataStructTable[ file.leviathan_zone_6 ] <- data

		file.zone6Leviathan_AttachmentToStompDataStructTable[ "FX_L_FOOT_A"  ] <- zone6LeftFrontFootStompDataStruct
		file.zone6Leviathan_AttachmentToStompDataStructTable[ "FX_R_FOOT_A"  ] <- zone6RightFrontFootStompDataStruct

		//Init death triggers in feet for zone 6 leviathan
		entity frontleftFootTrigger = CreateDeathTriggersInsideLeviathanFeet( file.leviathan_zone_6, "FX_L_FOOT_A", zone6LeftFrontFootStompDataStruct )
		entity frontleftFootSupplementalTrigger = CreateDeathTriggersInsideLeviathanFeet( file.leviathan_zone_6, "FX_L_FOOT_A", zone6LeftFrontFootSupplemental )
		entity frontleftFootSupplementalTrigger2 = CreateDeathTriggersInsideLeviathanFeet( file.leviathan_zone_6, "FX_L_FOOT_A", zone6LeftFrontFootSupplemental2 )
		entity frontleftFootSupplementalTrigger3 = CreateDeathTriggersInsideLeviathanFeet( file.leviathan_zone_6, "FX_L_FOOT_A", zone6LeftFrontFootSupplemental3 )
		entity frontleftFootSupplementalTrigger4 = CreateDeathTriggersInsideLeviathanFeet( file.leviathan_zone_6, "FX_L_FOOT_A", zone6LeftFrontFootSupplemental4 )
		entity frontleftFootSupplementalTrigger5 = CreateDeathTriggersInsideLeviathanFeet( file.leviathan_zone_6, "FX_L_FOOT_A", zone6LeftFrontFootSupplemental5 )

		entity frontrightFootTrigger = CreateDeathTriggersInsideLeviathanFeet( file.leviathan_zone_6, "FX_R_FOOT_A" , zone6RightFrontFootStompDataStruct )

		//Setup safespots for deathboxes when players are crushed by leviathan's feet

		Point zone6_FrontLeft_SafeDeathBoxSpot1
		zone6_FrontLeft_SafeDeathBoxSpot1.origin = <6585.564941, -2842.639893, 2080.845947>
		zone6_FrontLeft_SafeDeathBoxSpot1.angles = < 27.393206, -101.856026, 0 >
		file.leviathanStompSafeSpotsForDeathBox.append( zone6_FrontLeft_SafeDeathBoxSpot1 )

		Point zone6_FrontLeft_SafeDeathBoxSpot2
		zone6_FrontLeft_SafeDeathBoxSpot2.origin = < 6336.281738, -3599.423828, 2005.598267>
		zone6_FrontLeft_SafeDeathBoxSpot2.angles = < 20.233309, -138.489944, 0 >
		file.leviathanStompSafeSpotsForDeathBox.append( zone6_FrontLeft_SafeDeathBoxSpot2 )

		Point zone6_FrontLeft_SafeDeathBoxSpot3
		zone6_FrontLeft_SafeDeathBoxSpot3.origin = < 5563.900879, -3580.969727, 2131.115479 >
		zone6_FrontLeft_SafeDeathBoxSpot3.angles = < 16.537201, 128.658768, 0>
		file.leviathanStompSafeSpotsForDeathBox.append( zone6_FrontLeft_SafeDeathBoxSpot3 )

		Point zone6_FrontLeft_SafeDeathBoxSpot4
		zone6_FrontLeft_SafeDeathBoxSpot4.origin = < 5576.116211, -2814.419434, 2109.048096 >
		zone6_FrontLeft_SafeDeathBoxSpot4.angles = < 19.102730, 68.505020, 0 >
		file.leviathanStompSafeSpotsForDeathBox.append( zone6_FrontLeft_SafeDeathBoxSpot4 )

		Point zone6_FrontRight_SafeDeathBoxSpot1
		zone6_FrontRight_SafeDeathBoxSpot1.origin = < 7908.698730, -704.986511, 3284.023682>
		zone6_FrontRight_SafeDeathBoxSpot1.angles = < 9.461251, 150.514069, 0 >
		file.leviathanStompSafeSpotsForDeathBox.append( zone6_FrontRight_SafeDeathBoxSpot1 )

		Point zone6_FrontRight_SafeDeathBoxSpot2
		zone6_FrontRight_SafeDeathBoxSpot2.origin = < 7357.807129, -570.694885, 3294.826172>
		zone6_FrontRight_SafeDeathBoxSpot2.angles = < -1.983863, 131.933731, 0 >
		file.leviathanStompSafeSpotsForDeathBox.append( zone6_FrontRight_SafeDeathBoxSpot2 )

		Point zone6_FrontRight_SafeDeathBoxSpot3
		zone6_FrontRight_SafeDeathBoxSpot3.origin = < 7144.082031, 356.535889, 3936.242920 >
		zone6_FrontRight_SafeDeathBoxSpot3.angles = < 7.163844, 43.621662, 0 >
		file.leviathanStompSafeSpotsForDeathBox.append( zone6_FrontRight_SafeDeathBoxSpot3 )

		Point zone6_FrontRight_SafeDeathBoxSpot4
		zone6_FrontRight_SafeDeathBoxSpot4.origin = < 8280.272461, -425.902649, 3291.036865 >
		zone6_FrontRight_SafeDeathBoxSpot4.angles = < 11.839429, -128.277313, 0 >
		file.leviathanStompSafeSpotsForDeathBox.append( zone6_FrontRight_SafeDeathBoxSpot4 )
	}

	if ( IsValid( file.leviathan_zone_9 ) )
	{
		file.leviathans.append( file.leviathan_zone_9 )

		LeviathanDataStruct data
		data.stateAnims[LeviathanState.IDLE] = $"animseq/creatures/leviathan/leviathan_animated/leviathan_kingscanyon_mu1_zone9_munching_idle.rseq"
		data.stateAnims[LeviathanState.LOOK] = data.stateAnims[LeviathanState.IDLE] // TODO $"animseq/creatures/leviathan/leviathan_animated/leviathan_kingscanyon_mu1_zone9_head_neutral.rseq"
		data.stateAnims[LeviathanState.SHAKE] = $"animseq/creatures/leviathan/leviathan_animated/leviathan_kingscanyon_mu1_zone9_shake.rseq"
		data.stateAnims[LeviathanState.ROAR] = $"animseq/creatures/leviathan/leviathan_animated/leviathan_kingscanyon_mu1_zone9_roar.rseq"
		if ( GetCurrentPlaylistVarBool( "evil_leviathans", false ) )
			data.stateAnims[LeviathanState.ROAR] = $"animseq/creatures/leviathan/leviathan_animated/leviathan_kingscanyon_mu1_zone9_roar_shadow.rseq"
		data.stateAnims[LeviathanState.STOMP] = $"animseq/creatures/leviathan/leviathan_animated/leviathan_kingscanyon_mu1_zone9_leg_lift.rseq"

		file.leviathanToDataStructTable[ file.leviathan_zone_9 ] <- data

		file.zone9Leviathan_AttachmentToStompDataStructTable[ "FX_L_FOOT_A"  ] <- zone9LeftFrontFootStompDataStruct

		entity frontleftFootTrigger = CreateDeathTriggersInsideLeviathanFeet( file.leviathan_zone_9, "FX_L_FOOT_A", zone9LeftFrontFootStompDataStruct  )
		entity frontleftFootTriggerSupplemental = CreateDeathTriggersInsideLeviathanFeet( file.leviathan_zone_9, "FX_L_FOOT_A", zone9LeftFrontFootStompDataStructSupplemental )
		entity frontleftFootTriggerSupplemental2 = CreateDeathTriggersInsideLeviathanFeet( file.leviathan_zone_9, "FX_L_FOOT_A", zone9LeftFrontFootStompDataStructSupplemental2  )
		entity frontleftFootTriggerSupplemental3 = CreateDeathTriggersInsideLeviathanFeet( file.leviathan_zone_9, "FX_L_FOOT_A", zone9LeftFrontFootStompDataStructSupplemental3  )
		entity frontleftFootTriggerSupplemental4 = CreateDeathTriggersInsideLeviathanFeet( file.leviathan_zone_9, "FX_L_FOOT_A", zone9LeftFrontFootStompDataStructSupplemental4  )
		entity frontleftFootTriggerSupplemental5 = CreateDeathTriggersInsideLeviathanFeet( file.leviathan_zone_9, "FX_L_FOOT_A", zone9LeftFrontFootStompDataStructSupplemental5  )

		//Setup safespots for deathboxes when players are crushed by leviathan's feet

		Point zone9_FrontLeft_SafeDeathBoxSpot1
		zone9_FrontLeft_SafeDeathBoxSpot1.origin = < 315.885712, 16635.968750, 2432.052979 >
		zone9_FrontLeft_SafeDeathBoxSpot1.angles = < 11.835224, 149.467743, 0>
		file.leviathanStompSafeSpotsForDeathBox.append( zone9_FrontLeft_SafeDeathBoxSpot1 )

		Point zone9_FrontLeft_SafeDeathBoxSpot2
		zone9_FrontLeft_SafeDeathBoxSpot2.origin = <22.767666, 16678.648438, 2375.670410>
		zone9_FrontLeft_SafeDeathBoxSpot2.angles = < 7.121348, 135.938904, 0>
		file.leviathanStompSafeSpotsForDeathBox.append( zone9_FrontLeft_SafeDeathBoxSpot2 )

		Point zone9_FrontLeft_SafeDeathBoxSpot3
		zone9_FrontLeft_SafeDeathBoxSpot3.origin = < -331.147064, 17073.042969, 2489.378174 >
		zone9_FrontLeft_SafeDeathBoxSpot3.angles = < 16.889608, 73.000313, 0 >
		file.leviathanStompSafeSpotsForDeathBox.append( zone9_FrontLeft_SafeDeathBoxSpot3 )

		Point zone9_FrontLeft_SafeDeathBoxSpot4
		zone9_FrontLeft_SafeDeathBoxSpot4.origin = < -168.356476, 17594.197266, 2479.775879 >
		zone9_FrontLeft_SafeDeathBoxSpot4.angles = < 23.892269, 31.812557, 0 >
		file.leviathanStompSafeSpotsForDeathBox.append( zone9_FrontLeft_SafeDeathBoxSpot4 )

		Point zone9_FrontLeft_SafeDeathBoxSpot5
		zone9_FrontLeft_SafeDeathBoxSpot5.origin = < 980.488586, 17346.046875, 2471.358398>
		zone9_FrontLeft_SafeDeathBoxSpot5.angles = < 14.164673, -79.038307, 0 >
		file.leviathanStompSafeSpotsForDeathBox.append( zone9_FrontLeft_SafeDeathBoxSpot5 )
	}

	foreach ( leviathan in GetLeviathans() )
	{
		InitIndividualLeviathan( leviathan )
	}

	if ( ShouldIncreaseRoarFrequency() )
		file.randomLeviathanRoarThisGame = true
	else
		file.randomLeviathanRoarThisGame = RandomInt( 10 ) == 0


	if ( file.randomLeviathanRoarThisGame )
	{
		if ( RandomInt( 6 ) == 0 )
			file.randomLeviathanRoarNextLook = true // just roar at the first thing it sees!
		else
			thread Leviathan_RandomRoarThread()
	}

	//create NoSpawnArea around feet now that they are initialized
	foreach( trig in file.leviathansDeathTriggers )
	{
		//float radius = trig.GetCylinderRadius()
		//vector origin = trig.GetOrigin()
		//CreateNoSpawnArea( TEAM_ANY, TEAM_ANY, origin, -1.0 )
	}
}


void function InitIndividualLeviathan( entity leviathan )
{
	leviathan.SetMaxHealth( LEVIATHAN_MAX_HEALTH )
	leviathan.SetHealth( LEVIATHAN_MAX_HEALTH )
	SetLeviathanMover( leviathan, true )

	Assert( leviathan in file.leviathanToDataStructTable )
	LeviathanDataStruct leviathanData = file.leviathanToDataStructTable[ leviathan ]

	leviathanData.state = LeviathanState.IDLE
	leviathan.Anim_Play( leviathanData.stateAnims[LeviathanState.IDLE] )
	leviathan.SetCycle( RandomFloat( 1.0 ) )
	AddAnimEvent( leviathan, "leviathan_foot_stomp_FL", AnimEvent_LeviathanFLFootStomp )
	AddAnimEvent( leviathan, "leviathan_foot_stomp_FR", AnimEvent_LeviathanFRFootStomp )
	//AddAnimEvent( leviathan, "leviathan_foot_stomp_BL", AnimEvent_LeviathanBLFootStomp ) //No Back leg stomp anims
	//AddAnimEvent( leviathan, "leviathan_foot_stomp_BR", AnimEvent_LeviathanBRFootStomp ) //No Back leg stomp anims
	AddAnimEvent( leviathan, "leviathan_foot_stomp_shake_FL", AnimEvent_LeviathanFLFootStompShake )
	AddAnimEvent( leviathan, "leviathan_foot_stomp_shake_FR", AnimEvent_LeviathanFRFootStompShake )
	leviathan.SetCanBeMeleed( false )

	if ( GetCurrentPlaylistVarBool( "evil_leviathans", false ) )
		leviathan.SetSkin( 1 )

	if ( ShouldIncreaseRoarFrequency() )
	{
		leviathanData.superAngryDamageThreshold = 10
	}
	else
	{
		leviathanData.superAngryDamageThreshold = RandomFloatRange( LEVIATHAN_SUPER_ANGRY_DAMAGE_AMOUNT_MIN, LEVIATHAN_SUPER_ANGRY_DAMAGE_AMOUNT_MAX )
	}
	leviathanData.stompDamageThreshold = RandomFloatRange( LEVIATHAN_STOMP_DAMAGE_AMOUNT_MIN, LEVIATHAN_STOMP_DAMAGE_AMOUNT_MAX )

	leviathan.SetDamageNotifications( true )
	AddEntityCallback_OnDamaged( leviathan, Leviathan_OnTakeDamage )

	// randomly choose whether we play the "shake" animation when taking damage. Every time we play the animation or look at someone damaging us, we will redecide this.
	if ( RandomInt( 2 ) == 0 )
		leviathanData.nextShakeTime = 1.e38

	//Test making phys_bone_followers take damage.
	array<entity> boneFollowers = leviathan.GetBoneFollowers()

	foreach( boneFollower in boneFollowers )
		boneFollower.SetTakeDamageType( DAMAGE_EVENTS_ONLY )

	PlayCloudsOnLeviathan( leviathan )

	thread Leviathan_LookThread( leviathan )
	thread Leviathan_StompThread( leviathan )

	int radiusForUltAdjustment = GetCurrentPlaylistVarInt( "leviathan_ult_adjustment_radius",  LEVIATHAN_ULT_ADJUSTMENT_RADIUS  )
	entity trig = CreateEntity( "trigger_cylinder" ) //To make Bangalore/Gibraltar's ult around the leviathans be created at a heigher height.
	//trig.SetCylinderRadius( radiusForUltAdjustment  )
	//trig.SetAboveHeight( DEFAULT_BOMBARDMENT_HEIGHT )
	//trig.SetBelowHeight( DEFAULT_BOMBARDMENT_HEIGHT )
	trig.SetOrigin(  leviathan.GetOrigin() )

	trig.SetOwner( leviathan  )
	trig.SetEnterCallback( Leviathan_Ult_Adjustment_Enter )
	trig.SetLeaveCallback( Leviathan_Ult_Adjustment_Leave )

	DispatchSpawn( trig )
}

entity function CreateDeathTriggersInsideLeviathanFeet( entity leviathan, string attachment, LeviathanStompDataStruct dataStruct ) //To stop people being stuck inside leviathan when they do foot stomps
{
	vector origin = leviathan.GetAttachmentOrigin( leviathan.LookupAttachment ( attachment ) )
	entity trig = CreateEntity( "trigger_cylinder" )
	//trig.SetCylinderRadius( dataStruct.radius  - dataStruct.staticTriggerRadiusReduction )
	trig.SetAboveHeight( dataStruct.cylinderAboveHeight )
	trig.SetBelowHeight( 0 )
	trig.SetOrigin(  origin + dataStruct.offset + <0, 0, 50 > )

	trig.SetPhaseShiftCanTouch( true )
	trig.SetOwner( leviathan  )
	trig.SetEnterCallback( Leviathan_Stomp_TriggerDamage )

	trig.SetParent( leviathan, attachment, true )
	DispatchSpawn( trig )

	file.leviathansDeathTriggers.append( trig  )
	return trig
}

array<entity> function GetLeviathans()
{
	return file.leviathans
}


entity function GetZone6Leviathan()
{
	return  file.leviathan_zone_6
}


entity function GetZone9Leviathan()
{
	return  file.leviathan_zone_9
}

const bool DEBUGDAMAGE = false

const vector LEVIATHAN_6_FRONT_LEFT_FOOT_POS = <6028, -3094, 2206>
const vector LEVIATHAN_9_FRONT_LEFT_FOOT_POS = <344, 17145, 2515>
const float FOOT_DIST_SQR = 1100.0 * 1100.0

void function Leviathan_OnTakeDamage( entity leviathan, var damageInfo )
{
	vector pos = DamageInfo_GetDamagePosition( damageInfo )
	if ( pos.z - leviathan.GetOrigin().z < LEVIATHAN_UPPER_AREA_Z )
	{
		if ( DistanceSqr( pos, LEVIATHAN_6_FRONT_LEFT_FOOT_POS ) < FOOT_DIST_SQR || DistanceSqr( pos, LEVIATHAN_9_FRONT_LEFT_FOOT_POS ) < FOOT_DIST_SQR )
		{
			LeviathanDataStruct leviathanData = file.leviathanToDataStructTable[ leviathan ]
			float damage = DamageInfo_GetDamage( damageInfo )

			float time = Time()
			float timePassed = time - leviathanData.footDamageInfo.lastTime
			leviathanData.footDamageInfo.damage -= timePassed * LEVIATHAN_DAMAGE_DECAY_RATE
			if ( leviathanData.footDamageInfo.damage < 0 )
				leviathanData.footDamageInfo.damage = 0
			leviathanData.footDamageInfo.damage += damage
			leviathanData.footDamageInfo.lastTime = time

			if ( DEBUGDAMAGE )
				printt( "foot damage " + leviathanData.footDamageInfo.damage )

			if ( leviathanData.footDamageInfo.damage > leviathanData.stompDamageThreshold )
			{
				if ( leviathanData.state == LeviathanState.IDLE || leviathanData.state == LeviathanState.LOOK )
				{
					if ( DEBUGDAMAGE )
						printt( "stomp!" )
					leviathanData.footDamageInfo.damage = 0
					leviathanData.stompDamageThreshold += RandomFloatRange( LEVIATHAN_STOMP_DAMAGE_INCREASE_MIN, LEVIATHAN_STOMP_DAMAGE_INCREASE_MAX )
					thread Leviathan_PlayStateAnimAndWait( leviathan, leviathanData, LeviathanState.STOMP )
				}
				else
				{
					if ( DEBUGDAMAGE )
						printt( "missed stomp" )
					// reduce foot damage a lot
					leviathanData.footDamageInfo.lastTime -= 60
				}
			}
		}

		return
	}

	Assert( leviathan in file.leviathanToDataStructTable )
	LeviathanDataStruct leviathanData = file.leviathanToDataStructTable[ leviathan ]

	entity attacker = DamageInfo_GetAttacker( damageInfo )
	if ( !IsValid( attacker ) )
		return

	float damage = DamageInfo_GetDamage( damageInfo )

	float time = Time()

	{
		float timePassed = time - leviathanData.allDamageInfo.lastTime
		leviathanData.allDamageInfo.damage -= timePassed * LEVIATHAN_DAMAGE_DECAY_RATE
		if ( leviathanData.allDamageInfo.damage < 0 )
			leviathanData.allDamageInfo.damage = 0
		leviathanData.allDamageInfo.damage += damage
		leviathanData.allDamageInfo.lastTime = time
	}

	if ( DEBUGDAMAGE )
		printt( "damage " + leviathanData.allDamageInfo.damage )

	vector fromPos = attacker.GetOrigin()

	LeviathanDamageInfo ornull nearestDamageInfo = null
	float bestDistSq = 4000.0 * 4000.0
	for ( int i = leviathanData.damageInfos.len() - 1; i >= 0; i-- ) // iterate backwards so we can remove as we go
	{
		LeviathanDamageInfo levDamageInfo = leviathanData.damageInfos[i]

		float timePassed = time - levDamageInfo.lastTime
		levDamageInfo.damage -= timePassed * LEVIATHAN_DAMAGE_DECAY_RATE
		if ( levDamageInfo.damage < 0 )
		{
			leviathanData.damageInfos.fastremove( i )
			continue
		}

		float distSq = DistanceSqr( fromPos, levDamageInfo.frompos )
		if ( distSq > bestDistSq )
			continue

		bestDistSq = distSq
		nearestDamageInfo = levDamageInfo
	}

	if ( !nearestDamageInfo )
	{
		LeviathanDamageInfo newDamageInfo
		newDamageInfo.damage = 0

		nearestDamageInfo = newDamageInfo
		leviathanData.damageInfos.append( newDamageInfo )
	}

	expect LeviathanDamageInfo( nearestDamageInfo )

	nearestDamageInfo.frompos = fromPos
	nearestDamageInfo.attacker = attacker
	nearestDamageInfo.lastTime = time
	nearestDamageInfo.damage += damage

	thread LeviathanDamageReaction( leviathan, leviathanData, attacker, pos, nearestDamageInfo )
}

void function DEV_LeviathanAllowRoar()
{
	foreach ( leviathan in file.leviathans )
	{
		LeviathanDataStruct leviathanData = file.leviathanToDataStructTable[ leviathan ]
		leviathanData.superAngryDamageThreshold = 10
		leviathanData.nextRoarTime = 0
		leviathanData.nextDamageReactionTime = 0
	}
}

void function LeviathanDamageReaction( entity leviathan, LeviathanDataStruct leviathanData, entity attacker, vector pos, LeviathanDamageInfo thisLevDamageInfo )
{
	leviathan.Signal( "LeviathanTookDamage" )

	// WaitEndFrame() prevents changing animation from within projectile lag compensation.
	// This works around a bug in which code doesn't detect the animation sequence transition until the next frame's snapshot, causing a visual pop.
	// It's possible that multiple of these threads could accumulate on one frame here, but that should be harmless.
	WaitEndFrame()

	if ( !IsValid( attacker ) )
		return

	if ( leviathanData.state != LeviathanState.IDLE && leviathanData.state != LeviathanState.LOOK )
	{
		if ( DEBUGDAMAGE )
			DebugDrawText( pos, "in animation", true, 1.0 )
		return
	}

	float time = Time()
	if ( time < leviathanData.nextDamageReactionTime )
	{
		if ( DEBUGDAMAGE )
			DebugDrawText( pos, string( ceil( leviathanData.nextDamageReactionTime - time ) ) + "s", true, 1.0 )
		return
	}

	if ( leviathanData.allDamageInfo.damage >= leviathanData.superAngryDamageThreshold && time > leviathanData.nextRoarTime )
	{
		// roar
		if ( DEBUGDAMAGE )
			DebugDrawText( pos, "roar", true, 1.0 )

		leviathanData.looktarget = null

		int state
		if ( leviathanData.stateAnims[LeviathanState.STAND] != $"" && RandomInt( 4 ) == 0 )
		{
			state = LeviathanState.STAND
		}
		else
		{
			state = LeviathanState.ROAR

			file.randomLeviathanRoarThisGame = false

			array< LeviathanDamageInfo > damageInfos = leviathanData.damageInfos
			damageInfos.sort( int function( LeviathanDamageInfo a, LeviathanDamageInfo b ) { return int(a.damage - b.damage) } )
			foreach ( LeviathanDamageInfo damageInfo in damageInfos )
			{
				if ( !IsValid( damageInfo.attacker ) )
					continue
				vector lookpos = damageInfo.attacker.GetOrigin() + damageInfo.attacker.GetVelocity() * LEVIATHAN_LOOK_ANTICIPATE_TIME
				if ( Leviathan_CanLookAtEnt( leviathan, lookpos, 1.0, 1.0, DEBUGDAMAGE ) )
				{
					leviathanData.looktarget = damageInfo.attacker
					leviathanData.lookendtime = time + 12.0 // about how long until the roar ends
					break
				}
			}
		}

		leviathanData.roarSide = 0
        if(state == LeviathanState.ROAR)
            thread Leviathan_PlayRoar(leviathan, 5)
		Leviathan_PlayStateAnimAndWait( leviathan, leviathanData, state )

		if ( ShouldIncreaseRoarFrequency() )
		{
			leviathanData.superAngryDamageThreshold = 10
			leviathanData.nextDamageReactionTime = 0
			leviathanData.nextRoarTime = time + RandomFloatRange( 15.0, 30.0 )
		}
		else
		{
			leviathanData.superAngryDamageThreshold += RandomFloatRange( LEVIATHAN_SUPER_ANGRY_DAMAGE_INCREASE_MIN, LEVIATHAN_SUPER_ANGRY_DAMAGE_INCREASE_MAX )
			leviathanData.nextDamageReactionTime = time + RandomFloatRange( 10.0, 20.0 )
			leviathanData.nextRoarTime = time + RandomFloatRange( 60.0, 120.0 )
		}

		// forget all damage
		leviathanData.allDamageInfo.damage = 0
		leviathanData.damageInfos.clear()

		return
	}

	vector lookpos = attacker.GetOrigin() + attacker.GetVelocity() * LEVIATHAN_LOOK_ANTICIPATE_TIME

	if ( thisLevDamageInfo.damage > LEVIATHAN_LOOK_DAMAGE_THRESHOLD && time > leviathanData.nextLookTime )
	{
		if ( Leviathan_CanLookAtEnt( leviathan, lookpos, 1.0, 1.0, DEBUGDAMAGE ) )
		{
			if ( DEBUGDAMAGE )
				DebugDrawText( pos, "look", true, 1.0 )

			// look!
			leviathanData.looktarget = attacker
			leviathanData.lookendtime = time + RandomFloatRange( 5.0, 15.0 )

			Leviathan_StartLooking( leviathan, leviathanData )
		}

		leviathanData.nextDamageReactionTime = time + RandomFloatRange( 3.0, 8.0 )
		leviathanData.nextLookTime = RandomFloatRange( 5, leviathanData.lookendtime + 15.0 )

		// randomly turn shake animation on or off
		if ( RandomInt( 2 ) == 0 )
			leviathanData.nextShakeTime = 1.e38
		else if ( leviathanData.nextShakeTime >= 1.e38 )
			leviathanData.nextShakeTime = time + RandomFloatRange( 15.0, 20.0 )
	}

	if ( thisLevDamageInfo.damage > LEVIATHAN_SHAKE_DAMAGE_THRESHOLD && time > leviathanData.nextShakeTime )
	{
		if ( DEBUGDAMAGE )
			DebugDrawText( pos, "shake", true, 1.0 )

		// shake
		Leviathan_PlayStateAnimAndWait( leviathan, leviathanData, LeviathanState.SHAKE )

		leviathanData.allDamageInfo.damage -= LEVIATHAN_SHAKE_DAMAGE_REDUCE
		if ( leviathanData.allDamageInfo.damage < 0 )
			leviathanData.allDamageInfo.damage = 0

		leviathanData.nextDamageReactionTime = time + RandomFloatRange( 5.0, 10.0 )
		if ( RandomInt( 2 ) == 0 )
			leviathanData.nextShakeTime = 1.e38
		else
			leviathanData.nextShakeTime = time + RandomFloatRange( 30.0, 60.0 )
		return
	}

	if ( DEBUGDAMAGE )
		DebugDrawText( pos, ".", true, 1.0 )
}

void function Leviathan_PlayStateAnimAndWait( entity leviathan, LeviathanDataStruct leviathanData, int state )
{
	Assert( leviathanData.state == LeviathanState.IDLE || leviathanData.state == LeviathanState.LOOK )
	leviathanData.state = state

	asset anim = leviathanData.stateAnims[state]
	waitthread PlayAnim( leviathan, anim )

	Assert( leviathanData.state == state )

	leviathanData.state = LeviathanState.IDLE
	leviathan.Anim_Play( leviathanData.stateAnims[LeviathanState.IDLE] )

	if ( IsValid( leviathanData.looktarget ) )
		Leviathan_StartLooking( leviathan, leviathanData )
}


void function PlayCloudsOnLeviathan( entity ent )
{
	printt( "Creating FOG on " + ent )
	int fxid     = GetParticleSystemIndex( FX_LEVIATHAN_CLOUD )
	int attachid = ent.LookupAttachment( "CHEST_FOCUS" )


	vector attachOrg = ent.GetAttachmentOrigin( attachid )
	vector attachAng = ent.GetAttachmentAngles( attachid )
	vector fx_offset = < 0, 0, -2000 >

	entity fx = StartParticleEffectInWorld_ReturnEntity( fxid, attachOrg + fx_offset, attachAng )
}

vector function GetLeviathanAngDiffForPos( LeviathanDataStruct leviathanData, vector headorg, vector headang, float leviathanyaw, vector pos )
{
	const float ExtraPitch = 10 // look down a little more than directly toward the object; looks better

	vector targetdir = leviathanData.looktarget.GetOrigin() - headorg
	vector targetang = VectorToAngles( targetdir )

	vector angdiff
	// use angle relative to *actual* head pos so we're not reliant on the pose parameters being super accurate.
	// this is wrong for animations that move the head wildly, but the acceleration is slow enough that hopefully won't matter much
	angdiff.x = AngleNormalize( targetang.x ) + ExtraPitch - AngleNormalize( headang.x )
	angdiff.y = AngleNormalize( targetang.y - leviathanyaw ) - AngleNormalize( headang.y - leviathanyaw ) // do yaw relative to overall leviathan so the "seam" is behind them, where they can't look
	//targetang = leviathanData.lookang + lookang

	return angdiff
}

vector function ClampLeviathanAngDiff( LeviathanDataStruct leviathanData, vector angdiff )
{
	if ( angdiff.x + leviathanData.lookang.x > 90 )
		angdiff.x = 90 - leviathanData.lookang.x
	else if ( angdiff.x + leviathanData.lookang.x < -90)
		angdiff.x = -90 - leviathanData.lookang.x

	if ( angdiff.y + leviathanData.lookang.y > 90 )
		angdiff.y = 90 - leviathanData.lookang.y
	else if ( angdiff.y + leviathanData.lookang.y < -90)
		angdiff.y = -90 - leviathanData.lookang.y

	return angdiff
}

void function Leviathan_StompThread( entity leviathan )
{
	LeviathanDataStruct leviathanData = file.leviathanToDataStructTable[ leviathan ]

	FlagWait( "GamePlaying" )
	wait RandomFloatRange( 30, 60 )
	for ( ;; )
	{
		wait RandomFloatRange( 120, 500 )

		if ( leviathanData.state != LeviathanState.IDLE && leviathanData.state != LeviathanState.LOOK )
			continue

		int state
		if ( RandomInt( 4 ) == 0 && leviathanData.stateAnims[LeviathanState.STAND] != $"" )
			state = LeviathanState.STAND
		else
			state = LeviathanState.STOMP

		Leviathan_PlayStateAnimAndWait( leviathan, leviathanData, state )
	}
}

void function Leviathan_RandomRoarThread()
{
	FlagWait( "GamePlaying" )

	float waitTime
	if ( ShouldIncreaseRoarFrequency() )
		waitTime = RandomFloatRange( 60, 60 * 3 )
	else
		waitTime = RandomFloatRange( 60, 60 * 15 )

	wait waitTime

	if ( file.randomLeviathanRoarThisGame )
		file.randomLeviathanRoarNextLook = true
}

bool function ShouldIncreaseRoarFrequency()
{

	if ( GetCurrentPlaylistVarBool( "leviathan_increase_roar_frequency", false ) == true )
		return true

	return false
}

void function Leviathan_RandomRoar( entity leviathan )
{
	Assert( file.randomLeviathanRoarThisGame )
	file.randomLeviathanRoarThisGame = false

	Assert( file.leviathans.len() == 2 )
	int index = (file.leviathans[0] == leviathan) ? 0 : 1
	Assert( leviathan == file.leviathans[index] )

	for ( int i = 0; i < 2; i++ )
	{
		leviathan = file.leviathans[index]
		LeviathanDataStruct leviathanData = file.leviathanToDataStructTable[ leviathan ]

		if ( leviathanData.state != LeviathanState.IDLE && leviathanData.state != LeviathanState.LOOK )
			break

		leviathanData.roarSide = 0
        thread Leviathan_PlayRoar(leviathan, 5)
		Leviathan_PlayStateAnimAndWait( leviathan, leviathanData, LeviathanState.ROAR )

		// only rarely have both leviathans roar
		if ( RandomInt( 10 ) > 0 )
			break

		index = 1 - index // other leviathan
		wait RandomFloatRange( 5, 13 )
	}
}

void function Leviathan_PlayRoar(entity leviathan, float waitTime)
{
    //This is hacky and there's probably a better way to do this, but it will work for now.
    wait waitTime
    
    int leviathanMouthAttachmentIndex = file.leviathan_zone_6.LookupAttachment( "FX_MOUTH" )
    vector org = leviathan.GetAttachmentOrigin( leviathanMouthAttachmentIndex )
    if(GetCurrentPlaylistVarBool( "evil_leviathans", false ) )
        EmitSoundAtPosition( TEAM_UNASSIGNED, org, "Leviathan_AngryRoar")
    else
        EmitSoundAtPosition( TEAM_UNASSIGNED, org, "Leviathan_LongRoar")
}

const float LOOK_PITCH_DIFF = 25

void function Leviathan_StartLooking( entity leviathan, LeviathanDataStruct leviathanData )
{
	if ( leviathanData.state == LeviathanState.IDLE )
	{
		leviathanData.state = LeviathanState.LOOK
		//leviathan.Anim_Play( leviathanData.stateAnims[LeviathanState.LOOK] )

		// non-look animations have the head pitched down, but the look animation doesn't.
		// we need to lerp the pitch pose parameter by the inverse of that over the same length of time that the animation lerps.
		//leviathanData.lookPitchLerpOffset += LOOK_PITCH_DIFF
	}
}


void function Leviathan_StopLooking( entity leviathan, LeviathanDataStruct leviathanData )
{
	leviathanData.looktarget = null
	if ( leviathanData.state == LeviathanState.LOOK )
	{
		leviathanData.state = LeviathanState.IDLE
		//leviathan.Anim_Play( leviathanData.stateAnims[LeviathanState.IDLE] )

		//leviathanData.lookPitchLerpOffset -= LOOK_PITCH_DIFF
	}
}


const float LEVIATHAN_LOOK_ANTICIPATE_TIME = 4.0

void function Leviathan_LookThread( entity leviathan )
{
	LeviathanDataStruct leviathanData = file.leviathanToDataStructTable[ leviathan ]

	bool debug = false // (leviathan == GetZone9Leviathan())

	int leviathanMouthAttachmentIndex = file.leviathan_zone_6.LookupAttachment( "FX_MOUTH" )
	int pitchPoseParamIndex = leviathan.LookupPoseParameterIndex( "aim_pitch"  )
	int yawPoseParamIndex = leviathan.LookupPoseParameterIndex( "aim_yaw"  )

	vector center = leviathan.GetAttachmentOrigin( leviathan.LookupAttachment( "CHEST_FOCUS" ) )
	vector forward = leviathan.GetForwardVector()

	float leviathanyaw = leviathan.GetAngles().y

	int mouthAttachmentIndex

	const float normallookaccel = 4 // degrees / s^2
	const float fastlookaccel = 10
	const float roarlookaccel = 40

	const float normalmaxvel = 20
	const float roarmaxvel = 80

	const float dt = 0.099 // close to 0.1
	const float MaxVelFudge = 0.9 // prevents head from moving too fast and overshooting due to inaccurate pose parameter values

	for ( ;; )
	{
		vector angdiff
		vector desiredangvel
		float lookaccel = normallookaccel
		float maxvel = normalmaxvel

		entity lookTarget

		// decide whether to look at anything at all
		if ( leviathanData.state != LeviathanState.LOOK )
		{
			lookTarget = null
			lookaccel = fastlookaccel

			// hack: if doing the roar part of the roar animation, look at the guy!
			if ( leviathanData.state == LeviathanState.ROAR && leviathan.GetCycle() > 0.13 )
			{
				if ( leviathan.GetCycle() < 0.45 )
					lookTarget = leviathanData.looktarget
				lookaccel = roarlookaccel
				maxvel = roarmaxvel
			}
		}
		else
		{
			lookTarget = leviathanData.looktarget
		}

		// decide what point to look at
		if ( IsValid( lookTarget ) )
		{
			if ( debug )
				printt( "target " + lookTarget )
			if ( Time() > leviathanData.lookendtime )
			{
				Leviathan_StopLooking( leviathan, leviathanData )
				continue
			}

			vector headorg = leviathan.GetAttachmentOrigin( leviathanMouthAttachmentIndex )
			vector headang = leviathan.GetAttachmentAngles( leviathanMouthAttachmentIndex )

			vector lookPos = leviathanData.looktarget.GetOrigin()
			angdiff = GetLeviathanAngDiffForPos( leviathanData, headorg, headang, leviathanyaw, leviathanData.looktarget.GetOrigin() )

			vector futureLookPos = lookPos + leviathanData.looktarget.GetVelocity() * LEVIATHAN_LOOK_ANTICIPATE_TIME
			vector futureangdiff = GetLeviathanAngDiffForPos( leviathanData, headorg, headang, leviathanyaw, futureLookPos )

			// if future angle is too far out of field of view, stop looking
			float yaw = futureangdiff.y + leviathanData.lookang.y
			if ( (yaw > 120 || yaw < -120) && DotProduct( futureLookPos - center, forward ) < 0 )
			{
				if ( debug )
					printt( "clearing target (yaw " + yaw + ")" )
				Leviathan_StopLooking( leviathan, leviathanData )
				continue
			}

			angdiff = ClampLeviathanAngDiff( leviathanData, angdiff )
			futureangdiff = ClampLeviathanAngDiff( leviathanData, futureangdiff )

			desiredangvel = (futureangdiff - angdiff) / LEVIATHAN_LOOK_ANTICIPATE_TIME
		}
		else
		{
			angdiff = -leviathanData.lookang
			desiredangvel = <0,0,0>
		}

		if ( leviathanData.state == LeviathanState.ROAR )
		{
			float cycle = leviathan.GetCycle()
			// hack: zone 6 leviathan can't have certain yaws near the end of its roar without the head going through the rock
			if ( leviathan == file.leviathan_zone_6 && cycle > 0.2 && cycle < 0.6 )
			{
				if ( leviathanData.roarSide == 0 && (leviathanData.lookang.x > 30 || cycle > 0.3) )
				{
					// pick a side of the rock
					float yaw = leviathanData.lookang.y + angdiff.y
					leviathanData.roarSide = (yaw > -40) ? 1 : -1
					if ( debug )
						printt( "picked side " + leviathanData.roarSide + " (yaw " + yaw + ")" )
				}
				if ( leviathanData.roarSide < 0 )
				{
					if ( leviathan.GetCycle() > 0.45 )
					{
						angdiff.y = -60 - leviathanData.lookang.y
						// also pitch down (helps get head around the rock)
						angdiff.x = 15 - leviathanData.lookang.x
					}
					else if ( leviathanData.lookang.y + angdiff.y > -60 ) // keep yaw < -60
					{
						angdiff.y = -60 - leviathanData.lookang.y
					}
				}
				else if ( leviathanData.roarSide > 0 )
				{
					// keep yaw >= 0
					if ( leviathanData.lookang.y + angdiff.y < 0 )
					{
						angdiff.y = -leviathanData.lookang.y
						// also don't pitch down (avoids going into rock)
						if ( angdiff.x > 0 )
							angdiff.x = 0 - leviathanData.lookang.x
					}
				}
			}

			if ( cycle < 0.4 )
			{
				// while roaring, change pitch slowly, because the roar animation changes it quickly
				angdiff.x *= 0.25
			}
		}

		// we treat pitch and yaw as vectors in 2d space.
		// find the vector toward the goal, and accelerate in that direction.
		// decelerate the perpendicular direction.
		float dist = angdiff.Length()
		vector dir = Normalize( angdiff )
		vector perp = <dir.y, -dir.x, 0>

		vector relvel = leviathanData.lookvel - desiredangvel

		float dirvel = DotProduct( dir, relvel )
		float perpvel = DotProduct( perp, relvel )

		// a   =   lookaccel
		// v   =   a * t + v0                   =   lookaccel * t + lookvel
		// d   =   1/2 a * t^2 + v0 * t + d0    =   0.5 * lookaccel * t * t + lookvel * t + lookang

		// want to know v0 (maxvel) that will result in v = 0 at a given d when a is negative
		// -lookaccel * t + maxvel = 0
		// t = maxvel / lookaccel // time it takes to decelerate to 0
		// d = 0.5 * -lookaccel * (maxvel / lookaccel)^2 + maxvel * (maxvel / lookaccel)
		// d = -0.5 * maxvel^2 / lookaccel + maxvel^2 / lookaccel
		// d = 0.5 * maxvel^2 / lookaccel
		// maxvel^2 = d * lookaccel / 0.5
		// maxvel = sqrt( 2 * d * lookaccel )
		float desiredvel = min( sqrt( 2.0 * dist * lookaccel ) * MaxVelFudge, maxvel )

		float velchange = lookaccel * dt
		float desiredveloffset = desiredvel - dirvel
		if ( desiredveloffset > velchange )
			leviathanData.lookvel += velchange * dir
		else if ( desiredveloffset < -velchange )
			leviathanData.lookvel -= velchange * dir
		else
			leviathanData.lookvel += desiredveloffset * dir

		// desired vel in perpendicular dir is 0.
		if ( perpvel > velchange )
			leviathanData.lookvel -= velchange * perp
		else if ( perpvel < -velchange )
			leviathanData.lookvel += velchange * perp
		else
			leviathanData.lookvel -= perpvel * perp

		//float framevel = (oldvel + leviathanData.lookvel[i]) * 0.5 // average old and new velocity for this frame
		leviathanData.lookang += leviathanData.lookvel * dt

		if ( debug )
			printt( " cycle " + leviathan.GetCycle() + " ang " + leviathanData.lookang + " angdiff " + angdiff + " desiredvel " + desiredangvel + " vel " + leviathanData.lookvel )

		/*if ( leviathanData.lookPitchLerpOffset )
		{
			float maxPitchChange = dt * LOOK_PITCH_DIFF // LOOK_PITCH_DIFF degrees per second because the anim lerp time is 1 second and the angle difference between look and idle is LOOK_PITCH_DIFF
			float pitchChange
			if ( leviathanData.lookPitchLerpOffset > maxPitchChange )
				pitchChange = -maxPitchChange
			else if ( leviathanData.lookPitchLerpOffset < -maxPitchChange )
				pitchChange = maxPitchChange
			else
				pitchChange = -leviathanData.lookPitchLerpOffset

			leviathanData.lookPitchLerpOffset += pitchChange
			vector lookang = leviathanData.lookang
			lookang.x -= pitchChange
			lookang.y -= pitchChange // * 0.5
			leviathanData.lookang = lookang
		}*/

		leviathan.SetPoseParameterOverTime( pitchPoseParamIndex, leviathanData.lookang.x, dt * 1.05 )
		leviathan.SetPoseParameterOverTime( yawPoseParamIndex, leviathanData.lookang.y, dt * 1.05 )

		wait dt
	}
}

const float MinLookAtDist = 8000.0 // about the distance from CHEST_FOCUS to head when looking around
const float MinCareDist = 16000.0
const float MaxCareDist = 40000.0
const float cos70 = 0.342

bool function Leviathan_CanLookAtEnt( entity leviathan, vector pos, float careChance, float maxDistCareChance, bool DEBUG )
{
	vector center = leviathan.GetAttachmentOrigin( leviathan.LookupAttachment( "CHEST_FOCUS" ) )

	float chance = RandomFloat( 1 )
	if ( chance > careChance )
	{
		if ( DEBUG )
			DebugDrawLine( center, pos, 255,255,0, true, 5 )
		return false
	}

	// can't look at things too close to our torso
	float distSqr = DistanceSqr( pos, center )
	if ( distSqr < MinLookAtDist * MinLookAtDist )
	{
		if ( DEBUG )
			DebugDrawLine( center, pos, 255,0,0, true, 5 )
		return false
	}

	// Care about things based on how far away they are
	if ( distSqr >= MaxCareDist * MaxCareDist )
	{
		if ( DEBUG )
			DebugDrawLine( center, pos, 255,0,0, true, 5 )
		return false
	}

	if ( distSqr >= MinCareDist * MinCareDist )
	{
		float distCareChance = GraphCapped( sqrt( distSqr ), MinCareDist, MaxCareDist, careChance, maxDistCareChance )
		if ( chance > distCareChance )
		{
			if ( DEBUG )
				DebugDrawLine( center, pos, 255,255,0, true, 5 )
			return false
		}
	}

	vector dir = leviathan.GetForwardVector()

	vector diff = pos - center

	// can't look more than 110 degrees away
	float dot = DotProduct( diff, dir )
	if ( dot < 0 )
	{
		if ( dot * dot > cos70 * cos70 * diff.LengthSqr() )
		{
			if ( DEBUG )
				DebugDrawLine( center, pos, 255,128,0, true, 5 )
			return false
		}
	}

	if ( DEBUG )
		DebugDrawLine( center, pos, 0,255,0, true, 5 )

	return true
}

void function Leviathan_ConsiderLookAtEnt_Callback( entity ent, float duration, float careChance )
{
	const bool DEBUG = false

	array< entity > leviathans = clone file.leviathans
	leviathans.randomize()

	ent.EndSignal( "OnDestroy" )

	vector pos = ent.GetOrigin() + ent.GetVelocity() * min( duration * 0.3, LEVIATHAN_LOOK_ANTICIPATE_TIME )
	foreach ( entity leviathan in leviathans )
	{
		if ( !Leviathan_CanLookAtEnt( leviathan, pos, careChance, 0, DEBUG ) )
			continue

		LeviathanDataStruct leviathanData = file.leviathanToDataStructTable[ leviathan ]
		if ( leviathanData.state == LeviathanState.ROAR )
			continue // don't change what we're roaring at

		leviathanData.looktarget = ent
		leviathanData.lookendtime = Time() + duration

		if ( file.randomLeviathanRoarThisGame && file.randomLeviathanRoarNextLook )
		{
			leviathanData.lookendtime = Time() + 12.0 // about how long until the roar ends
			Leviathan_RandomRoar( leviathan )
		}
		else
		{
			Leviathan_StartLooking( leviathan, leviathanData )
		}

		// don't want both leviathans looking at the same time
		wait RandomFloatRange( duration * .1, duration * .2 )
	}
}


void function AnimEvent_LeviathanFLFootStomp( entity leviathan  )
{
	OnLeviathanFootStomp( leviathan, "FX_L_FOOT_A" )
}

void function AnimEvent_LeviathanFRFootStomp( entity leviathan  )
{
	OnLeviathanFootStomp( leviathan, "FX_R_FOOT_A" )
}

void function AnimEvent_LeviathanFLFootStompShake( entity leviathan  )
{
	CreateLeviathanStompShake( leviathan, "FX_L_FOOT_A" )
}

void function AnimEvent_LeviathanFRFootStompShake( entity leviathan  )
{
	CreateLeviathanStompShake( leviathan, "FX_R_FOOT_A" )
}

void function CreateLeviathanStompShake( entity leviathan, string attachment )
{
	vector footOrigin = leviathan.GetAttachmentOrigin( leviathan.LookupAttachment ( attachment ) )
	entity shake = CreateShake( footOrigin, 22, 180, 2.0, 6000 )
	shake.kv.spawnflags = SF_SHAKE_INAIR
}



void function OnLeviathanFootStomp( entity leviathan, string attachment )
{
	vector footOrigin = leviathan.GetAttachmentOrigin( leviathan.LookupAttachment ( attachment ) )

	LeviathanStompDataStruct dataStruct

	if ( leviathan == GetZone6Leviathan()  )
		dataStruct = file.zone6Leviathan_AttachmentToStompDataStructTable[ attachment  ]
	else
		dataStruct = file.zone9Leviathan_AttachmentToStompDataStructTable[ attachment  ]

	entity trig = CreateEntity( "trigger_cylinder" )
	//trig.SetCylinderRadius( dataStruct.radius )
	trig.SetAboveHeight( dataStruct.cylinderAboveHeight )
	trig.SetBelowHeight( dataStruct.cylinderBelowHeight )
	trig.SetOrigin(  footOrigin + dataStruct.offset )
	trig.SetPhaseShiftCanTouch( false )
	trig.SetOwner( leviathan  )
	trig.kv.triggerFilterNpc = "all"
	trig.kv.triggerFilterPlayer = "pilot"
	trig.kv.triggerFilterNonCharacter = "1"
	trig.kv.triggerFilterTeamIMC = "1"
	trig.kv.triggerFilterTeamMilitia = "1"
	trig.kv.triggerFilterTeamOther = "1"
	trig.SetEnterCallback( Leviathan_Stomp_TriggerDamage )
	trig.SetParent( leviathan, attachment, true  )
	DispatchSpawn( trig )

	trig.SearchForNewTouchingEntity()
	thread CleanupTrigger( trig )
}

void function Leviathan_Stomp_TriggerDamage( entity trigger, entity ent )
{
	entity leviathan = trigger.GetOwner()
	if ( ent.GetOwner() ==  leviathan  ) //This is probably a phys_bone_follower of the leviathan!
		return

	if ( ent.IsPlayer() )
	{
		if ( !IsAlive( ent  )  )
			return

		if ( ent.IsPhaseShiftedOrPending() ) //Better to cancel phase shift for players than to let them be inside the leviathan's foot for a while, then die when coming out of phase shift. Also considered but too much work: Leviathans aren't in phase shift land!
			ent.PhaseShiftCancel()


		//Point safeSpotForDeathBox = FindBestSafeSpotForDeathBox( ent )

		//ent.p.safeSpotForDeathBox = safeSpotForDeathBox
	}

	string entScriptName = ent.GetScriptName()

	if ( entScriptName == PHASETUNNEL_BLOCKER_SCRIPTNAME  ) //Phase tunnel, force close the tunnel
	{
		entity tunnelEnt = ent.GetOwner()

		if ( IsValid( tunnelEnt  ) )
		{
			entity ownerPlayer = tunnelEnt.GetOwner()

			if ( IsAlive( ownerPlayer  )  )
				ownerPlayer.Signal( "PhaseTunnel_DestroyPlacement" )

		}
	}

	if ( entScriptName == PHASETUNNEL_PRE_BLOCKER_SCRIPTNAME  ) //Pre phase tunnel, try to stop the tunnel from being created
	{
		entity ownerPlayer = ent.GetOwner()
		if ( IsValid( ownerPlayer ) && ownerPlayer.IsPlayer() )
			ownerPlayer.Signal( "PhaseTunnel_CancelPlacement" ) //Try to stop the portal creation process
	}

	if ( !IsAlive( ent ) )
		return

	if ( ent.IsPlayer() && ent.IsShadowForm() )
		ent.TakeDamage( 10000, svGlobal.worldspawn, trigger, { damageSourceId = eDamageSourceId.crushed, scriptType =  DF_BYPASS_SHIELD | DF_SKIPS_DOOMED_STATE }   )
	else
		ent.Die( trigger.GetOwner(), trigger, { damageSourceId = eDamageSourceId.crushed, scriptType =  DF_BYPASS_SHIELD | DF_SKIPS_DOOMED_STATE, damageType = DMG_CRUSH }  )

	if ( ent.IsPlayer() )
	{
	vector entOrigin = ent.GetOrigin()
	vector triggerOrigin = trigger.GetOrigin()

	if ( entOrigin.z < triggerOrigin.z ) //Pushed the player underneath the world, so hackily pop the ent back up to avoid pushing it through the world
			ent.SetAbsOrigin( < entOrigin.x, entOrigin.y, triggerOrigin.z > ) //Player can be parented, so set abs origin instead of origin
	}

}

void function CleanupTrigger( entity trigger  )
{
	wait 0.2

	trigger.SearchForNewTouchingEntity() //JFS: Just to get entities that we miss.

	if (IsValid( trigger ) )
		trigger.Destroy()
}

Point function FindBestSafeSpotForDeathBox( entity player  ) //This is lazy, comparing to all points in a single array instead of having separate arrays for each leviathan foot. Mainly because it's not convenient to get that info at time of leviathan foot stomp
{
	vector playerOrigin = player.GetOrigin()

	Point resultPoint
	float minDistSqr = 900000.0

	foreach( testPoint in file.leviathanStompSafeSpotsForDeathBox )
	{
		float dist2DSqr = Distance2DSqr( playerOrigin, testPoint.origin )

		if ( dist2DSqr < minDistSqr )
		{
			minDistSqr = dist2DSqr
			resultPoint = testPoint
		}
	}

	return resultPoint

}

void function Leviathan_Ult_Adjustment_Enter( entity trigger, entity ent )
{
	if ( ent.IsPlayer() )
		StatusEffect_AddEndless( ent, eStatusEffect.bombardment_uses_extended_height, 1.0 )
}

void function Leviathan_Ult_Adjustment_Leave( entity trigger, entity ent )
{
	if ( ent.IsPlayer() )
		StatusEffect_StopAllOfType( ent, eStatusEffect.bombardment_uses_extended_height )
}

void function Leviathan_OptimizeUpperBoneFollowersWhenAllPlayersHaveLanded()
{

	if ( IsFallLTM() ) //don't optimize since we will constantly be skydiving back in
		return

	thread Leviathan_OptimizeUpperBoneFollowersWhenAllPlayersHaveLanded_Thread()
}

void function Leviathan_OptimizeUpperBoneFollowersWhenAllPlayersHaveLanded_Thread()
{
	// wait for all players to have landed
	array<entity> players = GetPlayerArray_Alive()
	int checkCount = 0
	for ( ;; )
	{
		for ( int i = players.len() - 1; i >= 0; i-- )
		{
			entity player = players[i]
			//if ( !IsAlive( player ) || (player.p.survivalLandedOnGround && player.GetOrigin().z < MAX_LANDING_Z) )
			//{
			//	players.fastremove( i )
			//	continue
			//}
			break
		}

		if ( players.len() == 0 )
		{
			checkCount++
			if ( checkCount == 2 )
				break

			// all players in the original array have landed, but get a new array in case someone connected late
			players = GetPlayerArray_Alive()
		}
		else
		{
			wait players.len() * 0.05
		}
	}

	foreach ( leviathan in file.leviathans )
	{
		table< entity, bool > keepFollowers
		keepFollowers[leviathan.GetBoneFollowerForBone( "def_r_ankleA" )] <- true
		keepFollowers[leviathan.GetBoneFollowerForBone( "def_r_ankleB" )] <- true
		keepFollowers[leviathan.GetBoneFollowerForBone( "def_r_kneeA" )] <- true
		keepFollowers[leviathan.GetBoneFollowerForBone( "def_r_kneeB" )] <- true
		keepFollowers[leviathan.GetBoneFollowerForBone( "def_l_ankleA" )] <- true
		keepFollowers[leviathan.GetBoneFollowerForBone( "def_l_ankleB" )] <- true
		keepFollowers[leviathan.GetBoneFollowerForBone( "def_l_kneeA" )] <- true
		keepFollowers[leviathan.GetBoneFollowerForBone( "def_l_kneeB" )] <- true

		array<entity> allFollowers = leviathan.GetBoneFollowers()

		foreach ( follower in allFollowers )
		{
			if ( follower in keepFollowers )
				continue
			follower.SetPusher( false )
			follower.DisablePhysics()
		}
	}
}

void function CreateClientSideLeviathanMarkers( entity leviathan )
{
	leviathan.EndSignal( "OnDestroy" )

	vector leviathanOrigin = leviathan.GetOrigin()
	vector leviathanAngles = leviathan.GetAngles()

	entity ent = CreatePropDynamic_NoDispatchSpawn( $"mdl/dev/empty_model.rmdl", leviathanOrigin, leviathanAngles )
	SetTargetName( ent, leviathan.GetScriptName() )
	DispatchSpawn( ent )

	leviathan.Destroy()

	ent.EndSignal( "OnDestroy" )

	wait 3.0

	ent.Destroy()
}

void function PlayerTookBurnTriggerDamage( entity ent, var damageInfo )
{
	if ( !ent.IsPlayer()  )
		return

	entity attacker = DamageInfo_GetAttacker( damageInfo )

	if ( !IsValid (attacker ) )
		return

	if ( attacker.GetClassName() != "trigger_hurt"  )
		return

	EmitSoundOnEntityOnlyToPlayer( ent, ent, "flesh_thermiteburn_3p_vs_1p"  )
}

void function SpawnRelayRockFix()
{
	CreatePropDynamic( RELAY_ROCK_FIX_MODEL, < 30597.9, 24214.7, 4136.22 + 68.0		>, < 0, -85.7655 + 90.0, 0 >, 		SOLID_VPHYSICS, 15000 )
	CreatePropDynamic( RELAY_ROCK_FIX_MODEL, < 30606.1, 24458.3, 4128.22 + 68.0 	>, < 0, -82.9966 + 90.0, 0 >, 		SOLID_VPHYSICS, 15000 )
	CreatePropDynamic( RELAY_ROCK_FIX_MODEL, < 30608.5, 24785.4, 4136.22 + 68.0		>, < 0, -83.8008 + 90.0, 0 >, 		SOLID_VPHYSICS, 15000 )
	CreatePropDynamic( RELAY_ROCK_FIX_MODEL, < 30605.9, 25118.7, 4128.22 + 68.0 	>, < 0, -86.6508 + 90.0, 0 >, 		SOLID_VPHYSICS, 15000 )
	CreatePropDynamic( RELAY_ROCK_FIX_MODEL, < 30606, 25470.6, 4136.22 + 68.0	 	>, < 0, -85.2053 + 90.0, 0 >, 		SOLID_VPHYSICS, 15000 )
	CreatePropDynamic( RELAY_ROCK_FIX_MODEL, < 30606, 25782.6, 4128.22 + 68.0	 	>, < 0, -85.2053 + 90.0, 0 >, 		SOLID_VPHYSICS, 15000 )
	CreatePropDynamic( RELAY_ROCK_FIX_MODEL, < 30598, 26126.8, 4136.22 + 68.0	    >, < 0, -89.5552 + 90.0, 0 >, 		SOLID_VPHYSICS, 15000 )
	CreatePropDynamic( RELAY_ROCK_FIX_MODEL, < 30598, 26398.8, 4128.22 + 68.0	    >, < 0, -89.5552 + 90.0, 0 >, 		SOLID_VPHYSICS, 15000 )
	CreatePropDynamic( RELAY_ROCK_FIX_MODEL, < 30598, 26638.8, 4128.22 + 68.0	    >, < 0, -89.5552 + 90.0, 0 >, 		SOLID_VPHYSICS, 15000 )
	CreatePropDynamic( RELAY_ROCK_FIX_MODEL, < 30516.7, 26730, 4136.22 + 96.0	    >, < 0, 8.92695  + 90.0, 0 >, 		SOLID_VPHYSICS, 15000 )
}

bool function RelayRockFixEnabled()
{
	return GetCurrentPlaylistVarInt( "relay_rock_fix_enabled", 0 ) == 1
}

#if DEVELOPER

void function LeviathanTeleportBug()
{
	entity player = GetPlayerArray()[0]

	//setpos 6266.347656 -2719.270752 2004.225952;setang 11.569291 -117.904839 0.000000
	player.SetOrigin( < 6266.347656, -2719.270752, 2004.225952 >  )
	player.SetAngles( < 11.569291, -117.904839, 0 >  )

	wait 2.0
	entity leviathan = GetZone6Leviathan()
	leviathan.Anim_Play( "leviathan_kingscanyon_mu1_zone6_leg_lift"  )
	leviathan.SetCycle( 0.7  )
}

void function TestZone6LeviathanFootStomp()
{
	array<string> footStompAnims = [ "leviathan_kingscanyon_mu1_zone6_leg_lift", "leviathan_kingscanyon_mu1_zone6_stand" ]
	//array<string> footStompAnims = [ "leviathan_kingscanyon_mu1_zone6_leg_lift" ]
	//array<string> footStompAnims = [ "leviathan_kingscanyon_mu1_zone6_stand" ]
	string randomAnim
	entity leviathan = GetZone6Leviathan()
	entity player = GetPlayerArray()[0]

	player.EndSignal( "OnDeath"  )

	OnThreadEnd(
		function() : ( player ){
			printt( "Player 0 origin : " +  player.GetOrigin() + ", angles: " + player.GetAngles() )
		}
	)

	while( true  )
	{
		randomAnim = footStompAnims[  RandomInt( footStompAnims.len()  ) ]
		leviathan.Anim_Play( randomAnim  )
		leviathan.SetCycle( 0.5 )
		printt( "Zone6Leviathan playing anim: " + randomAnim  )

		wait 9.0
	}
}

void function TestZone9LeviathanFootStomp()
{
	array<string> footStompAnims = [ "leviathan_kingscanyon_mu1_zone9_leg_lift" ]
	string randomAnim
	entity leviathan = GetZone9Leviathan()
	entity player = GetPlayerArray()[0]

	player.EndSignal( "OnDeath"  )

	OnThreadEnd(
		function() : ( player  ){
			printt( "Player 0 origin : " +  player.GetOrigin() + ", angles: " + player.GetAngles()  )
		}
	)

	while( true  )
	{
		randomAnim = footStompAnims[  RandomInt( footStompAnims.len()  ) ]
		leviathan.Anim_Play( randomAnim  )
		leviathan.SetCycle( 0.4 )
		printt( "Zone9Leviathan playing anim: " + randomAnim  )


		wait 9.0
	}
}

void function TeleportPlayerZeroIntoLeviathanFoot()
{
	entity player = GetPlayerArray()[0]
	//player.SetOrigin( <6301.13184, -3037.07202, 2001.28308>  )
	//player.SetAngles( <0, 168.952301, 0>  )

	//player.SetOrigin( <5868.9082, -3584.77075, 2063.63037>  )
	//player.SetAngles( <0, -23.2103596, 0> )

	//player.SetOrigin( <5744.848633, -2810.721680, 2069.738525>  )
	//player.SetAngles( <0, -40, 0> )

	player.SetOrigin( < 5799.420898, -2810.140381, 2040.280151 > )
	player.SetAngles( <-81, -66, 0> )
}

void function RecreateLeviathanDeathTriggers()
{
	foreach( trigger in file.leviathansDeathTriggers )
		trigger.Destroy()

	file.leviathansDeathTriggers.clear()

	file.leviathan_zone_6 = GetEntByScriptName( "leviathan_zone_6" )
	file.leviathan_zone_9 = GetEntByScriptName( "leviathan_zone_9" )

	LeviathanStompDataStruct zone6LeftFrontFootStompDataStruct
	zone6LeftFrontFootStompDataStruct.radius = 410
	zone6LeftFrontFootStompDataStruct.cylinderAboveHeight = 70.0
	zone6LeftFrontFootStompDataStruct.cylinderBelowHeight = 450.0
	zone6LeftFrontFootStompDataStruct.offset = < 60, 30, 0>
	zone6LeftFrontFootStompDataStruct.staticTriggerRadiusReduction = 60.0

	LeviathanStompDataStruct zone6LeftFrontFootSupplemental
	zone6LeftFrontFootSupplemental.radius = 120
	zone6LeftFrontFootSupplemental.cylinderAboveHeight = 70.0
	zone6LeftFrontFootSupplemental.cylinderBelowHeight = 0.0
	zone6LeftFrontFootSupplemental.offset = < -50, -375, 0>

	LeviathanStompDataStruct zone6LeftFrontFootSupplemental2
	zone6LeftFrontFootSupplemental2.radius = 125
	zone6LeftFrontFootSupplemental2.cylinderAboveHeight = 70.0
	zone6LeftFrontFootSupplemental2.cylinderBelowHeight = 0.0
	zone6LeftFrontFootSupplemental2.offset = < -240, -250, 0>

	LeviathanStompDataStruct zone6LeftFrontFootSupplemental3
	zone6LeftFrontFootSupplemental3.radius = 165
	zone6LeftFrontFootSupplemental3.cylinderAboveHeight = 70.0
	zone6LeftFrontFootSupplemental3.cylinderBelowHeight = 0.0
	zone6LeftFrontFootSupplemental3.offset = < -100, 300, 0>

	LeviathanStompDataStruct zone6LeftFrontFootSupplemental4
	zone6LeftFrontFootSupplemental4.radius = 90
	zone6LeftFrontFootSupplemental4.cylinderAboveHeight = 70.0
	zone6LeftFrontFootSupplemental4.cylinderBelowHeight = 0.0
	zone6LeftFrontFootSupplemental4.offset = < 100, -345, 0>

	LeviathanStompDataStruct zone6LeftFrontFootSupplemental5
	zone6LeftFrontFootSupplemental5.radius = 50
	zone6LeftFrontFootSupplemental5.cylinderAboveHeight = 70.0
	zone6LeftFrontFootSupplemental5.cylinderBelowHeight = 0.0
	zone6LeftFrontFootSupplemental5.offset = < 50, -435, 0>


	LeviathanStompDataStruct zone6RightFrontFootStompDataStruct
	zone6RightFrontFootStompDataStruct.radius = 410
	zone6RightFrontFootStompDataStruct.cylinderAboveHeight = 70.0
	zone6RightFrontFootStompDataStruct.cylinderBelowHeight = 450.0
	zone6RightFrontFootStompDataStruct.offset = < 0, -50, 0>
	zone6RightFrontFootStompDataStruct.staticTriggerRadiusReduction = 40.0

	LeviathanStompDataStruct zone9LeftFrontFootStompDataStruct
	zone9LeftFrontFootStompDataStruct.radius = 390.0
	zone9LeftFrontFootStompDataStruct.cylinderAboveHeight = 70.0
	zone9LeftFrontFootStompDataStruct.cylinderBelowHeight = 450.0
	zone9LeftFrontFootStompDataStruct.offset = < 50, -30, 0>
	zone9LeftFrontFootStompDataStruct.staticTriggerRadiusReduction = 95.0

	LeviathanStompDataStruct zone9LeftFrontFootStompDataStructSupplemental
	zone9LeftFrontFootStompDataStructSupplemental.radius = 125.0
	zone9LeftFrontFootStompDataStructSupplemental.cylinderAboveHeight = 70.0
	zone9LeftFrontFootStompDataStructSupplemental.cylinderBelowHeight = 0
	zone9LeftFrontFootStompDataStructSupplemental.offset = < 250, 250, 0>

	LeviathanStompDataStruct zone9LeftFrontFootStompDataStructSupplemental2
	zone9LeftFrontFootStompDataStructSupplemental2.radius = 125.0
	zone9LeftFrontFootStompDataStructSupplemental2.cylinderAboveHeight = 70.0
	zone9LeftFrontFootStompDataStructSupplemental2.cylinderBelowHeight = 0
	zone9LeftFrontFootStompDataStructSupplemental2.offset = < 0, -250, 0>

	LeviathanStompDataStruct zone9LeftFrontFootStompDataStructSupplemental3
	zone9LeftFrontFootStompDataStructSupplemental3.radius = 125.0
	zone9LeftFrontFootStompDataStructSupplemental3.cylinderAboveHeight = 70.0
	zone9LeftFrontFootStompDataStructSupplemental3.cylinderBelowHeight = 0
	zone9LeftFrontFootStompDataStructSupplemental3.offset = < 350, 70, 0>

	LeviathanStompDataStruct zone9LeftFrontFootStompDataStructSupplemental4
	zone9LeftFrontFootStompDataStructSupplemental4.radius = 125.0
	zone9LeftFrontFootStompDataStructSupplemental4.cylinderAboveHeight = 70.0
	zone9LeftFrontFootStompDataStructSupplemental4.cylinderBelowHeight = 0
	zone9LeftFrontFootStompDataStructSupplemental4.offset = < -310, 90, 0>

	LeviathanStompDataStruct zone9LeftFrontFootStompDataStructSupplemental5
	zone9LeftFrontFootStompDataStructSupplemental5.radius = 100.0
	zone9LeftFrontFootStompDataStructSupplemental5.cylinderAboveHeight = 70.0
	zone9LeftFrontFootStompDataStructSupplemental5.cylinderBelowHeight = 0
	zone9LeftFrontFootStompDataStructSupplemental5.offset = < -350, -110, 0>




	if ( IsValid( file.leviathan_zone_6 ) )
	{
		//Init death triggers in feet for zone 6 leviathan
		entity frontleftFootTrigger = CreateDeathTriggersInsideLeviathanFeet( file.leviathan_zone_6, "FX_L_FOOT_A", zone6LeftFrontFootStompDataStruct )
		entity frontleftFootSupplementalTrigger = CreateDeathTriggersInsideLeviathanFeet( file.leviathan_zone_6, "FX_L_FOOT_A", zone6LeftFrontFootSupplemental )
		entity frontleftFootSupplementalTrigger2 = CreateDeathTriggersInsideLeviathanFeet( file.leviathan_zone_6, "FX_L_FOOT_A", zone6LeftFrontFootSupplemental2 )
		entity frontleftFootSupplementalTrigger3 = CreateDeathTriggersInsideLeviathanFeet( file.leviathan_zone_6, "FX_L_FOOT_A", zone6LeftFrontFootSupplemental3 )
		entity frontleftFootSupplementalTrigger4 = CreateDeathTriggersInsideLeviathanFeet( file.leviathan_zone_6, "FX_L_FOOT_A", zone6LeftFrontFootSupplemental4 )
		entity frontleftFootSupplementalTrigger5 = CreateDeathTriggersInsideLeviathanFeet( file.leviathan_zone_6, "FX_L_FOOT_A", zone6LeftFrontFootSupplemental5 )

		entity frontrightFootTrigger = CreateDeathTriggersInsideLeviathanFeet( file.leviathan_zone_6, "FX_R_FOOT_A" , zone6RightFrontFootStompDataStruct )
	}

	if ( IsValid( file.leviathan_zone_9 ) )
	{
		entity frontleftFootTrigger = CreateDeathTriggersInsideLeviathanFeet( file.leviathan_zone_9, "FX_L_FOOT_A", zone9LeftFrontFootStompDataStruct  )
		entity frontleftFootTriggerSupplemental = CreateDeathTriggersInsideLeviathanFeet( file.leviathan_zone_9, "FX_L_FOOT_A", zone9LeftFrontFootStompDataStructSupplemental )
		entity frontleftFootTriggerSupplemental2 = CreateDeathTriggersInsideLeviathanFeet( file.leviathan_zone_9, "FX_L_FOOT_A", zone9LeftFrontFootStompDataStructSupplemental2  )
		entity frontleftFootTriggerSupplemental3 = CreateDeathTriggersInsideLeviathanFeet( file.leviathan_zone_9, "FX_L_FOOT_A", zone9LeftFrontFootStompDataStructSupplemental3  )
		entity frontleftFootTriggerSupplemental4 = CreateDeathTriggersInsideLeviathanFeet( file.leviathan_zone_9, "FX_L_FOOT_A", zone9LeftFrontFootStompDataStructSupplemental4  )
		entity frontleftFootTriggerSupplemental5 = CreateDeathTriggersInsideLeviathanFeet( file.leviathan_zone_9, "FX_L_FOOT_A", zone9LeftFrontFootStompDataStructSupplemental5  )

	}




}
#endif // DEVELOPER
#endif // SERVER