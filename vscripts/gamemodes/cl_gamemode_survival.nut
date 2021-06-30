global function ClGamemodeSurvival_Init
global function CLSurvival_RegisterNetworkFunctions

global function ServerCallback_SURVIVAL_SetRankValuesForDisplay
global function ServerCallback_AnnounceCircleClosing
global function ServerCallback_SUR_PingMinimap
global function ServerCallback_SurvivalHint
global function ServerCallback_PlayerBootsOnGround
global function ServerCallback_ClearHints
global function ServerCallback_MatchEndAnnouncement
global function ServerCallback_ShowSquadSummary
global function ServerCallback_ShowWinningSquadSequence
global function ServerCallback_AddWinningSquadData
global function ServerCallback_PromptSayThanks
global function ServerCallback_RefreshInventoryAndWeaponInfo
global function ServerCallback_RefreshDeathBoxHighlight

global function OnHealthPickupTypeChanged

global function UpdateFallbackMatchmaking
global function UpdateInventoryCounter

global function OverrideHUDHealthFractions
global function AddMinimapLabel

global function OpenSurvivalMenu

global function SURVIVAL_AddMinimapLevelLabel
global function SURVIVAL_PopulatePlayerInfoRui

global function MarkDpadAsBlocked

global function ScorebarInitTracking
global function FullMap_CommonAdd
global function FullMap_CommonTrackEntOrigin
global function FullMap_PingLocation
global function FullMap_PingEntity
global function FullMap_SetDeathFieldRadius
global function FullMap_UpdateTopologies
global function FullMap_UpdateAimPos

global function PlayerHudSetWeaponInspect
global function UpdateDpadHud

global function PROTO_ServerCallback_Sur_HoldForUltimate

global function PROTO_OpenInventoryOrSpecifiedMenu

global function UICallback_UpdateCharacterDetailsPanel
global function UICallback_OpenCharacterSelectNewMenu
global function UICallback_QueryPlayerCanBeRespawned

global function HealthkitWheelToggleEnabled
global function HealthkitWheelUseOnRelease
global function HealthkitUseOnHold

global function OrdnanceWheelToggleEnabled
global function OrdnanceWheelUseOnRelease
global function OrdnanceUseOnHold

global function GetSquadSummaryData
global function SetSquadDataToLocalTeam
global function IsSquadDataPersistenceEmpty
global function SetVictorySequenceLocation
global function ServerCallback_NessyMessage
global function ShowChampionVictoryScreen

global function CanReportPlayer

global function UIToClient_ToggleMute
global function SetSquadMuteState
global function ToggleSquadMute
global function IsSquadMuted
global function AddCallback_OnSquadMuteChanged

#if R5DEV
global function Dev_ShowVictorySequence
global function Dev_AdjustVictorySequence
#endif

global function GetCompassRui

global const FULLMAP_OBJECT_RUI           = $"ui/in_world_minimap_object.rpak"
const FULLMAP_ZOOM_SPEED_MOUSE            = 0.5
const FULLMAP_ZOOM_SPEED_CONTROLLER       = 0.1

const string SOUND_UI_TEAMMATE_KILLED     = "UI_DeathAlert_Friendly"

const string CIRCLE_CLOSING_IN_SOUND      = "UI_InGame_RingMoveWarning" //"survival_circle_close_alarm_01"
const string CIRCLE_CLOSING_SOUND         = "survival_circle_close_alarm_02"

const float TITAN_DESYNC_TIME             = 1.0
const float OVERVIEW_MAP_SIZE             = 4096 // matches magic number const from code...

// Must match gamemode_survival.rui values
const int HEALTH_STATE_DEFAULT            = 0
const int HEALTH_STATE_BLEED              = 1
const int HEALTH_STATE_REVIVE             = 2

const string SFX_DROPSELECTION_ME         = "UI_Survival_DropSelection_Player"
const string SFX_DROPSELECTION_TEAM       = "UI_Survival_DropSelection_TeamMember"

global const vector SAFE_ZONE_COLOR       = <1,1,1>
global const float SAFE_ZONE_ALPHA        = 0.05

global const string HEALTHKIT_BIND_COMMAND       = "+scriptCommand2"
global const string ORDNANCEMENU_BIND_COMMAND    = "+strafe"

struct MinimapLabelStruct
{
	string name
	vector pos
	float width = 200
	float scale = 1.0
}

global struct NextCircleDisplayCustomData
{
	float circleStartTime
	float circleCloseTime
	int roundNumber
	string roundString

	vector deathFieldOrigin
	vector safeZoneOrigin

	float deathfieldDistance
	float deathfieldStartRadius
	float deathfieldEndRadius

	asset altIcon = $""
	string altIconText
}

global struct SquadSummaryPlayerData
{
	int eHandle
	int kills
	int damageDealt
	int survivalTime
	int revivesGiven
	int respawnsGiven
}

global struct SquadSummaryData
{
	array<SquadSummaryPlayerData> playerData
	int squadPlacement = -1
}

struct
{
	var titanLinkProgressRui
	var dpadMenuRui
	var pilotRui
	var titanRui
	var compassRui

	var fallbackMMRui

	array<var> minimapTopos
	table<entity, var> minimapTopoClientEnt

	// fullscreen map
	var mapAimRui
	var mapTopo
	var mapTopoBG
	float mapCornerX
	float mapCornerY
	float mapScale
	float threatMaxDist

	bool cameFromWaitingForPlayersState      = false
	bool knowsHowToUseAmmo                   = false
	bool superHintAllowed                    = true
	bool needsMapHint                        = true

	bool toggleMuteKeysEnabled               = false
	bool isSquadMuted                        = false
	array< void functionref() > squadMuteChangeCallbacks

	entity lastPrimaryWeapon

	bool toposInitialized                    = false

	entity planeStart
	entity planeEnd

	bool mapContextPushed                    = false

	bool autoLoadoutDone                     = false

	bool haveEverSetOwnDropPoint             = false

	string playerState

	array<MinimapLabelStruct> minimapLabels

	string rodeoOfferingHintShown            = ""
	ConsumableInventoryItem rodeoOfferedItem

	bool wantsGroundItemUpdate               = false
	float nextGroundItemUpdate               = 0

	bool requestReviveButtonRegistered       = false

	table<entity, entity> playerWaypointData

	var inWorldMinimapDeathFieldRui

	vector fullmapAimPos                     = <0.5, 0.5, 0>
	vector fullmapZoomPos                    = <0.5, 0.5, 0>
	float  fullmapZoomFactor                 = 1.0

	table<string,string> toggleAttachments

	vector victorySequencePosition           = < 0, 0, 10000 >
	vector victorySequenceAngles             = < 0, 0, 0 >
	var victoryRui                           = null

	SquadSummaryData squadSummaryData
	SquadSummaryData winnerSquadSummaryData

	table< var, NestedGladiatorCardHandle > elemToGladCardHandle

	var inventoryCountRui

	bool shouldShowButtonHintsLocal

	var waitingForPlayersBlackScreenRui = null
} file

void function ClGamemodeSurvival_Init()
{
	//Sh_ArenaDeathField_Init()
	ClSurvivalCommentary_Init()
	#if MP_PVEMODE
		ObjectiveResourceSystem_Init()
	#endif
	BleedoutClient_Init()
	ClSurvivalShip_Init()
	SurvivalFreefall_Init()
	ClUnitFrames_Init()
	Cl_Survival_InventoryInit()
	Cl_Survival_LootInit()

	Bleedout_SetFirstAidStrings( "#SURVIVAL_APPLYING_FIRST_AID", "#SURVIVAL_RECIEVING_FIRST_AID" )

	RegisterSignal( "Sur_EndTrackOffhandWeaponSlot0" )
	RegisterSignal( "Sur_EndTrackAmmo" )
	RegisterSignal( "Sur_EndTrackPrimary" )
	RegisterSignal( "StopShowingRodeoOfferingPrompt" )
	RegisterSignal( "ReloadPressed" )
	RegisterSignal( "ClearSwapOnUseThread" )
	RegisterSignal( "DroppodLanded" )
	RegisterSignal( "SquadEliminated" )

	FlagInit( "SquadEliminated" )

	ClGameState_RegisterGameStateAsset( $"ui/gamestate_info_survival.rpak" )

	AddCallback_OnClientScriptInit( OverrideMinimapPackages )

	SetGameModeScoreBarUpdateRulesWithFlags( GameModeScoreBarRules, sbflag.SKIP_STANDARD_UPDATE )
	AddCallback_OnPlayerMatchStateChanged( OnPlayerMatchStateChanged )

	AddCallback_OnClientScriptInit( Cl_Survival_AddClient )

	AddCreateCallback( "npc_titan", OnTrackTitanTeam )
	AddCreateCallback( "prop_survival", OnPropCreated )
	AddCreateCallback( "prop_dynamic", OnPropDynamicCreated )
	AddCreateCallback( "player_vehicle", OnPlayerVehicleCreated )

	AddCreateCallback( "player", OnPlayerCreated )
	AddDestroyCallback( "player", OnPlayerDestroyed )
	AddOnDeathCallback( "player", OnPlayerKilled )

	//AddCreateCallback( "titan_cockpit", OnTitanCockpitCreated )
	AddCreateTitanCockpitCallback( OnTitanCockpitCreated )
	AddCreatePilotCockpitCallback( OnPilotCockpitCreated )
	AddCallback_PlayerClassChanged( Survival_OnPlayerClassChanged )

	RegisterConCommandTriggeredCallback( "-offhand4", AllowSuperHint )
	RegisterConCommandTriggeredCallback( "+scriptCommand3", ToggleFireSelect )
	RegisterConCommandTriggeredCallback( "weaponSelectOrdnance", TryCycleOrdnance )

	RegisterConCommandTriggeredCallback( "+reload", ReloadPressed )
	RegisterConCommandTriggeredCallback( "+use", UsePressed )
	RegisterConCommandTriggeredCallback( "+useAndReload", ReloadPressed )

	RegisterConCommandTriggeredCallback( HEALTHKIT_BIND_COMMAND, HealthkitButton_Down )
	RegisterConCommandTriggeredCallback( "-" + HEALTHKIT_BIND_COMMAND.slice( 1 ), HealthkitButton_Up )

	RegisterConCommandTriggeredCallback( ORDNANCEMENU_BIND_COMMAND, OrdnanceMenu_Down )
	RegisterConCommandTriggeredCallback( "-" + ORDNANCEMENU_BIND_COMMAND.slice( 1 ), OrdnanceMenu_Up )

	asset mapImage = Minimap_GetAssetForKey( "minimap" )
	file.mapCornerX = Minimap_GetFloatForKey( "pos_x" )
	file.mapCornerY = Minimap_GetFloatForKey( "pos_y" )
	file.mapScale = max( Minimap_GetFloatForKey( "scale" ), 1.0 )
	float displayDist = Minimap_GetFloatForKey( "displayDist" )
	float threatDistNear = Minimap_GetFloatForKey( "threatNearDist" )
	float threatDistFar = Minimap_GetFloatForKey( "threatFarDist" )
	file.threatMaxDist = Minimap_GetFloatForKey( "threatMaxDist" )

	file.inventoryCountRui = CreateFullscreenRui( $"ui/inventory_count_meter.rpak", 0 )

	AddScoreboardShowCallback( Sur_OnScoreboardShow )
	AddScoreboardHideCallback( Sur_OnScoreboardHide )

	AddCallback_MinimapEntShoudCreateCheck( DontCreateRuisForEnemies )
	AddCallback_MinimapEntSpawned( AddInWorldMinimapObject )
	AddCallback_LocalViewPlayerSpawned( AddInWorldMinimapObject )

	AddCallback_LocalClientPlayerSpawned( OnLocalPlayerSpawned )

	AddCallback_EntitiesDidLoad( Survival_EntitiesDidLoad )

	AddCallback_OnBleedoutStarted( Sur_OnBleedoutStarted )
	AddCallback_OnBleedoutEnded( Sur_OnBleedoutEnded )

	AddFirstPersonSpectateStartedCallback( OnFirstPersonSpectateStarted )
	AddOnSpectatorTargetChangedCallback( OnSpectatorTargetChanged )
	AddCallback_OnPlayerConsumableInventoryChanged( UpdateDpadHud )

	AddCallback_GameStateEnter( eGameState.WaitingForPlayers, Survival_WaitForPlayers )
	AddCallback_GameStateEnter( eGameState.PickLoadout, Survival_RunCharacterSelection )
	AddCallback_GameStateEnter( eGameState.Prematch, OnGamestatePrematch )
	AddCallback_GameStateEnter( eGameState.WaitingForCustomStart, SetDpadMenuVisible )
	AddCallback_GameStateEnter( eGameState.Playing, SetDpadMenuVisible )
	AddCallback_GameStateEnter( eGameState.Playing, RemoveBlackScreen )
	AddCallback_GameStateEnter( eGameState.WinnerDetermined, Survival_ClearHints )

	RegisterServerVarChangeCallback( "gameState", OnGamestateChanged )

	if ( GetCurrentPlaylistVarBool( "inventory_counter_enabled", true ) )
		AddCallback_LocalPlayerPickedUpLoot( TryUpdateInventoryCounter )

	Obituary_SetEnabled( GetCurrentPlaylistVarBool( "enable_obituary", true ) )

	foreach ( equipSlot,data in EquipmentSlot_GetAllEquipmentSlots() )
	{
		if ( data.trackingNetInt != "" )
		{
			AddCallback_OnEquipSlotTrackingIntChanged( equipSlot, EquipmentChanged )
		}
	}

	AddCallback_OnEquipSlotTrackingIntChanged( "backpack", BackpackChanged )
}


void function Survival_EntitiesDidLoad()
{
	InitInWorldScreens()

	foreach ( data in file.minimapLabels )
	{
		AddMinimapLabel( data.name, data.pos.x, data.pos.y, data.width, data.scale )
	}

	file.toposInitialized = true
}


void function InitInWorldScreens()
{
	array<entity> screens = GetEntArrayByScriptName( "inworld_minimap" )
	array<var> topos

	float size = 800 * 2

	foreach ( screen in screens )
	{
		topos.append( AddInWorldMinimapTopo( screen, size, size ) )
	}

	asset mapImage = Minimap_GetAssetForKey( "minimap" )

	file.mapCornerX = Minimap_GetFloatForKey( "pos_x" )
	file.mapCornerY = Minimap_GetFloatForKey( "pos_y" )
	float displayDist = Minimap_GetFloatForKey( "displayDist" )
	float threatDistNear = Minimap_GetFloatForKey( "threatNearDist" )
	float threatDistFar = Minimap_GetFloatForKey( "threatFarDist" )
	file.mapScale = max( Minimap_GetFloatForKey( "scale" ), 1.0 )

	file.threatMaxDist = Minimap_GetFloatForKey( "threatMaxDist" )

	foreach ( screen in topos )
	{
		var rui2 = RuiCreate( $"ui/basic_image.rpak", screen, RUI_DRAW_WORLD, FULLMAP_Z_BASE )
		RuiSetFloat3( rui2, "basicImageColor", <0, 0, 0> )

		var rui = RuiCreate( $"ui/in_world_minimap_base.rpak", screen, RUI_DRAW_WORLD, FULLMAP_Z_BASE )
		RuiSetFloat3( rui, "mapCorner", <file.mapCornerX, file.mapCornerY, 0> )
		RuiSetFloat( rui, "mapScale", file.mapScale )
		RuiSetImage( rui, "mapImage", mapImage )
		RuiSetImage( rui, "mapBgTileImage", GetMinimapBackgroundTileImage() )
		entity ent = CreateClientSidePropDynamic( <0,0,0>, <0,0,0>, $"mdl/dev/empty_model.rmdl" )
		file.minimapTopoClientEnt[ ent ] <- screen
		thread CleanupRuiOnTopoDestroy( rui, screen )
		thread CleanupRuiOnTopoDestroy( rui2, screen )
	}

	file.minimapTopos.extend( topos )

	foreach ( player in GetPlayerArray() )
	{
		if ( IsValid( player ) )
			AddInWorldMinimapObject( player )
	}

	if ( file.minimapTopos.len() > 1 )
		file.needsMapHint = false
}


bool function SprintFXAreEnabled()
{
	bool enabled = GetCurrentPlaylistVarBool( "fp_sprint_fx", false )
	return enabled
}


void function OnPlayerCreated( entity player )
{
	if ( SprintFXAreEnabled() )
	{
		if ( player == GetLocalViewPlayer() )
			thread TrackSprint( player )
	}

	if ( (player.GetTeam() == GetLocalClientPlayer().GetTeam()) && (SquadMuteIntroEnabled() || SquadMuteLegendSelectEnabled()) )
	{
		if ( IsSquadMuted() )
			SetSquadMuteState( IsSquadMuted() )
	}
}


void function OnPlayerDestroyed( entity player )
{

}


