global function ClientCodeCallback_MapInit

const JUMP_PAD_LAUNCH_SOUND_1P = "Geyser_LaunchPlayer_1p"

void function ClientCodeCallback_MapInit()
{
	DesertlandsTrainAnnouncer_Init()
	ClLaserMesh_Init()
	Desertlands_MapInit_Common()
	MapZones_RegisterDataTable( $"datatable/map_zones/zones_mp_rr_desertlands_64k_x_64k.rpak")

	AddCreateCallback( "trigger_cylinder_heavy", Geyser_OnJumpPadCreated )
	//New zones
	SURVIVAL_AddMinimapLevelLabel( "#DES_ZONE_6_FRAGMENT_WEST", 0.52, 0.40, 0.5 )
	SURVIVAL_AddMinimapLevelLabel( "#DES_ZONE_6_FRAGMENT_EAST", 0.66, 0.44, 0.5 )
	SURVIVAL_AddMinimapLevelLabel( "#DES_ZONE_3_SURVEY", 0.59, 0.20, 0.5 )
	SURVIVAL_AddMinimapLevelLabel( "#DES_ZONE_9_HARVESTER", 0.52, 0.60, 0.5 )
	
	//Old Zones
	SURVIVAL_AddMinimapLevelLabel( "#DES_ZONE_11_THERMAL_STATION", 0.28, 0.73, 0.5 )
	SURVIVAL_AddMinimapLevelLabel( "#DES_ZONE_7_SNOW_FIELD", 0.85, 0.40, 0.5 )
	SURVIVAL_AddMinimapLevelLabel( "#DES_ZONE_2_CAP_CITY", 0.35, 0.22, 0.5 )
	SURVIVAL_AddMinimapLevelLabel( "#DES_ZONE_15_LAVA_CITY", 0.80, 0.80, 0.5 )
	SURVIVAL_AddMinimapLevelLabel( "#DES_ZONE_5_LAVA_FISSURE", 0.18, 0.43, 0.5 )
	SURVIVAL_AddMinimapLevelLabel( "#DES_ZONE_4_BURIED_REFINERY", 0.72, 0.19, 0.5 )
	SURVIVAL_AddMinimapLevelLabel( "#DES_ZONE_4_GROUND_ZERO", 0.63, 0.30, 0.5 )
	SURVIVAL_AddMinimapLevelLabel( "#DES_ZONE_10_RESEARCH_STATION_BRAVO", 0.77, 0.60, 0.5 )
	SURVIVAL_AddMinimapLevelLabel( "#DES_ZONE_12_RESEARCH_STATION_ALPHA", 0.41, 0.84, 0.5 )
	SURVIVAL_AddMinimapLevelLabel( "#DES_ZONE_16_MT", 0.72, 0.92, 0.5 )
	SURVIVAL_AddMinimapLevelLabel( "#DES_ZONE_5_TRAINYARD", 0.36, 0.46, 0.5 )
	SURVIVAL_AddMinimapLevelLabel( "#DES_ZONE_13_REFINERY", 0.57, 0.74, 0.5 )
	SURVIVAL_AddMinimapLevelLabel( "#DES_ZONE_1_DRILL_SITE", 0.29, 0.35, 0.5 )

	//TownTakerover Zones
	SURVIVAL_AddMinimapLevelLabel( "#DES_ZONE_8_MIRAGE", 0.23, 0.54, 0.5 )

}

void function Geyser_OnJumpPadCreated( entity trigger )
{
	if ( trigger.GetTriggerType() != TT_JUMP_PAD )
		return

	if ( trigger.GetTargetName() != "geyser_trigger" )
		return

	trigger.SetClientEnterCallback( Geyser_OnJumpPadAreaEnter )
}

void function Geyser_OnJumpPadAreaEnter( entity trigger, entity player )
{
	entity localViewPlayer = GetLocalViewPlayer()
	if ( player != localViewPlayer )
		return

	if ( !IsPilot( player ) )
		return

	if ( trigger.GetTargetName() != "geyser_trigger" )
		return

	EmitSoundOnEntity( player, JUMP_PAD_LAUNCH_SOUND_1P )
	EmitSoundOnEntity( player, "JumpPad_Ascent_Windrush" )
}
