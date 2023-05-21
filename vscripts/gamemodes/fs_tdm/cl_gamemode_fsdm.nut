global function Cl_CustomTDM_Init
global function Cl_RegisterLocation
global function OpenTDMWeaponSelectorUI
global function ServerCallback_SendScoreboardToClient
global function ServerCallback_SendProphuntPropsScoreboardToClient
global function ServerCallback_SendProphuntHuntersScoreboardToClient
global function ServerCallback_ClearScoreboardOnClient
global function NotifyRingTimer
	
//Statistics
global function ServerCallback_OpenStatisticsUI

// Voting
global function ServerCallback_FSDM_OpenVotingPhase
global function ServerCallback_FSDM_ChampionScreenHandle
global function ServerCallback_FSDM_UpdateVotingMaps
global function ServerCallback_FSDM_UpdateMapVotesClient
global function ServerCallback_FSDM_SetScreen
global function ServerCallback_FSDM_CoolCamera
global function PROPHUNT_AddWinningSquadData_PropTeamAddModelIndex
global function DM_HintCatalog
global function FSDM_CloseVotingPhase

//Ui callbacks
global function UI_To_Client_VoteForMap_FSDM

const string CIRCLE_CLOSING_IN_SOUND = "UI_InGame_RingMoveWarning" //"survival_circle_close_alarm_01"


struct {
    LocationSettings &selectedLocation
    array<LocationSettings> locationSettings
	int teamwon
	vector victorySequencePosition = < 0, 0, 10000 >
	vector victorySequenceAngles = < 0, 0, 0 >
	SquadSummaryData winnerSquadSummaryData
	bool forceShowSelectedLocation = false

	var activeQuickHint
} file

struct VictoryCameraPackage
{
	vector camera_offset_start
	vector camera_offset_end
	vector camera_focus_offset
	float camera_fov
}

bool hasvoted = false
bool isvoting = false
bool roundover = false
array<var> overHeadRuis
array<entity> cleanupEnts

void function Cl_CustomTDM_Init()
{
    AddCallback_EntitiesDidLoad( NotifyRingTimer )
	RegisterButtonPressedCallback(KEY_ENTER, ClientReportChat)
	PrecacheParticleSystem($"P_wpn_lasercannon_aim_short_blue")
	
	RegisterSignal("ChallengeStartRemoveCameras")
	RegisterSignal("ChangeCameraToSelectedLocation")
}

void function Cl_RegisterLocation(LocationSettings locationSettings)
{
    file.locationSettings.append(locationSettings)
}

void function ClientReportChat(var button)
{
	if(CHAT_TEXT  == "") return
	
	string text = "say " + CHAT_TEXT
	GetLocalClientPlayer().ClientCommand(text)
}

void function ServerCallback_FSDM_CoolCamera()
{
    thread CoolCamera()
}

LocPair function NewCameraPair(vector origin, vector angles)
{
    LocPair locPair
    locPair.origin = origin
    locPair.angles = angles

    return locPair
}

