//Made by @CafeFPS and Julefox#0050 ( 2022, dev script )

global function OnWeaponTossReleaseAnimEvent_Turret
global function OnWeaponAttemptOffhandSwitch_Turret
global function OnWeaponTossPrep_Turret
global function OnProjectileCollision_voltturret

#if SERVER
global function TurretPlasma_Init
global function Turret
global function OnWeaponNpcPrimaryAttack_voltturret

///CONFIGS///
bool DAMAGEOWNER = true // toggle friendly
string NPC_WEAPON = "npc_weapon_turret_volt"
string NPC_WEAPON_AUDIO = "weapon_smartpistol_firesuppressed_3p"
// string NPC_WEAPON = "mp_weapon_nuke_launcher" //i changed nuke fx, i don't know why is projectile going far
// string NPC_WEAPON_AUDIO = "weapon_softball_fire_3p"
float TURRET_MODELSCALE = 2.8 //ok value
float TURRET_RADIUS = 400
float TURRET_HEALTH = 150
float TURRET_SLOW_AMOUNT = 0.5
bool RADIUS_FX_ENABLED = true
///////////

const asset PC1     = $"mdl/robotics_r2/turret_plasma/plasma_turret_pc_1.rmdl" // cannon
const asset PC2     = $"mdl/robotics_r2/turret_plasma/plasma_turret_pc_2.rmdl" // ammo_box
const asset PC3     = $"mdl/robotics_r2/turret_plasma/plasma_turret_pc_3.rmdl" // body
const asset VEHICLE = $"mdl/vehicles_r5/land/msc_truck_mod_lrg/veh_land_msc_truck_mod_police_lrg_01_closed_static.rmdl"
const LASER_SHORT   = $"P_wpn_lasercannon_aim_short"
const LASER_LONG    = $"P_wpn_lasercannon_aim_long"
const array< string > SOUND  = [ "Boost_Card_SentryTurret_Scanning_Loop_3P", "Boost_Card_AP_SentryTurret_PowerUp_3P", "Boost_Card_SentryTurret_Deployed_3P", "Boost_Card_SentryTurret_Leg_Servo_3P" ]
const array< string > RANDOM_SOUND  = [ "radarpulse_on", "weapon_proximitymine_armedbeep"]
const array< asset >  TURRET       = [ PC1, PC2 ]
const array< vector > TURRET_VEC   = [ < 4, -7, 22 >, < 0, 0, 10 > ]

void function TurretPlasma_Init() 
{
	PrecacheModel( PC1 )
	PrecacheModel( PC2 )
	PrecacheModel( PC3 )
	PrecacheModel ($"mdl/fx/ar_survival_cylinder.rmdl")
	PrecacheModel ($"mdl/fx/ar_survival_radius_1x100.rmdl")
	
	PrecacheParticleSystem( LASER_SHORT )
	PrecacheParticleSystem( LASER_LONG )
	PrecacheParticleSystem( $"P_drone_exp_md" )
	PrecacheParticleSystem( $"P_plasma_exp_SM" )
	PrecacheParticleSystem( $"P_survival_cylinder_CP" )
	PrecacheParticleSystem( $"P_skydive_trail_CP" )
	PrecacheParticleSystem( $"P_plasma_proj_SM" )
	PrecacheParticleSystem( $"P_arc_green" )
	PrecacheParticleSystem( $"P_survival_radius_CP_1x100" )
	PrecacheParticleSystem($"P_survival_radius_1x100_test" )
	PrecacheModel( $"mdl/fx/ar_radiusmarker.rmdl" )
	PrecacheModel( $"mdl/weapons_r5/weapon_tesla_trap/mp_weapon_tesla_trap_ar_trigger_radius.rmdl" )
}
#endif

bool function OnWeaponAttemptOffhandSwitch_Turret( entity weapon )
{
	int ammoReq = weapon.GetAmmoPerShot()
	int currAmmo = weapon.GetWeaponPrimaryClipCount()
	if ( currAmmo < ammoReq )
		return false

	entity player = weapon.GetWeaponOwner()
	if ( player.IsPhaseShifted() )
		return false

	return true
}

