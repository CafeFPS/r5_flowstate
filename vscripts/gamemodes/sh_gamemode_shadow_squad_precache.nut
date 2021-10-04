global function ShPrecacheShadowSquadAssets

#if CLIENT
const asset SHADOW_SQUAD_IMAGE_ATLAS = $"ui_image_atlas/shadow_squad_mode.rpak"
#endif

void function ShPrecacheShadowSquadAssets()
{
	FX_SHADOW_FORM_EYEGLOW 				= $"P_BShadow_eye"
	FX_SHADOW_TRAIL 					= $"P_Bshadow_body"
	#if SERVER
		const asset DEATH_FX_SHADOW_SQUAD 				= $"P_Bshadow_death"
		const asset FX_EVAC_SHIP_FOR_SHADOWS 			= $"P_lootcache_far_beam"
		const asset ICON_NEMESIS						= $"rui/hud/gametype_icons/ltm/enemy_nemesis_color"
		const asset ICON_DEATH_LEGEND					= $"rui/hud/gametype_icons/ltm/deathpos_skull_legend"
		const asset ICON_DEATH_SHADOW					= $"rui/hud/gametype_icons/ltm/deathpos_skull_default_color"
		const asset ICON_DROPSHIP_EVAC_FOR_SHADOWS 		= $"rui/hud/common/evac_location_enemy"
	#endif //SERVER

	#if CLIENT
		SHADOW_SCREEN_FX 					= $"P_Bshadow_screen"
		FX_HEALTH_RESTORE					= $"P_heal_loop_screen"
		FX_SHIELD_RESTORE					= $"P_armor_FP_charged_full_CP"
	#endif

	PrecacheParticleSystem( FX_SHADOW_FORM_EYEGLOW )
	PrecacheParticleSystem( FX_SHADOW_TRAIL )

	#if SERVER
		PrecacheParticleSystem( DEATH_FX_SHADOW_SQUAD )
		PrecacheParticleSystem( FX_EVAC_SHIP_FOR_SHADOWS )
	#endif //SERVER

	#if CLIENT
		PrecacheParticleSystem( SHADOW_SCREEN_FX )
		PrecacheParticleSystem( FX_HEALTH_RESTORE )
		PrecacheParticleSystem( FX_SHIELD_RESTORE )

	#endif

}