global function OnWeaponPrimaryAttack_hunt_mode
global function MpAbilityHuntModeWeapon_Init
global function MpAbilityHuntModeWeapon_OnWeaponTossPrep
global function OnWeaponDeactivate_hunt_mode

#if DEVELOPER && CLIENT
global function GetBloodhoundColorCorrectionID
#endif //DEVELOPER && CLIENT

const float HUNT_MODE_DURATION = 30.0
const float HUNT_MODE_KNOCKDOWN_TIME_BONUS = 5.0
const int HUNT_MODE_KNOCKDOWN_HEAL_BONUS = 50 //Upgrade
const asset HUNT_MODE_ACTIVATION_SCREEN_FX = $"P_hunt_screen"
const asset HUNT_MODE_BODY_FX = $"P_hunt_body"

struct
{
	#if CLIENT
		int colorCorrection = -1
	#endif //CLIENT
	#if SERVER
		table<entity, float> huntModeEndTimes
		float                sonarRange = 0.0
	#endif
} file

void function MpAbilityHuntModeWeapon_Init()
{
	#if SERVER
		PrecacheParticleSystem( HUNT_MODE_BODY_FX )
		Bleedout_AddCallback_OnPlayerStartBleedout( HuntMode_OnPlayerStartBleedout ) //Handle Kills on Non-Bleeding Out Targets
		AddCallback_OnPlayerKilled( HuntMode_OnPlayerKilled ) //Handle Kills on Non-Bleeding Out Targets

		file.sonarRange = GetCurrentPlaylistVarFloat( "bloodhound_ult_sonar_range", 0.0 )
	#endif //SERVER

	RegisterSignal( "HuntMode_ForceAbilityStop" )
	RegisterSignal( "HuntMode_End" )
	AddCallback_GameStateEnter( eGameState.WinnerDetermined, StopHuntMode )

	#if CLIENT
		RegisterSignal( "HuntMode_StopColorCorrection" )
		RegisterSignal( "HuntMode_StopActivationScreenFX" )
		//file.colorCorrection = ColorCorrection_Register_WRAPPER( "materials/correction/hunt_mode.raw" )
		file.colorCorrection = ColorCorrection_Register( "materials/correction/ability_hunt_mode.raw_hdr" )
		PrecacheParticleSystem( HUNT_MODE_ACTIVATION_SCREEN_FX )
		StatusEffect_RegisterEnabledCallback( eStatusEffect.hunt_mode, HuntMode_StartEffect )
		StatusEffect_RegisterDisabledCallback( eStatusEffect.hunt_mode, HuntMode_StopEffect )
		StatusEffect_RegisterEnabledCallback( eStatusEffect.hunt_mode_visuals, HuntMode_StartVisualEffect )
		StatusEffect_RegisterDisabledCallback( eStatusEffect.hunt_mode_visuals, HuntMode_StopVisualEffect )
	#endif

}

float function HuntMode_GetExtendedDuration()
{
	return GetCurrentPlaylistVarFloat( "bloodhound_ult_upgraded_duration", 40 )
}

float function HuntMode_GetDuration( entity player )
{
	float result = HUNT_MODE_DURATION

	// if( PlayerHasPassive( player, ePassives.PAS_ULT_UPGRADE_ONE ) ) // upgrade_bloodhound_extended_hunt
	// {
		// return HuntMode_GetExtendedDuration()
	// }
    
	return result
}

#if SERVER
void function HuntMode_TryRegenOnKnock( entity attacker )
{
	// if( PlayerHasPassive( attacker, ePassives.PAS_ULT_UPGRADE_TWO ) ) // upgrade_bloodhound_knock_regen_during_hunt
	// {
		int health = attacker.GetHealth()
		int newHealth = minint( health + HUNT_MODE_KNOCKDOWN_HEAL_BONUS, attacker.GetMaxHealth() )
		attacker.SetHealth( newHealth )
	// }
}

