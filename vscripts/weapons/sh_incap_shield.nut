global function ShIncapShield_Init


global function GetIncapShieldTriLerpColor
global function IncapShield_GetShieldTier
global function IncapShield_GetMaxShieldHealthFromTier
global function IncapShield_GetShieldImpactColorID

#if SERVER
global function UpdateIncapShieldFX
global function UpdateIncapShieldColorForFrac
global function GetIncapShieldColorFromInventory
global function IncapShield_SetShieldEntCollision

#endif

#if CLIENT
global function UpdateFirstPersonIncapShieldColor_Thread
#endif

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
	int shieldhealthTier1
	int shieldhealthTier2
	int shieldhealthTier3

} file


void function ShIncapShield_Init()
{

	file.shieldhealthTier1 = GetCurrentPlaylistVarInt( "survival_bleedout_shield_health_tier1", 200 )
	file.shieldhealthTier2 = GetCurrentPlaylistVarInt( "survival_bleedout_shield_health_tier2", 450 )
	file.shieldhealthTier3 = GetCurrentPlaylistVarInt( "survival_bleedout_shield_health_tier3", 750 )

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
		case 0:
			return 0
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


#if SERVER
void function UpdateIncapShieldFX( entity shieldEnt, float frac )
{
	entity player = shieldEnt.GetOwner()
	int shieldTier = IncapShield_GetShieldTier( player )

	if ( shieldEnt.e.fxControlPoints.len() > 0 )
		UpdateIncapShieldColorForFrac( shieldEnt.e.fxControlPoints, frac, shieldTier )
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


#if CLIENT

void function UpdateFirstPersonIncapShieldColor_Thread( entity weapon, int fxHandle, asset fxShieldAsset ) //todo: Confirm I can feed the particle ASSET for each KD shield type in here
{
	weapon.EndSignal( "OnDestroy" )
	weapon.EndSignal( "OnChargeEnd" )

	entity weaponOwner = weapon.GetOwner()
	weaponOwner.EndSignal( "OnDeath" )
	weaponOwner.EndSignal( "OnDestroy" )

	int weaponEffect = fxHandle
	while ( true )
	{
		if ( !EffectDoesExist( weaponEffect ) )
		{
			//We manually play the effect in situations where the player gets the OnWeaponCharged callback but the FX are not actually made (such as if they're holding the trigger down while returning to first person) - ChadA
			weaponEffect = weapon.PlayWeaponEffectReturnViewEffectHandle( fxShieldAsset, fxShieldAsset, "muzzle_flash" )
		}

		entity player = weapon.GetOwner()
		float currentHealth = IsValid( weapon ) ? float( weapon.GetScriptInt0() ) : 0.0
		float maxHealth = float( IncapShield_GetMaxShieldHealthFromTier( IncapShield_GetShieldTier( player ) )  )
		float healthFrac = maxHealth > 0 ? ( currentHealth / maxHealth ) : 0.0
		vector colorVec = GetIncapShieldTriLerpColor( healthFrac, IncapShield_GetShieldTier( player ) )

		EffectSetControlPointVector( weaponEffect, 2, colorVec )

		if ( player.ContextAction_IsReviving() || player.ContextAction_IsBeingRevived() )
		{
			weapon.StopWeaponEffect( fxShieldAsset, fxShieldAsset )
			break
		}

		if ( currentHealth <= 0 )
		{
			weapon.StopWeaponEffect( fxShieldAsset, fxShieldAsset )
			break
		}

		//Bugfix R5DEV-502111 - weapon.EndSignal( "OnChargeEnd" ) is not hitting on spectators.
		if ( weaponOwner != GetLocalClientPlayer() && !weapon.IsWeaponCharging() )
		{
			weapon.StopWeaponEffect( fxShieldAsset, fxShieldAsset )
			break
		}

		WaitFrame()
	}
}
#endif // #if CLIENT

#if SERVER
void function IncapShield_SetShieldEntCollision( entity shieldEnt, bool collisionEnabled )
{
	if ( collisionEnabled )
		shieldEnt.SetCollisionAllowed( true )
	else
		shieldEnt.SetCollisionAllowed( false )
}
#endif // #if SERVER