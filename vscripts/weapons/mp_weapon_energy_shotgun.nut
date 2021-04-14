global function MpWeaponEnergyShotgun_Init
global function OnWeaponPrimaryAttack_weapon_energy_shotgun
global function OnWeaponChargeLevelIncreased_weapon_energy_shotgun
global function OnWeaponChargeEnd_weapon_energy_shotgun

#if SERVER
global function OnWeaponNpcPrimaryAttack_weapon_energy_shotgun
#endif

// Set up the pattern and default scale to match desired spread_stand_hip
// we only use the xy here
array<vector> BLAST_PATTERN_ENERGY_SHOTGUN = [
	// 5-pointed star pattern
	// arranged so the first 6 still make a star pattern (for NPCs)
	< 0.0, 0.0, 	0 >, // center
	< 0.0, 13.75, 	0 >, // head
	< -9.4, 5.4, 	0 >, // left arm top
	< 9.4, 5.4, 	0 >, // right arm top
	< -8.75, -9.4, 	0 >, // left leg bottom
	< 8.75, -9.4, 	0 >, // right leg bottom
	< 0.0, 7.5, 	0 >, // neck
	< -4.35, 3.75, 	0 >, // left arm middle
	< 4.35, 3.75, 	0 >, // right arm middle
	< -4.35, -4.3, 	0 >, // left leg middle
	< 4.35, -4.35, 	0 >, // right leg middle
]

struct
{
	EnergyChargeWeaponData chargeWeaponData
} file


void function MpWeaponEnergyShotgun_Init()
{
	file.chargeWeaponData.blastPattern = BLAST_PATTERN_ENERGY_SHOTGUN
}

var function OnWeaponPrimaryAttack_weapon_energy_shotgun( entity weapon, WeaponPrimaryAttackParams attackParams)
{
	bool playerFired = true
	return Fire_EnergyShotgun( weapon, attackParams, playerFired )
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_weapon_energy_shotgun( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	bool playerFired = false
	return Fire_EnergyShotgun( weapon, attackParams, playerFired )
}
#endif

int function Fire_EnergyShotgun( entity weapon, WeaponPrimaryAttackParams attackParams, bool playerFired )
{
	float patternScale = 1.0
	if ( weapon.HasMod( "npc_shotgunner" ) )
		patternScale = expect float( weapon.GetWeaponInfoFileKeyField( "projectile_blast_pattern_npc_scale" ) )

	return Fire_EnergyChargeWeapon( weapon, attackParams, file.chargeWeaponData, playerFired, patternScale )
}

bool function OnWeaponChargeLevelIncreased_weapon_energy_shotgun( entity weapon )
{
	return EnergyChargeWeapon_OnWeaponChargeLevelIncreased( weapon, file.chargeWeaponData )
}

void function OnWeaponChargeEnd_weapon_energy_shotgun( entity weapon )
{
	EnergyChargeWeapon_OnWeaponChargeEnd( weapon, file.chargeWeaponData )
}
