// Credits
// AyeZee#6969 -- ctf gamemode and ui
// sal#3261 -- base custom_tdm mode to work off
// Retículo Endoplasmático#5955 -- giving me the ctf sound names
// everyone else -- advice

global function Cl_CustomCTF_Init

//Server Callbacks
global function ServerCallback_CTF_DoAnnouncement
global function ServerCallback_CTF_PointCaptured
global function ServerCallback_CTF_TeamText
global function ServerCallback_CTF_FlagCaptured
global function ServerCallback_CTF_CustomMessages
global function ServerCallback_CTF_OpenCTFRespawnMenu
global function ServerCallback_CTF_SetSelectedLocation
global function ServerCallback_CTF_SetObjectiveText
global function ServerCallback_CTF_AddPointIcon
global function ServerCallback_CTF_RecaptureFlag
global function ServerCallback_CTF_ResetFlagIcons
global function ServerCallback_CTF_SetPointIconHint
global function ServerCallback_CTF_SetCorrectTime
global function ServerCallback_CTF_UpdatePlayerStats
global function ServerCallback_CTF_CheckUpdatePlayerLegend
global function ServerCallback_CTF_PickedUpFlag
global function ServerCallback_CTF_HideCustomUI
// Voting
global function ServerCallback_CTF_SetVoteMenuOpen
global function ServerCallback_CTF_UpdateVotingMaps
global function ServerCallback_CTF_UpdateMapVotesClient
global function ServerCallback_CTF_SetScreen
global function ServerCallback_CTF_BuildClientMessage
global function ServerCallback_CTF_PrintClientMessage

//Ui callbacks
global function UI_To_Client_VoteForMap
global function UI_To_Client_UpdateSelectedClass

global function Cl_CTFRegisterLocation
global function Cl_CTFRegisterCTFClass

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
    if(GLOBAL_CHAT_ENABLED)
        RegisterButtonPressedCallback(KEY_ENTER, SendChat);

    AddClientCallback_OnResolutionChanged( GetTimeFromServer )
    RegisterConCommandTriggeredCallback( "+use_alt", SendDropFlagToServer )

    //Pak is released when vm is destroyed
    CTFRpak = RequestPakFile( "ctf_mode" )
}

void function SendChat(var button)
{
	var chat = HudElement( "IngameTextChat" )
	var chatTextEntry = Hud_GetChild( Hud_GetChild( chat, "ChatInputLine" ), "ChatInputTextEntry" )

	if(CHAT_TEXT != "" && !IsChatOverflow(CHAT_TEXT.len()))
	{
		string text = "say " + CHAT_TEXT
		GetLocalClientPlayer().ClientCommand(text)
	}	
}

void function SetChatSize()
{
    var chat = HudElement( "IngameTextChat" )
	Hud_SetHeight( chat, 300 )
    Hud_SetWidth( chat, 800 )
}

bool function IsChatOverflow(int len)
{
	if(len > 126 - (int(GetLocalClientPlayer().GetPlayerName().len() * 2.5) + 1))
		return true
	return false
}

void function HideChatAfterDelay()
{
    if(hidechat) {
        hidechatcountdown = 10
        return
    }

    hidechatcountdown = 10
    hidechat = true

    while(hidechatcountdown > 0)
    {
        hidechatcountdown--
        wait 1
    }

    var chatHistory = Hud_GetChild( HudElement( "IngameTextChat" ), "HudChatHistory")
    Hud_SetText( chatHistory, "" )
    hidechat = false
}

void function ServerCallback_CTF_PrintClientMessage()
{
    //Easier to just set the size every client message
    SetChatSize()

    //If old message array > 7 then remove the first message
    if(savedmessages.len() > 7)
        savedmessages.remove(0)

    if(savedmessages.len() > 0)
        savedmessages.append("\n" + client_messageString)
    else
        savedmessages.append(client_messageString)

    string finishedtext = ""

    //Add each old message to the finished string
    foreach(string message in savedmessages) {
        finishedtext += message
    }

    var chatHistory = Hud_GetChild( HudElement( "IngameTextChat" ), "HudChatHistory")
    Hud_SetText( chatHistory, finishedtext )

    client_messageString = ""

    thread HideChatAfterDelay()
}

