global function MpWeaponBloodhoundAxePrimary_Init

global function OnWeaponActivate_weapon_bloodhound_axe_primary
global function OnWeaponDeactivate_weapon_bloodhound_axe_primary


const asset AXE_FX_GLOW_FP = $"P_wpn_bhaxe_gas_glow_FP"
const asset AXE_FX_GLOW_3P = $"P_wpn_bhaxe_gas_glow_3P"


void function MpWeaponBloodhoundAxePrimary_Init()
{

	PrecacheParticleSystem( AXE_FX_GLOW_FP )
	PrecacheParticleSystem( AXE_FX_GLOW_3P )

}

void function OnWeaponActivate_weapon_bloodhound_axe_primary( entity weapon )
{
	//
	weapon.PlayWeaponEffect( AXE_FX_GLOW_FP, AXE_FX_GLOW_3P, "FX_CROW_MOUTH", true )
}

void function OnWeaponDeactivate_weapon_bloodhound_axe_primary( entity weapon )
{
	//
	weapon.StopWeaponEffect( AXE_FX_GLOW_FP, AXE_FX_GLOW_3P )

}
