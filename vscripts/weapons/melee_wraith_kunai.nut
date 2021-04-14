global function MeleeWraithKunai_Init

global function OnWeaponActivate_melee_wraith_kunai
global function OnWeaponDeactivate_melee_wraith_kunai

const EFFECT_KUNAI_ATTACK_SWIPE_FP = $"P_kunai_attack_swipe_edge_FP"
const EFFECT_KUNAI_ATTACK_SWIPE_3P = $"P_kunai_attack_swipe_edge_3P"
const EFFECT_KUNAI_ATTACK_STAB_FP = $"P_kunai_attack_stab_FP"
const EFFECT_KUNAI_ATTACK_STAB_3P = $"P_kunai_attack_stab_3P"

void function MeleeWraithKunai_Init()
{
	PrecacheParticleSystem( EFFECT_KUNAI_ATTACK_SWIPE_FP )
	PrecacheParticleSystem( EFFECT_KUNAI_ATTACK_SWIPE_3P )
	PrecacheParticleSystem( EFFECT_KUNAI_ATTACK_STAB_FP )
	PrecacheParticleSystem( EFFECT_KUNAI_ATTACK_STAB_3P )
}

// this weapon is only used for attacks (not "primary weapon" idling onscreen)
// - activate = attack start; deactivate = attack finished
void function OnWeaponActivate_melee_wraith_kunai( entity weapon )
{
	//printt( "melee_wraith_kunai activated" )

	entity owner = weapon.GetWeaponOwner()

	if ( !IsAlive( owner ) )
		return

	// NOTE: Kunai currently still uses default attack anims for jumping and sliding
	if ( !owner.IsOnGround() || owner.IsSliding() )
		return

	// standing. walking, crouching
	asset effect1P = EFFECT_KUNAI_ATTACK_SWIPE_FP
	asset effect3P = EFFECT_KUNAI_ATTACK_SWIPE_3P

	// sprinting
	if ( owner.IsSprinting() )
	{
		effect1P = EFFECT_KUNAI_ATTACK_STAB_FP
		effect3P = EFFECT_KUNAI_ATTACK_STAB_3P
	}

	weapon.PlayWeaponEffect( effect1P, effect3P, "knife_base" )
}

void function OnWeaponDeactivate_melee_wraith_kunai( entity weapon )
{
	//printt( "melee_wraith_kunai deactivated" )

	weapon.StopWeaponEffect( EFFECT_KUNAI_ATTACK_SWIPE_FP, EFFECT_KUNAI_ATTACK_SWIPE_3P )
	weapon.StopWeaponEffect( EFFECT_KUNAI_ATTACK_STAB_FP, EFFECT_KUNAI_ATTACK_STAB_3P )
}
