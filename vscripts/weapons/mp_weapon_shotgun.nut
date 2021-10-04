global function OnWeaponActivate_weapon_shotgun
global function OnWeaponDeactivate_weapon_shotgun
global function OnWeaponPrimaryAttack_weapon_shotgun

#if SERVER
global function OnWeaponNpcPrimaryAttack_weapon_shotgun
#endif // #if SERVER
global function OnProjectileCollision_weapon_shotgun

void function OnWeaponActivate_weapon_shotgun( entity weapon )
{
	OnWeaponActivate_weapon_basic_bolt( weapon )

	UpdateDoubleTapShotgunBoltPairing( weapon )
}

void function OnWeaponDeactivate_weapon_shotgun( entity weapon )
{
	UpdateDoubleTapShotgunBoltPairing( weapon )
}

void function UpdateDoubleTapShotgunBoltPairing( entity weapon )
{

	bool isPredictedOrServer = InPrediction() && IsFirstTimePredicted()
	#if SERVER

	#endif //
	if ( !isPredictedOrServer )
		return

	const string BOLT_MOD_BASE = "shotgun_bolt_"
	const string DOUBLE_TAP_SUFFIX = "_double_tap"
	array<string> levels = ["l1", "l2", "l3"]
	#if SERVER

	#endif

	if ( weapon.HasMod( "hopup_double_tap" ) )
	{

		foreach ( string level in levels )
		{
			string boltModBase = BOLT_MOD_BASE + level
			string boltModDT = boltModBase + DOUBLE_TAP_SUFFIX

			weapon.RemoveMod( boltModDT )

			if ( weapon.HasMod( boltModBase ) )
				weapon.AddMod( boltModDT )
		}
	}
	else
	{
		foreach ( string level in levels )
		{
			string boltModDT = BOLT_MOD_BASE + level + DOUBLE_TAP_SUFFIX

			weapon.RemoveMod( boltModDT )
		}
	}
}

var function OnWeaponPrimaryAttack_weapon_shotgun( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	bool playerFired = true
	Fire_EVA_Shotgun( weapon, attackParams, playerFired )
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_weapon_shotgun( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	bool playerFired = false
	Fire_EVA_Shotgun( weapon, attackParams, playerFired )
}
#endif // #if SERVER

int function Fire_EVA_Shotgun( entity weapon, WeaponPrimaryAttackParams attackParams, bool playerFired = true )
{
	entity owner = weapon.GetWeaponOwner()

	float patternScale = 1.0
	if ( !playerFired )
		patternScale = weapon.GetWeaponSettingFloat( eWeaponVar.blast_pattern_npc_scale )

	float speedScale = 1.0
	bool ignoreSpread = true
	weapon.FireWeapon_Default( attackParams.pos, attackParams.dir, speedScale, patternScale, ignoreSpread )

	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
}

void function OnProjectileCollision_weapon_shotgun( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical )
{
	#if SERVER
	// TODO: IMPLEMENT
	#endif //
}
