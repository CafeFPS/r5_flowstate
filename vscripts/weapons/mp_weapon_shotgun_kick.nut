#if(true)//

global function OnWeaponOwnerChanged_weapon_shotgun_kick
global function OnWeaponPrimaryAttack_weapon_shotgun_kick
global function WeaponShotgunKick_FireWeaponPlayerAndNPC

#if SERVER

#endif //

#if CLIENT
global function ServerCallback_ShotgunKickNoAmmoMessage
#endif //

const MASTIFF_MAX_BOLTS = 8 //

const float WEAPON_SHOTGUN_KICK_AMMO_MESSAGE_DURATION = 3.0

struct {
	float[2][MASTIFF_MAX_BOLTS] boltOffsets = [
		[0.0, 0.3], //
		[0.0, 0.6], //
		[0.0, 1.2], //
		[0.0, 2.4], //
		[0.0, -0.6], //
		[0.0, -1.2], //
		[0.0, -2.4], //
		[0.0, -0.3], //
	]
	/*










*/

	/*








*/
} file

void function OnWeaponOwnerChanged_weapon_shotgun_kick( entity weapon, WeaponOwnerChangedParams changeParams )
{
	entity weaponOwner = weapon.GetWeaponOwner()

	if ( !IsValid( weaponOwner ) )
		return

	if ( !weaponOwner.IsPlayer() )
		return

	//
	SetPlayerRequireLootType( weaponOwner, "shotgun" )
}

var function OnWeaponPrimaryAttack_weapon_shotgun_kick( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return WeaponShotgunKick_FireWeaponPlayerAndNPC( attackParams, true, weapon )
}

#if SERVER




#endif //

int function WeaponShotgunKick_FireWeaponPlayerAndNPC( WeaponPrimaryAttackParams attackParams, bool playerFired, entity weapon )
{
	entity owner = weapon.GetWeaponOwner()
	bool shouldCreateProjectile = false
	if ( IsServer() || weapon.ShouldPredictProjectiles() )
		shouldCreateProjectile = true
	#if CLIENT
		if ( !playerFired )
			shouldCreateProjectile = false
	#endif

	int ammoPool = owner.AmmoPool_GetCount( eAmmoPoolType.shotgun )

	//
	if ( ammoPool == 0 )
	{
		//
		#if SERVER

#endif //

		return 0
	}


	#if SERVER

#endif //

	vector attackAngles = VectorToAngles( attackParams.dir )
	vector baseUpVec = AnglesToUp( attackAngles )
	vector baseRightVec = AnglesToRight( attackAngles )

	float zoomFrac
	if ( playerFired )
		zoomFrac = owner.GetZoomFrac()
	else
		zoomFrac = 0.5

	float spreadFrac = Graph( zoomFrac, 0, 1, 0.05, 0.025 ) * 1.0

	array<entity> projectiles

	if ( shouldCreateProjectile )
	{
		weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )

		for ( int index = 0; index < MASTIFF_MAX_BOLTS; index++ )
		{
			vector upVec = baseUpVec * file.boltOffsets[index][0] * spreadFrac
			vector rightVec = baseRightVec * file.boltOffsets[index][1] * spreadFrac

			vector attackDir = attackParams.dir + upVec + rightVec
			int damageFlags = weapon.GetWeaponDamageFlags()
			WeaponFireBoltParams fireBoltParams
			fireBoltParams.pos = attackParams.pos
			fireBoltParams.dir = attackDir
			fireBoltParams.speed = 4500
			fireBoltParams.scriptTouchDamageType = damageFlags
			fireBoltParams.scriptExplosionDamageType = damageFlags
			fireBoltParams.clientPredicted = playerFired
			fireBoltParams.additionalRandomSeed = index
			entity bolt = weapon.FireWeaponBoltAndReturnEntity( fireBoltParams )
			if ( bolt != null )
			{
				bolt.kv.gravity = 0.09

				if ( !(playerFired && zoomFrac > 0.8) )
					bolt.SetProjectileLifetime( RandomFloatRange( 0.65, 0.85 ) )
				else
					bolt.SetProjectileLifetime( RandomFloatRange( 0.65, 0.85 ) * 1.25 )

				projectiles.append( bolt )

				#if SERVER

#endif
			}
		}
	}

	return 1
}

#if CLIENT
void function ServerCallback_ShotgunKickNoAmmoMessage()
{
	var rui = CreateFullscreenRui( $"ui/weapon_shotgun_kick_ammo_hint.rpak" )
	RuiSetString( rui, "displayText", "#WPN_SHOTGUN_KICK_AMMO_HINT" )
	RuiSetString( rui, "displayTextSub", "#WPN_SHOTGUN_KICK_AMMO_HINT_SUB" )
	RuiSetGameTime( rui, "startTime", Time() )
	RuiSetGameTime( rui, "endTime", Time() + WEAPON_SHOTGUN_KICK_AMMO_MESSAGE_DURATION )
}
#endif //


#endif //