void function HuntMode_OnPlayerKilled( entity victim, entity attacker, var damageInfo )
{
	//PrintFunc()
	if ( !IsValid( attacker ) )
		return

	float timeRemaining = StatusEffect_GetTimeRemaining( attacker, eStatusEffect.hunt_mode )
	if ( timeRemaining > 0.0 && (attacker in file.huntModeEndTimes) )
	{
		if ( !Bleedout_IsBleedingOut( victim ) )
		{
			// if ( PlayerHasPassive( attacker, ePassives.PAS_ULT_UPGRADE_THREE ) ) // upgrade_bloodhound_knock_extends_ult
			{
				float extension = CalculateTimeExtension( timeRemaining )
				file.huntModeEndTimes[attacker] += extension
				StatusEffect_StopAllOfType( attacker, eStatusEffect.hunt_mode )
				StatusEffect_StopAllOfType( attacker, eStatusEffect.hunt_mode_visuals )
				StatusEffect_AddTimed( attacker, eStatusEffect.hunt_mode, 1.0, timeRemaining + extension, HuntMode_GetDuration( attacker ) )
				StatusEffect_AddTimed( attacker, eStatusEffect.hunt_mode_visuals, 1.0, timeRemaining + extension, 5.0 )

				int extensionFloatToInt = int( extension )
				float extensionRounded  = float( extensionFloatToInt )

				// Remote_CallFunction_Replay( attacker, "ServerCallback_ShowUltTimeIncreasedHint", attacker, extensionRounded )
         
			}

			HuntMode_TryRegenOnKnock( attacker )
			
			bool isValidMode = true

			if ( isValidMode )
			{
				entity tacticalWeapon = attacker.GetOffhandWeapon( OFFHAND_TACTICAL )
				if( IsValid( tacticalWeapon ) )
				{
					int currentAmmo       = tacticalWeapon.GetWeaponPrimaryClipCount()
					int maxAmmo           = tacticalWeapon.GetWeaponPrimaryClipCountMax()
					if ( currentAmmo != maxAmmo )
						tacticalWeapon.SetWeaponPrimaryClipCount( maxAmmo )
				}
			}
        
		}
	}

	if ( IsValid( victim ) && StatusEffect_GetTimeRemaining( victim, eStatusEffect.hunt_mode ) > 0.0 )
	{
		StatusEffect_StopAllOfType( victim, eStatusEffect.hunt_mode )
		StatusEffect_StopAllOfType( victim, eStatusEffect.hunt_mode_visuals )
	}
}

float function CalculateTimeExtension( float remainingTime )
{
	float timeExtensionStart         = GetCurrentPlaylistVarFloat( "bloodhound_ult_extension_start_time", 10.0 )
	float timeExtensionEnd           = GetCurrentPlaylistVarFloat( "bloodhound_ult_extension_end_time", 2.0 )
	float timeExtensionMaxMultiplier = GetCurrentPlaylistVarFloat( "bloodhound_ult_extension_max_multiplier", 3.0 )
	float adjustedExtension          = GraphCapped( remainingTime, timeExtensionStart, timeExtensionEnd, HUNT_MODE_KNOCKDOWN_TIME_BONUS, HUNT_MODE_KNOCKDOWN_TIME_BONUS * timeExtensionMaxMultiplier )
	return adjustedExtension
}

void function HuntMode_OnPlayerStartBleedout( entity player, entity attacker, var damageInfo )
{
	float timeRemaining = StatusEffect_GetTimeRemaining( attacker, eStatusEffect.hunt_mode )
	if ( (attacker in file.huntModeEndTimes) && timeRemaining > 0.0 )
	{
		HuntMode_TryRegenOnKnock( attacker )
		
		bool isValidMode = true

		if ( isValidMode )
		{
			entity tacticalWeapon = player.GetOffhandWeapon( OFFHAND_TACTICAL )
			int currentAmmo       = tacticalWeapon.GetWeaponPrimaryClipCount()
			int maxAmmo           = tacticalWeapon.GetWeaponPrimaryClipCountMax()
			if ( currentAmmo != maxAmmo )
				tacticalWeapon.SetWeaponPrimaryClipCount( maxAmmo )
		}
	}

	if ( IsValid( player ) && StatusEffect_GetTimeRemaining( player, eStatusEffect.hunt_mode ) > 0.0 )
	{
		StatusEffect_StopAllOfType( player, eStatusEffect.hunt_mode )
		StatusEffect_StopAllOfType( player, eStatusEffect.hunt_mode_visuals )
	}
}

