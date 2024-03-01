//By Colombia. Based on Halo Infinite Cindershot and Titanfall2 scripts.

untyped

global function MpWeaponGuidedMissile_Init
global function OnWeaponActivate_cindershot
global function OnWeaponDeactivate_cindershot
global function OnWeaponPrimaryAttack_cindershot
global function OnProjectileCollision_cindershot
global function OnWeaponStartZoomIn_cindershot
global function OnWeaponStartZoomOut_cindershot

struct{
entity weapon	
}file

function MpWeaponGuidedMissile_Init()
{
	#if SERVER
	PrecacheParticleSystem($"P_impact_exp_emp_med_default")
	RegisterSignal( "StopGuidedLaser" )
	#endif
}

void function OnWeaponActivate_cindershot( entity weapon )
{
	entity weaponOwner = weapon.GetWeaponOwner()
	file.weapon = weapon
	if ( !("guidedLaserPoint" in weaponOwner.s) )
		weaponOwner.s.guidedLaserPoint <- null

}

void function OnWeaponDeactivate_cindershot( entity weapon )
{

}

var function OnWeaponPrimaryAttack_cindershot( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	if (weapon.HasMod( "bouncepls" )) weapon.RemoveMod( "bouncepls") 
	if (weapon.HasMod( "dontdoeffectonimpact" )) weapon.RemoveMod( "dontdoeffectonimpact") 
		
	entity weaponOwner = weapon.GetWeaponOwner()

	if(weaponOwner.IsInputCommandHeld( IN_ZOOM | IN_ZOOM_TOGGLE )){	
		#if SERVER	
		WeaponFireMissileParams fireMissileParams
		fireMissileParams.pos = attackParams.pos
		fireMissileParams.dir = attackParams.dir
		fireMissileParams.speed = 0.5
		fireMissileParams.scriptTouchDamageType = damageTypes.largeCaliberExp | DF_IMPACT
		fireMissileParams.scriptExplosionDamageType = damageTypes.explosive
		fireMissileParams.doRandomVelocAndThinkVars = false
		fireMissileParams.clientPredicted = false
		entity missile = weapon.FireWeaponMissile( fireMissileParams )
		if ( missile )
		{
			if( "guidedMissileTarget" in weapon.s && IsValid( weapon.s.guidedMissileTarget ) )
			{
				missile.SetMissileTarget( weapon.s.guidedMissileTarget, Vector( 0, 0, 0 ) )
			}
		}
		printt("Firing Cindershot Guided mode")

		return 1
		#endif
	} else {
		#if SERVER
		 array<string> mods = weapon.GetMods()
		 mods.append( "bouncepls" )
		 mods.append( "dontdoeffectonimpact" )
		 weapon.SetMods( mods )
		
		 float speedScale = 1.0
		 weapon.FireWeapon_Default( attackParams.pos, attackParams.dir, speedScale, 1, true )
		
		printt("Firing Cindershot Normal mode")
		return 1
		#endif
	}
}

void function OnProjectileCollision_cindershot( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical )
{
	#if SERVER
	if(hitEnt.IsPlayer() || hitEnt.IsNPC())
	entity fx = StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( $"P_impact_exp_emp_med_default" ), projectile.GetOrigin(), <0,0,0> )
		printt("Collission! Don't do fxs if first bounce. - Count: " + projectile.proj.projectileBounceCount)
			int bounceCount = projectile.GetProjectileWeaponSettingInt( eWeaponVar.projectile_ricochet_max_count )
			if (file.weapon.HasMod( "dontdoeffectonimpact" ) && projectile.proj.projectileBounceCount > 0) 
				entity fx = StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( $"P_impact_exp_emp_med_default" ), projectile.GetOrigin(), <0,0,0> )
		
			if ( projectile.proj.projectileBounceCount >= bounceCount ) return
			projectile.proj.projectileBounceCount++
	#endif
}

function CalculatePath( entity weapon, entity weaponOwner)
{
	#if SERVER
	weaponOwner.EndSignal( "OnDestroy" )
	weapon.EndSignal( "OnDestroy" )
	weapon.EndSignal( "StopGuidedLaser" )

		entity info_target
		info_target = CreateEntity( "info_target" )
		info_target.SetOrigin( weapon.GetOrigin() )
		info_target.SetInvulnerable()
		DispatchSpawn( info_target )
		weapon.s.guidedMissileTarget <- info_target

	OnThreadEnd(function() : ( weapon, info_target )
		{
			if ( IsValid( info_target ) && IsValid(weapon.s.guidedMissileTarget))
			{
				info_target.Destroy()
				weapon.s.guidedMissileTarget.Destroy()
			}
		})

	while ( true )
	{
		if ( !IsValid( weaponOwner ) || !IsValid( weapon ) )
			break
		weaponOwner.s.guidedLaserPoint = null
		TraceResults result = GetViewTrace( weaponOwner )
		weaponOwner.s.guidedLaserPoint = result.endPos 
		
		if(IsValid(info_target)) info_target.SetOrigin( result.endPos )
			
		wait 0.0000000001
	}
	#endif
}

void function OnWeaponStartZoomIn_cindershot(entity weapon)
{
	#if SERVER
	entity weaponOwner = weapon.GetOwner()
	thread CalculatePath( weapon, weaponOwner)
	#endif
}

void function OnWeaponStartZoomOut_cindershot(entity weapon)
{
	#if SERVER
	weapon.Signal( "StopGuidedLaser" )
	#endif
}