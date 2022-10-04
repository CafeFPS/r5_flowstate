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
global function Survival_SetCallback_Leviathan_ConsiderLookAtEnt
global function Survival_Leviathan_ConsiderLookAtEnt
global function CreateSurvivalDeathBoxForPlayer
global function UpdateMatchSummaryPersistentVars

int MAXBLOCKTIME = 2

struct
{
    void functionref( entity, float, float ) leviathanConsiderLookAtEntCallback = null
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
	AddClientCommandCallback("latency", ClientCommand_ShowLatency)
	AddCallback_GameStateEnter(
		eGameState.Playing,
		void function()
		{
			thread Sequence_Playing()
		}
	)

	thread SURVIVAL_RunArenaDeathField()
}

void function Survival_SetCallback_Leviathan_ConsiderLookAtEnt( void functionref( entity, float, float ) callback )
{
	file.leviathanConsiderLookAtEntCallback = callback
}

void function Survival_Leviathan_ConsiderLookAtEnt(entity ent)
{
    wait 1 //Wait until the ent has decided their direction
    if(file.leviathanConsiderLookAtEntCallback != null)
        file.leviathanConsiderLookAtEntCallback( ent, 10, 0.3 )
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
}

void function Sequence_Playing()
{
	SetServerVar( "minimapState", IsFiringRangeGameMode() ? eMinimapState.Hidden : eMinimapState.Default )

	if ( IsFiringRangeGameMode() || IsSurvivalTraining() )
	{
		SetGameState( eGameState.WaitingForPlayers )
		return
	}

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
		float DROP_TOTAL_TIME = GetCurrentPlaylistVarFloat( "survival_plane_jump_duration", 45.0 )
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
		MakeInvincible( player )
		Remote_CallFunction_NonReplay( player, "ServerCallback_PlayMatchEndMusic" )
		Remote_CallFunction_NonReplay( player, "ServerCallback_MatchEndAnnouncement", player.GetTeam() == GetWinningTeam(), GetWinningTeam() )
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
	//StatsHook_SquadEliminated( GetPlayerArrayOfTeam_Connected( team ) )

	UpdateMatchSummaryPersistentVars( team )

	foreach ( player in GetPlayerArray() )
		Remote_CallFunction_NonReplay( player, "ServerCallback_SquadEliminated", team )
}

// Fully doomed, no chance to respawn, game over
void function PlayerFullyDoomed( entity player )
{
	player.p.respawnChanceExpiryTime = Time()
	player.p.squadRank = Survival_GetCurrentRank( player )

	//StatsHook_RecordPlacementStats( player )
}

void function OnPlayerDamaged( entity victim, var damageInfo )
{
	if ( !IsValid( victim ) || !victim.IsPlayer() || Bleedout_IsBleedingOut( victim ) )
		return
	
	entity attacker = InflictorOwner( DamageInfo_GetAttacker( damageInfo ) )
	
	int sourceId = DamageInfo_GetDamageSourceIdentifier( damageInfo )
	if ( sourceId == eDamageSourceId.bleedout || sourceId == eDamageSourceId.human_execution )
		return
	
	HandleDeathRecapData(victim, damageInfo)
	
	float damage = DamageInfo_GetDamage( damageInfo )

	int currentHealth = victim.GetHealth()
	if ( !( DamageInfo_GetCustomDamageType( damageInfo ) & DF_BYPASS_SHIELD ) )
		currentHealth += victim.GetShieldHealth()
	
	vector damagePosition = DamageInfo_GetDamagePosition( damageInfo )
	int damageType = DamageInfo_GetCustomDamageType( damageInfo )

	StoreDamageHistoryAndUpdate( victim, Time() + 30, damage, damagePosition, damageType, sourceId, attacker )
	
	if ( currentHealth - damage <= 0 && PlayerRevivingEnabled() && !IsInstantDeath( damageInfo ) && Bleedout_AreThereAlivingMates( victim.GetTeam(), victim ) )
	{	
		if(!IsValid(attacker) || !IsValid(victim)) return
	
		if( GetGameState() >= eGameState.Playing && attacker.IsPlayer() && attacker != victim )
		{
			ScoreEvent event = GetScoreEvent( "Sur_DownedPilot" )

			Remote_CallFunction_NonReplay( attacker, "ServerCallback_ScoreEvent", event.eventId, event.pointValue, event.displayType, victim.GetEncodedEHandle(), GetTotalDamageTakenByPlayer( victim, attacker ), 0 )
		}

		foreach ( cbPlayer in GetPlayerArray() )
			Remote_CallFunction_Replay( cbPlayer, "ServerCallback_OnEnemyDowned", attacker, victim, damageType, sourceId )	
			
		// Add the cool splashy blood and big red crosshair hitmarker
		DamageInfo_AddCustomDamageType( damageInfo, DF_KILLSHOT )
	
		// Supposed to be bleeding
		Bleedout_StartPlayerBleedout( victim, attacker )

		// Notify the player of the damage (even though it's *technically* canceled and we're hijacking the damage in order to not make an alive 100hp player instantly dead with a well placed kraber shot)
		if (attacker.IsPlayer() && IsValid( attacker ))
        {
            attacker.NotifyDidDamage( victim, DamageInfo_GetHitBox( damageInfo ), damagePosition, damageType, damage, DamageInfo_GetDamageFlags( damageInfo ), DamageInfo_GetHitGroup( damageInfo ), DamageInfo_GetWeapon( damageInfo ), DamageInfo_GetDistFromAttackOrigin( damageInfo ) )
        }
		// Cancel the damage
		// Setting damage to 0 cancels all knockback, setting it to 1 doesn't
		// There might be a better way to do this, but this works well enough
		DamageInfo_SetDamage( damageInfo, 1 )

		// Delete any shield health remaining
		victim.SetShieldHealth( 0 )
	}
}

