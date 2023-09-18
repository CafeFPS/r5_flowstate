untyped

global function OnWeaponPrimaryAttack_RayGun
global function OnWeaponActivate_RayGun
global function OnWeaponDeactivate_RayGun
global function MpWeaponRayGun_Init

const asset BULLETMODELRAYGUN = $"mdl/fx/ar_marker_ringwobble.rmdl"
// const asset BULLETMODELRAYGUN2 = $"mdl/fx/ar_hazard_ring_1.rmdl"
const asset BULLETMODELRAYGUN3 = $"mdl/fx/energy_ring_core_fx.rmdl"

void function MpWeaponRayGun_Init()
{
	PrecacheModel(BULLETMODELRAYGUN)
	// PrecacheModel(BULLETMODELRAYGUN2)
	PrecacheModel(BULLETMODELRAYGUN3)
}

var function OnWeaponPrimaryAttack_RayGun( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	#if CLIENT
		if ( !weapon.ShouldPredictProjectiles() )
			return 1
	#endif // #if CLIENT
	
	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )
	
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
	
	#if SERVER
	entity trailFXHandle = StartParticleEffectOnEntity_ReturnEntity(bullet, GetParticleSystemIndex( $"P_skydive_trail_CP" ), FX_PATTACH_ABSORIGIN_FOLLOW, -1)
	EffectSetControlPointVector( trailFXHandle, 1, <89, 255, 136>)
	EntFireByHandle( trailFXHandle, "Kill", "", 1, null, null )
	EntFireByHandle( trailFXHandle, "Stop", "", 1, null, null )	
	
	vector angles = VectorToAngles( player.GetOrigin() - bullet.GetOrigin())
	
	entity visual = CreatePropDynamic( BULLETMODELRAYGUN, bullet.GetOrigin(), Vector(90,angles.y,angles.z) )
	visual.SetModelScale(0.3)
	visual.kv.rendercolor = "89, 255, 136"
	visual.kv.renderamt = 100
	visual.SetParent(bullet)

	entity visual3 = CreatePropDynamic( BULLETMODELRAYGUN3, bullet.GetOrigin(), Vector(90,angles.y,angles.z) )
	visual3.SetModelScale(0.3)
	visual3.kv.rendercolor = "89, 255, 136"
	visual3.SetParent(bullet)
	#endif
}

void function OnWeaponActivate_RayGun( entity weapon )
{
	//file.owner = weapon.GetWeaponOwner()
	
	// weapon.PlayWeaponEffect( $"P_wat_hand_elec_CP" , $"P_wat_hand_elec_CP", "shell" )
}

void function OnWeaponDeactivate_RayGun( entity weapon )
{
	// weapon.StopWeaponEffect( $"P_wat_hand_elec_CP", $"P_wat_hand_elec_CP" )
}
