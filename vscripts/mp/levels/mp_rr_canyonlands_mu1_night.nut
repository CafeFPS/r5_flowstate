
#if CLIENT
	global function ClientCodeCallback_MapInit
	global function MinimapLabelsCanyonlandsNight
#endif //CLIENT


#if SERVER
	global function CodeCallback_MapInit
#endif //SERVER



#if CLIENT
	const asset FX_LEVIATHAN_EYE_GLOW = $"P_leviathan_eye"
	const asset FX_LEVIATHAN_FIRE = $"P_leviathan_roar_fire"
	const asset FX_LEVIATHAN_FIRE_END = $"P_ship_fire_large"
#endif //CLIENT


#if SERVER
void function CodeCallback_MapInit()
{
	if ( IsFallLTM() )
	{
		SharedInit()
		SURVIVAL_AddCallback_OnDeathFieldStopShrink( OnDeathFieldStopShrink_ShadowSquad )
	}
	//mp_rr_canyonlands_mu1_night_SurvivalPreprocess()

	Canyonlands_MU1_CommonMapInit()

	MapZones_RegisterDataTable( $"datatable/map_zones/zones_mp_rr_canyonlands_mu1_night.rpak" )
	//SetFlyersToSpawn( 8  )
	AddCallback_EntitiesDidLoad( EntitiesDidLoad )


	// ------------------ DEV --------------------

	PrecacheModel(BANGALORE_SMOKE_MODEL)
	PrecacheModel(BUTTON_ASSET)

	PrecacheParticleSystem( TROPHY_INTERCEPT_PROJECTILE_SMALL_FX )
	PrecacheParticleSystem( TROPHY_INTERCEPT_PROJECTILE_LARGE_FX )
	PrecacheParticleSystem( TROPHY_INTERCEPT_PROJECTILE_CLOSE_FX )

	PrecacheParticleSystem( FX_BOMBARDMENT_MARKER )
	PrecacheParticleSystem( FX_ARTILLERY_PLASMA )
	PrecacheParticleSystem( METEOR_TRAIL )
	PrecacheParticleSystem( SHIELD_BRAKER )
	PrecacheParticleSystem( MASTIF_PROJ )
	PrecacheParticleSystem( TRACER_PROJ )
	PrecacheParticleSystem( HOLO_TRAIL_FX )
	PrecacheParticleSystem( DOG_SMOKE )
	PrecacheParticleSystem( SHIP_ROCK )

	SpawnButton()
	RegisterSignal("onFireworksStop")

	// ------------------------------------------

}
#endif //SERVER


#if CLIENT
void function ClientCodeCallback_MapInit()
{
	if ( IsFallLTM() )
		SharedInit()
	Canyonlands_MapInit_Common()
	MapZones_RegisterDataTable( $"datatable/map_zones/zones_mp_rr_canyonlands_mu1_night.rpak" )
	MinimapLabelsCanyonlandsNight()
	AddTargetNameCreateCallback( "leviathan_staging", OnLeviathanMarkerCreated )
	AddTargetNameCreateCallback( "leviathan_zone_6", AddAirdropTraceIgnoreEnt )
	AddTargetNameCreateCallback( "leviathan_zone_9", AddAirdropTraceIgnoreEnt )
	RequireVolumetricLighting( true )


	RegisterSignal( "RoarStop" )
	if ( EvilLeviathansEnabled() )
	{
		AddTargetNameCreateCallback( "leviathan_zone_6", OnEvilLeviathanCreated )
		AddTargetNameCreateCallback( "leviathan_zone_9", OnEvilLeviathanCreated )
		AddGlobalAnimEvent( "leviathan_breathes_fire_start", OnLeviathanBreathesFire )
		PrecacheParticleSystem( FX_LEVIATHAN_EYE_GLOW )
		PrecacheParticleSystem( FX_LEVIATHAN_FIRE )
	}

}
#endif //CLIENT


void function SharedInit()
{
	ShPrecacheShadowSquadAssets()
	ShPrecacheEvacShipAssets()
	//ShLootCreeps_Init()

}


#if SERVER
void function EntitiesDidLoad()
{



}
#endif //SERVER


