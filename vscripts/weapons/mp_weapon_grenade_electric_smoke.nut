
global function MpWeaponGreandeElectricSmoke_Init
global function OnProjectileCollision_weapon_grenade_electric_smoke
#if SERVER
global function ElectricGrenadeSmokescreen
#endif

global const FX_ELECTRIC_SMOKESCREEN_PILOT = $"P_smokescreen_FD"
global const FX_ELECTRIC_SMOKESCREEN_PILOT_AIR = $"P_smokescreen_FD"

void function MpWeaponGreandeElectricSmoke_Init()
{
	PrecacheParticleSystem( FX_ELECTRIC_SMOKESCREEN_PILOT )
	PrecacheParticleSystem( FX_ELECTRIC_SMOKESCREEN_PILOT_AIR )
}

void function OnProjectileCollision_weapon_grenade_electric_smoke( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical )
{
	entity player = projectile.GetOwner()
	if ( hitEnt == player )
		return

	if ( projectile.GrenadeHasIgnited() )
		return

	table collisionParams =
	{
		pos = pos,
		normal = normal,
		hitEnt = hitEnt,
		hitbox = hitbox
	}

	projectile.SetModel( $"mdl/dev/empty_model.rmdl" )
	bool result = PlantStickyEntity( projectile, collisionParams, <90.0, 0.0, 0.0> )

#if SERVER
	if ( !result )
	{
		projectile.SetVelocity( <0.0, 0.0, 0.0> )
		projectile.StopPhysics()
		ElectricGrenadeSmokescreen( projectile, FX_ELECTRIC_SMOKESCREEN_PILOT_AIR )
	}
	else if ( IsValid( hitEnt ) && ( hitEnt.IsPlayer() || hitEnt.IsTitan() || hitEnt.IsNPC() ) )
	{
		ElectricGrenadeSmokescreen( projectile, FX_ELECTRIC_SMOKESCREEN_PILOT_AIR )
	}
	else
	{
		ElectricGrenadeSmokescreen( projectile, FX_ELECTRIC_SMOKESCREEN_PILOT )
	}
#endif
	projectile.GrenadeIgnite()
	projectile.SetDoesExplode( false )
}

#if SERVER
void function ElectricGrenadeSmokescreen( entity projectile, asset fx )
{
	entity owner = projectile.GetThrower()
	vector pos = projectile.GetOrigin()

	if ( !IsValid( owner ) )
		return
	
	EmitSoundAtPosition( TEAM_UNASSIGNED, pos, "Wattson_Ultimate_I", owner )
	
	float duration = 10
	
	entity effect = StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( $"P_impact_exp_emp_med_default" ), pos+<0,0,32>, <0,0,0> )
	effect.SetOwner( owner )
	AddToUltimateRealm( owner, effect )
	for(int i = 0; i<duration*2; i++)
	{
		EntFireByHandle( effect, "Stop", "", i*0.5, null, null )
		EntFireByHandle( effect, "Start", "", i*0.5+0.1, null, null )
	}
	EntFireByHandle( effect, "Kill", "", duration, null, null )
	

	RadiusDamageData radiusDamageData = GetRadiusDamageDataFromProjectile( projectile, owner )

	SmokescreenStruct smokescreen
	smokescreen.smokescreenFX = fx
	smokescreen.ownerTeam = owner.GetTeam()
	smokescreen.damageSource = eDamageSourceId.mp_weapon_droneplasma
	smokescreen.attacker = owner
	smokescreen.inflictor = owner
	smokescreen.weaponOrProjectile = projectile
	smokescreen.damageInnerRadius = radiusDamageData.explosionInnerRadius
	smokescreen.damageOuterRadius = radiusDamageData.explosionRadius
	smokescreen.dangerousAreaRadius = smokescreen.damageOuterRadius * 1.5
	smokescreen.damageDelay = 1.0
	smokescreen.dpsPilot = radiusDamageData.explosionDamage
	smokescreen.dpsTitan = radiusDamageData.explosionDamageHeavyArmor
	smokescreen.lifetime = duration
	
	smokescreen.deploySound1p = "bangalore_smoke_screen_3p"
	smokescreen.deploySound3p = "bangalore_smoke_screen_3p"
	smokescreen.stopSound1p = "bangalore_smoke_screen_stop_3p"
	smokescreen.stopSound3p = "bangalore_smoke_screen_stop_3p"

	smokescreen.origin = pos
	smokescreen.angles = <0,0,0>
	smokescreen.fxUseWeaponOrProjectileAngles = true
	smokescreen.fxOffsets = [ <0.0, 0.0, 5.0> ]

	Smokescreen( smokescreen, owner )
	
	projectile.Destroy()
}
#endif