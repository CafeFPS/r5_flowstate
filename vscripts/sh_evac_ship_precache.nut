global function ShPrecacheEvacShipAssets

void function ShPrecacheEvacShipAssets()
{
	#if SERVER
		const asset ICON_DROPSHIP_EVAC          = $"rui/hud/common/evac_location_friendly"
		const asset FX_EVAC_FLARE               = $"P_road_flare"
		const asset FX_EVAC_RING_LIGHT_GREEN    = $"runway_light_green"
		const asset FX_EVAC_RING_LIGHT_RED      = $"runway_light_red"
		const asset FX_EVAC_SHIP_BEACON_PENDING = $"P_lootcache_far_beam"
		const asset FX_EVAC_SHIP_BEACON_ARRIVED = $"P_lootcache_far_beam" //need different beam for when ship has arrived

		PrecacheParticleSystem( FX_EVAC_FLARE )
		PrecacheParticleSystem( FX_EVAC_RING_LIGHT_GREEN )
		PrecacheParticleSystem( FX_EVAC_RING_LIGHT_RED )
		PrecacheParticleSystem( FX_EVAC_SHIP_BEACON_PENDING )
		PrecacheParticleSystem( FX_EVAC_SHIP_BEACON_ARRIVED )
	#endif
}
