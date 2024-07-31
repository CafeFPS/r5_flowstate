// Search and Destroy
// Made by @CafeFPS - Server, Client and UI

// Aeon#0236 - Playtests and ideas
// AyeZee#6969 - Some of the economy system logic from his arenas mode draft - stamina
// @DEAFPS - Shoothouse, de_cache and NCanals maps
// @CafeFPS and Darkes#8647 - de_dust2 map model port and fake collision
// VishnuRajan in https://sketchfab.com/3d-models/time-bomb-efb2e079c31349c1b2bd072f00d8fe79 - Bomb model and textures

untyped

global function Cl_GamemodeSND_Init

global function ServerCallback_ForceDestroyPlantingRUI
global function ServerCallback_FlowstateSND_CustomBuyMenu_UpdateValues
global function ServerCallback_BuySuccessful
global function ServerCallback_BuyRejected
global function ServerCallback_SellSuccessful
global function ServerCallback_OnMoneyAdded
global function ServerCallback_ResetMoney
global function Thread_SNDTimer
global function Thread_SNDTimer_Fromfile
global function Thread_SNDBuyMenuTimer
global function SND_ClientAskedForTeam

//Custom Winner Screen
global function FlowstateSND_CustomWinnerScreen_Start

//Custom Buy Menu
global function FlowstateSND_CustomBuyMenu_Start
global function FlowstateSND_CustomBuyMenu_Stop
global function SetSNDKnifeColor
global function SND_ForceUpdatePlayerCount

#if DEVELOPER
global function TestCustomModelAngles
#endif

enum BuyMenuMenus
{
	MAIN,
	PISTOLS,
	SHOTGUNS,
	SMGS,
	ARS,
	LMGS,
	//MARKSMAN,
	SNIPER,
	GEAR,
	ABILITIES
}

table< int, string > MainMenu_Names =
{
	[ BuyMenuMenus.MAIN ] = "",
	[ BuyMenuMenus.PISTOLS ] = "PISTOLS",
	[ BuyMenuMenus.SHOTGUNS ] = "SHOTGUNS",
	[ BuyMenuMenus.SMGS ] = "SMGS",
	[ BuyMenuMenus.ARS ] = "ARS",
	[ BuyMenuMenus.LMGS ] = "LMGS",
	//[ BuyMenuMenus.MARKSMAN ] = "MARKSMAN",
	[ BuyMenuMenus.SNIPER ] = "SNIPER",
	[ BuyMenuMenus.GEAR ] = "GEAR",
	[ BuyMenuMenus.ABILITIES ] = "ABILITIES"
}

struct {
	table< string, var > equipmentButtons = {}
	
	//Cursor handling in client vm
	int currentx
	int currenty
	
	//Epic Wheel system
	var WheelRUI	
	bool isShowingBuyMenu
	int activeMenu = BuyMenuMenus.MAIN
	float focusedSlot
	float lastFocusTime
	float slotCount = 8
	
	//menu model system
	entity menumodelCharacter
	entity menumodelWeaponPrimary
	entity menumodelWeaponSecondary
	entity menumodelGear
	entity light
	int selectedWeaponID
	bool executeNewAnim = true
	
	vector cameraStart
	vector cameraAnglesStart
	entity camera
	
	//Saveed info on client
	int availableMoney = 0
	int weapon1ID = -1
	int weapon2ID = -1
	int weapon1lvl = -1
	int weapon2lvl = -1
	int currentRound
	var PrimaryWeaponName
	var SecondaryWeaponName
	float endtime
} file

void function Cl_GamemodeSND_Init()
{
	SetConVarInt("cl_quota_stringCmdsPerSecond", 200)
	//I don't want these things in user screen even if they launch in debug
	SetConVarBool( "cl_showpos", false )
	SetConVarBool( "cl_showfps", false )
	SetConVarBool( "cl_showgpustats", false )
	SetConVarBool( "cl_showsimstats", false )
	SetConVarBool( "host_speeds", false )
	SetConVarBool( "con_drawnotify", false )
	SetConVarBool( "enable_debug_overlays", false )
	//SetConVarFloat( "fps_max", 190 ) 
	
	SetConVarInt( "cl_footstep_event_max_dist", 600 )
	SetConVarBool( "miles_occlusion", false )
	SetConVarFloat( "mat_autoexposure_force_value", 0.8 )
	
	RegisterSignal("NewKillChangeRui")
	RegisterSignal("StartNewWinnerScreen")
	RegisterSignal("NewMoneySpentRui")
	RegisterSignal("ChangeMenuModelAnim")
	RegisterSignal("SND_EndTimer")
	RegisterSignal("ChallengeStartRemoveCameras")
	RegisterSignal("ChangeCameraToSelectedLocation")
	
	AddCallback_EntitiesDidLoad( Cl_EntitiesDidLoad )
	AddClientCallback_OnResolutionChanged( Cl_OnResolutionChanged )
}

void function ServerCallback_ForceDestroyPlantingRUI()
{
	entity player = GetLocalClientPlayer()
	Signal(player, "OnChargeEnd")
}

void function FlowstateSND_CustomWinnerScreen_Start(int winnerTeam, int reason)
{
	thread function() : (winnerTeam, reason)
	{
		entity player = GetLocalClientPlayer()
		
		// if( player != GetLocalViewPlayer() ) return
		
		Signal(player, "StartNewWinnerScreen")
		Signal(player, "NewKillChangeRui")
		Signal(player, "OnChargeEnd")
		Signal(player, "SND_EndTimer")
		
		DoF_SetFarDepth( 50, 1000 )

		EndSignal(player, "StartNewWinnerScreen")

		OnThreadEnd(
			function() : ( )
			{
				DoF_SetNearDepthToDefault()
				DoF_SetFarDepthToDefault()
			}
		)

		EmitSoundOnEntity(player, "UI_InGame_Top5_Streak_1X")
		
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
		
		string roundText = localPlayerIsWinner ? "ROUND WIN" : "ROUND LOSS"
		string winnerTeamText = winnerTeam == TEAM_IMC ? "IMC" : "MILITIA"
		string loserTeamText = winnerTeamText == "IMC" ? "MILITIA" : "IMC"

		string reasonText
		string teamText
		
		string attackers = Sh_GetAttackerTeam() == TEAM_IMC ? "IMC" : "MILITIA"
		string defenders = Sh_GetDefenderTeam() == TEAM_IMC ? "IMC" : "MILITIA"

		switch(reason)
		{
			case 0:
				if( localPlayerIsWinner )
					reasonText = "ALL ENEMY PLAYERS WERE ELIMINATED"// "ALL " + loserTeamText + " PLAYERS WERE ELIMINATED"
				else
					reasonText = "YOUR TEAM WAS ELIMINATED"// BY " + winnerTeamText
			break
			
			case 1:
				if( localPlayerIsWinner )
					reasonText = "YOUR BOMB EXPLODED"
				else
					reasonText = "ENEMY BOMB EXPLODED"//winnerTeamText + " TEAM BOMB EXPLODED"
			break
			
			case 2:
				if( localPlayerIsWinner )
					reasonText = "YOUR TEAM DEFUSED ENEMY BOMB"
				else
					reasonText = "ENEMY TEAM DEFUSED YOUR BOMB"//winnerTeamText + " TEAM DEFUSED THE BOMB"
			break
			
			case 3:
				if( localPlayerIsWinner )
					reasonText = "YOU MANAGED TO DEFEND"//, DEFENDERS WIN"
				else
					reasonText = "YOU FAILED TO PLANT THE BOMB"//, ATTACKERS LOSS"
			break
		}
		
		Hud_SetText( RoundWinOrLoseText, roundText )
		Hud_SetText( WinOrLoseReason, reasonText )
		
		wait 1.2
		
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

		Hud_ScaleOverTime( LTMLogo, 1.2, 1.2, 0.4, INTERPOLATOR_ACCEL )
		
		wait 0.4
		
		Hud_ScaleOverTime( LTMLogo, 1, 1, 0.15, INTERPOLATOR_LINEAR )
		
		wait 0.35
		
		Hud_ScaleOverTime( RoundWinOrLoseText, 1, 1, 0.35, INTERPOLATOR_SIMPLESPLINE )
		Hud_ScaleOverTime( LTMBoxMsg, 1, 1, 0.3, INTERPOLATOR_SIMPLESPLINE )
		Hud_ScaleOverTime( WinOrLoseReason, 1, 1, 0.35, INTERPOLATOR_SIMPLESPLINE )
		
		wait 4.5
		
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
	}()
}

void function ServerCallback_ResetMoney()
{
	file.availableMoney = 0

	Hud_SetText( HudElement( "SND_AvailableMoney" ), "$" + file.availableMoney.tostring() )
}

void function SetCameraStartPointForMap()
{
	switch( MapName() )
	{
		case eMaps.mp_rr_arena_composite:
			file.cameraStart = <-1830.57922, 7155.41406, 1150.48047>
			file.cameraAnglesStart = <0, 28, 0>
		break

		case eMaps.mp_rr_desertlands_64k_x_64k:
			file.cameraStart = <24961.9648, 23251.0977, -3110.40308>
			file.cameraAnglesStart = <0, -170.236649, 0>
		break
		
		case eMaps.mp_rr_arena_skygarden:
			file.cameraStart = <499.259277, 2014.12402, 3020.03125>
			file.cameraAnglesStart = <0, -122.591728, 0>
		break
		
		case eMaps.mp_rr_olympus_mu1:
		case eMaps.mp_rr_arena_empty:
		case eMaps.mp_rr_party_crasher_new:
			file.cameraStart = <238.288742, 94.6433334, 11841.7451>
			file.cameraAnglesStart = <0, -177.9431, 0>
		break
	}
}

