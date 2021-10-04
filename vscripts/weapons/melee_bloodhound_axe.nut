#if(true)//

global function MeleeBloodhoundAxe_Init

global function OnWeaponActivate_melee_bloodhound_axe
global function OnWeaponDeactivate_melee_bloodhound_axe

const AXE_FX_ATTACK_SWIPE_FP = $"P_wpn_bhaxe_swipe_FP"
const AXE_FX_ATTACK_SWIPE_3P = $"P_wpn_bhaxe_swipe_3P"

void function MeleeBloodhoundAxe_Init()
{
	PrecacheParticleSystem( AXE_FX_ATTACK_SWIPE_FP )
	PrecacheParticleSystem( AXE_FX_ATTACK_SWIPE_3P )
}

//
//
void function OnWeaponActivate_melee_bloodhound_axe( entity weapon )
{
	//
	weapon.PlayWeaponEffect( AXE_FX_ATTACK_SWIPE_FP, AXE_FX_ATTACK_SWIPE_3P, "FX_CROW_MOUTH" )
}

void function OnWeaponDeactivate_melee_bloodhound_axe( entity weapon )
{
	//
	weapon.StopWeaponEffect( AXE_FX_ATTACK_SWIPE_FP, AXE_FX_ATTACK_SWIPE_3P )

}

#endif //