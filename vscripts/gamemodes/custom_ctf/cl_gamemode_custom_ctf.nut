// Credits
// AyeZee#6969 -- ctf gamemode and ui
// sal#3261 -- base custom_tdm mode to work off
// Retículo Endoplasmático#5955 -- giving me the ctf sound names
// everyone else -- advice

global function Cl_CustomCTF_Init

//Server Callbacks
global function ServerCallback_CTF_DoAnnouncement
global function ServerCallback_CTF_FlagCaptured
global function ServerCallback_CTF_CustomMessages
global function ServerCallback_CTF_OpenCTFRespawnMenu
global function ServerCallback_CTF_SetSelectedLocation
global function ServerCallback_CTF_SetObjectiveText
global function ServerCallback_CTF_AddPointIcon
global function ServerCallback_CTF_RecaptureFlag
global function ServerCallback_CTF_ResetFlagIcons
global function ServerCallback_CTF_SetPointIconHint
global function ServerCallback_CTF_UpdatePlayerStats
global function ServerCallback_CTF_CheckUpdatePlayerLegend
global function ServerCallback_CTF_PickedUpFlag
global function ServerCallback_CTF_HideCustomUI
// Voting
global function ServerCallback_CTF_SetVoteMenuOpen
global function ServerCallback_CTF_UpdateVotingMaps
global function ServerCallback_CTF_UpdateMapVotesClient
global function ServerCallback_CTF_SetScreen

//Ui callbacks
global function UI_To_Client_VoteForMap
global function UI_To_Client_UpdateSelectedClass

global function Cl_CTFRegisterLocation
global function Cl_CTFRegisterCTFClass
global function CL_FSCTF_RegisterNetworkFunctions

global function FSCTF_GameStateChanged

struct {

    LocationSettingsCTF &selectedLocation
    array choices
    array<LocationSettingsCTF> locationSettings
    array<CTFClasses> ctfclasses
    var scoreRui
    var teamRui
    var dropflagrui
    var baseicon
    entity baseiconmdl

	vector victorySequencePosition = < 0, 0, 10000 >
	vector victorySequenceAngles = < 0, 0, 0 >

	SquadSummaryData squadSummaryData
	SquadSummaryData winnerSquadSummaryData

    int teamwon

    int ClassID = 0
} file;

struct {
    var imcscorebg
    var imcscorecurrentbg
    var milscorebg
    var milscorecurrentbg
    var miltext
    var imctext
    var milscore
    var imcscore
    var timer

    int milscore2
    int imcscore2
} teamscore;

struct {
    var IMCpointicon = null
    var MILITIApointicon = null
    var FlagReturnRUI = null
} FlagRUI;

struct {
    int gamestarttime
    int endingtime
    int seconds
} clientgametimer;

struct {
    entity e
    entity m
} deathcam;

bool hasvoted = false;
bool isvoting = false;
bool roundover = false

bool hidechat = false;
int hidechatcountdown = 0;

array<var> teamicons
array<entity> cleanupEnts
array<var> overHeadRuis

PakHandle &CTFRpak

string client_messageString = ""
string oldmessages = ""
array<string> savedmessages

void function Cl_CustomCTF_Init()
{
	AddClientCallback_OnResolutionChanged( Cl_CTF_OnResolutionChanged )
	RegisterConCommandTriggeredCallback( "+scriptCommand5", SendDropFlagToServer )
	AddClientCallback_OnResolutionChanged( Cl_OnResolutionChanged )
	AddCallback_EntitiesDidLoad( CTFNotifyRingTimer )

	CTFRpak = RequestPakFile( "ctf_mode" )
	RegisterSignal("FSDM_EndTimer")
}

void function CL_FSCTF_RegisterNetworkFunctions()
{
	if ( IsLobby() )
		return
	
	RegisterNetworkedVariableChangeCallback_time( "flowstate_DMStartTime", Flowstate_CTFStartTimeChanged )
	RegisterNetworkedVariableChangeCallback_time( "flowstate_DMRoundEndTime", Flowstate_CTFRoundEndTimeChanged )
}

void function Cl_OnResolutionChanged()
{
	if( GetGlobalNetInt( "FSDM_GameState" ) != 0 )
	{
		ShowScoreRUI( false )
		Flowstate_ShowRoundEndTimeUI( -1 )
		return
	}
	
	Flowstate_ShowRoundEndTimeUI( GetGlobalNetTime( "flowstate_DMRoundEndTime" ) )
	ShowScoreRUI( true )
}

void function FSCTF_GameStateChanged( entity player, int old, int new, bool actuallyChanged )
{
	if ( !actuallyChanged )
		return

	if( new == 0 )
	{
		ShowScoreRUI( true )
	} else if( new == 1 )
	{
		ShowScoreRUI( false )
		Flowstate_ShowRoundEndTimeUI( -1 )
	}
}

void function Flowstate_CTFStartTimeChanged( entity player, float old, float new, bool actuallyChanged )
{
	if ( !actuallyChanged  )
		return

	thread Flowstate_PlayStartRoundSounds( )
	thread Flowstate_ShowStartTimeUI( new )
}

void function Flowstate_CTFRoundEndTimeChanged( entity player, float old, float new, bool actuallyChanged )
{
	if ( !actuallyChanged  )
		return

	thread Flowstate_ShowRoundEndTimeUI( new )
}

