global function MpWeaponIncapShield_Init

global function OnWeaponChargeBegin_weapon_incap_shield
global function OnWeaponChargeEnd_weapon_incap_shield
global function OnWeaponOwnerChanged_weapon_incap_shield
global function OnWeaponPrimaryAttack_incap_shield
global function OnWeaponPrimaryAttackAnimEvent_incap_shield
global function OnWeaponDeactivate_incap_shield
global function OnWeaponActivate_incap_shield

#if CLIENT
global function OnCreateChargeEffect_incap_shield
#endif // #if CLIENT

global function IncapShield_GetMaxShieldHealthFromTier

const INCAP_SHIELD_FX_WALL_FP = $"P_down_shield_CP" //$"P_gun_shield_gibraltar_3P" //Should be FP, but Gibraltar Shield FP fx don't color change
const INCAP_SHIELD_FX_WALL = $"P_down_shield_CP" //$"P_gun_shield_gibraltar_3P"
const INCAP_SHIELD_FX_COL = $"mdl/fx/down_shield_01.rmdl" //$"mdl/fx/gibralter_gun_shield.rmdl"
const INCAP_SHIELD_FX_BREAK = $"P_down_shield_break_CP"

const string SOUND_PILOT_INCAP_SHIELD_3P = "BleedOut_Shield_Sustain_3p"
const string SOUND_PILOT_INCAP_SHIELD_1P = "BleedOut_Shield_Sustain_1p"

const string SOUND_PILOT_INCAP_SHIELD_END_3P = "BleedOut_Shield_Break_3P"
const string SOUND_PILOT_INCAP_SHIELD_END_1P = "BleedOut_Shield_Break_1P"

const vector COLOR_SHIELD_TIER4_HIGH = <220, 185, 39>
const vector COLOR_SHIELD_TIER4_MED = <219, 200, 121>
const vector COLOR_SHIELD_TIER4_LOW = <219, 211, 175>

const vector COLOR_SHIELD_TIER3_HIGH = <158, 73, 188>
const vector COLOR_SHIELD_TIER3_MED = <171, 123, 188>
const vector COLOR_SHIELD_TIER3_LOW = <184, 170, 188>

const vector COLOR_SHIELD_TIER2_HIGH = <58, 133, 176>
const vector COLOR_SHIELD_TIER2_MED = <114, 153, 176>
const vector COLOR_SHIELD_TIER2_LOW = <158, 169, 176>

const vector COLOR_SHIELD_TIER1_HIGH = <255, 255, 255>
const vector COLOR_SHIELD_TIER1_MED = <191, 191, 191>
const vector COLOR_SHIELD_TIER1_LOW = <191, 191, 191>


struct
{
#if CLIENT
	var shieldHintRui
#endif // #if CLIENT

	int shieldhealthTier1
	int shieldhealthTier2
	int shieldhealthTier3
} file


void function MpWeaponIncapShield_Init()
{
	PrecacheModel( INCAP_SHIELD_FX_COL )

	PrecacheParticleSystem( INCAP_SHIELD_FX_WALL_FP )
	PrecacheParticleSystem( INCAP_SHIELD_FX_WALL )
	PrecacheParticleSystem( INCAP_SHIELD_FX_BREAK )

	RegisterSignal( "ShieldWeaponThink" )
	RegisterSignal( "DestroyPlayerShield" )

	file.shieldhealthTier1 = GetCurrentPlaylistVarInt( "survival_bleedout_shield_health_tier1", 100 )
	file.shieldhealthTier2 = GetCurrentPlaylistVarInt( "survival_bleedout_shield_health_tier2", 250 )
	file.shieldhealthTier3 = GetCurrentPlaylistVarInt( "survival_bleedout_shield_health_tier3", 750 )
}

bool function OnWeaponChargeBegin_weapon_incap_shield( entity weapon )
{
	entity player = weapon.GetWeaponOwner()

	if ( player.IsPlayer() )
	{
#if SERVER
		PIN_PlayerUse( player, weapon.GetWeaponClassName(), "INCAP_SHIELD" )

		if( !IsValid( weapon.GetWeaponUtilityEntity() ) && !Bleedout_IsReceivingFirstAid( player ) && weapon.GetScriptInt0() > 0 )
			CreateIncapShield( player, weapon )
#endif // #if SERVER
	}

	return true
}

