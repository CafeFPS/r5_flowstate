
global function MpWeaponGrenadeDefensiveBombardment_Init
global function OnProjectileCollision_WeaponDefensiveBombardment
global function OnProjectileCollision_WeaponDefensiveBombardmentExplosion
global function OnWeaponTossReleaseAnimEvent_WeaponDefensiveBombardment
global function OnWeaponOwnerChanged_WeaponDefensiveBombardment

const string DEFENSIVE_BOMBARDMENT_MISSILE_WEAPON = "mp_weapon_defensive_bombardment_weapon"

//Gibraltar Ult / Mortar FX
const asset FX_BOMBARDMENT_MARKER = $"P_ar_artillery_marker"

const float DEFENSIVE_BOMBARDMENT_RADIUS 		 	= 1024 //The radius of the bombardment area.
const int	DEFENSIVE_BOMBARDMENT_DENSITY			= 6	//The density of the distributed shell randomness.
const float DEFENSIVE_BOMBARDMENT_DURATION			= 6.0 //The duration the bombardment will last.
const float DEFENSIVE_BOMBARDMENT_DELAY 			= 2.0 //The bombardment will wait 2.0 seconds before firing the first shell.

const float DEFENSIVE_BOMBARDMENT_SHELLSHOCK_DURATION = 4.0

const asset FX_DEFENSIVE_BOMBARDMENT_SCAN = $"P_artillery_marker_scan"

void function MpWeaponGrenadeDefensiveBombardment_Init()
{
	PrecacheWeapon( DEFENSIVE_BOMBARDMENT_MISSILE_WEAPON )

	PrecacheParticleSystem( FX_DEFENSIVE_BOMBARDMENT_SCAN )
	PrecacheParticleSystem( FX_BOMBARDMENT_MARKER )

	#if SERVER
		AddDamageCallbackSourceID( eDamageSourceId.damagedef_defensive_bombardment, DefensiveBombardment_DamagedTarget )
	#endif //SERVER
}

void function OnWeaponOwnerChanged_WeaponDefensiveBombardment( entity weapon, WeaponOwnerChangedParams changeParams )
{
	#if SERVER
	if ( IsValid( changeParams.oldOwner ) )
	{
		if ( changeParams.oldOwner.IsPlayer() )
		{
			changeParams.oldOwner.TakeOffhandWeapon( OFFHAND_RIGHT )
		}
	}

	if ( IsValid( changeParams.newOwner ) )
	{
		if ( changeParams.newOwner.IsPlayer() )
		{
			changeParams.newOwner.GiveOffhandWeapon( DEFENSIVE_BOMBARDMENT_MISSILE_WEAPON, OFFHAND_RIGHT, [] )
		}
	}
	#endif
}

var function OnWeaponTossReleaseAnimEvent_WeaponDefensiveBombardment( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity owner = weapon.GetWeaponOwner()

	if ( !IsValid( owner ) )
		return

	#if SERVER
	entity bombardmentWeapon = owner.GetOffhandWeapon( OFFHAND_RIGHT )
	if ( !IsValid( bombardmentWeapon ) )
		owner.GiveOffhandWeapon( DEFENSIVE_BOMBARDMENT_MISSILE_WEAPON, OFFHAND_RIGHT, [] )

		PlayBattleChatterLineToSpeakerAndTeam( owner, "bc_super" )
	#endif

	Grenade_OnWeaponTossReleaseAnimEvent( weapon, attackParams )
	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
}

void function OnProjectileCollision_WeaponDefensiveBombardment( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical )
{
	entity player = projectile.GetOwner()
	if ( hitEnt == player )
		return

	if ( projectile.GrenadeHasIgnited() )
		return

	table collisionParams =
	{
		pos = pos,
		normal = normal,
		hitEnt = hitEnt,
		hitbox = hitbox
	}

	bool result = PlantStickyEntityOnWorldThatBouncesOffWalls( projectile, collisionParams, 0.7 )

	#if SERVER
		if ( !result )
		{
			return
		}
		else
		{
			thread DefensiveBombardmentSmoke( projectile, FX_DEFENSIVE_BOMBARDMENT_SCAN )
		}
	#endif
	projectile.GrenadeIgnite()
	projectile.SetDoesExplode( false )
}

void function OnProjectileCollision_WeaponDefensiveBombardmentExplosion( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical )
{
	#if SERVER
	entity player = projectile.GetOwner()
	if ( !IsValid( player ) )
	{
		projectile.Destroy()
		return
	}
	
	Explosion_DamageDefSimple( eDamageSourceId.damagedef_defensive_bombardment, pos, player, projectile, pos )
	projectile.Destroy()
	#endif
}

#if SERVER
void function DefensiveBombardment_DamagedTarget( entity victim, var damageInfo )
{
	// Seems like we need this since the invulnerability from phase shift has not kicked in at this point yet
	if ( victim.IsPhaseShifted() )
		return

	//if the attacker is a valid friendly set damage do zero.
	//Note: We need the FF so we can trigger the shellshock effect.
	entity attacker = DamageInfo_GetAttacker( damageInfo )
	if ( IsValid( attacker ) )
	{
		if ( IsFriendlyTeam( attacker.GetTeam(), victim.GetTeam() ) && (attacker != victim) )
			DamageInfo_ScaleDamage( damageInfo, 0 )
	}

	if ( victim.IsPlayer() )
		ShellShock_ApplyForDuration( victim, DEFENSIVE_BOMBARDMENT_SHELLSHOCK_DURATION )
}

void function DefensiveBombardmentSmoke( entity projectile, asset fx )
{
	entity owner = projectile.GetThrower()

	if ( !IsValid( owner ) )
		return

	entity bombardmentWeapon = VerifyBombardmentWeapon( owner, DEFENSIVE_BOMBARDMENT_MISSILE_WEAPON )
	if ( !IsValid( bombardmentWeapon ) )
		return
	
	string sound_incoming_first = GetWeaponInfoFileKeyField_GlobalString(bombardmentWeapon.GetWeaponClassName(), "sound_incoming_first")

	vector origin = projectile.GetOrigin()

	int smokeFxId = GetParticleSystemIndex( fx )
	entity smokeFX = StartParticleEffectOnEntity_ReturnEntity( projectile, smokeFxId, FX_PATTACH_ABSORIGIN_FOLLOW, 0 )

	ThreatDetection_CreateThreatZoneForBombardment( null, projectile.GetOrigin(), -1, DEFENSIVE_BOMBARDMENT_RADIUS, 1.0 )
	
	EmitSoundOnEntity( projectile, sound_incoming_first)

	thread Bombardment_MortarBarrageFocused( bombardmentWeapon, FX_BOMBARDMENT_MARKER, projectile.GetOrigin(),
		DEFENSIVE_BOMBARDMENT_RADIUS,
		DEFENSIVE_BOMBARDMENT_DENSITY,
		DEFENSIVE_BOMBARDMENT_DURATION,
		DEFENSIVE_BOMBARDMENT_DELAY )

	wait DEFENSIVE_BOMBARDMENT_DURATION + DEFENSIVE_BOMBARDMENT_DELAY

	if ( IsValid( smokeFX ) )
		EffectStop( smokeFX )
}
#endif
