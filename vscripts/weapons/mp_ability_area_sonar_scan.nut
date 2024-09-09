global function MpAbilityAreaSonarScan_Init

global function OnWeaponActivate_ability_area_sonar_scan
global function OnWeaponPrimaryAttackAnimEvent_ability_area_sonar_scan

#if SERVER
global function AreaSonarScan_OnSonarTriggerEnterForHostileEnts
global function AreaSonarScan_OnSonarTriggerEnter
global function AreaSonarScan_OnSonarTriggerLeave
global function AreaSonarScan_PropScriptUpdate
#endif

const asset FLASHEFFECT    = $"P_sonar_bloodhound"
const asset EYEEFFECT    = $"P_sonar_bloodhound_eyes"
const asset AREA_SCAN_ACTIVATION_SCREEN_FX = $"P_sonar"
const asset FX_SONAR_TARGET = $"P_ar_target_sonar"

const int AREA_SCAN_SKIN_INDEX = 9

const float AREA_SONAR_SCAN_RADIUS = 3000.0
const float AREA_SONAR_SCAN_HUD_FEEDBACK_DURATION = 3.0
global const float AREA_SONAR_SCAN_HIGHLIGHT_DURATION = 1.5
const float AREA_SONAR_SCAN_CONE_FOV = 125.0

const bool AREA_SONAR_PERF_TESTING = false

struct
{
	int colorCorrection
	int screeFxHandle
	float areaSonarScanDuration
	float areaSonarScanRadius
	float areaSonarScanRadiusSqr
	float areaSonarScanFOV


#if SERVER
	table< entity , int > areaScanIndex
	table<entity, table< int, array<entity> > >  areaScanTargets


	table< entity, entity > eyesEffectHandles
#endif
} file

void function MpAbilityAreaSonarScan_Init()
{
	PrecacheParticleSystem( FLASHEFFECT )
	PrecacheParticleSystem( EYEEFFECT )
	PrecacheParticleSystem( FX_SONAR_TARGET )

	file.areaSonarScanDuration = GetCurrentPlaylistVarFloat( "bloodhound_scan_duration", 3.0 )
	file.areaSonarScanRadius = GetCurrentPlaylistVarFloat( "area_sonar_scan_radius_override", AREA_SONAR_SCAN_RADIUS )
	file.areaSonarScanRadiusSqr = file.areaSonarScanRadius * file.areaSonarScanRadius
	file.areaSonarScanFOV = GetCurrentPlaylistVarFloat( "bloodhound_scan_cone_fov", AREA_SONAR_SCAN_CONE_FOV )

	#if CLIENT
		PrecacheParticleSystem( AREA_SCAN_ACTIVATION_SCREEN_FX )
		file.colorCorrection = ColorCorrection_Register( "materials/correction/area_sonar_scan.raw_hdr" )

		StatusEffect_RegisterEnabledCallback( eStatusEffect.sonar_pulse_visuals, AreaSonarScan_StartScreenEffect )
		StatusEffect_RegisterDisabledCallback( eStatusEffect.sonar_pulse_visuals, AreaSonarScan_StopScreenEffect )
	#endif //CLIENT

	RegisterSignal( "AreaSonarScan_Activated" )

}

void function OnWeaponActivate_ability_area_sonar_scan( entity weapon )
{
}

var function OnWeaponPrimaryAttackAnimEvent_ability_area_sonar_scan( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	//weapon.SetWeaponSkin( AREA_SCAN_SKIN_INDEX )
	entity weaponOwner = weapon.GetWeaponOwner()
	Assert ( weaponOwner.IsPlayer() )

	#if SERVER
		//StatusEffect_AddTimed( weaponOwner, eStatusEffect.threat_vision, 1.0, 1.0, 1.0 )
		vector scanOrigin = weaponOwner.GetAttachmentOrigin( weaponOwner.LookupAttachment( "HEADSHOT" ) )
		thread AreaSonarScan_SonarThink( weaponOwner, scanOrigin,weaponOwner.GetViewForward(), AreaSonarScan_GetScanRadius() )
		var battleChatterLine = GetWeaponInfoFileKeyField_Global( weapon.GetWeaponClassName(), "battle_chatter_event" )

		if ( battleChatterLine != null )
			thread PlayBattleChatterLineDelayedToSpeakerAndTeam( weaponOwner, expect string( battleChatterLine ), 0.4 )
	#endif //SERVER

	#if CLIENT
//		if ( IsFirstTimePredicted() )
//			thread AreaSonarScan_PlayActivationScreenFX( weaponOwner )
	#endif //CLIENT

	PlayerUsedOffhand( weaponOwner, weapon )

	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_min_to_fire )
}



