global function GamemodeSurvival_Init
global function RateSpawnpoints_Directional
global function Survival_SetFriendlyOwnerHighlight
global function SURVIVAL_AddSpawnPointGroup
global function SURVIVAL_IsCharacterClassLocked
global function SURVIVAL_IsValidCircleLocation
global function _GetSquadRank
global function JetwashFX
global function Survival_PlayerRespawnedTeammate
global function UpdateDeathBoxHighlight
global function UpdateDeathBoxHighlight_Retail
global function HandleSquadElimination
// these probably doesn't belong here
//----------------------------------
global function Survival_GetMapFloorZ
global function SURVIVAL_GetClosestValidCircleEndLocation
global function SURVIVAL_CalculateAirdropPositions
global function SURVIVAL_AddLootBin
global function SURVIVAL_AddLootGroupRemapping
global function SURVIVAL_DebugLoot
global function Survival_AddCallback_OnAirdropLaunched
global function Survival_CleanupPlayerPermanents
global function Survival_SetCallback_Leviathan_ConsiderLookAtEnt
global function Leviathan_ConsiderLookAtEnt

global entity WORKAROUND_DESERTLANDS_TRAIN = null

global function CreateSurvivalDeathBoxForPlayer
global function UpdateMatchSummaryPersistentVars
global function EnemyDownedDialogue
global function TakingFireDialogue
global function GetAllDroppableItems

global function CreateShipPath
global function Flowstate_CheckForLv4MagazinesAndRefillAmmo
global function EnemyKilledDialogue

//float SERVER_SHUTDOWN_TIME_AFTER_FINISH = -1 // 1 or more to wait the specified number of seconds before executing, 0 to execute immediately, -1 or less to not execute

struct
{
    void functionref( entity, float, float ) leviathanConsiderLookAtEntCallback = null
	array<vector> foundFlightPath
} file

void function GamemodeSurvival_Init()
{	
	if(GetCurrentPlaylistVarBool("enable_global_chat", true))
		SetConVarBool("sv_forceChatToTeamOnly", false) //thanks rexx
	else
		SetConVarBool("sv_forceChatToTeamOnly", true)
	
	SurvivalFreefall_Init()
	Sh_ArenaDeathField_Init()
	SurvivalShip_Init()

	FlagInit( "SpawnInDropship", false )
	FlagInit( "PlaneDrop_Respawn_SetUseCallback", false )

	AddCallback_OnPlayerKilled( OnPlayerKilled )
	AddCallback_OnPlayerKilled( OnPlayerKilled_DropLoot )
	AddCallback_OnClientConnected( OnClientConnected )
	AddCallback_EntitiesDidLoad( OnSurvivalMapEntsDidLoad )
	// #if DEVELOPER
	AddClientCommandCallback("Flowstate_AssignCustomCharacterFromMenu", ClientCommand_Flowstate_AssignCustomCharacterFromMenu)
	AddClientCommandCallback("SpawnDeathboxAtCrosshair", ClientCommand_deathbox)
	AddClientCommandCallback("forceBleedout", ClientCommand_bleedout)
	AddClientCommandCallback("lsm_restart", ClientCommand_restartServer)
	AddClientCommandCallback("playerRequestsSword", ClientCommand_GiveSword)

	AddClientCommandCallback("forceChampionScreen", ClientCommand_ForceChampionScreen)
	AddClientCommandCallback("forceGameOverScreen", ClientCommand_ForceGameOverScreen)
	AddClientCommandCallback("forceRingMovement", ClientCommand_ForceRingMovement )
	
	AddClientCommandCallback("destroyEndScreen", ClientCommand_DestroyEndScreen)
	
	// #endif

	FillSkyWithClouds()

	AddCallback_GameStateEnter(
		eGameState.Playing,
		void function()
		{
			thread Sequence_Playing()
		}
	)

	thread SURVIVAL_RunArenaDeathField()
}

bool function ClientCommand_GiveSword(entity player, array<string> args)
{
	if ( GetConVarInt( "sv_cheats" ) != 1 )
		return false

	GiveSword( player )
	return true
}

bool function ClientCommand_bleedout(entity player, array<string> args)
{
	if ( GetConVarInt( "sv_cheats" ) != 1 )
		return false

	Bleedout_StartPlayerBleedout( player, player )
	return true
}

bool function ClientCommand_restartServer(entity player, array<string> args)
{
	if ( GetConVarInt( "sv_cheats" ) != 1 )
		return false

	GameRules_ChangeMap( GetMapName(), GetCurrentPlaylistName() )
	return true
}

bool function ClientCommand_ForceRingMovement(entity player, array<string> args)
{
	if ( GetConVarInt( "sv_cheats" ) != 1 )
		return false

	FlagWait( "DeathCircleActive" )
	svGlobal.levelEnt.Signal( "DeathField_ShrinkNow" )
	FlagClear( "DeathFieldPaused" )

	return true
}

bool function ClientCommand_ForceChampionScreen(entity player, array<string> args)
{
	if ( GetConVarInt( "sv_cheats" ) != 1 )
		return false

	Remote_CallFunction_NonReplay( player, "ServerCallback_MatchEndAnnouncement", true, gp()[0].GetTeam() )
	ToggleHudForPlayer( player )

	return true
}

bool function ClientCommand_ForceGameOverScreen(entity player, array<string> args)
{
	if ( GetConVarInt( "sv_cheats" ) != 1 )
		return false

	Remote_CallFunction_NonReplay( player, "ServerCallback_MatchEndAnnouncement", true, gp()[0].GetTeam() + 1 )
	ToggleHudForPlayer( player )

	return true
}

bool function ClientCommand_DestroyEndScreen(entity player, array<string> args)
{
	if ( GetConVarInt( "sv_cheats" ) != 1 )
		return false

	Remote_CallFunction_NonReplay( player, "ServerCallback_DestroyEndAnnouncement" )
	ToggleHudForPlayer( player )

	return true
}

bool function ClientCommand_deathbox(entity player, array<string> args)
{
	if ( GetConVarInt( "sv_cheats" ) != 1 )
		return false

	vector origin = OriginToGround( GetPlayerCrosshairOrigin( player ) )

	vector org2 = player.GetOrigin()
	vector vec1 = org2 - origin
	vector angles1 = VectorToAngles( vec1 )
	angles1.x = 0
	
	CreateAimtrainerDeathbox( gp()[0], origin )
	return true
}

void function OnSurvivalMapEntsDidLoad()
{
	CreateShipPath()
}