void function ServerCallback_FlowstateSND_CustomBuyMenu_UpdateValues(int availableMoney, int weapon1ID, int weapon2ID, int weapon1lvl, int weapon2lvl)
{
	#if DEVELOPER
		printt("updating values, weaponid: " + weapon1ID + " | weapon 2 id: " + weapon2ID + " | weapon1lvl: " + weapon1lvl + " | weapon2lvl: " + weapon2lvl)
	#endif
	
	file.availableMoney = availableMoney
	file.weapon1ID = weapon1ID
	file.weapon2ID = weapon2ID
	file.weapon1lvl = weapon1lvl
	file.weapon2lvl = weapon2lvl
	
	SetTierForSlotFromWeaponIDAndLVL(file.weapon1ID, file.weapon1lvl)
	SetTierForSlotFromWeaponIDAndLVL(file.weapon2ID, file.weapon2lvl)
	
	FillWeaponBoxTest(0)
	FillWeaponBoxTest(1)
}

void function SND_ClientAskedForTeam(int index)
{
	entity player = GetLocalClientPlayer()
	
	switch(index)
	{
		case 0:
		player.ClientCommand("AskForTeam 0")
		break
		
		case 1:
		player.ClientCommand("AskForTeam 1")
		break
		
		default:
		break
	}	
}

#if DEVELOPER
void function TestCustomModelAngles( vector angles )
{
	file.menumodelCharacter.SetAngles( angles )
}
#endif
void function FlowstateSND_CustomBuyMenu_Start(int currentRound, int availableMoney, int weapon1ID, int weapon2ID, int weapon1lvl, int weapon2lvl, bool showSavedWeapons)
{
	EmitSoundOnEntity( GetLocalClientPlayer(), "Music_CharacterSelect_Wattson" )
	EmitSoundOnEntity( GetLocalClientPlayer(),  "UI_PostGame_CoinMove" )
	
	FSDM_CloseVotingPhase()
	
	file.availableMoney = availableMoney
	file.weapon1ID = weapon1ID
	file.weapon2ID = weapon2ID
	file.weapon1lvl = weapon1lvl
	file.weapon2lvl = weapon2lvl
	file.currentRound = currentRound
		
	entity player = GetLocalClientPlayer()

	if(!showSavedWeapons)
	{
		{
			var rui = Hud_GetRui( HudElement( "MainWeapon0" ) )
			RuiSetBool( rui, "isFullyKitted", false )
			RuiSetBool( rui, "showBrackets", false )
			RuiSetBool(  rui, "brackerGradientEnabled", false )

			RuiSetImage( rui, "iconImage", GetEmptyEquipmentImage( "main_weapon0" ) )
			
			RuiSetInt( rui, "lootTier", 0 )
			Hud_SetText( HudElement( "MainWeapon0_Name" ), "Primary" )
		}
		
		{
			var rui = Hud_GetRui( HudElement( "MainWeapon1" ) )
			RuiSetBool( rui, "isFullyKitted", false )
			RuiSetBool( rui, "showBrackets", false )
			RuiSetBool(  rui, "brackerGradientEnabled", false )
			
			RuiSetImage( rui, "iconImage", GetEmptyEquipmentImage( "main_weapon1" ) )
			
			RuiSetInt( rui, "lootTier", 0 )				
			Hud_SetText( HudElement( "MainWeapon1_Name" ), "Secondary" )
		}
		
		foreach ( button in file.equipmentButtons )
		{
			var rui              = Hud_GetRui( button )
			string equipmentSlot = Hud_GetScriptID( button )

			if ( !EquipmentSlot_IsValidEquipmentSlot( equipmentSlot ) )
				continue

			LootData data    = EquipmentSlot_GetEquippedLootDataForSlot( player, equipmentSlot )
			string equipment = data.ref
			
			RuiSetInt( rui, "lootTier", 0 )	
			RuiSetImage( rui, "iconImage", GetEmptyEquipmentImage( equipmentSlot ) )
		}
	}
	file.camera = CreateClientSidePointCamera(file.cameraStart, file.cameraAnglesStart,70)

	EmitSoundOnEntity(player, "UI_Menu_Purchase_Coins" )
	
	file.menumodelCharacter = CreateClientSidePropDynamic( Vector(0,0,-60) + file.camera.GetOrigin() + AnglesToForward(file.camera.GetAngles())*55 + AnglesToRight(file.camera.GetAngles())*20, Vector(0,0,0), GetLocalClientPlayer().GetModelName() ) // GetLocalClientPlayer().GetModelName() )
	file.menumodelCharacter.SetAngles( Vector(0, VectorToAngles( file.camera.GetOrigin() - file.menumodelCharacter.GetOrigin() ).y - 10 % 360, 0) )
	
	// file.menumodelCharacter.SetAngles( Vector(0,90,90) )

	// file.menumodelCharacter.SetSkin(2)
	
	// if( player.GetTeam() == TEAM_IMC )
		// file.menumodelCharacter.SetCamo(IMC_color)
	// else if( player.GetTeam() == TEAM_MILITIA )
		// file.menumodelCharacter.SetCamo(MILITIA_color)
	
	int tagID = file.menumodelCharacter.LookupAttachment( "VDU" )
	vector heightFix = file.menumodelCharacter.GetAttachmentOrigin( tagID )
	file.camera.SetOrigin( Vector(file.camera.GetOrigin().x, file.camera.GetOrigin().y, heightFix.z - 10 ) )
	
	file.menumodelWeaponPrimary = CreateClientSidePropDynamic( file.menumodelCharacter.GetOrigin(), <0, -120, 0>, $"mdl/dev/empty_model.rmdl" )
	file.menumodelWeaponSecondary = CreateClientSidePropDynamic( file.menumodelCharacter.GetOrigin(), <0, -120, 0>, $"mdl/dev/empty_model.rmdl" )
	thread PlayAnim(file.menumodelCharacter, "ACT_MP_MENU_LOBBY_SELECT_IDLE", file.menumodelCharacter)
	
	player.ClearMenuCameraEntity()
	DoF_SetNearDepthToDefault()
	DoF_SetFarDepthToDefault()
	
	player.SetMenuCameraEntity( file.camera )

	if(showSavedWeapons)
	{
		if(IsValid(player.GetNormalWeapon( 0 ) ) && GetWeaponModelFromWeaponID( file.weapon1ID ) != $"mdl/dev/empty_model.rmdl")			
			HandleCharacterAndWeaponMenuModel( GetWeaponModelFromWeaponID( file.weapon1ID ), false, 0, file.weapon1lvl)	
		
		if(IsValid(player.GetNormalWeapon( 1 ) ) && GetWeaponModelFromWeaponID( file.weapon2ID ) != $"mdl/dev/empty_model.rmdl")
			HandleCharacterAndWeaponMenuModel( GetWeaponModelFromWeaponID( file.weapon2ID ), false, 1, file.weapon2lvl)
	}
	
	thread function() : ()
	{
		WaitFrame()
		DoF_SetFarDepth( 50, 2300 )
	}()
	
	SetCrosshairPriorityState( crosshairPriorityLevel.MENU, CROSSHAIR_STATE_HIDE_ALL )
	
	Hud_SetVisible( HudElement( "MouseCursorTest" ), true )
	Hud_SetVisible( HudElement( "WheelTest" ), true )
	// Hud_SetVisible( HudElement( "BuyMenuTitle" ), true )
	// Hud_SetVisible( HudElement( "BuyMenuBoxMsg" ), true )
	
	Hud_SetVisible( HudElement( "AvailableMoney" ), true )
	//Hud_SetVisible( HudElement( "AvailableMoneyFrame" ), true )
	Hud_SetText( HudElement( "AvailableMoney" ), "$" + file.availableMoney.tostring() )
	
	//Hud_SetVisible( HudElement( "YourTeamBox" ), true )
	//Hud_SetVisible( HudElement( "YourTeamTitle" ), true )
	Hud_SetVisible( HudElement( "YourTeamIcon" ), true )
	Hud_SetVisible( HudElement( "YourTeamRole" ), true )

	Hud_SetVisible( HudElement( "BuyMenu_EnemyTeamIcon" ), true )
	Hud_SetVisible( HudElement( "BuyMenu_EnemyTeamRole" ), true )
	Hud_SetVisible( HudElement( "BuyMenu_BothTeamsScore" ), true )
	Hud_SetVisible( HudElement( "BuyMenu_RoundNumberText" ), true )
	// Hud_SetVisible( HudElement( "BuyMenu_RoundNumberNumber" ), true )
	
	Hud_SetVisible( HudElement( "BuyMenuRemainingTimeText" ), true )
	Hud_SetVisible( HudElement( "BuyMenuBottomFrame" ), true )
	Hud_SetVisible( HudElement( "BuyMenuBottomFrameBorder" ), true )
	// Hud_SetVisible( HudElement( "BuyMenuTimerFrame" ), true )
	
	Hud_SetVisible( HudElement( "MainWeapon1_Hopup" ), true )
	Hud_SetVisible( HudElement( "MainWeapon1_Grip" ), true )
	Hud_SetVisible( HudElement( "MainWeapon1_Sight" ), true )
	Hud_SetVisible( HudElement( "MainWeapon1_Mag" ), true )
	Hud_SetVisible( HudElement( "MainWeapon1_Barrel" ), true )
	Hud_SetVisible( HudElement( "MainWeapon1"), true )
	Hud_SetVisible( HudElement( "MainWeapon1_Name" ), true )
	Hud_SetVisible( HudElement( "MainWeapon0_Hopup" ), true )
	Hud_SetVisible( HudElement( "MainWeapon0_Grip" ), true )
	Hud_SetVisible( HudElement( "MainWeapon0_Sight" ), true )
	Hud_SetVisible( HudElement( "MainWeapon0_Mag"), true )
	Hud_SetVisible( HudElement( "MainWeapon0_Barrel" ), true )
	Hud_SetVisible( HudElement( "MainWeapon0" ), true )
	Hud_SetVisible( HudElement( "MainWeapon0_Name" ), true )
	//Hud_SetVisible( HudElement( "WeaponsBoughtFrame" ), true )

	// if( player.GetTeam() == TEAM_IMC )
	// {
		RuiSetImage( Hud_GetRui( HudElement( "YourTeamIcon" ) ), "basicImage", $"rui/flowstatecustom/imc" )
		RuiSetImage( Hud_GetRui( HudElement( "BuyMenu_EnemyTeamIcon" ) ), "basicImage", $"rui/flowstatecustom/militia" )
		
		if(TEAM_IMC == Sh_GetAttackerTeam())
		{
			Hud_SetText( HudElement( "YourTeamRole"), "YOU'RE ATTACKING" )
			Hud_SetText( HudElement( "BuyMenu_EnemyTeamRole"), "ENEMY TEAM DEFENDING" )
		}
		else if(TEAM_IMC == Sh_GetDefenderTeam())
		{
			Hud_SetText( HudElement( "YourTeamRole"), "YOU'RE DEFENDING" )
			Hud_SetText( HudElement( "BuyMenu_EnemyTeamRole"), "ENEMY TEAM ATTACKING" )
		}
	// }
	// else if( player.GetTeam() == TEAM_MILITIA )
	// {
		RuiSetImage( Hud_GetRui( HudElement( "YourTeamIcon" ) ), "basicImage", $"rui/flowstatecustom/militia" )
		RuiSetImage( Hud_GetRui( HudElement( "BuyMenu_EnemyTeamIcon" ) ), "basicImage", $"rui/flowstatecustom/imc" )
		
		if(TEAM_MILITIA == Sh_GetAttackerTeam())
		{
			Hud_SetText( HudElement( "YourTeamRole"), "YOU'RE ATTACKING" )
			Hud_SetText( HudElement( "BuyMenu_EnemyTeamRole"), "ENEMY TEAM DEFENDING" )
		}
		else if(TEAM_MILITIA  == Sh_GetDefenderTeam())
		{
			Hud_SetText( HudElement( "YourTeamRole"), "YOU'RE DEFENDING" )
			Hud_SetText( HudElement( "BuyMenu_EnemyTeamRole"), "ENEMY TEAM ATTACKING" )
		}
	// }
	
	//build score
	string thisroundScore = SND_GetIMCWins().tostring() + " - " + SND_GetMilitiaWins().tostring()
	Hud_SetText( HudElement( "BuyMenu_BothTeamsScore"), thisroundScore )
	
	Hud_SetText( HudElement( "BuyMenu_RoundNumberText"), "Round " + file.currentRound.tostring() )
	
	file.isShowingBuyMenu = true
	file.activeMenu = BuyMenuMenus.MAIN
	file.lastFocusTime = 0
	file.focusedSlot = -1
		
	CreateBuyMenuRUI()
	
	HudInputContext inputContext
	inputContext.keyInputCallback = BuyMenu_HandleKeyInput
	inputContext.viewInputCallback = HandleMouseCursorOnClient_HACK
	inputContext.hudInputFlags = (HIF_BLOCK_WAYPOINT_FOCUS)
	HudInput_PushContext( inputContext )
}

