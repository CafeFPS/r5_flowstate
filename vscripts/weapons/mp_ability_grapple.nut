global function OnWeaponActivate_ability_grapple
global function OnWeaponPrimaryAttack_ability_grapple
global function OnWeaponAttemptOffhandSwitch_ability_grapple
global function OnWeaponReadyToFire_ability_grapple
global function CodeCallback_OnGrappleActivate
global function CodeCallback_OnGrappleAttach
global function CodeCallback_OnGrappleDetach
global function GrappleWeaponInit

#if SERVER
global function OnWeaponNpcPrimaryAttack_ability_grapple
global function AddEntityCallback_OnGrappled
global function RemoveEntityCallback_OnGrappled
global function AddCallback_OnGrappled
global function AddCallback_OnGrappleDetached
global function RemoveCallback_OnGrappled

#endif // SERVER

struct
{
	int grappleExplodeImpactTable
	array<void functionref( entity player, entity hitent, vector hitpos, vector hitNormal )> onGrappledCallbacks
	array<void functionref( entity player )> onGrappleDetachCallbacks

	int grappleDrainBaseCost = 100
	float grappleDrainMinDist = 300
	float grappleDrainMaxDist = 2800
	float grappleDrainMaxDist_Zscalar = 0.5
} file

const int GRAPPLEFLAG_CHARGED	= (1<<0)
const int CHANCE_TO_COMMENT_GRAPPLE = 33

void function GrappleWeaponInit()
{
	file.grappleExplodeImpactTable = PrecacheImpactEffectTable( "exp_rocket_archer" )

	RegisterSignal( "Grapple_OnTouchGround" )

	file.grappleDrainBaseCost = GetCurrentPlaylistVarInt( "pathfinder_grapple_drain_base_cost", 100 )
	file.grappleDrainMinDist = GetCurrentPlaylistVarFloat( "pathfinder_grapple_drain_min_dist", 300 )
	file.grappleDrainMaxDist = GetCurrentPlaylistVarFloat( "pathfinder_grapple_drain_max_dist", 4500 )
	file.grappleDrainMaxDist_Zscalar = GetCurrentPlaylistVarFloat( "pathfinder_grapple_drain_z_scalar", 0.5 )

#if SERVER
	Bleedout_AddCallback_OnPlayerStartBleedout( Grapple_OnPlayerStartBleedout )
	AddCallback_OnGrappled( GrappleNPCCallback )
	RegisterSignal( "OnGrappled" )
	//RegisterSignal( "OnGrappleDetach" )
#endif
}

void function OnWeaponActivate_ability_grapple( entity weapon )
{
	entity weaponOwner = weapon.GetWeaponOwner()
	int pmLevel = -1
	if ( (pmLevel >= 2) && IsValid( weaponOwner ) )
		weapon.SetScriptTime0( Time() )
	else
		weapon.SetScriptTime0( 0.0 )

	{
		int oldFlags = weapon.GetScriptFlags0()
		weapon.SetScriptFlags0( oldFlags & ~GRAPPLEFLAG_CHARGED )
	}
}

var function OnWeaponPrimaryAttack_ability_grapple( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity owner = weapon.GetWeaponOwner()

	if ( owner.IsPlayer() )
	{
		int pmLevel = -1
		float scriptTime = weapon.GetScriptTime0()
		if ( (pmLevel >= 2) && (scriptTime != 0.0) )
		{
			float chargeMaxTime = weapon.GetWeaponSettingFloat( eWeaponVar.custom_float_0 )
			float chargeTime = (Time() - scriptTime)
			if ( chargeTime >= chargeMaxTime )
			{
				int oldFlags = weapon.GetScriptFlags0()
				weapon.SetScriptFlags0( oldFlags | GRAPPLEFLAG_CHARGED )
			}
		}
	}

	PlayerUsedOffhand( owner, weapon )

	vector grappleDirection = attackParams.dir
	entity grappleAutoAimTarget = null
	if ( owner.IsPlayer() )
	{
		if ( !owner.IsGrappleActive() )
		{
			entity autoAimTarget = GrappleAutoAim_FindTarget( owner )
			if ( autoAimTarget )
			{
				vector ownerToTarget = autoAimTarget.GetWorldSpaceCenter() - attackParams.pos
				grappleDirection = Normalize( ownerToTarget )
				grappleAutoAimTarget = autoAimTarget
			}
		}
	}

	owner.Grapple( grappleDirection )

	if ( owner.IsPlayer() && owner.IsGrappleActive() && grappleAutoAimTarget )
	{
		owner.SetGrappleAutoAimTarget( grappleAutoAimTarget )
	}

	if ( weapon.HasMod( "survival_finite_ordnance" ) )
		return 0
	else
		return 0 // weapon.GetWeaponSettingInt( eWeaponVar.ammo_min_to_fire ) 
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_ability_grapple( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity owner = weapon.GetWeaponOwner()

	owner.GrappleNPC( attackParams.dir )

	return 1
}
#endif

bool function OnWeaponAttemptOffhandSwitch_ability_grapple( entity weapon )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	bool allowSwitch = (ownerPlayer.GetSuitGrapplePower() >= 100.0)

	if ( !allowSwitch )
	{
		Assert( ownerPlayer == weapon.GetWeaponOwner() )
		ownerPlayer.Grapple( <0,0,1> )
	}

	return allowSwitch
}

