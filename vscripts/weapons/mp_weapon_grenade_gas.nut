global function MpWeaponGrenadeGas_Init
global function OnProjectileCollision_weapon_grenade_gas
global function OnWeaponReadyToFire_weapon_grenade_gas
global function OnWeaponTossReleaseAnimEvent_weapon_greande_gas
global function OnWeaponDeactivate_weapon_grenade_gas

const float WEAPON_GAS_GRENADE_DELAY = 1.0
const float WEAPON_GAS_GRENADE_DURATION = 15.0
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

	projectile.NotSolid()
	thread DeployGas( projectile )
	#endif

	projectile.GrenadeIgnite()
}

#if SERVER

void function DeployGas( entity projectile )
{
	Assert ( IsNewThread(), "Must be threaded off." )
	projectile.EndSignal( "OnDestroy" )

	OnThreadEnd(
		function() : ( projectile )
		{
			if ( IsValid( projectile ) )
				projectile.Destroy()
		}
	)

	wait WEAPON_GAS_GRENADE_DELAY - 1.0

	EmitSoundOnEntity( projectile, GAS_GRENADE_WARNING_SOUND )

	wait 0.8

	if ( !IsValid( projectile.GetThrower() ) )
		return
	if ( IsTeamEliminated( projectile.GetThrower().GetTeam() ) )
		return

	thread DeployGas_Internal( projectile )
}


float function GetGasDuration( entity owner )
{
	float result = WEAPON_GAS_GRENADE_DURATION

	//if( IsValid( owner ) && owner.HasPassive( ePassives.PAS_ULT_UPGRADE_ONE ) ) // upgrade_caustic_gas_duration
	//{
	//	result *= GetUpgradedGasDurationMultiplier()
	//}
       

	return result
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

	entity dummyCloudSource = CreateScriptMover( origin )
	dummyCloudSource.SetOwner( owner )
	if(owner)
	{
		dummyCloudSource.RemoveFromAllRealms()
		dummyCloudSource.AddToOtherEntitysRealms( owner )
	}

	if ( IsValid( myParent ) )
	{
		entity parentPoint = CreateScriptMover( origin, Vector( 0, 0, 0 ) )
		parentPoint.SetParent( myParent )
		dummyCloudSource.SetParent( parentPoint )
	}

	TrackingVision_CreatePOI( eTrackingVisionNetworkedPOITypes.PLAYER_ABILITIES_GAS, dummyCloudSource, dummyCloudSource.GetOrigin(), dummyCloudSource.GetTeam(), dummyCloudSource )
	float gasDuration = GetGasDuration( owner )
	CreateGasCloudLarge( dummyCloudSource, gasDuration, WEAPON_GAS_GRENADE_OFFSET )
	
	waitthread DelayedDestroy( dummyCloudSource, gasDuration )
}

#endif