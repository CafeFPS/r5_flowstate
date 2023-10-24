// #####################################################
// #######           FALLING FOREVER             #######
// #######         By @JayTheYggdrasil           #######
// #####################################################

global function InitFallingForever

global struct SimpleState {
    vector pos
    vector ang
    vector vel
}

global struct RecordingData {
    vector startPos
    vector startAng

    float restoreHeight = 999999
    SimpleState& restoreState
    var anim
}

struct FallingForeverPlayer {
    array<RecordingData> checkpoints
    array<SimpleState> history
    
    RecordingData currentRecord
    RecordingData pendingRecord

    bool started = false
    float startTime = 0
    int startCount = 0

    float minHeight = 999999
    int climbCount = 0
    bool isRecording = false
    
    bool isActive = true
    int resetCount = 0

    bool isPending = false
}

struct {
    table<entity, FallingForeverPlayer> playerFiles = {}
    bool isInitialized = false
} mapData

void function InitFallingForever() {
    if ( mapData.isInitialized )
        return

	AddCallback_OnClientConnected( InitPlayerFallingForever )

    thread LoadFallingForeverProps()

    mapData.isInitialized = true
	
	thread function() : ()
	{
		wait 5
		// Initialize Players
		foreach( entity p in GetPlayerArray() ) {
			InitPlayerFallingForever( p )
		}
	}()

}

FallingForeverPlayer function GetPlayerFile( entity player ) {
    if( !(player in mapData.playerFiles) )
        InitPlayerFallingForever( player )
    
    
    return mapData.playerFiles[player]
}

// Used to disable tracking when restoring state.
void function Deactivate( entity player ) {
    FallingForeverPlayer file = GetPlayerFile( player )
    file.resetCount += 1
    file.isActive = false
}

void function Activate( entity player ) {
    FallingForeverPlayer file = GetPlayerFile( player )
    file.isActive = true
}

void function InitPlayerFallingForever( entity player ) {
    if( !IsValidPlayer( player ) )
        return

    // Create player file
    FallingForeverPlayer file
    file.checkpoints = []
    file.history = []

    mapData.playerFiles[player] <- file
    
    // Teleport player to the map start
    player.SetOrigin( <7422, 3700, 55300> )
    player.SetAngles( <0, 90, 0> )
    player.KnockBack( <0, 0, -100>, 0.1 )

    // Player movement callbacks
    AddPlayerMovementEventCallback( player, ePlayerMovementEvents.BEGIN_WALLRUN, record_climbs )
    AddPlayerMovementEventCallback( player, ePlayerMovementEvents.BEGIN_WALLRUN, FallingForeverMapFinish )

    AddPlayerMovementEventCallback( player, ePlayerMovementEvents.END_WALLRUN, end_climb )

    AddPlayerMovementEventCallback( player, ePlayerMovementEvents.BEGIN_WALLHANG, void function ( entity player ) : () {
        thread fail(player, "Mantling is not allowed, try again")
    } )
    AddPlayerMovementEventCallback( player, ePlayerMovementEvents.TOUCH_GROUND, void function ( entity player ) : () {
        thread fail(player, "Touching the ground is not allowed, try again")
    } )

    AddButtonPressedPlayerInputCallback( player, IN_ZOOM, JustSave )
    AddButtonPressedPlayerInputCallback( player, IN_OFFHAND4, JustSave )
    AddButtonPressedPlayerInputCallback( player, IN_ATTACK, JustRestore )
    AddButtonPressedPlayerInputCallback( player, IN_USE, RemoveAndRestore )
    AddButtonPressedPlayerInputCallback( player, IN_RELOAD, RestoreToStart )

    array<ItemFlavor> characters = GetAllCharacters()
	CharacterSelect_AssignCharacter(ToEHI(player), characters[8])

	TakeAllPassives( player )
	TakeAllWeapons( player )
	player.GiveWeapon("mp_weapon_melee_survival", WEAPON_INVENTORY_SLOT_PRIMARY_2, [])
	player.GiveOffhandWeapon("melee_pilot_emptyhanded", OFFHAND_MELEE, [])
	player.SetPlayerNetBool("pingEnabled", false)

    // Track player movements
    thread TrackPlayerFallingForever( player )
}

void function TrackPlayerFallingForever( entity player ) {
    FallingForeverPlayer file = GetPlayerFile( player )

    while( IsValidPlayer( player ) ) {
        vector pos = player.GetOrigin()

        // Track the players minimum height.
        if(pos.z < file.minHeight || player.IsOnGround()) {
            file.minHeight = pos.z
        }

        // Keep track of the history
        // This is needed for selecting a sensible checkpoint.
        if(file.isRecording && file.isActive && !player.IsWallRunning() && !player.IsOnGround() && !player.IsWallHanging()) {
            
            SimpleState state
            state.pos = pos
            state.vel = player.GetVelocity()
            
            vector ang = player.EyeAngles()

            state.ang = <0, ang.y, ang.z>

            file.history.append( state )
        }

        // Timer things
        FallingForeverMapStart( player ) // Starts timer as needed

        float seconds = 0
        if( file.started ) {
            seconds = Time() - file.startTime
        }

        Remote_CallFunction_NonReplay( player, "ServerCallback_SetTimer", seconds )

        
        WaitFrame() // 0.1s on server
    }
}