void function OnWeaponChargeEnd_weapon_incap_shield( entity weapon )
{
	weapon.Signal( "OnChargeEnd" )

	foreach( effect in weapon.w.statusEffects )
		StatusEffect_Stop( weapon.GetWeaponOwner(), effect )
}

void function OnWeaponOwnerChanged_weapon_incap_shield( entity weapon, WeaponOwnerChangedParams changeParams )
{
	entity newOwner = weapon.GetWeaponOwner()
	entity oldOwner = changeParams.oldOwner

#if SERVER
	if ( !IsValid( newOwner ) )
		weapon.Destroy()
	else
		weapon.SetScriptInt0( IncapShield_GetMaxShieldHealthFromTier( IncapShield_GetShieldTier( newOwner ) ))
#endif // #if SERVER
}

var function OnWeaponPrimaryAttack_incap_shield( entity weapon, WeaponPrimaryAttackParams attackParams )
{
#if CLIENT
		//Rumble_Play( "rumble_holopilot_activate", {} )
#endif // #if CLIENT

	return 0
}

var function OnWeaponPrimaryAttackAnimEvent_incap_shield( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return 0
}

#if CLIENT
void function OnCreateChargeEffect_incap_shield( entity weapon, int fxHandle )
{
	thread UpdateFirstPersonIncapShieldColor_Thread( weapon, fxHandle )
}

void function UpdateFirstPersonIncapShieldColor_Thread( entity weapon, int fxHandle )
{
	weapon.EndSignal( "OnDestroy" )
	weapon.EndSignal( "OnChargeEnd" )

	entity weaponOwner = weapon.GetOwner()
	weaponOwner.EndSignal( "OnDeath" )
	weaponOwner.EndSignal( "OnDestroy" )

	while ( EffectDoesExist( fxHandle ) )
	{
		float currentHealth = IsValid( weapon ) ? float( weapon.GetScriptInt0() ) : 0.0
		float maxHealth = float( IncapShield_GetMaxShieldHealthFromTier( IncapShield_GetShieldTier( weapon.GetOwner() ) )  )
		float healthFrac = currentHealth / maxHealth
		vector colorVec = GetIncapShieldTriLerpColor( healthFrac, IncapShield_GetShieldTier( GetLocalViewPlayer() ) )

		EffectSetControlPointVector( fxHandle, 2, colorVec )

		WaitFrame()
	}
}
#endif

void function OnWeaponDeactivate_incap_shield( entity weapon )
{
}

void function OnWeaponActivate_incap_shield( entity weapon )
{
}

#if SERVER
void function CreateIncapShield( entity player, entity weapon )
{
	thread IncapShieldThink( player, weapon )
	weapon.w.statusEffects.append( StatusEffect_AddEndless( weapon.GetWeaponOwner(), eStatusEffect.move_slow, 0.65 ) )
}

void function IncapShieldThink( entity player, entity vortexWeapon )
{
	player.EndSignal( "BleedOut_OnReviveStart" )
	vortexWeapon.EndSignal( "OnChargeEnd" )
	vortexWeapon.EndSignal( "OnDestroy" )

	while( true )
	{
		entity utilityEnt = vortexWeapon.GetWeaponUtilityEntity()
		if ( !IsValid( utilityEnt ) )
		{
			if ( vortexWeapon.GetScriptInt0() > 0  )
				thread IncapShieldThread( player, vortexWeapon )
		}
		else
		{
			UpdateIncapShieldFX( utilityEnt, GetShieldHealthFraction( utilityEnt ) )
		}

		WaitFrame()
	}
}

