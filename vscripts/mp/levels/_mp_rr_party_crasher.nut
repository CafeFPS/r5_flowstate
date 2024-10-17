global function CodeCallback_MapInit

//Party Crasher Reloaded
//By CafeFPS & AyeZee

struct {
	entity button1
    entity button2
    entity button3
    bool button1pressed = false
    bool button2pressed = false
    bool button3pressed = false
} file

void function CodeCallback_MapInit()
{
	//printt("PARTY CRASHER LOADED!")
	PrecacheModel($"mdl/levels_terrain/mp_rr_canyonlands/waterfall_canyonlands_04.rmdl")
	AddCallback_EntitiesDidLoad( PartyCrasherOnEntitiesDidLoad )
}

void function PartyCrasherOnEntitiesDidLoad()
{
    SpawnMovingLights()
    InitSpecialButtons()
     
    // Props ( Zipline )
    MapEditor_CreateProp( $"mdl/industrial/security_fence_post.rmdl", < 165.7, -1146.7, 1179 >, < 0, 116.1, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/zipline_arm.rmdl", < 165.4215, -1147.95, 1339 >, < 0, 26.1, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/zipline_arm.rmdl", < 2228.743, 1109.592, 1059 >, < 0, -147.9, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/security_fence_post.rmdl", < -998.8, 1006, 1019.5 >, < 0, 110.3, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/zipline_arm.rmdl", < -999.2034, 1004.785, 1179.5 >, < 0, 20.3, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/zipline_arm.rmdl", < 1638.167, 2096.169, 1059 >, < 0, 31.82, 0 >, true, 50000, -1, 1 )

    // NonVerticalZipLines
    MapEditor_CreateZiplineFromUnity( < 137.6328, -1100.318, 1327 >, < 0, 116.1, 0 >, < 2261.358, 1065.125, 1047 >, < 0, 116.1, 0 >, false, -1, 1, 2, 1, 0.985, 0, 1, 160, 160, false, 0, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < -1022.036, 1054.981, 1167.5 >, < 0, 110.3, 0 >, < 1605.769, 2140.794, 1047 >, < 0, 110.3, 0 >, false, -1, 1, 2, 1, 0.985, 0, 1, 160, 160, false, 0, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )


	//three waterfalls
	CreateMapEditorProp( $"mdl/levels_terrain/mp_rr_canyonlands/waterfall_canyonlands_04.rmdl", <-3000, -1300, 1100>, <0, -150, 0>)
	entity waterfallSmall = CreateMapEditorProp( $"mdl/levels_terrain/mp_rr_canyonlands/waterfall_canyonlands_04.rmdl", <-3300, -200, 1150>, <0, -170, 0>)
	waterfallSmall.kv.modelscale = 0.5
	entity waterfallSmall2 = CreateMapEditorProp( $"mdl/levels_terrain/mp_rr_canyonlands/waterfall_canyonlands_04.rmdl", <-2400, -2000, 1500>, <0, -140, 0>)
	waterfallSmall2.kv.modelscale = 0.5
	
	//some props around map to fill empty space
	CreateMapEditorProp( $"mdl/foliage/plant_tropical_ground_leafy_01.rmdl", <-3136.84,0.466312,1215.73>, <0,-90,0>, true, 8000, -1 )
    CreateMapEditorProp( $"mdl/foliage/plant_tropical_ground_leafy_01.rmdl", <-2624.68,-319.345,1215.67>, <0,-90,0>, true, 8000, -1 )
    CreateMapEditorProp( $"mdl/foliage/plant_tropical_ground_leafy_01.rmdl", <-2879.16,-128.205,1215.51>, <0,90,0>, true, 8000, -1 )
    CreateMapEditorProp( $"mdl/foliage/plant_tropical_ground_leafy_01.rmdl", <-2048.13,-2240.96,1215.75>, <0,0,0>, true, 8000, -1 )
    CreateMapEditorProp( $"mdl/foliage/plant_tropical_ground_leafy_01.rmdl", <-2239.56,-832.826,1215.65>, <0,15,0>, true, 8000, -1 )
    CreateMapEditorProp( $"mdl/foliage/plant_tropical_ground_leafy_01.rmdl", <-2432.7,-511.627,1215.39>, <0,-90,0>, true, 8000, -1 )
    CreateMapEditorProp( $"mdl/foliage/plant_tropical_ground_leafy_01.rmdl", <-1984.15,-1792.94,1215.7>, <0,15,0>, true, 8000, -1 )
    CreateMapEditorProp( $"mdl/foliage/plant_tropical_ground_leafy_01.rmdl", <-2048.23,-1343.37,1215.26>, <0,-165,0>, true, 8000, -1 )
    CreateMapEditorProp( $"mdl/foliage/tree_green_forest_med_01.rmdl", <2176.5,1791.2,953.683>, <0,0,0>, true, 8000, -1 )
	CreateMapEditorProp( $"mdl/foliage/grass_02_desert_large.rmdl", <2185.05,1781.14,939.460>, <0,0,0>, true, 8000, -1 )
	CreateMapEditorProp( $"mdl/foliage/bush_green_forest_01.rmdl", <-2687.71,3520.91,575.701>, <0,-135,0>, true, 8000, -1 )
    CreateMapEditorProp( $"mdl/foliage/bush_green_forest_01.rmdl", <-2751.9,3520.88,575.543>, <0,-135,0>, true, 8000, -1 )
    CreateMapEditorProp( $"mdl/foliage/bush_green_forest_01.rmdl", <-2815.94,3520.87,575.505>, <0,-135,0>, true, 8000, -1 )
    CreateMapEditorProp( $"mdl/foliage/bush_green_forest_01.rmdl", <-2176.91,4032.05,575.591>, <0,-45,0>, true, 8000, -1 )
    CreateMapEditorProp( $"mdl/foliage/bush_green_forest_01.rmdl", <-2176.91,4096.08,575.586>, <0,-45,0>, true, 8000, -1 )
    CreateMapEditorProp( $"mdl/foliage/bush_green_forest_01.rmdl", <-2176.88,4160.19,575.56>, <0,-45,0>, true, 8000, -1 )
    CreateMapEditorProp( $"mdl/foliage/bush_green_forest_01.rmdl", <-2176.85,4223.62,575.627>, <0,-45,0>, true, 8000, -1 )
    CreateMapEditorProp( $"mdl/foliage/bush_green_forest_01.rmdl", <1216.73,-3456.63,575.725>, <0,135,0>, true, 8000, -1 )
    CreateMapEditorProp( $"mdl/foliage/bush_green_forest_01.rmdl", <1216.86,-3392.27,575.576>, <0,135,0>, true, 8000, -1 )
    CreateMapEditorProp( $"mdl/foliage/bush_green_forest_01.rmdl", <1280.84,-3328.33,575.574>, <0,135,0>, true, 8000, -1 )
    CreateMapEditorProp( $"mdl/foliage/bush_green_forest_01.rmdl", <1279.74,-3456.39,575.116>, <0,15,0>, true, 8000, -1 )
    CreateMapEditorProp( $"mdl/foliage/bush_green_forest_01.rmdl", <1983.48,-3200.63,575.417>, <0,0,0>, true, 8000, -1 )
    CreateMapEditorProp( $"mdl/foliage/bush_green_forest_01.rmdl", <2047.47,-3200.68,575.486>, <0,0,0>, true, 8000, -1 )
    CreateMapEditorProp( $"mdl/foliage/bush_green_forest_01.rmdl", <2111.48,-3264.63,575.424>, <0,0,0>, true, 8000, -1 )
    CreateMapEditorProp( $"mdl/foliage/bush_green_forest_01.rmdl", <1983.47,-3136.61,575.403>, <0,0,0>, true, 8000, -1 )
    CreateMapEditorProp( $"mdl/containers/underbelly_cargo_container_128_red_01.rmdl", <1727.79,1024.48,703.149>, <0,-150,0>, true, 8000, -1 )
    CreateMapEditorProp( $"mdl/containers/underbelly_cargo_container_128_red_01.rmdl", <1344.24,1727.33,703.294>, <0,30,0>, true, 8000, -1 )
    CreateMapEditorProp( $"mdl/containers/container_medium_tanks_blue.rmdl", <383.785,1152.43,703.121>, <0,-150,0>, true, 8000, -1 )
    CreateMapEditorProp( $"mdl/containers/container_medium_tanks_blue.rmdl", <1088.25,703.257,703.381>, <0,30,0>, true, 8000, -1 )
    CreateMapEditorProp( $"mdl/containers/box_med_cardboard_01.rmdl", <575.911,1280.8,703.413>, <0,-105,0>, true, 8000, -1 )

    vector startingorg = <0,0,0>


    


    //Props
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1022.2640, 4628.7520, 574.9180 > + startingorg, < -90.0000, 59.7772, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 915.6472, 4690.8690, 574.8954 > + startingorg, < -89.8615, -83.6833, 143.4129 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 880.5435, 4639.3730, 512.9185 > + startingorg, < 0.0000, -120.2039, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 773.8673, 4701.5800, 512.9185 > + startingorg, < 0.0000, -120.2039, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 561.7797, 4825.5800, 512.9185 > + startingorg, < 0.0000, -120.2039, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 703.5596, 4814.8690, 574.8954 > + startingorg, < -89.8615, -83.6833, 143.4129 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 668.4558, 4763.3730, 512.9185 > + startingorg, < 0.0000, -120.2039, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 810.1767, 4752.7520, 574.9180 > + startingorg, < -90.0000, 59.7772, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1549.7040, 5076.0540, 582.0000 > + startingorg, < -90.0000, 90.4566, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1677.0070, 5012.8750, 520.0005 > + startingorg, < 0.0000, -89.5246, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1673.0910, 5075.0750, 581.9775 > + startingorg, < -89.8615, -53.0119, 143.4203 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1800.4930, 5011.9460, 520.0005 > + startingorg, < 0.0000, -89.5246, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -4210.2890, 2928.1280, 582.0000 > + startingorg, < -90.0000, -151.1878, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -4094.2310, 2846.1050, 520.0005 > + startingorg, < 0.0000, 28.8311, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -4239.5080, 2685.8480, 520.0005 > + startingorg, < 0.0000, 35.1688, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -4363.9120, 2754.5580, 582.0000 > + startingorg, < -90.0000, -144.8501, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -3955.9260, 2282.5080, 520.0005 > + startingorg, < 0.0000, 35.1688, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -4080.3470, 2351.3280, 581.9775 > + startingorg, < -89.8630, 71.6824, 143.4196 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -4026.9780, 2383.5100, 520.0005 > + startingorg, < 0.0000, 35.1688, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -4151.3820, 2452.2200, 582.0000 > + startingorg, < -90.0000, -144.8501, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -4168.7250, 2585.1130, 520.0005 > + startingorg, < 0.0000, 35.1688, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -4293.1290, 2653.8230, 582.0000 > + startingorg, < -90.0000, -144.8501, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -4097.6730, 2484.1110, 520.0005 > + startingorg, < 0.0000, 35.1688, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -4222.1160, 2552.8890, 582.0000 > + startingorg, < -90.0000, -144.8501, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/pipes/pipe_modular_painted_yellow_16.rmdl", < 3106.0000, -70.0000, 938.6000 > + startingorg, < 0.0000, 0.0000, 0.0000 >, true, 50000, -1, 1.3);
    CreateMapEditorProp( $"mdl/pipes/pipe_modular_painted_yellow_16.rmdl", < 3106.0000, -70.0000, 930.0000 > + startingorg, < 0.0000, 0.0000, 0.0000 >, true, 50000, -1, 1.3);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_column01_40x128_dirty_a.rmdl", < 4430.0000, -1797.0000, 469.0005 > + startingorg, < 0.0000, 0.0000, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 4481.9510, -1948.0720, 520.0005 > + startingorg, < 0.0000, -130.0286, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 4619.8350, -1982.7710, 582.0000 > + startingorg, < -90.0000, 49.9526, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 4669.2310, -2105.8200, 520.0005 > + startingorg, < 0.0000, -130.0286, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 4807.0580, -2140.4630, 582.0000 > + startingorg, < -90.0000, 49.9526, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 4574.7290, -2026.3240, 520.0005 > + startingorg, < 0.0000, -130.0286, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 4712.6140, -2061.0230, 582.0000 > + startingorg, < -90.0000, 49.9526, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_column01_40x128_dirty_a.rmdl", < 3860.0000, -2366.0000, 469.0005 > + startingorg, < 0.0000, 0.0000, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 3031.2040, -3396.2340, 520.0005 > + startingorg, < 0.0000, 95.1535, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2908.2040, -3407.2340, 520.0005 > + startingorg, < 0.0000, 95.1535, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2909.4000, -3469.5830, 582.0000 > + startingorg, < -90.0000, -84.8654, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2786.4790, -3480.5830, 582.0000 > + startingorg, < -90.0000, -84.8654, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/desertlands/construction_bldg_platform_04_corner.rmdl", < -210.8703, -1022.7400, 1260.1350 > + startingorg, < 4.1008, -17.7584, -2.7917 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1280.5020, -2185.1360, 1197.5770 > + startingorg, < 0.0000, -99.7329, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1214.2740, 2820.5010, 829.0771 > + startingorg, < 0.0000, -9.0903, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1901.9690, 1585.3190, 1048.0000 > + startingorg, < 90.0000, 31.1714, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_column01_40x128_dirty_a.rmdl", < 839.0002, 975.0007, 826.0005 > + startingorg, < 0.0000, 30.5130, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2052.8150, 2013.6260, 918.0005 > + startingorg, < 0.0000, -59.1546, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1529.7260, -1940.4990, 1075.5770 > + startingorg, < 0.0000, -9.0903, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -4064.6050, 2633.0540, 1977.0000 > + startingorg, < -90.0000, -65.3040, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1333.3830, 754.7301, 700.0771 > + startingorg, < 0.0000, -64.5558, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/containers/underbelly_cargo_container_128_red_02.rmdl", < -1217.1240, 2327.8840, 834.9526 > + startingorg, < 0.0000, -49.0797, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_02.rmdl", < -1934.0540, -3105.3080, 2493.9220 > + startingorg, < 0.0000, -17.3116, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 806.7003, 3110.4330, 790.0005 > + startingorg, < 0.0000, 42.5120, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1333.3830, 754.7301, 823.0771 > + startingorg, < 0.0000, -64.5558, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1558.0190, 546.2936, 1120.4540 > + startingorg, < -0.7399, -60.8484, -5.1692 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2599.7710, -140.4068, 781.0005 > + startingorg, < 0.0000, 109.8747, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1548.0330, 550.0198, 1191.8640 > + startingorg, < 84.7783, -142.7255, -81.4594 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 3337.5240, 600.2608, 2004.0000 > + startingorg, < 0.0000, 26.8554, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_rooftop_01.rmdl", < -1331.0030, 5048.0030, 543.0005 > + startingorg, < 0.0000, 0.0000, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1538.6500, 2590.2570, 1197.5770 > + startingorg, < 0.0000, -116.6361, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1262.9110, 2677.7940, 829.0771 > + startingorg, < 0.0000, -44.8131, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_02.rmdl", < -4220.2920, 1019.1220, 1527.9220 > + startingorg, < 0.0000, -172.5304, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2489.7060, 2504.7810, 919.0002 > + startingorg, < 0.0000, 121.8182, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 650.9488, 3280.9000, 790.0005 > + startingorg, < 0.0000, -46.7805, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2462.8920, 1922.1110, 994.0000 > + startingorg, < 90.0000, -148.6756, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1379.7290, 3054.7160, 951.0771 > + startingorg, < 0.0000, 62.5265, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1142.3110, -1738.6440, 1196.0770 > + startingorg, < 0.0000, 117.9073, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1606.2820, 2625.8040, 952.5771 > + startingorg, < 0.0000, -135.0176, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -4202.6050, 2638.0540, 1977.0000 > + startingorg, < -90.0000, -65.3040, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1214.2740, 2820.5010, 706.0771 > + startingorg, < 0.0000, -9.0903, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -3930.0500, 2578.6650, 2049.0000 > + startingorg, < 0.0000, 25.3541, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_02.rmdl", < -4535.9020, 1900.4290, 2382.1620 > + startingorg, < -18.8778, -46.4835, -95.3110 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1049.6920, -2011.5790, 1075.5770 > + startingorg, < 0.0000, -170.8390, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_rooftop_01.rmdl", < -909.2095, -4313.5300, 1127.5000 > + startingorg, < 0.0000, 4.2552, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1358.8210, -2173.6540, 1197.5770 > + startingorg, < 0.0000, -81.1128, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_wallrun_03.rmdl", < -3616.0000, 361.9997, 1906.5000 > + startingorg, < 0.0000, -140.5318, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_wallrun_02.rmdl", < -1445.1860, -3935.6320, 2314.0000 > + startingorg, < 0.0000, -151.9449, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1262.9110, 2677.7940, 952.5771 > + startingorg, < 0.0000, -44.8131, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1205.3500, -2170.7430, 829.0771 > + startingorg, < 0.0000, -116.6361, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 949.2862, 1575.3270, 700.0771 > + startingorg, < 0.0000, -55.5848, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/canyonlands/fabric_canopy_pole_256_01.rmdl", < 181.1489, 3829.0520, 668.6074 > + startingorg, < 0.0000, 0.0000, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2599.7710, -140.4068, 717.0005 > + startingorg, < 0.0000, 109.8747, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -4039.5850, 2537.7490, 2049.0000 > + startingorg, < 0.0000, -65.3087, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1210.5130, -1705.1360, 706.0771 > + startingorg, < 0.0000, 99.4343, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -4039.1050, 2575.5540, 1977.0000 > + startingorg, < -90.0000, -65.3040, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_corner_cap_01_a.rmdl", < -486.5946, 5008.4920, 565.0004 > + startingorg, < 0.0000, 153.9872, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1210.5130, -1703.8560, 829.0771 > + startingorg, < 0.0000, 99.4343, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_wallrun_03.rmdl", < -1739.0000, -3131.1170, 1533.5000 > + startingorg, < 0.0000, -153.5348, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2400.4470, 2030.3820, 918.0005 > + startingorg, < 0.0000, -148.8894, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_rooftop_01.rmdl", < 2720.2280, -4194.0260, 511.0005 > + startingorg, < 0.0000, -85.4092, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2416.4470, 1893.3740, 994.0000 > + startingorg, < 90.0000, -148.6756, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1726.1770, 3057.0100, 734.0005 > + startingorg, < 0.0000, -138.3042, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1694.3080, 2749.4210, 1075.5770 > + startingorg, < 0.0000, -170.8390, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2610.7060, 1519.7810, 666.0002 > + startingorg, < 0.0000, 121.8182, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1137.7180, -2135.1960, 829.0771 > + startingorg, < 0.0000, -135.0176, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1288.4980, -1693.2130, 1074.0770 > + startingorg, < 0.0000, 80.8143, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1606.2820, 2625.8040, 1197.5770 > + startingorg, < 0.0000, -135.0176, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 3045.7060, 1569.7810, 918.0002 > + startingorg, < 0.0000, 121.8182, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1517.1940, -2017.2570, 1075.5770 > + startingorg, < 0.0000, -27.3782, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1517.1940, -2017.2570, 952.5771 > + startingorg, < 0.0000, -27.3782, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2238.0420, 1466.8760, 918.0005 > + startingorg, < 0.0000, -59.1546, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1463.4980, 2575.8650, 829.0771 > + startingorg, < 0.0000, -99.7329, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1262.9110, 2677.7940, 1075.5770 > + startingorg, < 0.0000, -44.8131, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1660.0360, 2679.8460, 1197.5770 > + startingorg, < 0.0000, -152.5263, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_wallrun_03.rmdl", < -1249.0010, -4135.2310, 1906.5000 > + startingorg, < 0.0000, -148.6012, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/containers/underbelly_cargo_container_128_red_02.rmdl", < -2061.8760, -159.9306, 1097.9530 > + startingorg, < 0.0000, 129.8628, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1607.5160, 434.1960, 1201.5810 > + startingorg, < 5.1883, 30.7730, -90.5436 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_corner_cap_01_a.rmdl", < -371.5946, 4953.4920, 565.0004 > + startingorg, < 0.0000, 153.9872, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1137.7180, -2135.1960, 706.0771 > + startingorg, < 0.0000, -135.0176, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_playback_04.rmdl", < -4504.1920, 1607.1660, 1674.9420 > + startingorg, < 10.6747, -147.8555, 0.4520 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 679.9241, 3308.1040, 860.0005 > + startingorg, < 0.0000, -46.7805, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1456.4660, 3067.3760, 1196.0770 > + startingorg, < 0.0000, 80.8143, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_rooftop_01.rmdl", < -4121.7260, 2012.6580, 1634.0000 > + startingorg, < 0.0000, 34.1100, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 3337.5240, 600.2608, 1878.0000 > + startingorg, < 0.0000, 26.8554, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1529.7260, -1940.4990, 706.0771 > + startingorg, < 0.0000, -9.0903, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/containers/underbelly_cargo_container_128_red_02.rmdl", < -1612.8990, 87.8900, 1069.9530 > + startingorg, < 0.0000, 29.8565, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -4175.6050, 2581.0540, 1977.0000 > + startingorg, < -90.0000, -65.3040, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2405.3950, 2019.9580, 918.0005 > + startingorg, < 0.0000, 121.8182, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 799.7893, 3119.6730, 860.0005 > + startingorg, < 0.0000, -46.7805, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1225.9140, 2897.5030, 1075.5770 > + startingorg, < 0.0000, 9.5296, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1694.3080, 2749.4210, 1197.5770 > + startingorg, < 0.0000, -170.8390, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -4340.6050, 2645.0540, 2121.0000 > + startingorg, < -90.0000, -65.3040, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1280.5020, -2185.1360, 1075.5770 > + startingorg, < 0.0000, -99.7329, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_rooftop_01.rmdl", < -2399.6720, 4828.0560, 878.0005 > + startingorg, < 0.0000, -59.3247, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_wallrun_03.rmdl", < -4051.6770, 852.7333, 1533.5000 > + startingorg, < 0.0000, 30.5374, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_wallrun_03.rmdl", < -4279.8570, 1008.2670, 2512.5000 > + startingorg, < 0.0000, 30.5374, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1083.9640, -2081.1540, 952.5771 > + startingorg, < 0.0000, -152.5263, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1601.6890, 3022.3560, 1196.0770 > + startingorg, < 0.0000, 117.9073, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1049.6920, -2011.5790, 952.5771 > + startingorg, < 0.0000, -170.8390, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1481.0890, -2083.2070, 952.5771 > + startingorg, < 0.0000, -44.8131, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1083.9640, -2081.1540, 706.0771 > + startingorg, < 0.0000, -152.5263, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_rooftop_01.rmdl", < -315.8793, 5424.7950, 919.0781 > + startingorg, < 0.2777, 176.9451, -0.2050 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1529.7260, -1940.4990, 829.0771 > + startingorg, < 0.0000, -9.0903, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_rooftop_01.rmdl", < 5187.3000, -2436.3310, 399.0005 > + startingorg, < 0.0000, 44.0898, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1694.3080, 2749.4210, 829.0771 > + startingorg, < 0.0000, -170.8390, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1385.1790, 2587.3470, 1075.5770 > + startingorg, < 0.0000, -81.1128, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_02.rmdl", < -1612.5720, -3598.3370, 2061.9220 > + startingorg, < 0.0000, 158.6911, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1083.9640, -2081.1540, 829.0771 > + startingorg, < 0.0000, -152.5263, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1601.6890, 3022.3560, 951.0771 > + startingorg, < 0.0000, 117.9073, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -4150.6050, 2524.0540, 2121.0000 > + startingorg, < -90.0000, -65.3040, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1049.6920, -2011.5790, 1197.5770 > + startingorg, < 0.0000, -170.8390, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/containers/underbelly_cargo_container_128_blue_02.rmdl", < -1510.6880, 906.5958, 1109.7510 > + startingorg, < 2.5877, -59.6467, 174.5653 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_large_01.rmdl", < -4479.8190, -519.0424, 4927.3240 > + startingorg, < -36.4160, -2.3426, 93.9421 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1964.1240, 1476.8810, 918.0005 > + startingorg, < 0.0000, 30.9576, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1694.3080, 2749.4210, 706.0771 > + startingorg, < 0.0000, -170.8390, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1430.1610, -1742.4980, 1197.5770 > + startingorg, < 0.0000, 45.0916, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1385.1790, 2587.3470, 952.5771 > + startingorg, < 0.0000, -81.1128, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2878.5040, 1619.2150, 918.0002 > + startingorg, < 0.0000, -148.8894, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1903.1610, 1723.0140, 1044.8970 > + startingorg, < 0.0000, 122.6392, -89.9530 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_wallrun_03.rmdl", < -1567.8790, -3725.3260, 2277.5000 > + startingorg, < 0.0000, 22.4678, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1916.3570, 2003.8360, 1048.0000 > + startingorg, < 90.0000, -59.5390, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1259.8890, 2964.6350, 1197.5770 > + startingorg, < 0.0000, 26.9646, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1657.4320, 2968.4520, 706.0771 > + startingorg, < 0.0000, 134.5260, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_column01_40x128_dirty_a.rmdl", < 809.0002, 956.0007, 826.0005 > + startingorg, < 0.0000, 30.5130, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1533.4870, 3055.8640, 1074.0770 > + startingorg, < 0.0000, 99.4343, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1912.8150, 2003.1260, 976.0005 > + startingorg, < 0.0000, -59.1546, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2018.8150, 2066.1260, 976.0005 > + startingorg, < 0.0000, -59.1546, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_wallrun_02.rmdl", < -1505.1860, -3935.6320, 2536.0000 > + startingorg, < 0.0000, -151.9449, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/containers/underbelly_cargo_container_128_red_02.rmdl", < -1152.6370, 318.3668, 1284.1800 > + startingorg, < 0.2914, -30.8948, -5.4935 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -4123.6050, 2467.0540, 2121.0000 > + startingorg, < -90.0000, -65.3040, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1484.1110, -1796.3650, 829.0771 > + startingorg, < 0.0000, 26.9646, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1086.5680, -1792.5480, 1196.0770 > + startingorg, < 0.0000, 134.5260, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1704.6040, 2825.5000, 706.0771 > + startingorg, < 0.0000, 171.1011, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_02.rmdl", < -1792.2830, -3104.2100, 1861.9220 > + startingorg, < 0.0000, 43.1949, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1225.9140, 2897.5030, 829.0771 > + startingorg, < 0.0000, 9.5296, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2300.2780, 1968.0370, 918.0005 > + startingorg, < 0.0000, -148.8894, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1953.3510, 1616.8600, 976.0005 > + startingorg, < 0.0000, 30.9576, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1316.6880, 2623.7540, 829.0771 > + startingorg, < 0.0000, -62.9401, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2272.0420, 1414.3760, 918.0005 > + startingorg, < 0.0000, -59.1546, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_02.rmdl", < -1664.1480, -3430.7530, 1694.4220 > + startingorg, < 0.0000, 158.6911, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/containers/underbelly_cargo_container_128_blue_02.rmdl", < -739.4376, -1342.3050, 1264.6340 > + startingorg, < 3.9445, 73.3543, 3.5379 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_playback_06.rmdl", < -1040.1690, -459.2502, 1049.6840 > + startingorg, < 22.7059, -104.7870, -23.5879 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1606.2820, 2625.8040, 1075.5770 > + startingorg, < 0.0000, -135.0176, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_large_01.rmdl", < -3517.8450, -2190.4820, 3585.0010 > + startingorg, < 0.0000, -75.4123, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_rooftop_01.rmdl", < -3936.9250, 2145.2710, 563.0005 > + startingorg, < 0.0000, 35.1031, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_large_01.rmdl", < -2711.8450, -2934.0680, 3271.0010 > + startingorg, < 0.0000, -75.4123, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2344.0420, 1529.8760, 976.0005 > + startingorg, < 0.0000, -59.1546, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2932.9560, 1649.2850, 993.9998 > + startingorg, < 90.0000, -149.2738, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1900.9170, 1582.7570, 976.0005 > + startingorg, < 0.0000, 30.9576, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_column01_40x128_dirty_a.rmdl", < 846.0006, 1008.0000, 702.0005 > + startingorg, < 0.0000, -14.1761, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_playback_06.rmdl", < -1575.7710, -927.2753, 1072.6840 > + startingorg, < 22.7059, 34.3213, -23.5879 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_corner_cap_01_a.rmdl", < -1372.9610, 4921.1680, 1718.0000 > + startingorg, < 0.0000, -179.8721, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2354.7300, 1998.1080, 994.0000 > + startingorg, < 90.0000, -149.2738, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1963.4070, 1480.4210, 1048.0000 > + startingorg, < 90.0000, 30.5732, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_02.rmdl", < -4112.3370, 822.5415, 1861.9220 > + startingorg, < 0.0000, 166.7606, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_wallrun_03.rmdl", < -1098.9170, -4301.9480, 1897.0000 > + startingorg, < 0.0000, 20.2798, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1463.4980, 2575.8650, 706.0771 > + startingorg, < 0.0000, -99.7329, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1280.5020, -2185.1360, 829.0771 > + startingorg, < 0.0000, -99.7329, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1538.6500, 2590.2570, 706.0771 > + startingorg, < 0.0000, -116.6361, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1729.4100, 3049.4060, 676.3638 > + startingorg, < -1.0522, 131.9069, 90.7296 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1052.0990, -1859.8370, 829.0771 > + startingorg, < 0.0000, 153.1051, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1673.5640, 3105.8440, 683.0005 > + startingorg, < 0.0000, -138.3042, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -4261.6050, 2473.0540, 2121.0000 > + startingorg, < -90.0000, -65.3040, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1142.3110, -1738.6440, 951.0771 > + startingorg, < 0.0000, 117.9073, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1226.8060, 2743.7440, 1197.5770 > + startingorg, < 0.0000, -27.3782, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_corner_cap_01_a.rmdl", < -486.5946, 5008.4920, 1122.0000 > + startingorg, < 0.0000, 153.9872, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2021.3750, 2065.0690, 1048.0000 > + startingorg, < 90.0000, -58.9408, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2983.6200, 1671.1350, 918.0002 > + startingorg, < 0.0000, 121.8182, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/containers/underbelly_cargo_container_128_blue_02.rmdl", < -1723.6880, 794.5958, 1137.7510 > + startingorg, < 2.5877, -59.6467, 174.5653 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1981.6200, 2255.1350, 666.0002 > + startingorg, < 0.0000, 121.8182, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1660.0360, 2679.8460, 1075.5770 > + startingorg, < 0.0000, -152.5263, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 668.0190, 398.3954, 823.0771 > + startingorg, < 0.0000, -59.6587, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_large_01.rmdl", < -4202.8180, -682.9636, 3054.0010 > + startingorg, < 0.0000, 36.4808, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1977.4010, 2262.0210, 741.9998 > + startingorg, < 90.0000, -149.2738, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_large_01.rmdl", < -4543.1180, -2232.6750, 5732.3240 > + startingorg, < -36.4160, 32.7230, 93.9422 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_wallrun_03.rmdl", < -1771.0000, -3232.0000, 2106.5000 > + startingorg, < 0.0000, 70.6413, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1533.4870, 3055.8640, 829.0771 > + startingorg, < 0.0000, 99.4343, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2548.6200, 1621.1350, 666.0002 > + startingorg, < 0.0000, 121.8182, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1364.2710, -1705.7480, 1196.0770 > + startingorg, < 0.0000, 62.5265, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_large_01.rmdl", < -4668.8190, 588.0364, 3192.0010 > + startingorg, < 0.0000, 36.4808, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_corner_cap_01_a.rmdl", < 3156.9830, -3471.9850, 733.0004 > + startingorg, < 0.0000, -86.2436, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1518.0860, -1863.4970, 829.0771 > + startingorg, < 0.0000, 9.5296, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_rooftop_01.rmdl", < 5187.3000, -2430.8310, 702.0005 > + startingorg, < 0.0000, 44.0898, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1137.7180, -2135.1960, 1197.5770 > + startingorg, < 0.0000, -135.0176, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_wallrun_03.rmdl", < -1688.0930, -3296.6690, 1906.5000 > + startingorg, < 0.0000, 3.5108, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -4039.5850, 2537.7490, 1986.0000 > + startingorg, < 0.0000, -65.3087, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1456.4660, 3067.3760, 951.0771 > + startingorg, < 0.0000, 80.8143, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_02.rmdl", < -1725.9560, -3598.3370, 2271.9220 > + startingorg, < 0.0000, 158.6911, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_playback_06.rmdl", < -244.4752, 1049.0810, 756.6836 > + startingorg, < 22.7059, -60.2699, -23.5879 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_corner_cap_01_a.rmdl", < -2110.1250, 4306.2150, 1605.0000 > + startingorg, < 0.0000, -150.1494, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -4150.5850, 2486.7490, 1986.0000 > + startingorg, < 0.0000, -65.3087, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1691.9010, 2901.1640, 706.0771 > + startingorg, < 0.0000, 153.1051, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_02.rmdl", < -1785.9560, -3598.3370, 2493.9220 > + startingorg, < 0.0000, 158.6911, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 308.0191, 1167.3950, 823.0771 > + startingorg, < 0.0000, -59.6587, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2238.0420, 1466.8760, 976.0005 > + startingorg, < 0.0000, -59.1546, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1481.0890, -2083.2070, 1197.5770 > + startingorg, < 0.0000, -44.8131, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_large_01.rmdl", < -3294.8450, -2729.4820, 3755.0010 > + startingorg, < 0.0000, -75.4123, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 3337.5240, 600.2608, 1941.0000 > + startingorg, < 0.0000, 26.8554, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_large_01.rmdl", < -3806.4320, -2023.3580, 4284.3240 > + startingorg, < -36.4159, -146.5997, 93.9422 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_rooftop_01.rmdl", < 3960.5730, -3876.8300, 555.0005 > + startingorg, < 0.0000, -64.1365, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/containers/underbelly_cargo_container_128_red_02.rmdl", < 982.8983, -1576.0610, 834.9526 > + startingorg, < 0.0000, -66.4237, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2463.9380, 1924.6760, 918.0005 > + startingorg, < 0.0000, -148.8894, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_rooftop_01.rmdl", < 2717.2280, -4190.0260, 830.0005 > + startingorg, < 0.0000, -85.4092, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1316.6880, 2623.7540, 1075.5770 > + startingorg, < 0.0000, -62.9401, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_wallrun_03.rmdl", < -4225.7380, 1008.2670, 2200.8500 > + startingorg, < 0.0000, 30.5374, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -4039.5850, 2537.7490, 2112.0000 > + startingorg, < 0.0000, -65.3087, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1205.3500, -2170.7430, 1075.5770 > + startingorg, < 0.0000, -116.6361, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2378.0420, 1477.3760, 976.0005 > + startingorg, < 0.0000, -59.1546, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1225.9140, 2897.5030, 952.5771 > + startingorg, < 0.0000, 9.5296, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1142.3110, -1738.6440, 1074.0770 > + startingorg, < 0.0000, 117.9073, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_rooftop_01.rmdl", < 1763.1430, -4402.0740, 3035.0000 > + startingorg, < 0.0000, -142.1790, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_02.rmdl", < -4460.6680, 1512.0340, 1454.4220 > + startingorg, < 0.0000, -133.8349, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_wallrun_03.rmdl", < -4198.3220, 1008.2670, 1906.5000 > + startingorg, < 0.0000, 30.5374, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1083.9640, -2081.1540, 1075.5770 > + startingorg, < 0.0000, -152.5263, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1225.9140, 2897.5030, 1197.5770 > + startingorg, < 0.0000, 9.5296, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/containers/underbelly_cargo_container_128_red_02.rmdl", < -1612.8990, 87.8900, 1153.9530 > + startingorg, < 0.0000, 29.8565, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1900.9170, 1582.7570, 918.0005 > + startingorg, < 0.0000, 30.9576, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1481.0890, -2083.2070, 706.0771 > + startingorg, < 0.0000, -44.8131, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1313.8390, 3018.5020, 1197.5770 > + startingorg, < 0.0000, 45.0916, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1726.1770, 3057.0100, 683.0005 > + startingorg, < 0.0000, -138.3042, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1976.6730, 2265.5600, 666.0002 > + startingorg, < 0.0000, -148.8894, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/containers/underbelly_cargo_container_128_red_02.rmdl", < -1007.8990, 417.8802, 1092.9530 > + startingorg, < 0.0000, 29.8565, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2630.0880, -224.1846, 851.0005 > + startingorg, < 0.0000, -160.8329, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1423.5810, -2258.1530, 676.3638 > + startingorg, < -1.0522, -72.2724, 90.7296 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_02.rmdl", < -4193.8720, 822.5415, 2467.9220 > + startingorg, < 0.0000, 166.7606, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_large_01.rmdl", < -3972.1180, -2582.6410, 4924.3240 > + startingorg, < -36.4160, 32.7230, 93.9422 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2401.1760, 2026.8440, 994.0000 > + startingorg, < 90.0000, -149.2738, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1364.2710, -1706.2840, 706.0771 > + startingorg, < 0.0000, 62.5265, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 253.0191, 1135.3950, 823.0771 > + startingorg, < 0.0000, -59.6587, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1225.9140, 2897.5030, 706.0771 > + startingorg, < 0.0000, 9.5296, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 949.2862, 1575.3270, 823.0771 > + startingorg, < 0.0000, -55.5848, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1876.5040, 2203.2150, 666.0002 > + startingorg, < 0.0000, -148.8894, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_02.rmdl", < -2055.6990, -2850.0790, 2268.4220 > + startingorg, < 0.0000, 45.1589, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/containers/underbelly_cargo_container_128_red_02.rmdl", < -1077.6370, 272.3668, 1282.1800 > + startingorg, < 0.2914, -30.8948, -5.4935 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_wallrun_03.rmdl", < -4536.7270, 1381.0370, 2161.8500 > + startingorg, < 0.0000, -145.4653, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1463.4980, 2575.8650, 952.5771 > + startingorg, < 0.0000, -99.7329, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_02.rmdl", < -4198.0420, 1081.6630, 1444.5480 > + startingorg, < 11.4164, 14.4611, -95.4532 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1660.0360, 2679.8460, 829.0771 > + startingorg, < 0.0000, -152.5263, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_wallrun_02.rmdl", < -3814.4150, 527.9996, 2198.3500 > + startingorg, < 0.0000, -143.8754, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1349.5180, -2286.7650, 683.0005 > + startingorg, < 0.0000, 17.5165, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -4286.6050, 2530.0540, 2121.0000 > + startingorg, < -90.0000, -65.3040, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_rooftop_01.rmdl", < 1763.1430, -4402.0740, 2430.0000 > + startingorg, < 0.0000, -142.1790, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/containers/underbelly_cargo_container_128_blue_02.rmdl", < -1591.7380, 870.1613, 1118.3960 > + startingorg, < 1.4427, -62.3856, 83.6463 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1214.2740, 2820.5010, 1197.5770 > + startingorg, < 0.0000, -9.0903, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_02.rmdl", < -4355.5930, 1289.9000, 2156.2720 > + startingorg, < 0.0000, -9.2421, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1390.9140, 781.9181, 700.0771 > + startingorg, < 0.0000, -64.5558, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_wallrun_03.rmdl", < -4795.9540, 1738.9280, 1906.5000 > + startingorg, < 0.0000, 43.4656, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1316.6880, 2623.7540, 1197.5770 > + startingorg, < 0.0000, -62.9401, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 53.4323, 3785.4550, 759.0000 > + startingorg, < -90.0000, -48.0783, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_02.rmdl", < -4206.7830, 1101.3230, 1527.9220 > + startingorg, < 0.0000, 11.4669, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1953.3510, 1616.8600, 918.0005 > + startingorg, < 0.0000, 30.9576, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -4261.6050, 2473.0540, 1977.0000 > + startingorg, < -90.0000, -65.3040, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1694.3080, 2749.4210, 952.5771 > + startingorg, < 0.0000, -170.8390, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1484.1110, -1796.3650, 706.0771 > + startingorg, < 0.0000, 26.9646, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_column01_40x128_dirty_a.rmdl", < 809.0002, 956.0007, 702.0005 > + startingorg, < 0.0000, 30.5130, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_corner_cap_01_a.rmdl", < -486.5946, 5008.4920, 846.0004 > + startingorg, < 0.0000, 153.9872, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1484.1110, -1796.3650, 1075.5770 > + startingorg, < 0.0000, 26.9646, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_large_01.rmdl", < -4867.5070, -1087.6750, 5330.0010 > + startingorg, < 0.0000, -125.4285, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_02.rmdl", < -4139.7520, 822.5415, 2156.2720 > + startingorg, < 0.0000, 166.7606, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1430.1610, -1742.4980, 952.5771 > + startingorg, < 0.0000, 45.0916, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -4175.6050, 2581.0540, 2121.0000 > + startingorg, < -90.0000, -65.3040, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_02.rmdl", < -3351.5310, -1358.9700, 1624.8430 > + startingorg, < 78.1344, 77.0360, 127.1316 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1052.0990, -1859.8370, 1074.0770 > + startingorg, < 0.0000, 153.1051, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_large_01.rmdl", < -1673.8190, -4293.9640, 2162.0010 > + startingorg, < 0.0000, 36.4808, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_02.rmdl", < -4328.1780, 1289.9000, 1861.9220 > + startingorg, < 0.0000, -9.2421, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_playback_06.rmdl", < -2042.8940, 1702.7230, 865.2115 > + startingorg, < 5.3266, 35.0645, -24.5932 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_02.rmdl", < -1612.5720, -3598.3370, 1861.9220 > + startingorg, < 0.0000, 158.6911, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 668.0190, 398.3954, 700.0771 > + startingorg, < 0.0000, -59.6587, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2277.2950, 1404.3570, 1044.8970 > + startingorg, < 0.0000, 32.5270, -89.9530 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_wallrun_02.rmdl", < -1395.0000, -3948.9990, 2104.0000 > + startingorg, < 0.0000, -6.9135, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_corner_cap_01_a.rmdl", < -371.5946, 4953.4920, 846.0004 > + startingorg, < 0.0000, 153.9872, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_02.rmdl", < -1837.8370, -3105.3080, 2061.9220 > + startingorg, < 0.0000, -17.3116, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_large_01.rmdl", < -5368.7610, -1557.8590, 3765.7940 > + startingorg, < 0.0000, 71.5465, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1039.3960, -1935.5000, 1198.0770 > + startingorg, < 0.0000, 171.1011, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1533.4870, 3055.8640, 706.0771 > + startingorg, < 0.0000, 99.4343, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_02.rmdl", < -1842.7970, -2912.8630, 1454.4220 > + startingorg, < 0.0000, -141.9044, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2566.1550, -152.9111, 717.0005 > + startingorg, < 0.0000, 109.8747, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_large_01.rmdl", < -4622.8450, 914.5182, 3155.0010 > + startingorg, < 0.0000, -75.4123, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2363.7670, 1862.3290, 918.0005 > + startingorg, < 0.0000, -148.8894, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1039.3960, -1935.5000, 953.0771 > + startingorg, < 0.0000, 171.1011, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_02.rmdl", < -1613.8530, -3309.0590, 1527.9220 > + startingorg, < 0.0000, 3.3974, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_rooftop_01.rmdl", < -315.8793, 5438.7950, 300.0781 > + startingorg, < 0.2777, 176.9451, -0.2050 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_rooftop_01.rmdl", < 1082.7910, -4517.5300, 511.0005 > + startingorg, < 0.0000, 4.2552, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_corner_cap_01_a.rmdl", < -371.5946, 4953.4920, 1122.0000 > + startingorg, < 0.0000, 153.9872, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1364.2710, -1705.7480, 829.0771 > + startingorg, < 0.0000, 62.5265, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1086.5680, -1792.5480, 829.0771 > + startingorg, < 0.0000, 134.5260, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_rooftop_01.rmdl", < 650.7903, -4554.0300, 832.0005 > + startingorg, < 0.0000, 4.2552, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_large_01.rmdl", < -5556.8190, -1089.9640, 5434.0010 > + startingorg, < 0.0000, 36.4808, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_02.rmdl", < -3848.2660, 483.9170, 1480.4220 > + startingorg, < 0.0000, 42.1678, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1673.5640, 3105.8440, 734.0005 > + startingorg, < 0.0000, -138.3042, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_column01_40x128_dirty_a.rmdl", < 831.0006, 941.0004, 702.0005 > + startingorg, < 0.0000, -14.1761, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/containers/underbelly_cargo_container_128_red_02.rmdl", < -1218.4130, 213.7749, 1296.1800 > + startingorg, < 0.2914, -30.8948, -5.4935 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_02.rmdl", < -2115.6990, -2850.0790, 2490.4220 > + startingorg, < 0.0000, 45.1589, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2635.1550, -360.9111, 717.0005 > + startingorg, < 0.0000, 109.8747, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_wallrun_02.rmdl", < -4700.6730, 1561.0480, 2198.3500 > + startingorg, < 0.0000, 40.1219, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1039.3960, -1935.5000, 829.0771 > + startingorg, < 0.0000, 171.1011, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1259.8890, 2964.6350, 829.0771 > + startingorg, < 0.0000, 26.9646, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -4150.6050, 2524.0540, 1977.0000 > + startingorg, < -90.0000, -65.3040, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1137.7180, -2135.1960, 952.5771 > + startingorg, < 0.0000, -135.0176, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_wallrun_03.rmdl", < -1305.9670, -4159.4730, 1486.0000 > + startingorg, < 0.0000, 20.2798, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2423.4010, 2613.0210, 994.9998 > + startingorg, < 90.0000, -149.2738, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1379.7290, 3054.7160, 829.0771 > + startingorg, < 0.0000, 62.5265, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_column01_40x128_dirty_a.rmdl", < 831.0006, 941.0004, 827.0005 > + startingorg, < 0.0000, -14.1761, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_large_01.rmdl", < -5373.6480, 1335.8270, 3355.0010 > + startingorg, < 0.0000, -119.7670, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1390.9140, 781.9181, 823.0771 > + startingorg, < 0.0000, -64.5558, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/containers/underbelly_cargo_container_128_red_02.rmdl", < -1007.8990, 417.8802, 1008.9530 > + startingorg, < 0.0000, 29.8565, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1205.3500, -2170.7430, 1197.5770 > + startingorg, < 0.0000, -116.6361, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_wallrun_02.rmdl", < -1331.8020, -3935.6320, 1904.0000 > + startingorg, < 0.0000, -151.9449, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 738.7565, 3184.5780, 860.0005 > + startingorg, < 0.0000, 42.5120, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2272.0420, 1414.3760, 976.0005 > + startingorg, < 0.0000, -59.1546, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 3056.7740, 1508.1280, 710.0000 > + startingorg, < -90.0000, -58.9181, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_corner_cap_01_a.rmdl", < -801.0410, 5178.0110, 565.0004 > + startingorg, < 0.0000, 89.9699, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/pipes/slum_pipe_large_blue_256_01.rmdl", < 1284.0020, -1937.9950, 680.0023 > + startingorg, < 0.0000, 0.0000, 0.0000 >, true, 50000, -1, 5);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_wallrun_03.rmdl", < -1402.0000, -3767.2290, 1525.0000 > + startingorg, < 0.0000, 20.2798, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_wallrun_02.rmdl", < -4754.7920, 1561.0480, 2510.0000 > + startingorg, < 0.0000, 40.1219, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1427.3120, -2137.2460, 1075.5770 > + startingorg, < 0.0000, -62.9401, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_rooftop_01.rmdl", < -685.7239, 6015.3900, 722.0005 > + startingorg, < 0.0000, 88.2257, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1538.6500, 2590.2570, 829.0771 > + startingorg, < 0.0000, -116.6361, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_corner_cap_01_a.rmdl", < -3028.8910, 3780.9000, 1576.0020 > + startingorg, < -86.9981, -70.0681, -80.7927 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/pipes/slum_pipe_large_blue_256_01.rmdl", < -1459.9980, 2823.0050, 680.0023 > + startingorg, < 0.0000, 0.0000, 0.0000 >, true, 50000, -1, 5);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_02.rmdl", < -3139.2660, -1516.0830, 1339.4220 > + startingorg, < 0.0000, 42.1678, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1517.1940, -2017.2570, 829.0771 > + startingorg, < 0.0000, -27.3782, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1616.1390, 440.0866, 1130.8380 > + startingorg, < -0.7399, -60.8484, -5.1692 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2422.6730, 2616.5600, 919.0002 > + startingorg, < 0.0000, -148.8894, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1288.4980, -1693.2130, 829.0771 > + startingorg, < 0.0000, 80.8143, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1657.4320, 2968.4520, 951.0771 > + startingorg, < 0.0000, 134.5260, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_02.rmdl", < -1942.3150, -2850.0790, 2058.4220 > + startingorg, < 0.0000, 45.1589, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 806.7003, 3110.4330, 860.0005 > + startingorg, < 0.0000, 42.5120, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1086.5680, -1792.5480, 1074.0770 > + startingorg, < 0.0000, 134.5260, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_wallrun_03.rmdl", < -4320.0000, 1314.0000, 1533.5000 > + startingorg, < 0.0000, -145.4653, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 363.0191, 1199.3950, 823.0771 > + startingorg, < 0.0000, -59.6587, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1349.5180, -2286.7650, 734.0005 > + startingorg, < 0.0000, 17.5165, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_rooftop_01.rmdl", < 1168.7910, -4520.0300, 1154.0000 > + startingorg, < 0.0000, 4.2552, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1379.7290, 3054.7160, 1074.0770 > + startingorg, < 0.0000, 62.5265, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_corner_cap_01_a.rmdl", < -801.0410, 5178.0110, 851.0004 > + startingorg, < 0.0000, 89.9699, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 3337.5240, 600.2608, 2065.0000 > + startingorg, < 0.0000, 26.8554, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1704.6040, 2825.5000, 829.0771 > + startingorg, < 0.0000, 171.1011, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_wallrun_03.rmdl", < -4025.1440, 577.3645, 1867.5000 > + startingorg, < 0.0000, -140.5318, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_large_01.rmdl", < -5373.6480, 144.1234, 4381.5010 > + startingorg, < 0.0000, -119.7670, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_rooftop_01.rmdl", < 3122.4290, -4295.4550, 671.0005 > + startingorg, < 0.0000, -79.8756, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -4234.6050, 2416.0540, 2121.0000 > + startingorg, < -90.0000, -65.3040, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2543.6730, 1631.5600, 666.0002 > + startingorg, < 0.0000, -148.8894, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2597.0880, -129.1846, 781.0005 > + startingorg, < 0.0000, -160.8329, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/containers/underbelly_cargo_container_128_red_02.rmdl", < -2061.8760, -159.9306, 1185.9530 > + startingorg, < 0.0000, 129.8628, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1463.4980, 2575.8650, 1075.5770 > + startingorg, < 0.0000, -99.7329, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1287.5340, -1693.6240, 706.0771 > + startingorg, < 0.0000, 80.8143, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 825.6987, 3144.4750, 860.0005 > + startingorg, < 0.0000, -46.7805, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_column01_40x128_dirty_a.rmdl", < 819.0002, 1007.0010, 702.0005 > + startingorg, < 0.0000, 30.5130, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_corner_cap_01_a.rmdl", < -2495.8910, 4091.9000, 1576.0020 > + startingorg, < -86.9981, -70.0681, -80.7927 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1946.8150, 1950.6260, 918.0005 > + startingorg, < 0.0000, -59.1546, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_wallrun_03.rmdl", < -4509.3120, 1381.0370, 1867.5000 > + startingorg, < 0.0000, -145.4653, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1288.4980, -1693.2130, 951.0771 > + startingorg, < 0.0000, 80.8143, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_02.rmdl", < -3334.8770, -1255.7810, 1339.4220 > + startingorg, < 0.0000, -147.4711, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2529.3950, 1812.9580, 918.0005 > + startingorg, < 0.0000, 121.8182, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2566.1550, -152.9111, 781.0005 > + startingorg, < 0.0000, 109.8747, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_large_01.rmdl", < -3034.9400, -3463.0520, 4185.0010 > + startingorg, < 0.0000, -83.9696, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_wallrun_03.rmdl", < -1801.4770, -3296.6690, 2316.5000 > + startingorg, < 0.0000, -49.0691, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1313.7580, 3018.5020, 1075.5770 > + startingorg, < 0.0000, 45.0916, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_02.rmdl", < -4662.9020, 1993.4290, 2382.1620 > + startingorg, < -18.8778, -46.4835, -95.3110 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 144.4323, 3866.9550, 759.0000 > + startingorg, < -90.0000, -48.0783, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -4256.5850, 2437.7490, 2112.0000 > + startingorg, < 0.0000, -65.3087, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2672.5390, -347.4154, 781.0005 > + startingorg, < 0.0000, 109.8747, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_wallrun_03.rmdl", < -1540.0000, -3725.3260, 2067.5000 > + startingorg, < 0.0000, 22.4678, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_rooftop_01.rmdl", < 4698.3000, -2927.3310, 399.0005 > + startingorg, < 0.0000, 44.0898, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1385.1790, 2587.3470, 829.0771 > + startingorg, < 0.0000, -81.1128, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2635.1550, -360.9111, 851.0005 > + startingorg, < 0.0000, 109.8747, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2408.7740, 2590.1280, 703.0000 > + startingorg, < -90.0000, -58.9181, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_column01_40x128_dirty_a.rmdl", < 871.0006, 967.0004, 827.0005 > + startingorg, < 0.0000, -14.1761, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -4150.5850, 2486.7490, 2049.0000 > + startingorg, < 0.0000, -65.3087, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2635.1550, -360.9111, 781.0005 > + startingorg, < 0.0000, 109.8747, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_playback_06.rmdl", < 97.8313, 614.7498, 819.6836 > + startingorg, < 22.7059, -104.7870, -23.5879 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_rooftop_01.rmdl", < -1331.0030, 5048.0030, 543.0005 > + startingorg, < 0.0000, 0.0000, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_playback_06.rmdl", < -3144.4750, 421.0812, 1092.6840 > + startingorg, < 22.7059, -60.2699, -23.5879 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1416.3600, 550.5212, 1109.9510 > + startingorg, < -0.7399, -60.8484, -5.1692 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1385.1790, 2587.3470, 706.0771 > + startingorg, < 0.0000, -81.1128, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_rooftop_01.rmdl", < -4276.9250, 1737.2710, 682.0005 > + startingorg, < 0.0000, 35.1031, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_large_01.rmdl", < -4192.8190, -682.9636, 3659.0010 > + startingorg, < 0.0000, 36.4808, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2443.5040, 1569.2150, 666.0002 > + startingorg, < 0.0000, -148.8894, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1417.5180, -2263.7650, 683.0005 > + startingorg, < 0.0000, 17.5165, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -4256.5850, 2437.7490, 2049.0000 > + startingorg, < 0.0000, -65.3087, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1052.0990, -1859.8370, 951.0771 > + startingorg, < 0.0000, 153.1051, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1001.8740, 1611.1530, 823.0771 > + startingorg, < 0.0000, -55.5848, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1523.8070, 491.0515, 1121.0560 > + startingorg, < -0.7399, -60.8484, -5.1692 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1280.5020, -2185.1360, 952.5771 > + startingorg, < 0.0000, -99.7329, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1385.1790, 2587.3470, 1197.5770 > + startingorg, < 0.0000, -81.1128, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_column01_40x128_dirty_a.rmdl", < 871.0006, 967.0004, 702.0005 > + startingorg, < 0.0000, -14.1761, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/canyonlands/fabric_canopy_pole_256_01.rmdl", < 91.1489, 3749.0520, 668.6074 > + startingorg, < 0.0000, 0.0000, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_rooftop_01.rmdl", < -315.8793, 5430.7950, 605.0781 > + startingorg, < 0.2777, 176.9451, -0.2050 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 778.0190, 462.3954, 823.0771 > + startingorg, < 0.0000, -59.6587, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/domestic/corgi_doll.rmdl", < 2137.0740, 2872.5410, 4373.2300 > + startingorg, < 0.0000, -80.7770, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_02.rmdl", < -1735.1480, -3443.7530, 2061.9220 > + startingorg, < 0.0000, 158.6911, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1606.2820, 2625.8040, 706.0771 > + startingorg, < 0.0000, -135.0176, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_large_01.rmdl", < -4201.1180, -2721.6410, 5471.3240 > + startingorg, < -36.4160, 32.7230, 93.9422 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1641.2530, 498.9810, 1201.2850 > + startingorg, < 84.7783, -142.7255, -81.4594 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -4286.6050, 2530.0540, 1977.0000 > + startingorg, < -90.0000, -65.3040, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_rooftop_01.rmdl", < -3936.9250, 2145.2710, 1172.0000 > + startingorg, < 0.0000, 35.1031, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_wallrun_03.rmdl", < -3971.0000, 672.0002, 1525.0000 > + startingorg, < 0.0000, 28.3493, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1657.4320, 2968.4520, 829.0771 > + startingorg, < 0.0000, 134.5260, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1052.0990, -1859.8370, 1196.0770 > + startingorg, < 0.0000, 153.1051, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_large_01.rmdl", < -2496.8190, -3919.9640, 3604.0010 > + startingorg, < 0.0000, 36.4808, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_playback_06.rmdl", < -961.8944, 1439.7230, 782.2115 > + startingorg, < 5.3266, 35.0645, -24.5932 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_large_01.rmdl", < -4422.8190, 50.9234, 3447.0010 > + startingorg, < 0.0000, 36.4808, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1649.9270, 494.8445, 1129.8380 > + startingorg, < -0.7399, -60.8484, -5.1692 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_rooftop_01.rmdl", < -3936.9250, 2145.2710, 1793.0000 > + startingorg, < 0.0000, 35.1031, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2630.0880, -224.1846, 781.0005 > + startingorg, < 0.0000, -160.8329, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1533.4870, 3055.8640, 951.0771 > + startingorg, < 0.0000, 99.4343, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1533.4870, 3055.8640, 1196.0770 > + startingorg, < 0.0000, 99.4343, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 91.4323, 3742.4550, 759.0000 > + startingorg, < -90.0000, -48.0783, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1313.7580, 3018.5020, 829.0771 > + startingorg, < 0.0000, 45.0916, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_large_01.rmdl", < -5457.8190, -603.6670, 4888.0010 > + startingorg, < 0.0000, 36.4808, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2408.7740, 2590.1280, 710.0000 > + startingorg, < -90.0000, -58.9181, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_column01_40x128_dirty_a.rmdl", < 870.0002, 994.0007, 702.0005 > + startingorg, < 0.0000, 30.5130, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -3930.0500, 2578.6650, 1986.0000 > + startingorg, < 0.0000, 25.3541, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_02.rmdl", < -4804.9020, 1891.4290, 2612.1620 > + startingorg, < -18.8778, -46.4835, -95.3110 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2597.0880, -129.1846, 851.0005 > + startingorg, < 0.0000, -160.8329, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_wallrun_03.rmdl", < -4590.8460, 1381.0370, 2473.5000 > + startingorg, < 0.0000, -145.4653, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2597.0880, -129.1846, 717.0005 > + startingorg, < 0.0000, -160.8329, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_corner_cap_01_a.rmdl", < -2857.8910, 3880.9000, 1576.0020 > + startingorg, < -86.9981, -70.0681, -80.7927 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1481.0890, -2083.2070, 1075.5770 > + startingorg, < 0.0000, -44.8131, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_corner_cap_01_a.rmdl", < -636.5322, 5081.8170, 1122.0000 > + startingorg, < 0.0000, 155.2334, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1657.4320, 2968.4520, 1196.0770 > + startingorg, < 0.0000, 134.5260, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1226.8060, 2743.7440, 952.5771 > + startingorg, < 0.0000, -27.3782, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1049.6920, -2011.5790, 829.0771 > + startingorg, < 0.0000, -170.8390, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -4150.5850, 2486.7490, 2112.0000 > + startingorg, < 0.0000, -65.3087, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_large_01.rmdl", < -4605.3030, -885.8181, 4632.3240 > + startingorg, < -36.4160, -168.9905, 93.9422 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_02.rmdl", < -4409.7120, 1289.9000, 2467.9220 > + startingorg, < 0.0000, -9.2421, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_large_01.rmdl", < -4956.8190, 239.9576, 4269.3240 > + startingorg, < -36.4160, -2.3426, 93.9421 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_playback_04.rmdl", < -4534.1920, 1647.1660, 1447.9420 > + startingorg, < 10.6747, -147.8555, 0.4520 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_rooftop_01.rmdl", < 650.7903, -4555.0300, 511.0005 > + startingorg, < 0.0000, 4.2552, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1304.6030, 601.7084, 1168.1840 > + startingorg, < 5.1883, 30.7730, -90.5436 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_rooftop_01.rmdl", < 4698.3000, -2921.8310, 702.0005 > + startingorg, < 0.0000, 44.0898, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 723.0190, 430.3954, 700.0771 > + startingorg, < 0.0000, -59.6587, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_playback_06.rmdl", < 339.5248, -245.9188, 709.6836 > + startingorg, < 22.7059, -60.2699, -23.5879 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2566.1550, -152.9111, 851.0005 > + startingorg, < 0.0000, 109.8747, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_rooftop_01.rmdl", < -909.2095, -4312.5300, 832.0005 > + startingorg, < 0.0000, 4.2552, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1205.3500, -2170.7430, 706.0771 > + startingorg, < 0.0000, -116.6361, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_wallrun_03.rmdl", < -1861.4770, -3296.6690, 2538.5000 > + startingorg, < 0.0000, 80.8703, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_playback_04.rmdl", < -4534.1920, 1647.1660, 1503.9420 > + startingorg, < 10.6747, -147.8555, 0.4520 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_column01_40x128_dirty_a.rmdl", < 804.0006, 984.0004, 827.0005 > + startingorg, < 0.0000, -14.1761, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/pipes/pipe_modular_painted_yellow_8.rmdl", < -1456.9850, 2822.0150, 1736.0000 > + startingorg, < 0.0000, 0.0000, 0.0000 >, true, 50000, -1, 28);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1691.9010, 2901.1640, 1196.0770 > + startingorg, < 0.0000, 153.1051, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_corner_cap_01_a.rmdl", < -1477.9610, 4921.1680, 1436.0000 > + startingorg, < 0.0000, -179.8721, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 650.9488, 3280.9000, 860.0005 > + startingorg, < 0.0000, -46.7805, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_column01_40x128_dirty_a.rmdl", < 804.0006, 984.0004, 702.0005 > + startingorg, < 0.0000, -14.1761, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1517.1940, -2017.2570, 1197.5770 > + startingorg, < 0.0000, -27.3782, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 253.0191, 1135.3950, 700.0771 > + startingorg, < 0.0000, -59.6587, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_rooftop_01.rmdl", < -3936.9250, 2145.2710, 867.0005 > + startingorg, < 0.0000, 35.1031, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -4229.6050, 2696.0540, 2121.0000 > + startingorg, < -90.0000, -65.3040, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2427.6200, 2606.1350, 919.0002 > + startingorg, < 0.0000, 121.8182, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1364.2710, -1705.7480, 1074.0770 > + startingorg, < 0.0000, 62.5265, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_wallrun_03.rmdl", < -3965.4150, 719.0002, 2161.8500 > + startingorg, < 0.0000, 30.5374, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1704.6040, 2825.5000, 1075.5770 > + startingorg, < 0.0000, 171.1011, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_wallrun_03.rmdl", < -3505.0000, 198.0002, 1897.0000 > + startingorg, < 0.0000, 28.3493, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_rooftop_01.rmdl", < 1763.1430, -4402.0740, 2732.0000 > + startingorg, < 0.0000, -142.1790, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/domestic/nessy_doll.rmdl", < 1912.9040, 3086.6840, 4372.1720 > + startingorg, < 0.0000, 100.7376, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -4313.6050, 2587.0540, 2121.0000 > + startingorg, < -90.0000, -65.3040, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_large_01.rmdl", < -1862.8560, -3809.7440, 2475.0010 > + startingorg, < 0.0000, 52.1884, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_corner_cap_01_a.rmdl", < -1305.9610, 4921.1680, 1436.0000 > + startingorg, < 0.0000, -179.8721, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/containers/underbelly_cargo_container_128_red_02.rmdl", < -2507.8850, -353.1250, 1188.9530 > + startingorg, < 0.0000, 46.4611, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2241.5840, 1467.5860, 1048.0000 > + startingorg, < 90.0000, -59.5390, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2344.0420, 1529.8760, 918.0005 > + startingorg, < 0.0000, -59.1546, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2378.0420, 1477.3760, 918.0005 > + startingorg, < 0.0000, -59.1546, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_corner_cap_01_a.rmdl", < -959.9609, 4902.1680, 1263.0000 > + startingorg, < 0.0000, -179.8721, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 799.7893, 3119.6730, 790.0005 > + startingorg, < 0.0000, -46.7805, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_02.rmdl", < -1942.3150, -2850.0790, 1858.4220 > + startingorg, < 0.0000, 45.1589, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1137.7180, -2135.1960, 1075.5770 > + startingorg, < 0.0000, -135.0176, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_wallrun_03.rmdl", < -3729.0000, 316.0007, 2311.0000 > + startingorg, < 57.8028, 16.8626, -85.8501 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 679.9241, 3308.1040, 790.0005 > + startingorg, < 0.0000, -46.7805, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1430.2420, -1740.8610, 829.0771 > + startingorg, < 0.0000, 45.0916, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_large_01.rmdl", < -4162.8180, 50.9234, 2475.0010 > + startingorg, < 0.0000, 36.4808, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/canyonlands/fabric_canopy_pole_256_01.rmdl", < 12.1489, 3839.0520, 668.6074 > + startingorg, < 0.0000, 0.0000, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_playback_04.rmdl", < -4563.1920, 1646.1660, 1662.9420 > + startingorg, < 10.6747, -147.8555, 0.4520 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 182.4323, 3823.9550, 759.0000 > + startingorg, < -90.0000, -48.0783, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1601.6890, 3022.3560, 829.0771 > + startingorg, < 0.0000, 117.9073, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_wallrun_03.rmdl", < -3595.0000, 316.0007, 2164.0000 > + startingorg, < -9.0228, 28.9917, -91.6680 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_large_01.rmdl", < -4583.5200, -2516.0610, 5719.0010 > + startingorg, < 0.0000, 78.3238, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 806.7003, 3110.4330, 726.0005 > + startingorg, < 0.0000, 42.5120, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_rooftop_01.rmdl", < 3960.5730, -3872.8300, 863.0005 > + startingorg, < 0.0000, -64.1365, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2544.4010, 1628.0210, 741.9998 > + startingorg, < 90.0000, -149.2738, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1358.8210, -2173.6540, 1075.5770 > + startingorg, < 0.0000, -81.1128, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1484.1110, -1796.3650, 1197.5770 > + startingorg, < 0.0000, 26.9646, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_column01_40x128_dirty_a.rmdl", < 839.0002, 974.0007, 702.0005 > + startingorg, < 0.0000, 30.5130, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_large_01.rmdl", < -3824.2310, -2481.2060, 4784.1170 > + startingorg, < -36.4160, -133.9249, 93.9422 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -4256.5850, 2437.7490, 1986.0000 > + startingorg, < 0.0000, -65.3087, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1226.8060, 2743.7440, 829.0771 > + startingorg, < 0.0000, -27.3782, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_rooftop_01.rmdl", < -2399.6720, 4828.0560, 568.0005 > + startingorg, < 0.0000, -59.3247, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1259.8890, 2964.6350, 952.5771 > + startingorg, < 0.0000, 26.9646, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1210.5130, -1703.8560, 1074.0770 > + startingorg, < 0.0000, 99.4343, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_wallrun_03.rmdl", < -4306.3220, 1205.2670, 1572.5000 > + startingorg, < 0.0000, 30.5374, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_large_01.rmdl", < -1974.8190, -4175.9640, 2943.0010 > + startingorg, < 0.0000, 36.4808, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1288.4980, -1693.2130, 1196.0770 > + startingorg, < 0.0000, 80.8143, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_playback_04.rmdl", < -3768.6920, 502.1661, 1654.4420 > + startingorg, < 10.6747, -147.8555, 0.4520 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1601.6890, 3022.3560, 1074.0770 > + startingorg, < 0.0000, 117.9073, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 738.7565, 3184.5780, 790.0005 > + startingorg, < 0.0000, 42.5120, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 723.0190, 430.3954, 823.0771 > + startingorg, < 0.0000, -59.6587, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -4039.1050, 2575.5540, 2121.0000 > + startingorg, < -90.0000, -65.3040, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1606.2820, 2625.8040, 829.0771 > + startingorg, < 0.0000, -135.0176, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1448.4450, 809.1062, 823.0771 > + startingorg, < 0.0000, -64.5558, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2599.7710, -140.4068, 851.0005 > + startingorg, < 0.0000, 109.8747, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1210.5130, -1703.8560, 951.0771 > + startingorg, < 0.0000, 99.4343, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2484.2950, 1527.3570, 1044.8970 > + startingorg, < 0.0000, 32.5270, -89.9530 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1691.9010, 2901.1640, 829.0771 > + startingorg, < 0.0000, 153.1051, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1427.3120, -2137.2460, 1197.5770 > + startingorg, < 0.0000, -62.9401, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_large_01.rmdl", < -4875.5200, -1861.4930, 6027.0010 > + startingorg, < 0.0000, 78.3238, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1481.0890, -2083.2070, 829.0771 > + startingorg, < 0.0000, -44.8131, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1657.4320, 2968.4520, 1074.0770 > + startingorg, < 0.0000, 134.5260, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 308.0191, 1167.3950, 700.0771 > + startingorg, < 0.0000, -59.6587, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1529.7260, -1940.4990, 952.5771 > + startingorg, < 0.0000, -9.0903, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -4012.1050, 2518.5540, 2121.0000 > + startingorg, < -90.0000, -65.3040, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_column01_40x128_dirty_a.rmdl", < 857.0002, 943.0007, 702.0005 > + startingorg, < 0.0000, 30.5130, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1601.6890, 3022.3560, 706.0771 > + startingorg, < 0.0000, 117.9073, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_large_01.rmdl", < -4692.5200, -1861.4930, 4954.5010 > + startingorg, < 0.0000, 78.3238, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 778.0190, 462.3954, 700.0771 > + startingorg, < 0.0000, -59.6587, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1379.7290, 3054.7160, 1196.0770 > + startingorg, < 0.0000, 62.5265, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 650.9488, 3280.9000, 726.0005 > + startingorg, < 0.0000, -46.7805, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_corner_cap_01_a.rmdl", < 3156.9830, -3471.9850, 460.0004 > + startingorg, < 0.0000, -86.2436, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_large_01.rmdl", < -5457.8190, 588.0364, 3891.0010 > + startingorg, < 0.0000, 36.4808, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1691.9010, 2901.1640, 951.0771 > + startingorg, < 0.0000, 153.1051, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1083.9640, -2081.1540, 1197.5770 > + startingorg, < 0.0000, -152.5263, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1001.8740, 1611.1530, 700.0771 > + startingorg, < 0.0000, -55.5848, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1427.3120, -2137.2460, 952.5771 > + startingorg, < 0.0000, -62.9401, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_wallrun_02.rmdl", < -3748.0000, 231.9996, 2510.0000 > + startingorg, < 0.0000, -168.2323, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -4064.6050, 2633.0540, 2121.0000 > + startingorg, < -90.0000, -65.3040, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_column01_40x128_dirty_a.rmdl", < 819.0002, 1007.0010, 826.0005 > + startingorg, < 0.0000, 30.5130, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1205.3500, -2170.7430, 952.5771 > + startingorg, < 0.0000, -116.6361, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1456.4660, 3067.3760, 1074.0770 > + startingorg, < 0.0000, 80.8143, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_large_01.rmdl", < -2856.8450, -2225.4820, 2262.0010 > + startingorg, < 0.0000, -75.4123, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_desert_05.rmdl", < 2754.2960, -1276.1040, 609.9453 > + startingorg, < 0.0000, 0.0000, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1226.8060, 2743.7440, 1075.5770 > + startingorg, < 0.0000, -27.3782, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1660.0360, 2679.8460, 706.0771 > + startingorg, < 0.0000, -152.5263, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_rooftop_01.rmdl", < -4276.9250, 1737.2710, 381.0005 > + startingorg, < 0.0000, 35.1031, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1424.5490, -2266.3080, 793.5635 > + startingorg, < -89.4115, 178.4395, -161.0400 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1518.0860, -1863.4970, 952.5771 > + startingorg, < 0.0000, 9.5296, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_02.rmdl", < -4565.4560, 1514.0410, 1817.4220 > + startingorg, < 0.0000, 53.2284, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1049.6920, -2011.5790, 706.0771 > + startingorg, < 0.0000, -170.8390, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -4202.6050, 2638.0540, 2121.0000 > + startingorg, < -90.0000, -65.3040, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_large_01.rmdl", < -2088.8650, -3501.0680, 3155.0010 > + startingorg, < 0.0000, -75.4123, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_column01_40x128_dirty_a.rmdl", < 870.0002, 994.0007, 826.0005 > + startingorg, < 0.0000, 30.5130, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1358.8210, -2173.6540, 706.0771 > + startingorg, < 0.0000, -81.1128, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1259.8890, 2964.6350, 706.0771 > + startingorg, < 0.0000, 26.9646, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1450.5720, 605.7633, 1109.3490 > + startingorg, < -0.7399, -60.8484, -5.1692 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -4123.6050, 2467.0540, 1977.0000 > + startingorg, < -90.0000, -65.3040, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_wallrun_02.rmdl", < -3787.0000, 527.9996, 1904.0000 > + startingorg, < 0.0000, -143.8754, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2043.7060, 2153.7810, 666.0002 > + startingorg, < 0.0000, 121.8182, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1379.7290, 3054.7160, 706.0771 > + startingorg, < 0.0000, 62.5265, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_wallrun_03.rmdl", < -4019.5340, 719.0002, 2473.5000 > + startingorg, < 0.0000, 30.5374, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1313.8390, 3018.5020, 952.5771 > + startingorg, < 0.0000, 45.0916, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_large_01.rmdl", < -2327.8650, -2934.0680, 2373.0010 > + startingorg, < 0.0000, -75.4123, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1529.7260, -1940.4990, 1197.5770 > + startingorg, < 0.0000, -9.0903, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1518.0860, -1863.4970, 1197.5770 > + startingorg, < 0.0000, 9.5296, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/canyonlands/fabric_canopy_pole_256_01.rmdl", < 269.1489, 3910.0520, 668.6074 > + startingorg, < 0.0000, 0.0000, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_02.rmdl", < -4355.5930, 1069.9980, 2156.2720 > + startingorg, < 0.0000, -9.2421, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_wallrun_03.rmdl", < -3938.0000, 719.0002, 1867.5000 > + startingorg, < 0.0000, 30.5374, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_wallrun_03.rmdl", < -3716.0000, 60.0002, 2614.0000 > + startingorg, < 0.0000, 28.3493, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_playback_06.rmdl", < -847.4752, -2534.9190, 862.6836 > + startingorg, < 22.7059, -60.2699, -23.5879 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_rooftop_01.rmdl", < -909.2095, -4313.5300, 511.0005 > + startingorg, < 0.0000, 4.2552, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1259.8890, 2964.6350, 1075.5770 > + startingorg, < 0.0000, 26.9646, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 799.7893, 3119.6730, 726.0005 > + startingorg, < 0.0000, -46.7805, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_large_01.rmdl", < -5373.6480, 1335.8270, 3355.0010 > + startingorg, < 0.0000, -119.7670, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2016.5580, 1510.9840, 976.0005 > + startingorg, < 0.0000, 30.9576, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_02.rmdl", < -1874.0540, -3105.3080, 2271.9220 > + startingorg, < 0.0000, -17.3116, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 825.6987, 3144.4750, 790.0005 > + startingorg, < 0.0000, -46.7805, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1538.6500, 2590.2570, 1075.5770 > + startingorg, < 0.0000, -116.6361, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1214.2740, 2820.5010, 952.5771 > + startingorg, < 0.0000, -9.0903, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1456.4660, 3067.3760, 829.0771 > + startingorg, < 0.0000, 80.8143, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_rooftop_01.rmdl", < -1331.0030, 5048.0030, 863.0005 > + startingorg, < 0.0000, 0.0000, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2026.5660, 1516.2550, 1044.8970 > + startingorg, < 0.0000, 122.6392, -89.9530 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1316.6880, 2623.7540, 952.5771 > + startingorg, < 0.0000, -62.9401, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_column01_40x128_dirty_a.rmdl", < 857.0002, 943.0007, 826.0005 > + startingorg, < 0.0000, 30.5130, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 679.9241, 3308.1040, 726.0005 > + startingorg, < 0.0000, -46.7805, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_wallrun_03.rmdl", < -3566.0000, 146.0002, 1897.0000 > + startingorg, < 0.0000, 28.3493, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1704.6040, 2825.5000, 953.0771 > + startingorg, < 0.0000, 171.1011, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2497.9560, 1599.2850, 741.9998 > + startingorg, < 90.0000, -149.2738, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1430.2420, -1742.4980, 1075.5770 > + startingorg, < 0.0000, 45.0916, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/containers/underbelly_cargo_container_128_blue_02.rmdl", < -648.2345, -1340.9910, 1255.6340 > + startingorg, < 3.9445, 112.6727, 3.5379 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_corner_cap_01_a.rmdl", < -636.5322, 5081.8170, 846.0004 > + startingorg, < 0.0000, 155.2334, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_wallrun_02.rmdl", < -3868.5340, 527.9996, 2510.0000 > + startingorg, < 0.0000, -143.8754, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1964.1240, 1476.8810, 976.0005 > + startingorg, < 0.0000, 30.9576, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2672.5390, -347.4154, 717.0005 > + startingorg, < 0.0000, 109.8747, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_playback_06.rmdl", < -1846.5660, 1126.8030, 1013.6370 > + startingorg, < 0.0000, 36.9956, -50.5623 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2052.8150, 2013.6260, 976.0005 > + startingorg, < 0.0000, -59.1546, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_corner_cap_01_a.rmdl", < -636.5322, 5081.8170, 565.0004 > + startingorg, < 0.0000, 155.2334, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1364.2710, -1705.7480, 951.0771 > + startingorg, < 0.0000, 62.5265, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_playback_06.rmdl", < -165.2794, 716.9898, 881.4160 > + startingorg, < 48.3599, -5.2539, -20.2695 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 738.7565, 3184.5780, 726.0005 > + startingorg, < 0.0000, 42.5120, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -4234.6050, 2416.0540, 1977.0000 > + startingorg, < -90.0000, -65.3040, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1448.4450, 809.1062, 700.0771 > + startingorg, < 0.0000, -64.5558, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2018.8150, 2066.1260, 918.0005 > + startingorg, < 0.0000, -59.1546, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_wallrun_03.rmdl", < -4745.3140, 1774.5420, 1486.0000 > + startingorg, < 0.0000, -147.6534, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1912.8150, 2003.1260, 918.0005 > + startingorg, < 0.0000, -59.1546, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2016.5580, 1510.9840, 918.0005 > + startingorg, < 0.0000, 30.9576, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1704.6040, 2825.5000, 1198.0770 > + startingorg, < 0.0000, 171.1011, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_wallrun_03.rmdl", < -4479.6670, 1430.2230, 1525.0000 > + startingorg, < 0.0000, -147.6534, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_column01_40x128_dirty_a.rmdl", < 846.0006, 1008.0000, 827.0005 > + startingorg, < 0.0000, -14.1761, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1733.6340, 3056.4480, 793.5635 > + startingorg, < -89.4118, 22.6173, -161.0386 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -3930.0500, 2578.6650, 2112.0000 > + startingorg, < 0.0000, 25.3541, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2630.0880, -224.1846, 717.0005 > + startingorg, < 0.0000, -160.8329, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_wallrun_02.rmdl", < -4673.2580, 1561.0480, 1904.0000 > + startingorg, < 0.0000, 40.1219, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_playback_04.rmdl", < -4534.1920, 1647.1660, 1559.9420 > + startingorg, < 10.6747, -147.8555, 0.4520 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 896.6986, 1539.5000, 823.0771 > + startingorg, < 0.0000, -55.5848, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1262.9110, 2677.7940, 1197.5770 > + startingorg, < 0.0000, -44.8131, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/canyonlands/fabric_canopy_pole_256_01.rmdl", < 192.1489, 3999.0520, 668.6074 > + startingorg, < 0.0000, 0.0000, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2672.5390, -347.4154, 851.0005 > + startingorg, < 0.0000, 109.8747, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_rooftop_01.rmdl", < -781.7147, 5585.4580, 722.0005 > + startingorg, < 0.0000, 45.3932, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1262.9110, 2677.7940, 706.0771 > + startingorg, < 0.0000, -44.8131, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1691.9010, 2901.1640, 1074.0770 > + startingorg, < 0.0000, 153.1051, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/containers/underbelly_cargo_container_128_blue_02.rmdl", < -584.0426, -668.8167, 1240.1230 > + startingorg, < -1.5296, -109.9436, -4.2075 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_rooftop_01.rmdl", < -909.2095, -4312.5300, 1448.5000 > + startingorg, < 0.0000, 4.2552, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1214.2740, 2820.5010, 1075.5770 > + startingorg, < 0.0000, -9.0903, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1463.4980, 2575.8650, 1197.5770 > + startingorg, < 0.0000, -99.7329, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1039.3960, -1935.5000, 1075.5770 > + startingorg, < 0.0000, 171.1011, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_wallrun_03.rmdl", < -3730.0000, 310.0002, 1486.0000 > + startingorg, < 0.0000, 28.3493, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1484.1110, -1796.3650, 952.5771 > + startingorg, < 0.0000, 26.9646, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_rooftop_01.rmdl", < 1082.7910, -4516.5300, 832.0005 > + startingorg, < 0.0000, 4.2552, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2159.0670, 2063.6070, 1044.8970 > + startingorg, < 0.0000, 32.5270, -89.9530 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1441.6140, 607.7581, 1180.9290 > + startingorg, < 84.7784, -142.7246, -82.0567 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1280.5020, -2185.1360, 706.0771 > + startingorg, < 0.0000, -99.7329, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_wallrun_03.rmdl", < -1454.4940, -3725.3260, 1867.5000 > + startingorg, < 0.0000, 22.4678, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_large_01.rmdl", < -5034.7340, -1471.6750, 5821.0010 > + startingorg, < 0.0000, -125.4285, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1930.9560, 2233.2850, 741.9998 > + startingorg, < 90.0000, -149.2738, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2346.6030, 1528.8190, 1048.0000 > + startingorg, < 90.0000, -58.9408, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 3923.0000, -2427.0000, 547.0000 > + startingorg, < 0.0000, 0.0000, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1946.8150, 1950.6260, 976.0005 > + startingorg, < 0.0000, -59.1546, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_wallrun_03.rmdl", < -1627.8790, -3725.3260, 2499.5000 > + startingorg, < 0.0000, 22.4678, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1518.0860, -1863.4970, 706.0771 > + startingorg, < 0.0000, 9.5296, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 3056.7740, 1508.1280, 703.0000 > + startingorg, < -90.0000, -58.9181, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 896.6986, 1539.5000, 700.0771 > + startingorg, < 0.0000, -55.5848, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1142.3110, -1738.6440, 829.0771 > + startingorg, < 0.0000, 117.9073, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2978.6730, 1681.5600, 918.0002 > + startingorg, < 0.0000, -148.8894, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/containers/underbelly_cargo_container_128_red_02.rmdl", < -1607.3330, -1384.9200, 1182.9230 > + startingorg, < -10.8896, 114.4993, 3.5745 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/canyonlands/fabric_canopy_pole_256_01.rmdl", < 101.1489, 3919.0520, 668.6074 > + startingorg, < 0.0000, 0.0000, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1417.5180, -2263.7650, 734.0005 > + startingorg, < 0.0000, 17.5165, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_wallrun_03.rmdl", < -1479.0000, -3576.9600, 1533.5000 > + startingorg, < 0.0000, 22.4678, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_rooftop_01.rmdl", < 650.7903, -4564.0300, 1154.0000 > + startingorg, < 0.0000, 4.2552, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1518.0860, -1863.4970, 1075.5770 > + startingorg, < 0.0000, 9.5296, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1086.5680, -1792.5480, 951.0771 > + startingorg, < 0.0000, 134.5260, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/containers/underbelly_cargo_container_128_blue_02.rmdl", < -928.4363, -851.5400, 1271.2050 > + startingorg, < 2.2605, -20.7631, -5.0049 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2376.9560, 2584.2850, 994.9998 > + startingorg, < 90.0000, -149.2738, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_rooftop_01.rmdl", < 3947.5080, -4062.9050, 671.0005 > + startingorg, < 0.0000, -34.0526, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1210.5130, -1703.8560, 1196.0770 > + startingorg, < 0.0000, 99.4343, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_large_01.rmdl", < -4861.8450, 1481.5180, 2373.0010 > + startingorg, < 0.0000, -75.4123, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1456.4660, 3067.3760, 706.0771 > + startingorg, < 0.0000, 80.8143, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 3337.5240, 600.2608, 1815.0000 > + startingorg, < 0.0000, 26.8554, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1226.8060, 2743.7440, 706.0771 > + startingorg, < 0.0000, -27.3782, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_wallrun_03.rmdl", < -3743.0000, 415.0006, 1654.0000 > + startingorg, < 87.3338, 156.0671, 42.7757 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -4313.6050, 2587.0540, 1977.0000 > + startingorg, < -90.0000, -65.3040, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1538.6500, 2590.2570, 952.5771 > + startingorg, < 0.0000, -116.6361, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_wallrun_03.rmdl", < -4229.4570, 1110.6210, 1906.5000 > + startingorg, < 0.0000, -145.4653, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_corner_cap_01_a.rmdl", < -2684.8910, 3984.9000, 1576.0020 > + startingorg, < -86.9981, -70.0681, -80.7927 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 825.6987, 3144.4750, 726.0005 > + startingorg, < 0.0000, -46.7805, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1517.1940, -2017.2570, 706.0771 > + startingorg, < 0.0000, -27.3782, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -4012.1050, 2518.5540, 1977.0000 > + startingorg, < -90.0000, -65.3040, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_large_01.rmdl", < -3650.1450, -3152.2310, 3891.0010 > + startingorg, < 0.0000, 72.2781, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/containers/underbelly_cargo_container_128_red_02.rmdl", < -1143.4130, 167.7749, 1294.1800 > + startingorg, < 0.2914, -30.8948, -5.4935 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1358.8210, -2173.6540, 952.5771 > + startingorg, < 0.0000, -81.1128, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_large_01.rmdl", < -4396.8360, 605.8422, 2475.0010 > + startingorg, < 0.0000, 52.1884, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1358.8210, -2173.6540, 829.0771 > + startingorg, < 0.0000, -81.1128, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2979.4010, 1678.0210, 993.9998 > + startingorg, < 90.0000, -149.2738, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1952.0670, 1940.6070, 1044.8970 > + startingorg, < 0.0000, 32.5270, -89.9530 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1039.3960, -1935.5000, 710.0771 > + startingorg, < 0.0000, 171.1011, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_playback_04.rmdl", < -4534.1920, 1646.1660, 1619.9420 > + startingorg, < 10.6747, -147.8555, 0.4520 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_playback_04.rmdl", < -4007.6920, 839.1661, 2044.4420 > + startingorg, < 10.6747, -147.8555, 0.4520 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/pipes/pipe_modular_painted_yellow_8.rmdl", < 1287.0150, -1938.9850, 1736.0000 > + startingorg, < 0.0000, 0.0000, 0.0000 >, true, 50000, -1, 28);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1430.1610, -1742.4980, 706.0771 > + startingorg, < 0.0000, 45.0916, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_02.rmdl", < -1324.1450, -3970.6790, 1480.4220 > + startingorg, < 0.0000, 34.0983, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_playback_06.rmdl", < -144.7486, 640.2878, 904.4160 > + startingorg, < 48.3600, -172.1949, -20.2695 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1427.3120, -2137.2460, 829.0771 > + startingorg, < 0.0000, -62.9401, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_rooftop_01.rmdl", < -3936.9250, 2145.2710, 1494.0000 > + startingorg, < 0.0000, 35.1031, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/military_base/militaryfort_wall_rooftop_01.rmdl", < -4121.7260, 2012.6580, 1956.0000 > + startingorg, < 0.0000, 34.1100, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1316.6880, 2623.7540, 706.0771 > + startingorg, < 0.0000, -62.9401, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 363.0191, 1199.3950, 700.0771 > + startingorg, < 0.0000, -59.6587, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 1427.3120, -2137.2460, 706.0771 > + startingorg, < 0.0000, -62.9401, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/rocks/rock_white_chalk_modular_large_01.rmdl", < -3040.1900, -3141.5100, 4269.3240 > + startingorg, < -36.4160, 33.4547, 93.9421 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 3337.5240, 600.2608, 2127.0000 > + startingorg, < 0.0000, 26.8554, 0.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1313.8390, 3018.5020, 706.0771 > + startingorg, < 0.0000, 45.0916, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1660.0360, 2679.8460, 952.5771 > + startingorg, < 0.0000, -152.5263, 90.0000 >, true, 50000, -1, 1);
    CreateMapEditorProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 2322.5040, 2554.2150, 919.0002 > + startingorg, < 0.0000, -148.8894, 0.0000 >, true, 50000, -1, 1);

	Patch_mp_rr_party_crasher() //(mk): spawn LOS flagged props
}

