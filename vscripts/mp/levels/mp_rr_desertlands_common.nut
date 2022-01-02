global function Desertlands_PreMapInit_Common
global function Desertlands_MapInit_Common
global function CodeCallback_PlayerEnterUpdraftTrigger
global function CodeCallback_PlayerLeaveUpdraftTrigger

#if SERVER

global function Desertlands_MU1_MapInit_Common
global function Desertlands_MU1_EntitiesLoaded_Common
global function Desertlands_MU1_UpdraftInit_Common
global function Desertlands_SetTrainEnabled
#endif


#if SERVER
//Copied from _jump_pads. This is being hacked for the geysers.
const float JUMP_PAD_PUSH_RADIUS = 256.0
const float JUMP_PAD_PUSH_PROJECTILE_RADIUS = 32.0//98.0
const float JUMP_PAD_PUSH_VELOCITY = 2000.0
const float JUMP_PAD_VIEW_PUNCH_SOFT = 25.0
const float JUMP_PAD_VIEW_PUNCH_HARD = 4.0
const float JUMP_PAD_VIEW_PUNCH_RAND = 4.0
const float JUMP_PAD_VIEW_PUNCH_SOFT_TITAN = 120.0
const float JUMP_PAD_VIEW_PUNCH_HARD_TITAN = 20.0
const float JUMP_PAD_VIEW_PUNCH_RAND_TITAN = 20.0
const TEAM_JUMPJET_DBL = $"P_team_jump_jet_ON_trails"
const ENEMY_JUMPJET_DBL = $"P_enemy_jump_jet_ON_trails"
const asset JUMP_PAD_MODEL = $"mdl/props/octane_jump_pad/octane_jump_pad.rmdl"

const float JUMP_PAD_ANGLE_LIMIT = 0.70
const float JUMP_PAD_ICON_HEIGHT_OFFSET = 48.0
const float JUMP_PAD_ACTIVATION_TIME = 0.5
const asset JUMP_PAD_LAUNCH_FX = $"P_grndpnd_launch"
const JUMP_PAD_DESTRUCTION = "jump_pad_destruction"

// Loot drones
const int NUM_LOOT_DRONES_TO_SPAWN = 12
const int NUM_LOOT_DRONES_WITH_VAULT_KEYS = 4
#endif

struct
{
	#if SERVER
	bool isTrainEnabled = true
	array<LootData> weapons
	array<LootData> items
	array<LootData> ordnance
	#endif
} file

void function Desertlands_PreMapInit_Common()
{
	//DesertlandsTrain_PreMapInit()
}

void function Desertlands_MapInit_Common()
{
	printt( "Desertlands_MapInit_Common" )

	MapZones_RegisterDataTable( $"datatable/map_zones/zones_mp_rr_desertlands_64k_x_64k.rpak" )

	FlagInit( "PlayConveyerStartFX", true )

	SetVictorySequencePlatformModel( $"mdl/rocks/desertlands_victory_platform.rmdl", < 0, 0, -10 >, < 0, 0, 0 > )

	#if SERVER
		//%if HAS_LOOT_DRONES && HAS_LOOT_ROLLERS
		InitLootDrones()
		InitLootRollers()
		//%endif

		AddCallback_EntitiesDidLoad( EntitiesDidLoad )

		SURVIVAL_SetPlaneHeight( 15250 )
		SURVIVAL_SetAirburstHeight( 2500 )
		SURVIVAL_SetMapCenter( <0, 0, 0> )
		//Survival_SetMapFloorZ( -8000 )

		//if ( file.isTrainEnabled )
		//	DesertlandsTrain_Precaches()

		AddSpawnCallback_ScriptName( "desertlands_train_mover_0", AddTrainToMinimap )
	#endif

	#if CLIENT
		Freefall_SetPlaneHeight( 15250 )
		Freefall_SetDisplaySeaHeightForLevel( -8961.0 )

		SetVictorySequenceLocation( <11092.6162, -20878.0684, 1561.52222>, <0, 267.894653, 0> )
		SetVictorySequenceSunSkyIntensity( 1.0, 0.5 )
		SetMinimapBackgroundTileImage( $"overviews/mp_rr_canyonlands_bg" )

		// RegisterMinimapPackage( "prop_script", eMinimapObject_prop_script.TRAIN, MINIMAP_OBJECT_RUI, MinimapPackage_Train, FULLMAP_OBJECT_RUI, FullmapPackage_Train )
	#endif
}

