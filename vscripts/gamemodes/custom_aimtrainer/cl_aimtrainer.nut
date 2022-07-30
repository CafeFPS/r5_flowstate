//Flowstate Aim Trainer my beloved
//Credits: 
//CaféDeColombiaFPS (Retículo Endoplasmático#5955 - @CafeFPS) -- dev
//Zee#6969 -- gave me weapons menu example
//Skeptation#4002 -- main advices and relevant feedback

global function  Cl_ChallengesByColombia_Init
//Main menu and results UI
global function ServerCallback_SetDefaultMenuSettings
global function ServerCallback_OpenFRChallengesMenu
global function ServerCallback_OpenFRChallengesSettings // needed? revisit this
global function ServerCallback_OpenFRChallengesMainMenu

//Stats UI
global function ServerCallback_LiveStatsUIDummiesKilled
global function ServerCallback_LiveStatsUIAccuracyViaTotalShots
global function ServerCallback_LiveStatsUIAccuracyViaShotsHits
global function ServerCallback_LiveStatsUIDamageViaWeaponAttack
global function ServerCallback_LiveStatsUIDamageViaDummieDamaged
global function ServerCallback_LiveStatsUIHeadshot
global function ServerCallback_ResetLiveStatsUI
global function ServerCallback_CoolCameraOnMenu

//Main menu buttons
global function StartChallenge1Client
global function StartChallenge2Client
global function StartChallenge3Client
global function StartChallenge4Client
global function StartChallenge5Client
global function StartChallenge6Client
global function StartChallenge1NewCClient
global function StartChallenge2NewCClient
global function StartChallenge3NewCClient
global function StartChallenge4NewCClient
global function StartChallenge5NewCClient
global function StartChallenge6NewCClient
global function SkipButtonResultsClient

//Settings
global function ChangeChallengeDurationClient
global function ChangeAimTrainer_AI_SHIELDS_LEVELClient
global function ChangeRGB_HUDClient
global function ChangeAimTrainer_INFINITE_CHALLENGEClient
global function ChangeAimTrainer_INFINITE_AMMOClient
global function ChangeAimTrainer_INMORTAL_TARGETSClient
global function ChangeAimTrainer_USER_WANNA_BE_A_DUMMYClient
global function UIToClient_MenuGiveWeapon
global function UIToClient_MenuGiveWeaponWithAttachments
global function OpenFRChallengesSettingsWpnSelector
global function CloseFRChallengesSettingsWpnSelector
global function ExitChallengeClient
global function OpenSMGOptics

struct{
	int totalShots
	int ShotsHits
	int damageDone
	int damagePossible
} ChallengesClientStruct

global struct CameraLocationPair
{
    vector origin = <0, 0, 0>
    vector angles = <0, 0, 0>
}

void function Cl_ChallengesByColombia_Init()
{
	SetConVarBool( "cl_showpos", false )
	SetConVarBool( "cl_showfps", false )
	SetConVarBool( "cl_showgpustats", false )
	
	RegisterSignal("ChallengeStartRemoveCameras")	
}

void function ServerCallback_SetDefaultMenuSettings()
{
	thread ActuallyPutDefaultSettings()
}

void function ActuallyPutDefaultSettings()
{
	entity player = GetLocalClientPlayer()
	//Hack, reusing convars for this sp gamemode. Default settings for the menu declared here.
	SetConVarInt( "hud_setting_minimapRotate", 1 )
	SetConVarInt( "hud_setting_streamerMode", 0)
	SetConVarInt( "hud_setting_showTips",  	1 )
	SetConVarInt( "hud_setting_showMeter", 0)
	SetConVarInt( "hud_setting_showMedals", 0)
	SetConVarInt( "hud_setting_showLevelUp", 2)
	WaitFrame()
	//set default settings
	player.ClientCommand("CC_AimTrainer_AI_SHIELDS_LEVEL " + GetConVarInt("hud_setting_minimapRotate").tostring())
	player.ClientCommand("CC_RGB_HUD " + GetConVarInt("hud_setting_showMeter").tostring())
	player.ClientCommand("CC_AimTrainer_INFINITE_CHALLENGE " + GetConVarInt("hud_setting_showMedals").tostring())
	player.ClientCommand("CC_AimTrainer_INFINITE_AMMO " + GetConVarInt("hud_setting_showTips").tostring())
	player.ClientCommand("CC_AimTrainer_INMORTAL_TARGETS " + GetConVarInt("hud_setting_streamerMode").tostring())
	player.ClientCommand("CC_AimTrainer_USER_WANNA_BE_A_DUMMY " + GetConVarInt("hud_setting_showLevelUp").tostring())		
}


