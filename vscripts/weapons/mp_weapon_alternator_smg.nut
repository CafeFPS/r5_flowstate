
global function OnWeaponPrimaryAttack_alternator_smg
global function MpWeaponAlternatorSMG_Init

#if SERVER
global function OnWeaponNpcPrimaryAttack_alternator_smg
#endif

#if CLIENT
	global function OnClientAnimEvent_alternator_smg
#endif


const ALTERNATOR_SMG_TRACER_FX = $"weapon_tracers_xo16_speed"

void function MpWeaponAlternatorSMG_Init()
{
	#if CLIENT
		PrecacheParticleSystem( ALTERNATOR_SMG_TRACER_FX )
	#endif
}

var function OnWeaponPrimaryAttack_alternator_smg( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return FireWeaponPlayerAndNPC( weapon, attackParams, true )
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_alternator_smg( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return FireWeaponPlayerAndNPC( weapon, attackParams, false )
}
#endif

int function FireWeaponPlayerAndNPC( entity weapon, WeaponPrimaryAttackParams attackParams, bool playerFired )
{
	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )
	int damageType = weapon.GetWeaponDamageFlags()
	//if ( weapon.HasMod( "burn_mod_lmg" ) )
	//	damageType = damageType | DF_GIB
	//int modulusRemainder = weapon.GetShotCount() % 2
	//entity owner = weapon.GetWeaponOwner()
	//vector right = owner.GetRightVector()
	//array<float> traceOffsets = [ -2.0, 2.0 ]
	//bool useLeftBarrel = ( modulusRemainder == 0 )
	//attackParams.pos = attackParams.pos + (right * traceOffsets[modulusRemainder] )
	weapon.FireWeaponBullet( attackParams.pos, attackParams.dir, 1, damageType )

	return 1
}

#if CLIENT
void function OnClientAnimEvent_alternator_smg( entity weapon, string name )
{
	GlobalClientEventHandler( weapon, name )
}
#endif