#endif

void function MpAbilityHuntModeWeapon_OnWeaponTossPrep( entity weapon, WeaponTossPrepParams prepParams )
{
	entity weaponOwner = weapon.GetWeaponOwner()
	weapon.SetScriptTime0( 0.0 )

	#if SERVER
		thread PlayBattleChatterLineDelayedToSpeakerAndTeam( weaponOwner, "bc_super", 0.1 )

		Embark_Disallow( weaponOwner )
		DisableMantle( weaponOwner )
		LockWeaponsAndMelee( weaponOwner )

		// temp fix to stop the issue with wallclimb holstering weapons.
		const ACTIVATION_TIME = 2.1
		StatusEffect_AddTimed( weaponOwner, eStatusEffect.disable_wall_run_and_double_jump, 1.0, ACTIVATION_TIME, 0.0 )
	#endif
}


var function OnWeaponPrimaryAttack_hunt_mode( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity weaponOwner = weapon.GetWeaponOwner()
	Assert ( weaponOwner.IsPlayer() )

	//Activate hunt mode
	HuntMode_Start( weaponOwner )

	PlayerUsedOffhand( weaponOwner, weapon )

	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_min_to_fire )
}


void function OnWeaponDeactivate_hunt_mode( entity weapon )
{
	entity weaponOwner = weapon.GetWeaponOwner()

	#if SERVER
		Embark_Allow( weaponOwner )
		EnableMantle( weaponOwner )
		UnlockWeaponsAndMelee( weaponOwner )
	#endif //SERVER
}


void function HuntMode_Start( entity player )
{
	array<int> ids = []
	ids.append( StatusEffect_AddEndless( player, eStatusEffect.threat_vision, 1.0 ) )
	ids.append( StatusEffect_AddEndless( player, eStatusEffect.speed_boost, 0.15 ) )

	float huntDuration = HuntMode_GetDuration( player )
	ids.append( StatusEffect_AddTimed( player, eStatusEffect.hunt_mode, 1.0, huntDuration, huntDuration ) )
	ids.append( StatusEffect_AddTimed( player, eStatusEffect.hunt_mode_visuals, 1.0, huntDuration, 5.0 ) )

	#if SERVER
		if ( player in file.huntModeEndTimes )
			file.huntModeEndTimes[player] = Time() + huntDuration
		else
			file.huntModeEndTimes[player] <- Time() + huntDuration
		//EmitSoundOnEntityOnlyToPlayer( player, player, "beastofthehunt_activate_1P" )
		EmitSoundOnEntityExceptToPlayer( player, player, "beastofthehunt_activate_3P" )

		thread HuntMode_PlayLoopingBodyFx( player )
		thread HuntMode_HandleStatusEffects( player, ids )

		if ( file.sonarRange > 0.0 )
		{
			thread HuntMode_ScanTargets( player )
		}
	#endif
}


void function EndThreadOn_HuntCommon( entity player )
{
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "HuntMode_ForceAbilityStop" )
	player.EndSignal( "BleedOut_OnStartDying" )

	#if SERVER
		player.EndSignal( "CleanUpPlayerAbilities" )
		EndThreadOn_PlayerChangedClass( player )
	#endif // SERVER
}