void function CTFNotifyRingTimer()
{
    if( GetGlobalNetTime( "flowstate_DMRoundEndTime" ) < Time() || GetGlobalNetInt( "FSDM_GameState" ) != eTDMState.IN_PROGRESS || GetGlobalNetTime( "flowstate_DMRoundEndTime" ) == -1 )
	{
		ShowScoreRUI( false )
		Flowstate_ShowRoundEndTimeUI( -1 )
        return
	}

    Flowstate_ShowRoundEndTimeUI( GetGlobalNetTime( "flowstate_DMRoundEndTime" ) )
	ShowScoreRUI( true )
}

void function ServerCallback_CTF_HideCustomUI()
{
    ShowScoreRUI(false)
}

void function SendDropFlagToServer( entity localPlayer )
{
	GetLocalClientPlayer().ClientCommand("DropFlag")
}

void function Cl_CTF_OnResolutionChanged()
{
	
}

void function Cl_CTFRegisterLocation(LocationSettingsCTF locationSettings)
{
    file.locationSettings.append(locationSettings)
}

void function Cl_CTFRegisterCTFClass(CTFClasses ctfclass)
{
    file.ctfclasses.append(ctfclass)
}

void function ServerCallback_CTF_SetSelectedLocation(int sel)
{
    file.selectedLocation = file.locationSettings[sel]

    array<LocPairCTF> spawns = file.selectedLocation.ringspots
}

void function ServerCallback_CTF_RecaptureFlag(int team, float starttime, float endtime, bool start)
{
    asset icon

    if(team == TEAM_IMC)
        icon = $"rui/gamemodes/capture_the_flag/imc_flag"
    else
        icon = $"rui/gamemodes/capture_the_flag/mil_flag"

    if(start)
    {
        FlagRUI.FlagReturnRUI = CreateFullscreenRui( $"ui/consumable_progress.rpak")
        RuiSetGameTime( FlagRUI.FlagReturnRUI, "healStartTime", starttime )
        RuiSetString( FlagRUI.FlagReturnRUI, "consumableName", "Returning Flag To Base" )
        RuiSetFloat( FlagRUI.FlagReturnRUI, "raiseTime", 5.0 )
        RuiSetFloat( FlagRUI.FlagReturnRUI, "chargeTime", 0 )
        RuiSetImage( FlagRUI.FlagReturnRUI, "hudIcon", icon )
        RuiSetInt( FlagRUI.FlagReturnRUI, "consumableType", 3 ) //0 = red, 1 = dark blue, 2 = dark purple, 3 = white
		RuiSetString( FlagRUI.FlagReturnRUI, "hintController", "" )
		RuiSetString( FlagRUI.FlagReturnRUI, "hintKeyboardMouse", "" )
    }
    else
    {
        if (FlagRUI.FlagReturnRUI != null)
        {
			RuiDestroyIfAlive( FlagRUI.FlagReturnRUI )
			FlagRUI.FlagReturnRUI = null
        }
    }
}

void function ServerCallback_CTF_ResetFlagIcons()
{
	if( FlagRUI.IMCpointicon != null)
	{
		RuiDestroyIfAlive( FlagRUI.IMCpointicon )
		FlagRUI.IMCpointicon = null
	}
	if( FlagRUI.MILITIApointicon != null)
	{
		RuiDestroyIfAlive( FlagRUI.MILITIApointicon )
		FlagRUI.MILITIApointicon = null
	}
}

void function ServerCallback_CTF_AddPointIcon(entity imcflag, entity milflag, int team)
{
    ClientCodeCallback_MinimapEntitySpawned(imcflag)
    ClientCodeCallback_MinimapEntitySpawned(milflag)
	
	entity player = GetLocalClientPlayer()

    switch( player.GetTeam() )
    {
        case TEAM_IMC:
            if(FlagRUI.IMCpointicon == null)
                FlagRUI.IMCpointicon = AddPointIconRUI(FlagRUI.IMCpointicon, imcflag, "Defend", $"rui/gamemodes/capture_the_flag/imc_flag")
            if(FlagRUI.MILITIApointicon == null)
                FlagRUI.MILITIApointicon = AddPointIconRUI(FlagRUI.MILITIApointicon, milflag, "Capture", $"rui/gamemodes/capture_the_flag/mil_flag")
            break
        case TEAM_MILITIA:
            if(FlagRUI.IMCpointicon == null)
                FlagRUI.IMCpointicon = AddPointIconRUI(FlagRUI.IMCpointicon, imcflag, "Capture", $"rui/gamemodes/capture_the_flag/imc_flag")
            if(FlagRUI.MILITIApointicon == null)
                FlagRUI.MILITIApointicon = AddPointIconRUI(FlagRUI.MILITIApointicon, milflag, "Defend", $"rui/gamemodes/capture_the_flag/mil_flag")
            break
    }
}

var function AddPointIconRUI(var rui, entity flag, string text, asset icon)
{
    if(!IsValid(flag))
        return
        
    bool pinToEdge = true
    asset ruiFile = $"ui/overhead_icon_generic.rpak"

    rui = AddCaptureIcon( flag, icon, pinToEdge, ruiFile)
	RuiSetFloat2( rui, "iconSize", <40,40,0> )
	RuiSetFloat( rui, "distanceFade", 100000 )
	RuiSetBool( rui, "adsFade", false )
	RuiSetString( rui, "hint", text )
    return rui
}