void function CreateShipPath()
{
	file.foundFlightPath = Survival_GeneratePlaneFlightPath()
}
// #if DEVELOPER
bool function ClientCommand_Flowstate_AssignCustomCharacterFromMenu(entity player, array<string> args)
{
	if( !IsValid(player) || !IsAlive( player) || args.len() != 1 )
		return false

	if ( GetConVarInt( "sv_cheats" ) != 1 )
		return false

	CharacterSelect_AssignCharacter( ToEHI( player ), GetAllCharacters()[5] )

	ItemFlavor playerCharacter = LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_CharacterClass() )
	asset characterSetFile = CharacterClass_GetSetFile( playerCharacter )
	player.SetPlayerSettingsWithMods( characterSetFile, [] )

	player.TakeOffhandWeapon(OFFHAND_TACTICAL)
	player.TakeOffhandWeapon(OFFHAND_ULTIMATE)
	TakeAllPassives(player)

	switch( args[0] )
	{
		case "0":
		player.SetBodyModelOverride( $"mdl/Humans/pilots/w_master_chief.rmdl" )
		player.SetArmsModelOverride( $"mdl/Humans/pilots/ptpov_master_chief.rmdl" )
		break
		
		case "1":
		player.SetBodyModelOverride( $"mdl/Humans/pilots/w_blisk.rmdl" )
		player.SetArmsModelOverride( $"mdl/Humans/pilots/pov_blisk.rmdl" )
		break
		
		case "2":
		player.SetBodyModelOverride( $"mdl/Humans/pilots/w_phantom.rmdl" )
		player.SetArmsModelOverride( $"mdl/Humans/pilots/ptpov_phantom.rmdl" )
		break
		
		case "3":
		player.SetBodyModelOverride( $"mdl/Humans/pilots/w_amogino.rmdl" )
		player.SetArmsModelOverride( $"mdl/Humans/pilots/ptpov_amogino.rmdl" )
		break

		// case "4":
		// player.SetBodyModelOverride( $"mdl/Humans/pilots/w_petergriffing.rmdl" )
		// player.SetArmsModelOverride( $"mdl/Humans/pilots/ptpov_petergriffing.rmdl" )
		// break
		
		case "5":
		player.SetBodyModelOverride( $"mdl/Humans/pilots/w_rhapsody.rmdl" )
		player.SetArmsModelOverride( $"mdl/Humans/pilots/ptpov_rhapsody.rmdl" )
		break
		
		case "6":
		player.SetBodyModelOverride( $"mdl/Humans/pilots/w_ash_legacy.rmdl" )
		player.SetArmsModelOverride( $"mdl/Humans/pilots/pov_ash_legacy.rmdl" )
		break
		
		// case "7":
		// player.SetBodyModelOverride( $"mdl/Humans/pilots/w_cj.rmdl" )
		// player.SetArmsModelOverride( $"mdl/Humans/pilots/ptpov_amogino.rmdl" )
		// break
		
		case "8":
		player.SetBodyModelOverride( $"mdl/Humans/pilots/w_jackcooper.rmdl" )
		player.SetArmsModelOverride( $"mdl/Humans/pilots/ptpov_jackcooper.rmdl" )
		break

		case "9":
		player.SetBodyModelOverride( $"mdl/Humans/pilots/pilot_medium_loba.rmdl" )
		player.SetArmsModelOverride( $"mdl/Humans/pilots/pov_pilot_medium_loba.rmdl" )
		break
		
		case "10":
		player.SetBodyModelOverride( $"mdl/Humans/pilots/pilot_heavy_revenant.rmdl" )
		player.SetArmsModelOverride( $"mdl/Humans/pilots/pov_pilot_heavy_revenant.rmdl" )
		break

		// case "11": //loba ss
		// player.SetBodyModelOverride( $"mdl/Humans/pilots/pilot_medium_loba_swimsuit.rmdl" )
		// player.SetArmsModelOverride( $"mdl/Humans/pilots/ptpov_loba_swimsuit.rmdl" )
		// break
		
		case "12": // ballistic
		player.SetBodyModelOverride( $"mdl/Humans/pilots/ballistic_base_w.rmdl" )
		player.SetArmsModelOverride( $"mdl/Humans/pilots/ballistic_base_v.rmdl" )
		break
		
		case "13": // mrvn
		player.SetBodyModelOverride( $"mdl/flowstate_custom/w_marvin.rmdl" )
		player.SetArmsModelOverride( $"mdl/Humans/pilots/ptpov_amogino.rmdl" )
		break

		// case "14": // gojo
		// player.SetBodyModelOverride( $"mdl/flowstate_custom/w_gojo.rmdl" )
		// player.SetArmsModelOverride( $"mdl/flowstate_custom/ptpov_gojo.rmdl" )
		// break

		// case "15": // naruto
		// player.SetBodyModelOverride( $"mdl/flowstate_custom/w_naruto.rmdl" )
		// player.SetArmsModelOverride( $"mdl/flowstate_custom/ptpov_naruto.rmdl" )
		// break

		case "16": // pete
		player.SetBodyModelOverride( $"mdl/flowstate_custom/w_pete_mri.rmdl" )
		player.SetArmsModelOverride( $"mdl/flowstate_custom/ptpov_pete_mri.rmdl" )
		break
	}

	// player.TakeOffhandWeapon(OFFHAND_MELEE)
	// player.TakeNormalWeaponByIndexNow( WEAPON_INVENTORY_SLOT_PRIMARY_2 )
	// player.GiveWeapon( "mp_weapon_vctblue_primary", WEAPON_INVENTORY_SLOT_PRIMARY_2, [] )
	// player.GiveOffhandWeapon( "melee_vctblue", OFFHAND_MELEE, [] )

	return true
}
// #endif

void function Survival_SetCallback_Leviathan_ConsiderLookAtEnt( void functionref( entity, float, float ) callback )
{
	file.leviathanConsiderLookAtEntCallback = callback
}

void function Leviathan_ConsiderLookAtEnt( entity ent, float duration, float careChance )
{
	if ( file.leviathanConsiderLookAtEntCallback != null )
		thread file.leviathanConsiderLookAtEntCallback( ent, duration, careChance )
}

void function RespawnPlayerInDropship( entity player )
{
	const float POS_OFFSET = -525.0 // Offset from dropship's origin

	entity dropship = Sur_GetPlaneEnt()

	vector dropshipPlayerOrigin = dropship.GetOrigin()
	dropshipPlayerOrigin.z += POS_OFFSET

	DecideRespawnPlayer( player, false )

	player.SetParent( dropship )

	player.SetOrigin( dropshipPlayerOrigin )
	player.SetAngles( dropship.GetAngles() )

	player.UnfreezeControlsOnServer()

	player.ForceCrouch()
	player.Hide()
	player.NotSolid()
	
	player.SetPlayerNetBool( "isJumpingWithSquad", true )
	player.SetPlayerNetBool( "playerInPlane", true )

	PlayerMatchState_Set( player, ePlayerMatchState.SKYDIVE_PRELAUNCH )

	if ( Flag( "PlaneDrop_Respawn_SetUseCallback" ) )
		AddCallback_OnUseButtonPressed( player, Survival_DropPlayerFromPlane_UseCallback )

	array<entity> playerTeam = GetPlayerArrayOfTeam( player.GetTeam() )
	bool isAlone = playerTeam.len() <= 1

	if ( isAlone )
		player.SetPlayerNetBool( "isJumpmaster", true )

	AddCinematicFlag( player, CE_FLAG_HIDE_MAIN_HUD_INSTANT )

	if( GetCurrentPlaylistVarBool( "flowstate_giveskins_characters", false ) )
	{
		array<ItemFlavor> characterSkinsA = GetValidItemFlavorsForLoadoutSlot( ToEHI( player ), Loadout_CharacterSkin( LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_CharacterClass() ) ) )
		CharacterSkin_Apply( player, characterSkinsA[characterSkinsA.len()-RandomIntRangeInclusive(1,4)])
	}
}

