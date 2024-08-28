// Made by @CafeFPS
// -- holo thing for the spawner - Zer0bytes

globalize_all_functions

struct
{
	entity ball
	entity ballCarrier

	//Spawner
	entity ballSpawn
	entity ballSpawn_emptyball
} file

const float ODDBALL_BALL_TIMEOUT = 35

void function FsOddballInit()
{
	AddCallback_OnClientDisconnected( FsOddball_PlayerDisconnected )
	AddCallback_OnPlayerKilled( FsOddball_OnPlayerKilled )
	RegisterSignal( "OnlyOneTimeThread" )
	AddClientCommandCallback( "CC_AttemptThrowOddball", Flowstate_ClientCommand_AttemptThrowOddball )
	//connected callback, refresh score and ball icon
	
	RegisterSignal( "StopAutoStartRuiThread" )
	PrecacheModel( $"mdl/weapons/caber_shot/caber_shot_thrown.rmdl" )
}

bool function Flowstate_ClientCommand_AttemptThrowOddball(entity player, array < string > args)
{
	if( !IsValid( player ) || !player.IsPlayer() || file.ballCarrier != player ) // check if loot fs_ball exists
		return false

	printt("Ball dropped by " + player)

	ClearBallCarrierPlayerSetup( player )
	SpawnOddballFromPlayer( player )
	return true
}

void function FsOddball_PlayerDisconnected( entity player )
{
	if( file.ballCarrier == player && GetTDMState() == eTDMState.IN_PROGRESS )
	{
		printt( "Ball carrier disconnected. Ball spawned." )
		SpawnOddballFromPlayer( player )
		SetBallCarrier( null )
	}
}

void function FsOddball_OnPlayerKilled(entity victim, entity attacker, var damageInfo)
{
	if( !IsValid( victim ) )
		return

	victim.p.storedWeapons = []

	if( file.ballCarrier == victim && GetTDMState() == eTDMState.IN_PROGRESS )
	{
		ClearBallCarrierPlayerSetup( victim )
		SpawnOddballFromPlayer( victim )
		SetBallCarrier( null )
		printt( "Ball carrier died. Ball spawned." )
	}
}

void function SpawnOddballFromPlayer( entity player )
{
	if( IsValid( GetBallEntity() ) ) 
		GetBallEntity().Destroy()

	vector origin = GetThrowOrigin( player )
	entity ball = SpawnGenericLoot( "fs_ball", origin, <0,0,0>, 1 )
	FakePhysicsThrow( player, ball, AnglesToForward( player.EyeAngles() ) * 300 )
	SetBallEntity( ball )
	
	SetBallCarrier( null )

	thread CheckBallInWorldBounds( ball )
}

void function CheckBallInWorldBounds( entity ball )
{
	EndSignal( ball, "OnDestroy" )

	float timeout = Time() + ODDBALL_BALL_TIMEOUT
	
	while( IsValid( ball ) && GetTDMState() == eTDMState.IN_PROGRESS )
	{
		if( Time() >= timeout )
		{
			thread ResetBallInBallSpawner( true )
			break
		}

		if( MapName() == eMaps.mp_flowstate && ball.GetOrigin().z <= GetZLimitForCurrentLocationName() || MapName() == eMaps.mp_flowstate && ball.GetOrigin().z >= -19500 )
		{
			thread ResetBallInBallSpawner( true )
			break
		}
	
		WaitFrame()
	}
}

void function SetBallCarrier( entity player )
{
	if( !IsValid( player ) || !player.IsPlayer() || !IsAlive( player)  )
	{
		file.ballCarrier = null

		if( IsValid( GetBallEntity() ) )
		{
			SetGlobalNetEnt( "FSDM_Oddball_BallOrCarrierEntity", GetBallEntity() )
		}
		return
	}

	file.ballCarrier = player
	SetGlobalNetEnt( "FSDM_Oddball_BallOrCarrierEntity", player )

	StorePilotWeapons( player )
	TakeAllWeapons( player )
	SetupBallCarrierPlayer( player )
}

