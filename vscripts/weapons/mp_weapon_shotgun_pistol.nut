global function OnWeaponPrimaryAttack_weapon_shotgun_pistol

#if SERVER
global function OnWeaponNpcPrimaryAttack_weapon_shotgun_pistol
#endif // #if SERVER

// Set up the pattern and default scale to match desired spread_stand_hip
// we only use the xy here
array<vector> BLAST_PATTERN_SHOTGUN_PISTOL = [
	// Triangle pattern
	< 0.0, 8.0, 	0 >, // top
	< -6.0, -6.0, 	0 >, // left
	< 6.0, -6.0, 	0 >, // right
]

const float BLAST_PATTERN_ADS_SCALE_REDUCTION = 0.5  // how small the default pattern can get when player ADSes


var function OnWeaponPrimaryAttack_weapon_shotgun_pistol( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	bool playerFired = true
	return Fire_ShotgunPistol( weapon, attackParams, playerFired )
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_weapon_shotgun_pistol( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	bool playerFired = false
	return Fire_ShotgunPistol( weapon, attackParams, playerFired )
}
#endif // #if SERVER

int function Fire_ShotgunPistol( entity weapon, WeaponPrimaryAttackParams attackParams, bool playerFired = true )
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
		if ( playerFired )
		{
			// scale spread pattern based on ADS
			entity owner = weapon.GetWeaponOwner()
			patternScale *= GraphCapped( owner.GetZoomFrac(), 0.0, 1.0, 1.0, BLAST_PATTERN_ADS_SCALE_REDUCTION )
		}
		else
		{
			patternScale = expect float( weapon.GetWeaponInfoFileKeyField( "projectile_blast_pattern_npc_scale" ) )
		}

		FireProjectileBlastPattern( weapon, attackParams, playerFired, BLAST_PATTERN_SHOTGUN_PISTOL, patternScale )
	}

	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
}