void function TrackSprint( entity player )
{
	player.EndSignal( "OnDestroy" )

	table<string, bool> e
	e[ "sprintingVisuals" ] <- false
	int fxHandle

	while ( 1 )
	{
		bool isSprint = e[ "sprintingVisuals" ]
		bool shouldSprint = ShouldShowSprintVisuals( player )

		if ( isSprint && !shouldSprint )
		{
			e[ "sprintingVisuals" ] = false
			player.SetFOVScale( 1, 2 )
			EffectStop( fxHandle, false, true )
			fxHandle = -1
		}
		else if ( !isSprint && shouldSprint )
		{
			e[ "sprintingVisuals" ] = true
			//player.SetFOVScale( 1.15, 0.2 )
			if ( IsValid( player.GetCockpit() ) )
				fxHandle = StartParticleEffectOnEntity( player.GetCockpit(), GetParticleSystemIndex( SPRINT_FP ), FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
		}

		// for some reason, this needs to get called every frame?
		if ( shouldSprint )
			player.SetFOVScale( 1.15, 2 )

		WaitFrame()
	}
}


bool function ShouldShowSprintVisuals( entity player )
{
	if ( player.GetParent() != null )
		return false

	if ( player.GetPhysics() == MOVETYPE_NOCLIP )
		return false

	entity activeWeapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
	if ( IsValid( activeWeapon ) && activeWeapon.GetWeaponSettingFloat( eWeaponVar.move_speed_modifier ) > 1 && player.IsSprinting() )
		return true

	float max = 260 //player.GetPlayerSettingFloat( "standing_sprint_speed" )

	vector fwd = player.GetViewVector()
	float dot = DotProduct( fwd, player.GetVelocity() )
	float dot2 = DotProduct( fwd, Normalize( player.GetVelocity() ) )

	return ( dot > max * 1.01 ) && ( dot2 > 0.85 )
}


var function AddInWorldMinimapTopo( entity ent, float width, float height )
{
	vector ang = ent.GetAngles()
	vector right = ((AnglesToRight( ang ) * -1) * width * 0.5)
	vector down  = ((AnglesToUp( ang ) * -1) * height * 0.5)

	vector org = ent.GetOrigin()

	org = ent.GetOrigin() - right * 0.5 - down * 0.5

	var topo = RuiTopology_CreatePlane( org, right, down, true )
	return topo
}


void function Cl_Survival_AddClient( entity player )
{
	SetBigMapZoomScale( 1.0 )
	CreateFullmap()
	HideMapRui()

	asset mapImage = Minimap_GetAssetForKey( "minimap" )
	float displayDist = Minimap_GetFloatForKey( "displayDist" )
	float threatDistNear = Minimap_GetFloatForKey( "threatNearDist" )
	float threatDistFar = Minimap_GetFloatForKey( "threatFarDist" )

	file.mapCornerX = Minimap_GetFloatForKey( "pos_x" )
	file.mapCornerY = Minimap_GetFloatForKey( "pos_y" )
	file.mapScale = max( Minimap_GetFloatForKey( "scale" ), 1.0 )

	var rui = RuiCreate( $"ui/in_world_minimap_base.rpak", file.mapTopo, FULLMAP_RUI_DRAW_LAYER, FULLMAP_Z_BASE )
	RuiSetFloat3( rui, "mapCorner", <file.mapCornerX, file.mapCornerY, 0> )
	RuiSetFloat( rui, "mapScale", file.mapScale )
	RuiTrackFloat2( rui, "zoomPos", null, RUI_TRACK_BIG_MAP_ZOOM_ANCHOR )
	RuiTrackFloat( rui, "zoomFactor", null, RUI_TRACK_BIG_MAP_ZOOM_SCALE )
	RuiSetImage( rui, "mapImage", mapImage )
	RuiSetImage( rui, "mapBgTileImage", GetMinimapBackgroundTileImage() )
	RuiSetBool( rui, "hudVersion", true )

	Fullmap_AddRui( rui )

	file.dpadMenuRui = CreateCockpitPostFXRui( SURVIVAL_HUD_DPAD_RUI, HUD_Z_BASE )
	RuiTrackFloat( file.dpadMenuRui, "reviveEndTime", player, RUI_TRACK_SCRIPT_NETWORK_VAR, GetNetworkedVariableIndex( "reviveEndTime" ) )

	getroottable().testRui <- file.dpadMenuRui
	SetDpadMenuVisible()

	#if R5DEV
		if ( GetBugReproNum() == 1972 )
			file.pilotRui = CreatePermanentCockpitPostFXRui( $"ui/survival_player_hud_editor_version.rpak", HUD_Z_BASE )
		else
			file.pilotRui = CreatePermanentCockpitPostFXRui( SURVIVAL_HUD_PLAYER, HUD_Z_BASE )
	#else
		file.pilotRui = CreatePermanentCockpitPostFXRui( SURVIVAL_HUD_PLAYER, HUD_Z_BASE )
	#endif

	RuiSetBool( file.pilotRui, "isVisible", GetHudDefaultVisibility() )
	RuiSetBool( file.pilotRui, "useShields", GetCurrentPlaylistVarInt( "survival_shields", 1 ) > 0 )

	file.compassRui = CreatePermanentCockpitRui( $"ui/compass_flat.rpak", HUD_Z_BASE )
	RuiTrackFloat3( file.compassRui, "playerAngles", player, RUI_TRACK_CAMANGLES_FOLLOW )
	RuiTrackInt( file.compassRui, "gameState", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL_INT, GetNetworkedVariableIndex( "gameState" ) )

#if PC_PROG
	if( GetCurrentPlaylistVarBool( "pc_force_pushtotalk", false ) )
		player.ClientCommand( "+pushtotalk" )
#endif //PC_PROG

	SetConVarFloat( "dof_variable_blur", 0.0 )

	#if MP_PVEMODE
		RuiTrackInt( file.pilotRui, "squadID", player, RUI_TRACK_SQUADID )
	#endif //MP_PVEMODE

	#if !MP_PVEMODE
		if ( !GetCurrentPlaylistVarBool( "survival_staging_area_enabled", false ) && !IsTestMap() && player.GetTeam() != TEAM_SPECTATOR )
		{
			//file.waitingForPlayersBlackScreenRui = CreatePermanentCockpitRui( $"ui/waiting_for_players_blackscreen.rpak", -1 )
			//RuiSetResolutionToScreenSize( file.waitingForPlayersBlackScreenRui )

			string muteString
			if ( SquadMuteIntroEnabled() && !UseSoloModeInGamePresentation() )
				muteString = Localize( IsSquadMuted() ? "#CHAR_SEL_BUTTON_UNMUTE" : "#CHAR_SEL_BUTTON_MUTE" )
			else
				muteString = ""

			//RuiSetString( file.waitingForPlayersBlackScreenRui, "squadMuteHint", muteString )
		}
	#endif //!MP_PVEMODE
}


void function InitSurvivalHealthBar()
{
	Assert( IsNewThread(), "Must be threaded off" )

	entity player = GetLocalViewPlayer()
	SURVIVAL_PopulatePlayerInfoRui( player, file.pilotRui )
}


void function SURVIVAL_PopulatePlayerInfoRui( entity player, var rui )
{
	Assert( IsValid( player ) )

	#if !MP_PVEMODE
		RuiTrackInt( rui, "teamMemberIndex", player, RUI_TRACK_PLAYER_TEAM_MEMBER_INDEX )
	#endif
	RuiTrackString( rui, "name", player, RUI_TRACK_PLAYER_NAME_STRING )
	RuiTrackInt( rui, "micStatus", player, RUI_TRACK_MIC_STATUS )

	ItemFlavor character = LoadoutSlot_WaitForItemFlavor( ToEHI( player ), Loadout_CharacterClass() )
	asset classIcon = CharacterClass_GetGalleryPortrait( character )
	RuiSetImage( rui, "playerIcon", classIcon )

	RuiTrackFloat( rui, "playerHealthFrac", player, RUI_TRACK_HEALTH )
	RuiTrackFloat( rui, "playerTargetHealthFrac", player, RUI_TRACK_HEAL_TARGET )
	RuiTrackFloat( rui, "playerShieldFrac", player, RUI_TRACK_SHIELD_FRACTION )

	if ( GetCurrentPlaylistVarInt( "survival_shields", 1 ) )
	{
		vector shieldFrac = < SURVIVAL_GetShieldHealthForTier( 0 ) / 100.0,
				SURVIVAL_GetShieldHealthForTier( 1 ) / 100.0,
				SURVIVAL_GetShieldHealthForTier( 2 ) / 100.0 >

		RuiSetColorAlpha( rui, "shieldFrac", shieldFrac, float( SURVIVAL_GetShieldHealthForTier( 3 ) ) )
		RuiTrackFloat( rui, "playerTargetShieldFrac", player, RUI_TRACK_STATUS_EFFECT_SEVERITY, eStatusEffect.target_shields )
		RuiTrackFloat( rui, "playerTargetHealthFrac", player, RUI_TRACK_STATUS_EFFECT_SEVERITY, eStatusEffect.target_health )
		RuiTrackFloat( rui, "playerTargetHealthFracTemp", player, RUI_TRACK_HEAL_TARGET )
	}
	else
	{
		RuiSetFloat3( rui, "shieldFrac", <0, 0, 0> )
		RuiSetFloat( rui, "shield1Frac", 0 )
		RuiSetFloat( rui, "shield2Frac", 0 )
	}
}


void function OverrideHUDHealthFractions( entity player, float targetHealthFrac = -1, float targetShieldFrac = -1 )
{
	if ( targetHealthFrac < 0 )
		RuiTrackFloat( file.pilotRui, "playerTargetHealthFrac", player, RUI_TRACK_STATUS_EFFECT_SEVERITY, eStatusEffect.target_health )
	else
		RuiSetFloat( file.pilotRui, "playerTargetHealthFrac", targetHealthFrac )

	if ( targetShieldFrac < 0 )
		RuiTrackFloat( file.pilotRui, "playerTargetShieldFrac", player, RUI_TRACK_STATUS_EFFECT_SEVERITY, eStatusEffect.target_shields )
	else
		RuiSetFloat( file.pilotRui, "playerTargetShieldFrac", targetShieldFrac )
}


void function OverrideMinimapPackages( entity player )
{
	RegisterMinimapPackage( "prop_script",			eMinimapObject_prop_script.OBJECTIVE_AREA,					MINIMAP_OBJECTIVE_AREA_RUI,		MinimapPackage_ObjectiveAreaInit )
	RegisterMinimapPackage( "prop_script",			eMinimapObject_prop_script.FD_HARVESTER,					MINIMAP_OBJECT_RUI,				MinimapPackage_PlaneInit )
	RegisterMinimapPackage( "prop_script",			eMinimapObject_prop_script.AT_BANK,							MINIMAP_OBJECT_RUI,				MinimapPackage_MarkerInit )
	RegisterMinimapPackage( "npc_titan", 			eMinimapObject_npc_titan.AT_BOUNTY_BOSS, 					MINIMAP_OBJECT_RUI, 			FD_NPCTitanInit )
	RegisterMinimapPackage( "prop_script", 			eMinimapObject_prop_script.VAULT_KEY, 						MINIMAP_OBJECT_RUI, 			MinimapPackage_VaultKey )
	RegisterMinimapPackage( "prop_script", 			eMinimapObject_prop_script.VAULT_PANEL, 					MINIMAP_OBJECT_RUI, 			MinimapPackage_VaultPanel )
	RegisterMinimapPackage( "prop_script", 			eMinimapObject_prop_script.SURVEY_BEACON, 					MINIMAP_OBJECT_RUI, 			MinimapPackage_SurveyBeacon )
	RegisterMinimapPackage( "prop_script", 			eMinimapObject_prop_script.HOVERTANK, 						MINIMAP_OBJECT_RUI, 			MinimapPackage_HoverTank )
	RegisterMinimapPackage( "prop_script", 			eMinimapObject_prop_script.HOVERTANK_DESTINATION, 			MINIMAP_OBJECT_RUI, 			MinimapPackage_HoverTankDestination )
	RegisterMinimapPackage( "prop_script", 			eMinimapObject_prop_script.FLARE, 							MINIMAP_OBJECT_RUI, 			MinimapPackage_Flare )
	RegisterMinimapPackage( "prop_script", 			eMinimapObject_prop_script.TRAIN, 							MINIMAP_OBJECT_RUI, 			MinimapPackage_Train )
}


void function FD_NPCTitanInit( entity ent, var rui )
{
	RuiSetImage( rui, "defaultIcon", $"" )
	RuiSetImage( rui, "clampedDefaultIcon", $"" )
}

void function MinimapPackage_VaultPanel( entity ent, var rui )
{
	RuiSetImage( rui, "defaultIcon", $"rui/hud/gametype_icons/survival/data_knife_vault" )
	RuiSetImage( rui, "clampedDefaultIcon", $"" )
	RuiSetBool( rui, "useTeamColor", false )
}

void function MinimapPackage_VaultKey( entity ent, var rui )
{
	RuiSetImage( rui, "defaultIcon", $"rui/hud/gametype_icons/survival/data_knife" )
	RuiSetImage( rui, "clampedDefaultIcon", $"" )
	RuiSetBool( rui, "useTeamColor", false )
}

void function MinimapPackage_SurveyBeacon( entity ent, var rui )
{
	RuiSetImage( rui, "defaultIcon", $"rui/hud/gametype_icons/survival/survey_beacon_only_pathfinder" )
	RuiSetImage( rui, "clampedDefaultIcon", $"" )
	RuiSetBool( rui, "useTeamColor", false )
}

void function MinimapPackage_HoverTank( entity ent, var rui )
{
	RuiSetImage( rui, "defaultIcon", $"rui/hud/gametype_icons/survival/sur_hovertank_minimap" )
	RuiSetImage( rui, "clampedDefaultIcon", $"" )
	RuiSetBool( rui, "useTeamColor", false )
}


void function MinimapPackage_HoverTankDestination( entity ent, var rui )
{
	RuiSetImage( rui, "defaultIcon", $"rui/hud/gametype_icons/survival/sur_hovertank_minimap_destination" )
	RuiSetImage( rui, "clampedDefaultIcon", $"" )
	RuiSetBool( rui, "useTeamColor", false )
}

void function MinimapPackage_Flare( entity ent, var rui )
{
	RuiSetImage( rui, "defaultIcon", $"rui/hud/gametype_icons/survival/flare_location" )
	RuiSetImage( rui, "clampedDefaultIcon", $"" )
	RuiSetBool( rui, "useTeamColor", false )
}

void function MinimapPackage_Train( entity ent, var rui )
{
	RuiSetImage( rui, "defaultIcon", $"rui/hud/gametype_icons/sur_train_minimap" )
	RuiSetImage( rui, "clampedDefaultIcon", $"" )
	RuiSetBool( rui, "useTeamColor", false )
}

void function MinimapPackage_MarkerInit( entity ent, var rui )
{
	if ( ent.GetTargetName() != "worldMarker" )
		return

	RuiSetImage( rui, "defaultIcon", $"rui/hud/gametype_icons/ctf/ctf_flag_neutral" )
	RuiSetImage( rui, "clampedDefaultIcon", $"rui/hud/gametype_icons/ctf/ctf_flag_neutral" )
	RuiSetBool( rui, "useTeamColor", true )
}


void function MinimapPackage_PlaneInit( entity ent, var rui )
{
	if ( ent.GetTargetName() != "planeMapEnt" )
		return

	RuiSetImage( rui, "defaultIcon", $"rui/survival_ship" )
	RuiSetImage( rui, "clampedDefaultIcon", $"rui/survival_ship" )
	RuiSetBool( rui, "useTeamColor", false )
}


void function MinimapPackage_ObjectiveAreaInit( entity ent, var rui )
{
	RuiSetFloat( rui, "radiusScale", SURVIVAL_MINIMAP_RING_SCALE )
	RuiTrackFloat( rui, "objectRadius", ent, RUI_TRACK_MINIMAP_SCALE )
	RuiSetImage( rui, "clampedImage", $"" )
	RuiSetImage( rui, "centerImage", $"" )
	RuiSetBool( rui, "blink", true )

	switch ( ent.GetTargetName() )
	{
		case "safeZone":
			RuiTrackFloat3( rui, "playerPos", GetLocalViewPlayer(), RUI_TRACK_ABSORIGIN_FOLLOW )
			RuiSetColorAlpha( rui, "objColor", SrgbToLinear( SAFE_ZONE_COLOR ), SAFE_ZONE_ALPHA )
			RuiSetBool( rui, "drawLine", true )
		break

		case "safeZone_noline":
			RuiSetColorAlpha( rui, "objColor", SrgbToLinear( SAFE_ZONE_COLOR ), SAFE_ZONE_ALPHA )
		break

		case "surveyZone":
			RuiSetBool( rui, "blink", false )
			RuiSetColorAlpha( rui, "objColor", SrgbToLinear( TEAM_COLOR_PARTY / 255.0 ), 0.05 )
		break

		case "trainIcon":
			RuiSetBool( rui, "blink", false )
			RuiSetColorAlpha( rui, "objColor", SrgbToLinear( TEAM_COLOR_PARTY / 255.0 ), 1.0 )
		break

		case "negationZoneWarning":
			RuiSetColorAlpha( rui, "objColor", SrgbToLinear( <255, 187, 150> / 255.0 ), 0.12 )
			RuiSetColorAlpha( rui, "objBorderColor", SrgbToLinear( <252, 140, 112> / 255.0 ), 0.5 )
			RuiSetBool( rui, "blink", true )
			RuiSetBool( rui, "borderBlink", false )
			break

		case "negationZone":
			RuiSetColorAlpha( rui, "objColor", SrgbToLinear( <255, 48, 2> / 255.0 ), 0.5 )
			RuiSetColorAlpha( rui, "objBorderColor", SrgbToLinear( <252, 140, 112> / 255.0 ), 0.5 )
			RuiSetBool( rui, "blink", false )
			RuiSetBool( rui, "borderBlink", false )
			break
		case "hotZone":
			RuiSetColorAlpha( rui, "objColor", SrgbToLinear( <128, 188, 255> / 255.0 ), 0.25 )
			RuiSetColorAlpha( rui, "objBorderColor", SrgbToLinear( <128, 188, 255> / 255.0 ), 0.5 )
			RuiSetBool( rui, "blink", true )
			RuiSetBool( rui, "borderBlink", true )
			break
	}
}


void function CLSurvival_RegisterNetworkFunctions()
{
	if ( IsLobby() )
		return

	RegisterNetworkedVariableChangeCallback_time( "nextCircleStartTime", NextCircleStartTimeChanged )
	RegisterNetworkedVariableChangeCallback_time( "circleCloseTime", CircleCloseTimeChanged )
	RegisterNetworkedVariableChangeCallback_bool( "isHealing", OnIsHealingChanged )
}


void function ScorebarInitTracking( entity player, var statusRui )
{
	RuiTrackInt( statusRui, "livingPlayerCount",	null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL_INT, GetNetworkedVariableIndex( "livingPlayerCount" ) )
	RuiTrackInt( statusRui, "squadsRemainingCount",	null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL_INT, GetNetworkedVariableIndex( "squadsRemainingCount" ) )
	RuiTrackFloat( statusRui, "deathfieldDistance",	player, RUI_TRACK_DEATHFIELD_DISTANCE )
	RuiTrackInt( statusRui, "teamMemberIndex", player, RUI_TRACK_PLAYER_TEAM_MEMBER_INDEX )

	#if MP_PVEMODE
	#endif //MP_PVEMODE
}


void function OnHealthPickupTypeChanged( entity player, int oldKitType, int kitType, bool actuallyChanged )
{
	if ( WeaponDrivenConsumablesEnabled() )
	{
		Consumable_OnSelectedConsumableTypeNetIntChanged( player, oldKitType, kitType, actuallyChanged )
	}

	if ( player != GetLocalViewPlayer() )
		return

	UpdateDpadHud( player )
}


void function UpdateDpadHud( entity player  )
{
	if ( !IsValid( player ) || file.pilotRui == null || file.dpadMenuRui == null )
		return

	if ( !IsLocalViewPlayer( player ) )
		return

	PerfStart( PerfIndexClient.SUR_HudRefresh )

	PerfStart( PerfIndexClient.SUR_HudRefresh_1 )
	int healthItems = SURVIVAL_Loot_GetTotalHealthItems( player, eHealthPickupCategory.HEALTH )
	PerfEnd( PerfIndexClient.SUR_HudRefresh_1 )
	RuiSetInt( file.dpadMenuRui, "totalHealthPackCount", healthItems )
	PerfStart( PerfIndexClient.SUR_HudRefresh_2 )
	int shieldItems = SURVIVAL_Loot_GetTotalHealthItems( player, eHealthPickupCategory.SHIELD )
	PerfEnd( PerfIndexClient.SUR_HudRefresh_2 )
	RuiSetInt( file.dpadMenuRui, "totalShieldPackCount", shieldItems )

	int kitType = Survival_Health_GetSelectedHealthPickupType()
	if ( kitType != -1 )
	{
		PerfStart( PerfIndexClient.SUR_HudRefresh_3 )
		string kitRef    = SURVIVAL_Loot_GetHealthPickupRefFromType( kitType )
		LootData kitData = SURVIVAL_Loot_GetLootDataByRef( kitRef )
		PerfEnd( PerfIndexClient.SUR_HudRefresh_3 )
		RuiSetInt( file.dpadMenuRui, "selectedHealthPickupCount", SURVIVAL_CountItemsInInventory( player, kitRef ) )
		RuiSetImage( file.dpadMenuRui, "selectedHealthPickupIcon", kitData.hudIcon )
	}
	else
	{
		RuiSetInt( file.dpadMenuRui, "selectedHealthPickupCount", -1 )
		RuiSetImage( file.dpadMenuRui, "selectedHealthPickupIcon", $"rui/hud/gametype_icons/survival/health_pack_auto" )
	}
	PerfEnd( PerfIndexClient.SUR_HudRefresh )

	#if MP_PVEMODE
		RuiSetBool( file.dpadMenuRui, "isTitan", player.IsTitan() )
	#endif
	RuiSetInt( file.dpadMenuRui, "healthTypeCount", GetCountForLootType( eLootType.HEALTH ) )

	entity ordnanceWeapon = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_ANTI_TITAN )
	int ammo = 0
	asset ordnanceIcon = $""

	if ( IsValid( ordnanceWeapon ) )
	{
		ammo = SURVIVAL_CountItemsInInventory( player, ordnanceWeapon.GetWeaponClassName() )
		ordnanceIcon = ordnanceWeapon.GetWeaponSettingAsset( eWeaponVar.hud_icon )
	}

	RuiSetImage( file.dpadMenuRui, "ordnanceIcon", ordnanceIcon )
	RuiSetInt( file.dpadMenuRui, "ordnanceCount", ammo )
	RuiSetInt( file.dpadMenuRui, "ordnanceTypeCount", GetCountForLootType( eLootType.ORDNANCE ) )
}