//string function GetInstalledSight( entity weapon )
//{
//	array<string> mods
//	if ( weapon.GetNetworkedClassName() == "prop_survival" )
//		mods = weapon.GetWeaponMods()
//	else
//		mods = weapon.GetMods()
//
//	foreach ( string mod in mods )
//	{
//		if ( SURVIVAL_Loot_IsRefValid( mod ) && SURVIVAL_Loot_GetLootDataByRef( mod ).attachmentStyle == "sight" )
//			return mod
//	}
//
//	return ""
//}
string function GetEquipmentSlotTypeForButton( var button )
{
	string scriptID = Hud_GetScriptID( button )
	return scriptID
}

void function FlowstateSND_CustomBuyMenu_Stop()
{
	if ( file.isShowingBuyMenu )
	{
		GetLocalClientPlayer().ClearMenuCameraEntity()
		Signal(GetLocalClientPlayer(), "ChangeMenuModelAnim")
		
		FadeOutSoundOnEntity( GetLocalClientPlayer(), "Music_CharacterSelect_Wattson", 0.2 )
		
		if(IsValid(file.camera))
			file.camera.Destroy()
		
		if(IsValid(file.menumodelCharacter))
			file.menumodelCharacter.Destroy()
		
		if(IsValid(file.menumodelWeaponPrimary))
			file.menumodelWeaponPrimary.Destroy()
		
		if(IsValid(file.menumodelWeaponSecondary))
			file.menumodelWeaponSecondary.Destroy()

		DoF_SetNearDepthToDefault()
		DoF_SetFarDepthToDefault()
			
		Hud_SetVisible( HudElement( "MouseCursorTest" ), false )
		Hud_SetVisible( HudElement( "WheelTest" ), false )
		// Hud_SetVisible( HudElement( "BuyMenuTitle" ), false )
		Hud_SetVisible( HudElement( "AvailableMoney" ), false )
		//Hud_SetVisible( HudElement( "AvailableMoneyFrame" ), false )
		// Hud_SetVisible( HudElement( "BuyMenuBoxMsg" ), false )
		Hud_SetVisible( HudElement( "BuyMenuRemainingTimeText" ), false )
		Hud_SetVisible( HudElement( "BuyMenuBottomFrame" ), false )
		Hud_SetVisible( HudElement( "BuyMenuBottomFrameBorder" ), false )
		// Hud_SetVisible( HudElement( "BuyMenuTimerFrame" ), false )
		
		//Hud_SetVisible( HudElement( "YourTeamBox" ), false )
		//Hud_SetVisible( HudElement( "YourTeamTitle" ), false )
		Hud_SetVisible( HudElement( "YourTeamIcon" ), false )
		Hud_SetVisible( HudElement( "YourTeamRole" ), false )

		Hud_SetVisible( HudElement( "BuyMenu_EnemyTeamIcon" ), false )
		Hud_SetVisible( HudElement( "BuyMenu_EnemyTeamRole" ), false )
		Hud_SetVisible( HudElement( "BuyMenu_BothTeamsScore" ), false )
		Hud_SetVisible( HudElement( "BuyMenu_RoundNumberText" ), false )
		// Hud_SetVisible( HudElement( "BuyMenu_RoundNumberNumber" ), false )
		//Hud_SetVisible( HudElement( "WeaponsBoughtFrame" ), false )
		Hud_SetVisible( HudElement( "MainWeapon1_Hopup" ), false )
		Hud_SetVisible( HudElement( "MainWeapon1_Grip" ), false )
		Hud_SetVisible( HudElement( "MainWeapon1_Sight" ), false )
		Hud_SetVisible( HudElement( "MainWeapon1_Mag" ), false )
		Hud_SetVisible( HudElement( "MainWeapon1_Barrel" ), false )
		Hud_SetVisible( HudElement( "MainWeapon1"), false )
		Hud_SetVisible( HudElement( "MainWeapon1_Name" ), false )
		Hud_SetVisible( HudElement( "MainWeapon0_Hopup" ), false )
		Hud_SetVisible( HudElement( "MainWeapon0_Grip" ), false )
		Hud_SetVisible( HudElement( "MainWeapon0_Sight" ), false )
		Hud_SetVisible( HudElement( "MainWeapon0_Mag"), false )
		Hud_SetVisible( HudElement( "MainWeapon0_Barrel" ), false )
		Hud_SetVisible( HudElement( "MainWeapon0" ), false )
		Hud_SetVisible( HudElement( "MainWeapon0_Name" ), false )
	
		RuiSetInt( Hud_GetRui( HudElement( "WheelTest" ) ), "focusedSlot", -1 )
		
		file.isShowingBuyMenu = false
		file.activeMenu = BuyMenuMenus.MAIN
		file.lastFocusTime = 0
		file.focusedSlot = -1
		file.executeNewAnim = true
		//file.availableMoney = -1
		file.weapon1ID = -1
		file.weapon2ID = -1
		file.weapon1lvl = -1
		file.weapon2lvl = -1

		ClearCrosshairPriority( crosshairPriorityLevel.MENU )
		HudInput_PopContext()
		
		Hud_SetText( HudElement( "RoundNumberText"), (file.currentRound).tostring() )
		
		// This will block stick input until you return them back to center
		HudInputContext inputContext
		inputContext.keyInputCallback = BuyMenuCleanup_HandleKeyInput
		inputContext.viewInputCallback = BuyMenuCleanup_HandleViewInput
		HudInput_PushContext( inputContext )
	}
}

bool function BuyMenuCleanup_HandleKeyInput( int key )
{
	HudInput_PopContext()
	return false
}

bool function BuyMenuCleanup_HandleViewInput( float x, float y )
{
	if ( x == 0 && y == 0 )
		return true

	if ( fabs( x ) + fabs( y ) > 0.4 )
		return true

	HudInput_PopContext()
	return false
}

