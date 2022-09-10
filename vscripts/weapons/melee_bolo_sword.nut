global function MeleeBoloSword_Init

global function OnWeaponActivate_melee_bolo_sword
global function OnWeaponDeactivate_melee_bolo_sword

const EFFECT_BOLO_ATTACK_SWIPE_FP = $"P_xo_punch_spark"

void function MeleeBoloSword_Init()
{
	PrecacheParticleSystem( EFFECT_BOLO_ATTACK_SWIPE_FP )
}

// this weapon is only used for attacks (not "primary weapon" idling onscreen)
// - activate = attack start; deactivate = attack finished
void function OnWeaponActivate_melee_bolo_sword( entity weapon )
{
		//printt( "melee_bolo_sword activated" )

	entity owner = weapon.GetWeaponOwner()

	thread Activate_melee_bolo_sword( weapon, owner )
}

void function Activate_melee_bolo_sword( entity weapon, entity owner )
{
	asset effect1P = EFFECT_BOLO_ATTACK_SWIPE_FP
	wait 0.2
	if ( !IsAlive( owner ) || !IsValid( owner ))
		return

	weapon.PlayWeaponEffect( effect1P, $"", "muzzle_flash" )
}

void function OnWeaponDeactivate_melee_bolo_sword( entity weapon )
{
	//printt( "melee_bolo_sword deactivated" )

	weapon.StopWeaponEffect( EFFECT_BOLO_ATTACK_SWIPE_FP, $"" )
}