global function MpAbilityPhaseWalk_Init

global function OnWeaponActivate_ability_phase_walk
global function OnWeaponDeactivate_ability_phase_walk
global function OnWeaponPrimaryAttack_ability_phase_walk
global function OnWeaponChargeBegin_ability_phase_walk
global function OnWeaponChargeEnd_ability_phase_walk

const float PHASE_WALK_PRE_TELL_TIME = 1.5
const asset PHASE_WALK_APPEAR_PRE_FX = $"P_phase_dash_pre_end_mdl"

void function MpAbilityPhaseWalk_Init()
{
	PrecacheParticleSystem( PHASE_WALK_APPEAR_PRE_FX )
}


void function OnWeaponActivate_ability_phase_walk( entity weapon )
{
	#if SERVER
		entity player = weapon.GetWeaponOwner()
		EmitSoundOnEntityExceptToPlayer( player, player, "pilot_phaseshift_armraise_3p" )
		float deploy_time = weapon.GetWeaponSettingFloat( eWeaponVar.deploy_time )
		
		if ( player.GetActiveWeapon( eActiveInventorySlot.mainHand ) != player.GetOffhandWeapon( OFFHAND_INVENTORY ) )
			PlayBattleChatterLineToSpeakerAndTeam( player, "bc_tactical" )
		
			if ( !weapon.HasMod( "ult_active" ) )
			{
		StatusEffect_AddTimed( player, eStatusEffect.move_slow, 0.2, deploy_time, deploy_time )
	}
		
		
	#endif
}

void function OnWeaponDeactivate_ability_phase_walk( entity weapon )
{
	#if SERVER
	entity player = weapon.GetWeaponOwner()
	if(returnPropBool() || player.GetTeam() == TEAM_IMC){
		printt("Flowstate DEBUG - Angles locked for prop team player.", player, player.GetAngles())
		thread PROPHUNT_GiveAndManageRandomProp(player, true)

	} else {
		int newscore = player.p.PROPHUNT_Max3changes + 1 	//using int as a boolean
		player.p.PROPHUNT_Max3changes = newscore
		if (player.p.PROPHUNT_Max3changes <= 3){
			thread PROPHUNT_GiveAndManageRandomProp(player)
			} else {
			printt("Flowstate DEBUG - Max amount of changes reached: ", player)
			Message(player, "prophunt", "Max amount of changes reached.", 1)
			}
	}
	#endif
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
	float amount = GetCurrentPlaylistVarFloat( "wraith_phase_walk_speed_boost_amount", 0.3 )
	float easeOut = GetCurrentPlaylistVarFloat( "wraith_phase_walk_speed_boost_easeOutFrac", 0.3 )
			
	#if SERVER
		LockWeaponsAndMelee( player )

			weapon.w.statusEffects.append( StatusEffect_AddTimed( player, eStatusEffect.speed_boost, amount, chargeTime, chargeTime*easeOut ) )

		thread PhaseWalkUnphaseTell( player, chargeTime )
		PlayerUsedOffhand( player, weapon )
	StatsHook_Tactical_TimeSpentInPhase( player, chargeTime )
	#endif
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
		if ( player.IsMantling() || player.IsWallRunning() || player.p.isSkydiving )
			weapon.SetWeaponPrimaryClipCount( 0 ) //Defensive fix for the fact that primary fire isn't triggered when climbing.
	#endif
}