bool function HandleMouseCursorOnClient_HACK( float x, float y ) //from radial menu, heavily modified. Colombia
{
	if(Hud_GetRui( HudElement( "WheelTest" ) ) == null) return false
	
	UISize screenSize = GetScreenSize()
	float resMultX = screenSize.width / 1920.0
	float resMultY = screenSize.height / 1080.0
	
	file.currentx += int(x)	
	file.currentx = minint(maxint(-screenSize.width/2,file.currentx), screenSize.width/2)
	
	file.currenty += int(y)
	file.currenty = minint(maxint(-screenSize.height/2,file.currenty), screenSize.height/2)

	HudElement( "MouseCursorTest" ).SetPos( file.currentx, -file.currenty )

	if ( file.slotCount > 0 && fabs( float(file.currentx) ) + fabs( float(file.currenty) ) > 0.4 )
	{
		float circle = 2.0*PI
		float angle = atan2(file.currentx+(425*resMultX), file.currenty+(40*resMultY) ) // Indexed angle starts a 12 o'clock and is clockwise
		if ( angle < 0.0 )
		 	angle += circle

		float slotWidth = circle / file.slotCount 
		angle += slotWidth*0.5
		
		if(file.focusedSlot != int( (angle / circle) * file.slotCount ) % file.slotCount && file.focusedSlot != -1 && GetWeaponPriceFromSlot( int(file.focusedSlot) ) <= file.availableMoney)
		{
			EmitSoundOnEntity( GetLocalClientPlayer(), "menu_focus" )
			RuiSetInt( Hud_GetRui( HudElement( "WheelTest" ) ), "selectedSlot", int(int( (angle / circle) * file.slotCount ) % file.slotCount) )
		}
		
		file.focusedSlot = int( (angle / circle) * file.slotCount ) % file.slotCount

		file.lastFocusTime = Time()
	}
	else if ( IsControllerModeActive() )
	{
		if ( Time() > file.lastFocusTime + 1.5 )
		{
			RuiSetInt( Hud_GetRui( HudElement( "WheelTest" ) ), "focusedSlot", int(file.focusedSlot) )
		}
	}
	
	if( file.currentx > 30*resMultY ) // añadir un valor negativo por si el jugador tiene una pantalla muy grande, actualmente detecta el input del mouse de la mitad de la pantalla hacia la izquierda
	{
		file.focusedSlot = -1 //disables choice if mouse is outside of wheel location (solo a la derecha)
		file.selectedWeaponID = -1
		RuiSetString( Hud_GetRui( HudElement( "WheelTest" ) ), "focusedText", "" )
		RuiSetInt( Hud_GetRui( HudElement( "WheelTest" ) ), "selectedSlot", -1 )
	}

	if(file.focusedSlot != -1 && file.activeMenu != BuyMenuMenus.MAIN)
	{
		RuiSetString( Hud_GetRui( HudElement( "WheelTest" ) ), "focusedText", GetPriceForCurrentSlotAndMenu() + "\n\n" + GetWeaponNameForCurrentSlotAndMenu() )
		RuiSetString( Hud_GetRui( HudElement( "WheelTest" ) ), "labelText", MainMenu_Names[file.activeMenu] )
		RuiSetString( Hud_GetRui( HudElement( "WheelTest" ) ), "backText", "%use% RETURN" )
		RuiSetString( Hud_GetRui( HudElement( "WheelTest" ) ), "promptText", "%attack% BUY/UPGRADE\n%zoom% SELL/DOWNGRADE" )
	}
	
	if( GetWeaponPriceFromSlot( int(file.focusedSlot) ) <= file.availableMoney )
	{
		RuiSetInt( Hud_GetRui( HudElement( "WheelTest" ) ), "selectedSlot", int(file.focusedSlot) )
		RuiSetInt( Hud_GetRui( HudElement( "WheelTest" ) ), "focusedSlot", int(file.focusedSlot) )
	}else
	{
		RuiSetInt( Hud_GetRui( HudElement( "WheelTest" ) ), "selectedSlot", -1 )
		RuiSetInt( Hud_GetRui( HudElement( "WheelTest" ) ), "focusedSlot", int(file.focusedSlot) )
		RuiSetString( Hud_GetRui( HudElement( "WheelTest" ) ), "focusedText", GetPriceForCurrentSlotAndMenu() + "\n\n CAN'T BUY" )
		RuiSetString( Hud_GetRui( HudElement( "WheelTest" ) ), "backText", "%use% RETURN" )
		RuiSetString( Hud_GetRui( HudElement( "WheelTest" ) ), "promptText", " " )
	}
	
	if(file.focusedSlot != -1 && file.activeMenu == BuyMenuMenus.MAIN)
	{
		RuiSetString( Hud_GetRui( HudElement( "WheelTest" ) ), "focusedText", GetWeaponNameForCurrentSlotAndMenu() )
		RuiSetString( Hud_GetRui( HudElement( "WheelTest" ) ), "backText", "" )
	}
	
	if(file.focusedSlot == -1 && file.activeMenu == BuyMenuMenus.MAIN)
	{
		RuiSetString( Hud_GetRui( HudElement( "WheelTest" ) ), "backText", "SELECT A CATEGORY" )
	}
	return true
}

bool function IsDowngradeAllowed(int slot)
{
	if( slot == 0 )
	{
		if( file.weapon1lvl > -1 )
			return true
	}
	else if( slot == 1 )
	{
		if( file.weapon2lvl > -1 )
			return true
	}
	
	return false
}

bool function IsUpgradeAllowed(int slot)
{
	if(slot == 0 && file.weapon1ID != 12 && file.weapon1ID != 6 && file.weapon1ID != 23 || slot == 1 && file.weapon2ID != 12 && file.weapon2ID != 6 && file.weapon2ID != 23 )
		return false
	
	if( slot == 0 )
	{
		if( file.weapon1lvl < 2 )
			return true
	}
	else if( slot == 1 )
	{
		if( file.weapon2lvl < 2 )
			return true
	}
	
	return false
}

bool function BuyMenu_HandleKeyInput( int key ) //todo cleanup
{
	// Assert( IsCommsMenuActive() )
	entity player = GetLocalClientPlayer()
	
	bool shouldExecute    = false
	bool shouldCancelMenu = false
	int choice            = -1
	
	switch ( key )
	{
		case KEY_1:
			file.focusedSlot = 0
			
			if(player.IsInputCommandHeld( IN_DUCK ))
				ReturnToMainMenuOrSellWeaponByFocusedSlot()
			else
				EnterMenuOrBuyWeaponByFocusedSlot()
			break
			
		case KEY_2:
			file.focusedSlot = 1
			
			if(player.IsInputCommandHeld( IN_DUCK ))
				ReturnToMainMenuOrSellWeaponByFocusedSlot()
			else
				EnterMenuOrBuyWeaponByFocusedSlot()
			break
			
		case KEY_3:
			file.focusedSlot = 2
			
			if(player.IsInputCommandHeld( IN_DUCK ))
				ReturnToMainMenuOrSellWeaponByFocusedSlot()
			else
				EnterMenuOrBuyWeaponByFocusedSlot()
			break
			
		case KEY_4:
			file.focusedSlot = 3
			
			if(player.IsInputCommandHeld( IN_DUCK ))
				ReturnToMainMenuOrSellWeaponByFocusedSlot()
			else
				EnterMenuOrBuyWeaponByFocusedSlot()
			break
			
		case KEY_5:
			file.focusedSlot = 4
			
			if(player.IsInputCommandHeld( IN_DUCK ))
				ReturnToMainMenuOrSellWeaponByFocusedSlot()
			else
				EnterMenuOrBuyWeaponByFocusedSlot()
			break
			
		case KEY_6:
			file.focusedSlot = 5
			
			if(player.IsInputCommandHeld( IN_DUCK ))
				ReturnToMainMenuOrSellWeaponByFocusedSlot()
			else
				EnterMenuOrBuyWeaponByFocusedSlot()
			break
			
		case KEY_7:
			file.focusedSlot = 6
			
			if(player.IsInputCommandHeld( IN_DUCK ))
				ReturnToMainMenuOrSellWeaponByFocusedSlot()
			else
				EnterMenuOrBuyWeaponByFocusedSlot()
			break
			
		case KEY_8:
			file.focusedSlot = 7
			
			if(player.IsInputCommandHeld( IN_DUCK ))
				ReturnToMainMenuOrSellWeaponByFocusedSlot()
			else
				EnterMenuOrBuyWeaponByFocusedSlot()
			break
			
		case KEY_9:
			file.focusedSlot = 8
			
			if(player.IsInputCommandHeld( IN_DUCK ))
				ReturnToMainMenuOrSellWeaponByFocusedSlot()
			else
				EnterMenuOrBuyWeaponByFocusedSlot()
			break
			
		case KEY_0:
			file.focusedSlot = 9
			
			if(player.IsInputCommandHeld( IN_DUCK ))
				ReturnToMainMenuOrSellWeaponByFocusedSlot()
			else
				EnterMenuOrBuyWeaponByFocusedSlot()
			break
			
		case BUTTON_A:
		case MOUSE_LEFT:
			 //is allowed to click? check if mouse is inside wheel bounds
			EnterMenuOrBuyWeaponByFocusedSlot()
			
			break
			
		case MOUSE_RIGHT:
		case BUTTON_X:
			 //is allowed to click? check if mouse is inside wheel bounds
			ReturnToMainMenuOrSellWeaponByFocusedSlot()
			
			break
			
		case BUTTON_B:
		//case KEY_ESCAPE:
		case KEY_F:
		case KEY_E:
		
			if(file.activeMenu != BuyMenuMenus.MAIN)
			{
				CreateBuyMenuRUI( )
				EmitSoundOnEntity( GetLocalClientPlayer(), "menu_back" )
				file.executeNewAnim = true
			}
			
			#if DEVELOPER
				printt("Should return to main weapons menu if another menu is open")
			#endif
		
			break
	}

	return false
}

void function EnterMenuOrBuyWeaponByFocusedSlot()
{
	if( file.focusedSlot > GetWeaponElementsForActiveMenu().len()-1 )
		return
	
	if(file.activeMenu == BuyMenuMenus.MAIN && file.focusedSlot != -1 )
	{
		FillRuiElementsWithDatatableData( int(file.focusedSlot) + 1 )
		EmitSoundOnEntity( GetLocalClientPlayer(), "menu_accept" )
		file.focusedSlot = -1
	}
	
	if(file.activeMenu > BuyMenuMenus.MAIN && file.activeMenu <= BuyMenuMenus.SNIPER && file.focusedSlot != -1 )
	{
		FlowstateSND_RequestBuyFocusedWeapon()
	}

	if(file.activeMenu == BuyMenuMenus.GEAR && file.focusedSlot != -1 )
	{
		FlowstateSND_RequestBuyFocusedGrenade()
	}
	
	if(file.activeMenu == BuyMenuMenus.ABILITIES && file.focusedSlot != -1 )
	{
		FlowstateSND_RequestBuyFocusedAbility()
	}	
}

void function ReturnToMainMenuOrSellWeaponByFocusedSlot()
{
	if(file.activeMenu > BuyMenuMenus.MAIN && file.activeMenu <= BuyMenuMenus.SNIPER && file.focusedSlot != -1 )
	{
		FlowstateSND_RequestSellFocusedWeapon()
	}

	if(file.activeMenu == BuyMenuMenus.GEAR && file.focusedSlot != -1 )
	{
		FlowstateSND_RequestSellFocusedGrenade()
	}
	
	if(file.activeMenu == BuyMenuMenus.ABILITIES && file.focusedSlot != -1 )
	{
		FlowstateSND_RequestSellFocusedAbility()
	}	
}

