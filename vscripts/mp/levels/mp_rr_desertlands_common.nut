global function Desertlands_MapInit_Common

void function Desertlands_MapInit_Common()
{
	printt( "Desertlands_MapInit_Common" )

	SetVictorySequencePlatformModel( $"mdl/rocks/desertlands_victory_platform.rmdl", < 0, 0, -10 >, < 0, 0, 0 > )

	#if SERVER

		AddCallback_EntitiesDidLoad( EntitiesDidLoad )

		SURVIVAL_SetPlaneHeight( 15250 )
		SURVIVAL_SetAirburstHeight( 2500 )
		SURVIVAL_SetMapCenter( <0, 0, 0> )
		SetOutOfBoundsTimeLimit( 30.0 )

		// DesertlandsTrain_Precaches()
	#endif

	#if CLIENT
		Freefall_SetPlaneHeight( 15250 )
		Freefall_SetDisplaySeaHeightForLevel( -8961.0 )

		SetVictorySequenceLocation( <11092.6162, -20878.0684, 1561.52222>, <0, 267.894653, 0> )
		SetVictorySequenceSunSkyIntensity( 1.0, 0.5 )
		SetMinimapBackgroundTileImage( $"overviews/mp_rr_canyonlands_bg" )
	#endif
}

#if SERVER
void function EntitiesDidLoad()
{
	// thread DesertlandsTrain_Init()
}
#endif


