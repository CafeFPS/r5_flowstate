global function ShReaperRodeo_Init

global const float RODEO_REAPER_DEBOUNCE = 2.0

global enum eRodeoSpots_Reaper
{
	TOP,
}

global enum eRodeoTransitions_Reaper
{
	ATTACH_TOP_FROM_FRONT,
	ATTACH_TOP_FROM_BACK,
}

struct
{
	RodeoVehicleFlavor& superSpectreFlavor
} file

void function ShReaperRodeo_Init()
{
	#if SERVER
		AddSpawnCallback( "npc_super_spectre", OnNpcSuperSpectreCreated )
	#endif
	#if CLIENT
		AddCreateCallback( "npc_super_spectre", OnNpcSuperSpectreCreated )
	#endif

	RodeoVehicleFlavor vf
	vf.isValidRodeoTarget = IsValidRodeoTarget
	vf.getAttachTransition = GetAttachTransition
	file.superSpectreFlavor = vf

	// todo(dw): fix up rodeo animations
	RodeoSpotFlavor sf
	{
		sf = RodeoVehicleFlavor_AddSpot( vf, eRodeoSpots_Reaper.TOP )
		sf.attachPoint = "hijack"
		sf.thirdPersonIdleAnim = "pt_rodeo_3P_super_spectre_idle"
		sf.firstPersonIdleAnim = "ptpov_rodeo_3P_super_spectre_idle"
	}

	RodeoTransitionFlavor tf
	{
		tf = RodeoVehicleFlavor_AddTransition( vf,
			eRodeoTransitions_Reaper.ATTACH_TOP_FROM_FRONT, RODEO_SENTINEL_BEGIN_SPOT_ATTACH, eRodeoSpots_Reaper.TOP
		)
		tf.attachment = "hijack"
		tf.thirdPersonAnim = "pt_rodeo_3P_super_spectre_f"
		tf.firstPersonAnim = "ptpov_rodeo_3P_super_spectre_f"
		tf.worldSound = "Rodeo_Atlas_Rodeo_ClimbOn_Left_Exterior"
		tf.cockpitSound = "Rodeo_Atlas_Rodeo_ClimbOn_Left_Interior"

		tf = RodeoVehicleFlavor_AddTransition( vf,
			eRodeoTransitions_Reaper.ATTACH_TOP_FROM_BACK, RODEO_SENTINEL_BEGIN_SPOT_ATTACH, eRodeoSpots_Reaper.TOP
		)
		tf.attachment = "hijack"
		tf.thirdPersonAnim = "pt_rodeo_3P_super_spectre_b"
		tf.firstPersonAnim = "ptpov_rodeo_3P_super_spectre_b"
		tf.worldSound = "Rodeo_Atlas_Rodeo_ClimbOn_Left_Exterior"
		tf.cockpitSound = "Rodeo_Atlas_Rodeo_ClimbOn_Left_Interior"
	}
}

void function OnNpcSuperSpectreCreated( entity npcSuperSpectre )
{
	Rodeo_RegisterVehicle( npcSuperSpectre, file.superSpectreFlavor )
}


bool function IsValidRodeoTarget( entity rider, entity vehicle )
{
	return RodeoState_GetRiderTimeSinceRodeo( rider ) > RODEO_REAPER_DEBOUNCE
}


int function GetAttachTransition( entity rider, entity titan )
{
	bool topAvailable = RodeoState_CheckSpotsAreAvailable( titan, eRodeoSpots_Reaper.TOP )
	if ( !topAvailable )
		return RODEO_SENTINEL_TRANSITION_NONE

	FrontRightDotProductsStruct dots = GetFrontRightDots( titan, rider )

	bool frontPreferred = (dots.forwardDot > 0)
	return frontPreferred ? eRodeoTransitions_Reaper.ATTACH_TOP_FROM_FRONT : eRodeoTransitions_Reaper.ATTACH_TOP_FROM_BACK
}