#if SERVER
void function EntitiesDidLoad()
{
	#if SERVER && DEV
	test_runmapchecks()
	#endif

	SpawnEditorProps()
	GeyserInit()
	Updrafts_Init()
	InitLootDronePaths()
	string currentPlaylist = GetCurrentPlaylistName()
	int keyCount = GetPlaylistVarInt( currentPlaylist, "loot_drones_vault_key_count", NUM_LOOT_DRONES_WITH_VAULT_KEYS )
	if ( file.isTrainEnabled )
		thread DesertlandsTrain_Init()

	FillLootTable()

	// //Granadas-Grenades
	SpawnGrenades(<19010,33300,-810>, <0, 0, 0>, 6, ["thermite", "frag", "arc"], 3)
	SpawnGrenades(<18882,29908,-810>,<0, -90, 0>, 6, ["thermite", "frag", "arc"], 3)
	SpawnGrenades(<15346,30084,-810>,<0, 90, 0>, 6, ["thermite", "frag", "arc"], 3)
	SpawnGrenades(<15346,33540,-810>,<0, 90, 0>, 6, ["thermite", "frag", "arc"], 3)

	SpawnGrenades(<12099, 6976,-4330>,<0, -90, 0>, 10, ["thermite", "frag", "arc"], 1)
	SpawnGrenades(<11238, 4238,-4283>,<0, -90, 0>, 10, ["thermite", "frag", "arc"], 1)
	SpawnGrenades(<8443, 4459, -4283>,<0, 0, 0>, 10, ["thermite", "frag", "arc"], 1)
	SpawnGrenades(<10293, 3890, -3948>,<0, -90, 0>, 10, ["thermite", "frag", "arc"], 1)


	// //Spawn de armas
	SpawnWeapon( <17250,32500,2220>, <0, -90, 0>, 60, 2, 1)
	SpawnWeapon( <17500,32500,2220>, <0, -90, 0>, 60, 0, 1)
	SpawnWeapon( <17750,32500,2220>, <0, -90, 0>, 60, 1, 1)
	// // ------------------------------------------------------

}
#endif

#if SERVER
void function Desertlands_SetTrainEnabled( bool enabled )
{
	file.isTrainEnabled = enabled
}
#endif

#if SERVER
void function Desertlands_MU1_MapInit_Common()
{
	AddSpawnCallback_ScriptName( "conveyor_rotator_mover", OnSpawnConveyorRotatorMover )

	Desertlands_MapInit_Common()
	PrecacheParticleSystem( JUMP_PAD_LAUNCH_FX )

	//SURVIVAL_SetDefaultLootZone( "zone_medium" )

	//LaserMesh_Init()
	FlagSet( "DisableDropships" )

	AddDamageCallbackSourceID( eDamageSourceId.burn, OnBurnDamage )

	svGlobal.evacEnabled = false //Need to disable this on a map level if it doesn't support it at all
}

void function OnBurnDamage( entity player, var damageInfo )
{
	if ( !player.IsPlayer() )
		return

	// sky laser shouldn't hurt players in plane
	if ( player.GetPlayerNetBool( "playerInPlane" ) )
	{
		DamageInfo_SetDamage( damageInfo, 0 )
	}
}

void function OnSpawnConveyorRotatorMover( entity mover )
{
	thread ConveyorRotatorMoverThink( mover )
}

void function ConveyorRotatorMoverThink( entity mover )
{
	mover.EndSignal( "OnDestroy" )

	entity rotator = GetEntByScriptName( "conveyor_rotator" )
	entity startNode
	entity endNode

	array<entity> links = rotator.GetLinkEntArray()
	foreach ( l in links )
	{
		if ( l.GetValueForKey( "script_noteworthy" ) == "end" )
			endNode = l
		if ( l.GetValueForKey( "script_noteworthy" ) == "start" )
			startNode = l
	}
	float angle1 = VectorToAngles( startNode.GetOrigin() - rotator.GetOrigin() ).y
	float angle2 = VectorToAngles( endNode.GetOrigin() - rotator.GetOrigin() ).y

	float angleDiff = angle1 - angle2
	angleDiff = (angleDiff + 180) % 360 - 180

	float rotatorSpeed = float( rotator.GetValueForKey( "rotate_forever_speed" ) )
	float waitTime     = fabs( angleDiff ) / rotatorSpeed

	Assert( IsValid( endNode ) )

	while ( 1 )
	{
		mover.WaitSignal( "ReachedPathEnd" )

		mover.SetParent( rotator, "", true )

		wait waitTime

		mover.ClearParent()
		mover.SetOrigin( endNode.GetOrigin() )
		mover.SetAngles( endNode.GetAngles() )

		thread MoverThink( mover, [ endNode ] )
	}
}