bool s_didScorebarSetup = false
void function GameModeScoreBarRules( var gamestateRui )
{
	if ( !s_didScorebarSetup )
	{
		entity player = GetLocalViewPlayer()
		if ( !IsValid( player ) )
			return

		ScorebarInitTracking( player, gamestateRui )
		RuiSetBool( gamestateRui, "hideSquadsRemaining", GetCurrentPlaylistVarBool( "scorebar_hide_squads_remaining", false ) ) // TODO: FIX
		RuiSetBool( gamestateRui, "hideWaitingForPlayers", GetCurrentPlaylistVarBool( "scorebar_hide_waiting_for_players", false ) ) // TODO: FIX

		s_didScorebarSetup = true

		UpdateGamestateRuiTracking( player )

		// force update
		file.shouldShowButtonHintsLocal = !ShouldShowButtonHints()
	}

	PerfStart( PerfIndexClient.SUR_ScoreBoardRules_1 )

	PerfStart( PerfIndexClient.SUR_ScoreBoardRules_2 )

	if ( file.shouldShowButtonHintsLocal != ShouldShowButtonHints() )
	{
		entity player = GetLocalViewPlayer()
		if ( !IsValid( player ) )
			return

		bool showButtonHints = ShouldShowButtonHints()

		Minimap_UpdateShowButtonHint()
		ClWeaponStatus_UpdateShowButtonHint()
		if ( file.dpadMenuRui != null )
			RuiSetBool( file.dpadMenuRui, "showButtonHints", showButtonHints )

		file.shouldShowButtonHintsLocal = showButtonHints
	}

	PerfEnd( PerfIndexClient.SUR_ScoreBoardRules_2 )

	PerfStart( PerfIndexClient.SUR_ScoreBoardRules_3 )

	if ( GetServerVar( "connectionTimeout" ) != null && GetServerVar( "connectionTimeout" ) != 0 )
	{
		float endTime = expect float( GetServerVar( "connectionTimeout" ) )
		RuiSetGameTime( gamestateRui, "endTime", endTime )
	}

	PerfEnd( PerfIndexClient.SUR_ScoreBoardRules_3 )

	PerfEnd( PerfIndexClient.SUR_ScoreBoardRules_1 )
}

void function SetNextCircleDisplayCustom_( NextCircleDisplayCustomData data )
{
	entity localViewPlayer = GetLocalViewPlayer()
	if ( !IsValid( localViewPlayer ) )
		return

	var rui = ClGameState_GetRui()
	RuiTrackFloat3( rui, "playerOrigin", localViewPlayer, RUI_TRACK_ABSORIGIN_FOLLOW )

	RuiSetGameTime( rui, "circleStartTime", data.circleStartTime )
	RuiSetGameTime( rui, "circleCloseTime", data.circleCloseTime )
	RuiSetInt( rui, "roundNumber", data.roundNumber )
	RuiSetString( rui, "roundClosingString", data.roundString )

	RuiSetFloat3( rui, "deathFieldOrigin", data.deathFieldOrigin )
	RuiSetFloat3( rui, "safeZoneOrigin", data.safeZoneOrigin )

	RuiSetFloat( rui, "deathfieldDistance", data.deathfieldDistance )
	RuiSetFloat( rui, "deathfieldStartRadius", data.deathfieldStartRadius )
	RuiSetFloat( rui, "deathfieldEndRadius", data.deathfieldEndRadius )

	RuiSetBool( rui, "hasAltIcon", (data.altIcon != $"") )
	RuiSetImage( rui, "altIcon", data.altIcon )
	RuiSetString( rui, "altIconText", data.altIconText )
}

void function SetNextCircleDisplayCustomStarting( float circleStartTime, asset altIcon, string altIconText )
{
	NextCircleDisplayCustomData data
	data.circleStartTime = circleStartTime
	data.roundNumber = -1
	data.altIcon = altIcon
	data.altIconText = altIconText
	SetNextCircleDisplayCustom_( data )
}

void function SetNextCircleDisplayCustomClosing( float circleCloseTime, string prompt )
{
	NextCircleDisplayCustomData data
	data.circleStartTime = Time() - 4.0
	data.circleCloseTime = circleCloseTime
	data.roundString = prompt
	data.roundNumber = -1
	SetNextCircleDisplayCustom_( data )
}

void function SetNextCircleDisplayCustomClear()
{
	NextCircleDisplayCustomData data
	SetNextCircleDisplayCustom_( data )
}

void function NextCircleStartTimeChanged( entity player, float old, float new, bool actuallyChanged )
{
	if ( !actuallyChanged )
		return

	var rui = ClGameState_GetRui()

	UpdateFullmapRuiTracks()

	RuiSetGameTime( rui, "circleStartTime", new )

	int roundNumber = (SURVIVAL_GetCurrentDeathFieldStage() + 1) // can't use SURVIVAL_GetCurrentRoundString because it return "final" for the last round
	RuiSetInt( rui, "roundNumber", roundNumber )

	string roundString = Localize( "#SURVIVAL_CIRCLE_STATUS_ROUND_CLOSING", roundNumber )
	if ( SURVIVAL_IsFinalDeathFieldStage() )
		roundString = Localize( "#SURVIVAL_CIRCLE_STATUS_ROUND_CLOSING_FINAL" )
	RuiSetString( rui, "roundClosingString", roundString )

	entity localViewPlayer = GetLocalViewPlayer()
	if ( IsValid( localViewPlayer ) )
	{
		DeathFieldStageData data = GetDeathFieldStage( SURVIVAL_GetCurrentDeathFieldStage() )
		float currentRadius = SURVIVAL_GetDeathFieldCurrentRadius()
		float endRadius = data.endRadius

		RuiSetFloat( rui, "deathfieldStartRadius", currentRadius )
		RuiSetFloat( rui, "deathfieldEndRadius", endRadius )
		RuiTrackFloat3( rui, "playerOrigin", localViewPlayer, RUI_TRACK_ABSORIGIN_FOLLOW )

		#if !MP_PVEMODE
			RuiTrackInt( rui, "teamMemberIndex", localViewPlayer, RUI_TRACK_PLAYER_TEAM_MEMBER_INDEX )
		#endif
	}

	if ( new < Time() )
		return

	if ( actuallyChanged && GamePlaying() )
	{
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
		Announcement_SetPriority( announcement, 200 ) // Be higher priority than Titanfall ready indicator etc
		Announcement_SetDuration( announcement, duration )

		AnnouncementFromClass( GetLocalViewPlayer(), announcement )
	}
}

void function ServerCallback_SURVIVAL_SetRankValuesForDisplay( int myRank, int playerCountAtStart )
{
	var rui = ClGameState_GetRui()
	RuiSetInt( rui, "myRank", myRank )
	RuiSetInt( rui, "totalPlayers", playerCountAtStart )
	RuiSetBool( rui, "showRank", true )
}

void function OnIsHealingChanged( entity player, bool old, bool new, bool actuallyChanged )
{
	if ( player != GetLocalClientPlayer() )
		return

	UpdateHealHint( player )
}


void function CircleCloseTimeChanged( entity player, float old, float new, bool actuallyChanged )
{
	var rui = ClGameState_GetRui()
	RuiSetGameTime( rui, "circleCloseTime", new )

	UpdateFullmapRuiTracks()
}


void function InventoryCountChanged( entity player, int old, int new, bool actuallyChanged )
{
	ResetInventoryMenu( player )
}


asset function GetArmorIconForTypeIndex( int typeIndex )
{
	switch ( typeIndex )
	{
		case 1:
			return $"rui/hud/gametype_icons/survival/sur_armor_icon_l1"

		case 2:
			return $"rui/hud/gametype_icons/survival/sur_armor_icon_l2"

		case 3:
			return $"rui/hud/gametype_icons/survival/sur_armor_icon_l3"

		default:
			return $""
	}

	unreachable
}


void function EquipmentChanged( entity player, string equipSlot, int new )
{
	int tier = 0
	EquipmentSlot es = Survival_GetEquipmentSlotDataByRef( equipSlot )
	asset hudIcon = es.emptyImage

	if ( new > -1 )
	{
		LootData data = SURVIVAL_Loot_GetLootDataByIndex( new )
		tier = data.tier
		hudIcon = data.hudIcon

		if ( es.attachmentPoint != "" )
		{
			string attachmentStyle = GetAttachmentPointStyle( es.attachmentPoint, data.ref )
			hudIcon = emptyAttachmentSlotImages[attachmentStyle]
		}
	}

	if ( player == GetLocalViewPlayer() )
	{
		RuiSetInt( file.pilotRui, es.unitFrameTierVar, tier )
		RuiSetImage( file.pilotRui, es.unitFrameImageVar, hudIcon )

		UpdateActiveLootPings()
	}

	if ( player == GetLocalClientPlayer() )
	{
		ResetInventoryMenu( player )
	}
}


void function BackpackChanged( entity player, string equipSlot, int new )
{
	int tier = 0
	EquipmentSlot es = Survival_GetEquipmentSlotDataByRef( equipSlot )
	asset hudIcon = es.emptyImage

	if ( new > -1 )
	{
		LootData data = SURVIVAL_Loot_GetLootDataByIndex( new )
		tier = data.tier
		hudIcon = data.hudIcon
	}

	if ( player == GetLocalViewPlayer() )
	{
		RuiSetImage( file.dpadMenuRui, "backpackIcon", hudIcon )
		RuiSetInt( file.dpadMenuRui, "backpackTier", tier )
	}
}


void function UpdateActiveLootPings()
{
	entity player = GetLocalViewPlayer()
	array<entity> waypoints = Waypoints_GetActiveLootPings()
	foreach ( wp in waypoints )
	{
		entity owner = wp.GetOwner()
		if ( owner != player )
		{
			entity lootItem = Waypoint_GetItemEntForLootWaypoint( wp )
			if ( !IsValid( lootItem ) )
				continue

			LootData lootData = SURVIVAL_Loot_GetLootDataByIndex( lootItem.GetSurvivalInt() )
			RuiSetBool( wp.wp.ruiHud, "isImportant", SURVIVAL_IsLootAnUpgrade( player, lootItem, lootData, eLootContext.GROUND ) )
		}
	}
}


void function LinkContestedChanged( entity player, bool old, bool new, bool actuallyChanged )
{
	if ( player != GetLocalClientPlayer() )
		return

	if ( player != GetLocalViewPlayer() )
		return

	RuiSetBool( file.titanLinkProgressRui, "isContested", new )
}


void function LinkInUseChanged( entity player, bool old, bool new, bool actuallyChanged )
{
	if ( player != GetLocalClientPlayer() )
		return

	if ( player != GetLocalViewPlayer() )
		return

	RuiSetBool( file.titanLinkProgressRui, "isInUse", new )
}


void function OnTitanCockpitCreated( entity cockpit, entity player )
{
	var rui = ClGameState_GetRui()
	if ( file.pilotRui != null )
		RuiSetBool( file.pilotRui, "isVisible", false )
	if ( file.titanRui != null )
		RuiSetBool( file.titanRui, "isVisible", true )

	if ( player == GetLocalViewPlayer() )
	{
		// InitHealthDisplay( true )
		//thread SurvivalTitanHoverHint()
		//player.ClientCommand( "c_thirdpersonshoulderaimdist 120" )
		//player.ClientCommand( "c_thirdpersonshoulderdist 75" )
		//player.ClientCommand( "c_thirdpersonshoulderheight 12" )
		//player.ClientCommand( "c_thirdpersonshoulderoffset 100" )
	}
}


void function OnPilotCockpitCreated( entity cockpit, entity player )
{
	if ( file.pilotRui != null )
		RuiSetBool( file.pilotRui, "isVisible", GetHudDefaultVisibility() )
	if ( file.titanRui != null )
		RuiSetBool( file.titanRui, "isVisible", false )


	if ( player == GetLocalViewPlayer() )
	{
		RuiTrackBool( file.dpadMenuRui, "inventoryEnabled", GetLocalViewPlayer(), RUI_TRACK_SCRIPT_NETWORK_VAR_BOOL, GetNetworkedVariableIndex( "inventoryEnabled" ) )
		RuiTrackInt( file.dpadMenuRui, "selectedHealthPickup", GetLocalViewPlayer(), RUI_TRACK_SCRIPT_NETWORK_VAR_INT, GetNetworkedVariableIndex( "selectedHealthPickupType" ) )
		RuiTrackFloat( file.dpadMenuRui, "bleedoutEndTime", GetLocalViewPlayer(), RUI_TRACK_SCRIPT_NETWORK_VAR, GetNetworkedVariableIndex( "bleedoutEndTime" ) )

		EquipmentSlot es = Survival_GetEquipmentSlotDataByRef( "backpack" )
		RuiSetImage( file.dpadMenuRui, "backpackIcon", es.emptyImage )
		RuiSetInt( file.dpadMenuRui, "backpackTier", 0 )

		foreach ( equipSlot,data in EquipmentSlot_GetAllEquipmentSlots() )
		{
			if ( data.trackingNetInt != "" )
			{
				EquipmentChanged( GetLocalViewPlayer(), equipSlot, EquipmentSlot_GetEquippedLootDataForSlot( player, equipSlot ).index )
			}
		}
	}
}


