
global function MpWeaponGreandeElectricSmoke_Init
global function OnProjectileCollision_weapon_grenade_electric_smoke
#if SERVER
global function ElectricGrenadeSmokescreen
#endif

global const FX_ELECTRIC_SMOKESCREEN_PILOT = $"P_wpn_smk_electric_pilot"
global const FX_ELECTRIC_SMOKESCREEN_PILOT_AIR = $"P_wpn_smk_electric_pilot_air"

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

	if ( !IsValid( owner ) )
		return

	RadiusDamageData radiusDamageData = GetRadiusDamageDataFromProjectile( projectile, owner )

	SmokescreenStruct smokescreen
	smokescreen.smokescreenFX = fx
	smokescreen.ownerTeam = owner.GetTeam()
	smokescreen.damageSource = eDamageSourceId.mp_weapon_grenade_electric_smoke
	smokescreen.deploySound1p = "explo_electric_smoke_impact"
	smokescreen.deploySound3p = "explo_electric_smoke_impact"
	smokescreen.attacker = owner
	smokescreen.inflictor = owner
	smokescreen.weaponOrProjectile = projectile
	smokescreen.damageInnerRadius = radiusDamageData.explosionInnerRadius
	smokescreen.damageOuterRadius = radiusDamageData.explosionRadius
	smokescreen.dangerousAreaRadius = smokescreen.damageOuterRadius * 1.5
	smokescreen.damageDelay = 1.0
	smokescreen.dpsPilot = radiusDamageData.explosionDamage
	smokescreen.dpsTitan = radiusDamageData.explosionDamageHeavyArmor

	smokescreen.origin = projectile.GetOrigin()
	smokescreen.angles = projectile.GetAngles()
	smokescreen.fxUseWeaponOrProjectileAngles = true
	smokescreen.fxOffsets = [ <0.0, 0.0, 2.0> ]

	Smokescreen( smokescreen, owner )
}
#endif