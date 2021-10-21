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
} file

const int GRAPPLEFLAG_CHARGED	= (1<<0)
const int CHANCE_TO_COMMENT_GRAPPLE = 33

void function GrappleWeaponInit()
{
	file.grappleExplodeImpactTable = PrecacheImpactEffectTable( "exp_rocket_archer" )

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

	// clear "charged-up" flag:
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
		return weapon.GetWeaponSettingInt( eWeaponVar.ammo_min_to_fire )
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
#endif //

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

		if ( grappleWeapon.HasMod( "survival_finite_ordnance" ) )
		{
			int newAmmo = maxint( 0, grappleWeapon.GetWeaponPrimaryClipCount() - grappleWeapon.GetWeaponSettingInt( eWeaponVar.ammo_min_to_fire ) )
			grappleWeapon.SetWeaponPrimaryClipCount( newAmmo )
		}

		int flags = grappleWeapon.GetScriptFlags0()
		if ( ! (flags & GRAPPLEFLAG_CHARGED) )
			return

		int expDamage = grappleWeapon.GetWeaponSettingInt( eWeaponVar.explosion_damage )
		if ( expDamage <= 0 )
			return

		DoGrappleImpactExplosion( player, grappleWeapon, hitent, hitpos, hitNormal )
	}
}

void function CodeCallback_OnGrappleDetach( entity player )
{
	#if SERVER
		// Added via AddCallback_OnGrappleDetached
		foreach ( callbackFunc in file.onGrappleDetachCallbacks )
		{
			thread callbackFunc( player )
		}
		
		entity grappleWeapon = player.GetOffhandWeapon( OFFHAND_LEFT )
		if ( !IsValid( grappleWeapon ) )
			return
		if ( !grappleWeapon.GetWeaponSettingBool( eWeaponVar.grapple_weapon ) )
			return
		
		float reloadTime = float(grappleWeapon.GetWeaponSettingInt( eWeaponVar.ammo_min_to_fire )) / 10

		// If last grapple time was longer than cooldown, then reload tactical as grapple missed any object
		if (Time() - grappleWeapon.e.lastGrappleTime >= reloadTime) {
			int max = grappleWeapon.GetWeaponPrimaryClipCountMax()
			grappleWeapon.SetWeaponPrimaryClipCount( max )
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
	const GRAPPLE_DAMAGE = 100
	const enablePlanting = true

	hitent.EndSignal( "OnDestroy" )

	if ( !IsEnemyTeam( hitent.GetTeam(), player.GetTeam() ) )
		return

	if ( hitent.IsNPC() && IsAlive( hitent ) && IsHumanSized( hitent ) )
	{
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
		hitent.TakeDamage( GRAPPLE_DAMAGE, player, null, { force = forceVec, weapon = grappleWeapon } )
	}
}

void function EnableGrappleAutoAim( entity npc )
{
	if ( !IsEnemyTeam( npc.GetTeam(), TEAM_MILITIA ) )
		return

	GrappleAutoAim_AddTarget( npc )
}

#endif // SERVER