string function ReturnChallengeName(int index)
{
	string final
	switch(index){
		case 1:
			final = "STRAFING DUMMY"
			break		
		case 2:
			final = "TARGET SWITCHING"
			break
		case 3:
			final = "FLOATING TARGET"
			break
		case 4:
			final = "POPCORN TARGETS"
			break
		case 5:
			final = "STRAIGHT UP"
			break
		case 6:
			final = "BUBBLEFIGHT PRACTICE"
			break
		case 7:
			final = "ARCSTARS PRACTICE"
			break
		case 8:
			final = "LIFT UP PRACTICE"
			break
		case 9:
			final = "SHOOTING VALK'S ULT"
			break
		case 10:
			final = "TILE FRENZY"
			break
		case 0:
		default: 
			final = "CHALLENGE RESULTS"
	}
	return final
}

void function ServerCallback_OpenFRChallengesMenu(int challengeName, int shothits, int dummieskilled, float accuracy, int damagedone, int criticalshots, int shotshitrecord, bool isNewRecord)
{	
	string actualChallengeName = ReturnChallengeName(challengeName)
	DisableLiveStatsUI()
    RunUIScript( "UpdateResultsData", actualChallengeName, shothits, dummieskilled, accuracy, damagedone, criticalshots, shotshitrecord, isNewRecord )
	RunUIScript( "OpenFRChallengesMenu" )

    thread UpdateUIRespawnTimer()
}

void function ServerCallback_OpenFRChallengesMainMenu(int dummiesKilled)
{
	entity player = GetLocalClientPlayer()
	RunUIScript( "OpenFRChallengesMainMenu", dummiesKilled)
}

void function ServerCallback_OpenFRChallengesSettings()
{
	RunUIScript( "OpenFRChallengesSettings" )
}

void function ServerCallback_LiveStatsUIDummiesKilled(int dummieskilled)
{
	Hud_SetText( HudElement( "ChallengesDummieskilledValue"), dummieskilled.tostring())
}

void function ServerCallback_LiveStatsUIAccuracyViaTotalShots(int pellets)
{
	ChallengesClientStruct.totalShots += (1*pellets)
	float accuracy = float(ChallengesClientStruct.ShotsHits)/float(ChallengesClientStruct.totalShots)
	
	string final = ChallengesClientStruct.ShotsHits.tostring() + "/" +  ChallengesClientStruct.totalShots.tostring() + " | " + ClientLocalizeAndShortenNumber_Float(accuracy, 1, 2)
	Hud_SetText( HudElement( "ChallengesAccuracyValue"), final.tostring())
}
void function ServerCallback_LiveStatsUIAccuracyViaShotsHits()
{
	ChallengesClientStruct.ShotsHits++
	float accuracy = float(ChallengesClientStruct.ShotsHits)/float(ChallengesClientStruct.totalShots)
	
	string final = ChallengesClientStruct.ShotsHits.tostring() + "/" +  ChallengesClientStruct.totalShots.tostring() + " | " + ClientLocalizeAndShortenNumber_Float(accuracy, 1, 2)
	Hud_SetText( HudElement( "ChallengesAccuracyValue"), final.tostring())
}

void function ServerCallback_LiveStatsUIDamageViaWeaponAttack(int damage, float damagePossible)
{
	ChallengesClientStruct.damagePossible += int(damagePossible)
	float damageRatio = float(ChallengesClientStruct.damageDone)/float(ChallengesClientStruct.damagePossible)
	
	string final = ChallengesClientStruct.damageDone.tostring() + "/" +  ChallengesClientStruct.damagePossible.tostring() + " | " + ClientLocalizeAndShortenNumber_Float(damageRatio, 1, 2)
	Hud_SetText( HudElement( "ChallengesDamageValue"), final.tostring())
}

