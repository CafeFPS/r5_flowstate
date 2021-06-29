global function OnWeaponPrimaryAttack_weapon_smr
global function OnWeaponActivate_weapon_smr

#if SERVER
global function OnWeaponNpcPrimaryAttack_weapon_smr
#endif // #if SERVER

#if CLIENT
global function OnClientAnimEvent_weapon_smr
#endif // #if CLIENT

void function OnWeaponActivate_weapon_smr( entity weapon )
{
#if CLIENT
	UpdateViewmodelAmmo( false, weapon )
#endif // #if CLIENT
}

var function OnWeaponPrimaryAttack_weapon_smr( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )

	entity weaponOwner = weapon.GetWeaponOwner()
	//vector bulletVec = ApplyVectorSpread( attackParams.dir, weaponOwner.GetAttackSpreadAngle() - 1.0 )
	//attackParams.dir = bulletVec

	if ( IsServer() || weapon.ShouldPredictProjectiles() )
	{
		WeaponFireMissileParams fireMissileParams
		fireMissileParams.pos = attackParams.pos
		fireMissileParams.dir = attackParams.dir
		fireMissileParams.speed = 1.5
		fireMissileParams.scriptTouchDamageType = damageTypes.projectileImpact
		fireMissileParams.scriptExplosionDamageType = damageTypes.explosive
		fireMissileParams.doRandomVelocAndThinkVars = false
		fireMissileParams.clientPredicted = false
		entity missile = weapon.FireWeaponMissile( fireMissileParams )
		if ( missile )
		{
			#if SERVER
				EmitSoundOnEntity( missile, "Weapon_Sidwinder_Projectile" )
			#endif

			missile.InitMissileForRandomDriftFromWeaponSettings( attackParams.pos, attackParams.dir )
			//InitMissileForRandomDrift( missile, attackParams.pos, attackParams.dir )
		}
	}
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_weapon_smr( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )

		WeaponFireMissileParams fireMissileParams
		fireMissileParams.pos = attackParams.pos
		fireMissileParams.dir = attackParams.dir
		fireMissileParams.speed = 4600
		fireMissileParams.scriptTouchDamageType = damageTypes.projectileImpact
		fireMissileParams.scriptExplosionDamageType = damageTypes.explosive
		fireMissileParams.doRandomVelocAndThinkVars = false
		fireMissileParams.clientPredicted = false
		entity missile = weapon.FireWeaponMissile( fireMissileParams )
	if ( missile && !weapon.HasMod( "sp_s2s_settings" ) )
	{
		EmitSoundOnEntity( missile, "Weapon_Sidwinder_Projectile" )
		//missile.InitMissileForRandomDriftFromWeaponSettings( attackParams.pos, attackParams.dir )
	}
}
#endif // #if SERVER

#if CLIENT
void function OnClientAnimEvent_weapon_smr( entity weapon, string name )
{
	GlobalClientEventHandler( weapon, name )
}
#endif // #if CLIENT

