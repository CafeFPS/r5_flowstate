global function Cl_CustomTDM_Init

global function ServerCallback_TDM_DoAnnouncement
global function ServerCallback_TDM_SetSelectedLocation
global function ServerCallback_TDM_DoLocationIntroCutscene
global function ServerCallback_TDM_PlayerKilled

global function Cl_RegisterLocation

struct {

    LocationSettings &selectedLocation
    array choices
    array<LocationSettings> locationSettings
    var scoreRui
} file;



void function Cl_CustomTDM_Init()
{
}

void function Cl_RegisterLocation(LocationSettings locationSettings)
{
    file.locationSettings.append(locationSettings)
}


void function MakeScoreRUI()
{
    if ( file.scoreRui != null)
    {
        RuiSetString( file.scoreRui, "messageText", "Team IMC: 0  ||  Team MIL: 0" )
        return
    }
    clGlobal.levelEnt.EndSignal( "CloseScoreRUI" )

    UISize screenSize = GetScreenSize()
    var screenAlignmentTopo = RuiTopology_CreatePlane( <( screenSize.width * 0.25),( screenSize.height * 0.31 ), 0>, <float( screenSize.width ), 0, 0>, <0, float( screenSize.height ), 0>, false )
    var rui = RuiCreate( $"ui/announcement_quick_right.rpak", screenAlignmentTopo, RUI_DRAW_HUD, RUI_SORT_SCREENFADE + 1 )
    
    RuiSetGameTime( rui, "startTime", Time() )
    RuiSetString( rui, "messageText", "Team IMC: 0  ||  Team MIL: 0" )
    RuiSetString( rui, "messageSubText", "Text 2")
    RuiSetFloat( rui, "duration", 9999999 )
    RuiSetFloat3( rui, "eventColor", SrgbToLinear( <128, 188, 255> ) )
	
    file.scoreRui = rui
    
    OnThreadEnd(
		function() : ( rui )
		{
			RuiDestroy( rui )
			file.scoreRui = null
		}
	)
    
    WaitForever()
}

void function ServerCallback_TDM_DoAnnouncement(float duration, int type)
{
    string message = ""
    string subtext = ""
    switch(type)
    {
        case eTDMAnnounce.WAITING_FOR_PLAYERS: 
        {
            message = "Waiting For Players"
            subtext = GetPlayerArray().len().tostring() + "/" + MIN_NUMBER_OF_PLAYERS.tostring()
            break
        }
        case eTDMAnnounce.ROUND_START:
        {
            thread MakeScoreRUI();
            message = "Round start"
            break
        }
        case eTDMAnnounce.VOTING_PHASE:
        {
            clGlobal.levelEnt.Signal( "CloseScoreRUI" )
            message = "Welcome To Team Deathmatch"
            break
        }
        case eTDMAnnounce.MAP_FLYOVER:
        {
            
            if(file.locationSettings.len())
                message = file.selectedLocation.name
            break
        }
    }
	AnnouncementData announcement = Announcement_Create( message )
    Announcement_SetSubText(announcement, subtext)
	Announcement_SetStyle( announcement, ANNOUNCEMENT_STYLE_CIRCLE_WARNING )
	Announcement_SetPurge( announcement, true )
	Announcement_SetOptionalTextArgsArray( announcement, [ "true" ] )
	Announcement_SetPriority( announcement, 200 ) //Be higher priority than Titanfall ready indicator etc
	announcement.duration = duration
	AnnouncementFromClass( GetLocalViewPlayer(), announcement )
}

void function ServerCallback_TDM_DoLocationIntroCutscene()
{
    thread ServerCallback_TDM_DoLocationIntroCutscene_Body()
}

void function ServerCallback_TDM_DoLocationIntroCutscene_Body()
{
    float playerFOV = GetLocalClientPlayer().GetFOV()
    
    entity camera = CreateClientSidePointCamera(file.selectedLocation.spawns[teams[0]][0].origin + file.selectedLocation.cinematicCameraOffset, <90, 90, 0>, 17)
    camera.SetFOV(90)
    
    entity cutsceneMover = CreateClientsideScriptMover($"mdl/dev/empty_model.rmdl", file.selectedLocation.spawns[teams[0]][0].origin + file.selectedLocation.cinematicCameraOffset, <90, 90, 0>)
    camera.SetParent(cutsceneMover)
    wait 1

	GetLocalClientPlayer().SetMenuCameraEntity( camera )


    for(int i = 0; i < teams.len(); i++)
    {
        entity spawn = CreateClientSidePropDynamic(OriginToGround(file.selectedLocation.spawns[teams[i]][0].origin), <0, 0, 0>, $"mdl/dev/empty_model.rmdl" )
        thread CreateTemporarySpawnRUI(spawn, LOCATION_CUTSCENE_DURATION + 2)
    }

    for(int i = 1; i < teams.len(); i++)
    {

        float duration = LOCATION_CUTSCENE_DURATION / max(1, teams.len() - 1)
        cutsceneMover.NonPhysicsMoveTo(file.selectedLocation.spawns[teams[i]][0].origin + file.selectedLocation.cinematicCameraOffset, duration, 1, 1)
        wait duration
    }

    wait 1
    cutsceneMover.NonPhysicsMoveTo(GetLocalClientPlayer().GetOrigin() + <0, 0, 100>, 2, 1, 1)
    cutsceneMover.NonPhysicsRotateTo(GetLocalClientPlayer().GetAngles(), 2, 1, 1)
	camera.SetTargetFOV(playerFOV, true, EASING_CUBIC_INOUT, 2 )

    wait 2
    GetLocalClientPlayer().ClearMenuCameraEntity()
    cutsceneMover.Destroy()
    
    camera.Destroy()
}

void function ServerCallback_TDM_SetSelectedLocation(int sel)
{
    file.selectedLocation = file.locationSettings[sel]
}

void function ServerCallback_TDM_PlayerKilled()
{
    if(file.scoreRui)
        RuiSetString( file.scoreRui, "messageText", "Team IMC: " + GameRules_GetTeamScore(TEAM_IMC) + "  ||  Team MIL: " + GameRules_GetTeamScore(TEAM_MILITIA) );
}

var function CreateTemporarySpawnRUI(entity parentEnt, float duration)
{
	var rui = AddOverheadIcon( parentEnt, RESPAWN_BEACON_ICON, false, $"ui/overhead_icon_respawn_beacon.rpak" )
	RuiSetFloat2( rui, "iconSize", <80,80,0> )
	RuiSetFloat( rui, "distanceFade", 50000 )
	RuiSetBool( rui, "adsFade", true )
	RuiSetString( rui, "hint", "SPAWN POINT" )

    wait duration

    parentEnt.Destroy()
}