void function Desertlands_MU1_UpdraftInit_Common( entity player )
{
	//ApplyUpdraftModUntilTouchingGround( player )
	thread PlayerSkydiveFromCurrentPosition( player )
	thread BurnPlayerOverTime( player )
}

void function Desertlands_MU1_EntitiesLoaded_Common()
{
	GeyserInit()
	Updrafts_Init()
}

//Geyster stuff
void function GeyserInit()
{
	array<entity> geyserTargets = GetEntArrayByScriptName( "geyser_jump" )
	foreach ( target in geyserTargets )
	{
		thread GeyersJumpTriggerArea( target )
		//target.Destroy()
	}
}

void function GeyersJumpTriggerArea( entity jumpPad )
{
	Assert ( IsNewThread(), "Must be threaded off" )
	jumpPad.EndSignal( "OnDestroy" )

	vector origin = OriginToGround( jumpPad.GetOrigin() )
	vector angles = jumpPad.GetAngles()

	entity trigger = CreateEntity( "trigger_cylinder_heavy" )
	SetTargetName( trigger, "geyser_trigger" )
	trigger.SetOwner( jumpPad )
	trigger.SetRadius( JUMP_PAD_PUSH_RADIUS )
	trigger.SetAboveHeight( 32 )
	trigger.SetBelowHeight( 16 ) //need this because the player or jump pad can sink into the ground a tiny bit and we check player feet not half height
	trigger.SetOrigin( origin )
	trigger.SetAngles( angles )
	trigger.SetTriggerType( TT_JUMP_PAD )
	trigger.SetLaunchScaleValues( JUMP_PAD_PUSH_VELOCITY, 1.25 )
	trigger.SetViewPunchValues( JUMP_PAD_VIEW_PUNCH_SOFT, JUMP_PAD_VIEW_PUNCH_HARD, JUMP_PAD_VIEW_PUNCH_RAND )
	trigger.SetLaunchDir( <0.0, 0.0, 1.0> )
	trigger.UsePointCollision()
	trigger.kv.triggerFilterNonCharacter = "0"
	DispatchSpawn( trigger )
	trigger.SetEnterCallback( Geyser_OnJumpPadAreaEnter )

	// entity traceBlocker = CreateTraceBlockerVolume( trigger.GetOrigin(), 24.0, true, CONTENTS_BLOCK_PING | CONTENTS_NOGRAPPLE, TEAM_MILITIA, GEYSER_PING_SCRIPT_NAME )
	// traceBlocker.SetBox( <-192, -192, -16>, <192, 192, 3000> )

	//DebugDrawCylinder( origin, < -90, 0, 0 >, JUMP_PAD_PUSH_RADIUS, trigger.GetAboveHeight(), 255, 0, 255, true, 9999.9 )
	//DebugDrawCylinder( origin, < -90, 0, 0 >, JUMP_PAD_PUSH_RADIUS, -trigger.GetBelowHeight(), 255, 0, 255, true, 9999.9 )

	OnThreadEnd(
		function() : ( trigger )
		{
			trigger.Destroy()
		} )

	WaitForever()
}


void function Geyser_OnJumpPadAreaEnter( entity trigger, entity ent )
{
	Geyser_JumpPadPushEnt( trigger, ent, trigger.GetOrigin(), trigger.GetAngles() )
}


void function Geyser_JumpPadPushEnt( entity trigger, entity ent, vector origin, vector angles )
{
	if ( Geyser_JumpPad_ShouldPushPlayerOrNPC( ent ) )
	{
		if ( ent.IsPlayer() )
		{
			entity jumpPad = trigger.GetOwner()
			if ( IsValid( jumpPad ) )
			{
				int fxId = GetParticleSystemIndex( JUMP_PAD_LAUNCH_FX )
				StartParticleEffectOnEntity( jumpPad, fxId, FX_PATTACH_ABSORIGIN_FOLLOW, 0 )
			}
			thread Geyser_JumpJetsWhileAirborne( ent )
		}
		else
		{
			EmitSoundOnEntity( ent, "JumpPad_LaunchPlayer_3p" )
			EmitSoundOnEntity( ent, "JumpPad_AirborneMvmt_3p" )
		}
	}
}