void function SetupBallCarrierPlayer( entity player )
{
	if(IsValid(player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_2 )))
		player.TakeNormalWeaponByIndexNow( WEAPON_INVENTORY_SLOT_PRIMARY_2 )
	
	if(IsValid(player.GetOffhandWeapon( OFFHAND_MELEE )))
		player.TakeOffhandWeapon( OFFHAND_MELEE )
	
	player.GiveWeapon( "mp_weapon_oddball_primary", WEAPON_INVENTORY_SLOT_PRIMARY_2, [] )
	player.GiveOffhandWeapon( "melee_oddball", OFFHAND_MELEE, [] )
	player.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_2)
	
	player.SetVelocity( <0,0,0> ) //avoid bhop abuse
	//ball carrier can't run
	StatusEffect_AddEndless(player, eStatusEffect.move_slow, 0.1)
	player.SetMoveSpeedScale( 1.11 )

	Remote_CallFunction_NonReplay(player, "Oddball_HintCatalog", 0, 0)

	//show hud
	thread function () : ( player )
	{
		EndSignal( player, "StopAutoStartRuiThread" )
		wait 3.55
		if( IsValid( player ) && GetBallCarrier() == player )
			StatusEffect_AddEndless( player, eStatusEffect.player_carrying_oddball, 1.0 )
	}()
	
	//destruir trail por si las moscas, no debería pasar
	if( IsValid( player.p.oddballCarrierFx ) )
		player.p.oddballCarrierFx.Destroy()

	int AttachID = player.LookupAttachment( "CHESTFOCUS" )
    player.p.oddballCarrierFx = StartParticleEffectOnEntity_ReturnEntity( player, GetParticleSystemIndex( $"P_ar_holopilot_trail" ), FX_PATTACH_ABSORIGIN_FOLLOW, AttachID )
	if( IsValid( player.p.oddballCarrierFx ) )
	{
		player.p.oddballCarrierFx.SetOwner( player )
		player.p.oddballCarrierFx.kv.VisibilityFlags = ( ENTITY_VISIBLE_TO_FRIENDLY | ENTITY_VISIBLE_TO_ENEMY ) //owner cant see
	}
	//Move ball icon on hud properly
	foreach( sPlayer in GetPlayerArray() )
	{
		if( player.GetTeam() == sPlayer.GetTeam() )
		{
			Remote_CallFunction_NonReplay( sPlayer, "SetBallPosesionIconOnHud", 0 )
		} else
			Remote_CallFunction_NonReplay( sPlayer, "SetBallPosesionIconOnHud", 1 )
	}
}

void function Oddball_RestorePlayerStats( entity player )
{
	player.SetPlayerNetInt( "oddball_ballHeldTime", 0 )
}

void function Oddball_GlobalHeldTimer()
{
	Signal(svGlobal.levelEnt, "OnlyOneTimeThread" )
	EndSignal(svGlobal.levelEnt, "OnlyOneTimeThread" )
	
	while( GetGlobalNetInt( "FSDM_GameState" ) == eTDMState.IN_PROGRESS )
	{
		foreach( player in GetPlayerArray() )
		{
			if( IsValid( player ) && IsAlive( player ) && file.ballCarrier == player )
			{
				player.SetPlayerNetInt( "oddball_ballHeldTime", player.GetPlayerNetInt( "oddball_ballHeldTime" ) + 1 )
			}
		}

		wait 1
	}
}

void function ClearBallCarrierPlayerSetup( entity player )
{
	if( !IsValid( player ) || player != file.ballCarrier )
		return
	
	//restore movement
	StatusEffect_StopAllOfType( player, eStatusEffect.move_slow)
	player.SetMoveSpeedScale( 1 )
	
	Signal( player, "StopAutoStartRuiThread" )
	SetBallCarrier( null )
	
	RetrievePilotWeapons( player )
	player.ClearFirstDeployForAllWeapons()
	Remote_CallFunction_NonReplay(player, "Oddball_HintCatalog", -1, 0)
	SURVIVAL_RemoveFromPlayerInventory( player, "fs_ball", 1 )
	
	StatusEffect_StopAllOfType( player, eStatusEffect.player_carrying_oddball )

	foreach( sPlayer in GetPlayerArray() )
	{
		Remote_CallFunction_NonReplay(player, "SetBallPosesionIconOnHud", -1 )
	}
	
	if( IsValid( player.p.oddballCarrierFx ) )
		player.p.oddballCarrierFx.Destroy()
}