void function ServerCallback_CTF_SetPointIconHint(int teamflag, int messageid)
{
    try {
        var selected

        if(teamflag == TEAM_IMC)
            selected = FlagRUI.IMCpointicon
        else
            selected = FlagRUI.MILITIApointicon

        switch(messageid)
        {
        case eCTFFlag.Defend:
            RuiSetString( selected, "hint", "Defend" )
            break
        case eCTFFlag.Capture:
            RuiSetString( selected, "hint", "Capture" )
            break
        case eCTFFlag.Attack:
            RuiSetString( selected, "hint", "Attack" )
            break
        case eCTFFlag.Escort:
            RuiSetString( selected, "hint", "Escort" )
            break
        case eCTFFlag.Return:
            RuiSetString( selected, "hint", "Return" )
            break
        }
    } catch (pe3){ }
}

var function AddCaptureIcon( entity prop, asset icon, bool pinToEdge = true, asset ruiFile = $"ui/overhead_icon_generic.rpak" )
{
	var rui = CreateFullscreenRui( ruiFile, HUD_Z_BASE - 20 )
	RuiSetImage( rui, "icon", icon )
	RuiSetBool( rui, "isVisible", true )
	RuiSetBool( rui, "pinToEdge", pinToEdge )
	RuiTrackFloat3( rui, "pos", prop, RUI_TRACK_OVERHEAD_FOLLOW )

    thread AddCaptureIconThread( prop, rui )
	return rui
}

void function AddCaptureIconThread( entity prop, var rui )
{
	prop.EndSignal( "OnDestroy" )

	prop.e.overheadRui = rui

	OnThreadEnd(
		function() : ( prop, rui )
		{
			if( rui != null)
			{
				RuiDestroyIfAlive( rui )
			}

			if ( IsValid( prop ) )
				prop.e.overheadRui = null
		}
	)

	WaitForever()
}

void function ServerCallback_CTF_PickedUpFlag(entity player, bool pickedup)
{
    asset icon = $"rui/gamemodes/capture_the_flag/arrow"
    vector emptymdlloc
    vector color

    switch(player.GetTeam())
    {
        case TEAM_IMC:
            if(FlagRUI.IMCpointicon == null)
                break

            emptymdlloc = file.selectedLocation.imcflagspawn
            color = SrgbToLinear( <100,100,255> / 255 )

            if(pickedup)
                RuiSetVisible( FlagRUI.MILITIApointicon, false )
            else
                RuiSetVisible( FlagRUI.MILITIApointicon, true )
            break
        case TEAM_MILITIA:
            if(FlagRUI.MILITIApointicon == null)
                break

            emptymdlloc = file.selectedLocation.milflagspawn
            color = SrgbToLinear( <255,100,100> / 255 )

            if(pickedup)
                RuiSetVisible( FlagRUI.IMCpointicon, false )
            else
                RuiSetVisible( FlagRUI.IMCpointicon, true )
            break
    }

    if(pickedup)
    {
		file.dropflagrui = CreateFullscreenRui( $"ui/wraith_comms_hint.rpak" )
		RuiSetGameTime( file.dropflagrui, "startTime", Time() )
		RuiSetGameTime( file.dropflagrui, "endTime", 9999999 )
		RuiSetBool( file.dropflagrui, "commsMenuOpen", false )
		RuiSetString( file.dropflagrui, "msg", "Press %scriptCommand5% to drop the flag" )

        file.baseiconmdl = CreateClientSidePropDynamic( emptymdlloc + <0,0,100>, <0,0,0>, $"mdl/dev/empty_model.rmdl" )
        file.baseicon = AddCaptureIcon( file.baseiconmdl, icon, false, $"ui/overhead_icon_generic.rpak")
        RuiSetFloat2( file.baseicon, "iconSize", <25,25,0> )
        RuiSetFloat( file.baseicon, "distanceFade", 100000 )
        RuiSetBool( file.baseicon, "adsFade", false )
        RuiSetString( file.baseicon, "hint", "" )
    }
    else
    {
		if( file.dropflagrui != null)
		{
			RuiDestroyIfAlive( file.dropflagrui )
			file.dropflagrui = null
		}

		if( file.baseicon != null)
		{
			RuiDestroyIfAlive( file.baseicon )
			file.baseicon = null
		}

        if(IsValid( file.baseiconmdl ))
            file.baseiconmdl.Destroy()
    }
}

void function ServerCallback_CTF_DoAnnouncement(float duration, int type, float starttime)
{
    string message = ""
    string subtext = ""
    switch(type)
    {

        case eCTFAnnounce.ROUND_START:
        {
            ShowScoreRUI( true )
            message = "Match Start"
            subtext = "Score 5 points to win!"
            break
        }
        case eCTFAnnounce.VOTING_PHASE:
        {
            clGlobal.levelEnt.Signal( "CloseScoreRUI" )
            break
        }
    }
	AnnouncementData announcement = Announcement_Create( message )
    Announcement_SetSubText(announcement, subtext)
	Announcement_SetStyle( announcement, ANNOUNCEMENT_STYLE_CIRCLE_WARNING )
	Announcement_SetPurge( announcement, true )
	Announcement_SetOptionalTextArgsArray( announcement, [ "true" ] )
	Announcement_SetPriority( announcement, 200 )
	announcement.duration = duration
	AnnouncementFromClass( GetLocalViewPlayer(), announcement )
}