void function Geyser_JumpJetsWhileAirborne( entity player )
{
	if ( !IsPilot( player ) )
		return
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )
	player.Signal( "JumpPadStart" )
	player.EndSignal( "JumpPadStart" )
	player.EnableSlowMo()
	player.DisableMantle()

	EmitSoundOnEntityExceptToPlayer( player, player, "JumpPad_LaunchPlayer_3p" )
	EmitSoundOnEntityExceptToPlayer( player, player, "JumpPad_AirborneMvmt_3p" )

	array<entity> jumpJetFXs
	array<string> attachments = [ "vent_left", "vent_right" ]
	int team                  = player.GetTeam()
	foreach ( attachment in attachments )
	{
		int friendlyID    = GetParticleSystemIndex( TEAM_JUMPJET_DBL )
		entity friendlyFX = StartParticleEffectOnEntity_ReturnEntity( player, friendlyID, FX_PATTACH_POINT_FOLLOW, player.LookupAttachment( attachment ) )
		friendlyFX.SetOwner( player )
		SetTeam( friendlyFX, team )
		friendlyFX.kv.VisibilityFlags = ENTITY_VISIBLE_TO_FRIENDLY
		jumpJetFXs.append( friendlyFX )

		int enemyID    = GetParticleSystemIndex( ENEMY_JUMPJET_DBL )
		entity enemyFX = StartParticleEffectOnEntity_ReturnEntity( player, enemyID, FX_PATTACH_POINT_FOLLOW, player.LookupAttachment( attachment ) )
		SetTeam( enemyFX, team )
		enemyFX.kv.VisibilityFlags = ENTITY_VISIBLE_TO_ENEMY
		jumpJetFXs.append( enemyFX )
	}

	OnThreadEnd(
		function() : ( jumpJetFXs, player )
		{
			foreach ( fx in jumpJetFXs )
			{
				if ( IsValid( fx ) )
					fx.Destroy()
			}

			if ( IsValid( player ) )
			{
				player.DisableSlowMo()
				player.EnableMantle()
				StopSoundOnEntity( player, "JumpPad_AirborneMvmt_3p" )
			}
		}
	)

	WaitFrame()

	wait 0.1
	//thread PlayerSkydiveFromCurrentPosition( player )
	while( !player.IsOnGround() )
	{
		WaitFrame()
	}

}


bool function Geyser_JumpPad_ShouldPushPlayerOrNPC( entity target )
{
	if ( target.IsTitan() )
		return false

	if ( IsSuperSpectre( target ) )
		return false

	if ( IsTurret( target ) )
		return false

	if ( IsDropship( target ) )
		return false

	return true
}


///////////////////////
///////////////////////
//// Updrafts

const string UPDRAFT_TRIGGER_SCRIPT_NAME = "skydive_dust_devil"
void function Updrafts_Init()
{
	array<entity> triggers = GetEntArrayByScriptName( UPDRAFT_TRIGGER_SCRIPT_NAME )
	foreach ( entity trigger in triggers )
	{
		if ( trigger.GetClassName() != "trigger_updraft" )
		{
			entity newTrigger = CreateEntity( "trigger_updraft" )
			newTrigger.SetOrigin( trigger.GetOrigin() )
			newTrigger.SetAngles( trigger.GetAngles() )
			newTrigger.SetModel( trigger.GetModelName() )
			newTrigger.SetScriptName( UPDRAFT_TRIGGER_SCRIPT_NAME )
			newTrigger.kv.triggerFilterTeamBeast = 1
			newTrigger.kv.triggerFilterTeamNeutral = 1
			newTrigger.kv.triggerFilterTeamOther = 1
			newTrigger.kv.triggerFilterUseNew = 1
			DispatchSpawn( newTrigger )
			trigger.Destroy()
		}
	}
}