void function Sequence_Playing()
{
	SetServerVar( "minimapState", IsFiringRangeGameMode() ? eMinimapState.Hidden : eMinimapState.Default )

	if ( IsFiringRangeGameMode() || IsSurvivalTraining() )
	{
		SetGameState( eGameState.WaitingForPlayers )
		return
	}

	FlagSet( "GamePlaying" )

	if ( !GetCurrentPlaylistVarBool( "jump_from_plane_enabled", true ) )
	{
		// vector pos = GetEnt( "info_player_start" ).GetOrigin()
		// pos.z += 5

		// int i = 0
		foreach ( player in GetPlayerArray() )
		{
			// // circle
			// float r = float(i) / float(GetPlayerArray().len()) * 2 * PI
			// player.SetOrigin( pos + 500.0 * <sin( r ), cos( r ), 0.0> )

			DecideRespawnPlayer( player )
			// GiveBasicSurvivalItems( player )
			// i++
		}

		// Show the squad and player counter
		UpdatePlayerCounts()
	}
	else
	{
		float DROP_TOTAL_TIME = GetCurrentPlaylistVarFloat( "survival_plane_jump_duration", 60.0 )
		float DROP_WAIT_TIME = GetCurrentPlaylistVarFloat( "survival_plane_jump_delay", 5.0 )
		float DROP_TIMEOUT_TIME = 0 // GetCurrentPlaylistVarFloat( "survival_plane_jump_timeout", 5.0 )

		array<vector> foundFlightPath = file.foundFlightPath

		vector shipStart = foundFlightPath[0]
		vector shipEnd = foundFlightPath[1]
		vector shipAngles = foundFlightPath[2]
		vector shipPathCenter = foundFlightPath[3]

		entity centerEnt = CreatePropScript_NoDispatchSpawn( $"mdl/dev/empty_model.rmdl", shipPathCenter, shipAngles )
		centerEnt.Minimap_AlwaysShow( 0, null )
		SetTargetName( centerEnt, "pathCenterEnt" )
		DispatchSpawn( centerEnt )

		entity dropship = Survival_CreatePlane( shipStart, shipAngles )

		Sur_SetPlaneEnt( dropship )

		entity minimapPlaneEnt = CreatePropScript_NoDispatchSpawn( $"mdl/dev/empty_model.rmdl", dropship.GetOrigin(), dropship.GetAngles() )
		minimapPlaneEnt.NotSolid()
		minimapPlaneEnt.SetParent( dropship )
		minimapPlaneEnt.Minimap_AlwaysShow( 0, null )
		SetTargetName( minimapPlaneEnt, "planeEnt" )
		DispatchSpawn( minimapPlaneEnt )

		foreach ( team in GetTeamsForPlayers( GetPlayerArray() ) )
		{
			array<entity> teamMembers = GetPlayerArrayOfTeam( team )

			bool foundJumpmaster = false
			entity ornull jumpMaster = null

			for ( int idx = teamMembers.len() - 1; idx == 0; idx-- )
			{
				entity teamMember = teamMembers[idx]

				if ( Survival_IsPlayerEligibleForJumpmaster( teamMember ) )
				{
					foundJumpmaster = true
					jumpMaster = teamMember

					break
				}
			}

			if ( !foundJumpmaster && teamMembers.len() > 0 ) // No eligible jumpmasters? Shouldn't happen, but just in case
				jumpMaster = teamMembers.getrandom()

			if ( jumpMaster != null )
			{
				expect entity( jumpMaster )

				jumpMaster.SetPlayerNetBool( "isJumpmaster", true )
			}
		}

		FlagSet( "SpawnInDropship" )

		foreach ( player in GetPlayerArray() )
			RespawnPlayerInDropship( player )

		// Show the squad and player counter
		UpdatePlayerCounts()

		// Update the networked duration
		float timeDoorOpenWait = CharSelect_GetOutroTransitionDuration() + DROP_WAIT_TIME
		float timeDoorCloseWait = DROP_TOTAL_TIME

		float referenceTime = Time()
		SetGlobalNetTime( "PlaneDoorsOpenTime", referenceTime + timeDoorOpenWait )
		SetGlobalNetTime( "PlaneDoorsCloseTime", referenceTime + timeDoorOpenWait + timeDoorCloseWait )

		dropship.NonPhysicsMoveTo( shipEnd, DROP_TOTAL_TIME + DROP_WAIT_TIME, 0.0, 0.0 )

		wait CharSelect_GetOutroTransitionDuration()

		wait DROP_WAIT_TIME

		FlagSet( "PlaneDrop_Respawn_SetUseCallback" )

		foreach ( player in GetPlayerArray_AliveConnected() )
			AddCallback_OnUseButtonPressed( player, Survival_DropPlayerFromPlane_UseCallback )

		wait DROP_TOTAL_TIME - CharSelect_GetOutroTransitionDuration()

		FlagClear( "PlaneDrop_Respawn_SetUseCallback" )

		FlagClear( "SpawnInDropship" )

		foreach ( player in GetPlayerArray() )
		{
			if ( player.GetPlayerNetBool( "playerInPlane" ) )
				Survival_DropPlayerFromPlane_UseCallback( player )
		}

		centerEnt.Destroy()
		minimapPlaneEnt.Destroy()
		minimapPlaneEnt.ClearParent()
		try{
			ClearChildren( dropship, true )
			dropship.Destroy()}
		catch( e420 )
		{
			printt("DROPSHIP BUG CATCHED - DEBUG THIS, DID DROPSHIP HAVE BOTS?")
		}
		
	}
	
	FlagClear( "SpawnInDropship" )
	
	wait 5.0

	if ( GetCurrentPlaylistVarBool( "survival_deathfield_enabled", true ) )
	{
		FlagSet( "DeathCircleActive" )
		thread CircleRemainingTimeChatter_Think()
	}

	if( GetCurrentPlaylistVarBool( "lsm_mod11", false ) )
	{
		while( GetPlayerArray().len() < 2 )
		{
			WaitFrame()
		}
	} else if ( !GetCurrentPlaylistVarBool( "match_ending_enabled", true ) || GetConVarInt( "mp_enablematchending" ) < 1 )
	{
		WaitForever() // match never ending
	}
	
	while ( GetGameState() == eGameState.Playing )
	{
		if ( GetNumTeamsRemaining() <= 1 )
		{
			int winnerTeam
			if( GetTeamsForPlayers( GetPlayerArray_AliveConnected() ).len() > 0 )
				winnerTeam = GetTeamsForPlayers( GetPlayerArray_AliveConnected() )[0]
			else
				winnerTeam = -1
			
			level.nv.winningTeam = winnerTeam

			SetGameState( eGameState.WinnerDetermined )
		}
		WaitFrame()
	}

	thread Sequence_WinnerDetermined()
}

