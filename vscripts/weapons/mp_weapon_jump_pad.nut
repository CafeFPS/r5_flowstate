untyped

global function OnWeaponTossReleaseAnimEvent_weapon_jump_pad
global function OnWeaponAttemptOffhandSwitch_weapon_jump_pad
global function OnWeaponTossPrep_weapon_jump_pad

const float JUMP_PAD_ANGLE_LIMIT = 0.70

bool function OnWeaponAttemptOffhandSwitch_weapon_jump_pad( entity weapon )
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

var function OnWeaponTossReleaseAnimEvent_weapon_jump_pad( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	int ammoReq = weapon.GetAmmoPerShot()
	weapon.EmitWeaponSound_1p3p( GetGrenadeThrowSound_1p( weapon ), GetGrenadeThrowSound_3p( weapon ) )

	entity deployable = ThrowDeployable( weapon, attackParams, 1.0, OnJumpPadPlanted )
	if ( deployable )
	{
		entity player = weapon.GetWeaponOwner()
		PlayerUsedOffhand( player, weapon, true, deployable )

		#if false








#endif

		#if false

#endif

	}

	return ammoReq
}

void function OnWeaponTossPrep_weapon_jump_pad( entity weapon, WeaponTossPrepParams prepParams )
{
	weapon.EmitWeaponSound_1p3p( GetGrenadeDeploySound_1p( weapon ), GetGrenadeDeploySound_3p( weapon ) )
}

void function OnJumpPadPlanted( entity projectile )
{
	#if SERVER
	Assert( IsValid( projectile ) )

	entity owner = projectile.GetOwner()

	if( !IsValid( owner ) )
	{
		projectile.Destroy()
		return
	}


	vector origin = projectile.GetOrigin()
	vector endOrigin = origin - <0,0,32>
	vector surfaceAngles = projectile.proj.savedAngles
	vector oldUpDir = AnglesToUp( surfaceAngles )

	// is this used?
	TraceResults traceResult = TraceLine( origin, endOrigin, [ projectile ], TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_BLOCK_WEAPONS_AND_PHYSICS )
	if ( traceResult.fraction < 1.0 )
	{
		vector forward = AnglesToForward( projectile.proj.savedAngles )
		surfaceAngles = AnglesOnSurface( traceResult.surfaceNormal, forward )

		vector newUpDir = AnglesToUp( surfaceAngles )
		if ( DotProduct( newUpDir, oldUpDir ) < JUMP_PAD_ANGLE_LIMIT )
			surfaceAngles = projectile.proj.savedAngles
	}

	entity oldParent = projectile.GetParent()
	projectile.ClearParent()

	origin = projectile.GetOrigin()
	asset model = $"mdl/props/octane_jump_pad/octane_jump_pad.rmdl"// projectile.GetModelName()
	//float duration = projectile.GetProjectileWeaponSettingFloat( eWeaponVar.fire_duration )

	//Use NoDispatchSpawn so that we can setup the entity before spawning it in the game world
	entity newProjectile = CreatePropDynamic_NoDispatchSpawn( model, origin, surfaceAngles, SOLID_VPHYSICS )

	newProjectile.RemoveFromAllRealms()
	newProjectile.AddToOtherEntitysRealms( projectile )
	projectile.Destroy()

	newProjectile.kv.solid = 6
	newProjectile.SetTakeDamageType( DAMAGE_YES )
	newProjectile.SetMaxHealth( 100 )
	newProjectile.SetHealth( 100 )
	SetVisibleEntitiesInConeQueriableEnabled( newProjectile, true )

	newProjectile.SetOwner( owner )

	//Dispatch the spawn after our settings are done
	DispatchSpawn( newProjectile )

	thread TrapDestroyOnRoundEnd( owner, newProjectile )

	if ( IsValid( traceResult.hitEnt ) )
	{
		newProjectile.SetParent( traceResult.hitEnt )
	}
	else if ( IsValid( oldParent ) )
	{
		newProjectile.SetParent( oldParent )
	}

	// collision for the bubble shield for sliding doors
	entity jumpPadProxy = CreateEntity( "script_mover_lightweight" )
	jumpPadProxy.kv.solid = SOLID_VPHYSICS
	jumpPadProxy.kv.fadedist = -1
	jumpPadProxy.SetValueForModelKey( $"mdl/props/octane_jump_pad/octane_jump_pad.rmdl" )
	jumpPadProxy.kv.SpawnAsPhysicsMover = 0
	jumpPadProxy.e.isDoorBlocker = true

	jumpPadProxy.SetOrigin( newProjectile.GetOrigin() )
	jumpPadProxy.SetAngles( newProjectile.GetAngles() )


	DispatchSpawn( jumpPadProxy )
	jumpPadProxy.Hide()
	jumpPadProxy.SetParent( newProjectile )
	jumpPadProxy.SetOwner( owner )

	JumpPad_CreatedCallback( newProjectile )
	#endif
}