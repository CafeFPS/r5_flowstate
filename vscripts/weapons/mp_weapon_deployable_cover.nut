untyped

global function MpWeaponDeployableCover_Init

global function OnWeaponTossReleaseAnimEvent_weapon_deployable_cover
global function OnWeaponAttemptOffhandSwitch_weapon_deployable_cover
global function OnWeaponTossPrep_weapon_deployable_cover

#if SERVER
global function DeployCover
global function GetAmpedWallsActiveCountForPlayer
#endif

const DEPLOYABLE_ONE_PER_PLAYER = false
const DEPLOYABLE_SHIELD_DURATION = 15.0

const DEPLOYABLE_SHIELD_FX = $"P_pilot_cover_shield"
const DEPLOYABLE_SHIELD_FX_AMPED = $"P_pilot_amped_shield"
const DEPLOYABLE_SHIELD_HEALTH = 225

const DEPLOYABLE_SHIELD_RADIUS = 84
const DEPLOYABLE_SHIELD_HEIGHT = 89
const DEPLOYABLE_SHIELD_FOV = 150

const DEPLOYABLE_SHIELD_ANGLE_LIMIT = 0.5

struct
{
	table< entity, int > playerToAmpedWallsActiveTable //Mainly used to track stat for amped wall execution unlock
	int index
}file;

function MpWeaponDeployableCover_Init()
{
	PrecacheParticleSystem( DEPLOYABLE_SHIELD_FX )
	file.index = PrecacheParticleSystem( DEPLOYABLE_SHIELD_FX_AMPED )
	//you are so weird respawn, I just want to say it
	PrecacheModel( $"mdl/fx/medic_shield_wall.rmdl" )
}

bool function OnWeaponAttemptOffhandSwitch_weapon_deployable_cover( entity weapon )
{
	int ammoReq = weapon.GetAmmoPerShot()
	int currAmmo = weapon.GetWeaponPrimaryClipCount()
	if ( currAmmo < ammoReq )
		return false

	entity player = weapon.GetWeaponOwner()
	if ( player.IsPhaseShifted() )
		return false

	return true
}

var function OnWeaponTossReleaseAnimEvent_weapon_deployable_cover( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	int ammoReq = weapon.GetAmmoPerShot()
	weapon.EmitWeaponSound_1p3p( GetGrenadeThrowSound_1p( weapon ), GetGrenadeThrowSound_3p( weapon ) )

	#if SERVER
	if ( DEPLOYABLE_ONE_PER_PLAYER && IsValid( weapon.w.lastProjectileFired ) )
		weapon.w.lastProjectileFired.Destroy()
	#endif

	entity deployable = ThrowDeployable( weapon, attackParams, DEPLOYABLE_THROW_POWER_WALL, OnDeployableCoverPlanted )
	if ( deployable )
	{
		entity player = weapon.GetWeaponOwner()
		PlayerUsedOffhand( player, weapon )

		#if SERVER
		string projectileSound = GetGrenadeProjectileSound( weapon )
		if ( projectileSound != "" )
			EmitSoundOnEntity( deployable, projectileSound )

		weapon.w.lastProjectileFired = deployable
		#endif

		#if BATTLECHATTER_ENABLED && SERVER
			TryPlayWeaponBattleChatterLine( player, weapon )
		#endif
	}
	return ammoReq
}

void function OnWeaponTossPrep_weapon_deployable_cover( entity weapon, WeaponTossPrepParams prepParams )
{
	weapon.EmitWeaponSound_1p3p( GetGrenadeDeploySound_1p( weapon ), GetGrenadeDeploySound_3p( weapon ) )
}