void function CoolCamera()
//based on sal's tdm
{
    entity player = GetLocalClientPlayer()
	player.EndSignal("ChangeCameraToSelectedLocation")
	array<LocPair> cutsceneSpawns
	
    if(!IsValid(player)) return
	
	switch(GetMapName())
	{
		case "mp_rr_desertlands_64k_x_64k":
		case "mp_rr_desertlands_64k_x_64k_nx":
		case "mp_rr_desertlands_64k_x_64k_tt":		
		cutsceneSpawns.append(NewCameraPair(<10915.0039, 6811.3418, -3539.73657>,<0, -100.5355, 0>))
		cutsceneSpawns.append(NewCameraPair(<9586.79199, 24404.5898, -2019.6366>, <0, -52.6216431, 0>)) 
		cutsceneSpawns.append(NewCameraPair(<-29335.9199, 11470.1729, -2374.77954>,<0, -2.17369795, 0>))
		cutsceneSpawns.append(NewCameraPair(<16346.3076, -34468.9492, -1109.32153>, <0, -44.3879509, 0>))
		cutsceneSpawns.append(NewCameraPair(<1133.25562, -20102.9648, -2488.08252>, <0, -24.9140873, 0>))		
		cutsceneSpawns.append(NewCameraPair(<4225.83447, 3396.84448, -3090.29712>,<0, 38.1615944, 0>))
		cutsceneSpawns.append(NewCameraPair(<-9873.3916, 5598.64307, -2453.47461>,<0, -107.887512, 0>))
		cutsceneSpawns.append(NewCameraPair(<-28200.6348, 2603.86792, -3899.62598>,<0, -94.3539505, 0>))
		cutsceneSpawns.append(NewCameraPair(<-13217.0469, 24311.4375, -3157.30908>,<0, 97.8569489, 0>))
		break
		
		case "mp_rr_canyonlands_staging":
		case "mp_rr_ashs_redemption":
		cutsceneSpawns.append(NewCameraPair(<32645.04,-9575.77,-25911.94>, <7.71,91.67,0.00>)) 
		cutsceneSpawns.append(NewCameraPair(<49180.1055, -6836.14502, -23461.8379>, <0, -55.7723808, 0>)) 
		cutsceneSpawns.append(NewCameraPair(<43552.3203, -1023.86182, -25270.9766>, <0, 20.9528542, 0>))
		cutsceneSpawns.append(NewCameraPair(<30038.0254, -1036.81982, -23369.6035>, <55, -24.2035522, 0>))
		break
		
		case "mp_rr_canyonlands_mu1":
		case "mp_rr_canyonlands_mu1_night":
		case "mp_rr_canyonlands_64k_x_64k":
		cutsceneSpawns.append(NewCameraPair(<-7984.68408, -16770.2031, 3972.28271>, <0, -158.605301, 0>)) 
		cutsceneSpawns.append(NewCameraPair(<-19691.1621, 5229.45264, 4238.53125>, <0, -54.6054993, 0>))
		cutsceneSpawns.append(NewCameraPair(<13270.0576, -20413.9023, 2999.29468>, <0, 98.6180649, 0>))
		cutsceneSpawns.append(NewCameraPair(<-25250.0391, -723.554199, 3427.51831>, <0, -55.5126762, 0>))
		cutsceneSpawns.append(NewCameraPair(<10445.5107, -30267.8691, 3435.0647>,<0, -151.025223, 0>))
		cutsceneSpawns.append(NewCameraPair(<-21710.4395, -12452.8604, 2887.22778>,<0, 29.4609108, 0>))
		cutsceneSpawns.append(NewCameraPair(<-17403.5469, 15699.3867, 4041.38379>,<0, -1.59664249, 0>))
		cutsceneSpawns.append(NewCameraPair(<-3939.00781, 16862.0586, 3525.45728>,<0, 142.246902, 0>))
		cutsceneSpawns.append(NewCameraPair(<26928.9668, 7577.22363, 2926.2876>,<0, 55.0248222, 0>))
		cutsceneSpawns.append(NewCameraPair(<32170.3008, -1944.38562, 3590.89258>,<0, 27.8040161, 0>))
		break
		
		case "mp_rr_party_crasher":
		case "mp_rr_party_crasher_new":
		cutsceneSpawns.append(NewCameraPair(<-1363.75867, -2183.58081, 1354.65466>, <0, 72.5054092, 0>)) 
		cutsceneSpawns.append(NewCameraPair(<2378.75439, 1177.52783, 1309.69019>, <0, 146.118546, 0>))
		break
		
		case "mp_rr_arena_composite":
		cutsceneSpawns.append(NewCameraPair(<2343.25171, 4311.43896, 829.289917>, <0, -139.293152, 0>)) 
		cutsceneSpawns.append(NewCameraPair(<-1661.23608, 2852.71924, 657.674316>, <0, -56.0820427, 0>)) 
		cutsceneSpawns.append(NewCameraPair(<-640.810059, 1039.97424, 514.500793>, <0, -23.5162239, 0>)) 
		break
		
		case "mp_rr_aqueduct":
		case "mp_rr_aqueduct_night":
		cutsceneSpawns.append(NewCameraPair(<1593.85205, -3274.99365, 1044.39099>, <0, -126.270805, 0>)) 
		cutsceneSpawns.append(NewCameraPair(<1489.99255, -6570.93262, 741.996887>, <0, 133.833832, 0>))
		break 
		
		case "mp_rr_arena_skygarden":
		cutsceneSpawns.append(NewCameraPair(<-9000, 3274.99365, 4044.39099>, <0, -126.270805, 0>)) 
		cutsceneSpawns.append(NewCameraPair(<1489.99255, -6570.93262, 4041.996887>, <0, 133.833832, 0>)) 
		break
	}


    //EmitSoundOnEntity( player, "music_skyway_04_smartpistolrun" )

    float playerFOV = player.GetFOV()
	
	cutsceneSpawns.randomize()
	vector randomcameraPos = cutsceneSpawns[0].origin
	vector randomcameraAng = cutsceneSpawns[0].angles
	
    entity camera = CreateClientSidePointCamera(randomcameraPos, randomcameraAng, 17)
    camera.SetFOV(100)
    entity cutsceneMover = CreateClientsideScriptMover($"mdl/dev/empty_model.rmdl", randomcameraPos, randomcameraAng)
    camera.SetParent(cutsceneMover)
	GetLocalClientPlayer().SetMenuCameraEntity( camera )
	DoF_SetFarDepth( 6000, 10000 )	
	
	OnThreadEnd(
		function() : ( player, cutsceneMover, camera, cutsceneSpawns )
		{
			thread function() : (player, cutsceneMover, camera, cutsceneSpawns)
			{
				if(GameRules_GetGameMode() == "flowstate_snd")
				{
					GetLocalClientPlayer().ClearMenuCameraEntity()
					cutsceneMover.Destroy()

					// if(IsValid(player))
					// {
						// FadeOutSoundOnEntity( player, "music_skyway_04_smartpistolrun", 1 )
					// }
					if(IsValid(camera))
					{
						camera.Destroy()
					}
					DoF_SetNearDepthToDefault()
					DoF_SetFarDepthToDefault()
					return
				}
					
				EndSignal(player, "ChallengeStartRemoveCameras")
				
				OnThreadEnd(
				function() : ( player, cutsceneMover, camera )
				{
					GetLocalClientPlayer().ClearMenuCameraEntity()
					cutsceneMover.Destroy()

					// if(IsValid(player))
					// {
						// FadeOutSoundOnEntity( player, "music_skyway_04_smartpistolrun", 1 )
					// }
					if(IsValid(camera))
					{
						camera.Destroy()
					}
					DoF_SetNearDepthToDefault()
					DoF_SetFarDepthToDefault()			
				})
				
				waitthread CoolCameraMovement(player, cutsceneMover, camera, file.selectedLocation.spawns, true)
			}()
		}
	)
	
	waitthread CoolCameraMovement(player, cutsceneMover, camera, cutsceneSpawns)
}

