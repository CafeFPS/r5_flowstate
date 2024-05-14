//By @CafeFPS and Respawn

global function MpWeaponTitanSword_Dash_Init
global function TitanSword_Dash_OnWeaponActivate
global function TitanSword_Dash_OnWeaponDeactivate
global function TitanSword_Dash_ClearMods
global function TitanSword_Dash_TryDash
global function TitanSword_Dash_IsDashing

#if CLIENT
global function ServerCallback_StopDash
global function TrackDashSprintFx
#endif

const float TITAN_SWORD_CHARGE_DASH_SEC = 0.0
const float TITAN_SWORD_DASH_SPEED = 1400
const float TITAN_SWORD_DASH_SPEED_AIR = 950

const float TITAN_SWORD_DASH_NOT_READY_DEBOUNCE_TIME_SEC = 1
const float TITAN_SWORD_MAIN_INSTRUCTIONS_DEBOUNCE_TIME = 30 
const float TITAN_SWORD_INSTRUCTIONS_DEBOUNCE_TIME = 10

const bool TITAN_SWORD_LOS_DEBUG = false

const asset VFX_TITAN_SWORD_DASH_1P = $"P_sprint_FP"
const asset VFX_TITAN_SWORD_DASH_3P = $"P_pilot_dash_3P"
const asset VFX_TITAN_SWORD_DASH_JETS = $"P_pilot_dash_launch_thruster"

const string VFX_TITAN_SWORD_DASH_START_IMPACT = "pilot_dash_start" 
const string VFX_TITAN_SWORD_DASH_SKID_IMPACT = "pilot_dash" 

const string SFX_TITAN_SWORD_DASH_1P = "titan_phasedash_activate_1p"
const string SFX_TITAN_SWORD_DASH_3P = "titansword_special_dash_3p"
const string SFX_TITAN_SWORD_DASH_IMPACT = "titansword_special_dash_obstacle_1p"

struct
{
	int sprintFxHandle = -1
}file

void function MpWeaponTitanSword_Dash_Init()
{
	PrecacheParticleSystem( VFX_TITAN_SWORD_DASH_1P )

	RegisterSignal( SIG_TITAN_SWORD_DASH_ACTIVATED )
	RegisterSignal( SIG_TITAN_SWORD_DASH_ONACTIVATE )
	RegisterSignal( SIG_TITAN_SWORD_DASH_STOPPED )

	#if CLIENT
	AddCreateCallback( "player", OnPlayerCreated )
	#endif
}

void function TitanSword_Dash_OnWeaponActivate( entity player, entity weapon )
{
}

void function TitanSword_Dash_OnWeaponDeactivate( entity player, entity weapon )
{
}

void function TitanSword_Dash_ClearMods( entity weapon )
{
	
}

void function TitanSword_Dash_StartDashing( entity player, float duration )
{
	#if CLIENT
		if ( !InPrediction() )
			return
	#endif

	StatusEffect_AddTimed( player, eStatusEffect.titan_sword_dash, 1.0, duration, 0.0 )
}

void function TitanSword_Dash_StopDashing( entity player )
{
	#if CLIENT
		if ( InPrediction() )
			StatusEffect_StopAllOfType( player, eStatusEffect.titan_sword_dash )

		player.Signal( SIG_TITAN_SWORD_DASH_STOPPED )
		return
	#endif
	
	StatusEffect_StopAllOfType( player, eStatusEffect.titan_sword_dash )
	player.Signal( SIG_TITAN_SWORD_DASH_STOPPED )
}

bool function TitanSword_Dash_IsDashing( entity player )
{
	return StatusEffect_GetSeverity( player, eStatusEffect.titan_sword_dash ) > 0
}

bool function TitanSword_Dash_TryDash( entity player, entity weapon )
{
	if ( TitanSword_Block_IsBlocking( weapon ) )
	{
		if ( TitanSword_Dash_TryDashCancel( player, weapon ) && TitanSword_Heavy_TryHeavyAttack( player, weapon ) )
			return true

		if ( TitanSword_Dash_IsDashing( player ) )
			return true

		if ( !TitanSword_TryUseFuel( player, true ) )
			return true

		thread TitanSword_Dash_Thread( player )
		#if CLIENT
			HidePlayerHint( "Dash charging" )
		#endif
		return true 
	}

	return false
}

