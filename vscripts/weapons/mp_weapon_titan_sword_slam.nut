//By @CafeFPS and Respawn
untyped

global function MpWeaponTitanSword_Slam_Init
global function TitanSword_Slam_OnWeaponActivate
global function TitanSword_Slam_OnWeaponDectivate
global function TitanSword_Slam_ClearMods
global function TitanSword_Slam_TrySlam
global function TitanSword_Slam_VictimHitOverride
global function TitanSword_Slam_TrySlamAnimEvent

#if CLIENT
global function FS_TitanSword_CreateSlamGroundFx
#endif

const string TITAN_SWORD_SLAM_READY_MOD = "slam_ready"
const string TITAN_SWORD_SLAM_MOD = "slam"

const string TITAN_SWORD_LOOT_MOVER_SCRIPTNAME = "titan_sword_loot_mover"

global const string SIG_TITAN_SWORD_SLAM_ACTIVATED = "TitanSword_SlamActivated"
global const string SIG_TITAN_SWORD_SLAM_LANDED = "TitanSword_SlamLanded"
global const string SIG_TITAN_SWORD_SLAM_READY_THREAD = "TitanSword_SlamThread"

const bool TITAN_SWORD_LOS_DEBUG = false

const int TITAN_SWORD_SLAM_DISABLED_WEAPON_TYPES = WPT_ULTIMATE | WPT_TACTICAL | WPT_CONSUMABLE

const asset VFX_TITAN_SWORD_SLAM = $"P_pilot_swd_slam_shockwave" 
const string VFX_TITAN_SWORD_SLAM_IMPACT = "pilot_sword_slam"
const TITAN_SWORD_FX_SLAM_ATK_FP = $"P_pilot_sword_swipe_slam_FP"
const TITAN_SWORD_FX_SLAM_ATK_3P = $"P_pilot_sword_swipe_slam_3P"
const asset VFX_TITAN_SWORD_SLAM_JETS = $"P_pilot_slam_thrusters"

const string SFX_TITAN_SWORD_SLAM_ACTIVATED_1P = "titan_phasedash_end_1p"
const string SFX_TITAN_SWORD_SLAM_AIR_1P = "titan_phasedash_warningtoend_1p"
const string SFX_TITAN_SWORD_SLAM_AIR_3P = "titan_phasedash_warningtoend_3p"

struct
{
	#if SERVER


	#endif

	#if CLIENT
		bool slamHintActive = false
	#endif

}file

void function MpWeaponTitanSword_Slam_Init()
{
	RegisterSignal( SIG_TITAN_SWORD_SLAM_ACTIVATED )
	RegisterSignal( SIG_TITAN_SWORD_SLAM_LANDED )
	RegisterSignal( SIG_TITAN_SWORD_SLAM_READY_THREAD )
	RegisterSignal( "JumpPadStart" )
	RegisterSignal( "JumpPad_GiveDoubleJump" )
}

void function TitanSword_Slam_StartVFX( entity weapon )
{
	// weapon.PlayWeaponEffect( TITAN_SWORD_FX_SLAM_ATK_FP, TITAN_SWORD_FX_SLAM_ATK_3P, "muzzle_flash" )
}

void function TitanSword_Slam_OnWeaponActivate( entity player, entity weapon)
{
	#if SERVER
		thread FS_TitanSword_Slam_CheckForMinHeightAndAddMod( player, weapon )
	#elseif CLIENT
		thread TitanSword_SlamHint_Thread( player, weapon )
	#endif
}

void function TitanSword_Slam_OnWeaponDectivate( entity player, entity weapon )
{
	ClearSlamState( player, weapon, false )
}

void function TitanSword_Slam_ClearMods( entity weapon )
{
	try{
	weapon.RemoveMod( TITAN_SWORD_SLAM_MOD )
	// weapon.RemoveMod( TITAN_SWORD_SLAM_READY_MOD )
	}catch(e420)
	{
		Warning( "Error removing Slam mod, but it should work after this..." )
	}
}

