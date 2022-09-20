global function Cl_CustomTDM_Init

global function ServerCallback_TDM_DoAnnouncement
global function ServerCallback_TDM_SetSelectedLocation
global function ServerCallback_TDM_DoLocationIntroCutscene
global function ServerCallback_TDM_PlayerKilled
global function TDM_OnPlayerKilled
global function Cl_RegisterLocation

bool isFuncRegister = false

struct {

    LocationSettings &selectedLocation
    array choices
    array<LocationSettings> locationSettings
    var scoreRui
} file;



void function Cl_CustomTDM_Init()
{
	thread ChatEvent_Handler()
	AddOnDeathCallback( "player", TDM_OnPlayerKilled )
}

void function Cl_RegisterLocation(LocationSettings locationSettings)
{
    file.locationSettings.append(locationSettings)
}

void function TDM_OnPlayerKilled( entity player )
{
	entity viewPlayer = GetLocalViewPlayer()
}

void function ChatEvent_Handler()
{
	while(true)
	{
		if(isChatShow && !isFuncRegister)
		{
			RegisterButtonPressedCallback(KEY_ENTER, SendChat);
			isFuncRegister = true
		}
		else if(!isChatShow && isFuncRegister)
		{
			DeregisterButtonPressedCallback(KEY_ENTER, SendChat)
			isFuncRegister = false
		}
		wait 0.5
	}
	
}
void function SendChat(var button)
{
	GetLocalClientPlayer().ClientCommand(chatText)
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
    var screenAlignmentTopo = RuiTopology_CreatePlane( <( screenSize.width * 0.20),( screenSize.height * 0.31 ), 0>, <float( screenSize.width ), 0, 0>, <0, float( screenSize.height ), 0>, false )
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
            subtext = "Made by sal (score UI by shrugtal)"
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
    float desiredSpawnSpeed = Deathmatch_GetIntroSpawnSpeed()
    float desiredSpawnDuration = Deathmatch_GetIntroCutsceneSpawnDuration()
    float desireNoSpawns = Deathmatch_GetIntroCutsceneNumSpawns()
    

    entity player = GetLocalClientPlayer()
    
    if(!IsValid(player)) return
    

    EmitSoundOnEntity( player, "music_skyway_04_smartpistolrun" )
     
    float playerFOV = player.GetFOV()
    
    entity camera = CreateClientSidePointCamera(file.selectedLocation.spawns[0].origin + file.selectedLocation.cinematicCameraOffset, <90, 90, 0>, 17)
    camera.SetFOV(90)

    entity cutsceneMover = CreateClientsideScriptMover($"mdl/dev/empty_model.rmdl", file.selectedLocation.spawns[0].origin + file.selectedLocation.cinematicCameraOffset, <90, 90, 0>)
    camera.SetParent(cutsceneMover)
	GetLocalClientPlayer().SetMenuCameraEntity( camera )

    ////////////////////////////////////////////////////////////////////////////////
    ///////// EFFECTIVE CUTSCENE CODE START


    array<LocPair> cutsceneSpawns
    for(int i = 0; i < desireNoSpawns; i++)
    {
        if(!cutsceneSpawns.len())
            cutsceneSpawns = clone file.selectedLocation.spawns

        LocPair spawn = cutsceneSpawns.getrandom()
        cutsceneSpawns.fastremovebyvalue(spawn)

        cutsceneMover.SetOrigin(spawn.origin)
        camera.SetAngles(spawn.angles)



        cutsceneMover.NonPhysicsMoveTo(spawn.origin + AnglesToForward(spawn.angles) * desiredSpawnDuration * desiredSpawnSpeed, desiredSpawnDuration, 0, 0)
        wait desiredSpawnDuration
    }

    ///////// EFFECTIVE CUTSCENE CODE END
    ////////////////////////////////////////////////////////////////////////////////

    GetLocalClientPlayer().ClearMenuCameraEntity()
    cutsceneMover.Destroy()

    if(IsValid(player))
    {
        FadeOutSoundOnEntity( player, "music_skyway_04_smartpistolrun", 1 )
    }
    if(IsValid(camera))
    {
        camera.Destroy()
    }
    
    
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