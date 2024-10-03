// Credits
// AyeZee#6969 -- ctf gamemode and ui
// CafeFPS -- Server/client/ui Rework and multiple code fixes
// sal#3261 -- base custom_tdm mode to work off
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

global function FS_CreateIntroScreen
global function FSIntro_ForceEnd

global function ServerCallback_FS_OpenVoteTeamMenu
global function FS_InWorldPic
global function HoverTeamButton
global function VoteTeam_EndFocusModel
global function VoteTeam_ClientAskedForTeam

global function ServerCallback_AddClientThatVotedToTeam
global function ServerCallback_RemoveClientThatVotedFromTeam
global function Flowstate_IntroTimeChanged
global function Flowstate_IntroEndTimeChanged
global function Flowstate_VoteTeamEndTimeChanged

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
	table<int, entity> charactersModels

	entity FSIntro_Localmodel
	entity FSIntro_Camera
	entity FSIntro_CameraMover

	array<entity> FSIntro_localSquadEnts
	
	entity VoteTeam_Camera
	entity VoteTeam_orchidPlayerModel
	vector VoteTeam_orchidPlayerModel_OgOrigin
	entity VoteTeam_condorPlayerModel
	vector VoteTeam_condorPlayerModel_OgOrigin

	int VoteTeam_selectedTeam = -1
	array<var> FSIntro_cleanupRui
	var activeQuickHint
	var activeSweepHint
} file

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
} teamscore

struct {
	var IMCpointicon = null
	var MILITIApointicon = null
	var FlagReturnRUI = null
} FlagRUI

struct {
	int gamestarttime
	int endingtime
	int seconds
} clientgametimer

struct {
	entity e
	entity m
} deathcam

bool hasvoted = false
bool isvoting = false
bool roundover = false

bool hidechat = false
int hidechatcountdown = 0

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
	RegisterSignal("NewKillChangeRui")
	RegisterSignal( "StartNewWinnerScreen" )
	RegisterSignal( "ChangeCameraToSelectedLocation" )
	RegisterSignal( "VoteTeam_EndModelFocus" )
	RegisterSignal( "FSIntro_CardName" )
	
	if( Flowstate_IsHaloMode() )
		SetCommsDialogueEnabled( false )
}

void function CL_FSCTF_RegisterNetworkFunctions()
{
	RegisterNetworkedVariableChangeCallback_time( "FSIntro_StartTime", Flowstate_IntroTimeChanged )
	RegisterNetworkedVariableChangeCallback_time( "FSIntro_EndTime", Flowstate_IntroEndTimeChanged )
	// RegisterNetworkedVariableChangeCallback_time( "FSVoteTeam_StartTime", Flowstate_VoteTeamTimeChanged )
	RegisterNetworkedVariableChangeCallback_time( "FSVoteTeam_EndTime", Flowstate_VoteTeamEndTimeChanged )
	RegisterNetworkedVariableChangeCallback_time( "flowstate_DMStartTime", Flowstate_CTFStartTimeChanged )
	RegisterNetworkedVariableChangeCallback_time( "flowstate_DMRoundEndTime", Flowstate_CTFRoundEndTimeChanged )
	RegisterNetworkedVariableChangeCallback_ent( "imcFlag", CTF_FlagEntChangedImc )
	RegisterNetworkedVariableChangeCallback_ent( "milFlag", CTF_FlagEntChangedMil )
}

void function CTF_FlagEntChangedImc( entity player, entity oldFlag, entity newFlag, bool actuallyChanged )
{
	CTF_FlagEntChanged( TEAM_IMC, newFlag )
}

void function CTF_FlagEntChangedMil( entity player, entity oldFlag, entity newFlag, bool actuallyChanged )
{
	CTF_FlagEntChanged( TEAM_MILITIA, newFlag )
}

void function CTF_FlagEntChanged( int team, entity newFlag )
{
	#if DEVELOPER
		printt( "CTF_FlagEntChanged", newFlag, team )
	#endif

	if ( !IsValid( newFlag ) || newFlag.IsPlayer() && newFlag == GetLocalClientPlayer() )
	{
		if( team == TEAM_IMC )
		{
			if( FlagRUI.IMCpointicon != null )
			{
				RuiDestroyIfAlive( FlagRUI.IMCpointicon )
				FlagRUI.IMCpointicon = null
			}
		} else if( team == TEAM_MILITIA )
		{
			if( FlagRUI.MILITIApointicon != null )
			{
				RuiDestroyIfAlive( FlagRUI.MILITIApointicon )
				FlagRUI.MILITIApointicon = null
			}
		}
		return
	}

	entity player = GetLocalViewPlayer()

	// ClientCodeCallback_MinimapEntitySpawned( newFlag )

	string msg = player.GetTeam() == team ? "Defend" : "Capture"
	
	if( newFlag.IsPlayer() )
		msg = player.GetTeam() == newFlag.GetTeam() ? "Escort" : "Attack"

	asset Icon = player.GetTeam() == team ? $"rui/gamemodes/capture_the_flag/imc_flag" : $"rui/gamemodes/capture_the_flag/mil_flag"

	if( team == TEAM_IMC )
	{
		if( FlagRUI.IMCpointicon != null )
		{
			RuiDestroyIfAlive( FlagRUI.IMCpointicon )
			FlagRUI.IMCpointicon = null
		}
		FlagRUI.IMCpointicon = AddPointIconRUI( newFlag, msg, Icon)
	} else if( team == TEAM_MILITIA )
	{
		if( FlagRUI.MILITIApointicon != null )
		{
			RuiDestroyIfAlive( FlagRUI.MILITIApointicon )
			FlagRUI.MILITIApointicon = null
		}
		FlagRUI.MILITIApointicon = AddPointIconRUI( newFlag, msg, Icon)
	}
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

	if( Flowstate_IsHaloMode() )
		return

	Obituary_Print_Localized( "%$rui/bullet_point% Made by zee_x64. Reworked by @CafeFPS.", GetChatTitleColorForPlayer( GetLocalViewPlayer() ), BURN_COLOR )
	EmitSoundOnEntity( GetLocalClientPlayer(), "UI_Survival_Intro_LaunchCountDown_Finish" )
}

void function Flowstate_IntroTimeChanged( entity player, float old, float new, bool actuallyChanged )
{
	if ( !actuallyChanged  )
		return

	FS_CreateIntroScreen()
}

void function Flowstate_IntroEndTimeChanged( entity player, float old, float new, bool actuallyChanged )
{
	if ( !actuallyChanged  )
		return
}

void function Flowstate_VoteTeamTimeChanged( entity player, float old, float new, bool actuallyChanged )
{
	if ( !actuallyChanged  )
		return

	// ServerCallback_FS_OpenVoteTeamMenu( true )
}