void function HandleDeathRecapData(entity victim, var damageInfo)
//By CaféDeColombiaFPS
{	
	entity attacker = DamageInfo_GetAttacker( damageInfo )
	if(!attacker.IsPlayer()) return //fix abilities? implement damageSourceId and scriptDamageType
	
	entity weapon = DamageInfo_GetWeapon( damageInfo )
	
	int attackerEHandle = attacker ? attacker.GetEncodedEHandle() : -1
	int victimEHandle = victim ? victim.GetEncodedEHandle() : -1
	int scriptDamageType = DamageInfo_GetCustomDamageType( damageInfo )
	int damageSourceId = DamageInfo_GetDamageSourceIdentifier( damageInfo )
	float damageInflicted = DamageInfo_GetDamage( damageInfo )
	bool isValidHeadShot = IsValidHeadShot( damageInfo, victim )
	float shieldHealthFrac = GetShieldHealthFrac( victim )
	float healthFrac = GetHealthFrac( victim )

	if ( weapon == attacker.p.DeathRecap_PreviousShotWeapon && victim == attacker.p.DeathRecap_PreviousShotEnemyPlayer ) //Time() < attacker.p.DeathRecap_BlockTime + MAXBLOCKTIME && 
	{
		//Register Data
		attacker.p.DeathRecap_DataToSend.attackerEHandle = attackerEHandle
		attacker.p.DeathRecap_DataToSend.victimEHandle = victimEHandle
		attacker.p.DeathRecap_DataToSend.damageSourceID = damageSourceId
		attacker.p.DeathRecap_DataToSend.damageType = scriptDamageType
		attacker.p.DeathRecap_DataToSend.totalDamage += int(damageInflicted)
		attacker.p.DeathRecap_DataToSend.hitCount++
		if(isValidHeadShot)
			attacker.p.DeathRecap_DataToSend.headShotBits++
		attacker.p.DeathRecap_DataToSend.healthFrac += shieldHealthFrac
		attacker.p.DeathRecap_DataToSend.shieldFrac += healthFrac
		attacker.p.DeathRecap_DataToSend.blockTime = attacker.p.DeathRecap_BlockTime
	}
	else
	{
		if(weapon != attacker.p.DeathRecap_PreviousShotWeapon || victim != attacker.p.DeathRecap_PreviousShotEnemyPlayer) // || Time() >= attacker.p.DeathRecap_BlockTime + MAXBLOCKTIME )
		{
			if(victimEHandle != -1  && victim.p.DeathRecap_PreviousShotEnemyPlayer != null && victim.p.DeathRecap_PreviousShotEnemyPlayer.GetEncodedEHandle() && victim.p.DeathRecap_DataToSend.totalDamage > 0)
			{
				Remote_CallFunction_NonReplay( victim, "ServerCallback_SendDeathRecapData", victimEHandle, victim.p.DeathRecap_PreviousShotEnemyPlayer.GetEncodedEHandle(), victim.p.DeathRecap_DataToSend.damageSourceID, victim.p.DeathRecap_DataToSend.damageType, victim.p.DeathRecap_DataToSend.totalDamage, victim.p.DeathRecap_DataToSend.hitCount, victim.p.DeathRecap_DataToSend.headShotBits, victim.p.DeathRecap_DataToSend.healthFrac, victim.p.DeathRecap_DataToSend.shieldFrac, victim.p.DeathRecap_DataToSend.blockTime )
				ResetDeathRecapBlock(victim)
			}
			if(attackerEHandle != -1 && victimEHandle != -1 && attacker.p.DeathRecap_DataToSend.totalDamage > 0)
			{
				Remote_CallFunction_NonReplay( victim, "ServerCallback_SendDeathRecapData", attackerEHandle, victimEHandle, attacker.p.DeathRecap_DataToSend.damageSourceID, attacker.p.DeathRecap_DataToSend.damageType, attacker.p.DeathRecap_DataToSend.totalDamage, attacker.p.DeathRecap_DataToSend.hitCount, attacker.p.DeathRecap_DataToSend.headShotBits, attacker.p.DeathRecap_DataToSend.healthFrac, attacker.p.DeathRecap_DataToSend.shieldFrac, attacker.p.DeathRecap_DataToSend.blockTime )
				ResetDeathRecapBlock(attacker)		
			}
			
		}
		
		//Save weapon and player before sending data, so next shot we'll see if it's the same to create a new block
		attacker.p.DeathRecap_PreviousShotWeapon = weapon
		attacker.p.DeathRecap_PreviousShotEnemyPlayer = victim
		
		//Restart time 
		attacker.p.DeathRecap_BlockTime = Time()

		//Register First Shot Data
		attacker.p.DeathRecap_DataToSend.attackerEHandle = attackerEHandle
		attacker.p.DeathRecap_DataToSend.victimEHandle = victimEHandle
		attacker.p.DeathRecap_DataToSend.damageSourceID = damageSourceId
		attacker.p.DeathRecap_DataToSend.damageType = scriptDamageType
		attacker.p.DeathRecap_DataToSend.totalDamage += int(damageInflicted)
		attacker.p.DeathRecap_DataToSend.hitCount++
		if(isValidHeadShot)
			attacker.p.DeathRecap_DataToSend.headShotBits++
		attacker.p.DeathRecap_DataToSend.healthFrac += shieldHealthFrac
		attacker.p.DeathRecap_DataToSend.shieldFrac += healthFrac
		attacker.p.DeathRecap_DataToSend.blockTime = attacker.p.DeathRecap_BlockTime
	}
}

