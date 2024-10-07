//Updated by @CafeFPS based on S21 scripts

global function MpAbilityPhaseWalk_Init

global function OnWeaponActivate_ability_phase_walk
global function OnWeaponAttemptOffhandSwitch_ability_phase_walk
global function OnWeaponChargeBegin_ability_phase_walk
global function OnWeaponChargeEnd_ability_phase_walk

const string SOUND_ACTIVATE_1P = "pilot_phaseshift_firstarmraise_1p" // Play (to 1p only) as soon as the "arm raise" animation for placing the first gate starts (basically as soon as the ability key is pressed and the ability successfully starts).
const string SOUND_ACTIVATE_3P = "pilot_phaseshift_firstarmraise_3p" // Play (to everyone except 1p) as soon as the 3p Wraith begins activating the ability to place the first gate.

const float PHASE_WALK_PRE_TELL_TIME = 1.5
const asset PHASE_WALK_APPEAR_PRE_FX = $"P_phase_dash_pre_end_mdl"

struct
{
	#if SERVER
	table< entity, bool > hasLockedWeaponsAndMelee
	#endif
} file

void function MpAbilityPhaseWalk_Init()
{
	PrecacheParticleSystem( PHASE_WALK_APPEAR_PRE_FX )
}

void function OnWeaponActivate_ability_phase_walk( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	float deploy_time = weapon.GetWeaponSettingFloat( eWeaponVar.deploy_time )
	
	#if SERVER
		EmitSoundOnEntityExceptToPlayer( player, player, "pilot_phaseshift_armraise_3p" )

	if ( player.GetActiveWeapon( eActiveInventorySlot.mainHand ) != player.GetOffhandWeapon( OFFHAND_INVENTORY ) )
		PlayBattleChatterLineToSpeakerAndTeam( player, "bc_tactical" )
	#endif
	
	if ( !weapon.HasMod( "ult_active" ) )
	{
		#if SERVER
			EmitSoundOnEntityExceptToPlayer( player, player, SOUND_ACTIVATE_3P )
		#endif

		#if CLIENT
			if ( !InPrediction() )
				return

			EmitSoundOnEntity( player, SOUND_ACTIVATE_1P )
		#endif

		float amount = GetCurrentPlaylistVarFloat( "wraith_phase_walk_slow_amount", 0.2 )
		StatusEffect_AddTimed( player, eStatusEffect.move_slow, amount, deploy_time, deploy_time )	
	}
}

bool function OnWeaponAttemptOffhandSwitch_ability_phase_walk( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	if ( IsValid( player ) && player.IsPhaseShifted() )
		return false

	return true
}

bool function OnWeaponChargeBegin_ability_phase_walk( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	float chargeTime = weapon.GetWeaponSettingFloat( eWeaponVar.charge_time )

	bool doStatus = true
	#if CLIENT
		if ( !InPrediction() )
			doStatus = false
	#endif

	if ( doStatus )
	{
		int speedHandle = StatusEffect_AddTimed( player, eStatusEffect.speed_boost, 0.3, chargeTime, chargeTime * 0.3 )

		#if SERVER
		weapon.w.statusEffects.append( speedHandle )
		#endif
	}
	
	#if SERVER
	thread PhaseWalk_Thread( player, chargeTime )
	PlayerUsedOffhand( player, weapon )
	#endif
	
	PhaseShift( player, 0, chargeTime, eShiftStyle.Balance )
	return true
}

#if SERVER
void function PhaseWalk_Thread( entity player, float chargeTime )
{
	player.EndSignal( "OnDeath" )
	player.EndSignal( "BleedOut_OnStartDying" )
	player.EndSignal( "ForceStopPhaseShift" )

	ForceAutoSprintOn( player )

	LockWeaponsAndMelee( player )
	file.hasLockedWeaponsAndMelee[player] <- true

	//StatsHook_Tactical_TimeSpentInPhase( player, chargeTime )
	TrackingVision_CreatePOI( eTrackingVisionNetworkedPOITypes.PLAYER_ABILITIES_PHASE_DASH_START, player, player.GetOrigin(), player.GetTeam(), player )

	entity dashFX

	OnThreadEnd(
	function() : ( player, dashFX )
		{
			if ( IsValid( player ) )
			{
				TrackingVision_CreatePOI( eTrackingVisionNetworkedPOITypes.PLAYER_ABILITIES_PHASE_DASH_STOP, player, player.GetOrigin(), player.GetTeam(), player )
				ForceAutoSprintOff( player )

          
			}
			if ( player in file.hasLockedWeaponsAndMelee && file.hasLockedWeaponsAndMelee[player]  )
			{
				if ( IsValid( player ) )
				{
					UnlockWeaponsAndMelee( player )
				}
				file.hasLockedWeaponsAndMelee[player] <- false
			}
			if ( IsValid( dashFX ) )
			{
				EffectStop( dashFX )
			}
		}
	)

	float tellWait = chargeTime - PHASE_WALK_PRE_TELL_TIME
	wait tellWait

	asset fxAsset = PHASE_WALK_APPEAR_PRE_FX
	int fxid     = GetParticleSystemIndex( fxAsset )
	int attachId = player.LookupAttachment( "ORIGIN" )

	dashFX = StartParticleEffectOnEntity_ReturnEntity( player, fxid, FX_PATTACH_POINT_FOLLOW, attachId )
	dashFX.kv.VisibilityFlags = (ENTITY_VISIBLE_TO_FRIENDLY | ENTITY_VISIBLE_TO_ENEMY)	// everyone but owner
	dashFX.SetOwner( player )


	wait PHASE_WALK_PRE_TELL_TIME
}
#endif

void function OnWeaponChargeEnd_ability_phase_walk( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	#if SERVER
		foreach ( effect in weapon.w.statusEffects )
		{
			StatusEffect_Stop( player, effect )
		}
		if ( player in file.hasLockedWeaponsAndMelee && file.hasLockedWeaponsAndMelee[player]  )
		{
			if ( IsValid(player) )
				UnlockWeaponsAndMelee( player )
			file.hasLockedWeaponsAndMelee[player] <- false
		}
		int ammoAfterFiring = weapon.GetWeaponPrimaryClipCount() - weapon.GetAmmoPerShot()
		weapon.SetWeaponPrimaryClipCount( maxint( ammoAfterFiring, 0 ) )
	#endif
}