void function CoolCameraMovement(entity player, entity cutsceneMover, entity camera, array<LocPair> cutsceneSpawns, bool isSelectedZoneCamera = false)
{
	int locationindex = 0
	
	vector startpos
	vector startangs
	
	vector finalpos
	vector finalangs	
	
	if(isSelectedZoneCamera)
	{
		LocPair far = file.selectedLocation.spawns.getrandom()
		startpos = far.origin
		if(file.selectedLocation.name != "Swamps")
			startpos.z+= 2000
		else
			startpos.z+= 1500
		startangs = far.angles
		
		finalpos = GetCenterOfCircle(file.selectedLocation.spawns)
		//calcular el más lejano
	}
	else
	{
		startpos = cutsceneSpawns[locationindex].origin
		startangs = cutsceneSpawns[locationindex].angles
	}
		
	while(true){
		if(locationindex == cutsceneSpawns.len()){
			locationindex = 0
		}
		
		if(!isSelectedZoneCamera)
		{
			startpos = cutsceneSpawns[locationindex].origin
			startangs = cutsceneSpawns[locationindex].angles		
		}
		locationindex++
		cutsceneMover.SetOrigin(startpos)
		cutsceneMover.SetAngles(startangs)
		camera.SetOrigin(startpos)
		camera.SetAngles(startangs)
		
		if(isSelectedZoneCamera)
		{
			camera.SetFOV(90)
			cutsceneMover.NonPhysicsMoveTo(finalpos, 30, 0, 0)
			cutsceneMover.NonPhysicsRotateTo( VectorToAngles( finalpos - startpos ), 5, 0.0, 6 / 2.0 )
			WaitForever()
		}
		else
		{
			cutsceneMover.NonPhysicsMoveTo(startpos + AnglesToRight(startangs) * 700, 15, 0, 0)
			cutsceneMover.NonPhysicsRotateTo( startangs, 10, 0.0, 6 / 2.0 )	
			wait 5
		}
	}	
}

LocPair function GetUbicacionMasLejana(LocPair random)
{
	array<float> allspawnsDistances
	
	for(int i = 0; i<file.selectedLocation.spawns.len(); i++)
	{
		allspawnsDistances.append(Distance(random.origin, file.selectedLocation.spawns[i].origin))
	}
	
	float compareDis = -1
	int bestpos = 0
	for(int j = 1; j<allspawnsDistances.len(); j++)
	{
		if(allspawnsDistances[j] > compareDis)
		{
			compareDis = allspawnsDistances[j]
			bestpos = j
		}	
	}

    return file.selectedLocation.spawns[bestpos]
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

    // if ( SURVIVAL_IsFinalDeathFieldStage() )
        // roundString = "#SURVIVAL_CIRCLE_ROUND_FINAL"
    // else
        // roundString = Localize( "#SURVIVAL_CIRCLE_ROUND", SURVIVAL_GetCurrentRoundString() )

    // float duration = 7.0

    // AnnouncementData announcement
    // announcement = Announcement_Create( "" )
    // Announcement_SetSubText( announcement, roundString )
    // Announcement_SetHeaderText( announcement, "#SURVIVAL_CIRCLE_WARNING" )
    // Announcement_SetDisplayEndTime( announcement, new )
    // Announcement_SetStyle( announcement, ANNOUNCEMENT_STYLE_CIRCLE_WARNING )
    // Announcement_SetSoundAlias( announcement, CIRCLE_CLOSING_IN_SOUND )
    // Announcement_SetPurge( announcement, true )
    // Announcement_SetPriority( announcement, 200 ) //
    // Announcement_SetDuration( announcement, duration )

    // AnnouncementFromClass( GetLocalViewPlayer(), announcement )
}

void function OpenTDMWeaponSelectorUI()
{
	entity player = GetLocalClientPlayer()
    player.ClientCommand("CC_TDM_Weapon_Selector_Open")
	DoF_SetFarDepth( 1, 300 )
	RunUIScript("OpenFRChallengesSettingsWpnSelector")
}

void function ServerCallback_SendScoreboardToClient(int eHandle, int score, int deaths, float kd, int damage, int latency)
{
	if ( !EHIHasValidScriptStruct( eHandle ) ) 
		return
		
	RunUIScript( "SendScoreboardToUI", EHI_GetName(eHandle), score, deaths, kd, damage, latency)
}

void function ServerCallback_SendProphuntPropsScoreboardToClient(int eHandle, int score, int survivaltime)
{
	if ( !EHIHasValidScriptStruct( eHandle ) ) 
		return
	
	RunUIScript( "SendPropsScoreboardToUI", EHI_GetName(eHandle), score, survivaltime)
}