entity function GetBallCarrier()
{
	return file.ballCarrier
}

void function SetBallEntity( entity ball )
{
	file.ball = ball
	SetGlobalNetEnt( "FSDM_Oddball_BallOrCarrierEntity", file.ball )
}

entity function GetBallEntity()
{
	return file.ball
}

//Ball Spawner


int function GetZLimitForCurrentLocationName()
{
	string mapName = FSDM_GetSelectedLocation().name

	switch( mapName )
	{
		case "Narrows":
			return -21000
		break

		case "Beaver Creek":
			return -26500
		break
		default:
		return -22500
	}
	
	unreachable
}

void function SpawnBallSpawnerAtMapLocation( string mapName )
{
	if( IsValid( file.ballSpawn ) )
		file.ballSpawn.Destroy()

	//start timer
	thread Oddball_GlobalHeldTimer()

	switch( mapName )
	{
		case "Narrows":
		CreateBallSpawner( <42000, -10000, -20119.0781> )
		break
		
		case "The Pit":
		CreateBallSpawner( <42002.2734, -10494.9375, -19726.1563> )
		break

		case "Lockout":
		CreateBallSpawner( <41878.957, -9840.07324, -20806.2383> )
		break

		case "Beaver Creek":
		CreateBallSpawner( <42051.8242, -10105.6211, -26054.0566> )
		break

		default:
		foreach( player in GetPlayerArray() )
			Message( player, "NO BALL SPAWNER :(", "")
			
		Signal(svGlobal.levelEnt, "OnlyOneTimeThread" )
		break
	}
	
}
void function CreateBallSpawner( vector origin )
{
	entity  holo = CreateEntity( "prop_script" )
	holo.SetOrigin( origin )
	holo.SetAngles( Vector(-90,0,0) )
	holo.kv.targetname = "BallSpawner"
	holo.SetValueForModelKey( $"mdl/weapons/caber_shot/caber_shot_thrown.rmdl" )
	holo.SetModel( $"mdl/weapons/caber_shot/caber_shot_thrown.rmdl" )
	DispatchSpawn(  holo )

	holo.SetCollisionAllowed(false)
	thread LoopFXOnEntity2( holo , $"P_BT_eye_proj_holo" , 10, <0,0,3> )
	
	if( IsValid( file.ballSpawn ) )
		file.ballSpawn.Destroy()

	file.ballSpawn = holo
	
	if( !IsValid( file.ballSpawn_emptyball ) && !IsValid( GetBallEntity() ) )
		SetEmptyBallInBallSpawner()
}

void function ResetBallInBallSpawner( bool actualReset = false ) 
{
	if( !IsValid( file.ballSpawn ) )
		return

	float yaw = 0
	if( IsValid( file.ballSpawn_emptyball ) )
	{
		yaw = file.ballSpawn_emptyball.GetAngles().y
		file.ballSpawn_emptyball.Destroy()
	}
	
	SetBallCarrier( null )
	if( IsValid( GetBallEntity() ) ) 
		GetBallEntity().Destroy()
	
	vector angles = <0,-90,0>
	
	if( yaw != 0 )
		angles.y = yaw

	entity AnimProxy = CreatePropScript( $"mdl/flowstate_custom/w_oddball.rmdl", file.ballSpawn.GetOrigin() + <0,0,50>, angles)
	{
		AnimProxy.kv.modelscale = 1.5
		AnimProxy.kv.rendermode = 3
		AnimProxy.kv.renderamt = 255
		AnimProxy.kv.fadedist = 9999
		HighlightMiticItem( AnimProxy )
		AnimProxy.SetParent( file.ballSpawn )
	}

	SetBallEntity( AnimProxy )
	thread SpinRotateEntity2(AnimProxy , 4.0)

	entity trigger = CreateEntity( "trigger_cylinder" )
	trigger.SetRadius( 30 )
	trigger.SetAboveHeight( 120 )
	trigger.SetBelowHeight( 0 )
	trigger.SetOrigin( file.ballSpawn.GetOrigin() )
	trigger.SetEnterCallback( BallSpawnerTrigger )
	DispatchSpawn( trigger )
	trigger.SetParent( AnimProxy )
	trigger.SearchForNewTouchingEntity()

	foreach( sPlayer in GetPlayerArray() )
	{
		Remote_CallFunction_NonReplay( sPlayer, "SetBallPosesionIconOnHud", -1 )
	}
	
	if( actualReset )
	{
		foreach( player in GetPlayerArray() )
			Message( player, "BALL RESET", "", 3, "UI_InGame_FD_SliderExit" ) //Ball has been moved to start position
	}
}

