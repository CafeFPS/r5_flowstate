global function MpWeaponWraithKunaiPrimary_Init

global function OnWeaponActivate_weapon_wraith_kunai_primary
global function OnWeaponDeactivate_weapon_wraith_kunai_primary

const asset KUNAI_FX_GLOW_FP = $"P_kunai_idle_FP"
const asset KUNAI_FX_GLOW_3P = $"P_kunai_idle_3P"

void function MpWeaponWraithKunaiPrimary_Init()
{
	PrecacheParticleSystem( KUNAI_FX_GLOW_FP )
	PrecacheParticleSystem( KUNAI_FX_GLOW_3P )
}

void function OnWeaponActivate_weapon_wraith_kunai_primary( entity weapon )
{
	//printt( "mp_weapon_wraith_kunai_primary activated" )

	weapon.PlayWeaponEffect( KUNAI_FX_GLOW_FP, KUNAI_FX_GLOW_3P, "knife_base" )
}

void function OnWeaponDeactivate_weapon_wraith_kunai_primary( entity weapon )
{
	//printt( "mp_weapon_wraith_kunai_primary deactivated" )

	weapon.StopWeaponEffect( KUNAI_FX_GLOW_FP, KUNAI_FX_GLOW_3P )
}