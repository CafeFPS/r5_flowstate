// Credits
// AyeZee#6969 -- ctf gamemode and ui
// sal#3261 -- base custom_tdm mode to work off
// Retículo Endoplasmático#5955 -- giving me the ctf sound names
// everyone else -- advice

global function Cl_CustomCTF_Init

//Lots of server callbacks
global function ServerCallback_CTF_DoAnnouncement
global function ServerCallback_CTF_PointCaptured
global function ServerCallback_CTF_TeamText
global function ServerCallback_CTF_EnemyCaptured
global function ServerCallback_CTF_TeamCaptured
global function ServerCallback_CTF_CustomMessages
global function ServerCallback_CTF_PlayerDied
global function ServerCallback_CTF_PlayerSpawning
global function ServerCallback_CTF_OpenCTFRespawnMenu
global function ServerCallback_CTF_SetSelectedLocation
global function ServerCallback_CTF_TeamWon
global function ServerCallback_CTF_UpdateDamage
global function ServerCallback_CTF_SetObjectiveText
global function ServerCallback_CTF_AddPointIcon
global function ServerCallback_CTF_RecaptureFlag
global function ServerCallback_CTF_EndRecaptureFlag
global function ServerCallback_CTF_ResetFlagIcons
global function ServerCallback_CTF_SetPointIconHint

global function Cl_CTFRegisterLocation

struct {

    LocationSettingsCTF &selectedLocation
    array choices
    array<LocationSettingsCTF> locationSettings
    var scoreRui
    var teamRui
} file;

var IMCpointicon = null
var MILITIApointicon = null
var FlagReturnRUI = null

entity Deathcam
entity cameraMover

array<var> teamicons

void function Cl_CustomCTF_Init()
{
}

void function Cl_CTFRegisterLocation(LocationSettingsCTF locationSettings)
{
    file.locationSettings.append(locationSettings)
}

void function ServerCallback_CTF_SetSelectedLocation(int sel)
{
    file.selectedLocation = file.locationSettings[sel]
}

vector function GetDeathcamHeight()
{
    vector height
    switch(file.selectedLocation.name)
    {
        case "Relay":
            height = <0,0,6000> // Done
            break
        case "WetLands":
            height = <0,0,7000> // Done
            break
        case "Repulsor":
            height = <0,0,7000> // Done
            break
        case "Skull Town":
            height = <0,0,7000> // Done
            break
        case "Refinery":
            height = <0,0,7000> // Done
            break
        case "Capitol City":
            height = <0,0,7000> // Done
            break
        case "Sorting Factory":
            height = <0,0,7000> // Done
            break
        default:
            height = <0,0,5000>
            break
    }

    return height
}

vector function GetDeathcamAng()
{
    vector angles
    switch(file.selectedLocation.name)
    {
        case "Firing Range":
            angles = <90,180,0>
            break
        case "Artillery":
            angles = <90,90,0> // Done
            break
        case "Airbase":
            angles = <90,0,0> // Done
            break
        case "Relay":
            angles = <90,-90,0> // Done
            break
        case "WetLands":
            angles = <90,90,0> // Done
            break
        case "Repulsor":
            angles = <90,90,0> // Done
            break
        case "Skull Town":
            angles = <90,-45,0> // Done
            break
        case "Overlook":
            angles = <90,27,0> // Done
            break
        case "Refinery":
            angles = <90,-165,0> // Done
            break
        case "Capitol City":
            angles = <90,-85,0> // Done
            break
        case "Sorting Factory":
            angles = <90,-45,0> // Done
            break
        default:
            angles = <90,0,0> // Done
            break
    }

    return angles
}

void function ServerCallback_CTF_RecaptureFlag(int team, float starttime, float endtime)
{
    FlagReturnRUI = CreateFullscreenRui( $"ui/health_use_progress.rpak" )
    RuiSetBool( FlagReturnRUI, "isVisible", true )
	RuiSetImage( FlagReturnRUI, "icon", $"rui/hud/gametype_icons/survival/survey_beacon_only_pathfinder" )
	RuiSetGameTime( FlagReturnRUI, "startTime", starttime )
	RuiSetGameTime( FlagReturnRUI, "endTime", endtime )
    RuiSetString( FlagReturnRUI, "hintKeyboardMouse", "Returning Flag To Base" )
	RuiSetString( FlagReturnRUI, "hintController", "Returning Flag To Base" )
}

