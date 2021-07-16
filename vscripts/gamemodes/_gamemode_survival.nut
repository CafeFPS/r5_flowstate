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
// these probably doesn't belong here
global function DecideRespawnPlayer
//----------------------------------
global function Survival_GetMapFloorZ
global function SURVIVAL_GetClosestValidCircleEndLocation
global function SURVIVAL_CalculateAirdropPositions
global function SURVIVAL_AddLootBin
global function SURVIVAL_AddLootGroupRemapping
global function SURVIVAL_GetMultipleWeightedItemsFromGroup
global function SURVIVAL_DebugLoot
global function Survival_AddCallback_OnAirdropLaunched
global function Survival_CleanupPlayerPermanents
global function SURVIVAL_SetMapCenter
global function SURVIVAL_GetMapCenter

struct
{
	int connectedPlayerCount = 0
	bool minPlayersReached = false

	vector mapCenter = <0, 0, 0>

	bool planeDoorsOpen = false
} file

void function GamemodeSurvival_Init()
{
	SurvivalFreefall_Init()
	Sh_ArenaDeathField_Init()

	// init flags
	FlagInit( "DeathCircleActive", true )
	FlagInit( "Survival_LootSpawned", true )
	FlagInit( "PathFinished", false )

	RegisterSignal( "SwitchToOrdnance" )
	RegisterSignal( "SwapToNextOrdnance" )

	#if R5DEV
	AddClientCommandCallback( "GoToMapPoint", ClientCommand_GoToMapPoint )
	#endif

	AddCallback_OnPlayerKilled( OnPlayerKilled )
	AddCallback_OnClientConnected( OnClientConnected )

	SetGameState( eGameState.WaitingForPlayers )

	AddCallback_ItemFlavorLoadoutSlotDidChange_AnyPlayer( Loadout_CharacterClass(), OnCharacterClassChanged )

	// Start the WaitingForPlayers sequence.
	// TODO: staging area support
	thread Sequence_WaitingForPlayers()
}

// Sequences
void function UpdateSequencedTimePoints( float referenceTime )
{
	switch ( GetGameState() )
	{
		case eGameState.WaitingForPlayers:
			SetGlobalNetTime( "PreGameStartTime", referenceTime + PreGame_GetWaitingForPlayersCountdown() )
			SetGlobalNetTime( "pickLoadoutGamestateStartTime", referenceTime + PreGame_GetWaitingForPlayersCountdown() + CharSelect_GetIntroTransitionDuration() + CharSelect_GetIntroCountdownDuration() )
			break
		case eGameState.PickLoadout:
			float timeBeforeCharacterSelection = CharSelect_GetIntroCountdownDuration() + CharSelect_GetPickingDelayBeforeAll()
		
			float timeToSelectAllCharacters = CharSelect_GetPickingDelayOnFirst()
			for ( int pickIndex = 0; pickIndex < MAX_TEAM_PLAYERS; pickIndex++ )
				timeToSelectAllCharacters += Survival_GetCharacterSelectDuration( pickIndex ) + CharSelect_GetPickingDelayAfterEachLock()
		
			float timeAfterCharacterSelection = CharSelect_GetPickingDelayAfterAll()

			float timeBeforeChampionPresentation = GetCurrentPlaylistVarInt( "survival_enable_squad_intro", 1 ) == 1 ? CharSelect_GetOutroSquadPresentDuration() : 0.0
			float timeAfterChampionPresentation = GetCurrentPlaylistVarInt( "survival_enable_gladiator_intros", 1 ) == 1 ? CharSelect_GetOutroChampionPresentDuration() : 0.0
				
			SetGlobalNetTime( "squadPresentationStartTime", referenceTime + timeBeforeCharacterSelection + timeToSelectAllCharacters + timeAfterCharacterSelection )
			SetGlobalNetTime( "championSquadPresentationStartTime", referenceTime + timeBeforeCharacterSelection + timeToSelectAllCharacters + timeAfterCharacterSelection + timeBeforeChampionPresentation )
			SetGlobalNetTime( "pickLoadoutGamestateEndTime", referenceTime + timeBeforeCharacterSelection + timeToSelectAllCharacters + timeAfterCharacterSelection + timeBeforeChampionPresentation + timeAfterChampionPresentation )
			break
		case eGameState.Playing:
			float timeDoorOpenWait = GetCurrentPlaylistVarFloat( "survival_plane_jump_delay", 4.0 )
			float timeDoorCloseWait = GetCurrentPlaylistVarFloat( "survival_plane_jump_duration", 60.0 )

			SetGlobalNetTime( "PlaneDoorsOpenTime", referenceTime + timeDoorOpenWait )
			SetGlobalNetTime( "PlaneDoorsCloseTime", referenceTime + timeDoorOpenWait + timeDoorCloseWait )
			break
	}
}

