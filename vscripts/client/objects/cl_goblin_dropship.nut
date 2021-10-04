global function ClGoblinDropship_ModelFX_Init


void function ClGoblinDropship_ModelFX_Init()
{
	ModelFX_BeginData( "friend_lights", $"mdl/vehicle/goblin_dropship/goblin_dropship.rmdl", "friend", true )
		//----------------------
		// ACL Lights - Friend
		//----------------------
		ModelFX_AddTagSpawnFX( "light_Red0",		$"acl_light_blue" )
		ModelFX_AddTagSpawnFX( "light_Green0",		$"acl_light_blue" )
	ModelFX_EndData()

	ModelFX_BeginData( "foe_lights", $"mdl/vehicle/goblin_dropship/goblin_dropship.rmdl", "foe", true )
		//----------------------
		// ACL Lights - Foe
		//----------------------
		ModelFX_AddTagSpawnFX( "light_Red0",		$"acl_light_red" )
		ModelFX_AddTagSpawnFX( "light_Green0",		$"acl_light_red" )
	ModelFX_EndData()

	ModelFX_BeginData( "thrusters", $"mdl/vehicle/goblin_dropship/goblin_dropship.rmdl", "all", true )
		//----------------------
		// Thrusters
		//----------------------
		ModelFX_AddTagSpawnFX( "L_exhaust_rear_1", $"P_veh_dropship_jet_full" )
		ModelFX_AddTagSpawnFX( "L_exhaust_rear_2", $"P_veh_dropship_jet_full" )
		ModelFX_AddTagSpawnFX( "L_exhaust_front_1", $"P_veh_dropship_jet_full" )

		ModelFX_AddTagSpawnFX( "R_exhaust_rear_1", $"P_veh_dropship_jet_full" )
		ModelFX_AddTagSpawnFX( "R_exhaust_rear_2", $"P_veh_dropship_jet_full" )
		ModelFX_AddTagSpawnFX( "R_exhaust_front_1", $"P_veh_dropship_jet_full" )
	ModelFX_EndData()

	ModelFX_BeginData( "dropshipDamage", $"mdl/vehicle/goblin_dropship/goblin_dropship.rmdl", "all", true )
		//----------------------
		// Health effects
		//----------------------
		ModelFX_AddTagHealthFX( 0.80, "L_exhaust_rear_1", $"xo_health_smoke_white", false )
		ModelFX_AddTagHealthFX( 0.60, "R_exhaust_rear_2", $"xo_health_smoke_white", false )
		ModelFX_AddTagHealthFX( 0.40, "L_exhaust_rear_1", $"xo_health_smoke_black", false )
		ModelFX_AddTagHealthFX( 0.20, "R_exhaust_rear_2", $"xo_health_smoke_black", false )
	ModelFX_EndData()

	//STATIC FLYING VERSION
	ModelFX_BeginData( "thrusters", $"mdl/vehicle/goblin_dropship/goblin_dropship_flying_static.rmdl", "all", true )
		//----------------------
		// Thrusters
		//----------------------
		ModelFX_AddTagSpawnFX( "L_exhaust_rear_1", $"P_veh_dropship_jet_full" )
		ModelFX_AddTagSpawnFX( "L_exhaust_rear_2", $"P_veh_dropship_jet_full" )

		ModelFX_AddTagSpawnFX( "R_exhaust_rear_1", $"P_veh_dropship_jet_full" )
		ModelFX_AddTagSpawnFX( "R_exhaust_rear_2", $"P_veh_dropship_jet_full" )
	ModelFX_EndData()
}
