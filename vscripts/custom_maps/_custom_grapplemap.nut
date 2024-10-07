untyped
globalize_all_functions

// Made by Loy. 

void
function grapplemap_precache() {
    PrecacheModel($"mdl/desertlands/desertlands_cafeteria_table_02.rmdl")
    PrecacheModel($"mdl/desertlands/construction_bldg_platform_01.rmdl")
    PrecacheModel($"mdl/desertlands/desertlands_city_slanted_building_01_wall_pillar_64.rmdl")
    PrecacheModel($"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape.rmdl")
    PrecacheModel($"mdl/beacon/beacon_fence_sign_01.rmdl")
    PrecacheModel($"mdl/beacon/construction_scaff_128_64_64.rmdl")
    PrecacheModel($"mdl/barriers/guard_rail_01_256.rmdl")
    PrecacheModel($"mdl/signs/street_sign_arrow.rmdl")
    PrecacheModel($"mdl/robots/drone_frag/drone_frag.rmdl")
    PrecacheModel($"mdl/door/canyonlands_door_single_02_hinges.rmdl")
    PrecacheModel($"mdl/desertlands/highrise_square_top_01.rmdl")
    PrecacheModel($"mdl/barriers/guard_rail_01_128.rmdl")
    PrecacheModel($"mdl/containers/plastic_pallet_01.rmdl")
    PrecacheModel($"mdl/domestic/farmland_mattress_01.rmdl")
    PrecacheModel($"mdl/desertlands/construction_bldg_platform_02.rmdl")
    PrecacheModel($"mdl/desertlands/construction_bldg_platform_03.rmdl")
    PrecacheModel($"mdl/desertlands/construction_bldg_column_stack_01.rmdl")
    PrecacheModel($"mdl/desertlands/desertlands_lobby_double_doorframe_01.rmdl")
    PrecacheModel($"mdl/fx/core_energy.rmdl")
    PrecacheModel($"mdl/vehicles_r5/land_med/msc_freight_tortus_mod/veh_land_msc_freight_tortus_mod_cargo_holder_v1_static.rmdl")
    PrecacheModel($"mdl/desertlands/icelandic_moss_mod_01.rmdl")
    PrecacheModel($"mdl/desertlands/desertlands_lobby_double_doorframe_02.rmdl")
    PrecacheModel($"mdl/garbage/trash_bin_single_wtrash.rmdl")
    PrecacheModel($"mdl/desertlands/construction_bldg_column_01.rmdl")
    PrecacheModel($"mdl/desertlands/desertlands_train_station_interior_light_04.rmdl")
    PrecacheModel($"mdl/beacon/construction_scaff_segment_128_64.rmdl")
    PrecacheModel($"mdl/desertlands/construction_bldg_platform_04_corner.rmdl")
    PrecacheModel($"mdl/industrial/zipline_arm.rmdl")
    PrecacheModel($"mdl/industrial/security_fence_post.rmdl")
    PrecacheModel($"mdl/barriers/concrete/concrete_barrier_fence.rmdl")
    PrecacheModel($"mdl/garbage/trash_bin_single_wtrash_Blue.rmdl")
}


struct {
    table < entity, vector > cp_table = {}
    vector first_cp = < 0, -2, 20100 >
}
file

void
function grapplemap_init() {
    AddCallback_OnClientConnected(grapplemap_player_setup)
    AddCallback_EntitiesDidLoad(GrappleMapEntitiesDidLoad)
    grapplemap_precache()
}

void
function GrappleMapEntitiesDidLoad() {
    thread grapplemap_load()
}

void
function grapplemap_SpawnInfoText(entity player) {
    FlagWait("EntitiesDidLoad")
    wait 1
    CreatePanelText(player, "1", "Hint: over the bubble, slide jump through ring", <- 6.1387, -58.8598, 20134.77 > , < 0, -89.9999, 0 > , false, 1)
    CreatePanelText(player, "2", "Hint: over the wall and forward", < 3206, 0, 19912 > , < 0, 0, 0 > , false, 1)
    CreatePanelText(player, "3", "Hint: over the wall and forward", < 5469, 0, 20923 > , < 0, 0, 0 > , false, 1)
    CreatePanelText(player, "4", "Hint: around the bubble from the right", < 7453.562, -49.6098, 21938.04 > , < 0, -89.9999, 0 > , false, 1)
    CreatePanelText(player, "5", "Hint: slide down, grapple up", < 8874.461, 1932.34, 21943.77 > , < 0, -45, 0 > , false, 1)
    CreatePanelText(player, "6", "Hint: slide jump, grapple up", < 9909.262, 2341.19, 22534.64 > , < 0, 90, 0 > , false, 1)
    CreatePanelText(player, "7", "Hint: slide jump, grapple up", < 9178.661, 2005.08, 23534.5 > , < 0, -90, 0 > , false, 1)
    CreatePanelText(player, "8", "Hint: slide jump, grapple up", < 9909.722, 2340.67, 24577.46 > , < 0, 90, 0 > , false, 1)
    CreatePanelText(player, "9", "Hint: run off the platform, looking forward", < 9169.692, 2005.39, 25571.64 > , < 0, -90, 0 > , false, 1)
    CreatePanelText(player, "10", "Hint: superglide", < 18458.53, 1988.69, 17881.73 > , < 0, -90, 0 > , false, 1)
    CreatePanelText(player, "11", "Hint: slide off the platform", < 19488, -2259.8, 17888.8 > , < 0, 180, 0 > , false, 1)
    CreatePanelText(player, "12", "Hint: wait a little before the 2nd jump", < 19490.3, -5511.4, 17613.2 > , < 0, -180, 0 > , false, 1)
    CreatePanelText(player, "13", "Hint: Hyper Jump", < 19487.4, -9029.3, 17781.7 > , < 0, 180, 0 > , false, 1)
    CreatePanelText(player, "14", "Hint: be like Spiderman", < 19550.7, -9804.5, 18216 > , < 0, 180, 0 > , false, 1)
    CreatePanelText(player, "15", "Hint: Slide Grapple", < 18940.8, -15315, 18308 > , < 0, -180, 0 > , false, 1)
    CreatePanelText(player, "Loy", "Made by:", <- 6.1387, 55.8902, 20134.77 > , < 0, 90, 0 > , false, 1)
}

void
function grapplemap_player_setup(entity player) {
    if (!IsValidPlayer(player))
		return

	CharacterSelect_AssignCharacter( ToEHI( player ), GetAllCharacters()[7] )

	ItemFlavor playerCharacter = LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_CharacterClass() )
	asset characterSetFile = CharacterClass_GetSetFile( playerCharacter )
	player.SetPlayerSettingsWithMods( characterSetFile, [] )
	player.TakeOffhandWeapon(OFFHAND_TACTICAL)
	player.TakeOffhandWeapon(OFFHAND_ULTIMATE)
    player.SetPlayerNetBool("pingEnabled", false)
    player.SetPersistentVar("gen", 0)
    player.SetOrigin(file.first_cp)
    TakeAllPassives(player)
    TakeAllWeapons(player)
    player.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
    player.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
    player.SetSuitGrapplePower(100)
    player.SetAngles( < 0, -90, 0 > )
    LocalMsg(player, "#FS_STRING_VAR", "", 9, 5.0, "It Hurts Map", "By: Loy Takian", "", false)

    thread grapplemap_SpawnInfoText(player)
}