void function Sequence_WaitingForPlayers()
{
	// Wait the absolute minimum delay, if required (0 by default)
	wait PreGame_GetWaitingForPlayersDelayMin()

	// Start to wait for players.
	// Countdown will be reached when the minimum amount of players join, or when the maximum delay is reached (if enabled).
	float timeSpentWaitingForPlayers = 0.0
	float maximumTimeToSpendToWaitForPlayers = PreGame_GetWaitingForPlayersDelayMax() - PreGame_GetWaitingForPlayersDelayMin()

	bool shouldNotWaitForever = maximumTimeToSpendToWaitForPlayers > 0.0 && !GetCurrentPlaylistVarBool( "wait_for_players_forever", false )

	while ( !file.minPlayersReached )
	{
		const float LOOP_INTERVAL = 0.1

		timeSpentWaitingForPlayers += LOOP_INTERVAL
		wait LOOP_INTERVAL

		if ( shouldNotWaitForever 
			&& timeSpentWaitingForPlayers >= maximumTimeToSpendToWaitForPlayers
			&& file.connectedPlayerCount > 0
			)
			break
	}

	// Update to make client aware of the countdown
	UpdateSequencedTimePoints( Time() )
	wait PreGame_GetWaitingForPlayersCountdown()

	thread Sequence_PickLoadout()
}

void function Sequence_PickLoadout()
{
	if ( !Survival_CharacterSelectEnabled() ) 
	{
		foreach ( player in GetPlayerArray() )
			CharacterSelect_TryAssignCharacterCandidatesToPlayer( player, [] ) // No candidates to force it to pick a random legend.

		thread Sequence_Prematch() 
		return
	}

	ScreenCoverTransition_AllPlayers( Time() + CharSelect_GetIntroTransitionDuration() )
	wait CharSelect_GetIntroTransitionDuration()

	SetGameState( eGameState.PickLoadout )

	// Assign character selection order to teams
	AssignLockStepOrder()

	// Update future time points now that the delays should be predictable
	UpdateSequencedTimePoints( Time() )

	// Signalize that character selection sequence should be started clientside
	SetGlobalNetBool( "characterSelectionReady", true )

	// TODO: character selection music

	wait CharSelect_GetIntroCountdownDuration()

	wait CharSelect_GetPickingDelayBeforeAll()

	for ( int pickIndex = 0; pickIndex < MAX_TEAM_PLAYERS; pickIndex++ )
	{
		float startTime = Time()

		float timeSpentOnSelection = Survival_GetCharacterSelectDuration( pickIndex ) + CharSelect_GetPickingDelayAfterEachLock()
		if ( pickIndex == 0 )
			timeSpentOnSelection += CharSelect_GetPickingDelayOnFirst()

		float endTime = startTime + timeSpentOnSelection

		SetGlobalNetInt( "characterSelectLockstepIndex", pickIndex )
		SetGlobalNetTime( "characterSelectLockstepStartTime", startTime )
		SetGlobalNetTime( "characterSelectLockstepEndTime", endTime )

		wait timeSpentOnSelection

		foreach ( player in GetAllPlayersOfLockstepIndex( pickIndex ) )
		{
			ItemFlavor selectedCharacter = LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_CharacterClass() )

			if ( player.GetPlayerNetBool( "hasLockedInCharacter" ) )
				CharacterSelect_AssignCharacter( player, selectedCharacter )
			else
				CharacterSelect_TryAssignCharacterCandidatesToPlayer( player, [ 
					player.GetPlayerNetInt( "characterSelectFocusIndex" ), // Last focused character
					ItemFlavor_GetGUID( selectedCharacter ) // Currently selected loadout character
				] )
		}
	}

	// Reset selection step to lock all character selection loadout slots
	SetGlobalNetInt( "characterSelectLockstepIndex", -1 )

	wait CharSelect_GetPickingDelayAfterAll()

	if ( GetCurrentPlaylistVarInt( "survival_enable_squad_intro", 1 ) == 1 )
		wait CharSelect_GetOutroSquadPresentDuration()
		
	thread Sequence_Prematch()
}