void function FlowstateSND_RequestBuyFocusedWeapon()
{
	if ( GetLocalViewPlayer() != GetLocalClientPlayer() )
		return
	entity player = GetLocalClientPlayer()

    player.ClientCommand("BuySNDWeapon " + GetWeaponRefFromSlot( int(file.focusedSlot) ))
}

void function FlowstateSND_RequestBuyFocusedGrenade()
{
	if ( GetLocalViewPlayer() != GetLocalClientPlayer() )
		return
	entity player = GetLocalClientPlayer()

    player.ClientCommand("BuySNDGrenade " + GetWeaponRefFromSlot( int(file.focusedSlot) ))
}

void function FlowstateSND_RequestBuyFocusedAbility()
{
	if ( GetLocalViewPlayer() != GetLocalClientPlayer() )
		return
	entity player = GetLocalClientPlayer()

    player.ClientCommand("BuySNDAbility " + GetWeaponRefFromSlot( int(file.focusedSlot) ))
}

void function FlowstateSND_RequestSellFocusedAbility()
{
	if ( GetLocalViewPlayer() != GetLocalClientPlayer() )
		return
	entity player = GetLocalClientPlayer()

    player.ClientCommand("SellSNDAbility " + GetWeaponRefFromSlot( int(file.focusedSlot) ))
}

void function FlowstateSND_RequestSellFocusedGrenade()
{
	if ( GetLocalViewPlayer() != GetLocalClientPlayer() )
		return
	entity player = GetLocalClientPlayer()

    player.ClientCommand("SellSNDGrenade " + GetWeaponRefFromSlot( int(file.focusedSlot) ))
}

void function FlowstateSND_RequestSellFocusedWeapon()
{
	if ( GetLocalViewPlayer() != GetLocalClientPlayer() )
		return
	entity player = GetLocalClientPlayer()

    player.ClientCommand("SellSNDWeapon " + GetWeaponRefFromSlot( int(file.focusedSlot) ))
}

void function ServerCallback_BuySuccessful(int weaponID, int weaponSlot, int upgradeLevel, int priceToDiscount)
{
	if ( GetLocalViewPlayer() != GetLocalClientPlayer() )
		return
	
	#if DEVELOPER
		printt("me fui de compras en el slot " + weaponSlot)
	#endif
	
	EmitSoundOnEntity( GetLocalClientPlayer(), "UI_Menu_Store_Purchase_Success" )
	
	if(weaponSlot == 0 || weaponSlot == 1)
		thread HandleCharacterAndWeaponMenuModel( GetWeaponModelFromWeaponID( weaponID ), false, weaponSlot, upgradeLevel)

	OnMoneySpent(priceToDiscount)

	if(weaponSlot == OFFHAND_SLOT_FOR_CONSUMABLES)
		GetLocalClientPlayer().ClientCommand( "Sur_SwapToNextOrdnance" )
}

void function ServerCallback_BuyRejected() //this can be performed by the server without remote func
{
	if ( GetLocalViewPlayer() != GetLocalClientPlayer() )
		return

	EmitSoundOnEntity( GetLocalViewPlayer(), "UI_Survival_LootPickupDeny" )
}

void function ServerCallback_SellSuccessful(int weaponID, int weaponSlot, int upgradeLevel, int priceToCashback)
{
	if ( GetLocalViewPlayer() != GetLocalClientPlayer() )
		return
	
	#if DEVELOPER
		printt("vendiendo vendiendo")
	#endif
	
	EmitSoundOnEntity(GetLocalClientPlayer(), "UI_Menu_Purchase_Coins" )
	
	if(weaponSlot == 0 || weaponSlot == 1)
		thread HandleCharacterAndWeaponMenuModel( GetWeaponModelFromWeaponID( weaponID ), true, weaponSlot, upgradeLevel )

	OnMoneyCashback(priceToCashback)
	
	if(upgradeLevel == -1)
		SetTierForSlotFromWeaponIDAndLVL(weaponID, upgradeLevel, true)
}

void function HandleCharacterAndWeaponMenuModel(asset weaponModel, bool isSell, int weaponSlot, int upgradeLevel)
{
	#if DEVELOPER
		printt("Menu model data input: " + " " + weaponModel + " " + isSell + " " + weaponSlot + " " + upgradeLevel)
	#endif 
	
	entity player = GetLocalClientPlayer()

	if(isSell && upgradeLevel == -1)
	{
		if(weaponSlot == WEAPON_INVENTORY_SLOT_PRIMARY_0) 
		{
			file.menumodelWeaponPrimary.SetModel( $"mdl/dev/empty_model.rmdl" )
			file.menumodelWeaponPrimary.Hide()
			
			if( file.menumodelWeaponSecondary.GetModelName() != $"mdl/dev/empty_model.rmdl")
			{
				file.executeNewAnim = true
				file.menumodelWeaponSecondary.SetParent( file.menumodelCharacter, "PROPGUN" )
				file.menumodelWeaponPrimary.SetParent( file.menumodelCharacter, "RIFLE_HOLSTER" )
			} 
			else 
			{
				#if DEVELOPER
					printt("should return to idle, no another weapon detected")
				#endif 
				
				Signal(GetLocalClientPlayer(), "ChangeMenuModelAnim" )
				file.menumodelCharacter.Anim_Play( "ACT_MP_MENU_LOBBY_SELECT_IDLE" )
				file.executeNewAnim = true
			}
		} else if(weaponSlot == WEAPON_INVENTORY_SLOT_PRIMARY_1) 
		{
			file.menumodelWeaponSecondary.SetModel( $"mdl/dev/empty_model.rmdl" )
			file.menumodelWeaponSecondary.Hide()
			
			if( file.menumodelWeaponPrimary.GetModelName() != $"mdl/dev/empty_model.rmdl" )
			{
				file.executeNewAnim = true
				file.menumodelWeaponPrimary.SetParent( file.menumodelCharacter, "PROPGUN" )
				file.menumodelWeaponSecondary.SetParent( file.menumodelCharacter, "RIFLE_HOLSTER" )
			} else {
				Signal(GetLocalClientPlayer(), "ChangeMenuModelAnim")
				file.menumodelCharacter.Anim_Play( "ACT_MP_MENU_LOBBY_SELECT_IDLE" )
				file.executeNewAnim = true
			}
		}

		return
	}
		
	if(weaponSlot == WEAPON_INVENTORY_SLOT_PRIMARY_0)
	{
		file.menumodelWeaponPrimary.SetModel( weaponModel )
		file.menumodelWeaponPrimary.SetParent( file.menumodelCharacter, "PROPGUN" )
		file.menumodelWeaponSecondary.SetParent( file.menumodelCharacter, "RIFLE_HOLSTER" )
		file.menumodelWeaponPrimary.Show()
		entity currentweapon = player.GetNormalWeapon( weaponSlot )
		
		if(!IsValid(currentweapon)) return
		
		SetBodyGroupsForWeaponConfig( file.menumodelWeaponPrimary, currentweapon.GetWeaponClassName(), currentweapon.GetMods())
	} else if(weaponSlot == WEAPON_INVENTORY_SLOT_PRIMARY_1)
	{
		file.menumodelWeaponSecondary.SetModel( weaponModel )
		file.menumodelWeaponSecondary.SetParent( file.menumodelCharacter, "PROPGUN" )
		file.menumodelWeaponPrimary.SetParent( file.menumodelCharacter, "RIFLE_HOLSTER" )
		file.menumodelWeaponSecondary.Show()
		
		entity currentweapon = player.GetNormalWeapon( weaponSlot )
		
		if(!IsValid(currentweapon)) return
		
		SetBodyGroupsForWeaponConfig( file.menumodelWeaponSecondary, currentweapon.GetWeaponClassName(), currentweapon.GetMods())
	}	

	if(file.executeNewAnim)
	{
		ItemFlavor character = LoadoutSlot_WaitForItemFlavor( ToEHI( player ), Loadout_CharacterClass() )
		string charRef = ItemFlavor_GetHumanReadableRef( character )
		
		array<string> charRefSplit = split( charRef, "_")
		
		string shortName = charRefSplit[charRefSplit.len()-1]
		thread function () : (shortName)
		{
			Signal(GetLocalClientPlayer(), "ChangeMenuModelAnim")
			EndSignal(GetLocalClientPlayer(), "ChangeMenuModelAnim")
			string animToPlay
			
			while(IsValid(file.menumodelCharacter))
			{
				animToPlay = shortName + "_idle_rifle"
				
				if(shortName == "lifeline")
					animToPlay += "_calm"
				
				file.menumodelCharacter.Anim_Play( animToPlay )

				wait file.menumodelCharacter.GetSequenceDuration( animToPlay )
			}
		}()
		file.executeNewAnim = false
	}
}

void function OnMoneySpent(int priceForSlot)
{
	if( priceForSlot == 0 ) return

	Signal(GetLocalClientPlayer(), "NewMoneySpentRui")
	file.availableMoney -= priceForSlot
	
	file.availableMoney = maxint(0,file.availableMoney)
	Hud_SetText( HudElement( "AvailableMoney" ), "$" + file.availableMoney.tostring() )
	Hud_SetText( HudElement( "SpentMoney" ), "-$" + priceForSlot )
	
	Hud_SetVisible( HudElement( "SpentMoney" ), true)	
	Hud_SetVisible( HudElement( "MoneyCashback" ), false)
	
	thread MoneyChangedBalanced_FadeOut( HudElement( "SpentMoney" ), 0, 60, 1)
}