void function CircleRemainingTimeChatter_Think()
{
	while( true )
	{
		wait 1.0

		int remainingTime = int( GetGlobalNetTime( "nextCircleStartTime" ) - Time() )

		if( remainingTime < 0 )
			continue
		
		string line = ""
		array< int > alreadySaidTeam = []

		switch( remainingTime )
		{
			case 60:
				line = "bc_circleMovesNag1Min"
				break

			case 45:
				line = "bc_circleMovesNag45Sec"
				break

			case 30:
				line = "bc_circleMovesNag30Sec"
				break

			case 10:
				line = "bc_circleMovesNag10Sec"
				break
		}

		if( line == "" )
			continue

		foreach( player in GetPlayerArray_Alive() )
		{
			if( !IsValid( player ) )
				continue

			if( alreadySaidTeam.contains( player.GetTeam() ) )
				continue

			alreadySaidTeam.append( player.GetTeam() )
			string distance = ""
			entity speaker = GetPlayerArrayOfTeam_Alive( player.GetTeam() ).getrandom()

			if( SURVIVAL_PosInSafeZone( speaker.GetOrigin() ) )
				continue

			if( Distance( SURVIVAL_GetSafeZoneCenter(), speaker.GetOrigin() ) >= FAR_FROM_CIRCLE_DISTANCE * 17500 )
				distance = "_far"
			else
				distance = "_close"

			PlayBattleChatterLineToSpeakerAndTeam( speaker, line + distance )
		}
	}
}

void function Sequence_WinnerDetermined()
{
	FlagSet( "DeathFieldPaused" )

	foreach ( player in GetPlayerArray() )
	{
		MakeInvincible( player )
		Remote_CallFunction_NonReplay( player, "ServerCallback_PlayMatchEndMusic" )
		Remote_CallFunction_NonReplay( player, "ServerCallback_MatchEndAnnouncement", player.GetTeam() == GetWinningTeam(), GetWinningTeam() )

		if( Bleedout_IsBleedingOut( player ) )
		{
			player.Signal( "BleedOut_OnRevive" )
			player.Signal( "OnContinousUseStopped" )
		}
			
	}

	thread SurvivalCommentary_HostAnnounce( eSurvivalCommentaryBucket.WINNER, 3.0 )

	wait 15.0

	thread Sequence_Epilogue()
}

void function Sequence_Epilogue()
{
	SetGameState( eGameState.Epilogue )

	UpdateMatchSummaryPersistentVars( GetWinningTeam() )

	foreach ( player in GetPlayerArray() )
	{
		player.FreezeControlsOnServer()

		// Clear all residue data
		Remote_CallFunction_NonReplay( player, "ServerCallback_AddWinningSquadData", -1, -1, 0, 0, 0, 0, 0 )

		foreach ( int i, entity champion in GetPlayerArrayOfTeam( GetWinningTeam() ) )
		{
			GameSummarySquadData gameSummaryData = GameSummary_GetPlayerData( champion )

			Remote_CallFunction_NonReplay(
				player,
				"ServerCallback_AddWinningSquadData",
				i, // Champion index
				champion.GetEncodedEHandle(), // Champion EEH
				gameSummaryData.kills,
				gameSummaryData.damageDealt,
				gameSummaryData.survivalTime,
				gameSummaryData.revivesGiven,
				gameSummaryData.respawnsGiven
			)
		}

		Remote_CallFunction_NonReplay( player, "ServerCallback_ShowWinningSquadSequence" )
	}
	
	WaitForever()
	// if( SERVER_SHUTDOWN_TIME_AFTER_FINISH >= 1 )
		// wait SERVER_SHUTDOWN_TIME_AFTER_FINISH
	// else if( SERVER_SHUTDOWN_TIME_AFTER_FINISH <= -1 )
		// WaitForever()

	// if( GetCurrentPlaylistVarBool( "survival_server_restart_after_end", false ) )
		// GameRules_ChangeMap( GetMapName(), GameRules_GetGameMode() )
	// else
		// DestroyServer()
}

void function UpdateMatchSummaryPersistentVars( int team )
{
	array<entity> squadMembers = GetPlayerArrayOfTeam( team )
	int maxTrackedSquadMembers = PersistenceGetArrayCount( "lastGameSquadStats" )

	foreach ( teamMember in squadMembers )
	{
		teamMember.SetPersistentVar( "lastGameRank", Survival_GetCurrentRank( teamMember ) )

		for ( int i = 0; i < squadMembers.len(); i++ )
		{
			if ( i >= maxTrackedSquadMembers )
				continue

			entity statMember = squadMembers[i]
			GameSummarySquadData statSummaryData = GameSummary_GetPlayerData( statMember )

			teamMember.SetPersistentVar( "lastGameSquadStats[" + i + "].eHandle", statMember.GetEncodedEHandle() )
			teamMember.SetPersistentVar( "lastGameSquadStats[" + i + "].kills", statSummaryData.kills )
			teamMember.SetPersistentVar( "lastGameSquadStats[" + i + "].damageDealt", statSummaryData.damageDealt )
			teamMember.SetPersistentVar( "lastGameSquadStats[" + i + "].survivalTime", statSummaryData.survivalTime )
			teamMember.SetPersistentVar( "lastGameSquadStats[" + i + "].revivesGiven", statSummaryData.revivesGiven )
			teamMember.SetPersistentVar( "lastGameSquadStats[" + i + "].respawnsGiven", statSummaryData.respawnsGiven )
		}
	}
}

void function HandleSquadElimination( int team )
{
	RespawnBeacons_OnSquadEliminated( team )
	StatsHook_SquadEliminated( GetPlayerArrayOfTeam_Connected( team ) )

	UpdateMatchSummaryPersistentVars( team )

	foreach ( player in GetPlayerArray() )
		Remote_CallFunction_NonReplay( player, "ServerCallback_SquadEliminated", team )

	array< table< int, var > > squadData
	array< entity > squadList = GetPlayerArrayOfTeam( team )

	foreach ( squadPlayer in squadList )
	{
		squadData.append( LiveAPI_GetPlayerIdentityTable( squadPlayer ) )
	}

	LiveAPI_WriteLogUsingDefinedFields( eLiveAPI_EventTypes.squadEliminated,
		[ squadData ], [ 3/*players*/ ]
	)
}

// Fully doomed, no chance to respawn, game over
void function PlayerFullyDoomed( entity player )
{
	player.p.respawnChanceExpiryTime = Time()
	player.p.squadRank = 0 // Survival_GetCurrentRank( player )

	StatsHook_RecordPlacementStats( player )
}