void function ServerCallback_CTF_EndRecaptureFlag()
{
    if (FlagReturnRUI != null)
    {
        try {
            RuiDestroy(FlagReturnRUI)
        } catch (pe1){
        
        }
        FlagReturnRUI = null
    }
}

void function ServerCallback_CTF_ResetFlagIcons()
{

    try {
        RuiDestroy(IMCpointicon)
    } catch (pe1){
        
    }

    try {
        RuiDestroy(MILITIApointicon)
    } catch (pe2){
        
    }

    IMCpointicon = null
    MILITIApointicon = null
}

void function ServerCallback_CTF_AddPointIcon(entity imcflag, entity milflag, int team)
{
    if (team == TEAM_IMC)
    {
        if (IMCpointicon == null)
        {
            asset icon = $"rui/hud/gametype_icons/survival/survey_beacon_only_pathfinder"
            bool pinToEdge = true
            asset ruiFile = $"ui/overhead_icon_generic.rpak"

            IMCpointicon = AddCaptureIcon( imcflag, icon, pinToEdge, ruiFile)
		    RuiSetFloat2( IMCpointicon, "iconSize", <40,40,0> )
		    RuiSetFloat( IMCpointicon, "distanceFade", 100000 )
		    RuiSetBool( IMCpointicon, "adsFade", false )
		    RuiSetString( IMCpointicon, "hint", "Defend" )
        }

        if (MILITIApointicon == null)
        {
            asset icon = $"rui/hud/gametype_icons/survival/survey_beacon_only_pathfinder"
            bool pinToEdge = true
            asset ruiFile = $"ui/overhead_icon_generic.rpak"

            MILITIApointicon = AddCaptureIcon( milflag, icon, pinToEdge, ruiFile)
		    RuiSetFloat2( MILITIApointicon, "iconSize", <40,40,0> )
		    RuiSetFloat( MILITIApointicon, "distanceFade", 100000 )
		    RuiSetBool( MILITIApointicon, "adsFade", false )
		    RuiSetString( MILITIApointicon, "hint", "Capture" )
        }
    }

    if (team == TEAM_MILITIA)
    {
        if (IMCpointicon == null)
        {
            asset icon = $"rui/hud/gametype_icons/survival/survey_beacon_only_pathfinder"
            bool pinToEdge = true
            asset ruiFile = $"ui/overhead_icon_generic.rpak"

            IMCpointicon = AddCaptureIcon( imcflag, icon, pinToEdge, ruiFile)
		    RuiSetFloat2( IMCpointicon, "iconSize", <40,40,0> )
		    RuiSetFloat( IMCpointicon, "distanceFade", 100000 )
		    RuiSetBool( IMCpointicon, "adsFade", false )
		    RuiSetString( IMCpointicon, "hint", "Capture" )
        }

        if (MILITIApointicon == null)
        {
            asset icon = $"rui/hud/gametype_icons/survival/survey_beacon_only_pathfinder"
            bool pinToEdge = true
            asset ruiFile = $"ui/overhead_icon_generic.rpak"

            MILITIApointicon = AddCaptureIcon( milflag, icon, pinToEdge, ruiFile)
		    RuiSetFloat2( MILITIApointicon, "iconSize", <40,40,0> )
		    RuiSetFloat( MILITIApointicon, "distanceFade", 100000 )
		    RuiSetBool( MILITIApointicon, "adsFade", false )
		    RuiSetString( MILITIApointicon, "hint", "Defend" )
        }
    }
}

