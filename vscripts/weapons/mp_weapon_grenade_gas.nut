global function MpWeaponGrenadeGas_Init
global function OnProjectileCollision_weapon_grenade_gas
global function OnWeaponReadyToFire_weapon_grenade_gas
global function OnWeaponTossReleaseAnimEvent_weapon_greande_gas
global function OnWeaponDeactivate_weapon_grenade_gas

const float WEAPON_GAS_GRENADE_DELAY = 1.0
const float WEAPON_GAS_GRENADE_DURATION = 20.0
const vector WEAPON_GAS_GRENADE_OFFSET = <0,0,16>

const string GAS_GRENADE_WARNING_SOUND 	= "weapon_vortex_gun_explosivewarningbeep"

const asset GAS_GRENADE_FX_GLOW_FP = $"P_wpn_grenade_gas_glow_FP"
const asset GAS_GRENADE_FX_GLOW_3P = $"P_wpn_grenade_gas_glow_3P"

void function MpWeaponGrenadeGas_Init()
{
	PrecacheParticleSystem( GAS_GRENADE_FX_GLOW_FP )
	PrecacheParticleSystem( GAS_GRENADE_FX_GLOW_3P )
}


void function OnWeaponReadyToFire_weapon_grenade_gas( entity weapon )
{
	weapon.PlayWeaponEffect( GAS_GRENADE_FX_GLOW_FP, GAS_GRENADE_FX_GLOW_3P, "FX_TRAIL" )
}

void function OnWeaponDeactivate_weapon_grenade_gas( entity weapon )
{
	weapon.StopWeaponEffect( GAS_GRENADE_FX_GLOW_FP, GAS_GRENADE_FX_GLOW_3P )
	Grenade_OnWeaponDeactivate( weapon )
}

var function OnWeaponTossReleaseAnimEvent_weapon_greande_gas( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	weapon.StopWeaponEffect( GAS_GRENADE_FX_GLOW_FP, GAS_GRENADE_FX_GLOW_3P )

	var result = Grenade_OnWeaponToss( weapon, attackParams, 1.0 )
	return result
}


void function OnProjectileCollision_weapon_grenade_gas( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical )
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
	projectile.proj.projectileBounceCount++
	if ( !result && projectile.proj.projectileBounceCount < 10 )
	{
		return
	}
	else if ( IsValid( hitEnt ) && ( hitEnt.IsPlayer() || hitEnt.IsTitan() || hitEnt.IsNPC() ) )
	{
		projectile.NotSolid()
		thread DeployGas( projectile )
	}
	else
	{
		projectile.NotSolid()
		thread DeployGas( projectile )
	}
	#endif

	projectile.GrenadeIgnite()
}

#if SERVER

void function DeployGas( entity projectile )
{
	Assert ( IsNewThread(), "Must be threaded off." )
	projectile.EndSignal( "OnDestroy" )

	wait WEAPON_GAS_GRENADE_DELAY - 1.0

	EmitSoundOnEntity( projectile, GAS_GRENADE_WARNING_SOUND )

	wait 0.8

	thread DeployGas_Internal( projectile )
}

void function DeployGas_Internal( entity projectile )
{
	vector origin = projectile.GetOrigin()
	entity owner = projectile.GetThrower()
	if ( !IsValid( owner ) )
		return
	entity myParent = projectile.GetParent()

	owner.EndSignal( "OnDestroy" )
	projectile.GrenadeExplode( <0,0,1> )

	wait 0.2

	entity mover = CreateScriptMover( origin )
	mover.SetOwner( owner )
	if(owner)
	{
		mover.RemoveFromAllRealms()
		mover.AddToOtherEntitysRealms( owner )
	}

	if ( IsValid( myParent ) )
	{
		mover.SetParent( myParent )
	}

	TrackingVision_CreatePOI( eTrackingVisionNetworkedPOITypes.PLAYER_ABILITIES_GAS, mover, mover.GetOrigin(), mover.GetTeam(), mover )
	CreateGasCloudLarge( mover, WEAPON_GAS_GRENADE_DURATION, WEAPON_GAS_GRENADE_OFFSET )
	thread DelayedDestroy( mover, WEAPON_GAS_GRENADE_DURATION )
}

#endif