array<entity> function PerfectZipline(vector startPos,vector endPos,bool pathfinder_model)
{
	vector pathfinder_offset = <0,0,120>
	asset PATHFINDER_ZIP_MODEL = $"mdl/props/pathfinder_zipline/pathfinder_zipline.rmdl"

	entity zipline_start = CreateEntity( "zipline" )
	entity ent_model_start
	zipline_start.kv.Material = "cable/zipline.vmt"
	zipline_start.kv.ZiplineAutoDetachDistance = "160"
	array<entity> ziplineEnts

	ent_model_start = CreatePropDynamic( PATHFINDER_ZIP_MODEL, startPos, <0,0,0>, 6, -1 )
	zipline_start.SetOrigin( startPos + pathfinder_offset)

	entity zipline_end = CreateEntity( "zipline_end" )
	zipline_end.kv.ZiplineAutoDetachDistance = "160"
	entity ent_model_end
	
	ent_model_end = CreatePropDynamic( PATHFINDER_ZIP_MODEL, endPos, <0,0,0>, 6, -1 )
	zipline_end.SetOrigin( endPos + pathfinder_offset)

	zipline_start.LinkToEnt( zipline_end )
	DispatchSpawn( zipline_start )
	DispatchSpawn( zipline_end )

	ziplineEnts = [ zipline_start, zipline_end ,ent_model_start,ent_model_end]
		
	return ziplineEnts
}

