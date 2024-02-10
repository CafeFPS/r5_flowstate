//Script by @CafeFPS

global function CodeCallback_MapInit

#if DEVELOPER
global function DEV_AdScreenToggle
global function DEV_KoScreenToggle
#endif

struct {
	entity adScreenEnt
	entity koScreenEnt
	array<entity> racks
	array<entity> vaultKeys
} file

void function CodeCallback_MapInit()
{
	printt( "----------------------------" )
	printt( "WELCOME TO R5R OLYMPUS MU1" )
	printt( "-- map port: AyeZee" )
	printt( "-- collision and engine fixes: rexx & Amos" )
	printt( "-- map scripts: @CafeFPS" )
	printt( "----------------------------" )

	SetVictorySequencePlatformModel( $"mdl/rocks/victory_platform.rmdl", < 0, 0, -10 >, < 0, 0, 0 > )
	SURVIVAL_SetPlaneHeight( 11500 )
	SURVIVAL_SetAirburstHeight( 9500 )
	SURVIVAL_SetMapCenter( <-6900, 2940, 0> )
	// SURVIVAL_SetMapDelta( 50000 )

	PathTT_Init()
	MapZones_RegisterDataTable( $"datatable/map_zones/zones_mp_rr_olympus_mu1.rpak" )
	
	//Clean up unused ents
	AddCallback_EntitiesDidLoad( Olympus_OnEntitiesDidLoad )
	AddSpawnCallbackEditorClass( "prop_dynamic", "script_loot_marvin", CleanupEnt )
	AddSpawnCallbackEditorClass( "prop_dynamic", "script_survival_crafting_workbench_cluster", CleanupEnt )
	AddSpawnCallbackEditorClass( "prop_dynamic", "script_survival_crafting_harvester", CleanupEnt )
	AddSpawnCallbackEditorClass( "player_vehicle", "hover_vehicle", CleanupEnt )
	AddSpawnCallbackEditorClass( "prop_script", "control_vehicle_summon_platform", CleanupEnt )

	//Clean up Arenas ents
	AddSpawnCallbackEditorClass( "func_brush", "func_brush_arenas_start_zone", CleanupEnt )
	
	AddSpawnCallback( "info_spawnpoint_human", InitSpawnpoint )
	AddSpawnCallback( "info_spawnpoint_human_start", InitSpawnpoint )
	AddSpawnCallback( "info_spawnpoint_titan", InitSpawnpoint )
	AddSpawnCallback( "info_spawnpoint_titan_start", InitSpawnpoint )
	AddSpawnCallback( "info_target", InitInfoTarget )
	AddSpawnCallback( "script_ref", InitScriptRef )
	AddSpawnCallback( "trigger_multiple", InitTriggerMultiple )
	
	AddSpawnCallbackEditorClass( "trigger_multiple", "trigger_warp_gate", InitWarpGateTrigger )
}

void function Olympus_OnEntitiesDidLoad() 
{
	//Remove trident walls
	array<entity> tridentWalls = GetEntArrayByScriptName( "vehicle_fence_01" )
	foreach( ent in tridentWalls )
		ent.Destroy()

	//Adjust props
	array<entity> props
	entity first = Entities_FindByClassname( null, "prop_dynamic" )

	while( IsValid( first ) )
	{
		props.append( first )
		first = Entities_FindByClassname( first, "prop_dynamic" )
	}

	foreach( ent in props )
	{
		if( ent.GetScriptName() == "path_tt_jumbo_screen_ad" )
		{
			file.adScreenEnt = ent
			printt( "Saved AD screen ent" )
		}
		else if( ent.GetScriptName() == "path_tt_jumbo_screen_ko" )
		{
			file.koScreenEnt = ent
			printt( "Saved KO screen ent" )
		} else if( ent.GetScriptName() == "ship_vault_corpse" )
		{
			file.vaultKeys.append( ent )
		}

		if( ent.GetTargetName() == "vehicle_platform" )
		{
			// printt( "Removed vehicle platform" )
			ent.Destroy()
		}
		
		if( ent.GetModelName() == $"mdl/industrial/gun_rack_arm_down.rmdl" )
		{
			file.racks.append( ent )
		}
		// To hook:
		// ship_vault_corpse
		// ShipVaultDoor
		// ShipVaultPanel
	}
	
	if( GameRules_GetGameMode() == SURVIVAL )
	{
		SpawnWeaponsonRacks()
		SetupKeyForShipVault()
	}
}

void function SpawnWeaponsonRacks()
{
	array<LootData> allWeapons = SURVIVAL_Loot_GetByType_InLevel( eLootType.MAINWEAPON , 2 )

	foreach( rack in file.racks )
	{
		SpawnWeaponOnRack( rack, allWeapons.getrandom().ref )
	}
}

void function SetupKeyForShipVault()
{
	entity chosenKey = file.vaultKeys.getrandom()
	foreach( key in file.vaultKeys )
	{
		if( key == chosenKey )
			continue
		
		key.Destroy()
	}
	
	SpawnGenericLoot( "data_knife", chosenKey.GetOrigin(), chosenKey.GetAngles(), 1 )
	printt( "Spawned key for Ship Vault at ", chosenKey.GetOrigin() )
	chosenKey.Destroy()
}

