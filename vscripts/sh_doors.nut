//
// ########   #######   #######  ########   ######
// ##     ## ##     ## ##     ## ##     ## ##    ##
// ##     ## ##     ## ##     ## ##     ## ##
// ##     ## ##     ## ##     ## ########   ######
// ##     ## ##     ## ##     ## ##   ##         ##
// ##     ## ##     ## ##     ## ##    ##  ##    ##
// ########   #######   #######  ##     ##  ######
//

global function ShDoors_Init
global function IsDoor
global function IsCodeDoor
global function IsDoorOpen
global function GetAllPropDoors

#if SERVER && R5DEV
global function DEV_RestartAllDoorThinks
#endif

global function CodeCallback_OnDoorInteraction

enum eDoorType
{
	MODEL,
	MOVER,
	PLAIN,
	SLIDING,
	BLOCKABLE,
	CODE,
}

struct DoorData
{
	string className
	string scriptName
	vector origin
	vector angles
	int realm
	asset modelName
	entity linkDoor
	bool hasLinkDoor
	DoorData ornull linkDoorData
}

struct
{
	#if SERVER && R5DEV
		table<entity, int> allDoors
	#endif

	#if SERVER
		int propDoorArrayIndex
	#endif //SERVER

	#if CLIENT
		array<entity> allPropDoors
	#endif //CLIENT

} file

void function ShDoors_Init()
{
	#if SERVER
		RegisterSignal( "PlayerEnteredDoorTrigger" )
		RegisterSignal( "PlayerLeftDoorTrigger" )
		RegisterSignal( "TryDoorInteraction" )
		RegisterSignal( "DoorIdle" )
		RegisterSignal( "DoorOperating" )
		//RegisterSignal( "DelayedSetDoorUsable" )
		RegisterSignal( "OperateLinkedDoor" )
		RegisterSignal( "BlockableDoor_ThreadedRegen" )
		RegisterSignal( "ScriptCalled" )
		RegisterSignal( "AnimTimeout" )

		AddSpawnCallback_ScriptName( "survival_door_model", OnDoorSpawned )
		AddSpawnCallback_ScriptName( "survival_door_plain", OnDoorSpawned )
		AddSpawnCallback_ScriptName( "survival_door_sliding", OnDoorSpawned )
		AddSpawnCallback( "prop_door", OnCodeDoorSpawned )

		file.propDoorArrayIndex = CreateScriptManagedEntArray()

		#if R5DEV
			RegisterSignal( "HaltDoorThink" )
			AddClientCommandCallback( "dev_spawn_blockable_door", ClientCommand_dev_spawn_blockable_door )
		#endif

	#endif
	#if CLIENT
		AddCreateCallback( "prop_dynamic", OnSomePropCreated )
		AddCreateCallback( "script_mover", OnSomePropCreated )
		AddCreateCallback( "door_mover", OnSomePropCreated )
		AddCreateCallback( "prop_door", OnCodeDoorCreated_Client )
		AddDestroyCallback( "prop_door", OnCodeDoorDestroyed_Client )
	#endif

	SurvivalDoorSliding_Init()
	BlockableDoor_Init()
}

bool function IsDoor( entity ent )
{
	if ( IsCodeDoor( ent ) )
		return true

	switch ( ent.GetScriptName() )
	{
		case "survival_door_model":
		case "survival_door_plain":
		case "survival_door_sliding":
		case "survival_door_blockable":
		case "survival_door_code":
		return true
	}

	return false
}

bool function IsDoorOpen( entity door )
{
	if ( !IsDoor( door ) )
		return false

	if ( IsCodeDoor( door ) )
	{
		return door.IsDoorOpen()
	}
	else
	{
		return GradeFlagsHas( door, eGradeFlags.IS_OPEN ) //
	}

	return false
}

array<entity> function GetAllPropDoors()
{
	#if SERVER
		array<entity> doors = GetScriptManagedEntArray( file.propDoorArrayIndex )
		return doors
	#endif //SERVER

	#if CLIENT
		return file.allPropDoors
	#endif //CLIENT
}

#if SERVER && R5DEV
bool function ClientCommand_dev_spawn_blockable_door( entity player, array<string> args )
{
	TraceResults tr = TraceLine(
		player.EyePosition(), player.EyePosition() + 300.0 * player.GetViewVector(),
		[ player ], TRACE_MASK_NPCWORLDSTATIC, TRACE_COLLISION_GROUP_NONE
	)

	entity door = CreateEntity( "prop_dynamic" )
	door.SetScriptName( "survival_door_model" )
	//door.SetValueForModelKey( $"mdl/door/door_108x60x4_generic_right_animated.rmdl" )
	door.SetValueForModelKey( $"mdl/door/door_104x64x8_elevatorstyle01_right_animated.rmdl" )
	door.SetOrigin( tr.endPos )
	door.SetAngles( AnglesCompose( VectorToAngles( FlattenNormalizeVec( tr.endPos - player.GetOrigin() ) ), <0, -90, 0> ) )
	DispatchSpawn( door )

	return true
}
#endif

//#if SERVER && R5DEV
//void function CreateDoor( vector hingeEdgeBottomPos, vector angleToGap, entity existingEnt = null )
//{
//	//
//	// Single door:
//	// ╔════════════╗
//	// ║H          S║
//	// ║H          S║
//	// ║H          S║
//	// ║H          S║
//	// ║H          S║
//	// ║H          S║
//	// ║H          S║
//	// ║╳────>     S║
//	// ╚════════════╝
//	//
//	//   ╳   = the very bottom corner of the door frame (hingeEdgeBottomPos)
//	// ────> = the direction from that corner to the bottom middle of the door frame (angleToGap)
//	//   H   = the edge of the door that has the hinges
//	//   S   = the edge of the door that swings
//	//
//	//
//	// Double door (simply two linked single doors):
//	// ╔════════════════════════╗
//	// ║H          SS          S║
//	// ║H          SS          S║
//	// ║H          SS          S║
//	// ║H          SS          S║
//	// ║H          SS          S║
//	// ║H          SS          S║
//	// ║H          SS          S║
//	// ║╳────>     SS     <────╳║
//	// ╚════════════════════════╝
//	//
//}
//#endif


bool function DoorsAreEnabled()
{
	return GetCurrentPlaylistVarBool( "survival_enable_doors", true ) // todo(dw): rename this playlist var to be non-survival specific
}