void function ResetDeathRecapBlock(entity attacker)
{
	attacker.p.DeathRecap_DataToSend.attackerEHandle = 0
	attacker.p.DeathRecap_DataToSend.victimEHandle = 0
	attacker.p.DeathRecap_DataToSend.damageSourceID = 0
	attacker.p.DeathRecap_DataToSend.damageType = 0
	attacker.p.DeathRecap_DataToSend.totalDamage = 0
	attacker.p.DeathRecap_DataToSend.hitCount = 0
	attacker.p.DeathRecap_DataToSend.headShotBits = 0
	attacker.p.DeathRecap_DataToSend.healthFrac = 0
	attacker.p.DeathRecap_DataToSend.shieldFrac = 0
	attacker.p.DeathRecap_DataToSend.blockTime = 0
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

void function OnPlayerKilled( entity victim, entity attacker, var damageInfo )
{
	if ( !IsValid( victim ) || !IsValid( attacker ) || !victim.IsPlayer() )
		return

	if( victim.GetObserverTarget() != null )
		victim.SetObserverTarget( null )

	victim.StartObserverMode( OBS_MODE_DEATHCAM )
	
	if( attacker.IsPlayer() )
	{
		int attackerEHandle = attacker ? attacker.GetEncodedEHandle() : -1
		int victimEHandle = victim ? victim.GetEncodedEHandle() : -1	
			
		if(victimEHandle != -1  && victim.p.DeathRecap_PreviousShotEnemyPlayer != null && victim.p.DeathRecap_PreviousShotEnemyPlayer.GetEncodedEHandle() && victim.p.DeathRecap_DataToSend.totalDamage > 0)
		{
			Remote_CallFunction_NonReplay( victim, "ServerCallback_SendDeathRecapData", victimEHandle, victim.p.DeathRecap_PreviousShotEnemyPlayer.GetEncodedEHandle(), victim.p.DeathRecap_DataToSend.damageSourceID, victim.p.DeathRecap_DataToSend.damageType, victim.p.DeathRecap_DataToSend.totalDamage, victim.p.DeathRecap_DataToSend.hitCount, victim.p.DeathRecap_DataToSend.headShotBits, victim.p.DeathRecap_DataToSend.healthFrac, victim.p.DeathRecap_DataToSend.shieldFrac, victim.p.DeathRecap_DataToSend.blockTime )
			ResetDeathRecapBlock(victim)
		}
		if(attackerEHandle != -1 && victimEHandle != -1 && attacker.p.DeathRecap_DataToSend.totalDamage > 0)
		{
			Remote_CallFunction_NonReplay( victim, "ServerCallback_SendDeathRecapData", attackerEHandle, victimEHandle, attacker.p.DeathRecap_DataToSend.damageSourceID, attacker.p.DeathRecap_DataToSend.damageType, attacker.p.DeathRecap_DataToSend.totalDamage, attacker.p.DeathRecap_DataToSend.hitCount, attacker.p.DeathRecap_DataToSend.headShotBits, attacker.p.DeathRecap_DataToSend.healthFrac, attacker.p.DeathRecap_DataToSend.shieldFrac, attacker.p.DeathRecap_DataToSend.blockTime )
			ResetDeathRecapBlock(attacker)		
		}

		if(attackerEHandle != -1)
			Remote_CallFunction_NonReplay( victim, "ServerCallback_DeathRecapDataUpdated", true, attackerEHandle)	
		
	}
	SetPlayerEliminated( victim )

	if ( IsFiringRangeGameMode() )
	{
		thread function() : ( victim )
		{
			wait 5.0

			SetRandomStagingPositionForPlayer( victim )
			DecideRespawnPlayer( victim )
		}()

		return
	}

	int victimTeamNumber = victim.GetTeam()
	array<entity> victimTeam = GetPlayerArrayOfTeam_Alive( victimTeamNumber )
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
		thread PlayerStartSpectating( victim, attacker, true, victim.GetTeam())	
	} else
		thread PlayerStartSpectating( victim, attacker, false )	
	
	// Restore weapons for deathbox
	if ( victim.p.storedWeapons.len() > 0 )
		RetrievePilotWeapons( victim )
	
	int droppableItems = GetAllDroppableItems( victim ).len()

	if ( canPlayerBeRespawned || droppableItems > 0 )
		CreateSurvivalDeathBoxForPlayer( victim, attacker, damageInfo )
}