void
function grapplemap_load() {

    // Props Array
    array < entity > InvisibleArray;
    array < entity > NoGrappleArray;
    array < entity > NoGrappleNoClimbArray;

    // Props
    NoGrappleArray.append(MapEditor_CreateProp($"mdl/beacon/beacon_fence_sign_01.rmdl", < 3059, 0, 19835.5 > , < 0, 0, 90 > , true, 50000, -1, 1))
    NoGrappleArray.append(MapEditor_CreateProp($"mdl/containers/plastic_pallet_01.rmdl", < 5128.6, 0, 20849.4 > , < 0, 0, 180 > , true, 50000, -1, 1))
    MapEditor_CreateProp($"mdl/fx/core_energy.rmdl", < 3217, 0.0001, 20745.4 > , < 0, 0, 0 > , true, 50000, -1, 1.215689)
    MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_01.rmdl", < 3219.4, 178, 20854 > , <- 90, 0, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/signs/street_sign_arrow.rmdl", < 3218.6, 0.4995, 20506 > , <- 90, 90, 0 > , true, 50000, -1, 2.0248)
    MapEditor_CreateProp($"mdl/signs/street_sign_arrow.rmdl", < 3218.6, 0.4995, 20122 > , <- 90, 90, 0 > , true, 50000, -1, 2.0248)
    NoGrappleArray.append(MapEditor_CreateProp($"mdl/containers/plastic_pallet_01.rmdl", < 7389.6, -2, 21861.4 > , < 0, 0, 180 > , true, 50000, -1, 1))
    NoGrappleArray.append(MapEditor_CreateProp($"mdl/beacon/beacon_fence_sign_01.rmdl", < 5320, -2, 20847.5 > , < 0, 0, 90 > , true, 50000, -1, 1))
    MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_01.rmdl", < 5480.4, 176, 21866 > , <- 90, 0, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/fx/core_energy.rmdl", < 5480.3, -1.9999, 21773 > , < 0, 0, 0 > , true, 50000, -1, 1.215689)
    MapEditor_CreateProp($"mdl/signs/street_sign_arrow.rmdl", < 5479.6, -1.5005, 21528 > , <- 90, 90, 0 > , true, 50000, -1, 2.0248)
    MapEditor_CreateProp($"mdl/signs/street_sign_arrow.rmdl", < 5479.6, -1.5005, 21144 > , <- 90, 90, 0 > , true, 50000, -1, 2.0248)
    NoGrappleArray.append(MapEditor_CreateProp($"mdl/containers/plastic_pallet_01.rmdl", < 8641.5, 1818.9, 21862.2 > , < 0, -90, 180 > , true, 50000, -1, 1))
    NoGrappleArray.append(MapEditor_CreateProp($"mdl/beacon/beacon_fence_sign_01.rmdl", < 7581.7, -4, 21861.3 > , < 0, 0, 90 > , true, 50000, -1, 1))
    MapEditor_CreateProp($"mdl/signs/street_sign_arrow.rmdl", < 8404.3, -9.0983, 22179.5 > , < 0, 90, 0 > , true, 50000, -1, 1.7327)
    MapEditor_CreateProp($"mdl/robots/drone_frag/drone_frag.rmdl", < 8401.9, -10, 22164 > , < 0, -180, -180 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/fx/core_energy.rmdl", < 8402, -10.0001, 22130.4 > , < 0, -180, 0 > , true, 50000, -1, 1.215689)
    NoGrappleArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_04_corner.rmdl", < 8462.2, 1851.2, 21866.2 > , < 0, -179.9999, 0 > , true, 50000, -1, 1))
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_128.rmdl", < 8476.907, 1906.799, 21880.6 > , < 0, 0, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_128.rmdl", < 8892.2, 2332.3, 21880.8 > , < 0, -90, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 8554.8, 2069.4, 21880.8 > , < 0, -45, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 8739.4, 2254, 21880.8 > , < 0, -45, 0 > , true, 50000, -1, 1)
    NoGrappleArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_02.rmdl", < 9549.8, 2347.21, 21866 > , < 0, 0, 0 > , true, 50000, -1, 1))
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 9086.1, 2335.2, 21879.1 > , < 0, -89.9999, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 10334, 2337, 25500 > , < 0, -89.9999, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 9381.896, 2335.2, 21879.1 > , < 0, -89.9999, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 10054.6, 2337.2, 25500 > , < 0, -89.9999, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/signs/street_sign_arrow.rmdl", < 9059, 2173.396, 22995 > , < 90, -90.0001, 0 > , true, 50000, -1, 3.004)
    MapEditor_CreateProp($"mdl/signs/street_sign_arrow.rmdl", < 10035.6, 2173.4, 22272.1 > , < 90, 90, 0 > , true, 50000, -1, 3.004)
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 9465.8, 2007, 25500 > , < 0, 90, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 9758.8, 2337.2, 25500 > , < 0, -89.9999, 0 > , true, 50000, -1, 1)
    NoGrappleArray.append(MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 9475, 2007, 23463 > , < 0, 90, 0 > , true, 50000, -1, 1))
    MapEditor_CreateProp($"mdl/signs/street_sign_arrow.rmdl", < 9059, 2173.396, 23255.1 > , < 90, -90.0001, 0 > , true, 50000, -1, 3.004)
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 9911, 2007, 22463 > , < 0, 90, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 9911, 2007, 24505.8 > , < 0, 90, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/signs/street_sign_arrow.rmdl", < 10035.6, 2173.4, 22012 > , < 90, 90, 0 > , true, 50000, -1, 3.004)
    NoGrappleArray.append(MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 9614.3, 2337.2, 22463 > , < 0, -89.9999, 0 > , true, 50000, -1, 1))
    NoGrappleArray.append(MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 9615.2, 2007, 22463 > , < 0, 90, 0 > , true, 50000, -1, 1))
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 10055.5, 2007, 25500 > , < 0, 90, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 9179.2, 2007, 23463 > , < 0, 90, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/signs/street_sign_arrow.rmdl", < 9059, 2173.396, 25309.8 > , < 90, -90.0001, 0 > , true, 50000, -1, 3.004)
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 9170, 2007, 25500 > , < 0, 90, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_128.rmdl", < 10545.1, 2011.721, 25500.9 > , < 0, 90, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/signs/street_sign_arrow.rmdl", < 9059, 2173.396, 25049.7 > , < 90, -90.0001, 0 > , true, 50000, -1, 3.004)
    NoGrappleArray.append(MapEditor_CreateProp($"mdl/signs/street_sign_arrow.rmdl", < 10946, 2173.5, 25630 > , < 90, 90, 0 > , true, 50000, -1, 2.581074))
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 9910.097, 2337.2, 22463 > , < 0, -89.9999, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/signs/street_sign_arrow.rmdl", < 10035.6, 2173.4, 24305.1 > , < 90, 90, 0 > , true, 50000, -1, 3.004)
    MapEditor_CreateProp($"mdl/signs/street_sign_arrow.rmdl", < 10035.6, 2173.4, 24045 > , < 90, 90, 0 > , true, 50000, -1, 3.004)
    NoGrappleArray.append(MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 9474.097, 2337.2, 23463 > , < 0, -89.9999, 0 > , true, 50000, -1, 1))
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 9910.097, 2337.2, 24505.8 > , < 0, -89.9999, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 9464.896, 2337.2, 25500 > , < 0, -89.9999, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_128.rmdl", < 10545.1, 2331.6, 25500.9 > , < 0, -90, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 9169.1, 2337.2, 25500 > , < 0, -89.9999, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 9382.8, 2005, 21879.1 > , < 0, 90, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 10334.9, 2006.8, 25500 > , < 0, 90, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 9087, 2005, 21879.1 > , < 0, 90, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 9178.3, 2337.2, 23463 > , < 0, -89.9999, 0 > , true, 50000, -1, 1)
    NoGrappleArray.append(MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 9614.3, 2337.2, 24505.8 > , < 0, -89.9999, 0 > , true, 50000, -1, 1))
    NoGrappleArray.append(MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 9615.2, 2007, 24505.8 > , < 0, 90, 0 > , true, 50000, -1, 1))
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 9759.7, 2007, 25500 > , < 0, 90, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/fx/core_energy.rmdl", < 10542.35, 2173.4, 21839.18 > , < 0, 0, 0 > , true, 50000, -1, 1)
    NoGrappleArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_02.rmdl", < 10059.8, 2349, 22455 > , < 0, 0, 0 > , true, 50000, -1, 1))
    MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_02.rmdl", < 10602, 2349, 21863 > , < 0, 0, 0 > , true, 50000, -1, 1)
    NoGrappleArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_02.rmdl", < 10060, 1996.998, 22455 > , <- 90, -180, 0 > , true, 50000, -1, 1))
    NoGrappleArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_02.rmdl", < 9034.202, 1996.992, 23450 > , < 0, -180, 0 > , true, 50000, -1, 1))
    NoGrappleArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_02.rmdl", < 9034.001, 2348.994, 23450 > , <- 90, 0, 0 > , true, 50000, -1, 0.9999995))
    MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_02.rmdl", < 8492.002, 1996.991, 22858 > , < 0, -180, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/fx/core_energy.rmdl", < 8552.502, 2172.991, 22835.78 > , < 0, 0, 0 > , true, 50000, -1, 1)
    NoGrappleArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_02.rmdl", < 10060, 1996.998, 24492 > , <- 90, -180, 0 > , true, 50000, -1, 1))
    MapEditor_CreateProp($"mdl/fx/core_energy.rmdl", < 10542.36, 2172.991, 23875.8 > , < 0, 0, 0 > , true, 50000, -1, 1)
    NoGrappleArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_02.rmdl", < 10059.8, 2349, 24492 > , < 0, 0, 0 > , true, 50000, -1, 1))
    MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_02.rmdl", < 10602, 2349, 23900 > , < 0, 0, 0 > , true, 50000, -1, 1)
    NoGrappleArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_02.rmdl", < 9034.001, 2348.994, 25487.6 > , <- 90, 0, 0 > , true, 50000, -1, 0.9999995))
    MapEditor_CreateProp($"mdl/fx/core_energy.rmdl", < 8552.042, 2172.991, 24872.8 > , < 0, 0, 0 > , true, 50000, -1, 1)
    NoGrappleArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_02.rmdl", < 9034.202, 1996.992, 25487.6 > , < 0, -180, 0 > , true, 50000, -1, 1))
    MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_02.rmdl", < 8492.002, 1996.991, 24895.6 > , < 0, -180, 0 > , true, 50000, -1, 1)
    NoGrappleArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_01.rmdl", < 9626, 1997, 25487.6 > , < 0, -180, 0 > , true, 50000, -1, 1))
    MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_01.rmdl", < 12298, 2337, 18734 > , < 50, 0, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/desertlands/icelandic_moss_mod_01.rmdl", < 15938, 2151, 18020.2 > , < 0, 0, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/fx/core_energy.rmdl", < 15938, 2151, 18017 > , < 0, 0, 0 > , true, 50000, -1, 3.9513)
    MapEditor_CreateProp($"mdl/beacon/beacon_fence_sign_01.rmdl", < 12280.6, 2164, 18772 > , < 0, -90.0001, 59.9873 > , true, 50000, -1, 1)
    NoGrappleArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_01.rmdl", < 19334, 2331, 17798 > , < 0, 0, 0 > , true, 50000, -1, 1))
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 18754.1, 2321.2, 17810 > , < 0, -89.9999, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 19033.5, 2321, 17810 > , < 0, -89.9999, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 19034.4, 1990.8, 17810 > , < 0, 90, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 18755, 1991, 17810 > , < 0, 90, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 18458.3, 2321.2, 17810 > , < 0, -89.9999, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_128.rmdl", < 19244.6, 2315.6, 17810.9 > , < 0, -90, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_128.rmdl", < 19244.6, 1995.721, 17810.9 > , < 0, 90, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 18459.2, 1991, 17810 > , < 0, 90, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 19487.8, 1390.097, 17810 > , < 0, 0, 0 > , true, 50000, -1, 0.9999998)
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_128.rmdl", < 19812.32, 1901.001, 17812.4 > , < 0, -179.9998, 0 > , true, 50000, -1, 0.9999995)
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_128.rmdl", < 19386.82, 2316.293, 17812.2 > , < 0, -89.9999, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 19818, 1686.794, 17810 > , < 0, -179.9999, 0 > , true, 50000, -1, 0.9999998)
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 19487.8, 1685.896, 17810 > , < 0, 0, 0 > , true, 50000, -1, 0.9999998)
    NoGrappleArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_04_corner.rmdl", < 19331.22, 2331, 17797.8 > , < 0, 90.0003, 0 > , true, 50000, -1, 1))
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 19734.02, 2053.801, 17812.4 > , < 0, -134.9998, 0 > , true, 50000, -1, 0.9999998)
    NoGrappleArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_02.rmdl", < 19827, 1249.996, 17798 > , < 0, -90, 0 > , true, 50000, -1, 1))
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 19549.42, 2238.4, 17812.4 > , < 0, -134.9998, 0 > , true, 50000, -1, 0.9999998)
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 19818, 1390.996, 17810 > , < 0, -179.9999, 0 > , true, 50000, -1, 0.9999998)
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_128.rmdl", < 19407.32, 1920.2, 17811.1 > , < 0, 44.9999, 0 > , true, 50000, -1, 0.9999996)
    NoGrappleArray.append(MapEditor_CreateProp($"mdl/containers/plastic_pallet_01.rmdl", < 19654.8, -1932.1, 17798 > , < 0, -90, 180 > , true, 50000, -1, 1))
    NoGrappleArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_04_corner.rmdl", < 19299, 1159, 17804 > , < 0, 135.0001, 0 > , true, 50000, -1, 1))
    MapEditor_CreateProp($"mdl/barriers/concrete/concrete_barrier_fence.rmdl", < 19649.4, 911.9, 17777.2 > , < 0, -90, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/robots/drone_frag/drone_frag.rmdl", < 19633, -365.6, 18015.1 > , < 0, 0, -180 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/fx/core_energy.rmdl", < 19632.9, -365.5999, 17981.5 > , < 0, 0, 0 > , true, 50000, -1, 1.215689)
    MapEditor_CreateProp($"mdl/fx/core_energy.rmdl", < 19647.7, -7330, 17794 > , < 0, 0, 0 > , true, 50000, -1, 1.908314)
    NoGrappleArray.append(MapEditor_CreateProp($"mdl/containers/plastic_pallet_01.rmdl", < 19649.8, -8696, 17686 > , < 0, -90, 180 > , true, 50000, -1, 1))
    MapEditor_CreateProp($"mdl/desertlands/icelandic_moss_mod_01.rmdl", < 19647.7, -7330, 17784 > , < 0, 0, 0 > , true, 50000, -1, 1)
    NoGrappleArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_01.rmdl", < 19831.7, -6242.5, 17515 > , < 0, -90, 0 > , true, 50000, -1, 1))
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 19492.2, -5659, 17528.7 > , < 0, 0, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 19822.39, -5658.101, 17528.7 > , < 0, -179.9999, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 19492.2, -5363.202, 17528.7 > , < 0, 0, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 19822.2, -5937.508, 17528.7 > , < 0, -179.9999, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 19492, -5938.411, 17528.7 > , < 0, 0, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 19822.4, -5362.308, 17528.7 > , < 0, -179.9999, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_128.rmdl", < 19496.92, -6148.604, 17529.6 > , < 0, 0, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_128.rmdl", < 19816.8, -6148.599, 17529.6 > , < 0, -180, 0 > , true, 50000, -1, 1)
    NoGrappleArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_01.rmdl", < 19831.7, -9751, 17690 > , < 0, -90, 0 > , true, 50000, -1, 1))
    NoGrappleArray.append(MapEditor_CreateProp($"mdl/containers/plastic_pallet_01.rmdl", < 19656.5, -9822.9, 18143 > , < 0, -90, 180 > , true, 50000, -1, 1))
    NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_04_corner.rmdl", < 20004, -9661, 17686 > , < 0, -45, 0 > , true, 50000, -1, 1))
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_128.rmdl", < 19496.92, -9666.604, 17704.6 > , < 0, 0, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 19492.2, -8881.201, 17703.7 > , < 0, 0, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_128.rmdl", < 19816.8, -9666.599, 17704.6 > , < 0, -180, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 19822.4, -8880.308, 17703.7 > , < 0, -179.9999, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 19492.2, -9177, 17703.7 > , < 0, 0, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 19822.2, -9455.508, 17703.7 > , < 0, -179.9999, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 19492, -9456.411, 17703.7 > , < 0, 0, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 19822.39, -9176.102, 17703.7 > , < 0, -179.9999, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/industrial/security_fence_post.rmdl", < 19353.7, -9669, 17685 > , < 0, 0, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/industrial/zipline_arm.rmdl", < 19352.7, -9668.2, 17885 > , < 0, -90, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/industrial/security_fence_post.rmdl", < 19953.7, -9669, 17685 > , < 0, -180, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/industrial/zipline_arm.rmdl", < 19954.7, -9669.8, 17885 > , < 0, 90, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_01.rmdl", < 19224.7, -16165.5, 18236 > , < 0, -90, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/beacon/construction_scaff_segment_128_64.rmdl", < 19127.4, -16156.1, 18232.7 > , < 0, 0.0001, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/beacon/construction_scaff_128_64_64.rmdl", < 18906.7, -15992.6, 18229.9 > , < 0, 0, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_stack_01.rmdl", < 18899.4, -15877.3, 18235.7 > , < 0, 0, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_stack_01.rmdl", < 18899.4, -15727.8, 18235.7 > , < 0, 0, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/beacon/construction_scaff_128_64_64.rmdl", < 19192.2, -15315.05, 18235.6 > , < 0, 0, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < 18873, -15198, 18236 > , < 0, -180, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_stack_01.rmdl", < 19196.5, -15428.6, 18235.7 > , < 0, 0, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/garbage/trash_bin_single_wtrash.rmdl", < 18915.2, -15240.8, 18232.4 > , < 0, 90, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/garbage/trash_bin_single_wtrash.rmdl", < 19180.3, -15240.8, 18232.4 > , < 0, -90, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/beacon/construction_scaff_segment_128_64.rmdl", < 18971.2, -16156.1, 18232.7 > , < 0, -179.9999, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_stack_01.rmdl", < 18899.4, -15578.3, 18235.7 > , < 0, 0, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < 18930.6, -16109, 18236 > , < 0, 0.0001, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_stack_01.rmdl", < 18899.4, -15428.6, 18235.7 > , < 0, 0, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_stack_01.rmdl", < 19196.5, -15877.3, 18235.7 > , < 0, 0, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_03.rmdl", < 19227.1, -16164.9, 18386.6 > , < 0, -90, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_stack_01.rmdl", < 19196.5, -15578.3, 18235.7 > , < 0, 0, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_stack_01.rmdl", < 19196.5, -15727.8, 18235.7 > , < 0, 0, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/beacon/construction_scaff_segment_128_64.rmdl", < 18971.6, -15150.9, 18232.7 > , < 0, -180, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/beacon/construction_scaff_128_64_64.rmdl", < 19192.2, -15992.6, 18229.9 > , < 0, 0, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/garbage/trash_bin_single_wtrash_Blue.rmdl", < 19180.55, -16067.12, 18235.8 > , < 0, -90, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < 19168.4, -15198, 18236 > , < 0, -180, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/beacon/construction_scaff_128_64_64.rmdl", < 18906.7, -15315.05, 18235.6 > , < 0, 0, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/beacon/construction_scaff_segment_128_64.rmdl", < 19127.8, -15150.9, 18232.7 > , < 0, 0, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/garbage/trash_bin_single_wtrash_Blue.rmdl", < 18917.13, -16067.12, 18235.8 > , < 0, 90, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_03.rmdl", < 18872.96, -15141.9, 18386.6 > , < 0, 90, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_01.rmdl", < 19228, -16165.5, 18414 > , < 0, -90, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < 19226, -16109, 18236 > , < 0, 0.0001, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/desertlands/desertlands_lobby_double_doorframe_01.rmdl", < 19049.1, -16150.8, 18235.7 > , < 0, -180, 0 > , true, 50000, -1, 0.9999995)
    MapEditor_CreateProp($"mdl/desertlands/desertlands_lobby_double_doorframe_02.rmdl", < 19049.1, -16150.8, 18235.7 > , < 0, -180, 0 > , true, 50000, -1, 0.9999995)
    MapEditor_CreateProp($"mdl/door/canyonlands_door_single_02_hinges.rmdl", < 19114.1, -16155.8, 18287.7 > , < 0, 90, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/door/canyonlands_door_single_02_hinges.rmdl", < 18987.1, -16155.8, 18287.7 > , < 0, -90, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/desertlands/desertlands_lobby_double_doorframe_02.rmdl", < 19050.96, -15148.4, 18235.7 > , < 0, -180, 0 > , true, 50000, -1, 0.9999995)
    MapEditor_CreateProp($"mdl/desertlands/desertlands_lobby_double_doorframe_01.rmdl", < 19050.96, -15148.4, 18235.7 > , < 0, -180, 0 > , true, 50000, -1, 0.9999995)
    MapEditor_CreateProp($"mdl/door/canyonlands_door_single_02_hinges.rmdl", < 19115.96, -15153.4, 18287.7 > , < 0, 90.0001, 0 > , true, 50000, -1, 0.9999999)
    MapEditor_CreateProp($"mdl/door/canyonlands_door_single_02_hinges.rmdl", < 18988.96, -15153.4, 18287.7 > , < 0, -89.9999, 0 > , true, 50000, -1, 1)
    InvisibleArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_01.rmdl", < 19557, -15144.5, 18556 > , < 0, 0, -90 > , true, 50000, -1, 1))
    InvisibleArray.append(MapEditor_CreateProp($"mdl/desertlands/desertlands_city_slanted_building_01_wall_pillar_64.rmdl", < 18920.37, -15178.92, 18502.16 > , <- 0.0001, 90, 90 > , true, 50000, -1, 1))
    InvisibleArray.append(MapEditor_CreateProp($"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape.rmdl", < 18811.47, -15178.47, 18539 > , < 0, -89.9999, -179.9999 > , true, 50000, -1, 1))
    InvisibleArray.append(MapEditor_CreateProp($"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape.rmdl", < 19288.47, -15178.5, 18539 > , < 0, 90, 179.9999 > , true, 50000, -1, 1))
    InvisibleArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_01.rmdl", < 18533.01, -16159.23, 18556 > , < 0, -180, -90 > , true, 50000, -1, 1))
    InvisibleArray.append(MapEditor_CreateProp($"mdl/desertlands/desertlands_city_slanted_building_01_wall_pillar_64.rmdl", < 19169.64, -16124.81, 18502.16 > , <- 0.0001, -90, 90 > , true, 50000, -1, 1))
    InvisibleArray.append(MapEditor_CreateProp($"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape.rmdl", < 19278.54, -16125.26, 18539 > , < 0, 90.0002, -179.9999 > , true, 50000, -1, 1))
    InvisibleArray.append(MapEditor_CreateProp($"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape.rmdl", < 18801.54, -16125.23, 18539 > , < 0, -89.9999, 179.9999 > , true, 50000, -1, 1))
    NoGrappleArray.append(MapEditor_CreateProp($"mdl/vehicles_r5/land_med/msc_freight_tortus_mod/veh_land_msc_freight_tortus_mod_cargo_holder_v1_static.rmdl", < 0, -2, 20000 > , < 0, 0, 0 > , true, 50000, -1, 1))
    NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/desertlands_train_station_interior_light_04.rmdl", < 1670, -2, 20256.1 > , < 0, 0, 0 > , true, 50000, -1, 1))
    MapEditor_CreateProp($"mdl/fx/core_energy.rmdl", < 804, -1.9999, 20294 > , < 0, 0, 0 > , true, 50000, -1, 1.215689)
    MapEditor_CreateProp($"mdl/robots/drone_frag/drone_frag.rmdl", < 804.1, -2, 20327.6 > , < 0, 0, -180 > , true, 50000, -1, 1)
    InvisibleArray.append(MapEditor_CreateProp($"mdl/domestic/farmland_mattress_01.rmdl", < 1649.6, -2, 20140.7 > , < 0, -90, 0 > , true, 50000, -1, 1))
    InvisibleArray.append(MapEditor_CreateProp($"mdl/domestic/farmland_mattress_01.rmdl", < 1689.9, -2, 20140.7 > , < 0, -90, 0 > , true, 50000, -1, 1))
    NoGrappleArray.append(MapEditor_CreateProp($"mdl/containers/plastic_pallet_01.rmdl", < 2867, 1.8456, 19836 > , < 0, 0, 180 > , true, 50000, -1, 1))
    NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/desertlands_train_station_interior_light_04.rmdl", < 1670, -2, 20181.5 > , < 0, 0, 180 > , true, 50000, -1, 1))
    MapEditor_CreateProp($"mdl/robots/drone_frag/drone_frag.rmdl", < 19976.1, -14392.01, 18148.6 > , < 0, 0, -180 > , true, 50000, -1, 1)
    NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < 19995.95, -13675.46, 17467 > , < 0, 155, 90 > , true, 50000, -1, 0.9999999))
    NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < 20031.46, -12736.46, 19020 > , < 0, 20.0001, 90 > , true, 50000, -1, 0.9999999))
    MapEditor_CreateProp($"mdl/fx/core_energy.rmdl", < 19266.5, -11129, 18115 > , < 0, -180, 0 > , true, 50000, -1, 1.215689)
    NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < 19811.33, -11896.5, 19020 > , < 0, -25, 90 > , true, 50000, -1, 0.9999999))
    NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < 19811.33, -11896.5, 18243 > , < 0, -25, 90 > , true, 50000, -1, 0.9999999))
    NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < 19803.61, -12241.46, 17467 > , < 0, -159.9999, 90 > , true, 50000, -1, 0.9999999))
    NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < 19803.61, -12241.46, 18243 > , < 0, -159.9999, 90 > , true, 50000, -1, 0.9999999))
    NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < 19072.53, -12507.55, 19020 > , < 0, -159.9999, 90 > , true, 50000, -1, 0.9999999))
    NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < 19108.04, -11568.55, 18243 > , < 0, -25, 90 > , true, 50000, -1, 0.9999999))
    NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < 19108.04, -11568.55, 17467 > , < 0, -25, 90 > , true, 50000, -1, 0.9999999))
    MapEditor_CreateProp($"mdl/robots/drone_frag/drone_frag.rmdl", < 20376.55, -12156.86, 18153.6 > , < 0, -25, -180 > , true, 50000, -1, 1)
    NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < 18824.03, -13830.56, 17467 > , < 0, -25, 90 > , true, 50000, -1, 0.9999999))
    NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < 19803.61, -12241.46, 19020 > , < 0, -159.9999, 90 > , true, 50000, -1, 0.9999999))
    NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < 19292.66, -13347.51, 17467 > , < 0, 155, 90 > , true, 50000, -1, 0.9999999))
    NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < 18824.03, -13830.56, 18243 > , < 0, -25, 90 > , true, 50000, -1, 0.9999999))
    NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < 18824.03, -13830.56, 19020 > , < 0, -25, 90 > , true, 50000, -1, 0.9999999))
    MapEditor_CreateProp($"mdl/fx/core_energy.rmdl", < 19976, -14392.01, 18115 > , < 0, 0, 0 > , true, 50000, -1, 1.215689)
    NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < 19292.66, -13347.51, 18243 > , < 0, 155, 90 > , true, 50000, -1, 0.9999999))
    NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < 19995.95, -13675.46, 18243 > , < 0, 155, 90 > , true, 50000, -1, 0.9999999))
    NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < 19108.04, -11568.55, 19020 > , < 0, -25, 90 > , true, 50000, -1, 0.9999999))
    NoGrappleArray.append(MapEditor_CreateProp($"mdl/containers/plastic_pallet_01.rmdl", < 19054, -15114, 18233.5 > , < 0, -90, -180 > , true, 50000, -1, 1))
    MapEditor_CreateProp($"mdl/fx/core_energy.rmdl", < 18727.53, -13087.19, 18120 > , < 0, 155, 0 > , true, 50000, -1, 1.215689)
    NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < 19300.38, -13002.55, 18243 > , < 0, 20.0001, 90 > , true, 50000, -1, 0.9999999))
    NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < 19995.95, -13675.46, 19020 > , < 0, 155, 90 > , true, 50000, -1, 0.9999999))
    MapEditor_CreateProp($"mdl/fx/core_energy.rmdl", < 20376.46, -12156.82, 18120 > , < 0, -25, 0 > , true, 50000, -1, 1.215689)
    MapEditor_CreateProp($"mdl/robots/drone_frag/drone_frag.rmdl", < 18727.44, -13087.15, 18153.6 > , < 0, 155, -180 > , true, 50000, -1, 1)
    NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < 19527.32, -14158.52, 18243 > , < 0, -25, 90 > , true, 50000, -1, 0.9999999))
    NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < 19527.32, -14158.52, 19020 > , < 0, -25, 90 > , true, 50000, -1, 0.9999999))
    NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < 20031.46, -12736.46, 18243 > , < 0, 20.0001, 90 > , true, 50000, -1, 0.9999999))
    NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < 20031.46, -12736.46, 17467 > , < 0, 20.0001, 90 > , true, 50000, -1, 0.9999999))
    NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < 19811.33, -11896.5, 17467 > , < 0, -25, 90 > , true, 50000, -1, 0.9999999))
    NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < 19527.32, -14158.52, 17467 > , < 0, -25, 90 > , true, 50000, -1, 0.9999999))
    NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < 19072.53, -12507.55, 18243 > , < 0, -159.9999, 90 > , true, 50000, -1, 0.9999999))
    NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < 19300.38, -13002.55, 17467 > , < 0, 20.0001, 90 > , true, 50000, -1, 0.9999999))
    NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < 19292.66, -13347.51, 19020 > , < 0, 155, 90 > , true, 50000, -1, 0.9999999))
    NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < 19072.53, -12507.55, 17467 > , < 0, -159.9999, 90 > , true, 50000, -1, 0.9999999))
    NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < 19300.38, -13002.55, 19020 > , < 0, 20.0001, 90 > , true, 50000, -1, 0.9999999))
    MapEditor_CreateProp($"mdl/robots/drone_frag/drone_frag.rmdl", < 19266.4, -11129, 18148.6 > , < 0, -180, -180 > , true, 50000, -1, 1)
    NoGrappleArray.append(MapEditor_CreateProp($"mdl/beacon/beacon_fence_sign_01.rmdl", < 19654.4, -9990.8, 18061.6 > , < 30, -90, 90 > , true, 50000, -1, 1))
    NoGrappleArray.append(MapEditor_CreateProp($"mdl/containers/plastic_pallet_01.rmdl", < 19649.8, -5186, 17511 > , < 0, -90, 180 > , true, 50000, -1, 1))
    NoGrappleArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_01.rmdl", < 19831.7, -2990.5, 17804 > , < 0, -90, 0 > , true, 50000, -1, 1))
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 19822.4, -2108.896, 17810 > , < 0, -179.9999, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 19822.2, -2684.096, 17810 > , < 0, -179.9999, 0 > , true, 50000, -1, 1)
    NoGrappleArray.append(MapEditor_CreateProp($"mdl/signs/street_sign_arrow.rmdl", < 19659, -3398, 17891 > , < 90, 0, 0 > , true, 50000, -1, 1.6015))
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 19492.2, -2109.79, 17810 > , < 0, 0, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_128.rmdl", < 19496.92, -2895.192, 17810.9 > , < 0, 0, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 19822.39, -2404.69, 17810 > , < 0, -179.9999, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 19492.2, -2405.589, 17810 > , < 0, 0, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/fx/core_energy.rmdl", < 19647.3, -4286, 17124 > , < 0, 0, 0 > , true, 50000, -1, 1.215689)
    MapEditor_CreateProp($"mdl/robots/drone_frag/drone_frag.rmdl", < 19647.4, -4286, 17157.6 > , < 0, 0, -180 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_128.rmdl", < 19816.8, -2895.188, 17810.9 > , < 0, -180, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/barriers/guard_rail_01_256.rmdl", < 19492, -2685, 17810 > , < 0, 0, 0 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/desertlands/desertlands_cafeteria_table_02.rmdl", < 19038.9, -17656.8, 17871.9 > , < 0, -180, 30 > , true, 50000, -1, 1)
    MapEditor_CreateProp($"mdl/beacon/beacon_fence_sign_01.rmdl", < 19041.8, -17850.3, 17928.7 > , < 0, 90, 90.0001 > , true, 50000, -1, 1)

    //1
    Invis_Button( < 35, -60, 20124 > , < 0, 180, 0 > , true, < 2940.184, 4.6201, 19889.95 > , < 0, 0, 0 > , "")
    Invis_Button( <- 45, -60, 20124 > , < 0, 180, 0 > , false, < 19050.58, -15185.38, 18286.05 > , < 0, -130, 0 > , "")
    //2
    Invis_Button( < 3207.9, 39, 19900 > , < 0, -90, 0 > , true, < 5198.984, -1.1799, 20901.15 > , < 0, 0, 0 > , "")
    Invis_Button( < 3207.9, -39, 19900 > , < 0, -90, 0 > , false, file.first_cp, < 0, -90, 0 > , "")
    //3
    Invis_Button( < 5469, 39, 20910 > , < 0, -90, 0 > , true, < 7459.584, -1.1799, 21913.65 > , < 0, -90, 0 > , "")
    Invis_Button( < 5469, -39, 20910 > , < 0, -90, 0 > , false, < 2940.184, 4.6201, 19889.95 > , < 0, 0, 0 > , "")
    //4
    Invis_Button( < 7486, -49.6098, 21925 > , < 0, 180, 0 > , true, < 8724.584, 2009.62, 21913.65 > , < 0, -27, 0 > , "")
    Invis_Button( < 7420, -49.6098, 21925 > , < 0, 180, 0 > , false, < 5198.984, -1.1799, 20901.15 > , < 0, 0, 0 > , "")
    //5
    Invis_Button( < 8898.5, 1956.5, 21930 > , < 0, -135, 0 > , true, < 9893.584, 2172.02, 22509.65 > , < 0, 90, 0 > , "")
    Invis_Button( < 8851.3, 1909.3, 21930 > , < 0, -135, 0 > , false, < 7459.584, -1.1799, 21913.65 > , < 0, -90, 0 > , "")
    //6
    Invis_Button( < 9873.8, 2341, 22525 > , < 0, 0, 0 > , true, < 9201.884, 2172.02, 23502.65 > , < 0, -90, 0 > , "")
    Invis_Button( < 9943.6, 2341, 22525 > , < 0, 0, 0 > , false, < 8724.584, 2009.62, 21913.65 > , < 0, -27, 0 > , "")
    //7
    Invis_Button( < 9211, 2005, 23527 > , < 0, 180, 0 > , true, < 9893.584, 2172.02, 24542.65 > , < 0, 90, 0 > , "")
    Invis_Button( < 9147, 2005, 23527 > , < 0, 180, 0 > , false, < 9893.584, 2172.02, 22509.65 > , < 0, 90, 0 > , "")
    //8
    Invis_Button( < 9875.4, 2340, 24565 > , < 0, 0, 0 > , true, < 9200.584, 2172.02, 25537.65 > , < 0, -90, 0 > , "")
    Invis_Button( < 9945, 2340, 24565 > , < 0, 0, 0 > , false, < 9201.884, 2172.02, 23502.65 > , < 0, -90, 0 > , "")
    //9
    Invis_Button( < 9218, 2005, 25566 > , < 0, 180, 0 > , true, < 18476.58, 2155.62, 17846.65 > , < 0, -90, 0 > , "")
    Invis_Button( < 9120, 2005, 25566 > , < 0, 180, 0 > , false, < 9893.584, 2172.02, 24542.65 > , < 0, 90, 0 > , "")
    //10
    Invis_Button( < 18485, 1988, 17870 > , < 0, 180, 0 > , true, < 19656.58, -2070.18, 17856.35 > , < 0, -130, 0 > , "")
    Invis_Button( < 18430, 1988, 17870 > , < 0, 180, 0 > , false, < 9200.584, 2172.02, 25537.65 > , < 0, -90, 0 > , "")
    //11
    Invis_Button( < 19488, -2293, 17875 > , < 0, 90, 0 > , true, < 19656.58, -5318.38, 17566.65 > , < 0, -130, 0 > , "")
    Invis_Button( < 19488, -2225, 17875 > , < 0, 90, 0 > , false, < 18476.58, 2155.62, 17846.65 > , < 0, -90, 0 > , "")
    //12
    Invis_Button( < 19490.3, -5554, 17605 > , < 0, 90, 0 > , true, < 19656.58, -8828.38, 17741.65 > , < 0, -130, 0 > , "")
    Invis_Button( < 19490.3, -5464, 17605 > , < 0, 90, 0 > , false, < 19656.58, -2070.18, 17856.35 > , < 0, -130, 0 > , "")
    //13
    Invis_Button( < 19487.4, -9053.4, 17771.4 > , < 0, 90, 0 > , true, < 19657.18, -9823.58, 18196.25 > , < 0, 180, 0 > , "")
    Invis_Button( < 19487.4, -9003, 17771.4 > , < 0, 90, 0 > , false, < 19656.58, -5318.38, 17566.65 > , < 0, -130, 0 > , "")
    //14
    Invis_Button( < 19550.7, -9835, 18216 > , < 0, 90, 0 > , true, < 19050.58, -15185.38, 18286.05 > , < 0, -130, 0 > , "")
    Invis_Button( < 19550.7, -9755, 18216 > , < 0, 90, 0 > , false, < 19656.58, -8828.38, 17741.65 > , < 0, -130, 0 > , "")
    //15
    Invis_Button( < 18940.8, -15348, 18295 > , < 0, 90, 0 > , true, file.first_cp, < 0, -90, 0 > , "")
    Invis_Button( < 18940.8, -15292, 18295 > , < 0, 90, 0 > , false, < 19657.18, -9823.58, 18196.25 > , < 0, 180, 0 > , "")

    foreach(entity ent in InvisibleArray) ent.MakeInvisible()
    foreach(entity ent in NoGrappleArray) ent.kv.contents = CONTENTS_SOLID | CONTENTS_NOGRAPPLE
    foreach(entity ent in NoGrappleNoClimbArray) {
        ent.kv.solid = 3
        ent.kv.CollisionGroup = TRACE_COLLISION_GROUP_PLAYER
        ent.kv.contents = CONTENTS_SOLID | CONTENTS_NOGRAPPLE
    }

    // NonVerticalZipLines
    MapEditor_CreateZiplineFromUnity( < 19407.7, -9664.2, 17873 > , < 0, 0, 0 > , < 19899.7, -9673.8, 17873 > , < 0, 0, 0 > , false, -1, 1, 2, 1, 1, 0, 1, 150, 150, false, 0, false, 0, 0, [], [], [], 32, 60, 0)

    // Double Doors
    MapEditor_SpawnDoor( < 19049.1, -16155.8, 18235.7 > , < 0, -90, 0 > , eMapEditorDoorType.Double, false, true)
    MapEditor_SpawnDoor( < 19050.96, -15153.4, 18235.7 > , < 0, -89.9999, 0 > , eMapEditorDoorType.Double, false, false)

    // Buttons
    AddCallback_OnUseEntity(CreateFRButton( <- 164.6378, -1.9487, 20063.54 > , < 0, 90.0001, 0 > , "%use% Start/Stop Timer"), void
        function(entity panel, entity user, int input) {
            if (IsValidPlayer(user)) {
                array < ItemFlavor > characters = GetAllCharacters()
                CharacterSelect_AssignCharacter(ToEHI(user), characters[7])
                user.TakeOffhandWeapon(OFFHAND_ULTIMATE)

                if (user.GetPersistentVar("gen") == 0) {
                    user.SetPersistentVar("gen", Time())
                    user.p.isTimerActive = true
                    user.p.startTime = floor(Time()).tointeger()
                    LocalMsg(user, "#FS_STRING_VAR", "", 4, 1.0, "Timer Started", "", "", false)
                } else {
                    user.SetPersistentVar("gen", 0)
                    user.p.isTimerActive = false
                    LocalMsg(user, "#FS_STRING_VAR", "", 4, 1.0, "Timer Stopped", "", "", false)
                }
            }
        })

    AddCallback_OnUseEntity(CreateFRButton( < 19042.76, -17991.25, 17932.54 > , < 0, 180, 0 > , "%use% Finish"), void
        function(entity panel, entity user, int input) {
            if (IsValidPlayer(user)) {
                int gen = user.GetPersistentVarAsInt("gen")
                file.cp_table[user] <- file.first_cp

                if (gen != 0) {
                    float final_time = Time() - gen
                    float minutes = final_time / 60
                    float seconds = final_time % 60

                    LocalMsg(user, "#FS_STRING_VAR", "", 2, 5.0, format("%d:%02d", minutes, seconds), "FINAL TIME", "", false)
                    user.SetPersistentVar("gen", 0)
                } else {
                    LocalMsg(user, "#FS_STRING_VAR", "", 2, 5.0, "YOU FINISHED!", "CONGRATULATIONS", "", false)
                }

                if (user.p.isTimerActive == true) {
                    user.p.isTimerActive = false
                }
            }
        })


    // Jumppads
    MapEditor_CreateJumpPad(MapEditor_CreateProp($"mdl/props/octane_jump_pad/octane_jump_pad.rmdl", < 19647.41, -6190.9, 17514.6 > , < 0, 0, 0 > , true, 50000, -1, 1))

    // Triggers
    entity trigger_0 = MapEditor_CreateTrigger( < 13333.58, -7248.38, 14965.65 > , < 0, 0, 0 > , 45000, 50, false)
    trigger_0.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValid(ent)) {
                if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
                    ent.SetVelocity( < 0, 0, 0 > )
                    ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
                    ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
                    ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
                    ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
                    ent.SetSuitGrapplePower(100)

                    if (ent in file.cp_table) {
                        ent.SetOrigin(file.cp_table[ent])
                    } else {
                        ent.SetOrigin(file.first_cp)
                    }
                }
            }
        })
    DispatchSpawn(trigger_0)
    entity trigger_1 = MapEditor_CreateTrigger( < 19788.58, -14516.38, 16813.65 > , < 0, 0, 0 > , 4500, 50, false)
    trigger_1.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValid(ent)) {
                if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
                    ent.SetVelocity( < 0, 0, 0 > )
                    ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
                    ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
                    ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
                    ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
                    ent.SetSuitGrapplePower(100)

                    if (ent in file.cp_table) {
                        ent.SetOrigin(file.cp_table[ent])
                    } else {
                        ent.SetOrigin(file.first_cp)
                    }
                }
            }
        })
    DispatchSpawn(trigger_1)
    entity trigger_2 = MapEditor_CreateTrigger( < 19788.58, -7772.38, 17143.65 > , < 0, 0, 0 > , 2500, 50, false)
    trigger_2.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValid(ent)) {
                if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
                    ent.SetVelocity( < 0, 0, 0 > )
                    ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
                    ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
                    ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
                    ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
                    ent.SetSuitGrapplePower(100)

                    if (ent in file.cp_table) {
                        ent.SetOrigin(file.cp_table[ent])
                    } else {
                        ent.SetOrigin(file.first_cp)
                    }
                }
            }
        })
    DispatchSpawn(trigger_2)
    entity trigger_3 = MapEditor_CreateTrigger( < 19788.58, -4002.38, 15641.65 > , < 0, 0, 0 > , 2500, 50, false)
    trigger_3.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValid(ent)) {
                if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
                    ent.SetVelocity( < 0, 0, 0 > )
                    ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
                    ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
                    ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
                    ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
                    ent.SetSuitGrapplePower(100)

                    if (ent in file.cp_table) {
                        ent.SetOrigin(file.cp_table[ent])
                    } else {
                        ent.SetOrigin(file.first_cp)
                    }
                }
            }
        })
    DispatchSpawn(trigger_3)
    entity trigger_4 = MapEditor_CreateTrigger( < 19788.58, -732.3799, 16849.65 > , < 0, 0, 0 > , 2500, 50, false)
    trigger_4.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValid(ent)) {
                if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
                    ent.SetVelocity( < 0, 0, 0 > )
                    ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
                    ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
                    ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
                    ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
                    ent.SetSuitGrapplePower(100)

                    if (ent in file.cp_table) {
                        ent.SetOrigin(file.cp_table[ent])
                    } else {
                        ent.SetOrigin(file.first_cp)
                    }
                }
            }
        })
    DispatchSpawn(trigger_4)
    entity trigger_5 = MapEditor_CreateTrigger( < 19522.58, 2417.62, 16849.65 > , < 0, 0, 0 > , 2500, 50, false)
    trigger_5.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValid(ent)) {
                if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
                    ent.SetVelocity( < 0, 0, 0 > )
                    ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
                    ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
                    ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
                    ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
                    ent.SetSuitGrapplePower(100)

                    if (ent in file.cp_table) {
                        ent.SetOrigin(file.cp_table[ent])
                    } else {
                        ent.SetOrigin(file.first_cp)
                    }
                }
            }
        })
    DispatchSpawn(trigger_5)
    entity trigger_6 = MapEditor_CreateTrigger( < 11549.58, 2417.62, 17391.65 > , < 0, 0, 0 > , 2500, 50, false)
    trigger_6.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValid(ent)) {
                if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
                    ent.SetVelocity( < 0, 0, 0 > )
                    ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
                    ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
                    ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
                    ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
                    ent.SetSuitGrapplePower(100)

                    if (ent in file.cp_table) {
                        ent.SetOrigin(file.cp_table[ent])
                    } else {
                        ent.SetOrigin(file.first_cp)
                    }
                }
            }
        })
    DispatchSpawn(trigger_6)
    entity trigger_7 = MapEditor_CreateTrigger( < 15565.58, 2417.62, 17391.65 > , < 0, 0, 0 > , 2500, 50, false)
    trigger_7.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValid(ent)) {
                if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
                    ent.SetVelocity( < 0, 0, 0 > )
                    ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
                    ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
                    ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
                    ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
                    ent.SetSuitGrapplePower(100)

                    if (ent in file.cp_table) {
                        ent.SetOrigin(file.cp_table[ent])
                    } else {
                        ent.SetOrigin(file.first_cp)
                    }
                }
            }
        })
    DispatchSpawn(trigger_7)
    entity trigger_8 = MapEditor_CreateTrigger( < 6812.584, 2284.62, 21430.65 > , < 0, 0, 0 > , 1500, 50, false)
    trigger_8.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValid(ent)) {
                if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
                    ent.SetVelocity( < 0, 0, 0 > )
                    ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
                    ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
                    ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
                    ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
                    ent.SetSuitGrapplePower(100)

                    if (ent in file.cp_table) {
                        ent.SetOrigin(file.cp_table[ent])
                    } else {
                        ent.SetOrigin(file.first_cp)
                    }
                }
            }
        })
    DispatchSpawn(trigger_8)
    entity trigger_9 = MapEditor_CreateTrigger( < 9468.584, 2296.62, 20852.65 > , < 0, 0, 0 > , 1500, 50, false)
    trigger_9.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValid(ent)) {
                if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
                    ent.SetVelocity( < 0, 0, 0 > )
                    ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
                    ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
                    ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
                    ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
                    ent.SetSuitGrapplePower(100)

                    if (ent in file.cp_table) {
                        ent.SetOrigin(file.cp_table[ent])
                    } else {
                        ent.SetOrigin(file.first_cp)
                    }
                }
            }
        })
    DispatchSpawn(trigger_9)
    entity trigger_10 = MapEditor_CreateTrigger( < 5962.584, -8.3799, 20440.65 > , < 0, 0, 0 > , 2500, 50, false)
    trigger_10.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValid(ent)) {
                if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
                    ent.SetVelocity( < 0, 0, 0 > )
                    ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
                    ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
                    ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
                    ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
                    ent.SetSuitGrapplePower(100)

                    if (ent in file.cp_table) {
                        ent.SetOrigin(file.cp_table[ent])
                    } else {
                        ent.SetOrigin(file.first_cp)
                    }
                }
            }
        })
    DispatchSpawn(trigger_10)
    entity trigger_11 = MapEditor_CreateTrigger( < 1656.584, -8.3799, 19587.65 > , < 0, 0, 0 > , 2500, 50, false)
    trigger_11.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValid(ent)) {
                if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
                    ent.SetVelocity( < 0, 0, 0 > )
                    ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
                    ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
                    ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
                    ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
                    ent.SetSuitGrapplePower(100)

                    if (ent in file.cp_table) {
                        ent.SetOrigin(file.cp_table[ent])
                    } else {
                        ent.SetOrigin(file.first_cp)
                    }
                }
            }
        })
    DispatchSpawn(trigger_11)
    entity trigger_12 = MapEditor_CreateTrigger( <- 4.4004, -3.5, 20108 > , < 0, 0, 0 > , 100, 50, false)
    trigger_12.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValidPlayer(ent)) {
                // int gen = ent.GetPersistentVarAsInt("gen")
                // if (gen != 0) {
                //     float final_time = Time() - gen
                //     float minutes = final_time / 60
                //     float seconds = final_time % 60
                //     LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, format("%d:%02d", minutes, seconds), "", "", false)
                // } else if (file.cp_table[ent] != <- 4.4004, -3.5, 20108 > ) {
                //     LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, "CHECKPOINT", "", "", false)
                // }
                ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
                ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
                ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
                ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
                ent.SetSuitGrapplePower(100)
                file.cp_table[ent] <-  < -4.4004, -3.5, 20108 >
            }
        })
    DispatchSpawn(trigger_12)
    entity trigger_13 = MapEditor_CreateTrigger( < 2940.184, 4.6201, 19889.95 > , < 0, 0, 0 > , 100, 50, false)
    trigger_13.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValidPlayer(ent)) {
                int gen = ent.GetPersistentVarAsInt("gen")
                if (gen != 0) {
                    float final_time = Time() - gen
                    float minutes = final_time / 60
                    float seconds = final_time % 60
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, format("%d:%02d", minutes, seconds), "", "", false)
                } else if (file.cp_table[ent] != < 2940.184, 4.6201, 19889.95 > ) {
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, "CHECKPOINT", "", "", false)
                }
                ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
                ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
                ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
                ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
                ent.SetSuitGrapplePower(100)
                file.cp_table[ent] <-  < 2940.184, 4.6201, 19889.95 >
            }
        })
    DispatchSpawn(trigger_13)
    entity trigger_14 = MapEditor_CreateTrigger( < 5198.984, -1.1799, 20901.15 > , < 0, 0, 0 > , 100, 50, false)
    trigger_14.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValidPlayer(ent)) {
                int gen = ent.GetPersistentVarAsInt("gen")
                if (gen != 0) {
                    float final_time = Time() - gen
                    float minutes = final_time / 60
                    float seconds = final_time % 60
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, format("%d:%02d", minutes, seconds), "", "", false)
                } else if (file.cp_table[ent] != < 5198.984, -1.1799, 20901.15 > ) {
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, "CHECKPOINT", "", "", false)
                }
                ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
                ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
                ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
                ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
                ent.SetSuitGrapplePower(100)
                file.cp_table[ent] <-  < 5198.984, -1.1799, 20901.15 >
            }
        })
    DispatchSpawn(trigger_14)
    entity trigger_15 = MapEditor_CreateTrigger( < 7459.584, -1.1799, 21913.65 > , < 0, 0, 0 > , 100, 50, false)
    trigger_15.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValidPlayer(ent)) {
                int gen = ent.GetPersistentVarAsInt("gen")
                if (gen != 0) {
                    float final_time = Time() - gen
                    float minutes = final_time / 60
                    float seconds = final_time % 60
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, format("%d:%02d", minutes, seconds), "", "", false)
                } else if (file.cp_table[ent] != < 7459.584, -1.1799, 21913.65 > ) {
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, "CHECKPOINT", "", "", false)
                }
                ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
                ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
                ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
                ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
                ent.SetSuitGrapplePower(100)
                file.cp_table[ent] <-  < 7459.584, -1.1799, 21913.65 >
            }
        })
    DispatchSpawn(trigger_15)
    entity trigger_16 = MapEditor_CreateTrigger( < 8724.584, 2009.62, 21913.65 > , < 0, 0, 0 > , 180.6, 50, false)
    trigger_16.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValidPlayer(ent)) {
                int gen = ent.GetPersistentVarAsInt("gen")
                if (gen != 0) {
                    float final_time = Time() - gen
                    float minutes = final_time / 60
                    float seconds = final_time % 60
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, format("%d:%02d", minutes, seconds), "", "", false)
                } else if (file.cp_table[ent] != < 8724.584, 2009.62, 21913.65 > ) {
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, "CHECKPOINT", "", "", false)
                }
                ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
                ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
                ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
                ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
                ent.SetSuitGrapplePower(100)
                file.cp_table[ent] <-  < 8724.584, 2009.62, 21913.65 >
            }
        })
    DispatchSpawn(trigger_16)
    entity trigger_17 = MapEditor_CreateTrigger( < 9893.584, 2172.02, 22509.65 > , < 0, 0, 0 > , 161.75, 50, false)
    trigger_17.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValidPlayer(ent)) {
                int gen = ent.GetPersistentVarAsInt("gen")
                if (gen != 0) {
                    float final_time = Time() - gen
                    float minutes = final_time / 60
                    float seconds = final_time % 60
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, format("%d:%02d", minutes, seconds), "", "", false)
                } else if (file.cp_table[ent] != < 9893.584, 2172.02, 22509.65 > ) {
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, "CHECKPOINT", "", "", false)
                }
                ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
                ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
                ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
                ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
                ent.SetSuitGrapplePower(100)
                file.cp_table[ent] <-  < 9893.584, 2172.02, 22509.65 >
            }
        })
    DispatchSpawn(trigger_17)
    entity trigger_18 = MapEditor_CreateTrigger( < 9201.884, 2172.02, 23502.65 > , < 0, 0, 0 > , 161.75, 50, false)
    trigger_18.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValidPlayer(ent)) {
                int gen = ent.GetPersistentVarAsInt("gen")
                if (gen != 0) {
                    float final_time = Time() - gen
                    float minutes = final_time / 60
                    float seconds = final_time % 60
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, format("%d:%02d", minutes, seconds), "", "", false)
                } else if (file.cp_table[ent] != < 9201.884, 2172.02, 23502.65 > ) {
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, "CHECKPOINT", "", "", false)
                }
                ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
                ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
                ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
                ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
                ent.SetSuitGrapplePower(100)
                file.cp_table[ent] <-  < 9201.884, 2172.02, 23502.65 >
            }
        })
    DispatchSpawn(trigger_18)
    entity trigger_19 = MapEditor_CreateTrigger( < 9893.584, 2172.02, 24542.65 > , < 0, 0, 0 > , 161.75, 50, false)
    trigger_19.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValidPlayer(ent)) {
                int gen = ent.GetPersistentVarAsInt("gen")
                if (gen != 0) {
                    float final_time = Time() - gen
                    float minutes = final_time / 60
                    float seconds = final_time % 60
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, format("%d:%02d", minutes, seconds), "", "", false)
                } else if (file.cp_table[ent] != < 9893.584, 2172.02, 24542.65 > ) {
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, "CHECKPOINT", "", "", false)
                }
                ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
                ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
                ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
                ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
                ent.SetSuitGrapplePower(100)
                file.cp_table[ent] <-  < 9893.584, 2172.02, 24542.65 >
            }
        })
    DispatchSpawn(trigger_19)
    entity trigger_20 = MapEditor_CreateTrigger( < 9200.584, 2172.02, 25537.65 > , < 0, 0, 0 > , 161.75, 50, false)
    trigger_20.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValidPlayer(ent)) {
                int gen = ent.GetPersistentVarAsInt("gen")
                if (gen != 0) {
                    float final_time = Time() - gen
                    float minutes = final_time / 60
                    float seconds = final_time % 60
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, format("%d:%02d", minutes, seconds), "", "", false)
                } else if (file.cp_table[ent] != < 9200.584, 2172.02, 25537.65 > ) {
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, "CHECKPOINT", "", "", false)
                }
                ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
                ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
                ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
                ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
                ent.SetSuitGrapplePower(100)
                file.cp_table[ent] <-  < 9200.584, 2172.02, 25537.65 >
            }
        })
    DispatchSpawn(trigger_20)
    entity trigger_21 = MapEditor_CreateTrigger( < 18476.58, 2155.62, 17846.65 > , < 0, 0, 0 > , 160.9, 50, false)
    trigger_21.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValidPlayer(ent)) {
                int gen = ent.GetPersistentVarAsInt("gen")
                if (gen != 0) {
                    float final_time = Time() - gen
                    float minutes = final_time / 60
                    float seconds = final_time % 60
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, format("%d:%02d", minutes, seconds), "", "", false)
                } else if (file.cp_table[ent] != < 18476.58, 2155.62, 17846.65 > ) {
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, "CHECKPOINT", "", "", false)
                }
                ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
                ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
                ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
                ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
                ent.SetSuitGrapplePower(100)
                file.cp_table[ent] <-  < 19655, 1142, 17877 >
            }
        })
    DispatchSpawn(trigger_21)
    entity trigger_22 = MapEditor_CreateTrigger( < 19656.58, -2070.18, 17856.35 > , < 0, 0, 0 > , 162.05, 50, false)
    trigger_22.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValidPlayer(ent)) {
                int gen = ent.GetPersistentVarAsInt("gen")
                if (gen != 0) {
                    float final_time = Time() - gen
                    float minutes = final_time / 60
                    float seconds = final_time % 60
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, format("%d:%02d", minutes, seconds), "", "", false)
                } else if (file.cp_table[ent] != < 19656.58, -2070.18, 17856.35 > ) {
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, "CHECKPOINT", "", "", false)
                }
                ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
                ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
                ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
                ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
                ent.SetSuitGrapplePower(100)
                file.cp_table[ent] <-  < 19656.58, -2070.18, 17856.35 >
            }
        })
    DispatchSpawn(trigger_22)
    entity trigger_23 = MapEditor_CreateTrigger( < 19656.58, -5318.38, 17566.65 > , < 0, 0, 0 > , 162.05, 50, false)
    trigger_23.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValidPlayer(ent)) {
                int gen = ent.GetPersistentVarAsInt("gen")
                if (gen != 0) {
                    float final_time = Time() - gen
                    float minutes = final_time / 60
                    float seconds = final_time % 60
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, format("%d:%02d", minutes, seconds), "", "", false)
                } else if (file.cp_table[ent] != < 19656.58, -5318.38, 17566.65 > ) {
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, "CHECKPOINT", "", "", false)
                }
                ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
                ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
                ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
                ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
                ent.SetSuitGrapplePower(100)
                file.cp_table[ent] <-  < 19656.58, -5318.38, 17566.65 >
            }
        })
    DispatchSpawn(trigger_23)
    entity trigger_24 = MapEditor_CreateTrigger( < 19656.58, -8828.38, 17741.65 > , < 0, 0, 0 > , 162.05, 50, false)
    trigger_24.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValidPlayer(ent)) {
                int gen = ent.GetPersistentVarAsInt("gen")
                if (gen != 0) {
                    float final_time = Time() - gen
                    float minutes = final_time / 60
                    float seconds = final_time % 60
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, format("%d:%02d", minutes, seconds), "", "", false)
                } else if (file.cp_table[ent] != < 19656.58, -8828.38, 17741.65 > ) {
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, "CHECKPOINT", "", "", false)
                }
                ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
                ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
                ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
                ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
                ent.SetSuitGrapplePower(100)
                file.cp_table[ent] <-  < 19656.58, -8828.38, 17741.65 >
            }
        })
    DispatchSpawn(trigger_24)
    entity trigger_25 = MapEditor_CreateTrigger( < 19657.18, -9823.58, 18196.25 > , < 0, 0, 0 > , 30, 50, false)
    trigger_25.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValidPlayer(ent)) {
                int gen = ent.GetPersistentVarAsInt("gen")
                if (gen != 0) {
                    float final_time = Time() - gen
                    float minutes = final_time / 60
                    float seconds = final_time % 60
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, format("%d:%02d", minutes, seconds), "", "", false)
                } else if (file.cp_table[ent] != < 19657.18, -9823.58, 18196.25 > ) {
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, "CHECKPOINT", "", "", false)
                }
                ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
                ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
                ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
                ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
                ent.SetSuitGrapplePower(100)
                file.cp_table[ent] <-  < 19657.18, -9823.58, 18196.25 >
            }
        })
    DispatchSpawn(trigger_25)
    entity trigger_26 = MapEditor_CreateTrigger( < 19050.58, -15185.38, 18286.05 > , < 0, 0, 0 > , 100, 50, false)
    trigger_26.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValidPlayer(ent)) {
                int gen = ent.GetPersistentVarAsInt("gen")
                if (gen != 0) {
                    float final_time = Time() - gen
                    float minutes = final_time / 60
                    float seconds = final_time % 60
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, format("%d:%02d", minutes, seconds), "", "", false)
                } else if (file.cp_table[ent] != < 19050.58, -15185.38, 18286.05 > ) {
                    LocalMsg(ent, "#FS_STRING_VAR", "", 1, 5.0, "CHECKPOINT", "", "", false)
                }
                ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
                ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
                ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
                ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
                ent.SetSuitGrapplePower(100)
                file.cp_table[ent] <-  < 19050.58, -15185.38, 18286.05 >
            }
        })
    DispatchSpawn(trigger_26)
    entity trigger_27 = MapEditor_CreateTrigger( < 9929.584, 2175.62, 25597.65 > , < 0, 0, 0 > , 243, 106, false)
    trigger_27.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValid(ent)) {
                if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
                    ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
                    ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
                }
            }
        })
    trigger_27.SetLeaveCallback(void
        function(entity trigger, entity ent) {
            if (IsValid(ent)) {
                if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
                    ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
                    ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
                }
            }
        })
    DispatchSpawn(trigger_27)
    entity trigger_28 = MapEditor_CreateTrigger( < 19656.58, -9398.38, 17741.65 > , < 0, 0, 0 > , 450, 50, false)
    trigger_28.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValid(ent)) {
                if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
                    ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
                    ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
                }
            }
        })
    trigger_28.SetLeaveCallback(void
        function(entity trigger, entity ent) {
            if (IsValid(ent)) {
                if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
                    ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
                    ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
                }
            }
        })
    DispatchSpawn(trigger_28)
    entity trigger_29 = MapEditor_CreateTrigger( < 19986.58, -11663.38, 18271.65 > , < 0, 0, 0 > , 300.05, 1152.2, false)
    trigger_29.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValid(ent)) {
                if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
                    ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
                    ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
                    ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
                    ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
                    ent.SetSuitGrapplePower(100)
                }
            }
        })
    DispatchSpawn(trigger_29)
    entity trigger_30 = MapEditor_CreateTrigger( < 19155.58, -12768.38, 18254.65 > , < 0, 0, 0 > , 267.6, 1152.2, false)
    trigger_30.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValid(ent)) {
                if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
                    ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
                    ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
                    ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
                    ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
                    ent.SetSuitGrapplePower(100)
                }
            }
        })
    DispatchSpawn(trigger_30)
    entity trigger_31 = MapEditor_CreateTrigger( < 19763.58, -13925.38, 18224.65 > , < 0, 0, 0 > , 319.6, 1152.2, false)
    trigger_31.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValid(ent)) {
                if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
                    ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
                    ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
                    ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
                    ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
                    ent.SetSuitGrapplePower(100)
                }
            }
        })
    DispatchSpawn(trigger_31)
    entity trigger_32 = MapEditor_CreateTrigger( < 11990.58, 2147.62, 19594.65 > , < 0, 0, 0 > , 482.25, 900, false)
    trigger_32.SetEnterCallback(void
        function(entity trigger, entity ent) {
            if (IsValid(ent)) {
                if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
                    ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
                    ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
                    ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
                    ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
                    ent.SetSuitGrapplePower(100)
                }
            }
        })
    DispatchSpawn(trigger_32)

}