void function ToggleFireSelect( entity player )
{
	entity weapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )

	if ( !IsValid( weapon ) )
		return

	if ( player.GetWeaponDisableFlags() == WEAPON_DISABLE_FLAGS_ALL )
		return

	foreach ( mod,toggleMod in GetToggleAttachmentsList() )
	{
		if ( IsModActive( weapon, mod ) )
		{
			WeaponModCommand_Toggle( toggleMod )
			return
		}
	}

	if ( DoesModExist( weapon, "altfire" ) && !DoesModExist( weapon, "hopup_selectfire" ) )
	{
		WeaponModCommand_Toggle( "altfire" )
		return
	}

	// Akimbo SMG
	if ( DoesModExist( weapon, "akimbo" ) )
	{
		WeaponModCommand_Toggle( "akimbo" )
		return
	}

	// Firestar ordnance
	if ( DoesModExist( weapon, "vertical_firestar" ) )
	{
		WeaponModCommand_Toggle( "vertical_firestar" )
		return
	}
}


void function ServerCallback_SUR_PingMinimap( vector origin, float duration, float spreadRadius, float ringRadius, int colorIndex )
{
	vector color = TEAM_COLOR_ENEMY
	switch ( colorIndex )
	{
		case 0:
			color = TEAM_COLOR_ENEMY
		break;

		case 1:
			color = TEAM_COLOR_FRIENDLY
		break;

		case 2:
			color = COLOR_AIRDROP
			break
	}
	thread ServerCallback_SUR_PingMinimap_Internal( origin, duration, spreadRadius, ringRadius, color )
}


void function ServerCallback_SUR_PingMinimap_Internal( vector origin, float duration, float spreadRadius, float ringRadius, vector color )
{
	entity player = GetLocalViewPlayer()
	player.EndSignal( "OnDestroy" )

	float endTime = Time() + duration

	float randMin = -1 * spreadRadius
	float randMax = spreadRadius

	float minWait = 0.6
	float maxWait = 1.0

	float pulseDuration = 1.5
	float lifeTime = 1.5

	while ( Time() < endTime )
	{
		vector newOrigin = origin + < RandomIntRange( randMin, randMax ), RandomIntRange( randMin, randMax ), 0 >  // after first ping do little offsets

		Minimap_RingPulseAtLocation( newOrigin, ringRadius, color/255.0, pulseDuration, lifeTime, false )
		FullMap_PingLocation( newOrigin, ringRadius, color/255.0, pulseDuration, lifeTime, false )

		wait RandomFloatRange( minWait, maxWait )
	}
}

struct FullmapDrawParams
{
	vector org
	vector right
	vector down
}

FullmapDrawParams function GetFullmapDrawParams()
{
	UISize screenSize = GetScreenSize()

	float mapSizeScale = GetCurrentPlaylistVarFloat( "fullmap_size_scale", 0.94 )
	float posScaleX = GetCurrentPlaylistVarFloat( "fullmap_pos_x", -0.5 )
	float posScaleY = GetCurrentPlaylistVarFloat( "fullmap_pos_y", -0.5/* - (mapSizeScale * 0.5)*/ )

	float size = (screenSize.height * mapSizeScale)
	float baseX = (screenSize.width * 0.5)
	float baseY = (screenSize.height * 0.5)

	float posX = baseX + (screenSize.height * posScaleX)
	float posY = baseY + (screenSize.height * posScaleY)

	FullmapDrawParams fp
	fp.org =	<posX, posY, 0.0>
	fp.right =	<size, 0, 0>
	fp.down =	<0, size, 0>
	return fp
}


void function CreateFullmap()
{
	FullmapDrawParams fp = GetFullmapDrawParams()
	file.mapTopoBG = RuiTopology_CreatePlane( fp.org, fp.right, fp.down, false )
	file.mapTopo = RuiTopology_CreatePlane( fp.org, fp.right, fp.down, true )
	file.minimapTopos.append( file.mapTopo )

	file.mapAimRui = RuiCreate( $"ui/survival_map_selector.rpak", file.mapTopoBG, FULLMAP_RUI_DRAW_LAYER, RUI_SORT_SCREENFADE - 1 )
	Fullmap_AddRui( file.mapAimRui )
}


void function FullMap_UpdateAimPos()
{
	RuiSetGameTime( file.mapAimRui, "updateTime", Time() )
}


void function FullMap_UpdateTopologies()
{
	FullmapDrawParams fp = GetFullmapDrawParams()

	RuiTopology_UpdatePos( file.mapTopoBG, fp.org, fp.right, fp.down )
	RuiTopology_UpdatePos( file.mapTopo, fp.org, fp.right, fp.down )
}


void function HideMapRui()
{
	//UISize screenSize = GetScreenSize()
	//vector offscreenOrg = <0.0, (screenSize.height * 5), 0.0>
	//FullmapDrawParams fp = GetFullmapDrawParams()
	//RuiTopology_UpdatePos( file.mapTopo, offscreenOrg, fp.right, fp.down )
	//RuiTopology_UpdatePos( file.mapTopoBG, offscreenOrg, fp.right, fp.down )

	Fullmap_SetVisible( false )
	UpdateMainHudVisibility( GetLocalViewPlayer() )
}


void function ShowMapRui()
{
	HidePlayerHint( "#SURVIVAL_MAP_HINT" )
	file.needsMapHint = false

	//FullmapDrawParams fp = GetFullmapDrawParams()
	//RuiTopology_UpdatePos( file.mapTopo, fp.org, fp.right, fp.down )
	//RuiTopology_UpdatePos( file.mapTopoBG, fp.org, fp.right, fp.down )

	Fullmap_SetVisible( true )
	UpdateMainHudVisibility( GetLocalViewPlayer() )
}


bool function MapDevCheatsAreActive()
{
	#if R5DEV
	if ( !GetConVarBool( "sv_cheats" ) )
		return false
	if ( InputIsButtonDown( KEY_LSHIFT ) || InputIsButtonDown( BUTTON_STICK_LEFT ) )
		return true
	#endif

	return false
}


void function UpdateMap_THREAD()
{
	EndSignal( clGlobal.signalDummy, "OnHideScoreboard" )

	Fullmap_SetVisible( true )
	UpdateMainHudVisibility( GetLocalViewPlayer() )

	OnThreadEnd(
		function() : (  )
		{
			Fullmap_SetVisible( false )
			UpdateMainHudVisibility( GetLocalViewPlayer() )
		}
	)

	for ( ;; )
	{
		if ( IsValid( file.mapAimRui ) )
		{
			RuiSetBool( file.mapAimRui, "devCheatsAreActive", MapDevCheatsAreActive() )
		}

		if ( InputIsButtonDown( BUTTON_TRIGGER_RIGHT ) )
			ChangeFullMapZoomFactor( FULLMAP_ZOOM_SPEED_CONTROLLER )

		if ( InputIsButtonDown( BUTTON_TRIGGER_LEFT ) )
			ChangeFullMapZoomFactor( -FULLMAP_ZOOM_SPEED_CONTROLLER )

		WaitFrame()
	}
}


void function ChangeFullMapZoomFactor( float delta )
{
	vector oldAimPos = GetMapNormalizedAimCoordinate()

	file.fullmapZoomFactor *= pow( 1.5, delta )

	if ( file.fullmapZoomFactor > 6.0 )
		file.fullmapZoomFactor = 6.0

	if ( file.fullmapZoomFactor < 1 )
		file.fullmapZoomFactor = 1

	SetBigMapZoomScale( file.fullmapZoomFactor )

	vector newAimPos = GetMapNormalizedAimCoordinate()

	vector zoomDelta = oldAimPos - newAimPos

	float zoomScreenWidth = 1.0 / GetBigMapZoomScale()
	float zoomAreaUpperLeftFrac = 1.0 - zoomScreenWidth

	if ( zoomAreaUpperLeftFrac > 0 )
	{
		file.fullmapZoomPos += zoomDelta / zoomAreaUpperLeftFrac
		file.fullmapZoomPos = <clamp( file.fullmapZoomPos.x, 0, 0.99999 ), clamp( file.fullmapZoomPos.y, 0, 0.99999 ), 0>

		SetBigMapZoomAnchor( file.fullmapZoomPos.x, file.fullmapZoomPos.y )
	}
}


void function Sur_OnScoreboardShow()
{
	if ( RadialMenu_IsShowing() )
		RadialMenu_Destroy()

	ShowMapRui()
	UpdateFullmapRuiTracks()

	thread UpdateMap_THREAD()

	if ( !IsSpectating() && !IsPlayerInPlane( GetLocalViewPlayer() ) )
	{
		vector normalized = NormalizeWorldPos( GetLocalViewPlayer().GetOrigin() )
		file.fullmapAimPos = normalized
		file.fullmapZoomPos = normalized
	}

	if ( IsValid( file.mapAimRui ) )
		RuiSetFloat2( file.mapAimRui, "pos", file.fullmapAimPos )

	s_inputDebounceIsActive = true
	HudInputContext inputContext
	inputContext.keyInputCallback = Survival_HandleKeyInput
	inputContext.moveInputCallback = Survival_HandleMoveInput
	inputContext.viewInputCallback = Survival_HandleViewInput
	inputContext.hudInputFlags = (HIF_ALLOW_AUTOSPRINT_FORWARD)
	HudInput_PushContext( inputContext )
	file.mapContextPushed = true
}

void function Sur_OnScoreboardHide()
{
	Signal( clGlobal.signalDummy, "OnHideScoreboard" )

	HideMapRui()

	if ( file.mapContextPushed )
	{
		HudInput_PopContext()
		file.mapContextPushed = false
	}
}


void function AddInWorldMinimapObject( entity ent )
//TODO: If we want radar jammer boost to hide friendly players we need to be able to get the rui handles back.
{
	Assert( IsValid( ent ) )
	thread AddInWorldMinimapObject_WhenValid( ent )
}


void function AddInWorldMinimapObject_WhenValid( entity ent )
{
	ent.EndSignal( "OnDestroy" )

	while ( !file.toposInitialized )
		WaitFrame()

	switch ( ent.GetTargetName() )
	{
		case "deathField":
			thread AddInWorldMinimapDeathFieldInternal( ent, file.mapTopo )
			return

		case "safeZone":
		case "surveyZone":
		case "hotZone":
			SetMapFeatureItem( 300, "#HOT_ZONE", "#HOT_ZONE_DESC", $"rui/hud/gametype_icons/survival/hot_zone" )
			thread AddInWorldMinimapObjectiveInternal( ent, file.mapTopo )
			return

		case "hovertank":
			foreach ( screen in file.minimapTopos )
				thread AddInWorldMinimapObjectInternal( ent, screen, $"rui/hud/gametype_icons/survival/sur_hovertank_minimap", $"rui/hud/gametype_icons/survival/sur_hovertank_minimap", <1.5, 1.5, 0.0>, <0.5, 0.5, 0.5> )
			return

		case "hovertankDestination":
			foreach ( screen in file.minimapTopos )
				thread AddInWorldMinimapObjectInternal( ent, screen, $"rui/hud/gametype_icons/survival/sur_hovertank_minimap_destination", $"rui/hud/gametype_icons/survival/sur_hovertank_minimap_destination", <1.5, 1.5, 0.0>, <0.5, 0.5, 0.5> )
			return

		case "SurveyBeacon":
			foreach ( screen in file.minimapTopos )
				thread AddInWorldMinimapObjectInternal( ent, screen, $"rui/hud/gametype_icons/survival/survey_beacon_only_pathfinder", $"rui/hud/gametype_icons/survival/survey_beacon_only_pathfinder", <1.5, 1.5, 0.0>, <0.5, 0.5, 0.5> )
			return

		case "pathCenterEnt":
			ent.SetDoDestroyCallback(true)
			Sur_SetPlaneCenterEnt( ent )
			foreach ( screen in file.minimapTopos )
				thread ShowPlaneTube( ent, screen )
			return

		case "planeEnt":
			foreach ( screen in file.minimapTopos )
				thread AddInWorldMinimapObjectInternal( ent, screen, $"rui/survival_ship", $"", <1.5,1.5,0.0>, <0.5, 0.5, 0.5> )
			return

		case "worldMarker":
			if ( IsFriendlyTeam( ent.GetTeam(), GetLocalViewPlayer().GetTeam() ) )
				thread AddInWorldMinimapObjectInternal( ent, file.mapTopo, $"rui/hud/gametype_icons/ctf/ctf_flag_neutral", $"rui/hud/gametype_icons/ctf/ctf_flag_neutral" )
		return
	}

	if ( ent.GetNetworkedClassName() == "player_vehicle" )
	{
		ent.SetDoDestroyCallback( true )
		thread AddInWorldMinimapObjectInternal( ent, file.mapTopo, $"rui/hud/minimap/compass_icon_small_dot", $"rui/hud/minimap/compass_icon_small_dot", <2.0,2.0,0.0> )
		return
	}

	if ( !ent.IsPlayer() && !ent.IsTitan() )
		return

	while ( IsValid( ent ) )
	{
		if ( ent.IsPlayer() && ent.GetTeam() != GetLocalViewPlayer().GetTeam() )
		{
			waitthread WaitForEntUpdate( ent, GetLocalViewPlayer() )
			continue
		}
		else if ( ent.IsTitan() && ent.GetTeam() != GetLocalViewPlayer().GetTeam() )
		{
			wait 0.5
			continue
		}
		else if ( IsValid( GetLocalViewPlayer() ) )
		{
			break
		}
		WaitFrame()
	}

	ent.SetDoDestroyCallback( true )

	thread AddInWorldMinimapObjectInternal( ent, file.mapTopo )
}


void function WaitForEntUpdate( entity ent, entity viewPlayer )
{
	EndSignal( ent, "SettingsChanged", "OnDeath" )

	EndSignal( viewPlayer, "SettingsChanged", "OnDeath" )

	WaitForever()
}


void function AddInWorldMinimapPlaneLine( var screen )
{
	if ( !IsValid( file.planeStart ) )
		return
	if ( !IsValid( file.planeEnd ) )
		return

	file.planeStart.EndSignal( "OnDestroy" )
	file.planeEnd.EndSignal( "OnDestroy" )

	int drawType = RUI_DRAW_WORLD
	if ( screen == file.mapTopo )
		drawType = RUI_DRAW_HUD

	int zOrder = file.planeEnd.Minimap_GetZOrder()

	printt( "======================= added line ========================" )

	var rui = RuiCreate( $"ui/in_world_minimap_line.rpak", screen, drawType, FULLMAP_Z_BASE + 10 )
	RuiSetFloat3( rui, "mapCorner", <file.mapCornerX, file.mapCornerY, 0.0> )
	RuiSetFloat( rui, "mapScale", file.mapScale )
	RuiTrackFloat3( rui, "startPos", file.planeStart, RUI_TRACK_ABSORIGIN_FOLLOW )
	RuiTrackFloat3( rui, "endPos", file.planeEnd, RUI_TRACK_ABSORIGIN_FOLLOW )
	RuiSetBool( rui, "hudVersion", screen == file.mapTopo )
	RuiSetBool( rui, "clipLine", false )

	OnThreadEnd(
		function() : ( rui )
		{
			printt( "Line Destroy " + rui )
			RuiDestroy( rui )
		}
	)

	entity clientEnt = GetClientEntFromTopo(screen)
	if ( clientEnt != null )
		clientEnt.EndSignal( "OnDestroy" )

	WaitForever()
}


void function AddInWorldMinimapObjectiveInternal( entity ent, var screen )
{
	if ( !IsValid( ent ) )
		return

	int customState = ent.Minimap_GetCustomState()
	asset minimapAsset = $"ui/in_world_minimap_objective_area.rpak"
	int zOrder = ent.Minimap_GetZOrder()
	entity viewPlayer = GetLocalViewPlayer()

	int drawType = RUI_DRAW_WORLD
	if ( screen == file.mapTopo )
		drawType = FULLMAP_RUI_DRAW_LAYER

	var rui = RuiCreate( minimapAsset, screen, drawType, FULLMAP_Z_BASE + zOrder )

	RuiSetFloat3( rui, "mapCorner", <file.mapCornerX, file.mapCornerY, 0.0> )
	RuiSetFloat( rui, "mapScale", file.mapScale )
	RuiTrackFloat2( rui, "zoomPos", null, RUI_TRACK_BIG_MAP_ZOOM_ANCHOR )
	RuiTrackFloat( rui, "zoomFactor", null, RUI_TRACK_BIG_MAP_ZOOM_SCALE )
	RuiTrackFloat3( rui, "objectPos", ent, RUI_TRACK_ABSORIGIN_FOLLOW )
	RuiTrackFloat3( rui, "objectAngles", ent, RUI_TRACK_EYEANGLES_FOLLOW )
	RuiTrackInt( rui, "objectFlags", ent, RUI_TRACK_MINIMAP_FLAGS )
	RuiTrackInt( rui, "customState", ent, RUI_TRACK_MINIMAP_CUSTOM_STATE )
	RuiSetFloat( rui, "displayDist", max( file.threatMaxDist, 2200 ) )
	RuiSetBool( rui, "hudVersion", screen == file.mapTopo )

	MinimapPackage_ObjectiveAreaInit( ent, rui )

	Fullmap_AddRui( rui )

	OnThreadEnd(
		function() : ( rui )
		{
			Fullmap_RemoveRui( rui )
			RuiDestroy( rui )
		}
	)

	ent.EndSignal( "OnDestroy" )
	entity clientEnt = GetClientEntFromTopo(screen)
	if ( clientEnt != null )
		clientEnt.EndSignal( "OnDestroy" )

	if ( ent.IsPlayer() )
	{
		while ( IsValid( ent ) )
		{
			WaitSignal( ent, "SettingsChanged", "OnDeath" )
			RuiSetFloat2( rui, "iconScale", ent.IsTitan() ? <1.0,1.0,0.0> : <2.0,2.0,0.0> )
		}
	}
	else
	{
		ent.WaitSignal( "OnDestroy" )
	}
}


