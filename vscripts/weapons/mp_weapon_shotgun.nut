
global function OnWeaponPrimaryAttack_weapon_shotgun

#if SERVER
global function OnWeaponNpcPrimaryAttack_weapon_shotgun
#endif // #if SERVER


// Set up the pattern and default scale to match desired spread_stand_hip
// we only use the xy here
const array<vector> BLAST_PATTERN_EVA_SHOTGUN = [
	// "Squished 3x3" pattern
	< -7.0, 7.0, 	0 >, // top row
	< 0.0, 11.0, 	0 >,
	< 7.0, 7.0, 	0 >,
	< -6.0, 0.0, 	0 >, // middle row
	< 0.0, 0.0, 	0 >,
	< 6.0, 0.0, 	0 >,
	< -7.0, -7.0, 	0 >, // bottom row
	< 0.0, -11.0, 	0 >,
	< 7.0, -7.0, 	0 >,
]


var function OnWeaponPrimaryAttack_weapon_shotgun( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	bool playerFired = true
	Fire_EVA_Shotgun( weapon, attackParams, playerFired )
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_weapon_shotgun( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	bool playerFired = false
	Fire_EVA_Shotgun( weapon, attackParams, playerFired )
}
#endif // #if SERVER

int function Fire_EVA_Shotgun( entity weapon, WeaponPrimaryAttackParams attackParams, bool playerFired = true )
{
	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )

	bool shouldCreateProjectile = false
	if ( IsServer() || weapon.ShouldPredictProjectiles() )
		shouldCreateProjectile = true

	#if CLIENT
		if ( !playerFired )
			shouldCreateProjectile = false
	#endif

	if ( shouldCreateProjectile )
	{
		float patternScale = 1.0
		if ( !playerFired )
			patternScale = expect float( weapon.GetWeaponInfoFileKeyField( "projectile_blast_pattern_npc_scale" ) )

		FireProjectileBlastPattern( weapon, attackParams, playerFired, BLAST_PATTERN_EVA_SHOTGUN, patternScale )
	}

	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
}