void function end_climb( entity player ) {
    FallingForeverPlayer file = GetPlayerFile( player )

    if ( file.isActive ) {
        file.minHeight = file.minHeight - 273 // Bonus penalty for ending a climb
    }

    CheckUncontrolled( player )
    
    thread function () : ( player ) {
        WaitFrame()
        if ( player.IsOnGround() ) {
            thread fail(player, "Touching the ground is not allowed\nTry again")
        }
    }()
}

// Failes player after a certain period of falling in an uncontrolled maner.
void function CheckUncontrolled( entity player ) {
    FallingForeverPlayer file = GetPlayerFile( player )

    int thisClimb = file.climbCount
    int thisReset = file.resetCount
    int thisStart = file.startCount

    thread function () : ( thisClimb, thisReset, thisStart, player ) {
        wait 2.5

        // In order to fail, we must be on the same climb, and not have reset yet.
        FallingForeverPlayer file = GetPlayerFile( player )
        if( thisClimb == file.climbCount && thisReset == file.resetCount && file.isActive && file.startCount == thisStart ) {
            thread fail( player, "Falling a bit too quick are we?" )
        }
    }()
}

void function EnableCheckpointAvailability( entity player ) {
    FallingForeverPlayer file = GetPlayerFile( player )

    // Skip if we haven't started
    if( !file.started ) 
        return

    player.TakeOffhandWeapon(OFFHAND_ULTIMATE)
    player.GiveOffhandWeapon("mp_ability_phase_walk", OFFHAND_ULTIMATE)
}

void function DisableCheckpointAvailability( entity player ) {
    player.TakeOffhandWeapon(OFFHAND_ULTIMATE)
}

void function record_climbs( entity player ) {
    FallingForeverPlayer file = GetPlayerFile( player )

    // Only stop recording if we've been in the air for at least a second
    if(file.history.len() >= 10)
        StopRecording( player )

    file.history.clear()
    StartRecording( player )

    file.climbCount += 1
}

void function fail( entity player, string message ) {
    FallingForeverPlayer file = GetPlayerFile( player )

	// Get the current state
    bool onGround = player.IsOnGround()
	bool isClimbing = player.IsWallRunning()

	// Wait 0.1s to see how it evolves
    WaitFrame()

	// The "grounded" state is funky.
    // Skip if "grounded" or climbing but still falling
    if ( ( isClimbing || onGround ) && player.GetVelocity().z < 0 )
        return

    // Skip if we haven't started
    if ( !file.started )
        return

    if ( player.IsOnGround() && file.isActive ) {
        file.minHeight = 999999
    }

    if ( file.checkpoints.len() == 0 ) {
        Message( player, message, "", 1 )
        RestoreToStart( player )
    } else {
        RestoreCheckpoint( player, file.checkpoints[file.checkpoints.len() - 1], message )
    }
}

void function StartRecording( entity player ) {
    FallingForeverPlayer file = GetPlayerFile( player )
    if( file.isRecording || !file.started )
        return
    
    file.isRecording = true
    vector initialpos = player.GetOrigin()
    vector initialang = player.GetAngles()
    player.StartRecordingAnimation( initialpos, initialang )

    file.currentRecord.startPos = initialpos
    file.currentRecord.startAng = initialang
}

void function StopRecording( entity player ) {
    FallingForeverPlayer file = GetPlayerFile( player )
    if( !file.isRecording )
        return

    // Does this make sense as a potential checkpoint?
    if( !player.IsWallRunning() || !( file.history.len() >= 5 )) {
        player.StopRecordingAnimation()
        file.isRecording = false
        return
    }

    
    file.pendingRecord.startPos = file.currentRecord.startPos
    file.pendingRecord.startAng = file.currentRecord.startAng

    file.pendingRecord.restoreState = file.history[file.history.len() - 5]
    file.pendingRecord.restoreHeight = file.minHeight

    file.pendingRecord.anim = player.StopRecordingAnimation()

	printl( "Recording:" )
    printt( file.pendingRecord.anim )

    file.isRecording = false

    file.history.clear()
    file.isPending = true

    EnableCheckpointAvailability( player )

    // Autosave Checkpoint
    JustSave( player )
}

void function printCheckpoints( entity player ) {
    FallingForeverPlayer file = GetPlayerFile( player )
    foreach(int index, RecordingData cpData in file.checkpoints) {
        printl( "Index: " + index + " --  height: " + cpData.startPos.z )
    }
}