void function ServerCallback_SendProphuntHuntersScoreboardToClient(int eHandle, int propskilled)
{
	if ( !EHIHasValidScriptStruct( eHandle ) ) 
		return
	
	RunUIScript( "SendHuntersScoreboardToUI", EHI_GetName(eHandle), propskilled)
}

void function ServerCallback_ClearScoreboardOnClient()
{
	if(GameRules_GetGameMode() == "fs_prophunt")
		RunUIScript( "ClearProphuntScoreboardOnUI")
	else
		RunUIScript( "ClearScoreboardOnUI")
}

void function ServerCallback_OpenStatisticsUI()
{
	entity player = GetLocalClientPlayer()
	RunUIScript( "OpenStatisticsUI" )	
}

void function ServerCallback_FSDM_OpenVotingPhase(bool shouldOpen)
{
	if(shouldOpen)
	{
		//try { GetLocalClientPlayer().ClearMenuCameraEntity(); GetWinnerPropCameraEntities()[0].ClearParent(); GetWinnerPropCameraEntities()[0].Destroy(); GetWinnerPropCameraEntities()[1].Destroy() } catch (exceptio2n){ }
		RunUIScript( "Open_FSDM_VotingPhase" )
	}
	else
		thread FSDM_CloseVotingPhase()
	
}

void function ServerCallback_FSDM_ChampionScreenHandle(bool shouldOpen, int TeamWon, int skinindex)
{
    file.teamwon = TeamWon
	
    if( shouldOpen )
        thread CreateChampionUI(skinindex)
    else
        thread DestroyChampionUI()
}

void function CreateChampionUI(int skinindex)
{
    hasvoted = false
    isvoting = true
    roundover = true
	
    EmitSoundOnEntity( GetLocalClientPlayer(), "Music_CharacterSelect_Wattson" )
    // ScreenFade(GetLocalClientPlayer(), 0, 0, 0, 255, 0.4, 0.5, FFADE_OUT | FFADE_PURGE)
    // wait 0.9
	
    entity targetBackground = GetEntByScriptName( "target_char_sel_bg_new" )
    entity targetCamera = GetEntByScriptName( "target_char_sel_camera_new" )
	
	if(file.teamwon != 3 && GameRules_GetGameMode() == "fs_prophunt" || GameRules_GetGameMode() == "flowstate_pkknockback")
	{
		//Clear Winning Squad Data
		AddWinningSquadData( -1, -1)
		
		//Set Squad Data For Each Player In Winning Team
		foreach( int i, entity player in GetPlayerArrayOfTeam_Alive( file.teamwon ) )
		{
			AddWinningSquadData( i, player.GetEncodedEHandle())
		}
	}
    thread Show_FSDM_VictorySequence(skinindex)
	
    // ScreenFade(GetLocalClientPlayer(), 0, 0, 0, 255, 0.3, 0.0, FFADE_IN | FFADE_PURGE)
}

void function DestroyChampionUI()
{
    foreach( rui in overHeadRuis )
		RuiDestroyIfAlive( rui )

    foreach( entity ent in cleanupEnts )
		ent.Destroy()

    overHeadRuis.clear()
    cleanupEnts.clear()	
}

void function FSDM_CloseVotingPhase()
{
    isvoting = false
    
    FadeOutSoundOnEntity( GetLocalClientPlayer(), "Music_CharacterSelect_Event3_Solo", 0.2 )

    // wait 1

    GetLocalClientPlayer().ClearMenuCameraEntity()

    RunUIScript( "Close_FSDM_VoteMenu" )
    GetLocalClientPlayer().Signal("ChallengeStartRemoveCameras")

}

void function UpdateUIVoteTimer(int team)
{
	RunUIScript( "UpdateVoteTimerHeader_FSDM" )
    float time = team - Time()
    while(time > -1)
    {
        RunUIScript( "UpdateVoteTimer_FSDM", int(time))

        if (time <= 5 && time != 0)
            EmitSoundOnEntity( GetLocalClientPlayer(), "ui_ingame_markedfordeath_countdowntomarked" )

        if (time == 0)
            EmitSoundOnEntity( GetLocalClientPlayer(), "ui_ingame_markedfordeath_countdowntoyouaremarked" )

        time--

        wait 1
    }
}

void function UI_To_Client_VoteForMap_FSDM(int mapid)
{
    if(hasvoted)
        return

    entity player = GetLocalClientPlayer()
    player.ClientCommand("VoteForMap " + mapid)
    RunUIScript("UpdateVotedFor_FSDM", mapid + 1)

    hasvoted = true
}

void function ServerCallback_FSDM_UpdateMapVotesClient( int map1votes, int map2votes, int map3votes, int map4votes)
{
    RunUIScript("UpdateVotesUI_FSDM", map1votes, map2votes, map3votes, map4votes)
}

void function ServerCallback_FSDM_UpdateVotingMaps( int map1, int map2, int map3, int map4)
{
    RunUIScript("UpdateMapsForVoting_FSDM", file.locationSettings[map1].name, file.locationSettings[map1].locationAsset, file.locationSettings[map2].name, file.locationSettings[map2].locationAsset, file.locationSettings[map3].name, file.locationSettings[map3].locationAsset, file.locationSettings[map4].name, file.locationSettings[map4].locationAsset)
}