bool function TitanSword_Slam_TrySlam( entity player, entity weapon )
{
	#if CLIENT
		if ( !InPrediction() )
			return false
	#endif

	if ( player.IsOnGround() )
		return false

	if ( !weapon.HasMod( TITAN_SWORD_SLAM_READY_MOD ) )
		return false

	if ( weapon.HasMod( TITAN_SWORD_SLAM_MOD ) )
		return true

	TitanSword_SafelyAddAttackMod( weapon, TITAN_SWORD_SLAM_MOD )

	// TitanSword_Slam_StartVFX( weapon )

	thread Slam_Thread( player, weapon )

	return true
}

#if CLIENT
void function TitanSword_SlamHint_Thread( entity player, entity weapon )
{
	if ( !IsValid( player ) )
		return

	if ( !IsLocalViewPlayer( player ) )
		return

	if ( file.slamHintActive )
		return

	if ( !IsValid( weapon ) )
		return

	EndSignal( player, "BleedOut_OnStartDying" )
	EndSignal( player, "OnDeath" )
	EndSignal( player, "OnDestroy" )

	EndSignal( weapon, "OnDestroy" )
	EndSignal( weapon, SIG_TITAN_SWORD_DEACTIVATE )

	file.slamHintActive = true

	string[1] displayedHint = [""]

	float buildUp = -1

	OnThreadEnd(
		function() : (displayedHint)
		{
			if ( displayedHint[0] != "" )
				HidePlayerHint( displayedHint[0] )
			file.slamHintActive = false
		}
	)

	while( true )
	{
		string hint

		if ( CanSlam( player ) && weapon.HasMod( TITAN_SWORD_SLAM_READY_MOD ) && !weapon.HasMod( TITAN_SWORD_SLAM_MOD ) && !TitanSword_Block_IsBlocking( weapon ) )
		{
			if ( buildUp == -1 )
			{
				buildUp = Time() + 0.25
			}
			else if ( Time() > buildUp )
			{
				hint = "%attack% SLAM"
			}
		}

		if ( hint != displayedHint[0] )
		{
			if ( displayedHint[0] != "" )
			{
				buildUp = -1
				HidePlayerHint( displayedHint[0] )
			}
			if ( hint != "" )
			{
				AddPlayerHint( 60.0, 0.0, $"", hint )
			}
			displayedHint[0] = hint
		}
		WaitFrame()
	}
}

void function FS_TitanSword_CreateSlamGroundFx( vector origin )
{
	entity circle = CreateClientSidePropDynamic( origin, <0, 0, 0>, $"mdl/weapons_r5/weapon_tesla_trap/mp_weapon_tesla_trap_ar_trigger_radius.rmdl" )
	circle.kv.fadedist = 30000
	circle.kv.renderamt = 0
	circle.kv.rendercolor = "245, 155, 66"
	circle.SetModelScale( 0.01 )


	// EmitSoundAtPosition( TEAM_UNASSIGNED, origin, "explo_mgl_impact_3p" )//Flyer_Cage_Slam
	thread FS_TitanSword_HandleSlamGrounFX( circle )
}

void function FS_TitanSword_HandleSlamGrounFX( entity circle )
{
	float startTime = Time()
	float endTime = Time() + 0.28
	int startAlpha = 255
	int endAlpha = 0
	float alphaResult = -1

	circle.kv.rendermode = 4

	OnThreadEnd(
	function() : ( circle )
	{
		if(IsValid(circle))
			circle.Destroy()
	})
	
	while( Time() <= endTime )
	{
		circle.SetModelScale( circle.GetModelScale() + 0.017 ) // GraphCapped( Time() - startTime, 0, 3, 0, 0.35 )
		alphaResult = GraphCapped( Time(), startTime, endTime, startAlpha, endAlpha )
		circle.kv.renderamt = alphaResult
		WaitFrame()
	}
}
#endif
bool function CanSlam( entity player )
{
	if ( player.IsOnGround() )
		return false

	if ( player.IsZiplining() )
		return false

	return true
}

