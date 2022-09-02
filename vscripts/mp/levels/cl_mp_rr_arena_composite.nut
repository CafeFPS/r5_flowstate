global function ClientCodeCallback_MapInit

void function ClientCodeCallback_MapInit()
{
	ShInit_ArenaComposite()
	thread FixtheMapHoles()
}

void function FixtheMapHoles()
{
	wait 0.1
	entity Bigscreen = CreateClientSidePropDynamic( <0, 3413, 830>, <0, 0, 0>, $"mdl/beacon/beacon_big_screen_02.rmdl" )
	entity Light_Pole = CreateClientSidePropDynamic( <0, 2278, -115>, <0, 0, 0>, $"mdl/canyonlands/canyonlands_light_pole_01.rmdl" )
	entity Wall_256_stair = CreateClientSidePropDynamic( <-2022, 2360, -88>, <24, 37.5, 90>, $"mdl/thunderdome/thunderdome_cage_wall_256x128_03.rmdl" )
	entity Wall_256_stair2 = CreateClientSidePropDynamic( <2022, 2360, -88>, <-24, -37.5, 90>, $"mdl/thunderdome/thunderdome_cage_wall_256x128_03.rmdl" )
	entity Wall_256_stair_small = CreateClientSidePropDynamic( <-600, 3040, -185>, <-24, 90, 90>, $"mdl/thunderdome/thunderdome_cage_wall_256x128_03.rmdl" )
	entity Wall_256_stair_small2 = CreateClientSidePropDynamic( <600, 3040, -185>, <-24, 90, 270>, $"mdl/thunderdome/thunderdome_cage_wall_256x128_03.rmdl" )
	entity squarewall = CreateClientSidePropDynamic( <-2685, 3875, 795>, <90, 45, 0>, $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl" )
	entity squarewall2 = CreateClientSidePropDynamic( <2685, 3875, 795>, <-90, -45, 0>, $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl" )
	entity squarewall3 = CreateClientSidePropDynamic( <-3620, 2920, 950>, <90, -45, 0>, $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl" )
	entity squarewall4 = CreateClientSidePropDynamic( <3620, 2920, 950>, <-90, 45, 0>, $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl" )
	entity stairrail = CreateClientSidePropDynamic( <-1517, 4997, 84>, <0, 135, 0>, $"mdl/ola/sewer_stair_railing_01.rmdl" )
	entity stairrail2 = CreateClientSidePropDynamic( <-1465, 5048, 35>, <0, 135, 0>, $"mdl/ola/sewer_stair_railing_01.rmdl" )
	entity stairrail3 = CreateClientSidePropDynamic( <-1413, 5101, -15>, <0, 135, 0>, $"mdl/ola/sewer_stair_railing_01.rmdl" )
	entity stairrail4 = CreateClientSidePropDynamic( <1521, 4997, 84>, <0, -135, 0>, $"mdl/ola/sewer_stair_railing_01.rmdl" )
	entity stairrail5 = CreateClientSidePropDynamic( <1469, 5048, 35>, <0, -135, 0>, $"mdl/ola/sewer_stair_railing_01.rmdl" )
	entity stairrail6 = CreateClientSidePropDynamic( <1417, 5101, -15>, <0, -135, 0>, $"mdl/ola/sewer_stair_railing_01.rmdl" )
	Bigscreen.SetModelScale( 1.8 )
	Light_Pole.SetModelScale( 0.6 )
	Wall_256_stair.SetModelScale( 3.55 )
	Wall_256_stair2.SetModelScale( 3.55 )
	Wall_256_stair_small.SetModelScale( 2.55 )
	Wall_256_stair_small2.SetModelScale( 2.55 )
	squarewall.SetModelScale( 2 )
	squarewall2.SetModelScale( 2 )
	squarewall3.SetModelScale( 3 )
	squarewall4.SetModelScale( 3 )
	stairrail.SetModelScale( 1.3 )
	stairrail2.SetModelScale( 1.3 )
	stairrail3.SetModelScale( 1.3 )
	stairrail4.SetModelScale( 1.3 )
	stairrail5.SetModelScale( 1.3 )
	stairrail6.SetModelScale( 1.3 )
}