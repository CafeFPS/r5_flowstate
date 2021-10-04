//=========================================================
//	sh_loot_rollers.nut
//=========================================================

global function ShLootRollers_Init
global function IsLootRoller

#if CLIENT
global function ServerCallback_SetLootRollerLootTierFX
global function ServerCallback_StopLootRollerFX
#endif // CLIENT


//////////////////////
//////////////////////
//// Global Types ////
//////////////////////
//////////////////////
global const asset LOOT_ROLLER_MODEL              = $"mdl/props/loot_sphere/loot_sphere.rmdl"
global const asset LOOT_ROLLER_EYE_FX             = $"P_loot_ball_flash_CP"
global const int NUM_LOOT_ROLLER_FX_ATTACH_POINTS = 12
global const string FX_ATTACH_ROOT_NAME           = "fx_glow_"
global const asset FX_LOOT_ROLLER_EXPLOSION       = $"P_ball_tick_exp_CP"


///////////////////////
///////////////////////
//// Private Types ////
///////////////////////
///////////////////////
#if CLIENT
struct LootRollerClientData
{
	entity rollerModel
	array<int> eyeFXEnts
	int lootTier = 1
	bool hasVaultKey
}
#endif

struct
{
	array< entity > allLootRollers
	//

	table< entity, array< void functionref( entity, var ) > > Callbacks_OnLootRollerDamaged
	table< entity, array< void functionref( entity, var ) > > Callbacks_OnLootRollerKilled

	#if CLIENT
		table<entity, LootRollerClientData> rollerToClientData
	#endif
} file


////////////////////////
////////////////////////
//// Initialization ////
////////////////////////
////////////////////////
void function ShLootRollers_Init()
{
	#if SERVER
	AddSpawnCallback( "prop_physics", LootRollerSpawned )
	AddSpawnCallback( "prop_dynamic", LootRollerSpawned )
  #endif

	#if CLIENT
	AddCreateCallback( "prop_physics", LootRollerSpawned )
	AddCreateCallback( "prop_dynamic", LootRollerSpawned )
	#endif
}


/////////////////////////
/////////////////////////
//// Internals       ////
/////////////////////////
/////////////////////////
void function LootRollerSpawned( entity ent )
{
	if ( ent.GetModelName().tolower() != LOOT_ROLLER_MODEL.tolower() )
		return

	file.allLootRollers.append( ent )

	#if SERVER

	#endif

	#if CLIENT
	LootRollerClientData data
	data.rollerModel = ent

	int fxIdx = GetParticleSystemIndex( LOOT_ROLLER_EYE_FX )
	for( int i; i < NUM_LOOT_ROLLER_FX_ATTACH_POINTS; i++ )
	{
		int suffixIdx = i + 1
		string attachSuffix = string( suffixIdx )

		int attachIdx = ent.LookupAttachment( FX_ATTACH_ROOT_NAME + attachSuffix )
		int newFx = StartParticleEffectOnEntity( ent, fxIdx, FX_PATTACH_POINT_FOLLOW, attachIdx )
		data.eyeFXEnts.append( newFx )
		EffectSetControlPointColorById( newFx, 1, COLORID_FX_LOOT_TIER0 + data.lootTier )
	}

	if ( data.hasVaultKey && data.eyeFXEnts.len() > 0 )
	{
		int randEye = data.eyeFXEnts[ RandomInt( data.eyeFXEnts.len() - 1 ) ]
		EffectSetControlPointColorById( randEye, 1, COLORID_FX_LOOT_TIER0 + 5 )
	}

	SetLootRollerClientData( data )
	#endif
}

void function OnLootRollerDamaged( entity roller, var damageInfo )
{
	int health = roller.GetHealth()
	float damage = DamageInfo_GetDamage( damageInfo )
	int remainingHealth = (health - int(damage))
	if( remainingHealth <= 0 )
	{
		#if CLIENT
		LootRollerClientData clientData = GetLootRollerClientDataFromEnt( roller )

		foreach( eye in clientData.eyeFXEnts )
		{
			EffectStop( eye, false, true )
		}
		#endif // CLIENT
	}
}

bool function IsLootRoller( entity ent )
{
	return file.allLootRollers.contains( ent )
}

#if CLIENT
void function SetLootRollerClientData( LootRollerClientData data )
{
	entity roller = data.rollerModel

	if ( roller in file.rollerToClientData )
		return

	file.rollerToClientData[ roller ] <- data
}

LootRollerClientData function GetLootRollerClientDataFromEnt( entity ent )
{
	Assert( ent in file.rollerToClientData, "Attempted to get Loot Roller Client data from a roller that's not in the table!" )

	return file.rollerToClientData[ ent ]
}


//////////////////////////
//////////////////////////
//// Global functions ////
//////////////////////////
//////////////////////////
void function ServerCallback_SetLootRollerLootTierFX( int rollerHandle, int tier, bool hasVaultKey )
{
	entity roller = GetEntityFromEncodedEHandle( rollerHandle )

	if ( !IsValid( roller ) )
		return

	vector tierColor = GetFXRarityColorForTier( tier )
	string tierColorString = format("%f %f %f", tierColor.x, tierColor.y, tierColor.z )
	roller.kv.rendercolor = tierColorString

	LootRollerClientData rollerData = GetLootRollerClientDataFromEnt( roller )
	rollerData.lootTier = tier
	rollerData.hasVaultKey = hasVaultKey

	foreach (fx in rollerData.eyeFXEnts )
	{
		EffectSetControlPointColorById( fx, 1, COLORID_FX_LOOT_TIER0 + rollerData.lootTier )
	}

	int fxCount = GetCurrentPlaylistVarInt( "loot_rollers_vault_key_fx_hints", 1 )

	if ( fxCount > 0 && rollerData.hasVaultKey && rollerData.eyeFXEnts.len() > 0 )
	{
		array<int> randomEyes
		int eyeCount = rollerData.eyeFXEnts.len()
		fxCount = minint( fxCount, eyeCount )
		for ( int i = 0; i < fxCount; i++ )
		{
			int randomIdx = RandomInt( rollerData.eyeFXEnts.len() - 1 )
			randomEyes.append( randomIdx )
		}

		foreach ( idx in randomEyes )
		{
			int randEye = rollerData.eyeFXEnts[ idx ]
			EffectSetControlPointColorById( randEye, 1, COLORID_FX_LOOT_TIER0 + 5 )
		}
	}
}

void function ServerCallback_StopLootRollerFX( int rollerHandle )
{
	entity roller = GetEntityFromEncodedEHandle( rollerHandle )

	if ( !IsValid( roller ) )
		return

	LootRollerClientData rollerData = GetLootRollerClientDataFromEnt( roller )
	foreach ( fx in rollerData.eyeFXEnts )
		EffectStop( fx, false, true )
}
#endif // CLIENT
