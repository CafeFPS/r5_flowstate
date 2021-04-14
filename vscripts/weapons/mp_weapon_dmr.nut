untyped

global function MpWeaponDmr_Init

global function OnWeaponActivate_weapon_dmr
global function OnWeaponDeactivate_weapon_dmr

#if CLIENT
global function OnClientAnimEvent_weapon_dmr
#endif // #if CLIENT


void function MpWeaponDmr_Init()
{
	DMRPrecache()
}

void function DMRPrecache()
{
	PrecacheParticleSystem( $"wpn_mflash_snp_hmn_smoke_side_FP" )
	PrecacheParticleSystem( $"wpn_mflash_snp_hmn_smoke_side" )
}

void function OnWeaponActivate_weapon_dmr( entity weapon )
{
	if ( !( "zoomTimeIn" in weapon.s ) )
		weapon.s.zoomTimeIn <- weapon.GetWeaponSettingFloat( eWeaponVar.zoom_time_in )

	#if CLIENT
		if ( weapon.GetWeaponOwner() != GetLocalViewPlayer() )
			return
	#endif
}

void function OnWeaponDeactivate_weapon_dmr( entity weapon )
{
}

#if CLIENT
void function OnClientAnimEvent_weapon_dmr( entity weapon, string name )
{
	GlobalClientEventHandler( weapon, name )

	if ( name == "muzzle_flash" )
	{
		if ( IsOwnerViewPlayerFullyADSed( weapon ) )
			return
		if ( !weapon.HasMod( "silencer" ) )
		{
			weapon.PlayWeaponEffect( $"wpn_mflash_snp_hmn_smoke_side_FP", $"wpn_mflash_snp_hmn_smoke_side", "muzzle_flash_L" )
			weapon.PlayWeaponEffect( $"wpn_mflash_snp_hmn_smoke_side_FP", $"wpn_mflash_snp_hmn_smoke_side", "muzzle_flash_R" )
		}
	}

	if ( name == "shell_eject" )
	{
		thread DelayedCasingsSound( weapon, 0.6 )
	}
}
#endif // #if CLIENT

void function DelayedCasingsSound( entity weapon, float delayTime )
{
	Wait( delayTime )

	if ( !IsValid( weapon ) )
		return

	weapon.EmitWeaponSound( "large_shell_drop" )
}
