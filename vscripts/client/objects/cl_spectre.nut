global function ClSpectre_Init

struct
{
	table<asset,bool> initialized
} file

void function ClSpectre_Init()
{
	AddCreateCallback( "npc_spectre", CreateCallback_Spectre )

	RegisterSignal( "SpectreGlowEYEGLOW" )

	PrecacheParticleSystem( $"P_spectre_eye_foe" )
	PrecacheParticleSystem( $"P_spectre_eye_friend" )
}

void function CreateCallback_Spectre( entity spectre )
{
	AddAnimEvent( spectre, "create_dataknife", CreateThirdPersonDataKnife )
	spectre.DoBodyGroupChangeScriptCallback( true, spectre.FindBodygroup( "removableHead" ) )

	asset model = spectre.GetModelName()
	if ( model in file.initialized )
		return
	file.initialized[ model ] <- true

	//----------------------
	// model Lights - Friend
	//----------------------
	ModelFX_BeginData( "friend_lights", model, "friend", true )
		ModelFX_HideFromLocalPlayer()
		ModelFX_AddTagSpawnFX( "EYEGLOW",		$"P_spectre_eye_friend" )
	ModelFX_EndData()

	//----------------------
	// model Lights - Foe
	//----------------------
	ModelFX_BeginData( "foe_lights", model, "foe", true )
		ModelFX_HideFromLocalPlayer()
		//ModelFX_AddTagSpawnFX( "EYEGLOW",		$"P_spectre_eye_foe" )
		ModelFX_AddTagSpawnFX( "EYEGLOW",		$"P_spectre_eye_friend" )
	ModelFX_EndData()
}

