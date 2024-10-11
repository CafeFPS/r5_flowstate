global function OnWeaponChargeBegin_ability_heal
global function OnWeaponPrimaryAttack_ability_heal
global function OnWeaponChargeEnd_ability_heal
global function OnWeaponAttemptOffhandSwitch_ability_heal

const float STIM_DURATION = 6.0
const int 	STIM_HEALTH_COST = 20

bool function OnWeaponChargeBegin_ability_heal( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	float duration     = STIM_DURATION
	StimPlayerWithOffhandWeapon( player, duration, weapon )

	weapon.EmitWeaponSound_1p3p( "octane_stimpack_loop_1P", "octane_stimpack_loop_3P" )
	PlayerUsedOffhand( player, weapon )

	thread StimEnd(weapon, duration)

	#if SERVER
	player.p.lastDamageTime = Time()
	
	int currentHealth    = player.GetHealth()
	int healthToSubtract = GetCurrentPlaylistVarInt( "octane_health_cost", STIM_HEALTH_COST )
	float newHealth      = max( 1, currentHealth - healthToSubtract )
	float damage         = currentHealth - newHealth

	player.SetHealth( newHealth )
	
	// store damage taken to damage histroy so that it shows up in the death recap.
	int scriptDamageType = DF_INSTANT | DF_BYPASS_SHIELD //| DF_NO_HITBEEP | DF_NO_INDICATOR
	StoreDamageHistoryAndUpdate( player, GetCurrentPlaylistVarFloat( "max_damage_history_time", MAX_DAMAGE_HISTORY_TIME  ), damage, player.GetCenter(), scriptDamageType, eDamageSourceId.mp_ability_heal, player )

	if( Time() > player.p.lastStimChatterTime )
	{
		player.p.lastStimChatterTime = Time() + RandomFloatRange( 20.0, 40.0 )
		PlayBattleChatterLineToSpeakerAndTeam( player, "bc_tactical" )
	}

	#endif
	return true
}

void function StimEnd( entity weapon, float duration)
{
	if ( !IsValid( weapon ) )
		return

	EndSignal( weapon, "OnDestroy" )

	wait duration-2

	weapon.EmitWeaponSound_1p3p( "octane_stimpack_deactivate_1P", "octane_stimpack_deactivate_3P" )
}

void function OnWeaponChargeEnd_ability_heal( entity weapon )
{
	if ( !IsValid( weapon ) )
		return

	#if SERVER
		int ammoAfterFiring = weapon.GetWeaponPrimaryClipCount() - weapon.GetAmmoPerShot()
		weapon.SetWeaponPrimaryClipCount( maxint( ammoAfterFiring, 0 ) )
	#endif
}


var function OnWeaponPrimaryAttack_ability_heal( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
}


bool function OnWeaponAttemptOffhandSwitch_ability_heal( entity weapon )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	if ( IsValid( ownerPlayer ) )
	{
		if ( StatusEffect_GetSeverity( ownerPlayer, eStatusEffect.stim_visual_effect ) )
			return false
	}
	return true
}