float function AreaSonarScan_GetConeFOV()
{
	return file.areaSonarScanFOV
}

#if SERVER
float function GetScanHighlightDuration( entity player )
{
	float dur = AREA_SONAR_SCAN_HIGHLIGHT_DURATION

	return dur
}

float function AreaSonarScan_GetDuration( )
{
	return file.areaSonarScanDuration
}

float function AreaSonarScan_GetScanRadius( )
{
	return file.areaSonarScanRadius
}
float function AreaSonarScan_GetScanRadiusSqr( )
{
	return file.areaSonarScanRadiusSqr
}

void function AreaSonarScan_PlayActivateSound( entity owner )
{
	Assert( IsValid( owner ) )

	// play the sonar activated sounds here
	EmitSoundOnEntityExceptToPlayer( owner, owner, "SonarScan_Activate_3p" )
	EmitSoundOnEntityOnlyToPlayer( owner, owner, "SonarScan_Activate_1p" )
}

void function AreaSonarScan_SonarThink( entity owner, vector scanOrigin, vector scanDirection, float scanRadius )
{
	owner.EndSignal( "OnDeath" )
	owner.EndSignal( "OnDestroy" )

	StatusEffect_AddTimed( owner, eStatusEffect.device_detected, 0.01, AreaSonarScan_GetDuration( ), 0.0 )
	StatusEffect_AddTimed( owner, eStatusEffect.sonar_pulse_visuals, 1, AreaSonarScan_GetDuration( ), 0.0 )

// #if SERVER
	// if ( owner.IsPlayer() )
		// owner.Anim_PlayAttackGesture()
// #endif

	int team           = owner.GetTeam()
	vector pulseOrigin = scanOrigin
	array<entity> ents = []

	pulseOrigin = ClampToWorldspace( pulseOrigin )

	bool USE_FASTER_SCAN_LOGIC = GetCurrentPlaylistVarBool( "area_sonar_scan_faster_scan_logic", true )
	owner.e.sonarConeDirection 	= scanDirection
	owner.e.sonarConeFOV 			= AreaSonarScan_GetConeFOV()
	owner.e.sonarConeDetections	= 0

	entity trigger
	int thisAreaScanIndex = -1
	if ( USE_FASTER_SCAN_LOGIC )
	{
		if ( !(owner in file.areaScanTargets) )
			file.areaScanIndex[owner] <- 0
		else
			file.areaScanIndex[owner]++

		if ( !(owner in file.areaScanTargets) )
		{
			table< int, array<entity> > areaScanTargetTable
			file.areaScanTargets[owner] <- areaScanTargetTable
		}

		if ( file.areaScanTargets[owner].len() == 0 )
		{
			file.areaScanIndex[owner] = 0
		}

		thisAreaScanIndex = file.areaScanIndex[owner]


		file.areaScanTargets[owner][thisAreaScanIndex] <- []

		array<entity> enemyPlayers = GetPlayerArrayOfEnemies( team )
		foreach ( enemy in enemyPlayers )
		{
			AreaSonarScan_CheckandScanValidTarget( owner, enemy )
		}

		array<entity> npcArray = GetNPCArray()
		foreach ( npc in npcArray )
		{
			AreaSonarScan_CheckandScanValidTarget( owner, npc )
		}
	}

	else
	{
		trigger = CreateTriggerRadiusMultiple_Deprecated( pulseOrigin, scanRadius, ents, TRIG_FLAG_START_DISABLED | TRIG_FLAG_NO_PHASE_SHIFT )
		SetTeam( trigger, team )
		trigger.SetOwner( owner )
		trigger.RemoveFromAllRealms()
		trigger.AddToOtherEntitysRealms( owner )
		trigger.e.sonarConeDirection 	= scanDirection
		trigger.e.sonarConeFOV 			= AreaSonarScan_GetConeFOV()
		trigger.e.sonarConeDetections	= 0


		if ( HasForceUseCodeTriggers() )
			AddCallback_ScriptTriggerEnter_Deprecated( trigger, AreaSonarScan_OnSonarTriggerEnterForHostileEnts )
		else
			AddCallback_ScriptTriggerEnter_Deprecated( trigger, AreaSonarScan_OnSonarTriggerEnter )

		AddCallback_ScriptTriggerLeave_Deprecated( trigger, AreaSonarScan_OnSonarTriggerLeave )

		ScriptTriggerSetEnabled_Deprecated( trigger, true )
	}

	if ( USE_FASTER_SCAN_LOGIC )
	{
		array<entity> sonarRegisteredPropScripts = GetSonarRegisteredPropScripts( scanOrigin, scanRadius )
		if ( sonarRegisteredPropScripts.len() > 0 )
		{
			foreach ( prop in sonarRegisteredPropScripts )
			{
				entity actualSonarPropScript = GetSonarRegisteredPropScriptFromProxy( prop )
				if ( IsValid( actualSonarPropScript ) )
					prop = actualSonarPropScript

				AreaSonarScan_CheckandScanValidTarget( owner, prop )
			}
		}
	}
	else
	{
		//Create a trigger cylinder that only detects collision with prop scripts that have been registered using AddSonarDetectionForPropScript.
		array<entity> sonarRegisteredPropScripts = GetSonarRegisteredPropScripts( scanOrigin, scanRadius )
		if ( sonarRegisteredPropScripts.len() > 0 )
		{
			thread AreaSonarScan_PropScriptUpdate( owner )
			//		printt( "sonar scan enter props: " + ent )
		}
	}

	//printt( "AreaSonarScan Start, thisScanIndex: " + thisAreaScanIndex )
	//foreach( k, ownerTable in file.areaScanTargets[owner])
	//{
	//	foreach( target in ownerTable )
	//	{
	//		printt( "AreaSonar Scan index: " + k + " target: " +target )
	//	}
	//}

	PassByReferenceBool hasRemovedHighlight
	hasRemovedHighlight.value = false
	OnThreadEnd(
		function() : ( owner, trigger, team, thisAreaScanIndex, hasRemovedHighlight)
		{
			if ( IsValid ( owner ) )
			{
				if ( owner.e.sonarConeDetections > 0 )
				{
					// play the target acquisition end sound here
					 EmitSoundOnEntityOnlyToPlayer( owner, owner, "SonarScan_AcquiredOut_1p" )
				}
			}
			if ( owner in file.areaScanTargets )
			{
				//printt( "AreaSonarScan End, thisScanIndex: " + thisAreaScanIndex )
				//foreach( k, ownerTable in file.areaScanTargets[owner])
				//{
				//	foreach( target in ownerTable )
				//	{
				//		printt( "AreaSonar Scan index: " + k + " target: " +target )
				//	}
				//}

				foreach( target in file.areaScanTargets[owner][thisAreaScanIndex] )
				{
					SonarEnd( target, team, owner, !hasRemovedHighlight.value )

					//printt( "Sonar End: " + target )
					//DebugDrawText( target.GetOrigin(), "sonar count: " + target.e.inSonarTriggerCount, false, AreaSonarScan_GetDuration() )
				}
				delete file.areaScanTargets[owner][thisAreaScanIndex]
			}

			if ( IsValid ( trigger ) )
				trigger.Destroy()

		}
	)



	AreaSonarScan_PlayActivateSound( owner )

	if ( IsValid( owner ) && owner.IsPlayer() )
		Signal( owner, "AreaSonarScan_Activated" )

	int pulseAttachmentID = owner.LookupAttachment( "HEADSHOT" )
	array<entity> players = GetPlayerArray()
	AreaSonarScan_BroadcastPulseConeEffectToPlayers( pulseOrigin, scanRadius, scanDirection, AreaSonarScan_GetConeFOV(), players, team, owner )

	if ( !(owner in file.eyesEffectHandles) )
		file.eyesEffectHandles[owner] <- null

	StartParticleEffectOnEntity( owner, GetParticleSystemIndex( FLASHEFFECT ), FX_PATTACH_POINT_FOLLOW, pulseAttachmentID )
	file.eyesEffectHandles[owner] = StartParticleEffectOnEntity_ReturnEntity( owner, GetParticleSystemIndex( EYEEFFECT ), FX_PATTACH_POINT_FOLLOW, pulseAttachmentID )

	file.eyesEffectHandles[owner].SetOwner( owner )
	file.eyesEffectHandles[owner].kv.VisibilityFlags = (ENTITY_VISIBLE_TO_FRIENDLY | ENTITY_VISIBLE_TO_ENEMY) // not owner only
	thread DestroyAfterDelay( file.eyesEffectHandles[owner], 10.0 )

	int deviceCount = 2 + owner.e.sonarConeDetections //Two device means no devices for our purposes.

	float cappedCount = min ( deviceCount, 13 ) // this gives us a max of 11 that is displayed as 10+ hostiles detected
	float convertedCount = cappedCount * 0.01
	StatusEffect_AddTimed( owner, eStatusEffect.device_detected, convertedCount, AREA_SONAR_SCAN_HUD_FEEDBACK_DURATION, 0.0 )

	float areaScanDuration = AreaSonarScan_GetDuration( )
	float highlightScanDuration = GetScanHighlightDuration( owner )

	wait highlightScanDuration

	foreach( target in file.areaScanTargets[owner][thisAreaScanIndex] )
	{
		SonarEnd_EndHighlight( target, team, owner )
	}
	hasRemovedHighlight.value = true

	if( areaScanDuration > highlightScanDuration )
	{
		wait areaScanDuration - highlightScanDuration
	}
}