void function AddInWorldMinimapDeathFieldInternal( entity ent, var screen )
{
	if ( !IsValid( ent ) )
		return

	int customState = ent.Minimap_GetCustomState()
	asset minimapAsset = $"ui/in_world_minimap_death_field.rpak"
	int zOrder = ent.Minimap_GetZOrder()
	entity viewPlayer = GetLocalViewPlayer()

	int drawType = RUI_DRAW_WORLD
	if ( screen == file.mapTopo )
		drawType = FULLMAP_RUI_DRAW_LAYER

	var rui = RuiCreate( minimapAsset, screen, drawType, FULLMAP_Z_BASE + zOrder )
	file.inWorldMinimapDeathFieldRui = rui
	asset mapImage = Minimap_GetAssetForKey( "minimap" )

	RuiSetImage( rui, "mapImage", mapImage )
	RuiSetImage( rui, "mapBgTileImage", GetMinimapBackgroundTileImage() )

	RuiSetFloat3( rui, "mapCorner", <file.mapCornerX, file.mapCornerY, 0.0> )
	RuiSetFloat( rui, "mapScale", file.mapScale )
	RuiTrackFloat2( rui, "zoomPos", null, RUI_TRACK_BIG_MAP_ZOOM_ANCHOR )
	RuiTrackFloat( rui, "zoomFactor", null, RUI_TRACK_BIG_MAP_ZOOM_SCALE )
	RuiTrackFloat3( rui, "objectPos", ent, RUI_TRACK_ABSORIGIN_FOLLOW )
	RuiTrackInt( rui, "objectFlags", ent, RUI_TRACK_MINIMAP_FLAGS )
	RuiSetFloat( rui, "displayDist", max( file.threatMaxDist, 2200 ) )
	RuiSetBool( rui, "hudVersion", screen == file.mapTopo )

	RuiSetFloat( rui, "radiusScale", SURVIVAL_MINIMAP_RING_SCALE )
	FullMap_SetDeathFieldRadius( SURVIVAL_GetDeathFieldCurrentRadius() )

	Fullmap_AddRui( rui )

	OnThreadEnd(
		function() : ( rui )
		{
			Fullmap_RemoveRui( rui )
			RuiDestroy( rui )
			file.inWorldMinimapDeathFieldRui = null
		}
	)

	ent.EndSignal( "OnDestroy" )
	entity clientEnt = GetClientEntFromTopo(screen)
	if ( clientEnt != null )
		clientEnt.EndSignal( "OnDestroy" )

	ent.WaitSignal( "OnDestroy" )
}


void function FullMap_SetDeathFieldRadius( float radius )
{
	if ( file.inWorldMinimapDeathFieldRui == null )
		return

	RuiSetFloat( file.inWorldMinimapDeathFieldRui, "objectRadius", radius / SURVIVAL_MINIMAP_RING_SCALE )
}


void function AddInWorldMinimapObjectInternal( entity ent, var screen, asset defaultIcon = $"", asset clampedDefaultIcon = $"", vector iconScale = <1.0,1.0,0.0>, vector iconColor = <1, 1, 1> )
{
	entity viewPlayer = GetLocalViewPlayer()
	bool isNPCTitan = ent.IsNPC() && ent.IsTitan()
	bool isPetTitan = ent == viewPlayer.GetPetTitan()
	bool isLocalPlayer = ent == viewPlayer
	int customState = ent.Minimap_GetCustomState()
	asset minimapAsset = FULLMAP_OBJECT_RUI
	if ( ent.IsPlayer() )
	{
		minimapAsset = $"ui/in_world_minimap_player.rpak"
	}

	int zOrder = ent.Minimap_GetZOrder()

	int drawType = RUI_DRAW_WORLD
	if ( screen == file.mapTopo )
		drawType = FULLMAP_RUI_DRAW_LAYER

	var rui = RuiCreate( minimapAsset, screen, drawType, FULLMAP_Z_BASE + zOrder )

	//RuiTrackGameTime( rui, "lastFireTime", ent, RUI_TRACK_LAST_FIRED_TIME )

	RuiSetFloat3( rui, "mapCorner", <file.mapCornerX, file.mapCornerY, 0.0> )
	RuiSetFloat( rui, "mapScale", file.mapScale )
	RuiTrackFloat2( rui, "zoomPos", null, RUI_TRACK_BIG_MAP_ZOOM_ANCHOR )
	RuiTrackFloat( rui, "zoomFactor", null, RUI_TRACK_BIG_MAP_ZOOM_SCALE )

	RuiTrackFloat3( rui, "objectPos", ent, RUI_TRACK_ABSORIGIN_FOLLOW )
	RuiTrackFloat3( rui, "objectAngles", ent, RUI_TRACK_EYEANGLES_FOLLOW )
	RuiTrackInt( rui, "objectFlags", ent, RUI_TRACK_MINIMAP_FLAGS )
	RuiTrackInt( rui, "customState", ent, RUI_TRACK_MINIMAP_CUSTOM_STATE )
	RuiSetFloat( rui, "displayDist", max( file.threatMaxDist, 2200 ) )
	RuiSetFloat( rui, "iconBlend", 1.0 )
	RuiSetFloat( rui, "iconPremul", 0.0 )
	RuiSetFloat2( rui, "iconScale", ent.IsTitan() ? <1.5,1.5,0.0> : <2.0,2.0,0.0> )
	RuiSetBool( rui, "hudVersion", screen == file.mapTopo )

	#if !MP_PVEMODE
	if ( ent.IsPlayer() )
		RuiTrackInt( rui, "teamMemberIndex", ent, RUI_TRACK_PLAYER_TEAM_MEMBER_INDEX )
	#endif

	#if MP_PVEMODE
	if ( ent.IsPlayer() )
		RuiTrackInt( rui, "squadID", ent, RUI_TRACK_SQUADID )
	#endif //MP_PVEMODE

	if ( isLocalPlayer )
	{
		RuiSetBool( rui, "isLocalPlayer", isLocalPlayer )
	}

	if ( !ent.IsPlayer() )
	{
		if ( isNPCTitan )
		{
			// RuiSetImage( rui, "defaultIcon", $"" )
			// RuiSetImage( rui, "clampedDefaultIcon", $"" )
		}
		else
		{
			RuiSetImage( rui, "defaultIcon", defaultIcon )
			RuiSetImage( rui, "clampedDefaultIcon", clampedDefaultIcon )
			RuiSetFloat2( rui, "iconScale", iconScale )
			RuiSetFloat3( rui, "iconColor", iconColor )
		}
	}

	Fullmap_AddRui( rui )

	OnThreadEnd(
		function() : ( rui )
		{
			Fullmap_RemoveRui( rui )
			RuiDestroy( rui )
		}
	)

	ent.EndSignal( "OnDestroy" )
	entity clientEnt = GetClientEntFromTopo(screen)
	if ( clientEnt != null )
		clientEnt.EndSignal( "OnDestroy" )

	if ( ent.IsPlayer() )
	{
		while ( IsValid( ent ) )
		{
			WaitSignal( ent, "SettingsChanged", "OnDeath" )
			RuiSetFloat2( rui, "iconScale", ent.IsTitan() ? <1.0,1.0,0.0> : <2.0,2.0,0.0> )
		}
	}
	else
	{
		ent.WaitSignal( "OnDestroy" )
	}
}


void function MinimapPackage_PlayerInit( entity ent, var rui )
{
	RuiTrackGameTime( rui, "lastFireTime", ent, RUI_TRACK_LAST_FIRED_TIME )
	if ( Is2TeamPvPGame() )
		//JFS: Too much work to get FFA to work correctly with Minimap logic, so disabling it for FFA
	{
		RuiTrackFloat( rui, "sonarDetectedFrac", ent, RUI_TRACK_STATUS_EFFECT_SEVERITY, eStatusEffect.sonar_detected )
		RuiTrackFloat( rui, "maphackDetectedFrac", ent, RUI_TRACK_STATUS_EFFECT_SEVERITY, eStatusEffect.maphack_detected )
	}
}


void function AddMinimapLabel( string title, float xPos, float yPos, float width = 200, float scale = 1.0 )
{
	foreach ( topo in file.minimapTopos )
	{
		int drawType = RUI_DRAW_WORLD
		int sort = FULLMAP_Z_BASE
		if ( topo == file.mapTopo )
		{
			drawType = FULLMAP_RUI_DRAW_LAYER
			sort = FULLMAP_Z_BASE + 20
		}

		var rui = RuiCreate( $"ui/in_world_minimap_label.rpak", topo, drawType, sort )
		RuiSetString( rui, "title", title )
		RuiSetFloat2( rui, "pos", <xPos, yPos, 0> )
		RuiTrackFloat2( rui, "zoomPos", null, RUI_TRACK_BIG_MAP_ZOOM_ANCHOR )
		RuiTrackFloat( rui, "zoomFactor", null, RUI_TRACK_BIG_MAP_ZOOM_SCALE )
		RuiSetFloat( rui, "width", width )
		RuiSetFloat( rui, "scale", scale )
		RuiSetBool( rui, "hudVersion", topo == file.mapTopo )

		if ( topo != file.mapTopo )
		{
			thread CleanupRuiOnTopoDestroy( rui, topo )
		}

		if ( topo == file.mapTopo )
			Fullmap_AddRui( rui )
	}
}


void function CleanupRuiOnTopoDestroy( var rui, var topo )
{
	entity clientEnt = GetClientEntFromTopo(topo)
	if ( clientEnt != null )
		clientEnt.EndSignal( "OnDestroy" )

	OnThreadEnd(
		function () : ( rui )
		{
			Fullmap_RemoveRui( rui )
		}
	)

	WaitForever()
}


void function AllowSuperHint( entity player )
{
	file.superHintAllowed = true
}


void function Survival_OnPlayerClassChanged( entity player )
{
	if ( file.pilotRui == null )
		return

	if ( player != GetLocalViewPlayer() )
		return

	if ( player.IsTitan() )
	{
		if ( file.playerState != "titan" )
		{
			ResetInventoryMenu( player )
			file.playerState = "titan"
		}
	}
	else
	{
		bool resetInventory = false

		if ( file.playerState != "pilot" )
		{
			resetInventory = true
			file.playerState = "pilot"
		}

		if ( resetInventory )
		{
			ResetInventoryMenu( player )
		}

		bool isReady = LoadoutSlot_IsReady( ToEHI( player ), Loadout_CharacterClass() )
		if ( isReady )
		{
			thread InitSurvivalHealthBar()
		}
	}

	if ( player == GetLocalClientPlayer() )
	{
		thread PeriodicHealHint()
		thread TrackAmmoPool( player )
		thread TrackPrimaryWeapon( player )
		thread TrackATWeaponSlot( player )
		if ( file.pilotRui != null )
			thread TrackPrimaryWeaponEnabled( player, file.pilotRui, "Sur_EndTrackPrimary" )
	}

	ServerCallback_ClearHints()
}


void function OnPropDynamicCreated( entity prop )
{
	if ( prop.GetTargetName() == "fakeButton" )
		AddEntityCallback_GetUseEntOverrideText( prop, DroppodButtonUseTextOverride )
}


void function OnPropCreated( entity prop )
{
	if ( prop.GetSurvivalInt() < 0 )
	{
		PROTO_OnContainerCreated( prop )
		return
	}
}


string function DroppodButtonUseTextOverride( entity prop )
{
	if ( GetLocalViewPlayer().GetParent() != null )
		return " "
	return ""
}


void function OnPlayerVehicleCreated( entity ent )
{
	AddInWorldMinimapObject( ent )
}


void function OpenSurvivalMenu()
{
	entity player = GetLocalClientPlayer()

	if ( !IsAlive( player ) || player != GetLocalClientPlayer() )
	{
		RunUIScript( "ServerCallback_OpenSurvivalExitMenu", false )
	}
	else
	{
		PROTO_OpenInventoryOrSpecifiedMenu( player )
	}
}


void function PROTO_OpenInventoryOrSpecifiedMenu( entity player )
{
	HideScoreboard()
	OpenSurvivalInventory( player )
}


void function OpenQuickSwap( entity player )
{
	thread TryOpenQuickSwap()
}


void function TrackATWeaponSlot( entity player )
{
	if ( player != GetLocalViewPlayer() )
		return

	if ( player != GetLocalClientPlayer() )
		return

	player.Signal( "Sur_EndTrackOffhandWeaponSlot0" )
	player.EndSignal( "Sur_EndTrackOffhandWeaponSlot0" )
	player.EndSignal( "OnDeath" )

	entity oldWeapon = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_ANTI_TITAN )
	int oldAmmo = 0

	bool firstRun = true

	while ( IsAlive( player ) )
	{
		int ammo = 0
		entity weapon = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_ANTI_TITAN )

		if ( !player.IsTitan() )
		{
			if ( weapon != null )
			{
				ammo = weapon.GetWeaponPrimaryClipCount()
			}
		}
		else
		{
			weapon = null
		}

		if ( oldWeapon != weapon || ammo != oldAmmo || firstRun )
		{
			firstRun = false

			ResetInventoryMenu( player )

			if ( weapon != null )
			{
				RuiSetImage( file.dpadMenuRui, "ordnanceIcon", weapon.GetWeaponSettingAsset( eWeaponVar.hud_icon ) )
				RuiSetInt( file.dpadMenuRui, "ordnanceCount", ammo )
				RuiSetBool( file.dpadMenuRui, "ordnanceIsMelee", weapon.GetWeaponSettingBool( eWeaponVar.attack_button_presses_melee ) )
			}
			else
			{
				RuiSetInt( file.dpadMenuRui, "ordnanceCount", 0 )
			}

			oldWeapon = weapon
			oldAmmo = ammo
		}
		WaitFrame()
	}
}


void function PeriodicHealHint()
{
	while ( IsAlive( GetLocalClientPlayer() ) )
	{
		wait 30.0
		UpdateHealHint( GetLocalClientPlayer() )
	}
}


void function TrackAmmoPool( entity player )
{
	if ( player != GetLocalViewPlayer() )
		return

	if ( player != GetLocalClientPlayer() )
		return

	player.Signal( "Sur_EndTrackAmmo" )
	player.EndSignal( "Sur_EndTrackAmmo" )
	player.EndSignal( "OnDeath" )

	table<string, int> oldAmmo
	foreach ( ammoRef, value in eAmmoPoolType )
	{
		oldAmmo[ ammoRef ] <- 0
	}


	while ( IsAlive( player ) )
	{
		bool resetAmmo = false
		foreach ( ammoRef, value in eAmmoPoolType )
		{
			int ammo = player.AmmoPool_GetCount( value )

			if ( ammo != oldAmmo[ ammoRef ] )
			{
				resetAmmo = true
				oldAmmo[ ammoRef ] = ammo
			}
		}

		if ( resetAmmo )
			ResetInventoryMenu( player )
		WaitFrame()
	}
}


void function TrackPrimaryWeapon( entity player )
{
	if ( player != GetLocalViewPlayer() )
		return

	if ( player != GetLocalClientPlayer() )
		return

	player.Signal( "Sur_EndTrackPrimary" )
	player.EndSignal( "Sur_EndTrackPrimary" )
	player.EndSignal( "OnDeath" )

	entity oldWeapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
	int oldBitField = 0

	if ( oldWeapon != null && oldWeapon.IsWeaponOffhand() )
		oldWeapon = null

	bool firstRun = true

	while ( IsAlive( player ) )
	{
		entity weapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
		if ( IsValid( weapon ) && weapon.IsWeaponMelee() )
		{
			WaitFrame()
			continue
		}

		int bitField = 0

		if ( !player.IsTitan() )
		{
			if ( player.GetWeaponDisableFlags() != WEAPON_DISABLE_FLAGS_ALL )
			{
				if ( weapon != null && weapon.IsWeaponOffhand() )
					weapon = IsValid( oldWeapon ) ? oldWeapon : null
			}
			if ( weapon )
				bitField = weapon.GetModBitField()
		}

		if ( ( weapon != oldWeapon || bitField != oldBitField || firstRun) )
		{
			firstRun = false

			if ( IsValid( weapon ) && weapon.GetWeaponType() != WT_ANTITITAN )
				file.lastPrimaryWeapon = weapon
			else
				file.lastPrimaryWeapon = null

			ServerCallback_ClearHints()

			if ( IsValid( weapon ) )
			{
				if ( weapon.GetWeaponType() == WT_ANTITITAN && SURVIVAL_GetAllPlayerOrdnance( player ).len() > 1 )
					ServerCallback_SurvivalHint( eSurvivalHints.ORDNANCE )
			}

			UpdateActiveLootPings()
			ResetInventoryMenu( player )
			oldWeapon = weapon
			oldBitField = bitField
		}
		WaitFrame()
	}
}


void function ServerCallback_SurvivalHint( int hintType )
{
	string hintString
	float duration = 8.0

	switch ( hintType )
	{
		case eSurvivalHints.EQUIP:
			hintString = "#SURVIVAL_ATTACH_HINT"
		break

		case eSurvivalHints.ORDNANCE:
			duration = 2.0
			hintString = "#SURVIVAL_ORDNANCE_HINT"
		break

		default:
			return
	}
	AddPlayerHint( duration, 0.5, $"", hintString )
}


