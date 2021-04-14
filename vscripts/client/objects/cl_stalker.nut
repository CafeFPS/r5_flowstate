global function ClStalker_Init

struct
{
	bool fxInitialized
	float nextStalkerWarningTime
} file

const asset STALKER_GIB_LEG_L = $"mdl/robots/stalker/robot_stalker_l_leg_red_gib.rmdl"
const asset STALKER_GIB_LEG_R = $"mdl/robots/stalker/robot_stalker_r_leg_red_gib.rmdl"
const asset STALKER_GIB_ARM_L = $"mdl/robots/stalker/robot_stalker_l_arm_red_gib.rmdl"
const asset STALKER_GIB_ARM_R = $"mdl/robots/stalker/robot_stalker_r_arm_red_gib.rmdl"

void function ClStalker_Init()
{
	AddCreateCallback( "npc_stalker", CreateCallback_Stalker )
	PrecacheModel( STALKER_GIB_ARM_R )
	PrecacheModel( STALKER_GIB_ARM_L )
	PrecacheParticleSystem( $"P_sparks_dir_MD_LOOP" )
	PrecacheParticleSystem( $"P_spectre_dmg_elec" )
	PrecacheParticleSystem( $"P_spectre_dmg_fire" )
	PrecacheParticleSystem( $"P_spectre_dmg_smk" )
	PrecacheParticleSystem( $"P_stalker_eye_foe" )
	PrecacheParticleSystem( $"P_stalker_eye_friend" )

	AddCreateCallback( "npc_stalker", OnNPCStalkerCreated )
	AddCreateTitanCockpitCallback( OnTitanCockpitCreated_AddStalkers )
	AddLocalPlayerTookDamageTypeCallback( eDamageSourceId.damagedef_stalker_powersupply_explosion_large_at, StalkerWarningMessage )
}

void function CreateCallback_Stalker( entity npc )
{
	npc.DoBodyGroupChangeScriptCallback( true, npc.FindBodygroup( "removableHead" ) )
	if ( file.fxInitialized )
		return

	file.fxInitialized = true

	asset model = npc.GetModelName()
	//------------------------------
	//DAMAGE FX - REGULAR STALKERS
	//------------------------------
	ModelFX_BeginData( "stalkerHealth", model, "all", true )
		//ModelFX_AddTagHealthFX( 0.75, "chest", $"P_spectre_dmg_smk", false )
		ModelFX_AddTagHealthFX( 0.5, "chest", $"P_spectre_dmg_elec", false )
		//ModelFX_AddTagHealthFX( 0.25, "chest", $"P_spectre_dmg_fire", false )
	ModelFX_EndData()

	const float MIN_VELO = 150
	const float MAX_VELO = 250

	ModelFX_BeginData( "damagefx", model, "all", true )
	  	ModelFX_AddTagBreakGib( 1, "left_leg", STALKER_GIB_LEG_L, GIBTYPE_NORMAL, MIN_VELO, MAX_VELO )
			ModelFX_AddTagBreakFX( 1, "FX_L_LEG", $"P_sparks_dir_MD_LOOP", "" )

	  	ModelFX_AddTagBreakGib( 1, "right_leg", STALKER_GIB_LEG_R, GIBTYPE_NORMAL, MIN_VELO, MAX_VELO )
			ModelFX_AddTagBreakFX( 1, "FX_R_LEG", $"P_sparks_dir_MD_LOOP", "" )

	  	ModelFX_AddTagBreakGib( 1, "left_arm", STALKER_GIB_ARM_L, GIBTYPE_NORMAL, MIN_VELO, MAX_VELO )
			ModelFX_AddTagBreakFX( 1, "FX_L_ARM", $"P_sparks_dir_MD_LOOP", "" )

	  	ModelFX_AddTagBreakGib( 1, "right_arm", STALKER_GIB_ARM_R, GIBTYPE_NORMAL, MIN_VELO, MAX_VELO )
			ModelFX_AddTagBreakFX( 1, "FX_R_ARM", $"P_sparks_dir_MD_LOOP", "" )
	ModelFX_EndData()


	//----------------------
	// Light FX - REGULAR STALKERS
	//----------------------
	ModelFX_BeginData( "friend_lights", model, "friend", true )
		ModelFX_HideFromLocalPlayer()
		ModelFX_AddTagSpawnFX( "FX_C_EYE",		$"P_stalker_eye_friend" )
	ModelFX_EndData()

	ModelFX_BeginData( "foe_lights", model, "foe", true )
		ModelFX_HideFromLocalPlayer()
		ModelFX_AddTagSpawnFX( "FX_C_EYE",		$"P_stalker_eye_foe" )
	ModelFX_EndData()
}

void function OnNPCStalkerCreated( entity stalker )
{
	entity player = GetLocalViewPlayer()

	if ( IsFriendlyTeam( stalker.GetTeam(), player.GetTeam() ) )
		return

	if ( IsAlive( stalker ) )
		thread GrenadeArrowThink( player, stalker, 500, 0, true, "titan" )
}

void function StalkerWarningMessage( float damage, vector damageOrigin, int damageType, int damageSourceId, entity attacker )
{
	if ( !GetLocalViewPlayer().IsTitan() )
		return

	if ( Time() > file.nextStalkerWarningTime )
	{
		file.nextStalkerWarningTime = Time() +  5.0
		AddPlayerHint( 3.5, 0.5, $"", "#HINT_STALKER_EXPLODE" )
	}
}

void function OnTitanCockpitCreated_AddStalkers( entity cockpit, entity player )
{
	array<entity> stalkers = GetNPCArrayByClass( "npc_stalker" )
	foreach ( stalker in stalkers )
		OnNPCStalkerCreated( stalker ) // recreate grenade arrows since they would have gotten destroyed when the pilot cockpit was destroyed
}


