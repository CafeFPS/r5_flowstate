global function OnWeaponPrimaryAttack_cloak


var function OnWeaponPrimaryAttack_cloak( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity ownerPlayer = weapon.GetWeaponOwner()

	if( !IsValid( ownerPlayer ) || !ownerPlayer.IsPlayer() )
		return

	PlayerUsedOffhand( ownerPlayer, weapon )

	#if SERVER
		float duration = weapon.GetWeaponSettingFloat( eWeaponVar.fire_duration )
		EnableCloak( ownerPlayer, 2.0 )

		thread(void function() : ( ownerPlayer )
		{
			while( IsValid( ownerPlayer ) && IsCloaked( ownerPlayer ) )
			{
				if( ownerPlayer.GetVelocity() != <0,0,0> && IsCloaked( ownerPlayer ) )
					ownerPlayer.SetCloakFlicker( 0.5, 0.1 )

				WaitFrame()
			}
		}())

		#if BATTLECHATTER_ENABLED
			TryPlayWeaponBattleChatterLine( ownerPlayer, weapon )
		#endif
		//ownerPlayer.Signal( "PlayerUsedAbility" )
	#endif

	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_min_to_fire )
}