void function OnDeployableCoverPlanted( entity projectile )
{
	#if SERVER
		Assert( IsValid( projectile ) )
		vector origin = projectile.GetOrigin()

		vector endOrigin = origin - Vector( 0.0, 0.0, 32.0 )
		vector surfaceAngles = projectile.proj.savedAngles
		vector oldUpDir = AnglesToUp( surfaceAngles )

		TraceResults traceResult = TraceLine( origin, endOrigin, [], TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_NONE )
		if ( traceResult.fraction < 1.0 )
		{
			vector forward = AnglesToForward( projectile.proj.savedAngles )
			surfaceAngles = AnglesOnSurface( traceResult.surfaceNormal, forward )

			vector newUpDir = AnglesToUp( surfaceAngles )
			if ( DotProduct( newUpDir, oldUpDir ) < DEPLOYABLE_SHIELD_ANGLE_LIMIT )
				surfaceAngles = projectile.proj.savedAngles
		}

		projectile.SetAngles( surfaceAngles )

		bool isAmpedWall = !( projectile.ProjectileGetMods().contains( "burn_card_weapon_mod" ) ) //Unusual, but deliberate: the boost version of the weapon does not have amped functionality

		if ( isAmpedWall )
			DeployAmpedWall( projectile, origin, surfaceAngles )
		else
			DeployCover( projectile, origin, surfaceAngles )
	#endif
}

#if SERVER
void function DeployCover( entity projectile, vector origin, vector angles, float duration = DEPLOYABLE_SHIELD_DURATION )
{
	Assert( IsValid( projectile ) )
	if ( !IsValid( projectile ) )
		return

	EmitSoundOnEntity( projectile, "Hardcover_Shield_Start_3P" )

	vector fwd = AnglesToForward( angles )
	vector up = AnglesToUp( angles )
	origin = origin - (fwd * (DEPLOYABLE_SHIELD_RADIUS - 1.0))
	origin = origin - (up * 1.0)

	entity vortexSphere = CreateShieldWithSettings( origin, angles, DEPLOYABLE_SHIELD_RADIUS, DEPLOYABLE_SHIELD_HEIGHT, DEPLOYABLE_SHIELD_FOV, duration, DEPLOYABLE_SHIELD_HEALTH, DEPLOYABLE_SHIELD_FX )

	Assert( vortexSphere )
	if ( !vortexSphere )
		return

	vortexSphere.SetParent( projectile )
	vortexSphere.EndSignal( "OnDestroy" )
	vortexSphere.SetBlocksRadiusDamage( true )
	vortexSphere.DisableVortexBlockLOS()

	UpdateShieldWallColorForFrac( vortexSphere.e.shieldWallFX, GetHealthFrac( vortexSphere ) )

	OnThreadEnd(
		function() : ( vortexSphere, projectile )
		{
			StopSoundOnEntity( projectile, "Hardcover_Shield_Start_3P" )
			EmitSoundOnEntity( projectile, "Hardcover_Shield_End_3P" )

			if ( IsValid( projectile ) && projectile.IsProjectile() )
				projectile.GrenadeExplode( Vector(0,0,0) )

			if ( IsValid( vortexSphere ) )
				vortexSphere.Destroy()
		}
	)

	wait duration
}