var function OnWeaponTossReleaseAnimEvent_Turret( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	int ammoReq = weapon.GetAmmoPerShot()
	weapon.EmitWeaponSound_1p3p( GetGrenadeThrowSound_1p( weapon ), GetGrenadeThrowSound_3p( weapon ) )

	entity deployable = ThrowDeployable( weapon, attackParams, 800, OnTurretPlanted )
	if ( deployable )
	{
		entity player = weapon.GetWeaponOwner()
		PlayerUsedOffhand( player, weapon, true, deployable )

		#if SERVER

		#endif
	}

	return ammoReq
}

void function OnWeaponTossPrep_Turret( entity weapon, WeaponTossPrepParams prepParams )
{
	weapon.EmitWeaponSound_1p3p( GetGrenadeDeploySound_1p( weapon ), GetGrenadeDeploySound_3p( weapon ) )
}

void function OnTurretPlanted( entity projectile )
{
	#if SERVER
	Assert( IsValid( projectile ) )
	
	entity owner = projectile.GetOwner()
	
	if ( !IsValid( owner ) )
		{
			projectile.Destroy()
			return
		}

	entity turret = Turret(owner, projectile.GetOrigin(), owner)
	EmitSoundOnEntity(turret, SOUND[2])
	
	OnThreadEnd(
		function() : ( projectile )
		{
			if ( IsValid( projectile ) )
			{
				projectile.Dissolve( ENTITY_DISSOLVE_CORE, <0, 0, 0>, 100 )
			}
		}
	)
	#endif
}