void function OnClientConnected( entity player )
{
	array<entity> playerTeam = GetPlayerArrayOfTeam( player.GetTeam() )
	
	bool isAlone = playerTeam.len() <= 1

	playerTeam.fastremovebyvalue( player )
	player.p.squadRank = 0

	AddEntityCallback_OnDamaged( player, OnPlayerDamaged )

	if ( IsFiringRangeGameMode() )
	{
		SetRandomStagingPositionForPlayer( player )
		DecideRespawnPlayer( player )
		return
	} else if ( IsSurvivalTraining() )
	{
		DecideRespawnPlayer( player )
		thread PlayerStartsTraining( player )
		return
	}

	switch ( GetGameState() )
	{
		// case eGameState.WaitingForPlayers:
		
		// break
		case eGameState.Prematch:
			if ( IsValid( Sur_GetPlaneEnt() ) )
				RespawnPlayerInDropship( player )

			break
		case eGameState.Playing:
			if ( !player.GetPlayerNetBool( "hasLockedInCharacter" ) )
			{
				array<ItemFlavor> characters = GetAllCharacters()
				CharacterSelect_AssignCharacter( ToEHI( player ), characters.getrandom() )
			}
			
			if ( IsFiringRangeGameMode() )
			{
				PlayerMatchState_Set( player, ePlayerMatchState.STAGING_AREA )

				SetRandomStagingPositionForPlayer( player )
				DecideRespawnPlayer( player )
			}
			else if ( Flag( "SpawnInDropship" ) )
				RespawnPlayerInDropship( player )
			else
			{
				PlayerMatchState_Set( player, ePlayerMatchState.NORMAL )

				if ( IsPlayerEliminated( player ) )
					thread PlayerStartSpectating( player, null, false, 0, true)
				else
				{
					
					array<entity> beacons
					
					foreach(prop in GetEntArrayByClass_Expensive( "prop_dynamic" ))
						if(prop.GetTargetName() == RESPAWN_CHAMBER_TARGETNAME)
							beacons.append(prop)
		
					foreach(beacon in beacons)
						if(!SURVIVAL_PosInsideDeathField(beacon.GetOrigin()))
							beacons.fastremovebyvalue(beacon)
					
					if(beacons.len() == 0)
					{
						beacons.clear()
						beacons = GetPlayerArray_AliveConnected()
					}
					
					array<entity> respawnCandidates = isAlone ? beacons : playerTeam
					respawnCandidates.fastremovebyvalue( player )

					if ( respawnCandidates.len() == 0 )
					{
						Message(player, "NO SPAWN POINTS :(")
						break
					}
					vector origin = respawnCandidates.getrandom().GetOrigin()

					DecideRespawnPlayer( player )

					player.SetOrigin( origin )
					PutEntityInSafeSpot( player, null, null, player.GetOrigin() + <0,0,256>, origin )
				}
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

	//StatsHook_PlayerRespawnedTeammate( playerWhoRespawned, respawnedPlayer )
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
	Highlight_SetNeutralHighlight( box, SURVIVAL_GetHighlightForTier( highestTier ) )

	foreach ( player in GetPlayerArray() )
		Remote_CallFunction_Replay( player, "ServerCallback_RefreshDeathBoxHighlight" )
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