void function ServerCallback_LiveStatsUIDamageViaDummieDamaged(int damage)
{
	ChallengesClientStruct.damageDone += damage
	float damageRatio = float(ChallengesClientStruct.damageDone)/float(ChallengesClientStruct.damagePossible)
	
	string final = ChallengesClientStruct.damageDone.tostring() + "/" +  ChallengesClientStruct.damagePossible.tostring() + " | " + ClientLocalizeAndShortenNumber_Float(damageRatio, 1, 2)
	Hud_SetText( HudElement( "ChallengesDamageValue"), final.tostring())
}

void function ServerCallback_LiveStatsUIHeadshot(int headshots)
{
	Hud_SetText( HudElement( "ChallengesHeadshotsValue"), headshots.tostring())
}

void function ServerCallback_CoolCameraOnMenu()
{
    thread CoolCameraOnMenu()
}

CameraLocationPair function NewCameraPair(vector origin, vector angles)
{
    CameraLocationPair locPair
    locPair.origin = origin
    locPair.angles = angles

    return locPair
}

void function CoolCameraOnMenu()
//took from tdm
{
    entity player = GetLocalClientPlayer()
	player.EndSignal("ChallengeStartRemoveCameras")
	array<CameraLocationPair> cutsceneSpawns
	
    if(!IsValid(player)) return
	
	if (GetMapName() == "mp_rr_desertlands_64k_x_64k" || GetMapName() == "mp_rr_desertlands_64k_x_64k_nx")
	{
		cutsceneSpawns.append(NewCameraPair(<10881.2295, 5903.09863, -3176.7959>, <0, -143.321213, 0>)) 
		cutsceneSpawns.append(NewCameraPair(<9586.79199, 24404.5898, -2019.6366>, <0, -52.6216431, 0>)) 
		cutsceneSpawns.append(NewCameraPair(<-22333.625, -15142.3359, 634.326172>, <0, -46.2498436, 0>))
		cutsceneSpawns.append(NewCameraPair(<21524.0859, -11396.7852, -2646.92944>, <0, 116.187294, 0>))
	}
	else if(GetMapName() == "mp_rr_canyonlands_staging")
	{
		cutsceneSpawns.append(NewCameraPair(<32645.04,-9575.77,-25911.94>, <7.71,91.67,0.00>)) 
		cutsceneSpawns.append(NewCameraPair(<49180.1055, -6836.14502, -23461.8379>, <0, -55.7723808, 0>)) 
		cutsceneSpawns.append(NewCameraPair(<43552.3203, -1023.86182, -25270.9766>, <0, 20.9528542, 0>))
		cutsceneSpawns.append(NewCameraPair(<30038.0254, -1036.81982, -23369.6035>, <55, -24.2035522, 0>))
	}
	else if(GetMapName() == "mp_rr_canyonlands_mu1" || GetMapName() == "mp_rr_canyonlands_mu1_night" || GetMapName() == "mp_rr_canyonlands_64k_x_64k")
	{
		cutsceneSpawns.append(NewCameraPair(<22771.2344, -16147.1143, 12773.626>, <0, 160.513199, 0>)) 
		cutsceneSpawns.append(NewCameraPair(<-7984.68408, -16770.2031, 3972.28271>, <0, -158.605301, 0>)) 
		cutsceneSpawns.append(NewCameraPair(<-19691.1621, 5229.45264, 4238.53125>, <0, -54.6054993, 0>))
		cutsceneSpawns.append(NewCameraPair(<13270.0576, -20413.9023, 2999.29468>, <0, 98.6180649, 0>))
	}

    //EmitSoundOnEntity( player, "music_skyway_04_smartpistolrun" )

    float playerFOV = player.GetFOV()
	
	cutsceneSpawns.randomize()
	int locationindex = 0
	vector randomcameraPos = cutsceneSpawns[0].origin
	vector randomcameraAng = cutsceneSpawns[0].angles
    entity camera = CreateClientSidePointCamera(randomcameraPos, randomcameraAng, 17)
    camera.SetFOV(100)
    entity cutsceneMover = CreateClientsideScriptMover($"mdl/dev/empty_model.rmdl", randomcameraPos, randomcameraAng)
    camera.SetParent(cutsceneMover)
	GetLocalClientPlayer().SetMenuCameraEntity( camera )
	DoF_SetFarDepth( 6000, 10000 )	
	
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
		}
	)
	
	while(true){
		if(locationindex == cutsceneSpawns.len()){

			locationindex = 0
		}	
	    randomcameraPos = cutsceneSpawns[locationindex].origin
		randomcameraAng = cutsceneSpawns[locationindex].angles
		locationindex++
		cutsceneMover.SetOrigin(randomcameraPos)
		cutsceneMover.SetAngles(randomcameraAng)
		camera.SetOrigin(randomcameraPos)
		camera.SetAngles(randomcameraAng)
		cutsceneMover.NonPhysicsMoveTo(randomcameraPos + AnglesToRight(randomcameraAng) * 700, 15, 0, 0)
		//cutsceneMover.NonPhysicsRotateTo( )
		wait 15 
	}
}
void function DisableLiveStatsUI()
{
	Hud_SetVisible(HudElement( "Countdown" ), false)
	Hud_SetVisible(HudElement( "CountdownFrame" ), false)
	
	Hud_SetVisible(HudElement( "ChallengesStatsFrame" ), false)
	Hud_SetVisible(HudElement( "TitleStats" ), false)
	Hud_SetVisible(HudElement( "ScreenBlur" ), false)
	Hud_SetVisible(HudElement( "ChallengesDummieskilled" ), false)
	Hud_SetVisible(HudElement( "ChallengesDummieskilledValue" ), false)
	Hud_SetVisible(HudElement( "ChallengesAccuracy" ), false)
	Hud_SetVisible(HudElement( "ChallengesAccuracyValue" ), false)
	Hud_SetVisible(HudElement( "ChallengesDamage" ), false)
	Hud_SetVisible(HudElement( "ChallengesDamageValue" ), false)
	Hud_SetVisible(HudElement( "ChallengesHeadshots" ), false)
	Hud_SetVisible(HudElement( "ChallengesHeadshotsValue" ), false)	
}