#if SERVER
void function OnDoorSpawned( entity door )
{
	//printt( "DOOR!", door.GetScriptName(), door.GetModelName(), door.GetOrigin() )

	if ( !DoorsAreEnabled() )
	{
		door.Destroy()
		return
	}

	string scriptName = door.GetScriptName()

	int doorType
	switch( scriptName )
	{
		case "survival_door_model":
			// Special legacy case for a specific door model
			// Faster to do these experiments in script than to keep changing models in leveled and recompiling
			// TODO: Should eventually delete
			bool useBlockableDoors = GetCurrentPlaylistVarBool( "survival_force_blockable_doors", true )
			bool useCodeDoors = GetCurrentPlaylistVarBool( "survival_force_code_doors", true )
			if ( useCodeDoors )
			{
				bool makeLeftDoor  = false, makeRightDoor = false
				vector leftDoorPos = <0, 0, 0>, rightDoorPos = <0, 0, 0>
				vector leftDoorAng = <0, 0, 0>, rightDoorAng = <0, 0, 0>

				switch ( door.GetModelName() )
				{
					case "mdl/door/door_104x64x8_generic_left_animated.rmdl":
						// elevator-style left
						makeLeftDoor = true
						leftDoorAng = door.GetAngles()
						leftDoorPos = door.GetOrigin() + RotateVector( <0, -59, 0>, door.GetAngles() )
						break

					case "mdl/door/door_108x60x4_generic_right_animated.rmdl":
						// brown-style right
						makeLeftDoor = true
						leftDoorAng = AnglesCompose( door.GetAngles(), <0, 180, 0> )
						leftDoorPos = door.GetOrigin() + RotateVector( <0, 57, 0>, door.GetAngles() )
						break

					case "mdl/door/door_104x64x8_generic_both_animated.rmdl":
						// elevator-style double
					case "mdl/door/door_108x60x4_generic_both_animated.rmdl":
						// brown-style double
						makeLeftDoor = true
						makeRightDoor = true
						leftDoorAng = door.GetAngles()
						leftDoorPos = door.GetOrigin() + RotateVector( <0, -59, 0>, door.GetAngles() )
						rightDoorAng = AnglesCompose( door.GetAngles(), <0, 180, 0> )
						rightDoorPos = door.GetOrigin() + RotateVector( <0, 59, 0>, door.GetAngles() )
						break
				}

				door.Destroy()
				doorType = eDoorType.CODE

				entity leftMoverDoor
				entity rightMoverDoor
				if ( makeLeftDoor )
				{
					leftMoverDoor = CreatePropDoor( $"mdl/door/canyonlands_door_single_02.rmdl", leftDoorPos, leftDoorAng )
					door = leftMoverDoor
				}

				if ( makeRightDoor )
				{
					rightMoverDoor = CreatePropDoor( $"mdl/door/canyonlands_door_single_02.rmdl", rightDoorPos, rightDoorAng )

					Assert( leftMoverDoor )
					rightMoverDoor.LinkToEnt( leftMoverDoor )
					leftMoverDoor.LinkToEnt( rightMoverDoor )
				}

				if ( leftMoverDoor )
				{
					DispatchSpawn( leftMoverDoor )
					leftMoverDoor.SetScriptName( "survival_door_code" )
				}
				if ( rightMoverDoor )
				{
					DispatchSpawn( rightMoverDoor )
					rightMoverDoor.SetScriptName( "survival_door_code" )
					OnDoorSpawned( rightMoverDoor )
				}
			}
			else if ( useBlockableDoors )
			{
				bool makeLeftDoor  = false, makeRightDoor = false
				vector leftDoorPos = <0, 0, 0>, rightDoorPos = <0, 0, 0>
				vector leftDoorAng = <0, 0, 0>, rightDoorAng = <0, 0, 0>

				switch( door.GetModelName() )
				{
					case "mdl/door/door_104x64x8_generic_left_animated.rmdl":
						// elevator-style left
						makeLeftDoor = true
						leftDoorAng = door.GetAngles()
						leftDoorPos = door.GetOrigin() + RotateVector( <0, -61.9, 0>, door.GetAngles() )
						break

					case "mdl/door/door_104x64x8_generic_both_animated.rmdl":
						// elevator-style double
						makeLeftDoor = true
						makeRightDoor = true
						leftDoorAng = AnglesCompose( door.GetAngles(), <0, 180, 0> )
						leftDoorPos = door.GetOrigin() + RotateVector( <0, 61.892, 0>, door.GetAngles() )
						rightDoorAng = AnglesCompose( door.GetAngles(), <0, 180, 0> )
						rightDoorPos = door.GetOrigin() + RotateVector( <0, -61.892, 0>, door.GetAngles() )
						break

					case "mdl/door/door_108x60x4_generic_right_animated.rmdl":
						// brown-style right
						makeRightDoor = true
						rightDoorAng = door.GetAngles()
						rightDoorPos = door.GetOrigin() + RotateVector( <0, 61.9, 0>, door.GetAngles() )
						break

					case "mdl/door/door_108x60x4_generic_both_animated.rmdl":
						// brown-style double
						makeLeftDoor = true
						makeRightDoor = true
						leftDoorAng = AnglesCompose( door.GetAngles(), <0, 180, 0> )
						leftDoorPos = door.GetOrigin() + RotateVector( <0, 61.892, 0>, door.GetAngles() )
						rightDoorAng = AnglesCompose( door.GetAngles(), <0, 180, 0> )
						rightDoorPos = door.GetOrigin() + RotateVector( <0, -61.892, 0>, door.GetAngles() )
						break
				}

				entity leftMoverDoor = null
				if ( makeLeftDoor )
				{
					leftMoverDoor = CreateDoorMoverModel( $"mdl/door/door_104x64x8_elevatorstyle01_left_static.rmdl", leftDoorPos, leftDoorAng, SOLID_VPHYSICS )
					leftMoverDoor.SetScriptName( "survival_door_blockable" )
					leftMoverDoor.e.isLeftDoor = true

					door.Destroy()
					door = leftMoverDoor
					doorType = eDoorType.BLOCKABLE
				}

				if ( makeRightDoor )
				{
					entity rightMoverDoor = CreateDoorMoverModel( $"mdl/door/door_104x64x8_elevatorstyle01_right_static.rmdl", rightDoorPos, rightDoorAng, SOLID_VPHYSICS )
					rightMoverDoor.SetScriptName( "survival_door_blockable" )
					rightMoverDoor.e.isLeftDoor = false

					if ( leftMoverDoor == null )
					{
						door.Destroy()
						door = rightMoverDoor
						doorType = eDoorType.BLOCKABLE
					}
					else
					{
						rightMoverDoor.LinkToEnt( leftMoverDoor )
						leftMoverDoor.LinkToEnt( rightMoverDoor )
						OnDoorSpawned( rightMoverDoor )
					}
				}
			}
			else
			{
				if ( GetCurrentPlaylistVarBool( "survival_force_sliding_doors", false ) )
				{
					entity ent
					if ( door.GetModelName() == "mdl/door/door_108x60x4_generic_right_animated.rmdl" )
					{
						ent = CreatePropDynamic_NoDispatchSpawn( $"mdl/door/door_104x64x8_elevatorstyle01_right_animated.rmdl", door.GetOrigin(), door.GetAngles(), 6, -1 )
					}
					else if ( door.GetModelName() == "mdl/door/door_104x64x8_generic_left_animated.rmdl" )
					{
						ent = CreatePropDynamic_NoDispatchSpawn( $"mdl/door/door_104x64x8_elevatorstyle01_right_animated.rmdl", door.GetOrigin(), AnglesCompose( door.GetAngles(), <0, 180, 0> ), 6, -1 )
					}

					if ( ent != null )
					{
						ent.SetScriptName( "survival_door_sliding" )
						door.Destroy()

						entity trig = CreateEntity( "trigger_cylinder" )
						trig.SetRadius( 30 )
						trig.SetAboveHeight( 90 )
						trig.SetBelowHeight( 0 )
						vector rgt = AnglesToRight( door.GetAngles() )
						trig.SetOrigin( door.GetOrigin() - rgt * 30 )
						trig.kv.triggerFilterNpc = "none"
						trig.kv.triggerFilterPlayer = "all"
						trig.kv.triggerFilterNonCharacter = 1
						trig.kv.triggerFilterTeamIMC = 1
						trig.kv.triggerFilterTeamMilitia = 1
						trig.kv.triggerFilterTeamBeast = 1
						trig.kv.triggerFilterTeamNeutral = 1
						trig.kv.triggerFilterTeamOther = 1
						DispatchSpawn( trig )

						ent.LinkToEnt( trig )

						DispatchSpawn( ent )
						return
					}
				}

				if ( door.GetModelName() == "mdl/door/door_108x60x4_generic_right_animated.rmdl" )
				{
					// THIS WILL CONVERT ANIMATED DOORS INTO SCRIPT_MOVER DOORS
					// ANIMATED DOORS TAKE UP 2+ ENTS, BUT SCRIPT MOVER DOORS ONLY TAKE 1 ENT
					entity moverDoor = CreateDoorMoverModel( $"mdl/door/door_108x60x4_generic_r_static.rmdl", door.GetOrigin(), door.GetAngles(), 6 )
					vector rgt       = AnglesToRight( moverDoor.GetAngles() )
					moverDoor.SetAngles( AnglesCompose( moverDoor.GetAngles(), <0, 180, 0> ) )
					moverDoor.SetOrigin( moverDoor.GetOrigin() - rgt * 60 )
					moverDoor.SetScriptName( "survival_door_model" )
					doorType = eDoorType.MOVER
					door.Destroy()
					door = moverDoor
				}
				else
				{
					doorType = eDoorType.MODEL
				}
			}

			break

		case "survival_door_plain":
			// increase use radius for large doors
			door.AddUsableValue( USABLE_USE_DISTANCE_OVERRIDE | USABLE_HORIZONTAL_FOV )
			door.SetUsableDistanceOverride( 150 ) // no point going higher without increasing context_use_entity_search_range
			doorType = eDoorType.PLAIN
			break

		case "survival_door_sliding":
			doorType = eDoorType.SLIDING
			break

		case "survival_door_blockable":
			doorType = eDoorType.BLOCKABLE
			break

		case "survival_door_code":
			doorType = eDoorType.CODE
			break
	}

	door.e.spawnAngles = door.GetAngles()

	switch( doorType )
	{
		case eDoorType.SLIDING:
		{
			SetCallback_CanUseEntityCallback( door, Survival_DoorSliding_CanUseFunction )
			AddEntityCallback_OnPostDamaged( door, SurvivalDoorSlidingPostDamage )
			thread SurvivalDoorSlidingThink( door )
			break
		}

		case eDoorType.BLOCKABLE:
		{
			OnBlockableDoorSpawned( door )
			break
		}

		case eDoorType.CODE:
		{
			// OnCodeDoorSpawned is called via AddSpawnCallback above
			//OnCodeDoorSpawned( door )
			break
		}

		default:
		{
			thread SurvivalDoorThink( door, doorType )
			break
		}
	}

	#if R5DEV
		file.allDoors[door] <- doorType
	#endif
}
#endif

#if SERVER && R5DEV
void function DEV_RestartAllDoorThinks()
{
	foreach( entity door, int doorType in file.allDoors )
	{
		if ( !IsValid( door ) )
			continue

		door.Signal( "HaltDoorThink" )

		switch( doorType )
		{
			case eDoorType.SLIDING:
			{
				thread SurvivalDoorSlidingThink( door )
				break
			}

			case eDoorType.BLOCKABLE:
			{
				OnBlockableDoorSpawned( door )
				break
			}

			default:
			{
				thread SurvivalDoorThink( door, doorType )
				break
			}
		}
	}
}
#endif

#if CLIENT
void function OnSomePropCreated( entity prop )
{
	if ( prop.GetScriptName() == "survival_door_sliding" )
		SetCallback_CanUseEntityCallback( prop, Survival_DoorSliding_CanUseFunction )

	if ( prop.GetScriptName() == "survival_door_blockable" )
		OnBlockableDoorSpawned( prop )
}

void function OnCodeDoorCreated_Client( entity door )
{
	door.SetDoDestroyCallback( true )
	file.allPropDoors.append( door )
}

void function OnCodeDoorDestroyed_Client( entity door )
{
	file.allPropDoors.fastremovebyvalue( door )
}
#endif

#if SERVER
void function DoorActivateAsRandomPlayer( entity door )
{
	array<entity> players = GetPlayerArray()
	if ( players.len() == 0 )
	{
		Warning( "%s() - unable to activate door as random player, no valid players found", FUNC_NAME() )
		return
	}

	Signal( door, "OnPlayerUse", { player = players[0] } )
}
#endif

#if SERVER
float function GetDoorTriggerRadius( entity door )
{
	float doorWidth   = GetDoorLongestWidth( door )
	float result = ((doorWidth / 2.0) + 32.0)
	return result
}
#endif

#if SERVER
vector function GetDoorBottomCenterOrg( entity door )
{
	vector doorCenter = door.GetWorldSpaceCenter()
	vector doorOrigin = door.GetOrigin()
	return < doorCenter.x, doorCenter.y, doorOrigin.z >
}
#endif

#if SERVER
float function GetDoorLongestWidth( entity door )
{
	// Get the longest side of a door on x or y
	// Note this may not be exact since some doors are placed in instances that are rotated off-center

	float doorWidth
	vector mins      = door.GetBoundingMins()
	vector maxs      = door.GetBoundingMaxs()
	float doorWidthX = maxs.x + (mins.x * -1)
	float doorWidthY = maxs.y + (mins.y * -1)
	if ( doorWidthX > doorWidthY )
		doorWidth = doorWidthX
	else
		doorWidth = doorWidthY

	return doorWidth
}
#endif

bool function IsCodeDoor( entity door )
{
	if ( door.GetNetworkedClassName() == "prop_door" )
		return true
	return false
}


#if SERVER
void function TimeoutSignal( table signalObj, float timeout )
{
	EndSignal( signalObj, "AnimTimeout" )
	wait timeout
	Signal( signalObj, "AnimTimeout" )
}
void function PlayAnimWithTimeout( entity ent, string anim, float timeout )
{
	table signalObj = {}
	EndSignal( signalObj, "AnimTimeout" )
	OnThreadEnd( function() : (signalObj) {Signal( signalObj, "AnimTimeout" )} )

	thread TimeoutSignal( signalObj, timeout )
	PlayAnim( ent, anim )
}