void function ServerCallback_FSDM_SetScreen(int screen, int team, int mapid, int done)
{
    switch(screen)
    {
        case eFSDMScreen.ScoreboardUI: //Sets the screen to the winners screen
			DestroyChampionUI()
			
			if(GameRules_GetGameMode() == "fs_prophunt")
				RunUIScript("Set_FSDM_ProphuntScoreboardScreen")
			else
				RunUIScript("Set_FSDM_ScoreboardScreen")
			
            break

        case eFSDMScreen.WinnerScreen: //Sets the screen to the winners screen
            RunUIScript("Set_FSDM_TeamWonScreen", GetWinningTeamText(team))
            break

        case eFSDMScreen.VoteScreen: //Sets the screen to the vote screen
			DestroyChampionUI()
			
			hasvoted = false
			isvoting = true
			roundover = true
			
            EmitSoundOnEntity( GetLocalClientPlayer(), "UI_PostGame_CoinMove" )
            thread UpdateUIVoteTimer(team)
            RunUIScript("Set_FSDM_VotingScreen")
            break

        case eFSDMScreen.TiedScreen: //Sets the screen to the tied screen
            switch(done)
            {
				case 0:
					EmitSoundOnEntity( GetLocalClientPlayer(), "HUD_match_start_timer_tick_1P" )
					break
				case 1:
					EmitSoundOnEntity( GetLocalClientPlayer(),  "UI_PostGame_CoinMove" )
					break
            }

            if (mapid == 42069)
                RunUIScript( "UpdateVotedLocation_FSDMTied", "")
            else
                RunUIScript( "UpdateVotedLocation_FSDMTied", file.locationSettings[mapid].name)
            break

        case eFSDMScreen.SelectedScreen: //Sets the screen to the selected location screen
            EmitSoundOnEntity( GetLocalClientPlayer(), "UI_PostGame_Level_Up_Pilot" )
            RunUIScript( "UpdateVotedLocation_FSDM", file.locationSettings[mapid].name)
			file.selectedLocation = file.locationSettings[mapid]
			Signal(GetLocalClientPlayer(), "ChangeCameraToSelectedLocation")
            break

        case eFSDMScreen.NextRoundScreen: //Sets the screen to the next round screen
            EmitSoundOnEntity( GetLocalClientPlayer(), "UI_PostGame_Level_Up_Pilot" )
            FadeOutSoundOnEntity( GetLocalClientPlayer(), "Music_CharacterSelect_Wattson", 0.2 )
            RunUIScript("Set_FSDM_VoteMenuNextRound")
            break
    }
}

string function GetWinningTeamText(int team)
{
    string teamwon = ""
    // switch(team)
    // {
        // case TEAM_IMC:
            // teamwon = "IMC has won"
            // break
        // case TEAM_MILITIA:
            // teamwon = "MILITIA has won"
            // break
        // case 69:
            // teamwon = "Winner couldn't be decided"
            // break
    // }
	// if(IsFFAGame())
		// teamwon = GetPlayerArrayOfTeam( team )[0].GetPlayerName() + " has won."
	// else
		// teamwon = "Team " + team + " has won."
	
    return teamwon
}

