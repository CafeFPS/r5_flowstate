// Made by @CafeFPS

// Featuring:
// Entities Clean Up
// Bunker Hatches
// Charge Pylons
// Warp Tunnel

global function CodeCallback_MapInit

const asset BUNKER_MODEL_SCALE_DOWN = $"mdl/props/bunker_hatch/bunker_hatch_scale_down.rmdl"
const asset BUNKER_BUTTON_MODEL = $"mdl/props/global_access_panel_button/global_access_panel_button_console.rmdl"
const asset BUNKER_MODEL = $"mdl/props/bunker_hatch/bunker_hatch.rmdl"

struct {
	array<entity> bunkerDoorsScaleDown
	array<entity> bunkerDoors
} file

void function CodeCallback_MapInit()
{
	printt( "----------------------------" )
	printt( "Welcome to Kings Canyon MU2" )
	printt( "-- textures and models port: AyeZee" )
	printt( "-- models collision and engine fixes: rexx & Amos" )
	printt( "-- map scripts: CafeFPS" )
	printt( "----------------------------" )

	SetVictorySequencePlatformModel( $"mdl/rocks/victory_platform.rmdl", < 0, 0, -10 >, < 0, 0, 0 > )
	SURVIVAL_SetPlaneHeight( 24000 )
	SURVIVAL_SetAirburstHeight( 8000 )
	SURVIVAL_SetMapCenter( <0, 0, 0> )
    SURVIVAL_SetMapDelta( 4900 )

	MapZones_RegisterDataTable( $"datatable/map_zones/zones_mp_rr_canyonlands_mu2_1.rpak" )
	
	//Clean up unused ents
	AddCallback_EntitiesDidLoad( KCMU2_OnEntitiesDidLoad )

	AddSpawnCallback( "info_spawnpoint_human", CleanupEnt )
	Canyonlands_MapInit_Common()
}

void function CleanupEnt( entity ent )
{
	if( !IsValid( ent ) )
		return

	ent.Destroy()
}

void function InitInfoTarget( entity infotarget )
{
	if( GetEditorClass( infotarget ) == "info_warp_gate_path_node" || infotarget.GetScriptName() == "apex_screen" )
		return

	if( ShouldDestroyInfoTarget( infotarget ) )
	{
		// printt( "Destroyed useless info target ent leftover" )
		infotarget.Destroy()
	}
}

bool function ShouldDestroyInfoTarget( entity infotarget )
{
	if( GetEditorClass( infotarget ) == "" && infotarget.GetScriptName() == "" && infotarget.GetTargetName() == "" )
		return true

	if( GetEditorClass( infotarget ) == "info_warp_gate_path_node" || infotarget.GetScriptName() == "apex_screen" )
		return false
	
	if( infotarget.GetModelName() == $"mdl/test/loot_box_half_01.rmdl" || infotarget.GetModelName() == $"mdl/vehicle/droppod_fireteam/droppod_fireteam.rmdl" )
		return true
	
	return false
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

	if( GetEditorClass( scriptref ) == "" && scriptref.GetScriptName() == "" && scriptref.GetTargetName() == "" || GetEditorClass( scriptref ) == "info_survival_circle_end_location" || scriptref.GetModelName() == $"mdl/dev/editor_ref.rmdl" )
	{
		// printt( "Destroyed useless script ref ent leftover" )
		scriptref.Destroy()
	}
}

void function KCMU2_OnEntitiesDidLoad() 
{
	printt( "KCMU2_OnEntitiesDidLoad" )

	array<entity> scriptRefs = GetEntArrayByClass_Expensive( "script_ref" )
	foreach( ref in scriptRefs )
		InitScriptRef( ref )

	array<entity> infoTargets = GetEntArrayByClass_Expensive( "info_target" )
	foreach( target in infoTargets )
		InitInfoTarget( target )

	array<entity> props = GetEntArrayByClass_Expensive( "prop_dynamic" )
	foreach( prop in props )
		InitPropDynamic( prop )

	SetupBunkersDoors()
}

void function InitPropDynamic( entity prop )
{
	if( prop.GetModelName() == BUNKER_MODEL )
		file.bunkerDoors.append( prop )

	if( prop.GetModelName() == BUNKER_MODEL_SCALE_DOWN )
		file.bunkerDoorsScaleDown.append( prop )

	// printt( "prop spawned", prop.GetModelName(), prop.GetOrigin() )

	if( ShouldDestroyPropDynamic( prop.GetModelName() ) )
		prop.Destroy()
}

bool function ShouldDestroyPropDynamic( string model )
{
	switch( model )
	{
		case "mdl/props/proxy_r5/pvp_currency_container.rmdl":
		case "mdl/props/crafting_siphon/crafting_siphon.rmdl":
		case "mdl/props/crafting_replicator/crafting_replicator.rmdl":
		case "mdl/props/global_access_panel_button/global_access_panel_button_console_w_stand.rmdl":
		return true
	}
	
	return false
}

