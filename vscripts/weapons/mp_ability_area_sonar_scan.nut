global function MpAbilityAreaSonarScan_Init

global function OnWeaponActivate_ability_area_sonar_scan
global function OnWeaponPrimaryAttackAnimEvent_ability_area_sonar_scan

#if CLIENT
global function ServerCallback_SonarAreaScanTarget
#endif //CLIENT

const asset FLASHEFFECT    = $"P_sonar_bloodhound"
const asset EYEEFFECT    = $"P_sonar_bloodhound_eyes"
const asset AREA_SCAN_ACTIVATION_SCREEN_FX = $"P_sonar"
const asset FX_SONAR_TARGET = $"P_ar_target_sonar"

const int AREA_SCAN_SKIN_INDEX = 9

const float AREA_SONAR_SCAN_HUD_FEEDBACK_DURATION = 3.0
const float AREA_SONAR_SCAN_DURATION = 2.0
const float AREA_SONAR_SCAN_CONE_FOV = 90.0

struct
{
	int colorCorrection
	int screeFxHandle

#if SERVER
	table< entity, entity > eyesEffectHandles
#endif
} file

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
		thread AreaSonarScan_SonarThink( weaponOwner )
		thread PlayBattleChatterLineDelayedToSpeakerAndTeam( weaponOwner, "bc_tactical", 0.4 )
	#endif //SERVER

	#if CLIENT
//		if ( IsFirstTimePredicted() )
//			thread AreaSonarScan_PlayActivationScreenFX( weaponOwner )
	#endif //CLIENT

	PlayerUsedOffhand( weaponOwner, weapon )

	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_min_to_fire )
}

void function MpAbilityAreaSonarScan_Init()
{
	PrecacheParticleSystem( FLASHEFFECT )
	PrecacheParticleSystem( EYEEFFECT )
	PrecacheParticleSystem( FX_SONAR_TARGET )

	#if CLIENT
		PrecacheParticleSystem( AREA_SCAN_ACTIVATION_SCREEN_FX )
		file.colorCorrection = ColorCorrection_Register( "materials/correction/area_sonar_scan.raw_hdr" )

		StatusEffect_RegisterEnabledCallback( eStatusEffect.sonar_pulse_visuals, AreaSonarScan_StartScreenEffect )
		StatusEffect_RegisterDisabledCallback( eStatusEffect.sonar_pulse_visuals, AreaSonarScan_StopScreenEffect )
	#endif //CLIENT

	RegisterSignal( "AreaSonarScan_Activated" )

}

#if SERVER
void function AreaSonarScan_PlayActivateSound( entity owner )
{
	Assert( IsValid( owner ) )

	// play the sonar activated sounds here
	EmitSoundOnEntityExceptToPlayer( owner, owner, "SonarScan_Activate_3p" )
	EmitSoundOnEntityOnlyToPlayer( owner, owner, "SonarScan_Activate_1p" )
}

void function AreaSonarScan_SonarThink( entity owner )
{
	owner.EndSignal( "OnDeath" )
	owner.EndSignal( "OnDestroy" )

	StatusEffect_AddTimed( owner, eStatusEffect.device_detected, 0.01, AREA_SONAR_SCAN_DURATION, 0.0 )
	StatusEffect_AddTimed( owner, eStatusEffect.sonar_pulse_visuals, 1, AREA_SONAR_SCAN_DURATION, 0.0 )

	int attachmentID = owner.LookupAttachment( "HEADSHOT" )

	int team = owner.GetTeam()
	vector pulseOrigin = owner.GetAttachmentOrigin( attachmentID )
	array<entity> ents = []

	entity trigger = CreateTriggerRadiusMultiple( pulseOrigin, AREA_SONAR_SCAN_RADIUS, ents, TRIG_FLAG_START_DISABLED | TRIG_FLAG_NO_PHASE_SHIFT )
	trigger.e.sonarConeDirection 	= owner.GetViewForward()
	trigger.e.sonarConeFOV 			= AREA_SONAR_SCAN_CONE_FOV
	trigger.e.sonarConeDetections	= 0
	SetTeam( trigger, team )
	trigger.SetOwner( owner )
	trigger.RemoveFromAllRealms()
	trigger.AddToOtherEntitysRealms( owner )

	//Create a trigger cylinder that only detects collision with prop scripts that have been registered using AddSonarDetectionForPropScript.
	array<entity> sonarRegisteredPropScripts = GetSonarRegisteredPropScripts()
	if ( sonarRegisteredPropScripts.len() )
	{
		thread AreaSonarScan_PropScriptUpdate( owner )
	}

	//IncrementSonarPerTeam( team )

	OnThreadEnd(
		function() : ( owner, trigger, team )
		{
			if ( IsValid ( owner ) )
			{
				if ( trigger.e.sonarConeDetections > 0 )
				{
					// play the target acquisition end sound here
					 EmitSoundOnEntityOnlyToPlayer( owner, owner, "SonarScan_AcquiredOut_1p" )
				}

				int deviceCount = 2 + trigger.e.sonarConeDetections //Two device means no devices for our purposes.
				float cappedCount = min ( deviceCount, 12 )
				float convertedCount = cappedCount * 0.01
				StatusEffect_AddTimed( owner, eStatusEffect.device_detected, convertedCount, AREA_SONAR_SCAN_HUD_FEEDBACK_DURATION, 0.0 )
			}

			//DecrementSonarPerTeam( team )
			trigger.Destroy()
		}
	)

	AddCallback_ScriptTriggerEnter( trigger, AreaSonarScan_OnSonarTriggerEnter )
	ScriptTriggerSetEnabled( trigger, true )

	AreaSonarScan_PlayActivateSound( owner )

	if ( IsValid( owner ) && owner.IsPlayer() )
		Signal( owner, "AreaSonarScan_Activated" )

	int pulseAttachmentID = owner.LookupAttachment( "HEADSHOT" )
	array<entity> players = GetPlayerArray()
	AreaSonarScan_BroadcastPulseConeEffectToPlayers( pulseOrigin, trigger.e.sonarConeDirection, trigger.e.sonarConeFOV, players, team, owner )

	if ( !(owner in file.eyesEffectHandles) )
		file.eyesEffectHandles[owner] <- null

	StartParticleEffectOnEntity( owner, GetParticleSystemIndex( FLASHEFFECT ), FX_PATTACH_POINT_FOLLOW, pulseAttachmentID )
	file.eyesEffectHandles[owner] = StartParticleEffectOnEntity_ReturnEntity( owner, GetParticleSystemIndex( EYEEFFECT ), FX_PATTACH_POINT_FOLLOW, pulseAttachmentID )

	file.eyesEffectHandles[owner].SetOwner( owner )
	file.eyesEffectHandles[owner].kv.VisibilityFlags = (ENTITY_VISIBLE_TO_FRIENDLY | ENTITY_VISIBLE_TO_ENEMY) // not owner only

	WaitFrame()
//	wait AREA_SONAR_SCAN_DURATION
}

