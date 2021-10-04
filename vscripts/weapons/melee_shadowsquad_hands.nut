#if(true)//

global function MeleeShadowsquadHands_Init

global function OnWeaponActivate_melee_shadowsquad_hands
global function OnWeaponDeactivate_melee_shadowsquad_hands

const SHADOWHANDS_FX_ATTACK_SWIPE_FP = $"P_wpn_bhaxe_swipe_FP"
const SHADOWHANDS_FX_ATTACK_SWIPE_3P = $"P_wpn_bhaxe_swipe_3P"

void function MeleeShadowsquadHands_Init()
{
	PrecacheParticleSystem( SHADOWHANDS_FX_ATTACK_SWIPE_FP )
	PrecacheParticleSystem( SHADOWHANDS_FX_ATTACK_SWIPE_3P )
}

//
//
void function OnWeaponActivate_melee_shadowsquad_hands( entity weapon )
{
	//
	//
}

void function OnWeaponDeactivate_melee_shadowsquad_hands( entity weapon )
{
	//
	//

}

#endif //