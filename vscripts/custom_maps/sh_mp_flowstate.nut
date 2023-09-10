//flowstate map empty bsp
// void function TpEncerrona()
// {
	// // script_client ServerCallback_SetMapSettings( 3, true, 1, 1, 0, 50, 50, 5, 6 )
	// gp()[0].SetOrigin( <37405.3711, 14503.9111, -107.460938> )
	
	
	// StartParticleEffectInWorld( GetParticleSystemIndex( $"P_snow_atmo_512" ), <38310.6094, 15441.2061, -342.760986>, <0,0,0> )
	// StartParticleEffectInWorld( GetParticleSystemIndex( $"P_snow_atmo_512" ), <37409.4102, 14393.5078, -107.460938>, <0,0,0> )
	// StartParticleEffectInWorld( GetParticleSystemIndex( $"P_snow_atmo_512" ), <36995.2227, 14109.1445, -314.893219>, <0,0,0> )
	// StartParticleEffectInWorld( GetParticleSystemIndex( $"P_snow_atmo_512" ), <37000.6953, 16284.4043, -211.283371>, <0,0,0> )
	// StartParticleEffectInWorld( GetParticleSystemIndex( $"P_snow_atmo_512" ), <37158.4258, 14945.7402, -633.160583>, <0,0,0> )
	// StartParticleEffectInWorld( GetParticleSystemIndex( $"P_snow_atmo_512" ), <37971.0156, 15433.6221, -713.303284>, <0,0,0> )
	// StartParticleEffectInWorld( GetParticleSystemIndex( $"P_snow_atmo_512" ), <38293.4023, 16212.9609, -851.131042>, <0,0,0> )
	// StartParticleEffectInWorld( GetParticleSystemIndex( $"P_snow_atmo_512" ), <38563.4336, 15408.0127, 444.985046>, <0,0,0> )
	// StartParticleEffectInWorld( GetParticleSystemIndex( $"P_snow_atmo_512" ), <37454.375, 15416.6729, -385.16095>, <0,0,0> )
	// // script_client SetEncerronaNightParams_Test()
	// //script_client SetConVarFloat( "mat_autoexposure_max_multiplier", 1 )
	// //script_client ServerCallback_SetMapSettings( 3, true, 1, 1, 0, 50, 50, 2, 2)	

// }

#if SERVER
global function CodeCallback_MapInit
#endif

#if CLIENT
global function ClientCodeCallback_MapInit
#endif


#if SERVER
void function CodeCallback_MapInit()
{
	PrecacheModel( $"mdl/fs_skybox1.rmdl" )
    AddCallback_GameStateEnter( eGameState.WaitingForPlayers, StagingArea_MoveSkybox )
}

void function StagingArea_MoveSkybox()
{
	thread StagingArea_MoveSkybox_Thread()
}


void function StagingArea_MoveSkybox_Thread()
{
	FlagWait( "EntitiesDidLoad" )

	printt( "Congrats! mp_flowstate has been loaded." )
	
	// CreatePropDynamic( $"mdl/fs_skybox1.rmdl", skyboxCamera.GetOrigin() - <0, 0, 100>, <0, 60, 0> ).SetModelScale( 1 )
}
#endif

#if CLIENT
void function ClientCodeCallback_MapInit()
{
	
}
#endif