void function ServerCallback_ClearHints()
{
	HidePlayerHint( "#SURVIVAL_MAP_HINT" )
	HidePlayerHint( "#SURVIVAL_ATTACH_HINT" )
	HidePlayerHint( "#SURVIVAL_DROPPOD_LAUNCH_HINT" )
	HidePlayerHint( "#SURVIVAL_DROPPOD_STEER_HINT" )
	HidePlayerHint( "#SURVIVAL_DROPPOD_ACTIVATE_HINT" )
	HidePlayerHint( "#SURVIVAL_TITAN_HOVER_HINT" )
}


void function SurvivalTitanHoverHint()
{
	ServerCallback_ClearHints()
	wait 4
	AddPlayerHint( 6.0, 0.5, $"", "#SURVIVAL_TITAN_HOVER_HINT" )
}


vector function NormalizeWorldPos( vector pos, float zoomFactor = 1.0 )
{
	float mapScaleTweak = max( file.mapScale * OVERVIEW_MAP_SIZE, 1 )
	vector normalizedPos = (pos - <file.mapCornerX, file.mapCornerY, 0>) / mapScaleTweak
	normalizedPos = <normalizedPos.x, -1 * normalizedPos.y, 0> * zoomFactor
	return normalizedPos
}


vector function ConvertNormalizedPosToWorldPos( vector normalizedPos, float zoomFactor = 1.0 )
{
	vector fixedPos = <normalizedPos.x, -1 * normalizedPos.y, 0> / zoomFactor
	float mapScaleTweak = max( file.mapScale * OVERVIEW_MAP_SIZE, 1 )
	vector pos = (fixedPos * mapScaleTweak) + <file.mapCornerX, file.mapCornerY, 0>
	return pos
}


// TODO: Need to rethink the way all this works. It doesn't consider keybinds so it's going to be impossible to block any player ability that can be rebound.
bool function Survival_HandleKeyInput( int key )
{
	#if R5DEV
	if ( MapDevCheatsAreActive() )
	{
		switch ( key )
		{
			case BUTTON_A:
			case MOUSE_LEFT:
				vector worldPos = ConvertNormalizedPosToWorldPos( GetMapNormalizedAimCoordinate() )
				GetLocalClientPlayer().ClientCommand( format( "GoToMapPoint %.3f %.3f %.3f", worldPos.x, worldPos.y, worldPos.z ) )
				ScreenFlash( 0.0, 0.0, 0.0, 0.1, 0.5 )
				EmitSoundOnEntity( GetLocalViewPlayer(), "dropship_mp_epilogue_warpout" )
				delaythread( 0.25 ) HideScoreboard()
				return true

			case BUTTON_B:
			case MOUSE_RIGHT:
				vector worldPos = ConvertNormalizedPosToWorldPos( GetMapNormalizedAimCoordinate() )
				GetLocalClientPlayer().ClientCommand( format( "UpdateCirclePos %.3f %.3f %.3f", worldPos.x, worldPos.y, worldPos.z ) )
				delaythread( 0.25 ) HideScoreboard()
				return true
		}

		return false
	}
	#endif

	bool pressedPing = false
	bool swallowInput = false
	switch ( key )
	{
		case MOUSE_WHEEL_UP:
			ChangeFullMapZoomFactor( FULLMAP_ZOOM_SPEED_MOUSE )
			swallowInput = true
			break

		case MOUSE_WHEEL_DOWN:
			ChangeFullMapZoomFactor( -FULLMAP_ZOOM_SPEED_MOUSE )
			swallowInput = true
			break

		case BUTTON_TRIGGER_RIGHT:
			ChangeFullMapZoomFactor( FULLMAP_ZOOM_SPEED_CONTROLLER )
			swallowInput = true
			break

		case BUTTON_TRIGGER_LEFT:
			ChangeFullMapZoomFactor( -FULLMAP_ZOOM_SPEED_CONTROLLER )
			swallowInput = true
			break

		case BUTTON_SHOULDER_RIGHT:
		case MOUSE_LEFT:
			pressedPing = true
			break

		case MOUSE_RIGHT:
		case BUTTON_X:
			Ping_ClearMapWaypoint( GetLocalClientPlayer() )
			swallowInput = true
			break

		case BUTTON_B:
			HideScoreboard()
			swallowInput = true
			break

		case MOUSE_MIDDLE:
		case BUTTON_STICK_RIGHT:
		case BUTTON_Y:
			swallowInput = true
			break
	}

	if ( pressedPing )
		printt( "pressedPing", key )

	if ( ButtonIsBoundToAction( key, "use" ) )
		return true

	if ( ButtonIsBoundToAction( key, "+jump" ) )
		return true

	if ( ButtonIsBoundToAction( key, "offhand1" ) )
		return true

	if ( ButtonIsBoundToAction( key, "offhand4" ) )
		return true

	if ( (!IsControllerModeActive() && ButtonIsBoundToPing( key )) || pressedPing )
	{
		vector worldPos = ConvertNormalizedPosToWorldPos( GetMapNormalizedAimCoordinate() )
		Ping_SetMapWaypoint( GetLocalClientPlayer(), worldPos )
		swallowInput = true
	}

	return swallowInput
}


vector function SmoothInput( vector vecIn )
{
	const float DEADZONE = 0.05

	float len = min( Length2D( vecIn ), 1.0 )
	if ( len < DEADZONE )
		return <0,0,0>

	float factor = (len * len)
	return (vecIn * factor)
}


vector function GetMapNormalizedAimCoordinate()
{
	float zoomScreenWidth = 1.0 / file.fullmapZoomFactor

	float zoomAreaUpperLeftFrac = 1.0 - zoomScreenWidth
	vector zoomAreaUpperLeft = file.fullmapZoomPos * zoomAreaUpperLeftFrac
	return zoomAreaUpperLeft + file.fullmapAimPos * zoomScreenWidth
}


bool function Survival_HandleViewInput( float x, float y )
{
	if ( IsControllerModeActive() )
		return false

	//printt( "mouse:", x, y, "file.fullmapZoomPos:", file.fullmapZoomPos )

	vector oldAimPos = GetMapNormalizedAimCoordinate()

	file.fullmapAimPos += <x, -y, 0> * 0.001
	vector desiredFullMapPos = file.fullmapAimPos

	if ( InputIsButtonDown( MOUSE_RIGHT ) )// || InputIsButtonDown( MOUSE_MIDDLE ) )
	{
		vector newAimPos = GetMapNormalizedAimCoordinate()

		vector delta = oldAimPos - newAimPos

		float zoomScreenWidth = 1.0 / file.fullmapZoomFactor
		float zoomAreaUpperLeftFrac = 1.0 - zoomScreenWidth

		if ( zoomAreaUpperLeftFrac > 0 )
			file.fullmapZoomPos += delta / zoomAreaUpperLeftFrac
	}

	file.fullmapAimPos = <clamp( file.fullmapAimPos.x, 0, 0.99999 ), clamp( file.fullmapAimPos.y, 0, 0.99999 ), 0>
	vector clampDiff = desiredFullMapPos - file.fullmapAimPos
	if ( file.fullmapZoomFactor > 0 )
		file.fullmapZoomPos += clampDiff / file.fullmapZoomFactor

	file.fullmapZoomPos = <clamp( file.fullmapZoomPos.x, 0, 0.99999 ), clamp( file.fullmapZoomPos.y, 0, 0.99999 ), 0>
	SetBigMapZoomAnchor( file.fullmapZoomPos.x, file.fullmapZoomPos.y )

	if ( IsValid( file.mapAimRui ) )
		RuiSetFloat2( file.mapAimRui, "pos", file.fullmapAimPos )

	return true
}


bool s_inputDebounceIsActive = false
bool function Survival_HandleMoveInput( float x, float y )
{
	if ( !IsValid( file.mapAimRui ) )
		return false
	if ( !IsControllerModeActive() )
		return false

	if ( s_inputDebounceIsActive )
	{
		const float DEBOUNCE_THRESHOLD = 0.4
		float len = min( Length2D( <x, y, 0> ), 1.0 )
		if ( len > DEBOUNCE_THRESHOLD )
			return true
		s_inputDebounceIsActive = false
	}

	vector smoothed = SmoothInput( <x, y, 0> )
	file.fullmapAimPos += <smoothed.x, (-1.0 * smoothed.y), 0> * 0.01 / file.fullmapZoomFactor
	file.fullmapAimPos = <clamp( file.fullmapAimPos.x, 0, 0.99999 ), clamp( file.fullmapAimPos.y, 0, 0.99999 ), 0>
	file.fullmapZoomPos = file.fullmapAimPos
	RuiSetFloat2( file.mapAimRui, "pos", file.fullmapAimPos )
	SetBigMapZoomAnchor( file.fullmapZoomPos.x, file.fullmapZoomPos.y )
	return true
}


void function Sur_Cl_PickLoadout( entity player )
{

}


void function Survival_WaitForPlayers()
{
	file.cameFromWaitingForPlayersState = true
	SetDpadMenuVisible()
	SetMapSetting_FogEnabled( true )
	Minimap_UpdateMinimapVisibility( GetLocalClientPlayer() )
}


void function RemoveBlackScreen()
{
	if ( file.waitingForPlayersBlackScreenRui != null )
		RuiDestroyIfAlive( file.waitingForPlayersBlackScreenRui )
}

void function Survival_RunCharacterSelection()
{
	SetDpadMenuHidden()
	RemoveBlackScreen()
	thread Survival_RunCharacterSelection_Thread()
}


void function Survival_RunCharacterSelection_Thread()
{
	FlagWait( "ClientInitComplete" )

	bool characterSelectEnabled = Survival_CharacterSelectEnabled()
	if ( !characterSelectEnabled )
		return

	while( GetGlobalNetBool( "characterSelectionReady" ) == false )
		WaitFrame()

	entity player = GetLocalClientPlayer()
	if ( IsValid( player ) )
	{
		EndSignal( player, "OnDestroy" )
		while( player.GetPlayerNetInt( "characterSelectLockstepPlayerIndex" ) < 0 )
			WaitFrame()
	}

	//wait ScreenCoverTransition( Time() + CHARACTER_SELECT_OPEN_TRANSITION_DURATION )

	// Play sound
	if ( file.cameFromWaitingForPlayersState )
//		EmitSoundOnEntity( GetLocalViewPlayer(), "menu_email_sent" )

	HideMapRui()

	// We first need to close the menu before opening it here because the player may already have a browse mode version of the menu open
	CloseCharacterSelectNewMenu()
	WaitFrame()
	OpenCharacterSelectNewMenu()

	while( Time() < GetGlobalNetTime( "squadPresentationStartTime" ) )
		WaitFrame()

	thread DoSquadCardsPresentation()

	while( Time() < GetGlobalNetTime( "championSquadPresentationStartTime" ) )
		WaitFrame()

	thread DoChampionSquadCardsPresentation()
}


void function OnGamestateChanged()
{
	int gamestate = GetGameState()

	var gamestateRui = ClGameState_GetRui()
	if ( gamestateRui == null )
		return

	bool gamestateIsPlaying = GamePlaying()
	bool gamestateWaitingForPlayers = GetGameState() == eGameState.WaitingForPlayers
	RuiSetBool( gamestateRui, "gamestateIsPlaying", gamestateIsPlaying )
	RuiSetBool( gamestateRui, "gamestateWaitingForPlayers", gamestateWaitingForPlayers )
	RuiSetInt( gamestateRui, "gamestate", gamestate )

	if ( file.pilotRui != null )
	{
		RuiSetBool( file.pilotRui, "gamestateIsPlaying", gamestateIsPlaying )
		RuiSetBool( file.dpadMenuRui, "gamestateIsPlaying", gamestateIsPlaying )

		RuiSetBool( file.pilotRui, "gamestateWaitingForPlayers", gamestateWaitingForPlayers )
		RuiSetBool( file.dpadMenuRui, "gamestateWaitingForPlayers", gamestateWaitingForPlayers )
	}
}


void function OnGamestatePrematch()
{
	SetDpadMenuHidden()
	RemoveBlackScreen()
	Minimap_UpdateMinimapVisibility( GetLocalClientPlayer() )
}


void function SetDpadMenuVisible()
{
	RuiSetBool( file.dpadMenuRui, "isVisible", GetHudDefaultVisibility() )
}


void function SetDpadMenuHidden()
{
	RuiSetBool( file.dpadMenuRui, "isVisible", false )
}


void function Survival_ClearHints()
{
	UpdateHealHint( GetLocalViewPlayer() )
}


void function ServerCallback_PlayerBootsOnGround()
{
	NotifyDropSequence( false )

	Signal( GetLocalClientPlayer(), "DroppodLanded" )

	array<entity> keysToClear
	foreach ( topo in file.minimapTopos )
	{
		if ( topo != file.mapTopo )
		{
			entity ent = GetClientEntFromTopo( topo )
			ent.Signal( "OnDestroy" )
			RuiTopology_Destroy( topo )
			keysToClear.append(ent)
		}
	}
	foreach ( ent in keysToClear )
	{
		delete file.minimapTopoClientEnt[ ent ]
		ent.Destroy()
	}
	file.minimapTopos.clear()
	file.minimapTopos.append( file.mapTopo )

	DoF_LerpFarDepthToDefault( 0.5 )
	DoF_LerpNearDepthToDefault( 0.5 )
	GetLocalClientPlayer().ClientCommand( "dof_variable_blur 0" )
}


void function ServerCallback_AnnounceCircleClosing()
{
	float duration = 4.0
	AnnouncementData announcement = Announcement_Create( Localize( "#SURVIVAL_CIRCLE_STARTING" ) )
	Announcement_SetSoundAlias( announcement, CIRCLE_CLOSING_SOUND )
	Announcement_SetStyle( announcement, ANNOUNCEMENT_STYLE_CIRCLE_WARNING )
	Announcement_SetPurge( announcement, true )
	Announcement_SetOptionalTextArgsArray( announcement, [ "true" ] )
	Announcement_SetPriority( announcement, 200 ) //Be higher priority than Titanfall ready indicator etc
	announcement.duration = duration
	AnnouncementFromClass( GetLocalViewPlayer(), announcement )
}


void function Sur_OnBleedoutStarted( entity victim, float endTime )
{
	if ( victim != GetLocalViewPlayer() )
		return

	RuiSetGameTime( file.pilotRui, "bleedoutEndTime", endTime )
	RuiSetBool( file.pilotRui, "isDowned", true )

	if ( victim == GetLocalClientPlayer() )
		RunUIScript( "TryCloseSurvivalInventory", null )
}


void function Sur_OnBleedoutEnded( entity victim )
{
	if ( victim != GetLocalViewPlayer() )
		return

	RuiSetGameTime( file.pilotRui, "bleedoutEndTime", 0.0 )
	RuiSetBool( file.pilotRui, "isDowned", false )
}


void function SURVIVAL_AddMinimapLevelLabel( string name, float x, float y, float scale = 1.0, float width = 200 )
{
	MinimapLabelStruct s
	s.name = name
	s.pos = <x,y,0>
	s.scale = scale
	s.width = width
	file.minimapLabels.append( s )
}


bool function DontCreateRuisForEnemies( entity ent )
{
	if ( ent.IsPlayer() || ent.IsNPC() )
	{
		if ( ent.GetTeam() != GetLocalViewPlayer().GetTeam() )
		{
			return false
		}
	}

	return true
}


void function MarkDpadAsBlocked( bool isBlocked )
{
	if ( file.dpadMenuRui != null )
		RuiSetBool( file.dpadMenuRui, "dpadNotAvailable", isBlocked )
}


void function OnTrackTitanTeam( entity titan )
{
	thread OnTrackTitanTeamInternal( titan )
}


void function OnTrackTitanTeamInternal( entity titan )
{
	titan.SetDoDestroyCallback( true )

	EndSignal( titan, "OnDestroy" )

	int team = titan.GetTeam()

	while ( IsValid( titan ) )
	{
		if ( team != titan.GetTeam() )
		{
			team = titan.GetTeam()
			Signal( titan, "SettingsChanged" )
		}
		wait 0.5
	}
}


entity function GetClientEntFromTopo( var screen )
{
	entity entToReturn
	foreach ( ent, topo in file.minimapTopoClientEnt )
	{
		if ( topo == screen )
		{
			entToReturn = ent
		}
	}

	return entToReturn
}


var function FullMap_CommonAdd( asset ruiAsset, int zOrder = 50 )
{
	if ( !file.mapTopo )
		return null
	var rui = RuiCreate( ruiAsset, file.mapTopo, FULLMAP_RUI_DRAW_LAYER, FULLMAP_Z_BASE + zOrder )

	RuiSetFloat3( rui, "mapCorner", <file.mapCornerX, file.mapCornerY, 0> )
	RuiSetFloat( rui, "mapScale", file.mapScale )
	RuiTrackFloat2( rui, "zoomPos", null, RUI_TRACK_BIG_MAP_ZOOM_ANCHOR )
	RuiTrackFloat( rui, "zoomFactor", null, RUI_TRACK_BIG_MAP_ZOOM_SCALE )

	if ( ruiAsset == FULLMAP_OBJECT_RUI )
	{
		RuiSetBool( rui, "hudVersion", true )
	}

	return rui
}


void function FullMap_CommonTrackEntOrigin( var rui, entity ent, bool doTrackAngles )
{
	RuiTrackFloat3( rui, "objectPos", ent, RUI_TRACK_ABSORIGIN_FOLLOW )
	if ( doTrackAngles )
		RuiTrackFloat3( rui, "objectAngles", ent, RUI_TRACK_EYEANGLES_FOLLOW )
}