array<ItemFlavor> function GetAllGoodAnimsFromGladcardStancesForCharacter_ChampionScreen(ItemFlavor character)
///////////////////////////////////////////////////////
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
/////////////////////////////////////////////////////// 
//Don't try this at home
{
	array<ItemFlavor> actualGoodAnimsForThisCharacter
	switch(ItemFlavor_GetHumanReadableRef( character )){
			case "character_pathfinder":
		actualGoodAnimsForThisCharacter.append( GetItemFlavorByGUID( ConvertItemFlavorGUIDStringToGUID( "SAID00543164026" ) ) )
		return actualGoodAnimsForThisCharacter
		
			case "character_bangalore":
		actualGoodAnimsForThisCharacter.append( GetItemFlavorByGUID( ConvertItemFlavorGUIDStringToGUID( "SAID02041779191" ) ) )
		return actualGoodAnimsForThisCharacter
		
			case "character_bloodhound":
		actualGoodAnimsForThisCharacter.append( GetItemFlavorByGUID( ConvertItemFlavorGUIDStringToGUID( "SAID00982377873" ) ) )
		actualGoodAnimsForThisCharacter.append( GetItemFlavorByGUID( ConvertItemFlavorGUIDStringToGUID( "SAID00924111436" ) ) )
		return actualGoodAnimsForThisCharacter
		
			case "character_caustic":
		actualGoodAnimsForThisCharacter.append( GetItemFlavorByGUID( ConvertItemFlavorGUIDStringToGUID( "SAID01037940994" ) ) )
		actualGoodAnimsForThisCharacter.append( GetItemFlavorByGUID( ConvertItemFlavorGUIDStringToGUID( "SAID01924098215" ) ) )
		actualGoodAnimsForThisCharacter.append( GetItemFlavorByGUID( ConvertItemFlavorGUIDStringToGUID( "SAID00844387739" ) ) )
		return actualGoodAnimsForThisCharacter
		
			case "character_gibraltar":
		actualGoodAnimsForThisCharacter.append( GetItemFlavorByGUID( ConvertItemFlavorGUIDStringToGUID( "SAID00335495845" ) ) )
		actualGoodAnimsForThisCharacter.append( GetItemFlavorByGUID( ConvertItemFlavorGUIDStringToGUID( "SAID01763092699" ) ) )
		actualGoodAnimsForThisCharacter.append( GetItemFlavorByGUID( ConvertItemFlavorGUIDStringToGUID( "SAID01066049905" ) ) )
		actualGoodAnimsForThisCharacter.append( GetItemFlavorByGUID( ConvertItemFlavorGUIDStringToGUID( "SAID01139949206" ) ) )
		actualGoodAnimsForThisCharacter.append( GetItemFlavorByGUID( ConvertItemFlavorGUIDStringToGUID( "SAID00558533496" ) ) )
		return actualGoodAnimsForThisCharacter
		
			case "character_lifeline":
		actualGoodAnimsForThisCharacter.append( GetItemFlavorByGUID( ConvertItemFlavorGUIDStringToGUID( "SAID00294421454" ) ) )
		actualGoodAnimsForThisCharacter.append( GetItemFlavorByGUID( ConvertItemFlavorGUIDStringToGUID( "SAID01386679009" ) ) )
		return actualGoodAnimsForThisCharacter

			case "character_mirage":
		actualGoodAnimsForThisCharacter.append( GetItemFlavorByGUID( ConvertItemFlavorGUIDStringToGUID( "SAID01262193178" ) ) )
		actualGoodAnimsForThisCharacter.append( GetItemFlavorByGUID( ConvertItemFlavorGUIDStringToGUID( "SAID00986179205" ) ) )
		actualGoodAnimsForThisCharacter.append( GetItemFlavorByGUID( ConvertItemFlavorGUIDStringToGUID( "SAID00002234092" ) ) )
		return actualGoodAnimsForThisCharacter
		
			case "character_octane":
		actualGoodAnimsForThisCharacter.append( GetItemFlavorByGUID( ConvertItemFlavorGUIDStringToGUID( "SAID01698467954" ) ) )
		return actualGoodAnimsForThisCharacter
		
			case "character_wraith":
		actualGoodAnimsForThisCharacter.append( GetItemFlavorByGUID( ConvertItemFlavorGUIDStringToGUID( "SAID01474484292" ) ) )
		actualGoodAnimsForThisCharacter.append( GetItemFlavorByGUID( ConvertItemFlavorGUIDStringToGUID( "SAID01587991597" ) ) )
		actualGoodAnimsForThisCharacter.append( GetItemFlavorByGUID( ConvertItemFlavorGUIDStringToGUID( "SAID02046254916" ) ) )
		actualGoodAnimsForThisCharacter.append( GetItemFlavorByGUID( ConvertItemFlavorGUIDStringToGUID( "SAID01527711638" ) ) )
		return actualGoodAnimsForThisCharacter

			case "character_wattson":
		actualGoodAnimsForThisCharacter.append( GetItemFlavorByGUID( ConvertItemFlavorGUIDStringToGUID( "SAID01638491567" ) ) )
		return actualGoodAnimsForThisCharacter
		
			case "character_crypto":
		actualGoodAnimsForThisCharacter.append( GetItemFlavorByGUID( ConvertItemFlavorGUIDStringToGUID( "SAID00269538572" ) ) )
		actualGoodAnimsForThisCharacter.append( GetItemFlavorByGUID( ConvertItemFlavorGUIDStringToGUID( "SAID00814728196" ) ) )
		actualGoodAnimsForThisCharacter.append( GetItemFlavorByGUID( ConvertItemFlavorGUIDStringToGUID( "SAID01574566414" ) ) )
		return actualGoodAnimsForThisCharacter
	}
	return actualGoodAnimsForThisCharacter
}

