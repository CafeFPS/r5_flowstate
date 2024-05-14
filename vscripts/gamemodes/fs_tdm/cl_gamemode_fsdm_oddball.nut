//Made by @CafeFPS

global function Oddball_HintCatalog
global function Cl_FsOddballInit
global function SetBallPosesionIconOnHud
global function FSDM_GameStateChanged
global function Oddball_BallOrCarrierEntityChanged
//Custom Winner Screen
global function FSDM_CustomWinnerScreen_Start

struct {
	var activeQuickHint
	var ballRui
} file

void function Cl_FsOddballInit()
{
	RegisterConCommandTriggeredCallback( "+scriptCommand5", AttemptThrowOddball )
	AddClientCallback_OnResolutionChanged( Cl_OnResolutionChanged )
	AddCallback_EntitiesDidLoad( OddballNotifyRingTimer )
	RegisterSignal( "StopAutoDestroyRuiThread" )
	RegisterSignal( "StartNewWinnerScreen" )
}

void function FSDM_GameStateChanged( entity player, int old, int new, bool actuallyChanged )
{
	if ( !actuallyChanged )
		return

	if( new == eTDMState.IN_PROGRESS )
	{
		Oddball_ToggleScoreboardVisibility( true )
	} else if( new == eTDMState.NEXT_ROUND_NOW )
	{
		Oddball_ToggleScoreboardVisibility( false )
		Flowstate_ShowRoundEndTimeUI( -1 )
		Oddball_HintCatalog( -1, 0 )
	}
}

void function Cl_OnResolutionChanged()
{
	if( GetGlobalNetInt( "FSDM_GameState" ) != eTDMState.IN_PROGRESS )
	{
		Oddball_ToggleScoreboardVisibility( false )
		return
	}

	Oddball_ToggleScoreboardVisibility( true )
}

void function OddballNotifyRingTimer()
{
    if( GetGlobalNetTime( "flowstate_DMRoundEndTime" ) < Time() || GetGlobalNetInt( "FSDM_GameState" ) != eTDMState.IN_PROGRESS || GetGlobalNetTime( "flowstate_DMRoundEndTime" ) == -1 )
	{
		Oddball_ToggleScoreboardVisibility( false )
		Flowstate_ShowRoundEndTimeUI( -1 )
        return
	}

    Flowstate_ShowRoundEndTimeUI( GetGlobalNetTime( "flowstate_DMRoundEndTime" ) )
	Oddball_ToggleScoreboardVisibility( true )
}

void function AttemptThrowOddball( entity player )
{
	if ( player != GetLocalViewPlayer() || player != GetLocalClientPlayer() )
		return

	if ( IsControllerModeActive() )
	{
		if ( TryPingBlockingFunction( player, "quickchat" ) )
			return
	}

	player.ClientCommand( "CC_AttemptThrowOddball" )
}

void function Oddball_HintCatalog( int index, int eHandle )
{
	if( !IsValid( GetLocalViewPlayer() ) ) return

	switch(index)
	{
		case 0:
		Oddball_PermaHint( "Press %scriptCommand5% to drop the ball", true, 9999)
		break
		
		case -1:
		if(file.activeQuickHint != null)
		{
			RuiDestroyIfAlive( file.activeQuickHint )
			file.activeQuickHint = null
		}
		break
	}
}

void function Oddball_PermaHint( string hintText, bool blueText = false, float duration = 2.5)
{
	if(file.activeQuickHint != null)
	{
		RuiDestroyIfAlive( file.activeQuickHint )
		file.activeQuickHint = null
	}

	file.activeQuickHint = CreateFullscreenRui( $"ui/wraith_comms_hint.rpak" )

	RuiSetGameTime( file.activeQuickHint, "startTime", Time() )
	RuiSetGameTime( file.activeQuickHint, "endTime", duration )
	RuiSetBool( file.activeQuickHint, "commsMenuOpen", false )
	RuiSetString( file.activeQuickHint, "msg", hintText )
}

