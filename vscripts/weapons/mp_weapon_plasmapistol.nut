global function OnWeaponPrimaryAttack_Fanatic

bool FANATICDEBUG = false

void function MpWeaponFanatic_Init()
{

}

void function OnWeaponActivate_Fanatic( entity weapon )
{

}

void function OnWeaponDeactivate_Fanatic( entity weapon )
{

}

bool function ChangeDamage_Fanatic( entity weapon )
//By Colombia
{
    if( !IsValid( weapon ) || weapon.GetWeaponClassName() != "mp_weapon_plasmapistol" )
    	return false
  
    if(weapon.IsWeaponCharging() && FANATICDEBUG) printt("Charge fraction: " + weapon.GetWeaponChargeFraction())

        if(IsValid(weapon)){
                        
            //Resets damage amp each charge start.
            if(weapon.HasMod( "damageamped2" )) weapon.RemoveMod( "damageamped2")
            if (weapon.HasMod( "damageamped3" )) weapon.RemoveMod( "damageamped3") 
            if (weapon.HasMod( "damageamped4" )) weapon.RemoveMod( "damageamped4") 
            if (weapon.HasMod( "damageamped5" )) weapon.RemoveMod( "damageamped5") 

            array<string> mods = weapon.GetMods()

            if ( weapon.GetWeaponChargeFraction() >= 0.2 && weapon.GetWeaponChargeFraction() <= 0.4)
            {
                if(FANATICDEBUG) printt("Amping damage x2")
                mods.append( "damageamped2" )
                weapon.SetMods( mods )
                return true
            } else if ( weapon.GetWeaponChargeFraction() >= 0.4 && weapon.GetWeaponChargeFraction() <= 0.6) {
                if(FANATICDEBUG) printt("Amping damage x3")
                mods.append( "damageamped3" )
                weapon.SetMods( mods )
                return true
            } else if ( weapon.GetWeaponChargeFraction() >= 0.6 && weapon.GetWeaponChargeFraction() <= 0.8) {
                if(FANATICDEBUG) printt("Amping damage x4")
                mods.append( "damageamped4" )
                weapon.SetMods( mods )
                return true
            } else if ( weapon.GetWeaponChargeFraction() >= 0.8) {
                if(FANATICDEBUG) printt("Amping damage x5")
                mods.append( "damageamped5" )
                weapon.SetMods( mods )
                return true
            }
        }
    return true
}


var function OnWeaponPrimaryAttack_Fanatic( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	if ( !ChangeDamage_Fanatic( weapon ) )
		 return 0
	 
	return Fire_Fanatic( weapon, attackParams )
}

int function Fire_Fanatic( entity weapon, WeaponPrimaryAttackParams attackParams )

{

	weapon.FireWeapon_Default( attackParams.pos, attackParams.dir, 1.0, 1.0, false )

	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
}
