untyped

globalize_all_functions

void
function door_map_precache() {

    PrecacheModel( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl" )
    PrecacheModel( $"mdl/thunderdome/thunderdome_cage_ceiling_256x64_04.rmdl" )
    PrecacheModel( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_02.rmdl" )
    PrecacheModel( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl" )
    PrecacheModel( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape.rmdl" )
    PrecacheModel( $"mdl/barriers/concrete/concrete_barrier_01.rmdl" )
    PrecacheModel( $"mdl/desertlands/construction_bldg_platform_01.rmdl" )
    PrecacheModel( $"mdl/industrial/landing_mat_metal_03_large.rmdl" )
    PrecacheModel( $"mdl/desertlands/desertlands_lobby_double_doorframe_01.rmdl" )
    PrecacheModel( $"mdl/desertlands/desertlands_lobby_double_doorframe_02.rmdl" )
    PrecacheModel( $"mdl/door/canyonlands_door_single_02_hinges.rmdl" )
    PrecacheModel( $"mdl/pipes/pipe_modular_painted_red_128.rmdl" )
    PrecacheModel( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl" )
    PrecacheModel( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl" )
    PrecacheModel( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl" )
    PrecacheModel( $"mdl/desertlands/desertlands_lobby_doorframe_02.rmdl" )
    PrecacheModel( $"mdl/desertlands/desertlands_lobby_doorframe.rmdl" )
    PrecacheModel( $"mdl/pipes/pipe_modular_painted_red_02_64.rmdl" )
    PrecacheModel( $"mdl/desertlands/industrial_metal_frame_wall_32x144_01.rmdl" )
    PrecacheModel( $"mdl/desertlands/industrial_metal_frame_wall_128x144_04.rmdl" )
    PrecacheModel( $"mdl/industrial/landing_mat_metal_02.rmdl" )
    PrecacheModel( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl" )
    PrecacheModel( $"mdl/beacon/beacon_fence_sign_01.rmdl" )
    PrecacheModel( $"mdl/thunderdome/thunderdome_cage_frame_256_01.rmdl" )
    PrecacheModel( $"mdl/barriers/concrete/concrete_barrier_fence.rmdl" )
    PrecacheModel( $"mdl/pipes/pipe_modular_painted_red_64.rmdl" )
}


struct {
  array < entity > lootbins
  array < entity > door_list

  table<entity, vector> cp_table = {}
  vector first_cp = < 0.23, -1.96, 14898.73 >
}
file

void
function door_map_init() {
    // AddClientCommandCallback("runrestart", ClientCommand_runrestart)
	AddCallback_OnClientConnected( TeleportPlayer )
	AddCallback_EntitiesDidLoad( DoorMapEntitiesDidLoad )
	door_map_precache()
}

void function DoorMapEntitiesDidLoad( )
{
	thread door_map()
	thread lootbins()
	thread lootbins_buttons()
	thread doors()
}

void function TeleportPlayer( entity player )
{
	if( !IsValid( player ) )
		return
    array<ItemFlavor> characters = GetAllCharacters()

	player.SetOrigin(file.first_cp)
	CharacterSelect_AssignCharacter(ToEHI(player), characters[8])

	TakeAllPassives( player )
	TakeAllWeapons( player )
	player.GiveWeapon("mp_weapon_melee_survival", WEAPON_INVENTORY_SLOT_PRIMARY_2, [])
	player.GiveOffhandWeapon("melee_pilot_emptyhanded", OFFHAND_MELEE, [])
	player.SetPlayerNetBool("pingEnabled", false)
    player.SetPersistentVar("gen", 0)

	Message(player, "Welcome to the Door Map!")
	SpawnInfoText( player )
}

// bool function ClientCommand_runrestart(entity player, array<string> args)
// {
	// if( !IsValid( player ) )
		// return

    // Message(player, "run restarted!")
    // player.SetPersistentVar("gen", 0)
    // player.SetOrigin(file.first_cp)
    // ResetDoors()
    // destroy_lootbins()

    // return true
// }


void
function SpawnInfoText( entity player ) {

	CreatePanelText(player, "1", "forward", < 0.23, 359.44, 15038.53 >, < 0, 90, 0 >, false, 1)
	CreatePanelText(player, "2", "right", < 1.7361, 1296.582, 15037.6 >, < 0, 89.6289, 0 >, false, 1)
	CreatePanelText(player, "3", "left", < 809.8999, 1462.2, 15033 >, < 0, 0, 0 >, false, 1)
	CreatePanelText(player, "4", "up", < 1146.9, 2158.5, 15031.6 >, < 0, 0, 0 >, false, 1)
	CreatePanelText(player, "5", "up", < 695.3042, 2158.8, 15158.9 >, < 0, -180, 0 >, false, 1)
	CreatePanelText(player, "6", "left", < 1146.704, 2153.5, 15299.5 >, < 0, 0, 0 >, false, 1)
	CreatePanelText(player, "7", "right", < 678.6013, 2203.906, 15440 >, < 0, -180, 0 >, false, 1)
	CreatePanelText(player, "8", "forward", < 1391.3, 2499.7, 15584.1 >, < 0, 0, 0 >, false, 1)
	CreatePanelText(player, "9", "right", < 2312.2, 2502.1, 15584.1 >, < 0, 0, 0 >, false, 1)
	CreatePanelText(player, "10", "right", < 2557.3, 1768, 15694 >, < 0, -90, 0 >, false, 1)
	CreatePanelText(player, "11", "right", < 2329.9, 2231.1, 15840.1 >, < 0, 90, 0 >, false, 1)
	CreatePanelText(player, "12", "forward", < 2557.3, 1768, 15982 >, < 0, -90, 0 >, false, 1)
	CreatePanelText(player, "13", "forward", < 2508.9, 805.1036, 15982.89 >, < 0, -90, 0 >, false, 1)
	CreatePanelText(player, "14", "forward", < 2511.8, 130.1001, 15980.24 >, < 0, -90, 0 >, false, 1)
	CreatePanelText(player, "15", "left", < 2511.399, -509.1964, 15980.24 >, < 0, -90, 0 >, false, 1)
	CreatePanelText(player, "16", "right", < 2998.8, -914.4966, 15976.5 >, < 0, -90, 0 >, false, 1)
	CreatePanelText(player, "17", "up", < 2583.516, -1340.868, 15983.97 >, < 0, -90, 0 >, false, 1)
	CreatePanelText(player, "18", "forward", < 1685.2, -1187.218, 16096.22 >, < 0, -180, 20 >, false, 1)
	CreatePanelText(player, "19", "forward", < 757.1541, -1267.28, 16100.17 >, < 0, -180, -15 >, false, 1)
	CreatePanelText(player, "20", "forward", < -130.1465, -1232.896, 15970.39 >, < 20, -180, 0 >, false, 1)
	CreatePanelText(player, "21", "forward", < -1373.523, -1192.61, 16034.23 >, < 0, -180, 0 >, false, 1)
	CreatePanelText(player, "22", "up", < -1946.399, -1234.21, 16158.97 >, < 0, -180, 0 >, false, 1)
	CreatePanelText(player, "23", "forward", < -2008.553, -1234.21, 16556.62 >, < 0, -180, 0 >, false, 1)
	CreatePanelText(player, "24", "up", < -3030.099, -1234.21, 16526.93 >, < 0, -180, 0 >, false, 1)
	CreatePanelText(player, "25", "forward", < -2711.399, -358.8946, 17086.04 >, < 0, 90, 0 >, false, 1)
	CreatePanelText(player, "26", "forward", < -2828.199, 635.2054, 17225.34 >, < 0, 90, 0 >, false, 1)
	CreatePanelText(player, "27", "left", < -2831.899, 1633.906, 17380.26 >, < 0, 90, 0 >, false, 1)
	CreatePanelText(player, "28", "right", < -3031.799, 2445.006, 17519.66 >, < 0, 90, 0 >, false, 1)
	CreatePanelText(player, "29", "left", < -2307.202, 2780.404, 17561.71 >, < 0, 0, 0 >, false, 1)
	CreatePanelText(player, "30", "left", < -2192.393, 3687.328, 17561.71 >, < 0, 0, 0 >, false, 1)
	CreatePanelText(player, "31", "forward", < -2185.993, 4860.828, 17712.3 >, < 0, 0, 0 >, false, 1)
	CreatePanelText(player, "32", "left", < -1441.793, 4762.328, 17712.3 >, < 0, -90, 0 >, false, 1)
	CreatePanelText(player, "33", "up", < -926.0934, 3991.628, 17579.41 >, < 0, -90, 0 >, false, 1)
	CreatePanelText(player, "34", "forward", < -926.095, 3674.026, 17946.8 >, < 0, -90, 0 >, false, 1)
	CreatePanelText(player, "35", "left", < -926.0933, 2880.628, 18294.15 >, < 0, -90, 0 >, false, 1)
	CreatePanelText(player, "36", "forward", < 137.6069, 2358.228, 17994.05 >, < 0, 0, 0 >, false, 1)
	CreatePanelText(player, "37", "forward", < 1174.307, 2358.525, 18285.61 >, < 0, 0, 0 >, false, 1)
	CreatePanelText(player, "38", "left", < 1930.58, 2357.525, 18625.11 >, < 0, 0, 0 >, false, 1)
	CreatePanelText(player, "39", "left", < 1930.584, 2703.522, 18836.21 >, < 0, 0, 0 >, false, 1)
	CreatePanelText(player, "40", "left", < 1737.381, 3049.821, 19047.61 >, < 0, 180, 0 >, false, 1)
	CreatePanelText(player, "41", "left", < 1737.379, 2703.821, 19258.71 >, < 0, 180, 0 >, false, 1)
	CreatePanelText(player, "42", "left", < 1737.38, 2358.223, 19469.21 >, < 0, 180, 0 >, false, 1)
	CreatePanelText(player, "43", "up", < 1837.904, 1928.428, 19637.9 >, < 0, -90.0002, 0 >, false, 1)
	CreatePanelText(player, "44", "forward", < 1837.905, 739.2283, 19695.3 >, < 0, -90.0001, 0 >, false, 1)
	CreatePanelText(player, "Loy and Treeree", "Made by", < 116.8301, 273.84, 15029.93 >, < 0, 0, 0 >, true, 1)
	CreatePanelText(player, "youtube.com/Treeree", "For map walkthrough!", < -107.8701, 273.84, 15029.93 >, < 0, -180, 0 >, true, 1)

}


void
function lootbins() {
    // Loot Bins
    file.lootbins.append(MapEditor_CreateLootBin( < 1837.905, 703.6001, 19629.3 >, < 0, -90.0001, 0 >, 0 ))


}

void
function doors() {
    file.door_list.clear()

    // Single Doors
    file.door_list.extend(MapEditor_SpawnDoor( < -2827.399, 705.4054, 17050.2 >, < 0, -90.0001, 0 >, eMapEditorDoorType.Single, true, false ))
    file.door_list.extend(MapEditor_SpawnDoor( < -2715.499, -289.4946, 16910.9 >, < 0, 90, 0 >, eMapEditorDoorType.Single, true, false ))
    file.door_list.extend(MapEditor_SpawnDoor( < -2826.899, 1701.406, 17189.6 >, < 0, -90.0001, 0 >, eMapEditorDoorType.Single, true, false ))
    file.door_list.extend(MapEditor_SpawnDoor( < 744.316, -1210.406, 15996.33 >, < 0, -180, -15 >, eMapEditorDoorType.Single, true, false ))
    file.door_list.extend(MapEditor_SpawnDoor( < 1672.816, -1252.007, 15998.83 >, < 0, 0, -20 >, eMapEditorDoorType.Single, true, false ))
    file.door_list.extend(MapEditor_SpawnDoor( < -3036.799, 2512.406, 17329 >, < 0, 89.9999, 0 >, eMapEditorDoorType.Single, true, false ))
    file.door_list.extend(MapEditor_SpawnDoor( < 2478.5, 792.6993, 15865.99 >, < 0, -90, 0 >, eMapEditorDoorType.Single, true, false ))
    file.door_list.extend(MapEditor_SpawnDoor( < 2481.8, 115.5958, 15864.24 >, < 0, -90, 0 >, eMapEditorDoorType.Single, true, false ))
    file.door_list.extend(MapEditor_SpawnDoor( < 2481.399, -520.8008, 15864.24 >, < 0, -90, 0 >, eMapEditorDoorType.Single, true, false ))
    file.door_list.extend(MapEditor_SpawnDoor( < 2971.6, -925.7967, 15860.14 >, < 0, -90, 0 >, eMapEditorDoorType.Single, true, false ))
    file.door_list.extend(MapEditor_SpawnDoor( < 2879.3, -692.7003, 15860.13 >, < 0, -180, 0 >, eMapEditorDoorType.Single, true, false ))
    file.door_list.extend(MapEditor_SpawnDoor( < 2701.616, -1177.468, 15867.27 >, < 0, 0, 0 >, eMapEditorDoorType.Single, true, false ))
    file.door_list.extend(MapEditor_SpawnDoor( < 2554.716, -1352.768, 15867.44 >, < 0, -90, 0 >, eMapEditorDoorType.Single, true, false ))
    file.door_list.extend(MapEditor_SpawnDoor( < 2554.715, -1352.772, 16006.64 >, < 0, -90, 0 >, eMapEditorDoorType.Single, true, false ))
    file.door_list.extend(MapEditor_SpawnDoor( < -101.8206, -1202.496, 15856.3 >, < 20, -180, 0 >, eMapEditorDoorType.Single, true, false ))
    file.door_list.extend(MapEditor_SpawnDoor( < -1394.321, -1192.804, 15913.93 >, < 20, -180, 0 >, eMapEditorDoorType.Single, true, false ))
    file.door_list.extend(MapEditor_SpawnDoor( < -1992.799, -1183.91, 16033.5 >, < 0, 0, 90 >, eMapEditorDoorType.Single, true, false ))
    file.door_list.extend(MapEditor_SpawnDoor( < -1987.699, -1285.908, 16142.63 >, < 0, -180, 90 >, eMapEditorDoorType.Single, true, false ))
    file.door_list.extend(MapEditor_SpawnDoor( < -1948.099, -1285.908, 16268.72 >, < 0, -180, 90 >, eMapEditorDoorType.Single, true, false ))
    file.door_list.extend(MapEditor_SpawnDoor( < -2139.423, -1286.606, 16495.15 >, < 69.7133, -2.7827, -92.6098 >, eMapEditorDoorType.Single, true, true ))
    file.door_list.extend(MapEditor_SpawnDoor( < -2208.011, -1286.605, 16469.87 >, < 69.7133, -2.7827, -92.6098 >, eMapEditorDoorType.Single, true, true ))
    file.door_list.extend(MapEditor_SpawnDoor( < -2271.108, -1286.605, 16447.33 >, < 69.7133, -2.7827, -92.6098 >, eMapEditorDoorType.Single, true, true ))
    file.door_list.extend(MapEditor_SpawnDoor( < -2082.178, -1286.61, 16515.35 >, < 70, 0, -90 >, eMapEditorDoorType.Single, true, true ))
    file.door_list.extend(MapEditor_SpawnDoor( < -2919.199, -1107.21, 16541.48 >, < 90, -180, 0 >, eMapEditorDoorType.Single, true, true ))
    file.door_list.extend(MapEditor_SpawnDoor( < -3016.099, -1270.71, 16644.78 >, < 90, -90, 0 >, eMapEditorDoorType.Single, true, true ))
    file.door_list.extend(MapEditor_SpawnDoor( < -2781.999, -1198.279, 16862.38 >, < 90, 90, 0 >, eMapEditorDoorType.Single, true, true ))
    file.door_list.extend(MapEditor_SpawnDoor( < -2878.599, -1363.91, 16756.48 >, < 90, 0, 0 >, eMapEditorDoorType.Single, true, true ))

    // Double Doors
    file.door_list.extend(MapEditor_SpawnDoor( < -1, 372.4, 14914.7 >, < 0, -90, 0 >, eMapEditorDoorType.Double, true, false ))
    file.door_list.extend(MapEditor_SpawnDoor( < 0.5901, 1309.549, 14913.77 >, < 0, -90.3712, 0 >, eMapEditorDoorType.Double, true, false ))
    file.door_list.extend(MapEditor_SpawnDoor( < 824.5901, 1462.2, 14915.07 >, < 0, 0, 0 >, eMapEditorDoorType.Double, true, false ))
    file.door_list.extend(MapEditor_SpawnDoor( < 331.0098, 1462.4, 14915.07 >, < 0, -180, 0 >, eMapEditorDoorType.Double, true, false ))
    file.door_list.extend(MapEditor_SpawnDoor( < 1045, 1787.6, 14915.9 >, < 0, -90, 0 >, eMapEditorDoorType.Double, true, false ))
    file.door_list.extend(MapEditor_SpawnDoor( < 1163.94, 2158.266, 14915.9 >, < 0, 0, 0 >, eMapEditorDoorType.Double, true, false ))
    file.door_list.extend(MapEditor_SpawnDoor( < 668.2442, 2157.57, 15045.27 >, < 0, 0, 0 >, eMapEditorDoorType.Double, true, false ))
    file.door_list.extend(MapEditor_SpawnDoor( < 1159.664, 2154.73, 15175.67 >, < 0, -180, 0 >, eMapEditorDoorType.Double, true, false ))
    file.door_list.extend(MapEditor_SpawnDoor( < 667.71, 2201.588, 15322.07 >, < 0, 0, 0 >, eMapEditorDoorType.Double, true, false ))
    file.door_list.extend(MapEditor_SpawnDoor( < 1160.79, 2312.488, 15322.07 >, < 0, 0, 0 >, eMapEditorDoorType.Double, true, false ))
    file.door_list.extend(MapEditor_SpawnDoor( < 667.21, 2446.6, 15465.97 >, < 0, -180, 0 >, eMapEditorDoorType.Double, true, false ))
    file.door_list.extend(MapEditor_SpawnDoor( < 1412.9, 2502, 15466.1 >, < 0, 180, 0 >, eMapEditorDoorType.Double, true, true ))
    file.door_list.extend(MapEditor_SpawnDoor( < 2321.6, 2501.6, 15466.1 >, < 0, 180, 0 >, eMapEditorDoorType.Double, true, true ))
    file.door_list.extend(MapEditor_SpawnDoor( < 2561.4, 1753.71, 15576.07 >, < 0, 90, 0 >, eMapEditorDoorType.Double, true, true ))
    file.door_list.extend(MapEditor_SpawnDoor( < 2451.5, 2246.79, 15576.07 >, < 0, 90, 0 >, eMapEditorDoorType.Double, true, false ))
    file.door_list.extend(MapEditor_SpawnDoor( < 2325.8, 2245.39, 15722.17 >, < 0, -90, 0 >, eMapEditorDoorType.Double, true, true ))
    file.door_list.extend(MapEditor_SpawnDoor( < 2435.7, 1752.31, 15722.17 >, < 0, -90, 0 >, eMapEditorDoorType.Double, true, true ))
    file.door_list.extend(MapEditor_SpawnDoor( < 2561.4, 1753.71, 15864.07 >, < 0, 90, 0 >, eMapEditorDoorType.Double, true, true ))
    file.door_list.extend(MapEditor_SpawnDoor( < 2451.5, 2246.79, 15864.07 >, < 0, 90, 0 >, eMapEditorDoorType.Double, true, true ))
    file.door_list.extend(MapEditor_SpawnDoor( < -2477.336, -1235.81, 16373.33 >, < 0, -180, 0 >, eMapEditorDoorType.Double, true, false ))
    file.door_list.extend(MapEditor_SpawnDoor( < -2777.199, -1233.61, 16436.13 >, < 0, -180, 0 >, eMapEditorDoorType.Double, true, false ))

    // Horizontal Doors
    file.door_list.extend(MapEditor_SpawnDoor( < -2569.802, 2782.404, 17471.61 >, < 0, 0, 0 >, eMapEditorDoorType.Horizontal, false, true ))
    file.door_list.extend(MapEditor_SpawnDoor( < -2457.479, 3687.816, 17469.91 >, < 0, 0, 0 >, eMapEditorDoorType.Horizontal, false, true ))
    file.door_list.extend(MapEditor_SpawnDoor( < -2166.494, 4862.027, 17469.91 >, < 0, 0, 0 >, eMapEditorDoorType.Horizontal, false, true ))
    file.door_list.extend(MapEditor_SpawnDoor( < 1181.007, 2487.125, 18158.71 >, < 0, 0, 90 >, eMapEditorDoorType.Horizontal, false, false ))
    file.door_list.extend(MapEditor_SpawnDoor( < 139.8194, 2358.716, 17944.23 >, < 0, -90, -140 >, eMapEditorDoorType.Horizontal, false, false ))
    file.door_list.extend(MapEditor_SpawnDoor( < -1056.693, 4236.128, 17471.01 >, < 0, 90, 90 >, eMapEditorDoorType.Horizontal, false, true ))
    file.door_list.extend(MapEditor_SpawnDoor( < -795.495, 3667.526, 17819.93 >, < 0, -90.0001, 90 >, eMapEditorDoorType.Horizontal, false, true ))
    file.door_list.extend(MapEditor_SpawnDoor( < 1956.58, 2230.225, 18433.51 >, < 0, 180, 90 >, eMapEditorDoorType.Horizontal, false, false ))
    file.door_list.extend(MapEditor_SpawnDoor( < 1711.381, 3177.121, 18856.01 >, < 0, 0, 90 >, eMapEditorDoorType.Horizontal, false, false ))
    file.door_list.extend(MapEditor_SpawnDoor( < -460.1806, 2485.916, 18012.23 >, < 0, 0, 90 >, eMapEditorDoorType.Horizontal, false, true ))
    file.door_list.extend(MapEditor_SpawnDoor( < 1710.604, 1920.928, 19502.3 >, < 0, 89.9999, 90 >, eMapEditorDoorType.Horizontal, false, false ))
    file.door_list.extend(MapEditor_SpawnDoor( < -1441.793, 4740.728, 17469.91 >, < 0, -90, 0 >, eMapEditorDoorType.Horizontal, false, true ))
    file.door_list.extend(MapEditor_SpawnDoor( < 1711.381, 2485.523, 19277.61 >, < 0, 0, 90 >, eMapEditorDoorType.Horizontal, false, false ))
    file.door_list.extend(MapEditor_SpawnDoor( < 1711.379, 2831.121, 19067.11 >, < 0, 0, 90 >, eMapEditorDoorType.Horizontal, false, false ))
    file.door_list.extend(MapEditor_SpawnDoor( < 1956.584, 2576.222, 18644.61 >, < 0, 180, 90 >, eMapEditorDoorType.Horizontal, false, false ))
    file.door_list.extend(MapEditor_SpawnDoor( < 1708.905, 1926.028, 19743.61 >, < -90, 179.9998, 0 >, eMapEditorDoorType.Horizontal, false, true ))
    file.door_list.extend(MapEditor_SpawnDoor( < -926.0933, 2872.428, 18038.35 >, < 0, -90, 0 >, eMapEditorDoorType.Horizontal, false, true ))



    }

void
function lootbins_buttons() {
    // Buttons
    AddCallback_OnUseEntity( CreateFRButton(< 107.3301, 124.84, 14914.9 >, < 0, -90, 0 >, "%use% Start Timer"), void function(entity panel, entity user, int input)
    {
	if (user.GetPersistentVar("gen") == 0) {
        array<ItemFlavor> characters = GetAllCharacters()
		CharacterSelect_AssignCharacter(ToEHI(user), characters[8])
		user.TakeOffhandWeapon(OFFHAND_TACTICAL)
		user.TakeOffhandWeapon(OFFHAND_ULTIMATE)
		user.SetPersistentVar( "gen", Time() )
		Message(user, "Timer Started!" )
	} else {
		user.SetPersistentVar("gen", 0)
		Message(user, "Timer Stopped!")
	}
    })

    AddCallback_OnUseEntity( CreateFRButton(< 1837.905, 129.0281, 19747.3 >, < 0, -180, 0 >, "%use% Stop Timer"), void function(entity panel, entity user, int input)
    {
      int reset = 0
	file.cp_table[user] <- < 0.23, -1.96, 14976.83 > 
      if (user.GetPersistentVarAsInt("gen") != reset) {
        user.SetPersistentVar("xp", Time() - user.GetPersistentVarAsInt("gen"))
        int seconds = user.GetPersistentVarAsInt("xp")
        if (seconds > 59) {
          
	  //Whacky conversion
	  int minutes = seconds / 60
          int realseconds = seconds - (minutes * 60)
          
	  //Display player Time
	  Message(user, "Your Final Time: " + minutes + ":" + realseconds)
	  
	  //Add to results file
	  //string finalTime = user.GetPlatformUID()+ "|" + user.GetPlayerName() + "|" + minutes + ":" + realseconds + "|" + GetUnixTimestamp() + "|Map3"
	  //file.allTimes.append(finalTime)
	  
	  //Reset Timer
          user.SetPersistentVar("gen", reset)
	  
        } else { 
	  
	  //Display player Time
          Message(user, "Your Final Time: " + seconds + " seconds")
	  
	  //Add to results file
	  //string finalTime = user.GetPlatformUID()+ "|" + user.GetPlayerName() + "|" + "0:" + seconds + "|" + GetUnixTimestamp() + "|Map3"
	  //file.allTimes.append(finalTime)
	  
	  //Reset Timer
          user.SetPersistentVar("gen", reset)
	  }
}
    })

    AddCallback_OnUseEntity( CreateFRButton(< -112.47, 124.84, 14915.13 >, < 0, 90, 0 >, "%use% Skip jump"), void function(entity panel, entity user, int input)
    {
        if (IsValid(user)) {
            if (user.IsPlayer() && user.GetPhysics() != MOVETYPE_NOCLIP) {
                if (user.GetPersistentVarAsInt("gen") == 0) {
                    user.SetOrigin(< -54.6, 932.9, 14968.2 >)
                } else {
                    Message(user, "Can't skip while Timer is running!")
                }
            }
        }
    })

    AddCallback_OnUseEntity( CreateFRButton(< -106.8, 933.2, 14914.2 >, < 0, 89.6289, 0 >, "%use% Skip jump"), void function(entity panel, entity user, int input)
    {
if (IsValid(user)) {
	if (user.IsPlayer() && user.GetPhysics() != MOVETYPE_NOCLIP) {
if (user.GetPersistentVarAsInt("gen") == 0) {
		user.SetOrigin(< 449, 1513, 14960.8 >)
	} else {
            Message(user, "Can't skip while Timer is running!")
        }
}
    }})

    AddCallback_OnUseEntity( CreateFRButton(< 449, 1567.4, 14915.5 >, < 0, 0, 0 >, "%use% Skip jump"), void function(entity panel, entity user, int input)
    {
if (IsValid(user)) {
	if (user.IsPlayer() && user.GetPhysics() != MOVETYPE_NOCLIP) {
if (user.GetPersistentVarAsInt("gen") == 0) {
		user.SetOrigin(< 984, 1906, 14953.2 >)
	} else {
            Message(user, "Can't skip while Timer is running!")
        }
}
    }})

    AddCallback_OnUseEntity( CreateFRButton(< 936, 1906, 14916.1 >, < 0, 90, 0 >, "%use% Skip jump"), void function(entity panel, entity user, int input)
    {
if (IsValid(user)) {
	if (user.IsPlayer() && user.GetPhysics() != MOVETYPE_NOCLIP) {
if (user.GetPersistentVarAsInt("gen") == 0) {
		user.SetOrigin(< 1041.8, 2098, 15096 >)
	} else {
            Message(user, "Can't skip while Timer is running!")
        }
}
    }})

    AddCallback_OnUseEntity( CreateFRButton(< 1041.8, 2046.1, 15045.7 >, < 0, -180, 0 >, "%use% Skip jump"), void function(entity panel, entity user, int input)
    {
if (IsValid(user)) {
	if (user.IsPlayer() && user.GetPhysics() != MOVETYPE_NOCLIP) {
if (user.GetPersistentVarAsInt("gen") == 0) {
		user.SetOrigin(< 784.8, 2217.1, 15229.3 >)
	} else {
            Message(user, "Can't skip while Timer is running!")
        }
}
    }})

    AddCallback_OnUseEntity( CreateFRButton(< 784.8, 2266.2, 15176.1 >, < 0, 0, 0 >, "%use% Skip jump"), void function(entity panel, entity user, int input)
    {
if (IsValid(user)) {
	if (user.IsPlayer() && user.GetPhysics() != MOVETYPE_NOCLIP) {
if (user.GetPersistentVarAsInt("gen") == 0) {
		user.SetOrigin(< 1041.8, 2210.1, 15365.7 >)
	} else {
            Message(user, "Can't skip while Timer is running!")
        }
}
    }})

    AddCallback_OnUseEntity( CreateFRButton(< 1041.8, 2155.8, 15321.5 >, < 0, -180, 0 >, "%use% Skip jump"), void function(entity panel, entity user, int input)
    {
if (IsValid(user)) {
	if (user.IsPlayer() && user.GetPhysics() != MOVETYPE_NOCLIP) {
if (user.GetPersistentVarAsInt("gen") == 0) {
		user.SetOrigin(< 1035.4, 2550.6, 15522.9 >)
	} else {
            Message(user, "Can't skip while Timer is running!")
        }
}
    }})

    AddCallback_OnUseEntity( CreateFRButton(< 1035.4, 2602, 15465.4 >, < 0, 0, 0 >, "%use% Skip jump"), void function(entity panel, entity user, int input)
    {
if (IsValid(user)) {
	if (user.IsPlayer() && user.GetPhysics() != MOVETYPE_NOCLIP) {
if (user.GetPersistentVarAsInt("gen") == 0) {
		user.SetOrigin(< 1947.9, 2551.9, 15517 >)
	} else {
            Message(user, "Can't skip while Timer is running!")
        }
}
    }})

    AddCallback_OnUseEntity( CreateFRButton(< 1947.9, 2615.7, 15466.1 >, < 0, 0, 0 >, "%use% Skip jump"), void function(entity panel, entity user, int input)
    {
if (IsValid(user)) {
	if (user.IsPlayer() && user.GetPhysics() != MOVETYPE_NOCLIP) {
if (user.GetPersistentVarAsInt("gen") == 0) {
		user.SetOrigin(< 2556.8, 2127.3, 15624 >)
	} else {
            Message(user, "Can't skip while Timer is running!")
        }
}
    }})

    AddCallback_OnUseEntity( CreateFRButton(< 2612.4, 2127.3, 15575.5 >, < 0, -90, 0 >, "%use% Skip jump"), void function(entity panel, entity user, int input)
    {
if (IsValid(user)) {
	if (user.IsPlayer() && user.GetPhysics() != MOVETYPE_NOCLIP) {
if (user.GetPersistentVarAsInt("gen") == 0) {
		user.SetOrigin(< 2340.8, 1872.1, 15780.7 >)
	} else {
            Message(user, "Can't skip while Timer is running!")
        }
}
    }})

    AddCallback_OnUseEntity( CreateFRButton(< 2275.1, 1872.1, 15721.6 >, < 0, 90, 0 >, "%use% Skip jump"), void function(entity panel, entity user, int input)
    {
if (IsValid(user)) {
	if (user.IsPlayer() && user.GetPhysics() != MOVETYPE_NOCLIP) {
if (user.GetPersistentVarAsInt("gen") == 0) {
		user.SetOrigin(< 2569.3, 2130.6, 15901 >)
	} else {
            Message(user, "Can't skip while Timer is running!")
        }
}
    }})

    AddCallback_OnUseEntity( CreateFRButton(< 2610.1, 2130.6, 15863.5 >, < 0, -90, 0 >, "%use% Skip jump"), void function(entity panel, entity user, int input)
    {
if (IsValid(user)) {
	if (user.IsPlayer() && user.GetPhysics() != MOVETYPE_NOCLIP) {
if (user.GetPersistentVarAsInt("gen") == 0) {
		user.SetOrigin(< 2556.4, 1166.7, 15917.8 >)
	} else {
            Message(user, "Can't skip while Timer is running!")
        }
}
    }})

    AddCallback_OnUseEntity( CreateFRButton(< 2613.7, 1166.7, 15865.99 >, < 0, -90, 0 >, "%use% Skip jump"), void function(entity panel, entity user, int input)
    {
if (IsValid(user)) {
	if (user.IsPlayer() && user.GetPhysics() != MOVETYPE_NOCLIP) {
if (user.GetPersistentVarAsInt("gen") == 0) {
		user.SetOrigin(< 2567.6, 235, 15919.6 >)
	} else {
            Message(user, "Can't skip while Timer is running!")
        }
}
    }})

    AddCallback_OnUseEntity( CreateFRButton(< 2619, 235, 15863.94 >, < 0, -90, 0 >, "%use% Skip jump"), void function(entity panel, entity user, int input)
    {
if (IsValid(user)) {
	if (user.IsPlayer() && user.GetPhysics() != MOVETYPE_NOCLIP) {
if (user.GetPersistentVarAsInt("gen") == 0) {
		user.SetOrigin(< 2578, -401.4, 15918.1 >)
	} else {
            Message(user, "Can't skip while Timer is running!")
        }
}
    }})

    AddCallback_OnUseEntity( CreateFRButton(< 2622.899, -401.3965, 15864.24 >, < 0, -90, 0 >, "%use% Skip jump"), void function(entity panel, entity user, int input)
    {
if (IsValid(user)) {
	if (user.IsPlayer() && user.GetPhysics() != MOVETYPE_NOCLIP) {
if (user.GetPersistentVarAsInt("gen") == 0) {
		user.SetOrigin(< 3062.9, -811.0966, 15920.1 >)
	} else {
            Message(user, "Can't skip while Timer is running!")
        }
}
    }})

    AddCallback_OnUseEntity( CreateFRButton(< 3113.3, -811.0966, 15860.7 >, < 0, -90, 0 >, "%use% Skip jump"), void function(entity panel, entity user, int input)
    {
if (IsValid(user)) {
	if (user.IsPlayer() && user.GetPhysics() != MOVETYPE_NOCLIP) {
if (user.GetPersistentVarAsInt("gen") == 0) {
		user.SetOrigin(< 2633.2, -1300.1, 15915.7 >)
	} else {
            Message(user, "Can't skip while Timer is running!")
        }
}
    }})

    AddCallback_OnUseEntity( CreateFRButton(< 2676.8, -1300.1, 15867.37 >, < 0, -90, 0 >, "%use% Skip jump"), void function(entity panel, entity user, int input)
    {
if (IsValid(user)) {
	if (user.IsPlayer() && user.GetPhysics() != MOVETYPE_NOCLIP) {
if (user.GetPersistentVarAsInt("gen") == 0) {
		user.SetOrigin(< 2047.8, -1278.3, 16043.1 >)
	} else {
            Message(user, "Can't skip while Timer is running!")
        }
}
    }})

    AddCallback_OnUseEntity( CreateFRButton(< 2047.8, -1331.4, 16024.3 >, < 0, -180, 20 >, "%use% Skip jump"), void function(entity panel, entity user, int input)
    {
if (IsValid(user)) {
	if (user.IsPlayer() && user.GetPhysics() != MOVETYPE_NOCLIP) {
if (user.GetPersistentVarAsInt("gen") == 0) {
		user.SetOrigin(< 1120.6, -1298.3, 16019.3 >)
	} else {
            Message(user, "Can't skip while Timer is running!")
        }
}
    }})

    AddCallback_OnUseEntity( CreateFRButton(< 1120.6, -1339.5, 15960.1 >, < 0, -180, -20 >, "%use% Skip jump"), void function(entity panel, entity user, int input)
    {
if (IsValid(user)) {
	if (user.IsPlayer() && user.GetPhysics() != MOVETYPE_NOCLIP) {
if (user.GetPersistentVarAsInt("gen") == 0) {
		user.SetOrigin(< 236.2, -1293.1, 16028.1 >)
	} else {
            Message(user, "Can't skip while Timer is running!")
        }
}
    }})

    AddCallback_OnUseEntity( CreateFRButton(< 251.9, -1343.8, 15985 >, < 20, -180, 0 >, "%use% Skip jump"), void function(entity panel, entity user, int input)
    {
if (IsValid(user)) {
	if (user.IsPlayer() && user.GetPhysics() != MOVETYPE_NOCLIP) {
if (user.GetPersistentVarAsInt("gen") == 0) {
		user.SetOrigin(< -779.7988, -1284.5, 15799.7 >)
	} else {
            Message(user, "Can't skip while Timer is running!")
        }
}
    }})

    AddCallback_OnUseEntity( CreateFRButton(< -779.7988, -1342.594, 15743.93 >, < 0, -180, 0 >, "%use% Skip jump"), void function(entity panel, entity user, int input)
    {
if (IsValid(user)) {
	if (user.IsPlayer() && user.GetPhysics() != MOVETYPE_NOCLIP) {
if (user.GetPersistentVarAsInt("gen") == 0) {
		user.SetOrigin(< -1864.661, -1297.2, 16088 >)
	} else {
            Message(user, "Can't skip while Timer is running!")
        }
}
    }})

    AddCallback_OnUseEntity( CreateFRButton(< -1864.661, -1350.932, 16034.8 >, < 0, -180, 0 >, "%use% Skip jump"), void function(entity panel, entity user, int input)
    {
if (IsValid(user)) {
	if (user.IsPlayer() && user.GetPhysics() != MOVETYPE_NOCLIP) {
if (user.GetPersistentVarAsInt("gen") == 0) {
		user.SetOrigin(< -2903.943, -1290.8, 16489.9 >)
	} else {
            Message(user, "Can't skip while Timer is running!")
        }
}
    }})

    AddCallback_OnUseEntity( CreateFRButton(< -2903.943, -1340.1, 16436.13 >, < 0, -180, 0 >, "%use% Skip jump"), void function(entity panel, entity user, int input)
    {
if (IsValid(user)) {
	if (user.IsPlayer() && user.GetPhysics() != MOVETYPE_NOCLIP) {
if (user.GetPersistentVarAsInt("gen") == 0) {
		user.SetOrigin(< -2823.7, -621.6021, 16968.9 >)
	} else {
            Message(user, "Can't skip while Timer is running!")
        }
}
    }})

    AddCallback_OnUseEntity( CreateFRButton(< -2890.073, -621.6021, 16912.13 >, < 0, 90, 0 >, "%use% Skip jump"), void function(entity panel, entity user, int input)
    {
if (IsValid(user)) {
	if (user.IsPlayer() && user.GetPhysics() != MOVETYPE_NOCLIP) {
if (user.GetPersistentVarAsInt("gen") == 0) {
		user.SetOrigin(< -2819.5, 127.3, 17108.9 >)
	} else {
            Message(user, "Can't skip while Timer is running!")
        }
}
    }})

    AddCallback_OnUseEntity( CreateFRButton(< -2889.573, 127.3, 17051.43 >, < 0, 90, 0 >, "%use% Skip jump"), void function(entity panel, entity user, int input)
    {
if (IsValid(user)) {
	if (user.IsPlayer() && user.GetPhysics() != MOVETYPE_NOCLIP) {
if (user.GetPersistentVarAsInt("gen") == 0) {
		user.SetOrigin(< -2820.9, 1119.8, 17249.4 >)
	} else {
            Message(user, "Can't skip while Timer is running!")
        }
}
    }})

    AddCallback_OnUseEntity( CreateFRButton(< -2891.399, 1119.8, 17190.83 >, < 0, 90, 0 >, "%use% Skip jump"), void function(entity panel, entity user, int input)
    {
if (IsValid(user)) {
	if (user.IsPlayer() && user.GetPhysics() != MOVETYPE_NOCLIP) {
if (user.GetPersistentVarAsInt("gen") == 0) {
		user.SetOrigin(< -3127.1, 1920.9, 17390.4 >)
	} else {
            Message(user, "Can't skip while Timer is running!")
        }
}
    }})

    AddCallback_OnUseEntity( CreateFRButton(< -3196.1, 1920.9, 17330.23 >, < 0, 90, 0 >, "%use% Skip jump"), void function(entity panel, entity user, int input)
    {
if (IsValid(user)) {
	if (user.IsPlayer() && user.GetPhysics() != MOVETYPE_NOCLIP) {
if (user.GetPersistentVarAsInt("gen") == 0) {
		user.SetOrigin(< -2774.602, 2832, 17556 >)
	} else {
            Message(user, "Can't skip while Timer is running!")
        }
}
    }})

    AddCallback_OnUseEntity( CreateFRButton(< -2774.602, 2890.904, 17469.41 >, < 0, 0, 0 >, "%use% Skip jump"), void function(entity panel, entity user, int input)
    {
if (IsValid(user)) {
	if (user.IsPlayer() && user.GetPhysics() != MOVETYPE_NOCLIP) {
if (user.GetPersistentVarAsInt("gen") == 0) {
		user.SetOrigin(< -2499.4, 3729.9, 17532.8 >)
	} else {
            Message(user, "Can't skip while Timer is running!")
        }
}
    }})

    AddCallback_OnUseEntity( CreateFRButton(< -2499.4, 3799.4, 17469.41 >, < 0, 0, 0 >, "%use% Skip jump"), void function(entity panel, entity user, int input)
    {
if (IsValid(user)) {
	if (user.IsPlayer() && user.GetPhysics() != MOVETYPE_NOCLIP) {
if (user.GetPersistentVarAsInt("gen") == 0) {
		user.SetOrigin(< -2286.825, 4914, 17538 >)
	} else {
            Message(user, "Can't skip while Timer is running!")
        }
}
    }})

    AddCallback_OnUseEntity( CreateFRButton(< -2286.825, 4978.426, 17469.61 >, < 0, 0, 0 >, "%use% Skip jump"), void function(entity panel, entity user, int input)
    {
if (IsValid(user)) {
	if (user.IsPlayer() && user.GetPhysics() != MOVETYPE_NOCLIP) {
if (user.GetPersistentVarAsInt("gen") == 0) {
		user.SetOrigin(< -1410, 4863.159, 17542 >)
	} else {
            Message(user, "Can't skip while Timer is running!")
        }
}
    }})

    AddCallback_OnUseEntity( CreateFRButton(< -1324.195, 4863.159, 17469.61 >, < 0, -90, 0 >, "%use% Skip jump"), void function(entity panel, entity user, int input)
    {
if (IsValid(user)) {
	if (user.IsPlayer() && user.GetPhysics() != MOVETYPE_NOCLIP) {
if (user.GetPersistentVarAsInt("gen") == 0) {
		user.SetOrigin(< -870, 4116, 17544 >)
	} else {
            Message(user, "Can't skip while Timer is running!")
        }
}
    }})

    AddCallback_OnUseEntity( CreateFRButton(< -814.8521, 4116, 17470.01 >, < 0, -90, 0 >, "%use% Skip jump"), void function(entity panel, entity user, int input)
    {
if (IsValid(user)) {
	if (user.IsPlayer() && user.GetPhysics() != MOVETYPE_NOCLIP) {
if (user.GetPersistentVarAsInt("gen") == 0) {
		user.SetOrigin(< -881.4, 3789.826, 17789.6 >)
	} else {
            Message(user, "Can't skip while Timer is running!")
        }
}
    }})

    AddCallback_OnUseEntity( CreateFRButton(< -814.8949, 3789.826, 17724.71 >, < 0, -90, 0 >, "%use% Skip jump"), void function(entity panel, entity user, int input)
    {
if (IsValid(user)) {
	if (user.IsPlayer() && user.GetPhysics() != MOVETYPE_NOCLIP) {
if (user.GetPersistentVarAsInt("gen") == 0) {
		user.SetOrigin(< -882, 3271, 18109 >)
	} else {
            Message(user, "Can't skip while Timer is running!")
        }
}
    }})

    AddCallback_OnUseEntity( CreateFRButton(< -815, 3271, 18038.05 >, < 0, -90, 0 >, "%use% Skip jump"), void function(entity panel, entity user, int input)
    {
if (IsValid(user)) {
	if (user.IsPlayer() && user.GetPhysics() != MOVETYPE_NOCLIP) {
if (user.GetPersistentVarAsInt("gen") == 0) {
		user.SetOrigin(< 19, 2350, 18010 >)
	} else {
            Message(user, "Can't skip while Timer is running!")
        }
}
    }})

    AddCallback_OnUseEntity( CreateFRButton(< 19.2999, 2469.2, 17930.45 >, < 0, 0, 0 >, "%use% Skip jump"), void function(entity panel, entity user, int input)
    {
if (IsValid(user)) {
	if (user.IsPlayer() && user.GetPhysics() != MOVETYPE_NOCLIP) {
if (user.GetPersistentVarAsInt("gen") == 0) {
		user.SetOrigin(< 1061.8, 2391, 18223.8 >)
	} else {
            Message(user, "Can't skip while Timer is running!")
        }
}
    }})

    AddCallback_OnUseEntity( CreateFRButton(< 1061.8, 2469.525, 18157.5 >, < 0, 0, 0 >, "%use% Skip jump"), void function(entity panel, entity user, int input)
    {
if (IsValid(user)) {
	if (user.IsPlayer() && user.GetPhysics() != MOVETYPE_NOCLIP) {
if (user.GetPersistentVarAsInt("gen") == 0) {
		user.SetOrigin(< 1818.9, 2413.8, 18518.4 >)
	} else {
            Message(user, "Can't skip while Timer is running!")
        }
}
    }})

    AddCallback_OnUseEntity( CreateFRButton(< 1818.9, 2471.5, 18449.51 >, < 0, 0, 0 >, "%use% Skip jump"), void function(entity panel, entity user, int input)
    {
if (IsValid(user)) {
	if (user.IsPlayer() && user.GetPhysics() != MOVETYPE_NOCLIP) {
if (user.GetPersistentVarAsInt("gen") == 0) {
		user.SetOrigin(< 1821.3, 2758.2, 18727.2 >)
	} else {
            Message(user, "Can't skip while Timer is running!")
        }
}
    }})

    AddCallback_OnUseEntity( CreateFRButton(< 1821.3, 2817.5, 18660.61 >, < 0, 0, 0 >, "%use% Skip jump"), void function(entity panel, entity user, int input)
    {
if (IsValid(user)) {
	if (user.IsPlayer() && user.GetPhysics() != MOVETYPE_NOCLIP) {
if (user.GetPersistentVarAsInt("gen") == 0) {
		user.SetOrigin(< 1824.3, 3097.8, 18944.1 >)
	} else {
            Message(user, "Can't skip while Timer is running!")
        }
}
    }})

    AddCallback_OnUseEntity( CreateFRButton(< 1824.3, 3156.3, 18872.01 >, < 0, 0, 0 >, "%use% Skip jump"), void function(entity panel, entity user, int input)
    {
if (IsValid(user)) {
	if (user.IsPlayer() && user.GetPhysics() != MOVETYPE_NOCLIP) {
if (user.GetPersistentVarAsInt("gen") == 0) {
		user.SetOrigin(< 1823.1, 2661.6, 19149.6 >)
	} else {
            Message(user, "Can't skip while Timer is running!")
        }
}
    }})

    AddCallback_OnUseEntity( CreateFRButton(< 1823.1, 2589.821, 19083.11 >, < 0, 180, 0 >, "%use% Skip jump"), void function(entity panel, entity user, int input)
    {
if (IsValid(user)) {
	if (user.IsPlayer() && user.GetPhysics() != MOVETYPE_NOCLIP) {
if (user.GetPersistentVarAsInt("gen") == 0) {
		user.SetOrigin(< 1830.3, 2313, 19366.3 >)
	} else {
            Message(user, "Can't skip while Timer is running!")
        }
}
    }})

    AddCallback_OnUseEntity( CreateFRButton(< 1830.3, 2244.223, 19293.61 >, < 0, 180, 0 >, "%use% Skip jump"), void function(entity panel, entity user, int input)
    {
if (IsValid(user)) {
	if (user.IsPlayer() && user.GetPhysics() != MOVETYPE_NOCLIP) {
if (user.GetPersistentVarAsInt("gen") == 0) {
		user.SetOrigin(< 1871.5, 2042, 19575.5 >)
	} else {
            Message(user, "Can't skip while Timer is running!")
        }
}
    }})

    AddCallback_OnUseEntity( CreateFRButton(< 1952, 2042, 19518.4 >, < 0, -90.0002, 0 >, "%use% Skip jump"), void function(entity panel, entity user, int input)
    {
if (IsValid(user)) {
	if (user.IsPlayer() && user.GetPhysics() != MOVETYPE_NOCLIP) {
if (user.GetPersistentVarAsInt("gen") == 0) {
		user.SetOrigin(< 1872.1, 973, 19708.6 >)
	} else {
            Message(user, "Can't skip while Timer is running!")
        }
}
    }})

    AddCallback_OnUseEntity( CreateFRButton(< 1949.7, 973, 19629.61 >, < 0, -90.0001, 0 >, "%use% Skip jump"), void function(entity panel, entity user, int input)
    {
if (IsValid(user)) {
	if (user.IsPlayer() && user.GetPhysics() != MOVETYPE_NOCLIP) {
if (user.GetPersistentVarAsInt("gen") == 0) {
		user.SetOrigin(< -33.7, -5.4, 14978.1 >)
	} else {
            Message(user, "Can't skip while Timer is running!")
        }
}
    }})

}

void
function door_map() {
    // Props Array
    array < entity > NoClimbArray; array < entity > InvisibleArray; 

    // Props
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 61.6799, -69.46, 15041.56 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 61.6799, 60.54, 15041.56 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 61.6799, 190.53, 15041.56 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 61.6799, 320.53, 15041.56 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < -65.0701, -69.46, 15041.56 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < -65.0701, 60.54, 15041.56 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < -65.0701, 190.53, 15041.56 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < -65.0701, 320.53, 15041.56 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_red_128.rmdl", < 63.2, 373.2, 15032.88 >, < 0, -90, 90 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 98.7, 370.8, 14899.5 >, < 0, -90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 98.7, 373.6, 14899.5 >, < 0, 90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < -100.8, 370.8, 14899.5 >, < 0, -90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < -100.8, 373.6, 14899.5 >, < 0, 90, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 0.23, 254.0399, 14898.73 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 0.23, -1.96, 14898.73 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 127.2295, -2.16, 14900.03 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 127.2295, 253.74, 14900.03 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < -126.3701, -2.16, 14900.03 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < -126.3701, 253.7394, 14900.03 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 60.4065, 867.2925, 15040.63 >, < 0, -0.3712, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 61.2485, 997.2898, 15040.63 >, < 0, -0.3712, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 62.0906, 1127.277, 15040.63 >, < 0, -0.3712, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 62.9326, 1257.274, 15040.63 >, < 0, -0.3712, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < -66.3408, 868.1136, 15040.63 >, < 0, -0.3712, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < -65.4988, 998.1109, 15040.63 >, < 0, -0.3712, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < -64.6567, 1128.098, 15040.63 >, < 0, -0.3712, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < -63.8147, 1258.095, 15040.63 >, < 0, -0.3712, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_red_128.rmdl", < 64.794, 1309.933, 15031.95 >, < 0, -90.3712, 90 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 100.2776, 1307.303, 14898.57 >, < 0, -90.3712, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 100.2957, 1310.103, 14898.57 >, < 0, 89.6289, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < -99.2183, 1308.596, 14898.57 >, < 0, -90.3712, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < -99.2002, 1311.396, 14898.57 >, < 0, 89.6289, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 1.0532, 1191.184, 14897.8 >, < 0, -0.3712, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -0.605, 935.1892, 14897.8 >, < 0, -0.3712, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 126.3904, 934.1665, 14899.1 >, < 0, 179.6289, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 128.0481, 1190.061, 14899.1 >, < 0, 179.6289, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < -127.2036, 935.8093, 14899.1 >, < 0, 179.6289, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < -125.5461, 1191.703, 14899.1 >, < 0, 179.6289, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 825.4902, 1362.1, 14899.27 >, < 0, 0, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 823.1101, 1362.1, 14899.27 >, < 0, -180, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 825.509, 1562.3, 14899.27 >, < 0, 0, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 823.1289, 1562.3, 14899.27 >, < 0, -180, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_red_128.rmdl", < 826.79, 1526.2, 15033 >, < 0, 0, 90 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 330.1099, 1562.5, 14899.27 >, < 0, -180, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 332.49, 1562.5, 14899.27 >, < 0, 0, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 330.0908, 1362.3, 14899.27 >, < 0, -180, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 332.4709, 1362.3, 14899.27 >, < 0, 0, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_red_128.rmdl", < 328.8098, 1398.4, 15033 >, < 0, -180, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 449.8101, 1462.4, 14899.1 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 705.79, 1462.2, 14899.1 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 449.8, 1335.4, 14899.2 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 705.8, 1335.21, 14899.2 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 449.8, 1589.39, 14899.2 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 705.8, 1589.2, 14899.2 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 383.2, 1525.8, 15042.6 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 513.2, 1525.8, 15042.6 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 773.1001, 1523.8, 15042.6 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 643.1001, 1523.8, 15042.6 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 383.2, 1400.8, 15042.6 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 513.2, 1400.8, 15042.6 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 773.1001, 1398.8, 15042.6 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 643.1001, 1398.8, 15042.6 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_red_128.rmdl", < 1166.604, 2223.5, 15028.8 >, < 0, 0, 90 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 1164.64, 2058.366, 14900.4 >, < 0, 0, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 1163.34, 2058.366, 14900.4 >, < 0, -180, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 1164.64, 2258.166, 14900.4 >, < 0, 0, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 1163.34, 2258.166, 14900.4 >, < 0, -180, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_red_128.rmdl", < 981.5, 1787.2, 15034.2 >, < 0, 90, 90 >, true, 50000, -1, 0.9999999 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 945.1001, 1786.6, 14900.3 >, < 0, -90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 945.1001, 1788.4, 14900.3 >, < 0, 90, 0 >, false, 50000, -1, 0.9999999 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 1145, 1786.6, 14900.3 >, < 0, -90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 1145, 1788.4, 14900.3 >, < 0, 90, 0 >, false, 50000, -1, 0.9999999 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 1045, 1906.516, 14900 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 1045, 2158.216, 14900 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 981.3, 1846.4, 15044.6 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 1108.2, 1846.4, 15044.6 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 981.3, 1975.1, 15044.6 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 1108.2, 1975.1, 15044.6 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 918.2, 1904, 14900.1 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 918.2, 2159.6, 14900.1 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 1171.7, 1904, 14900.1 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 1043.7, 2284.9, 14900.1 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 1110.104, 2220.25, 15172.13 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 980.1042, 2220.25, 15172.13 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 850.1143, 2220.25, 15172.13 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 720.1143, 2220.25, 15172.13 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 1110.104, 2093.5, 15172.13 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 980.1042, 2093.5, 15172.13 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 850.1143, 2093.5, 15172.13 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 720.1143, 2093.5, 15172.13 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_red_128.rmdl", < 667.4441, 2221.77, 15163.45 >, < 0, 0, 90 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 669.8442, 2257.27, 15030.07 >, < 0, 0, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 667.0442, 2257.27, 15030.07 >, < 0, -180, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 669.8442, 2057.77, 15030.07 >, < 0, 0, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 667.0442, 2057.77, 15030.07 >, < 0, -180, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 786.6042, 2158.8, 15029.3 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 1042.604, 2158.8, 15029.3 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 1042.804, 2285.8, 15030.6 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 786.9043, 2285.8, 15030.6 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 1042.804, 2032.2, 15030.6 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 786.9048, 2032.2, 15030.6 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 717.8042, 2092.05, 15302.53 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 847.8042, 2092.05, 15302.53 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 977.7942, 2092.05, 15302.53 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 1107.794, 2092.05, 15302.53 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 717.8042, 2218.8, 15302.53 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 847.8042, 2218.8, 15302.53 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 977.7942, 2218.8, 15302.53 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 1107.794, 2218.8, 15302.53 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_red_128.rmdl", < 1160.464, 2090.53, 15293.85 >, < 0, -180, 90 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 1158.064, 2055.03, 15160.47 >, < 0, -180, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 1160.864, 2055.03, 15160.47 >, < 0, 0, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 1158.064, 2254.53, 15160.47 >, < 0, -180, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 1160.864, 2254.53, 15160.47 >, < 0, 0, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 1041.304, 2153.5, 15159.7 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 785.3042, 2153.5, 15159.7 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 785.104, 2026.5, 15161 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 1041.004, 2026.5, 15161 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 785.104, 2280.1, 15161 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 1041.003, 2280.1, 15161 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_red_128.rmdl", < 665.4114, 2140.006, 15440 >, < 0, -180, 90 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 666.7112, 2359.106, 15306.27 >, < 0, -180, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 669.0913, 2359.106, 15306.27 >, < 0, 0, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 666.7302, 2303.506, 15306.27 >, < 0, -180, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 669.1304, 2303.506, 15306.27 >, < 0, 0, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_red_128.rmdl", < 1163.392, 2377.906, 15440 >, < 0, 0, 90 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 1162.092, 2158.706, 15306.27 >, < 0, 0, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 1159.711, 2158.706, 15306.27 >, < 0, -180, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 1162.073, 2214.406, 15306.27 >, < 0, 0, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 1159.672, 2214.406, 15306.27 >, < 0, -180, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 1042.391, 2258.806, 15306.1 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 786.4114, 2259.006, 15306.1 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 1042.401, 2385.806, 15306.2 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 786.4014, 2385.996, 15306.2 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 1042.401, 2131.815, 15306.2 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 786.4014, 2132.006, 15306.2 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 1109.001, 2195.406, 15449.6 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 979.0015, 2195.406, 15449.6 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 719.1013, 2197.406, 15449.6 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 849.1013, 2197.406, 15449.6 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 1109.001, 2320.406, 15449.6 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 979.0015, 2320.406, 15449.6 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 719.1013, 2322.406, 15449.6 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 849.1013, 2322.406, 15449.6 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_red_128.rmdl", < 665.0098, 2382.6, 15583.9 >, < 0, -180, 90 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 666.3101, 2601.8, 15450.17 >, < 0, -180, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 668.6899, 2601.8, 15450.17 >, < 0, 0, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 666.3289, 2546.1, 15450.17 >, < 0, -180, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 668.729, 2546.1, 15450.17 >, < 0, 0, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 786.01, 2501.7, 15450 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 1041.99, 2501.5, 15450 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 786, 2374.7, 15450.1 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 1042, 2374.51, 15450.1 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 786, 2628.69, 15450.1 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 1042, 2628.5, 15450.1 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 719.3999, 2565.1, 15593.5 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 849.3999, 2565.1, 15593.5 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 1109.3, 2563.1, 15593.5 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 979.3, 2563.1, 15593.5 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 719.3999, 2440.1, 15593.5 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 849.3999, 2440.1, 15593.5 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 1109.3, 2438.1, 15593.5 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 979.3, 2438.1, 15593.5 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 1294.6, 2502, 15450.1 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 1294, 2375.1, 15450.2 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 1294, 2629, 15450.1 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 1414.2, 2402, 15450.2 >, < 0, 0, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 1412.4, 2402, 15450.2 >, < 0, 180, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 1414.2, 2602, 15450.2 >, < 0, 0, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 1412.4, 2602, 15450.2 >, < 0, 180, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_red_128.rmdl", < 1413.3, 2566.5, 15584.1 >, < -90, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 1232.3, 2563.8, 15593 >, < 0, -90.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 1362.3, 2564.601, 15593 >, < 0, -90.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 1232.3, 2436.8, 15593 >, < 0, -90.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 1362.3, 2437.601, 15593 >, < 0, -90.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 2203.3, 2501.6, 15450.1 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 1947.6, 2498.8, 15450.1 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 2202.7, 2374.7, 15450.2 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 2202.7, 2628.6, 15450.1 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 2322.9, 2401.6, 15450.2 >, < 0, 0, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 2321.1, 2401.6, 15450.2 >, < 0, 180, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 2322.9, 2601.6, 15450.2 >, < 0, 0, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 2321.1, 2601.6, 15450.2 >, < 0, 180, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_red_128.rmdl", < 2322, 2566.1, 15584.1 >, < -89.9802, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 2141, 2563.4, 15593 >, < 0, -90.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 2271, 2564.201, 15593 >, < 0, -90.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 2141, 2436.4, 15593 >, < 0, -90.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 2271, 2437.201, 15593 >, < 0, -90.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_red_128.rmdl", < 2625.4, 1751.01, 15694 >, < 0, -90, 90 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 2406.3, 1752.31, 15560.27 >, < 0, -90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 2406.3, 1754.69, 15560.27 >, < 0, 90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 2461.9, 1752.329, 15560.27 >, < 0, -90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 2461.9, 1754.729, 15560.27 >, < 0, 90, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_red_128.rmdl", < 2387.5, 2248.99, 15694 >, < 0, 90, 90 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 2606.7, 2247.69, 15560.27 >, < 0, 90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 2606.7, 2245.31, 15560.27 >, < 0, -90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 2551, 2247.671, 15560.27 >, < 0, 90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 2551, 2245.271, 15560.27 >, < 0, -90, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 2506.6, 2127.99, 15560.1 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 2506.4, 1872.01, 15560.1 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 2379.6, 2128, 15560.2 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 2379.41, 1872, 15560.2 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 2633.59, 2128, 15560.2 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 2633.4, 1872, 15560.2 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 2570, 2194.6, 15703.6 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 2570, 2064.6, 15703.6 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 2568, 1804.7, 15703.6 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 2568, 1934.7, 15703.6 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 2445, 2194.6, 15703.6 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 2445, 2064.6, 15703.6 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 2443, 1804.7, 15703.6 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 2443, 1934.7, 15703.6 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_red_128.rmdl", < 2261.8, 2248.09, 15840.1 >, < 0, 90, 90 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 2480.9, 2246.79, 15706.37 >, < 0, 90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 2480.9, 2244.41, 15706.37 >, < 0, -90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 2425.3, 2246.771, 15706.37 >, < 0, 90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 2425.3, 2244.371, 15706.37 >, < 0, -90, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_red_128.rmdl", < 2499.7, 1750.11, 15840.1 >, < 0, -90, 90 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 2280.5, 1751.41, 15706.37 >, < 0, -90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 2280.5, 1753.79, 15706.37 >, < 0, 90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 2336.2, 1751.429, 15706.37 >, < 0, -90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 2336.2, 1753.829, 15706.37 >, < 0, 90, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 2380.6, 1871.11, 15706.2 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 2380.8, 2127.09, 15706.2 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 2507.6, 1871.1, 15706.3 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 2507.79, 2127.1, 15706.3 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 2253.61, 1871.1, 15706.3 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 2253.8, 2127.1, 15706.3 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 2317.2, 1804.5, 15849.7 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 2317.2, 1934.5, 15849.7 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 2319.2, 2194.4, 15849.7 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 2319.2, 2064.4, 15849.7 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 2442.2, 1804.5, 15849.7 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 2442.2, 1934.5, 15849.7 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 2444.2, 2194.4, 15849.7 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 2444.2, 2064.4, 15849.7 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_red_128.rmdl", < 2625.4, 1751.01, 15982 >, < 0, -90, 90 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 2406.3, 1752.31, 15848.27 >, < 0, -90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 2406.3, 1754.69, 15848.27 >, < 0, 90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 2461.9, 1752.329, 15848.27 >, < 0, -90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 2461.9, 1754.729, 15848.27 >, < 0, 90, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_red_128.rmdl", < 2387.5, 2248.99, 15982 >, < 0, 90, 90 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 2606.7, 2247.69, 15848.27 >, < 0, 90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 2606.7, 2245.31, 15848.27 >, < 0, -90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 2551, 2247.671, 15848.27 >, < 0, 90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 2551, 2245.271, 15848.27 >, < 0, -90, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 2506.6, 2127.99, 15848.1 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 2506.4, 1872.01, 15848.1 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 2379.6, 2128, 15848.2 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 2379.41, 1872, 15848.2 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 2633.59, 2128, 15848.2 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 2633.4, 1872, 15848.2 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 2570, 2194.6, 15991.6 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 2570, 2064.6, 15991.6 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 2568, 1804.7, 15991.6 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 2568, 1934.7, 15991.6 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 2445, 2194.6, 15991.6 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 2445, 2064.6, 15991.6 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 2443, 1804.7, 15991.6 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 2443, 1934.7, 15991.6 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 2570.102, 847.0958, 15990.69 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 2570.102, 977.0958, 15990.69 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 2570.1, 1106.904, 15990.69 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 2570.1, 1236.903, 15990.69 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 2445.701, 847.0958, 15990.69 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 2445.701, 977.0958, 15990.69 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 2445.701, 1106.904, 15990.69 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 2445.702, 1236.903, 15990.69 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 2508.5, 912.0997, 15849.99 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 2508.5, 1167.924, 15849.99 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 2635.301, 912.0997, 15850.49 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 2381.601, 912.0997, 15850.49 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 2635.3, 1167.604, 15850.49 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 2381.6, 1167.604, 15850.49 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_red_64.rmdl", < 2538.5, 793.5997, 15982.89 >, < -90, 0, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 2607.2, 791.8995, 15850.15 >, < 0, -90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_32x144_01.rmdl", < 2561.4, 794.3995, 15850.45 >, < 0, 90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 2607.2, 794.3995, 15850.15 >, < 0, 90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_32x144_01.rmdl", < 2561.4, 791.8995, 15850.45 >, < 0, -90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_32x144_01.rmdl", < 2453.3, 791.8995, 15850.45 >, < 0, -90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 2409.73, 791.8995, 15850.15 >, < 0, -90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_32x144_01.rmdl", < 2453.3, 794.3995, 15850.45 >, < 0, 90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 2409.73, 794.3995, 15850.15 >, < 0, 90, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 2573.401, 169.9922, 15988.94 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 2573.401, 299.9922, 15988.94 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 2449.001, 169.9922, 15988.94 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 2449.001, 299.9922, 15988.94 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 2511.8, 234.9962, 15848.24 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 2638.601, 234.9961, 15848.74 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 2384.9, 234.9962, 15848.74 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_red_64.rmdl", < 2541.8, 116.4961, 15981.14 >, < -90, 0, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 2610.5, 114.7959, 15848.4 >, < 0, -90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_32x144_01.rmdl", < 2564.7, 117.2959, 15848.7 >, < 0, 90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 2610.5, 117.2959, 15848.4 >, < 0, 90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_32x144_01.rmdl", < 2564.7, 114.7959, 15848.7 >, < 0, -90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_32x144_01.rmdl", < 2456.6, 114.796, 15848.7 >, < 0, -90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 2413.03, 114.796, 15848.4 >, < 0, -90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_32x144_01.rmdl", < 2456.6, 117.296, 15848.7 >, < 0, 90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 2413.03, 117.296, 15848.4 >, < 0, 90, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 2573.001, -466.4042, 15988.94 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 2573.001, -336.4042, 15988.94 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 2448.601, -466.4042, 15988.94 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 2448.601, -336.4042, 15988.94 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 2511.399, -401.4003, 15848.24 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 2638.2, -401.4003, 15848.74 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 2384.5, -401.4003, 15848.74 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_red_64.rmdl", < 2541.399, -519.9003, 15981.14 >, < -90, 0, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 2610.1, -521.6005, 15848.4 >, < 0, -90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_32x144_01.rmdl", < 2564.3, -519.1005, 15848.7 >, < 0, 90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 2610.1, -519.1005, 15848.4 >, < 0, 90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_32x144_01.rmdl", < 2564.3, -521.6005, 15848.7 >, < 0, -90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_32x144_01.rmdl", < 2456.199, -521.6005, 15848.7 >, < 0, -90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 2412.63, -521.6005, 15848.4 >, < 0, -90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_32x144_01.rmdl", < 2456.199, -519.1005, 15848.7 >, < 0, 90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 2412.63, -519.1005, 15848.4 >, < 0, 90, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 2998.716, -806.3245, 15844.14 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 2998.899, -679.4966, 15844.2 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 3125.6, -806.5967, 15844.2 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 3065.399, -869.6967, 15984.6 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 3065.399, -741.0967, 15984.6 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 2937.7, -741.0967, 15984.6 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 2937.7, -869.6963, 15984.6 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_32x144_01.rmdl", < 3117.899, -926.1006, 15844.2 >, < 0, -90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 3070.1, -926.3008, 15844.4 >, < 0, -90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_32x144_01.rmdl", < 3117.899, -923.8701, 15844.2 >, < 0, 90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 3070.1, -924.0703, 15844.4 >, < 0, 90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_32x144_01.rmdl", < 2883, -925.4927, 15844.2 >, < 0, 90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 2930.8, -925.2925, 15844.4 >, < 0, 90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_32x144_01.rmdl", < 2883, -927.7231, 15844.2 >, < 0, -90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 2930.8, -927.5229, 15844.4 >, < 0, -90, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_red_64.rmdl", < 2968.2, -925.1967, 15976.5 >, < -90, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_red_64.rmdl", < 2879.699, -753.4004, 15976.5 >, < -90, -90, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_128x144_04.rmdl", < 2878.999, -823.5967, 15841 >, < 0, -180, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_32x144_01.rmdl", < 2879, -903.4966, 15841 >, < 0, -180, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_128x144_04.rmdl", < 2880.999, -823.5967, 15841 >, < 0, 0, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_32x144_01.rmdl", < 2881, -903.4966, 15841 >, < 0, 0, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_red_64.rmdl", < 2701.616, -1115.568, 15983.67 >, < 0, 0, 90 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_32x144_01.rmdl", < 2704.316, -1330.468, 15851.67 >, < 0, 0, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_128x144_04.rmdl", < 2704.316, -1250.568, 15851.67 >, < 0, 0, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_32x144_01.rmdl", < 2700.115, -1330.468, 15851.67 >, < 0, -180, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_128x144_04.rmdl", < 2700.116, -1250.568, 15851.67 >, < 0, -180, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_red_64.rmdl", < 2616.716, -1352.768, 15983.97 >, < 0, -90, 90 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 2683.315, -1353.372, 15851.47 >, < 0, -90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_32x144_01.rmdl", < 2637.516, -1353.572, 15851.47 >, < 0, -90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 2683.316, -1350.968, 15851.47 >, < 0, 90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_32x144_01.rmdl", < 2637.517, -1351.169, 15851.47 >, < 0, 90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 2481.614, -1353.372, 15851.47 >, < 0, -90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_32x144_01.rmdl", < 2529.515, -1353.571, 15851.47 >, < 0, -90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 2481.616, -1350.968, 15851.47 >, < 0, 90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_32x144_01.rmdl", < 2529.516, -1351.168, 15851.47 >, < 0, 90, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 2584.598, -1233.396, 15851.44 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 2453.916, -1232.568, 15851.47 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 2584.616, -1106.668, 15851.44 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 2584.615, -1106.672, 15995.37 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 2708.415, -1230.572, 15995.37 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 2584.597, -1233.4, 15990.67 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_red_64.rmdl", < 2616.715, -1352.772, 16123.17 >, < 0, -90, 90 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 2683.315, -1353.376, 15990.67 >, < 0, -90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_32x144_01.rmdl", < 2637.516, -1353.576, 15990.67 >, < 0, -90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 2683.315, -1350.972, 15990.67 >, < 0, 90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_32x144_01.rmdl", < 2637.517, -1351.173, 15990.67 >, < 0, 90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 2481.614, -1353.376, 15990.67 >, < 0, -90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_32x144_01.rmdl", < 2529.515, -1353.575, 15990.67 >, < 0, -90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < 2481.615, -1350.972, 15990.67 >, < 0, 90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_32x144_01.rmdl", < 2529.516, -1351.172, 15990.67 >, < 0, 90, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 2646.614, -1294.668, 16132.87 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 2516.714, -1294.668, 16132.87 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 2646.616, -1168.068, 16132.87 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 2516.714, -1168.068, 16132.87 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 1727.192, -1242.061, 16124.48 >, < -20, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 1857.192, -1242.061, 16124.48 >, < -20, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 1987, -1242.06, 16124.48 >, < -20, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 2117, -1242.059, 16124.48 >, < -20, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 1727.192, -1125.163, 16081.94 >, < -20, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 1857.192, -1125.163, 16081.94 >, < -20, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 1987, -1125.163, 16081.94 >, < -20, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 2117, -1125.163, 16081.94 >, < -20, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 1792.196, -1232.297, 15971.2 >, < -20, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 2048.021, -1232.297, 15971.2 >, < -20, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 1792.196, -1351.28, 16015.04 >, < -20, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 1792.196, -1112.88, 15928.27 >, < -20, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 2047.7, -1351.279, 16015.04 >, < -20, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 2047.7, -1112.879, 15928.27 >, < -20, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_red_64.rmdl", < 1673.696, -1216.101, 16107.8 >, < -70, 90, 180 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_128x144_04.rmdl", < 1671.97, -1326.035, 16006.91 >, < 0, 0, -20 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_128x144_04.rmdl", < 1671.97, -1326.035, 16006.91 >, < 0, -180, 20 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_128x144_04.rmdl", < 1674.496, -1135.662, 15937.3 >, < 0, 0, -20 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_128x144_04.rmdl", < 1674.496, -1135.662, 15937.3 >, < 0, -180, 20 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 799.1462, -1328.415, 16091.86 >, < 15, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 929.1462, -1328.415, 16091.86 >, < 15, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 1058.954, -1328.413, 16091.86 >, < 15, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 1188.954, -1328.412, 16091.86 >, < 15, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 799.1462, -1208.253, 16124.06 >, < 15, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 929.1462, -1208.253, 16124.06 >, < 15, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 1058.954, -1208.253, 16124.06 >, < 15, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 1188.954, -1208.253, 16124.06 >, < 15, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 864.1501, -1232.496, 15971.9 >, < 15, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 1119.974, -1232.496, 15971.9 >, < 15, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 864.1501, -1355.106, 15939.56 >, < 15, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 864.1501, -1110.05, 16005.23 >, < 15, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 1119.654, -1355.105, 15939.57 >, < 15, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 1119.654, -1110.049, 16005.23 >, < 15, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_red_64.rmdl", < 745.6501, -1299.155, 16091.63 >, < -75, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_128x144_04.rmdl", < 743.9241, -1331.343, 15945.93 >, < 0, -180, -15 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_128x144_04.rmdl", < 743.9241, -1331.343, 15945.93 >, < 0, 0, 15 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_128x144_04.rmdl", < 746.45, -1135.472, 15998.1 >, < 0, 0, 15 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_128x144_04.rmdl", < 746.45, -1135.472, 15998.1 >, < 0, -180, -15 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < -93.3545, -1294.098, 15992.08 >, < 0, -90, 20 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 28.8057, -1294.098, 16036.54 >, < 0, -90, 20 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 150.7852, -1294.096, 16080.94 >, < 0, -90, 20 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 272.9451, -1294.096, 16125.4 >, < 0, -90, 20 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < -93.3545, -1169.698, 15992.08 >, < 0, -90, 20 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 28.8057, -1169.698, 16036.54 >, < 0, -90, 20 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 150.7852, -1169.698, 16080.94 >, < 0, -90, 20 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_03_large.rmdl", < 272.9448, -1169.698, 16125.4 >, < 0, -90, 20 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 15.8516, -1232.496, 15882.1 >, < 0, -90, 20 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 256.2476, -1232.496, 15969.59 >, < 0, -90, 20 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 15.6807, -1359.297, 15882.57 >, < 0, -90, 20 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 15.6804, -1105.597, 15882.57 >, < 0, -90, 20 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 255.7756, -1359.296, 15969.96 >, < 0, -90, 20 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_256x144_02.rmdl", < 255.7756, -1105.596, 15969.96 >, < 0, -90, 20 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/pipes/pipe_modular_painted_red_64.rmdl", < -142.9707, -1262.496, 15972 >, < -70, -180, 90 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < -97.1555, -1331.196, 15841.14 >, < 20, -180, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_32x144_01.rmdl", < -94.9087, -1285.396, 15842.28 >, < -20, 0, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < -94.8062, -1331.196, 15842 >, < -20, 0, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_32x144_01.rmdl", < -97.2581, -1285.396, 15841.42 >, < 20, -180, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_32x144_01.rmdl", < -97.2581, -1177.296, 15841.42 >, < 20, -180, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < -97.1555, -1133.727, 15841.14 >, < 20, -180, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_32x144_01.rmdl", < -94.9087, -1177.296, 15842.28 >, < -20, 0, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_metal_frame_wall_64x144_01.rmdl", < -94.8064, -1133.727, 15842 >, < -20, 0, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -789.5226, -1233.61, 15727.93 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -1278.523, -1233.61, 15856.93 >, < 0, -90, -20 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -1040.523, -1233.61, 15770.73 >, < 0, -90, -20 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -1867.398, -1234.21, 16018.8 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_02.rmdl", < -1947.489, -1234.21, 16117.97 >, < 90, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_02.rmdl", < -1968.799, -1172.41, 16409.8 >, < 0, -180, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_02.rmdl", < -1947.489, -1234.21, 16251 >, < 90, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_02.rmdl", < -1947.489, -1234.21, 16201.99 >, < 90, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_02.rmdl", < -1968.799, -1234.21, 16095.3 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_02.rmdl", < -1987.898, -1234.21, 16412.3 >, < 90, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_02.rmdl", < -1968.799, -1172.11, 16292.6 >, < 0, -180, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_02.rmdl", < -1968.799, -1299.51, 16162.8 >, < 0, -180, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_02.rmdl", < -1968.799, -1299.41, 16409.8 >, < 0, -180, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_02.rmdl", < -1968.799, -1172.11, 16162.8 >, < 0, -180, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_02.rmdl", < -1987.898, -1234.21, 16454.3 >, < 90, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_02.rmdl", < -1947.489, -1234.21, 16159.97 >, < 90, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_02.rmdl", < -1987.898, -1234.21, 16329.1 >, < 90, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_02.rmdl", < -1969.799, -1234.21, 16390.6 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_02.rmdl", < -1987.898, -1234.21, 16287.2 >, < 90, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_02.rmdl", < -1968.799, -1299.41, 16292.6 >, < 0, -180, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_02.rmdl", < -1987.898, -1234.21, 16370.7 >, < 90, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_02.rmdl", < -1987.898, -1234.21, 16253.6 >, < 90, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_02.rmdl", < -1953.799, -1234.21, 16370.6 >, < -90, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_02.rmdl", < -1989.299, -1234.21, 16117.97 >, < 90, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_02.rmdl", < -1968.799, -1172.41, 16539.7 >, < 0, -180, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_02.rmdl", < -1968.799, -1299.41, 16539.7 >, < 0, -180, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_02.rmdl", < -1953.799, -1234.21, 16585.06 >, < -90, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_02.rmdl", < -1987.898, -1234.21, 16585.3 >, < 90, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_02.rmdl", < -1969.799, -1234.21, 16604.6 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_256_01.rmdl", < -2498.692, -1235.81, 16480.01 >, < 0, -90, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_02.rmdl", < -2024.672, -1172.41, 16487.76 >, < 70, 0, -90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_02.rmdl", < -2024.672, -1298.61, 16487.76 >, < 70, 0, -90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_02.rmdl", < -2145.328, -1172.41, 16443.84 >, < 70, 0, -90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_02.rmdl", < -2145.328, -1298.61, 16443.84 >, < 70, 0, -90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_02.rmdl", < -2264.951, -1172.41, 16400.3 >, < 70, 0, -90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_02.rmdl", < -2264.951, -1298.61, 16400.3 >, < 70, 0, -90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_02.rmdl", < -2039.15, -1298.61, 16527.54 >, < 70, 0, -90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_02.rmdl", < -2279.43, -1172.41, 16440.08 >, < 70, 0, -90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_02.rmdl", < -2279.429, -1298.61, 16440.08 >, < 70, 0, -90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_02.rmdl", < -2039.15, -1172.41, 16527.54 >, < 70, 0, -90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_02.rmdl", < -2159.807, -1172.41, 16483.62 >, < 70, 0, -90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_02.rmdl", < -2159.807, -1298.61, 16483.62 >, < 70, 0, -90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_02.rmdl", < -2150.916, -1255.744, 16509.48 >, < -0.0001, -90, -160 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_02.rmdl", < -2030.26, -1255.744, 16553.4 >, < -0.0001, -90, -160 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_02.rmdl", < -2270.539, -1255.744, 16465.94 >, < -0.0001, -90, -160 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_02.rmdl", < -2030.261, -1213.41, 16553.4 >, < -0.0001, -90, -160 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_02.rmdl", < -2270.541, -1213.41, 16465.95 >, < -0.0001, -90, -160 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/landing_mat_metal_02.rmdl", < -2150.918, -1213.41, 16509.49 >, < -0.0001, -90, -160 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -2230.018, -1234.394, 16375.66 >, < 0, 90, -20 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl", < -2111.941, -1234.394, 16419.06 >, < 0, 90, -20 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -2902.799, -1234.21, 16420.13 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/beacon/beacon_fence_sign_01.rmdl", < -3019.219, -1325.394, 16807.53 >, < -90, -90, 0 >, false, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/beacon/beacon_fence_sign_01.rmdl", < -2827.599, -1366.394, 16921.13 >, < -90, 0, 0 >, false, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/beacon/beacon_fence_sign_01.rmdl", < -2778.577, -1143.595, 17025.13 >, < -90, 90, 0 >, false, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/beacon/beacon_fence_sign_01.rmdl", < -2970.198, -1102.594, 16706.13 >, < -90, -180, 0 >, false, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/barriers/concrete/concrete_barrier_01.rmdl", < -2786.399, -1130.11, 16436.13 >, < 0, 0, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/barriers/concrete/concrete_barrier_01.rmdl", < -2786.399, -1339.31, 16436.13 >, < 0, 0, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -2775.059, -622.8946, 16896.13 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -2774.599, 127.4055, 17035.5 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x64_04.rmdl", < -2719.499, -292.4946, 17143 >, < 0, -90, -90 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x64_04.rmdl", < -2773.999, -297.3946, 17143 >, < 0, -0.0001, -90 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x64_04.rmdl", < -2647.999, -297.3946, 17143 >, < 0, -0.0001, -90 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -2774.559, 379.1055, 17035.43 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -2774.099, 1120.906, 17174.8 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x64_04.rmdl", < -2836.399, 700.9055, 17282.3 >, < 0, -90, -90 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x64_04.rmdl", < -2892.999, 704.6055, 17282.3 >, < 0, -0.0001, -90 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x64_04.rmdl", < -2766.999, 704.6055, 17282.3 >, < 0, -0.0001, -90 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -2774.059, 1375.105, 17174.83 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -3088.999, 1919.706, 17314.2 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x64_04.rmdl", < -2837.899, 1701.005, 17421.7 >, < 0, -90, -90 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x64_04.rmdl", < -2895.799, 1695.406, 17307.4 >, < 0, -0.0001, -90 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x64_04.rmdl", < -2767.799, 1697.805, 17421.7 >, < 0, -0.0001, -90 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -3089.339, 2175.506, 17314.23 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -2773.799, 2780.406, 17453.6 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x64_04.rmdl", < -3025.799, 2512.406, 17561.1 >, < 0, 90, -90 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x64_04.rmdl", < -2967.799, 2518.406, 17446.8 >, < 0, 180, -90 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x64_04.rmdl", < -3095.799, 2518.406, 17561.1 >, < 0, 180, -90 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_256_01.rmdl", < -2595.502, 2909.504, 17700.3 >, < 0, -90, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -2517.802, 2780.404, 17453.61 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/barriers/concrete/concrete_barrier_fence.rmdl", < -2292.802, 2780.404, 17515.61 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -2403.802, 3686.504, 17453.61 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_256_01.rmdl", < -2595.502, 2654.504, 17700.3 >, < 0, -90, 0 >, false, 50000, -1, 1 ) )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_256_01.rmdl", < -2480.693, 3816.428, 17700.3 >, < 0, -90, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/barriers/concrete/concrete_barrier_fence.rmdl", < -2177.993, 3687.328, 17515.61 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    NoClimbArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_256_01.rmdl", < -2480.693, 3561.428, 17700.3 >, < 0, -90, 0 >, false, 50000, -1, 1 ) )
    MapEditor_CreateProp( $"mdl/industrial/security_fence_post.rmdl", < -2158.891, 3688.424, 17578.8 >, < 0, 159.8135, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/industrial/zipline_arm.rmdl", < -2158.229, 3687.328, 17878.8 >, < 0, 69.8135, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -2286.393, 4860.828, 17453.61 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_256_01.rmdl", < -2142.433, 4733.128, 17694.13 >, < 0, 90, 0 >, false, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_256_01.rmdl", < -2142.433, 4988.128, 17694.13 >, < 0, 90, 0 >, false, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -1441.793, 4862.729, 17453.61 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_256_01.rmdl", < -1569.493, 4718.769, 17694.13 >, < 0, 0, 0 >, false, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_256_01.rmdl", < -1314.493, 4718.769, 17694.13 >, < 0, 0, 0 >, false, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -926.0931, 4115.028, 17454.01 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -926.095, 3791.026, 17708.61 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -926.0933, 2994.428, 18022.05 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_256_01.rmdl", < -1053.793, 2850.468, 18262.57 >, < 0, 0, 0 >, false, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_256_01.rmdl", < -798.7932, 2850.468, 18262.57 >, < 0, 0, 0 >, false, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 23.907, 2357.028, 17930.41 >, < 0, -90, 180 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 803.907, 2357.028, 18142.05 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < -926.1963, 3249.929, 18022.05 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 1059.907, 2356.525, 18141.71 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 1835.48, 2357.525, 18433.51 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_256_01.rmdl", < 1932.48, 2357.825, 18625.01 >, < 0, -90, 0 >, false, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 1835.484, 2703.522, 18644.61 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_256_01.rmdl", < 1932.484, 2703.822, 18836.11 >, < 0, -90, 0 >, false, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 1832.481, 3049.821, 18856.01 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_256_01.rmdl", < 1735.481, 3049.521, 19047.51 >, < 0, 90, 0 >, false, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 1832.479, 2703.821, 19067.11 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_256_01.rmdl", < 1735.479, 2703.521, 19258.61 >, < 0, 90, 0 >, false, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 1832.48, 2358.223, 19277.61 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_frame_256_01.rmdl", < 1735.48, 2357.923, 19469.11 >, < 0, 90, 0 >, false, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 1837.905, 2042.028, 19502.3 >, < 0, 89.9999, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 1837.904, 1926.026, 19743.61 >, < -90, 89.9999, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 1837.605, 2167.326, 19743.61 >, < -90, 89.9999, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 1837.902, 964.0281, 19613.3 >, < 0, 89.9999, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 1707.604, 2039.226, 19743.61 >, < 0, 89.9999, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 1949.905, 2038.126, 19743.61 >, < 0, 89.9999, 90 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 1837.905, 709.0281, 19613.61 >, < 0, -90.0001, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl", < 1837.904, 129.0281, 19731.61 >, < 0, -90.0001, 0 >, true, 50000, -1, 1 )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 4.2554, -138.9602, 14912.53 >, < 0, -90, 0 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl", < -192.3446, 346.0398, 15160.53 >, < 0, -90, 180 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl", < 191.5554, 346.0398, 15160.53 >, < 0, 90, 180 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < 513.2554, 386.0398, 15257.53 >, < 0, 0, 0 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl", < 190.6553, 841.0397, 15160.53 >, < 0, 90, 180 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl", < -193.2447, 841.0397, 15160.53 >, < 0, -90, 180 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < -514.9446, 801.0397, 15257.53 >, < 0, -180, 0 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl", < -191.0446, 1278.04, 15160.53 >, < 0, -90, 180 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl", < 192.8554, 1278.04, 15160.53 >, < 0, 90, 180 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < 514.5554, 1318.04, 15257.53 >, < 0, 0, 0 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl", < 358.6554, 1272.34, 15160.53 >, < 0, 0, 180 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl", < 358.6554, 1656.24, 15160.53 >, < 0, -180, 180 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < 318.6555, 1977.94, 15257.53 >, < 0, 90, 0 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl", < 790.2554, 1655.04, 15161.6 >, < 0, -180, 180 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl", < 790.2554, 1271.14, 15161.6 >, < 0, 0, 180 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < 830.2555, 949.4396, 15258.6 >, < 0, -90, 0 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 962.7554, 1908.94, 15087.53 >, < 0, -90, 0 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 1328.956, 1908.94, 15088.23 >, < 0, -90, 90 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 759.1649, 1754.175, 15088.23 >, < 0, 114.3922, 90 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 1184.455, 2030.04, 15270.63 >, < 0, -90, 90 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 503.4042, 1887.1, 15325.6 >, < 0, 90, 90 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 640.1042, 2134.54, 15530 >, < 0, 0, 90 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 366.5042, 1887.1, 15325.6 >, < 0, 90, 90 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 1167.504, 2142.8, 15454.1 >, < 0, 0, 0 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 1174.704, 1990.54, 15535.5 >, < 0, -180, 90 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 650.9554, 2300.04, 15683.03 >, < -0.1, 0, 90 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl", < 697.0554, 2310.44, 15738.23 >, < 0, 0, 180 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl", < 697.0554, 2694.34, 15738.23 >, < 0, -180, 180 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < 657.0555, 3016.04, 15835.23 >, < 0, 90, 0 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl", < 1395.455, 2692.54, 15691.23 >, < 0, -180, 180 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl", < 1395.455, 2308.64, 15691.23 >, < 0, 0, 180 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < 1435.455, 1986.939, 15788.23 >, < 0, -90, 0 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 2072.255, 2485.94, 15584.53 >, < 0, 0, 0 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < 2337.255, 2708.04, 15596.29 >, < 90, 0, 0 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 2201.955, 2252.44, 15843.83 >, < 0, 131.1163, 90 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape.rmdl", < 2703.055, 2223.84, 15824.93 >, < 0, 90, 180 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl", < 2158.955, 2775.04, 15681.53 >, < 0, 0, 90 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape.rmdl", < 2703.055, 1773.84, 15824.93 >, < 0, 90, 180 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape.rmdl", < 2864.657, -863.7548, 16037.53 >, < -90, -180, 0 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape.rmdl", < 2724.657, -1166.355, 16182.63 >, < -90, 0, 0 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl", < 2311.801, 1265.306, 16116 >, < 0, -90, 180 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl", < 2695.701, 1265.306, 16116 >, < 0, 90, 180 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < 3017.401, 1305.306, 16213 >, < 0, 0, 0 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl", < 2698.102, 824.1056, 16116 >, < 0, 90, 180 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl", < 2314.201, 824.1056, 16116 >, < 0, -90, 180 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < 1992.501, 784.1056, 16213 >, < 0, -180, 0 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl", < 2702.401, 134.6055, 16116 >, < 0, 90, 180 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl", < 2318.501, 134.6055, 16116 >, < 0, -90, 180 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < 1996.801, 49.6055, 16213 >, < 0, -180, 0 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl", < 2702.401, 328.5055, 16116 >, < 0, 90, 180 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl", < 2318.501, 328.5055, 16116 >, < 0, -90, 180 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl", < 2702.401, -500.1945, 16116 >, < 0, 90, 180 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl", < 2318.501, -500.1945, 16116 >, < 0, -90, 180 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < 1996.801, -585.1945, 16213 >, < 0, -180, 0 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl", < 2702.401, -306.2945, 16116 >, < 0, 90, 180 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl", < 2318.501, -306.2945, 16116 >, < 0, -90, 180 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl", < 1697.401, -1316.7, 16296.43 >, < 0, 0, 160 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl", < 1697.401, -955.9515, 16165.13 >, < 0, -180, -160 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < 1657.401, -620.4764, 16146.25 >, < 20, 90, 0 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl", < 2148.401, -960.5182, 16155.2 >, < 0, -180, -160 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl", < 2148.401, -1321.266, 16286.5 >, < 0, 0, 160 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < 2188.401, -1590.389, 16487.68 >, < -20, -90, 0 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl", < 1223.657, -1119.522, 16275.73 >, < 0, -180, 165 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl", < 1223.657, -1490.341, 16176.37 >, < 0, 0, -165 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < 1263.657, -1826.185, 16186.8 >, < 15, -90, 0 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl", < 776.6567, -1486.11, 16182.75 >, < 0, 0, -165 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl", < 776.6567, -1115.291, 16282.11 >, < 0, -180, 165 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < 736.6567, -829.6583, 16459.07 >, < -15, 90, 0 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl", < 259.158, -1043.794, 16255.32 >, < 20, -180, 180 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl", < 259.1581, -1427.694, 16255.32 >, < -20, 0, 180 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < 263.5699, -1749.394, 16360.15 >, < 0, -90, 20 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl", < -164.2762, -1424.194, 16112.61 >, < -20, 0, 180 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl", < -164.2762, -1040.294, 16112.61 >, < 20, -180, 180 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < -235.0397, -718.5942, 16190.08 >, < 0, 90, -20 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl", < 2697.7, 1775.2, 16138.3 >, < 0, 90, 180 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl", < 2313.8, 1775.2, 16138.3 >, < 0, -90, 180 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < 1992.1, 1735.2, 16235.3 >, < 0, -180, 0 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl", < 2314.9, 2240, 16136.1 >, < 0, -90, 180 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl", < 2698.8, 2240, 16136.1 >, < 0, 90, 180 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/construction_bldg_platform_01.rmdl", < 3020.5, 2280, 16233.1 >, < 0, 0, 0 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_02.rmdl", < -1963.799, -1234.21, 16235.2 >, < 0, -180, 0 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl", < -1988.345, -1108.66, 16724.72 >, < 0, -180, 180 >, false, 50000, -1, 1 ) )
    InvisibleArray.append( MapEditor_CreateProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl", < -1988.345, -1362.06, 16724.72 >, < 0, 0, 180 >, false, 50000, -1, 1 ) )

    foreach ( entity ent in NoClimbArray ) ent.kv.solid = 3
    foreach ( entity ent in InvisibleArray ) ent.MakeInvisible()

    // VerticalZipLines
    MapEditor_CreateZiplineFromUnity( < -2211.231, 3702.553, 17866.8 >, < 0, 91.5, 0 >, < -2211.231, 3702.553, 17531.5 >, < 0, 91.5, 0 >, true, -1, 1, 2, 1, 1, 1, 1, 25, 25, false, 1, false, 0, 0, [  ], [  ], [  ], 32, 60, 0 )

    // Triggers
    entity trigger_0 = MapEditor_CreateTrigger( < 0.23, -1.96, 14976.83 >, < 0, 0, 0 >, 100, 50, false )
    trigger_0.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) { // validates is valid player
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){ // validades noclip is off
        int reset = 0
        if (ent in file.cp_table) { // validates if player has a previous cp saved
            if (file.cp_table[ent] != < 0.23, -1.96, 14976.83 >) { // validades if saved cp is different from the current one
                file.cp_table[ent] <- < 0.23, -1.96, 14976.83 > 

                // display timer
                if(ent.GetPersistentVarAsInt("gen") != reset){
                    ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                    int seconds = ent.GetPersistentVarAsInt( "xp" )
                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)
                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                    } else {
                        int minutes = seconds
                        Message(ent, "Current Time: " + seconds + " seconds" )
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 0.23, -1.96, 14976.83 >

            // display timer
            if(ent.GetPersistentVarAsInt("gen") != reset){
                ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                int seconds = ent.GetPersistentVarAsInt( "xp" )
                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)
                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                } else {
                    int minutes = seconds
                    Message(ent, "Current Time: " + seconds + " seconds" )
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_0 )
    entity trigger_2 = MapEditor_CreateTrigger( < -0.605, 935.1892, 14975.9 >, < 0, -0.3712, 0 >, 100, 50, false )
    trigger_2.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) { // validates is valid player
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){ // validades noclip is off
        int reset = 0
        if (ent in file.cp_table) { // validates if player has a previous cp saved
            if (file.cp_table[ent] != < -0.605, 935.1892, 14975.9 >) { // validades if saved cp is different from the current one
                file.cp_table[ent] <- < -0.605, 935.1892, 14975.9 > 

                // display timer
                if(ent.GetPersistentVarAsInt("gen") != reset){
                    ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                    int seconds = ent.GetPersistentVarAsInt( "xp" )
                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)
                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                    } else {
                        int minutes = seconds
                        Message(ent, "Current Time: " + seconds + " seconds" )
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < -0.605, 935.1892, 14975.9 >

            // display timer
            if(ent.GetPersistentVarAsInt("gen") != reset){
                ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                int seconds = ent.GetPersistentVarAsInt( "xp" )
                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)
                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                } else {
                    int minutes = seconds
                    Message(ent, "Current Time: " + seconds + " seconds" )
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_2 )
    entity trigger_3 = MapEditor_CreateTrigger( < 449.8101, 1462.4, 14978 >, < 0, -90, 0 >, 100, 50, false )
    trigger_3.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) { // validates is valid player
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){ // validades noclip is off
        int reset = 0
        if (ent in file.cp_table) { // validates if player has a previous cp saved
            if (file.cp_table[ent] != < 449.8101, 1462.4, 14978 >) { // validades if saved cp is different from the current one
                file.cp_table[ent] <- < 449.8101, 1462.4, 14978 > 

                // display timer
                if(ent.GetPersistentVarAsInt("gen") != reset){
                    ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                    int seconds = ent.GetPersistentVarAsInt( "xp" )
                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)
                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                    } else {
                        int minutes = seconds
                        Message(ent, "Current Time: " + seconds + " seconds" )
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 449.8101, 1462.4, 14978 >

            // display timer
            if(ent.GetPersistentVarAsInt("gen") != reset){
                ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                int seconds = ent.GetPersistentVarAsInt( "xp" )
                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)
                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                } else {
                    int minutes = seconds
                    Message(ent, "Current Time: " + seconds + " seconds" )
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_3 )
    entity trigger_4 = MapEditor_CreateTrigger( < 1045, 1906.516, 14986.4 >, < 0, 0, 0 >, 100, 50, false )
    trigger_4.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) { // validates is valid player
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){ // validades noclip is off
        int reset = 0
        if (ent in file.cp_table) { // validates if player has a previous cp saved
            if (file.cp_table[ent] != < 1045, 1906.516, 14986.4 >) { // validades if saved cp is different from the current one
                file.cp_table[ent] <- < 1045, 1906.516, 14986.4 > 

                // display timer
                if(ent.GetPersistentVarAsInt("gen") != reset){
                    ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                    int seconds = ent.GetPersistentVarAsInt( "xp" )
                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)
                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                    } else {
                        int minutes = seconds
                        Message(ent, "Current Time: " + seconds + " seconds" )
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 1045, 1906.516, 14986.4 >

            // display timer
            if(ent.GetPersistentVarAsInt("gen") != reset){
                ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                int seconds = ent.GetPersistentVarAsInt( "xp" )
                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)
                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                } else {
                    int minutes = seconds
                    Message(ent, "Current Time: " + seconds + " seconds" )
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_4 )
    entity trigger_5 = MapEditor_CreateTrigger( < 1042.604, 2158.8, 15107.4 >, < 0, 90, 0 >, 100, 50, false )
    trigger_5.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) { // validates is valid player
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){ // validades noclip is off
        int reset = 0
        if (ent in file.cp_table) { // validates if player has a previous cp saved
            if (file.cp_table[ent] != < 1042.604, 2158.8, 15107.4 >) { // validades if saved cp is different from the current one
                file.cp_table[ent] <- < 1042.604, 2158.8, 15107.4 > 

                // display timer
                if(ent.GetPersistentVarAsInt("gen") != reset){
                    ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                    int seconds = ent.GetPersistentVarAsInt( "xp" )
                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)
                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                    } else {
                        int minutes = seconds
                        Message(ent, "Current Time: " + seconds + " seconds" )
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 1042.604, 2158.8, 15107.4 >

            // display timer
            if(ent.GetPersistentVarAsInt("gen") != reset){
                ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                int seconds = ent.GetPersistentVarAsInt( "xp" )
                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)
                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                } else {
                    int minutes = seconds
                    Message(ent, "Current Time: " + seconds + " seconds" )
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_5 )
    entity trigger_6 = MapEditor_CreateTrigger( < 785.3042, 2153.5, 15237.8 >, < 0, -90, 0 >, 100, 50, false )
    trigger_6.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) { // validates is valid player
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){ // validades noclip is off
        int reset = 0
        if (ent in file.cp_table) { // validates if player has a previous cp saved
            if (file.cp_table[ent] != < 785.3042, 2153.5, 15237.8 >) { // validades if saved cp is different from the current one
                file.cp_table[ent] <- < 785.3042, 2153.5, 15237.8 > 

                // display timer
                if(ent.GetPersistentVarAsInt("gen") != reset){
                    ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                    int seconds = ent.GetPersistentVarAsInt( "xp" )
                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)
                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                    } else {
                        int minutes = seconds
                        Message(ent, "Current Time: " + seconds + " seconds" )
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 785.3042, 2153.5, 15237.8 >

            // display timer
            if(ent.GetPersistentVarAsInt("gen") != reset){
                ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                int seconds = ent.GetPersistentVarAsInt( "xp" )
                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)
                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                } else {
                    int minutes = seconds
                    Message(ent, "Current Time: " + seconds + " seconds" )
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_6 )
    entity trigger_7 = MapEditor_CreateTrigger( < 1042.391, 2258.806, 15382 >, < 0, 90, 0 >, 100, 50, false )
    trigger_7.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) { // validates is valid player
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){ // validades noclip is off
        int reset = 0
        if (ent in file.cp_table) { // validates if player has a previous cp saved
            if (file.cp_table[ent] != < 1042.391, 2258.806, 15382 >) { // validades if saved cp is different from the current one
                file.cp_table[ent] <- < 1042.391, 2258.806, 15382 > 

                // display timer
                if(ent.GetPersistentVarAsInt("gen") != reset){
                    ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                    int seconds = ent.GetPersistentVarAsInt( "xp" )
                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)
                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                    } else {
                        int minutes = seconds
                        Message(ent, "Current Time: " + seconds + " seconds" )
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 1042.391, 2258.806, 15382 >

            // display timer
            if(ent.GetPersistentVarAsInt("gen") != reset){
                ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                int seconds = ent.GetPersistentVarAsInt( "xp" )
                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)
                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                } else {
                    int minutes = seconds
                    Message(ent, "Current Time: " + seconds + " seconds" )
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_7 )
    entity trigger_8 = MapEditor_CreateTrigger( < 1041.99, 2501.5, 15529.8 >, < 0, 90, 0 >, 100, 50, false )
    trigger_8.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) { // validates is valid player
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){ // validades noclip is off
        int reset = 0
        if (ent in file.cp_table) { // validates if player has a previous cp saved
            if (file.cp_table[ent] != < 1041.99, 2501.5, 15529.8 >) { // validades if saved cp is different from the current one
                file.cp_table[ent] <- < 1041.99, 2501.5, 15529.8 > 

                // display timer
                if(ent.GetPersistentVarAsInt("gen") != reset){
                    ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                    int seconds = ent.GetPersistentVarAsInt( "xp" )
                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)
                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                    } else {
                        int minutes = seconds
                        Message(ent, "Current Time: " + seconds + " seconds" )
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 1041.99, 2501.5, 15529.8 >

            // display timer
            if(ent.GetPersistentVarAsInt("gen") != reset){
                ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                int seconds = ent.GetPersistentVarAsInt( "xp" )
                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)
                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                } else {
                    int minutes = seconds
                    Message(ent, "Current Time: " + seconds + " seconds" )
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_8 )
    entity trigger_9 = MapEditor_CreateTrigger( < 1947.6, 2498.8, 15529.9 >, < 0, 90, 0 >, 100, 50, false )
    trigger_9.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) { // validates is valid player
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){ // validades noclip is off
        int reset = 0
        if (ent in file.cp_table) { // validates if player has a previous cp saved
            if (file.cp_table[ent] != < 1869.1, 2498.8, 15529.9 >) { // validades if saved cp is different from the current one
                file.cp_table[ent] <- < 1869.1, 2498.8, 15529.9 > 

                // display timer
                if(ent.GetPersistentVarAsInt("gen") != reset){
                    ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                    int seconds = ent.GetPersistentVarAsInt( "xp" )
                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)
                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                    } else {
                        int minutes = seconds
                        Message(ent, "Current Time: " + seconds + " seconds" )
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 1869.1, 2498.8, 15529.9 >

            // display timer
            if(ent.GetPersistentVarAsInt("gen") != reset){
                ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                int seconds = ent.GetPersistentVarAsInt( "xp" )
                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)
                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                } else {
                    int minutes = seconds
                    Message(ent, "Current Time: " + seconds + " seconds" )
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_9 )
    entity trigger_10 = MapEditor_CreateTrigger( < 2506.6, 2127.99, 15639.9 >, < 0, -180, 0 >, 100, 50, false )
    trigger_10.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) { // validates is valid player
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){ // validades noclip is off
        int reset = 0
        if (ent in file.cp_table) { // validates if player has a previous cp saved
            if (file.cp_table[ent] != < 2506.6, 2175.89, 15639.9 >) { // validades if saved cp is different from the current one
                file.cp_table[ent] <- < 2506.6, 2175.89, 15639.9 > 

                // display timer
                if(ent.GetPersistentVarAsInt("gen") != reset){
                    ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                    int seconds = ent.GetPersistentVarAsInt( "xp" )
                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)
                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                    } else {
                        int minutes = seconds
                        Message(ent, "Current Time: " + seconds + " seconds" )
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 2506.6, 2175.89, 15639.9 >

            // display timer
            if(ent.GetPersistentVarAsInt("gen") != reset){
                ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                int seconds = ent.GetPersistentVarAsInt( "xp" )
                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)
                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                } else {
                    int minutes = seconds
                    Message(ent, "Current Time: " + seconds + " seconds" )
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_10 )
    entity trigger_11 = MapEditor_CreateTrigger( < 2380.6, 1871.11, 15786 >, < 0, 0, 0 >, 100, 50, false )
    trigger_11.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) { // validates is valid player
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){ // validades noclip is off
        int reset = 0
        if (ent in file.cp_table) { // validates if player has a previous cp saved
            if (file.cp_table[ent] != < 2380.6, 1820.01, 15786 >) { // validades if saved cp is different from the current one
                file.cp_table[ent] <- < 2380.6, 1820.01, 15786 > 

                // display timer
                if(ent.GetPersistentVarAsInt("gen") != reset){
                    ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                    int seconds = ent.GetPersistentVarAsInt( "xp" )
                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)
                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                    } else {
                        int minutes = seconds
                        Message(ent, "Current Time: " + seconds + " seconds" )
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 2380.6, 1820.01, 15786 >

            // display timer
            if(ent.GetPersistentVarAsInt("gen") != reset){
                ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                int seconds = ent.GetPersistentVarAsInt( "xp" )
                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)
                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                } else {
                    int minutes = seconds
                    Message(ent, "Current Time: " + seconds + " seconds" )
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_11 )
    entity trigger_12 = MapEditor_CreateTrigger( < 2506.6, 2127.99, 15927.9 >, < 0, -180, 0 >, 100, 50, false )
    trigger_12.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) { // validates is valid player
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){ // validades noclip is off
        int reset = 0
        if (ent in file.cp_table) { // validates if player has a previous cp saved
            if (file.cp_table[ent] != < 2506.6, 2198.49, 15927.9 >) { // validades if saved cp is different from the current one
                file.cp_table[ent] <- < 2506.6, 2198.49, 15927.9 > 

                // display timer
                if(ent.GetPersistentVarAsInt("gen") != reset){
                    ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                    int seconds = ent.GetPersistentVarAsInt( "xp" )
                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)
                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                    } else {
                        int minutes = seconds
                        Message(ent, "Current Time: " + seconds + " seconds" )
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 2506.6, 2198.49, 15927.9 >

            // display timer
            if(ent.GetPersistentVarAsInt("gen") != reset){
                ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                int seconds = ent.GetPersistentVarAsInt( "xp" )
                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)
                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                } else {
                    int minutes = seconds
                    Message(ent, "Current Time: " + seconds + " seconds" )
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_12 )
    entity trigger_13 = MapEditor_CreateTrigger( < 2508.5, 1167.924, 15927.99 >, < 0, 0, 0 >, 100, 50, false )
    trigger_13.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) { // validates is valid player
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){ // validades noclip is off
        int reset = 0
        if (ent in file.cp_table) { // validates if player has a previous cp saved
            if (file.cp_table[ent] != < 2508.5, 1249.024, 15927.99 >) { // validades if saved cp is different from the current one
                file.cp_table[ent] <- < 2508.5, 1249.024, 15927.99 > 

                // display timer
                if(ent.GetPersistentVarAsInt("gen") != reset){
                    ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                    int seconds = ent.GetPersistentVarAsInt( "xp" )
                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)
                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                    } else {
                        int minutes = seconds
                        Message(ent, "Current Time: " + seconds + " seconds" )
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 2508.5, 1249.024, 15927.99 >

            // display timer
            if(ent.GetPersistentVarAsInt("gen") != reset){
                ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                int seconds = ent.GetPersistentVarAsInt( "xp" )
                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)
                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                } else {
                    int minutes = seconds
                    Message(ent, "Current Time: " + seconds + " seconds" )
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_13 )
    entity trigger_14 = MapEditor_CreateTrigger( < 2511.8, 235.0001, 15926.24 >, < 0, 0, 0 >, 100, 50, false )
    trigger_14.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) { // validates is valid player
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){ // validades noclip is off
        int reset = 0
        if (ent in file.cp_table) { // validates if player has a previous cp saved
            if (file.cp_table[ent] != < 2511.8, 315.3, 15926.24 >) { // validades if saved cp is different from the current one
                file.cp_table[ent] <- < 2511.8, 315.3, 15926.24 > 

                // display timer
                if(ent.GetPersistentVarAsInt("gen") != reset){
                    ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                    int seconds = ent.GetPersistentVarAsInt( "xp" )
                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)
                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                    } else {
                        int minutes = seconds
                        Message(ent, "Current Time: " + seconds + " seconds" )
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 2511.8, 315.3, 15926.24 >

            // display timer
            if(ent.GetPersistentVarAsInt("gen") != reset){
                ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                int seconds = ent.GetPersistentVarAsInt( "xp" )
                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)
                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                } else {
                    int minutes = seconds
                    Message(ent, "Current Time: " + seconds + " seconds" )
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_14 )
    entity trigger_15 = MapEditor_CreateTrigger( < 2511.399, -401.3964, 15926.24 >, < 0, 0, 0 >, 100, 50, false )
    trigger_15.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) { // validates is valid player
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){ // validades noclip is off
        int reset = 0
        if (ent in file.cp_table) { // validates if player has a previous cp saved
            if (file.cp_table[ent] != < 2511.399, -318.5964, 15926.24 >) { // validades if saved cp is different from the current one
                file.cp_table[ent] <- < 2511.399, -318.5964, 15926.24 > 

                // display timer
                if(ent.GetPersistentVarAsInt("gen") != reset){
                    ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                    int seconds = ent.GetPersistentVarAsInt( "xp" )
                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)
                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                    } else {
                        int minutes = seconds
                        Message(ent, "Current Time: " + seconds + " seconds" )
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 2511.399, -318.5964, 15926.24 >

            // display timer
            if(ent.GetPersistentVarAsInt("gen") != reset){
                ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                int seconds = ent.GetPersistentVarAsInt( "xp" )
                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)
                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                } else {
                    int minutes = seconds
                    Message(ent, "Current Time: " + seconds + " seconds" )
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_15 )
    entity trigger_16 = MapEditor_CreateTrigger( < 2998.716, -806.3245, 15923.46 >, < 0, 0, 0 >, 100, 50, false )
    trigger_16.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) { // validates is valid player
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){ // validades noclip is off
        int reset = 0
        if (ent in file.cp_table) { // validates if player has a previous cp saved
            if (file.cp_table[ent] != < 3074.016, -730.1245, 15923.46 >) { // validades if saved cp is different from the current one
                file.cp_table[ent] <- < 3074.016, -730.1245, 15923.46 > 

                // display timer
                if(ent.GetPersistentVarAsInt("gen") != reset){
                    ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                    int seconds = ent.GetPersistentVarAsInt( "xp" )
                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)
                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                    } else {
                        int minutes = seconds
                        Message(ent, "Current Time: " + seconds + " seconds" )
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 3074.016, -730.1245, 15923.46 >

            // display timer
            if(ent.GetPersistentVarAsInt("gen") != reset){
                ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                int seconds = ent.GetPersistentVarAsInt( "xp" )
                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)
                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                } else {
                    int minutes = seconds
                    Message(ent, "Current Time: " + seconds + " seconds" )
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_16 )
    entity trigger_17 = MapEditor_CreateTrigger( < 2584.598, -1233.396, 15929.7 >, < 0, 0, 0 >, 100, 50, false )
    trigger_17.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) { // validates is valid player
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){ // validades noclip is off
        int reset = 0
        if (ent in file.cp_table) { // validates if player has a previous cp saved
            if (file.cp_table[ent] != < 2584.598, -1233.396, 15929.7 >) { // validades if saved cp is different from the current one
                file.cp_table[ent] <- < 2584.598, -1233.396, 15929.7 > 

                // display timer
                if(ent.GetPersistentVarAsInt("gen") != reset){
                    ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                    int seconds = ent.GetPersistentVarAsInt( "xp" )
                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)
                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                    } else {
                        int minutes = seconds
                        Message(ent, "Current Time: " + seconds + " seconds" )
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 2584.598, -1233.396, 15929.7 >

            // display timer
            if(ent.GetPersistentVarAsInt("gen") != reset){
                ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                int seconds = ent.GetPersistentVarAsInt( "xp" )
                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)
                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                } else {
                    int minutes = seconds
                    Message(ent, "Current Time: " + seconds + " seconds" )
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_17 )
    entity trigger_18 = MapEditor_CreateTrigger( < 2048.021, -1205.619, 16044.5 >, < -20, -90, 0 >, 100, 50, false )
    trigger_18.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) { // validates is valid player
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){ // validades noclip is off
        int reset = 0
        if (ent in file.cp_table) { // validates if player has a previous cp saved
            if (file.cp_table[ent] != < 2129.521, -1205.619, 16044.5 >) { // validades if saved cp is different from the current one
                file.cp_table[ent] <- < 2129.521, -1205.619, 16044.5 > 

                // display timer
                if(ent.GetPersistentVarAsInt("gen") != reset){
                    ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                    int seconds = ent.GetPersistentVarAsInt( "xp" )
                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)
                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                    } else {
                        int minutes = seconds
                        Message(ent, "Current Time: " + seconds + " seconds" )
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 2129.521, -1205.619, 16044.5 >

            // display timer
            if(ent.GetPersistentVarAsInt("gen") != reset){
                ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                int seconds = ent.GetPersistentVarAsInt( "xp" )
                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)
                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                } else {
                    int minutes = seconds
                    Message(ent, "Current Time: " + seconds + " seconds" )
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_18 )
    entity trigger_19 = MapEditor_CreateTrigger( < 1119.974, -1252.684, 16047.24 >, < 15, -90, 0 >, 100, 50, false )
    trigger_19.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) { // validates is valid player
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){ // validades noclip is off
        int reset = 0
        if (ent in file.cp_table) { // validates if player has a previous cp saved
            if (file.cp_table[ent] != < 1200.374, -1252.684, 16047.24 >) { // validades if saved cp is different from the current one
                file.cp_table[ent] <- < 1200.374, -1252.684, 16047.24 > 

                // display timer
                if(ent.GetPersistentVarAsInt("gen") != reset){
                    ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                    int seconds = ent.GetPersistentVarAsInt( "xp" )
                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)
                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                    } else {
                        int minutes = seconds
                        Message(ent, "Current Time: " + seconds + " seconds" )
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 1200.374, -1252.684, 16047.24 >

            // display timer
            if(ent.GetPersistentVarAsInt("gen") != reset){
                ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                int seconds = ent.GetPersistentVarAsInt( "xp" )
                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)
                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                } else {
                    int minutes = seconds
                    Message(ent, "Current Time: " + seconds + " seconds" )
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_19 )
    entity trigger_20 = MapEditor_CreateTrigger( < 229.5698, -1232.496, 16042.89 >, < 0, -90, 20 >, 100, 50, false )
    trigger_20.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) { // validates is valid player
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){ // validades noclip is off
        int reset = 0
        if (ent in file.cp_table) { // validates if player has a previous cp saved
            if (file.cp_table[ent] != < 305.9668, -1232.496, 16070.7 >) { // validades if saved cp is different from the current one
                file.cp_table[ent] <- < 305.9668, -1232.496, 16070.7 > 

                // display timer
                if(ent.GetPersistentVarAsInt("gen") != reset){
                    ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                    int seconds = ent.GetPersistentVarAsInt( "xp" )
                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)
                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                    } else {
                        int minutes = seconds
                        Message(ent, "Current Time: " + seconds + " seconds" )
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 305.9668, -1232.496, 16070.7 >

            // display timer
            if(ent.GetPersistentVarAsInt("gen") != reset){
                ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                int seconds = ent.GetPersistentVarAsInt( "xp" )
                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)
                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                } else {
                    int minutes = seconds
                    Message(ent, "Current Time: " + seconds + " seconds" )
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_20 )
    entity trigger_21 = MapEditor_CreateTrigger( < -789.5226, -1233.61, 15805.93 >, < 0, -90, 0 >, 100, 50, false )
    trigger_21.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) { // validates is valid player
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){ // validades noclip is off
        int reset = 0
        if (ent in file.cp_table) { // validates if player has a previous cp saved
            if (file.cp_table[ent] != < -789.5226, -1233.61, 15805.93 >) { // validades if saved cp is different from the current one
                file.cp_table[ent] <- < -789.5226, -1233.61, 15805.93 > 

                // display timer
                if(ent.GetPersistentVarAsInt("gen") != reset){
                    ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                    int seconds = ent.GetPersistentVarAsInt( "xp" )
                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)
                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                    } else {
                        int minutes = seconds
                        Message(ent, "Current Time: " + seconds + " seconds" )
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < -789.5226, -1233.61, 15805.93 >

            // display timer
            if(ent.GetPersistentVarAsInt("gen") != reset){
                ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                int seconds = ent.GetPersistentVarAsInt( "xp" )
                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)
                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                } else {
                    int minutes = seconds
                    Message(ent, "Current Time: " + seconds + " seconds" )
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_21 )
    entity trigger_22 = MapEditor_CreateTrigger( < -1867.398, -1234.21, 16096 >, < 0, -180, 0 >, 100, 50, false )
    trigger_22.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) { // validates is valid player
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){ // validades noclip is off
        int reset = 0
        if (ent in file.cp_table) { // validates if player has a previous cp saved
            if (file.cp_table[ent] != < -1788.398, -1234.21, 16096 >) { // validades if saved cp is different from the current one
                file.cp_table[ent] <- < -1788.398, -1234.21, 16096 > 

                // display timer
                if(ent.GetPersistentVarAsInt("gen") != reset){
                    ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                    int seconds = ent.GetPersistentVarAsInt( "xp" )
                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)
                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                    } else {
                        int minutes = seconds
                        Message(ent, "Current Time: " + seconds + " seconds" )
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < -1788.398, -1234.21, 16096 >

            // display timer
            if(ent.GetPersistentVarAsInt("gen") != reset){
                ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                int seconds = ent.GetPersistentVarAsInt( "xp" )
                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)
                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                } else {
                    int minutes = seconds
                    Message(ent, "Current Time: " + seconds + " seconds" )
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_22 )
    entity trigger_23 = MapEditor_CreateTrigger( < -1972.274, -1234.21, 16517.47 >, < 20, -180, 0 >, 50, 20, false )
    trigger_23.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) { // validates is valid player
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){ // validades noclip is off
        int reset = 0
        if (ent in file.cp_table) { // validates if player has a previous cp saved
            if (file.cp_table[ent] != < -1972.274, -1234.21, 16517.47 >) { // validades if saved cp is different from the current one
                file.cp_table[ent] <- < -1972.274, -1234.21, 16517.47 > 

                // display timer
                if(ent.GetPersistentVarAsInt("gen") != reset){
                    ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                    int seconds = ent.GetPersistentVarAsInt( "xp" )
                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)
                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                    } else {
                        int minutes = seconds
                        Message(ent, "Current Time: " + seconds + " seconds" )
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < -1972.274, -1234.21, 16517.47 >

            // display timer
            if(ent.GetPersistentVarAsInt("gen") != reset){
                ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                int seconds = ent.GetPersistentVarAsInt( "xp" )
                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)
                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                } else {
                    int minutes = seconds
                    Message(ent, "Current Time: " + seconds + " seconds" )
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_23 )
    entity trigger_24 = MapEditor_CreateTrigger( < -2902.799, -1234.21, 16498.13 >, < 0, -180, 0 >, 100, 50, false )
    trigger_24.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) { // validates is valid player
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){ // validades noclip is off
        int reset = 0
        if (ent in file.cp_table) { // validates if player has a previous cp saved
            if (file.cp_table[ent] != < -2902.799, -1234.21, 16498.13 >) { // validades if saved cp is different from the current one
                file.cp_table[ent] <- < -2902.799, -1234.21, 16498.13 > 

                // display timer
                if(ent.GetPersistentVarAsInt("gen") != reset){
                    ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                    int seconds = ent.GetPersistentVarAsInt( "xp" )
                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)
                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                    } else {
                        int minutes = seconds
                        Message(ent, "Current Time: " + seconds + " seconds" )
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < -2902.799, -1234.21, 16498.13 >

            // display timer
            if(ent.GetPersistentVarAsInt("gen") != reset){
                ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                int seconds = ent.GetPersistentVarAsInt( "xp" )
                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)
                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                } else {
                    int minutes = seconds
                    Message(ent, "Current Time: " + seconds + " seconds" )
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_24 )
    entity trigger_25 = MapEditor_CreateTrigger( < -2775.059, -622.8948, 16966.13 >, < 0, -90, 0 >, 100, 50, false )
    trigger_25.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) { // validates is valid player
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){ // validades noclip is off
        int reset = 0
        if (ent in file.cp_table) { // validates if player has a previous cp saved
            if (file.cp_table[ent] != < -2775.059, -700.4949, 16966.13 >) { // validades if saved cp is different from the current one
                file.cp_table[ent] <- < -2775.059, -700.4949, 16966.13 > 

                // display timer
                if(ent.GetPersistentVarAsInt("gen") != reset){
                    ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                    int seconds = ent.GetPersistentVarAsInt( "xp" )
                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)
                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                    } else {
                        int minutes = seconds
                        Message(ent, "Current Time: " + seconds + " seconds" )
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < -2775.059, -700.4949, 16966.13 >

            // display timer
            if(ent.GetPersistentVarAsInt("gen") != reset){
                ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                int seconds = ent.GetPersistentVarAsInt( "xp" )
                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)
                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                } else {
                    int minutes = seconds
                    Message(ent, "Current Time: " + seconds + " seconds" )
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_25 )
    entity trigger_26 = MapEditor_CreateTrigger( < -2774.599, 127.4053, 17110.5 >, < 0, -90, 0 >, 100, 50, false )
    trigger_26.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) { // validates is valid player
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){ // validades noclip is off
        int reset = 0
        if (ent in file.cp_table) { // validates if player has a previous cp saved
            if (file.cp_table[ent] != < -2774.599, 48.7052, 17110.5 >) { // validades if saved cp is different from the current one
                file.cp_table[ent] <- < -2774.599, 48.7052, 17110.5 > 

                // display timer
                if(ent.GetPersistentVarAsInt("gen") != reset){
                    ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                    int seconds = ent.GetPersistentVarAsInt( "xp" )
                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)
                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                    } else {
                        int minutes = seconds
                        Message(ent, "Current Time: " + seconds + " seconds" )
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < -2774.599, 48.7052, 17110.5 >

            // display timer
            if(ent.GetPersistentVarAsInt("gen") != reset){
                ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                int seconds = ent.GetPersistentVarAsInt( "xp" )
                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)
                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                } else {
                    int minutes = seconds
                    Message(ent, "Current Time: " + seconds + " seconds" )
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_26 )
    entity trigger_27 = MapEditor_CreateTrigger( < -2774.099, 1120.905, 17249.8 >, < 0, -90, 0 >, 100, 50, false )
    trigger_27.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) { // validates is valid player
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){ // validades noclip is off
        int reset = 0
        if (ent in file.cp_table) { // validates if player has a previous cp saved
            if (file.cp_table[ent] != < -2774.099, 1043.105, 17249.8 >) { // validades if saved cp is different from the current one
                file.cp_table[ent] <- < -2774.099, 1043.105, 17249.8 > 

                // display timer
                if(ent.GetPersistentVarAsInt("gen") != reset){
                    ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                    int seconds = ent.GetPersistentVarAsInt( "xp" )
                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)
                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                    } else {
                        int minutes = seconds
                        Message(ent, "Current Time: " + seconds + " seconds" )
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < -2774.099, 1043.105, 17249.8 >

            // display timer
            if(ent.GetPersistentVarAsInt("gen") != reset){
                ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                int seconds = ent.GetPersistentVarAsInt( "xp" )
                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)
                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                } else {
                    int minutes = seconds
                    Message(ent, "Current Time: " + seconds + " seconds" )
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_27 )
    entity trigger_28 = MapEditor_CreateTrigger( < -3088.999, 1919.706, 17389.2 >, < 0, -90, 0 >, 100, 50, false )
    trigger_28.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) { // validates is valid player
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){ // validades noclip is off
        int reset = 0
        if (ent in file.cp_table) { // validates if player has a previous cp saved
            if (file.cp_table[ent] != < -3088.999, 1841.806, 17389.2 >) { // validades if saved cp is different from the current one
                file.cp_table[ent] <- < -3088.999, 1841.806, 17389.2 > 

                // display timer
                if(ent.GetPersistentVarAsInt("gen") != reset){
                    ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                    int seconds = ent.GetPersistentVarAsInt( "xp" )
                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)
                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                    } else {
                        int minutes = seconds
                        Message(ent, "Current Time: " + seconds + " seconds" )
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < -3088.999, 1841.806, 17389.2 >

            // display timer
            if(ent.GetPersistentVarAsInt("gen") != reset){
                ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                int seconds = ent.GetPersistentVarAsInt( "xp" )
                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)
                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                } else {
                    int minutes = seconds
                    Message(ent, "Current Time: " + seconds + " seconds" )
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_28 )
    entity trigger_29 = MapEditor_CreateTrigger( < -2777.502, 2780.404, 17528.61 >, < 0, 0, 0 >, 100, 50, false )
    trigger_29.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) { // validates is valid player
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){ // validades noclip is off
        int reset = 0
        if (ent in file.cp_table) { // validates if player has a previous cp saved
            if (file.cp_table[ent] != < -2493.302, 2701.004, 17528.61 >) { // validades if saved cp is different from the current one
                file.cp_table[ent] <- < -2493.302, 2701.004, 17528.61 > 

                // display timer
                if(ent.GetPersistentVarAsInt("gen") != reset){
                    ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                    int seconds = ent.GetPersistentVarAsInt( "xp" )
                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)
                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                    } else {
                        int minutes = seconds
                        Message(ent, "Current Time: " + seconds + " seconds" )
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < -2493.302, 2701.004, 17528.61 >

            // display timer
            if(ent.GetPersistentVarAsInt("gen") != reset){
                ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                int seconds = ent.GetPersistentVarAsInt( "xp" )
                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)
                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                } else {
                    int minutes = seconds
                    Message(ent, "Current Time: " + seconds + " seconds" )
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_29 )
    entity trigger_30 = MapEditor_CreateTrigger( < -2397.293, 3687.328, 17528.61 >, < 0, 0, 0 >, 100, 50, false )
    trigger_30.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) { // validates is valid player
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){ // validades noclip is off
        int reset = 0
        if (ent in file.cp_table) { // validates if player has a previous cp saved
            if (file.cp_table[ent] != < -2414.793, 3607.928, 17528.61 >) { // validades if saved cp is different from the current one
                file.cp_table[ent] <- < -2414.793, 3607.928, 17528.61 > 

                // display timer
                if(ent.GetPersistentVarAsInt("gen") != reset){
                    ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                    int seconds = ent.GetPersistentVarAsInt( "xp" )
                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)
                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                    } else {
                        int minutes = seconds
                        Message(ent, "Current Time: " + seconds + " seconds" )
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < -2414.793, 3607.928, 17528.61 >

            // display timer
            if(ent.GetPersistentVarAsInt("gen") != reset){
                ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                int seconds = ent.GetPersistentVarAsInt( "xp" )
                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)
                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                } else {
                    int minutes = seconds
                    Message(ent, "Current Time: " + seconds + " seconds" )
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_30 )
    entity trigger_31 = MapEditor_CreateTrigger( < -2286.393, 4860.828, 17531.61 >, < 0, 0, 0 >, 100, 50, false )
    trigger_31.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) { // validates is valid player
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){ // validades noclip is off
        int reset = 0
        if (ent in file.cp_table) { // validates if player has a previous cp saved
            if (file.cp_table[ent] != < -2358.393, 4860.828, 17531.61 >) { // validades if saved cp is different from the current one
                file.cp_table[ent] <- < -2358.393, 4860.828, 17531.61 > 

                // display timer
                if(ent.GetPersistentVarAsInt("gen") != reset){
                    ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                    int seconds = ent.GetPersistentVarAsInt( "xp" )
                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)
                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                    } else {
                        int minutes = seconds
                        Message(ent, "Current Time: " + seconds + " seconds" )
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < -2358.393, 4860.828, 17531.61 >

            // display timer
            if(ent.GetPersistentVarAsInt("gen") != reset){
                ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                int seconds = ent.GetPersistentVarAsInt( "xp" )
                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)
                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                } else {
                    int minutes = seconds
                    Message(ent, "Current Time: " + seconds + " seconds" )
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_31 )
    entity trigger_32 = MapEditor_CreateTrigger( < -1449.993, 4864.928, 17531.61 >, < 0, -90, 0 >, 100, 50, false )
    trigger_32.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) { // validates is valid player
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){ // validades noclip is off
        int reset = 0
        if (ent in file.cp_table) { // validates if player has a previous cp saved
            if (file.cp_table[ent] != < -1519.593, 4936.128, 17531.61 >) { // validades if saved cp is different from the current one
                file.cp_table[ent] <- < -1519.593, 4936.128, 17531.61 > 

                // display timer
                if(ent.GetPersistentVarAsInt("gen") != reset){
                    ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                    int seconds = ent.GetPersistentVarAsInt( "xp" )
                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)
                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                    } else {
                        int minutes = seconds
                        Message(ent, "Current Time: " + seconds + " seconds" )
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < -1519.593, 4936.128, 17531.61 >

            // display timer
            if(ent.GetPersistentVarAsInt("gen") != reset){
                ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                int seconds = ent.GetPersistentVarAsInt( "xp" )
                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)
                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                } else {
                    int minutes = seconds
                    Message(ent, "Current Time: " + seconds + " seconds" )
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_32 )
    entity trigger_33 = MapEditor_CreateTrigger( < -926.0931, 4115.028, 17532.01 >, < 0, 90, 0 >, 100, 50, false )
    trigger_33.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) { // validates is valid player
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){ // validades noclip is off
        int reset = 0
        if (ent in file.cp_table) { // validates if player has a previous cp saved
            if (file.cp_table[ent] != < -926.0931, 4115.028, 17532.01 >) { // validades if saved cp is different from the current one
                file.cp_table[ent] <- < -926.0931, 4115.028, 17532.01 > 

                // display timer
                if(ent.GetPersistentVarAsInt("gen") != reset){
                    ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                    int seconds = ent.GetPersistentVarAsInt( "xp" )
                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)
                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                    } else {
                        int minutes = seconds
                        Message(ent, "Current Time: " + seconds + " seconds" )
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < -926.0931, 4115.028, 17532.01 >

            // display timer
            if(ent.GetPersistentVarAsInt("gen") != reset){
                ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                int seconds = ent.GetPersistentVarAsInt( "xp" )
                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)
                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                } else {
                    int minutes = seconds
                    Message(ent, "Current Time: " + seconds + " seconds" )
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_33 )
    entity trigger_34 = MapEditor_CreateTrigger( < -926.0948, 3791.026, 17786.61 >, < 0, -0.0001, 0 >, 100, 50, false )
    trigger_34.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) { // validates is valid player
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){ // validades noclip is off
        int reset = 0
        if (ent in file.cp_table) { // validates if player has a previous cp saved
            if (file.cp_table[ent] != < -926.0948, 3791.026, 17786.61 >) { // validades if saved cp is different from the current one
                file.cp_table[ent] <- < -926.0948, 3791.026, 17786.61 > 

                // display timer
                if(ent.GetPersistentVarAsInt("gen") != reset){
                    ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                    int seconds = ent.GetPersistentVarAsInt( "xp" )
                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)
                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                    } else {
                        int minutes = seconds
                        Message(ent, "Current Time: " + seconds + " seconds" )
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < -926.0948, 3791.026, 17786.61 >

            // display timer
            if(ent.GetPersistentVarAsInt("gen") != reset){
                ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                int seconds = ent.GetPersistentVarAsInt( "xp" )
                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)
                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                } else {
                    int minutes = seconds
                    Message(ent, "Current Time: " + seconds + " seconds" )
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_34 )
    entity trigger_35 = MapEditor_CreateTrigger( < -9.093, 2358.028, 17991.85 >, < 0, -90, 0 >, 90, 62, false )
    trigger_35.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) { // validates is valid player
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){ // validades noclip is off
        int reset = 0
        if (ent in file.cp_table) { // validates if player has a previous cp saved
            if (file.cp_table[ent] != < -9.093, 2358.028, 17991.85 >) { // validades if saved cp is different from the current one
                file.cp_table[ent] <- < -9.093, 2358.028, 17991.85 > 

                // display timer
                if(ent.GetPersistentVarAsInt("gen") != reset){
                    ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                    int seconds = ent.GetPersistentVarAsInt( "xp" )
                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)
                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                    } else {
                        int minutes = seconds
                        Message(ent, "Current Time: " + seconds + " seconds" )
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < -9.093, 2358.028, 17991.85 >

            // display timer
            if(ent.GetPersistentVarAsInt("gen") != reset){
                ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                int seconds = ent.GetPersistentVarAsInt( "xp" )
                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)
                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                } else {
                    int minutes = seconds
                    Message(ent, "Current Time: " + seconds + " seconds" )
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_35 )
    entity trigger_36 = MapEditor_CreateTrigger( < -926.0933, 3263.328, 18100.05 >, < 0, -90, 0 >, 100, 50, false )
    trigger_36.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) { // validates is valid player
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){ // validades noclip is off
        int reset = 0
        if (ent in file.cp_table) { // validates if player has a previous cp saved
            if (file.cp_table[ent] != < -1001.793, 3338.528, 18100.05 >) { // validades if saved cp is different from the current one
                file.cp_table[ent] <- < -1001.793, 3338.528, 18100.05 > 

                // display timer
                if(ent.GetPersistentVarAsInt("gen") != reset){
                    ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                    int seconds = ent.GetPersistentVarAsInt( "xp" )
                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)
                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                    } else {
                        int minutes = seconds
                        Message(ent, "Current Time: " + seconds + " seconds" )
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < -1001.793, 3338.528, 18100.05 >

            // display timer
            if(ent.GetPersistentVarAsInt("gen") != reset){
                ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                int seconds = ent.GetPersistentVarAsInt( "xp" )
                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)
                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                } else {
                    int minutes = seconds
                    Message(ent, "Current Time: " + seconds + " seconds" )
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_36 )
    entity trigger_37 = MapEditor_CreateTrigger( < 1059.907, 2356.525, 18219.71 >, < 0, 0, 0 >, 100, 50, false )
    trigger_37.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) { // validates is valid player
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){ // validades noclip is off
        int reset = 0
        if (ent in file.cp_table) { // validates if player has a previous cp saved
            if (file.cp_table[ent] != < 1059.907, 2356.525, 18219.71 >) { // validades if saved cp is different from the current one
                file.cp_table[ent] <- < 1059.907, 2356.525, 18219.71 > 

                // display timer
                if(ent.GetPersistentVarAsInt("gen") != reset){
                    ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                    int seconds = ent.GetPersistentVarAsInt( "xp" )
                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)
                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                    } else {
                        int minutes = seconds
                        Message(ent, "Current Time: " + seconds + " seconds" )
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 1059.907, 2356.525, 18219.71 >

            // display timer
            if(ent.GetPersistentVarAsInt("gen") != reset){
                ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                int seconds = ent.GetPersistentVarAsInt( "xp" )
                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)
                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                } else {
                    int minutes = seconds
                    Message(ent, "Current Time: " + seconds + " seconds" )
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_37 )
    entity trigger_38 = MapEditor_CreateTrigger( < 1835.48, 2357.525, 18511.51 >, < 0, 180, 0 >, 100, 50, false )
    trigger_38.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) { // validates is valid player
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){ // validades noclip is off
        int reset = 0
        if (ent in file.cp_table) { // validates if player has a previous cp saved
            if (file.cp_table[ent] != < 1835.48, 2357.525, 18511.51 >) { // validades if saved cp is different from the current one
                file.cp_table[ent] <- < 1835.48, 2357.525, 18511.51 > 

                // display timer
                if(ent.GetPersistentVarAsInt("gen") != reset){
                    ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                    int seconds = ent.GetPersistentVarAsInt( "xp" )
                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)
                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                    } else {
                        int minutes = seconds
                        Message(ent, "Current Time: " + seconds + " seconds" )
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 1835.48, 2357.525, 18511.51 >

            // display timer
            if(ent.GetPersistentVarAsInt("gen") != reset){
                ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                int seconds = ent.GetPersistentVarAsInt( "xp" )
                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)
                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                } else {
                    int minutes = seconds
                    Message(ent, "Current Time: " + seconds + " seconds" )
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_38 )
    entity trigger_39 = MapEditor_CreateTrigger( < 1835.484, 2703.522, 18722.61 >, < 0, 180, 0 >, 100, 50, false )
    trigger_39.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) { // validates is valid player
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){ // validades noclip is off
        int reset = 0
        if (ent in file.cp_table) { // validates if player has a previous cp saved
            if (file.cp_table[ent] != < 1835.484, 2703.522, 18722.61 >) { // validades if saved cp is different from the current one
                file.cp_table[ent] <- < 1835.484, 2703.522, 18722.61 > 

                // display timer
                if(ent.GetPersistentVarAsInt("gen") != reset){
                    ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                    int seconds = ent.GetPersistentVarAsInt( "xp" )
                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)
                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                    } else {
                        int minutes = seconds
                        Message(ent, "Current Time: " + seconds + " seconds" )
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 1835.484, 2703.522, 18722.61 >

            // display timer
            if(ent.GetPersistentVarAsInt("gen") != reset){
                ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                int seconds = ent.GetPersistentVarAsInt( "xp" )
                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)
                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                } else {
                    int minutes = seconds
                    Message(ent, "Current Time: " + seconds + " seconds" )
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_39 )
    entity trigger_40 = MapEditor_CreateTrigger( < 1832.481, 3049.821, 18934.01 >, < 0, 0, 0 >, 100, 50, false )
    trigger_40.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) { // validates is valid player
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){ // validades noclip is off
        int reset = 0
        if (ent in file.cp_table) { // validates if player has a previous cp saved
            if (file.cp_table[ent] != < 1832.481, 3049.821, 18934.01 >) { // validades if saved cp is different from the current one
                file.cp_table[ent] <- < 1832.481, 3049.821, 18934.01 > 

                // display timer
                if(ent.GetPersistentVarAsInt("gen") != reset){
                    ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                    int seconds = ent.GetPersistentVarAsInt( "xp" )
                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)
                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                    } else {
                        int minutes = seconds
                        Message(ent, "Current Time: " + seconds + " seconds" )
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 1832.481, 3049.821, 18934.01 >

            // display timer
            if(ent.GetPersistentVarAsInt("gen") != reset){
                ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                int seconds = ent.GetPersistentVarAsInt( "xp" )
                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)
                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                } else {
                    int minutes = seconds
                    Message(ent, "Current Time: " + seconds + " seconds" )
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_40 )
    entity trigger_41 = MapEditor_CreateTrigger( < 1832.479, 2703.821, 19145.11 >, < 0, 0, 0 >, 100, 50, false )
    trigger_41.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) { // validates is valid player
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){ // validades noclip is off
        int reset = 0
        if (ent in file.cp_table) { // validates if player has a previous cp saved
            if (file.cp_table[ent] != < 1832.479, 2703.821, 19145.11 >) { // validades if saved cp is different from the current one
                file.cp_table[ent] <- < 1832.479, 2703.821, 19145.11 > 

                // display timer
                if(ent.GetPersistentVarAsInt("gen") != reset){
                    ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                    int seconds = ent.GetPersistentVarAsInt( "xp" )
                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)
                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                    } else {
                        int minutes = seconds
                        Message(ent, "Current Time: " + seconds + " seconds" )
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 1832.479, 2703.821, 19145.11 >

            // display timer
            if(ent.GetPersistentVarAsInt("gen") != reset){
                ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                int seconds = ent.GetPersistentVarAsInt( "xp" )
                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)
                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                } else {
                    int minutes = seconds
                    Message(ent, "Current Time: " + seconds + " seconds" )
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_41 )
    entity trigger_42 = MapEditor_CreateTrigger( < 1832.48, 2358.223, 19355.61 >, < 0, 0, 0 >, 100, 50, false )
    trigger_42.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) { // validates is valid player
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){ // validades noclip is off
        int reset = 0
        if (ent in file.cp_table) { // validates if player has a previous cp saved
            if (file.cp_table[ent] != < 1832.48, 2358.223, 19355.61 >) { // validades if saved cp is different from the current one
                file.cp_table[ent] <- < 1832.48, 2358.223, 19355.61 > 

                // display timer
                if(ent.GetPersistentVarAsInt("gen") != reset){
                    ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                    int seconds = ent.GetPersistentVarAsInt( "xp" )
                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)
                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                    } else {
                        int minutes = seconds
                        Message(ent, "Current Time: " + seconds + " seconds" )
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 1832.48, 2358.223, 19355.61 >

            // display timer
            if(ent.GetPersistentVarAsInt("gen") != reset){
                ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                int seconds = ent.GetPersistentVarAsInt( "xp" )
                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)
                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                } else {
                    int minutes = seconds
                    Message(ent, "Current Time: " + seconds + " seconds" )
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_42 )
    entity trigger_43 = MapEditor_CreateTrigger( < 1837.905, 2042.028, 19580.3 >, < 0, 89.9999, 0 >, 100, 50, false )
    trigger_43.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) { // validates is valid player
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){ // validades noclip is off
        int reset = 0
        if (ent in file.cp_table) { // validates if player has a previous cp saved
            if (file.cp_table[ent] != < 1837.905, 2042.028, 19580.3 >) { // validades if saved cp is different from the current one
                file.cp_table[ent] <- < 1837.905, 2042.028, 19580.3 > 

                // display timer
                if(ent.GetPersistentVarAsInt("gen") != reset){
                    ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                    int seconds = ent.GetPersistentVarAsInt( "xp" )
                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)
                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                    } else {
                        int minutes = seconds
                        Message(ent, "Current Time: " + seconds + " seconds" )
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 1837.905, 2042.028, 19580.3 >

            // display timer
            if(ent.GetPersistentVarAsInt("gen") != reset){
                ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                int seconds = ent.GetPersistentVarAsInt( "xp" )
                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)
                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                } else {
                    int minutes = seconds
                    Message(ent, "Current Time: " + seconds + " seconds" )
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_43 )
    entity trigger_44 = MapEditor_CreateTrigger( < 1837.905, 960.0281, 19705.91 >, < 0, -90.0001, 0 >, 100, 50, false )
    trigger_44.SetEnterCallback( void function(entity trigger , entity ent)
    {
    if (IsValid(ent)) { // validates is valid player
    if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP){ // validades noclip is off
        int reset = 0
        if (ent in file.cp_table) { // validates if player has a previous cp saved
            if (file.cp_table[ent] != < 1837.905, 645.0281, 19705.91 >) { // validades if saved cp is different from the current one
                file.cp_table[ent] <- < 1837.905, 645.0281, 19705.91 >
                thread destroy_lootbins() 

                // display timer
                if(ent.GetPersistentVarAsInt("gen") != reset){
                    ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                    int seconds = ent.GetPersistentVarAsInt( "xp" )
                    if (seconds > 59) {
                        int minutes = seconds / 60
                        int realseconds = seconds - (minutes * 60)
                        Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                    } else {
                        int minutes = seconds
                        Message(ent, "Current Time: " + seconds + " seconds" )
                    }
                }
            }
        } else {
            file.cp_table[ent] <- < 1837.905, 645.0281, 19705.91 >

            // display timer
            if(ent.GetPersistentVarAsInt("gen") != reset){
                ent.SetPersistentVar( "xp", Time() - ent.GetPersistentVarAsInt( "gen" ) )
                int seconds = ent.GetPersistentVarAsInt( "xp" )
                if (seconds > 59) {
                    int minutes = seconds / 60
                    int realseconds = seconds - (minutes * 60)
                    Message(ent, "Current Time: " + minutes + " minutes " + realseconds + " seconds " )
                } else {
                    int minutes = seconds
                    Message(ent, "Current Time: " + seconds + " seconds" )
                }
            }
        }
    }
}
    })
    DispatchSpawn( trigger_44 )
    entity trigger_45 = MapEditor_CreateTrigger( < 587.7756, 1931.578, 14703.11 >, < 0, 0, 0 >, 2500, 50, false )
    trigger_45.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
	ResetDoors()
            if (ent in file.cp_table) {
                ent.SetOrigin(file.cp_table[ent])
            } else {
                ent.SetOrigin(file.first_cp)
            }
        }
    }
    })
    DispatchSpawn( trigger_45 )
    entity trigger_46 = MapEditor_CreateTrigger( < 2607.776, 2310.578, 15298.11 >, < 0, 0, 0 >, 1000, 50, false )
    trigger_46.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
	ResetDoors()
            if (ent in file.cp_table) {
                ent.SetOrigin(file.cp_table[ent])
            } else {
                ent.SetOrigin(file.first_cp)
            }
        }
    }
    })
    DispatchSpawn( trigger_46 )
    entity trigger_47 = MapEditor_CreateTrigger( < 2321.177, 395.7831, 15680.11 >, < 0, 0, 0 >, 1000, 50, false )
    trigger_47.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
	ResetDoors()
            if (ent in file.cp_table) {
                ent.SetOrigin(file.cp_table[ent])
            } else {
                ent.SetOrigin(file.first_cp)
            }
        }
    }
    })
    DispatchSpawn( trigger_47 )
    entity trigger_48 = MapEditor_CreateTrigger( < 2321.177, -1200.217, 15680.11 >, < 0, 0, 0 >, 1000, 50, false )
    trigger_48.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
	ResetDoors()
            if (ent in file.cp_table) {
                ent.SetOrigin(file.cp_table[ent])
            } else {
                ent.SetOrigin(file.first_cp)
            }
        }
    }
    })
    DispatchSpawn( trigger_48 )
    entity trigger_49 = MapEditor_CreateTrigger( < 728.177, -1200.217, 15745.11 >, < 0, 0, 0 >, 1000, 50, false )
    trigger_49.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
	ResetDoors()
            if (ent in file.cp_table) {
                ent.SetOrigin(file.cp_table[ent])
            } else {
                ent.SetOrigin(file.first_cp)
            }
        }
    }
    })
    DispatchSpawn( trigger_49 )
    entity trigger_50 = MapEditor_CreateTrigger( < -1584.823, -1200.217, 15554.11 >, < 0, 0, 0 >, 1500, 50, false )
    trigger_50.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
	ResetDoors()
            if (ent in file.cp_table) {
                ent.SetOrigin(file.cp_table[ent])
            } else {
                ent.SetOrigin(file.first_cp)
            }
        }
    }
    })
    DispatchSpawn( trigger_50 )
    entity trigger_51 = MapEditor_CreateTrigger( < -3212.823, -1200.217, 16192.11 >, < 0, 0, 0 >, 1000, 50, false )
    trigger_51.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
	ResetDoors()
            if (ent in file.cp_table) {
                ent.SetOrigin(file.cp_table[ent])
            } else {
                ent.SetOrigin(file.first_cp)
            }
        }
    }
    })
    DispatchSpawn( trigger_51 )
    entity trigger_52 = MapEditor_CreateTrigger( < -2775.823, 294.1832, 16803.11 >, < 0, 0, 0 >, 1000, 50, false )
    trigger_52.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
	ResetDoors()
            if (ent in file.cp_table) {
                ent.SetOrigin(file.cp_table[ent])
            } else {
                ent.SetOrigin(file.first_cp)
            }
        }
    }
    })
    DispatchSpawn( trigger_52 )
    entity trigger_53 = MapEditor_CreateTrigger( < -2775.823, 2036.183, 17036.11 >, < 0, 0, 0 >, 1000, 50, false )
    trigger_53.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
	ResetDoors()
            if (ent in file.cp_table) {
                ent.SetOrigin(file.cp_table[ent])
            } else {
                ent.SetOrigin(file.first_cp)
            }
        }
    }
    })
    DispatchSpawn( trigger_53 )
    entity trigger_54 = MapEditor_CreateTrigger( < -848.2244, 3967.978, 17181.11 >, < 0, 0, 0 >, 1250, 50, false )
    trigger_54.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
	ResetDoors()
            if (ent in file.cp_table) {
                ent.SetOrigin(file.cp_table[ent])
            } else {
                ent.SetOrigin(file.first_cp)
            }
        }
    }
    })
    DispatchSpawn( trigger_54 )
    entity trigger_55 = MapEditor_CreateTrigger( < -299.3245, 2220.028, 17614.11 >, < 0, 0, 0 >, 1750, 50, false )
    trigger_55.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
	ResetDoors()
            if (ent in file.cp_table) {
                ent.SetOrigin(file.cp_table[ent])
            } else {
                ent.SetOrigin(file.first_cp)
            }
        }
    }
    })
    DispatchSpawn( trigger_55 )
    entity trigger_56 = MapEditor_CreateTrigger( < 1937.674, 2220.028, 18020.11 >, < 0, 0, 0 >, 1000, 50, false )
    trigger_56.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
	ResetDoors()
            if (ent in file.cp_table) {
                ent.SetOrigin(file.cp_table[ent])
            } else {
                ent.SetOrigin(file.first_cp)
            }
        }
    }
    })
    DispatchSpawn( trigger_56 )
    entity trigger_57 = MapEditor_CreateTrigger( < 1937.674, 3634.578, 18369.11 >, < 0, 0, 0 >, 1000, 50, false )
    trigger_57.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
	ResetDoors()
            if (ent in file.cp_table) {
                ent.SetOrigin(file.cp_table[ent])
            } else {
                ent.SetOrigin(file.first_cp)
            }
        }
    }
    })
    DispatchSpawn( trigger_57 )
    entity trigger_58 = MapEditor_CreateTrigger( < 1937.674, 1807.578, 18992.11 >, < 0, 0, 0 >, 1000, 50, false )
    trigger_58.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
	ResetDoors()
            if (ent in file.cp_table) {
                ent.SetOrigin(file.cp_table[ent])
            } else {
                ent.SetOrigin(file.first_cp)
            }
        }
    }
    })
    DispatchSpawn( trigger_58 )
    entity trigger_59 = MapEditor_CreateTrigger( < 1937.674, 425.5778, 19494.11 >, < 0, 0, 0 >, 1000, 50, false )
    trigger_59.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
	ResetDoors()
	destroy_lootbins() 
            if (ent in file.cp_table) {
                ent.SetOrigin(file.cp_table[ent])
            } else {
                ent.SetOrigin(file.first_cp)
            }
        }
    }
    })
    DispatchSpawn( trigger_59 )
    entity trigger_60 = MapEditor_CreateTrigger( < -2307.823, 3338.783, 17167.11 >, < 0, 0, 0 >, 1000, 50, false )
    trigger_60.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
	ResetDoors()
            if (ent in file.cp_table) {
                ent.SetOrigin(file.cp_table[ent])
            } else {
                ent.SetOrigin(file.first_cp)
            }
        }
    }
    })
    DispatchSpawn( trigger_60 )
    entity trigger_61 = MapEditor_CreateTrigger( < -2110.224, 5155.978, 17181.11 >, < 0, 0, 0 >, 1250, 50, false )
    trigger_61.SetEnterCallback( void function(entity trigger , entity ent)
    {
        if (IsValid(ent)) // ensure the entity is valid
    {
        if (ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // Noclip players are not affected by the trigger
        {
	ResetDoors()
            if (ent in file.cp_table) {
                ent.SetOrigin(file.cp_table[ent])
            } else {
                ent.SetOrigin(file.first_cp)
            }
        }
    }
    })
    DispatchSpawn( trigger_61 )



    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_double_doorframe_01.rmdl", < -1, 377.4, 14914.7 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_double_doorframe_02.rmdl", < -1, 377.4, 14914.7 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/door/canyonlands_door_single_02_hinges.rmdl", < 64, 372.4, 14966.7 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/door/canyonlands_door_single_02_hinges.rmdl", < -63, 372.4, 14966.7 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_double_doorframe_01.rmdl", < 0.6225, 1314.549, 14913.77 >, < 0, 179.6289, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_double_doorframe_02.rmdl", < 0.6225, 1314.549, 14913.77 >, < 0, 179.6289, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/door/canyonlands_door_single_02_hinges.rmdl", < 65.5888, 1309.128, 14965.77 >, < 0, 89.6289, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/door/canyonlands_door_single_02_hinges.rmdl", < -61.4086, 1309.951, 14965.77 >, < 0, -90.3712, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_double_doorframe_01.rmdl", < 819.5901, 1462.2, 14915.07 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_double_doorframe_02.rmdl", < 819.5901, 1462.2, 14915.07 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/door/canyonlands_door_single_02_hinges.rmdl", < 824.5901, 1527.2, 14967.07 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/door/canyonlands_door_single_02_hinges.rmdl", < 824.5901, 1400.2, 14967.07 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_double_doorframe_01.rmdl", < 336.0098, 1462.4, 14915.07 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_double_doorframe_02.rmdl", < 336.0098, 1462.4, 14915.07 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/door/canyonlands_door_single_02_hinges.rmdl", < 331.0098, 1397.4, 14967.07 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/door/canyonlands_door_single_02_hinges.rmdl", < 331.0098, 1524.4, 14967.07 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_double_doorframe_01.rmdl", < 1045, 1792.6, 14915.9 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_double_doorframe_02.rmdl", < 1045, 1792.6, 14915.9 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/door/canyonlands_door_single_02_hinges.rmdl", < 1110, 1787.6, 14967.9 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/door/canyonlands_door_single_02_hinges.rmdl", < 983.0001, 1787.6, 14967.9 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_double_doorframe_01.rmdl", < 1158.94, 2158.266, 14915.9 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_double_doorframe_02.rmdl", < 1158.94, 2158.266, 14915.9 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/door/canyonlands_door_single_02_hinges.rmdl", < 1163.94, 2223.266, 14967.9 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/door/canyonlands_door_single_02_hinges.rmdl", < 1163.94, 2096.266, 14967.9 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_double_doorframe_01.rmdl", < 663.2442, 2157.57, 15045.27 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_double_doorframe_02.rmdl", < 663.2442, 2157.57, 15045.27 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/door/canyonlands_door_single_02_hinges.rmdl", < 668.2442, 2222.57, 15097.27 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/door/canyonlands_door_single_02_hinges.rmdl", < 668.2442, 2095.57, 15097.27 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_double_doorframe_01.rmdl", < 1164.664, 2154.73, 15175.67 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_double_doorframe_02.rmdl", < 1164.664, 2154.73, 15175.67 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/door/canyonlands_door_single_02_hinges.rmdl", < 1159.664, 2089.73, 15227.67 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/door/canyonlands_door_single_02_hinges.rmdl", < 1159.664, 2216.73, 15227.67 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_double_doorframe_01.rmdl", < 662.71, 2201.588, 15322.07 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_double_doorframe_02.rmdl", < 662.71, 2201.588, 15322.07 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/door/canyonlands_door_single_02_hinges.rmdl", < 667.71, 2266.588, 15374.07 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/door/canyonlands_door_single_02_hinges.rmdl", < 667.71, 2139.588, 15374.07 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_double_doorframe_01.rmdl", < 1155.79, 2312.488, 15322.07 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_double_doorframe_02.rmdl", < 1155.79, 2312.488, 15322.07 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/door/canyonlands_door_single_02_hinges.rmdl", < 1160.79, 2377.488, 15374.07 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/door/canyonlands_door_single_02_hinges.rmdl", < 1160.79, 2250.488, 15374.07 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_double_doorframe_01.rmdl", < 672.21, 2446.6, 15465.97 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_double_doorframe_02.rmdl", < 672.21, 2446.6, 15465.97 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/door/canyonlands_door_single_02_hinges.rmdl", < 667.21, 2381.6, 15517.97 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/door/canyonlands_door_single_02_hinges.rmdl", < 667.21, 2508.6, 15517.97 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_double_doorframe_01.rmdl", < 1417.9, 2502, 15466.1 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_double_doorframe_02.rmdl", < 1417.9, 2502, 15466.1 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/door/canyonlands_door_single_02_hinges.rmdl", < 1412.9, 2437, 15518.1 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/door/canyonlands_door_single_02_hinges.rmdl", < 1412.9, 2564, 15518.1 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_double_doorframe_01.rmdl", < 2326.6, 2501.6, 15466.1 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_double_doorframe_02.rmdl", < 2326.6, 2501.6, 15466.1 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/door/canyonlands_door_single_02_hinges.rmdl", < 2321.6, 2436.6, 15518.1 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/door/canyonlands_door_single_02_hinges.rmdl", < 2321.6, 2563.6, 15518.1 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_double_doorframe_01.rmdl", < 2561.4, 1748.71, 15576.07 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_double_doorframe_02.rmdl", < 2561.4, 1748.71, 15576.07 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/door/canyonlands_door_single_02_hinges.rmdl", < 2496.4, 1753.71, 15628.07 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/door/canyonlands_door_single_02_hinges.rmdl", < 2623.4, 1753.71, 15628.07 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_double_doorframe_01.rmdl", < 2451.5, 2241.79, 15576.07 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_double_doorframe_02.rmdl", < 2451.5, 2241.79, 15576.07 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/door/canyonlands_door_single_02_hinges.rmdl", < 2386.5, 2246.79, 15628.07 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/door/canyonlands_door_single_02_hinges.rmdl", < 2513.5, 2246.79, 15628.07 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_double_doorframe_01.rmdl", < 2325.8, 2250.39, 15722.17 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_double_doorframe_02.rmdl", < 2325.8, 2250.39, 15722.17 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/door/canyonlands_door_single_02_hinges.rmdl", < 2390.8, 2245.39, 15774.17 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/door/canyonlands_door_single_02_hinges.rmdl", < 2263.8, 2245.39, 15774.17 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_double_doorframe_01.rmdl", < 2435.7, 1757.31, 15722.17 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_double_doorframe_02.rmdl", < 2435.7, 1757.31, 15722.17 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/door/canyonlands_door_single_02_hinges.rmdl", < 2500.7, 1752.31, 15774.17 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/door/canyonlands_door_single_02_hinges.rmdl", < 2373.7, 1752.31, 15774.17 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_double_doorframe_01.rmdl", < 2561.4, 1748.71, 15864.07 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_double_doorframe_02.rmdl", < 2561.4, 1748.71, 15864.07 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/door/canyonlands_door_single_02_hinges.rmdl", < 2496.4, 1753.71, 15916.07 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/door/canyonlands_door_single_02_hinges.rmdl", < 2623.4, 1753.71, 15916.07 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_double_doorframe_01.rmdl", < 2451.5, 2241.79, 15864.07 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_double_doorframe_02.rmdl", < 2451.5, 2241.79, 15864.07 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/door/canyonlands_door_single_02_hinges.rmdl", < 2386.5, 2246.79, 15916.07 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/door/canyonlands_door_single_02_hinges.rmdl", < 2513.5, 2246.79, 15916.07 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_doorframe_02.rmdl", < 2508.5, 797.6993, 15865.99 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_doorframe.rmdl", < 2508.5, 797.6993, 15865.99 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/door/canyonlands_door_single_02_hinges.rmdl", < 2475.07, 792.6993, 15917.99 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_doorframe_02.rmdl", < 2511.8, 120.5958, 15864.24 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_doorframe.rmdl", < 2511.8, 120.5958, 15864.24 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/door/canyonlands_door_single_02_hinges.rmdl", < 2478.37, 115.5958, 15916.24 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_doorframe_02.rmdl", < 2511.399, -515.8008, 15864.24 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_doorframe.rmdl", < 2511.399, -515.8008, 15864.24 >, < 0, 180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/door/canyonlands_door_single_02_hinges.rmdl", < 2477.969, -520.8008, 15916.24 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_doorframe_02.rmdl", < 3001.6, -920.7967, 15860.14 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_doorframe.rmdl", < 3001.6, -920.7967, 15860.14 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/door/canyonlands_door_single_02_hinges.rmdl", < 2968.17, -925.7967, 15912.14 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_doorframe_02.rmdl", < 2884.3, -722.7003, 15860.13 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_doorframe.rmdl", < 2884.3, -722.7003, 15860.13 >, < 0, 90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/door/canyonlands_door_single_02_hinges.rmdl", < 2879.3, -689.2702, 15912.13 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_doorframe_02.rmdl", < 2696.616, -1147.468, 15867.27 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_doorframe.rmdl", < 2696.616, -1147.468, 15867.27 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/door/canyonlands_door_single_02_hinges.rmdl", < 2701.616, -1180.898, 15919.27 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_doorframe_02.rmdl", < 2584.716, -1347.768, 15867.44 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_doorframe.rmdl", < 2584.716, -1347.768, 15867.44 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/door/canyonlands_door_single_02_hinges.rmdl", < 2551.286, -1352.768, 15919.44 >, < 0, -90, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_doorframe_02.rmdl", < 2584.715, -1347.772, 16006.64 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/desertlands/desertlands_lobby_doorframe.rmdl", < 2584.715, -1347.772, 16006.64 >, < 0, -180, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/door/canyonlands_door_single_02_hinges.rmdl", < 2551.285, -1352.772, 16058.64 >, < 0, -90, 0 >, true, 50000, -1, 1 )

}

void
function destroy_lootbins() {

	foreach(lootbin in file.lootbins)
		{
			lootbin.Destroy()
		}
	file.lootbins.clear()

	thread lootbins()
}

void function ResetDoors()
{
    foreach ( door in file.door_list )
    {
        if ( IsValid( door ) )
        {
            door.Destroy()
        }
    }

    file.door_list.clear()

    doors()
}