void function Oddball_ToggleScoreboardVisibility(bool show)
{
    Hud_SetVisible( HudElement( "FS_Oddball_YourTeam" ), show )
	Hud_SetVisible( HudElement( "FS_Oddball_YourTeamGoalScore" ), show )
	Hud_SetText( HudElement( "FS_Oddball_YourTeamGoalScore"), "/" + ODDBALL_POINTS_TO_WIN ) 
    Hud_SetVisible( HudElement( "FS_Oddball_YourTeamScore" ), show )
    Hud_SetVisible( HudElement( "FS_Oddball_AllyHas" ), false )
    Hud_SetVisible( HudElement( "FS_Oddball_EnemyTeam" ), show )
    Hud_SetVisible( HudElement( "FS_Oddball_EnemyTeamScore" ), show )
    Hud_SetVisible( HudElement( "FS_Oddball_EnemyHas" ), false )

	RuiSetImage( Hud_GetRui( HudElement( "FS_Oddball_EnemyHas" ) ), "basicImage", $"rui/hud/gametype_icons/ctf/ctf_foreground" )
	RuiSetImage( Hud_GetRui( HudElement( "FS_Oddball_AllyHas" ) ), "basicImage", $"rui/hud/gametype_icons/ctf/ctf_foreground" )
	RuiSetImage( Hud_GetRui( HudElement( "FS_Oddball_Scoreboard_Frame" ) ), "basicImage", $"rui/flowstate_custom/scoreboard_bg_oddball" )
	
	Hud_SetVisible( HudElement( "FS_Oddball_Scoreboard_Frame" ), show )
	
	if( !show )
		return
	
	thread Oddball_StartBuildingTeamsScoreOnHud()
}

void function SetBallPosesionIconOnHud( int team )
{
	switch( team )
	{
		case -1:
			Hud_SetVisible( HudElement( "FS_Oddball_AllyHas" ), false )
			Hud_SetVisible( HudElement( "FS_Oddball_EnemyHas" ), false )
		break
		
		case 0:
			Hud_SetVisible( HudElement( "FS_Oddball_AllyHas" ), true )
			Hud_SetVisible( HudElement( "FS_Oddball_EnemyHas" ), false )
		break
		
		case 1:
			Hud_SetVisible( HudElement( "FS_Oddball_AllyHas" ), false )
			Hud_SetVisible( HudElement( "FS_Oddball_EnemyHas" ), true )
		break
	}
}

void function Oddball_StartBuildingTeamsScoreOnHud()
{
	entity player = GetLocalClientPlayer()

	int localscore = 0
	int enemyscore = 0
	string str_localscore = ""
	string str_enemyscore = ""

	while( GetGlobalNetInt( "FSDM_GameState" ) == eTDMState.IN_PROGRESS )
	{
		localscore = 0
		enemyscore = 0
		str_localscore = ""
		str_enemyscore = ""

		localscore += player.GetPlayerNetInt( "oddball_ballHeldTime" )

		foreach( sPlayer in GetPlayerArray() )
		{
			if( sPlayer == player )
				continue

			if( sPlayer.GetTeam() == player.GetTeam() )
			{
				localscore += sPlayer.GetPlayerNetInt( "oddball_ballHeldTime" )
			} else
			{
				enemyscore += sPlayer.GetPlayerNetInt( "oddball_ballHeldTime" )
			}
		}
		
		if( localscore >= ODDBALL_POINTS_TO_WIN )
		{
			localscore = ODDBALL_POINTS_TO_WIN
		}else if( enemyscore >= ODDBALL_POINTS_TO_WIN )
		{
			enemyscore = ODDBALL_POINTS_TO_WIN
		}

		str_localscore = localscore.tostring()
		str_enemyscore = enemyscore.tostring() + "/" + ODDBALL_POINTS_TO_WIN.tostring()
		
		Hud_SetText( HudElement( "FS_Oddball_YourTeamScore"), str_localscore ) 
		Hud_SetText( HudElement( "FS_Oddball_EnemyTeamScore"), str_enemyscore ) 

		wait 0.01
	}
}