void function ServerCallback_CTF_BuildClientMessage( ... )
{
	for ( int i = 0; i < vargc; i++ )
		client_messageString += format("%c", vargv[i] )
}

void function ServerCallback_CTF_HideCustomUI()
{
    ShowScoreRUI(false)
}

void function SendDropFlagToServer( entity localPlayer )
{
	GetLocalClientPlayer().ClientCommand("DropFlag")
}

void function ServerCallback_CTF_SetCorrectTime(int serverseconds)
{
    clientgametimer.seconds = serverseconds
}

void function GetTimeFromServer()
{
    GetLocalClientPlayer().ClientCommand("GetTimeFromServer")
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
    }
    else
    {
        if (FlagRUI.FlagReturnRUI != null)
        {
            try { RuiDestroy(FlagRUI.FlagReturnRUI) } catch (pe1){ }
            FlagRUI.FlagReturnRUI = null
        }
    }
}

void function ServerCallback_CTF_ResetFlagIcons()
{
    try { RuiDestroy(FlagRUI.IMCpointicon) } catch (pe1){  }
    try { RuiDestroy(FlagRUI.MILITIApointicon) } catch (pe2){ }

    FlagRUI.IMCpointicon = null
    FlagRUI.MILITIApointicon = null
}

void function ServerCallback_CTF_AddPointIcon(entity imcflag, entity milflag, int team)
{
    ClientCodeCallback_MinimapEntitySpawned(imcflag)
    ClientCodeCallback_MinimapEntitySpawned(milflag)
    switch(team)
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
            if ( IsValid( rui ) )
                try { RuiDestroy( rui ) } catch (pe3){ }

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
        UISize screenSize = GetScreenSize()
        var screenAlignmentTopo = RuiTopology_CreatePlane( <float( screenSize.width ) * 0.25, 0, 0>, <float( screenSize.width ), 0, 0>, <0, float( screenSize.height ) + 100, 0>, false )
        file.dropflagrui = RuiCreate( $"ui/announcement_quick_right.rpak", screenAlignmentTopo, RUI_DRAW_HUD, RUI_SORT_SCREENFADE + 1 )

        RuiSetGameTime( file.dropflagrui, "startTime", Time() )
        RuiSetString( file.dropflagrui, "messageText", "Press %use_alt% to drop the flag" )
        RuiSetFloat( file.dropflagrui, "duration", 9999999 )
        RuiSetFloat3( file.dropflagrui, "eventColor", color )

        file.baseiconmdl = CreateClientSidePropDynamic( emptymdlloc + <0,0,100>, <0,0,0>, $"mdl/dev/empty_model.rmdl" )
        file.baseicon = AddCaptureIcon( file.baseiconmdl, icon, false, $"ui/overhead_icon_generic.rpak")
        RuiSetFloat2( file.baseicon, "iconSize", <25,25,0> )
        RuiSetFloat( file.baseicon, "distanceFade", 100000 )
        RuiSetBool( file.baseicon, "adsFade", false )
        RuiSetString( file.baseicon, "hint", "" )

    }
    else
    {
        if(IsValid( file.dropflagrui ))
            RuiDestroy( file.dropflagrui )

        if(IsValid( file.baseicon ))
            RuiDestroy( file.baseicon )

        if(IsValid( file.baseiconmdl ))
            file.baseiconmdl.Destroy()
    }
}