void function BurnPlayerOverTime( entity player )
{
	Assert( IsValid( player ) )
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDeath" )
	player.EndSignal( "DeathTotem_PreRecallPlayer" )
	for ( int i = 0; i < 8; ++i )
	{
		//if ( !player.Player_IsInsideUpdraftTrigger() )
		//	break

		if ( !player.IsPhaseShifted() )
		{
			player.TakeDamage( 5, null, null, { damageSourceId = eDamageSourceId.burn, damageType = DMG_BURN } )
		}

		wait 0.5
	}
}
#endif

void function CodeCallback_PlayerEnterUpdraftTrigger( entity trigger, entity player )
{
	float entZ = player.GetOrigin().z
	//OnEnterUpdraftTrigger( trigger, player, max( -5750.0, entZ - 400.0 ) )
}

void function CodeCallback_PlayerLeaveUpdraftTrigger( entity trigger, entity player )
{
	//OnLeaveUpdraftTrigger( trigger, player )
}

#if SERVER
void function AddTrainToMinimap( entity mover )
{
	entity minimapObj = CreatePropScript( $"mdl/dev/empty_model.rmdl", mover.GetOrigin() )
	minimapObj.Minimap_SetCustomState( eMinimapObject_prop_script.TRAIN )
	minimapObj.SetParent( mover )
	SetTargetName( minimapObj, "trainIcon" )
	foreach ( player in GetPlayerArray() )
	{
		minimapObj.Minimap_AlwaysShow( 0, player )
	}
}
#endif

#if CLIENT
void function MinimapPackage_Train( entity ent, var rui )
{
	#if DEV
		printt( "Adding 'rui/hud/gametype_icons/sur_train_minimap' icon to minimap" )
	#endif
	RuiSetImage( rui, "defaultIcon", $"rui/hud/gametype_icons/sur_train_minimap" )
	RuiSetImage( rui, "clampedDefaultIcon", $"" )
	RuiSetBool( rui, "useTeamColor", false )
}

void function FullmapPackage_Train( entity ent, var rui )
{
	MinimapPackage_Train( ent, rui )
	RuiSetFloat2( rui, "iconScale", <1.5,1.5,0.0> )
	RuiSetFloat3( rui, "iconColor", <0.5,0.5,0.5> )
}
#endif

#if SERVER
entity function SpawnBigTrainingTarget(vector pos, vector ang, void functionref( entity, var ) onDamaged )
{
	entity target = CreateEntity( "prop_dynamic" )
	target.kv.solid = 6
	target.SetValueForModelKey( $"mdl/barriers/shooting_range_target_02.rmdl" )
	target.kv.SpawnAsPhysicsMover = 0
	target.SetOrigin( pos )
	target.SetAngles( ang )
	DispatchSpawn( target )
	target.SetDamageNotifications( true )

    AddEntityCallback_OnDamaged(target, onDamaged)
	return target
}
#endif

                           // 888                                .d888                            888    d8b
                           // 888                               d88P"                             888    Y8P
                           // 888                               888                               888
 // .d8888b 888  888 .d8888b  888888 .d88b.  88888b.d88b.       888888 888  888 88888b.   .d8888b 888888 888  .d88b.  88888b.  .d8888b
// d88P"    888  888 88K      888   d88""88b 888 "888 "88b      888    888  888 888 "88b d88P"    888    888 d88""88b 888 "88b 88K
// 888      888  888 "Y8888b. 888   888  888 888  888  888      888    888  888 888  888 888      888    888 888  888 888  888 "Y8888b.
// Y88b.    Y88b 888      X88 Y88b. Y88..88P 888  888  888      888    Y88b 888 888  888 Y88b.    Y88b.  888 Y88..88P 888  888      X88
 // "Y8888P  "Y88888  88888P'  "Y888 "Y88P"  888  888  888      888     "Y88888 888  888  "Y8888P  "Y888 888  "Y88P"  888  888  88888P'

#if SERVER
void function RespawnItem(entity item, string ref, int amount = 1, int wait_time=6)
//By Retículo Endoplasmático#5955 CaféDeColombiaFPS. Tomado del firing range.

{
	vector pos = item.GetOrigin()
	vector angles = item.GetAngles()
	item.WaitSignal("OnItemPickup")

	wait wait_time
	StartParticleEffectInWorld( GetParticleSystemIndex( $"P_impact_shieldbreaker_sparks" ), pos, angles )
	thread RespawnItem(SpawnGenericLoot(ref, pos, angles, amount), ref, amount)
}
#endif