void function AreaSonarScan_PropScriptUpdate( entity owner )
{
	Assert( IsNewThread(), "Must be threaded off." )
	owner.EndSignal( "OnDeath" )
	owner.EndSignal( "OnDestroy" )

	int team = owner.GetTeam()
	int attachmentID = owner.LookupAttachment( "CHESTFOCUS" )
	vector pulseOrigin = owner.GetAttachmentOrigin( attachmentID )

	array<entity> sonarRegisteredPropScripts = GetSonarRegisteredPropScripts()
	entity triggerPropScript = CreateTriggerRadiusMultiple( pulseOrigin, AREA_SONAR_SCAN_RADIUS, sonarRegisteredPropScripts, TRIG_FLAG_START_DISABLED | TRIG_FLAG_NO_PHASE_SHIFT )
	triggerPropScript.e.sonarConeDirection 	= owner.GetViewForward()
	triggerPropScript.e.sonarConeFOV 		= AREA_SONAR_SCAN_CONE_FOV
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

	AddCallback_ScriptTriggerEnter( triggerPropScript, AreaSonarScan_OnSonarTriggerEnter )
	ScriptTriggerSetEnabled( triggerPropScript, true )

	wait AREA_SONAR_SCAN_DURATION
}

void function AreaSonarScan_BroadcastPulseConeEffectToPlayers( vector pulseConeOrigin, vector pulseConeDir, float pulseConeFOV, array<entity> players, int team, entity owner )
{
	foreach ( player in players )
	{
		bool showTrail = ( owner == player )
		if ( owner.DoesShareRealms( player ) )
			Remote_CallFunction_Replay( player, "ServerCallback_SonarPulseConeFromPosition", pulseConeOrigin, AREA_SONAR_SCAN_RADIUS, pulseConeDir, pulseConeFOV, team, 3.0, true, showTrail )
	}
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

	if ( IsHostileSonarTarget( owner, ent ) )
		trigger.e.sonarConeDetections++

	ent.e.sonarTriggers.append( trigger )

	// remote call everyone on the bloodhound team
	array<entity> teamPlayers = GetPlayerArrayOfTeam_AliveConnected( owner.GetTeam() )
	foreach ( player in teamPlayers )
		Remote_CallFunction_Replay( player, "ServerCallback_SonarAreaScanTarget", ent, owner )

	// remote call the sonar target if it's a player
	if ( ent.IsPlayer() )
		Remote_CallFunction_Replay( ent, "ServerCallback_SonarAreaScanTarget", ent, owner )

	StatsHook_AreaSonarScan_EnemyDetected( trigger.GetOwner(), ent )
}

bool function IsHostileSonarTarget( entity owner, entity ent )
{
	if ( !ent.IsPlayer() && !ent.IsNPC() )
		return false

	if ( ent.GetTeam() == 100 )
		return false

	return true
}
#endif

#if CLIENT

void function ServerCallback_SonarAreaScanTarget( entity sonarTarget, entity owner )
{
	entity viewPlayer = GetLocalViewPlayer()
	int viewPlayerTeam = viewPlayer.GetTeam()
	int ownerTeam = owner.GetTeam()

	if ( sonarTarget == GetLocalViewPlayer() )
		thread CreateViemodelSonarFlash( sonarTarget )
	else if ( viewPlayerTeam == ownerTeam )
		thread CreateSonarCloneForEnt( sonarTarget, owner )
}

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

void function CreateSonarCloneForEnt( entity sonarTarget, entity owner )
{
	entity entClone = CreateClientSidePropDynamicClone( sonarTarget, sonarTarget.GetModelName() )
	if ( !IsValid( entClone ) ) //JFS - Could further investigate why this particular function can return null. Code comment was referring to TF1 stuff.
		return

	EndSignal( entClone, "OnDestroy" )
	SonarPlayerCloneHighlight( entClone )

	int fxid = GetParticleSystemIndex( FX_SONAR_TARGET )
	int fxHandle = -1

	if ( owner == GetLocalViewPlayer() )
	{
		fxHandle = StartParticleEffectOnEntity( entClone, fxid, FX_PATTACH_POINT_FOLLOW_NOROTATE, entClone.LookupAttachment( "CHESTFOCUS" ) )
	}

	OnThreadEnd(
		function() : ( fxHandle )
		{
			if ( EffectDoesExist( fxHandle ) )
				EffectStop( fxHandle, true, true )
		}
	)

	wait AREA_SONAR_SCAN_DURATION
	entClone.Destroy()
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