void function Oddball_BallOrCarrierEntityChanged( entity player, entity oldEnt, entity newEnt, bool actuallyChanged )
{
	printt( "ball or carrier changed, new: " + newEnt )

	entity localViewPlayer = GetLocalViewPlayer()

	if ( !IsValid( localViewPlayer ) || !IsValid( newEnt ) )
	{
		if( file.ballRui != null )
		{
			RuiDestroyIfAlive( file.ballRui )
			file.ballRui = null
		}
		return
	}
	
	Signal( localViewPlayer, "StopAutoDestroyRuiThread" )

	string msg
	asset icon
	
	if( !newEnt.IsPlayer() )
	{
		msg = "Pick Up"
		icon = $"rui/hud/gametype_icons/ctf/ctf_foreground"
	} else if( newEnt.IsPlayer() && newEnt.GetTeam() == localViewPlayer.GetTeam() )
	{
		msg = "Defend"
		icon = $"rui/hud/gametype_icons/ctf/ctf_foreground"
	} else if( newEnt.IsPlayer() && newEnt.GetTeam() != localViewPlayer.GetTeam() )
	{
		msg = "Enemy Scoring"
		icon = $"rui/hud/gametype_icons/ctf/ctf_foreground"
	}
	
	if( newEnt.IsPlayer() && newEnt == GetLocalViewPlayer() )
	{
		msg = "Ball Picked Up!"
		icon = $"rui/hud/gametype_icons/ctf/ctf_foreground"
	}

	Oddball_CreateBallRUI( newEnt, msg, icon )
}