#if SERVER
void function HuntMode_ScanTargets( entity player )
{
	player.EndSignal( "OnDeath" )
	player.EndSignal( "HuntMode_ForceAbilityStop" )
	player.EndSignal( "HuntMode_End" )

	entity trigger = CreateEntity( "trigger_cylinder" )
	trigger.RemoveFromAllRealms()
	trigger.AddToOtherEntitysRealms( player )
	trigger.SetRadius( file.sonarRange )
	trigger.SetAboveHeight( file.sonarRange )
	trigger.SetBelowHeight( file.sonarRange ) // Need this because the player or entity can sink into the ground a tiny bit and we check player feet not half height
	trigger.SetOrigin( player.GetOrigin() )
	trigger.kv.triggerFilterNpc = "all"
	trigger.kv.triggerFilterPlayer = "pilot"
	trigger.kv.triggerFilterNonCharacter = 0
	trigger.kv.triggerFilterTeamIMC = 1
	trigger.kv.triggerFilterTeamMilitia = 1
	trigger.kv.triggerFilterTeamOther = 1 // this is key for survival
	trigger.SetEnterCallback( void function( entity trigger, entity ent ) : ( player ) {
		SonarTrigger_OnEnter( trigger, player, ent )
	} )
	trigger.SetLeaveCallback( void function( entity trigger, entity ent ) : ( player ) {
		SonarTrigger_OnLeave( trigger, player, ent )
	} )
	DispatchSpawn( trigger )
	thread TriggerTrackOwner( trigger, player )

	OnThreadEnd(
		function() : ( trigger )
		{
			trigger.Destroy()
		}
	)

	trigger.SearchForNewTouchingEntity()

	WaitForever()
}

void function TriggerTrackOwner( entity trigger, entity owner )
{
	owner.EndSignal( "OnDestroy" )
	trigger.EndSignal( "OnDestroy" )

	while ( true )
	{
		trigger.SetOrigin( owner.GetOrigin() )
		WaitFrame()
	}
}

void function SonarTrigger_OnEnter( entity trigger, entity player, entity ent )
{
	trigger.e.attachedEnts.append( ent )
	thread EntitySonarThink( trigger, player, ent )
}

void function SonarTrigger_OnLeave( entity trigger, entity player, entity ent )
{
	trigger.e.attachedEnts.fastremovebyvalue( ent )
}

void function EntitySonarThink( entity trigger, entity weaponOwner, entity ent )
{
	trigger.EndSignal( "OnDestroy" )
	ent.EndSignal( "OnDestroy" )
	weaponOwner.EndSignal( "OnDeath" )
	weaponOwner.EndSignal( "HuntMode_ForceAbilityStop" )
	weaponOwner.EndSignal( "HuntMode_End" )

	if ( !ent.DoesShareRealms( weaponOwner ) )
		return

	ent.EndSignal( "OnDeath" )

	if ( ent == weaponOwner )
		return

	if ( IsFriendlyTeam( ent.GetTeam(), weaponOwner.GetTeam() ) )
		return

	table<string, bool> e
	e[ "sonared" ] <- false

	OnThreadEnd(
		function() : ( ent, weaponOwner, e )
		{
			if ( IsValid( ent ) )
			{
				if ( e[ "sonared" ] )
				{
					SonarEnd( ent, weaponOwner.GetTeam(), weaponOwner )
				}
			}
		}
	)

	while ( IsValid( ent ) )
	{
		if ( !trigger.e.attachedEnts.contains( ent ) && !IsCodeDoor( ent ) )
			return

		if ( !e["sonared"] )
		{
			if ( TargetShouldBeSonared( ent, weaponOwner ) )
			{
				e["sonared"] <- true
				SonarStart( ent, ent.GetOrigin(), weaponOwner.GetTeam(), weaponOwner )
			}
		}
		else
		{
			if ( !TargetShouldBeSonared( ent, weaponOwner ) )
			{
				e["sonared"] <- false
				SonarEnd( ent, weaponOwner.GetTeam(), weaponOwner )
			}
		}

		WaitFrame()
	}
}

bool function TargetShouldBeSonared( entity ent, entity looker )
{
	float minDot = deg_cos( 70.0 )

	vector origin = looker.EyePosition()
	vector fwd    = looker.GetViewVector()

	vector entCenter = ent.GetCenter()
	vector v1        = Normalize( entCenter - origin )
	float dot        = DotProduct2D( fwd, v1 )

	if ( dot < minDot )
		return false

	TraceResults results = TraceLine( origin, entCenter, [ looker, ent ], TRACE_MASK_VISIBLE, TRACE_COLLISION_GROUP_NONE )

	if ( results.fraction < 0.99 )
		return false
	
	if( StatusEffect_GetSeverity( ent, eStatusEffect.smokescreen ) > 0.0 )
		return false
	
	return true
}