void function SurvivalDoorThink( entity door, int doorType )
{
	vector defaultAngles = door.GetAngles() //not used by SurvivalDoorPlainThink_Internal

	door.EndSignal( "OnDestroy" )
	#if R5DEV
		door.EndSignal( "HaltDoorThink" )
	#endif
	OnThreadEnd( function() : ( door, doorType, defaultAngles ) {
		if ( IsValid( door ) )
			door.SetAngles( defaultAngles )
	} )

	door.SetUsable()
	door.AllowMantle()
	door.SetUsePrompts( "#SURVIVAL_OPEN_DOOR", "#SURVIVAL_OPEN_DOOR" )
	door.SetUsableByGroup( "pilot" )
	door.AddUsableValue( USABLE_HORIZONTAL_FOV )

	door.e.isOpen = false
	GradeFlagsClear( door, eGradeFlags.IS_OPEN )
	float moveTime           = 0.5
	string lastOpenDirection = "" //not used by SurvivalDoorMoverThink_Internal
	vector doorIconOrigin    = door.GetWorldSpaceCenter()

	if ( doorType == eDoorType.PLAIN )
		door.SetCycle( 1.0 ) // set up as if a close animation has finished

	while ( 1 )
	{
		entity player = expect entity( door.WaitSignal( "OnPlayerUse" ).player )

			if ( !IsValid( player ) || !player.IsPlayer() ) // (dw): R5DEV-69114
				continue

		//Tell players with tracking vision that a pilot has recently distrubed the door.
		#if MP
			TrackingVision_CreatePOI( eTrackingVisionNetworkedPOITypes.DOOR_USE, door, doorIconOrigin, player.GetTeam(), player )
		#endif

		door.Signal( "DoorOperating" )

		foreach( entity linkedDoor in door.GetLinkEntArray() )
			Signal( linkedDoor, "OnPlayerUse", { player = player } ) // todo(dw): this is hacky

		door.SetUsePrompts( "", "" )

		if ( door.e.isOpen )
		{
			EmitSoundOnEntity( door, "Door_Sliding_Metal_Close" )
			door.e.isOpen = false
			GradeFlagsClear( door, eGradeFlags.IS_OPEN )

			HeatMapStat( player, "DoorClosed", door.GetOrigin() )

			if ( IsValid( player ) )
				PIN_Interact( player, "door_close" )

			if ( doorType == eDoorType.PLAIN )
			{
				door.Anim_SetSafePushMode( true )
				waitthread PlayAnimWithTimeout( door, "close", 1.3 )
			}

			if ( doorType == eDoorType.MODEL )
			{
				waitthread PlayAnim( door, "close_" + lastOpenDirection )
			}
			else if ( doorType == eDoorType.MOVER )
			{
				door.NonPhysicsRotateTo( defaultAngles, moveTime, 0, 0 )
				wait moveTime
			}
		}
		else
		{
			EmitSoundOnEntity( door, "Door_Sliding_Metal_Open" )
			door.e.isOpen = true
			GradeFlagsSet( door, eGradeFlags.IS_OPEN )
			vector doorVec = AnglesToForward( defaultAngles )

			HeatMapStat( player, "DoorOpened", door.GetOrigin() )

			if ( IsValid( player ) )
				PIN_Interact( player, "door_open" )

			if ( doorType == eDoorType.PLAIN )
			{
				float oldCycle = door.GetCycle()
				if ( oldCycle < 1.0 )
				{
					door.Anim_ChangePlaybackRate( 0.0 )
					door.Anim_SetSafePushMode( false )
					wait 0.1
				}
				PlayAnimNoWait( door, "open" )

				// approximate correspondence between open/close animations
				if ( door.GetModelName() == "mdl/door/door_canyonlands_large_01_animated.rmdl" )
					door.SetCycle( 1.0 - min( oldCycle / 0.75, 1.0 ) )
				else
					door.SetCycle( 1.0 - oldCycle )

				WaittillAnimDone( door )
			}
			else if ( doorType == eDoorType.MODEL )
			{
				float dot = DotProduct( door.GetOrigin() - player.GetOrigin(), doorVec )
				lastOpenDirection = dot > 0 ? "out" : "in"
				waitthread PlayAnim( door, "open_" + lastOpenDirection )
			}
			else if ( doorType == eDoorType.MOVER )
			{
				vector A   = door.GetOrigin() + doorVec
				vector B   = door.GetOrigin()
				vector pos = player.GetOrigin()

				A = <A.x, A.y, 0>
				B = <B.x, B.y, 0>
				pos = <pos.x, pos.y, 0>

				float dot = DotProduct( A - B, Normalize( pos - B ) )

				float dir = dot > 0 ? 1.0 : -1.0

				vector newAngles = AnglesCompose( defaultAngles, <  0, 90 * dir, 0 > )
				door.NonPhysicsRotateTo( newAngles, moveTime, 0, 0 )
				wait moveTime
			}
		}

		if ( door.e.isOpen )
			door.SetUsePrompts( "#SURVIVAL_CLOSE_DOOR", "#SURVIVAL_CLOSE_DOOR" )
		else
			door.SetUsePrompts( "#SURVIVAL_OPEN_DOOR", "#SURVIVAL_OPEN_DOOR" )
	}
}
#endif



//
// ______          _        _
// | ___ \        | |      | |                     _
// | |_/ / __ ___ | |_ ___ | |_ _   _ _ __   ___  (_)
// |  __/ '__/ _ \| __/ _ \| __| | | | '_ \ / _ \
// | |  | | | (_) | || (_) | |_| |_| | |_) |  __/  _
// \_|  |_|  \___/ \__\___/ \__|\__, | .__/ \___| (_)
//                               __/ | |
//                              |___/|_|
// ______ _            _         _     _             _           _                   _   _ _     _                      _             _                   _
// | ___ \ |          | |       | |   | |           | |         | |                 | | (_) |   | |                    (_)           (_)                 | |
// | |_/ / | ___   ___| | ____ _| |__ | | ___     __| | ___  ___| |_ _ __ _   _  ___| |_ _| |__ | | ___    _____      ___ _ __   __ _ _ _ __   __ _    __| | ___   ___  _ __ ___
// | ___ \ |/ _ \ / __| |/ / _` | '_ \| |/ _ \   / _` |/ _ \/ __| __| '__| | | |/ __| __| | '_ \| |/ _ \  / __\ \ /\ / / | '_ \ / _` | | '_ \ / _` |  / _` |/ _ \ / _ \| '__/ __|
// | |_/ / | (_) | (__|   < (_| | |_) | |  __/  | (_| |  __/\__ \ |_| |  | |_| | (__| |_| | |_) | |  __/  \__ \\ V  V /| | | | | (_| | | | | | (_| | | (_| | (_) | (_) | |  \__ \
// \____/|_|\___/ \___|_|\_\__,_|_.__/|_|\___|   \__,_|\___||___/\__|_|   \__,_|\___|\__|_|_.__/|_|\___|  |___/ \_/\_/ |_|_| |_|\__, |_|_| |_|\__, |  \__,_|\___/ \___/|_|  |___/
//                                                                                                                               __/ |         __/ |
//                                                                                                                              |___/         |___/

const float BLOCKABLE_DOOR_EXTRA_USE_DEBOUNCE = 0.21

const float BLOCKABLE_DOOR_CONSIDER_CLOSED_ANGLE = 4.0
const float BLOCKABLE_DOOR_PLAYER_HULL_DIAMETER = 32.0

const float BLOCKABLE_DOOR_TEMP_HARDCODED_DOOR_THICKNESS = 8.0
const float BLOCKABLE_DOOR_TEMP_HARDCODED_DOOR_LENGTH = 60.0
const float BLOCKABLE_DOOR_TEMP_HARDCODED_DOOR_HEIGHT = 108.0

const float BLOCKABLE_DOOR_TRACE_ANGLE_DELTA = 11.0
const float BLOCKABLE_DOOR_TRACE_EXTRA_THICKNESS = 3.8
const float BLOCKABLE_DOOR_TRACE_SWING_EDGE_INSET = 0.2
const float BLOCKABLE_DOOR_TRACE_HINGE_EDGE_INSET = 4.0//10.0
const float BLOCKABLE_DOOR_TRACE_MAX_CAPSULE_GAP = 7.0
const float BLOCKABLE_DOOR_TRACE_HEIGHT_INSET = 9.0 // both top and bottom

const asset BLOCKABLE_DOOR_MODEL = $"mdl/door/door_104x64x8_elevatorstyle01_right_animated.rmdl"
const asset BLOCKABLE_DOOR_DAMAGED_MODEL = $"mdl/door/canyonlands_door_single_02_damaged.rmdl"
const asset BLOCKABLE_DOOR_DAMAGED_FX = $"P_door_damaged"
const asset BLOCKABLE_DOOR_DESTRUCTION_FX = $"P_door_breach"

const bool BLOCKABLE_DOOR_DEBUG = false


enum eDoorFlags
{
	GOAL_IS_OPEN = (1 << 0),
	GOAL_IS_CLOCKWISE = (1 << 1),
	IS_BUSY = (1 << 2),
}

#if SERVER || CLIENT
void function BlockableDoor_Init()
{
	PrecacheModel( BLOCKABLE_DOOR_MODEL )
	PrecacheModel( BLOCKABLE_DOOR_DAMAGED_MODEL )
	PrecacheParticleSystem( BLOCKABLE_DOOR_DAMAGED_FX )
	PrecacheParticleSystem( BLOCKABLE_DOOR_DESTRUCTION_FX )
}
#endif

#if SERVER || CLIENT
void function OnBlockableDoorSpawned( entity door )
{
	#if SERVER
		door.e.spawnAngles = door.GetAngles()
		thread BlockableDoorThink( door )
	#elseif CLIENT
		SetCallback_CanUseEntityCallback( door, BlockableDoorCanUseCheck )
		AddEntityCallback_GetUseEntOverrideText( door, BlockableDoorUseTextOverride )
	#endif
}
#endif

enum eBlockableDoorNotch
{
	OPEN_ANTICLOCKWISE = -1,
	CLOSED = 0,
	OPEN_CLOCKWISE = 1
}

const table<int, vector> BLOCKABLE_DOOR_NOTCH_ROTATIONS = {
	[eBlockableDoorNotch.OPEN_ANTICLOCKWISE] = <0, 89.2, 0>,
	[eBlockableDoorNotch.CLOSED] = <0, 0, 0>,
	[eBlockableDoorNotch.OPEN_CLOCKWISE] = <0, -89.2, 0>,
}


#if SERVER
vector function GetBlockableDoorSwingingEdgeFloorPos( entity door, vector angles )
{
	vector hingeEdgeFloorPos             = door.GetOrigin()
	vector hingeEdgeToClosedSwingEdgeDir = AnglesToRight( angles ) * (door.e.isLeftDoor ? -1 : 1)
	vector closedSwingEdgeClockwiseDir   = CrossProduct( hingeEdgeToClosedSwingEdgeDir, -AnglesToUp( angles ) )
	vector swingEdgeFloorPos             = hingeEdgeFloorPos + BLOCKABLE_DOOR_TEMP_HARDCODED_DOOR_LENGTH * hingeEdgeToClosedSwingEdgeDir

	#if BLOCKABLE_DOOR_DEBUG
		DebugDrawMark( hingeEdgeFloorPos, 40, [255, 128, 0], true, 10.0 )
		DebugDrawArrow( hingeEdgeFloorPos, swingEdgeFloorPos, 8, 255, 0, 0, true, 5.0 )
		DebugDrawArrow( swingEdgeFloorPos, swingEdgeFloorPos + 25.0 * closedSwingEdgeClockwiseDir, 8, 240, 40, 128, true, 5.0 )
	#endif

	return swingEdgeFloorPos
}
#endif


#if SERVER
int function GetBlockableDoorNotchAt( entity door, vector currAngles )
{
	//vector currAngles = door.GetAngles()
	float angleDiff = AngleDiff( AnglesCompose( currAngles, AnglesInverse( door.e.spawnAngles ) ).y, 0.0 )
	bool isClosed   = fabs( angleDiff ) < BLOCKABLE_DOOR_CONSIDER_CLOSED_ANGLE

	//vector currSwingEdgeFloorPos = GetBlockableDoorSwingingEdgeFloorPos( door, currAngles )

	//bool isClosed = (Distance( currSwingEdgeFloorPos, otherSwingEdgeFloorPos ) < (BLOCKABLE_DOOR_PLAYER_HULL_DIAMETER + BLOCKABLE_DOOR_TEMP_HARDCODED_DOOR_THICKNESS))
	//printt( isClosed, Distance( currSwingEdgeFloorPos, otherSwingEdgeFloorPos ), (BLOCKABLE_DOOR_PLAYER_HULL_DIAMETER + BLOCKABLE_DOOR_TEMP_HARDCODED_DOOR_THICKNESS) )
	//if ( BLOCKABLE_DOOR_DEBUG )
	//	DebugDrawArrow( currSwingEdgeFloorPos, otherSwingEdgeFloorPos, 8, 255, 0, 0, true, 5.0 )

	if ( isClosed )
		return eBlockableDoorNotch.CLOSED
	else if ( angleDiff < 0.0 )
		return eBlockableDoorNotch.OPEN_ANTICLOCKWISE

	return eBlockableDoorNotch.OPEN_CLOCKWISE
}
#endif