void function DeleteScoreRUI(bool newround)
{
    printt( "Delete score Rui" )
}

void function ShowScoreRUI(bool show)
{
    Hud_SetVisible( HudElement( "FS_Oddball_YourTeam" ), show )
	Hud_SetVisible( HudElement( "FS_Oddball_YourTeamGoalScore" ), show )
	Hud_SetText( HudElement( "FS_Oddball_YourTeamGoalScore"), "/" + CTF_SCORE_GOAL_TO_WIN ) 
    Hud_SetVisible( HudElement( "FS_Oddball_YourTeamScore" ), show )
    Hud_SetVisible( HudElement( "FS_Oddball_AllyHas" ), show )
    Hud_SetVisible( HudElement( "FS_Oddball_EnemyTeam" ), show )
    Hud_SetVisible( HudElement( "FS_Oddball_EnemyTeamScore" ), show )
    Hud_SetVisible( HudElement( "FS_Oddball_EnemyHas" ), show )

	RuiSetImage( Hud_GetRui( HudElement( "FS_Oddball_EnemyHas" ) ), "basicImage", $"rui/gamemodes/capture_the_flag/mil_flag" )
	RuiSetImage( Hud_GetRui( HudElement( "FS_Oddball_AllyHas" ) ), "basicImage", $"rui/gamemodes/capture_the_flag/imc_flag" )
	RuiSetImage( Hud_GetRui( HudElement( "FS_Oddball_Scoreboard_Frame" ) ), "basicImage", $"rui/flowstate_custom/scoreboard_bg_oddball" )
	
	Hud_SetVisible( HudElement( "FS_Oddball_Scoreboard_Frame" ), show )
	
	if( !show )
		return
	
	thread CTF_StartBuildingTeamsScoreOnHud()
}

void function CTF_StartBuildingTeamsScoreOnHud()
{
	entity player = GetLocalClientPlayer()

	int localscore = 0
	int enemyscore = 0
	string str_localscore = ""
	string str_enemyscore = ""
	
	while( GetGlobalNetInt( "FSDM_GameState" ) == 0 )
	{
		localscore = GameRules_GetTeamScore( player.GetTeam() )
		enemyscore = GameRules_GetTeamScore( player.GetTeam() == TEAM_IMC ? TEAM_MILITIA : TEAM_IMC )
		str_localscore = ""
		str_enemyscore = ""

		str_localscore = localscore.tostring()
		str_enemyscore = enemyscore.tostring() + "/" + CTF_SCORE_GOAL_TO_WIN.tostring()
		
		Hud_SetText( HudElement( "FS_Oddball_YourTeamScore"), str_localscore ) 
		Hud_SetText( HudElement( "FS_Oddball_EnemyTeamScore"), str_enemyscore ) 

		wait 0.01
	}
}

void function ServerCallback_CTF_FlagCaptured(entity player, int messageid)
{
    string message
    switch(messageid)
    {
        case eCTFMessage.PickedUpFlag:
            message = "Your team has captured the enemy flag!"
            break
        case eCTFMessage.EnemyPickedUpFlag:
            message = "Enemy team has captured your flag!"
            break
    }

    AnnouncementData announcement = Announcement_Create( message )
	Announcement_SetStyle( announcement, ANNOUNCEMENT_STYLE_SWEEP )
	Announcement_SetPurge( announcement, true )
	Announcement_SetOptionalTextArgsArray( announcement, [ "true" ] )
	Announcement_SetPriority( announcement, 200 )
	announcement.duration = 3
	AnnouncementFromClass( GetLocalViewPlayer(), announcement )
}

void function ServerCallback_CTF_CustomMessages(entity player, int messageid)
{
    string message
    vector color = <0,0,0>
    switch(messageid)
    {
        case eCTFMessage.PickedUpFlag:
            message = "You picked up the flag"
            break
        case eCTFMessage.EnemyPickedUpFlag:
            message = "Enemy team picked up your flag"
            break
        case eCTFMessage.TeamReturnedFlag:
            message = "Your teams flag has been returned to base"
    }

    switch(GetLocalClientPlayer().GetTeam())
    {
        case TEAM_IMC:
            color = SrgbToLinear( <100,100,255> / 255 )
            break
        case TEAM_MILITIA:
            color = SrgbToLinear( <255,100,100> / 255 )
    }

    AnnouncementData announcement = CreateAnnouncementMessageQuick( player, message, "", color, $"rui/hud/gametype_icons/survival/survey_beacon_only_pathfinder" )
	Announcement_SetPurge( announcement, true )
	Announcement_SetPriority( announcement, 200 )
	announcement.duration = 3
	AnnouncementFromClass( GetLocalViewPlayer(), announcement )
}