void function Sequence_Prematch()
{
	SetGameState( eGameState.Prematch )

	// Update future time points now that the delays should be predictable
	UpdateSequencedTimePoints( Time() )

	// Show the squad and player counter
	UpdateSquadNetCounts()

	if ( GetCurrentPlaylistVarInt( "survival_enable_gladiator_intros", 1 ) == 1 )
		wait CharSelect_GetOutroChampionPresentDuration()

	thread Sequence_Playing()
}

void function Sequence_Playing()
{
	SetGameState( eGameState.Playing )

	// Update future time points now that the delays should be predictable
	UpdateSequencedTimePoints( Time() )

	SetServerVar( "minimapState", true )

	if ( !GetCurrentPlaylistVarBool( "jump_from_plane_enabled", true ) )
	{
		vector pos = GetEnt( "info_player_start" ).GetOrigin()
		pos.z += 5
	
		int i = 0
		foreach ( player in GetPlayerArray() )
		{
			// circle
			float r = float(i) / float(GetPlayerArray().len()) * 2 * PI
			player.SetOrigin( pos + 500.0 * <sin( r ), cos( r ), 0.0> )
	
			DecideRespawnPlayer( player )
	
			i++
		}
	}
	else
	{
		const float POS_OFFSET = -500.0 // Offset from dropship's origin

		float DROP_TOTAL_TIME = GetCurrentPlaylistVarFloat( "survival_plane_jump_duration", 60.0 )
		float DROP_WAIT_TIME = GetCurrentPlaylistVarFloat( "survival_plane_jump_delay", 5.0 )
		float DROP_TIMEOUT_TIME = GetCurrentPlaylistVarFloat( "survival_plane_jump_timeout", 10.0 )

		array<vector> foundFlightPath = Survival_GeneratePlaneFlightPath()

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
		minimapPlaneEnt.SetParent( dropship )
		minimapPlaneEnt.Minimap_AlwaysShow( 0, null )
		SetTargetName( minimapPlaneEnt, "planeEnt" )
		DispatchSpawn( minimapPlaneEnt )

		vector dropshipPlayerOrigin = shipStart
		dropshipPlayerOrigin.z += POS_OFFSET

		foreach ( player in GetPlayerArray() )
		{
			DecideRespawnPlayer( player, false )

			player.SetParent( dropship )

			player.SetOrigin( dropshipPlayerOrigin )
			player.SetAngles( shipAngles )

			player.UnfreezeControlsOnServer()

			player.SetPlayerNetBool( "playerInPlane", true )
			player.SetPlayerNetBool( "isJumpingWithSquad", true )
		}

		foreach ( team in GetTeamsForPlayers( GetPlayerArray() ) )
		{
			// TODO: proper jumpmaster logic
			array<entity> teamMembers = GetPlayerArrayOfTeam(team)
			teamMembers[0].SetPlayerNetBool( "isJumpmaster", true )
		}

		dropship.NonPhysicsMoveTo( shipEnd, DROP_TOTAL_TIME + DROP_WAIT_TIME + DROP_TIMEOUT_TIME, 0.0, DROP_TIMEOUT_TIME )

		wait DROP_WAIT_TIME

		foreach ( player in GetPlayerArray_AliveConnected() )
			AddCallback_OnUseButtonPressed( player, Survival_DropPlayerFromPlane_UseCallback )

		file.planeDoorsOpen = true

		// TODO: squad jumpmaster reassignment and solo drop

		wait DROP_TOTAL_TIME

		file.planeDoorsOpen = false

		foreach ( player in GetPlayerArray() )
		{
			if ( player.GetPlayerNetBool( "playerInPlane" ) )
				Survival_DropPlayerFromPlane_UseCallback( player )
		}

		wait DROP_TIMEOUT_TIME

		centerEnt.Destroy()
		minimapPlaneEnt.Destroy()
		dropship.Destroy()
	}

	wait 5.0

	thread SURVIVAL_RunArenaDeathField()

	// TODO: match ending
}
// Sequences END

