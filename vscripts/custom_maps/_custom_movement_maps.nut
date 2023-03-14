untyped

globalize_all_functions

void function PrecacheMovementMapProps()
{
    if(GetMapName() == "mp_rr_desertlands_64k_x_64k_nx" || GetMapName() == "mp_rr_desertlands_64k_x_64k"){
    PrecacheModel( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl" )
    PrecacheModel( $"mdl/runoff/runoff_railing_64_yellow.rmdl" )
    PrecacheModel( $"mdl/signs/Sign_no_tresspasing.rmdl" )
    PrecacheModel( $"mdl/props/kunai/kunai.rmdl" )
    PrecacheModel( $"mdl/robots/drone_frag/drone_frag_loot.rmdl" )
    PrecacheModel( $"mdl/robots/drone_frag/drone_frag_loot_bf.rmdl" )
    PrecacheModel( $"mdl/dev/mp_spawn.rmdl" )
    PrecacheModel( $"mdl/desertlands/highrise_square_top_01.rmdl" )
    PrecacheModel( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl" )
    PrecacheModel( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl" )
    PrecacheModel( $"mdl/signs/street_sign_arrow.rmdl" )
    PrecacheModel( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl" )
    PrecacheModel( $"mdl/desertlands/desertlands_barrier_concrete_128_01.rmdl" )
    PrecacheModel( $"mdl/levels_terrain/mp_rr_canyonlands/clands_roof_bars_01_fglass_blue.rmdl" )
    PrecacheModel( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl" )
    PrecacheModel( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl" )
    PrecacheModel( $"mdl/desertlands/desertlands_apartments_rug_01.rmdl" )
    PrecacheModel( $"mdl/desertlands/construction_bldg_column_01.rmdl" )
    PrecacheModel( $"mdl/desertlands/industrial_support_beam_16x144_filler.rmdl" )
    PrecacheModel( $"mdl/desertlands/industrial_cargo_container_small_03.rmdl" )
    PrecacheModel( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl" )
    PrecacheModel( $"mdl/industrial/underbelly_support_beam_256_01.rmdl" )
    PrecacheModel( $"mdl/pipes/pipe_modular_painted_grey_256.rmdl" )
    PrecacheModel( $"mdl/desertlands/desertlands_apartments_rug_02.rmdl" )
    PrecacheModel( $"mdl/desertlands/desrtlands_icicles_06.rmdl" )
    PrecacheModel( $"mdl/desertlands/highrise_square_block_02.rmdl" )
    PrecacheModel( $"mdl/desertlands/desertlands_city_train_station_railing_02.rmdl" )
    PrecacheModel( $"mdl/desertlands/desertlands_train_station_sign_04.rmdl" )
    PrecacheModel( $"mdl/domestic/floor_rug_red.rmdl" )
    PrecacheModel( $"mdl/desertlands/desertlands_apartments_planter_02.rmdl" )
    PrecacheModel( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl" )
    PrecacheModel( $"mdl/foliage/plant_desert_yucca_01.rmdl" )
    PrecacheModel( $"mdl/barriers/concrete/concrete_barrier_fence.rmdl" )
    PrecacheModel( $"mdl/desertlands/desertlands_building_ice_02.rmdl" )
    PrecacheModel( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl" )
    PrecacheModel( $"mdl/colony/ventilation_unit_01_black.rmdl" )
    PrecacheModel( $"mdl/desertlands/industrial_cargo_container_small_02.rmdl" )
    PrecacheModel( $"mdl/desertlands/wall_city_barred_concrete_192_01.rmdl" )
    PrecacheModel( $"mdl/desertlands/construction_bldg_elevator_01_bott.rmdl" )
    PrecacheModel( $"mdl/desertlands/wall_city_corner_concrete_64_01.rmdl" )
    PrecacheModel( $"mdl/domestic/tv_LED_med_panel.rmdl" )
    PrecacheModel( $"mdl/firstgen/firstgen_pipe_256_darkcloth_01.rmdl" )
    PrecacheModel( $"mdl/signs/numbers/sign_number_lit_1.rmdl" )
    PrecacheModel( $"mdl/desertlands/industrial_support_beam_16x144_vertical.rmdl" )
    PrecacheModel( $"mdl/firstgen/firstgen_pipe_128_goldfoil_01.rmdl" )
    PrecacheModel( $"mdl/desertlands/desertlands_lobby_sign_01.rmdl" )
    PrecacheModel( $"mdl/desertlands/lightpole_desertlands_city_01.rmdl" )
    PrecacheModel( $"mdl/desertlands/curb_parking_concrete_destroyed_01.rmdl" )
    PrecacheModel( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_05.rmdl" )
    PrecacheModel( $"mdl/domestic/bar_sink.rmdl" )
    PrecacheModel( $"mdl/colony/antenna_03_colony.rmdl" )
    PrecacheModel( $"mdl/desertlands/desertlands_train_station_turnstile_01.rmdl" )
    PrecacheModel( $"mdl/props/octane_jump_pad/octane_jump_pad.rmdl" )
    PrecacheModel( $"mdl/industrial/screwdriver_octane.rmdl" )
    PrecacheModel( $"mdl/desertlands/desertlands_train_track_magnetic_beam_01.rmdl" )
    PrecacheModel( $"mdl/props/lifeline_needle/lifeline_needle.rmdl" )
    PrecacheModel( $"mdl/desertlands/construction_bldg_elevator_01_top.rmdl" )
    PrecacheModel( $"mdl/signs/numbers/sign_number_lit_2.rmdl" )
    PrecacheModel( $"mdl/domestic/ac_unit_dirty_32x64_01_a.rmdl" )
    PrecacheModel( $"mdl/desertlands/desertlands_train_track_sign_01.rmdl" )
    PrecacheModel( $"mdl/signs/numbers/sign_number_lit_3.rmdl" )
    PrecacheModel( $"mdl/signs/desertlands_city_newdawn_sign_01.rmdl" )


    }
}


void function MovementGym()
{
    //Buttons 
    AddCallback_OnUseEntity( CreateFRButton(< 9524.8000, -903.8000, 42440.6000 >, < 0, 90.0007, 0 >, "%use% Hub"), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< 10646, 9925, -4283 >,< 0, -89.9998, 0 >)
Message(user, "HUB", "\n  You now recieved Phase Walk Tactical" )
    })
    AddCallback_OnUseEntity( CreateFRButton(< 9645.9000, 64.4000, 42440.6000 >, < 0, 0.0002, 0 >, "%use% Repeat"), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< 9647, -963, 42441.2000 >,< 0, 89.9998, 0 >)
    })
    AddCallback_OnUseEntity( CreateFRButton(< 10534.2000, 9921.3990, -4296.6510 >, < 0, 90.0002, 0 >, "%use% Octane Stim Practice"), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< 9647, -963, 42441.2000 >,< 0, 89.9998, 0 >)
Message(user, "Octane Stim Superglides", "\n  You now recieved Stim Tactical" )
    })
    AddCallback_OnUseEntity( CreateFRButton(< 10896.9000, 9492.5090, -4296.6510 >, < 0, -179.9999, 0 >, "%use% Basic Tap Strafe Practice"), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< -17280, 258.0005, 41940 >,< 0, 89.9998, 0 >)
Message(user, "Tap Strafe Practice")


    })
    AddCallback_OnUseEntity( CreateFRButton(< 3393.2080, 2632.1000, 42441.2000 >, < 0, 180, 0 >, "%use% Hub"), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< 10646, 9925, -4283 >,< 0, -89.9998, 0 >)
Message(user, "Hub")
    })
    AddCallback_OnUseEntity( CreateFRButton(< 3429.6000, 6830.5000, 42886.6000 >, < 0, -0.0004, 0 >, "%use% Repeat Exercise "), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< 3391.9900, 2660.3000, 42441.2000 >,< 0, 89.9998, 0 >)

    })
    AddCallback_OnUseEntity( CreateFRButton(< 3353.6000, 6830.5000, 42886.6000 >, < 0, -0.0004, 0 >, "%use% Hub"), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< 10646, 9925, -4283 >,< 0, -89.9998, 0 >)
Message(user, "Hub")
    })
    AddCallback_OnUseEntity( CreateFRButton(< 5389.1710, 9208.6090, -688.3530 >, < 0, -89.9998, 0 >, "%use% Back to start"), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< 6961, 1147.7710, -1453 >,< 0, -89.9998, 0 >)
    })
    AddCallback_OnUseEntity( CreateFRButton(< -17279.3900, 7651.0070, 41938.3500 >, < 0, 180, 0 >, "%use% Back to Hub"), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< 10646, 9925, -4283 >,< 0, 89.9998, 0 >)
Message(user, "Hub")
    })
    AddCallback_OnUseEntity( CreateFRButton(< 6900.8000, 1258.4930, -1457 >, < 0, 0, 0 >, "%use% Back to Hub"), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< 10646, 9925, -4283 >,< 0, -89.9998, 0 >)
Message(user, "Hub")
    })
    AddCallback_OnUseEntity( CreateFRButton(< -21614.6100, 7241.4930, 41938.3500 >, < 0, -0.0004, 0 >, "%use% Next Exercise "), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< -23694, 7550, 41938.3500 >,< 0, 89.9998, 0 >)

    })
    AddCallback_OnUseEntity( CreateFRButton(< -2221.9000, 8789.6000, 42297.1000 >, < 0, -90.0002, 0 >, "%use% Next Exercise"), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< -6531.1010, 8698.3000, 41914.3000 >,< 0, 89.9998, 0 >)
    })
    AddCallback_OnUseEntity( CreateFRButton(< -17318.6100, 11875.4900, 41938.3500 >, < 0, -0.0004, 0 >, "%use% Next Exercise "), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< -21670, 7550, 41938.3500 >,< 0, 89.9998, 0 >)

    })
    AddCallback_OnUseEntity( CreateFRButton(< -2621.5070, 2607.6090, 41922.3500 >, < 0, -90.0002, 0 >, "%use% Back to Hub"), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< 10646, 9925, -4283 >,< 0, -89.9998, 0 >)
Message(user, "Hub")
    })
    AddCallback_OnUseEntity( CreateFRButton(< 10730, 9492.5090, -4296.6510 >, < 0, -179.9999, 0 >, "%use% Superglide Practice"), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< -17280, 7718, 41940 >,< 0, 89.9998, 0 >)
Message(user, "Superglide Practice")
    })
    AddCallback_OnUseEntity( CreateFRButton(< 9872, 5659.6190, -3696.6510 >, < 0, -90.0002, 0 >, "%use% Back to Hub"), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< 10646, 9925, -4283 >,< 0, -89.9998, 0 >)
Message(user, "Hub")
    })
    AddCallback_OnUseEntity( CreateFRButton(< -17280.6100, 8503.4930, 41938.3500 >, < 0, -0.0004, 0 >, "%use% Next Exercise "), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< -17280, 9112, 41940 >,< 0, 89.9998, 0 >)
    })
    AddCallback_OnUseEntity( CreateFRButton(< -8825.4000, 8789.6000, 41916.1000 >, < 0, -90.0002, 0 >, "%use% Back to Hub"), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< 10646, 9925, -4283 >,< 0, -89.9998, 0 >)
Message(user, "Hub")
    })
    AddCallback_OnUseEntity( CreateFRButton(< -17279.3900, 197.0068, 41938.3500 >, < 0, 180, 0 >, "%use% Back to Hub"), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< 10646, 9925, -4283 >,< 0, -89.9998, 0 >)
Message(user, "Hub")
    })
    AddCallback_OnUseEntity( CreateFRButton(< -8045.6020, 8572.1990, 42423.7000 >, < 0, -89.9997, 0 >, "%use% Repeat"), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< -8932.6010, 8698.3000, 41914.3000 >,< 0, 89.9998, 0 >)
Message(user, "Jump Pad Tap Strafes")
    })
    AddCallback_OnUseEntity( CreateFRButton(< -17589.3800, 197.0068, 41938.3500 >, < 0, 180, 0 >, "%use% Repeat"), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< -17280, 258.0005, 41940 >,< 0, 89.9998, 0 >)
    })
    AddCallback_OnUseEntity( CreateFRButton(< -11159.6100, 24859.4900, -3353.6510 >, < 0, 0, 0 >, "%use% Back to Hub"), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< 10646, 9925, -4283 >,< 0, -89.9998, 0 >)
Message(user, "Hub")
    })
    AddCallback_OnUseEntity( CreateFRButton(< 10942.4600, 10168.1100, -4296.6510 >, < 0, -90.0001, 0 >, "%use% TTV Building 1"), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< 9501, 5609, -3692 >,< 0, -180, 0 >)
Message(user, "TTV Building 1")
    })
    AddCallback_OnUseEntity( CreateFRButton(< 4663.4070, 1258.4930, -1263.6510 >, < 0, 0, 0 >, "%use% Skip"), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< 4242.7190, 1151.9690, -1075.7000 >,< 0, 180, 0 >)
    })
    AddCallback_OnUseEntity( CreateFRButton(< -17443.5000, 5211.3790, 41938.3500 >, < 0, 89.9995, 0 >, "%use% Next Exercise "), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< -17280, 7716, 41940 >,< 0, 89.9998, 0 >)

    })
    AddCallback_OnUseEntity( CreateFRButton(< -17443.4900, 5289.3820, 41938.3500 >, < 0, 89.9995, 0 >, "%use% Repeat"), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< -17280, 2500, 41940 >,< 0, 89.9998, 0 >)
    })
    AddCallback_OnUseEntity( CreateFRButton(< -23586.5100, 7616.3000, 41938.3500 >, < 0, -90.0002, 0 >, "%use% Back to Hub"), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< 10646, 9925, -4283 >,< 0, 89.9998, 0 >)
Message(user, "Hub")

    })
    AddCallback_OnUseEntity( CreateFRButton(< 3281.5070, 2094.3910, -1016.6510 >, < 0, 89.9998, 0 >, "%use% Skip"), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< 3320.5000, 3635.8000, -685 >,< 0, 60, 0 >)
    })
    AddCallback_OnUseEntity( CreateFRButton(< -17242.6100, 11875.4900, 41938.3500 >, < 0, -0.0004, 0 >, "%use% Repeat Exercise "), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< -17280, 9104, 41940 >,< 0, 89.9998, 0 >)

    })
    AddCallback_OnUseEntity( CreateFRButton(< -2451.5000, 8783, 42297.2000 >, < 0, 90.0002, 0 >, "%use% Repeat"), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< -2329.1000, 8714.7000, 41919.5000 >,< 0, 89.9998, 0 >)
Message(user, "Jump Pad Tap Strafes")
    })
    AddCallback_OnUseEntity( CreateFRButton(< -17279.3900, 2406.5070, 41938.3500 >, < 0, 180, 0 >, "%use% Back to Hub"), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< 10646, 9925, -4283 >,< 0, -89.9998, 0 >)
Message(user, "Hub")
    })
    AddCallback_OnUseEntity( CreateFRButton(< -5864.2000, 8790.7000, 42423.6000 >, < 0, 89.9999, 0 >, "%use% Next Exercise"), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< -8932.6010, 8698.3000, 41914.3000 >,< 0, 89.9998, 0 >)
    })
    AddCallback_OnUseEntity( CreateFRButton(< 3149.5070, 7037.3910, -1136.6510 >, < 0, 89.9998, 0 >, "%use% Skip"), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< 4593, 9070, -813.4000 >,< 0, 60, 0 >)
    })
    AddCallback_OnUseEntity( CreateFRButton(< -17279.3900, 9035.7570, 41938.3500 >, < 0, 180, 0 >, "%use% Back to Hub"), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< 10646, 9925, -4283 >,< 0, 89.9998, 0 >)
Message(user, "Hub")
    })
    AddCallback_OnUseEntity( CreateFRButton(< 10814.4100, 9492.5090, -4296.6510 >, < 0, -179.9999, 0 >, "%use% Advanced Tap Strafe into Wall Jump"), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< 3391.9900, 2660.3000, 42441.2000 >,< 0, 89.9998, 0 >)
Message(user, "Advanced Tap Strafe into Wall Jump")
    })
    AddCallback_OnUseEntity( CreateFRButton(< 10942.4500, 10005.1100, -4296.6510 >, < 0, -90.0001, 0 >, "%use% Skyhook TTV"), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< -11067, 24486, -3344 >,< 0, 0, 0 >)
Message(user, "Skyhook TTV")
    })
    AddCallback_OnUseEntity( CreateFRButton(< 1582.6090, 4863.5070, -3208.6510 >, < 0, 179.9997, 0 >, "%use% Back to Hub"), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< 10646, 9925, -4283 >,< 0, -89.9998, 0 >)
Message(user, "Hub")
    })
    AddCallback_OnUseEntity( CreateFRButton(< -6423.9000, 8789.6000, 41916.1000 >, < 0, -90.0002, 0 >, "%use% Back to Hub"), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< 10646, 9925, -4283 >,< 0, -89.9998, 0 >)
Message(user, "Hub")
    })
    AddCallback_OnUseEntity( CreateFRButton(< 10649, 9492.5060, -4296.6510 >, < 0, -179.9999, 0 >, "%use% Sideways Superglide Practice"), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< -21670, 7550, 41938.3500 >,< 0, 89.9998, 0 >)
Message(user, "Sideways Superglide Pracc")
    })
    AddCallback_OnUseEntity( CreateFRButton(< 3281.5070, 1146.3910, -1008.6510 >, < 0, 89.9998, 0 >, "%use% Skip"), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< 3389, 2069.1000, -1013.8000 >,< 0, 180, 0 >)
    })
    AddCallback_OnUseEntity( CreateFRButton(< 4199.3910, 1258.4930, -1074.6510 >, < 0, 0, 0 >, "%use% Skip"), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< 3389.2000, 1152, -1007.1000 >,< 0, 180, 0 >)
    })
    AddCallback_OnUseEntity( CreateFRButton(< 3281.5070, 3761.3910, -688.6514 >, < 0, 89.9998, 0 >, "%use% Skip"), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< 3231.9000, 6983.4000, -1132.3000 >,< 0, 60, 0 >)
    })
    AddCallback_OnUseEntity( CreateFRButton(< 5389.1710, 9096.6090, -688.3530 >, < 0, -89.9998, 0 >, "%use% Back to Hub"), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< 10646, 9925, -4283 >,< 0, -89.9998, 0 >)
