untyped
globalize_all_functions

// Made by Loy and Treeree. 

void function mantlemap_precache() {
    PrecacheModel( $"mdl/desertlands/wall_city_corner_concrete_64_02.rmdl" )
    PrecacheModel( $"mdl/desertlands/wall_city_barred_concrete_192_01.rmdl" )
    PrecacheModel( $"mdl/industrial/zipline_arm.rmdl" )
    PrecacheModel( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl" )
    PrecacheModel( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl" )
    PrecacheModel( $"mdl/desertlands/industrial_drill_01_support_02.rmdl" )
    PrecacheModel( $"mdl/thunderdome/thunderdome_cage_wall_128x352_03.rmdl" )
    PrecacheModel( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl" )
    PrecacheModel( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl" )
    PrecacheModel( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl" )
    PrecacheModel( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl" )
    PrecacheModel( $"mdl/desertlands/wall_city_panel_concrete_64_01.rmdl" )
    PrecacheModel( $"mdl/desertlands/construction_bldg_elevator_01_top.rmdl" )
    PrecacheModel( $"mdl/industrial/underbelly_support_beam_256_01.rmdl" )
    PrecacheModel( $"mdl/desertlands/construction_bldg_platform_01.rmdl" )
    PrecacheModel( $"mdl/desertlands/desertlands_fuel_tower_pill_tank_med_01.rmdl" )
    PrecacheModel( $"mdl/fx/ar_marker_big_arrow_down.rmdl" )
    PrecacheModel( $"mdl/industrial/security_fence_post.rmdl" )
    PrecacheModel( $"mdl/desertlands/construction_bldg_platform_03.rmdl" )
    PrecacheModel( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl" )
    PrecacheModel( $"mdl/desertlands/construction_bldg_column_01.rmdl" )
    PrecacheModel( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_03.rmdl" )
    PrecacheModel( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl" )
    PrecacheModel( $"mdl/pipes/slum_pipe_large_yellow_512_01.rmdl" )
    PrecacheModel( $"mdl/desertlands/construction_bldg_elevator_01_bott.rmdl" )
    PrecacheModel( $"mdl/thunderdome/thunderdome_cage_frame_16x352_01.rmdl" )
    PrecacheModel( $"mdl/homestead/homestead_floor_panel_01.rmdl" )
    PrecacheModel( $"mdl/thunderdome/thunderdome_cage_frame_16x32_01.rmdl" )
    PrecacheModel( $"mdl/ola/sewer_grate_01.rmdl" )
    PrecacheModel( $"mdl/firstgen/firstgen_pipe_256_goldfoil_01.rmdl")
    PrecacheModel( $"mdl/floating_village/lagoon_window_metal_shutters_open_80x128.rmdl")
    PrecacheModel( $"mdl/desertlands/desertlands_large_liquid_tank_01.rmdl")
    PrecacheModel( $"mdl/fx/energy_ring_edge.rmdl")
}


struct {
    array < entity > door_list
    table<entity, vector> cp_table = {}
    vector first_cp = < 2015.6, -6767, 18139 >
}
file

void function mantlejumpmap_init() {
  AddCallback_OnClientConnected( mantlemap_player_setup )
  AddCallback_EntitiesDidLoad( MantleJumpMapEntitiesDidLoad )
  mantlemap_precache()
}

void function MantleJumpMapEntitiesDidLoad()
{
	thread mantlemap_load()
	thread mantlemap_reset_doors()
}

void function mantlemap_SpawnInfoText( entity player ) {
	CreatePanelText(player, "12", "", < 2808.018, -28037.01, 23739.73 >, < 0, -179.9997, 0 >, false, 1 )
	CreatePanelText(player, "11", "", < 1471.772, 10931.9, 24457.32 >, < 0, 89.986, 0 >, false, 1 )
	CreatePanelText(player, "9", "", < 1936.201, -26709.17, 21599.13 >, < 0, 0, 0 >, false, 1 )
	CreatePanelText(player, "17", "", < 1937.939, 12683.44, 30704.32 >, < 0, -89.9993, 0 >, false, 1 )
	CreatePanelText(player, "Hard", "Course", < 2089.4, -7017.9, 18365.4 >, < -15, -90.0001, 0 >, false, 1 )
	CreatePanelText(player, "14", "", < 1255.536, 12189.64, 27790.52 >, < 0, 90, 0 >, false, 1 )
	CreatePanelText(player, "12", "", < 1254.773, 11273.9, 25557.85 >, < 0, 89.986, 0 >, false, 1 )
	CreatePanelText(player, "Loy and Treeree", "Made by:", < 2216, -6772.2, 18288.4 >, < 0, -0.0001, 0 >, false, 1 )
	CreatePanelText(player, "8", "", < 1968.266, -25003.8, 21001.33 >, < 0, 0, 0 >, false, 1 )
	CreatePanelText(player, "2", "", < 3090.481, 11751.27, 15211.33 >, < 0, -90, 0 >, false, 1 )
	CreatePanelText(player, "18", "", < 1979.999, 13474.49, 31602 >, < 0, 89.986, 0 >, false, 1 )
	CreatePanelText(player, "10", "", < 1262.772, 10591.9, 23353.32 >, < 0, 89.986, 0 >, false, 1 )
	CreatePanelText(player, "1", "", < 3088.958, 12428.77, 14204.52 >, < 0, -90, 0 >, false, 1 )
	CreatePanelText(player, "6", "", < 1513.766, 10177.18, 19229.32 >, < 0, 179.998, 0 >, false, 1 )
	CreatePanelText(player, "7", "", < 1603.318, 9425.265, 20230.32 >, < 0, -90.0021, 0 >, false, 1 )
	CreatePanelText(player, "13", "", < 1255.536, 11566.54, 26758.52 >, < 0, 90, 0 >, false, 1 )
	CreatePanelText(player, "10", "", < 3058.363, -27627.1, 22115.23 >, < 0.0001, -90.0066, 0 >, false, 1 )
	CreatePanelText(player, "16", "", < 1937.937, 12864.44, 29869.52 >, < 0, 90, 0 >, false, 1 )
	CreatePanelText(player, "14", "", < 5490.953, -28042.9, 25540.73 >, < 0, 0.0004, 0 >, false, 1 )
	CreatePanelText(player, "3", "", < 919.191, -19924.7, 17935.63 >, < 0, -90, 0 >, false, 1 )
	CreatePanelText(player, "4", "", < 2453.969, 10792.12, 17230.32 >, < 0, 179.9999, 0 >, false, 1 )
	CreatePanelText(player, "15", "", < 1768.841, 12357.96, 28827.62 >, < 0, 0, 0 >, false, 1 )
	CreatePanelText(player, "7", "", < 1609.794, -24807.92, 19455.93 >, < 0, -90.0001, 0 >, false, 1 )
	CreatePanelText(player, "13", "", < 3511.953, -28098.9, 25309.73 >, < 0, 0.0004, 0 >, false, 1 )
	CreatePanelText(player, "5", "", < 2266.317, 10082.27, 18228.32 >, < 0, -90.002, 0 >, false, 1 )
	CreatePanelText(player, "6", "", < 1608.996, -23639.72, 19372.13 >, < 0, -90.0001, 0 >, false, 1 )
	CreatePanelText(player, "2", "", < 924.0396, -19279.3, 16767.73 >, < 0, 90, 0 >, false, 1 )
	CreatePanelText(player, "15", "", < 5313.953, -29838.89, 27516.73 >, < 0, -89.9996, 0 >, false, 1 )
	CreatePanelText(player, "4", "", < 922, -22078.9, 17974.53 >, < 0, -90, 0 >, false, 1 )
	CreatePanelText(player, "19", "", < 1920.812, 15773.8, 31816.7 >, < 0, 89.986, 0 >, false, 1 )
	CreatePanelText(player, "9", "", < 1462.706, 10455.62, 22277.32 >, < 0, 179.9838, 0 >, false, 1 )
	CreatePanelText(player, "8", "", < 1599.416, 10266.69, 21202.32 >, < 0, 90.0198, 0 >, false, 1 )
	CreatePanelText(player, "1", "", < 417.5096, -19512.2, 15237 >, < 0, -90, 0 >, false, 1 )
	CreatePanelText(player, "Easy", "Course", < 1993.801, -6364.4, 18217.2 >, < 0, 89.9999, 0 >, false, 1 )
	CreatePanelText(player, "3", "", < 3090.481, 11049.27, 16217.35 >, < 0, -90, 0 >, false, 1 )
	CreatePanelText(player, "11", "", < 4172.018, -27979.01, 23481.73 >, < 0, -179.9997, 0 >, false, 1 )
	CreatePanelText(player, "5", "", < 1609.001, -22377.32, 19372.23 >, < 0, -90.0001, 0 >, false, 1 )
}

void function mantlemap_doors() {
    file.door_list.clear()
        file.door_list.extend(MapEditor_SpawnDoor( < 3165.018, -28034.01, 23602.73 >, < 90, -0.0064, 0 >, eMapEditorDoorType.Horizontal, false, true ) )
        file.door_list.extend(MapEditor_SpawnDoor( < 4572.953, -28043.9, 25437.73 >, < 90, 179.9936, 0 >, eMapEditorDoorType.Horizontal, false, false ) )
    }

void function mantlemap_reset_doors()
{
    foreach ( door in file.door_list )
    {
        if ( IsValid( door ) )
        {
            door.Destroy()
        }
    }

    file.door_list.clear()

    mantlemap_doors()
}


void function mantlemap_player_setup( entity player )
{
    array<ItemFlavor> characters = GetAllCharacters()
	player.SetOrigin(file.first_cp)
	CharacterSelect_AssignCharacter(ToEHI(player), characters[8])

	TakeAllPassives( player )
	TakeAllWeapons( player )
	player.GiveWeapon("mp_weapon_melee_survival", WEAPON_INVENTORY_SLOT_PRIMARY_2, [])
	player.GiveOffhandWeapon("melee_pilot_emptyhanded", OFFHAND_MELEE, [])
	player.SetPlayerNetBool("pingEnabled", false)

	player.SetAngles(< 0, 0, 0 >)
	player.SetPersistentVar("gen", 0)
	Message(player, "Welcome to the Mantle Map!")
	mantlemap_SpawnInfoText( player )
}

void function mantlemap_load() {    // Props Array
    array < entity > NoClimbArray; array < entity > ClipInvisibleNoGrappleNoClimbArray; 

    // Props
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 3279.9, -28034, 24126.73 >, < -30.0001, 0, 0 >, true, 250, -1, 1 )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 3300, -28034, 24709.73 >, < -30.0001, 0, 0 >, true, 250, -1, 1 )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 2686, -28034, 23840.73 >, < -30, -179.9997, 0 >, true, 250, -1, 1 )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 2686, -28034, 24433.73 >, < -30, -179.9997, 0 >, true, 250, -1, 1 )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 2579.1, -27271.8, 22077.13 >, < 45.0001, -90, -0.0107 >, true, 250, -1, 1 )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 2542.816, -27551.88, 22253.38 >, < 75.0001, -0.0004, -0.011 >, true, 250, -1, 1 )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 2228.616, -27291.78, 22065.08 >, < 75.0001, -0.0004, -0.011 >, true, 250, -1, 1 )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 2264.9, -27011.7, 21888.83 >, < 45.0001, -90, -0.0107 >, true, 250, -1, 1 )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 1913.716, -27019.81, 21838.96 >, < 75.0001, -0.0004, -0.011 >, true, 250, -1, 1 )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 1950, -26739.73, 21662.71 >, < 45.0001, -90, -0.0107 >, true, 250, -1, 1 )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 922.5, -19227.08, 17441.96 >, < 0, 0, 44.9999 >, true, 250, -1, 1 )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 922.4999, -19458.63, 17557.73 >, < 0, -179.9997, 44.9999 >, true, 250, -1, 1 )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 922.4999, -19458.63, 17251.5 >, < 0, -179.9997, 44.9999 >, true, 250, -1, 1 )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 922.5, -19227.08, 17135.73 >, < 0, 0, 44.9999 >, true, 250, -1, 1 )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 922.4999, -19458.63, 16954.5 >, < 0, -179.9997, 44.9999 >, true, 250, -1, 1 )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 922.5, -19227.08, 16838.73 >, < 0, 0, 44.9999 >, true, 250, -1, 1 )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 418.0095, -19014.4, 15682.69 >, < 0, 0, 30 >, true, 250, -1, 1 )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 417.5244, -19548, 15394.39 >, < 0, -180, 30 >, true, 250, -1, 1 )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 1048.8, -19357.63, 16182.26 >, < 44.9999, -89.9756, 0.0173 >, true, 250, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/zipline_arm.rmdl", < 5025.736, -29225.92, 28803.73 >, < 0, 90.0004, 0 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 1387.96, 11355.21, 26648.24 >, < 0, 179.9699, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1472.197, 10937.01, 24839.84 >, < -0.0123, -0.0114, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 2525.07, 10177.5, 18905.6 >, < 0, 179.9936, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 3090.523, 11575.94, 15805.03 >, < -45, 90.0007, 0 >, true, 250, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 3089.924, 10229.13, 16308.35 >, < 0, 89.9959, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1140.881, 11014.32, 24917.84 >, < 0, -90.0019, 0 >, false, 50000, -1, 1 ) )
    ClipInvisibleNoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/firstgen/firstgen_pipe_256_goldfoil_01.rmdl", < 975, -22088.9, 18676.6 >, < -90, 0, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1817.993, 12890.49, 29982.7 >, < 0, -90.008, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 1417.691, -25067.8, 20591.63 >, < 0, -179.99, 0 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1148.05, 10382.37, 22841.84 >, < 0, 89.9639, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 1139.392, 10577.3, 23238 >, < 0, -0.0438, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 924.1616, -19807.65, 16285 >, < 0, -179.9899, 0 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1602.925, 9420.159, 20739.37 >, < -0.0123, -179.9994, 179.9718 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 921.6307, -19380.24, 16669.03 >, < 0, 0.0107, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 6643.973, -29135.9, 26815.73 >, < 0, -89.9998, 0 >, true, 50000, -1, 1 ) )
    ClipInvisibleNoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 2610.363, -27228.5, 22026.73 >, < -0.0001, 89.9999, -90 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 2663.573, 10917.57, 16715.84 >, < 0, 179.9779, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 2385.878, 10055.19, 17952.8 >, < 0, 89.99, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 1133.123, 11551.1, 26648 >, < 0, -0.0298, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 1626.437, 10293.63, 21804 >, < 0, 108.741, 45.0001 >, true, 250, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 2432.545, 10925.63, 17113.26 >, < 0, 90.0026, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1558.674, 12472.53, 28319.84 >, < 0, -0.022, 0 >, false, 50000, -1, 1 ) )
    ClipInvisibleNoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/firstgen/firstgen_pipe_256_goldfoil_01.rmdl", < 1262.9, -22088.9, 18980 >, < -90, 0, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 2968.463, 12401.5, 14321.41 >, < 0, 89.9894, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_03.rmdl", < 2461.982, -27084.84, 22033.23 >, < 0, 0, 90.0001 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 1122.304, 11246.69, 25441.24 >, < 0, 89.9885, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1594.171, 10672.32, 23945.31 >, < 0, 90.0163, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < 1834.782, -26574.44, 21814.76 >, < -90, -90.0001, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/floating_village/lagoon_window_metal_shutters_open_80x128.rmdl", < 3359.991, -27928.52, 22423.2 >, < 0, -90.0065, 0.0001 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1558.626, 12232.53, 28319.84 >, < 0, -0.022, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_64_01.rmdl", < 1584.072, 10609.25, 24236.23 >, < -90, 90.0801, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 1489.913, 10334.15, 22162.25 >, < 0, 179.9863, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 3089.932, 11746.16, 15466.37 >, < -0.0123, -179.9974, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 1389.031, 12210.15, 27680.26 >, < 0, 0.0027, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/floating_village/lagoon_window_metal_shutters_open_80x128.rmdl", < 3764.068, -27721.26, 22678.1 >, < -0.0001, -0.0063, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1599.991, 10271.79, 21457.37 >, < -0.0123, 0.0225, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/floating_village/lagoon_window_metal_shutters_open_80x128.rmdl", < 4065.079, -27230.6, 22935.1 >, < -0.0001, -0.0065, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_corner_concrete_64_02.rmdl", < 1624.078, 10526.33, 23946.18 >, < 0.0027, 45.0038, 179.9973 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/floating_village/lagoon_window_metal_shutters_open_80x128.rmdl", < 4557.45, -27539.75, 23190.1 >, < -0.0001, -0.0064, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1456.157, 10582.32, 23817.31 >, < 0, -180, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_64_01.rmdl", < 1360.228, 10582.23, 24232.23 >, < -90, -179.9196, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 1603.602, 9352.414, 20843.46 >, < 0, -179.9997, 45.0001 >, true, 250, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/floating_village/lagoon_window_metal_shutters_open_80x128.rmdl", < 3834.96, -27792.37, 22678.1 >, < 0, 89.9936, -0.0001 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1496.158, 10473.32, 24010.31 >, < 0, -180, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 1602.888, 8605.121, 20321.33 >, < 0, 89.9938, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 4259.018, -28034.01, 23270.73 >, < -0.0001, -89.9998, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1374.972, 11300.95, 25282.32 >, < 0, -90.0221, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 1109.031, 12210.15, 27680.26 >, < 0, 0.0027, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/industrial/zipline_arm.rmdl", < 1977.132, -25426.6, 21592.73 >, < 0, 120, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/security_fence_post.rmdl", < 1975.866, -25426.4, 21292.73 >, < 0, -150, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < 2141.583, -26840.44, 22021.76 >, < -90, -90.0001, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/floating_village/lagoon_window_metal_shutters_open_80x128.rmdl", < 4065.08, -27230.6, 22935.1 >, < -0.0001, -0.0065, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 3088.463, 11608.43, 14501.91 >, < 0, 89.9932, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 3058.38, -27622.78, 22070.8 >, < 0.0001, 179.9935, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 1268.014, 11276.69, 26141.23 >, < -30, 89.9883, 0 >, true, 250, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_64_01.rmdl", < 1376.996, 11045.25, 25331.77 >, < 90, -90.1031, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 1487.718, -24284.36, 20146.95 >, < -45, 0, 39.7038 >, true, 250, -1, 1 )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 462.6954, -19544.4, 15935.86 >, < 75, 0, 0 >, true, 250, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 3088.508, 12423.47, 14587.31 >, < -0.0123, -180, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 2387.761, 10096.08, 18112.09 >, < 0, 179.9997, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1937.994, 12868.49, 30252.2 >, < -0.0123, 0.0026, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1376.113, 11592.81, 26489.8 >, < 0, -90.008, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/industrial/zipline_arm.rmdl", < 1980.908, 14409.7, 31488.29 >, < 0, 90.0088, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/security_fence_post.rmdl", < 1979.908, 14410.5, 31388.29 >, < 0, -179.9912, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/zipline_arm.rmdl", < 1981, 13477.7, 31488.29 >, < 0, 90.0088, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/security_fence_post.rmdl", < 1980, 13478.5, 31388.29 >, < 0, -179.9912, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 1602.997, 10436.57, 19700.24 >, < 0, -90.0065, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 3212.963, 11985.85, 15094.26 >, < 0, -89.9975, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1482.879, 9398.192, 19954.8 >, < 0, 89.9899, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1937.994, 12868.49, 29996.8 >, < -0.0123, 0.0026, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1254.921, 11279.01, 25812.89 >, < -0.0123, -0.0114, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 1633.826, 10792.68, 17114.33 >, < 0, -0.0042, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 2956.969, 11729.84, 15094.26 >, < 0, -179.9973, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 922.5289, -22074.6, 18539 >, < 0, -179.9899, 0 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 3089.932, 11746.16, 15593.84 >, < -0.0123, -179.9974, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 1122.393, 11260.3, 25440.99 >, < 0, -0.0438, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < 2284.083, -26963.64, 22021.76 >, < -90, -0.0001, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 2060.082, -27094.53, 22061.73 >, < 0, 180, 179.9999 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1795.307, 12237.39, 28940.7 >, < 0, 179.992, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 2265.924, 10077.16, 18610.84 >, < -0.0123, -179.9994, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 1263.275, 11412.04, 23754.6 >, < 0, -90.0053, -179.9926 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 2057.993, 12890.5, 29982.7 >, < 0, -90.008, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 424.196, -19493.83, 15802.23 >, < 0, -179.9902, 0 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/floating_village/lagoon_window_metal_shutters_open_80x128.rmdl", < 3764.068, -27721.26, 22678.1 >, < -0.0001, -0.0063, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_64_01.rmdl", < 1584.157, 10582.32, 23945.31 >, < 0, -180, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_corner_concrete_64_02.rmdl", < 1108.16, 10868.33, 25046.7 >, < 0.0027, -135.0099, 179.9973 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/wall_city_barred_concrete_192_01.rmdl", < 1385.217, 11240.33, 26282.23 >, < 15.011, 90.0073, -89.991 >, false, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 3200.743, -28032.89, 24566.23 >, < 0, -89.9896, 0 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1594.171, 10672.32, 24071.31 >, < 0, 90.0163, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 2958.02, 11765.91, 15094 >, < 0, 89.9971, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 1557.723, 12480.4, 28717.24 >, < 0, -0.0032, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_64_01.rmdl", < 1344.379, 10924.32, 25172.84 >, < 0, -180, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/floating_village/lagoon_window_metal_shutters_open_80x128.rmdl", < 4628.339, -27634.26, 23260.9 >, < 90, 89.9935, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 3414.953, -28042.9, 25109.73 >, < 0, 179.9935, -0.0001 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 1394.25, 10577.22, 23238 >, < 0, -90.0169, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/floating_village/lagoon_window_metal_shutters_open_80x128.rmdl", < 3834.97, -27705.97, 22758.1 >, < 90, -90.0064, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 900.2131, -19283.24, 16703.83 >, < 90, 0.0104, 0 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1256.091, 11570.79, 27267.7 >, < -0.0123, 0.0026, 179.9718 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 2385.878, 10055.19, 18334.7 >, < 0, 89.99, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 1468.872, 9402.896, 20114.35 >, < 0, -179.9678, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 3850.692, -27440.91, 22733.29 >, < 29.9999, 44.9999, 0 >, true, 250, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1134.972, 11301, 25282.32 >, < 0, -90.0221, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1380.973, 11356.13, 26250.84 >, < 0, 89.978, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 1937.961, 13691.49, 30795.33 >, < 0, -90.0041, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 1833.79, -25000.84, 20892.65 >, < -0.0001, 89.9999, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 1611.492, -24805.5, 19410.73 >, < 0, -179.9899, 0 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/pipes/slum_pipe_large_yellow_512_01.rmdl", < 918.2467, -20727.66, 17890.73 >, < -0.0001, -89.9904, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 2969.887, 11022.19, 15941.82 >, < 0, 89.992, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 3089.932, 11746.16, 15212.44 >, < -0.0123, -179.9974, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 1696.253, 10334.09, 22162.25 >, < 0, 179.9863, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1376.895, 11014.32, 24917.84 >, < 0, 90.0163, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 1740.99, 12480.46, 28717.26 >, < 0, 0.0025, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 5528.959, -29169.9, 26262.73 >, < 0, -179.9997, 0 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1482.879, 9398.192, 20336.7 >, < 0, 89.9899, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 1255.129, 12094.05, 25648.85 >, < 0, -90.0182, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 5302.953, -29832.89, 27999.73 >, < 0, -179.9997, 0 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 1732.895, 10289.17, 21087.25 >, < 0, 0.0225, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 2965.027, 11258.87, 15702.87 >, < 0, -90.022, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_03.rmdl", < 1216.035, 11131.35, 26215.21 >, < 89.9802, -0.0414, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 929.929, -22132.4, 18695.39 >, < 30, 0, 0 >, true, 250, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 2811.622, -28034.59, 23694.77 >, < 0, 90.0104, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/industrial/zipline_arm.rmdl", < 2001.064, 14861.29, 32107.93 >, < 0, 90.002, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 2265.996, 11093.57, 17904.6 >, < 0, -90.0065, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_corner_concrete_64_02.rmdl", < 1108.16, 10868.33, 25300.7 >, < 0.0027, -135.0099, 179.9973 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 1599.585, 11086.83, 21603.6 >, < 0, -89.9714, -179.9926 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 1323.309, 10954.36, 24341.37 >, < 0, -0.0114, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 3090.055, 10931.13, 15714.18 >, < 0, 90.0087, -179.9926 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 1256.032, 10554.42, 26234.31 >, < 0, 89.9956, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 939, -22132.4, 18086.73 >, < 30, 0, 0 >, true, 250, -1, 1 )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 5282.953, -29187.89, 28351.73 >, < 29.9999, -179.9996, 0 >, true, 250, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 1377.182, 11064.35, 25441.23 >, < 0, 179.9559, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1457.597, 10456.17, 22532.37 >, < -0.0123, 89.9865, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 1633.826, 10792.55, 17733.18 >, < 0, 0.0087, -179.9926 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 3088.508, 12423.47, 14713.84 >, < -0.0123, -180, 179.9718 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_top.rmdl", < 2587.995, 12357.54, 29338.2 >, < 0, -179.9917, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1672.341, 10581.01, 21765.84 >, < 0, 179.9618, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1508.66, 10177.58, 19611.84 >, < -0.0123, 90.0006, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_64_01.rmdl", < 1140.79, 11046.25, 25331.76 >, < -89.972, 90.085, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 1256.076, 12385.87, 26856.33 >, < 0, -90.0041, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 1557.711, 12225.54, 28717.24 >, < 0, 89.9699, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1817.993, 12898.49, 30810.7 >, < 0, -90.008, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_03.rmdl", < 2286.027, -26967.09, 21829.73 >, < 0.0001, -90.0001, 90.0001 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1256.091, 12193.79, 28299.7 >, < -0.0123, 0.0026, 179.9718 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 1723.462, 10055.82, 19113.34 >, < 0, -179.9736, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/floating_village/lagoon_window_metal_shutters_open_80x128.rmdl", < 4557.45, -27539.75, 23190.1 >, < -0.0001, -0.0064, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 2057.993, 12898.5, 30810.7 >, < 0, -90.008, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 3236.969, 11027.84, 16100.28 >, < 0, -179.9973, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1256.091, 12193.79, 28173.2 >, < -0.0123, 0.0026, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 1263.406, 11412.04, 23237.33 >, < 0, -90.0182, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 2145.878, 10055.19, 18334.7 >, < 0, 89.99, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 922.5289, -21970.6, 17871 >, < 0, -179.9899, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 1937.961, 13683.49, 29760.33 >, < 0, -90.0041, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 1779.837, 10407.51, 21970.1 >, < 0, -119.9778, 45.0001 >, true, 250, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 2387.733, 10316.03, 18112.35 >, < 0, -89.968, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_barred_concrete_192_01.rmdl", < 1256.539, 11316.32, 26068.31 >, < 0, -0.0117, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1216.379, 10924.32, 24917.84 >, < 0, -180, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1817.993, 12898.49, 30428.8 >, < 0, -90.008, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 1122.254, 11040.35, 25441.24 >, < 0, 89.9885, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1140.973, 11979.17, 27282.84 >, < 0, 89.978, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/floating_village/lagoon_window_metal_shutters_open_80x128.rmdl", < 4628.339, -27634.26, 23270.1 >, < 90, 89.9935, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 1611.001, -22243.02, 19263.73 >, < -0.0001, -0.0001, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 1476.302, 10334.24, 22162 >, < 0, 89.954, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 929.929, -22132.4, 19304.73 >, < 30, 0, 0 >, true, 250, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/floating_village/lagoon_window_metal_shutters_open_80x128.rmdl", < 3834.979, -27626.77, 22758.1 >, < 90, -90.0064, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 921.6422, -19349.23, 16923.73 >, < -90, -89.9998, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 1491.397, 10311.63, 19113.35 >, < 0, 90.0323, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1263.198, 10597.01, 23608.37 >, < -0.0123, -0.0114, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_03.rmdl", < 1979.229, -26701.09, 21622.73 >, < 0.0001, -90.0001, 90.0001 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 1835.784, -26701.44, 21486.66 >, < -0.0001, 89.9999, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 1835.782, -26701.44, 21854.76 >, < -0.0001, 89.9999, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_corner_concrete_64_02.rmdl", < 1624.078, 10526.33, 24200.18 >, < 0.0027, 45.0038, 179.9973 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 1255.945, 13008.87, 28300.18 >, < 0, -89.9913, -179.9926 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 2141.027, 10291.87, 17715.99 >, < 0, -90.0241, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 1387.98, 11551.09, 26648 >, < 0, -90.0029, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1393.883, 11064.27, 25045.24 >, < 0, 89.9639, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_large_liquid_tank_01.rmdl", < 4223.257, -27631.91, 22524.5 >, < 0, 89.9935, -0.0001 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1486.693, 10297.62, 19335.7 >, < 0, -0.01, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/floating_village/lagoon_window_metal_shutters_open_80x128.rmdl", < 4136.188, -27159.71, 22935.1 >, < 0, -90.0065, 0.0001 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 5579.953, -28081.9, 25907.73 >, < 45, -89.9997, 0 >, true, 250, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 2265.996, 11093.57, 17698.24 >, < 0, -90.0065, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1376.113, 12215.81, 27521.8 >, < 0, -90.008, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 2264.399, -7273.6, 18386.2 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 1815.029, 12629.15, 29759.26 >, < 0, 90.0025, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 1154.264, -24690.13, 20296.33 >, < 0, 90.0101, 0 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 1316.529, -22074.6, 18843 >, < 0, -179.9899, 0 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1143.249, 10619, 23465.84 >, < 0, -90.0221, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1339.158, 10722.38, 23945.84 >, < 0, 89.9639, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1773.295, 12357.41, 29210.2 >, < -0.0123, -89.9974, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 1472.405, 11752.05, 24548.33 >, < 0, -90.0182, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 2448.864, 10792.67, 17485.37 >, < -0.0123, 90.0026, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/floating_village/lagoon_window_metal_shutters_open_80x128.rmdl", < 4628.348, -27555.06, 23270.1 >, < 90, 89.9935, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1121.883, 11064.38, 25045.24 >, < 0, 89.9639, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 2588.374, 12357.42, 28925.33 >, < 0, 179.9959, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 3442.283, -27999.63, 22326 >, < 0, -90.0066, 0.0001 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/floating_village/lagoon_window_metal_shutters_open_80x128.rmdl", < 3058.587, -27555.78, 22248 >, < 89.9802, 89.9935, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/industrial/zipline_arm.rmdl", < 974.6069, -22088.58, 18886.18 >, < 0, 38.9681, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/security_fence_post.rmdl", < 974.6, -22087.3, 18586.3 >, < 0, 128.9681, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 2238.766, -26950.5, 21742.73 >, < 90, -89.9893, 0 >, true, 50000, -1, 1 ) )
    ClipInvisibleNoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/firstgen/firstgen_pipe_256_goldfoil_01.rmdl", < 1262.9, -22088.9, 18351 >, < -90, 0, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 2426.902, 10672.71, 17336.7 >, < 0, -0.0081, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 2956.969, 11027.84, 16100.28 >, < 0, -179.9973, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1241.08, 10815.32, 24983.84 >, < 0, -180, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1241.08, 10815.32, 25110.84 >, < 0, -180, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 5556.953, -29225.9, 26397.73 >, < -45, -179.9997, 0 >, true, 250, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1383.249, 10618.95, 23465.84 >, < 0, -90.0221, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 3212.877, 11063.9, 16100.03 >, < 0, 179.9702, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_64_01.rmdl", < 1375.31, 10924.23, 25332.78 >, < 90, 179.9197, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/floating_village/lagoon_window_metal_shutters_open_80x128.rmdl", < 3834.979, -27626.77, 22748.9 >, < 90, -90.0064, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1435.6, 10336.22, 22050.32 >, < 0, -0.0242, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 1347.392, 10918.3, 24341.12 >, < 0, -0.0438, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 1540.195, 10055.66, 19113.35 >, < 0, -179.9679, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 1938.035, 11852.49, 29552.6 >, < 0, 89.9955, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 423.46, -19409.19, 15060.63 >, < 0, -89.9904, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_64_01.rmdl", < 1584.157, 10582.32, 23817.31 >, < 0, -180, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 2063.002, 12654.5, 29361.84 >, < 0, 89.978, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 2132.904, 10095.96, 18112.09 >, < 0, 90.0267, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 3835.177, -27638.97, 22580.9 >, < -0.0001, -0.0065, 0 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 2265.924, 10077.16, 18355.44 >, < -0.0123, -179.9994, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1256.091, 12193.79, 27791.8 >, < -0.0123, 0.0026, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/homestead/homestead_floor_panel_01.rmdl", < 1289.531, 11317.31, 26192.98 >, < 0.0118, 0, 90.0012 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/floating_village/lagoon_window_metal_shutters_open_80x128.rmdl", < 3834.96, -27792.37, 22678.1 >, < 0, 89.9936, -0.0001 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 1672.179, 10334.16, 22162.24 >, < 0, 179.9806, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/floating_village/lagoon_window_metal_shutters_open_80x128.rmdl", < 3058.597, -27469.38, 22168 >, < 0, -90.0064, 0.0001 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 1789.655, 12224.47, 28717.26 >, < 0, -89.9973, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 3209.887, 11724.2, 14935.8 >, < 0, 89.992, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 1477, 10253.03, 21087 >, < 0, -0.0099, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 1133.102, 11978.22, 27680.24 >, < 0, 89.9968, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_03.rmdl", < 2508.096, -27355.73, 22265.23 >, < 0, 180, 179.9999 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/industrial/zipline_arm.rmdl", < 1261.421, -22088.97, 18564.18 >, < 0, -48.021, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/security_fence_post.rmdl", < 1262.7, -22088.9, 18264.3 >, < 0, 41.979, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/zipline_arm.rmdl", < 1261.421, -22088.97, 19190.28 >, < 0, -48.021, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/security_fence_post.rmdl", < 1262.7, -22088.9, 18890.4 >, < 0, 41.979, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 3088.997, 12246.7, 14806.61 >, < -45, 89.9932, 0 >, true, 250, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 2448.864, 10792.67, 17739.37 >, < -0.0123, 90.0026, 179.9718 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 1256.076, 12385.87, 26649.33 >, < 0, -90.0041, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 1377.251, 11260.22, 25440.99 >, < 0, -90.0169, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 2474.007, 10455.85, 21539.22 >, < 0, 179.9794, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1256.091, 12193.79, 28045.7 >, < -0.0123, 0.0026, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 3089.932, 11044.16, 16599.87 >, < -0.0123, -179.9974, 179.9718 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 1255.476, 11741.86, 27355.92 >, < -45, -89.9993, 0 >, true, 250, -1, 1 )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 1633.603, -24839.62, 19554.87 >, < -24.8222, 156.468, 46.0636 >, true, 250, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/zipline_arm.rmdl", < 4452.953, -28098.8, 25223.88 >, < 0, 0.0091, 0.0001 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/zipline_arm.rmdl", < 3520.153, -28099.9, 25223.73 >, < 0, 0.0091, 0.0001 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/industrial/security_fence_post.rmdl", < 3520.953, -28098.9, 25123.73 >, < -0.0001, 90.0091, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/wall_city_barred_concrete_192_01.rmdl", < 1002.037, 11240.32, 26282.23 >, < -15.0114, -90, -89.9915 >, false, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 2474.007, 10455.85, 21747.41 >, < 0, 179.9794, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 2968.463, 12401.5, 13939.51 >, < 0, 89.9894, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 4994.953, -29352.89, 29309.73 >, < 0, 89.9935, -0.0001 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 1815.093, 12653.22, 29759.24 >, < 0, 89.9968, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1937.994, 12868.49, 30378.7 >, < -0.0123, 0.0026, 179.9718 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/floating_village/lagoon_window_metal_shutters_open_80x128.rmdl", < 3129.489, -27540.49, 22168 >, < 0.0001, 179.9937, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 1117.815, -24714.61, 20429.49 >, < 20.1459, 21.5219, 48.8672 >, true, 250, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/pipes/slum_pipe_large_yellow_512_01.rmdl", < 919.4667, -21366.66, 17890.73 >, < -0.0001, -89.9904, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 1115.309, 10613.36, 23238.25 >, < 0, -0.0114, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 1963.985, -25425.31, 21228.73 >, < 90, -89.9893, 0 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 3212.963, 11283.85, 16100.28 >, < 0, -89.9975, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1720.028, 10293.81, 20986.89 >, < 0, -89.9882, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/floating_village/lagoon_window_metal_shutters_open_80x128.rmdl", < 4699.25, -27539.77, 23190.1 >, < 0.0001, 179.9937, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1456.157, 10582.32, 23945.31 >, < 0, -180, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/floating_village/lagoon_window_metal_shutters_open_80x128.rmdl", < 4628.358, -27468.66, 23190.1 >, < 0, -90.0064, 0.0001 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1672.225, 10341.01, 21765.84 >, < 0, 179.9618, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 756.9253, 12357.47, 28510.6 >, < 0, -0.0044, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 1394.181, 10381.35, 23238.24 >, < 0, 179.9559, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 1472.274, 11752.05, 24858.6 >, < 0, -90.0053, -179.9926 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 2481.209, 10669.64, 17113.26 >, < 0, -179.9976, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 1602.888, 8605.121, 20114.33 >, < 0, 89.9938, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1496.158, 10473.32, 23883.31 >, < 0, -180, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 1599.716, 11086.83, 21086.33 >, < 0, -89.9843, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 3273.872, -27505.27, 22241.26 >, < -44.9999, -45.0001, 0 >, true, 250, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1592.248, 10958.95, 24568.84 >, < 0, -90.0221, 0 >, false, 50000, -1, 1 ) )
    ClipInvisibleNoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/firstgen/firstgen_pipe_256_goldfoil_01.rmdl", < 4162.018, -27979.01, 23588.73 >, < 90, 0.0003, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 3068.966, -27525.51, 21882.46 >, < -0.0001, 89.9999, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_64_01.rmdl", < 1148.994, 10951.25, 25336.76 >, < -90, 90.0801, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_03.rmdl", < 1705.584, -26701.09, 21622.73 >, < 0.0001, -90.0001, 90.0001 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 921.1796, -19826.66, 17844.73 >, < -0.0001, -89.9904, -0.009 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/floating_village/lagoon_window_metal_shutters_open_80x128.rmdl", < 3359.975, -28070.32, 22423.2 >, < 0, 89.9935, -0.0001 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/floating_village/lagoon_window_metal_shutters_open_80x128.rmdl", < 3834.97, -27705.97, 22758.1 >, < 90, -90.0064, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1937.994, 12868.49, 30124.7 >, < -0.0123, 0.0026, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 1452.895, 10289.07, 21087.25 >, < 0, 0.0225, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_03.rmdl", < 2605.427, -27228.29, 22033.23 >, < 0.0001, -90.0001, 90.0001 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/floating_village/lagoon_window_metal_shutters_open_80x128.rmdl", < 3905.868, -27721.28, 22678.1 >, < 0.0001, 179.9936, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/pipes/slum_pipe_large_yellow_512_01.rmdl", < 919.2238, -20089.66, 17890.73 >, < -0.0001, -89.9904, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 1133.037, 11331.15, 26648.26 >, < 0, 90.0025, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_03.rmdl", < 1881.893, -26828.53, 21854.73 >, < 0, 180, 179.9999 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 1602.249, 10918.22, 24341.12 >, < 0, -90.0169, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 3058.38, -27622.78, 22070.8 >, < 0.0001, 179.9935, 0 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 3090.055, 10229.13, 16720.2 >, < 0, 90.0087, -179.9926 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1256.091, 11570.79, 27013.7 >, < -0.0123, 0.0026, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 919.1954, -19920.66, 17890.73 >, < 0, -179.9893, 0.0001 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_top.rmdl", < 1255.958, 12385.49, 27269.2 >, < 0, -89.9917, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 2379.482, -27355.73, 22265.23 >, < 0, 180, 179.9999 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1258.884, 11060.32, 25367.84 >, < 0, -0.0076, 0.0026 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 2525.07, 10177.5, 18699.24 >, < 0, 179.9936, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 1600.307, 9255.383, 20878.6 >, < 0, 90.0154, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1476.159, 10596.39, 24261.24 >, < -0.0076, 0, -89.9929 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 3089.968, 12060.57, 15893.63 >, < 0, -90.0045, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 1937.468, 13031.63, 30517.88 >, < 30, -89.9993, 0 >, true, 250, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_03.rmdl", < 1833.789, -25128.68, 21028.72 >, < 0, 0, 90.0001 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 1254.636, 10262.6, 25234.12 >, < 0, 89.9815, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 3089.932, 11746.16, 15720.37 >, < -0.0123, -179.9974, 179.9718 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1457.597, 10456.17, 22278.44 >, < -0.0123, 89.9865, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/zipline_arm.rmdl", < 3286.018, -27979.11, 23388.88 >, < 0, -179.991, 0.0001 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/zipline_arm.rmdl", < 4165.817, -27978.02, 23388.73 >, < 0, -179.991, 0.0001 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/industrial/security_fence_post.rmdl", < 4165.018, -27979.02, 23288.73 >, < -0.0001, -89.991, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 4628.141, -27622.06, 23092.9 >, < 0.0001, 179.9935, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 2119, -7131, 18065.6 >, < 0, 0.0001, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1254.921, 11279.01, 26066.89 >, < -0.0123, -0.0114, 179.9718 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 3089.924, 10931.13, 15302.33 >, < 0, 89.9959, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_bott.rmdl", < 3088.463, 11608.43, 14078.91 >, < 0, 89.9932, 0 >, false, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_03.rmdl", < 1833.788, -25594.3, 21327.72 >, < 0, 0, 90.0001 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 2783.938, -28034.9, 24275.43 >, < 0, 90.0105, 0 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 2069.951, 12653.21, 29759.24 >, < 0, 179.9699, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1140.881, 11014.32, 25171.84 >, < 0, -90.0019, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_large_liquid_tank_01.rmdl", < 3446.848, -27631.83, 22012.5 >, < 0, 89.9935, -0.0001 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 2264.399, -7146, 18386.2 >, < 0, -90, 0 >, false, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/floating_village/lagoon_window_metal_shutters_open_80x128.rmdl", < 4136.171, -27301.5, 22935.1 >, < 0, 89.9935, -0.0001 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 2461.981, -27228.64, 22265.26 >, < -0.0001, 89.9999, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1376.113, 11592.81, 26871.7 >, < 0, -90.008, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 3209.887, 11724.2, 15317.7 >, < 0, 89.992, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 1942.999, 14561.5, 31714 >, < 0, -90.0067, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_64_01.rmdl", < 1152.379, 10924.32, 25172.84 >, < 0, -180, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 1609.695, -22246.01, 19263.45 >, < -0.0001, -89.9904, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 1491.542, 10031.63, 19113.35 >, < 0, 90.0323, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 1926, 13382.5, 31373 >, < 0, -90.0067, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1376.895, 11014.32, 25171.84 >, < 0, 90.0163, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 3089.932, 11746.16, 15338.44 >, < -0.0123, -179.9974, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 2131.872, 10059.9, 18112.35 >, < 0, -179.9678, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1508.66, 10177.58, 19738.37 >, < -0.0123, 90.0006, 179.9718 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 1256.076, 13008.87, 27888.33 >, < 0, -90.0041, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 1256.032, 11177.42, 27473.6 >, < 0, 89.9956, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 2387.84, 10108.69, 18112.35 >, < 0, -89.968, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 3088.508, 12423.47, 14205.91 >, < -0.0123, -180, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 1937.961, 13683.49, 29967.33 >, < 0, -90.0041, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/zipline_arm.rmdl", < 5487.986, -27998.12, 25552.73 >, < 0, -179.9997, 0 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1937.994, 12876.49, 31206.7 >, < -0.0123, 0.0026, 179.9718 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 3442.283, -27999.63, 22326 >, < 0, -90.0066, 0.0001 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 1815.115, 12849.1, 29759 >, < 0, -0.0298, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < 1942.999, 14753.9, 31714 >, < 0, -90.0067, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1136.113, 11592.8, 26489.8 >, < 0, -90.008, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_64_01.rmdl", < 1392.157, 10582.32, 24072.31 >, < 0, -180, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1602.925, 9420.159, 20231.44 >, < -0.0123, -179.9994, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1723.318, 10062.47, 18716.99 >, < 0, 179.976, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/floating_village/lagoon_window_metal_shutters_open_80x128.rmdl", < 4136.171, -27301.5, 22935.1 >, < 0, 89.9935, -0.0001 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 3088.463, 11608.43, 14294.91 >, < 0, 89.9932, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/floating_village/lagoon_window_metal_shutters_open_80x128.rmdl", < 3359.975, -28070.32, 22423.2 >, < 0, 89.9935, -0.0001 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 1327.579, 10249.97, 23039 >, < 0, -165.057, 45.0001 >, true, 250, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1136.113, 12215.8, 27903.7 >, < 0, -90.008, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 1255.129, 12094.05, 25441.85 >, < 0, -90.0182, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/zipline_arm.rmdl", < 4936.179, -29153.67, 29061.73 >, < 0, -89.9997, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 3273.872, -27505.27, 22829.93 >, < -44.9999, -45.0001, 0 >, true, 250, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1383.249, 10618.95, 23077.8 >, < 0, -90.0221, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 2688.549, 10669.64, 17113.26 >, < 0, -179.9976, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 1724.734, 9659.033, 20114.35 >, < 0, -89.968, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/wall_city_barred_concrete_192_01.rmdl", < 1510.636, 11240.32, 26282.23 >, < 15.011, 90.0073, -89.991 >, false, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 1262.912, 9580.598, 22614.72 >, < 0, 89.9815, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/floating_village/lagoon_window_metal_shutters_open_80x128.rmdl", < 4628.348, -27555.06, 23270.1 >, < 90, 89.9935, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1358.156, 10672.32, 24071.31 >, < 0, -90.0019, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 1608.996, -23635.42, 19327.73 >, < 0.0001, -179.9894, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 5313.953, -29161.89, 27425.73 >, < 0, 89.9935, -0.0001 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/floating_village/lagoon_window_metal_shutters_open_80x128.rmdl", < 3288.883, -27999.41, 22423.2 >, < -0.0001, -0.0065, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 1139.253, 10357.35, 23238.25 >, < 0, 89.9885, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1486.694, 10057.62, 18953.8 >, < 0, -0.01, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 1633.826, 10792.68, 17321.33 >, < 0, -0.0042, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1599.991, 10271.79, 21711.37 >, < -0.0123, 0.0225, 179.9718 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 2969.887, 11022.19, 16323.73 >, < 0, 89.992, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 1724.841, 9451.693, 20114.35 >, < 0, -89.968, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 2071.023, 12885.15, 29759.26 >, < 0, 0.0027, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 3089.932, 11044.16, 16218.47 >, < -0.0123, -179.9974, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 2468.6, 10669.72, 17113 >, < 0, 89.9702, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 1267.811, 10965.74, 26320.83 >, < -30, -90.0117, 0 >, true, 250, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 1791.023, 12885.15, 29759.26 >, < 0, 0.0027, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 1937.468, 13052.06, 31294.42 >, < -45, -89.9993, 0 >, true, 250, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 2244.925, -6841.8, 18121.8 >, < -90, -90, 0 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 3089.924, 10931.13, 15095.33 >, < 0, 89.9959, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1480.028, 10293.71, 21368.79 >, < 0, -89.9882, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 3200.94, -28032.89, 23984.73 >, < 0, -89.9895, 0 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_03.rmdl", < 2188.695, -27094.53, 22061.73 >, < 0, 180, 179.9999 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1720.028, 10293.81, 21368.79 >, < 0, -89.9882, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 5306.953, -29864.89, 28159.73 >, < 0, -179.9997, 45 >, true, 250, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 900.2136, -19284.14, 17609.33 >, < 90, 0.0104, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/industrial/zipline_arm.rmdl", < 2001.064, 14861.29, 32661.93 >, < 0, 90.002, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 1611.159, -24675.79, 19346.65 >, < -0.0001, -0.0001, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 2432.544, 10645.63, 17113.26 >, < 0, 90.0026, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 1256.076, 13008.87, 27681.33 >, < 0, -90.0041, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 1789.655, 12504.47, 28717.26 >, < 0, -89.9973, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1602.925, 9420.159, 20612.84 >, < -0.0123, -179.9994, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1435.66, 10576.22, 22445.36 >, < 0, -0.0242, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 693.6223, 10177.61, 19113.33 >, < 0, -0.0061, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/floating_village/lagoon_window_metal_shutters_open_80x128.rmdl", < 4136.188, -27159.71, 22935.1 >, < 0, -90.0065, 0.0001 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 2265.887, 9262.122, 18112.33 >, < 0, 89.9938, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 1262.912, 9580.598, 22821.91 >, < 0, 89.9815, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/wall_city_barred_concrete_192_01.rmdl", < 1129.354, 11240.32, 26282.23 >, < -15.0114, -90, -89.9915 >, false, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1256.091, 11570.79, 27141.2 >, < -0.0123, 0.0026, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 1133.037, 11954.15, 27680.26 >, < 0, 90.0025, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 1395.309, 10613.29, 23238.25 >, < 0, -0.0114, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < 2603.483, -27224.84, 22225.26 >, < -90, -0.0001, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_64_01.rmdl", < 1128.287, 11317.33, 26068.31 >, < 0.0015, -179.9999, -0.0096 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1486.694, 10057.62, 19335.7 >, < 0, -0.01, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_top.rmdl", < 1937.961, 13691.49, 31208.2 >, < 0, -89.9917, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/zipline_arm.rmdl", < 5482.339, -29189.68, 27192.73 >, < 0, 0.0004, 0 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 3205.027, 11258.83, 15702.87 >, < 0, -90.022, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/floating_village/lagoon_window_metal_shutters_open_80x128.rmdl", < 4151.479, -27230.61, 23015.1 >, < 89.9802, 179.9934, 0 >, false, 50000, -1, 1 ) )
    ClipInvisibleNoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/firstgen/firstgen_pipe_256_goldfoil_01.rmdl", < 3521.953, -28098.9, 25424.73 >, < 90, -179.9997, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 1387.96, 11978.21, 27680.24 >, < 0, 179.9699, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 2265.924, 10077.16, 18229.44 >, < -0.0123, -179.9994, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1256.091, 11570.79, 26885.8 >, < -0.0123, 0.0026, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/zipline_arm.rmdl", < 5256.179, -29762.67, 27786.73 >, < 0, -89.9996, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 1299.977, 12309.66, 28361.22 >, < -33.334, -104.7952, -40.0151 >, true, 250, -1, 1 )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 2686, -28034, 25005.83 >, < -30, -179.9997, 0 >, true, 250, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 1133.037, 11538.49, 26648.26 >, < 0, 90.0025, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1472.197, 10937.01, 24966.37 >, < -0.0123, -0.0114, 179.9718 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 1937.961, 13691.49, 30588.33 >, < 0, -90.0041, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_fuel_tower_pill_tank_med_01.rmdl", < 1608.995, -24234.42, 19566.73 >, < -0.0001, 0.0107, 180 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 756.9253, 12357.47, 28303.31 >, < 0, -0.0044, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1508.66, 10177.58, 19484.37 >, < -0.0123, 90.0006, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1263.198, 10597.01, 23480.44 >, < -0.0123, -0.0114, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1480.028, 10293.71, 20986.89 >, < 0, -89.9882, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 2280.638, 10785.74, 17831.36 >, < -9.6883, 170.6572, -30.4798 >, true, 250, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/floating_village/lagoon_window_metal_shutters_open_80x128.rmdl", < 4230.679, -27230.62, 23005.9 >, < 89.9802, 179.9934, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 5528.359, -28053.9, 25753.73 >, < 0, -89.9997, 0 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 3089.932, 11044.16, 16472.4 >, < -0.0123, -179.9974, 179.9718 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 1133.037, 12161.49, 27680.26 >, < 0, 90.0025, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1476.159, 10718.32, 24267.31 >, < 0, -0.0076, 0.0026 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 3088.508, 12423.47, 14459.84 >, < -0.0123, -180, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1216.379, 10924.32, 25045.84 >, < 0, -180, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_fuel_tower_pill_tank_med_01.rmdl", < 1608.995, -24234.42, 19422.73 >, < 0.0001, -179.9894, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 1527.465, 10310.6, 19113.09 >, < 0, 0.0267, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 924.0052, -19219, 17768.83 >, < 0, 0.0104, 45 >, true, 250, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 1471.912, 9920.599, 24133.6 >, < 0, 89.9815, 0 >, false, 50000, -1, 1 ) )
    ClipInvisibleNoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/firstgen/firstgen_pipe_256_goldfoil_01.rmdl", < 975, -22088.9, 19285.6 >, < -90, 0, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1140.973, 11356.17, 26250.84 >, < 0, 89.978, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1256.091, 11570.79, 26759.8 >, < -0.0123, 0.0026, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 1255.945, 12385.87, 27268.18 >, < 0, -89.9913, -179.9926 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 3212.963, 11076.51, 16100.28 >, < 0, -89.9975, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_64_01.rmdl", < 1358.066, 10704.25, 24231.23 >, < -89.972, 90.085, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1376.113, 12215.81, 27903.7 >, < 0, -90.008, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 1256.032, 11177.42, 27266.31 >, < 0, 89.9956, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/floating_village/lagoon_window_metal_shutters_open_80x128.rmdl", < 3375.283, -27999.42, 22503.2 >, < 89.9802, 179.9934, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 922.5289, -22074.6, 17930.37 >, < 0, -179.9899, 0 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 2426.893, 10912.71, 16954.8 >, < 0, -0.0081, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 1469.823, 9634.841, 20114.34 >, < 0, -0.0006, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 1748.872, 9403.041, 20114.35 >, < 0, -179.9678, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 2924.964, -28034.89, 23613.73 >, < 0, 90.0104, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1254.921, 11279.01, 25684.96 >, < -0.0123, -0.0114, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 1256.032, 10554.42, 26441.6 >, < 0, 89.9956, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1937.994, 12876.49, 30952.7 >, < -0.0123, 0.0026, 179.9718 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 1815.029, 12836.49, 29759.26 >, < 0, 90.0025, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1795.307, 12237.39, 28558.8 >, < 0, 179.992, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 1938.035, 11852.49, 29345.31 >, < 0, 89.9955, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1723.373, 10302.47, 18716.99 >, < 0, 179.976, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/floating_village/lagoon_window_metal_shutters_open_80x128.rmdl", < 3058.578, -27634.98, 22238.8 >, < 89.9802, 89.9935, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1263.198, 10597.01, 23862.37 >, < -0.0123, -0.0114, 179.9718 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 418.0095, -19070, 15525.73 >, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1136.113, 11592.8, 26871.7 >, < 0, -90.008, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 2057.993, 12890.5, 29600.8 >, < 0, -90.008, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 1731.904, 10057.23, 21087.24 >, < 0, 179.9897, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 1476.919, 10239.42, 21087.25 >, < 0, 90.0223, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 2142.583, -26967.44, 22061.76 >, < -0.0001, 89.9999, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_03.rmdl", < 1310.536, 11131.35, 26215.28 >, < -90, -0.0414, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 3089.932, 11044.16, 16726.4 >, < -0.0123, -179.9974, 179.9718 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 1469.905, 9438.964, 20114.09 >, < 0, 90.0267, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1457.597, 10456.17, 22659.84 >, < -0.0123, 89.9865, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 1937.961, 13683.49, 30379.18 >, < 0, -89.9913, -179.9926 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1773.295, 12357.41, 29082.7 >, < -0.0123, -89.9974, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 921.6422, -19349.23, 17528.23 >, < -90, -89.9998, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 1602.997, 10436.57, 19906.6 >, < 0, -90.0065, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 3205.027, 11960.83, 14696.84 >, < 0, -90.022, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/floating_village/lagoon_window_metal_shutters_open_80x128.rmdl", < 4628.358, -27468.66, 23190.1 >, < 0, -90.0064, 0.0001 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 2468.612, 10924.58, 17113 >, < 0, -0.0029, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_03.rmdl", < 2142.583, -26823.64, 21829.73 >, < 0, 0, 90.0001 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 1902.257, 12371.42, 29455.82 >, < -21.2104, -157.6825, 32.4343 >, true, 250, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/zipline_arm.rmdl", < 6603.6, -29080.13, 26614.73 >, < 0, -179.9997, 0 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 1724.682, 9634.961, 20114.34 >, < 0, -89.9737, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/floating_village/lagoon_window_metal_shutters_open_80x128.rmdl", < 3359.991, -27928.52, 22423.2 >, < 0, -90.0065, 0.0001 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < 1705.383, -26697.64, 21814.76 >, < -90, -0.0001, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/zipline_arm.rmdl", < 4923.179, -29153.67, 28545.73 >, < 0, -89.9996, 0 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1478.028, 9634.872, 19717.99 >, < 0, -90.0241, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1352.248, 10959, 24568.84 >, < 0, -90.0221, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 1262.912, 9580.598, 23029.6 >, < 0, 89.9815, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 2265.924, 10077.16, 18737.37 >, < -0.0123, -179.9994, 179.9718 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 4218.479, -27230.81, 22837.9 >, < 0, -90.0066, 0.0001 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 949.1958, -19329.45, 16038 >, < 0, -89.9827, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/industrial/zipline_arm.rmdl", < 974.6069, -22088.58, 19495.98 >, < 0, 38.9681, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/security_fence_post.rmdl", < 974.6, -22087.3, 19196.1 >, < 0, 128.9681, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1773.295, 12357.41, 28954.8 >, < -0.0123, -89.9974, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_64_01.rmdl", < 1344.379, 10924.32, 24917.84 >, < 0, -180, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 1723.342, 10310.68, 19113.34 >, < 0, -90.0005, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < 1977.282, -26697.64, 21814.76 >, < -90, -0.0001, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1352.248, 10959, 24181.8 >, < 0, -90.0221, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1484.97, 10057.09, 20690.84 >, < 0, 89.9978, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1602.925, 9420.159, 20485.37 >, < -0.0123, -179.9994, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 2664.477, 10669.7, 17113.24 >, < 0, 179.9967, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 1533.65, 12480.46, 28717.26 >, < 0, 0.0025, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 642.5591, 10456.41, 22368.33 >, < 0, -0.0203, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 2226.4, 9923.173, 18860.8 >, < 0, 59.9987, -30 >, true, 250, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 642.5591, 10456.28, 22678.6 >, < 0, -0.0074, -179.9926 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 924.3086, -20089.25, 16582 >, < 0, -179.9899, 0 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/floating_village/lagoon_window_metal_shutters_open_80x128.rmdl", < 2987.689, -27540.48, 22168 >, < -0.0001, -0.0064, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 2965.027, 11960.87, 14696.84 >, < 0, -90.022, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 1599.716, 11086.83, 21293.33 >, < 0, -89.9843, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 2783.931, -28034.9, 24856.33 >, < 0, 90.0105, 0 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1263.198, 10597.01, 23354.44 >, < -0.0123, -0.0114, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 2145.878, 10055.19, 17952.8 >, < 0, 89.99, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1457.597, 10456.17, 22786.37 >, < -0.0123, 89.9865, 179.9718 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 3835.177, -27638.97, 22580.9 >, < -0.0001, -0.0065, 0 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 693.6223, 10177.61, 19320.33 >, < 0, -0.0061, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 1139.323, 10381.42, 23238.24 >, < 0, 89.9828, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 1476.386, 10589.1, 22162 >, < 0, -0.019, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 1347.323, 10722.42, 24341.36 >, < 0, 89.9828, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 2265.924, 10077.16, 18483.37 >, < -0.0123, -179.9994, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 3212.877, 11765.9, 15094 >, < 0, 179.9702, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 1440.241, 10310.16, 22162.25 >, < 0, 89.9865, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/floating_village/lagoon_window_metal_shutters_open_80x128.rmdl", < 2987.689, -27540.48, 22168 >, < -0.0001, -0.0064, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 2069.972, 12849.09, 29759 >, < 0, -90.0029, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1358.156, 10672.32, 23945.31 >, < 0, -90.0019, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 2448.864, 10792.67, 17231.44 >, < -0.0123, 90.0026, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 2132.823, 10291.84, 18112.34 >, < 0, -0.0006, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 923.9951, -20159.81, 16739.32 >, < 0, -179.9899, 45 >, true, 250, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 1512.234, -24311.5, 20001.33 >, < 0, 0.0101, 0 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 2558.165, -27211.7, 21946.23 >, < 90, -89.9893, 0 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 3465.274, 10792.63, 16906.6 >, < 0, 179.9955, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 1311, -22132.4, 18394.39 >, < -30, 0, 0 >, true, 250, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 900.2136, -19284.14, 17306.83 >, < 90, 0.0104, 0 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1254.921, 11279.01, 25558.96 >, < -0.0123, -0.0114, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 1963.986, -25880.51, 21523.73 >, < 90, -89.9893, 0 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1602.925, 9420.159, 20357.44 >, < -0.0123, -179.9994, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 3208.463, 12401.5, 14321.41 >, < 0, 89.9894, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1388.05, 10382.27, 22841.84 >, < 0, 89.9639, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 5302.953, -29288.89, 28225.73 >, < 0, 0.0003, 0 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1496.158, 10473.32, 23755.31 >, < 0, -180, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 1602.181, 10722.35, 24341.36 >, < 0, 179.9559, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/zipline_arm.rmdl", < 5358.737, -29834.92, 27528.73 >, < 0, 90.0004, 0 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 1600.307, 9255.383, 20671.31 >, < 0, 90.0154, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1722.879, 9398.192, 20336.7 >, < 0, 89.9899, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_03.rmdl", < 1216.035, 11131.35, 26375.21 >, < 89.9802, -0.0414, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1718.028, 9634.816, 19717.99 >, < 0, -90.0241, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1258.884, 10938.39, 25361.76 >, < -0.0076, 0, -89.9929 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 1316.529, -22074.6, 18216.3 >, < 0, -179.9899, 0 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 3089.968, 12762.57, 14680.31 >, < 0, -90.0045, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_64_01.rmdl", < 1615.089, 10582.23, 24232.25 >, < 90, 179.9197, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1508.66, 10177.58, 19230.44 >, < -0.0123, 90.0006, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 1603.309, 10954.29, 24341.37 >, < 0, -0.0114, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1472.197, 10937.01, 24584.44 >, < -0.0123, -0.0114, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 1476.99, 10033.08, 21087.25 >, < 0, 90.0223, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 2958.04, 11961.79, 15094.25 >, < 0, -0.0301, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 3089.968, 12060.57, 15686.34 >, < 0, -90.0045, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 3212.898, 11259.78, 16100.27 >, < 0, -90.0032, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 1930.142, -24547.33, 19842.87 >, < -36.396, -47.4896, 10.04 >, true, 250, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 4813.953, -28042.9, 25449.73 >, < 0, 179.9935, -0.0001 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 2588.374, 12357.42, 28718.33 >, < 0, 179.9959, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 2663.525, 10677.57, 16715.84 >, < 0, 179.9779, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 1133.102, 11355.22, 26648.24 >, < 0, 89.9968, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_64_01.rmdl", < 1584.157, 10582.32, 24072.31 >, < 0, -180, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 2588.374, 12357.55, 29337.18 >, < 0, -179.9913, -179.9926 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 3212.963, 11778.51, 15094.26 >, < 0, -89.9975, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1795.298, 12477.39, 28940.7 >, < 0, 179.992, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 2969.887, 11724.19, 15317.7 >, < 0, 89.992, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 3089.932, 11044.16, 16344.47 >, < -0.0123, -179.9974, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 1471.912, 9920.599, 23925.31 >, < 0, 89.9815, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 2381.027, 10291.82, 17715.99 >, < 0, -90.0241, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1358.156, 10672.32, 23817.31 >, < 0, -90.0019, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1594.171, 10672.32, 23817.31 >, < 0, 90.0163, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_corner_concrete_64_02.rmdl", < 1624.078, 10526.32, 23945.31 >, < 0, -45.0037, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 1610.996, -23505.42, 19263.73 >, < -0.0001, -0.0001, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1380.973, 11979.13, 27282.84 >, < 0, 89.978, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/industrial/zipline_arm.rmdl", < 2221.801, -6772.4, 18361.9 >, < 0, 89.9999, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/security_fence_post.rmdl", < 2220.801, -6771.6, 18111.9 >, < 0, 179.9999, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/floating_village/lagoon_window_metal_shutters_open_80x128.rmdl", < 3454.483, -27999.43, 22503.2 >, < 89.9802, 179.9934, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 4628.141, -27622.06, 23092.9 >, < 0.0001, 179.9935, 0 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1376.895, 11014.32, 25045.84 >, < 0, 90.0163, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1457.597, 10456.17, 22404.44 >, < -0.0123, 89.9865, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 1440.32, 10590.16, 22162.25 >, < 0, 89.9865, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 1442.308, 10420.9, 22849.4 >, < 0, 3.741, 45.0001 >, true, 250, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1136.113, 12215.8, 27521.8 >, < 0, -90.008, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1241.08, 10815.32, 25238.84 >, < 0, -180, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1937.994, 12868.49, 29870.8 >, < -0.0123, 0.0026, 179.9718 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 2119, -7131, 18214.6 >, < 0, 0.0001, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1795.298, 12477.39, 28558.8 >, < 0, 179.992, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1134.972, 11301, 25670.84 >, < 0, -90.0221, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 900.2136, -19284.14, 17004.93 >, < 90, 0.0104, 0 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 1472.405, 11752.05, 24341.33 >, < 0, -90.0182, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 1731.857, 10253.1, 21087 >, < 0, -89.983, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1722.879, 9398.192, 19954.8 >, < 0, 89.9899, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1823.003, 12654.49, 29361.84 >, < 0, 89.978, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 918.4382, -21197.66, 17890.73 >, < 0, -179.9893, 0.0001 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/industrial/zipline_arm.rmdl", < 1976.002, -25882.58, 21887.9 >, < 0, 119.9999, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/security_fence_post.rmdl", < 1974.736, -25882.38, 21587.9 >, < 0, -150.0001, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/floating_village/lagoon_window_metal_shutters_open_80x128.rmdl", < 4699.25, -27539.77, 23190.1 >, < 0.0001, 179.9937, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1599.991, 10271.79, 21584.84 >, < -0.0123, 0.0225, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 1109.031, 11587.15, 26648.26 >, < 0, 0.0027, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 1133.123, 12174.1, 27680 >, < 0, -0.0298, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 1752.582, -26828.53, 21854.73 >, < 0, 180, 179.9999 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 3089.924, 10229.13, 16101.35 >, < 0, 89.9959, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1508.66, 10177.58, 19356.44 >, < -0.0123, 90.0006, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 3236.969, 11729.84, 15094.26 >, < 0, -179.9973, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1254.921, 11279.01, 25940.36 >, < -0.0123, -0.0114, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 417.5244, -19509.52, 15237 >, < 0, -180, 0 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_64_01.rmdl", < 1344.379, 10924.32, 25045.84 >, < 0, -180, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 2387.681, 10291.96, 18112.34 >, < 0, -89.9737, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1256.091, 12193.79, 27917.8 >, < -0.0123, 0.0026, 179.9718 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < 1739, -22853.02, 20033.73 >, < -90, -0.0001, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 1753.588, 12225.52, 28717 >, < 0, 179.9971, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1599.991, 10271.79, 21329.44 >, < -0.0123, 0.0225, 179.9718 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 3077.828, 10863.34, 16814.38 >, < 11.7196, 113.1219, -30.7068 >, true, 250, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1724.97, 10057.13, 20690.84 >, < 0, 89.9978, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 1098.31, 11296.36, 25441.24 >, < 0, -0.0114, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 1969.036, -6360.1, 18065.6 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 1286.634, 10662.16, 23970.1 >, < 45, -0.0117, 0 >, true, 250, -1, 1 )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 1420.301, 10145.2, 19865.1 >, < 0, 25.7901, 60.0001 >, true, 250, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 1387.98, 12174.09, 27680 >, < 0, -90.0029, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_64_01.rmdl", < 1417.216, 11317.33, 26228.28 >, < 90, -179.9903, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1773.295, 12357.41, 28828.8 >, < -0.0123, -89.9974, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1599.991, 10271.79, 21203.44 >, < -0.0123, 0.0225, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1435.66, 10576.22, 22050.32 >, < 0, -0.0242, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 2426.902, 10672.71, 16954.8 >, < 0, -0.0081, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 1174.042, 10896.76, 25227.87 >, < -45, -90.0117, 0 >, true, 250, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1374.972, 11300.95, 25670.84 >, < 0, -90.0221, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 1122.324, 11064.42, 25441.23 >, < 0, 89.9828, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1143.249, 10619, 23077.8 >, < 0, -90.0221, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 922.5289, -22074.6, 19148 >, < 0, -179.9899, 0 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 3212.898, 11961.78, 15094.25 >, < 0, -90.0032, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1611.158, 10722.27, 23945.84 >, < 0, 89.9639, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1773.295, 12357.41, 29336.7 >, < -0.0123, -89.9974, 179.9718 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 2426.893, 10912.71, 17336.7 >, < 0, -0.0081, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 3088.508, 12423.47, 14331.91 >, < -0.0123, -180, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 2057.993, 12898.5, 30428.8 >, < 0, -90.008, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 2448.864, 10792.67, 17357.44 >, < -0.0123, 90.0026, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_64_01.rmdl", < 1097.353, 11317.33, 26228.23 >, < -90, 179.9905, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_64_01.rmdl", < 1385.328, 11317.33, 26068.31 >, < 0.0392, -179.9999, -0.0096 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 1477.046, 10057.15, 21087.24 >, < 0, 90.0167, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 1389.031, 11587.15, 26648.26 >, < 0, 0.0027, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 2474.007, 10455.85, 21953.6 >, < 0, 179.9794, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 1937.961, 13691.49, 31207.18 >, < 0, -89.9913, -179.9926 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/floating_village/lagoon_window_metal_shutters_open_80x128.rmdl", < 3058.578, -27634.98, 22248 >, < 89.9802, 89.9935, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 3209.887, 11022.2, 16323.73 >, < 0, 89.992, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_03.rmdl", < 1310.534, 11131.37, 26375.28 >, < -90, -0.0414, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_top.rmdl", < 1255.958, 13008.49, 28301.2 >, < 0, -89.9917, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 2265.887, 9262.122, 18319.33 >, < 0, 89.9938, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 2411.872, 10060.04, 18112.35 >, < 0, -179.9678, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 4218.479, -27230.81, 22837.9 >, < 0, -90.0066, 0.0001 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1263.198, 10597.01, 23735.84 >, < -0.0123, -0.0114, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 1254.998, 12094.05, 25959.12 >, < 0, -90.0053, -179.9926 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 3465.274, 10792.63, 16699.31 >, < 0, 179.9955, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 1753.6, 12480.38, 28717 >, < 0, -90.0298, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 1931.964, -26684.5, 21535.73 >, < 90, -89.9893, 0 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/floating_village/lagoon_window_metal_shutters_open_80x128.rmdl", < 4151.479, -27230.61, 23015.1 >, < 89.9802, 179.9934, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 1347.252, 10698.35, 24341.37 >, < 0, 89.9885, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 1311, -22132.4, 19003.73 >, < -30, 0, 0 >, true, 250, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_64_01.rmdl", < 1594.272, 10728.25, 24231.25 >, < 90, -90.1031, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 1672.263, 10589.02, 22162.24 >, < 0, -90.0463, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1592.248, 10958.95, 24181.8 >, < 0, -90.0221, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1140.881, 11014.32, 25045.84 >, < 0, -90.0019, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 1527.585, 10055.74, 19113.09 >, < 0, 89.9998, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1486.693, 10297.62, 18953.8 >, < 0, -0.01, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 642.5591, 10456.41, 22161.33 >, < 0, -0.0203, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/floating_village/lagoon_window_metal_shutters_open_80x128.rmdl", < 3058.587, -27555.78, 22248 >, < 89.9802, 89.9935, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 2958.02, 11063.91, 16100.03 >, < 0, 89.9971, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 1459.334, 11004.17, 25070.8 >, < -45, -0.0117, 0 >, true, 250, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/floating_village/lagoon_window_metal_shutters_open_80x128.rmdl", < 3058.597, -27469.38, 22168 >, < 0, -90.0064, 0.0001 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < 2460.983, -27101.64, 22225.26 >, < -90, -90.0001, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 918.2183, -20558.66, 17890.73 >, < 0, -179.9893, 0.0001 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 1963.986, -25003.3, 20956.93 >, < 0.0001, -89.9893, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < 2267.198, -7298.924, 18066 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1496.158, 10473.32, 24138.31 >, < 0, -180, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 3208.463, 12401.5, 13939.51 >, < 0, 89.9894, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1817.993, 12890.49, 29600.8 >, < 0, -90.008, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 2958.04, 11259.79, 16100.27 >, < 0, -0.0301, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/industrial/zipline_arm.rmdl", < 1939.17, 15771.3, 32384.93 >, < 0, -90.0067, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 2448.864, 10792.67, 17612.84 >, < -0.0123, 90.0026, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1472.197, 10937.01, 24712.37 >, < -0.0123, -0.0114, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 3089.968, 12762.57, 14887.6 >, < 0, -90.0045, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 2969.887, 11724.19, 14935.8 >, < 0, 89.992, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 1139.303, 10563.69, 23238.25 >, < 0, 89.9885, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 1254.636, 10262.6, 25027.31 >, < 0, 89.9815, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 6722.953, -29135.9, 26958.73 >, < 0, -89.9997, 30 >, true, 250, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 1747.534, 10055.77, 19113.35 >, < 0, -179.9679, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_03.rmdl", < 1833.787, -26048.6, 21629.73 >, < 0, 0, -89.9999 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_top.rmdl", < 1937.961, 13683.49, 30380.2 >, < 0, -89.9917, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_corner_concrete_64_02.rmdl", < 1108.164, 10868.34, 25045.84 >, < 0, 134.9828, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 1724.762, 9439.084, 20114.09 >, < 0, 179.9997, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 1435.6, 10336.22, 22445.36 >, < 0, -0.0242, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 1445.884, -25149.2, 20732.66 >, < 45, 0, 0 >, true, 250, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1472.197, 10937.01, 24458.44 >, < -0.0123, -0.0114, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 1378.31, 11296.29, 25441.24 >, < 0, -0.0114, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < 1484, -22853.02, 19010.73 >, < 90, -0.0001, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_drill_01_support_02.rmdl", < 3209.887, 11022.2, 15941.82 >, < 0, 89.992, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/floating_village/lagoon_window_metal_shutters_open_80x128.rmdl", < 4230.679, -27230.62, 23015.1 >, < 89.9802, 179.9934, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1937.994, 12876.49, 31080.2 >, < -0.0123, 0.0026, 179.9718 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 921.6422, -19349.23, 17225.73 >, < -90, -89.9998, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/floating_village/lagoon_window_metal_shutters_open_80x128.rmdl", < 3905.868, -27721.28, 22678.1 >, < 0.0001, 179.9936, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/industrial/zipline_arm.rmdl", < 1891.17, 15771.31, 31829.93 >, < 0, -90.0067, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < 2664.489, 10924.56, 17113.24 >, < 0, -90.0302, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 1609.001, -22373.02, 19327.73 >, < 0.0001, -179.9894, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 1539.881, 10554.68, 24139.17 >, < 45, 89.9883, 0 >, true, 250, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 1969.036, -6360.1, 18214.6 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/floating_village/lagoon_window_metal_shutters_open_80x128.rmdl", < 3454.483, -27999.43, 22494 >, < 89.9802, 179.9934, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 1874.562, -24558.37, 19705.73 >, < 0, -89.9899, 0 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_64_01.rmdl", < 1120.449, 10924.23, 25332.76 >, < -90, -179.9196, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/floating_village/lagoon_window_metal_shutters_open_80x128.rmdl", < 3129.489, -27540.49, 22168 >, < 0.0001, 179.9937, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/wall_city_panel_concrete_192_01.rmdl", < 1240.995, 10815.32, 24855.84 >, < 0, -180, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 1263.406, 11412.04, 23444.33 >, < 0, -90.0182, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < 1347.303, 10904.69, 24341.37 >, < 0, 89.9885, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/industrial/zipline_arm.rmdl", < 5584.738, -29129.52, 26061.73 >, < 0, 90.0004, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 1944.047, 14715.3, 32885.13 >, < 0, -90.0135, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/floating_village/lagoon_window_metal_shutters_open_80x128.rmdl", < 3375.283, -27999.42, 22503.2 >, < 89.9802, 179.9934, 0 >, false, 50000, -1, 1 ) )

    foreach ( entity ent in NoClimbArray ) ent.kv.solid = 3
    foreach ( entity ent in ClipInvisibleNoGrappleNoClimbArray )
    {
        ent.MakeInvisible()
        ent.kv.solid = 3
        ent.kv.CollisionGroup = TRACE_COLLISION_GROUP_PLAYER
        ent.kv.contents = CONTENTS_SOLID | CONTENTS_NOGRAPPLE
    }

    // VerticalZipLines
    MapEditor_CreateZiplineFromUnity( < 1937.998, 12758.49, 30519.12 >, < 0, 86.9107, 0 >, < 1937.998, 12758.49, 29572.52 >, < 0, 86.9107, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 1472.165, 10826.61, 25100.12 >, < 0, 86.8967, 0 >, < 1472.165, 10826.61, 24171.12 >, < 0, 86.8967, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 922, -22029.7, 18096.1 >, < 0, -89.9899, 0 >, < 922, -22029.7, 17946.1 >, < 0, -89.9899, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 924.6229, -19337.24, 16885.73 >, < 0, 90.0104, 0 >, < 924.6229, -19337.24, 16735.73 >, < 0, 90.0104, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 1931.5, -25457.56, 21580.73 >, < 0, -116, 0 >, < 1931.5, -25457.56, 21280.73 >, < 0, -116, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 3834.966, -27742.77, 22753.4 >, < 0, 89.9935, -0.0001 >, < 3834.966, -27742.77, 22553.4 >, < 0, 89.9935, -0.0001 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 3090.063, 11154.56, 16860.15 >, < 0, -93.0893, 0 >, < 3090.063, 11154.56, 15913.55 >, < 0, -93.0893, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 3834.966, -27742.77, 22753.4 >, < 0, 89.9935, -0.0001 >, < 3834.966, -27742.77, 22553.4 >, < 0, 89.9935, -0.0001 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 3338.483, -27999.42, 22498.5 >, < -0.0001, -0.0066, 0 >, < 3338.483, -27999.42, 22298.5 >, < -0.0001, -0.0066, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 3088.573, 12531.71, 14845.91 >, < 0, -93.0968, 0 >, < 3088.573, 12531.71, 14174.91 >, < 0, -93.0968, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 1619.055, 10177.6, 19872.12 >, < 0, 176.9087, 0 >, < 1619.055, 10177.6, 18943.12 >, < 0, 176.9087, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 4114.68, -27230.6, 23010.4 >, < -0.0001, -0.0066, 0 >, < 4114.68, -27230.6, 22810.4 >, < -0.0001, -0.0066, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 1937.998, 12766.49, 31347.12 >, < 0, 86.9107, 0 >, < 1937.998, 12766.49, 30649.32 >, < 0, 86.9107, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 918.1851, -19860.66, 18146.73 >, < -0.0001, -89.9892, 0 >, < 918.1848, -19860.66, 17896.73 >, < -0.0001, -89.9892, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 1263.166, 10486.61, 23996.12 >, < 0, 86.8967, 0 >, < 1263.166, 10486.61, 23067.12 >, < 0, 86.8967, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 1255.167, 11168.61, 26200.65 >, < 0, 86.8967, 0 >, < 1255.167, 11168.61, 25271.65 >, < 0, 86.8967, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 1903.487, -25003.83, 21212.65 >, < 0, 0.0107, 0.0001 >, < 1903.487, -25003.83, 20962.65 >, < 0, 0.0107, 0.0001 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 924.623, -19337.24, 17488.73 >, < 0, 90.0104, 0 >, < 924.623, -19337.24, 17338.73 >, < 0, 90.0104, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 936.9081, -22048.33, 18874.18 >, < 0, -116, 0 >, < 936.9081, -22048.33, 18551.58 >, < 0, -116, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 924.623, -19337.24, 17186.83 >, < 0, 90.0104, 0 >, < 924.623, -19337.24, 17036.83 >, < 0, 90.0104, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 3115.94, -28033.89, 24150.73 >, < 0, 0.0105, 0 >, < 3115.94, -28033.89, 24000.73 >, < 0, 0.0105, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 2497.686, -27231.67, 22217.16 >, < 0, 0.0107, 0.0001 >, < 2497.686, -27231.67, 21967.16 >, < 0, 0.0107, 0.0001 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 1567.995, 10456.01, 22920.12 >, < 0, 176.8945, 0 >, < 1567.995, 10456.01, 21991.12 >, < 0, 176.8945, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 1299.633, -22049.21, 18552.18 >, < 0, -116, 0 >, < 1299.633, -22049.21, 18229.58 >, < 0, -116, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 1299.633, -22049.21, 19178.28 >, < 0, -116, 0 >, < 1299.633, -22049.21, 18855.68 >, < 0, -116, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 3338.483, -27999.42, 22498.5 >, < -0.0001, -0.0066, 0 >, < 3338.483, -27999.42, 22298.5 >, < -0.0001, -0.0066, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 2178.285, -26970.47, 22013.66 >, < 0, 0.0107, 0.0001 >, < 2178.285, -26970.47, 21763.66 >, < 0, 0.0107, 0.0001 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 4628.353, -27518.26, 23265.4 >, < 0, -90.0065, 0.0001 >, < 4628.353, -27518.26, 23065.4 >, < 0, -90.0065, 0.0001 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 917.208, -20498.66, 18146.73 >, < -0.0001, -89.9892, 0 >, < 917.2078, -20498.66, 17896.73 >, < -0.0001, -89.9892, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 2867.931, -28033.89, 25022.33 >, < 0, -179.9895, 0 >, < 2867.931, -28033.89, 24872.33 >, < 0, -179.9895, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 418.5149, -19159.49, 15664.73 >, < 0, 90, 0 >, < 418.5154, -19159.49, 15524.73 >, < 0, 90, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 864.5972, -19329.99, 16203.73 >, < 0, 0.0173, 0 >, < 864.5977, -19329.99, 16053.73 >, < 0, 0.0173, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 1662.942, 12357.56, 29477.12 >, < 0, -3.0893, 0 >, < 1662.942, 12357.56, 28530.52 >, < 0, -3.0893, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 2559.258, 10792.54, 17873.12 >, < 0, 176.9106, 0 >, < 2559.258, 10792.54, 16926.52 >, < 0, 176.9106, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 924.623, -19337.24, 17791.23 >, < 0, 90.0104, 0 >, < 924.623, -19337.24, 17641.23 >, < 0, 90.0104, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 1255.938, 12083.44, 28440.12 >, < 0, 86.9107, 0 >, < 1255.938, 12083.44, 27493.52 >, < 0, 86.9107, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 3090.063, 11856.56, 15854.13 >, < 0, -93.0893, 0 >, < 3090.063, 11856.56, 14907.53 >, < 0, -93.0893, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 1610.963, -24720.9, 19576.46 >, < 0, -89.9899, 0 >, < 1610.963, -24720.9, 19426.46 >, < 0, -89.9899, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 1871.486, -26704.46, 21806.66 >, < 0, 0.0107, 0.0001 >, < 1871.486, -26704.46, 21556.66 >, < 0, 0.0107, 0.0001 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 423.6871, -19409.23, 16051.93 >, < 0, -89.9902, 0 >, < 423.6876, -19409.23, 15836.93 >, < 0, -89.9902, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 2896.212, -28034.04, 23860.5 >, < 0, -179.9896, 0 >, < 2896.212, -28034.04, 23710.5 >, < 0, -179.9896, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 5528.955, -29080.89, 26401.73 >, < 0, -89.9997, 0 >, < 5528.951, -29080.88, 26261.73 >, < 0, -89.9997, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 1238.863, -24689.6, 20462.06 >, < 0, -179.9899, 0 >, < 1238.863, -24689.6, 20312.06 >, < 0, -179.9899, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 936.9081, -22048.33, 19483.98 >, < 0, -116, 0 >, < 936.9081, -22048.33, 19161.38 >, < 0, -116, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 1599.871, 10161.41, 21845.12 >, < 0, 86.9305, 0 >, < 1599.871, 10161.41, 20916.12 >, < 0, 86.9305, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 923.7798, -20004.65, 16747.73 >, < 0, -89.9899, 0 >, < 923.7798, -20004.65, 16597.73 >, < 0, -89.9899, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 5302.953, -29378.89, 28364.73 >, < 0, 90.0003, 0 >, < 5302.953, -29378.89, 28224.73 >, < 0, 90.0003, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 1789.963, -24558.9, 19871.46 >, < 0, 0.0101, 0 >, < 1789.963, -24558.9, 19721.46 >, < 0, 0.0101, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 6553.969, -29136.9, 26954.73 >, < 0, 0.0003, 0 >, < 6553.965, -29136.89, 26814.73 >, < 0, 0.0003, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 2867.938, -28033.89, 24441.43 >, < 0, -179.9895, 0 >, < 2867.938, -28033.89, 24291.43 >, < 0, -179.9895, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 2265.902, 10187.55, 18871.12 >, < 0, -93.0913, 0 >, < 2265.902, 10187.55, 17942.12 >, < 0, -93.0913, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 923.6333, -19723.05, 16450.73 >, < 0, -89.9899, 0 >, < 923.6338, -19723.05, 16300.73 >, < 0, -89.9899, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 918.4279, -21137.66, 18146.73 >, < -0.0001, -89.9892, 0 >, < 918.4274, -21137.66, 17896.73 >, < -0.0001, -89.9892, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 4114.68, -27230.6, 23010.4 >, < -0.0001, -0.0066, 0 >, < 4114.68, -27230.6, 22810.4 >, < -0.0001, -0.0066, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 418.5084, -19408.49, 15376 >, < 0, 90, 0 >, < 418.5089, -19408.49, 15114.9 >, < 0, 90, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 5438.355, -28054.89, 25892.73 >, < 0, 0.0003, 0 >, < 5438.352, -28054.89, 25752.73 >, < 0, 0.0003, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 2166.801, -6776.4, 18349.9 >, < 0, 0, 0 >, < 2166.801, -6776.4, 18096.6 >, < 0, 0, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 1512.763, -24396.1, 20167.06 >, < 0, 90.0101, 0 >, < 1512.763, -24396.1, 20017.06 >, < 0, 90.0101, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 1930.37, -25913.54, 21875.9 >, < 0, -116, 0 >, < 1930.37, -25913.54, 21575.9 >, < 0, -116, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 5302.953, -29743.89, 28138.73 >, < 0, -89.9997, 0 >, < 5302.953, -29743.89, 27998.73 >, < 0, -89.9997, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 3058.591, -27518.98, 22243.3 >, < 0, -90.0065, 0.0001 >, < 3058.591, -27518.98, 21925.1 >, < 0, -90.0065, 0.0001 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 1608.001, -22313.02, 19583.73 >, < 0, -89.9894, 0.0001 >, < 1608.001, -22313.02, 19333.73 >, < 0, -89.9894, 0.0001 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 1608.996, -23575.42, 19583.73 >, < 0, -89.9894, 0.0001 >, < 1608.996, -23575.42, 19333.73 >, < 0, -89.9894, 0.0001 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 1417.163, -24983.2, 20757.36 >, < 0, -89.99, 0 >, < 1417.163, -24983.2, 20607.36 >, < 0, -89.99, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 1255.938, 11460.44, 27408.12 >, < 0, 86.9107, 0 >, < 1255.938, 11460.44, 26335.42 >, < 0, 86.9107, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 4628.353, -27518.26, 23265.4 >, < 0, -90.0065, 0.0001 >, < 4628.353, -27518.26, 23065.4 >, < 0, -90.0065, 0.0001 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 1602.903, 9530.554, 20873.12 >, < 0, -93.0914, 0 >, < 1602.903, 9530.554, 19944.12 >, < 0, -93.0914, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 3115.743, -28033.89, 24732.23 >, < 0, 0.0104, 0 >, < 3115.743, -28033.89, 24582.23 >, < 0, 0.0104, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )

    // NonVerticalZipLines
    MapEditor_CreateZiplineFromUnity( < 4970.736, -29229.92, 28791.73 >, < 0, -179.9996, 0 >, < 4966.154, -28659.29, 28803.73 >, < 0, -179.9996, 0 >, false, -1, 1, 2, 1, 1, 0, 1, 150, 150, false, 0, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 1926.001, 13473.69, 31476.29 >, < 0, -179.9912, 0 >, < 1925.909, 14405.69, 31476.29 >, < 0, -179.9912, 0 >, false, -1, 1, 2, 1, 1, 0, 1, 150, 150, false, 0, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 1946.064, 14857.29, 32095.93 >, < 0, -179.998, 0 >, < 1946.263, 15791.5, 32095.85 >, < 0, -179.998, 0 >, false, -1, 1, 2, 1, 1, 0, 1, 150, 150, false, 0, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 3516.145, -28044.9, 25211.73 >, < -0.0001, 90.0091, 0 >, < 4448.944, -28043.8, 25211.88 >, < -0.0001, 90.0091, 0 >, false, -1, 1, 2, 1, 1, 0, 1, 150, 150, false, 0, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 4169.826, -28033.02, 23376.73 >, < -0.0001, -89.991, 0 >, < 3290.026, -28034.11, 23376.88 >, < -0.0001, -89.991, 0 >, false, -1, 1, 2, 1, 1, 0, 1, 150, 150, false, 0, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 5491.986, -28053.12, 25540.73 >, < 0, -89.9997, 0 >, < 4921.359, -28057.7, 25552.73 >, < 0, -89.9997, 0 >, false, -1, 1, 2, 1, 1, 0, 1, 150, 150, false, 0, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 4991.179, -29149.67, 29049.73 >, < 0, 0.0003, 0 >, < 4995.761, -29720.3, 29061.73 >, < 0, 0.0003, 0 >, false, -1, 1, 2, 1, 1, 0, 1, 150, 150, false, 0, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 1946.064, 14857.29, 32649.93 >, < 0, -179.998, 0 >, < 1946.263, 15791.5, 32649.85 >, < 0, -179.998, 0 >, false, -1, 1, 2, 1, 1, 0, 1, 150, 150, false, 0, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 5478.339, -29134.68, 27180.73 >, < 0, 90.0004, 0 >, < 6064.566, -29130.09, 27192.73 >, < 0, 90.0004, 0 >, false, -1, 1, 2, 1, 1, 0, 1, 150, 150, false, 0, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 5311.179, -29758.67, 27774.73 >, < 0, 0.0004, 0 >, < 5315.762, -30329.3, 27786.73 >, < 0, 0.0004, 0 >, false, -1, 1, 2, 1, 1, 0, 1, 150, 150, false, 0, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 6607.6, -29135.13, 26602.73 >, < 0, -89.9997, 0 >, < 6036.973, -29139.71, 26614.73 >, < 0, -89.9997, 0 >, false, -1, 1, 2, 1, 1, 0, 1, 150, 150, false, 0, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 4978.179, -29149.67, 28533.73 >, < 0, 0.0004, 0 >, < 4982.762, -29720.3, 28545.73 >, < 0, 0.0004, 0 >, false, -1, 1, 2, 1, 1, 0, 1, 150, 150, false, 0, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 5303.737, -29838.93, 27516.73 >, < 0, -179.9996, 0 >, < 5299.154, -29268.29, 27528.73 >, < 0, -179.9996, 0 >, false, -1, 1, 2, 1, 1, 0, 1, 150, 150, false, 0, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 1994.171, 15775.3, 32372.93 >, < 0, -0.0067, 0 >, < 1993.831, 14841.09, 32372.85 >, < 0, -0.0067, 0 >, false, -1, 1, 2, 1, 1, 0, 1, 150, 150, false, 0, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 1946.171, 15775.3, 31817.93 >, < 0, -0.0067, 0 >, < 1945.831, 14841.09, 31817.85 >, < 0, -0.0067, 0 >, false, -1, 1, 2, 1, 1, 0, 1, 150, 150, false, 0, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 5529.738, -29133.52, 26049.73 >, < 0, -179.9996, 0 >, < 5525.155, -28562.9, 26061.73 >, < 0, -179.9996, 0 >, false, -1, 1, 2, 1, 1, 0, 1, 150, 150, false, 0, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )

    // Buttons
    AddCallback_OnUseEntity( CreateFRButton(< 1939.141, 14610.98, 32901.26 >, < 0, 179.9865, 0 >, "%use% Finish Timer/Go to Lobby"), void function(entity panel, entity user, int input)
    {
int reset = 0
file.cp_table[user] <- file.first_cp
if (user.GetPersistentVarAsInt("gen") != reset) {
    user.SetPersistentVar("xp", Time() - user.GetPersistentVarAsInt("gen"))
    int seconds = user.GetPersistentVarAsInt("xp")
    if (seconds > 59) {
        int minutes = seconds / 60
        int realseconds = seconds - (minutes * 60)

        Message(user, "Your Final Time: " + minutes + ":" + realseconds)
        user.SetPersistentVar("gen", reset)
    } else {
        Message(user, "Your Final Time: " + seconds + " seconds")
        user.SetPersistentVar("gen", reset)
    }
} else {
    Message(user, "Congratulations!", "You finished the Easy course!")
    user.SetOrigin(file.first_cp)
    user.SetVelocity(<0,0,0>)
}
    })

    AddCallback_OnUseEntity( CreateFRButton(< 2084.399, -6322.4, 18066 >, < 0, -0.0001, 0 >, "%use% Go to Easy Course"), void function(entity panel, entity user, int input)
    {
if (IsValid(user)) {
    if(user.IsPlayer() && user.GetPhysics() != MOVETYPE_NOCLIP) {
        user.SetOrigin(< 3088.624, 12585.7, 14129.37 >
)
        user.SetVelocity(< 0, 0, 0> )
        user.SetPersistentVar("gen", 0)
    }
}
    })

    AddCallback_OnUseEntity( CreateFRButton(< 511.0371, -19286.22, 15076.09 >, < 0, 0, 0 >, "%use% Start/Stop Timer"), void function(entity panel, entity user, int input)
    {
if (user.GetPersistentVar("gen") == 0) {
    array<ItemFlavor> characters = GetAllCharacters()
    CharacterSelect_AssignCharacter(ToEHI(user), characters[8])
    user.TakeOffhandWeapon(OFFHAND_TACTICAL)
    user.TakeOffhandWeapon(OFFHAND_ULTIMATE)
    user.SetPersistentVar( "gen", Time())
    Message(user, "Timer Started!")
} else {
    user.SetPersistentVar("gen", 0)
    Message(user, "Timer Stopped!")
}
    })

    AddCallback_OnUseEntity( CreateFRButton(< 3208.55, 12481.08, 14079.62 >, < 0, -90, 0 >, "%use% Start/Stop Timer"), void function(entity panel, entity user, int input)
    {
if (user.GetPersistentVar("gen") == 0) {
    array<ItemFlavor> characters = GetAllCharacters()
    CharacterSelect_AssignCharacter(ToEHI(user), characters[8])
    user.TakeOffhandWeapon(OFFHAND_TACTICAL)
    user.TakeOffhandWeapon(OFFHAND_ULTIMATE)
    user.SetPersistentVar( "gen", Time())
    Message(user, "Timer Started!")
} else {
    user.SetPersistentVar("gen", 0)
    Message(user, "Timer Stopped!")
}
    })

    AddCallback_OnUseEntity( CreateFRButton(< 5001.053, -29432.39, 29325.23 >, < 0, 179.9934, -0.0001 >, "%use% Finish Timer/Go to Lobby"), void function(entity panel, entity user, int input)
    {
int reset = 0
file.cp_table[user] <- file.first_cp
if (user.GetPersistentVarAsInt("gen") != reset) {
    user.SetPersistentVar("xp", Time() - user.GetPersistentVarAsInt("gen"))
    int seconds = user.GetPersistentVarAsInt("xp")
    if (seconds > 59) {
        int minutes = seconds / 60
        int realseconds = seconds - (minutes * 60)

        Message(user, "Your Final Time: " + minutes + ":" + realseconds)
        user.SetPersistentVar("gen", reset)
    } else {
        Message(user, "Your Final Time: " + seconds + " seconds")
        user.SetPersistentVar("gen", reset)
    }
} else {
    Message(user, "Congratulations!", "You finished the Hard course!")
    user.SetOrigin(file.first_cp)
    user.SetVelocity(<0,0,0>)
}
    })

    AddCallback_OnUseEntity( CreateFRButton(< 2094.399, -7247.7, 18386 >, < 0, 180, 0 >, "%use% Go to Hard Course"), void function(entity panel, entity user, int input)
    {
if (IsValid(user)) {
    if(user.IsPlayer() && user.GetPhysics() != MOVETYPE_NOCLIP) {
        user.SetOrigin(< 423.4482, -19355.29, 15129 >)
        user.SetVelocity(< 0, 0, 0> )
        user.SetPersistentVar("gen", 0)
    }
}

    })

    AddCallback_OnUseEntity( CreateFRButton(< 2963.737, 12481.08, 14079.62 >, < 0, 90, 0 >, "%use% Go to Lobby"), void function(entity panel, entity user, int input)
    {
if (IsValid(user)) {
    if(user.IsPlayer() && user.GetPhysics() != MOVETYPE_NOCLIP) {
        user.SetOrigin(file.first_cp)
        user.SetVelocity(< 0, 0, 0> )
        user.SetPersistentVar("gen", 0)
    }
}
    })

    AddCallback_OnUseEntity( CreateFRButton(< 337.3955, -19286.2, 15076.09 >, < 0, 0, 0 >, "%use% Go to Lobby"), void function(entity panel, entity user, int input)
    {
if (IsValid(user)) {
    if(user.IsPlayer() && user.GetPhysics() != MOVETYPE_NOCLIP) {
        user.SetOrigin(file.first_cp)
        user.SetVelocity(< 0, 0, 0> )
        user.SetPersistentVar("gen", 0)
    }
}
    })


    // Triggers
    entity trigger_0 = MapEditor_CreateTrigger( < 4470.99, -27922.42, 22155.73 >, < -0.0001, -179.9997, 0 >, 1000, 50, false )
    trigger_0.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    mantlemap_reset_doors() 
    }
}
    })
    DispatchSpawn( trigger_0 )
    entity trigger_1 = MapEditor_CreateTrigger( < 3357.989, -28157.42, 23175.07 >, < -0.0001, -179.9997, 0 >, 1000, 50, false )
    trigger_1.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    mantlemap_reset_doors() 
    }
}
    })
    DispatchSpawn( trigger_1 )
    entity trigger_2 = MapEditor_CreateTrigger( < 1602.513, 10965, 27159.07 >, < 0, 89.9932, 0 >, 500, 50, false )
    trigger_2.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_2 )
    entity trigger_3 = MapEditor_CreateTrigger( < 2290.413, 12362.9, 29170.77 >, < 0, -0.0067, 0 >, 500, 50, false )
    trigger_3.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_3 )
    entity trigger_4 = MapEditor_CreateTrigger( < 1936.513, 9816, 19447.97 >, < 0, 89.9932, 0 >, 341.65, 50, false )
    trigger_4.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_4 )
    entity trigger_5 = MapEditor_CreateTrigger( < 922.5293, -21970.6, 17937.23 >, < 0, -179.9899, 0 >, 100, 50, false )
    trigger_5.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        int reset = 0

        if (ent in file.cp_table) {
            if (file.cp_table[ent] != < 922.5293, -21970.6, 17937.23 >) {
                file.cp_table[ent] <- < 922.5293, -21970.6, 17937.23 >

                if (ent.GetPersistentVarAsInt("gen") != reset) {
                    ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                    int seconds = ent.GetPersistentVarAsInt("xp")

                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)

                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                    } else {
                        int minutes = seconds

                        Message(ent, "Current Time: " + seconds + " seconds ")
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 922.5293, -21970.6, 17937.23 >

            if (ent.GetPersistentVarAsInt("gen") != reset) {
                ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                int seconds = ent.GetPersistentVarAsInt("xp")

                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)

                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                } else {
                    int minutes = seconds

                    Message(ent, "Current Time: " + seconds + " seconds ")
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_5 )
    entity trigger_6 = MapEditor_CreateTrigger( < 2161.513, 10434, 22593.87 >, < 0, 89.9932, 0 >, 500, 50, false )
    trigger_6.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_6 )
    entity trigger_7 = MapEditor_CreateTrigger( < 2402.504, 12348, 30285.27 >, < 0, 0, 0 >, 500, 50, false )
    trigger_7.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_7 )
    entity trigger_8 = MapEditor_CreateTrigger( < 1610.515, -22242.55, 19324.64 >, < -0.0001, -0.0001, 0 >, 100, 50, false )
    trigger_8.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        int reset = 0

        if (ent in file.cp_table) {
            if (file.cp_table[ent] != < 1610.515, -22242.55, 19324.64 >) {
                file.cp_table[ent] <- < 1610.515, -22242.55, 19324.64 >

                if (ent.GetPersistentVarAsInt("gen") != reset) {
                    ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                    int seconds = ent.GetPersistentVarAsInt("xp")

                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)

                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                    } else {
                        int minutes = seconds

                        Message(ent, "Current Time: " + seconds + " seconds ")
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 1610.515, -22242.55, 19324.64 >

            if (ent.GetPersistentVarAsInt("gen") != reset) {
                ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                int seconds = ent.GetPersistentVarAsInt("xp")

                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)

                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                } else {
                    int minutes = seconds

                    Message(ent, "Current Time: " + seconds + " seconds ")
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_8 )
    entity trigger_9 = MapEditor_CreateTrigger( < 1413.513, 12539, 13749.27 >, < 0, 0, 0 >, 7500, 50, false )
    trigger_9.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_9 )
    entity trigger_10 = MapEditor_CreateTrigger( < 3089.513, 11152, 16116.12 >, < 0, 89.9932, 0 >, 43.65, 50, false )
    trigger_10.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        int reset = 0

        if (ent in file.cp_table) {
            if (file.cp_table[ent] != < 3089.513, 11066, 16129.52 >) {
                file.cp_table[ent] <- < 3089.513, 11066, 16129.52 >

                if (ent.GetPersistentVarAsInt("gen") != reset) {
                    ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                    int seconds = ent.GetPersistentVarAsInt("xp")

                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)

                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                    } else {
                        int minutes = seconds

                        Message(ent, "Current Time: " + seconds + " seconds ")
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 3089.513, 11066, 16129.52 >

            if (ent.GetPersistentVarAsInt("gen") != reset) {
                ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                int seconds = ent.GetPersistentVarAsInt("xp")

                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)

                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                } else {
                    int minutes = seconds

                    Message(ent, "Current Time: " + seconds + " seconds ")
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_10 )
    entity trigger_11 = MapEditor_CreateTrigger( < 1943.575, 14758.1, 31781.8 >, < 0, -90.0208, 0 >, 125, 50, false )
    trigger_11.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        int reset = 0

        if (ent in file.cp_table) {
            if (file.cp_table[ent] != < 1943.575, 14758.1, 31781.8 >) {
                file.cp_table[ent] <- < 1943.575, 14758.1, 31781.8 >

                if (ent.GetPersistentVarAsInt("gen") != reset) {
                    ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                    int seconds = ent.GetPersistentVarAsInt("xp")

                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)

                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                    } else {
                        int minutes = seconds

                        Message(ent, "Current Time: " + seconds + " seconds ")
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 1943.575, 14758.1, 31781.8 >

            if (ent.GetPersistentVarAsInt("gen") != reset) {
                ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                int seconds = ent.GetPersistentVarAsInt("xp")

                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)

                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                } else {
                    int minutes = seconds

                    Message(ent, "Current Time: " + seconds + " seconds ")
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_11 )
    entity trigger_12 = MapEditor_CreateTrigger( < 1624.295, 12250.03, 30285.27 >, < 0, 0, 0 >, 500, 50, false )
    trigger_12.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_12 )
    entity trigger_13 = MapEditor_CreateTrigger( < 1835.787, -26701.4, 21555.3 >, < -0.0001, 89.9999, 0 >, 100, 50, false )
    trigger_13.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        int reset = 0

        if (ent in file.cp_table) {
            if (file.cp_table[ent] != < 1835.787, -26701.4, 21555.3 >) {
                file.cp_table[ent] <- < 1835.787, -26701.4, 21555.3 >

                if (ent.GetPersistentVarAsInt("gen") != reset) {
                    ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                    int seconds = ent.GetPersistentVarAsInt("xp")

                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)

                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                    } else {
                        int minutes = seconds

                        Message(ent, "Current Time: " + seconds + " seconds ")
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 1835.787, -26701.4, 21555.3 >

            if (ent.GetPersistentVarAsInt("gen") != reset) {
                ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                int seconds = ent.GetPersistentVarAsInt("xp")

                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)

                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                } else {
                    int minutes = seconds

                    Message(ent, "Current Time: " + seconds + " seconds ")
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_13 )
    entity trigger_14 = MapEditor_CreateTrigger( < 1827.417, 11718.9, 29170.77 >, < 0, -0.0067, 0 >, 500, 50, false )
    trigger_14.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_14 )
    entity trigger_15 = MapEditor_CreateTrigger( < 924.5127, 10434, 22593.87 >, < 0, 89.9932, 0 >, 500, 50, false )
    trigger_15.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_15 )
    entity trigger_16 = MapEditor_CreateTrigger( < 1665.5, 12357.01, 28733.1 >, < 0, 179.9932, 0 >, 43.65, 50, false )
    trigger_16.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        int reset = 0

        if (ent in file.cp_table) {
            if (file.cp_table[ent] != < 1751.5, 12357.01, 28746.5 >) {
                file.cp_table[ent] <- < 1751.5, 12357.01, 28746.5 >

                if (ent.GetPersistentVarAsInt("gen") != reset) {
                    ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                    int seconds = ent.GetPersistentVarAsInt("xp")

                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)

                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                    } else {
                        int minutes = seconds

                        Message(ent, "Current Time: " + seconds + " seconds ")
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 1751.5, 12357.01, 28746.5 >

            if (ent.GetPersistentVarAsInt("gen") != reset) {
                ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                int seconds = ent.GetPersistentVarAsInt("xp")

                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)

                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                } else {
                    int minutes = seconds

                    Message(ent, "Current Time: " + seconds + " seconds ")
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_16 )
    entity trigger_17 = MapEditor_CreateTrigger( < 1914.513, 12274, 28186.27 >, < 0, 89.9932, 0 >, 500, 50, false )
    trigger_17.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_17 )
    entity trigger_18 = MapEditor_CreateTrigger( < 2779.513, 10345, 17599.27 >, < 0, 89.9932, 0 >, 350, 50, false )
    trigger_18.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_18 )
    entity trigger_19 = MapEditor_CreateTrigger( < 1832.5, -19529.49, 15854 >, < 0, -89.9904, 0 >, 1000, 10, false )
    trigger_19.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_19 )
    entity trigger_20 = MapEditor_CreateTrigger( < 1266.513, 13755, 26483.27 >, < 0, 89.9932, 0 >, 1000, 50, false )
    trigger_20.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_20 )
    entity trigger_21 = MapEditor_CreateTrigger( < 607.5127, 11653, 27159.07 >, < 0, 89.9932, 0 >, 500, 50, false )
    trigger_21.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_21 )
    entity trigger_22 = MapEditor_CreateTrigger( < 1908.809, 13414.83, 30285.27 >, < 0, 0, 0 >, 500, 50, false )
    trigger_22.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_22 )
    entity trigger_23 = MapEditor_CreateTrigger( < 1680.513, 9570, 21510.27 >, < 0, 89.9932, 0 >, 500, 50, false )
    trigger_23.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_23 )
    entity trigger_24 = MapEditor_CreateTrigger( < 3083.513, 12968, 14628.37 >, < 0, 89.9932, 0 >, 350, 50, false )
    trigger_24.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_24 )
    entity trigger_25 = MapEditor_CreateTrigger( < 2490.513, 10803, 16529.27 >, < 0, 89.9932, 0 >, 500, 50, false )
    trigger_25.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_25 )
    entity trigger_26 = MapEditor_CreateTrigger( < 1606.513, 11586, 28186.27 >, < 0, 89.9932, 0 >, 500, 50, false )
    trigger_26.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_26 )
    entity trigger_27 = MapEditor_CreateTrigger( < 2260.513, 10244, 21510.27 >, < 0, 89.9932, 0 >, 500, 50, false )
    trigger_27.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_27 )
    entity trigger_28 = MapEditor_CreateTrigger( < 3414.953, -28042.9, 25170.73 >, < 0, 179.9935, -0.0001 >, 100, 50, false )
    trigger_28.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        int reset = 0

        if (ent in file.cp_table) {
            if (file.cp_table[ent] != < 3414.953, -28042.9, 25170.73 >) {
                file.cp_table[ent] <- < 3414.953, -28042.9, 25170.73 >

                if (ent.GetPersistentVarAsInt("gen") != reset) {
                    ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                    int seconds = ent.GetPersistentVarAsInt("xp")

                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)

                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                    } else {
                        int minutes = seconds

                        Message(ent, "Current Time: " + seconds + " seconds ")
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 3414.953, -28042.9, 25170.73 >

            if (ent.GetPersistentVarAsInt("gen") != reset) {
                ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                int seconds = ent.GetPersistentVarAsInt("xp")

                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)

                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                } else {
                    int minutes = seconds

                    Message(ent, "Current Time: " + seconds + " seconds ")
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_28 )
    entity trigger_29 = MapEditor_CreateTrigger( < 6744.07, -29269.57, 26240.07 >, < -0.0001, -179.9997, 0 >, 1000, 50, false )
    trigger_29.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)

    }
}
    })
    DispatchSpawn( trigger_29 )
    entity trigger_30 = MapEditor_CreateTrigger( < 922.5127, 10950, 27159.07 >, < 0, 89.9932, 0 >, 500, 50, false )
    trigger_30.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_30 )
    entity trigger_31 = MapEditor_CreateTrigger( < 4986.078, -30787.57, 28501.07 >, < -0.0001, -179.9997, 0 >, 1000, 50, false )
    trigger_31.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)

    }
}
    })
    DispatchSpawn( trigger_31 )
    entity trigger_32 = MapEditor_CreateTrigger( < 916.4987, -21077.49, 17757 >, < 0.0001, 90.0096, 0 >, 500, 50, false )
    trigger_32.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_32 )
    entity trigger_33 = MapEditor_CreateTrigger( < 2281.413, 9724.1, 18448.07 >, < 0, 89.9932, 0 >, 341.65, 50, false )
    trigger_33.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_33 )
    entity trigger_34 = MapEditor_CreateTrigger( < 1270.513, 12737, 28186.27 >, < 0, 89.9932, 0 >, 500, 50, false )
    trigger_34.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_34 )
    entity trigger_35 = MapEditor_CreateTrigger( < 1139.413, 12026.9, 29170.77 >, < 0, -0.0067, 0 >, 500, 50, false )
    trigger_35.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_35 )
    entity trigger_36 = MapEditor_CreateTrigger( < 2253.513, 9564, 20454.27 >, < 0, 89.9932, 0 >, 500, 50, false )
    trigger_36.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_36 )
    entity trigger_37 = MapEditor_CreateTrigger( < 807.5127, 10938, 24766.67 >, < 0, 89.9932, 0 >, 500, 50, false )
    trigger_37.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_37 )
    entity trigger_38 = MapEditor_CreateTrigger( < 2531.504, 13108, 31098.27 >, < 0, 0, 0 >, 500, 50, false )
    trigger_38.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_38 )
    entity trigger_39 = MapEditor_CreateTrigger( < 1298.071, 12973, 30285.27 >, < 0, 0, 0 >, 500, 50, false )
    trigger_39.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_39 )
    entity trigger_40 = MapEditor_CreateTrigger( < 1616.496, 10178.15, 19128.1 >, < 0, -0.0087, 0 >, 43.65, 50, false )
    trigger_40.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        int reset = 0

        if (ent in file.cp_table) {
            if (file.cp_table[ent] != < 1530.497, 10178.15, 19141.5 >) {
                file.cp_table[ent] <- < 1530.497, 10178.15, 19141.5 >

                if (ent.GetPersistentVarAsInt("gen") != reset) {
                    ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                    int seconds = ent.GetPersistentVarAsInt("xp")

                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)

                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                    } else {
                        int minutes = seconds

                        Message(ent, "Current Time: " + seconds + " seconds ")
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 1530.497, 10178.15, 19141.5 >

            if (ent.GetPersistentVarAsInt("gen") != reset) {
                ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                int seconds = ent.GetPersistentVarAsInt("xp")

                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)

                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                } else {
                    int minutes = seconds

                    Message(ent, "Current Time: " + seconds + " seconds ")
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_40 )
    entity trigger_41 = MapEditor_CreateTrigger( < 1600.42, 10163.96, 21101.1 >, < 0, -89.9869, 0 >, 43.65, 50, false )
    trigger_41.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        int reset = 0

        if (ent in file.cp_table) {
            if (file.cp_table[ent] != < 1600.39, 10249.96, 21114.5 >) {
                file.cp_table[ent] <- < 1600.39, 10249.96, 21114.5 >

                if (ent.GetPersistentVarAsInt("gen") != reset) {
                    ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                    int seconds = ent.GetPersistentVarAsInt("xp")

                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)

                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                    } else {
                        int minutes = seconds

                        Message(ent, "Current Time: " + seconds + " seconds ")
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 1600.39, 10249.96, 21114.5 >

            if (ent.GetPersistentVarAsInt("gen") != reset) {
                ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                int seconds = ent.GetPersistentVarAsInt("xp")

                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)

                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                } else {
                    int minutes = seconds

                    Message(ent, "Current Time: " + seconds + " seconds ")
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_41 )
    entity trigger_42 = MapEditor_CreateTrigger( < 607.5127, 11338, 25855.17 >, < 0, 89.9932, 0 >, 500, 50, false )
    trigger_42.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_42 )
    entity trigger_43 = MapEditor_CreateTrigger( < 3089.987, -29410.42, 29383.73 >, < -0.0001, -179.9997, 0 >, 1589, 50, false )
    trigger_43.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)

    }
}
    })
    DispatchSpawn( trigger_43 )
    entity trigger_44 = MapEditor_CreateTrigger( < 1610.995, -24530.42, 19040.73 >, < -0.0001, -0.0001, 0 >, 1000, 50, false )
    trigger_44.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)

    }
}
    })
    DispatchSpawn( trigger_44 )
    entity trigger_45 = MapEditor_CreateTrigger( < 1588.513, 8878, 20454.27 >, < 0, 89.9932, 0 >, 500, 50, false )
    trigger_45.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_45 )
    entity trigger_46 = MapEditor_CreateTrigger( < 611.5127, 12274, 28186.27 >, < 0, 89.9932, 0 >, 500, 50, false )
    trigger_46.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_46 )
    entity trigger_47 = MapEditor_CreateTrigger( < 1908.809, 13414.83, 31098.27 >, < 0, 0, 0 >, 500, 50, false )
    trigger_47.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_47 )
    entity trigger_48 = MapEditor_CreateTrigger( < 921.6299, -19380.24, 16737 >, < 0, 0.0107, 0 >, 100, 50, false )
    trigger_48.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        int reset = 0

        if (ent in file.cp_table) {
            if (file.cp_table[ent] != < 921.6299, -19380.24, 16737 >) {
                file.cp_table[ent] <- < 921.6299, -19380.24, 16737 >

                if (ent.GetPersistentVarAsInt("gen") != reset) {
                    ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                    int seconds = ent.GetPersistentVarAsInt("xp")

                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)

                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                    } else {
                        int minutes = seconds

                        Message(ent, "Current Time: " + seconds + " seconds ")
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 921.6299, -19380.24, 16737 >

            if (ent.GetPersistentVarAsInt("gen") != reset) {
                ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                int seconds = ent.GetPersistentVarAsInt("xp")

                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)

                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                } else {
                    int minutes = seconds

                    Message(ent, "Current Time: " + seconds + " seconds ")
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_48 )
    entity trigger_49 = MapEditor_CreateTrigger( < 4813.953, -28042.9, 25510.73 >, < 0, 179.9935, -0.0001 >, 100, 50, false )
    trigger_49.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        int reset = 0

        if (ent in file.cp_table) {
            if (file.cp_table[ent] != < 4813.953, -28042.9, 25510.73 >) {
                file.cp_table[ent] <- < 4813.953, -28042.9, 25510.73 >

                if (ent.GetPersistentVarAsInt("gen") != reset) {
                    ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                    int seconds = ent.GetPersistentVarAsInt("xp")

                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)

                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                    } else {
                        int minutes = seconds

                        Message(ent, "Current Time: " + seconds + " seconds ")
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 4813.953, -28042.9, 25510.73 >

            if (ent.GetPersistentVarAsInt("gen") != reset) {
                ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                int seconds = ent.GetPersistentVarAsInt("xp")

                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)

                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                } else {
                    int minutes = seconds

                    Message(ent, "Current Time: " + seconds + " seconds ")
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_49 )
    entity trigger_50 = MapEditor_CreateTrigger( < 3089.513, 12294, 15560.27 >, < 0, 89.9932, 0 >, 341.65, 50, false )
    trigger_50.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_50 )
    entity trigger_51 = MapEditor_CreateTrigger( < 1245.513, 10257, 24766.67 >, < 0, 89.9932, 0 >, 500, 50, false )
    trigger_51.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_51 )
    entity trigger_52 = MapEditor_CreateTrigger( < 6836.988, -29410.43, 29383.73 >, < -0.0001, -179.9997, 0 >, 1589, 50, false )
    trigger_52.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)

    }
}
    })
    DispatchSpawn( trigger_52 )
    entity trigger_53 = MapEditor_CreateTrigger( < 1255.717, 11171.17, 25456.62 >, < 0, -90.0208, 0 >, 43.65, 50, false )
    trigger_53.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        int reset = 0

        if (ent in file.cp_table) {
            if (file.cp_table[ent] != < 1255.738, 11257.17, 25470.02 >) {
                file.cp_table[ent] <- < 1255.738, 11257.17, 25470.02 >

                if (ent.GetPersistentVarAsInt("gen") != reset) {
                    ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                    int seconds = ent.GetPersistentVarAsInt("xp")

                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)

                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                    } else {
                        int minutes = seconds

                        Message(ent, "Current Time: " + seconds + " seconds ")
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 1255.738, 11257.17, 25470.02 >

            if (ent.GetPersistentVarAsInt("gen") != reset) {
                ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                int seconds = ent.GetPersistentVarAsInt("xp")

                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)

                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                } else {
                    int minutes = seconds

                    Message(ent, "Current Time: " + seconds + " seconds ")
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_53 )
    entity trigger_54 = MapEditor_CreateTrigger( < 928.5, -18493.49, 16636 >, < 0, -89.9904, 0 >, 1000, 10, false )
    trigger_54.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_54 )
    entity trigger_55 = MapEditor_CreateTrigger( < 2924.964, -28034.89, 23680.73 >, < 0, 90.0104, 0 >, 100, 50, false )
    trigger_55.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        int reset = 0

        if (ent in file.cp_table) {
            if (file.cp_table[ent] != < 2924.964, -28034.89, 23680.73 >) {
                file.cp_table[ent] <- < 2924.964, -28034.89, 23680.73 >

                if (ent.GetPersistentVarAsInt("gen") != reset) {
                    ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                    int seconds = ent.GetPersistentVarAsInt("xp")

                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)

                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                    } else {
                        int minutes = seconds

                        Message(ent, "Current Time: " + seconds + " seconds ")
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 2924.964, -28034.89, 23680.73 >

            if (ent.GetPersistentVarAsInt("gen") != reset) {
                ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                int seconds = ent.GetPersistentVarAsInt("xp")

                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)

                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                } else {
                    int minutes = seconds

                    Message(ent, "Current Time: " + seconds + " seconds ")
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_55 )
    entity trigger_56 = MapEditor_CreateTrigger( < 1992.513, 10554, 18448.07 >, < 0, 89.9932, 0 >, 341.65, 50, false )
    trigger_56.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_56 )
    entity trigger_57 = MapEditor_CreateTrigger( < 423.458, -19409.19, 15129 >, < 0, -89.9904, 0 >, 100, 50, false )
    trigger_57.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        int reset = 0

        if (ent in file.cp_table) {
            if (file.cp_table[ent] != < 423.4482, -19355.29, 15129 >) {
                file.cp_table[ent] <- < 423.4482, -19355.29, 15129 >

                if (ent.GetPersistentVarAsInt("gen") != reset) {
                    ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                    int seconds = ent.GetPersistentVarAsInt("xp")

                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)

                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                    } else {
                        int minutes = seconds

                        Message(ent, "Current Time: " + seconds + " seconds ")
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 423.4482, -19355.29, 15129 >

            if (ent.GetPersistentVarAsInt("gen") != reset) {
                ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                int seconds = ent.GetPersistentVarAsInt("xp")

                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)

                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                } else {
                    int minutes = seconds

                    Message(ent, "Current Time: " + seconds + " seconds ")
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_57 )
    entity trigger_58 = MapEditor_CreateTrigger( < 2402.504, 12348, 31098.27 >, < 0, 0, 0 >, 500, 50, false )
    trigger_58.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_58 )
    entity trigger_59 = MapEditor_CreateTrigger( < 948.5127, 9514, 20454.27 >, < 0, 89.9932, 0 >, 500, 50, false )
    trigger_59.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_59 )
    entity trigger_60 = MapEditor_CreateTrigger( < 3088.513, 11890, 14628.37 >, < 0, 89.9932, 0 >, 500, 50, false )
    trigger_60.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_60 )
    entity trigger_61 = MapEditor_CreateTrigger( < 2053.513, 11219, 24766.67 >, < 0, 89.9932, 0 >, 500, 50, false )
    trigger_61.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_61 )
    entity trigger_62 = MapEditor_CreateTrigger( < 3066.2, -27525, 21950.53 >, < 0, -180, 0 >, 100, 50, false )
    trigger_62.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        int reset = 0

        if (ent in file.cp_table) {
            if (file.cp_table[ent] != < 3066.2, -27525, 21950.53 >) {
                file.cp_table[ent] <- < 3066.2, -27525, 21950.53 >

                if (ent.GetPersistentVarAsInt("gen") != reset) {
                    ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                    int seconds = ent.GetPersistentVarAsInt("xp")

                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)

                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                    } else {
                        int minutes = seconds

                        Message(ent, "Current Time: " + seconds + " seconds ")
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 3066.2, -27525, 21950.53 >

            if (ent.GetPersistentVarAsInt("gen") != reset) {
                ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                int seconds = ent.GetPersistentVarAsInt("xp")

                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)

                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                } else {
                    int minutes = seconds

                    Message(ent, "Current Time: " + seconds + " seconds ")
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_62 )
    entity trigger_63 = MapEditor_CreateTrigger( < 2587.513, 12497, 14628.37 >, < 0, 89.9932, 0 >, 350, 50, false )
    trigger_63.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_63 )
    entity trigger_64 = MapEditor_CreateTrigger( < 916.4988, -20165.49, 17757 >, < 0.0001, 90.0096, 0 >, 500, 50, false )
    trigger_64.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_64 )
    entity trigger_65 = MapEditor_CreateTrigger( < 1570.513, 11124, 22593.87 >, < 0, 89.9932, 0 >, 500, 50, false )
    trigger_65.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_65 )
    entity trigger_66 = MapEditor_CreateTrigger( < 1427.513, 11118, 23664.87 >, < 0, 89.9932, 0 >, 500, 50, false )
    trigger_66.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_66 )
    entity trigger_67 = MapEditor_CreateTrigger( < 1151.513, 10145, 19447.97 >, < 0, 89.9932, 0 >, 341.65, 50, false )
    trigger_67.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_67 )
    entity trigger_68 = MapEditor_CreateTrigger( < 4986.074, -29269.57, 26914.07 >, < -0.0001, -179.9997, 0 >, 1000, 50, false )
    trigger_68.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)

    }
}
    })
    DispatchSpawn( trigger_68 )
    entity trigger_69 = MapEditor_CreateTrigger( < 1504.513, 9928, 23664.87 >, < 0, 89.9932, 0 >, 500, 50, false )
    trigger_69.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_69 )
    entity trigger_70 = MapEditor_CreateTrigger( < 1827.412, 13021.9, 29170.77 >, < 0, -0.0067, 0 >, 500, 50, false )
    trigger_70.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_70 )
    entity trigger_71 = MapEditor_CreateTrigger( < 5019.984, -31324.42, 29383.73 >, < -0.0001, -179.9997, 0 >, 1589, 50, false )
    trigger_71.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)

    }
}
    })
    DispatchSpawn( trigger_71 )
    entity trigger_72 = MapEditor_CreateTrigger( < 4986.072, -30400.57, 27250.07 >, < -0.0001, -179.9997, 0 >, 1000, 50, false )
    trigger_72.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)

    }
}
    })
    DispatchSpawn( trigger_72 )
    entity trigger_73 = MapEditor_CreateTrigger( < 2567.513, 11299.7, 17599.27 >, < 0, 89.9932, 0 >, 350, 50, false )
    trigger_73.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_73 )
    entity trigger_74 = MapEditor_CreateTrigger( < 1602.353, 9527.995, 20129.1 >, < 0, 89.9912, 0 >, 43.65, 50, false )
    trigger_74.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        int reset = 0

        if (ent in file.cp_table) {
            if (file.cp_table[ent] != < 1602.35, 9441.996, 20142.5 >) {
                file.cp_table[ent] <- < 1602.35, 9441.996, 20142.5 >

                if (ent.GetPersistentVarAsInt("gen") != reset) {
                    ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                    int seconds = ent.GetPersistentVarAsInt("xp")

                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)

                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                    } else {
                        int minutes = seconds

                        Message(ent, "Current Time: " + seconds + " seconds ")
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 1602.35, 9441.996, 20142.5 >

            if (ent.GetPersistentVarAsInt("gen") != reset) {
                ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                int seconds = ent.GetPersistentVarAsInt("xp")

                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)

                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                } else {
                    int minutes = seconds

                    Message(ent, "Current Time: " + seconds + " seconds ")
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_74 )
    entity trigger_75 = MapEditor_CreateTrigger( < 3088.613, 12494.5, 14129.37 >, < 0, 89.9932, 0 >, 147.9, 50, false )
    trigger_75.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        int reset = 0

        if (ent in file.cp_table) {
            if (file.cp_table[ent] != < 3088.624, 12585.7, 14129.37 >) {
                file.cp_table[ent] <- < 3088.624, 12585.7, 14129.37 >

                if (ent.GetPersistentVarAsInt("gen") != reset) {
                    ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                    int seconds = ent.GetPersistentVarAsInt("xp")

                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)

                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                    } else {
                        int minutes = seconds

                        Message(ent, "Current Time: " + seconds + " seconds ")
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 3088.624, 12585.7, 14129.37 >

            if (ent.GetPersistentVarAsInt("gen") != reset) {
                ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                int seconds = ent.GetPersistentVarAsInt("xp")

                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)

                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                } else {
                    int minutes = seconds

                    Message(ent, "Current Time: " + seconds + " seconds ")
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_75 )
    entity trigger_76 = MapEditor_CreateTrigger( < 2313.513, 10316, 17599.27 >, < 0, 89.9932, 0 >, 350, 50, false )
    trigger_76.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_76 )
    entity trigger_77 = MapEditor_CreateTrigger( < 1624.295, 12250.03, 31098.27 >, < 0, 0, 0 >, 500, 50, false )
    trigger_77.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_77 )
    entity trigger_78 = MapEditor_CreateTrigger( < 2675.513, 11390, 16529.27 >, < 0, 89.9932, 0 >, 350, 50, false )
    trigger_78.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_78 )
    entity trigger_79 = MapEditor_CreateTrigger( < 1932.513, 10614, 23664.87 >, < 0, 89.9932, 0 >, 500, 50, false )
    trigger_79.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_79 )
    entity trigger_80 = MapEditor_CreateTrigger( < 1611.159, -24675.79, 19413.03 >, < -0.0001, -0.0001, 0 >, 100, 50, false )
    trigger_80.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        int reset = 0

        if (ent in file.cp_table) {
            if (file.cp_table[ent] != < 1611.159, -24675.79, 19413.03 >) {
                file.cp_table[ent] <- < 1611.159, -24675.79, 19413.03 >

                if (ent.GetPersistentVarAsInt("gen") != reset) {
                    ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                    int seconds = ent.GetPersistentVarAsInt("xp")

                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)

                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                    } else {
                        int minutes = seconds

                        Message(ent, "Current Time: " + seconds + " seconds ")
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 1611.159, -24675.79, 19413.03 >

            if (ent.GetPersistentVarAsInt("gen") != reset) {
                ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                int seconds = ent.GetPersistentVarAsInt("xp")

                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)

                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                } else {
                    int minutes = seconds

                    Message(ent, "Current Time: " + seconds + " seconds ")
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_80 )
    entity trigger_81 = MapEditor_CreateTrigger( < 1640.998, -22661.42, 19018.73 >, < -0.0001, -0.0001, 0 >, 500, 50, false )
    trigger_81.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    mantlemap_reset_doors() 
    }
}
    })
    DispatchSpawn( trigger_81 )
    entity trigger_82 = MapEditor_CreateTrigger( < 1266.513, 11801, 25855.17 >, < 0, 89.9932, 0 >, 500, 50, false )
    trigger_82.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_82 )
    entity trigger_83 = MapEditor_CreateTrigger( < 1613.513, 10133, 20454.27 >, < 0, 89.9932, 0 >, 500, 50, false )
    trigger_83.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_83 )
    entity trigger_84 = MapEditor_CreateTrigger( < 4260.018, -28033.01, 23331.73 >, < -0.0001, -89.9998, 0 >, 100, 50, false )
    trigger_84.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        int reset = 0

        if (ent in file.cp_table) {
            if (file.cp_table[ent] != < 4260.018, -28033.01, 23331.73 >) {
                file.cp_table[ent] <- < 4260.018, -28033.01, 23331.73 >

                if (ent.GetPersistentVarAsInt("gen") != reset) {
                    ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                    int seconds = ent.GetPersistentVarAsInt("xp")

                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)

                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                    } else {
                        int minutes = seconds

                        Message(ent, "Current Time: " + seconds + " seconds ")
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 4260.018, -28033.01, 23331.73 >

            if (ent.GetPersistentVarAsInt("gen") != reset) {
                ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                int seconds = ent.GetPersistentVarAsInt("xp")

                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)

                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                } else {
                    int minutes = seconds

                    Message(ent, "Current Time: " + seconds + " seconds ")
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_84 )
    entity trigger_85 = MapEditor_CreateTrigger( < 1298.071, 12973, 31098.27 >, < 0, 0, 0 >, 500, 50, false )
    trigger_85.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_85 )
    entity trigger_86 = MapEditor_CreateTrigger( < 1263.716, 10489.17, 23252.1 >, < 0, -90.0208, 0 >, 43.65, 50, false )
    trigger_86.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        int reset = 0

        if (ent in file.cp_table) {
            if (file.cp_table[ent] != < 1263.737, 10575.17, 23265.5 >) {
                file.cp_table[ent] <- < 1263.737, 10575.17, 23265.5 >

                if (ent.GetPersistentVarAsInt("gen") != reset) {
                    ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                    int seconds = ent.GetPersistentVarAsInt("xp")

                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)

                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                    } else {
                        int minutes = seconds

                        Message(ent, "Current Time: " + seconds + " seconds ")
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 1263.737, 10575.17, 23265.5 >

            if (ent.GetPersistentVarAsInt("gen") != reset) {
                ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                int seconds = ent.GetPersistentVarAsInt("xp")

                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)

                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                } else {
                    int minutes = seconds

                    Message(ent, "Current Time: " + seconds + " seconds ")
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_86 )
    entity trigger_87 = MapEditor_CreateTrigger( < 2535.504, 13119, 30285.27 >, < 0, 0, 0 >, 500, 50, false )
    trigger_87.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_87 )
    entity trigger_88 = MapEditor_CreateTrigger( < 4986.066, -28004.57, 29184.73 >, < -0.0001, -179.9997, 0 >, 1000, 50, false )
    trigger_88.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)

    }
}
    })
    DispatchSpawn( trigger_88 )
    entity trigger_89 = MapEditor_CreateTrigger( < 4994.953, -29352.89, 29370.73 >, < 0, 89.9935, -0.0001 >, 100, 50, false )
    trigger_89.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        int reset = 0

        if (ent in file.cp_table) {
            if (file.cp_table[ent] != < 4994.953, -29352.89, 29370.73 >) {
                file.cp_table[ent] <- < 4994.953, -29352.89, 29370.73 >

                if (ent.GetPersistentVarAsInt("gen") != reset) {
                    ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                    int seconds = ent.GetPersistentVarAsInt("xp")

                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)

                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                    } else {
                        int minutes = seconds

                        Message(ent, "Current Time: " + seconds + " seconds ")
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 4994.953, -29352.89, 29370.73 >

            if (ent.GetPersistentVarAsInt("gen") != reset) {
                ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                int seconds = ent.GetPersistentVarAsInt("xp")

                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)

                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                } else {
                    int minutes = seconds

                    Message(ent, "Current Time: " + seconds + " seconds ")
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_89 )
    entity trigger_90 = MapEditor_CreateTrigger( < 3592.513, 11850, 15560.27 >, < 0, 89.9932, 0 >, 341.65, 50, false )
    trigger_90.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_90 )
    entity trigger_91 = MapEditor_CreateTrigger( < 679.5127, 10208, 23664.87 >, < 0, 89.9932, 0 >, 500, 50, false )
    trigger_91.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_91 )
    entity trigger_92 = MapEditor_CreateTrigger( < 1386.513, 11492, 24766.67 >, < 0, 89.9932, 0 >, 500, 50, false )
    trigger_92.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_92 )
    entity trigger_93 = MapEditor_CreateTrigger( < 946.5127, 10116, 21510.27 >, < 0, 89.9932, 0 >, 500, 50, false )
    trigger_93.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_93 )
    entity trigger_94 = MapEditor_CreateTrigger( < 1602.513, 10650, 25855.17 >, < 0, 89.9932, 0 >, 500, 50, false )
    trigger_94.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_94 )
    entity trigger_95 = MapEditor_CreateTrigger( < 926.5127, 11571, 28186.27 >, < 0, 89.9932, 0 >, 500, 50, false )
    trigger_95.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_95 )
    entity trigger_96 = MapEditor_CreateTrigger( < 2527.513, 10556, 18448.07 >, < 0, 89.9932, 0 >, 341.65, 50, false )
    trigger_96.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_96 )
    entity trigger_97 = MapEditor_CreateTrigger( < 1266.513, 12360, 26119.27 >, < 0, 89.9932, 0 >, 1000, 50, false )
    trigger_97.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_97 )
    entity trigger_98 = MapEditor_CreateTrigger( < 3089.513, 11394, 15560.27 >, < 0, 89.9932, 0 >, 341.65, 50, false )
    trigger_98.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_98 )
    entity trigger_99 = MapEditor_CreateTrigger( < 1256.487, 11463, 26664.1 >, < 0, -90.0068, 0 >, 43.65, 50, false )
    trigger_99.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        int reset = 0

        if (ent in file.cp_table) {
            if (file.cp_table[ent] != < 1256.487, 11549, 26677.5 >) {
                file.cp_table[ent] <- < 1256.487, 11549, 26677.5 >

                if (ent.GetPersistentVarAsInt("gen") != reset) {
                    ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                    int seconds = ent.GetPersistentVarAsInt("xp")

                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)

                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                    } else {
                        int minutes = seconds

                        Message(ent, "Current Time: " + seconds + " seconds ")
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 1256.487, 11549, 26677.5 >

            if (ent.GetPersistentVarAsInt("gen") != reset) {
                ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                int seconds = ent.GetPersistentVarAsInt("xp")

                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)

                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                } else {
                    int minutes = seconds

                    Message(ent, "Current Time: " + seconds + " seconds ")
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_99 )
    entity trigger_100 = MapEditor_CreateTrigger( < 3008.513, 10799.7, 17599.27 >, < 0, 89.9932, 0 >, 350, 50, false )
    trigger_100.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_100 )
    entity trigger_101 = MapEditor_CreateTrigger( < 1532.513, 9651, 19447.97 >, < 0, 89.9932, 0 >, 341.65, 50, false )
    trigger_101.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_101 )
    entity trigger_102 = MapEditor_CreateTrigger( < 1938.938, 12761.44, 29775.1 >, < 0, -90.0068, 0 >, 43.65, 50, false )
    trigger_102.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        int reset = 0

        if (ent in file.cp_table) {
            if (file.cp_table[ent] != < 1938.938, 12847.44, 29788.5 >) {
                file.cp_table[ent] <- < 1938.938, 12847.44, 29788.5 >

                if (ent.GetPersistentVarAsInt("gen") != reset) {
                    ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                    int seconds = ent.GetPersistentVarAsInt("xp")

                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)

                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                    } else {
                        int minutes = seconds

                        Message(ent, "Current Time: " + seconds + " seconds ")
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 1938.938, 12847.44, 29788.5 >

            if (ent.GetPersistentVarAsInt("gen") != reset) {
                ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                int seconds = ent.GetPersistentVarAsInt("xp")

                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)

                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                } else {
                    int minutes = seconds

                    Message(ent, "Current Time: " + seconds + " seconds ")
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_102 )
    entity trigger_103 = MapEditor_CreateTrigger( < 3598.513, 11175, 16529.27 >, < 0, 89.9932, 0 >, 350, 50, false )
    trigger_103.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_103 )
    entity trigger_104 = MapEditor_CreateTrigger( < 1923.977, 13379.5, 31441.8 >, < 0, -90.0208, 0 >, 125, 50, false )
    trigger_104.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        int reset = 0

        if (ent in file.cp_table) {
            if (file.cp_table[ent] != < 1923.977, 13379.5, 31441.8 >) {
                file.cp_table[ent] <- < 1923.977, 13379.5, 31441.8 >

                if (ent.GetPersistentVarAsInt("gen") != reset) {
                    ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                    int seconds = ent.GetPersistentVarAsInt("xp")

                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)

                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                    } else {
                        int minutes = seconds

                        Message(ent, "Current Time: " + seconds + " seconds ")
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 1923.977, 13379.5, 31441.8 >

            if (ent.GetPersistentVarAsInt("gen") != reset) {
                ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                int seconds = ent.GetPersistentVarAsInt("xp")

                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)

                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                } else {
                    int minutes = seconds

                    Message(ent, "Current Time: " + seconds + " seconds ")
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_104 )
    entity trigger_105 = MapEditor_CreateTrigger( < 1968.513, 10443, 24766.67 >, < 0, 89.9932, 0 >, 500, 50, false )
    trigger_105.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_105 )
    entity trigger_106 = MapEditor_CreateTrigger( < 1860.993, -25746.42, 20182.73 >, < -0.0001, -0.0001, 0 >, 1000, 50, false )
    trigger_106.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)

    }
}
    })
    DispatchSpawn( trigger_106 )
    entity trigger_107 = MapEditor_CreateTrigger( < 1938.938, 12769.44, 30683.92 >, < 0, -90.0068, 0 >, 95.35, 83.8, false )
    trigger_107.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        int reset = 0

        if (ent in file.cp_table) {
            if (file.cp_table[ent] != < 1938.938, 12769.44, 30683.92 >) {
                file.cp_table[ent] <- < 1938.938, 12769.44, 30683.92 >

                if (ent.GetPersistentVarAsInt("gen") != reset) {
                    ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                    int seconds = ent.GetPersistentVarAsInt("xp")

                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)

                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                    } else {
                        int minutes = seconds

                        Message(ent, "Current Time: " + seconds + " seconds ")
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 1938.938, 12769.44, 30683.92 >

            if (ent.GetPersistentVarAsInt("gen") != reset) {
                ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                int seconds = ent.GetPersistentVarAsInt("xp")

                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)

                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                } else {
                    int minutes = seconds

                    Message(ent, "Current Time: " + seconds + " seconds ")
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_107 )
    entity trigger_108 = MapEditor_CreateTrigger( < 3589.513, 12507, 14628.37 >, < 0, 89.9932, 0 >, 350, 50, false )
    trigger_108.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_108 )
    entity trigger_109 = MapEditor_CreateTrigger( < 3078.513, 11598, 16529.27 >, < 0, 89.9932, 0 >, 350, 50, false )
    trigger_109.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_109 )
    entity trigger_110 = MapEditor_CreateTrigger( < 5710.07, -28157.57, 25242.07 >, < -0.0001, -179.9997, 0 >, 1000, 50, false )
    trigger_110.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)

    }
}
    })
    DispatchSpawn( trigger_110 )
    entity trigger_111 = MapEditor_CreateTrigger( < 1908.809, 14213, 31171.27 >, < 0, 0, 0 >, 1000, 50, false )
    trigger_111.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_111 )
    entity trigger_112 = MapEditor_CreateTrigger( < 1579.513, 9785, 22593.87 >, < 0, 89.9932, 0 >, 500, 50, false )
    trigger_112.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_112 )
    entity trigger_113 = MapEditor_CreateTrigger( < 522.5005, -20522.49, 15854 >, < 0, -89.9904, 0 >, 1000, 10, false )
    trigger_113.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_113 )
    entity trigger_114 = MapEditor_CreateTrigger( < 1472.716, 10829.17, 24356.1 >, < 0, -90.0208, 0 >, 43.65, 50, false )
    trigger_114.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        int reset = 0

        if (ent in file.cp_table) {
            if (file.cp_table[ent] != < 1472.737, 10915.17, 24369.5 >) {
                file.cp_table[ent] <- < 1472.737, 10915.17, 24369.5 >

                if (ent.GetPersistentVarAsInt("gen") != reset) {
                    ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                    int seconds = ent.GetPersistentVarAsInt("xp")

                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)

                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                    } else {
                        int minutes = seconds

                        Message(ent, "Current Time: " + seconds + " seconds ")
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 1472.737, 10915.17, 24369.5 >

            if (ent.GetPersistentVarAsInt("gen") != reset) {
                ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                int seconds = ent.GetPersistentVarAsInt("xp")

                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)

                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                } else {
                    int minutes = seconds

                    Message(ent, "Current Time: " + seconds + " seconds ")
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_114 )
    entity trigger_115 = MapEditor_CreateTrigger( < 1565.436, 10456.56, 22176.1 >, < 0, -0.023, 0 >, 43.65, 50, false )
    trigger_115.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        int reset = 0

        if (ent in file.cp_table) {
            if (file.cp_table[ent] != < 1479.437, 10456.58, 22189.5 >) {
                file.cp_table[ent] <- < 1479.437, 10456.58, 22189.5 >

                if (ent.GetPersistentVarAsInt("gen") != reset) {
                    ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                    int seconds = ent.GetPersistentVarAsInt("xp")

                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)

                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                    } else {
                        int minutes = seconds

                        Message(ent, "Current Time: " + seconds + " seconds ")
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 1479.437, 10456.58, 22189.5 >

            if (ent.GetPersistentVarAsInt("gen") != reset) {
                ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                int seconds = ent.GetPersistentVarAsInt("xp")

                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)

                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                } else {
                    int minutes = seconds

                    Message(ent, "Current Time: " + seconds + " seconds ")
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_115 )
    entity trigger_116 = MapEditor_CreateTrigger( < 1486.513, 10692, 19447.97 >, < 0, 89.9932, 0 >, 341.65, 50, false )
    trigger_116.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_116 )
    entity trigger_117 = MapEditor_CreateTrigger( < 2556.699, 10793.09, 17129.1 >, < 0, -0.0068, 0 >, 43.65, 50, false )
    trigger_117.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        int reset = 0

        if (ent in file.cp_table) {
            if (file.cp_table[ent] != < 2470.7, 10793.09, 17142.5 >) {
                file.cp_table[ent] <- < 2470.7, 10793.09, 17142.5 >

                if (ent.GetPersistentVarAsInt("gen") != reset) {
                    ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                    int seconds = ent.GetPersistentVarAsInt("xp")

                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)

                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                    } else {
                        int minutes = seconds

                        Message(ent, "Current Time: " + seconds + " seconds ")
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 2470.7, 10793.09, 17142.5 >

            if (ent.GetPersistentVarAsInt("gen") != reset) {
                ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                int seconds = ent.GetPersistentVarAsInt("xp")

                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)

                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                } else {
                    int minutes = seconds

                    Message(ent, "Current Time: " + seconds + " seconds ")
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_117 )
    entity trigger_118 = MapEditor_CreateTrigger( < 2753.413, 10044.1, 18448.07 >, < 0, 89.9932, 0 >, 341.65, 50, false )
    trigger_118.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_118 )
    entity trigger_119 = MapEditor_CreateTrigger( < 2265.352, 10185, 18127.1 >, < 0, 89.9912, 0 >, 43.65, 50, false )
    trigger_119.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        int reset = 0

        if (ent in file.cp_table) {
            if (file.cp_table[ent] != < 2265.349, 10099, 18140.5 >) {
                file.cp_table[ent] <- < 2265.349, 10099, 18140.5 >

                if (ent.GetPersistentVarAsInt("gen") != reset) {
                    ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                    int seconds = ent.GetPersistentVarAsInt("xp")

                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)

                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                    } else {
                        int minutes = seconds

                        Message(ent, "Current Time: " + seconds + " seconds ")
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 2265.349, 10099, 18140.5 >

            if (ent.GetPersistentVarAsInt("gen") != reset) {
                ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                int seconds = ent.GetPersistentVarAsInt("xp")

                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)

                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                } else {
                    int minutes = seconds

                    Message(ent, "Current Time: " + seconds + " seconds ")
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_119 )
    entity trigger_120 = MapEditor_CreateTrigger( < 3089.513, 11854, 15110.1 >, < 0, 89.9932, 0 >, 43.65, 50, false )
    trigger_120.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        int reset = 0

        if (ent in file.cp_table) {
            if (file.cp_table[ent] != < 3089.513, 11768, 15123.5 >) {
                file.cp_table[ent] <- < 3089.513, 11768, 15123.5 >

                if (ent.GetPersistentVarAsInt("gen") != reset) {
                    ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                    int seconds = ent.GetPersistentVarAsInt("xp")

                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)

                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                    } else {
                        int minutes = seconds

                        Message(ent, "Current Time: " + seconds + " seconds ")
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 3089.513, 11768, 15123.5 >

            if (ent.GetPersistentVarAsInt("gen") != reset) {
                ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                int seconds = ent.GetPersistentVarAsInt("xp")

                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)

                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                } else {
                    int minutes = seconds

                    Message(ent, "Current Time: " + seconds + " seconds ")
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_120 )
    entity trigger_121 = MapEditor_CreateTrigger( < 1610.997, -23274.42, 19040.73 >, < -0.0001, -0.0001, 0 >, 500, 50, false )
    trigger_121.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)

    }
}
    })
    DispatchSpawn( trigger_121 )
    entity trigger_122 = MapEditor_CreateTrigger( < 1613.513, 10825, 21510.27 >, < 0, 89.9932, 0 >, 500, 50, false )
    trigger_122.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_122 )
    entity trigger_123 = MapEditor_CreateTrigger( < 1910.513, 11338, 25855.17 >, < 0, 89.9932, 0 >, 500, 50, false )
    trigger_123.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_123 )
    entity trigger_124 = MapEditor_CreateTrigger( < 2089.513, 10819.7, 17599.27 >, < 0, 89.9932, 0 >, 350, 50, false )
    trigger_124.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_124 )
    entity trigger_125 = MapEditor_CreateTrigger( < 3145.513, 10680, 16529.27 >, < 0, 89.9932, 0 >, 341.65, 50, false )
    trigger_125.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_125 )
    entity trigger_126 = MapEditor_CreateTrigger( < 1908.809, 15627, 31370.27 >, < 0, 0, 0 >, 1000, 50, false )
    trigger_126.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_126 )
    entity trigger_127 = MapEditor_CreateTrigger( < 928.4995, -19528.49, 14989 >, < 0, -89.9904, 0 >, 15000, 50, false )
    trigger_127.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_127 )
    entity trigger_128 = MapEditor_CreateTrigger( < 1256.487, 12086, 27696.1 >, < 0, -90.0068, 0 >, 43.65, 50, false )
    trigger_128.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        int reset = 0

        if (ent in file.cp_table) {
            if (file.cp_table[ent] != < 1256.487, 12172, 27709.5 >) {
                file.cp_table[ent] <- < 1256.487, 12172, 27709.5 >

                if (ent.GetPersistentVarAsInt("gen") != reset) {
                    ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                    int seconds = ent.GetPersistentVarAsInt("xp")

                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)

                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                    } else {
                        int minutes = seconds

                        Message(ent, "Current Time: " + seconds + " seconds ")
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 1256.487, 12172, 27709.5 >

            if (ent.GetPersistentVarAsInt("gen") != reset) {
                ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                int seconds = ent.GetPersistentVarAsInt("xp")

                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)

                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                } else {
                    int minutes = seconds

                    Message(ent, "Current Time: " + seconds + " seconds ")
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_128 )
    entity trigger_129 = MapEditor_CreateTrigger( < 1610.51, -23504.96, 19324.64 >, < -0.0001, -0.0001, 0 >, 100, 50, false )
    trigger_129.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        int reset = 0

        if (ent in file.cp_table) {
            if (file.cp_table[ent] != < 1610.51, -23504.96, 19324.64 >) {
                file.cp_table[ent] <- < 1610.51, -23504.96, 19324.64 >

                if (ent.GetPersistentVarAsInt("gen") != reset) {
                    ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                    int seconds = ent.GetPersistentVarAsInt("xp")

                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)

                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                    } else {
                        int minutes = seconds

                        Message(ent, "Current Time: " + seconds + " seconds ")
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 1610.51, -23504.96, 19324.64 >

            if (ent.GetPersistentVarAsInt("gen") != reset) {
                ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                int seconds = ent.GetPersistentVarAsInt("xp")

                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)

                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                } else {
                    int minutes = seconds

                    Message(ent, "Current Time: " + seconds + " seconds ")
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_129 )
    entity trigger_130 = MapEditor_CreateTrigger( < 1910.513, 11653, 27159.07 >, < 0, 89.9932, 0 >, 500, 50, false )
    trigger_130.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_130 )
    entity trigger_131 = MapEditor_CreateTrigger( < 1860.991, -26770.42, 21352.73 >, < -0.0001, -0.0001, 0 >, 1000, 50, false )
    trigger_131.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)

    }
}
    })
    DispatchSpawn( trigger_131 )
    entity trigger_132 = MapEditor_CreateTrigger( < 1833.327, -25001.33, 20953.57 >, < -0.0001, 89.9999, 0 >, 100, 50, false )
    trigger_132.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        int reset = 0

        if (ent in file.cp_table) {
            if (file.cp_table[ent] != < 1833.327, -25001.33, 20953.57 >) {
                file.cp_table[ent] <- < 1833.327, -25001.33, 20953.57 >

                if (ent.GetPersistentVarAsInt("gen") != reset) {
                    ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                    int seconds = ent.GetPersistentVarAsInt("xp")

                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)

                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                    } else {
                        int minutes = seconds

                        Message(ent, "Current Time: " + seconds + " seconds ")
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 1833.327, -25001.33, 20953.57 >

            if (ent.GetPersistentVarAsInt("gen") != reset) {
                ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                int seconds = ent.GetPersistentVarAsInt("xp")

                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)

                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                } else {
                    int minutes = seconds

                    Message(ent, "Current Time: " + seconds + " seconds ")
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_132 )
    entity trigger_133 = MapEditor_CreateTrigger( < 645.5127, 10832, 23664.87 >, < 0, 89.9932, 0 >, 500, 50, false )
    trigger_133.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_133 )
    entity trigger_134 = MapEditor_CreateTrigger( < 921.8325, -19826.42, 17912.72 >, < -0.0001, -89.9904, -0.009 >, 100, 50, false )
    trigger_134.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        int reset = 0

        if (ent in file.cp_table) {
            if (file.cp_table[ent] != < 921.8325, -19826.42, 17912.72 >) {
                file.cp_table[ent] <- < 921.8325, -19826.42, 17912.72 >

                if (ent.GetPersistentVarAsInt("gen") != reset) {
                    ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                    int seconds = ent.GetPersistentVarAsInt("xp")

                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)

                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                    } else {
                        int minutes = seconds

                        Message(ent, "Current Time: " + seconds + " seconds ")
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 921.8325, -19826.42, 17912.72 >

            if (ent.GetPersistentVarAsInt("gen") != reset) {
                ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                int seconds = ent.GetPersistentVarAsInt("xp")

                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)

                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                } else {
                    int minutes = seconds

                    Message(ent, "Current Time: " + seconds + " seconds ")
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_134 )
    entity trigger_135 = MapEditor_CreateTrigger( < 1781.513, 10140, 18448.07 >, < 0, 89.9932, 0 >, 341.65, 50, false )
    trigger_135.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_135 )
    entity trigger_136 = MapEditor_CreateTrigger( < 2593.513, 11850, 15560.27 >, < 0, 89.9932, 0 >, 341.65, 50, false )
    trigger_136.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_136 )
    entity trigger_137 = MapEditor_CreateTrigger( < 1942.569, 14730.1, 32952 >, < 0, -90.0208, 0 >, 101, 50, false )
    trigger_137.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        int reset = 0

        if (ent in file.cp_table) {
            if (file.cp_table[ent] != < 1942.569, 14730.1, 32952 >) {
                file.cp_table[ent] <- < 1942.569, 14730.1, 32952 >

                if (ent.GetPersistentVarAsInt("gen") != reset) {
                    ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                    int seconds = ent.GetPersistentVarAsInt("xp")

                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)

                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                    } else {
                        int minutes = seconds

                        Message(ent, "Current Time: " + seconds + " seconds ")
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 1942.569, 14730.1, 32952 >

            if (ent.GetPersistentVarAsInt("gen") != reset) {
                ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                int seconds = ent.GetPersistentVarAsInt("xp")

                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)

                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                } else {
                    int minutes = seconds

                    Message(ent, "Current Time: " + seconds + " seconds ")
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_137 )
    entity trigger_138 = MapEditor_CreateTrigger( < 2019.513, 10389, 19447.97 >, < 0, 89.9932, 0 >, 341.65, 50, false )
    trigger_138.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_138 )
    entity trigger_139 = MapEditor_CreateTrigger( < 2798.99, -27401.42, 21513.73 >, < -0.0001, -0.0001, 0 >, 1000, 50, false )
    trigger_139.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)

    }
}
    })
    DispatchSpawn( trigger_139 )
    entity trigger_140 = MapEditor_CreateTrigger( < 921.5005, -22512.49, 17746 >, < 0, 90, 0 >, 1000, 50, false )
    trigger_140.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    mantlemap_reset_doors() 
    }
}
    })
    DispatchSpawn( trigger_140 )
    entity trigger_141 = MapEditor_CreateTrigger( < 5313.953, -29160.9, 27486.73 >, < 0, 179.9935, -0.0001 >, 100, 50, false )
    trigger_141.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        int reset = 0

        if (ent in file.cp_table) {
            if (file.cp_table[ent] != < 5313.953, -29160.9, 27486.73 >) {
                file.cp_table[ent] <- < 5313.953, -29160.9, 27486.73 >

                if (ent.GetPersistentVarAsInt("gen") != reset) {
                    ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                    int seconds = ent.GetPersistentVarAsInt("xp")

                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)

                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                    } else {
                        int minutes = seconds

                        Message(ent, "Current Time: " + seconds + " seconds ")
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 5313.953, -29160.9, 27486.73 >

            if (ent.GetPersistentVarAsInt("gen") != reset) {
                ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                int seconds = ent.GetPersistentVarAsInt("xp")

                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)

                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                } else {
                    int minutes = seconds

                    Message(ent, "Current Time: " + seconds + " seconds ")
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_141 )
    entity trigger_142 = MapEditor_CreateTrigger( < 4337.067, -28023.58, 24859.07 >, < -0.0001, -179.9997, 0 >, 1000, 50, false )
    trigger_142.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    mantlemap_reset_doors() 
    }
}
    })
    DispatchSpawn( trigger_142 )
    entity trigger_143 = MapEditor_CreateTrigger( < 2267.499, -6761.486, 17805 >, < 0, -90, 0 >, 2500, 50, false )
    trigger_143.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_143 )
    entity trigger_144 = MapEditor_CreateTrigger( < 4986.07, -28492.57, 28003.07 >, < -0.0001, -179.9997, 0 >, 1000, 50, false )
    trigger_144.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)

    }
}
    })
    DispatchSpawn( trigger_144 )
    entity trigger_145 = MapEditor_CreateTrigger( < 1860.992, -26184.42, 21067.73 >, < -0.0001, -0.0001, 0 >, 1000, 50, false )
    trigger_145.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)

    }
}
    })
    DispatchSpawn( trigger_145 )
    entity trigger_146 = MapEditor_CreateTrigger( < 5710.076, -29269.57, 25751.07 >, < -0.0001, -179.9997, 0 >, 1000, 50, false )
    trigger_146.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)

    }
}
    })
    DispatchSpawn( trigger_146 )
    entity trigger_147 = MapEditor_CreateTrigger( < 922.5127, 10635, 25855.17 >, < 0, 89.9932, 0 >, 500, 50, false )
    trigger_147.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_147 )
    entity trigger_148 = MapEditor_CreateTrigger( < 1124.412, 12706.9, 29170.77 >, < 0, -0.0067, 0 >, 500, 50, false )
    trigger_148.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_148 )
    entity trigger_149 = MapEditor_CreateTrigger( < 2660.064, -28157.58, 23175.07 >, < -0.0001, -179.9997, 0 >, 1000, 50, false )
    trigger_149.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    mantlemap_reset_doors() 
    }
}
    })
    DispatchSpawn( trigger_149 )
    entity trigger_150 = MapEditor_CreateTrigger( < 5313.953, -29161.89, 27486.73 >, < 0, 89.9935, -0.0001 >, 100, 50, false )
    trigger_150.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        int reset = 0

        if (ent in file.cp_table) {
            if (file.cp_table[ent] != < 5313.953, -29161.89, 27486.73 >) {
                file.cp_table[ent] <- < 5313.953, -29161.89, 27486.73 >

                if (ent.GetPersistentVarAsInt("gen") != reset) {
                    ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                    int seconds = ent.GetPersistentVarAsInt("xp")

                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)

                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                    } else {
                        int minutes = seconds

                        Message(ent, "Current Time: " + seconds + " seconds ")
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 5313.953, -29161.89, 27486.73 >

            if (ent.GetPersistentVarAsInt("gen") != reset) {
                ent.SetPersistentVar("xp", Time() - ent.GetPersistentVarAsInt("gen"))
                int seconds = ent.GetPersistentVarAsInt("xp")

                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)

                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds ")
                } else {
                    int minutes = seconds

                    Message(ent, "Current Time: " + seconds + " seconds ")
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_150 )
    entity trigger_151 = MapEditor_CreateTrigger( < 1266.513, 12116, 27159.07 >, < 0, 89.9932, 0 >, 500, 50, false )
    trigger_151.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)
    }
}
    })
    DispatchSpawn( trigger_151 )

    entity trigger_152 = MapEditor_CreateTrigger( < 3761.989, -28283.42, 21513.73 >, < -0.0001, -0.0001, 0 >, 1000, 50, false )
    trigger_152.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)

    }
}
    })
    DispatchSpawn( trigger_152 )

    // Triggers
    entity trigger_153 = MapEditor_CreateTrigger( < 4459.991, -26805.42, 22475.73 >, < -0.0001, -0.0001, 0 >, 1000, 50, false )
    trigger_153.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent in file.cp_table) {
            ent.SetOrigin(file.cp_table[ent])
        } else {
            ent.SetOrigin(file.first_cp)
        }
        ent.SetVelocity( < 0, 0, 0 >)

    }
}
    })
    DispatchSpawn( trigger_153 )

    // Props
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 3006.854, 12562.96, 14078.6 >, < 0, 179.9865, 0 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 3203.054, 11776.55, 15117.9 >, < 0, 89.9932, 0 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 3208.454, 11080.25, 16125.4 >, < 0, 179.9865, 0 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 2477.954, 10676.75, 17138.4 >, < 0, 179.9634, 0 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 2380.954, 10106.75, 18138.4 >, < 0, -90.007, 0 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 1536.954, 10061.75, 19138 >, < 0, 179.993, 0 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 1718.954, 9448.755, 20138.4 >, < 0, -90.007, 0 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 1482.954, 10241.75, 21111.4 >, < 0, 89.9833, 0 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 1488.954, 10339.75, 22186.4 >, < 0, 179.9473, 0 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 1145.954, 10568.75, 23262.4 >, < 0, 89.9494, 0 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 1356.354, 10906.75, 24365.4 >, < 0, 89.9494, 0 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 1131.954, 11251.75, 25465.4 >, < 0, 89.9494, 0 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 1140.954, 11542.75, 26673.4 >, < 0, 89.9634, 0 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 1140.054, 12161.75, 27704.4 >, < 0, 89.9634, 0 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 1746.054, 12473.75, 28741.4 >, < 0, -0.0365, 0 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 1822.854, 12839.85, 29783 >, < 0, 89.9634, 0 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 2054.954, 12849.96, 30587.9 >, < 0, -0.0135, 0 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 1829.454, 13479.55, 31389 >, < 0, -0.0275, 0 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 1842.654, 14780.96, 31730.4 >, < 0, -0.0275, 0 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 3170.754, 12562.96, 14078.6 >, < 0, 179.9865, 0 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 2970.254, 11776.55, 15117.9 >, < 0, 89.9932, 0 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 2970.554, 11080.25, 16125.4 >, < 0, 179.9865, 0 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 2477.954, 10911.85, 17138.4 >, < 0, 179.9634, 0 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 2146.554, 10106.75, 18138.4 >, < 0, -90.007, 0 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 1536.954, 10297.05, 19138 >, < 0, 179.993, 0 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 1483.654, 9448.755, 20138.4 >, < 0, -90.007, 0 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 1718.954, 10241.75, 21111.4 >, < 0, 89.9833, 0 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 1488.954, 10575.16, 22186.4 >, < 0, 179.9473, 0 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 1382.054, 10568.75, 23262.4 >, < 0, 89.9494, 0 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 1374.154, 11251.75, 25465.4 >, < 0, 89.9494, 0 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 2056.854, 12839.85, 29783 >, < 0, 89.9634, 0 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 2021.854, 13479.55, 31389 >, < 0, -0.0275, 0 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 1375.154, 12161.75, 27704.4 >, < 0, 89.9634, 0 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 1591.654, 10906.75, 24365.4 >, < 0, 89.9494, 0 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 1375.254, 11542.75, 26673.4 >, < 0, 89.9634, 0 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 1746.054, 12238.85, 28741.4 >, < 0, -0.0365, 0 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 1818.354, 12849.96, 30587.9 >, < 0, -0.0135, 0 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 2040.254, 14780.96, 31730.4 >, < 0, -0.0275, 0 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 522.9539, -19508.34, 15076.6 >, < 0, 0.0029, 0 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 821.9539, -19280.55, 16685.6 >, < 0, 90.004, 0 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 1020.851, -19926.34, 17860.8 >, < 0.009, 0.0029, -0.0001 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 1022.854, -22070.55, 17887.8 >, < 0, -89.9967, 0 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 1710.954, -22346.14, 19281.9 >, < 0, 89.9932, -0.0001 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 1711.454, -23604.35, 19279.5 >, < 0, 89.9932, -0.0001 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 1710.454, -24774.64, 19362.3 >, < 0, 89.9932, -0.0001 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 1934.054, -24902.55, 20908.7 >, < 0, 179.9932, -0.0001 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 1936.454, -26602.55, 21502 >, < 0, 179.9932, -0.0001 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 3168.154, -27624.14, 21897.3 >, < 0, -90.0068, 0 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 4161.154, -28133.75, 23287.4 >, < 0, -0.0065, -0.0001 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 2824.854, -28134.64, 23630.8 >, < 0, -179.9963, 0 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 3513.654, -27943.75, 25127.1 >, < 0.0001, -90.0132, 0 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 4913.354, -27944.64, 25465.8 >, < 0.0001, -90.0132, 0 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 5413.654, -29261.14, 27441.3 >, < 0.0001, -90.0132, 0 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 324.3538, -19508.34, 15076.6 >, < 0, 0.0029, 0 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 1020.554, -19280.55, 16685.6 >, < 0, 90.004, 0 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 823.3513, -19926.34, 17860.8 >, < 0.009, 0.0029, -0.0001 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 823.7539, -22070.55, 17887.8 >, < 0, -89.9967, 0 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 1511.454, -22346.14, 19281.9 >, < 0, 89.9932, -0.0001 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 1513.554, -23604.35, 19279.5 >, < 0, 89.9932, -0.0001 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 1512.954, -24774.64, 19362.3 >, < 0, 89.9932, -0.0001 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 1934.054, -25100.25, 20908.7 >, < 0, 179.9932, -0.0001 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 1936.454, -26796.05, 21502 >, < 0, 179.9932, -0.0001 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 2968.954, -27624.14, 21897.3 >, < 0, -90.0068, 0 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 4161.154, -27936.14, 23287.4 >, < 0, -0.0065, -0.0001 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 2824.854, -27936.14, 23630.8 >, < 0, -179.9963, 0 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 3513.654, -28141.64, 25127.1 >, < 0.0001, -90.0132, 0 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 4913.354, -28141.55, 25465.8 >, < 0.0001, -90.0132, 0 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/fx/energy_ring_edge.rmdl", < 5215.454, -29261.14, 27441.3 >, < 0.0001, -90.0132, 0 >, true, 50000, -1, 5.3625 )

    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 5215.454, -29261.14, 27525.02 >, < 90, 89.9941, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 4913.354, -28141.55, 25550.72 >, < 90, -0.0067, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 3513.654, -28141.64, 25212.1 >, < 90, -0.0068, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 2824.854, -27936.14, 23715.62 >, < 90, 0.011, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 4161.154, -27936.14, 23372.52 >, < 90, 0.0005, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 2968.954, -27624.14, 21982.42 >, < 90, 90.0005, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 1936.454, -26796.05, 21587.22 >, < 90, -179.9999, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 1934.054, -25100.25, 20994.42 >, < 90, -179.9999, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 1512.954, -24774.64, 19446.92 >, < 90, 90.0001, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 1513.554, -23604.35, 19364.42 >, < 90, 90, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 1511.454, -22346.14, 19365.72 >, < 89.9802, 90.0001, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 823.7539, -22070.55, 17971.82 >, < 90, 90.0106, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 823.3647, -19926.34, 17946.12 >, < 90, 90.0189, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 1020.554, -19280.55, 16770.52 >, < 90, -89.9887, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 324.3538, -19508.34, 15161.82 >, < 90, 90.0099, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 5413.954, -29261.17, 27442.22 >, < -90, -90.0067, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 4913.354, -27941.34, 25467.42 >, < -90, 179.9935, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 3513.654, -27943.75, 25128.92 >, < -90, 179.9935, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 2824.854, -28134.64, 23632.32 >, < -90, -179.9897, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 4161.154, -28133.75, 23288.72 >, < -90, -179.9996, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 3168.154, -27624.14, 21899.42 >, < -90, -90.0002, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 1936.454, -26602.55, 21503.72 >, < -90, 0.0001, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 1934.054, -24902.55, 20910.82 >, < -90, 0.0001, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 1710.454, -24774.64, 19363.32 >, < -90, -89.9999, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 1711.454, -23604.35, 19281.02 >, < -90, -89.9999, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 1710.954, -22346.14, 19283.22 >, < -90, -89.9999, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 1022.854, -22070.55, 17889.22 >, < -90, -89.99, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 1020.852, -19926.34, 17862.92 >, < -90, -89.9994, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 821.9539, -19280.55, 16687.12 >, < -90, 90.0107, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 522.9539, -19508.34, 15078.42 >, < -90, -89.9903, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 2040.227, 14781.55, 31815.57 >, < 90, -0.0209, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 2055.854, 12850.03, 30589.92 >, < -90, 179.9934, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 1746.053, 12236.66, 28827.12 >, < 89.972, -90.0301, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 1375.254, 11542.75, 26758.62 >, < 89.972, 179.9706, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 1375.154, 12161.75, 27789.42 >, < 89.972, -0.03, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 1591.654, 10906.75, 24450.32 >, < 89.9657, 179.9569, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 2021.827, 13480.75, 31474.02 >, < 89.972, -0.021, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 2055.454, 12839.86, 29867.92 >, < 89.972, -0.0299, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 1374.154, 11251.75, 25550.62 >, < 89.9657, 179.9571, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 1382.054, 10568.75, 23347.62 >, < 89.9657, 179.957, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 1488.954, 10575.16, 22271.62 >, < 89.972, -90.0453, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 1718.954, 10241.75, 21183.72 >, < 90, -0.0012, 0 >, true, 50000, -1, 5.3625 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 1483.654, 9448.755, 20223.82 >, < 90, 0.0004, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 1536.954, 10297.05, 19223.32 >, < 89.972, -89.9995, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 2146.554, 10106.75, 18223.52 >, < 90, 0.0004, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 2477.954, 10911.85, 17223.62 >, < 89.9802, -90.0291, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 2970.554, 11080.25, 16210.22 >, < 90, 179.9822, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 2970.254, 11776.55, 15203.22 >, < 89.9802, 0.0003, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 3170.754, 12562.96, 14080.12 >, < -90, -0.0066, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 1842.654, 14781.55, 31732.48 >, < -90, 179.9794, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 1829.454, 13480.75, 31391.12 >, < -89.9802, 179.9794, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 1817.354, 12850.08, 30672.62 >, < 89.9802, -0.0063, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 1820.254, 12839.86, 29785.12 >, < -89.972, 179.9705, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 1746.053, 12472.55, 28743.32 >, < -89.9604, 89.9706, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 1140.054, 12161.75, 27706.12 >, < -89.972, 179.9707, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 1140.954, 11542.75, 26675.72 >, < -89.9802, -0.0298, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 1131.954, 11251.75, 25467.92 >, < -89.9604, -0.0438, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 1145.954, 10568.75, 23264.42 >, < -89.972, -0.0439, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 1356.354, 10906.75, 24367.72 >, < -89.972, -0.0438, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 1488.954, 10339.75, 22188.22 >, < -89.9657, 89.954, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 1482.954, 10241.75, 21113.72 >, < -90, -179.9942, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 1718.954, 9448.755, 20140.52 >, < -90, 179.9998, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 1536.954, 10061.75, 19139.02 >, < -90, 89.9998, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 2380.954, 10106.75, 18140.82 >, < -90, 179.9998, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 2477.954, 10676.75, 17140.72 >, < -89.972, 89.9702, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 3208.454, 11080.25, 16140.32 >, < -90, -0.0066, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 3203.054, 11776.55, 15119.72 >, < -89.9802, -179.9997, 0 >, true, 50000, -1, 6.9404 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < 3006.854, 12562.96, 14163.82 >, < 90, 179.9938, 0 >, true, 50000, -1, 6.9404 )





    // Triggers
    entity trigger_900 = MapEditor_CreateTrigger( < 3006.854, 12562.96, 14093.52 >, < 0, 179.9865, 0 >, 28.15, 15, false )
    trigger_900.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 1943.575, 14758.1, 31781.8 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
    Message(ent, "Going to the previous cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_900 )
    entity trigger_901 = MapEditor_CreateTrigger( < 3203.054, 11776.55, 15132.82 >, < 0, 89.9932, 0 >, 28.15, 15, false )
    trigger_901.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 3089.513, 11152, 16116.12 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the next cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_901 )
    entity trigger_902 = MapEditor_CreateTrigger( < 3208.454, 11080.25, 16140.32 >, < 0, 89.9932, 0 >, 28.15, 15, false )
    trigger_902.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 2556.699, 10793.09, 17129.1 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the next cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_902 )
    entity trigger_903 = MapEditor_CreateTrigger( < 2477.954, 10676.75, 17153.32 >, < 0, 89.9702, 0 >, 28.15, 15, false )
    trigger_903.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 2265.352, 10185, 18127.1 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the next cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_903 )
    entity trigger_904 = MapEditor_CreateTrigger( < 2380.954, 10106.75, 18153.32 >, < 0, 179.9997, 0 >, 28.15, 15, false )
    trigger_904.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 1616.496, 10178.15, 19128.1 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the next cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_904 )
    entity trigger_905 = MapEditor_CreateTrigger( < 1536.954, 10061.75, 19152.92 >, < 0, 89.9998, 0 >, 28.15, 15, false )
    trigger_905.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 1602.353, 9527.995, 20129.1 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the next cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_905 )
    entity trigger_906 = MapEditor_CreateTrigger( < 1718.954, 9448.755, 20153.32 >, < 0, 179.9997, 0 >, 28.15, 15, false )
    trigger_906.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 1600.42, 10163.96, 21101.1 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the next cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_906 )
    entity trigger_907 = MapEditor_CreateTrigger( < 1482.954, 10241.75, 21126.32 >, < 0, -0.0099, 0 >, 28.15, 15, false )
    trigger_907.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 1565.436, 10456.56, 22176.1 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the next cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_907 )
    entity trigger_908 = MapEditor_CreateTrigger( < 1488.954, 10339.75, 22201.32 >, < 0, 89.954, 0 >, 28.15, 15, false )
    trigger_908.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 1263.716, 10489.17, 23252.1 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the next cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_908 )
    entity trigger_909 = MapEditor_CreateTrigger( < 1145.954, 10568.75, 23277.32 >, < 0, -0.0438, 0 >, 28.15, 15, false )
    trigger_909.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 1472.716, 10829.17, 24356.1 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the next cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_909 )
    entity trigger_9010 = MapEditor_CreateTrigger( < 1356.354, 10906.75, 24380.32 >, < 0, -0.0438, 0 >, 28.15, 15, false )
    trigger_9010.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 1255.717, 11171.17, 25456.62 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the next cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9010 )
    entity trigger_9011 = MapEditor_CreateTrigger( < 1131.954, 11251.75, 25480.32 >, < 0, -0.0438, 0 >, 28.15, 15, false )
    trigger_9011.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 1256.487, 11463, 26664.1 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the next cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9011 )
    entity trigger_9012 = MapEditor_CreateTrigger( < 1140.954, 11542.75, 26688.32 >, < 0, -0.0298, 0 >, 28.15, 15, false )
    trigger_9012.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 1256.487, 12086, 27696.1 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the next cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9012 )
    entity trigger_9013 = MapEditor_CreateTrigger( < 1140.054, 12161.75, 27719.32 >, < 0, -0.0298, 0 >, 28.15, 15, false )
    trigger_9013.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 1665.5, 12357.01, 28733.1 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the next cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9013 )
    entity trigger_9014 = MapEditor_CreateTrigger( < 1746.054, 12473.75, 28756.32 >, < 0, -90.0298, 0 >, 28.15, 15, false )
    trigger_9014.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 1938.938, 12761.44, 29775.1 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the next cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9014 )
    entity trigger_9015 = MapEditor_CreateTrigger( < 1822.854, 12839.85, 29797.92 >, < 0, -0.0298, 0 >, 28.15, 15, false )
    trigger_9015.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 1938.938, 12769.44, 30683.92 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the next cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9015 )
    entity trigger_9016 = MapEditor_CreateTrigger( < 2054.954, 12849.96, 30602.82 >, < 0, -90.0068, 0 >, 28.15, 15, false )
    trigger_9016.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 1923.977, 13379.5, 31441.8 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the next cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9016 )
    entity trigger_9017 = MapEditor_CreateTrigger( < 1829.454, 13479.55, 31403.92 >, < 0, -90.0208, 0 >, 28.15, 15, false )
    trigger_9017.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 1943.575, 14758.1, 31781.8 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the next cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9017 )
    entity trigger_9018 = MapEditor_CreateTrigger( < 1842.654, 14780.96, 31745.32 >, < 0, -90.0208, 0 >, 28.15, 15, false )
    trigger_9018.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 3088.613, 12494.5, 14129.37 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the next cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9018 )
    entity trigger_9019 = MapEditor_CreateTrigger( < 3170.754, 12562.96, 14093.52 >, < 0, 179.9865, 0 >, 28.15, 15, false )
    trigger_9019.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 3089.513, 11854, 15110.1 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the next cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9019 )
    entity trigger_9020 = MapEditor_CreateTrigger( < 2970.254, 11776.55, 15132.82 >, < 0, 89.9932, 0 >, 28.15, 15, false )
    trigger_9020.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 3088.613, 12494.5, 14129.37 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the previous cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9020 )
    entity trigger_9021 = MapEditor_CreateTrigger( < 2970.554, 11080.25, 16140.32 >, < 0, 89.9932, 0 >, 28.15, 15, false )
    trigger_9021.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 3089.513, 11854, 15110.1 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the previous cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9021 )
    entity trigger_9022 = MapEditor_CreateTrigger( < 2477.954, 10911.85, 17153.32 >, < 0, 89.9702, 0 >, 28.15, 15, false )
    trigger_9022.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 3089.513, 11152, 16116.12 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the previous cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9022 )
    entity trigger_9023 = MapEditor_CreateTrigger( < 2146.554, 10106.75, 18153.32 >, < 0, 179.9997, 0 >, 28.15, 15, false )
    trigger_9023.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 2556.699, 10793.09, 17129.1 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the previous cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9023 )
    entity trigger_9024 = MapEditor_CreateTrigger( < 1536.954, 10297.05, 19152.92 >, < 0, 89.9998, 0 >, 28.15, 15, false )
    trigger_9024.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 2265.352, 10185, 18127.1 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the previous cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9024 )
    entity trigger_9025 = MapEditor_CreateTrigger( < 1483.654, 9448.755, 20153.32 >, < 0, 179.9997, 0 >, 28.15, 15, false )
    trigger_9025.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 1616.496, 10178.15, 19128.1 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the previous cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9025 )
    entity trigger_9026 = MapEditor_CreateTrigger( < 1718.954, 10241.75, 21126.32 >, < 0, -0.0099, 0 >, 28.15, 15, false )
    trigger_9026.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 1602.353, 9527.995, 20129.1 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the previous cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9026 )
    entity trigger_9027 = MapEditor_CreateTrigger( < 1488.954, 10575.16, 22201.32 >, < 0, 89.954, 0 >, 28.15, 15, false )
    trigger_9027.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 1600.42, 10163.96, 21101.1 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the previous cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9027 )
    entity trigger_9028 = MapEditor_CreateTrigger( < 1382.054, 10568.75, 23277.32 >, < 0, -0.0438, 0 >, 28.15, 15, false )
    trigger_9028.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 1565.436, 10456.56, 22176.1 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the previous cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9028 )
    entity trigger_9029 = MapEditor_CreateTrigger( < 1374.154, 11251.75, 25480.32 >, < 0, -0.0438, 0 >, 28.15, 15, false )
    trigger_9029.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 1472.716, 10829.17, 24356.1 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the previous cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9029 )
    entity trigger_9030 = MapEditor_CreateTrigger( < 2056.854, 12839.85, 29797.92 >, < 0, -0.0298, 0 >, 28.15, 15, false )
    trigger_9030.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 1665.5, 12357.01, 28733.1 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the previous cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9030 )
    entity trigger_9031 = MapEditor_CreateTrigger( < 2021.854, 13479.55, 31403.92 >, < 0, -90.0208, 0 >, 28.15, 15, false )
    trigger_9031.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 1938.938, 12769.44, 30683.92 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the previous cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9031 )
    entity trigger_9032 = MapEditor_CreateTrigger( < 1375.154, 12161.75, 27719.32 >, < 0, -0.0298, 0 >, 28.15, 15, false )
    trigger_9032.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 1256.487, 11463, 26664.1 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the previous cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9032 )
    entity trigger_9033 = MapEditor_CreateTrigger( < 1591.654, 10906.75, 24380.32 >, < 0, -0.0438, 0 >, 28.15, 15, false )
    trigger_9033.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 1263.716, 10489.17, 23252.1 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the previous cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9033 )
    entity trigger_9034 = MapEditor_CreateTrigger( < 1375.254, 11542.75, 26688.32 >, < 0, -0.0298, 0 >, 28.15, 15, false )
    trigger_9034.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 1255.717, 11171.17, 25456.62 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the previous cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9034 )
    entity trigger_9035 = MapEditor_CreateTrigger( < 1746.054, 12238.85, 28756.32 >, < 0, -90.0298, 0 >, 28.15, 15, false )
    trigger_9035.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 1256.487, 12086, 27696.1 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the previous cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9035 )
    entity trigger_9036 = MapEditor_CreateTrigger( < 1818.354, 12849.96, 30602.82 >, < 0, -90.0068, 0 >, 28.15, 15, false )
    trigger_9036.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 1938.938, 12761.44, 29775.1 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the previous cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9036 )
    entity trigger_9037 = MapEditor_CreateTrigger( < 2040.254, 14780.96, 31745.32 >, < 0, -90.0208, 0 >, 28.15, 15, false )
    trigger_9037.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 1923.977, 13379.5, 31441.8 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the previous cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9037 )
    entity trigger_9038 = MapEditor_CreateTrigger( < 522.9539, -19508.34, 15091.52 >, < 0, 0.0029, 0 >, 28.15, 15, false )
    trigger_9038.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 921.6301, -19380.24, 16737 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
    Message(ent, "Going to the next cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9038 )
    entity trigger_9039 = MapEditor_CreateTrigger( < 821.9539, -19280.55, 16700.52 >, < 0, 90.004, 0 >, 28.15, 15, false )
    trigger_9039.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 921.8325, -19826.42, 17912.72 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the next cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9039 )
    entity trigger_9040 = MapEditor_CreateTrigger( < 1020.854, -19926.34, 17875.72 >, < -0.0001, -89.9904, -0.009 >, 28.15, 15, false )
    trigger_9040.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 922.5293, -21970.6, 17937.23 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the next cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9040 )
    entity trigger_9041 = MapEditor_CreateTrigger( < 1022.854, -22070.55, 17902.72 >, < 0, -179.9899, 0 >, 28.15, 15, false )
    trigger_9041.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 1610.515, -22242.55, 19324.64 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the next cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9041 )
    entity trigger_9042 = MapEditor_CreateTrigger( < 1710.954, -22346.14, 19296.82 >, < -0.0001, -0.0001, 0 >, 28.15, 15, false )
    trigger_9042.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 1610.51, -23504.96, 19324.64 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the next cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9042 )
    entity trigger_9043 = MapEditor_CreateTrigger( < 1711.454, -23604.35, 19294.42 >, < -0.0001, -0.0001, 0 >, 28.15, 15, false )
    trigger_9043.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 1611.159, -24675.79, 19413.03 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the next cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9043 )
    entity trigger_9044 = MapEditor_CreateTrigger( < 1710.454, -24774.64, 19377.22 >, < -0.0001, -0.0001, 0 >, 28.15, 15, false )
    trigger_9044.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 1833.327, -25001.33, 20953.57 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the next cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9044 )
    entity trigger_9045 = MapEditor_CreateTrigger( < 1934.054, -24902.55, 20923.62 >, < -0.0001, 89.9999, 0 >, 28.15, 15, false )
    trigger_9045.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 1835.786, -26701.4, 21555.3 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the next cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9045 )
    entity trigger_9046 = MapEditor_CreateTrigger( < 1936.454, -26602.55, 21516.92 >, < -0.0001, 89.9999, 0 >, 28.15, 15, false )
    trigger_9046.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 3066.2, -27525, 21950.53 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the next cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9046 )
    entity trigger_9047 = MapEditor_CreateTrigger( < 3168.154, -27624.14, 21912.22 >, < 0, -180, 0 >, 28.15, 15, false )
    trigger_9047.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 4260.018, -28033.01, 23331.73 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the next cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9047 )
    entity trigger_9048 = MapEditor_CreateTrigger( < 4161.154, -28133.75, 23302.32 >, < -0.0001, -89.9998, 0 >, 28.15, 15, false )
    trigger_9048.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 2924.964, -28034.89, 23680.73 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the next cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9048 )
    entity trigger_9049 = MapEditor_CreateTrigger( < 2824.854, -28134.64, 23645.72 >, < 0, 90.0104, 0 >, 28.15, 15, false )
    trigger_9049.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 3414.953, -28042.9, 25170.73 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the next cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9049 )
    entity trigger_9050 = MapEditor_CreateTrigger( < 3513.654, -27943.75, 25142.02 >, < 0, 179.9935, -0.0001 >, 28.15, 15, false )
    trigger_9050.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 4813.953, -28042.9, 25510.73 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the next cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9050 )
    entity trigger_9051 = MapEditor_CreateTrigger( < 4913.354, -27944.64, 25480.72 >, < 0, 179.9935, -0.0001 >, 28.15, 15, false )
    trigger_9051.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 5313.953, -29160.9, 27486.73 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the next cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9051 )
    entity trigger_9052 = MapEditor_CreateTrigger( < 5413.654, -29261.14, 27456.22 >, < 0, 179.9935, -0.0001 >, 28.15, 15, false )
    trigger_9052.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 423.458, -19409.2, 15129 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the next cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9052 )
    entity trigger_9053 = MapEditor_CreateTrigger( < 324.3538, -19508.34, 15091.52 >, < 0, 0.0029, 0 >, 28.15, 15, false )
    trigger_9053.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 5313.955, -29160.9, 27486.73 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the previous cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9053 )
    entity trigger_9054 = MapEditor_CreateTrigger( < 1020.554, -19280.55, 16700.52 >, < 0, 90.004, 0 >, 28.15, 15, false )
    trigger_9054.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 423.4578, -19409.2, 15129 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the previous cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9054 )
    entity trigger_9055 = MapEditor_CreateTrigger( < 823.3538, -19926.34, 17875.72 >, < -0.0001, -89.9904, -0.009 >, 28.15, 15, false )
    trigger_9055.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 921.6299, -19380.24, 16737 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the previous cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9055 )
    entity trigger_9056 = MapEditor_CreateTrigger( < 823.7539, -22070.55, 17902.72 >, < 0, -179.9899, 0 >, 28.15, 15, false )
    trigger_9056.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 921.8325, -19826.42, 17912.72 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the previous cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9056 )
    entity trigger_9057 = MapEditor_CreateTrigger( < 1511.454, -22346.14, 19296.82 >, < -0.0001, -0.0001, 0 >, 28.15, 15, false )
    trigger_9057.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 922.5293, -21970.6, 17937.23 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the previous cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9057 )
    entity trigger_9058 = MapEditor_CreateTrigger( < 1513.554, -23604.35, 19294.42 >, < -0.0001, -0.0001, 0 >, 28.15, 15, false )
    trigger_9058.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 1610.515, -22242.55, 19324.64 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the previous cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9058 )
    entity trigger_9059 = MapEditor_CreateTrigger( < 1512.954, -24774.64, 19377.22 >, < -0.0001, -0.0001, 0 >, 28.15, 15, false )
    trigger_9059.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 1610.51, -23504.96, 19324.64 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the previous cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9059 )
    entity trigger_9060 = MapEditor_CreateTrigger( < 1934.054, -25100.25, 20923.62 >, < -0.0001, 89.9999, 0 >, 28.15, 15, false )
    trigger_9060.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 1611.159, -24675.79, 19413.03 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the previous cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9060 )
    entity trigger_9061 = MapEditor_CreateTrigger( < 1936.454, -26796.05, 21516.92 >, < -0.0001, 89.9999, 0 >, 28.15, 15, false )
    trigger_9061.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 1833.327, -25001.33, 20953.57 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the previous cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9061 )
    entity trigger_9062 = MapEditor_CreateTrigger( < 2968.954, -27624.14, 21912.22 >, < 0, -180, 0 >, 28.15, 15, false )
    trigger_9062.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 1835.787, -26701.4, 21555.3 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the previous cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9062 )
    entity trigger_9063 = MapEditor_CreateTrigger( < 4161.154, -27936.14, 23302.32 >, < -0.0001, -89.9998, 0 >, 28.15, 15, false )
    trigger_9063.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 3066.2, -27525, 21950.53 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the previous cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9063 )
    entity trigger_9064 = MapEditor_CreateTrigger( < 2824.854, -27936.14, 23645.72 >, < 0, 90.0104, 0 >, 28.15, 15, false )
    trigger_9064.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 4260.018, -28033.01, 23331.73 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the previous cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9064 )
    entity trigger_9065 = MapEditor_CreateTrigger( < 3513.654, -28141.64, 25142.02 >, < 0, 179.9935, -0.0001 >, 28.15, 15, false )
    trigger_9065.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 2924.964, -28034.89, 23680.73 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the previous cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9065 )
    entity trigger_9066 = MapEditor_CreateTrigger( < 4913.354, -28141.55, 25480.72 >, < 0, 179.9935, -0.0001 >, 28.15, 15, false )
    trigger_9066.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 3414.953, -28042.9, 25170.73 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the previous cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9066 )
    entity trigger_9067 = MapEditor_CreateTrigger( < 5215.454, -29261.14, 27456.22 >, < 0, 179.9935, -0.0001 >, 28.15, 15, false )
    trigger_9067.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) {
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
        if (ent.GetPersistentVarAsInt("gen") == 0) {
            ent.SetOrigin(< 4813.953, -28042.9, 25510.73 >)
            
            ent.SetVelocity(< 0, 0, 0 >)
            Message(ent, "Going to the previous cp")
        } else {
            Message(ent, "Can't use it while Timer is running!")
        }
    }
}
    })
    DispatchSpawn( trigger_9067 )

}