void function OnPlayerDamaged( entity victim, var damageInfo )
{
	if ( !IsValid( victim ) || !victim.IsPlayer() || Bleedout_IsBleedingOut( victim ) )
		return
	
	entity attacker = InflictorOwner( DamageInfo_GetAttacker( damageInfo ) )
	
	int sourceId = DamageInfo_GetDamageSourceIdentifier( damageInfo )
	if ( sourceId == eDamageSourceId.bleedout || sourceId == eDamageSourceId.human_execution )
		return

	float damage = DamageInfo_GetDamage( damageInfo )

	int currentHealth = victim.GetHealth()
	if ( !( DamageInfo_GetCustomDamageType( damageInfo ) & DF_BYPASS_SHIELD ) )
		currentHealth += victim.GetShieldHealth()
	
	vector damagePosition = DamageInfo_GetDamagePosition( damageInfo )
	int damageType = DamageInfo_GetCustomDamageType( damageInfo )
	entity weapon = DamageInfo_GetWeapon( damageInfo )

	TakingFireDialogue( attacker, victim, weapon )

	if ( currentHealth - damage <= 0 && !IsInstantDeath( damageInfo ) && !IsDemigod( victim ) )
	{
		OnPlayerDowned_UpdateHuntEndTime( victim, attacker, damageInfo )
	}
	
	if ( currentHealth - damage <= 0 && PlayerRevivingEnabled() && !IsInstantDeath( damageInfo ) && Bleedout_AreThereAlivingMates( victim.GetTeam(), victim ) && !IsDemigod( victim ) )
	{	
		if( !IsValid(attacker) || !IsValid(victim) )
			return

		thread EnemyDownedDialogue( attacker, victim )

		if( GetGameState() >= eGameState.Playing && attacker.IsPlayer() && attacker != victim )
			AddPlayerScore( attacker, "Sur_DownedPilot", victim )

		foreach ( cbPlayer in GetPlayerArray() )
			Remote_CallFunction_Replay( cbPlayer, "ServerCallback_OnEnemyDowned", attacker, victim, damageType, sourceId )	
			
		// Add the cool splashy blood and big red crosshair hitmarker
		DamageInfo_AddCustomDamageType( damageInfo, DF_KILLSHOT )
	
		// Supposed to be bleeding
		Bleedout_StartPlayerBleedout( victim, attacker )

		// Notify the player of the damage (even though it's *technically* canceled and we're hijacking the damage in order to not make an alive 100hp player instantly dead with a well placed kraber shot)
		if (attacker.IsPlayer() && IsValid( attacker ))
        {
            attacker.NotifyDidDamage( victim, DamageInfo_GetHitBox( damageInfo ), damagePosition, damageType, damage, DamageInfo_GetDamageFlags( damageInfo ), DamageInfo_GetHitGroup( damageInfo ), weapon, DamageInfo_GetDistFromAttackOrigin( damageInfo ) )
        }
		// Cancel the damage
		// Setting damage to 0 cancels all knockback, setting it to 1 doesn't
		// There might be a better way to do this, but this works well enough
		DamageInfo_SetDamage( damageInfo, 1 )

		// Delete any shield health remaining
		victim.SetShieldHealth( 0 )
	}
}

void function EnemyDownedDialogue( entity attacker, entity victim )
{
	if( !attacker.IsPlayer() || attacker == victim )
		return
	
	attacker.p.downedEnemy++

	string dialogue = ""
	float delay = 2
	float anotherDelay = 10
	if( Time() <= anotherDelay )
		attacker.p.lastDownedEnemyTime -= anotherDelay // rare
	
	float time = Time() - attacker.p.lastDownedEnemyTime
	int currentDownedEnemy = attacker.p.downedEnemy

	if( attacker.p.downedEnemy > 1 )
		dialogue = "bc_iDownedMultiple"
	else if( time <= anotherDelay )
		dialogue = "bc_iDownedAnotherEnemy"
	else
		dialogue = "bc_iDownedAnEnemy"

	wait delay

	if( attacker.p.downedEnemy == currentDownedEnemy )
	{
		PlayBattleChatterLineToSpeakerAndTeam( attacker, dialogue )
		attacker.p.downedEnemy = 0
		attacker.p.lastDownedEnemyTime = Time()
	}
}

void function TakingFireDialogue( entity attacker, entity victim, entity weapon )
{
	if( !attacker.IsPlayer() || !victim.IsPlayer() || attacker == victim )
		return

	float returnTime = 30
	float farTime = 5
	int attackerTeam = attacker.GetTeam()

	bool inTime = false
	foreach( player in GetPlayerArrayOfTeam( victim.GetTeam() ) )
	{
		if( !IsValid(player) )
			continue
		
		if( !(attackerTeam in player.p.attackedTeam) )
			player.p.attackedTeam[ attackerTeam ] <- -returnTime
		
		if( attackerTeam in player.p.attackedTeam && Time() - player.p.attackedTeam[ attackerTeam ] <= returnTime )
			inTime = true
	}

	if( IsValid(weapon) )
	{
		if( Distance( attacker.GetOrigin(), victim.GetOrigin() ) >= 4000 && Time() - victim.p.attackedTeam[ attackerTeam ] >= farTime )
			PlayBattleChatterLineToSpeakerAndTeam( attacker, "bc_damageEnemy" )
		else if( !inTime )
			PlayBattleChatterLineToSpeakerAndTeam( attacker, "bc_engagingEnemy" )
	}

	foreach( player in GetPlayerArrayOfTeam( victim.GetTeam() ) )
	{
		if( attackerTeam in player.p.attackedTeam )
			player.p.attackedTeam[ attackerTeam ] = Time()
	}

	if( inTime )
		return

	int attackerTotalTeam = 0
	foreach( team, time in victim.p.attackedTeam )
		if( Time() - time < returnTime )
			attackerTotalTeam++
	
	if( attackerTotalTeam > 1 )
		PlayBattleChatterLineToSpeakerAndTeam( victim, "bc_anotherSquadAttackingUs" )
	else
		if( weapon == null )
			PlayBattleChatterLineToSpeakerAndTeam( victim, "bc_takingDamage" )
		else
			PlayBattleChatterLineToSpeakerAndTeam( victim, "bc_takingFire" )
}

array<ConsumableInventoryItem> function GetAllDroppableItems( entity player )
{
	array<ConsumableInventoryItem> final = []

	// Consumable inventory
	final.extend( SURVIVAL_GetPlayerInventory( player ) )

	// Weapon related items
	foreach ( weapon in SURVIVAL_GetPrimaryWeapons( player ) )
	{
		LootData data = SURVIVAL_GetLootDataFromWeapon( weapon )
		if ( data.ref == "" )
			continue

		// Add the weapon
		ConsumableInventoryItem item

		item.type = data.index
		item.count = weapon.GetWeaponPrimaryClipCount()

		final.append( item )

		foreach ( esRef, mod in GetAllWeaponAttachments( weapon ) )
		{
			if ( !SURVIVAL_Loot_IsRefValid( mod ) )
				continue

			if ( data.baseMods.contains( mod ) )
				continue

			LootData attachmentData = SURVIVAL_Loot_GetLootDataByRef( mod )

			// Add the attachment
			ConsumableInventoryItem attachmentItem

			attachmentItem.type = attachmentData.index
			attachmentItem.count = 1

			final.append( attachmentItem )
		}
	}

	// Non-weapon equipment slots
	foreach ( string ref, EquipmentSlot es in EquipmentSlot_GetAllEquipmentSlots() )
	{
		if ( EquipmentSlot_IsMainWeaponSlot( ref ) || EquipmentSlot_IsAttachmentSlot( ref ) )
			continue

		LootData data = EquipmentSlot_GetEquippedLootDataForSlot( player, ref )
		if ( data.ref == "" )
			continue

		// Add the equipped loot
		ConsumableInventoryItem equippedItem

		equippedItem.type = data.index
		equippedItem.count = 1

		final.append( equippedItem )
	}

	return final
}

