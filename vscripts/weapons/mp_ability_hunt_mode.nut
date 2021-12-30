//By AyeZee
//Modified and finished by ColombiaFPS
// changelist by Colombia:
// -bounce
// -improve border trigger - w~a ability
// -correct time: 10
// -correct height: 1100
// -correct speed: ~300
// -better visuals!
// -timer so gravity lift dissapears
// -s11 horizon values
// -projectile indicator!

untyped

global function MpAbilityHuntModeWeapon_Init

global function OnProjectileCollision_lift
global function OnProjectileIgnite_lift
global function Lift_OnWeaponTossRelease

float LIFT_DURATION = 10.0

function MpAbilityHuntModeWeapon_Init()
{

	PrecacheParticleSystem( $"P_wpn_BBunker_beam" )
	PrecacheParticleSystem( $"P_wpn_BBunker_beam_end" )
}

var function Lift_OnWeaponTossRelease( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	#if SERVER
	var result = Lift_OnWeaponToss( weapon, attackParams, 1.0 )
	return result
	#endif
}

int function Lift_OnWeaponToss( entity weapon, WeaponPrimaryAttackParams attackParams, float directionScale )
{
	weapon.EmitWeaponSound_1p3p( GetGrenadeThrowSound_1p( weapon ), GetGrenadeThrowSound_3p( weapon ) )
	bool projectilePredicted = PROJECTILE_PREDICTED
	bool projectileLagCompensated = PROJECTILE_LAG_COMPENSATED
#if SERVER
	if ( weapon.IsForceReleaseFromServer() )
	{
		projectilePredicted = false
		projectileLagCompensated = false
	}
#endif
	entity grenade = Lift_Launch( weapon, attackParams.pos, (attackParams.dir * directionScale), projectilePredicted, projectileLagCompensated )
	entity weaponOwner = weapon.GetWeaponOwner()
	weaponOwner.Signal( "ThrowGrenade" )

	PlayerUsedOffhand( weaponOwner, weapon, true, grenade ) // intentionally here and in Hack_DropGrenadeOnDeath - accurate for when cooldown actually begins

	if ( IsValid( grenade ) )
		grenade.proj.savedDir = weaponOwner.GetViewForward()

#if SERVER
	#if BATTLECHATTER_ENABLED
		TryPlayWeaponBattleChatterLine( weaponOwner, weapon )
	#endif
#endif

	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
}

entity function Lift_Launch( entity weapon, vector attackPos, vector throwVelocity, bool isPredicted, bool isLagCompensated )
{
	//TEMP FIX while Deploy anim is added to sprint
	float currentTime = Time()
	if ( weapon.w.startChargeTime == 0.0 )
		weapon.w.startChargeTime = currentTime

	// Note that fuse time of 0 means the grenade won't explode on its own, instead it depends on OnProjectileCollision() functions to be defined and explode there.
	float fuseTime = weapon.GetGrenadeFuseTime()
	bool startFuseOnLaunch = bool( weapon.GetWeaponInfoFileKeyField( "start_fuse_on_launch" ) )

	if ( fuseTime > 0 && !startFuseOnLaunch )
	{
		fuseTime = fuseTime - ( currentTime - weapon.w.startChargeTime )
		if ( fuseTime <= 0 )
			fuseTime = 0.001
	}

	// NOTE: DO NOT apply randomness to angularVelocity, it messes up lag compensation
	// KNOWN ISSUE: angularVelocity is applied relative to the world, so currently the projectile spins differently based on facing angle
	vector angularVelocity = <10, -1600, 10>

	int damageFlags = weapon.GetWeaponDamageFlags()
	WeaponFireGrenadeParams fireGrenadeParams
	fireGrenadeParams.pos = attackPos
	fireGrenadeParams.vel = throwVelocity
	fireGrenadeParams.angVel = angularVelocity
	fireGrenadeParams.fuseTime = fuseTime
	fireGrenadeParams.scriptTouchDamageType = (damageFlags & ~DF_EXPLOSION) // when a grenade "bonks" something, that shouldn't count as explosive.explosive
	fireGrenadeParams.scriptExplosionDamageType = damageFlags
	fireGrenadeParams.clientPredicted = isPredicted
	fireGrenadeParams.lagCompensated = isLagCompensated
	fireGrenadeParams.useScriptOnDamage = true
	entity frag = weapon.FireWeaponGrenade( fireGrenadeParams )
	if ( frag == null )
		return null

	#if SERVER
		entity owner = weapon.GetWeaponOwner()
		if ( IsValid( owner ) )
		{
			if ( IsWeaponOffhand( weapon ) )
			{
				AddToUltimateRealm( owner, frag )
			}
			else
			{
				frag.RemoveFromAllRealms()
				frag.AddToOtherEntitysRealms( owner )
			}
		}

		//HolsterAndDisableWeapons( owner )
        //owner.ForceStand()
	#endif

	Lift_OnPlayerNPCTossGrenade_Common( weapon, frag )

	return frag
}

