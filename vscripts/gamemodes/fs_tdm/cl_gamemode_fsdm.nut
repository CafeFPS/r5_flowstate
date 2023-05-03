global function Cl_CustomTDM_Init

global function ServerCallback_TDM_DoAnnouncement
global function ServerCallback_TDM_SetSelectedLocation
global function ServerCallback_TDM_DoLocationIntroCutscene
global function ServerCallback_TDM_PlayerKilled
global function TDM_OnPlayerKilled
global function Cl_RegisterLocation

const string CIRCLE_CLOSING_IN_SOUND = "UI_InGame_RingMoveWarning" //"survival_circle_close_alarm_01"

bool isFuncRegister = false

struct {

    LocationSettings &selectedLocation
    array choices
    array<LocationSettings> locationSettings
    var scoreRui
} file;



void function Cl_CustomTDM_Init()
{
	AddOnDeathCallback( "player", TDM_OnPlayerKilled )
    AddCallback_EntitiesDidLoad( NotifyRingTimer )
	RegisterButtonPressedCallback(KEY_ENTER, ClientReportChat)
}

void function ClientReportChat(var button)
{
	if(CHAT_TEXT  == "") return
	
	string text = "say " + CHAT_TEXT
	GetLocalClientPlayer().ClientCommand(text)
}

void function NotifyRingTimer()
{
    if( GetGlobalNetTime( "nextCircleStartTime" ) < Time() )
        return
    
    UpdateFullmapRuiTracks()

    float new = GetGlobalNetTime( "nextCircleStartTime" )

    var gamestateRui = ClGameState_GetRui()
	array<var> ruis = [gamestateRui]
	var cameraRui = GetCameraCircleStatusRui()
	if ( IsValid( cameraRui ) )
		ruis.append( cameraRui )

	int roundNumber = (SURVIVAL_GetCurrentDeathFieldStage() + 1)
	string roundString = Localize( "#SURVIVAL_CIRCLE_STATUS_ROUND_CLOSING", roundNumber )
	if ( SURVIVAL_IsFinalDeathFieldStage() )
		roundString = Localize( "#SURVIVAL_CIRCLE_STATUS_ROUND_CLOSING_FINAL" )
	DeathFieldStageData data = GetDeathFieldStage( SURVIVAL_GetCurrentDeathFieldStage() )
	float currentRadius      = SURVIVAL_GetDeathFieldCurrentRadius()
	float endRadius          = data.endRadius

	foreach( rui in ruis )
	{
		RuiSetGameTime( rui, "circleStartTime", new )
		RuiSetInt( rui, "roundNumber", roundNumber )
		RuiSetString( rui, "roundClosingString", roundString )

		entity localViewPlayer = GetLocalViewPlayer()
		if ( IsValid( localViewPlayer ) )
		{
			RuiSetFloat( rui, "deathfieldStartRadius", currentRadius )
			RuiSetFloat( rui, "deathfieldEndRadius", endRadius )
			RuiTrackFloat3( rui, "playerOrigin", localViewPlayer, RUI_TRACK_ABSORIGIN_FOLLOW )

			#if(true)
				RuiTrackInt( rui, "teamMemberIndex", localViewPlayer, RUI_TRACK_PLAYER_TEAM_MEMBER_INDEX )
			#endif
		}
	}

    if ( SURVIVAL_IsFinalDeathFieldStage() )
        roundString = "#SURVIVAL_CIRCLE_ROUND_FINAL"
    else
        roundString = Localize( "#SURVIVAL_CIRCLE_ROUND", SURVIVAL_GetCurrentRoundString() )

    float duration = 7.0

    AnnouncementData announcement
    announcement = Announcement_Create( "" )
    Announcement_SetSubText( announcement, roundString )
    Announcement_SetHeaderText( announcement, "#SURVIVAL_CIRCLE_WARNING" )
    Announcement_SetDisplayEndTime( announcement, new )
    Announcement_SetStyle( announcement, ANNOUNCEMENT_STYLE_CIRCLE_WARNING )
    Announcement_SetSoundAlias( announcement, CIRCLE_CLOSING_IN_SOUND )
    Announcement_SetPurge( announcement, true )
    Announcement_SetPriority( announcement, 200 ) //
    Announcement_SetDuration( announcement, duration )

    AnnouncementFromClass( GetLocalViewPlayer(), announcement )
}

void function Cl_RegisterLocation(LocationSettings locationSettings)
{
    file.locationSettings.append(locationSettings)
}

void function TDM_OnPlayerKilled( entity player )
{
	entity viewPlayer = GetLocalViewPlayer()
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