void function OnWeaponReadyToFire_ability_grapple( entity weapon )
{
	#if SERVER
		PIN_PlayerAbilityReady( weapon.GetWeaponOwner(), ABILITY_TYPE.TACTICAL )
	#endif
}

void function DoGrappleImpactExplosion( entity player, entity grappleWeapon, entity hitent, vector hitpos, vector hitNormal )
{
#if CLIENT
	if ( !grappleWeapon.ShouldPredictProjectiles() )
		return
#endif

	vector origin = hitpos + hitNormal * 16.0
	int damageType = (DF_RAGDOLL | DF_EXPLOSION | DF_ELECTRICAL)
	WeaponFireGrenadeParams fireGrenadeParams
	fireGrenadeParams.pos = origin
	fireGrenadeParams.vel = hitNormal
	fireGrenadeParams.angVel = <0,0,0>
	fireGrenadeParams.fuseTime = 0.01
	fireGrenadeParams.scriptTouchDamageType = damageType
	fireGrenadeParams.scriptExplosionDamageType = damageType
	fireGrenadeParams.clientPredicted = true
	fireGrenadeParams.lagCompensated = true
	fireGrenadeParams.useScriptOnDamage = true
	entity nade = grappleWeapon.FireWeaponGrenade( fireGrenadeParams )
	if ( !nade )
		return

	nade.SetImpactEffectTable( file.grappleExplodeImpactTable )
	nade.GrenadeExplode( hitNormal )
}

void function CodeCallback_OnGrappleActivate( entity player )
{
	entity grappleWeapon = player.GetOffhandWeapon( OFFHAND_LEFT )
	if ( !IsValid( grappleWeapon ) )
		return
	if ( !grappleWeapon.GetWeaponSettingBool( eWeaponVar.grapple_weapon ) )
		return

	grappleWeapon.e.lastGrappleTime = -1
}

void function CodeCallback_OnGrappleAttach( entity player, entity hitent, vector hitpos, vector hitNormal )
{
#if SERVER	
	PIN_PlayerAbility( player, "mp_ability_grapple", ABILITY_TYPE.TACTICAL, null, {pos = hitpos, attached = true} )
	if ( IsValid( hitent ) )
	{
		// Added via AddEntityCallback_OnGrappled
		foreach ( callbackFunc in hitent.e.onGrappledCallbacks )
		{
			thread callbackFunc( player, hitent, hitpos, hitNormal )
		}
	}

	// Added via AddCallback_OnGrappled
	foreach ( callbackFunc in file.onGrappledCallbacks )
	{
		thread callbackFunc( player, hitent, hitpos, hitNormal )
	}

	if ( RandomIntRange( 0, 100 ) <= CHANCE_TO_COMMENT_GRAPPLE )
		PlayBattleChatterLineToSpeakerAndTeam( player, "bc_tactical" )

	StatsHook_Grapple_OnAttach( player )

#endif // SERVER

	// assault impact:
	{
		if ( !IsValid( player ) )
			return

		entity grappleWeapon = player.GetOffhandWeapon( OFFHAND_LEFT )
		if ( !IsValid( grappleWeapon ) )
			return
		if ( !grappleWeapon.GetWeaponSettingBool( eWeaponVar.grapple_weapon ) )
			return

		grappleWeapon.e.lastGrappleTime = Time()

		thread GrappleDecreaseAmmo( player, grappleWeapon )

		int flags = grappleWeapon.GetScriptFlags0()
		if ( ! (flags & GRAPPLEFLAG_CHARGED) )
			return

		int expDamage = grappleWeapon.GetWeaponSettingInt( eWeaponVar.explosion_damage )
		if ( expDamage <= 0 )
			return

		DoGrappleImpactExplosion( player, grappleWeapon, hitent, hitpos, hitNormal )
	}
}