void function AreaSonarScan_PropScriptUpdate( entity owner )
{
	Assert( IsNewThread(), "Must be threaded off." )
	owner.EndSignal( "OnDeath" )
	owner.EndSignal( "OnDestroy" )

	int team = owner.GetTeam()
	int attachmentID = owner.LookupAttachment( "CHESTFOCUS" )
	vector pulseOrigin = owner.GetAttachmentOrigin( attachmentID )
	float scanRadius = AreaSonarScan_GetScanRadius()

	array<entity> sonarRegisteredPropScripts = GetSonarRegisteredPropScripts( pulseOrigin, scanRadius )
	entity triggerPropScript = CreateTriggerRadiusMultiple_Deprecated( pulseOrigin, scanRadius, sonarRegisteredPropScripts, TRIG_FLAG_START_DISABLED | TRIG_FLAG_NO_PHASE_SHIFT ) //TODO: Rewrite this so we don't need to pass in an ent array and a filter function AreaSonarScan_OnSonarTriggerEnter
	triggerPropScript.e.sonarConeDirection 	= owner.GetViewForward()
	triggerPropScript.e.sonarConeFOV 		= AreaSonarScan_GetConeFOV()
	SetTeam( triggerPropScript, team )
	triggerPropScript.SetOwner( owner )
	triggerPropScript.RemoveFromAllRealms()
	triggerPropScript.AddToOtherEntitysRealms( owner )

	triggerPropScript.EndSignal( "OnDestroy" )

	OnThreadEnd(
		function() : ( triggerPropScript )
		{
			if ( IsValid( triggerPropScript ) )
				triggerPropScript.Destroy()
		}
	)

	if ( HasForceUseCodeTriggers() )
		AddCallback_ScriptTriggerEnter_Deprecated( triggerPropScript, AreaSonarScan_OnSonarTriggerEnterForPropScript  )
	else
		AddCallback_ScriptTriggerEnter_Deprecated( triggerPropScript, AreaSonarScan_OnSonarTriggerEnter )

	AddCallback_ScriptTriggerLeave_Deprecated( triggerPropScript, AreaSonarScan_OnSonarTriggerLeave )

	ScriptTriggerSetEnabled_Deprecated( triggerPropScript, true )

	wait AreaSonarScan_GetDuration( )
}

