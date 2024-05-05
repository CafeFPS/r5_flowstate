//FLOWSTATE PROPHUNT
//Made by @CafeFPS (@CafeFPS)

// AyeZee#6969 -- Ctf voting phase to work off
// _RitzKing#1715 -- Gamemode Icon
// everyone else -- advice

global function GamemodeProphuntShared_Init
global function RegisterLocationPROPHUNT
global function GetCenterOfCircle

global const int PROPHUNT_CHANGE_PROP_USAGE_LIMIT = 5
global const int PROPHUNT_FLASH_BANG_RADIUS = 600
global const int PROPHUNT_DECOYS_USAGE_LIMIT = 5
global const int PROPHUNT_FLASH_BANG_USAGE_LIMIT = 5
global const int PROPHUNT_WHISTLE_RADIUS = 2000
global const int PROPHUNT_WHISTLE_TIMER = 25
global const int PROPHUNT_TELEPORT_ATTACKERS_DELAY = 60 //hiding props time too
global const int PROPHUNT_ATTACKERS_ABILITY_COOLDOWN = 60

global int PROPHUNT_HUNTERS_AMOUNT_ALLOWED
global int PROPHUNT_PROPS_AMOUNT_ALLOWED

global struct ProphuntPlayerInfo_PROPS
{
	string name
	int timessurvived
	int survivaltime
}

global struct ProphuntPlayerInfo_HUNTERS
{
	string name
	int propskilled
}

global array<asset> prophuntAssets = []

