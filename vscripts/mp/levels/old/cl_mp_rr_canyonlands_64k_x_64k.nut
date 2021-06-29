global function ClientCodeCallback_MapInit

void function ClientCodeCallback_MapInit()
{
	Canyonlands_MapInit_Common()
	MapZones_RegisterDataTable( $"datatable/map_zones/zones_mp_rr_canyonlands_64k_x_64k.rpak" )

//SWAMPLAND
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_02_A" ) ), 0.93, 0.5, 0.6 ) //Swamps

//INDUSTRIAL
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_04_A" ) ), 0.79, 0.62, 0.6 ) //Hydro Dam
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_11_A" ) ), 0.56, 0.91, 0.6 ) //Water Treatment
	//SURVIVAL_AddMinimapLevelLabel( "Windmills", 0.46, 0.77, 0.4 )
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_14_RUNOFF" ) ), 0.13, 0.40, 0.6 ) //Runoff

//UNIQUE
	//SURVIVAL_AddMinimapLevelLabel( "No Man's Land", 0.77, 0.44, 0.4 )
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_13_ARENA" ) ), 0.24, 0.32, 0.6 ) //The Pit
	//SURVIVAL_AddMinimapLevelLabel( "Arena", 0.24, 0.3, 0.5 )
	//SURVIVAL_AddMinimapLevelLabel(  GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "JCT_08_10_16" ) ), 0.51, 0.62, 0.4 )//Caves
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_17_DOME" ) ), 0.22, 0.85, 0.6 )//Thunderdome

//MILITARY
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_04_B" ) ), 0.78, 0.74, 0.6 ) //Repulsor
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_08_ARTILLERY" ) ), 0.54, 0.15, 0.6 ) //Artillery
	//SURVIVAL_AddMinimapLevelLabel( "Fort West", 0.48, 0.21, 0.4 )
	//SURVIVAL_AddMinimapLevelLabel( "Fort East", 0.68, 0.77, 0.4 )
	//SURVIVAL_AddMinimapLevelLabel( "Tower Mid", 0.61, 0.56, 0.4 )
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_15_AIRBASE" ) ), 0.13, 0.56, 0.6 ) //Airbase
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "JCT_10_13" ) ), 0.34, 0.45, 0.6 ) //Bunker Pass
	//SURVIVAL_AddMinimapLevelLabel( "Passthrough", 0.74, 0.61, 0.4 )

//COLONY
	//SURVIVAL_AddMinimapLevelLabel( "Compound North", 0.84, 0.49, 0.4 )
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_01_A" ) ), 0.81, 0.22, 0.6 ) //Relay
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_01_B" ) ), 0.78, 0.32, 0.6 ) //Wetlands
	//SURVIVAL_AddMinimapLevelLabel( "Convoy", 0.65, 0.3, 0.4 )
	//SURVIVAL_AddMinimapLevelLabel( "Parachute Field", 0.61, 0.28, 0.4 )
	//SURVIVAL_AddMinimapLevelLabel( "River Colony", 0.4, 0.32, 0.4 )

//LAGOON
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_09_A" ) ), 0.47, 0.34, 0.6 ) //"Cascades"
	//SURVIVAL_AddMinimapLevelLabel( "River Town 2", 0.41, 0.49, 0.5 )
	//SURVIVAL_AddMinimapLevelLabel( "River Town 3", 0.62, 0.78, 0.5 )
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_06_A" ) ), 0.57, 0.56, 0.6 ) //"Bridges"
	//SURVIVAL_AddMinimapLevelLabel( "Waterfall Town", 0.28, 0.12, 0.5 )

//SLUM
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_12_A" ) ), 0.16, 0.23, 0.6 )//"Slum Lakes"
	//SURVIVAL_AddMinimapLevelLabel( "Hilltop Town", 0.22, 0.51, 0.4 )
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_16_MALL" ) ), 0.49, 0.68, 0.6 ) //"Market"
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_16_SKULLTOWN" ) ), 0.32, 0.74, 0.6 )//"Skull Town"
	//SURVIVAL_AddMinimapLevelLabel( "Pitstop", 0.35, 0.63, 0.4 )
	//SURVIVAL_AddMinimapLevelLabel( "Scorch City", 0.32, 0.9, 0.4 )
}