void function GrappleDecreaseAmmo( entity player, entity grappleWeapon )
{
	#if CLIENT
		if ( !InPrediction() )
			return
	#endif
	player.EndSignal( "OnDeath" )
	grappleWeapon.EndSignal( "OnDestroy" )

	vector startPos = player.GetOrigin()

	table<string , float> d
	table<string , vector> e
	e[ "startPos" ] <- startPos
	e[ "lastPos" ] <- startPos
	d[ "distanceTraveled" ] <- 0.0
	d[ "distanceTraveled_z" ] <- 0.0

	float startTime = Time()
	float fireDuration = grappleWeapon.GetWeaponSettingFloat( eWeaponVar.fire_duration )

	int maxAmmo = grappleWeapon.GetWeaponSettingInt( eWeaponVar.ammo_min_to_fire )
	int startAmmo = grappleWeapon.GetWeaponPrimaryClipCount()

	{
		int amountToReduce = file.grappleDrainBaseCost

		int newAmmo = maxint( 0, grappleWeapon.GetWeaponPrimaryClipCount() - amountToReduce )
		grappleWeapon.SetWeaponPrimaryClipCount( 0 )
		grappleWeapon.AddMod( "grapple_regen_stop" )
		grappleWeapon.RegenerateAmmoReset()
	}

	OnThreadEnd(
		function() : ( player, e, d, startAmmo, maxAmmo, grappleWeapon )
		{
			if ( IsValid( player ) )
			{
				if ( IsValid( grappleWeapon ) )
				{
					d[ "distanceTraveled" ] += Distance2D( e[ "lastPos" ], player.GetOrigin() )
					d[ "distanceTraveled_z" ] = max( d[ "distanceTraveled_z" ], fabs( player.GetOrigin().z - e[ "startPos" ].z ) )
					float distanceTraveled = max( max( d[ "distanceTraveled" ], Distance( e[ "startPos" ], player.GetOrigin() ) ), d[ "distanceTraveled_z" ] * file.grappleDrainMaxDist_Zscalar )
					ReduceAmmoBasedOnDistance( grappleWeapon, d[ "distanceTraveled" ], startAmmo, maxAmmo )
				}
			}
		}
	)

	bool playerWasOnZipline = player.IsZiplining()
	while ( player.IsGrappleActive() || Length( player.GetVelocity() ) > 500.0 )
	{
		grappleWeapon.SetWeaponPrimaryClipCount( 0 )

		d[ "distanceTraveled" ] += Distance2D( e[ "lastPos" ], player.GetOrigin() )
		d[ "distanceTraveled_z" ] = max( d[ "distanceTraveled_z" ], fabs( player.GetOrigin().z - e[ "startPos" ].z ) )
		float distanceTraveled = max( max( d[ "distanceTraveled" ], Distance( e[ "startPos" ], player.GetOrigin() ) ), d[ "distanceTraveled_z" ] * file.grappleDrainMaxDist_Zscalar )
		e[ "lastPos" ] <- player.GetOrigin()

		if ( player.IsZiplining() && !playerWasOnZipline )
			break

		if ( !player.IsZiplining() )
			playerWasOnZipline =  false

		if ((Time() - startTime) > 5)
			break
		
		wait 0.1
	}
}

void function ReduceAmmoBasedOnDistance( entity grappleWeapon, float distanceTraveled, int startAmmo, int maxAmmo )
{
	#if CLIENT
		if ( !InPrediction() )
			return
	#endif

	if ( !IsValid( grappleWeapon.GetWeaponOwner() ) )
		return

	float XYScalar = GraphCapped( distanceTraveled, file.grappleDrainMinDist, file.grappleDrainMaxDist, 0, 1.0 )

	int amountToReduce = int( GraphCapped( XYScalar, 0, 1.0, 0, maxAmmo ) )                                                                                                          
	amountToReduce += file.grappleDrainBaseCost

	int newAmmo = minint( maxAmmo, maxint( 0, startAmmo - amountToReduce ) )

	grappleWeapon.SetWeaponPrimaryClipCount( newAmmo )
	if ( grappleWeapon.HasMod( "grapple_regen_stop" ) )
		grappleWeapon.RemoveMod( "grapple_regen_stop" )

	grappleWeapon.RegenerateAmmoReset()
}
void function CodeCallback_OnGrappleDetach( entity player )
{
	#if SERVER
		// Added via AddCallback_OnGrappleDetached
		foreach ( callbackFunc in file.onGrappleDetachCallbacks )
		{
			thread callbackFunc( player )
		}
		
		//Signal( player, "OnGrappleDetach" )
	#endif
}