#if SERVER
int function GetBlockableDoorGoal( entity door, entity operator, bool forceOpen )
{
	vector currAngles                  = door.GetAngles()
	vector hingeEdgeFloorPos           = door.GetOrigin()
	vector hingeEdgeToCurrSwingEdgeDir = CrossProduct( AnglesToForward( currAngles ), AnglesToUp( currAngles ) ) * (door.e.isLeftDoor ? 1 : -1)
	vector currSwingEdgeClockwiseDir   = CrossProduct( hingeEdgeToCurrSwingEdgeDir, -AnglesToUp( currAngles ) )
	bool isClockwise                   = (DotProduct( operator.EyePosition() - hingeEdgeFloorPos, currSwingEdgeClockwiseDir ) > 0)

	if ( !forceOpen )
	{
		int currentNotch = GetBlockableDoorNotchAt( door, door.GetAngles() )
		if ( currentNotch != eBlockableDoorNotch.CLOSED )
			return eBlockableDoorNotch.CLOSED
	}

	return isClockwise ? eBlockableDoorNotch.OPEN_ANTICLOCKWISE : eBlockableDoorNotch.OPEN_CLOCKWISE
}
#endif

#if SERVER
int function GetBlockableDoorGoalFromFlags( int flags )
{
	if ( bool(flags & eDoorFlags.GOAL_IS_OPEN) )
	{
		if ( bool(flags & eDoorFlags.GOAL_IS_CLOCKWISE) )
			return eBlockableDoorNotch.OPEN_CLOCKWISE
		else
			return eBlockableDoorNotch.OPEN_ANTICLOCKWISE
	}
	return eBlockableDoorNotch.CLOSED
}
#endif

#if SERVER
vector function GetBlockableDoorDesiredAngles( entity door, int goalNotch )
{
	return AnglesCompose( door.e.spawnAngles, BLOCKABLE_DOOR_NOTCH_ROTATIONS[goalNotch] )
}
#endif


#if SERVER
void function OnCodeDoorSpawned( entity door )
{
	door.SetMaxHealth( GetCurrentPlaylistVarInt( "blockable_door_health", 30 ) )
	door.SetHealth( door.GetMaxHealth() )
	door.SetTakeDamageType( DAMAGE_YES )
	door.SetDamageNotifications( true )
	AddEntityCallback_OnPostDamaged( door, BlockableDoor_OnDamage )
	SetObjectCanBeMeleed( door, true )
	SetVisibleEntitiesInConeQueriableEnabled( door, true )

	AddToScriptManagedEntArray( file.propDoorArrayIndex, door )

	AddCallback_OnUseEntity( door, OnCodeDoorUsed )
}

void function OnCodeDoorUsed( entity door, entity player, int useInputFlags )
{
#if MP
	TrackingVision_CreatePOI( eTrackingVisionNetworkedPOITypes.DOOR_USE, door, door.GetWorldSpaceCenter(), player.GetTeam(), player )
#endif
}

void function BlockableDoorThink( entity door )
{
	door.EndSignal( "OnDestroy" )
	#if R5DEV
		door.EndSignal( "HaltDoorThink" )
	#endif
	OnThreadEnd( function() : ( door ) {
		if ( IsValid( door ) )
		{
			door.SetAngles( door.e.spawnAngles )
			RemoveEntityCallback_OnPostDamaged( door, BlockableDoor_OnDamage )
			ClearCallback_CanUseEntityCallback( door )
		}
	} )

	door.SetPusher( true )

	door.SetMaxHealth( GetCurrentPlaylistVarInt( "blockable_door_health", 30 ) )
	door.SetHealth( door.GetMaxHealth() )
	door.SetTakeDamageType( DAMAGE_YES )
	door.SetDamageNotifications( true )
	//door.AddUsableValue( USABLE_USE_DISTANCE_OVERRIDE )
	//door.SetUsableDistanceOverride( 10.0 )
	//door.SetUsableFOVByDegrees( 90.0 )
	AddEntityCallback_OnPostDamaged( door, BlockableDoor_OnDamage )
	SetObjectCanBeMeleed( door, true )
	SetVisibleEntitiesInConeQueriableEnabled( door, true )

	door.AllowMantle()

	door.SetUsePrompts( "", "" )
	SetCallback_CanUseEntityCallback( door, BlockableDoorCanUseCheck )

	door.SetDoorFlags( 0 )

	Assert( door.GetLinkEntArray().len() <= 1, "Door is linked to more than one other door! (" + door.GetOrigin() + ")" )

	entity otherDoor = (door.GetLinkEntArray().len() > 0 ? door.GetLinkEntArray()[0] : null)

	door.e.goalAngles = door.GetAngles()

	thread DelayedSetDoorUsable( door, 0.0 )

	while ( true )
	{
		int goalNotch = GetBlockableDoorGoalFromFlags( door.GetDoorFlags() )

		int currNotch = GetBlockableDoorNotchAt( door, door.e.goalAngles )
		if ( currNotch != goalNotch || bool(door.GetDoorFlags() & eDoorFlags.IS_BUSY) )
		{
			if ( bool(door.GetDoorFlags() & eDoorFlags.IS_BUSY) )
				door.Signal( "DoorOperating" )

			thread OperateBlockableDoor( door, goalNotch, door.e.usePlayer, otherDoor, true )
		}

		thread DelayedSetDoorUsable( door, GetCurrentPlaylistVarFloat( "blockable_door_operation_duration", 0.61 ) + BLOCKABLE_DOOR_EXTRA_USE_DEBOUNCE )

		table useData = WaitSignal( door, "OnPlayerUse", "OperateLinkedDoor" )
		// time passes
		door.e.usePlayer = expect entity(useData.player)

		int newGoalNotch
		if ( useData.signal == "OnPlayerUse" )
		{
			if ( bool(door.GetDoorFlags() & eDoorFlags.IS_BUSY) )
			{
				if ( goalNotch == eBlockableDoorNotch.CLOSED )
					newGoalNotch = GetBlockableDoorGoal( door, door.e.usePlayer, true )
				else
					newGoalNotch = eBlockableDoorNotch.CLOSED
			}
			else
			{
				newGoalNotch = GetBlockableDoorGoal( door, door.e.usePlayer, false )
			}
			#if MP
				TrackingVision_CreatePOI( eTrackingVisionNetworkedPOITypes.DOOR_USE, door, door.GetWorldSpaceCenter(), door.e.usePlayer.GetTeam(), door.e.usePlayer )
			#endif

			vector soundPosition = door.GetWorldSpaceCenter()

			if ( otherDoor != null && IsValid( otherDoor ) && IsAlive( otherDoor ) )
			{
				int otherGoalNotch = -newGoalNotch
				Signal( otherDoor, "OperateLinkedDoor", { player = door.e.usePlayer, goalNotch = otherGoalNotch } )
				soundPosition = (soundPosition + otherDoor.GetWorldSpaceCenter()) / 2.0
			}
			else
			{
				otherDoor = null
			}

			#if BLOCKABLE_DOOR_DEBUG
				DebugDrawMark( soundPosition, 20, [40, 60, 93], true, 3.0 )
			#endif

			if ( newGoalNotch == eBlockableDoorNotch.CLOSED )
			{
				EmitSoundAtPosition( TEAM_UNASSIGNED, soundPosition, "Door_Single_Metal_Close_Start" )
				HeatMapStat( door.e.usePlayer, "DoorClosed", door.GetOrigin() )
			}
			else
			{
				EmitSoundAtPosition( TEAM_UNASSIGNED, soundPosition, "Door_Single_Metal_Open_Start" )
				HeatMapStat( door.e.usePlayer, "DoorOpened", door.GetOrigin() )
			}
		}
		else if ( useData.signal == "OperateLinkedDoor" )
		{
			newGoalNotch = expect int(useData.goalNotch)
		}

		if ( newGoalNotch == eBlockableDoorNotch.CLOSED )
		{
			door.RemoveDoorFlags( eDoorFlags.GOAL_IS_OPEN )
		}
		else
		{
			door.AddDoorFlags( eDoorFlags.GOAL_IS_OPEN )
			if ( newGoalNotch == eBlockableDoorNotch.OPEN_CLOCKWISE )
				door.AddDoorFlags( eDoorFlags.GOAL_IS_CLOCKWISE )
			else
				door.RemoveDoorFlags( eDoorFlags.GOAL_IS_CLOCKWISE )
		}
	}
}
#endif


#if SERVER
void function DelayedSetDoorUsable( entity door, float delay )
{
	door.EndSignal( "OnDestroy", "OnPlayerUse", "OperateLinkedDoor" )
	//door.EndSignal( "DelayedSetDoorUsable" )
	//door.Signal( "DelayedSetDoorUsable" )

	if ( delay > 0.0 )
	{
		door.UnsetUsable()
		wait delay
	}
	door.SetUsableValue( USABLE_BY_ALL | USABLE_CUSTOM_HINTS | USABLE_NO_FOV_REQUIREMENTS | USABLE_HORIZONTAL_FOV )
	door.SetUsablePriority( USABLE_PRIORITY_MEDIUM )
}
#endif


//#if SERVER
//void function WatchForOperateDoorCancel( entity door, entity otherDoor )
//{
//	door.EndSignal( "DoorIdle" )
//	//thread DelayedSetDoorUsable( door, 0.0 )
//	table useData   = WaitSignal( door, "OnPlayerUse", "OperateLinkedDoor" )
//	entity operator = expect entity(useData.player)
//	//door.e.shouldInterrupt = true
//	door.e.usePlayer = operator
//	thread DelayedSetDoorUsable( door, BLOCKABLE_DOOR_USE_DEBOUNCE )
//
//	if ( IsValid( otherDoor ) )
//	{
//		otherDoor.e.shouldInterrupt = true
//		otherDoor.e.usePlayer = operator
//		thread DelayedSetDoorUsable( otherDoor, BLOCKABLE_DOOR_USE_DEBOUNCE )
//	}
//}
//#endif


//#if SERVER
//void function AllowOperateDoorCancel( entity door, entity otherDoor )
//{
//	thread DelayedSetDoorUsable( door, 0.0 )
//
//	if ( IsValid( otherDoor ) )
//		thread DelayedSetDoorUsable( door, 0.0 )
//}
//#endif