void function Slam_Thread( entity player, entity weapon )
{
	printt( "Slam_Thread() - Running!" )
	player.Signal( SIG_TITAN_SWORD_SLAM_ACTIVATED )

	player.EndSignal( SIG_TITAN_SWORD_SLAM_ACTIVATED )
	player.EndSignal( "JumpPadStart" )
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )

	weapon.EndSignal( "OnDestroy" )

	entity point_push 
	
	#if SERVER
	point_push = CreateEntity( "point_push" )
	point_push.kv.spawnflags = 2
	point_push.kv.enabled = 1
	point_push.kv.magnitude = 840.0 * 0.75 //Compensate for reduced player gravity to match R1
	point_push.kv.radius = 100.0
	point_push.kv.solid = SOLID_VPHYSICS
	DispatchSpawn( point_push )
	point_push.Fire( "Enable" )
	point_push.SetParent( player ) 
	point_push.SetOrigin( player.GetOrigin() + <0, 0, -100> )

	entity melee = GetPlayerMeleeOffhandWeapon( player )
	entity lungeTarget

	if( IsValid( melee ) && melee.GetWeaponClassName() == "melee_titan_sword" )
		lungeTarget = GetMeleeAttackLungeTarget( player, melee )		

	#endif

	OnThreadEnd( function() : ( weapon, player, point_push )
		{
			printt( "Slam_Thread() - OnThreadEnd" )

			#if SERVER
			if( IsValid( point_push ) )
				point_push.Fire( "Kill", "", 0.0 )
			#endif

			#if CLIENT
			//if ( !InPrediction() || (InPrediction() && IsFirstTimePredicted()) )
				//player.UnfreezeControlsOnClient()
			#endif
		})

	#if SERVER
	// if weapon has launcher mod?
	player.SetVelocity( <0, 0, 200> )
	#endif

	player.Signal( "JumpPad_GiveDoubleJump" )

	#if CLIENT
	if ( !InPrediction() || (InPrediction() && IsFirstTimePredicted()) )
	{
		StopSoundOnEntity( player, "Survival_DropSequence_Launch_1P" )
		EmitSoundOnEntity( player, SFX_TITAN_SWORD_SLAM_ACTIVATED_1P )
	}
	#endif

	#if SERVER
	thread function () : ( lungeTarget, weapon, player )
	{
		player.p.slamLastInnerPlayers.clear()
		player.EndSignal( SIG_TITAN_SWORD_SLAM_ACTIVATED )
		player.EndSignal( "JumpPadStart" )
		player.EndSignal( "OnDeath" )
		player.EndSignal( "OnDestroy" )
		weapon.EndSignal( "OnDestroy" )
		player.EndSignal( SIG_TITAN_SWORD_SLAM_LANDED )

		vector startPos = player.GetOrigin()
		vector mins = player.GetPlayerMins()
		vector maxs = player.GetPlayerMaxs()
		array<entity> ignoreEnts = [ player, weapon ]

		float minHeightRequired
		TraceResults result = TraceHull( startPos, startPos - < 0, 0, 20000 >, mins, maxs, ignoreEnts, TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_PLAYER )
		float playerDist = DistanceSqr( startPos, result.endPos )
		TraceResults hullResult
		vector groundOrigin = player.GetOrigin()
		array<entity> entityToPushArray = GetPlayerArray()
		entityToPushArray.extend( GetNPCArray() )
		entityToPushArray.extend( GetAllPropDoors() )
		float innerSqr = GetWeaponInfoFileKeyField_GlobalFloat( TITAN_SWORD_WEAPON_REF, "slam_radius_inner" ) * GetWeaponInfoFileKeyField_GlobalFloat( TITAN_SWORD_WEAPON_REF, "slam_radius_inner" )
		float outerSqr = GetWeaponInfoFileKeyField_GlobalFloat( TITAN_SWORD_WEAPON_REF, "slam_radius_outer" ) * GetWeaponInfoFileKeyField_GlobalFloat( TITAN_SWORD_WEAPON_REF, "slam_radius_outer" )
		array<entity> finalEntsToPushInner

		while( IsValid( player ) && IsValid( weapon ) )
		{
			startPos = player.GetOrigin()
			result = TraceLine( startPos, startPos - < 0, 0, 20000 >, ignoreEnts, TRACE_MASK_NPCWORLDSTATIC | TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_NONE )
			// hullResult = TraceHull( startPos, startPos - < 0, 0, 20000 >, mins, maxs, ignoreEnts, TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_PLAYER )

			playerDist = DistanceSqr( startPos, result.endPos )

			if( playerDist >= 50000 )
			{
				printt( "inner push - playerDistToGround ", playerDist )
				WaitFrame()
				continue
			}

			printt( "inner push final - playerDistToGround ", playerDist )

			foreach( ent in entityToPushArray )
			{
				if( !IsValid( ent ) || ent == player || IsValid( weapon ) && ent == weapon || IsValid( lungeTarget ) && ent == lungeTarget || !IsAlive( ent ) || !ent.IsPlayer() && !ent.IsNPC() && !IsDoor( ent ) )
				{
					continue
				}

				playerDist = DistanceSqr( result.endPos, ent.GetOrigin() )
				if( playerDist <= innerSqr )
				{
					printt( "ent added to inner radius" )
					finalEntsToPushInner.append( ent )
				}
			}

			foreach( ent in finalEntsToPushInner )
			{	
				if( !IsValid( ent ) )
					continue
				
				printt( "inner push - knocking back player - ", ent ) //, sqrt( DistanceSqr( result.endPos, ent.GetOrigin() ) ), Distance2D( result.endPos, ent.GetOrigin() ), Distance( result.endPos, ent.GetOrigin() ) )
				TitanSword_Slam_VictimHitOverride( weapon, player, ent, true )
				player.p.slamLastInnerPlayers.append( ent )
			}

			break
		}
	}()
	#endif

	wait 0.4
	
	if( !IsValid( player ) || !IsValid( weapon ) )
		return
	
	#if CLIENT
	//if ( !InPrediction() || (InPrediction() && IsFirstTimePredicted()) )
		//player.FreezeControlsOnClient()
	#endif

	#if SERVER
	printt( "SHOULD SLAM NOW" )

	// EmitSoundOnEntityOnlyToPlayer( player, player, SFX_TITAN_SWORD_SLAM_AIR_1P )
	// EmitSoundOnEntityExceptToPlayer( player, player, SFX_TITAN_SWORD_SLAM_AIR_3P )

	//si tiene un enemigo, mandar a ese hacia abajo tambien antes de crear el point push
	TitanSword_Slam_TrySlamAnimEvent( player, weapon )

	// if( weapon.IsInCustomActivity() )
		// weapon.StopCustomActivity()

	// weapon.StartCustomActivity("ACT_VM_RAISE", 0)
	player.RumbleEffect( 4, 0, 0 )

		// vector playerAng
		// float difference
		// int progress = 0
		// while( IsValid( player ) && IsValid( weapon )  )
		// {	
			// playerAng = player.GetAngles()
			
			// if( playerAng.x < 0 )
			// {
				// difference = 90 + fabs( playerAng.x )
			// } else
			// {
				// difference = 90 - playerAng.x
			// }

			// if( progress >= difference )
				// break 

			// player.SetAbsAnglesSmooth( <AngleNormalize( playerAng.x + 4 ), playerAng.y, 0> )

			// printt( "setting angles, difference ", difference )
			// progress += 4
			// WaitFrame()
		// }
	// }()
	#endif

	player.EndSignal( SIG_TITAN_SWORD_SLAM_LANDED )
	TraceResults result
	float anotherGroundDist = DistanceSqr( player.GetOrigin(), result.endPos )
	array<entity> ignoreEnts = [ player, weapon ]

	while( IsValid( player ) && IsValid( weapon ) )
	{
		result = TraceLine( player.GetOrigin(), player.GetOrigin() - < 0, 0, 20000 >, ignoreEnts, TRACE_MASK_NPCWORLDSTATIC | TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_NONE )
		anotherGroundDist = DistanceSqr( player.GetOrigin(), result.endPos )

		if( anotherGroundDist >= ( 15 * 15 ) && !player.IsOnGround() )
		{
			WaitFrame()
			continue
		} else
			break

		WaitFrame()
	}
	
	#if CLIENT
	vector fxorigin = result.endPos
	vector fwd    = AnglesToForward( player.GetAngles() )
	fxorigin += Normalize( fwd ) * 50

	FS_TitanSword_CreateSlamGroundFx( fxorigin )
	//add remote function here to spawn fx on client side 
	#endif

	if( !IsValid( player ) )
		return
	
	#if SERVER
	PlayImpactFXTable( result.endPos, null, "pilot_bodyslam" )

	foreach( sPlayer in GetPlayerArray() )
	{
		if( player == sPlayer )
			continue

		vector fxorigin = result.endPos
		vector fwd    = AnglesToForward( player.GetAngles() )
		fxorigin += Normalize( fwd ) * 50
		Remote_CallFunction_NonReplay( sPlayer, "FS_TitanSword_CreateSlamGroundFx", fxorigin )
	}

	vector groundOrigin = result.endPos
	array<entity> entityToPushArray = GetPlayerArray()
	entityToPushArray.extend( GetNPCArray() )
	entityToPushArray.extend( GetAllPropDoors() )
	float playerDist
	float outerSqr = GetWeaponInfoFileKeyField_GlobalFloat( TITAN_SWORD_WEAPON_REF, "slam_radius_outer" ) * GetWeaponInfoFileKeyField_GlobalFloat( TITAN_SWORD_WEAPON_REF, "slam_radius_outer" )
	array<entity> finalEntsToPushOuter
	foreach( ent in entityToPushArray )
	{
		if( !IsValid( ent ) || ent == player || IsValid( weapon ) && ent == weapon || IsValid( lungeTarget ) && ent == lungeTarget || !IsAlive( ent ) || !ent.IsPlayer() && !ent.IsNPC() && !IsDoor( ent ) )
		{
			continue
		}

		playerDist = DistanceSqr( groundOrigin, ent.GetOrigin() )
		if( playerDist <= outerSqr && !(player.p.slamLastInnerPlayers.contains( ent ) ) )
		{
			finalEntsToPushOuter.append( ent )
			printt( "ent added to outer radius" )
		}
	}

	if( IsValid( weapon ) )
	{
		foreach( ent in finalEntsToPushOuter )
		{	
			if( !IsValid( ent ) )
				continue

			printt( "outer push - knocking back player - ", sqrt( DistanceSqr( result.endPos, ent.GetOrigin() ) ) )
			TitanSword_Slam_VictimHitOverride( weapon, player, ent, true )
		}
	}

	player.p.slamLastInnerPlayers.clear()
	#endif

	printt( "SLAM TOUCH GROUND" )
	OnPlayerSlamLand( player )
}

