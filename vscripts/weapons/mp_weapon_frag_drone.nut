global function OnProjectileCollision_weapon_frag_drone
global function OnProjectileExplode_weapon_frag_drone
global function OnWeaponAttemptOffhandSwitch_weapon_frag_drone
global function OnWeaponTossReleaseAnimEvent_weapon_frag_drone
global function MpWeaponFragDrone_Init

void function MpWeaponFragDrone_Init()
{
	RegisterSignal( "OnFragDroneCollision" )

	#if SERVER
		AddDamageCallbackSourceID( eDamageSourceId.damagedef_frag_drone_throwable_PLAYER, FragDrone_OnDamagePlayerOrNPC )
	#endif
}

void function OnProjectileCollision_weapon_frag_drone( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical )
{
	#if SERVER
		if ( hitEnt.GetClassName() != "func_brush" )
		{
			if ( projectile.proj.projectileBounceCount > 0 )
				return

			float dot = normal.Dot( Vector( 0, 0, 1 ) )

			if ( dot < 0.7 )
				return

			projectile.proj.projectileBounceCount += 1

 			thread DelayedExplode( projectile, 0.001 )
		}
	#endif
}


var function OnWeaponTossReleaseAnimEvent_weapon_frag_drone( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	Grenade_OnWeaponTossReleaseAnimEvent( weapon, attackParams )
	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
}


void function OnProjectileExplode_weapon_frag_drone( entity projectile )
{
	#if SERVER
			vector origin = projectile.GetOrigin()
			entity owner = projectile.GetThrower()

			if ( !IsValid( owner ) )
				return

			int team = owner.GetTeam()

			entity drone = CreateFragDroneCan( team, origin, < 0, projectile.GetAngles().y, 0 > )
			SetSpawnOption_AISettings( drone, "npc_frag_drone_throwable" )
			DispatchSpawn( drone )

			vector ornull clampedPos = NavMesh_ClampPointForAIWithExtents( origin, drone, < 20, 20, 36 > )
			if ( clampedPos != null )
			{
				expect vector( clampedPos )
				drone.SetOrigin( clampedPos )
			}
			else
			{
				projectile.GrenadeExplode( Vector( 0, 0, 0 ) )
				drone.Signal( "SuicideSpectreExploding" )
				return
			}

			int followBehavior = GetDefaultNPCFollowBehavior( drone )
			if ( owner.IsPlayer() )
			{
				drone.SetBossPlayer( owner )
				UpdateEnemyMemoryWithinRadius( drone, 1000 )
			}
			else if ( owner.IsNPC() )
			{
				entity enemy = owner.GetEnemy()
				if ( IsAlive( enemy ) )
					drone.SetEnemy( enemy )
			}

			if ( IsSingleplayer() && IsAlive( owner ) )
			{
				drone.InitFollowBehavior( owner, followBehavior )
				drone.EnableBehavior( "Follow" )
			}
			else
			{
				drone.EnableNPCFlag( NPC_ALLOW_PATROL | NPC_ALLOW_INVESTIGATE | NPC_NEW_ENEMY_FROM_SOUND )
			}

			thread FragDroneDeplyAnimation( drone, 0.0, 0.1 )
			thread WaitForEnemyNotification( drone )
			thread FragDroneLifetime( drone )
	#endif
}

#if SERVER
void function FragDroneLifetime( entity drone )
{
	drone.EndSignal( "OnDestroy" )
	drone.EndSignal( "OnDeath" )

	EmitSoundOnEntity( drone, "weapon_sentryfragdrone_emit_loop" )
	wait 55.0
	drone.Signal( "SuicideSpectreExploding" )
}

void function DelayedExplode( entity projectile, float delay )
{
	projectile.Signal( "OnFragDroneCollision" )
	projectile.EndSignal( "OnFragDroneCollision" )
	projectile.EndSignal( "OnDestroy" )

	wait delay
	while( TraceLineSimple( projectile.GetOrigin(), projectile.GetOrigin() - <0,0,15>, projectile ) == 1.0 )
		wait 0.25

	projectile.GrenadeExplode( Vector( 0, 0, 0 ) )
}

void function WaitForEnemyNotification( entity drone )
{
	drone.EndSignal( "OnDeath" )

	entity owner
	entity currentTarget

	while ( true )
	{
		//----------------------------------
		// Get owner and current enemy
		//----------------------------------
		currentTarget = drone.GetEnemy()
		owner = drone.GetFollowTarget()

		//----------------------------------
		// Free roam if owner is dead or HasEnemy
		//----------------------------------
		if ( !IsAlive( owner ) || currentTarget != null )
		{
			drone.DisableBehavior( "Follow" )
		}
		else
		{
			drone.ClearEnemy()
			drone.EnableBehavior( "Follow" )
		}

		wait 0.25
	}

}

void function FragDrone_OnDamagePlayerOrNPC( entity ent, var damageInfo )
{
	if ( !IsValid( ent ) )
		return

	entity attacker = DamageInfo_GetAttacker( damageInfo )
	if ( !IsValid( attacker ) )
		return

	if ( ent != attacker )
		return

	DamageInfo_SetDamage( damageInfo, 0.0 )
}

#endif

bool function OnWeaponAttemptOffhandSwitch_weapon_frag_drone( entity weapon )
{
	entity weaponOwner = weapon.GetOwner()
	if ( weaponOwner.IsPhaseShifted() )
		return false

	return true
}