#if SERVER || CLIENT
bool function BlockableDoorCanUseCheck( entity player, entity door )
{
	// todo(dw): move the constants out

	float doorUseRangeMax = 130.0
	float doorUseRangeMin = 30.0

	vector doorUsePos   = door.GetWorldSpaceCenter()
	vector playerToDoor = doorUsePos - player.EyePosition()

	float lookDot      = DotProduct( player.GetViewForward(), Normalize( playerToDoor ) )
	float doorUseRange = GraphCapped( lookDot, -1.0, 1.0, doorUseRangeMin, doorUseRangeMax )
	doorUseRange += GraphCapped( fabs( DotProduct( AnglesToRight( door.GetAngles() ), -playerToDoor ) ), 0.0, 1.0, 0.0, BLOCKABLE_DOOR_TEMP_HARDCODED_DOOR_LENGTH / 2.0 )

	#if BLOCKABLE_DOOR_DEBUG
		//DebugDrawLine( player.EyePosition(), doorUsePos, 200, 200, 50, true, 0.3 )
		DebugDrawTrigger( doorUsePos, doorUseRange, 200, 200, 50, 0.3, true )
	#endif

	if ( LengthSqr( playerToDoor ) > doorUseRange * doorUseRange )
		return false

	vector moveRaw = <player.GetInputAxisForward(), -player.GetInputAxisRight(), 0>
	if ( LengthSqr( moveRaw ) > 0.2 )
	{
		vector moveIntention = RotateVector( Normalize( moveRaw ), <0, player.EyeAngles().y, 0> )
		for ( int sideIndex = 0; sideIndex < 2; sideIndex++ )
		{
			vector sidePoint                  = player.EyePosition() + CrossProduct( moveIntention, AnglesToUp( player.GetAngles() ) ) * player.GetBoundingMaxs().y * (sideIndex == 0 ? -1.0 : 1.0)
			vector ornull moveIntersectOrNull = GetIntersectionOfLineAndPlane( sidePoint, sidePoint + 1000.0 * moveIntention, door.GetOrigin(), AnglesToForward( door.GetAngles() ) )
			if ( moveIntersectOrNull != null )
			{
				#if BLOCKABLE_DOOR_DEBUG
					DebugDrawArrow( sidePoint, sidePoint + 50.0 * moveIntention, 8, 0, 128, 255, true, 0.3 )
					DebugDrawMark( expect vector(moveIntersectOrNull), 40, [255, 128, 0], true, 0.3 )
				#endif

				if ( DotProduct( moveIntention, Normalize( (expect vector(moveIntersectOrNull)) - sidePoint ) ) > 0.0 )
				{
					vector localMoveIntersect       = WorldPosToLocalPos( expect vector(moveIntersectOrNull), door )
					bool doesMoveIntentionIntersect = PointIsWithinBounds( localMoveIntersect, door.GetBoundingMins(), door.GetBoundingMaxs() )
					if ( doesMoveIntentionIntersect )
						return true
				}
			}
		}
	}

	vector ornull lookIntersectOrNull = GetIntersectionOfLineAndPlane( player.EyePosition(), player.EyePosition() + 1000.0 * player.GetViewVector(), door.GetOrigin(), AnglesToForward( door.GetAngles() ) )
	if ( lookDot > 0.0 && lookIntersectOrNull != null )
	{
		//DebugDrawMark( expect vector(lookIntersectOrNull), 40, [255, 0, 128], true, 0.3 )
		vector localLookIntersect = WorldPosToLocalPos( expect vector(lookIntersectOrNull), door )
		bool doesLookIntersect    = PointIsWithinBounds( localLookIntersect, door.GetBoundingMins(), door.GetBoundingMaxs() )
		if ( doesLookIntersect )
			return true
	}

	return false
}
#endif


#if CLIENT
string function BlockableDoorUseTextOverride( entity door )
{
	//if ( ShDoors_IsDoorBusy( door ) )
	//	return "#SURVIVAL_STOP_DOOR"

	if ( ShDoors_IsDoorGoalToOpen( door ) )
		return "#SURVIVAL_CLOSE_DOOR"

	return "#SURVIVAL_OPEN_DOOR"
}
#endif


#if SERVER
void function OperateBlockableDoor( entity door, int goalNotch, entity operator, entity otherDoor, bool isOperatedDoor )
{
	door.EndSignal( "OnDestroy" )
	door.EndSignal( "DoorOperating" )
	#if R5DEV
		door.EndSignal( "HaltDoorThink" )
	#endif

	door.AddDoorFlags( eDoorFlags.IS_BUSY )

	OnThreadEnd( function() : ( door ) {
		if ( IsValid( door ) )
		{
			door.RemoveDoorFlags( eDoorFlags.IS_BUSY )
		}
	} )

	float startTime         = Time()
	float operationDuration = GetCurrentPlaylistVarFloat( "blockable_door_operation_duration", 0.61 )
	float degreesPerSecond  = 90.0 / operationDuration

	vector hingeEdgeFloorPos = door.GetOrigin()

	float capsuleThickness     = BLOCKABLE_DOOR_TEMP_HARDCODED_DOOR_THICKNESS + BLOCKABLE_DOOR_TRACE_EXTRA_THICKNESS
	vector capsuleMins         = <-capsuleThickness / 2.0, -capsuleThickness / 2.0, 0.0>
	vector capsuleMaxs         = <capsuleThickness / 2.0, capsuleThickness / 2.0, BLOCKABLE_DOOR_TEMP_HARDCODED_DOOR_HEIGHT - 2.0 * BLOCKABLE_DOOR_TRACE_HEIGHT_INSET>
	float capsuleSectionLength = BLOCKABLE_DOOR_TEMP_HARDCODED_DOOR_LENGTH - BLOCKABLE_DOOR_TRACE_SWING_EDGE_INSET - BLOCKABLE_DOOR_TRACE_HINGE_EDGE_INSET
	int numCapsules            = int(ceil( 1 + capsuleSectionLength / (capsuleThickness + BLOCKABLE_DOOR_TRACE_MAX_CAPSULE_GAP) ))
	float capsuleGap           = (capsuleSectionLength - capsuleThickness * float(numCapsules)) / (float(numCapsules) - 1)

	vector up                           = AnglesToUp( door.e.spawnAngles )
	vector startAngles                  = door.GetAngles()
	vector desiredAngles                = GetBlockableDoorDesiredAngles( door, goalNotch )
	vector localSpawnAngles             = <0, 0, 0>
	vector localStartAngles             = AnglesCompose( startAngles, AnglesInverse( door.e.spawnAngles ) )
	vector localDesiredAngles           = AnglesCompose( desiredAngles, AnglesInverse( door.e.spawnAngles ) )
	vector hingeEdgeToFinalSwingEdgeDir = CrossProduct( AnglesToForward( desiredAngles ), up ) * (door.e.isLeftDoor ? 1 : -1)

	float finalTime           = Time()
	float totalLocalYawChange = AngleDiff( localStartAngles.y, localSpawnAngles.y ) + AngleDiff( localSpawnAngles.y, localDesiredAngles.y )
	float currLocalYawChange  = 0
	bool haveDoneHitSound     = false
	for ( int stepIdx = 0; fabs( currLocalYawChange - totalLocalYawChange ) > 0.1; stepIdx++ )
	{
		vector hingeEdgeToCurrSwingEdgeDir = CrossProduct( AnglesToForward( door.e.goalAngles ), up ) * (door.e.isLeftDoor ? 1 : -1)

		float yawDelta = BLOCKABLE_DOOR_TRACE_ANGLE_DELTA
		if ( IsValid( operator ) && DotProduct( up, <0, 0, 1> ) > 0.7 )
		{
			vector currSwingEdgeClockwiseDir = CrossProduct( hingeEdgeToCurrSwingEdgeDir, -up )
			vector doorToOperatorDir         = Normalize( operator.EyePosition() - hingeEdgeFloorPos )
			bool isOperatorClockwise         = (DotProduct( doorToOperatorDir, currSwingEdgeClockwiseDir ) > 0)
			bool isMovingClockwise           = (AngleDiff( startAngles.y, desiredAngles.y ) < 0.0)
			float hackySprintSpeed           = 260.0
			float hackySprintFrac            = GraphCapped( Length( operator.GetVelocity() ), 15.0, hackySprintSpeed, 0.0, 1.0 )
			hackySprintFrac *= GraphCapped( DotProduct( operator.GetVelocity(), -doorToOperatorDir ), 0.0, 1.0, 0.0, 1.0 )
			float hackyPlayerRadius = GraphCapped( hackySprintFrac, 0.0, 1.0, operator.GetBoundingMaxs().x * 2, hackySprintSpeed )
			if ( isOperatorClockwise == isMovingClockwise )
			{
				bool isOperatorInTheWay = CircleIntersectsArc(
					operator.GetOrigin(), hackyPlayerRadius,
					hingeEdgeFloorPos, BLOCKABLE_DOOR_TEMP_HARDCODED_DOOR_LENGTH, VectorToAngles( hingeEdgeToCurrSwingEdgeDir ).y, VectorToAngles( hingeEdgeToFinalSwingEdgeDir ).y
				)
				if ( isOperatorInTheWay )
					yawDelta *= GraphCapped( Time(), startTime, startTime + operationDuration * 3.5, 0.1, 0.6 )
			}
		}
		float stepDuration = yawDelta / degreesPerSecond

		float nextLocalYawChange = signum( totalLocalYawChange ) * min( fabs( currLocalYawChange ) + yawDelta, fabs( totalLocalYawChange ) )

		vector nextLocalAngles = AnglesCompose( localStartAngles, <0, nextLocalYawChange, 0> )
		vector nextAngles      = AnglesCompose( nextLocalAngles, door.e.spawnAngles )

		vector hingeEdgeToNextSwingEdgeDir = CrossProduct( AnglesToForward( nextAngles ), up ) * (door.e.isLeftDoor ? 1 : -1)

		float capsuleOriginLengthOffset = BLOCKABLE_DOOR_TRACE_HINGE_EDGE_INSET + capsuleThickness / 2.0
		array<entity> ignoreEnts        = door.GetLinkEntArray()
		ignoreEnts.append( door )

		bool didHit = false
		entity hitEnt
		for ( int capsuleIdx = 0; capsuleIdx < numCapsules; capsuleIdx++ )
		{
			for ( int breakableThingIndex = 0; breakableThingIndex < 5; breakableThingIndex++ )
			{
				//vector capsuleCurr     = hingeEdgeFloorPos + BLOCKABLE_DOOR_TRACE_HEIGHT_INSET * up + capsuleOriginLengthOffset * hingeEdgeToCurrSwingEdgeDir
				vector capsuleDest     = hingeEdgeFloorPos + BLOCKABLE_DOOR_TRACE_HEIGHT_INSET * up + capsuleOriginLengthOffset * hingeEdgeToNextSwingEdgeDir
				vector capsuleCurr     = capsuleDest
				TraceResults collTrace = TraceHullEntsOnly(
					capsuleCurr, capsuleDest, capsuleMins, capsuleMaxs, ignoreEnts, TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_NONE, up
				)
				#if BLOCKABLE_DOOR_DEBUG
					//DebugDrawRotatedBox( capsuleCurr, capsuleMins, capsuleMaxs, VectorToAngles( -AnglesToUp( VectorToAngles( up ) ) ), 0, 255, 0, true, operationDuration / BLOCKABLE_DOOR_TRACE_STEP_COUNT + 0.08 )
					//DebugDrawRotatedBox( capsuleDest, capsuleMins, capsuleMaxs, VectorToAngles( -AnglesToUp( VectorToAngles( up ) ) ), 255, 0, 255, true, operationDuration / BLOCKABLE_DOOR_TRACE_STEP_COUNT + 0.08 )
					DebugDrawCircle( capsuleCurr, up, capsuleMins.x, 0, 255, 0, true, stepDuration + 0.08 )
					DebugDrawCircle( capsuleCurr + <0, 0, capsuleMaxs.z>, up, capsuleMins.x, 0, 255, 0, true, stepDuration + 0.08 )
					DebugDrawCircle( capsuleDest, up, capsuleMins.x, 255, 0, 255, true, stepDuration + 0.08 )
					DebugDrawCircle( capsuleDest + <0, 0, capsuleMaxs.z>, up, capsuleMins.x, 255, 0, 255, true, stepDuration + 0.08 )
				#endif

				//if ( collTrace.startSolid && IsValid( collTrace.hitEnt ) && collTrace.hitEnt.IsPlayer() )
				//{
				//	Warning( "WARNING! Player may have gotten stuck in blockable door. Please bug this with a replay (" + collTrace.hitEnt + ")." )
				//	collTrace.hitEnt.IgnoreEntityForMovementUntilNotTouching( door )
				//}

				if ( collTrace.fraction < 0.999 || collTrace.startSolid )
				{
					if ( IsValid( collTrace.hitEnt ) )
					{
						hitEnt = collTrace.hitEnt
						bool isBreakableObstruction = collTrace.hitEnt.IsPlayerDecoy()
						if ( isBreakableObstruction )
						{
							ignoreEnts.append( hitEnt )
							hitEnt.TakeDamage( 100, door, door, {} ) // kill the decoy!
							continue
						}
					}

					didHit = true
					break
				}
				capsuleOriginLengthOffset += capsuleThickness + capsuleGap
				break
			}
			if ( didHit )
				break
		}
		if ( didHit )
		{
			if ( !haveDoneHitSound && (!IsValid( operator ) || hitEnt != operator) )
			{
				haveDoneHitSound = true
				EmitSoundOnEntity( door, "Door_Single_Metal_Open_Stop" )
			}
			WaitFrame()
		}
		else
		{
			currLocalYawChange = nextLocalYawChange
			door.e.goalAngles = nextAngles
			door.NonPhysicsRotateTo( nextAngles, 1.2 * stepDuration, stepIdx == 0 ? stepDuration : 0.0, 0.0 )
			wait stepDuration
		}
	}

	if ( isOperatedDoor )
	{
		if ( goalNotch == eBlockableDoorNotch.CLOSED )
			EmitSoundOnEntity( door, "Door_Single_Metal_Close_Stop" )
		else
			EmitSoundOnEntity( door, "Door_Single_Metal_Open_Stop" )
	}
}
#endif