bool function TitanSword_Dash_TryDashCancel( entity player, entity weapon )
{
	if ( TitanSword_Dash_IsDashing( player ) && !weapon.IsWeaponInAds() )
	{
		return true
	}
	return false
}

void function TitanSword_Dash_Thread( entity player )
{
	if ( !IsValid( player ) )
		return

	printt( "DASH STARTED: ", player )
	
	player.PlayerMelee_SetAttackRecoveryShouldBeQuick( true )
	player.PlayerMelee_EndAttack()
	player.Signal( SIG_TITAN_SWORD_DASH_ACTIVATED )

	player.EndSignal( SIG_TITAN_SWORD_DASH_ACTIVATED )
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "BleedOut_OnStartDying" )
	player.EndSignal( SIG_TITAN_SWORD_DASH_STOPPED )

	#if CLIENT
		if ( !InPrediction() || (InPrediction() && IsFirstTimePredicted()) )
			EmitSoundOnEntity( player, SFX_TITAN_SWORD_DASH_1P )
	#endif

	float duration = 0.4
	vector startPos = player.GetOrigin()
	TitanSword_Dash_StartDashing( player, duration + 0.1 ) 

	vector fwdAdjusted = AnglesCompose( player.EyeAngles(), <90, 0, 0> )
	fwdAdjusted.x = 90

	vector eyeAngles = player.EyeAngles()
	eyeAngles.x = 0
	vector launchFwd = FlattenNormalizeVec( AnglesToForward( eyeAngles ) )

	vector normalVel = Normalize( player.GetVelocity() )

	float dashSpeed = player.IsOnGround() ? TITAN_SWORD_DASH_SPEED : TITAN_SWORD_DASH_SPEED_AIR

	vector dashVec  = launchFwd * dashSpeed
	if ( StatusEffect_GetSeverity( player, eStatusEffect.titan_sword_dash_sickness ) > 0 )
	{
		dashVec.z = player.GetVelocity().z * 0.85
	}

	#if SERVER
	thread FS_CheckDashPathEntities( player )

	OnThreadEnd(
		function() : ( player, dashVec, dashSpeed )
		{
			if( !IsValid( player ) )
				return
			
			vector vel = player.GetVelocity()
			float velScalar = vel.Length()
			if( player.IsOnGround() && !player.IsSliding() &&  velScalar > dashSpeed*0.45 )
			{
				player.SetVelocity( Normalize( dashVec ) * ( dashSpeed * 0.45 ) )
				printt( "player broken (?) " )
			}

			TitanSword_Dash_StopDashing( player ) 
		}
	)

	player.SetVelocity( dashVec )

	foreach(sPlayer in GetPlayerArray() )
	{
		if( sPlayer == player )
			continue
		
		if( player.GetTeam() == sPlayer.GetTeam() )
			EmitSoundOnEntityOnlyToPlayer( player, sPlayer, "titan_phasedash_activate_3p" )
		else
			EmitSoundOnEntityOnlyToPlayer( player, sPlayer, "titan_phasedash_activate_3p_enemy" )
	}
	#endif
	
	if ( !player.IsOnGround() )
		StatusEffect_AddTimed( player, eStatusEffect.titan_sword_dash_sickness, 1.0, 5.0, 0.0 )

	wait 0.1

	if( !IsValid( player ) || !IsAlive( player ) ) 
		return

	wait duration
	
	if( !IsValid( player ) ) 
		return

	printt( "PLAYER DASHED: ", Distance( startPos, player.GetOrigin() ) )
	#if SERVER
	foreach(sPlayer in GetPlayerArray() )
	{
		if( sPlayer == player )
			continue
		
		if( player.GetTeam() == sPlayer.GetTeam() )
			StopSoundOnEntity( player, "titan_phasedash_activate_3p" )
		else
			StopSoundOnEntity( player, "titan_phasedash_activate_3p_enemy" )
	}
	#endif
	player.Signal( SIG_TITAN_SWORD_DASH_STOPPED )

}
 
#if CLIENT
void function ServerCallback_StopDash()
{
	entity player = GetLocalViewPlayer()
	if ( IsValid( player ) )
		TitanSword_Dash_StopDashing( player )
}