void function BallSpawnerTrigger( entity trigger , entity player )
{
	if( !IsValid(player) || IsValid(player) && !player.IsPlayer() || GetTDMState() != eTDMState.IN_PROGRESS ) 
		return
	
	SetEmptyBallInBallSpawner()
	SetBallCarrier( player )
}

void function SetEmptyBallInBallSpawner() 
{
	if( !IsValid( file.ballSpawn ) )
		return

	float yaw = 0
	if( IsValid( GetBallEntity() ) )
	{
		yaw = GetBallEntity().GetAngles().y
		GetBallEntity().Destroy()
	}

	vector angles = <0,-90,0>
	
	if( yaw != 0 )
		angles.y = yaw

	if( IsValid( file.ballSpawn_emptyball ) ) 
		file.ballSpawn_emptyball.Destroy()

	entity AnimProxy = CreatePropScript( $"mdl/flowstate_custom/w_oddball.rmdl", file.ballSpawn.GetOrigin() + <0,0,50>, angles)
	{
		AnimProxy.kv.modelscale = 1.5
		AnimProxy.kv.rendermode = 4
		AnimProxy.kv.renderamt = 180
		AnimProxy.kv.fadedist = 9999 
		// ScaleBoundingBox( AnimProxy, 0.25 )
		HighlightDecoy2( AnimProxy )
		AnimProxy.SetParent( file.ballSpawn )
	}

	file.ballSpawn_emptyball = AnimProxy
	thread SpinRotateEntity2(AnimProxy , 4.0)
}

void function LoopFXOnEntity2( entity ent , asset fxname , float loop_speed , vector offset = ZERO_VECTOR , int loop_count = -1)
{
   Assert( !IsNewThread(), "Must be threaded" )

   int looped = 0
   while (IsValid(ent))
   {
		if( loop_count != -1 && looped > loop_count)
			break

		entity fx = PlayFXOnEntity( fxname, ent )
		fx.SetOrigin(fx.GetOrigin() + offset)
		wait loop_speed

		if( loop_count != -1 )
		  looped++

		if(IsValid(fx))
			fx.Destroy()
   }
}

void function ScaleBoundingBox2(entity ent,float scale = 1)
{
	if(scale == 1)
		ent.SetBoundingBox( ent.GetBoundingMins() * ent.GetModelScale(), ent.GetBoundingMaxs() * ent.GetModelScale() )
	else ent.SetBoundingBox( ent.GetBoundingMins() * scale, ent.GetBoundingMaxs() * scale )
}

void function SpinRotateEntity2( entity Ent , float Direction = 4)
{
	while( IsValid( Ent ) )
	{
		if(Ent.GetAngles().y == -360)
			Ent.SetAngles( <0,0,0> )
		else
			Ent.SetAngles( Ent.GetAngles() + <0,Direction,0> )
		WaitFrame()
	}
}
  
void function HighlightDecoy2( entity ent , vector RGB = ZERO_VECTOR)
{
    Highlight_SetNeutralHighlight( ent , "decoy_prop" )

    if(RGB != ZERO_VECTOR)
        ent.Highlight_SetParam( 0, 0, RGB / 255 )
}
  
void function HighlightMiticItem( entity ent , vector RGB = ZERO_VECTOR)
{
    Highlight_SetNeutralHighlight( ent , "survival_item_heirloom" )

    if(RGB != ZERO_VECTOR)
        ent.Highlight_SetParam( 0, 0, RGB / 255 )
}