void function AreaSonarScan_BroadcastPulseConeEffectToPlayers( vector pulseConeOrigin, float pulseConeRange, vector pulseConeDir, float pulseConeFOV, array<entity> players, int team, entity owner )
{
	foreach ( player in players )
	{
		bool showTrail = ( owner == player )
		if ( owner.DoesShareRealms( player ) )
			Remote_CallFunction_Replay( player, "ServerCallback_SonarPulseConeFromPosition", pulseConeOrigin, pulseConeRange, pulseConeDir, pulseConeFOV, team, 3.0, true, showTrail )
	}
}

void function AreaSonarScan_OnSonarTriggerEnterForHostileEnts( entity trigger, entity ent ) //Filter function to only call AreaSonarScan_OnSonarTriggerEnter for players, NPCs or player Decoys, since that was the behavior under the old script_triggers
{
	if ( IsHostileSonarTarget( trigger.GetOwner(), ent ) )
		AreaSonarScan_OnSonarTriggerEnter( trigger, ent  )
}

void function AreaSonarScan_OnSonarTriggerEnterForPropScript( entity trigger, entity ent ) //Filter function to only call AreaSonarScan_OnSonarTriggerEnter for prop_scripts, since this was registered as the enter callback for a trigger meant for prop_scripts
{
	array<entity> sonarRegisteredPropScripts = GetSonarRegisteredPropScripts( trigger.GetOrigin(), AreaSonarScan_GetScanRadius() )
	if ( sonarRegisteredPropScripts.len() == 0 )
		return

	if ( !sonarRegisteredPropScripts.contains( ent ) )
		return

	entity actualSonarPropScript = GetSonarRegisteredPropScriptFromProxy( ent  )
	if( IsValid( actualSonarPropScript ) )
		ent = actualSonarPropScript

	AreaSonarScan_OnSonarTriggerEnter( trigger, ent  )
}

