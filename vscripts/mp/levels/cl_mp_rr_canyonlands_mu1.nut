global function ClientCodeCallback_MapInit
global function MinimapLabelsCanyonlandsMU1

//#if HAS_HALLOWEEN
	const asset FX_LEVIATHAN_EYE_GLOW = $"draconis_coolant_glow" //P_wpn_meteor_exp_trail //env_star_red_dwarf //draconis_coolant_glow //P_tday_draconis_side_coolant //P_wpn_arcball_trail
	const asset FX_LEVIATHAN_FIRE = $"shipFire_LG_fire_loop_LG_1" // //fire_loop_main_XL //P_ship_fire_large //shipFire_LG_fire_loop_LG_1
	const asset FX_LEVIATHAN_FIRE_END = $"P_ship_fire_large" // //fire_loop_main_XL //P_ship_fire_large //shipFire_LG_fire_loop_LG_1
//#endif

struct
{

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
		//AddTargetNameCreateCallback( "leviathan_zone_6", AddAirdropTraceIgnoreEnt ) // TODO: Change compilation order
		//AddTargetNameCreateCallback( "leviathan_zone_9", AddAirdropTraceIgnoreEnt ) // TODO: Change compilation order
	#endif
	RegisterSignal( "StopBreathingFire" )
	if ( EvilLeviathansEnabled() )
	{
		AddTargetNameCreateCallback( "leviathan_zone_6", OnEvilLeviathanCreated )
		AddTargetNameCreateCallback( "leviathan_zone_9", OnEvilLeviathanCreated )
		AddGlobalAnimEvent( "leviathan_breathes_fire_start", OnLeviathanBreathesFire )
		PrecacheParticleSystem( FX_LEVIATHAN_EYE_GLOW )
		PrecacheParticleSystem( FX_LEVIATHAN_FIRE )
		PrecacheParticleSystem( FX_LEVIATHAN_FIRE_END )
	}
}

void function MinimapLabelsCanyonlandsMU1()
{
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
	//SURVIVAL_AddMinimapLevelLabel( "Pitstop", 0.35, 0.63, 0.4 )
	//SURVIVAL_AddMinimapLevelLabel( "Scorch City", 0.32, 0.9, 0.4 )
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

//#if HAS_HALLOWEEN
void function OnLeviathanBreathesFire( entity ent )
{
	if ( !GetCurrentPlaylistVarBool( "evil_leviathans", false ) )
		return

	thread LeviathanBreathesFire( ent )

}
//#endif //#if HAS_HALLOWEEN

//#if HAS_HALLOWEEN
void function LeviathanBreathesFire( entity ent )
{
	if ( !IsValid( ent ) )
		return

	ent.EndSignal( "OnDestroy" )
	ent.EndSignal( "StopBreathingFire" )

	int fxid = GetParticleSystemIndex( FX_LEVIATHAN_FIRE )
	int attachId = ent.LookupAttachment( "FX_ROAR" )
	vector attachmentOrigin = ent.GetAttachmentOrigin( attachId )
	vector attachmentAngles = ent.GetAttachmentAngles( attachId )

	int numberOfFireballs = 4
	array <entity> dummies
	array <int> fxHandles
	float offset = 550
	float previousOffset = 0
	for( int i = 0; i < numberOfFireballs; i++ )
	{
		float newOffset = offset + previousOffset
		entity dummy = CreateClientSidePropDynamic( attachmentOrigin, attachmentAngles, $"mdl/dev/empty_model.rmdl" )
		vector originOffset = PositionOffsetFromOriginAngles( attachmentOrigin, attachmentAngles, newOffset, 0, 0 )
		vector anglesOffset = AnglesCompose( attachmentAngles, <0, 0, 0> )
		previousOffset = newOffset
		dummy.SetOrigin( originOffset )
		dummy.SetAngles( anglesOffset )
		dummy.SetParent( ent, "FX_ROAR", true )
		dummies.append( dummy )
		int fxIndex
		if ( i == numberOfFireballs - 1 )
			fxIndex = GetParticleSystemIndex( FX_LEVIATHAN_FIRE_END )
		else
			fxIndex = GetParticleSystemIndex( FX_LEVIATHAN_FIRE )
		fxHandles.append( StartParticleEffectOnEntity( dummy, fxIndex, FX_PATTACH_POINT_FOLLOW, dummy.LookupAttachment( "REF" ) ) )
	}

	OnThreadEnd( void function() : ( ent, fxHandles, dummies ) {
		foreach ( fxHandle in fxHandles )
		{
			if ( EffectDoesExist( fxHandle ) )
				EffectStop( fxHandle, false, true )
		}
		foreach ( dummy in dummies )
		{
			if ( IsValid( dummy ) )
				dummy.Destroy()
		}
	} )

	WaitForever()
}
//#endif //#if HAS_HALLOWEEN


//#if HAS_HALLOWEEN
void function OnEvilLeviathanCreated( entity ent )
{
	///////////////////
	// Eye glows
	///////////////////
	entity leviathan = ent
	array <string> eyeGlowAttachments
	eyeGlowAttachments.append( "EYE_L" )
	eyeGlowAttachments.append( "EYE_R" )
	int fxIndex = GetParticleSystemIndex( FX_LEVIATHAN_EYE_GLOW )
	foreach( eyeGlowAttachment in eyeGlowAttachments )
		StartParticleEffectOnEntity( leviathan, fxIndex, FX_PATTACH_POINT_FOLLOW, leviathan.LookupAttachment( eyeGlowAttachment ) )

}
//#endif //#if HAS_HALLOWEEN

bool function EvilLeviathansEnabled()
{
	//#if HAS_HALLOWEEN
		if ( GetCurrentPlaylistVarBool( "evil_leviathans", false ) )
			return true
	//#endif

	return false
}