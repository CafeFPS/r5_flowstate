global function OnWeaponPrimaryAttack_lmg
global function OnWeaponActivate_lmg
global function OnWeaponBulletHit_weapon_lmg

#if SERVER
global function OnWeaponNpcPrimaryAttack_LMG
#endif // SERVER

const float LMG_SMART_AMMO_TRACKER_TIME = 10.0

void function OnWeaponActivate_lmg( entity weapon )
{
	//PrintFunc()
	SmartAmmo_SetAllowUnlockedFiring( weapon, true )
	SmartAmmo_SetUnlockAfterBurst( weapon, (SMART_AMMO_PLAYER_MAX_LOCKS > 1) )
	SmartAmmo_SetWarningIndicatorDelay( weapon, 9999.0 )
}

var function OnWeaponPrimaryAttack_lmg( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	if ( weapon.HasMod( "smart_lock_dev" ) )
	{
		int damageFlags = weapon.GetWeaponDamageFlags()
		//printt( "DamageFlags for lmg: " + damageFlags )
		return SmartAmmo_FireWeapon( weapon, attackParams, damageFlags, damageFlags )
	}
	else
	{
		weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )
		weapon.FireWeaponBullet( attackParams.pos, attackParams.dir, 1, weapon.GetWeaponDamageFlags() )
	}
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_LMG( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	weapon.EmitWeaponSound_1p3p( "", "weapon_predator_powershot_shortrange_3p_int_enemy" )
	return OnWeaponNpcPrimaryAttack_weapon_basic_bolt( weapon, attackParams )
}
#endif // #if SERVER

void function OnWeaponBulletHit_weapon_lmg( entity weapon, WeaponBulletHitParams hitParams )
{
	if ( !weapon.HasMod( "smart_lock_dev" ) )
		return

	entity hitEnt = hitParams.hitEnt //Could be more efficient with this and early return out if the hitEnt is not a player, if only smart_ammo_player_targets_must_be_tracked  is set, which is currently true

	if ( IsValid( hitEnt ) )
	{
		weapon.SmartAmmo_TrackEntity( hitEnt, LMG_SMART_AMMO_TRACKER_TIME )

		#if SERVER
			if ( hitEnt.IsPlayer() && !hitEnt.IsTitan() ) //Note that there is a max of 10 status effects, which means that if you theoreteically get hit as a pilot 10 times without somehow dying, you could knock out other status effects like emp slow etc
			{
				printt( "Adding status effect" )
				StatusEffect_AddTimed( hitEnt, eStatusEffect.sonar_detected, 1.0, LMG_SMART_AMMO_TRACKER_TIME, 0.0 )
			}
		#endif
	}
}
