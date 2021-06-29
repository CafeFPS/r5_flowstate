untyped

global function MpWeaponProximityMine_Init
global function OnWeaponTossReleaseAnimEvent_weapon_proximity_mine
global function OnProjectileCollision_weapon_proximity_mine

#if SERVER
global function ShowProxMineTriggeredIcon
#endif

const MAX_PROXIMITY_MINES_IN_WORLD = 4  // if more than this are thrown, the oldest one gets cleaned up
const PROXIMITY_MINE_THROW_POWER = 620
const ATTACH_SFX = "Weapon_ProximityMine_Land"
const WARNING_SFX = "Weapon_ProximityMine_ArmedBeep"

struct {
	int iconCount = 0
	int totalIcons = 10
	var[10] icons
} file
function MpWeaponProximityMine_Init()
{
	#if SERVER
		RegisterSignal( "ProxMineTriggered" )
	#endif
}

#if SERVER
function ShowProxMineTriggeredIcon( entity triggeredEnt )
{
	triggeredEnt.Signal( "ProxMineTriggered")
	triggeredEnt.EndSignal( "OnDeath" )
	triggeredEnt.EndSignal( "ProxMineTriggered" )

	wait PROX_MINE_MARKER_TIME
}
#endif

var function OnWeaponTossReleaseAnimEvent_weapon_proximity_mine( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	#if CLIENT
		if ( !weapon.ShouldPredictProjectiles() )
			return
	#endif

	entity player = weapon.GetWeaponOwner()

	vector attackPos
	if ( IsValid( player ) )
		attackPos = GetProximityMineThrowStartPos( player, attackParams.pos )
	else
		attackPos = attackParams.pos

	vector attackVec = attackParams.dir
	vector angularVelocity = Vector( 600, RandomFloatRange( -300, 300 ), 0 )

	float fuseTime = 0.0	// infinite

	int damageFlags = weapon.GetWeaponDamageFlags()
	//PROJECTILE_PREDICTED = false
	WeaponFireGrenadeParams fireGrenadeParams
	fireGrenadeParams.pos = attackPos
	//fireGrenadeParams.vec = attackVec
	fireGrenadeParams.angVel = angularVelocity
	fireGrenadeParams.fuseTime = fuseTime
	fireGrenadeParams.scriptTouchDamageType = (damageFlags & ~DF_EXPLOSION) // when a grenade "bonks" something, that shouldn't count as explosive.explosive
	fireGrenadeParams.scriptExplosionDamageType = damageFlags
	entity proximityMine = weapon.FireWeaponGrenade( fireGrenadeParams )
	if ( proximityMine == null )
		return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )

	Grenade_Init( proximityMine, weapon )
	PlayerUsedOffhand( player, weapon )
	#if SERVER
		EmitSoundOnEntityExceptToPlayer( player, player, "weapon_proximitymine_throw" )
		ProximityCharge_PostFired_Init( proximityMine, player )
		thread ProximityMineThink( proximityMine, player )
		thread TrapDestroyOnRoundEnd( player, proximityMine )
		PROTO_PlayTrapLightEffect( proximityMine, "BLINKER", player.GetTeam() )
	#endif
	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
}

vector function GetProximityMineThrowStartPos( entity player, vector baseStartPos )
{
	vector attackPos = player.OffsetPositionFromView( baseStartPos, Vector( 15.0, 0.0, 0.0 ) )	// forward, right, up
	return attackPos
}

vector function GetProximityMineThrowVelocity( vector baseAngles )
{
	baseAngles += Vector( -10, 0, 0 )
	vector forward = AnglesToForward( baseAngles )
	vector velocity = forward * PROXIMITY_MINE_THROW_POWER

	return velocity
}

void function OnProjectileCollision_weapon_proximity_mine( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical )
{
	// Old version, but that rotation/position offset stuff is bunk and if this weapon comes back, we fix the asset.
	//bool result = PlantStickyEntity( projectile, collisionParams, Vector( 90, 0, 0 ), false, Vector( 0, 0, -3.9 ) )
	table collisionParams =
	{
		pos = pos,
		normal = normal,
		hitEnt = hitEnt,
		hitbox = hitbox
	}
	bool result = PlantStickyEntity( projectile, collisionParams )

	#if SERVER
		entity player = projectile.GetOwner()

		if ( !IsValid( player ) )
		{
			projectile.Kill_Deprecated_UseDestroyInstead()
			return
		}

		EmitSoundOnEntity( projectile, ATTACH_SFX )

		thread EnableTrapWarningSound( projectile, PROXIMITY_MINE_ARMING_DELAY, WARNING_SFX )

		// if player is rodeoing a Titan and we stickied the mine onto the Titan, set lastAttackTime accordingly
		if ( result )
		{
			entity entAttachedTo = projectile.GetParent()
			if ( !IsValid( entAttachedTo ) )
				return

			if ( !player.IsPlayer() ) //If an NPC Titan has vortexed a prox mine  and fires it back out, then it won't be a player that is the owner of this satchel
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