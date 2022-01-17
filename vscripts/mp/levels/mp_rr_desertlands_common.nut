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
	if(!GetCurrentPlaylistVarBool("flowstatePROPHUNT", false )){

	// //Granadas-Grenades
	SpawnGrenades(<19010,33300,-810>, <0, 0, 0>, 6, ["thermite", "frag", "arc"], 3)
	SpawnGrenades(<18882,29908,-810>,<0, -90, 0>, 6, ["thermite", "frag", "arc"], 3)
	SpawnGrenades(<15346,30084,-810>,<0, 90, 0>, 6, ["thermite", "frag", "arc"], 3)
	SpawnGrenades(<15346,33540,-810>,<0, 90, 0>, 6, ["thermite", "frag", "arc"], 3)

	SpawnGrenades(<12099, 6976,-4330>,<0, -90, 0>, 10, ["thermite", "frag", "arc"], 1)
	SpawnGrenades(<11238, 4238,-4283>,<0, -90, 0>, 10, ["thermite", "frag", "arc"], 1)
	SpawnGrenades(<8443, 4459, -4283>,<0, 0, 0>, 10, ["thermite", "frag", "arc"], 1)
	SpawnGrenades(<10293, 3890, -3948>,<0, -90, 0>, 10, ["thermite", "frag", "arc"], 1)

	CreateWeaponRackSkillTrainer(<17250,32500,2220>, <0,-90,0>, "mp_weapon_sniper")
	CreateWeaponRackSkillTrainer(<17500,32500,2220>, <0,-90,0>, "mp_weapon_mastiff")
	CreateWeaponRackSkillTrainer(<17750,32500,2220>, <0,-90,0>, "mp_weapon_lstar")}
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
entity function CreateEditorPropLobby(asset a, vector pos, vector ang, bool mantle = false, float fade = 2000, int realm = -1)
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
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19392,1472,6208>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19392,1728,6208>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19136,1472,6208>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19136,1728,6208>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19392.2,1343.06,6207.72>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19136.1,1343.04,6207.72>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19648,1472,6208>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19648,1728,6208>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19904,1728,6208>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19904,1472,6208>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19904,1984,6208>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19904,2240,6208>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19648,2240,6208>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19392,2240,6208>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19136,1984,6208>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19392,1984,6208>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19648,1984,6208>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19904,2496,6208>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19904,2752,6208>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19648,2752,6208>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19648,2496,6208>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19392,2496,6208>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19136,2496,6208>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19392,2752,6208>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19136,2752,6208>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-20160,2240,6208>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-20160,1984,6208>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-20416,1984,6208>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-20416,2240,6208>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-20031.1,1727.99,6207.54>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-20031.1,1471.99,6207.57>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19904,1344.94,6207.67>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19648,1344.95,6207.68>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-20033,2496.07,6207.78>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-20033,2752.03,6207.79>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19904.4,2880.72,6207.42>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19648,2880.8,6207.4>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19392,2880.8,6207.39>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19136,2880.8,6207.4>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-20031,1727.86,6463.97>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-20031,1983.95,6464>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-20031,2239.98,6464>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-20031,2495.98,6464>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-20031,2751.98,6464>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-20031,1471.98,6464>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19904,1345,6464>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19648,1345,6464.01>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19392,1345,6464.01>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19136,1345,6464>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19008.7,1472,6207.33>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19008.7,1728,6207.33>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19008.7,2496.01,6207.33>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19008.7,2752.05,6207.34>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19009,2752.23,6464.06>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19009,2496.03,6464.07>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19009,2240.03,6464.07>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19009,1984.03,6464.07>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19009,1728.03,6464.04>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19009,1472.03,6464.04>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19136,2879,6464.02>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19392,2879,6464.02>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19648,2879,6464.02>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", <-19904,2879,6464.02>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19136,1472,6464>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19392,1472,6464>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19648,1472,6464>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19904,1472,6464>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19904,1728,6464>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19904,1984,6464>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19904,2240,6464>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19904,2496,6464>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19904,2752,6464>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19648,2752,6464>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19392,2752,6464>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19136,2752,6464>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19136,1728,6464>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19136,1984,6464>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19136,2240,6464>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19136,2496,6464>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/ola/sewer_railing_01_corner_out.rmdl", <-20544.1,1855.03,6207.75>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/ola/sewer_railing_01_128.rmdl", <-20415.3,1855.38,6207.75>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/ola/sewer_railing_01_128.rmdl", <-20287.1,1855.6,6207.72>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/ola/sewer_railing_01_128.rmdl", <-20159.1,1855.73,6207.78>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/ola/sewer_railing_01_128.rmdl", <-20160.8,2368.17,6207.37>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/ola/sewer_railing_01_128.rmdl", <-20288.8,2368.2,6207.5>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/ola/sewer_railing_01_128.rmdl", <-20416.9,2368.12,6207.61>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/ola/sewer_railing_01_corner_in.rmdl", <-20544.1,2368.33,6207.06>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/ola/sewer_railing_01_corner_in.rmdl", <-19263.3,2624.63,6463.58>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/ola/sewer_railing_01_corner_in.rmdl", <-19263.5,1599.32,6463.49>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/ola/sewer_railing_01_corner_in.rmdl", <-19776.9,1599.7,6463.76>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/ola/sewer_railing_01_corner_in.rmdl", <-19776.4,2624.9,6463.91>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/ola/sewer_railing_01_128.rmdl", <-19647.2,2624.61,6463.81>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/ola/sewer_railing_01_128.rmdl", <-19519.2,2624.59,6463.86>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/ola/sewer_railing_01_128.rmdl", <-19391.2,2624.65,6463.95>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/ola/sewer_railing_01_128.rmdl", <-19263.3,2495.27,6464.01>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/ola/sewer_railing_01_128.rmdl", <-19263.4,2367.18,6464.01>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/ola/sewer_railing_01_128.rmdl", <-19263.4,2239.21,6464.03>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/ola/sewer_railing_01_128.rmdl", <-19263.3,2111.24,6464.04>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/ola/sewer_railing_01_128.rmdl", <-19263.3,1983.26,6464.03>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/ola/sewer_railing_01_128.rmdl", <-19263.3,1855.28,6464.03>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/ola/sewer_railing_01_128.rmdl", <-19263.3,1727.28,6464.03>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/ola/sewer_railing_01_128.rmdl", <-19392.7,1599.34,6464>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/ola/sewer_railing_01_128.rmdl", <-19520.7,1599.31,6464.01>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/ola/sewer_railing_01_128.rmdl", <-19648.8,1599.35,6464.01>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/ola/sewer_railing_01_128.rmdl", <-19776.7,1728.73,6463.91>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/ola/sewer_railing_01_128.rmdl", <-19776.5,1856.84,6463.96>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/ola/sewer_railing_01_128.rmdl", <-19776.6,1984.8,6463.98>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/ola/sewer_railing_01_128.rmdl", <-19776.7,2112.71,6464>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/ola/sewer_railing_01_128.rmdl", <-19776.7,2240.71,6464>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/ola/sewer_railing_01_128.rmdl", <-19776.7,2368.75,6464.01>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/ola/sewer_railing_01_128.rmdl", <-19776.7,2496.72,6464.03>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-18880,2240,6208>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-18880,1984,6208>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-18880,1728,6208>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-18624,1728,6208>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-18624,1984,6208>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-18624,2240,6208>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-18624,2496,6208>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-18880,2496,6208>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-18368,2496,6208>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-18368,2240,6208>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-18368,1984,6208>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-18368,1728,6208>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/containers/slumcity_oxygen_tank_red.rmdl", <-20004.9,1831.88,6223.61>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/containers/slumcity_oxygen_tank_red.rmdl", <-20016.9,1804.14,6223.72>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/containers/slumcity_oxygen_tank_red.rmdl", <-19988.9,1812.22,6223.58>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/containers/slumcity_oxygen_tank_red.rmdl", <-19139.4,2860.82,6224.02>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/containers/slumcity_oxygen_tank_red.rmdl", <-19167.6,2872.9,6224.03>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/containers/slumcity_oxygen_tank_red.rmdl", <-19159.5,2848.86,6223.99>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/containers/box_shrinkwrapped.rmdl", <-19071.2,1411.41,6223.84>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/containers/box_shrinkwrapped.rmdl", <-19159.4,1399.24,6223.82>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/containers/box_shrinkwrapped.rmdl", <-19064.1,1515.01,6223.9>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/containers/box_shrinkwrapped.rmdl", <-19135.8,1387.19,6299.45>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/containers/box_shrinkwrapped.rmdl", <-19063.2,1479.79,6299.39>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/containers/box_shrinkwrapped.rmdl", <-19163.4,1487.26,6223.69>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/industrial/hazmat_suit_hanging.rmdl", <-19375.2,1355.44,6280.31>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/industrial/hazmat_suit_hanging.rmdl", <-19411.3,1351.34,6280.3>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/industrial/hazmat_suit_hanging.rmdl", <-19451.3,1351.34,6280.32>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/industrial/cafe_coffe_machine_dirty.rmdl", <-20025,1720.02,6256.04>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/industrial/tool_chest.rmdl", <-19027.7,2423.08,6223.79>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/industrial/tool_chest_double.rmdl", <-19027.4,2463.23,6223.81>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/signs/signage_plates_metal/sign_plate_a.rmdl", <-20024.7,2391.26,6332.05>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/signs/signage_plates_metal/sign_plate_a.rmdl", <-20024.6,1831.21,6331.85>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/utilities/power_gen1.rmdl", <-18940.5,2568.71,6223.51>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/utilities/wire_ground_coils_03.rmdl", <-18964.8,2472.43,6223.58>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/utilities/wires_ground_coils_01.rmdl", <-18912.6,2416.07,6223.21>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/utilities/wires_ground_coils_01.rmdl", <-18852,2528.88,6223.53>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/utilities/wire_ground_coils_03.rmdl", <-18908.5,2472.55,6223.35>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/utilities/wall_Waterpipe.rmdl", <-19000.6,2399.29,6259.72>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/vehicles_r5/land_med/msc_freight_tortus_mod/veh_land_msc_freight_tortus_mod_wheeled_v1_static.rmdl", <-19619,2756.16,6223.96>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/angel_city/vending_machine.rmdl", <-19755.2,1367.54,6223.6>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/angel_city/recyclebin_large_01.rmdl", <-19799.3,1367.43,6223.5>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/angel_city/ground_pile_trash_02.rmdl", <-19879.7,1395.47,6223.19>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/angel_city/ground_pile_trash_02.rmdl", <-19819.3,1439.82,6223.28>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/angel_city/ground_pile_trash_02.rmdl", <-19875.7,1447.87,6223.06>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/angel_city/ground_pile_trash_02.rmdl", <-19908,1468.01,6223>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/angel_city/ground_pile_trash_02.rmdl", <-19831.4,1488.17,6223.23>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/angel_city/ground_pile_trash_02.rmdl", <-19867.6,1480.12,6223.08>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/angel_city/ground_pile_trash_02.rmdl", <-19831.4,1423.69,6223.26>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/angel_city/ground_pile_trash_03.rmdl", <-19831.4,1443.84,6223.22>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/angel_city/ground_pile_trash_03.rmdl", <-19875.7,1403.53,6223.17>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/angel_city/ground_pile_trash_03.rmdl", <-19783.2,1476.06,6223.42>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/angel_city/ground_pile_trash_03.rmdl", <-19847.5,1516.39,6223.22>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/angel_city/ground_pile_trash_03.rmdl", <-19883.8,1496.23,6223.06>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/angel_city/box_small_02.rmdl", <-19912,1379.36,6223.23>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/angel_city/box_small_02.rmdl", <-19980.5,1379.42,6223.33>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/angel_city/box_small_02.rmdl", <-19996.6,1439.8,6223.24>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/angel_city/box_small_02.rmdl", <-19992.6,1512.35,6223.26>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/angel_city/box_small_02.rmdl", <-19952.3,1439.79,6223.07>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/angel_city/box_small_02.rmdl", <-19899.9,1427.68,6223.06>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/angel_city/box_small_02.rmdl", <-19928.3,1395.04,6235.92>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/angel_city/box_small_02.rmdl", <-19968.6,1439.18,6239.89>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/angel_city/box_small_02.rmdl", <-19940.6,1503.33,6223.52>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/angel_city/box_small_02.rmdl", <-19972.7,1499.37,6239.76>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/angel_city/box_small_02.rmdl", <-19980.4,1387.17,6239.57>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/angel_city/box_small_02.rmdl", <-19944,1399.1,6251.56>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/angel_city/box_small_02.rmdl", <-19888.7,1484.15,6223.3>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/angel_city/box_small_02.rmdl", <-19908.9,1455.86,6239.55>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/angel_city/box_small_01.rmdl", <-19860.4,1367.19,6223.62>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/angel_city/box_small_01.rmdl", <-20012.8,1563.51,6223.67>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/angel_city/box_small_01.rmdl", <-19996.5,1379.13,6255.84>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/angel_city/box_small_01.rmdl", <-19899.9,1379.04,6251.75>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/angel_city/box_small_01.rmdl", <-19988.6,1431.24,6255.66>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/angel_city/box_small_01.rmdl", <-19940.2,1475.53,6223.14>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/furniture/couch_suede_brown_01.rmdl", <-19868.8,2848.57,6223.73>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/furniture/chair_beanbag_01.rmdl", <-19980,2795.41,6223.2>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/furniture/office_desk_shelved.rmdl", <-20000.3,2619.07,6223.75>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/furniture/office_chair_leather.rmdl", <-19976.2,2608.97,6223.87>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/furniture/books_shelved.rmdl", <-19997,2579.81,6259.93>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/furniture/office_laptop.rmdl", <-19992.8,2608.14,6259.43>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/furniture/office_desk_accessories_papers.rmdl", <-19996.9,2627.88,6259.52>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/furniture/office_desk_accessories_papers.rmdl", <-19992.9,2631.94,6259.48>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/furniture/office_desk_accessories_pen_holder.rmdl", <-19996.9,2644.04,6259.52>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/furniture/office_desk_accessories_mug.rmdl", <-19988.8,2648.09,6259.47>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/furniture/office_keyboard_plastic.rmdl", <-20012.2,2603.08,6267.66>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/furniture/chair_beanbag_01.rmdl", <-19984.4,2715.18,6223.61>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/playback/playback_fish_net_01.rmdl", <-19596.8,2856.61,6364.02>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/IMC_base/generator_IMC_01.rmdl", <-18952.5,1656.7,6223.5>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/IMC_base/imc_antenna_large.rmdl", <-18259.8,2588.48,6223.15>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/IMC_base/monitor_imc_02.rmdl", <-19012.4,2140.75,6448.53>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/IMC_base/cargo_container_imc_01_blue.rmdl", <-18957,1772.2,6223.8>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/colony/farmland_crate_plastic_01_red.rmdl", <-19588,1363.08,6223.61>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/colony/farmland_crate_plastic_01_red.rmdl", <-19536,1367.08,6223.6>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/colony/farmland_crate_plastic_01_red.rmdl", <-19564.2,1367.05,6247.74>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/colony/farmland_crate_plastic_yellow_01.rmdl", <-19564.2,1399.18,6223.47>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/colony/farmland_domicile_hanging_net_01.rmdl", <-19544.9,2772.16,6464.43>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/colony/farmland_domicile_hanging_net_01.rmdl", <-19580.8,2708.53,6464.4>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/colony/farmland_domicile_hanging_net_01.rmdl", <-19420.7,2736.59,6456.39>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/colony/antenna_05_colony.rmdl", <-18347.3,1663.48,6223.57>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/colony/farmland_fridge_01.rmdl", <-19223.1,1355.7,6223.89>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/lamps/light_florescenet_modern_off.rmdl", <-19860.7,1748.03,6464.67>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/lamps/light_florescenet_modern_off.rmdl", <-19864.8,2208.01,6464.55>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/lamps/light_florescenet_modern_off.rmdl", <-19876.8,2492.03,6464.53>, <0,-90,0>, true, 8000, -1 )
    //CreateEditorPropLobby( $"mdl/lamps/light_parking_post.rmdl", <-20504.2,1895.05,6223.78>, <0,0,0>, true, 8000, -1 )
    //CreateEditorPropLobby( $"mdl/lamps/light_parking_post.rmdl", <-20507.9,2324.99,6223.9>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/barriers/concrete/concrete_barrier_01.rmdl", <-20036.2,2320.91,6223.64>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/barriers/concrete/concrete_barrier_01.rmdl", <-20032,1895.31,6223.28>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/barriers/concrete/concrete_barrier_01.rmdl", <-20032.3,2115.13,6223.6>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <-18935.5,1608.38,6223.2>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <-18803.3,1604.54,6223.56>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <-18667.2,1604.59,6223.75>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <-18531.3,1604.69,6223.83>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <-18395.3,1604.65,6223.8>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <-18920.6,2615.54,6223.37>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <-18784.5,2615.62,6223.21>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <-18640.8,2615.57,6223.57>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <-18504.8,2615.74,6223.42>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/barriers/concrete/concrete_barrier_fence_tarp_128.rmdl", <-18372.6,2615.79,6223.24>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/barriers/concrete/concrete_barrier_01.rmdl", <-18251.8,2544.8,6223.42>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/barriers/concrete/concrete_barrier_01.rmdl", <-18251.9,2456.79,6223.41>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/barriers/concrete/concrete_barrier_01.rmdl", <-18251.8,1723.11,6223.61>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/barriers/concrete/concrete_barrier_01.rmdl", <-18251.7,1815.41,6223.27>, <0,0,0>, true, 8000, -1 )

    CreateEditorPropLobby( $"mdl/vehicle/goblin_dropship/goblin_dropship.rmdl", <-18604,2115.18,6223.43>, <0,0,0>, true, 8000, -1 )
    //CreateEditorPropLobby( $"mdl/vehicles_r5/land_med/msc_freight_tortus_mod/veh_land_msc_freight_tortus_mod_cargo_holder_v1_static.rmdl", <-20600.9,2115.91,6223.55>, <0,-90,0>, true, 8000, -1 )
    
	CreateEditorPropLobby( $"mdl/vehicles_r5/land/msc_forklift_imc_v2/veh_land_msc_forklift_imc_v2_static.rmdl", <-18668,2536.64,6223.23>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19136,1472,6720>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19136,1728,6720>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19136,1984,6720>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19136,2240,6720>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19136,2496,6720>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19136,2752,6720>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19392,2752,6720>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19648,2752,6720>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19904,2752,6720>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19904,2496,6720>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19904,2240,6720>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19904,1984,6720>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19904,1728,6720>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19904,1472,6720>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19648,1472,6720>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19392,1472,6720>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19648,1728,6720>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19648,1984,6720>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19648,2240,6720>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19648,2496,6720>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19392,2240,6720>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19392,2496,6720>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19392,1984,6720>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19392,1728,6720>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/lamps/industrial_wall_light_on_blue.rmdl", <-20039,1867.84,6472.22>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/lamps/industrial_wall_light_on_blue.rmdl", <-20039,1975.98,6472.22>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/lamps/industrial_wall_light_on_blue.rmdl", <-20039,2084.16,6472.24>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/lamps/industrial_wall_light_on_blue.rmdl", <-20039,2127.94,6472.22>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/lamps/industrial_wall_light_on_blue.rmdl", <-20039,2232.06,6472.22>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/lamps/industrial_wall_light_on_blue.rmdl", <-20039,2340.1,6472.22>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/lamps/industrial_wall_light_on_blue.rmdl", <-19000.9,1883.83,6472.44>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/lamps/industrial_wall_light_on_blue.rmdl", <-19000.9,1991.9,6472.45>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/lamps/industrial_wall_light_on_blue.rmdl", <-19000.9,2096.05,6472.46>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/lamps/industrial_wall_light_on_blue.rmdl", <-19000.8,2144.3,6472.45>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/lamps/industrial_wall_light_on_blue.rmdl", <-19000.8,2247.89,6471.43>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/lamps/industrial_wall_light_on_blue.rmdl", <-19000.8,2351.88,6471.43>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", <-19136,2240,6208>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/signs/market_sign_yellow_milk.rmdl", <-20024.6,2431.25,6404.36>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/signs/scrolling_sign_scan.rmdl", <-20024.5,1795.14,6408.19>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/signs/building_sign_lit_standing_02.rmdl", <-19015.1,2424.05,6304.39>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/beacon/construction_scaff_128_64_64.rmdl", <-18435.6,2552.81,6223.55>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/beacon/construction_plastic_mat_white_01.rmdl", <-19376.8,1947.43,6227.73>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/beacon/beacon_server_wall_mount_01.rmdl", <-19019.1,2592.44,6223.77>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/beacon/beacon_server_stand_01.rmdl", <-19027,2695.97,6231.9>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/beacon/construction_plastic_mat_black_01.rmdl", <-19685,2271.89,6223.86>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/beacon/construction_plastic_mat_black_01.rmdl", <-18560.2,2556.98,6224.04>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/beacon/construction_plastic_mat_black_01.rmdl", <-18644.1,2525,6223.97>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/mendoko/mendoko_handscanner_01_dmg.rmdl", <-19015.1,1839.94,6307.67>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/canyonlands/canyonlands_zone_sign_03b.rmdl", <-20032.2,2240.89,6719.59>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/industrial/security_fence_post.rmdl", <-19967.9,1408.71,6719.31>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/industrial/security_fence_post.rmdl", <-19027.8,1360.8,6735.44>, <0,180,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/industrial/UTG_spire.rmdl", <-19040.6,2851.51,6735.38>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/industrial/UTG_spire.rmdl", <-19984.6,2843.49,6735.42>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/industrial/traffic_barrel_02.rmdl", <-19996.6,1891.46,6223.4>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/industrial/traffic_barrel_02.rmdl", <-19992.5,2112.09,6223.17>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/industrial/traffic_barrel_02.rmdl", <-19996.7,2323.91,6223.32>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/industrial/traffic_tube_01.rmdl", <-19992.7,2224.1,6223.33>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/industrial/traffic_tube_01.rmdl", <-19989,1992.01,6223.73>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/industrial/traffic_cone_01.rmdl", <-19969,2091.8,6223.81>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/industrial/traffic_cone_01.rmdl", <-19969,2136.07,6223.8>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/industrial/traffic_cone_01.rmdl", <-19948.3,2115.11,6223.68>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/industrial/traffic_cone_01.rmdl", <-18255.3,2392.42,6223.47>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/industrial/traffic_cone_01.rmdl", <-18255.2,2343.94,6223.4>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/industrial/traffic_cone_01.rmdl", <-18255.2,2304.13,6223.44>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/industrial/traffic_cone_01.rmdl", <-18251.2,1883.99,6223.41>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/industrial/traffic_cone_01.rmdl", <-18251.2,1923.77,6223.44>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/industrial/traffic_cone_01.rmdl", <-18247.2,1972.06,6223.43>, <0,90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/industrial/vending_machine_02.rmdl", <-19464.8,2872.55,6223.8>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/industrial/vending_machine_04.rmdl", <-19408.7,2872.61,6223.65>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/industrial/vending_machine_01.rmdl", <-19352.7,2872.63,6223.73>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/industrial/vending_machine_03.rmdl", <-19292.7,2872.62,6223.7>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/industrial/glass_white_board_wall.rmdl", <-20024.7,2499.31,6347.71>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/industrial/welding_push_unit.rmdl", <-18648.1,1655.13,6223.5>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/industrial/electrical_box_green.rmdl", <-18720.7,1647.64,6223.4>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/industrial/traffic_barrel_02.rmdl", <-18876.8,1655.51,6223.79>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/industrial/traffic_barrel_02.rmdl", <-18840.8,1655.42,6223.69>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/industrial/traffic_barrel_02.rmdl", <-18864.9,1687.66,6223.72>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/industrial/traffic_tube_01.rmdl", <-18804.6,1643.28,6223.61>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/industrial/traffic_tube_01.rmdl", <-18808.7,1671.43,6223.51>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/industrial/traffic_tube_01.rmdl", <-18784.4,1639.19,6223.58>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/industrial/traffic_tube_01.rmdl", <-18792.5,1659.31,6223.52>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/industrial/traffic_tube_01.rmdl", <-18772.4,1655.24,6223.46>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/industrial/traffic_tube_01.rmdl", <-18764.3,1635.14,6223.56>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/industrial/traffic_tube_01.rmdl", <-18788.5,1675.4,6223.4>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/industrial/traffic_cone_01.rmdl", <-18752.2,1659.23,6223.4>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/industrial/traffic_cone_01.rmdl", <-18768.4,1683.41,6223.29>, <0,0,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/industrial/traffic_cone_01.rmdl", <-18792.6,1695.59,6223.34>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/industrial/traffic_cone_01.rmdl", <-18816.8,1695.61,6223.48>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/industrial/traffic_cone_01.rmdl", <-18832.8,1683.57,6223.59>, <0,-90,0>, true, 8000, -1 )
    CreateEditorPropLobby( $"mdl/industrial/exit_sign_03.rmdl", <-20028.2,2140.85,6448.46>, <0,180,0>, true, 8000, -1 )

}
#endif