void function Lift_OnPlayerNPCTossGrenade_Common( entity weapon, entity frag )
{
	LiftThrow_Init( frag, weapon )
	#if SERVER
		thread TrapExplodeOnDamage( frag, 20, 0.0, 0.0 )
		
		string projectileSound = GetGrenadeProjectileSound( weapon )
		if ( projectileSound != "" )
			EmitSoundOnEntity( frag, projectileSound )

		entity fxID = StartParticleEffectOnEntity_ReturnEntity( frag, GetParticleSystemIndex( $"P_ar_holopilot_trail" ), FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
		entity fxID2 = StartParticleEffectOnEntity_ReturnEntity( frag, GetParticleSystemIndex( $"P_ar_holopilot_trail" ), FX_PATTACH_ABSORIGIN_FOLLOW, -1 )

	#endif
}

void function LiftThrow_Init( entity grenade, entity weapon )
{
	entity weaponOwner = weapon.GetOwner()
	if ( IsValid( weaponOwner ) )
		SetTeam( grenade, weaponOwner.GetTeam() )

	// JFS: this is because I don't know if the above line should be
	// weapon.GetOwner() or it's a typo and should really be weapon.GetWeaponOwner()
	// and it's too close to ship and who knows what effect that will have
	entity owner = weapon.GetWeaponOwner()
	if ( IsValid( owner ) && owner.IsNPC() )
		SetTeam( grenade, owner.GetTeam() )

	#if SERVER
		bool smartPistolVisible = weapon.GetWeaponSettingBool( eWeaponVar.projectile_visible_to_smart_ammo )
		if ( smartPistolVisible )
		{
			grenade.SetDamageNotifications( true )
			grenade.SetTakeDamageType( DAMAGE_EVENTS_ONLY )
			grenade.proj.onlyAllowSmartPistolDamage = true

			if ( !grenade.GetProjectileWeaponSettingBool( eWeaponVar.projectile_damages_owner ) && !grenade.GetProjectileWeaponSettingBool( eWeaponVar.explosion_damages_owner ) )
				SetCustomSmartAmmoTarget( grenade, true ) // prevent friendly target lockon
		}
		else
		{
			grenade.SetTakeDamageType( DAMAGE_NO )
		}
	#endif
		
}

void function OnProjectileCollision_lift( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical )
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

	bool result = PlantStickyEntityOnWorldThatBouncesOffWalls( projectile, collisionParams, 0.7 )

	#if SERVER
	entity bottom = CreateEntity( "trigger_cylinder" )
	bottom.SetRadius( 25 )
	bottom.SetAboveHeight( 1100 )
	bottom.SetBelowHeight( 0 )
	bottom.SetOrigin( pos )
	bottom.RemoveFromAllRealms()
	bottom.AddToOtherEntitysRealms( projectile )
	DispatchSpawn( bottom )

	entity top = CreateEntity( "trigger_cylinder" )
	top.SetRadius( 50 )
	top.SetAboveHeight( 0 )
	top.SetBelowHeight( 24 )
	top.SetOrigin( pos + <0, 0, 1100> )
	top.RemoveFromAllRealms()
	top.AddToOtherEntitysRealms( projectile )
	top.SetLeaveCallback( TopTriggerLeave )
	DispatchSpawn( top )
	
	projectile.proj.projectileBounceCount++
	if ( !result && projectile.proj.projectileBounceCount < 10 )
	{
		return
	}
	else if ( IsValid( hitEnt ) && ( hitEnt.IsPlayer() || hitEnt.IsTitan() || hitEnt.IsNPC() ) )
	{
		projectile.Destroy()
		thread liftplayerup(bottom, top, pos)
		thread liftCreator(pos)
	}
	else
	{
		projectile.Destroy()
		thread liftplayerup(bottom, top, pos)
		thread liftCreator(pos)
	}
	#endif
}

#if SERVER