#if DEVELOPER
void function DEV_AdScreenToggle( bool toggle )
{
	if( toggle )
	{
		file.adScreenEnt.Hide()
	}else
	{
		file.adScreenEnt.Show()
	}
}

void function DEV_KoScreenToggle( bool toggle )
{
	if( toggle )
	{
		file.adScreenEnt.Hide()
	}else
	{
		file.adScreenEnt.Show()
	}
}

#endif
 
void function InitSpawnpoint( entity spawn )
{
	// #if DEVELOPER
	// DebugDrawSphere( spawn.GetOrigin(), 56, 255, 0, 0, true, 999.0 )
	// #endif
	// wtf are these Respawn
	spawn.Destroy()
}

void function InitInfoTarget( entity infotarget )
{
	if( GetEditorClass( infotarget ) == "info_warp_gate_path_node" || GetEditorClass( infotarget ) == "warp_node_rift_exit" || GetEditorClass( infotarget ) == "oly_pr_warn_fx_ref"  )
	{
		#if DEVELOPER
		// DebugDrawSphere( infotarget.GetOrigin(), 80, 255, 0, 255, true, 999.0 )
		#endif
		return
	}

	if( infotarget.GetScriptName() == "apex_screen" )
		return

	if( GetEditorClass( infotarget ) == "" && infotarget.GetScriptName() == "" && infotarget.GetTargetName() == "" )
	{
		// printt( "Destroyed useless info target ent leftover" )
		infotarget.Destroy()
		return
	}

	// printt( "Interesting Info target started. Editor: ", GetEditorClass( infotarget ), " ScriptRef: ", infotarget.GetScriptName()," Target: ", infotarget.GetTargetName() )

	#if DEVELOPER
	// DebugDrawSphere( infotarget.GetOrigin(), 56, 255, 255, 255, true, 999.0 )
	#endif

	infotarget.Destroy()
}

void function InitScriptRef( entity scriptref )
{
	array<string> stringCats

	if( GetEditorClass( scriptref ) != "" )
	{
		stringCats = split( GetEditorClass( scriptref ), "_" )
		
		if( stringCats[1] != "survival" )
		{
			// printt( "Removed Unused Script Ref Ent. Editor: ", GetEditorClass( scriptref ), " ScriptRef: ", scriptref.GetScriptName()," Target: ", scriptref.GetTargetName() )
			scriptref.Destroy()
			return
		}
	}
	
	if( scriptref.GetScriptName() != "" )
	{
		// printt( "Script Ref started. Editor: ", GetEditorClass( scriptref ), " ScriptRef: ", scriptref.GetScriptName()," Target: ", scriptref.GetTargetName() )
	}

	if( scriptref.GetTargetName() != "" )
	{
		// printt( "Script Ref started. Editor: ", GetEditorClass( scriptref ), " ScriptRef: ", scriptref.GetScriptName()," Target: ", scriptref.GetTargetName() )
	}
}

void function InitTriggerMultiple( entity trigger )
{
	if( GetEditorClass( trigger ) == "trigger_skydive" || GetEditorClass( trigger ) == "trigger_pve_zone" || GetEditorClass( trigger ) == "trigger_warp_gate" || trigger.GetScriptName() == "path_tt_ring_trig" )
	{
		// #if DEVELOPER
		// DebugDrawSphere( trigger.GetOrigin(), 128, 255, 255, 0, true, 999.0 )
		// #endif
		return
	}

	// printt( "Removed Unused Trigger Multiple. Editor: ", GetEditorClass( trigger ), " ScriptRef: ", trigger.GetScriptName()," Target: ", trigger.GetTargetName() )
	trigger.Destroy()
}

void function CleanupEnt( entity ent )
{
	if( !IsValid( ent ) )
		return

	ent.Destroy()
}

void function InitWarpGateTrigger( entity ent )
{
	printt( "Warp Trigger Start", ent )
	
	// if( ent.GetScriptName() == "warp_trigger_rift_entrance" )
	// {
		// printt( ent.GetLinkEnt() )
		// return
	// }

	// #if DEVELOPER
	// DebugDrawSphere( ent.GetOrigin(), 128, 255, 255, 255, true, 999.0 )
	// #endif

	array<entity> linkedEnts = ent.GetLinkEntArray()
	foreach ( entity link in linkedEnts )
	{
		if( link.GetClassName() == "trigger_multiple" )
			continue
		
		// if( link.GetLinkEntArray().len() > 1 )
		// {
			// foreach( entity newLink in link.GetLinkEntArray() )
			// {
				// DebugDrawSphere( newLink.GetOrigin(), 56, 255, 255, 0, true, 999.0 )
			// }
		// }
		// #if DEVELOPER
		// DebugDrawSphere( link.GetOrigin(), 256, 255, 0, 255, true, 999.0 )
		// #endif

		// printt( "Linked ent for Trigger", link )
		
		// if( link.GetScriptName() == "warp_trigger_rift_entrance" )
		// {
			// #if DEVELOPER
			// // DebugDrawSphere( link.GetOrigin(), 256, 255, 0, 255, true, 999.0 )
			// #endif
		// } else
		// {
			// #if DEVELOPER
			// DebugDrawSphere( link.GetOrigin(), 56, 0, 255, 255, true, 999.0 )
			// #endif
		// }
	}
}