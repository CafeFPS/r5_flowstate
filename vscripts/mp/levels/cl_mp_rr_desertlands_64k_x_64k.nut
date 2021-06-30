global function ClientCodeCallback_MapInit

void function ClientCodeCallback_MapInit()
{
	ClLaserMesh_Init()
	Desertlands_MapInit_Common()
	MapZones_RegisterDataTable( $"datatable/map_zones/zones_mp_rr_desertlands_64k_x_64k.rpak")

	AddCreateCallback( "trigger_cylinder_heavy", Geyser_OnJumpPadCreated )



	SURVIVAL_AddMinimapLevelLabel( "Capital City", 0.56, 0.42, 0.5 )
	SURVIVAL_AddMinimapLevelLabel( "Thermal Station",  0.28, 0.73, 0.5)
	SURVIVAL_AddMinimapLevelLabel( "Overlook", 0.85, 0.40, 0.5 )
	SURVIVAL_AddMinimapLevelLabel( "Skyhook", 0.35, 0.22, 0.5 )
	SURVIVAL_AddMinimapLevelLabel( "Lava City", 0.80, 0.80, 0.5 )
	SURVIVAL_AddMinimapLevelLabel( "Lava Fissure", 0.18, 0.41, 0.5)
	SURVIVAL_AddMinimapLevelLabel( "Refinery", 0.72, 0.18, 0.5 )
	SURVIVAL_AddMinimapLevelLabel( "Ground Zero", 0.63, 0.30, 0.5 )
	SURVIVAL_AddMinimapLevelLabel( "Young Unreliable", 0.79, 0.60, 0.5 )
	SURVIVAL_AddMinimapLevelLabel( "The Tree", 0.42, 0.85, 0.5 )
	SURVIVAL_AddMinimapLevelLabel( "Volcanic Base", 0.72, 0.92, 0.5 )
	SURVIVAL_AddMinimapLevelLabel( "Train Yard", 0.38, 0.45, 0.5 )
	SURVIVAL_AddMinimapLevelLabel( "Sorting Factory", 0.57, 0.72, 0.5 )
	SURVIVAL_AddMinimapLevelLabel( "Drill Site", 0.29, 0.35, 0.5 )
	SURVIVAL_AddMinimapLevelLabel( "Fuel Depot", 0.52, 0.60, 0.5 )


	//SURVIVAL_AddMinimapLevelLabel( "Tunnel", 0.52, 0.64, 0.3)
//
	//SURVIVAL_AddMinimapLevelLabel( "Tunnel", 0.74, 0.51, 0.3)
//
	//SURVIVAL_AddMinimapLevelLabel( "Tunnel", 0.48, 0.18, 0.3)
//
	//SURVIVAL_AddMinimapLevelLabel( "Tunnel", 0.41, 0.51, 0.3)
//
	//SURVIVAL_AddMinimapLevelLabel( "Tunnel", 0.67, 0.75, 0.3)
//
	//SURVIVAL_AddMinimapLevelLabel( "Tunnel", 0.43, 0.32, 0.3)


	//SURVIVAL_AddMinimapLevelLabel( "`1*", 0.70, 0.57, 1.0)
	//SURVIVAL_AddMinimapLevelLabel( "`1*", 0.77, 0.65, 1.0)
	//SURVIVAL_AddMinimapLevelLabel( "`1*", 0.18, 0.37, 1.0)
	//SURVIVAL_AddMinimapLevelLabel( "`1*", 0.37, 0.58, 1.0)
	//SURVIVAL_AddMinimapLevelLabel( "`1*", 0.20, 0.47, 1.0)
//
	////Legand
	//SURVIVAL_AddMinimapLevelLabel( "`1Elevators", 0.12, 0.95, 0.5)
	//SURVIVAL_AddMinimapLevelLabel( "`1*", 0.05, 0.85, 1.0)


	//SURVIVAL_AddMinimapLevelLabel( "%$r2_ui/menus/loadout_icons/attachments/energy_ar_quick_charge%", 0.60, 0.20, 2.0 )
	//SURVIVAL_AddMinimapLevelLabel( "Cave", 0.85, 0.55, 0.5 )
	//SURVIVAL_AddMinimapLevelLabel( "Bridge", 0.75, 0.80, 0.5 )
//
	//SURVIVAL_AddMinimapLevelLabel( "Elevator", 0.22, 0.57, 0.3)
	//SURVIVAL_AddMinimapLevelLabel( "Elevator", 0.80, 0.87, 0.3)
	//SURVIVAL_AddMinimapLevelLabel( "Gandola", 0.20, 0.75, 0.3)
	//SURVIVAL_AddMinimapLevelLabel( "Gandola", 0.30, 0.93, 0.3)
}

void function Geyser_OnJumpPadCreated( entity trigger )
{
	trigger.SetClientEnterCallback( Geyser_OnJumpPadAreaEnter )
}

void function Geyser_OnJumpPadAreaEnter( entity trigger, entity player )
{
	entity localViewPlayer = GetLocalViewPlayer()
	if ( player != localViewPlayer )
		return

	if ( !IsPilot( player ) )
		return

	EmitSoundOnEntity( player, "JumpPad_LaunchPlayer_1p" )
	EmitSoundOnEntity( player, "JumpPad_Ascent_Windrush" )

	Chroma_UsedJumpPad()
}