void function OnMoneyCashback(int priceForSlot)
{
	if( priceForSlot == 0 ) return

	Signal(GetLocalClientPlayer(), "NewMoneySpentRui")

	file.availableMoney += priceForSlot
	
	file.availableMoney = maxint(0,file.availableMoney)
	Hud_SetText( HudElement( "AvailableMoney" ), "$" + file.availableMoney.tostring() )
	Hud_SetText( HudElement( "MoneyCashback" ), "+$" + priceForSlot )
	
	Hud_SetVisible( HudElement( "SpentMoney" ), false)
	Hud_SetVisible( HudElement( "MoneyCashback" ), true)
	
	thread MoneyChangedBalanced_FadeOut( HudElement( "MoneyCashback" ), 0, 60, 1)
}

void function ServerCallback_OnMoneyAdded(int moneyAdded)
{
	if(GetLocalClientPlayer() != GetLocalViewPlayer()) return
	
	if( moneyAdded == 0 ) return

	Signal(GetLocalClientPlayer(), "NewMoneySpentRui")
	
	EmitSoundOnEntity(GetLocalClientPlayer(), "UI_Menu_Purchase_Coins" )
	
	file.availableMoney += moneyAdded
	
	Hud_SetText( HudElement( "SND_AvailableMoney" ), "$" + file.availableMoney.tostring() )
	Hud_SetText( HudElement( "SND_MoneyCashback" ), "+$" + moneyAdded )
	
	// Hud_SetVisible( HudElement( "SpentMoney" ), false)
	Hud_SetVisible( HudElement( "SND_MoneyCashback" ), true)
	
	thread MoneyChangedBalanced_FadeOut( HudElement( "SND_MoneyCashback" ), 0, 50, 1.5)
}

void function MoneyChangedBalanced_FadeOut( var label, int xOffset = 0, int yOffset = 0, float duration = 0.3 )
{
	EndSignal(GetLocalClientPlayer(), "NewMoneySpentRui")
	
	UIPos currentPos = REPLACEHud_GetPos( label )

	OnThreadEnd(
		function() : ( label, currentPos, xOffset, yOffset )
		{
			Hud_SetVisible( label, false )
			Hud_ReturnToBasePos( label )
			Hud_SetAlpha( label, 255 )
		}
	)
	UISize screenSize = GetScreenSize()
	float resMultX = screenSize.width / 1920.0
	float resMultY = screenSize.height / 1080.0
	
	Hud_FadeOverTime( label, 0, duration, INTERPOLATOR_ACCEL )

	Hud_MoveOverTime( label, currentPos.x + xOffset * resMultX, currentPos.y + yOffset * resMultY, 0.25 )
	
	wait duration
}

void function CreateBuyMenuRUI( )
{
	var rui = Hud_GetRui( HudElement( "WheelTest" ) )
	
	// if ( Hud_GetRui( HudElement( "WheelTest" ) ) == null )
		// rui = Hud_GetRui( HudElement( "WheelTest" ) )
	// else
		// rui = Hud_GetRui( HudElement( "WheelTest" ) )
	
    string labelText        = "BUY MENU"
    string backText         = "SELECT A CATEGORY"
    string promptText       = "%attack% ENTER MENU"
    string nextPageText = ""
    bool showNextPageText = true
    bool shouldShowLine     = false
    vector outerCircleColor = <255, 255, 255>

    RuiSetString( rui, "labelText", labelText )
    RuiSetString( rui, "promptText", promptText )
    RuiSetString( rui, "backText", backText )
    RuiSetBool( rui, "shouldShowLine", shouldShowLine )
    RuiSetBool( rui, "showNextPageText", showNextPageText )
    RuiSetString( rui, "nextPageText", nextPageText )
    RuiSetFloat3( rui, "outerCircleColor", SrgbToLinear( outerCircleColor / 255.0 ) )

	int count
	for(int i = 0; i < GetAllBuyMenuElements().len(); i++)
	{
		if( GetAllBuyMenuElements()[i].menuID != BuyMenuMenus.MAIN )
			continue

		RuiSetImage( rui, "optionIcon" + count, GetAllBuyMenuElements()[i].icon )
		RuiSetInt( rui, "optionTier" + count, GetAllBuyMenuElements()[i].tier )
		RuiSetFloat3( rui, "optionColor" + count, SrgbToLinear( outerCircleColor / 255.0 ) )
		RuiSetString( rui, "optionCenterText" + count, GetAllBuyMenuElements()[i].text )
		RuiSetString( rui, "optionText" + count, GetAllBuyMenuElements()[i].name )
		RuiSetBool( rui, "optionEnabled" + count, true )
		
		count++
	}
	
	file.slotCount = float(count)
    RuiSetInt( rui, "optionCount", count )
	
	file.activeMenu = BuyMenuMenus.MAIN
	RuiSetString( rui, "focusedText", "")
}

void function Cl_OnResolutionChanged()
{
	//todo add timer refresh, save endtime in file struct and call it again
	
	if( GetGameState() != eGameState.Playing )
		return
	
	SND_ToggleScoreboardVisibility(true)
	
	Hud_SetVisible( HudElement( "BombStateText_New" ), true)
	Hud_SetVisible(HudElement( "SNDTempRoundTimer" ), true)
	Hud_SetVisible(HudElement( "BombStateScreenBlur2" ), true)
	Hud_SetVisible(HudElement( "BombStateScreenBlur1" ), true)
	ServerCallback_SetBombStateFromfile()
	Thread_SNDTimer_Fromfile()
	Hud_SetText( HudElement( "SND_AvailableMoney" ), "$" + file.availableMoney.tostring() )
}

void function Cl_EntitiesDidLoad()
{
	SetCameraStartPointForMap()
	CreateClientSideDynamicLight( file.cameraStart, file.cameraAnglesStart, DLIGHT_WHITE, 130 )

	array<var> AttachmentsButtons
	AttachmentsButtons.append( HudElement( "MainWeapon1_Hopup" )) 
	AttachmentsButtons.append( HudElement( "MainWeapon1_Grip" )) 
	AttachmentsButtons.append( HudElement( "MainWeapon1_Sight" )) 
	AttachmentsButtons.append( HudElement( "MainWeapon1_Mag" )) 
	AttachmentsButtons.append( HudElement( "MainWeapon1_Barrel" )) 
	
	AttachmentsButtons.append( HudElement( "MainWeapon0_Hopup" )) 
	AttachmentsButtons.append( HudElement( "MainWeapon0_Grip" )) 
	AttachmentsButtons.append( HudElement( "MainWeapon0_Sight" )) 
	AttachmentsButtons.append( HudElement( "MainWeapon0_Mag" )) 
	AttachmentsButtons.append( HudElement( "MainWeapon0_Barrel" )) 

	AttachmentsButtons.append( HudElement( "MainWeapon1" ))
	AttachmentsButtons.append( HudElement( "MainWeapon0" )) 

	file.PrimaryWeaponName = HudElement( "MainWeapon0_Name" )
	file.SecondaryWeaponName = HudElement( "MainWeapon1_Name" )
	
	foreach ( button in AttachmentsButtons )
	{
		string equipmentType = GetEquipmentSlotTypeForButton( button )

		file.equipmentButtons[equipmentType] <- button
	}
	
	entity player = GetLocalClientPlayer()
	
	foreach ( button in file.equipmentButtons )
	{
		var rui              = Hud_GetRui( button )
		string equipmentSlot = Hud_GetScriptID( button )

		if ( !EquipmentSlot_IsValidEquipmentSlot( equipmentSlot ) )
			continue

		LootData data    = EquipmentSlot_GetEquippedLootDataForSlot( player, equipmentSlot )
		string equipment = data.ref

		RuiSetImage( rui, "iconImage", GetEmptyEquipmentImage( equipmentSlot ) )
	}
}


