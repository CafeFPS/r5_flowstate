untyped
globalize_all_functions

// Code by: loy_ (Discord). 
// Map by: JayTheYggDrasil (Discord) & Treeree (Discord).

void function Firstmap_precache() {
    PrecacheModel( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl" )
    PrecacheModel( $"mdl/homestead/homestead_floor_panel_01.rmdl" )
    PrecacheModel( $"mdl/lamps/warning_light_ON_red.rmdl" )
    PrecacheModel( $"mdl/lamps/halogen_light_ceiling.rmdl" )
    PrecacheModel( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl" )
    PrecacheModel( $"mdl/signs/street_sign_arrow.rmdl" )
    PrecacheModel( $"mdl/desertlands/construction_bldg_platform_01.rmdl" )
    PrecacheModel( $"mdl/lamps/floor_standing_ambient_light.rmdl" )
    PrecacheModel( $"mdl/desertlands/construction_bldg_platform_02.rmdl" )
    PrecacheModel( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl" )
    PrecacheModel( $"mdl/desertlands/construction_bldg_column_stack_01.rmdl" )
    PrecacheModel( $"mdl/fixtures/stasis_light_01_warm.rmdl" )
    PrecacheModel( $"mdl/barriers/guard_rail_01_256.rmdl" )
    PrecacheModel( $"mdl/timeshift/timeshift_bench_01.rmdl" )
    PrecacheModel( $"mdl/thunderdome/thunderdome_cage_wall_256x352_02.rmdl" )
    PrecacheModel( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl" )
    PrecacheModel( $"mdl/fx/water_bubble_pop_fx.rmdl" )
    PrecacheModel( $"mdl/desertlands/construction_bldg_platform_03.rmdl" )
    PrecacheModel( $"mdl/thunderdome/survival_modular_flexscreens_04.rmdl" )
    PrecacheModel( $"mdl/desertlands/industrial_window_shutter_128x80.rmdl" )
    PrecacheModel( $"mdl/thunderdome/thunderdome_cage_wall_256x128_03.rmdl" )
    PrecacheModel( $"mdl/desertlands/desertlands_cafeteria_light_01.rmdl" )
    PrecacheModel( $"mdl/fx/ar_marker_big_arrow_down.rmdl" )
    PrecacheModel( $"mdl/desertlands/desertlands_lobby_light_01.rmdl" )
    PrecacheModel( $"mdl/thunderdome/thunderdome_cage_wall_128x352_03.rmdl" )
    PrecacheModel( $"mdl/thunderdome/thunderdome_cage_wall_512x352_01.rmdl" )
    PrecacheModel( $"mdl/thunderdome/thunderdome_cage_wall_256x128_02.rmdl" )
    PrecacheModel( $"mdl/thunderdome/thunderdome_cage_frame_128x32_01.rmdl" )
    PrecacheModel( $"mdl/signs/sign_service_shaft_02.rmdl" )
    PrecacheModel( $"mdl/desertlands/construction_bldg_wall_01.rmdl" )
    PrecacheModel( $"mdl/desertlands/lightpole_desertlands_city_01.rmdl" )
    PrecacheModel( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl" )
    PrecacheModel( $"mdl/eden/beacon_small_screen_02_off.rmdl" )
    PrecacheModel( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl" )
    PrecacheModel( $"mdl/vehicles_r5/land_med/msc_freight_tortus_mod/veh_land_msc_freight_tortus_mod_cargo_holder_v1_static.rmdl" )
}

struct {
    vector first_cp = < 7148.8, 6934.9, 16105.8 >
    table<entity, vector> cp_table = {}
    table<entity, vector> cp_angle = {}
    table<entity, bool> last_cp = {}
}
file

void function Firstmap_init() {
    AddCallback_OnClientConnected( Firstmap_player_setup )
    AddCallback_EntitiesDidLoad( FirstMapEntitiesDidLoad )
    Firstmap_precache()
}

void function FirstMapEntitiesDidLoad()
{
    thread Firstmap_load()
}

void function Firstmap_player_setup( entity player )
{
    array<ItemFlavor> characters = GetAllCharacters()

    file.cp_table[player] <- file.first_cp
    file.cp_angle[player] <- < 0, 0, 0 >
    file.last_cp[player] <- false

    player.SetOrigin(file.cp_table[player])
    player.SetAngles(file.cp_angle[player])
    CharacterSelect_AssignCharacter(ToEHI(player), characters[8]) // Wraith

    player.SetPlayerNetBool("pingEnabled", false)
    player.SetPersistentVar("gen", 0)
    Message(player, "Welcome to the First Map!")

    TakeAllPassives( player )
    TakeAllWeapons( player )
    player.TakeOffhandWeapon(OFFHAND_ULTIMATE)
    player.GiveWeapon("mp_weapon_melee_survival", WEAPON_INVENTORY_SLOT_PRIMARY_2, [])
    player.GiveOffhandWeapon("melee_pilot_emptyhanded", OFFHAND_MELEE, [])

    thread Firstmap_SpawnInfoText( player )
}

void function Firstmap_SpawnInfoText( entity player ) {
    FlagWait( "EntitiesDidLoad" )
    wait 1
    CreatePanelText(player, "First Map", "Made by:", < 7132, 7055, 16267 >, < 0, 90, 0 >, false, 2 )
    CreatePanelText(player, "JayTheYggDrasil", "", < 7131.725, 7055, 16150 >, < 0, 90, 0 >, false, 1 )
    CreatePanelText(player, "Treeree", "", < 7131.725, 7056, 16127.3 >, < 0, 90, 0 >, false, 1 )
    CreatePanelText(player, "Loy", "", < 7131.725, 7057, 16104.3 >, < 0, 90, 0 >, false, 1 )
}

void function Firstmap_load() {
    // Props Array
    array < entity > NoClimbArray; array < entity > InvisibleArray; array < entity > ClipInvisibleNoGrappleNoClimbArray; array < entity > ClipNoGrappleNoClimb; array < entity > NoCollisionArray; 

    // Props
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 7258.768, 4102.005, 16259.78 >, < 0, 0.0004, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/homestead/homestead_floor_panel_01.rmdl", < 4888.477, 2823.749, 16654.8 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/lamps/warning_light_ON_red.rmdl", < 7015.725, 7031, 16304.23 >, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/lamps/halogen_light_ceiling.rmdl", < 7131.725, 6175, 16645.65 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < -82.2754, 3431, 16187.81 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 7307.724, 4836, 16650.81 >, < 0, -89.9998, 89.9991 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 7067.723, 7063.328, 16296.6 >, < 0, -179.9997, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 7003.631, 3655.997, 16132.06 >, < 0, -179.998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < 7258.681, 4759, 16395.81 >, < 0, -90, 90 >, true, 50000, -1, 1 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/lamps/floor_standing_ambient_light.rmdl", < 1755.419, 3086.791, 16018.48 >, < 0, -179.9997, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 7131.725, 5305.36, 16650.81 >, < 0, 0, 89.9991 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < -594.2754, 3947, 16297.81 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_02.rmdl", < 7259.725, 3054, 16651.81 >, < -90, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 6996.724, 5156.002, 16394.81 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    ClipInvisibleNoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_stack_01.rmdl", < 6960.6, 6447, 16227.99 >, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 7266.725, 6688, 16394.81 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < 6950.725, 5027, 16646.81 >, < 0, -90, 180 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_02.rmdl", < 6441, 7021, 16357.81 >, < 0, 0, 89.9998 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/fixtures/stasis_light_01_warm.rmdl", < 2417.725, 3227.036, 16567.04 >, < 0, 0, 92.5664 >, false, 50000, -1, 1 )
    ClipNoGrappleNoClimb.append( MapEditor_CreateProp( $"mdl/barriers/guard_rail_01_256.rmdl", < 3596, 7098.891, 19738.81 >, < 0, -89.9997, 0 >, true, 50000, -1, 1 ) )
    ClipInvisibleNoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_02.rmdl", < 1709.725, 2687, 16482.61 >, < 0, -90, -90 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/timeshift/timeshift_bench_01.rmdl", < 7195.412, 3758, 16337.91 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/lamps/floor_standing_ambient_light.rmdl", < 1755.476, 2877, 16018.48 >, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 7003.631, 4549.997, 16388.06 >, < 0, -179.998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 2350.725, 3235, 16266 >, < 0, 0, 0 >, false, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/lamps/halogen_light_ceiling.rmdl", < 7131.725, 5822, 16645.65 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 45.7246, 3431, 16187.81 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x352_02.rmdl", < 3593.396, 6980.847, 19729.55 >, < 0, 90.0005, 90 >, true, 50000, -1, 0.3144 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -914.2744, 4986, 16642.48 >, < 0, 90.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < -722.2754, 3947, 16297.81 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/fx/water_bubble_pop_fx.rmdl", < -914.2744, 5248, 16669.81 >, < 0, 90.0001, 0 >, true, 50000, -1, 7.08 )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 7135, 7055, 16631 >, < 0, 0, 89.9998 >, true, 50000, -1, 1 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/lamps/warning_light_ON_red.rmdl", < 7015.725, 6840, 16186.81 >, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/thunderdome/survival_modular_flexscreens_04.rmdl", < 5094.091, 3183.505, 16713.97 >, < -90, -90, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_shutter_128x80.rmdl", < 5648.725, 2810, 16573.69 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/homestead/homestead_floor_panel_01.rmdl", < 4761.477, 2823.749, 16654.8 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 1645.726, 2982, 16002.48 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -210.2744, 3750, 16386.48 >, < 0, -89.9999, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 4184.725, 3168.88, 16523.81 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x128_03.rmdl", < 3633.228, 6804.2, 19721.55 >, < 0, 43.4111, 89.9999 >, true, 50000, -1, 1 ) )
    ClipInvisibleNoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_stack_01.rmdl", < 7304, 6752.804, 16393.81 >, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 7003.816, 4102.007, 16260.11 >, < 0, -179.998, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 7131.725, 6359.639, 16651.24 >, < 0, 0, 89.9991 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_shutter_128x80.rmdl", < 6113.725, 2906, 16386.69 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/lamps/halogen_light_ceiling.rmdl", < 7131.792, 4888.067, 16645.65 >, < 0, -89.9998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 2158.725, 2919, 16147.81 >, < 0, 0, 0 >, false, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 7131.725, 6943.33, 16059.04 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 7131.725, 5666.667, 16394.81 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 7258.768, 4102.005, 16131.78 >, < 0, 0.0004, 0 >, true, 50000, -1, 1 ) )
    ClipInvisibleNoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < 6362.726, 2323, 16574 >, < 0, -89.9998, -90 >, true, 50000, -1, 1 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/lamps/warning_light_ON_red.rmdl", < 7246.725, 6840, 16460.23 >, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    ClipInvisibleNoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_stack_01.rmdl", < 6960.6, 6752.804, 16393.81 >, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 365.7246, 2984, 16154.81 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/lamps/halogen_light_ceiling.rmdl", < 7131.725, 6875, 16645.65 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 7003.631, 4549.997, 16260.06 >, < 0, -179.998, 0 >, true, 50000, -1, 1 )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 7260, 6923, 16631 >, < 0, -90, 90 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 7131.725, 5656.639, 16651.24 >, < 0, 0, 89.9991 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6740, 2983, 16293 >, < 0, 90.0021, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 4056.725, 3168.88, 16523.81 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_cafeteria_light_01.rmdl", < 6236.725, 2855.999, 16563.15 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 1284.013, 2919, 16130.01 >, < 44.9999, 0, 0 >, true, 50000, -1, 1 )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/thunderdome/survival_modular_flexscreens_04.rmdl", < 5110.091, 3183.505, 16713.97 >, < -90, -90, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 7258.768, 4102.005, 16516.06 >, < 0, 0.0004, 0 >, true, 50000, -1, 1 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/signs/street_sign_arrow.rmdl", < 3601.906, 6867.906, 19804.81 >, < 90, -89.9998, 0 >, true, 50000, -1, 1.6815 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x128_03.rmdl", < 3538.728, 6817.3, 19721.55 >, < -0.0001, -46.5889, 90 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_light_01.rmdl", < -82.5, 3437, 16520.81 >, < -30, 89.9998, 0.0001 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_shutter_128x80.rmdl", < 6113.725, 2906, 16465.69 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 2158.725, 2919, 15795.81 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    ClipNoGrappleNoClimb.append( MapEditor_CreateProp( $"mdl/barriers/guard_rail_01_256.rmdl", < 3363.109, 6873, 19738.81 >, < 0, 0.0003, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_shutter_128x80.rmdl", < 6113.725, 2810, 16465.69 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 7263, 7055, 16631 >, < 0, 0, 89.9998 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 7266.725, 4900.663, 16394.81 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 7258.595, 3655.995, 16260.4 >, < 0, 0.0004, 0 >, true, 50000, -1, 1 )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/thunderdome/survival_modular_flexscreens_04.rmdl", < 5094.091, 3183.505, 16850.97 >, < -90, -90, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 3417.727, 7108, 19723.55 >, < 0, -179.9997, -89.9999 >, true, 50000, -1, 1 )
    ClipInvisibleNoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_stack_01.rmdl", < 7304, 6447, 16393.81 >, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 5771.726, 2856, 16431.6 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 2030.725, 2919, 16147.81 >, < 0, 0, 0 >, false, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 7266.725, 5411.332, 16394.81 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/lamps/warning_light_ON_red.rmdl", < 7131.944, 7031, 16304.23 >, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 7266.725, 5156.002, 16394.81 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 7266.725, 5921.997, 16394.81 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 3479.729, 7044, 19723.55 >, < 0, -89.9998, -89.9999 >, true, 50000, -1, 1 )
    ClipInvisibleNoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < 5891.726, 2323, 16688.81 >, < 0, -89.9998, -90 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/timeshift/timeshift_bench_01.rmdl", < 7068.038, 3758, 16337.91 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 5465, 6992, 16078.81 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x352_02.rmdl", < 3480.881, 6869.667, 19729.55 >, < 0, -179.9997, 90 >, true, 50000, -1, 0.3144 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 1133.716, 2982.95, 15938.8 >, < 0, -179.9999, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 7258.595, 4549.995, 16260.4 >, < 0, 0.0004, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_03.rmdl", < 7212.725, 4006, 15984.02 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 1581.726, 2854, 16130.48 >, < 0, 90.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/fixtures/stasis_light_01_warm.rmdl", < 3311.725, 2602.965, 16714.04 >, < 0, -179.9997, 92.5664 >, true, 50000, -1, 1 )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/thunderdome/survival_modular_flexscreens_04.rmdl", < 5110.091, 3183.505, 16850.97 >, < -90, -90, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 7258.595, 3655.995, 16516.4 >, < 0, 0.0004, 0 >, true, 50000, -1, 1 )
    ClipNoGrappleNoClimb.append( MapEditor_CreateProp( $"mdl/barriers/guard_rail_01_256.rmdl", < -779, 4262, 16538.81 >, < 0, 0, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 2478.725, 3235, 16266 >, < 0, 0, 0 >, false, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < 7001.677, 5783.002, 16395.81 >, < 0, 90.0053, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 6236.725, 2855.999, 16564 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 7258.595, 3655.995, 16132.4 >, < 0, 0.0004, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 6996.724, 6432.665, 16394.81 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/fixtures/stasis_light_01_warm.rmdl", < 2094.725, 2925.964, 16466.04 >, < 0, -179.9997, 92.5664 >, false, 50000, -1, 1 )
    ClipInvisibleNoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_stack_01.rmdl", < 6960.6, 6447, 16066.99 >, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 7003.631, 3655.997, 16516.06 >, < 0, -179.998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 7266.725, 6177.335, 16394.81 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 7003.816, 3208.007, 16388.4 >, < 0, -179.998, 0 >, true, 50000, -1, 1 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/signs/street_sign_arrow.rmdl", < 3592.105, 6858.006, 19804.81 >, < 90, -179.9996, 0 >, true, 50000, -1, 1.6815 ) )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 7258.595, 4549.995, 16388.4 >, < 0, 0.0004, 0 >, true, 50000, -1, 1 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/lamps/warning_light_ON_red.rmdl", < 7246.725, 4078, 16342.23 >, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 5771.726, 2991, 16431.6 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/lamps/warning_light_ON_red.rmdl", < 7131.944, 6840, 16186.81 >, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 5771.726, 2720, 16431.6 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 3247.725, 2597, 16395.81 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < 7001.677, 6807, 16395.81 >, < 0, 90.0003, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 6236.725, 2855.999, 16323.6 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 7003.816, 3208.007, 16516.4 >, < 0, -179.998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 7269, 6872, 16296.6 >, < 0, 90.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 3375.725, 2597, 16395.81 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < 4519.728, 7014.332, 16151.42 >, < 90, -90.0001, 0 >, true, 50000, -1, 1 )
    ClipNoGrappleNoClimb.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_512x352_01.rmdl", < 5098.725, 2856, 16604.95 >, < 0, -90, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x128_02.rmdl", < 7131.725, 3103, 16214.22 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    ClipInvisibleNoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < 6362.726, 2361.998, 17347 >, < -90, -179.9998, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -914.2744, 4730, 16642.48 >, < 0, 0.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 7131.725, 7063.329, 16043.3 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 7003.816, 4102.007, 16388.4 >, < 0, -179.998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128x32_01.rmdl", < 7131.725, 6812, 16410.81 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/signs/sign_service_shaft_02.rmdl", < 7003.814, 4179.461, 16240.81 >, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -914.2744, 4262, 16514.48 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < 7540.725, 2728, 16299.81 >, < 0, 0, -90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_03.rmdl", < 7052.725, 4006, 15984.02 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    ClipNoGrappleNoClimb.append( MapEditor_CreateProp( $"mdl/barriers/guard_rail_01_256.rmdl", < 3596, 6640.109, 19738.81 >, < 0, 90.0002, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 7293.425, 4013, 16333.91 >, < 0, -90, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128x32_01.rmdl", < 7131.725, 7059, 16255.81 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 7131.725, 6008.36, 16650.81 >, < 0, 0, 89.9991 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_02.rmdl", < 1709.725, 2687, 16130.81 >, < 0, -90, -90 >, true, 50000, -1, 1 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/lamps/warning_light_ON_red.rmdl", < 7131.944, 4078, 16342.23 >, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 7131.725, 4645.333, 16134.23 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/lamps/warning_light_ON_red.rmdl", < 7015.725, 4078, 16342.23 >, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/signs/street_sign_arrow.rmdl", < 3582.006, 6868.106, 19804.81 >, < 90, 90.0005, 0 >, true, 50000, -1, 1.6815 ) )
    ClipNoGrappleNoClimb.append( MapEditor_CreateProp( $"mdl/barriers/guard_rail_01_256.rmdl", < 2434.7, 3230.2, 16622.3 >, < 0, -90.0001, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 7003.816, 3208.007, 16132.4 >, < 0, -179.998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 7131.725, 2856, 16341.41 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 1581.726, 3110, 16130.48 >, < 0, 90.0001, 0 >, true, 50000, -1, 1 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/signs/street_sign_arrow.rmdl", < 3591.906, 6877.906, 19804.81 >, < 90, 0, 0 >, true, 50000, -1, 1.6815 ) )
    MapEditor_CreateProp( $"mdl/lamps/halogen_light_ceiling.rmdl", < 7131.725, 6524, 16645.65 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_light_01.rmdl", < 46.5, 3437, 16520.81 >, < -30, 89.9998, 0.0001 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 6996.724, 5666.667, 16394.81 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 7131.725, 6710, 16650.81 >, < 0, 0, 89.9991 >, true, 50000, -1, 1 )
    ClipInvisibleNoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_stack_01.rmdl", < 6960.6, 6447, 16393.81 >, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 6996.724, 6943.33, 16394.81 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 2030.725, 2919, 15795.81 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    ClipInvisibleNoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_stack_01.rmdl", < 7304, 6447, 16227.99 >, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/props/charm/charm_nessy.rmdl", < 7110.733, 3072.694, 16258.09 >, < -2.7423, 123.7615, -12.6479 >, true, 50000, -1, 16 )
    MapEditor_CreateProp( $"mdl/lamps/halogen_light_ceiling.rmdl", < 7131.725, 5470, 16645.65 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 6996.724, 6688, 16394.81 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 7003.816, 4102.007, 16516.4 >, < 0, -179.998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 7258.595, 4549.995, 16516.4 >, < 0, 0.0004, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_shutter_128x80.rmdl", < 5648.725, 2810, 16494.69 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 7003.816, 4102.007, 16131.77 >, < 0, -179.998, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 3353.729, 6692, 19722.55 >, < 0, -89.9998, -89.9999 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 7003.631, 4549.997, 16132.06 >, < 0, -179.998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_wall_01.rmdl", < -849.2754, 4933, 16641.81 >, < 0, 0, -89.9998 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 7266.725, 6943.33, 16043.3 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < 6950.725, 6051, 16646.81 >, < 0, -90, 180 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 493.7256, 3302, 16322.48 >, < 0, -89.9999, 0 >, true, 50000, -1, 1 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/lamps/warning_light_ON_red.rmdl", < 7131.944, 6840, 16460.23 >, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 7131.725, 4390, 16134.23 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    ClipInvisibleNoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < 5891.726, 2998.998, 17461.81 >, < -90, -179.9998, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 941.7256, 2982, 16194.48 >, < 0, 90.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 7258.768, 3208.005, 16132.06 >, < 0, 0.0004, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < 1284.013, 3043, 16130.01 >, < 44.9999, 0, 0 >, true, 50000, -1, 1 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x352_02.rmdl", < 3703.576, 6866.332, 19729.55 >, < 0, 0, 90 >, true, 50000, -1, 0.3144 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x352_02.rmdl", < 3592.061, 6756.153, 19729.55 >, < 0, -89.9998, 90 >, true, 50000, -1, 0.3144 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x128_03.rmdl", < 3646.928, 6919.599, 19721.55 >, < 0.0001, 133.4111, 90 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 7195.723, 7063.329, 16296.6 >, < 0, -179.9997, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 3767.727, 6980, 19723.55 >, < 0, -179.9997, -89.9999 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 7266.725, 5666.667, 16394.81 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/signs/street_sign_arrow.rmdl", < 7132.572, 4014, 16283.81 >, < -90, 0, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < -850.9248, 4773.851, 16385.73 >, < 0, 90.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 493.7246, 2984, 16154.81 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    ClipInvisibleNoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_stack_01.rmdl", < 7304, 6447, 16066.99 >, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/desertlands/lightpole_desertlands_city_01.rmdl", < 7236.779, 2743.946, 16357.41 >, < 0, -134.9997, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < 7131.725, 3048, 16341.41 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 7131.725, 4134, 16134.23 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x128_03.rmdl", < 3530.928, 6912.4, 19721.55 >, < 0, -136.5889, 90.0001 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_light_01.rmdl", < -593.5, 3953, 16631.81 >, < -30, 89.9998, 0.0001 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_shutter_128x80.rmdl", < 5648.725, 2906, 16573.69 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/homestead/homestead_floor_panel_01.rmdl", < 4824.477, 2823.749, 16654.8 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 4412, 6953, 16163 >, < 0, -90, 45 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 2927.728, 2916.91, 16450.88 >, < 0, -89.9999, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 6236.725, 2991, 16323.6 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/fx/ar_marker_big_arrow_down.rmdl", < -915, 4664, 16567.69 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 1197.726, 2982, 16194.48 >, < 0, -89.9999, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 6996.724, 5921.997, 16394.81 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 7003.631, 3655.997, 16260.06 >, < 0, -179.998, 0 >, true, 50000, -1, 1 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/eden/beacon_small_screen_02_off.rmdl", < 1658.516, 2986.002, 16308.02 >, < 0, 90, 0 >, true, 50000, -1, 5.59 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 6996.724, 5411.332, 16394.81 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 6236.725, 2720, 16323.6 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/signs/sign_service_shaft_02.rmdl", < 7258.044, 4178.54, 16240.81 >, < 0, -179.9429, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 7258.768, 3208.005, 16516.06 >, < 0, 0.0004, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 7258.768, 4102.005, 16388.06 >, < 0, 0.0004, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 7003.631, 3655.997, 16388.06 >, < 0, -179.998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_light_01.rmdl", < 494, 2992, 16489.54 >, < -30, 89.9998, 0.0001 >, true, 50000, -1, 1 )
    ClipInvisibleNoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_stack_01.rmdl", < 6960.6, 6600, 16393.81 >, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 7131.725, 6688, 16394.81 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 7266.725, 6432.665, 16394.81 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 7258.595, 3655.995, 16388.4 >, < 0, 0.0004, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_shutter_128x80.rmdl", < 5648.725, 2906, 16494.69 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/lamps/halogen_light_ceiling.rmdl", < 7131.725, 5120, 16645.65 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 7307.724, 4964, 16650.81 >, < 0, -89.9998, 89.9991 >, true, 50000, -1, 1 )
    ClipInvisibleNoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < 5891.726, 2361.998, 17461.81 >, < -90, -179.9998, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3767.225, 2921.601, 16594.88 >, < 0, -90, 179.9998 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 7258.768, 3208.005, 16260.06 >, < 0, 0.0004, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 7003.631, 4549.997, 16516.06 >, < 0, -179.998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 7269, 7000, 16296.6 >, < 0, 90.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 4569.728, 2854.91, 16642.88 >, < 0, -89.9999, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_light_01.rmdl", < -722.5, 3953, 16631.81 >, < -30, 89.9998, 0.0001 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 7003.816, 3208.007, 16260.4 >, < 0, -179.998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 7131.725, 6304, 16394.81 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 7258.768, 3208.005, 16388.06 >, < 0, 0.0004, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 6996.724, 4900.663, 16394.81 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 7258.595, 4549.995, 16132.4 >, < 0, 0.0004, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/fixtures/stasis_light_01_warm.rmdl", < 4117.435, 3162.036, 16839.04 >, < 0, 0, 92.5664 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < 7258.681, 5783, 16395.81 >, < 0, -90, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 7067.725, 6808, 16059.04 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/lamps/warning_light_ON_red.rmdl", < 7015.725, 6840, 16460.23 >, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 7195.725, 6808, 16059.04 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 5771.726, 2856, 16672 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6740, 2983, 16420.4 >, < 0, 90.0021, 0 >, false, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_cafeteria_light_01.rmdl", < 5771.726, 2856, 16670.96 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/vehicles_r5/land_med/msc_freight_tortus_mod/veh_land_msc_freight_tortus_mod_cargo_holder_v1_static.rmdl", < 5261.724, 2856, 16487.2 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 6996.724, 6177.335, 16394.81 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 7131.725, 3870, 16322.43 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/lamps/warning_light_ON_red.rmdl", < 7246.725, 6840, 16186.81 >, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    ClipInvisibleNoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < 6362.726, 2998.998, 17347 >, < -90, -179.9998, 0 >, true, 50000, -1, 1 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/lamps/warning_light_ON_red.rmdl", < 7246.725, 7031, 16304.23 >, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    ClipInvisibleNoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_stack_01.rmdl", < 7304, 6600, 16393.81 >, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_shutter_128x80.rmdl", < 6113.725, 2810, 16386.69 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < -976.0005, 4773.851, 16385.73 >, < 0, 90.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128x32_01.rmdl", < 7131.725, 6812, 16138.81 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_light_01.rmdl", < 365, 2992, 16489.54 >, < -30, 89.9998, 0.0001 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl", < 7131.725, 7061.279, 16651.24 >, < 0, 0, 89.9991 >, true, 50000, -1, 1 )

    foreach ( entity ent in NoClimbArray ) ent.kv.solid = 3
    foreach ( entity ent in InvisibleArray ) ent.MakeInvisible()
    foreach ( entity ent in ClipInvisibleNoGrappleNoClimbArray )
    {
        ent.MakeInvisible()
        ent.kv.solid = 3
        ent.kv.CollisionGroup = TRACE_COLLISION_GROUP_PLAYER
        ent.kv.contents = CONTENTS_SOLID | CONTENTS_NOGRAPPLE
    }
    foreach ( entity ent in ClipNoGrappleNoClimb )
    {
        ent.kv.solid = 3
        ent.kv.CollisionGroup = TRACE_COLLISION_GROUP_PLAYER
        ent.kv.contents = CONTENTS_SOLID | CONTENTS_NOGRAPPLE
    }
    foreach ( entity ent in NoCollisionArray ) ent.kv.solid = 0

    // Buttons
    AddCallback_OnUseEntity( CreateFRButton(< 7254.493, 6938.447, 16075.16 >, < 0, -89.9998, 0 >, "%use% Start/Stop Timer"), void function(entity panel, entity ent, int input)
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

    // 1
    Invis_Button(< 7059.391, 7055, 16075.04 >, < 0, 0, 0 >, true, < 7084, 6688, 16511 >, < 0, 180, 0 >, "" )
    Invis_Button(< 7201.391, 7055, 16075.04 >, < 0, 0, 0 >, false, < -914, 5259, 16825 >, < 0, 0, 0 >, "" )
    // 2
    Invis_Button(< 7016, 6641, 16411 >, < 0, 90, 0 >, true, < 7076, 3950, 16438 >, < 0, 180, 0 >, "" )
    Invis_Button(< 7016, 6734, 16411 >, < 0, 90, 0 >, false, < 7131, 6950, 16147 >, < 0, 90, 0 >, "" )
    // 3
    Invis_Button(< 7021, 3900.776, 16339 >, < 0, 90, 0 >, true, < 7132, 2799, 16457 >, < 0, -90, 0 >, "" )
    Invis_Button(< 7021, 3993.776, 16339 >, < 0, 90, 0 >, false, < 7084, 6688, 16511 >, < 0, 180, 0 >, "" )
    // 4
    Invis_Button(< 7178, 2741.686, 16358 >, < 0, -180, 0 >, true, < 6237, 2795, 16439 >, < 0, -90, 0 >, "" )
    Invis_Button(< 7085, 2741.686, 16358 >, < 0, -180, 0 >, false, < 7076, 3950, 16438 >, < 0, 180, 0 >, "" )
    // 5
    Invis_Button(< 6284, 2741.686, 16340 >, < 0, -180, 0 >, true, < 5772, 2795, 16548 >, < 0, -90, 0 >, "" )
    Invis_Button(< 6191, 2741.686, 16340 >, < 0, -180, 0 >, false, < 7132, 2799, 16457 >, < 0, -90, 0 >, "" )
    // 6
    Invis_Button(< 5819, 2741.686, 16448 >, < 0, -180, 0 >, true, < 5283, 2831, 16651 >, < 0, -90, 0 >, "" )
    Invis_Button(< 5726, 2741.686, 16448 >, < 0, -180, 0 >, false, < 6237, 2795, 16439 >, < 0, -90, 0 >, "" )
    // 7
    Invis_Button(< 5315, 2734.686, 16551 >, < 0, -180, 0 >, true, < 4570, 2812, 16759 >, < 0, -90, 0 >, "" )
    Invis_Button(< 5222, 2734.686, 16551 >, < 0, -180, 0 >, false, < 5772, 2795, 16548 >, < 0, -90, 0 >, "" )
    // 8
    Invis_Button(< 4617, 2741.686, 16659 >, < 0, -180, 0 >, true, < 3825, 2831, 16686 >, < 0, -90, 0 >, "" )
    Invis_Button(< 4524, 2741.686, 16659 >, < 0, -180, 0 >, false, < 5283, 2831, 16651 >, < 0, -90, 0 >, "" )
    // 9
    Invis_Button(< 3845, 2734.686, 16587 >, < 0, -180, 0 >, true, < 2928, 2984, 16567 >, < 0, 90, 0 >, "" )
    Invis_Button(< 3752, 2734.686, 16587 >, < 0, -180, 0 >, false, < 4570, 2812, 16759 >, < 0, -90, 0 >, "" )
    // 10
    Invis_Button(< 2880, 3033, 16467 >, < 0, 0, 0 >, true, < 1645, 3026, 16080 >, < 0, 90, 0 >, "" )
    Invis_Button(< 2973, 3033, 16467 >, < 0, 0, 0 >, false, < 3825, 2831, 16686 >, < 0, -90, 0 >, "" )
    // 11
    Invis_Button(< 1598, 3098, 16019 >, < 0, 0, 0 >, true, < 942, 3027, 16310 >, < 0, 90, 0 >, "" )
    Invis_Button(< 1691, 3098, 16019 >, < 0, 0, 0 >, false, < 2928, 2984, 16567 >, < 0, 90, 0 >, "" )
    // 12
    Invis_Button(< 894, 3097, 16211 >, < 0, 0, 0 >, true, < 494, 3334, 16439 >, < 0, 90, 0 >, "" )
    Invis_Button(< 987, 3097, 16211 >, < 0, 0, 0 >, false, < 1645, 3026, 16080 >, < 0, 90, 0 >, "" )
    // 13
    Invis_Button(< 447, 3417, 16339 >, < 0, 0, 0 >, true, < -210, 3800, 16503 >, < 0, 90, 0 >, "" )
    Invis_Button(< 540, 3417, 16339 >, < 0, 0, 0 >, false, < 942, 3027, 16310 >, < 0, 90, 0 >, "" )
    // 14
    Invis_Button(< -257, 3866, 16403 >, < 0, 0, 0 >, true, < -943, 4262, 16631 >, < 0, -180, 0 >, "" )
    Invis_Button(< -164, 3866, 16403 >, < 0, 0, 0 >, false, < 494, 3334, 16439 >, < 0, 90, 0 >, "" )
    // 15
    Invis_Button(< -1030, 4215, 16531 >, < 0, 90, 0 >, true, < -914, 5259, 16825 >, < 0, 0, 0 >, "" )
    Invis_Button(< -1030, 4308, 16531 >, < 0, 90, 0 >, false, < -209.9995, 3800, 16503 >, < 0, 90, 0 >, "" )
    // 16
    Invis_Button(< 3823, 6911, 19728 >, < 0, -90, 0 >, true, < 7131, 6950, 16147 >, < 0, 90, 0 >, "" )
    Invis_Button(< 3823, 6818, 19728 >, < 0, -90, 0 >, false, < -943.002, 4261.999, 16631 >, < 0, -180, 0 >, "" )


    // Triggers
    entity trigger_0 = MapEditor_CreateTrigger( < 1954.999, 5209, 15649.81 >, < 0, 0, 0 >, 3900, 50, false )
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
    entity trigger_1 = MapEditor_CreateTrigger( < 5619.999, 4595, 15771.81 >, < 0, 0, 0 >, 3900, 50, false )
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
    entity trigger_2 = MapEditor_CreateTrigger( < 7148.8, 6956.2, 16231 >, < 0, 0, 0 >, 147.85, 137.6, false )
    trigger_2.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValidPlayer(ent)) {
        file.cp_table[ent] <- < 7148.8, 6934.9, 16105.8 >
        file.cp_angle[ent] <- < 0, 0, 0 >

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
    DispatchSpawn( trigger_2 )
    entity trigger_3 = MapEditor_CreateTrigger( < 7131.725, 6688, 16460.81 >, < 0, 0, 0 >, 120.85, 50, false )
    trigger_3.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValidPlayer(ent)) {
            int gen = ent.GetPersistentVarAsInt("gen")
            if (gen != 0) {
                float final_time = Time() - gen
                float minutes = final_time / 60
                float seconds = final_time % 60

                Message(ent, format("%d:%02d", minutes, seconds))
            }
            file.cp_table[ent] <- < 7139.724, 6769.2, 16460.81 >
            file.cp_angle[ent] <- < 0, -90.0001, 0 >
        }
    })
    DispatchSpawn( trigger_3 )
    entity trigger_4 = MapEditor_CreateTrigger( < 7131.725, 3870, 16387.81 >, < 0, -90, 0 >, 124.05, 50, false )
    trigger_4.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValidPlayer(ent)) {
            int gen = ent.GetPersistentVarAsInt("gen")
            if (gen != 0) {
                float final_time = Time() - gen
                float minutes = final_time / 60
                float seconds = final_time % 60

                Message(ent, format("%d:%02d", minutes, seconds))
            }
            file.cp_table[ent] <- < 7131.725, 3951, 16387.81 >
            file.cp_angle[ent] <- < 0, -90, 0 >
        }
    })
    DispatchSpawn( trigger_4 )
    entity trigger_5 = MapEditor_CreateTrigger( < 7131.725, 2856, 16406.81 >, < 0, -90, 0 >, 160.95, 50, false )
    trigger_5.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValidPlayer(ent)) {
            int gen = ent.GetPersistentVarAsInt("gen")
            if (gen != 0) {
                float final_time = Time() - gen
                float minutes = final_time / 60
                float seconds = final_time % 60

                Message(ent, format("%d:%02d", minutes, seconds))
            }
            file.cp_table[ent] <- < 7220.724, 2848, 16406.81 >
            file.cp_angle[ent] <- < 0, 180, 0 >
        }
    })
    DispatchSpawn( trigger_5 )
    entity trigger_6 = MapEditor_CreateTrigger( < 6236.725, 2855.999, 16389 >, < 0, -90, 0 >, 128.25, 50, false )
    trigger_6.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValidPlayer(ent)) {
            int gen = ent.GetPersistentVarAsInt("gen")
            if (gen != 0) {
                float final_time = Time() - gen
                float minutes = final_time / 60
                float seconds = final_time % 60

                Message(ent, format("%d:%02d", minutes, seconds))
            }
            file.cp_table[ent] <- < 6325.724, 2848, 16389 >
            file.cp_angle[ent] <- < 0, 180, 0 >
        }
    })
    DispatchSpawn( trigger_6 )
    entity trigger_7 = MapEditor_CreateTrigger( < 5771.726, 2856, 16497.81 >, < 0, -90, 0 >, 130, 50, false )
    trigger_7.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValidPlayer(ent)) {
            int gen = ent.GetPersistentVarAsInt("gen")
            if (gen != 0) {
                float final_time = Time() - gen
                float minutes = final_time / 60
                float seconds = final_time % 60

                Message(ent, format("%d:%02d", minutes, seconds))
            }
            file.cp_table[ent] <- < 5860.725, 2848, 16497.81 >
            file.cp_angle[ent] <- < 0, 179.9999, 0 >
        }
    })
    DispatchSpawn( trigger_7 )
    entity trigger_8 = MapEditor_CreateTrigger( < 5214.725, 2856, 16600.95 >, < 0, 0, 0 >, 100, 50, false )
    trigger_8.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValidPlayer(ent)) {
            int gen = ent.GetPersistentVarAsInt("gen")
            if (gen != 0) {
                float final_time = Time() - gen
                float minutes = final_time / 60
                float seconds = final_time % 60

                Message(ent, format("%d:%02d", minutes, seconds))
            }
            file.cp_table[ent] <- < 5404, 2856, 16600.95 >
            file.cp_angle[ent] <- < 0, 180, 0 >
        }
    })
    DispatchSpawn( trigger_8 )
    entity trigger_9 = MapEditor_CreateTrigger( < 4569.728, 2854.91, 16708.81 >, < 0, -89.9999, 0 >, 136.05, 50, false )
    trigger_9.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValidPlayer(ent)) {
            int gen = ent.GetPersistentVarAsInt("gen")
            if (gen != 0) {
                float final_time = Time() - gen
                float minutes = final_time / 60
                float seconds = final_time % 60

                Message(ent, format("%d:%02d", minutes, seconds))
            }
            file.cp_table[ent] <- < 4647.843, 2767.852, 16708.81 >
            file.cp_angle[ent] <- < 0, 135.0001, 0 >
        }
    })
    DispatchSpawn( trigger_9 )
    entity trigger_10 = MapEditor_CreateTrigger( < 3767.225, 2860.455, 16635.81 >, < 0, 90, 0 >, 100, 50, false )
    trigger_10.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValidPlayer(ent)) {
            int gen = ent.GetPersistentVarAsInt("gen")
            if (gen != 0) {
                float final_time = Time() - gen
                float minutes = final_time / 60
                float seconds = final_time % 60

                Message(ent, format("%d:%02d", minutes, seconds))
            }
            file.cp_table[ent] <- < 3881.727, 2880.071, 16635.81 >
            file.cp_angle[ent] <- < 0, -165, 0 >
        }
    })
    DispatchSpawn( trigger_10 )
    entity trigger_11 = MapEditor_CreateTrigger( < 2927.728, 2916.91, 16516.81 >, < 0, -89.9999, 0 >, 120.55, 50, false )
    trigger_11.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValidPlayer(ent)) {
            int gen = ent.GetPersistentVarAsInt("gen")
            if (gen != 0) {
                float final_time = Time() - gen
                float minutes = final_time / 60
                float seconds = final_time % 60

                Message(ent, format("%d:%02d", minutes, seconds))
            }
            file.cp_table[ent] <- < 3006.381, 2829.343, 16516.81 >
            file.cp_angle[ent] <- < 0, 135.0003, 0 >
        }
    })
    DispatchSpawn( trigger_11 )
    entity trigger_12 = MapEditor_CreateTrigger( < 1645.726, 2982, 16068.81 >, < 0, 0.0001, 0 >, 123.3, 50, false )
    trigger_12.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValidPlayer(ent)) {
            int gen = ent.GetPersistentVarAsInt("gen")
            if (gen != 0) {
                float final_time = Time() - gen
                float minutes = final_time / 60
                float seconds = final_time % 60

                Message(ent, format("%d:%02d", minutes, seconds))
            }
            file.cp_table[ent] <- < 1709.724, 2982, 16061.81 >
            file.cp_angle[ent] <- < 0, -179.9996, 0 >
        }
    })
    DispatchSpawn( trigger_12 )
    entity trigger_13 = MapEditor_CreateTrigger( < 941.7256, 2982, 16259.81 >, < 0, 90.0001, 0 >, 122, 50, false )
    trigger_13.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValidPlayer(ent)) {
            int gen = ent.GetPersistentVarAsInt("gen")
            if (gen != 0) {
                float final_time = Time() - gen
                float minutes = final_time / 60
                float seconds = final_time % 60

                Message(ent, format("%d:%02d", minutes, seconds))
            }
            file.cp_table[ent] <- < 1050.724, 3029, 16259.81 >
            file.cp_angle[ent] <- < 0, 179.9999, 0 >
        }
    })
    DispatchSpawn( trigger_13 )
    entity trigger_14 = MapEditor_CreateTrigger( < 493.7256, 3302, 16388.81 >, < 0, -89.9999, 0 >, 123.9, 50, false )
    trigger_14.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValidPlayer(ent)) {
            int gen = ent.GetPersistentVarAsInt("gen")
            if (gen != 0) {
                float final_time = Time() - gen
                float minutes = final_time / 60
                float seconds = final_time % 60

                Message(ent, format("%d:%02d", minutes, seconds))
            }
            file.cp_table[ent] <- < 570.3813, 3215.343, 16388.81 >
            file.cp_angle[ent] <- < 0, 135.0003, 0 >
        }
    })
    DispatchSpawn( trigger_14 )
    entity trigger_15 = MapEditor_CreateTrigger( < -210.2744, 3750, 16452.81 >, < 0, -89.9999, 0 >, 123.15, 50, false )
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
            file.cp_table[ent] <- < -133.6182, 3663.343, 16452.81 >
            file.cp_angle[ent] <- < 0, 135.0003, 0 >
        }
    })
    DispatchSpawn( trigger_15 )
    entity trigger_16 = MapEditor_CreateTrigger( < -914.2744, 4262, 16580.81 >, < 0, -89.9999, 0 >, 121.1, 50, false )
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
            file.cp_table[ent] <- < -977.2754, 4174, 16580.81 >
            file.cp_angle[ent] <- < 0, 90.0004, 0 >
        }
    })
    DispatchSpawn( trigger_16 )
    entity trigger_17 = MapEditor_CreateTrigger( < -914.2744, 5260, 16706.81 >, < 0, 90.0001, 0 >, 100, 50, false )
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
            file.cp_table[ent] <- < 3401.895, 6874.097, 19743.81 >
            file.cp_angle[ent] <- < 0, 0.0005, 0 >
                file.last_cp[ent] <- true
        ent.SetOrigin(< 3401.895, 6874.097, 19743.81 >)
        ent.SetAngles(< 0, 0.0005, 0 >)
        ent.SetVelocity(<0, 0, 0>)
    }
    })
    DispatchSpawn( trigger_17 )
}