void function HuntMode_HandleStatusEffects( entity player, array<int> ids )
{
	Assert( IsNewThread(), "Must be threaded off." )

	EndThreadOn_HuntCommon( player )

	table<string, bool> e
	e[ "addedMod" ] <- false

	entity tacticalAbility = player.GetOffhandWeapon( OFFHAND_LEFT )
	int tacClipCount = tacticalAbility.GetWeaponPrimaryClipCount()
	int tacStockpile = tacticalAbility.GetWeaponPrimaryAmmoCount( AMMOSOURCE_STOCKPILE )

	array<string> currentTacMods = tacticalAbility.GetMods()

	// Only the server will force the status effect to end in special circumstances
	// Typical case is for the client to let the status effect time out naturally (in addition to the server stopping it after the fact)
	OnThreadEnd(
		function() : ( player, ids, e, tacticalAbility, tacClipCount, tacStockpile )
		{
			array<string> currentTacMods = tacticalAbility.GetMods()
			if ( IsValid( tacticalAbility ) && e[ "addedMod" ] )
			{
				if ( currentTacMods.contains( "tac_cd_in_ult" ) )
				{
					tacticalAbility.RemoveMod( "tac_cd_in_ult" )
				}
			}

			if ( IsValid( player ) )
			{
				player.Signal( "HuntMode_End" )

				foreach ( id in ids )
					StatusEffect_Stop( player, id )
			}
		}
	)

	while( Time() < file.huntModeEndTimes[player] )
	{
		WaitFrame()
	}
}

void function HuntMode_PlayLoopingBodyFx( entity player )
{
	Assert ( IsNewThread(), "Must be threaded off." )
	EndThreadOn_HuntCommon( player )

	int AttachmentID = player.LookupAttachment( "HEADSHOT" )
	int fxid         = GetParticleSystemIndex( HUNT_MODE_BODY_FX )

	entity fxHandle = StartParticleEffectOnEntity_ReturnEntity( player, fxid, FX_PATTACH_POINT_FOLLOW, AttachmentID )

	EmitSoundOnEntityOnlyToPlayer( player, player, "beastofthehunt_loop_1P" )
	EmitSoundOnEntityExceptToPlayer( player, player, "beastofthehunt_loop_3P" )

	fxHandle.SetOwner( player )
	int visFlags = (ENTITY_VISIBLE_TO_FRIENDLY | ENTITY_VISIBLE_TO_ENEMY) // not owner only
	if ( player.IsThirdPersonShoulderModeOn() )
		visFlags = (visFlags | ENTITY_VISIBLE_TO_OWNER)

	fxHandle.kv.VisibilityFlags = visFlags

	OnThreadEnd(
		function() : ( player, fxHandle )
		{
			if ( IsValid( fxHandle ) )
				EffectStop( fxHandle )

			if ( IsValid( player ) )
			{
				StopSoundOnEntity( player, "beastofthehunt_loop_1P" )
				StopSoundOnEntity( player, "beastofthehunt_loop_3P" )
			}
		}
	)

	bool endIsPlaying = false
	const FADE_DURATION = 2.0
	while( Time() < file.huntModeEndTimes[player] )
	{
		if ( endIsPlaying == false && Time() > file.huntModeEndTimes[player] - FADE_DURATION )
		{
			endIsPlaying = true

			StopSoundOnEntity( player, "beastofthehunt_loop_1P" )
			StopSoundOnEntity( player, "beastofthehunt_loop_3P" )

			EmitSoundOnEntityOnlyToPlayer( player, player, "BeastOfTheHunt_End_1p" )
			EmitSoundOnEntityExceptToPlayer( player, player, "BeastOfTheHunt_End_3p" )
		}

		if ( endIsPlaying == true && Time() < file.huntModeEndTimes[player] - FADE_DURATION )
		{
			endIsPlaying = false

			EmitSoundOnEntityOnlyToPlayer( player, player, "beastofthehunt_loop_1P" )
			EmitSoundOnEntityExceptToPlayer( player, player, "beastofthehunt_loop_3P" )

			StopSoundOnEntity( player, "BeastOfTheHunt_End_1p" )
			StopSoundOnEntity( player, "BeastOfTheHunt_End_3p" )
		}
		WaitFrame()
	}

}