void function UI_To_Client_UpdateSelectedClass(int selectedclass)
{
    file.ClassID = selectedclass;

    RunUIScript("UpdateSelectedClass", file.ClassID, file.ctfclasses[file.ClassID].primary, file.ctfclasses[file.ClassID].secondary, file.ctfclasses[file.ClassID].tactical, file.ctfclasses[file.ClassID].ult, USE_LEGEND_ABILITYS)

    entity player = GetLocalClientPlayer()
    // why does s3 not have remote server functions..?
    player.ClientCommand("SetPlayerClass " + selectedclass)
}

void function ServerCallback_CTF_CheckUpdatePlayerLegend()
{
    RunUIScript("CTFUpdatePlayerLegend")
}

void function ServerCallback_CTF_OpenCTFRespawnMenu(vector campos, int IMCscore, int MILscore, entity attacker, int selectedclassid)
{
    if(isvoting)
        return

    entity localplayer = GetLocalClientPlayer()
    array<entity> teamplayers = GetPlayerArrayOfTeam( localplayer.GetTeam() )

    HealthHUD_StopUpdate( localplayer)

    RunUIScript("OpenCTFRespawnMenu", file.ctfclasses[0].name, file.ctfclasses[1].name, file.ctfclasses[2].name, file.ctfclasses[3].name, file.ctfclasses[4].name)
    RunUIScript("UpdateSelectedClass", selectedclassid, file.ctfclasses[selectedclassid].primary, file.ctfclasses[selectedclassid].secondary, file.ctfclasses[selectedclassid].tactical, file.ctfclasses[selectedclassid].ult, USE_LEGEND_ABILITYS)

    if(attacker != null)
    {
        if (attacker == GetLocalClientPlayer())
            RunUIScript( "UpdateKillerName", "Suicide")
        else if(attacker.IsPlayer() && attacker != null)
            RunUIScript( "UpdateKillerName", attacker.GetPlayerName())
        else
            RunUIScript( "UpdateKillerName", "Mysterious Forces")
    }
    else
    {
        RunUIScript( "UpdateKillerName", "Mysterious Forces")
    }

    RunUIScript("SetCTFScores", IMCscore, MILscore, CTF_SCORE_GOAL_TO_WIN)

    foreach ( player in teamplayers )
    {
        if(player == localplayer)
        {
            AddTeamIcons(player, $"rui/pilot_loadout/mods/hopup_skullpiercer", <25,25,0>, "Death Location")
        }
        else
        {
            AddTeamIcons(player, $"rui/hud/gametype_icons/obj_foreground_diamond", <15,15,0>, player.GetPlayerName())
        }
    }

    deathcam.m = CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", localplayer.GetOrigin(), localplayer.CameraAngles() )
    deathcam.e = CreateClientSidePointCamera( localplayer.GetOrigin(), localplayer.CameraAngles(), 90 )
    deathcam.e.SetParent( deathcam.m, "", false )
    localplayer.SetMenuCameraEntityWithAudio( deathcam.e )
    deathcam.e.SetTargetFOV( 90, true, EASING_CUBIC_INOUT, 0.50 )

    vector finalorg = campos + file.selectedLocation.deathcam.origin

    //Special Cases
    if(file.selectedLocation.name == "Tunnel")
        finalorg = file.selectedLocation.deathcam.origin
    else if(file.selectedLocation.name == "Drop Off")
        finalorg = file.selectedLocation.deathcam.origin

    deathcam.m.NonPhysicsMoveTo(finalorg, 0.60, 0, 0.30)
    deathcam.m.NonPhysicsRotateTo( file.selectedLocation.deathcam.angles, 0.60, 0, 0.30 )

    thread UpdateUIRespawnTimer()
}

void function AddTeamIcons(entity player, asset icon, vector iconsize, string text)
{
    var newicon = AddCaptureIcon( player, icon, false, $"ui/overhead_icon_generic.rpak")
	RuiSetFloat2( newicon, "iconSize", iconsize )
	RuiSetFloat( newicon, "distanceFade", 100000 )
	RuiSetBool( newicon, "adsFade", false )
	RuiSetString( newicon, "hint", text )

    teamicons.append(newicon)
}

void function UpdateUIRespawnTimer()
{
    int time = CTF_RESPAWN_TIMER
    while(time > -1)
    {
        RunUIScript( "UpdateRespawnTimer", time)

        if(time == 0)
        {
            DestoryTeamIcons()
            entity player = GetLocalClientPlayer()
            RunUIScript( "DisableClassSelect")
            thread waitrespawn(player)
        }

        time--
        wait 1
    }
}

void function DestoryTeamIcons()
{
    foreach ( iconvar in teamicons )
    {
        if(IsValid(iconvar))
            try { RuiDestroy(iconvar) } catch (exception2){ }
    }
}

void function ServerCallback_CTF_SetObjectiveText(int score)
{
    RunUIScript( "UpdateObjectiveText", score)
}

void function waitrespawn(entity player)
{
    try { deathcam.e.ClearParent(); deathcam.m.Destroy() } catch (exception){ }

    if(!isvoting)
    {
        RunUIScript( "CloseCTFRespawnMenu" )

        try {
            deathcam.m = CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", deathcam.e.GetOrigin(), deathcam.e.GetAngles() )
            deathcam.e.SetParent( deathcam.m, "", false )
            player.SetMenuCameraEntityWithAudio( deathcam.e )
            deathcam.m.NonPhysicsMoveTo( player.GetOrigin(), 0.6, 0.6 / 2, 0.6 / 2 )
            deathcam.m.NonPhysicsRotateTo( player.CameraAngles(), 0.6, 0.6 / 2, 0.6 / 2 )
        } catch (exception2){ }

        wait 0.6

        ShowScoreRUI(true)

        player.ClearMenuCameraEntity()
        HealthHUD_Update( player )
    }

    try { deathcam.e.ClearParent(); deathcam.e.Destroy(); deathcam.m.Destroy() } catch (exceptio2n){ }
}