void function ServerCallback_ResetLiveStatsUI()
{
	Hud_SetText( HudElement( "ChallengesDummieskilledValue"), "0")
	Hud_SetText( HudElement( "ChallengesAccuracyValue"), "0/0 | 0")
	Hud_SetText( HudElement( "ChallengesDamageValue"), "0/0 | 0")
	Hud_SetText( HudElement( "ChallengesHeadshotsValue"), "0")
	ChallengesClientStruct.totalShots = 0
	ChallengesClientStruct.ShotsHits = 0
	ChallengesClientStruct.damageDone = 0
	ChallengesClientStruct.damagePossible = 0
}

void function UpdateUIRespawnTimer()
{
	entity player = GetLocalClientPlayer() 
	int time = AimTrainer_RESULTS_TIME
	EndSignal(player, "ForceResultsEnd_SkipButton")
	
    while(time > -1)
    {
        RunUIScript( "UpdateFRChallengeResultsTimer", time)
        time--
        wait 1
    }
}

void function CreateDescriptionRUI(string description)
{
	entity player = GetLocalClientPlayer()
	player.Signal("ChallengeStartRemoveCameras")
	wait 0.5	
	UISize screenSize = GetScreenSize()
    var topo = RuiTopology_CreatePlane( <( screenSize.width * 0),( screenSize.height * -0.1 ), 0>, <float( screenSize.width ), 0, 0>, <0, float( screenSize.height ), 0>, false )
	var rui = RuiCreate( $"ui/id_dev_text.rpak", topo, RUI_DRAW_HUD, 0 )
	
	RuiSetFloat( rui, "startTime", Time() )
	RuiSetString( rui, "speaker","")
	RuiSetString( rui, "text", description )
	RuiSetFloat( rui, "duration", AimTrainer_PRE_START_TIME-0.5 )
	RuiSetResolutionToScreenSize( rui )	
}