void function RestoreCheckpoint( entity player, RecordingData animData, string message ) {
    FallingForeverPlayer file = GetPlayerFile( player )

    if( !file.isActive )
        return

    file.isPending = false
    DisableCheckpointAvailability( player )

    Deactivate( player )

    StopRecording( player )

    vector pos = animData.startPos
    vector ang = animData.startAng
    var anim = animData.anim

    float animDuration = GetRecordedAnimationDuration( anim )

    Message( player, message, "", animDuration + 1 )

    // Set third person settings
    player.SetTrackEntityDistanceMode("scriptOffset")
    player.SetTrackEntityShouldViewAnglesFollowTrackedEntity(true)
    player.SetTrackEntityOffsetDistance(150)
    player.SetTrackEntityLookaheadMaxAngle(90)
    player.SetTrackEntityLookaheadLerpAheadRate(10)
    player.SetTrackEntityMinYaw(-180)
    player.SetTrackEntityMaxYaw(180)
    player.SetTrackEntityMinPitch(-90)
    player.SetTrackEntityMaxPitch(90)
    player.SetTrackEntityOffsetHeight( player.EyePosition().z - player.GetOrigin().z )

    // Have them start watching a dummy
    asset playermodel = player.GetModelName()
    entity dummy = CreatePropDynamic( playermodel, pos, ang, SOLID_BBOX, 99999 )

    dummy.PlayRecordedAnimation( anim, pos, ang, 0 )
    dummy.SetRecordedAnimationPlaybackRate( 0 )

    player.SetAngles( ang ) // Set angle so they are facing the right direction.
    player.SetTrackEntity(dummy)

    // Meanwhile, teleport the player to the top of the map, to reset their max climb height.
    player.SetOrigin( <7422, 3817, 55300> )
    player.KnockBack( <0, 0, -100>, 0.1 )

    wait 0.75 // Small wait to allow player to gain bairings in spectator
    dummy.SetRecordedAnimationPlaybackRate( 1 )

    wait ( animDuration - 1.5 )

    // "Countdown" to regaining control
    player.SetTrackEntityOffsetDistance(100)
    wait 0.3
    player.SetTrackEntityOffsetDistance(50)
    wait 0.3
    player.SetTrackEntityOffsetDistance(20)
    wait 0.3
    player.SetTrackEntityOffsetDistance(0)

    // Set player max climb height
    player.KnockBack( <0, 0, 1000>, 0.1 )
    player.SetOrigin( <7422, 3817, animData.restoreHeight> )

    WaitFrame()

    // Remove third person
    player.SetTrackEntity( player )
    dummy.Destroy()
    player.SetTrackEntity( null )

    // Set full final restore state
    player.SetOrigin( animData.restoreState.pos )
    player.KnockBack( animData.restoreState.vel, 0.1 )
    file.minHeight = animData.restoreHeight

    Activate( player )

    CheckUncontrolled( player )
}

void function JustSave( entity player ) {
    FallingForeverPlayer file = GetPlayerFile( player )
    if( file.isPending && file.started && file.isActive ) {
        RecordingData pr = file.pendingRecord

        RecordingData record
        record.startPos = file.pendingRecord.startPos
        record.startAng = file.pendingRecord.startAng

        record.restoreHeight = file.pendingRecord.restoreHeight
        record.restoreState = file.pendingRecord.restoreState
        record.anim = file.pendingRecord.anim

        file.checkpoints.append( record )
        file.isPending = false
        DisableCheckpointAvailability( player )
        Message( player, "Checkpoint Set", "", 1 )
    }

    // printCheckpoints( player )
}

void function RestoreToStart( entity player ) {
    FallingForeverPlayer file = GetPlayerFile( player )
    if(!file.isActive)
        return

    StopRecording( player )
    file.isPending = false
    DisableCheckpointAvailability( player )
    file.minHeight = 999999
    file.history.clear()
    file.resetCount = 0

    file.started = false

    file.checkpoints.clear()

    player.SetOrigin( <7422, 3700, 55300> )
    player.SetAngles( <0, 90, 0> )
    player.KnockBack( <0, 0, -100>, 0.1 )
}

void function RemoveAndRestore( entity player ) {
    FallingForeverPlayer file = GetPlayerFile( player )
    if(!file.isActive)
        return

    if ( file.checkpoints.len() <= 1 ) {
        if( file.checkpoints.len() == 1 )
            file.checkpoints.remove( 0 )

        Message( player, "Forgetting this checkpoint\nRestored to start", "", 1 )
        RestoreToStart( player )
    } else {
        file.checkpoints.remove( file.checkpoints.len() - 1 ) // Remove the last checkpoint
        thread RestoreCheckpoint( player, file.checkpoints[file.checkpoints.len() - 1], "Forgetting this checkpoint\nRestoring to previous checkpoint." )
    }

    // printCheckpoints( player )
}

void function JustRestore( entity player ) {
    FallingForeverPlayer file = GetPlayerFile( player )
    if(!file.isActive)
        return

    if ( file.checkpoints.len() == 0 ) {
        Message( player, "Restored to start", "", 1 )
        RestoreToStart( player )
    } else {
        thread RestoreCheckpoint( player, file.checkpoints[file.checkpoints.len() - 1], "Restoring to last saved checkpoint." )
    }
}

void function FallingForeverMapFinish( entity player ) {
    FallingForeverPlayer file = GetPlayerFile( player )

    vector origin = player.GetOrigin()

    bool boundsX = 6650 < origin.x && origin.x < 8150
    bool boundsY = 7600 < origin.y && origin.y < 7800
    bool boundsZ = 41419 < origin.z && origin.z < 42180

    if ( boundsX && boundsY && boundsZ && file.started ) {
        string timeMessage = "NAN"

        float currentTime = Time() - file.startTime
        if ( currentTime < 60 ) {
            timeMessage = format("%0.1f s", currentTime )
        } else {
            int minutes = int( currentTime / 60 )
            float seconds = currentTime - 60 * minutes
            timeMessage = format("%d m %0.1f s", minutes, seconds )
        }

        Message( player, format("Time: %s\nResets %d.", timeMessage, file.resetCount), "", 5 )

        file.started = false
    }
}

