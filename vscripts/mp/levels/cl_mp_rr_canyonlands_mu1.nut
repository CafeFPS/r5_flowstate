global function ClientCodeCallback_MapInit
global function MinimapLabelsCanyonlandsMU1

struct
{
	bool teaseDronePropSpawned = false
	entity teasePointLight
	entity teaseSpotLight
}
file

void function ClientCodeCallback_MapInit()
{
	#if MP_PVEMODE
		CL_CanyonlandsPVE_MapInit()
	#else
		Canyonlands_MapInit_Common()
		MapZones_RegisterDataTable( $"datatable/map_zones/zones_mp_rr_canyonlands_mu1.rpak" )
		MinimapLabelsCanyonlandsMU1()
		AddTargetNameCreateCallback( "leviathan_staging", OnLeviathanMarkerCreated )
		AddTargetNameCreateCallback( "leviathan_zone_6", AddAirdropTraceIgnoreEnt )
		AddTargetNameCreateCallback( "leviathan_zone_9", AddAirdropTraceIgnoreEnt )
	#endif
	RegisterSignal( "RoarStop" ) //needed for anim callbacks in not-yet-shipped DFS scripts
	AddCallback_GameStateEnter( eGameState.WinnerDetermined, MU1_OnWinnerDetermined )

	AddCreateCallback( "prop_dynamic", OnTeaseDronePropSpawned )
	AddCallback_EntitiesDidLoad( EntitiesDidLoad )
}

void function EntitiesDidLoad()
{
	array<entity> pointLightArr = GetEntArrayByScriptName( "tvtease_pointlight_01" )
	array<entity> spotLightArr = GetEntArrayByScriptName( "tvtease_spotlight_01" )

	if ( pointLightArr.len() == 0 || spotLightArr.len() == 0 )
	{
		Warning( "!!! Warning !!! No tease tweak lights found!" )
		return
	}

	file.teasePointLight = pointLightArr.top()
	file.teaseSpotLight = spotLightArr.top()

	if ( GetCurrentPlaylistVarInt( "wtt_side_room_active", 0 ) == 1 )
		thread Thread_TweakLightFlicker()
	else
		thread Thread_TurnOffTweakLights()
}

void function MinimapLabelsCanyonlandsMU1()
{
	//SWAMPLAND
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_02_A" ) ), 0.93, 0.5, 0.6 ) //Swamps

	//INDUSTRIAL
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_04_A" ) ), 0.79, 0.62, 0.6 ) //Hydro Dam
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_03_B" ) ), 0.81, 0.51, 0.6 ) //Labs
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
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_09_A" ) ), 0.4, 0.3, 0.6 ) //"Containment"
	//SURVIVAL_AddMinimapLevelLabel( "River Town 2", 0.41, 0.49, 0.5 )
	//SURVIVAL_AddMinimapLevelLabel( "River Town 3", 0.62, 0.78, 0.5 )
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_06_A" ) ), 0.66, 0.53, 0.6 ) //"The Cage"
	//SURVIVAL_AddMinimapLevelLabel( "Waterfall Town", 0.28, 0.12, 0.5 )

	//SLUM
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_12_A" ) ), 0.16, 0.23, 0.6 )//"Slum Lakes"
	//SURVIVAL_AddMinimapLevelLabel( "Hilltop Town", 0.22, 0.51, 0.4 )
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_16_MALL" ) ), 0.49, 0.68, 0.6 ) //"Market"
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_16_SKULLTOWN" ) ), 0.32, 0.74, 0.6 )//"Skull Town"
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_18_A" ) ), 0.16, 0.7, 0.6 )//"Gauntlet"
	//SURVIVAL_AddMinimapLevelLabel( "Pitstop", 0.35, 0.63, 0.4 )
	//SURVIVAL_AddMinimapLevelLabel( "Scorch City", 0.32, 0.9, 0.4 )

	// Tease
	ModelFX_BeginData( "thrusters_tease_foe", $"mdl/props/crypto_drone/crypto_drone.rmdl", "foe", false )
		ModelFX_AddTagSpawnFX( "handle_t_fx", $"P_drone_exhaust_T" )
		ModelFX_AddTagSpawnFX( "frame_b_fx", $"P_drone_exhaust_B" )
		ModelFX_AddTagSpawnFX( "arm_l_fx", $"P_drone_exhaust_L" )
		ModelFX_AddTagSpawnFX( "arm_r_fx", $"P_drone_exhaust_R" )
		//ModelFX_AddTagSpawnFX( "__illumPosition", $"P_crypto_drone_shield" )
		ModelFX_AddTagSpawnFX( "LENS", $"P_drone_camera" )
	ModelFX_EndData()
}


void function OnLeviathanMarkerCreated( entity marker )
{
	string markerTargetName = marker.GetTargetName()
	entity leviathan = CreateClientSidePropDynamic( marker.GetOrigin(), marker.GetAngles(), MU1_LEVIATHAN_MODEL )
	bool stagingOnly = markerTargetName == "leviathan_staging"

	thread LeviathanThink( marker, leviathan, stagingOnly )
}

void function LeviathanThink( entity marker, entity leviathan, bool stagingOnly )
{
	marker.EndSignal( "OnDestroy" )
	leviathan.EndSignal( "OnDestroy" )

	OnThreadEnd(
		function () : ( leviathan )
		{
			if ( IsValid( leviathan ) )
			{
				leviathan.Destroy()
			}
		}
	)

	leviathan.Anim_Play( "ACT_IDLE"  )
	leviathan.SetCycle( RandomFloat(1.0 ) )

	WaitForever()
}


void function MU1_OnWinnerDetermined()
{
	array<entity> portalFXArray = GetEntArrayByScriptName( "wraith_tt_portal_fx" )

	if ( portalFXArray.len() == 0 )
	{
		Warning( "Warning! Incorrect number of portal FX entities found for destruction!" )
		return
	}

	foreach( entity fx in portalFXArray )
		fx.Destroy()
}

void function OnTeaseDronePropSpawned( entity prop )
{
	if ( file.teaseDronePropSpawned )
		return

	if ( prop.GetScriptName() != "tease_drone_prop_01" )
		return

	ModelFX_EnableGroup( prop, "thrusters_tease_foe" )
	file.teaseDronePropSpawned = true

	thread Thread_TurnOffTweakLights()
}

void function Thread_TweakLightFlicker()
{
	float origPointLightBrightness = 0.25
	float origSpotLightBrightness = 0.3

	bool lightsOn = true

	// Make sure to leave lights in default on state
	OnThreadEnd(
		function() : ( origPointLightBrightness, origSpotLightBrightness )
		{
			file.teasePointLight.SetTweakLightBrightness( origPointLightBrightness )
			file.teaseSpotLight.SetTweakLightBrightness( origSpotLightBrightness )
		}
	)

	while ( !file.teaseDronePropSpawned )
	{
		wait RandomFloatRange( 0.5, 4 )

		file.teasePointLight.SetTweakLightBrightness( origPointLightBrightness * RandomFloatRange( 0.3, 1.2 ) )
		file.teaseSpotLight.SetTweakLightBrightness( origSpotLightBrightness * RandomFloatRange( 0.3, 1.2 )  )
	}
}

void function Thread_TurnOffTweakLights()
{
	wait 4.8

	file.teasePointLight.SetTweakLightBrightness( 0.05 )
	file.teaseSpotLight.SetTweakLightBrightness( 0.0 )
}