void function TitanSword_Slam_TrySlamAnimEvent( entity player, entity weapon )
{
	if ( !IsValid( player ) || !IsValid( weapon ) )
		return

	if ( !weapon.HasMod( TITAN_SWORD_SLAM_MOD ) )
		return

	printt( "SLAMMING" )

	float velZ = GetWeaponInfoFileKeyField_GlobalFloat( TITAN_SWORD_WEAPON_REF, "slam_vel_z" )
	player.SetVelocity( <0, 0, velZ> )
}
   
void function ClearSlamState( entity player, entity weapon, bool doLandAnim )
{
	if ( !IsValid( player ) )
		return

	// if ( player.PlayerMelee_GetState() != PLAYER_MELEE_STATE_SLAM_ATTACK )
		// return

	player.PlayerMelee_EndAttack()

	#if CLIENT
		if ( !InPrediction() )
			return
	#endif

	if( !IsValid( weapon ) )
		return

	if ( weapon.IsInCustomActivity() )
		weapon.StopCustomActivity()

	if ( doLandAnim )
	{
		weapon.Raise()
	}

	printt( "ClearSlamState()" )
	
	weapon.RemoveMod( TITAN_SWORD_SLAM_MOD )	
}

void function OnPlayerSlamLand( entity player )
{
	if( !IsValid( player ) )
		return

	printt( "SLAM LANDED!" )

	// if ( player.PlayerMelee_GetState() != PLAYER_MELEE_STATE_SLAM_ATTACK )
		// return

	entity weapon = TitanSword_GetMainWeapon( player )

	if ( !IsValid( weapon ) ) 
	{
		if( player.PlayerMelee_IsAttackActive() )
			player.PlayerMelee_EndAttack()

		player.Signal( SIG_TITAN_SWORD_SLAM_LANDED ) 
		// PlayRotatedImpactFXTable( player, player.GetOrigin(), AnglesToForward( player.GetAngles() ), VFX_TITAN_SWORD_SLAM_IMPACT )
		return
	}

	ClearSlamState( player, weapon, true )
	
	#if SERVER
	player.TouchGround()
	player.ConsumeDoubleJump()
	#endif

	vector origin = player.GetOrigin()
	vector fwd    = AnglesToForward( player.GetAngles() )
	const float fwdImpactOffset = 50
	origin += Normalize( fwd ) * fwdImpactOffset

	// PlayRotatedImpactFXTable( player, origin, AnglesToForward( player.GetAngles() ), VFX_TITAN_SWORD_SLAM_IMPACT, 0 )

	#if CLIENT
		// StartParticleEffectInWorld( GetParticleSystemIndex( VFX_TITAN_SWORD_SLAM ), player.GetOrigin(), <0, 0, 0> )
	#endif

	player.Signal( SIG_TITAN_SWORD_SLAM_LANDED ) 
}