void function MakeScoreRUI()
{
    if ( file.teamRui != null)
        return

    var compass = GetCompassRui()
    if ( IsValid( compass ) )
        RuiDestroy( compass )

    clGlobal.levelEnt.EndSignal( "CloseScoreRUI" )

    UISize screenSize = GetScreenSize()

    var logoTopo = RuiTopology_CreatePlane( <(screenSize.width / 2) - 25, 25, 0>, <50, 0, 0>, <0, 50, 0>, false )
    file.teamRui = RuiCreate( $"ui/basic_image.rpak", logoTopo, RUI_DRAW_HUD, RUI_SORT_SCREENFADE + 1)
    asset icon
    if(GetLocalClientPlayer().GetTeam() == TEAM_IMC)
        icon = $"rui/gamemodes/capture_the_flag/imc_logo"
    else
        icon = $"rui/gamemodes/capture_the_flag/mil_logo"

    var screenAlignmentTopoTimer = RuiTopology_CreatePlane( <(screenSize.width / 2) - 135, -305, 0>, <200, 0, 0>, <0, 800, 0>, false )
    teamscore.timer = RuiCreate( $"ui/announcement_quick_right.rpak", screenAlignmentTopoTimer, RUI_DRAW_HUD, RUI_SORT_SCREENFADE + 1 )

    RuiSetGameTime( teamscore.timer, "startTime", Time() )
    RuiSetString( teamscore.timer, "messageText", "00:00" )
    RuiSetFloat( teamscore.timer, "duration", 9999999 )
    RuiSetFloat3( teamscore.timer, "eventColor", SrgbToLinear( <128, 188, 255> ) )

    RuiSetImage( file.teamRui, "basicImage", icon)

    if(GetLocalClientPlayer().GetTeam() == TEAM_SPECTATOR)
        RuiSetVisible( file.teamRui, false )

    OnThreadEnd(
		function() : ()
		{
            if ( IsValid( file.teamRui ) )
			    try { RuiDestroy( file.teamRui ) } catch (pe4){ }

            if ( IsValid( teamscore.timer ) )
			    try { RuiDestroy( teamscore.timer ) } catch (pe4){ }

            teamscore.timer = null
            file.teamRui = null
		}
	)

    WaitForever()
}