void function InitSpecialButtons()
{
    file.button1 = CreateFRButton(<1353,4808,1860>, <0,40,0>, "Secret Button (1/3)")
    file.button2 = CreateFRButton(<3337,892,1870>, <0,30,0>, "Secret Button (2/3)")
    file.button3 = CreateFRButton(<-4034,2586,1990>, <0,-100,0>, "Secret Button (3/3)")
	AddCallback_OnUseEntity( file.button1, void function(entity panel, entity user, int input)
	{
        if(file.button1pressed)
            return
        
        file.button1pressed = true
		ButtonCheck(panel)
	})
    AddCallback_OnUseEntity( file.button2, void function(entity panel, entity user, int input)
	{
        if(file.button2pressed)
            return

        file.button2pressed = true
		ButtonCheck(panel)
	})
    AddCallback_OnUseEntity( file.button3, void function(entity panel, entity user, int input)
	{
        if(file.button3pressed)
            return

        file.button3pressed = true
		ButtonCheck(panel)
	})
}

void function ButtonCheck(entity button)
{
    EmitSoundOnEntity( button, "ui_ingame_markedfordeath_countdowntomarked" )
    button.SetUsePrompts("ACTIVATED", "ACTIVATED")

    button.Dissolve( ENTITY_DISSOLVE_CORE, <0,0,0>, 1000 )

    if(file.button1pressed && file.button2pressed && file.button3pressed)
        thread ActivacteSecret()
}

