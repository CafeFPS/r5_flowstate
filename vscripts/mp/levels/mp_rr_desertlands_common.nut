
global function Desertlands_MapInit_Common

void function Desertlands_MapInit_Common()
{
	printt( "Desertlands_MapInit_Common" )

	SetVictorySequencePlatformModel( $"mdl/rocks/victory_platform.rmdl", < 0, 0, -10 >, < 0, 0, 0 > )

	#if SERVER

		AddCallback_EntitiesDidLoad( EntitiesDidLoad )

		SURVIVAL_SetPlaneHeight( 15250 )
		SURVIVAL_SetAirburstHeight( 2500 )
		SURVIVAL_SetMapCenter( <0, 0, 0> )
		SetOutOfBoundsTimeLimit( 30.0 )

	#endif

	#if CLIENT
		SetVictorySequenceLocation( <-31359.7344, 16233.1162, -341.363831>, <0, 115.679665, 0> )
		SetMinimapBackgroundTileImage( $"overviews/mp_rr_canyonlands_bg" )
	#endif
}

#if SERVER
void function EntitiesDidLoad()
{
}
#endif