var function FullMap_Ping_( float radius, vector color, float pulseDuration, float lifeTime, bool reverse )
{
	var rui = FullMap_CommonAdd( $"ui/in_world_minimap_ping.rpak" )

	RuiSetFloat3( rui, "objColor", SrgbToLinear( color ) )
	RuiSetFloat( rui, "objectRadius", max( radius, 1000 ) )
	RuiSetGameTime( rui, "startTime", Time() )
	RuiSetFloat( rui, "pulseDuration", pulseDuration )
	RuiSetBool( rui, "reverse", reverse )
	RuiSetImage( rui, "marker", $"" )

	Fullmap_AddRui( rui )

	if ( lifeTime > 0 )
	{
		RuiSetFloat( rui, "lifeTime", lifeTime )
		delaythread( lifeTime - (1/60.0) ) Fullmap_RemoveRui( rui )
	}

	return rui
}


var function FullMap_PingLocation( vector origin, float radius, vector color, float pulseDuration, float lifeTime = -1, bool reverse = false )
{
	if ( !file.mapTopo )
		return null

	var rui = FullMap_Ping_( radius, color, pulseDuration, lifeTime, reverse )
	RuiSetFloat3( rui, "objectPos", origin )
	RuiSetFloat3( rui, "objectAngles", <0,0,0> )
	return rui
}


var function FullMap_PingEntity( entity ent, float radius, vector color, float pulseDuration, float lifeTime = -1, bool reverse = false )
{
	if ( !file.mapTopo )
		return null

	var rui = FullMap_Ping_( radius, color, pulseDuration, lifeTime, reverse )
	FullMap_CommonTrackEntOrigin( rui, ent, false )
	return rui
}


////////////////////////////////////
////////////////////////////////////
//// Loot container prototyping ////
////////////////////////////////////
////////////////////////////////////
struct PROTO_LootContainerState
{
	entity container
	bool isLit = false
	entity light = null
}

bool proto_isContainerThinkRunning = false
array<PROTO_LootContainerState> proto_lootContainerStateList = []
void function PROTO_OnContainerCreated( entity container )
{
	PROTO_LootContainerState state
	state.container = container
	proto_lootContainerStateList.append( state )

	if ( !proto_isContainerThinkRunning )
	{
		thread PROTO_ContainersThink()
	}

	//return "Tap %use% to open"
}


void function PROTO_ContainersThink()
{
	proto_isContainerThinkRunning = true
	while( true )
	{
		if ( proto_lootContainerStateList.len() == 0 )
		{
			proto_isContainerThinkRunning = false
			return
		}

		entity player = GetLocalViewPlayer()

		array<int> stateIndexesToRemove = []
		foreach( int stateIndex, PROTO_LootContainerState state in proto_lootContainerStateList )
		{
			if ( !IsValid( state.container ) )
			{
				stateIndexesToRemove.append( stateIndex )
				continue
			}

			float dist             = Distance2D( state.container.GetWorldSpaceCenter(), player.GetWorldSpaceCenter() )
			float fullOnPoint = 100.0
			float offPoint = 120.0
			bool shouldBecomeLit   = (dist < offPoint)
			//bool shouldBecomeUnlit = (dist > offPoint)

			if ( shouldBecomeLit )
			{
				if ( !state.isLit )
				{
					state.light = CreateClientSideDynamicLight( state.container.GetWorldSpaceCenter(), <0, 0, 0>, <0, 0, 0>, 0.0 )
					//DebugDrawMark( state.container.GetWorldSpaceCenter() + <20, 20, 20>, 80.0, [255, 255, 0], true, 5.0 )
					state.isLit = true
				}
			}
			else// if ( shouldBecomeUnlit )
			{
				if ( state.isLit )
				{
					state.light.Destroy()
					state.light = null
					state.isLit = false
				}
			}

			if ( state.isLit )
			{
				vector lightCol = <0, 1, 1>
				float brightness = GraphCapped( dist, fullOnPoint, offPoint, 1.0, 0.0 )
				state.light.SetLightColor( lightCol * brightness )
				state.light.SetLightRadius( 220.0 )
			}
		}

		for ( int i = stateIndexesToRemove.len() - 1; i >= 0; i-- )
		{
			PROTO_LootContainerState state = proto_lootContainerStateList[ stateIndexesToRemove[i] ]
			if ( state.light != null )
			{
				state.light.Destroy()
			}
			proto_lootContainerStateList.fastremove( stateIndexesToRemove[i] )
		}

		wait 0.1
	}
}


void function TryCycleOrdnance( entity player )
{
	printt("TryCycleOrdnance")
	if ( player == GetLocalClientPlayer() && player == GetLocalViewPlayer() )
	{
		entity weapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )

		if ( IsValid( weapon ) && player.GetWeaponDisableFlags() != WEAPON_DISABLE_FLAGS_ALL )
		{
			if ( weapon.GetWeaponType() == WT_ANTITITAN )
			{
				array<string> allOrdnance = SURVIVAL_GetAllPlayerOrdnance( player )

				if ( allOrdnance.len() > 1 )
				{
					player.ClientCommand( "Sur_SwapToNextOrdnance" )
				}
			}
		}
	}
}


void function ReloadPressed( entity player )
{
	player.Signal( "ReloadPressed" )

	if ( player != GetLocalClientPlayer() || player != GetLocalViewPlayer() )
		return

	int weaponDisableFlags = player.GetWeaponDisableFlags()
	if ( weaponDisableFlags == WEAPON_DISABLE_FLAGS_ALL )
		return

	entity weapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )

	if ( !IsValid( weapon )  )
		return

	if ( weapon.GetWeaponType() == WT_ANTITITAN )
		return

	if ( weapon.GetWeaponPrimaryClipCountMax() <= 0 || !weapon.GetWeaponSettingBool( eWeaponVar.uses_ammo_pool ) || player.AmmoPool_GetCount( weapon.GetWeaponAmmoPoolType() ) > 0 )
		return

	if ( player.IsInputCommandPressed( IN_USE ) && player.HasUsePrompt() )
		return

	NotifyReloadAttemptButNoReserveAmmo()
}


void function UsePressed( entity player )
{
	int gamepadUseType = GetConVarInt( "gamepad_use_type" )
	if ( gamepadUseType == eGamepadUseSchemeType.TAP_TO_USE_HOLD_TO_RELOAD && player == GetLocalClientPlayer() && player == GetLocalViewPlayer() )
	{
		if ( !IsPickupFlyoutValid() && !player.HasUsePrompt() )
		{
			entity weapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
			if ( IsValid( weapon ) && player.GetWeaponDisableFlags() != WEAPON_DISABLE_FLAGS_ALL )
			{
				if ( !weapon.GetWeaponSettingBool( eWeaponVar.reload_enabled ) )
					return

				if ( weapon.GetWeaponType() == WT_ANTITITAN )
				{
					array<string> allOrdnance = SURVIVAL_GetAllPlayerOrdnance( player )

					if ( allOrdnance.len() > 1 )
					{
						ServerCallback_SurvivalHint( eSurvivalHints.ORDNANCE )
					}
				}
				else if ( IsControllerModeActive() && player.AmmoPool_GetCount( weapon.GetWeaponAmmoPoolType() ) > 0 )
				{
					float lowAmmoFrac = weapon.GetWeaponSettingFloat( eWeaponVar.low_ammo_fraction )

					float weaponClipMax = float( weapon.GetWeaponPrimaryClipCountMax() )
					float currClipCount = float( weapon.GetWeaponPrimaryClipCount() )
					float ammoFrac = currClipCount / weaponClipMax

					if ( weaponClipMax > currClipCount && ammoFrac > lowAmmoFrac )
						AddPlayerHint( 2.0, 0.5, $"", "#HINT_RELOAD_TAP_TO_USE" )
				}
			}
		}
	}
}


void function ShowPlaneTube( entity ent, var topo )
{
	int drawMode = RUI_DRAW_WORLD
	if ( topo == file.mapTopo )
		drawMode = FULLMAP_RUI_DRAW_LAYER

	var rui = RuiCreate( $"ui/in_world_minimap_plane_path.rpak", topo, drawMode, FULLMAP_Z_BASE )
	RuiSetFloat3( rui, "mapCorner", <file.mapCornerX, file.mapCornerY, 0> )
	RuiSetFloat( rui, "mapScale", file.mapScale )
	RuiTrackFloat2( rui, "zoomPos", null, RUI_TRACK_BIG_MAP_ZOOM_ANCHOR )
	RuiTrackFloat( rui, "zoomFactor", null, RUI_TRACK_BIG_MAP_ZOOM_SCALE )
	RuiTrackFloat3( rui, "objectPos", ent, RUI_TRACK_ABSORIGIN_FOLLOW )
	RuiTrackFloat3( rui, "objectAngles", ent, RUI_TRACK_EYEANGLES_FOLLOW )
	RuiSetFloat( rui, "displayDist", max( file.threatMaxDist, 2200 ) )
	RuiSetBool( rui, "hudVersion", topo == file.mapTopo )

	//RuiSetFloat( rui, "tubeWidth", 1.0 )

	if ( topo == file.mapTopo )
		Fullmap_AddRui( rui )

	OnThreadEnd(
		function () : ( rui, topo )
		{
			if ( topo == file.mapTopo )
				Fullmap_RemoveRui( rui )

			RuiDestroy( rui )
		}
	)

	ent.WaitSignal( "OnDestroy" )
}


void function UpdateFallbackMatchmaking( string fallbackPlaylistName, string fallbackStatusText )
{
	if ( fallbackPlaylistName == "" )
	{
		if ( file.fallbackMMRui != null )
			RuiDestroy( file.fallbackMMRui )

		file.fallbackMMRui = null
		return
	}

	if ( file.fallbackMMRui == null )
	{
		file.fallbackMMRui = RuiCreate( $"ui/fallback_status_text.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 100 )
		RuiSetGameTime( file.fallbackMMRui, "queueStartTime", Time() )
	}

	string playlistName = Localize( GetCurrentPlaylistVarString( fallbackPlaylistName, "name" ) )

	RuiSetString( file.fallbackMMRui, "fallbackPlaylistText", playlistName )
	RuiSetString( file.fallbackMMRui, "fallbackStatusText", fallbackStatusText )
}


void function PROTO_ServerCallback_Sur_HoldForUltimate()
{
	AddPlayerHint( 4.0, 0.25, $"", "Hold %offhand4%" )
}


void function SetVictorySequenceLocation( vector position, vector angles )
{
	file.victorySequencePosition = position
	file.victorySequenceAngles = angles
}


void function ServerCallback_MatchEndAnnouncement( bool victory, int winningTeam )
{
	clGlobal.levelEnt.Signal( "SquadEliminated" )
	FlagSet( "SquadEliminated" )

	if ( victory )
	{
		ShowChampionVictoryScreen( winningTeam )
	}
}

void function ShowChampionVictoryScreen( int winningTeam )
{
	if ( file.victoryRui != null )
		return

	entity clientPlayer = GetLocalClientPlayer()

	// make sure to hide the glad card and other hud elements when we show the victory screen text.
	HideGladiatorCardSidePane( true )
	UpdateRespawnStatus( eRespawnStatus.NONE )
	UpdateDeathAndSpectatorHUD( clientPlayer, null )

	file.victoryRui = CreateFullscreenRui( $"ui/champion_screen.rpak" )
	RuiSetBool( file.victoryRui, "onWinningTeam", GetLocalClientPlayer().GetTeam() == winningTeam )

	EmitSoundOnEntity( GetLocalClientPlayer(), "UI_InGame_ChampionVictory" )
}

void function ServerCallback_ShowSquadSummary()
{
	SetSquadDataToLocalTeam()
	thread ShowSquadSummary()
}


void function ShowSquadSummary()
{
	entity player = GetLocalClientPlayer()
	EndSignal( player, "OnDestroy" )

	thread ShowRoundEndSquadResults( true )
}


void function ServerCallback_AddWinningSquadData( int index, int eHandle, int kills, int damageDealt, int survivalTime, int revivesGiven, int respawnsGiven )
{
	if ( index == -1 )
	{
		file.winnerSquadSummaryData.playerData.clear()
		file.winnerSquadSummaryData.squadPlacement = -1
		return
	}

	SquadSummaryPlayerData data
	data.eHandle = eHandle
	data.kills = kills
	data.damageDealt = damageDealt
	data.survivalTime = survivalTime
	data.revivesGiven = revivesGiven
	data.respawnsGiven = respawnsGiven
	file.winnerSquadSummaryData.playerData.append( data )
	file.winnerSquadSummaryData.squadPlacement = 1
}


SquadSummaryData function GetSquadSummaryData()
{
	return file.squadSummaryData
}

#if R5DEV
void function Dev_ShowVictorySequence()
{
	ServerCallback_AddWinningSquadData( -1, -1, 0, 0, 0, 0, 0 )
	foreach( int i, entity player in GetPlayerArrayOfTeam( GetLocalClientPlayer().GetTeam() ) )
		ServerCallback_AddWinningSquadData( i, player.GetEncodedEHandle(), 2, 1234, 600, 3, 1 )
	thread ShowVictorySequence()
}

void function Dev_AdjustVictorySequence()
{
	ServerCallback_AddWinningSquadData( -1, -1, 0, 0, 0, 0, 0 )
	foreach( int i, entity player in GetPlayerArrayOfTeam( GetLocalClientPlayer().GetTeam() ) )
		ServerCallback_AddWinningSquadData( i, player.GetEncodedEHandle(), 2, 1234, 600, 3, 1 )
	GetLocalClientPlayer().FreezeControlsOnClient()
	thread ShowVictorySequence(true)
}
#endif

void function ServerCallback_ShowWinningSquadSequence()
{
	thread ShowVictorySequence()
}


bool function IsSquadDataPersistenceEmpty()
{
	entity player = GetLocalClientPlayer()

	int maxTrackedSquadMembers = PersistenceGetArrayCount( "lastGameSquadStats" )
	for ( int i = 0 ; i < maxTrackedSquadMembers ; i++ )
	{
		int eHandle = player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].eHandle" )

		if ( eHandle > 0 )
			return false
	}
	return true
}


void function SetSquadDataToLocalTeam()
{
	entity player = GetLocalClientPlayer()

	int maxTrackedSquadMembers = PersistenceGetArrayCount( "lastGameSquadStats" )
	file.squadSummaryData.playerData.clear()
	for ( int i = 0 ; i < maxTrackedSquadMembers ; i++ )
	{
		int eHandle = player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].eHandle" )

		if ( eHandle <= 0 )
			continue

		SquadSummaryPlayerData data

		data.eHandle = eHandle
		data.kills = player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].kills" )
		data.damageDealt = player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].damageDealt" )
		data.survivalTime = player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].survivalTime" )
		data.revivesGiven = player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].revivesGiven" )
		data.respawnsGiven = player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].respawnsGiven" )

		file.squadSummaryData.playerData.append( data )
	}

	file.squadSummaryData.squadPlacement = player.GetPersistentVarAsInt( "lastGameRank" )
}