void function IncapShieldThread( entity player, entity weapon )
{
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "BleedOut_OnReviveStart" )
	weapon.EndSignal( "OnDestroy" )
	weapon.EndSignal( "OnChargeEnd" )

	entity shieldEnt = CreateIncapShieldEntity( player, weapon )
	shieldEnt.SetHealth( weapon.GetScriptInt0() )
	shieldEnt.EndSignal( "OnDestroy" )
	weapon.SetWeaponUtilityEntity( shieldEnt )

	UpdateIncapShieldFX( shieldEnt, GetShieldHealthFraction( shieldEnt ) )

	EmitSoundOnEntityExceptToPlayer( player, player, SOUND_PILOT_INCAP_SHIELD_3P )
	EmitSoundOnEntityOnlyToPlayer( player, player, SOUND_PILOT_INCAP_SHIELD_1P )

	OnThreadEnd(
		function () : ( shieldEnt, weapon, player )
		{
			if ( IsValid( player ) )
			{
				StopSoundOnEntity( player, SOUND_PILOT_INCAP_SHIELD_1P )
				StopSoundOnEntity( player, SOUND_PILOT_INCAP_SHIELD_3P )
			}

			if ( IsValid( shieldEnt ) )
			{
				if ( IsValid( shieldEnt.e.shieldWallFX ) )
					EffectStop( shieldEnt.e.shieldWallFX )
				foreach ( fx in shieldEnt.e.fxControlPoints )
					EffectStop( fx )

				weapon.SetScriptInt0( shieldEnt.GetHealth() )
				shieldEnt.Destroy()
			}

			weapon.SetWeaponUtilityEntity( null )
		}
	)

	AddEntityCallback_OnPostDamaged( shieldEnt, IncapShield_OnDamaged )
	WaitForever()
}

void function IncapShield_OnDamaged( entity ent, var damageInfo )
{
	float damage = DamageInfo_GetDamage( damageInfo )
	entity attacker = DamageInfo_GetAttacker( damageInfo )
	vector damageOrigin = DamageInfo_GetDamagePosition( damageInfo )

	if ( damage > 0 )
	{
		if ( attacker.GetTeam() == ent.GetTeam() )
			DamageInfo_SetDamage( damageInfo, 0 )
	}

	damage = DamageInfo_GetDamage( damageInfo )
	if ( damage > 0 )
	{
		if ( IsValid( attacker ) && attacker.IsPlayer() )
			attacker.NotifyDidDamage( ent, 0, damageOrigin, 0, damage, DF_NO_HITBEEP | DAMAGEFLAG_VICTIM_HAS_VORTEX, 0, null, 0 )

		ent.SetHealth( maxint( 0, ent.GetHealth()-int( damage ) ) )

		entity player = ent.GetOwner()
		if ( IsValid( player ) )
		{
			UpdateIncapShieldFX( ent, GetShieldHealthFraction( ent ) )
			player.ViewPunch( damageOrigin, 2.0, 1.0, 1.0 )
		}

		entity weapon = ent.e.ownerWeapon
		if ( IsValid( weapon ) )
			weapon.SetScriptInt0( ent.GetHealth() )

		if ( IsValid( player ) )
		{
			if ( ent.GetHealth() <= 0 )
			{
				weapon.SetScriptInt0( 0 )
				weapon.SetWeaponPrimaryAmmoCount( AMMOSOURCE_STOCKPILE, 0 )
				entity fx = StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( INCAP_SHIELD_FX_BREAK ), player.GetAttachmentOrigin( player.LookupAttachment( "PROPGUN" )), player.GetAttachmentAngles( player.LookupAttachment( "PROPGUN" )) )
				EffectSetControlPointVector( fx, 2, GetIncapShieldTriLerpColor( 1.0, IncapShield_GetShieldTier( player ) ) )
				//EmitSoundOnEntityExceptToPlayer( player, player, SOUND_PILOT_INCAP_SHIELD_3P )
				//EmitSoundOnEntityOnlyToPlayer( player, player, SOUND_PILOT_INCAP_SHIELD_1P )
				ent.Destroy()
			}
		}
	}
}