#if SERVER
void function FillLootTable()
//By Retículo Endoplasmático#5955 CaféDeColombiaFPS. Adaptado del firing range.
{
	file.ordnance.extend(SURVIVAL_Loot_GetByType( eLootType.ORDNANCE ))
	file.weapons.extend(SURVIVAL_Loot_GetByType( eLootType.MAINWEAPON ))
}
#endif

#if SERVER
void function SpawnGrenades(vector pos, vector ang, int wait_time = 6, array which_nades = ["thermite", "frag", "arc"], int num_rows = 1)
//By michae\l/#1125 & Retículo Endoplasmático#5955
{
    vector posfixed = pos
	int i;
    for (i = 0; i < num_rows; i++)
    {
        if(i != 0) {posfixed += <30, 0 - which_nades.len() * 30, 0>}
            foreach(nade in which_nades)
        {
            LootData item
			posfixed = posfixed + <0, 30, 0>
            if(nade == "thermite") {
                item = file.ordnance[0]
            }
            else if(nade == "frag") {
                item = file.ordnance[1]
			}
            else if(nade == "arc") {
                item = file.ordnance[2]
        }
		entity loot = SpawnGenericLoot(item.ref, posfixed, ang, 1)
		thread RespawnItem(loot, item.ref, 1, wait_time)
	}}}
#endif

#if SERVER
void function SpawnWeapon(vector pos, vector ang, int wait_time=5, int weapon=0, int qt=1)
//By Retículo Endoplasmático#5955 CaféDeColombiaFPS.
{
	vector posfixed = pos
	int i;
	for (i = 0; i < qt; i++)
		{
	LootData item
	posfixed = posfixed + <30, 0, 0>
	item = file.weapons[weapon]
	entity loot = SpawnGenericLoot(item.ref, posfixed, ang, 1)
    thread RespawnItem(loot,item.ref, 1, wait_time)
}}

