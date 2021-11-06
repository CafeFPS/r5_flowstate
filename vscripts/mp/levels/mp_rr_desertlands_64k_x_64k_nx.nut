#if SERVER
global function CodeCallback_MapInit
#endif //SERVER

#if SERVER
void function CodeCallback_MapInit()
{
	SharedInit()
	Desertlands_MapInit_Common()
}
#endif //SERVER

#if CLIENT
void function ClientCodeCallback_MapInit()
{
	SharedInit()
	SURVIVAL_AddCallback_OnDeathFieldStopShrink( OnDeathFieldStopShrink_ShadowSquad)
}
#endif //CLIENT

void function SharedInit()
{
	ShPrecacheShadowSquadAssets()
	ShPrecacheEvacShipAssets()
	//ShLootCreeps_Init() // Assets only exists in "mp_rr_canyonlands_mu1_night.rpak"
}

void function OnDeathFieldStopShrink_ShadowSquad( DeathFieldStageData deathFieldData )
{
	//LootCreepGarbageCollect() // Assets only exists in "mp_rr_canyonlands_mu1_night.rpak"
}