// Screen cover transition functions
void function ScreenCoverTransition_Player( entity player, float endTime )
{
	Remote_CallFunction_NonReplay( player, "ServerToClient_ScreenCoverTransition", endTime )
}

void function ScreenCoverTransition_AllPlayers( float endTime )
{
	foreach ( player in GetPlayerArray() )
		ScreenCoverTransition_Player( player, endTime )
}

void function UpdateSquadNetCounts()
{
	SetGlobalNetInt( "livingPlayerCount", GetPlayerArray_AliveConnected().len() )
	SetGlobalNetInt( "squadsRemainingCount", GetNumTeamsRemaining() )
}

void function OnPlayerKilled( entity victim, entity attacker, var damageInfo )
{
	if ( !IsValid( victim ) || !IsValid( attacker ) )
		return

	UpdateSquadNetCounts()

	if ( attacker.IsPlayer() && victim.IsPlayer() )
	{
		attacker.SetPlayerNetInt( "kills", attacker.GetPlayerNetInt( "kills" ) + 1 )
	}

	if ( victim.IsPlayer() )
	{
		SetPlayerEliminated( victim )
	}
}

void function OnClientConnected( entity client )
{
	file.connectedPlayerCount++

	SetGlobalNetInt( "connectedPlayerCount", file.connectedPlayerCount )

	int minPlayers = GetCurrentPlaylistVarInt( "min_players", 1 )
	
	if ( file.connectedPlayerCount >= minPlayers )
		file.minPlayersReached = true

	PlayerMatchState_Set( client, ePlayerMatchState.NORMAL )

	int teamMemberIndex = GetPlayerArrayOfTeam( client.GetTeam() ).len() - 1
	client.SetTeamMemberIndex( teamMemberIndex )

	switch ( GetGameState() )
	{
		case eGameState.WaitingForPlayers:
			entity startEnt = GetEnt( "info_player_start" )

			client.SetOrigin( startEnt.GetOrigin() )
			client.SetAngles( startEnt.GetAngles() )

			client.FreezeControlsOnServer()

			if ( PreGame_GetWaitingForPlayersSpawningEnabled() )
				DecideRespawnPlayer( client, false )
			break
	}
}

void function OnCharacterClassChanged( EHI playerEHI, ItemFlavor flavor )
{
	if ( GetGameState() == eGameState.PickLoadout )
		return

	entity player = FromEHI( playerEHI )
	if ( IsAlive( player ) ) {
		TakeAllWeapons( player )
		
		CharacterSelect_AssignCharacter( player, flavor, false )
		DecideRespawnPlayer( player )
	}
}

array<entity> function GetAllPlayersOfLockstepIndex( int index )
{
	array<entity> result = []

	foreach ( player in GetPlayerArray() )
		if ( player.GetPlayerNetInt( "characterSelectLockstepPlayerIndex" ) == index )
			result.append( player )

	return result
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
	return player.GetPlayerNetBool( "hasLockedInCharacter" ) || player.GetPlayerNetInt( "characterSelectLockstepPlayerIndex" ) != GetGlobalNetInt( "characterSelectLockstepIndex" )
}

bool function SURVIVAL_IsValidCircleLocation( vector origin )
{
	return false
}

