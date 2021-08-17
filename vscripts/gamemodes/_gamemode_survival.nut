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

struct
{
} file

void function GamemodeSurvival_Init()
{
	SurvivalFreefall_Init()
	Sh_ArenaDeathField_Init()
	SurvivalShip_Init()

	FlagInit( "SpawnInDropship", false )
	FlagInit( "PlaneDrop_Respawn_SetUseCallback", false )

	AddCallback_OnPlayerKilled( OnPlayerKilled )
	AddCallback_OnClientConnected( OnClientConnected )

	AddCallback_GameStateEnter( 
		eGameState.Playing,
		void function()
		{
			thread Sequence_Playing()
		}
	)

	thread SURVIVAL_RunArenaDeathField()
}

void function RespawnPlayerInDropship( entity player )
{
	const float POS_OFFSET = -500.0 // Offset from dropship's origin

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

	player.SetPlayerNetBool( "isJumpingWithSquad", true )
	player.SetPlayerNetBool( "playerInPlane", true )

	PlayerMatchState_Set( player, ePlayerMatchState.SKYDIVE_PRELAUNCH )

	if ( Flag( "PlaneDrop_Respawn_SetUseCallback" ) )
		AddCallback_OnUseButtonPressed( player, Survival_DropPlayerFromPlane_UseCallback )

	array<entity> playerTeam = GetPlayerArrayOfTeam( player.GetTeam() )
	bool isAlone = playerTeam.len() <= 1

	if ( isAlone )
		player.SetPlayerNetBool( "isJumpmaster", true )
}

void function Sequence_Playing()
{
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

		// Show the squad and player counter
		UpdatePlayerCounts()
	}
	else
	{
		float DROP_TOTAL_TIME = GetCurrentPlaylistVarFloat( "survival_plane_jump_duration", 60.0 )
		float DROP_WAIT_TIME = GetCurrentPlaylistVarFloat( "survival_plane_jump_delay", 5.0 )
		float DROP_TIMEOUT_TIME = GetCurrentPlaylistVarFloat( "survival_plane_jump_timeout", 5.0 )

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

			if ( !foundJumpmaster ) // No eligible jumpmasters? Shouldn't happen, but just in case
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

		dropship.NonPhysicsMoveTo( shipEnd, DROP_TOTAL_TIME + DROP_WAIT_TIME + DROP_TIMEOUT_TIME, 0.0, 0.0 )

		wait CharSelect_GetOutroTransitionDuration()

		wait DROP_WAIT_TIME

		FlagSet( "PlaneDrop_Respawn_SetUseCallback" )

		foreach ( player in GetPlayerArray_AliveConnected() )
			AddCallback_OnUseButtonPressed( player, Survival_DropPlayerFromPlane_UseCallback )

		wait DROP_TOTAL_TIME

		FlagClear( "PlaneDrop_Respawn_SetUseCallback" )

		FlagClear( "SpawnInDropship" )

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

	if ( GetCurrentPlaylistVarBool( "survival_deathfield_enabled", true ) )
		FlagSet( "DeathCircleActive" )

	if ( !GetCurrentPlaylistVarBool( "match_ending_enabled", true ) || GetConVarInt( "mp_enablematchending" ) < 1 )
		WaitForever() // match never ending

	while ( GetGameState() == eGameState.Playing )
	{
		if ( GetNumTeamsRemaining() <= 1 )
		{
			int winnerTeam = GetTeamsForPlayers( GetPlayerArray_AliveConnected() )[0]
			level.nv.winningTeam = winnerTeam

			SetGameState( eGameState.WinnerDetermined )
		}
		WaitFrame()
	}

	thread Sequence_WinnerDetermined()
}

void function Sequence_WinnerDetermined()
{
	FlagSet( "DeathFieldPaused" )

	foreach ( player in GetPlayerArray() )
	{
		Remote_CallFunction_NonReplay( player, "ServerCallback_PlayMatchEndMusic" )
		Remote_CallFunction_NonReplay( player, "ServerCallback_MatchEndAnnouncement", player.GetTeam() == GetWinningTeam(), GetWinningTeam() )
	}

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
}

// Fully doomed, no chance to respawn, game over
void function PlayerFullyDoomed( entity player )
{
	player.p.respawnChanceExpiryTime = Time()
	player.p.squadRank = Survival_GetCurrentRank( player )

	StatsHook_RecordPlacementStats( player )
}

