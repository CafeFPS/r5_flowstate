#if SERVER
globalize_all_functions
#endif
globalize_all_functions

global const NO_CHOICES = 2
global const SCORE_GOAL_TO_WIN = 100

global enum eTDMAnnounce
{
	NONE = 0
	WAITING_FOR_PLAYERS = 1
	ROUND_START = 2
	VOTING_PHASE = 3
	MAP_FLYOVER = 4
	IN_PROGRESS = 5
}

global struct LocPair
{
    vector origin = <0, 0, 0>
    vector angles = <0, 0, 0>
}

global struct LocationSettings
{
    string name
    array<LocPair> spawns
    vector cinematicCameraOffset
}

struct {
    LocationSettings &selectedLocation
    array choices
    array<LocationSettings> locationSettings
    var scoreRui
} file;

void function Sh_CustomTDM_Init()
{


    // Map locations

    switch(GetMapName())
    {
   case "mp_rr_aqueduct":
   case "mp_rr_aqueduct_night":
        Shared_RegisterLocation(
            NewLocationSettings(
               "Overflow",
                [
                    NewLocPair(<3863.79321, -3262.95703, 282.03125>, <0, -135.066055, 0>),
                    NewLocPair(<4169.18262, -5555.22119, 410.03125>, <0, 146.240646, 0>),
                    NewLocPair(<-620.375977, -6611.72803, 410.03125>, <0, 29.9391613, 0>),
                    NewLocPair(<-1859.04651, -3355.55103, 282.03125>, <0, -51.3485374, 0>),
                    NewLocPair(<817.221375, -3503.38354, 482.03125>, <0, 44.7887459, 0>)
                ],
                <0, 0, 3000>
            )
        )
        break
   case "mp_rr_canyonlands_staging":
        Shared_RegisterLocation(
            NewLocationSettings(
               "Deathbox by Ayezee",
                [
                    //Top Floor
                    NewLocPair(<29351, -8106, -15794>, <4, 45, 0>),
                    NewLocPair(<32678, -8106, -15794>, <4, 135, 0>),
                    NewLocPair(<29351, -4780, -15794>, <4, -45, 0>),
                    NewLocPair(<32678, -4780, -15794>, <4, -135, 0>),

                    //Bottom Floor
                    NewLocPair(<29351, -8106, -16073>, <4, 45, 0>),
                    NewLocPair(<32678, -8106, -16073>, <4, 135, 0>),
                    NewLocPair(<29351, -4780, -16073>, <4, -45, 0>),
                    NewLocPair(<32678, -4780, -16073>, <4, -135, 0>),

                    //Other
                    NewLocPair(<32682, -6574, -15794>, <0, 180, 0>),
                    NewLocPair(<29340, -6318, -15794>, <0, 0, 0>),
                    NewLocPair(<31138, -4778, -15794>, <0, -90, 0>),
                    NewLocPair(<30882, -8116, -15794>, <0, 90, 0>)
                ],
                <0, 0, 3000>
            )
        )
        break
    case "mp_rr_ashs_redemption":
        Shared_RegisterLocation(
            NewLocationSettings(
                "Ash's Redemption",
                [
                    NewLocPair(<-22104, 6009, -26529>, <0, 0, 0>),
					NewLocPair(<-21372, 3709, -26555>, <-5, 55, 0>),
                    NewLocPair(<-19356, 6397, -26461>, <-4, -166, 0>),
					NewLocPair(<-20713, 7409, -26442>, <-4, -114, 0>)
                ],
                <0, 0, 1000>
            )
        )

        break
    case "mp_rr_arena_composite":
        Shared_RegisterLocation(
            NewLocationSettings(
                "Drop-Off",
                [
					NewLocPair(<-3592, 1081, 258>, <0, 37, 0>),
					NewLocPair(<3592, 1081, 258>, <0, 142, 0>),
					NewLocPair(<-1315, 4113, 71>, <0, -43, 0>),
					NewLocPair(<1315, 4113, 71>, <0, -136, 0>),
					NewLocPair(<-1374, 1, 259>, <0, 35, 0>),
					NewLocPair(<1374, 1, 259>, <0, 140, 0>),
					NewLocPair(<-1383.81238, 2653.86523, -50>,<0, -102.007385, 0>),
					NewLocPair(<-12.9539881, 3344.23584, -34>,<0, -92.351532, 0>),
					NewLocPair(<1705.29504, 3284.08252, 210>,<0, -142.564148, 0>),
					NewLocPair(<1402.96716, 2709.0498, -50>,<0, -126.903221, 0>),
					NewLocPair(<1402.96716, 2709.0498, -50>,<0, -126.903221, 0>),
					NewLocPair(<692.371887, 1771.11829, -50>,<0, 51.6300087, 0>),
					NewLocPair(<-358.171814, 1723.92322, -50>,<0, 45.0872917, 0>),
					NewLocPair(<-912.219482, 2789.4751, 10>,<0, -53.7381134, 0>)
                ],
                <0, 0, 1000>
            )
        )
        break
	case "mp_rr_canyonlands_mu1_night":		
	case "mp_rr_canyonlands_mu1":
		Shared_RegisterLocation(
            NewLocationSettings(
                "Hillside Outspot",
                [
                    NewLocPair(<-20579, 6322, 2912>, <0, -100, 0>),
                    NewLocPair(<-17075, 7502, 3206>, <0, -90, 0>),
                    NewLocPair(<-14421, -405, 3315>, <0, 62, 0>),
                    NewLocPair(<-18633, -1146, 3320>, <0, 114, 0>),
					NewLocPair(<-22921, 3307, 3144>, <0, 6, 0>),
					NewLocPair(<-16154, 3072, 3898>, <0, 86, 0>),
					NewLocPair(<-19026, 3749, 4460>, <0, 2, 0>)
                ],
                <0, 0, 3000>
            )
        )
		Shared_RegisterLocation(
            NewLocationSettings(
                "Skull Town",
                [
                    NewLocPair(<-9320, -13528, 3167>, <0, -100, 0>),
                    NewLocPair(<-7544, -13240, 3161>, <0, -115, 0>),
                    NewLocPair(<-10250, -18320, 3323>, <0, 100, 0>),
                    NewLocPair(<-13261, -18100, 3337>, <0, 20, 0>)
                ],
                <0, 0, 3000>
            )
        )
		Shared_RegisterLocation(
            NewLocationSettings(
                "Containment",
                [
                    NewLocPair(<-7291, 19547, 2978>, <0, -65, 0>),
                    NewLocPair(<-3906, 19557, 2733>, <0, -123, 0>),
                    NewLocPair(<-3084, 16315, 2566>, <0, 144, 0>),
                    NewLocPair(<-6517, 15833, 2911>, <0, 51, 0>)
                ],
                <0, 0, 3000>
            )
        )
		Shared_RegisterLocation(
            NewLocationSettings(
                "Gaunlet",
                [
                    NewLocPair(<-21271, -15275, 2781>, <0, 90, 0>),
                    NewLocPair(<-22952, -13304, 2718>, <0, 5, 0>),
                    NewLocPair(<-22467, -9567, 2949>, <0, -85, 0>),
                    NewLocPair(<-18494, -10427, 2825>, <0, -155, 0>),
					NewLocPair(<-22590, -7534, 3103>, <0, 0, 0>)
                ],
                <0, 0, 4000>
            )
        )
		Shared_RegisterLocation(
            NewLocationSettings(
                "Market",
                [
                    NewLocPair(<-110, -9977, 2987>, <0, 0, 0>),
                    NewLocPair(<-1605, -10300, 3053>, <0, -100, 0>),
                    NewLocPair(<4600, -11450, 2950>, <0, 180, 0>),
                    NewLocPair(<3150, -11153, 3053>, <0, 100, 0>)
                ],
                <0, 0, 3000>
            )
        )
		Shared_RegisterLocation(
            NewLocationSettings(
                "Labs",
                [
                    NewLocPair(<27576, 8062, 2910>, <0, -115, 0>),
					NewLocPair(<24545, 2387, 4100>, <0, -7, 0>),
                    NewLocPair(<25924, 2161, 3848>, <0, -9, 0>),
                    NewLocPair(<28818, 2590, 3798>, <0, 117, 0>)
                ],
                <0, 0, 3000>
            )
        )
		Shared_RegisterLocation(
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
                    NewLocPair(<27133, -16074, 5414>, <0, -90, 0>),
                    NewLocPair(<27051, -14200, 5582>, <0, -90, 0>)
                ],
                <0, 0, 3000>
            )
        )

		Shared_RegisterLocation(
			NewLocationSettings(
                "Cage",
                [
                    NewLocPair(<15604, -1068, 5833>, <0, -126, 0>),
                    NewLocPair(<18826, -4314, 5032>, <0, 173, 0>),
                    NewLocPair(<19946, 32, 4960>, <0, -168, 0>),
                    NewLocPair(<12335, -1446, 3984>, <0, 2, 0>)
                ],
                <0, 0, 3000>
            )
        )

		Shared_RegisterLocation(
            NewLocationSettings(
                "Swamps",
                [
                    NewLocPair(<37886, -4012, 3300>, <0, 167, 0>),
                    NewLocPair(<34392, -5974, 3017>, <0, 51, 0>),
                    NewLocPair(<29457, -2989, 2895>, <0, -17, 0>),
                    NewLocPair(<34582, 2300, 2998>, <0, -92, 0>),
					NewLocPair(<35757, 3256, 3290>, <0, -90, 0>),
                    NewLocPair(<36422, 3109, 3294>, <0, -165, 0>),
                    NewLocPair(<34965, 1718, 3529>, <0, 45, 0>),
                    NewLocPair(<32654, -1552, 3228>, <0, -90, 0>)

                ],
                <0, 0, 3000>
            )
        )

		Shared_RegisterLocation(
            NewLocationSettings(
                "Interstellar Relay",
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
                <0, 0, 3000>
            )
        )
		
        Shared_RegisterLocation(
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
                <0, 0, 3000>
            )
        )
		
        Shared_RegisterLocation(
            NewLocationSettings(
                "Little Town",
                [
                    NewLocPair(<-30190, 12473, 3186>, <0, -90, 0>),
                    NewLocPair(<-28773, 11228, 3210>, <0, 180, 0>),
                    NewLocPair(<-29802, 9886, 3217>, <0, 90, 0>),
                    NewLocPair(<-30895, 10733, 3202>, <0, 0, 0>)
                ],
                <0, 0, 3000>
            )
        )

        Shared_RegisterLocation(
            NewLocationSettings(
                "Runoff",
                [
                    NewLocPair(<-23380, 9634, 3371>, <0, 90, 0>),
                    NewLocPair(<-24917, 11273, 3085>, <0, 0, 0>),
                    NewLocPair(<-23614, 13605, 3347>, <0, -90, 0>),
                    NewLocPair(<-24697, 12631, 3085>, <0, 0, 0>)
                ],
                <0, 0, 3000>
            )
        )
		
		Shared_RegisterLocation(
            NewLocationSettings(
                "Big fights happened here",
                [
                    NewLocPair(<11242, 8591, 4630>, <0, 0, 0>),
                    NewLocPair(<6657, 12189, 5066>, <0, -90, 0>),
                    NewLocPair(<7540, 8620, 5374>, <0, 89, 0>),
                    NewLocPair(<13599, 7838, 4944>, <0, 150, 0>)
                ],
                <0, 0, 3000>
            )
        )
		
        Shared_RegisterLocation(
            NewLocationSettings(
                "Thunderdome",
                [
                    NewLocPair(<-20216, -21612, 3191>, <0, -67, 0>),
                    NewLocPair(<-16035, -20591, 3232>, <0, -133, 0>),
                    NewLocPair(<-16584, -24859, 2642>, <0, 165, 0>),
                    NewLocPair(<-19019, -26209, 2640>, <0, 65, 0>)
                ],
                <0, 0, 2000>
            )
        )
        Shared_RegisterLocation(
            NewLocationSettings(
                "Water Treatment",
                [
                    NewLocPair(<5583, -30000, 3070>, <0, 0, 0>),
                    NewLocPair(<7544, -29035, 3061>, <0, 130, 0>),
                    NewLocPair(<10091, -30000, 3070>, <0, 180, 0>),
                    NewLocPair(<8487, -28838, 3061>, <0, -45, 0>)
                ],
                <0, 0, 3000>
            )
        )
		
        Shared_RegisterLocation(
            NewLocationSettings(
                "The Pit",
                [
                    NewLocPair(<-18558, 13823, 3605>, <0, 20, 0>),
                    NewLocPair(<-16514, 16184, 3772>, <0, -77, 0>),
                    NewLocPair(<-13826, 15325, 3749>, <0, 160, 0>),
                    NewLocPair(<-16160, 14273, 3770>, <0, 101, 0>)
                ],
                <0, 0, 7000>
            )
        )
		
        Shared_RegisterLocation(
            NewLocationSettings(
                "Airbase",
                [
                    NewLocPair(<-24140, -4510, 2583>, <0, 90, 0>),
                    NewLocPair(<-28675, 612, 2600>, <0, 18, 0>),
                    NewLocPair(<-24688, 1316, 2583>, <0, 180, 0>),
                    NewLocPair(<-26492, -5197, 2574>, <0, 50, 0>)
                ],
                <0, 0, 3000>
            )
        )		
		///////////////////////////////////
		//PROPHUNT LOCATIONS///////////////
		RegisterLocationPROPHUNT(
            NewLocationSettings(
                "Hillside Outspot",
                [
                    NewLocPair(<-16896,3904,3200>, <0, -100, 0>),
                    NewLocPair(<-15232,3200,3264>, <0, -90, 0>),
                    NewLocPair(<-14848,2112,3328>, <0, 62, 0>),
                    NewLocPair(<-18112,3584,3264>, <0, 114, 0>)
                ],
                <0, 0, 3000>
            )
        )
		
		RegisterLocationPROPHUNT(
            NewLocationSettings(
                "Skull Town",
                [
                    NewLocPair(<-9320, -13528, 3167>, <0, -100, 0>),
                    NewLocPair(<-7544, -13240, 3161>, <0, -115, 0>),
                    NewLocPair(<-10250, -18320, 3323>, <0, 100, 0>),
                    NewLocPair(<-13261, -18100, 3337>, <0, 20, 0>)
                ],
                <0, 0, 3000>
            )
        )
		
		RegisterLocationPROPHUNT(
            NewLocationSettings(
                "Containment",
                [
                    NewLocPair(<-7291, 19547, 2978>, <0, -65, 0>),
                    NewLocPair(<-3906, 19557, 2733>, <0, -123, 0>),
                    NewLocPair(<-3084, 16315, 2566>, <0, 144, 0>),
                    NewLocPair(<-6517, 15833, 2911>, <0, 51, 0>)
                ],
                <0, 0, 3000>
            )
        )
		
		RegisterLocationPROPHUNT(
            NewLocationSettings(
                "Gaunlet",
                [
                    NewLocPair(<-21271, -15275, 2781>, <0, 90, 0>),
                    NewLocPair(<-22952, -13304, 2718>, <0, 5, 0>),
                    NewLocPair(<-22467, -9567, 2949>, <0, -85, 0>),
                    NewLocPair(<-18494, -10427, 2825>, <0, -155, 0>)
				],
                <0, 0, 4000>
            )
        )
		
		RegisterLocationPROPHUNT(
            NewLocationSettings(
                "Market",
                [
                    NewLocPair(<-110, -9977, 2987>, <0, 0, 0>),
                    NewLocPair(<-1605, -10300, 3053>, <0, -100, 0>),
                    NewLocPair(<4600, -11450, 2950>, <0, 180, 0>),
                    NewLocPair(<3150, -11153, 3053>, <0, 100, 0>)
                ],
                <0, 0, 3000>
            )
        )

	break
	case "mp_rr_canyonlands_64k_x_64k":
		
		Shared_RegisterLocation(
				NewLocationSettings(
					"Interstellar Relay",
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
					<0, 0, 3000>
				)
			)
		Shared_RegisterLocation(
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
					<0, 0, 3000>
				)
			)
		Shared_RegisterLocation(
				NewLocationSettings(
					"Little Town",
					[
						NewLocPair(<-30190, 12473, 3186>, <0, -90, 0>),
						NewLocPair(<-28773, 11228, 3210>, <0, 180, 0>),
						NewLocPair(<-29802, 9886, 3217>, <0, 90, 0>),
						NewLocPair(<-30895, 10733, 3202>, <0, 0, 0>)
					],
					<0, 0, 3000>
				)
			)
		Shared_RegisterLocation(
				NewLocationSettings(
					"Runoff",
					[
						NewLocPair(<-23380, 9634, 3371>, <0, 90, 0>),
						NewLocPair(<-24917, 11273, 3085>, <0, 0, 0>),
						NewLocPair(<-23614, 13605, 3347>, <0, -90, 0>),
						NewLocPair(<-24697, 12631, 3085>, <0, 0, 0>)
					],
					<0, 0, 3000>
				)
			)
		Shared_RegisterLocation(
				NewLocationSettings(
					"Thunderdome",
					[
						NewLocPair(<-20216, -21612, 3191>, <0, -67, 0>),
						NewLocPair(<-16035, -20591, 3232>, <0, -133, 0>),
						NewLocPair(<-16584, -24859, 2642>, <0, 165, 0>),
						NewLocPair(<-19019, -26209, 2640>, <0, 65, 0>)
					],
					<0, 0, 2000>
				)
			)
		Shared_RegisterLocation(
				NewLocationSettings(
					"Water Treatment",
					[
						NewLocPair(<5583, -30000, 3070>, <0, 0, 0>),
						NewLocPair(<7544, -29035, 3061>, <0, 130, 0>),
						NewLocPair(<10091, -30000, 3070>, <0, 180, 0>),
						NewLocPair(<8487, -28838, 3061>, <0, -45, 0>)
					],
					<0, 0, 3000>
				)
			)
		Shared_RegisterLocation(
				NewLocationSettings(
					"The Pit",
					[
						NewLocPair(<-18558, 13823, 3605>, <0, 20, 0>),
						NewLocPair(<-16514, 16184, 3772>, <0, -77, 0>),
						NewLocPair(<-13826, 15325, 3749>, <0, 160, 0>),
						NewLocPair(<-16160, 14273, 3770>, <0, 101, 0>)
					],
					<0, 0, 7000>
				)
			)
		Shared_RegisterLocation(
				NewLocationSettings(
					"Airbase",
					[
						NewLocPair(<-24140, -4510, 2583>, <0, 90, 0>),
						NewLocPair(<-28675, 612, 2600>, <0, 18, 0>),
						NewLocPair(<-24688, 1316, 2583>, <0, 180, 0>),
						NewLocPair(<-26492, -5197, 2574>, <0, 50, 0>)
					],
					<0, 0, 3000>
				)
			)

		Shared_RegisterLocation(
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
						  NewLocPair(<27133, -16074, 5414>, <0, -90, 0>)
					],
					<0, 0, 3000>
				)
			)

		Shared_RegisterLocation(
				NewLocationSettings(
					"Swamps",
					[
						NewLocPair(<37886, -4012, 3300>, <0, 167, 0>),
						NewLocPair(<34392, -5974, 3017>, <0, 51, 0>),
						NewLocPair(<29457, -2989, 2895>, <0, -17, 0>),
						NewLocPair(<34582, 2300, 2998>, <0, -92, 0>),
						NewLocPair(<35757, 3256, 3290>, <0, -90, 0>),
						NewLocPair(<36422, 3109, 3294>, <0, -165, 0>),
						NewLocPair(<34965, 1718, 3529>, <0, 45, 0>),
						NewLocPair(<32654, -1552, 3228>, <0, -90, 0>)
					],
					<0, 0, 3000>
				)
			)
		Shared_RegisterLocation(
				NewLocationSettings(
					"Skull Town",
					[
						NewLocPair(<-9320, -13528, 3167>, <0, -100, 0>),
						NewLocPair(<-7544, -13240, 3161>, <0, -115, 0>),
						NewLocPair(<-10250, -18320, 3323>, <0, 100, 0>),
						NewLocPair(<-13261, -18100, 3337>, <0, 20, 0>)
					],
					<0, 0, 3000>
				)
			)
		Shared_RegisterLocation(
				NewLocationSettings(
					"Market",
					[
						NewLocPair(<-110, -9977, 2987>, <0, 0, 0>),
						NewLocPair(<-1605, -10300, 3053>, <0, -100, 0>),
						NewLocPair(<4600, -11450, 2950>, <0, 180, 0>),
						NewLocPair(<3150, -11153, 3053>, <0, 100, 0>)
					],
					<0, 0, 3000>
				)
			)
		if(FlowState_EnableCustomMapByBiscutz()){
		Shared_RegisterLocation(
				NewLocationSettings(
					"Custom map by Biscutz",
					[
						NewLocPair(<-2768,15163,6469>, <0, -180, 0>),
						NewLocPair(<-5800,16008,6706>, <0, -48, 0>),
						NewLocPair(<-5297,13404,6040>, <0, 0, 0>),
						NewLocPair(<-2348,11823,6194>, <0, 0, 0>),
						NewLocPair(<-5256,14392,5800>, <0, 0, 0>),
						NewLocPair(<-3659,13700,6600>, <0, 0, 0>),
						NewLocPair(<-1514,11165,7730>, <0, 0, 0>)
					],
					<0, 0, 3000>
				)
			)
		}	
			
		if(FlowState_EnableWhiteForestByZero()){
		Shared_RegisterLocation(
			NewLocationSettings(
				"White Forest By Zer0Bytes",
				[
					//Side A
					NewLocPair( <-33024,17408,3328>, <0,90,0>),
					NewLocPair( <-33024,16960,3328>, <0,90,0>),
					NewLocPair( <-33280,16128,3264>, <0,90,0>),
					NewLocPair( <-32448,16256,3328>, <0,90,0>),
					NewLocPair( <-32192,16960,3328>, <0,90,0>),
					NewLocPair( <-32256,16256,3328>, <0,90,0>),
					NewLocPair( <-32128,17536,3328>, <0,90,0>),
					NewLocPair( <-32512,17536,3328>, <0,90,0>),
					NewLocPair( <-32960,17600,3328>, <0,90,0>),
					NewLocPair( <-33536,17600,3328>, <0,90,0>),
					NewLocPair( <-33728,17088,3328>, <0,90,0>),
					NewLocPair( <-33856,16896,3200>, <0,90,0>),
					NewLocPair( <-33920,17600,3200>, <0,90,0>),
					NewLocPair( <-34368,18048,3072>, <0,0,0>),
					NewLocPair( <-34352,18038,3151>, <0,0,0>),
					NewLocPair( <-36696,19010,3021>, <0,0,0>),
					NewLocPair( <-37079,19432,3120>, <0,90,0>),
					NewLocPair( <-37335,19812,3053>, <0,0,0>),
					NewLocPair( <-37371,19308,3033>, <0,0,0>),
					NewLocPair( <-37106,19616,3152>, <0,0,0>),


					// side B
					NewLocPair( <-35442,24433,4112>, <0,-90,0>),
					NewLocPair( <-35467,24668,4112>, <0,-90,0>),
					NewLocPair( <-35454,24954,4135>, <0,-90,0>),
					NewLocPair( <-34738,24934,4145>, <0,-90,0>),
					NewLocPair( <-33453,24955,4152>, <0,-90,0>),
					NewLocPair( <-33380,24704,4173>, <0,-90,0>),
					NewLocPair( <-33498,24455,4148>, <0,-90,0>),
					NewLocPair( <-34195,24456,4128>, <0,-90,0>),
					NewLocPair( <-33745,24188,4093>, <0,-90,0>),
					NewLocPair( <-33319,24002,3955>, <0,-90,0>),
					NewLocPair( <-32764,23897,3382>, <0,-90,0>),
					NewLocPair( <-32317,23278,2779>, <0,-90,0>),
					NewLocPair( <-32100,22750,2647>, <0,180,0>),
					NewLocPair( <-35148,24427,4147>, <0,-90,0>),

					//forest
					NewLocPair( <-33511,22657,2239>, <0,-90,0>),
					NewLocPair( <-33813,21797,2178>, <0,-90,0>),
					NewLocPair( <-34937,22312,2195>, <0,-90,0>),
					NewLocPair( <-35843,23339,2172>, <0,0,0> ),
					NewLocPair( <-36700,23252,2237>, <0,0,0> ),
					NewLocPair( <-36374,21910,2204>, <0,0,0> ),
					NewLocPair( <-35239,22024,2154>, <0,180,0>),
					NewLocPair( <-34463,20783,2182>, <0,90,0>),
					NewLocPair( <-32753,20853,2085>, <0,90,0>),
					NewLocPair( <-31809,21230,2015>, <0,-90,0>),
					NewLocPair( <-33549,18878,2129>, <0,90,0>),
					NewLocPair( <-34726,19371,2106>, <0,90,0>),
					NewLocPair( <-34295,20018,2134>, <0,90,0>),
					NewLocPair( <-31263,21107,2019>, <0,180,0>),
					NewLocPair( <-36806,22295,2261>, <0,0,0> ),
					NewLocPair( <-36226,20102,2105>, <0,0,0>),
					NewLocPair( <-32764,19415,2048>, <0,180,0>),
					NewLocPair( <-32402,22605,2328>, <0,-90,0>),
					NewLocPair( <-33082,23773,2363>, <0,-90,0>)

				],
				<0, 0, 3000>
			)
		)  
		}	
		///////////////////////////////////
		//PROPHUNT LOCATIONS///////////////
		
		RegisterLocationPROPHUNT(
				NewLocationSettings(
					"Interstellar Relay",
					[
						NewLocPair(<26420, 31700, 4790>, <0, -90, 0>),
						NewLocPair(<29260, 26245, 4210>, <0, 45, 0>),
						NewLocPair(<29255, 24360, 4210>, <0, 0, 0>),
						NewLocPair(<24445, 28970, 4340>, <0, -90, 0>)
					],
					<0, 0, 3000>
				)
			)
		RegisterLocationPROPHUNT(
				NewLocationSettings(
					"Slum Lakes",
					[
						NewLocPair(<-20060, 23800, 2655>, <0, 110, 0>),
						NewLocPair(<-20245, 24475, 2810>, <0, -160, 0>),
						NewLocPair(<-25650, 22025, 2270>, <0, 20, 0>),
						NewLocPair(<-25550, 21635, 2590>, <0, 20, 0>)
					],
					<0, 0, 3000>
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
					<0, 0, 3000>
				)
			)

		RegisterLocationPROPHUNT(
				NewLocationSettings(
					"Water Treatment",
					[
						NewLocPair(<5583, -30000, 3070>, <0, 0, 0>),
						NewLocPair(<7544, -29035, 3061>, <0, 130, 0>),
						NewLocPair(<10091, -30000, 3070>, <0, 180, 0>),
						NewLocPair(<8487, -28838, 3061>, <0, -45, 0>)
					],
					<0, 0, 3000>
				)
			)

		RegisterLocationPROPHUNT(
				NewLocationSettings(
					"Airbase",
					[
						NewLocPair(<-24140, -4510, 2583>, <0, 90, 0>),
						NewLocPair(<-28675, 612, 2600>, <0, 18, 0>),
						NewLocPair(<-24688, 1316, 2583>, <0, 180, 0>),
						NewLocPair(<-26492, -5197, 2574>, <0, 50, 0>)
					],
					<0, 0, 3000>
				)
			)

		RegisterLocationPROPHUNT(
				NewLocationSettings(
					"Swamps",
					[
						NewLocPair(<32704,-8576,3520>, <0, 167, 0>),
						NewLocPair(<34496,-5888,3008>, <0, 51, 0>),
						NewLocPair(<33280,-4544,3072>, <0, -17, 0>),
						NewLocPair(<30720,-6080,2944>, <0, -92, 0>)
					],
					<0, 0, 3000>
				)
			)
		RegisterLocationPROPHUNT(
				NewLocationSettings(
					"Skull Town",
					[
						NewLocPair(<-9320, -13528, 3167>, <0, -100, 0>),
						NewLocPair(<-7544, -13240, 3161>, <0, -115, 0>),
						NewLocPair(<-10250, -18320, 3323>, <0, 100, 0>),
						NewLocPair(<-13261, -18100, 3337>, <0, 20, 0>)
					],
					<0, 0, 3000>
				)
			)
		RegisterLocationPROPHUNT(
				NewLocationSettings(
					"Market",
					[
						NewLocPair(<-110, -9977, 2987>, <0, 0, 0>),
						NewLocPair(<-1605, -10300, 3053>, <0, -100, 0>),
						NewLocPair(<4600, -11450, 2950>, <0, 180, 0>),
						NewLocPair(<3150, -11153, 3053>, <0, 100, 0>)
					],
					<0, 0, 3000>
				)
			)
		break
	///////////////////////////////////
	//END PROPHUNT LOCATIONS///////////////		
	
        case "mp_rr_desertlands_64k_x_64k":
        case "mp_rr_desertlands_64k_x_64k_nx":
		if(!GetCurrentPlaylistVarBool("flowstateCapitolCityReplacesTTVLocation", false ))
		{
		Shared_RegisterLocation(
			NewLocationSettings(
				"TTV Building",
				[
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
				<0, 0, 3000>
			)
		)
		}
		else{
		Shared_RegisterLocation(
			NewLocationSettings(
				"Capitol City",
				[
					NewLocPair(<1142, 5067, -3351>, <16, 18, 0>),
					NewLocPair(<1155, 5460, -3552>, <5, -62, 0>),
					NewLocPair(<1552, 5547, -3151>, <20, -166, 0>),
					NewLocPair(<1168, 4657, -4167>, <9, 58, 0>),
					NewLocPair(<1233, 5027, -3152>, <13, 55, 0>),
					NewLocPair(<2196, 3038, -4083>, <1, 1, 0>),
					NewLocPair(<2262, 4710, -3552>, <12, 60, 0>),
					NewLocPair(<2364, 5634, -3967>, <20, 171, 0>),
					NewLocPair(<2911, 9488, -3863>, <11, 50, 0>),
					NewLocPair(<5258, 12129, -4024>, <8, 16, 0>),
					NewLocPair(<5316, 3324, -3848>, <10, 125, 0>),
					NewLocPair(<5897, 10028, -4015>, <10, 60, 0>),
					NewLocPair(<6756, 4952, -3448>, <8, 7, 0>),
					NewLocPair(<7299, 7471, -4222>, <0, -90, 0>),
					NewLocPair(<7307, 6964, -4503>, <2, 88, 0>),
					NewLocPair(<7372, 3885, -4219>, <0, 55, 0>)
					NewLocPair(<7825, 3225, -4239>, <0, 6, 0>),
					NewLocPair(<7965, 5976, -4266>, <0, -135, 0>),
					NewLocPair(<8105, 6156, -4300>, <0, -45, 0>),
					NewLocPair(<8186, 5513, -3828>, <0, 0, 0>),
					NewLocPair(<8277, 6304, -3940>, <0, 0, 0>),
					NewLocPair(<9012, 5386, -4242>, <0, 90, 0>),
					NewLocPair(<9043, 5866, -4171>, <0, 90, 0>),
					NewLocPair(<9420, 5528, -4236>, <0, 90, 0>),
					NewLocPair(<9800, 5347, -3507>, <0, 134, 0>),
					NewLocPair(<9862, 5561, -3832>, <0, 180, 0>),
					NewLocPair(<9976, 8539, -4207>, <0, -90, 0>),
					NewLocPair(<10058, 2071, -3827>, <0, -90, 0>),
					NewLocPair(<10107, 3843, -4000>, <0, 90, 0>),
					NewLocPair(<10176, 4245, -4300>, <0, 100, 0>),
					NewLocPair(<11181, 5862, -3900>, <0, -180, 0>),
					NewLocPair(<11210, 4164, -4235>, <0, 90, 0>),
					NewLocPair(<11700, 6207, -4435>, <-10, 90, 0>)
				],
				<0, 0, 3000>
			)
		)
		}
			
		Shared_RegisterLocation(
                NewLocationSettings(
                    "Lava Fissure",
                    [
                        NewLocPair(<-26550, 13746, -3048>, <0, -134, 0>),
						NewLocPair(<-28877, 12943, -3109>, <0, -88.70, 0>),
                        NewLocPair(<-29881, 9168, -2905>, <-1.87, -2.11, 0>),
						NewLocPair(<-27590, 9279, -3109>, <0, 90, 0>)
                    ],
                    <0, 0, 2500>
                )
            )
			
		Shared_RegisterLocation(
                NewLocationSettings(
                    "Space Elevator",
                    [
                        NewLocPair(<-12286, 26037, -4012>, <0, -116, 0>),
                        NewLocPair(<-12318, 28447, -3975>, <0, -122, 0>),
                        NewLocPair(<-14373, 27785, -3961>, <0, -25, 0>),
						NewLocPair(<-13858, 27985, -1958>, <0, -46, 0>),
						NewLocPair(<-11638, 26123, -3983>, <0, 137, 0>)
                    ],
                    <0, 0, 2000>
                )
            )
			
		Shared_RegisterLocation(
                NewLocationSettings(
                    "Little Town",
                    [
                        NewLocPair(<22857, 3449, -4050>, <0, -157, 0>),
                        NewLocPair(<19559, 232, -4035>, <0, 33, 0>),
                        NewLocPair(<19400, 4384, -4027>, <0, -35, 0>)
                    ],
                    <0, 0, 2000>
                )
            )

		Shared_RegisterLocation(
                NewLocationSettings(
                    "TTV Building 2",
                    [
                        NewLocPair(<1313, 4450, -2990>, <0, 50, 0>),
                        NewLocPair(<2300, 6571, -4490>, <0, -96, 0>),
						NewLocPair(<2617, 4668, -4250>, <0, 85, 0>),
                        NewLocPair(<1200, 4471, -4150>, <0, 50, 0>)
                    ],
                    <0, 0, 2000>
                )
            )

		Shared_RegisterLocation(
                NewLocationSettings(
                    "Little Town 2",
                    [
                        NewLocPair(<-27219, -24393, -4497>, <0, 87, 0>),
                        NewLocPair(<-26483, -28042, -4209>, <0, 122, 0>),
                        NewLocPair(<-25174, -26091, -4550>, <0, 177, 0>),
						NewLocPair(<-29512, -25863, -4462>, <0, 3, 0>),
						NewLocPair(<-28380, -28984, -4102>, <0, 54, 0>)
                    ],
                    <0, 0, 2000>
                )
            )

	    Shared_RegisterLocation(
                NewLocationSettings(
                    "Dome",
                    [
                        NewLocPair(<19351, -41456, -2192>, <0, 96, 0>),
                        NewLocPair(<22925, -37060, -2169>, <0, -156, 0>),
                        NewLocPair(<19772, -34549, -2232>, <0, -137, 0>),
						NewLocPair(<17010, -37125, -2129>, <0, 81, 0>),
						NewLocPair(<15223, -40222, -1998>, <0, 86, 0>)
                    ],
                    <0, 0, 2000>
                )
            )

		Shared_RegisterLocation(
                NewLocationSettings(
                    "Overlook",
                    [
                        NewLocPair(<32774, 6031, -3239>, <0, 117, 0>),
                        NewLocPair(<28381, 8963, -3224>, <0, 48, 0>),
                        NewLocPair(<26327, 11857, -2477>, <0, -43, 0>),
						NewLocPair(<27303, 14528, -3047>, <0, -42, 0>)
                    ],
                    <0, 0, 2000>
                )
            )

		Shared_RegisterLocation(
                NewLocationSettings(
                    "Refinery",
                    [
                        NewLocPair(<22970, 27159, -4612>, <0, 135, 0>),
                        NewLocPair(<20430, 26481, -4200>, <0, 135, 0>),
                        NewLocPair(<19142, 30982, -4612>, <0, -45, 0>),
                        NewLocPair(<18285, 28602, -4200>, <0, -45, 0>),
                        NewLocPair(<19228, 25592, -4821>, <0, 135, 0>),
                        NewLocPair(<19495, 29283, -4821>, <0, -45, 0>),
                        NewLocPair(<18470, 28330, -4370>, <0, 135, 0>),
                        NewLocPair(<18461, 28405, -4199>, <0, 45, 0>),
                        NewLocPair(<18284, 28492, -3992>, <0, -45, 0>),
                        NewLocPair(<19428, 27190, -4140>, <0, -45, 0>),
                        NewLocPair(<20435, 26254, -4139>, <0, -175, 0>),
                        NewLocPair(<20222, 26549, -4316>, <0, 135, 0>),
                        NewLocPair(<19444, 25605, -4602>, <0, 45, 0>),
                        NewLocPair(<21751, 29980, -4226>, <0, -135, 0>),
                        NewLocPair(<17570, 26915, -4637>, <0, -90, 0>),
                        NewLocPair(<16382, 28296, -4588>, <0, -45, 0>),
                        NewLocPair(<16618, 28848, -4451>, <0, 40, 0>)
                    ],
                    <0, 0, 6500>
                )
            )
			
        Shared_RegisterLocation(
                NewLocationSettings(
                    "Factory",
                    [
                        NewLocPair(<9213, -22942, -3571>, <0, -120, 0>),
                        NewLocPair(<7825, -24577, -3547>, <0, -165, 0>),
                        NewLocPair(<5846, -25513, -3523>, <0, 180, 0>),
                        NewLocPair(<4422, -25937, -3571>, <0, 90, 0>),
                        NewLocPair(<4056, -25017, -3571>, <0, -170, 0>),
                        NewLocPair(<2050, -25267, -3650>, <-5, 45, 0>),
                        NewLocPair(<2068, -25171, -3318>, <15, 45, 0>),
                        NewLocPair(<2197, -22687, -3572>, <-3, -90, 0>),
                        NewLocPair(<7081, -23051, -3667>, <0, 45, 0>),
                        NewLocPair(<8922, -22135, -3119>, <0, 180, 0>),
                        NewLocPair(<5436, -22436, -3188>, <0, 90, 0>),
                        NewLocPair(<4254, -23031, -3522>, <0, 45, 0>),
                        NewLocPair(<8211, -21413, -3700>, <0, -140, 0>),
                        NewLocPair(<4277, -24101, -3571>, <0, -60, 0>),
						NewLocPair(<8660.39453, -13133.9375, -3580.73633>, <0, -97.4808044, 0>),
						NewLocPair(<11329.2891, -13115.9834, -3622.38745>, <0, -71.2786713, 0>),
						NewLocPair(<13883.2432, -14648.5352, -3576.56958>, <0, -128.430359, 0>),
						NewLocPair(<12295.1377, -17865.8203, -3596.34741>, <0, 14.371604, 0>),
						NewLocPair(<14512.1699, -18212.9648, -3594.43066>, <0, -105.340668, 0>),
						NewLocPair(<6397.604, -16609.4238, -3582.43506>, <0, 2.21608353, 0>),
						NewLocPair(<6497.25586, -20472.2969, -2751.29224>, <0, 75.2278214, 0>),
						NewLocPair(<8201.38867, -20132.3125, -3662.59399>, <0, 143.648376, 0>),
						NewLocPair(<11440.123, -18491.1289, -3561.79004>, <0, -164.187637, 0>),
						NewLocPair(<12813.6133, -22558.4629, -3610.26221>, <0, 99.4675751, 0>),
						NewLocPair(<9001.81348, -21488.0703, -3099.1582>, <0, 158.801071, 0>),
						NewLocPair(<10363.5137, -23754.041, -3624.48706>, <0, 122.611496, 0>),
						NewLocPair(<10700.7656, -16818.541, -2753.85913>, <0, -110.592018, 0>)
                    ],
                    <0, 0, 3000>
                )
            )

        Shared_RegisterLocation(
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
                    <0, 0, 3000>
                )
            )
			
        Shared_RegisterLocation(
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
                        NewLocPair(<-17113, -19622, -4269>, <10, -170, 0>),
                        NewLocPair(<-20092, -17684, -4252>, <0, -90, 0>),
                        NewLocPair(<-23069, -20567, -4214>, <-11, 146, 0>),
                        NewLocPair(<-20109, -20675, -4252>, <0, -90, 0>)
                    ],
                    <0, 0, 11000>
                )
            )
			
		Shared_RegisterLocation(
                NewLocationSettings(
                    "Epicenter",
                    [
                        NewLocPair(<8712, 23164, -3944>, <0, -49, 0>),
                        NewLocPair(<14000, 21690, -3969>, <0, -130, 0>),
                        NewLocPair(<10377, 17994, -4236>, <0, -120, 0>),
						NewLocPair(<13100, 18138, -4856>, <0, 120, 0>)

                    ],
                    <0, 0, 2000>
                )
            )
					
		if(FlowState_EnableSkillTrainerByColombia()){
		Shared_RegisterLocation(
                NewLocationSettings(
                   "Skill trainer By Colombia",
                    [
                       NewLocPair(<15008, 30040, -680>, <20, 50, 0>),
                       NewLocPair(<19265, 30022, -680>, <11, 132, 0>),
                       NewLocPair(<19267, 33522, -680>, <10, -138, 0>),
                       NewLocPair(<14995, 33566, -680>, <16, -45, 0>)
                    ],
                   <0, 0, 3000>
                )
            )
		}
		
		if(FlowState_EnableCaveByBlessedSeal() ){
			Shared_RegisterLocation(
                NewLocationSettings(
                    "Cave By BlessedSeal",
                    [
						NewLocPair(<-8742, -11843, -3185>, <0, 40, 0>),
                        NewLocPair(<-1897, -9707, -3841>, <0, 40, 0>),
                        NewLocPair(<-5005, -11170, -213>, <0, -40, 0>),
                        NewLocPair(<-1086, -9685, -3790>, <5, -120, 0>)
                    ],
                    <0, 0, 2000>
                )
            )
		}
		
		if(FlowState_EnableBrightWaterByZero()){
		Shared_RegisterLocation(
			NewLocationSettings(
				"Brightwater By Zer0bytes",
				[
					// SIde A
					NewLocPair(<-34368,35904,-3776>, <0,0,0>),
					NewLocPair(<-34496,35648,-3776>, <0,0,0>),
					NewLocPair(<-35392,35136,-3776>, <0,90,0>),
					NewLocPair(<-35456,35776,-3712>, <0,0,0>),
					NewLocPair(<-35456,36160,-3712>, <0,0,0>),
					NewLocPair(<-33088,37888,-3776>, <0,0,0>),
					NewLocPair(<-32960,37440,-3776>, <0,0,0>),
					NewLocPair(<-32576,35136,-3648>, <0,0,0>),
					NewLocPair(<-32576,34880,-3648>, <0,0,0>),
					NewLocPair(<-31488,34432,-3648>, <0,90,0>),
					NewLocPair(<-31296,34496,-3712>, <0,0,0>),
					NewLocPair(<-31232,34496,-3648>, <0,0,0>),
					NewLocPair(<-30976,34432,-3648>, <0,0,0>),
					NewLocPair(<-31232,35200,-3648>, <0,0,0>),
					NewLocPair(<-31424,35776,-3648>, <0,0,0>),
					NewLocPair(<-32384,37056,-3776>, <0,0,0>),
					NewLocPair(<-32000,36672,-3776>, <0,0,0>),
					NewLocPair(<-31680,38016,-3776>, <0,0,0>),
					NewLocPair(<-31104,37824,-3776>, <0,0,0>),
					NewLocPair(<-31680,39296,-3648>, <0,0,0>),
					NewLocPair(<-31680,39616,-3648>, <0,0,0>)

				   //Side A
				   NewLocPair(<-24640,40000,-3648>, <0,180,0>),
				   NewLocPair(<-24640,39744,-3648>, <0,180,0>),
				   NewLocPair(<-24941,39665,-3470>, <0,180,0>),
				   NewLocPair(<-23936,37888,-3712>, <0,180,0>),
				   NewLocPair(<-25088,37376,-3712>, <0,180,0>),
				   NewLocPair(<-25600,40832,-3712>, <0,180,0>),
				   NewLocPair(<-26752,39296,-3712>, <0,180,0>),
				   NewLocPair(<-26880,37248,-3584>, <0,180,0>),
				   NewLocPair(<-26880,37888,-3584>, <0,180,0>),
				   NewLocPair(<-26880,38528,-3584>, <0,180,0>),
				   NewLocPair(<-26368,35968,-3712>, <0,180,0>),
				   NewLocPair(<-26496,35584,-3712>, <0,180,0>),
				   NewLocPair(<-26368,36224,-3712>, <0,180,0>),
				   NewLocPair(<-26752,35968,-3200>, <0,180,0>),
				   NewLocPair(<-25728,40448,-3712>, <0,180,0>),
				   NewLocPair(<-26496,40704,-3712>, <0,-90,0>),
				   NewLocPair(<-27520,39808,-3840>, <0,180,0>),
				   NewLocPair(<-24832,36480,-3712>, <0,180,0>),
				   NewLocPair(<-23808,37504,-3712>, <0,180,0>),
				   NewLocPair(<-23680,36992,-3584>, <0,180,0>),
				   NewLocPair(<-25344,40704,-3584>, <0,180,0>),
				   NewLocPair(<-25344,41344,-3584>, <0,180,0>),

				   //others
				   NewLocPair(<-27136,41920,1036>, <0,180,0>),
				   NewLocPair(<-29364,42940,1040>, <0,180,0>),
				   NewLocPair(<-31304,42044,1036>, <0,0,0>),
				   NewLocPair(<-33520,42044,1204>, <0,0,0>),
				   NewLocPair(<-33800,41756,1252>, <0,0,0>),
				   NewLocPair(<-29268,41712,1084>, <0,0,0>),
				   NewLocPair(<-25776,42168,1216>, <0,180,0>),
				   NewLocPair(<-25724,41724,1204>, <0,180,0>),
				   NewLocPair(<-28196,38564,-676>, <0,-90,0>),
				   NewLocPair(<-26324,40476,-2756>, <0,180,0>),
				   NewLocPair(<-31000,39452,-2752>, <0,0,0>), 
				   NewLocPair(<-27192,35676,-3284>, <0,90,0>),
				   NewLocPair(<-28108,35740,-3284>, <0,180,0>),
				   NewLocPair(<-27376,35880,-2732>, <0,90,0>),
				   NewLocPair(<-27204,35764,-3628>, <0,90,0>),
				   NewLocPair(<-27908,36328,-3644>, <0,-90,0>),
				   NewLocPair(<-28332,37500,-3676>, <0,0,0>), 
				   NewLocPair(<-27828,37996,-3676>, <0,180,0>),
				   NewLocPair(<-27960,37448,-3400>, <0,90,0>),
				   NewLocPair(<-28396,38072,-3344>, <0,0,0>), 
				   NewLocPair(<-27976,37960,2608>, <0,180,0>),
				   NewLocPair(<-29348,39856,2668>, <0,-90,0>),
				   NewLocPair(<-28936,39308,1916>, <0,0,0>),
				   NewLocPair(<-27420,38688,2112>, <0,0,0>),
				   NewLocPair(<-23648,35384,-3564>, <0,180,0>),
				   NewLocPair(<-23972,35136,-3748>, <0,90,0>),
				   NewLocPair(<-26220,35644,-3692>, <0,90,0>),
				   NewLocPair(<-26320,36392,-3748>, <0,90,0>),
				],
				<0, 0, 7450>
			)
		)}
		///////////////////////////////////
		//PROPHUNT LOCATIONS///////////////			
		RegisterLocationPROPHUNT(
                NewLocationSettings(
                    "TTV Building",
                    [
                        NewLocPair(<8779, 5154, -4092>, <0, 90, 0>),
                        NewLocPair(<9351,6319,-4095>, <0, -120, 0>),
                        NewLocPair(<10462,6128,-4163>, <0, -45, 0>),
                        NewLocPair(<9635,4868,-4073>, <0, -135, 0>)
                    ],
                    <0, 0, 3000>
                )
            )
		RegisterLocationPROPHUNT(
                NewLocationSettings(
                    "Skill trainer By Colombia",
                    [
                        NewLocPair(<15008, 30040, -680>, <20, 50, 0>),
                        NewLocPair(<19265, 30022, -680>, <11, 132, 0>),
                        NewLocPair(<19267, 33522, -680>, <10, -138, 0>),
                        NewLocPair(<14995, 33566, -680>, <16, -45, 0>)
                    ],
                    <0, 0, 3000>
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
                    <0, 0, 2000>
                )
            )
		Shared_RegisterLocation(
                NewLocationSettings(
                    "Overlook",
                    [
                        NewLocPair(<32774, 6031, -3239>, <0, 117, 0>),
                        NewLocPair(<28381, 8963, -3224>, <0, 48, 0>),
                        NewLocPair(<26327, 11857, -2477>, <0, -43, 0>),
						NewLocPair(<27303, 14528, -3047>, <0, -42, 0>)
                    ],
                    <0, 0, 2000>
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
                    <0, 0, 2000>
                )
            )

	  // RegisterLocationPROPHUNT(
			// NewLocationSettings(
				// "Thermal Station",
				// [
					// NewLocPair(<-20091, -17683, -3984>, <0, -90, 0>),
					// NewLocPair(<-22919, -20528, -4010>, <0, 0, 0>),
					// NewLocPair(<-17140, -20710, -3973>, <0, -180, 0>),
					// NewLocPair(<-21054, -23399, -3850>, <0, 90, 0>)
				// ],
				// <0, 0, 11000>
			// )
		// )

	///////////////////////////////////
	//END PROPHUNT LOCATIONS///////////////	
	
	///////////////////////////////////////////////////
	//EXCLUSIVE SURF LOCATIONS FOR WORLD'S EDGE////////	
	
		RegisterLocationSURF(
                NewLocationSettings(
                    "surf_purgatory",
                    [
                        NewLocPair(<3225,9084,21476>, <0, -90, 0>)
                    ],
                    <0, 0, 3000>
                )
            )

         RegisterLocationSURF(
                NewLocationSettings(
                    "surf_noname",
                    [
                        NewLocPair(<7799, 11833, 24585>, <0, 180, 0>)
                    ],
                    <0, 0, 3000>
                )
            )
         RegisterLocationSURF(
                NewLocationSettings(
                    "surf_kitsune",
                    [
                        NewLocPair(<14724, 25241, 17271>, <0, 180, 0>)
                    ],
                    <0, 0, 3000>
                )
            )
        default:
            Assert(false, "No TDM locations found for map!")
    }

    //Client Signals
    RegisterSignal( "CloseScoreRUI" )
}

