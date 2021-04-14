global function OnWeaponPrimaryAttack_weapon_mastiff

#if SERVER
global function OnWeaponNpcPrimaryAttack_weapon_mastiff
#endif // #if SERVER

const MASTIFF_BLAST_PATTERN_LEN = 8

struct {
	float[2][MASTIFF_BLAST_PATTERN_LEN] boltOffsets = [
		[0.0, 0.15], //
		[0.0, 0.3], //
		[0.0, 0.6], //
		[0.0, 1.2], //
		[0.0, -0.3], //
		[0.0, -0.6], //
		[0.0, -1.2], //
		[0.0, -0.15], //
	]

	/*array boltOffsets = [
		[0.0, 0.0], // center
		[1.0, 0.0], // top
		[0.0, 1.0], // right
		[0.0, -1.0], // left
		[0.5, 0.5],
		[0.5, -0.5],
		[-0.5, 0.5],
		[-0.5, -0.5]
	]*/
} file

var function OnWeaponPrimaryAttack_weapon_mastiff( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return FireMastiff( attackParams, true, weapon )
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_weapon_mastiff( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return FireMastiff( attackParams, false, weapon )
}
#endif // #if SERVER

int function FireMastiff( WeaponPrimaryAttackParams attackParams, bool playerFired, entity weapon )
{
	entity owner = weapon.GetWeaponOwner()
	bool shouldCreateProjectile = false
	if ( IsServer() || weapon.ShouldPredictProjectiles() )
		shouldCreateProjectile = true
	#if CLIENT
		if ( !playerFired )
			shouldCreateProjectile = false
	#endif

	vector attackAngles = VectorToAngles( attackParams.dir )
	vector baseUpVec = AnglesToUp( attackAngles )
	vector baseRightVec = AnglesToRight( attackAngles )

	float zoomFrac
	if ( playerFired )
		zoomFrac = owner.GetZoomFrac()
	else
		zoomFrac = 0.5

	float spreadFrac = Graph( zoomFrac, 0, 1, 0.05, 0.025 ) * 1.0

	int boltsPerShot = weapon.GetProjectilesPerShot()
	Assert( boltsPerShot <= MASTIFF_BLAST_PATTERN_LEN, "Not enough points in blast pattern to fire " + boltsPerShot + " bolts; check MASTIFF_BLAST_PATTERN_LEN in script" )

	if ( shouldCreateProjectile )
	{
		weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )

		for ( int index = 0; index < boltsPerShot; index++ )
		{
			vector upVec = baseUpVec * file.boltOffsets[index][0] * spreadFrac
			vector rightVec = baseRightVec * file.boltOffsets[index][1] * spreadFrac
			vector attackDir = attackParams.dir + upVec + rightVec

			bool ignoreSpread = true  // don't use the normal code spread for this weapon (ie, slightly adjusting outgoing round angle within spread cone)
			bool deferred = index > (boltsPerShot / 2)
			entity bolt = FireBallisticRoundWithDrop( weapon, attackParams.pos, attackDir, playerFired, ignoreSpread, index, deferred )

			if ( IsValid( bolt ) )
			{
				if ( owner.IsPlayer() )
				{
#if CLIENT
					EmitSoundOnEntity( bolt, "weapon_mastiff_projectile_crackle" )
#else //
					EmitSoundOnEntityExceptToPlayer( bolt, owner, "weapon_mastiff_projectile_crackle" )
#endif //
				}
				else
				{
					EmitSoundOnEntity( bolt, "weapon_mastiff_projectile_crackle" )
				}
			}
		}
	}

	return 1
}