//Orginal code from cl_gamemode_survival.nut
//Modifed slightly
void function Show_FSDM_VictorySequence(int skinindex)
{
	DoF_SetFarDepth( 500, 1000 )
	entity player = GetLocalClientPlayer()

	try { GetWinnerPropCameraEntities()[0].ClearParent(); GetWinnerPropCameraEntities()[0].Destroy(); GetWinnerPropCameraEntities()[1].Destroy() } catch (exceptio2n){ }

	if (GetMapName() == "mp_rr_desertlands_64k_x_64k" || GetMapName() == "mp_rr_desertlands_64k_x_64k_nx")
	{
		file.victorySequencePosition = file.selectedLocation.victorypos.origin - < 0, 0, 52>
		file.victorySequenceAngles = file.selectedLocation.victorypos.angles
	}
	else if(GetMapName() == "mp_rr_canyonlands_mu1")
	{
		file.victorySequencePosition = <-19443.75, -26319.9316, 9915.63965>	
		file.victorySequenceAngles = <0, 0, 0>
	}
	
	asset defaultModel                = GetGlobalSettingsAsset( DEFAULT_PILOT_SETTINGS, "bodyModel" )
	LoadoutEntry loadoutSlotCharacter = Loadout_CharacterClass()
	vector characterAngles            = < file.victorySequenceAngles.x / 2.0, Clamp(file.victorySequenceAngles.y-60, -180, 180), file.victorySequenceAngles.z >

	VictoryPlatformModelData victoryPlatformModelData = GetVictorySequencePlatformModel()

	entity platformModel
	entity characterModel
	int maxPlayersToShow = 3
	int maxPropsToShow = 1
	if ( victoryPlatformModelData.isSet )
	{
		platformModel = CreateClientSidePropDynamic( file.victorySequencePosition + victoryPlatformModelData.originOffset, victoryPlatformModelData.modelAngles, victoryPlatformModelData.modelAsset )
		
		cleanupEnts.append( platformModel )
		int playersOnPodium = 0

		VictorySequenceOrderPlayerFirst( player )

		foreach( int i, SquadSummaryPlayerData data in file.winnerSquadSummaryData.playerData )
		{
			if ( i >= maxPlayersToShow && GameRules_GetGameMode() != "fs_prophunt")
				break
			
			if ( file.teamwon != 3 && i >= maxPlayersToShow && GameRules_GetGameMode() == "fs_prophunt")
				break

			if ( file.teamwon == 3 && i >= maxPropsToShow && GameRules_GetGameMode() == "fs_prophunt")
				break
			
			string playerName = ""
			if ( EHIHasValidScriptStruct( data.eHandle ) )
				playerName = EHI_GetName( data.eHandle )
			
			if(file.teamwon == 3 && GameRules_GetGameMode() == "fs_prophunt")
				{
					if ( !LoadoutSlot_IsReady( data.eHandle, loadoutSlotCharacter ) )
						continue

					ItemFlavor character = LoadoutSlot_GetItemFlavor( data.eHandle, loadoutSlotCharacter )

					if ( !LoadoutSlot_IsReady( data.eHandle, Loadout_CharacterSkin( character ) ) )
						continue

					vector pos = GetVictorySquadFormationPosition( file.victorySequencePosition, file.victorySequenceAngles, i )
					entity characterNode = CreateScriptRef( pos, characterAngles )
					characterNode.SetParent( platformModel, "", true )

					characterModel = CreateClientSidePropDynamic( pos, characterAngles, prophuntAssets[data.prophuntModelIndex] )
					SetForceDrawWhileParented( characterModel, true )
					characterModel.MakeSafeForUIScriptHack()
					cleanupEnts.append( characterModel )

					foreach( func in s_callbacks_OnVictoryCharacterModelSpawned )
						func( characterModel, character, data.eHandle )

					characterModel.SetParent( characterNode, "", false )

					entity overheadNameEnt = CreateClientSidePropDynamic( pos + (AnglesToUp( file.victorySequenceAngles ) * 73), <0, 0, 0>, $"mdl/dev/empty_model.rmdl" )
					overheadNameEnt.Hide()

					var overheadRuiName = RuiCreate( $"ui/winning_squad_member_overhead_name.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 0 )
					RuiSetString(overheadRuiName, "playerName", playerName)
					RuiTrackFloat3(overheadRuiName, "position", overheadNameEnt, RUI_TRACK_ABSORIGIN_FOLLOW)

					overHeadRuis.append( overheadRuiName )

					playersOnPodium++
				}
			else
			{
				if ( !LoadoutSlot_IsReady( data.eHandle, loadoutSlotCharacter ) )
					continue

				ItemFlavor character = LoadoutSlot_GetItemFlavor( data.eHandle, loadoutSlotCharacter )

				if ( !LoadoutSlot_IsReady( data.eHandle, Loadout_CharacterSkin( character ) ) )
					continue

				
				ItemFlavor characterSkin 
				if(skinindex == 0)
					characterSkin = GetValidItemFlavorsForLoadoutSlot( data.eHandle, Loadout_CharacterSkin( character ) )[0]
				else
					characterSkin = GetValidItemFlavorsForLoadoutSlot( data.eHandle, Loadout_CharacterSkin( character ) )[GetValidItemFlavorsForLoadoutSlot( data.eHandle, Loadout_CharacterSkin( character ) ).len()-skinindex]
				
				vector pos = GetVictorySquadFormationPosition( file.victorySequencePosition, file.victorySequenceAngles, i )
				printt(pos)
				entity characterNode = CreateScriptRef( pos, characterAngles )
				characterNode.SetParent( platformModel, "", true )

				characterModel = CreateClientSidePropDynamic( pos, characterAngles, defaultModel )
				SetForceDrawWhileParented( characterModel, true )
				characterModel.MakeSafeForUIScriptHack()
				CharacterSkin_Apply( characterModel, characterSkin )

				cleanupEnts.append( characterModel )

				foreach( func in s_callbacks_OnVictoryCharacterModelSpawned )
					func( characterModel, character, data.eHandle )

				//characterModel.SetParent( characterNode, "", false )
				
				ItemFlavor anim = GetAllGoodAnimsFromGladcardStancesForCharacter_ChampionScreen(character).getrandom()
				asset animtoplay = GetGlobalSettingsAsset( ItemFlavor_GetAsset( anim ), "movingAnimSeq" )
				thread PlayAnim( characterModel, animtoplay, characterNode )
				characterModel.Anim_SetPlaybackRate(0.8)

				//characterModel.Anim_EnableUseAnimatedRefAttachmentInsteadOfRootMotion()

				entity overheadNameEnt = CreateClientSidePropDynamic( pos + (AnglesToUp( file.victorySequenceAngles ) * 73), <0, 0, 0>, $"mdl/dev/empty_model.rmdl" )
				overheadNameEnt.Hide()

				var overheadRuiName = RuiCreate( $"ui/winning_squad_member_overhead_name.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 0 )
				RuiSetString(overheadRuiName, "playerName", playerName)
				RuiTrackFloat3(overheadRuiName, "position", overheadNameEnt, RUI_TRACK_ABSORIGIN_FOLLOW)

				overHeadRuis.append( overheadRuiName )

				playersOnPodium++
			}
		}

		string dialogueApexChampion
        // if (file.teamwon == TEAM_IMC || file.teamwon == TEAM_MILITIA)
        // {
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
        // }
		
		vector AnglesToUseCamera
		
		// if(file.teamwon != 3 && GameRules_GetGameMode() == "fs_prophunt")
			// AnglesToUseCamera = characterModel.GetAngles()
		// else
			AnglesToUseCamera = file.victorySequenceAngles
		
		VictoryCameraPackage victoryCameraPackage
		victoryCameraPackage.camera_offset_start = AnglesToForward( AnglesToUseCamera ) * 300 + AnglesToUp( AnglesToUseCamera ) * 100
		victoryCameraPackage.camera_offset_end = AnglesToForward( AnglesToUseCamera ) * 300 + AnglesToRight( AnglesToUseCamera ) *200 + AnglesToUp( AnglesToUseCamera ) * 100
		//if(CoinFlip()) victoryCameraPackage.camera_offset_end = AnglesToForward( AnglesToUseCamera ) * 300 + AnglesToRight( AnglesToUseCamera ) *-200 + AnglesToUp( AnglesToUseCamera ) * 100
		victoryCameraPackage.camera_focus_offset = <0, 0, 40>
		//victoryCameraPackage.camera_fov = 20
	
		vector camera_offset_start = victoryCameraPackage.camera_offset_start
		vector camera_offset_end   = victoryCameraPackage.camera_offset_end
		vector camera_focus_offset = victoryCameraPackage.camera_focus_offset
		
		vector camera_start_pos = OffsetPointRelativeToVector( file.victorySequencePosition, camera_offset_start, AnglesToForward( AnglesToUseCamera ) )
		vector camera_end_pos   = OffsetPointRelativeToVector( file.victorySequencePosition, camera_offset_end, AnglesToForward( AnglesToUseCamera ) )
		vector camera_focus_pos = OffsetPointRelativeToVector( file.victorySequencePosition, camera_focus_offset, AnglesToForward( AnglesToUseCamera ) )
		vector camera_start_angles = VectorToAngles( camera_focus_pos - camera_start_pos )
		vector camera_end_angles   = VectorToAngles( camera_focus_pos - camera_end_pos )

        //Create camera and mover
		entity cameraMover = CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", camera_start_pos, camera_start_angles )
		entity camera      = CreateClientSidePointCamera( camera_start_pos, camera_start_angles, 35 )
		player.SetMenuCameraEntity( camera )
		camera.SetParent( cameraMover, "", false )
		cleanupEnts.append( camera )

		cleanupEnts.append( cameraMover )
		thread CameraMovement(cameraMover, camera_end_pos, camera_end_angles)
	}
}

void function CameraMovement(entity cameraMover, vector camera_end_pos, vector camera_end_angles)
{
	vector initialOrigin = cameraMover.GetOrigin()
	vector initialAngles = cameraMover.GetAngles()

	//Move camera to end pos
	cameraMover.NonPhysicsMoveTo( camera_end_pos, 10, 0.0, 6 / 2.0 )
	cameraMover.NonPhysicsRotateTo( camera_end_angles, 10, 0.0, 6 / 2.0 )	
	// wait 3
	// if(!IsValid(cameraMover)) return
	// cameraMover.NonPhysicsMoveTo( initialOrigin, 5, 0.0, 5 / 2.0 )
	// cameraMover.NonPhysicsRotateTo( initialAngles, 5, 0.0, 5 / 2.0 )	
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

void function PROPHUNT_AddWinningSquadData_PropTeamAddModelIndex( bool clear, int eHandle, int ModelIndex)
{
	if ( clear )
	{
		file.winnerSquadSummaryData.playerData.clear()
		file.winnerSquadSummaryData.squadPlacement = -1
	}
	
	SquadSummaryPlayerData data
	data.eHandle = eHandle
	data.prophuntModelIndex = ModelIndex
	file.winnerSquadSummaryData.playerData.append( data )
	file.winnerSquadSummaryData.squadPlacement = 1
}

void function VictorySequenceOrderPlayerFirst( entity player )
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

void function DM_HintCatalog(int index, int eHandle)
{
	if(!IsValid(GetLocalViewPlayer())) return

	switch(index)
	{
		case 0:
		DM_QuickHint( "Hold %use% to lock nearest enemy", true, 10)
		break
		
		case 1:
		if(file.activeQuickHint != null)
		{
			RuiDestroyIfAlive( file.activeQuickHint )
			file.activeQuickHint = null
		}
		break
	}
}

void function DM_QuickHint( string hintText, bool blueText = false, float duration = 2.5)
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
		RuiSetFloat3( file.activeQuickHint, "eventColor", SrgbToLinear( <255, 0, 119> / 255.0 ) )
}

array<void functionref( entity, ItemFlavor, int )> s_callbacks_OnVictoryCharacterModelSpawned
