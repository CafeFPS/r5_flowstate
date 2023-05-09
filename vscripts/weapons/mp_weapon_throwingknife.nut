untyped

global function ThrowingKnife_Init
global function OnProjectileCollision_weapon_throwingknife

const int KNIFE_DESPAWN_TIME = 5
const float FLT_EPSILON = 1.0e-6

void function ThrowingKnife_Init()
{
    PrecacheModel( $"mdl/weapons/throwingknife/ptpov_throwing_knife.rmdl" )
    PrecacheModel( $"mdl/weapons/throwingknife/w_throwing_knife.rmdl" )
}

void function OnProjectileCollision_weapon_throwingknife( entity projectile, vector pos, vector normal, entity hitEnt, int hitBox, bool isCritical )
{

	if ( !IsValid( projectile ) )
		return

	if ( !IsValid( hitEnt ) )
	{
		#if SERVER
	    projectile.Destroy()
		#endif
		return
	}

	bool ignoreTarget = false

	if ( IsValid( projectile.GetOwner() ) && hitEnt == projectile.GetOwner() )
		ignoreTarget = true


	if ( hitEnt.IsPlayer() && IsFriendlyTeam( hitEnt.GetTeam(), projectile.GetTeam() ) )
		ignoreTarget = true

	//if ( hitEnt.IsPlayerVehicle() )
	//	ignoreTarget = true

	//if ( hitEnt.IsPlayer() && StatusEffect_GetTimeRemaining (hitEnt, eStatusEffect.death_totem_recall) )
	//	ignoreTarget = true

	vector forward = AnglesToForward( VectorToAngles( projectile.GetVelocity() ) )
	vector stickNormal

	if ( LengthSqr( forward ) > FLT_EPSILON )
		stickNormal = forward
	else
		stickNormal = normal


    vector plantpos = pos + (projectile.proj.savedDir)
    table collisionParams =
    {
        pos = pos + (projectile.proj.savedDir),
        normal = stickNormal,
        hitEnt = hitEnt,
        hitbox = hitBox
    }

	projectile.kv.solid = 0
	//projectile.SetDoesExplode( false )

	vector plantAngles = AnglesCompose( VectorToAngles( collisionParams.normal ), <90,0,0> )

	if ( !PlantStickyEntity( projectile, collisionParams, <90,0,0> ) || ignoreTarget )
	{

		projectile.StopPhysics()
		projectile.SetVelocity( <0, 0, 0> )

        projectile.SetOrigin( plantpos )
        projectile.SetAngles( plantAngles )
	}
	else
	{
		if ( IsValid( projectile ) )
		{
			#if CLIENT
                projectile.SetOrigin( plantpos )
                projectile.SetAngles( plantAngles )
			#endif

			if ( IsValid( projectile.GetWeaponSource() ) &&  GetGrenadeProjectileSound( projectile.GetWeaponSource() ) != "" )
				StopSoundOnEntity( projectile, GetGrenadeProjectileSound( projectile.GetWeaponSource() ) )

            #if SERVER
			thread function(entity projectile, entity hitEnt, int KNIFE_DESPAWN_TIME) : ()
            {
                wait KNIFE_DESPAWN_TIME

                if(IsValid(projectile))
                    projectile.Destroy()

            }(projectile, hitEnt, KNIFE_DESPAWN_TIME)
            #endif
		}
	}
}