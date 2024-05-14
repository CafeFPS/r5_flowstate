global function OnWeaponPrimaryAttack_nessy97
global function OnWeaponActivate_nessy97
global function OnWeaponDeactivate_nessy97
global function OnWeaponBulletHit_nessy97
global function OnWeaponSustainedDischargeBegin_nessy97
global function OnWeaponSustainedDischargeEnd_nessy97
global function OnWeaponActivate_arc_accel
global function OnWeaponDeactivate_arc_accel

void function OnWeaponActivate_nessy97( entity weapon )
{
    #if SERVER
    weapon.SetWeaponCharm( $"mdl/props/charm/charm_nessy.rmdl", "CHARM" )
    weapon.SetSkin(4)

    #endif
	//OnWeaponActivate_weapon_basic_bolt( weapon )
}

void function OnWeaponDeactivate_nessy97( entity weapon )
{

}


void function OnWeaponActivate_arc_accel( entity weapon )
{
    weapon.PlayWeaponEffect( $"P_wpn_lasercannon_aim_short_blue", $"", "flashlight" )

    #if SERVER
    if(!IsValid(weapon))
        return

    if( weapon.GetOwner().GetNormalWeapon( GetDualPrimarySlotForWeapon( weapon ) ) )
        TakeMatchingAkimboWeapon( weapon )
    else
        GiveMatchingAkimboWeapon( weapon, weapon.GetMods())
    #endif
}

void function OnWeaponDeactivate_arc_accel( entity weapon )
{
    weapon.StopWeaponEffect( $"P_wpn_lasercannon_aim_short_blue", $"P_wpn_lasercannon_aim_short_blue" )

    #if SERVER
    if( weapon.GetOwner().GetNormalWeapon( GetDualPrimarySlotForWeapon( weapon ) ) )
        TakeMatchingAkimboWeapon(weapon)
    #endif
}

var function OnWeaponPrimaryAttack_nessy97( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	#if CLIENT
	if(!weapon.ShouldPredictProjectiles())
	    return 1
	#endif


    WeaponFireGrenadeParams fireGrenadeParams
    fireGrenadeParams.pos = attackParams.pos
    fireGrenadeParams.vel = attackParams.dir
    fireGrenadeParams.angVel = <0,-90,0>
    fireGrenadeParams.fuseTime = weapon.GetWeaponSettingFloat( eWeaponVar.projectile_lifetime ) / 1.5
    fireGrenadeParams.scriptTouchDamageType = 0
    fireGrenadeParams.scriptExplosionDamageType = 0
    fireGrenadeParams.clientPredicted = false
    fireGrenadeParams.lagCompensated = true
    fireGrenadeParams.useScriptOnDamage = false
    fireGrenadeParams.isZiplineGrenade = false
    entity projectile = weapon.FireWeaponGrenade( fireGrenadeParams )
    #if SERVER
    if( IsValid( projectile ) )
        projectile.SetAngles( weapon.GetOwner().GetAngles() )
    #endif

	return 1
}


void function OnWeaponBulletHit_nessy97( entity weapon, WeaponBulletHitParams hitParams )
{
	entity target = hitParams.hitEnt
    entity owner = weapon.GetOwner()
}

int function OnWeaponSustainedDischargeBegin_nessy97( entity weapon )
{
	if(weapon.HasMod("damage"))
	    weapon.RemoveMod("damage")
	return 1
}

void function OnWeaponSustainedDischargeEnd_nessy97( entity weapon )
{
    #if CLIENT
    entity player = GetLocalClientPlayer()
    #elseif SERVER
        entity player = weapon.GetParent()
    #endif

	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )

	#if SERVER
    vector eyePosition = player.EyePosition()
    vector viewVector = player.GetViewVector()
	float max_range = weapon.GetWeaponSettingFloat( eWeaponVar.sustained_laser_range )
    #endif
}