bool function CircleIntersectsArc(
		vector circleCenterIn, float circleRadius,
		vector arcCornerIn, float arcRadius, float arcStartAng, float arcEndAng )
{
	#if BLOCKABLE_DOOR_DEBUG
		DebugDrawCircle( circleCenterIn, <0, 0, 0>, circleRadius, 255, 255, 255, true, 0.6 )
	#endif
	bool intersect = true

	vector circleCenter = FlattenVector( circleCenterIn )
	vector arcCorner    = FlattenVector( arcCornerIn )

	//Assert( AngleDiff( arcStartAng, arcEndAng ) <= 180.0 )
	if ( AngleDiff( arcStartAng, arcEndAng ) > AngleDiff( arcEndAng, arcStartAng ) )
	{
		float temp = arcStartAng
		arcStartAng = arcEndAng
		arcEndAng = temp
	}

	vector startAngPlaneAlongDir        = AnglesToForward( <0, arcStartAng, 0> )
	vector startAngPlaneInnerDir        = -AnglesToRight( <0, arcStartAng, 0> )
	vector startAngPlaneClosestPoint    = GetClosestPointOnLine( arcCorner, arcCorner + startAngPlaneAlongDir, circleCenter )
	vector startAngPlaneCircleCenterDir = Normalize( startAngPlaneClosestPoint - circleCenter )
	float startAngPlaceCircleCenterDist = Distance2D( startAngPlaneClosestPoint, circleCenter )
	if ( DotProduct( startAngPlaneInnerDir, startAngPlaneCircleCenterDir ) < 0.0 && startAngPlaceCircleCenterDist > circleRadius )
	{
		#if BLOCKABLE_DOOR_DEBUG
			DebugDrawLine( arcCornerIn, arcCornerIn + arcRadius * startAngPlaneAlongDir, 255, 120, 180, true, 0.6 )
		#endif
		intersect = false
	}
	else
	{
		#if BLOCKABLE_DOOR_DEBUG
			DebugDrawLine( arcCornerIn, arcCornerIn + arcRadius * startAngPlaneAlongDir, 120, 255, 180, true, 0.6 )
		#endif
	}

	vector endAngPlaneAlongDir        = AnglesToForward( <0, arcEndAng, 0> )
	vector endAngPlaneInnerDir        = AnglesToRight( <0, arcEndAng, 0> )
	vector endAngPlaneClosestPoint    = GetClosestPointOnLine( arcCorner, arcCorner + endAngPlaneAlongDir, circleCenter )
	vector endAngPlaneCircleCenterDir = Normalize( endAngPlaneClosestPoint - circleCenter )
	float endAngPlaceCircleCenterDist = Distance2D( endAngPlaneClosestPoint, circleCenter )
	if ( DotProduct( endAngPlaneInnerDir, endAngPlaneCircleCenterDir ) < 0.0 && endAngPlaceCircleCenterDist > circleRadius )
	{
		#if BLOCKABLE_DOOR_DEBUG
			DebugDrawLine( arcCornerIn, arcCornerIn + arcRadius * endAngPlaneAlongDir, 255, 120, 30, true, 0.6 )
		#endif
		intersect = false
	}
	else
	{
		#if BLOCKABLE_DOOR_DEBUG
			DebugDrawLine( arcCornerIn, arcCornerIn + arcRadius * endAngPlaneAlongDir, 120, 255, 30, true, 0.6 )
		#endif
	}

	float arcCornerCircleCenterDist = Distance2D( arcCorner, circleCenter )
	if ( arcCornerCircleCenterDist > arcRadius + circleRadius )
	{
		#if BLOCKABLE_DOOR_DEBUG
			DebugDrawCircle( arcCornerIn, <0, 0, 0>, arcRadius, 255, 40, 40, true, 0.6 )
		#endif
		intersect = false
	}
	else
	{
		#if BLOCKABLE_DOOR_DEBUG
			DebugDrawCircle( arcCornerIn, <0, 0, 0>, arcRadius, 40, 255, 40, true, 0.6 )
		#endif
	}

	return intersect
}


#if SERVER
void function BlockableDoor_OnDamage( entity door, var damageInfo )
{
	entity attacker       = DamageInfo_GetAttacker( damageInfo )
	float damageInflicted = DamageInfo_GetDamage( damageInfo )
	//entity weapon      = DamageInfo_GetWeapon( damageInfo ) // This returns null for melee. See R5DEV-28611.
	entity weapon         = null
	if ( IsValid( attacker ) && attacker.IsPlayer() )
		weapon = attacker.GetActiveWeapon( eActiveInventorySlot.mainHand )

	if ( GetCurrentPlaylistVarBool( "blockable_door_can_be_hurt_by_special_kick", true ) && IsValid( weapon ) && weapon.HasMod( "proto_door_kick" ) )
	{
		int guaranteedKickCount = GetCurrentPlaylistVarInt( "blockable_door_guaranteed_kick_kill_count", 2 )
		damageInflicted = float( door.GetMaxHealth() ) / (float( guaranteedKickCount ) - 0.5)
		DamageInfo_SetDamage( damageInfo, damageInflicted )
	}
	else if ( bool(DamageInfo_GetCustomDamageType( damageInfo ) & DF_MELEE) && GetCurrentPlaylistVarBool( "blockable_door_can_be_hurt_by_melee", false ) )
	{
		int guaranteedMeleeCount = GetCurrentPlaylistVarInt( "blockable_door_guaranteed_melee_kill_count", 2 )
		damageInflicted = float( door.GetMaxHealth() ) / (float( guaranteedMeleeCount ) - 0.5)
		DamageInfo_SetDamage( damageInfo, damageInflicted )
	}
	else if ( bool(DamageInfo_GetCustomDamageType( damageInfo ) & DF_EXPLOSION) )
	{
		DamageInfo_ScaleDamage( damageInfo, GetCurrentPlaylistVarFloat( "blockable_door_explosive_damage_mutiplier", 1.0 ) )
		if ( DamageInfo_GetDamage( damageInfo ) >= door.GetHealth() && door.GetHealth() > 1 )
		{
			// delay the last point of damage one frame so that the door blocks damage to other entities
			damageInflicted = float( door.GetHealth() - 1 )
			if ( damageInflicted < 0 )
				damageInflicted = 0
			DamageInfo_SetDamage( damageInfo, damageInflicted )
			thread FinishDoorExplosiveDamage( door, damageInfo )
		}
	}
	else if (DamageInfo_GetDamageSourceIdentifier( damageInfo ) == eDamageSourceId.mp_weapon_thermite_grenade ) {
		damageInflicted = DamageInfo_GetDamage( damageInfo )
	}
	else if ( !GetCurrentPlaylistVarBool( "blockable_door_can_be_hurt_by_normal_weapons", false ) )
	{
		DamageInfo_SetDamage( damageInfo, 0 )
		return
	}

	if ( attacker.IsPlayer() && GetCurrentPlaylistVarBool( "blockable_door_show_damage_numbers", false ) )
	{
		attacker.NotifyDidDamage(
			door, DamageInfo_GetHitBox( damageInfo ),
			DamageInfo_GetDamagePosition( damageInfo ), DamageInfo_GetCustomDamageType( damageInfo ),
							100.0 * DamageInfo_GetDamage( damageInfo ) / door.GetMaxHealth(), // make the numbers % of door health
			DamageInfo_GetDamageFlags( damageInfo ), DamageInfo_GetHitGroup( damageInfo ),
			DamageInfo_GetWeapon( damageInfo ), DamageInfo_GetDistFromAttackOrigin( damageInfo )
		)
	}

	// for testing
	//damageInflicted = 1
	//DamageInfo_SetDamage( damageInfo, 1 )

	float newHealth = door.GetHealth() - damageInflicted
	if ( newHealth > 0 )
	{
		vector damageDir = DamageInfo_GetDamageForceDirection( damageInfo )
		if ( damageDir.LengthSqr() == 0 && attacker )
		{
			entity inflictor = DamageInfo_GetInflictor( damageInfo )
			damageDir = DamageInfo_GetDamagePosition( damageInfo ) - (inflictor ? inflictor : attacker).EyePosition()
		}

		vector doorAlong = -door.GetRightVector()
		vector doorPerp = door.GetForwardVector()
		vector doorUp = door.GetUpVector()
		vector effectDir
		if ( DotProduct( doorPerp, damageDir ) > 0 )
			effectDir = doorPerp
		else
			effectDir = -doorPerp

		vector doorCenter = door.GetOrigin() + 30.0 * doorAlong + 54.0 * doorUp
		#if BLOCKABLE_DOOR_DEBUG
			DebugDrawLine( doorCenter, doorCenter + effectDir * 50.0, 200, 200, 50, true, 3.0 )
		#endif

		StartParticleEffectInWorld( GetParticleSystemIndex( BLOCKABLE_DOOR_DAMAGED_FX ), doorCenter, VectorToAngles( effectDir ) )


		EmitSoundOnEntity( door, "Door_Impact_Breach" )
		EmitSoundOnEntity( door, "tone_jog_stress_3p" )
		//EmitSoundOnEntity( door, "door_stop" )
		if ( GetCurrentPlaylistVarBool( "blockable_door_regen_enabled", false ) )
			thread BlockableDoor_ThreadedRegen( door )

		if ( newHealth < door.GetMaxHealth() * 0.5 )
		{
			if ( door.GetModelName() == "mdl/door/canyonlands_door_single_02.rmdl" )
			{
				door.SetValueForModelKey( BLOCKABLE_DOOR_DAMAGED_MODEL )
				door.SetModel( BLOCKABLE_DOOR_DAMAGED_MODEL )
			}
		}
	}
	else
	{
		vector damageDir = DamageInfo_GetDamageForceDirection( damageInfo )
		if ( damageDir.LengthSqr() == 0 && attacker )
		{
			entity inflictor = DamageInfo_GetInflictor( damageInfo )
			damageDir = DamageInfo_GetDamagePosition( damageInfo ) - (inflictor ? inflictor : attacker).EyePosition()
		}

		vector doorAlong = -door.GetRightVector()
		vector doorPerp = door.GetForwardVector()
		vector doorUp = door.GetUpVector()
		vector effectDir
		if ( DotProduct( doorPerp, damageDir ) > 0 )
			effectDir = doorPerp
		else
			effectDir = -doorPerp

		vector doorCenter = door.GetOrigin() + 30.0 * doorAlong + 54.0 * doorUp
		#if BLOCKABLE_DOOR_DEBUG
			DebugDrawLine( doorCenter, doorCenter + effectDir * 50.0, 200, 200, 50, true, 3.0 )
		#endif

		StartParticleEffectInWorld( GetParticleSystemIndex( BLOCKABLE_DOOR_DESTRUCTION_FX ), doorCenter, VectorToAngles( effectDir ) )
		string destroySound
		if ( bool(DamageInfo_GetCustomDamageType( damageInfo ) & DF_MELEE) )
		{
			destroySound = "Door_Impact_Break"
		}
		else if ( bool(DamageInfo_GetCustomDamageType( damageInfo ) & DF_EXPLOSION) )
		{
			destroySound = "Survival_Door_Destroy_Frag"
		}
		else
		{
			destroySound = "Survival_Door_Destroy_Frag" // todo(dw): temp
		}
		EmitSoundAtPosition( TEAM_ANY, door.GetOrigin(), destroySound )

		#if MP
			if ( IsValid( attacker ) && attacker.IsPlayer() )
				TrackingVision_CreatePOI( eTrackingVisionNetworkedPOITypes.DOOR_DESTROYED, attacker, door.GetWorldSpaceCenter(), attacker.GetTeam(), attacker )
		#endif
	}
}

