untyped

global function OnWeaponPrimaryAttack_weapon_softball
global function OnProjectileCollision_weapon_softball

#if SERVER
global function OnWeaponNpcPrimaryAttack_weapon_softball
#endif // #if SERVER

const float FUSE_TIME 				= 2.0 //Applies once the grenade has stuck to a surface.
const asset SOFTBALL_PROJECTILE_IMP 	= $"P_impact_exp_smll_metal"

var function OnWeaponPrimaryAttack_weapon_softball( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	PrecacheParticleSystem( SOFTBALL_PROJECTILE_IMP )
	entity player = weapon.GetWeaponOwner()

	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )
	//vector bulletVec = ApplyVectorSpread( attackParams.dir, player.GetAttackSpreadAngle() * 2.0 )
	//attackParams.dir = bulletVec

	if ( IsServer() || weapon.ShouldPredictProjectiles() )
	{
		vector offset = Vector( 30.0, 6.0, -4.0 )
		if ( weapon.IsWeaponInAds() )
			offset = Vector( 30.0, 0.0, -3.0 )
		vector attackPos = player.OffsetPositionFromView( attackParams[ "pos" ], offset )	// forward, right, up
		FireGrenade( weapon, attackParams )
	}
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_weapon_softball( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	PrecacheParticleSystem( SOFTBALL_PROJECTILE_IMP )
	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )
	FireGrenade( weapon, attackParams, true )
}
#endif // #if SERVER

function FireGrenade( entity weapon, WeaponPrimaryAttackParams attackParams, isNPCFiring = false )
{
	vector angularVelocity = Vector( RandomFloatRange( -1200, 1200 ), 100, 0 )

	int damageType = DF_RAGDOLL | DF_EXPLOSION

	WeaponFireGrenadeParams fireGrenadeParams
	fireGrenadeParams.pos                   = attackParams.pos
	fireGrenadeParams.vel                   = attackParams.dir
	fireGrenadeParams.angVel                = angularVelocity
	fireGrenadeParams.clientPredicted       = !isNPCFiring
	fireGrenadeParams.lagCompensated        = true
	fireGrenadeParams.useScriptOnDamage     = false

	int damageFlags = weapon.GetWeaponDamageFlags()
	fireGrenadeParams.scriptTouchDamageType     = (damageFlags & ~DF_EXPLOSION)
	fireGrenadeParams.scriptExplosionDamageType = damageFlags
	fireGrenadeParams.fuseTime                  = weapon.GetWeaponSettingFloat( eWeaponVar.projectile_lifetime )
	entity deployable                           = weapon.FireWeaponGrenade( fireGrenadeParams )
    entity nade                                 = weapon.FireWeaponGrenade( fireGrenadeParams )

	if ( nade )
	{
		#if SERVER
			EmitSoundOnEntity( nade, "Weapon_softball_Grenade_Emitter" )
			Grenade_Init( nade, weapon )
		#else
			entity weaponOwner = weapon.GetWeaponOwner()
			SetTeam( nade, weaponOwner.GetTeam() )
		#endif
	}
}

void function OnProjectileCollision_weapon_softball( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical )
{
	bool didStick = PlantSuperStickyGrenade( projectile, pos, normal, hitEnt, hitbox )
	if ( !didStick )
		return

	#if SERVER
		if ( IsAlive( hitEnt ) && hitEnt.IsPlayer() )
		{
			EmitSoundOnEntityOnlyToPlayer( projectile, hitEnt, "weapon_softball_grenade_attached_1P" )
			EmitSoundOnEntityExceptToPlayer( projectile, hitEnt, "weapon_softball_grenade_attached_3P" )
            EmitSoundOnEntityOnlyToPlayer( projectile, hitEnt, "explo_softball_impact_1p" )
			EmitSoundOnEntityExceptToPlayer( projectile, hitEnt, "explo_softball_impact_3p" )
		}
		else
		{
            EmitSoundOnEntity( projectile, "explo_softball_impact_3p" )
			EmitSoundOnEntity( projectile, "weapon_softball_grenade_attached_3P" )
		}
		thread DetonateStickyAfterTime( projectile, FUSE_TIME, normal )
	#endif
}

#if SERVER
// need this so grenade can use the normal to explode
void function DetonateStickyAfterTime( entity projectile, float delay, vector normal )
{
	wait delay
	if ( IsValid( projectile ) )
    {
        projectile.GrenadeExplode( normal )
    }

}
#endif