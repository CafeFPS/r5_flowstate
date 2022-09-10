#if SERVER
global function CodeCallback_MapInit
#endif //SERVER

#if SERVER
void function CodeCallback_MapInit()
{
	if ( IsFallLTM() )
	{
		SharedInit()
		SURVIVAL_AddCallback_OnDeathFieldStopShrink( OnDeathFieldStopShrink_ShadowSquad )
	}
	Desertlands_MapInit_Common()
}
#endif //SERVER

#if CLIENT
void function ClientCodeCallback_MapInit()
{
	if ( IsFallLTM() )
		SharedInit()
}
#endif //CLIENT

void function SharedInit()
{
	ShPrecacheShadowSquadAssets()
	ShPrecacheEvacShipAssets()
	ShLootCreeps_Init()
}

#if SERVER
void function OnDeathFieldStopShrink_ShadowSquad( DeathFieldData deathFieldData )
{
	LootCreepGarbageCollect()
}
#endif //SERVER