void function AreaSonarScan_CheckandScanValidTarget( entity owner, entity ent )
{
	if ( !IsEnemyTeam( owner.GetTeam(), ent.GetTeam() ) )
		return

	if ( !ent.DoesShareRealms( owner ) )
		return

	if ( !IsAlive( ent )  )
		return

	//Only ping players that are within our sonar cone.
	vector posToTarget = Normalize( ent.GetCenter() - owner.GetOrigin() )
	float dot = DotProduct( posToTarget, Normalize( owner.e.sonarConeDirection) )
	if ( dot <= 0.0 )
		return
	float angle = DotToAngle( dot )


	//If entity is not in sonar cone don't add it as a target. fudge angle when target is very close
	float distSqr = Distance2DSqr( ent.GetCenter(), owner.GetOrigin() )
	float maxDistSqr = AreaSonarScan_GetScanRadiusSqr()
	if ( distSqr > maxDistSqr )
		return

	float matchAngle = GraphCapped( distSqr, 32*32, 128*128, owner.e.sonarConeFOV, owner.e.sonarConeFOV / 2 )
	if ( angle > matchAngle )
		return

	if ( owner.e.sonarConeDetections == 0 )
	{
		// play targer acquisition "start" sound here
		EmitSoundOnEntityOnlyToPlayer( owner, owner, "SonarScan_AcquireTarget_1p" )
	}

	if ( IsHostileSonarTarget( owner, ent ) && ent.GetTeam() != TEAM_TICK ) //Hardcoded check, we don't want ticks to show up as hostile but we do want them to be highlighted
		owner.e.sonarConeDetections++

	//ent.e.sonarTriggers.append( trigger )
	//printt( "sonar scan enter filtered: " + ent )
	SonarStart( ent, ent.GetOrigin(), owner.GetTeam(), owner )

	StatsHook_AreaSonarScan_EnemyDetected( owner, ent )

	file.areaScanTargets[owner][file.areaScanIndex[owner]].push( ent )

	//printt( "Sonar Start: " + ent )
	//DebugDrawSphere( ent.GetOrigin(), 30, COLOR_YELLOW,false, AreaSonarScan_GetDuration() )
	//DebugDrawText( ent.GetOrigin(), "sonar count: " + ent.e.inSonarTriggerCount, false, AreaSonarScan_GetDuration() )
}

