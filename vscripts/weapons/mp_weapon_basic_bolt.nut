
global function MpWeaponBasicBolt_Init

global function OnWeaponActivate_weapon_basic_bolt
global function OnWeaponPrimaryAttack_weapon_basic_bolt
global function OnProjectileCollision_weapon_basic_bolt

#if CLIENT
global function OnClientAnimEvent_weapon_basic_bolt
#endif // #if CLIENT

#if SERVER
global function OnWeaponNpcPrimaryAttack_weapon_basic_bolt
#endif // #if SERVER

void function MpWeaponBasicBolt_Init()
{
	BasicBoltPrecache()
}

void function BasicBoltPrecache()
{
	PrecacheParticleSystem( $"wpn_mflash_snp_hmn_smoke_side_FP" )
	PrecacheParticleSystem( $"wpn_mflash_snp_hmn_smoke_side" )
}

void function OnWeaponActivate_weapon_basic_bolt( entity weapon )
{
#if CLIENT
	UpdateViewmodelAmmo( false, weapon )
#endif // #if CLIENT
}

#if CLIENT
void function OnClientAnimEvent_weapon_basic_bolt( entity weapon, string name )
{
	GlobalClientEventHandler( weapon, name )
}

#endif // #if CLIENT

var function OnWeaponPrimaryAttack_weapon_basic_bolt( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )

	return FireWeaponPlayerAndNPC( weapon, attackParams, true )
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_weapon_basic_bolt( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )

	return FireWeaponPlayerAndNPC( weapon, attackParams, false )
}
#endif // #if SERVER

int function FireWeaponPlayerAndNPC( entity weapon, WeaponPrimaryAttackParams attackParams, bool playerFired )
{
	bool shouldCreateProjectile = false
	if ( IsServer() || weapon.ShouldPredictProjectiles() )
		shouldCreateProjectile = true

	#if CLIENT
		if ( !playerFired )
			shouldCreateProjectile = false
	#endif

	if ( shouldCreateProjectile )
		entity bolt = FireBallisticRoundWithDrop( weapon, attackParams.pos, attackParams.dir, playerFired, false, 0, false )

	return 1
}

void function OnProjectileCollision_weapon_basic_bolt( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical )
{
	#if SERVER
		if ( DEBUG_BULLET_DROP != 0 )
		{
			entity owner = projectile.GetOwner()
			vector eyePos = owner.EyePosition()
			float distance = Distance( eyePos, pos )

			vector startPos = eyePos + (projectile.proj.savedDir * distance)

			float durationSec = Time() - projectile.proj.savedShotTime
			float dropDist = (pos.z - startPos.z)

			printt( "Distance:   ", GetDistanceString( distance ) )
			printt( "Drop:       ", GetDistanceString( dropDist ), durationSec )
			printt( "Drop ms/sec:", (2 * fabs(dropDist / 39.3701)) / (durationSec * durationSec) )
		}

		int bounceCount = projectile.GetProjectileWeaponSettingInt( eWeaponVar.projectile_ricochet_max_count )
		if ( projectile.proj.projectileBounceCount >= bounceCount )
			return

		projectile.proj.projectileBounceCount++
	#endif
}