void function OnProjectileCollision_voltturret( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical )
{
	#if SERVER
	if(hitEnt.IsPlayer() && hitEnt.e.islockedent)
	{
		StatusEffect_AddTimed( hitEnt, eStatusEffect.move_slow, TURRET_SLOW_AMOUNT, 1, 1 ) 
	}
	#endif
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_voltturret( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity dummy = weapon.GetOwner()
	if(dummy.e.stopTurretWeapon){
		printt("turret tried to shoot but it won't shoot!")
		return 0
	}
	printt("turret shooting!")
	EmitSoundOnEntity(weapon, NPC_WEAPON_AUDIO)
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
	bullet.MakeInvisible()
	bullet.kv.gravity = 1

	entity trailFXHandle = StartParticleEffectInWorld_ReturnEntity(GetParticleSystemIndex( $"P_plasma_proj_SM" ), bullet.GetOrigin(), <0, 0, 0>)
	trailFXHandle.SetParent(bullet, "ref")
	return 1
}

entity function Turret( entity ent, vector pos, entity owner ) 
{
	vector movingPartAng = < 0, 0, 0 >
	vector bodyAng = < 0, 0, 0 >
	pos += < 0, 0, 25 >

	entity root = CreateScriptMover( pos, movingPartAng )
	root.SetMaxHealth( TURRET_HEALTH )
	root.SetHealth( TURRET_HEALTH )
	root.SetDamageNotifications( true )
	root.SetTakeDamageType( DAMAGE_EVENTS_ONLY )
	
	entity turret_assemble = CreateEntity( "script_mover" )
	turret_assemble.kv.solid = 6
	turret_assemble.kv.CollisionGroup = TRACE_COLLISION_GROUP_PLAYER
	turret_assemble.AllowMantle()
	turret_assemble.kv.modelscale = TURRET_MODELSCALE
	turret_assemble.SetValueForModelKey( TURRET[0] )
	turret_assemble.kv.SpawnAsPhysicsMover = 0
	turret_assemble.SetOrigin( pos + TURRET_VEC[0] )
	turret_assemble.SetAngles( movingPartAng )
	DispatchSpawn( turret_assemble )
	turret_assemble.SetParent( root )
	AddEntityCallback_OnDamaged( turret_assemble, Turret_OnDamaged)
	turret_assemble.e.turretparts.append(root)
	turret_assemble.e.turretparts.append(turret_assemble)
	
	entity turret_assemble2 = CreateEntity( "script_mover" )
	turret_assemble2.kv.solid = 6
	turret_assemble.kv.CollisionGroup = TRACE_COLLISION_GROUP_PLAYER
	turret_assemble.AllowMantle()
	turret_assemble2.kv.modelscale = TURRET_MODELSCALE
	turret_assemble2.SetValueForModelKey( TURRET[1] )
	turret_assemble2.kv.SpawnAsPhysicsMover = 0
	turret_assemble2.SetOrigin( pos + TURRET_VEC[1] )
	turret_assemble2.SetAngles( movingPartAng )
	DispatchSpawn( turret_assemble2 )
	turret_assemble2.SetParent( root )
	AddEntityCallback_OnDamaged( turret_assemble2, Turret_OnDamaged)
	turret_assemble.e.turretparts.append(turret_assemble2)
	
	entity e = CreatePropDynamic(PC3,pos,bodyAng,0,20000)
	e.kv.modelscale = TURRET_MODELSCALE
	e.kv.fadedist = 20000
	e.kv.rendermode = 0
	e.kv.renderamt = 1
	e.kv.solid = 6
	e.kv.CollisionGroup = TRACE_COLLISION_GROUP_PLAYER
	e.AllowMantle()
	e.SetParent(root)
	AddEntityCallback_OnDamaged( e, Turret_OnDamaged)
	turret_assemble.e.turretparts.append(e)

	root.e.turretowner = owner
	thread CreateTurretTrigger(root, turret_assemble)
	if(RADIUS_FX_ENABLED) {
		if(DAMAGEOWNER) thread RadiusAlert(root, true)
			else thread RadiusAlert(root, false)
	}
	thread PlayTurretSound(root)
	thread PlayRandomTurretSound(root)
	//cool star icon: $"rui/pilot_loadout/kit/titan_cowboy_filled"
	//este no está mal: $"rui/events/s03e01a/item_source_icon" es como un escudo
	
	if(!DAMAGEOWNER)
	{
		entity wp = CreateWaypoint_BasicPos( root.GetOrigin() + <0,0,96>, "", $"rui/hud/gametype_icons/survival/survey_beacon_only_pathfinder" )
		wp.SetParent(root)
	}
	
	turret_assemble.SetUsable()
	turret_assemble.SetOwner( owner )
	turret_assemble.SetUsableByGroup( "owner" )
	turret_assemble.SetUsePrompts( "Hold %use% to remove this turret", "Press %use% to remove this turret" )
	AddCallback_OnUseEntity( turret_assemble, RemoveTurretThread )

	return e
}

void function RemoveTurretThread( entity turret, entity player, int useInputFlags )
{
	entity root = turret.GetParent()

	if ( !IsValid(root) )
		return

	foreach(entity part in turret.e.turretparts)
	{
		if(IsValid(part)) 
			part.Dissolve( ENTITY_DISSOLVE_CORE, <0, 0, 0>, 5000 )
	}
	
	if(IsValid(player)) 
		player.GetOffhandWeapon( OFFHAND_LEFT ).SetWeaponPrimaryClipCount( player.GetOffhandWeapon( OFFHAND_LEFT ).GetWeaponPrimaryClipCountMax() )
}

void function Turret_OnDamaged(entity proxy, var damageInfo)
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
{
	entity attacker = DamageInfo_GetAttacker(damageInfo)
	if (!attacker.IsPlayer()) return
	entity ent = proxy.GetParent()
	float damage = DamageInfo_GetDamage( damageInfo )
	attacker.NotifyDidDamage
	(
		ent,
		DamageInfo_GetHitBox( damageInfo ),
		DamageInfo_GetDamagePosition( damageInfo ), 
		DamageInfo_GetCustomDamageType( damageInfo ),
		DamageInfo_GetDamage( damageInfo ),
		DamageInfo_GetDamageFlags( damageInfo ), 
		DamageInfo_GetHitGroup( damageInfo ),
		DamageInfo_GetWeapon( damageInfo ), 
		DamageInfo_GetDistFromAttackOrigin( damageInfo )
	)
	float nextturrethealth = ent.GetHealth() - DamageInfo_GetDamage( damageInfo )

	if (nextturrethealth > 0 && IsValid(ent))
	{
		ent.SetHealth(nextturrethealth)
	} else if ( IsValid(ent) )
	{
		entity fx = StartParticleEffectInWorld_ReturnEntity(GetParticleSystemIndex( $"P_drone_exp_md" ), ent.GetOrigin(), ent.GetAngles())
		entity fx2 = StartParticleEffectInWorld_ReturnEntity(GetParticleSystemIndex( $"P_plasma_exp_SM" ), ent.GetOrigin(), ent.GetAngles())
		EmitSoundOnEntity( fx, "spectre_arm_explode" )
		ent.e.turrettrigger.Destroy()
		ent.SetTakeDamageType( DAMAGE_NO )
		ent.kv.solid = 0
		ent.SetOwner( attacker )
		ent.Destroy()
	}
}

void function rotateturret(entity ent,float speed,bool rightside)
{
	EndSignal(ent, "OnDestroy")
	vector result
	while( !ent.e.stoppls )
	{
		if(rightside) 
		{
			result =  ent.GetAngles() + <0,-speed,0>
		}else 
		{
			result = ent.GetAngles()  + <0,speed,0>
		}
		
		if( IsValid(ent) ) 
			ent.SetAngles( < 0, (result.y).tointeger(), 0 > )

		WaitFrame()
	}
}

void function RemoveHUDAlert( entity trigger, entity ent )
{
	StatusEffect_StopAllOfType( ent, eStatusEffect.turretlockon_detected )
	ent.e.islockedent = false
}

void function AddHUDAlert( entity trigger, entity ent )
{
	thread AddHUDAlert2( trigger, ent )
}

void function AddHUDAlert2( entity trigger, entity ent )
{
	if(!IsValid(trigger) || !ent.IsPlayer()) return
	
	EndSignal(trigger, "OnDestroy")

	while(ent.IsPlayer() && trigger.IsTouching(ent) )
	{
		if(ent.IsPlayer() && ent.e.islockedent && IsValid(ent)){
		StatusEffect_AddEndless( ent, eStatusEffect.turretlockon_detected, 1.0)}
		WaitFrame()	
	}
}

void function CreateTurretTrigger(entity turret, entity pc1)
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
{
	EndSignal(turret, "OnDestroy")
	
	bool isfirsttime = true
	EmitSoundOnEntity( turret, SOUND[1] ) //ready up
	turret.e.turrettrigger = CreateEntity( "trigger_cylinder" )
	turret.e.turrettrigger.SetRadius( TURRET_RADIUS )
	turret.e.turrettrigger.SetAboveHeight( TURRET_RADIUS/1.5 )
	turret.e.turrettrigger.SetBelowHeight( TURRET_RADIUS/1.5 )
	turret.e.turrettrigger.SetOrigin( turret.GetOrigin() )
	DispatchSpawn( turret.e.turrettrigger )
	
	turret.e.turrettrigger.EndSignal( "OnDestroy" )

	turret.e.turrettrigger.SetEnterCallback( AddHUDAlert )
	turret.e.turrettrigger.SetLeaveCallback( RemoveHUDAlert )
	turret.e.turrettrigger.SearchForNewTouchingEntity()
	vector targetOffset = < 0, 0, 20 >
	entity fx = PlayLoopFXOnEntity( LASER_LONG, turret, "", < 6, 5.6, 23.8 > )
	entity fx2 = PlayLoopFXOnEntity( LASER_LONG, turret, "", < 6, 5.6, 23.8 > )
	entity fx3 = PlayLoopFXOnEntity( LASER_SHORT, turret, "", < 6, 5.6, 23.8 > )
	fx.SetParent(turret)
	fx2.SetParent(turret)
	fx3.SetParent(turret)
	fx3.Hide()
	
	int ownerteam = turret.e.turretowner.GetTeam()

	while ( true )
		{
			array<entity> touchingEnts = turret.e.turrettrigger.GetTouchingEntities()
			array<entity> touchingEntsFinal
			
			foreach(entity ent in touchingEnts)
			{
				if(ent.GetTargetName() != "turretweapon")
				{
					touchingEntsFinal.append(ent)
				}
			}
			
			if(!DAMAGEOWNER)
			{
				//R5RDEV-1
				// foreach(entity ent in touchingEntsFinal)
				// {
					// if(ent == turret.e.turretowner || ent.GetTeam() == ownerteam)
					// {
						// touchingEntsFinal.removebyvalue(ent)
					// }
				// }
				
				int maxIter = touchingEntsFinal.len() - 1
				
				for( int i = maxIter; i >= 0; i-- )
				{
					entity ent = touchingEntsFinal[ i ]
					
					if( ent == turret.e.turretowner || ent.GetTeam() == ownerteam )
					{
						touchingEntsFinal.remove( i )
					}
				}
			}
			
			if(touchingEntsFinal.len() == 0)
			{
				turret.e.turretlockedent = null
				if(turret.e.turretweapon != null) {
					printt("destroying dummie weapon!")
					if(IsValid(turret.e.turretweapon))turret.e.turretweapon.Destroy()
					turret.e.turretweapon = null 
				}
			
				if(turret.e.onlyonetime == false){
					turret.e.stoppls = false
					 thread rotateturret(turret, 15, CoinFlip())
					 fx.SetAngles(turret.GetAngles()+ < 5.5, 0, 0 >)
					 fx.MakeVisible()
					 fx2.SetAngles(turret.GetAngles()+ < 5.5, 0, 0 >)
					 fx2.MakeVisible()
					 fx3.MakeInvisible()
					 fx3.SetAngles(turret.GetAngles())
					 EmitSoundOnEntity(turret, SOUND[3])
					 turret.e.onlyonetime = true 
				 }
			} else 
			{
				entity ent = touchingEntsFinal[0]	
				if( !IsValid(ent) )
				{ 
					WaitFrame()
					continue 
				}
				if(ent.IsNPC() && IsValid(ent) && ent.GetTargetName() != "turretweapon" || ent.IsPlayer() && IsValid(ent))
				{
					turret.e.turretlockedent = ent
					ent.e.islockedent = true
					if(turret.e.onlyonetime == true || isfirsttime )
					{
						if(turret.e.turretweapon == null)
						{
							printt("creating dummie weapon!")
							turret.e.turretweapon = SpawnTurretWeapon( pc1.GetOrigin(), pc1.GetAngles(), pc1)
						}
						turret.e.stoppls = true
						EmitSoundOnEntity(turret, "weapon_proximitymine_closewarning")
						printt("DEBUG - Trigger touched by:  " + ent)
						turret.e.onlyonetime = false
						isfirsttime = false
					}
					
					vector targetPos
					if ( ent.IsPlayer() || ent.IsNPC() ){
						targetPos = ( ent.GetOrigin() + targetOffset ) + ent.GetVelocity() * 0.200 * 0.9
						MakeLookAt( turret, targetPos, ent, fx )
					}
					if ( ent.IsPlayer() && ent.IsCrouched() || ent.IsPlayer() && ent.IsSliding() ){
						targetPos = ent.GetOrigin() + ent.GetVelocity() * 0.200 * 0.9
						MakeLookAt( turret, targetPos, ent, fx )
					}
					fx.MakeInvisible()
					fx2.MakeInvisible()
					fx3.MakeVisible()
				}
			}
			touchingEnts.clear()
			touchingEntsFinal.clear()
			WaitFrame()
		}
}

void function RadiusAlert( entity turret, bool red)
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
{
	entity circle = CreateEntity( "prop_script" )
	circle.SetValueForModelKey( $"mdl/weapons_r5/weapon_tesla_trap/mp_weapon_tesla_trap_ar_trigger_radius.rmdl" )
	circle.kv.fadedist = 200
	circle.kv.renderamt = 255
	if(red) circle.kv.rendercolor = "161, 45, 37"
	else circle.kv.rendercolor = "50, 168, 82"
	float idk = TURRET_RADIUS/500
	circle.kv.modelscale = 2*idk
	//circle.kv.modelscale = 2
	circle.kv.solid = 0
	circle.SetOrigin( turret.GetOrigin() + <0.0, 0.0, -25>)
	circle.SetAngles( <0, 0, 0> )
	circle.NotSolid()
	DispatchSpawn(circle)
	circle.SetParent(turret)
}

entity function SpawnTurretWeapon(vector origin, vector angles, entity turret)
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
{
	entity dummy = CreateEntity( "npc_dummie" )
	SetSpawnOption_AISettings( dummy, "npc_supressorturret" )
	SetTargetName(dummy, "turretweapon")
	dummy.SetOrigin( origin )
	dummy.SetAngles( angles )
	SetTeam(dummy, 90)
	DispatchSpawn( dummy )
	dummy.SetTitle("TURRET")
	
	dummy.DisableNPCFlag( NPC_ALLOW_PATROL | NPC_ALLOW_INVESTIGATE )
	dummy.EnableNPCFlag( NPC_AIM_DIRECT_AT_ENEMY )
	dummy.SetParent(turret)
	dummy.SetOrigin(turret.GetOrigin() + <0.0, 0.0, -25.0>  + (turret.GetForwardVector() * 20))
	dummy.SetAngles(turret.GetAngles())
	
	entity weapon = dummy.GiveWeapon(NPC_WEAPON, WEAPON_INVENTORY_SLOT_ANY)
	dummy.kv.renderamt = 255
	dummy.kv.rendermode = 3
	dummy.kv.rendercolor = "0 0 0 50"
	dummy.kv.solid = 0
	dummy.kv.fadedist = 1
	dummy.MakeInvisible()
	
	if( IsValid( weapon ) )
	{
		weapon.kv.renderamt = 255
		weapon.kv.rendermode = 3
		weapon.kv.rendercolor = "0 0 0 50"
		weapon.kv.solid = 0
		weapon.kv.fadedist = 1
		weapon.MakeInvisible()
	}
	
	thread weaponEnemyWatcher(dummy, turret)
	return dummy
}

void function weaponEnemyWatcher( entity dummy, entity turret )
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
{
	EndSignal(dummy, "OnDestroy")
	EndSignal(turret, "OnDestroy")

	entity enemy
	wait 1
	entity root = turret.GetParent()

	if( !IsValid( root ) )
		return

	while(true)
	{
		if( !IsValid( dummy ) )
			break

		if( IsValid(turret) && IsValid(dummy) ) 
			dummy.SetAngles(turret.GetAngles())
		
		if(IsValid(root.e.turretlockedent)) 
		{
			dummy.LockEnemy( root.e.turretlockedent )
			dummy.SetEnemy( root.e.turretlockedent )
			dummy.SetSecondaryEnemy( root.e.turretlockedent )
			dummy.SetEnemyLKP( root.e.turretlockedent, root.e.turretlockedent.GetOrigin() )
			printt("set enemy to lockedent")
		} else {
			printt("lockedent is not valid")
		}

		enemy = dummy.GetEnemy()
		
		if( IsValid(enemy) )
		{
			dummy.e.stopTurretWeapon = false
			float distance = Distance( dummy.GetOrigin(), enemy.GetOrigin() )
			printt("dummy enemy: " + enemy + " - distance: " + distance)
			
			if(!enemy.e.islockedent || distance > TURRET_RADIUS-10){
				dummy.e.stopTurretWeapon = true
				dummy.ClearEnemy()
				dummy.ClearEnemyMemory()
				dummy.ClearAllEnemyMemory()
				printt("enemy for dummie is NOT the locked ent or distance is greater than 500, weapon is disabled!")
			} else {
				dummy.e.stopTurretWeapon = false
				printt("enemy for dummie is the locked ent - weapon must shoot!")
			}
			
		} else 
		{
			printt("enemy is null!")
			//dummy.ClearEnemy()
			//dummy.ClearEnemyMemory()
			//dummy.ClearAllEnemyMemory()
			dummy.e.stopTurretWeapon = true
			//return
		}
		WaitFrame()
	}
}

void function PlayTurretSound( entity turret )
//By Julefox#0050
{   
	EndSignal(turret, "OnDestroy")
	while ( true )
	{
		EmitSoundOnEntity( turret, SOUND[0] )
		wait 18.0
	}   
}

void function PlayRandomTurretSound( entity turret )
//By Julefox#0050
{   
	EndSignal(turret, "OnDestroy")
	while ( true )
	{
		EmitSoundOnEntity( turret, RANDOM_SOUND.getrandom() ) 
		wait RandomFloatRange( 15.0, 25.0 )
	}   
}

void function MakeLookAt(entity entityToRotate, vector targetPos, entity targetType, entity fx ) 
{
//By Julefox#0050
	vector entityPos    = entityToRotate.GetOrigin()
	vector distance     = targetPos - entityPos

	float rotY = atan(distance.y / distance.x) * 180.0 / PI
	float rotX = -atan(distance.z / sqrt(distance.y*distance.y + distance.x*distance.x)) * 180.0 / PI

	if (distance.x < 0 ) rotY = rotY + 180.0
	
	entityToRotate.NonPhysicsRotateTo( < rotX, rotY, 0 > , 0.2, 0, 0 )  
}
#endif