#if SERVER
void function OnDeathFieldStopShrink_ShadowSquad( DeathFieldData deathFieldData )
{
	LootCreepGarbageCollect()
}
#endif //SERVER




#if CLIENT
void function MinimapLabelsCanyonlandsNight()
{
	//SWAMPLAND
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_02_A" ) ), 0.93, 0.5, 0.6 ) //Swamps

	//INDUSTRIAL
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_04_A" ) ), 0.79, 0.62, 0.6 ) //Hydro Dam
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_11_A" ) ), 0.56, 0.91, 0.6 ) //Water Treatment
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_14_RUNOFF" ) ), 0.13, 0.40, 0.6 ) //Runoff

	//UNIQUE
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_13_ARENA" ) ), 0.24, 0.32, 0.6 ) //The Pit
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_17_DOME" ) ), 0.22, 0.85, 0.6 )//Thunderdome

	//MILITARY
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_04_B" ) ), 0.78, 0.74, 0.6 ) //Repulsor
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_08_ARTILLERY" ) ), 0.54, 0.15, 0.6 ) //Artillery
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_15_AIRBASE" ) ), 0.13, 0.56, 0.6 ) //Airbase
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "JCT_10_13" ) ), 0.34, 0.45, 0.6 ) //Bunker Pass


	//COLONY
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_01_A" ) ), 0.81, 0.22, 0.6 ) //Relay
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_01_B" ) ), 0.78, 0.32, 0.6 ) //Wetlands

	//LAGOON
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_09_A" ) ), 0.4, 0.3, 0.6 ) //"Containment"
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_06_A" ) ), 0.66, 0.53, 0.6 ) //"The Cage"

	//SLUM
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_12_A" ) ), 0.16, 0.23, 0.6 )//"Slum Lakes"
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_16_MALL" ) ), 0.49, 0.68, 0.6 ) //"Market"
	SURVIVAL_AddMinimapLevelLabel( GetZoneMiniMapNameForZoneId( MapZones_GetZoneIdForTriggerName( "Z_16_SKULLTOWN" ) ), 0.32, 0.74, 0.6 )//"Skull Town"

}
#endif //CLIENT





#if CLIENT
void function OnLeviathanMarkerCreated( entity marker )
{
	string markerTargetName = marker.GetTargetName()
	entity leviathan = CreateClientSidePropDynamic( marker.GetOrigin(), marker.GetAngles(), MU1_LEVIATHAN_MODEL )
	bool stagingOnly = markerTargetName == "leviathan_staging"

	thread LeviathanThink( marker, leviathan, stagingOnly )
}
#endif //CLIENT


#if CLIENT
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
#endif //CLIENT



#if CLIENT
void function OnLeviathanBreathesFire( entity ent )
{
	if ( !GetCurrentPlaylistVarBool( "evil_leviathans", false ) )
		return

	thread LeviathanBreathesFire( ent )

}
#endif //CLIENT



