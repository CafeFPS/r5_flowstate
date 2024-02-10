//By @CafeFPS and Respawn

global function MpWeaponTitanSword_Heavy_Init
global function TitanSword_Heavy_OnWeaponActivate
global function TitanSword_Heavy_ClearMods
global function TitanSword_Heavy_TryHeavyAttack
global function TitanSword_TryMultiAttack

global function GetPlayerMeleeOffhandWeapon

global const string TITAN_SWORD_HEAVY_MOD = "heavy_melee"
global const string TITAN_SWORD_HEAVY_SUPER_MOD = "super_melee"

const bool TITAN_SWORD_LOS_DEBUG = false
const bool DEBUG_MULTI_HIT = false

const float TITAN_SWORD_HEAVY_ATTACK_DISTANCE = 150
const float TITAN_SWORD_HEAVY_ATTACK_ANGLE_HORIZONTAL = 89.9
const float TITAN_SWORD_HEAVY_ATTACK_ANGLE_VERTICAL = 30

const float TITAN_SWORD_INSTRUCTIONS_DEBOUNCE_TIME = 10

const TITAN_SWORD_FX_HEAVY_ATK_FP = $"P_pilot_sword_swipe_heavy_FP"
const TITAN_SWORD_FX_HEAVY_ATK_3P = $"P_pilot_sword_swipe_heavy_3P"

struct
{
}file

void function MpWeaponTitanSword_Heavy_Init()
{
	// PrecacheParticleSystem( TITAN_SWORD_FX_HEAVY_ATK_FP )
	// PrecacheParticleSystem( TITAN_SWORD_FX_HEAVY_ATK_3P )
}

// void function TitanSword_Heavy_StartVFX( entity weapon )
// {
	// weapon.PlayWeaponEffect( TITAN_SWORD_FX_HEAVY_ATK_FP, TITAN_SWORD_FX_HEAVY_ATK_3P, "blade_turn" )
// }

// void function TitanSword_Heavy_StopVFX( entity weapon )
// {
	// weapon.StopWeaponEffect( TITAN_SWORD_FX_HEAVY_ATK_FP, TITAN_SWORD_FX_HEAVY_ATK_3P )
// }

void function TitanSword_Heavy_OnWeaponActivate( entity player, entity weapon )
{
	#if SERVER


	#endif
}

void function TitanSword_Heavy_ClearMods( entity weapon )
{
	if( !IsValid( weapon ) )
		return

	weapon.RemoveMod( TITAN_SWORD_HEAVY_MOD )

	// TitanSword_Heavy_StopVFX( weapon )
}


bool function TitanSword_Heavy_TryHeavyAttack( entity player, entity weapon )
{
	#if CLIENT
		if ( !InPrediction() )
			return false
	#endif
	
	TitanSword_SafelyAddAttackMod( weapon, TITAN_SWORD_HEAVY_MOD )
	TitanSword_SafelyAddAttackMod( GetPlayerMeleeOffhandWeapon( player ), TITAN_SWORD_HEAVY_MOD )

	if ( TitanSword_Super_IsActive( player ) )
		weapon.AddMod( TITAN_SWORD_HEAVY_SUPER_MOD )

	entity melee = GetPlayerMeleeOffhandWeapon( player )
	
	if(IsValid( melee ) && TitanSword_Super_IsActive( player ) )
		melee.AddMod( TITAN_SWORD_HEAVY_SUPER_MOD )
		
	// TitanSword_Heavy_StartVFX( weapon )
	return true
}

