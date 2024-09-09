untyped
globalize_all_functions

// Code by: loy_ (Discord). 
// Map by: loy_ (Discord).

void function Gymmovementmap_precache() {
    PrecacheModel( $"mdl/Weapons/octane_epipen/w_octane_epipen.rmdl" )
    PrecacheModel( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl" )
    PrecacheModel( $"mdl/fx/core_energy.rmdl" )
    PrecacheModel( $"mdl/beacon/construction_scaff_post_128_01.rmdl" )
    PrecacheModel( $"mdl/thunderdome/thunderdome_cage_ceiling_256x64_05.rmdl" )
    PrecacheModel( $"mdl/desertlands/industrial_cargo_container_320_01_open.rmdl" )
    PrecacheModel( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl" )
    PrecacheModel( $"mdl/slum_city/slumcity_girdering_32x16_dirty_d.rmdl" )
    PrecacheModel( $"mdl/desertlands/construction_bldg_column_01.rmdl" )
    PrecacheModel( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl" )
    PrecacheModel( $"mdl/mendoko/mendoko_rubber_floor_01.rmdl" )
    PrecacheModel( $"mdl/ola/sewer_staircase_01.rmdl" )
    PrecacheModel( $"mdl/desertlands/construction_bldg_platform_01.rmdl" )
    PrecacheModel( $"mdl/desertlands/fence_large_concrete_metal_dirty_128_01.rmdl" )
    PrecacheModel( $"mdl/desertlands/construction_bldg_column_stack_01.rmdl" )
    PrecacheModel( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl" )
    PrecacheModel( $"mdl/pipes/pipe_modular_painted_grey_128.rmdl" )
    PrecacheModel( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl" )
    PrecacheModel( $"mdl/pipes/pipe_modular_painted_grey_32_tjunk.rmdl" )
    PrecacheModel( $"mdl/beacon/beacon_fence_sign_01.rmdl" )
    PrecacheModel( $"mdl/pipes/pipe_modular_painted_grey_256.rmdl" )
    PrecacheModel( $"mdl/desertlands/research_station_stairs_bend_01.rmdl" )
    PrecacheModel( $"mdl/utilities/wall_Waterpipe.rmdl" )
    PrecacheModel( $"mdl/industrial/zipline_arm.rmdl" )
    PrecacheModel( $"mdl/industrial/security_fence_post.rmdl" )
    PrecacheModel( $"mdl/desertlands/icelandic_moss_mod_01.rmdl" )
    PrecacheModel( $"mdl/pipes/pipe_modular_painted_grey_32_valve.rmdl" )
    PrecacheModel( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl" )
    PrecacheModel( $"mdl/ola/sewer_railing_01_stairend.rmdl" )
    PrecacheModel( $"mdl/beacon/modular_hose_yellow_32_01.rmdl" )
    PrecacheModel( $"mdl/beacon/modular_hose_yellow_corner_01.rmdl" )
    PrecacheModel( $"mdl/props/zipline_balloon/zipline_balloon.rmdl" )
    PrecacheModel( $"mdl/slum_city/slumcity_girdering_128x16_dirty_d.rmdl" )
    PrecacheModel( $"mdl/desertlands/construction_bldg_platform_02.rmdl" )
    PrecacheModel( $"mdl/barriers/concrete/concrete_barrier_01.rmdl" )
    PrecacheModel( $"mdl/pipes/pipe_modular_painted_grey_corner.rmdl" )
    PrecacheModel( $"mdl/beacon/modular_hose_yellow_128_02.rmdl" )
    PrecacheModel( $"mdl/beacon/modular_hose_yellow_128_01.rmdl" )
    PrecacheModel( $"mdl/desertlands/construction_bldg_platform_04_corner.rmdl" )
    PrecacheModel( $"mdl/playback/playback_bridge_panel_128x064_01.rmdl" )
    PrecacheModel( $"mdl/thunderdome/thunderdome_cage_wall_128x352_03.rmdl" )
    PrecacheModel( $"mdl/desertlands/desertlands_cafeteria_table_01.rmdl" )
    PrecacheModel( $"mdl/desertlands/highrise_rectangle_top_01.rmdl" )
    PrecacheModel( $"mdl/utilities/halogen_lightbulbs.rmdl" )
    PrecacheModel( $"mdl/timeshift/timeshift_bench_01.rmdl" )
    PrecacheModel( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape.rmdl" )
    PrecacheModel( $"mdl/pipes/pipe_modular_painted_grey_64.rmdl" )
    PrecacheModel( $"mdl/ola/sewer_railing_01_corner_in.rmdl" )
    PrecacheModel( $"mdl/pipes/slum_pipe_large_yellow_256_02.rmdl" )
    PrecacheModel( $"mdl/desertlands/city_steps_metal_grate_double_128_01.rmdl" )
    PrecacheModel( $"mdl/lamps/light_parking_post.rmdl" )
    PrecacheModel( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_pillar_64.rmdl" )
    PrecacheModel( $"mdl/desertlands/construction_bldg_elevator_01_top.rmdl" )
    PrecacheModel( $"mdl/industrial/exit_sign_03.rmdl" )
    PrecacheModel( $"mdl/desertlands/railing_metal_dirty_64_panel_01.rmdl" )
    PrecacheModel( $"mdl/barriers/concrete/concrete_barrier_fence.rmdl" )
    PrecacheModel( $"mdl/containers/slumcity_oxygen_bag_large_01_b.rmdl" )
    PrecacheModel( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl" )
    PrecacheModel( $"mdl/thunderdome/thunderdome_cage_wall_256x128_02.rmdl" )
    PrecacheModel( $"mdl/slum_city/slumcity_girdering_256x16_dirty_d.rmdl" )
    PrecacheModel( $"mdl/ola/sewer_staircase_96_double.rmdl" )
}

struct {
    vector first_cp = < 11500.01, -3531.309, 15243.27 >
    table<entity, vector> cp_table = {}
    table<entity, vector> cp_angle = {}
    table<entity, bool> last_cp = {}
}
file

void function Gymmovementmap_init() {
    AddCallback_OnClientConnected( Gymmovementmap_player_setup )
    AddCallback_EntitiesDidLoad( GymMovementMapEntitiesDidLoad )
    Gymmovementmap_precache()
}

void function GymMovementMapEntitiesDidLoad()
{
    thread Gymmovementmap_load()
}

void function Gymmovementmap_player_setup( entity player )
{
    array<ItemFlavor> characters = GetAllCharacters()

    file.cp_table[player] <- file.first_cp
    file.cp_angle[player] <- < 0, 180, 0 >
    file.last_cp[player] <- false

    player.SetOrigin(file.cp_table[player])
    player.SetAngles(file.cp_angle[player])
    CharacterSelect_AssignCharacter(ToEHI(player), characters[8]) // Wraith

    player.SetPlayerNetBool("pingEnabled", false)
    player.SetPersistentVar("gen", 0)
    Message(player, "Welcome to the Gym Movement Map!")

    TakeAllPassives( player )
    TakeAllWeapons( player )
    player.TakeOffhandWeapon(OFFHAND_ULTIMATE)
    player.GiveWeapon("mp_weapon_melee_survival", WEAPON_INVENTORY_SLOT_PRIMARY_2, [])
    player.GiveOffhandWeapon("melee_pilot_emptyhanded", OFFHAND_MELEE, [])

    if( !player.HasPassive( ePassives.PAS_PILOT_BLOOD ) )
    GivePassive(player, ePassives.PAS_PILOT_BLOOD)

    thread Gymmovementmap_SpawnInfoText( player )
}

void function Gymmovementmap_SpawnInfoText( entity player ) {
    FlagWait( "EntitiesDidLoad" )
    wait 1
    CreatePanelText(player, "Gym Map", "Made by: Loy", < 11425.01, -3531.51, 15322 >, < 0, 180, 0 >, false, 2 )
}

void function Gymmovementmap_load() {
    // Props Array
    array < entity > NoClimbArray; array < entity > InvisibleArray; array < entity > NoGrappleArray; array < entity > ClipInvisibleNoGrappleNoClimbArray; array < entity > NoCollisionArray; 

    // Props
    MapEditor_CreateProp( $"mdl/desertlands/fence_large_concrete_metal_dirty_128_01.rmdl", < 9042.719, -10672.88, 15774.35 >, < 0, 89.9999, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1461.048, -10678.16, 16841.25 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/fx/core_energy.rmdl", < 1610.718, -10766.63, 16076.51 >, < 0, -179.9998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x64_05.rmdl", < -3661.146, -9887.403, 17466.3 >, < 0, 0.0003, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01_open.rmdl", < 11656.91, -10551.1, 15412.03 >, < -0.0099, -179.9863, 35.7129 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 8656.468, -10737.38, 16011.95 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/slum_city/slumcity_girdering_32x16_dirty_d.rmdl", < 11740, -5602.378, 15323 >, < 0, -90.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 5649.093, -10678.63, 15720.35 >, < 0, -90.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < -3056.395, -10042.83, 17747.22 >, < 0, -179.9997, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/mendoko/mendoko_rubber_floor_01.rmdl", < 11552.85, -7620.783, 14448.71 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/ola/sewer_staircase_01.rmdl", < 1611.499, -10670.6, 15843.68 >, < 0, 0.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < 8278.857, -10915.38, 15117.35 >, < 90, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/fence_large_concrete_metal_dirty_128_01.rmdl", < 9101.218, -10615.38, 15774.35 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < -3056.147, -10265.15, 17747.22 >, < 0, -179.9997, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_stack_01.rmdl", < -4155.944, -9465.45, 17520.22 >, < 0, 45.0831, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < 7796.658, -10738.98, 15472.35 >, < 0, 89.9999, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_stack_01.rmdl", < -4261.94, -9359.455, 17520.22 >, < 0, 45.0831, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_128.rmdl", < -3454.823, -10555.47, 17836.57 >, < 0, 90.0003, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < -3055.896, -10489.16, 17785.22 >, < 0, -179.9997, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < 7540.093, -10738.98, 15472.35 >, < 0, 89.9999, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 9078.818, -10738.38, 15926.42 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -152.9541, -10675.6, 16425.11 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_32_tjunk.rmdl", < -3293.144, -10554.52, 17868.01 >, < 90, 0.0003, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/beacon/beacon_fence_sign_01.rmdl", < 1274.499, -10670.6, 16435.03 >, < 0, -179.9997, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_256.rmdl", < -3632.017, -10555.21, 17437.17 >, < 0, 90.0003, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/research_station_stairs_bend_01.rmdl", < 11571.3, -9269.277, 14825.44 >, < 0, -90.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < -3056.147, -10265.15, 17607.22 >, < 0, -179.9997, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/utilities/wall_Waterpipe.rmdl", < -3055.324, -9964.816, 17412.33 >, < 0, 89.9999, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/zipline_arm.rmdl", < 5807, -10728.21, 16169 >, < 0, -90.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/security_fence_post.rmdl", < 5808, -10729, 15869 >, < 0, -0.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 5817.093, -10678.63, 15720.35 >, < 0, -90.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 8407.857, -10738.88, 16140.35 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < -3338.821, -10560.32, 17747.22 >, < 0, 89.9824, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/icelandic_moss_mod_01.rmdl", < 4722, -10732, 16366.63 >, < 0, 179.9897, -179.9996 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_32_valve.rmdl", < -3055.337, -9975.349, 17406.14 >, < 0, 90.0639, 0 >, true, 50000, -1, 1 )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < -3628.001, -10555, 17511 >, < 90, 0, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/fence_large_concrete_metal_dirty_128_01.rmdl", < 9296.219, -10801.88, 15647.15 >, < 0, 89.9999, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 5817.093, -10845.38, 15720.35 >, < 0, -90.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/ola/sewer_railing_01_stairend.rmdl", < 5909.684, -10789.22, 15817.59 >, < 0, 89.9999, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/beacon/modular_hose_yellow_32_01.rmdl", < -681.5537, -10668.09, 16610.25 >, < 90, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 5649.05, -10734.13, 15859.32 >, < 0, -90.0001, -179.9659 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/beacon/modular_hose_yellow_corner_01.rmdl", < -554.499, -10667.29, 16610.41 >, < 0, 0.0018, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < 6441.093, -10738.98, 15472.35 >, < 0, 89.9999, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 9164.219, -10737.38, 15758.35 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/props/zipline_balloon/zipline_balloon.rmdl", < 11569, -9283.01, 15239.14 >, < 0, 90, 0 >, true, 50000, -1, 0.08 ) )
    MapEditor_CreateProp( $"mdl/desertlands/fence_large_concrete_metal_dirty_128_01.rmdl", < 8534.968, -10672.88, 16027.95 >, < 0, 89.9999, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/beacon/beacon_fence_sign_01.rmdl", < -1444.548, -10809.08, 16888.25 >, < -90, 0, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_128.rmdl", < -3615.466, -10555.47, 17836.57 >, < 0, 90.0003, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/slum_city/slumcity_girdering_128x16_dirty_d.rmdl", < 11707.02, -5594.51, 15198 >, < -90, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_02.rmdl", < 11760, -4758.009, 15138.31 >, < 0, -90.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -1581.403, -10675.59, 16537.21 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 11581.5, -9239.811, 14442.14 >, < 0, 179.9999, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/slum_city/slumcity_girdering_128x16_dirty_d.rmdl", < 11707.02, -5602.643, 15323 >, < 0, -90.0001, 89.9893 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/barriers/concrete/concrete_barrier_01.rmdl", < 10250.7, -10754.16, 15656.48 >, < 0, -90.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 5705.093, -10678.63, 15720.35 >, < 0, -90.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < -3450.822, -10560.32, 17607.22 >, < 0, 89.9824, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -2672.001, -10674.89, 17560.38 >, < 0, 89.9999, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 3188.093, -10731.38, 15854.65 >, < 0, -179.9898, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01_open.rmdl", < 11656.91, -10385.99, 15281.58 >, < -0.012, -179.988, 45 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < -3561.144, -10560.32, 17467.22 >, < 0, 89.9824, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_corner.rmdl", < -3255.882, -10557.99, 17566.72 >, < 90, -179.9997, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/beacon/beacon_fence_sign_01.rmdl", < 1383.499, -10766.6, 16196.35 >, < 0, -89.9999, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/beacon/modular_hose_yellow_128_02.rmdl", < -681.5537, -10704.8, 16443.91 >, < -90, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1442.591, -10678.16, 16722.25 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_stack_01.rmdl", < -4155.944, -9465.45, 17353.22 >, < 0, 45.0831, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -1948.999, -10829.08, 17616.76 >, < 0, 90.0003, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/utilities/wall_Waterpipe.rmdl", < -3640.622, -10556.82, 17412.33 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -2012.999, -10689.08, 17616.75 >, < 0, 0.0003, 0 >, true, 50000, -1, 1 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/props/zipline_balloon/zipline_balloon.rmdl", < 11584.85, -7715.683, 15155.21 >, < 0, -90.0001, 0 >, true, 50000, -1, 0.08 ) )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_32_tjunk.rmdl", < -3487.145, -10554.52, 17837.01 >, < 90, 0.0003, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_256.rmdl", < -3613.144, -10558.01, 17387.96 >, < 0, 90.0003, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 11585.12, -10028.31, 15009.6 >, < 0, 179.9999, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < 11738.5, -5330.51, 14679.81 >, < 90, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1442.591, -10678.16, 16960.44 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/ola/sewer_staircase_01.rmdl", < 1611.499, -10670.6, 16321.03 >, < 0, 0.0001, 0 >, true, 50000, -1, 1 )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -3500.001, -10563, 17703 >, < 89.972, 89.9998, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/fx/core_energy.rmdl", < 1611.718, -10766.63, 16315.81 >, < 0, -179.9998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/beacon/modular_hose_yellow_32_01.rmdl", < -816.6221, -10667.28, 16602.25 >, < 90, 0.0099, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/fence_large_concrete_metal_dirty_128_01.rmdl", < 8846.968, -10615.38, 15900.75 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 9674, -10739.05, 15631.38 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/beacon/modular_hose_yellow_32_01.rmdl", < -681.5713, -10665, 16436.71 >, < 0, -89.9835, -179.9742 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/beacon/modular_hose_yellow_128_01.rmdl", < -681.001, -10667.3, 16610.41 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 11584.81, -9772.109, 15009.6 >, < 0, 179.9999, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 5817.093, -10734.13, 15720.35 >, < 0, -90.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_04_corner.rmdl", < -27.4541, -10676.6, 16435.71 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < 720.999, -10729, 16648.15 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/beacon/beacon_fence_sign_01.rmdl", < -1444.548, -10542.08, 16888.25 >, < -90, 180, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/playback/playback_bridge_panel_128x064_01.rmdl", < 11474.55, -9405.309, 14970.75 >, < 0, 0, -10.414 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_128.rmdl", < -3055.437, -9974.682, 17692.16 >, < 0, 0.064, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < -3338.821, -10560.32, 17467.22 >, < 0, 89.9824, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1454.548, -10550.16, 16601.25 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_corner.rmdl", < -3052.752, -10553.64, 17853.04 >, < 0, 90.0639, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 1493.499, -10731.41, 15829.68 >, < 0, 90.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 2003.093, -10731.38, 15829.65 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/props/zipline_balloon/zipline_balloon.rmdl", < -1844.001, -10667.29, 18857.62 >, < 0, 180, 0 >, true, 50000, -1, 0.08 ) )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_128.rmdl", < -3052.273, -10409, 17868.3 >, < 0, 0.0639, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/beacon/modular_hose_yellow_32_01.rmdl", < -681.5713, -10633, 16436.71 >, < 0, -89.9835, -179.9742 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < -3056.395, -10042.83, 17607.22 >, < 0, -179.9997, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_stack_01.rmdl", < -4366.945, -9254.45, 17353.22 >, < 0, 45.0831, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/fence_large_concrete_metal_dirty_128_01.rmdl", < 9101.218, -10859.38, 15774.35 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_32_valve.rmdl", < -3271.241, -10558.33, 17401.06 >, < 0, -89.9997, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/mendoko/mendoko_rubber_floor_01.rmdl", < 11552.85, -8286.683, 14448.71 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < -3114.822, -10560.32, 17785.22 >, < 0, 89.9824, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/beacon/modular_hose_yellow_corner_01.rmdl", < -681.5791, -10696.87, 16436.71 >, < 0, -90.0001, -179.9742 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 8096.558, -10738.88, 15301.35 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/slum_city/slumcity_girdering_32x16_dirty_d.rmdl", < 11740, -5250.246, 15435.57 >, < 0, -90.0001, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/beacon/beacon_fence_sign_01.rmdl", < -1444.548, -10542.08, 16570.25 >, < -90, 180, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/beacon/modular_hose_yellow_32_01.rmdl", < -681.5537, -10633, 16579.6 >, < 0, -90.0166, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -1828.87, -10675.04, 17032 >, < 0, 89.9999, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_03.rmdl", < 7933.558, -10738.88, 15470.65 >, < 0, -90.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/ola/sewer_staircase_01.rmdl", < 1611.499, -10670.6, 16082.35 >, < 0, 0.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -1573.444, -10675.02, 17032.06 >, < 0, -0.0253, 0 >, true, 50000, -1, 1 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/Weapons/octane_epipen/w_octane_epipen.rmdl", < -3676.819, -9941.918, 17512.14 >, < -39.4678, -152.2212, -78.9297 >, true, 50000, -1, 5 ) )
    MapEditor_CreateProp( $"mdl/playback/playback_bridge_panel_128x064_01.rmdl", < 11474.55, -9531.195, 14993.9 >, < 0, 0, -10.414 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 5761.093, -10845.38, 15720.35 >, < 0, -90.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_cafeteria_table_01.rmdl", < 11351.01, -3493.766, 15144.71 >, < 0, -90.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/highrise_rectangle_top_01.rmdl", < 11585.01, -3359.01, 15110.41 >, < 0, -90.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 11580.85, -8983.683, 14442.21 >, < 0, 179.9999, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/utilities/halogen_lightbulbs.rmdl", < 11716.27, -5706.787, 15189.4 >, < 0, -90.0001, 0 >, true, 50000, -1, 1 )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -3188.001, -10565, 17727 >, < 89.972, 89.9998, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_256.rmdl", < -3052.692, -10553.51, 17602.22 >, < 0, 90.0003, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_128.rmdl", < -3057.815, -10353.68, 17567.09 >, < 0, 0.0639, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/mendoko/mendoko_rubber_floor_01.rmdl", < 11552.75, -8223.883, 14448.71 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/fence_large_concrete_metal_dirty_128_01.rmdl", < 8593.468, -10859.38, 16027.95 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_corner.rmdl", < -3057.835, -10335.32, 17402.35 >, < 0, 90.0639, 180 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -1326.55, -10675.59, 16657.25 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_04_corner.rmdl", < 468.5449, -11172.6, 16435.71 >, < 0, -90.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1461.048, -10550.16, 16841.25 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < -3056.021, -10377.15, 17645.22 >, < 0, -179.9997, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/beacon/modular_hose_yellow_corner_01.rmdl", < -808.5967, -10667.12, 16610.41 >, < 0, -179.9883, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < -3056.021, -10377.15, 17785.22 >, < 0, -179.9997, 0 >, true, 50000, -1, 1 )
    ClipInvisibleNoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape.rmdl", < 8266.92, -10930.04, 16461.38 >, < 0, 0, 180 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -681.6533, -10675.6, 16425.11 >, < 0, 180, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < -3114.822, -10560.32, 17645.22 >, < 0, 89.9824, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_corner.rmdl", < -3057.817, -10350.95, 17566.72 >, < 90, 90.064, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/fence_large_concrete_metal_dirty_128_01.rmdl", < 9354.719, -10615.38, 15647.15 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/mendoko/mendoko_rubber_floor_01.rmdl", < 11552.85, -7683.683, 14448.71 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 5705.093, -10845.38, 15720.35 >, < 0, -90.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_cafeteria_table_01.rmdl", < 11351.01, -3218.254, 15144.71 >, < 0, -90.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/beacon/beacon_fence_sign_01.rmdl", < 1670.671, -10766.6, 16077.03 >, < 0, 89.9998, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_corner.rmdl", < -3309.821, -10554.09, 17853.04 >, < 0, 0.0003, 0 >, true, 50000, -1, 1 )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -3068, -10203, 17703 >, < 90, 0, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < 11760, -7029.01, 14437.31 >, < 0, -90.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_32_tjunk.rmdl", < -3054.599, -10119.68, 17837.01 >, < 90, -89.936, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < 11489, -10457, 16328 >, < 0, 0, 89.9998 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_64.rmdl", < -3055.995, -10483.68, 17567.09 >, < 0, 0.0639, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/beacon/beacon_fence_sign_01.rmdl", < 1383.499, -10766.6, 15957.68 >, < 0, -89.9999, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/slum_city/slumcity_girdering_32x16_dirty_d.rmdl", < 11740, -5720.378, 15323 >, < 0, -90.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/fx/core_energy.rmdl", < 1442.718, -10766.63, 15957.72 >, < 0, 0.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/slum_city/slumcity_girdering_128x16_dirty_d.rmdl", < 11707.02, -5720.643, 15323 >, < 0, -90.0001, 89.9893 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_corner.rmdl", < -3271.509, -10557.99, 17402.35 >, < 0, -179.9997, 180 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < -3056.272, -10153.15, 17607.22 >, < 0, -179.9997, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 5817.093, -10789.88, 15720.35 >, < 0, -90.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/ola/sewer_railing_01_corner_in.rmdl", < -3723.147, -9757.997, 17479.62 >, < 0, -179.9997, 0 >, true, 50000, -1, 1 )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -3067, -10423, 17727 >, < 90, 0, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_corner.rmdl", < -3310.185, -10554.51, 17852.57 >, < 0, -179.9997, 180 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/beacon/beacon_fence_sign_01.rmdl", < -1444.548, -10809.08, 16570.25 >, < -90, 0, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < -3056.273, -10042.83, 17467.22 >, < 0, -179.9997, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/slum_city/slumcity_girdering_32x16_dirty_d.rmdl", < 11740, -5061.246, 15435.57 >, < 0, -90.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 5649.093, -10789.88, 15720.35 >, < 0, -90.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < 720.999, -10617, 16509.15 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_128.rmdl", < -3057.835, -10335.68, 17433.08 >, < 0, 0.064, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1454.548, -10678.16, 16601.25 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/slum_city/slumcity_girdering_128x16_dirty_d.rmdl", < 11707.02, -5250.51, 15435.58 >, < 0, -90.0001, 89.9893 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 5761.093, -10678.63, 15720.35 >, < 0, -90.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -1326.401, -10675.59, 16408.21 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/beacon/beacon_fence_sign_01.rmdl", < 954.999, -10671, 16435.15 >, < 0, 180, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/research_station_stairs_bend_01.rmdl", < 11571.3, -9269.277, 14580.69 >, < 0, -90.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_corner.rmdl", < -3632.099, -10555.52, 17820.3 >, < 0, 0.0003, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < -3338.821, -10560.32, 17607.22 >, < 0, 89.9824, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < 720.999, -10617, 16648.15 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < -3056.272, -10153.15, 17747.22 >, < 0, -179.9997, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/fence_large_concrete_metal_dirty_128_01.rmdl", < 8593.468, -10615.38, 16027.95 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 5649.093, -10734.13, 15720.35 >, < 0, -90.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/slum_pipe_large_yellow_256_02.rmdl", < 2478.093, -10731.38, 15793.65 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/ola/sewer_railing_01_corner_in.rmdl", < -3854.146, -9888.998, 17479.62 >, < 0, -179.9997, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < -3450.822, -10560.32, 17467.22 >, < 0, 89.9824, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/fence_large_concrete_metal_dirty_128_01.rmdl", < 8846.968, -10859.38, 15900.75 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/beacon/modular_hose_yellow_128_02.rmdl", < -681.5537, -10625.14, 16443.91 >, < -90, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/fence_large_concrete_metal_dirty_128_01.rmdl", < 8788.468, -10672.88, 15900.75 >, < 0, 89.9999, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/beacon/modular_hose_yellow_corner_01.rmdl", < -681.5537, -10696.87, 16579.62 >, < 0, -90.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_steps_metal_grate_double_128_01.rmdl", < 5866.731, -10732.38, 15838 >, < 0, -90.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 1747.499, -10731.41, 15829.68 >, < 0, 90.0001, 0 >, true, 50000, -1, 1 )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -3069, -10111, 17703 >, < 90, 0, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -1581.401, -10675.02, 16537.73 >, < 0, -0.0253, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/fx/core_energy.rmdl", < 1443.718, -10766.63, 16196.01 >, < 0, 0.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/fence_large_concrete_metal_dirty_128_01.rmdl", < 9042.719, -10801.88, 15774.35 >, < 0, 89.9999, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_corner.rmdl", < -3054.401, -10296.64, 17852.57 >, < 0, 90.0639, 180 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < -3450.822, -10560.32, 17747.22 >, < 0, 89.9824, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_128.rmdl", < -3632.144, -10555.19, 17692.16 >, < 0, 90.0003, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_64.rmdl", < -3123.144, -10556.32, 17567.09 >, < 0, 90.0003, 90 >, true, 50000, -1, 1 )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < -3062, -10333, 17511 >, < 89.972, 89.9998, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < -3055.896, -10489.16, 17645.22 >, < 0, -179.9997, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/lamps/light_parking_post.rmdl", < -3490.21, -10122.06, 17479.33 >, < 0, 45.0003, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_corner.rmdl", < -3058.544, -9990.947, 17388.45 >, < -90, -89.936, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_corner.rmdl", < -3053.185, -10553.15, 17853.04 >, < 0, -179.9997, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/playback/playback_bridge_panel_128x064_01.rmdl", < 11474.55, -9657.676, 15017.13 >, < 0, 0, -10.414 >, true, 50000, -1, 1 )
    ClipInvisibleNoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_pillar_64.rmdl", < 8267, -10937.04, 15887.38 >, < 0, 180, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/utilities/halogen_lightbulbs.rmdl", < 11716.27, -5248.72, 15299.57 >, < 0, -90.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/slum_city/slumcity_girdering_128x16_dirty_d.rmdl", < 11707.02, -5061.51, 15435.58 >, < 0, -90.0001, 89.9893 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/beacon/construction_scaff_post_128_01.rmdl", < 11738.71, -4037.81, 15108.2 >, < -90, 89.9999, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_32_tjunk.rmdl", < -3054.382, -10313.68, 17868.01 >, < 90, -89.936, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < 11489, -10457, 15975 >, < 0, 0, 89.9998 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_04_corner.rmdl", < 6065.093, -11081.11, 15486.35 >, < 0, -135.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < -3561.144, -10560.32, 17607.22 >, < 0, 89.9824, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_256.rmdl", < -3055.448, -9974.807, 17437.17 >, < 0, 0.064, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/beacon/modular_hose_yellow_32_01.rmdl", < -546.4736, -10667.14, 16602.25 >, < 90, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/mendoko/mendoko_rubber_floor_01.rmdl", < 6989.414, -10706.38, 15368.28 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -2928.821, -10675.32, 17560.33 >, < 0, -179.9997, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/beacon/modular_hose_yellow_128_01.rmdl", < -553.2666, -10667.3, 16610.41 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/beacon/modular_hose_yellow_corner_01.rmdl", < -681.5732, -10633.08, 16436.71 >, < 0, 89.9999, 179.9742 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_04_corner.rmdl", < -3347.461, -10264.68, 17480.22 >, < 0, -44.9997, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 5705.048, -10734.13, 15859.34 >, < 0, -90.0001, -179.9659 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/ola/sewer_railing_01_corner_in.rmdl", < -3731.146, -9880.996, 17479.66 >, < 0, 0.0003, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/ola/sewer_railing_01_stairend.rmdl", < 5909.684, -10678.38, 15817.59 >, < 0, 89.9999, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/ola/sewer_staircase_01.rmdl", < 1442.671, -10862.6, 15963.03 >, < 0, 179.9998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < -3561.144, -10560.32, 17747.22 >, < 0, 89.9824, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_corner.rmdl", < -3615.882, -10558.32, 17388.45 >, < -90, 0.0003, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < -3056.147, -10265.15, 17467.22 >, < 0, -179.9997, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/beacon/modular_hose_yellow_corner_01.rmdl", < -681.5635, -10633.08, 16579.61 >, < 0, 89.9999, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/fence_large_concrete_metal_dirty_128_01.rmdl", < 8788.468, -10801.88, 15900.75 >, < 0, 89.9999, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_top.rmdl", < 9078.818, -10738.38, 16141.41 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -1335.55, -10675.59, 16896.61 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/ola/sewer_staircase_01.rmdl", < 1442.671, -10862.6, 16201.7 >, < 0, 179.9998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_32_valve.rmdl", < -3058.169, -10335.59, 17401.06 >, < 0, -179.936, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_02.rmdl", < 10237.91, -10921.09, 15652.5 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < 7920.848, -10921.38, 15317.35 >, < 89.9802, 89.9999, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -1949.001, -10524.08, 17616.76 >, < 0, 90.0003, 0 >, true, 50000, -1, 1 )
    ClipInvisibleNoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_pillar_64.rmdl", < 8267, -10544.04, 15887.38 >, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/timeshift/timeshift_bench_01.rmdl", < -3879.146, -10184, 17480.81 >, < 0, 135.0003, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_corner.rmdl", < -3053.978, -10297, 17853.04 >, < 0, -89.9361, 0 >, true, 50000, -1, 1 )
    ClipInvisibleNoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_pillar_64.rmdl", < 8168.558, -11046.88, 16018.25 >, < 0, 89.9999, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < 6697.093, -10738.98, 15472.35 >, < 0, 89.9999, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -1071.954, -10675.6, 16408.11 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/industrial/exit_sign_03.rmdl", < 8276.035, -10736.07, 16256.68 >, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_128.rmdl", < -3253.147, -10557.99, 17567.09 >, < 0, 90.0003, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/railing_metal_dirty_64_panel_01.rmdl", < 7414.022, -10740, 15487.91 >, < 0, 89.9998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_steps_metal_grate_double_128_01.rmdl", < 5890.731, -10732.38, 15822 >, < 0, -90.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < 11489, -10457, 15625 >, < 0, 0, 89.9998 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/beacon/modular_hose_yellow_32_01.rmdl", < -681.5537, -10665, 16579.6 >, < 0, -90.0166, 0 >, true, 50000, -1, 1 )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -3408.001, -10564, 17703 >, < 89.972, 89.9998, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_128.rmdl", < -3055.519, -10152, 17836.57 >, < 0, 0.0639, 90 >, true, 50000, -1, 1 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/Weapons/octane_epipen/w_octane_epipen.rmdl", < 7726.998, -10742.39, 15524.08 >, < -30.0001, -89.9998, 119.9657 >, true, 50000, -1, 5 ) )
    MapEditor_CreateProp( $"mdl/barriers/concrete/concrete_barrier_fence.rmdl", < 798.6592, -10671, 16438.29 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_stack_01.rmdl", < -4366.945, -9254.45, 17520.22 >, < 0, 45.0831, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < -3056.272, -10153.15, 17467.22 >, < 0, -179.9997, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_32_valve.rmdl", < -3631.477, -10555.1, 17406.14 >, < 0, -179.9997, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_128.rmdl", < -3271.144, -10557.99, 17433.08 >, < 0, 90.0003, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_cafeteria_table_01.rmdl", < 11822.01, -3497.766, 15144.71 >, < 0, -90.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_64.rmdl", < -3058.046, -10252.69, 17387.09 >, < 0, 0.0639, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_64.rmdl", < -3354.145, -10558.11, 17387.09 >, < 0, 90.0003, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < -3226.821, -10560.32, 17785.22 >, < 0, 89.9824, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x64_05.rmdl", < -3723.739, -9951.23, 17465.3 >, < 0, 89.9689, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_stack_01.rmdl", < -4261.94, -9359.455, 17353.22 >, < 0, 45.0831, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -1580.548, -10675.02, 16777.75 >, < 0, -0.0253, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_steps_metal_grate_double_128_01.rmdl", < 5818.731, -10732.38, 15870 >, < 0, -90.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/beacon/beacon_fence_sign_01.rmdl", < 1670.671, -10766.6, 16315.7 >, < 0, 89.9998, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/fence_large_concrete_metal_dirty_128_01.rmdl", < 9296.219, -10672.88, 15647.15 >, < 0, 89.9999, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/utilities/halogen_lightbulbs.rmdl", < 11716.27, -5152.72, 15299.57 >, < 0, -90.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_04_corner.rmdl", < -3347.464, -9563.23, 17480.22 >, < 0, 45.0003, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < 8272.857, -10557.38, 15317.35 >, < 89.9802, -90.0003, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/containers/slumcity_oxygen_bag_large_01_b.rmdl", < 2478.06, -10730.42, 15883.86 >, < 0, -90.0001, 0 >, true, 50000, -1, 1.477 )
    MapEditor_CreateProp( $"mdl/desertlands/fence_large_concrete_metal_dirty_128_01.rmdl", < 8534.968, -10801.88, 16027.95 >, < 0, 89.9999, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1442.591, -10550.16, 16722.25 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < -3226.821, -10560.32, 17645.22 >, < 0, 89.9824, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_64.rmdl", < -3261.821, -10553.51, 17868.3 >, < 0, 90.0003, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/fence_large_concrete_metal_dirty_128_01.rmdl", < 9354.719, -10859.38, 15647.15 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -4657.285, -8959.871, 17472.22 >, < 0, 135.0003, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/research_station_stairs_bend_01.rmdl", < 11567.8, -9277.266, 14702.69 >, < 0, 89.9999, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/timeshift/timeshift_bench_01.rmdl", < -3442.149, -9738.994, 17480.81 >, < 0, 135.0003, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_cafeteria_table_01.rmdl", < 11822.01, -3222.255, 15144.71 >, < 0, -90.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/zipline_arm.rmdl", < 6077.293, -11033.38, 15646.35 >, < 0, -0.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/security_fence_post.rmdl", < 6078.093, -11032.38, 15486.35 >, < 0, 89.9999, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/zipline_arm.rmdl", < 6078.895, -10431.38, 15646.35 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/security_fence_post.rmdl", < 6078.094, -10432.38, 15486.35 >, < 0, -90.0001, 0 >, true, 50000, -1, 1 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/props/zipline_balloon/zipline_balloon.rmdl", < 11585.01, -6977.008, 15405.21 >, < 0, -90.0001, 0 >, true, 50000, -1, 0.08 ) )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_128.rmdl", < -3197.822, -10552.51, 17868.3 >, < 0, 90.0003, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_corner.rmdl", < -3055.76, -9974.725, 17820.3 >, < 0, -89.9361, 0 >, true, 50000, -1, 1 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_32_valve.rmdl", < -3051.188, -10555.26, 17575.19 >, < 0, -44.9997, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < -1917.548, -10675.85, 17585 >, < 0, 89.9996, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 5649.093, -10845.38, 15720.35 >, < 0, -90.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 5705.048, -10789.88, 15859.34 >, < 0, -90.0001, -179.9659 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_64.rmdl", < -3053.347, -10345, 17868.3 >, < 0, 0.0639, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x128_02.rmdl", < -1447.63, -10679.59, 16425.21 >, < 0, 89.9999, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/slum_city/slumcity_girdering_256x16_dirty_d.rmdl", < 11723, -5280.378, 15307.57 >, < -90, 180, 0 >, true, 50000, -1, 1 )
    ClipInvisibleNoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_pillar_64.rmdl", < 8168.458, -10432.58, 16018.25 >, < 0, 89.9999, 0 >, true, 50000, -1, 1 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/props/zipline_balloon/zipline_balloon.rmdl", < 11584.85, -8318.683, 15155.21 >, < 0, -90.0001, 0 >, true, 50000, -1, 0.08 ) )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_128.rmdl", < -3055.697, -9991.356, 17836.57 >, < 0, 0.0639, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_256.rmdl", < -3058.231, -9993.68, 17387.96 >, < 0, 0.0639, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 8909.969, -10737.38, 15884.75 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 5649.05, -10789.88, 15859.32 >, < 0, -90.0001, -179.9659 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_steps_metal_grate_double_128_01.rmdl", < 5842.731, -10732.38, 15854 >, < 0, -90.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < 720.999, -10729, 16509.15 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 2932.093, -10731.38, 15854.65 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    NoGrappleArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < 11738.5, -5836.51, 14449 >, < 90, 180, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/research_station_stairs_bend_01.rmdl", < 11567.8, -9277.266, 14458.14 >, < 0, 89.9999, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < -1442.591, -10550.16, 16960.44 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 9417.719, -10737.38, 15631.15 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    ClipInvisibleNoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape.rmdl", < 8267, -10550.04, 16461.38 >, < 0, 180, 180 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/ola/sewer_staircase_96_double.rmdl", < -1195.599, -10675.59, 16661.4 >, < 0, 0, 0 >, true, 50000, -1, 1 )

    foreach ( entity ent in NoClimbArray ) ent.kv.solid = 3
    foreach ( entity ent in InvisibleArray ) ent.MakeInvisible()
    foreach ( entity ent in NoGrappleArray ) ent.kv.contents = CONTENTS_SOLID | CONTENTS_NOGRAPPLE
    foreach ( entity ent in ClipInvisibleNoGrappleNoClimbArray )
    {
        ent.MakeInvisible()
        ent.kv.solid = 3
        ent.kv.CollisionGroup = TRACE_COLLISION_GROUP_PLAYER
        ent.kv.contents = CONTENTS_SOLID | CONTENTS_NOGRAPPLE
    }
    foreach ( entity ent in NoCollisionArray ) ent.kv.solid = 0

    // Jumppads
    MapEditor_CreateJumpPad( MapEditor_CreateProp( $"mdl/props/octane_jump_pad/octane_jump_pad.rmdl", < 11584.53, -10092.91, 15025.6 >, < 0, 149.9999, 0 >, true, 50000, -1, 1 ) )

    // VerticalZipLines
    MapEditor_CreateZiplineFromUnity( < 11585.01, -6977.008, 15405.21 >, < 0, -90, 0 >, < 11585.01, -6977.008, 14455.21 >, < 0, -90, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 11584.85, -8318.683, 15155.21 >, < 0, -90, 0 >, < 11584.85, -8318.683, 14455.21 >, < 0, -90, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < -1844.001, -10667.29, 18855 >, < 0, 180, 0 >, < -1844.001, -10667.29, 17055 >, < 0, 180, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 11569, -9283.01, 15239.14 >, < 0, 90, 0 >, < 11569, -9283.01, 14469.14 >, < 0, 90, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 11584.85, -7715.683, 15155.21 >, < 0, -90, 0 >, < 11584.85, -7715.683, 14455.21 >, < 0, -90, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )

    // NonVerticalZipLines
    MapEditor_CreateZiplineFromUnity( < 5862, -10724.21, 16157 >, < 0, -0.0001, 0 >, < 6074.129, -11029.83, 15820.5 >, < 0, -0.0001, 0 >, false, -1, 1, 2, 1, 1, 0, 1, 150, 150, false, 0, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 6082.894, -10486.38, 15634.35 >, < 0, -90.0001, 0 >, < 6073.294, -10978.38, 15634.35 >, < 0, -90.0001, 0 >, false, -1, 1, 2, 1, 1, 0, 1, 150, 150, false, 0, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 6075.793, -10435.23, 15822.29 >, < 0, -90.0001, 0 >, < 5862, -10724, 16157 >, < 0, -90.0001, 0 >, false, -1, 1, 2, 1, 1, 0, 1, 150, 150, false, 0, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )

    // Func Window Hints
    MapEditor_CreateFuncWindowHint( < 1443.718, -10766.63, 16196.01 >, 64, 72, < 0, 1, 0 > )
    MapEditor_CreateFuncWindowHint( < 1442.718, -10766.63, 15957.72 >, 64, 72, < 0, 1, 0 > )
    MapEditor_CreateFuncWindowHint( < 1610.718, -10766.63, 16076.51 >, 64, 72, < 0, -1, 0 > )
    MapEditor_CreateFuncWindowHint( < 1611.718, -10766.63, 16315.81 >, 64, 72, < 0, -1, 0 > )

    // Buttons
    AddCallback_OnUseEntity( CreateFRButton(< 11437, -3709.917, 15144.11 >, < 0, -179.9997, 0 >, "%use% Start/Stop timer"), void function(entity panel, entity ent, int input)
    {
    if (IsValidPlayer(ent)) {
        if (ent.GetPersistentVar("gen") == 0) {
            ent.SetPersistentVar("gen", Time())
            ent.p.isTimerActive = true
            ent.p.startTime = floor(Time()).tointeger()
            Message(ent, "Timer Started!")
        } else {
            ent.SetPersistentVar("gen", 0)
            ent.p.isTimerActive = false
            Message(ent, "Timer Stopped")
        }
        ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
        ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
    }
    })
    AddCallback_OnUseEntity( CreateFRButton(< -4738.3, -8878.9, 17488.22 >, < 0, 45, 0 >, "%use% Go back to start"), void function(entity panel, entity ent, int input)
    {
    if (IsValidPlayer(ent)) {
        ent.SetOrigin(file.first_cp)
        ent.SetAngles(<0, 180, 0>)
        ent.SetVelocity(<0, 0, 0>)
    }
    })

    // 1
    Invis_Button(< 11425, -3577.7, 15143.97 >, < 0, 90, 0 >, true, < 11490.1, -4396.81, 15243.27 >, < 0, 180, 0 >, "" )
    Invis_Button(< 11425, -3484.7, 15143.97 >, < 0, 90, 0 >, false, < -3557.553, -10049.69, 17582.47 >, < 0, -45, 0 >, "" )
    // 2
    Invis_Button(< 11415.1, -4443.2, 15143.97 >, < 0, 90, 0 >, true, < 11490.2, -6207.01, 14537.17 >, < 0, 180, 0 >, "" )
    Invis_Button(< 11415.1, -4350.2, 15143.97 >, < 0, 90, 0 >, false, < 11500.01, -3531.31, 15243.27 >, < 0, 180, 0 >, "" )
    // 3
    Invis_Button(< 11415.2, -6253.4, 14437.87 >, < 0, 90, 0 >, true, < 11534.7, -8990.41, 14557.87 >, < 0, 180, 0 >, "" )
    Invis_Button(< 11415.2, -6160.4, 14437.87 >, < 0, 90, 0 >, false, < 11490.1, -4396.81, 15243.27 >, < 0, 180, 0 >, "" )
    // 4
    Invis_Button(< 11459.69, -9036.801, 14458.57 >, < 0, 90, 0 >, true, < 11539, -9775.01, 15124.77 >, < 0, 180, 0 >, "" )
    Invis_Button(< 11459.69, -8943.801, 14458.57 >, < 0, 90, 0 >, false, < 11490.2, -6207.01, 14537.17 >, < 0, 180, 0 >, "" )
    // 5
    Invis_Button(< 11463.99, -9821.4, 15025.47 >, < 0, 90, 0 >, true, < 10648.6, -10651.21, 15752.47 >, < 0, 90, 0 >, "" )
    Invis_Button(< 11463.99, -9728.4, 15025.47 >, < 0, 90, 0 >, false, < 11534.7, -8990.41, 14557.87 >, < 0, 180, 0 >, "" )
    // 6
    Invis_Button(< 10602.21, -10576.2, 15653.17 >, < 0, 0, 0 >, true, < 9668.6, -10693.01, 15745.77 >, < 0, 90, 0 >, "" )
    Invis_Button(< 10695.21, -10576.2, 15653.17 >, < 0, 0, 0 >, false, < 11539, -9775.01, 15124.77 >, < 0, 180, 0 >, "" )
    // 7
    Invis_Button(< 9622.209, -10618, 15646.47 >, < 0, 0, 0 >, true, < 8408.399, -10693.01, 16282.67 >, < 0, 90, 0 >, "" )
    Invis_Button(< 9715.209, -10618, 15646.47 >, < 0, 0, 0 >, false, < 10648.6, -10651.21, 15752.47 >, < 0, 90, 0 >, "" )
    // 8
    Invis_Button(< 8362.009, -10618, 16183.37 >, < 0, 0, 0 >, true, < 7797, -10718.41, 15586.77 >, < 0, 90, 0 >, "" )
    Invis_Button(< 8455.009, -10618, 16183.37 >, < 0, 0, 0 >, false, < 9668.6, -10693.01, 15745.77 >, < 0, 90, 0 >, "" )
    // 9
    Invis_Button(< 7750.609, -10643.4, 15487.47 >, < 0, 0, 0 >, true, < 6647.399, -10718.41, 15586.17 >, < 0, 90, 0 >, "" )
    Invis_Button(< 7843.609, -10643.4, 15487.47 >, < 0, 0, 0 >, false, < 8408.399, -10693.01, 16282.67 >, < 0, 90, 0 >, "" )
    // 10
    Invis_Button(< 6601.009, -10643.4, 15486.87 >, < 0, 0, 0 >, true, < 5707, -10704.5, 15968.47 >, < 0, 90, 0 >, "" )
    Invis_Button(< 6694.009, -10643.4, 15486.87 >, < 0, 0, 0 >, false, < 7797, -10718.41, 15586.77 >, < 0, 90, 0 >, "" )
    // 11
    Invis_Button(< 5660.609, -10629.5, 15869.17 >, < 0, 0, 0 >, true, < 3186.2, -10685.3, 15969.37 >, < 0, 90, 0 >, "" )
    Invis_Button(< 5753.609, -10629.5, 15869.17 >, < 0, 0, 0 >, false, < 6647.4, -10718.41, 15586.17 >, < 0, 90, 0 >, "" )
    // 12
    Invis_Button(< 3139.81, -10610.3, 15870.07 >, < 0, 0, 0 >, true, < 1872.7, -10684.9, 15944.97 >, < 0, 90, 0 >, "" )
    Invis_Button(< 3232.81, -10610.3, 15870.07 >, < 0, 0, 0 >, false, < 5707, -10704.5, 15968.47 >, < 0, 90, 0 >, "" )
    // 13
    Invis_Button(< 1826.31, -10609.89, 15845.67 >, < 0, 0, 0 >, true, < 928.5986, -10651.9, 16538.77 >, < 0, 90, 0 >, "" )
    Invis_Button(< 1919.31, -10609.89, 15845.67 >, < 0, 0, 0 >, false, < 3186.2, -10685.3, 15969.37 >, < 0, 90, 0 >, "" )
    // 14
    Invis_Button(< 882.208, -10576.89, 16439.47 >, < 0, 0, 0 >, true, < -153.9014, -10629.3, 16539.97 >, < 0, 90, 0 >, "" )
    Invis_Button(< 975.208, -10576.89, 16439.47 >, < 0, 0, 0 >, false, < 1872.7, -10684.9, 15944.97 >, < 0, 90, 0 >, "" )
    // 15
    Invis_Button(< -200.292, -10554.29, 16440.67 >, < 0, 0, 0 >, true, < -1079.8, -10629.3, 16523.57 >, < 0, 90, 0 >, "" )
    Invis_Button(< -107.292, -10554.29, 16440.67 >, < 0, 0, 0 >, false, < 928.5986, -10651.9, 16538.77 >, < 0, 90, 0 >, "" )
    // 16
    Invis_Button(< -1126.19, -10554.29, 16424.27 >, < 0, 0, 0 >, true, < -1623.3, -10628.6, 17147.27 >, < 0, 90, 0 >, "" )
    Invis_Button(< -1033.19, -10554.29, 16424.27 >, < 0, 0, 0 >, false, < -153.9014, -10629.3, 16539.97 >, < 0, 90, 0 >, "" )
    // 17
    Invis_Button(< -1669.69, -10553.59, 17047.97 >, < 0, 0, 0 >, true, < -2854.001, -10721.8, 17675.17 >, < 0, -90, 0 >, "" )
    Invis_Button(< -1576.69, -10553.59, 17047.97 >, < 0, 0, 0 >, false, < -1079.8, -10629.3, 16523.57 >, < 0, 90, 0 >, "" )
    // 18
    Invis_Button(< -2807.61, -10796.8, 17575.87 >, < 0, 180, 0 >, true, < -3557.553, -10049.69, 17582.47 >, < 0, -45, 0 >, "" )
    Invis_Button(< -2900.61, -10796.8, 17575.87 >, < 0, 180, 0 >, false, < -1623.3, -10628.6, 17147.27 >, < 0, 90, 0 >, "" )
    // 19
    Invis_Button(< -3471.712, -10069.92, 17483.17 >, < 0, -135, 0 >, true, < 11500.01, -3531.309, 15243.27 >, < 0, 180, 0 >, "" )
    Invis_Button(< -3537.473, -10135.69, 17483.17 >, < 0, -135, 0 >, false, < -2854.001, -10721.8, 17675.17 >, < 0, -90, 0 >, "" )


    // Triggers
    entity trigger_0 = MapEditor_CreateTrigger( < 11584.01, -2444.01, 14617 >, < 0, -90.0001, 0 >, 2500, 50, false )
    trigger_0.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValidPlayer(ent) && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
            ent.SetAngles(file.cp_angle[ent])
            ent.SetVelocity(<0, 0, 0>)
        } else {
            ent.SetOrigin(file.first_cp)
            ent.SetVelocity(<0, 0, 0>)
        }
    }
    })
    DispatchSpawn( trigger_0 )
    entity trigger_1 = MapEditor_CreateTrigger( < 11584, -4926.01, 14243 >, < 0, -90.0001, 0 >, 2500, 50, false )
    trigger_1.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValidPlayer(ent) && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
            ent.SetAngles(file.cp_angle[ent])
            ent.SetVelocity(<0, 0, 0>)
        } else {
            ent.SetOrigin(file.first_cp)
            ent.SetVelocity(<0, 0, 0>)
        }
    }
    })
    DispatchSpawn( trigger_1 )
    entity trigger_2 = MapEditor_CreateTrigger( < 11584, -7920.01, 14243 >, < 0, -90.0001, 0 >, 2500, 50, false )
    trigger_2.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValidPlayer(ent) && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
            ent.SetAngles(file.cp_angle[ent])
            ent.SetVelocity(<0, 0, 0>)
        } else {
            ent.SetOrigin(file.first_cp)
            ent.SetVelocity(<0, 0, 0>)
        }
    }
    })
    DispatchSpawn( trigger_2 )
    entity trigger_3 = MapEditor_CreateTrigger( < 11471, -11001.01, 14243 >, < 0, -90.0001, 0 >, 2500, 50, false )
    trigger_3.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValidPlayer(ent) && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
            ent.SetAngles(file.cp_angle[ent])
            ent.SetVelocity(<0, 0, 0>)
        } else {
            ent.SetOrigin(file.first_cp)
            ent.SetVelocity(<0, 0, 0>)
        }
    }
    })
    DispatchSpawn( trigger_3 )
    entity trigger_4 = MapEditor_CreateTrigger( < 9597, -10864.01, 15347 >, < 0, -90.0001, 0 >, 1250, 50, false )
    trigger_4.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValidPlayer(ent) && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
            ent.SetAngles(file.cp_angle[ent])
            ent.SetVelocity(<0, 0, 0>)
        } else {
            ent.SetOrigin(file.first_cp)
            ent.SetVelocity(<0, 0, 0>)
        }
    }
    })
    DispatchSpawn( trigger_4 )
    entity trigger_5 = MapEditor_CreateTrigger( < 6946, -11001.01, 15040 >, < 0, -90.0001, 0 >, 2500, 50, false )
    trigger_5.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValidPlayer(ent) && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
            ent.SetAngles(file.cp_angle[ent])
            ent.SetVelocity(<0, 0, 0>)
        } else {
            ent.SetOrigin(file.first_cp)
            ent.SetVelocity(<0, 0, 0>)
        }
    }
    })
    DispatchSpawn( trigger_5 )
    entity trigger_6 = MapEditor_CreateTrigger( < 3277.999, -11001, 15340 >, < 0, -90.0001, 0 >, 3000, 50, false )
    trigger_6.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValidPlayer(ent) && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
            ent.SetAngles(file.cp_angle[ent])
            ent.SetVelocity(<0, 0, 0>)
        } else {
            ent.SetOrigin(file.first_cp)
            ent.SetVelocity(<0, 0, 0>)
        }
    }
    })
    DispatchSpawn( trigger_6 )
    entity trigger_7 = MapEditor_CreateTrigger( < -821.001, -11001, 16174 >, < 0, -90.0001, 0 >, 2000, 50, false )
    trigger_7.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValidPlayer(ent) && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
            ent.SetAngles(file.cp_angle[ent])
            ent.SetVelocity(<0, 0, 0>)
        } else {
            ent.SetOrigin(file.first_cp)
            ent.SetVelocity(<0, 0, 0>)
        }
    }
    })
    DispatchSpawn( trigger_7 )
    entity trigger_8 = MapEditor_CreateTrigger( < -3056.998, -7844.997, 16955 >, < 0, -90.0001, 0 >, 3000, 50, false )
    trigger_8.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValidPlayer(ent) && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
            ent.SetAngles(file.cp_angle[ent])
            ent.SetVelocity(<0, 0, 0>)
        } else {
            ent.SetOrigin(file.first_cp)
            ent.SetVelocity(<0, 0, 0>)
        }
    }
    })
    DispatchSpawn( trigger_8 )
    entity trigger_9 = MapEditor_CreateTrigger( < -4007.002, -12923, 16955 >, < 0, -90.0001, 0 >, 3000, 50, false )
    trigger_9.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValidPlayer(ent) && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
            ent.SetAngles(file.cp_angle[ent])
            ent.SetVelocity(<0, 0, 0>)
        } else {
            ent.SetOrigin(file.first_cp)
            ent.SetVelocity(<0, 0, 0>)
        }
    }
    })
    DispatchSpawn( trigger_9 )
    entity trigger_10 = MapEditor_CreateTrigger( < 11471, -13798.01, 16078 >, < 0, -90.0001, 0 >, 2500, 1000, false )
    trigger_10.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValidPlayer(ent) && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
            ent.SetAngles(file.cp_angle[ent])
            ent.SetVelocity(<0, 0, 0>)
        } else {
            ent.SetOrigin(file.first_cp)
            ent.SetVelocity(<0, 0, 0>)
        }
    }
    })
    DispatchSpawn( trigger_10 )
    entity trigger_11 = MapEditor_CreateTrigger( < 14495, -10201.01, 16078 >, < 0, -90.0001, 0 >, 2500, 1000, false )
    trigger_11.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValidPlayer(ent) && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
            ent.SetAngles(file.cp_angle[ent])
            ent.SetVelocity(<0, 0, 0>)
        } else {
            ent.SetOrigin(file.first_cp)
            ent.SetVelocity(<0, 0, 0>)
        }
    }
    })
    DispatchSpawn( trigger_11 )
    entity trigger_12 = MapEditor_CreateTrigger( < 8897.002, -7959.008, 16078 >, < 0, -90.0001, 0 >, 2500, 1000, false )
    trigger_12.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValidPlayer(ent) && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
            ent.SetAngles(file.cp_angle[ent])
            ent.SetVelocity(<0, 0, 0>)
        } else {
            ent.SetOrigin(file.first_cp)
            ent.SetVelocity(<0, 0, 0>)
        }
    }
    })
    DispatchSpawn( trigger_12 )
    entity trigger_13 = MapEditor_CreateTrigger( < 10814, -9950, 16078 >, < 0, -90.0001, 0 >, 474.95, 1000, false )
    trigger_13.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValidPlayer(ent) && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
            ent.SetAngles(file.cp_angle[ent])
            ent.SetVelocity(<0, 0, 0>)
        } else {
            ent.SetOrigin(file.first_cp)
            ent.SetVelocity(<0, 0, 0>)
        }
    }
    })
    DispatchSpawn( trigger_13 )
    entity trigger_14 = MapEditor_CreateTrigger( < 11585, -3531, 15193 >, < 0, -90.0001, 0 >, 172.5, 50, false )
    trigger_14.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValidPlayer(ent)) {
        file.cp_table[ent] <- < 11585, -3427.9, 15193 >
        file.cp_angle[ent] <- < 0, -90.0001, 0 >
        file.last_cp[ent] <- false
    }
    })
    DispatchSpawn( trigger_14 )
    entity trigger_15 = MapEditor_CreateTrigger( < 11585, -4396, 15188.11 >, < 0, -90.0001, 0 >, 200, 50, false )
    trigger_15.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValidPlayer(ent)) {
        int gen = ent.GetPersistentVarAsInt("gen")

        if (gen != 0) {
            float final_time = Time() - gen
            float minutes = final_time / 60
            float seconds = final_time % 60

            Message(ent, format("%d:%02d", minutes, seconds))
        }

        file.cp_table[ent] <- < 11585, -4218, 15188.11 >
        file.cp_angle[ent] <- < 0, -90.0001, 0 >
    }
    })
    DispatchSpawn( trigger_15 )
    entity trigger_16 = MapEditor_CreateTrigger( < 11585, -6208, 14829 >, < 0, -90.0001, 0 >, 200, 386.9, false )
    trigger_16.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValidPlayer(ent)) {
        int gen = ent.GetPersistentVarAsInt("gen")

        if (gen != 0) {
            float final_time = Time() - gen
            float minutes = final_time / 60
            float seconds = final_time % 60

            Message(ent, format("%d:%02d", minutes, seconds))
        }

        file.cp_table[ent] <- < 11585, -6455, 14504 >
        file.cp_angle[ent] <- < 0, -90.0001, 0 >
    }
    })
    DispatchSpawn( trigger_16 )
    entity trigger_17 = MapEditor_CreateTrigger( < 11579.7, -8989.709, 14507.71 >, < 0, -90.0001, 0 >, 122.5, 50, false )
    trigger_17.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValidPlayer(ent)) {
        int gen = ent.GetPersistentVarAsInt("gen")

        if (gen != 0) {
            float final_time = Time() - gen
            float minutes = final_time / 60
            float seconds = final_time % 60

            Message(ent, format("%d:%02d", minutes, seconds))
        }

        file.cp_table[ent] <- < 11579.7, -8989.709, 14507.71 >
        file.cp_angle[ent] <- < 0, -90.0001, 0 >
    }
    })
    DispatchSpawn( trigger_17 )
    entity trigger_18 = MapEditor_CreateTrigger( < 11585.4, -9775.609, 15074.91 >, < 0, -90.0001, 0 >, 122.5, 50, false )
    trigger_18.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValidPlayer(ent)) {
        int gen = ent.GetPersistentVarAsInt("gen")

        if (gen != 0) {
            float final_time = Time() - gen
            float minutes = final_time / 60
            float seconds = final_time % 60

            Message(ent, format("%d:%02d", minutes, seconds))
        }

        file.cp_table[ent] <- < 11585.4, -9775.609, 15074.91 >
        file.cp_angle[ent] <- < 0, -90.0001, 0 >
    }
    })
    DispatchSpawn( trigger_18 )
    entity trigger_19 = MapEditor_CreateTrigger( < 10649, -10744.01, 15700.94 >, < 0, 179.9999, 0 >, 172.5, 50, false )
    trigger_19.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValidPlayer(ent)) {
        int gen = ent.GetPersistentVarAsInt("gen")

        if (gen != 0) {
            float final_time = Time() - gen
            float minutes = final_time / 60
            float seconds = final_time % 60

            Message(ent, format("%d:%02d", minutes, seconds))
        }

        file.cp_table[ent] <- < 10649, -10744.01, 15700.94 >
        file.cp_angle[ent] <- < 0, 179.9999, 0 >
    }
    })
    DispatchSpawn( trigger_19 )
    entity trigger_20 = MapEditor_CreateTrigger( < 9669.899, -10739.55, 15696.48 >, < 0, -180, 0 >, 122.5, 50, false )
    trigger_20.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValidPlayer(ent)) {
        int gen = ent.GetPersistentVarAsInt("gen")

        if (gen != 0) {
            float final_time = Time() - gen
            float minutes = final_time / 60
            float seconds = final_time % 60

            Message(ent, format("%d:%02d", minutes, seconds))
        }

        file.cp_table[ent] <- < 9669.899, -10739.55, 15696.48 >
        file.cp_angle[ent] <- < 0, -180, 0 >
    }
    })
    DispatchSpawn( trigger_20 )
    entity trigger_21 = MapEditor_CreateTrigger( < 8407.857, -10738.88, 16205.85 >, < 0, 180, 0 >, 122.5, 50, false )
    trigger_21.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValidPlayer(ent)) {
        int gen = ent.GetPersistentVarAsInt("gen")

        if (gen != 0) {
            float final_time = Time() - gen
            float minutes = final_time / 60
            float seconds = final_time % 60

            Message(ent, format("%d:%02d", minutes, seconds))
        }

        file.cp_table[ent] <- < 8407.857, -10738.88, 16205.85 >
        file.cp_angle[ent] <- < 0, 180, 0 >
    }
    })
    DispatchSpawn( trigger_21 )
    entity trigger_22 = MapEditor_CreateTrigger( < 7796.658, -10738.98, 15537.65 >, < 0, 179.9999, 0 >, 62.5, 50, false )
    trigger_22.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValidPlayer(ent)) {
        file.cp_table[ent] <- < 7796.658, -10738.98, 15537.65 >
        file.cp_angle[ent] <- < 0, 179.9999, 0 >
        int gen = ent.GetPersistentVarAsInt("gen")

        if (gen != 0) {
            float final_time = Time() - gen
            float minutes = final_time / 60
            float seconds = final_time % 60

            Message(ent, format("%d:%02d", minutes, seconds))
        }

        StatusEffect_StopAllOfType( ent, eStatusEffect.speed_boost )
        StatusEffect_StopAllOfType( ent, eStatusEffect.stim_visual_effect )
        ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
        ent.GiveOffhandWeapon("mp_ability_heal", OFFHAND_TACTICAL)
    }
    })
    DispatchSpawn( trigger_22 )
    entity trigger_23 = MapEditor_CreateTrigger( < 6647.994, -10739.38, 15537.65 >, < 0, 179.9999, 0 >, 122.5, 50, false )
    trigger_23.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValidPlayer(ent)) {
        file.cp_table[ent] <- < 6215.494, -10739.38, 15537.65 >
        file.cp_angle[ent] <- < 0, 179.9999, 0 >
        int gen = ent.GetPersistentVarAsInt("gen")

        if (gen != 0) {
            float final_time = Time() - gen
            float minutes = final_time / 60
            float seconds = final_time % 60

            Message(ent, format("%d:%02d", minutes, seconds))
        }
        
        ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
    }
    })
    DispatchSpawn( trigger_23 )
    entity trigger_24 = MapEditor_CreateTrigger( < 5705.593, -10732.53, 15919.15 >, < 0, 180, 0 >, 122.5, 50, false )
    trigger_24.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValidPlayer(ent)) {
        file.cp_table[ent] <- < 5705.593, -10732.53, 15919.15 >
        file.cp_angle[ent] <- < 0, 180, 0 >
        int gen = ent.GetPersistentVarAsInt("gen")

        if (gen != 0) {
            float final_time = Time() - gen
            float minutes = final_time / 60
            float seconds = final_time % 60

            Message(ent, format("%d:%02d", minutes, seconds))
        }

        ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
        ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
        ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
        ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
        ent.SetSuitGrapplePower(100)
    }
    })
    DispatchSpawn( trigger_24 )
    entity trigger_25 = MapEditor_CreateTrigger( < 3172.001, -10731.4, 16758 >, < 0, -179.9898, 0 >, 156.7, 900, false )
    trigger_25.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValidPlayer(ent)) {
        file.cp_table[ent] <- < 3198.999, -10731.38, 15914 >
        file.cp_angle[ent] <- < 0, -180, 0 >
        int gen = ent.GetPersistentVarAsInt("gen")

        if (gen != 0) {
            float final_time = Time() - gen
            float minutes = final_time / 60
            float seconds = final_time % 60

            Message(ent, format("%d:%02d", minutes, seconds))
        }
        
        ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
    }

    })
    DispatchSpawn( trigger_25 )
    entity trigger_26 = MapEditor_CreateTrigger( < 1873.601, -10731.65, 15919.25 >, < 0, -179.9898, 0 >, 122.5, 75.1, false )
    trigger_26.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValidPlayer(ent)) {
        int gen = ent.GetPersistentVarAsInt("gen")

        if (gen != 0) {
            float final_time = Time() - gen
            float minutes = final_time / 60
            float seconds = final_time % 60

            Message(ent, format("%d:%02d", minutes, seconds))
        }

        file.cp_table[ent] <- < 1873.601, -10731.65, 15919.25 >
        file.cp_angle[ent] <- < 0, -179.9898, 0 >
    }
    })
    DispatchSpawn( trigger_26 )
    entity trigger_27 = MapEditor_CreateTrigger( < 930.1455, -10671, 16489.52 >, < 0, -179.9898, 0 >, 63.75, 50, false )
    trigger_27.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValidPlayer(ent)) {
        int gen = ent.GetPersistentVarAsInt("gen")

        if (gen != 0) {
            float final_time = Time() - gen
            float minutes = final_time / 60
            float seconds = final_time % 60

            Message(ent, format("%d:%02d", minutes, seconds))
        }

        file.cp_table[ent] <- < 930.1455, -10671, 16489.52 >
        file.cp_angle[ent] <- < 0, -179.9898, 0 >
    }
    })
    DispatchSpawn( trigger_27 )
    entity trigger_28 = MapEditor_CreateTrigger( < -152.9541, -10675.6, 16490.31 >, < 0, -179.9898, 0 >, 122.5, 50, false )
    trigger_28.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValidPlayer(ent)) {
        int gen = ent.GetPersistentVarAsInt("gen")

        if (gen != 0) {
            float final_time = Time() - gen
            float minutes = final_time / 60
            float seconds = final_time % 60

            Message(ent, format("%d:%02d", minutes, seconds))
        }

        file.cp_table[ent] <- < 43.999, -10675.6, 16490.31 >
        file.cp_angle[ent] <- < 0, -179.9898, 0 >
    }
    })
    DispatchSpawn( trigger_28 )
    entity trigger_29 = MapEditor_CreateTrigger( < -1079.401, -10675.59, 16474.21 >, < 0, -179.9898, 0 >, 122.5, 50, false )
    trigger_29.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValidPlayer(ent)) {
        int gen = ent.GetPersistentVarAsInt("gen")

        if (gen != 0) {
            float final_time = Time() - gen
            float minutes = final_time / 60
            float seconds = final_time % 60

            Message(ent, format("%d:%02d", minutes, seconds))
        }

        file.cp_table[ent] <- < -1079.401, -10675.59, 16474.21 >
        file.cp_angle[ent] <- < 0, -179.9898, 0 >
    }
    })
    DispatchSpawn( trigger_29 )
    entity trigger_30 = MapEditor_CreateTrigger( < -1622.771, -10675.76, 17095.38 >, < 0, -179.9898, 0 >, 122.5, 50, false )
    trigger_30.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValidPlayer(ent)) {
        int gen = ent.GetPersistentVarAsInt("gen")

        if (gen != 0) {
            float final_time = Time() - gen
            float minutes = final_time / 60
            float seconds = final_time % 60

            Message(ent, format("%d:%02d", minutes, seconds))
        }

        file.cp_table[ent] <- < -1622.771, -10675.76, 17095.38 >
        file.cp_angle[ent] <- < 0, -179.9898, 0 >
    }
    })
    DispatchSpawn( trigger_30 )
    entity trigger_31 = MapEditor_CreateTrigger( < -2860.37, -10675.76, 17625.18 >, < 0, 150.0102, 0 >, 122.5, 50, false )
    trigger_31.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValidPlayer(ent)) {
        int gen = ent.GetPersistentVarAsInt("gen")

        if (gen != 0) {
            float final_time = Time() - gen
            float minutes = final_time / 60
            float seconds = final_time % 60

            Message(ent, format("%d:%02d", minutes, seconds))
        }

        file.cp_table[ent] <- < -2860.37, -10675.76, 17625.18 >
        file.cp_angle[ent] <- < 0, 150.0102, 0 >
    }
    })
    DispatchSpawn( trigger_31 )
    entity trigger_32 = MapEditor_CreateTrigger( < -3587.824, -10026.32, 17530.13 >, < 0, 135.0102, 0 >, 215, 50, false )
    trigger_32.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValidPlayer(ent)) {
        file.cp_table[ent] <- < -3587.824, -10026.32, 17530.13 >
        file.cp_angle[ent] <- < 0, 135.0102, 0 >
        file.last_cp[ent] <- true
        int gen = ent.GetPersistentVarAsInt("gen")

        if (gen != 0) {
            float final_time = Time() - gen
            float minutes = final_time / 60
            float seconds = final_time % 60

            Message(ent, format("%d:%02d", minutes, seconds))
        }

        StatusEffect_StopAllOfType( ent, eStatusEffect.speed_boost )
        StatusEffect_StopAllOfType( ent, eStatusEffect.stim_visual_effect )
        ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
        ent.GiveOffhandWeapon("mp_ability_heal", OFFHAND_TACTICAL)
    }
    })
    DispatchSpawn( trigger_32 )
    entity trigger_33 = MapEditor_CreateTrigger( < -4261.827, -9360.322, 17778.33 >, < 0, 135.0102, 0 >, 215, 50, false )
    trigger_33.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValidPlayer(ent)) {
        StatusEffect_StopAllOfType( ent, eStatusEffect.speed_boost )
        StatusEffect_StopAllOfType( ent, eStatusEffect.stim_visual_effect )
        ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
    }
    })
    DispatchSpawn( trigger_33 )
    entity trigger_34 = MapEditor_CreateTrigger( < -4661.528, -8955.629, 17540.32 >, < 0, 135.0003, 0 >, 120, 50, false )
    trigger_34.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValidPlayer(ent)) {
        file.cp_table[ent] <- < -4661.528, -8955.629, 17540.32 >
        file.cp_angle[ent] <- < 0, 135.0003, 0 >
        
        ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
        
        if (file.last_cp[ent]) {
            int gen = ent.GetPersistentVarAsInt("gen")

            if (gen != 0) {
                float final_time = Time() - gen
                float minutes = final_time / 60
                float seconds = final_time % 60

                Message(ent, format("%d:%02d", minutes, seconds), "Final Time")
                ent.SetPersistentVar("gen", 0)
            } else {
                Message(ent, "You Finished!", "Congratulations")
            }

            if (ent.p.isTimerActive == true) {
                ent.p.isTimerActive = false
            }
        }
        file.last_cp[ent] <- false
    }
    })
    DispatchSpawn( trigger_34 )
    entity trigger_35 = MapEditor_CreateTrigger( < 2921, -11259, 16601 >, < 0, -179.9898, 0 >, 533.5, 1200, false )
    trigger_35.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValidPlayer(ent)) {
            ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
        }
    })
    DispatchSpawn( trigger_35 )
    entity trigger_36 = MapEditor_CreateTrigger( < 2921.001, -10216.02, 16587 >, < 0, -179.9898, 0 >, 533.5, 1200, false )
    trigger_36.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValidPlayer(ent)) {
            ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
        }
    })
    DispatchSpawn( trigger_36 )
}