void function ServerCallback_CTF_SetVoteMenuOpen(bool shouldOpen, int TeamWon)
{
    file.teamwon = TeamWon

    if( shouldOpen )
        thread CreateVotingUI()
    else
        thread DestroyVotingUI()
}

void function CreateVotingUI()
{
    hasvoted = false
    isvoting = true
    roundover = true

    EmitSoundOnEntity( GetLocalClientPlayer(), "Music_CharacterSelect_Wattson" )
    wait 3;
    ScreenFade(GetLocalClientPlayer(), 0, 0, 0, 255, 0.4, 0.5, FFADE_OUT | FFADE_PURGE)
    wait 0.9;

    DeleteScoreRUI(true)

    entity targetBackground = GetEntByScriptName( "target_char_sel_bg_new" )
    entity targetCamera = GetEntByScriptName( "target_char_sel_camera_new" )

    //Clear Winning Squad Data
    AddWinningSquadData( -1, -1)

    //Set Squad Data For Each Player In Winning Team
	foreach( int i, entity player in GetPlayerArrayOfTeam( file.teamwon ) )
    {
		AddWinningSquadData( i, player.GetEncodedEHandle())
    }

    thread ShowCTFVictorySequence()

    RunUIScript( "OpenCTFVoteMenu" )

    ScreenFade(GetLocalClientPlayer(), 0, 0, 0, 255, 0.3, 0.0, FFADE_IN | FFADE_PURGE)
}

void function DestroyVotingUI()
{
    isvoting = false
    
    FadeOutSoundOnEntity( GetLocalClientPlayer(), "Music_CharacterSelect_Wattson", 0.2 )
    ScreenCoverTransition( Time() + 0.2 )

    wait 1;

    GetLocalClientPlayer().ClearMenuCameraEntity()

    RunUIScript( "CloseCTFVoteMenu" )

    foreach( rui in overHeadRuis )
		RuiDestroyIfAlive( rui )

    foreach( entity ent in cleanupEnts )
		ent.Destroy()

    overHeadRuis.clear()
    cleanupEnts.clear()
}

void function UpdateUIVoteTimer()
{
    int time = 15
    while(time > -1)
    {
        RunUIScript( "UpdateVoteTimer", time)

        if (time <= 5 && time != 0)
            EmitSoundOnEntity( GetLocalClientPlayer(), "ui_ingame_markedfordeath_countdowntomarked" )

        if (time == 0)
            EmitSoundOnEntity( GetLocalClientPlayer(), "ui_ingame_markedfordeath_countdowntoyouaremarked" )

        time--

        wait 1
    }
}

void function UI_To_Client_VoteForMap(int mapid)
{
    if(hasvoted)
        return

    entity player = GetLocalClientPlayer()

    // why does s3 not have remote server functions..?
    player.ClientCommand("VoteForMap " + mapid)
    RunUIScript("UpdateVotedFor", mapid + 1)

    hasvoted = true
}

void function ServerCallback_CTF_UpdateMapVotesClient( int map1votes, int map2votes, int map3votes, int map4votes)
{
    RunUIScript("UpdateVotesUI", map1votes, map2votes, map3votes, map4votes)
}

void function ServerCallback_CTF_UpdateVotingMaps( int map1, int map2, int map3, int map4)
{
    RunUIScript("UpdateMapsForVoting", file.locationSettings[map1].name, file.locationSettings[map2].name, file.locationSettings[map3].name, file.locationSettings[map4].name)
}

void function ServerCallback_CTF_SetScreen(int screen, int team, int mapid, int done)
{
    switch(screen)
    {
        case eCTFScreen.WinnerScreen: //Sets the screen to the winners screen
            RunUIScript("SetCTFTeamWonScreen", GetWinningTeamText(team))
            break

        case eCTFScreen.VoteScreen: //Sets the screen to the vote screen
            EmitSoundOnEntity( GetLocalClientPlayer(), "UI_PostGame_CoinMove" )
            thread UpdateUIVoteTimer()
            RunUIScript("SetCTFVotingScreen")
            break

        case eCTFScreen.TiedScreen: //Sets the screen to the tied screen
            switch(done)
            {
            case 0:
                EmitSoundOnEntity( GetLocalClientPlayer(), "HUD_match_start_timer_tick_1P" )
                break
            case 1:
                EmitSoundOnEntity( GetLocalClientPlayer(),  "UI_PostGame_CoinMove" )
                break
            }

            if (mapid == 254)
                RunUIScript( "UpdateVotedLocationTied", "")
            else
                RunUIScript( "UpdateVotedLocationTied", file.locationSettings[mapid].name)
            break

        case eCTFScreen.SelectedScreen: //Sets the screen to the selected location screen
            EmitSoundOnEntity( GetLocalClientPlayer(), "UI_PostGame_Level_Up_Pilot" )
            RunUIScript( "UpdateVotedLocation", file.locationSettings[mapid].name)
            break

        case eCTFScreen.NextRoundScreen: //Sets the screen to the next round screen
            EmitSoundOnEntity( GetLocalClientPlayer(), "UI_PostGame_Level_Up_Pilot" )
            FadeOutSoundOnEntity( GetLocalClientPlayer(), "Music_CharacterSelect_Wattson", 0.2 )
            RunUIScript("SetCTFVoteMenuNextRound")
            break
    }
}