void function ServerCallback_CTF_DoAnnouncement(float duration, int type, float starttime)
{
    string message = ""
    string subtext = ""
    switch(type)
    {

        case eCTFAnnounce.ROUND_START:
        {
            thread MakeScoreRUI();
            //message = "Round start"
            message = "Match Start"
            subtext = "Score 5 points to win!"

            //Timer Stuff
            roundover = false
            clientgametimer.gamestarttime = starttime.tointeger()
            clientgametimer.endingtime = clientgametimer.gamestarttime + CTF_ROUNDTIME
            clientgametimer.seconds = 60
            thread StartGameTimer()
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

void function StartGameTimer()
{
    //Filler for when time is < 10
    string secondsfiller = ""
    string minsfiller = ""

	while (!roundover)
	{
        //Calculate Elapsed Time
        int elapsedtime = clientgametimer.endingtime - Time().tointeger()

        //Calculate Seconds To Minutes
		int minutes = floor( elapsedtime / 60 ).tointeger()

        //If Seconds is < 1 Set Back To 60
        if(clientgametimer.seconds < 1)
            clientgametimer.seconds = 60

        //This isnt needed but is there to make the time left counter look nicer when the timer is < 10
        if(clientgametimer.seconds < 10)
            secondsfiller = "0"
        else
            secondsfiller = ""

        //This isnt needed but is there to make the time left counter look nicer when the timer is < 10
        if(minutes < 10)
            minsfiller = "0"
        else
            minsfiller = ""

        //Update the counter on the UI
        RunUIScript("SetGameTimer", minsfiller + minutes + ":" + secondsfiller + clientgametimer.seconds)

        if(IsValid(teamscore.timer))
            RuiSetString( teamscore.timer, "messageText", minsfiller + minutes + ":" + secondsfiller + clientgametimer.seconds )

		wait 1
        clientgametimer.seconds--
	}
}

void function ServerCallback_CTF_PointCaptured(int IMC, int MIL)
{
    RunUIScript("SetCTFScores", IMC, MIL, CTF_SCORE_GOAL_TO_WIN)

    int startwidth = 400 / CTF_SCORE_GOAL_TO_WIN
    int imcwidth = startwidth * IMC
    int milwidth = startwidth * MIL

    UISize screenSize = GetScreenSize()

    DeleteScoreRUI(false)

    //Alignment
    var screenAlignmentTopoIMCBG = RuiTopology_CreatePlane( <(screenSize.width / 2) - 420, 100, 0>, <400, 0, 0>, <0, 10, 0>, false )
    var screenAlignmentTopoMILBG = RuiTopology_CreatePlane( <(screenSize.width / 2) + 20, 100, 0>, <400, 0, 0>, <0, 10, 0>, false )
    var screenAlignmentTopoIMC = RuiTopology_CreatePlane( <(screenSize.width / 2) - (imcwidth + 20), 100, 0>, <imcwidth, 0, 0>, <0, 10, 0>, false )
    var screenAlignmentTopoMIL = RuiTopology_CreatePlane( <(screenSize.width / 2) + 20, 100, 0>, <milwidth, 0, 0>, <0, 10, 0>, false )
    var screenAlignmentTopoMILText = RuiTopology_CreatePlane( <(screenSize.width / 2) - 200, -230, 0>, <400, 0, 0>, <0, 600, 0>, false )
    var screenAlignmentTopoMILScore = RuiTopology_CreatePlane( <(screenSize.width / 2) + 125, -230, 0>, <400, 0, 0>, <0, 600, 0>, false )
    var screenAlignmentTopoIMCText = RuiTopology_CreatePlane( <(screenSize.width / 2) - 269, -230, 0>, <400, 0, 0>, <0, 600, 0>, false )
    var screenAlignmentTopoIMCScore = RuiTopology_CreatePlane( <(screenSize.width / 2) - 640, -230, 0>, <400, 0, 0>, <0, 600, 0>, false )

    teamscore.imcscorebg = RuiCreate( $"ui/basic_image.rpak", screenAlignmentTopoIMCBG, RUI_DRAW_HUD, RUI_SORT_SCREENFADE + 1)
    RuiSetFloat3( teamscore.imcscorebg, "basicImageColor", SrgbToLinear( <30, 30, 30> / 255 ))

    teamscore.milscorebg = RuiCreate( $"ui/basic_image.rpak", screenAlignmentTopoMILBG, RUI_DRAW_HUD, RUI_SORT_SCREENFADE + 1)
    RuiSetFloat3( teamscore.milscorebg, "basicImageColor", SrgbToLinear( <30, 30, 30> / 255 ))

    teamscore.imcscorecurrentbg = RuiCreate( $"ui/basic_image.rpak", screenAlignmentTopoIMC, RUI_DRAW_HUD, RUI_SORT_SCREENFADE + 1)
    RuiSetFloat3( teamscore.imcscorecurrentbg, "basicImageColor", SrgbToLinear( <100, 100, 255> / 255 ))

    teamscore.milscorecurrentbg = RuiCreate( $"ui/basic_image.rpak", screenAlignmentTopoMIL, RUI_DRAW_HUD, RUI_SORT_SCREENFADE + 1)
    RuiSetFloat3( teamscore.milscorecurrentbg, "basicImageColor", SrgbToLinear( <255, 100, 100> / 255 ))

    if(!IsValid(teamscore.miltext))
    {
        teamscore.miltext = RuiCreate( $"ui/announcement_quick_right.rpak", screenAlignmentTopoMILText, RUI_DRAW_HUD, RUI_SORT_SCREENFADE + 1 )
        RuiSetGameTime( teamscore.miltext, "startTime", Time() )
        RuiSetString( teamscore.miltext, "messageText", "MILITIA" )
        RuiSetFloat( teamscore.miltext, "duration", 9999999 )
        RuiSetFloat3( teamscore.miltext, "eventColor", SrgbToLinear( <128, 188, 255> ) )
    }

    if(!IsValid(teamscore.imctext))
    {
        teamscore.imctext = RuiCreate( $"ui/announcement_quick_right.rpak", screenAlignmentTopoIMCText, RUI_DRAW_HUD, RUI_SORT_SCREENFADE + 1 )
        RuiSetGameTime( teamscore.imctext, "startTime", Time() )
        RuiSetString( teamscore.imctext, "messageText", "IMC" )
        RuiSetFloat( teamscore.imctext, "duration", 9999999 )
        RuiSetFloat3( teamscore.imctext, "eventColor", SrgbToLinear( <128, 188, 255> ) )
    }

    if(IMC > teamscore.imcscore2 || !IsValid( teamscore.imcscore ))
    {
        if ( IsValid( teamscore.imcscore ) )
	        try { RuiDestroy( teamscore.imcscore ) } catch (pe4){ }

        teamscore.imcscore = RuiCreate( $"ui/announcement_quick_right.rpak", screenAlignmentTopoIMCScore, RUI_DRAW_HUD, RUI_SORT_SCREENFADE + 1 )
        RuiSetGameTime( teamscore.imcscore, "startTime", Time() )
        RuiSetString( teamscore.imcscore, "messageText", "Captures: " + IMC)
        RuiSetFloat( teamscore.imcscore, "duration", 9999999 )
        RuiSetFloat3( teamscore.imcscore, "eventColor", SrgbToLinear( <100, 100, 255> / 255 ))
    }

    if(MIL > teamscore.milscore2 || !IsValid( teamscore.milscore ))
    {
        if ( IsValid( teamscore.milscore ) )
	        try { RuiDestroy( teamscore.milscore ) } catch (pe4){ }

        teamscore.milscore = RuiCreate( $"ui/announcement_quick_right.rpak", screenAlignmentTopoMILScore, RUI_DRAW_HUD, RUI_SORT_SCREENFADE + 1 )
        RuiSetGameTime( teamscore.milscore, "startTime", Time() )
        RuiSetString( teamscore.milscore, "messageText", "Captures: " + MIL )
        RuiSetFloat( teamscore.milscore, "duration", 9999999 )
        RuiSetFloat3( teamscore.milscore, "eventColor", SrgbToLinear( <255, 100, 100> / 255 ))
    }

    teamscore.milscore2 = MIL
    teamscore.imcscore2 = IMC
}

void function DeleteScoreRUI(bool newround)
{
    if ( IsValid(  teamscore.imcscorecurrentbg ) )
		try { RuiDestroy(  teamscore.imcscorecurrentbg ) } catch (pe4){ }

    if ( IsValid( teamscore.milscorecurrentbg ) )
	    try { RuiDestroy( teamscore.milscorecurrentbg ) } catch (pe4){ }

    if ( IsValid( teamscore.imcscorebg ) )
		try { RuiDestroy( teamscore.imcscorebg ) } catch (pe4){ }

    if ( IsValid( teamscore.milscorebg ) )
        try { RuiDestroy( teamscore.milscorebg ) } catch (pe4){ }

    teamscore.milscorebg = null
    teamscore.imcscorebg = null
    teamscore.milscorecurrentbg = null
    teamscore.imcscorecurrentbg = null

    if(newround)
    {
        if ( IsValid(  teamscore.imcscore ) )
		    try { RuiDestroy(  teamscore.imcscore ) } catch (pe4){ }

        if ( IsValid( teamscore.milscore ) )
            try { RuiDestroy( teamscore.milscore ) } catch (pe4){ }

        if ( IsValid( teamscore.miltext ) )
            try { RuiDestroy( teamscore.miltext ) } catch (pe4){ }

        if ( IsValid( teamscore.imctext ) )
            try { RuiDestroy( teamscore.imctext ) } catch (pe4){ }

        teamscore.imcscore = null
        teamscore.milscore = null
        teamscore.miltext = null
        teamscore.imctext = null
    }
}

void function ShowScoreRUI(bool show)
{
    if ( IsValid(  teamscore.imcscorecurrentbg ) )
		RuiSetVisible(  teamscore.imcscorecurrentbg, show )

    if ( IsValid( teamscore.milscorecurrentbg ) )
	    RuiSetVisible( teamscore.milscorecurrentbg, show )

    if ( IsValid( teamscore.imcscorebg ) )
		RuiSetVisible( teamscore.imcscorebg, show )

    if ( IsValid( teamscore.milscorebg ) )
		RuiSetVisible( teamscore.milscorebg, show )

    if ( IsValid( teamscore.miltext ) )
		RuiSetVisible( teamscore.miltext, show )

    if ( IsValid(  teamscore.imctext ) )
		RuiSetVisible(  teamscore.imctext, show )

    if ( IsValid( teamscore.imcscore ) )
	    RuiSetVisible( teamscore.imcscore, show )

    if ( IsValid( teamscore.milscore ) )
		RuiSetVisible( teamscore.milscore, show )

    if ( IsValid( teamscore.timer ))
        RuiSetVisible( teamscore.timer, show )

    if ( IsValid( file.teamRui ))
        RuiSetVisible( file.teamRui, show )
}

void function ServerCallback_CTF_TeamText(int team)
{
    if(file.teamRui)
    {
        switch(team)
        {
            case TEAM_IMC:
                RuiSetImage( file.teamRui, "basicImage", $"rui/gamemodes/capture_the_flag/imc_logo")
                break
            case TEAM_MILITIA:
                RuiSetImage( file.teamRui, "basicImage", $"rui/gamemodes/capture_the_flag/mil_logo")
                break
        }
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
    ShowScoreRUI(false)

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
    ShowScoreRUI(true)

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