LocPair function NewLocPair(vector origin, vector angles)
{
    LocPair locPair
    locPair.origin = origin
    locPair.angles = angles

    return locPair
}

LocationSettings function NewLocationSettings(string name, array<LocPair> spawns, vector cinematicCameraOffset)
{
    LocationSettings locationSettings
    locationSettings.name = name
    locationSettings.spawns = spawns
    locationSettings.cinematicCameraOffset = cinematicCameraOffset

    return locationSettings
}

void function Shared_RegisterLocation(LocationSettings locationSettings)
{
    #if SERVER
    _RegisterLocation(locationSettings)
    #endif


    #if CLIENT
    Cl_RegisterLocation(locationSettings)
    #endif
}

void function RegisterLocationPROPHUNT(LocationSettings locationSettings)
{
    #if SERVER
    _RegisterLocationPROPHUNT(locationSettings)
    #endif

}

void function RegisterLocationSURF(LocationSettings locationSettings)
{
    #if SERVER
    _RegisterLocationSURF(locationSettings)
    #endif

}
// Playlist GET

float function Deathmatch_GetIntroCutsceneNumSpawns()                { return GetCurrentPlaylistVarFloat("intro_cutscene_num_spawns", 0)}
float function Deathmatch_GetIntroCutsceneSpawnDuration()            { return GetCurrentPlaylistVarFloat("intro_cutscene_spawn_duration", 5)}
float function Deathmatch_GetIntroSpawnSpeed()                       { return GetCurrentPlaylistVarFloat("intro_cutscene_spawn_speed", 40)}
bool function Spectator_GetReplayIsEnabled()                         { return GetCurrentPlaylistVarBool("replay_enabled", true ) } 
float function Spectator_GetReplayDelay()                            { return GetCurrentPlaylistVarFloat("replay_delay", 5 ) } 
float function Deathmatch_GetRespawnDelay()                          { return GetCurrentPlaylistVarFloat("respawn_delay", 5) }
float function Equipment_GetDefaultShieldHP()                        { return GetCurrentPlaylistVarFloat("default_shield_hp", 100) }
float function Deathmatch_GetOOBDamagePercent()                      { return GetCurrentPlaylistVarFloat("oob_damage_percent", 10) }
float function Deathmatch_GetVotingTime()                            { return GetCurrentPlaylistVarFloat("voting_time", 5) }