void function ServerCallback_CTF_SetPointIconHint(int teamflag, int messageid)
{
    try {
    
    if(teamflag == TEAM_IMC)
    {
        if(IMCpointicon == null)
            return
        
        if(messageid == CTF_Defend)
            RuiSetString( IMCpointicon, "hint", "Defend" )
        else if(messageid == CTF_Capture)
            RuiSetString( IMCpointicon, "hint", "Capture" )
        else if(messageid == CTF_Attack)
            RuiSetString( IMCpointicon, "hint", "Attack" )
        else if(messageid == CTF_Escort)
            RuiSetString( IMCpointicon, "hint", "Escort" )
        else if(messageid == CTF_Return)
            RuiSetString( IMCpointicon, "hint", "Return" )
        
    }
    else if (teamflag == TEAM_MILITIA)
    {
        if(MILITIApointicon == null)
            return
        
        if(messageid == CTF_Defend)
            RuiSetString( MILITIApointicon, "hint", "Defend" )
        else if(messageid == CTF_Capture)
            RuiSetString( MILITIApointicon, "hint", "Capture" )
        else if(messageid == CTF_Attack)
            RuiSetString( MILITIApointicon, "hint", "Attack" )
        else if(messageid == CTF_Escort)
            RuiSetString( MILITIApointicon, "hint", "Escort" )
        else if(messageid == CTF_Return)
            RuiSetString( MILITIApointicon, "hint", "Return" )
    }

    } catch (pe3){
        
    }
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
            try {
			    RuiDestroy( rui )
            } catch (pe3){
        
            }

			if ( IsValid( prop ) )
				prop.e.overheadRui = null
		}
	)

	WaitForever()
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

    var screenAlignmentTopo2 = RuiTopology_CreatePlane( <( screenSize.width * 0.25),( screenSize.height * 0.31 ), 0>, <float( screenSize.width ), 0, 0>, <0, float( screenSize.height - 100 ), 0>, false )
    var rui2 = RuiCreate( $"ui/announcement_quick_right.rpak", screenAlignmentTopo2, RUI_DRAW_HUD, RUI_SORT_SCREENFADE + 1 )
    
    RuiSetGameTime( rui, "startTime", Time() )
    RuiSetString( rui, "messageText", "Team IMC: 0  ||  Team MIL: 0" )
    RuiSetFloat( rui, "duration", 9999999 )
    RuiSetFloat3( rui, "eventColor", SrgbToLinear( <128, 188, 255> ) )

    RuiSetGameTime( rui2, "startTime", Time() )
    RuiSetString( rui2, "messageText", "Team: " )
    RuiSetFloat( rui2, "duration", 9999999 )
    RuiSetFloat3( rui2, "eventColor", SrgbToLinear( <128, 188, 255> ) )
    
    file.scoreRui = rui
    file.teamRui = rui2
    
    OnThreadEnd(
		function() : ( rui, rui2 )
		{
            if ( IsValid( rui ) )
			    RuiDestroy( rui )
            
            if ( IsValid( rui2 ) )
			    RuiDestroy( rui2 )

			file.scoreRui = null
            file.teamRui = null
		}
	)
    
    WaitForever()
}

