//Made by @CafeFPS

global function MpWeaponFlameThrower_Init
global function OnWeaponPrimaryAttack_weapon_FlameThrower
global function OnProjectileCollision_weapon_FlameThrower
global function OnWeaponActivate_weapon_FlameThrower
global function OnWeaponDeactivate_weapon_FlameThrower

const array<asset> FIRE_PARTICLES = [
	$"P_fire_loop_sm",
	$"P_fire_loop_MD",
	$"P_fire_loop_LG_short_1",
	$"P_fire_loop_XL",
	$"P_fire_med_FULL"
]

void function MpWeaponFlameThrower_Init()
{
	foreach(fx in FIRE_PARTICLES)
		PrecacheParticleSystem(fx)
		
	PrecacheParticleSystem($"P_wpn_meteor_flamethrower_trail")
	PrecacheParticleSystem($"P_fire_jet_med_nomdl")
	PrecacheParticleSystem($"P_xo_flamethrower_proj")
	PrecacheParticleSystem($"P_fire_loop_LG_short_1")
	#if CLIENT
	RegisterSignal("RestartEndFlameTimer")
	#endif
}

var function OnWeaponPrimaryAttack_weapon_FlameThrower( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	#if SERVER
	thread ShootFlameThrower(weapon, attackParams)
	#endif
	return 1
}

#if SERVER
void function ShootFlameThrower(entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity player = weapon.GetWeaponOwner()
	int damageFlags = weapon.GetWeaponDamageFlags()
	WeaponFireBoltParams fireBoltParams
	fireBoltParams.pos = attackParams.pos
	fireBoltParams.dir = attackParams.dir
	fireBoltParams.speed = 1
	fireBoltParams.scriptTouchDamageType = damageFlags
	fireBoltParams.scriptExplosionDamageType = damageFlags
	fireBoltParams.clientPredicted = false
	fireBoltParams.additionalRandomSeed = 0
	entity bullet = weapon.FireWeaponBoltAndReturnEntity( fireBoltParams )
	bullet.SetModel($"mdl/dev/empty_model.rmdl")
	
	EndSignal( bullet, "OnDestroy" )
	EndSignal( player, "OnDestroy" )
	EndSignal( player, "OnDeath" )

	WaitFrame()

	entity fx2 = StartParticleEffectOnEntity_ReturnEntity(bullet, GetParticleSystemIndex( $"P_wpn_meteor_flamethrower_trail" ), FX_PATTACH_ABSORIGIN_FOLLOW, 0 )
	
	WaitFrame()

	entity fx = StartParticleEffectOnEntity_ReturnEntity(bullet, GetParticleSystemIndex( $"P_xo_flamethrower_proj" ), FX_PATTACH_ABSORIGIN_FOLLOW, 0 )
	entity fx3 = StartParticleEffectOnEntity_ReturnEntity(bullet, GetParticleSystemIndex( $"P_fire_loop_LG_short_1" ), FX_PATTACH_ABSORIGIN_FOLLOW, 0 )
	entity fx4 = StartParticleEffectOnEntity_ReturnEntity(bullet, GetParticleSystemIndex( $"P_fire_jet_med_nomdl" ), FX_PATTACH_ABSORIGIN_FOLLOW, 0 )

	fx.SetAngles(player.GetAngles())
	fx3.SetAngles(player.GetAngles())
	fx4.SetAngles(player.GetAngles())
}
#endif

#if CLIENT
void function CheckForClickPressed(entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	
	OnThreadEnd(
		function() : (player)
		{
			
		}
	)
	bool onetime
	while( IsValid(weapon) && IsValid(player) )
	{
		if( !weapon.IsReloading() && player.IsInputCommandHeld( IN_ATTACK ) )
		{
			if( onetime )
			{
				EmitSoundOnEntity(weapon, "Canyonlands_Generic_Emit_RingOfFire_Constant")
			}
			onetime = false
		}
		else
		{
			if( !onetime )
			{
				FadeOutSoundOnEntity(weapon, "Canyonlands_Generic_Emit_RingOfFire_Constant", 3.0)
				Signal(weapon, "RestartEndFlameTimer")
				thread FlameOnWeaponAfterShotWatcher(weapon)
			}
			onetime = true
		}
		
		WaitFrame()
	}
}
#endif