void function AreaSonarScan_OnSonarTriggerEnter( entity trigger, entity ent )
{
	if ( !IsEnemyTeam( trigger.GetTeam(), ent.GetTeam() ) )
		return

	if ( !ent.DoesShareRealms( trigger ) )
		return

	if ( ent.e.sonarTriggers.contains( trigger ) )
		return

	//Only ping players that are within our sonar cone.
	vector posToTarget = Normalize( ent.GetCenter() - trigger.GetOrigin() )
	float dot = DotProduct( posToTarget, trigger.e.sonarConeDirection )
	float angle = DotToAngle( dot )
	entity owner = trigger.GetOwner()

	//If entity is not in sonar cone don't add it as a target. fudge angle when target is very close
	float distSqr = Distance2DSqr( ent.GetCenter(), trigger.GetOrigin() )
	float matchAngle = GraphCapped( distSqr, 32*32, 128*128, trigger.e.sonarConeFOV, trigger.e.sonarConeFOV / 2 )
	if ( angle > matchAngle )
		return

	if ( trigger.e.sonarConeDetections == 0 )
	{
		// play targer acquisition "start" sound here
		EmitSoundOnEntityOnlyToPlayer( owner, owner, "SonarScan_AcquireTarget_1p" )
	}

	if ( IsHostileSonarTarget( owner, ent ) && ent.GetTeam() != TEAM_TICK ) //Hardcoded check, we don't want ticks to show up as hostile but we do want them to be highlighted
		trigger.e.sonarConeDetections++

	ent.e.sonarTriggers.append( trigger )

	SonarStart( ent, ent.GetOrigin(), trigger.GetTeam(), owner )

	StatsHook_AreaSonarScan_EnemyDetected( trigger.GetOwner(), ent )
}

void function AreaSonarScan_OnSonarTriggerLeave( entity trigger, entity ent )
{
	int triggerTeam = trigger.GetTeam()
	if ( !IsEnemyTeam( triggerTeam, ent.GetTeam() ) )
		return

	if ( ent.e.sonarTriggers.contains( trigger ) )
	{
		SonarEnd( ent, triggerTeam, trigger.GetOwner() )
		ent.e.sonarTriggers.fastremovebyvalue( trigger )
	}
}

bool function IsHostileSonarTarget( entity owner, entity ent )
{
	int entTeam = ent.GetTeam()
	if ( !IsEnemyTeam( owner.GetTeam(), entTeam ) )
		return false

	if ( owner == ent )
		return false

	if ( !IsAlive( ent )  )
		return false

	if ( !( ent instanceof CBaseAnimating ) ) //This is needed because when we create the clientside prop dynamic clone for sonar it won't work unless it is also CBaseAnimating. The specific case for this is Bangalore's smoke which creates a trace_volume, which return true for IsAlive() thus bypassing the previous check.
		return false

	string propString = "prop_"
	string ornull className = ent.GetNetworkedClassName()
	if ( className != null )
	{
		expect string( className )
		if ( className.slice( 0, propString.len() ) == propString )
			return false
	}

	if ( !ent.IsPlayer() && !ent.IsNPC() && !ent.IsPlayerDecoy() && ( IsValid( ent.GetBossPlayer() ) || ( IsValid( ent.GetOwner() ) && ent.GetOwner().IsPlayer() ) ) ) //Covers the case for fake AI like Flyers, but excludes stuff like caustic barrels
		return false

	if ( ent.IsNPC() && ent.GetAIClassName() == "marvin" )
		return false

	if ( ent.IsProjectile() )
		return false

	return true
}
#endif

