#if(true)//

//

global function OnAbilityStart_Defender_Sustained
global function OnAbilityEnd_Defender_Sustained
global function OnWeaponPrimaryAttack_weapon_defender_sustained

//
//
//


int function OnAbilityStart_Defender_Sustained( entity weapon )
{
	return 1
}

void function OnAbilityEnd_Defender_Sustained( entity weapon )
{

}

bool function OnAbilityChargeBegin_ChargeRifle_Sustained( entity weapon )
{
	if ( !IsValid( weapon ) )
		return false

	//

	return true
}

void function OnAbilityChargeEnd_ChargeRifle_Sustained( entity weapon )
{
	if ( !IsValid( weapon ) )
		return

	//
}

var function OnWeaponPrimaryAttack_weapon_defender_sustained( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	//
	//

	return FireDefenderSustained( weapon, attackParams )
}

int function FireDefenderSustained( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.1 )

	int damageFlags = weapon.GetWeaponDamageFlags()
	weapon.FireWeaponBullet( attackParams.pos, attackParams.dir, 1, damageFlags )

	return 1
}



#endif //
