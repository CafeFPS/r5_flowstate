global function MpAbilityPhaseWalk_Init

global function OnWeaponActivate_ability_phase_walk
global function OnWeaponPrimaryAttack_ability_phase_walk
global function OnWeaponChargeBegin_ability_phase_walk
global function OnWeaponChargeEnd_ability_phase_walk

const string SOUND_ACTIVATE_1P = "pilot_phaseshift_firstarmraise_1p"                                                                                                                                                                                   
const string SOUND_ACTIVATE_3P = "pilot_phaseshift_firstarmraise_3p"                                                                                                                

const float PHASE_WALK_PRE_TELL_TIME = 1.5
const asset PHASE_WALK_APPEAR_PRE_FX = $"P_phase_dash_pre_end_mdl"

void function MpAbilityPhaseWalk_Init()
{
	PrecacheParticleSystem( PHASE_WALK_APPEAR_PRE_FX )
}

void function OnWeaponActivate_ability_phase_walk( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	float deploy_time = weapon.GetWeaponSettingFloat( eWeaponVar.deploy_time )
	
	#if SERVER
	EmitSoundOnEntityExceptToPlayer( player, player, SOUND_ACTIVATE_3P )

	if ( player.GetActiveWeapon( eActiveInventorySlot.mainHand ) != player.GetOffhandWeapon( OFFHAND_INVENTORY ) )
		PlayBattleChatterLineToSpeakerAndTeam( player, "bc_tactical" )
	#endif
	
	if ( !weapon.HasMod( "ult_active" ) )
	{
		#if SERVER
			                                                                    
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

var function OnWeaponPrimaryAttack_ability_phase_walk( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity player = weapon.GetWeaponOwner()
	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
}

bool function OnWeaponChargeBegin_ability_phase_walk( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	float chargeTime = weapon.GetWeaponSettingFloat( eWeaponVar.charge_time )
		
	{
		bool doStatus = true
		#if CLIENT
			if ( !InPrediction() )
				doStatus = false
		#endif

		if ( doStatus )
		{
			int speedHandle = StatusEffect_AddTimed( player, eStatusEffect.speed_boost, 0.3, chargeTime, chargeTime * 0.3 )

			#if SERVER
			LockWeaponsAndMelee( player )
			thread PhaseWalkUnphaseTell( player, chargeTime )
			PlayerUsedOffhand( player, weapon )
			//StatsHook_Tactical_TimeSpentInPhase( player, chargeTime )                                         
			#endif
		}
	}

	PhaseShift( player, 0, chargeTime, eShiftStyle.Balance )
	return true
}

#if SERVER
void function PhaseWalkUnphaseTell( entity player, float chargeTime )
{
	player.EndSignal( "OnDeath" )
	player.EndSignal( "ForceStopPhaseShift" )

	TrackingVision_CreatePOI( eTrackingVisionNetworkedPOITypes.PLAYER_ABILITIES_PHASE_DASH_START, player, player.GetOrigin(), player.GetTeam(), player )

	wait PHASE_WALK_PRE_TELL_TIME

	asset fxAsset = PHASE_WALK_APPEAR_PRE_FX
	int fxid     = GetParticleSystemIndex( fxAsset )
	int attachId = player.LookupAttachment( "ORIGIN" )

	entity dashFX = StartParticleEffectOnEntity_ReturnEntity( player, fxid, FX_PATTACH_POINT_FOLLOW, attachId )
	dashFX.kv.VisibilityFlags = (ENTITY_VISIBLE_TO_FRIENDLY | ENTITY_VISIBLE_TO_ENEMY)	// everyone but owner
	dashFX.SetOwner( player )

	OnThreadEnd(
	function() : ( player, dashFX )
		{
			if ( IsValid( player ) )
				TrackingVision_CreatePOI( eTrackingVisionNetworkedPOITypes.PLAYER_ABILITIES_PHASE_DASH_STOP, player, player.GetOrigin(), player.GetTeam(), player )
			EffectStop( dashFX )
		}
	)
	wait chargeTime - PHASE_WALK_PRE_TELL_TIME
}
#endif

void function OnWeaponChargeEnd_ability_phase_walk( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	#if SERVER
		UnlockWeaponsAndMelee( player )
		EnableMantle(player)
		foreach ( effect in weapon.w.statusEffects )
		{
			StatusEffect_Stop( player, effect )
		}
		
		weapon.SetWeaponPrimaryClipCount( 0 )
	#endif
}