string function GetWinningTeamText(int team)
{
    string teamwon = ""
    switch(team)
    {
        case TEAM_IMC:
            teamwon = "IMC has won"
            break
        case TEAM_MILITIA:
            teamwon = "MILITIA has won"
            break
        case 69:
            teamwon = "Winner couldn't be decided"
            break
    }

    return teamwon
}

void function ServerCallback_CTF_UpdatePlayerStats(int id)
{
    entity player = GetLocalClientPlayer()

    switch(id)
    {
        case eCTFStats.Clear:
            GetEHIScriptStruct( player.GetEncodedEHandle() ).CTFCaptures = 0
	        GetEHIScriptStruct( player.GetEncodedEHandle() ).CTFKills = 0
            break
        case eCTFStats.Captures:
            GetEHIScriptStruct( player.GetEncodedEHandle() ).CTFCaptures++
            break
        case eCTFStats.Kills:
            GetEHIScriptStruct( player.GetEncodedEHandle() ).CTFKills++
            break
    }
}

//Orginal code from cl_gamemode_survival.nut
//Modifed slightly
void function ShowCTFVictorySequence()
{
	entity player = GetLocalClientPlayer()

    //Todo: each maps victory pos and ang
    file.victorySequencePosition = file.selectedLocation.victorypos.origin - < 0, 0, 52>
	file.victorySequenceAngles = file.selectedLocation.victorypos.angles

	asset defaultModel                = GetGlobalSettingsAsset( DEFAULT_PILOT_SETTINGS, "bodyModel" )
	LoadoutEntry loadoutSlotCharacter = Loadout_CharacterClass()
	vector characterAngles            = < file.victorySequenceAngles.x / 2.0, file.victorySequenceAngles.y, file.victorySequenceAngles.z >

	VictoryPlatformModelData victoryPlatformModelData = GetVictorySequencePlatformModel()
	entity platformModel

	int maxPlayersToShow = 9

	if ( victoryPlatformModelData.isSet )
	{
		platformModel = CreateClientSidePropDynamic( file.victorySequencePosition + victoryPlatformModelData.originOffset, victoryPlatformModelData.modelAngles, $"mdl/dev/empty_model.rmdl" )

		cleanupEnts.append( platformModel )
		int playersOnPodium = 0

		VictorySequenceOrderLocalPlayerFirst( player )

		foreach( int i, SquadSummaryPlayerData data in file.winnerSquadSummaryData.playerData )
		{
			if ( maxPlayersToShow > 0 && i > maxPlayersToShow )
				break

			string playerName = ""
			if ( EHIHasValidScriptStruct( data.eHandle ) )
				playerName = EHI_GetName( data.eHandle )

			if ( !LoadoutSlot_IsReady( data.eHandle, loadoutSlotCharacter ) )
				continue

			ItemFlavor character = LoadoutSlot_GetItemFlavor( data.eHandle, loadoutSlotCharacter )

			if ( !LoadoutSlot_IsReady( data.eHandle, Loadout_CharacterSkin( character ) ) )
				continue

			ItemFlavor characterSkin = LoadoutSlot_GetItemFlavor( data.eHandle, Loadout_CharacterSkin( character ) )

			vector pos = GetVictorySquadFormationPosition( file.victorySequencePosition, file.victorySequenceAngles, i )
			entity characterNode = CreateScriptRef( pos, characterAngles )
			characterNode.SetParent( platformModel, "", true )

			entity characterModel = CreateClientSidePropDynamic( pos, characterAngles, defaultModel )
			SetForceDrawWhileParented( characterModel, true )
			characterModel.MakeSafeForUIScriptHack()
			CharacterSkin_Apply( characterModel, characterSkin )

			cleanupEnts.append( characterModel )

			foreach( func in s_callbacks_OnVictoryCharacterModelSpawned )
				func( characterModel, character, data.eHandle )

			characterModel.SetParent( characterNode, "", false )
			string victoryAnim = "ACT_MP_MENU_LOBBY_SELECT_IDLE"
			characterModel.Anim_Play( victoryAnim )
			characterModel.Anim_EnableUseAnimatedRefAttachmentInsteadOfRootMotion()

			float duration = characterModel.GetSequenceDuration( victoryAnim )
			float initialTime = RandomFloatRange( 0, duration )
			characterModel.Anim_SetInitialTime( initialTime )

			entity overheadNameEnt = CreateClientSidePropDynamic( pos + (AnglesToUp( file.victorySequenceAngles ) * 78), <0, 0, 0>, $"mdl/dev/empty_model.rmdl" )
			overheadNameEnt.Hide()

			var overheadRuiName = RuiCreate( $"ui/winning_squad_member_overhead_name.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 0 )
			RuiSetString(overheadRuiName, "playerName", playerName)
			RuiTrackFloat3(overheadRuiName, "position", overheadNameEnt, RUI_TRACK_ABSORIGIN_FOLLOW)

			overHeadRuis.append( overheadRuiName )

			playersOnPodium++
		}

		string dialogueApexChampion
        if (file.teamwon == TEAM_IMC || file.teamwon == TEAM_MILITIA)
        {
            if (player.GetTeam() == file.teamwon)
            {
                if ( playersOnPodium > 1 )
                    dialogueApexChampion = "diag_ap_aiNotify_winnerFound_07"
                else
                    dialogueApexChampion = "diag_ap_aiNotify_winnerFound_10"
            }
            else
            {
                if ( playersOnPodium > 1 )
                    dialogueApexChampion = "diag_ap_aiNotify_winnerFound_08"
                else
                    dialogueApexChampion = "diag_ap_ainotify_introchampion_01_02"
            }

            EmitSoundOnEntityAfterDelay( platformModel, dialogueApexChampion, 0.5 )
        }

		//Setup camera pos and angles
		vector camera_start_pos = OffsetPointRelativeToVector( file.victorySequencePosition, <0, 480, 108>, AnglesToForward( file.victorySequenceAngles ) )
		vector camera_end_pos   = OffsetPointRelativeToVector( file.victorySequencePosition, <0, 350, 88>, AnglesToForward( file.victorySequenceAngles ) )
		vector camera_focus_pos = OffsetPointRelativeToVector( file.victorySequencePosition, <0, 0, 56>, AnglesToForward( file.victorySequenceAngles ) )
		vector camera_start_angles = VectorToAngles( camera_focus_pos - camera_start_pos )
		vector camera_end_angles   = VectorToAngles( camera_focus_pos - camera_end_pos )

        //Create camera and mover
		entity cameraMover = CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", camera_start_pos, camera_start_angles )
		entity camera      = CreateClientSidePointCamera( camera_start_pos, camera_start_angles, 35.5 )
		player.SetMenuCameraEntity( camera )
		camera.SetTargetFOV( 35.5, true, EASING_CUBIC_INOUT, 0.0 )
		camera.SetParent( cameraMover, "", false )
		cleanupEnts.append( camera )

		//Move camera to end pos
		cameraMover.NonPhysicsMoveTo( camera_end_pos, 6, 0.0, 6 / 2.0 )
		cameraMover.NonPhysicsRotateTo( camera_end_angles, 6, 0.0, 6 / 2.0 )
		cleanupEnts.append( cameraMover )
	}
}

void function AddWinningSquadData( int index, int eHandle)
{
	if ( index == -1 )
	{
		file.winnerSquadSummaryData.playerData.clear()
		file.winnerSquadSummaryData.squadPlacement = -1
		return
	}

	SquadSummaryPlayerData data
	data.eHandle = eHandle
	file.winnerSquadSummaryData.playerData.append( data )
	file.winnerSquadSummaryData.squadPlacement = 1
}

void function VictorySequenceOrderLocalPlayerFirst( entity player )
{
	int playerEHandle = player.GetEncodedEHandle()
	bool hadLocalPlayer = false
	array<SquadSummaryPlayerData> playerDataArray
	SquadSummaryPlayerData localPlayerData

	foreach( SquadSummaryPlayerData data in file.winnerSquadSummaryData.playerData )
	{
		if ( data.eHandle == playerEHandle )
		{
			localPlayerData = data
			hadLocalPlayer = true
			continue
		}

		playerDataArray.append( data )
	}

	file.winnerSquadSummaryData.playerData = playerDataArray
	if ( hadLocalPlayer )
		file.winnerSquadSummaryData.playerData.insert( 0, localPlayerData )
}

vector function GetVictorySquadFormationPosition( vector mainPosition, vector angles, int index )
{
	if ( index == 0 )
		return mainPosition - <0, 0, 8>

	float offset_side = 48.0
	float offset_back = -28.0

	int groupOffsetIndex = index / 3
	int internalGroupOffsetIndex = index % 3

	float internalGroupOffsetSide = 34.0                                                                                           
	float internalGroupOffsetBack = -38.0                                                                              

	float groupOffsetSide = 114.0                                                                                            
	float groupOffsetBack = -64.0                                                                               

	float finalOffsetSide = ( groupOffsetSide * ( groupOffsetIndex % 2 == 0 ? 1 : -1 ) * ( groupOffsetIndex == 0 ? 0 : 1 ) ) + ( internalGroupOffsetSide * ( internalGroupOffsetIndex % 2 == 0 ? 1 : -1 ) * ( internalGroupOffsetIndex == 0 ? 0 : 1 ) )
	float finalOffsetBack = ( groupOffsetBack * ( groupOffsetIndex == 0 ? 0 : 1 ) ) + ( internalGroupOffsetBack * ( internalGroupOffsetIndex == 0 ? 0 : 1 ) )

	vector offset = < finalOffsetSide, finalOffsetBack, -8 >
	return OffsetPointRelativeToVector( mainPosition, offset, AnglesToForward( angles ) )
}

array<void functionref( entity, ItemFlavor, int )> s_callbacks_OnVictoryCharacterModelSpawned