void function FinishDoorExplosiveDamage( entity door, var damageInfo )
{
	door.EndSignal( "OnDestroy" )

	entity attacker = DamageInfo_GetAttacker( damageInfo )
	entity inflictor = DamageInfo_GetInflictor( damageInfo )
	table additionalInfo =
	{
		weapon = DamageInfo_GetWeapon( damageInfo ),
		origin = DamageInfo_GetDamagePosition( damageInfo ),
		force = DamageInfo_GetDamageForceDirection( damageInfo )
		scriptType = DamageInfo_GetCustomDamageType( damageInfo )
		damageSourceId = DamageInfo_GetDamageSourceIdentifier( damageInfo )
	}

	if ( !IsValid( attacker ) || !attacker.IsPlayer() )
		attacker = null // todo(dw): workaround for R5DEV-69085, where the projectile is passed as the attacker

	WaitFrame() // note that entities like attacker and/or inflictor can become invalid during the wait, but TakeDamage should allow that

	door.TakeDamage( 1, attacker, inflictor, additionalInfo )
}
#endif


#if SERVER
void function BlockableDoor_ThreadedRegen( entity door )
{
	door.EndSignal( "OnDestroy" )
	door.Signal( "BlockableDoor_ThreadedRegen" )
	door.EndSignal( "BlockableDoor_ThreadedRegen" )

	wait GetCurrentPlaylistVarFloat( "blockable_door_regen_start_delay", 1.8 )

	float startTime         = Time()
	float startHealth       = float(door.GetHealth())
	float fullRegenDuration = GetCurrentPlaylistVarFloat( "blockable_door_regen_duration", 4.2 )
	while ( door.GetHealth() < door.GetMaxHealth() )
	{
		door.SetHealth( min( door.GetMaxHealth(), int(startHealth + (Time() - startTime) / fullRegenDuration * float(door.GetMaxHealth())) ) )

		wait 0.21

		//DebugScreenText( 0.05, 0.5, format( "%d", door.GetHealth() ) )
		//WaitFrame()
	}
}
#endif


bool function ShDoors_IsDoorGoalToOpen( entity door )
{
	if ( door.GetNetworkedClassName() != "door_mover" )
		return false // todo(dw): temporary until all doors are door_movers

	return bool(door.GetDoorFlags() & eDoorFlags.GOAL_IS_OPEN)

}


bool function ShDoors_IsDoorBusy( entity door )
{
	if ( door.GetNetworkedClassName() != "door_mover" )
		return false // todo(dw): temporary until all doors are door_movers

	return bool(door.GetDoorFlags() & eDoorFlags.IS_BUSY)
}




/*
  ____  _ _     _ _                ____            _
 / ___|| (_) __| (_)_ __   __ _   |  _ \ _ __ ___ | |_ ___
 \___ \| | |/ _` | | '_ \ / _` |  | |_) | '__/ _ \| __/ _ \
  ___) | | | (_| | | | | | (_| |  |  __/| | | (_) | || (_) |
 |____/|_|_|\__,_|_|_| |_|\__, |  |_|   |_|  \___/ \__\___/
						  |___/
*/

const float SURVIVAL_SLIDING_DOOR_USE_RANGE = 80.0
const float SURVIVAL_SLIDING_DOOR_FACING_AWAY_USE_RANGE = 30.0

const float SURVIVAL_SLIDING_DOOR_USE_RANGE_SQUARED = SURVIVAL_SLIDING_DOOR_USE_RANGE * SURVIVAL_SLIDING_DOOR_USE_RANGE
const float SURVIVAL_SLIDING_DOOR_FACING_AWAY_USE_RANGE_SQUARED = SURVIVAL_SLIDING_DOOR_FACING_AWAY_USE_RANGE * SURVIVAL_SLIDING_DOOR_FACING_AWAY_USE_RANGE

const float SURVIVAL_SLIDING_DOOR_USE_HEIGHT = 64.0
const float SURVIVAL_SLIDING_DOOR_USE_NEGATIVE_HEIGHT = 32.0
const vector SURVIVAL_SLIDING_DOOR_ORIGIN_OFFSET = <0.0, 30.0, 0.0>

const bool SURVIVAL_SLIDING_DOOR_DEBUG_DRAW = false

const float SURVIVAL_SLIDING_DOOR_WAIT_TO_OPEN_FOR_COLLSIION_TIME = 0.3
const float SURVIVAL_SLIDING_DOOR_WAIT_TO_CLOSE_FOR_COLLSIION_TIME = 0.4
const float SURVIVAL_SLIDING_DOOR_CLOSE_WAIT_TIME = 0.5
const float SURVIVAL_SLIDING_DOOR_TICK_TIME = 1.0
const float SURVIVAL_SLIDING_DOOR_TOTAL_TICKS = 3
const bool SURVIVAL_SLIDING_DOOR_OPENS_WHEN_TOUCHED = true

const string SURVIVAL_SLIDING_DOOR_TICK_SOUND = "hud_match_start_timer_tick_1p"
const string SURVIVAL_SLIDING_DOOR_INTERACT_SOUND = "og_lastimosa_wrist_computer_confirm_short_3p"
const string SURVIVAL_SLIDING_DOOR_CANCEL_SOUND = "ui_networks_invitation_canceled"
const float SURVIVAL_SLIDING_DOOR_MINIMUM_DAMAGE = 11.0
const float SURVIVAL_SLIDING_DOOR_HEALTH = SURVIVAL_SLIDING_DOOR_MINIMUM_DAMAGE
const asset SURVIVAL_SLIDING_DOOR_DESTRUCTION_FX = $"P_door_breach"

struct SlidingDoorData
{
	int  numBlockers
	bool isClosing
	bool isOpen
	bool shouldPlayInteractSound = true
}
array<SlidingDoorData> PROTO_slidingDoorData

#if SERVER || CLIENT
void function SurvivalDoorSliding_Init()
{
	PrecacheParticleSystem( SURVIVAL_SLIDING_DOOR_DESTRUCTION_FX )
}
#endif


#if SERVER
void function SurvivalDoorSliding_PlayAnimationAndResetSkin( entity doorModel, string animationName )
{
	waitthread PlayAnim( doorModel, animationName )
	doorModel.SetSkin( 0 )
}
#endif


