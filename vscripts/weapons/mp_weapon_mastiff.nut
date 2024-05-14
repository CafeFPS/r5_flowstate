global function OnWeaponPrimaryAttack_weapon_mastiff

#if SERVER
global function OnWeaponNpcPrimaryAttack_weapon_mastiff
#endif // #if SERVER

const MASTIFF_BLAST_PATTERN_LEN = 8
const BLAST_PATTERN_LEN_SIXTYNINE = 69

struct {
	float[2][MASTIFF_BLAST_PATTERN_LEN] boltOffsets = [
		[0.0, 1.2], 
		[0.0, 0.15], 
		[0.0, 0.3], 
		[0.0, 0.6], 
		[0.0, -0.3], 
		[0.0, -0.6], 
		[0.0, -1.2], 
		[0.0, -0.15], 
	]
	
		float[2][BLAST_PATTERN_LEN_SIXTYNINE] boltOffsets_69 = [
		//6
		//remember x and y are reversed (y,x)
		[2.0, -2.8],
		[2.0, -2.4],
		[2.0, -2.0],
		[2.0, -2.2],
		[2.0, -1.6],
		[2.0, -1.2],
		[2.0, -0.8],

		[2.0, -3.0], //
		[1.6, -3.0], //
		[1.2, -3.0], //
		[0.8, -3.0], //
		[0.4, -3.0], //
		[0.0, -3.0], //
		[0.2, -3.0], //
		[-0.2, -3.0], //
		[-0.4, -3.0], //
		[-0.8, -3.0], //
		[-1.2, -3.0], //
		[-1.6, -3.0], //
		[-2.0, -3.0], //

		[0.0, -2.8],
		[0.0, -2.4],
		[0.0, -2.0],
		[0.0, -1.6],
		[0.0, -1.2],
		[0.0, -0.8],

		[-2.0, -2.8],
		[-2.0, -2.4],
		[-2.0, -2.0],
		[-2.0, -2.2],
		[-2.0, -1.6],
		[-2.0, -1.2],
		[-2.0, -0.8],


		[-0.4, -0.8], //
		[-0.8, -0.8], //
		[-1.2, -0.8], //
		[-1.6, -0.8], //

		//9

		[2.0, 1.0], //
		[1.6, 1.0], //
		[1.2, 1.0], //
		[0.8, 1.0], //
		[0.4, 1.0], //
		[0.0, 1.0], //

		[2.0, 1.4], //
		[2.0, 1.8], //
		[2.0, 2.2], //
		[2.0, 2.6], //

		[2.0, 3.0], //
		[1.6, 3.0], //
		[1.2, 3.0], //
		[0.8, 3.0], //
		[0.4, 3.0], //
		[0.0, 3.0], //
		[0.2, 3.0], //
		[-0.2, 3.0], //
		[-0.4, 3.0], //
		[-0.8, 3.0], //
		[-1.2, 3.0], //
		[-1.6, 3.0], //
		[-2.0, 3.0], //
	
		[0.0, 1.4], //
		[0.0, 1.8], //
		[0.0, 2.2], //
		[0.0, 2.6], //

		[-2.0, 1.0],
		[-2.0, 1.4], //
		[-2.0, 1.8], //
		[-2.0, 2.2], //
		[-2.0, 2.6], //
	]
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
	
	bool eva69 = false
	if( weapon.GetWeaponClassName() == "mp_weapon_eva69" )
	{
		eva69 = true
		boltsPerShot = 69
	}

	Assert( boltsPerShot <= MASTIFF_BLAST_PATTERN_LEN, "Not enough points in blast pattern to fire " + boltsPerShot + " bolts; check MASTIFF_BLAST_PATTERN_LEN in script" )

	if ( shouldCreateProjectile )
	{
		weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )

		for ( int index = 0; index < boltsPerShot; index++ )
		{
			vector upVect
			if( !eva69 )
				upVect = baseUpVec * file.boltOffsets[index][0] * spreadFrac
			else
				upVect = baseUpVec * file.boltOffsets_69[index][0] * spreadFrac
			
			vector rightVec 

			if( !eva69 )
				rightVec = baseRightVec * file.boltOffsets[index][1] * spreadFrac
			else
				rightVec = baseRightVec * file.boltOffsets_69[index][1] * spreadFrac
				
			vector attackDir = attackParams.dir + upVect + rightVec

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

