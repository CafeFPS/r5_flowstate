global function OnWeaponChargeBegin_ability_heal
global function OnWeaponPrimaryAttack_ability_heal
global function OnWeaponChargeEnd_ability_heal
global function OnWeaponAttemptOffhandSwitch_ability_heal

bool function OnWeaponChargeBegin_ability_heal( entity weapon )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	float duration     = weapon.GetWeaponSettingFloat( eWeaponVar.charge_time )
	StimPlayerWithOffhandWeapon( ownerPlayer, duration, weapon )

	weapon.EmitWeaponSound_1p3p( "octane_stimpack_loop_1P", "octane_stimpack_loop_3P" )
	PlayerUsedOffhand( ownerPlayer, weapon )
	thread StimSounds(weapon)
	//Rumble_Play( "rumble_stim_activate", {} )
	return true
}

void function StimSounds( entity weapon )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	wait 4
	if ( !IsValid( weapon ) )
		return
	weapon.EmitWeaponSound_1p3p( "octane_stimpack_deactivate_1P", "octane_stimpack_deactivate_3P" )
}

void function OnWeaponChargeEnd_ability_heal( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
}


var function OnWeaponPrimaryAttack_ability_heal( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity player = weapon.GetWeaponOwner()

	//wait 3
	//weapon.EmitWeaponSound_1p3p( "Octane_Stim_DeActivateWarning", "Octane_Stim_DeActivateWarning_3p" )
	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
}


bool function OnWeaponAttemptOffhandSwitch_ability_heal( entity weapon )
{
	entity player = weapon.GetWeaponOwner()

	if ( !IsValid( player ) )
		return false

	if ( !player.IsPlayer() )
		return false

	return true
}