void function CreateSurvivalDeathBoxForPlayer( entity victim, entity attacker, var damageInfo )
{
	entity deathBox = SURVIVAL_CreateDeathBox( victim, true )

	foreach ( invItem in GetAllDroppableItems( victim ) )
	{
		LootData data = SURVIVAL_Loot_GetLootDataByIndex( invItem.type )

		entity loot = SpawnGenericLoot( data.ref, deathBox.GetOrigin(), deathBox.GetAngles(), invItem.count )
		AddToDeathBox( loot, deathBox )
	}

	UpdateDeathBoxHighlight( deathBox )

	foreach ( func in svGlobal.onDeathBoxSpawnedCallbacks )
		func( deathBox, attacker, damageInfo != null ? DamageInfo_GetDamageSourceIdentifier( damageInfo ) : 0 )
}

void function OnPlayerKilled_DropLoot( entity player, entity attacker, var damageInfo )
{
	// Don't drop player loot upon death for Firing Range.
	if ( Gamemode() != eGamemodes.SURVIVAL )
		return

	if ( GetGameState() >= eGameState.Playing )
		thread SURVIVAL_Death_DropLoot( player, damageInfo )
}

void function OnPlayerKilled( entity victim, entity attacker, var damageInfo )
{
	if ( !IsValid( victim ) || !IsValid( attacker ) || !victim.IsPlayer() )
		return

	int attackerEHandle = -1
	int victimEHandle = -1
	
	if( attacker.IsPlayer() && !IsFiringRangeGameMode() )
	{
		attackerEHandle = attacker ? attacker.GetEncodedEHandle() : -1
		victimEHandle = victim ? victim.GetEncodedEHandle() : -1
	}

	SetPlayerEliminated( victim )

	if ( Flowstate_PlayerDoesRespawn() )
	{
		thread function() : ( victim )
		{
			wait GetDeathCamLength()
			
			if( !IsValid(victim) )
				return
			
			//SetRandomStagingPositionForPlayer( victim )
			DecideRespawnPlayer( victim )
		}()

		return
	}

	int victimTeamNum = victim.GetTeam()
	array<entity> victimTeam = GetPlayerArrayOfTeam_Alive( victimTeamNum )
	bool teamEliminated = victimTeam.len() == 0
	bool canPlayerBeRespawned = PlayerRespawnEnabled() && !teamEliminated

	// PlayerFullyDoomed MUST be called before HandleSquadElimination
	// HandleSquadElimination accesses player.p.respawnChanceExpiryTime which is set by PlayerFullyDoomed
	// if it isn't called in this order, the survivalTime will be 0
	if ( !canPlayerBeRespawned )
	{
		PlayerFullyDoomed( victim )
	}

	if ( teamEliminated )
	{
		HandleSquadElimination( victimTeamNum )
		thread PlayerStartSpectating( victim, attacker, true, victimTeamNum, false, attackerEHandle)	
	} else
		thread PlayerStartSpectating( victim, attacker, false, 0, false, attackerEHandle)	
	
	// Restore weapons for deathbox
	if ( victim.p.storedWeapons.len() > 0 )
		RetrievePilotWeapons( victim )
	
	// int droppableItems = GetAllDroppableItems( victim ).len()

	// if ( canPlayerBeRespawned || droppableItems > 0 )
		// CreateSurvivalDeathBoxForPlayer( victim, attacker, damageInfo )// changed to s21 behavior. Café

	thread EnemyKilledDialogue( attacker, victimTeamNum, victim )
}

void function EnemyKilledDialogue( entity attacker, int victimTeam, entity victim )
{
	if( !attacker.IsPlayer() || attacker == victim )
		return
	
	attacker.p.killedEnemy++

	string dialogue = ""
	string responseName = ""
	entity responsePlayer = null
	float delay = 2
	int currentKilledEnemy = attacker.p.killedEnemy

	if( GetPlayerArrayOfTeam_Alive( victimTeam ).len() == 0 )
	{
		dialogue = "bc_squadTeamWipe"
		responseName = "bc_congratsKill"
		responsePlayer = TryFindSpeakingPlayerOnTeamDisallowSelf( attacker.GetTeam(), attacker )
	}
	else if( attacker.p.killedEnemy > 1 )
		dialogue = "bc_megaKill"
	else
		dialogue = "bc_iKilledAnEnemy"

	wait delay

	if( attacker.p.killedEnemy == currentKilledEnemy )
	{
		PlayBattleChatterLineToSpeakerAndTeam( attacker, dialogue )
		if( responsePlayer != null )
			PlayBattleChatterLineToSpeakerAndTeam( responsePlayer, responseName )
		
		attacker.p.killedEnemy = 0
	}
}