string function FlowState_Hoster() { return GetCurrentPlaylistVarString("flowstateHoster", "ColombiaFPS") }
string function FlowState_Admin1() { return GetCurrentPlaylistVarString("flowstateAdmin1", "ColombiaFPS") }
string function FlowState_Admin2() { return GetCurrentPlaylistVarString("flowstateAdmin2", "ColombiaFPS") }
string function FlowState_Admin3() { return GetCurrentPlaylistVarString("flowstateAdmin3", "ColombiaFPS") }
string function FlowState_Admin4() { return GetCurrentPlaylistVarString("flowstateAdmin4", "ColombiaFPS") }
int function FlowState_RoundTime() { return GetCurrentPlaylistVarInt("flowstateRoundtime", 1800) }
string function FlowState_RingColor() { return GetCurrentPlaylistVarString("flowstateBubble", "120, 26, 56") }
string function FlowState_BubbleColor() { return GetCurrentPlaylistVarString("flowstateBubble", "120, 26, 56") }
bool function FlowState_ResetKillsEachRound()                         { return GetCurrentPlaylistVarBool("flowstateResetKills", true ) } 
bool function FlowState_Timer()                         { return GetCurrentPlaylistVarBool("flowstateTimer", true ) } 
bool function FlowState_LockPOI()                         { return GetCurrentPlaylistVarBool("flowstateLockPOI", false ) } 
int function FlowState_LockedPOI() { return GetCurrentPlaylistVarInt("flowstateLockeedPOI", 0) }
bool function FlowState_AdminTgive()                         { return GetCurrentPlaylistVarBool("flowstateAdminTgive", true ) }
bool function FlowState_ForceCharacter()                         { return GetCurrentPlaylistVarBool("flowstateForceCharacter", true ) } 
int function FlowState_ChosenCharacter() { return GetCurrentPlaylistVarInt("flowstateChosenCharacter", 8) }
bool function FlowState_ForceAdminCharacter()                         { return GetCurrentPlaylistVarBool("flowstateForceAdminCharacter", true ) } 
int function FlowState_ChosenAdminCharacter() { return GetCurrentPlaylistVarInt("flowstateChosenAdminCharacter", 8) }
bool function FlowState_DummyOverride()                         { return GetCurrentPlaylistVarBool("flowstateDummyOverride", false ) } 
bool function FlowState_AutoreloadOnKillPrimary()                         { return GetCurrentPlaylistVarBool("flowstateAutoreloadPrimary", true ) } 
bool function FlowState_AutoreloadOnKillSecondary()                         { return GetCurrentPlaylistVarBool("flowstateAutoreloadSecondary", true ) } 
bool function FlowState_RandomGuns()                         { return GetCurrentPlaylistVarBool("flowstateRandomGuns", false ) } 
bool function FlowState_RandomTactical()                         { return GetCurrentPlaylistVarBool("flowstateRandomTactical", false ) } 
bool function FlowState_RandomUltimate()                         { return GetCurrentPlaylistVarBool("flowstateRandomUltimate", false ) }
bool function FlowState_RandomGunsEverydie() { return GetCurrentPlaylistVarBool("flowstateFiesta", false ) }
bool function FlowState_FIESTAShieldsStreak() { return GetCurrentPlaylistVarBool("flowstateFiestaShieldsUpgrade", true ) } 
bool function FlowState_FIESTADeathboxes() { return GetCurrentPlaylistVarBool("flowstateFiestaDeathboxes", true ) } 
bool function FlowState_RandomGunsMetagame()                         { return GetCurrentPlaylistVarBool("flowstateRandomGunsMetagame", false ) }
bool function FlowState_KillshotEnabled()                         { return GetCurrentPlaylistVarBool("flowstateKillshotEnabled", true ) }
bool function FlowState_Droppods()                         { return GetCurrentPlaylistVarBool("flowstateDroppodsOnPlayerConnected", false ) }
bool function FlowState_ExtrashieldsEnabled()                         { return GetCurrentPlaylistVarBool("flowstateExtrashieldsEnabled", true ) }
float function FlowState_ExtrashieldsSpawntime()                         { return GetCurrentPlaylistVarFloat("flowstateExtrashieldsSpawntime", 240 ) }
float function FlowState_ExtrashieldValue()                         { return GetCurrentPlaylistVarFloat("flowstateExtrashieldValue", 150 ) }
bool function FlowState_Gungame()                         { return GetCurrentPlaylistVarBool("flowstateGungame", false ) }
bool function FlowState_GungameRandomAbilities()                         { return GetCurrentPlaylistVarBool("flowstateGUNGAMERandomAbilities", false ) }
bool function FlowState_SURF()                         { return GetCurrentPlaylistVarBool("flowstateSurf", false ) }
int function FlowState_SURFRoundTime() { return GetCurrentPlaylistVarInt("flowstateSURFRoundtime", 800) }
bool function FlowState_SURFLockPOI()                         { return GetCurrentPlaylistVarBool("flowstateSURFLockPOI", false ) } 
int function FlowState_SURFLockedPOI() { return GetCurrentPlaylistVarInt("flowstateSURFLockeedPOI", 0) }
bool function FlowState_PROPHUNT()                         { return GetCurrentPlaylistVarBool("flowstatePROPHUNT", false ) }
bool function Flowstate_EnableAutoChangeLevel() { return GetCurrentPlaylistVarBool("flowstateAutoChangeLevelEnable", false ) }
int function Flowstate_AutoChangeLevelRounds() { return GetCurrentPlaylistVarInt("flowstateRoundsBeforeChangeLevel", 2 ) }
bool function FlowState_EnableSkillTrainerByColombia()                         { return GetCurrentPlaylistVarBool("flowstate_Enable_SKILLTRAINER_By_Colombia", true ) }
bool function FlowState_EnableCustomMapByBiscutz()                         { return GetCurrentPlaylistVarBool("flowstate_Enable_CUSTOMMAP_By_Biscutz", false ) }
bool function FlowState_EnableWhiteForestByZero()                         { return GetCurrentPlaylistVarBool("flowstate_Enable_WHITEFOREST_By_Zero", true ) }
bool function FlowState_EnableBrightWaterByZero()                         { return GetCurrentPlaylistVarBool("flowstate_Enable_BRIGHWATER_By_Zero", false ) }
bool function FlowState_EnableCaveByBlessedSeal()                         { return GetCurrentPlaylistVarBool("flowstate_Enable_CAVE_By_BlessedSeal", false ) }
bool function Flowstate_DoorsEnabled()                         { return GetCurrentPlaylistVarBool("flowstateDoorsEnabled", true ) }
int function FlowState_MaxPingAllowed() { return GetCurrentPlaylistVarInt("flowstateMaxPingAllowed", 200) }
bool function FlowState_KickHighPingPlayer()                         { return GetCurrentPlaylistVarBool("flowstateKickHighPingPlayer", true ) }

