global function MpAbilityMirageUltimate_Init
global function OnWeaponChargeBegin_ability_mirage_ultimate
global function OnWeaponChargeEnd_ability_mirage_ultimate
global function OnWeaponAttemptOffhandSwitch_ability_mirage_ultimate

struct
{
	#if CLIENT
	var cancelHintRui
	#endif
} file

void function MpAbilityMirageUltimate_Init()
{
	RegisterSignal( "CancelCloak" )
	#if CLIENT
	StatusEffect_RegisterEnabledCallback( eStatusEffect.mirage_ultimate_cancel_hint, CancelHint_OnCreate )
	StatusEffect_RegisterDisabledCallback( eStatusEffect.mirage_ultimate_cancel_hint, CancelHint_OnDestroy )
	#endif
}

#if CLIENT
void function CancelHint_OnCreate( entity player, int statusEffect, bool actuallyChanged )
{
	if ( player != GetLocalViewPlayer() )
		return

	file.cancelHintRui = CreateFullscreenRui( $"ui/mirage_ultimate_cancel_hint.rpak" )
}

void function CancelHint_OnDestroy( entity player, int statusEffect, bool actuallyChanged )
{
	if ( player != GetLocalViewPlayer() )
		return

	RuiDestroyIfAlive( file.cancelHintRui )
	file.cancelHintRui = null
}
#endif // CLIENT

bool function OnWeaponAttemptOffhandSwitch_ability_mirage_ultimate( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	if ( !IsValid( player ) )
		return false
		
	if ( player.IsPhaseShifted() )
		return false

	if ( !PlayerCanUseDecoy( player ) )
		return false

	return true
}

var function OnWeaponPrimaryAttack_mirage_ultimate( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	var ammoToReturn = OnWeaponPrimaryAttack_holopilot( weapon, attackParams )

	return ammoToReturn
}

void function MirageUltimateCancelCloak( entity player )
{
	player.Signal( "CancelCloak")
}

void function OnWeaponChargeEnd_ability_mirage_ultimate( entity weapon )
{
	entity player = weapon.GetWeaponOwner()
	if ( !IsValid( player ) )
		return

	if ( weapon.GetWeaponChargeFraction() < 1 )
	{
		MirageUltimateCancelCloak( player )
		return
	}

	if ( weapon.GetWeaponPrimaryClipCount() == 0 )                                                                                                          
		return

	weapon.SetWeaponPrimaryClipCount( 0 )
	WeaponPrimaryAttackParams attackParams
	OnWeaponPrimaryAttack_mirage_ultimate( weapon, attackParams )
}

#if SERVER
void function HolsterAndDisableWeaponsMirageUltimate( entity ownerPlayer )
{
	ownerPlayer.EndSignal( "OnDestroy" )
	ownerPlayer.EndSignal( "OnDeath" )
	ownerPlayer.EndSignal( "OnSyncedMelee" )
	ownerPlayer.EndSignal( "BleedOut_OnStartDying" )
	ownerPlayer.EndSignal( "CancelCloak" )

	foreach( weapon in SURVIVAL_GetPrimaryWeaponsSorted( ownerPlayer ) )
		if( IsValid( weapon ) )
			weapon.AllowUse( false )
		
	OnThreadEnd(
	function() : ( ownerPlayer )
		{
			if ( IsValid( ownerPlayer ) )
			{
				foreach( weapon in SURVIVAL_GetPrimaryWeaponsSorted( ownerPlayer ) )
					if( IsValid( weapon ) )
						weapon.AllowUse( true )
			}
		}
	)

	wait 1
}

void function MirageUltCloakThink( entity ownerPlayer )
{
	ownerPlayer.EndSignal( "OnDestroy" )
	ownerPlayer.EndSignal( "OnDeath" )
	ownerPlayer.EndSignal( "OnSyncedMelee" )
	ownerPlayer.EndSignal( "BleedOut_OnStartDying" )
	ownerPlayer.EndSignal( "CancelCloak" )
	
	EnableCloak( ownerPlayer, 1 )

	int statusId = 	StatusEffect_AddTimed( ownerPlayer, eStatusEffect.speed_boost, 0.15, 1, 0.5 )
	OnThreadEnd(
	function() : ( ownerPlayer, statusId )
		{
			if ( IsValid( ownerPlayer ) )
			{
				if ( IsCloaked( ownerPlayer ) )
					DisableCloak( ownerPlayer, 0.0 )
				
				StatusEffect_Stop( ownerPlayer, statusId )
			}
		}
	)
	
	wait 1
}
#endif

bool function OnWeaponChargeBegin_ability_mirage_ultimate( entity weapon )
{
	weapon.EmitWeaponSound_1p3p( "Mirage_Vanish_Activate_1P", "Mirage_Vanish_Activate_3P" )
	entity ownerPlayer = weapon.GetWeaponOwner()

	if( !IsValid( ownerPlayer ) || !ownerPlayer.IsPlayer() )
		return false

	PlayerUsedOffhand( ownerPlayer, weapon, true )
	#if SERVER
	ItemFlavor character = LoadoutSlot_GetItemFlavor( ToEHI( ownerPlayer ), Loadout_CharacterClass() )
	string charRef = ItemFlavor_GetHumanReadableRef( character )

	if( charRef == "character_mirage")	
		PlayBattleChatterLineToSpeakerAndTeam( ownerPlayer, "bc_super" )
	
	thread MirageUltCloakThink( ownerPlayer )
	thread HolsterAndDisableWeaponsMirageUltimate( weapon.GetWeaponOwner() )
	#endif
	return true
}