//By @CafeFPS
bool function TitanSword_TryMultiAttack( entity attacker, entity weapon )
{
	if ( !weapon.HasMod( TITAN_SWORD_HEAVY_MOD ) )
		return false
	
	attacker.p.targetsForAoeDamage.clear()

	entity melee = GetPlayerMeleeOffhandWeapon( attacker )
	vector attackpos 	= attacker.ShipHack_PositionBetweenEyes() // attacker.EyePosition() // attacker.CameraPosition()
	vector attackdir 	= attacker.CameraAngles()
	
	if( !IsValid( melee ) )
		return false

	array<entity> ignoredEntities = [ attacker, weapon, melee ]

	int traceMask 				= TRACE_MASK_SHOT | TRACE_MASK_VISIBLE_AND_NPCS
	int flags					= VIS_CONE_ENTS_TEST_HITBOXES
	entity antilagPlayer		= null
	if ( attacker.IsPlayer() )
	{
		antilagPlayer = attacker
	}
	
	printt( "Getting AOE heavy attack targets.." )
	float distance = TITAN_SWORD_HEAVY_ATTACK_DISTANCE

	// array<VisibleEntityInCone> hitList = FindVisibleEntitiesInCone( attackpos, attackdir, distance, TITAN_SWORD_HEAVY_ATTACK_ANGLE_HORIZONTAL, ignoredEntities, traceMask, flags, antilagPlayer, weapon ) // Not realiable

	// array< entity > hitList
	// entity ent = Entities_FindInSphere( null, attacker.GetOrigin(), TITAN_SWORD_HEAVY_ATTACK_DISTANCE ) //Expensive
	// for ( ;; )
	// {
		// if ( ent == null )
			// break

		// hitList.append( ent )

		// ent = Entities_FindInSphere( ent, < 0, 0, 0 >, TITAN_SWORD_HEAVY_ATTACK_DISTANCE )
	// }

	array<entity> hitList = GetPlayerArray() //Expensive
	hitList.extend( GetNPCArray() )
	hitList.extend( GetAllPropDoors() )

	TraceResults traceResult

	foreach( target in hitList )
	{
		if( !IsValid( target ) || !target.IsPlayer() && !target.IsNPC() && !IsDoor( target ) || !IsAlive( target ) && !IsDoor( target ) || target == attacker )
			continue

		//Don't trigger on phase shifted targets.
		if ( target.IsPhaseShifted() )
			continue

		//Don't trigger on cloaked targets.
		if ( IsCloaked( target ) )
			continue

		//Don't trigger on titans
		if ( target.IsTitan() )
			continue

		if ( !target.DoesShareRealms( attacker ) )
			continue

		if( Distance( attacker.GetOrigin(), target.GetOrigin() ) > distance )
			continue

		if( DegreesToTarget( attackpos, AnglesToForward( attackdir ), target.GetOrigin() ) > TITAN_SWORD_HEAVY_ATTACK_ANGLE_HORIZONTAL )
			continue

		if( DegreesToTarget( attackpos, AnglesToUp( attackdir ), target.GetOrigin() ) > 145 || DegreesToTarget( attackpos, AnglesToUp( attackdir ), target.GetOrigin() ) <= 85 ) //30 - TITAN_SWORD_HEAVY_ATTACK_ANGLE_VERTICAL
			continue
		
		traceResult = TraceLine( attackpos, attackpos + ( Normalize( target.GetWorldSpaceCenter() - attackpos ) * TITAN_SWORD_HEAVY_ATTACK_DISTANCE ), [ attacker, weapon ], TRACE_MASK_PLAYERSOLID | TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_NONE )

		VisibleEntityInCone target1
		target1.ent = target
		vector visiblePosition = target.GetOrigin()
		
		bool LOS = IsValid( traceResult.hitEnt ) && target == traceResult.hitEnt
		
		#if DEVELOPER
		// DebugDrawLine( attackpos, traceResult.endPos, 0, 255, 0, true, 1 )
		// printt( "/////////////////////////" )
		// printt( "- Detected AOE target: ", target )
		// printt( "- Horizontal Angle: ", DegreesToTarget( attackpos, AnglesToForward( attackdir ), target.GetOrigin() ) )
		// printt( "- Vertical Angle: ", DegreesToTarget( attackpos, AnglesToUp( attackdir ), target.GetOrigin() ) )
		// printt( "- LOS Check: ", LOS )
		// printt( "/////////////////////////" )
		#endif
		
		// if( !LOS )
			// continue
	
		attacker.p.targetsForAoeDamage.append( target1 )
	}

	return hitList.len() > 0
}

bool function Updated_IsValidMeleeAttackTarget( entity attacker, entity target )
{
	entity meleeInputWeapon  = null 
	entity meleeAttackWeapon = GetPlayerMeleeOffhandWeapon( attacker )

	if ( !IsValidMeleeAttackTarget( attacker, meleeInputWeapon, meleeAttackWeapon, target ) )
		return false

	return true
}

entity function GetPlayerMeleeOffhandWeapon( entity player )
{
	array<entity> wpns = player.GetOffhandWeapons()
	entity main
	foreach( wpn in wpns )
	{
		if( wpn.GetWeaponClassName() == "melee_titan_sword" && wpn.IsWeaponMelee() )
			main = wpn
	}
	return main
}


void function TitanSword_OnMultiAttackHit( entity attacker, table attackInfo, entity meleeAttackWeapon, int impactTableOverride )
{
	Melee_Attack( attacker, meleeAttackWeapon, attackInfo ) 
}