#if CLIENT
void function LeviathanBreathesFire( entity ent )
{
	if ( !IsValid( ent ) )
		return

	ent.EndSignal( "OnDestroy" )
	ent.EndSignal( "RoarStop" )

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
#endif //CLIENT



#if CLIENT
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
#endif //CLIENT


#if CLIENT
bool function EvilLeviathansEnabled()
{

	if ( GetCurrentPlaylistVarBool( "evil_leviathans", false ) )
		return true
	return false
}
#endif //CLIENT


///// ----------------------------- FIREWORKS MOD --------------------------//////////////


#if SERVER


const asset BUTTON_ASSET = $"mdl/props/global_access_panel_button/global_access_panel_button_console_w_stand.rmdl"

const asset TROPHY_INTERCEPT_PROJECTILE_SMALL_FX = $"P_wpn_trophy_imp_sm"//
const asset TROPHY_INTERCEPT_PROJECTILE_LARGE_FX = $"P_wpn_trophy_imp_lg"
const asset TROPHY_INTERCEPT_PROJECTILE_CLOSE_FX = $"P_wpn_trophy_imp_lite"

const asset FX_BOMBARDMENT_MARKER = $"P_ar_artillery_marker"
const asset FX_ARTILLERY_PLASMA = $"P_projectile_artillery_plasma"
const asset BANGALORE_SMOKE_MODEL = $"mdl/weapons/grenades/w_bangalore_canister_gas_projectile.rmdl"
const asset METEOR_TRAIL = $"P_wpn_meteor_trail"
const asset SHIELD_BRAKER = $"P_tracer_proj_smg_shield_breaker"
const asset MASTIF_PROJ = $"P_mastiff_proj"
const asset TRACER_PROJ = $"P_tracer_projectile_smg"
const asset MUZZLE_FLASH = $"P_ts_muzzleflash_pred"
const asset HOLO_TRAIL_FX = $"P_ar_holopilot_trail"
const asset DOG_SMOKE = $"P_dog_w_fire_trail_1"
const asset SHIP_ROCK = $"P_fire_large"

// locations on map KC night
const vector FIRE_A = < 29416, -17672, 5692>
const vector FIRE_B = < 29511, -12159, 5692>
const vector FIRE_C = < 27205, -12175, 5692>
const vector FIRE_D = < 26125, -17691, 5692>

const vector LAUNCHER_A = < 27026, -16131, 5580>
const vector LAUNCHER_B = < 27070, -14223, 5580>
const vector LAUNCHER_C = < 26838, -15176, 5272>

const vector PANEL_POS = < 29389, -15057, 5367>
const vector PANEL_ANG = <0,90,0>


// ---- IF USED IN A SEPARATE FILE --------

// void function Fireworks_Init()
// {

// 	PrecacheModel(BANGALORE_SMOKE_MODEL)
// 	PrecacheModel(BUTTON_ASSET)

// 	PrecacheParticleSystem( TROPHY_INTERCEPT_PROJECTILE_SMALL_FX )
// 	PrecacheParticleSystem( TROPHY_INTERCEPT_PROJECTILE_LARGE_FX )
// 	PrecacheParticleSystem( TROPHY_INTERCEPT_PROJECTILE_CLOSE_FX )

// 	PrecacheParticleSystem( FX_BOMBARDMENT_MARKER )
// 	PrecacheParticleSystem( FX_ARTILLERY_PLASMA )
// 	PrecacheParticleSystem( METEOR_TRAIL )
// 	PrecacheParticleSystem( SHIELD_BRAKER )
// 	PrecacheParticleSystem( MASTIF_PROJ )
// 	PrecacheParticleSystem( TRACER_PROJ )
// 	PrecacheParticleSystem( HOLO_TRAIL_FX )
// 	PrecacheParticleSystem( DOG_SMOKE )
// 	PrecacheParticleSystem( SHIP_ROCK )

// 	RegisterSignal("onFireworksStop")


// 	if ( GetMapName() == "mp_rr_canyonlands_mu1_night") 
// 	{
// 		print("---------------- " +  GetMapName() + " --------------------")
// 		SpawnButton()
// 		RegisterSignal("onFireworksStop")
// 	}
// }

// -------------------------------------

void function SpawnButton()
{
	entity myButton = CreateButton(PANEL_POS, PANEL_ANG)
	AddCallback_OnUseEntity( myButton, void function(entity panel, entity user, int input) 
	{
		// EmitSoundOnEntityOnlyTopanel( user, user, FIRINGRANGE_BUTTON_SOUND )
		thread startFireworks(panel)
	})
}

void function startFireworks(entity panel)
{
	// busy state
	panel.SetSkin( 1 )

	panel.UnsetUsable()
	panel.SetUsePrompts( "", "" )

	waitthread LaunchShow(panel)
	wait 5


	// normal state
	panel.SetSkin( 0 )

	string prompt = "%&use% START FIREWORK SHOW"
	panel.SetUsePrompts(prompt, prompt)

	panel.SetUsable()
	print("panel is now usable")

}

entity function CreateButton(vector pos, vector ang)
{
	entity button = CreateEntity("prop_dynamic")
	button.kv.solid = 6
	button.SetValueForModelKey(BUTTON_ASSET)
	button.SetOrigin(pos)
	button.SetAngles(ang)
	DispatchSpawn(button)

	button.SetUsable()
	button.SetUsableByGroup("pilot")

	string prompt = "%&use% START FIREWORK SHOW"

	button.SetUsePrompts(prompt, prompt)
	return button
}

// unused
void function sequenceTest(entity panel)
{
	float speed = 1500
	float dt = 2.0
	float xOffset = -0.3

	thread numberBomb(speed, dt, <xOffset, -0.5, 1>, 2, LAUNCHER_A)
	thread numberBomb(speed, dt, <xOffset, 0, 1>, 0, LAUNCHER_A)
	thread numberBomb(speed, dt, <xOffset, 0, 1>, 2, LAUNCHER_B)
	thread numberBomb(speed, dt, <xOffset, 0.5, 1>, 2, LAUNCHER_B)
}

void function LaunchShow(entity panel)
{
	wait 1.0
	waitthread fullSequence(panel)
}

void function fullSequence(entity panel)
{
	// PART 1 : light up fire
	thread flameSequence(panel)

	// PART 2 : small firework 
	// 2.1 solo firework small

	wait 10.0

	thread megaBomb(1500, 0.5, <0, 0, 1>, 500, 1, -0.6, LAUNCHER_A)
	wait 3.0 
	thread megaBomb(1500, 0.5, <0, 0, 1> , 500, 1, -0.6, LAUNCHER_B)

	wait 1.0

	thread megaBomb(1500, 0.5, <0, 0.1, 1>, 500, 1, -0.6, LAUNCHER_A)
	wait 2.0 
	thread megaBomb(1500, 0.5, <0, -0.1, 1> , 500, 1, -0.6, LAUNCHER_B)

	thread megaBomb(1500, 0.5, <0, -0.1, 1>, 500, 1, -0.6, LAUNCHER_A)
	wait 3.0 
	thread megaBomb(1500, 0.5, <0, 0.1, 1> , 500, 1, -0.6, LAUNCHER_B)

	// 2.2 multiple firwork small
	wait 5.0
	thread smallSequence(panel)

	// PART 3: ZAP firework 
	wait 15.0
	thread zapSequence(panel, 10)

	// PART 4 : big firework
	wait 20.0

	// 4.1 solo firework big
	thread megaBomb(3500, 3.0, <-0, 0, 1>, 1500, 0, -1, LAUNCHER_C )
	wait 7.0

	thread megaBomb(3000, 3.0, <-0.2, 0.1, 1>, 1500, 0, -1, LAUNCHER_A )
	wait 7.0

	thread megaBomb(3000, 3.0, <0.2, -0.1, 1>, 1500, 0, -1, LAUNCHER_B )
	wait 10.0

	thread megaBomb(3000, 3.0, <-0.2, 0.1, 1>, 1500, 0, -1, LAUNCHER_A )
	wait 5.0

	thread megaBomb(3500, 3.0, <-0, 0, 1>, 1500, 0, -1, LAUNCHER_C )
	wait 5.0

	thread megaBomb(3000, 3.0, <0.2, -0.1, 1>, 1500, 0, -1, LAUNCHER_B )
	wait 10.0


	// PART 5 : FINAL MIX
	thread bigSequence()
	thread zapSequence(panel, 28)

	wait 15.0
	thread smallSequence(panel)
	wait 20.0

	// PART 6: 2022 firework
	float speed = 2000
	float dt = 3
	float xOffset = -0.3

	thread numberBomb(speed, dt, <xOffset, -0.3, 1>, 2, LAUNCHER_A)
	thread numberBomb(speed, dt, <xOffset, 0, 1>, 0, LAUNCHER_A)
	thread numberBomb(speed, dt, <xOffset, 0, 1>, 2, LAUNCHER_B)
	thread numberBomb(speed, dt, <xOffset, 0.3, 1>, 2, LAUNCHER_B)

	wait 3.0

	panel.Signal("onFireworksStop")
}

void function zapSequence(entity panel, int number)
{
	panel.EndSignal("onFireworksStop")

	for (int i=0; i < number; i++)
	{
		int random = RandomInt(9)

		if (random < 4 ) 
		{
			thread CreateZap(LAUNCHER_A)
		} else if ( random >= 4 && random < 8)
		{
			thread CreateZap(LAUNCHER_B)
		}
		else {
			thread CreateZap(LAUNCHER_A)
			thread CreateZap(LAUNCHER_B)
		}

		float waittime = 2 - (2 / float(number)) * i  + RandomFloat ( 0.5)
		wait waittime
	}
}

void function flameSequence(entity panel)
{
	panel.EndSignal("onFireworksStop")

	// PART 1 : light up fire 

	for (int i=0; i < 5; i++)
	{
		thread repeatFlame(LAUNCHER_C, 15)
		wait 3.0
		thread repeatFlame(FIRE_A, 10)
		thread repeatFlame(FIRE_B, 10)
		thread repeatFlame(FIRE_C, 10)
		thread repeatFlame(FIRE_D, 10)
	}
	wait 10.0


	// PART 2 : alternate fire
	while(true)
	{
		thread repeatFlame(FIRE_A, 3)
		thread repeatFlame(FIRE_B, 3)
		wait 2.0
		thread repeatFlame(FIRE_C, 3)
		thread repeatFlame(FIRE_D, 3)
		wait 2.0
	}
}

void function smallSequence(entity panel)
{
	panel.EndSignal("onFireworksStop")

	for (int i=0; i<20 ; i++)
	{
		vector vel = <0, RandomFloat(0.2) - 0.1, 1>
		thread megaBomb(1500, 0.5, vel, 500, 1, 0.2, LAUNCHER_A)

		float waittime = 0.1 + RandomFloat(0.5)
		wait waittime

		vector vel2 = <0, RandomFloat(0.2) - 0.1, 1>
		thread megaBomb(1500, 0.5, vel2 , 500, 1, 0.2, LAUNCHER_B)

		float waittimeF = 3.0 + float(i)/ 5 

		wait waittimeF
	}
}

void function bigSequence()
{
	int n = 10

	for (int i=0; i<n ; i++)
	{
		float v = 3000 + float(RandomInt(500))
		vector vel = <RandomFloat(0.2) - 0.1, 0, 1>
		thread megaBomb(v, 3.0, vel, 1500, 0, -1, LAUNCHER_A)

		float waittime = 0.1 + RandomFloat(0.5)
		wait waittime

		float v2 = 3000 + float(RandomInt(500))
		vector vel2 = <RandomFloat(0.4) - 0.2, 0, 1>

		thread megaBomb(v2, 3.0, vel2, 1500, 0, -1, LAUNCHER_B)

		int random = RandomInt(4)

		if (random == 0){
			float v3 = 3000 + float(RandomInt(500))
			thread megaBomb(v3, 3.0, <0,0,1>, 1500, 0, -1, LAUNCHER_C)
		}

		float splittime = 3.0
		wait splittime
	}
}


entity function CreateFireworkProp(vector pos)
{
	entity prop_physics = CreateEntity( "prop_physics" )
	prop_physics.SetValueForModelKey( BANGALORE_SMOKE_MODEL )

	prop_physics.kv.spawnflags = 4 // 4 = SF_PHYSPROP_DEBRIS
	prop_physics.kv.fadedist = 2000
	prop_physics.kv.renderamt = 255
	prop_physics.kv.rendercolor = "255 255 255"
	prop_physics.kv.CollisionGroup = TRACE_COLLISION_GROUP_DEBRIS

	prop_physics.kv.minhealthdmg = 9999
	prop_physics.kv.nodamageforces = 1
	prop_physics.kv.inertiaScale = 1

	prop_physics.SetOrigin( pos )
	DispatchSpawn( prop_physics )
	prop_physics.SetModel( BANGALORE_SMOKE_MODEL )

	return prop_physics
}


void function flamethrower(vector pos)
{
	vector startVelocity = < 0, 0, 1> * 1500

	vector startAngle = VectorToAngles(startVelocity)
	vector launchPosition = pos + < 0,0,50>

	entity prop_physics = CreateFireworkProp(launchPosition)
	prop_physics.SetVelocity( startVelocity )

	entity fx = PlayFXOnEntity( SHIP_ROCK, prop_physics, "",  <0,0,0>, startAngle)
	prop_physics.e.fxArray.append( fx )

	thread stopFlame(prop_physics)
}

void function repeatFlame(vector pos, int n)
{
	for ( int i=0; i<n; i++)
	{
		thread flamethrower(pos)
		wait 1.0
	}
}

void function stopFlame(entity prop_physics)
{
	float maxT = 1.5
	wait maxT
	prop_physics.Destroy()
}

void function megaBomb(float v, float launchtime, vector vVec, float bombV, int index, float shape, vector pos)
{
	entity prop = Launcher(v, vVec, index, pos )
	wait launchtime // launch time

	vector endPosition = prop.GetOrigin() + <0,0,250>
	prop.Destroy()

	// wait 0.3 // time before explo

	if (index == 0 ){
		wait 0.3
	} else {
		wait 0.1
	}

	
	// exploding
	thread CreateBomb(endPosition, bombV, index, shape)
}

void function numberBomb(float v, float launchtime, vector vVec, int number, vector pos)
{
	entity prop = Launcher(v, vVec, 1, pos )
	wait launchtime // launch time

	vector endPosition = prop.GetOrigin() + <-200,0,350>
	prop.Destroy()

	wait 0.3 // time before explo
	
	// exploding
	thread CreateYearBomb_number(endPosition, number)
}

entity function Launcher(float v, vector vVec, int index, vector pos)
{
	vector startVelocity = vVec * v
	vector startAngle = VectorToAngles(startVelocity)
	vector launchPosition = pos + < 0,0,50>

	entity prop_physics = CreateFireworkProp(launchPosition)
	prop_physics.SetVelocity( startVelocity )

	if (index == 0)
	{
		thread delayedLaunchSound(launchPosition)
	} else
	{
		thread delayedLaunchSmallSound(launchPosition)
	}

	entity fx = PlayFXOnEntity( METEOR_TRAIL, prop_physics, "",  <0,0,0>, startAngle)
	prop_physics.e.fxArray.append( fx )

	return prop_physics
}

void function delayedLaunchSound(vector launchPosition)
{
	wait 0.3
	EmitSoundAtPosition(TEAM_UNASSIGNED, launchPosition, "Weapon_Kraber_Fire_3P")
}

void function delayedLaunchSmallSound(vector launchPosition)
{
	wait 0.1
	EmitSoundAtPosition(TEAM_UNASSIGNED, launchPosition, "Weapon_p2011_FireSuppressed_3P")
}

void function delayedExplosionSound(vector exploPosition)
{
	wait 0.5
	EmitSoundAtPosition(TEAM_UNASSIGNED, exploPosition, "Weapon_G2A4_Fire_3P")
}

void function delayedSmallSound(vector exploPosition)
{
	// wait 0.2
	wait 0.1
	EmitSoundAtPosition(TEAM_UNASSIGNED, exploPosition, "Weapon_p2011_FireSuppressed_3P")
}

void function CreateYearBomb_number(vector position, int index)
{
	print("bombing year")
	array<vector> p

	if (index == 0)
	{
		// 0
		p = [ <-12,0,0>, <-11.5,0,4>, <-11.5,0,-4>, <-10,0,7>, <-10,0,-7>, <-7,0,-8>, <-7,0,8>, <-4,0,7>, <-4,0,-7>, <-2.5,0,4>, <-2.5,0,-4>, <-2,0,0> ] 
	} else {
		// 2
		p = [ <-26, 0,3>, <-25.5,0,5>, <-24.5, 0, 6.5>, <-23,0,7.5>, <-21,0,8>, <-19,0,7.5>, <-17.5,0,6.5>, <-16,0,3>, <-17,0,1>, <-18,0,1>, <-21,0,-3>, <-24,0,-5>, <-26,0,-8>, <-23,0,-8>, <-21,0,-8>, <-19,0,-8>, <-16,0,-8> ]
	}

	for (int i=0; i< p.len(); i++)
	{
		vector ang = <0,0,0>
		vector offset = < 0, 0, 0>

		if (index == 0)
		{
			offset = <7, 0, 0>
		} else {
			offset = <21, 0, 0>
		}
		// should do for more numbers

		vector tempP = p[i] + offset

		tempP.y = tempP.x
		tempP.x = 0

		vector velocityOffset = <0, 0, 20>
		vector startPosition = position + (tempP) * 100
		vector startVelocity = (tempP + velocityOffset) * 50 

		entity prop_physics = CreateFireworkProp(startPosition)
		vector startAngle = <0,0,0>

		entity fx = PlayFXOnEntity( DOG_SMOKE, prop_physics, "",  <0,0,0>, startAngle)
		prop_physics.e.fxArray.append( fx )
		thread CorrectFxNumber(fx, prop_physics, 1)

		prop_physics.SetVelocity( startVelocity )
	}
}


void function CreateBomb(vector position, float bombV, int index, float shape)
{	
	vector startPosition = position
	vector ang = <0,0,0>

	// --- get points ---
	int n = 100
	float l = shape

	array<vector> p = []
	float phi = 3.14 * (3 - sqrt(5))

	for (int i=0; i < n; i++)
	{
		float y = 1 - (i / float( n - 1)) * 2
		float tempR = 1 - y * y

		if (tempR < 0 )
			tempR = - tempR

		float r = sqrt(tempR)
		float theta = phi * i
		float x = cos(theta) * r
		float z = sin(theta) * r

		vector tempP = <x, y, z>
		if ( z > l )
		{
			p.append(tempP)
		}
		// else drop p
	}

	// print(p.len())
	// for (int j =0; j< p.len(); j++)
	// {
	// 	print(p[j])
	// }

	// ----- 1D perlin noise lookalike func -----
	// float nx = sin(2 * x) + sin(3.14 * x)
	// ------------------------------------------

	for ( int i=0; i< p.len(); i++)
	{
		float zt = p[i].z

		vector startVelocity = p[i] * bombV

		entity prop_physics = CreateFireworkProp(startPosition)
		prop_physics.SetModel( BANGALORE_SMOKE_MODEL )
		// --

		vector startAngle = VectorToAngles(startVelocity)

		if (index == 0)
		{
			// big fw
			entity fx = PlayFXOnEntity( FX_ARTILLERY_PLASMA, prop_physics, "",  <0,0,0>, startAngle)
			prop_physics.e.fxArray.append( fx )
			thread CorrectFx(fx, prop_physics, zt)
			thread delayedExplosionSound(startPosition)
		} else if (index == 1)
		{
			// tiny fw
			entity fx = PlayFXOnEntity( MASTIF_PROJ, prop_physics, "",  <0,0,0>, startAngle)
			prop_physics.e.fxArray.append( fx )
			thread CorrectFxSmall(fx, prop_physics, zt)
			thread delayedSmallSound(startPosition)
		} else if (index == 2)
		{
			// number fw
			entity fx = PlayFXOnEntity( DOG_SMOKE, prop_physics, "",  <0,0,0>, startAngle)
			prop_physics.e.fxArray.append( fx )
			thread CorrectFxSmall(fx, prop_physics, zt)
			thread delayedSmallSound(startPosition)
		} else 
		{
			entity fx = PlayFXOnEntity( SHIP_ROCK, prop_physics, "",  <0,0,0>, startAngle)
			prop_physics.e.fxArray.append( fx )
			thread CorrectFxSmall(fx, prop_physics, zt)
			thread delayedSmallSound(startPosition)
		} 

		// entity fx = PlayFXOnEntity( MUZZLE_FLASH, prop_physics, "",  <0,0,0>, startAngle)
		prop_physics.SetVelocity( startVelocity )
	}

	////----------- flat circle -----------

	// int nbBranches = 8
	// int branchLength = 100
	// vector baseVec = <1, 0, 0>

	// for ( int i=0; i< nbBranches; i++)
	// {
	// 	float rotAng = 2 * 3.14 / nbBranches * i
	// 	vector dirVec = < cos(rotAng), sin(rotAng), 0 >

	// 	vector startVelocity = dirVec * branchLength
	// 	startVelocity.z = 300

	// 	entity prop_physics = CreateFireworkProp(startPosition)
	// 	vector startAngle = VectorToAngles(startVelocity)

	// 	entity fx = PlayFXOnEntity( FX_ARTILLERY_PLASMA, prop_physics, "",  <0,0,0>, startAngle)
	// 	prop_physics.e.fxArray.append( fx )
	// 	thread CorrectFx(fx, prop_physics)

	// 	prop_physics.SetVelocity( startVelocity )
	// 	// print("bomb created")
	// }

	// -----------------------------

	// print("bomb created")
}

void function CorrectFx(entity fx, entity prop_physics, float zt)
{
	float maxT = 2.5 + RandomFloat(2) * zt * 3
	float t = 0

	float dt = 0.1
	while (t < maxT)
	{
		vector tempV = prop_physics.GetVelocity()
		vector tempAng = VectorToAngles(tempV)
		tempAng.x = tempAng.x % 360
		fx.SetAngles( tempAng )
		fx.SetOrigin(prop_physics.GetOrigin())

		wait dt - 0.01
		t = t + dt
	}
	prop_physics.Destroy()
}

void function CorrectFxSmall(entity fx, entity prop_physics, float zt)
{
	// float maxT = 0.5 + RandomFloat(2) * zt * 3
	float maxT = 2

	// print("maxT : " + maxT)
	float t = 0

	float dt = 0.2
	while (t < maxT)
	{
		vector tempV = prop_physics.GetVelocity()
		vector tempAng = VectorToAngles(tempV)
		tempAng.x = tempAng.x % 360
		fx.SetAngles( tempAng )
		fx.SetOrigin(prop_physics.GetOrigin())

		wait dt - 0.01
		t = t + dt
	}
	prop_physics.Destroy()
}

void function CorrectFxNumber(entity fx, entity prop_physics, float zt)
{
	float maxT = 1.5

	// print("maxT : " + maxT)
	float t = 0

	float dt = 0.1
	while (t < maxT)
	{
		vector tempV = prop_physics.GetVelocity()
		vector tempAng = VectorToAngles(tempV)
		tempAng.x = tempAng.x % 360
		fx.SetAngles( tempAng )
		fx.SetOrigin(prop_physics.GetOrigin())

		wait dt - 0.01
		t = t + dt
	}
	prop_physics.Destroy()
}

void function CreateZap(vector launcherPos)
{
	wait 0.5

	vector startPosition = launcherPos + <0, 0, 300>
	// vector endPosition = startPosition + <0, 0, 2000>

	float randomX = RandomFloat(500) - 250
	float randomY = RandomFloat(500) - 250
	float randomZ = RandomFloat(1000) - 500 + 2000

	vector endPosition = startPosition + <randomX, randomY, randomZ> 
	vector ang  = <0,0,0>

	int random = RandomInt(3)
	int level = 1 // temporary

	int duration = 1 // temporary

	entity zap = StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( TROPHY_INTERCEPT_PROJECTILE_LARGE_FX ), endPosition, ang )

	EmitSoundAtPosition(TEAM_UNASSIGNED, startPosition, "Wattson_Ultimate_I")

	// vector myColor = <255, 171, 0>
	EffectSetControlPointVector( zap, 1, startPosition )

	thread ZapFractal(endPosition, level, duration)

	thread delayedDestroy(zap)
}

void function ZapFractal( vector pos, int level, int duration)
{	
	// TODO: fractal levels

	// print("ZapFractal")
	wait 0.2

	if (level == 0)
		return

	int nbBranches = 8
	int branchLength = 500
	vector baseVec = <1, 0, 0>

	float randomZ = RandomFloat(1) - 0.5

	for ( int i=0; i< nbBranches; i++)
	{
		float rotAng = 2 * 3.14 / nbBranches * i
		vector dirVec = < cos(rotAng), sin(rotAng), randomZ >
		vector tempEndPos = pos + dirVec * (branchLength + RandomInt(2) * branchLength)

		EmitSoundAtPosition(TEAM_UNASSIGNED, tempEndPos, "Wattson_Ultimate_I")

		entity zap = StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( TROPHY_INTERCEPT_PROJECTILE_LARGE_FX ), tempEndPos, <0,0,0> )
		EffectSetControlPointVector( zap, 1, pos )

		thread delayedDestroy(zap)
	}
}

void function delayedDestroy(entity zap)
{
	wait 2.0
	try{
		zap.Destroy()
	}
	catch(error)
	{
		// error print
	}
}

#endif