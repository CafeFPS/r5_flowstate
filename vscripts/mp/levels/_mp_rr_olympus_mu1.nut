// Made by @CafeFPS

// Featuring:
// Entities Clean Up
// Pathfinder Town Takeover boxing ring set up
// Pathfinder Town Takeover screens set up
// Warp Tunnels
// Bridge Vault Set Up
// Ship Weapon Racks

global function CodeCallback_MapInit

#if DEVELOPER
global function DEV_AdScreenToggle
global function DEV_KoScreenToggle
global function DEV_StartNodesLinksShow
#endif

struct {
	entity adScreenEnt
	entity koScreenEnt
	array<entity> racks
	array<entity> vaultKeys
	array<entity> nodes
} file

void function CodeCallback_MapInit()
{
	printt( "----------------------------" )
	printt( "Welcome to Olympus MU1" )
	printt( "-- textures and models port: AyeZee" )
	printt( "-- models collision and engine fixes: rexx & Amos" )
	printt( "-- map scripts: CafeFPS" )
	printt( "----------------------------" )

	SetVictorySequencePlatformModel( $"mdl/rocks/victory_platform.rmdl", < 0, 0, -10 >, < 0, 0, 0 > )

	Olympus_MapInit_Common()
	SURVIVAL_SetPlaneHeight( 12500 )
	SURVIVAL_SetAirburstHeight( 9000 )
	SURVIVAL_SetMapCenter( <-6900, 2940, 0> )
	// SURVIVAL_SetMapDelta( 50000 )


	PathTT_Init()
	MapZones_RegisterDataTable( $"datatable/map_zones/zones_mp_rr_olympus_mu1.rpak" )
	
	//Clean up unused ents
	AddCallback_EntitiesDidLoad( Olympus_OnEntitiesDidLoad )
	// AddSpawnCallbackEditorClass( "prop_dynamic", "script_loot_marvin", CleanupEnt )
	// AddSpawnCallbackEditorClass( "prop_dynamic", "script_survival_crafting_workbench_cluster", CleanupEnt )
	// AddSpawnCallbackEditorClass( "prop_dynamic", "script_survival_crafting_harvester", CleanupEnt )
	// AddSpawnCallbackEditorClass( "player_vehicle", "hover_vehicle", CleanupEnt )
	// AddSpawnCallbackEditorClass( "prop_script", "control_vehicle_summon_platform", CleanupEnt )
	// AddSpawnCallbackEditorClass( "func_brush", "func_brush_arenas_start_zone", CleanupEnt )
	
	// AddSpawnCallback( "info_spawnpoint_human", InitSpawnpoint )
	// AddSpawnCallback( "info_spawnpoint_human_start", InitSpawnpoint )
	// AddSpawnCallback( "info_spawnpoint_titan", InitSpawnpoint )
	// AddSpawnCallback( "info_spawnpoint_titan_start", InitSpawnpoint )
	// AddSpawnCallback( "trigger_multiple", InitTriggerMultiple )
	
	// AddSpawnCallback( "script_ref", InitScriptRef )
	// AddSpawnCallback( "info_target", InitInfoTarget )
	
	// AddSpawnCallbackEditorClass( "trigger_multiple", "trigger_warp_gate", Flowstate_InitWarpGateTrigger )
}

void function Olympus_OnEntitiesDidLoad() 
{
	// //Remove trident walls
	// array<entity> tridentWalls = GetEntArrayByScriptName( "vehicle_fence_01" )
	// foreach( ent in tridentWalls )
		// ent.Destroy()

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
	}

	if( Gamemode() == eGamemodes.SURVIVAL )
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
	printt( "Spawned key for Ship Bridge Vault at ", chosenKey.GetOrigin() )
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
	spawn.Destroy()
}