void function liftCreator(vector pos)
{
	
	entity gravLiftBeam2 = StartParticleEffectInWorld_ReturnEntity(GetParticleSystemIndex( $"P_wpn_BBunker_beam"), pos + <0, 0, 256>, <90, 0, 0> )
	entity gravLiftBeam3 = StartParticleEffectInWorld_ReturnEntity(GetParticleSystemIndex( $"P_wpn_BBunker_beam"), pos + <0, 0, 256>, <-90, 0, 0> )
	entity gravLiftBeam4 = StartParticleEffectInWorld_ReturnEntity(GetParticleSystemIndex( $"P_wpn_BBunker_beam"), pos + <0, 0, 512>, <90, 0, 0> )
	entity gravLiftBeam5 = StartParticleEffectInWorld_ReturnEntity(GetParticleSystemIndex( $"P_wpn_BBunker_beam"), pos + <0, 0, 512>, <-90, 0, 0> )
	entity gravLiftBeam6 = StartParticleEffectInWorld_ReturnEntity(GetParticleSystemIndex( $"P_wpn_BBunker_beam"), pos + <0, 0, 768 >, <-90, 0, 0> )
	
	wait 0.15
	EffectSetControlPointVector( gravLiftBeam2, 1, <0, 255, 255> )
	wait 0.15
	EffectSetControlPointVector( gravLiftBeam3, 1, <0, 255, 255> )
	wait 0.15
	EffectSetControlPointVector( gravLiftBeam4, 1, <0, 255, 255> )
	wait 0.15
	EffectSetControlPointVector( gravLiftBeam5, 1, <0, 255, 255> )
	wait 0.15
	EffectSetControlPointVector( gravLiftBeam6, 1, <0, 255, 255> )
	
	//destroyers
	thread liftWatcher(gravLiftBeam2,gravLiftBeam3)
	thread liftWatcher2(gravLiftBeam4,gravLiftBeam5)
	thread liftWatcher3(gravLiftBeam6)
}

void function TopTriggerLeave( entity trigger, entity ent )
{
	if ( !ent.IsPlayer() )
		return
		
	vector forward = AnglesToForward( ent.GetAngles() )
	vector velocity = ent.GetVelocity()
	velocity += forward * 150
	ent.SetVelocity( <ent.GetVelocity().x, ent.GetVelocity().y, 400> + velocity )
}

void function liftplayerup( entity bottom, entity top, vector pos )
{
float endTime = Time() + LIFT_DURATION

while( Time() <= endTime )
	{
		foreach(player in GetPlayerArray())
        {
			if(top.IsTouching(player))
			{
				player.SetVelocity( <player.GetVelocity().x, player.GetVelocity().y, 25> )
				vector enemyOrigin = player.GetOrigin()
				vector dir = Normalize( pos - player.GetOrigin() )
				float dist = Distance( enemyOrigin, pos )
				float distZ = enemyOrigin.z - pos.z
				vector newVelocity = player.GetVelocity() * GraphCapped( dist, 50, 600.0, 0, 1 ) + dir * GraphCapped( dist, 50, 600.0, 0, 300.0 ) + < 0, 0, GraphCapped( 300, -50, 0, 300, 0 )>
				newVelocity.z = 25
				player.SetVelocity( newVelocity )
			}
			else if(bottom.IsTouching(player))
			{
				
				player.SetVelocity( <player.GetVelocity().x, player.GetVelocity().y, 300> )
				vector enemyOrigin = player.GetOrigin()
				vector dir = Normalize( pos - player.GetOrigin() )
				float dist = Distance( enemyOrigin, pos )
				float distZ = enemyOrigin.z - pos.z
				vector newVelocity = player.GetVelocity() * GraphCapped( dist, 50, 600.0, 0, 1 ) + dir * GraphCapped( dist, 50, 600.0, 0, 300.0 ) + < 0, 0, GraphCapped( 300, -50, 0, 300, 0 )>
				newVelocity.z = 350
				player.SetVelocity( newVelocity )
			}
		}
		wait 0.01
	}

}

void function liftWatcher(entity gravLiftBeam2,entity gravLiftBeam3)
{	
wait LIFT_DURATION
	gravLiftBeam2.Destroy()
	gravLiftBeam3.Destroy()
}


void function liftWatcher2(entity gravLiftBeam4,entity gravLiftBeam5)
{
wait LIFT_DURATION
	gravLiftBeam4.Destroy()
	gravLiftBeam5.Destroy()
}
void function liftWatcher3(entity gravLiftBeam6)
{
wait LIFT_DURATION
	gravLiftBeam6.Destroy()
}

#endif

void function OnProjectileIgnite_lift( entity projectile )
{

}