var function Oddball_CreateBallRUI( entity ballOrCarrier, string text, asset icon )
{
	if( file.ballRui != null )
	{
		RuiDestroyIfAlive( file.ballRui )
		file.ballRui = null
		
		// if( ballOrCarrier == GetLocalViewPlayer() )
			// return
	}

    if( !IsValid( ballOrCarrier ) )
        return

	// var rui = CreateFullscreenRui( $"ui/waypoint_hub_areaofinterest.rpak", HUD_Z_BASE - 20 )
	// RuiTrackFloat3( rui, "targetCenter", ballOrCarrier, RUI_TRACK_OVERHEAD_FOLLOW )
	// RuiSetImage( rui, "iconImage", icon )
	// RuiSetString( rui, "inAreaText", text )

	// var rui = CreateFullscreenRui( $"ui/waypoint_basic_area.rpak", HUD_Z_BASE - 20 )
	// RuiTrackFloat3( rui, "targetCenter", ballOrCarrier, RUI_TRACK_OVERHEAD_FOLLOW )
	// RuiSetFloat( rui, "areaRadius2D", 15 )
	// RuiSetImage( rui, "iconImage", icon )
	// RuiSetString( rui, "outOfAreaText", text )
	// RuiSetString( rui, "inAreaText", text )
	
	var rui = CreateCockpitRui( $"ui/ctf_flag_marker.rpak", 200 )
	RuiSetBool( rui, "isVisible", true )
	RuiTrackFloat3( rui, "pos", ballOrCarrier, RUI_TRACK_OVERHEAD_FOLLOW )
	
	if( ballOrCarrier.IsPlayer() )
	{
		if( GetLocalViewPlayer() != ballOrCarrier )
			RuiTrackInt( rui, "teamRelation", ballOrCarrier, RUI_TRACK_TEAM_RELATION_VIEWPLAYER )
		else 
			RuiSetInt( rui, "teamRelation", 1 )
		RuiSetInt( rui, "flagStateFlags", -1 )
	}
	else 
	{
		//pick up
		RuiSetInt( rui, "teamRelation", 0 ) //pickup with enemy logo
		RuiSetInt( rui, "flagStateFlags", 1 ) //pick up
	}

	RuiSetBool( rui, "playerIsCarrying", ballOrCarrier.IsPlayer() && GetLocalViewPlayer() == ballOrCarrier )

	// var rui = CreateFullscreenRui( $"ui/waypoint_basic_entpos.rpak", HUD_Z_BASE - 20 )
	// RuiTrackFloat3( rui, "targetPos", ballOrCarrier, RUI_TRACK_OVERHEAD_FOLLOW )
	// RuiSetFloat3( rui, "playerAngles", <0,0,0> )
	// RuiSetString( rui, "promptText", text )
	// RuiSetImage( rui, "iconImage", icon )

	// var rui = CreateFullscreenRui( $"ui/waypoint_ping_entpos.rpak", HUD_Z_BASE - 20 )
	// RuiTrackFloat3( rui, "targetPos", ballOrCarrier, RUI_TRACK_OVERHEAD_FOLLOW )
	// RuiTrackInt( rui, "viewPlayerTeamMemberIndex", GetLocalViewPlayer(), RUI_TRACK_PLAYER_TEAM_MEMBER_INDEX )
	// RuiTrackBool( rui, "hasFocus", ballOrCarrier, RUI_TRACK_WAYPOINT_FOCUS_ENT_IS_FOCUSED )
	// RuiSetInt( rui, "confirmationCount", 1 )
	// RuiTrackFloat3( rui, "playerAngles", GetLocalViewPlayer(), RUI_TRACK_CAMANGLES_FOLLOW )
	// RuiSetFloat( rui, "pingOpacity", GetConVarFloat( "hud_setting_pingAlpha" ) )
	// RuiSetImage( rui, "iconImage", icon )
	// RuiSetString( rui, "promptText", text )
	// RuiSetString( rui, "shortPromptText", text )
	// RuiSetFloat( rui, "iconSize", 80.0 )
	// RuiSetFloat2( rui, "iconScale", <1,1,0> )
	// RuiSetFloat( rui, "iconSizePinned", 100.0 )
	// RuiSetImage( rui, "innerIcon", icon )
	// RuiSetImage( rui, "innerShadowIcon", icon )
	// RuiSetImage( rui, "outerIcon", icon )
	// RuiSetImage( rui, "shadowIcon", icon )
	// RuiSetBool( rui, "drawHeightLine", false )
	// RuiSetImage( rui, "animIcon", $"rui/hud/unitframes/frame_status_fill" )
	// RuiSetBool( rui, "additive", true )
	// RuiSetFloat( rui, "iconSize", 120.0 )
	// RuiSetFloat( rui, "iconSizePinned", 120.0 )
	// RuiSetFloat3( rui, "iconColor", SrgbToLinear( <48, 107, 255> / 255.0 ) )
	// RuiSetBool( rui, "completeADSFade", true )
	// RuiSetString( rui, "ownerPlayerName", text )
	
	// var rui = CreateFullscreenRui( $"ui/waypoint_generic_pve.rpak", HUD_Z_BASE - 20 )
	// RuiTrackFloat3( rui, "targetPos", ballOrCarrier, RUI_TRACK_OVERHEAD_FOLLOW )
	// RuiTrackInt( rui, "viewPlayerTeamMemberIndex", GetLocalViewPlayer(), RUI_TRACK_PLAYER_TEAM_MEMBER_INDEX )
	// RuiTrackBool( rui, "hasFocus", ballOrCarrier, RUI_TRACK_WAYPOINT_FOCUS_ENT_IS_FOCUSED )
	// RuiSetInt( rui, "confirmationCount", 1 )
	// RuiSetFloat( rui, "pingOpacity", GetConVarFloat( "hud_setting_pingAlpha" ) )
	// RuiSetImage( rui, "iconImage", icon )
	// RuiSetString( rui, "promptText", text )
	// RuiSetString( rui, "shortPromptText", text )
	// RuiSetFloat3( rui, "iconColor", SrgbToLinear( <48, 107, 255> / 255.0 ) )
	
	// var rui = CreateFullscreenRui( $"ui/waypoint_loot_entpos.rpak", HUD_Z_BASE - 20 )
	// RuiTrackFloat3( rui, "targetPos", ballOrCarrier, RUI_TRACK_OVERHEAD_FOLLOW )
	// RuiSetBool( rui, "hasFocus", true )
	// RuiSetInt( rui, "lootTier", 5 )
	// RuiSetString( rui, "promptText", text )
	// RuiSetString( rui, "shortPromptText", text )
	// RuiSetImage( rui, "iconImage", icon )
	// RuiSetFloat2( rui, "iconScale", <1.0, 1.0, 0.0> )
	// RuiSetImage( rui, "innerIcon", $"" ) //rui/hud/ping/icon_ping_loot_inner
	// RuiSetImage( rui, "innerShadowIcon", $"" ) //rui/hud/ping/icon_ping_loot_inner_shadow
	// RuiSetImage( rui, "outerIcon", $"" )
	// RuiSetImage( rui, "shadowIcon", $"" )
	// RuiSetImage( rui, "animIcon", $"" ) //rui/hud/ping/icon_ping_loot_outline
	// RuiSetBool( rui, "isImportant", true )
	// RuiSetFloat( rui, "iconSize", 64.0 )
	// RuiSetFloat( rui, "iconSizePinned", 64.0 )
	// RuiSetString( rui, "pingPrompt", text )
	// RuiSetString( rui, "pingPromptForOwner", text )
	// RuiSetBool( rui, "viewPlayerHasConfirmed", false )

	// var rui = CreateFullscreenRui( $"ui/overhead_icon_generic.rpak", HUD_Z_BASE - 20 )
	// RuiSetImage( rui, "icon", icon )
	// RuiSetBool( rui, "isVisible", true )
	// RuiSetBool( rui, "pinToEdge", true )
	// RuiTrackFloat3( rui, "pos", ballOrCarrier, RUI_TRACK_OVERHEAD_FOLLOW )
	// RuiSetFloat2( rui, "iconSize", <30,30,0> )
	// RuiSetFloat( rui, "distanceFade", 100000 )
	// RuiSetBool( rui, "adsFade", true )
	// RuiSetString( rui, "hint", text )
	
	file.ballRui = rui
	
	if( ballOrCarrier == GetLocalViewPlayer() )
	{
		thread function () : ( ballOrCarrier )
		{
			EndSignal( GetLocalViewPlayer(), "StopAutoDestroyRuiThread" )
			float endtime = Time() + 3.5

			OnThreadEnd(
				function() : ( )
				{
					if( file.ballRui != null )
					{
						RuiDestroyIfAlive( file.ballRui )
						file.ballRui = null
					}
				}
			)

			while( Time() <= endtime )
				WaitFrame()
		}()
	}
    return rui
}