entity function CreateIncapShieldEntity( entity player, entity vortexWeapon )
{
	vector dir = player.EyeAngles()
	vector forward = AnglesToForward( dir )

	GunShieldSettings gs
	gs.invulnerable = false
	gs.maxHealth = float( IncapShield_GetMaxShieldHealthFromTier( IncapShield_GetShieldTier( player ) ) )
	gs.impacteffectcolorID = IncapShield_GetShieldImpactColorID( player )
	gs.ownerWeapon = vortexWeapon
	gs.owner = player
	gs.shieldFX = INCAP_SHIELD_FX_WALL
	gs.parentEnt = player
	gs.parentAttachment = "PROPGUN"
	gs.useFriendlyEnemyFx = false
	gs.useFxColorOverride = true
	gs.fxColorOverride = GetIncapShieldColorFromInventory( player )
	gs.model = INCAP_SHIELD_FX_COL
	gs.modelHide = true
	gs.modelOverrideAngles = forward // <91, 0, 0>
	gs.fxOverrideAngles = <0, 0, 0>

	entity vortexSphere = CreateGunAttachedShieldModel( gs )
	return vortexSphere
}

void function UpdateIncapShieldFX( entity vortexSphere, float frac )
{
	entity player = vortexSphere.GetOwner()
	int shieldTier = IncapShield_GetShieldTier( player )

	if ( vortexSphere.e.fxControlPoints.len() > 0 )
		UpdateIncapShieldColorForFrac( vortexSphere.e.fxControlPoints, frac, shieldTier )
}

void function UpdateIncapShieldColorForFrac( array<entity> fxArray, float frac, int tier )
{
	vector color = GetIncapShieldTriLerpColor( frac, tier )

	foreach ( fx in fxArray )
	{
		EffectSetControlPointVector( fx, 2, color )
	}
}

vector function GetIncapShieldColorFromInventory( entity player )
{
	int incapShieldTier = IncapShield_GetShieldTier( player )

	switch( incapShieldTier )
	{
		case 4:
			return COLOR_SHIELD_TIER4_HIGH
		case 3:
			return COLOR_SHIELD_TIER3_HIGH
		case 2:
			return COLOR_SHIELD_TIER2_HIGH
		default:
			return COLOR_SHIELD_TIER1_HIGH
	}

	unreachable
}
#endif // #if SERVER

float function GetShieldHealthFraction( entity shieldEnt )
{
	float currentHealth = float( shieldEnt.GetHealth() )
	float maxHealth = float( shieldEnt.GetMaxHealth() )

	return currentHealth / maxHealth
}

vector function GetIncapShieldTriLerpColor( float frac, int tier )
{
	vector color1
	vector color2
	vector color3

	switch( tier )
	{
		case 4:
			color1 = COLOR_SHIELD_TIER4_LOW
			color2 = COLOR_SHIELD_TIER4_MED
			color3 = COLOR_SHIELD_TIER4_HIGH
			break
		case 3:
			color1 = COLOR_SHIELD_TIER3_LOW
			color2 = COLOR_SHIELD_TIER3_MED
			color3 = COLOR_SHIELD_TIER3_HIGH
			break
		case 2:
			color1 = COLOR_SHIELD_TIER2_LOW
			color2 = COLOR_SHIELD_TIER2_MED
			color3 = COLOR_SHIELD_TIER2_HIGH
			break
		default:
			color1 = COLOR_SHIELD_TIER1_LOW
			color2 = COLOR_SHIELD_TIER1_MED
			color3 = COLOR_SHIELD_TIER1_HIGH
	}

	return GetTriLerpColor( frac, color1, color2, color3, 0.55, 0.10 )
}

int function IncapShield_GetShieldTier( entity player )
{
	return EquipmentSlot_GetEquipmentTier( player, "incapshield" )
}

int function IncapShield_GetMaxShieldHealthFromTier( int tier )
{
	switch( tier )
	{
		case 2:
			return file.shieldhealthTier2
		case 3:
		case 4:
			return file.shieldhealthTier3
		default:
			return file.shieldhealthTier1
	}

	unreachable
}

int function IncapShield_GetShieldImpactColorID( entity player )
{
	int shieldTier = IncapShield_GetShieldTier( player )
	return COLORID_FX_LOOT_TIER0 + shieldTier
}