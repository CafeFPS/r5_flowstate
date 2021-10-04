#if(true)//

global function MpWeaponShadowsquadHandsPrimary_Init

global function OnWeaponActivate_weapon_shadow_squad_hands_primary
global function OnWeaponDeactivate_weapon_shadow_squad_hands_primary


const asset SHADOWHANDS_FX_GLOW_FP = $"P_wpn_bhaxe_gas_glow_FP"
const asset SHADOWHANDS_FX_GLOW_3P = $"P_wpn_bhaxe_gas_glow_3P"


void function MpWeaponShadowsquadHandsPrimary_Init()
{

	PrecacheParticleSystem( SHADOWHANDS_FX_GLOW_FP )
	PrecacheParticleSystem( SHADOWHANDS_FX_GLOW_3P )

}

void function OnWeaponActivate_weapon_shadow_squad_hands_primary( entity weapon )
{
	//
	//
}

void function OnWeaponDeactivate_weapon_shadow_squad_hands_primary( entity weapon )
{
	//
	//

}

#endif //