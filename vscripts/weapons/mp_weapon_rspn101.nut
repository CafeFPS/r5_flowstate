global function OnWeaponActivate_R101
global function OnWeaponDeactivate_R101

//--------------------------------------------------
// R101 MAIN
//--------------------------------------------------

void function OnWeaponActivate_R101( entity weapon )
{
	OnWeaponActivate_weapon_basic_bolt( weapon )

	OnWeaponActivate_RUIColorSchemeOverrides( weapon )
	OnWeaponActivate_ReactiveKillEffects( weapon )
}

void function OnWeaponDeactivate_R101( entity weapon )
{
	OnWeaponDeactivate_ReactiveKillEffects( weapon )
}