void function ShowVictorySequence( bool placementMode = false )
{
	#if !DEV
		placementMode = false
	#endif

	entity player = GetLocalClientPlayer()

	EndSignal( player, "OnDestroy" )

	// Fade to white and destroy the vidtory rui if there is one
	ScreenFade( player, 255, 255, 255, 255, 0.4, 2.0, FFADE_OUT | FFADE_PURGE )

	EmitSoundOnEntity( GetLocalClientPlayer(), "UI_InGame_ChampionMountain_Whoosh" )

	wait 0.4

	if ( IsSpectating() )
	{
		// don't show squad results when winner is determined, it will be shown after the Victory Sequence (victors lined up)
		// this causes a fade it seems. Need a way to not fade if we are not showing it to begin with.
		if ( GetGameState() < eGameState.WinnerDetermined )
			ShowRoundEndSquadResults( false )

		UpdateDeathAndSpectatorHUD( player, null )
	}

	if ( file.victoryRui != null )
		RuiDestroyIfAlive( file.victoryRui )

	UpdateRespawnStatus( eRespawnStatus.NONE )
	HideGladiatorCardSidePane( true )
	Signal( player, "Bleedout_StopBleedoutEffects" )

	ScreenFade( player, 255, 255, 255, 255, 0.4, 0.0, FFADE_IN | FFADE_PURGE )

	// Spawn character model for each squad member
	asset defaultModel = GetGlobalSettingsAsset( DEFAULT_PILOT_SETTINGS, "bodyModel" )
	LoadoutEntry loadoutSlotCharacter = Loadout_CharacterClass()
	vector characterAngles = < file.victorySequenceAngles.x / 2.0, file.victorySequenceAngles.y, file.victorySequenceAngles.z >

	array<entity> cleanupEnts

	// Platform model if one is set
	VictoryPlatformModelData victoryPlatformModelData = GetVictorySequencePlatformModel()
	entity platformModel
	if ( victoryPlatformModelData.isSet )
	{
		platformModel = CreateClientSidePropDynamic( file.victorySequencePosition + victoryPlatformModelData.originOffset, victoryPlatformModelData.modelAngles, victoryPlatformModelData.modelAsset )
		cleanupEnts.append( platformModel )
		int playersOnPodium = 0

		foreach( int i, SquadSummaryPlayerData data in file.winnerSquadSummaryData.playerData )
		{
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

			// Create Character model
			entity characterNode = CreateScriptRef( pos, characterAngles )
			characterNode.SetParent( platformModel, "", true )
			entity characterModel = CreateClientSidePropDynamic( pos, characterAngles, defaultModel )
			characterModel.MakeSafeForUIScriptHack()
			CharacterSkin_Apply( characterModel, characterSkin )
			cleanupEnts.append( characterModel )

			// Anim Activity
			characterModel.SetParent( characterNode, "", false )
			characterModel.Anim_Play( GetVictorySquadFormationActivity( i ) )
			characterModel.Anim_EnableUseAnimatedRefAttachmentInsteadOfRootMotion()

			// Create Overhead RUI
			entity overheadEnt = CreateClientSidePropDynamic( pos + ( AnglesToUp( file.victorySequenceAngles ) * 78 ), <0, 0, 0>, $"mdl/dev/empty_model.rmdl" )
			overheadEnt.Hide()

			var overheadRui = RuiCreate( $"ui/winning_squad_member_overhead_name.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 0 )
			RuiSetString( overheadRui, "playerName", playerName )
			RuiTrackFloat3( overheadRui, "position", overheadEnt, RUI_TRACK_ABSORIGIN_FOLLOW )

			playersOnPodium++
		}

		// different dialog depending on if you won or not.
		if ( player.GetTeam() == GetWinningTeam() )
		{
			//announcer VO
			if ( playersOnPodium > 1 )
				EmitSoundOnEntityAfterDelay( platformModel, "diag_ap_aiNotify_winnerFound_07", 0.5 )	// "You are the Apex Champions."
			else
				EmitSoundOnEntityAfterDelay( platformModel, "diag_ap_aiNotify_winnerFound_10", 0.5 )	// "You are the Apex Champion."
		}
		else
		{
			if ( playersOnPodium > 1 )
				EmitSoundOnEntityAfterDelay( platformModel, "diag_ap_aiNotify_winnerFound_08", 0.5 )	// "We have our Apex Champions."
			else
				EmitSoundOnEntityAfterDelay( platformModel, "diag_ap_ainotify_introchampion_01_02", 0.5 )	// "This is your Champion."
		}

		// Camera
		vector camera_offset_start = <0, 320, 68>
		vector camera_offset_end = <0, 200, 48>
		vector camera_focus_offset = <0, 0, 36>
		float camera_fov = 35.5

		vector camera_start_pos = OffsetPointRelativeToVector( file.victorySequencePosition, camera_offset_start, AnglesToForward( file.victorySequenceAngles ) )
		vector camera_end_pos = OffsetPointRelativeToVector( file.victorySequencePosition, camera_offset_end, AnglesToForward( file.victorySequenceAngles ) )
		vector camera_focus_pos = OffsetPointRelativeToVector( file.victorySequencePosition, camera_focus_offset, AnglesToForward( file.victorySequenceAngles ) )

		vector camera_start_angles = VectorToAngles( camera_focus_pos - camera_start_pos )
		vector camera_end_angles = VectorToAngles( camera_focus_pos - camera_end_pos )

		entity cameraMover = CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", camera_start_pos, camera_start_angles )
		entity camera = CreateClientSidePointCamera( camera_start_pos, camera_start_angles, camera_fov )
		player.SetMenuCameraEntity( camera )
		camera.SetTargetFOV( camera_fov, true, EASING_CUBIC_INOUT, 0.0 )
		camera.SetParent( cameraMover, "", false )
		cleanupEnts.append( camera )

		//DoF_SetFarDepth( 250, 750 )
		GetLightEnvironmentEntity().ScaleSunSkyIntensity( 1.3, 4.0 )

		// Camera Move
		float camera_move_duration = 6.5
		cameraMover.NonPhysicsMoveTo( camera_end_pos, camera_move_duration, 0.0, camera_move_duration / 2.0 )
		cameraMover.NonPhysicsRotateTo( camera_end_angles, camera_move_duration, 0.0, camera_move_duration / 2.0 )
		cleanupEnts.append( cameraMover )

		wait camera_move_duration - 0.5

		#if R5DEV
			if ( placementMode )
			{
				if ( IsValid( platformModel ) )
					platformModel.SetParent( cameraMover, "", true )

				while( true )
				{
					vector pos = cameraMover.GetOrigin()
					vector ang = cameraMover.GetAngles()
					vector flatAngles = FlattenAngles( ang )

					vector forward = AnglesToForward( flatAngles )
					vector right = AnglesToRight( flatAngles )
					vector up = <0,0,1>

					float moveSpeed = 800.0 + ( InputGetAxis( ANALOG_L_TRIGGER ) * 5000.0 )
					moveSpeed *= max( 1.0 - InputGetAxis( ANALOG_R_TRIGGER ), 0.05 )

					float rotateSpeed = 2.0 + ( InputGetAxis( ANALOG_L_TRIGGER ) * 10.0 )
					rotateSpeed *= max( 1.0 - InputGetAxis( ANALOG_R_TRIGGER ), 0.05 )

					if ( InputGetAxis( ANALOG_LEFT_Y ) > 0.15 || InputGetAxis( ANALOG_LEFT_Y ) < -0.15 )
						pos += forward * InputGetAxis( ANALOG_LEFT_Y ) * -moveSpeed
					if ( InputGetAxis( ANALOG_LEFT_X ) > 0.15 || InputGetAxis( ANALOG_LEFT_X ) < -0.15 )
						pos += right * InputGetAxis( ANALOG_LEFT_X ) * moveSpeed
					if ( InputIsButtonDown( BUTTON_STICK_LEFT ) )
						pos += up * moveSpeed * 0.1
					if ( InputIsButtonDown( BUTTON_STICK_RIGHT ) )
						pos -= up * moveSpeed * 0.1

					if ( InputGetAxis( ANALOG_RIGHT_X ) > 0.15 || InputGetAxis( ANALOG_RIGHT_X ) < -0.15 )
					{
						float yaw = ang.y + ( InputGetAxis( ANALOG_RIGHT_X ) * -rotateSpeed )
						ang = ClampAngles( < ang.x, yaw, ang.z > )
					}

					cameraMover.NonPhysicsMoveTo( pos, 0.1, 0.0, 0.0 )
					cameraMover.NonPhysicsRotateTo( ang, 0.1, 0.0, 0.0 )

					printt( "SetVictorySequenceLocation( " + (platformModel.GetOrigin() - victoryPlatformModelData.originOffset) + ", " + ClampAngles( < 0, camera.GetAngles().y + 180, 0 > ) + " )" )

					WaitFrame()
				}
			}
		#endif
	}

	SetSquadDataToLocalTeam()	// since the winning team never gets eliminated the data isn't set from before.
	thread ShowSquadSummary()

	wait 1.0

	foreach( entity ent in cleanupEnts )
		ent.Destroy()
}


vector function GetVictorySquadFormationPosition( vector mainPosition, vector angles, int index )
{
	if ( index == 0 )
		return mainPosition - <0,0,8>

	float offset_side = 48.0
	float offset_back = -28.0

	int countBack = ( index + 1 ) / 2
	vector offset = < offset_side, offset_back, 0 > * countBack

	if ( index % 2 == 0 )
		offset.x *= -1

	vector point = OffsetPointRelativeToVector( mainPosition, offset, AnglesToForward( angles ) )
	return point - <0,0,8>
}


string function GetVictorySquadFormationActivity( int index )
{
	return "ACT_MP_MENU_LOBBY_SELECT_IDLE"
	/*
	if ( index == 0 )
		return "ACT_MP_MENU_LOBBY_CENTER_IDLE"

	if ( index % 2 == 0 )
		return "ACT_MP_MENU_LOBBY_RIGHT_IDLE"

	return "ACT_MP_MENU_LOBBY_LEFT_IDLE"
	*/
}


bool function HealthkitWheelToggleEnabled()
{
	return false
}


bool function HealthkitWheelUseOnRelease()
{
	return false && !HealthkitUseOnHold()
}


bool function HealthkitUseOnHold()
{
	return false && !HealthkitWheelToggleEnabled()
}


void function HealthkitButton_Down( entity player )
{
	if ( !CommsMenu_CanUseMenu( player ) )
		return

	int ms = PlayerMatchState_GetFor( player )
	if ( ms < ePlayerMatchState.NORMAL )
		return

	CommsMenu_OpenMenuTo( player, eChatPage.INVENTORY_HEALTH, eCommsMenuStyle.INVENTORY_HEALTH_MENU )
}


void function HealthkitButton_Up( entity player )
{
	if ( !IsCommsMenuActive() )
		return

	if ( CommsMenu_GetCurrentCommsMenu() != eCommsMenuStyle.INVENTORY_HEALTH_MENU )
		return

	if ( HealthkitWheelToggleEnabled() )
		return

	if ( CommsMenu_HasValidSelection() )
		CommsMenu_ExecuteSelection( eWheelInputType.NONE )

	CommsMenu_Shutdown( true )
	player.SetLookStickDebounce()
}


bool function OrdnanceWheelToggleEnabled()
{
	return false
}


bool function OrdnanceWheelUseOnRelease()
{
	return true && !OrdnanceUseOnHold()
}


bool function OrdnanceUseOnHold()
{
	return false && !OrdnanceWheelToggleEnabled()
}


void function OrdnanceMenu_Down( entity player )
{
	if ( !SURVIVAL_PlayerCanSwitchOrdnance( player ) )
		return

	if ( !CommsMenu_CanUseMenu( player ) )
		return

	if ( Bleedout_IsBleedingOut( player ) )
		return

	CommsMenu_OpenMenuTo( player, eChatPage.ORDNANCE_LIST, eCommsMenuStyle.ORDNANCE_MENU )
}


void function OrdnanceMenu_Up( entity player )
{
	if ( !IsCommsMenuActive() )
		return
	if ( CommsMenu_GetCurrentCommsMenu() != eCommsMenuStyle.ORDNANCE_MENU )
		return

	if ( CommsMenu_HasValidSelection() )
		CommsMenu_ExecuteSelection( eWheelInputType.NONE )

	CommsMenu_Shutdown( true )
	player.SetLookStickDebounce()
}


const float MINIMAP_SCALE_SPECTATE = 1.0
void function OnFirstPersonSpectateStarted( entity player, entity currentTarget )
{
	if ( !Flag( "SquadEliminated" ) )
		StopLocal1PDeathSound()

	if ( IsValid( currentTarget ) && currentTarget.IsPlayer() )
		thread InitSurvivalHealthBar()

	Minimap_SetSizeScale( MINIMAP_SCALE_SPECTATE)
}


void function OnSpectatorTargetChanged( entity player, entity previousTarget, entity currentTarget )
{
	if ( IsValid( currentTarget ) && currentTarget.IsPlayer() )
	{
		thread InitSurvivalHealthBar()
		ScorebarInitTracking( currentTarget, ClGameState_GetRui() )
	}
}


void function OnLocalPlayerSpawned( entity localPlayer )
{
	thread InitSurvivalHealthBar()
	ScorebarInitTracking( localPlayer, ClGameState_GetRui() )

	Minimap_SetSizeScale( 1.0 )
}


void function OnPlayerMatchStateChanged( entity player, int oldState, int newState )
{
	switch ( newState )
	{
		case ePlayerMatchState.SKYDIVE_PRELAUNCH:
		case ePlayerMatchState.SKYDIVE_FALLING:
			Minimap_SetSizeScale( MINIMAP_SCALE_SPECTATE )
			break

		case ePlayerMatchState.NORMAL:
		case ePlayerMatchState.STAGING_AREA:
			Minimap_SetSizeScale( 1.0 )
			break
	}

	UpdateIsSonyMP()
}


void function UICallback_UpdateCharacterDetailsPanel( var ruiPanel )
{
	var rui = Hud_GetRui( ruiPanel )
	ItemFlavor character = LoadoutSlot_GetItemFlavor( ToEHI( GetLocalClientPlayer() ), Loadout_CharacterClass() )
	UpdateCharacterDetailsMenu( rui, character, true )
}


void function UICallback_OpenCharacterSelectNewMenu()
{
	// TODO: 
	if ( true || GetGameState() < eGameState.PickLoadout && !IsSurvivalTraining() )
	{
		OpenCharacterSelectNewMenu( true )
	}
}


void function UICallback_QueryPlayerCanBeRespawned()
{
	entity player = GetLocalClientPlayer()
	int rStatus = player.GetPlayerNetInt( "respawnStatus" )
	bool playerCanBeRespawned = rStatus == eRespawnStatus.WAITING_FOR_DELIVERY || rStatus == eRespawnStatus.WAITING_FOR_PICKUP
	playerCanBeRespawned = playerCanBeRespawned && GetGameState() == eGameState.Playing

	bool penaltyMayBeActive = PlayerMatchState_GetFor( GetLocalClientPlayer() ) < ePlayerMatchState.NORMAL
	penaltyMayBeActive = penaltyMayBeActive && GetPlayerArrayOfTeam( player.GetTeam() ).len() == 3


	penaltyMayBeActive = Ranked_IsPlayerAbandoning( player )


	RunUIScript( "ConfirmLeaveMatchDialog_SetPlayerCanBeRespawned", playerCanBeRespawned, penaltyMayBeActive )
}


void function ServerCallback_PromptSayThanks( entity thankee )
{
	if ( ShouldMuteCommsActionForCooldown( GetLocalViewPlayer(), eCommsAction.REPLY_THANKS, null ) )
		return

	AddPingBlockingFunction( "quickchat", SayThanks, 6.0, Localize( "#PING_SAY_THANKS", thankee.GetPlayerName() ) )
}


void function SayThanks( entity player )
{
	Quickchat( player, eCommsAction.REPLY_THANKS )
}

bool function CanReportPlayer( entity target )
{
	int reportStyle = GetReportStyle()

	if ( !IsValid( target ) )
		return false

	if ( !target.IsPlayer() )
		return false

	#if CONSOLE_PROG
	reportStyle = minint( reportStyle, 1 )
	#endif

	switch ( reportStyle )
	{
		case 0: //
			return false

		case 1: //
			return target.GetHardware() == GetLocalClientPlayer().GetHardware()

		case 2: //
			break

		default:
			return false
	}

	return true
}

void function OnPlayerKilled( entity player )
{
	entity viewPlayer = GetLocalViewPlayer()
	if ( player.GetTeam() == viewPlayer.GetTeam() && player != viewPlayer )
	{
		EmitSoundOnEntity( viewPlayer, SOUND_UI_TEAMMATE_KILLED )
	}
}


void function UpdateInventoryCounter( entity player, string ref, bool isFull = false )
{
	var rui = file.inventoryCountRui

	RuiSetGameTime( rui, "startTime", Time() )
	RuiSetFloat2( rui, "offset", <0.0,0.18,0.0> )
	RuiSetInt( rui, "maxCount", SURVIVAL_GetInventoryLimit( player ) )
	RuiSetInt( rui, "currentCount", SURVIVAL_GetInventoryCount( player ) )
	RuiSetInt( rui, "highlightCount", 0 ) //SURVIVAL_CountSquaresInInventory( player, ref ) )
	RuiSetBool( rui, "isFull", isFull )
}


void function TryUpdateInventoryCounter( entity player, LootData data, int lootAction )
{
	if ( lootAction == eLootAction.PICKUP || lootAction == eLootAction.PICKUP_ALL || data.lootType == eLootType.BACKPACK )
	{
		UpdateInventoryCounter( player, data.ref )
	}
}


void function PlayerHudSetWeaponInspect( bool inspect )
{
	RuiSetBool( file.pilotRui, "weaponInspect", inspect )
	RuiSetBool( file.dpadMenuRui, "weaponInspect", inspect )
}


void function ServerCallback_NessyMessage( int state )
{
	if ( state == 0 )
		Obituary_Print_Localized( Localize( "#NESSY_APPEARS" ) )
	if ( state == 1 )
		Obituary_Print_Localized( Localize( "#NESSY_SURFACES" ) )
}


void function ServerCallback_RefreshInventoryAndWeaponInfo()
{
	ServerCallback_RefreshInventory()
	ClWeaponStatus_RefreshWeaponInfo()
}

void function UIToClient_ToggleMute()
{
	ToggleSquadMute()
}

void function ToggleSquadMute()
{
	SetSquadMuteState( !file.isSquadMuted )
}

void function SetSquadMuteState( bool isSquadMuted )
{
	file.isSquadMuted = isSquadMuted
	foreach ( player in GetPlayerArrayOfTeam( GetLocalClientPlayer().GetTeam() ) )
	{
		if ( player == GetLocalClientPlayer() )
			continue

		if ( player.IsTextMuted() != isSquadMuted )
		{
			TogglePlayerTextMute( player )
		}

		if ( player.IsVoiceMuted() != isSquadMuted  )
		{
			TogglePlayerVoiceMute( player )
		}
	}

	foreach ( cb in file.squadMuteChangeCallbacks )
		cb()
}

bool function IsSquadMuted()
{
	return file.isSquadMuted
}


bool function SquadMuteIntroEnabled()
{
	return GetCurrentPlaylistVarBool( "squad_mute_intro_enable", true )
}


void function AddCallback_OnSquadMuteChanged( void functionref() cb )
{
	file.squadMuteChangeCallbacks.append( cb )
}


void function OnSquadMuteChanged()
{
	if ( file.waitingForPlayersBlackScreenRui )
	{
		string muteString = ""
		if ( !UseSoloModeIntroPresentation() )
		{
			muteString = Localize( IsSquadMuted() ? "#CHAR_SEL_BUTTON_UNMUTE" : "#CHAR_SEL_BUTTON_MUTE" )
		}
		RuiSetString( file.waitingForPlayersBlackScreenRui, "squadMuteHint", muteString )
	}
}
void function ServerCallback_RefreshDeathBoxHighlight()
{
	array<entity> boxes = GetAllDeathBoxes()
	ArrayRemoveInvalid( boxes )
	foreach ( box in boxes )
	{
		ManageHighlightEntity( box )
	}
}

var function GetCompassRui()
{
	return file.compassRui
}