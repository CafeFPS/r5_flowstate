//By @CafeFPS and Respawn

global function OnWeaponStartZoomIn_weapon_titan_sword
global function OnWeaponStartZoomOut_weapon_titan_sword

global function MpWeaponTitanSword_Block_Init
global function TitanSword_Block_OnWeaponActivate
global function TitanSword_Block_ClearMods

global function TitanSword_Block_PlayerIsBlocking
global function TitanSword_Block_IsBlocking


const string TITAN_SWORD_BLOCK_MOD = "blocking"

const string SIG_TITAN_SWORD_BLOCK_DEACTIVATE = "TitanSword_DeactivateBlock"

// const asset VFX_TITAN_SWORD_BLOCK = $"P_xo_sword_block"
// const asset VFX_TITAN_SWORD_BLOCK_HIT_1P = $"P_xo_sword_block_hit"
const asset VFX_TITAN_SWORD_BLOCK_HIT_3P = $"P_impact_shieldbreaker_sparks"
// const asset VFX_TITAN_SWORD_BLOCK_BULLET_HIT = $"P_pilot_sword_block_bullet"
// const asset VFX_TITAN_SWORD_BLOCK_SWORD_HIT = $"P_pilot_sword_block_sword"

const string SFX_TITAN_SWORD_BLOCK_DAMAGE = "titansword_block_bullet_impacts_1p"

struct
{
}file

void function MpWeaponTitanSword_Block_Init()
{
	#if CLIENT
	PrecacheParticleSystem( VFX_TITAN_SWORD_BLOCK_HIT_3P )
	RegisterNetworkedVariableChangeCallback_bool( "isPlayerBlocking", OnPlayerBlockingStateChanged )
	#endif

	#if SERVER
	AddDamageFinalCallback( "player", TitanSword_Blocking_OnDamage )
	#endif
}

void function OnWeaponStartZoomIn_weapon_titan_sword( entity weapon )
{
	entity player = weapon.GetWeaponOwner()

	#if SERVER
	player.SetPlayerNetBool( "isPlayerBlocking", true )
	weapon.StartCustomActivity("ACT_VM_JUMP", 0)
	entity vm = weapon.GetWeaponViewmodel()
	if( IsValid( vm ) )
		try{
			vm.Anim_PlayOnly("animseq/weapons/bloodhound_axe/ptpov_axe_bloodhound/idle_crouch.rseq")
		}catch(e420){}
	#endif
}

void function OnWeaponStartZoomOut_weapon_titan_sword( entity weapon )
{
	entity player = weapon.GetWeaponOwner()

	#if SERVER
	player.SetPlayerNetBool( "isPlayerBlocking", false )
	if( weapon.IsInCustomActivity() )
		weapon.StopCustomActivity()
	entity vm = weapon.GetWeaponViewmodel()
	if( IsValid( vm ) )
		vm.Anim_Stop()
	#endif
}

void function TitanSword_Block_OnWeaponActivate( entity player, entity weapon )
{
	#if SERVER



	#endif
}

#if CLIENT
void function OnPlayerBlockingStateChanged( entity player, bool old, bool new, bool actuallyChanged )
{
	if ( player != GetLocalClientPlayer() )
		return

	if( !actuallyChanged )
		return
	
	if( !old && new )
		printt( "FS Titan Sword - Started blocking" )
	else if( old && !new )
		printt( "FS Titan Sword - Stopped blocking" )
}
#endif

void function TitanSword_Block_ClearMods( entity weapon )
{
}

bool function TitanSword_Block_PlayerIsBlocking( entity player )
{
	if ( !player.IsPlayer() )
		return false

	entity weapon = TitanSword_GetMainWeapon( player )
	if ( IsValid( weapon ) )
		return TitanSword_Block_IsBlocking( weapon )

	return false
}

bool function TitanSword_Block_IsBlocking( entity weapon )
{
	return weapon.IsWeaponInAds()
}

