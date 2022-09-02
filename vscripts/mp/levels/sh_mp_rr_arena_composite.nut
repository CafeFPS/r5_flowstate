global function ShInit_ArenaComposite
global function CodeCallback_MapInit

void function CodeCallback_MapInit()
{
	PrecacheModel( $"mdl/beacon/beacon_big_screen_02.rmdl" )
	PrecacheModel( $"mdl/canyonlands/canyonlands_light_pole_01.rmdl" )
	PrecacheModel( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl" )
	PrecacheModel( $"mdl/ola/sewer_stair_railing_01.rmdl" )
}

void function ShInit_ArenaComposite()
{
	SetVictorySequencePlatformModel( $"mdl/dev/empty_model.rmdl", < 0, 0, -10 >, < 0, 0, 0 > )
	#if CLIENT
	  SetVictorySequenceLocation(<1374, -4060, 418>, <0, 201.828598, 0> )
	#endif
}