void function OnPlayerDamaged( entity victim, var damageInfo )
{
	if ( !IsValid( victim ) || !victim.IsPlayer() || Bleedout_IsBleedingOut( victim ) )
		return

	int sourceId = DamageInfo_GetDamageSourceIdentifier( damageInfo )
	
	// Trigger_Hurt fix
	entity inflictor = DamageInfo_GetInflictor(damageInfo);
	if(sourceId == eDamageSourceId.invalid && inflictor != null && inflictor.GetClassName() == "trigger_hurt" && inflictor.HasKey("damageSourceName"))
		DamageInfo_SetDamageSourceIdentifier(damageInfo, eDamageSourceId[expect string(inflictor.kv.damageSourceName)])
	
	if ( sourceId == eDamageSourceId.bleedout || sourceId == eDamageSourceId.human_execution )
		return

	float damage = DamageInfo_GetDamage( damageInfo )

	int currentHealth = victim.GetHealth()
	if ( !( DamageInfo_GetCustomDamageType( damageInfo ) & DF_BYPASS_SHIELD ) )
		currentHealth += victim.GetShieldHealth()

	if ( currentHealth - damage <= 0 
		&& PlayerRevivingEnabled() )
	{
		// Supposed to be bleeding
		//Bleedout_StartPlayerBleedout( victim, DamageInfo_GetAttacker( damageInfo ) )

		// Cancel the damage
		//DamageInfo_SetDamage( damageInfo, 0 )
	}
}

void function OnPlayerKilled( entity victim, entity attacker, var damageInfo )
{
	if ( !IsValid( victim ) || !IsValid( attacker ) )
		return

	if ( victim.IsPlayer() )
	{
		SetPlayerEliminated( victim )
		PlayerStartSpectating( victim, attacker )

		int victimTeamNumber = victim.GetTeam()
		array<entity> victimTeam = GetPlayerArrayOfTeam_Alive( victimTeamNumber )
		bool teamEliminated = victimTeam.len() == 0

		if ( teamEliminated )
			HandleSquadElimination( victim.GetTeam() )

		if ( !PlayerRespawnEnabled() )
			PlayerFullyDoomed( victim )
		else
			printt( "!!! Respawns are enabled! This is TODO" )
	}
}

void function OnClientConnected( entity player )
{
	array<entity> playerTeam = GetPlayerArrayOfTeam( player.GetTeam() )
	bool isAlone = playerTeam.len() <= 1

	playerTeam.fastremovebyvalue( player )

	player.p.squadRank = 0

	AddEntityCallback_OnDamaged( player, OnPlayerDamaged )

	switch ( GetGameState() )
	{
		case eGameState.Prematch:
			if ( IsValid( Sur_GetPlaneEnt() ) )
				RespawnPlayerInDropship( player )

			break
		case eGameState.Playing:
			if ( !player.GetPlayerNetBool( "hasLockedInCharacter" ) )
				// Joined too late, assign a random legend so everything runs fine
				CharacterSelect_TryAssignCharacterCandidatesToPlayer( player, [] )

			if ( Flag( "SpawnInDropship" ) )
				RespawnPlayerInDropship( player )
			else
			{
				PlayerMatchState_Set( player, ePlayerMatchState.NORMAL )

				if ( IsPlayerEliminated( player ) )
					PlayerStartSpectating( player, null )
				else
				{
					array<entity> respawnCandidates = isAlone ? GetPlayerArray_AliveConnected() : playerTeam
					respawnCandidates.fastremovebyvalue( player )

					if ( respawnCandidates.len() == 0 )
						break

					vector origin = respawnCandidates.getrandom().GetOrigin()

					DecideRespawnPlayer( player )

					player.SetOrigin( origin )
				}
			}

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
	return player.GetPlayerNetBool( "hasLockedInCharacter" ) || player.GetPlayerNetInt( "characterSelectLockstepPlayerIndex" ) != GetGlobalNetInt( "characterSelectLockstepIndex" )
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
            
            if(!VerifyAirdropPoint( airdropPoint.origin, airdropPoint.angles.y ))
            {
                //force this to loop again if we didn't verify our airdropPoint
                j--;
            }
            else
            {
                previousAirdrops.push(airdropPoint.origin)
                printt("Added airdrop with origin ", airdropPoint.origin, " to the array")
                airdropData.originArray.append(airdropPoint.origin)
                airdropData.anglesArray.append(airdropPoint.angles)
                
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