#if SERVER
void function SurvivalDoorSlidingThink( entity doorModel )
{
	#if R5DEV
		doorModel.EndSignal( "HaltDoorThink" )
	#endif

	vector defaultAngles = doorModel.GetAngles()

	doorModel.SetUsable()
	doorModel.AllowMantle()
	doorModel.SetUsePrompts( "#SURVIVAL_OPEN_DOOR", "#SURVIVAL_OPEN_DOOR" )
	doorModel.SetUsableByGroup( "pilot" )
	doorModel.AddUsableValue( USABLE_NO_FOV_REQUIREMENTS | USABLE_HORIZONTAL_FOV )
	doorModel.SetTakeDamageType( DAMAGE_YES )
	doorModel.SetMaxHealth( SURVIVAL_SLIDING_DOOR_HEALTH )
	doorModel.SetHealth( SURVIVAL_SLIDING_DOOR_HEALTH )

	float moveTime = 0.5

	int doorDataIndex = PROTO_slidingDoorData.len()
	SlidingDoorData myData

	myData.numBlockers = 0
	myData.isClosing = false
	myData.isOpen = false

	PROTO_slidingDoorData.append( myData )

	vector doorIconOrigin        = doorModel.GetWorldSpaceCenter()
	array<entity> linkedTriggers = GetLinkedEntsByClassName( doorModel, "trigger_multiple" )

	if ( linkedTriggers.len() == 0 )
		linkedTriggers = GetLinkedEntsByClassName( doorModel, "trigger_cylinder" )

	if ( linkedTriggers.len() > 0 )
	{
		entity doorTrigger = linkedTriggers[0]

		doorTrigger.SetEnterCallback( OnPlayerEnterSlidingTrigger )
		doorTrigger.SetLeaveCallback( OnPlayerLeaveSlidingTrigger )

		thread SurvivalDoorSlidingTriggerEnterThink( doorModel, doorTrigger, doorDataIndex )
		thread SurvivalDoorSlidingTriggerLeaveThink( doorModel, doorTrigger, doorDataIndex )
	}

	while ( 1 )
	{
		entity player = expect entity( doorModel.WaitSignal( "OnPlayerUse", "TryDoorInteraction" ).player )

		doorModel.SetSkin( 1 )

		if ( player != null )
		{
			//Tell players with tracking vision that a pilot has recently distrubed the door.
			#if MP
				TrackingVision_CreatePOI( eTrackingVisionNetworkedPOITypes.DOOR_USE, doorModel, doorIconOrigin, player.GetTeam(), player )
			#endif
		}

		if ( PROTO_slidingDoorData[ doorDataIndex ].isOpen )
		{
			if ( PROTO_slidingDoorData[ doorDataIndex ].shouldPlayInteractSound == false )
				PROTO_slidingDoorData[ doorDataIndex ].shouldPlayInteractSound = true
			else
				EmitSoundOnEntity( doorModel, SURVIVAL_SLIDING_DOOR_INTERACT_SOUND )

			wait SURVIVAL_SLIDING_DOOR_CLOSE_WAIT_TIME

			float timeAttemptToClose   = Time()
			int numTicks               = 0
			bool keepTryingToCloseDoor = true
			while ( PROTO_slidingDoorData[ doorDataIndex ].numBlockers > 0 )
			{
				float deltaTime = Time() - timeAttemptToClose
				if ( deltaTime >= SURVIVAL_SLIDING_DOOR_TICK_TIME )
				{
					timeAttemptToClose = Time()
					++numTicks
					EmitSoundOnEntity( doorModel, SURVIVAL_SLIDING_DOOR_TICK_SOUND )
					if ( numTicks > SURVIVAL_SLIDING_DOOR_TOTAL_TICKS )
					{
						keepTryingToCloseDoor = false
						break
					}
				}

				WaitFrame()
			}

			if ( !keepTryingToCloseDoor )
			{
				doorModel.SetSkin( 0 )
				EmitSoundOnEntity( doorModel, SURVIVAL_SLIDING_DOOR_CANCEL_SOUND )
				continue
			}


			EmitSoundOnEntity( doorModel, "Door_Sliding_Metal_Close" )
			doorModel.SetUsePrompts( "#SURVIVAL_OPEN_DOOR", "#SURVIVAL_OPEN_DOOR" )
			doorModel.SetCollisionAllowed( true )

			HeatMapStat( player, "DoorClosed", doorModel.GetOrigin() )

			PROTO_slidingDoorData[ doorDataIndex ].numBlockers = 0
			PROTO_slidingDoorData[ doorDataIndex ].isOpen = false

			PROTO_slidingDoorData[ doorDataIndex ].isClosing = true
			thread SurvivalDoorSliding_PlayAnimationAndResetSkin( doorModel, "close" )
			wait SURVIVAL_SLIDING_DOOR_WAIT_TO_CLOSE_FOR_COLLSIION_TIME
			PROTO_slidingDoorData[ doorDataIndex ].isClosing = false
		}
		else
		{
			if ( PROTO_slidingDoorData[ doorDataIndex ].shouldPlayInteractSound == false )
				PROTO_slidingDoorData[ doorDataIndex ].shouldPlayInteractSound = true
			else
				EmitSoundOnEntity( doorModel, SURVIVAL_SLIDING_DOOR_INTERACT_SOUND )

			EmitSoundOnEntity( doorModel, "Door_Sliding_Metal_Open" )

			doorModel.SetUsePrompts( "#SURVIVAL_CLOSE_DOOR", "#SURVIVAL_CLOSE_DOOR" )

			HeatMapStat( player, "DoorOpened", doorModel.GetOrigin() )

			thread SurvivalDoorSliding_PlayAnimationAndResetSkin( doorModel, "open" )
			wait SURVIVAL_SLIDING_DOOR_WAIT_TO_OPEN_FOR_COLLSIION_TIME

			PROTO_slidingDoorData[ doorDataIndex ].isOpen = true
			doorModel.SetCollisionAllowed( false )
		}
	}
}
#endif

#if SERVER
bool function Survival_IsSlidingDoorBlocker( entity ent )
{
	if ( !ent.IsPlayer() )
	{
		if ( !ent.e.isDoorBlocker )
			return false
	}

	return true
}
#endif

#if SERVER
void function OnPlayerEnterSlidingTrigger( entity trigger, entity ent )
{
	if ( Survival_IsSlidingDoorBlocker( ent ) )
	{
		trigger.Signal( "PlayerEnteredDoorTrigger" )
	}
}
#endif

#if SERVER
void function OnPlayerLeaveSlidingTrigger( entity trigger, entity ent )
{
	if ( Survival_IsSlidingDoorBlocker( ent ) )
	{
		trigger.Signal( "PlayerLeftDoorTrigger" )
	}
}
#endif

#if SERVER
void function SurvivalDoorSlidingTriggerEnterThink( entity doorModel, entity trigger, int doorDataIndex )
{
	#if R5DEV
		doorModel.EndSignal( "HaltDoorThink" )
	#endif
	trigger.EndSignal( "OnDeath" )
	while( true )
	{
		trigger.WaitSignal( "PlayerEnteredDoorTrigger" )
		++PROTO_slidingDoorData[ doorDataIndex ].numBlockers

		if ( SURVIVAL_SLIDING_DOOR_OPENS_WHEN_TOUCHED && PROTO_slidingDoorData[ doorDataIndex ].isClosing )
		{
			PROTO_slidingDoorData[ doorDataIndex ].isOpen = true
			thread PlayAnim( doorModel, "open" )
			wait SURVIVAL_SLIDING_DOOR_WAIT_TO_OPEN_FOR_COLLSIION_TIME
			doorModel.SetCollisionAllowed( false )
			doorModel.SetUsePrompts( "#SURVIVAL_CLOSE_DOOR", "#SURVIVAL_CLOSE_DOOR" )

			wait 0.5
			PROTO_slidingDoorData[ doorDataIndex ].shouldPlayInteractSound = false
			doorModel.Signal( "TryDoorInteraction", { player = null } )
		}
	}
}
#endif

#if SERVER
void function SurvivalDoorSlidingTriggerLeaveThink( entity doorModel, entity trigger, int doorDataIndex )
{
	#if R5DEV
		doorModel.EndSignal( "HaltDoorThink" )
	#endif
	trigger.EndSignal( "OnDeath" )
	while( true )
	{
		trigger.WaitSignal( "PlayerLeftDoorTrigger" )
		--PROTO_slidingDoorData[ doorDataIndex ].numBlockers
		if ( PROTO_slidingDoorData[ doorDataIndex ].numBlockers < 0 )
			PROTO_slidingDoorData[ doorDataIndex ].numBlockers = 0
	}
}
#endif

#if SERVER
void function SurvivalDoorSlidingPostDamage( entity ent, var damageInfo )
{
	entity inflictor          = DamageInfo_GetInflictor( damageInfo )
	string inflictorClassName = inflictor.GetClassName()
	int scriptDamageType      = DamageInfo_GetCustomDamageType( damageInfo )
	float damageDealt         = DamageInfo_GetDamage( damageInfo )

	if ( (scriptDamageType & DF_EXPLOSION) == 0 || damageDealt < SURVIVAL_SLIDING_DOOR_MINIMUM_DAMAGE )
	{
		DamageInfo_SetDamage( damageInfo, 0 )
		return
	}

	entity attacker = DamageInfo_GetAttacker( damageInfo )
	if ( attacker.IsPlayer() )
	{
		attacker.NotifyDidDamage( ent, DamageInfo_GetHitBox( damageInfo ), DamageInfo_GetDamagePosition( damageInfo ), DamageInfo_GetCustomDamageType( damageInfo ), DamageInfo_GetDamage( damageInfo ), DamageInfo_GetDamageFlags( damageInfo ), DamageInfo_GetHitGroup( damageInfo ), DamageInfo_GetWeapon( damageInfo ), DamageInfo_GetDistFromAttackOrigin( damageInfo ) )
	}

	if ( ent.GetHealth() - damageDealt <= 0 )
	{
		vector damageDir = DamageInfo_GetDamageForceDirection( damageInfo )
		damageDir.z = 0.0

		vector entAngles  = ent.GetAngles()
		vector entForward = AnglesToForward( entAngles )
		entForward.z = 0.0

		if ( DotProduct( entForward, damageDir ) < 0.0 )
		{
			entAngles.x += 180.0
		}

		// DebugDrawLine( ent.GetOrigin() + <0.0, 30.0, 40.0>, ent.GetOrigin() + <0.0, 30.0, 40.0> + AnglesToForward( entAngles ) * 500.0, 200, 200, 50, true, 3.0 )
		StartParticleEffectInWorld( GetParticleSystemIndex( SURVIVAL_SLIDING_DOOR_DESTRUCTION_FX ), ent.GetOrigin() + <0.0, 30.0, 40.0>, entAngles )
	}
}
#endif

#if SERVER || CLIENT
bool function Survival_DoorSliding_CanUseFunction( entity playerUser, entity doorModel )
{
	float doorUseRangeSquared = SURVIVAL_SLIDING_DOOR_USE_RANGE_SQUARED
	float doorUseRange        = SURVIVAL_SLIDING_DOOR_USE_RANGE

	vector rotatedOffset = RotateVector( SURVIVAL_SLIDING_DOOR_ORIGIN_OFFSET, doorModel.GetAngles() )
	vector playerPos     = playerUser.GetOrigin()
	vector doorModelPos  = doorModel.GetOrigin() + rotatedOffset
	vector doorToPlayer  = playerPos - doorModelPos

	if ( doorToPlayer.z < -SURVIVAL_SLIDING_DOOR_USE_NEGATIVE_HEIGHT || doorToPlayer.z > SURVIVAL_SLIDING_DOOR_USE_HEIGHT )
		return false

	// we just want to do a cylinder check, not a sphere check, so 0 out up-axis
	doorToPlayer.z = 0.0

	// if the player is facing away from the door, reduce the range
	vector playerFacing = playerUser.GetViewForward()
	playerFacing.z = 0.0

	if ( DotProduct( playerFacing, doorToPlayer ) > 0 )
	{
		doorUseRange = SURVIVAL_SLIDING_DOOR_FACING_AWAY_USE_RANGE
		doorUseRangeSquared = SURVIVAL_SLIDING_DOOR_FACING_AWAY_USE_RANGE_SQUARED
	}

	if ( SURVIVAL_SLIDING_DOOR_DEBUG_DRAW )
	{
		DebugDrawLine( playerPos, doorModelPos, 200, 200, 50, true, 1.0 )
		DebugDrawTrigger( doorModelPos, doorUseRange, 200, 200, 50, 1.0, true )
	}

	float diffLengthSquared = LengthSqr( doorToPlayer )
	return diffLengthSquared <= doorUseRangeSquared
}
#endif


void function CodeCallback_OnDoorInteraction( entity door, entity user, entity oppositeDoor, bool opening )
{
	#if SERVER
	if ( IsValid( user ) )
	{
		string actionName = opening ? "door_open" : "door_close"
		PIN_Interact( user, actionName )
	}
	#endif
}