#endif //SERVER

#if CLIENT
void function HuntMode_UpdatePlayerScreenColorCorrection( entity player )
{
	Assert ( IsNewThread(), "Must be threaded off." )
	Assert ( player == GetLocalViewPlayer() )

	EndThreadOn_HuntCommon( player )
	player.EndSignal( "HuntMode_StopColorCorrection" )
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )

	OnThreadEnd(
		function() : ( player )
		{
			ColorCorrection_SetWeight( file.colorCorrection, 0.0 )
			ColorCorrection_SetExclusive( file.colorCorrection, false )
		}
	)

	ColorCorrection_SetExclusive( file.colorCorrection, true )
	ColorCorrection_SetWeight( file.colorCorrection, 1.0 )

	const FOV_SCALE = 1.2
	const LERP_IN_TIME = 0.0125    // hack! because statusEffect doesn't seem to have a lerp in feature?
	float startTime = Time()

	while ( true )
	{
		float weight = StatusEffect_GetSeverity( player, eStatusEffect.hunt_mode_visuals )
		//printt( weight )
		weight = GraphCapped( Time() - startTime, 0, LERP_IN_TIME, 0, weight )

		ColorCorrection_SetWeight( file.colorCorrection, weight )

		WaitFrame()
	}
}

void function HuntMode_StartEffect( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( !actuallyChanged && GetLocalViewPlayer() == GetLocalClientPlayer() )
		return

	if ( ent != GetLocalViewPlayer() )
		return
}

void function HuntMode_StopEffect( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( !actuallyChanged && GetLocalViewPlayer() == GetLocalClientPlayer() )
		return

	if ( ent != GetLocalViewPlayer() )
		return
}

void function HuntMode_StartVisualEffect( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( !actuallyChanged && GetLocalViewPlayer() == GetLocalClientPlayer() )
		return

	if ( ent != GetLocalViewPlayer() )
		return

	GfxDesaturate( true )
	Chroma_StartHuntMode()
	thread HuntMode_UpdatePlayerScreenColorCorrection( ent )
	thread HuntMode_PlayActivationScreenFX( ent )
}

void function HuntMode_StopVisualEffect( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( !actuallyChanged && GetLocalViewPlayer() == GetLocalClientPlayer() )
		return

	if ( ent != GetLocalViewPlayer() )
		return

	GfxDesaturate( false )
	Chroma_EndHuntMode()
	ent.Signal( "HuntMode_StopColorCorrection" )
	ent.Signal( "HuntMode_StopActivationScreenFX" )
}

void function HuntMode_PlayActivationScreenFX( entity clientPlayer )
{
	Assert ( IsNewThread(), "Must be threaded off." )
	EndThreadOn_HuntCommon( clientPlayer )

	entity viewPlayer = GetLocalViewPlayer()
	int fxid          = GetParticleSystemIndex( HUNT_MODE_ACTIVATION_SCREEN_FX )

	int fxHandle = StartParticleEffectOnEntity( viewPlayer, fxid, FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
	EffectSetIsWithCockpit( fxHandle, true )
	Effects_SetParticleFlag( fxHandle, PARTICLE_SCRIPT_FLAG_NO_DESATURATE, true )


	OnThreadEnd(
		function() : ( clientPlayer, fxHandle )
		{
			if ( IsValid( clientPlayer ) )
			{
				if ( EffectDoesExist( fxHandle ) )
					EffectStop( fxHandle, false, true )
			}
		}
	)

	clientPlayer.WaitSignal( "HuntMode_StopActivationScreenFX" )
}

#endif //CLIENT

void function StopHuntMode()
{
	#if CLIENT
		entity player = GetLocalViewPlayer()
		player.Signal( "HuntMode_ForceAbilityStop" )
	#else
		array<entity> playerArray = GetPlayerArray()
		foreach ( player in playerArray )
			player.Signal( "HuntMode_ForceAbilityStop" )
	#endif
}

#if DEVELOPER && CLIENT
int function GetBloodhoundColorCorrectionID()
{
	return file.colorCorrection
}
#endif //DEVELOPER && CLIENT
