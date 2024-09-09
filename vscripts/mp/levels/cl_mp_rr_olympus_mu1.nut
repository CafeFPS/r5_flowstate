//Script by @CafeFPS

global function ClientCodeCallback_MapInit

struct
{

}
file

void function ClientCodeCallback_MapInit()
{
	MinimapLabelsCloudcity()
	PathTT_Init()
	Olympus_MapInit_Common()
}

void function MinimapLabelsCloudcity()
{
	MapZones_RegisterDataTable( $"datatable/map_zones/zones_mp_rr_olympus_mu1.rpak" )

	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_01_A" ) ), 0.24, 0.39, 0.7 )// OASIS
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_02_B" ) ), 0.28, 0.26, 0.7 )// CARRIER
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_02_A" ) ), 0.37, 0.20, 0.7 )// DOCKS
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_03_A" ) ), 0.50, 0.30, 0.7 )// POWER GRID
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_04_A" ) ), 0.64, 0.26, 0.7 )// RIFT
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_05_A" ) ), 0.44, 0.41, 0.7 )// TURBINE
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_08_A" ) ), 0.59, 0.44, 0.7 )// ENERGY DEPOT
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_09_A" ) ), 0.76, 0.44, 0.7 )// GARDEN
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_07_A" ) ), 0.49, 0.55, 0.7 )// HAMMOND LABS
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_14_B" ) ), 0.77, 0.55, 0.7 )// GROW TOWERS
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_13_C" ) ), 0.57, 0.68, 0.7 )// SOLAR ARRAY
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_15_A" ) ), 0.83, 0.75, 0.7 )// ORBITAL CANNON
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_12_A" ) ), 0.53, 0.88, 0.7 )// BONSAI PLAZA
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_11_A" ) ), 0.18, 0.71, 0.7 )// HYDROPHONCIS
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_10_A" ) ), 0.09, 0.62, 0.7 )// ELYSIUM
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_06_B" ) ), 0.31, 0.52, 0.7 )// ESTATES
}