#if SERVER   


bool function Equipment_GetRespawnKitEnabled()                       { return GetCurrentPlaylistVarBool("respawn_kit_enabled", false) }

StoredWeapon function Equipment_GetRespawnKit_PrimaryWeapon()
{
    return Equipment_GetRespawnKit_Weapon(
        GetCurrentPlaylistVarString("respawn_kit_primary_weapon", "~~none~~"),
        eStoredWeaponType.main,
        WEAPON_INVENTORY_SLOT_PRIMARY_0
    )
}
StoredWeapon function Equipment_GetRespawnKit_SecondaryWeapon()
{
    return Equipment_GetRespawnKit_Weapon(
        GetCurrentPlaylistVarString("respawn_kit_secondary_weapon", "~~none~~"),
        eStoredWeaponType.main,
        WEAPON_INVENTORY_SLOT_PRIMARY_1
    )
}
StoredWeapon function Equipment_GetRespawnKit_Tactical()
{
    return Equipment_GetRespawnKit_Weapon(
        GetCurrentPlaylistVarString("respawn_kit_tactical", "~~none~~"),
        eStoredWeaponType.offhand,
        OFFHAND_TACTICAL
    )
}
StoredWeapon function Equipment_GetRespawnKit_Ultimate()
{
    return Equipment_GetRespawnKit_Weapon(
        GetCurrentPlaylistVarString("respawn_kit_ultimate", "~~none~~"),
        eStoredWeaponType.offhand,
        OFFHAND_ULTIMATE
    )
}

StoredWeapon function Equipment_GetRespawnKit_Weapon(string input, int type, int index)
{
    StoredWeapon weapon
    if(input == "~~none~~") return weapon

    array<string> args = split(input, " ")

    if(args.len() == 0) return weapon

    weapon.name = args[0]
    weapon.weaponType = type
    weapon.inventoryIndex = index
    weapon.mods = args.slice(1, args.len())

    return weapon
}

#endif
