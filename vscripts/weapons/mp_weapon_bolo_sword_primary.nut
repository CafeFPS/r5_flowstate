global function MpWeaponPoloSwordPrimary_Init

global function OnWeaponActivate_melee_bolo_sword_primary
global function OnWeaponDeactivate_melee_bolo_sword_primary

const asset SWORD_FX_GLOW_FP = $"P_wpn_bhaxe_gas_glow_FP"
const asset SWORD_FX_GLOW_3P = $"P_wpn_bhaxe_gas_glow_3P"

void function MpWeaponPoloSwordPrimary_Init()
{
	PrecacheParticleSystem( SWORD_FX_GLOW_FP )
	PrecacheParticleSystem( SWORD_FX_GLOW_3P )
}

void function OnWeaponActivate_melee_bolo_sword_primary( entity weapon )
{
	weapon.PlayWeaponEffect( SWORD_FX_GLOW_FP, $"", "muzzle_flash" )
}

void function OnWeaponDeactivate_melee_bolo_sword_primary( entity weapon )
{
	weapon.StopWeaponEffect( SWORD_FX_GLOW_FP, SWORD_FX_GLOW_3P )
}