#if SERVER
void function AddEntityCallback_OnGrappled( entity ent, void functionref( entity player, entity hitent, vector hitpos, vector hitNormal ) callbackFunc )
{
	Assert( !ent.e.onGrappledCallbacks.contains( callbackFunc ), "Already added " + string( callbackFunc ) + " to entity" )
	ent.e.onGrappledCallbacks.append( callbackFunc )
}

void function RemoveEntityCallback_OnGrappled( entity ent, void functionref( entity player, entity hitent, vector hitpos, vector hitNormal ) callbackFunc )
{
	Assert( ent.e.onGrappledCallbacks.contains( callbackFunc ), "Callback " + string( callbackFunc ) + " doesn't exist on entity" )
	ent.e.onGrappledCallbacks.fastremovebyvalue( callbackFunc )
}

void function AddCallback_OnGrappled( void functionref( entity player, entity hitent, vector hitpos, vector hitNormal ) callbackFunc )
{
	Assert( !file.onGrappledCallbacks.contains( callbackFunc ), "Already added " + string( callbackFunc ) )
	file.onGrappledCallbacks.append( callbackFunc )
}

void function RemoveCallback_OnGrappled( void functionref( entity player, entity hitent, vector hitpos, vector hitNormal ) callbackFunc )
{
	Assert( file.onGrappledCallbacks.contains( callbackFunc ), "Callback " + string( callbackFunc ) + " doesn't exist" )
	file.onGrappledCallbacks.fastremovebyvalue( callbackFunc )
}

void function AddCallback_OnGrappleDetached( void functionref( entity player ) callbackFunc )
{
	Assert( !file.onGrappleDetachCallbacks.contains( callbackFunc ), "Already added " + string( callbackFunc ) )
	file.onGrappleDetachCallbacks.append( callbackFunc )
}

void function Grapple_OnPlayerStartBleedout( entity player, entity attacker, var damageInfo )
{
	if ( player.HasGrapple() && player.IsGrappleActive() )
	{
		player.Grapple( <0,0,0> )
	}
}

void function GrappleNPCCallback( entity player, entity hitent, vector hitpos, vector hitNormal )
{
	const enablePlanting = true

	hitent.EndSignal( "OnDestroy" )

	if ( !IsEnemyTeam( hitent.GetTeam(), player.GetTeam() ) )
		return

	if ( hitent.IsNPC() && IsAlive( hitent ) && IsHumanSized( hitent ) )
	{
		//Fix crash if player is using buggy dummie model
		if(player.GetModelName() != $"mdl/humans/class/medium/pilot_medium_generic.rmdl")
			PlayGrappleAttachedAnimation( player, "ptpov_cloudcity_grapple_switch_quick" )

		string ReleaseACT
		if ( hitent.Anim_HasActivity( "ACT_FLINCH_GRAPPLE" ) )
		{
			ReleaseACT = "ACT_FLINCH_GRAPPLE"
		}
		else
		{
			switch ( hitent.GetClassName() )
			{
				case "npc_soldier":
				case "npc_spectre":
					ReleaseACT = "ACT_STUNNED"
					break

				case "npc_stalker":
					ReleaseACT = "ACT_STUNNED"
					break

				case "npc_prowler":
					ReleaseACT = "ACT_SMALL_FLINCH"
					break

				default:
					break
			}
		}

		if ( hitent.IsInterruptable() && ReleaseACT != "" )
		{
			hitent.Anim_ScriptedPlayActivityByName( ReleaseACT, enablePlanting, 0.1 )
			float duration = 2
			StatusEffect_AddTimed( hitent, eStatusEffect.grapple_slow, 1, duration, 0 )
		}

		if ( ReleaseACT == "" )
			player.Grapple( < 0, 0, 0 > )
		vector forceVec = Normalize( player.EyePosition() - hitent.GetCenter() ) // towards the player since we are pulling on the rope
		entity grappleWeapon = player.GetGrappleWeapon()
	}
}

void function EnableGrappleAutoAim( entity npc )
{
	if ( !IsEnemyTeam( npc.GetTeam(), TEAM_MILITIA ) )
		return

	GrappleAutoAim_AddTarget( npc )
}

#endif // SERVER
