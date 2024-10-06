untyped
globalize_all_functions

// Code by: loy_ (Discord).
// Map by: loy_ (Discord).

void
function ithurtsmap_precache() {
    PrecacheModel($"mdl/beacon/construction_scaff_128_32.rmdl")
    PrecacheModel($"mdl/slum_city/slumcity_fencewall_32x72_dirty.rmdl")
    PrecacheModel($"mdl/firstgen/firstgen_pipe_128_darkcloth_01.rmdl")
    PrecacheModel($"mdl/beacon/beacon_fence_sign_01.rmdl")
    PrecacheModel($"mdl/desertlands/industrial_cargo_container_320_01_open.rmdl")
    PrecacheModel($"mdl/thunderdome/thunderdome_cage_ceiling_256x64_05.rmdl")
    PrecacheModel($"mdl/desertlands/desertlands_ceiling_tile_01.rmdl")
    PrecacheModel($"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl")
    PrecacheModel($"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl")
    PrecacheModel($"mdl/desertlands/construction_bldg_elevator_01_top.rmdl")
    PrecacheModel($"mdl/desertlands/industrial_cargo_container_small_03.rmdl")
    PrecacheModel($"mdl/desertlands/fence_large_concrete_metal_dirty_192_01.rmdl")
    PrecacheModel($"mdl/desertlands/industrial_cargo_container_large_01.rmdl")
    PrecacheModel($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl")
    PrecacheModel($"mdl/props/death_box/death_box_01.rmdl")
    PrecacheModel($"mdl/desertlands/construction_bldg_platform_02.rmdl")
    PrecacheModel($"mdl/desertlands/construction_bldg_platform_01.rmdl")
    PrecacheModel($"mdl/ola/sewer_grate_02.rmdl")
    PrecacheModel($"mdl/desertlands/construction_bldg_platform_03.rmdl")
    PrecacheModel($"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl")
    PrecacheModel($"mdl/desertlands/city_steps_metal_grate_double_128_01.rmdl")
    PrecacheModel($"mdl/beacon/construction_scaff_segment_128_64.rmdl")
    PrecacheModel($"mdl/thunderdome/thunderdome_cage_frame_128x32_01.rmdl")
    PrecacheModel($"mdl/desertlands/construction_bldg_elevator_01_bott.rmdl")
    PrecacheModel($"mdl/thunderdome/thunderdome_cage_wall_256x128_03.rmdl")
    PrecacheModel($"mdl/beacon/construction_scaff_post_128_01.rmdl")
    PrecacheModel($"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl")
    PrecacheModel($"mdl/desertlands/icelandic_moss_mod_01.rmdl")
    PrecacheModel($"mdl/beacon/kodai_metal_beam_02_256.rmdl")
    PrecacheModel($"mdl/homestead/homestead_floor_panel_01.rmdl")
}


struct {
    vector first_cp = < 29890.6, -930, 50109 >
        table < entity, vector > cp_table = {}
    table < entity, vector > cp_angle = {}
    table < entity, bool > last_cp = {}
}
file

void
function ithurtsmap_init() {
    AddCallback_OnClientConnected(ithurtsmap_player_setup)
    AddCallback_EntitiesDidLoad(ItHurtsMapEntitiesDidLoad)
    ithurtsmap_precache()
}

void
function ItHurtsMapEntitiesDidLoad() {
    thread ithurtsmap_load()
}

void
function ithurtsmap_SpawnInfoText(entity player) {
    EndSignal(player, "OnDestroy") //fix to entity may become invalid after the wait, causing server to crash. Cafe
    FlagWait("EntitiesDidLoad")
    wait 1
    CreatePanelText(player, "It hurts", "by: Loy", < 29890.02, -1092.1, 50179.2 > , < 0, -90, 0 > , false, 1)
}

void
function ithurtsmap_player_setup(entity player) {
    array < ItemFlavor > characters = GetAllCharacters()

    player.SetOrigin(file.first_cp)
    CharacterSelect_AssignCharacter(ToEHI(player), characters[8])

    TakeAllPassives(player)
    TakeAllWeapons(player)
    player.GiveWeapon("mp_weapon_melee_survival", WEAPON_INVENTORY_SLOT_PRIMARY_2, [])
    player.GiveOffhandWeapon("melee_pilot_emptyhanded", OFFHAND_MELEE, [])
    player.SetPlayerNetBool("pingEnabled", false)

    player.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
    player.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
    player.SetSuitGrapplePower(100)
    player.SetAngles( < 0, -90, 0 > )
    player.SetPersistentVar("gen", 0)
    file.last_cp[player] <- false
    LocalMsg(player, "#FS_STRING_VAR", "", 9, 5.0, "It Hurts Map", "By: Loy Takian", "", false)

    thread ithurtsmap_SpawnInfoText(player)
}

void
function ithurtsmap_load() {
    // Props
    entity prop
    prop = MapEditor_CreateProp($"mdl/beacon/construction_scaff_128_32.rmdl", < 35398.1, 7835.18, 51615.7 > , < 0.0002, -90.0002, -90.0003 > , false, 50000, -1, 1)
    prop.kv.solid = 3
    prop = MapEditor_CreateProp($"mdl/slum_city/slumcity_fencewall_32x72_dirty.rmdl", < 34288.64, 8053.41, 50653.08 > , < 0, -89.9985, -180 > , false, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/firstgen/firstgen_pipe_128_darkcloth_01.rmdl", < 29950.98, 7348.102, 50426.3 > , < 0, -179.999, 90 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/beacon/beacon_fence_sign_01.rmdl", < 29934.1, 4162.001, 50246.2 > , < 0, 90.0009, 179.9997 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_320_01_open.rmdl", < 35407.01, 6309.836, 53093 > , <- 90, 0.0003, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x64_05.rmdl", < 35330.8, 7936.869, 51294.6 > , < 0, 0.0018, -30 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/desertlands/desertlands_ceiling_tile_01.rmdl", < 29806.3, 1923.998, 50260 > , < 90, 0.0007, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 34913.49, 8183.755, 50809.9 > , < 0, -179.9984, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/slum_city/slumcity_fencewall_32x72_dirty.rmdl", < 33521.75, 8192.98, 50650.9 > , <- 90, 90.0016, 0 > , false, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 29710.98, 7520.297, 50553 > , <- 90, -179.999, 0 > , false, 50000, -1, 1)
    prop.kv.solid = 3;
    prop.MakeInvisible()
    prop = MapEditor_CreateProp($"mdl/desertlands/construction_bldg_elevator_01_top.rmdl", < 35337.03, 7317.467, 51685.8 > , < 0, 90.0116, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/beacon/beacon_fence_sign_01.rmdl", < 29887.88, 3846.301, 50293.1 > , < 0.0002, 90.0007, 89.9998 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_small_03.rmdl", < 35135, 5530, 53223 > , < 0, 0, 0 > , false, 50000, -1, 1)
    prop.kv.solid = 3
    prop = MapEditor_CreateProp($"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 34908.49, 8183.755, 51018.8 > , < 90, -179.9984, 0 > , false, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/desertlands/fence_large_concrete_metal_dirty_192_01.rmdl", < 29792.9, 4275.501, 50288.9 > , < 0, 0, 0 > , false, 50000, -1, 1)
    prop.kv.solid = 3
    prop = MapEditor_CreateProp($"mdl/slum_city/slumcity_fencewall_32x72_dirty.rmdl", < 33521.75, 8053.391, 50653.08 > , < 0, -89.9985, -180 > , false, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 35543.7, 5343.6, 53097.16 > , <- 90, 0, 0 > , false, 50000, -1, 1)
    prop.kv.solid = 3
    prop = MapEditor_CreateProp($"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 34913.49, 8183.755, 50609.1 > , < 0, -179.9984, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 29886.98, 7467.5, 50372.6 > , < 0, -179.999, 90 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/props/death_box/death_box_01.rmdl", < 32203, 8119.993, 50322.8 > , < 0, 0.0012, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 29887.03, 4829.9, 50373.2 > , < 0, -179.999, 90 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_02.rmdl", < 29711.01, 3240.697, 50315.6 > , < 0, 90.0012, 0 > , false, 50000, -1, 1)
    prop.kv.solid = 3;
    prop.MakeInvisible()
    prop = MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 30068.58, 7520.304, 50224.5 > , <- 0.0108, -179.9992, 0.0002 > , false, 50000, -1, 1)
    prop.kv.solid = 3;
    prop.MakeInvisible()
    prop = MapEditor_CreateProp($"mdl/props/death_box/death_box_01.rmdl", < 32423, 8119.997, 50322.6 > , < 0, 0.0012, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_01.rmdl", < 29809.99, 6894, 50227 > , < 0, -89.9985, -89.9999 > , true, 50000, -1, 1)
    prop.kv.solid = 3;
    prop.MakeInvisible()
    prop = MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 35125.04, 5344.029, 53097.16 > , <- 90, -179.9997, 0 > , false, 50000, -1, 1)
    prop.kv.solid = 3
    prop = MapEditor_CreateProp($"mdl/ola/sewer_grate_02.rmdl", < 30014.5, 112.1001, 50055.9 > , < 90, -179.9997, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_03.rmdl", < 30064.12, 2648.303, 50227.2 > , < 90, -89.9992, 0 > , false, 50000, -1, 1)
    prop.kv.solid = 3;
    prop.MakeInvisible()
    prop = MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 35335, 6917.735, 52732.2 > , < 0, -179.9985, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 35335, 6798.035, 52978 > , < 90, -89.9985, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/firstgen/firstgen_pipe_128_darkcloth_01.rmdl", < 29951, 6463.002, 50426.5 > , < 0, -179.999, 90 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_small_03.rmdl", < 35431, 5119, 51135.8 > , < 0, 90.0012, -179.9997 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/desertlands/city_steps_metal_grate_double_128_01.rmdl", < 35331.89, 8112.982, 51612.9 > , < 0, -179.9977, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x64_05.rmdl", < 35331.6, 4486.6, 50811.2 > , < 0, 90.0012, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_02.rmdl", < 33162.99, 7944.011, 49903 > , < 90, -179.9986, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 29888.01, 2970.1, 50223.8 > , < 0, -179.999, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 29886.99, 7199.301, 50437.4 > , < 0, -179.999, 90 > , false, 50000, -1, 1)
    prop.kv.solid = 3
    prop = MapEditor_CreateProp($"mdl/props/death_box/death_box_01.rmdl", < 30223, 8119.952, 50372.6 > , < 0, 0.0012, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_320_01_open.rmdl", < 35406.9, 5119, 51623.4 > , < 0, 90.0012, -89.9998 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/props/death_box/death_box_01.rmdl", < 31103, 8119.97, 50347.9 > , < 0, 0.0012, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 34764, 8120.013, 50495 > , < 0, -89.9985, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/beacon/construction_scaff_segment_128_64.rmdl", < 34497, 8120.006, 50545 > , <- 90, 90.0018, 0 > , false, 50000, -1, 1)
    prop.kv.solid = 3
    prop = MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 35331.6, 4240, 51000 > , < 0, 90.0012, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 29888.02, 2525.9, 50223.9 > , < 0, -179.999, 0 > , false, 50000, -1, 1)
    prop.kv.solid = 3
    prop = MapEditor_CreateProp($"mdl/beacon/beacon_fence_sign_01.rmdl", < 29887.88, 4671.301, 50376.9 > , < 0.0002, 90.0007, 89.9998 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_small_03.rmdl", < 35267.2, 5279.396, 51135.8 > , < 0, 0.0013, -179.9997 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 35335.09, 7276.335, 52190.2 > , < 0, 0.0019, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/slum_city/slumcity_fencewall_32x72_dirty.rmdl", < 34256.8, 8055.1, 50517.5 > , < 0, -89.9985, 0 > , false, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 35335.01, 6308.235, 53096.4 > , < 0, 0, 89.9998 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_frame_128x32_01.rmdl", < 30000, -0.5, 50192 > , < 0.0003, 90.0003, 180 > , false, 50000, -1, 1)
    prop.kv.solid = 3
    prop = MapEditor_CreateProp($"mdl/ola/sewer_grate_02.rmdl", < 30014.5, -15.7998, 50055.9 > , < 90, -179.9997, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_small_03.rmdl", < 35267.2, 4906.997, 50843.8 > , < 0.0002, 0.0012, 90.0005 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 35335, 6659.935, 53096.4 > , < 0, 0, 89.9998 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 35335.03, 5604.635, 53096.4 > , < 0, 0, 89.9998 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 35335.09, 7219.035, 52005 > , < 0, 90.0018, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/beacon/construction_scaff_128_32.rmdl", < 35271.39, 8119.476, 51926.7 > , <- 0.0002, -89.9998, 90 > , false, 50000, -1, 1)
    prop.kv.solid = 3
    prop = MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_03.rmdl", < 30064.01, 3190.003, 50314 > , < 90, -89.9992, 0 > , false, 50000, -1, 1)
    prop.kv.solid = 3;
    prop.MakeInvisible()
    prop = MapEditor_CreateProp($"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 34908.49, 8183.755, 50617.7 > , < 90, -179.9984, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/beacon/construction_scaff_segment_128_64.rmdl", < 29762.22, 3306.383, 50273 > , <- 90, 90.0018, 0 > , false, 50000, -1, 1)
    prop.kv.solid = 3;
    prop.MakeInvisible()
    prop = MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 29887, 6314.2, 50437.6 > , < 0, -179.999, 90 > , false, 50000, -1, 1)
    prop.kv.solid = 3
    prop = MapEditor_CreateProp($"mdl/desertlands/construction_bldg_elevator_01_bott.rmdl", < 35337.03, 7317.467, 51686.12 > , < 0, 90.0116, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/beacon/construction_scaff_segment_128_64.rmdl", < 33727, 8119.986, 50545 > , <- 89.9802, -89.9985, 0 > , false, 50000, -1, 1)
    prop.kv.solid = 3
    prop = MapEditor_CreateProp($"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 34614.39, 8055.899, 50910.1 > , < 0, 0.002, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/slum_city/slumcity_fencewall_32x72_dirty.rmdl", < 33873.5, 8049.25, 50650.9 > , <- 90, -89.9985, 0 > , false, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_small_03.rmdl", < 35396, 5530, 53223 > , < 0, 0, 0 > , false, 50000, -1, 1)
    prop.kv.solid = 3
    prop = MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 35335.09, 7107.028, 52437 > , < 90, -89.9979, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/beacon/construction_scaff_segment_128_64.rmdl", < 33727, 8119.986, 50545 > , <- 90, 90.0018, 0 > , false, 50000, -1, 1)
    prop.kv.solid = 3
    prop = MapEditor_CreateProp($"mdl/desertlands/construction_bldg_elevator_01_top.rmdl", < 35336.92, 7317.467, 51477.8 > , < 0, 90.0018, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_03.rmdl", < 30031.91, 2941.302, 50140.51 > , < 90, -179.999, 0 > , false, 50000, -1, 1)
    prop.kv.solid = 3;
    prop.MakeInvisible()
    prop = MapEditor_CreateProp($"mdl/slum_city/slumcity_fencewall_32x72_dirty.rmdl", < 33489.91, 8055.08, 50517.5 > , < 0, -89.9985, 0 > , false, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_320_01_open.rmdl", < 35406.9, 5119, 52279.3 > , < 0, 90.0012, -89.9998 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 29886.98, 7539.4, 50477 > , < 0, -179.999, 90 > , false, 50000, -1, 1)
    prop.kv.solid = 3
    prop = MapEditor_CreateProp($"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 34619.39, 8055.9, 50717.9 > , < 90, 0.002, 0 > , false, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_small_03.rmdl", < 35238.9, 5118.996, 51000 > , < 0, 90.0012, -179.9997 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_small_03.rmdl", < 35267.2, 5279.396, 51000 > , < 0, 0.0013, -179.9997 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 34614.39, 8055.899, 51110.4 > , < 0, 0.002, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_wall_256x128_03.rmdl", < 35335, 6787.135, 53096.4 > , < 0, 0.0005, 90 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/beacon/construction_scaff_128_32.rmdl", < 35398.09, 8119.48, 51926.7 > , < 0.0002, -90.0002, -90.0003 > , false, 50000, -1, 1)
    prop.kv.solid = 3
    prop = MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_frame_128x32_01.rmdl", < 30000, 251.6001, 50192 > , < 0.0003, 90.0003, 180 > , false, 50000, -1, 1)
    prop.kv.solid = 3
    prop = MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 29888.01, 2776.7, 50223.9 > , < 0, -179.999, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_frame_128x32_01.rmdl", < 29786, -0.5024, 50192 > , <- 0.0003, -90, 180 > , false, 50000, -1, 1)
    prop.kv.solid = 3
    prop = MapEditor_CreateProp($"mdl/beacon/construction_scaff_post_128_01.rmdl", < 35428.23, 7830.596, 51788.3 > , < 0, 90.0122, 0 > , true, 50000, -1, 1)
    prop.kv.solid = 3
    prop = MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_01.rmdl", < 29713.5, -81.2017, 50058.2 > , < 0, 90.0005, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 29887.01, 5765.4, 50477.6 > , < 0, -179.999, 90 > , false, 50000, -1, 1)
    prop.kv.solid = 3
    prop = MapEditor_CreateProp($"mdl/slum_city/slumcity_fencewall_32x72_dirty.rmdl", < 33905.35, 8049.25, 50519.5 > , < 90, 90.0014, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/desertlands/construction_bldg_elevator_01_top.rmdl", < 35335.55, 8637.092, 51788 > , < 0, -89.9881, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/beacon/construction_scaff_segment_128_64.rmdl", < 34115, 8119.996, 50545 > , <- 89.9802, -89.9985, 0 > , false, 50000, -1, 1)
    prop.kv.solid = 3
    prop = MapEditor_CreateProp($"mdl/slum_city/slumcity_fencewall_32x72_dirty.rmdl", < 33489.91, 8049.24, 50650.9 > , <- 90, -89.9985, 0 > , false, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/slum_city/slumcity_fencewall_32x72_dirty.rmdl", < 34256.8, 8188.7, 50653.08 > , < 0, 90.0015, 180 > , false, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/beacon/beacon_fence_sign_01.rmdl", < 29841, 4162, 50246.2 > , < 0, 90.0005, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_320_01_open.rmdl", < 35407.02, 5973.937, 53093 > , <- 90, 0.0003, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_01.rmdl", < 29712.7, 1675.096, 50163.5 > , < 0, 90.0005, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/beacon/beacon_fence_sign_01.rmdl", < 29887.88, 4162.001, 50293.1 > , < 0.0002, 90.0007, 89.9998 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 29887, 6654.301, 50477.2 > , < 0, -179.999, 90 > , false, 50000, -1, 1)
    prop.kv.solid = 3
    prop = MapEditor_CreateProp($"mdl/beacon/beacon_fence_sign_01.rmdl", < 29934.1, 3846.301, 50246.2 > , < 0, 90.0009, 179.9997 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_small_03.rmdl", < 35431, 5119, 51000 > , < 0, 90.0012, -179.9997 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 35259.04, 5344.036, 53365 > , < 90, 0, 0 > , false, 50000, -1, 1)
    prop.kv.solid = 3
    prop = MapEditor_CreateProp($"mdl/desertlands/construction_bldg_elevator_01_bott.rmdl", < 35335.68, 8637.093, 51375.92 > , < 0, -89.9985, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 29888.02, 2429.4, 50147 > , < 0, -179.999, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_wall_256x128_03.rmdl", < 30015.51, 3177.602, 50132.7 > , < 0, 90.0012, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/beacon/construction_scaff_post_128_01.rmdl", < 35429.37, 8124.001, 51686.1 > , < 0, -89.9881, 0 > , true, 50000, -1, 1)
    prop.kv.solid = 3
    prop = MapEditor_CreateProp($"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl", < 35467.01, 6450.038, 53340.7 > , < 0, 90.0002, 179.9997 > , false, 50000, -1, 1)
    prop.kv.solid = 3;
    prop.MakeInvisible()
    prop = MapEditor_CreateProp($"mdl/slum_city/slumcity_fencewall_32x72_dirty.rmdl", < 34256.8, 8193, 50519.5 > , < 90, -89.9985, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_small_03.rmdl", < 35238.9, 5118.996, 51135.8 > , < 0, 90.0012, -179.9997 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 29886.99, 6928.9, 50372.6 > , < 0, -179.999, 90 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_frame_128x32_01.rmdl", < 29786, 251.5977, 50192 > , <- 0.0003, -90, 180 > , false, 50000, -1, 1)
    prop.kv.solid = 3
    prop = MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 29887.02, 5154.9, 50373.2 > , < 0, -179.999, 90 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/desertlands/icelandic_moss_mod_01.rmdl", < 32595, 3632, 49250 > , < 0, 0, 0 > , true, 50000, -1, 60)
    prop = MapEditor_CreateProp($"mdl/beacon/construction_scaff_post_128_01.rmdl", < 35428.2, 7830.581, 51375.9 > , < 0, 90.0018, 0 > , true, 50000, -1, 1)
    prop.kv.solid = 3
    prop = MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_01.rmdl", < 29964.01, 5892.002, 50227 > , < 0, 90.0012, -89.9999 > , true, 50000, -1, 1)
    prop.kv.solid = 3;
    prop.MakeInvisible()
    prop = MapEditor_CreateProp($"mdl/ola/sewer_grate_02.rmdl", < 30014.5, 239.9001, 50055.9 > , < 90, -179.9997, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_03.rmdl", < 33163, 7944.001, 50495 > , < 0, -179.9997, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/slum_city/slumcity_fencewall_32x72_dirty.rmdl", < 33489.9, 8188.68, 50653.08 > , < 0, 90.0015, 180 > , false, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_320_01_open.rmdl", < 35406.9, 5119, 51295.1 > , < 0, 90.0012, -89.9998 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_small_03.rmdl", < 35267.2, 5290.297, 51272.3 > , < 0, 0.0013, -179.9997 > , false, 50000, -1, 1)
    prop.kv.solid = 3;
    prop.MakeInvisible()
    prop = MapEditor_CreateProp($"mdl/slum_city/slumcity_fencewall_32x72_dirty.rmdl", < 33905.34, 8192.99, 50650.9 > , <- 90, 90.0016, 0 > , false, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/desertlands/desertlands_ceiling_tile_01.rmdl", < 29975, 1924, 50260 > , < 90, 0.0007, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_small_03.rmdl", < 35236.3, 5118.996, 51272.3 > , < 0, 90.0012, -179.9997 > , false, 50000, -1, 1)
    prop.kv.solid = 3;
    prop.MakeInvisible()
    prop = MapEditor_CreateProp($"mdl/ola/sewer_grate_02.rmdl", < 29770.4, 112.0996, 50055.9 > , < 90, 0.0007, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 34619.39, 8055.9, 50918.7 > , < 90, 0.002, 0 > , false, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_320_01_open.rmdl", < 35406.9, 5119, 51951 > , < 0, 90.0012, -89.9998 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/ola/sewer_grate_02.rmdl", < 29770.4, -15.8003, 50055.9 > , < 90, 0.0007, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/beacon/construction_scaff_segment_128_64.rmdl", < 30015.02, 3306.39, 50273 > , <- 90, 90.0018, 0 > , false, 50000, -1, 1)
    prop.kv.solid = 3;
    prop.MakeInvisible()
    prop = MapEditor_CreateProp($"mdl/slum_city/slumcity_fencewall_32x72_dirty.rmdl", < 33521.75, 8187.98, 50517.3 > , < 0, 90.0015, 0 > , false, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_03.rmdl", < 29745.5, 3293.298, 50140.51 > , < 90, 0.0013, 0 > , false, 50000, -1, 1)
    prop.kv.solid = 3;
    prop.MakeInvisible()
    prop = MapEditor_CreateProp($"mdl/desertlands/fence_large_concrete_metal_dirty_192_01.rmdl", < 29985, 4275.501, 50288.9 > , < 0, 0, 0 > , false, 50000, -1, 1)
    prop.kv.solid = 3
    prop = MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 35335.41, 7474.278, 52004.7 > , < 0, -89.9985, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 34614.39, 8055.899, 50709.3 > , < 0, 0.002, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/ola/sewer_grate_02.rmdl", < 29770.4, 367.7996, 50055.9 > , < 90, 0.0007, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 29886.99, 6861, 50477 > , < 0, -179.999, 90 > , false, 50000, -1, 1)
    prop.kv.solid = 3
    prop = MapEditor_CreateProp($"mdl/slum_city/slumcity_fencewall_32x72_dirty.rmdl", < 33873.5, 8055.09, 50517.5 > , < 0, -89.9985, 0 > , false, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_02.rmdl", < 33181.78, 8296.012, 50123 > , < 0, 0.0013, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/beacon/kodai_metal_beam_02_256.rmdl", < 33092.39, 7869.209, 50245.2 > , <- 0.0002, -179.9985, 89.9998 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 29887.02, 5087, 50477.6 > , < 0, -179.999, 90 > , false, 50000, -1, 1)
    prop.kv.solid = 3
    prop = MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_01.rmdl", < 29810.04, 4868, 50227 > , < 0, -89.9985, -89.9999 > , true, 50000, -1, 1)
    prop.kv.solid = 3;
    prop.MakeInvisible()
    prop = MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 29888, 3559, 50281.4 > , < 0, -179.999, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/slum_city/slumcity_fencewall_32x72_dirty.rmdl", < 33905.34, 8053.4, 50653.08 > , < 0, -89.9985, -180 > , false, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/ola/sewer_grate_02.rmdl", < 30014.5, 367.8, 50055.9 > , < 90, -179.9997, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/slum_city/slumcity_fencewall_32x72_dirty.rmdl", < 33873.5, 8188.69, 50653.08 > , < 0, 90.0015, 180 > , false, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/props/death_box/death_box_01.rmdl", < 31763, 8119.983, 50347.6 > , < 0, 0.0012, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/beacon/construction_scaff_128_32.rmdl", < 35400.2, 7835.18, 51615.7 > , <- 0.0002, -89.9998, 90 > , false, 50000, -1, 1)
    prop.kv.solid = 3
    prop = MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 29888.01, 2939.4, 50147 > , < 0, -179.999, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/beacon/construction_scaff_segment_128_64.rmdl", < 34115, 8119.996, 50545 > , <- 90, 90.0018, 0 > , false, 50000, -1, 1)
    prop.kv.solid = 3
    prop = MapEditor_CreateProp($"mdl/ola/sewer_grate_02.rmdl", < 29770.4, 239.8997, 50055.9 > , < 90, 0.0007, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_01.rmdl", < 29963.97, 7918.002, 50227 > , < 0, 90.0012, -89.9999 > , true, 50000, -1, 1)
    prop.kv.solid = 3;
    prop.MakeInvisible()
    prop = MapEditor_CreateProp($"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 34913.49, 8183.755, 51010.2 > , < 0, -179.9984, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_wall_256x128_03.rmdl", < 29761.61, 3177.598, 50132.7 > , < 0, 90.0012, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 29888.02, 2683.7, 50147 > , < 0, -179.999, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/beacon/construction_scaff_post_128_01.rmdl", < 35243.2, 7830.575, 51375.9 > , < 0, 90.0018, 0 > , true, 50000, -1, 1)
    prop.kv.solid = 3
    prop = MapEditor_CreateProp($"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 34908.49, 8183.755, 50818.5 > , < 90, -179.9984, 0 > , false, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 29888.69, 2429.398, 50146.9 > , < 0, 0.0007, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/beacon/beacon_fence_sign_01.rmdl", < 29841, 3846.3, 50246.2 > , < 0, 90.0005, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/props/death_box/death_box_01.rmdl", < 31543, 8119.979, 50297.6 > , < 0, 0.0012, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/slum_city/slumcity_fencewall_32x72_dirty.rmdl", < 34288.64, 8188, 50517.3 > , < 0, 90.0015, 0 > , false, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 35335, 6975.035, 52547 > , < 0, -89.9985, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_320_01_open.rmdl", < 35406.9, 5119, 52608.2 > , < 0, 90.0012, -89.9998 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/beacon/kodai_metal_beam_02_256.rmdl", < 33092.39, 8110.009, 50245.2 > , <- 0.0002, -179.9985, 89.9998 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/props/death_box/death_box_01.rmdl", < 31983, 8119.988, 50322.9 > , < 0, 0.0012, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/slum_city/slumcity_fencewall_32x72_dirty.rmdl", < 33873.5, 8192.99, 50519.5 > , < 90, -89.9985, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/slum_city/slumcity_fencewall_32x72_dirty.rmdl", < 34288.64, 8193, 50650.9 > , <- 90, 90.0016, 0 > , false, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/slum_city/slumcity_fencewall_32x72_dirty.rmdl", < 33489.9, 8192.98, 50519.5 > , < 90, -89.9985, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 35335.02, 5956.635, 53096.4 > , < 0, 0, 89.9998 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/props/death_box/death_box_01.rmdl", < 30443, 8119.957, 50322.7 > , < 0, 0.0012, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/homestead/homestead_floor_panel_01.rmdl", < 30007.8, 1936.603, 50313.2 > , < 0, 0.0007, -179.9997 > , false, 50000, -1, 1)
    prop.kv.solid = 3
    prop = MapEditor_CreateProp($"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 35333.43, 4546.294, 50810 > , < 0, 90.0012, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/desertlands/construction_bldg_elevator_01_top.rmdl", < 35335.68, 8637.093, 51375.6 > , < 0, -89.9985, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/slum_city/slumcity_fencewall_32x72_dirty.rmdl", < 34256.8, 8049.26, 50650.9 > , <- 90, -89.9985, 0 > , false, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/beacon/construction_scaff_segment_128_64.rmdl", < 34497, 8120.006, 50545 > , <- 89.9802, -89.9985, 0 > , false, 50000, -1, 1)
    prop.kv.solid = 3
    prop = MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 29887.02, 5425.301, 50438 > , < 0, -179.999, 90 > , false, 50000, -1, 1)
    prop.kv.solid = 3
    prop = MapEditor_CreateProp($"mdl/props/death_box/death_box_01.rmdl", < 31323, 8119.975, 50322.6 > , < 0, 0.0012, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/beacon/construction_scaff_post_128_01.rmdl", < 35243.23, 7830.557, 51788.3 > , < 0, 90.0122, 0 > , true, 50000, -1, 1)
    prop.kv.solid = 3
    prop = MapEditor_CreateProp($"mdl/slum_city/slumcity_fencewall_32x72_dirty.rmdl", < 33521.75, 8049.24, 50519.5 > , < 90, 90.0015, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 34619.39, 8055.9, 51119 > , < 90, 0.002, 0 > , false, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/homestead/homestead_floor_panel_01.rmdl", < 29839, 1936.601, 50313.2 > , < 0, 0.0007, -179.9997 > , false, 50000, -1, 1)
    prop.kv.solid = 3
    prop = MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_small_03.rmdl", < 35434.6, 5119, 51272.3 > , < 0, 90.0012, -179.9997 > , false, 50000, -1, 1)
    prop.kv.solid = 3;
    prop.MakeInvisible()
    prop = MapEditor_CreateProp($"mdl/beacon/construction_scaff_128_32.rmdl", < 35400.19, 8119.48, 51926.7 > , <- 0.0002, -89.9998, 90 > , false, 50000, -1, 1)
    prop.kv.solid = 3
    prop = MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 29887.01, 6043.801, 50372.8 > , < 0, -179.999, 90 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_01.rmdl", < 29810.02, 5876, 50227 > , < 0, -89.9985, -89.9999 > , true, 50000, -1, 1)
    prop.kv.solid = 3;
    prop.MakeInvisible()
    prop = MapEditor_CreateProp($"mdl/slum_city/slumcity_fencewall_32x72_dirty.rmdl", < 34288.64, 8049.26, 50519.5 > , < 90, 90.0015, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/beacon/construction_scaff_post_128_01.rmdl", < 35244.36, 8123.963, 51686.1 > , < 0, -89.9881, 0 > , true, 50000, -1, 1)
    prop.kv.solid = 3
    prop = MapEditor_CreateProp($"mdl/desertlands/construction_bldg_elevator_01_bott.rmdl", < 35336.92, 7317.467, 51478.12 > , < 0, 90.0018, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_320_01_open.rmdl", < 35407.03, 5636.937, 53093 > , <- 90, 0.0003, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_small_03.rmdl", < 35265, 5087, 53094 > , < 0, 0, 0 > , false, 50000, -1, 1)
    prop.kv.solid = 3
    prop = MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 29887.01, 5975.9, 50477.2 > , < 0, -179.999, 90 > , false, 50000, -1, 1)
    prop.kv.solid = 3
    prop = MapEditor_CreateProp($"mdl/firstgen/firstgen_pipe_128_darkcloth_01.rmdl", < 29950.62, 5574.102, 50426.9 > , < 0, -179.999, 90 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_01.rmdl", < 29963.99, 6910.002, 50227 > , < 0, 90.0012, -89.9999 > , true, 50000, -1, 1)
    prop.kv.solid = 3;
    prop.MakeInvisible()
    prop = MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 29886.98, 7819.201, 50372.6 > , < 0, -179.999, 90 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/props/death_box/death_box_01.rmdl", < 30663, 8119.961, 50322.9 > , < 0, 0.0012, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x64_05.rmdl", < 35266.89, 8120.066, 51229 > , < 0, -89.9979, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/beacon/construction_scaff_128_32.rmdl", < 35271.4, 7835.176, 51615.7 > , <- 0.0002, -89.9998, 90 > , false, 50000, -1, 1)
    prop.kv.solid = 3
    prop = MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 29706.98, 7520.297, 50224.5 > , <- 0.0108, -179.9992, 0.0002 > , false, 50000, -1, 1)
    prop.kv.solid = 3;
    prop.MakeInvisible()
    prop = MapEditor_CreateProp($"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 35460.59, 4546.297, 50810 > , < 0, 90.0012, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/slum_city/slumcity_fencewall_32x72_dirty.rmdl", < 33905.34, 8187.991, 50517.3 > , < 0, 90.0015, 0 > , false, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 29887.01, 5693.5, 50373.2 > , < 0, -179.999, 90 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 29887, 6582.4, 50372.8 > , < 0, -179.999, 90 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 35331.6, 4341.2, 50838.4 > , < 0, 90.0012, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_320_01_open.rmdl", < 35406.9, 5119, 52936.5 > , < 0, 90.0012, -89.9998 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/props/death_box/death_box_01.rmdl", < 30883, 8119.966, 50297.9 > , < 0, 0.0012, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/desertlands/construction_bldg_elevator_01_bott.rmdl", < 35335.55, 8637.092, 51788.32 > , < 0, -89.9881, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/beacon/construction_scaff_post_128_01.rmdl", < 35429.39, 8123.985, 51478.1 > , < 0, -89.9979, 0 > , true, 50000, -1, 1)
    prop.kv.solid = 3
    prop = MapEditor_CreateProp($"mdl/beacon/construction_scaff_post_128_01.rmdl", < 35244.39, 8123.979, 51478.1 > , < 0, -89.9979, 0 > , true, 50000, -1, 1)
    prop.kv.solid = 3
    prop = MapEditor_CreateProp($"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl", < 35205.01, 6450.031, 53340.7 > , < 0, -90.0001, 179.9997 > , false, 50000, -1, 1)
    prop.kv.solid = 3;
    prop.MakeInvisible()
    prop = MapEditor_CreateProp($"mdl/desertlands/city_steps_metal_grate_double_128_01.rmdl", < 35331.5, 7841.578, 51923.2 > , < 0, 0.002, 0 > , true, 50000, -1, 1)
    prop = MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x64_05.rmdl", < 35011.2, 8120.059, 51229 > , < 0, 90.0018, 0 > , true, 50000, -1, 1)

    //1
    Invis_Button( < 29741.61, -977.4374, 50058.2 > , < 0, 90, 0 > , true, < 29816.61, 834.654, 50262.49 > , < 0, -180, 0 > , "")
    Invis_Button( < 29741.61, -884.4374, 50058.2 > , < 0, 90, 0 > , false, < 35376.51, 4338.754, 50953.09 > , < 0, -180, 0 > , "")
    //2
    Invis_Button( < 29741.61, 788.2626, 50163.19 > , < 0, 90, 0 > , true, < 29885.81, 2352.754, 50264.09 > , < 0, -180, 0 > , "")
    Invis_Button( < 29741.61, 881.2626, 50163.19 > , < 0, 90, 0 > , false, < 29816.61, -931.0469, 50157.5 > , < 0, -180, 0 > , "")
    //3
    Invis_Button( < 29766.51, 2385.363, 50164.79 > , < 0, 90, 0 > , true, < 29842.91, 3555.654, 50396.99 > , < 0, -180, 0 > , "")
    Invis_Button( < 29766.51, 2478.363, 50164.79 > , < 0, 90, 0 > , false, < 29816.61, 834.6529, 50262.49 > , < 0, -180, 0 > , "")
    //4
    Invis_Button( < 29767.91, 3509.263, 50297.69 > , < 0, 90, 0 > , true, < 29893.11, 4871.653, 50479.99 > , < 0, -180, 0 > , "")
    Invis_Button( < 29767.91, 3602.263, 50297.69 > , < 0, 90, 0 > , false, < 29885.81, 2352.753, 50264.09 > , < 0, -180, 0 > , "")
    //5
    Invis_Button( < 29818.11, 4825.263, 50380.69 > , < 0, 90, 0 > , true, < 29887.71, 8088.454, 50479.99 > , < 0, 90, 0 > , "")
    Invis_Button( < 29818.11, 4918.263, 50380.69 > , < 0, 90, 0 > , false, < 29842.91, 3555.653, 50396.99 > , < 0, -180, 0 > , "")
    //6
    Invis_Button( < 29841.32, 8163.46, 50380.69 > , < 0, 0, 0 > , true, < 32775.91, 8197.854, 50222.19 > , < 0, 90, 0 > , "")
    Invis_Button( < 29934.32, 8163.46, 50380.69 > , < 0, 0, 0 > , false, < 29893.11, 4871.653, 50479.99 > , < 0, -180, 0 > , "")
    //7
    Invis_Button( < 32729.52, 8272.86, 50122.89 > , < 0, 0, 0 > , true, < 33228.71, 8197.854, 50593.39 > , < 0, 90, 0 > , "")
    Invis_Button( < 32822.52, 8272.86, 50122.89 > , < 0, 0, 0 > , false, < 29887.71, 8088.453, 50479.99 > , < 0, 90, 0 > , "")
    //8
    Invis_Button( < 33182.32, 8272.86, 50494.09 > , < 0, 0, 0 > , true, < 34764.71, 8165.054, 50610.09 > , < 0, 90, 0 > , "")
    Invis_Button( < 33275.32, 8272.86, 50494.09 > , < 0, 0, 0 > , false, < 32775.91, 8197.854, 50222.19 > , < 0, 90, 0 > , "")
    //9
    Invis_Button( < 34718.32, 8240.061, 50510.79 > , < 0, 0, 0 > , true, < 35331.71, 7729.554, 51474.49 > , < 0, -90, 0 > , "")
    Invis_Button( < 34811.32, 8240.061, 50510.79 > , < 0, 0, 0 > , false, < 33228.71, 8197.854, 50593.39 > , < 0, 90, 0 > , "")
    //10
    Invis_Button( < 35378.1, 7654.548, 51375.19 > , < 0, -180, 0 > , true, < 35380.21, 7476.153, 52119.89 > , < 0, 0, 0 > , "")
    Invis_Button( < 35285.1, 7654.547, 51375.19 > , < 0, -180, 0 > , false, < 34764.71, 8165.054, 50610.09 > , < 0, 90, 0 > , "")
    //11
    Invis_Button( < 35455.22, 7522.544, 52020.59 > , < 0, -90, 0 > , true, < 35380.21, 6975.553, 52662.29 > , < 0, 0, 0 > , "")
    Invis_Button( < 35455.22, 7429.544, 52020.59 > , < 0, -90, 0 > , false, < 35331.71, 7729.554, 51474.49 > , < 0, -90, 0 > , "")
    //12
    Invis_Button( < 35455.22, 7021.944, 52562.99 > , < 0, -90, 0 > , true, < 35330.41, 5363.951, 53158.59 > , < 0, -90, 0 > , "")
    Invis_Button( < 35455.22, 6928.944, 52562.99 > , < 0, -90, 0 > , false, < 35380.21, 7476.153, 52119.89 > , < 0, 0, 0 > , "")
    //13
    Invis_Button( < 35376.8, 5135, 53117.09 > , < 0, -180, 0 > , true, < 35376.51, 4338.753, 50953.09 > , < 0, 0, 0 > , "")
    Invis_Button( < 35283.8, 5135, 53117.09 > , < 0, -180, 0 > , false, < 35380.21, 6975.553, 52662.29 > , < 0, 0, 0 > , "")
    //14
    Invis_Button( < 35451.52, 4385.144, 50853.79 > , < 0, -90, 0 > , true, < 29816.61, -931.0474, 50157.5 > , < 0, -180, 0 > , "")
    Invis_Button( < 35451.52, 4292.144, 50853.79 > , < 0, -90, 0 > , false, < 35330.41, 5363.951, 53158.59 > , < 0, -90, 0 > , "")

    // Linked Ziplines
    MapEditor_CreateLinkedZipline([ < 33095.98, 8288.142, 50210.7 > , < 33095.98, 8240.113, 50210.7 > , < 33095.98, 8185.113, 50210.7 > , < 33095.99, 8057.113, 50210.7 > , < 33095.99, 8000.113, 50210.7 > , < 33095.99, 7951.983, 50210.7 > ])

    // VerticalZipLines
    MapEditor_CreateZiplineFromUnity( < 35335.09, 7219.035, 52336 > , < 0, 90.0018, 0 > , < 35335.09, 7219.035, 52036 > , < 0, 90.0018, 0 > , true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [], [], [], 32, 60, 0)
    MapEditor_CreateZiplineFromUnity( < 35335, 6975.035, 52878 > , < 0, -89.9985, 0 > , < 35335, 6975.035, 52578 > , < 0, -89.9985, 0 > , true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [], [], [], 32, 60, 0)

    // Buttons
    AddCallback_OnUseEntity(CreateFRButton( < 29890.02, -1092.1, 50058.9 > , < 0, -179.9997, 0 > , "%use% Start/Stop Timer"), void
        function(entity panel, entity ent, int input) {
            if (IsValidPlayer(ent)) {
                if (ent.GetPersistentVar("gen") == 0) {
                    ent.SetPersistentVar("gen", Time())
                    ent.p.isTimerActive = true
                    ent.p.startTime = floor(Time()).tointeger()
                    LocalMsg(ent, "#FS_STRING_VAR", "", 4, 1.0, "Timer Started", "", "", false)
                } else {
                    ent.SetPersistentVar("gen", 0)
                    ent.p.isTimerActive = false
                    LocalMsg(ent, "#FS_STRING_VAR", "", 4, 1.0, "Timer Stopped", "", "", false)
                }
                file.last_cp[ent] <- false
                ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
                ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
            }
        })

    // Triggers
    entity trigger
    trigger = MapEditor_CreateTrigger( < 32776.6, 8120, 50178 > , < 0, -89.9998, 0 > , 180, 50, false)
    trigger.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValidPlayer(ent)) {
                int gen = ent.GetPersistentVarAsInt("gen")
                if (gen != 0) {
                    float final_time = Time() - gen
                    float minutes = final_time / 60
                    float seconds = final_time % 60
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, format("%d:%02d", minutes, seconds), "", "", false)
                } else if (file.cp_table[ent] != < 32776.6, 8120, 50178 > ) {
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, "CHECKPOINT", "", "", false)
                }
                file.cp_table[ent] <-  < 32776.6, 8120, 50178 >
                    file.cp_angle[ent] <-  < 0, 0.0002, 0 >
            }
        })
    DispatchSpawn(trigger)
    trigger = MapEditor_CreateTrigger( < 33227.1, 8119, 50552 > , < 0, -89.9998, 0 > , 62.5, 50, false)
    trigger.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValidPlayer(ent)) {
                int gen = ent.GetPersistentVarAsInt("gen")
                if (gen != 0) {
                    float final_time = Time() - gen
                    float minutes = final_time / 60
                    float seconds = final_time % 60
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, format("%d:%02d", minutes, seconds), "", "", false)
                } else if (file.cp_table[ent] != < 33187.7, 8120.1, 50552 > ) {
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, "CHECKPOINT", "", "", false)
                }
                file.cp_table[ent] <-  < 33187.7, 8120.1, 50552 >
                    file.cp_angle[ent] <-  < 0, 0.0002, 0 >
            }
        })
    DispatchSpawn(trigger)
    trigger = MapEditor_CreateTrigger( < 34765.2, 8120, 50560.7 > , < 0, -89.9998, 0 > , 125, 50, false)
    trigger.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValidPlayer(ent)) {
                int gen = ent.GetPersistentVarAsInt("gen")
                if (gen != 0) {
                    float final_time = Time() - gen
                    float minutes = final_time / 60
                    float seconds = final_time % 60
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, format("%d:%02d", minutes, seconds), "", "", false)
                } else if (file.cp_table[ent] != < 34765.2, 8120, 50560.7 > ) {
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, "CHECKPOINT", "", "", false)
                }
                file.cp_table[ent] <-  < 34765.2, 8120, 50560.7 >
                    file.cp_angle[ent] <-  < 0, 0.0002, 0 >
            }
        })
    DispatchSpawn(trigger)
    trigger = MapEditor_CreateTrigger( < 35975.6, 8136, 51111 > , < 0, 0, 0 > , 1000, 5, false)
    trigger.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValidPlayer(ent) && !ent.IsNoclipping())
                ent.SetOrigin(file.cp_table[ent])
        })
    DispatchSpawn(trigger)
    trigger = MapEditor_CreateTrigger( < 29888.7, 8096.3, 50430.7 > , < 0, -89.9998, 0 > , 75, 50, false)
    trigger.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValidPlayer(ent)) {
                int gen = ent.GetPersistentVarAsInt("gen")
                if (gen != 0) {
                    float final_time = Time() - gen
                    float minutes = final_time / 60
                    float seconds = final_time % 60
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, format("%d:%02d", minutes, seconds), "", "", false)
                } else if (file.cp_table[ent] != < 29888.7, 8096.3, 50430.7 > ) {
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, "CHECKPOINT", "", "", false)
                }
                file.cp_table[ent] <-  < 29888.7, 8096.3, 50430.7 >
                    file.cp_angle[ent] <-  < 0, 0.0002, 0 >
            }
        })
    DispatchSpawn(trigger)
    trigger = MapEditor_CreateTrigger( < 29888.7, 2432.5, 50215.4 > , < 0, 0, 0 > , 125, 50, false)
    trigger.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValidPlayer(ent)) {
                int gen = ent.GetPersistentVarAsInt("gen")
                if (gen != 0) {
                    float final_time = Time() - gen
                    float minutes = final_time / 60
                    float seconds = final_time % 60
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, format("%d:%02d", minutes, seconds), "", "", false)
                } else if (file.cp_table[ent] != < 29888.7, 2330.2, 50215.4 > ) {
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, "CHECKPOINT", "", "", false)
                }
                file.cp_table[ent] <-  < 29888.7, 2330.2, 50215.4 >
                    file.cp_angle[ent] <-  < 0, 90, 0 >
            }
        })
    DispatchSpawn(trigger)
    trigger = MapEditor_CreateTrigger( < 35332.5, 4239.1, 51065.6 > , < 0, 0, 0 > , 125, 50, false)
    trigger.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValidPlayer(ent)) {
                file.cp_table[ent] <- file.first_cp
                file.cp_angle[ent] <-  < 0, -90, 0 >

                    if (file.last_cp[ent]) {
                        int gen = ent.GetPersistentVarAsInt("gen")
                        file.last_cp[ent] = false

                        if (gen != 0) {
                            float final_time = Time() - gen
                            float minutes = final_time / 60
                            float seconds = final_time % 60

                            LocalMsg(ent, "#FS_STRING_VAR", "", 2, 5.0, format("%d:%02d", minutes, seconds), "FINAL TIME", "", false)
                            ent.SetPersistentVar("gen", 0)
                        } else {
                            LocalMsg(ent, "#FS_STRING_VAR", "", 2, 5.0, "YOU FINISHED!", "CONGRATULATIONS", "", false)
                        }
                    }

                if (ent.p.isTimerActive == true) {
                    ent.p.isTimerActive = false
                }
            }
        })
    DispatchSpawn(trigger)
    trigger = MapEditor_CreateTrigger( < 29888.7, 3560.4, 50347.4 > , < 0, 0, 0 > , 125, 50, false)
    trigger.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValidPlayer(ent)) {
                int gen = ent.GetPersistentVarAsInt("gen")
                if (gen != 0) {
                    float final_time = Time() - gen
                    float minutes = final_time / 60
                    float seconds = final_time % 60
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, format("%d:%02d", minutes, seconds), "", "", false)
                } else if (file.cp_table[ent] != < 29888.7, 3560.4, 50347.4 > ) {
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, "CHECKPOINT", "", "", false)
                }
                file.cp_table[ent] <-  < 29888.7, 3560.4, 50347.4 >
                    file.cp_angle[ent] <-  < 0, 90, 0 >
            }
        })
    DispatchSpawn(trigger)
    trigger = MapEditor_CreateTrigger( < 35469.6, 7151, 51111 > , < 0, 0, 0 > , 1000, 5, false)
    trigger.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValidPlayer(ent) && !ent.IsNoclipping())
                ent.SetOrigin(file.cp_table[ent])
        })
    DispatchSpawn(trigger)
    trigger = MapEditor_CreateTrigger( < 29904.6, -895, 49747 > , < 0, 0, 0 > , 3421.75, 50, false)
    trigger.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValidPlayer(ent) && !ent.IsNoclipping())
                ent.SetOrigin(file.cp_table[ent])
        })
    DispatchSpawn(trigger)
    trigger = MapEditor_CreateTrigger( < 29888.7, 7956.9, 50430.7 > , < 0, -89.9998, 0 > , 75, 50, false)
    trigger.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValidPlayer(ent)) {
                int gen = ent.GetPersistentVarAsInt("gen")
                if (gen != 0) {
                    float final_time = Time() - gen
                    float minutes = final_time / 60
                    float seconds = final_time % 60
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, format("%d:%02d", minutes, seconds), "", "", false)
                } else if (file.cp_table[ent] != < 29888.7, 8096.3, 50430.7 > ) {
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, "CHECKPOINT", "", "", false)
                }
                file.cp_table[ent] <-  < 29888.7, 8096.3, 50430.7 >
                    file.cp_angle[ent] <-  < 0, 0, 0 >
            }
        })
    DispatchSpawn(trigger)
    trigger = MapEditor_CreateTrigger( < 29904.6, 3347, 49747 > , < 0, 0, 0 > , 3421.75, 50, false)
    trigger.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValidPlayer(ent) && !ent.IsNoclipping())
                ent.SetOrigin(file.cp_table[ent])
        })
    DispatchSpawn(trigger)
    trigger = MapEditor_CreateTrigger( < 34478.6, 5969, 49747 > , < 0, 0, 0 > , 3500, 50, false)
    trigger.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValidPlayer(ent) && !ent.IsNoclipping())
                ent.SetOrigin(file.cp_table[ent])
        })
    DispatchSpawn(trigger)
    trigger = MapEditor_CreateTrigger( < 33227.1, 8241, 50552 > , < 0, -89.9998, 0 > , 62.5, 50, false)
    trigger.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValidPlayer(ent)) {
                int gen = ent.GetPersistentVarAsInt("gen")
                if (gen != 0) {
                    float final_time = Time() - gen
                    float minutes = final_time / 60
                    float seconds = final_time % 60
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, format("%d:%02d", minutes, seconds), "", "", false)
                } else if (file.cp_table[ent] != < 33187.7, 8120.1, 50552 > ) {
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, "CHECKPOINT", "", "", false)
                }
                file.cp_table[ent] <-  < 33187.7, 8120.1, 50552 >
                    file.cp_angle[ent] <-  < 0, 0.0002, 0 >
            }
        })
    DispatchSpawn(trigger)
    trigger = MapEditor_CreateTrigger( < 33227.1, 7995.2, 50552 > , < 0, -89.9998, 0 > , 62.5, 50, false)
    trigger.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValidPlayer(ent)) {
                int gen = ent.GetPersistentVarAsInt("gen")
                if (gen != 0) {
                    float final_time = Time() - gen
                    float minutes = final_time / 60
                    float seconds = final_time % 60
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, format("%d:%02d", minutes, seconds), "", "", false)
                } else if (file.cp_table[ent] != < 33187.7, 8120, 50552 > ) {
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, "CHECKPOINT", "", "", false)
                }
                file.cp_table[ent] <-  < 33187.7, 8120, 50552 >
                    file.cp_angle[ent] <-  < 0, 0.0002, 0 >
            }
        })
    DispatchSpawn(trigger)
    trigger = MapEditor_CreateTrigger( < 29890.6, 840.1001, 50215.4 > , < 0, 0, 0 > , 180, 50, false)
    trigger.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValidPlayer(ent)) {
                int gen = ent.GetPersistentVarAsInt("gen")
                if (gen != 0) {
                    float final_time = Time() - gen
                    float minutes = final_time / 60
                    float seconds = final_time % 60
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, format("%d:%02d", minutes, seconds), "", "", false)
                } else if (file.cp_table[ent] != < 29890.6, 840.1001, 50215.4 > ) {
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, "CHECKPOINT", "", "", false)
                }
                file.cp_table[ent] <-  < 29890.6, 840.1001, 50215.4 >
                    file.cp_angle[ent] <-  < 0, 90, 0 >
            }
        })
    DispatchSpawn(trigger)
    trigger = MapEditor_CreateTrigger( < 35335.7, 5379.2, 53147.5 > , < 0, -179.9997, 0 > , 125, 50, false)
    trigger.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValidPlayer(ent)) {
                int gen = ent.GetPersistentVarAsInt("gen")
                if (gen != 0) {
                    float final_time = Time() - gen
                    float minutes = final_time / 60
                    float seconds = final_time % 60
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, format("%d:%02d", minutes, seconds), "", "", false)
                } else if (file.cp_table[ent] != < 35335.7, 5379.2, 53147.5 > ) {
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, "CHECKPOINT", "", "", false)
                }
                file.cp_table[ent] <-  < 35335.7, 5379.2, 53147.5 >
                    file.cp_angle[ent] <-  < 0, -89.9997, 0 >
            }
        })
    DispatchSpawn(trigger)
    trigger = MapEditor_CreateTrigger( < 29888.7, 4857.4, 50429.8 > , < 0, 0, 0 > , 75, 50, false)
    trigger.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValidPlayer(ent)) {
                int gen = ent.GetPersistentVarAsInt("gen")
                if (gen != 0) {
                    float final_time = Time() - gen
                    float minutes = final_time / 60
                    float seconds = final_time % 60
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, format("%d:%02d", minutes, seconds), "", "", false)
                } else if (file.cp_table[ent] != < 29888.7, 4857.4, 50429.8 > ) {
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, "CHECKPOINT", "", "", false)
                }
                file.cp_table[ent] <-  < 29888.7, 4857.4, 50429.8 >
                    file.cp_angle[ent] <-  < 0, 90, 0 >
            }
        })
    DispatchSpawn(trigger)
    trigger = MapEditor_CreateTrigger( < 35335.7, 7475.8, 52070.9 > , < 0, -179.9997, 0 > , 125, 50, false)
    trigger.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValidPlayer(ent)) {
                int gen = ent.GetPersistentVarAsInt("gen")
                if (gen != 0) {
                    float final_time = Time() - gen
                    float minutes = final_time / 60
                    float seconds = final_time % 60
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, format("%d:%02d", minutes, seconds), "", "", false)
                } else if (file.cp_table[ent] != < 35335.7, 7475.8, 52070.9 > ) {
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, "CHECKPOINT", "", "", false)
                }
                file.cp_table[ent] <-  < 35335.7, 7475.8, 52070.9 >
                    file.cp_angle[ent] <-  < 0, -89.9997, 0 >
            }
        })
    DispatchSpawn(trigger)
    trigger = MapEditor_CreateTrigger( < 35335.7, 7748.2, 51434.4 > , < 0, 0, 0 > , 112.5, 50, false)
    trigger.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValidPlayer(ent)) {
                int gen = ent.GetPersistentVarAsInt("gen")
                if (gen != 0) {
                    float final_time = Time() - gen
                    float minutes = final_time / 60
                    float seconds = final_time % 60
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, format("%d:%02d", minutes, seconds), "", "", false)
                } else if (file.cp_table[ent] != < 35335.7, 7670.8, 51434.4 > ) {
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, "CHECKPOINT", "", "", false)
                }
                file.cp_table[ent] <-  < 35335.7, 7670.8, 51434.4 >
                    file.cp_angle[ent] <-  < 0, 90, 0 >
            }
        })
    DispatchSpawn(trigger)
    trigger = MapEditor_CreateTrigger( < 35335.7, 6974.2, 52613 > , < 0, -179.9997, 0 > , 125, 50, false)
    trigger.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValidPlayer(ent)) {
                int gen = ent.GetPersistentVarAsInt("gen")
                if (gen != 0) {
                    float final_time = Time() - gen
                    float minutes = final_time / 60
                    float seconds = final_time % 60
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, format("%d:%02d", minutes, seconds), "", "", false)
                } else if (file.cp_table[ent] != < 35335.7, 6974.2, 52613 > ) {
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, "CHECKPOINT", "", "", false)
                }
                file.cp_table[ent] <-  < 35335.7, 6974.2, 52613 >
                    file.cp_angle[ent] <-  < 0, -89.9997, 0 >
            }
        })
    DispatchSpawn(trigger)
    trigger = MapEditor_CreateTrigger( < 29890.6, -930, 50109 > , < 0, 0, 0 > , 180, 50, false)
    trigger.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValidPlayer(ent)) {
                int gen = ent.GetPersistentVarAsInt("gen")
                if (gen != 0) {
                    float final_time = Time() - gen
                    float minutes = final_time / 60
                    float seconds = final_time % 60
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, format("%d:%02d", minutes, seconds), "", "", false)
                }
                file.cp_table[ent] <-  < 29890.6, -930, 50109 >
                    file.cp_angle[ent] <-  < 0, 90, 0 >
            }
        })
    DispatchSpawn(trigger)
    trigger = MapEditor_CreateTrigger( < 35332.5, 4338.7, 50904.1 > , < 0, 0, 0 > , 125, 50, false)
    trigger.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValidPlayer(ent)) {
                int gen = ent.GetPersistentVarAsInt("gen")
                if (gen != 0) {
                    float final_time = Time() - gen
                    float minutes = final_time / 60
                    float seconds = final_time % 60
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, format("%d:%02d", minutes, seconds), "", "", false)
                } else if (file.cp_table[ent] != < 35332.5, 4338.7, 50904.1 > ) {
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, "CHECKPOINT", "", "", false)
                }
                file.cp_table[ent] <-  < 35332.5, 4338.7, 50904.1 >
                    file.cp_angle[ent] <-  < 0, 90, 0 >
                    file.last_cp[ent] <- true
            }
        })
    DispatchSpawn(trigger)
    trigger = MapEditor_CreateTrigger( < 34242.6, 8115, 50250 > , < 0, 0, 0 > , 1000, 50, false)
    trigger.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValidPlayer(ent) && !ent.IsNoclipping())
                ent.SetOrigin(file.cp_table[ent])
        })
    DispatchSpawn(trigger)
    trigger = MapEditor_CreateTrigger( < 35469.6, 6588, 51885 > , < 0, 0, 0 > , 1000, 5, false)
    trigger.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValidPlayer(ent) && !ent.IsNoclipping())
                ent.SetOrigin(file.cp_table[ent])
        })
    DispatchSpawn(trigger)
    trigger = MapEditor_CreateTrigger( < 29904.6, 8097, 49747 > , < 0, 0, 0 > , 3421.75, 50, false)
    trigger.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValidPlayer(ent) && !ent.IsNoclipping())
                ent.SetOrigin(file.cp_table[ent])
        })
    DispatchSpawn(trigger)
}