int function _GetSquadRank ( entity player )
{
	return 1
}

void function JetwashFX( entity dropship )
{

}

void function Survival_PlayerRespawnedTeammate( entity playerWhoRespawned, entity respawnedPlayer )
{
	ClearPlayerEliminated( respawnedPlayer )
}

void function UpdateDeathBoxHighlight( entity box )
{

}

void function GiveLoadoutRelatedWeapons( entity player )
{
	ItemFlavor character = LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_CharacterClass() )

	// Shared
	player.GiveOffhandWeapon( CONSUMABLE_WEAPON_NAME, OFFHAND_SLOT_FOR_CONSUMABLES, [] )

	// Loadout meleeskin
	ItemFlavor meleeSkin = LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_MeleeSkin( character ) )
	player.GiveWeapon( MeleeSkin_GetMainWeaponClassname( meleeSkin ), WEAPON_INVENTORY_SLOT_PRIMARY_2 )
	player.GiveOffhandWeapon( MeleeSkin_GetOffhandWeaponClassname( meleeSkin ), OFFHAND_MELEE, [] )

	// Character related
	ItemFlavor tacticalAbility = CharacterClass_GetTacticalAbility( character )
	player.GiveOffhandWeapon( CharacterAbility_GetWeaponClassname( tacticalAbility ), OFFHAND_TACTICAL, [] )

	ItemFlavor ultimateAbility = CharacterClass_GetUltimateAbility( character )
	player.GiveOffhandWeapon( CharacterAbility_GetWeaponClassname( ultimateAbility ), OFFHAND_ULTIMATE, [] )

	ItemFlavor passiveAbility = CharacterClass_GetPassiveAbility( character )
	GivePassive( player, CharacterAbility_GetPassiveIndex( passiveAbility ) )
}

void function DecideRespawnPlayer( entity player, bool setPlayerSettings = true )
{
	DoRespawnPlayer( player, null )

	if ( setPlayerSettings )
	{
		table<string, string> possibleMods = {
			survival_jumpkit_enabled = "enable_doublejump",
			survival_wallrun_enabled = "enable_wallrun"
		}
	
		array<string> enabledMods = []
		foreach ( playlistVar, modName in possibleMods )
			if ( GetCurrentPlaylistVarBool( playlistVar, false ) )
				enabledMods.append( modName )
	
		ItemFlavor playerCharacter = LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_CharacterClass() )
		asset characterSetFile = CharacterClass_GetSetFile( playerCharacter )

		player.SetPlayerSettingsWithMods( characterSetFile, enabledMods )

		GiveLoadoutRelatedWeapons( player )

		player.SetPlayerNetBool( "pingEnabled", true )
	}

	player.SetHealth( 100 )
}

float function Survival_GetMapFloorZ( vector field )
{
	return 0.0
}

vector function SURVIVAL_GetClosestValidCircleEndLocation( vector origin )
{
	return origin
}

vector function SURVIVAL_CalculateAirdropPositions()
{
	// calculate airdrop pos here
	vector origin = <0, 0, 0>
	return origin
}

void function SURVIVAL_AddLootBin( entity lootbin )
{
	// InitLootBin( lootbin )
}

void function SURVIVAL_AddLootGroupRemapping( string hovertank, string supplyship )
{
	
}

array<string> function SURVIVAL_GetMultipleWeightedItemsFromGroup( string lootGroup, int numLootItems )
{
	array<string> group = ["TODO"]
	return group
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

vector function SURVIVAL_GetMapCenter()
{
	return file.mapCenter
}

void function SURVIVAL_SetMapCenter( vector center )
{
	file.mapCenter = center
}

bool function ClientCommand_GoToMapPoint( entity player, array<string> args )
{
	if ( !IsValid( player ) )
		return true

	float x = float( args[0] )
	float y = float( args[1] )
	float z = float( args[2] )

	vector origin = <x, y, z>

	if ( z == 0 )
	{
		origin = OriginToGround( <x, y, 20000> )
	}

	player.SetOrigin( origin )

	return true
}