void function FillWeaponBoxTest(int slot)
{
	entity player = GetLocalClientPlayer()

	entity weapon = player.GetNormalWeapon( slot )
	
	if(!IsValid(weapon)) return
	
	LootData wData = SURVIVAL_GetLootDataFromWeapon( weapon )
	
	int tier = slot == 0 ? file.weapon1lvl : file.weapon2lvl
	
	#if DEVELOPER
		printt("DEBUG TIER ", tier)
	#endif
	
	{
		var rui = Hud_GetRui( HudElement( "MainWeapon" + slot ) )
		RuiSetBool( rui, "isFullyKitted", false )
		RuiSetBool( rui, "showBrackets", false )
		RuiSetBool(  rui, "brackerGradientEnabled", false )
		RuiSetImage( rui, "iconImage", wData.hudIcon )

		int lvlToUse = slot == 0 ? file.weapon1lvl : file.weapon2lvl
		
		switch(lvlToUse)
		{
			case -1:
				RuiSetInt( rui, "lootTier", 2 )
			break
			
			case 0:
				RuiSetInt( rui, "lootTier", 3 )
			break
			
			case 1:
				RuiSetInt( rui, "lootTier", 4 )
			break
			
			case 2:
				RuiSetInt( rui, "lootTier", 5 )
			break
			
			default:
				RuiSetInt( rui, "lootTier", 0 )
			break
		}
		
		Hud_SetText( HudElement( "MainWeapon" + slot + "_Name" ), wData.pickupString )
	}

	array<string> mods
	if ( weapon.GetNetworkedClassName() == "prop_survival" )
		mods = weapon.GetWeaponMods()
	else
		mods = weapon.GetMods()
	
	bool hasSight = false
	bool hasMag = false
	bool hasBarrel = false
	bool hasGrip = false
	bool hasHopup = false
	
	foreach ( string mod in mods )
	{
		#if DEVELOPER
			printt(mod, SURVIVAL_Loot_GetLootDataByRef( mod ).attachmentStyle )
		#endif
		
		LootData attachmentData = SURVIVAL_Loot_GetLootDataByRef( mod )

		if ( attachmentData.ref == "" )
			continue
		
		if ( SURVIVAL_Loot_IsRefValid( mod ) && SURVIVAL_Loot_GetLootDataByRef( mod ).attachmentStyle == "sight" )
		{
			SetIconForAttachment( "MainWeapon" + slot + "_Sight", attachmentData )
			hasSight = true
			continue
		}
		
		if ( SURVIVAL_Loot_IsRefValid( mod ) && SURVIVAL_Loot_GetLootDataByRef( mod ).attachmentStyle == "mag" || SURVIVAL_Loot_IsRefValid( mod ) && SURVIVAL_Loot_GetLootDataByRef( mod ).attachmentStyle == "mag_straight" || SURVIVAL_Loot_IsRefValid( mod ) && SURVIVAL_Loot_GetLootDataByRef( mod ).attachmentStyle == "mag_shotgun" || SURVIVAL_Loot_IsRefValid( mod ) && SURVIVAL_Loot_GetLootDataByRef( mod ).attachmentStyle == "mag_energy")
		{
			SetIconForAttachment( "MainWeapon" + slot + "_Mag", attachmentData )
			hasMag = true
			continue
		}
		
		if ( SURVIVAL_Loot_IsRefValid( mod ) && SURVIVAL_Loot_GetLootDataByRef( mod ).attachmentStyle == "barrel" || SURVIVAL_Loot_IsRefValid( mod ) && SURVIVAL_Loot_GetLootDataByRef( mod ).attachmentStyle == "barrel_stabilizer" || SURVIVAL_Loot_IsRefValid( mod ) && SURVIVAL_Loot_GetLootDataByRef( mod ).attachmentStyle == "barrel_flash")
		{
			SetIconForAttachment( "MainWeapon" + slot + "_Barrel", attachmentData )
			hasBarrel = true
			continue
		}
		
		if ( SURVIVAL_Loot_IsRefValid( mod ) && SURVIVAL_Loot_GetLootDataByRef( mod ).attachmentStyle == "grip" || SURVIVAL_Loot_IsRefValid( mod ) && SURVIVAL_Loot_GetLootDataByRef( mod ).attachmentStyle == "stock" || SURVIVAL_Loot_IsRefValid( mod ) && SURVIVAL_Loot_GetLootDataByRef( mod ).attachmentStyle == "stock_tactical")
		{
			SetIconForAttachment( "MainWeapon" + slot + "_Grip", attachmentData )
			hasGrip = true
			continue
		}
		
		string style = SURVIVAL_Loot_GetLootDataByRef( mod ).attachmentStyle
		array<string> hopup = split(style, "_")
		if ( SURVIVAL_Loot_IsRefValid( mod ) && hopup.len() > 0 && hopup[0] == "hopup" )
		{
			SetIconForAttachment( "MainWeapon" + slot + "_Hopup", attachmentData )
			hasHopup = true
			continue
		}
	}

	if(!hasSight)
		ReplaceForEmptyIcon( "MainWeapon" + slot + "_Sight" )

	if(!hasMag)
		ReplaceForEmptyIcon( "MainWeapon" + slot + "_Mag" )

	if(!hasBarrel)
		ReplaceForEmptyIcon( "MainWeapon" + slot + "_Barrel" )

	if(!hasGrip)
		ReplaceForEmptyIcon( "MainWeapon" + slot + "_Grip" )

	if(!hasHopup)
		ReplaceForEmptyIcon( "MainWeapon" + slot + "_Hopup" )
}

void function SetIconForAttachment( string hudElementName, LootData attachmentData )
{
	var rui = Hud_GetRui( HudElement( hudElementName ) )
	RuiSetBool( rui, "isFullyKitted", false )
	RuiSetBool( rui, "showBrackets", false )
	RuiSetImage( rui, "iconImage", attachmentData.hudIcon )
	RuiSetInt( rui, "lootTier", attachmentData.tier )
	RuiSetBool(  rui, "brackerGradientEnabled", false )
}

void function ReplaceForEmptyIcon(string hudElementName)
{
	var actualRui = Hud_GetRui( HudElement( hudElementName ) )
	entity player = GetLocalClientPlayer()
	
	foreach ( button in file.equipmentButtons )
	{
		var rui              = Hud_GetRui( button )
		
		if( rui != actualRui )
			continue
		
		string equipmentSlot = Hud_GetScriptID( button )

		if ( !EquipmentSlot_IsValidEquipmentSlot( equipmentSlot ) )
			continue

		LootData data    = EquipmentSlot_GetEquippedLootDataForSlot( player, equipmentSlot )
		string equipment = data.ref

		RuiSetImage( rui, "iconImage", GetEmptyEquipmentImage( equipmentSlot ) )
		RuiSetInt( rui, "lootTier", 0 )
	}	
}

void function FillRuiElementsWithDatatableData(int chosenMenu)
{
	file.activeMenu = chosenMenu
	
	var rui = Hud_GetRui( HudElement( "WheelTest" ) )
	vector outerCircleColor = <255, 255, 255>
	
	int i
	int count = 0
	
	for(i = 0; i < GetAllBuyMenuElements().len(); i++)
	{
		if( GetAllBuyMenuElements()[i].menuID != chosenMenu )
			continue

		RuiSetImage( rui, "optionIcon" + count, GetAllBuyMenuElements()[i].icon )
		RuiSetInt( rui, "optionTier" + count, GetAllBuyMenuElements()[i].tier )
		
		if(GetAllBuyMenuElements()[i].weaponID == file.weapon1ID)			
			RuiSetInt( rui, "optionTier" + count, file.weapon1lvl + 3 )
		else if(GetAllBuyMenuElements()[i].weaponID == file.weapon2ID)	
			RuiSetInt( rui, "optionTier" + count, file.weapon2lvl + 3 )	

		RuiSetFloat3( rui, "optionColor" + count, SrgbToLinear( outerCircleColor / 255.0 ) )
		RuiSetString( rui, "optionCenterText" + count, GetAllBuyMenuElements()[i].text )
		RuiSetString( rui, "optionText" + count, GetAllBuyMenuElements()[i].name )
		RuiSetBool( rui, "optionEnabled" + count, true )
		
		count++
	}
	
	for(int j = count; j < 9; j++) //Hide the remaining rui pages
	{
		RuiSetImage( rui, "optionIcon" + j, $"" )
		RuiSetInt( rui, "optionTier" + j, 0 )
		RuiSetFloat3( rui, "optionColor" + j, SrgbToLinear( outerCircleColor / 255.0 ) )
		RuiSetString( rui, "optionCenterText" + j, "" )
		RuiSetString( rui, "optionText" + j, "" )
		RuiSetBool( rui, "optionEnabled" + j, false )
	}
	
	file.slotCount = float(count)
    RuiSetInt( rui, "optionCount", count )
	RuiSetString( rui, "backText", "%use% RETURN" )
	RuiSetString( rui, "promptText", "%attack% BUY WEAPON" )
}

void function SetTierForSlotFromWeaponIDAndLVL(int weaponID, int weaponlvl, bool wasAbsoluteSell = false)
{
	int i
	int count
	
	for(i = 0; i < GetAllBuyMenuElements().len()-1; i++)
	{
		if( GetAllBuyMenuElements()[i].menuID != file.activeMenu )
			continue
		
		if(GetAllBuyMenuElements()[i].weaponID == weaponID)
			break
		
		count++
	}
	
	if(GetAllBuyMenuElements()[i].weaponID == weaponID)
	{	
		RuiSetInt( Hud_GetRui( HudElement( "WheelTest" ) ), "optionTier" + count, weaponlvl + 3 )
		
		if(wasAbsoluteSell)
		{
			RuiSetInt( Hud_GetRui( HudElement( "WheelTest" ) ), "optionTier" + count, 1 )
			
			if(weaponID == file.weapon1ID)
			{
				var rui = Hud_GetRui( HudElement( "MainWeapon0" ) )
				RuiSetBool( rui, "isFullyKitted", false )
				RuiSetBool( rui, "showBrackets", false )
				RuiSetBool(  rui, "brackerGradientEnabled", false )

				RuiSetImage( rui, "iconImage", GetEmptyEquipmentImage( "main_weapon0" ) )
				
				RuiSetInt( rui, "lootTier", 0 )
				Hud_SetText( HudElement( "MainWeapon0_Name" ), "Primary" )
			} else if(weaponID == file.weapon2ID)
			{
				var rui = Hud_GetRui( HudElement( "MainWeapon1" ) )
				RuiSetBool( rui, "isFullyKitted", false )
				RuiSetBool( rui, "showBrackets", false )
				RuiSetBool(  rui, "brackerGradientEnabled", false )
				
				RuiSetImage( rui, "iconImage", GetEmptyEquipmentImage( "main_weapon1" ) )
				
				RuiSetInt( rui, "lootTier", 0 )				
				Hud_SetText( HudElement( "MainWeapon1_Name" ), "Secondary" )
			}
		}
	}
}

string function GetWeaponRefFromSlot(int slot)
{
	int count
	for(int i = 0; i < GetAllBuyMenuElements().len(); i++)
	{
		if( GetAllBuyMenuElements()[i].menuID != file.activeMenu )
			continue
		
		if(count == slot)
			return GetAllBuyMenuElements()[i].weaponref
		
		count++
	}
	
	return ""
}

int function GetWeaponIDFromSlot(int slot)
{
	int count
	for(int i = 0; i < GetAllBuyMenuElements().len(); i++)
	{
		if( GetAllBuyMenuElements()[i].menuID != file.activeMenu )
			continue
		
		if(count == slot)
			return GetAllBuyMenuElements()[i].weaponID
		
		count++
	}
	
	return -1
}

array<weaponMenuElement> function GetWeaponElementsForActiveMenu()
{
	array<weaponMenuElement> result
	
	for(int i = 0; i < GetAllBuyMenuElements().len(); i++)
	{
		if( GetAllBuyMenuElements()[i].menuID != file.activeMenu )
			continue
		
		result.append( GetAllBuyMenuElements()[i] )
	}
	
	return result
}

string function GetWeaponNameForCurrentSlotAndMenu()
{
	if( GetWeaponElementsForActiveMenu().len() == 0) 
		return ""
	
	return GetWeaponElementsForActiveMenu()[int(file.focusedSlot)].name
}

