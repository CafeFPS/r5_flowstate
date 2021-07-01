global function ClDroneCrypto_Init


void function ClDroneCrypto_Init()
{
	ModelFX_BeginData( "thrusters_friend", $"mdl/props/crypto_drone/crypto_drone.rmdl", "friend", false )

		//
		//
		//
			ModelFX_AddTagSpawnFX( "handle_t_fx", $"P_drone_exhaust_T" )
			ModelFX_AddTagSpawnFX( "frame_b_fx", $"P_drone_exhaust_B" )
			ModelFX_AddTagSpawnFX( "arm_l_fx", $"P_drone_exhaust_L" )
			ModelFX_AddTagSpawnFX( "arm_r_fx", $"P_drone_exhaust_R" )
			ModelFX_AddTagSpawnFX( "__illumPosition", $"P_crypto_drone_shield" )
			ModelFX_AddTagSpawnFX( "LENS", $"P_drone_camera" )
	ModelFX_EndData()

	ModelFX_BeginData( "thrusters_foe", $"mdl/props/crypto_drone/crypto_drone.rmdl", "foe", false )

		//
		//
		//
			ModelFX_AddTagSpawnFX( "handle_t_fx", $"P_drone_exhaust_enemy_T" )
			ModelFX_AddTagSpawnFX( "frame_b_fx", $"P_drone_exhaust_enemy_B" )
			ModelFX_AddTagSpawnFX( "arm_l_fx", $"P_drone_exhaust_enemy_L" )
			ModelFX_AddTagSpawnFX( "arm_r_fx", $"P_drone_exhaust_enemy_R" )
			ModelFX_AddTagSpawnFX( "__illumPosition", $"P_crypto_drone_shield_enemy" )
			ModelFX_AddTagSpawnFX( "LENS", $"P_drone_camera_enemy" )
	ModelFX_EndData()

}
