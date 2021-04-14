global function OnProjectileCollision_weapon_grenade_emp

void function OnProjectileCollision_weapon_grenade_emp( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical )
{
	entity player = projectile.GetOwner()
	if ( hitEnt == player )
		return

	table collisionParams =
	{
		pos = pos,
		normal = normal,
		hitEnt = hitEnt,
		hitbox = hitbox
	}

	bool result = PlantStickyEntity( projectile, collisionParams )

	if ( projectile.GrenadeHasIgnited() )
		return

	projectile.GrenadeIgnite()

	#if SERVER
		thread ArcCookSound( projectile )
	#endif
}

void function ArcCookSound( entity projectile )
{
	projectile.EndSignal( "OnDestroy" )

	string cookSound = expect string( projectile.ProjectileGetWeaponInfoFileKeyField( "sound_cook_warning" ) )
	float ignitionTime = expect float( projectile.ProjectileGetWeaponInfoFileKeyField( "grenade_ignition_time" ) )

	float stickTime = 0.2
	wait stickTime  // let it make a stick sound before alarm starts

	EmitSoundOnEntity( projectile, cookSound )
}