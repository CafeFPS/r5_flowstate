//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)

global function OnWeaponActivate_heatwave
global function OnWeaponDeactivate_heatwave
global function OnWeaponPrimaryAttack_heatwave
global function OnProjectileCollision_heatwave
global function MpWeaponHeatwave_Init

const HEATWAVE_PATTERN = 6

void function MpWeaponHeatwave_Init()
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)
{
#if CLIENT
// RegisterConCommandTriggeredCallback( "+zoom", ActivateAltfire )
#endif	
}

struct {
	float[2][HEATWAVE_PATTERN] boltOffsets = [
		[0.0, 0.3], //
		[0.0, 0.6], //
		[0.0, 1.2], //
		[0.0, -0.3], //
		[0.0, -0.6], //
		[0.0, -1.2], //
	]

	float[2][HEATWAVE_PATTERN] boltOffsetsVertical = [
		[0.3, 0], //
		[0.6, 0], //
		[1.2, 0], //
		[-0.3, 0], //
		[-0.6, 0], //
		[-1.2, 0], //
	]
} file

void function OnWeaponActivate_heatwave( entity weapon )
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)
{
	//do something here? fxs?
}

void function OnWeaponDeactivate_heatwave( entity weapon )
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)
{
	//do something here? fxs?
}

var function OnWeaponPrimaryAttack_heatwave( entity weapon, WeaponPrimaryAttackParams attackParams )
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)
{	
	//EmitSoundOnEntity( weapon, "explo_spectre" )
	return FireHeatwave( attackParams, true, weapon )
}

void function OnProjectileCollision_heatwave( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical )
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)
{
	#if SERVER
		int bounceCount = projectile.GetProjectileWeaponSettingInt( eWeaponVar.projectile_ricochet_max_count )
		if ( projectile.proj.projectileBounceCount >= bounceCount )
			return

		projectile.proj.projectileBounceCount++
	#endif
}

int function FireHeatwave( WeaponPrimaryAttackParams attackParams, bool playerFired, entity weapon )
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

	if ( shouldCreateProjectile )
	{
		weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )

		for ( int index = 0; index < boltsPerShot; index++ )
		{
			vector upVec
			vector rightVec
			
			if(IsModActive( weapon, "altfire" ))
			//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)
			{
				upVec = baseUpVec * file.boltOffsetsVertical[index][0] * spreadFrac
				rightVec = baseRightVec * file.boltOffsetsVertical[index][1] * spreadFrac	
			}				
			else
			{
				upVec = baseUpVec * file.boltOffsets[index][0] * spreadFrac
				rightVec = baseRightVec * file.boltOffsets[index][1] * spreadFrac	
			}
				
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

#if CLIENT
void function ActivateAltfire(entity player)
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)
{
	player.ClientCommand("+scriptCommand3")
	player.ClientCommand("-scriptCommand3")
}
#endif