Message(user, "Hub")
    })
    AddCallback_OnUseEntity( CreateFRButton(< 10534.2000, 10004.9000, -4296.6510 >, < 0, 90.0002, 0 >, "%use% Jump Pad Tap Strafes"), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< -2329.1000, 8714.7000, 41919.5000 >,< 0, 89.9998, 0 >)
Message(user, "Jump Pad Tap Strafes")
    })
    AddCallback_OnUseEntity( CreateFRButton(< 10534.2000, 10165.3900, -4296.6510 >, < 0, 90.0002, 0 >, "%use% Treerees Movement Map 1"), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< 6961, 1147.7710, -1453 >,< 0, -89.9998, 0 >)
Message(user, "Treerees Movement map")
    })
    AddCallback_OnUseEntity( CreateFRButton(< -2221.9000, 8789.6000, 41916.1000 >, < 0, -90.0002, 0 >, "%use% Back to Hub"), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< 10646, 9925, -4283 >,< 0, -89.9998, 0 >)
Message(user, "Hub")
    })
    AddCallback_OnUseEntity( CreateFRButton(< -17511.3800, 197.0068, 41938.3500 >, < 0, 180, 0 >, "%use% Next Exercise "), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< -17280, 2500, 41940 >,< 0, 89.9998, 0 >)
    })
    AddCallback_OnUseEntity( CreateFRButton(< 10534.2000, 10085.3900, -4296.6510 >, < 0, 90.0002, 0 >, "%use% Mantle Jump Practice "), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< -2789.5070, 2607.6090, 41922.3500 >,< 0, -89.9998, 0 >)
Message(user, "Mantle Jump Practice")
    })
    AddCallback_OnUseEntity( CreateFRButton(< -8265.7010, 8565.6000, 42423.6000 >, < 0, 89.9999, 0 >, "%use% Back to Hub"), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< 10646, 9925, -4283 >,< 0, -89.9998, 0 >)
Message(user, "Hub")
    })
    AddCallback_OnUseEntity( CreateFRButton(< -21642.5100, 7640.6090, 41938.3500 >, < 0, -90.0002, 0 >, "%use% Back to Hub"), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< 10646, 9925, -4283 >,< 0, -89.9998, 0 >)
Message(user, "Hub")
    })
    AddCallback_OnUseEntity( CreateFRButton(< 10569.1600, 9492.5090, -4296.6510 >, < 0, -179.9999, 0 >, "%use% Backwards Superglide Practice"), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< -23694, 7550, 41938.3500 >,< 0, 89.9998, 0 >)
Message(user, "Backwards Superglide Practice")
    })
    AddCallback_OnUseEntity( CreateFRButton(< 10942.4600, 10085.1100, -4296.6510 >, < 0, -90.0001, 0 >, "%use% TTV Building 2"), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< 1744.3380, 4889.6790, -3204 >,< 0, 0, 0 >)
Message(user, "TTV Building 2")
    })
    AddCallback_OnUseEntity( CreateFRButton(< 4658.3910, 9266.4920, -816.6514 >, < 0, 0, 0 >, "%use% Skip"), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< 5266.2000, 9155.5000, -687 >,< 0, 60, 0 >)
    })
    AddCallback_OnUseEntity( CreateFRButton(< -5644.1010, 8797.3000, 42423.7000 >, < 0, -89.9997, 0 >, "%use% Repeat"), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< -6531.1010, 8698.3000, 41914.3000 >,< 0, 89.9998, 0 >)