void function FSDM_CustomWinnerScreen_Start(int winnerTeam, int reason)
{
	thread function() : (winnerTeam, reason)
	{
		printt( "Starting custom winner screen: Winner: " + winnerTeam, reason )
		entity player = GetLocalClientPlayer()
		
		// if( player != GetLocalViewPlayer() ) return
		
		Signal(player, "StartNewWinnerScreen")
		// Signal(player, "NewKillChangeRui")
		// Signal(player, "OnChargeEnd")
		// Signal(player, "SND_EndTimer")

		DoF_SetFarDepth( 50, 1000 )
		EndSignal(player, "StartNewWinnerScreen")

		OnThreadEnd(
			function() : ( )
			{
				DoF_SetNearDepthToDefault()
				DoF_SetFarDepthToDefault()
			}
		)

		EmitSoundOnEntity( player, "Music_CharacterSelect_Wattson" )

		var LTMLogo = HudElement( "SkullLogo")
		var RoundWinOrLoseText = HudElement( "WinOrLoseText")
		var WinOrLoseReason = HudElement( "WinOrLoseReason")
		var LTMBoxMsg = HudElement( "LTMBoxMsg")
		
		bool localPlayerIsWinner = player.GetTeam() == winnerTeam
		
		if( localPlayerIsWinner )
			RuiSetImage( Hud_GetRui( LTMLogo ), "basicImage", $"rui/flowstatecustom/ltm_logo" )
		else
			RuiSetImage( Hud_GetRui( LTMLogo ), "basicImage", $"rui/flowstatecustom/ltm_logo_red" )
		
		
		if( localPlayerIsWinner )
			RuiSetImage( Hud_GetRui( LTMBoxMsg ), "basicImage", $"rui/flowstatecustom/ltm_box_msg" )
		else
			RuiSetImage( Hud_GetRui( LTMBoxMsg ), "basicImage", $"rui/flowstatecustom/ltm_box_msg_red" )
		
		string roundText = localPlayerIsWinner ? "MATCH WIN" : "MATCH LOSS"

		string reasonText
		string teamText

		if( Playlist() == ePlaylists.fs_haloMod_oddball )
		{
			switch(reason)
			{
				case 0:
					if( localPlayerIsWinner )
						reasonText = "YOUR TEAM DOMINATED THE BALL"
					else
						reasonText = "THE ENEMY TEAM HELD THE BALL THE LONGEST"
				break

				case 1:
					roundText = "TIE"
					reasonText = "TIME RAN OUT, AND BOTH TEAMS HAD THE SAME SCORE"
				break
			}
		} else if( Playlist() == ePlaylists.fs_haloMod_ctf )
		{
			switch(reason)
			{
				case 0:
					if( localPlayerIsWinner )
						reasonText = "YOUR TEAM HAS WON"
					else
						reasonText = "THE ENEMY TEAM HAS WON"
				break

				case 1:
					roundText = "TIE"
					reasonText = "TIME RAN OUT, AND BOTH TEAMS HAD THE SAME SCORE"
				break
			}
		}
		
		Hud_SetText( RoundWinOrLoseText, roundText )
		Hud_SetText( WinOrLoseReason, reasonText )
		DoF_SetFarDepth( 2, 10 )
		wait 2
		
		EmitSoundOnEntity(player, "UI_InGame_Top5_Streak_1X")
		wait 0.7

		Hud_SetEnabled( LTMLogo, true )
		Hud_SetVisible( LTMLogo, true )
		
		Hud_SetEnabled( RoundWinOrLoseText, true )
		Hud_SetVisible( RoundWinOrLoseText, true )
		
		Hud_SetEnabled( WinOrLoseReason, true )
		Hud_SetVisible( WinOrLoseReason, true )
		
		Hud_SetEnabled( LTMBoxMsg, true )
		Hud_SetVisible( LTMBoxMsg, true )
		
		Hud_SetSize( LTMLogo, 0, 0 )
		Hud_SetSize( LTMBoxMsg, 0, 0 )
		Hud_SetSize( RoundWinOrLoseText, 0, 0 )
		Hud_SetSize( WinOrLoseReason, 0, 0 )

		Hud_ScaleOverTime( LTMLogo, 1.2, 1.2, 0.6, INTERPOLATOR_ACCEL )

		wait 0.6
		
		Hud_ScaleOverTime( LTMLogo, 1, 1, 0.15, INTERPOLATOR_LINEAR )
		
		wait 0.35
		
		Hud_ScaleOverTime( RoundWinOrLoseText, 1, 1, 0.35, INTERPOLATOR_SIMPLESPLINE )
		Hud_ScaleOverTime( LTMBoxMsg, 1, 1, 0.3, INTERPOLATOR_SIMPLESPLINE )
		Hud_ScaleOverTime( WinOrLoseReason, 1, 1, 0.35, INTERPOLATOR_SIMPLESPLINE )
		
		wait 5
		
		Hud_ScaleOverTime( LTMLogo, 1.3, 0.05, 0.15, INTERPOLATOR_ACCEL )
		
		Hud_ScaleOverTime( RoundWinOrLoseText, 1.3, 0.05, 0.15, INTERPOLATOR_ACCEL )
		Hud_ScaleOverTime( LTMBoxMsg, 1.3, 0.05, 0.15, INTERPOLATOR_ACCEL )
		Hud_ScaleOverTime( WinOrLoseReason, 1.3, 0.05, 0.15, INTERPOLATOR_ACCEL )
		
		wait 0.15
		
		Hud_ScaleOverTime( LTMLogo, 0, 0, 0.1, INTERPOLATOR_LINEAR )
		Hud_ScaleOverTime( RoundWinOrLoseText, 0, 0, 0.1, INTERPOLATOR_LINEAR )
		Hud_ScaleOverTime( LTMBoxMsg, 0, 0, 0.1, INTERPOLATOR_LINEAR )
		Hud_ScaleOverTime( WinOrLoseReason, 0, 0, 0.1, INTERPOLATOR_LINEAR )
		
		if(IsValid(GetLocalViewPlayer()))
			EmitSoundOnEntity(GetLocalViewPlayer(), "HUD_MP_Match_End_WinLoss_UI_Sweep_1P")
		
		wait 1.15
		
		Hud_SetEnabled( LTMLogo, false )
		Hud_SetVisible( LTMLogo, false )
		
		Hud_SetEnabled( RoundWinOrLoseText, false )
		Hud_SetVisible( RoundWinOrLoseText, false )
		
		Hud_SetEnabled( WinOrLoseReason, false )
		Hud_SetVisible( WinOrLoseReason, false )
		
		Hud_SetEnabled( LTMBoxMsg, false )
		Hud_SetVisible( LTMBoxMsg, false )
		
		Hud_SetSize( LTMLogo, 1, 1 )
		Hud_SetSize( RoundWinOrLoseText, 1, 1 )
		
		FadeOutSoundOnEntity( GetLocalClientPlayer(), "Music_CharacterSelect_Wattson", 0.2 )
	}()
}