void function OnPlayerCreated( entity player )
{
	if( !IsValid( player ) || player != GetLocalViewPlayer() )
		return
	
	thread TrackDashSprintFx( player )
}

void function TrackDashSprintFx( entity player )
{
	// printt( "TrackDashSprintFx restarted" )
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDeath" )

	player.Signal( SIG_TITAN_SWORD_DASH_ONACTIVATE )
	player.EndSignal( SIG_TITAN_SWORD_DASH_ONACTIVATE )

	OnThreadEnd(
		function() : ( player )
		{
			if( EffectDoesExist( file.sprintFxHandle ) )
				EffectStop( file.sprintFxHandle, true, false )
		}
	)

	while ( true )
	{
		WaitFrame()

		if( !IsValid( player.GetCockpit() ) )
			continue

		if( file.sprintFxHandle == -1 )
		{
			file.sprintFxHandle = StartParticleEffectOnEntity( player.GetCockpit(), GetParticleSystemIndex( VFX_TITAN_SWORD_DASH_1P ), FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
			EffectSetIsWithCockpit( file.sprintFxHandle, true )
		}

		bool shouldSprint = TitanSword_Dash_IsDashing( player )
		
		if ( !shouldSprint && EffectDoesExist( file.sprintFxHandle ) && file.sprintFxHandle != -1 )
		{
			EffectSleep( file.sprintFxHandle )
		}
		else if ( shouldSprint && EffectDoesExist( file.sprintFxHandle ) && file.sprintFxHandle != -1 )
		{
			EffectWake( file.sprintFxHandle )
		}
	}
}
#endif

#if SERVER
void function FS_CheckDashPathEntities( entity player )
{
	EndSignal( player, "OnDeath" )
	EndSignal( player, "OnDestroy" )
	EndSignal( player, SIG_TITAN_SWORD_DASH_STOPPED )
	vector mins = player.GetPlayerMins()
	vector maxs = player.GetPlayerMaxs()
	vector eyePos
	array<entity> ignoreEnts = [ player]
	TraceResults result

	vector eyeAngles = player.EyeAngles()
	eyeAngles.x = 0
	vector launchFwd = FlattenNormalizeVec( AnglesToForward( eyeAngles ) )
	bool dontstop = false

	while( IsValid( player ) && TitanSword_Dash_IsDashing( player ) )
	{
		eyePos = player.EyePosition()
		eyeAngles = player.EyeAngles()
		eyeAngles.x = 0
		launchFwd = FlattenNormalizeVec( AnglesToForward( eyeAngles ) )

		result = TraceHull( eyePos, eyePos + launchFwd * 500, mins, maxs, ignoreEnts, TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_NONE )

		printt( "PLAYER DASHING!!! - ", result.fraction, result.hitEnt, result.endPos, "Dist: ", Distance( result.endPos, eyePos ) )

		if( IsValid( result.hitEnt ) && !result.hitEnt.IsPlayer() && !IsWorldSpawn( result.hitEnt ) && FS_TitanSword_CanGoThroughBlockingEntity( result.hitEnt ) && Distance( result.endPos, eyePos ) < 100 )
		{
			printt( "PLAYER GOING THROUGH ALLOWED ENT" )
			WaitFrame()
			continue
		}

		if( result.fraction < 1 && Distance( result.endPos, eyePos ) < 100 )
		{
			printt( "PLAYER DASHING FORCED TO STOP" )
			player.Signal( SIG_TITAN_SWORD_DASH_STOPPED )
			Remote_CallFunction_NonReplay( player, "ServerCallback_StopDash" )

			// add door destroy
			break
		}

		WaitFrame()
	}
}

bool function FS_TitanSword_CanGoThroughBlockingEntity( entity blockingEntity )
{
	if ( !IsValid( blockingEntity ) )
		return false

	if ( blockingEntity.GetScriptName() == BUBBLE_SHIELD_SCRIPTNAME )
	{
		return true
	}

	if ( blockingEntity.GetScriptName() == TROPHY_SYSTEM_NAME )
	{
		return false
	}

	if ( blockingEntity.GetScriptName() == CARE_PACKAGE_SCRIPTNAME )
	{
		return false
	}

	return false
}
#endif	