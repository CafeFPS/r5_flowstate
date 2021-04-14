global function ClSuperSpectre_Init

struct
{
	bool initialized
} file

void function ClSuperSpectre_Init()
{
	AddCreateCallback( "npc_super_spectre", CreateCallback_SuperSpectre )
}


void function CreateCallback_SuperSpectre( entity super_spectre )
{
	AddAnimEvent( super_spectre, "create_dataknife", CreateThirdPersonDataKnife ) //Will use when we enable hacking

	if ( file.initialized )
		return
	file.initialized = true

	asset super_spectre_model = super_spectre.GetModelName()

	//----------------------
	// ACL Lights - Friend
	//----------------------
	ModelFX_BeginData( "friend_lights", super_spectre_model, "friend", true )
		ModelFX_AddTagSpawnFX( "FX_R_EYE",		$"P_spectre_eye_friend" )
		ModelFX_AddTagSpawnFX( "FX_L_EYE",		$"P_spectre_eye_friend" )
	ModelFX_EndData()

	//----------------------
	// ACL Lights - Foe
	//----------------------
	ModelFX_BeginData( "foe_lights", super_spectre_model, "foe", true )
		ModelFX_AddTagSpawnFX( "FX_R_EYE",		$"P_spectre_eye_foe" )
		ModelFX_AddTagSpawnFX( "FX_L_EYE",		$"P_spectre_eye_foe" )
	ModelFX_EndData()



	ModelFX_BeginData( "SuperSpectreDamage", super_spectre_model, "all", true )
		//----------------------
		// Health effects
		//----------------------

		ModelFX_AddTagHealthFX( 0.66, "FX_DAM_VENT_FR", $"P_sup_spec_dam_vent_1", false )
		ModelFX_AddTagHealthFX( 0.66, "FX_DAM_VENT_FL", $"P_sup_spec_dam_vent_1", false )
		ModelFX_AddTagHealthFX( 0.66, "FX_DAM_VENT_RR", $"P_sup_spec_dam_vent_1", false )
		ModelFX_AddTagHealthFX( 0.66, "FX_DAM_VENT_RL", $"P_sup_spec_dam_vent_1", false )
		ModelFX_AddTagHealthFX( 0.33, "FX_DAM_VENT_FR", $"P_sup_spec_dam_vent_2", false )
		ModelFX_AddTagHealthFX( 0.33, "FX_DAM_VENT_FL", $"P_sup_spec_dam_vent_2", false )
		ModelFX_AddTagHealthFX( 0.33, "FX_DAM_VENT_RR", $"P_sup_spec_dam_vent_2", false )
		ModelFX_AddTagHealthFX( 0.33, "FX_DAM_VENT_RL", $"P_sup_spec_dam_vent_2", false )


		ModelFX_AddTagHealthFX( 0.66, "CHESTFOCUS", $"P_sup_spectre_dam_1", false )
		ModelFX_AddTagHealthFX( 0.33, "CHESTFOCUS", $"P_sup_spectre_dam_2", false )
	ModelFX_EndData()
}

void function OnSuperSpectreDeathExplosion( entity npc )
{
	ModelFX_DisableGroup( npc, "friend_lights" )
	ModelFX_DisableGroup( npc, "foe_lights" )
	ModelFX_DisableGroup( npc, "SuperSpectreDamage" )
}