void function SetupBunkersDoors()
{
	array<entity> allDoors
	allDoors.extend( file.bunkerDoorsScaleDown )
	allDoors.extend( file.bunkerDoors )

	foreach( entity door in allDoors )
	{
		entity button
		foreach( link in door.GetLinkEntArray() )
		{
			// printt( door, link, link.GetOrigin() )
			if( link.GetScriptName() == "bunker_hatch_panel_model" )
				button = link
		}

		door.Anim_PlayOnly( "bunker_hatch_close_idle" )
		door.SetCycle( 1.0 )

		if( IsValid( button ) )
		{
			button.kv.solid = 0 //fixes crash
			button.SetUsableByGroup( "pilot" )
			button.SetUsePrompts( "%use% To Open Hatch", "%use% To Open Hatch" )

			if( file.bunkerDoorsScaleDown.contains( door ) )
				AddCallback_OnUseEntity( button, BunkerDoorSmall_OnOpen )
			else
				AddCallback_OnUseEntity( button, BunkerDoor_OnOpen )

		} else //There is not button only for Ash Teaser bunker, leave it open.
		{
			thread function() : ( door )
			{
				door.Anim_PlayOnly( "bunker_hatch_open" )
				wait door.GetSequenceDuration( "bunker_hatch_open" )
				door.Anim_PlayOnly( "bunker_hatch_open_idle" )
			}()
		}
	}
}

entity function BunkerDoor_GetDoorForButton( entity button )
{
	foreach( door in file.bunkerDoorsScaleDown )
	{
		foreach( link in door.GetLinkEntArray() )
		{
			if( link == button )
				return door
		}
	}

	foreach( door in file.bunkerDoors )
	{
		foreach( link in door.GetLinkEntArray() )
		{
			if( link == button )
				return door
		}
	}
	
	return null
}

void function BunkerDoor_OnOpen( entity button, entity user, int input )
{
	button.SetSkin( 1 )
	button.UnsetUsable()

	entity door = BunkerDoor_GetDoorForButton( button )
	
	thread function() : ( door, button )
	{
		door.Anim_PlayOnly( "bunker_hatch_open" )
		wait door.GetSequenceDuration( "bunker_hatch_open" )
		door.Anim_PlayOnly( "bunker_hatch_open_idle" )
	}()
}

void function BunkerDoorSmall_OnOpen( entity button, entity user, int input )
{
	button.SetSkin( 1 )
	button.UnsetUsable()

	entity door = BunkerDoor_GetDoorForButton( button )

	bool doorHasSpecialZiplineStart = false
	entity specialZipStartInfoTarget

	foreach( link in door.GetLinkEntArray() )
	{
		if( link.GetScriptName() == "hatch_special_zipline_start_target" )
		{
			doorHasSpecialZiplineStart = true
			specialZipStartInfoTarget = link
		}
	}

	if( doorHasSpecialZiplineStart && specialZipStartInfoTarget )
	{
		thread BunkerDoor_CreateZipline( specialZipStartInfoTarget.GetOrigin() + <0,0,50>, < specialZipStartInfoTarget.GetOrigin().x, specialZipStartInfoTarget.GetOrigin().y, button.GetOrigin().z >, true )
	}

	thread function() : ( door, button )
	{
		door.Anim_PlayOnly( "bunker_hatch_open" )
		wait door.GetSequenceDuration( "bunker_hatch_open" )
		door.Anim_PlayOnly( "bunker_hatch_open_idle" )

		BunkerDoor_CreateZipline( < door.GetOrigin().x, door.GetOrigin().y, door.GetOrigin().z + 200 > , < door.GetOrigin().x, door.GetOrigin().y, door.GetOrigin().z - 1000 >, true )
	}()
}

void function BunkerDoor_CreateZipline( vector startPos, vector endPos, bool moveIt )
{
	entity zip_start = CreateEntity("zipline")
	entity zip_end = CreateEntity("zipline_end")

	zip_start.SetOrigin( startPos )

	entity mover 
	
	if( moveIt )
	{
		zip_end.SetOrigin( startPos - <0,0,1> )
		mover = CreateScriptMover( zip_start.GetOrigin(), zip_start.GetAngles())
		zip_end.SetParent(mover)
	} else
	{
		zip_end.SetOrigin( endPos )
		zip_start.kv._zipline_rest_point_0 = startPos.x + " " + startPos.y + " " + startPos.z
		zip_start.kv._zipline_rest_point_1 = endPos.x + " " + endPos.y + " " + endPos.z
	}

	zip_start.kv.ZiplineAutoDetachDistance = "160"
	zip_end.kv.ZiplineAutoDetachDistance = "160"

	zip_start.LinkToEnt(zip_end)
	zip_start.kv.Material = "cable/zipline.vmt"
	zip_start.kv.ZiplineVertical = true
	zip_start.kv.ZiplinePreserveVelocity = true

	zip_start.Zipline_Disable()

	DispatchSpawn(zip_start)
	DispatchSpawn(zip_end)
	
	if( moveIt )
	{
		mover.NonPhysicsMoveTo( endPos, 1.0, 1.0, 0.0  )
		wait 1.0
		zip_end.SetOrigin( endPos )
		zip_end.ClearParent()
		mover.Destroy()
		zip_start.Zipline_Enable()
		zip_start.Zipline_WakeUp()
	} else
	{
		zip_start.Zipline_Enable()
		zip_start.Zipline_WakeUp()
	}
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