void function ActivacteSecret()
{
    wait 5

    entity nessy = CreateMapEditorProp( $"mdl/domestic/nessy_doll.rmdl", < -8266.8550, -2482.3440, 6157.1870 >, < -1.3469, -61.0443, -42.0124 >, true, 50000, -1, 100);

    foreach( entity player in GetPlayerArray() )
    {
		Remote_CallFunction_NonReplay( player, "ServerCallback_NessyMessage", 1 )
        EmitSoundOnEntity( nessy, "Canyonlands_Generic_Emit_Leviathan_Vocal_Generic_A" )
    }

    entity nessymover = CreateScriptMover( < -8266.8550, -2482.3440, 6157.1870 >, < -1.3469, -61.0443, -42.0124 > )
    nessy.SetParent( nessymover )

	nessymover.NonPhysicsMoveTo( < -5726.2830, -2482.3440, 7216.6340 >, 30.0, 4.0, 4.0 )
	nessymover.NonPhysicsRotateTo( < -1.3469, -61.0443, -42.0124 >, 15, 5, 5 )
}

void function MovingLights(entity ent, bool rightside)
{
	vector result
	float newAngle = 1.5
	float speed = 1.4
	while(IsValid(ent))
	{
		if(!rightside)
		   result =  ent.GetAngles() + <-speed,0,0>
		else
		   result = ent.GetAngles()  + <speed,0,0>

		if(result.x <= 70)
			rightside = true
		else if(result.x > 130)
			rightside = false
		
		ent.NonPhysicsRotateTo(result, 0.1, 0, 0)
		wait 0.01
	}	
}