bool function TitanSword_Slam_VictimHitOverride( entity weapon, entity attacker, entity victim, bool doDistanceDamage = false )
{
	if( !IsValid( attacker ) || !IsValid( victim ) || !IsAlive( victim ) || !victim.IsPlayer() || !IsValid( weapon ) || IsFriendlyTeam( attacker.GetTeam(), victim.GetTeam() ) )
		return false

	#if SERVER
	float damageAmount = 60
	string weaponName = weapon.GetWeaponClassName()
	int damageScriptType = weapon.GetWeaponDamageFlags()
	int damageType       = DMG_MELEE_ATTACK
	int damageSourceId   = eDamageSourceId.mp_weapon_titan_sword_slam
	vector damageForce   = AnglesToForward( attacker.EyeAngles() ) * weapon.GetWeaponDamageForce()
	vector startPos = attacker.GetOrigin()
	array<entity> ignoreEnts = [ attacker, weapon ]
	TraceResults result = TraceLine( startPos, startPos - < 0, 0, 20000 >, ignoreEnts, TRACE_MASK_NPCWORLDSTATIC | TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_NONE )
	vector damageOrigin  = result.endPos

	float force_max = GetWeaponInfoFileKeyField_GlobalFloat( TITAN_SWORD_WEAPON_REF, "slam_force_max" )
	float force_min = GetWeaponInfoFileKeyField_GlobalFloat( TITAN_SWORD_WEAPON_REF, "slam_force_min" )
	float minRadius = GetWeaponInfoFileKeyField_GlobalFloat( TITAN_SWORD_WEAPON_REF, "slam_radius_inner" )
	float maxRadius = GetWeaponInfoFileKeyField_GlobalFloat( TITAN_SWORD_WEAPON_REF, "slam_radius_outer" )
	float radiusToReduceDamage = maxRadius - minRadius
	float distance = Distance( damageOrigin, victim.GetOrigin() )
	float distanceDamageScale = distance / maxRadius

	if( doDistanceDamage && distance > minRadius )
	{
		distance -= minRadius
		distanceDamageScale = distance / radiusToReduceDamage
		damageAmount -= damageAmount * min( distanceDamageScale, 1.0 )
		damageAmount = ceil( damageAmount )
		// printt( "SCALE TEST: damage:", damageAmount )
		damageForce   = AnglesToForward( attacker.EyeAngles() ) * weapon.GetWeaponDamageForce()
	}

	table damageTable = {
		scriptType = weapon.GetWeaponDamageFlags(),
		damageType = damageType,
		damageSourceId = damageSourceId,
		origin = damageOrigin,
		force = damageForce
	}

	vector startPosition = attacker.GetOrigin()
	vector endPosition = victim.GetOrigin()

	if( victim.LookupAttachment( "CHESTFOCUS" ) != 0 )
		endPosition = victim.GetAttachmentOrigin( victim.LookupAttachment( "CHESTFOCUS" ) )

	vector hitNormal = Normalize( startPosition - endPosition )

	attacker.DispatchImpactEffects( victim, attacker.GetOrigin(), endPosition, hitNormal, -1, -1, -1, weapon.GetImpactTableIndex(),	attacker, -1 )

	victim.TakeDamage( int( damageAmount ), attacker, attacker, damageTable )
	bool targetIsEnemy  = IsEnemyTeam( attacker.GetTeam(), victim.GetTeam() )
	float severityScale = ( targetIsEnemy ? 1.0 : 0.5 )
	weapon.DoMeleeHitConfirmation( severityScale )
	printt( "ENT DAMAGED ", damageAmount, victim, " - From Slam_VictimHitOverride - doDistanceDamage: ", doDistanceDamage )

	if( !doDistanceDamage )
	{
		vector lookDirection = attacker.GetViewForward()
		lookDirection.z = 0
		lookDirection   = Normalize( lookDirection )

		vector knockback = lookDirection * 2000
		TitanSword_LaunchEntity( victim, <knockback.x, knockback.y, -2200> )
	} else
	{
		float force = max( force_max * min( distanceDamageScale, 1.0 ), force_min )
		if( distance <= minRadius )
			force = force_max

		PushPlayerApart( victim, attacker, force )
	}
	#endif
	return true
}

