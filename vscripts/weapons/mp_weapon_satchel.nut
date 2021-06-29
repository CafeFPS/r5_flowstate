untyped

global function MpWeaponSatchel_Init

global function OnWeaponActivate_weapon_satchel
global function OnWeaponDeactivate_weapon_satchel
global function OnWeaponPrimaryAttackAnimEvent_weapon_satchel
global function OnWeaponTossReleaseAnimEvent_weapon_satchel
global function OnProjectileCollision_weapon_satchel
global function AddCallback_OnSatchelPlanted

const MAX_SATCHELS_IN_WORLD = 3  // if more than this are thrown, the oldest one gets cleaned up
const SATCHEL_THROW_POWER = 620

function MpWeaponSatchel_Init()
{
	SatchelPrecache()

	RegisterSignal( "DetonateSatchels" )
}

function SatchelPrecache()
{
	PrecacheParticleSystem( $"wpn_laser_blink" )
	PrecacheParticleSystem( $"wpn_satchel_clacker_glow_LG_1" )
	PrecacheParticleSystem( $"wpn_satchel_clacker_glow_SM_1" )
}

void function OnWeaponActivate_weapon_satchel( entity weapon )
{
	#if CLIENT
		if ( weapon.GetWeaponOwner() == GetLocalViewPlayer() )
		{
			weapon.PlayWeaponEffect( $"wpn_satchel_clacker_glow_LG_1", $"", "light_large" )
			weapon.PlayWeaponEffect( $"wpn_satchel_clacker_glow_SM_1", $"", "light_small" )
		}
	#endif
}

void function OnWeaponDeactivate_weapon_satchel( entity weapon )
{
	#if CLIENT
		if ( weapon.GetWeaponOwner() == GetLocalViewPlayer() )
		{
			weapon.StopWeaponEffect( $"wpn_satchel_clacker_glow_LG_1", $"" )
			weapon.StopWeaponEffect( $"wpn_satchel_clacker_glow_SM_1", $"" )
		}
	#endif
}

var function OnWeaponPrimaryAttackAnimEvent_weapon_satchel( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity player = weapon.GetWeaponOwner()
	if ( !IsValid( player ) )
		return

	#if SERVER
		Player_DetonateSatchels( player )
	#endif
}

var function OnWeaponTossReleaseAnimEvent_weapon_satchel( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	#if CLIENT
		if ( !weapon.ShouldPredictProjectiles() )
			return
	#endif

	entity player = weapon.GetWeaponOwner()

	vector attackPos
	if ( IsValid( player ) )
		attackPos = GetSatchelThrowStartPos( player, attackParams.pos )
	else
		attackPos = attackParams.pos


	vector attackVec = attackParams.dir
	vector angularVelocity = Vector( 600, RandomFloatRange( -300, 300 ), 0 )

	float fuseTime = 0.0	// infinite

	int damageFlags = weapon.GetWeaponDamageFlags()
	//PROJECTILE_PREDICTED = false
	WeaponFireGrenadeParams fireGrenadeParams
	fireGrenadeParams.pos = attackPos
	fireGrenadeParams.vel = attackParams.dir
	fireGrenadeParams.angVel = angularVelocity
	fireGrenadeParams.fuseTime = fuseTime
	fireGrenadeParams.scriptTouchDamageType = (damageFlags & ~DF_EXPLOSION) // when a grenade "bonks" something, that shouldn't count as explosive.explosive
	fireGrenadeParams.scriptExplosionDamageType = damageFlags

	entity satchel = weapon.FireWeaponGrenade( fireGrenadeParams )
	if ( satchel == null )
		return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )

	Grenade_Init( satchel, weapon )
	PlayerUsedOffhand( player, weapon )

	#if SERVER
		SetVisibleEntitiesInConeQueriableEnabled( satchel, true )
		Satchel_PostFired_Init( satchel, player )
		thread EnableTrapWarningSound( satchel, 0, DEFAULT_WARNING_SFX )
		EmitSoundOnEntityExceptToPlayer( player, player, "weapon_r1_satchel.throw" )
		PROTO_PlayTrapLightEffect( satchel, "LIGHT", player.GetTeam() )
		#if BATTLECHATTER_ENABLED
			TryPlayWeaponBattleChatterLine( player, weapon )
		#endif
	#endif
	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
}

vector function GetSatchelThrowStartPos( entity player, vector baseStartPos )
{
	vector attackPos = player.OffsetPositionFromView( baseStartPos, Vector( 15.0, 0.0, 0.0 ) )	// forward, right, up
	return attackPos
}

vector function GetSatchelThrowVelocity( entity player, vector baseAngles )
{
	baseAngles += Vector( -8, 0, 0 )
	vector forward = AnglesToForward( baseAngles )
	vector velocity = forward * SATCHEL_THROW_POWER

	return velocity
}

void function OnProjectileCollision_weapon_satchel( entity weapon, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical )
{
	table collisionParams =
	{
		pos = pos,
		normal = normal,
		hitEnt = hitEnt,
		hitbox = hitbox
	}

	bool result = PlantStickyEntity( weapon, collisionParams )

	#if SERVER
		entity player = weapon.GetOwner()

		if ( !IsValid( player ) )
		{
			weapon.Kill_Deprecated_UseDestroyInstead()
			return
		}

		EmitSoundOnEntity( weapon, "Weapon_R1_Satchel.Attach" )
		EmitAISoundWithOwner( player, SOUND_PLAYER, 0, player.GetOrigin(), 1000, 0.2 )

		// Added via AddCallback_OnSatchelPlanted
		if ( "onSatchelPlanted" in level )
		{
			foreach ( callbackFunc in level.onSatchelPlanted )
				callbackFunc( player, collisionParams )
		}

		//if player is rodeoing a Titan and we stickied the satchel onto the Titan, set lastAttackTime accordingly
		if ( result )
		{
			entity entAttachedTo = weapon.GetParent()
			if ( !IsValid( entAttachedTo ) )
				return

			if ( !player.IsPlayer() ) //If an NPC Titan has vortexed a satchel and fires it back out, then it won't be a player that is the owner of this satchel
				return

			entity titanSoulRodeoed = player.GetTitanSoulBeingRodeoed()
			if ( !IsValid( titanSoulRodeoed ) )
				return

			entity titan = titanSoulRodeoed.GetTitan()

			if ( !IsAlive( titan ) )
				return

			if ( titan == entAttachedTo )
				titanSoulRodeoed.SetLastRodeoHitTime( Time() )
		}



	#endif
}

function AddCallback_OnSatchelPlanted( callbackFunc )
{
	if ( !( "onSatchelPlanted" in level ) )
		level.onSatchelPlanted <- []

	AssertParameters( callbackFunc, 2, "entity player, table collisionParams" )

	Assert( !level.onSatchelPlanted.contains( callbackFunc ), "Already added " + FunctionToString( callbackFunc ) + " with AddCallback_OnSatchelPlanted" )

	level.onSatchelPlanted.append( callbackFunc )
}