void function OnClientConnected( entity player )
{
	array<entity> playerTeam = GetPlayerArrayOfTeam( player.GetTeam() )
	
	bool isAlone = playerTeam.len() <= 1

	playerTeam.fastremovebyvalue( player )
	player.p.squadRank = 0

	if( GetCurrentPlaylistVarBool( "lsm_mod4", false ) )
	{
		AddPlayerMovementEventCallback( player, ePlayerMovementEvents.TOUCH_GROUND, LSM_OnPlayerTouchGround )
		AddPlayerMovementEventCallback( player, ePlayerMovementEvents.LEAVE_GROUND, LSM_OnPlayerLeaveGround )
	}

	AddEntityCallback_OnDamaged( player, OnPlayerDamaged )
	
	if ( IsFiringRangeGameMode() )
	{
		SetRandomStagingPositionForPlayer( player )
		DecideRespawnPlayer( player )
		GiveBasicSurvivalItems( player )
		return	
	} 
	else if ( IsSurvivalTraining() )
	{
		DecideRespawnPlayer( player )
		thread PlayerStartsTraining( player )
		return
	} 
	else if( Playlist() == ePlaylists.survival_dev || Playlist() == ePlaylists.dev_default || GetCurrentPlaylistVarBool( "is_practice_map", false ) || Playlist() == ePlaylists.fs_movementrecorder )
	{
		vector origin
		if( GetPlayerArray_Alive().len() > 0 )
			origin = GetPlayerArray_Alive()[0].GetOrigin()
		
		PlayerMatchState_Set( player, ePlayerMatchState.NORMAL )
		
		if( !GetCurrentPlaylistVarBool( "is_practice_map", false ) )
		{
			Flowstate_AssignUniqueCharacterForPlayer(player, true)
			player.SetOrigin( origin )
		}
		
		DecideRespawnPlayer( player )
		GiveBasicSurvivalItems( player )
		return		
	}

	switch ( GetGameState() )
	{
		// case eGameState.WaitingForPlayers:
		
		// break
		case eGameState.Prematch:
			if ( IsValid( Sur_GetPlaneEnt() ) )
				RespawnPlayerInDropship( player )
				printt( "connected prematch" )
			break
		case eGameState.Playing:
			if ( !player.GetPlayerNetBool( "hasLockedInCharacter" ) )
			{
				Flowstate_AssignUniqueCharacterForPlayer(player, true)
			}
			
			if ( IsFiringRangeGameMode() )
			{
				PlayerMatchState_Set( player, ePlayerMatchState.STAGING_AREA )

				SetRandomStagingPositionForPlayer( player )
				DecideRespawnPlayer( player )
			}
			else if ( Flag( "SpawnInDropship" ) && IsValid( Sur_GetPlaneEnt() ) )
			{
				RespawnPlayerInDropship( player )
				printt( "connected dropship playing" )
			}
			else if( GetPlayerArray_Alive().len() > 0 ) //player connected mid game, start spectating
			{
				array<entity> players = clone GetPlayerArray_Alive()
				players.fastremovebyvalue( player )

				if( players.len() == 0 )
					return

				entity target = players.getrandom()

				if( !ShouldSetObserverTarget( target ) )
					return

				PlayerMatchState_Set( player, ePlayerMatchState.NORMAL )
				Remote_CallFunction_NonReplay( player, "ServerCallback_ShowDeathScreen" )
				player.SetPlayerNetInt( "spectatorTargetCount", players.len() )
				player.SetSpecReplayDelay( 1 )
				player.StartObserverMode( OBS_MODE_IN_EYE )
				player.SetObserverTarget( target )
				player.SetPlayerCanToggleObserverMode( false )
				player.SetPlayerNetInt( "respawnStatus", eRespawnStatus.NONE )
			}

			break
		case eGameState.Epilogue:
			Remote_CallFunction_NonReplay( player, "ServerCallback_ShowWinningSquadSequence" )
			break
	}
}

void function Survival_SetFriendlyOwnerHighlight( entity player, entity characterModel )
{

}

void function SURVIVAL_AddSpawnPointGroup( string ref )
{

}

void function RateSpawnpoints_Directional( int checkClass, array<entity> spawnpoints, int team, entity player )
{

}

bool function SURVIVAL_IsCharacterClassLocked( entity player )
{
	int stepIndex = Playlist() == ePlaylists.fs_scenarios ? player.GetPlayerNetInt( "characterSelectLockstepIndex" ) : GetGlobalNetInt( "characterSelectLockstepIndex" )
	return player.GetPlayerNetBool( "hasLockedInCharacter" ) || player.GetPlayerNetInt( "characterSelectLockstepPlayerIndex" ) != stepIndex
}

bool function SURVIVAL_IsValidCircleLocation( vector origin )
{
	return false
}

int function _GetSquadRank( entity player )
{
	return player.p.squadRank
}

void function JetwashFX( entity dropship )
{

}

void function Survival_PlayerRespawnedTeammate( entity playerWhoRespawned, entity respawnedPlayer )
{
	playerWhoRespawned.p.respawnsGiven++

	respawnedPlayer.p.respawnChanceExpiryTime = 0.0
	ClearPlayerEliminated( respawnedPlayer )

	StatsHook_PlayerRespawnedTeammate( playerWhoRespawned, respawnedPlayer )
}

void function UpdateDeathBoxHighlight( entity box )
{
	int highestTier = 0

	foreach ( item in box.GetLinkEntArray() )
	{
		LootData data = SURVIVAL_Loot_GetLootDataByIndex( item.GetSurvivalInt() )
		if ( data.ref == "" )
			continue

		if ( data.tier > highestTier )
			highestTier = data.tier
	}

	box.SetNetInt( "lootRarity", highestTier )
	// Highlight_SetNeutralHighlight( box, SURVIVAL_GetHighlightForTier( highestTier ) ) //FIXME. Cafe

	foreach ( player in GetPlayerArray() )
		Remote_CallFunction_Replay( player, "ServerCallback_RefreshDeathBoxHighlight" )
}

//FIXME. Cafe
void function UpdateDeathBoxHighlight_Retail( entity box, bool longerHighlightDist = false )
{
	if ( !IsValid( box ) )
		return

	if ( box.e.blockActive )
		return

	// if ( box.GetScriptName() == BLACK_MARKET_SCRIPTNAME )
		// return

	// foreach ( func in file.onDeathboxLootUpdatedCallbacks )
	// {
		// func( box )
	// }

	array<entity> itemsInBox = box.GetLinkEntArray()

	if ( itemsInBox.len() > 0 )
	{
		int maxTier = 1
		foreach ( loot in itemsInBox )
		{
			LootData data = SURVIVAL_Loot_GetLootDataByRef( loot.e.lootRef )
			if ( data.tier > maxTier )
				maxTier = data.tier
		}

		box.SetNetInt( "maxLootTier", maxTier )
	}
	else
	{
		if ( box.GetTeam() == TEAM_UNASSIGNED )
		{
			vector o = box.GetOrigin()
			vector a = box.GetAngles()
			asset m  = box.GetModelName()
			entity p = box.GetParent()

			bool inBound = PositionIsInMapBounds( box.GetOrigin() )

			box.Destroy()

			if ( inBound )
			{
				entity newBox = CreatePropDynamic( m, o, a )
				if ( IsValid( p ) )
				{
					newBox.SetParent( p )
				}
				else
				{
					newBox.ClearParent()
				}
				EmitSoundAtPosition( TEAM_UNASSIGNED, o, "Object_Dissolve", newBox)
				newBox.Dissolve( ENTITY_DISSOLVE_CORE, < 0, 0, 0 >, 1000 )
			}

			return
		}
	}

	box.SetNetBool( "highlightFar", longerHighlightDist )
}

float function Survival_GetMapFloorZ( vector field )
{
	field.z = SURVIVAL_GetPlaneHeight()
	vector endOrigin = field - < 0, 0, 50000 >
	TraceResults traceResult = TraceLine( field, endOrigin, [], TRACE_MASK_NPCWORLDSTATIC, TRACE_COLLISION_GROUP_NONE )
	vector endPos = traceResult.endPos
	return endPos.z
}

vector function SURVIVAL_GetClosestValidCircleEndLocation( vector origin )
{
	return origin
}