entity function CreateEditorProp(asset a, vector pos, vector ang, bool mantle = false, float fade = 2000, int realm = -1)
{
    entity e = CreatePropDynamic(a,pos,ang,SOLID_VPHYSICS,fade)
    e.kv.fadedist = fade
    if(mantle) e.AllowMantle()

    if (realm > -1) {
        e.RemoveFromAllRealms()
        e.AddToRealm(realm)
    }

    string positionSerialized = pos.x.tostring() + "," + pos.y.tostring() + "," + pos.z.tostring()
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
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19584,1536,6528>, <0,0,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19584,1792,6528>, <0,0,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19328,1792,6528>, <0,0,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19328,1536,6528>, <0,0,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19072,1536,6528>, <0,0,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19072,1792,6528>, <0,0,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19072,2048,6528>, <0,0,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19328,2048,6528>, <0,0,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19584,2048,6528>, <0,0,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19840,2048,6528>, <0,0,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19840,1792,6528>, <0,90,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19840,1536,6528>, <0,90,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19840,1280,6528>, <0,180,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19584,1280,6528>, <0,180,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19328,1280,6528>, <0,180,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19072,1280,6528>, <0,180,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19071.9,2176.93,6527.65>, <0,180,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19328,2176.94,6527.65>, <0,180,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19584,2176.94,6527.65>, <0,180,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19840,2176.94,6527.65>, <0,180,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19969,2048.01,6527.69>, <0,-90,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19969,1792.01,6527.69>, <0,-90,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19969,1535.96,6527.69>, <0,-90,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19969,1279.98,6527.69>, <0,-90,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19840,1151.01,6527.85>, <0,0,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19584,1151.01,6527.85>, <0,0,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19328,1151.01,6527.85>, <0,0,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-18943,1280.13,6527.82>, <0,90,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-18943,2048.02,6527.83>, <0,90,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-18943,1280.09,6783.93>, <0,90,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19071.8,1151.02,6783.94>, <0,0,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19328,1151.01,6783.9>, <0,0,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19584,1151.01,6783.9>, <0,0,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19840,1151.01,6783.9>, <0,0,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19071.8,1151.06,6527.71>, <0,0,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19969,1279.83,6783.92>, <0,-90,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19969,1536.05,6783.89>, <0,-90,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19969,1791.97,6783.89>, <0,-90,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19969,2048.07,6783.87>, <0,-90,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19840,2177,6783.92>, <0,180,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19584,2177,6783.91>, <0,180,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19328,2177,6783.91>, <0,180,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19072,2176.99,6783.9>, <0,180,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-18943,2048.02,6783.89>, <0,90,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-18943,1792.02,6783.89>, <0,90,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-18943,1536.02,6783.89>, <0,90,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19072,2048,7040>, <0,180,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19328,2048,7040>, <0,180,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19584,2048,7040>, <0,180,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19840,2048,7040>, <0,180,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19840,1792,7040>, <0,-90,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19840,1536,7040>, <0,-90,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19840,1280,7040>, <0,-90,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19584,1280,7040>, <0,0,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19328,1280,7040>, <0,0,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19072,1280,7040>, <0,0,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19072,1536,7040>, <0,90,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19072,1792,7040>, <0,90,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19328,1792,7040>, <0,90,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19328,1536,7040>, <0,90,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19584,1792,7040>, <0,180,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19584,1536,7040>, <0,90,0>, true, 8000, -1 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-18816,1792,6528>, <0,180,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-18816,1536,6528>, <0,180,0>, true, 8000, -1 )

	CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-18560,1792,6528>, <0,180,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-18560,1536,6528>, <0,180,0>, true, 8000, -1 )

	CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-18304,1792,6528>, <0,180,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-18304,1536,6528>, <0,180,0>, true, 8000, -1 )

    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-18816,1536,6784>, <0,-90,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-18816,1792,6784>, <0,-90,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-18816.2,1408.97,6528.16>, <0,180,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-18816.1,1919.02,6527.81>, <0,0,0>, true, 8000, -1 )

    CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_01.rmdl", <-18943.6,1472.77,6527.47>, <0,180,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_01.rmdl", <-18943.8,1664.92,6527.67>, <0,180,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/barriers/concrete/concrete_barrier_01.rmdl", <-18943.9,1856.98,6527.82>, <0,180,0>, true, 8000, -1 )
    //CreateEditorProp( $"mdl/props/global_access_panel_button/global_access_panel_button_console_w_stand.rmdl", <-18760.9,1503.82,6543.63>, <0,-90,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19072,2048,6784>, <0,90,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19072,1792,6784>, <0,90,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19072,1536,6784>, <0,90,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19072,1280,6784>, <0,90,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19328,1280,6784>, <0,0,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19584,1280,6784>, <0,0,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19840,1280,6784>, <0,0,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19840,1536,6784>, <0,-90,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19840,1792,6784>, <0,-90,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19840,2048,6784>, <0,-90,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19584,2048,6784>, <0,180,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19328,2048,6784>, <0,180,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/ola/sewer_railing_01_corner_in.rmdl", <-19199.4,1407.26,6783.83>, <0,0,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/ola/sewer_railing_01_corner_in.rmdl", <-19713,1407.69,6783.97>, <0,-90,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/ola/sewer_railing_01_corner_in.rmdl", <-19712.4,1920.89,6783.83>, <0,180,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/ola/sewer_railing_01_corner_in.rmdl", <-19199.3,1920.65,6783.85>, <0,90,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/ola/sewer_railing_01_128.rmdl", <-19199.5,1791.2,6783.69>, <0,0,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/ola/sewer_railing_01_128.rmdl", <-19199.4,1663.27,6783.7>, <0,0,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/ola/sewer_railing_01_128.rmdl", <-19199.4,1535.22,6783.83>, <0,0,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/ola/sewer_railing_01_128.rmdl", <-19328.9,1407.52,6783.89>, <0,-90,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/ola/sewer_railing_01_128.rmdl", <-19456.9,1407.57,6783.86>, <0,-90,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/ola/sewer_railing_01_128.rmdl", <-19584.9,1407.58,6783.93>, <0,-90,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/ola/sewer_railing_01_128.rmdl", <-19712.5,1536.86,6783.96>, <0,180,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/ola/sewer_railing_01_128.rmdl", <-19712.4,1664.92,6783.82>, <0,180,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/ola/sewer_railing_01_128.rmdl", <-19712.3,1792.95,6783.85>, <0,180,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/ola/sewer_railing_01_128.rmdl", <-19583.1,1920.39,6783.8>, <0,90,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/ola/sewer_railing_01_128.rmdl", <-19455.1,1920.41,6783.87>, <0,90,0>, true, 8000, -1 )
    CreateEditorProp( $"mdl/ola/sewer_railing_01_128.rmdl", <-19327.2,1920.53,6783.89>, <0,90,0>, true, 8000, -1 )

}
#endif