#if CLIENT
void function FlameOnWeaponAfterShotWatcher(entity weapon)
{
	EndSignal(weapon, "RestartEndFlameTimer")
	
	OnThreadEnd(
		function() : (weapon)
		{
			if(IsValid(weapon))
			{
				weapon.StopWeaponEffect( $"P_fire_jet_med_nomdl", $"P_fire_jet_med_nomdl" )
				StopSoundOnEntity(weapon, "Grave_Emit_FireJet")
			}			
		}
	)
	
	weapon.PlayWeaponEffect( $"P_fire_jet_med_nomdl", $"P_fire_jet_med_nomdl", "muzzle_flash" )
	EmitSoundOnEntity(weapon, "Grave_Emit_FireJet")
	wait 3
}
#endif

void function OnProjectileCollision_weapon_FlameThrower( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical )
{
	#if SERVER
	entity player = projectile.GetOwner()
	vector GoodAngles = AnglesOnSurface(normal, -AnglesToRight(player.EyeAngles()))
	
	if(RandomFloatRange(0,1) > 0.7)
	{
		entity fire = CreateEntity( "trigger_cylinder" )
		fire.SetRadius( 50 )
		fire.SetAboveHeight( 25 )
		fire.SetBelowHeight( 25 )
		fire.SetOrigin( projectile.GetOrigin() )
		DispatchSpawn( fire )
		fire.SetOwner(player)
		fire.SetEnterCallback( NPCOrPlayerWillStartBurning )

		StartParticleEffectInWorld_ReturnEntity(GetParticleSystemIndex(FIRE_PARTICLES.getrandom()), projectile.GetOrigin(), GoodAngles )
		
		if(IsDoor(hitEnt)) 
		{
			EmitSoundAtPosition( TEAM_ANY, hitEnt.GetOrigin(), "Door_Impact_Breach" )
			EmitSoundAtPosition( TEAM_ANY, hitEnt.GetOrigin(), "tone_jog_stress_3p" )		
			EmitSoundAtPosition( TEAM_ANY, hitEnt.GetOrigin(), "Door_Impact_Break" )	
			hitEnt.Destroy()
		}
	}
	#endif
}

#if SERVER
void function NPCOrPlayerWillStartBurning( entity trigger, entity player )
{
	thread EntWillStartBurning_Thread(trigger, player)
}

void function EntWillStartBurning_Thread(entity trigger, entity ent)
{
	if(!IsValid(ent) || IsValid(ent) && !ent.IsPlayer() && !ent.IsNPC()) return

	EndSignal(ent, "OnDeath")
	
	entity fx
	
	if(!IsDoor(ent))
		fx = StartParticleEffectOnEntity_ReturnEntity(ent, GetParticleSystemIndex(FIRE_PARTICLES[0]), FX_PATTACH_ABSORIGIN_FOLLOW, 0 )
	
	OnThreadEnd(
		function() : (ent, fx)
		{
			if(IsValid(ent))
				Highlight_ClearEnemyHighlight( ent )
			if(IsValid(fx))
				fx.Destroy()
		}
	)
	
	Highlight_SetEnemyHighlight( ent, "survival_enemy_skydiving" )
	
	float endTime = Time() + 3

	while(Time() <= endTime && IsValid(ent))
	{
		ent.TakeDamage( 1, trigger.GetOwner(), null, { scriptType = DF_BYPASS_SHIELD | DF_DOOMED_HEALTH_LOSS, damageSourceId = eDamageSourceId.deathField } )
		wait 0.15
	}	
}

#endif

void function OnWeaponActivate_weapon_FlameThrower( entity weapon )
{
	#if CLIENT
	thread CheckForClickPressed(weapon)
	#endif
}

void function OnWeaponDeactivate_weapon_FlameThrower( entity weapon )
{
	weapon.StopWeaponEffect( $"P_fire_jet_med_nomdl", $"P_fire_jet_med_nomdl" )
	StopSoundOnEntity(weapon, "Canyonlands_Generic_Emit_RingOfFire_Constant")
	StopSoundOnEntity(weapon, "Grave_Emit_FireJet")	
}