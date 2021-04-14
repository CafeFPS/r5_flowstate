global function ClDraconisFlyin_Init


void function ClDraconisFlyin_Init()
{
	ModelFX_BeginData( "thrusters", $"mdl/vehicles_r2/spacecraft/draconis/draconis_flying_small.rmdl", "all", true )


		//----------------------
		// Thrusters
		//----------------------
			ModelFX_AddTagSpawnFX( "engine_front_left", $"P_veh_draconis_flyin_jet" )
			ModelFX_AddTagSpawnFX( "engine_front_right", $"P_veh_draconis_flyin_jet" )
			ModelFX_AddTagSpawnFX( "engine_rear_left", $"P_veh_draconis_flyin_jet" )
			ModelFX_AddTagSpawnFX( "engine_rear_right", $"P_veh_draconis_flyin_jet" )


	ModelFX_EndData()


	ModelFX_BeginData( "wind", $"mdl/vehicles_r2/spacecraft/draconis/draconis_flying_small.rmdl", "all", true )

		//----------------------
		// Clouds
		//----------------------
			ModelFX_AddTagSpawnFX( "ship_bottom", $"P_veh_draconis_flyin_wind" )

	ModelFX_EndData()

}



