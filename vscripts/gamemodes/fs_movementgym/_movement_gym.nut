untyped

globalize_all_functions

//  ╔╦╗╔═╗╦  ╦╔═╗╔╦╗╔═╗╔╗╔╔╦╗  ╔═╗╦ ╦╔╦╗
//  ║║║║ ║╚╗╔╝║╣ ║║║║╣ ║║║ ║   ║ ╦╚╦╝║║║
//  ╩ ╩╚═╝ ╚╝ ╚═╝╩ ╩╚═╝╝╚╝ ╩   ╚═╝ ╩ ╩ ╩
//  
//  Server Script
//  
//  Made by DEAFPS
//
//  With help from:
//  CaféFPS - Flowstate the one and only R5R VScript repo
//  AyeZee - ReMap Tool
//  Julefox - ReMap Tool
//  
//  TweeWee & JayTheYggdrasil - Map1
//  Dzajko my beloved son - Map2 & and Pathfinder segments help
//  LoyTakian - Map3

//  ╔╗ ╔═╗╔═╗╦╔═╗  ╔═╗╦ ╦╔╗╔╔═╗╔╦╗╦╔═╗╔╗╔╔═╗
//  ╠╩╗╠═╣╚═╗║║    ╠╣ ║ ║║║║║   ║ ║║ ║║║║╚═╗
//  ╚═╝╩ ╩╚═╝╩╚═╝  ╚  ╚═╝╝╚╝╚═╝ ╩ ╩╚═╝╝╚╝╚═╝

//Init Movement Gym
void
function MovementGym() {
  if (GetMapName() == "mp_rr_desertlands_64k_x_64k" || GetMapName() == "mp_rr_desertlands_64k_x_64k_nx" || GetMapName() == "mp_rr_arena_composite") {
    
    // Commands
    AddClientCommandCallback("hub", ClientCommand_Hub)
    AddClientCommandCallback("invis", ClientCommand_invis)
    //AddClientCommandCallback("meter", ClientCommand_meter)
    //AddClientCommandCallback("keys", ClientCommand_keys)
    //AddClientCommandCallback("style", ClientCommand_style)
    AddClientCommandCallback("spectate", _MG_Spectate) //99% ready will update via pull after release
    
    //Settings Init
    if(Flowstate_MovementGym_ClassicMovement()){
	//Classic_Movement = true
        ServerCommand("wallrun_enable 0")
	ServerCommand("sv_quota_stringCmdsPerSecond 64")
    }
    
    
    //Map init
    MovementGym_Hub()
    WaitFrame()

    MovementGym_Map1()
    WaitFrame()
    
    MovementGym_Map2()
    WaitFrame()
    
    MovementGym_Map3()
    WaitFrame()

    MovementGym_Octane()
    WaitFrame()

    MovementGym_Tapstrafe()
    WaitFrame()

    MovementGym_Superglide()
    WaitFrame()

    MovementGym_MantleJumps()
    WaitFrame()

    MovementGym_Grapple1()
    WaitFrame()

    MovementGym_Grapple2()
    WaitFrame()
    
    //MovementGym_Surf_Kitsune_lvl1()
    //WaitFrame()
    //
    //MovementGym_Surf_Kitsune_lvl2()
    //WaitFrame()
    //
    //MovementGym_Surf_Kitsune_lvl3()
    //WaitFrame()
    //
    //MovementGym_Surf_Kitsune_lvl4()
    //WaitFrame()
    //
    //MovementGym_Surf_Kitsune_lvl5()
    //WaitFrame()
    //
    //MovementGym_Surf_Kitsune_lvl6()
    //WaitFrame()
    //
    //MovementGym_Surf_Kitsune_lvl7()
    //WaitFrame()

    MovementGym_Hub_Buttons()
    WaitFrame()

    MovementGym_Map1_Button()
    WaitFrame()
    
    MovementGym_Map2_Button()
    WaitFrame()
    
    //MovementGym_Surf_Button()
    //WaitFrame()
    
    MovementGym_Map3_Button()
    WaitFrame()
    
    thread MovementGymSaveTimesToFile_thread()

  }
}

//Precache props
void
function PrecacheMovementGymProps() {

  PrecacheModel($"mdl/beacon/construction_scaff_post_256_01.rmdl")
	PrecacheModel($"mdl/barriers/concrete/concrete_barrier_01.rmdl")
  PrecacheModel($"mdl/homestead/homestead_floor_panel_01.rmdl")
  PrecacheModel($"mdl/utilities/wall_Waterpipe.rmdl")
	PrecacheModel($"mdl/props/charm/charm_nessy.rmdl")
	PrecacheModel($"mdl/vehicle/hovership/hovership_platform_mp.rmdl")
	PrecacheModel( $"mdl/garbage/garbage_bag_plastic_a.rmdl" )
	PrecacheModel( $"mdl/angel_city/vending_machine.rmdl" )
	PrecacheModel( $"mdl/barriers/concrete/concrete_barrier_fence.rmdl" )
	PrecacheModel( $"mdl/barriers/guard_rail_01_128.rmdl" )
	PrecacheModel( $"mdl/barriers/guard_rail_01_256.rmdl" )
	PrecacheModel( $"mdl/barriers/shooting_range_target_02.rmdl" )
	PrecacheModel( $"mdl/beacon/beacon_fence_sign_01.rmdl" )
	PrecacheModel( $"mdl/beacon/modular_hose_yellow_128_02.rmdl" )
	PrecacheModel( $"mdl/beacon/modular_hose_yellow_32_01.rmdl" )
	PrecacheModel( $"mdl/beacon/modular_hose_yellow_512_02.rmdl" )
	PrecacheModel( $"mdl/beacon/modular_hose_yellow_corner_01.rmdl" )
	PrecacheModel( $"mdl/colony/antenna_03_colony.rmdl" )
	PrecacheModel( $"mdl/colony/farmland_ceiling_096x048_01.rmdl" )
	PrecacheModel( $"mdl/colony/ventilation_unit_01_black.rmdl" )
	PrecacheModel( $"mdl/containers/slumcity_oxygen_bag_large_01_b.rmdl" )
	PrecacheModel( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl" )
	PrecacheModel( $"mdl/desertlands/city_steps_metal_grate_double_128_01.rmdl" )
	PrecacheModel( $"mdl/desertlands/construction_bldg_column_01.rmdl" )
	PrecacheModel( $"mdl/desertlands/construction_bldg_column_stack_01.rmdl" )
	PrecacheModel( $"mdl/desertlands/construction_bldg_elevator_01_bott.rmdl" )
	PrecacheModel( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl" )
	PrecacheModel( $"mdl/desertlands/construction_bldg_elevator_01_top.rmdl" )
	PrecacheModel( $"mdl/desertlands/construction_bldg_platform_01.rmdl" )
	PrecacheModel( $"mdl/desertlands/construction_bldg_platform_02.rmdl" )
	PrecacheModel( $"mdl/desertlands/construction_bldg_platform_03.rmdl" )
	PrecacheModel( $"mdl/desertlands/construction_bldg_platform_04_corner.rmdl" )
	PrecacheModel( $"mdl/desertlands/construction_bldg_wall_01.rmdl" )
	PrecacheModel( $"mdl/desertlands/construction_bldg_wood_board_01.rmdl" )
	PrecacheModel( $"mdl/desertlands/construction_fold_sign_01.rmdl" )
	PrecacheModel( $"mdl/desertlands/construction_stacker_cone_dirty_01.rmdl" )
	PrecacheModel( $"mdl/desertlands/curb_parking_concrete_destroyed_01.rmdl" )
	PrecacheModel( $"mdl/desertlands/desertlands_apartments_planter_02.rmdl" )
	PrecacheModel( $"mdl/desertlands/desertlands_apartments_rug_01.rmdl" )
	PrecacheModel( $"mdl/desertlands/desertlands_apartments_rug_02.rmdl" )
	PrecacheModel( $"mdl/desertlands/desertlands_barrier_concrete_128_01.rmdl" )
	PrecacheModel( $"mdl/desertlands/desertlands_building_ice_02.rmdl" )
	PrecacheModel( $"mdl/desertlands/desertlands_cafeteria_table_01.rmdl" )
	PrecacheModel( $"mdl/desertlands/desertlands_city_train_station_railing_02.rmdl" )
	PrecacheModel( $"mdl/desertlands/desertlands_lobby_double_doorframe_02.rmdl" )
	PrecacheModel( $"mdl/desertlands/desertlands_lobby_sign_01.rmdl" )
	PrecacheModel( $"mdl/desertlands/desertlands_train_station_sign_04.rmdl" )
	PrecacheModel( $"mdl/desertlands/desertlands_train_station_turnstile_01.rmdl" )
	PrecacheModel( $"mdl/desertlands/desertlands_train_track_magnetic_beam_01.rmdl" )
	PrecacheModel( $"mdl/desertlands/desertlands_train_track_sign_01.rmdl" )
	PrecacheModel( $"mdl/desertlands/desrtlands_icicles_06.rmdl" )
	PrecacheModel( $"mdl/desertlands/fence_large_concrete_metal_dirty_128_01.rmdl" )
	PrecacheModel( $"mdl/desertlands/fence_large_concrete_metal_dirty_192_01.rmdl" )
	PrecacheModel( $"mdl/desertlands/fence_large_concrete_metal_dirty_64_01.rmdl" )
	PrecacheModel( $"mdl/desertlands/highrise_rectangle_top_01.rmdl" )
	PrecacheModel( $"mdl/desertlands/highrise_square_top_01.rmdl" )
	PrecacheModel( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl" )
	PrecacheModel( $"mdl/desertlands/industrial_cargo_container_320_01_open.rmdl" )
	PrecacheModel( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl" )
	PrecacheModel( $"mdl/desertlands/industrial_cargo_container_small_02.rmdl" )
	PrecacheModel( $"mdl/desertlands/industrial_cargo_container_small_03.rmdl" )
	PrecacheModel( $"mdl/desertlands/industrial_support_beam_16x144_filler.rmdl" )
	PrecacheModel( $"mdl/desertlands/industrial_support_beam_16x144_vertical.rmdl" )
	PrecacheModel( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl" )
	PrecacheModel( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl" )
	PrecacheModel( $"mdl/desertlands/lightpole_desertlands_city_01.rmdl" )
	PrecacheModel( $"mdl/desertlands/wall_city_barred_concrete_192_01.rmdl" )
	PrecacheModel( $"mdl/desertlands/wall_city_corner_concrete_64_01.rmdl" )
	PrecacheModel( $"mdl/dev/editor_ref.rmdl" )
	PrecacheModel( $"mdl/canyonlands/octane_tt_screen_02.rmdl" )
	PrecacheModel( $"mdl/colony/farmland_crate_md_80x64x72_02.rmdl" )
	PrecacheModel( $"mdl/domestic/ac_unit_dirty_32x64_01_a.rmdl" )
	PrecacheModel( $"mdl/domestic/bar_sink.rmdl" )
	PrecacheModel( $"mdl/domestic/city_bench_dirty_blue.rmdl" )
	PrecacheModel( $"mdl/domestic/floor_rug_red.rmdl" )
	PrecacheModel( $"mdl/domestic/tv_LED_med_panel.rmdl" )
	PrecacheModel( $"mdl/firstgen/firstgen_pipe_128_goldfoil_01.rmdl" )
	PrecacheModel( $"mdl/firstgen/firstgen_pipe_256_darkcloth_01.rmdl" )
	PrecacheModel( $"mdl/foliage/grass_burnt_yellow_03.rmdl" )
	PrecacheModel( $"mdl/foliage/icelandic_moss_grass_01.rmdl" )
	PrecacheModel( $"mdl/foliage/icelandic_moss_grass_02.rmdl" )
	PrecacheModel( $"mdl/foliage/plant_desert_yucca_01.rmdl" )
	PrecacheModel( $"mdl/garbage/trash_can_metal_01_a.rmdl" )
	PrecacheModel( $"mdl/garbage/trash_can_metal_02_a.rmdl" )
	PrecacheModel( $"mdl/hud/grenade_indicator/grenade_indicator_arrow.rmdl" )
	PrecacheModel( $"mdl/humans/class/heavy/pilot_heavy_pathfinder.rmdl" )
	PrecacheModel( $"mdl/IMC_base/scaffold_tech_alpharail_128.rmdl" )
	PrecacheModel( $"mdl/industrial/exit_sign_03.rmdl" )
	PrecacheModel( $"mdl/industrial/landing_mat_metal_03_large.rmdl" )
	PrecacheModel( $"mdl/industrial/modular_railing_trim_long.rmdl" )
	PrecacheModel( $"mdl/industrial/screwdriver_octane.rmdl" )
	PrecacheModel( $"mdl/industrial/security_fence_post.rmdl" )
	PrecacheModel( $"mdl/industrial/underbelly_support_beam_256_01.rmdl" )
	PrecacheModel( $"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl" )
	PrecacheModel( $"mdl/industrial/vending_machine_02.rmdl" )
	PrecacheModel( $"mdl/industrial/vending_machine_05.rmdl" )
	PrecacheModel( $"mdl/industrial/vending_machine_06.rmdl" )
	PrecacheModel( $"mdl/industrial/zipline_arm.rmdl" )
	PrecacheModel( $"mdl/lamps/desertlands_lootbin_light_01.rmdl" )
	PrecacheModel( $"mdl/lamps/floor_standing_ambient_light.rmdl" )
	PrecacheModel( $"mdl/lamps/light_parking_post.rmdl" )
	PrecacheModel( $"mdl/levels_terrain/mp_rr_canyonlands/clands_roof_bars_01_fglass_blue.rmdl" )
	PrecacheModel( $"mdl/mendoko/mendoko_rubber_floor_01.rmdl" )
	PrecacheModel( $"mdl/ola/sewer_railing_01_128.rmdl" )
	PrecacheModel( $"mdl/ola/sewer_railing_01_64.rmdl" )
	PrecacheModel( $"mdl/ola/sewer_railing_01_corner_in.rmdl" )
	PrecacheModel( $"mdl/ola/sewer_railing_01_stairend.rmdl" )
	PrecacheModel( $"mdl/pipes/pipe_modular_painted_grey_128.rmdl" )
	PrecacheModel( $"mdl/pipes/pipe_modular_painted_grey_256.rmdl" )
	PrecacheModel( $"mdl/pipes/pipe_modular_painted_grey_32_tjunk.rmdl" )
	PrecacheModel( $"mdl/pipes/pipe_modular_painted_grey_32_valve.rmdl" )
	PrecacheModel( $"mdl/pipes/pipe_modular_painted_grey_64.rmdl" )
	PrecacheModel( $"mdl/pipes/pipe_modular_painted_grey_corner.rmdl" )
	PrecacheModel( $"mdl/pipes/slum_pipe_large_yellow_256_02.rmdl" )
	PrecacheModel( $"mdl/playback/playback_barstool_02.rmdl" )
	PrecacheModel( $"mdl/props/death_box/death_box_01_gladcard.rmdl" )
	PrecacheModel( $"mdl/props/lifeline_needle/lifeline_needle.rmdl" )
	PrecacheModel( $"mdl/props/octane_jump_pad/octane_jump_pad.rmdl" )
	PrecacheModel( $"mdl/props/zipline_balloon/zipline_balloon.rmdl" )
	PrecacheModel( $"mdl/robots/drone_frag/drone_frag_loot.rmdl" )
	PrecacheModel( $"mdl/robots/drone_frag/drone_frag_loot_bf.rmdl" )
	PrecacheModel( $"mdl/rocks/icelandic_rockcluster_02.rmdl" )
	PrecacheModel( $"mdl/rocks/rock_sharp_lava_moss_desertlands_02.rmdl" )
	PrecacheModel( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl" )
	PrecacheModel( $"mdl/signs/desertlands_city_newdawn_sign_01.rmdl" )
	PrecacheModel( $"mdl/signs/desertlands_city_streetsign_01.rmdl" )
	PrecacheModel( $"mdl/signs/numbers/sign_number_lit_1.rmdl" )
	PrecacheModel( $"mdl/signs/numbers/sign_number_lit_2.rmdl" )
	PrecacheModel( $"mdl/signs/numbers/sign_number_lit_3.rmdl" )
	PrecacheModel( $"mdl/signs/Sign_no_tresspasing.rmdl" )
	PrecacheModel( $"mdl/signs/street_sign_arrow.rmdl" )
	PrecacheModel( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl" )
	PrecacheModel( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl" )
	PrecacheModel( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl" )
	PrecacheModel( $"mdl/thunderdome/thunderdome_cage_ceiling_256x64_05.rmdl" )
	PrecacheModel( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl" )
	PrecacheModel( $"mdl/thunderdome/thunderdome_cage_wall_128x352_03.rmdl" )
	PrecacheModel( $"mdl/thunderdome/thunderdome_cage_wall_256x128_02.rmdl" )
	PrecacheModel( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl" )
	PrecacheModel( $"mdl/thunderdome/thunderdome_hanging_pilot_helmets_04.rmdl" )
	PrecacheModel( $"mdl/thunderdome/thunderdome_hanging_pilot_helmets_06.rmdl" )
	PrecacheModel( $"mdl/timeshift/timeshift_bench_01.rmdl" )
	PrecacheModel( $"mdl/weapons/bullets/damage_arrow.rmdl" )
	PrecacheModel( $"mdl/weapons_r5/misc_crypto_drone/crypto_logo_holo.rmdl" )
	PrecacheModel( $"mdl/garbage/garbage_bag_plastic_a.rmdl" )
}

struct {
  array < string > allTimes
}
file

//Save times to file
void
function MovementGymSaveTimesToFile() {
  DevTextBufferClear()
  DevTextBufferWrite("=== Movement Gym Times === \n\n")
  DevTextBufferWrite("=== OID == Player Name == Run Time == Map === \n")

  int i = 0
  foreach(line in file.allTimes) {
    DevTextBufferWrite(line + "\n")
    i++
  }

  DevP4Checkout("MovementGym_Results_" + GetUnixTimestamp() + ".txt")
  DevTextBufferDumpToFile("MovementGymLogs/MovementGym_Results_" + GetUnixTimestamp() + ".txt")

  Warning("[!] MOVEMENTGYM RESULTS SAVED IN /r5reloaded/platform/ === ")
  file.allTimes.clear()
  Warning("[!] allTimes array has been cleared === ")
}

void
function MovementGymSaveTimesToFile_thread() {
	while(FlowState_EnableMovementGymLogs()){
		wait 300
		MovementGymSaveTimesToFile()
	}
}

void
function _MG_OnPlayerConnected(entity player) {
	player.SetPlayerNetBool( "pingEnabled", false )
	player.AddToRealm(1)
	StatusEffect_StopAllOfType(player, eStatusEffect.stim_visual_effect)
	StatusEffect_StopAllOfType(player, eStatusEffect.speed_boost)
	TakeAllWeapons( player )
	TakeAllPassives( player )
	player.GiveOffhandWeapon("mp_ability_phase_walk", OFFHAND_TACTICAL)
	player.PhaseShiftCancel()
	Remote_CallFunction_NonReplay( player, "Cl_MovementGym_Init")
	
	if(Flowstate_MovementGym_ClassicMovement() && Flowstate_MovementGym_ClassicMovement_Type() == 3)
		thread _Classic_Movement_ABH(player)
	
    player.GiveWeapon( "mp_weapon_melee_survival", WEAPON_INVENTORY_SLOT_PRIMARY_2, [] )
    player.GiveOffhandWeapon( "melee_pilot_emptyhanded", OFFHAND_MELEE, [] )

	if( !player.HasPassive( ePassives.PAS_PILOT_BLOOD ) )
		GivePassive(player, ePassives.PAS_PILOT_BLOOD)

	EnableOffhandWeapons( player )
	DeployAndEnableWeapons( player )
	player.UnfreezeControlsOnServer()
	thread Flowstate_InitAFKThreadForPlayer(player)
}

//hub command
bool
function ClientCommand_Hub(entity user, array < string > args) {
  if( !IsValid(user) )
	return false

  if(Time() - user.p.lastHub < 3)
	return false

  EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
  TeleportFRPlayer(user, < 10726.9000, 10287, -4283 > , < 0, -89.9998, 0 > )
  StatusEffect_StopAllOfType(user, eStatusEffect.stim_visual_effect)
  StatusEffect_StopAllOfType(user, eStatusEffect.speed_boost)
  user.TakeOffhandWeapon(OFFHAND_TACTICAL)
  user.TakeOffhandWeapon(OFFHAND_ULTIMATE)
  user.GiveOffhandWeapon("mp_ability_phase_walk", OFFHAND_TACTICAL)
  user.PhaseShiftCancel()
  Message(user, "Hub")
  //Start Checkpoint
  user.p.allowCheckpoint = false
  user.p.currentCheckpoint = 0
  //Reset Timer
  Remote_CallFunction_NonReplay( user, "MG_StopWatch_toggle", false)
  user.p.isTimerActive = false
  user.p.startTime = 0

  //Re-enable invis after surf
  user.p.isPlayerInvisAllowed = true
  if (user.IsInRealm(1) == false) {
    user.RemoveFromAllRealms()
    user.AddToRealm(1)
    user.MakeVisible()
    Message(user, "You are now Visible")
    user.p.lastInvis = Time()
  }
  
  //Force Default Player Settings
  // SetPlayerSettings(user, TDM_PLAYER_SETTINGS)
  
  user.p.lastHub = Time()
  return true
}

//invis toggle command
bool
function ClientCommand_invis(entity user, array < string > args) {
  if( !IsValid(user) )
	return false

  if(Time() - user.p.lastInvis < 3)
	return false

  if (user.p.isPlayerInvisAllowed == true) {
    if (user.IsInRealm(1)) {
      user.RemoveFromAllRealms()
      user.AddToRealm(RandomIntRange(10, 63))
      user.MakeInvisible()
      user.HidePlayer()
      Message(user, "You are now Invisible")
      user.p.lastInvis = Time()
    } else {
      user.RemoveFromAllRealms()
      user.AddToRealm(1)
      user.MakeVisible()
      user.UnhidePlayer()
      Message(user, "You are now Visible")
      user.p.lastInvis = Time()
    }
  } else {
    Message(user, "This action is not allowed right now")
  }
  return true
}

////speedometer on/off
//bool
//function ClientCommand_meter(entity user, array < string > args) {
//  if( !IsValid(user) || args.len() == 0 )
//	return false
//  
//  if(args[0] == "off"){
//	if(user.p.speedometerVisible == true){
//		Remote_CallFunction_NonReplay( user, "MG_Speedometer_toggle", false)
//		user.p.speedometerVisible = false
//	}
//  }
//  
//  if(args[0] == "on"){
//	if(user.p.speedometerVisible == false){
//		Remote_CallFunction_NonReplay( user, "MG_Speedometer_toggle", true)
//		user.p.speedometerVisible = true
//	}
//  }
//  
//  return true
//}
//
//
////Movement Overlay on/off
//bool
//function ClientCommand_keys(entity user, array < string > args) {
//    if( !IsValid(user) || args.len() == 0 )
//	return false
//  
//  if(args[0] == "off"){
//	if(user.p.movementOverlayVisible == true){
//		Remote_CallFunction_NonReplay( user, "MG_MovementOverlay_toggle", false)
//		user.p.movementOverlayVisible = false
//	}
//  }
//  
//  if(args[0] == "on"){
//	if(user.p.movementOverlayVisible == false){
//		Remote_CallFunction_NonReplay( user, "MG_MovementOverlay_toggle", true)
//		user.p.movementOverlayVisible = true
//	}
//  }
//  return true
//}
//
////Stylemeter on/off
//bool
//function ClientCommand_style(entity user, array < string > args) {
//    if( !IsValid(user) || args.len() == 0 )
//	return false
//  
//  if(args[0] == "off"){
//	if(user.p.stylemeterVisible == true){
//		Remote_CallFunction_NonReplay( user, "MG_Ultrakill_styleemeter_toggle", false)
//		user.p.stylemeterVisible = false
//	}
//  }
//  
//  if(args[0] == "on"){
//	if(user.p.stylemeterVisible == false){
//		Remote_CallFunction_NonReplay( user, "MG_Ultrakill_styleemeter_toggle", true)
//		user.p.stylemeterVisible = true		
//	}
//  }
//  return true
//}


bool
function _MG_Spectate(entity player, array < string > name){
	
	if( !IsValid(player) )
		return false

	if( name.len() == 0 )
	{
		Message(player, "Incorrect Username", "")
		return false
	}

	bool doesNameExist = false
	foreach( sPlayer in GetPlayerArray() )
	{
		if( sPlayer.GetPlayerName() == name[0] )
		{
			doesNameExist = true
			break
		}
	}
	
	if( !doesNameExist )
	{
		Message(player, "Incorrect Username", "")
		return false
	}

	thread _MG_Spectate_by_name(player, name[0] )
	return true
}

void
function _MG_Spectate_by_name(entity player, string name){
	//if( !IsAdmin(player) ){
	//	Message(player, "Admin Only", "try logging in if you are a admin")
	//	return false
	//}
	
	if( Time() - player.p.lastTimeSpectateUsed < 3 )
	{
		Message( player, "Spam Protection", "It is in cool down. Please try again later." )
		return 
	}
	
	
	if(name == "stop"){
		if(IsValid(player) && player.p.isSpectating){
			player.p.isSpectating = false
			player.SetPlayerNetInt( "spectatorTargetCount", 0 )
			player.SetObserverTarget( null )
			player.StopObserverMode()
			player.p.lastTimeSpectateUsed = Time()
			DecideRespawnPlayer(player, true)
			if(IsValid(player)){
				player.RemoveFromAllRealms()
				player.AddToRealm(1)
			}
			return
		}
	}
	
	if(name != "stop" && player.GetPlayerName() != name && !player.p.isSpectating )
	{
		foreach(target in GetPlayerArray_Alive())
		{
			if ( !IsValid( target ) ) 
				continue
			
			if( !IsValid( player ) )
				return

			if( target.GetPlayerName() == name ){
					player.p.isSpectating = true
					player.Die( null, null, { damageSourceId = eDamageSourceId.damagedef_suicide } )
					player.SetPlayerNetInt( "spectatorTargetCount", 1 )
					player.SetObserverTarget( target )
					player.SetSpecReplayDelay( 5 )
					player.StartObserverMode( OBS_MODE_IN_EYE )
					player.p.lastTimeSpectateUsed = Time()
					
					while( IsValid( player ) )
					{
						if(!IsValid(target) || !target.IsInRealm(1))
						{
							player.p.isSpectating = false
							player.SetPlayerNetInt( "spectatorTargetCount", 0 )
							player.SetObserverTarget( null )
							player.StopObserverMode()
							player.p.lastTimeSpectateUsed = Time()
							DecideRespawnPlayer(player, true)
							StatusEffect_StopAllOfType(player, eStatusEffect.stim_visual_effect)
							StatusEffect_StopAllOfType(player, eStatusEffect.speed_boost)
							player.TakeOffhandWeapon(OFFHAND_TACTICAL)
							player.TakeOffhandWeapon(OFFHAND_ULTIMATE)
							player.GiveOffhandWeapon("mp_ability_phase_walk", OFFHAND_TACTICAL)
							player.PhaseShiftCancel()
							return
						}
						WaitFrame()
					}
			}	
		}	
	} else {
		Message(player, "Invalid Parameters", "Possible Reasons:\n wrong username\n you are already spectating someone\n unhide players\n exit surf\n ")
		return 
	}
	
	
	//if(name != "stop" && player.GetPlayerName() != name && !player.p.isSpectating && player.IsInRealm(1) && Time() - player.p.lastTimeSpectateUsed < 3){
	//	foreach(target in GetPlayerArray_Alive()) {
	//		if( target.GetPlayerName() == name ){
	//			player.AddToAllRealms()
	//			if(IsValid(target) && target.IsInRealm(1)){
	//				player.p.isSpectating = true
	//				player.Die( null, null, { damageSourceId = eDamageSourceId.damagedef_suicide } )
	//				player.SetPlayerNetInt( "spectatorTargetCount", 1 )
	//				player.SetObserverTarget( target )
	//				player.SetSpecReplayDelay( 5 )
	//				player.StartObserverMode( OBS_MODE_IN_EYE )
	//				player.p.lastTimeSpectateUsed = Time()
	//				//thread _MG_Spectate_checker(player, target)
	//				
	//				while(true){
	//					if(!IsValid(target))
	//					{
	//						player.p.isSpectating = false
	//						player.SetPlayerNetInt( "spectatorTargetCount", 0 )
	//						player.SetObserverTarget( null )
	//						player.StopObserverMode()
	//						player.p.lastTimeSpectateUsed = Time()
	//						DecideRespawnPlayer(player, true)
	//						if(IsValid(player)){
	//							player.RemoveFromAllRealms()
	//							player.AddToRealm(1)
	//						}
	//					}
	//				WaitFrame()
	//				}
	//				
	//				return
	//			} else {
	//				Message(player, "Player is hidden", "")
	//				player.RemoveFromAllRealms()
	//				player.AddToRealm(1)
	//				return 
	//			}
	//			
	//		} else {
	//			Message(player, "Invalid Player Name", "or player are already spectating someone")
	//			return 
	//		}	
	//	}	
	//} else {
	//	Message(player, "Invalid Parameters", "Possible Reasons:\n wrong username\n you are already spectating someone\n unhide players\n exit surf\n ")
	//	return 
	//}
	
	return 
}

//void
//function _MG_Spectate_checker( entity player, entity target){
//	
//	OnThreadEnd(
//		function() : ( player, target )
//		{
//			if( !IsValid(player) ) return
//			
//			if(!IsValid(target))
//			{
//				player.p.isSpectating = false
//				player.SetPlayerNetInt( "spectatorTargetCount", 0 )
//				player.SetObserverTarget( null )
//				player.StopObserverMode()
//				player.p.lastTimeSpectateUsed = Time()
//				DecideRespawnPlayer(player, true)
//				if(IsValid(player)){
//					player.RemoveFromAllRealms()
//					player.AddToRealm(1)
//				}
//			}
//		}
//	)
//	
//	while(IsValid(player) && player.IsObserver() && IsValid(target) )
//	{		
//		WaitFrame()
//	}
//	
//}

//whacky glowy button
entity
function CreateSurfButton(vector pos, vector ang, string prompt) {
  entity button = CreateEntity("prop_dynamic")
  button.kv.solid = 0
  button.SetValueForModelKey($"mdl/props/global_access_panel_button/global_access_panel_button_console_w_stand.rmdl")
  button.SetOrigin(pos)
  button.SetAngles(ang)
  DispatchSpawn(button)
  button.SetUsable()
  button.SetUsableByGroup("pilot")
  button.SetUsePrompts(prompt, prompt)
  button.Highlight_SetFunctions(0, 0, false, 136, 1.0, 2, false)
  button.Highlight_SetParam(0, 0, < 1.0, 1.0, 0 > )
  return button
}

//whacky fake button
entity
function Create_MG_Fake_Button(vector pos, vector ang, string prompt) {
  entity button = CreateEntity("prop_dynamic")
  button.kv.solid = 0
  button.SetValueForModelKey($"mdl/props/global_access_panel_button/global_access_panel_button_console_w_stand.rmdl")
  button.SetOrigin(pos)
  button.SetAngles(ang)
  DispatchSpawn(button)
  button.SetUsable()
  button.SetUsableByGroup("pilot")
  button.SetUsePrompts(prompt, prompt)
  button.MakeInvisible()
  return button
}

string function _MG_Convert_Sec_to_Time(int totalSeconds, bool showH = false) {
    string formattedTime
    local hours = totalSeconds / 3600
    local minutes = (totalSeconds % 3600) / 60
    local seconds = totalSeconds % 60

    switch (showH){
	case true:
		formattedTime = format("%02d:%02d:%02d",
			hours,
			minutes,
			seconds
		)
		break
	case false:
		formattedTime = format("%02d:%02d",
			minutes,
			seconds
		)
		break
    }
    
    return formattedTime
}


//╔╦╗╔═╗╔═╗  ╔═╗╔═╗╔═╗╔╦╗╔═╗╔╗╔╔╦╗╔═╗
//║║║╠═╣╠═╝  ╚═╗║╣ ║ ╦║║║║╣ ║║║ ║ ╚═╗
//╩ ╩╩ ╩╩    ╚═╝╚═╝╚═╝╩ ╩╚═╝╝╚╝ ╩ ╚═╝


//Offset for Teleporters after changing segment heights
vector tpoffset = < 0, 0, -20000 >

//Init Hub
void
function MovementGym_Hub() {
    // Props Array
    array < entity > NoClimbArray; array < entity > NoCollisionArray; 

    // Props
    MapEditor_CreateProp( $"mdl/desertlands/fence_large_concrete_metal_dirty_64_01.rmdl", < 10731.84, 9480.57, -4169.342 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/fence_large_concrete_metal_dirty_192_01.rmdl", < 10606.8, 9480.57, -4169.342 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/fence_large_concrete_metal_dirty_192_01.rmdl", < 10856.8, 9480.57, -4169.342 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_hanging_pilot_helmets_06.rmdl", < 10755.26, 9901.212, -3915.242 >, < 0, 0, 0 >, true, 50000, -1, 0.75 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_hanging_pilot_helmets_04.rmdl", < 10840.27, 9829.147, -3915.742 >, < 0, 0, 0 >, true, 50000, -1, 0.38 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 10731.04, 9487.999, -4050.001 >, < 0, -89.9998, 0 >, true, 5000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 10731.04, 10360, -4050.001 >, < 0, 90.0005, 0 >, true, 5000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 10948.96, 10144, -4050.001 >, < 0, 0, 0 >, true, 5000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 10515.04, 10144, -4050.001 >, < 0, -179.9997, 0 >, true, 5000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 10515.04, 9704.003, -4050.001 >, < 0, -179.9997, 0 >, true, 5000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 10948.96, 9704, -4050.001 >, < 0, 0, 0 >, true, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 10948.96, 10144, -4306 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 10948.96, 9704, -4306 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 10731.04, 9487.999, -4306 >, < 0, -89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 10515.04, 9704.003, -4306 >, < 0, -179.9997, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 10515.04, 10144, -4306 >, < 0, -179.9997, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 10731.04, 10360, -4306 >, < 0, 90.0005, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 10860.7, 10317.9, -3920.1 >, < 0, 0, 0 >, true, 50000, -1, 2 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_hanging_pilot_helmets_04.rmdl", < 10628.36, 10021.37, -3915.142 >, < 0, 0, 0 >, true, 50000, -1, 0.53 ) )
    MapEditor_CreateProp( $"mdl/desertlands/fence_large_concrete_metal_dirty_64_01.rmdl", < 10731.84, 10366.87, -4169.342 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/fence_large_concrete_metal_dirty_192_01.rmdl", < 10856.8, 10366.87, -4169.342 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/fence_large_concrete_metal_dirty_192_01.rmdl", < 10606.8, 10366.87, -4169.342 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/fence_large_concrete_metal_dirty_64_01.rmdl", < 10956.26, 10142.33, -4169.342 >, < 0, -89.9998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/fence_large_concrete_metal_dirty_192_01.rmdl", < 10956.26, 10267.37, -4169.342 >, < 0, -89.9998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/fence_large_concrete_metal_dirty_192_01.rmdl", < 10956.26, 10017.37, -4169.342 >, < 0, -89.9998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/fence_large_concrete_metal_dirty_64_01.rmdl", < 10956.26, 9705.232, -4169.342 >, < 0, -89.9998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/fence_large_concrete_metal_dirty_192_01.rmdl", < 10956.26, 9830.271, -4169.342 >, < 0, -89.9998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/fence_large_concrete_metal_dirty_192_01.rmdl", < 10956.26, 9580.271, -4169.342 >, < 0, -89.9998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/fence_large_concrete_metal_dirty_192_01.rmdl", < 10507.46, 9830.271, -4169.342 >, < 0, -89.9998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/fence_large_concrete_metal_dirty_64_01.rmdl", < 10507.46, 10142.33, -4169.342 >, < 0, -89.9998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/fence_large_concrete_metal_dirty_192_01.rmdl", < 10507.46, 10267.37, -4169.342 >, < 0, -89.9998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/fence_large_concrete_metal_dirty_192_01.rmdl", < 10507.46, 10017.37, -4169.342 >, < 0, -89.9998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/fence_large_concrete_metal_dirty_192_01.rmdl", < 10507.46, 9580.271, -4169.342 >, < 0, -89.9998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/fence_large_concrete_metal_dirty_64_01.rmdl", < 10507.46, 9705.232, -4169.342 >, < 0, -89.9998, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 10604.3, 10317.9, -3920.1 >, < 0, 0, 0 >, true, 50000, -1, 2 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 10860.7, 10056.4, -3920.1 >, < 0, 0, 0 >, true, 50000, -1, 2 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 10604.3, 10056.4, -3920.1 >, < 0, 0, 0 >, true, 50000, -1, 2 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 10860.7, 9795.101, -3920.1 >, < 0, 0, 0 >, true, 50000, -1, 2 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 10604.3, 9795.101, -3920.1 >, < 0, 0, 0 >, true, 50000, -1, 2 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 10860.7, 9533, -3920.1 >, < 0, 0, 0 >, true, 50000, -1, 2 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 10604.3, 9533, -3920.1 >, < 0, 0, 0 >, true, 50000, -1, 2 )

    foreach ( entity ent in NoClimbArray ) ent.kv.solid = 3
    foreach ( entity ent in NoCollisionArray ) ent.kv.solid = 0

    // Triggers
    entity trigger_0 = MapEditor_CreateTrigger( < 10730.36, 9677.57, -4168 >, < 0, 0, 0 >, 565.51, 149.5838, false )
    trigger_0.SetEnterCallback( void function(entity trigger , entity ent)
    {
          if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          array < ItemFlavor > characters = GetAllCharacters()
          CharacterSelect_AssignCharacter(ToEHI(ent), characters[4])

      //apply melee

        TakeAllWeapons(ent)
        ent.GiveWeapon("mp_weapon_melee_survival", WEAPON_INVENTORY_SLOT_PRIMARY_2, [])
        ent.GiveOffhandWeapon("melee_pilot_emptyhanded", OFFHAND_MELEE, [])

          ent.GiveOffhandWeapon("mp_ability_phase_walk", OFFHAND_TACTICAL)
          ent.SetPlayerNetBool("pingEnabled", false)
          // SetPlayerSettings(ent, TDM_PLAYER_SETTINGS)

		TakeAllPassives( ent )
		if( !ent.HasPassive( ePassives.PAS_PILOT_BLOOD ) )
			GivePassive(ent, ePassives.PAS_PILOT_BLOOD)

          //Start Checkpoint
          ent.p.allowCheckpoint = false
          ent.p.currentCheckpoint = 0

          //Reset Timer
          ent.p.isTimerActive = false
          ent.p.startTime = 0
	  
	  //Classic Source Movement
	  if(Flowstate_MovementGym_ClassicMovement() == true){
		_Classic_Movement(ent)
	  }

        }
      }
    })
    DispatchSpawn( trigger_0 )
    entity trigger_1 = MapEditor_CreateTrigger( < 10730.36, 10173.57, -4168 >, < 0, 0, 0 >, 373.9595, 149.5838, false )
    trigger_1.SetEnterCallback( void function(entity trigger , entity ent)
    {
          if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          array < ItemFlavor > characters = GetAllCharacters()
          CharacterSelect_AssignCharacter(ToEHI(ent), characters[4])

      //apply melee

        TakeAllWeapons(ent)
        ent.GiveWeapon("mp_weapon_melee_survival", WEAPON_INVENTORY_SLOT_PRIMARY_2, [])
        ent.GiveOffhandWeapon("melee_pilot_emptyhanded", OFFHAND_MELEE, [])

          ent.GiveOffhandWeapon("mp_ability_phase_walk", OFFHAND_TACTICAL)
          ent.SetPlayerNetBool("pingEnabled", false)
          // SetPlayerSettings(ent, TDM_PLAYER_SETTINGS)

		TakeAllPassives( ent )
		if( !ent.HasPassive( ePassives.PAS_PILOT_BLOOD ) )
			GivePassive(ent, ePassives.PAS_PILOT_BLOOD)

          //Start Checkpoint
          ent.p.allowCheckpoint = false
          ent.p.currentCheckpoint = 0

          //Reset Timer
          ent.p.isTimerActive = false
          ent.p.startTime = 0
	  
	  //Classic Source Movement
	  if(Flowstate_MovementGym_ClassicMovement() == true){
		_Classic_Movement(ent)
	  }

        }
      }
    })
    DispatchSpawn( trigger_1 )
}

//Hub Buttons
void
function MovementGym_Hub_Buttons() {
    // Buttons
    AddCallback_OnUseEntity( Create_MG_Fake_Button(< 10942.42, 9648.403, -4296.651 >, < 0, -89.9994, 0 >, "%use% Free Roam"), void function(entity panel, entity user, int input)
    {
	EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
	TeleportFRPlayer(user,< 9492, 5553.3, -3657 >,< 0, -89.9998, 0 >)
	Message(user, "Free Roam")
	//Start Checkpoint
	user.p.allowCheckpoint = false
	user.p.currentCheckpoint = 0
	//Reset Timer
	user.p.isTimerActive = false
	user.p.startTime = 0
    })

  // Buttons
  AddCallback_OnUseEntity(Create_MG_Fake_Button( < 10534.2, 10158.35, -4296.651 > , < 0, 90.0002, 0 > , "%use% Mantle Jump Practice "), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
      TeleportFRPlayer(user,< -2789.5070, 2607.6090, 41922.3500 > + tpoffset,< 0, -89.9998, 0 >)
      Message(user, "Mantle Jump Practice")
    })

  AddCallback_OnUseEntity(Create_MG_Fake_Button( < 10814.41, 9492.509, -4296.651 > , < 0, -179.9999, 0 > , "%use% Advanced Tap Strafe into Wall Jump"), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < 3391.9900, 2660.3000, 42441.2000 > +tpoffset, < 0, 89.9998, 0 > )
      Message(user, "Advanced Tap Strafe into Wall Jump")
    })

  AddCallback_OnUseEntity(Create_MG_Fake_Button( < 10730, 9492.509, -4296.651 > , < 0, -179.9999, 0 > , "%use% Superglide Practice"), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < -17280, 7718, 41940 > +tpoffset, < 0, 89.9998, 0 > )
      Message(user, "Superglide Practice")
    })

  AddCallback_OnUseEntity(Create_MG_Fake_Button( < 10649, 9492.506, -4296.651 > , < 0, -179.9999, 0 > , "%use% Sideways Superglide Practice"), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < -21670, 7550, 41938.3500 > +tpoffset, < 0, 89.9998, 0 > )
      Message(user, "Sideways Superglide Pracc")
    })

  AddCallback_OnUseEntity(Create_MG_Fake_Button( < 10569.16, 9492.509, -4296.651 > , < 0, -179.9999, 0 > , "%use% Backwards Superglide Practice"), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < -23694, 7550, 41938.3500 > +tpoffset, < 0, 89.9998, 0 > )
      Message(user, "Backwards Superglide Practice")
    })

  AddCallback_OnUseEntity(Create_MG_Fake_Button( < 10534.2, 10077.86, -4296.651 > , < 0, 90.0002, 0 > , "%use% Jump Pad Tap Strafes"), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < -2329.1000, 8714.7000, 41919.5000 > +tpoffset, < 0, 89.9998, 0 > )
      Message(user, "Jump Pad Tap Strafes")
    })

  AddCallback_OnUseEntity(Create_MG_Fake_Button( < 10896.9, 9492.509, -4296.651 > , < 0, -179.9999, 0 > , "%use% Basic Tap Strafe Practice"), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < -17280, 258.0005, 41940 > +tpoffset, < 0, 89.9998, 0 > )
      Message(user, "Tap Strafe Practice")

    })

  AddCallback_OnUseEntity(Create_MG_Fake_Button( < 10534.2, 9994.362, -4296.651 > , < 0, 90.0002, 0 > , "%use% Octane Stim Practice"), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < 9647, -963, 42441.2000 > +tpoffset, < 0, 89.9998, 0 > )
      Message(user, "Octane Stim Superglides", "\n  You now recieved Stim Tactical")
    })

  AddCallback_OnUseEntity(Create_MG_Fake_Button( < 10534.2, 9907.363, -4296.651 > , < 0, 90.0002, 0 > , "%use% Pathfinder Grapples"), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < -13561.7000, 26485.9000, -83.2000 > , < 0, 0, 0 > )
      array < ItemFlavor > characters = GetAllCharacters()
      CharacterSelect_AssignCharacter(ToEHI(user), characters[7])

      //apply melee

        TakeAllWeapons(user)
        user.GiveWeapon("mp_weapon_melee_survival", WEAPON_INVENTORY_SLOT_PRIMARY_2, [])
        user.GiveOffhandWeapon("melee_pilot_emptyhanded", OFFHAND_MELEE, [])

		TakeAllPassives( user )
		if( !user.HasPassive( ePassives.PAS_PILOT_BLOOD ) )
			GivePassive(user, ePassives.PAS_PILOT_BLOOD)

      user.SetPlayerNetBool("pingEnabled", false)
      Message(user, "Pathfinder Grapples", "You now recieved Grapple Tactical")
    })

}

void
function MovementGym_Map1_Button(){
//Button	
  AddCallback_OnUseEntity(Create_MG_Fake_Button( < 10942.42, 10011.12, -4296.651 > , < 0, -89.9994, 0 > , "%use% Map 1 by TreeRee & JayTheYggdrasil"), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < 6961, 1147.7710, -1453 > , < 0, -89.9998, 0 > )
      Message(user, "Map 1 by TREEREE")
      //Start Checkpoint
      user.p.allowCheckpoint = true
      user.p.currentCheckpoint = 1
      //Reset Timer
      user.p.isTimerActive = false
      user.p.startTime = 0
    })	
	
}

void
function MovementGym_Map2_Button(){
//Button	
  AddCallback_OnUseEntity(Create_MG_Fake_Button( < 10942.42, 9923.115, -4296.652 > , < 0, -89.9994, 0 > , "%use% Map 2 by Dzajko & DEAFPS"), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < 19500.3000, -25867.7000, 21940 > , < 0, 90, 0 > )
      array < ItemFlavor > characters = GetAllCharacters()
      CharacterSelect_AssignCharacter(ToEHI(user), characters[7])

            //apply melee

        TakeAllWeapons(user)
        user.GiveWeapon("mp_weapon_melee_survival", WEAPON_INVENTORY_SLOT_PRIMARY_2, [])
        user.GiveOffhandWeapon("melee_pilot_emptyhanded", OFFHAND_MELEE, [])

		TakeAllPassives( user )
		if( !user.HasPassive( ePassives.PAS_PILOT_BLOOD ) )
			GivePassive(user, ePassives.PAS_PILOT_BLOOD)
	
      user.SetPlayerNetBool("pingEnabled", false)
      Message(user, "Map 2 by DEAFPS")
      //Start Checkpoint
      user.p.allowCheckpoint = true
      user.p.currentCheckpoint = 1
      //Reset Timer
      user.p.isTimerActive = false
      user.p.startTime = 0
    })
	
}

//void
//function MovementGym_Surf_Button(){
////Button	
//  AddCallback_OnUseEntity(Create_MG_Fake_Button( < 10942.42, 9832.81, -4296.652 > , < 0, -89.9994, 0 > , "%use% Surf Kitsune by DEAFPS"), void
//    function (entity panel, entity user, int input) {
//      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
//      TeleportFRPlayer(user, < -38602.13, -10078.1, 21493.38 > , < 0, 0, 0 > )
//
//      Message(user, "Surf Kitsune by DEAFPS")
//
//      //Start Checkpoint
//      int checkpointInThisTrigger = 3
//      user.p.allowCheckpoint = true
//      //set checkpoint
//      user.p.currentCheckpoint = checkpointInThisTrigger
//
//      //Reset Timer
//      user.p.isTimerActive = false
//      user.p.startTime = 0
//
//      //change realm and lock invis
//      user.RemoveFromAllRealms()
//      user.AddToRealm(checkpointInThisTrigger)
//      user.p.isPlayerInvisAllowed = false
//
//      array < ItemFlavor > characters = GetAllCharacters()
//      CharacterSelect_AssignCharacter(ToEHI(user), characters[8])
//      TakeAllWeapons(user)
//      SetPlayerSettings(user, SURF_SETTINGS)
//    })
//	
//}

void
function MovementGym_Map3_Button(){

//Button	
  AddCallback_OnUseEntity(Create_MG_Fake_Button( < 10942.42, 9832.81, -4296.652 > , < 0, -89.9994, 0 > , "%use% Map 3 by LoyTakian"), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < -6130.526, 19524, 23766.6 > , < 0, 90, 0 > )
      array < ItemFlavor > characters = GetAllCharacters()
      CharacterSelect_AssignCharacter(ToEHI(user), characters[7])

      //apply melee and take abilities
      TakeAllWeapons(user)
      user.GiveWeapon("mp_weapon_melee_survival", WEAPON_INVENTORY_SLOT_PRIMARY_2, [])
      user.GiveOffhandWeapon("melee_pilot_emptyhanded", OFFHAND_MELEE, [])

	TakeAllPassives( user )
	if( !user.HasPassive( ePassives.PAS_PILOT_BLOOD ) )
		GivePassive(user, ePassives.PAS_PILOT_BLOOD)	

      user.SetPlayerNetBool("pingEnabled", false)
      Message(user, "Map 3 by LoyTakian")
      //Start Checkpoint
      user.p.allowCheckpoint = true
      user.p.currentCheckpoint = 1
      //Reset Timer
      user.p.isTimerActive = false
      user.p.startTime = 0
    })
	
}

//Init Map1 Treeree
void
function MovementGym_Map1() {
    // Props
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 6602.5, 1156.57, -1344.42 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_small_02.rmdl", < 3394.6, 1152.7, -722 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 4735.015, 1152.98, -704.201 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3274, 1142.8, -840.8 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 3400, 2128, -1032 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_small_03.rmdl", < 6852.8, 1141.3, -1059.4 >, < 0, -179.9999, 90 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 3263.9, 6528.61, -1216.79 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 5640.101, 1274.4, -1095.5 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 6396.507, 1152.98, -704.201 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3274.001, 1583.499, -1350.6 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6085.001, 1274.399, -1223 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 4100.996, 1220, -1072.2 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3843.4, 1038, -967.6 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3394.499, 2599, -569.7487 >, < -90, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3394.499, 2086.3, -705.9991 >, < -90, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 3792.875, 8255.9, -1145.547 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 5627.4, 1038.4, -712.9 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3843.4, 1038.4, -840.3 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 3520, 6656, -1216 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 3391.99, 3133, -692.065 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 4160, 8448, -960 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3507.8, 2599, -832.3495 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3521.599, 2599, -569.7486 >, < -90, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 6143.492, 1152.98, -704.193 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4301, 1273.999, -713.4 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4291.899, 1038.4, -712.9 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4747, 1273.999, -840.8 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 3391.03, 7808.16, -959.811 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3507.8, 2086.3, -968.5999 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/wall_city_corner_concrete_64_01.rmdl", < 3136.46, 6528.86, -1216.21 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6518.3, 1038.4, -840.3 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 3392, 2560, -640 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 7125.999, 1265.3, -802.2 >, < 0, -180, 90 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3018.999, 4922, -1281.35 >, < 0, 179.9997, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3250.5, 6614, -1320.001 >, < 90, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6992.1, 1164.998, -802.2 >, < 0, 0.0002, 90 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 4992.507, 1152.98, -704.201 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6797.798, 1021.001, -1299 >, < 0, -179.9998, 90 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4734.299, 1038, -967.6 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3640.001, 5827, -1027.75 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3843.4, 1038, -1095 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6085.001, 1274, -840.7999 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_small_03.rmdl", < 6852.8, 1013.8, -1059.4 >, < 0, -179.9999, 90 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 6268.507, 1152.98, -704.201 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 7125.999, 1265.3, -1242 >, < 0, -180, 90 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4747, 1274, -713.4 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 5194.101, 1274.398, -1223 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6527.401, 1274.001, -713.3999 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 3136, 7040, -1152 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 6015.492, 1152.98, -704.193 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3507.8, 1498.599, -713.8999 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3018.999, 4922, -899.3495 >, < 0, 179.9997, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 7118.001, 1046.5, -1242 >, < 0, 0, 90 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 5376.478, 1152.98, -704.193 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3401, 1038, -1095 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 3520.06, 6527.05, -960.295 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 4736.507, 1152.98, -704.201 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3507.8, 1498.6, -841.3 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6527.4, 1274.4, -1350.1 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3401, 1038, -1222.5 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_support_beam_16x144_vertical.rmdl", < 3264.81, 2239.84, -1024.56 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 3328, 5312, -896 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3267, 2086.3, -968.5999 >, < 0, -179.9999, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 4607.015, 1152.98, -704.201 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_train_station_railing_02.rmdl", < 3775.99, 1023.02, -704.184 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3843.4, 1038, -1222.5 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3018.999, 4922, -644.6495 >, < 0, 179.9997, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4747, 1274.399, -1223 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3507.8, 2599, -1214.35 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3273.599, 1142.8, -968.0999 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4291.899, 1038, -1349.6 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6072.3, 1038, -1095 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3356.2, 6063, -1148.349 >, < 0, 180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3701.001, 4159, -700 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3356.2, 6063, -1530.35 >, < 0, 180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 3264.06, 6527.02, -960.188 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 5640.101, 1273.999, -840.8 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6518.3, 1038, -1095 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4291.899, 1038, -1095 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 5640.101, 1274.399, -1223 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 4544.97, 8895.77, -640.076 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 5185, 1038.4, -712.9 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 3712, 1152.98, -704.201 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 4223.97, 1152.98, -704.193 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3274, 1583.5, -968.5999 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 3584, 1152.98, -704.201 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 5825.4, 1156.4, -1088 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 3392, 1152, -1024 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3507.8, 2086.3, -1223.5 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 6652.507, 1152.98, -704.201 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3356.2, 6063, -1275.75 >, < 0, 180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6797.799, 1149.002, -1299 >, < 0, -179.9998, 90 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 5185, 1038, -1222.5 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 5140, 9152, -704 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 7041.4, 1156.4, -1216 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 3392.95, 7104.01, -1407.68 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3640.001, 5827, -645.6495 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3701.001, 4159, -572.5999 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6863.3, 1269.301, -1242 >, < 0, 90.0002, 90 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3386.05, 2558.551, -879.4496 >, < 90, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 3840, 1152.98, -704.201 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3507.8, 2086.3, -1096 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 5119.93, 959.139, -1344.5 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.04, 3417.89, -651.2494 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 5640.1, 1274.399, -1350.1 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3860.9, 1273.999, -713.4 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6085.001, 1274, -713.3998 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6735.3, 1269.3, -1242 >, < 0, 90.0002, 90 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3860.9, 1274.398, -1095.5 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 3392.06, 2687.03, -832.231 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.039, 3071.95, -759.5032 >, < 0, -90, 179.9997 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/curb_parking_concrete_destroyed_01.rmdl", < 3455.22, 6528.52, -1216.33 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3273.6, 1142.8, -1223 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 6721.4, 1156.4, -1088 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6072.3, 1038, -1222.5 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 3386.8, 2244, -959.212 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 3519.92, 6528.49, -1216.87 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4291.899, 1038.4, -840.3 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 5640.101, 1274.4, -968.1 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.04, 2943.73, -767.887 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 5627.4, 1038.4, -840.3 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 7253.999, 1265.3, -802.2 >, < 0, -180, 90 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_support_beam_16x144_vertical.rmdl", < 6848.68, 1284.93, -1472.44 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 4416, 1152, -1280 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 7118.001, 1046.5, -802.2 >, < 0, 0, 90 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 4927.7, 1152.4, -1280 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3267, 2599, -577.6495 >, < 0, -179.9999, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 4095.97, 1152.98, -704.193 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3386.049, 2431.45, -879.4496 >, < 90, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 5627.4, 1038, -1349.6 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6072.3, 1038, -1349.6 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 5185, 1038, -1349.6 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 3791.125, 8256.11, -890.1671 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4734.299, 1038, -1095 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3860.9, 1274.398, -1350.1 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3521.599, 2086.3, -705.999 >, < -90, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3267, 2599, -1087.25 >, < 0, -179.9999, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 5627.4, 1038, -967.6 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.039, 2943.73, -759.8892 >, < 0, -90, 179.9997 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_train_station_railing_02.rmdl", < 4160.01, 1280.66, -704.753 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6879.298, 1042.5, -802.2 >, < 0, -89.9998, 90 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4301, 1274.399, -968.1001 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6863.3, 1269.3, -802.2 >, < 0, 90.0002, 90 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 5183.98, 9215, -959.98 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 6524.507, 1152.98, -704.201 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_train_station_railing_02.rmdl", < 3904, 1280.65, -704.758 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 6657.28, 1027.5, -1088.42 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 4990.984, 1152.98, -704.193 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_small_02.rmdl", < 3519.67, 1152.7, -722 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 4862.984, 1152.98, -704.193 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4301, 1274.398, -1095.5 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 5194.101, 1273.999, -840.8 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3267, 2599, -832.3495 >, < 0, -179.9999, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 5627.4, 1038, -1095 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 3712, 7744, -1024 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3640.001, 5827, -1282.35 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6879.298, 1042.5, -1242 >, < 0, -89.9998, 90 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6085, 1274.4, -968.0999 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4291.899, 1038, -967.6 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3018.999, 4922, -772.0496 >, < 0, 179.9997, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_support_beam_16x144_vertical.rmdl", < 3264.97, 2239.78, -895.903 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3507.8, 2599, -1087.25 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 3264, 6656, -1216 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 4672, 1152, -1280 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 4351.015, 1152.98, -704.201 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3377.6, 6614, -1320.001 >, < 90, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3018.999, 4922, -1154.25 >, < 0, 179.9997, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3640.001, 5827, -773.0496 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3267, 2599, -705.0496 >, < 0, -179.9999, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3507.8, 2599, -959.7496 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3274.401, 1583.5, -841.3 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 5194.101, 1274.399, -968.1001 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 5248.478, 1152.98, -704.193 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 5183.85, 9088.65, -960.748 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3273.6, 1142.799, -1350.1 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6990.001, 1046.5, -802.2 >, < 0, 0, 90 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6072.3, 1038.4, -712.9 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/wall_city_barred_concrete_192_01.rmdl", < 3135, 6655.96, -1216.06 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6072.3, 1038.4, -840.3 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/wall_city_corner_concrete_64_01.rmdl", < 3647.16, 6528.18, -1216.51 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_train_station_railing_02.rmdl", < 3776.04, 1280.65, -704.763 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3508.2, 1498.6, -1096 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4301, 1274.398, -1350.1 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 3392, 7040, -1152 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3356.2, 6063, -1021.05 >, < 0, 180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3267, 2086.3, -1223.5 >, < 0, -179.9999, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 6721.4, 1156.4, -1344 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3273.599, 1142.8, -1095.5 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.039, 3417.89, -643.2516 >, < 0, -90, 179.9997 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3860.9, 1274.399, -968.1001 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 5194.101, 1273.999, -713.4 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_train_station_railing_02.rmdl", < 3903.96, 1023.02, -704.196 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 7253.999, 1265.301, -1242 >, < 0, -180, 90 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3507.8, 2599, -577.6495 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 5759.522, 1152.98, -704.201 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.039, 3546.11, -642.8655 >, < 0, -90, 179.9997 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3640.001, 5827, -1155.25 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6527.4, 1274.4, -968.1 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 5185, 1038, -967.6 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 4351.01, 8896.15, -896.07 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 5194.101, 1274.398, -1350.1 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.04, 3071.95, -768.273 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3401, 1038.4, -840.3 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 6657.5, 1283.43, -1344.21 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3267, 2086.3, -841.3 >, < 0, -179.9999, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3267, 2086.3, -1096 >, < 0, -179.9999, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3508.2, 1498.6, -968.5999 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3356.2, 6063, -893.6495 >, < 0, 180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4291.899, 1038, -1222.5 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6992.101, 1292.998, -1242 >, < 0, 0.0002, 90 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 5120.507, 1152.98, -704.201 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/wall_city_corner_concrete_64_01.rmdl", < 3648.46, 6783.39, -1216.64 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 5627.4, 1038, -1222.5 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3701.001, 4159, -827.5 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6085.001, 1274.399, -1350.1 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4301, 1274.398, -1223 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 5194.101, 1274.398, -1095.5 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3356.2, 6063, -1403.25 >, < 0, 180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 5395, 9152, -704 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6518.3, 1038.4, -712.9 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 4101.005, 1091.77, -1071.99 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6518.3, 1038, -967.6 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3273.999, 1142.801, -713.3999 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 6913.4, 1156.4, -1472 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4301, 1273.999, -840.8 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_train_station_railing_02.rmdl", < 4287.95, 1023.04, -704.286 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3843.4, 1038, -1349.6 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 5185, 1038, -1095 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3508.2, 1498.599, -1223.5 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4734.299, 1038.4, -840.3 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 3392, 7296, -1152 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 7007.298, 1042.5, -1242 >, < 0, -89.9998, 90 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6992.101, 1292.998, -802.2 >, < 0, 0.0002, 90 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 4672, 9152, -832 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 4195.9, 1152, -1089.9 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 5640.101, 1274, -713.4 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 6780.478, 1152.98, -704.193 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3701.001, 4159, -954.6 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_train_station_railing_02.rmdl", < 3648.02, 1023.3, -704.71 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.04, 3546.11, -651.6354 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3401, 1038.4, -712.9 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3250.5, 2086.3, -1015.7 >, < 90, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3267, 2086.3, -713.8999 >, < 0, -179.9999, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3507.8, 2086.3, -1350.6 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 3520.97, 2560.06, -896.235 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 4544.94, 8896.05, -896.35 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6527.401, 1274.001, -840.8 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_train_station_railing_02.rmdl", < 4032, 1280.65, -704.756 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 6337.4, 1156.4, -1088 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3401, 1038, -967.6 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 5503.522, 1152.98, -704.201 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3274.4, 1583.501, -713.8999 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3274, 1583.5, -1096 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3640.001, 5827, -900.3495 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 3968, 1152.98, -704.201 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/wall_city_corner_concrete_64_01.rmdl", < 3136.92, 6784.01, -1216.39 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4734.299, 1038.4, -712.9 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 3392.92, 7808.22, -1216.31 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3507.8, 2086.3, -841.3 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 5887.522, 1152.98, -704.201 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3860.9, 1274.398, -1223 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3860.9, 1273.999, -840.8 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3507.8, 2086.3, -713.8999 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4734.299, 1038, -1222.5 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6085.001, 1274.399, -1095.5 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/wall_city_barred_concrete_192_01.rmdl", < 3648.97, 6656.02, -1216.23 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6527.4, 1274.4, -1095.5 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 7007.298, 1042.5, -802.2 >, < 0, -89.9998, 90 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4747, 1274.4, -1095.5 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4747, 1274.4, -968.1 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6072.3, 1038, -967.6 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3377.6, 2086.3, -1015.7 >, < 90, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6992.101, 1164.998, -1242 >, < 0, 0.0002, 90 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3701.001, 4159, -445.3 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6735.299, 1269.3, -802.2 >, < 0, 90.0002, 90 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3267, 2599, -1214.35 >, < 0, -179.9999, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6990.001, 1046.5, -1242 >, < 0, 0, 90 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 4864.507, 1152.98, -704.201 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 5631.522, 1152.98, -704.201 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3274, 1583.5, -1223.5 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_train_station_railing_02.rmdl", < 4159.94, 1023.02, -704.21 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6518.3, 1038, -1349.6 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 4351.07, 8895.99, -1152.36 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_window_frame_ceiling_curved_01.rmdl", < 4479.015, 1152.98, -704.201 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 3392, 4480, -768 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3508.199, 1498.6, -1350.6 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_train_station_railing_02.rmdl", < 4031.94, 1023.02, -704.21 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_support_beam_16x144_vertical.rmdl", < 3520.92, 2239.66, -1024.2 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 4287, 1151.95, -1343.99 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3401, 1038, -1349.6 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_train_station_railing_02.rmdl", < 3519.85, 1280.64, -704.754 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 3843.4, 1038.4, -712.9 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4746.999, 1274.399, -1350.1 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3018.999, 4922, -1026.75 >, < 0, 179.9997, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 5888.02, 960.986, -1344.17 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6527.4, 1274.4, -1223 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4734.299, 1038, -1349.6 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 6518.3, 1038, -1222.5 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 3648, 7040, -1152 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3507.8, 2599, -705.0496 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 5185, 1038.4, -840.3 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3267, 2086.3, -1350.6 >, < 0, -179.9999, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_train_station_railing_02.rmdl", < 3648, 1280.64, -704.77 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3267, 2599, -959.7496 >, < 0, -179.9999, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_support_beam_16x144_vertical.rmdl", < 6849.98, 1027.849, -1472.6 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 3392.58, 3712.07, -643.0634 >, < 0, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4568.001, 1160, -1098 >, < 0, 0.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 4452, 1368, -1089.9 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 4452, 944.0005, -1089.9 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4807.999, 1160, -953.9996 >, < 0.0003, 179.9998, 180 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4568.001, 1160, -973.9999 >, < 0, 0.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4807.999, 1160, -829.9999 >, < 0.0003, 179.9998, 180 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4807.999, 1160, -704 >, < 0.0003, 179.9998, 180 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4568.001, 1160, -847.9999 >, < 0, 0.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3122.5, 6614, -1320.001 >, < 90, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3505.1, 6614, -1320.001 >, < 90, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3356.2, 6063, -767.7 >, < 0, 180, 0 >, true, 5000, -1, 1 )

    // Buttons
    AddCallback_OnUseEntity( CreateFRButton(< 5500.9, 9208.609, -688.353 >, < 0, -89.9998, 0 >, "%use% Back to start"), void function(entity panel, entity user, int input)
    {
	EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
	TeleportFRPlayer(user,< 6961, 1147.7710, -1453 >,< 0, -89.9998, 0 >)
	user.p.isTimerActive = false
	user.p.startTime = 0
	user.p.currentCheckpoint = 1
	Remote_CallFunction_NonReplay( user, "MG_StopWatch_toggle", false)

    })

    AddCallback_OnUseEntity( CreateFRButton(< 5500.9, 9096.609, -688.353 >, < 0, -89.9998, 0 >, "%use% Back to Hub"), void function(entity panel, entity user, int input)
    {
	EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
	TeleportFRPlayer(user,< 10726.9000, 10287, -4283 >,< 0, -89.9998, 0 >)
	Message(user, "Hub")
	user.p.isTimerActive = false
	user.p.startTime = 0
	user.p.allowCheckpoint = false
	Remote_CallFunction_NonReplay( user, "MG_StopWatch_toggle", false)
    })

    AddCallback_OnUseEntity( CreateFRButton(< 6900.8, 1258.493, -1457 >, < 0, 0, 0 >, "%use% Back to Hub"), void function(entity panel, entity user, int input)
    {
	EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
	TeleportFRPlayer(user,< 10726.9000, 10287, -4283 >,< 0, -89.9998, 0 >)
	Message(user, "Hub")
	user.p.isTimerActive = false
	user.p.startTime = 0
	user.p.allowCheckpoint = false
	Remote_CallFunction_NonReplay( user, "MG_StopWatch_toggle", false)
    })

    AddCallback_OnUseEntity( CreateFRButton(< 6902.018, 1045, -1457 >, < 0, 179.9997, 0 >, "%use% Start Timer"), void function(entity panel, entity user, int input)
    {
	//Start Timer Button
	user.p.isTimerActive = true
	user.p.startTime = floor( Time() ).tointeger()
	Remote_CallFunction_NonReplay( user, "MG_StopWatch_toggle", false)
	Remote_CallFunction_NonReplay( user, "MG_StopWatch_toggle", true)
	Message(user, "Timer Started!" )
    })

    AddCallback_OnUseEntity( CreateFRButton(< 5330, 9154.7, -688.353 >, < 0, -89.9998, 0 >, "%use% Stop Timer"), void function(entity panel, entity user, int input)
    {
     //Stop timer Button
      if (user.p.isTimerActive == true) {
        user.p.finalTime = floor( Time() ).tointeger() - user.p.startTime
        
	int seconds = user.p.finalTime
        
	//Display player Time
	Message(user, "Your Final Time: " + _MG_Convert_Sec_to_Time(seconds))
	
	//Add to results file
	string finalTime = user.GetPlatformUID()+ "|" + user.GetPlayerName() + "|" + _MG_Convert_Sec_to_Time(seconds) + "|" + GetUnixTimestamp() + "|Map1"
	file.allTimes.append(finalTime)
	
	//Reset Timer
	user.p.isTimerActive = false
	user.p.startTime = 0
	
	Remote_CallFunction_NonReplay( user, "MG_StopWatch_toggle", false)
	
	//Send time to killfeed and update WORLDRUI
	if(user.IsInRealm(1)){
		foreach(entity sPlayer in GetPlayerArray()){
			if(sPlayer.IsInRealm(1)){
				Remote_CallFunction_NonReplay( sPlayer, "MG_StopWatch_Obituary", seconds, user, 1)
			}
		}
	}
	  
}
    })


    // Triggers
    entity trigger_0 = MapEditor_CreateTrigger( < 4773, 4876, -1777 >, < 0, 0, 0 >, 12633, 50, false )
    trigger_0.SetEnterCallback( void function(entity trigger , entity ent)
    {
    //Big ahh trigger
      if (IsValid(ent)) {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
          if (ent.p.allowCheckpoint == true) {
            switch (ent.p.currentCheckpoint) {
              // Checkpoint 1
            case 1:
              ent.SetOrigin( < 6767.9240, 1149.2000, -1025.2000 > )
              ent.SetAngles( < 0, 180, 0 > )
              ent.SetVelocity( < 0, 0, 0 > )
              break

              // Checkpoint 2
            case 2:
              ent.SetOrigin( < 4217.1000, 1149.1000, -1074.6510 > )
              ent.SetAngles( < 0, 180, 0 > )
              ent.SetVelocity( < 0, 0, 0 > )
              break

              // Checkpoint 3
            case 3:
              ent.SetOrigin( < 3380, 1139.7720, -1008 > )
              ent.SetAngles( < 0, 90, 0 > )
              ent.SetVelocity( < 0, 0, 0 > )
              break

              // Checkpoint 4
            case 4:
              ent.SetOrigin( < 3380, 1966, -1008 > )
              ent.SetAngles( < 0, 90, 0 > )
              ent.SetVelocity( < 0, 0, 0 > )
              break

              // Checkpoint 5
            case 5:
              ent.SetOrigin( < 3380.2, 3714, -598.1504 > )
              ent.SetAngles( < 0, 90, 0 > )
              ent.SetVelocity( < 0, 0, 0 > )
              break

              // Checkpoint 6
            case 6:
              ent.SetOrigin( < 3380, 4406, -753.9995 > )
              ent.SetAngles( < 0, 90, 0 > )
              ent.SetVelocity( < 0, 0, 0 > )
              break

              // Checkpoint 7
            case 7:
              ent.SetOrigin( < 3348, 5222, -882.9995 > )
              ent.SetAngles( < 0, 90, 0 > )
              ent.SetVelocity( < 0, 0, 0 > )
              break

              // Checkpoint 8
            case 8:
              ent.SetOrigin( < 3250.5000, 6614, -1218.0010 > )
              ent.SetAngles( < 0, 90, 0 > )
              ent.SetVelocity( < 0, 0, 0 > )
              break

              // Checkpoint 9
            case 9:
              ent.SetOrigin( < 3381, 7335, -1137 > )
              ent.SetAngles( < 0, 90, 0 > )
              ent.SetVelocity( < 0, 0, 0 > )
              break

              // Checkpoint 10
            case 10:
              ent.SetOrigin( < 3723, 7739, -1006 > )
              ent.SetAngles( < 0, 90, 0 > )
              ent.SetVelocity( < 0, 0, 0 > )
              break

              // Checkpoint 11
            case 11:
              ent.SetOrigin( < 4162, 8476, -942.9995 > )
              ent.SetAngles( < 0, 90, 0 > )
              ent.SetVelocity( < 0, 0, 0 > )
              break

              // Checkpoint 12
            case 12:
              ent.SetOrigin( < 4658, 9149, -811.9995 > )
              ent.SetAngles( < 0, 90, 0 > )
              ent.SetVelocity( < 0, 0, 0 > )
              break
            }
          }
        }
      }
    })
    DispatchSpawn( trigger_0 )
    entity trigger_1 = MapEditor_CreateTrigger( < 4156.423, 1163.8, -1062.494 >, < 0, 0, 0 >, 129.9, 29.41697, false )
    trigger_1.SetEnterCallback( void function(entity trigger , entity ent)
    {
    //set Checkpoint and shot timer
if (IsValid(ent)){
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){
		int checkpointInThisTrigger = 2
		
		//show checkpoint msg
		if(ent.p.currentCheckpoint != checkpointInThisTrigger)
			Remote_CallFunction_NonReplay( ent, "MG_Checkpoint_Msg")
		
		//set checkpoint
		ent.p.currentCheckpoint = checkpointInThisTrigger
        }
}
    })
    DispatchSpawn( trigger_1 )
    entity trigger_2 = MapEditor_CreateTrigger( < 3380.2, 1163.8, -993.7 >, < 0, 0, 0 >, 147.0848, 29.41697, false )
    trigger_2.SetEnterCallback( void function(entity trigger , entity ent)
    {
    //set Checkpoint and shot timer
if (IsValid(ent)){
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){
		int checkpointInThisTrigger = 3
		//show checkpoint msg
		if(ent.p.currentCheckpoint != checkpointInThisTrigger)
			Remote_CallFunction_NonReplay( ent, "MG_Checkpoint_Msg")
		
		//set checkpoint
		ent.p.currentCheckpoint = checkpointInThisTrigger
        }
}
    })
    DispatchSpawn( trigger_2 )
    entity trigger_3 = MapEditor_CreateTrigger( < 3380.2, 2079.9, -993.7 >, < 0, 0, 0 >, 147.0848, 29.41697, false )
    trigger_3.SetEnterCallback( void function(entity trigger , entity ent)
    {
    //set Checkpoint and shot timer
if (IsValid(ent)){
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){
		int checkpointInThisTrigger = 4
		//show checkpoint msg
		if(ent.p.currentCheckpoint != checkpointInThisTrigger)
			Remote_CallFunction_NonReplay( ent, "MG_Checkpoint_Msg")
		
		//set checkpoint
		ent.p.currentCheckpoint = checkpointInThisTrigger
        }
}
    })
    DispatchSpawn( trigger_3 )
    entity trigger_4 = MapEditor_CreateTrigger( < 6351.3, 1163.8, -1056 >, < 0, 0, 0 >, 147.0848, 29.41697, false )
    trigger_4.SetEnterCallback( void function(entity trigger , entity ent)
    {
    //set Checkpoint and shot timer
if (IsValid(ent)){
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){
		int checkpointInThisTrigger = 1
		//show checkpoint msg
		if(ent.p.currentCheckpoint != checkpointInThisTrigger)
			Remote_CallFunction_NonReplay( ent, "MG_Checkpoint_Msg")
		
		//set checkpoint
		ent.p.currentCheckpoint = checkpointInThisTrigger
        }
}
    })
    DispatchSpawn( trigger_4 )
    entity trigger_5 = MapEditor_CreateTrigger( < 3380.2, 3714, -609.0504 >, < 0, 0, 0 >, 147.0848, 29.41697, false )
    trigger_5.SetEnterCallback( void function(entity trigger , entity ent)
    {
    //set Checkpoint and shot timer
if (IsValid(ent)){
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){
		int checkpointInThisTrigger = 5
		//show checkpoint msg
		if(ent.p.currentCheckpoint != checkpointInThisTrigger)
			Remote_CallFunction_NonReplay( ent, "MG_Checkpoint_Msg")
		
		//set checkpoint
		ent.p.currentCheckpoint = checkpointInThisTrigger
        }
}
    })
    DispatchSpawn( trigger_5 )
    entity trigger_6 = MapEditor_CreateTrigger( < 3380.2, 6620.1, -1295.6 >, < 0, 0, 0 >, 147.0848, 29.41697, false )
    trigger_6.SetEnterCallback( void function(entity trigger , entity ent)
    {
    //set Checkpoint and shot timer
if (IsValid(ent)){
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){
		int checkpointInThisTrigger = 8
		//show checkpoint msg
		if(ent.p.currentCheckpoint != checkpointInThisTrigger)
			Remote_CallFunction_NonReplay( ent, "MG_Checkpoint_Msg")
		
		//set checkpoint
		ent.p.currentCheckpoint = checkpointInThisTrigger
        }
}
    })
    DispatchSpawn( trigger_6 )
    entity trigger_7 = MapEditor_CreateTrigger( < 4163, 8445.127, -927.2 >, < 0, 0, 0 >, 122.9, 29.41697, false )
    trigger_7.SetEnterCallback( void function(entity trigger , entity ent)
    {
    //set Checkpoint and shot timer
if (IsValid(ent)){
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){
		int checkpointInThisTrigger = 11
		//show checkpoint msg
		if(ent.p.currentCheckpoint != checkpointInThisTrigger)
			Remote_CallFunction_NonReplay( ent, "MG_Checkpoint_Msg")
		
		//set checkpoint
		ent.p.currentCheckpoint = checkpointInThisTrigger
        }
}
    })
    DispatchSpawn( trigger_7 )
    entity trigger_8 = MapEditor_CreateTrigger( < 4686.523, 9145.026, -801 >, < 0, 0, 0 >, 114.6, 29.41697, false )
    trigger_8.SetEnterCallback( void function(entity trigger , entity ent)
    {
    //set Checkpoint and shot timer
if (IsValid(ent)){
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){
		int checkpointInThisTrigger = 12
		//show checkpoint msg
		if(ent.p.currentCheckpoint != checkpointInThisTrigger)
			Remote_CallFunction_NonReplay( ent, "MG_Checkpoint_Msg")
		
		//set checkpoint
		ent.p.currentCheckpoint = checkpointInThisTrigger
        }
}
    })
    DispatchSpawn( trigger_8 )
    entity trigger_9 = MapEditor_CreateTrigger( < 3396.223, 4484.626, -732.194 >, < 0, 0, 0 >, 107, 29.41697, false )
    trigger_9.SetEnterCallback( void function(entity trigger , entity ent)
    {
    //set Checkpoint and shot timer
if (IsValid(ent)){
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){
		int checkpointInThisTrigger = 6
		//show checkpoint msg
		if(ent.p.currentCheckpoint != checkpointInThisTrigger)
			Remote_CallFunction_NonReplay( ent, "MG_Checkpoint_Msg")
		
		//set checkpoint
		ent.p.currentCheckpoint = checkpointInThisTrigger
        }
}
    })
    DispatchSpawn( trigger_9 )
    entity trigger_10 = MapEditor_CreateTrigger( < 3327.823, 5313.026, -861.194 >, < 0, 0, 0 >, 107, 29.41697, false )
    trigger_10.SetEnterCallback( void function(entity trigger , entity ent)
    {
    //set Checkpoint and shot timer
if (IsValid(ent)){
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){
		int checkpointInThisTrigger = 7
		//show checkpoint msg
		if(ent.p.currentCheckpoint != checkpointInThisTrigger)
			Remote_CallFunction_NonReplay( ent, "MG_Checkpoint_Msg")
		
		//set checkpoint
		ent.p.currentCheckpoint = checkpointInThisTrigger
        }
}
    })
    DispatchSpawn( trigger_10 )
    entity trigger_11 = MapEditor_CreateTrigger( < 3380.2, 7269.026, -1109.894 >, < 0, 0, 0 >, 147.0848, 29.41697, false )
    trigger_11.SetEnterCallback( void function(entity trigger , entity ent)
    {
    //set Checkpoint and shot timer
if (IsValid(ent)){
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){
		int checkpointInThisTrigger = 9
		//show checkpoint msg
		if(ent.p.currentCheckpoint != checkpointInThisTrigger)
			Remote_CallFunction_NonReplay( ent, "MG_Checkpoint_Msg")
		
		//set checkpoint
		ent.p.currentCheckpoint = checkpointInThisTrigger
        }
}
    })
    DispatchSpawn( trigger_11 )
    entity trigger_12 = MapEditor_CreateTrigger( < 3712.023, 7743.626, -980.194 >, < 0, 0, 0 >, 108.3, 29.41697, false )
    trigger_12.SetEnterCallback( void function(entity trigger , entity ent)
    {
    //set Checkpoint and shot timer
if (IsValid(ent)){
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){
		int checkpointInThisTrigger = 10
		//show checkpoint msg
		if(ent.p.currentCheckpoint != checkpointInThisTrigger)
			Remote_CallFunction_NonReplay( ent, "MG_Checkpoint_Msg")
		
		//set checkpoint
		ent.p.currentCheckpoint = checkpointInThisTrigger
        }
}
    })
    DispatchSpawn( trigger_12 )


}

//Init Map2 DEAFPS
void
function MovementGym_Map2() {
    // Props Array
    array < entity > ClipArray; array < entity > NoClimbArray; array < entity > NoGrappleNoClimbArray; array < entity > NoCollisionArray; 

    // Props
    ClipArray.append( MapEditor_CreateProp( $"mdl/mendoko/mendoko_rubber_floor_01.rmdl", < 29458.07, -20315.99, 23133.46 >, < 0, 0, 0 >, true, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_wood_board_01.rmdl", < 22992.17, -26731.81, 22705.27 >, < 0, 0, -44.9999 >, true, 5000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/barriers/shooting_range_target_02.rmdl", < 29469.7, -20272.5, 23084.2 >, < 0, 179.9997, 0 >, false, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/construction_fold_sign_01.rmdl", < 25123.22, -20726.25, 23003.15 >, < 0, 30.4986, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29125.7, -20024.7, 24097.4 >, < 0, 0, 89.9998 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_wood_board_01.rmdl", < 25360.22, -22557.35, 22771.05 >, < -0.0001, -89.9999, 59.9999 >, true, 5000, -1, 1 )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 19677.38, -25472.53, 22577.15 >, < -90, 179.9999, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 19677.38, -24862.53, 22577.15 >, < -90, 179.9999, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 19677.38, -25472.53, 21971.15 >, < -90, 179.9999, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 19677.38, -24862.53, 21971.15 >, < -90, 179.9999, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 19328.78, -24862.52, 22577.15 >, < -90, 0, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 19328.78, -25472.53, 21971.15 >, < -90, 0, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 19328.78, -25472.53, 22577.15 >, < -90, 0, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 19328.78, -24862.53, 21971.15 >, < -90, 0, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 19677.38, -25472.53, 23183.15 >, < -90, 179.9999, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 19328.78, -25472.53, 23183.15 >, < -90, 0, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 19677.38, -24862.53, 23183.15 >, < -90, 179.9999, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 19328.78, -24862.52, 23183.15 >, < -90, 0, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 19328.78, -25963.75, 21971.15 >, < -90, 0, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 19328.78, -25963.75, 22577.15 >, < -90, 0, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 19328.78, -25963.75, 23183.15 >, < -90, 0, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 23497, -26446, 23183.15 >, < -90, -90.0003, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 24107, -26446, 23183.15 >, < -90, -90.0003, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 24107, -26787.99, 23183.15 >, < -90, 90.0001, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 23497, -26788, 23183.15 >, < -90, 90.0001, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 24662.32, -26441.81, 22978.1 >, < -90, -89.9996, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 24662.32, -26441.81, 22372.1 >, < -90, -89.9996, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 20676.77, -25860.41, 23183.15 >, < -90, -90.0003, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 20676.77, -25860.41, 22577.15 >, < -90, -90.0003, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 20066.77, -25860.41, 23183.15 >, < -90, -90.0003, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 21286.77, -25860.41, 22577.15 >, < -90, -90.0003, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 20066.77, -25860.41, 22577.15 >, < -90, -90.0003, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 21286.77, -25860.41, 23183.15 >, < -90, -90.0003, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29300.97, -20487.21, 23183.15 >, < -90, 90.0001, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29488.97, -20241.41, 23183.15 >, < -90, 179.9999, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29488.97, -19684.41, 23183.15 >, < -90, 179.9999, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29488.97, -19684.41, 23781.77 >, < -90, 179.9999, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29488.97, -20241.41, 23781.77 >, < -90, 179.9999, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29300.97, -20487.21, 23642.85 >, < -90, 90.0001, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29054.32, -19581.75, 23183.15 >, < -90, 0.0002, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 28969.77, -19829.41, 23781.77 >, < -90, 0.0002, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 28901.77, -19829.41, 23183.15 >, < -90, -179.9994, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 28901.77, -19829.41, 23781.77 >, < -90, -179.9994, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 24107, -26446, 22405.82 >, < -90, -90.0003, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 23497, -26446, 22405.82 >, < -90, -90.0003, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 23497, -26788, 22405.82 >, < -90, 90.0001, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 24107, -26787.99, 22405.82 >, < -90, 90.0001, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 23497, -26446, 23960.48 >, < -90, -90.0003, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 23497, -26788, 23960.48 >, < -90, 90.0001, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 24107, -26446, 23960.48 >, < -90, -90.0003, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 24107, -26787.99, 23960.48 >, < -90, 90.0001, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 19328.78, -24862.52, 23960.48 >, < -90, 0, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 19677.38, -24862.53, 23960.48 >, < -90, 179.9999, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 20066.77, -25860.41, 23960.48 >, < -90, -90.0003, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 19328.78, -25963.75, 23960.48 >, < -90, 0, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 20676.77, -25860.41, 23960.48 >, < -90, -90.0003, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 19328.78, -25472.53, 23960.48 >, < -90, 0, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 19677.38, -25472.53, 23960.48 >, < -90, 179.9999, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 21286.77, -25860.41, 23960.48 >, < -90, -90.0003, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 28901.77, -19829.41, 23183.15 >, < -90, -179.9994, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29054.32, -19218.95, 23183.15 >, < -90, 0.0002, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29054.32, -18615.75, 23183.15 >, < -90, 0.0002, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29401.72, -19226.21, 23183.15 >, < -90, -179.9994, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29401.72, -18615.76, 23183.15 >, < -90, -179.9994, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29401.72, -19581.75, 23183.15 >, < -90, -179.9994, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29054.32, -19829.41, 23960.48 >, < -90, 0.0002, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29401.72, -18615.76, 23960.48 >, < -90, -179.9994, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29054.32, -18615.75, 23960.48 >, < -90, 0.0002, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29401.72, -19226.21, 23960.48 >, < -90, -179.9994, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29054.32, -19218.95, 23960.48 >, < -90, 0.0002, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29401.72, -19829.41, 23960.48 >, < -90, -179.9994, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29054.32, -19829.41, 24737.81 >, < -90, 0.0002, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29401.72, -18615.76, 24737.81 >, < -90, -179.9994, 0 >, false, 5000, -1, 1.000001 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29054.32, -18615.75, 24737.81 >, < -90, 0.0002, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29401.72, -19226.21, 24737.81 >, < -90, -179.9994, 0 >, false, 5000, -1, 1.000001 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29054.32, -19218.95, 24737.81 >, < -90, 0.0002, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29401.72, -19829.41, 24737.81 >, < -90, -179.9994, 0 >, false, 5000, -1, 1.000001 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29401.72, -18615.76, 25515.13 >, < -90, -179.9994, 0 >, false, 5000, -1, 1.000001 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29054.32, -18615.75, 25515.13 >, < -90, 0.0002, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29401.72, -19829.41, 25515.13 >, < -90, -179.9994, 0 >, false, 5000, -1, 1.000001 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29401.72, -19226.21, 25515.13 >, < -90, -179.9994, 0 >, false, 5000, -1, 1.000001 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29054.32, -19218.95, 25515.13 >, < -90, 0.0002, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29054.32, -19829.41, 25515.13 >, < -90, 0.0002, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29401.72, -20873.55, 24408.87 >, < -90, -179.9994, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29054.32, -20510.76, 24408.87 >, < -90, 0.0009, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29401.72, -20510.76, 24408.87 >, < -90, -179.9994, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29401.72, -21476.75, 24408.87 >, < -90, -179.9994, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29054.32, -20866.3, 24408.87 >, < -90, 0.0009, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29054.33, -21476.76, 24408.87 >, < -90, 0.0009, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29401.72, -20263.1, 25186.2 >, < -90, -179.9994, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29054.33, -21476.76, 25186.2 >, < -90, 0.0009, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29401.72, -21476.75, 25186.2 >, < -90, -179.9994, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29054.32, -20866.3, 25186.2 >, < -90, 0.0009, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29401.72, -20873.55, 25186.2 >, < -90, -179.9994, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29054.32, -20263.1, 25186.2 >, < -90, 0.0009, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29401.72, -20263.1, 25963.53 >, < -90, -179.9994, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29054.33, -21476.76, 25963.53 >, < -90, 0.0009, 0 >, false, 5000, -1, 1.000001 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29401.72, -21476.75, 25963.53 >, < -90, -179.9994, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29054.32, -20866.3, 25963.53 >, < -90, 0.0009, 0 >, false, 5000, -1, 1.000001 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29401.72, -20873.55, 25963.53 >, < -90, -179.9994, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29054.32, -20263.1, 25963.53 >, < -90, 0.0009, 0 >, false, 5000, -1, 1.000001 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29054.33, -21476.76, 26740.85 >, < -90, 0.0009, 0 >, false, 5000, -1, 1.000001 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29401.72, -21476.75, 26740.85 >, < -90, -179.9994, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29054.32, -20263.1, 26740.85 >, < -90, 0.0009, 0 >, false, 5000, -1, 1.000001 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29054.32, -20866.3, 26740.85 >, < -90, 0.0009, 0 >, false, 5000, -1, 1.000001 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29401.72, -20873.55, 26740.85 >, < -90, -179.9994, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29401.72, -20263.1, 26740.85 >, < -90, -179.9994, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29189.12, -19434.85, 25263.85 >, < -90, -89.9996, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29189.12, -19434.85, 26000.85 >, < -90, -89.9996, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 23326.82, -26446, 22405.82 >, < -90, -90.0003, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 23326.82, -26446, 23110.52 >, < -90, -90.0003, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 23326.82, -26446, 23887.85 >, < -90, -90.0003, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 23342.32, -26788, 22405.82 >, < -90, 90.0001, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 23342.32, -26788, 23183.15 >, < -90, 90.0001, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 23342.32, -26788, 23960.48 >, < -90, 90.0001, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29300.97, -20897.75, 23938.85 >, < 0.0005, 90, 0.0001 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29300.97, -21404.75, 23938.85 >, < 0.0005, 90, 0.0001 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29300.97, -21751.75, 23938.85 >, < 0.0005, 90, 0.0001 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 29300.97, -20546.55, 23938.85 >, < 0.0005, 90, 0.0001 >, false, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/construction_fold_sign_01.rmdl", < 22519.62, -26464.25, 22725.45 >, < -0.3992, 146.9825, -9.3797 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_wood_board_01.rmdl", < 29001.97, -20490.35, 23058.24 >, < -0.0001, -179.9997, 46.6977 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_stacker_cone_dirty_01.rmdl", < 24797.22, -26778.81, 22722.07 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_stack_01.rmdl", < 23786, -26468, 22718.2 >, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 25200.77, -21671.25, 22811.38 >, < 0, -90, 179.9997 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 25200.77, -22145.41, 22694.77 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 25200.77, -21670.96, 22803.1 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 25201.72, -21171.81, 22990.79 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 25200.77, -21361.08, 22922.96 >, < 0, -90, 179.9997 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 25201.72, -21609.91, 22879.31 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 25201.72, -22084.36, 22770.97 >, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 25200.77, -21232.86, 22914.58 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 25200.77, -21799.47, 22802.99 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 25200.77, -22273.63, 22703.15 >, < 0, -90, 179.9997 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 25200.77, -21799.47, 22810.99 >, < 0, -90, 179.9997 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 25200.77, -21361.08, 22914.96 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 25200.77, -22145.41, 22703.54 >, < 0, -90, 179.9997 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 25200.77, -21232.86, 22923.35 >, < 0, -90, 179.9997 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 25200.77, -22273.63, 22695.15 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 25241.94, -22454.31, 22586.77 >, < 0, -90, 0 >, true, 5000, -1, 0.7657143 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 25154.77, -25036.41, 22710.77 >, < 0, -179.9999, 0 >, true, 5000, -1, 1.82 ) )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 25199.26, -22411.61, 22586.77 >, < 0, 0, 0 >, true, 5000, -1, 0.7657141 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 25155.17, -22417.61, 22704.31 >, < 0, -179.9999, 0 >, true, 5000, -1, 1.82 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 25173.74, -25089.66, 22713.77 >, < 0, -179.9999, 0 >, true, 5000, -1, 1.82 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 25174.14, -22470.86, 22707.31 >, < 0, -179.9999, 0 >, true, 5000, -1, 1.82 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 25247.66, -22503.29, 22704.31 >, < 0, 0.0002, 0 >, true, 5000, -1, 1.82 ) )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 25166.94, -25078.46, 22586.77 >, < 0, 90, 0 >, true, 5000, -1, 0.7657141 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 25228.7, -22450.05, 22707.31 >, < 0, 0.0002, 0 >, true, 5000, -1, 1.82 ) )
    ClipArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 25203.54, -22437.01, 22700.46 >, < 0, 0, 0 >, true, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 25166.64, -22454.35, 22586.77 >, < 0, 90, 0 >, true, 5000, -1, 0.7657141 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 25152.27, -25123.71, 22708.77 >, < 0, -179.9999, 0 >, true, 5000, -1, 1.82 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 25152.67, -22504.91, 22702.31 >, < 0, -179.9999, 0 >, true, 5000, -1, 1.82 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 25250.17, -22415.99, 22702.31 >, < 0, 0.0002, 0 >, true, 5000, -1, 1.82 ) )
    MapEditor_CreateProp( $"mdl/lamps/light_parking_post.rmdl", < 25163.54, -25091.31, 22669.76 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 25199.26, -22509.31, 22586.77 >, < 0, -180, 0 >, true, 5000, -1, 0.7657141 )
    ClipArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 25203.54, -22476.61, 22700.46 >, < 0, 0, 0 >, true, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 25162.54, -25756.26, 22588.77 >, < 0, 90, 0 >, true, 5000, -1, 0.7657141 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 25169.34, -25767.46, 22715.77 >, < 0, -179.9999, 0 >, true, 5000, -1, 1.82 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 25161.77, -25817.41, 22712.77 >, < 0, -89.9999, 0 >, true, 5000, -1, 1.82 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 25150.37, -25714.21, 22712.77 >, < 0, -179.9999, 0 >, true, 5000, -1, 1.82 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 25147.87, -25801.51, 22710.77 >, < 0, -179.9999, 0 >, true, 5000, -1, 1.82 ) )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 25237.84, -25977.51, 22588.77 >, < 0, -90, 0 >, true, 5000, -1, 0.7657143 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 25243.17, -25800.11, 22712.77 >, < 0, 0, 0 >, true, 5000, -1, 1.82 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 25161.77, -26038.71, 22712.77 >, < 0, -89.9999, 0 >, true, 5000, -1, 1.82 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 25169.34, -25988.76, 22715.77 >, < 0, -179.9999, 0 >, true, 5000, -1, 1.82 ) )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 25195.16, -25811.21, 22588.77 >, < 0, -180, 0 >, true, 5000, -1, 0.7657141 )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 25195.16, -25934.82, 22588.77 >, < 0, 0, 0 >, true, 5000, -1, 0.7657141 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 25231.04, -25966.31, 22715.77 >, < 0, 0, 0 >, true, 5000, -1, 1.82 ) )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 25195.16, -25713.51, 22588.77 >, < 0, 0, 0 >, true, 5000, -1, 0.7657141 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 25249.77, -25938.31, 22710.77 >, < 0, 0, 0 >, true, 5000, -1, 1.82 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 25249.67, -25813.11, 22710.77 >, < 0, -89.9999, 0 >, true, 5000, -1, 1.82 ) )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 25237.84, -25756.21, 22588.77 >, < 0, -90, 0 >, true, 5000, -1, 0.7657143 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 25150.37, -25935.51, 22712.77 >, < 0, -179.9999, 0 >, true, 5000, -1, 1.82 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 25190.17, -25923.91, 22715.77 >, < 0, 0, 0 >, true, 5000, -1, 1.82 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 25231.04, -25745.01, 22715.77 >, < 0, 0, 0 >, true, 5000, -1, 1.82 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 25147.87, -26022.81, 22710.77 >, < 0, -179.9999, 0 >, true, 5000, -1, 1.82 ) )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 25195.16, -26032.51, 22588.77 >, < 0, -180, 0 >, true, 5000, -1, 0.7657141 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 25190.17, -25702.61, 22715.77 >, < 0, 0, 0 >, true, 5000, -1, 1.82 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 25243.17, -26021.41, 22712.77 >, < 0, 0, 0 >, true, 5000, -1, 1.82 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 25249.77, -25717.01, 22710.77 >, < 0, 0, 0 >, true, 5000, -1, 1.82 ) )
    ClipArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 25199.44, -25744.62, 22702.46 >, < 0, 0, 0 >, true, 5000, -1, 1 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 25249.67, -26034.41, 22710.77 >, < 0, -89.9999, 0 >, true, 5000, -1, 1.82 ) )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 25162.54, -25977.56, 22588.77 >, < 0, 90, 0 >, true, 5000, -1, 0.7657141 )
    ClipArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 25199.44, -25995.02, 22702.46 >, < 0, 0, 0 >, true, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/barriers/concrete/concrete_barrier_fence.rmdl", < 24977.97, -26451.41, 22714.27 >, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 20378.1, -26497.46, 22737.07 >, < 0, -179.9999, 0 >, true, 5000, -1, 1.82 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 20399.57, -26463.41, 22742.07 >, < 0, -179.9999, 0 >, true, 5000, -1, 1.82 ) )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 20392.77, -26452.21, 22615.07 >, < 0, 90, 0 >, true, 5000, -1, 0.7657141 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 20380.6, -26410.16, 22739.07 >, < 0, -179.9999, 0 >, true, 5000, -1, 1.82 ) )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 25044.16, -26439.8, 22716.77 >, < 0, -0.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/ola/sewer_railing_01_128.rmdl", < 23085.7, -26713.11, 22720.57 >, < 0, -0.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/lamps/light_parking_post.rmdl", < 20386.87, -26450.81, 22673.37 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 19678.7, -25751.3, 22091.5 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_02.rmdl", < 19678.7, -25848, 21876.9 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 19400.2, -25721.8, 22364.9 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_top.rmdl", < 19496.5, -24950.7, 22514.7 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_bott.rmdl", < 19496.5, -24950.7, 21877.3 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 19496.5, -24950.7, 22298.2 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 19344.6, -25721.8, 22364.9 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 19703.8, -25721.8, 22364.9 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 19648.2, -25721.8, 22364.9 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 19400.2, -25721.8, 22215.7 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 19344.6, -25721.8, 22215.7 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 19648.2, -25721.8, 22215.7 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 19703.8, -25721.8, 22215.7 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 19703.8, -25721.8, 22066.5 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 19648.2, -25721.8, 22066.5 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 19344.6, -25721.8, 22066.5 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 19400.2, -25721.8, 22066.5 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 19400.2, -25721.8, 21916.8 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 19344.6, -25721.8, 21916.8 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 19648.2, -25721.8, 21916.8 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 19703.8, -25721.8, 21916.8 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 19703.8, -25721.8, 21767.9 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 19648.2, -25721.8, 21767.9 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 19344.6, -25721.8, 21767.9 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 19400.2, -25721.8, 21767.9 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_bott.rmdl", < 19496.5, -24950.7, 22091.8 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 19678.7, -25623, 22091.5 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 19678.7, -25581.3, 22091.2 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 19678.7, -25751.3, 22305.1 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 19678.7, -25623, 22305.1 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 19678.7, -25501.8, 22428.7 >, < -90, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 19678.7, -25501.8, 22515.4 >, < -90, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 19678.7, -25633.2, 22515.7 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 19678.7, -25761.5, 22515.7 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 19326.7, -25762.2, 22515.4 >, < -90, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 19326.7, -25762.2, 22400 >, < -90, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 19678.7, -25761.5, 22721.2 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 19678.7, -25634.1, 22721.2 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 19678.7, -25585.1, 22721.4 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 19400.2, -25721.8, 22514 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 19344.6, -25721.8, 22514 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 19648.2, -25721.8, 22514 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 19703.8, -25721.8, 22514 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 19703.8, -25721.8, 22666.4 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 19648.2, -25721.8, 22666.4 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 19344.6, -25721.8, 22666.4 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 19400.2, -25721.8, 22666.4 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 19415, -25380.58, 22288.46 >, < 0, 0, 14.417 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 19589, -25380.58, 22288.46 >, < 0, 0, 14.417 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 19415, -25138.7, 22320.87 >, < 0, 0, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 19589, -25138.7, 22320.87 >, < 0, 0, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 19589, -24905, 22320.87 >, < 0, 0, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 19415, -24905, 22320.87 >, < 0, 0, 0 >, false, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_02.rmdl", < 23085.7, -26440.63, 22722.8 >, < 0, -0.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_02.rmdl", < 24234.7, -26440.63, 22722.8 >, < 0, -0.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/ola/sewer_railing_01_128.rmdl", < 24233.77, -26713.61, 22721.27 >, < 0, -0.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 25296.93, -26531.76, 22691.17 >, < 0, -37.2341, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 25296.93, -26531.75, 22563.77 >, < 0, -37.2341, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 25296.61, -26531.51, 22818.47 >, < 0, -37.2341, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 19678.7, -25875.71, 22722.77 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 19678.7, -26002.31, 22722.96 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 19330.77, -26066.81, 22807.67 >, < 0.0004, -179.9997, -89.9998 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_04_corner.rmdl", < 19822.7, -26790, 22722.8 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 24916.77, -26439.81, 22716.77 >, < 0, -0.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/barriers/concrete/concrete_barrier_fence.rmdl", < 24850.87, -26451.51, 22714.27 >, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 25837.39, -20355.2, 22881.77 >, < 0, -90, 0 >, true, 5000, -1, 0.7657143 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 25708.49, -20315.26, 23005.77 >, < 0, -179.9999, 0 >, true, 5000, -1, 1.3183 ) )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 25739.69, -20355.2, 22881.77 >, < 0, 90, 0 >, true, 5000, -1, 0.7657141 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 25734.67, -20285.38, 23003.77 >, < 0, 90.0001, 0 >, true, 5000, -1, 1.3183 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 25251.59, -20741, 23005.77 >, < 0, 90.0001, 0 >, true, 5000, -1, 1.3183 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 25281.47, -20767.18, 23003.77 >, < 0, 0.0001, 0 >, true, 5000, -1, 1.3183 ) )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 25168.97, -20827.2, 22881.77 >, < 0, 90, 0 >, true, 5000, -1, 0.7657143 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_small_02.rmdl", < 25332.97, -20961.18, 22980.56 >, < 0, 0, 0 >, true, 5000, -1, 1 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 25834.59, -20291.38, 23005.77 >, < 0, 90.0001, 0 >, true, 5000, -1, 1.3183 ) )
    ClipArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 25778.75, -20355.48, 22994.56 >, < 0, -90, 0 >, true, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/ola/sewer_railing_01_128.rmdl", < 25258.47, -20689.18, 23001.36 >, < 0, 89.9999, 0 >, true, 5000, -1, 1 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 25805.9, -20391.08, 23008.77 >, < 0, -90, 0 >, true, 5000, -1, 1.3183 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 25754.75, -20429.08, 23005.77 >, < 0, -90, 0 >, true, 5000, -1, 1.3183 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 25275.47, -20867.1, 23005.77 >, < 0, 0.0001, 0 >, true, 5000, -1, 1.3183 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 25783.44, -20329.38, 23008.77 >, < 0, 90.0001, 0 >, true, 5000, -1, 1.3183 ) )
    ClipArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 25207.67, -20816.08, 22994.56 >, < 0, 0, 0 >, true, 5000, -1, 1 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 25702.49, -20415.18, 23003.77 >, < 0, -179.9999, 0 >, true, 5000, -1, 1.3183 ) )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 25794.69, -20397.88, 22881.77 >, < 0, -180, 0 >, true, 5000, -1, 0.7657141 )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 25211.65, -20772.21, 22881.77 >, < 0, 0, 0 >, true, 5000, -1, 0.7657141 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 25151.67, -20735, 23003.77 >, < 0, 90.0001, 0 >, true, 5000, -1, 1.3183 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 25237.47, -20815.96, 23008.77 >, < 0, 0.0001, 0 >, true, 5000, -1, 1.3183 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 25137.77, -20787.26, 23005.77 >, < 0, -180, 0 >, true, 5000, -1, 1.3183 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 25131.77, -20887.18, 23003.77 >, < 0, -180, 0 >, true, 5000, -1, 1.3183 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_small_02.rmdl", < 25332.97, -20689.78, 22980.56 >, < 0, 0, 0 >, true, 5000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_small_02.rmdl", < 25332.97, -20961.18, 23122.96 >, < 0, 0, 0 >, true, 5000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_small_02.rmdl", < 25332.97, -20689.78, 23122.96 >, < 0, 0, 0 >, true, 5000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_small_02.rmdl", < 25604.87, -20553.38, 22980.56 >, < 0, -90, 0 >, true, 5000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_small_02.rmdl", < 25876.27, -20553.38, 22980.56 >, < 0, -90, 0 >, true, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/signs/street_sign_arrow.rmdl", < 25223.67, -20303.38, 23103.96 >, < 0, 0, 180 >, true, 5000, -1, 2.8878 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 25854.67, -20435.08, 23003.77 >, < 0, -90, 0 >, true, 5000, -1, 1.3183 ) )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 25211.65, -20869.9, 22881.77 >, < 0, -180, 0 >, true, 5000, -1, 0.7657141 )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 25794.65, -20322.58, 22881.77 >, < 0, 0, 0 >, true, 5000, -1, 0.7657141 )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 25244.27, -20827.16, 22881.77 >, < 0, -90, 0 >, true, 5000, -1, 0.7657141 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 25175.77, -20838.41, 23008.77 >, < 0, -180, 0 >, true, 5000, -1, 1.3183 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_small_02.rmdl", < 25876.27, -20553.38, 23122.96 >, < 0, -90, 0 >, true, 5000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_small_02.rmdl", < 25604.87, -20553.38, 23122.96 >, < 0, -90, 0 >, true, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 25207.67, -20938.81, 22881.27 >, < 0, 0, 89.9998 >, true, 5000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_small_02.rmdl", < 25332.97, -20961.18, 23265.77 >, < 0, 0, 0 >, true, 5000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_small_02.rmdl", < 25332.97, -20689.78, 23265.77 >, < 0, 0, 0 >, true, 5000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_small_02.rmdl", < 25876.27, -20553.38, 23265.77 >, < 0, -90, 0 >, true, 5000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_small_02.rmdl", < 25604.87, -20553.38, 23265.77 >, < 0, -90, 0 >, true, 5000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_small_02.rmdl", < 25332.97, -20961.18, 23408.77 >, < 0, 0, 0 >, true, 5000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_small_02.rmdl", < 25332.97, -20689.78, 23408.77 >, < 0, 0, 0 >, true, 5000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_small_02.rmdl", < 25876.27, -20553.38, 23408.77 >, < 0, -90, 0 >, true, 5000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_small_02.rmdl", < 25604.87, -20553.38, 23408.77 >, < 0, -90, 0 >, true, 5000, -1, 1 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 26365.17, -20329.88, 23001.53 >, < 0, 90.0003, 0 >, true, 5000, -1, 1.82 ) )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 26376.38, -20323.09, 22874.53 >, < 0, 0.0002, 0 >, true, 5000, -1, 0.7657141 )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 29071.03, -20322.78, 22874.53 >, < 0, 0.0002, 0 >, true, 5000, -1, 0.7657141 )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 29071.07, -20398.08, 22874.53 >, < 0, -179.9998, 0 >, true, 5000, -1, 0.7657143 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 26418.42, -20310.91, 22998.53 >, < 0, 90.0003, 0 >, true, 5000, -1, 1.82 ) )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 29113.77, -20355.4, 22874.53 >, < 0, -89.9998, 0 >, true, 5000, -1, 0.7657141 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 29054.52, -20330.28, 22995.08 >, < 0, 90.0003, 0 >, true, 5000, -1, 1.82 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 29022.09, -20403.8, 22992.08 >, < 0, -89.9996, 0 >, true, 5000, -1, 1.82 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 29107.77, -20311.31, 22992.08 >, < 0, 90.0003, 0 >, true, 5000, -1, 1.82 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 26331.12, -20308.41, 22996.53 >, < 0, 90.0003, 0 >, true, 5000, -1, 1.82 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 29020.47, -20308.81, 22990.08 >, < 0, 90.0003, 0 >, true, 5000, -1, 1.82 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 29109.39, -20406.31, 22990.08 >, < 0, -89.9996, 0 >, true, 5000, -1, 1.82 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 29075.33, -20384.84, 22995.08 >, < 0, -89.9996, 0 >, true, 5000, -1, 1.82 ) )
    ClipArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 29088.37, -20359.68, 22988.23 >, < 0, -89.9998, 0 >, true, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/lamps/light_parking_post.rmdl", < 26363.52, -20319.68, 22957.53 >, < 0, -89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 29016.07, -20355.4, 22874.53 >, < 0, 90.0002, 0 >, true, 5000, -1, 0.7657141 )
    ClipArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 29048.77, -20359.68, 22988.23 >, < 0, -89.9998, 0 >, true, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 29348.32, -20322.78, 22874.53 >, < 0, 0.0002, 0 >, true, 5000, -1, 0.7657141 )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 29348.37, -20398.08, 22874.53 >, < 0, -179.9998, 0 >, true, 5000, -1, 0.7657143 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 29331.82, -20330.28, 22995.08 >, < 0, 90.0003, 0 >, true, 5000, -1, 1.82 ) )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 29391.06, -20355.4, 22874.53 >, < 0, -89.9998, 0 >, true, 5000, -1, 0.7657141 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 29299.38, -20403.8, 22992.08 >, < 0, -89.9996, 0 >, true, 5000, -1, 1.82 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 29385.07, -20311.31, 22992.08 >, < 0, 90.0003, 0 >, true, 5000, -1, 1.82 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 29386.68, -20406.31, 22990.08 >, < 0, -89.9996, 0 >, true, 5000, -1, 1.82 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 29297.77, -20308.81, 22990.08 >, < 0, 90.0003, 0 >, true, 5000, -1, 1.82 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 29352.63, -20384.84, 22995.08 >, < 0, -89.9996, 0 >, true, 5000, -1, 1.82 ) )
    ClipArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 29365.66, -20359.68, 22988.23 >, < 0, -89.9998, 0 >, true, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 29293.37, -20355.4, 22874.53 >, < 0, 90.0002, 0 >, true, 5000, -1, 0.7657141 )
    ClipArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 29326.06, -20359.68, 22988.23 >, < 0, -89.9998, 0 >, true, 5000, -1, 1 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 29213.77, -20403.8, 22987.67 >, < 0, -89.9996, 0 >, true, 5000, -1, 1.82 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 29219.67, -20330.28, 22990.07 >, < 0, 90.0003, 0 >, true, 5000, -1, 1.82 ) )
    ClipArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 28935.07, -20359.68, 22873.07 >, < -0.0002, -90, 89.9998 >, true, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 29286.87, -20090.59, 23073.77 >, < 0, 89.9997, 0 >, true, 5000, -1, 0.7657143 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 29415.77, -20130.53, 23197.77 >, < 0, -0.0002, 0 >, true, 5000, -1, 1.3183 ) )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 29384.56, -20090.59, 23073.77 >, < 0, -90.0003, 0 >, true, 5000, -1, 0.7657141 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 29289.67, -20154.41, 23197.77 >, < 0, -90.0002, 0 >, true, 5000, -1, 1.3183 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 29389.59, -20160.41, 23195.77 >, < 0, -90.0002, 0 >, true, 5000, -1, 1.3183 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 29318.36, -20054.71, 23200.77 >, < 0, 89.9997, 0 >, true, 5000, -1, 1.3183 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 29369.52, -20016.71, 23197.77 >, < 0, 89.9997, 0 >, true, 5000, -1, 1.3183 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 29421.77, -20030.61, 23195.77 >, < 0, -0.0002, 0 >, true, 5000, -1, 1.3183 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 29340.82, -20116.41, 23200.77 >, < 0, -90.0002, 0 >, true, 5000, -1, 1.3183 ) )
    ClipArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 29345.51, -20090.31, 23186.56 >, < 0, 89.9997, 0 >, true, 5000, -1, 1 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 29269.59, -20010.71, 23195.77 >, < 0, 89.9997, 0 >, true, 5000, -1, 1.3183 ) )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 29329.57, -20047.91, 23073.77 >, < 0, -0.0003, 0 >, true, 5000, -1, 0.7657141 )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 29329.61, -20116.61, 23073.77 >, < 0, 179.9997, 0 >, true, 5000, -1, 0.7657141 )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 29345.51, -20202.91, 23072.46 >, < -90, 89.9997, 0 >, true, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 29286.87, -20085.09, 22977.77 >, < 0, 89.9997, 0 >, true, 5000, -1, 0.7657143 )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 29384.56, -20085.09, 22977.77 >, < 0, -90.0003, 0 >, true, 5000, -1, 0.7657141 )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 29329.57, -20042.41, 22977.77 >, < 0, -0.0003, 0 >, true, 5000, -1, 0.7657141 )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 29329.61, -20117.71, 22977.77 >, < 0, 179.9997, 0 >, true, 5000, -1, 0.7657141 )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 25052.03, -26189.41, 22691.17 >, < 0, -179.9992, 0 >, true, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 25052.03, -26189.41, 22563.77 >, < 0, -179.9992, 0 >, true, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 25052.43, -26189.41, 22818.47 >, < 0, -179.9992, 0 >, true, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 25052.03, -26189.41, 23069.46 >, < 0, -179.9992, 0 >, true, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 25052.03, -26189.41, 22942.06 >, < 0, -179.9992, 0 >, true, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 25052.43, -26189.41, 23196.77 >, < 0, -179.9992, 0 >, true, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 29134.04, -20090.59, 23073.77 >, < 0, -90.0003, 0 >, true, 5000, -1, 0.7657141 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 29039.15, -20154.41, 23197.77 >, < 0, -90.0002, 0 >, true, 5000, -1, 1.3183 ) )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 29036.35, -20085.09, 22977.77 >, < 0, 89.9997, 0 >, true, 5000, -1, 0.7657143 )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 29134.04, -20085.09, 22977.77 >, < 0, -90.0003, 0 >, true, 5000, -1, 0.7657141 )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 29079.05, -20042.41, 22977.77 >, < 0, -0.0003, 0 >, true, 5000, -1, 0.7657141 )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 29036.35, -20090.59, 23073.77 >, < 0, 89.9997, 0 >, true, 5000, -1, 0.7657143 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 29165.25, -20130.53, 23197.77 >, < 0, -0.0002, 0 >, true, 5000, -1, 1.3183 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 29090.3, -20116.41, 23200.77 >, < 0, -90.0002, 0 >, true, 5000, -1, 1.3183 ) )
    ClipArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 29094.99, -20090.31, 23186.56 >, < 0, 89.9997, 0 >, true, 5000, -1, 1 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 29019.07, -20010.71, 23195.77 >, < 0, 89.9997, 0 >, true, 5000, -1, 1.3183 ) )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 29079.05, -20047.91, 23073.77 >, < 0, -0.0003, 0 >, true, 5000, -1, 0.7657141 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 29139.07, -20160.41, 23195.77 >, < 0, -90.0002, 0 >, true, 5000, -1, 1.3183 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 29067.84, -20054.71, 23200.77 >, < 0, 89.9997, 0 >, true, 5000, -1, 1.3183 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 29119, -20016.71, 23197.77 >, < 0, 89.9997, 0 >, true, 5000, -1, 1.3183 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 29171.25, -20030.61, 23195.77 >, < 0, -0.0002, 0 >, true, 5000, -1, 1.3183 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 29094.99, -20202.91, 23072.46 >, < -90, 89.9997, 0 >, true, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29428.97, -19913.41, 23684.97 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29373.37, -19913.41, 23684.97 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29373.37, -19913.41, 23236.87 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 29403.87, -19776.71, 24041.47 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29428.97, -19913.41, 23535.77 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29125.37, -19913.41, 23535.77 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_top.rmdl", < 29221.67, -19142.31, 23834.77 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29069.77, -19913.41, 23386.57 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29069.77, -19913.41, 23236.87 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29373.37, -19913.41, 23087.97 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29069.77, -19913.41, 23087.97 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29125.37, -19913.41, 23087.97 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 29051.87, -19953.81, 23835.47 >, < -90, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29428.97, -19913.41, 23386.57 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29428.97, -19913.41, 23986.47 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 29403.87, -19772.91, 23411.27 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 29403.87, -19825.71, 24041.27 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29373.37, -19913.41, 23986.47 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29069.77, -19913.41, 23986.47 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 29403.87, -19814.61, 23411.57 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29373.37, -19913.41, 24134.27 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 29140.17, -19572.51, 23605.17 >, < 0, 0, 12.1251 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 29140.17, -19330.31, 23631.96 >, < 0, 0, 0 >, false, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29125.37, -19913.41, 23236.87 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29125.37, -19913.41, 23834.07 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29125.37, -19913.41, 24134.27 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 29403.87, -19942.91, 23411.57 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29069.77, -19913.41, 23684.97 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29069.77, -19913.41, 23535.77 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_02.rmdl", < 29403.87, -20039.61, 23196.97 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29373.37, -19913.41, 23386.57 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_bott.rmdl", < 29221.67, -19142.31, 23411.87 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 29403.87, -19814.61, 23625.17 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29125.37, -19913.41, 23684.97 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 29221.67, -19142.31, 23618.27 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 29403.87, -19693.41, 23748.77 >, < -90, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 29403.87, -19953.11, 23835.77 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 29051.87, -19953.81, 23720.07 >, < -90, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 29403.87, -19953.11, 24041.27 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29069.77, -19913.41, 23834.07 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29428.97, -19913.41, 23236.87 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29428.97, -19913.41, 23834.07 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29069.77, -19913.41, 24134.27 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29428.97, -19913.41, 24134.27 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 29403.87, -19942.91, 23625.17 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 29314.17, -19572.51, 23605.17 >, < 0, 0, 12.1251 >, false, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29428.97, -19913.41, 23087.97 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29373.37, -19913.41, 23535.77 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29125.37, -19913.41, 23386.57 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29373.37, -19913.41, 23834.07 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 29314.17, -19096.61, 23631.96 >, < 0, 0, 0 >, false, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 29403.87, -19693.41, 23835.47 >, < -90, -90, 0 >, true, 5000, -1, 1 )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 29140.17, -19096.61, 23631.96 >, < 0, 0, 0 >, false, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 29403.87, -19824.81, 23835.77 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29125.37, -19913.41, 23986.47 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 29314.17, -19330.31, 23631.96 >, < 0, 0, 0 >, false, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 29403.87, -20067.32, 24042.83 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 29403.87, -20193.92, 24043.03 >, < 0, -90, 0 >, true, 5000, -1, 1 )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 29141.77, -20877.31, 24482.43 >, < 0, -179.9997, 0 >, false, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 29052.07, -20140.3, 24888.19 >, < 0, 90.0003, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 29052.06, -20013.7, 24888.39 >, < 0, 90.0003, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29021.77, -20294.21, 24442.11 >, < 0, -179.9997, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29077.37, -20294.21, 24442.11 >, < 0, -179.9997, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29077.37, -20294.21, 23994.01 >, < 0, -179.9997, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 29052.07, -20430.91, 24886.83 >, < 0, 90.0003, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29021.77, -20294.21, 24292.91 >, < 0, -179.9997, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29325.37, -20294.21, 24292.91 >, < 0, -179.9997, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29380.97, -20294.21, 23994.01 >, < 0, -179.9997, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 29398.87, -20253.81, 24680.83 >, < -90, -89.9997, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29082.56, -20294.21, 24741.17 >, < 0, -179.9997, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29380.97, -20294.21, 24741.17 >, < 0, -179.9997, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29077.37, -20294.21, 24888.96 >, < 0, -179.9997, 0 >, true, 5000, -1, 1 )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 29315.77, -20877.31, 24482.43 >, < 0, -179.9997, 0 >, false, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29325.37, -20294.21, 23994.01 >, < 0, -179.9997, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29325.37, -20294.21, 24591.21 >, < 0, -179.9997, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29325.37, -20294.21, 24888.96 >, < 0, -179.9997, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 29052.07, -20264.71, 24256.93 >, < 0, 90.0003, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29380.97, -20294.21, 24442.11 >, < 0, -179.9997, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29380.97, -20294.21, 24292.91 >, < 0, -179.9997, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_02.rmdl", < 29052.07, -20168.01, 24042.96 >, < 0, 90.0003, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29077.37, -20294.21, 24143.71 >, < 0, -179.9997, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 29052.07, -20434.71, 24256.63 >, < 0, 90.0003, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 29052.07, -20381.91, 24886.63 >, < 0, 90.0003, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29021.77, -20294.21, 24143.71 >, < 0, -179.9997, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29021.77, -20294.21, 24741.17 >, < 0, -179.9997, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_bott.rmdl", < 29229.17, -21065.31, 24257.23 >, < 0, 90.0003, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 29052.06, -20393.01, 24470.53 >, < 0, 90.0003, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29330.56, -20294.21, 24442.11 >, < 0, -179.9997, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < 29229.17, -21065.31, 24463.63 >, < 0, 90.0003, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 29052.07, -20514.21, 24594.13 >, < -90, 90.0003, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 29052.06, -20254.51, 24681.13 >, < 0, 90.0003, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 29398.87, -20253.81, 24565.43 >, < -90, -89.9997, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29380.97, -20294.21, 24591.21 >, < 0, -179.9997, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29021.77, -20294.21, 23994.01 >, < 0, -179.9997, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29021.77, -20294.21, 24591.21 >, < 0, -179.9997, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29380.97, -20294.21, 24888.96 >, < 0, -179.9997, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29021.77, -20294.21, 24888.96 >, < 0, -179.9997, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 29052.06, -20393.01, 24256.93 >, < 0, 90.0003, 0 >, true, 5000, -1, 1 )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 29315.77, -20638.51, 24453.87 >, < -0.0001, -179.9997, 12.9107 >, false, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 29052.06, -20254.51, 24886.63 >, < 0, 90.0003, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_top.rmdl", < 29229.17, -21065.31, 24680.13 >, < 0, 90.0003, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29380.97, -20294.21, 24143.71 >, < 0, -179.9997, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 29052.07, -20514.21, 24680.83 >, < -90, 90.0003, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 29052.07, -20382.81, 24681.13 >, < 0, 90.0003, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29325.37, -20294.21, 24741.17 >, < 0, -179.9997, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < 29052.07, -20264.71, 24470.53 >, < 0, 90.0003, 0 >, true, 5000, -1, 1 )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 29141.77, -20638.51, 24453.87 >, < -0.0001, -179.9997, 12.9107 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 29141.77, -21111.01, 24482.43 >, < 0, -179.9997, 0 >, false, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 29315.77, -21111.01, 24482.43 >, < 0, -179.9997, 0 >, false, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29077.37, -20294.21, 24292.91 >, < 0, -179.9997, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29325.37, -20294.21, 24143.71 >, < 0, -179.9997, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29077.37, -20294.21, 24591.21 >, < 0, -179.9997, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_02.rmdl", < 29052.07, -19421.63, 24888.37 >, < 0, 90.0003, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29125.37, -19913.41, 24284.27 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29069.77, -19913.41, 24284.27 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29428.97, -19913.41, 24284.27 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29373.37, -19913.41, 24284.27 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29428.97, -19913.41, 24434.27 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29125.37, -19913.41, 24434.27 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29373.37, -19913.41, 24434.27 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29069.77, -19913.41, 24434.27 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29069.77, -19913.41, 24584.27 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29428.97, -19913.41, 24584.27 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29125.37, -19913.41, 24584.27 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29373.37, -19913.41, 24584.27 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29125.37, -19913.41, 24734.27 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29428.97, -19913.41, 24734.27 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29069.77, -19913.41, 24734.27 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29373.37, -19913.41, 24734.27 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/signs/street_sign_arrow.rmdl", < 29480.4, -20345.19, 23208.07 >, < -59.9999, 89.9996, 0.0003 >, true, 5000, -1, 2.39 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 25296.61, -26531.51, 22946.17 >, < 0, -37.2341, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 25399.97, -22454.31, 22710.17 >, < 0, 90.0003, 0 >, true, 5000, -1, 0.35 )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 25390.87, -22399.31, 22691.77 >, < 0, 90.0003, 0 >, true, 5000, -1, 0.35 )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 25384.37, -22518.61, 22674.96 >, < 0, 90.0003, 0 >, true, 5000, -1, 0.35 )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 25390.87, -22460.11, 22588.46 >, < 0, 90.0003, 0 >, true, 5000, -1, 0.58 )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 25399.97, -22454.31, 22664.17 >, < 0, 90.0003, 0 >, true, 5000, -1, 0.35 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 19683.67, -26210.81, 22807.67 >, < 0.0004, 0.0006, -89.9998 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_stack_01.rmdl", < 24967.9, -26762.3, 22718.2 >, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < 29373.7, -20021.1, 24097.4 >, < 0, 0, 89.9998 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 29340.92, -20532.81, 23004.37 >, < 0, 0.0005, 0 >, true, 5000, -1, 0.35 )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 29276.62, -20517.21, 22969.17 >, < 0, 0.0005, 0 >, true, 5000, -1, 0.35 )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 29335.12, -20523.71, 22882.67 >, < 0, 0.0005, 0 >, true, 5000, -1, 0.58 )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 29395.92, -20523.71, 22985.97 >, < 0, 0.0005, 0 >, true, 5000, -1, 0.35 )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 29340.92, -20532.81, 22958.37 >, < 0, 0.0005, 0 >, true, 5000, -1, 0.35 )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 29154.67, -20116.61, 23073.77 >, < 0, 179.9997, 0 >, true, 5000, -1, 0.7657141 )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 29052.37, -20116.61, 23073.77 >, < 0, 179.9997, 0 >, true, 5000, -1, 0.7657141 )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 29052.37, -20116.61, 23008.17 >, < 0, 179.9997, 0 >, true, 5000, -1, 0.7657141 )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 29154.67, -20116.61, 22997.77 >, < 0, 179.9997, 0 >, true, 5000, -1, 0.7657141 )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 29148.97, -20532.81, 22958.37 >, < 0, 0.0005, 0 >, true, 5000, -1, 0.35 )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 29148.97, -20532.81, 23004.37 >, < 0, 0.0005, 0 >, true, 5000, -1, 0.35 )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 29084.67, -20517.21, 22969.17 >, < 0, 0.0005, 0 >, true, 5000, -1, 0.35 )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 29143.17, -20523.71, 22882.67 >, < 0, 0.0005, 0 >, true, 5000, -1, 0.58 )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 29203.97, -20523.71, 22985.97 >, < 0, 0.0005, 0 >, true, 5000, -1, 0.35 )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 29525.16, -20246.26, 23004.37 >, < 0, 90.0004, 0 >, true, 5000, -1, 0.35 )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 29509.56, -20310.56, 22969.17 >, < 0, 90.0004, 0 >, true, 5000, -1, 0.35 )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 29516.07, -20252.06, 22882.67 >, < 0, 90.0004, 0 >, true, 5000, -1, 0.58 )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 29516.07, -20191.26, 22985.97 >, < 0, 90.0004, 0 >, true, 5000, -1, 0.35 )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 29525.16, -20246.26, 22958.37 >, < 0, 90.0004, 0 >, true, 5000, -1, 0.35 )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 29525.16, -20438.2, 22958.37 >, < 0, 90.0004, 0 >, true, 5000, -1, 0.35 )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 29537.47, -20438.2, 23004.37 >, < 0, 90.0004, 0 >, true, 5000, -1, 0.35 )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 29509.56, -20502.5, 22969.17 >, < 0, 90.0004, 0 >, true, 5000, -1, 0.35 )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 29527.67, -20383.21, 22985.97 >, < 0, 90.0004, 0 >, true, 5000, -1, 0.35 )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 29516.07, -20444.01, 22882.67 >, < 0, 90.0004, 0 >, true, 5000, -1, 0.58 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_wood_board_01.rmdl", < 29442.47, -20469.31, 22974.27 >, < 51.1379, -131.4282, 4.6225 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/ola/sewer_railing_01_128.rmdl", < 23005.87, -26791.71, 22720.57 >, < 0, -90.0001, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/ola/sewer_railing_01_128.rmdl", < 22881.87, -26791.71, 22720.57 >, < 0, -90.0001, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/ola/sewer_railing_01_128.rmdl", < 22757.87, -26791.71, 22720.57 >, < 0, -90.0001, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/ola/sewer_railing_01_128.rmdl", < 22633.87, -26791.71, 22720.57 >, < 0, -90.0001, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_wood_board_01.rmdl", < 22800.17, -26731.81, 22705.27 >, < 0, 0, -44.9999 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/ola/sewer_railing_01_128.rmdl", < 22633.87, -26442, 22720.57 >, < 0, 89.9999, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_wood_board_01.rmdl", < 22647.57, -26501.91, 22705.27 >, < 0, 180, -44.9999 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/ola/sewer_railing_01_128.rmdl", < 22757.87, -26442, 22720.57 >, < 0, 89.9999, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/ola/sewer_railing_01_128.rmdl", < 22881.86, -26442.01, 22720.57 >, < 0, 89.9999, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/ola/sewer_railing_01_128.rmdl", < 23005.87, -26442, 22720.57 >, < 0, 89.9999, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_wood_board_01.rmdl", < 22839.57, -26501.91, 22705.27 >, < 0, 180, -44.9999 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_wood_board_01.rmdl", < 28923.27, -20490.33, 23058.24 >, < -0.0001, -179.9997, 46.6977 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 29005.97, -20517.21, 22969.17 >, < 0, 0.0005, 0 >, true, 5000, -1, 0.35 )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 29070.27, -20532.81, 23004.37 >, < 0, 0.0005, 0 >, true, 5000, -1, 0.35 )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 29064.47, -20523.71, 22882.67 >, < 0, 0.0005, 0 >, true, 5000, -1, 0.58 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 24988.87, -21913.11, 22854.39 >, < 90, -0.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 24996.86, -21913.11, 22854.39 >, < 90, -179.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 24988.87, -21913.11, 22727.77 >, < 90, -0.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 24996.86, -21913.11, 22727.77 >, < 90, -179.9998, 0 >, true, 5000, -1, 1 )
    ClipArray.append( MapEditor_CreateProp( $"mdl/mendoko/mendoko_rubber_floor_01.rmdl", < 29458.07, -20291.01, 23133.46 >, < 0, 0, 0 >, true, 5000, -1, 1 ) )
    NoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_wood_board_01.rmdl", < 29442.27, -20467.31, 22972.77 >, < 51.1379, -131.4282, 4.6225 >, true, 5000, -1, 1 ) )

    foreach ( entity ent in ClipArray )
    {
        ent.MakeInvisible()
        ent.kv.solid = 6
        ent.kv.CollisionGroup = TRACE_COLLISION_GROUP_PLAYER
        ent.kv.contents = CONTENTS_PLAYERCLIP
    }
    foreach ( entity ent in NoClimbArray ) ent.kv.solid = 3
    foreach ( entity ent in NoGrappleNoClimbArray )
    {
        ent.MakeInvisible()
        ent.kv.solid = 3
        ent.kv.CollisionGroup = TRACE_COLLISION_GROUP_PLAYER
        ent.kv.contents = CONTENTS_SOLID | CONTENTS_NOGRAPPLE
    }
    foreach ( entity ent in NoCollisionArray ) ent.kv.solid = 0

    // VerticalZipLines
    MapEditor_CreateZiplineFromUnity( < 19501.2, -25873.8, 22714.8 >, < 0, 90.0001, 0 >, < 19501.2, -25873.8, 22164.7 >, < 0, 90.0001, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 29226.37, -20065.41, 24034.86 >, < 0, 90.0001, 0 >, < 29226.37, -20065.41, 23484.76 >, < 0, 90.0001, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 29229.57, -20142.21, 24880.22 >, < 0, -89.9996, 0 >, < 29229.57, -20142.21, 24330.13 >, < 0, -89.9996, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )

    // Buttons
    AddCallback_OnUseEntity( CreateFRButton(< 19402.37, -25749.81, 21876.2 >, < 0, 90.0005, 0 >, "%use% Back to Hub"), void function(entity panel, entity user, int input)
    {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < 10726.9000, 10287, -4283 > , < 0, -89.9998, 0 > )
      Message(user, "HUB", "\n  You now recieved Phase Walk Tactical")
      user.p.isTimerActive = false
      user.p.startTime = 0
      user.p.allowCheckpoint = false
      Remote_CallFunction_NonReplay( user, "MG_StopWatch_toggle", false)
    })

    AddCallback_OnUseEntity( CreateFRButton(< 19589.47, -25748.59, 21876.2 >, < 0, -89.9992, 0 >, "%use% Start Timer"), void function(entity panel, entity user, int input)
    {
//Start Timer Button
	user.p.isTimerActive = true
	user.p.startTime = floor( Time() ).tointeger()
	Message(user, "Timer Started!" )
	Remote_CallFunction_NonReplay( user, "MG_StopWatch_toggle", false)
	Remote_CallFunction_NonReplay( user, "MG_StopWatch_toggle", true)
    })

    AddCallback_OnUseEntity( CreateFRButton(< 29284.57, -19512.01, 24886.57 >, < 0, 0, 0 >, "%use% Back to Hub"), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< 10726.9000, 10287, -4283 >,< 0, -89.9998, 0 >)
Message(user, "Hub")
user.p.isTimerActive = false
user.p.startTime = 0
user.p.allowCheckpoint = false
Remote_CallFunction_NonReplay( user, "MG_StopWatch_toggle", false)

    })

    AddCallback_OnUseEntity( CreateFRButton(< 29172.57, -19512.01, 24886.57 >, < 0, 0, 0 >, "%use% Back to start"), void function(entity panel, entity user, int input)
    {
      EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
      TeleportFRPlayer(user,< 19500.3000, -25867.7000, 21940 > , < 0, -89.9998, 0 >)
	user.p.isTimerActive = false
	user.p.startTime = 0
	user.p.currentCheckpoint = 1
	Remote_CallFunction_NonReplay( user, "MG_StopWatch_toggle", false)
    })

    AddCallback_OnUseEntity( CreateFRButton(< 29226.47, -19618.21, 24886.57 >, < 0, 0, 0 >, "%use% Stop Timer"), void function(entity panel, entity user, int input)
    {
//Stop timer Button
      if (user.p.isTimerActive == true) {
        user.p.finalTime = floor( Time() ).tointeger() - user.p.startTime
        
	int seconds = user.p.finalTime
        
	//Display player Time
	Message(user, "Your Final Time: " + _MG_Convert_Sec_to_Time(seconds))
	
	//Add to results file
	string finalTime = user.GetPlatformUID()+ "|" + user.GetPlayerName() + "|" + _MG_Convert_Sec_to_Time(seconds) + "|" + GetUnixTimestamp() + "|Map2"
	file.allTimes.append(finalTime)
	
	//Reset Timer
	user.p.isTimerActive = false
	user.p.startTime = 0
	
	Remote_CallFunction_NonReplay( user, "MG_StopWatch_toggle", false)
	
	//Send time to killfeed and update WORLDRUI
	if(user.IsInRealm(1)){
		foreach(entity sPlayer in GetPlayerArray()){
			if(sPlayer.IsInRealm(1)){
				Remote_CallFunction_NonReplay( sPlayer, "MG_StopWatch_Obituary", seconds, user, 2)
			}
		}
	}
	  
}
    })


    // Triggers
    entity trigger_0 = MapEditor_CreateTrigger( < 25219, -22393, 21739 >, < 0, 0, 0 >, 20000, 50, false )
    trigger_0.SetEnterCallback( void function(entity trigger , entity ent)
    {
          //Big ahh trigger
      if (IsValid(ent)) {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
          if (ent.p.allowCheckpoint == true) {
            switch (ent.p.currentCheckpoint) {
              // Checkpoint 1
            case 1:
              ent.SetOrigin( < 19500.3000, -25867.7000, 21940 > )
              ent.SetAngles( < 0, 0, 0 > )
              ent.SetVelocity( < 0, 0, 0 > )
              break

              // Checkpoint 2
            case 2:
              ent.SetOrigin( < 19494, -25636, 22726 > )
              ent.SetAngles( < 0, -90, 0 > )
              ent.SetVelocity( < 0, 0, 0 > )
              break

              // Checkpoint 3
            case 3:
              ent.SetOrigin( < 22921.5, -26594.16, 22741.9 > )
              ent.SetAngles( < 0, 0, 0 > )
              ent.SetVelocity( < 0, 0, 0 > )
              break

              // Checkpoint 4
            case 4:
              ent.SetOrigin( < 24881.3, -26610.8, 22735.8 > )
              ent.SetAngles( < 0, 0, 0 > )
              ent.SetVelocity( < 0, 0, 0 > )
              break

              // Checkpoint 5
            case 5:
              ent.SetOrigin( < 25192.57, -25999.21, 22724.57 > )
              ent.SetAngles( < 0, 90, 0 > )
              ent.SetVelocity( < 0, 0, 0 > )
              break

              // Checkpoint 6
            case 6:
              ent.SetOrigin( < 25182.77, -22528.81, 22717.96 > )
              ent.SetAngles( < 0, 90, 0 > )
              ent.SetVelocity( < 0, 0, 0 > )
              break

              // Checkpoint 7
            case 7:
              ent.SetOrigin( < 25192.57, -20847.21, 23020.77 > )
              ent.SetAngles( < 0, 90, 0 > )
              ent.SetVelocity( < 0, 0, 0 > )
              break

              // Checkpoint 8
            case 8:
              ent.SetOrigin( < 25753.97, -20349.61, 23025.57 > )
              ent.SetAngles( < 0, 0, 0 > )
              ent.SetVelocity( < 0, 0, 0 > )
              break

              // Checkpoint 9
            case 9:
              ent.SetOrigin( < 29049.1, -20359.7, 23043.9 > )
              ent.SetAngles( < 0, 0, 0 > )
              ent.SetVelocity( < 0, 0, 0 > )
              break

              // Checkpoint 10
            case 10:
              ent.SetOrigin( < 29230.03, -19820.17, 24060.37 > )
              ent.SetAngles( < 0, -180, 0 > )
              ent.SetVelocity( < 0, 0, 0 > )
              break

              // Checkpoint 11
            case 11:
              ent.SetOrigin( < 29228.4, -20369.9, 24916.2 > )
              ent.SetAngles( < 0, 90, 0 > )
              ent.SetVelocity( < 0, 0, 0 > )
              break

              // is actually checkpoint 3.5
              // Checkpoint 12
            case 12:
              ent.SetOrigin( < 23807.4, -26669.4, 22740 > )
              ent.SetAngles( < 0, 90, 0 > )
              ent.SetVelocity( < 0, 0, 0 > )
              break
            }
          }
        }
      }
    })
    DispatchSpawn( trigger_0 )
    entity trigger_1 = MapEditor_CreateTrigger( < 19490.77, -25616.31, 22763.77 >, < 0, 0, 0 >, 147.0848, 29.41697, false )
    trigger_1.SetEnterCallback( void function(entity trigger , entity ent)
    {
    //set Checkpoint and shot timer
if (IsValid(ent)){
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){
		int checkpointInThisTrigger = 2
		//show checkpoint msg
		if(ent.p.currentCheckpoint != checkpointInThisTrigger)
			Remote_CallFunction_NonReplay( ent, "MG_Checkpoint_Msg")
		
		//set checkpoint
		ent.p.currentCheckpoint = checkpointInThisTrigger
        }
}
    })
    DispatchSpawn( trigger_1 )
    entity trigger_2 = MapEditor_CreateTrigger( < 25197.57, -25872.41, 22746.21 >, < 0, 0, 0 >, 192.96, 26.5964, false )
    trigger_2.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
         	  ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
        	  ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
         	  ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
         	  ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
	  ent.SetSuitGrapplePower(100)
        }
    }

    })
    DispatchSpawn( trigger_2 )
    entity trigger_3 = MapEditor_CreateTrigger( < 19542.47, -25859.01, 21899.15 >, < 0, 0, 0 >, 110.2, 50, false )
    trigger_3.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
         	  ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
        	  ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
         	  ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
         	  ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
	  ent.SetSuitGrapplePower(100)
        }
    }

    })
    DispatchSpawn( trigger_3 )
    entity trigger_4 = MapEditor_CreateTrigger( < 19500.83, -25826.5, 22282.15 >, < 0, 0, 0 >, 132.982, 26.5964, false )
    trigger_4.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
         	  ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
        	  ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
         	  ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
         	  ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
	  ent.SetSuitGrapplePower(100)
        }
    }

    })
    DispatchSpawn( trigger_4 )
    entity trigger_5 = MapEditor_CreateTrigger( < 19510.13, -25375.3, 22444.15 >, < 0, 0, 0 >, 240.7167, 10, false )
    trigger_5.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< 19500.3000, -25867.7000, 21940 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger_5 )
    entity trigger_6 = MapEditor_CreateTrigger( < 19510.13, -25040.8, 22444.15 >, < 0, 0, 0 >, 240.7167, 10, false )
    trigger_6.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< 19500.3000, -25867.7000, 21940 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger_6 )
    entity trigger_7 = MapEditor_CreateTrigger( < 19510.13, -24830.13, 22444.15 >, < 0, 0, 0 >, 240.7167, 10, false )
    trigger_7.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< 19500.3000, -25867.7000, 21940 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger_7 )
    entity trigger_8 = MapEditor_CreateTrigger( < 19500.83, -25826.5, 22748 >, < 0, 0, 0 >, 132.982, 26.5964, false )
    trigger_8.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
         	  ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
        	  ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
         	  ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
         	  ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
	  ent.SetSuitGrapplePower(100)
        }
    }

    })
    DispatchSpawn( trigger_8 )
    entity trigger_9 = MapEditor_CreateTrigger( < 22962.67, -26643.71, 22744 >, < 0, 0, 0 >, 198.8, 79.2, false )
    trigger_9.SetEnterCallback( void function(entity trigger , entity ent)
    {
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
    DispatchSpawn( trigger_9 )
    entity trigger_10 = MapEditor_CreateTrigger( < 24102, -26656.21, 22744 >, < 0, 0, 0 >, 218, 95.1, false )
    trigger_10.SetEnterCallback( void function(entity trigger , entity ent)
    {
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
    DispatchSpawn( trigger_10 )
    entity trigger_11 = MapEditor_CreateTrigger( < 24922, -26700.81, 22744 >, < 0, 0, 0 >, 132.982, 26.5964, false )
    trigger_11.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
	StatusEffect_StopAllOfType( ent, eStatusEffect.speed_boost )
	StatusEffect_StopAllOfType( ent, eStatusEffect.stim_visual_effect )
	ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
        }
    }
    })
    DispatchSpawn( trigger_11 )
    entity trigger_12 = MapEditor_CreateTrigger( < 24922, -26508.11, 22744 >, < 0, 0, 0 >, 132.982, 26.5964, false )
    trigger_12.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
	StatusEffect_StopAllOfType( ent, eStatusEffect.speed_boost )
	StatusEffect_StopAllOfType( ent, eStatusEffect.stim_visual_effect )
	ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
        }
    }
    })
    DispatchSpawn( trigger_12 )
    entity trigger_13 = MapEditor_CreateTrigger( < 24922, -26599.71, 22744 >, < 0, 0, 0 >, 132.982, 26.5964, false )
    trigger_13.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
	StatusEffect_StopAllOfType( ent, eStatusEffect.speed_boost )
	StatusEffect_StopAllOfType( ent, eStatusEffect.stim_visual_effect )
	ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
        }
    }
    })
    DispatchSpawn( trigger_13 )
    entity trigger_14 = MapEditor_CreateTrigger( < 25209.97, -20819.28, 23014.56 >, < 0, 0, 0 >, 132.982, 26.5964, false )
    trigger_14.SetEnterCallback( void function(entity trigger , entity ent)
    {
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
    DispatchSpawn( trigger_14 )
    entity trigger_15 = MapEditor_CreateTrigger( < 19863.07, -25738.61, 22652.9 >, < 0, 0, 0 >, 115.3, 10, false )
    trigger_15.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< 19494, -25636, 22726 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger_15 )
    entity trigger_16 = MapEditor_CreateTrigger( < 25255.27, -22481.61, 22744 >, < 0, 89.9998, 0 >, 132.982, 26.5964, false )
    trigger_16.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
	StatusEffect_StopAllOfType( ent, eStatusEffect.speed_boost )
	StatusEffect_StopAllOfType( ent, eStatusEffect.stim_visual_effect )
	ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
        }
    }
    })
    DispatchSpawn( trigger_16 )
    entity trigger_17 = MapEditor_CreateTrigger( < 25154.17, -22481.61, 22744 >, < 0, 89.9998, 0 >, 132.982, 26.5964, false )
    trigger_17.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
	StatusEffect_StopAllOfType( ent, eStatusEffect.speed_boost )
	StatusEffect_StopAllOfType( ent, eStatusEffect.stim_visual_effect )
	ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
        }
    }
    })
    DispatchSpawn( trigger_17 )
    entity trigger_18 = MapEditor_CreateTrigger( < 25154.17, -22321.01, 22744 >, < 0, 89.9998, 0 >, 132.982, 26.5964, false )
    trigger_18.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
	StatusEffect_StopAllOfType( ent, eStatusEffect.speed_boost )
	StatusEffect_StopAllOfType( ent, eStatusEffect.stim_visual_effect )
	ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
        }
    }
    })
    DispatchSpawn( trigger_18 )
    entity trigger_19 = MapEditor_CreateTrigger( < 25255.27, -22321.01, 22744 >, < 0, 89.9998, 0 >, 132.982, 26.5964, false )
    trigger_19.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
	StatusEffect_StopAllOfType( ent, eStatusEffect.speed_boost )
	StatusEffect_StopAllOfType( ent, eStatusEffect.stim_visual_effect )
	ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
        }
    }
    })
    DispatchSpawn( trigger_19 )
    entity trigger_20 = MapEditor_CreateTrigger( < 29065.07, -20366.81, 23031.77 >, < 0, 0, 0 >, 167.6, 26.5964, false )
    trigger_20.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
	StatusEffect_StopAllOfType( ent, eStatusEffect.speed_boost )
	StatusEffect_StopAllOfType( ent, eStatusEffect.stim_visual_effect )
	ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
        }
    }
    })
    DispatchSpawn( trigger_20 )
    entity trigger_21 = MapEditor_CreateTrigger( < 25784.27, -20354.41, 23014.77 >, < 0, 0, 0 >, 262, 115, false )
    trigger_21.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
         	  ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
        	  ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
         	  ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
         	  ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
	  ent.SetSuitGrapplePower(100)
        }
    }

    })
    DispatchSpawn( trigger_21 )
    entity trigger_22 = MapEditor_CreateTrigger( < 29206.77, -20366.81, 23031.77 >, < 0, 0, 0 >, 167.6, 26.5964, false )
    trigger_22.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
	StatusEffect_StopAllOfType( ent, eStatusEffect.speed_boost )
	StatusEffect_StopAllOfType( ent, eStatusEffect.stim_visual_effect )
	ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
        }
    }
    })
    DispatchSpawn( trigger_22 )
    entity trigger_23 = MapEditor_CreateTrigger( < 29272.07, -20366.81, 23031.77 >, < 0, 0, 0 >, 167.6, 26.5964, false )
    trigger_23.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
	StatusEffect_StopAllOfType( ent, eStatusEffect.speed_boost )
	StatusEffect_StopAllOfType( ent, eStatusEffect.stim_visual_effect )
	ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
        }
    }
    })
    DispatchSpawn( trigger_23 )
    entity trigger_24 = MapEditor_CreateTrigger( < 22647.77, -26623.41, 22763.77 >, < 0, 0, 0 >, 147.0848, 29.41697, false )
    trigger_24.SetEnterCallback( void function(entity trigger , entity ent)
    {
    //set Checkpoint and shot timer
if (IsValid(ent)){
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){
		int checkpointInThisTrigger = 3
		//show checkpoint msg
		if(ent.p.currentCheckpoint != checkpointInThisTrigger)
			Remote_CallFunction_NonReplay( ent, "MG_Checkpoint_Msg")
		
		//set checkpoint
		ent.p.currentCheckpoint = checkpointInThisTrigger
        }
}
    })
    DispatchSpawn( trigger_24 )
    entity trigger_25 = MapEditor_CreateTrigger( < 24923.77, -26623.41, 22763.77 >, < 0, 0, 0 >, 147.0848, 29.41697, false )
    trigger_25.SetEnterCallback( void function(entity trigger , entity ent)
    {
    //set Checkpoint and shot timer
if (IsValid(ent)){
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){
		int checkpointInThisTrigger = 4
		//show checkpoint msg
		if(ent.p.currentCheckpoint != checkpointInThisTrigger)
			Remote_CallFunction_NonReplay( ent, "MG_Checkpoint_Msg")
		
		//set checkpoint
		ent.p.currentCheckpoint = checkpointInThisTrigger
        }
}
    })
    DispatchSpawn( trigger_25 )
    entity trigger_26 = MapEditor_CreateTrigger( < 25199.87, -22422.61, 22763.46 >, < 0, 0, 0 >, 147.0848, 29.41697, false )
    trigger_26.SetEnterCallback( void function(entity trigger , entity ent)
    {
    //set Checkpoint and shot timer
if (IsValid(ent)){
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){
		int checkpointInThisTrigger = 6
		//show checkpoint msg
		if(ent.p.currentCheckpoint != checkpointInThisTrigger)
			Remote_CallFunction_NonReplay( ent, "MG_Checkpoint_Msg")
		
		//set checkpoint
		ent.p.currentCheckpoint = checkpointInThisTrigger
        }
}
    })
    DispatchSpawn( trigger_26 )
    entity trigger_27 = MapEditor_CreateTrigger( < 25207.17, -20823.51, 23062.67 >, < 0, 0, 0 >, 147.0848, 29.41697, false )
    trigger_27.SetEnterCallback( void function(entity trigger , entity ent)
    {
    //set Checkpoint and shot timer
if (IsValid(ent)){
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){
		int checkpointInThisTrigger = 7
		//show checkpoint msg
		if(ent.p.currentCheckpoint != checkpointInThisTrigger)
			Remote_CallFunction_NonReplay( ent, "MG_Checkpoint_Msg")
		
		//set checkpoint
		ent.p.currentCheckpoint = checkpointInThisTrigger
        }
}
    })
    DispatchSpawn( trigger_27 )
    entity trigger_28 = MapEditor_CreateTrigger( < 29095.37, -20354.41, 23062.67 >, < 0, 0, 0 >, 147.0848, 29.41697, false )
    trigger_28.SetEnterCallback( void function(entity trigger , entity ent)
    {
    //set Checkpoint and shot timer
if (IsValid(ent)){
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){
		int checkpointInThisTrigger = 9
		//show checkpoint msg
		if(ent.p.currentCheckpoint != checkpointInThisTrigger)
			Remote_CallFunction_NonReplay( ent, "MG_Checkpoint_Msg")
		
		//set checkpoint
		ent.p.currentCheckpoint = checkpointInThisTrigger
        }
}
    })
    DispatchSpawn( trigger_28 )
    entity trigger_29 = MapEditor_CreateTrigger( < 29235.3, -19566.9, 23764.22 >, < 0, 0, 0 >, 240.7167, 10, false )
    trigger_29.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< 29243.9, -20067.04, 23203.72 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger_29 )
    entity trigger_30 = MapEditor_CreateTrigger( < 29226, -19846.31, 23219.22 >, < 0, 0, 0 >, 200, 50, false )
    trigger_30.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
         	  ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
        	  ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
         	  ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
         	  ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
	  ent.SetSuitGrapplePower(100)
        }
    }

    })
    DispatchSpawn( trigger_30 )
    entity trigger_31 = MapEditor_CreateTrigger( < 29215.94, -19807.92, 24083.83 >, < 0, 0, 0 >, 147.0848, 29.41697, false )
    trigger_31.SetEnterCallback( void function(entity trigger , entity ent)
    {
    //set Checkpoint and shot timer
if (IsValid(ent)){
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){
		int checkpointInThisTrigger = 10
		//show checkpoint msg
		if(ent.p.currentCheckpoint != checkpointInThisTrigger)
			Remote_CallFunction_NonReplay( ent, "MG_Checkpoint_Msg")
		
		//set checkpoint
		ent.p.currentCheckpoint = checkpointInThisTrigger
        }
}
    })
    DispatchSpawn( trigger_31 )
    entity trigger_32 = MapEditor_CreateTrigger( < 29241.77, -19354.41, 23000.77 >, < 0, 0, 0 >, 215, 1, false )
    trigger_32.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< 29243.9, -20067.04, 23203.72 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger_32 )
    entity trigger_33 = MapEditor_CreateTrigger( < 29226, -20018.1, 23602.22 >, < 0, 0, 0 >, 132.982, 26.5964, false )
    trigger_33.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
         	  ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
        	  ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
         	  ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
         	  ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
	  ent.SetSuitGrapplePower(100)
        }
    }

    })
    DispatchSpawn( trigger_33 )
    entity trigger_34 = MapEditor_CreateTrigger( < 29235.3, -19232.4, 23764.22 >, < 0, 0, 0 >, 240.7167, 10, false )
    trigger_34.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< 29243.9, -20067.04, 23203.72 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger_34 )
    entity trigger_35 = MapEditor_CreateTrigger( < 29226, -20018.1, 24068.07 >, < 0, 0, 0 >, 132.982, 26.5964, false )
    trigger_35.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
         	  ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
        	  ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
         	  ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
         	  ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
	  ent.SetSuitGrapplePower(100)
        }
    }

    })
    DispatchSpawn( trigger_35 )
    entity trigger_36 = MapEditor_CreateTrigger( < 29235.3, -19021.74, 23764.22 >, < 0, 0, 0 >, 240.7167, 10, false )
    trigger_36.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< 29243.9, -20067.04, 23203.72 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger_36 )
    entity trigger_37 = MapEditor_CreateTrigger( < 29220.64, -20640.71, 24609.58 >, < 0, -179.9997, 0 >, 240.7167, 10, false )
    trigger_37.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< 29230.03, -19820.17, 24060.37 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger_37 )
    entity trigger_38 = MapEditor_CreateTrigger( < 29240, -20399.7, 24929.19 >, < 0, -179.9997, 0 >, 147.0848, 29.41697, false )
    trigger_38.SetEnterCallback( void function(entity trigger , entity ent)
    {
    //set Checkpoint and shot timer
if (IsValid(ent)){
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){
		int checkpointInThisTrigger = 11
		//show checkpoint msg
		if(ent.p.currentCheckpoint != checkpointInThisTrigger)
			Remote_CallFunction_NonReplay( ent, "MG_Checkpoint_Msg")
		
		//set checkpoint
		ent.p.currentCheckpoint = checkpointInThisTrigger
        }
}
    })
    DispatchSpawn( trigger_38 )
    entity trigger_39 = MapEditor_CreateTrigger( < 29222.67, -20934.51, 24027.27 >, < 0, -179.9997, 0 >, 205.7, 1, false )
    trigger_39.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< 29230.03, -19820.17, 24060.37 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger_39 )
    entity trigger_40 = MapEditor_CreateTrigger( < 29229.94, -20189.51, 24447.58 >, < 0, -179.9997, 0 >, 132.982, 26.5964, false )
    trigger_40.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
         	  ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
        	  ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
         	  ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
         	  ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
	  ent.SetSuitGrapplePower(100)
        }
    }

    })
    DispatchSpawn( trigger_40 )
    entity trigger_41 = MapEditor_CreateTrigger( < 29229.94, -20189.51, 24064.58 >, < 0, -179.9997, 0 >, 200, 50, false )
    trigger_41.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
         	  ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
        	  ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
         	  ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
         	  ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
	  ent.SetSuitGrapplePower(100)
        }
    }

    })
    DispatchSpawn( trigger_41 )
    entity trigger_42 = MapEditor_CreateTrigger( < 29220.64, -20975.21, 24609.58 >, < 0, -179.9997, 0 >, 240.7167, 10, false )
    trigger_42.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< 29230.03, -19820.17, 24060.37 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger_42 )
    entity trigger_43 = MapEditor_CreateTrigger( < 29220.64, -21185.88, 24609.58 >, < 0, -179.9997, 0 >, 240.7167, 10, false )
    trigger_43.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< 29230.03, -19820.17, 24060.37 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger_43 )
    entity trigger_44 = MapEditor_CreateTrigger( < 29241.77, -19058.41, 23000.77 >, < 0, 0, 0 >, 215, 1, false )
    trigger_44.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< 29243.9, -20067.04, 23203.72 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger_44 )
    entity trigger_45 = MapEditor_CreateTrigger( < 19449.57, -25859.01, 21899.15 >, < 0, 0, 0 >, 110.2, 50, false )
    trigger_45.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
         	  ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
        	  ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
         	  ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
         	  ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
	  ent.SetSuitGrapplePower(100)
        }
    }

    })
    DispatchSpawn( trigger_45 )
    entity trigger_46 = MapEditor_CreateTrigger( < 19493.67, -25648.31, 21899.15 >, < 0, 0, 0 >, 110.2, 50, false )
    trigger_46.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
         	  ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
        	  ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
         	  ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
         	  ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
	  ent.SetSuitGrapplePower(100)
        }
    }

    })
    DispatchSpawn( trigger_46 )
    entity trigger_47 = MapEditor_CreateTrigger( < 19500.83, -26276.91, 22748 >, < 0, 0, 0 >, 132.982, 26.5964, false )
    trigger_47.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
         	  ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
        	  ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
         	  ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
         	  ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
	  ent.SetSuitGrapplePower(100)
        }
    }

    })
    DispatchSpawn( trigger_47 )
    entity trigger_48 = MapEditor_CreateTrigger( < 25200.77, -25921.41, 22763.77 >, < 0, 0, 0 >, 147.0848, 29.41697, false )
    trigger_48.SetEnterCallback( void function(entity trigger , entity ent)
    {
    //set Checkpoint and shot timer
if (IsValid(ent)){
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){
		int checkpointInThisTrigger = 5
		//show checkpoint msg
		if(ent.p.currentCheckpoint != checkpointInThisTrigger)
			Remote_CallFunction_NonReplay( ent, "MG_Checkpoint_Msg")
		
		//set checkpoint
		ent.p.currentCheckpoint = checkpointInThisTrigger
        }
}
    })
    DispatchSpawn( trigger_48 )
    entity trigger_49 = MapEditor_CreateTrigger( < 25789.07, -20363.41, 23062.67 >, < 0, 0, 0 >, 147.0848, 29.41697, false )
    trigger_49.SetEnterCallback( void function(entity trigger , entity ent)
    {
    //set Checkpoint and shot timer
if (IsValid(ent)){
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){
		int checkpointInThisTrigger = 8
		//show checkpoint msg
		if(ent.p.currentCheckpoint != checkpointInThisTrigger)
			Remote_CallFunction_NonReplay( ent, "MG_Checkpoint_Msg")
		
		//set checkpoint
		ent.p.currentCheckpoint = checkpointInThisTrigger
        }
}
    })
    DispatchSpawn( trigger_49 )
    entity trigger_50 = MapEditor_CreateTrigger( < 23836.77, -26623.41, 22763.77 >, < 0, 0, 0 >, 147.0848, 29.41697, false )
    trigger_50.SetEnterCallback( void function(entity trigger , entity ent)
    {
    //set Checkpoint and shot timer
if (IsValid(ent)){
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){
		int checkpointInThisTrigger = 12
		//show checkpoint msg
		if(ent.p.currentCheckpoint != checkpointInThisTrigger)
			Remote_CallFunction_NonReplay( ent, "MG_Checkpoint_Msg")
		
		//set checkpoint
		ent.p.currentCheckpoint = checkpointInThisTrigger
        }
}
    })
    DispatchSpawn( trigger_50 )
    entity trigger_51 = MapEditor_CreateTrigger( < 19490.77, -25976.81, 22763.77 >, < 0, 0, 0 >, 147.0848, 29.41697, false )
    trigger_51.SetEnterCallback( void function(entity trigger , entity ent)
    {
    //set Checkpoint and shot timer
if (IsValid(ent)){
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){
		int checkpointInThisTrigger = 2
		//show checkpoint msg
		if(ent.p.currentCheckpoint != checkpointInThisTrigger)
			Remote_CallFunction_NonReplay( ent, "MG_Checkpoint_Msg")
		
		//set checkpoint
		ent.p.currentCheckpoint = checkpointInThisTrigger
        }
}
    })
    DispatchSpawn( trigger_51 )
    entity trigger_52 = MapEditor_CreateTrigger( < 29241.77, -18781.41, 23000.77 >, < 0, 0, 0 >, 215, 1, false )
    trigger_52.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< 29243.9, -20067.04, 23203.72 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger_52 )
    entity trigger_53 = MapEditor_CreateTrigger( < 29241.77, -18545.41, 23000.77 >, < 0, 0, 0 >, 215, 1, false )
    trigger_53.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< 29243.9, -20067.04, 23203.72 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger_53 )
    entity trigger_54 = MapEditor_CreateTrigger( < 29241.77, -18343.41, 23000.77 >, < 0, 0, 0 >, 215, 1, false )
    trigger_54.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< 29243.9, -20067.04, 23203.72 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger_54 )
    entity trigger_55 = MapEditor_CreateTrigger( < 29241.77, -18047.41, 23000.77 >, < 0, 0, 0 >, 215, 1, false )
    trigger_55.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< 29243.9, -20067.04, 23203.72 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger_55 )
    entity trigger_56 = MapEditor_CreateTrigger( < 29222.67, -21135.61, 24027.27 >, < 0, -179.9997, 0 >, 205.7, 1, false )
    trigger_56.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< 29230.03, -19820.17, 24060.37 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger_56 )
    entity trigger_57 = MapEditor_CreateTrigger( < 29222.67, -21367.71, 24027.27 >, < 0, -179.9997, 0 >, 205.7, 1, false )
    trigger_57.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< 29230.03, -19820.17, 24060.37 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger_57 )
    entity trigger_58 = MapEditor_CreateTrigger( < 29222.67, -21586.61, 24027.27 >, < 0, -179.9997, 0 >, 205.7, 1, false )
    trigger_58.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< 29230.03, -19820.17, 24060.37 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger_58 )
    entity trigger_59 = MapEditor_CreateTrigger( < 29222.67, -21716.21, 24027.27 >, < 0, -179.9997, 0 >, 205.7, 1, false )
    trigger_59.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
            ent.SetOrigin(< 29230.03, -19820.17, 24060.37 >) // change tp location
        }
    }
    })
    DispatchSpawn( trigger_59 )

    // Func Window Hints
    MapEditor_CreateFuncWindowHint( < 29450.57, -20272.81, 23085.87 >, 33.5, 45.4, < 0, -1, 0 > )


}

//Init Map3 Loy
void 
function MovementGym_Map3() {

    //Starting Origin, Change this to a origin in a map 
    vector startingorg = < 0, 0, 0 >

    // Props Array
    array < entity > ClipArray; array < entity > NoClimbArray; array < entity > InvisibleArray; array < entity > NoGrappleArray; array < entity > ClipInvisibleNoGrappleNoClimbArray; array < entity > NoCollisionArray; 

    // Props
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < 4788, 26994, 23847 > + startingorg, < 0, -179.9997, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 4525.967, 27308, 23794 > + startingorg, < 0, 89.9999, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 4525.969, 27308, 24048 > + startingorg, < 0, 89.9999, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3762.971, 26695, 23794.32 > + startingorg, < 0, -89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 4525.967, 27308, 23921 > + startingorg, < 0, 89.9999, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3762.971, 26695, 23666.82 > + startingorg, < 0, -89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3762.971, 26695, 23539.72 > + startingorg, < 0, -89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3762.971, 26695, 23921.72 > + startingorg, < 0, -89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3762.971, 26695, 24049.02 > + startingorg, < 0, -89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 4083.966, 27004, 23851 > + startingorg, < 0, -89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 4525.967, 27308, 23539 > + startingorg, < 0, 89.9999, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 4525.967, 27308, 23666 > + startingorg, < 0, 89.9999, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_02.rmdl", < 5621.002, 21689, 24833 > + startingorg, < 0, -89.9995, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/vending_machine_02.rmdl", < -5667.061, 19546.4, 23753.31 > + startingorg, < 0, 179.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/vending_machine_05.rmdl", < -5692.91, 19223.12, 23753.2 > + startingorg, < 0, -45.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/signs/desertlands_city_newdawn_sign_01.rmdl", < -6130.825, 19897.89, 23753.35 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/angel_city/vending_machine.rmdl", < -6580.142, 19541.84, 23753.31 > + startingorg, < 0, -0.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_cafeteria_table_01.rmdl", < -5897.827, 19403.62, 23753.16 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/garbage/trash_can_metal_01_a.rmdl", < -5777.175, 19897.38, 23753.15 > + startingorg, < 0, -0.0202, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/garbage/trash_can_metal_02_a.rmdl", < -5810.474, 19897.38, 23753.15 > + startingorg, < 0, -0.0202, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_cafeteria_table_01.rmdl", < -6368.826, 19683.13, 23753.16 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_cafeteria_table_01.rmdl", < -5897.826, 19679.13, 23753.16 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/highrise_rectangle_top_01.rmdl", < -6131.826, 19544.38, 23718.87 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_cafeteria_table_01.rmdl", < -6368.827, 19407.62, 23753.16 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/garbage/trash_can_metal_02_a.rmdl", < -6489.475, 19897.38, 23753.15 > + startingorg, < 0, -0.0202, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/vending_machine_06.rmdl", < -6548.084, 19198.46, 23753.2 > + startingorg, < 0, -135.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/garbage/trash_can_metal_01_a.rmdl", < -6456.175, 19897.38, 23753.15 > + startingorg, < 0, -0.0202, 0 >, true, 5000, -1, 1 )
    ClipInvisibleNoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_rectangle_top_01.rmdl", < -5962.505, 26225, 23365.31 > + startingorg, < 0, 89.9998, 90 >, true, 5000, -1, 1 ) )
    ClipInvisibleNoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_rectangle_top_01.rmdl", < -6123.505, 26444, 23833.31 > + startingorg, < 0, 179.9999, 90 >, true, 5000, -1, 1 ) )
    ClipInvisibleNoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_rectangle_top_01.rmdl", < -6295.505, 26227, 23365.31 > + startingorg, < 0, -89.9999, 90 >, true, 5000, -1, 1 ) )
    ClipInvisibleNoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_rectangle_top_01.rmdl", < -2984.505, 26461.99, 23517.31 > + startingorg, < 0, 89.9998, 90 >, true, 5000, -1, 1 ) )
    ClipInvisibleNoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_rectangle_top_01.rmdl", < -2984.505, 26461.99, 24333.31 > + startingorg, < 0, 89.9998, 90 >, true, 5000, -1, 1 ) )
    ClipInvisibleNoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_rectangle_top_01.rmdl", < -2984.503, 26957.99, 24854.31 > + startingorg, < 0, 89.9998, 90 >, true, 5000, -1, 1 ) )
    ClipInvisibleNoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_rectangle_top_01.rmdl", < -2984.501, 27550.99, 24333.31 > + startingorg, < 0, 89.9998, 90 >, true, 5000, -1, 1 ) )
    ClipInvisibleNoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_rectangle_top_01.rmdl", < -2984.501, 27550.99, 23517.31 > + startingorg, < 0, 89.9998, 90 >, true, 5000, -1, 1 ) )
    ClipInvisibleNoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_rectangle_top_01.rmdl", < -2986.504, 26851.19, 23517.31 > + startingorg, < 0, 0, 90 >, true, 5000, -1, 1 ) )
    ClipInvisibleNoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_rectangle_top_01.rmdl", < -2986.502, 27166.59, 23517.31 > + startingorg, < 0, -179.9997, 90 >, true, 5000, -1, 1 ) )
    ClipInvisibleNoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_rectangle_top_01.rmdl", < -2612.903, 27028.99, 24333.31 > + startingorg, < 0, 89.9998, 90 >, true, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_cafeteria_table_01.rmdl", < 3523.062, 20285.99, 24686.25 > + startingorg, < 0, -134.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/garbage/trash_can_metal_02_a.rmdl", < 3112.16, 19998.62, 24686.24 > + startingorg, < 0, 134.9802, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/garbage/trash_can_metal_02_a.rmdl", < 3592.286, 19518.5, 24686.24 > + startingorg, < 0, 134.9802, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/highrise_rectangle_top_01.rmdl", < 3589, 20021, 24651.96 > + startingorg, < 0, -134.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/vending_machine_05.rmdl", < 3505.798, 20558.52, 24686.3 > + startingorg, < 0, 90.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_cafeteria_table_01.rmdl", < 3658.467, 19755.3, 24686.25 > + startingorg, < 0, -134.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/vending_machine_06.rmdl", < 4127.935, 19971.26, 24686.3 > + startingorg, < 0, 0.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/vending_machine_02.rmdl", < 3258.932, 20348.21, 24686.4 > + startingorg, < 0, -44.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/garbage/trash_can_metal_01_a.rmdl", < 3568.743, 19542.04, 24686.24 > + startingorg, < 0, 134.9802, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/angel_city/vending_machine.rmdl", < 3907.804, 19705.79, 24686.4 > + startingorg, < 0, 135.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/signs/desertlands_city_newdawn_sign_01.rmdl", < 3857.677, 20291.17, 24686.44 > + startingorg, < 0, -134.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/garbage/trash_can_metal_01_a.rmdl", < 3088.613, 20022.16, 24686.24 > + startingorg, < 0, 134.9802, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_cafeteria_table_01.rmdl", < 3328.25, 20091.17, 24686.25 > + startingorg, < 0, -134.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_cafeteria_table_01.rmdl", < 3853.283, 19950.11, 24686.25 > + startingorg, < 0, -134.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_02.rmdl", < -6306.821, 20963.38, 23746.46 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/signs/desertlands_city_streetsign_01.rmdl", < -6294.805, 20646.38, 23767.77 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/lamps/floor_standing_ambient_light.rmdl", < -6294.822, 20382.67, 23752.46 > + startingorg, < 0, -89.9888, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/lamps/floor_standing_ambient_light.rmdl", < -5966.544, 20382.72, 23752.46 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < -6285.017, 22685.48, 23287.96 > + startingorg, < 90, -0.0002, 0 >, true, 5000, -1, 1 ) )
    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < -6285.318, 22041.88, 23057.15 > + startingorg, < 90, -0.0002, 0 >, true, 5000, -1, 1 ) )
    ClipInvisibleNoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < -6285.318, 22041.88, 24078 > + startingorg, < 90, -0.0002, 0 >, true, 5000, -1, 1 ) )
    ClipInvisibleNoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < -6285.318, 21534.4, 24285 > + startingorg, < 90, -0.0002, 0 >, true, 5000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < -6287.303, 21184.4, 23304 > + startingorg, < 90, -90, 0 >, true, 5000, -1, 1 ) )
    ClipInvisibleNoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < -6639.303, 21535.4, 23304 > + startingorg, < 89.9802, 89.9997, 0 >, true, 5000, -1, 1 ) )
    ClipInvisibleNoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < -6639.303, 22043.4, 23304 > + startingorg, < 89.9802, 89.9997, 0 >, true, 5000, -1, 1 ) )
    ClipInvisibleNoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < -6287.303, 21691.4, 23304 > + startingorg, < 90, -90, 0 >, true, 5000, -1, 1 ) )
    ClipInvisibleNoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < -6287.303, 21184.4, 24291.81 > + startingorg, < 90, -90, 0 >, true, 5000, -1, 1 ) )
    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < -6286, 21534.4, 23262 > + startingorg, < 90, -0.0002, 0 >, true, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/garbage/trash_can_metal_01_a.rmdl", < -6293.48, 22729.5, 23053 > + startingorg, < 0, -90.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/garbage/trash_can_metal_02_a.rmdl", < -5967.481, 22513.5, 23053 > + startingorg, < 0, 90.0038, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/garbage/trash_can_metal_01_a.rmdl", < -5967.48, 22729.5, 23053 > + startingorg, < 0, 90.0038, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/lamps/light_parking_post.rmdl", < -6131.477, 23201.5, 23046.64 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    NoGrappleArray.append( MapEditor_CreateProp( $"mdl/barriers/guard_rail_01_256.rmdl", < -5967.483, 22335.5, 23060.85 > + startingorg, < 0, 179.9998, 0 >, true, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/garbage/trash_can_metal_02_a.rmdl", < -6293.482, 22513.5, 23053 > + startingorg, < 0, -90.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/domestic/city_bench_dirty_blue.rmdl", < -6306.481, 22620.5, 23053 > + startingorg, < 0, -0.0002, 0 >, true, 5000, -1, 1 )
    NoGrappleArray.append( MapEditor_CreateProp( $"mdl/barriers/guard_rail_01_256.rmdl", < -6288.483, 22335.5, 23060.85 > + startingorg, < 0, -0.0002, 0 >, true, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/domestic/city_bench_dirty_blue.rmdl", < -5954.481, 22622.5, 23053 > + startingorg, < 0, -179.9962, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/lamps/light_parking_post.rmdl", < 157.5581, 27000.45, 23889.15 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01_open.rmdl", < -6203.411, 26821.06, 23432.65 > + startingorg, < -0.0099, 0.0136, 35.7129 >, true, 5000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01_open.rmdl", < -6203.411, 26655.94, 23302.2 > + startingorg, < -0.012, 0.0118, 45 >, true, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/garbage/trash_can_metal_01_a.rmdl", < -5967.514, 25917, 23053 > + startingorg, < 0, 90.0038, 0 >, true, 5000, -1, 1 )
    NoGrappleArray.append( MapEditor_CreateProp( $"mdl/barriers/guard_rail_01_256.rmdl", < -5967.491, 26094.96, 23059.99 > + startingorg, < 0, 179.9998, 0 >, true, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/barriers/guard_rail_01_128.rmdl", < -6288.49, 26319.96, 23059.99 > + startingorg, < 0, -0.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/barriers/guard_rail_01_128.rmdl", < -5967.49, 26319.96, 23059.99 > + startingorg, < 0, 179.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/garbage/trash_can_metal_01_a.rmdl", < -6293.506, 25917, 23053 > + startingorg, < 0, -90.0002, 0 >, true, 5000, -1, 1 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/signs/desertlands_city_streetsign_01.rmdl", < -6293.618, 26051.46, 23068.61 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 ) )
    NoGrappleArray.append( MapEditor_CreateProp( $"mdl/barriers/guard_rail_01_256.rmdl", < -6288.491, 26094.96, 23059.99 > + startingorg, < 0, -0.0002, 0 >, true, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/industrial/modular_railing_trim_long.rmdl", < -4933.56, 26846.45, 23679.63 > + startingorg, < 0, 179.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/modular_railing_trim_long.rmdl", < -5193.308, 27183.42, 23679.63 > + startingorg, < 0, 179.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/modular_railing_trim_long.rmdl", < -5128.06, 26846.45, 23679.63 > + startingorg, < 0, 179.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/modular_railing_trim_long.rmdl", < -5387.81, 26846.45, 23679.63 > + startingorg, < 0, 179.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/modular_railing_trim_long.rmdl", < -5387.808, 27183.42, 23679.63 > + startingorg, < 0, 179.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/modular_railing_trim_long.rmdl", < -5322.81, 26846.45, 23679.63 > + startingorg, < 0, 179.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_02.rmdl", < -4925.411, 27191.04, 23673.12 > + startingorg, < 0, -0.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/modular_railing_trim_long.rmdl", < -5063.06, 26846.45, 23679.63 > + startingorg, < 0, 179.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/modular_railing_trim_long.rmdl", < -5258.31, 26846.45, 23679.63 > + startingorg, < 0, 179.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/modular_railing_trim_long.rmdl", < -5193.31, 26846.45, 23679.63 > + startingorg, < 0, 179.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/modular_railing_trim_long.rmdl", < -5322.808, 27183.42, 23679.63 > + startingorg, < 0, 179.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/modular_railing_trim_long.rmdl", < -4933.558, 27183.42, 23679.63 > + startingorg, < 0, 179.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/modular_railing_trim_long.rmdl", < -5258.308, 27183.42, 23679.63 > + startingorg, < 0, 179.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/modular_railing_trim_long.rmdl", < -4998.56, 26846.45, 23679.63 > + startingorg, < 0, 179.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/modular_railing_trim_long.rmdl", < -5063.058, 27183.42, 23679.63 > + startingorg, < 0, 179.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/modular_railing_trim_long.rmdl", < -4998.558, 27183.42, 23679.63 > + startingorg, < 0, 179.9998, 0 >, true, 5000, -1, 1 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/signs/desertlands_city_streetsign_01.rmdl", < -5220.597, 27173.32, 23691.59 > + startingorg, < 0, -0.0002, 0 >, true, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/industrial/modular_railing_trim_long.rmdl", < -5509.635, 27183.42, 23679.63 > + startingorg, < 0, -0.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/modular_railing_trim_long.rmdl", < -5128.058, 27183.42, 23679.63 > + startingorg, < 0, 179.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/modular_railing_trim_long.rmdl", < -5509.637, 26846.45, 23679.63 > + startingorg, < 0, -0.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/lamps/floor_standing_ambient_light.rmdl", < -5507.476, 26855, 23678.41 > + startingorg, < 0, -0.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/lamps/floor_standing_ambient_light.rmdl", < -5507.475, 27174, 23678.41 > + startingorg, < 0, 179.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/modular_railing_trim_long.rmdl", < -4475.542, 27131, 23667.64 > + startingorg, < 0, -0.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/modular_railing_trim_long.rmdl", < -4368.465, 26883.99, 23667.64 > + startingorg, < 0, 179.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/modular_railing_trim_long.rmdl", < -4239.465, 26883.99, 23667.64 > + startingorg, < 0, 179.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/modular_railing_trim_long.rmdl", < -4368.464, 27130.99, 23667.64 > + startingorg, < 0, 179.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/modular_railing_trim_long.rmdl", < -4304.465, 26883.99, 23667.64 > + startingorg, < 0, 179.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/modular_railing_trim_long.rmdl", < -4304.464, 27130.99, 23667.64 > + startingorg, < 0, 179.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/modular_railing_trim_long.rmdl", < -4475.542, 26884, 23667.64 > + startingorg, < 0, -0.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/modular_railing_trim_long.rmdl", < -4239.464, 27130.99, 23667.64 > + startingorg, < 0, 179.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -4361.503, 27009, 23652 > + startingorg, < 0, -0.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/modular_railing_trim_long.rmdl", < -3214.542, 26883.99, 24176.64 > + startingorg, < 0, -0.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/modular_railing_trim_long.rmdl", < -3856.464, 27130.99, 23794.64 > + startingorg, < 0, 179.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/modular_railing_trim_long.rmdl", < -3214.542, 27130.99, 24176.64 > + startingorg, < 0, -0.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/modular_railing_trim_long.rmdl", < -3970.542, 27130.99, 23794.64 > + startingorg, < 0, -0.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/modular_railing_trim_long.rmdl", < -3970.542, 26883.99, 23794.64 > + startingorg, < 0, -0.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/modular_railing_trim_long.rmdl", < -4174.465, 27130.99, 23667.64 > + startingorg, < 0, 179.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/modular_railing_trim_long.rmdl", < -3602.464, 26883.99, 23920.64 > + startingorg, < 0, 179.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/modular_railing_trim_long.rmdl", < -3856.464, 26883.99, 23794.64 > + startingorg, < 0, 179.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/modular_railing_trim_long.rmdl", < -3462.542, 26883.99, 24048.64 > + startingorg, < 0, -0.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/modular_railing_trim_long.rmdl", < -2976.464, 27130.99, 24176.64 > + startingorg, < 0, 179.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/modular_railing_trim_long.rmdl", < -3716.542, 26883.99, 23920.64 > + startingorg, < 0, -0.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/modular_railing_trim_long.rmdl", < -3090.542, 26883.99, 24176.64 > + startingorg, < 0, -0.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/modular_railing_trim_long.rmdl", < -4174.465, 26883.99, 23667.64 > + startingorg, < 0, 179.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/modular_railing_trim_long.rmdl", < -3348.464, 27130.99, 24048.64 > + startingorg, < 0, 179.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/modular_railing_trim_long.rmdl", < -3090.542, 27130.99, 24176.64 > + startingorg, < 0, -0.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/modular_railing_trim_long.rmdl", < -3462.542, 27130.99, 24048.64 > + startingorg, < 0, -0.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/modular_railing_trim_long.rmdl", < -3100.464, 27130.99, 24176.64 > + startingorg, < 0, 179.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/modular_railing_trim_long.rmdl", < -2976.464, 26883.99, 24176.64 > + startingorg, < 0, 179.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/modular_railing_trim_long.rmdl", < -3348.464, 26883.99, 24048.64 > + startingorg, < 0, 179.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/modular_railing_trim_long.rmdl", < -4109.465, 26883.99, 23667.64 > + startingorg, < 0, 179.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/modular_railing_trim_long.rmdl", < -3716.542, 27130.99, 23920.64 > + startingorg, < 0, -0.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -3095.362, 27008.83, 24160.97 > + startingorg, < 0, -0.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/modular_railing_trim_long.rmdl", < -3602.464, 27130.99, 23920.64 > + startingorg, < 0, 179.9998, 0 >, true, 5000, -1, 1 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/signs/desertlands_city_streetsign_01.rmdl", < -3094.503, 27129.31, 24192.59 > + startingorg, < 0, -0.0002, 0 >, true, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/industrial/modular_railing_trim_long.rmdl", < -4109.465, 27130.99, 23667.64 > + startingorg, < 0, 179.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/modular_railing_trim_long.rmdl", < -3100.464, 26883.99, 24176.64 > + startingorg, < 0, 179.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/fence_large_concrete_metal_dirty_128_01.rmdl", < -4042.222, 26885.33, 23667.77 > + startingorg, < 0, -0.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/fence_large_concrete_metal_dirty_128_01.rmdl", < -3983.722, 26942.83, 23667.77 > + startingorg, < 0, -90.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/fence_large_concrete_metal_dirty_128_01.rmdl", < -4042.222, 27129.33, 23667.77 > + startingorg, < 0, -0.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -4105.222, 27007.33, 23651.77 > + startingorg, < 0, -0.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/fence_large_concrete_metal_dirty_128_01.rmdl", < -3983.722, 27071.83, 23667.77 > + startingorg, < 0, -90.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/fence_large_concrete_metal_dirty_128_01.rmdl", < -3730.222, 26942.83, 23794.97 > + startingorg, < 0, -90.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/fence_large_concrete_metal_dirty_128_01.rmdl", < -3730.222, 27071.83, 23794.97 > + startingorg, < 0, -90.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -3851.722, 27007.33, 23778.97 > + startingorg, < 0, -0.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/fence_large_concrete_metal_dirty_128_01.rmdl", < -3788.721, 27129.33, 23794.97 > + startingorg, < 0, -0.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/fence_large_concrete_metal_dirty_128_01.rmdl", < -3788.722, 26885.33, 23794.97 > + startingorg, < 0, -0.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/fence_large_concrete_metal_dirty_128_01.rmdl", < -3222.471, 27071.83, 24048.57 > + startingorg, < 0, -90.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/fence_large_concrete_metal_dirty_128_01.rmdl", < -3222.472, 26942.83, 24048.57 > + startingorg, < 0, -90.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/fence_large_concrete_metal_dirty_128_01.rmdl", < -3280.971, 27129.33, 24048.57 > + startingorg, < 0, -0.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/fence_large_concrete_metal_dirty_128_01.rmdl", < -3280.972, 26885.33, 24048.57 > + startingorg, < 0, -0.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -3343.972, 27007.33, 24032.57 > + startingorg, < 0, -0.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/fence_large_concrete_metal_dirty_128_01.rmdl", < -3534.472, 26885.33, 23921.37 > + startingorg, < 0, -0.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/fence_large_concrete_metal_dirty_128_01.rmdl", < -3475.972, 26942.83, 23921.37 > + startingorg, < 0, -90.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/fence_large_concrete_metal_dirty_128_01.rmdl", < -3534.471, 27129.33, 23921.37 > + startingorg, < 0, -0.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/fence_large_concrete_metal_dirty_128_01.rmdl", < -3475.972, 27071.83, 23921.37 > + startingorg, < 0, -90.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -3597.472, 27007.33, 23905.37 > + startingorg, < 0, -0.0002, 0 >, true, 5000, -1, 1 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/industrial/exit_sign_03.rmdl", < -2974.761, 27006.03, 24277.3 > + startingorg, < 0, 179.9998, 0 >, true, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < -3783.162, 27008.33, 23947.04 > + startingorg, < 0, -0.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_elevator_01_top.rmdl", < -3783.162, 27008.33, 24162.03 > + startingorg, < 0, -0.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < -2966.96, 27185.33, 23137.97 > + startingorg, < 90, -0.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -1384.597, 27008.92, 23492.97 > + startingorg, < 0, -90.0002, 0 >, true, 5000, -1, 1 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/signs/desertlands_city_streetsign_01.rmdl", < -2356.617, 27188.13, 23524.59 > + startingorg, < 0, -0.0002, 0 >, true, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -1128.597, 27008.92, 23492.97 > + startingorg, < 0, -90.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_steps_metal_grate_double_128_01.rmdl", < -530.2358, 27002.32, 23874.62 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_steps_metal_grate_double_128_01.rmdl", < -506.2358, 27002.32, 23890.62 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/signs/desertlands_city_streetsign_01.rmdl", < -1006.597, 27065.3, 23524.59 > + startingorg, < 0, -0.0002, 0 >, true, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_04_corner.rmdl", < -752.5957, 27351.05, 23506.97 > + startingorg, < 0, 44.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/ola/sewer_railing_01_stairend.rmdl", < -597.187, 26948.32, 23838.21 > + startingorg, < 0, -90.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_steps_metal_grate_double_128_01.rmdl", < -578.2358, 27002.32, 23842.62 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/ola/sewer_railing_01_stairend.rmdl", < -597.187, 27059.16, 23838.21 > + startingorg, < 0, -90.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_steps_metal_grate_double_128_01.rmdl", < -554.2358, 27002.32, 23858.62 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/security_fence_post.rmdl", < -779.5967, 27701.58, 23506.97 > + startingorg, < 0, -90.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/zipline_arm.rmdl", < -778.7969, 27702.58, 23706.97 > + startingorg, < 0, 179.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/security_fence_post.rmdl", < -779.5991, 26239.42, 23506.97 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/zipline_arm.rmdl", < -780.3979, 26238.42, 23706.97 > + startingorg, < 0, -0.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_steps_metal_grate_double_128_01.rmdl", < -602.2979, 27002.32, 23826.97 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < -336.5972, 27004.07, 23740.97 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < -336.5967, 27059.82, 23740.97 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < -504.5967, 27115.32, 23740.97 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < -392.5972, 26948.57, 23740.97 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < -392.5522, 27004.07, 23879.96 > + startingorg, < 0, 89.9998, -179.9659 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < -336.5972, 26948.57, 23740.97 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < -448.5972, 26948.57, 23740.97 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < -392.5967, 27115.32, 23740.97 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < -336.5537, 27059.82, 23879.94 > + startingorg, < 0, 89.9998, -179.9659 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 2124.403, 27001.31, 23875.28 > + startingorg, < 0, 0.01, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < -336.5967, 27115.32, 23740.97 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < -448.5967, 27115.32, 23740.97 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/signs/desertlands_city_streetsign_01.rmdl", < -499.5967, 27107.3, 23906.59 > + startingorg, < 0, -0.0002, 0 >, true, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/signs/Sign_no_tresspasing.rmdl", < -504.4038, 27003.48, 23774 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 2.3232 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < -336.5542, 27004.07, 23879.94 > + startingorg, < 0, 89.9998, -179.9659 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < -392.5518, 27059.82, 23879.96 > + startingorg, < 0, 89.9998, -179.9659 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < -504.5972, 26948.57, 23740.97 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < -504.5967, 27059.82, 23740.97 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < -504.5972, 27004.07, 23740.97 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 2380.403, 27001.31, 23875.28 > + startingorg, < 0, -0.0002, 0 >, true, 5000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/containers/slumcity_oxygen_bag_large_01_b.rmdl", < 2834.437, 27000.36, 23904.48 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1.477 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 3309.403, 27001.31, 23850.28 > + startingorg, < 0, -0.0002, 0 >, true, 5000, -1, 1 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/signs/desertlands_city_streetsign_01.rmdl", < 2251.404, 27124.29, 23901.59 > + startingorg, < 0, -0.0002, 0 >, true, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/pipes/slum_pipe_large_yellow_256_02.rmdl", < 2834.403, 27001.31, 23814.28 > + startingorg, < 0, -0.0002, 0 >, true, 5000, -1, 1 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/signs/desertlands_city_streetsign_01.rmdl", < 3309.404, 27124.29, 23882.59 > + startingorg, < 0, -0.0002, 0 >, true, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < 5118.403, 27050.48, 24072.47 > + startingorg, < 0, -0.0002, 0 >, true, 5000, -1, 1 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/signs/desertlands_city_streetsign_01.rmdl", < 4810.403, 27040.48, 23880.59 > + startingorg, < 0, -0.0002, 0 >, true, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < 5118.402, 26938.48, 24072.47 > + startingorg, < 0, -0.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < 5118.403, 27050.48, 23933.47 > + startingorg, < 0, -0.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < 5118.402, 26938.48, 23933.47 > + startingorg, < 0, -0.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/beacon/beacon_fence_sign_01.rmdl", < 4884.402, 26992.48, 23859.47 > + startingorg, < 0, -0.0002, 90 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/beacon/modular_hose_yellow_corner_01.rmdl", < 5422.501, 26465.02, 24003.37 > + startingorg, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/beacon/modular_hose_yellow_32_01.rmdl", < 5358.501, 26465.02, 23860.47 > + startingorg, < 0, 0.0165, -179.9742 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/beacon/modular_hose_yellow_corner_01.rmdl", < 5358.501, 26465.02, 23860.46 > + startingorg, < 0, -180, 179.9742 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/beacon/modular_hose_yellow_corner_01.rmdl", < 5358.501, 26465.02, 24003.36 > + startingorg, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 5400.5, 26075.02, 23848.86 > + startingorg, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 5400.502, 26994.02, 23848.86 > + startingorg, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/beacon/modular_hose_yellow_32_01.rmdl", < 5390.501, 26465.02, 23860.47 > + startingorg, < 0, 0.0165, -179.9742 >, true, 5000, -1, 1 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/signs/desertlands_city_streetsign_01.rmdl", < 5503.602, 27105.12, 23881.59 > + startingorg, < 0, -0.0001, 0 >, true, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/beacon/modular_hose_yellow_128_02.rmdl", < 5430.501, 26465.02, 23867.66 > + startingorg, < -90, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/beacon/modular_hose_yellow_corner_01.rmdl", < 5422.501, 26465.02, 23860.46 > + startingorg, < 0, 0, -179.9742 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/beacon/modular_hose_yellow_128_02.rmdl", < 5350.501, 26465.02, 23867.66 > + startingorg, < -90, 90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/beacon/modular_hose_yellow_32_01.rmdl", < 5390.501, 26465.02, 24003.36 > + startingorg, < 0, -0.0165, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 5400.501, 26465.02, 23848.86 > + startingorg, < 0, -90, 90 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/beacon/modular_hose_yellow_32_01.rmdl", < 5358.501, 26465.02, 24003.36 > + startingorg, < 0, -0.0165, 0 >, true, 5000, -1, 1 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/signs/desertlands_city_streetsign_01.rmdl", < 5522.349, 26075.48, 23881.59 > + startingorg, < 0, -90, 0 >, true, 5000, -1, 1 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/signs/desertlands_city_streetsign_01.rmdl", < 5530.308, 23471.64, 24850.94 > + startingorg, < 0, -89.9996, 0 >, true, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < 5414.308, 23470.64, 24819.04 > + startingorg, < 0, 90.0004, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < 5400.308, 23530.64, 24725 > + startingorg, < 0, -90, 180 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_steps_metal_grate_double_128_01.rmdl", < 5337.314, 25447.64, 24536.65 > + startingorg, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < 5554.308, 23534.64, 24818.94 > + startingorg, < 0, -179.9997, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_steps_metal_grate_double_128_01.rmdl", < 5337.314, 25471.64, 24520.65 > + startingorg, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_steps_metal_grate_double_128_01.rmdl", < 5463.314, 25471.64, 24520.65 > + startingorg, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_steps_metal_grate_double_128_01.rmdl", < 5463.314, 25447.64, 24536.65 > + startingorg, < 0, 0, 0 >, true, 5000, -1, 1 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/signs/desertlands_city_streetsign_01.rmdl", < 5524.314, 25319.64, 24553.76 > + startingorg, < 0, -90, 0 >, true, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 5401.308, 23530.64, 24252 > + startingorg, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < 5249.308, 23534.64, 24818.94 > + startingorg, < 0, -179.9997, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < 5400.308, 23530.64, 24366 > + startingorg, < 0, -90, 180 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 5401.308, 23530.64, 24612 > + startingorg, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_steps_metal_grate_double_128_01.rmdl", < 5337.314, 25495.64, 24504.65 > + startingorg, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 5401.308, 23530.64, 24792 > + startingorg, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < 5400.308, 23530.64, 24546 > + startingorg, < 0, -90, 180 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_128_01.rmdl", < 5401.308, 23530.64, 24432 > + startingorg, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_steps_metal_grate_double_128_01.rmdl", < 5463.314, 25495.64, 24504.65 > + startingorg, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < 5389.309, 23834.24, 24819.23 > + startingorg, < 0, -89.9993, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < 5249.208, 23770.24, 24819.13 > + startingorg, < 0, 0.0007, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < 5554.208, 23770.14, 24819.13 > + startingorg, < 0, 0.0007, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < 5282.803, 21630.64, 24902.24 > + startingorg, < 0, 179.9824, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_128.rmdl", < 5277.802, 21290.64, 25093.24 > + startingorg, < 0, -179.9997, 90 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_corner.rmdl", < 5276.802, 21435.64, 25110.24 > + startingorg, < 0, 90.0004, 0 >, true, 5000, -1, 1 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/signs/desertlands_city_streetsign_01.rmdl", < 5613.105, 21945.64, 24844.24 > + startingorg, < 0, -89.9996, 0 >, true, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < 5282.802, 21294.64, 24724.24 > + startingorg, < 0, 179.9824, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < 5282.802, 21294.64, 24864.24 > + startingorg, < 0, 179.9824, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < 5282.803, 21518.64, 24902.24 > + startingorg, < 0, 179.9824, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < 5282.803, 21630.64, 25042.24 > + startingorg, < 0, 179.9824, 0 >, true, 5000, -1, 1 )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/playback/playback_barstool_02.rmdl", < 4676.803, 21686.64, 24663.24 > + startingorg, < 0, 90.0784, 0 >, true, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_corner.rmdl", < 5280.802, 21128.64, 24645.24 > + startingorg, < -90, 90.0003, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_corner.rmdl", < 5275.803, 21692.64, 25110.24 > + startingorg, < 0, -179.9361, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_128.rmdl", < 5075.803, 21687.64, 24824.24 > + startingorg, < 0, 90.064, 90 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < 5211.803, 21688.64, 25042.24 > + startingorg, < 0, -89.9996, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < 5099.803, 21688.64, 24902.24 > + startingorg, < 0, -89.9996, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < 5211.803, 21688.64, 24902.24 > + startingorg, < 0, -89.9996, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_32_valve.rmdl", < 4697.803, 21689.64, 24663.24 > + startingorg, < 0, -179.9361, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < 4765.803, 21688.64, 24724.24 > + startingorg, < 0, -89.9996, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_corner.rmdl", < 5277.802, 21112.64, 25077.24 > + startingorg, < 0, 90.0004, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < 4765.803, 21688.64, 24864.24 > + startingorg, < 0, -89.9996, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < 5282.802, 21183.64, 25004.24 > + startingorg, < 0, 179.9824, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < 5282.802, 21183.64, 24864.24 > + startingorg, < 0, 179.9824, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_64.rmdl", < 5275.802, 21483.64, 25125.24 > + startingorg, < 0, -179.9997, 90 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_corner.rmdl", < 5275.803, 21691.64, 25110.24 > + startingorg, < 0, -89.9996, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < 5282.802, 21183.64, 24724.24 > + startingorg, < 0, 179.9824, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_32_valve.rmdl", < 5277.803, 21693.64, 24832.24 > + startingorg, < 0, 45.0003, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < 5282.802, 21406.64, 24724.24 > + startingorg, < 0, 179.9824, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < 5282.802, 21294.64, 25004.24 > + startingorg, < 0, 179.9824, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_128.rmdl", < 5277.802, 21129.64, 25093.24 > + startingorg, < 0, -179.9997, 90 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_256.rmdl", < 5277.802, 21112.64, 24694.24 > + startingorg, < 0, -179.9997, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_256.rmdl", < 5280.802, 21131.64, 24645.24 > + startingorg, < 0, -179.9997, 90 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_32_valve.rmdl", < 5277.802, 21113.64, 24663.24 > + startingorg, < 0, -89.9996, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_64.rmdl", < 5280.802, 21390.64, 24644.24 > + startingorg, < 0, -179.9997, 90 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_corner.rmdl", < 5280.802, 21473.64, 24659.24 > + startingorg, < 0, -89.9996, 180 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_128.rmdl", < 5280.802, 21473.64, 24690.24 > + startingorg, < 0, -179.9997, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < 5282.802, 21406.64, 25004.24 > + startingorg, < 0, 179.9824, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < 5282.802, 21406.64, 24864.24 > + startingorg, < 0, 179.9824, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_corner.rmdl", < 5280.802, 21488.64, 24824.24 > + startingorg, < 90, -89.9997, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_128.rmdl", < 5280.803, 21491.64, 24824.24 > + startingorg, < 0, -179.9997, 90 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_64.rmdl", < 5278.803, 21621.64, 24824.24 > + startingorg, < 0, -179.9997, 90 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < 5282.803, 21518.64, 25042.24 > + startingorg, < 0, 179.9824, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_32_tjunk.rmdl", < 5276.802, 21451.64, 25125.24 > + startingorg, < 90, 90.0003, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_128.rmdl", < 5277.802, 21112.64, 24949.24 > + startingorg, < 0, -179.9997, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_32_valve.rmdl", < 5280.802, 21473.64, 24658.24 > + startingorg, < 0, 0.0003, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_corner.rmdl", < 5019.803, 21690.64, 25109.87 > + startingorg, < 0, 0.0639, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_256.rmdl", < 4715.803, 21686.64, 24645.24 > + startingorg, < 0, 90.064, 90 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_128.rmdl", < 5131.803, 21692.64, 25125.24 > + startingorg, < 0, 90.064, 90 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_64.rmdl", < 5067.803, 21691.64, 25125.24 > + startingorg, < 0, 90.064, 90 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < 4987.803, 21688.64, 24864.24 > + startingorg, < 0, -89.9996, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < 4765.803, 21688.64, 25004.24 > + startingorg, < 0, -89.9996, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_128.rmdl", < 4713.803, 21689.64, 25093.24 > + startingorg, < 0, 90.064, 90 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_256.rmdl", < 4696.803, 21689.64, 24694.24 > + startingorg, < 0, 90.064, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_128.rmdl", < 4696.803, 21689.64, 24949.24 > + startingorg, < 0, 90.064, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_32_tjunk.rmdl", < 5035.683, 21691, 25125.85 > + startingorg, < 90, -0.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_corner.rmdl", < 4713.803, 21686.64, 24645.24 > + startingorg, < -90, -19.4411, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_64.rmdl", < 4974.803, 21686.64, 24644.24 > + startingorg, < 0, 90.064, 90 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_corner.rmdl", < 5057.803, 21686.64, 24659.24 > + startingorg, < 0, -179.9361, 180 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_128.rmdl", < 5057.803, 21686.64, 24690.24 > + startingorg, < 0, 90.064, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_64.rmdl", < 5205.803, 21688.64, 24824.24 > + startingorg, < 0, 90.064, 90 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_corner.rmdl", < 5073.803, 21687.64, 24824.24 > + startingorg, < 90, 160.5589, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_32_valve.rmdl", < 5057.803, 21686.64, 24658.24 > + startingorg, < 0, -89.9216, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_corner.rmdl", < 5276.802, 21434.64, 25109.24 > + startingorg, < 0, -89.9996, 180 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_32_tjunk.rmdl", < 5278.202, 21257.64, 25094.24 > + startingorg, < 90, 90.0003, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_32_tjunk.rmdl", < 4842.104, 21689.14, 25094.24 > + startingorg, < 90, 0.2862, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_corner.rmdl", < 4696.803, 21689.64, 25077.24 > + startingorg, < 0, 0.0639, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_128.rmdl", < 5274.803, 21547.64, 25125.24 > + startingorg, < 0, -179.9997, 90 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_corner.rmdl", < 5018.803, 21690.64, 25109.24 > + startingorg, < 0, -179.9361, 180 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_128.rmdl", < 4874.803, 21689.64, 25093.24 > + startingorg, < 0, 90.064, 90 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < 5099.803, 21688.64, 25042.24 > + startingorg, < 0, -89.9996, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < 4875.803, 21688.64, 24724.24 > + startingorg, < 0, -89.9996, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < 4875.803, 21688.64, 25004.24 > + startingorg, < 0, -89.9996, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_grey_256.rmdl", < 5275.803, 21692.64, 24859.24 > + startingorg, < 0, -179.9997, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/lamps/light_parking_post.rmdl", < 4844.802, 21254.64, 24736.24 > + startingorg, < 0, 135.0003, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < 4875.803, 21688.64, 24864.24 > + startingorg, < 0, -89.9996, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_04_corner.rmdl", < 4986.871, 21398.7, 24737.13 > + startingorg, < 0, 45.0004, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_04_corner.rmdl", < 4285.421, 21398.7, 24737.13 > + startingorg, < 0, 135.0004, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < 4987.803, 21688.64, 25004.24 > + startingorg, < 0, -89.9996, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/indust_struct_gondola_platform_fence_01.rmdl", < 4987.803, 21688.64, 24724.24 > + startingorg, < 0, -89.9996, 0 >, true, 5000, -1, 1 )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/playback/playback_barstool_02.rmdl", < 5277, 21091, 24663.24 > + startingorg, < 0, 90.0784, 0 >, true, 5000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/playback/playback_barstool_02.rmdl", < 5277, 21076, 24663.24 > + startingorg, < 0, 90.0784, 0 >, true, 5000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/playback/playback_barstool_02.rmdl", < 4661, 21686.64, 24663.24 > + startingorg, < 0, 90.0784, 0 >, true, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_stack_01.rmdl", < 4102.728, 20505.83, 24605.13 > + startingorg, < 0, 135.0832, 0 >, true, 5000, -1, 1 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/signs/desertlands_city_streetsign_01.rmdl", < 4757.512, 21171.92, 24753.13 > + startingorg, < 0, 115.5289, 0 >, true, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/ola/sewer_railing_01_corner_in.rmdl", < 4481.031, 21024.14, 24737.13 > + startingorg, < 0, -89.9997, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_stack_01.rmdl", < 4212.33, 20615.43, 24605.13 > + startingorg, < 0, 135.0832, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/ola/sewer_railing_01_corner_in.rmdl", < 4604.069, 21015.65, 24737.13 > + startingorg, < 0, 90.0003, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/ola/sewer_railing_01_corner_in.rmdl", < 4611.845, 20893.33, 24737.13 > + startingorg, < 0, -89.9997, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x64_05.rmdl", < 4674.072, 21023.43, 24722.13 > + startingorg, < 0, 179.969, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_stack_01.rmdl", < 4212.33, 20615.43, 24772.13 > + startingorg, < 0, 135.0832, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x64_05.rmdl", < 4610.432, 21085.66, 24723.13 > + startingorg, < 0, 90.0003, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_stack_01.rmdl", < 4102.728, 20505.83, 24772.13 > + startingorg, < 0, 135.0832, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < -6285.52, 21558, 23850.15 > + startingorg, < 0, 179.9998, -90 >, true, 5000, -1, 2.75 )
    ClipInvisibleNoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -6273.305, 26456.7, 23418.4 > + startingorg, < -90, 89.9998, 0 >, true, 5000, -1, 1 ) )
    ClipInvisibleNoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -6332.605, 26536.3, 23206.8 > + startingorg, < -45.0003, -90.0002, 180 >, true, 5000, -1, 1 ) )
    ClipInvisibleNoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -6263.705, 26454.36, 23092 > + startingorg, < -44.9999, 89.9998, 0 >, true, 5000, -1, 1 ) )
    ClipInvisibleNoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -5941.405, 26536.3, 23206.8 > + startingorg, < -45.0003, -90.0002, 180 >, true, 5000, -1, 1 ) )
    ClipInvisibleNoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -6023.105, 26456.7, 23418.4 > + startingorg, < -90, 89.9998, 0 >, true, 5000, -1, 1 ) )
    ClipInvisibleNoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -6014.105, 26454.36, 23092 > + startingorg, < -44.9999, 89.9998, 0 >, true, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_02.rmdl", < -6306.413, 26426.46, 23046.32 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_02.rmdl", < -6108.516, 22805, 23015.9 > + startingorg, < -15, 90, 89.9998 >, true, 5000, -1, 0.5 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_02.rmdl", < -6126.516, 22799, 23015.97 > + startingorg, < 2.9769, -103.7716, 89.7103 >, true, 5000, -1, 0.5 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_02.rmdl", < -6266.516, 22805, 23015.9 > + startingorg, < -15, 90, 89.9998 >, true, 5000, -1, 0.5 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_02.rmdl", < -6296.516, 22805, 23016.9 > + startingorg, < -15, 90, 89.9998 >, true, 5000, -1, 0.5 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/rocks/icelandic_rockcluster_02.rmdl", < -6089.516, 22756, 23049 > + startingorg, < 0, -5.9729, 0 >, true, 5000, -1, 1 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/rocks/icelandic_rockcluster_02.rmdl", < -6245.516, 22714, 23049 > + startingorg, < 0, -170.5681, 0 >, true, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < -6087.515, 23211, 23045.7 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < -6156.515, 23224, 23045.7 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < -6144.515, 23186, 23045.7 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < -6178.515, 23211, 23045.7 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/grass_burnt_yellow_03.rmdl", < -6254.516, 22777, 23050.2 > + startingorg, < 0, 0, 0 >, true, 5000, -1, 1 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/grass_burnt_yellow_03.rmdl", < -6119.516, 22777, 23050.2 > + startingorg, < 0, 0, 0 >, true, 5000, -1, 1 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/grass_burnt_yellow_03.rmdl", < -6028.516, 22777, 23050.2 > + startingorg, < 0, 0, 0 >, true, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_wall_01.rmdl", < -2612.598, 27192.8, 23491.27 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 0.95 )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 166.896, 27009.18, 23796.5 > + startingorg, < 0, 140.0065, 0 >, true, 5000, -1, 0.58 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 190.0967, 26955.88, 23888 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 201.4966, 27009.98, 23888 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 133.0972, 27022.88, 23888 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 144.9966, 26985.18, 23888 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < 110.4966, 27009.98, 23888 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/props/zipline_balloon/zipline_balloon.rmdl", < 5400.489, 24407.96, 24810.62 > + startingorg, < 0, 70.5288, 0 >, true, 5000, -1, 0.05 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/props/zipline_balloon/zipline_balloon.rmdl", < 5400.491, 25060.96, 24809.06 > + startingorg, < 0, 70.5288, 0 >, true, 5000, -1, 0.05 ) )
    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_02.rmdl", < 4289.477, 20647.97, 24548.71 > + startingorg, < 90, -45.0006, 0 >, true, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -5773.527, 19230, 23757 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -5878.527, 19229, 23757 > + startingorg, < 0, -105.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -5982.527, 19228, 23757 > + startingorg, < 0, -105.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -6089.527, 19228, 23757 > + startingorg, < 0, -105.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -6198.527, 19228, 23757 > + startingorg, < 0, -105.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -6307.527, 19228, 23757 > + startingorg, < 0, -105.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -6411.527, 19228, 23757 > + startingorg, < 0, -105.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -6500.527, 19228, 23757 > + startingorg, < 0, -105.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -6526.527, 19251, 23757 > + startingorg, < 0, -105.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -5773.526, 19325, 23757 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -5878.526, 19323, 23757 > + startingorg, < 0, -105.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -5982.526, 19322, 23757 > + startingorg, < 0, -105.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -6089.526, 19322, 23757 > + startingorg, < 0, -105.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -6198.526, 19322, 23757 > + startingorg, < 0, -105.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -6307.526, 19322, 23757 > + startingorg, < 0, -105.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -6411.526, 19322, 23757 > + startingorg, < 0, -105.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -6500.526, 19322, 23757 > + startingorg, < 0, -105.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -6500.526, 19421, 23757 > + startingorg, < 0, -105.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -6411.526, 19421, 23757 > + startingorg, < 0, -105.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -6307.526, 19421, 23757 > + startingorg, < 0, -105.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -6198.526, 19421, 23757 > + startingorg, < 0, -105.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -6089.526, 19421, 23757 > + startingorg, < 0, -105.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -5982.526, 19421, 23757 > + startingorg, < 0, -105.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -5878.526, 19422, 23757 > + startingorg, < 0, -105.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -5773.526, 19423, 23757 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -5773.526, 19519, 23757 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -5878.526, 19517, 23757 > + startingorg, < 0, -105.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -5982.526, 19517, 23757 > + startingorg, < 0, -105.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -6089.526, 19517, 23757 > + startingorg, < 0, -105.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -6198.526, 19517, 23757 > + startingorg, < 0, -105.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -6307.526, 19517, 23757 > + startingorg, < 0, -105.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -6411.526, 19517, 23757 > + startingorg, < 0, -105.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -6500.526, 19517, 23757 > + startingorg, < 0, -105.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -6500.526, 19611, 23757 > + startingorg, < 0, -105.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -6411.526, 19611, 23757 > + startingorg, < 0, -105.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -6307.526, 19611, 23757 > + startingorg, < 0, -105.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -6198.526, 19611, 23757 > + startingorg, < 0, -105.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -6089.526, 19611, 23757 > + startingorg, < 0, -105.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -5982.526, 19611, 23757 > + startingorg, < 0, -105.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -5878.526, 19612, 23757 > + startingorg, < 0, -105.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -5773.525, 19614, 23757 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -5773.525, 19713, 23757 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -5878.525, 19712, 23757 > + startingorg, < 0, -105.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -5982.525, 19711, 23757 > + startingorg, < 0, -105.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -6089.525, 19711, 23757 > + startingorg, < 0, -105.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -6198.525, 19711, 23757 > + startingorg, < 0, -105.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -6307.525, 19711, 23757 > + startingorg, < 0, -105.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -6411.525, 19711, 23757 > + startingorg, < 0, -105.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -6500.525, 19711, 23757 > + startingorg, < 0, -105.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -6500.525, 19806, 23757 > + startingorg, < 0, -105.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -6411.525, 19806, 23757 > + startingorg, < 0, -105.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -6307.525, 19806, 23757 > + startingorg, < 0, -105.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -6198.525, 19806, 23757 > + startingorg, < 0, -105.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -6089.525, 19806, 23757 > + startingorg, < 0, -105.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -5982.525, 19806, 23757 > + startingorg, < 0, -105.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -5878.525, 19806, 23757 > + startingorg, < 0, -105.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -5773.525, 19808, 23757 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -6522.525, 19852, 23757 > + startingorg, < 0, 120, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -6548.525, 19785, 23757 > + startingorg, < 0, 180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -6548.525, 19689, 23757 > + startingorg, < 0, 180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -6548.525, 19619, 23757 > + startingorg, < 0, 180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -6548.526, 19477, 23757 > + startingorg, < 0, 180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -6548.526, 19362, 23757 > + startingorg, < 0, 180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -5717.526, 19362, 23757 > + startingorg, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -5717.526, 19458, 23757 > + startingorg, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -5717.526, 19558, 23757 > + startingorg, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -5717.525, 19666, 23757 > + startingorg, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -5717.525, 19753, 23757 > + startingorg, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -5717.525, 19814, 23757 > + startingorg, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -5752.525, 19851, 23757 > + startingorg, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -5859.525, 19855, 23757 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -5937.525, 19855, 23757 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -6021.525, 19855, 23757 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -6111.525, 19855, 23757 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -6193.525, 19855, 23757 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -6277.525, 19855, 23757 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -6344.525, 19855, 23757 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -6406.525, 19855, 23757 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/props/zipline_balloon/zipline_balloon.rmdl", < 5400.484, 22837.96, 25250 > + startingorg, < 0, 70.5288, 0 >, true, 5000, -1, 0.05 ) )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < -2803.304, 27008.39, 24476.47 > + startingorg, < 89.9802, -179.9997, 0 >, true, 100, -1, 40.48 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < -3028.225, 27008.43, 23393.08 > + startingorg, < 0.0003, 0.0002, 0.0002 >, true, 100, -1, 40.48 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < -563.7036, 27001.78, 23433.8 > + startingorg, < -90, 0.0003, 0 >, true, 100, -1, 40.48 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_02.rmdl", < 2037.396, 26797.28, 23869.5 > + startingorg, < -15, 90, 89.9998 >, true, 5000, -1, 1 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_02.rmdl", < 2063.696, 26785.38, 23745.93 > + startingorg, < 2.6801, 104.7639, -10.0608 >, true, 5000, -1, 1 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_02.rmdl", < 2231.396, 26776.13, 23747.38 > + startingorg, < -7.3911, -113.91, 4.025 >, true, 5000, -1, 1 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_02.rmdl", < 2174.66, 26700.29, 23747.38 > + startingorg, < -7.3911, -56.9058, 4.025 >, true, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/ola/sewer_railing_01_64.rmdl", < 5043.648, 27012.45, 23859.35 > + startingorg, < 0, -0.0002, -0.0002 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_wood_board_01.rmdl", < 2193.897, 26881.06, 23882.1 > + startingorg, < 0.0087, 0.0051, -58.9392 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/weapons/bullets/damage_arrow.rmdl", < -6354.903, 27118.42, 23716.7 > + startingorg, < -0.0002, -0.0002, 89.9998 >, true, 100, -1, 40.48 )
    MapEditor_CreateProp( $"mdl/ola/sewer_railing_01_64.rmdl", < 5043.595, 26972.5, 23859.3 > + startingorg, < 0, -0.0002, -0.0002 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -5735.527, 19266, 23757 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_02.rmdl", < 3996.477, 20442.97, 24548.71 > + startingorg, < 90, 134.9995, 0 >, true, 5000, -1, 1 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/props/zipline_balloon/zipline_balloon.rmdl", < 5400.487, 23652.96, 25085.13 > + startingorg, < 0, 70.5288, 0 >, true, 5000, -1, 0.05 ) )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_wall_01.rmdl", < -2612.6, 26963.8, 23491.27 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 0.95 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < -2228.704, 26841.39, 23509.2 > + startingorg, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < -2356.704, 26841.39, 23509.2 > + startingorg, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < -2484.704, 26841.39, 23509.2 > + startingorg, < 0, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < -2612.704, 26841.39, 23509.2 > + startingorg, < 0, 180, 0 >, true, 5000, -1, 1 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/foliage/grass_burnt_yellow_03.rmdl", < -6193.516, 22777, 23050.2 > + startingorg, < 0, 0, 0 >, true, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < -6099.515, 23157, 23045.7 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_02.rmdl", < -6029.516, 22805, 23015.9 > + startingorg, < -15, 90, 89.9998 >, true, 5000, -1, 0.5 ) )
    NoCollisionArray.append( MapEditor_CreateProp( $"mdl/rocks/icelandic_rockcluster_02.rmdl", < -6019.516, 22754, 23049 > + startingorg, < 0, 70.1294, 0 >, true, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < -6122.515, 23210, 22954.2 > + startingorg, < 0, 140.0065, 0 >, true, 5000, -1, 0.58 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_02.rmdl", < -5954.518, 22208, 23047.15 > + startingorg, < 0, -90.0005, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < -6285.518, 22064, 23619.15 > + startingorg, < 0, 179.9998, -90 >, true, 5000, -1, 2.75 )
    MapEditor_CreateProp( $"mdl/timeshift/timeshift_bench_01.rmdl", < 4906.478, 20865.97, 24737.83 > + startingorg, < 0, -134.9996, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/timeshift/timeshift_bench_01.rmdl", < 4461.479, 21302.97, 24737.83 > + startingorg, < 0, -134.9996, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_wall_256x128_02.rmdl", < 5404.512, 25697.92, 23865.49 > + startingorg, < 0, -180, 0 >, true, 5000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/beacon/beacon_fence_sign_01.rmdl", < 5534, 25701, 24328.53 > + startingorg, < -90, 90, 0 >, true, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/lamps/desertlands_lootbin_light_01.rmdl", < 5280, 25685, 24042 > + startingorg, < 0, -180, 180 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_steps_metal_grate_double_128_01.rmdl", < 5337, 25493.64, 24504.17 > + startingorg, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 5275.077, 25702.96, 24162.53 > + startingorg, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 5275.077, 25684.5, 24281.53 > + startingorg, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/lamps/desertlands_lootbin_light_01.rmdl", < 5527, 25679, 24282 > + startingorg, < 0, -180, 180 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 5399.957, 25316.68, 24526.66 > + startingorg, < 0, -180, 0 >, true, 5000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/beacon/beacon_fence_sign_01.rmdl", < 5534, 25701, 24010.53 > + startingorg, < -90, 90, 0 >, true, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 5403.077, 25684.5, 24281.53 > + startingorg, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 5399.943, 25564.15, 23978.01 > + startingorg, < 0, 89.9747, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 5275.077, 25691, 24041.53 > + startingorg, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 5399.943, 25572.11, 24472.34 > + startingorg, < 0, 89.9747, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 5400.513, 25564.14, 23977.49 > + startingorg, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_steps_metal_grate_double_128_01.rmdl", < 5337, 25469.64, 24520.17 > + startingorg, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/lamps/desertlands_lootbin_light_01.rmdl", < 5527, 25697, 24163 > + startingorg, < 0, -180, 180 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_steps_metal_grate_double_128_01.rmdl", < 5463, 25469.64, 24520.17 > + startingorg, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_steps_metal_grate_double_128_01.rmdl", < 5463, 25445.64, 24536.17 > + startingorg, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 5399.943, 25565, 24218.03 > + startingorg, < 0, 89.9747, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/lamps/desertlands_lootbin_light_01.rmdl", < 5527, 25685, 24042 > + startingorg, < 0, -180, 180 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/lamps/desertlands_lootbin_light_01.rmdl", < 5280, 25697, 24401 > + startingorg, < 0, -180, 180 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/lamps/desertlands_lootbin_light_01.rmdl", < 5280, 25697, 24163 > + startingorg, < 0, -180, 180 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_steps_metal_grate_double_128_01.rmdl", < 5463, 25493.64, 24504.17 > + startingorg, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 5400.513, 25810, 24336.89 > + startingorg, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 5403.076, 25691, 24041.53 > + startingorg, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/lamps/desertlands_lootbin_light_01.rmdl", < 5280, 25679, 24282 > + startingorg, < 0, -180, 180 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/city_steps_metal_grate_double_128_01.rmdl", < 5337, 25445.64, 24536.17 > + startingorg, < 0, 0, 0 >, true, 5000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/beacon/beacon_fence_sign_01.rmdl", < 5267, 25701, 24328.53 > + startingorg, < -90, -90, 0 >, true, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 5403.076, 25702.96, 24162.53 > + startingorg, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 5275.077, 25702.96, 24400.71 > + startingorg, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 5400.513, 25819.15, 23848.49 > + startingorg, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 5400.513, 25819, 24097.53 > + startingorg, < 0, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/slum_city/slumcity_fencewall_128x72_dirty.rmdl", < 5403.076, 25702.96, 24400.71 > + startingorg, < 0, -90, 0 >, true, 5000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/beacon/beacon_fence_sign_01.rmdl", < 5267, 25701, 24010.53 > + startingorg, < -90, -90, 0 >, true, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/lamps/desertlands_lootbin_light_01.rmdl", < 5527, 25697, 24401 > + startingorg, < 0, -180, 180 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < -5638.7, 27191, 23640.3 > + startingorg, < -15.0001, -0.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < -5762.3, 27191, 23607.2 > + startingorg, < -15.0001, -0.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/colony/farmland_ceiling_096x048_01.rmdl", < 5462.48, 21688.9, 24856.8 > + startingorg, < -89.972, 89.9995, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/colony/farmland_ceiling_096x048_01.rmdl", < -4974.2, 27015.5, 23697 > + startingorg, < -90, 90.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/colony/farmland_ceiling_096x048_01.rmdl", < -4974.201, 27016.83, 23697 > + startingorg, < -90, -89.9995, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_04_corner.rmdl", < -2979, 27367.2, 23374 > + startingorg, < 0, 44.9999, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_03.rmdl", < -5515.352, 27191, 23673.35 > + startingorg, < -15.0001, -0.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/colony/farmland_ceiling_096x048_01.rmdl", < -2100.9, 27017.38, 23532.9 > + startingorg, < -90, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/colony/farmland_crate_md_80x64x72_02.rmdl", < -6357.521, 21199, 23777.5 > + startingorg, < 89.9802, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/colony/farmland_crate_md_80x64x72_02.rmdl", < -6491.521, 21199, 23933.8 > + startingorg, < 89.9802, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/colony/farmland_crate_md_80x64x72_02.rmdl", < -6355.794, 21199, 24133.6 > + startingorg, < 89.9802, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/colony/farmland_crate_md_80x64x72_02.rmdl", < -6298.521, 21344, 24225.6 > + startingorg, < 90, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/colony/farmland_crate_md_80x64x72_02.rmdl", < -6298.519, 21847, 24002 > + startingorg, < 90, -90, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < -776.999, 27704, 23415.16 > + startingorg, < 0, 140.0065, 0 >, true, 5000, -1, 0.58 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < -810.7983, 27717.7, 23506.66 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < -753.7988, 27650.7, 23506.66 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < -742.3984, 27704.8, 23506.66 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < -798.8994, 27680, 23506.66 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < -833.3984, 27704.8, 23506.66 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < -788.9995, 26257, 23415.16 > + startingorg, < 0, 140.0065, 0 >, true, 5000, -1, 0.58 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < -822.7988, 26270.7, 23506.66 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < -810.8999, 26233, 23506.66 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < -845.3989, 26257.8, 23506.66 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < -765.7993, 26203.7, 23506.66 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_01.rmdl", < -754.3989, 26257.8, 23506.66 > + startingorg, < 0, 89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3762.97, 27310, 23794.32 > + startingorg, < 0, 90.0005, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3762.97, 27310, 23666.82 > + startingorg, < 0, 90.0005, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3762.97, 27310, 23539.72 > + startingorg, < 0, 90.0005, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3762.97, 27310, 23921.72 > + startingorg, < 0, 90.0005, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 3762.97, 27310, 24049.02 > + startingorg, < 0, 90.0005, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 4525.966, 26694, 23794 > + startingorg, < 0, -89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 4525.966, 26694, 23539 > + startingorg, < 0, -89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 4525.966, 26694, 23666 > + startingorg, < 0, -89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 4525.966, 26694, 24048 > + startingorg, < 0, -89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < 4525.966, 26694, 23921 > + startingorg, < 0, -89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 4075.475, 19948.97, 24690.09 > + startingorg, < 0, 30.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3716.476, 20207.97, 24690.09 > + startingorg, < 0, 30.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3655.475, 19992.97, 24690.09 > + startingorg, < 0, 30.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3869.475, 19779.97, 24690.09 > + startingorg, < 0, 30.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3707.476, 20349.97, 24690.09 > + startingorg, < 0, 30.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3874.475, 19909.97, 24690.09 > + startingorg, < 0, 30.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3421.476, 20359.97, 24690.09 > + startingorg, < 0, -134.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3806.475, 19842.97, 24690.09 > + startingorg, < 0, 30.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 4010.476, 20046.97, 24690.09 > + startingorg, < 0, 30.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3570.476, 20213.97, 24690.09 > + startingorg, < 0, 30.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3666.475, 19849.97, 24690.09 > + startingorg, < 0, 30.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3936.476, 20120.97, 24690.09 > + startingorg, < 0, 30.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3518.475, 19855.97, 24690.09 > + startingorg, < 0, 30.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3595.475, 19778.97, 24690.09 > + startingorg, < 0, 30.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3425.477, 20442.97, 24690.09 > + startingorg, < 0, 135.0004, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3210.476, 20227.97, 24690.09 > + startingorg, < 0, 135.0004, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3231.475, 19938.97, 24690.09 > + startingorg, < 0, -134.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3413.475, 19757.97, 24690.09 > + startingorg, < 0, -134.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3429.476, 20218.97, 24690.09 > + startingorg, < 0, 30.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3365.475, 20008.97, 24690.09 > + startingorg, < 0, 30.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3647.474, 19526.97, 24690.09 > + startingorg, < 0, -104.9995, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3496.476, 20286.97, 24690.09 > + startingorg, < 0, 30.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3944.475, 19979.97, 24690.09 > + startingorg, < 0, 30.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3936.475, 19847.97, 24690.09 > + startingorg, < 0, 30.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3589.475, 19926.97, 24690.09 > + startingorg, < 0, 30.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3291.476, 20081.97, 24690.09 > + startingorg, < 0, 30.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3793.476, 20130.97, 24690.09 > + startingorg, < 0, 30.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3646.476, 20137.97, 24690.09 > + startingorg, < 0, 30.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3830.474, 19673.97, 24690.09 > + startingorg, < 0, -44.9997, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 4073.475, 19983.97, 24690.09 > + startingorg, < 0, 30.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3578.476, 20069.97, 24690.09 > + startingorg, < 0, 30.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3732.475, 19915.97, 24690.09 > + startingorg, < 0, 30.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3286.476, 20224.97, 24690.09 > + startingorg, < 0, -134.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3713.474, 19555.97, 24690.09 > + startingorg, < 0, -44.9997, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3931.475, 19773.97, 24690.09 > + startingorg, < 0, -44.9997, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3451.475, 19788.97, 24690.09 > + startingorg, < 0, 30.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3149.476, 20087.97, 24690.09 > + startingorg, < 0, -134.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3105.476, 20122.97, 24690.09 > + startingorg, < 0, 135.0004, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3557.477, 20496.97, 24690.09 > + startingorg, < 0, -134.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3490.477, 20429.97, 24690.09 > + startingorg, < 0, -134.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3800.475, 19983.97, 24690.09 > + startingorg, < 0, 30.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 4006.475, 19917.97, 24690.09 > + startingorg, < 0, 30.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3723.476, 20060.97, 24690.09 > + startingorg, < 0, 30.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3353.476, 20291.97, 24690.09 > + startingorg, < 0, -134.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3640.476, 20283.97, 24690.09 > + startingorg, < 0, 30.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3739.475, 19775.97, 24690.09 > + startingorg, < 0, 30.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3148.476, 20165.97, 24690.09 > + startingorg, < 0, 135.0004, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3291.475, 19878.97, 24690.09 > + startingorg, < 0, -134.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3355.475, 19815.97, 24690.09 > + startingorg, < 0, -134.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3436.476, 20078.97, 24690.09 > + startingorg, < 0, 30.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3362.476, 20151.97, 24690.09 > + startingorg, < 0, 30.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3216.476, 20154.97, 24690.09 > + startingorg, < 0, -134.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3668.474, 19704.97, 24690.09 > + startingorg, < 0, 30.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3870.476, 20053.97, 24690.09 > + startingorg, < 0, 30.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3512.475, 20003.97, 24690.09 > + startingorg, < 0, 30.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3441.475, 19932.97, 24690.09 > + startingorg, < 0, 30.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3374.475, 19865.97, 24690.09 > + startingorg, < 0, 30.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3566.476, 20356.97, 24690.09 > + startingorg, < 0, 30.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3298.475, 19941.97, 24690.09 > + startingorg, < 0, 30.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3104.476, 20071.97, 24690.09 > + startingorg, < 0, 135.0004, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3224.475, 20014.97, 24690.09 > + startingorg, < 0, 30.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3176.475, 19993.97, 24690.09 > + startingorg, < 0, -134.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3505.477, 20497.97, 24690.09 > + startingorg, < 0, -134.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3781.474, 19623.97, 24690.09 > + startingorg, < 0, -44.9997, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3528.474, 19711.97, 24690.09 > + startingorg, < 0, 30.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 4012.475, 19854.97, 24690.09 > + startingorg, < 0, -44.9997, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3286.476, 20303.97, 24690.09 > + startingorg, < 0, 135.0004, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3472.474, 19697.97, 24690.09 > + startingorg, < 0, -134.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3563.474, 19606.97, 24690.09 > + startingorg, < 0, -134.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3632.477, 20422.97, 24690.09 > + startingorg, < 0, 30.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3782.476, 20274.97, 24690.09 > + startingorg, < 0, 30.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3859.476, 20197.97, 24690.09 > + startingorg, < 0, 30.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3601.474, 19637.97, 24690.09 > + startingorg, < 0, 30.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3519.474, 19650.97, 24690.09 > + startingorg, < 0, -134.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3802.474, 19712.97, 24690.09 > + startingorg, < 0, 30.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3664.474, 19574.97, 24690.09 > + startingorg, < 0, 30.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3357.477, 20374.97, 24690.09 > + startingorg, < 0, 135.0004, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3502.476, 20145.97, 24690.09 > + startingorg, < 0, 30.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 3731.474, 19641.97, 24690.09 > + startingorg, < 0, 30.0002, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/colony/farmland_ceiling_096x048_01.rmdl", < 5269.281, 21884.57, 24856.8 > + startingorg, < -90, -0.0001, 0 >, true, 5000, -1, 1 )
    ClipInvisibleNoGrappleNoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < 5392.501, 26465.02, 23990 > + startingorg, < 0, -179.9998, 179.9998 >, true, 5000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/colony/farmland_crate_md_80x64x72_02.rmdl", < -6286.794, 21199, 24133.6 > + startingorg, < 89.9802, -180, 0 >, true, 5000, -1, 1 )

    MapEditor_CreateProp( $"mdl/beacon/construction_scaff_post_256_01.rmdl", < -6299, 20369.4, 23704 >, < -90, 89.9999, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/barriers/concrete/concrete_barrier_01.rmdl", < -4953, 27016, 23675.4 >, < 0, -89.9998, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < -2924.774, 27211, 23357.04 >, < 44.9999, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < -2818.707, 27211, 23463.11 >, < 44.9999, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < -2712.742, 27211, 23568.99 >, < 44.9999, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < -2818.707, 26862, 23463.11 >, < 44.9999, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < -2924.774, 26862, 23357.04 >, < 44.9999, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_column_01.rmdl", < -2712.742, 26862, 23568.99 >, < 44.9999, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/homestead/homestead_floor_panel_01.rmdl", < -1619, 26984.9, 23371 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/ola/sewer_railing_01_64.rmdl", < -2114, 27016, 23509.4 >, < 0, 0, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/ola/sewer_railing_01_corner_in.rmdl", < 3597.3, 26624, 23873.5 >, < 0, -90, 90 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/ola/sewer_railing_01_corner_in.rmdl", < 4363, 26624, 23873.5 >, < 0, -90, 90 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/ola/sewer_railing_01_corner_in.rmdl", < 3597.3, 27377, 23873.5 >, < 90, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/ola/sewer_railing_01_corner_in.rmdl", < 4363, 27377, 23873.5 >, < 90, -180, 0 >, true, 5000, -1, 1 )
    MapEditor_CreateProp( $"mdl/utilities/wall_Waterpipe.rmdl", < 4116.301, 20480.1, 24891.9 >, < 0, -45, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/utilities/wall_Waterpipe.rmdl", < 4223.4, 20587.2, 24891.9 >, < 0, -45, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/utilities/wall_Waterpipe.rmdl", < 4076.2, 20520.2, 24891.9 >, < 0, 135, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/utilities/wall_Waterpipe.rmdl", < 4183.3, 20627.3, 24891.9 >, < 0, 135, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/beacon/beacon_fence_sign_01.rmdl", < -6132.1, 25783.2, 23042.5 >, < 0, 0, 90 >, true, 50000, -1, 1 )

    foreach ( entity ent in ClipArray )
    {
        ent.MakeInvisible()
        ent.kv.solid = 6
        ent.kv.CollisionGroup = TRACE_COLLISION_GROUP_PLAYER
        ent.kv.contents = CONTENTS_PLAYERCLIP
    }
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

    // VerticalZipLines
    MapEditor_CreateZiplineFromUnity( < 5399.706, 25060.74, 24813.17 > + startingorg, < 0, -89.9999, 0 >, < 5399.704, 25060.74, 24313.17 > + startingorg, < 0, -89.9999, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 5400.809, 24408.28, 24810.62 > + startingorg, < 0, -90, 0 >, < 5400.807, 24408.28, 24378 > + startingorg, < 0, -90, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 5400.804, 22838.28, 25250.13 > + startingorg, < 0, -89.9999, 0 >, < 5400.802, 22838.28, 24425.94 > + startingorg, < 0, -89.9999, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    MapEditor_CreateZiplineFromUnity( < 5400.798, 23653.51, 25085.13 > + startingorg, < 0, -90.0001, 0 >, < 5400.796, 23653.5, 24138 > + startingorg, < 0, -90.0001, 0 >, true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )
    // NonVerticalZipLines
    MapEditor_CreateZiplineFromUnity( < -774.7969, 27647.58, 23694.97 > + startingorg, < 0, -90.0002, 0 >, < -784.3979, 26293.42, 23694.97 > + startingorg, < 0, -90.0002, 0 >, false, -1, 1, 2, 1, 1, 0, 1, 150, 150, false, 0, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )

    // Buttons
    AddCallback_OnUseEntity( CreateFRButton(< -6221.525, 19909, 23752.35 > + startingorg, < 0, 0.0007, 0 >, "%use% Back to Hub"), void function(entity panel, entity user, int input)
    {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < 10726.9000, 10287, -4283 > , < 0, -89.9998, 0 > )
      Message(user, "HUB", "\n  You now recieved Phase Walk Tactical")
    })

    AddCallback_OnUseEntity( CreateFRButton(< -6045.525, 19909, 23752.35 > + startingorg, < 0, 0.0007, 0 >, "%use% Start Timer"), void function(entity panel, entity user, int input)
    {
//Start Timer Button
	user.p.isTimerActive = true
	user.p.startTime = floor( Time() ).tointeger()
	Remote_CallFunction_NonReplay( user, "MG_StopWatch_toggle", false)
	Remote_CallFunction_NonReplay( user, "MG_StopWatch_toggle", true)
	Message(user, "Timer Started!" )
    })

    AddCallback_OnUseEntity( CreateFRButton(< 3590.475, 19925.97, 24685.1 > + startingorg, < 0, 134.9999, 0 >, "%use% Back to start"), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< -6130.522, 19588, 23766.6 >,< 0, -89.9998, 0 >)
user.p.isTimerActive = false
user.p.startTime = 0
user.p.currentCheckpoint = 1
Remote_CallFunction_NonReplay( user, "MG_StopWatch_toggle", false)
    })

    AddCallback_OnUseEntity( CreateFRButton(< 3511.475, 20004.97, 24685.1 > + startingorg, < 0, 134.9999, 0 >, "%use% Back to Hub"), void function(entity panel, entity user, int input)
    {
EmitSoundOnEntityOnlyToPlayer( user, user, FIRINGRANGE_BUTTON_SOUND )
TeleportFRPlayer(user,< 10726.9000, 10287, -4283 >,< 0, -89.9998, 0 >)
Message(user, "Hub")
user.p.isTimerActive = false
user.p.startTime = 0
user.p.allowCheckpoint = false
Remote_CallFunction_NonReplay( user, "MG_StopWatch_toggle", false)
    })

    AddCallback_OnUseEntity( CreateFRButton(< 3627.476, 20038.97, 24685.1 > + startingorg, < 0, 134.9999, 0 >, "%use% Stop Timer"), void function(entity panel, entity user, int input)
    {
//Stop timer Button
      if (user.p.isTimerActive == true) {
        user.p.finalTime = floor( Time() ).tointeger() - user.p.startTime
        
	int seconds = user.p.finalTime
        
	//Display player Time
	Message(user, "Your Final Time: " + _MG_Convert_Sec_to_Time(seconds))
	
	//Add to results file
	string finalTime = user.GetPlatformUID()+ "|" + user.GetPlayerName() + "|" + _MG_Convert_Sec_to_Time(seconds) + "|" + GetUnixTimestamp() + "|Map3"
	file.allTimes.append(finalTime)
	
	//Reset Timer
	user.p.isTimerActive = false
	user.p.startTime = 0
	
	Remote_CallFunction_NonReplay( user, "MG_StopWatch_toggle", false)
	
	//Send time to killfeed and update WORLDRUI
	if(user.IsInRealm(1)){
		foreach(entity sPlayer in GetPlayerArray()){
			if(sPlayer.IsInRealm(1)){
				Remote_CallFunction_NonReplay( sPlayer, "MG_StopWatch_Obituary", seconds, user, 3)
			}
		}
	}
	  
}
    })


    // Jumppads
    MapEditor_CreateJumpPad( MapEditor_CreateProp( $"mdl/props/octane_jump_pad/octane_jump_pad.rmdl", < -6136.015, 26351.89, 23046.12 > + startingorg, < 0, 89.9998, 0 >, true, 50000, -1, 1 ) )

    // Triggers
    entity trigger_0 = MapEditor_CreateTrigger( < -156.2324, 24188.59, 22846.77 > + startingorg, < 0, 0, 0 >, 10000, 50, false )
    trigger_0.SetEnterCallback( void function(entity trigger , entity ent)
    {
    //Big ahh trigger
if (IsValid(ent)) {
  if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
    if (ent.p.allowCheckpoint == true) {
      switch (ent.p.currentCheckpoint) {
        // Checkpoint 1
      case 1:
        ent.SetOrigin( < -6130.522, 19545, 23766.6 > )
        ent.SetAngles( < 0, 90, 0 > )
        ent.SetVelocity( < 0, 0, 0 > )
        break

        // Checkpoint 2
      case 2:
        ent.SetOrigin( < -6130.522, 20662, 23766.6 > )
        ent.SetAngles( < 0, 90, 0 > )
        ent.SetVelocity( < 0, 0, 0 > )
        break

        // Checkpoint 3
      case 3:
        ent.SetOrigin( < -6130.517, 22501, 23070.3 > )
        ent.SetAngles( < 0, 90, 0 > )
        ent.SetVelocity( < 0, 0, 0 > )
        break

        // Checkpoint 4
      case 4:
        ent.SetOrigin( < -6130.505, 26278.5, 23070.3 > )
        ent.SetAngles( < 0, 90, 0 > )
        ent.SetVelocity( < 0, 0, 0 > )
        break

        // Checkpoint 5
      case 5:
        ent.SetOrigin( < -5230.003, 27014.4, 23694.6 > )
        ent.SetAngles( < 0, 0, 0 > )
        ent.SetVelocity( < 0, 0, 0 > )
        break

        // Checkpoint 6
      case 6:
        ent.SetOrigin( < -3097.104, 27003.29, 24199.3 > )
        ent.SetAngles( < 0, 0, 0 > )
        ent.SetVelocity( < 0, 0, 0 > )
        break

        // Checkpoint 7
      case 7:
        ent.SetOrigin( < -2374.904, 27020.99, 23532 > )
        ent.SetAngles( < 0, 0, 0 > )
        ent.SetVelocity( < 0, 0, 0 > )
        break

        // Checkpoint 8
      case 8:
        ent.SetOrigin( < -860.5034, 27008.98, 23528.7 > )
        ent.SetAngles( < 0, 0, 0 > )
        ent.SetVelocity( < 0, 0, 0 > )
        break

        // Checkpoint 9
      case 9:
        ent.SetOrigin( < -383.3032, 27008.98, 23911 > )
        ent.SetAngles( < 0, 0, 0 > )
        ent.SetVelocity( < 0, 0, 0 > )
        break

        // Checkpoint 10
      case 10:
        ent.SetOrigin( < 2240.197, 26990.38, 23911 > )
        ent.SetAngles( < 0, 0, 0 > )
        ent.SetVelocity( < 0, 0, 0 > )
        break

        // Checkpoint 11
      case 11:
        ent.SetOrigin( < 3304.497, 26996.17, 23911 > )
        ent.SetAngles( < 0, 0, 0 > )
        ent.SetVelocity( < 0, 0, 0 > )
        break

        // Checkpoint 12
      case 12:
        ent.SetOrigin( < 4881.497, 26989.97, 23911 > )
        ent.SetAngles( < 0, 0, 0 > )
        ent.SetVelocity( < 0, 0, 0 > )
        break

        // Checkpoint 13
      case 13:
        ent.SetOrigin( < 5391.397, 26989.96, 23911 > )
        ent.SetAngles( < 0, -90, 0 > )
        ent.SetVelocity( < 0, 0, 0 > )
        break

        // Checkpoint 14
      case 14:
        ent.SetOrigin( < 5391.494, 26070.96, 23911 > )
        ent.SetAngles( < 0, -90, 0 > )
        ent.SetVelocity( < 0, 0, 0 > )
        break

        // Checkpoint 15
      case 15:
        ent.SetOrigin( < 5391.492, 25312.96, 24567 > )
        ent.SetAngles( < 0, -90, 0 > )
        ent.SetVelocity( < 0, 0, 0 > )
        break

        // Checkpoint 16
      case 16:
        ent.SetOrigin( < 5391.486, 23439.77, 24861.5 > )
        ent.SetAngles( < 0, -90, 0 > )
        ent.SetVelocity( < 0, 0, 0 > )
        break

        // Checkpoint 17
      case 17:
        ent.SetOrigin( < 5391.482, 22059.96, 24857.4 > )
        ent.SetAngles( < 0, -90, 0 > )
        ent.SetVelocity( < 0, 0, 0 > )
        break
	
        // Checkpoint 18
      case 18:
        ent.SetOrigin( < 4812.479, 21215.97, 24750 > )
        ent.SetAngles( < 0, -135, 0 > )
        ent.SetVelocity( < 0, 0, 0 > )
        break
      }
    }
  }
}
    })
    DispatchSpawn( trigger_0 )
    entity trigger_1 = MapEditor_CreateTrigger( < -2193.503, 27019.99, 23545 > + startingorg, < 0, 0, 0 >, 66.491, 43, false )
    trigger_1.SetEnterCallback( void function(entity trigger , entity ent)
    {
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
    DispatchSpawn( trigger_1 )
    entity trigger_2 = MapEditor_CreateTrigger( < -6121.517, 22613, 23069 > + startingorg, < 0, 0, 0 >, 66.491, 26.5964, false )
    trigger_2.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
         	  ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
        	  ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
         	  ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
         	  ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
	  ent.SetSuitGrapplePower(100)
        }
    }

    })
    DispatchSpawn( trigger_2 )
    entity trigger_3 = MapEditor_CreateTrigger( < -6143.606, 26172, 23069 > + startingorg, < 0, 0, 0 >, 134.8, 26.5964, false )
    trigger_3.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
         	  ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
        	  ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
        }
    }

    })
    DispatchSpawn( trigger_3 )
    entity trigger_4 = MapEditor_CreateTrigger( < -322.9995, 27004.98, 23885 > + startingorg, < 0, 0, 0 >, 42.75, 26.5964, false )
    trigger_4.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
         	  ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
        	  ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
         	  ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
         	  ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
	  ent.SetSuitGrapplePower(100)
        }
    }

    })
    DispatchSpawn( trigger_4 )
    entity trigger_5 = MapEditor_CreateTrigger( < 2246.497, 26985.97, 23903.4 > + startingorg, < 0, 0, 0 >, 134.8, 26.5964, false )
    trigger_5.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
         	  ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
        	  ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
        }
    }

    })
    DispatchSpawn( trigger_5 )
    entity trigger_6 = MapEditor_CreateTrigger( < 4646.479, 21055.97, 24761 > + startingorg, < 0, 0, 0 >, 102.55, 73.7, false )
    trigger_6.SetEnterCallback( void function(entity trigger , entity ent)
    {
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
    DispatchSpawn( trigger_6 )
    entity trigger_7 = MapEditor_CreateTrigger( < -6130.522, 20662, 23766.6 > + startingorg, < 0, 0, 0 >, 75.7, 26.5964, false )
    trigger_7.SetEnterCallback( void function(entity trigger , entity ent)
    {
    //set Checkpoint and shot timer
if (IsValid(ent)){
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){
		int checkpointInThisTrigger = 2
		//show checkpoint msg
		if(ent.p.currentCheckpoint != checkpointInThisTrigger)
			Remote_CallFunction_NonReplay( ent, "MG_Checkpoint_Msg")
		
		//set checkpoint
		ent.p.currentCheckpoint = checkpointInThisTrigger
        }
}
    })
    DispatchSpawn( trigger_7 )
    entity trigger_8 = MapEditor_CreateTrigger( < -6130.517, 22501, 23070.3 > + startingorg, < 0, 0, 0 >, 138.95, 26.5964, false )
    trigger_8.SetEnterCallback( void function(entity trigger , entity ent)
    {
    //set Checkpoint and shot timer
if (IsValid(ent)){
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){
		int checkpointInThisTrigger = 3
		//show checkpoint msg
		if(ent.p.currentCheckpoint != checkpointInThisTrigger)
			Remote_CallFunction_NonReplay( ent, "MG_Checkpoint_Msg")
		
		//set checkpoint
		ent.p.currentCheckpoint = checkpointInThisTrigger
        }
}
    })
    DispatchSpawn( trigger_8 )
    entity trigger_9 = MapEditor_CreateTrigger( < -6130.505, 26278.5, 23070.3 > + startingorg, < 0, 0, 0 >, 75.7, 26.5964, false )
    trigger_9.SetEnterCallback( void function(entity trigger , entity ent)
    {
    //set Checkpoint and shot timer
if (IsValid(ent)){
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){
		int checkpointInThisTrigger = 4
		//show checkpoint msg
		if(ent.p.currentCheckpoint != checkpointInThisTrigger)
			Remote_CallFunction_NonReplay( ent, "MG_Checkpoint_Msg")
		
		//set checkpoint
		ent.p.currentCheckpoint = checkpointInThisTrigger
        }
}
    })
    DispatchSpawn( trigger_9 )
    entity trigger_10 = MapEditor_CreateTrigger( < -5230.003, 27014.4, 23694.6 > + startingorg, < 0, 0, 0 >, 75.7, 26.5964, false )
    trigger_10.SetEnterCallback( void function(entity trigger , entity ent)
    {
    //set Checkpoint and shot timer
if (IsValid(ent)){
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){
		int checkpointInThisTrigger = 5
		//show checkpoint msg
		if(ent.p.currentCheckpoint != checkpointInThisTrigger)
			Remote_CallFunction_NonReplay( ent, "MG_Checkpoint_Msg")
		
		//set checkpoint
		ent.p.currentCheckpoint = checkpointInThisTrigger
        }
}
    })
    DispatchSpawn( trigger_10 )
    entity trigger_11 = MapEditor_CreateTrigger( < -3097.104, 27003.29, 24199.3 > + startingorg, < 0, 0, 0 >, 59.65, 26.5964, false )
    trigger_11.SetEnterCallback( void function(entity trigger , entity ent)
    {
    //set Checkpoint and shot timer
if (IsValid(ent)){
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){
		int checkpointInThisTrigger = 6
		//show checkpoint msg
		if(ent.p.currentCheckpoint != checkpointInThisTrigger)
			Remote_CallFunction_NonReplay( ent, "MG_Checkpoint_Msg")
		
		//set checkpoint
		ent.p.currentCheckpoint = checkpointInThisTrigger
        }
}
    })
    DispatchSpawn( trigger_11 )
    entity trigger_12 = MapEditor_CreateTrigger( < -2374.904, 27020.99, 23532 > + startingorg, < 0, 0, 0 >, 72.8, 26.5964, false )
    trigger_12.SetEnterCallback( void function(entity trigger , entity ent)
    {
    //set Checkpoint and shot timer
if (IsValid(ent)){
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){
		int checkpointInThisTrigger = 7
		//show checkpoint msg
		if(ent.p.currentCheckpoint != checkpointInThisTrigger)
			Remote_CallFunction_NonReplay( ent, "MG_Checkpoint_Msg")
		
		//set checkpoint
		ent.p.currentCheckpoint = checkpointInThisTrigger
        }
}
    })
    DispatchSpawn( trigger_12 )
    entity trigger_13 = MapEditor_CreateTrigger( < -1354, 27008.98, 23528.7 > + startingorg, < 0, 0, 0 >, 72.8, 26.5964, false )
    trigger_13.SetEnterCallback( void function(entity trigger , entity ent)
    {
    //set Checkpoint and shot timer
if (IsValid(ent)){
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){
		int checkpointInThisTrigger = 8
		//show checkpoint msg
		if(ent.p.currentCheckpoint != checkpointInThisTrigger)
			Remote_CallFunction_NonReplay( ent, "MG_Checkpoint_Msg")
		
		//set checkpoint
		ent.p.currentCheckpoint = checkpointInThisTrigger
        }
}
    })
    DispatchSpawn( trigger_13 )
    entity trigger_14 = MapEditor_CreateTrigger( < -383.3032, 27008.98, 23911 > + startingorg, < 0, 0, 0 >, 110.25, 85.3, false )
    trigger_14.SetEnterCallback( void function(entity trigger , entity ent)
    {
    //set Checkpoint and shot timer
if (IsValid(ent)){
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){
		int checkpointInThisTrigger = 9
		//show checkpoint msg
		if(ent.p.currentCheckpoint != checkpointInThisTrigger)
			Remote_CallFunction_NonReplay( ent, "MG_Checkpoint_Msg")
		
		//set checkpoint
		ent.p.currentCheckpoint = checkpointInThisTrigger
        }
}
    })
    DispatchSpawn( trigger_14 )
    entity trigger_15 = MapEditor_CreateTrigger( < 2240.197, 26990.38, 23911 > + startingorg, < 0, 0, 0 >, 124.35, 26.5964, false )
    trigger_15.SetEnterCallback( void function(entity trigger , entity ent)
    {
    //set Checkpoint and shot timer
if (IsValid(ent)){
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){
		int checkpointInThisTrigger = 10
		//show checkpoint msg
		if(ent.p.currentCheckpoint != checkpointInThisTrigger)
			Remote_CallFunction_NonReplay( ent, "MG_Checkpoint_Msg")
		
		//set checkpoint
		ent.p.currentCheckpoint = checkpointInThisTrigger
        }
}
    })
    DispatchSpawn( trigger_15 )
    entity trigger_16 = MapEditor_CreateTrigger( < 3390.497, 26995.97, 23892 > + startingorg, < 0, 0, 0 >, 99.25, 26.5964, false )
    trigger_16.SetEnterCallback( void function(entity trigger , entity ent)
    {
    //set Checkpoint and shot timer
if (IsValid(ent)){
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){

		int checkpointInThisTrigger = 11
		//show checkpoint msg
		if(ent.p.currentCheckpoint != checkpointInThisTrigger)
			Remote_CallFunction_NonReplay( ent, "MG_Checkpoint_Msg")
			
		//set checkpoint
		ent.p.currentCheckpoint = checkpointInThisTrigger

        }
}
    })
    DispatchSpawn( trigger_16 )
    entity trigger_17 = MapEditor_CreateTrigger( < 4881.497, 26989.97, 23888 > + startingorg, < 0, 0, 0 >, 72.8, 26.5964, false )
    trigger_17.SetEnterCallback( void function(entity trigger , entity ent)
    {
    //set Checkpoint and shot timer
if (IsValid(ent)){
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){
		int checkpointInThisTrigger = 12
		//show checkpoint msg
		if(ent.p.currentCheckpoint != checkpointInThisTrigger)
			Remote_CallFunction_NonReplay( ent, "MG_Checkpoint_Msg")
		
		//set checkpoint
		ent.p.currentCheckpoint = checkpointInThisTrigger
        }
}
    })
    DispatchSpawn( trigger_17 )
    entity trigger_18 = MapEditor_CreateTrigger( < 5391.397, 26989.96, 23889.5 > + startingorg, < 0, 0, 0 >, 63.3, 26.5964, false )
    trigger_18.SetEnterCallback( void function(entity trigger , entity ent)
    {
    //set Checkpoint and shot timer
if (IsValid(ent)){
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){
		int checkpointInThisTrigger = 13
		//show checkpoint msg
		if(ent.p.currentCheckpoint != checkpointInThisTrigger)
			Remote_CallFunction_NonReplay( ent, "MG_Checkpoint_Msg")
		
		//set checkpoint
		ent.p.currentCheckpoint = checkpointInThisTrigger
        }
}
    })
    DispatchSpawn( trigger_18 )
    entity trigger_19 = MapEditor_CreateTrigger( < 5391.494, 26070.96, 23911 > + startingorg, < 0, 0, 0 >, 69.9, 26.5964, false )
    trigger_19.SetEnterCallback( void function(entity trigger , entity ent)
    {
    //set Checkpoint and shot timer
if (IsValid(ent)){
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){
		int checkpointInThisTrigger = 14
		//show checkpoint msg
		if(ent.p.currentCheckpoint != checkpointInThisTrigger)
			Remote_CallFunction_NonReplay( ent, "MG_Checkpoint_Msg")
		
		//set checkpoint
		ent.p.currentCheckpoint = checkpointInThisTrigger
        }
}
    })
    DispatchSpawn( trigger_19 )
    entity trigger_20 = MapEditor_CreateTrigger( < 5391.492, 25312.96, 24567 > + startingorg, < 0, 0, 0 >, 54.2, 26.5964, false )
    trigger_20.SetEnterCallback( void function(entity trigger , entity ent)
    {
    //set Checkpoint and shot timer
if (IsValid(ent)){
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){
		int checkpointInThisTrigger = 15
		//show checkpoint msg
		if(ent.p.currentCheckpoint != checkpointInThisTrigger)
			Remote_CallFunction_NonReplay( ent, "MG_Checkpoint_Msg")
		
		//set checkpoint
		ent.p.currentCheckpoint = checkpointInThisTrigger
        }
}
    })
    DispatchSpawn( trigger_20 )
    entity trigger_21 = MapEditor_CreateTrigger( < 5391.487, 23653.96, 24861.5 > + startingorg, < 0, 0, 0 >, 116.4, 26.5964, false )
    trigger_21.SetEnterCallback( void function(entity trigger , entity ent)
    {
    //set Checkpoint and shot timer
if (IsValid(ent)){
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){
		int checkpointInThisTrigger = 16
		//show checkpoint msg
		if(ent.p.currentCheckpoint != checkpointInThisTrigger)
			Remote_CallFunction_NonReplay( ent, "MG_Checkpoint_Msg")
		
		//set checkpoint
		ent.p.currentCheckpoint = checkpointInThisTrigger
        }
}
    })
    DispatchSpawn( trigger_21 )
    entity trigger_22 = MapEditor_CreateTrigger( < 5438.482, 22059.96, 24857.4 > + startingorg, < 0, 0, 0 >, 99.2, 26.5964, false )
    trigger_22.SetEnterCallback( void function(entity trigger , entity ent)
    {
    //set Checkpoint and shot timer
if (IsValid(ent)){
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){
		int checkpointInThisTrigger = 17
		//show checkpoint msg
		if(ent.p.currentCheckpoint != checkpointInThisTrigger)
			Remote_CallFunction_NonReplay( ent, "MG_Checkpoint_Msg")
		
		//set checkpoint
		ent.p.currentCheckpoint = checkpointInThisTrigger
        }
}
    })
    DispatchSpawn( trigger_22 )
    entity trigger_23 = MapEditor_CreateTrigger( < 4806, 21211, 24750 > + startingorg, < 0, 0, 0 >, 129.45, 26.5964, false )
    trigger_23.SetEnterCallback( void function(entity trigger , entity ent)
    {
    //set Checkpoint and shot timer
if (IsValid(ent)){
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){
		int checkpointInThisTrigger = 18
		//show checkpoint msg
		if(ent.p.currentCheckpoint != checkpointInThisTrigger)
			Remote_CallFunction_NonReplay( ent, "MG_Checkpoint_Msg")
		
		//set checkpoint
		ent.p.currentCheckpoint = checkpointInThisTrigger
        }
}
    })
    DispatchSpawn( trigger_23 )
    entity trigger_24 = MapEditor_CreateTrigger( < 3400.497, 26985.97, 23903.4 > + startingorg, < 0, 0, 0 >, 223.75, 26.5964, false )
    trigger_24.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
         	  ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
        	  ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
        }
    }

    })
    DispatchSpawn( trigger_24 )
    entity trigger_25 = MapEditor_CreateTrigger( < -6143.503, 26983, 23609 > + startingorg, < 0, 0, 0 >, 134.8, 94.7, false )
    trigger_25.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
         	  ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
        	  ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
        }
    }

    })
    DispatchSpawn( trigger_25 )
    entity trigger_26 = MapEditor_CreateTrigger( < 4084, 26995.97, 23892 > + startingorg, < 0, 0, 0 >, 99.25, 26.5964, false )
    trigger_26.SetEnterCallback( void function(entity trigger , entity ent)
    {
    //set Checkpoint and shot timer
if (IsValid(ent)){
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){

		int checkpointInThisTrigger = 11
		//show checkpoint msg
		if(ent.p.currentCheckpoint != checkpointInThisTrigger)
			Remote_CallFunction_NonReplay( ent, "MG_Checkpoint_Msg")
			
		//set checkpoint
		ent.p.currentCheckpoint = checkpointInThisTrigger

        }
}
    })
    DispatchSpawn( trigger_26 )


}

//Init Octane Segments
void
function MovementGym_Octane() {
  // Props Array
  array < entity > ClipArray;
  array < entity > NoClimbArray;
  array < entity > NoCollisionArray;

  // Props
  MapEditor_CreateProp($"mdl/signs/street_sign_arrow.rmdl", < 15820, -390.2969, 22534.3 > , < 0, 0, 180 > , true, 5000, -1, 2.8878)
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_small_02.rmdl", < 15929.3, -1048.102, 22410.9 > , < 0, 0, 0 > , true, 5000, -1, 1))
  MapEditor_CreateProp($"mdl/ola/sewer_railing_01_128.rmdl", < 9697.8, -776.1016, 22431.7 > , < 0, 89.9999, 0 > , true, 5000, -1, 1)
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 9647, -903, 22424.9 > , < 0, 0, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 9647, -55, 22424.9 > , < 0, 0, 0 > , true, 5000, -1, 1))
  MapEditor_CreateProp($"mdl/ola/sewer_railing_01_128.rmdl", < 9593.604, -182.1016, 22431.7 > , < 0, -90.0005, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/ola/sewer_railing_01_128.rmdl", < 13450.19, -107.9063, 22431.7 > , < 0, -0.0005, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/ola/sewer_railing_01_128.rmdl", < 13193.68, -824.2969, 22431.7 > , < 0, 179.9998, 0 > , true, 5000, -1, 1)
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 13323.09, -54.5078, 22424.9 > , < 0, 90, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 13320.58, -870.3984, 22424.9 > , < 0, 90, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/ola/sewer_railing_01_128.rmdl", < 13192.28, -830.6016, 22431.1 > , < 0, 179.9998, 0 > , false, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/ola/sewer_railing_01_128.rmdl", < 13451.2, -102.8984, 22430.8 > , < 0, -0.0005, 0 > , false, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 13282.6, -902.9297, 22439.1 > , < 0, -179.9999, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 13244.6, -851.7813, 22436.1 > , < 0, -179.9999, 0 > , true, 5000, -1, 1.3183))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 13266.7, -878, 22312.1 > , < 0, 90, 0 > , true, 5000, -1, 0.7657141)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 13238.6, -951.7031, 22434.1 > , < 0, -179.9999, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 13388.3, -831.7031, 22434.1 > , < 0, 0.0001, 0 > , true, 5000, -1, 1.3183))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 13351.1, -891.6797, 22312.1 > , < 0, -90, 0 > , true, 5000, -1, 0.7657141)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 13382.3, -931.625, 22436.1 > , < 0, 0.0001, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 13344.3, -880.4766, 22439.1 > , < 0, 0.0001, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 13307.27, -843.5234, 22439.1 > , < 0, 90.0001, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 13358.42, -805.5234, 22436.1 > , < 0, 90.0001, 0 > , true, 5000, -1, 1.3183))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 13318.48, -836.7266, 22312.1 > , < 0, 0, 0 > , true, 5000, -1, 0.7657141)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 13258.5, -799.5234, 22434.1 > , < 0, 90.0001, 0 > , true, 5000, -1, 1.3183))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 13318.48, -934.4219, 22312.1 > , < 0, -180, 0 > , true, 5000, -1, 0.7657141)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 13259.92, 28.7031, 22434.1 > , < 0, 90.0001, 0 > , true, 5000, -1, 1.3183))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 13319.9, -8.5, 22312.1 > , < 0, 0, 0 > , true, 5000, -1, 0.7657141)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 13359.84, 22.7031, 22436.1 > , < 0, 90.0001, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 13308.69, -15.2969, 22439.1 > , < 0, 90.0001, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 13331.15, -77, 22439.1 > , < 0, -89.9999, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 13280, -115, 22436.1 > , < 0, -89.9999, 0 > , true, 5000, -1, 1.3183))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 13319.94, -83.7969, 22312.1 > , < 0, -180, 0 > , true, 5000, -1, 0.7657141)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 13379.92, -121, 22434.1 > , < 0, -89.9999, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 13412.1, 8.7969, 22434.1 > , < 0, 0.0001, 0 > , true, 5000, -1, 1.3183))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 13374.9, -51.1797, 22312.1 > , < 0, -90, 0 > , true, 5000, -1, 0.7657142)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 13406.1, -91.1172, 22436.1 > , < 0, 0.0001, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 13368.1, -39.9688, 22439.1 > , < 0, 0.0001, 0 > , true, 5000, -1, 1.3183))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 13277.2, -51.1797, 22312.1 > , < 0, 90, 0 > , true, 5000, -1, 0.7657141)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 10453.02, 2218.898, 22312.1 > , < 0, 0, 0 > , true, 5000, -1, 0.7657141)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 10413.08, 2090, 22436.1 > , < 0, -89.9999, 0 > , true, 5000, -1, 1.3183))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 10453.02, 2121.203, 22312.1 > , < 0, -180, 0 > , true, 5000, -1, 0.7657141)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 10513, 2084, 22434.1 > , < 0, -89.9999, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 10383.2, 2116.18, 22434.1 > , < 0, -179.9999, 0 > , true, 5000, -1, 1.3183))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 10420.4, 2176.156, 22312.1 > , < 0, 90, 0 > , true, 5000, -1, 0.7657141)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 10389.2, 2216.102, 22436.1 > , < 0, -179.9999, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 10427.2, 2164.953, 22439.1 > , < 0, -179.9999, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 10488.9, 2187.406, 22439.1 > , < 0, 0, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 10526.9, 2136.258, 22436.1 > , < 0, 0, 0 > , true, 5000, -1, 1.3183))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 10495.7, 2176.203, 22312.1 > , < 0, -90, 0 > , true, 5000, -1, 0.7657142)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 10532.9, 2236.18, 22434.1 > , < 0, 0, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 9726.603, 20.9219, 22434.1 > , < 0, 0, 0 > , true, 5000, -1, 1.3183))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 9689.399, -39.0625, 22312.1 > , < 0, -90, 0 > , true, 5000, -1, 0.7657142)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 9720.602, -79, 22436.1 > , < 0, 0, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 9682.601, -27.8516, 22439.1 > , < 0, 0, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 9620.9, -50.3125, 22439.1 > , < 0, -179.9999, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 9582.9, 0.8359, 22436.1 > , < 0, -179.9999, 0 > , true, 5000, -1, 1.3183))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 9614.1, -39.1016, 22312.1 > , < 0, 90, 0 > , true, 5000, -1, 0.7657141)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 9576.898, -99.0781, 22434.1 > , < 0, -179.9999, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 9706.7, -131.2578, 22434.1 > , < 0, -89.9999, 0 > , true, 5000, -1, 1.3183))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 9646.721, -94.0547, 22312.1 > , < 0, -180, 0 > , true, 5000, -1, 0.7657141)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 9606.781, -125.2578, 22436.1 > , < 0, -89.9999, 0 > , true, 5000, -1, 1.3183))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 9646.721, 3.6406, 22312.1 > , < 0, 0, 0 > , true, 5000, -1, 0.7657141)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 9571.096, -974.1016, 22434.1 > , < 0, -180, 0 > , true, 5000, -1, 1.3183))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 9608.299, -914.1172, 22312.1 > , < 0, 90, 0 > , true, 5000, -1, 0.7657142)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 9577.096, -874.1797, 22436.1 > , < 0, -180, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 9615.098, -925.3281, 22439.1 > , < 0, -180, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 9676.798, -902.875, 22439.1 > , < 0, 0.0001, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 9714.798, -954.0234, 22436.1 > , < 0, 0.0001, 0 > , true, 5000, -1, 1.3183))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 9683.598, -914.0781, 22312.1 > , < 0, -90, 0 > , true, 5000, -1, 0.7657141)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 9720.8, -854.1016, 22434.1 > , < 0, 0.0001, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 9590.997, -821.9219, 22434.1 > , < 0, 90.0001, 0 > , true, 5000, -1, 1.3183))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 9650.978, -859.125, 22312.1 > , < 0, 0, 0 > , true, 5000, -1, 0.7657141)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 9690.917, -827.9219, 22436.1 > , < 0, 90.0001, 0 > , true, 5000, -1, 1.3183))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 9650.977, -956.8203, 22312.1 > , < 0, -180, 0 > , true, 5000, -1, 0.7657141)
  MapEditor_CreateProp($"mdl/ola/sewer_railing_01_128.rmdl", < 16247.98, -389, 22431.7 > , < 0, 179.9995, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/ola/sewer_railing_01_128.rmdl", < 15854.8, -776.1016, 22431.7 > , < 0, 89.9999, 0 > , true, 5000, -1, 1)
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 16375.08, -442.3984, 22424.9 > , < 0, -90, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 15804, -903, 22424.9 > , < 0, 0, 0 > , true, 5000, -1, 1))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 16433.72, -442.1172, 22312.1 > , < 0, -90, 0 > , true, 5000, -1, 0.7657142)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 16304.82, -402.1797, 22436.1 > , < 0, -179.9999, 0 > , true, 5000, -1, 1.3183))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 16336.02, -442.1172, 22312.1 > , < 0, 90, 0 > , true, 5000, -1, 0.7657141)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 16298.82, -502.1016, 22434.1 > , < 0, -179.9999, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 16331, -372.2969, 22434.1 > , < 0, 90.0001, 0 > , true, 5000, -1, 1.3183))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 16390.98, -409.5, 22312.1 > , < 0, 0, 0 > , true, 5000, -1, 0.7657141)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 16430.92, -378.2969, 22436.1 > , < 0, 90.0001, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 16379.77, -416.2969, 22439.1 > , < 0, 90.0001, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 16402.23, -478, 22439.1 > , < 0, -90, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 16351.08, -516, 22436.1 > , < 0, -90, 0 > , true, 5000, -1, 1.3183))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 16391.02, -484.7969, 22312.1 > , < 0, -180, 0 > , true, 5000, -1, 0.7657141)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 16451, -522, 22434.1 > , < 0, -90, 0 > , true, 5000, -1, 1.3183))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 15807.98, -956.8203, 22312.1 > , < 0, -180, 0 > , true, 5000, -1, 0.7657141)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 15847.92, -827.9219, 22436.1 > , < 0, 90.0001, 0 > , true, 5000, -1, 1.3183))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 15807.98, -859.125, 22312.1 > , < 0, 0, 0 > , true, 5000, -1, 0.7657141)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 15748, -821.9219, 22434.1 > , < 0, 90.0001, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 15877.8, -854.1016, 22434.1 > , < 0, 0.0001, 0 > , true, 5000, -1, 1.3183))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 15840.6, -914.0781, 22312.1 > , < 0, -90, 0 > , true, 5000, -1, 0.7657141)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 15871.8, -954.0234, 22436.1 > , < 0, 0.0001, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 15833.8, -902.875, 22439.1 > , < 0, 0.0001, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 15772.1, -925.3281, 22439.1 > , < 0, -180, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 15734.1, -874.1797, 22436.1 > , < 0, -180, 0 > , true, 5000, -1, 1.3183))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 15765.3, -914.1172, 22312.1 > , < 0, 90, 0 > , true, 5000, -1, 0.7657142)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 15728.1, -974.1016, 22434.1 > , < 0, -180, 0 > , true, 5000, -1, 1.3183))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_small_02.rmdl", < 15929.3, -776.7031, 22410.9 > , < 0, 0, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_small_02.rmdl", < 15929.3, -1048.102, 22553.3 > , < 0, 0, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_small_02.rmdl", < 15929.3, -776.7031, 22553.3 > , < 0, 0, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_small_02.rmdl", < 16201.2, -640.2969, 22410.9 > , < 0, -90, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_small_02.rmdl", < 16472.6, -640.2969, 22410.9 > , < 0, -90, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_small_02.rmdl", < 16472.6, -640.2969, 22553.3 > , < 0, -90, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_small_02.rmdl", < 16201.2, -640.2969, 22553.3 > , < 0, -90, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_small_03.rmdl", < -8327.6, 8918.297, 22030.3 > , < 0, -90, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < -8463.4, 8918.297, 22283.7 > , < 0, -90, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < -8847.301, 8918.297, 22157.1 > , < 0, -90, 0 > , true, 5000, -1, 1))
  MapEditor_CreateProp($"mdl/signs/street_sign_arrow.rmdl", < -2338.4, 9119.297, 21946.8 > , < -90, 180, 0 > , true, 5000, -1, 4.715525)
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -5769.898, 8792.203, 22408.21 > , < 0, -179.9999, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -2337.1, 8790, 21901 > , < 0, 0, 0 > , true, 5000, -1, 1))
  MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -2337.1, 8790, 22389.3 > , < 0, 0, 0 > , true, 5000, -1, 1)
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -2338, 8665, 22068 > , < 0, 0, 90.0001 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -2338, 8665, 22684 > , < 0, 0, 90.0001 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -6539.1, 8790, 21901 > , < 0, 0, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -6422.1, 8790, 22031.5 > , < 90, 0, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -6670, 8790, 22031.5 > , < 90, 0, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -6537, 8677.703, 22031.5 > , < 90, -90, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -6539.1, 8790, 22151.3 > , < 0, 0, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -5635, 8840, 22068 > , < -0.0001, 90.0001, 90 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -5635, 8840, 22684 > , < -0.0001, 90.0001, 90 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -5909, 8669, 22068 > , < 0, 0.0001, 90.0001 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -5909, 8669, 22684 > , < 0, 0.0001, 90.0001 > , true, 5000, -1, 1))
  MapEditor_CreateProp($"mdl/signs/street_sign_arrow.rmdl", < -2338.4, 9119.297, 22164.8 > , < -30, -90.0001, -90 > , true, 5000, -1, 4.715525)
  MapEditor_CreateProp($"mdl/signs/street_sign_arrow.rmdl", < -6559.898, 9119, 21946.8 > , < -45, -0.0001, 180 > , true, 5000, -1, 4.715525)
  MapEditor_CreateProp($"mdl/signs/street_sign_arrow.rmdl", < -5810, 9087.703, 22470.6 > , < -28.7601, -58.7473, 175.6741 > , true, 5000, -1, 4.715526)
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -8940.6, 8790, 21901 > , < 0, 0, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -8823.6, 8790, 22031.5 > , < 90, 0, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -9071.5, 8790, 22031.5 > , < 90, 0, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -8938.5, 8677.703, 22031.5 > , < 90, -90, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -8940.6, 8790, 22151.3 > , < 0, 0, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -8168.1, 8567.102, 22408.21 > , < 0, -179.9999, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -8310.5, 8440.594, 22684 > , < 0, 0.0001, 90.0001 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -8310.5, 8440.602, 22068 > , < 0, 0.0001, 90.0001 > , true, 5000, -1, 1))
  MapEditor_CreateProp($"mdl/signs/street_sign_arrow.rmdl", < -8961.398, 9119, 21946.8 > , < -45, -0.0001, 180 > , true, 5000, -1, 4.715525)
  MapEditor_CreateProp($"mdl/signs/street_sign_arrow.rmdl", < -8053, 9087.688, 22505.9 > , < -0.0001, -90, 180 > , true, 5000, -1, 4.715525)
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -8036.5, 8770, 22068 > , < -0.0001, 90.0001, 90 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -8036.5, 8770, 22684 > , < -0.0001, 90.0001, 90 > , true, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/desertlands_apartments_rug_01.rmdl", < -2336.033, 8788.969, 22405.3 > , < 0, 7.2791, 0 > , true, 5000, -1, 1.6393))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < -8847.301, 8918.297, 22283.7 > , < 0, -90, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < -8847.301, 8918.297, 22410.3 > , < 0, -90, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < -8847.301, 8918.297, 22535.4 > , < 0, -90, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < -8847.301, 8918.297, 22662 > , < 0, -90, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < -8847.301, 8918.297, 22788.6 > , < 0, -90, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < -8463.4, 8918.297, 22157.1 > , < 0, -90, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < -8463.4, 8918.297, 22410.3 > , < 0, -90, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < -8463.4, 8918.297, 22535.4 > , < 0, -90, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < -8463.4, 8918.297, 22662 > , < 0, -90, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < -8463.4, 8918.297, 22788.6 > , < 0, -90, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < -8295.5, 8568.602, 22410.3 > , < 0, -180, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < -8295.5, 8568.602, 22157.1 > , < 0, -180, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < -8295.5, 8568.602, 22283.7 > , < 0, -180, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < -8295.5, 8568.602, 22535.4 > , < 0, -180, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < -8295.5, 8568.602, 22662 > , < 0, -180, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < -8295.5, 8568.602, 22788.6 > , < 0, -180, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < -8582.6, 8918.297, 22030.3 > , < 0, -90, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < -8582.6, 8918.297, 21903.8 > , < 0, -90, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_small_03.rmdl", < -8327.6, 8918.297, 21903.8 > , < 0, -90, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < -6448.699, 8918.297, 22157.1 > , < 0, -90, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < -6448.699, 8918.297, 22283.7 > , < 0, -90, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < -6448.699, 8918.297, 22410.3 > , < 0, -90, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < -6448.699, 8918.297, 22788.6 > , < 0, -90, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < -6448.699, 8918.297, 22662 > , < 0, -90, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < -6448.699, 8918.297, 22535.4 > , < 0, -90, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < -6064.801, 8918.297, 22283.7 > , < 0, -90, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < -6064.801, 8918.297, 22157.1 > , < 0, -90, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < -6064.801, 8918.297, 22410.3 > , < 0, -90, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < -6064.801, 8918.297, 22535.4 > , < 0, -90, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < -6064.801, 8918.297, 22662 > , < 0, -90, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_320_01.rmdl", < -6064.801, 8918.297, 22788.6 > , < 0, -90, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < -5896.9, 8568.602, 22410.3 > , < 0, -180, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < -5896.9, 8568.602, 22157.1 > , < 0, -180, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < -5896.9, 8568.602, 22283.7 > , < 0, -180, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < -5896.9, 8568.602, 22535.4 > , < 0, -180, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < -5896.9, 8568.602, 22662 > , < 0, -180, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < -5896.9, 8568.602, 22788.6 > , < 0, -180, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < -6184, 8918.297, 22030.3 > , < 0, -90, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < -6184, 8918.297, 21903.8 > , < 0, -90, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_small_03.rmdl", < -5929, 8918.297, 22030.3 > , < 0, -90, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_small_03.rmdl", < -5929, 8918.297, 21903.8 > , < 0, -90, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < -5896.9, 8568.602, 22030.3 > , < 0, -180, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < -5896.9, 8568.602, 21903.8 > , < 0, -180, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < -8295.5, 8568.602, 21903.8 > , < 0, -180, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < -8295.5, 8568.602, 22030.3 > , < 0, -180, 0 > , true, 5000, -1, 1))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < -2281.798, 8783.539, 21785.9 > , < 0, -90.0001, 0 > , true, 5000, -1, 0.7657141)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -2410.7, 8823.477, 21909.9 > , < 0, -180, 0 > , true, 5000, -1, 1.3183))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < -2379.498, 8783.539, 21785.9 > , < 0, 89.9999, 0 > , true, 5000, -1, 0.7657145)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -2416.702, 8723.563, 21907.9 > , < 0, -180, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -2384.521, 8853.359, 21907.9 > , < 0, 90.0001, 0 > , true, 5000, -1, 1.3183))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < -2324.539, 8816.156, 21785.9 > , < 0, 0, 0 > , true, 5000, -1, 0.7657141)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -2284.601, 8847.359, 21909.9 > , < 0, 90.0001, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -2335.749, 8809.359, 21912.9 > , < 0, 90.0001, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -2313.291, 8747.656, 21912.9 > , < 0, -90, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -2364.439, 8709.656, 21909.9 > , < 0, -90, 0 > , true, 5000, -1, 1.3183))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < -2324.501, 8740.859, 21785.9 > , < 0, 179.9999, 0 > , true, 5000, -1, 0.7657141)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -2264.519, 8703.656, 21907.9 > , < 0, -90, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -5718.521, 8711.797, 22417.7 > , < 0, -89.9999, 0 > , true, 5000, -1, 1.3183))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < -5821.242, 8781.617, 22295.7 > , < 0, 90, 0 > , true, 5000, -1, 0.7657145)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -5686.342, 8841.594, 22417.7 > , < 0, 0.0001, 0 > , true, 5000, -1, 1.3183))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < -5778.541, 8824.297, 22295.7 > , < 0, 0, 0 > , true, 5000, -1, 0.7657141)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -5789.75, 8817.5, 22422.7 > , < 0, 90.0001, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -5818.441, 8717.797, 22419.7 > , < 0, -89.9999, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -5692.34, 8741.68, 22419.7 > , < 0, 0.0001, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -5767.293, 8755.797, 22422.7 > , < 0, -89.9999, 0 > , true, 5000, -1, 1.3183))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < -5723.543, 8781.617, 22295.7 > , < 0, -90, 0 > , true, 5000, -1, 0.7657145)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -5838.523, 8861.5, 22417.7 > , < 0, 90.0001, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -5738.6, 8855.5, 22419.7 > , < 0, 90.0001, 0 > , true, 5000, -1, 1.3183))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < -5778.5, 8749, 22295.7 > , < 0, -180, 0 > , true, 5000, -1, 0.7657141)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -5856.9, 8786.602, 22419.7 > , < 0, -89.9999, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -6468.598, 8846.219, 21907.2 > , < 0, 0.0001, 0 > , true, 5000, -1, 1.3183))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < -6538.42, 8743.5, 21785.2 > , < 0, -180, 0 > , true, 5000, -1, 0.7657141)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -6598.398, 8878.398, 21907.2 > , < 0, 90.0001, 0 > , true, 5000, -1, 1.3183))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < -6581.1, 8786.203, 21785.2 > , < 0, 90, 0 > , true, 5000, -1, 0.7657145)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -6574.301, 8774.992, 21912.2 > , < 0, -180, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -6474.6, 8746.297, 21909.2 > , < 0, 0.0001, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -6498.48, 8872.398, 21909.2 > , < 0, 90.0001, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -6512.602, 8797.445, 21912.2 > , < 0, 0.0001, 0 > , true, 5000, -1, 1.3183))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < -6538.422, 8841.203, 21785.2 > , < 0, 0, 0 > , true, 5000, -1, 0.7657141)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -6618.305, 8726.219, 21907.2 > , < 0, -180, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -6612.301, 8826.141, 21909.2 > , < 0, -180, 0 > , true, 5000, -1, 1.3183))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < -6505.801, 8786.242, 21785.2 > , < 0, -90, 0 > , true, 5000, -1, 0.7657145)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -8866.699, 8831.32, 21908.2 > , < 0, 0.0001, 0 > , true, 5000, -1, 1.3183))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < -8936.521, 8728.602, 21786.2 > , < 0, 180, 0 > , true, 5000, -1, 0.7657141)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -8996.5, 8863.5, 21908.2 > , < 0, 90, 0 > , true, 5000, -1, 1.3183))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < -8979.199, 8771.297, 21786.2 > , < 0, 89.9999, 0 > , true, 5000, -1, 0.7657145)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -8972.398, 8760.094, 21913.2 > , < 0, -180, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -8872.703, 8731.398, 21910.2 > , < 0, 0.0001, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -8896.58, 8857.5, 21910.2 > , < 0, 90, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -8910.701, 8782.547, 21913.2 > , < 0, 0.0001, 0 > , true, 5000, -1, 1.3183))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < -8936.521, 8826.297, 21786.2 > , < 0, -0.0001, 0 > , true, 5000, -1, 0.7657141)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -9016.402, 8711.32, 21908.2 > , < 0, -180, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -9010.402, 8811.242, 21910.2 > , < 0, -180, 0 > , true, 5000, -1, 1.3183))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < -8903.9, 8771.336, 21786.2 > , < 0, -90, 0 > , true, 5000, -1, 0.7657141)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < -8134.5, 8545.797, 22294.8 > , < 0, -90, 0 > , true, 5000, -1, 0.7657141)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -8241, 8585.703, 22418.8 > , < 0, -180, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -8247, 8485.773, 22416.8 > , < 0, -180, 0 > , true, 5000, -1, 1.3183))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < -8167.121, 8600.758, 22294.8 > , < 0, -0.0001, 0 > , true, 5000, -1, 0.7657141)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -8141.301, 8557.008, 22421.8 > , < 0, 0.0001, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -8127.18, 8631.961, 22418.8 > , < 0, 90, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -8103.301, 8505.859, 22418.8 > , < 0, 0.0001, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -8202.998, 8534.547, 22421.8 > , < 0, -180, 0 > , true, 5000, -1, 1.3183))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < -8209.799, 8545.758, 22294.8 > , < 0, 89.9999, 0 > , true, 5000, -1, 0.7657145)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -8227.1, 8637.961, 22416.8 > , < 0, 90, 0 > , true, 5000, -1, 1.3183))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < -8167.121, 8503.055, 22294.8 > , < 0, 180, 0 > , true, 5000, -1, 0.7657141)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -8097.299, 8605.781, 22416.8 > , < 0, 0.0001, 0 > , true, 5000, -1, 1.3183))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -6674.869, 9145.203, 22068.15 > , < 0.0001, -90, 90 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -6674.871, 9145.195, 22684.15 > , < 0.0001, -90, 90 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -6674.869, 9745.203, 22068.15 > , < 0.0001, -90, 90 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -6674.871, 9745.195, 22684.15 > , < 0.0001, -90, 90 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -9067.867, 9145.211, 22068.15 > , < 0.0001, -90, 90 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -9067.869, 9145.203, 22684.15 > , < 0.0001, -90, 90 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -9067.867, 9745.211, 22068.15 > , < 0.0001, -90, 90 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -9067.869, 9745.203, 22684.15 > , < 0.0001, -90, 90 > , true, 5000, -1, 1))

  foreach(entity ent in ClipArray) {
    ent.MakeInvisible()
    ent.kv.solid = 6
    ent.kv.CollisionGroup = TRACE_COLLISION_GROUP_PLAYER
    ent.kv.contents = CONTENTS_PLAYERCLIP
  }
  foreach(entity ent in NoClimbArray) ent.kv.solid = 3
  foreach(entity ent in NoCollisionArray) ent.kv.solid = 0

  // Buttons
  AddCallback_OnUseEntity(CreateFRButton( < 9645.9, 64.3984, 22440.6 > , < 0, 0.0002, 0 > , "%use% Next Exercise"), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < 13320.5800, -915.8755, 42443.1000 > +tpoffset, < 0, 89.9998, 0 > )
    })

  AddCallback_OnUseEntity(CreateFRButton( < 9524.8, -903.7969, 22440.6 > , < 0, 90.0007, 0 > , "%use% Hub"), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < 10726.9000, 10287, -4283 > , < 0, -89.9998, 0 > )
      Message(user, "HUB", "\n  You now recieved Phase Walk Tactical")
    })

  AddCallback_OnUseEntity(CreateFRButton( < 13203.69, -55.6094, 22440.6 > , < 0, 90.0002, 0 > , "%use% Next Exercise "), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < 15795.4000, -987.9000, 42440.6000 > +tpoffset, < 0, 89.9998, 0 > )
    })

  AddCallback_OnUseEntity(CreateFRButton( < 13321.38, -983.8984, 22440.6 > , < 0, -179.9993, 0 > , "%use% Hub"), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < 10726.9000, 10287, -4283 > , < 0, -89.9998, 0 > )
      Message(user, "HUB", "\n  You now recieved Phase Walk Tactical")
    })

  AddCallback_OnUseEntity(CreateFRButton( < 16494.48, -441.2969, 22440.6 > , < 0, -89.9998, 0 > , "%use% Repeat"), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < 15795.4000, -987.9000, 42440.6000 > +tpoffset, < 0, 89.9998, 0 > )
    })

  AddCallback_OnUseEntity(CreateFRButton( < 15681.8, -903.7969, 22440.6 > , < 0, 90.0007, 0 > , "%use% Hub"), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < 10726.9000, 10287, -4283 > , < 0, -89.9998, 0 > )
      Message(user, "HUB", "\n  You now recieved Phase Walk Tactical")
    })

  AddCallback_OnUseEntity(CreateFRButton( < -2221.9, 8789.602, 21916.1 > , < 0, -90.0002, 0 > , "%use% Back to Hub"), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < 10726.9000, 10287, -4283 > , < 0, -89.9998, 0 > )
      Message(user, "Hub")
    })

  AddCallback_OnUseEntity(CreateFRButton( < -2221.9, 8789.602, 22404.8 > , < 0, -90.0002, 0 > , "%use% Next Exercise"), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < -6531.1010, 8698.3000, 41914.3000 > +tpoffset, < 0, 89.9998, 0 > )
    })

  AddCallback_OnUseEntity(CreateFRButton( < -2451.5, 8783, 22404.9 > , < 0, 90.0002, 0 > , "%use% Repeat"), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < -2329.1000, 8714.7000, 41919.5000 > +tpoffset, < 0, 89.9998, 0 > )
      Message(user, "Jump Pad Tap Strafes")
    })

  AddCallback_OnUseEntity(CreateFRButton( < -6423.869, 8855.203, 21916.1 > , < 0, -90.0002, 0 > , "%use% Back to Hub"), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < 10726.9000, 10287, -4283 > , < 0, -89.9998, 0 > )
      Message(user, "Hub")
    })

  AddCallback_OnUseEntity(CreateFRButton( < -5880.801, 8790.703, 22423.6 > , < 0, 89.9999, 0 > , "%use% Next Exercise"), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < -8932.6010, 8698.3000, 41914.3000 > +tpoffset, < 0, 89.9998, 0 > )
    })

  AddCallback_OnUseEntity(CreateFRButton( < -5660.701, 8797.297, 22423.7 > , < 0, -89.9997, 0 > , "%use% Repeat"), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < -6531.1010, 8698.3000, 41914.3000 > +tpoffset, < 0, 89.9998, 0 > )
      Message(user, "Jump Pad Tap Strafes")
    })

  AddCallback_OnUseEntity(CreateFRButton( < -8058.902, 8572.203, 22417.89 > , < 0, -89.9997, 0 > , "%use% Repeat"), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < -8932.6010, 8698.3000, 41914.3000 > +tpoffset, < 0, 89.9998, 0 > )
      Message(user, "Jump Pad Tap Strafes")
    })

  AddCallback_OnUseEntity(CreateFRButton( < -8825.4, 8849.203, 21916.1 > , < 0, -90.0002, 0 > , "%use% Back to Hub"), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < 10726.9000, 10287, -4283 > , < 0, -89.9998, 0 > )
      Message(user, "Hub")
    })

  AddCallback_OnUseEntity(CreateFRButton( < -8279, 8565.602, 22420.46 > , < 0, 89.9999, 0 > , "%use% Back to Hub"), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < 10726.9000, 10287, -4283 > , < 0, -89.9998, 0 > )
      Message(user, "Hub")
    })

  // Jumppads
  MapEditor_CreateJumpPad(MapEditor_CreateProp($"mdl/props/octane_jump_pad/octane_jump_pad.rmdl", < -2337.1, 8867.703, 21907 > , < 0, 0, 0 > , true, 5000, -1, 1))
  MapEditor_CreateJumpPad(MapEditor_CreateProp($"mdl/props/octane_jump_pad/octane_jump_pad.rmdl", < -6539.1, 8867.703, 21907 > , < 0, 0, 0 > , true, 5000, -1, 1))
  MapEditor_CreateJumpPad(MapEditor_CreateProp($"mdl/props/octane_jump_pad/octane_jump_pad.rmdl", < -8940.6, 8867.703, 21907 > , < 0, 0, 0 > , true, 5000, -1, 1))

  // Triggers
  entity trigger_0 = MapEditor_CreateTrigger( < 9705, -508, 22607 > , < 0, 0, 0 > , 1109.034, 221.8068, false)
  trigger_0.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          StatusEffect_StopAllOfType(ent, eStatusEffect.speed_boost)
          StatusEffect_StopAllOfType(ent, eStatusEffect.stim_visual_effect)
          ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
          ent.GiveOffhandWeapon("mp_ability_heal", OFFHAND_TACTICAL)
        }
      }

    })
  DispatchSpawn(trigger_0)
  entity trigger_1 = MapEditor_CreateTrigger( < 9705, -508, 22156 > , < 0, 0, 0 > , 1109.034, 221.8068, false)
  trigger_1.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          ent.SetOrigin( < 9647, -963, 42441.2000 > +tpoffset) // change tp location
        }
      }
    })
  DispatchSpawn(trigger_1)
  entity trigger_2 = MapEditor_CreateTrigger( < 9649.3, -48.7031, 22444.9 > , < 0, 0, 0 > , 132.982, 27, false)
  trigger_2.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          StatusEffect_StopAllOfType(ent, eStatusEffect.speed_boost)
          StatusEffect_StopAllOfType(ent, eStatusEffect.stim_visual_effect)
          ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
          ent.GiveOffhandWeapon("mp_ability_heal", OFFHAND_TACTICAL)
        }
      }

    })
  DispatchSpawn(trigger_2)
  entity trigger_3 = MapEditor_CreateTrigger( < 9649.3, -906.2031, 22444.9 > , < 0, 0, 0 > , 132.982, 27, false)
  trigger_3.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          StatusEffect_StopAllOfType(ent, eStatusEffect.speed_boost)
          StatusEffect_StopAllOfType(ent, eStatusEffect.stim_visual_effect)
          ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
          ent.GiveOffhandWeapon("mp_ability_heal", OFFHAND_TACTICAL)
        }
      }
    })
  DispatchSpawn(trigger_3)
  entity trigger_4 = MapEditor_CreateTrigger( < 13375.7, -508.2969, 22607 > , < 0, 0, 0 > , 1109.034, 221.8068, false)
  trigger_4.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          StatusEffect_StopAllOfType(ent, eStatusEffect.speed_boost)
          StatusEffect_StopAllOfType(ent, eStatusEffect.stim_visual_effect)
          ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
          ent.GiveOffhandWeapon("mp_ability_heal", OFFHAND_TACTICAL)
        }
      }

    })
  DispatchSpawn(trigger_4)
  entity trigger_5 = MapEditor_CreateTrigger( < 13375.7, -508.2969, 22156 > , < 0, 0, 0 > , 1109.034, 221.8068, false)
  trigger_5.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          ent.SetOrigin( < 13320.5800, -915.8755, 42443.1000 > +tpoffset) // change tp location
        }
      }
    })
  DispatchSpawn(trigger_5)
  entity trigger_6 = MapEditor_CreateTrigger( < 13320, -868.3203, 22444.9 > , < 0, 0, 0 > , 132.982, 26.5964, false)
  trigger_6.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          StatusEffect_StopAllOfType(ent, eStatusEffect.speed_boost)
          StatusEffect_StopAllOfType(ent, eStatusEffect.stim_visual_effect)
          ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
          ent.GiveOffhandWeapon("mp_ability_heal", OFFHAND_TACTICAL)
        }
      }
    })
  DispatchSpawn(trigger_6)
  entity trigger_7 = MapEditor_CreateTrigger( < 13316.79, -52.2109, 22444.9 > , < 0, 90, 0 > , 132.982, 26.5964, false)
  trigger_7.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          StatusEffect_StopAllOfType(ent, eStatusEffect.speed_boost)
          StatusEffect_StopAllOfType(ent, eStatusEffect.stim_visual_effect)
          ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
          ent.GiveOffhandWeapon("mp_ability_heal", OFFHAND_TACTICAL)
        }
      }
    })
  DispatchSpawn(trigger_7)
  entity trigger_8 = MapEditor_CreateTrigger( < 15862, -508, 22637 > , < 0, 0, 0 > , 1256.646, 251.3293, false)
  trigger_8.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          StatusEffect_StopAllOfType(ent, eStatusEffect.speed_boost)
          StatusEffect_StopAllOfType(ent, eStatusEffect.stim_visual_effect)
          ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
          ent.GiveOffhandWeapon("mp_ability_heal", OFFHAND_TACTICAL)
        }
      }

    })
  DispatchSpawn(trigger_8)
  entity trigger_9 = MapEditor_CreateTrigger( < 15862, -508, 22126 > , < 0, 0, 0 > , 1256.646, 251.3293, false)
  trigger_9.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          ent.SetOrigin( < 15795.4000, -987.9000, 42440.6000 > +tpoffset) // change tp location
        }
      }
    })
  DispatchSpawn(trigger_9)
  entity trigger_10 = MapEditor_CreateTrigger( < 15806.3, -906.2031, 22444.9 > , < 0, 0, 0 > , 132.982, 26.5964, false)
  trigger_10.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          StatusEffect_StopAllOfType(ent, eStatusEffect.speed_boost)
          StatusEffect_StopAllOfType(ent, eStatusEffect.stim_visual_effect)
          ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
          ent.GiveOffhandWeapon("mp_ability_heal", OFFHAND_TACTICAL)
        }
      }
    })
  DispatchSpawn(trigger_10)
  entity trigger_11 = MapEditor_CreateTrigger( < 16381.38, -444.6953, 22444.9 > , < 0, -90, 0 > , 132.982, 26.5964, false)
  trigger_11.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          StatusEffect_StopAllOfType(ent, eStatusEffect.speed_boost)
          StatusEffect_StopAllOfType(ent, eStatusEffect.stim_visual_effect)
          ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
          ent.GiveOffhandWeapon("mp_ability_heal", OFFHAND_TACTICAL)
        }
      }

    })
  DispatchSpawn(trigger_11)
  entity trigger_12 = MapEditor_CreateTrigger( < -2309, 8932, 21602 > , < 0, 0, 0 > , 1373.995, 274.799, false)
  trigger_12.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          ent.SetOrigin( < -2329.1000, 8714.7000, 41919.5000 > +tpoffset) // change tp location
        }
      }
    })
  DispatchSpawn(trigger_12)
  entity trigger_13 = MapEditor_CreateTrigger( < -6226, 8932, 21625 > , < 0, 0, 0 > , 1192.691, 238.5382, false)
  trigger_13.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          ent.SetOrigin( < -6531.1010, 8698.3000, 41914.3000 > +tpoffset) // change tp location
        }
      }
    })
  DispatchSpawn(trigger_13)
  entity trigger_14 = MapEditor_CreateTrigger( < -8627.5, 8932, 21628 > , < 0, 0, 0 > , 1192.691, 238.5382, false)
  trigger_14.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          ent.SetOrigin( < -8932.6010, 8698.3000, 41914.3000 > +tpoffset) // change tp location
        }
      }
    })
  DispatchSpawn(trigger_14)
  entity trigger_15 = MapEditor_CreateTrigger( < -2309, 10518.2, 21602 > , < 0, 0, 0 > , 1373.995, 274.799, false)
  trigger_15.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          ent.SetOrigin( < -2329.1000, 8714.7000, 41919.5000 > +tpoffset) // change tp location
        }
      }
    })
  DispatchSpawn(trigger_15)
  entity trigger_16 = MapEditor_CreateTrigger( < -3676.869, 9202.203, 21602 > , < 0, 0, 0 > , 1373.995, 274.799, false)
  trigger_16.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          ent.SetOrigin( < -2329.1000, 8714.7000, 41919.5000 > +tpoffset) // change tp location
        }
      }
    })
  DispatchSpawn(trigger_16)
  entity trigger_17 = MapEditor_CreateTrigger( < -597.8691, 9202.203, 21602 > , < 0, 0, 0 > , 1373.995, 274.799, false)
  trigger_17.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          ent.SetOrigin( < -2329.1000, 8714.7000, 41919.5000 > +tpoffset) // change tp location
        }
      }
    })
  DispatchSpawn(trigger_17)
  entity trigger_18 = MapEditor_CreateTrigger( < -6226, 10238.2, 21625 > , < 0, 0, 0 > , 1192.691, 238.5382, false)
  trigger_18.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          ent.SetOrigin( < -6531.1010, 8698.3000, 41914.3000 > +tpoffset) // change tp location
        }
      }
    })
  DispatchSpawn(trigger_18)
  entity trigger_19 = MapEditor_CreateTrigger( < -8627.5, 10315.2, 21628 > , < 0, 0, 0 > , 1192.691, 238.5382, false)
  trigger_19.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          ent.SetOrigin( < -8932.6010, 8698.3000, 41914.3000 > +tpoffset) // change tp location
        }
      }
    })
  DispatchSpawn(trigger_19)
  entity trigger_20 = MapEditor_CreateTrigger( < -2309, 7282.203, 21602 > , < 0, 0, 0 > , 1373.995, 274.799, false)
  trigger_20.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          ent.SetOrigin( < -2329.1000, 8714.7000, 41919.5000 > +tpoffset) // change tp location
        }
      }
    })
  DispatchSpawn(trigger_20)

}

//Init Tapstrafe Segments
void
function MovementGym_Tapstrafe() {
  // Props Array
  array < entity > ClipArray;
  array < entity > NoClimbArray;
  array < entity > NoCollisionArray;

  // Props
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 3391.99, 2753.797, 22424.9 > , < 0, 0, 0 > , true, 5000, -1, 1))
  MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 3391.99, 3133, 22492.83 > , < 0, -180, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.04, 3417.891, 22524.85 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.04, 2943.727, 22417 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.039, 3071.953, 22425.39 > , < 0, -90, 179.9997 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.039, 2943.727, 22425 > , < 0, -90, 179.9997 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.039, 3546.109, 22533.23 > , < 0, -90, 179.9997 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.04, 3071.953, 22416.62 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.039, 3417.891, 22532.84 > , < 0, -90, 179.9997 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 3391.99, 3607.453, 22601.16 > , < 0, -180, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.04, 3546.398, 22524.96 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 3391.99, 4045.547, 22712.64 > , < 0, -180, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.04, 4330.438, 22743.12 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.04, 3856.281, 22636.81 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.039, 3984.5, 22645.2 > , < 0, -90, 179.9997 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.039, 3856.281, 22644.81 > , < 0, -90, 179.9997 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.039, 4458.656, 22751.5 > , < 0, -90, 179.9997 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.04, 3984.5, 22636.43 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.039, 4330.438, 22751.11 > , < 0, -90, 179.9997 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 3391.99, 4520, 22819.43 > , < 0, -180, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.04, 4458.953, 22743.22 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 3391.99, 4975.047, 22920.43 > , < 0, -180, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.04, 5259.938, 22948.43 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.04, 4785.781, 22844.61 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.039, 4914, 22852.99 > , < 0, -90, 179.9997 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.039, 4785.781, 22852.61 > , < 0, -90, 179.9997 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.039, 5388.156, 22956.81 > , < 0, -90, 179.9997 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.04, 4914, 22844.22 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.039, 5259.938, 22956.43 > , < 0, -90, 179.9997 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 3391.99, 5449.5, 23024.75 > , < 0, -180, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.04, 5388.453, 22948.54 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 3391.99, 6376.5, 23245.43 > , < 0, -180, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl", < 3391.99, 5902.047, 23141.26 > , < 0, -180, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.04, 6186.938, 23169.12 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.04, 5712.781, 23065.43 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.039, 5841, 23073.82 > , < 0, -90, 179.9997 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.039, 5712.781, 23073.43 > , < 0, -90, 179.9997 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.04, 6315.453, 23169.22 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.039, 6315.156, 23177.5 > , < 0, -90, 179.9997 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.04, 5841, 23065.05 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < 3391.039, 6186.938, 23177.11 > , < 0, -90, 179.9997 > , true, 5000, -1, 1)
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 3391.99, 6719.297, 23253.63 > , < 0, 0, 0 > , true, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 3465.622, 2807.32, 22434.1 > , < 0, 0.0001, 0 > , true, 5000, -1, 1.3183))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 3395.8, 2704.602, 22312.1 > , < 0, 180, 0 > , true, 5000, -1, 0.7657141)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 3335.82, 2839.5, 22434.1 > , < 0, 90, 0 > , true, 5000, -1, 1.3183))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 3353.121, 2747.305, 22312.1 > , < 0, 89.9999, 0 > , true, 5000, -1, 0.7657142)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 3359.92, 2736.094, 22439.1 > , < 0, -180, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 3459.621, 2707.406, 22436.1 > , < 0, 0.0001, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 3435.739, 2833.5, 22436.1 > , < 0, 90, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 3421.62, 2758.547, 22439.1 > , < 0, 0.0001, 0 > , true, 5000, -1, 1.3183))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 3395.8, 2802.297, 22312.1 > , < 0, -0.0001, 0 > , true, 5000, -1, 0.7657141)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 3315.918, 2687.32, 22434.1 > , < 0, -180, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 3321.919, 2787.242, 22436.1 > , < 0, -180, 0 > , true, 5000, -1, 1.3183))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 3428.421, 2747.344, 22312.1 > , < 0, -90, 0 > , true, 5000, -1, 0.7657141)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 3317.217, 6668.984, 23262.13 > , < 0, -179.9999, 0 > , true, 5000, -1, 1.3183))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 3387.04, 6771.703, 23140.13 > , < 0, 0, 0 > , true, 5000, -1, 0.7657141)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 3447.019, 6636.797, 23262.13 > , < 0, -89.9999, 0 > , true, 5000, -1, 1.3183))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 3429.718, 6729, 23140.13 > , < 0, -90, 0 > , true, 5000, -1, 0.7657142)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 3422.919, 6740.211, 23267.13 > , < 0, 0, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 3323.219, 6768.898, 23264.13 > , < 0, -179.9999, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 3347.1, 6642.797, 23264.13 > , < 0, -89.9999, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 3361.219, 6717.75, 23267.13 > , < 0, -179.9999, 0 > , true, 5000, -1, 1.3183))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 3387.04, 6674, 23140.13 > , < 0, -180, 0 > , true, 5000, -1, 0.7657141)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 3466.921, 6788.984, 23262.13 > , < 0, 0, 0 > , true, 5000, -1, 1.3183))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 3460.92, 6689.063, 23264.13 > , < 0, 0, 0 > , true, 5000, -1, 1.3183))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 3354.418, 6728.961, 23140.13 > , < 0, 90, 0 > , true, 5000, -1, 0.7657141)
  MapEditor_CreateProp($"mdl/barriers/concrete/concrete_barrier_fence.rmdl", < -17416, 231, 21935.86 > , < 0, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -17424, 622.0078, 21916 > , < -90, -89.9998, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -17224, 5380.102, 21915.6 > , < 0, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/pipes/pipe_modular_painted_grey_256.rmdl", < -17149.1, 5118, 21939.9 > , < 0, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17280, 514.5, 21923.1 > , < 0, -180, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17280, 298.2578, 21923.5 > , < 0, -180, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17552, 298.2578, 21923.5 > , < 0, -180, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17552, 514.5, 21923.7 > , < 0, -180, 0 > , true, 5000, -1, 1)
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17144, 2780, 22066 > , < 90, -180, 0 > , true, 5000, -1, 1))
  MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17280, 2524, 21923.5 > , < 0, -180, 0 > , true, 5000, -1, 1)
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17030, 2892.203, 22066 > , < 90, 90.0002, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17144, 3100, 22066 > , < 90, -180, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17274, 2972.203, 22066 > , < 90, 90.0002, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17030, 3528.102, 22066 > , < 90, 90.0002, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17144, 3414, 22066 > , < 90, -180, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17030, 3286, 22066 > , < 90, 90.0002, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17274, 3214, 22066 > , < 90, 90.0002, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17030, 2650, 22066 > , < 90, 90.0002, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17274, 3843, 22066 > , < 90, 90.0002, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17274, 3601.203, 22066 > , < 90, 90.0002, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17030, 4157.703, 22066 > , < 90, 90.0002, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17030, 4551.5, 22066 > , < 90, 90.0002, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17274, 4479.5, 22066 > , < 90, 90.0002, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17144, 4045.5, 22066 > , < 90, -180, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17030, 4793.602, 22066 > , < 90, 90.0002, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17144, 4681.398, 22066 > , < 90, -180, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17274, 4237.703, 22066 > , < 90, 90.0002, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17030, 3915.5, 22066 > , < 90, 90.0002, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17274, 5108.5, 22066 > , < 90, 90.0002, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17274, 4866.703, 22066 > , < 90, 90.0002, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17144, 3730, 22066 > , < 90, -180, 0 > , true, 5000, -1, 1))
  MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17326, 5252, 21923.5 > , < 0, 89.9995, 0 > , true, 5000, -1, 1)
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17326, 5108.703, 22066 > , < 90, 90.0002, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17144, 4367, 22066 > , < 90, -180, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17144, 4997, 22066 > , < 90, -180, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17407.8, 514.5, 22056 > , < 90, -180, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17408.2, 298.2578, 22056 > , < 90, -180, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17407.8, 514.5, 22308 > , < 90, -180, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17408.2, 298.2578, 22308 > , < 90, -180, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17307.88, 155.8047, 22056 > , < 90, 90.0002, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17524.13, 156.1953, 22056 > , < 90, 90.0002, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17307.88, 155.8047, 22308 > , < 90, 90.0002, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17524.13, 156.1953, 22308 > , < 90, 90.0002, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17407.8, 514.5, 22562 > , < 90, -180, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17408.2, 298.2578, 22562 > , < 90, -180, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17307.88, 155.8047, 22562 > , < 90, 90.0002, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17524.13, 156.1953, 22562 > , < 90, 90.0002, 0 > , true, 5000, -1, 1))
  MapEditor_CreateProp($"mdl/signs/street_sign_arrow.rmdl", < -17280, 788.5, 21992 > , < 0, 179.9997, 0 > , true, 5000, -1, 2.98)
  MapEditor_CreateProp($"mdl/signs/street_sign_arrow.rmdl", < -17432, 772.5, 21992 > , < 0, -135.0004, 0 > , true, 5000, -1, 2.98)
  MapEditor_CreateProp($"mdl/signs/street_sign_arrow.rmdl", < -17192, 2972, 22018 > , < -0.0003, 0.0003, 180 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/signs/street_sign_arrow.rmdl", < -17166, 2972, 22028 > , < -90, 179.9997, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/signs/street_sign_arrow.rmdl", < -17110.34, 3286, 22018 > , < 0, 179.9997, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/signs/street_sign_arrow.rmdl", < -17137.03, 3286, 22028 > , < -90, 179.9997, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/signs/street_sign_arrow.rmdl", < -17192, 3601, 22018 > , < -0.0003, 0.0003, 180 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/signs/street_sign_arrow.rmdl", < -17166, 3601, 22028 > , < -90, 179.9997, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/signs/street_sign_arrow.rmdl", < -17137.03, 3915, 22028 > , < -90, 179.9997, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/signs/street_sign_arrow.rmdl", < -17110.34, 3915, 22018 > , < 0, 179.9997, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/signs/street_sign_arrow.rmdl", < -17110.34, 4551, 22018 > , < 0, 179.9997, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/signs/street_sign_arrow.rmdl", < -17137.03, 4551, 22028 > , < -90, 179.9997, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/signs/street_sign_arrow.rmdl", < -17166, 4237, 22028 > , < -90, 179.9997, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/signs/street_sign_arrow.rmdl", < -17192, 4237, 22018 > , < -0.0003, 0.0003, 180 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/signs/street_sign_arrow.rmdl", < -17192, 4865, 22018 > , < -0.0003, 0.0003, 180 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/signs/street_sign_arrow.rmdl", < -17166, 4865, 22028 > , < -90, 179.9997, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/signs/street_sign_arrow.rmdl", < -17078, 5179, 22032 > , < 0, 162.5526, 0 > , true, 5000, -1, 2.75)
  MapEditor_CreateProp($"mdl/pipes/pipe_modular_painted_grey_256.rmdl", < -17149.1, 4872.297, 21939.9 > , < 0, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/pipes/pipe_modular_painted_grey_256.rmdl", < -17149.1, 4488, 21939.9 > , < 0, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/pipes/pipe_modular_painted_grey_256.rmdl", < -17149.1, 4242.297, 21939.9 > , < 0, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/pipes/pipe_modular_painted_grey_256.rmdl", < -17149.1, 3607, 21939.9 > , < 0, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/pipes/pipe_modular_painted_grey_256.rmdl", < -17149.1, 3852.703, 21939.9 > , < 0, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/pipes/pipe_modular_painted_grey_256.rmdl", < -17149.1, 3223.297, 21939.9 > , < 0, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/pipes/pipe_modular_painted_grey_256.rmdl", < -17149.1, 2977.602, 21939.9 > , < 0, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/pipes/pipe_modular_painted_grey_256.rmdl", < -17153.9, 2657.602, 21939.9 > , < 0, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/pipes/pipe_modular_painted_grey_256.rmdl", < -17153.9, 2903.297, 21939.9 > , < 0, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/pipes/pipe_modular_painted_grey_256.rmdl", < -17153.9, 3537.5, 21939.9 > , < 0, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/pipes/pipe_modular_painted_grey_256.rmdl", < -17153.9, 3291.797, 21939.9 > , < 0, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/pipes/pipe_modular_painted_grey_256.rmdl", < -17153.9, 4169.398, 21939.9 > , < 0, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/pipes/pipe_modular_painted_grey_256.rmdl", < -17153.9, 3922.898, 21939.9 > , < 0, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/pipes/pipe_modular_painted_grey_256.rmdl", < -17153.9, 4557.898, 21939.9 > , < 0, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/pipes/pipe_modular_painted_grey_256.rmdl", < -17153.9, 4803.602, 21939.9 > , < 0, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -17144, 5122.797, 21916.9 > , < 0, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -17400, 5098.898, 21916.9 > , < 0, 89.9998, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -17182, 4810, 21916.9 > , < 0, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -17144, 4494, 21916.9 > , < 0, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -17182, 4173.602, 21916.9 > , < 0, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -17182, 3542, 21916.9 > , < 0, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -17144, 3858.203, 21916.9 > , < 0, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -17182, 2906, 21916.9 > , < 0, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -17144, 3228, 21916.9 > , < 0, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -17200, 5402, 21915.6 > , < 0, -89.9998, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -17456, 5380.102, 21915.6 > , < 0, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -17656.01, 644, 21916 > , < -90, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -17656.01, 425.7578, 21915.9 > , < -90, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -17424, 169.7656, 21916 > , < -90, -89.9998, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -17152, 169.7656, 21916 > , < -90, -89.9998, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -17152.01, 425.7578, 21916 > , < -90, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -17152.01, 644, 21916 > , < -90, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -17154, 622.0078, 21916 > , < -90, -89.9998, 0 > , true, 5000, -1, 1)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/desertlands_apartments_rug_01.rmdl", < -17281.22, 317.3438, 21939.9 > , < 0, 171.0228, 0 > , true, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/desertlands_apartments_rug_01.rmdl", < -17551.61, 509.5703, 21940.37 > , < 0, 121.4849, 0 > , true, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/desertlands_apartments_rug_01.rmdl", < -17280.62, 570.2422, 21939.9 > , < 0, -77.4886, 0 > , true, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/desertlands_apartments_rug_01.rmdl", < -17551.77, 298.0781, 21940.37 > , < 0, 73.3119, 0 > , true, 5000, -1, 1))
  MapEditor_CreateProp($"mdl/barriers/concrete/concrete_barrier_fence.rmdl", < -17416, 363, 21935.86 > , < 0, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/barriers/concrete/concrete_barrier_fence.rmdl", < -17416, 497, 21935.86 > , < 0, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/barriers/concrete/concrete_barrier_fence.rmdl", < -17416, 629, 21935.86 > , < 0, 0, 0 > , true, 5000, -1, 1)

  foreach(entity ent in ClipArray) {
    ent.MakeInvisible()
    ent.kv.solid = 6
    ent.kv.CollisionGroup = TRACE_COLLISION_GROUP_PLAYER
    ent.kv.contents = CONTENTS_PLAYERCLIP
  }

  foreach(entity ent in NoClimbArray) ent.kv.solid = 3
  foreach(entity ent in NoCollisionArray) ent.kv.solid = 0

  // Buttons
  AddCallback_OnUseEntity(CreateFRButton( < 3353.6, 6830.5, 23263.43 > , < 0, -0.0004, 0 > , "%use% Hub"), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < 10726.9000, 10287, -4283 > , < 0, -89.9998, 0 > )
      Message(user, "Hub")
    })

  AddCallback_OnUseEntity(CreateFRButton( < 3429.6, 6830.5, 23263.43 > , < 0, -0.0004, 0 > , "%use% Repeat Exercise "), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < 3391.9900, 2660.3000, 42441.2000 > +tpoffset, < 0, 89.9998, 0 > )
    })

  AddCallback_OnUseEntity(CreateFRButton( < 3393.208, 2632.102, 22434.8 > , < 0, 180, 0 > , "%use% Hub"), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < 10726.9000, 10287, -4283 > , < 0, -89.9998, 0 > )
      Message(user, "Hub")
    })

  AddCallback_OnUseEntity(CreateFRButton( < -17279.39, 197.0078, 21938.35 > , < 0, 180, 0 > , "%use% Back to Hub"), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < 10726.9000, 10287, -4283 > , < 0, -89.9998, 0 > )
      Message(user, "Hub")
    })

  AddCallback_OnUseEntity(CreateFRButton( < -17511.38, 197.0078, 21938.35 > , < 0, 180, 0 > , "%use% Next Exercise "), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < -17280, 2500, 41940 > +tpoffset, < 0, 89.9998, 0 > )
    })

  AddCallback_OnUseEntity(CreateFRButton( < -17589.38, 197.0078, 21938.35 > , < 0, 180, 0 > , "%use% Repeat"), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < -17280, 258.0005, 41940 > +tpoffset, < 0, 89.9998, 0 > )
    })

  AddCallback_OnUseEntity(CreateFRButton( < -17279.39, 2406.508, 21938.35 > , < 0, 180, 0 > , "%use% Back to Hub"), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < 10726.9000, 10287, -4283 > , < 0, -89.9998, 0 > )
      Message(user, "Hub")
    })

  AddCallback_OnUseEntity(CreateFRButton( < -17443.5, 5289.383, 21938.35 > , < 0, 89.9995, 0 > , "%use% Repeat"), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < -17280, 2500, 41940 > +tpoffset, < 0, 89.9998, 0 > )
    })

  AddCallback_OnUseEntity(CreateFRButton( < -17443.5, 5211.383, 21938.35 > , < 0, 89.9995, 0 > , "%use% Next Exercise "), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < 3391.9900, 2660.3000, 42441.2000 > +tpoffset, < 0, 89.9998, 0 > )
    })

  // Triggers
  entity trigger_0 = MapEditor_CreateTrigger( < 3311, 6984, 21856 > , < 0, 0, 0 > , 2388.858, 477.7715, false)
  trigger_0.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          ent.SetOrigin( < 3391.9900, 2660.3000, 42441.2000 > +tpoffset) // change tp location
        }
      }
    })
  DispatchSpawn(trigger_0)
  entity trigger_1 = MapEditor_CreateTrigger( < 3311, 4854, 21856 > , < 0, 0, 0 > , 2388.858, 477.7715, false)
  trigger_1.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          ent.SetOrigin( < 3391.9900, 2660.3000, 42441.2000 > +tpoffset) // change tp location
        }
      }
    })
  DispatchSpawn(trigger_1)
  entity trigger_2 = MapEditor_CreateTrigger( < 3311, 3524, 21856 > , < 0, 0, 0 > , 2388.858, 477.7715, false)
  trigger_2.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          ent.SetOrigin( < 3391.9900, 2660.3000, 42441.2000 > +tpoffset) // change tp location
        }
      }
    })
  DispatchSpawn(trigger_2)
  entity trigger_3 = MapEditor_CreateTrigger( < -17428, 490, 21740 > , < 0, 0, 0 > , 804.6815, 160.9363, false)
  trigger_3.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          ent.SetOrigin( < -17280, 258.0005, 41940 > +tpoffset) // change tp location
        }
      }
    })
  DispatchSpawn(trigger_3)
  entity trigger_4 = MapEditor_CreateTrigger( < -17188, 2924, 21740 > , < 0, 0, 0 > , 804.6815, 160.9363, false)
  trigger_4.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          ent.SetOrigin( < -17280, 2500, 41940 > +tpoffset) // change tp location
        }
      }
    })
  DispatchSpawn(trigger_4)
  entity trigger_5 = MapEditor_CreateTrigger( < -17188, 3584, 21740 > , < 0, 0, 0 > , 402.3408, 160.9363, false)
  trigger_5.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          ent.SetOrigin( < -17280, 2500, 41940 > +tpoffset) // change tp location
        }
      }
    })
  DispatchSpawn(trigger_5)
  entity trigger_6 = MapEditor_CreateTrigger( < -17188, 4326, 21740 > , < 0, 0, 0 > , 804.6815, 160.9363, false)
  trigger_6.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          ent.SetOrigin( < -17280, 2500, 41940 > +tpoffset) // change tp location
        }
      }
    })
  DispatchSpawn(trigger_6)
  entity trigger_7 = MapEditor_CreateTrigger( < -17188, 5146, 21740 > , < 0, 0, 0 > , 804.6815, 160.9363, false)
  trigger_7.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          ent.SetOrigin( < -17280, 2500, 41940 > +tpoffset) // change tp location
        }
      }
    })
  DispatchSpawn(trigger_7)

}

//Init Superglide Segments
void
function MovementGym_Superglide() {
  // Props Array
  array < entity > NoClimbArray;
  array < entity > NoCollisionArray;

  // Props
  MapEditor_CreateProp($"mdl/signs/street_sign_arrow.rmdl", < -23520, 7918, 21962 > , < -4.558, -74.895, 142.0979 > , true, 5000, -1, 2.46)
  MapEditor_CreateProp($"mdl/signs/street_sign_arrow.rmdl", < -21684, 7880, 22026 > , < -0.0003, -0.0003, 180 > , true, 5000, -1, 3.15)
  MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -21641.99, 7896, 21940 > , < 90, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/domestic/ac_unit_dirty_32x64_01_a.rmdl", < -23426.56, 7315.469, 21962 > , < 0.0002, 90, 89.9998 > , true, 5000, -1, 1.33)
  MapEditor_CreateProp($"mdl/domestic/bar_sink.rmdl", < -23749.96, 7955.813, 21982.67 > , < 0, 179.9997, 0 > , true, 5000, -1, 1.54)
  MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < -21616, 7509.938, 22171.94 > , < 0, -89.9998, 89.9998 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/domestic/tv_LED_med_panel.rmdl", < -21857.89, 7682, 22034.04 > , < 0, 0, 0 > , true, 5000, -1, 2.14)
  MapEditor_CreateProp($"mdl/desertlands/desertlands_apartments_planter_02.rmdl", < -21828, 7848, 21938.02 > , < 0, 0, 0 > , true, 5000, -1, 1.19)
  MapEditor_CreateProp($"mdl/desertlands/desertlands_building_ice_02.rmdl", < -23804.61, 7318.922, 21979.33 > , < 1.1701, -165.045, -4.3717 > , true, 5000, -1, 0.09000002)
  MapEditor_CreateProp($"mdl/levels_terrain/mp_rr_canyonlands/clands_roof_bars_01_fglass_blue.rmdl", < -23564, 7523.656, 22169.69 > , < 0, 0, 0 > , true, 5000, -1, 1)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/desertlands_apartments_rug_02.rmdl", < -21175.25, 7716, 21939.3 > , < 0, -89.9998, 0 > , true, 5000, -1, 0.85))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -21620, 7638, 21988 > , < 90, -179.9996, 0 > , true, 5000, -1, 1))
  MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17280, 8384, 21923.5 > , < 0, -180, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17280, 7768.5, 21923.5 > , < 0, -180, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < -17216, 7864, 21939.81 > , < 0, -179.9998, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17280, 9153.25, 21923.5 > , < 0, -180, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17280, 11756, 21923.5 > , < 0, -180, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < -17344, 8288, 21939.81 > , < 0, -179.9998, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17280, 9804, 21923.5 > , < 0, -180, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17280, 10426.75, 21923.5 > , < 0, -180, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -17280, 11089.88, 21923.5 > , < 0, -180, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -21748, 7768.5, 21923.5 > , < 0, -180, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < -21684, 7864, 21951.81 > , < 0, -179.9998, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -21748, 7638, 21923.25 > , < 0, -180, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -21054.58, 7768, 21923.5 > , < 0, 90.0002, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < -20959.08, 7704, 21951.81 > , < 0, 90.0003, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -21185.08, 7768, 21923.25 > , < 0, 90.0002, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -21054.58, 7150.586, 21923.5 > , < 0, 0.0003, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < -21118.58, 7055.086, 21951.81 > , < 0, 0.0005, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -21054.58, 7281.086, 21923.25 > , < 0, 0.0003, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -21737.42, 7138, 21923.5 > , < 0, -89.9995, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < -21832.92, 7202, 21951.81 > , < 0, -89.9993, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -21606.92, 7138, 21923.25 > , < 0, -89.9995, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -23692, 7844.648, 21923.5 > , < 0, -180, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < -23628, 7940.148, 21951.81 > , < 0, -179.9998, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -23692, 7638, 21923.25 > , < 0, -180, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -23450.84, 7559.25, 21923.5 > , < 0, -180, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -23450.84, 7428.75, 21923.25 > , < 0, -180, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/city_pipe_grate_medium_128.rmdl", < -23516.84, 7331.969, 21951.81 > , < 0, 0.0005, 0 > , true, 5000, -1, 1)
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -21185.08, 7640, 21988 > , < 90, 90.0006, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -21182, 7281.086, 21988 > , < 90, 0.0007, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -21608, 7250.203, 21988 > , < 90, 90.0012, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -21736, 7010.203, 21988 > , < 90, 90.0012, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -21606.92, 7010, 21988 > , < 90, 90.0012, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -20942, 7281.086, 21988 > , < 90, 0.0007, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -20942.2, 7150, 21988 > , < 90, 0.0007, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -21185.08, 7880, 21988 > , < 90, 90.0006, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -21056, 7880.203, 21988 > , < 90, 90.0006, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -21875.9, 7767.539, 21988 > , < 90, 0.0007, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -21876.1, 7636.461, 21988 > , < 90, 0.0007, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -20926, 7768, 21988 > , < 90, -179.9996, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -21054, 7022, 21988 > , < 90, 90.0006, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -21864, 7136, 21988 > , < 90, 0.0007, 0 > , true, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/desertlands_apartments_rug_02.rmdl", < -21154.97, 7820.664, 21939.3 > , < 0, 90.0005, 0 > , true, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/desertlands_apartments_rug_02.rmdl", < -21798.5, 7673, 21939.3 > , < 0, -179.9997, 0 > , true, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/desertlands_apartments_rug_02.rmdl", < -21693.84, 7644.727, 21939.3 > , < 0, 0.0007, 0 > , true, 5000, -1, 0.82))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/desertlands_apartments_rug_02.rmdl", < -21102, 7271.273, 21939.3 > , < 0, -179.9997, 0 > , true, 5000, -1, 0.82))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/desertlands_apartments_rug_02.rmdl", < -20997.34, 7244.773, 21939.3 > , < 0, 0.0007, 0 > , true, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/desertlands_apartments_rug_02.rmdl", < -21638.42, 7082.641, 21939.3 > , < 0, -89.9998, 0 > , true, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/desertlands_apartments_rug_02.rmdl", < -21612.73, 7187.297, 21939.3 > , < 0, 90.0005, 0 > , true, 5000, -1, 0.8200001))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -21748, 7880, 21988 > , < 90, 90.0005, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -23820.1, 7636.461, 21988 > , < 90, 0.0007, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -23819.9, 7843.688, 21988 > , < 90, 0.0007, 0 > , true, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/desertlands_apartments_rug_02.rmdl", < -23637.84, 7666.891, 21939.3 > , < 0, 0.0007, 0 > , true, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/desertlands_apartments_rug_02.rmdl", < -23742.5, 7731.109, 21939.3 > , < 0, -179.9997, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -23692, 7956.148, 21988 > , < 90, 90.0005, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -23580, 7596, 21988 > , < 90, 0.0007, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -23340.74, 7559.539, 21988 > , < 90, 0.0007, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -23340.94, 7428.461, 21988 > , < 90, 0.0007, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -23452.84, 7315.961, 21988 > , < 90, -89.9992, 0 > , true, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/desertlands_apartments_rug_02.rmdl", < -23402.34, 7522.961, 21939.3 > , < 0, 0.0007, 0 > , true, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/desertlands_apartments_rug_02.rmdl", < -23507.07, 7563.289, 21939.5 > , < 0, 174.2769, 0 > , true, 5000, -1, 0.73))
  MapEditor_CreateProp($"mdl/levels_terrain/mp_rr_canyonlands/clands_roof_bars_01_fglass_blue.rmdl", < -23564, 7747.656, 22169.69 > , < 0, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/levels_terrain/mp_rr_canyonlands/clands_roof_bars_01_fglass_blue.rmdl", < -23324, 7523.656, 22169.69 > , < 0, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/levels_terrain/mp_rr_canyonlands/clands_roof_bars_01_fglass_blue.rmdl", < -23324, 7747.656, 22169.69 > , < 0, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/levels_terrain/mp_rr_canyonlands/clands_roof_bars_01_fglass_blue.rmdl", < -23564, 7971.656, 22169.69 > , < 0, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/levels_terrain/mp_rr_canyonlands/clands_roof_bars_01_fglass_blue.rmdl", < -23324, 7971.656, 22169.69 > , < 0, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/desertlands_building_ice_02.rmdl", < -23335.66, 7952.008, 21981.33 > , < 1.1701, 9.8988, -4.3717 > , true, 5000, -1, 0.09)
  MapEditor_CreateProp($"mdl/levels_terrain/mp_rr_canyonlands/clands_roof_bars_01_fglass_blue.rmdl", < -21620, 7671.656, 22169.69 > , < 0, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/levels_terrain/mp_rr_canyonlands/clands_roof_bars_01_fglass_blue.rmdl", < -21640.35, 7008, 22169.69 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/levels_terrain/mp_rr_canyonlands/clands_roof_bars_01_fglass_blue.rmdl", < -20926, 7245.656, 22169.69 > , < 0, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/levels_terrain/mp_rr_canyonlands/clands_roof_bars_01_fglass_blue.rmdl", < -20926, 7640, 22169.69 > , < 0, -90, 0 > , true, 5000, -1, 1)
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -21620, 7638, 22114 > , < 90, -179.9996, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -21185.08, 7640, 22114 > , < 90, 90.0006, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -21182, 7281.086, 22114 > , < 90, 0.0007, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -21608, 7250.203, 22114 > , < 90, 90.0012, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -21736, 7010.203, 22114 > , < 90, 90.0012, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -21606.92, 7010, 22114 > , < 90, 90.0012, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -20942, 7281.086, 22114 > , < 90, 0.0007, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -20942.2, 7150, 22114 > , < 90, 0.0007, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -21185.08, 7880, 22114 > , < 90, 90.0006, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -21056, 7880.203, 22114 > , < 90, 90.0006, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -21876.1, 7636.461, 22114 > , < 90, 0.0007, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -21875.9, 7767.539, 22114 > , < 90, 0.0007, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -20926, 7768, 22114 > , < 90, -179.9996, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -21054, 7022, 22114 > , < 90, 90.0006, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -21864, 7136, 22114 > , < 90, 0.0007, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -21748, 7880, 22114 > , < 90, 90.0005, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -23692, 7956.148, 22114 > , < 90, 90.0005, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -23819.9, 7843.688, 22114 > , < 90, 0.0007, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -23820.1, 7636.461, 22114 > , < 90, 0.0007, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -23580, 7596, 22114 > , < 90, 0.0007, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -23340.94, 7428.461, 22114 > , < 90, 0.0007, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -23340.74, 7559.539, 22114 > , < 90, 0.0007, 0 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -23452.84, 7315.961, 22114 > , < 90, -89.9992, 0 > , true, 5000, -1, 1))
  MapEditor_CreateProp($"mdl/levels_terrain/mp_rr_canyonlands/clands_roof_bars_01_fglass_blue.rmdl", < -21620, 7895.656, 22169.69 > , < 0, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/levels_terrain/mp_rr_canyonlands/clands_roof_bars_01_fglass_blue.rmdl", < -21150.35, 7640, 22169.69 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/levels_terrain/mp_rr_canyonlands/clands_roof_bars_01_fglass_blue.rmdl", < -20926, 7469.656, 22169.69 > , < 0, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/desertlands_apartments_planter_02.rmdl", < -21780, 7848, 21938.02 > , < 0, 0, 0 > , true, 5000, -1, 1.19)
  MapEditor_CreateProp($"mdl/foliage/plant_desert_yucca_01.rmdl", < -21780.29, 7847.563, 21972.81 > , < 0, 0, 0 > , true, 5000, -1, 0.45)
  MapEditor_CreateProp($"mdl/foliage/plant_desert_yucca_01.rmdl", < -21826.45, 7847.563, 21972.81 > , < 0, 0, 0 > , true, 5000, -1, 0.45)
  MapEditor_CreateProp($"mdl/desertlands/desertlands_apartments_planter_02.rmdl", < -21020, 7064, 21938.02 > , < 0, 0, 0 > , true, 5000, -1, 1.19)
  MapEditor_CreateProp($"mdl/desertlands/desertlands_apartments_planter_02.rmdl", < -20972, 7064, 21938.02 > , < 0, 0, 0 > , true, 5000, -1, 1.19)
  MapEditor_CreateProp($"mdl/foliage/plant_desert_yucca_01.rmdl", < -20972.29, 7063.563, 21972.81 > , < 0, 0, 0 > , true, 5000, -1, 0.45)
  MapEditor_CreateProp($"mdl/foliage/plant_desert_yucca_01.rmdl", < -21018.45, 7063.563, 21972.81 > , < 0, 0, 0 > , true, 5000, -1, 0.45)
  MapEditor_CreateProp($"mdl/foliage/plant_desert_yucca_01.rmdl", < -20967.56, 7801.547, 21972.81 > , < 0, 89.9998, 0 > , true, 5000, -1, 0.45)
  MapEditor_CreateProp($"mdl/foliage/plant_desert_yucca_01.rmdl", < -20967.56, 7847.711, 21972.81 > , < 0, 89.9998, 0 > , true, 5000, -1, 0.45)
  MapEditor_CreateProp($"mdl/desertlands/desertlands_apartments_planter_02.rmdl", < -20968, 7848, 21938.02 > , < 0, 89.9998, 0 > , true, 5000, -1, 1.19)
  MapEditor_CreateProp($"mdl/desertlands/desertlands_apartments_planter_02.rmdl", < -20968, 7800, 21938.02 > , < 0, 89.9998, 0 > , true, 5000, -1, 1.19)
  MapEditor_CreateProp($"mdl/desertlands/desertlands_apartments_planter_02.rmdl", < -21820, 7058, 21938.02 > , < 0, 89.9998, 0 > , true, 5000, -1, 1.19)
  MapEditor_CreateProp($"mdl/desertlands/desertlands_apartments_planter_02.rmdl", < -21820, 7106, 21938.02 > , < 0, 89.9998, 0 > , true, 5000, -1, 1.19)
  MapEditor_CreateProp($"mdl/foliage/plant_desert_yucca_01.rmdl", < -21819.56, 7105.711, 21972.81 > , < 0, 89.9998, 0 > , true, 5000, -1, 0.45)
  MapEditor_CreateProp($"mdl/foliage/plant_desert_yucca_01.rmdl", < -21819.56, 7059.547, 21972.81 > , < 0, 89.9998, 0 > , true, 5000, -1, 0.45)
  MapEditor_CreateProp($"mdl/domestic/tv_LED_med_panel.rmdl", < -21652, 7028.227, 22034.04 > , < 0, 89.9998, 0 > , true, 5000, -1, 2.14)
  MapEditor_CreateProp($"mdl/domestic/tv_LED_med_panel.rmdl", < -20944.23, 7226, 22034.04 > , < 0, 179.9997, 0 > , true, 5000, -1, 2.14)
  MapEditor_CreateProp($"mdl/domestic/tv_LED_med_panel.rmdl", < -21146, 7877.773, 22034.04 > , < 0, -90.0005, 0 > , true, 5000, -1, 2.14)
  MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < -21852.99, 7509.938, 22171.94 > , < 0, -89.9998, 89.9998 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < -21311.1, 7636.5, 22171.94 > , < 0, -179.9997, 89.9998 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < -21311.1, 7873.492, 22171.94 > , < 0, -179.9997, 89.9998 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < -20948.51, 7407.102, 22171.94 > , < 0, 90.0005, 89.9998 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < -21185.5, 7407.102, 22171.94 > , < 0, 90.0005, 89.9998 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < -21478.9, 7269.5, 22171.94 > , < 0, 0.0007, 89.9998 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_bracket_corner_01.rmdl", < -21478.9, 7032.508, 22171.94 > , < 0, 0.0007, 89.9998 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/levels_terrain/mp_rr_canyonlands/clands_roof_bars_01_fglass_blue.rmdl", < -21416.35, 7008, 22169.69 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -21642, 7766, 21940 > , < 90, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -21877.98, 7896, 21940 > , < 90, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -21877.99, 7764, 21940 > , < 90, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -21876, 7508.016, 21940 > , < 90, 89.9998, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -21876, 7874.016, 21940 > , < 90, 89.9998, 0 > , true, 5000, -1, 1)
  NoClimbArray.append(MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -21639.99, 7508, 22172 > , < 0.0002, 89.9998, 90 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -21877.99, 7508, 22172 > , < 0.0002, 89.9998, 90 > , true, 5000, -1, 1))
  MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -21865, 7243.016, 21940 > , < 90, 89.9998, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -21735, 7243.008, 21940 > , < 90, 89.9998, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -21733, 7007.008, 21940 > , < 90, 89.9998, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -21865, 7007.023, 21940 > , < 90, 89.9998, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -21477.01, 7009, 21940 > , < 90, 179.9996, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -21843.01, 7009.008, 21940 > , < 90, 179.9996, 0 > , true, 5000, -1, 1)
  NoClimbArray.append(MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -21477, 7245.016, 22172 > , < 0.0002, 179.9996, 90 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -21477, 7007.016, 22172 > , < 0.0002, 179.9996, 90 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -20923.02, 7411, 22172 > , < 0.0002, -90.0005, 90 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -21161.01, 7411, 22172 > , < 0.0002, -90.0005, 90 > , true, 5000, -1, 1))
  MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -20925.01, 7044.984, 21940 > , < 90, -90.0005, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -20925, 7410.984, 21940 > , < 90, -90.0005, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -20923.02, 7023, 21940 > , < 90, 179.9996, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -20923.01, 7155, 21940 > , < 90, 179.9996, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -21159, 7153, 21940 > , < 90, 179.9996, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -21159.02, 7023, 21940 > , < 90, 179.9996, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -20927, 7662.984, 21940 > , < 90, -90.0005, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -21057, 7662.992, 21940 > , < 90, -90.0005, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -21059, 7898.992, 21940 > , < 90, -90.0005, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -20927, 7898.977, 21940 > , < 90, -90.0005, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -21314.99, 7897, 21940 > , < 90, -0.0007, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -20948.99, 7896.992, 21940 > , < 90, -0.0007, 0 > , true, 5000, -1, 1)
  NoClimbArray.append(MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -21315, 7660.984, 22172 > , < 0.0002, -0.0007, 90 > , true, 5000, -1, 1))
  NoClimbArray.append(MapEditor_CreateProp($"mdl/industrial/underbelly_support_beam_256_01.rmdl", < -21315, 7898.984, 22172 > , < 0.0002, -0.0007, 90 > , true, 5000, -1, 1))
  MapEditor_CreateProp($"mdl/signs/street_sign_arrow.rmdl", < -20942, 7702, 22026 > , < -0.0003, -90.0002, 180 > , true, 5000, -1, 3.150001)
  MapEditor_CreateProp($"mdl/signs/street_sign_arrow.rmdl", < -21120, 7038, 22026 > , < -0.0003, -180, 180 > , true, 5000, -1, 3.15)
  MapEditor_CreateProp($"mdl/signs/street_sign_arrow.rmdl", < -21848, 7202, 22026 > , < -0.0003, 90.0002, 180 > , true, 5000, -1, 3.15)
  MapEditor_CreateProp($"mdl/signs/street_sign_arrow.rmdl", < -23632, 7352, 21962 > , < -4.558, 120.1054, 142.0979 > , true, 5000, -1, 2.460001)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/domestic/floor_rug_red.rmdl", < -17273.89, 9138.602, 21939.3 > , < 0, 89.9998, 0 > , true, 5000, -1, 2.11))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/desertlands_apartments_rug_01.rmdl", < -17274.7, 7743.398, 21939.9 > , < 0, 89.9998, 0 > , true, 5000, -1, 1.81))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/desertlands_apartments_rug_01.rmdl", < -17274.7, 8405.102, 21939.9 > , < 0, 89.9998, 0 > , true, 5000, -1, 1.81))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/domestic/floor_rug_red.rmdl", < -17273.89, 9801, 21939.3 > , < 0, 89.9998, 0 > , true, 5000, -1, 2.11))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/domestic/floor_rug_red.rmdl", < -17273.89, 10411.25, 21939.3 > , < 0, 89.9998, 0 > , true, 5000, -1, 2.11))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/domestic/floor_rug_red.rmdl", < -17273.89, 11068.13, 21939.3 > , < 0, 89.9998, 0 > , true, 5000, -1, 2.11))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/domestic/floor_rug_red.rmdl", < -17273.89, 11752, 21939.3 > , < 0, 89.9998, 0 > , true, 5000, -1, 2.11))
  MapEditor_CreateProp($"mdl/ola/sewer_railing_01_128.rmdl", < -17279.9, 9280.898, 21932 > , < 0, 89.9999, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/ola/sewer_railing_01_128.rmdl", < -17280, 9930.898, 21932 > , < 0, 89.9999, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/ola/sewer_railing_01_128.rmdl", < -17280, 10554.5, 21932 > , < 0, 89.9999, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/ola/sewer_railing_01_128.rmdl", < -17280, 11217, 21932 > , < 0, 89.9999, 0 > , true, 5000, -1, 1)

  foreach(entity ent in NoClimbArray) ent.kv.solid = 3
  foreach(entity ent in NoCollisionArray) ent.kv.solid = 0

  // Buttons
  AddCallback_OnUseEntity(CreateFRButton( < -17279.39, 7651.008, 21938.35 > , < 0, 180, 0 > , "%use% Back to Hub"), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < 10726.9000, 10287, -4283 > , < 0, 89.9998, 0 > )
      Message(user, "Hub")
    })

  AddCallback_OnUseEntity(CreateFRButton( < -17280.61, 8503.492, 21938.35 > , < 0, -0.0004, 0 > , "%use% Next Exercise "), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < -17280, 9112, 41940 > +tpoffset, < 0, 89.9998, 0 > )
    })

  AddCallback_OnUseEntity(CreateFRButton( < -17279.39, 9035.758, 21938.35 > , < 0, 180, 0 > , "%use% Back to Hub"), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < 10726.9000, 10287, -4283 > , < 0, 89.9998, 0 > )
      Message(user, "Hub")
    })

  AddCallback_OnUseEntity(CreateFRButton( < -17318.61, 11875.49, 21938.35 > , < 0, -0.0004, 0 > , "%use% Next Exercise "), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < -21670, 7550, 41938.3500 > +tpoffset, < 0, 89.9998, 0 > )
    })

  AddCallback_OnUseEntity(CreateFRButton( < -17242.61, 11875.49, 21938.35 > , < 0, -0.0004, 0 > , "%use% Repeat Exercise "), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < -17280, 9104, 41940 > +tpoffset, < 0, 89.9998, 0 > )
    })

  AddCallback_OnUseEntity(CreateFRButton( < -21642.51, 7640.609, 21938.35 > , < 0, -90.0002, 0 > , "%use% Back to Hub"), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < 10726.9000, 10287, -4283 > , < 0, -89.9998, 0 > )
      Message(user, "Hub")
    })

  AddCallback_OnUseEntity(CreateFRButton( < -23586.51, 7616.297, 21938.35 > , < 0, -90.0002, 0 > , "%use% Back to Hub"), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < 10726.9000, 10287, -4283 > , < 0, 89.9998, 0 > )
      Message(user, "Hub")
    })

  AddCallback_OnUseEntity(CreateFRButton( < -21614.61, 7241.492, 21938.35 > , < 0, -0.0004, 0 > , "%use% Next Exercise "), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < -23694, 7550, 41938.3500 > +tpoffset, < 0, 89.9998, 0 > )
    })

  // Triggers
  entity trigger_0 = MapEditor_CreateTrigger( < -17274, 8028, 21740 > , < 0, 0, 0 > , 683.786, 136.7572, false)
  trigger_0.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          ent.SetOrigin( < -17280, 7716, 41940 > +tpoffset) // change tp location
        }
      }
    })
  DispatchSpawn(trigger_0)
  entity trigger_1 = MapEditor_CreateTrigger( < -17274, 9410, 21740 > , < 0, 0, 0 > , 683.786, 136.7572, false)
  trigger_1.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          ent.SetOrigin( < -17280, 9104, 41940 > +tpoffset) // change tp location
        }
      }
    })
  DispatchSpawn(trigger_1)
  entity trigger_2 = MapEditor_CreateTrigger( < -17274, 10230, 21740 > , < 0, 0, 0 > , 683.786, 136.7572, false)
  trigger_2.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          ent.SetOrigin( < -17280, 9104, 41940 > +tpoffset) // change tp location
        }
      }
    })
  DispatchSpawn(trigger_2)
  entity trigger_3 = MapEditor_CreateTrigger( < -17274, 10820, 21740 > , < 0, 0, 0 > , 683.786, 136.7572, false)
  trigger_3.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          ent.SetOrigin( < -17280, 9104, 41940 > +tpoffset) // change tp location
        }
      }
    })
  DispatchSpawn(trigger_3)
  entity trigger_4 = MapEditor_CreateTrigger( < -17274, 11556, 21740 > , < 0, 0, 0 > , 683.786, 136.7572, false)
  trigger_4.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          ent.SetOrigin( < -17280, 9104, 41940 > +tpoffset) // change tp location
        }
      }
    })
  DispatchSpawn(trigger_4)
  entity trigger_5 = MapEditor_CreateTrigger( < -21835, 7080.203, 21740 > , < 0, 0, 0 > , 683.786, 136.7572, false)
  trigger_5.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          ent.SetOrigin( < -21670, 7550, 41938.3500 > +tpoffset) // change tp location
        }
      }
    })
  DispatchSpawn(trigger_5)
  entity trigger_6 = MapEditor_CreateTrigger( < -21835, 7838.203, 21740 > , < 0, 0, 0 > , 683.786, 136.7572, false)
  trigger_6.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          ent.SetOrigin( < -21670, 7550, 41938.3500 > +tpoffset) // change tp location
        }
      }
    })
  DispatchSpawn(trigger_6)
  entity trigger_7 = MapEditor_CreateTrigger( < -21133, 7080.203, 21740 > , < 0, 0, 0 > , 683.786, 136.7572, false)
  trigger_7.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          ent.SetOrigin( < -21670, 7550, 41938.3500 > +tpoffset) // change tp location
        }
      }
    })
  DispatchSpawn(trigger_7)
  entity trigger_8 = MapEditor_CreateTrigger( < -21133, 7838.203, 21740 > , < 0, 0, 0 > , 683.786, 136.7572, false)
  trigger_8.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          ent.SetOrigin( < -21670, 7550, 41938.3500 > +tpoffset) // change tp location
        }
      }
    })
  DispatchSpawn(trigger_8)
  entity trigger_9 = MapEditor_CreateTrigger( < -23634, 7660, 21740 > , < 0, 0, 0 > , 779.9, 155.98, false)
  trigger_9.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          ent.SetOrigin( < -23694, 7550, 41938.3500 > +tpoffset) // change tp location
        }
      }
    })
  DispatchSpawn(trigger_9)

}

//Init Mantlejump Segments
void
function MovementGym_MantleJumps() {
  // Props Array
  array < entity > ClipArray;

  // Props
  MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -2796.7, 2359.398, 22338 > , < 0, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_elevator_01_bott.rmdl", < -2792.025, 3047, 21924 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < -2792.025, 3047, 22137.7 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_elevator_01_top.rmdl", < -2792.025, 3047, 22353.5 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2640.2, 2230.797, 22203.7 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2584.2, 2230.797, 22203.7 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2640.2, 2230.797, 22054.2 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2584.2, 2230.797, 22054.2 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2584.2, 2230.797, 21904.9 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2640.2, 2230.797, 21904.9 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2943.9, 2230.797, 22203.7 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2887.9, 2230.797, 22203.7 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2887.9, 2230.797, 22054.2 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2943.9, 2230.797, 22054.2 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2943.9, 2230.797, 21904.9 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2887.9, 2230.797, 21904.9 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_elevator_01_bott.rmdl", < -2791.875, 2161.797, 21924 > , < 0, 90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < -2791.875, 2161.797, 22137.7 > , < 0, 90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < -2791.875, 2161.797, 22344.7 > , < 0, 90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_elevator_01_top.rmdl", < -2792.025, 2161.797, 22560.5 > , < 0, 90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2640.2, 2922, 22411.1 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2584.2, 2922, 22411.1 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2584.2, 2922, 22261.6 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2640.2, 2922, 22261.6 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2640.2, 2922, 22112.3 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2584.2, 2922, 22112.3 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2887.9, 2922, 22112.3 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2943.9, 2922, 22112.3 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2943.9, 2922, 22261.6 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2887.9, 2922, 22261.6 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2887.9, 2922, 22411.1 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2943.9, 2922, 22411.1 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2943.9, 2922, 21963.4 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2887.9, 2922, 21963.4 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2584.2, 2922, 21963.4 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2640.2, 2922, 21963.4 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2640.2, 2922, 21815.3 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2584.2, 2922, 21815.3 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2887.9, 2922, 21815.3 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2943.9, 2922, 21815.3 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -2796.7, 2359.398, 22130.2 > , < 0, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -2796.7, 2849, 22545.4 > , < 0, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -2796.7, 2849, 22337.6 > , < 0, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -2796.7, 2849.797, 22128.7 > , < 0, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -3125, 2887, 21923 > , < 0, 0, -179.9999 > , true, 5000, -1, 3.451169)
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -2516, 3136, 21923.5 > , < 0, 0, -179.9999 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -2516, 2524, 21923.5 > , < 0, 0, -179.9999 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -2516, 1909, 21923.5 > , < 0, 0, -179.9999 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -2516, 3740, 21923.5 > , < 0, 0, -179.9999 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -3118, 3136, 21923.5 > , < 0, 0, -179.9999 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -3118, 2524, 21923.5 > , < 0, 0, -179.9999 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -3118, 1909, 21923.5 > , < 0, 0, -179.9999 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -3118, 3740, 21923.5 > , < 0, 0, -179.9999 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -3738, 3740, 21923.5 > , < 0, 0, -179.9999 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -3738, 1909, 21923.5 > , < 0, 0, -179.9999 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -3738, 2524, 21923.5 > , < 0, 0, -179.9999 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -3738, 3136, 21923.5 > , < 0, 0, -179.9999 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -4041, 1897, 22228 > , < 90, 179.9999, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -4041, 2510, 22228 > , < 90, 179.9999, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -4041, 3125.102, 22228 > , < 90, 179.9999, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -4041, 3741, 22228 > , < 90, 179.9999, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -3735, 4043, 22228 > , < 90, 90.0001, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -3123, 4043, 22228 > , < 90, 90.0001, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -2517, 4043, 22228 > , < 90, 90.0001, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -2220, 3740, 22228 > , < 90, 0.0001, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -2220, 3128, 22228 > , < 90, 0.0001, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -2220, 2518, 22228 > , < 90, 0.0001, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -2220, 1904, 22228 > , < 90, 0.0001, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -2517, 1598, 22228 > , < 90, -89.9999, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -3129, 1598, 22228 > , < 90, -89.9999, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -3735, 1598, 22228 > , < 90, -89.9999, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -4041, 1897, 22985 > , < 90, 179.9999, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -4041, 2510, 22985 > , < 90, 179.9999, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -4041, 3125.102, 22985 > , < 90, 179.9999, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -4041, 3741, 22985 > , < 90, 179.9999, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -3735, 4043, 22985 > , < 90, 90.0001, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -3123, 4043, 22985 > , < 90, 90.0001, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -2517, 4043, 22985 > , < 90, 90.0001, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -2220, 3740, 22985 > , < 90, 0.0001, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -2220, 3128, 22985 > , < 90, 0.0001, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -2220, 2518, 22985 > , < 90, 0.0001, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -2220, 1904, 22985 > , < 90, 0.0001, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -3735, 1598, 22985 > , < 90, -89.9999, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -3129, 1598, 22985 > , < 90, -89.9999, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -2517, 1598, 22985 > , < 90, -89.9999, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -2517, 1598, 23758 > , < 90, -89.9999, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -3129, 1598, 23758 > , < 90, -89.9999, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -3735, 1598, 23758 > , < 90, -89.9999, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -2220, 1904, 23758 > , < 90, 0.0001, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -2220, 2518, 23758 > , < 90, 0.0001, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -2220, 3128, 23758 > , < 90, 0.0001, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -2220, 3740, 23758 > , < 90, 0.0001, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -2517, 4043, 23758 > , < 90, 90.0001, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -3123, 4043, 23758 > , < 90, 90.0001, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -3735, 4043, 23758 > , < 90, 90.0001, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -4041, 3741, 23758 > , < 90, 179.9999, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -4041, 3125.102, 23758 > , < 90, 179.9999, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -4041, 2510, 23758 > , < 90, 179.9999, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -4041, 1897, 23758 > , < 90, 179.9999, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -4041, 1897, 24519 > , < 90, 179.9999, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -4041, 2510, 24519 > , < 90, 179.9999, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -4041, 3125.102, 24519 > , < 90, 179.9999, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -4041, 3741, 24519 > , < 90, 179.9999, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -3735, 4043, 24519 > , < 90, 90.0001, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -3123, 4043, 24519 > , < 90, 90.0001, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -2517, 4043, 24519 > , < 90, 90.0001, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -2220, 3740, 24519 > , < 90, 0.0001, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -2220, 3128, 24519 > , < 90, 0.0001, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -2220, 2518, 24519 > , < 90, 0.0001, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -2220, 1904, 24519 > , < 90, 0.0001, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -3735, 1598, 24519 > , < 90, -89.9999, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -3129, 1598, 24519 > , < 90, -89.9999, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -2517, 1598, 24519 > , < 90, -89.9999, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -2517, 1598, 25280 > , < 90, -89.9999, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -3129, 1598, 25280 > , < 90, -89.9999, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -3735, 1598, 25280 > , < 90, -89.9999, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -2220, 1904, 25280 > , < 90, 0.0001, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -2220, 2518, 25280 > , < 90, 0.0001, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -2220, 3128, 25280 > , < 90, 0.0001, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -2220, 3740, 25280 > , < 90, 0.0001, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -2517, 4043, 25280 > , < 90, 90.0001, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -3123, 4043, 25280 > , < 90, 90.0001, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -3735, 4043, 25280 > , < 90, 90.0001, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -4041, 3741, 25280 > , < 90, 179.9999, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -4041, 3125.102, 25280 > , < 90, 179.9999, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -4041, 2510, 25280 > , < 90, 179.9999, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -4041, 1897, 25280 > , < 90, 179.9999, 0 > , true, 5000, -1, 1))
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2887.9, 2922, 21963.4 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2887.9, 2230.797, 22203.7 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2887.9, 2230.797, 22054.2 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < -2791.875, 2161.797, 22344.7 > , < 0, 90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_elevator_01_top.rmdl", < -2792.025, 2161.797, 22560.5 > , < 0, 90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2640.2, 2922, 22261.6 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2887.9, 2922, 22411.1 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2943.9, 2922, 22261.6 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_elevator_01_top.rmdl", < -2792.025, 3047, 22353.5 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2943.9, 2922, 22112.3 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2943.9, 2922, 21963.4 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2640.2, 2230.797, 22054.2 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2640.2, 2230.797, 21904.9 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2943.9, 2230.797, 22203.7 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2640.2, 2922, 22411.1 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2584.2, 2230.797, 22203.7 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < -2792.025, 3047, 22137.7 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2943.9, 2230.797, 22054.2 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2887.9, 2230.797, 21904.9 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_elevator_01_bott.rmdl", < -2791.875, 2161.797, 21924 > , < 0, 90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < -2791.875, 2161.797, 22137.7 > , < 0, 90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2584.2, 2922, 22112.3 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2887.9, 2922, 22112.3 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2887.9, 2922, 22261.6 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2584.2, 2230.797, 21904.9 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2640.2, 2922, 21815.3 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_elevator_01_bott.rmdl", < -2792.025, 3047, 21924 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2584.2, 2230.797, 22054.2 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2943.9, 2922, 22411.1 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2584.2, 2922, 22411.1 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2943.9, 2230.797, 21904.9 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2640.2, 2922, 21963.4 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2584.2, 2922, 21815.3 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2887.9, 2922, 21815.3 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2640.2, 2922, 22112.3 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2584.2, 2922, 21963.4 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -2796.7, 2849, 22545.4 > , < 0, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2943.9, 2922, 21815.3 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -2796.7, 2849, 22337.6 > , < 0, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -2796.7, 2849.797, 22128.7 > , < 0, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -2796.7, 2359.398, 22338 > , < 0, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2640.2, 2230.797, 22203.7 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -2584.2, 2922, 22261.6 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -2796.7, 2359.398, 22130.2 > , < 0, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -3377.042, 2286.798, 21963.4 > , < 0, 90.0001, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -3377.042, 2978, 22203.7 > , < 0, 90.0001, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_elevator_01_top.rmdl", < -3472.917, 3047.001, 22560.5 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -3321.042, 2286.798, 22261.6 > , < 0, 90.0001, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -3321.042, 2978.001, 22054.2 > , < 0, 90.0001, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -3377.042, 2978, 21904.9 > , < 0, 90.0001, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_elevator_01_bott.rmdl", < -3473.067, 3047, 21924 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < -3473.067, 3047, 22137.7 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -3680.743, 2286.798, 22112.3 > , < 0, 90.0001, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -3377.042, 2286.798, 22112.3 > , < 0, 90.0001, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -3377.042, 2286.798, 22261.6 > , < 0, 90.0001, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_elevator_01_bott.rmdl", < -3472.918, 2161.798, 21924 > , < 0, 90.0001, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -3468.242, 2359.001, 22128.7 > , < 0, -180, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_elevator_01_top.rmdl", < -3472.918, 2161.798, 22353.5 > , < 0, 90.0001, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -3321.042, 2286.798, 22112.3 > , < 0, 90.0001, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -3321.042, 2286.798, 21963.4 > , < 0, 90.0001, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -3377.042, 2286.798, 21815.3 > , < 0, 90.0001, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -3680.743, 2286.798, 21963.4 > , < 0, 90.0001, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -3468.243, 2359.798, 22545.4 > , < 0, -180, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -3321.042, 2286.798, 21815.3 > , < 0, 90.0001, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -3680.743, 2286.798, 22411.1 > , < 0, 90.0001, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -3321.042, 2978.001, 21904.9 > , < 0, 90.0001, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -3624.742, 2286.798, 21963.4 > , < 0, 90.0001, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -3680.743, 2286.798, 21815.3 > , < 0, 90.0001, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -3680.742, 2978.001, 22054.2 > , < 0, 90.0001, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -3321.042, 2286.798, 22411.1 > , < 0, 90.0001, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -3377.042, 2978, 22054.2 > , < 0, 90.0001, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < -3473.067, 3047, 22344.7 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -3624.742, 2286.798, 22261.6 > , < 0, 90.0001, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -3377.042, 2286.798, 22411.1 > , < 0, 90.0001, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -3624.743, 2978.001, 22054.2 > , < 0, 90.0001, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -3624.743, 2978.001, 21904.9 > , < 0, 90.0001, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -3321.042, 2978.001, 22203.7 > , < 0, 90.0001, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -3624.742, 2286.798, 22411.1 > , < 0, 90.0001, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -3680.742, 2978.001, 22203.7 > , < 0, 90.0001, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_elevator_01_mid.rmdl", < -3472.918, 2161.798, 22137.7 > , < 0, 90.0001, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -3680.742, 2978.001, 21904.9 > , < 0, 90.0001, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -3624.742, 2286.798, 21815.3 > , < 0, 90.0001, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -3624.742, 2286.798, 22112.3 > , < 0, 90.0001, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -3468.242, 2849.399, 22338 > , < 0, -180, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -3624.743, 2978.001, 22203.7 > , < 0, 90.0001, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/desertlands/construction_bldg_column_01.rmdl", < -3680.743, 2286.798, 22261.6 > , < 0, 90.0001, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -3468.242, 2849.399, 22130.2 > , < 0, -180, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -3468.243, 2359.798, 22337.6 > , < 0, -180, 0 > , true, 5000, -1, 1)

  foreach(entity ent in ClipArray) {
    ent.MakeInvisible()
    ent.kv.solid = 6
    ent.kv.CollisionGroup = TRACE_COLLISION_GROUP_PLAYER
    ent.kv.contents = CONTENTS_PLAYERCLIP
  }

  // VerticalZipLines
  MapEditor_CreateZiplineFromUnity( < -2790.5, 2171.602, 22557.7 > , < 0, 0, 0 > , < -2790.5, 2171.602, 22015.5 > , < 0, 0, 0 > , true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [], [], [], 32, 60, 0)
  MapEditor_CreateZiplineFromUnity( < -2790.5, 3040.898, 22745.8 > , < 0, 0, 0 > , < -2790.5, 3040.898, 22019 > , < 0, 0, 0 > , true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [], [], [], 32, 60, 0)
  MapEditor_CreateZiplineFromUnity( < -3475.742, 3040.919, 22557.7 > , < 0, -180, 0 > , < -3475.742, 3040.919, 22015.5 > , < 0, -180, 0 > , true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [], [], [], 32, 60, 0)
  MapEditor_CreateZiplineFromUnity( < -3475.743, 2171.622, 22745.8 > , < 0, -180, 0 > , < -3475.743, 2171.622, 22019 > , < 0, -180, 0 > , true, -1, 1, 2, 1, 1, 0, 1, 50, 25, false, 1, false, 0, 0, [], [], [], 32, 60, 0)

  // Buttons
  AddCallback_OnUseEntity(CreateFRButton( < -2621.507, 2607.609, 21922.35 > , < 0, -90.0002, 0 > , "%use% Back to Hub"), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < 10726.9000, 10287, -4283 > , < 0, -89.9998, 0 > )
      Message(user, "Hub")
    })

}

//Init Grapple Legacy Segments
void
function MovementGym_Grapple1() {
  //Buttons 
  AddCallback_OnUseEntity(CreateFRButton( < -11183.8700, 26531.6000, 37.7500 > , < 0, -89.9999, 0 > , "%use% Repeat"), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < -13561.7000, 26485.9000, -83.2000 > , < 0, 0, 0 > )
      Message(user, "Easy Grapple")
    })
  AddCallback_OnUseEntity(CreateFRButton( < -11183.8700, 26450.8000, 37.7500 > , < 0, -89.9999, 0 > , "%use% Next"), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < -13540.7000, 27525.8000, -335.8000 > , < 0, 0, 0 > )
      Message(user, "Medium Grapple")
    })
  AddCallback_OnUseEntity(CreateFRButton( < -10684.1700, 27534.7000, 33.8496 > , < 0, -89.9999, 0 > , "%use% Hub"), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < 10726.9000, 10287, -4283 > , < 0, -89.9998, 0 > )
      Message(user, "HUB", "\n  You now recieved Phase Walk Tactical")
    })
  AddCallback_OnUseEntity(CreateFRButton( < -10684.1700, 27615.5100, 33.8496 > , < 0, -89.9999, 0 > , "%use% Next"), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < 10446.3000, -26287.1000, 22469.8000 > , < 0, 0, 0 > )
      Message(user, "Hard Grapple")
    })
  AddCallback_OnUseEntity(CreateFRButton( < -13618.5700, 26486.5000, -92.9492 > , < 0, 90.0005, 0 > , "%use% Hub"), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < 10726.9000, 10287, -4283 > , < 0, -89.9998, 0 > )
      Message(user, "HUB", "\n  You now recieved Phase Walk Tactical")
    })
  AddCallback_OnUseEntity(CreateFRButton( < -13589.6700, 27521, -337.3496 > , < 0, 90.0005, 0 > , "%use% Hub"), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < 10726.9000, 10287, -4283 > , < 0, -89.9998, 0 > )
      Message(user, "HUB", "\n  You now recieved Phase Walk Tactical")
    })

  //Props 
  MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -11330.8300, 26422.9700, 37.1504 > , < 0, -89.9992, 0 > , true, 5000, -1, 1.3183)
  MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -11279.6800, 26461, 40.1504 > , < 0, -89.9992, 0 > , true, 5000, -1, 1.3183)
  MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -11383.0700, 26436.8900, 35.1504 > , < 0, -179.9991, 0 > , true, 5000, -1, 1.3183)
  MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -11302.1200, 26522.6800, 40.1504 > , < 0, 90.0010, 0 > , true, 5000, -1, 1.3183)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < -11345.8800, 26496.8800, -86.8496 > , < 0, 90.0008, 0 > , true, 5000, -1, 0.7657141)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < -11290.9100, 26529.4900, -86.8496 > , < 0, 0.0008, 0 > , true, 5000, -1, 0.7657141)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < -11248.1700, 26496.8800, -86.8496 > , < 0, -89.9992, 0 > , true, 5000, -1, 0.7657141)
  MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -11350.8900, 26566.6900, 35.1504 > , < 0, 90.0010, 0 > , true, 5000, -1, 1.3183)
  MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -11250.9900, 26560.6700, 37.1504 > , < 0, 90.0010, 0 > , true, 5000, -1, 1.3183)
  MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -11230.8800, 26417, 35.1504 > , < 0, -89.9992, 0 > , true, 5000, -1, 1.3183)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < -11290.8800, 26454.2000, -86.8496 > , < 0, -179.9992, 0 > , true, 5000, -1, 0.7657142)
  MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -11377.0800, 26536.8000, 37.1504 > , < 0, -179.9991, 0 > , true, 5000, -1, 1.3183)
  MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -13475.7300, 26560.7100, -92.8496 > , < 0, 90.0005, 0 > , true, 5000, -1, 1.3183)
  MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -13526.8900, 26522.7000, -89.8496 > , < 0, 90.0005, 0 > , true, 5000, -1, 1.3183)
  MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -13504.4400, 26461, -89.8496 > , < 0, -89.9994, 0 > , true, 5000, -1, 1.3183)
  MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -13423.4800, 26546.8000, -94.8496 > , < 0, 0.0006, 0 > , true, 5000, -1, 1.3183)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < -13460.6900, 26486.8200, -216.8496 > , < 0, -89.9995, 0 > , true, 5000, -1, 0.7657141)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < -13515.6400, 26454.2000, -216.8496 > , < 0, -179.9995, 0 > , true, 5000, -1, 0.7657141)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < -13558.3900, 26486.8200, -216.8496 > , < 0, 90.0005, 0 > , true, 5000, -1, 0.7657141)
  MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -13455.6700, 26417, -94.8496 > , < 0, -89.9994, 0 > , true, 5000, -1, 1.3183)
  MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -13555.5800, 26423.0100, -92.8496 > , < 0, -89.9994, 0 > , true, 5000, -1, 1.3183)
  MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -13575.6700, 26566.7000, -94.8496 > , < 0, 90.0005, 0 > , true, 5000, -1, 1.3183)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < -13515.6900, 26529.4900, -216.8496 > , < 0, 0.0005, 0 > , true, 5000, -1, 0.7657142)
  MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -13429.4800, 26446.8900, -92.8496 > , < 0, 0.0006, 0 > , true, 5000, -1, 1.3183)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < -13445.2700, 27517.8000, -465.3496 > , < 0, -89.9995, 0 > , true, 5000, -1, 0.7657141)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < -13500.2200, 27485.1800, -465.3496 > , < 0, -179.9995, 0 > , true, 5000, -1, 0.7657141)
  MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -13460.3100, 27591.7000, -341.3496 > , < 0, 90.0005, 0 > , true, 5000, -1, 1.3183)
  MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -13511.4700, 27553.6800, -338.3496 > , < 0, 90.0005, 0 > , true, 5000, -1, 1.3183)
  MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -13489.0200, 27491.9800, -338.3496 > , < 0, -89.9994, 0 > , true, 5000, -1, 1.3183)
  MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -13408.0600, 27577.7900, -343.3496 > , < 0, 0.0006, 0 > , true, 5000, -1, 1.3183)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < -13542.9700, 27517.8000, -465.3496 > , < 0, 90.0005, 0 > , true, 5000, -1, 0.7657141)
  MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -13440.2500, 27447.9800, -343.3496 > , < 0, -89.9994, 0 > , true, 5000, -1, 1.3183)
  MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -13540.1600, 27453.9900, -341.3496 > , < 0, -89.9994, 0 > , true, 5000, -1, 1.3183)
  MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -13560.2500, 27597.6800, -343.3496 > , < 0, 90.0005, 0 > , true, 5000, -1, 1.3183)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < -13500.2700, 27560.4800, -465.3496 > , < 0, 0.0005, 0 > , true, 5000, -1, 0.7657142)
  MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -13414.0600, 27477.8800, -341.3496 > , < 0, 0.0006, 0 > , true, 5000, -1, 1.3183)
  MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -10726.6900, 27495.7000, 29.7500 > , < 0, -89.9998, 0 > , true, 5000, -1, 1.3183)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < -10786.6600, 27532.9100, -92.2500 > , < 0, -179.9998, 0 > , true, 5000, -1, 0.7657142)
  MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -10826.6200, 27501.7000, 31.7500 > , < 0, -89.9998, 0 > , true, 5000, -1, 1.3183)
  MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -10775.4600, 27539.7000, 34.7500 > , < 0, -89.9998, 0 > , true, 5000, -1, 1.3183)
  MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -10797.9200, 27601.4100, 34.7500 > , < 0, 90.0003, 0 > , true, 5000, -1, 1.3183)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < -10841.6600, 27575.5900, -92.2500 > , < 0, 90.0002, 0 > , true, 5000, -1, 0.7657141)
  MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -10846.6900, 27645.4100, 29.7500 > , < 0, 90.0003, 0 > , true, 5000, -1, 1.3183)
  MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -10878.8700, 27515.6100, 29.7500 > , < 0, -179.9997, 0 > , true, 5000, -1, 1.3183)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < -10743.9700, 27575.5900, -92.2500 > , < 0, -89.9998, 0 > , true, 5000, -1, 0.7657141)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < -10786.7100, 27608.2100, -92.2500 > , < 0, 0.0002, 0 > , true, 5000, -1, 0.7657141)
  MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -10746.7700, 27639.4100, 31.7500 > , < 0, 90.0003, 0 > , true, 5000, -1, 1.3183)
  MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < -10872.8700, 27615.5200, 31.7500 > , < 0, -179.9997, 0 > , true, 5000, -1, 1.3183)
  MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -12686, 23929, -106 > , < 0, -90, 0 > , true, 5000, -1, 1)

  //PlayerClips 
  array < entity > grappleplayerClips
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -10274, 23398.0200, 1616.0120 > , < -0.0003, 0.0003, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11033.9900, 23398.0200, 1616.0060 > , < -0.0003, 0.0003, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11802.9900, 23398.0200, 1616.0040 > , < -0.0003, 0.0003, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -12573, 23398.0100, 1615.9980 > , < -0.0003, 0.0003, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13345, 24064.0100, 1615.9940 > , < -0.0003, 0.0003, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -12573, 24064.0100, 1615.9980 > , < -0.0003, 0.0003, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11803, 24064.0200, 1616.0040 > , < -0.0003, 0.0003, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11034, 24064.0200, 1616.0060 > , < -0.0003, 0.0003, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -10274, 24064.0200, 1616.0120 > , < -0.0003, 0.0003, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -10274.0100, 26025.0200, 1616.0160 > , < -0.0003, 0.0003, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -10274.0100, 26618.0200, 1616.0140 > , < -0.0003, 0.0003, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -10274, 25406.0200, 1616.0120 > , < -0.0003, 0.0003, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -10274, 24813.0200, 1616.0120 > , < -0.0003, 0.0003, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11034, 24813.0200, 1616.0060 > , < -0.0003, 0.0003, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11034, 25406.0200, 1616.0100 > , < -0.0003, 0.0003, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11034.0100, 26618.0200, 1616.0120 > , < -0.0003, 0.0003, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11034, 26025.0200, 1616.0120 > , < -0.0003, 0.0003, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11803.0100, 26025.0200, 1616.0100 > , < -0.0003, 0.0003, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11803, 26618.0200, 1616.0100 > , < -0.0003, 0.0003, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11803, 25406.0100, 1616.0080 > , < -0.0003, 0.0003, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11803, 24813.0200, 1616.0040 > , < -0.0003, 0.0003, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -12573, 24813.0100, 1615.9980 > , < -0.0003, 0.0003, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -12573.0100, 25406.0100, 1616 > , < -0.0003, 0.0003, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -12573.0100, 26618.0100, 1616.0020 > , < -0.0003, 0.0003, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -12573.0100, 26025.0100, 1616 > , < -0.0003, 0.0003, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13345, 26025.0100, 1615.9960 > , < -0.0003, 0.0003, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13345.0100, 26618.0100, 1616 > , < -0.0003, 0.0003, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13345, 25406.0100, 1615.9940 > , < -0.0003, 0.0003, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13344.9900, 23333.0200, -550 > , < 0, 0, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13344.9900, 23333.0200, 43 > , < 0, 0, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13344.9900, 23333.0200, 1255 > , < 0, 0, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13344.9900, 23333.0200, 662 > , < 0, 0, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -12573, 23333.0200, 662 > , < 0, 0, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -12573, 23333.0200, 1255 > , < 0, 0, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -12573, 23333.0200, 43 > , < 0, 0, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -12573, 23333.0200, -550 > , < 0, 0, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11802.9900, 23333.0200, -550 > , < 0, 0, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11802.9900, 23333.0200, 43 > , < 0, 0, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11802.9900, 23333.0200, 1255 > , < 0, 0, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11802.9900, 23333.0200, 662 > , < 0, 0, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11033.9900, 23333.0200, 662 > , < 0, 0, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11033.9900, 23333.0200, 1255 > , < 0, 0, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11033.9900, 23333.0200, 43 > , < 0, 0, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11033.9900, 23333.0200, -550 > , < 0, 0, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -10274, 23333.0200, -550 > , < 0, 0, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -10274, 23333.0200, 43 > , < 0, 0, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -10274, 23333.0200, 1255 > , < 0, 0, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13626, 23617, 662 > , < 0, -89.9998, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13626, 23617, 1255 > , < 0, -89.9998, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13626, 23617, 43 > , < 0, -89.9998, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13626, 24377, -550 > , < 0, -89.9998, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13626, 23617, -550 > , < 0, -89.9998, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13626, 24377, 43 > , < 0, -89.9998, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13626, 24377, 1255 > , < 0, -89.9998, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -9996.9990, 23617.0200, -550 > , < 0, 90.0005, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -9996.9990, 23617.0200, 1255 > , < 0, 90.0005, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -9996.9990, 23617.0200, 43 > , < 0, 90.0005, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -9997, 24389.0200, 662 > , < 0, 90.0005, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -9996.9990, 23617.0200, 662 > , < 0, 90.0005, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -9997, 24389.0200, 1255 > , < 0, 90.0005, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -9997, 24389.0200, 43 > , < 0, 90.0005, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -9997.0060, 25159.0200, -550 > , < 0, 90.0005, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -9997, 24389.0200, -550 > , < 0, 90.0005, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -9997.0060, 25159.0200, 43 > , < 0, 90.0005, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -9997.0060, 25159.0200, 1255 > , < 0, 90.0005, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -9997.0120, 25928.0200, 662 > , < 0, 90.0005, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -9997.0060, 25159.0200, 662 > , < 0, 90.0005, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -9997.0180, 26688.0200, -550 > , < 0, 90.0005, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -9997.0120, 25928.0200, 1255 > , < 0, 90.0005, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -9997.0120, 25928.0200, 43 > , < 0, 90.0005, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -9997.0120, 25928.0200, -550 > , < 0, 90.0005, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -9997.0180, 26688.0200, 43 > , < 0, 90.0005, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -9997.0180, 26688.0200, 1255 > , < 0, 90.0005, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13626.0100, 25146, 662 > , < 0, -89.9998, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13626, 24377, 662 > , < 0, -89.9998, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13626.0100, 25146, 1255 > , < 0, -89.9998, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13626.0100, 25146, 43 > , < 0, -89.9998, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13626.0100, 25146, -550 > , < 0, -89.9998, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13626.0100, 25916.0100, -550 > , < 0, -89.9998, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13626.0100, 25916.0100, 43 > , < 0, -89.9998, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13626.0100, 25916.0100, 1255 > , < 0, -89.9998, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13626.0100, 26688, 662 > , < 0, -89.9998, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13626.0100, 25916.0100, 662 > , < 0, -89.9998, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13626.0100, 26688, 43 > , < 0, -89.9998, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13626.0100, 26688, 1255 > , < 0, -89.9998, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13344.9900, 23398, 1615.9940 > , < -0.0003, 0.0003, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13345, 24813, 1615.9940 > , < -0.0003, 0.0003, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -10274, 23333.0200, 662 > , < 0, 0, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13626.0100, 26688, -550 > , < 0, -89.9998, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -9997.0180, 26688.0200, 662 > , < 0, 90.0005, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -10274, 30636, 1615.9940 > , < -0.0003, -180, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11046, 30636, 1615.9980 > , < -0.0003, -180, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11816.0100, 30636, 1616.0040 > , < -0.0003, -180, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -12585, 30636, 1616.0060 > , < -0.0003, -180, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13345, 30636, 1616.0120 > , < -0.0003, -180, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13345, 29970, 1616.0120 > , < -0.0003, -180, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -12585, 29970, 1616.0060 > , < -0.0003, -180, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11816.0100, 29970, 1616.0040 > , < -0.0003, -180, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11046, 29970, 1615.9980 > , < -0.0003, -180, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -10274, 29970, 1615.9940 > , < -0.0003, -180, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -10274, 29221, 1615.9940 > , < -0.0003, -180, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -10274, 28628, 1615.9940 > , < -0.0003, -180, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -10274, 27416, 1616 > , < -0.0003, -180, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -10274, 28009, 1615.9960 > , < -0.0003, -180, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11046, 28009, 1616 > , < -0.0003, -180, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11046, 27416, 1616.0020 > , < -0.0003, -180, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11046, 28628, 1616 > , < -0.0003, -180, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11046, 29221, 1615.9980 > , < -0.0003, -180, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11816.0100, 29221, 1616.0040 > , < -0.0003, -180, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11816.0100, 28628, 1616.0080 > , < -0.0003, -180, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11816.0100, 27416, 1616.0100 > , < -0.0003, -180, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11816.0100, 28009, 1616.0100 > , < -0.0003, -180, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -12585, 28009, 1616.0120 > , < -0.0003, -180, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -12585, 27416, 1616.0120 > , < -0.0003, -180, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -12585, 28628, 1616.0100 > , < -0.0003, -180, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -12585, 29221, 1616.0060 > , < -0.0003, -180, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13345, 29221, 1616.0120 > , < -0.0003, -180, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13345, 28628, 1616.0120 > , < -0.0003, -180, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13345, 27416, 1616.0140 > , < -0.0003, -180, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13345, 28009, 1616.0160 > , < -0.0003, -180, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13345, 30701, 662 > , < 0, 179.9997, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13345, 30701, 1255 > , < 0, 179.9997, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13345, 30701, 43 > , < 0, 179.9997, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13345, 30701, -550 > , < 0, 179.9997, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -12585, 30701, -550 > , < 0, 179.9997, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -12585, 30701, 43 > , < 0, 179.9997, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -12585, 30701, 1255 > , < 0, 179.9997, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11816.0100, 30700.9900, 662 > , < 0, 179.9997, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -12585, 30701, 662 > , < 0, 179.9997, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11816.0100, 30700.9900, 1255 > , < 0, 179.9997, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11816.0100, 30700.9900, 43 > , < 0, 179.9997, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11816.0100, 30700.9900, -550 > , < 0, 179.9997, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11046, 30700.9800, -550 > , < 0, 179.9997, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11046, 30700.9800, 43 > , < 0, 179.9997, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11046, 30700.9800, 1255 > , < 0, 179.9997, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -10274, 30700.9800, 662 > , < 0, 179.9997, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11046, 30700.9800, 662 > , < 0, 179.9997, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -10274, 30700.9800, 43 > , < 0, 179.9997, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -10274, 30700.9800, 1255 > , < 0, 179.9997, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -10274, 30700.9800, -550 > , < 0, 179.9997, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -9993.0030, 27346, -550 > , < 0, 89.9999, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -9993.0030, 27346, 1255 > , < 0, 89.9999, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -9993.0030, 27346, 43 > , < 0, 89.9999, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -9993, 28118, 662 > , < 0, 89.9999, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -9993.0030, 27346, 662 > , < 0, 89.9999, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -9993, 28118, 43 > , < 0, 89.9999, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -9993, 28118, 1255 > , < 0, 89.9999, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -9992.9950, 28888.0100, -550 > , < 0, 89.9999, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -9993, 28118, -550 > , < 0, 89.9999, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -9992.9950, 28888.0100, 43 > , < 0, 89.9999, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -9992.9950, 28888.0100, 1255 > , < 0, 89.9999, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -9992.9950, 29657, 662 > , < 0, 89.9999, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -9992.9950, 28888.0100, 662 > , < 0, 89.9999, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -9992.9950, 29657, 1255 > , < 0, 89.9999, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -9992.9950, 29657, 43 > , < 0, 89.9999, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -9992.9940, 30417, -550 > , < 0, 89.9999, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -9992.9950, 29657, -550 > , < 0, 89.9999, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -9992.9940, 30417, 43 > , < 0, 89.9999, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -9992.9940, 30417, 1255 > , < 0, 89.9999, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -9992.9940, 30417, 662 > , < 0, 89.9999, 89.9999 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13621.9900, 27346, 662 > , < 0, -89.9998, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13621.9900, 27346, 1255 > , < 0, -89.9998, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13621.9900, 27346, 43 > , < 0, -89.9998, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13622, 28106, -550 > , < 0, -89.9998, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13622, 28875, 662 > , < 0, -89.9998, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13622, 29645, -550 > , < 0, -89.9998, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13622, 29645, 1255 > , < 0, -89.9998, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13622, 29645, 43 > , < 0, -89.9998, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13622, 30417, 662 > , < 0, -89.9998, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13622, 30417, 43 > , < 0, -89.9998, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13622, 28106, 43 > , < 0, -89.9998, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13622, 28106, 1255 > , < 0, -89.9998, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13622, 28875, 43 > , < 0, -89.9998, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13622, 28875, 1255 > , < 0, -89.9998, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13621.9900, 27346, -550 > , < 0, -89.9998, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13622, 28106, 662 > , < 0, -89.9998, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13622, 28875, -550 > , < 0, -89.9998, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13622, 29645, 662 > , < 0, -89.9998, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13622, 30417, 1255 > , < 0, -89.9998, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13622, 30417, -550 > , < 0, -89.9998, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13341, 26751.9800, -550 > , < 0, -179.9997, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13341, 26751.9800, 43 > , < 0, -179.9997, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13341, 26751.9800, 1255 > , < 0, -179.9997, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -12581, 26751.9900, 662 > , < 0, -179.9997, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -12581, 26751.9900, 43 > , < 0, -179.9997, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -12581, 26751.9900, 1255 > , < 0, -179.9997, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11812, 26751.9900, -550 > , < 0, -179.9997, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11812, 26751.9900, 1255 > , < 0, -179.9997, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11812, 26751.9900, 43 > , < 0, -179.9997, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11042, 26752, 662 > , < 0, -179.9997, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11042, 26752, 43 > , < 0, -179.9997, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -10270, 26752, 1255 > , < 0, -179.9997, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -10270, 26752, -550 > , < 0, -179.9997, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13341, 26751.9800, 662 > , < 0, -179.9997, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -12581, 26751.9900, -550 > , < 0, -179.9997, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11812, 26751.9900, 662 > , < 0, -179.9997, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11042, 26752, 1255 > , < 0, -179.9997, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11042, 26752, -550 > , < 0, -179.9997, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -10270, 26752, 662 > , < 0, -179.9997, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -10270, 26752, 43 > , < 0, -179.9997, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -10270, 27375, 662 > , < 0, 0, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -10270, 27375, 43 > , < 0, 0, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -10270, 27375, 1255 > , < 0, 0, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -10270, 27375, -550 > , < 0, 0, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11030, 27375, -550 > , < 0, 0, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11030, 27375, 1255 > , < 0, 0, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11030, 27375, 43 > , < 0, 0, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11030, 27375, 662 > , < 0, 0, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11799, 27375, 662 > , < 0, 0, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11799, 27375, 43 > , < 0, 0, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11799, 27375, 1255 > , < 0, 0, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -11799, 27375, -550 > , < 0, 0, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -12569, 27375, 1255 > , < 0, 0, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -12569, 27375, -550 > , < 0, 0, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -12569, 27375, 662 > , < 0, 0, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -12569, 27375, 43 > , < 0, 0, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13341, 27375, 662 > , < 0, 0, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13341, 27375, 1255 > , < 0, 0, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13341, 27375, 43 > , < 0, 0, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -13341, 27375, -550 > , < 0, 0, 89.9998 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -13512, 26490, -106 > , < 0, -90, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -10803.1000, 27572, 21 > , < 0, -90, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -11292.0400, 26489.0900, 21 > , < 0, 90.0003, 0 > , true, 5000, -1, 1))
  grappleplayerClips.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -13490, 27525, -352 > , < 0, -90, 0 > , true, 5000, -1, 1))

  foreach(entity grappleclip in grappleplayerClips) {
    grappleclip.MakeInvisible()
    grappleclip.kv.solid = 1
    grappleclip.kv.CollisionGroup = TRACE_COLLISION_GROUP_PLAYER
    grappleclip.kv.contents = CONTENTS_SOLID | CONTENTS_NOGRAPPLE
  }

  //// No Grapple allowed on these
  //array<entity> noGrapple 
  //noGrapple.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_wall_01.rmdl", < -12612.5000, 26996.4000, 91>,<0, -89.9998, 0>, true, 5000, -1, 1))
  //noGrapple.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_wall_01.rmdl", < -12854.5000, 27360.8000, 91>,<0, 0, 0>, true, 5000, -1, 1))
  //noGrapple.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_wall_01.rmdl", < -13210.4000, 26996.4000, 91>,<0, -89.9998, 0>, true, 5000, -1, 1))
  //noGrapple.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_wall_01.rmdl", < -12854.5000, 26753.3300, 91>,<0, 0, 0>, true, 5000, -1, 1))
  //
  //foreach(entity nograppleallowed in noGrapple) {
  //nograppleallowed.kv.contents = CONTENTS_SOLID | CONTENTS_NOGRAPPLE
  //}

  //Triggers 
  entity trigger9990 = MapEditor_CreateTrigger( < -13490.5700, 26510.2000, -69.5488 > , < 0, 0, 0 > , 234.1279, 46.82558, false)
  trigger9990.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
          ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
          ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
          ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
        }
      }
    })
  DispatchSpawn(trigger9990)
  entity trigger9991 = MapEditor_CreateTrigger( < -10846.8700, 27948.2000, -998.8496 > , < 0, 0, 0 > , 953.5631, 190.7126, false)
  trigger9991.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          TeleportFRPlayer(ent, < -13538.8000, 27513, -332.6000 > , < 0, 0, 0 > )
        }
      }
    })
  DispatchSpawn(trigger9991)
  entity trigger9992 = MapEditor_CreateTrigger( < -11830.8700, 27948.2000, -998.8496 > , < 0, 0, 0 > , 953.5631, 190.7126, false)
  trigger9992.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          TeleportFRPlayer(ent, < -13538.8000, 27513, -332.6000 > , < 0, 0, 0 > )
        }
      }
    })
  DispatchSpawn(trigger9992)
  entity trigger9993 = MapEditor_CreateTrigger( < -13252.8700, 27948.2000, -998.8496 > , < 0, 0, 0 > , 953.5631, 190.7126, false)
  trigger9993.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          TeleportFRPlayer(ent, < -13538.8000, 27513, -332.6000 > , < 0, 0, 0 > )
        }
      }
    })
  DispatchSpawn(trigger9993)
  entity trigger9994 = MapEditor_CreateTrigger( < -12493.8700, 27948.2000, -998.8496 > , < 0, 0, 0 > , 953.5631, 190.7126, false)
  trigger9994.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          TeleportFRPlayer(ent, < -13538.8000, 27513, -332.6000 > , < 0, 0, 0 > )
        }
      }
    })
  DispatchSpawn(trigger9994)
  entity trigger9995 = MapEditor_CreateTrigger( < -11328.8700, 27948.2000, -998.8496 > , < 0, 0, 0 > , 953.5631, 190.7126, false)
  trigger9995.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          TeleportFRPlayer(ent, < -13538.8000, 27513, -332.6000 > , < 0, 0, 0 > )
        }
      }
    })
  DispatchSpawn(trigger9995)
  entity trigger9996 = MapEditor_CreateTrigger( < -10272.8700, 27948.2000, -998.8496 > , < 0, 0, 0 > , 953.5631, 190.7126, false)
  trigger9996.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          TeleportFRPlayer(ent, < -13538.8000, 27513, -332.6000 > , < 0, 0, 0 > )
        }
      }
    })
  DispatchSpawn(trigger9996)
  entity trigger9997 = MapEditor_CreateTrigger( < -13252.8700, 29022.2000, -998.8496 > , < 0, 0, 0 > , 953.5631, 190.7126, false)
  trigger9997.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          TeleportFRPlayer(ent, < -13538.8000, 27513, -332.6000 > , < 0, 0, 0 > )
        }
      }
    })
  DispatchSpawn(trigger9997)
  entity trigger9998 = MapEditor_CreateTrigger( < -12493.8700, 29022.2000, -998.8496 > , < 0, 0, 0 > , 953.5631, 190.7126, false)
  trigger9998.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          TeleportFRPlayer(ent, < -13538.8000, 27513, -332.6000 > , < 0, 0, 0 > )
        }
      }
    })
  DispatchSpawn(trigger9998)
  entity trigger9999 = MapEditor_CreateTrigger( < -11328.8700, 29022.2000, -998.8496 > , < 0, 0, 0 > , 953.5631, 190.7126, false)
  trigger9999.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          TeleportFRPlayer(ent, < -13538.8000, 27513, -332.6000 > , < 0, 0, 0 > )
        }
      }
    })
  DispatchSpawn(trigger9999)
  entity trigger99910 = MapEditor_CreateTrigger( < -10272.8700, 29022.2000, -998.8496 > , < 0, 0, 0 > , 953.5631, 190.7126, false)
  trigger99910.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          TeleportFRPlayer(ent, < -13538.8000, 27513, -332.6000 > , < 0, 0, 0 > )
        }
      }
    })
  DispatchSpawn(trigger99910)
  entity trigger99911 = MapEditor_CreateTrigger( < -13252.8700, 30254.2000, -998.8496 > , < 0, 0, 0 > , 953.5631, 190.7126, false)
  trigger99911.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          TeleportFRPlayer(ent, < -13538.8000, 27513, -332.6000 > , < 0, 0, 0 > )
        }
      }
    })
  DispatchSpawn(trigger99911)
  entity trigger99912 = MapEditor_CreateTrigger( < -12493.8700, 30254.2000, -998.8496 > , < 0, 0, 0 > , 953.5631, 190.7126, false)
  trigger99912.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          TeleportFRPlayer(ent, < -13538.8000, 27513, -332.6000 > , < 0, 0, 0 > )
        }
      }
    })
  DispatchSpawn(trigger99912)
  entity trigger99913 = MapEditor_CreateTrigger( < -11328.8700, 30254.2000, -998.8496 > , < 0, 0, 0 > , 953.5631, 190.7126, false)
  trigger99913.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          TeleportFRPlayer(ent, < -13538.8000, 27513, -332.6000 > , < 0, 0, 0 > )
        }
      }
    })
  DispatchSpawn(trigger99913)
  entity trigger99914 = MapEditor_CreateTrigger( < -12850.8700, 23777.2000, -998.8496 > , < 0, 0, 0 > , 953.5631, 190.7126, false)
  trigger99914.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          TeleportFRPlayer(ent, < -13589.8000, 26485.9000, -83.2000 > , < 0, 0, 0 > )
        }
      }
    })
  DispatchSpawn(trigger99914)
  entity trigger99915 = MapEditor_CreateTrigger( < -12850.8700, 24864.2000, -998.8496 > , < 0, 0, 0 > , 953.5631, 190.7126, false)
  trigger99915.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          TeleportFRPlayer(ent, < -13589.8000, 26485.9000, -83.2000 > , < 0, 0, 0 > )
        }
      }
    })
  DispatchSpawn(trigger99915)
  entity trigger99916 = MapEditor_CreateTrigger( < -11624.8700, 23777.2000, -998.8496 > , < 0, 0, 0 > , 953.5631, 190.7126, false)
  trigger99916.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          TeleportFRPlayer(ent, < -13589.8000, 26485.9000, -83.2000 > , < 0, 0, 0 > )
        }
      }
    })
  DispatchSpawn(trigger99916)
  entity trigger99917 = MapEditor_CreateTrigger( < -11624.8700, 24864.2000, -998.8496 > , < 0, 0, 0 > , 953.5631, 190.7126, false)
  trigger99917.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          TeleportFRPlayer(ent, < -13589.8000, 26485.9000, -83.2000 > , < 0, 0, 0 > )
        }
      }
    })
  DispatchSpawn(trigger99917)
  entity trigger99918 = MapEditor_CreateTrigger( < -10354.8700, 23777.2000, -998.8496 > , < 0, 0, 0 > , 953.5631, 190.7126, false)
  trigger99918.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          TeleportFRPlayer(ent, < -13589.8000, 26485.9000, -83.2000 > , < 0, 0, 0 > )
        }
      }
    })
  DispatchSpawn(trigger99918)
  entity trigger99919 = MapEditor_CreateTrigger( < -10354.8700, 24864.2000, -998.8496 > , < 0, 0, 0 > , 953.5631, 190.7126, false)
  trigger99919.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          TeleportFRPlayer(ent, < -13589.8000, 26485.9000, -83.2000 > , < 0, 0, 0 > )
        }
      }
    })
  DispatchSpawn(trigger99919)
  entity trigger99920 = MapEditor_CreateTrigger( < -10354.8700, 26081.2000, -998.8496 > , < 0, 0, 0 > , 953.5631, 190.7126, false)
  trigger99920.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          TeleportFRPlayer(ent, < -13589.8000, 26485.9000, -83.2000 > , < 0, 0, 0 > )
        }
      }
    })
  DispatchSpawn(trigger99920)
  entity trigger99921 = MapEditor_CreateTrigger( < -10998.8700, 26081.2000, -998.8496 > , < 0, 0, 0 > , 953.5631, 190.7126, false)
  trigger99921.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          TeleportFRPlayer(ent, < -13589.8000, 26485.9000, -83.2000 > , < 0, 0, 0 > )
        }
      }
    })
  DispatchSpawn(trigger99921)
  entity trigger99922 = MapEditor_CreateTrigger( < -11661.8700, 26081.2000, -998.8496 > , < 0, 0, 0 > , 953.5631, 190.7126, false)
  trigger99922.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          TeleportFRPlayer(ent, < -13589.8000, 26485.9000, -83.2000 > , < 0, 0, 0 > )
        }
      }
    })
  DispatchSpawn(trigger99922)
  entity trigger99923 = MapEditor_CreateTrigger( < -12439.8700, 26081.2000, -998.8496 > , < 0, 0, 0 > , 953.5631, 190.7126, false)
  trigger99923.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          TeleportFRPlayer(ent, < -13589.8000, 26485.9000, -83.2000 > , < 0, 0, 0 > )
        }
      }
    })
  DispatchSpawn(trigger99923)
  entity trigger99924 = MapEditor_CreateTrigger( < -13239.8700, 26081.2000, -998.8496 > , < 0, 0, 0 > , 953.5631, 190.7126, false)
  trigger99924.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          TeleportFRPlayer(ent, < -13589.8000, 26485.9000, -83.2000 > , < 0, 0, 0 > )
        }
      }
    })
  DispatchSpawn(trigger99924)
  entity trigger99925 = MapEditor_CreateTrigger( < -10272.8700, 30254.2000, -998.8496 > , < 0, 0, 0 > , 953.5631, 190.7126, false)
  trigger99925.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          TeleportFRPlayer(ent, < -13538.8000, 27513, -332.6000 > , < 0, 0, 0 > )
        }
      }
    })
  DispatchSpawn(trigger99925)
  entity trigger99926 = MapEditor_CreateTrigger( < -13445.8700, 27501.7000, -298.8496 > , < 0, 0, 0 > , 234.1279, 46.82558, false)
  trigger99926.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
          ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
          ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
          ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
        }
      }
    })
  DispatchSpawn(trigger99926)
  entity trigger99990 = MapEditor_CreateTrigger( < -13402.6700, 26545.2000, -69.5488 > , < 0, 0, 0 > , 120.4611, 24.09223, false)
  trigger99990.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
          ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
          ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
          ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
        }
      }
    })
  DispatchSpawn(trigger99990)
  entity trigger99991 = MapEditor_CreateTrigger( < -13540.7700, 26522.1000, -69.5488 > , < 0, 0, 0 > , 120.4611, 24.09223, false)
  trigger99991.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
          ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
          ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
          ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
        }
      }
    })
  DispatchSpawn(trigger99991)
  entity trigger99992 = MapEditor_CreateTrigger( < -13540.7700, 26416.5000, -69.5488 > , < 0, 0, 0 > , 120.4611, 24.09223, false)
  trigger99992.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
          ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
          ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
          ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
        }
      }
    })
  DispatchSpawn(trigger99992)
  entity trigger99993 = MapEditor_CreateTrigger( < -13402.6700, 26416.5000, -69.5488 > , < 0, 0, 0 > , 120.4611, 24.09223, false)
  trigger99993.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
          ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
          ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
          ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
        }
      }
    })
  DispatchSpawn(trigger99993)

}

//Init Grapple Segments with cooldown fix
void
function MovementGym_Grapple2() {
  // Props Array
  array < entity > ClipArray;
  array < entity > NoGrappleNoClimbArray;
  array < entity > NoCollisionArray;

  // Props
  MapEditor_CreateProp($"mdl/ola/sewer_railing_01_64.rmdl", < 16348.3, -33291.7, 22910.3 > , < 0, -180, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/ola/sewer_railing_01_128.rmdl", < 16348.3, -33382.6, 22910.3 > , < 0, 179.9999, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/ola/sewer_railing_01_corner_in.rmdl", < 16348.3, -33506, 22910.3 > , < 0, -90, 0 > , true, 5000, -1, 1)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_02.rmdl", < 16533.1, -32708.24, 22726.9 > , < 0, 0, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 10457.3, -26008.9, 22425.8 > , < 0, 0, 0 > , true, 5000, -1, 1))
  MapEditor_CreateProp($"mdl/lamps/light_parking_post.rmdl", < 10417, -25292.7, 22395.1 > , < 0, 0, 0 > , true, 5000, -1, 1)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 10419.63, -26303, 22436.1 > , < 0, -89.9999, 0 > , true, 5000, -1, 1.82))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 10408.23, -26199.8, 22436.1 > , < 0, -179.9999, 0 > , true, 5000, -1, 1.82))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 10420.4, -26241.84, 22312.1 > , < 0, 90, 0 > , true, 5000, -1, 0.7657141)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 10453.02, -26199.1, 22312.1 > , < 0, 0, 0 > , true, 5000, -1, 0.7657141)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 10507.53, -26298.7, 22434.1 > , < 0, -89.9999, 0 > , true, 5000, -1, 1.82))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 10405.73, -26287.1, 22434.1 > , < 0, -179.9999, 0 > , true, 5000, -1, 1.82))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 10453.02, -26296.8, 22312.1 > , < 0, -180, 0 > , true, 5000, -1, 0.7657141)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 10427.2, -26253.05, 22439.1 > , < 0, -179.9999, 0 > , true, 5000, -1, 1.82))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 10488.9, -26230.59, 22439.1 > , < 0, 0, 0 > , true, 5000, -1, 1.82))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 10501.03, -26285.7, 22436.1 > , < 0, 0, 0 > , true, 5000, -1, 1.82))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 10495.7, -26241.8, 22312.1 > , < 0, -90, 0 > , true, 5000, -1, 0.7657142)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 10507.63, -26202.6, 22434.1 > , < 0, 0, 0 > , true, 5000, -1, 1.82))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 10448.03, -26188.2, 22439.1 > , < 0, 0, 0 > , true, 5000, -1, 1.82))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 10488.9, -26009.29, 22439.1 > , < 0, 0, 0 > , true, 5000, -1, 1.82))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 10501.03, -26064.39, 22436.1 > , < 0, 0, 0 > , true, 5000, -1, 1.82))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 10495.7, -26020.49, 22312.1 > , < 0, -90, 0 > , true, 5000, -1, 0.7657142)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 10507.63, -25981.29, 22434.1 > , < 0, 0, 0 > , true, 5000, -1, 1.82))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 10419.63, -26081.69, 22436.1 > , < 0, -89.9999, 0 > , true, 5000, -1, 1.82))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 10408.23, -25978.49, 22436.1 > , < 0, -179.9999, 0 > , true, 5000, -1, 1.82))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 10427.2, -26031.74, 22439.1 > , < 0, -179.9999, 0 > , true, 5000, -1, 1.82))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 10405.73, -26065.79, 22434.1 > , < 0, -179.9999, 0 > , true, 5000, -1, 1.82))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 10453.02, -25977.8, 22312.1 > , < 0, 0, 0 > , true, 5000, -1, 0.7657141)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 10507.53, -26077.39, 22434.1 > , < 0, -89.9999, 0 > , true, 5000, -1, 1.82))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 10420.4, -26020.54, 22312.1 > , < 0, 90, 0 > , true, 5000, -1, 0.7657141)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 10453.02, -26075.49, 22312.1 > , < 0, -180, 0 > , true, 5000, -1, 0.7657141)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 10448.03, -25966.89, 22439.1 > , < 0, 0, 0 > , true, 5000, -1, 1.82))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 10420.4, -25279.84, 22312.1 > , < 0, 90, 0 > , true, 5000, -1, 0.7657141)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 10405.73, -25325.1, 22434.1 > , < 0, -179.9999, 0 > , true, 5000, -1, 1.82))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 10408.23, -25237.8, 22436.1 > , < 0, -179.9999, 0 > , true, 5000, -1, 1.82))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 10427.2, -25291.05, 22439.1 > , < 0, -179.9999, 0 > , true, 5000, -1, 1.82))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 10495.4, -22482.7, 22312.1 > , < 0, -90, 0 > , true, 5000, -1, 0.7657142)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 10452.72, -22440, 22312.1 > , < 0, 0, 0 > , true, 5000, -1, 0.7657141)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 10420.1, -22482.74, 22312.1 > , < 0, 90, 0 > , true, 5000, -1, 0.7657141)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 10452.72, -22537.7, 22312.1 > , < 0, -180, 0 > , true, 5000, -1, 0.7657141)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 9714.131, -32272, 22499.05 > , < 0, 0, 0 > , true, 5000, -1, 1.137392)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 9720.33, -32324.6, 22499.05 > , < 0, -180, 0 > , true, 5000, -1, 1.137392)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 9888.83, -32272, 22499.05 > , < 0, 0, 0 > , true, 5000, -1, 1.137392)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 9895.029, -32324.6, 22499.05 > , < 0, -180, 0 > , true, 5000, -1, 1.137392)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 10193.73, -32881, 22740.35 > , < 0, -90, 0 > , true, 5000, -1, 0.8458858)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 10153.73, -32885, 22740.35 > , < 0, 90, 0 > , true, 5000, -1, 0.8458857)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 9933.83, -32613.3, 22680.85 > , < 0, -90, 0 > , true, 5000, -1, 1.017431)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 9933.83, -32613.3, 22575.15 > , < 0, -90, 0 > , true, 5000, -1, 1.017431)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 9933.83, -32613.3, 22827.25 > , < 0, -90, 0 > , true, 5000, -1, 1.017431)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 9933.83, -32613.3, 22944.85 > , < 0, -90, 0 > , true, 5000, -1, 1.017431)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 9933.83, -32334.2, 22944.85 > , < 0, -90, 0 > , true, 5000, -1, 1.017431)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 9908.131, -32311.5, 22869.9 > , < 0, -90, 0 > , true, 5000, -1, 1.197212)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 9758.131, -32245.5, 22962.85 > , < 0, 0.0001, 0 > , true, 5000, -1, 1.017431)
  ClipArray.append(MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 9735.439, -32271.19, 22869.9 > , < 0, 0.0001, 0 > , true, 5000, -1, 1.197212))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 16236.83, -32777.4, 22541.15 > , < 0, 0, 0 > , true, 5000, -1, 1.137392)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 16456.53, -33118.7, 22722.95 > , < 0, -90, 0 > , true, 5000, -1, 1.017431)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 16456.53, -33118.7, 22986.95 > , < 0, -90, 0 > , true, 5000, -1, 1.017431)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 16243.03, -32830, 22541.15 > , < 0, -180, 0 > , true, 5000, -1, 1.137392)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 16411.53, -32777.4, 22541.15 > , < 0, 0, 0 > , true, 5000, -1, 1.137392)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 16417.73, -32830, 22541.15 > , < 0, -180, 0 > , true, 5000, -1, 1.137392)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 16485.43, -33386.4, 22782.45 > , < 0, -90, 0 > , true, 5000, -1, 0.8458858)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 16445.43, -33390.4, 22782.45 > , < 0, 90, 0 > , true, 5000, -1, 0.8458857)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 16456.53, -33118.7, 22585.85 > , < 0, -90, 0 > , true, 5000, -1, 1.017431)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 16456.53, -33118.7, 22869.35 > , < 0, -90, 0 > , true, 5000, -1, 1.017431)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 16456.53, -32839.59, 22986.95 > , < 0, -90, 0 > , true, 5000, -1, 1.017431)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 16430.83, -32816.9, 22912 > , < 0, -90, 0 > , true, 5000, -1, 1.197212)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 16280.83, -32750.9, 23004.95 > , < 0, 0.0001, 0 > , true, 5000, -1, 1.017431)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 9933.83, -32836.5, 22944.85 > , < 0, -90, 0 > , true, 5000, -1, 1.017431)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 9933.83, -32836.5, 22543.75 > , < 0, -90, 0 > , true, 5000, -1, 1.017431)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 9933.83, -32836.5, 22827.25 > , < 0, -90, 0 > , true, 5000, -1, 1.017431)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 9886.23, -32592.3, 22712.25 > , < 0, 0, 0 > , true, 5000, -1, 1.017431)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 9689.932, -32592.3, 22712.25 > , < 0, 0, 0 > , true, 5000, -1, 1.017431)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 9933.83, -32836.5, 22663.75 > , < 0, -90, 0 > , true, 5000, -1, 1.017431)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 9689.932, -32592.3, 22580.15 > , < 0, 0, 0 > , true, 5000, -1, 1.017431)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 16456.53, -33342.3, 22632.95 > , < 0, -90, 0 > , true, 5000, -1, 1.017431)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 9712.754, -32319, 22962.85 > , < 0, -179.9999, 0 > , true, 5000, -1, 1.017431)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 9735.439, -32308.8, 22869.9 > , < 0, -179.9999, 0 > , true, 5000, -1, 1.197212)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 16235.45, -32846.29, 23004.95 > , < 0, -179.9999, 0 > , true, 5000, -1, 1.017431)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 16456.53, -33092.8, 22869.35 > , < 0, 90.0001, 0 > , true, 5000, -1, 1.017431)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 16223.23, -33102.3, 22756.65 > , < 0, 0, 0 > , true, 5000, -1, 1.017431)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 16223.23, -33102.3, 22624.55 > , < 0, 0, 0 > , true, 5000, -1, 1.017431)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 4039.199, -26020.34, 22312.1 > , < 0, 90, 0 > , true, 5000, -1, 0.7657141)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 4024.53, -25324.9, 22434.1 > , < 0, -179.9999, 0 > , true, 5000, -1, 1.82))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 4107.7, -26230.39, 22439.1 > , < 0, 0, 0 > , true, 5000, -1, 1.82))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 4038.431, -26302.8, 22436.1 > , < 0, -89.9999, 0 > , true, 5000, -1, 1.82))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 4046, -26252.85, 22439.1 > , < 0, -179.9999, 0 > , true, 5000, -1, 1.82))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 4119.831, -26285.5, 22436.1 > , < 0, 0, 0 > , true, 5000, -1, 1.82))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 4114.499, -26241.6, 22312.1 > , < 0, -90, 0 > , true, 5000, -1, 0.7657142)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 4126.331, -26077.19, 22434.1 > , < 0, -89.9999, 0 > , true, 5000, -1, 1.82))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 4046, -26031.54, 22439.1 > , < 0, -179.9999, 0 > , true, 5000, -1, 1.82))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 4038.431, -26081.49, 22436.1 > , < 0, -89.9999, 0 > , true, 5000, -1, 1.82))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 4126.331, -26298.5, 22434.1 > , < 0, -89.9999, 0 > , true, 5000, -1, 1.82))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 4071.82, -25977.6, 22312.1 > , < 0, 0, 0 > , true, 5000, -1, 0.7657141)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 4071.82, -26075.29, 22312.1 > , < 0, -180, 0 > , true, 5000, -1, 0.7657141)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 4113.9, -26247.66, 23406.5 > , < 0, -90, 0 > , true, 5000, -1, 0.7657142)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 4119.831, -26064.19, 22436.1 > , < 0, 0, 0 > , true, 5000, -1, 1.82))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 4114.499, -26020.29, 22312.1 > , < 0, -90, 0 > , true, 5000, -1, 0.7657142)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 4081.287, -26192.7, 23406.5 > , < 0, -0.0001, 0 > , true, 5000, -1, 0.7657141)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 4071.82, -26198.9, 22312.1 > , < 0, 0, 0 > , true, 5000, -1, 0.7657141)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 4027.03, -26199.6, 22436.1 > , < 0, -179.9999, 0 > , true, 5000, -1, 1.82))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 4039.199, -26241.64, 22312.1 > , < 0, 90, 0 > , true, 5000, -1, 0.7657141)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 4126.431, -26202.4, 22434.1 > , < 0, 0, 0 > , true, 5000, -1, 1.82))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 4066.831, -26188, 22439.1 > , < 0, 0, 0 > , true, 5000, -1, 1.82))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 4027.03, -25978.29, 22436.1 > , < 0, -179.9999, 0 > , true, 5000, -1, 1.82))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 4046, -25290.85, 22439.1 > , < 0, -179.9999, 0 > , true, 5000, -1, 1.82))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 4107.7, -26009.09, 22439.1 > , < 0, 0, 0 > , true, 5000, -1, 1.82))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 4126.431, -25981.09, 22434.1 > , < 0, 0, 0 > , true, 5000, -1, 1.82))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 4066.831, -25966.69, 22439.1 > , < 0, 0, 0 > , true, 5000, -1, 1.82))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 4024.53, -26286.9, 22434.1 > , < 0, -179.9999, 0 > , true, 5000, -1, 1.82))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 4039.199, -25279.64, 22312.1 > , < 0, 90, 0 > , true, 5000, -1, 0.7657141)
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 4071.82, -26296.6, 22312.1 > , < 0, -180, 0 > , true, 5000, -1, 0.7657141)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 4024.53, -26065.59, 22434.1 > , < 0, -179.9999, 0 > , true, 5000, -1, 1.82))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 4038.599, -26247.7, 23406.5 > , < 0, 89.9999, 0 > , true, 5000, -1, 0.7657142)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 4027.03, -25237.6, 22436.1 > , < 0, -179.9999, 0 > , true, 5000, -1, 1.82))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 4081.273, -26290.39, 23406.5 > , < 0, 180, 0 > , true, 5000, -1, 0.7657141)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 10406.13, -22533.3, 22427.65 > , < 0, -179.9999, 0 > , true, 5000, -1, 1.82))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 10408.63, -22446, 22429.65 > , < 0, -179.9999, 0 > , true, 5000, -1, 1.82))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 10427.6, -22499.25, 22432.65 > , < 0, -179.9999, 0 > , true, 5000, -1, 1.82))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 10503.63, -22444.38, 22427.65 > , < 0, 0.0002, 0 > , true, 5000, -1, 1.82))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 10501.13, -22531.68, 22429.65 > , < 0, 0.0002, 0 > , true, 5000, -1, 1.82))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_01.rmdl", < 10482.16, -22478.44, 22432.65 > , < 0, 0.0002, 0 > , true, 5000, -1, 1.82))
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 10457.3, -26259.3, 22425.8 > , < 0, 0, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 10457, -22465.4, 22425.8 > , < 0, 0, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 10457, -22505, 22425.8 > , < 0, 0, 0 > , true, 5000, -1, 1))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 16258.14, -32776.59, 22912 > , < 0, 0.0001, 0 > , true, 5000, -1, 1.197212)
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 16461.5, -32771.7, 22891.35 > , < 0, 0, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 16212.7, -32957.6, 22777.05 > , < 0, 0, 90 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 16468.3, -32957.6, 22777.05 > , < 0, 0, 90 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 16464.7, -33388.9, 22909.7 > , < 0, 0, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 16207.3, -32771.7, 22891.35 > , < 0, 0, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 16461.5, -32767.6, 22718 > , < 0, 0, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 16207.3, -32767.6, 22718 > , < 0, 0, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 16461.5, -32869.7, 22891.35 > , < 0, 0, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 16207.3, -32869.7, 22891.35 > , < 0, 0, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 16207.3, -32869.7, 22718 > , < 0, 0, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 16461.5, -32869.7, 22718 > , < 0, 0, 0 > , true, 5000, -1, 1))
  NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 16454.7, -32644.5, 22777.05 > , < 0, 0, 90 > , true, 5000, -1, 1))
  NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 16212.7, -32644.5, 22777.05 > , < 0, 0, 90 > , true, 5000, -1, 1))
  NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 16097.5, -32866.5, 22777.05 > , < 0, -90, 90 > , true, 5000, -1, 1))
  NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 16097.5, -32774.2, 22777.05 > , < 0, -90, 90 > , true, 5000, -1, 1))
  NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < 16203.7, -33510.7, 23212.7 > , < -90, 90, 0 > , true, 5000, -1, 1))
  NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < 16597.7, -33350.23, 22535.7 > , < -90, 0, 0 > , true, 5000, -1, 1))
  NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < 16339.7, -33348.1, 23248.7 > , < -90, 0, 0 > , true, 5000, -1, 1))
  NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < 16200.6, -33290.4, 23212.7 > , < -90, -90, 0 > , true, 5000, -1, 1))
  NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < 10067, -32441.7, 23251.35 > , < -90, 0, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 9938.801, -32364.3, 22675.9 > , < 0, 0, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 9684.602, -32364.3, 22675.9 > , < 0, 0, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 9684.602, -32364.3, 22849.25 > , < 0, 0, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 9938.801, -32364.3, 22849.25 > , < 0, 0, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 9684.602, -32262.2, 22675.9 > , < 0, 0, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 9938.801, -32262.2, 22675.9 > , < 0, 0, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 9938.801, -32266.3, 22849.25 > , < 0, 0, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 9684.602, -32266.3, 22849.25 > , < 0, 0, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 10173, -32883.5, 22867.6 > , < 0, 0, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 9932, -32452.2, 22734.95 > , < 0, 0, 90 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 9690, -32452.2, 22734.95 > , < 0, 0, 90 > , true, 5000, -1, 1))
  NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 9690, -32139.1, 22734.95 > , < 0, 0, 90 > , true, 5000, -1, 1))
  NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 9932, -32139.1, 22734.95 > , < 0, 0, 90 > , true, 5000, -1, 1))
  NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 9574.801, -32361.1, 22734.95 > , < 0, -90, 90 > , true, 5000, -1, 1))
  NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 9574.801, -32268.8, 22734.95 > , < 0, -90, 90 > , true, 5000, -1, 1))
  NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < 9732, -32105.7, 23251.35 > , < -90, 90, 0 > , true, 5000, -1, 1))
  NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < 10067, -32758.7, 23213.2 > , < -90, 0, 0 > , true, 5000, -1, 1))
  NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < 10381, -33005.3, 23213.2 > , < -90, 90, 0 > , true, 5000, -1, 1))
  NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < 10068, -32847.23, 22563.6 > , < -90, 0, 0 > , true, 5000, -1, 1))
  NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < 16254.7, -32611.1, 23293.45 > , < -90, 90, 0 > , true, 5000, -1, 1))
  NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < 16589.7, -32897.5, 23293.45 > , < -90, 0, 0 > , true, 5000, -1, 1))
  NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 10172.38, -32751.03, 22753.65 > , < 0, 0, 90 > , true, 5000, -1, 1))
  NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < 16589.7, -33909.52, 23198.15 > , < -90, 0, 0 > , true, 5000, -1, 1))
  MapEditor_CreateProp($"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 16258.14, -32820.6, 22912 > , < 0, -179.9999, 0 > , true, 5000, -1, 1.197212)
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_02.rmdl", < 16426.9, -32742, 22736 > , < 0, 0, 0 > , true, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_02.rmdl", < 16436.8, -32696.5, 22725 > , < 0, 0, 0 > , true, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_02.rmdl", < 16519.8, -32832.9, 22726.9 > , < 0, 0, 0 > , true, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_02.rmdl", < 16456, -32807.4, 22737.6 > , < 0, 0, 0 > , true, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_02.rmdl", < 16456, -32895, 22728 > , < 0, 0, 0 > , true, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_02.rmdl", < 16528.3, -32895, 22728 > , < 0, 0, 0 > , true, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_02.rmdl", < 16369.6, -32913.2, 22731.5 > , < 0, 0, 0 > , true, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_02.rmdl", < 16283.9, -32913.2, 22731.5 > , < 0, 0, 0 > , true, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_02.rmdl", < 16369.6, -32827.4, 22733.6 > , < 0, 0, 0 > , true, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_02.rmdl", < 16263.3, -32820.2, 22733.6 > , < 0, 0, 0 > , true, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_02.rmdl", < 16179.4, -32820.2, 22733.6 > , < 0, 0, 0 > , true, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_02.rmdl", < 16179.4, -32890.8, 22733.6 > , < 0, 0, 0 > , true, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_02.rmdl", < 16179.4, -32719.7, 22733.6 > , < 0, 0, 0 > , true, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_02.rmdl", < 16308.5, -32719.7, 22733.6 > , < 0, 0, 0 > , true, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_02.rmdl", < 16134.3, -32890.9, 22724.4 > , < 0, 0, 0 > , true, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_02.rmdl", < 16134.3, -32712, 22724.4 > , < 0, 0, 0 > , true, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_02.rmdl", < 10001, -32204.24, 22684.8 > , < 0, 0, 0 > , true, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_02.rmdl", < 9894.801, -32238, 22693.9 > , < 0, 0, 0 > , true, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_02.rmdl", < 9904.701, -32192.5, 22682.9 > , < 0, 0, 0 > , true, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_02.rmdl", < 9987.701, -32328.9, 22684.8 > , < 0, 0, 0 > , true, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_02.rmdl", < 9923.902, -32303.4, 22695.5 > , < 0, 0, 0 > , true, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_02.rmdl", < 9923.902, -32391, 22685.9 > , < 0, 0, 0 > , true, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_02.rmdl", < 9996.201, -32391, 22685.9 > , < 0, 0, 0 > , true, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_02.rmdl", < 9837.502, -32409.2, 22689.4 > , < 0, 0, 0 > , true, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_02.rmdl", < 9751.801, -32409.2, 22689.4 > , < 0, 0, 0 > , true, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_02.rmdl", < 9837.502, -32323.4, 22691.5 > , < 0, 0, 0 > , true, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_02.rmdl", < 9731.201, -32316.2, 22691.5 > , < 0, 0, 0 > , true, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_02.rmdl", < 9647.301, -32316.2, 22691.5 > , < 0, 0, 0 > , true, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_02.rmdl", < 9647.301, -32386.8, 22691.5 > , < 0, 0, 0 > , true, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_02.rmdl", < 9647.301, -32215.7, 22691.5 > , < 0, 0, 0 > , true, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_02.rmdl", < 9776.402, -32215.7, 22691.5 > , < 0, 0, 0 > , true, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_02.rmdl", < 9602.201, -32386.9, 22682.3 > , < 0, 0, 0 > , true, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_02.rmdl", < 9602.201, -32208, 22682.3 > , < 0, 0, 0 > , true, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_02.rmdl", < 10238, -32816, 22877 > , < 0, 0, 0 > , true, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_02.rmdl", < 10232.4, -32939, 22882.4 > , < 0, 0, 0 > , true, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_02.rmdl", < 10118.4, -32939, 22882.4 > , < 0, 0, 0 > , true, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_02.rmdl", < 10143.9, -32845.4, 22882.4 > , < 0, 0, 0 > , true, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_02.rmdl", < 16514.3, -33344.6, 22924 > , < 0, 90, 0 > , true, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_02.rmdl", < 16522, -33436.8, 22924.5 > , < 0, 0, 0 > , true, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_02.rmdl", < 16408, -33436.8, 22924.5 > , < 0, 0, 0 > , true, 5000, -1, 1))
  NoCollisionArray.append(MapEditor_CreateProp($"mdl/foliage/icelandic_moss_grass_02.rmdl", < 16409.5, -33325.5, 22924.5 > , < 0, 0, 0 > , true, 5000, -1, 1))
  MapEditor_CreateProp($"mdl/ola/sewer_railing_01_128.rmdl", < 16472.1, -33506.1, 22910.3 > , < 0, -90.0001, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/ola/sewer_railing_01_64.rmdl", < 16563.8, -33506.1, 22910.3 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/ola/sewer_railing_01_corner_in.rmdl", < 10294.8, -32998.99, 22868.2 > , < 0, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/ola/sewer_railing_01_128.rmdl", < 10171.4, -32999, 22868.2 > , < 0, -90.0001, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/ola/sewer_railing_01_64.rmdl", < 10080.5, -32999, 22868.2 > , < 0, -90, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/ola/sewer_railing_01_128.rmdl", < 10294.9, -32875.2, 22868.2 > , < 0, -0.0001, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/ola/sewer_railing_01_64.rmdl", < 10294.9, -32783.5, 22868.2 > , < 0, 0, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/ola/sewer_railing_01_128.rmdl", < 9551.906, -32268.5, 22676.6 > , < 0, 179.9999, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/ola/sewer_railing_01_128.rmdl", < 9675.402, -32144.7, 22676.6 > , < 0, 89.9999, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/ola/sewer_railing_01_corner_in.rmdl", < 9552, -32144.7, 22676.6 > , < 0, -180, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/ola/sewer_railing_01_128.rmdl", < 9551.906, -32390.8, 22676.6 > , < 0, 179.9999, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/ola/sewer_railing_01_128.rmdl", < 9799, -32144.7, 22676.6 > , < 0, 89.9999, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/ola/sewer_railing_01_128.rmdl", < 9921.801, -32144.7, 22676.6 > , < 0, 89.9999, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/ola/sewer_railing_01_corner_in.rmdl", < 16075.3, -32653.5, 22718.7 > , < 0, -180, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/ola/sewer_railing_01_128.rmdl", < 16198.7, -32653.5, 22718.7 > , < 0, 89.9999, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/ola/sewer_railing_01_128.rmdl", < 16075.2, -32777.3, 22718.7 > , < 0, 179.9999, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/ola/sewer_railing_01_128.rmdl", < 16075.2, -32899.6, 22718.7 > , < 0, 179.9999, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/ola/sewer_railing_01_128.rmdl", < 16322.3, -32653.5, 22718.7 > , < 0, 89.9999, 0 > , true, 5000, -1, 1)
  MapEditor_CreateProp($"mdl/ola/sewer_railing_01_128.rmdl", < 16445.1, -32653.5, 22718.7 > , < 0, 89.9999, 0 > , true, 5000, -1, 1)
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 4076.1, -26259.1, 22425.8 > , < 0, 0, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 4077, -26265, 23520.2 > , < 0, 179.9999, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 4076.999, -26225.39, 23520.2 > , < 0, 179.9999, 0 > , true, 5000, -1, 1))
  ClipArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 4076.1, -26008.7, 22425.8 > , < 0, 0, 0 > , true, 5000, -1, 1))
  MapEditor_CreateProp($"mdl/lamps/light_parking_post.rmdl", < 4035.8, -25292.5, 22395.1 > , < 0, 0, 0 > , true, 5000, -1, 1)
  NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 4077, -26112, 23405 > , < 0, 179.9999, 90 > , true, 5000, -1, 1))
  NoGrappleNoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 4077, -26229.93, 23369.2 > , < 0, 179.9999, 0 > , true, 5000, -1, 1))

  foreach(entity ent in ClipArray) {
    ent.MakeInvisible()
    ent.kv.solid = 6
    ent.kv.CollisionGroup = TRACE_COLLISION_GROUP_PLAYER
    ent.kv.contents = CONTENTS_PLAYERCLIP
  }

  foreach(entity ent in NoGrappleNoClimbArray) {
    ent.MakeInvisible()
    ent.kv.solid = 3
    ent.kv.CollisionGroup = TRACE_COLLISION_GROUP_PLAYER
    ent.kv.contents = CONTENTS_SOLID | CONTENTS_NOGRAPPLE
  }

  foreach(entity ent in NoCollisionArray) ent.kv.solid = 0

  // Buttons
  AddCallback_OnUseEntity(CreateFRButton( < 10457.2, -26370.2, 22435.4 > , < 0, -179.9997, 0 > , "%use% Back to Hub"), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < 10726.9000, 10287, -4283 > , < 0, -89.9998, 0 > )
      Message(user, "HUB", "\n  You now recieved Phase Walk Tactical")
    })

  AddCallback_OnUseEntity(CreateFRButton( < 10416.5, -22351.61, 22430.3 > , < 0, 0.0004, 0 > , "%use% Repeat"), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < 10446.3000, -26287.1000, 22469.8000 > , < 0, -89.9998, 0 > )
    })

  AddCallback_OnUseEntity(CreateFRButton( < 10495.7, -22351.61, 22430.3 > , < 0, 0.0004, 0 > , "%use% Next"), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < 4076, -26273.7000, 22448.4000 > , < 0, 90, 0 > )
      Message(user, "Grapple 180")
    })

  AddCallback_OnUseEntity(CreateFRButton( < 10213.5, -32983.9, 22883.1 > , < 0, -179.9996, 0 > , "%use% Repeat"), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < 9897.1310, -32726.8000, 21723.7500 > , < 0, 0, 0 > )
    })

  AddCallback_OnUseEntity(CreateFRButton( < 10134.3, -32983.9, 22883.1 > , < 0, -179.9996, 0 > , "%use% Next"), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < 16166.3000, -32793.7000, 22736.9000 > , < 0, 0, 0 > )
      Message(user, "Fragment Stairs Medium")
    })

  AddCallback_OnUseEntity(CreateFRButton( < 9582.1, -32303.1, 22691.41 > , < 0, 90.0004, 0 > , "%use% Back to Hub"), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < 10726.9000, 10287, -4283 > , < 0, -89.9998, 0 > )
      Message(user, "HUB", "\n  You now recieved Phase Walk Tactical")
    })

  AddCallback_OnUseEntity(CreateFRButton( < 16365.2, -33433.54, 22921.69 > , < 0, 90.0005, 0 > , "%use% Repeat"), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < 16150.4300, -32819, 22737.3000 > , < 0, 0, 0 > )
    })

  AddCallback_OnUseEntity(CreateFRButton( < 16103.3, -32793.7, 22730 > , < 0, 90.0004, 0 > , "%use% Back to Hub"), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < 10726.9000, 10287, -4283 > , < 0, -89.9998, 0 > )
      Message(user, "HUB", "\n  You now recieved Phase Walk Tactical")
    })

  AddCallback_OnUseEntity(CreateFRButton( < 4076, -26370, 22434.2 > , < 0, -179.9997, 0 > , "%use% Back to Hub"), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < 10726.9000, 10287, -4283 > , < 0, -89.9998, 0 > )
      Message(user, "HUB", "\n  You now recieved Phase Walk Tactical")
    })

  AddCallback_OnUseEntity(CreateFRButton( < 4038.299, -26366.34, 23529.3 > , < 0, -179.9997, 0 > , "%use% Next"), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < 9645.9000, -32303.1000, 22703.5000 > , < 0, 0, 0 > )
      Message(user, "Fragment Stairs Easy")
    })

  AddCallback_OnUseEntity(CreateFRButton( < 4117.502, -26366.34, 23529.3 > , < 0, -179.9997, 0 > , "%use% Repeat"), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < 4074.23, -26263.6, 22462.65 > , < 0, -89.9998, 0 > )
    })

  AddCallback_OnUseEntity(CreateFRButton( < 16365.2, -33362.04, 22921.69 > , < 0, 90.0005, 0 > , "%use% Back to Hub"), void
    function (entity panel, entity user, int input) {
      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
      TeleportFRPlayer(user, < 10726.9000, 10287, -4283 > , < 0, -89.9998, 0 > )
      Message(user, "HUB", "\n  You now recieved Phase Walk Tactical")
    })

  // Triggers
  entity trigger_0 = MapEditor_CreateTrigger( < 10455.43, -26263.8, 22469.55 > , < 0, 0, 0 > , 132.982, 26.5964, false)
  trigger_0.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
          ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
          ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
          ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
          ent.SetSuitGrapplePower(100)
        }
      }
    })
  DispatchSpawn(trigger_0)
  entity trigger_1 = MapEditor_CreateTrigger( < 10455.43, -26105.1, 22469.55 > , < 0, 0, 0 > , 132.982, 26.5964, false)
  trigger_1.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
          ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
          ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
          ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
          ent.SetSuitGrapplePower(100)
        }
      }
    })
  DispatchSpawn(trigger_1)
  entity trigger_2 = MapEditor_CreateTrigger( < 10311.13, -25143.8, 21718.15 > , < 0, 0, 0 > , 3032.002, 606.4005, false)
  trigger_2.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          ent.SetOrigin( < 10446.3000, -26287.1000, 22469.8000 > ) // change tp location
        }
      }
    })
  DispatchSpawn(trigger_2)
  entity trigger_3 = MapEditor_CreateTrigger( < 9897.131, -32726.8, 21723.75 > , < 0, 0, 0 > , 3032.002, 606.4005, false)
  trigger_3.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          ent.SetOrigin( < 9645.9000, -32303.1000, 22703.5000 > ) // change tp location
        }
      }
    })
  DispatchSpawn(trigger_3)
  entity trigger_4 = MapEditor_CreateTrigger( < 16371.13, -32761.8, 21717.85 > , < 0, 0, 0 > , 3032.002, 606.4005, false)
  trigger_4.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          ent.SetOrigin( < 16166.3000, -32793.7000, 22736.9000 > ) // change tp location
        }
      }
    })
  DispatchSpawn(trigger_4)
  entity trigger_5 = MapEditor_CreateTrigger( < 9908.101, -32307.5, 22704.95 > , < 0, -90, 0 > , 193.5, 26.5964, false)
  trigger_5.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
          ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
          ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
          ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
          ent.SetSuitGrapplePower(100)
        }
      }
    })
  DispatchSpawn(trigger_5)
  entity trigger_6 = MapEditor_CreateTrigger( < 16421, -32812.8, 22755.95 > , < 0, -90, 0 > , 193.5, 26.5964, false)
  trigger_6.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
          ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
          ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
          ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
          ent.SetSuitGrapplePower(100)
        }
      }
    })
  DispatchSpawn(trigger_6)
  entity trigger_7 = MapEditor_CreateTrigger( < 4074.23, -26263.6, 22469.55 > , < 0, 0, 0 > , 132.982, 26.5964, false)
  trigger_7.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
          ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
          ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
          ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
          ent.SetSuitGrapplePower(100)
        }
      }
    })
  DispatchSpawn(trigger_7)
  entity trigger_8 = MapEditor_CreateTrigger( < 3929.931, -25143.6, 21718.15 > , < 0, 0, 0 > , 3032.002, 606.4005, false)
  trigger_8.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          ent.SetOrigin( < 4076, -26273.7000, 22448.4000 > ) // change tp location
        }
      }
    })
  DispatchSpawn(trigger_8)
  entity trigger_9 = MapEditor_CreateTrigger( < 4074.23, -26104.9, 22469.55 > , < 0, 0, 0 > , 132.982, 26.5964, false)
  trigger_9.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
          ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
          ent.GiveOffhandWeapon("mp_ability_grapple", OFFHAND_TACTICAL)
          ent.GetOffhandWeapon(OFFHAND_LEFT).SetWeaponPrimaryClipCount(300)
          ent.SetSuitGrapplePower(100)
        }
      }
    })
  DispatchSpawn(trigger_9)
  entity trigger_10 = MapEditor_CreateTrigger( < 10311.13, -23082.8, 21718.15 > , < 0, 0, 0 > , 3032.002, 606.4005, false)
  trigger_10.SetEnterCallback(void
    function (entity trigger, entity ent) {
      if (IsValid(ent)) // ensure the entity is valid
      {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
          ent.SetOrigin( < 10446.3000, -26287.1000, 22469.8000 > ) // change tp location
        }
      }
    })
  DispatchSpawn(trigger_10)

}

////Init for Kitsune only without movement gym
//void
//function MovementGym_Surf_Kitsune() {
//
//  MovementGym_Surf_Kitsune_lvl1()
//  WaitFrame()
//
//  MovementGym_Surf_Kitsune_lvl2()
//  WaitFrame()
//
//  MovementGym_Surf_Kitsune_lvl3()
//  WaitFrame()
//
//  MovementGym_Surf_Kitsune_lvl4()
//  WaitFrame()
//
//  MovementGym_Surf_Kitsune_lvl5()
//  WaitFrame()
//
//  MovementGym_Surf_Kitsune_lvl6()
//  WaitFrame()
//
//  MovementGym_Surf_Kitsune_lvl7()
//}
//
//void
//function MovementGym_Surf_Kitsune_lvl1() {
//  vector startingorg = < 0, 0, 0 >
//
//    // Level Color
//    float rampr = 1.0
//  float rampg = 0.0
//  float rampb = 0.0
//  float carkrampr = 1.0
//  float darkrampg = 0.0
//  float darkrampb = 0.0
//
//  // Props Array
//  array < entity > ClipArray;
//  array < entity > NoGrappleArray;
//  array < entity > NoCollisionArray;
//
//  // Props
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -38028, -10138.74, 21199.91 > , < 5.0444, 0, 49.6068 > , false, 5000, 3, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37772.99, -10138.74, 21177.4 > , < 5.0444, 0, 49.6068 > , false, 5000, 3, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37517.97, -10138.74, 21154.89 > , < 5.0444, 0, 49.6068 > , false, 5000, 3, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37262.95, -10138.74, 21132.38 > , < 5.0444, 0, 49.6068 > , false, 5000, 3, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37280.09, -10304.63, 20938.17 > , < 5.0444, 0, 49.6068 > , false, 5000, 3, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37535.11, -10304.63, 20960.68 > , < 5.0444, 0, 49.6068 > , false, 5000, 3, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37790.13, -10304.63, 20983.19 > , < 5.0444, 0, 49.6068 > , false, 5000, 3, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -38045.14, -10304.63, 21005.7 > , < 5.0444, 0, 49.6068 > , false, 5000, 3, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37262.95, -9993.639, 21132.38 > , < -5.0444, -179.9997, 49.6068 > , false, 5000, 3, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37517.97, -9993.634, 21154.89 > , < -5.0444, -179.9997, 49.6068 > , false, 5000, 3, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37772.98, -9993.636, 21177.4 > , < -5.0444, -179.9997, 49.6068 > , false, 5000, 3, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -38028, -9993.637, 21199.91 > , < -5.0444, -179.9997, 49.6068 > , false, 5000, 3, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -38045.14, -9827.741, 21005.7 > , < -5.0444, -179.9997, 49.6068 > , false, 5000, 3, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37790.13, -9827.737, 20983.19 > , < -5.0444, -179.9997, 49.6068 > , false, 5000, 3, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37535.11, -9827.742, 20960.68 > , < -5.0444, -179.9997, 49.6068 > , false, 5000, 3, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37280.09, -9827.734, 20938.17 > , < -5.0444, -179.9997, 49.6068 > , false, 5000, 3, 1))
//  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_02.rmdl", < -38398.08, -10359.58, 21307.29 > , < 0, -89.9999, 0 > , false, 5000, 3, 1))
//  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_04_corner.rmdl", < -38894.07, -9272.236, 21307.29 > , < 0, 90.0004, 0 > , false, 5000, 3, 1))
//  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_04_corner.rmdl", < -38398.08, -10359.04, 21307.29 > , < 0, 0.0006, 0 > , false, 5000, 3, 1))
//  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_02.rmdl", < -36614.98, -9767.678, 21049.93 > , < 0, 90.0005, 0 > , false, 5000, 3, 1))
//  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_04_corner.rmdl", < -36118.98, -10855.02, 21049.93 > , < 0, -89.9992, 0 > , false, 5000, 3, 1))
//  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_04_corner.rmdl", < -36614.98, -9768.223, 21049.93 > , < 0, -179.9991, 0 > , false, 5000, 3, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -36257.13, -9354.638, 22064.93 > , < 0, 90.0005, 89.9998 > , false, 5000, 3, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -36257.1, -10559.64, 22064.93 > , < 0, 90.0005, 89.9998 > , false, 5000, 3, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -36257.1, -10559.64, 20802 > , < 0, 90.0005, 89.9998 > , false, 5000, 3, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -36257.13, -9354.638, 21441.93 > , < 0, 90.0005, 89.9998 > , false, 5000, 3, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -36257.13, -9354.638, 20802 > , < 0, 90.0005, 89.9998 > , false, 5000, 3, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -36257.11, -9983.648, 22064.93 > , < 0, 90.0005, 89.9998 > , false, 5000, 3, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -36257.11, -9983.648, 20802 > , < 0, 90.0005, 89.9998 > , false, 5000, 3, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -36257.11, -9983.648, 21441.93 > , < 0, 90.0005, 89.9998 > , false, 5000, 3, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -36257.1, -10559.64, 21441.93 > , < 0, 90.0005, 89.9998 > , false, 5000, 3, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/desertlands/desertlands_lobby_double_doorframe_02.rmdl", < -36259, -10059.8, 21052.4 > , < 0, 89.9998, 0 > , false, 5000, 3, 1))
//
//  foreach(entity ent in ClipArray) {
//    ent.MakeInvisible()
//    ent.kv.solid = 6
//    ent.kv.CollisionGroup = TRACE_COLLISION_GROUP_PLAYER
//    ent.kv.contents = CONTENTS_PLAYERCLIP
//  }
//
//  //Main Glow
//  foreach(entity ent in NoGrappleArray) {
//    ent.Highlight_SetFunctions(0, 136, false, 136, 3.0, 2, false)
//    ent.Highlight_SetParam(0, 0, < rampr, rampg, rampb > )
//  }
//
//  //Outline Glow
//  foreach(entity ent in NoCollisionArray) {
//    ent.Highlight_SetFunctions(0, 0, false, 136, 3.0, 2, false)
//    ent.Highlight_SetParam(0, 0, < rampr, rampg, rampb > )
//  }
//
//  // Buttons
//  AddCallback_OnUseEntity(CreateSurfButton( < -38594.93, -9874.137, 21306.73 > , < 0, 0, 0 > , "%use% Start Timer"), void
//    function (entity panel, entity user, int input) {
//      //Start Timer Button
//      user.p.isTimerActive = true
//      user.p.startTime = floor(Time()).tointeger()
//      Message(user, "Timer Started!")
//      Remote_CallFunction_NonReplay( user, "MG_StopWatch_toggle", false)
//      Remote_CallFunction_NonReplay( user, "MG_StopWatch_toggle", true)
//    })
//
//  AddCallback_OnUseEntity(CreateSurfButton( < -38593.7, -10285.93, 21306.73 > , < 0, 179.9999, 0 > , "%use% Back to Hub"), void
//    function (entity panel, entity user, int input) {
//      EmitSoundOnEntityOnlyToPlayer(user, user, FIRINGRANGE_BUTTON_SOUND)
//      TeleportFRPlayer(user, < 10726.9000, 10287, -4283 > , < 0, -89.9998, 0 > )
//      StatusEffect_StopAllOfType(user, eStatusEffect.stim_visual_effect)
//      StatusEffect_StopAllOfType(user, eStatusEffect.speed_boost)
//      user.TakeOffhandWeapon(OFFHAND_TACTICAL)
//      user.TakeOffhandWeapon(OFFHAND_ULTIMATE)
//      user.GiveOffhandWeapon("mp_ability_phase_walk", OFFHAND_TACTICAL)
//      user.PhaseShiftCancel()
//      //Start Checkpoint
//      user.p.allowCheckpoint = false
//      user.p.currentCheckpoint = 0
//      //Reset Timer
//      user.p.isTimerActive = false
//      user.p.startTime = 0
//      
//      Remote_CallFunction_NonReplay( user, "MG_StopWatch_toggle", false)
//
//      //Re-enable invis after surf
//      user.p.isPlayerInvisAllowed = true
//      if (user.IsInRealm(1) != true || user.IsInRealm(2) != true) {
//        user.RemoveFromAllRealms()
//        user.AddToRealm(1)
//        user.MakeVisible()
//        Message(user, "Hub", "You are now Visible")
//      }
//
//      //Force Default Player Settings
//      SetPlayerSettings(user, TDM_PLAYER_SETTINGS)
//    })
//
//  // Triggers
//  entity trigger_0 = MapEditor_CreateTrigger( < -32013.13, -16650.64, 17928.93 > , < 0, 0, 0 > , 25380, 50, false)
//  trigger_0.SetEnterCallback(void
//    function (entity trigger, entity ent) {
//      //Big ahh trigger
//      if (IsValid(ent)) {
//        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) {
//          if (ent.p.allowCheckpoint == true) {
//
//            switch (ent.p.currentCheckpoint) {
//              // Checkpoint 1
//            case 3:
//              ent.SetOrigin( < -38602.13, -10078.1, 21493.38 > )
//              ent.SetAngles( < 0, 0, 0 > )
//              ent.SetVelocity( < 0, 0, 0 > )
//              break
//              // Checkpoint 2
//            case 4:
//              ent.SetOrigin( < -38684.22, -12091.82, 21220.8 > )
//              ent.SetAngles( < 0, 0, 0 > )
//              ent.SetVelocity( < 0, 0, 0 > )
//              break
//              // Checkpoint 3
//            case 5:
//              ent.SetOrigin( < -38673.36, -14140.26, 21257.53 > )
//              ent.SetAngles( < 0, 0, 0 > )
//              ent.SetVelocity( < 0, 0, 0 > )
//              break
//              // Checkpoint 4
//            case 6:
//              ent.SetOrigin( < -38652.55, -17213.46, 21298.53 > )
//              ent.SetAngles( < 0, 0, 0 > )
//              ent.SetVelocity( < 0, 0, 0 > )
//              break
//              // Checkpoint 5
//            case 7:
//              ent.SetOrigin( < -38601.55, -20285.46, 21255.23 > )
//              ent.SetAngles( < 0, 0, 0 > )
//              ent.SetVelocity( < 0, 0, 0 > )
//              break
//              // Checkpoint 6
//            case 8:
//              ent.SetOrigin( < -38357.36, -24034.64, 21182.13 > )
//              ent.SetAngles( < 0, 0, 0 > )
//              ent.SetVelocity( < 0, 0, 0 > )
//              break
//              // Checkpoint 7
//            case 9:
//              ent.SetOrigin( < -22640.3, -8429.232, 27015.53 > )
//              ent.SetAngles( < 0, 180, 0 > )
//              ent.SetVelocity( < 0, 0, 0 > )
//              break
//            }
//          }
//        }
//      }
//    })
//  DispatchSpawn(trigger_0)
//  entity trigger_1 = MapEditor_CreateTrigger( < -36038.82, -10061.82, 21101 > , < 0, 0, 0 > , 237.05, 50, false)
//  trigger_1.SetEnterCallback(void
//    function (entity trigger, entity ent) {
//      if (IsValid(ent)) {
//        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
//        {
//          ent.SetOrigin( < -38684.22, -12091.82, 21220.8 > ) // change tp location
//          ent.SetAngles( < 0, 0, 0 > )
//
//          //
//          // Checkpoint and timer
//          //
//
//          int previousCheckpoint = 3
//          int checkpointInThisTrigger = 4
//          //show checkpoint msg
//          if(ent.p.currentCheckpoint != checkpointInThisTrigger)
//          	Remote_CallFunction_NonReplay( ent, "MG_Checkpoint_Msg")
//
//          if (ent.p.currentCheckpoint == previousCheckpoint) {
//            //set checkpoint
//            ent.p.currentCheckpoint = checkpointInThisTrigger
//
//            //change realm and lock invis
//            ent.RemoveFromAllRealms()
//            ent.AddToRealm(checkpointInThisTrigger)
//            ent.p.isPlayerInvisAllowed = false
//          }
//        }
//      }
//    })
//  DispatchSpawn(trigger_1)
//  entity trigger_2 = MapEditor_CreateTrigger( < -38602.13, -10078.1, 21363.29 > , < 0, 0, 0 > , 200, 50, false)
//  trigger_2.SetEnterCallback(void
//    function (entity trigger, entity ent) {
//      if (IsValid(ent)) // ensure the entity is valid
//      {
//        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
//        {
//          int checkpointInThisTrigger = 3
//
//          //set checkpoint
//          ent.p.currentCheckpoint = checkpointInThisTrigger
//
//          //change realm and lock invis
//          ent.RemoveFromAllRealms()
//          ent.AddToRealm(checkpointInThisTrigger)
//          ent.p.isPlayerInvisAllowed = false
//        }
//      }
//    })
//  DispatchSpawn(trigger_2)
//
//}
//
//void
//function MovementGym_Surf_Kitsune_lvl2() {
//  // Level Color
//  float rampr = 1.0
//  float rampg = 0.5
//  float rampb = 0.0
//  float darkrampr = 1.0
//  float darkrampg = 0.0
//  float darkrampb = 0.0
//
//  // Props Array
//  array < entity > ClipArray;
//  array < entity > NoGrappleArray;
//  array < entity > NoCollisionArray;
//
//  // Props
//  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_02.rmdl", < -38398.08, -12385.58, 21158.93 > , < 0, -89.9999, 0 > , false, 5000, 4, 1))
//  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_04_corner.rmdl", < -38894.07, -11298.24, 21158.93 > , < 0, 90.0004, 0 > , false, 5000, 4, 1))
//  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_04_corner.rmdl", < -38398.08, -12385.04, 21158.93 > , < 0, 0.0006, 0 > , false, 5000, 4, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36900.43, -12145.51, 20683.48 > , < 0, 0, 49.6068 > , false, 5000, 4, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36644.42, -12145.51, 20683.48 > , < 0, 0, 49.6068 > , false, 5000, 4, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36388.41, -12145.51, 20683.48 > , < 0, 0, 49.6068 > , false, 5000, 4, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36132.4, -12145.51, 20683.48 > , < 0, 0, 49.6068 > , false, 5000, 4, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36132.4, -12311.4, 20488.51 > , < 0, 0, 49.6068 > , false, 5000, 4, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36388.41, -12311.4, 20488.51 > , < 0, 0, 49.6068 > , false, 5000, 4, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36644.42, -12311.4, 20488.51 > , < 0, 0, 49.6068 > , false, 5000, 4, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36900.43, -12311.4, 20488.51 > , < 0, 0, 49.6068 > , false, 5000, 4, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36132.4, -12000.41, 20683.48 > , < 0, -179.9997, 49.6068 > , false, 5000, 4, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36388.41, -12000.41, 20683.48 > , < 0, -179.9997, 49.6068 > , false, 5000, 4, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36644.41, -12000.41, 20683.48 > , < 0, -179.9997, 49.6068 > , false, 5000, 4, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36900.42, -12000.41, 20683.48 > , < 0, -179.9997, 49.6068 > , false, 5000, 4, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36900.43, -11834.51, 20488.51 > , < 0, -179.9997, 49.6068 > , false, 5000, 4, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36644.42, -11834.51, 20488.51 > , < 0, -179.9997, 49.6068 > , false, 5000, 4, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36388.41, -11834.51, 20488.51 > , < 0, -179.9997, 49.6068 > , false, 5000, 4, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36132.4, -11834.51, 20488.51 > , < 0, -179.9997, 49.6068 > , false, 5000, 4, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -38033, -12145.51, 20972.21 > , < 15, 0, 49.6068 > , false, 5000, 4, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37785.71, -12145.51, 20905.95 > , < 15, 0, 49.6068 > , false, 5000, 4, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37538.43, -12145.51, 20839.69 > , < 15, 0, 49.6068 > , false, 5000, 4, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37291.14, -12145.51, 20773.43 > , < 15, 0, 49.6068 > , false, 5000, 4, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37341.6, -12311.4, 20585.1 > , < 15, 0, 49.6068 > , false, 5000, 4, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37588.89, -12311.4, 20651.36 > , < 15, 0, 49.6068 > , false, 5000, 4, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37836.18, -12311.4, 20717.62 > , < 15, 0, 49.6068 > , false, 5000, 4, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -38083.46, -12311.4, 20783.88 > , < 15, 0, 49.6068 > , false, 5000, 4, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37291.14, -12000.41, 20773.43 > , < -15, -179.9996, 49.6067 > , false, 5000, 4, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37538.43, -12000.41, 20839.69 > , < -15, -179.9996, 49.6067 > , false, 5000, 4, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37785.71, -12000.41, 20905.95 > , < -15, -179.9996, 49.6067 > , false, 5000, 4, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -38032.99, -12000.41, 20972.21 > , < -15, -179.9996, 49.6067 > , false, 5000, 4, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -38083.46, -11834.51, 20783.88 > , < -15, -179.9996, 49.6067 > , false, 5000, 4, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37836.18, -11834.51, 20717.62 > , < -15, -179.9996, 49.6067 > , false, 5000, 4, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37588.89, -11834.51, 20651.36 > , < -15, -179.9996, 49.6067 > , false, 5000, 4, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37341.6, -11834.51, 20585.1 > , < -15, -179.9996, 49.6067 > , false, 5000, 4, 1))
//  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_02.rmdl", < -35638.29, -11793.68, 20727.03 > , < 0, 90.0005, 0 > , false, 5000, 4, 1))
//  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_04_corner.rmdl", < -35142.29, -12881.02, 20727.03 > , < 0, -89.9992, 0 > , false, 5000, 4, 1))
//  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_04_corner.rmdl", < -35638.29, -11794.22, 20727.03 > , < 0, -179.9991, 0 > , false, 5000, 4, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -35283.9, -12584.64, 20887 > , < 0, 90.0005, 89.9998 > , false, 5000, 4, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -35283.93, -11379.64, 21526.93 > , < 0, 90.0005, 89.9998 > , false, 5000, 4, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -35283.93, -11379.64, 20887 > , < 0, 90.0005, 89.9998 > , false, 5000, 4, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -35283.92, -12008.65, 20887 > , < 0, 90.0005, 89.9998 > , false, 5000, 4, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -35283.92, -12008.65, 21526.93 > , < 0, 90.0005, 89.9998 > , false, 5000, 4, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -35283.9, -12584.64, 21526.93 > , < 0, 90.0005, 89.9998 > , false, 5000, 4, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -35283.9, -12584.64, 20264.93 > , < 0, 90.0005, 89.9998 > , false, 5000, 4, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -35283.93, -11379.64, 20264.93 > , < 0, 90.0005, 89.9998 > , false, 5000, 4, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -35283.92, -12008.65, 20264.93 > , < 0, 90.0005, 89.9998 > , false, 5000, 4, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/desertlands/desertlands_lobby_double_doorframe_02.rmdl", < -35282.93, -12076.64, 20732.93 > , < 0, 89.9998, 0 > , false, 5000, 4, 1))
//
//  foreach(entity ent in ClipArray) {
//    ent.MakeInvisible()
//    ent.kv.solid = 6
//    ent.kv.CollisionGroup = TRACE_COLLISION_GROUP_PLAYER
//    ent.kv.contents = CONTENTS_PLAYERCLIP
//  }
//
//  //Main Glow
//  foreach(entity ent in NoGrappleArray) {
//    ent.Highlight_SetFunctions(0, 136, false, 136, 3.0, 2, false)
//    ent.Highlight_SetParam(0, 0, < rampr, rampg, rampb > )
//  }
//
//  //Outline Glow
//  foreach(entity ent in NoCollisionArray) {
//    ent.Highlight_SetFunctions(0, 0, false, 136, 3.0, 2, false)
//    ent.Highlight_SetParam(0, 0, < rampr, rampg, rampb > )
//  }
//
//  // Triggers
//  entity trigger_0 = MapEditor_CreateTrigger( < -35062.76, -12078.66, 20781.53 > , < 0, 0, 0 > , 237.05, 50, false)
//  trigger_0.SetEnterCallback(void
//    function (entity trigger, entity ent) {
//      if (IsValid(ent)) {
//        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
//        {
//          ent.SetOrigin( < -38673.36, -14140.26, 21257.53 > ) // change tp location
//          ent.SetAngles( < 0, 0, 0 > )
//
//          //
//          // Checkpoint and timer
//          //
//
//          int previousCheckpoint = 4
//          int checkpointInThisTrigger = 5
//          //show checkpoint msg
//          if(ent.p.currentCheckpoint != checkpointInThisTrigger)
//          	Remote_CallFunction_NonReplay( ent, "MG_Checkpoint_Msg")
//
//          if (ent.p.currentCheckpoint == previousCheckpoint) {
//            //set checkpoint
//            ent.p.currentCheckpoint = checkpointInThisTrigger
//
//            //change realm and lock invis
//            ent.RemoveFromAllRealms()
//            ent.AddToRealm(checkpointInThisTrigger)
//            ent.p.isPlayerInvisAllowed = false
//          }
//        }
//      }
//    })
//  DispatchSpawn(trigger_0)
//
//}
//
//void
//function MovementGym_Surf_Kitsune_lvl3() {
//  // Level Color
//  float rampr = 1.0
//  float rampg = 1.0
//  float rampb = 0.0
//  float darkrampr = 0.25
//  float darkrampg = 0.25
//  float darkrampb = 0.0
//
//  // Props Array
//  array < entity > ClipArray;
//  array < entity > NoClimbArray;
//  array < entity > NoGrappleArray;
//  array < entity > NoCollisionArray;
//
//  // Props
//  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_02.rmdl", < -38403.97, -14437.58, 21208.13 > , < 0, -89.9999, 0 > , false, 5000, 5, 1))
//  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_04_corner.rmdl", < -38899.97, -13350.24, 21208.13 > , < 0, 90.0004, 0 > , false, 5000, 5, 1))
//  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_04_corner.rmdl", < -38403.97, -14437.04, 21208.13 > , < 0, 0.0006, 0 > , false, 5000, 5, 1))
//  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_02.rmdl", < -34630.58, -13845.69, 20840.93 > , < 0, 90.0005, 0 > , false, 5000, 5, 1))
//  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_04_corner.rmdl", < -34134.58, -14933.03, 20840.93 > , < 0, -89.9992, 0 > , false, 5000, 5, 1))
//  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_04_corner.rmdl", < -34630.58, -13846.24, 20840.93 > , < 0, -179.9991, 0 > , false, 5000, 5, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -38106.02, -14214.74, 21031.27 > , < 9.8898, 0, 49.6068 > , false, 5000, 5, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37853.82, -14214.74, 20987.3 > , < 9.8898, 0, 49.6068 > , false, 5000, 5, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37601.61, -14214.74, 20943.33 > , < 9.8898, 0, 49.6068 > , false, 5000, 5, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37349.41, -14214.74, 20899.36 > , < 9.8898, 0, 49.6068 > , false, 5000, 5, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37382.89, -14380.63, 20707.28 > , < 9.8898, 0, 49.6068 > , false, 5000, 5, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37635.1, -14380.63, 20751.25 > , < 9.8898, 0, 49.6068 > , false, 5000, 5, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37887.3, -14380.63, 20795.22 > , < 9.8898, 0, 49.6068 > , false, 5000, 5, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -38139.5, -14380.63, 20839.2 > , < 9.8898, 0, 49.6068 > , false, 5000, 5, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37349.4, -14069.64, 20899.36 > , < -9.8898, -179.9997, 49.6067 > , false, 5000, 5, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37601.61, -14069.63, 20943.33 > , < -9.8898, -179.9997, 49.6067 > , false, 5000, 5, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37853.81, -14069.64, 20987.3 > , < -9.8898, -179.9997, 49.6067 > , false, 5000, 5, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -38106.01, -14069.64, 21031.27 > , < -9.8898, -179.9997, 49.6067 > , false, 5000, 5, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -38139.5, -13903.74, 20839.19 > , < -9.8898, -179.9997, 49.6067 > , false, 5000, 5, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37887.3, -13903.74, 20795.22 > , < -9.8898, -179.9997, 49.6067 > , false, 5000, 5, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37635.1, -13903.74, 20751.25 > , < -9.8898, -179.9997, 49.6067 > , false, 5000, 5, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37382.89, -13903.73, 20707.28 > , < -9.8898, -179.9997, 49.6067 > , false, 5000, 5, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36906.94, -13455.47, 20722.38 > , < -0.0629, -0.202, 49.6047 > , false, 5000, 5, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36650.95, -13456.37, 20722.67 > , < -0.0629, -0.202, 49.6047 > , false, 5000, 5, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36394.94, -13457.27, 20722.95 > , < -0.0629, -0.202, 49.6047 > , false, 5000, 5, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36138.95, -13458.18, 20723.23 > , < -0.0629, -0.202, 49.6047 > , false, 5000, 5, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36139.33, -13624.18, 20528.23 > , < -0.0629, -0.202, 49.6047 > , false, 5000, 5, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36395.32, -13623.28, 20527.95 > , < -0.0629, -0.202, 49.6047 > , false, 5000, 5, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36651.31, -13622.38, 20527.67 > , < -0.0629, -0.202, 49.6047 > , false, 5000, 5, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36907.32, -13621.48, 20527.4 > , < -0.0629, -0.202, 49.6047 > , false, 5000, 5, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35557.4, -14214.74, 20661.04 > , < -0.0148, 0, 49.6068 > , false, 5000, 5, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35301.39, -14214.74, 20661.11 > , < -0.0148, 0, 49.6068 > , false, 5000, 5, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35045.38, -14214.74, 20661.18 > , < -0.0148, 0, 49.6068 > , false, 5000, 5, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34789.38, -14214.74, 20661.24 > , < -0.0148, 0, 49.6068 > , false, 5000, 5, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34789.32, -14380.63, 20466.27 > , < -0.0148, 0, 49.6068 > , false, 5000, 5, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35045.33, -14380.63, 20466.21 > , < -0.0148, 0, 49.6068 > , false, 5000, 5, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35301.34, -14380.63, 20466.14 > , < -0.0148, 0, 49.6068 > , false, 5000, 5, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35557.35, -14380.63, 20466.07 > , < -0.0148, 0, 49.6068 > , false, 5000, 5, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34789.37, -14069.64, 20661.24 > , < 0.0148, -179.9997, 49.6068 > , false, 5000, 5, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35045.38, -14069.63, 20661.18 > , < 0.0148, -179.9997, 49.6068 > , false, 5000, 5, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35301.39, -14069.64, 20661.11 > , < 0.0148, -179.9997, 49.6068 > , false, 5000, 5, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35557.39, -14069.64, 20661.04 > , < 0.0148, -179.9997, 49.6068 > , false, 5000, 5, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35557.35, -13903.74, 20466.07 > , < 0.0148, -179.9997, 49.6068 > , false, 5000, 5, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35301.34, -13903.74, 20466.14 > , < 0.0148, -179.9997, 49.6068 > , false, 5000, 5, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35045.33, -13903.74, 20466.21 > , < 0.0148, -179.9997, 49.6068 > , false, 5000, 5, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34789.32, -13903.73, 20466.27 > , < 0.0148, -179.9997, 49.6068 > , false, 5000, 5, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36139.37, -14832.54, 20722.39 > , < -0.0629, 179.7984, 49.6047 > , false, 5000, 5, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36395.36, -14831.64, 20722.67 > , < -0.0629, 179.7984, 49.6047 > , false, 5000, 5, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36651.37, -14830.74, 20722.95 > , < -0.0629, 179.7984, 49.6047 > , false, 5000, 5, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36907.35, -14829.84, 20723.23 > , < -0.0629, 179.7984, 49.6047 > , false, 5000, 5, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36906.98, -14663.83, 20528.24 > , < -0.0629, 179.7984, 49.6047 > , false, 5000, 5, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36650.98, -14664.73, 20527.96 > , < -0.0629, 179.7984, 49.6047 > , false, 5000, 5, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36395, -14665.63, 20527.68 > , < -0.0629, 179.7984, 49.6047 > , false, 5000, 5, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36138.98, -14666.53, 20527.4 > , < -0.0629, 179.7984, 49.6047 > , false, 5000, 5, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -36413.83, -14177.94, 21248.93 > , < 0.0002, -179.9995, 90 > , false, 5000, 5, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -36413.83, -14177.34, 20630.93 > , < 0.0002, -179.9995, 90 > , false, 5000, 5, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -36656.83, -14177.64, 21248.93 > , < 0.0002, -179.9995, 90 > , false, 5000, 5, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -36656.83, -14177.84, 20630.93 > , < 0.0002, -179.9995, 90 > , false, 5000, 5, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -36656.13, -14104.44, 21248.93 > , < -0.0002, 0.0006, 90 > , false, 5000, 5, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -36413.13, -14104.04, 20630.93 > , < -0.0002, 0.0006, 90 > , false, 5000, 5, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -36656.13, -14104.54, 20630.93 > , < -0.0002, 0.0006, 90 > , false, 5000, 5, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -36413.13, -14104.64, 21248.93 > , < -0.0002, 0.0006, 90 > , false, 5000, 5, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/desertlands/desertlands_lobby_double_doorframe_02.rmdl", < -34281.13, -14141.64, 20844.93 > , < 0, 89.9998, 0 > , false, 5000, 5, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -34278.1, -14635.64, 20682 > , < 0, 90.0005, 89.9998 > , false, 5000, 5, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -34278.13, -13430.64, 21321.93 > , < 0, 90.0005, 89.9998 > , false, 5000, 5, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -34278.13, -13430.64, 20682 > , < 0, 90.0005, 89.9998 > , false, 5000, 5, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -34278.11, -14059.65, 20682 > , < 0, 90.0005, 89.9998 > , false, 5000, 5, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -34278.11, -14059.65, 21321.93 > , < 0, 90.0005, 89.9998 > , false, 5000, 5, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -34278.1, -14635.64, 21321.93 > , < 0, 90.0005, 89.9998 > , false, 5000, 5, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -34278.11, -14059.65, 20051.93 > , < 0, 90.0005, 89.9998 > , false, 5000, 5, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -34278.1, -14635.64, 20051.93 > , < 0, 90.0005, 89.9998 > , false, 5000, 5, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -34278.13, -13430.64, 20051.93 > , < 0, 90.0005, 89.9998 > , false, 5000, 5, 1))
//
//  foreach(entity ent in ClipArray) {
//    ent.MakeInvisible()
//    ent.kv.solid = 6
//    ent.kv.CollisionGroup = TRACE_COLLISION_GROUP_PLAYER
//    ent.kv.contents = CONTENTS_PLAYERCLIP
//  }
//
//  //Secondary Glow
//  foreach(entity ent in NoClimbArray) {
//    ent.Highlight_SetFunctions(0, 136, false, 136, 3.0, 2, false)
//    ent.Highlight_SetParam(0, 0, < darkrampr, darkrampg, darkrampb > )
//  }
//
//  //Main Glow
//  foreach(entity ent in NoGrappleArray) {
//    ent.Highlight_SetFunctions(0, 136, false, 136, 3.0, 2, false)
//    ent.Highlight_SetParam(0, 0, < rampr, rampg, rampb > )
//  }
//
//  //Outline Glow
//  foreach(entity ent in NoCollisionArray) {
//    ent.Highlight_SetFunctions(0, 0, false, 136, 3.0, 2, false)
//    ent.Highlight_SetParam(0, 0, < rampr, rampg, rampb > )
//  }
//
//  // Triggers
//  entity trigger_0 = MapEditor_CreateTrigger( < -34060.95, -14143.66, 20893.53 > , < 0, 0, 0 > , 237.05, 50, false)
//  trigger_0.SetEnterCallback(void
//    function (entity trigger, entity ent) {
//      if (IsValid(ent)) {
//        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
//        {
//          ent.SetOrigin( < -38652.55, -17213.46, 21298.53 > ) // change tp location
//          ent.SetAngles( < 0, 0, 0 > )
//
//          //
//          // Checkpoint and timer
//          //
//
//          int previousCheckpoint = 5
//          int checkpointInThisTrigger = 6
//          //show checkpoint msg
//          if(ent.p.currentCheckpoint != checkpointInThisTrigger)
//          	Remote_CallFunction_NonReplay( ent, "MG_Checkpoint_Msg")
//
//          if (ent.p.currentCheckpoint == previousCheckpoint) {
//            //set checkpoint
//            ent.p.currentCheckpoint = checkpointInThisTrigger
//
//            //change realm and lock invis
//            ent.RemoveFromAllRealms()
//            ent.AddToRealm(checkpointInThisTrigger)
//            ent.p.isPlayerInvisAllowed = false
//          }
//        }
//      }
//    })
//  DispatchSpawn(trigger_0)
//
//}
//
//void
//function MovementGym_Surf_Kitsune_lvl4() {
//  // Level Color
//  float rampr = 0.0
//  float rampg = 1.0
//  float rampb = 0.0
//  float darkrampr = 0.0
//  float darkrampg = 0.25
//  float darkrampb = 0.0
//
//  // Props Array
//  array < entity > ClipArray;
//  array < entity > NoClimbArray;
//  array < entity > NoGrappleArray;
//  array < entity > NoCollisionArray;
//
//  // Props
//  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_02.rmdl", < -38403.97, -17501.58, 21221.73 > , < 0, -89.9999, 0 > , false, 5000, 6, 1))
//  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_04_corner.rmdl", < -38899.97, -16414.24, 21221.73 > , < 0, 90.0004, 0 > , false, 5000, 6, 1))
//  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_04_corner.rmdl", < -38403.97, -17501.04, 21221.73 > , < 0, 0.0006, 0 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33572.2, -18141.58, 19698.87 > , < -0.0629, 179.7984, 49.6047 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33828.15, -18140.68, 19699.15 > , < -0.0629, 179.7984, 49.6047 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33827.85, -17974.67, 19504.11 > , < -0.0629, 179.7984, 49.6047 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33571.8, -17975.57, 19503.85 > , < -0.0629, 179.7984, 49.6047 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -38245.46, -17287.74, 21005.93 > , < 24.8898, 0, 49.6068 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -38013.23, -17287.74, 20898.18 > , < 24.8898, 0, 49.6068 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37781, -17287.74, 20790.43 > , < 24.8898, 0, 49.6068 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37548.77, -17287.74, 20682.68 > , < 24.8898, 0, 49.6068 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37630.83, -17453.63, 20505.82 > , < 24.8898, 0, 49.6068 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37863.06, -17453.63, 20613.57 > , < 24.8898, 0, 49.6068 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -38095.29, -17453.63, 20721.31 > , < 24.8898, 0, 49.6068 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -38327.52, -17453.63, 20829.06 > , < 24.8898, 0, 49.6068 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37548.77, -17142.64, 20682.68 > , < -24.8898, -179.9996, 49.6066 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37781, -17142.63, 20790.43 > , < -24.8898, -179.9996, 49.6066 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -38013.22, -17142.64, 20898.18 > , < -24.8898, -179.9996, 49.6066 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -38245.46, -17142.64, 21005.92 > , < -24.8898, -179.9996, 49.6066 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -38327.52, -16976.74, 20829.06 > , < -24.8898, -179.9996, 49.6066 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -38095.29, -16976.74, 20721.31 > , < -24.8898, -179.9996, 49.6066 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37863.06, -16976.74, 20613.57 > , < -24.8898, -179.9996, 49.6066 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37630.82, -16976.73, 20505.82 > , < -24.8898, -179.9996, 49.6066 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37318.16, -17287.74, 20576.03 > , < 24.8898, 0, 49.6068 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37085.93, -17287.74, 20468.28 > , < 24.8898, 0, 49.6068 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36853.7, -17287.74, 20360.53 > , < 24.8898, 0, 49.6068 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36621.47, -17287.74, 20252.78 > , < 24.8898, 0, 49.6068 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36703.53, -17453.63, 20075.92 > , < 24.8898, 0, 49.6068 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36935.76, -17453.63, 20183.67 > , < 24.8898, 0, 49.6068 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37167.99, -17453.63, 20291.41 > , < 24.8898, 0, 49.6068 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37400.22, -17453.63, 20399.16 > , < 24.8898, 0, 49.6068 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36621.46, -17142.64, 20252.78 > , < -24.8898, -179.9996, 49.6066 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36853.7, -17142.63, 20360.53 > , < -24.8898, -179.9996, 49.6066 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37085.93, -17142.64, 20468.28 > , < -24.8898, -179.9996, 49.6066 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37318.16, -17142.64, 20576.02 > , < -24.8898, -179.9996, 49.6066 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37400.22, -16976.74, 20399.16 > , < -24.8898, -179.9996, 49.6066 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37167.99, -16976.74, 20291.41 > , < -24.8898, -179.9996, 49.6066 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36935.76, -16976.74, 20183.67 > , < -24.8898, -179.9996, 49.6066 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36703.52, -16976.73, 20075.92 > , < -24.8898, -179.9996, 49.6066 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36389.26, -17287.74, 20143.93 > , < 24.8898, 0, 49.6068 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36157.03, -17287.74, 20036.18 > , < 24.8898, 0, 49.6068 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35924.8, -17287.74, 19928.43 > , < 24.8898, 0, 49.6068 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35692.57, -17287.74, 19820.68 > , < 24.8898, 0, 49.6068 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35774.63, -17453.63, 19643.82 > , < 24.8898, 0, 49.6068 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36006.86, -17453.63, 19751.57 > , < 24.8898, 0, 49.6068 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36239.09, -17453.63, 19859.31 > , < 24.8898, 0, 49.6068 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36471.32, -17453.63, 19967.06 > , < 24.8898, 0, 49.6068 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35692.57, -17142.64, 19820.68 > , < -24.8898, -179.9996, 49.6066 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35924.8, -17142.63, 19928.43 > , < -24.8898, -179.9996, 49.6066 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36157.03, -17142.64, 20036.18 > , < -24.8898, -179.9996, 49.6066 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36389.26, -17142.64, 20143.92 > , < -24.8898, -179.9996, 49.6066 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36471.32, -16976.74, 19967.06 > , < -24.8898, -179.9996, 49.6066 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36239.09, -16976.74, 19859.31 > , < -24.8898, -179.9996, 49.6066 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36006.86, -16976.74, 19751.57 > , < -24.8898, -179.9996, 49.6066 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35774.63, -16976.73, 19643.82 > , < -24.8898, -179.9996, 49.6066 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35461.87, -17142.64, 19713.76 > , < -24.8898, -179.9996, 49.6066 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35543.95, -16976.64, 19536.87 > , < -24.8898, -179.9996, 49.6066 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35311.72, -16976.64, 19429.12 > , < -24.8898, -179.9996, 49.6066 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35311.72, -17453.64, 19429.12 > , < 24.8898, 0, 49.6068 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35229.65, -17142.64, 19606.01 > , < -24.8898, -179.9996, 49.6066 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35461.87, -17287.64, 19713.76 > , < 24.8898, 0, 49.6068 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35229.65, -17287.64, 19606.01 > , < 24.8898, 0, 49.6068 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35543.95, -17453.64, 19536.87 > , < 24.8898, 0, 49.6068 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33827.68, -16287.07, 19698.87 > , < -0.0629, -0.2013, 49.6047 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33571.73, -16287.97, 19699.15 > , < -0.0629, -0.2013, 49.6047 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33572.03, -16453.97, 19504.12 > , < -0.0629, -0.2013, 49.6047 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33828.07, -16453.07, 19503.85 > , < -0.0629, -0.2013, 49.6047 > , false, 5000, 6, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -33785.13, -17603.14, 18877.93 > , < 0, -179.9997, 89.9998 > , false, 5000, 6, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -33785.13, -17603.64, 19500.25 > , < 0, -179.9997, 89.9998 > , false, 5000, 6, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -33785.13, -17603.14, 20107.57 > , < 0, -179.9997, 89.9998 > , false, 5000, 6, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -33785.13, -17603.64, 20715.93 > , < 0, -179.9997, 89.9998 > , false, 5000, 6, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -33785.13, -17603.14, 21326.93 > , < 0, -179.9997, 89.9998 > , false, 5000, 6, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -34176.63, -17210.64, 18877.93 > , < 0, 90.0005, 89.9998 > , false, 5000, 6, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -34176.63, -17210.64, 21326.93 > , < 0, 90.0005, 89.9999 > , false, 5000, 6, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -34176.13, -17210.64, 19500.25 > , < 0, 90.0005, 89.9999 > , false, 5000, 6, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -34176.63, -17210.64, 20107.57 > , < 0, 90.0005, 89.9999 > , false, 5000, 6, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -33782.13, -16818.64, 19500.25 > , < 0, 0.0007, 89.9999 > , false, 5000, 6, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -33782.13, -16818.14, 18877.93 > , < 0, 0.0007, 89.9998 > , false, 5000, 6, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -33782.13, -16818.14, 21326.93 > , < 0, 0.0007, 89.9999 > , false, 5000, 6, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -33782.13, -16818.63, 20715.93 > , < 0, 0.0007, 89.9999 > , false, 5000, 6, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -33782.13, -16818.14, 20107.57 > , < 0, 0.0007, 89.9999 > , false, 5000, 6, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -33388.13, -17210.64, 19500.25 > , < 0, -89.9992, 89.9999 > , false, 5000, 6, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -33388.63, -17210.64, 21326.93 > , < 0, -89.9992, 89.9999 > , false, 5000, 6, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -33388.63, -17210.63, 18877.93 > , < 0, -89.9992, 89.9998 > , false, 5000, 6, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -33388.13, -17210.64, 20715.93 > , < 0, -89.9992, 89.9999 > , false, 5000, 6, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -33388.63, -17210.64, 20107.57 > , < 0, -89.9992, 89.9999 > , false, 5000, 6, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -34176.13, -17210.64, 20709.93 > , < 0, 90.0005, 89.9999 > , false, 5000, 6, 1))
//  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_02.rmdl", < -32677.38, -16909.7, 19845.93 > , < 0, 90.0005, 0 > , false, 5000, 6, 1))
//  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_04_corner.rmdl", < -32181.38, -17997.04, 19845.93 > , < 0, -89.9992, 0 > , false, 5000, 6, 1))
//  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_04_corner.rmdl", < -32677.38, -16910.24, 19845.93 > , < 0, -179.9991, 0 > , false, 5000, 6, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/desertlands/desertlands_lobby_double_doorframe_02.rmdl", < -32327.13, -17213.64, 19847.93 > , < 0, 89.9998, 0 > , false, 5000, 6, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -32323.1, -17985.63, 20743 > , < 0, 90.0005, 89.9998 > , false, 5000, 6, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -32323.13, -16497.64, 20743 > , < 0, 90.0005, 89.9998 > , false, 5000, 6, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -32323.11, -17219.64, 20743 > , < 0, 90.0005, 89.9998 > , false, 5000, 6, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -32323.11, -17219.64, 20186.87 > , < 0, 90.0005, 89.9998 > , false, 5000, 6, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -32323.11, -17219.64, 19563.87 > , < 0, 90.0005, 89.9998 > , false, 5000, 6, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -32323.13, -16497.64, 18923.93 > , < 0, 90.0005, 89.9998 > , false, 5000, 6, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -32323.11, -17219.64, 18923.93 > , < 0, 90.0005, 89.9998 > , false, 5000, 6, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -32323.13, -16497.64, 20186.87 > , < 0, 90.0005, 89.9998 > , false, 5000, 6, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -32323.1, -17985.63, 20186.87 > , < 0, 90.0005, 89.9998 > , false, 5000, 6, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -32323.1, -17985.63, 18923.93 > , < 0, 90.0005, 89.9998 > , false, 5000, 6, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -32323.13, -16497.64, 19563.87 > , < 0, 90.0005, 89.9998 > , false, 5000, 6, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -32323.1, -17985.63, 19563.87 > , < 0, 90.0005, 89.9998 > , false, 5000, 6, 1))
//
//  foreach(entity ent in ClipArray) {
//    ent.MakeInvisible()
//    ent.kv.solid = 6
//    ent.kv.CollisionGroup = TRACE_COLLISION_GROUP_PLAYER
//    ent.kv.contents = CONTENTS_PLAYERCLIP
//  }
//
//  //Secondary Glow
//  foreach(entity ent in NoClimbArray) {
//    ent.Highlight_SetFunctions(0, 136, false, 136, 3.0, 2, false)
//    ent.Highlight_SetParam(0, 0, < darkrampr, darkrampg, darkrampb > )
//  }
//
//  //Main Glow
//  foreach(entity ent in NoGrappleArray) {
//    ent.Highlight_SetFunctions(0, 136, false, 136, 3.0, 2, false)
//    ent.Highlight_SetParam(0, 0, < rampr, rampg, rampb > )
//  }
//
//  //Outline Glow
//  foreach(entity ent in NoCollisionArray) {
//    ent.Highlight_SetFunctions(0, 0, false, 136, 3.0, 2, false)
//    ent.Highlight_SetParam(0, 0, < rampr, rampg, rampb > )
//  }
//
//  // Triggers
//  entity trigger_0 = MapEditor_CreateTrigger( < -32106.95, -17215.66, 19896.53 > , < 0, 0, 0 > , 237.05, 50, false)
//  trigger_0.SetEnterCallback(void
//    function (entity trigger, entity ent) {
//      if (IsValid(ent)) {
//        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
//        {
//          ent.SetOrigin( < -38601.55, -20285.46, 21255.23 > ) // change tp location
//          ent.SetAngles( < 0, 0, 0 > )
//
//          //
//          // Checkpoint and timer
//          //
//
//          int previousCheckpoint = 6
//          int checkpointInThisTrigger = 7
//          //show checkpoint msg
//          if(ent.p.currentCheckpoint != checkpointInThisTrigger)
//          	Remote_CallFunction_NonReplay( ent, "MG_Checkpoint_Msg")
//
//          if (ent.p.currentCheckpoint == previousCheckpoint) {
//            //set checkpoint
//            ent.p.currentCheckpoint = checkpointInThisTrigger
//
//            //change realm and lock invis
//            ent.RemoveFromAllRealms()
//            ent.AddToRealm(checkpointInThisTrigger)
//            ent.p.isPlayerInvisAllowed = false
//          }
//        }
//      }
//    })
//  DispatchSpawn(trigger_0)
//
//}
//
//void
//function MovementGym_Surf_Kitsune_lvl5() {
//  // Level Color
//  float rampr = 0.5
//  float rampg = 0.5
//  float rampb = 1.0
//  float darkrampr = 0.13
//  float darkrampg = 0.13
//  float darkrampb = 0.25
//
//  // Props Array
//  array < entity > ClipArray;
//  array < entity > NoClimbArray;
//  array < entity > NoGrappleArray;
//  array < entity > NoCollisionArray;
//
//  // Props
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -32175.11, -20273.64, 20186.87 > , < 0, 90.0005, 89.9998 > , false, 5000, 7, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -32175.11, -20273.64, 19563.87 > , < 0, 90.0005, 89.9998 > , false, 5000, 7, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -32175.13, -19551.64, 18923.93 > , < 0, 90.0005, 89.9998 > , false, 5000, 7, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -32175.11, -20273.64, 18923.93 > , < 0, 90.0005, 89.9998 > , false, 5000, 7, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -32175.13, -19551.64, 20186.87 > , < 0, 90.0005, 89.9998 > , false, 5000, 7, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -32175.1, -21039.63, 20186.87 > , < 0, 90.0005, 89.9998 > , false, 5000, 7, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -32175.1, -21039.63, 18923.93 > , < 0, 90.0005, 89.9998 > , false, 5000, 7, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -32175.13, -19551.64, 19563.87 > , < 0, 90.0005, 89.9998 > , false, 5000, 7, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -32175.1, -21039.63, 19563.87 > , < 0, 90.0005, 89.9998 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -38214.46, -20358.74, 20952.93 > , < 24.8898, 0, 49.6068 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37982.23, -20358.74, 20845.18 > , < 24.8898, 0, 49.6068 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37750, -20358.74, 20737.43 > , < 24.8898, 0, 49.6068 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37517.77, -20358.74, 20629.68 > , < 24.8898, 0, 49.6068 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37599.83, -20524.63, 20452.82 > , < 24.8898, 0, 49.6068 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37832.06, -20524.63, 20560.57 > , < 24.8898, 0, 49.6068 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -38064.29, -20524.63, 20668.31 > , < 24.8898, 0, 49.6068 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -38296.52, -20524.63, 20776.06 > , < 24.8898, 0, 49.6068 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37517.77, -20213.64, 20629.68 > , < -24.8898, -179.9996, 49.6066 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37750, -20213.63, 20737.43 > , < -24.8898, -179.9996, 49.6066 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37982.22, -20213.64, 20845.18 > , < -24.8898, -179.9996, 49.6066 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -38214.46, -20213.64, 20952.92 > , < -24.8898, -179.9996, 49.6066 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -38296.52, -20047.74, 20776.06 > , < -24.8898, -179.9996, 49.6066 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -38064.29, -20047.74, 20668.31 > , < -24.8898, -179.9996, 49.6066 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37832.06, -20047.74, 20560.57 > , < -24.8898, -179.9996, 49.6066 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37599.82, -20047.73, 20452.82 > , < -24.8898, -179.9996, 49.6066 > , false, 5000, 7, 1))
//  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_02.rmdl", < -38403.97, -20572.58, 21124.73 > , < 0, -89.9999, 0 > , false, 5000, 7, 1))
//  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_04_corner.rmdl", < -38899.97, -19485.24, 21124.73 > , < 0, 90.0004, 0 > , false, 5000, 7, 1))
//  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_04_corner.rmdl", < -38403.97, -20572.04, 21124.73 > , < 0, 0.0006, 0 > , false, 5000, 7, 1))
//  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_02.rmdl", < -32519.98, -19980.68, 19399.93 > , < 0, 90.0005, 0 > , false, 5000, 7, 1))
//  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_04_corner.rmdl", < -32023.98, -21068.02, 19399.93 > , < 0, -89.9992, 0 > , false, 5000, 7, 1))
//  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_04_corner.rmdl", < -32519.98, -19981.23, 19399.93 > , < 0, -179.9991, 0 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/desertlands/desertlands_lobby_double_doorframe_02.rmdl", < -32169.73, -20284.62, 19401.93 > , < 0, 89.9998, 0 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37216.8, -20358.74, 20486.96 > , < 15.1809, 0, 49.6068 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36969.72, -20358.74, 20419.92 > , < 15.1809, 0, 49.6068 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36722.65, -20358.74, 20352.88 > , < 15.1809, 0, 49.6068 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36475.57, -20358.74, 20285.84 > , < 15.1809, 0, 49.6068 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36526.63, -20524.63, 20097.67 > , < 15.1809, 0, 49.6068 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36773.7, -20524.63, 20164.71 > , < 15.1809, 0, 49.6068 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37020.78, -20524.63, 20231.75 > , < 15.1809, 0, 49.6068 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37267.86, -20524.63, 20298.79 > , < 15.1809, 0, 49.6068 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36475.57, -20213.64, 20285.84 > , < -15.1809, -179.9996, 49.6067 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36722.65, -20213.63, 20352.88 > , < -15.1809, -179.9996, 49.6067 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36969.72, -20213.64, 20419.92 > , < -15.1809, -179.9996, 49.6067 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37216.79, -20213.64, 20486.96 > , < -15.1809, -179.9996, 49.6067 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37267.85, -20047.74, 20298.79 > , < -15.1809, -179.9996, 49.6067 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37020.78, -20047.74, 20231.75 > , < -15.1809, -179.9996, 49.6067 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36773.7, -20047.74, 20164.71 > , < -15.1809, -179.9996, 49.6067 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36526.63, -20047.73, 20097.67 > , < -15.1809, -179.9996, 49.6067 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35079.46, -20358.74, 20184.93 > , < 24.8898, 0, 49.6068 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34847.23, -20358.74, 20077.18 > , < 24.8898, 0, 49.6068 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34615, -20358.74, 19969.43 > , < 24.8898, 0, 49.6068 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34382.77, -20358.74, 19861.68 > , < 24.8898, 0, 49.6068 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34464.83, -20524.63, 19684.82 > , < 24.8898, 0, 49.6068 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34697.06, -20524.63, 19792.57 > , < 24.8898, 0, 49.6068 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34929.29, -20524.63, 19900.31 > , < 24.8898, 0, 49.6068 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35161.52, -20524.63, 20008.06 > , < 24.8898, 0, 49.6068 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34382.77, -20213.64, 19861.68 > , < -24.8898, -179.9996, 49.6066 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34615, -20213.63, 19969.43 > , < -24.8898, -179.9996, 49.6066 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34847.23, -20213.64, 20077.18 > , < -24.8898, -179.9996, 49.6066 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35079.46, -20213.64, 20184.92 > , < -24.8898, -179.9996, 49.6066 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35161.52, -20047.74, 20008.06 > , < -24.8898, -179.9996, 49.6066 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34929.29, -20047.74, 19900.31 > , < -24.8898, -179.9996, 49.6066 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34697.06, -20047.74, 19792.57 > , < -24.8898, -179.9996, 49.6066 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34464.82, -20047.73, 19684.82 > , < -24.8898, -179.9996, 49.6066 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34081.8, -20358.74, 19718.96 > , < 15.1809, 0, 49.6068 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33834.72, -20358.74, 19651.92 > , < 15.1809, 0, 49.6068 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33587.65, -20358.74, 19584.88 > , < 15.1809, 0, 49.6068 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33340.57, -20358.74, 19517.84 > , < 15.1809, 0, 49.6068 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33391.63, -20524.63, 19329.67 > , < 15.1809, 0, 49.6068 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33638.7, -20524.63, 19396.71 > , < 15.1809, 0, 49.6068 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33885.78, -20524.63, 19463.75 > , < 15.1809, 0, 49.6068 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34132.86, -20524.63, 19530.79 > , < 15.1809, 0, 49.6068 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33340.57, -20213.64, 19517.84 > , < -15.1809, -179.9996, 49.6067 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33587.65, -20213.63, 19584.88 > , < -15.1809, -179.9996, 49.6067 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33834.72, -20213.64, 19651.92 > , < -15.1809, -179.9996, 49.6067 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34081.79, -20213.64, 19718.96 > , < -15.1809, -179.9996, 49.6067 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34132.85, -20047.74, 19530.79 > , < -15.1809, -179.9996, 49.6067 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33885.78, -20047.74, 19463.75 > , < -15.1809, -179.9996, 49.6067 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33638.7, -20047.74, 19396.71 > , < -15.1809, -179.9996, 49.6067 > , false, 5000, 7, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33391.63, -20047.73, 19329.67 > , < -15.1809, -179.9996, 49.6067 > , false, 5000, 7, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35766.12, -21183.64, 20078.65 > , < 0, -89.9999, 90 > , false, 5000, 7, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35766.12, -21183.64, 20334.93 > , < 0, -89.9999, 90 > , false, 5000, 7, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35782.12, -19398.04, 20078.65 > , < -0.0001, 90, 90 > , false, 5000, 7, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35782.12, -19398.04, 20334.93 > , < -0.0001, 90, 90 > , false, 5000, 7, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -35790.13, -19595.64, 20787.93 > , < 0, 90.0005, 89.9999 > , false, 5000, 7, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -35790.13, -20984.14, 20787.93 > , < 0, 90.0005, 89.9999 > , false, 5000, 7, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -35789.83, -19595.64, 19613.93 > , < 0, 90.0005, 89.9999 > , false, 5000, 7, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -35789.83, -20984.14, 19613.93 > , < 0, 90.0005, 89.9999 > , false, 5000, 7, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -35788.13, -20290.64, 20219.93 > , < 0, 90.0005, 89.9999 > , false, 5000, 7, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -35786.23, -20290.64, 20787.93 > , < 0, 90.0005, 89.9999 > , false, 5000, 7, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -35786.13, -20290.64, 19613.93 > , < 0, 90.0005, 89.9999 > , false, 5000, 7, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33144.12, -21183.64, 19512.65 > , < 0, -89.9999, 90 > , false, 5000, 7, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33144.12, -21183.64, 19768.93 > , < 0, -89.9999, 90 > , false, 5000, 7, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33160.12, -19398.04, 19512.65 > , < -0.0001, 90, 90 > , false, 5000, 7, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33160.12, -19398.04, 19768.93 > , < -0.0001, 90, 90 > , false, 5000, 7, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -33168.13, -19595.64, 20221.93 > , < 0, 90.0005, 89.9999 > , false, 5000, 7, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -33168.13, -20984.14, 20221.93 > , < 0, 90.0005, 89.9999 > , false, 5000, 7, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -33167.83, -19595.64, 19047.93 > , < 0, 90.0005, 89.9999 > , false, 5000, 7, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -33167.83, -20984.14, 19047.93 > , < 0, 90.0005, 89.9999 > , false, 5000, 7, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -33166.13, -20290.64, 19653.93 > , < 0, 90.0005, 89.9999 > , false, 5000, 7, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -33164.23, -20290.64, 20221.93 > , < 0, 90.0005, 89.9999 > , false, 5000, 7, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -33164.13, -20290.64, 19047.93 > , < 0, 90.0005, 89.9999 > , false, 5000, 7, 1))
//
//  foreach(entity ent in ClipArray) {
//    ent.MakeInvisible()
//    ent.kv.solid = 6
//    ent.kv.CollisionGroup = TRACE_COLLISION_GROUP_PLAYER
//    ent.kv.contents = CONTENTS_PLAYERCLIP
//  }
//
//  //Secondary Glow
//  foreach(entity ent in NoClimbArray) {
//    ent.Highlight_SetFunctions(0, 136, false, 136, 3.0, 2, false)
//    ent.Highlight_SetParam(0, 0, < darkrampr, darkrampg, darkrampb > )
//  }
//
//  //Main Glow
//  foreach(entity ent in NoGrappleArray) {
//    ent.Highlight_SetFunctions(0, 136, false, 136, 3.0, 2, false)
//    ent.Highlight_SetParam(0, 0, < rampr, rampg, rampb > )
//  }
//
//  //Outline Glow
//  foreach(entity ent in NoCollisionArray) {
//    ent.Highlight_SetFunctions(0, 0, false, 136, 3.0, 2, false)
//    ent.Highlight_SetParam(0, 0, < rampr, rampg, rampb > )
//  }
//
//  // Triggers
//  entity trigger_0 = MapEditor_CreateTrigger( < -31949.55, -20286.64, 19450.53 > , < 0, 0, 0 > , 237.05, 50, false)
//  trigger_0.SetEnterCallback(void
//    function (entity trigger, entity ent) {
//      if (IsValid(ent)) {
//        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
//        {
//          ent.SetOrigin( < -38357.36, -24034.64, 21182.13 > ) // change tp location
//          ent.SetAngles( < 0, 0, 0 > )
//
//          //
//          // Checkpoint and timer
//          //
//
//          int previousCheckpoint = 7
//          int checkpointInThisTrigger = 8
//          //show checkpoint msg
//          if(ent.p.currentCheckpoint != checkpointInThisTrigger)
//          	Remote_CallFunction_NonReplay( ent, "MG_Checkpoint_Msg")
//
//          if (ent.p.currentCheckpoint == previousCheckpoint) {
//            //set checkpoint
//            ent.p.currentCheckpoint = checkpointInThisTrigger
//
//            //change realm and lock invis
//            ent.RemoveFromAllRealms()
//            ent.AddToRealm(checkpointInThisTrigger)
//            ent.p.isPlayerInvisAllowed = false
//          }
//        }
//      }
//    })
//  DispatchSpawn(trigger_0)
//
//}
//
//void
//function MovementGym_Surf_Kitsune_lvl6() {
//  // Level Color
//  float rampr = 0.0
//  float rampg = 0.0
//  float rampb = 1.0
//  float darkrampr = 0.0
//  float darkrampg = 0.0
//  float darkrampb = 0.1
//
//  // Props Array
//  array < entity > ClipArray;
//  array < entity > NoClimbArray;
//  array < entity > NoGrappleArray;
//  array < entity > NoCollisionArray;
//
//  // Props
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -32323.13, -25048.64, 20372.93 > , < 0, 0.0005, 89.9999 > , false, 5000, 8, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -33711.63, -25048.64, 20372.93 > , < 0, 0.0005, 89.9999 > , false, 5000, 8, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -32323.13, -25048.94, 19198.93 > , < 0, 0.0005, 89.9999 > , false, 5000, 8, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -33711.63, -25048.94, 19198.93 > , < 0, 0.0005, 89.9999 > , false, 5000, 8, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -32323.13, -25050.64, 19804.93 > , < 0, 0.0005, 89.9999 > , false, 5000, 8, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -33018.13, -25052.54, 20372.93 > , < 0, 0.0005, 89.9999 > , false, 5000, 8, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -33018.13, -25052.64, 19198.93 > , < 0, 0.0005, 89.9999 > , false, 5000, 8, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -33711.63, -25050.64, 19804.93 > , < 0, 0.0005, 89.9999 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37927.64, -24105.34, 20811.01 > , < 15.2464, 0, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37680.64, -24105.34, 20743.69 > , < 15.2464, 0, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37433.64, -24105.34, 20676.37 > , < 15.2464, 0, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37186.64, -24105.34, 20609.04 > , < 15.2464, 0, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37237.93, -24271.23, 20420.93 > , < 15.2464, 0, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37484.92, -24271.23, 20488.26 > , < 15.2464, 0, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37731.92, -24271.23, 20555.58 > , < 15.2464, 0, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37978.92, -24271.23, 20622.9 > , < 15.2464, 0, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37186.64, -23960.24, 20609.04 > , < -15.2464, -179.9996, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37433.64, -23960.23, 20676.37 > , < -15.2464, -179.9996, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37680.64, -23960.23, 20743.69 > , < -15.2464, -179.9996, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37927.64, -23960.24, 20811.01 > , < -15.2464, -179.9996, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37978.91, -23794.34, 20622.9 > , < -15.2464, -179.9996, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37731.92, -23794.34, 20555.58 > , < -15.2464, -179.9996, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37484.92, -23794.34, 20488.26 > , < -15.2464, -179.9996, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37237.92, -23794.33, 20420.93 > , < -15.2464, -179.9996, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36941.3, -23960.24, 20542.27 > , < -15.2464, -179.9996, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36992.58, -23794.24, 20354.14 > , < -15.2464, -179.9996, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36745.59, -23794.24, 20286.82 > , < -15.2464, -179.9996, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36745.59, -24271.24, 20286.82 > , < 15.2464, 0, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36694.31, -23960.24, 20474.95 > , < -15.2464, -179.9996, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36694.31, -24105.24, 20474.95 > , < 15.2464, 0, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36992.6, -24271.24, 20354.14 > , < 15.2464, 0, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36941.32, -24105.24, 20542.28 > , < 15.2464, 0, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36447.31, -24105.24, 20407.63 > , < 15.2464, 0, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36498.59, -24271.24, 20219.49 > , < 15.2464, 0, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36200.31, -24105.24, 20340.3 > , < 15.2464, 0, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36251.59, -24271.24, 20152.17 > , < 15.2464, 0, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35953.31, -24105.24, 20272.98 > , < 15.2464, 0, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36004.59, -24271.24, 20084.85 > , < 15.2464, 0, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36447.31, -23960.23, 20407.63 > , < -15.2464, -179.9996, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36498.59, -23794.23, 20219.49 > , < -15.2464, -179.9996, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36200.31, -23960.23, 20340.31 > , < -15.2464, -179.9996, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36251.59, -23794.23, 20152.17 > , < -15.2464, -179.9996, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35953.31, -23960.23, 20272.98 > , < -15.2464, -179.9996, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36004.59, -23794.23, 20084.84 > , < -15.2464, -179.9996, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33732, -23960.22, 19667.54 > , < -15.2464, -179.9996, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33783.27, -23794.22, 19479.4 > , < -15.2464, -179.9996, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33979, -23960.22, 19734.86 > , < -15.2464, -179.9996, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34030.27, -23794.22, 19546.72 > , < -15.2464, -179.9996, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34226, -23960.22, 19802.18 > , < -15.2464, -179.9996, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34277.28, -23794.22, 19614.04 > , < -15.2464, -179.9996, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34473, -23960.22, 19869.51 > , < -15.2464, -179.9996, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34524.28, -23794.22, 19681.37 > , < -15.2464, -179.9996, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34719.99, -23960.22, 19936.83 > , < -15.2464, -179.9996, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34771.27, -23794.22, 19748.69 > , < -15.2464, -179.9996, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34965.34, -23960.22, 20003.6 > , < -15.2464, -179.9996, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35016.61, -23794.32, 19815.48 > , < -15.2464, -179.9996, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35212.34, -23960.22, 20070.92 > , < -15.2464, -179.9996, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35263.61, -23794.33, 19882.81 > , < -15.2464, -179.9996, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35459.34, -23960.22, 20138.24 > , < -15.2464, -179.9996, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35510.61, -23794.32, 19950.13 > , < -15.2464, -179.9996, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35757.6, -23794.33, 20017.45 > , < -15.2464, -179.9996, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35706.33, -23960.22, 20205.56 > , < -15.2464, -179.9996, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35706.34, -24105.34, 20205.57 > , < 15.2464, 0, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35459.34, -24105.34, 20138.24 > , < 15.2464, 0, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35212.34, -24105.34, 20070.92 > , < 15.2464, 0, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34965.34, -24105.34, 20003.6 > , < 15.2464, 0, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34720.01, -24105.24, 19936.83 > , < 15.2464, 0, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34473, -24105.24, 19869.51 > , < 15.2464, 0, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34226, -24105.24, 19802.18 > , < 15.2464, 0, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33979, -24105.24, 19734.86 > , < 15.2464, 0, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33732, -24105.24, 19667.54 > , < 15.2464, 0, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33783.28, -24271.24, 19479.4 > , < 15.2464, 0, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34030.27, -24271.24, 19546.72 > , < 15.2464, 0, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34277.28, -24271.24, 19614.04 > , < 15.2464, 0, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34524.28, -24271.24, 19681.37 > , < 15.2464, 0, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34771.29, -24271.24, 19748.7 > , < 15.2464, 0, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35016.62, -24271.23, 19815.49 > , < 15.2464, 0, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35263.61, -24271.23, 19882.81 > , < 15.2464, 0, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35510.61, -24271.23, 19950.13 > , < 15.2464, 0, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35757.61, -24271.23, 20017.46 > , < 15.2464, 0, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33484.99, -23960.21, 19600.21 > , < -15.2464, -179.9996, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33536.27, -23794.21, 19412.07 > , < -15.2464, -179.9996, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33485, -24105.24, 19600.21 > , < 15.2464, 0, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33536.27, -24271.24, 19412.07 > , < 15.2464, 0, 49.6068 > , false, 5000, 8, 1))
//  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_02.rmdl", < -38120.97, -24335.58, 21124.73 > , < 0, -89.9999, 0 > , false, 5000, 8, 1))
//  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_04_corner.rmdl", < -38616.97, -23248.24, 21124.73 > , < 0, 90.0004, 0 > , false, 5000, 8, 1))
//  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_04_corner.rmdl", < -38120.97, -24335.04, 21124.73 > , < 0, 0.0006, 0 > , false, 5000, 8, 1))
//  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_02.rmdl", < -39312.28, -28886.59, 19174.93 > , < 0, -89.9995, 0 > , false, 5000, 8, 1))
//  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_04_corner.rmdl", < -39808.28, -27799.25, 19174.93 > , < 0, 90.0008, 0 > , false, 5000, 8, 1))
//  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_04_corner.rmdl", < -39312.28, -28886.05, 19174.93 > , < 0, 0.0009, 0 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/desertlands/desertlands_lobby_double_doorframe_02.rmdl", < -39662.53, -28582.65, 19176.93 > , < 0, -90.0002, 0 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33087.45, -25842.32, 19519.34 > , < 0, -90, 49.3604 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33087.45, -26098.34, 19519.34 > , < 0, -90, 49.3604 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33087.45, -26354.34, 19519.34 > , < 0, -90, 49.3604 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33087.45, -26610.35, 19519.34 > , < 0, -90, 49.3604 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33254.18, -26610.35, 19325.08 > , < 0, -90, 49.3604 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33254.18, -26354.34, 19325.08 > , < 0, -90, 49.3604 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33254.18, -26098.34, 19325.08 > , < 0, -90, 49.3604 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33254.18, -25842.32, 19325.08 > , < 0, -90, 49.3604 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -32942.35, -26610.36, 19518.71 > , < 0, 90.0004, 49.8531 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -32942.35, -26354.34, 19518.71 > , < 0, 90.0004, 49.8531 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -32942.35, -26098.34, 19518.71 > , < 0, 90.0004, 49.8531 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -32942.35, -25842.33, 19518.71 > , < 0, 90.0004, 49.8531 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -32777.29, -25842.33, 19323.03 > , < 0, 90.0004, 49.8531 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -32777.29, -26098.34, 19323.03 > , < 0, 90.0004, 49.8531 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -32777.29, -26354.34, 19323.03 > , < 0, 90.0004, 49.8531 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -32777.29, -26610.36, 19323.03 > , < 0, 90.0004, 49.8531 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33022.55, -28501.23, 19700.02 > , < 15.2464, -179.9997, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33269.55, -28501.23, 19632.69 > , < 15.2464, -179.9997, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33516.55, -28501.23, 19565.37 > , < 15.2464, -179.9997, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33763.54, -28501.23, 19498.05 > , < 15.2464, -179.9997, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33712.28, -28335.34, 19309.94 > , < 15.2464, -179.9997, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33465.29, -28335.34, 19377.26 > , < 15.2464, -179.9997, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33218.29, -28335.33, 19444.58 > , < 15.2464, -179.9997, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -32971.28, -28335.33, 19511.91 > , < 15.2464, -179.9997, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33763.55, -28646.33, 19498.05 > , < -15.2464, 0.0006, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33516.55, -28646.33, 19565.37 > , < -15.2464, 0.0006, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33269.55, -28646.33, 19632.69 > , < -15.2464, 0.0006, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33022.55, -28646.33, 19700.02 > , < -15.2464, 0.0006, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -32971.29, -28812.22, 19511.9 > , < -15.2464, 0.0006, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33218.29, -28812.23, 19444.58 > , < -15.2464, 0.0006, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33465.29, -28812.23, 19377.26 > , < -15.2464, 0.0006, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33712.28, -28812.23, 19309.94 > , < -15.2464, 0.0006, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34008.9, -28646.33, 19431.28 > , < -15.2464, 0.0006, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33957.62, -28812.33, 19243.14 > , < -15.2464, 0.0006, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34204.61, -28812.33, 19175.82 > , < -15.2464, 0.0006, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34204.61, -28335.33, 19175.82 > , < 15.2464, -179.9997, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34255.89, -28646.33, 19363.96 > , < -15.2464, 0.0006, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34255.89, -28501.33, 19363.96 > , < 15.2464, -179.9997, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33957.6, -28335.33, 19243.15 > , < 15.2464, -179.9997, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34008.89, -28501.33, 19431.28 > , < 15.2464, -179.9997, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34502.89, -28501.34, 19296.63 > , < 15.2464, -179.9997, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34451.61, -28335.34, 19108.5 > , < 15.2464, -179.9997, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34749.89, -28501.34, 19229.31 > , < 15.2464, -179.9997, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34698.61, -28335.34, 19041.17 > , < 15.2464, -179.9997, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34996.89, -28501.34, 19161.99 > , < 15.2464, -179.9997, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34945.61, -28335.34, 18973.85 > , < 15.2464, -179.9997, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34502.89, -28646.34, 19296.63 > , < -15.2464, 0.0006, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34451.61, -28812.34, 19108.5 > , < -15.2464, 0.0006, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34749.89, -28646.34, 19229.31 > , < -15.2464, 0.0006, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34698.61, -28812.34, 19041.17 > , < -15.2464, 0.0006, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34996.89, -28646.34, 19161.99 > , < -15.2464, 0.0006, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34945.61, -28812.34, 18973.85 > , < -15.2464, 0.0006, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37218.2, -28646.37, 18556.54 > , < -15.2464, 0.0006, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37166.93, -28812.37, 18368.4 > , < -15.2464, 0.0006, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36971.2, -28646.37, 18623.86 > , < -15.2464, 0.0006, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36919.92, -28812.37, 18435.72 > , < -15.2464, 0.0006, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36724.2, -28646.36, 18691.19 > , < -15.2464, 0.0006, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36672.92, -28812.36, 18503.05 > , < -15.2464, 0.0006, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36477.2, -28646.36, 18758.51 > , < -15.2464, 0.0006, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36425.92, -28812.36, 18570.37 > , < -15.2464, 0.0006, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36230.21, -28646.36, 18825.83 > , < -15.2464, 0.0006, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36178.93, -28812.36, 18637.69 > , < -15.2464, 0.0006, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35984.86, -28646.36, 18892.6 > , < -15.2464, 0.0006, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35933.59, -28812.26, 18704.49 > , < -15.2464, 0.0006, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35737.86, -28646.36, 18959.92 > , < -15.2464, 0.0006, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35686.59, -28812.25, 18771.81 > , < -15.2464, 0.0006, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35490.86, -28646.36, 19027.25 > , < -15.2464, 0.0006, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35439.59, -28812.25, 18839.13 > , < -15.2464, 0.0006, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35192.6, -28812.25, 18906.46 > , < -15.2464, 0.0006, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35243.87, -28646.35, 19094.57 > , < -15.2464, 0.0006, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35243.86, -28501.24, 19094.57 > , < 15.2464, -179.9997, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35490.86, -28501.24, 19027.25 > , < 15.2464, -179.9997, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35737.86, -28501.24, 18959.92 > , < 15.2464, -179.9997, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35984.87, -28501.24, 18892.6 > , < 15.2464, -179.9997, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36230.2, -28501.34, 18825.84 > , < 15.2464, -179.9997, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36477.2, -28501.34, 18758.51 > , < 15.2464, -179.9997, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36724.2, -28501.35, 18691.18 > , < 15.2464, -179.9997, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36971.2, -28501.35, 18623.86 > , < 15.2464, -179.9997, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37218.2, -28501.35, 18556.54 > , < 15.2464, -179.9997, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37166.92, -28335.35, 18368.4 > , < 15.2464, -179.9997, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36919.92, -28335.35, 18435.72 > , < 15.2464, -179.9997, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36672.92, -28335.35, 18503.05 > , < 15.2464, -179.9997, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36425.92, -28335.34, 18570.37 > , < 15.2464, -179.9997, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -36178.91, -28335.34, 18637.7 > , < 15.2464, -179.9997, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35933.59, -28335.35, 18704.49 > , < 15.2464, -179.9997, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35686.59, -28335.35, 18771.81 > , < 15.2464, -179.9997, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35439.59, -28335.35, 18839.13 > , < 15.2464, -179.9997, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -35192.59, -28335.34, 18906.46 > , < 15.2464, -179.9997, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37465.21, -28646.37, 18489.21 > , < -15.2464, 0.0006, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37413.94, -28812.37, 18301.07 > , < -15.2464, 0.0006, 49.6067 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37465.21, -28501.35, 18489.21 > , < 15.2464, -179.9997, 49.6068 > , false, 5000, 8, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -37413.93, -28335.35, 18301.08 > , < 15.2464, -179.9997, 49.6068 > , false, 5000, 8, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -32323.13, -27313.64, 20372.93 > , < 0, 0.0005, 89.9999 > , false, 5000, 8, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -33711.63, -27313.64, 20372.93 > , < 0, 0.0005, 89.9999 > , false, 5000, 8, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -32323.13, -27313.94, 19198.93 > , < 0, 0.0005, 89.9999 > , false, 5000, 8, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -33711.63, -27313.94, 19198.93 > , < 0, 0.0005, 89.9999 > , false, 5000, 8, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -32323.13, -27315.64, 19804.93 > , < 0, 0.0005, 89.9999 > , false, 5000, 8, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -33018.13, -27317.54, 20372.93 > , < 0, 0.0005, 89.9999 > , false, 5000, 8, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -33018.13, -27317.64, 19198.93 > , < 0, 0.0005, 89.9999 > , false, 5000, 8, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -33711.63, -27315.64, 19804.93 > , < 0, 0.0005, 89.9999 > , false, 5000, 8, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -35226.13, -27307.65, 20913.87 > , < 0, 0.0005, 89.9998 > , false, 5000, 8, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -35226.13, -27307.65, 20290.87 > , < 0, 0.0005, 89.9998 > , false, 5000, 8, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -34504.13, -27307.64, 19650.93 > , < 0, 0.0005, 89.9998 > , false, 5000, 8, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -35226.13, -27307.65, 19650.93 > , < 0, 0.0005, 89.9998 > , false, 5000, 8, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -34504.13, -27307.64, 20913.87 > , < 0, 0.0005, 89.9998 > , false, 5000, 8, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -35992.12, -27307.67, 20913.87 > , < 0, 0.0005, 89.9998 > , false, 5000, 8, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -35992.12, -27307.67, 19650.93 > , < 0, 0.0005, 89.9998 > , false, 5000, 8, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -34504.13, -27307.64, 20290.87 > , < 0, 0.0005, 89.9998 > , false, 5000, 8, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -35992.12, -27307.67, 20290.87 > , < 0, 0.0005, 89.9998 > , false, 5000, 8, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -37520.13, -27307.65, 20913.87 > , < 0, 0.0005, 89.9998 > , false, 5000, 8, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -37520.13, -27307.65, 20290.87 > , < 0, 0.0005, 89.9998 > , false, 5000, 8, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -36798.13, -27307.64, 19650.93 > , < 0, 0.0005, 89.9998 > , false, 5000, 8, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -37520.13, -27307.65, 19650.93 > , < 0, 0.0005, 89.9998 > , false, 5000, 8, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -36798.13, -27307.64, 20913.87 > , < 0, 0.0005, 89.9998 > , false, 5000, 8, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -38286.12, -27307.67, 20913.87 > , < 0, 0.0005, 89.9998 > , false, 5000, 8, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -38286.12, -27307.67, 19650.93 > , < 0, 0.0005, 89.9998 > , false, 5000, 8, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -36798.13, -27307.64, 20290.87 > , < 0, 0.0005, 89.9998 > , false, 5000, 8, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -38286.12, -27307.67, 20290.87 > , < 0, 0.0005, 89.9998 > , false, 5000, 8, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -35213.13, -25047.65, 20913.87 > , < 0, 0.0005, 89.9998 > , false, 5000, 8, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -35213.13, -25047.65, 20290.87 > , < 0, 0.0005, 89.9998 > , false, 5000, 8, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -34491.13, -25047.64, 19650.93 > , < 0, 0.0005, 89.9998 > , false, 5000, 8, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -35213.13, -25047.65, 19650.93 > , < 0, 0.0005, 89.9998 > , false, 5000, 8, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -34491.13, -25047.64, 20913.87 > , < 0, 0.0005, 89.9998 > , false, 5000, 8, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -35979.12, -25047.67, 20913.87 > , < 0, 0.0005, 89.9998 > , false, 5000, 8, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -35979.12, -25047.67, 19650.93 > , < 0, 0.0005, 89.9998 > , false, 5000, 8, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -34491.13, -25047.64, 20290.87 > , < 0, 0.0005, 89.9998 > , false, 5000, 8, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -35979.12, -25047.67, 20290.87 > , < 0, 0.0005, 89.9998 > , false, 5000, 8, 1))
//
//  foreach(entity ent in ClipArray) {
//    ent.MakeInvisible()
//    ent.kv.solid = 6
//    ent.kv.CollisionGroup = TRACE_COLLISION_GROUP_PLAYER
//    ent.kv.contents = CONTENTS_PLAYERCLIP
//  }
//
//  //Secondary Glow
//  foreach(entity ent in NoClimbArray) {
//    ent.Highlight_SetFunctions(0, 136, false, 136, 3.0, 2, false)
//    ent.Highlight_SetParam(0, 0, < darkrampr, darkrampg, darkrampb > )
//  }
//
//  //Main Glow
//  foreach(entity ent in NoGrappleArray) {
//    ent.Highlight_SetFunctions(0, 136, false, 136, 3.0, 2, false)
//    ent.Highlight_SetParam(0, 0, < rampr, rampg, rampb > )
//  }
//
//  //Outline Glow
//  foreach(entity ent in NoCollisionArray) {
//    ent.Highlight_SetFunctions(0, 0, false, 136, 3.0, 2, false)
//    ent.Highlight_SetParam(0, 0, < rampr, rampg, rampb > )
//  }
//
//  // Triggers
//  entity trigger_0 = MapEditor_CreateTrigger( < -39882.7, -28580.63, 19225.53 > , < 0, -180, 0 > , 237.05, 50, false)
//  trigger_0.SetEnterCallback(void
//    function (entity trigger, entity ent) {
//      if (IsValid(ent)) {
//        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
//        {
//          ent.SetOrigin( < -22640.3, -8429.232, 27015.53 > ) // change tp location
//          ent.SetAngles( < 0, 180, 0 > )
//
//          //
//          // Checkpoint and timer
//          //
//
//          int previousCheckpoint = 8
//          int checkpointInThisTrigger = 9
//          //show checkpoint msg
//          if(ent.p.currentCheckpoint != checkpointInThisTrigger)
//          	Remote_CallFunction_NonReplay( ent, "MG_Checkpoint_Msg")
//
//          if (ent.p.currentCheckpoint == previousCheckpoint) {
//            //set checkpoint
//            ent.p.currentCheckpoint = checkpointInThisTrigger
//
//            //change realm and lock invis
//            ent.RemoveFromAllRealms()
//            ent.AddToRealm(checkpointInThisTrigger)
//            ent.p.isPlayerInvisAllowed = false
//          }
//        }
//      }
//    })
//  DispatchSpawn(trigger_0)
//
//}
//
//void
//function MovementGym_Surf_Kitsune_lvl7() {
//  // Level Color
//  float rampr = 0.5
//  float rampg = 0.0
//  float rampb = 1.0
//  float darkrampr = 0.13
//  float darkrampg = 0.0
//  float darkrampb = 0.25
//
//  // Props Array
//  array < entity > ClipArray;
//  array < entity > NoClimbArray;
//  array < entity > NoGrappleArray;
//  array < entity > NoCollisionArray;
//
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -28387.05, -9302.629, 25344.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -29016.04, -9302.634, 25344.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -29016.04, -9302.634, 26095.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -28387.05, -9302.629, 26797.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -29592.04, -9302.635, 25344.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -29016.04, -9302.634, 26797.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -29592.04, -9302.635, 26095.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -29592.04, -9302.635, 26797.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -28387.05, -9302.629, 26095.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -27198.04, -9302.64, 26095.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -26569.04, -9302.635, 26797.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -27774.04, -9302.633, 25344.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -27198.04, -9302.64, 26797.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -27774.04, -9302.633, 26095.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -26569.04, -9302.635, 26095.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -26569.04, -9302.635, 25344.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -27198.04, -9302.64, 25344.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -27774.04, -9302.633, 26797.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -25360.04, -9302.634, 26095.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -24731.04, -9302.637, 25344.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -25360.04, -9302.634, 25344.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -24731.04, -9302.637, 26797.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -25936.04, -9302.635, 25344.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -25360.04, -9302.634, 26797.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -25936.04, -9302.635, 26095.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -24731.04, -9302.637, 26095.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -25936.04, -9302.635, 26797.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -23457.04, -9302.636, 26095.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -24033.04, -9302.636, 26797.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -22828.04, -9302.635, 25344.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -23457.04, -9302.636, 25344.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -22828.04, -9302.635, 26797.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -24033.04, -9302.636, 25344.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -23457.04, -9302.636, 26797.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -24033.04, -9302.636, 26095.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -22828.04, -9302.635, 26095.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -28387.05, -9302.629, 27547.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -29016.04, -9302.634, 27547.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -29592.04, -9302.635, 27547.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -31434.04, -9302.633, 27547.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -30229.04, -9302.636, 27547.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -26569.04, -9302.635, 27547.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -27198.04, -9302.64, 27547.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -27774.04, -9302.633, 27547.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -25936.04, -9302.635, 27547.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -24731.04, -9302.637, 27547.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -25360.04, -9302.634, 27547.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -24033.04, -9302.636, 27547.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -22828.04, -9302.635, 27547.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -23457.04, -9302.636, 27547.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -30858.04, -9302.636, 27547.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -28875.04, -13202.65, 22033.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -28875.04, -13202.65, 21212.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -28875.04, -13202.65, 20418.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -29658.04, -13202.65, 22033.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -29658.04, -13202.65, 20418.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -29658.04, -13202.65, 21212.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -30443.04, -13202.65, 21212.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -30443.04, -13202.65, 22033.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -30443.04, -13202.65, 20418.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -31257.04, -13202.64, 22033.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -31257.04, -13202.64, 20418.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -31257.04, -13202.65, 21212.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -32049.04, -13202.65, 21212.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -32049.04, -13202.65, 22033.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//    ClipArray.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < -32049.04, -13202.65, 20418.93 >, < 0, 0.0005, 89.9998 >, true, 50000, 9, 1 ) )
//
//  // Props
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -33108.06, -9375.646, 22861.93 > , < 0, 0.0005, 89.9999 > , false, 5000, 9, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -34496.56, -9375.648, 22861.93 > , < 0, 0.0005, 89.9999 > , false, 5000, 9, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -33108.06, -9375.947, 21687.93 > , < 0, 0.0005, 89.9999 > , false, 5000, 9, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -34496.56, -9375.949, 21687.93 > , < 0, 0.0005, 89.9999 > , false, 5000, 9, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -33108.06, -9377.646, 22293.93 > , < 0, 0.0005, 89.9999 > , false, 5000, 9, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -33803.06, -9379.546, 22861.93 > , < 0, 0.0005, 89.9999 > , false, 5000, 9, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -33803.06, -9379.647, 21687.93 > , < 0, 0.0005, 89.9999 > , false, 5000, 9, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -34496.56, -9377.648, 22293.93 > , < 0, 0.0005, 89.9999 > , false, 5000, 9, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -29395.05, -8416.65, 26191.93 > , < 0.0002, 90.0005, 90 > , false, 5000, 9, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -29391.05, -8416.65, 25573.93 > , < 0.0002, 90.0005, 90 > , false, 5000, 9, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -29314.05, -8417.65, 26191.93 > , < -0.0002, -89.9994, 90 > , false, 5000, 9, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -29318.05, -8417.65, 25573.93 > , < -0.0002, -89.9994, 90 > , false, 5000, 9, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -29318.05, -8417.65, 26817.93 > , < -0.0002, -89.9994, 90 > , false, 5000, 9, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -29391.05, -8416.65, 26817.93 > , < 0.0002, 90.0005, 90 > , false, 5000, 9, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -29937.05, -9037.65, 26191.93 > , < 0.0002, 90.0005, 90 > , false, 5000, 9, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -29933.05, -9037.65, 25573.93 > , < 0.0002, 90.0005, 90 > , false, 5000, 9, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -29856.05, -9038.65, 26191.93 > , < -0.0002, -89.9994, 90 > , false, 5000, 9, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -29860.05, -9038.65, 25573.93 > , < -0.0002, -89.9994, 90 > , false, 5000, 9, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -29860.05, -9038.65, 26817.93 > , < -0.0002, -89.9994, 90 > , false, 5000, 9, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -29933.05, -9037.65, 26817.93 > , < 0.0002, 90.0005, 90 > , false, 5000, 9, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -29860.05, -7788.846, 26817.93 > , < -0.0002, -89.9994, 90 > , false, 5000, 9, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -29937.05, -7787.65, 26191.93 > , < 0.0002, 90.0005, 90 > , false, 5000, 9, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -29933.05, -7787.846, 25573.93 > , < 0.0002, 90.0005, 90 > , false, 5000, 9, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -29856.05, -7788.65, 26191.93 > , < -0.0002, -89.9994, 90 > , false, 5000, 9, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -29860.05, -7788.846, 25573.93 > , < -0.0002, -89.9994, 90 > , false, 5000, 9, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -29933.05, -7787.846, 26817.93 > , < 0.0002, 90.0005, 90 > , false, 5000, 9, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -30334.05, -8404.647, 25180.93 > , < 0, 0.0006, 179.9998 > , false, 5000, 9, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -30334.05, -7786.647, 25176.93 > , < 0, 0.0006, 179.9998 > , false, 5000, 9, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -30334.05, -9030.647, 25176.93 > , < 0, 0.0006, 179.9998 > , false, 5000, 9, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -31349.05, -8404.648, 24368.93 > , < 0, 0.0006, 179.9998 > , false, 5000, 9, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -31349.05, -7786.648, 24364.93 > , < 0, 0.0006, 179.9998 > , false, 5000, 9, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -31349.05, -9030.648, 24364.93 > , < 0, 0.0006, 179.9998 > , false, 5000, 9, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -30403.05, -8404.647, 23331.93 > , < 0, 0.0006, 179.9998 > , false, 5000, 9, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -30403.05, -7786.647, 23327.93 > , < 0, 0.0006, 179.9998 > , false, 5000, 9, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -30403.05, -9030.647, 23327.93 > , < 0, 0.0006, 179.9998 > , false, 5000, 9, 1))
//  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_02.rmdl", < -22888.98, -8100.689, 26919.93 > , < 0, 90.0002, 0 > , false, 5000, 9, 1))
//  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_04_corner.rmdl", < -22392.99, -9188.034, 26919.93 > , < 0, -89.9995, 0 > , false, 5000, 9, 1))
//  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_04_corner.rmdl", < -22888.98, -8101.234, 26919.93 > , < 0, -179.9993, 0 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -23098.36, -8340.535, 26763 > , < 11.9382, -179.9999, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -23348.83, -8340.535, 26710.05 > , < 11.9382, -179.9999, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -23599.3, -8340.536, 26657.09 > , < 11.9382, -179.9999, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -23849.77, -8340.536, 26604.13 > , < 11.9382, -179.9999, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -23809.44, -8174.641, 26413.38 > , < 11.9382, -179.9999, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -23558.97, -8174.641, 26466.33 > , < 11.9382, -179.9999, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -23308.5, -8174.64, 26519.29 > , < 11.9382, -179.9999, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -23058.02, -8174.64, 26572.25 > , < 11.9382, -179.9999, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -23849.77, -8485.634, 26604.13 > , < -11.9382, 0.0004, 49.6067 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -23599.3, -8485.639, 26657.09 > , < -11.9382, 0.0004, 49.6067 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -23348.83, -8485.637, 26710.04 > , < -11.9382, 0.0004, 49.6067 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -23098.36, -8485.635, 26763 > , < -11.9382, 0.0004, 49.6067 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -23058.03, -8651.53, 26572.25 > , < -11.9382, 0.0004, 49.6067 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -23308.5, -8651.534, 26519.29 > , < -11.9382, 0.0004, 49.6067 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -23558.97, -8651.53, 26466.33 > , < -11.9382, 0.0004, 49.6067 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -23809.44, -8651.538, 26413.38 > , < -11.9382, 0.0004, 49.6067 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -24100.25, -8485.642, 26551.17 > , < -11.9382, 0.0004, 49.6067 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -24059.92, -8651.537, 26360.42 > , < -11.9382, 0.0004, 49.6067 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -24350.72, -8485.644, 26498.21 > , < -11.9382, 0.0004, 49.6067 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -24310.39, -8651.541, 26307.46 > , < -11.9382, 0.0004, 49.6067 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -24601.19, -8485.646, 26445.26 > , < -11.9382, 0.0004, 49.6067 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -24560.86, -8651.537, 26254.5 > , < -11.9382, 0.0004, 49.6067 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -24851.66, -8485.641, 26392.3 > , < -11.9382, 0.0004, 49.6067 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -24811.33, -8651.545, 26201.55 > , < -11.9382, 0.0004, 49.6067 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -25102.14, -8485.648, 26339.34 > , < -11.9382, 0.0004, 49.6067 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -25061.81, -8651.543, 26148.59 > , < -11.9382, 0.0004, 49.6067 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -25352.62, -8485.65, 26286.38 > , < -11.9382, 0.0004, 49.6067 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -25312.28, -8651.548, 26095.63 > , < -11.9382, 0.0004, 49.6067 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -25603.08, -8485.652, 26233.43 > , < -11.9382, 0.0004, 49.6067 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -25562.75, -8651.544, 26042.68 > , < -11.9382, 0.0004, 49.6067 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -25853.55, -8485.647, 26180.47 > , < -11.9382, 0.0004, 49.6067 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -25813.22, -8651.552, 25989.71 > , < -11.9382, 0.0004, 49.6067 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -26104.03, -8485.655, 26127.51 > , < -11.9382, 0.0004, 49.6067 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -26063.7, -8651.55, 25936.76 > , < -11.9382, 0.0004, 49.6067 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -26354.51, -8485.657, 26074.55 > , < -11.9382, 0.0004, 49.6067 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -26314.17, -8651.555, 25883.8 > , < -11.9382, 0.0004, 49.6067 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -26604.97, -8485.659, 26021.6 > , < -11.9382, 0.0004, 49.6067 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -26564.64, -8651.551, 25830.85 > , < -11.9382, 0.0004, 49.6067 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -26855.45, -8485.654, 25968.64 > , < -11.9382, 0.0004, 49.6067 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -26815.12, -8651.559, 25777.89 > , < -11.9382, 0.0004, 49.6067 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27105.92, -8485.662, 25915.68 > , < -11.9382, 0.0004, 49.6067 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27065.59, -8651.557, 25724.93 > , < -11.9382, 0.0004, 49.6067 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27356.4, -8485.664, 25862.73 > , < -11.9382, 0.0004, 49.6067 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27316.07, -8651.562, 25671.97 > , < -11.9382, 0.0004, 49.6067 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27606.87, -8485.666, 25809.77 > , < -11.9382, 0.0004, 49.6067 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27566.53, -8651.559, 25619.02 > , < -11.9382, 0.0004, 49.6067 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27857.34, -8485.661, 25756.81 > , < -11.9382, 0.0004, 49.6067 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27817.01, -8651.565, 25566.06 > , < -11.9382, 0.0004, 49.6067 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -28107.82, -8485.669, 25703.85 > , < -11.9382, 0.0004, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -28067.49, -8651.563, 25513.1 > , < -11.9382, 0.0004, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -28358.3, -8485.671, 25650.89 > , < -11.9382, 0.0004, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -28317.96, -8651.568, 25460.14 > , < -11.9382, 0.0004, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -28608.77, -8485.673, 25597.94 > , < -11.9382, 0.0004, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -28568.43, -8651.565, 25407.19 > , < -11.9382, 0.0004, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -24100.24, -8340.536, 26551.18 > , < 11.9382, -179.9999, 49.6068 > , false, 5000, 9, 0.9999999))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -24059.91, -8174.641, 26360.42 > , < 11.9382, -179.9999, 49.6068 > , false, 5000, 9, 0.9999999))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -24350.72, -8340.536, 26498.21 > , < 11.9382, -179.9999, 49.6068 > , false, 5000, 9, 0.9999999))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -24310.39, -8174.641, 26307.46 > , < 11.9382, -179.9999, 49.6068 > , false, 5000, 9, 0.9999999))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -24601.19, -8340.537, 26445.26 > , < 11.9382, -179.9999, 49.6068 > , false, 5000, 9, 0.9999999))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -24560.86, -8174.642, 26254.5 > , < 11.9382, -179.9999, 49.6068 > , false, 5000, 9, 0.9999999))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -24851.66, -8340.537, 26392.3 > , < 11.9382, -179.9999, 49.6068 > , false, 5000, 9, 0.9999999))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -24811.33, -8174.642, 26201.55 > , < 11.9382, -179.9999, 49.6068 > , false, 5000, 9, 0.9999999))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -25102.14, -8340.537, 26339.34 > , < 11.9382, -179.9999, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -25061.81, -8174.642, 26148.59 > , < 11.9382, -179.9999, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -25352.63, -8340.537, 26286.38 > , < 11.9382, -179.9999, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -25312.29, -8174.642, 26095.63 > , < 11.9382, -179.9999, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -25603.09, -8340.538, 26233.43 > , < 11.9382, -179.9999, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -25562.75, -8174.643, 26042.68 > , < 11.9382, -179.9999, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -25853.56, -8340.538, 26180.47 > , < 11.9382, -179.9999, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -25813.23, -8174.643, 25989.72 > , < 11.9382, -179.9999, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -26104.05, -8340.538, 26127.51 > , < 11.9382, -179.9999, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -26063.71, -8174.643, 25936.75 > , < 11.9382, -179.9999, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -26354.52, -8340.538, 26074.55 > , < 11.9382, -179.9999, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -26314.19, -8174.643, 25883.8 > , < 11.9382, -179.9999, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -26604.99, -8340.539, 26021.6 > , < 11.9382, -179.9999, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -26564.65, -8174.644, 25830.84 > , < 11.9382, -179.9999, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -26855.46, -8340.539, 25968.64 > , < 11.9382, -179.9999, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -26815.13, -8174.644, 25777.89 > , < 11.9382, -179.9999, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27105.94, -8340.539, 25915.68 > , < 11.9382, -179.9999, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27065.61, -8174.644, 25724.93 > , < 11.9382, -179.9999, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27356.42, -8340.539, 25862.72 > , < 11.9382, -179.9999, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27316.09, -8174.644, 25671.96 > , < 11.9382, -179.9999, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27606.89, -8340.54, 25809.76 > , < 11.9382, -179.9999, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27566.55, -8174.645, 25619.01 > , < 11.9382, -179.9999, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27857.36, -8340.54, 25756.81 > , < 11.9382, -179.9999, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27817.03, -8174.645, 25566.05 > , < 11.9382, -179.9999, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -28107.84, -8340.54, 25703.85 > , < 11.9382, -179.9999, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -28067.51, -8174.645, 25513.1 > , < 11.9382, -179.9999, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -28358.31, -8340.54, 25650.89 > , < 11.9382, -179.9999, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -28317.99, -8174.645, 25460.14 > , < 11.9382, -179.9999, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -28608.79, -8340.541, 25597.93 > , < 11.9382, -179.9999, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -28568.45, -8174.646, 25407.18 > , < 11.9382, -179.9999, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -31035.91, -8485.645, 22608.31 > , < -14.9739, 0.0004, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -30985.79, -8651.645, 22419.6 > , < -14.9739, 0.0004, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -31283.68, -8485.645, 22542.64 > , < -14.9739, 0.0004, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -31232.38, -8651.645, 22353.15 > , < -14.9739, 0.0004, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -31531.25, -8485.645, 22475.98 > , < -14.9739, 0.0004, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -31480.15, -8651.645, 22287.48 > , < -14.9739, 0.0004, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -31777.84, -8485.645, 22409.54 > , < -14.9739, 0.0004, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -31727.72, -8651.645, 22220.82 > , < -14.9739, 0.0004, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -31035.91, -8340.645, 22608.31 > , < 14.9739, -180, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -30985.79, -8174.645, 22419.6 > , < 14.9739, -180, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -31283.68, -8340.645, 22542.64 > , < 14.9739, -180, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -31232.38, -8174.645, 22353.15 > , < 14.9739, -180, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -31531.25, -8340.645, 22475.98 > , < 14.9739, -180, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -31480.15, -8174.645, 22287.48 > , < 14.9739, -180, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -31777.84, -8340.646, 22409.54 > , < 14.9739, -180, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -31727.72, -8174.645, 22220.82 > , < 14.9739, -180, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33745.14, -9949.647, 22171.44 > , < 0.0262, 90.0001, 49.6067 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33579.23, -9949.647, 21976.54 > , < 0.0262, 90.0001, 49.6067 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33890.27, -9949.647, 22171.42 > , < -0.026, -90.0001, 49.6069 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34056.61, -9949.647, 21976.8 > , < -0.026, -90.0001, 49.6069 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33843.24, -12190.65, 22103.68 > , < -14.8057, -179.9993, 49.6067 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33843.24, -12335.65, 22103.68 > , < 14.8058, 0.0004, 49.6069 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27314.24, -14509.64, 20968.7 > , < -15.0095, 90.0003, 49.6067 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27459.38, -14509.64, 20968.67 > , < 15.0095, -90.0001, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -32025.49, -8340.646, 22343.3 > , < 14.9739, -180, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -31975.36, -8174.645, 22154.59 > , < 14.9739, -180, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -32273.14, -8340.646, 22277.07 > , < 14.9739, -180, 49.6068 > , false, 5000, 9, 1.000002))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -32223.01, -8174.645, 22088.35 > , < 14.9739, -180, 49.6068 > , false, 5000, 9, 1.000002))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -32520.79, -8340.646, 22210.83 > , < 14.9739, -180, 49.6068 > , false, 5000, 9, 1.000002))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -32470.66, -8174.645, 22022.11 > , < 14.9739, -180, 49.6068 > , false, 5000, 9, 1.000002))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -32768.43, -8340.646, 22144.6 > , < 14.9739, -180, 49.6068 > , false, 5000, 9, 1.000002))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -32718.31, -8174.645, 21955.88 > , < 14.9739, -180, 49.6068 > , false, 5000, 9, 1.000002))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -32025.49, -8485.646, 22343.3 > , < -14.9739, 0.0004, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -31975.37, -8651.646, 22154.59 > , < -14.9739, 0.0004, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -32273.14, -8485.648, 22277.06 > , < -14.9739, 0.0004, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -32223.03, -8651.648, 22088.35 > , < -14.9739, 0.0004, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -32520.8, -8485.65, 22210.83 > , < -14.9739, 0.0004, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -32470.68, -8651.65, 22022.11 > , < -14.9739, 0.0004, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -32768.46, -8485.652, 22144.59 > , < -14.9739, 0.0004, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -32718.34, -8651.652, 21955.87 > , < -14.9739, 0.0004, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33016.11, -8485.654, 22078.35 > , < -14.9739, 0.0004, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -32965.99, -8651.654, 21889.63 > , < -14.9739, 0.0004, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33016.08, -8340.646, 22078.36 > , < 14.9739, -180, 49.6068 > , false, 5000, 9, 1.000002))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -32965.96, -8174.645, 21889.64 > , < 14.9739, -180, 49.6068 > , false, 5000, 9, 1.000002))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33745.14, -10205.74, 22171.56 > , < 0.0262, 90.0001, 49.6067 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33579.23, -10205.74, 21976.66 > , < 0.0262, 90.0001, 49.6067 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33745.14, -10461.84, 22171.68 > , < 0.0262, 90.0001, 49.6067 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33579.23, -10461.84, 21976.78 > , < 0.0262, 90.0001, 49.6067 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33745.14, -10717.94, 22171.79 > , < 0.0262, 90.0001, 49.6067 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33579.23, -10717.94, 21976.89 > , < 0.0262, 90.0001, 49.6067 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33890.27, -10205.75, 22171.54 > , < -0.026, -90.0001, 49.6069 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34056.61, -10205.75, 21976.92 > , < -0.026, -90.0001, 49.6069 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33890.27, -10461.84, 22171.65 > , < -0.026, -90.0001, 49.6069 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34056.61, -10461.84, 21977.04 > , < -0.026, -90.0001, 49.6069 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33890.27, -10717.94, 22171.77 > , < -0.026, -90.0001, 49.6069 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -34056.61, -10717.94, 21977.15 > , < -0.026, -90.0001, 49.6069 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33893.06, -12024.75, 21915.18 > , < -14.8057, -179.9993, 49.6067 > , false, 5000, 9, 0.9999999))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33645.55, -12024.75, 21849.76 > , < -14.8057, -179.9993, 49.6067 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33595.72, -12190.64, 22038.26 > , < -14.8057, -179.9993, 49.6067 > , false, 5000, 9, 0.9999999))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33398.03, -12024.74, 21784.34 > , < -14.8057, -179.9993, 49.6067 > , false, 5000, 9, 0.9999999))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33348.21, -12190.64, 21972.84 > , < -14.8057, -179.9993, 49.6067 > , false, 5000, 9, 0.9999999))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33150.52, -12024.74, 21718.91 > , < -14.8057, -179.9993, 49.6067 > , false, 5000, 9, 0.9999998))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33100.69, -12190.64, 21907.41 > , < -14.8057, -179.9993, 49.6067 > , false, 5000, 9, 0.9999998))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -32903, -12024.74, 21653.49 > , < -14.8057, -179.9993, 49.6067 > , false, 5000, 9, 0.9999998))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -32853.18, -12190.63, 21841.99 > , < -14.8057, -179.9993, 49.6067 > , false, 5000, 9, 0.9999998))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -32655.48, -12024.74, 21588.07 > , < -14.8057, -179.9993, 49.6067 > , false, 5000, 9, 0.9999998))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -32605.66, -12190.63, 21776.57 > , < -14.8057, -179.9993, 49.6067 > , false, 5000, 9, 0.9999998))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -32407.97, -12024.73, 21522.65 > , < -14.8057, -179.9993, 49.6067 > , false, 5000, 9, 0.9999996))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -32358.15, -12190.63, 21711.15 > , < -14.8057, -179.9993, 49.6067 > , false, 5000, 9, 0.9999996))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -32160.46, -12024.73, 21457.23 > , < -14.8057, -179.9993, 49.6066 > , false, 5000, 9, 0.9999995))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -32110.63, -12190.63, 21645.73 > , < -14.8057, -179.9993, 49.6066 > , false, 5000, 9, 0.9999995))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -31912.94, -12024.73, 21391.8 > , < -14.8057, -179.9993, 49.6066 > , false, 5000, 9, 0.9999996))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -31863.12, -12190.62, 21580.3 > , < -14.8057, -179.9993, 49.6066 > , false, 5000, 9, 0.9999996))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -31665.43, -12024.72, 21326.38 > , < -14.8057, -179.9993, 49.6066 > , false, 5000, 9, 0.9999998))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -31615.6, -12190.62, 21514.88 > , < -14.8057, -179.9993, 49.6066 > , false, 5000, 9, 0.9999998))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -31417.91, -12024.72, 21260.96 > , < -14.8057, -179.9993, 49.6066 > , false, 5000, 9, 0.9999999))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -31368.09, -12190.62, 21449.46 > , < -14.8057, -179.9993, 49.6066 > , false, 5000, 9, 0.9999999))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -31170.39, -12024.72, 21195.54 > , < -14.8057, -179.9993, 49.6066 > , false, 5000, 9, 0.9999999))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -31120.57, -12190.61, 21384.04 > , < -14.8057, -179.9993, 49.6066 > , false, 5000, 9, 0.9999999))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -30922.88, -12024.72, 21130.12 > , < -14.8057, -179.9993, 49.6066 > , false, 5000, 9, 0.9999999))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -30873.05, -12190.61, 21318.62 > , < -14.8057, -179.9993, 49.6066 > , false, 5000, 9, 0.9999999))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -30675.36, -12024.71, 21064.7 > , < -14.8057, -179.9993, 49.6066 > , false, 5000, 9, 0.9999998))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -30625.54, -12190.61, 21253.2 > , < -14.8057, -179.9993, 49.6066 > , false, 5000, 9, 0.9999998))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -30427.85, -12024.71, 20999.27 > , < -14.8057, -179.9993, 49.6066 > , false, 5000, 9, 0.9999995))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -30378.02, -12190.61, 21187.77 > , < -14.8057, -179.9993, 49.6066 > , false, 5000, 9, 0.9999995))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -30180.33, -12024.71, 20933.85 > , < -14.8057, -179.9993, 49.6066 > , false, 5000, 9, 0.9999996))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -30130.51, -12190.6, 21122.35 > , < -14.8057, -179.9993, 49.6066 > , false, 5000, 9, 0.9999996))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -29932.82, -12024.7, 20868.43 > , < -14.8057, -179.9993, 49.6066 > , false, 5000, 9, 0.9999995))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -29882.99, -12190.6, 21056.93 > , < -14.8057, -179.9993, 49.6066 > , false, 5000, 9, 0.9999995))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -29685.3, -12024.7, 20803 > , < -14.8058, -179.9993, 49.6066 > , false, 5000, 9, 0.9999995))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -29635.48, -12190.59, 20991.5 > , < -14.8058, -179.9993, 49.6066 > , false, 5000, 9, 0.9999995))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -29437.79, -12024.7, 20737.58 > , < -14.8058, -179.9993, 49.6066 > , false, 5000, 9, 0.9999994))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -29387.96, -12190.59, 20926.07 > , < -14.8058, -179.9993, 49.6066 > , false, 5000, 9, 0.9999994))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -29190.27, -12024.7, 20672.15 > , < -14.8058, -179.9993, 49.6066 > , false, 5000, 9, 0.9999995))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -29140.45, -12190.59, 20860.65 > , < -14.8058, -179.9993, 49.6066 > , false, 5000, 9, 0.9999995))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -28942.75, -12024.69, 20606.73 > , < -14.8058, -179.9993, 49.6066 > , false, 5000, 9, 0.9999996))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -28892.93, -12190.59, 20795.22 > , < -14.8058, -179.9993, 49.6066 > , false, 5000, 9, 0.9999996))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -28695.24, -12024.69, 20541.3 > , < -14.8058, -179.9993, 49.6066 > , false, 5000, 9, 0.9999995))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -28645.41, -12190.58, 20729.8 > , < -14.8058, -179.9993, 49.6066 > , false, 5000, 9, 0.9999995))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -28447.72, -12024.69, 20475.88 > , < -14.8058, -179.9993, 49.6066 > , false, 5000, 9, 0.9999994))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -28397.9, -12190.58, 20664.38 > , < -14.8058, -179.9993, 49.6066 > , false, 5000, 9, 0.9999994))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33893.06, -12501.54, 21915.18 > , < 14.8058, 0.0004, 49.6069 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33645.55, -12501.54, 21849.75 > , < 14.8058, 0.0004, 49.6069 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33595.72, -12335.64, 22038.26 > , < 14.8058, 0.0004, 49.6069 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33398.03, -12501.54, 21784.33 > , < 14.8058, 0.0004, 49.607 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33348.21, -12335.64, 21972.83 > , < 14.8058, 0.0004, 49.6069 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33150.52, -12501.54, 21718.91 > , < 14.8058, 0.0004, 49.607 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -33100.69, -12335.64, 21907.41 > , < 14.8058, 0.0004, 49.6069 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -32903, -12501.54, 21653.48 > , < 14.8058, 0.0004, 49.607 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -32853.18, -12335.64, 21841.99 > , < 14.8058, 0.0004, 49.607 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -32655.48, -12501.53, 21588.06 > , < 14.8058, 0.0004, 49.607 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -32605.66, -12335.64, 21776.56 > , < 14.8058, 0.0004, 49.607 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -32407.98, -12501.53, 21522.64 > , < 14.8058, 0.0004, 49.607 > , false, 5000, 9, 0.9999999))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -32358.15, -12335.63, 21711.14 > , < 14.8058, 0.0004, 49.607 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -32160.46, -12501.53, 21457.22 > , < 14.8058, 0.0004, 49.607 > , false, 5000, 9, 0.9999999))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -32110.64, -12335.63, 21645.72 > , < 14.8058, 0.0004, 49.607 > , false, 5000, 9, 0.9999999))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -31912.95, -12501.53, 21391.79 > , < 14.8058, 0.0004, 49.607 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -31863.12, -12335.63, 21580.29 > , < 14.8058, 0.0004, 49.607 > , false, 5000, 9, 0.9999999))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -31665.43, -12501.53, 21326.37 > , < 14.8058, 0.0004, 49.607 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -31615.61, -12335.63, 21514.87 > , < 14.8058, 0.0004, 49.607 > , false, 5000, 9, 0.9999999))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -31417.91, -12501.52, 21260.95 > , < 14.8058, 0.0004, 49.607 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -31368.09, -12335.63, 21449.45 > , < 14.8058, 0.0004, 49.607 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -31170.4, -12501.52, 21195.52 > , < 14.8058, 0.0004, 49.607 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -31120.57, -12335.63, 21384.02 > , < 14.8058, 0.0004, 49.607 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -30922.88, -12501.52, 21130.1 > , < 14.8058, 0.0004, 49.607 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -30873.06, -12335.62, 21318.6 > , < 14.8058, 0.0004, 49.607 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -30675.37, -12501.52, 21064.67 > , < 14.8058, 0.0004, 49.607 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -30625.54, -12335.62, 21253.18 > , < 14.8058, 0.0004, 49.607 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -30427.85, -12501.52, 20999.25 > , < 14.8058, 0.0004, 49.607 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -30378.03, -12335.62, 21187.75 > , < 14.8058, 0.0004, 49.607 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -30180.34, -12501.51, 20933.82 > , < 14.8058, 0.0004, 49.607 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -30130.51, -12335.62, 21122.33 > , < 14.8058, 0.0004, 49.607 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -29932.82, -12501.51, 20868.4 > , < 14.8058, 0.0004, 49.607 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -29883, -12335.62, 21056.9 > , < 14.8058, 0.0004, 49.607 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -29685.3, -12501.51, 20802.98 > , < 14.8058, 0.0004, 49.607 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -29635.48, -12335.61, 20991.48 > , < 14.8058, 0.0004, 49.607 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -29437.79, -12501.51, 20737.55 > , < 14.8058, 0.0004, 49.607 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -29387.96, -12335.61, 20926.06 > , < 14.8058, 0.0004, 49.607 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -29190.27, -12501.51, 20672.13 > , < 14.8058, 0.0004, 49.607 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -29140.45, -12335.61, 20860.63 > , < 14.8058, 0.0004, 49.607 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -28942.76, -12501.5, 20606.71 > , < 14.8058, 0.0004, 49.607 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -28892.93, -12335.61, 20795.21 > , < 14.8058, 0.0004, 49.607 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -28695.24, -12501.5, 20541.28 > , < 14.8058, 0.0004, 49.607 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -28645.42, -12335.61, 20729.79 > , < 14.8058, 0.0004, 49.607 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -28447.73, -12501.5, 20475.86 > , < 14.8058, 0.0004, 49.607 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -28397.9, -12335.6, 20664.36 > , < 14.8058, 0.0004, 49.607 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27625.27, -14459.15, 20780.35 > , < 15.0095, -90.0001, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27625.27, -14706.43, 20714.05 > , < 15.0095, -90.0001, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27459.38, -14756.92, 20902.37 > , < 15.0095, -90.0001, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27625.27, -14953.71, 20647.74 > , < 15.0095, -90.0001, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27459.38, -15004.2, 20836.06 > , < 15.0095, -90.0001, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27625.27, -15200.99, 20581.44 > , < 15.0095, -90.0001, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27459.38, -15251.48, 20769.76 > , < 15.0095, -90.0001, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27625.27, -15448.27, 20515.14 > , < 15.0095, -90.0001, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27459.38, -15498.77, 20703.46 > , < 15.0095, -90.0001, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27625.27, -15695.55, 20448.84 > , < 15.0095, -90.0001, 49.6068 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27459.38, -15746.05, 20637.15 > , < 15.0095, -90.0001, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27625.27, -15942.83, 20382.53 > , < 15.0095, -90.0001, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27459.38, -15993.33, 20570.85 > , < 15.0095, -90.0001, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27625.27, -16190.12, 20316.23 > , < 15.0095, -90.0001, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27459.38, -16240.61, 20504.55 > , < 15.0095, -90.0001, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27625.27, -16437.4, 20249.93 > , < 15.0095, -90.0001, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27459.38, -16487.89, 20438.25 > , < 15.0095, -90.0001, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27625.27, -16684.68, 20183.62 > , < 15.0095, -90.0001, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27459.38, -16735.17, 20371.94 > , < 15.0095, -90.0001, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27625.27, -16931.96, 20117.32 > , < 15.0095, -90.0001, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27459.38, -16982.45, 20305.64 > , < 15.0095, -90.0001, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27625.27, -17179.24, 20051.02 > , < 15.0095, -90.0001, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27459.38, -17229.73, 20239.34 > , < 15.0095, -90.0001, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27625.27, -17426.52, 19984.71 > , < 15.0095, -90.0001, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27459.38, -17477.02, 20173.04 > , < 15.0095, -90.0001, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27625.27, -17673.8, 19918.41 > , < 15.0095, -90.0001, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27459.38, -17724.3, 20106.73 > , < 15.0095, -90.0001, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27625.27, -17921.08, 19852.11 > , < 15.0095, -90.0001, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27459.38, -17971.58, 20040.43 > , < 15.0095, -90.0001, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27625.27, -18168.37, 19785.81 > , < 15.0095, -90.0001, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27459.38, -18218.86, 19974.12 > , < 15.0095, -90.0001, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27625.27, -18415.65, 19719.5 > , < 15.0095, -90.0001, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27459.38, -18466.14, 19907.82 > , < 15.0095, -90.0001, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27625.27, -18662.93, 19653.2 > , < 15.0095, -90.0001, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27459.38, -18713.42, 19841.52 > , < 15.0095, -90.0001, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27625.27, -18910.21, 19586.9 > , < 15.0095, -90.0001, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27459.38, -18960.7, 19775.21 > , < 15.0095, -90.0001, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27625.27, -19157.49, 19520.6 > , < 15.0095, -90.0001, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27459.38, -19207.98, 19708.91 > , < 15.0095, -90.0001, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27625.27, -19404.77, 19454.29 > , < 15.0095, -90.0001, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27459.38, -19455.27, 19642.61 > , < 15.0095, -90.0001, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27625.27, -19652.05, 19387.99 > , < 15.0095, -90.0001, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27459.38, -19702.55, 19576.31 > , < 15.0095, -90.0001, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27625.27, -19899.33, 19321.69 > , < 15.0095, -90.0001, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27459.38, -19949.83, 19510 > , < 15.0095, -90.0001, 49.6068 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27148.35, -14459.14, 20780.37 > , < -15.0095, 90.0003, 49.6067 > , false, 5000, 9, 0.9999996))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27148.35, -14706.43, 20714.07 > , < -15.0095, 90.0003, 49.6067 > , false, 5000, 9, 0.9999995))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27314.24, -14756.92, 20902.39 > , < -15.0095, 90.0003, 49.6067 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27148.35, -14953.7, 20647.77 > , < -15.0095, 90.0003, 49.6067 > , false, 5000, 9, 0.9999993))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27314.24, -15004.2, 20836.09 > , < -15.0095, 90.0003, 49.6067 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27148.35, -15200.98, 20581.47 > , < -15.0095, 90.0003, 49.6067 > , false, 5000, 9, 0.9999992))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27314.24, -15251.47, 20769.79 > , < -15.0095, 90.0003, 49.6067 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27148.35, -15448.25, 20515.17 > , < -15.0095, 90.0003, 49.6067 > , false, 5000, 9, 0.999999))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27314.24, -15498.75, 20703.49 > , < -15.0094, 90.0003, 49.6066 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27148.35, -15695.53, 20448.87 > , < -15.0095, 90.0003, 49.6067 > , false, 5000, 9, 0.9999989))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27314.24, -15746.02, 20637.19 > , < -15.0094, 90.0003, 49.6066 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27148.35, -15942.8, 20382.57 > , < -15.0095, 90.0003, 49.6067 > , false, 5000, 9, 0.9999988))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27314.24, -15993.3, 20570.89 > , < -15.0094, 90.0003, 49.6066 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27148.35, -16190.08, 20316.27 > , < -15.0095, 90.0003, 49.6067 > , false, 5000, 9, 0.9999987))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27314.24, -16240.57, 20504.59 > , < -15.0094, 90.0003, 49.6066 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27148.35, -16437.36, 20249.96 > , < -15.0095, 90.0003, 49.6067 > , false, 5000, 9, 0.9999987))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27314.24, -16487.85, 20438.29 > , < -15.0094, 90.0002, 49.6066 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27148.35, -16684.63, 20183.66 > , < -15.0095, 90.0003, 49.6067 > , false, 5000, 9, 0.9999986))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27314.24, -16735.13, 20371.98 > , < -15.0094, 90.0002, 49.6066 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27148.35, -16931.91, 20117.36 > , < -15.0095, 90.0003, 49.6067 > , false, 5000, 9, 0.9999985))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27314.24, -16982.41, 20305.68 > , < -15.0094, 90.0002, 49.6066 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27148.35, -17179.19, 20051.06 > , < -15.0095, 90.0003, 49.6067 > , false, 5000, 9, 0.9999985))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27314.24, -17229.68, 20239.38 > , < -15.0094, 90.0002, 49.6066 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27148.35, -17426.46, 19984.76 > , < -15.0095, 90.0003, 49.6067 > , false, 5000, 9, 0.9999983))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27314.24, -17476.96, 20173.08 > , < -15.0094, 90.0002, 49.6066 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27148.35, -17673.74, 19918.46 > , < -15.0095, 90.0003, 49.6067 > , false, 5000, 9, 0.9999982))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27314.24, -17724.24, 20106.78 > , < -15.0094, 90.0002, 49.6066 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27148.35, -17921.02, 19852.16 > , < -15.0095, 90.0003, 49.6067 > , false, 5000, 9, 0.9999981))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27314.24, -17971.52, 20040.48 > , < -15.0094, 90.0002, 49.6066 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27148.35, -18168.3, 19785.86 > , < -15.0095, 90.0003, 49.6067 > , false, 5000, 9, 0.9999979))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27314.24, -18218.79, 19974.18 > , < -15.0094, 90.0002, 49.6066 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27148.35, -18415.57, 19719.56 > , < -15.0095, 90.0003, 49.6067 > , false, 5000, 9, 0.9999979))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27314.24, -18466.07, 19907.88 > , < -15.0094, 90.0002, 49.6066 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27148.35, -18662.85, 19653.26 > , < -15.0095, 90.0003, 49.6067 > , false, 5000, 9, 0.9999977))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27314.24, -18713.35, 19841.57 > , < -15.0094, 90.0002, 49.6066 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27148.35, -18910.13, 19586.96 > , < -15.0095, 90.0003, 49.6067 > , false, 5000, 9, 0.9999977))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27314.24, -18960.63, 19775.27 > , < -15.0094, 90.0002, 49.6066 > , false, 5000, 9, 1.000001))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27148.35, -19157.41, 19520.66 > , < -15.0095, 90.0003, 49.6067 > , false, 5000, 9, 0.9999977))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27314.24, -19207.9, 19708.97 > , < -15.0094, 90.0002, 49.6066 > , false, 5000, 9, 1.000002))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27148.35, -19404.68, 19454.36 > , < -15.0095, 90.0003, 49.6067 > , false, 5000, 9, 0.9999977))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27314.24, -19455.18, 19642.67 > , < -15.0094, 90.0002, 49.6066 > , false, 5000, 9, 1.000002))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27148.35, -19651.96, 19388.05 > , < -15.0095, 90.0003, 49.6067 > , false, 5000, 9, 0.9999977))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27314.24, -19702.46, 19576.37 > , < -15.0094, 90.0002, 49.6066 > , false, 5000, 9, 1.000002))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27148.35, -19899.24, 19321.75 > , < -15.0095, 90.0003, 49.6067 > , false, 5000, 9, 0.9999977))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -27314.24, -19949.73, 19510.07 > , < -15.0094, 90.0002, 49.6066 > , false, 5000, 9, 1.000003))
//  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_02.rmdl", < -27105.16, -23408.79, 19595.93 > , < 0, 0.0004, 0 > , false, 5000, 9, 1))
//  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_04_corner.rmdl", < -28192.5, -23904.79, 19595.93 > , < 0, -179.9993, 0 > , false, 5000, 9, 1))
//  NoCollisionArray.append(MapEditor_CreateProp($"mdl/desertlands/construction_bldg_platform_04_corner.rmdl", < -27105.7, -23408.79, 19595.93 > , < 0, 90.0009, 0 > , false, 5000, 9, 1))
//  NoGrappleArray.append(MapEditor_CreateProp($"mdl/desertlands/desertlands_lobby_double_doorframe_02.rmdl", < -27388.12, -23764.14, 19601.83 > , < 0, -0.0002, 0 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -27896.02, -23762.68, 19756 > , < 0, 0.0005, 89.9998 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -26691.02, -23762.65, 20395.93 > , < 0, 0.0005, 89.9998 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -26691.02, -23762.65, 19756 > , < 0, 0.0005, 89.9998 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -27320.03, -23762.66, 19756 > , < 0, 0.0005, 89.9998 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -27320.03, -23762.66, 20395.93 > , < 0, 0.0005, 89.9998 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -27896.02, -23762.68, 20395.93 > , < 0, 0.0005, 89.9998 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -27896.02, -23762.68, 19133.93 > , < 0, 0.0005, 89.9998 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -26691.02, -23762.65, 19133.93 > , < 0, 0.0005, 89.9998 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -27320.03, -23762.66, 19133.93 > , < 0, 0.0005, 89.9998 > , false, 5000, 9, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -33108.05, -11253.65, 22861.93 > , < 0, 0.0005, 89.9999 > , false, 5000, 9, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -34496.55, -11253.65, 22861.93 > , < 0, 0.0005, 89.9999 > , false, 5000, 9, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -33108.05, -11253.95, 21687.93 > , < 0, 0.0005, 89.9999 > , false, 5000, 9, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -34496.55, -11253.95, 21687.93 > , < 0, 0.0005, 89.9999 > , false, 5000, 9, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -33108.05, -11255.65, 22293.93 > , < 0, 0.0005, 89.9999 > , false, 5000, 9, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -33803.05, -11257.55, 22861.93 > , < 0, 0.0005, 89.9999 > , false, 5000, 9, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -33803.05, -11257.65, 21687.93 > , < 0, 0.0005, 89.9999 > , false, 5000, 9, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -34496.55, -11255.65, 22293.93 > , < 0, 0.0005, 89.9999 > , false, 5000, 9, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -26692.05, -13205.64, 21701.93 > , < 0, 0.0005, 89.9999 > , false, 5000, 9, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -28080.55, -13205.64, 21701.93 > , < 0, 0.0005, 89.9999 > , false, 5000, 9, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -26692.05, -13205.94, 20527.93 > , < 0, 0.0005, 89.9999 > , false, 5000, 9, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -28080.55, -13205.94, 20527.93 > , < 0, 0.0005, 89.9999 > , false, 5000, 9, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -26692.05, -13207.64, 21133.93 > , < 0, 0.0005, 89.9999 > , false, 5000, 9, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -27387.05, -13209.54, 21701.93 > , < 0, 0.0005, 89.9999 > , false, 5000, 9, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -27387.05, -13209.64, 20527.93 > , < 0, 0.0005, 89.9999 > , false, 5000, 9, 1))
//  NoClimbArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -28080.55, -13207.64, 21133.93 > , < 0, 0.0005, 89.9999 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -31434.04, -9302.648, 24605 > , < 0, 0.0005, 89.9998 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -30229.04, -9302.651, 25344.93 > , < 0, 0.0005, 89.9998 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -30229.04, -9302.651, 24605 > , < 0, 0.0005, 89.9998 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -30858.04, -9302.651, 24605 > , < 0, 0.0005, 89.9998 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -30858.04, -9302.651, 25344.93 > , < 0, 0.0005, 89.9998 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -31434.04, -9302.648, 25344.93 > , < 0, 0.0005, 89.9998 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -31434.04, -9302.648, 23902.93 > , < 0, 0.0005, 89.9998 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -30229.04, -9302.651, 23902.93 > , < 0, 0.0005, 89.9998 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -30858.04, -9302.651, 23902.93 > , < 0, 0.0005, 89.9998 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -30858.04, -9302.651, 26797.93 > , < 0, 0.0005, 89.9998 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -31434.04, -9302.648, 26095.93 > , < 0, 0.0005, 89.9998 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -30858.04, -9302.651, 26095.93 > , < 0, 0.0005, 89.9998 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -31434.04, -9302.648, 26797.93 > , < 0, 0.0005, 89.9998 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -30229.04, -9302.651, 26797.93 > , < 0, 0.0005, 89.9998 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -30229.04, -9302.651, 26095.93 > , < 0, 0.0005, 89.9998 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -30858.04, -9302.651, 22474.93 > , < 0, 0.0005, 89.9998 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -30858.04, -9302.651, 23214.93 > , < 0, 0.0005, 89.9998 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -31434.04, -9302.648, 21772.93 > , < 0, 0.0005, 89.9998 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -30858.04, -9302.651, 21772.93 > , < 0, 0.0005, 89.9998 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -31434.04, -9302.648, 22474.93 > , < 0, 0.0005, 89.9998 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -30229.04, -9302.651, 23214.93 > , < 0, 0.0005, 89.9998 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -30229.04, -9302.651, 22474.93 > , < 0, 0.0005, 89.9998 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -30229.04, -9302.651, 21772.93 > , < 0, 0.0005, 89.9998 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -31434.04, -9302.648, 23214.93 > , < 0, 0.0005, 89.9998 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -31672.04, -8348.648, 25375.93 > , < -0.0002, -89.9995, 90 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -31672.04, -8348.648, 26115.93 > , < -0.0002, -89.9995, 90 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -31672.04, -7772.648, 24673.93 > , < -0.0002, -89.9995, 90 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -31672.04, -7772.648, 26115.93 > , < -0.0002, -89.9995, 90 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -31672.04, -7772.648, 25375.93 > , < -0.0002, -89.9995, 90 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -31672.04, -8977.648, 25375.93 > , < -0.0002, -89.9995, 90 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -31672.04, -8977.648, 24673.93 > , < -0.0002, -89.9995, 90 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -31672.04, -8348.648, 24673.93 > , < -0.0002, -89.9995, 90 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -31672.04, -8977.648, 26115.93 > , < -0.0002, -89.9995, 90 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -31672.04, -7772.648, 26799.93 > , < -0.0002, -89.9995, 90 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -31672.04, -8977.648, 26799.93 > , < -0.0002, -89.9995, 90 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -31672.04, -8348.648, 26799.93 > , < -0.0002, -89.9995, 90 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -30079.04, -8400.65, 23961.93 > , < 0.0001, 90.0005, 90 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -30079.04, -8400.65, 24701.93 > , < 0.0001, 90.0005, 90 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -30079.04, -8976.65, 23259.93 > , < 0.0001, 90.0005, 90 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -30079.04, -8976.65, 24701.93 > , < 0.0001, 90.0005, 90 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -30079.04, -8976.65, 23961.93 > , < 0.0001, 90.0005, 90 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -30079.04, -7771.65, 23961.93 > , < 0.0001, 90.0005, 90 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -30079.04, -7771.65, 23259.93 > , < 0.0001, 90.0005, 90 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -30079.04, -8400.65, 23259.93 > , < 0.0001, 90.0005, 90 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -30079.04, -7771.65, 24701.93 > , < 0.0001, 90.0005, 90 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -30228.04, -7428.651, 24605 > , < 0, -179.9995, 90.0001 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -31433.04, -7428.648, 25344.93 > , < 0, -179.9995, 90.0001 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -30804.04, -7428.651, 24605 > , < 0, -179.9995, 90.0001 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -30804.04, -7428.651, 25344.93 > , < 0, -179.9995, 90.0001 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -30228.04, -7428.651, 25344.93 > , < 0, -179.9995, 90.0001 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -30804.04, -7428.651, 22474.93 > , < 0, -179.9995, 90.0001 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -30804.04, -7428.651, 23214.93 > , < 0, -179.9995, 90.0001 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -30228.04, -7428.651, 21772.93 > , < 0, -179.9995, 90.0001 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -30804.04, -7428.651, 21772.93 > , < 0, -179.9995, 90.0001 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -30228.04, -7428.651, 23214.93 > , < 0, -179.9995, 90.0001 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -30228.04, -7428.651, 23902.93 > , < 0, -179.9995, 90.0001 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -31433.04, -7428.648, 23902.93 > , < 0, -179.9995, 90.0001 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -30804.04, -7428.651, 23902.93 > , < 0, -179.9995, 90.0001 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -31433.04, -7428.648, 24605 > , < 0, -179.9995, 90.0001 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -30804.04, -7428.651, 26797.93 > , < 0, -179.9995, 90.0001 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -30228.04, -7428.651, 26095.93 > , < 0, -179.9995, 90.0001 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -30804.04, -7428.651, 26095.93 > , < 0, -179.9995, 90.0001 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -31433.04, -7428.648, 26095.93 > , < 0, -179.9995, 90.0001 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -30228.04, -7428.651, 26797.93 > , < 0, -179.9995, 90.0001 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -31433.04, -7428.648, 26797.93 > , < 0, -179.9995, 90.0001 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -30228.04, -7428.651, 22474.93 > , < 0, -179.9995, 90.0001 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -31433.04, -7428.648, 22474.93 > , < 0, -179.9995, 90.0001 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -31433.04, -7428.648, 21772.93 > , < 0, -179.9995, 90.0001 > , false, 5000, 9, 1))
//  ClipArray.append(MapEditor_CreateProp($"mdl/desertlands/highrise_square_top_01.rmdl", < -31433.04, -7428.648, 23214.93 > , < 0, -179.9995, 90.0001 > , false, 5000, 9, 1))
//
//  foreach(entity ent in ClipArray) {
//    ent.MakeInvisible()
//    ent.kv.solid = 6
//    ent.kv.CollisionGroup = TRACE_COLLISION_GROUP_PLAYER
//    ent.kv.contents = CONTENTS_PLAYERCLIP
//  }
//
//  //Secondary Glow
//  foreach(entity ent in NoClimbArray) {
//    ent.Highlight_SetFunctions(0, 136, false, 136, 3.0, 2, false)
//    ent.Highlight_SetParam(0, 0, < darkrampr, darkrampg, darkrampb > )
//  }
//
//  //Main Glow
//  foreach(entity ent in NoGrappleArray) {
//    ent.Highlight_SetFunctions(0, 136, false, 136, 3.0, 2, false)
//    ent.Highlight_SetParam(0, 0, < rampr, rampg, rampb > )
//  }
//
//  //Outline Glow
//  foreach(entity ent in NoCollisionArray) {
//    ent.Highlight_SetFunctions(0, 0, false, 136, 3.0, 2, false)
//    ent.Highlight_SetParam(0, 0, < rampr, rampg, rampb > )
//  }
//
//  // Buttons
//  AddCallback_OnUseEntity(CreateSurfButton( < -27393.6, -23570.1, 19595.2 > , < 0, 180, 0 > , "%use% Stop Timer"), void
//    function (entity panel, entity user, int input) {
//      //Stop timer Button
//      if (user.p.isTimerActive == true) {
//        user.p.finalTime = floor(Time()).tointeger() - user.p.startTime
//
//        int seconds = user.p.finalTime
//        if (seconds > 59) {
//
//          //Whacky conversion
//          int minutes = seconds / 60
//          int realseconds = seconds - (minutes * 60)
//
//          //Display player Time
//          Message(user, "Your Final Time: " + minutes + ":" + realseconds)
//
//          //Add to results file
//          string finalTime = user.GetPlatformUID() + "|" + user.GetPlayerName() + "|" + minutes + ":" + realseconds + "|" + GetUnixTimestamp() + "|Map3"
//          file.allTimes.append(finalTime)
//
//          //Reset Timer
//          user.p.isTimerActive = false
//          user.p.startTime = 0
//	  
//	  Remote_CallFunction_NonReplay( user, "MG_StopWatch_toggle", false)
//
//        } else {
//
//          //Display player Time
//          Message(user, "Your Final Time: " + seconds + " seconds")
//
//          //Add to results file
//          string finalTime = user.GetPlatformUID() + "|" + user.GetPlayerName() + "|" + "0:" + seconds + "|" + GetUnixTimestamp() + "|Map3"
//          file.allTimes.append(finalTime)
//
//          //Reset Timer
//          user.p.isTimerActive = false
//          user.p.startTime = 0
//	  
//	  Remote_CallFunction_NonReplay( user, "MG_StopWatch_toggle", false)
//        }
//      }
//    })
//
//  // Triggers
//  entity trigger_0 = MapEditor_CreateTrigger( < -27390.14, -23984.31, 19650.43 > , < 0, -90, 0 > , 237.05, 50, false)
//  trigger_0.SetEnterCallback(void
//    function (entity trigger, entity ent) {
//      EmitSoundOnEntityOnlyToPlayer(ent, ent, FIRINGRANGE_BUTTON_SOUND)
//      TeleportFRPlayer(ent, < 10726.9000, 10287, -4283 > , < 0, -89.9998, 0 > )
//      StatusEffect_StopAllOfType(ent, eStatusEffect.stim_visual_effect)
//      StatusEffect_StopAllOfType(ent, eStatusEffect.speed_boost)
//      ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
//      ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
//      ent.GiveOffhandWeapon("mp_ability_phase_walk", OFFHAND_TACTICAL)
//      ent.PhaseShiftCancel()
//      //Start Checkpoint
//      ent.p.allowCheckpoint = false
//      ent.p.currentCheckpoint = 0
//      //Reset Timer
//      ent.p.isTimerActive = false
//      ent.p.startTime = 0
//      
//      Remote_CallFunction_NonReplay( ent, "MG_StopWatch_toggle", false)
//
//      //Re-enable invis after surf
//      ent.p.isPlayerInvisAllowed = true
//      if (ent.IsInRealm(1) != true || ent.IsInRealm(2) != true) {
//        ent.RemoveFromAllRealms()
//        ent.AddToRealm(1)
//        ent.MakeVisible()
//        Message(ent, "Hub", "You are now Visible")
//      }
//
//      //Force Default Player Settings
//      SetPlayerSettings(ent, TDM_PLAYER_SETTINGS)
//    })
//  DispatchSpawn(trigger_0)
//
//}

//╔╦╗╔═╗╔═╗╔╦╗╦╔╗╔╔═╗
// ║ ║╣ ╚═╗ ║ ║║║║║ ╦
// ╩ ╚═╝╚═╝ ╩ ╩╝╚╝╚═╝


void function _Classic_Movement(entity ent){
	
	if(Flowstate_MovementGym_ClassicMovement() != true)
		return
	
	switch(Flowstate_MovementGym_ClassicMovement_Type()){
		//Movement Speed CSGO
		case 1:
			StatusEffect_AddEndless(ent, eStatusEffect.move_slow, 0.1)
			ent.SetMoveSpeedScale(1.38854974986041364747)
			ent.DisableMantle()
			ent.SetGroundFrictionScale(1.03125)
			ClientCommand(ent, "_setClassVarServer acceleration 550")
			ClientCommand(ent, "_setClassVarServer slideRequiredStartSpeed 9999999")
			ClientCommand(ent, "_setClassVarServer slideSpeedBoostCap 0")
			ClientCommand(ent, "_setClassVarServer slideSpeedBoost 0")
			ClientCommand(ent, "_setClassVarServer slideVelocityDecay 0.1")
			ClientCommand(ent, "_setClassVarServer climbheight 0")
			ClientCommand(ent, "_setClassVarServer slideSpeedBoostCap 0")
			ClientCommand(ent, "_setClassVarServer antiMultiJumpHeightFrac 1")
			ClientCommand(ent, "_setClassVarServer automantle_enable 0")
			ClientCommand(ent, "_setClassVarServer wallrun 0")
			ClientCommand(ent, "_setClassVarServer airacceleration 1200")
			ClientCommand(ent, "_setClassVarServer jumpheight 55")
			ClientCommand(ent, "_setClassVarServer gravityscale 1.25")
			ClientCommand(ent, "_setClassVarServer skip_speed_reduce 0")
			ClientCommand(ent, "_setClassVarServer airspeed 30")
			break
		//Movement Speed HL1
		case 2:
			StatusEffect_AddEndless(ent, eStatusEffect.move_slow, 0.1)
			ent.SetMoveSpeedScale(1.77840093365762835808)
			ent.DisableMantle()
			ClientCommand(ent, "_setClassVarServer acceleration 1000")
			ClientCommand(ent, "_setClassVarServer slideRequiredStartSpeed 9999999")
			ClientCommand(ent, "_setClassVarServer slideSpeedBoostCap 0")
			ClientCommand(ent, "_setClassVarServer slideSpeedBoost 0")
			ClientCommand(ent, "_setClassVarServer slideVelocityDecay 0.1")
			ClientCommand(ent, "_setClassVarServer climbheight 0")
			ClientCommand(ent, "_setClassVarServer antiMultiJumpHeightFrac 1")
			ClientCommand(ent, "_setClassVarServer automantle_enable 0")
			ClientCommand(ent, "_setClassVarServer wallrun 0")
			ClientCommand(ent, "_setClassVarServer airacceleration 10000")
			ClientCommand(ent, "_setClassVarServer jumpheight 45")
			ClientCommand(ent, "_setClassVarServer gravityscale 1.25")
			ClientCommand(ent, "_setClassVarServer skip_speed_reduce 0")
			ClientCommand(ent, "_setClassVarServer airspeed 15")
			break
		case 3:
			StatusEffect_AddEndless(ent, eStatusEffect.move_slow, 0.1)
			ent.SetMoveSpeedScale(1.77840093365762835808)
			ent.DisableMantle()
			ClientCommand(ent, "_setClassVarServer acceleration 1000")
			ClientCommand(ent, "_setClassVarServer slideRequiredStartSpeed 9999999")
			ClientCommand(ent, "_setClassVarServer slideSpeedBoostCap 0")
			ClientCommand(ent, "_setClassVarServer slideSpeedBoost 0")
			ClientCommand(ent, "_setClassVarServer slideVelocityDecay 0.1")
			ClientCommand(ent, "_setClassVarServer climbheight 0")
			ClientCommand(ent, "_setClassVarServer antiMultiJumpHeightFrac 1")
			ClientCommand(ent, "_setClassVarServer automantle_enable 0")
			ClientCommand(ent, "_setClassVarServer wallrun 0")
			ClientCommand(ent, "_setClassVarServer airacceleration 1000")
			ClientCommand(ent, "_setClassVarServer jumpheight 21")
			ClientCommand(ent, "_setClassVarServer gravityscale 0.8")
			ClientCommand(ent, "_setClassVarServer skip_speed_reduce 0")
			ClientCommand(ent, "_setClassVarServer airspeed 15")
			break	
	}
}

void function _Classic_Movement_ABH(entity clientPlayer) {
	while (true) {
		if (IsValid(clientPlayer) && clientPlayer.IsPlayer() && clientPlayer.GetPhysics() != MOVETYPE_NOCLIP && !clientPlayer.IsOnGround()) {
			local forwardVector = clientPlayer.GetForwardVector()
			local velocity = clientPlayer.GetVelocity()

			local generalVelocity = velocity.Length()
			local dotProduct = velocity.Dot(forwardVector)

			switch(true) {
				
				case generalVelocity > 450:
					local velocityMultiplier = (dotProduct > 0) ? 1 : 1.05
					local modifiedVelocity = velocity * velocityMultiplier
	
					clientPlayer.SetVelocity(modifiedVelocity)
					break
				case generalVelocity > 350 && generalVelocity < 450:
					local velocityMultiplier = (dotProduct > 0) ? 0.9 : 1.25
					local modifiedVelocity = velocity * velocityMultiplier
	
					clientPlayer.SetVelocity(modifiedVelocity)
					break
			}
		}

		WaitFrame()
	}
}