Message(user, "Jump Pad Tap Strafes")
    })

    //Jumppads 
    JumpPad_CreatedCallback( MapEditor_CreateProp( $"mdl/props/octane_jump_pad/octane_jump_pad.rmdl", < -2337.1000, 8867.7000, 41907 >, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    JumpPad_CreatedCallback( MapEditor_CreateProp( $"mdl/props/octane_jump_pad/octane_jump_pad.rmdl", < -6539.1000, 8867.7000, 41907 >, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    JumpPad_CreatedCallback( MapEditor_CreateProp( $"mdl/props/octane_jump_pad/octane_jump_pad.rmdl", < -8940.6000, 8867.7000, 41907 >, < 0, 0, 0 >, true, 50000, -1, 1 ) )

    //VerticalZipLines 
    MapEditor_CreateZiplineFromUnity( < -2790.5000, 3040.9000, 42745.8000 >, < 0, 0, 0 >, < -2790.5000, 3040.9000, 42019 >, < 0, 0, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [ ], [ ], [ ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < -2790.5000, 2171.6000, 42557.7000 >, < 0, 0, 0 >, < -2790.5000, 2171.6000, 42015.5000 >, < 0, 0, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [ ], [ ], [ ], 32, 60, 0 )

    //Props 
    MapEditor_CreateProp( $"mdl/ola/sewer_railing_01_128.rmdl", < 9593.6040, -182.1000, 42431.7000 >, < 0, -90.0005, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/ola/sewer_railing_01_128.rmdl", < 9697.8000, -776.1000, 42431.7000 >, < 0, 89.9999, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 9647, -55, 42424.9000 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 9647, -903, 42424.9000 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 3391.9900, 6719.3000, 42871 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.0390, 6186.9390, 42823.2000 >, < 0, -90, 179.9997 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.0400, 5841, 42759.9300 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.0390, 6315.1600, 42823.5900 >, < 0, -90, 179.9997 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.0400, 6315.4500, 42815.3100 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.0390, 5712.7800, 42768.3100 >, < 0, -90, 179.9997 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.0390, 5841, 42768.7000 >, < 0, -90, 179.9997 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.0400, 5712.7800, 42760.3100 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.0400, 6186.9390, 42815.2000 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 3391.9900, 5902.0500, 42836.1400 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 3391.9900, 6376.5000, 42891.5200 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.0400, 5388.4500, 42707.3800 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 3391.9900, 5449.5000, 42783.5900 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.0390, 5259.9390, 42715.2700 >, < 0, -90, 179.9997 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.0400, 4914, 42652 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.0390, 5388.1600, 42715.6600 >, < 0, -90, 179.9997 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.0390, 4785.7800, 42660.3800 >, < 0, -90, 179.9997 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.0390, 4914, 42660.7700 >, < 0, -90, 179.9997 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.0400, 4785.7800, 42652.3800 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.0400, 5259.9390, 42707.2700 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 3391.9900, 4975.0500, 42728.2100 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.0400, 4458.9500, 42578.3900 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 3391.9900, 4520, 42654.6000 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.0390, 4330.4390, 42586.2800 >, < 0, -90, 179.9997 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.0400, 3984.5000, 42523.0100 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.0390, 4458.6600, 42586.6700 >, < 0, -90, 179.9997 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.0390, 3856.2800, 42531.3900 >, < 0, -90, 179.9997 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.0390, 3984.5000, 42531.7800 >, < 0, -90, 179.9997 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.0400, 3856.2800, 42523.3900 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.0400, 4330.4390, 42578.2900 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 3391.9900, 4045.5500, 42599.2200 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 3391.9900, 2753.8000, 42424.9000 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.0400, 3546.4000, 42472 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 3391.9900, 3607.4500, 42548.2100 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.0390, 3417.8900, 42479.8900 >, < 0, -90, 179.9997 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.0400, 3071.9500, 42416.6200 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.0390, 3546.1100, 42480.2700 >, < 0, -90, 179.9997 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.0390, 2943.7300, 42425 >, < 0, -90, 179.9997 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.0390, 3071.9500, 42425.3900 >, < 0, -90, 179.9997 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.0400, 2943.7300, 42417 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.0400, 3417.8900, 42471.8900 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 3391.9900, 3133, 42492.8200 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -2796, 2604, 41923.5000 >, < 0, 0, -179.9999 >, true, 50000, -1, 2.74 )
    MapEditor_CreateProp( $"mdl/signs/street_sign_arrow.rmdl", < -21848, 7202.0010, 42026 >, < -0.0003, 90.0002, 180 >, true, 50000, -1, 3.15 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 4452, 1368, -1089.9000 >, < 0, 0, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3018.9990, 4922, -772.0496 >, < 0, 179.9997, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_barrier_concrete_128_01.rmdl", < 3071.9400, 6911.0500, -1152.3100 >, < 0, 0, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/levels_terrain/mp_rr_canyonlands/clands_roof_bars_01_fglass_blue.rmdl", < -23324, 7747.6550, 42169.6900 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 7125.9990, 1265.3000, -1242 >, < 0, -180, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 5887.5220, 1152.9800, -704.2010 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4734.2990, 1038, -967.6000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 6337.4000, 1156.4000, -1088 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4301, 1274.3990, -968.1001 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 3584, 1152.9800, -704.2010 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/levels_terrain/mp_rr_canyonlands/clands_roof_bars_01_fglass_blue.rmdl", < -23564, 7747.6550, 42169.6900 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6990.0010, 1046.5000, -1242 >, < 0, 0, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3507.8000, 2086.3000, -1223.5000 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 4607.0150, 1152.9800, -704.2010 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3356.2000, 6063, -1148.3490 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/signs/street_sign_arrow.rmdl", < -17110.3400, 3286, 42018 >, < 0, 179.9997, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < -2943.9000, 2922, 41815.3000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_support_beam_16x144_filler.rmdl", < 3647.2200, 6528.4300, -1216.4400 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < -2887.9000, 2922, 41963.4000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_small_03.rmdl", < 6852.8000, 1141.3000, -1059.4000 >, < 0, -179.9999, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -17182, 4173.6000, 41916.9000 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3507.8000, 2086.3000, -841.3000 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 5627.4000, 1038, -1222.5000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -23450.8400, 7428.7500, 41923.2500 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -21477.0100, 7009.0020, 41940 >, < 90, 179.9996, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3521.5990, 2599, -569.7486 >, < -90, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/signs/street_sign_arrow.rmdl", < -2338.4000, 9119.3000, 41946.8000 >, < -90, 180, 0 >, true, 50000, -1, 4.715525 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -2796.7000, 2849, 42337.6000 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3274.4000, 1583.5010, -713.8999 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -6665.8000, 8923.3000, 41893.2000 >, < 0, 0.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 4287, 1151.9500, -1343.9900 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/signs/street_sign_arrow.rmdl", < -17192, 2972, 42018 >, < -0.0003, 0.0003, 180 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3701.0010, 4159, -634.3495 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_support_beam_16x144_filler.rmdl", < 3391.6200, 7935.3600, -1087.3300 >, < 0, 0, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < -2943.9000, 2922, 42411.1000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_support_beam_16x144_filler.rmdl", < 3135.7200, 6528.1500, -831.0500 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 3392, 3712, -704 >, < 0, 0, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desrtlands_icicles_06.rmdl", < 3391.4600, 5248.4200, -906.8265 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/highrise_square_block_02.rmdl", < -6008.9830, 8833.6000, 42193.9600 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3507.8000, 2599, -1214.3500 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3640.0010, 5827, -900.3495 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 3792.8750, 8255.9000, -1145.5470 >, < 0, 90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_barrier_concrete_128_01.rmdl", < 3007.0500, 6976.1100, -1152.3100 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 10948.9600, 9704, -4050.0010 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_train_station_railing_02.rmdl", < 4031.9400, 1023.0200, -704.2100 >, < 0, 0, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -21748, 7638, 41923.2500 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3273.6000, 1142.8000, -1223 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 5627.4000, 1038, -1095 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -17152.0100, 644, 41916 >, < -90, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 6721.4000, 1156.4000, -1088 >, < 0, 0, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_train_station_sign_04.rmdl", < 5056.6400, 9152.7600, -703.9010 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 3391.0300, 7808.1600, -959.8110 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desrtlands_icicles_06.rmdl", < 3327.1800, 2228.9540, -1153.6810 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desrtlands_icicles_06.rmdl", < 3327.1800, 3648.4900, -715.6808 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_train_station_railing_02.rmdl", < 3263.9000, 6528.8600, -704.4990 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/highrise_square_block_02.rmdl", < -6008.9830, 8833.6000, 41900.3000 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 4672, 1152, -1280 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_barrier_concrete_128_01.rmdl", < 3263.1100, 7360, -1152.4500 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 7041.4000, 1156.4000, -1216 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_train_station_railing_02.rmdl", < 4159.9400, 1023.0200, -704.2100 >, < 0, 0, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6518.3000, 1038.4000, -840.3000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_apartments_planter_02.rmdl", < -21780, 7848, 41938.0200 >, < 0, 0, 0 >, true, 50000, -1, 1.19 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < -21311.1000, 7636.4970, 42171.9300 >, < 0, -179.9997, 89.9998 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 4351.0700, 8895.9900, -1152.3600 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_barrier_concrete_128_01.rmdl", < 3712.2200, 7168.9000, -1152.3800 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 4095.9700, 1152.9800, -704.1930 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/plant_desert_yucca_01.rmdl", < -20967.5600, 7847.7130, 41972.8000 >, < 0, 89.9998, 0 >, true, 50000, -1, 0.45 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 4544.9400, 8896.0500, -896.3500 >, < 0, 90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/barriers/concrete/concrete_barrier_fence.rmdl", < -17416, 231.0005, 41935.8600 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_building_ice_02.rmdl", < -23804.6100, 7318.9230, 41979.3200 >, < 1.1701, -165.0450, -4.3717 >, true, 50000, -1, 0.09 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4291.8990, 1038.4000, -840.3000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < -2943.9000, 2230.8000, 42203.7000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/highrise_square_block_02.rmdl", < -8684, 8833.6000, 42487.6300 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 10515.0400, 10144, -4178 >, < 0, -179.9997, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_barrier_concrete_128_01.rmdl", < 3776.8200, 6975.7500, -1152.5100 >, < 0, 90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 5640.1010, 1274.4000, -968.1000 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -20925, 7410.9870, 41940 >, < 90, -90.0005, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 4101.0050, 1091.7700, -1071.9900 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desrtlands_icicles_06.rmdl", < 3391.1600, 6481.1300, -1461.6420 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < -2792.0250, 3047, 42137.7000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/colony/ventilation_unit_01_black.rmdl", < 5503.4700, 9087.2100, -704.3140 >, < 0, 0, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3274, 1583.5000, -968.5999 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/signs/street_sign_arrow.rmdl", < -17166, 4865, 42028 >, < -90, 179.9997, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_train_station_railing_02.rmdl", < 3391.0100, 7808.0600, -704.0960 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3507.8000, 1498.5990, -713.8999 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < -2584.2000, 2230.8000, 42054.2000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_train_station_railing_02.rmdl", < 4351.0400, 8768.2700, -639.8930 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_support_beam_16x144_filler.rmdl", < 3647.5500, 6528.2200, -831.1340 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/highrise_square_block_02.rmdl", < -6556.0170, 8661.2600, 42193.9600 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 10731.0400, 10360, -3922.0020 >, < 0, 90.0005, 0 >, true, 50000, -1, 0.9999999 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -21185.0800, 7768.0010, 41923.2500 >, < 0, 90.0002, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < -2943.9000, 2230.8000, 41904.9000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/barriers/concrete/concrete_barrier_fence.rmdl", < -17416, 497.0005, 41935.8600 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_small_02.rmdl", < 10852, 9578.0010, -3788 >, < 90, 89.9998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3267, 2599, -1214.3500 >, < 0, -179.9999, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/wall_city_barred_concrete_192_01.rmdl", < 3135, 6655.9600, -1216.0600 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 3520.9700, 2560.0600, -896.2350 >, < 0, 90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -5881.2000, 8899.7000, 42400.6000 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/highrise_square_block_02.rmdl", < -8410.4830, 8833.6000, 42193.9600 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.0390, 3417.8900, -705.0012 >, < 0, -90, 179.9997 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3521.5990, 2086.3000, -705.9990 >, < -90, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_train_station_railing_02.rmdl", < 3776.0400, 1280.6500, -704.7630 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_small_02.rmdl", < 10852, 9442, -3788 >, < 90, 89.9998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -8283.8000, 8427, 42400.9000 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < -2887.9000, 2922, 41815.3000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 5185, 1038, -1349.6000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desrtlands_icicles_06.rmdl", < 3263.1800, 5248.4100, -907.1565 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_support_beam_16x144_filler.rmdl", < 3647.1300, 6528.4700, -1087.8700 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3377.6000, 2086.3000, -1015.7000 >, < 90, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/plant_desert_yucca_01.rmdl", < -21819.5600, 7105.7130, 41972.8000 >, < 0, 89.9998, 0 >, true, 50000, -1, 0.45 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_bott.rmdl", < -2791.8750, 2161.8000, 41924 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < -2887.9000, 2230.8000, 41904.9000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3273.6000, 1142.7990, -1350.1000 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 4479.0150, 1152.9800, -704.2010 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -20923.0200, 7023, 41940 >, < 90, 179.9996, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/wall_city_corner_concrete_64_01.rmdl", < 3647.1600, 6528.1800, -1216.5100 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_train_station_sign_04.rmdl", < 3391.1600, 6528.5500, -1216.0100 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4807.9990, 1160, -704 >, < 0.0003, 179.9998, 180 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3267, 2599, -832.3495 >, < 0, -179.9999, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/signs/street_sign_arrow.rmdl", < -21120, 7038.0010, 42026 >, < -0.0003, -180, 180 >, true, 50000, -1, 3.15 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -21877.9800, 7896, 41940 >, < 90, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3507.8000, 2599, -705.0496 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3018.9990, 4922, -1281.3500 >, < 0, 179.9997, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 7253.9990, 1265.3000, -802.2000 >, < 0, -180, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desrtlands_icicles_06.rmdl", < 3391.2500, 2670.0240, -1008.6380 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 5640.1010, 1274.4000, -1095.5000 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 3392, 7040, -1152 >, < 0, 0, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 3392, 1152, -1024 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 4160, 8448, -960 >, < 0, 0, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/highrise_square_block_02.rmdl", < -6282.5000, 8661.2600, 41900.3000 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 5194.1010, 1274.3980, -1350.1000 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desrtlands_icicles_06.rmdl", < 3501.9760, 1151.0500, -1033.6380 >, < 0, -0.0002, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -17182, 2906, 41916.9000 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3250.5000, 6614, -1320.0010 >, < 90, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 10731.0400, 10360, -4306 >, < 0, 90.0005, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4734.2990, 1038.4000, -712.9000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6085.0010, 1274.3990, -1223 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 7003.2980, 1265.3010, -1242 >, < 0, -180, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/firstgen/firstgen_pipe_256_darkcloth_01.rmdl", < 5312.1900, 9088.9500, -832.2420 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_barrier_concrete_128_01.rmdl", < 3520.7900, 7232.1000, -1152.6000 >, < 0, 90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < -17216, 7864, 41939.8000 >, < 0, -179.9998, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.0400, 3546.1100, -713.3850 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 3328, 5312, -896 >, < 0, 0, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3507.8000, 2086.3000, -1350.6000 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/highrise_square_block_02.rmdl", < -8410.4830, 8661.2600, 42487.6300 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/highrise_square_block_02.rmdl", < -8684, 8833.6000, 41900.3000 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_train_station_railing_02.rmdl", < 4032, 1280.6500, -704.7560 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 4990.9840, 1152.9800, -704.1930 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -17152, 169.7680, 41916 >, < -90, -89.9998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 4544.9700, 8895.7700, -640.0760 >, < 0, 90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < -2640.2000, 2922, 41963.4000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_support_beam_16x144_vertical.rmdl", < 6848.6800, 1284.9300, -1472.4400 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/signs/street_sign_arrow.rmdl", < -17078, 5179, 42032 >, < 0, 162.5526, 0 >, true, 50000, -1, 2.75 )
    MapEditor_CreateProp( $"mdl/firstgen/firstgen_pipe_128_goldfoil_01.rmdl", < 5056.6700, 9088.0200, -703.2550 >, < 0, 90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 5185, 1038.4000, -840.3000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/highrise_square_block_02.rmdl", < -8957.5170, 8833.6000, 42193.9600 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < -2640.2000, 2230.8000, 41904.9000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < -2640.2000, 2230.8000, 42054.2000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < -17280, 11184.1900, 41953.8000 >, < 0, -179.9998, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -17154, 622.0114, 41916 >, < -90, -89.9998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/levels_terrain/mp_rr_canyonlands/clands_roof_bars_01_fglass_blue.rmdl", < -23324, 7523.6550, 42169.6900 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desrtlands_icicles_06.rmdl", < 3327.1800, 2462.9540, -1008.6810 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desrtlands_icicles_06.rmdl", < 5035.9560, 1215.0210, -1292.7460 >, < 0, -0.0002, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4291.8990, 1038.4000, -712.9000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -21877.9900, 7764, 41940 >, < 90, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17280, 7768.4990, 41923.5000 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3377.6000, 6614, -1320.0010 >, < 90, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/highrise_square_block_02.rmdl", < -6556.0170, 8661.2600, 42781.2900 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_support_beam_16x144_filler.rmdl", < 3391.8400, 7935.7100, -831.0560 >, < 0, 0, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4291.8990, 1038, -967.6000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 6780.4780, 1152.9800, -704.1930 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/highrise_square_block_02.rmdl", < -8410.4830, 8833.6000, 41900.3000 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -20948.9900, 7896.9930, 41940 >, < 90, -0.0007, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6072.3000, 1038, -1222.5000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4747, 1274.3990, -1223 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17280, 10426.7500, 41923.5000 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < -2584.2000, 2922, 41815.3000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -21057, 7662.9940, 41940 >, < 90, -90.0005, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/plant_desert_yucca_01.rmdl", < -20967.5600, 7801.5490, 41972.8000 >, < 0, 89.9998, 0 >, true, 50000, -1, 0.45 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_apartments_planter_02.rmdl", < -21020, 7064, 41938.0200 >, < 0, 0, 0 >, true, 50000, -1, 1.19 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3640.0010, 5827, -1282.3500 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 3392.9500, 7104.0100, -1407.6800 >, < 0, 90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6085.0010, 1274, -713.3998 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3267, 2086.3000, -1350.6000 >, < 0, -179.9999, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_train_station_railing_02.rmdl", < 3648.0200, 1023.3000, -704.7100 >, < 0, 0, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4807.9990, 1160, -953.9996 >, < 0.0003, 179.9998, 180 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/highrise_square_block_02.rmdl", < -8684, 8833.6000, 42193.9600 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6527.4000, 1274.4000, -968.1000 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -21876, 7874.0120, 41940 >, < 90, 89.9998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/highrise_square_block_02.rmdl", < -6008.9830, 8661.2600, 42487.6300 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 10731.0400, 9487.9990, -3922.0020 >, < 0, -89.9998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desrtlands_icicles_06.rmdl", < 3327.1800, 1944.9540, -1138.6810 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3508.1990, 1498.6000, -1350.6000 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_sign_01.rmdl", < 3400.1700, 6520.9100, -1212.3800 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/plant_desert_yucca_01.rmdl", < -20972.2900, 7063.5600, 41972.8000 >, < 0, 0, 0 >, true, 50000, -1, 0.45 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4301, 1274.3980, -1350.1000 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 6657.5000, 1283.4300, -1344.2100 >, < 0, 0, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3507.8000, 2086.3000, -968.5999 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < -23628, 7940.1470, 41951.8000 >, < 0, -179.9998, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -17456, 5380.1000, 41915.6000 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/highrise_square_block_02.rmdl", < -8684, 8833.6000, 42781.2900 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3860.9000, 1274.3990, -968.1001 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 10515.0400, 10144, -4306 >, < 0, -179.9997, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/levels_terrain/mp_rr_canyonlands/clands_roof_bars_01_fglass_blue.rmdl", < -20926, 7245.6550, 42169.6900 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/barriers/concrete/concrete_barrier_fence.rmdl", < -17416, 629.0005, 41935.8600 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6072.3000, 1038, -967.6000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6072.3000, 1038.4000, -840.3000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < -2887.9000, 2922, 42261.6000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3273.9990, 1142.8010, -713.3999 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -6433.5000, 8923.3000, 41893.2000 >, < 0, 0.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 5759.5220, 1152.9800, -704.2010 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/plant_desert_yucca_01.rmdl", < -21780.2900, 7847.5600, 41972.8000 >, < 0, 0, 0 >, true, 50000, -1, 0.45 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < -2640.2000, 2922, 42261.6000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/lightpole_desertlands_city_01.rmdl", < 3792.7650, 8384.6600, -634.5630 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < -2791.8750, 2161.8000, 42344.7000 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 10948.9600, 10144, -4050.0010 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -6665.9000, 8899.7000, 41893.4000 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/highrise_square_block_02.rmdl", < -8684, 8661.2600, 42487.6300 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desrtlands_icicles_06.rmdl", < 3391.2500, 1945.0240, -1138.6380 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_support_beam_16x144_filler.rmdl", < 3135.0800, 6528.3900, -1216.0800 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 5194.1010, 1274.3980, -1095.5000 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 3392, 4480, -768 >, < 0, 0, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/curb_parking_concrete_destroyed_01.rmdl", < 3455.2200, 6528.5200, -1216.3300 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -5881.2000, 8652.2000, 42400.6000 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < -2640.2000, 2922, 42112.3000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 10731.0400, 10360, -4050.0010 >, < 0, 90.0005, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 4992.5070, 1152.9800, -704.2010 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.0400, 3071.9500, -768.2730 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 3264, 6656, -1216 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3640.0010, 5827, -645.6495 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3267, 2599, -959.7496 >, < 0, -179.9999, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17280, 514.4995, 41923.1000 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3640.0010, 5827, -1155.2500 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < -2584.2000, 2922, 41963.4000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4301, 1273.9990, -840.8000 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4291.8990, 1038, -1222.5000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -2796.7000, 2849, 42545.4000 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3386.0500, 2558.5510, -879.4496 >, < 90, 89.9998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 3648, 7040, -1152 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_05.rmdl", < 3392.5800, 3712.0700, -704.8130 >, < 0, 90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -21865, 7007.0230, 41940 >, < 90, 89.9998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < -17344, 8288, 41939.8000 >, < 0, -179.9998, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3018.9990, 4922, -899.3495 >, < 0, 179.9997, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_support_beam_16x144_filler.rmdl", < 3135.2400, 6528.3100, -1087.4300 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 4195.9000, 1152, -1089.9000 >, < 0, 0, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.0400, 3417.8900, -712.9990 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3401, 1038, -1095 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -20923.0100, 7155, 41940 >, < 90, 179.9996, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3356.2000, 6063, -1530.3500 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3508.2000, 1498.5990, -1223.5000 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_train_station_railing_02.rmdl", < 4351, 8896.0700, -639.9730 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3356.2000, 6063, -893.6495 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_apartments_planter_02.rmdl", < -21828, 7848, 41938.0200 >, < 0, 0, 0 >, true, 50000, -1, 1.19 )
    MapEditor_CreateProp( $"mdl/foliage/plant_desert_yucca_01.rmdl", < -21819.5600, 7059.5490, 41972.8000 >, < 0, 89.9998, 0 >, true, 50000, -1, 0.45 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 10731.0400, 9487.9990, -4050.0010 >, < 0, -89.9998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 4223.9700, 1152.9800, -704.1930 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_small_02.rmdl", < 10588, 10122, -3788 >, < 90, 89.9998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3250.5000, 2086.3000, -1015.7000 >, < 90, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4747, 1273.9990, -840.8000 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_barrier_concrete_128_01.rmdl", < 3776.8500, 7104.1900, -1152.4900 >, < 0, 90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17280, 9804, 41923.5000 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3843.4000, 1038, -1095 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < -20948.5100, 7407.1020, 42171.9300 >, < 0, 90.0005, 89.9998 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 5640.1010, 1273.9990, -840.8000 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/highrise_square_block_02.rmdl", < -8410.4830, 8488.9200, 42193.9600 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_small_02.rmdl", < 3519.6700, 1152.7000, -722 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -21054.5800, 7768, 41923.5000 >, < 0, 90.0002, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desrtlands_icicles_06.rmdl", < 5035.9760, 1151.0500, -1292.6380 >, < 0, -0.0002, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_barrier_concrete_128_01.rmdl", < 3584.0300, 6913, -1152.0400 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 5185, 1038, -1095 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desrtlands_icicles_06.rmdl", < 3455.2200, 2229.0440, -1153.7460 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/levels_terrain/mp_rr_canyonlands/clands_roof_bars_01_fglass_blue.rmdl", < -20926, 7640, 42169.6900 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desrtlands_icicles_06.rmdl", < 3455.2200, 3648.5800, -715.7458 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3401, 1038, -1349.6000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4746.9990, 1274.3990, -1350.1000 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -21748, 7768.4990, 41923.5000 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/lightpole_desertlands_city_01.rmdl", < 3392.6600, 7936.7500, -704.0550 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4747, 1274.4000, -968.1000 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_train_station_railing_02.rmdl", < 3793.1050, 8255.8900, -634.2870 >, < 0, 90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/highrise_square_block_02.rmdl", < -8410.4830, 8488.9200, 42487.6300 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -8283.7000, 8698.1000, 42400.7000 >, < 0, 0.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3507.8000, 2599, -832.3495 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6527.4000, 1274.4000, -1350.1000 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 4735.0150, 1152.9800, -704.2010 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -17144, 3228, 41916.9000 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < -2887.9000, 2922, 42411.1000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/domestic/bar_sink.rmdl", < -23749.9600, 7955.8140, 41982.6700 >, < 0, 179.9997, 0 >, true, 50000, -1, 1.54 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -5881.1000, 8923.3000, 42400.4000 >, < 0, 0.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/highrise_square_block_02.rmdl", < -6556.0170, 8833.6000, 42781.2900 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 3392, 7296, -1152 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_apartments_planter_02.rmdl", < -20972, 7064, 41938.0200 >, < 0, 0, 0 >, true, 50000, -1, 1.19 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6739.3000, 1046.5000, -802.2000 >, < 0, 0, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < -2584.2000, 2922, 42112.3000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_support_beam_16x144_filler.rmdl", < 3391.6100, 7679.4000, -959.3030 >, < 0, 0, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/highrise_square_block_02.rmdl", < -8957.5170, 8661.2600, 42781.2900 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 5627.4000, 1038.4000, -840.3000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 6913.4000, 1156.4000, -1472 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_train_station_railing_02.rmdl", < 3391.9200, 6528.8700, -704.4930 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -2337.1000, 8790, 41901 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/colony/antenna_03_colony.rmdl", < 3392.8500, 6527.6500, -704.3920 >, < 0, 90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/highrise_square_block_02.rmdl", < -8410.4830, 8833.6000, 42487.6300 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -23450.8400, 7559.2490, 41923.5000 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.0400, 2943.7300, -767.8870 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 5627.4000, 1038, -1349.6000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_train_station_turnstile_01.rmdl", < 5055.1300, 9151.8600, -704.4630 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 3400, 2128, -1032 >, < 0, 0, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/signs/street_sign_arrow.rmdl", < -8053, 9087.6890, 42505.9000 >, < -0.0001, -90, 180 >, true, 50000, -1, 4.715525 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3701.0010, 4159, -379.6495 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/wall_city_corner_concrete_64_01.rmdl", < 3136.9200, 6784.0100, -1216.3900 >, < 0, 90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/highrise_square_block_02.rmdl", < -8410.4830, 8488.9200, 41900.3000 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_train_station_railing_02.rmdl", < 3793.1050, 8384.1400, -634.2771 >, < 0, 90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3507.8000, 2086.3000, -1096 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/signs/street_sign_arrow.rmdl", < -21684, 7879.9990, 42026 >, < -0.0003, -0.0003, 180 >, true, 50000, -1, 3.15 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -8051.3990, 8698.1000, 42400.7000 >, < 0, 0.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desrtlands_icicles_06.rmdl", < 3455.1500, 6481.1500, -1461.7420 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 3519.9200, 6528.4900, -1216.8700 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 6721.4000, 1156.4000, -1344 >, < 0, 0, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < -2887.9000, 2922, 42112.3000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/levels_terrain/mp_rr_canyonlands/clands_roof_bars_01_fglass_blue.rmdl", < -21620, 7671.6550, 42169.6900 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3860.9000, 1274.3980, -1095.5000 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 5120.5070, 1152.9800, -704.2010 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17274, 5108.5000, 42066 >, < 90, 90.0002, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 3712, 7744, -1024 >, < 0, 0, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3267, 2086.3000, -713.8999 >, < 0, -179.9999, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_bott.rmdl", < -2792.0250, 3047, 41924 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 5183.9800, 9215, -959.9800 >, < 0, 0, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 4351.0100, 8896.1500, -896.0700 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desrtlands_icicles_06.rmdl", < 3501.9560, 1215.0210, -1033.7460 >, < 0, -0.0002, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_small_02.rmdl", < 10852, 10122, -3788 >, < 90, 89.9998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -21642, 7766, 41940 >, < 90, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -9069.6010, 8923.3000, 41893.2000 >, < 0, 0.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/signs/street_sign_arrow.rmdl", < -17137.0300, 3286, 42028 >, < -90, 179.9997, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3401, 1038, -967.6000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/highrise_square_block_02.rmdl", < -6008.9830, 8661.2600, 41900.3000 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desrtlands_icicles_06.rmdl", < 4085.9760, 1161.0500, -1101.6380 >, < 0, -0.0002, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/highrise_square_block_02.rmdl", < -6556.0170, 8661.2600, 42487.6300 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6518.3000, 1038, -1222.5000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -23692, 7844.6460, 41923.5000 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_barrier_concrete_128_01.rmdl", < 3007.0400, 7104.0300, -1152.2800 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/signs/street_sign_arrow.rmdl", < -17166, 2972, 42028 >, < -90, 179.9997, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_small_02.rmdl", < 10852, 10258, -3788 >, < 90, 89.9998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6801.7990, 1160.9990, -1299 >, < 0, -90, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_barrier_concrete_128_01.rmdl", < 3584.0700, 7168.9200, -1152.3900 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/highrise_square_block_02.rmdl", < -6556.0170, 8833.6000, 42193.9600 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_train_station_railing_02.rmdl", < 3135.8000, 6528.8500, -704.4860 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_support_beam_16x144_filler.rmdl", < 3391.7600, 7679.5400, -831.1430 >, < 0, 0, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_support_beam_16x144_filler.rmdl", < 3391.4700, 7935.1700, -1216.1400 >, < 0, 0, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3267, 2599, -577.6495 >, < 0, -179.9999, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6527.4010, 1274.0010, -713.3999 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < -21311.1000, 7873.4920, 42171.9300 >, < 0, -179.9997, 89.9998 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 6268.5070, 1152.9800, -704.2010 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -21735, 7243.0040, 41940 >, < 90, 89.9998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < -2584.2000, 2922, 42411.1000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4747, 1274.4000, -1095.5000 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desrtlands_icicles_06.rmdl", < 3391.2500, 2229.0240, -1153.6380 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_support_beam_16x144_filler.rmdl", < 3391.7200, 7935.5100, -959.1760 >, < 0, 0, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3267, 2599, -1087.2500 >, < 0, -179.9999, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3507.8000, 2599, -1087.2500 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3267, 2086.3000, -841.3000 >, < 0, -179.9999, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desrtlands_icicles_06.rmdl", < 3455.2200, 1945.0440, -1138.7460 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 7118.0010, 1046.5000, -802.2000 >, < 0, 0, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 10948.9600, 9704, -3922.0020 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < -21852.9900, 7509.9340, 42171.9300 >, < 0, -89.9998, 89.9998 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/highrise_square_block_02.rmdl", < -8957.5170, 8833.6000, 42781.2900 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_support_beam_16x144_filler.rmdl", < 3647.3200, 6528.3400, -959.3500 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/signs/street_sign_arrow.rmdl", < -23632, 7352.0020, 41962 >, < -4.5580, 120.1054, 142.0979 >, true, 50000, -1, 2.46 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3267, 2599, -705.0496 >, < 0, -179.9999, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6072.3000, 1038.4000, -712.9000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4734.2990, 1038, -1095 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_train_station_railing_02.rmdl", < 3904, 1280.6500, -704.7580 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -21159, 7153.0010, 41940 >, < 90, 179.9996, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/plant_desert_yucca_01.rmdl", < -21018.4500, 7063.5600, 41972.8000 >, < 0, 0, 0 >, true, 50000, -1, 0.45 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < -2887.9000, 2230.8000, 42054.2000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/signs/street_sign_arrow.rmdl", < -17280, 788.4995, 41992 >, < 0, 179.9997, 0 >, true, 50000, -1, 2.98 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 3968, 1152.9800, -704.2010 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desrtlands_icicles_06.rmdl", < 3327.1200, 4416.4200, -788.2274 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 3712, 1152.9800, -704.2010 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4301, 1274.3980, -1223 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/signs/street_sign_arrow.rmdl", < -8961.3970, 9119, 41946.8000 >, < -45, -0.0001, 180 >, true, 50000, -1, 4.715525 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3273.5990, 1142.8000, -1095.5000 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/colony/ventilation_unit_01_black.rmdl", < 5503.5200, 9215.2300, -704.4200 >, < 0, 0, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 6602.5000, 1156.5700, -1344.4200 >, < 0, 90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6875.2980, 1265.3000, -1242 >, < 0, -180, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < -2640.2000, 2922, 42411.1000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -9069.7000, 8652.2000, 41893.4000 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6518.3000, 1038, -1349.6000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17326, 5252, 41923.5000 >, < 0, 89.9995, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 10731.0400, 9487.9990, -4178 >, < 0, -89.9998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_train_station_railing_02.rmdl", < 3520.0300, 6528.8600, -704.5070 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/lightpole_desertlands_city_01.rmdl", < 4352.6500, 9024.7600, -639.9790 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_small_03.rmdl", < 6852.8000, 1013.8000, -1059.4000 >, < 0, -179.9999, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 5185, 1038, -967.6000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 3263.9000, 6528.6100, -1216.7900 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -21059, 7898.9900, 41940 >, < 90, -90.0005, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3267, 2086.3000, -968.5999 >, < 0, -179.9999, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 5119.9300, 959.1390, -1344.5000 >, < 0, 0, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6739.3000, 1046.5000, -1242 >, < 0, 0, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_small_02.rmdl", < 10588, 9442, -3788 >, < 90, 89.9998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 3791.1250, 8256.1100, -890.1671 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_small_02.rmdl", < 10588, 9714, -3788 >, < 90, 89.9998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3640.0010, 5827, -1027.7500 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -21641.9900, 7896, 41940 >, < 90, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -21054.5800, 7281.0830, 41923.2500 >, < 0, 0.0003, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < -17280, 10521.3800, 41953.8000 >, < 0, -179.9998, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < -2943.9000, 2230.8000, 42054.2000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 4736.5070, 1152.9800, -704.2010 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desrtlands_icicles_06.rmdl", < 3502.0460, 1086.9810, -1033.6810 >, < 0, -0.0002, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 10731.0400, 10360, -4178 >, < 0, 90.0005, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_support_beam_16x144_vertical.rmdl", < 3264.9700, 2239.7800, -895.9030 >, < 0, 90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desrtlands_icicles_06.rmdl", < 4085.9560, 1225.0210, -1101.7460 >, < 0, -0.0002, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -20927, 7662.9830, 41940 >, < 90, -90.0005, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/barriers/concrete/concrete_barrier_fence.rmdl", < -17416, 363.0005, 41935.8600 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6801.8000, 1289, -1299 >, < 0, -90, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 4452, 944.0005, -1089.9000 >, < 0, 0, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 5627.4000, 1038, -967.6000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 6524.5070, 1152.9800, -704.2010 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 5825.4000, 1156.4000, -1088 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17280, 298.2555, 41923.5000 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/highrise_square_block_02.rmdl", < -6282.5000, 8833.6000, 41900.3000 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_train_station_railing_02.rmdl", < 3903.9600, 1023.0200, -704.1960 >, < 0, 0, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -20925.0100, 7044.9870, 41940 >, < 90, -90.0005, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < -2791.8750, 2161.8000, 42137.7000 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4301, 1273.9990, -713.4000 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desrtlands_icicles_06.rmdl", < 4086.0460, 1096.9810, -1101.6810 >, < 0, -0.0002, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/highrise_square_block_02.rmdl", < -8410.4830, 8661.2600, 41900.3000 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/highrise_square_block_02.rmdl", < -8957.5170, 8661.2600, 42487.6300 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 5640.1010, 1274.3990, -1223 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 3264.0600, 6527.0200, -960.1880 >, < 0, 0, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 3840, 1152.9800, -704.2010 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.0390, 3546.1100, -704.6152 >, < 0, -90, 179.9997 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 4416, 1152, -1280 >, < 0, 0, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 5640.1010, 1274, -713.4000 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_small_02.rmdl", < 10852, 9986.0010, -3788 >, < 90, 89.9998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desrtlands_icicles_06.rmdl", < 3327.0800, 6481, -1461.7120 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6518.3000, 1038, -1095 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3701.0010, 4159, -1016.3500 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_apartments_planter_02.rmdl", < -20968, 7800.0020, 41938.0200 >, < 0, 89.9998, 0 >, true, 50000, -1, 1.19 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17280, 9153.2490, 41923.5000 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3843.4000, 1038, -1222.5000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_train_station_railing_02.rmdl", < 4160.0100, 1280.6600, -704.7530 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3701.0010, 4159, -507.0496 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_barrier_concrete_128_01.rmdl", < 3263.1100, 7232, -1152.4500 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6988.1000, 1153, -802.2000 >, < 0, 90, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/highrise_square_block_02.rmdl", < -6282.5000, 8833.6000, 42193.9600 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6990.0010, 1046.5000, -802.2000 >, < 0, 0, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 10515.0400, 9704.0030, -4178 >, < 0, -179.9997, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/colony/ventilation_unit_01_black.rmdl", < 5503.4600, 9151.1800, -704.1940 >, < 0, 0, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -8154.8000, 8567.1000, 42408.2000 >, < 0, -179.9999, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3356.2000, 6063, -1275.7500 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17280, 11089.8800, 41923.5000 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_train_station_railing_02.rmdl", < 4287.9500, 1023.0400, -704.2860 >, < 0, 0, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desrtlands_icicles_06.rmdl", < 3391.2500, 2463.0240, -1008.6380 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3267, 2086.3000, -1096 >, < 0, -179.9999, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6875.2970, 1265.3000, -802.2000 >, < 0, -180, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3860.9000, 1273.9990, -840.8000 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 5248.4780, 1152.9800, -704.1930 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 6657.2800, 1027.5000, -1088.4200 >, < 0, 0, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3860.9000, 1273.9990, -713.4000 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -6539.1000, 8790, 41901 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_train_track_magnetic_beam_01.rmdl", < 5399.9470, 9156.5980, -704.0570 >, < 0, 0, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4301, 1274.3980, -1095.5000 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_train_station_railing_02.rmdl", < 3391, 7679.9900, -704.0950 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 5631.5220, 1152.9800, -704.2010 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/signs/street_sign_arrow.rmdl", < -6559.8970, 9119, 41946.8000 >, < -45, -0.0001, 180 >, true, 50000, -1, 4.715525 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_apartments_planter_02.rmdl", < -20968, 7848, 41938.0200 >, < 0, 89.9998, 0 >, true, 50000, -1, 1.19 )
    MapEditor_CreateProp( $"mdl/desertlands/highrise_square_block_02.rmdl", < -8410.4830, 8661.2600, 42781.2900 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 10515.0400, 9704.0030, -3922.0020 >, < 0, -179.9997, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -21876, 7508.0120, 41940 >, < 90, 89.9998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4568.0010, 1160, -973.9999 >, < 0, 0.0002, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6085.0010, 1274.3990, -1095.5000 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 5888.0200, 960.9860, -1344.1700 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/lightpole_desertlands_city_01.rmdl", < 3391.7800, 7679.2800, -704.6540 >, < 0, 0, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4734.2990, 1038, -1349.6000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -2337.1000, 8790, 42281.6000 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/highrise_square_block_02.rmdl", < -6008.9830, 8833.6000, 42781.2900 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < -21118.5800, 7055.0850, 41951.8000 >, < 0, 0.0005, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -2796.7000, 2849.8000, 42128.7000 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3274.0010, 1583.4990, -1350.6000 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3356.2000, 6063, -1021.0500 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6988.1010, 1025, -1242 >, < 0, 90, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < -17280, 9900, 41953.8000 >, < 0, -179.9998, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desrtlands_icicles_06.rmdl", < 3327.1800, 2669.9540, -1008.6810 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -2796.7000, 2359.4000, 42338 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -21843.0100, 7009.0050, 41940 >, < 90, 179.9996, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3274, 1142.8000, -840.8000 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3507.8000, 2599, -577.6495 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_top.rmdl", < -2792.0250, 2161.8000, 42560.5000 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_support_beam_16x144_filler.rmdl", < 3391.6700, 7679.3800, -1216.7100 >, < 0, 0, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 5627.4000, 1038.4000, -712.9000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 7003.2980, 1265.3010, -1242 >, < 0, -180, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/lightpole_desertlands_city_01.rmdl", < 3791.5850, 8127.1900, -634.4521 >, < 0, 0, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3843.4000, 1038, -1349.6000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6518.3000, 1038, -967.6000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 3392.0600, 2687.0300, -832.2310 >, < 0, 0, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3507.8000, 2599, -959.7496 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3843.4000, 1038.4000, -840.3000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 4351.0150, 1152.9800, -704.2010 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/highrise_square_block_02.rmdl", < -6282.5000, 8833.6000, 42487.6300 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3401, 1038.4000, -712.9000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 5185, 1038.4000, -712.9000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -5753.2990, 8792.2000, 42408.2000 >, < 0, -179.9999, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 6396.5070, 1152.9800, -704.2010 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_small_02.rmdl", < 10852, 9850, -3788 >, < 90, 89.9998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < -2584.2000, 2922, 42261.6000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desrtlands_icicles_06.rmdl", < 3327.1800, 1263.9540, -1033.6810 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 6015.4920, 1152.9800, -704.1930 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/highrise_square_block_02.rmdl", < -8410.4830, 8488.9200, 42781.2900 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -17182, 3542, 41916.9000 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < -17280, 9248.7500, 41953.8000 >, < 0, -179.9998, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 3520.0600, 6527.0500, -960.2950 >, < 0, 0, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -2796.7000, 2359.4000, 42130.2000 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -17656.0100, 425.7562, 41915.9000 >, < -90, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3274.4010, 1583.5000, -841.3000 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -21054.5800, 7150.5830, 41923.5000 >, < 0, 0.0003, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_apartments_planter_02.rmdl", < -21820, 7058.0020, 41938.0200 >, < 0, 89.9998, 0 >, true, 50000, -1, 1.19 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -21733, 7007.0090, 41940 >, < 90, 89.9998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/wall_city_corner_concrete_64_01.rmdl", < 3136.4600, 6528.8600, -1216.2100 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_small_02.rmdl", < 10588, 9986.0010, -3788 >, < 90, 89.9998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4568.0010, 1160, -847.9999 >, < 0, 0.0002, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_small_02.rmdl", < 10588, 10258, -3788 >, < 90, 89.9998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3356.2000, 6063, -1403.2500 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_support_beam_16x144_vertical.rmdl", < 3520.9200, 2239.6600, -1024.2000 >, < 0, 90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3267, 2086.3000, -1223.5000 >, < 0, -179.9999, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 5194.1010, 1273.9990, -713.4000 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 5194.1010, 1274.3990, -968.1001 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3701.0010, 4159, -889.2496 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3018.9990, 4922, -1154.2500 >, < 0, 179.9997, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 7125.9990, 1265.3000, -802.2000 >, < 0, -180, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/wall_city_corner_concrete_64_01.rmdl", < 3648.4600, 6783.3900, -1216.6400 >, < 0, 0, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3273.5990, 1142.8000, -968.0999 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6085, 1274.4000, -968.0999 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_barrier_concrete_128_01.rmdl", < 3199.9100, 6913, -1151.9900 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3507.8000, 1498.6000, -841.3000 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 3391.9900, 3133, -692.0650 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 4864.5070, 1152.9800, -704.2010 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3018.9990, 4922, -1026.7500 >, < 0, 179.9997, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3843.4000, 1038.4000, -712.9000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/highrise_square_block_02.rmdl", < -8684, 8661.2600, 42193.9600 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < -21478.9000, 7269.5020, 42171.9300 >, < 0, 0.0007, 89.9998 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_barrier_concrete_128_01.rmdl", < 3199.8900, 7168.8200, -1152.5700 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 10515.0400, 10144, -4050.0010 >, < 0, -179.9997, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/levels_terrain/mp_rr_canyonlands/clands_roof_bars_01_fglass_blue.rmdl", < -23564, 7971.6550, 42169.6900 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/highrise_square_block_02.rmdl", < -6008.9830, 8661.2600, 42781.2900 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_support_beam_16x144_vertical.rmdl", < 6849.9800, 1027.8490, -1472.6000 >, < 0, 90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -17424, 169.7680, 41916 >, < -90, -89.9998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 4672, 9152, -832 >, < 0, 0, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 10948.9600, 9704, -4306 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 5503.5220, 1152.9800, -704.2010 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desrtlands_icicles_06.rmdl", < 5036.0460, 1086.9810, -1292.6810 >, < 0, -0.0002, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 6652.5070, 1152.9800, -704.2010 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 10948.9600, 10144, -4306 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3274, 1583.5000, -1096 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3401, 1038.4000, -840.3000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/signs/street_sign_arrow.rmdl", < -20942, 7701.9990, 42026 >, < -0.0003, -90.0002, 180 >, true, 50000, -1, 3.15 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 6143.4920, 1152.9800, -704.1930 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4747, 1274, -713.4000 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/signs/street_sign_arrow.rmdl", < -17166, 4237, 42028 >, < -90, 179.9997, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/levels_terrain/mp_rr_canyonlands/clands_roof_bars_01_fglass_blue.rmdl", < -20926, 7469.6550, 42169.6900 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/highrise_square_block_02.rmdl", < -8957.5170, 8661.2600, 42193.9600 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6527.4010, 1274.0010, -840.8000 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 10948.9600, 10144, -4178 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_train_station_railing_02.rmdl", < 3519.8500, 1280.6400, -704.7540 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6527.4000, 1274.4000, -1223 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 4100.9960, 1220, -1072.2000 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desrtlands_icicles_06.rmdl", < 3455.2000, 4416.5800, -788.2633 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -17144, 3858.2000, 41916.9000 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 10515.0400, 10144, -3922.0020 >, < 0, -179.9997, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 10515.0400, 9704.0030, -4050.0010 >, < 0, -179.9997, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/signs/street_sign_arrow.rmdl", < -17110.3400, 3915, 42018 >, < 0, 179.9997, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3274, 1583.5000, -1223.5000 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -20927, 7898.9730, 41940 >, < 90, -90.0005, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3018.9990, 4922, -644.6495 >, < 0, 179.9997, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 10731.0400, 9487.9990, -4306 >, < 0, -89.9998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -17182, 4810, 41916.9000 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 5140, 9152, -704 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_barrier_concrete_128_01.rmdl", < 3520.7900, 7360.0400, -1152.6100 >, < 0, 90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/highrise_square_block_02.rmdl", < -8684, 8661.2600, 41900.3000 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -8940.6000, 8790, 41901 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_small_02.rmdl", < 10852, 9714, -3788 >, < 90, 89.9998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_small_02.rmdl", < 10588, 9850, -3788 >, < 90, 89.9998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < -2640.2000, 2230.8000, 42203.7000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6988.1000, 1152.9990, -1242 >, < 0, 90, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.0390, 3071.9500, -759.5032 >, < 0, -90, 179.9997 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -17200, 5402, 41915.6000 >, < 0, -89.9998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/levels_terrain/mp_rr_canyonlands/clands_roof_bars_01_fglass_blue.rmdl", < -21150.3500, 7640, 42169.6900 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17280, 8384, 41923.5000 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/wall_city_barred_concrete_192_01.rmdl", < 3648.9700, 6656.0200, -1216.2300 >, < 0, 90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3394.4990, 2086.3000, -705.9991 >, < -90, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4734.2990, 1038.4000, -840.3000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/signs/street_sign_arrow.rmdl", < -17192, 4237, 42018 >, < -0.0003, 0.0003, 180 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_train_station_railing_02.rmdl", < 3775.9900, 1023.0200, -704.1840 >, < 0, 0, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/domestic/ac_unit_dirty_32x64_01_a.rmdl", < -23426.5600, 7315.4700, 41962 >, < 0.0002, 90, 89.9998 >, true, 50000, -1, 1.33 )
    MapEditor_CreateProp( $"mdl/desertlands/desrtlands_icicles_06.rmdl", < 3455.2200, 2670.0440, -1008.7460 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6988.1000, 1024.9990, -802.2000 >, < 0, 90, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 5185, 1038, -1222.5000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_apartments_planter_02.rmdl", < -21820, 7106, 41938.0200 >, < 0, 89.9998, 0 >, true, 50000, -1, 1.19 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_top.rmdl", < -2792.0250, 3047, 42353.5000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 5194.1010, 1273.9990, -840.8000 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/highrise_square_block_02.rmdl", < -6008.9830, 8661.2600, 42193.9600 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6527.4000, 1274.4000, -1095.5000 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/highrise_square_block_02.rmdl", < -8410.4830, 8833.6000, 42781.2900 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/signs/street_sign_arrow.rmdl", < -17166, 3601, 42028 >, < -90, 179.9997, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -17400, 5098.9000, 41916.9000 >, < 0, 89.9998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 3392, 2560, -640 >, < 0, 90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/signs/street_sign_arrow.rmdl", < -17192, 3601, 42018 >, < -0.0003, 0.0003, 180 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/signs/street_sign_arrow.rmdl", < -2338.4000, 9119.2960, 42164.8000 >, < -30, -90.0001, -90 >, true, 50000, -1, 4.715525 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3843.4000, 1038, -967.6000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < -21616, 7509.9340, 42171.9300 >, < 0, -89.9998, 89.9998 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 5376.4780, 1152.9800, -704.1930 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3860.9000, 1274.3980, -1350.1000 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -8837.3000, 8923.3000, 41893.2000 >, < 0, 0.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -9069.7000, 8899.7000, 41893.4000 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 10515.0400, 9704.0030, -4306 >, < 0, -179.9997, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -21159.0200, 7023.0020, 41940 >, < 90, 179.9996, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < -21832.9200, 7201.9970, 41951.8000 >, < 0, -89.9993, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 4862.9840, 1152.9800, -704.1930 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < -20959.0800, 7704, 41951.8000 >, < 0, 90.0003, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 3520, 6656, -1216 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -17144, 4494, 41916.9000 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/levels_terrain/mp_rr_canyonlands/clands_roof_bars_01_fglass_blue.rmdl", < -23564, 7523.6550, 42169.6900 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < -2943.9000, 2922, 42112.3000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desrtlands_icicles_06.rmdl", < 3327.3500, 5248.5800, -907.0615 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < -2943.9000, 2922, 41963.4000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < -2584.2000, 2230.8000, 41904.9000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3701.0010, 4159, -761.7496 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 4927.7000, 1152.4000, -1280 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/levels_terrain/mp_rr_canyonlands/clands_roof_bars_01_fglass_blue.rmdl", < -21620, 7895.6550, 42169.6900 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -21865, 7243.0150, 41940 >, < 90, 89.9998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desrtlands_icicles_06.rmdl", < 3455.2200, 1264.0440, -1033.7460 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17552, 298.2555, 41923.5000 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_small_02.rmdl", < 3394.6000, 1152.7000, -722 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -21606.9200, 7137.9990, 41923.2500 >, < 0, -89.9995, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 5395, 9152, -704 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 7118.0010, 1046.5000, -1242 >, < 0, 0, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4291.8990, 1038, -1349.6000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 3136, 7040, -1152 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -17224, 5380.1000, 41915.6000 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4807.9990, 1160, -829.9999 >, < 0.0003, 179.9998, 180 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_train_track_sign_01.rmdl", < 4352.0500, 8769, -640.0750 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/highrise_square_block_02.rmdl", < -6282.5000, 8833.6000, 42781.2900 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 5640.1000, 1274.3990, -1350.1000 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -17424, 622.0114, 41916 >, < -90, -89.9998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_support_beam_16x144_filler.rmdl", < 3391.5300, 7679.1200, -1087.9000 >, < 0, 0, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/signs/street_sign_arrow.rmdl", < -17110.3400, 4551, 42018 >, < 0, 179.9997, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 3386.8000, 2244, -959.2120 >, < 0, 0, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desrtlands_icicles_06.rmdl", < 3455.2200, 2463.0440, -1008.7460 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 5183.8500, 9088.6500, -960.7480 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3401, 1038, -1222.5000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 5194.1010, 1274.3980, -1223 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6867.3000, 1046.5000, -1242 >, < 0, 0, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 7003.2980, 1265.3000, -802.2000 >, < 0, -180, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -21737.4200, 7138, 41923.5000 >, < 0, -89.9995, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desrtlands_icicles_06.rmdl", < 3391.1800, 4416.5400, -788.2493 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_building_ice_02.rmdl", < -23335.6600, 7952.0060, 41981.3200 >, < 1.1701, 9.8988, -4.3717 >, true, 50000, -1, 0.09 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3394.4990, 2599, -569.7487 >, < -90, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/signs/street_sign_arrow.rmdl", < -5810, 9087.7000, 42470.6000 >, < -28.7601, -58.7473, 175.6741 >, true, 50000, -1, 4.715525 )
    MapEditor_CreateProp( $"mdl/desertlands/highrise_square_block_02.rmdl", < -8684, 8661.2600, 42781.2900 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6072.3000, 1038, -1349.6000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_barrier_concrete_128_01.rmdl", < 3071.5600, 7168.7700, -1152.4600 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/firstgen/firstgen_pipe_256_darkcloth_01.rmdl", < 5055.7600, 9215.0300, -832.0870 >, < 0, 0, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < -23516.8400, 7331.9670, 41951.8000 >, < 0, 0.0005, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6085.0010, 1274.3990, -1350.1000 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3640.0010, 5827, -773.0496 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/highrise_square_block_02.rmdl", < -8957.5170, 8833.6000, 42487.6300 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/signs/street_sign_arrow.rmdl", < -17192, 4865, 42018 >, < -0.0003, 0.0003, 180 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/highrise_square_block_02.rmdl", < -6282.5000, 8661.2600, 42781.2900 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17280, 11756, 41923.5000 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < -21684, 7864, 41951.8000 >, < 0, -179.9998, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3508.2000, 1498.6000, -1096 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 10948.9600, 9704, -4178 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 10948.9600, 10144, -3922.0020 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6085.0010, 1274, -840.7999 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3386.0490, 2431.4500, -879.4496 >, < 90, 89.9998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/highrise_square_block_02.rmdl", < -6556.0170, 8833.6000, 42487.6300 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < -21478.9000, 7032.5090, 42171.9300 >, < 0, 0.0007, 89.9998 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_barrier_concrete_128_01.rmdl", < 3712.1200, 6912.9900, -1152.0400 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6072.3000, 1038, -1095 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6518.3000, 1038.4000, -712.9000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/signs/street_sign_arrow.rmdl", < -17137.0300, 3915, 42028 >, < -90, 179.9997, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 3392.9200, 7808.2200, -1216.3100 >, < 0, 90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17280, 2523.9990, 41923.5000 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_train_station_railing_02.rmdl", < 3648, 1280.6400, -704.7700 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < -21185.5000, 7407.0980, 42171.9300 >, < 0, 90.0005, 89.9998 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -23692, 7638, 41923.2500 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desrtlands_icicles_06.rmdl", < 3391.2500, 1264.0240, -1033.6380 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/signs/street_sign_arrow.rmdl", < -23520, 7917.9980, 41962 >, < -4.5580, -74.8950, 142.0979 >, true, 50000, -1, 2.46 )
    MapEditor_CreateProp( $"mdl/signs/street_sign_arrow.rmdl", < -17137.0300, 4551, 42028 >, < -90, 179.9997, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_support_beam_16x144_vertical.rmdl", < 3264.8100, 2239.8400, -1024.5600 >, < 0, 90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3860.9000, 1274.3980, -1223 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < -2640.2000, 2922, 41815.3000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/plant_desert_yucca_01.rmdl", < -21826.4500, 7847.5600, 41972.8000 >, < 0, 0, 0 >, true, 50000, -1, 0.45 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -21314.9900, 7896.9990, 41940 >, < 90, -0.0007, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_support_beam_16x144_filler.rmdl", < 3135.3900, 6528.3300, -959.2830 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/levels_terrain/mp_rr_canyonlands/clands_roof_bars_01_fglass_blue.rmdl", < -21416.3500, 7008, 42169.6900 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.0390, 2943.7300, -759.8892 >, < 0, -90, 179.9997 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/highrise_square_block_02.rmdl", < -6282.5000, 8661.2600, 42487.6300 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_small_02.rmdl", < 10588, 9578.0010, -3788 >, < 90, 89.9998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desrtlands_icicles_06.rmdl", < 3391.2500, 3648.5600, -715.6378 >, < 0, -90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < -2584.2000, 2230.8000, 42203.7000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -17144, 5122.8000, 41916.9000 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/highrise_square_block_02.rmdl", < -6008.9830, 8833.6000, 42487.6300 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6867.3000, 1046.5000, -802.2000 >, < 0, 0, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -17152.0100, 425.7562, 41916 >, < -90, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/levels_terrain/mp_rr_canyonlands/clands_roof_bars_01_fglass_blue.rmdl", < -23324, 7971.6550, 42169.6900 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -17656.0100, 644, 41916 >, < -90, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/signs/desertlands_city_newdawn_sign_01.rmdl", < 3392.8300, 7168.5600, -1151.9600 >, < 0, 90, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -8283.8000, 8674.5000, 42400.9000 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3507.8000, 2086.3000, -713.8999 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/signs/street_sign_arrow.rmdl", < -17432, 772.4993, 41992 >, < 0, -135.0004, 0 >, true, 50000, -1, 2.98 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 7253.9990, 1265.3010, -1242 >, < 0, -180, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3508.2000, 1498.6000, -968.5999 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17552, 514.4995, 41923.7000 >, < 0, -180, 0 >, true, 8000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4568.0010, 1160, -1098 >, < 0, 0.0002, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4291.8990, 1038, -1095 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < -2943.9000, 2922, 42261.6000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -6665.9000, 8652.2000, 41893.4000 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < -2887.9000, 2230.8000, 42203.7000 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/highrise_square_block_02.rmdl", < -6282.5000, 8661.2600, 42193.9600 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/levels_terrain/mp_rr_canyonlands/clands_roof_bars_01_fglass_blue.rmdl", < -21640.3500, 7008, 42169.6900 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -5648.8000, 8923.3000, 42400.4000 >, < 0, 0.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/highrise_square_block_02.rmdl", < -8410.4830, 8661.2600, 42193.9600 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4734.2990, 1038, -1222.5000 >, < 0, -90, 0 >, true, 50000, -1, 1 )

    //PlayerClips 
    array<entity> playerClips 
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 9638.9990, -148, 42898.8000 >, < 0, 90, 0.0005 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 9638.9990, -738, 42898.8000 >, < 0, 90, 0.0005 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 9346, -728, 42545 >, < 90, 179.9999, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 9346.0030, -146.9990, 42545 >, < 90, 179.9999, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 9935, -147, 42545 >, < 90, 0.0003, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 9935, -728, 42545 >, < 90, 0.0003, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 9639, 106, 42545 >, < 90, -90.0002, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 9639, -148, 42259.5100 >, < 0, 90, -179.9998 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 9639, -1025.9990, 42545 >, < 90, -90.0002, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 9639, -738, 42259.5100 >, < 0, 90, -179.9998 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 3922.6450, 2909, 43746.9900 >, < 0, 90, -179.9998 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 3345.3230, 2909, 43747 >, < 0, 90, -179.9998 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 2768.0010, 2909, 43747 >, < 0, 90, -179.9998 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 3922.6450, 3486.3230, 43746.9900 >, < 0, 90, -179.9998 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 3345.3230, 3486.3230, 43747 >, < 0, 90, -179.9998 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 2768.0010, 3486.3230, 43747 >, < 0, 90, -179.9998 >, true, 50000, -1, 1.000001 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 3345.3230, 4063.6470, 43747 >, < 0, 90, -179.9998 >, true, 50000, -1, 1.000001 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 3922.6450, 4063.6470, 43746.9900 >, < 0, 90, -179.9998 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 2768.0010, 4063.6470, 43747 >, < 0, 90, -179.9998 >, true, 50000, -1, 1.000001 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 3345.3230, 4640.9700, 43747 >, < 0, 90, -179.9998 >, true, 50000, -1, 1.000001 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 2768.0010, 4640.9700, 43747 >, < 0, 90, -179.9998 >, true, 50000, -1, 1.000001 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 3922.6450, 4640.9700, 43746.9900 >, < 0, 90, -179.9998 >, true, 50000, -1, 1.000001 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 3345.3230, 5218.2930, 43747 >, < 0, 90, -179.9998 >, true, 50000, -1, 1.000001 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 3922.6450, 5218.2930, 43746.9900 >, < 0, 90, -179.9998 >, true, 50000, -1, 1.000001 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 2768.0010, 5218.2930, 43747 >, < 0, 90, -179.9998 >, true, 50000, -1, 1.000001 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 3345.3230, 5795.6170, 43747 >, < 0, 90, -179.9998 >, true, 50000, -1, 1.000001 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 2768.0010, 5795.6170, 43747 >, < 0, 90, -179.9998 >, true, 50000, -1, 1.000002 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 3922.6450, 5795.6170, 43746.9900 >, < 0, 90, -179.9998 >, true, 50000, -1, 1.000001 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 2768.0010, 6372.9410, 43747 >, < 0, 90, -179.9998 >, true, 50000, -1, 1.000002 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 3345.3230, 6372.9410, 43747 >, < 0, 90, -179.9998 >, true, 50000, -1, 1.000002 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 3922.6450, 6372.9410, 43746.9900 >, < 0, 90, -179.9998 >, true, 50000, -1, 1.000001 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 3345.3230, 6950.2650, 43747 >, < 0, 90, -179.9998 >, true, 50000, -1, 1.000002 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 2768.0010, 6950.2650, 43747 >, < 0, 90, -179.9998 >, true, 50000, -1, 1.000002 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 3922.6450, 6950.2650, 43746.9900 >, < 0, 90, -179.9998 >, true, 50000, -1, 1.000002 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 3345.3230, 7527.5890, 43747 >, < 0, 90, -179.9998 >, true, 50000, -1, 1.000002 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 2768.0010, 7527.5890, 43747 >, < 0, 90, -179.9998 >, true, 50000, -1, 1.000002 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 3922.6450, 7527.5890, 43746.9900 >, < 0, 90, -179.9998 >, true, 50000, -1, 1.000002 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 3922.6450, 7527.5890, 42259.5000 >, < 0, 90, -179.9998 >, true, 50000, -1, 1.000002 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 2768.0010, 7527.5890, 42259.5100 >, < 0, 90, -179.9998 >, true, 50000, -1, 1.000002 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 3345.3230, 7527.5890, 42259.5000 >, < 0, 90, -179.9998 >, true, 50000, -1, 1.000002 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 3922.6450, 6950.2650, 42259.5000 >, < 0, 90, -179.9998 >, true, 50000, -1, 1.000002 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 2768.0010, 6950.2650, 42259.5100 >, < 0, 90, -179.9998 >, true, 50000, -1, 1.000002 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 3345.3230, 6950.2650, 42259.5000 >, < 0, 90, -179.9998 >, true, 50000, -1, 1.000002 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 3922.6450, 6372.9410, 42259.5000 >, < 0, 90, -179.9998 >, true, 50000, -1, 1.000001 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 3345.3230, 6372.9410, 42259.5000 >, < 0, 90, -179.9998 >, true, 50000, -1, 1.000002 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 2768.0010, 6372.9410, 42259.5100 >, < 0, 90, -179.9998 >, true, 50000, -1, 1.000002 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 3922.6450, 5795.6170, 42259.5000 >, < 0, 90, -179.9998 >, true, 50000, -1, 1.000001 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 2768.0010, 5795.6170, 42259.5100 >, < 0, 90, -179.9998 >, true, 50000, -1, 1.000002 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 3345.3230, 5795.6170, 42259.5000 >, < 0, 90, -179.9998 >, true, 50000, -1, 1.000001 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 2768.0010, 5218.2930, 42259.5100 >, < 0, 90, -179.9998 >, true, 50000, -1, 1.000001 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 3922.6450, 5218.2930, 42259.5000 >, < 0, 90, -179.9998 >, true, 50000, -1, 1.000001 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 3345.3230, 5218.2930, 42259.5000 >, < 0, 90, -179.9998 >, true, 50000, -1, 1.000001 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 3922.6450, 4640.9700, 42259.5000 >, < 0, 90, -179.9998 >, true, 50000, -1, 1.000001 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 2768.0010, 4640.9700, 42259.5100 >, < 0, 90, -179.9998 >, true, 50000, -1, 1.000001 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 3345.3230, 4640.9700, 42259.5000 >, < 0, 90, -179.9998 >, true, 50000, -1, 1.000001 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 2768.0010, 4063.6470, 42259.5100 >, < 0, 90, -179.9998 >, true, 50000, -1, 1.000001 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 3922.6450, 4063.6470, 42259.5000 >, < 0, 90, -179.9998 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 3345.3230, 4063.6470, 42259.5000 >, < 0, 90, -179.9998 >, true, 50000, -1, 1.000001 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 2768.0010, 3486.3230, 42259.5100 >, < 0, 90, -179.9998 >, true, 50000, -1, 1.000001 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 3345.3230, 3486.3230, 42259.5000 >, < 0, 90, -179.9998 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 3922.6450, 3486.3230, 42259.5000 >, < 0, 90, -179.9998 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 2768.0010, 2909, 42259.5100 >, < 0, 90, -179.9998 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 3345.3230, 2909, 42259.5000 >, < 0, 90, -179.9998 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 3922.6450, 2909, 42259.5000 >, < 0, 90, -179.9998 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 3922.6450, 2620.9990, 42226 >, < 90, -90.0002, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 3345.3230, 2621, 42226 >, < 90, -90.0002, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 2768.0010, 2621.0010, 42226 >, < 90, -90.0002, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 3922.6450, 2620.9970, 42803.3200 >, < 90, -90.0002, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 3345.3230, 2621, 42803.3200 >, < 90, -90.0002, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 2768.0010, 2621.0010, 42803.3200 >, < 90, -90.0002, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 3345.3230, 2621, 43380.6500 >, < 90, -90.0002, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 2768.0010, 2621.0010, 43380.6500 >, < 90, -90.0002, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 3922.6450, 2620.9970, 43380.6500 >, < 90, -90.0002, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 2768, 7486.0020, 43380.6500 >, < 90, 90.0001, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 3922.6440, 7486.0030, 43380.6500 >, < 90, 90.0001, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 3345.3210, 7486.0010, 43380.6500 >, < 90, 90.0001, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 3922.6440, 7486.0030, 42803.3200 >, < 90, 90.0001, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 3345.3210, 7486.0010, 42803.3200 >, < 90, 90.0001, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 2768, 7486.0020, 42803.3200 >, < 90, 90.0001, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 3922.6440, 7486.0030, 42226 >, < 90, 90.0001, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 3345.3210, 7486.0010, 42226 >, < 90, 90.0001, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 2768, 7486, 42226 >, < 90, 90.0001, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 4242.0020, 4171, 43380.6500 >, < 90, 0.0003, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 4242.0020, 5382, 43380.6500 >, < 90, 0.0003, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 4242.0020, 4772, 43380.6500 >, < 90, 0.0003, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 4242.0020, 6581, 43380.6500 >, < 90, 0.0003, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 2470.0090, 5969.9990, 43380.6500 >, < 90, 179.9999, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 2469.9980, 3559.9990, 43380.6500 >, < 90, 179.9999, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 2469.9960, 2958.9990, 43380.6500 >, < 90, 179.9999, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 2470.0060, 5369, 43380.6500 >, < 90, 179.9999, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 4242.0020, 2959, 43380.6500 >, < 90, 0.0003, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 4242.0020, 3560, 43380.6500 >, < 90, 0.0003, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 2470.0030, 4758.9990, 43380.6500 >, < 90, 179.9999, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 2470.0010, 4157.9990, 43380.6500 >, < 90, 179.9999, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 2470.0140, 7182, 43380.6500 >, < 90, 179.9999, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 2470.0130, 6580.9990, 43380.6500 >, < 90, 179.9999, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 4242.0020, 5983, 43380.6500 >, < 90, 0.0003, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 4242.0020, 7182, 43380.6500 >, < 90, 0.0003, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 4242.0020, 4171, 42803.3200 >, < 90, 0.0003, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 4242.0020, 5382, 42803.3200 >, < 90, 0.0003, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 4242.0020, 4772, 42803.3200 >, < 90, 0.0003, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 4242.0020, 6581, 42803.3200 >, < 90, 0.0003, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 2470.0090, 5969.9990, 42803.3200 >, < 90, 179.9999, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 2469.9980, 3559.9990, 42803.3200 >, < 90, 179.9999, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 2469.9960, 2958.9990, 42803.3200 >, < 90, 179.9999, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 2470.0060, 5369, 42803.3200 >, < 90, 179.9999, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 2470.0140, 7182, 42803.3200 >, < 90, 179.9999, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 2470.0130, 6580.9990, 42803.3200 >, < 90, 179.9999, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 4242.0020, 5983, 42803.3200 >, < 90, 0.0003, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 4242.0020, 7182, 42803.3200 >, < 90, 0.0003, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 4242.0020, 3560, 42803.3200 >, < 90, 0.0003, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 4242.0020, 2959, 42803.3200 >, < 90, 0.0003, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 2470.0010, 4157.9990, 42803.3200 >, < 90, 179.9999, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 2470.0030, 4758.9990, 42803.3200 >, < 90, 179.9999, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 2470, 3559.9990, 42226 >, < 90, 179.9999, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 2469.9980, 2958.9990, 42226 >, < 90, 179.9999, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 2470.0030, 4157.9990, 42226 >, < 90, 179.9999, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 2470.0050, 4758.9990, 42226 >, < 90, 179.9999, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 2470.0110, 5969.9990, 42226 >, < 90, 179.9999, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 2470.0150, 6580.9990, 42226 >, < 90, 179.9999, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 2470.0080, 5369, 42226 >, < 90, 179.9999, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 2470.0160, 7182, 42226 >, < 90, 179.9999, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 4242, 7182, 42226 >, < 90, 0.0003, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 4242, 6581, 42226 >, < 90, 0.0003, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 4242, 5382, 42226 >, < 90, 0.0003, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 4242, 5983, 42226 >, < 90, 0.0003, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 4242, 4772, 42226 >, < 90, 0.0003, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 4242, 4171, 42226 >, < 90, 0.0003, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 4242, 3560, 42226 >, < 90, 0.0003, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 4242, 2959, 42226 >, < 90, 0.0003, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -6828, 8919.2990, 42068 >, < 0.0001, -90, 90 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -23734, 8319, 42157 >, < 90, 89.9998, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17408.2000, 298.2555, 42056 >, < 90, -180, 0 >, true, 8000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17498.5000, 5124, 42157 >, < 90, -0.0001, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -21076.9900, 7757.0020, 42549 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17233, 7839, 42549 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17522, 10913, 41858 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -5954, 8921.2990, 43074 >, < 0, 0, -179.9999 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -21928, 7071.0030, 42157 >, < 90, 179.9999, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17522, 11787, 41858 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17023, 11718, 42157 >, < 90, -0.0001, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -8927.5000, 8441.7010, 42068 >, < 0, 0.0001, 90.0001 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17154, 2226, 42157 >, < 90, 89.9998, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17233, 11787, 41858 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17056, 3837, 41858 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17056, 2610, 41858 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17056, 3837, 42549 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17280, 685, 41824 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -8355.5000, 8921.2990, 43074 >, < 0, 0, -179.9999 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -9229.5000, 8919.2990, 42684 >, < 0.0001, -90, 90 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17056, 3212, 41858 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -23101, 7384.9970, 42157 >, < 90, 179.9999, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -2482.5000, 1685.5010, 42226 >, < 0, 0, 90.0002 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17522, 9066, 41858 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17600, 10844, 42157 >, < 90, -0.0001, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17023, 10844, 42157 >, < 90, -0.0001, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -21103, 7002, 42549 >, < 0.0002, 180, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17345, 2610, 41858 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17233, 11537, 41858 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -2175.4990, 1991.5000, 43002 >, < 90, 0.0003, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17407.8000, 514.4995, 42562 >, < 90, -180, 0 >, true, 8000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17569, 685, 41824 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -3404.4990, 1991.5000, 43002 >, < 90, 179.9999, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -21620, 6753.9980, 42157 >, < 90, -89.9999, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17600, 10210, 42157 >, < 90, -0.0001, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -16846, 4981, 42157 >, < 90, -0.0001, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -2175.4990, 1991.5000, 42226 >, < 90, 0.0003, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -3085, 2023, 43377 >, < 0.0002, 179.9999, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -23734.0100, 7316, 42549 >, < 0.0002, 180, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17331, 12035, 42157 >, < 90, 89.9998, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17522, 8441, 41858 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -23445.0100, 7315.9980, 42549 >, < 0.0002, 180, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17522, 7839, 41858 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -24052, 8002, 42157 >, < 90, -0.0001, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17056, 4439, 42549 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -2032, 8940.0010, 42068 >, < -0.0001, 90.0001, 90 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17423, 3763, 42157 >, < 90, -0.0001, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17233, 9066, 42549 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17408.2000, 298.2555, 42308 >, < 90, -180, 0 >, true, 8000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -23517, 8319, 42157 >, < 90, 89.9998, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17345, 4439, 42549 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -21717.9900, 8005.0020, 42157 >, < 90, 89.9998, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17345, 3837, 42549 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -5907.9000, 8921.2990, 41831 >, < 0, 0, -179.9999 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17522, 9668, 42549 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17522, 10279, 42549 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -8036.5000, 8840, 42684 >, < -0.0001, 90.0001, 90 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17345, 5050, 41858 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17345, 3212, 41858 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -5954, 9229.2990, 42684 >, < 0, -180, 89.9999 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17233, 10279, 41858 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -2467, 3254, 43377 >, < 0.0002, 179.9999, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17345, 5050, 41858 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17569, 685, 42563 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -2032, 8940.0010, 42684 >, < -0.0001, 90.0001, 90 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -2338, 9250, 42068 >, < 0, -180, 89.9999 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17569, 378, 42563 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -21691.9900, 7757.0020, 41858 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17233, 10913, 41858 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17056, 3212, 41858 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17056, 2610, 41858 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17522, 10279, 41858 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -3404.4990, 2606, 43002 >, < 90, 179.9999, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -2338, 9250, 42684 >, < 0, -180, 89.9999 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17280, 378, 41824 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17056, 3212, 42549 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -3212, 2526, 41923.5000 >, < 0, 0, -179.9999 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17345, 3837, 41858 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17522, 10913, 42549 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -8310.5000, 8440.5980, 42684 >, < 0, 0.0001, 90.0001 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17501, 951.0001, 42157 >, < 90, 89.9998, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -5909, 8668.9980, 42684 >, < 0, 0.0001, 90.0001 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17600, 11718, 42157 >, < 90, -0.0001, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -2640, 8940, 42684 >, < 0.0001, -90, 90 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17522, 9066, 42549 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -5954, 9229.2990, 42068 >, < 0, -180, 89.9999 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -21717.9900, 7002.0020, 41858 >, < 0.0002, 180, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17522, 11787, 42549 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17522, 11537, 42549 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17056, 5050, 41858 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -23209, 8002, 42157 >, < 90, -0.0001, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17233, 10913, 42549 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -8309.4000, 8572, 41831 >, < 0, 0, -179.9999 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -23636, 7067.9960, 42157 >, < 90, -89.9999, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -16846, 3763, 42157 >, < 90, -0.0001, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17524.1200, 156.1980, 42056 >, < 90, 90.0002, 0 >, true, 8000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -3404.4990, 1991.5000, 42226 >, < 90, 179.9999, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17524.1200, 156.1980, 42308 >, < 90, 90.0002, 0 >, true, 8000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -8927.5000, 9229.2990, 42684 >, < 0, -180, 89.9999 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -2338, 8665, 42684 >, < 0, 0, 90.0001 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -21174.9900, 8005.0020, 42157 >, < 90, 89.9998, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17056, 2610, 42549 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17408.2000, 298.2555, 42562 >, < 90, -180, 0 >, true, 8000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -2467, 2642, 43377 >, < 0.0002, 179.9999, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -23944, 7385, 42157 >, < 90, 179.9999, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -9229.5000, 8919.2990, 42068 >, < 0.0001, -90, 90 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -8927.5000, 8921.2990, 41831 >, < 0, 0, -179.9999 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -8036.5000, 8770, 42684 >, < -0.0001, 90.0001, 90 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -2467, 2023, 43377 >, < 0.0002, 179.9999, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -3099.5000, 1685.5010, 42226 >, < 0, 0, 90.0002 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17023, 11468, 42157 >, < 90, -0.0001, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17501, 43, 42157 >, < 90, -89.9999, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17233, 10913, 41858 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17345, 3837, 41858 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -2482.5000, 1685.5010, 43002 >, < 0, 0, 90.0002 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17233, 11787, 42549 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17600, 7791, 42157 >, < 90, -0.0001, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -16846, 5124, 42157 >, < 90, -0.0001, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17345, 3212, 42549 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17056, 3837, 41858 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17023, 8992, 42157 >, < 90, -0.0001, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17345, 2610, 42549 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -6526, 9229.2990, 42684 >, < 0, -180, 89.9999 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17522, 9668, 41858 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -16846, 3170, 42157 >, < 90, -0.0001, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -8927.5000, 9229.2990, 42068 >, < 0, -180, 89.9999 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17345, 2610, 41858 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -20866.9900, 7688.0020, 42157 >, < 90, -0.0001, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -2640, 8940, 42068 >, < 0.0001, -90, 90 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -6828, 8919.2990, 42684 >, < 0.0001, -90, 90 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17423, 4371, 42157 >, < 90, -0.0001, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -2482.5000, 3524.4970, 42226 >, < 0, 179.9997, 90.0003 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -3212, 3136, 41923.5000 >, < 0, 0, -179.9999 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -22035.9900, 7688.0020, 42157 >, < 90, -0.0001, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17023, 8399, 42157 >, < 90, -0.0001, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17154, 5398, 42157 >, < 90, 89.9998, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17600, 8399, 42157 >, < 90, -0.0001, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -23708, 8071, 42549 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -2175.5010, 2604.5010, 42226 >, < 90, 0.0003, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17233, 11537, 42549 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17407.8000, 514.4995, 42308 >, < 90, -180, 0 >, true, 8000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17233, 10279, 42549 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17005, 378, 42157 >, < 90, -0.0001, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17233, 10913, 42549 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17280, 378, 42563 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17233, 7839, 41858 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -23708, 8071, 41858 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17569, 378, 41824 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17056, 4439, 41858 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -3212, 1908, 41923.5000 >, < 0, 0, -179.9999 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17233, 9668, 42549 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -6526, 8921.2990, 41831 >, < 0, 0, -179.9999 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -5635, 8840, 42684 >, < -0.0001, 90.0001, 90 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -8355.5000, 9229.2990, 42068 >, < 0, -180, 89.9999 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -2338, 8942, 41831 >, < 0, 0, -179.9999 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -2175.5010, 2604.5010, 43002 >, < 90, 0.0003, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17345, 5050, 42549 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -8355.5000, 8798, 43074 >, < 0, 0, -179.9999 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -8036.5000, 8840, 42068 >, < -0.0001, 90.0001, 90 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -8927.5000, 8921.2990, 43074 >, < 0, 0, -179.9999 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17345, 3212, 41858 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17600, 10844, 42157 >, < 90, -0.0001, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -8927.5000, 8798, 43074 >, < 0, 0, -179.9999 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17233, 8441, 41858 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -21077, 6754.0030, 42157 >, < 90, -89.9999, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -3404.4990, 3219, 42226 >, < 90, 179.9999, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -3099.5000, 3524.4990, 43002 >, < 0, 179.9997, 90.0003 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17522, 10913, 41858 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17233, 8441, 42549 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -8036.5000, 8770, 42068 >, < -0.0001, 90.0001, 90 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17233, 9066, 41858 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -6526, 8669, 42068 >, < 0, 0.0001, 90.0001 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17423, 3170, 42157 >, < 90, -0.0001, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17307.8800, 155.8020, 42562 >, < 90, 90.0002, 0 >, true, 8000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17345, 5050, 42549 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -3085, 2642, 43377 >, < 0.0002, 179.9999, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -2175.5040, 3219, 42226 >, < 90, 0.0003, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17056, 5050, 42549 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17522, 11537, 41858 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -8927.5000, 8441.6990, 42684 >, < 0, 0.0001, 90.0001 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -8355.5000, 9229.2990, 42684 >, < 0, -180, 89.9999 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -21076.9900, 7757.0020, 41858 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -2516, 3576, 41923.5000 >, < 0, 0, -179.9999 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17233, 9668, 41858 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17345, 4439, 42549 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17345, 4439, 41858 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17819, 378, 42157 >, < 90, 179.9999, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -9229.5000, 8692, 42684 >, < 0.0001, -90, 90 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -5909, 8669, 42068 >, < 0, 0.0001, 90.0001 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17056, 5050, 41858 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -2516, 2526, 41923.5000 >, < 0, 0, -179.9999 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -3099.5000, 3524.4990, 42226 >, < 0, 179.9997, 90.0003 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17280, 685, 42563 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -23445, 7316, 41858 >, < 0.0002, 180, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -2338, 8942, 43074 >, < 0, 0, -179.9999 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -3085, 3254, 43377 >, < 0.0002, 179.9999, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17600, 11468, 42157 >, < 90, -0.0001, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17345, 3837, 42549 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17023, 10844, 42157 >, < 90, -0.0001, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -21718, 7002.0030, 42549 >, < 0.0002, 180, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17331, 7455, 42157 >, < 90, 89.9998, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17345, 3212, 42549 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -3404.4990, 2606, 42226 >, < 90, 179.9999, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17524.1200, 156.1980, 42562 >, < 90, 90.0002, 0 >, true, 8000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17819, 685, 42157 >, < 90, 179.9999, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17345, 2610, 42549 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17522, 8441, 42549 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17005, 685, 42157 >, < 90, -0.0001, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -16846, 2562, 42157 >, < 90, -0.0001, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17307.8800, 155.8020, 42056 >, < 90, 90.0002, 0 >, true, 8000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17600, 9600, 42157 >, < 90, -0.0001, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -8927.5000, 8669, 42068 >, < 0, 0.0001, 90.0001 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17407.8000, 514.4995, 42056 >, < 90, -180, 0 >, true, 8000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -3212, 3576, 41923.5000 >, < 0, 0, -179.9999 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -8309.4000, 8921.2990, 41831 >, < 0, 0, -179.9999 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17423, 2562, 42157 >, < 90, -0.0001, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17600, 8992, 42157 >, < 90, -0.0001, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -23419, 8071, 42549 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -6526, 8668.9980, 42684 >, < 0, 0.0001, 90.0001 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17307.8800, 155.8020, 42308 >, < 90, 90.0002, 0 >, true, 8000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17345, 4439, 41858 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -23419, 8071, 41858 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -8310.5000, 8440.6000, 42068 >, < 0, 0.0001, 90.0001 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -9229.5000, 8692, 42068 >, < 0.0001, -90, 90 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -16846, 4371, 42157 >, < 90, -0.0001, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17343, 950.9986, 42157 >, < 90, 89.9998, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -2482.5000, 3524.4970, 43002 >, < 0, 179.9997, 90.0003 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -3099.5000, 1685.5010, 43002 >, < 0, 0, 90.0002 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17522, 10913, 42549 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -3404.4990, 3219, 43002 >, < 90, 179.9999, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -8927.5000, 8668.9980, 42684 >, < 0, 0.0001, 90.0001 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -6526, 9229.2990, 42068 >, < 0, -180, 89.9999 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -6526, 8921.2990, 43074 >, < 0, 0, -179.9999 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -5635, 8840, 42068 >, < -0.0001, 90.0001, 90 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -2338, 8665, 42068 >, < 0, 0, 90.0001 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17343, 43, 42157 >, < 90, -89.9999, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -20759, 7070.9990, 42157 >, < 90, 179.9999, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -2516, 3136, 41923.5000 >, < 0, 0, -179.9999 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -23419, 7068, 42157 >, < 90, -89.9999, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -21691.9900, 7757.0020, 42549 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -23734, 7316, 41858 >, < 0.0002, 180, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17023, 7791, 42157 >, < 90, -0.0001, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -2516, 1908, 41923.5000 >, < 0, 0, -179.9999 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -2175.5040, 3219, 43002 >, < 90, 0.0003, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -21102.9900, 7002.0020, 41858 >, < 0.0002, 180, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17023, 10210, 42157 >, < 90, -0.0001, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17522, 7839, 42549 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17023, 9600, 42157 >, < 90, -0.0001, 0 >, true, 50000, -1, 1 ) )
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -17056, 4439, 41858 >, < -0.0002, -0.0001, 180 >, true, 50000, -1, 1 ) )

    foreach( entity clip in playerClips ) {
        clip.MakeInvisible()
        clip.kv.solid = SOLID_VPHYSICS
        clip.kv.CollisionGroup = TRACE_COLLISION_GROUP_PLAYER
        clip.kv.contents = CONTENTS_SOLID
    }


    //PlayerNoCollisions 
    array<entity> PlayerNoCollisions 
    PlayerNoCollisions.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_apartments_rug_01.rmdl", < 9638.7000, -60.5000, 42440.8000 >, < 0, 0, 0 >, true, 50000, -1, 1.656 ) )
    PlayerNoCollisions.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_apartments_rug_01.rmdl", < 9638.7000, -898.6800, 42440.8000 >, < 0, 0, 0 >, true, 50000, -1, 1.656 ) )
    PlayerNoCollisions.append( MapEditor_CreateProp( $"mdl/signs/Sign_no_tresspasing.rmdl", < 10515, 10165.9000, -4223.4000 >, < 0, -89.9998, 0 >, true, 50000, -1, 1.9275 ) )
    PlayerNoCollisions.append( MapEditor_CreateProp( $"mdl/props/kunai/kunai.rmdl", < 10947.3800, 10004.8500, -4238.1480 >, < -90, -179.9995, 0 >, true, 50000, -1, 3.4856 ) )
    PlayerNoCollisions.append( MapEditor_CreateProp( $"mdl/props/kunai/kunai.rmdl", < 10948.0200, 10012.5900, -4234.9390 >, < -44.9999, -90, -89.9997 >, true, 50000, -1, 3.4856 ) )
    PlayerNoCollisions.append( MapEditor_CreateProp( $"mdl/props/kunai/kunai.rmdl", < 10948.7700, 9997.1000, -4234.9390 >, < -44.9999, 89.9997, -89.9997 >, true, 50000, -1, 3.4856 ) )
    PlayerNoCollisions.append( MapEditor_CreateProp( $"mdl/props/kunai/kunai.rmdl", < 10948.0200, 10093, -4234.9390 >, < -44.9999, -90, -89.9997 >, true, 50000, -1, 3.4856 ) )
    PlayerNoCollisions.append( MapEditor_CreateProp( $"mdl/props/kunai/kunai.rmdl", < 10948.7700, 10077.5100, -4234.9390 >, < -44.9999, 89.9997, -89.9997 >, true, 50000, -1, 3.4856 ) )
    PlayerNoCollisions.append( MapEditor_CreateProp( $"mdl/props/kunai/kunai.rmdl", < 10948.7700, 10176.9000, -4227.2000 >, < -0.0003, -89.9998, 90.0001 >, true, 50000, -1, 3.4856 ) )
    PlayerNoCollisions.append( MapEditor_CreateProp( $"mdl/robots/drone_frag/drone_frag_loot.rmdl", < 10896.9200, 9462.7000, -4274.8000 >, < -9.8903, -28.4672, -17.5772 >, true, 50000, -1, 1.2036 ) )
    PlayerNoCollisions.append( MapEditor_CreateProp( $"mdl/robots/drone_frag/drone_frag_loot_bf.rmdl", < 10815, 9462.7000, -4274.8000 >, < -9.8903, -28.4672, -17.5772 >, true, 50000, -1, 1.2036 ) )
    PlayerNoCollisions.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_apartments_rug_01.rmdl", < -17551.7700, 298.0776, 41940.3700 >, < 0, 73.3119, 0 >, true, 50000, -1, 1 ) )
    PlayerNoCollisions.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_apartments_rug_01.rmdl", < -17274.7000, 7743.4000, 41939.9000 >, < 0, 89.9998, 0 >, true, 50000, -1, 1.81 ) )
    PlayerNoCollisions.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_apartments_rug_02.rmdl", < -21693.8400, 7644.7270, 41939.3000 >, < 0, 0.0007, 0 >, true, 50000, -1, 0.82 ) )
    PlayerNoCollisions.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_apartments_rug_01.rmdl", < -5753.4000, 8792.6000, 42424.9000 >, < 0, 0, 0 >, true, 50000, -1, 1.6393 ) )
    PlayerNoCollisions.append( MapEditor_CreateProp( $"mdl/domestic/floor_rug_red.rmdl", < -17273.8900, 10411.2500, 41939.3000 >, < 0, 89.9998, 0 >, true, 50000, -1, 2.11 ) )
    PlayerNoCollisions.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_apartments_rug_01.rmdl", < -17281.2200, 317.3472, 41939.9000 >, < 0, 171.0228, 0 >, true, 50000, -1, 1 ) )
    PlayerNoCollisions.append( MapEditor_CreateProp( $"mdl/domestic/floor_rug_red.rmdl", < -17273.8900, 11752, 41939.3000 >, < 0, 89.9998, 0 >, true, 50000, -1, 2.11 ) )
    PlayerNoCollisions.append( MapEditor_CreateProp( $"mdl/signs/numbers/sign_number_lit_1.rmdl", < 10729.8000, 9489, -4221 >, < 0, 90, 0 >, true, 50000, -1, 4.915405 ) )
    PlayerNoCollisions.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_apartments_rug_02.rmdl", < -23402.3400, 7522.9640, 41939.3000 >, < 0, 0.0007, 0 >, true, 50000, -1, 1 ) )
    PlayerNoCollisions.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_apartments_rug_02.rmdl", < -21638.4200, 7082.6370, 41939.3000 >, < 0, -89.9998, 0 >, true, 50000, -1, 1 ) )
    PlayerNoCollisions.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_apartments_rug_01.rmdl", < -6546.9000, 8759.7000, 41918 >, < 0, -83.6755, 0 >, true, 50000, -1, 1.247573 ) )
    PlayerNoCollisions.append( MapEditor_CreateProp( $"mdl/domestic/floor_rug_red.rmdl", < -17273.8900, 9138.6000, 41939.3000 >, < 0, 89.9998, 0 >, true, 50000, -1, 2.11 ) )
    PlayerNoCollisions.append( MapEditor_CreateProp( $"mdl/props/octane_jump_pad/octane_jump_pad.rmdl", < 10509, 10004, -4217.5000 >, < 90, 0, 0 >, true, 50000, -1, 1.367478 ) )
    PlayerNoCollisions.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_apartments_rug_01.rmdl", < -17551.6100, 509.5674, 41940.3700 >, < 0, 121.4849, 0 >, true, 50000, -1, 1 ) )
    PlayerNoCollisions.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_apartments_rug_01.rmdl", < -17274.7000, 8405.1000, 41939.9000 >, < 0, 89.9998, 0 >, true, 50000, -1, 1.81 ) )
    PlayerNoCollisions.append( MapEditor_CreateProp( $"mdl/domestic/floor_rug_red.rmdl", < -17273.8900, 11068.1300, 41939.3000 >, < 0, 89.9998, 0 >, true, 50000, -1, 2.11 ) )
    PlayerNoCollisions.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_apartments_rug_01.rmdl", < -2341.3000, 8742, 41916.9000 >, < 0, -97.7208, 0 >, true, 50000, -1, 1.030398 ) )
    PlayerNoCollisions.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_apartments_rug_02.rmdl", < -23507.0700, 7563.2920, 41939.5000 >, < 0, 174.2769, 0 >, true, 50000, -1, 0.73 ) )
    PlayerNoCollisions.append( MapEditor_CreateProp( $"mdl/industrial/screwdriver_octane.rmdl", < 10517, 10109, -4230.4000 >, < 0, -180, -90 >, true, 50000, -1, 4.98262 ) )
    PlayerNoCollisions.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_apartments_rug_01.rmdl", < -17280.6200, 570.2456, 41939.9000 >, < 0, -77.4886, 0 >, true, 50000, -1, 1 ) )
    PlayerNoCollisions.append( MapEditor_CreateProp( $"mdl/props/lifeline_needle/lifeline_needle.rmdl", < 10517.2000, 9920.3000, -4230.4000 >, < 0, -90, -90 >, true, 50000, -1, 6.85924 ) )
    PlayerNoCollisions.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_apartments_rug_01.rmdl", < -8154, 8564, 42424.9000 >, < 0, 0, 0 >, true, 50000, -1, 1.6393 ) )
    PlayerNoCollisions.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_apartments_rug_02.rmdl", < -21102, 7271.2730, 41939.3000 >, < 0, -179.9997, 0 >, true, 50000, -1, 0.82 ) )
    PlayerNoCollisions.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_apartments_rug_02.rmdl", < -20997.3400, 7244.7770, 41939.3000 >, < 0, 0.0007, 0 >, true, 50000, -1, 1 ) )
    PlayerNoCollisions.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_apartments_rug_02.rmdl", < -23637.8400, 7666.8870, 41939.3000 >, < 0, 0.0007, 0 >, true, 50000, -1, 1 ) )
    PlayerNoCollisions.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_apartments_rug_02.rmdl", < -21798.5000, 7673, 41939.3000 >, < 0, -179.9997, 0 >, true, 50000, -1, 1 ) )
    PlayerNoCollisions.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_apartments_rug_01.rmdl", < -2336.0330, 8788.9680, 42297.6000 >, < 0, 7.2791, 0 >, true, 50000, -1, 1.6393 ) )
    PlayerNoCollisions.append( MapEditor_CreateProp( $"mdl/signs/numbers/sign_number_lit_2.rmdl", < 10649.5000, 9489, -4221 >, < 0, 90, 0 >, true, 50000, -1, 4.915405 ) )
    PlayerNoCollisions.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_apartments_rug_01.rmdl", < -8947.5000, 8759.7000, 41918 >, < 0, -83.6755, 0 >, true, 50000, -1, 1.247573 ) )
    PlayerNoCollisions.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_apartments_rug_02.rmdl", < -23742.5000, 7731.1110, 41939.3000 >, < 0, -179.9997, 0 >, true, 50000, -1, 1 ) )
    PlayerNoCollisions.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_apartments_rug_02.rmdl", < -21175.2500, 7716, 41939.3000 >, < 0, -89.9998, 0 >, true, 50000, -1, 0.85 ) )
    PlayerNoCollisions.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_apartments_rug_02.rmdl", < -21612.7300, 7187.3000, 41939.3000 >, < 0, 90.0005, 0 >, true, 50000, -1, 0.82 ) )
    PlayerNoCollisions.append( MapEditor_CreateProp( $"mdl/signs/numbers/sign_number_lit_3.rmdl", < 10570.1000, 9489, -4221 >, < 0, 90, 0 >, true, 50000, -1, 4.915405 ) )
    PlayerNoCollisions.append( MapEditor_CreateProp( $"mdl/domestic/floor_rug_red.rmdl", < -17273.8900, 9801, 41939.3000 >, < 0, 89.9998, 0 >, true, 50000, -1, 2.11 ) )
    PlayerNoCollisions.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_apartments_rug_02.rmdl", < -21154.9700, 7820.6630, 41939.3000 >, < 0, 90.0005, 0 >, true, 50000, -1, 1 ) )

    foreach( entity nocollision in PlayerNoCollisions ) {
        nocollision.kv.solid = 0
    }


    //PlayerNoClimbs 
    array<entity> PlayerNoClimbs 
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -9071.5000, 8790, 42031.5000 >, < 90, 0, 0 >, true, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -21054, 7022, 42114 >, < 90, 90.0006, 0 >, false, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -21736, 7010.2010, 42114 >, < 90, 90.0012, 0 >, false, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17274, 3214, 42066 >, < 90, 90.0002, 0 >, true, 8000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -6670, 8790, 42031.5000 >, < 90, 0, 0 >, true, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_256.rmdl", < -17153.9000, 2657.6000, 41939.9000 >, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -23820.1000, 7636.4580, 42114 >, < 90, 0.0007, 0 >, false, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_256.rmdl", < -17153.9000, 3537.5000, 41939.9000 >, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17274, 3843, 42066 >, < 90, 90.0002, 0 >, true, 8000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -6539.1000, 8790, 42151.3000 >, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_256.rmdl", < -17149.1000, 3852.7000, 41939.9000 >, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -23340.7400, 7559.5420, 42114 >, < 90, 0.0007, 0 >, false, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17326, 5108.7000, 42066 >, < 90, 90.0002, 0 >, true, 8000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -21182, 7281.0840, 42114 >, < 90, 0.0007, 0 >, false, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17274, 3601.1990, 42066 >, < 90, 90.0002, 0 >, true, 8000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -20942.2000, 7150, 41988 >, < 90, 0.0007, 0 >, false, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_256.rmdl", < -17149.1000, 4488, 41939.9000 >, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -23580, 7596, 42114 >, < 90, 0.0007, 0 >, false, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/domestic/tv_LED_med_panel.rmdl", < -20944.2300, 7226, 42034.0400 >, < 0, 179.9997, 0 >, true, 50000, -1, 2.14 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -8823.6000, 8790, 42031.5000 >, < 90, 0, 0 >, true, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/domestic/tv_LED_med_panel.rmdl", < -21857.8900, 7682, 42034.0400 >, < 0, 0, 0 >, true, 50000, -1, 2.14 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/domestic/tv_LED_med_panel.rmdl", < -21652, 7028.2260, 42034.0400 >, < 0, 89.9998, 0 >, true, 50000, -1, 2.14 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -21161.0100, 7411, 42172 >, < 0.0002, -90.0005, 90 >, true, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -21182, 7281.0840, 41988 >, < 90, 0.0007, 0 >, false, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -21748, 7880, 42114 >, < 90, 90.0005, 0 >, false, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -21639.9900, 7508, 42172 >, < 0.0002, 89.9998, 90 >, true, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -20923.0200, 7410.9990, 42172 >, < 0.0002, -90.0005, 90 >, true, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17144, 4045.5000, 42066 >, < 90, -180, 0 >, true, 8000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17030, 2892.2000, 42066 >, < 90, 90.0002, 0 >, true, 8000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -23340.9400, 7428.4580, 41988 >, < 90, 0.0007, 0 >, false, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -6537, 8677.7000, 42031.5000 >, < 90, -90, 0 >, true, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -21875.9000, 7767.5420, 41988 >, < 90, 0.0007, 0 >, false, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17144, 4997, 42066 >, < 90, -180, 0 >, true, 8000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -21606.9200, 7009.9990, 41988 >, < 90, 90.0012, 0 >, false, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17274, 4479.5000, 42066 >, < 90, 90.0002, 0 >, true, 8000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -8940.6000, 8790, 42151.3000 >, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17274, 2972.2000, 42066 >, < 90, 90.0002, 0 >, true, 8000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17144, 4681.3990, 42066 >, < 90, -180, 0 >, true, 8000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -8938.5000, 8677.7000, 42031.5000 >, < 90, -90, 0 >, true, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_256.rmdl", < -17153.9000, 4557.9000, 41939.9000 >, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -23340.9400, 7428.4580, 42114 >, < 90, 0.0007, 0 >, false, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -21608, 7250.2000, 42114 >, < 90, 90.0012, 0 >, false, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -21877.9900, 7508, 42172 >, < 0.0002, 89.9998, 90 >, true, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_256.rmdl", < -17149.1000, 3607, 41939.9000 >, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -21054, 7022, 41988 >, < 90, 90.0006, 0 >, false, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -20926, 7768, 41988 >, < 90, -179.9996, 0 >, false, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -21620, 7638, 42114 >, < 90, -179.9996, 0 >, false, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -23820.1000, 7636.4580, 41988 >, < 90, 0.0007, 0 >, false, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -20926, 7768, 42114 >, < 90, -179.9996, 0 >, false, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_256.rmdl", < -17149.1000, 5118, 41939.9000 >, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17144, 3730, 42066 >, < 90, -180, 0 >, true, 8000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_256.rmdl", < -17153.9000, 4169.4000, 41939.9000 >, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17274, 4237.7000, 42066 >, < 90, 90.0002, 0 >, true, 8000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17030, 3915.5000, 42066 >, < 90, 90.0002, 0 >, true, 8000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_256.rmdl", < -17153.9000, 3922.9000, 41939.9000 >, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -21185.0800, 7880, 42114 >, < 90, 90.0006, 0 >, false, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -6422.1000, 8790, 42031.5000 >, < 90, 0, 0 >, true, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17030, 4551.5000, 42066 >, < 90, 90.0002, 0 >, true, 8000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_256.rmdl", < -17153.9000, 4803.6000, 41939.9000 >, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -23452.8400, 7315.9630, 42114 >, < 90, -89.9992, 0 >, false, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -23692, 7956.1470, 41988 >, < 90, 90.0005, 0 >, false, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -21876.1000, 7636.4580, 42114 >, < 90, 0.0007, 0 >, false, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -21620, 7638, 41988 >, < 90, -179.9996, 0 >, false, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_256.rmdl", < -17153.9000, 3291.8000, 41939.9000 >, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -21056, 7880.2000, 42114 >, < 90, 90.0006, 0 >, false, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -21056, 7880.2000, 41988 >, < 90, 90.0006, 0 >, false, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -21864, 7136, 42114 >, < 90, 0.0007, 0 >, false, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17030, 3286, 42066 >, < 90, 90.0002, 0 >, true, 8000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -21477, 7245.0150, 42172 >, < 0.0002, 179.9996, 90 >, true, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17030, 3528.0990, 42066 >, < 90, 90.0002, 0 >, true, 8000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17144, 3100, 42066 >, < 90, -180, 0 >, true, 8000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17144, 3414, 42066 >, < 90, -180, 0 >, true, 8000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -23692, 7956.1470, 42114 >, < 90, 90.0005, 0 >, false, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_256.rmdl", < -17153.9000, 2903.3000, 41939.9000 >, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -21608, 7250.2000, 41988 >, < 90, 90.0012, 0 >, false, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -23580, 7596, 41988 >, < 90, 0.0007, 0 >, false, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -21315, 7660.9840, 42172 >, < 0.0002, -0.0007, 90 >, true, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_256.rmdl", < -17149.1000, 2977.6000, 41939.9000 >, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -23819.9000, 7843.6890, 41988 >, < 90, 0.0007, 0 >, false, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -21185.0800, 7640.0010, 41988 >, < 90, 90.0006, 0 >, false, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -21736, 7010.2010, 41988 >, < 90, 90.0012, 0 >, false, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -23452.8400, 7315.9630, 41988 >, < 90, -89.9992, 0 >, false, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17030, 2650, 42066 >, < 90, 90.0002, 0 >, true, 8000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_256.rmdl", < -17149.1000, 4242.3000, 41939.9000 >, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_256.rmdl", < -17149.1000, 4872.3000, 41939.9000 >, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17144, 2779.9990, 42066 >, < 90, -180, 0 >, true, 8000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/domestic/tv_LED_med_panel.rmdl", < -21146, 7877.7740, 42034.0400 >, < 0, -90.0005, 0 >, true, 50000, -1, 2.14 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17274, 4866.7000, 42066 >, < 90, 90.0002, 0 >, true, 8000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -21875.9000, 7767.5420, 42114 >, < 90, 0.0007, 0 >, false, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -21876.1000, 7636.4580, 41988 >, < 90, 0.0007, 0 >, false, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -21606.9200, 7009.9990, 42114 >, < 90, 90.0012, 0 >, false, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -20942.2000, 7150, 42114 >, < 90, 0.0007, 0 >, false, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -23819.9000, 7843.6890, 42114 >, < 90, 0.0007, 0 >, false, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17030, 4793.6000, 42066 >, < 90, 90.0002, 0 >, true, 8000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17030, 4157.7000, 42066 >, < 90, 90.0002, 0 >, true, 8000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -21315, 7898.9850, 42172 >, < 0.0002, -0.0007, 90 >, true, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -21864, 7136, 41988 >, < 90, 0.0007, 0 >, false, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17144, 4367, 42066 >, < 90, -180, 0 >, true, 8000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -21748, 7880, 41988 >, < 90, 90.0005, 0 >, false, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -21185.0800, 7880, 41988 >, < 90, 90.0006, 0 >, false, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -20942, 7281.0840, 42114 >, < 90, 0.0007, 0 >, false, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -23340.7400, 7559.5420, 41988 >, < 90, 0.0007, 0 >, false, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_256.rmdl", < -17149.1000, 3223.3000, 41939.9000 >, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -21477, 7007.0160, 42172 >, < 0.0002, 179.9996, 90 >, true, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -21185.0800, 7640.0010, 42114 >, < 90, 90.0006, 0 >, false, 50000, -1, 1 ) )
    PlayerNoClimbs.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -20942, 7281.0840, 41988 >, < 90, 0.0007, 0 >, false, 50000, -1, 1 ) )

    foreach( entity noclimb in PlayerNoClimbs ) {
        noclimb.kv.solid = 3
    }


    //Triggers 
    entity trigger0 = MapEditor_CreateTrigger( < 10709, 9967, -4168 >, < 0, 0, 0 >, 747.9188, 149.5838, false )
    trigger0.SetEnterCallback( void function(entity trigger , entity ent){
    if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            TakeAllWeapons( ent )
        }
    }
    })
    DispatchSpawn( trigger0 )
    entity trigger1 = MapEditor_CreateTrigger( < 9649.3000, -906.2000, 42444.9000 >, < 0, 0, 0 >, 132.982, 26.5964, false )
    trigger1.SetEnterCallback( void function(entity trigger , entity ent){
    if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
	StatusEffect_StopAllOfType( ent, eStatusEffect.speed_boost )
	StatusEffect_StopAllOfType( ent, eStatusEffect.stim_visual_effect )
	ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
	ent.GiveOffhandWeapon("mp_ability_heal", OFFHAND_TACTICAL)
        }
    }

    })
    DispatchSpawn( trigger1 )
    entity trigger2 = MapEditor_CreateTrigger( < 9649.3000, -48.7000, 42444.9000 >, < 0, 0, 0 >, 132.982, 26.5964, false )
    trigger2.SetEnterCallback( void function(entity trigger , entity ent){
    if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
	StatusEffect_StopAllOfType( ent, eStatusEffect.speed_boost )
	StatusEffect_StopAllOfType( ent, eStatusEffect.stim_visual_effect )
	ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
	ent.GiveOffhandWeapon("mp_ability_heal", OFFHAND_TACTICAL)
        }
    }

    })
    DispatchSpawn( trigger2 )
    entity trigger3 = MapEditor_CreateTrigger( < 9705, -508, 42156 >, < 0, 0, 0 >, 1109.034, 221.8068, false )
    trigger3.SetEnterCallback( void function(entity trigger , entity ent){
    if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< 9647, -963, 42441.2000 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger3 )
    entity trigger4 = MapEditor_CreateTrigger( < 9705, -508, 42607 >, < 0, 0, 0 >, 1109.034, 221.8068, false )
    trigger4.SetEnterCallback( void function(entity trigger , entity ent){
    if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
	StatusEffect_StopAllOfType( ent, eStatusEffect.speed_boost )
	StatusEffect_StopAllOfType( ent, eStatusEffect.stim_visual_effect )
	ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
	ent.GiveOffhandWeapon("mp_ability_heal", OFFHAND_TACTICAL)
        }
    }

    })
    trigger4.SetLeaveCallback( void function(entity trigger , entity ent){
    if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
	StatusEffect_StopAllOfType( ent, eStatusEffect.speed_boost )
	StatusEffect_StopAllOfType( ent, eStatusEffect.stim_visual_effect )
	ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
	ent.GiveOffhandWeapon("mp_ability_phase_walk", OFFHAND_TACTICAL)
        }
    }

    })
    DispatchSpawn( trigger4 )
    entity trigger5 = MapEditor_CreateTrigger( < 3311, 4854, 41856 >, < 0, 0, 0 >, 2388.858, 477.7715, false )
    trigger5.SetEnterCallback( void function(entity trigger , entity ent){
    if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< 3391.9900, 2660.3000, 42441.2000 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger5 )
    entity trigger6 = MapEditor_CreateTrigger( < 3311, 6984, 41856 >, < 0, 0, 0 >, 2388.858, 477.7715, false )
    trigger6.SetEnterCallback( void function(entity trigger , entity ent){
    if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< 3391.9900, 2660.3000, 42441.2000 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger6 )
    entity trigger7 = MapEditor_CreateTrigger( < -17188, 5146, 41740 >, < 0, 0, 0 >, 804.6814, 160.9363, false )
    trigger7.SetEnterCallback( void function(entity trigger , entity ent){
    if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< -17280, 2500, 41940 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger7 )
    entity trigger8 = MapEditor_CreateTrigger( < 3399, 6875, -1931 >, < 0, 0, 0 >, 449.6239, 89.92479, false )
    trigger8.SetEnterCallback( void function(entity trigger , entity ent){
    if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< 3250.5000, 6614, -1218.0010 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger8 )
    entity trigger9 = MapEditor_CreateTrigger( < -8627.5000, 8932, 41703.3000 >, < 0, 0, 0 >, 804.6814, 160.9363, false )
    trigger9.SetEnterCallback( void function(entity trigger , entity ent){
    if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< -8932.6010, 8698.3000, 41914.3000 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger9 )
    entity trigger10 = MapEditor_CreateTrigger( < -17274, 9410, 41740 >, < 0, 0, 0 >, 683.7861, 136.7572, false )
    trigger10.SetEnterCallback( void function(entity trigger , entity ent){
    if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< -17280, 9104, 41940 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger10 )
    entity trigger11 = MapEditor_CreateTrigger( < -17274, 10820, 41740 >, < 0, 0, 0 >, 683.7861, 136.7572, false )
    trigger11.SetEnterCallback( void function(entity trigger , entity ent){
    if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< -17280, 9104, 41940 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger11 )
    entity trigger12 = MapEditor_CreateTrigger( < -17188, 4326, 41740 >, < 0, 0, 0 >, 804.6814, 160.9363, false )
    trigger12.SetEnterCallback( void function(entity trigger , entity ent){
    if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< -17280, 2500, 41940 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger12 )
    entity trigger13 = MapEditor_CreateTrigger( < 3328.9710, 3021.6360, -1325.2640 >, < 0, 0, 0 >, 857.529, 171.5058, false )
    trigger13.SetEnterCallback( void function(entity trigger , entity ent){
    if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< 3380, 1966, -1008 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger13 )
    entity trigger14 = MapEditor_CreateTrigger( < -21133, 6720, 41740 >, < 0, 0, 0 >, 683.7861, 136.7572, false )
    trigger14.SetEnterCallback( void function(entity trigger , entity ent){
    if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< -21670, 7550, 41938.3500 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger14 )
    entity trigger15 = MapEditor_CreateTrigger( < 4511, 9162, -1203 >, < 0, 0, 0 >, 278.551, 55.71021, false )
    trigger15.SetEnterCallback( void function(entity trigger , entity ent){
    if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< 4162, 8476, -942.9995 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger15 )
    entity trigger16 = MapEditor_CreateTrigger( < -6226, 8932, 41703.3000 >, < 0, 0, 0 >, 804.6814, 160.9363, false )
    trigger16.SetEnterCallback( void function(entity trigger , entity ent){
    if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< -6531.1010, 8698.3000, 41914.3000 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger16 )
    entity trigger17 = MapEditor_CreateTrigger( < -17188, 3584, 41740 >, < 0, 0, 0 >, 804.6814, 160.9363, false )
    trigger17.SetEnterCallback( void function(entity trigger , entity ent){
    if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< -17280, 2500, 41940 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger17 )
    entity trigger18 = MapEditor_CreateTrigger( < -17274, 8028, 41740 >, < 0, 0, 0 >, 683.7861, 136.7572, false )
    trigger18.SetEnterCallback( void function(entity trigger , entity ent){
    if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< -17280, 7716, 41940 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger18 )
    entity trigger19 = MapEditor_CreateTrigger( < 3931.9710, 1215.0060, -1952.2640 >, < 0, 0, 0 >, 689.3739, 137.8748, false )
    trigger19.SetEnterCallback( void function(entity trigger , entity ent){
    if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< 4992, 1147.7710, -1261 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger19 )
    entity trigger20 = MapEditor_CreateTrigger( < -23634, 7660, 41740 >, < 0, 0, 0 >, 779.9, 155.98, false )
    trigger20.SetEnterCallback( void function(entity trigger , entity ent){
    if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< -23694, 7550, 41938.3500 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger20 )
    entity trigger21 = MapEditor_CreateTrigger( < 3282, 1332, -1325.2640 >, < 0, 0, 0 >, 226.3008, 45.26015, false )
    trigger21.SetEnterCallback( void function(entity trigger , entity ent){
    if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< 3380, 1139.7720, -1008 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger21 )
    entity trigger22 = MapEditor_CreateTrigger( < -17274, 11556, 41740 >, < 0, 0, 0 >, 683.7861, 136.7572, false )
    trigger22.SetEnterCallback( void function(entity trigger , entity ent){
    if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< -17280, 9104, 41940 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger22 )
    entity trigger23 = MapEditor_CreateTrigger( < -17188, 2924, 41740 >, < 0, 0, 0 >, 804.6814, 160.9363, false )
    trigger23.SetEnterCallback( void function(entity trigger , entity ent){
    if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< -17280, 2500, 41940 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger23 )
    entity trigger24 = MapEditor_CreateTrigger( < -17274, 10230, 41740 >, < 0, 0, 0 >, 683.7861, 136.7572, false )
    trigger24.SetEnterCallback( void function(entity trigger , entity ent){
    if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< -17280, 9104, 41940 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger24 )
    entity trigger25 = MapEditor_CreateTrigger( < 3624, 4344, -1192 >, < 0, 0, 0 >, 420.6858, 84.13713, false )
    trigger25.SetEnterCallback( void function(entity trigger , entity ent){
    if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< 3380, 3648, -686.9995 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger25 )
    entity trigger26 = MapEditor_CreateTrigger( < 3282, 5031, -1192 >, < 0, 0, 0 >, 420.6858, 84.13713, false )
    trigger26.SetEnterCallback( void function(entity trigger , entity ent){
    if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< 3380, 4406, -753.9995 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger26 )
    entity trigger27 = MapEditor_CreateTrigger( < -2309, 8932, 41703.3000 >, < 0, 0, 0 >, 804.6814, 160.9363, false )
    trigger27.SetEnterCallback( void function(entity trigger , entity ent){
    if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< -2329.1000, 8714.7000, 41919.5000 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger27 )
    entity trigger28 = MapEditor_CreateTrigger( < 5749, 9147, -1297 >, < 0, 0, 0 >, 965.0747, 193.0149, false )
    trigger28.SetEnterCallback( void function(entity trigger , entity ent){
    if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< 4658, 9149, -811.9995 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger28 )
    entity trigger29 = MapEditor_CreateTrigger( < 6315.9710, 1215.0100, -1952.2640 >, < 0, 0, 0 >, 1808.906, 361.7811, false )
    trigger29.SetEnterCallback( void function(entity trigger , entity ent){
    if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< 6767.9240, 1149.2000, -1025.2000 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger29 )
    entity trigger30 = MapEditor_CreateTrigger( < 3455, 5938, -1886 >, < 0, 0, 0 >, 662.0141, 132.4028, false )
    trigger30.SetEnterCallback( void function(entity trigger , entity ent){
    if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< 3348, 5222, -882.9995 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger30 )
    entity trigger31 = MapEditor_CreateTrigger( < -21835, 6720, 41740 >, < 0, 0, 0 >, 683.7861, 136.7572, false )
    trigger31.SetEnterCallback( void function(entity trigger , entity ent){
    if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< -21670, 7550, 41938.3500 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger31 )
    entity trigger32 = MapEditor_CreateTrigger( < -21835, 7478, 41740 >, < 0, 0, 0 >, 683.7861, 136.7572, false )
    trigger32.SetEnterCallback( void function(entity trigger , entity ent){
    if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< -21670, 7550, 41938.3500 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger32 )
    entity trigger33 = MapEditor_CreateTrigger( < 4021, 8308, -1317 >, < 0, 0, 0 >, 449.6239, 89.92479, false )
    trigger33.SetEnterCallback( void function(entity trigger , entity ent){
    if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< 3723, 7739, -1006 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger33 )
    entity trigger34 = MapEditor_CreateTrigger( < 4511, 8875, -1203 >, < 0, 0, 0 >, 278.551, 55.71021, false )
    trigger34.SetEnterCallback( void function(entity trigger , entity ent){
    if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< 4162, 8476, -942.9995 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger34 )
    entity trigger35 = MapEditor_CreateTrigger( < -21133, 7478, 41740 >, < 0, 0, 0 >, 683.7861, 136.7572, false )
    trigger35.SetEnterCallback( void function(entity trigger , entity ent){
    if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< -21670, 7550, 41938.3500 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger35 )
    entity trigger36 = MapEditor_CreateTrigger( < 3399, 7653, -1317 >, < 0, 0, 0 >, 449.6239, 89.92479, false )
    trigger36.SetEnterCallback( void function(entity trigger , entity ent){
    if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< 3381, 7335, -1137 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger36 )
    entity trigger37 = MapEditor_CreateTrigger( < 3328.9710, 1574.6360, -1325.2640 >, < 0, 0, 0 >, 226.3008, 45.26015, false )
    trigger37.SetEnterCallback( void function(entity trigger , entity ent){
    if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< 3380, 1139.7720, -1008 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger37 )
    entity trigger38 = MapEditor_CreateTrigger( < -17428, 489.9999, 41740 >, < 0, 0, 0 >, 804.6814, 160.9363, false )
    trigger38.SetEnterCallback( void function(entity trigger , entity ent){
    if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(<-17280, 258.0005, 41940>) // change tp location
        }
    }
    })
    DispatchSpawn( trigger38 )
    entity trigger39 = MapEditor_CreateTrigger( < 3328.9710, 1858.6360, -1325.2640 >, < 0, 0, 0 >, 226.3008, 45.26015, false )
    trigger39.SetEnterCallback( void function(entity trigger , entity ent){
    if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< 3380, 1139.7720, -1008 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger39 )

}