void function InitInfoTarget( entity infotarget )
{
	if( GetEditorClass( infotarget ) == "info_warp_gate_path_node" ) // || GetEditorClass( infotarget ) == "warp_node_rift_exit" || GetEditorClass( infotarget ) == "oly_pr_warn_fx_ref"  )
	{
		//screen_flash_on_node && cinematic_path_node
	
		InitWarpNode( infotarget )
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

	trigger.Destroy()
}

void function CleanupEnt( entity ent )
{
	if( !IsValid( ent ) )
		return

	ent.Destroy()
}

//Warp Tunnels
// ██     ██  █████  ██████  ██████      ████████ ██    ██ ███    ██ ███    ██ ███████ ██      ███████ 
// ██     ██ ██   ██ ██   ██ ██   ██        ██    ██    ██ ████   ██ ████   ██ ██      ██      ██      
// ██  █  ██ ███████ ██████  ██████         ██    ██    ██ ██ ██  ██ ██ ██  ██ █████   ██      ███████ 
// ██ ███ ██ ██   ██ ██   ██ ██             ██    ██    ██ ██  ██ ██ ██  ██ ██ ██      ██           ██ 
 // ███ ███  ██   ██ ██   ██ ██             ██     ██████  ██   ████ ██   ████ ███████ ███████ ███████

void function Flowstate_InitWarpGateTrigger( entity ent )
{
	if( Gamemode() != eGamemodes.SURVIVAL )
		return

	Flowstate_WarpTunnel_SetupEnterTrigger( ent )

	ent.e.warpEntrancePath.clear()

	//should_teleport_to_first_node
	//warp_travel_speed

	ent.e.warpEntrancePath = Flowstate_GenerateWarpBasePathForTrigger( ent )
	array<vector> portalNodes
	foreach( node in ent.e.warpEntrancePath )
	{
		portalNodes.append( node.GetOrigin() )
	}
	ent.e.warpEntranceSmoothedPath = Flowstate_GenerateSmoothPathForBasePath( portalNodes )

	printt( "Warp Path created for Trigger:", ent, ent.e.warpEntrancePath.len(), "- Smooth path len:", ent.e.warpEntranceSmoothedPath.len() )
}

void function InitWarpNode( entity infotarget )
{
	file.nodes.append( infotarget )
	
	// #if DEVELOPER
	// if( infotarget.GetLinkEntArray().len() == 2 )
	// {
		// DebugDrawSphere( infotarget.GetOrigin(), 80, 255, 0, 255, true, 999.0 ) //morado

			// DebugDrawLine( infotarget.GetOrigin(), infotarget.GetLinkEntArray()[0].GetOrigin(), 255, 0, 255, true, 999 )
			// DebugDrawLine( infotarget.GetOrigin(), infotarget.GetLinkEntArray()[1].GetOrigin(), 0, 255, 0, true, 999 )

	// }
	// else if( infotarget.GetLinkEntArray().len() == 1 )
	// {
		// DebugDrawSphere( infotarget.GetOrigin(), 80, 0, 0, 255, true, 999.0 ) //azul
		// foreach( link in infotarget.GetLinkEntArray() )
		// {
			
			// DebugDrawLine( infotarget.GetOrigin(), link.GetOrigin(), 0, 0, 255, true, 999 )
		// }
	// } else if( infotarget.GetLinkEntArray().len() == 0 )
	// {
		// DebugDrawSphere( infotarget.GetOrigin(), 80, 0, 255, 0, true, 999.0 ) //green
		// foreach( link in infotarget.GetLinkEntArray() )
		// {
			
			// DebugDrawLine( infotarget.GetOrigin(), link.GetOrigin(), 0, 255, 0, true, 999 )
		// }
	// }
	// #endif

}

#if DEVELOPER
void function DEV_StartNodesLinksShow()
{
	foreach( node in file.nodes )
	{
		if( node.GetLinkEntArray().len() != 2 )
			continue

		DebugDrawSphere( node.GetOrigin(), 80, 255, 0, 255, true, 3.0 ) //morado
		
		printt( "morado:", node.GetLinkEntArray()[0], node.GetLinkEntArray()[0].GetOrigin() )
		printt( "verde:", node.GetLinkEntArray()[1], node.GetLinkEntArray()[1].GetOrigin() )
		DebugDrawLine( node.GetOrigin(), node.GetLinkEntArray()[0].GetOrigin(), 255, 0, 255, true, 3.0 )
		DebugDrawLine( node.GetOrigin(), node.GetLinkEntArray()[1].GetOrigin(), 0, 255, 0, true, 3.0 )

		wait 3
	}
}
#endif

array<entity> function Flowstate_GenerateWarpBasePathForTrigger( entity ent )
{
	array<entity> nodes
	array<entity> linkedEnts = ent.GetLinkEntArray()
	
	foreach ( entity link in linkedEnts ) //Obtener el nodo verde
	{
		if( GetEditorClass( link ) != "info_warp_gate_path_node" )
			continue
				
		if( link.GetLinkEntArray().len() == 0 )
		{
			nodes.append( link )
		}
	}
	
	entity nextEnt
	int type
	foreach ( entity link in linkedEnts )
	{
		if( GetEditorClass( link ) != "info_warp_gate_path_node" )
			continue
		
		if( link.GetLinkEntArray().len() == 2 || link.GetLinkEntArray().len() == 1 )
		{
			type = link.GetLinkEntArray().len()

			nextEnt = link
			nodes.append( link )
		}
	}
	
	if( !IsValid( nextEnt ) )
		return []

	int added
	int runs

	while( true )
	{
		array<entity> newNodes = nextEnt.GetLinkEntArray()
		foreach( entity newLink in newNodes )
		{
			if( newLink.GetClassName() != "info_target" && type == 2 && nodes.len() < 5 )
				continue
			
			if( newLink.GetClassName() == "script_ref" )
				continue

			if( !nodes.contains( newLink ) && newLink != nextEnt )
			{
				nodes.append( newLink )
				printt( "added link", newLink, newLink.GetOrigin() )
				nextEnt = newLink
				added++
				
				continue
			}
		}
		runs++
		// printt( type, runs, added )
		if( runs != added )
			break
	}

	nodes.removebyvalue( nodes[0] ) //Eliminar el nodo verde del comienzo, no es necesario
	
	//Eliminar los trigger multiple que se hayan agregado
	foreach( node in nodes )
	{
		if( node.GetClassName() != "info_target" )
		{
			nodes.removebyvalue( node )
		}
	}

	return nodes
}

array<vector> function Flowstate_GenerateSmoothPathForBasePath( array<vector> path ) 
{
	printt( "generating smooth points for path with len", path.len() )
	if( path.len() == 0 )
		return []

    array<vector> smoothPath
	array<vector> points = clone path
	
	int numPoints = 10

	points.insert( 0, points[0] )
	points.removebyvalue( points[points.len()-1] )
	if( path.len() == 7 )
		points.removebyvalue( points[points.len()-1] )
	points.insert( points.len(), points[points.len()-1] )

    for (int i = 0; i < points.len() - 3; i++)
    {
        for (int j = 0; j < numPoints; j++)
        {
            float t = float( j ) / float( numPoints )
            smoothPath.append( Flowstate_CatmullRom( points[i], points[i+1], points[i+2], points[i+3], t) )
        }
    }
    return smoothPath
}

//Catmull-Rom algo to smooth the path.
vector function Flowstate_CatmullRom( vector p0, vector p1, vector p2, vector p3, float t)
{
    vector v0 = p1
    vector v1 = 0.5 * (p2 - p0)
    vector v2 = p0 - 2.5 * p1 + 2 * p2 - 0.5 * p3
    vector v3 = 0.5 * (p3 - p0) + 1.5 * (p1 - p2)

    return v0 + v1 * t + v2 * t * t + v3 * t * t * t;
}

void function Flowstate_WarpTunnel_MoveEntAlongPath( entity player, array<entity> entNodes, entity trigger )
{
	if( entNodes.len() == 0 )
		return

	if( player.Player_IsFreefalling() )
	{
		Signal( player, "PlayerSkyDive" )
		WaitFrame()
	}

	array<vector> portalNodes
	array<vector> pathAngles
	
	foreach( node in entNodes )
	{
		portalNodes.append( node.GetOrigin() )
		pathAngles.append( node.GetAngles() )
	}

	int typeOfTunnel = entNodes.len() == 7 ? 2 : entNodes.len() == 6 ? 2 : 1

	if( typeOfTunnel == 2 )
	{
		portalNodes.clear()
		portalNodes = clone trigger.e.warpEntranceSmoothedPath
		portalNodes.append( entNodes[entNodes.len()-1].GetOrigin() )
	}
	
	#if DEVELOPER
	foreach( point in trigger.e.warpEntranceSmoothedPath )
	{
		DebugDrawSphere( point, 80, 255, 0, 255, true, 999 ) //morado
	}
	#endif

	player.EndSignal( "OnDeath" )
	
	player.Zipline_Stop()
	player.ClearTraverse()
	player.SetPredictionEnabled( false )
	player.FreezeControlsOnServer()

	//Don't re-enable weapons if player is carrying loot.
	if ( !SURVIVAL_IsPlayerCarryingLoot( player ) && !Bleedout_IsBleedingOut( player )  )
		HolsterAndDisableWeapons( player )

	entity mover = CreateScriptMover( portalNodes[0], pathAngles[0] )

	mover.EnableNonPhysicsMoveInterpolation( false ) // works around bug R5DEV-49571

	player.e.isInPhaseTunnel = true

	OnThreadEnd(
		function() : ( player, mover )
		{
			player.ClearParent()
			player.SetVelocity( <0,0,0> )
			
			StopSoundOnEntity( player, "Wraith_PhaseGate_Travel_1p" )
			StopSoundOnEntity( player, "Wraith_PhaseGate_Travel_3p" )

			if ( IsValid( mover ) )
				mover.Destroy()

			player.UnfreezeControlsOnServer()
			

			thread function () : ( player )
			{
				wait 2
				
				if ( IsValid( player ) )
				{
					CancelPhaseShift( player )
					player.SetPredictionEnabled( true )

					// TODO: DeployAndEnableWeapons should really use a stack so we don't have to do weird if-else's
					if ( !SURVIVAL_IsPlayerCarryingLoot( player ) && !Bleedout_IsBleedingOut( player ) )
					{
						if ( Survival_IsPlayerHealing( player ) )
							EnableOffhandWeapons( player )
						else
							DeployAndEnableWeapons( player )
					}
				}

				player.e.isInPhaseTunnel = false
			}()
		}
	)

	WaitEndFrame()

	EmitSoundOnEntityOnlyToPlayer( player, player, "Wraith_PhaseGate_Travel_1p" )
	EmitSoundOnEntityExceptToPlayer( player, player, "Wraith_PhaseGate_Travel_3p" )

	ViewConeZeroInstant( player )

	vector anglesToUse = Flowstate_GetNextAngleToLookAt(1, 1, portalNodes)

	player.SetAbsOrigin( portalNodes[0] )
	player.SetAbsAngles( anglesToUse + <0, -180, 0> )
	// player.SetAngles(anglesToUse + <0, -180, 0> )
	printt( "angles to use: ", anglesToUse, pathAngles[0], anglesToUse + <0, -180, 0>  )
	mover.SetAbsAngles( anglesToUse + <0, -180, 0> )

	thread function () : ( mover, pathAngles, player, portalNodes, anglesToUse)
	{
		WaitFrame()
	
		if( !IsValid( player ) || !IsAlive( player ) || !player.e.isInPhaseTunnel )
			return

		player.SetAbsOrigin( portalNodes[0] )
		player.SetAbsAngles( anglesToUse + <0, -180, 0> )
		// player.SetAngles(anglesToUse + <0, -180, 0> )
		printt( "angles to use: ", anglesToUse, pathAngles[0], anglesToUse + <0, -180, 0>  )
		// mover.SetAbsAngles( anglesToUse + <0, -180, 0> )
	}()

	player.SetParent( mover, "REF", true )	
	
	//Play Warp Screen Flash
	entity fx = PlayFXOnEntity( $"P_wrth_tt_portal_screen_flash", player )

	float travelSpeed = 3500
	
	if( trigger.HasKey( "warp_travel_speed" ) )
		travelSpeed = expect string( trigger.kv.warp_travel_speed ).tofloat()

	float phaseTime
	float distanceToNextNode
	float startTime = Time()
	float elapsedTime

	//Phase Shift Player
	PhaseShift( player, 0.0, 999, eShiftStyle.Gate )
	
	// int actualmovements

	// foreach( int i, node in portalNodes )
	// {
		// if( i == 0 || i == 4 && typeOfTunnel == 1 )
		// {
			// continue
		// }

		// if( i == 3 && typeOfTunnel == 1 )
		// {
			// continue
		// }

		// if( node == portalNodes[portalNodes.len()-2] )
		// {
			// continue
		// }

		// if( i == portalNodes.len()-1 )
		// {
			// break
		// }

		// actualmovements++
	// }

	foreach( int i, node in portalNodes )
	{
		anglesToUse = Flowstate_GetNextAngleToLookAt(i, 1, portalNodes)

		elapsedTime = Time() - startTime

		if( i == 0 || i == 4 && typeOfTunnel == 1 )
		{
			// mover.SetAngles( anglesToUse )
			// player.SetAbsAngles( anglesToUse )
			
			// mover.NonPhysicsRotateTo( anglesToUse + <0, -180, 0>, 0.01, 0, 0 )
			// mover.SetOrigin( portalNodes[ i + 1 ] )
			// mover.SetAngles( pathAngles[ i + 1 ] )
			continue
		}

		if( i == 3 && typeOfTunnel == 1 )
		{
			entity fx2 = PlayFXOnEntity( $"P_wrth_tt_portal_screen_flash", player )
			mover.SetOrigin( portalNodes[ i + 1 ] )
			mover.SetAbsAngles( pathAngles[ i + 1 ] )
			// player.SetAbsAngles( pathAngles[ i + 1 ] )
			continue
		}

		if( node == portalNodes[portalNodes.len()-2] && entNodes.len() != 6 )
		{
			printt( "flashing screen" )
			entity fx2 = PlayFXOnEntity( $"P_wrth_tt_portal_screen_flash", player )
			continue
		}

		if( i == portalNodes.len()-1 )
		{
			player.ClearParent()
			player.SetVelocity(<0,0,0>)
			player.SetAbsOrigin( node )

			WaitFrame()
			player.SetAbsAngles( pathAngles[ pathAngles.len()-1 ] )
			break
		}

		distanceToNextNode = Distance( mover.GetOrigin(), node )
		
		// distanceToFinalNode = 0
		// for( int j = i ; j < portalNodes.len()-2; j++)
		// {
			// // if( i == 3 && typeOfTunnel == 1 )
				// // continue

			// distanceToFinalNode += Distance( portalNodes[j - 1], portalNodes[j] )
		// }

		phaseTime = distanceToNextNode / travelSpeed // :)
	
		// printt( "travelling to warp node - Elapsed time: ", elapsedTime)// , "Total movements", actualmovements, phaseTime )
		// printt( "distanceToNextNode: ", distanceToNextNode, "- distanceToFinalNode ", distanceToFinalNode )

		mover.NonPhysicsMoveTo( node, phaseTime, 0, 0 )
		mover.NonPhysicsRotateTo( anglesToUse + <0, -180, 0>, phaseTime, 0, 0 )
		wait phaseTime - 0.055
	}
	
	#if DEVELOPER
		printt( "travel finished in ", elapsedTime, "s.")
	#endif
}

vector function Flowstate_GetNextAngleToLookAt( int currentIndex, int step, array< vector > pathNodeDataArray )
{
	int lookAhead = 2
	int total = 1
	vector startPosition = pathNodeDataArray[currentIndex]
	int nextIndex = currentIndex - step

	if ( nextIndex < 0 )
		return <0,0,0>

	vector nextPosition = startPosition

	while ( nextIndex >= 0 && lookAhead > 0 )
	{
		nextPosition = nextPosition + pathNodeDataArray[nextIndex]

		lookAhead--
		total++
		nextIndex = nextIndex - step
	}

	nextPosition = nextPosition / total

	return VectorToAngles( nextPosition - startPosition )
}

void function Flowstate_WarpTunnel_SetupEnterTrigger( entity trigger )
{
	trigger.ConnectOutput( "OnStartTouch", Flowstate_WarpTunnel_OnStartTouch )
	trigger.ConnectOutput( "OnEndTouch", FS_WarpTunnel_OnEndTouch )
}

void function Flowstate_WarpTunnel_OnStartTouch( entity trigger, entity player, entity caller, var value )
{
	if( player.IsPhaseShifted() || player.e.isInPhaseTunnel )
		return

	#if DEVELOPER
		printt( "player should travel now", player )
	#endif

	thread Flowstate_WarpTunnel_MoveEntAlongPath( player, trigger.e.warpEntrancePath, trigger )
}

void function FS_WarpTunnel_OnEndTouch( entity trigger, entity player, entity caller, var value )
{
	// printt( "-out of warp trigger", player )
}

