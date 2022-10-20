global function MpWeaponPoloSwordPrimary_Init

global function OnWeaponActivate_melee_bolo_sword_primary
global function OnWeaponDeactivate_melee_bolo_sword_primary

const asset SWORD_FX_GLOW = $"P_bFlare_glow_FP"

void function MpWeaponPoloSwordPrimary_Init()
{
	PrecacheParticleSystem( SWORD_FX_GLOW )
}

void function OnWeaponActivate_melee_bolo_sword_primary( entity weapon )
{
	weapon.PlayWeaponEffect( SWORD_FX_GLOW, $"", "muzzle_flash" )
}

void function OnWeaponDeactivate_melee_bolo_sword_primary( entity weapon )
{
	weapon.StopWeaponEffect( SWORD_FX_GLOW, $"" )
}