void function FallingForeverMapStart( entity player ) {
    FallingForeverPlayer file = GetPlayerFile( player )

    vector pos = player.GetOrigin()

    if ( pos.y > 4050 && pos.z > 55000 && !file.started ) {
        file.startTime = Time()
        file.started = true
        file.startCount += 1
        Message( player, "Timer Started", "", 1 )
        CheckUncontrolled( player )
    }
}

void function test() {
    entity player = GetPlayerArray()[0]
    FallingForeverPlayer file = GetPlayerFile( player )
    if( !file.isPending )
        return

    RestoreCheckpoint( player, file.pendingRecord, "Restoring to Checkpoint" )

    // if (file.minHeight > 100000)
    //     return

    // entity player = GetPlayerArray()[0]

    // vector pos = player.GetOrigin()
    // player.SetOrigin(<pos.x, pos.y, file.minHeight>)
}

void function LoadFallingForeverProps() {
    CreateEditorProp( $"mdl/levels_terrain/mp_rr_desertlands/desertlands_z12_mid_platform_01.rmdl",<7423.94,3839.25,55295.3>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/industrial_crane_yellow_donut_01.rmdl",<7424.13,3775.13,55551.5>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_wedge.rmdl",<7551.17,3647.55,55295.7>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_wedge.rmdl",<7679.19,3648.15,55295.4>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_wedge.rmdl",<7680.26,3647.22,55295.4>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_wedge.rmdl",<7423.51,3647.86,55295.1>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_wedge.rmdl",<7295.35,3647.51,55295.4>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_wedge.rmdl",<7167.98,3712.13,55295>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_wedge.rmdl",<7168.23,3648.8,55295.4>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_wedge.rmdl",<7167.14,3647.58,55295.7>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_wedge.rmdl",<7167.6,3840.64,55295.3>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_wedge.rmdl",<7167.51,3968.7,55295.5>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_wedge.rmdl",<7680.53,3711.19,55295.7>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_wedge.rmdl",<7680.15,3839.11,55295.6>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_wedge.rmdl",<7680.37,3967.12,55295.7>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl",<7744.94,3904.04,55265.7>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl",<7744.88,3776.2,55265.6>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl",<7615.88,3583.07,55265.6>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl",<7488.16,3583.06,55265.7>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl",<7359.95,3583.03,55265.8>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl",<7231.86,3583.03,55265.8>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl",<7103.11,3775.73,55265.6>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/desertlands_city_slanted_building_01_wall_corner_Lshape_end.rmdl",<7103.05,3903.92,55265.7>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7488.55,4159.95,55265.2>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7488.89,4287.8,55265.6>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7488.91,4415.97,55265.6>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7488.9,4543.91,55265.6>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7487.01,4672.11,55266>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7487.01,4799.87,55266>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7360.98,4159.8,55265.9>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7360.96,4287.73,55265.9>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7360.98,4415.86,55265.8>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7360.98,4543.94,55265.8>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7360.98,4671.94,55265.8>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7360.98,4799.93,55265.8>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7424.05,4480.91,55393.6>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl",<7423.91,4352.54,55585.2>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7423.93,4927.01,54783.9>,<0,0,35>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x128_03.rmdl",<7360.46,5184.28,54527.2>,<0,120,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x128_03.rmdl",<7360.73,5184.67,54656.1>,<0,120,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x128_03.rmdl",<7360.91,5184.39,54784.1>,<0,120,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x128_03.rmdl",<7487.6,5184.72,54783.4>,<0,-120,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x128_03.rmdl",<7487.73,5184.88,54655.6>,<0,-120,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_256x128_03.rmdl",<7487.48,5184.68,54527.5>,<0,-120,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7551.23,5376.19,54399.4>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7551.17,5504.08,54399.4>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7487.3,5631.95,54271.3>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7423.37,5888.13,54079.2>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7361,5631.97,54272>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7296.99,5503.87,54399.9>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7296.98,5376.19,54399.9>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7360.96,5760,54207.7>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7487.09,5759.96,54207.6>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7423.22,6015.91,54015.4>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/desertlands_large_liquid_tank_01.rmdl",<7743.93,6079.48,53375.1>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/desertlands_large_liquid_tank_01.rmdl",<7104.17,6079.37,53375.2>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl",<7808.84,6720.21,53119.5>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl",<7808.94,6720.33,53248>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl",<7808.88,6720.43,53375.8>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl",<7808.85,6720.53,52992>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl",<7808.82,6720.41,52863.6>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl",<7808.9,6720.43,53503.9>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl",<7808.97,6720.25,52736.1>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl",<7040.85,6720.52,52735.9>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl",<7040.8,6720.52,52863.7>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl",<7040.85,6720.47,52992.2>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl",<7040.8,6720.57,53119.8>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl",<7040.75,6720.49,53248.4>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl",<7040.8,6720.58,53376.1>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl",<7040.74,6720.41,53504.5>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl",<7808.89,6720.22,53631.6>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl",<7808.96,6720.26,53760>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl",<7808.92,6720.36,53887.8>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl",<7040.72,6720.4,53631.4>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl",<7040.87,6720.49,53760>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl",<7040.73,6720.41,53888.5>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/desertlands_city_slanted_building_01_slice_01.rmdl",<7808.66,7296.29,51154.7>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/desertlands_city_slanted_building_01_slice_01.rmdl",<7808.62,7296.36,50962.7>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/desertlands_city_slanted_building_01_slice_01.rmdl",<7808.73,7296.14,50770.7>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/desertlands_city_slanted_building_01_slice_01.rmdl",<7808.95,7296.08,50578.3>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/desertlands_city_slanted_building_01_slice_01.rmdl",<7808.86,7295.98,51346.5>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/desertlands_city_slanted_building_01_slice_01.rmdl",<7808.95,7296.07,51538.3>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/desertlands_city_slanted_building_01_slice_01.rmdl",<7808.76,7296.01,51730.6>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/desertlands_city_slanted_building_01_slice_01.rmdl",<7808.96,7296.11,51922.3>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/desertlands_city_slanted_building_01_slice_01.rmdl",<7808.79,7295.95,52114.6>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/desertlands_city_slanted_building_01_slice_01.rmdl",<7808.85,7296.18,52306.5>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/desertlands_city_slanted_building_01_slice_01.rmdl",<7808.96,7296.01,52498.3>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/desertlands_city_slanted_building_01_slice_01.rmdl",<7039,6783.98,50770>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/desertlands_city_slanted_building_01_slice_01.rmdl",<7039.02,6784.01,50962.2>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/desertlands_city_slanted_building_01_slice_01.rmdl",<7039.15,6784.01,51154.5>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/desertlands_city_slanted_building_01_slice_01.rmdl",<7039.02,6783.84,51346.1>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/desertlands_city_slanted_building_01_slice_01.rmdl",<7039.1,6783.83,51538.4>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/desertlands_city_slanted_building_01_slice_01.rmdl",<7039.13,6783.76,51730.4>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/desertlands_city_slanted_building_01_slice_01.rmdl",<7039.17,6783.73,51922.5>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/desertlands_city_slanted_building_01_slice_01.rmdl",<7039.23,6784.05,52114.6>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/desertlands_city_slanted_building_01_slice_01.rmdl",<7039.17,6783.82,52306.5>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/desertlands_city_slanted_building_01_slice_01.rmdl",<7039.07,6783.68,52498.2>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/ola/sewer_grate_02.rmdl",<7167.68,6784.92,51857.8>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/ola/sewer_grate_02.rmdl",<7167.58,6912.88,51857.8>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/ola/sewer_grate_02.rmdl",<7167.63,7040.92,51857.9>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/ola/sewer_grate_02.rmdl",<7680.01,6784.99,51857.9>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/ola/sewer_grate_02.rmdl",<7680.32,6912.95,51858>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/ola/sewer_grate_02.rmdl",<7680.21,7040.98,51858>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/ola/sewer_grate_02.rmdl",<7167.99,7295.15,51217.5>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/ola/sewer_grate_02.rmdl",<7168,7167.07,51217.6>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/ola/sewer_grate_02.rmdl",<7167.6,7039.14,51217.7>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/ola/sewer_grate_02.rmdl",<7680.16,7295.03,51217.8>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/ola/sewer_grate_02.rmdl",<7680.09,7167.01,51217.9>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/ola/sewer_grate_02.rmdl",<7680.05,7039,51217.9>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/ola/sewer_grate_02.rmdl",<7783.01,6752.08,51858.1>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/ola/sewer_grate_02.rmdl",<7064.79,6752.61,51861.9>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/desertlands_city_slanted_building_01_slice_01.rmdl",<7039.02,6784.2,50578>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl",<7168,6784,50578>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl",<7168,7040,50578>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl",<7168,7296,50578>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl",<7680,6784,50578>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl",<7680,7040,50578>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl",<7680,7296,50578>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl",<7040,7168,52686>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl",<7040,6912,52686>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl",<7808,7168,52686>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl",<7808,6912,52686>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7551.53,7296.87,49536.1>,<0,180,30>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7423.89,7296.99,49536.1>,<0,180,30>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7296.03,7296.99,49536.1>,<0,180,30>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7423.92,7296.99,49171.9>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7551.92,7296.99,49171.9>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7295.96,7296.99,49171.9>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/levels_terrain/mp_rr_desertlands/desertlands_z12_mid_platform_01.rmdl",<7423.15,6912.31,49555.6>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/pipes/slum_pipe_large_blue_512_01.rmdl",<7169,6912,48020>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/pipes/slum_pipe_large_blue_512_01.rmdl",<7168.69,6912.26,48531.3>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/pipes/slum_pipe_large_blue_512_01.rmdl",<7168.6,6912.38,49043.3>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/pipes/slum_pipe_large_blue_512_01.rmdl",<7679.48,6912.03,48019.1>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/pipes/slum_pipe_large_blue_512_01.rmdl",<7679.12,6912.46,48531.9>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/pipes/slum_pipe_large_blue_512_01.rmdl",<7679.06,6911.78,49043.7>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/pipes/slum_pipe_large_blue_512_01.rmdl",<7424.52,6528.39,48019.2>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/pipes/slum_pipe_large_blue_512_01.rmdl",<7424.95,6528.31,48531.9>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/pipes/slum_pipe_large_blue_512_01.rmdl",<7424.75,6528.46,49043.5>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/pipes/slum_pipe_large_blue_512_01.rmdl",<7552.53,6144.7,48019.5>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/pipes/slum_pipe_large_blue_512_01.rmdl",<7296.16,6144.77,48019.4>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/pipes/slum_pipe_large_blue_512_01.rmdl",<7295.44,6144.83,48532>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/pipes/slum_pipe_large_blue_512_01.rmdl",<7552.52,6144.84,48531.9>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/pipes/slum_pipe_large_blue_512_01.rmdl",<7552.23,6144.45,49044.9>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/pipes/slum_pipe_large_blue_512_01.rmdl",<7295.89,6144.62,49044.8>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/levels_terrain/mp_rr_desertlands/desertlands_z12_mid_platform_01.rmdl",<7808.81,6912.15,49555.4>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/levels_terrain/mp_rr_desertlands/desertlands_z12_mid_platform_01.rmdl",<7040.7,6911.99,49555.3>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/levels_terrain/mp_rr_desertlands/desertlands_z12_mid_platform_01.rmdl",<7168.83,6400.24,49555.5>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/levels_terrain/mp_rr_desertlands/desertlands_z12_mid_platform_01.rmdl",<7679.02,6400.08,49555.8>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/levels_terrain/mp_rr_desertlands/desertlands_z12_mid_platform_01.rmdl",<7424.83,6400.35,49555.6>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/levels_terrain/mp_rr_desertlands/desertlands_z12_mid_platform_01.rmdl",<7424.57,5888.31,49555.2>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7423.76,7424.75,49761.4>,<0,180,30>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7551.83,7424.86,49761.5>,<0,180,30>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7295.95,7424.88,49761.5>,<0,180,30>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl",<7296.94,7551.97,50057.7>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl",<7552.99,7552.03,50057.9>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/levels_terrain/mp_rr_desertlands/desertlands_z12_mid_platform_01.rmdl",<-22264.4,752.398,-27036.8>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl",<-21991,699.922,-26990>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl",<-22188,916.998,-26985.9>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl",<-22393,736.094,-26985.9>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl",<-22248.3,523.04,-26990>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl",<-22159.7,732.122,-27127>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl",<7295.9,5760.99,47909.9>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl",<7295.61,5760.88,48038.3>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl",<7295.98,5760.94,47782.3>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl",<7295.49,5760.8,47654.3>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl",<7552.4,5759.14,47653.7>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl",<7552.28,5759.05,47782.2>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl",<7552.23,5759.04,47910.2>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl",<7552.43,5759.1,48038>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl",<7552.43,5759.11,48166.2>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl",<7295.49,5760.86,48166.1>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl",<7295.6,5760.92,48293.9>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl",<7552.24,5759.03,48293.9>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl",<7871.17,5823.93,47653.4>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl",<7871.14,5823.49,47782>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl",<7871.17,5823.58,47909.6>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl",<7871.12,5823.58,48038.2>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl",<7871.34,5823.7,48166.7>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl",<7871.25,5823.52,48294.5>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl",<6976.48,5696.37,47654.8>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl",<6976.83,5696.54,47781.9>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl",<6976.74,5696.57,47910.3>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl",<6976.73,5696.6,48037.7>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl",<6976.75,5696.65,48166.1>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl",<6976.64,5696.62,48294.5>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl",<7552.28,5439.04,47522>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl",<7552.37,5439.24,47394.5>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl",<7552.41,5439.09,47266>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl",<7295.62,5440.92,47522.1>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl",<7295.51,5440.87,47393.9>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/industrial_cargo_container_large_01.rmdl",<7295.45,5440.84,47266>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7359.7,5504.86,47457.6>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7488.22,5504.9,47457.6>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7487.85,5248.9,47074.4>,<0,180,30>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7360.11,5248.98,47074.2>,<0,180,30>, true, 8000) 
    CreateEditorProp( $"mdl/pipes/slum_pipe_large_blue_512_01.rmdl",<7423.08,5056.39,46690>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/pipes/slum_pipe_large_blue_512_01.rmdl",<7423.43,5056.82,47202>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/pipes/slum_pipe_large_yellow_256_01.rmdl",<7423.16,5055.51,46434.2>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/highrise_square_shell_box_128_c.rmdl",<7551.07,5439.73,46562.3>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/highrise_square_shell_box_128_c.rmdl",<7551.02,5311.94,46562.2>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/highrise_square_shell_box_128_c.rmdl",<7487.54,5503.13,46562.2>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/highrise_square_shell_box_128_c.rmdl",<7487.89,5503.23,46306.6>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/highrise_square_shell_box_128_c.rmdl",<7487.83,5503.3,46050.7>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/highrise_square_shell_box_128_c.rmdl",<7488.32,5503.06,45794.1>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/highrise_square_shell_box_128_c.rmdl",<7360.18,5503.03,45794.1>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/highrise_square_shell_box_128_c.rmdl",<7360.23,5503.03,46049.9>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/highrise_square_shell_box_128_c.rmdl",<7360.21,5503.02,46306>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/highrise_square_shell_box_128_c.rmdl",<7359.94,5503,46561.9>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/highrise_square_shell_box_128_c.rmdl",<7296.67,5440.28,46562.7>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/highrise_square_shell_box_128_c.rmdl",<7359.58,5248.83,46561.6>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/highrise_square_shell_box_128_c.rmdl",<7487.84,5248.9,46561.6>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/highrise_square_shell_box_128_c.rmdl",<7360.13,5248.99,46306>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/highrise_square_shell_box_128_c.rmdl",<7488.12,5248.99,46306>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/highrise_square_shell_box_128_c.rmdl",<7359.86,5248.91,46049.6>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/highrise_square_shell_box_128_c.rmdl",<7487.56,5248.9,46049.9>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/highrise_square_shell_box_128_c.rmdl",<7359.91,5248.99,45794.1>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/highrise_square_shell_box_128_c.rmdl",<7487.77,5248.97,45794.1>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/highrise_square_shell_box_128_c.rmdl",<7359.7,5503.05,45537.9>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/highrise_square_shell_box_128_c.rmdl",<7487.8,5503.03,45537.9>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/highrise_square_shell_box_128_c.rmdl",<7360.08,5503.09,45282.4>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/highrise_square_shell_box_128_c.rmdl",<7487.95,5503.09,45282.4>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/highrise_square_shell_box_128_c.rmdl",<7359.68,5248.86,45538.4>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/highrise_square_shell_box_128_c.rmdl",<7488.15,5248.91,45538.4>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/highrise_square_shell_box_128_c.rmdl",<7360.19,5503.08,45025.7>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/highrise_square_shell_box_128_c.rmdl",<7488.1,5503.07,45025.6>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/colony/ventilation_unit_01_black.rmdl",<7488.04,5311.51,46497.1>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/colony/ventilation_unit_01_black.rmdl",<7424.08,5311.54,46497.1>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/colony/ventilation_unit_01_black.rmdl",<7359.88,5311.54,46497.1>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/colony/ventilation_unit_01_black.rmdl",<7360.03,5440.75,46113.3>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/colony/ventilation_unit_01_black.rmdl",<7424.06,5440.75,46113.3>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/colony/ventilation_unit_01_black.rmdl",<7488.04,5440.76,46113.3>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/highrise_square_shell_box_128_c.rmdl",<7296.71,5312,46561.3>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/highrise_square_shell_box_128_c.rmdl",<7297,5311.97,46818.1>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/highrise_square_shell_box_128_c.rmdl",<7296.97,5439.77,46818.1>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/highrise_square_shell_box_128_c.rmdl",<7359.85,5503.04,46818.2>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/highrise_square_shell_box_128_c.rmdl",<7487.79,5503.05,46818.2>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/highrise_square_shell_box_128_c.rmdl",<7551.02,5439.94,46818.2>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/highrise_square_shell_box_128_c.rmdl",<7551.02,5312.02,46818.2>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/highrise_square_shell_box_128_c.rmdl",<7296.98,5440.03,46306.2>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/highrise_square_shell_box_128_c.rmdl",<7551.08,5440.04,46306.4>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/colony/ventilation_unit_01_black.rmdl",<7487.46,5311.17,45730.1>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/colony/ventilation_unit_01_black.rmdl",<7424.16,5311.02,45729.9>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/colony/ventilation_unit_01_black.rmdl",<7360.02,5311.01,45729.9>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/colony/ventilation_unit_01_black.rmdl",<7359.61,5440.79,45345.5>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/colony/ventilation_unit_01_black.rmdl",<7423.91,5440.85,45345.5>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/colony/ventilation_unit_01_black.rmdl",<7487.41,5440.76,45345.7>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/highrise_square_shell_box_128_c.rmdl",<7360.15,5248.98,45281.9>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/highrise_square_shell_box_128_c.rmdl",<7488.04,5249,45281.9>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/highrise_square_shell_box_128_c.rmdl",<7359.88,5248.87,45026.5>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/highrise_square_shell_box_128_c.rmdl",<7488.07,5248.87,45026.5>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/highrise_square_shell_box_128_c.rmdl",<7359.68,5248.94,44769.9>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/highrise_square_shell_box_128_c.rmdl",<7488.27,5248.96,44769.9>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/highrise_square_shell_box_128_c.rmdl",<7359.98,5248.98,44514.2>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/highrise_square_shell_box_128_c.rmdl",<7487.98,5248.98,44514.2>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/highrise_square_shell_box_128_c.rmdl",<7487.87,5503.01,44770.1>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/highrise_square_shell_box_128_c.rmdl",<7359.98,5503,44770.1>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/colony/ventilation_unit_01_black.rmdl",<7488.07,5311.09,44961.6>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/colony/ventilation_unit_01_black.rmdl",<7424.17,5311.11,44961.6>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/colony/ventilation_unit_01_black.rmdl",<7359.97,5311.1,44961.6>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/colony/ventilation_unit_01_black.rmdl",<7296.26,5311.12,44961.6>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/colony/ventilation_unit_01_black.rmdl",<7551.82,5311.03,44962.2>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/colony/ventilation_unit_01_black.rmdl",<7551.94,5440.58,45345.2>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/colony/ventilation_unit_01_black.rmdl",<7296.03,5440.68,45345.3>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/colony/ventilation_unit_01_black.rmdl",<7552.02,5311.61,45729.1>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/colony/ventilation_unit_01_black.rmdl",<7296.02,5311.59,45729.1>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/colony/ventilation_unit_01_black.rmdl",<7295.99,5184.99,45730.2>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/colony/ventilation_unit_01_black.rmdl",<7359.97,5184.99,45730.2>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/colony/ventilation_unit_01_black.rmdl",<7423.96,5184.99,45730.2>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/colony/ventilation_unit_01_black.rmdl",<7487.95,5184.99,45730.2>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/colony/ventilation_unit_01_black.rmdl",<7551.96,5184.99,45730.2>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/colony/ventilation_unit_01_black.rmdl",<7551.8,5567.15,45345.5>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/colony/ventilation_unit_01_black.rmdl",<7488.09,5567.12,45345.5>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/colony/ventilation_unit_01_black.rmdl",<7424.05,5567.13,45345.5>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/colony/ventilation_unit_01_black.rmdl",<7360.38,5567.19,45345.6>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/colony/ventilation_unit_01_black.rmdl",<7296.19,5567.15,45345.5>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/colony/ventilation_unit_01_black.rmdl",<7295.98,5185,44962>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/colony/ventilation_unit_01_black.rmdl",<7359.67,5184.94,44962>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/colony/ventilation_unit_01_black.rmdl",<7423.9,5184.99,44961.9>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/colony/ventilation_unit_01_black.rmdl",<7488.23,5184.97,44961.9>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/colony/ventilation_unit_01_black.rmdl",<7552.09,5184.99,44961.9>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/colony/ventilation_unit_01_black.rmdl",<7359.67,5440.93,44577.8>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/colony/ventilation_unit_01_black.rmdl",<7423.88,5440.98,44577.8>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/colony/ventilation_unit_01_black.rmdl",<7487.86,5440.98,44577.8>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/colony/ventilation_unit_01_black.rmdl",<7552.04,5440.99,44577.8>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/colony/ventilation_unit_01_black.rmdl",<7296,5440.98,44577.8>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/colony/ventilation_unit_01_black.rmdl",<7296.53,5567.16,44578.1>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/colony/ventilation_unit_01_black.rmdl",<7360.28,5567.05,44578.1>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/colony/ventilation_unit_01_black.rmdl",<7423.72,5567.04,44578.1>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/colony/ventilation_unit_01_black.rmdl",<7487.62,5567.08,44578>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/colony/ventilation_unit_01_black.rmdl",<7551.78,5567.02,44578>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/highrise_square_shell_box_128_c.rmdl",<7487.97,5249,44258.1>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/desertlands/highrise_square_shell_box_128_c.rmdl",<7360.04,5249,44258.1>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7360.4,5568.86,43775.7>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7487.87,5568.96,43775.8>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7360.19,5568.95,44095.8>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7488.02,5568.97,44095.8>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7488.1,6207.02,43263.8>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7360.11,6207.03,43263.8>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7360.09,6207.13,43584.5>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7487.98,6207.11,43584.4>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7487.97,6207,42944>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7360.13,6207.01,42944>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7615.11,6399.89,42751.6>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7615.1,6527.76,42751.6>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7232.89,6528.17,42751.6>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7232.91,6400,42751.6>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7360.16,5888.92,43455.7>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7487.91,5888.96,43455.7>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7488.14,5887.1,43775.6>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7359.83,5887.12,43775.6>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7232.99,6655.9,42751.9>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7616.86,6655.5,42751.9>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7231,6527.95,42624>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7231.02,6655.92,42495.8>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7616.96,6528.25,42624.1>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7616.88,6655.95,42495.5>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7616.42,6719.11,42495.8>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7231.96,6719.01,42495.8>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7616.45,6719.22,42751.6>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7232.29,6719.07,42751.8>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7616.96,6783.99,42368.3>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7616.99,6784.03,42688.1>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7233,6783.96,42368.1>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7231.01,6783.85,42688>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7616.98,6911.86,42239.9>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7232.98,6912.11,42239.9>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7232.94,6911.96,42560.3>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7232.88,7040.14,42111.5>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7616.88,7039.9,42111.5>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7615.12,6911.84,42559.6>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7616.96,7039.71,42431.9>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7231.02,7039.89,42431.8>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7616.19,7103.05,42111.7>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7232.06,7103.04,42111.7>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7231.89,7103.02,42431.8>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7616.09,7103.03,42431.8>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7616.81,7167.9,41983.4>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7231.01,7168.14,41983.9>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7616.79,7296.14,41855.4>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7231.01,7295.98,41855.9>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7616.98,7167.82,42304>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7616.73,7295.77,42175.4>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7231.13,7295.71,42175.6>,<0,-90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7232.94,7167.66,42304.1>,<0,90,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7487.99,5504.85,47797.5>,<0,180,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_wall_128x352_04.rmdl",<7360.13,5503.03,47797.8>,<0,0,0>, true, 8000) 
    CreateEditorProp( $"mdl/thunderdome/thunderdome_cage_ceiling_256x256_06.rmdl",<7424,5504,47168>,<0,0,0>, true, 8000)

    CreateEditorProp( $"mdl/canyonlands/canyonlands_zone_sign_03b.rmdl",<7231.21,7743.45,41866.3>,<0,-90,0>, true, 8000)
}