void function CreateTimerRUI(bool crosshair = false) //and stats
{
	entity player = GetLocalClientPlayer()
	int time = AimTrainer_CHALLENGE_DURATION
	EndSignal(player, "ForceResultsEnd_SkipButton")
	EndSignal(player, "ChallengeTimeOver")

	wait AimTrainer_PRE_START_TIME
	
	var rui2
	if(crosshair)
		rui2 = RuiCreate( $"ui/crosshair_dot.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 0 )

	OnThreadEnd(
		function() : (crosshair, rui2)
		{
		if(crosshair)	
			RuiDestroyIfAlive( rui2 )
		DisableLiveStatsUI()
		}
	)

	Hud_SetVisible(HudElement( "ChallengesStatsFrame" ), true)
	Hud_SetVisible(HudElement( "TitleStats" ), true)
	Hud_SetVisible(HudElement( "ScreenBlur" ), true)
	Hud_SetVisible(HudElement( "ChallengesDummieskilled" ), true)
	Hud_SetVisible(HudElement( "ChallengesDummieskilledValue" ), true)
	Hud_SetVisible(HudElement( "ChallengesAccuracy" ), true)
	Hud_SetVisible(HudElement( "ChallengesAccuracyValue" ), true)
	Hud_SetVisible(HudElement( "ChallengesDamage" ), true)
	Hud_SetVisible(HudElement( "ChallengesDamageValue" ), true)
	Hud_SetVisible(HudElement( "ChallengesHeadshots" ), true)
	Hud_SetVisible(HudElement( "ChallengesHeadshotsValue" ), true)
	
	if(!AimTrainer_INFINITE_CHALLENGE){
	Hud_SetVisible(HudElement( "Countdown" ), true)
	Hud_SetVisible(HudElement( "CountdownFrame" ), true)
	Hud_SetText( HudElement( "Countdown" ), AimTrainer_CHALLENGE_DURATION.tostring())}
	
	while(time > -1)
    {
		if(!AimTrainer_INFINITE_CHALLENGE)
			Hud_SetText( HudElement( "Countdown" ), time.tostring())
        time--
		wait 1
    }
}
void function RefreshHUD()
{
	WaitFrame()
	//refresh
	entity player = GetLocalViewPlayer()
	entity weapon = player.GetSelectedWeapon( eActiveInventorySlot.mainHand )
	if ( !IsValid( weapon ) )
		weapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
	UpdateHudDataForMainWeapons( player, weapon )
	
	//refresh
	InitSurvivalHealthBar()
}

void function StartChallenge1Client()
{
	entity player = GetLocalClientPlayer()
	ScreenFade( player, 0, 0, 0, 255, 1, 1, FFADE_IN | FFADE_PURGE )
	thread CreateDescriptionRUI("Hit the strafing dummy to get points.")
	thread CreateTimerRUI()	
	player.ClientCommand("CC_StartChallenge1")
}

void function StartChallenge2Client()
{
	entity player = GetLocalClientPlayer()
	ScreenFade( player, 0, 0, 0, 255, 1, 1, FFADE_IN | FFADE_PURGE )
	thread CreateDescriptionRUI("Low health dummies. Hit the dummies to get points.")
	thread CreateTimerRUI()
	player.ClientCommand("CC_StartChallenge2")
}

void function StartChallenge3Client()
{
	entity player = GetLocalClientPlayer()
	ScreenFade( player, 0, 0, 0, 255, 1, 1, FFADE_IN | FFADE_PURGE )
	thread CreateDescriptionRUI("Don't let dummy touch ground to get streak points.")
	thread CreateTimerRUI()
	player.ClientCommand("CC_StartChallenge3")
}

void function StartChallenge4Client()
{
	entity player = GetLocalClientPlayer()
	ScreenFade( player, 0, 0, 0, 255, 1, 1, FFADE_IN | FFADE_PURGE )
	thread CreateDescriptionRUI("Tracking practice. Hit the dummies to get points.")
	thread CreateTimerRUI()
	player.ClientCommand("CC_StartChallenge4")
}

void function StartChallenge5Client()
{
	entity player = GetLocalClientPlayer()
	ScreenFade( player, 0, 0, 0, 255, 1, 1, FFADE_IN | FFADE_PURGE )
	thread CreateDescriptionRUI("Click weapon is recommended. Hit as many targets as possible.")
	thread CreateTimerRUI(true)
	player.ClientCommand("CC_StartChallenge5")
}
void function StartChallenge6Client()
{
	entity player = GetLocalClientPlayer()
	ScreenFade( player, 0, 0, 0, 255, 1, 1, FFADE_IN | FFADE_PURGE )
	thread CreateDescriptionRUI("TODO")
	thread CreateTimerRUI()
	player.ClientCommand("CC_StartChallenge6")
}
void function StartChallenge1NewCClient()
{
	entity player = GetLocalClientPlayer()
	ScreenFade( player, 0, 0, 0, 255, 1, 1, FFADE_IN | FFADE_PURGE )
	thread CreateDescriptionRUI("Avoid death by killing dummy.")
	thread CreateTimerRUI()
	player.ClientCommand("CC_StartChallenge1NewC")
}

void function StartChallenge2NewCClient()
{
	entity player = GetLocalClientPlayer()
	ScreenFade( player, 0, 0, 0, 255, 1, 1, FFADE_IN | FFADE_PURGE )
	thread CreateDescriptionRUI("Only sticks count, shields are disabled.")
	thread CreateTimerRUI()
	player.ClientCommand("CC_StartChallenge2NewC")
}

void function StartChallenge3NewCClient()
{
	// entity player = GetLocalClientPlayer()
	// ScreenFade( player, 0, 0, 0, 255, 1, 1, FFADE_IN | FFADE_PURGE )
	// player.ClientCommand("CC_StartChallenge3NewC")
}

void function StartChallenge4NewCClient()
{
	entity player = GetLocalClientPlayer()
	ScreenFade( player, 0, 0, 0, 255, 1, 1, FFADE_IN | FFADE_PURGE )
	thread CreateDescriptionRUI("Tracking practice. Valk ultimate/Balloons simulation.")
	thread CreateTimerRUI()
	player.ClientCommand("CC_StartChallenge4NewC")
}

void function StartChallenge5NewCClient()
{
	entity player = GetLocalClientPlayer()
	ScreenFade( player, 0, 0, 0, 255, 1, 1, FFADE_IN | FFADE_PURGE )
	thread CreateDescriptionRUI("Tracking practice. Horizon's lift simulation.")
	thread CreateTimerRUI()
	player.ClientCommand("CC_StartChallenge5NewC")
}
	
void function StartChallenge6NewCClient()
{
	entity player = GetLocalClientPlayer()
	ScreenFade( player, 0, 0, 0, 255, 1, 1, FFADE_IN | FFADE_PURGE )
	thread CreateDescriptionRUI("TODO")
	thread CreateTimerRUI()
	player.ClientCommand("CC_StartChallenge6NewC")
}

void function SkipButtonResultsClient()
{
	entity player = GetLocalClientPlayer()
	Signal(player, "ForceResultsEnd_SkipButton")
	player.ClientCommand("ChallengesSkipButton")
}

//settings
void function ChangeChallengeDurationClient(string time)
{
	if (time == "" || time == "0") return
	entity player = GetLocalClientPlayer()
	AimTrainer_CHALLENGE_DURATION = int(time)
	player.ClientCommand("CC_ChangeChallengeDuration " + time)
}
void function ChangeAimTrainer_AI_SHIELDS_LEVELClient(string desiredShieldLevel)
{
	entity player = GetLocalClientPlayer()
	AimTrainer_AI_SHIELDS_LEVEL = int(desiredShieldLevel)
	player.ClientCommand("CC_AimTrainer_AI_SHIELDS_LEVEL " + desiredShieldLevel)
}

void function ChangeRGB_HUDClient(string isabool)
{
	entity player = GetLocalClientPlayer()
	if(isabool == "0")
		RGB_HUD = false
	else if(isabool == "1")
		RGB_HUD = true
	
	thread RefreshHUD()
	player.ClientCommand("CC_RGB_HUD " + isabool)
}
void function ChangeAimTrainer_INFINITE_CHALLENGEClient(string isabool)
{
	entity player = GetLocalClientPlayer()
	if(isabool == "0")
		AimTrainer_INFINITE_CHALLENGE = false
	else if(isabool == "1")
		AimTrainer_INFINITE_CHALLENGE = true
	
	player.ClientCommand("CC_AimTrainer_INFINITE_CHALLENGE " + isabool)
}
void function ChangeAimTrainer_INFINITE_AMMOClient(string isabool)
{
	entity player = GetLocalClientPlayer()
	if(isabool == "0")
		AimTrainer_INFINITE_AMMO = false
	else if(isabool == "1")
		AimTrainer_INFINITE_AMMO = true
	
	player.ClientCommand("CC_AimTrainer_INFINITE_AMMO " + isabool)
}
void function ChangeAimTrainer_INMORTAL_TARGETSClient(string isabool)
{
	entity player = GetLocalClientPlayer()
	if(isabool == "0")
		AimTrainer_INMORTAL_TARGETS = false
	else if(isabool == "1")
		AimTrainer_INMORTAL_TARGETS = true
	
	player.ClientCommand("CC_AimTrainer_INMORTAL_TARGETS " + isabool)
}
void function ChangeAimTrainer_USER_WANNA_BE_A_DUMMYClient(string isabool)
{
	entity player = GetLocalClientPlayer()
	if(isabool == "2")
		AimTrainer_USER_WANNA_BE_A_DUMMY = false
	else if(isabool == "3")
		AimTrainer_USER_WANNA_BE_A_DUMMY = true
	
	player.ClientCommand("CC_AimTrainer_USER_WANNA_BE_A_DUMMY " + isabool)
}

void function UIToClient_MenuGiveWeapon( string weapon)
{
	entity player = GetLocalClientPlayer()
    player.ClientCommand("CC_MenuGiveAimTrainerWeapon " + weapon)
}

void function UIToClient_MenuGiveWeaponWithAttachments( string weapon, int desiredoptic, int desiredbarrel, int desiredstock, int desiredshotgunbolt, string weapontype)
{
	entity player = GetLocalClientPlayer()
	string optic
	string barrel
	string stock
	string shotgunbolt
	
	printt("DEBUG: desiredOptic: " + desiredoptic, " desiredBarrel: " + desiredbarrel, " desiredStock: " + desiredstock)

	switch(desiredoptic){
		case 0:
			optic = "optic_cq_hcog_classic"
			break
		case 1:
			optic = "optic_cq_holosight"
			break
		case 2:
			optic = "optic_cq_threat"
			break
		case 3:
			optic = "optic_cq_holosight_variable"
			break
		case 4:	
			optic = "optic_cq_hcog_bruiser"
			break
	}
	
	switch(desiredbarrel){
		case 0:
			barrel = "barrel_stabilizer_l1"
			break
		case 1:
			barrel = "barrel_stabilizer_l2"
			break
		case 2:
			barrel = "barrel_stabilizer_l3"
			break
	}

	switch(desiredstock){
			case 0:
				stock = "stock_tactical_l1"
				break
			case 1:
				stock = "stock_tactical_l2"
				break
			case 2:
				stock = "stock_tactical_l3"
				break
		}
	
	if( weapontype == "sniper" || weapontype == "sniper2" || weapontype == "marksman" || weapontype == "marksman2")
		switch(desiredstock){
			case 0:
				stock = "stock_sniper_l1"
				break
			case 1:
				stock = "stock_sniper_l2"
				break
			case 2:
				stock = "stock_sniper_l3"
				break
		}		
	
	switch(desiredshotgunbolt){
			case 0:
				shotgunbolt = "shotgun_bolt_l1"
				break
			case 1:
				shotgunbolt = "shotgun_bolt_l2"
				break
			case 2:
				shotgunbolt = "shotgun_bolt_l3"
				break
		}
		
	if(weapon == "mp_weapon_energy_ar" || weapon == "mp_weapon_esaw")
	{
		switch(desiredshotgunbolt){
			case 0:
				shotgunbolt = "."
				break
			case 1:
				shotgunbolt = "hopup_turbocharger"
				break
		}
	}else if(weapon == "mp_weapon_g2")
	{
		switch(desiredshotgunbolt){
			case 0:
				shotgunbolt = "."
				break
			case 1:
				shotgunbolt = "hopup_double_tap"
				break
		}	
	}else if(weapon == "mp_weapon_doubletake")
	{
		switch(desiredshotgunbolt){
			case 0:
				shotgunbolt = "."
				break
			case 1:
				shotgunbolt = "hopup_energy_choke"
				break
		}			
	}
	
	if(weapontype == "ar" || weapontype == "ar2" || weapontype == "lmg" || weapontype == "lmg2" || weapontype == "sniper" || weapontype == "sniper2" || weapontype == "marksman" || weapontype == "marksman2")
	switch(desiredoptic){
		case 0:
			optic = "optic_cq_hcog_classic"
			break
		case 1:
			optic = "optic_cq_holosight"
			break
		case 2:
			optic = "optic_cq_holosight_variable"
			break
		case 3:
			optic = "optic_cq_hcog_bruiser"
			break
		case 4:	
			optic = "optic_ranged_hcog"
			break
		case 5:	
			optic = "optic_ranged_aog_variable"
			break
		case 6:	
			optic = "optic_sniper"
			break
		case 7:	
			optic = "optic_sniper_variable"
			break
		case 8:	
			optic = "optic_sniper_threat"
			break
	}
	
	
    player.ClientCommand("CC_MenuGiveAimTrainerWeapon " + weapon + " " + optic + " " + barrel + " " + stock + " " + shotgunbolt + " " + weapontype)
}

void function OpenFRChallengesSettingsWpnSelector()
{
	entity player = GetLocalClientPlayer()
    player.ClientCommand("CC_Weapon_Selector_Open")
	player.Signal("ChallengeStartRemoveCameras")
	DoF_SetFarDepth( 1, 300 )
	RunUIScript("OpenFRChallengesSettingsWpnSelector")
}

void function CloseFRChallengesSettingsWpnSelector()
{
	entity player = GetLocalClientPlayer()
	thread CoolCameraOnMenu()
	DoF_SetFarDepth( 6000, 10000 )
    player.ClientCommand("CC_Weapon_Selector_Close")
}

void function ExitChallengeClient()
{
	entity player = GetLocalClientPlayer()
    player.ClientCommand("CC_ExitChallenge")
}

void function OpenSMGOptics()
{
	entity player = GetLocalClientPlayer()
    //player.ClientCommand("CC_Weapon_Selector_Open")
	//player.Signal("ChallengeStartRemoveCameras")
	//DoF_SetFarDepth( 1, 300 )
	RunUIScript("OpenSMGOptics")
}

string function ClientLocalizeAndShortenNumber_Float( float number, int maxDisplayIntegral = 3, int maxDisplayDecimal = 0 )
{
	if ( number == 0.0 )
		return "0"

	string thousandsSeparator = ","
	string decimalSeparator = "."
	string integralString = ""
	string integralSuffix = ""

	float integral = floor( number )
	int digits = int( floor( log10( integral ) + 1 ) )

	if ( digits > maxDisplayIntegral )
	{
	
		float displayIntegral = integral / pow( 10, (digits - 3) )
		displayIntegral = floor( displayIntegral )
		integralString = format( "%0.0f", displayIntegral )

		if ( digits/16 >= 1 )
			integralSuffix = Localize( "#STATS_VALUE_QUADRILLIONS" )
		else if ( digits/13 >= 1 )
			integralSuffix = Localize( "#STATS_VALUE_TRILLIONS" )
		else if ( digits/10 >= 1 )
			integralSuffix = Localize( "#STATS_VALUE_BILLIONS" )
		else if ( digits/7 >= 1 )
			integralSuffix = Localize( "#STATS_VALUE_MILLIONS" )
		else if ( digits/4 >= 1 )
			integralSuffix = Localize( "#STATS_VALUE_THOUSANDS" )
	}
	else
	{
		integralString = format( "%0.0f", integral )
	}

	if ( integralString.len() > 3 )
	{
		string separatedIntegralString = ""
		int integralsAdded = 0

	
		for ( int i = integralString.len(); i > 0; i-- )
		{
			string num = integralString.slice( i-1, i )
			if ( (separatedIntegralString.len() - integralsAdded) % 3 == 0 && separatedIntegralString.len() > 0 )
			{
				integralsAdded++
				separatedIntegralString = num + thousandsSeparator + separatedIntegralString
			}
			else
			{
				separatedIntegralString = num + separatedIntegralString
			}

		}

		integralString = separatedIntegralString
	}

	if ( integralString.len() <= 3 && integralString != "0" && digits > 3 )
	{
		int separatorPos
		if ( maxDisplayIntegral == 3 )
			separatorPos = (digits - maxDisplayIntegral) % 3
		else
			separatorPos = ((digits - maxDisplayIntegral) % 3) + 1

		if( separatorPos != 0 && separatorPos != 3 )
			integralString = integralString.slice( 0, separatorPos ) + decimalSeparator + integralString.slice( separatorPos, integralString.len() ) + integralSuffix
		else
			integralString += integralSuffix
	}

	float decimal = 0.0
	string decimalString = ""

	decimal = number % 1
	decimalString = string( decimal )

	if ( decimalString.find( "0." ) != -1 )
		decimalString = decimalString.slice( 2 )

	if ( decimalString.len() > maxDisplayDecimal )
		decimalString = decimalString.slice( 0, maxDisplayDecimal )

	string finalDisplayNumber = integralString

	if ( maxDisplayDecimal > 0 && decimal != 0.0 )
	{
		finalDisplayNumber += decimalSeparator + decimalString
	}

	return finalDisplayNumber
}