#if CLIENT
void function CreateViemodelSonarFlash( entity ent )
{
	EndSignal( ent, "OnDestroy" )

	entity viewModelArm = ent.GetViewModelArmsAttachment()
	entity viewModelEntity = ent.GetViewModelEntity()
	entity firstPersonProxy = ent.GetFirstPersonProxy()
	entity predictedFirstPersonProxy = ent.GetPredictedFirstPersonProxy()

	//vector highlightColor = statusEffect == eStatusEffect.sonar_detected ? HIGHLIGHT_COLOR_ENEMY : <1,0,0>
	vector highlightColor = <1,0,0>
	if ( StatusEffect_GetSeverity( ent, eStatusEffect.damage_received_multiplier ) > 0.0 )
		highlightColor = <1,0,0>

	if ( IsValid( viewModelArm ) )
		SonarViewModelHighlight( viewModelArm, highlightColor )

	if ( IsValid( viewModelEntity ) )
		SonarViewModelHighlight( viewModelEntity, highlightColor )

	if ( IsValid( firstPersonProxy ) )
		SonarViewModelHighlight( firstPersonProxy, highlightColor )

	if ( IsValid( predictedFirstPersonProxy ) )
		SonarViewModelHighlight( predictedFirstPersonProxy, highlightColor )

	EmitSoundOnEntity( ent, "HUD_MP_EnemySonarTag_Activated_1P" )

	wait 0.5 // Flash Duration - not the most interesting but good enough I hope

	viewModelArm = ent.GetViewModelArmsAttachment()
	viewModelEntity = ent.GetViewModelEntity()
	firstPersonProxy = ent.GetFirstPersonProxy()
	predictedFirstPersonProxy = ent.GetPredictedFirstPersonProxy()

	if ( IsValid( viewModelArm ) )
		SonarViewModelClearHighlight( viewModelArm )

	if ( IsValid( viewModelEntity ) )
		SonarViewModelClearHighlight( viewModelEntity )

	if ( IsValid( firstPersonProxy ) )
		SonarViewModelClearHighlight( firstPersonProxy )

	if ( IsValid( predictedFirstPersonProxy ) )
		SonarViewModelClearHighlight( predictedFirstPersonProxy )
}

void function AreaSonarScan_StartScreenEffect( entity player, int statusEffect, bool actuallyChanged )
{
	entity localViewPlayer = GetLocalViewPlayer()
	if ( player != localViewPlayer )
		return

	entity cockpit = player.GetCockpit()
	if ( !cockpit )
		return

	int indexD        = GetParticleSystemIndex( AREA_SCAN_ACTIVATION_SCREEN_FX )
	file.screeFxHandle = StartParticleEffectOnEntity( cockpit,indexD, FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
	EffectSetIsWithCockpit( file.screeFxHandle, true )

	thread ColorCorrection_LerpWeight( file.colorCorrection, 0, 1, 0.5 )
}

void function AreaSonarScan_StopScreenEffect( entity player, int statusEffect, bool actuallyChanged )
{
	Assert( IsValid( player ) )

	entity localViewPlayer = GetLocalViewPlayer()
	if ( player != localViewPlayer )
		return

	if ( file.screeFxHandle > -1 )
	{
		EffectStop( file.screeFxHandle, false, true )
	}

	thread ColorCorrection_LerpWeight( file.colorCorrection, 1, 0, 0.5 )
}

void function ColorCorrection_LerpWeight( int colorCorrection, float startWeight, float endWeight, float lerpTime = 0 )
{
	float startTime = Time()
	float endTime = startTime + lerpTime
	ColorCorrection_SetExclusive( colorCorrection, true )

	while ( Time() <= endTime )
	{
		WaitFrame()
		float weight = GraphCapped( Time(), startTime, endTime, startWeight, endWeight )
		ColorCorrection_SetWeight( colorCorrection, weight )
	}

	ColorCorrection_SetWeight( colorCorrection, endWeight )
}

#endif //CLIENT