void function GamemodeProphuntShared_Init()
{	
	SurvivalFreefall_Init() //Enables freefall/skydive
	
    switch( MapName() )
    {
	    case eMaps.mp_rr_canyonlands_mu1:

		prophuntAssets = [
			$"mdl/barriers/concrete/concrete_barrier_01.rmdl",
			$"mdl/vehicles_r5/land/msc_truck_samson_v2/veh_land_msc_truck_samson_v2.rmdl",
			$"mdl/angel_city/vending_machine.rmdl",
			$"mdl/utilities/power_gen1.rmdl",
			$"mdl/angel_city/box_small_02.rmdl",
			$"mdl/colony/antenna_05_colony.rmdl",
			$"mdl/angel_city/box_small_01.rmdl",
			$"mdl/containers/slumcity_oxygen_tank_red.rmdl",
			$"mdl/containers/box_shrinkwrapped.rmdl",
			$"mdl/colony/farmland_fridge_01.rmdl",
			$"mdl/colony/farmland_crate_plastic_01_red.rmdl",
			$"mdl/IMC_base/generator_IMC_01.rmdl",
			$"mdl/garbage/trash_can_metal_02_b.rmdl",
			$"mdl/garbage/trash_bin_single_wtrash.rmdl"
			$"mdl/containers/slumcity_oxygen_tank_blue.rmdl",
			$"mdl/containers/barrel.rmdl",
			$"mdl/containers/container_medium_tanks_blue.rmdl",
			$"mdl/containers/underbelly_cargo_container_128_red_02.rmdl",
			$"mdl/containers/underbelly_cargo_container_128_blue_02.rmdl",
			$"mdl/containers/pelican_case_large.rmdl",
			$"mdl/colony/farmland_crate_md_80x64x72_01.rmdl",
			$"mdl/angel_city/vending_machine.rmdl",
			//nuevos kc
			$"mdl/rocks/thunderdome_quarry_block_02_orange.rmdl",
			$"mdl/colony/farmland_crate_plastic_01.rmdl",
			$"mdl/colony/water_heater_red.rmdl",
			$"mdl/colony/antenna_01_colony_pole.rmdl",
			$"mdl/containers/gas_tank.rmdl",
			$"mdl/containers/crate_orange_plastic.rmdl",
			$"mdl/containers/lagoon_roof_tanks_01.rmdl",
			$"mdl/thunderdome/thunderdome_cut_rock_large_01.rmdl",
			$"mdl/eden/eden_electrical_transformer_01.rmdl",
			$"mdl/barriers/sandbags_curved_01.rmdl",
			$"mdl/barriers/guard_rail_01_64.rmdl",
			$"mdl/barriers/concrete/concrete_barrier_fence.rmdl",
			$"mdl/barriers/guard_rail_01_256.rmdl",
			$"mdl/vehicles_r5/land/msc_forklift_imc_v2/veh_land_msc_forklift_imc_v2_static.rmdl",
			$"mdl/beacon/beacon_server_stand_01.rmdl",
			$"mdl/nexus/hay_bale_01_round.rmdl",
			$"mdl/nexus/fir_log_pile_01.rmdl",
			$"mdl/nexus/hay_bale_01_straps.rmdl"
			
			
		]
		
		RegisterLocationPROPHUNT(
            NewLocationSettings(
                "Hillside Outspot",
                [
                    NewLocPair(<-19300, 4678, 3230>, <0, -100, 0>),
                    NewLocPair(<-16763, 4465, 3020>, <1, 18, 0>),
                    NewLocPair(<-20153, 1127, 3060>, <11, 170, 0>),
					NewLocPair(<-16787, 3540, 3075>, <0, 86, 0>),
					NewLocPair(<-19026, 3749, 4460>, <0, 2, 0>),
					NewLocPair(<-17030.5059, 2388.69922, 2839.93335>,<0, 75.5948486, 0>),
					NewLocPair(<-17177.373, 3861.9397, 2903.16895>,<0, -178.642105, 0>),
					NewLocPair(<-18008.9551, 4168.15088, 3001.29395>,<0, -21.2121582, 0>),
					NewLocPair(<-18366.0156, 2325.30273, 3626.2981>,<0, -177.12085, 0>),
					NewLocPair(<-18810.4629, 3258.021, 3635.05151>,<0, -64.3844833, 0>)
                ],
                <0, 0, 3000>,$"rui/flowstatelocations/hillside"
            )
        )
		
		RegisterLocationPROPHUNT(
            NewLocationSettings(
                "Skull Town",
                [
                    NewLocPair(<-9320, -13528, 3167>, <0, -100, 0>),
                    NewLocPair(<-7544, -13240, 3161>, <0, -115, 0>),
                    NewLocPair(<-10250, -18320, 3323>, <0, 100, 0>),
                    NewLocPair(<-13261, -18100, 3337>, <0, 20, 0>),
					NewLocPair(<-10814.5586, -16410.5391, 3856.77319>,<0, -38.5158501, 0>),
					NewLocPair(<-10473.9404, -16024.3477, 3901.43262>,<0, -34.6810913, 0>),
					NewLocPair(<-8734.7041, -16469.7344, 3208.71533>,<0, -108.860077, 0>),
					NewLocPair(<-10615.4395, -17777.127, 3159.24707>,<0, 43.0446396, 0>),
					NewLocPair(<-11566.0879, -17012.9453, 3154.54297>,<0, 95.893692, 0>),
					NewLocPair(<-12583.5811, -15106.4648, 3259.06519>,<0, 25.4997368, 0>),
					NewLocPair(<-9621.58008, -17746.0156, 3179.7666>,<0, 89.6492081, 0>),
					NewLocPair(<-8039.30566, -17382.6992, 3174.5835>,<0, 112.115288, 0>)
                ],
                <0, 0, 3000>,$"rui/flowstatelocations/skulltown"
            )
        )
		RegisterLocationPROPHUNT(
            NewLocationSettings(
                "Containment",
                [
                    NewLocPair(<-7291, 19547, 2978>, <0, -65, 0>),
                    NewLocPair(<-3906, 19557, 2733>, <0, -123, 0>),
                    NewLocPair(<-3084, 16315, 2566>, <0, 144, 0>),
                    NewLocPair(<-6517, 15833, 2911>, <0, 51, 0>),
					NewLocPair(<-6325.41797, 17395.4219, 3058.27148>,<0, -50.0188675, 0>),
					NewLocPair(<-5990.51318, 16260.3838, 3282.94336>,<0, 85.6426392, 0>),
					NewLocPair(<-4402.61523, 16541.2891, 2888.02124>,<0, 90.3426895, 0>),
					NewLocPair(<-4830.92334, 17571.6328, 3891.23779>,<0, 129.336548, 0>),
					NewLocPair(<-6240.06494, 19593.8496, 2796.3291>,<0, -67.6390762, 0>)
                ],
                <0, 0, 3000>,$"rui/flowstatelocations/containment"
            )
        )
		
		// RegisterLocationPROPHUNT(
            // NewLocationSettings(
                // "Gaunlet",
                // [
                    // NewLocPair(<-21271, -15275, 2781>, <0, 90, 0>),
                    // NewLocPair(<-22952, -13304, 2718>, <0, 5, 0>),
                    // NewLocPair(<-22467, -9567, 2949>, <0, -85, 0>),
                    // NewLocPair(<-18494, -10427, 2825>, <0, -155, 0>),
					// NewLocPair(<-22590, -7534, 3103>, <0, 0, 0>),
					// NewLocPair(<-19144.0469, -13831.9307, 2885.34009>,<0, 114.135735, 0>),
					// NewLocPair(<-21118.3496, -13426.8838, 3267.69751>,<0, 92.8888092, 0>),
					// NewLocPair(<-20688.4414, -13218.4688, 2590.52026>,<0, 119.666588, 0>),
					// NewLocPair(<-20970.3105, -12526.0381, 2604.68213>,<0, 84.2326584, 0>),
					// NewLocPair(<-21092.6875, -14138.5742, 2901.44849>,<0, 140.832993, 0>)
                // ],
                // <0, 0, 4000>,$"rui/flowstatelocations/gaunlet"
            // )
        // )
		
		RegisterLocationPROPHUNT(
            NewLocationSettings(
                "Market",
                [
                    NewLocPair(<-110, -9977, 2987>, <0, 0, 0>),
                    NewLocPair(<-1605, -10300, 3053>, <0, -100, 0>),
                    NewLocPair(<4600, -11450, 2950>, <0, 180, 0>),
                    NewLocPair(<3150, -11153, 3053>, <0, 100, 0>),
					NewLocPair(<1526.54724, -9814.23926, 3382.51367>,<0, -96.077919, 0>),
					NewLocPair(<2527.8833, -10010.7725, 3347.18506>,<0, -82.0662231, 0>),
					NewLocPair(<3474.97314, -10081.4277, 3329.40747>,<0, -111.653938, 0>),
					NewLocPair(<3384.8772, -10686.1895, 2976.70996>,<0, -179.954941, 0>),
					NewLocPair(<1665.42896, -10973.292, 3325.89233>,<0, 87.6322632, 0>)
                ],
                <0, 0, 3000>,$"rui/flowstatelocations/market"
            )
        )
		RegisterLocationPROPHUNT(
            NewLocationSettings(
                "Labs",
                [
                    NewLocPair(<27576, 8062, 2910>, <0, -115, 0>),
					NewLocPair(<24545, 2387, 4100>, <0, -7, 0>),
                    NewLocPair(<25924, 2161, 3848>, <0, -9, 0>),
                    NewLocPair(<28818, 2590, 3798>, <0, 117, 0>),
					NewLocPair(<26160.0293, 3163.60229, 3240.58228>,<0, 17.6068058, 0>),
					NewLocPair(<28126.6699, 2991.92944, 3438.99878>,<0, 112.35788, 0>),
					NewLocPair(<27356.709, 4449.24316, 3697.13477>,<0, -94.8291779, 0>)
                ],
                <0, 0, 3000>,$"rui/flowstatelocations/labs"
            )
        )
		RegisterLocationPROPHUNT(
            NewLocationSettings(
                "Repulsor",
                [
                    NewLocPair(<28095, -16983, 4786>, <0, 140, 0>),
                    NewLocPair(<29475, -12237, 5769>, <0, -157, 0>),
                    NewLocPair(<20567, -13551, 4821>, <0, -39, 0>),
                    NewLocPair(<22026, -17661, 5789>, <0, 21, 0>),
					NewLocPair(<26036, -17590, 5694>, <0, 90, 0>),
                    NewLocPair(<26670, -16729, 4926>, <0, -180, 0>),
                    NewLocPair(<27784, -16166, 5046>, <0, -180, 0>),
                    NewLocPair(<27133, -16074, 5630>, <0, -90, 0>),
                    NewLocPair(<27051, -14200, 5582>, <0, -90, 0>)
                ],
                <0, 0, 3000>,$"rui/flowstatelocations/repulsor"
            )
        )

		RegisterLocationPROPHUNT(
			NewLocationSettings(
                "Cage",
                [
                    NewLocPair(<15604, -1068, 5833>, <0, -126, 0>),
                    NewLocPair(<18826, -4314, 5032>, <0, 173, 0>),
                    NewLocPair(<19946, 32, 4960>, <0, -168, 0>),
                    NewLocPair(<12335, -1446, 3984>, <0, 2, 0>),
					NewLocPair(<13906.8184, -2018.16125, 3934.21411>,<0, 57.8257103, 0>),
					NewLocPair(<15384.8828, -1184.42346, 4603.6748>,<0, -14.5582685, 0>),
					NewLocPair(<15625.2549, -1304.52209, 5709.05469>,<0, 151.716797, 0>),
					NewLocPair(<15533.6895, 378.72757, 4613.93506>,<0, -86.3438873, 0>)
                ],
                <0, 0, 3000>,$"rui/flowstatelocations/cage"
            )
        )

		RegisterLocationPROPHUNT(
            NewLocationSettings(
                "Swamps",
                [
                    NewLocPair(<37886, -4012, 3300>, <0, 167, 0>),
                    NewLocPair(<34392, -5974, 3017>, <0, 51, 0>),
                    NewLocPair(<29457, -2989, 2895>, <0, -17, 0>),
                    NewLocPair(<34582, 2300, 2998>, <0, -92, 0>),
					NewLocPair(<35757, 3256, 3290>, <0, -90, 0>),
                    NewLocPair(<36422, 3109, 3500>, <0, -165, 0>),
                    NewLocPair(<34965, 1718, 3529>, <0, 45, 0>),
                    NewLocPair(<32654, -1552, 3500>, <0, -90, 0>)

                ],
                <0, 0, 3000>,$"rui/flowstatelocations/swamps"
            )
        )

		RegisterLocationPROPHUNT(
            NewLocationSettings(
                "Relay",
                [
                    NewLocPair(<26420, 31700, 4790>, <0, -90, 0>),
                    NewLocPair(<29260, 26245, 4210>, <0, 45, 0>),
                    NewLocPair(<29255, 24360, 4210>, <0, 0, 0>),
                    NewLocPair(<24445, 28970, 4340>, <0, -90, 0>),
                    NewLocPair(<27735, 27880, 4370>, <0, 180, 0>),
                    NewLocPair(<25325, 25725, 4270>, <0, 0, 0>),
                    NewLocPair(<27675, 25745, 4370>, <0, 0, 0>),
                    NewLocPair(<24375, 27050, 4325>, <0, 180, 0>),
                    NewLocPair(<24000, 23650, 4050>, <0, 135, 0>),
                    NewLocPair(<23935, 22080, 4200>, <0, 15, 0>)
                ],
                <0, 0, 3000>,$"rui/flowstatelocations/relay"
            )
        )
		
        RegisterLocationPROPHUNT(
            NewLocationSettings(
                "Slum Lakes",
                [
                    NewLocPair(<-20060, 23800, 2655>, <0, 110, 0>),
                    NewLocPair(<-20245, 24475, 2810>, <0, -160, 0>),
                    NewLocPair(<-25650, 22025, 2270>, <0, 20, 0>),
                    NewLocPair(<-25550, 21635, 2590>, <0, 20, 0>),
                    NewLocPair(<-25030, 24670, 2410>, <0, -75, 0>),
                    NewLocPair(<-23125, 25320, 2410>, <0, -20, 0>),
                    NewLocPair(<-21925, 21120, 2390>, <0, 180, 0>)
                ],
                <0, 0, 3000>,$"rui/flowstatelocations/slumlakes"
            )
        )
		
        RegisterLocationPROPHUNT(
            NewLocationSettings(
                "Little Town",
                [
                    NewLocPair(<-30190, 12473, 3186>, <0, -90, 0>),
                    NewLocPair(<-28773, 11228, 3210>, <0, 180, 0>),
                    NewLocPair(<-29802, 9886, 3217>, <0, 90, 0>),
                    NewLocPair(<-30895, 10733, 3202>, <0, 0, 0>)
                ],
                <0, 0, 3000>,$"rui/flowstatelocations/kclittletown"
            )
        )

        RegisterLocationPROPHUNT(
            NewLocationSettings(
                "Runoff",
                [
                    NewLocPair(<-23380, 9634, 3371>, <0, 90, 0>),
                    NewLocPair(<-24917, 11273, 3085>, <0, 0, 0>),
                    NewLocPair(<-23614, 13605, 3347>, <0, -90, 0>),
                    NewLocPair(<-24697, 12631, 3085>, <0, 0, 0>)
                ],
                <0, 0, 3000>,$"rui/flowstatelocations/runoff"
            )
        )
		
		RegisterLocationPROPHUNT(
            NewLocationSettings(
                "Aeonopolis",
                [
                    NewLocPair(<11242, 8591, 4830>, <0, 0, 0>),
                    NewLocPair(<6657, 12189, 5066>, <0, -90, 0>),
                    NewLocPair(<7540, 8620, 5374>, <0, 89, 0>)
					NewLocPair(<2326.99902, 9479.35547, 3285.5686>,<0, -0.576593876, 0>),
                    NewLocPair(<3378.27563, 11322.5547, 3076.6665>,<0, -36.3084145, 0>),
                    NewLocPair(<5299.32813, 10557.082, 3673.81982>,<0, 164.837448, 0>),
                    NewLocPair(<4780.20654, 8356.84863, 4089.06177>,<0, 107.167992, 0>)
                ],
                <0, 0, 3000>,$"rui/flowstatelocations/thefarm"
            )
        )
		
        RegisterLocationPROPHUNT(
            NewLocationSettings(
                "Thunderdome",
                [
                    NewLocPair(<-20216, -21612, 3191>, <0, -67, 0>),
                    NewLocPair(<-16035, -20591, 3232>, <0, -133, 0>),
                    NewLocPair(<-16584, -24859, 2642>, <0, 165, 0>),
                    NewLocPair(<-19019, -26209, 2640>, <0, 65, 0>),
					NewLocPair(<-18597.3945, -20683.5313, 2925.68896>,<0, -92.47892, 0>),
					NewLocPair(<-15106.6631, -22193.6934, 3043.68042>,<0, -122.203957, 0>),
					NewLocPair(<-16093.2119, -24896.3496, 3154.95996>,<0, 158.63353, 0>),
					NewLocPair(<-19700.002, -21213.0313, 3521.97876>,<0, -51.6356506, 0>),
					NewLocPair(<-18551.9102, -23733.8301, 4746.57031>,<0, 40.1287155, 0>),
					NewLocPair(<-15827.498, -21485.2305, 3216.41382>,<0, -96.8535309, 0>),
					NewLocPair(<-18183.5996, -25747.2891, 2756.88452>,<0, 99.2026978, 0>),
					NewLocPair(<-20057.3164, -23134.1191, 2596.95361>,<0, -8.30639935, 0>)
                ],
                <0, 0, 2000>,$"rui/flowstatelocations/thunderdome"
            )
        )
        RegisterLocationPROPHUNT(
            NewLocationSettings(
                "Water Treatment",
                [
                    NewLocPair(<5583, -30000, 3070>, <0, 0, 0>),
                    NewLocPair(<7544, -29035, 3061>, <0, 130, 0>),
                    NewLocPair(<10091, -30000, 3070>, <0, 180, 0>),
                    NewLocPair(<8487, -28838, 3061>, <0, -45, 0>),
					NewLocPair(<6544.66455, -29117, 3200.05591>,<0, -44.7344246, 0>),
					NewLocPair(<9038.57422, -31199.7852, 3102.63599>,<0, 48.6750031, 0>),
					NewLocPair(<9157.78809, -29951.9668, 3873.7229>,<0, -2.8198905, 0>),
                ],
                <0, 0, 3000>,$"rui/flowstatelocations/watert"
            )
        )
		
        // RegisterLocationPROPHUNT(
            // NewLocationSettings(
                // "The Pit",
                // [
                    // NewLocPair(<-18558, 13823, 3605>, <0, 20, 0>),
                    // NewLocPair(<-16514, 16184, 3772>, <0, -77, 0>),
                    // NewLocPair(<-13826, 15325, 3749>, <0, 160, 0>),
                    // NewLocPair(<-16160, 14273, 3770>, <0, 101, 0>)
                // ],
                // <0, 0, 7000>,$"rui/flowstatelocations/pit"
            // )
        // )
		
        RegisterLocationPROPHUNT(
            NewLocationSettings(
                "Airbase",
                [
                    NewLocPair(<-24140, -4510, 2583>, <0, 90, 0>),
                    NewLocPair(<-28675, 612, 2600>, <0, 18, 0>),
                    NewLocPair(<-24688, 1316, 2583>, <0, 180, 0>),
                    NewLocPair(<-26492, -5197, 2574>, <0, 50, 0>),
					NewLocPair(<-26304.3945, -4347.16602, 2554.1416>,<0, -21.3504105, 0>),
					NewLocPair(<-25275.1406, -5934.34912, 2620.34619>,<0, 69.685997, 0>),
					NewLocPair(<-24313.0508, -1477.07495, 3559.13696>,<0, 163.994537, 0>),
					NewLocPair(<-25072.6992, -3499.8147, 2565.59424>,<0, -97.5897827, 0>)
                ],
                <0, 0, 3000>,$"rui/flowstatelocations/airbase"
            )
        )
	    break

	    case eMaps.mp_rr_desertlands_64k_x_64k_nx:		
	    case eMaps.mp_rr_desertlands_64k_x_64k:
		
		prophuntAssets = [
			$"mdl/barriers/concrete/concrete_barrier_01.rmdl",
			$"mdl/vehicles_r5/land/msc_truck_samson_v2/veh_land_msc_truck_samson_v2.rmdl",
			$"mdl/angel_city/vending_machine.rmdl",
			$"mdl/utilities/power_gen1.rmdl",
			$"mdl/angel_city/box_small_02.rmdl",
			$"mdl/colony/antenna_05_colony.rmdl",
			$"mdl/garbage/trash_bin_single_wtrash_Blue.rmdl",
			$"mdl/angel_city/box_small_01.rmdl",
			$"mdl/garbage/dumpster_dirty_open_a_02.rmdl",
			$"mdl/containers/slumcity_oxygen_tank_red.rmdl",
			$"mdl/containers/box_shrinkwrapped.rmdl",
			$"mdl/colony/farmland_fridge_01.rmdl",
			$"mdl/furniture/chair_beanbag_01.rmdl",
			$"mdl/colony/farmland_crate_plastic_01_red.rmdl",
			$"mdl/IMC_base/generator_IMC_01.rmdl",
			$"mdl/garbage/trash_can_metal_02_b.rmdl",
			$"mdl/garbage/trash_bin_single_wtrash.rmdl"
			//nuevos
			$"mdl/containers/slumcity_oxygen_bag_large_01_b.rmdl",
			$"mdl/containers/slumcity_oxygen_tank_blue.rmdl",
			$"mdl/containers/barrel.rmdl",
			$"mdl/containers/container_medium_tanks_blue.rmdl",
			$"mdl/containers/underbelly_cargo_container_128_red_02.rmdl",
			$"mdl/containers/underbelly_cargo_container_128_blue_02.rmdl",
			$"mdl/containers/pelican_case_large.rmdl",
			$"mdl/containers/box_med_cardboard_03.rmdl",
			$"mdl/furniture/couch_suede_brown_01.rmdl",
			$"mdl/colony/farmland_crate_md_80x64x72_01.rmdl",
			$"mdl/colony/farmland_crate_md_80x64x72_03.rmdl",
			$"mdl/industrial/vending_machine_02.rmdl",
			$"mdl/angel_city/jersey_barrier_large_02.rmdl",
			$"mdl/angel_city/vending_machine.rmdl"
			
		]
		
		RegisterLocationPROPHUNT(
				NewLocationSettings(
					"TTV Building",
					[
						NewLocPair(<11407, 6778, -4295>, <0, 88, 0>),
						NewLocPair(<11973, 4158, -4220>, <0, 82, 0>),
						NewLocPair(<9956, 3435, -4239>, <0, 0, 0>),
						NewLocPair(<9038, 3800, -4120>, <0, -88, 0>),
						NewLocPair(<7933, 6692, -4250>, <0, 76, 0>),
						NewLocPair(<8990, 5380, -4250>, <0, 145, 0>),
						NewLocPair(<8200, 5463, -3815>, <0, 0, 0>),
						NewLocPair(<9789, 5363, -3480>, <0, 174, 0>),
						NewLocPair(<9448, 5804, -4000>, <0, 0, 0>),
						NewLocPair(<8135, 4087, -4233>, <0, 90, 0>),
						NewLocPair(<9761, 5980, -4250>, <0, 135, 0>),
						NewLocPair(<11393, 5477, -4289>, <0, 90, 0>),
						NewLocPair(<12027, 7121, -4290>, <0, -120, 0>),
						NewLocPair(<8105, 6156, -4300>, <0, -45, 0>),
						NewLocPair(<9420, 5528, -4236>, <0, 90, 0>),
						NewLocPair(<8277, 6304, -3940>, <0, 0, 0>),
						NewLocPair(<8186, 5513, -3828>, <0, 0, 0>),
						NewLocPair(<8243, 4537, -4235>, <-13, 32, 0>),
						NewLocPair(<11700, 6207, -4435>, <-10, 90, 0>),
						NewLocPair(<11181, 5862, -3900>, <0, -180, 0>),
						NewLocPair(<9043, 5866, -4171>, <0, 90, 0>),
						NewLocPair(<11210, 4164, -4235>, <0, 90, 0>),
						NewLocPair(<12775, 4446, -4235>, <0, 150, 0>),
						NewLocPair(<9012, 5386, -4242>, <0, 90, 0>)
					],
					<0, 0, 3000>,$"rui/flowstatelocations/ttvbuilding"
				)
			)
		RegisterLocationPROPHUNT(
                NewLocationSettings(
                    "Lava Fissure",
                    [
                        NewLocPair(<-26550, 13746, -3048>, <0, -134, 0>),
                        NewLocPair(<-28877, 12943, -3109>, <0, -88.70, 0>),
                        NewLocPair(<-29881, 9168, -2905>, <-1.87, -2.11, 0>),
                        NewLocPair(<-27590, 9279, -3109>, <0, 90, 0>),
                        NewLocPair(<-27585, 9191, -3080>, <0, 89, 0>),
                        NewLocPair(<-26469, 9825, -2810>, <0, 87, 0>),
                        NewLocPair(<-27623, 10210, -3290>, <0, 87, 0>),
                        NewLocPair(<-25717, 13034, -3047>, <0, -176, 0>),
                        NewLocPair(<-26433, 13360, -3000>, <0, 68, 0>),
                        NewLocPair(<-26463, 13766, -3080>, <0, -95, 0>),
                        NewLocPair(<-28781, 13266, -3080>, <0, 80, 0>),
                        NewLocPair(<-27535, 10922, -3000>, <0, -94, 0>),
                        NewLocPair(<-29879, 9151, -2860>, <0, 0, 0>)
                    ],
                    <0, 0, 2500>,$"rui/flowstatelocations/lavafissure"
                )
            )
			
		RegisterLocationPROPHUNT(
                NewLocationSettings(
                    "Space Elevator",
                    [
                        NewLocPair(<-12286, 26037, -4012>, <0, -116, 0>),
                        NewLocPair(<-12318, 28447, -3975>, <0, -122, 0>),
                        NewLocPair(<-14373, 27785, -3961>, <0, -25, 0>),
                        NewLocPair(<-11638, 26123, -3983>, <0, 137, 0>),
						NewLocPair(<-13348, 27630, -3535>, <3.01, 57.17, 0>),
						NewLocPair(<-13772, 26473, -4000>, <0, 169, 0>),
                        NewLocPair(<-12366, 26209, -4000>, <0, -90, 0>),
                        NewLocPair(<-12063, 27640, -4000>, <0, -3, 0>),
                        NewLocPair(<-13732, 27577, -3500>, <0, -83, 0>),
                        NewLocPair(<-13732, 27577, -3500>, <0, -83, 0>),
                        NewLocPair(<-12350, 26227, -3500>, <0, 148, 0>),
                        NewLocPair(<-13765, 27654, -2850>, <0, -65, 0>),
                        NewLocPair(<-12121, 26517, -2850>, <0, 124, 0>)
                    ],
                    <0, 0, 2000>,$"rui/flowstatelocations/spaceelevator"
                )
            )
			
		RegisterLocationPROPHUNT(
                NewLocationSettings(
                    "Hammies Hideout",
                    [
                        NewLocPair(<22857, 3449, -4050>, <0, -157, 0>),
                        NewLocPair(<19559, 232, -4035>, <0, 33, 0>),
                        NewLocPair(<19400, 4384, -4027>, <0, -35, 0>)
                    ],
                    <0, 0, 2000>,$"rui/flowstatelocations/littletown"
                )
            )

		RegisterLocationPROPHUNT(
                NewLocationSettings(
                    "TTV Building 2",
                    [
                        NewLocPair(<1313, 4450, -2990>, <0, 50, 0>),
                        NewLocPair(<2300, 6571, -4490>, <0, -96, 0>),
						NewLocPair(<2617, 4668, -4250>, <0, 85, 0>),
                        NewLocPair(<1200, 4471, -4150>, <0, 50, 0>)
                    ],
                    <0, 0, 2000>,$"rui/flowstatelocations/ttvbuilding2"
                )
            )

		RegisterLocationPROPHUNT(
                NewLocationSettings(
                    "Armag Town",
                    [
                        NewLocPair(<-27219, -24393, -4497>, <0, 87, 0>),
                        NewLocPair(<-26483, -28042, -4209>, <0, 122, 0>),
                        NewLocPair(<-25174, -26091, -4550>, <0, 177, 0>),
						NewLocPair(<-29512, -25863, -4462>, <0, 3, 0>),
						NewLocPair(<-28380, -28984, -4102>, <0, 54, 0>)
                    ],
                    <0, 0, 2000>,$"rui/flowstatelocations/littletown2"
                )
            )

	    RegisterLocationPROPHUNT(
                NewLocationSettings(
                    "Dome",
                    [
                        NewLocPair(<19351, -41456, -2192>, <0, 96, 0>),
                        NewLocPair(<22925, -37060, -2169>, <0, -156, 0>),
                        NewLocPair(<19772, -34549, -2232>, <0, -137, 0>),
					    NewLocPair(<17010, -37125, -2129>, <0, 81, 0>),
					    NewLocPair(<15223, -40222, -1998>, <0, 86, 0>)
                    ],
                    <0, 0, 2000>,$"rui/flowstatelocations/dome"
                )
            )

		// RegisterLocationPROPHUNT(
                // NewLocationSettings(
                    // "Refinery",
                    // [
                        // NewLocPair(<22970, 27159, -4612>, <0, 135, 0>),
                        // NewLocPair(<20430, 26481, -4200>, <0, 135, 0>),
                        // NewLocPair(<19142, 30982, -4612>, <0, -45, 0>),
                        // NewLocPair(<18285, 28602, -4200>, <0, -45, 0>),
                        // NewLocPair(<19228, 25592, -4821>, <0, 135, 0>),
                        // NewLocPair(<19495, 29283, -4821>, <0, -45, 0>),
                        // NewLocPair(<18470, 28330, -4370>, <0, 135, 0>),
                        // NewLocPair(<18461, 28405, -4199>, <0, 45, 0>),
                        // NewLocPair(<18284, 28492, -3992>, <0, -45, 0>),
                        // NewLocPair(<19428, 27190, -4140>, <0, -45, 0>),
                        // NewLocPair(<20435, 26254, -3950>, <0, -175, 0>),
                        // NewLocPair(<20222, 26549, -4316>, <0, 135, 0>),
                        // NewLocPair(<19444, 25605, -4602>, <0, 45, 0>),
                        // NewLocPair(<21751, 29980, -4226>, <0, -135, 0>),
                        // NewLocPair(<17570, 26915, -4637>, <0, -90, 0>),
                        // NewLocPair(<16715, 28017, -4650>, <0, -45, 0>)
                    // ],
                    // <0, 0, 6500>,$"rui/flowstatelocations/refinery"
                // )
            // )
			
		RegisterLocationPROPHUNT(
                NewLocationSettings(
                    "Factory",
                    [
                        NewLocPair(<495.42, -26649.92, -3038.36>, <10.60, 44.95, -0>),
                        NewLocPair(<648.07, -26450.72, -3547.97>, <10.20, 57.48, -0>),
                        NewLocPair(<1653.03, -22939.29, -3571.97>, <12.00, -1.80, -0>),
                        NewLocPair(<1722.22, -20823.69, -3719.31>, <7.45, -0.78, -0>),
                        NewLocPair(<2193.69, -25349.72, -3443.97>, <3.69, 15.20, -0>),
                        NewLocPair(<2557.95, -25035.46, -2971.97>, <2.00, 31.20, -0>),
                        NewLocPair(<2608.53, -21670.90, -3707.97>, <11.75, 89.78, -0>),
                        NewLocPair(<2240.71, -23184.89, -3187.97>, <-5.40, -87.58, -0>),
                        NewLocPair(<3507.99, -24980.33, -3571.97>, <-6.62, -36.62, -0>),
                        NewLocPair(<3954.13, -18102.04, -3582.36>, <-8.11, -29.47, 0>),
                        NewLocPair(<4450.69, -20891.45, -3507.85>, <11.16, -44.58, -0.00>),
                        NewLocPair(<6090.35, -25075.12, -3563.97>, <2.47, -0.46, -0>),
                        NewLocPair(<7415.33, -20497.42, -3631.94>, <8.72, 84.13, -0>),
                        NewLocPair(<7422.97, -17985.25, -3507.97>, <8.41, -45.65, -0>),
                        NewLocPair(<8240.16, -24245.68, -3547.97>, <8.23, 50.62, -0>),
                        NewLocPair(<9259.17, -22461.68, -3283.97>, <9.92, -28.07, -0>),
                        NewLocPair(<9534.27, -19869.87, -3331.97>, <3.73, -91.33, -0>),
                        NewLocPair(<10111.38, -20003.82, -2752.97>, <18.04, 84.92, -0>),
                        NewLocPair(<11252.87, -16981.14, -2752.97>, <17.64, -104.16, 0>),
                        NewLocPair(<11720.60, -19655.80, -3331.97>, <1.44, -116.68, -0>),
                        NewLocPair(<12233.26, -18075.12, -2581.72>, <4.60, -134.70, 0>),
                    ],
                    <0, 0, 3000>,$"rui/flowstatelocations/factory"
                )
            )

        RegisterLocationPROPHUNT(
                NewLocationSettings(
                    "Lava City",
                    [
                        NewLocPair(<22663, -28134, -2706>, <0, 40, 0>),
                        NewLocPair(<22844, -28222, -3030>, <0, 90, 0>),
                        NewLocPair(<22687, -27605, -3434>, <0, -90, 0>),
                        NewLocPair(<22610, -26999, -2949>, <0, 90, 0>),
                        NewLocPair(<22607, -26018, -2749>, <0, -90, 0>),
                        NewLocPair(<22925, -25792, -3500>, <0, -120, 0>),
                        NewLocPair(<24235, -27378, -3305>, <0, -100, 0>),
                        NewLocPair(<24345, -28872, -3433>, <0, -144, 0>),
                        NewLocPair(<24446, -28628, -3252>, <13, 0, 0>),
                        NewLocPair(<23931, -28043, -3265>, <0, 0, 0>),
                        NewLocPair(<27399, -28588, -3721>, <0, 130, 0>),
                        NewLocPair(<26610, -25784, -3400>, <0, -90, 0>),
                        NewLocPair(<26757, -26639, -3673>, <-10, 90, 0>),
                        NewLocPair(<26750, -26202, -3929>, <-10, -90, 0>)
                    ],
                    <0, 0, 3000>,$"rui/flowstatelocations/lavacity"
                )
            )
			
        RegisterLocationPROPHUNT(
                NewLocationSettings(
                    "Thermal Station",
                    [
                        NewLocPair(<-20091, -17683, -3984>, <0, -90, 0>),
						NewLocPair(<-22919, -20528, -4010>, <0, 0, 0>),
						NewLocPair(<-17140, -20710, -3973>, <0, -180, 0>),
                        NewLocPair(<-21054, -23399, -3850>, <0, 90, 0>),
                        NewLocPair(<-20938, -23039, -4252>, <0, 90, 0>),
                        NewLocPair(<-19361, -23083, -4252>, <0, 100, 0>),
                        NewLocPair(<-19264, -23395, -3850>, <0, 100, 0>),
                        NewLocPair(<-16756, -20711, -3982>, <0, 180, 0>),
                        NewLocPair(<-17066, -20746, -4233>, <0, 180, 0>),
                        NewLocPair(<-17113, -19622, -4200>, <10, -170, 0>),
                        NewLocPair(<-20092, -17684, -4252>, <0, -90, 0>),
                        NewLocPair(<-23069, -20567, -4214>, <-11, 146, 0>),
                        NewLocPair(<-20109, -20675, -4252>, <0, -90, 0>)
                    ],
                    <0, 0, 11000>,$"rui/flowstatelocations/thermalstation"
                )
            )
			
		RegisterLocationPROPHUNT(
                NewLocationSettings(
                    "Epicenter",
                    [
                        NewLocPair(<8712, 23164, -3944>, <0, -49, 0>),
                        NewLocPair(<14000, 21690, -3969>, <0, -130, 0>),
                        NewLocPair(<10377, 17994, -4236>, <0, -120, 0>),
						NewLocPair(<13100, 18138, -4856>, <0, 120, 0>)

                    ],
                    <0, 0, 2000>,$"rui/flowstatelocations/epicenter"
                )
            )
			
		RegisterLocationPROPHUNT(
                NewLocationSettings(
                    "Overlook",
                    [
                        NewLocPair(<32774, 6031, -3239>, <0, 117, 0>),
                        NewLocPair(<28381, 8963, -3224>, <0, 48, 0>),
                        NewLocPair(<26327, 11857, -2477>, <0, -43, 0>),
						NewLocPair(<27303, 14528, -3047>, <0, -42, 0>)
                    ],
                    <0, 0, 2000>,$"rui/flowstatelocations/overlook"
                )
            )	
			
		RegisterLocationPROPHUNT(
                NewLocationSettings(
                    "Train yard",
                    [
                        NewLocPair(<-11956,3021,-2988>, <0, 87, 0>),
                        NewLocPair(<-13829,2836,-3037>, <0, 122, 0>),
                        NewLocPair(<-12883,4502,-3340>, <0, 177, 0>),
						NewLocPair(<-11412,3692,-3405>, <0, 3, 0>),
						NewLocPair(<-14930,2065,-3140>, <0, 3, 0>)
                    ],
                    <0, 0, 2000>,$"rui/flowstatelocations/trainyard"
                )
            )
		break
	}
}

void function RegisterLocationPROPHUNT(LocationSettings locationSettings)
{
    #if SERVER
    _RegisterLocationPROPHUNT(locationSettings)
    #endif
	
	#if CLIENT
    Cl_RegisterLocation(locationSettings)
    #endif

}

vector function GetCenterOfCircle( array<LocPair> spawns )
{
	vector total

	foreach ( spawnLocation in spawns )
	{
		total += spawnLocation.origin
	}

	total.x /= float( spawns.len() )
	total.y /= float( spawns.len() )
	total.z /= float( spawns.len() )

	return total
}