void function SURVIVAL_CalculateAirdropPositions()
{
    calculatedAirdropData.clear()

    array<vector> previousAirdrops

    array<DeathFieldStageData> deathFieldData = SURVIVAL_GetDeathFieldStages()

    for ( int i = deathFieldData.len() - 1; i >= 0; i-- )
    {
        string airdropPlaylistData = GetCurrentPlaylistVarString( "airdrop_data_round_" + i, "" )

        if (airdropPlaylistData.len() == 0) //if no airdrop data for this ring, continue to next
            continue;

        //Split the PlaylistVar that we can parse it
        array<string> dataArr = split(airdropPlaylistData, ":" )
        if(dataArr.len() < 5)
            return;

        //First part of the playlist string is the number of airdrops for this round.
        int numAirdropsForThisRound = dataArr[0].tointeger()

        //Create our AirdropData entry now.
        AirdropData airdropData;
        airdropData.dropCircle = i
        airdropData.dropCount = numAirdropsForThisRound
        airdropData.preWait = dataArr[1].tofloat()

        //Get the deathfield data.
        DeathFieldStageData data = deathFieldData[i]

        vector center = data.endPos
        float radius = data.endRadius
        for (int j = 0; j < numAirdropsForThisRound; j++)
        {
            Point airdropPoint = FindRandomAirdropDropPoint(AIRDROP_ANGLE_DEVIATION, center, radius, previousAirdrops)

            if(!VerifyAirdropPoint( airdropPoint.origin, airdropPoint.angles.y % 360 ))
            {
                //force this to loop again if we didn't verify our airdropPoint
                j--;
            }
            else
            {
                previousAirdrops.push(airdropPoint.origin)
                //printt("Added airdrop with origin ", airdropPoint.origin, " to the array")
                airdropData.originArray.append(airdropPoint.origin)
                airdropData.anglesArray.append( Vector(airdropPoint.angles.x % 360, airdropPoint.angles.y % 360, airdropPoint.angles.z % 360) )

                //Should impl contents here.
                airdropData.contents.append([dataArr[2], dataArr[3], dataArr[4]])
            }
        }
        calculatedAirdropData.append(airdropData)
    }
    thread AirdropSpawnThink()
}

void function SURVIVAL_AddLootBin( entity lootbin )
{
	// InitLootBin( lootbin )
}

void function SURVIVAL_AddLootGroupRemapping( string hovertank, string supplyship )
{

}

void function SURVIVAL_DebugLoot( string lootBinsLootInside, vector origin )
{

}

void function Survival_AddCallback_OnAirdropLaunched( void functionref( entity dropPod, vector origin ) callbackFunc )
{

}

void function Survival_CleanupPlayerPermanents( entity player )
{

}

bool function IsValidLegendaryMagazine( string mod )
{
	switch( mod )
	{
		case "sniper_mag_l4":
		case "highcal_mag_l4":
		case "bullets_mag_l4":
		case "shotgun_bolt_l4":
		case "energy_mag_l4":
		
		return true
	}
	
	return false
}

void function Flowstate_CheckForLv4MagazinesAndRefillAmmo( entity player )
{
	if( !IsValid( player ) )
		return
	
	entity oldActiveWeapon
	entity activeWeapon

	while( IsValid( player ) )
	{
		wait 0.1
		
		if( !IsValid( player ) )
			break

		activeWeapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
		if( oldActiveWeapon == activeWeapon )
			continue

		oldActiveWeapon = activeWeapon

		array<entity> weapons = player.GetMainWeapons()

		foreach ( weapon in weapons )
		{
			if( !IsValid( weapon ) )
				continue
				
			if( weapon == player.GetActiveWeapon( eActiveInventorySlot.mainHand ) )
			{
				Signal( weapon, "Flowstate_RestartLv4MagazinesThread" )
				continue
			}

			string weaponRef = weapon.GetWeaponClassName()
			if ( !SURVIVAL_Loot_IsRefValid( weaponRef ) )
				continue

			LootData weaponData = SURVIVAL_Loot_GetLootDataByRef( weaponRef )
			if ( weaponData.lootType != eLootType.MAINWEAPON )
				continue

			array<string> mods = clone weapon.GetMods()
			
			foreach( mod in mods )
				if( IsValidLegendaryMagazine( mod ) )
					thread Flowstate_Lv4MagazinesRefillAmmo_Thread( player, weapon )
		}
	}
}

void function Flowstate_Lv4MagazinesRefillAmmo_Thread( entity player, entity weapon )
{
	Signal( weapon, "Flowstate_RestartLv4MagazinesThread" )
	EndSignal( weapon, "Flowstate_RestartLv4MagazinesThread" )
	EndSignal( weapon, "OnDestroy" )
	EndSignal( player, "OnDeath" )

	wait 5

	if( !IsValid( weapon ) || !IsValid( player ) || !IsAlive( player ) || weapon == player.GetActiveWeapon( eActiveInventorySlot.mainHand ) || !weapon.UsesClipsForAmmo() )
		return

	int ammoType = weapon.GetWeaponAmmoPoolType()
	string ammoRef = AmmoType_GetRefFromIndex( ammoType )
	int ammoInInventory = SURVIVAL_CountItemsInInventory( player, ammoRef )

	if( ammoInInventory == 0 )
		return

	int currentAmmo = weapon.GetWeaponPrimaryClipCount()
	int maxAmmo = weapon.GetWeaponSettingInt( eWeaponVar.ammo_clip_size )
	
	if( currentAmmo == maxAmmo )
		return

	int requiredAmmo = maxAmmo - currentAmmo
	int ammoToRemove = int( min( requiredAmmo, ammoInInventory ) )

	weapon.SetWeaponPrimaryClipCount( currentAmmo + ammoToRemove )
	SURVIVAL_RemoveFromPlayerInventory( player, ammoRef, ammoToRemove )
	weapon.SetWeaponPrimaryAmmoCount( AMMOSOURCE_POOL, min( SURVIVAL_CountItemsInInventory( player, ammoRef ), weapon.GetWeaponPrimaryAmmoCountMax( AMMOSOURCE_POOL ) ) )
	EmitSoundOnEntityOnlyToPlayer( player, player, "HUD_Boost_Card_Earned_1P" )
}

float MaxFallDistanceForDamage = 400.0

void function LSM_OnPlayerTouchGround( entity player )
{
	if( !player.e.IsFalling )
		return

	if ( player.IsNoclipping() )
		return

	player.e.IsFalling = false

	vector landingdist = <player.e.FallDamageJumpOrg.x, player.e.FallDamageJumpOrg.y, player.GetOrigin().z>
	float fallDist = Distance(player.e.FallDamageJumpOrg, landingdist)

	printf("Fall Distance: " + fallDist)

	if(fallDist < MaxFallDistanceForDamage)
		return

	float Damagemultiplier = 0.035

	if(fallDist > 1000)
		Damagemultiplier = 0.05
	
	player.TakeDamage( Damagemultiplier * fallDist, null, null, { damageSourceId=damagedef_suicide } )
}

void function LSM_OnPlayerLeaveGround( entity player )
{
	if( player.e.IsFalling )
		return

	if( player.IsNoclipping() )
		return

	player.e.IsFalling = true

	player.e.FallDamageJumpOrg = player.GetOrigin()
}