void function ServerCallback_CTF_DoAnnouncement(float duration, int type)
{
    string message = ""
    string subtext = ""
    switch(type)
    {

        case eCTFAnnounce.ROUND_START:
        {
            thread MakeScoreRUI();
            //message = "Round start"
            message = "Welcome To Capture The Flag Playtest!"
            subtext = "Made by AyeZee#6969"
            break
        }
        case eCTFAnnounce.VOTING_PHASE:
        {
            clGlobal.levelEnt.Signal( "CloseScoreRUI" )
            message = "Welcome To Capture The Flag"
            subtext = "Made by AyeZee#6969"
            break
        }
        case eCTFAnnounce.MAP_FLYOVER:
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

void function ServerCallback_CTF_PointCaptured(int IMC, int MIL)
{
    if(file.scoreRui)
        RuiSetString( file.scoreRui, "messageText", "Team IMC: " + IMC + "  ||  Team MIL: " + MIL )
}

void function ServerCallback_CTF_TeamText(int team)
{
    if(file.teamRui)
    {
        if(team == TEAM_IMC)
            RuiSetString( file.teamRui, "messageText", "Your Team: IMC" )
        else
            RuiSetString( file.teamRui, "messageText", "Your Team: MILITIA")
    }
}

void function ServerCallback_CTF_TeamWon(int team)
{
    AnnouncementData announcement
    if (team == TEAM_IMC)
    {
        announcement = Announcement_Create( "IMC has won the round!" )
    } 
    else if (team == TEAM_MILITIA)
    {
        announcement = Announcement_Create( "MILITIA has won the round!" )
    }
    else
    {
        announcement = Announcement_Create( "Couldnt decide on the winner!" )
    }

    Announcement_SetSubText(announcement, "Starting next round")
	Announcement_SetStyle( announcement, ANNOUNCEMENT_STYLE_CIRCLE_WARNING )
	Announcement_SetPurge( announcement, true )
	Announcement_SetOptionalTextArgsArray( announcement, [ "true" ] )
	Announcement_SetPriority( announcement, 200 ) //Be higher priority than Titanfall ready indicator etc
	announcement.duration = 20
	AnnouncementFromClass( GetLocalViewPlayer(), announcement )
}

void function ServerCallback_CTF_EnemyCaptured(entity player)
{
    AnnouncementData announcement = Announcement_Create( "Enemy team has captured your flag!" )
    //Announcement_SetSubText(announcement, "by: " + player.GetPlayerName())
	Announcement_SetStyle( announcement, ANNOUNCEMENT_STYLE_SWEEP )
	Announcement_SetPurge( announcement, true )
	Announcement_SetOptionalTextArgsArray( announcement, [ "true" ] )
	Announcement_SetPriority( announcement, 200 )
	announcement.duration = 3
	AnnouncementFromClass( GetLocalViewPlayer(), announcement )
}

void function ServerCallback_CTF_TeamCaptured(entity player)
{
    AnnouncementData announcement = Announcement_Create( "Your team has captured the enemy flag!" )
    //Announcement_SetSubText(announcement, "by: " + player.GetPlayerName())
	Announcement_SetStyle( announcement, ANNOUNCEMENT_STYLE_SWEEP )
	Announcement_SetPurge( announcement, true )
	Announcement_SetOptionalTextArgsArray( announcement, [ "true" ] )
	Announcement_SetPriority( announcement, 200 )
	announcement.duration = 3
	AnnouncementFromClass( GetLocalViewPlayer(), announcement )
}

void function ServerCallback_CTF_CustomMessages(entity player, int messageid)
{
    string message;
    if (messageid == PickedUpFlag)
    {
        message = "You picked up the flag"
    }
    else if (messageid == EnemyPickedUpFlag)
    {
        message = "Enemy team picked up your flag"
    }
    else if (messageid == TeamReturnedFlag)
    {
        message = "Your teams flag has been returned to base"
    }

    AnnouncementData announcement = CreateAnnouncementMessageQuick( player, message, "", <100, 0, 0>, $"rui/hud/gametype_icons/survival/survey_beacon_only_pathfinder" )
	Announcement_SetPurge( announcement, true )
	Announcement_SetPriority( announcement, 200 )
	announcement.duration = 3
	AnnouncementFromClass( GetLocalViewPlayer(), announcement )
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
void function ServerCallback_CTF_UpdateDamage(int type, float damage)
{
    if(type == 0)
    {
        RunUIScript( "UpdateKillerDamage", damage)
    }
    else
    {
        RunUIScript( "UpdateDamageGiven", damage)
    }
}

void function ServerCallback_CTF_OpenCTFRespawnMenu(vector campos, int IMCscore, int MILscore, entity attacker)
{
    RunUIScript( "OpenCTFRespawnMenu" )

    entity player = GetLocalClientPlayer()

    if(attacker != null)
    {
        if(attacker.IsPlayer() && attacker != null)
            RunUIScript( "UpdateKillerName", attacker.GetPlayerName())
        else
            RunUIScript( "UpdateKillerName", "Suicide")
    }
    else
        RunUIScript( "UpdateKillerName", "Suicide")

    if(player.GetTeam() == TEAM_IMC)
    {
        RunUIScript( "SetTeamScore", IMCscore)
        RunUIScript( "SetEnemyScore", MILscore)
    }
    else
    {
        RunUIScript( "SetTeamScore", MILscore)
        RunUIScript( "SetEnemyScore", IMCscore)
    }

    thread UpdateUIRespawnTimer()
}

void function ServerCallback_CTF_PlayerDied(vector campos, int IMCscore, int MILscore, entity attacker)
{
    entity player = GetLocalClientPlayer()
    
    array<entity> players = GetPlayerArrayOfTeam( player.GetTeam() )
    foreach ( teamplayer in players )
    {
        if(teamplayer == player)
        {
            var newicon = AddCaptureIcon( teamplayer, $"rui/pilot_loadout/mods/hopup_skullpiercer", false, $"ui/overhead_icon_generic.rpak")
		    RuiSetFloat2( newicon, "iconSize", <25,25,0> )
		    RuiSetFloat( newicon, "distanceFade", 100000 )
		    RuiSetBool( newicon, "adsFade", false )
		    RuiSetString( newicon, "hint", "Death Location" )

            teamicons.append(newicon)
            continue
        }

        var newicon = AddCaptureIcon( teamplayer, $"rui/hud/gametype_icons/obj_foreground_diamond", false, $"ui/overhead_icon_generic.rpak")
		RuiSetFloat2( newicon, "iconSize", <15,15,0> )
		RuiSetFloat( newicon, "distanceFade", 100000 )
		RuiSetBool( newicon, "adsFade", false )
		RuiSetString( newicon, "hint", teamplayer.GetPlayerName() )

        teamicons.append(newicon)
    }

    cameraMover = CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", player.GetOrigin(), player.CameraAngles() )
    Deathcam = CreateClientSidePointCamera( player.GetOrigin(), player.CameraAngles(), 90 )
    Deathcam.SetParent( cameraMover, "", false )
    player.SetMenuCameraEntityWithAudio( Deathcam )
    Deathcam.SetTargetFOV( 90, true, EASING_CUBIC_INOUT, 0.50 )
    cameraMover.NonPhysicsMoveTo( campos + GetDeathcamHeight(), 0.60, 0, 0.30 )
    cameraMover.NonPhysicsRotateTo( GetDeathcamAng(), 0.60, 0, 0.30 )
}

void function UpdateUIRespawnTimer()
{
    int time = 10
    while(time > -1)
    {
        RunUIScript( "UpdateRespawnTimer", time)
        time--

        if(time == -1)
        {
            entity player = GetLocalClientPlayer()
    
            thread waitrespawn(player)
        }
        
        wait 1
    }
}

void function ServerCallback_CTF_PlayerSpawning()
{

    foreach ( iconvar in teamicons )
    {
        try {
            RuiDestroy(iconvar)
        } catch (exception2){
            
        }
    }
}

void function ServerCallback_CTF_SetObjectiveText(int score)
{
    RunUIScript( "UpdateObjectiveText", score)
}

void function waitrespawn(entity player)
{
    try {
        Deathcam.ClearParent()
        cameraMover.Destroy()
    } catch (exception){
        
    }

    cameraMover = CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", Deathcam.GetOrigin(), Deathcam.GetAngles() )
    Deathcam.SetParent( cameraMover, "", false )
    player.SetMenuCameraEntityWithAudio( Deathcam )
    cameraMover.NonPhysicsMoveTo( player.GetOrigin(), 0.40, 0, 0.20 )
    cameraMover.NonPhysicsRotateTo( player.CameraAngles(), 0.40, 0, 0.20 )

    wait 0.40

    RunUIScript( "CloseCTFRespawnMenu" ) 
    player.ClearMenuCameraEntity()

    try {
        Deathcam.ClearParent()
        Deathcam.Destroy()
        cameraMover.Destroy()
    } catch (exceptio2n){
        
    }
}