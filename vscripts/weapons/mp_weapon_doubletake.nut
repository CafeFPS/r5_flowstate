global function MpWeaponDoubletake_Init
global function OnWeaponPrimaryAttack_weapon_doubletake
global function OnWeaponChargeLevelIncreased_weapon_doubletake
global function OnWeaponChargeEnd_weapon_doubletake
global function OnProjectileCollision_weapon_doubletake

#if SERVER
global function OnWeaponNpcPrimaryAttack_weapon_doubletake
#endif // #if SERVER

//const BARREL_GLOW_LEVEL_4_1P = $"P_mflash_nrg_shot_charge_FP"
//const BARREL_GLOW_LEVEL_4_3P = $"P_mflash_nrg_shot_charge"

// Set up the pattern and default scale to match desired spread_stand_hip
// we only use the xy here
const array<vector> BLAST_PATTERN_TRIPLE_TAKE = [
	// horizontal line pattern
	< 0.0, 0.0, 	0 >,
	< -1.0, 0.0, 	0 >,
	< 1.0, 0.0, 	0 >,
]

struct
{
	EnergyChargeWeaponData chargeWeaponData
} file


void function MpWeaponDoubletake_Init()
{
	//PrecacheParticleSystem( BARREL_GLOW_LEVEL_4_1P )
	//PrecacheParticleSystem( BARREL_GLOW_LEVEL_4_3P )

	file.chargeWeaponData.blastPattern = BLAST_PATTERN_TRIPLE_TAKE
	//file.chargeWeaponData.fx_barrel_glow_attach = "muzzle_flash"
	//file.chargeWeaponData.fx_barrel_glow_final_1p = BARREL_GLOW_LEVEL_4_1P
	//file.chargeWeaponData.fx_barrel_glow_final_3p = BARREL_GLOW_LEVEL_4_3P
}

var function OnWeaponPrimaryAttack_weapon_doubletake( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	bool playerFired = true
	return Fire_DoubleTake( weapon, attackParams, playerFired)
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_weapon_doubletake( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	bool playerFired = false
	return Fire_DoubleTake( weapon, attackParams, playerFired )
}
#endif // #if SERVER

int function Fire_DoubleTake( entity weapon, WeaponPrimaryAttackParams attackParams, bool playerFired )
{
	float patternScale = 1.0

	if ( playerFired )
	{
		float spreadAngle = weapon.GetAttackSpreadAngle()
		//printt( "spreadAngle", spreadAngle )
		patternScale += spreadAngle
	}
	else
	{
		patternScale = expect float( weapon.GetWeaponInfoFileKeyField( "projectile_blast_pattern_npc_scale" ) )
	}

	bool ignoreSpread = false
	return Fire_EnergyChargeWeapon( weapon, attackParams, file.chargeWeaponData, playerFired, patternScale, ignoreSpread )
}

bool function OnWeaponChargeLevelIncreased_weapon_doubletake( entity weapon )
{
	return EnergyChargeWeapon_OnWeaponChargeLevelIncreased( weapon, file.chargeWeaponData )
}

void function OnWeaponChargeEnd_weapon_doubletake( entity weapon )
{
	EnergyChargeWeapon_OnWeaponChargeEnd( weapon, file.chargeWeaponData )
}

void function OnProjectileCollision_weapon_doubletake( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical )
{
	#if SERVER
		int bounceCount = projectile.GetProjectileWeaponSettingInt( eWeaponVar.projectile_ricochet_max_count )
		if ( projectile.proj.projectileBounceCount >= bounceCount )
			return

		projectile.proj.projectileBounceCount++
	#endif
}