#if SERVER
void function IncrementChargeBlockAnim( entity blockingEnt, var damageInfo )
{
	entity weapon = blockingEnt.GetActiveWeapon( eActiveInventorySlot.mainHand )
	if ( !IsValid( weapon ) )
		return
	if ( !weapon.IsChargeWeapon() )
		return

	int oldIdx = weapon.GetChargeAnimIndex()
	int newIdx = RandomInt( CHARGE_ACTIVITY_ANIM_COUNT )
	if ( oldIdx == newIdx )
		oldIdx = ((oldIdx + 1) % CHARGE_ACTIVITY_ANIM_COUNT)
	weapon.SetChargeAnimIndex( newIdx )
}

const float melee_block_scale_back = 0.85 // reduce 15% of the damage incoming from the back without super
const float melee_block_scale_front = 0.15 // reduce 85% of the damage incoming from the back without super

const float melee_block_scale_super_back = 0.70 // reduce 30% of the damage incoming from the back with super
const float melee_block_scale_super_front = 0.05 // reduce 95% of the damage incoming from the back with super

float function HandleBlockingAndCalcDamageScaleForHit( entity blockingEnt, var damageInfo )
{
	entity weapon = blockingEnt.GetActiveWeapon( eActiveInventorySlot.mainHand )
	if ( !IsValid( weapon ) )
	{
		// printt( "swordblock: no valid activeweapon" )
		return 1.0
	}

	vector origin = GetDamageOrigin( damageInfo, blockingEnt )
	
	if( FS_TitanSword_IsVictimFacingAttacker( blockingEnt, origin ) && TitanSword_Super_IsActive( blockingEnt ) )
	{
		return melee_block_scale_super_front
	} else if( !FS_TitanSword_IsVictimFacingAttacker( blockingEnt, origin ) && TitanSword_Super_IsActive( blockingEnt ) )
	{
		return melee_block_scale_super_back
	} else if( FS_TitanSword_IsVictimFacingAttacker( blockingEnt, origin ) && !TitanSword_Super_IsActive( blockingEnt ) )
	{
		return melee_block_scale_front
	} else if( !FS_TitanSword_IsVictimFacingAttacker( blockingEnt, origin ) && !TitanSword_Super_IsActive( blockingEnt ) )
	{
		return melee_block_scale_back
	}

	return melee_block_scale_front
}

void function TitanSword_Blocking_OnDamage( entity blockingEnt, var damageInfo )
{
	if ( !IsValid( blockingEnt ) ||  !blockingEnt.GetPlayerNetBool( "isPlayerBlocking" ) )
		return

	float damageScale = HandleBlockingAndCalcDamageScaleForHit( blockingEnt, damageInfo )

	// printt( "TitanSword_Blocking_OnDamage - DamageScale: ", damageScale )

	if ( damageScale == 1.0 )
		return

	// IncrementChargeBlockAnim( blockingEnt, damageInfo )
	EmitSoundOnEntity( blockingEnt, "weapon_doubletake_ricochet_3p" )
	if ( blockingEnt.IsPlayer() )
	{
		blockingEnt.RumbleEffect( 1, 0, 0 )
	}

	StartParticleEffectInWorldWithControlPoint( GetParticleSystemIndex( VFX_TITAN_SWORD_BLOCK_HIT_3P ), DamageInfo_GetDamagePosition( damageInfo ) + blockingEnt.GetPlayerOrNPCViewVector()*15, VectorToAngles( blockingEnt.GetPlayerOrNPCViewVector() ) + <90,0,0>, <255,255,255> )

	// DamageInfo_SetDamage( damageInfo, ceil( ( DamageInfo_GetDamage( damageInfo ) + 0.5 ) * damageScale ) )
	DamageInfo_ScaleDamage( damageInfo, damageScale )
}

bool function FS_TitanSword_IsVictimFacingAttacker( entity victim, vector damageOrigin, int viewAngle = 85 ) // find actual viewAngle limit in retail Titan Sword
{
	vector dir = damageOrigin - victim.GetOrigin()
	dir = Normalize( dir )
	float dot = DotProduct( victim.GetPlayerOrNPCViewVector(), dir )
	float yaw = DotToAngle( dot )

	return ( yaw < viewAngle )
}
#endif