void function Flowstate_VoteTeamEndTimeChanged( entity player, float old, float new, bool actuallyChanged )
{
	if ( !actuallyChanged  || new == -1 )
		return
	
	thread function () : ( new )
	{
		thread VoteTeamUpdateUIVoteTimer( new )

		while( Time() < GetGlobalNetTime( "FSVoteTeam_EndTime" ) )
			WaitFrame()

		ServerCallback_FS_OpenVoteTeamMenu( false )
	}()
}

void function VoteTeamUpdateUIVoteTimer( float endtime)
{
	thread function() : (endtime)
	{
		int time = int ( endtime - Time() )
		while( time > -1 )
		{
			if( time != 0 )
				RunUIScript( "VoteTeamTimerSetText", "%$rui/menu/store/feature_timer% " + time )

			if (time <= 5 && time != 0)
				EmitSoundOnEntity( GetLocalClientPlayer(), "ui_ingame_markedfordeath_countdowntomarked" )

			if (time == 0)
				EmitSoundOnEntity( GetLocalClientPlayer(), "ui_ingame_markedfordeath_countdowntoyouaremarked" )

			time--

			wait 1
		}
	}()
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
	asset icon = $"rui/gamemodes/capture_the_flag/imc_flag"

	if(start)
	{
		FlagRUI.FlagReturnRUI = CreateFullscreenRui( $"ui/consumable_progress.rpak")
		RuiSetGameTime( FlagRUI.FlagReturnRUI, "healStartTime", starttime )
		RuiSetString( FlagRUI.FlagReturnRUI, "consumableName", "Returning Flag To Base" )
		RuiSetFloat( FlagRUI.FlagReturnRUI, "raiseTime", endtime - starttime )
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

void function ServerCallback_CTF_AddPointIcon(entity imcflag, entity milflag, int team)
{

}

var function AddPointIconRUI( entity flag, string text, asset icon)
{
	if(!IsValid(flag))
		return
		
	bool pinToEdge = true
	asset ruiFile = $"ui/overhead_icon_generic.rpak"

	var rui = AddCaptureIcon( flag, icon, pinToEdge, ruiFile )
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

	return rui
}

void function ServerCallback_CTF_PickedUpFlag(entity player, bool pickedup)
{
	#if DEVELOPER
		printt( "debug, ServerCallback_CTF_PickedUpFlag:", player, pickedup )
	#endif
	
	asset icon = $"rui/gamemodes/capture_the_flag/arrow"
	vector emptymdlloc
	vector color

	switch(player.GetTeam())
	{
		case TEAM_IMC:

			emptymdlloc = file.selectedLocation.imcflagspawn
			color = SrgbToLinear( <100,100,255> / 255 )

			break
		case TEAM_MILITIA:

			emptymdlloc = file.selectedLocation.milflagspawn
			color = SrgbToLinear( <255,100,100> / 255 )

			break
	}

	if(pickedup)
	{
		if( file.dropflagrui != null)
		{
			RuiDestroyIfAlive( file.dropflagrui )
			file.dropflagrui = null
		}

		file.dropflagrui = CreateFullscreenRui( $"ui/wraith_comms_hint.rpak" )
		RuiSetGameTime( file.dropflagrui, "startTime", Time() )
		RuiSetGameTime( file.dropflagrui, "endTime", 9999999 )
		RuiSetBool( file.dropflagrui, "commsMenuOpen", false )
		RuiSetString( file.dropflagrui, "msg", "Press %scriptCommand5% to drop the flag" )

		if( file.baseicon != null)
		{
			RuiDestroyIfAlive( file.baseicon )
			file.baseicon = null
		}

		if(IsValid( file.baseiconmdl ))
			file.baseiconmdl.Destroy()

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
			message = "CAPTURE THE FLAG"
			subtext = "Capture the enemy flag, defend your own."
			clGlobal.initScoreboardFunc()
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
	printt( "Delete score Rui" ) //...?
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

	asset localteamIcon
	asset enemyteamIcon

	entity player = GetLocalClientPlayer()

	if( !Flowstate_IsHaloMode() )
	{
		localteamIcon = player.GetTeam() == TEAM_IMC ? $"rui/flowstatecustom/imc" : $"rui/flowstatecustom/militia"
		enemyteamIcon = localteamIcon == "rui/flowstatecustom/imc" ? $"rui/flowstatecustom/militia" : $"rui/flowstatecustom/imc"
	} else
	{
		localteamIcon = player.GetTeam() == TEAM_IMC ? $"rui/flowstate_custom/team_orchid" : $"rui/flowstate_custom/team_condor"
		enemyteamIcon = localteamIcon == "rui/flowstate_custom/team_orchid" ? $"rui/flowstate_custom/team_condor" : $"rui/flowstate_custom/team_orchid"
	}

	RuiSetImage( Hud_GetRui( HudElement( "FS_Oddball_EnemyHas" ) ), "basicImage", enemyteamIcon )
	RuiSetImage( Hud_GetRui( HudElement( "FS_Oddball_AllyHas" ) ), "basicImage", localteamIcon )
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
	bool blueText = true
	asset icon = $"rui/gamemodes/capture_the_flag/mil_flag"

	switch(messageid)
	{
		case eCTFMessage.PickedUpFlag:
			if( player == GetLocalViewPlayer() )
				message = "You captured the enemy flag!"
			else
				message = "Your team has captured the enemy flag!"

			EmitSoundOnEntity( GetLocalViewPlayer(), "UI_CTF_1P_PlayerScore" )
			break
		case eCTFMessage.EnemyPickedUpFlag:
			message = "Enemy team has captured your flag!"
			blueText = false
			icon = $"rui/gamemodes/capture_the_flag/imc_flag"

			EmitSoundOnEntity( GetLocalViewPlayer(), "UI_CTF_3P_EnemyScores" )
			break
		case eCTFMessage.TeamReturnedFlag:
			if( player == GetLocalViewPlayer() )
				message = "You returned the ally flag!"
			else
				message = "Your teams flag has been returned!"

			EmitSoundOnEntity( GetLocalViewPlayer(), "UI_CTF_1P_ReturnsFlag" )
			break
		case eCTFMessage.EnemyTeamReturnedFlag:
			message = "Enemy flag has been returned!"
			blueText = false
			icon = $"rui/gamemodes/capture_the_flag/imc_flag"

			EmitSoundOnEntity( GetLocalViewPlayer(), "UI_CTF_3P_EnemyReturnsFlag" )
			break
	}

	QuickSweepHint( message, blueText, 3, icon )
}

void function ServerCallback_CTF_CustomMessages(entity player, int messageid)
{
	string message
	bool blueText = true

	switch(messageid)
	{
		case eCTFMessage.PickedUpFlag:
			if( player == GetLocalViewPlayer() )
				message = "You have the enemy flag!"
			else
				message = "Your team picked up the enemy flag!"

			EmitSoundOnEntity( GetLocalViewPlayer(), "UI_CTF_1P_GrabFlag" )
			break
		case eCTFMessage.EnemyPickedUpFlag:
			message = "Enemy team picked up your flag!"
			blueText = false

			EmitSoundOnEntity( GetLocalViewPlayer(), "UI_CTF_3P_EnemyGrabFlag" )
			break
		case eCTFMessage.YourTeamFlagHasBeenReset:
			message = "Your teams flag has been reset"

			EmitSoundOnEntity( GetLocalViewPlayer(), "ui_ctf_team_flagupdate" )
			break
		case eCTFMessage.EnemyTeamsFlagHasBeenReset:
			message = "The enemy flag has been reset"
			blueText = false

			EmitSoundOnEntity( GetLocalViewPlayer(), "ui_ctf_enemy_flagupdate" )
			break
		case eCTFMessage.FlagNeedsToBeAtBase:
			message = "Your teams flag is not at base"
			blueText = false

			EmitSoundOnEntity( GetLocalViewPlayer(), "UI_InGame_FD_MetaUpgradeTextAppear" )
			break
	}

	QuickRightHint( message, blueText, 3 )
}

void function QuickRightHint( string hintText, bool blueText = false, int duration = 2)
{
	if(file.activeQuickHint != null)
	{
		RuiDestroyIfAlive( file.activeQuickHint )
		file.activeQuickHint = null
	}
	file.activeQuickHint = CreateFullscreenRui( $"ui/announcement_quick_right.rpak" )

	RuiSetGameTime( file.activeQuickHint, "startTime", Time() )
	RuiSetString( file.activeQuickHint, "messageText", hintText )
	RuiSetFloat( file.activeQuickHint, "duration", duration.tofloat() )

	if(blueText)
		RuiSetFloat3( file.activeQuickHint, "eventColor", SrgbToLinear( <48, 107, 255> / 255.0 ) )
	else
		RuiSetFloat3( file.activeQuickHint, "eventColor", SrgbToLinear( <255, 0, 30> / 255.0 ) )
}

void function QuickSweepHint( string hintText, bool blueText = false, int duration = 2, asset icon = $"")
{
	if(file.activeSweepHint != null)
	{
		RuiDestroyIfAlive( file.activeSweepHint )
		file.activeSweepHint = null
	}
	file.activeSweepHint = CreateFullscreenRui( $"ui/announcement_center_sweep.rpak" )

	// RuiSetFloat2( file.activeSweepHint, "iconAspect", 1 )
	RuiSetImage( file.activeSweepHint, "leftIconImage", icon )
	RuiSetImage( file.activeSweepHint, "rightIconImage", icon )
	RuiSetGameTime( file.activeSweepHint, "startTime", Time() )
	RuiSetString( file.activeSweepHint, "messageText", hintText )
	RuiSetFloat( file.activeSweepHint, "duration", duration.tofloat() )

	if(blueText)
		RuiSetFloat3( file.activeSweepHint, "eventColor", SrgbToLinear( <48, 107, 255> / 255.0 ) )
	else
		RuiSetFloat3( file.activeSweepHint, "eventColor", SrgbToLinear( <255, 0, 30> / 255.0 ) )
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
	entity player = GetLocalClientPlayer()

	if( team == 69 )
	{
		return "Winner couldn't be decided"
	}

	string teamwon = ""

	if( team != player.GetTeam() )
	{
		teamwon = "The Enemy Team has won"
	} else
	{
		teamwon = "Your Team has won"
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

	asset defaultModel				= GetGlobalSettingsAsset( DEFAULT_PILOT_SETTINGS, "bodyModel" )
	LoadoutEntry loadoutSlotCharacter = Loadout_CharacterClass()
	vector characterAngles			= < file.victorySequenceAngles.x / 2.0, file.victorySequenceAngles.y, file.victorySequenceAngles.z >

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
		entity camera	  = CreateClientSidePointCamera( camera_start_pos, camera_start_angles, 35.5 )
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

void function AddIntroScreenSquadData( entity player )
{
	file.FSIntro_localSquadEnts.append( player )
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


//Halo mod


void function FS_CreateIntroScreen()
{
	thread function () : ()
	{
		file.FSIntro_localSquadEnts.clear()

		foreach( player in GetPlayerArrayOfTeam( GetLocalClientPlayer().GetTeam() ) )
		{
			AddIntroScreenSquadData( player )
		}

		while( Time() < GetGlobalNetTime( "FSIntro_StartTime" ) )
			WaitFrame()
	
		if( FlagRUI.IMCpointicon != null )
		{
			RuiSetVisible( FlagRUI.IMCpointicon, false )
		}
		if( FlagRUI.MILITIApointicon != null )
		{
			RuiSetVisible( FlagRUI.MILITIApointicon, false )
		}

		ScreenFade(GetLocalClientPlayer(), 0, 0, 0, 255, 0.3, 0.0, FFADE_IN | FFADE_PURGE)

		FSIntro_StartIntroScreen()
	}()
}

void function FSIntro_StartIntroScreen()
{
	float stime = Time()
	FSIntro_Destroy()
	
	if( Flowstate_IsHaloMode() && !IsValid( GetGlobalNetEnt( "imcFlag" ) ) || GetCurrentPlaylistVarBool( "is_halo_gamemode", false ) && !IsValid( GetGlobalNetEnt( "milFlag" ) ) )
		return

	entity player = GetLocalClientPlayer()
	
	file.victorySequencePosition = file.selectedLocation.victorypos.origin - < 0, 0, 52>
	file.victorySequenceAngles = file.selectedLocation.victorypos.angles

	if( Flowstate_IsHaloMode() )
	{
		if( player.GetTeam() == TEAM_IMC )
		{
			file.victorySequencePosition = GetGlobalNetEnt( "imcFlag" ).GetOrigin()
			
			// rui = FS_InWorldPic( file.victorySequencePosition + <0, 0, 15>, file.victorySequenceAngles, "rui/flowstate_custom/flowstatepresents", true, 500, 282, 1)

			switch( file.selectedLocation.name )
			{
				case "Narrows":
				file.victorySequenceAngles = <0, 180, 0>
				file.victorySequencePosition = OffsetPointRelativeToVector( file.victorySequencePosition, <0, 115, 8>, AnglesToForward( file.victorySequenceAngles ) )
				break
				
				case "The Pit":
				file.victorySequenceAngles = <0, 180, 0>
				file.victorySequencePosition = OffsetPointRelativeToVector( file.victorySequencePosition, <0, 115, 8>, AnglesToForward( file.victorySequenceAngles ) )
				break
				
				case "Lockout":
				
				break
			}
		} else if( player.GetTeam() == TEAM_MILITIA )
		{
			file.victorySequencePosition = GetGlobalNetEnt( "milFlag" ).GetOrigin()

			// rui = FS_InWorldPic( file.victorySequencePosition + <0, 0, 15>, file.victorySequenceAngles, "rui/flowstate_custom/flowstatepresents", true, 500, 282, 1)
	
			switch( file.selectedLocation.name )
			{
				case "Narrows":
				file.victorySequenceAngles = <0, 0, 0>
				file.victorySequencePosition = OffsetPointRelativeToVector( file.victorySequencePosition, <0, 115, 8>, AnglesToForward( file.victorySequenceAngles ) )
				break
				
				case "The Pit":
				file.victorySequenceAngles = <0, 0, 0>
				file.victorySequencePosition = OffsetPointRelativeToVector( file.victorySequencePosition, <0, 115, 8>, AnglesToForward( file.victorySequenceAngles ) )
				break
				
				case "Lockout":
				
				break
			}
		}
	}

	asset defaultModel				= GetGlobalSettingsAsset( DEFAULT_PILOT_SETTINGS, "bodyModel" )
	LoadoutEntry loadoutSlotCharacter = Loadout_CharacterClass()
	vector characterAngles			= < file.victorySequenceAngles.x / 2.0, file.victorySequenceAngles.y, file.victorySequenceAngles.z >

	int maxPlayersToShow = 9
	array<entity> charactersModels = file.FSIntro_localSquadEnts

	// VictorySequenceOrderLocalPlayerFirst( player )
	int j = 0
	foreach( teamPlayer in file.FSIntro_localSquadEnts )
	{
		if( !IsValid( teamPlayer ) || !teamPlayer.IsPlayer() )
			continue

		if ( maxPlayersToShow > 0 && j > maxPlayersToShow )
			break

		string playerName = teamPlayer.GetPlayerName()

		entity characterNode = CreateScriptRef( teamPlayer.GetOrigin(), teamPlayer.GetAngles() )

		entity characterModel = CreateClientSidePropDynamic( teamPlayer.GetOrigin(), teamPlayer.GetAngles(), teamPlayer.GetTeam() == TEAM_IMC ? $"mdl/Humans/pilots/w_master_chief_pink.rmdl" : $"mdl/Humans/pilots/w_master_chief_purple.rmdl" )

		if( teamPlayer == player )
			file.FSIntro_Localmodel = characterModel

		SetForceDrawWhileParented( characterModel, true )
		characterModel.MakeSafeForUIScriptHack()

		cleanupEnts.append( characterModel )

		characterModel.SetParent( characterNode, "", false )

		string victoryAnim = "animseq/humans/class/medium/pilot_medium_bloodhound/bloodhound_idle_UA.rseq"
		characterModel.Anim_Play( victoryAnim )
		characterModel.Anim_EnableUseAnimatedRefAttachmentInsteadOfRootMotion()

		float duration = characterModel.GetSequenceDuration( victoryAnim )
		float initialTime = RandomFloatRange( 0, duration )
		characterModel.Anim_SetInitialTime( initialTime )

		entity weapon = CreateClientSidePropDynamic( characterModel.GetOrigin(), <0, -120, 0>, $"mdl/flowstate_custom/w_haloassaultrifle.rmdl" )
		cleanupEnts.append( weapon )
		weapon.SetParent( characterModel, "RIFLE_HOLSTER" )

		j++
	}

	DoF_SetFarDepth( 500, 1000 )
	DoF_LerpFarDepth( 100, 150, 0.5 )
	
	if( charactersModels.len() == 0 )
		return

	//Setup camera pos and angles
	vector camera_start_pos = charactersModels[0].GetAttachmentOrigin( charactersModels[0].LookupAttachment("HEADFOCUS") ) + AnglesToForward( charactersModels[0].GetAngles() ) * 250
	vector camera_end_pos   = charactersModels[0].GetAttachmentOrigin( charactersModels[0].LookupAttachment("HEADFOCUS") ) + AnglesToForward( charactersModels[0].GetAngles() ) * 100 //+ OffsetPointRelativeToVector( model.GetOrigin(), <0, 0, 0>, AnglesToForward( model.GetAngles() ) )
	vector camera_focus_pos = charactersModels[0].GetAttachmentOrigin( charactersModels[0].LookupAttachment("HEADFOCUS") ) - AnglesToRight( charactersModels[0].GetAngles() ) * 17 - AnglesToUp( charactersModels[0].GetAngles() ) * 10
	vector camera_start_angles = VectorToAngles( camera_focus_pos - camera_start_pos )
	vector camera_end_angles   = VectorToAngles( camera_focus_pos - camera_end_pos )

	//Create camera and mover
	GetLocalClientPlayer().ClearMenuCameraEntity()
	file.FSIntro_CameraMover = CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", camera_start_pos, camera_start_angles )
	file.FSIntro_Camera	  = CreateClientSidePointCamera( camera_start_pos, camera_start_angles, 40 )
	entity cameraMover = file.FSIntro_CameraMover
	entity camera = file.FSIntro_Camera

	camera.SetTargetFOV( 40, true, EASING_CUBIC_INOUT, 0.0 )
	camera.SetParent( cameraMover, "", false )

	player.SetMenuCameraEntityWithAudio( camera )
	
	vector polePos = player.GetTeam() == TEAM_IMC ? GetGlobalNetEnt( "imcFlag" ).GetOrigin() : GetGlobalNetEnt( "milFlag" ).GetOrigin()

	cleanupEnts.append( camera )
	cleanupEnts.append( cameraMover )
	
	charactersModels = ArrayClosest( charactersModels, charactersModels[ charactersModels.len() - 1 ].GetOrigin() )
	charactersModels.reverse()
	
	int i = 1
	int divide = int( ceil ( float( charactersModels.len() ) / 2 ) )
	
	foreach( entity model in charactersModels )
	{
		camera_start_pos = camera.GetOrigin()
		camera_end_pos   = model.GetAttachmentOrigin( model.LookupAttachment("HEADFOCUS") ) + AnglesToForward( model.GetAngles() ) * 80 //+ OffsetPointRelativeToVector( model.GetOrigin(), <0, 0, 0>, AnglesToForward( model.GetAngles() ) )
		camera_focus_pos = model.GetAttachmentOrigin( model.LookupAttachment("HEADFOCUS") ) + AnglesToRight( model.GetAngles() ) * 13 * ( i > divide ? 1 : -1 ) - AnglesToUp( model.GetAngles() ) * 10
		camera_start_angles = VectorToAngles( camera_focus_pos - camera_start_pos )
		camera_end_angles   = VectorToAngles( camera_focus_pos - camera_end_pos )

		thread FSIntro_StartPlayerDataSmallUI( model, i > divide ? 0 : 1 )

		//Move camera to end pos
		cameraMover.NonPhysicsMoveTo( camera_end_pos, 0.5, 0.25, 0.25 )
		cameraMover.NonPhysicsRotateTo( camera_end_angles, 0.5, 0.25, 0.25 )
		
		#if DEVELOPER
			printt( "Moving camera" )
		#endif
		wait 0.5

		if( i == charactersModels.len() )
		{
			file.FSIntro_cleanupRui.append( FS_InWorldPic( polePos + <0, 0, 100>, VectorToAngles( polePos - ( polePos + AnglesToForward( file.victorySequenceAngles ) * 50 ) ), "rui/flowstate_custom/flowstatepresents", true, 250, 35, 1) )
			file.FSIntro_cleanupRui.append( FS_InWorldPic( polePos + <0, 0, 18> + AnglesToForward( file.victorySequenceAngles ) * 205, VectorToAngles( polePos - ( polePos + AnglesToForward( file.victorySequenceAngles ) * 50 ) ), player.GetTeam() == TEAM_IMC ? "rui/flowstate_custom/team_orchid" : "rui/flowstate_custom/team_condor", true, 35, 35, 1) ) 
		}

		i++
		//cool human like camera shake by cafefps - idk what i did
		waitthread function() : ( cameraMover, model, camera_end_pos, camera, camera_focus_pos )
		{
			EndSignal( camera, "OnDestroy" )
			EndSignal( cameraMover, "OnDestroy" )

			float endtime = Time() + FSINTRO_TIMEPERPLAYER - 1
			while( Time() <= endtime )
			{
				float waittime = RandomFloatRange( 0.25, 0.5 )
				cameraMover.NonPhysicsRotateTo( VectorToAngles( camera_focus_pos + AnglesToRight( model.GetAngles() ) * RandomFloatRange( 0.3, 1.5 ) - AnglesToUp( model.GetAngles() ) * RandomFloatRange( 0.3, 1.5 ) -  camera.GetOrigin() ), waittime, 0, 0 )
				float actualtimetowait = RandomFloatRange( 0.25, waittime )
				wait min( actualtimetowait, Time() + actualtimetowait - endtime )
			}
		}()
	}

	cameraMover.NonPhysicsMoveTo( OffsetPointRelativeToVector( file.victorySequencePosition, <0, 325, 70>, AnglesToForward( file.victorySequenceAngles ) ), 1.5, 0, 1.5 )
	cameraMover.NonPhysicsRotateTo( VectorToAngles( (file.victorySequencePosition + AnglesToUp( file.victorySequenceAngles ) * 35) - OffsetPointRelativeToVector( file.victorySequencePosition, <0, 350, 88>, AnglesToForward( file.victorySequenceAngles ) ) ), 1.5, 0, 1.5 )	
	DoF_LerpFarDepth( 700, 10000, 0.5 )

	wait 1.5

	#if DEVELOPER
		printt(  "intro lasted: ", ( Time() - stime ).tostring() )
	#endif
}

void function FSIntro_ForceEnd()
{
	thread function() : ()
	{
		float stime = Time()
		entity localmodel = file.FSIntro_Localmodel
		entity cameraMover = file.FSIntro_CameraMover
		entity camera = file.FSIntro_Camera
		
		if( !IsValid( camera ) || !IsValid( localmodel ) || !IsValid( cameraMover ) )
			return

		cameraMover.NonPhysicsMoveTo( localmodel.GetAttachmentOrigin( localmodel.LookupAttachment("HEADFOCUS") ) + AnglesToForward( GetLocalClientPlayer().CameraAngles() ) * 10, 1.25, 0, 1.25 )
		cameraMover.NonPhysicsRotateTo( GetLocalClientPlayer().CameraAngles(), 1.25, 0, 1.25 )
		camera.SetTargetFOV( GetLocalClientPlayer().GetFOV(), true, EASING_CUBIC_INOUT, 1.5 )
		wait 0.75
		ScreenFade(GetLocalClientPlayer(), 0, 0, 0, 255, 0.75, 0, FFADE_OUT | FFADE_PURGE )
		
		//destroy from server
		//did this finish for all players before destroying from server? set this as finished from client
		wait 0.75
		FSIntro_Destroy()	
		ScreenFade(GetLocalClientPlayer(), 0, 0, 0, 255, 0.75, 0, FFADE_IN | FFADE_PURGE )
		#if DEVELOPER
			printt(  "intro end lasted: ", ( Time() - stime ).tostring() )
		#endif

		if( FlagRUI.IMCpointicon != null )
		{
			RuiSetVisible( FlagRUI.IMCpointicon, true )
		}
		if( FlagRUI.MILITIApointicon != null )
		{
			RuiSetVisible( FlagRUI.MILITIApointicon, true )
		}

		Obituary_Print_Localized( "%$rui/flowstate_custom/colombia_flag_papa% Made in Colombia with love by @CafeFPS.", GetChatTitleColorForPlayer( GetLocalViewPlayer() ), BURN_COLOR )
		// Obituary_Print_Localized( "%$rui/flowstatecustom/hiswattson_ltms% Devised by HisWattson.", GetChatTitleColorForPlayer( GetLocalViewPlayer() ), BURN_COLOR )
		Obituary_Print_Localized( "Welcome to FS Halo Mod CTF v0.9 Beta - Powered by R5Reloaded", GetChatTitleColorForPlayer( GetLocalViewPlayer() ), BURN_COLOR )
	}()
}

void function FSIntro_Destroy()
{
	FadeOutSoundOnEntity( GetLocalClientPlayer(), "Music_CharacterSelect_Wattson", 0.2 )

	GetLocalClientPlayer().ClearMenuCameraEntity()

	foreach( rui in overHeadRuis )
		RuiDestroyIfAlive( rui )

	foreach( entity ent in cleanupEnts )
	{
		if( IsValid( ent ) )
			ent.Destroy()
	}

	foreach( rui in file.FSIntro_cleanupRui )
	{
		if ( rui != null )
		{
			RuiDestroyIfAlive( rui )
		}
	}

	file.FSIntro_cleanupRui.clear()
	overHeadRuis.clear()
	cleanupEnts.clear()

	DoF_SetNearDepthToDefault()
	DoF_SetFarDepthToDefault()
}

void function FSIntro_StartPlayerDataSmallUI( entity player, int side, float duration = FSINTRO_TIMEPERPLAYER )
{
	if( !IsValid( player ) )
		return

	GetLocalClientPlayer().Signal( "FSIntro_CardName" )
	GetLocalClientPlayer().EndSignal( "FSIntro_CardName" )

	OnThreadEnd(
		function() : ( )
		{
			Hud_SetVisible( HudElement( "FSIntro_NameBackground_Left" ), false )
			Hud_SetVisible( HudElement( "FSIntro_NameText_Left" ), false )
			Hud_SetVisible( HudElement( "FSIntro_NameBackground_Right" ), false )
			Hud_SetVisible( HudElement( "FSIntro_NameText_Right" ), false )

			Hud_SetText( HudElement( "FSIntro_NameText_Left" ), "" )
			Hud_SetText( HudElement( "FSIntro_NameText_Right" ), "" )
			Hud_SetAlpha( HudElement( "FSIntro_NameText_Left" ), 255 )
			Hud_SetAlpha( HudElement( "FSIntro_NameText_Right" ), 255 )
		})

	if( side == 0 )
	{
		Hud_SetText( HudElement( "FSIntro_NameText_Left"), player.GetPlayerName() )
		
		RuiSetImage( Hud_GetRui( HudElement( "FSIntro_NameBackground_Left") ), "basicImage", $"rui/flowstatecustom/strip_bg" )

		Hud_ReturnToBasePos( HudElement( "FSIntro_NameBackground_Left" ) )
		Hud_SetSize( HudElement( "FSIntro_NameBackground_Left" ), 0, 0 )

		Hud_SetVisible( HudElement( "FSIntro_NameBackground_Left" ), true )
		Hud_SetVisible( HudElement( "FSIntro_NameText_Left" ), true )

		Hud_ScaleOverTime( HudElement( "FSIntro_NameBackground_Left" ), 1.35, 1.35, 0.20, INTERPOLATOR_SIMPLESPLINE)

	} else if( side == 1 )
	{
		Hud_SetText( HudElement( "FSIntro_NameText_Right"), player.GetPlayerName() )
		
		RuiSetImage( Hud_GetRui( HudElement( "FSIntro_NameBackground_Right") ), "basicImage", $"rui/flowstatecustom/strip_bg" )
		
		Hud_ReturnToBasePos( HudElement( "FSIntro_NameBackground_Right" ) )
		Hud_SetSize( HudElement( "FSIntro_NameBackground_Right" ), 0, 0 )

		Hud_SetVisible( HudElement( "FSIntro_NameBackground_Right" ), true )
		Hud_SetVisible( HudElement( "FSIntro_NameText_Right" ), true )
		
		Hud_ScaleOverTime( HudElement( "FSIntro_NameBackground_Right" ), 1.1, 1.1, 0.20, INTERPOLATOR_SIMPLESPLINE)
	}
		
	wait 0.15

	if( side == 0 )
	{
		Hud_ScaleOverTime( HudElement( "FSIntro_NameBackground_Left" ), 1, 1, 0.20, INTERPOLATOR_SIMPLESPLINE)

	} else if( side == 1 )
	{
		Hud_ScaleOverTime( HudElement( "FSIntro_NameBackground_Right" ), 1, 1, 0.20, INTERPOLATOR_SIMPLESPLINE)
	}		

	wait duration - 0.6

	if( side == 0 )
	{
		UIPos currentPos = REPLACEHud_GetPos( HudElement( "FSIntro_NameBackground_Left" ) )
		UIPos currentPos2 = REPLACEHud_GetPos( HudElement( "FSIntro_NameText_Left" ) )

		Hud_FadeOverTime( HudElement( "FSIntro_NameBackground_Left" ), 0, duration/2, INTERPOLATOR_ACCEL )
		Hud_FadeOverTime( HudElement( "FSIntro_NameText_Left" ), 0, duration/2, INTERPOLATOR_ACCEL )

		Hud_MoveOverTime( HudElement( "FSIntro_NameBackground_Left" ), currentPos.x + 1000, currentPos.y + 0, 0.15 )
	} else if( side == 1 )
	{
		UIPos currentPos = REPLACEHud_GetPos( HudElement( "FSIntro_NameBackground_Right" ) )
		UIPos currentPos2 = REPLACEHud_GetPos( HudElement( "FSIntro_NameText_Right" ) )

		Hud_FadeOverTime( HudElement( "FSIntro_NameBackground_Right" ), 0, 0.3, INTERPOLATOR_ACCEL )
		Hud_FadeOverTime( HudElement( "FSIntro_NameText_Right" ), 0, 0.3, INTERPOLATOR_ACCEL )

		Hud_MoveOverTime( HudElement( "FSIntro_NameBackground_Right" ), currentPos.x + 1000, currentPos.y + 0, 0.15 )
	}

	wait 0.24
}


void function ServerCallback_FS_OpenVoteTeamMenu( bool shouldOpen )
{
	if(shouldOpen)
	{
		file.VoteTeam_selectedTeam = -1
		ScreenFade(GetLocalClientPlayer(), 0, 0, 0, 255, 0.3, 0.0, FFADE_IN | FFADE_PURGE)
		thread FS_VoteTeam_StartMenuModels()
		RunUIScript( "Open_FS_VoteTeam" )
	}
	else
	{
		ScreenFade( GetLocalClientPlayer(), 0, 0, 0, 255, 0, 0, FFADE_OUT | FFADE_STAYOUT )
		GetLocalClientPlayer().Signal("ChangeCameraToSelectedLocation")
		RunUIScript( "Close_FS_VoteTeam" )
		file.VoteTeam_selectedTeam = -1
	}
	
}
LocPair function NewCameraPair(vector origin, vector angles)
{
    LocPair locPair
    locPair.origin = origin
    locPair.angles = angles

    return locPair
}

void function FS_VoteTeam_StartMenuModels()
{
    entity player = GetLocalClientPlayer()
	player.Signal("ChangeCameraToSelectedLocation")
	player.EndSignal("ChangeCameraToSelectedLocation")
	array<LocPair> cutsceneSpawns
	array<entity> cleanupEnts
	array<var> cleanupRui

    if(!IsValid(player)) return
	
	switch( file.selectedLocation.name )
	{
		case "Narrows":
		cutsceneSpawns.append( NewCameraPair( <1489.99255, -6570.93262, 4041.996887>, <0, 133.833832, 0> ) ) 
		break

		case "The Pit":
		cutsceneSpawns.append( NewCameraPair( <40785.418, -10040.1396, -19775.4375>, <0, -142.61087, 0> ) )//<2.34243202, 31.4227657, 0> ) ) 
		break

		case "Lockout":
		cutsceneSpawns.append( NewCameraPair( <1489.99255, -6570.93262, 4041.996887>, <0, 133.833832, 0> ) ) 
		break
	}

	if( cutsceneSpawns.len() == 0 )
		return

    EmitSoundOnEntity( player, "music_skyway_04_smartpistolrun" )

	cutsceneSpawns.randomize()
	vector randomcameraPos = cutsceneSpawns[0].origin
	vector randomcameraAng = cutsceneSpawns[0].angles

	entity model1 = CreateClientSidePropDynamic( randomcameraPos + AnglesToForward( randomcameraAng ) * 65 + AnglesToRight( randomcameraAng ) * 35, <0, 0 ,0>, $"mdl/Humans/pilots/w_master_chief_pink.rmdl" )
	model1.MakeSafeForUIScriptHack()
	model1.Anim_Play( "animseq/humans/class/medium/pilot_medium_bloodhound/bloodhound_idle_UA.rseq" )
	model1.SetAngles( <0,VectorToAngles( randomcameraPos - model1.GetOrigin()).y,0> )
	model1.Anim_SetInitialTime( RandomFloatRange( 0, model1.GetSequenceDuration( "animseq/humans/class/medium/pilot_medium_bloodhound/bloodhound_idle_UA.rseq" ) ) )
	model1.Highlight_Enable()
	
	file.VoteTeam_orchidPlayerModel_OgOrigin = model1.GetOrigin()
	file.VoteTeam_orchidPlayerModel = model1

	entity light1 = CreateClientSideDynamicLight( <0, 0, 0>, <0, 0, 0>, <1, 1, 1>, 175.0 )
	light1.SetLightExponent( 3.1 )
	light1.SetParent( model1, "CHESTFOCUS", false )
	light1.SetLocalOrigin( <30, 13, 41> )
	
	var rui1 = FS_InWorldPic( model1.GetOrigin() + <0, 0, 15> + AnglesToForward( model1.GetAngles() ) * 12, randomcameraAng, "rui/flowstate_custom/team_orchid", true, 28, 28, 1)
	// FS_InWorldText( "Test 0 Test", model1.GetOrigin() + <0, 0, 50>, randomcameraAng )

	entity model2 = CreateClientSidePropDynamic( randomcameraPos + AnglesToForward( randomcameraAng ) * 65 - AnglesToRight( randomcameraAng ) * 35, <0, 0 ,0>, $"mdl/Humans/pilots/w_master_chief_purple.rmdl" )
	model2.MakeSafeForUIScriptHack()
	model2.Anim_Play( "animseq/humans/class/medium/pilot_medium_bloodhound/bloodhound_idle_UA.rseq" )
	model2.SetAngles(  <0,VectorToAngles( randomcameraPos - model2.GetOrigin() ).y,0> )
	model2.Anim_SetInitialTime( RandomFloatRange( 0, model2.GetSequenceDuration( "animseq/humans/class/medium/pilot_medium_bloodhound/bloodhound_idle_UA.rseq" ) ) )
	model2.Highlight_Enable()

	file.VoteTeam_condorPlayerModel_OgOrigin = model2.GetOrigin()
	file.VoteTeam_condorPlayerModel = model2

	entity light2 = CreateClientSideDynamicLight( <0, 0, 0>, <0, 0, 0>, <1, 1, 1>, 175.0 )
	light2.SetLightExponent( 3.1 )
	light2.SetParent( model2, "CHESTFOCUS", false )
	light2.SetLocalOrigin( <30, 13, 41> )
	
	var rui2 = FS_InWorldPic( model2.GetOrigin() + <0, 0, 15> + AnglesToForward( model2.GetAngles() ) * 15, randomcameraAng, "rui/flowstate_custom/team_condor", true, 28, 28, 1)
	// FS_InWorldText( "Test 2 Test", model2.GetOrigin() + <0, 0, 50>, randomcameraAng )

	randomcameraPos += <0,0,40>

    entity camera = CreateClientSidePointCamera(randomcameraPos, randomcameraAng, 17)
	file.VoteTeam_Camera = camera
    camera.SetFOV(100)

	cleanupEnts.append( camera )
	cleanupEnts.append( light2 )
	cleanupEnts.append( light1 )
	cleanupEnts.append( model2 )
	cleanupEnts.append( model1 )
	cleanupRui.append( rui1 )
	cleanupRui.append( rui2 )

	GetLocalClientPlayer().SetMenuCameraEntityWithAudio( camera )
	GetLocalClientPlayer().SetMenuCameraEntity( camera )

	DoF_SetFarDepth( 100, 300 )
	
	OnThreadEnd(
		function() : ( player, camera, cleanupRui, cleanupEnts ) //cutsceneMover
		{
			GetLocalClientPlayer().ClearMenuCameraEntity()

			if(IsValid(player))
			{
				FadeOutSoundOnEntity( player, "music_skyway_04_smartpistolrun", 1 )
			}

			foreach( ent in cleanupEnts )
			{
				if( IsValid( ent ) )
					ent.Destroy()
			}

			foreach( rui in cleanupRui )
			{
				if ( rui != null )
				{
					RuiDestroyIfAlive( rui )
				}
			}

			DoF_SetNearDepthToDefault()
			DoF_SetFarDepthToDefault()
		}
	)
	WaitForever()
}

var function FS_InWorldPic(vector origin, vector angles, string imgpath, bool useImgpath, float width, float height, float opacity, vector rgb = < 0, 0, 0 >) {
	
	// origin += (AnglesToUp( angles )*-1) * (height*0.5)
	var topo = CreateRUITopology_Worldspace( origin, angles, width, height )
	
	var rui = RuiCreate( $"ui/basic_image.rpak", topo, RUI_DRAW_WORLD, RUI_SORT_SCREENFADE + 1 )
	
	RuiSetFloat( rui, "basicImageAlpha", opacity)
	
	if(useImgpath)
		RuiSetString( rui, "basicImage", imgpath)
	
	if(!useImgpath)
		RuiSetFloat3( rui, "basicImageColor", SrgbToLinear( rgb / 255 ))
	
	return rui
}

var function FS_InWorldText( string text, vector origin, vector angles )
{
	float width = 250
	float height = 250


	origin += (AnglesToUp( angles )*-1) * (height*0.5)
	origin.z += 165
	origin -= AnglesToRight( angles ) * 30
	
	#if DEVELOPER
		printt( origin )
	#endif 
	
	var topo = CreateRUITopology_Worldspace( origin, angles, width, height )
	
	var rui = RuiCreate( $"ui/announcement_quick_right.rpak", topo, RUI_DRAW_WORLD, 32767 )
	RuiSetGameTime( rui, "startTime", Time() )
	RuiSetFloat( rui, "duration", 99999999 )
	RuiSetString( rui, "messageText", text)
	
	return rui
}

void function HoverTeamButton( int model, bool forceFx = false )
{
	#if DEVELOPER
		printt("hover team button client call ", model, forceFx )
	#endif 
	
	if( model == 0 && IsValid( file.VoteTeam_condorPlayerModel ) )
	{
		vector color = <128, 52, 235>
		float fillIntensityScalar    = 1
		float outlineIntensityScalar = 1
		float fadeInTime             = 0.25
		float fadeOutTime            = 0.25
		float lifeTime               = 0.5

		if( file.VoteTeam_selectedTeam != -1 && !forceFx )
			return
			
		#if DEVELOPER
			printt( "starting new effect for condor menu model", file.VoteTeam_selectedTeam, model )
		#endif
		
		thread Custom_HighlightTest( file.VoteTeam_condorPlayerModel, color, fillIntensityScalar, outlineIntensityScalar, fadeInTime, fadeOutTime, lifeTime )
	} else if( model == 1 && IsValid( file.VoteTeam_orchidPlayerModel ) )
	{
		vector color = <204, 14, 157>
		float fillIntensityScalar    = 1
		float outlineIntensityScalar = 1
		float fadeInTime             = 0.25
		float fadeOutTime            = 0.25
		float lifeTime               = 0.5
		
		if( file.VoteTeam_selectedTeam != -1 && !forceFx )
			return
		
		#if DEVELOPER
			printt( "starting new effect for orchid menu model", file.VoteTeam_selectedTeam, model )
		#endif
		
		thread Custom_HighlightTest( file.VoteTeam_orchidPlayerModel, color, fillIntensityScalar, outlineIntensityScalar, fadeInTime, fadeOutTime, lifeTime )
	}
}

void function Custom_HighlightTest( entity model, vector color, float fillIntensityScalar, float outlineIntensityScalar, float fadeInTime, float fadeOutTime, float lifeTime)
{
	if ( !IsValid( model ) )
		return

	const float HIGHLIGHT_RADIUS = 1
	Signal( model, "VoteTeam_EndModelFocus" )
	EndSignal( model, "VoteTeam_EndModelFocus" )
	
	vector ogPos

	if( model == file.VoteTeam_condorPlayerModel )
		ogPos = file.VoteTeam_condorPlayerModel_OgOrigin
	else if( model == file.VoteTeam_orchidPlayerModel )
		ogPos = file.VoteTeam_orchidPlayerModel_OgOrigin

	entity Mover = CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", model.GetOrigin(), model.GetAngles() )
	model.SetParent( Mover )
	Mover.NonPhysicsMoveTo( ogPos + <AnglesToForward( VectorToAngles( file.VoteTeam_Camera.GetOrigin() - ogPos ) ).x, AnglesToForward( VectorToAngles( file.VoteTeam_Camera.GetOrigin() - ogPos ) ).y, 0> * 15, 0.1, 0, 0.1 )

	OnThreadEnd(
		function() : ( Mover, ogPos )
		{
			thread function() : ( Mover, ogPos )
			{
				Mover.NonPhysicsMoveTo( ogPos, 0.1, 0.1, 0 )
				wait 0.1
				if( IsValid( Mover ) )
					Mover.Destroy()
			}()
		}
	)
	
	#if DEVELOPER
		printt("started highlight thread for model: ", model)
	#endif
		
	while( IsValid( model ) )
	{
		model.Highlight_ResetFlags()
		model.Highlight_SetVisibilityType( HIGHLIGHT_VIS_ALWAYS )
		model.Highlight_SetCurrentContext( HIGHLIGHT_CONTEXT_NEUTRAL )
		int highlightId = model.Highlight_GetState( HIGHLIGHT_CONTEXT_NEUTRAL )
		model.Highlight_SetFunctions( HIGHLIGHT_CONTEXT_NEUTRAL, HIGHLIGHT_FILL_VM_CUSTOM_COLOR, true, HIGHLIGHT_OUTLINE_VM_CUSTOM_COLOR, HIGHLIGHT_RADIUS, highlightId, false )
		model.Highlight_SetParam( HIGHLIGHT_CONTEXT_NEUTRAL, 0, color )
		// model.Highlight_SetParam( HIGHLIGHT_CONTEXT_NEUTRAL, 1, <fillIntensityScalar, outlineIntensityScalar, 0> )
		model.Highlight_SetFadeInTime( fadeInTime )
		model.Highlight_SetFadeOutTime( fadeOutTime )
		model.Highlight_StartOn()
		model.Highlight_SetLifeTime( lifeTime )
		wait 0.1
	}
}

void function VoteTeam_EndFocusModel( int model )
{
	if( model == 0 && IsValid( file.VoteTeam_condorPlayerModel ) && file.VoteTeam_selectedTeam != model)
	{
		// printt("signal to end focus model 0 on client" )
		Signal( file.VoteTeam_condorPlayerModel, "VoteTeam_EndModelFocus" )
	} else if( model == 1 && IsValid( file.VoteTeam_orchidPlayerModel ) && file.VoteTeam_selectedTeam != model)
	{
		// printt("signal to end focus model 1 on client" )
		Signal( file.VoteTeam_orchidPlayerModel, "VoteTeam_EndModelFocus" )
	}
}

void function VoteTeam_ClientAskedForTeam( int index )
{
	entity player = GetLocalClientPlayer()
	
	switch(index)
	{
		case 0:
		file.VoteTeam_selectedTeam = 0
		HoverTeamButton( 0, true )
		if( IsValid( file.VoteTeam_orchidPlayerModel ) )
			Signal( file.VoteTeam_orchidPlayerModel, "VoteTeam_EndModelFocus" )
		player.ClientCommand("VoteTeam_AskForTeam 0")
		break
		
		case 1:
		file.VoteTeam_selectedTeam = 1
		HoverTeamButton( 1, true )
		if( IsValid( file.VoteTeam_condorPlayerModel ) )
			Signal( file.VoteTeam_condorPlayerModel, "VoteTeam_EndModelFocus" )
		player.ClientCommand("VoteTeam_AskForTeam 1")
		break
		
		default:
		file.VoteTeam_selectedTeam = -1
		break
	}
	
	#if DEVELOPER
		printt("changed selected team for menu model: " , index, file.VoteTeam_selectedTeam)
	#endif
}

void function ServerCallback_AddClientThatVotedToTeam( int eHandle, int team )
{
	if ( !EHIHasValidScriptStruct( eHandle ) ) 
		return
	
	RunUIScript( "AddPlayerNameToTeamArray", team, EHI_GetName(eHandle) )
}

void function ServerCallback_RemoveClientThatVotedFromTeam( int eHandle, int team )
{
	if ( !EHIHasValidScriptStruct( eHandle ) ) 
		return
	
	RunUIScript( "RemovePlayerNameFromTeamArray", team, EHI_GetName(eHandle) )
}