void function SpawnMovingLights()
{
	entity beam =  StartParticleEffectInWorld_ReturnEntity(GetParticleSystemIndex( $"P_ar_hot_zone_far" ), <-4672.74414, 11260.5811, 2969.22217>, <70,0,0> )
	entity beam2 = StartParticleEffectInWorld_ReturnEntity(GetParticleSystemIndex( $"P_ar_hot_zone_far" ), <-6948.34473, 8222.79492, 3005.85596>, <130,0,0> )
	entity beam_2 =  StartParticleEffectInWorld_ReturnEntity(GetParticleSystemIndex( $"P_ar_hot_zone_far" ), <-4672.74414, 11260.5811, 2969.22217>, <70,0,0> )
	entity beam2_2 = StartParticleEffectInWorld_ReturnEntity(GetParticleSystemIndex( $"P_ar_hot_zone_far" ), <-6948.34473, 8222.79492, 3005.85596>, <130,0,0> )
	beam_2.SetParent(beam)
	beam2_2.SetParent(beam2)
	
	entity beam3 = StartParticleEffectInWorld_ReturnEntity(GetParticleSystemIndex( $"P_ar_hot_zone_far" ), <6654.4209, -6538.19385, 2883.62305>, <70,0,0> )
	entity beam4 = StartParticleEffectInWorld_ReturnEntity(GetParticleSystemIndex( $"P_ar_hot_zone_far" ), <3891.19507, -7936.33301, 2170.66748>, <130,0,0> )
	entity beam3_2 = StartParticleEffectInWorld_ReturnEntity(GetParticleSystemIndex( $"P_ar_hot_zone_far" ), <6654.4209, -6538.19385, 2883.62305>, <70,0,0> )
	entity beam4_2 = StartParticleEffectInWorld_ReturnEntity(GetParticleSystemIndex( $"P_ar_hot_zone_far" ), <3891.19507, -7936.33301, 2170.66748>, <130,0,0> )
	beam3_2.SetParent(beam3)
	beam4_2.SetParent(beam4)
	
	entity mover1 = CreateScriptMover( beam.GetOrigin() )
	mover1.SetAngles(beam.GetAngles())
	beam.SetParent(mover1)
	
	entity mover2 = CreateScriptMover( beam2.GetOrigin() )
	mover2.SetAngles(beam2.GetAngles())
	beam2.SetParent(mover2)

	entity mover3 = CreateScriptMover( beam3.GetOrigin() )
	mover3.SetAngles(beam3.GetAngles())
	beam3.SetParent(mover3)

	entity mover4 = CreateScriptMover( beam4.GetOrigin() )
	mover4.SetAngles(beam4.GetAngles())
	beam4.SetParent(mover4)
	
	thread MovingLights(mover1, true)
	thread MovingLights(mover2, false)
	thread MovingLights(mover3, true)
	thread MovingLights(mover4, false)		
}