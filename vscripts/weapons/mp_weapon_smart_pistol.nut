untyped

global function MpWeaponSmartPistol_Init

global function OnWeaponActivate_weapon_smart_pistol
global function OnWeaponDeactivate_weapon_smart_pistol
global function OnWeaponPrimaryAttack_weapon_smart_pistol
global function OnWeaponBulletHit_weapon_smart_pistol

global function OnWeaponStartZoomIn_weapon_smart_pistol
global function OnWeaponStartZoomOut_weapon_smart_pistol

const float SMART_PISTOL_TRACKER_TIME = 10.0

function MpWeaponSmartPistol_Init()
{
	PrecacheParticleSystem( $"P_smartpistol_lockon_FP" )
	PrecacheParticleSystem( $"P_smartpistol_lockon" )
}

void function OnWeaponActivate_weapon_smart_pistol( entity weapon )
{
	if ( !( "initialized" in weapon.s ) )
	{
		weapon.s.damageValue <- weapon.GetWeaponInfoFileKeyField( "damage_near_value" )
		SmartAmmo_SetAllowUnlockedFiring( weapon, true )
		SmartAmmo_SetUnlockAfterBurst( weapon, (SMART_AMMO_PLAYER_MAX_LOCKS > 1) )
		SmartAmmo_SetWarningIndicatorDelay( weapon, 0.0 )

		weapon.s.initialized <- true

#if SERVER
		weapon.s.lockStartTime <- Time()
		weapon.s.locking <- true
#endif
	}

#if SERVER
	weapon.s.locking = true
	weapon.s.lockStartTime = Time()
#endif
}

void function OnWeaponDeactivate_weapon_smart_pistol( entity weapon )
{
	weapon.StopWeaponEffect( $"P_smartpistol_lockon_FP", $"P_smartpistol_lockon" )
}

var function OnWeaponPrimaryAttack_weapon_smart_pistol( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	int damageFlags = weapon.GetWeaponDamageFlags()
	return SmartAmmo_FireWeapon( weapon, attackParams, damageFlags, damageFlags )
}

function SmartWeaponFireSound( entity weapon, target )
{
	if ( weapon.HasMod( "silencer" ) )
	{
		weapon.EmitWeaponSound_1p3p( "Weapon_SmartPistol_SuppressedFire_1P", "Weapon_SmartPistol_SuppressedFire_3P" )
	}
	else
	{
		if ( target == null )
			weapon.EmitWeaponSound_1p3p( "Weapon_SmartPistol_Fire_1P", "Weapon_SmartPistol_Fire_3P" )
		else
			weapon.EmitWeaponSound_1p3p( "Weapon_SmartPistol_Fire_1P", "Weapon_SmartPistol_Fire_3P" )
	}
}

void function OnWeaponBulletHit_weapon_smart_pistol( entity weapon, WeaponBulletHitParams hitParams )
{
	//if ( weapon.HasMod( "proto_tracker" ) ) //Recheck for this once we make it mod only
	entity hitEnt = hitParams.hitEnt
	if ( IsValid( hitEnt ) )
	{
		weapon.SmartAmmo_TrackEntity( hitEnt, SMART_PISTOL_TRACKER_TIME )

		#if SERVER
			if ( weapon.GetWeaponSettingBool( eWeaponVar.smart_ammo_player_targets_must_be_tracked ) )
			{
				if ( hitEnt.IsPlayer() &&  !hitEnt.IsTitan() ) //Note that there is a max of 10 status effects, which means that if you theoreteically get hit as a pilot 10 times without somehow dying, you could knock out other status effects like emp slow etc
					StatusEffect_AddTimed( hitEnt, eStatusEffect.lockon_detected, 1.0, SMART_PISTOL_TRACKER_TIME, 0.0 )
			}
		#endif
	}

}

void function OnWeaponStartZoomIn_weapon_smart_pistol( entity weapon )
{

	if ( !weapon.HasMod( "ads_smaller_lock_on" ) )
	{
		array<string> mods = weapon.GetMods()
		mods.append( "ads_smaller_lock_on" )
		weapon.SetMods( mods )
	}
}

void function OnWeaponStartZoomOut_weapon_smart_pistol( entity weapon )
{
	if ( weapon.HasMod( "ads_smaller_lock_on" ) )
	{
		array<string> mods = weapon.GetMods()
		mods.fastremovebyvalue( "ads_smaller_lock_on" )
		weapon.SetMods( mods )
	}

}