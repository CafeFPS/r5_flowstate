global function OnWeaponPrimaryAttack_cloak


var function OnWeaponPrimaryAttack_cloak( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity ownerPlayer = weapon.GetWeaponOwner()

	Assert( IsValid( ownerPlayer) && ownerPlayer.IsPlayer() )

	if ( IsValid( ownerPlayer ) && ownerPlayer.IsPlayer() )
	{
		if ( ownerPlayer.GetCinematicEventFlags() & CE_FLAG_CLASSIC_MP_SPAWNING )
			return false

		if ( ownerPlayer.GetCinematicEventFlags() & CE_FLAG_INTRO )
			return false

		if ( weapon.HasMod( "survival_finite_ordnance" ) )
		{
			entity activeWeapon = ownerPlayer.GetActiveWeapon( weapon.GetWeaponSettingEnum( eWeaponVar.offhand_active_slot, eActiveInventorySlot ) )
			if ( activeWeapon != null && activeWeapon.IsWeaponOffhand() )
				return false
		}
	}

	PlayerUsedOffhand( ownerPlayer, weapon )

	#if SERVER
		float duration = weapon.GetWeaponSettingFloat( eWeaponVar.fire_duration )
		EnableCloak( ownerPlayer, duration )
		#if BATTLECHATTER_ENABLED
			TryPlayWeaponBattleChatterLine( ownerPlayer, weapon )
		#endif
		//ownerPlayer.Signal( "PlayerUsedAbility" )
	#endif

	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_min_to_fire )
}