string function GetPriceForCurrentSlotAndMenu()
{
	if( GetWeaponElementsForActiveMenu().len() == 0) 
		return ""
	
	if( file.weapon1ID == GetWeaponElementsForActiveMenu()[int(file.focusedSlot)].weaponID && file.weapon1ID == 13 || file.weapon1ID == GetWeaponElementsForActiveMenu()[int(file.focusedSlot)].weaponID && file.weapon1ID == 6 || file.weapon1ID == GetWeaponElementsForActiveMenu()[int(file.focusedSlot)].weaponID && file.weapon1ID == 23 || file.weapon2ID == GetWeaponElementsForActiveMenu()[int(file.focusedSlot)].weaponID && file.weapon2ID == 13 || file.weapon2ID == GetWeaponElementsForActiveMenu()[int(file.focusedSlot)].weaponID && file.weapon2ID == 6 || file.weapon2ID == GetWeaponElementsForActiveMenu()[int(file.focusedSlot)].weaponID && file.weapon2ID == 23 )
		return ""
	
	string finalString = "$"
	
	if( file.weapon1ID == GetWeaponElementsForActiveMenu()[int(file.focusedSlot)].weaponID )
	{
		finalString = "UPGRADE $"
		
		switch(file.weapon1lvl)
		{
			case -1:
				finalString += GetWeaponElementsForActiveMenu()[int(file.focusedSlot)].price_upgrade2.tostring()
			break
			
			case 0:
				finalString += GetWeaponElementsForActiveMenu()[int(file.focusedSlot)].price_upgrade3.tostring()
			break
			
			case 1:
				finalString += GetWeaponElementsForActiveMenu()[int(file.focusedSlot)].price_upgrade4.tostring()
			break
			
			default:
				finalString = ""
			break
		}
	} else if (file.weapon2ID == GetWeaponElementsForActiveMenu()[int(file.focusedSlot)].weaponID)
	{
		finalString = "UPGRADE $"
		
		switch(file.weapon2lvl)
		{
			case -1:
				finalString += GetWeaponElementsForActiveMenu()[int(file.focusedSlot)].price_upgrade2.tostring()
			break
			
			case 0:
				finalString += GetWeaponElementsForActiveMenu()[int(file.focusedSlot)].price_upgrade3.tostring()
			break
			
			case 1:
				finalString += GetWeaponElementsForActiveMenu()[int(file.focusedSlot)].price_upgrade4.tostring()
			break

			default:
				finalString = ""
			break
		}
	} else
	{
		finalString += GetWeaponElementsForActiveMenu()[int(file.focusedSlot)].price_base.tostring()
	}
	
	return finalString
}

asset function GetWeaponModelFromSlot(int slot)
{
	if(slot == -1 || file.activeMenu == -1)
		return $"mdl/dev/empty_model.rmdl"
	
	string weaponRef = ""
	
	int count
	for(int i = 0; i < GetAllBuyMenuElements().len(); i++)
	{
		if( GetAllBuyMenuElements()[i].menuID != file.activeMenu )
			continue
		
		if(count == slot)
			weaponRef = GetAllBuyMenuElements()[i].weaponref
		
		count++
	}

	if( weaponRef == "" ) 
		return $"mdl/dev/empty_model.rmdl"
	
	LootData data = SURVIVAL_Loot_GetLootDataByRef( weaponRef )
	return data.model
}

asset function GetWeaponModelFromWeaponID(int weaponID)
{
	if(weaponID == -1 )
		return $"mdl/dev/empty_model.rmdl"
	
	string weaponRef = ""
	
	for(int i = 0; i < GetAllBuyMenuElements().len(); i++)
	{
		if(GetAllBuyMenuElements()[i].weaponID == weaponID)
			weaponRef = GetAllBuyMenuElements()[i].weaponref
	}

	if( weaponRef == "" ) 
		return $"mdl/dev/empty_model.rmdl"
	
	LootData data = SURVIVAL_Loot_GetLootDataByRef( weaponRef )
	return data.model
}

int function GetWeaponPriceFromWeaponID(int weaponID)
{
	if(weaponID == -1 )
		return 0
	
	int price = 0
	int count
	
	for(int i = 0; i < GetAllBuyMenuElements().len(); i++)
	{
		if(GetAllBuyMenuElements()[i].weaponID == weaponID)
			price = GetAllBuyMenuElements()[i].price_base
	}

	return price
}

int function GetWeaponPriceFromSlot(int slot)
{
	if(slot == -1 || file.activeMenu == -1) 
		return 0
	
	int price = 0
	
	int count
	for(int i = 0; i < GetAllBuyMenuElements().len(); i++)
	{
		if( GetAllBuyMenuElements()[i].menuID != file.activeMenu )
			continue
		
		if(count == slot)
		{
			price = GetAllBuyMenuElements()[i].price_base
			if( file.weapon1ID == GetWeaponElementsForActiveMenu()[slot].weaponID )
			{
				switch(file.weapon1lvl)
				{
					case -1:
						price = GetWeaponElementsForActiveMenu()[slot].price_upgrade2
					break
					
					case 0:
						price = GetWeaponElementsForActiveMenu()[slot].price_upgrade3
					break
					
					case 1:
						price = GetWeaponElementsForActiveMenu()[slot].price_upgrade4
					break
					
					default:
						price = GetWeaponElementsForActiveMenu()[slot].price_base
					break
				}
			} else if (file.weapon2ID == GetWeaponElementsForActiveMenu()[slot].weaponID)
			{
				switch(file.weapon2lvl)
				{
					case -1:
						price = GetWeaponElementsForActiveMenu()[slot].price_upgrade2
					break
					
					case 0:
						price = GetWeaponElementsForActiveMenu()[slot].price_upgrade3
					break
					
					case 1:
						price = GetWeaponElementsForActiveMenu()[slot].price_upgrade4
					break

					default:
						price = GetWeaponElementsForActiveMenu()[slot].price_base
					break
				}
			} else
			{
				price = GetWeaponElementsForActiveMenu()[slot].price_base
			}
		}

		count++
	}

	return price
}

void function Thread_SNDTimer(float endtime)
{
	file.endtime = endtime
	thread function() : (endtime)
	{
		entity player = GetLocalClientPlayer()
		
		if(player != GetLocalViewPlayer()) return
		
		Signal( player, "SND_EndTimer")
		EndSignal( player, "SND_EndTimer")
		EndSignal( player, "OnDeath")
		
		//Hud_SetVisible(HudElement( "SNDTempTimerFrame" ), true)
		Hud_SetVisible(HudElement( "SNDTempRoundTimer" ), true)
		
		OnThreadEnd(
			function() : ( )
			{
				//Hud_SetVisible(HudElement( "SNDTempTimerFrame" ), false)
				Hud_SetVisible(HudElement( "SNDTempRoundTimer" ), false)
			}
		)
		
		while ( Time() <= endtime )
		{
			if(endtime == 0) break
			
			int elapsedtime = int(endtime) - Time().tointeger()

			DisplayTime dt = SecondsToDHMS( elapsedtime )
			Hud_SetText( HudElement( "SNDTempRoundTimer"), format( "%.2d:%.2d", dt.minutes, dt.seconds ))
			
			wait 1
		}
	}()
}

void function Thread_SNDTimer_Fromfile()
{
	thread function() : ( )
	{
		entity player = GetLocalClientPlayer()
		
		if(player != GetLocalViewPlayer()) return
		
		Signal( player, "SND_EndTimer")
		EndSignal( player, "SND_EndTimer")
		EndSignal( player, "OnDeath")
		
		//Hud_SetVisible(HudElement( "SNDTempTimerFrame" ), true)
		Hud_SetVisible(HudElement( "SNDTempRoundTimer" ), true)
		
		OnThreadEnd(
			function() : ( )
			{
				//Hud_SetVisible(HudElement( "SNDTempTimerFrame" ), false)
				Hud_SetVisible(HudElement( "SNDTempRoundTimer" ), false)
			}
		)
		
		while ( Time() <= file.endtime )
		{
			if(file.endtime == 0) break
			
			int elapsedtime = int(file.endtime) - Time().tointeger()

			DisplayTime dt = SecondsToDHMS( elapsedtime )
			Hud_SetText( HudElement( "SNDTempRoundTimer"), format( "%.2d:%.2d", dt.minutes, dt.seconds ))
			
			wait 1
		}
	}()
}

void function Thread_SNDBuyMenuTimer(float endtime)
{
	thread function() : (endtime)
	{
		entity player = GetLocalClientPlayer()
		
		if(player != GetLocalViewPlayer()) return
		
		Signal( player, "SND_EndTimer")
		EndSignal( player, "SND_EndTimer")
		EndSignal( player, "OnDeath")
		
		Hud_SetVisible(HudElement( "BuyMenuRemainingTimeText" ), true)
		
		OnThreadEnd(
			function() : ( )
			{
				Hud_SetVisible(HudElement( "BuyMenuRemainingTimeText" ), false)
			}
		)
		
		while ( Time() <= endtime )
		{
			if(endtime == 0) break
			
			int elapsedtime = int(endtime) - Time().tointeger()
			
			DisplayTime dt = SecondsToDHMS( elapsedtime )
			Hud_SetText( HudElement( "BuyMenuRemainingTimeText"), "STARTING IN " + format( "%.2d", dt.seconds ))
			
			wait 1
		}
	}()
}

void function SetSNDKnifeColor(int color)
{
	entity player = GetLocalClientPlayer()
	
	if(GetLocalClientPlayer() != GetLocalViewPlayer()) return
	
	if(color < 0 || color > SND_knifeColors.len() ) return
	
	player.p.snd_knifecolor = SND_knifeColors[color]
}

void function SND_ForceUpdatePlayerCount() //getting rid of networked int for this game mode, so we can show proper enemy player count (each team should have a different value, networked int will show only one value) Colombia
{
	var statusRui = ClGameState_GetRui()
	if(statusRui != null && Gamemode() == eGamemodes.fs_snd )
	{
		RuiSetInt( statusRui, "livingPlayerCount", GetPlayerArrayOfEnemies_Alive( GetLocalClientPlayer().GetTeam() ).len() )
		RuiSetInt( statusRui, "squadsRemainingCount", GetPlayerArrayOfEnemies_Alive( GetLocalClientPlayer().GetTeam() ).len() )
	}
}