#if SERVER
void function PushPlayerApart( entity target, entity attacker, float speed )
{
	printt( "SLAM KNOCKBACK - ", speed, " - For ", target )
	vector dif = Normalize( target.GetOrigin() - attacker.GetOrigin() )
	dif *= speed
	vector result = dif
	result.z = max( 200, fabs( dif.z ) )
	target.SetVelocity( result )
	// DebugDrawLine( target.GetOrigin(), target.GetOrigin() + result * 5, 255, 0, 0, true, 10.0 )
}

void function FS_TitanSword_Slam_CheckForMinHeightAndAddMod( entity player, entity weapon )
{
	EndSignal( weapon, "OnDestroy" )
	EndSignal( player, "OnDeath" )
	EndSignal( player, "OnDestroy" )
	player.Signal( SIG_TITAN_SWORD_SLAM_READY_THREAD )
	player.EndSignal( SIG_TITAN_SWORD_SLAM_READY_THREAD )

	vector startPos = player.GetOrigin()
	vector mins = player.GetPlayerMins()
	vector maxs = player.GetPlayerMaxs()
	array<entity> ignoreEnts = [ player, weapon ]
	float playerDist
	float minHeightRequired
	TraceResults result
	bool staticAnimIdk = false

	while( true )
	{
		WaitFrame()

		if( !IsValid( player ) || !IsValid( weapon ) )
			break

		startPos = player.GetOrigin()
		result = TraceLine( startPos, startPos - < 0, 0, 20000 >, ignoreEnts, TRACE_MASK_NPCWORLDSTATIC | TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_NONE )
		playerDist = Distance( startPos, result.endPos )
		minHeightRequired = GetWeaponInfoFileKeyField_GlobalFloat( TITAN_SWORD_WEAPON_REF, "slam_height_required" )

		if( weapon.HasMod( TITAN_SWORD_SLAM_READY_MOD ) && playerDist >= minHeightRequired )
			continue

		if( playerDist < minHeightRequired && CanSlam( player ) )
		{
			weapon.RemoveMod( TITAN_SWORD_SLAM_READY_MOD )

			if( weapon.IsInCustomActivity() )
				weapon.StopCustomActivity()

			entity vm = weapon.GetWeaponViewmodel()
			if( IsValid( vm ) )
			{
				try{
					vm.Anim_Stop()
				}catch(e420){}
			}
		}

		if( playerDist >= minHeightRequired && CanSlam( player )  )
		{
			try{
			weapon.AddMod( TITAN_SWORD_SLAM_READY_MOD )
			}catch(e421) 
			{
				printt( "--------------------------------- DEBUG DEBUG DEBUG -> slam_ready2" )
			}

			entity vm = weapon.GetWeaponViewmodel()
			if( IsValid( vm ) )
			{
				try{
					vm.Anim_PlayOnly("animseq/weapons/bloodhound_axe/ptpov_axe_bloodhound/melee_jump.rseq")
				}catch(e420){}

				vm.SetCycle( 0.1 )
				vm.Anim_ChangePlaybackRate( 0.25 )
			}
		}
		
	}
}
#endif