void function DeployAmpedWall( entity grenade, vector origin, vector angles )
{
	Assert( grenade )
	EmitSoundOnEntity( grenade, "Hardcover_Shield_Start_3P" )
	grenade.SetBlocksRadiusDamage( true )

	vector fwd = AnglesToForward( angles )
	vector up = AnglesToUp( angles )
	origin = origin - (fwd * (DEPLOYABLE_SHIELD_RADIUS - 1.0))
	origin = origin - (up * 1.0)

	entity shieldFX = StartParticleEffectInWorld_ReturnEntity( file.index, origin, angles )

	angles = AnglesCompose( angles, <0,180,0> )
	entity ampedWall = CreatePropDynamic( $"mdl/fx/medic_shield_wall.rmdl", origin, angles, SOLID_VPHYSICS )


	ampedWall.kv.contents = (CONTENTS_WINDOW)
	ampedWall.kv.CollisionGroup = TRACE_COLLISION_GROUP_BLOCK_WEAPONS_AND_PHYSICS
	ampedWall.SetPassThroughFlags( PTF_ADDS_MODS | PTF_NO_DMG_ON_PASS_THROUGH )
	ampedWall.SetBlocksRadiusDamage( true )
	ampedWall.Hide()
	ampedWall.SetTakeDamageType( DAMAGE_YES)
	ampedWall.SetDamageNotifications( true )
	ampedWall.SetMaxHealth( 225 )
	ampedWall.SetHealth( 225 )
	ampedWall.EndSignal( "OnDestroy" )
	

	SetVisibleEntitiesInConeQueriableEnabled( ampedWall, true )

	AddEntityCallback_OnDamaged( ampedWall, OnAmpedWallDamaged )
	
	SetTeam( ampedWall, TEAM_BOTH )

	ampedWall.SetPassThroughThickness( 0 )
	ampedWall.SetPassThroughDirection( -0.30 )
	StatusEffect_AddTimed( ampedWall, eStatusEffect.pass_through_amps_weapon, 1.0, DEPLOYABLE_SHIELD_DURATION, 0.0 )
	
	CreateAirShakeRumbleOnly( origin, 16, 150, 0.6, 150 )

	entity owner = grenade.GetThrower()
	if ( IsValid( owner ) && owner.IsPlayer() )
	{
		array<entity> offhandWeapons = owner.GetOffhandWeapons()
		foreach ( weapon in offhandWeapons )
		{
			//if ( weapon.GetWeaponClassName() == grenade.GetWeaponClassName() ) // function doesn't exist for grenade entities
			if ( weapon.GetWeaponClassName() == "mp_weapon_deployable_cover" )
			{
				StatusEffect_AddTimed( weapon, eStatusEffect.simple_timer, 1.0, DEPLOYABLE_SHIELD_DURATION, DEPLOYABLE_SHIELD_DURATION )
				break
			}
		}

		thread MonitorAmpedWallsActiveForPlayer( ampedWall, owner )
	}

	OnThreadEnd(
		function() : ( ampedWall, grenade, shieldFX )
		{   
			if (IsValid(grenade ) ){
			StopSoundOnEntity( grenade, "Hardcover_Shield_Start_3P" )
			EmitSoundOnEntity( grenade, "Hardcover_Shield_End_3P" )}

			if ( IsValid( grenade ) )
				grenade.GrenadeExplode( Vector( 0, 0, 0 ) )

			if ( IsValid( ampedWall ) )
				ampedWall.Destroy()

			if ( IsValid( shieldFX ) )
				shieldFX.Destroy()
		}
	)

	wait DEPLOYABLE_SHIELD_DURATION
}

void function MonitorAmpedWallsActiveForPlayer( entity ampedWall, entity player )
{
	if ( player in file.playerToAmpedWallsActiveTable )
		++file.playerToAmpedWallsActiveTable[ player ]
	else
		file.playerToAmpedWallsActiveTable[ player ] <- 1

	ampedWall.EndSignal( "OnDestroy" )


	OnThreadEnd(
	function() : ( player )
		{
			if( IsValid( player ) )
			{
				Assert( player in file.playerToAmpedWallsActiveTable )
				--file.playerToAmpedWallsActiveTable[ player ]
			}

		}
	)

	WaitForever()
}

int function GetAmpedWallsActiveCountForPlayer( entity player )
{
	if ( !(player in file.playerToAmpedWallsActiveTable ))
		return 0

	return file.playerToAmpedWallsActiveTable[player ]
}

void function OnAmpedWallDamaged( entity ampedWall, var damageInfo )
{
	entity attacker = DamageInfo_GetAttacker( damageInfo )
	if ( !IsValid( attacker ) )
		return

	if ( attacker.IsPlayer() )
		attacker.NotifyDidDamage( ampedWall, 0, DamageInfo_GetDamagePosition( damageInfo ), DamageInfo_GetCustomDamageType( damageInfo ), DamageInfo_GetDamage( damageInfo ), DamageInfo_GetDamageFlags( damageInfo ), DamageInfo_GetHitGroup( damageInfo ), DamageInfo_GetWeapon( damageInfo ), DamageInfo_GetDistFromAttackOrigin( damageInfo ) )

	float damage = DamageInfo_GetDamage( damageInfo )
	ShieldDamageModifier damageModifier = GetShieldDamageModifier( damageInfo )
	damage *= damageModifier.damageScale

	DamageInfo_SetDamage( damageInfo, damage )
}

#endif