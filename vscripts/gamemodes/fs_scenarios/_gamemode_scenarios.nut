// By @CafeFPS

global function Init_FS_Scenarios
global function FS_Scenarios_GroupToInProgressList
global function FS_Scenarios_ReturnGroupForPlayer
global function FS_Scenarios_RespawnIn3v3Mode
global function FS_Scenarios_Main_Thread

global function FS_Scenarios_GetInProgressGroupsMap
global function FS_Scenarios_GetPlayerToGroupMap
global function FS_Scenarios_GetGroundLootEnabled
global function FS_Scenarios_GetInventoryEmptyEnabled
global function FS_Scenarios_GetAmountOfTeams
global function FS_Scenarios_GetDeathboxesEnabled
global function FS_Scenarios_ForceAllRoundsToFinish
global function FS_Scenarios_GetDropshipEnabled
global function FS_Scenarios_SaveLocationFromLootSpawn
global function FS_Scenarios_SaveLootbinData
global function FS_Scenarios_SaveBigDoorData

#if TRACKER //demo only
global function TrackerStats_ScenariosKills
global function TrackerStats_ScenariosDeaths
#endif

#if DEVELOPER
global function Cafe_KillAllPlayers
global function Cafe_EndAllRounds
#endif

global struct scenariosGroupStruct
{
	int groupHandle
	array<entity> team1Players
	array<entity> team2Players
	array<entity> team3Players

	// save legends indexes ?

	soloLocStruct &groupLocStruct
	entity ring
	float calculatedRingRadius
	float currentRingRadius
	int slotIndex
	int team1Index = -1
	int team2Index = -1
	int team3Index = -1

	bool IsFinished = false
	float endTime
	bool showedEndMsg = false
	bool isReady = false

	// realm based ground loot system
	array<entity> groundLoot
	array<entity> lootbins
	array<entity> doors
	
	int trackedEntsArrayIndex
}

struct doorsData
{
	entity door
	vector origin
	vector angles

	bool linked
	vector linkOrigin
	vector linkAngles
}

struct bigDoorsData
{
	vector origin
	vector angles
	asset model
	string scriptname
}

struct lootbinsData
{
	vector origin
	vector angles
}

struct {
	table<int, scenariosGroupStruct> scenariosPlayerToGroupMap = {} //map for quick assessment
	table<int, scenariosGroupStruct> scenariosGroupsInProgress = {} //group map to group
	
	array<vector> allLootSpawnsLocations
	array<lootbinsData> allMapLootbins
	array<doorsData> allMapDoors
	array<bigDoorsData> allBigMapDoors

	array<entity> aliveDropships
	array<entity> aliveDeathboxes
} file

struct {
	bool fs_scenarios_dropshipenabled = false
	int fs_scenarios_playersPerTeam = -1
	int fs_scenarios_teamAmount = -1

	float fs_scenarios_default_radius_padding = 169
	float fs_scenarios_default_radius = 8000
	float fs_scenarios_maxIndividualMatchTime = 300

	// float fs_scenarios_max_queuetime = 150
	// int fs_scenarios_minimum_team_allowed = 1 // used only when max_queuetime is triggered
	// int fs_scenarios_maximum_team_allowed = 3
	
	bool fs_scenarios_ground_loot = false
	bool fs_scenarios_inventory_empty = false
	bool fs_scenarios_deathboxes_enabled = true
	bool fs_scenarios_bleedout_enabled = true
	bool fs_scenarios_show_death_recap_onkilled = true
	bool fs_scenarios_zonewars_ring_mode = false
	float fs_scenarios_zonewars_ring_ringclosingspeed = 1.0
} settings

array< bool > teamSlots

void function Init_FS_Scenarios()
{
	settings.fs_scenarios_dropshipenabled = GetCurrentPlaylistVarBool( "fs_scenarios_dropshipenabled", true )
	settings.fs_scenarios_maxIndividualMatchTime = GetCurrentPlaylistVarFloat( "fs_scenarios_maxIndividualMatchTime", 300.0 )
	settings.fs_scenarios_playersPerTeam = GetCurrentPlaylistVarInt( "fs_scenarios_playersPerTeam", 3 )
	settings.fs_scenarios_teamAmount = GetCurrentPlaylistVarInt( "fs_scenarios_teamAmount", 2 )
	// settings.fs_scenarios_max_queuetime = GetCurrentPlaylistVarFloat( "fs_scenarios_max_queuetime", 150.0 )
	// settings.fs_scenarios_minimum_team_allowed = GetCurrentPlaylistVarInt( "fs_scenarios_minimum_team_allowed", 1 ) // used only when max_queuetime is triggered
	// settings.fs_scenarios_maximum_team_allowed = GetCurrentPlaylistVarInt( "fs_scenarios_maximum_team_allowed", 3 )

	settings.fs_scenarios_ground_loot = GetCurrentPlaylistVarBool( "fs_scenarios_ground_loot", true )
	settings.fs_scenarios_inventory_empty = GetCurrentPlaylistVarBool( "fs_scenarios_inventory_empty", true )
	settings.fs_scenarios_deathboxes_enabled = GetCurrentPlaylistVarBool( "fs_scenarios_deathboxes_enabled", true )
	settings.fs_scenarios_bleedout_enabled = GetCurrentPlaylistVarBool( "fs_scenarios_bleedout_enabled", true )
	settings.fs_scenarios_show_death_recap_onkilled = GetCurrentPlaylistVarBool( "fs_scenarios_show_death_recap_onkilled", true )
	settings.fs_scenarios_zonewars_ring_mode = GetCurrentPlaylistVarBool( "fs_scenarios_zonewars_ring_mode", true )
	settings.fs_scenarios_zonewars_ring_ringclosingspeed =  GetCurrentPlaylistVarFloat( "fs_scenarios_zonewars_ring_ringclosingspeed", 1.0 )

	teamSlots.resize( 119 )
	teamSlots[ 0 ] = true
	teamSlots[ 1 ] = true
	teamSlots[ 2 ] = true
	
	for (int i = 1; i < teamSlots.len(); i++)
	{
		teamSlots[ i ] = false
	}
	SurvivalFreefall_Init()
	SurvivalShip_Init()

	AddClientCommandCallback("playerRequeue_CloseDeathRecap", ClientCommand_FS_Scenarios_Requeue )	
	
	RegisterSignal( "FS_EndDelayedThread" )
	AddSpawnCallback( "prop_death_box", FS_Scenarios_StoreAliveDeathbox )

	AddCallback_OnPlayerKilled( FS_Scenarios_OnPlayerKilled )
	AddCallback_OnClientConnected( FS_Scenarios_OnPlayerConnected )
	AddCallback_OnClientDisconnected( FS_Scenarios_OnPlayerDisconnected )

	AddCallback_FlowstateSpawnsInit( CustomSpawns )
}

bool function ClientCommand_FS_Scenarios_Requeue(entity player, array<string> args )
{
	if( !IsValid(player) )
		return false
	
	if( Time() < player.p.lastRequeueUsedTime + 3 )
	{
		return false
	}
	
	player.p.InDeathRecap = false
	player.p.lastRequeueUsedTime = Time()

	return true
}

void function FS_Scenarios_OnPlayerKilled( entity victim, entity attacker, var damageInfo )
{
	#if DEVELOPER
		printt( "[+] OnPlayerKilled Scenarios -", victim, "by", attacker )
	#endif

	if ( !IsValid( victim ) || !IsValid( attacker ) || !victim.IsPlayer() )
		return

	if( settings.fs_scenarios_show_death_recap_onkilled )
	{
		int attackerEHandle = -1
		int victimEHandle = -1

		if( attacker.IsPlayer() && !IsFiringRangeGameMode() )
		{
			attackerEHandle = attacker ? attacker.GetEncodedEHandle() : -1
			victimEHandle = victim ? victim.GetEncodedEHandle() : -1	
			entity previousShotEnemy = victim.p.DeathRecap_PreviousShotEnemyPlayer

			if(victimEHandle != -1 && IsValid( previousShotEnemy ) && previousShotEnemy.GetEncodedEHandle() && victim.p.DeathRecap_DataToSend.totalDamage > 0)
			{
				Remote_CallFunction_NonReplay( victim, "ServerCallback_SendDeathRecapData", victimEHandle, previousShotEnemy.GetEncodedEHandle(), victim.p.DeathRecap_DataToSend.damageSourceID, victim.p.DeathRecap_DataToSend.damageType, victim.p.DeathRecap_DataToSend.totalDamage, victim.p.DeathRecap_DataToSend.hitCount, victim.p.DeathRecap_DataToSend.headShotBits, victim.p.DeathRecap_DataToSend.healthFrac, victim.p.DeathRecap_DataToSend.shieldFrac, victim.p.DeathRecap_DataToSend.blockTime )
				ResetDeathRecapBlock(victim)
			}

			if(attackerEHandle != -1 && victimEHandle != -1 && attacker.p.DeathRecap_DataToSend.totalDamage > 0)
			{
				Remote_CallFunction_NonReplay( attacker, "ServerCallback_SendDeathRecapData", attackerEHandle, victimEHandle, attacker.p.DeathRecap_DataToSend.damageSourceID, attacker.p.DeathRecap_DataToSend.damageType, attacker.p.DeathRecap_DataToSend.totalDamage, attacker.p.DeathRecap_DataToSend.hitCount, attacker.p.DeathRecap_DataToSend.headShotBits, attacker.p.DeathRecap_DataToSend.healthFrac, attacker.p.DeathRecap_DataToSend.shieldFrac, attacker.p.DeathRecap_DataToSend.blockTime )
				Remote_CallFunction_NonReplay( victim, "ServerCallback_SendDeathRecapData", attackerEHandle, victimEHandle, attacker.p.DeathRecap_DataToSend.damageSourceID, attacker.p.DeathRecap_DataToSend.damageType, attacker.p.DeathRecap_DataToSend.totalDamage, attacker.p.DeathRecap_DataToSend.hitCount, attacker.p.DeathRecap_DataToSend.headShotBits, attacker.p.DeathRecap_DataToSend.healthFrac, attacker.p.DeathRecap_DataToSend.shieldFrac, attacker.p.DeathRecap_DataToSend.blockTime )
				ResetDeathRecapBlock(attacker)		
			}

			Remote_CallFunction_NonReplay( victim, "ServerCallback_DeathRecapDataUpdated", true, attackerEHandle)
		} else if( !attacker.IsPlayer() )
		{
			Remote_CallFunction_NonReplay( victim, "ServerCallback_DeathRecapDataUpdated", true, ge( 0 ).GetEncodedEHandle() )
		}
	}

	thread EnemyKilledDialogue( attacker, victim.GetTeam(), victim )
}

void function FS_Scenarios_OnPlayerConnected( entity player )
{
	#if DEVELOPER
		printt( "[+] OnPlayerConnected Scenarios -", player )
	#endif

	AddEntityCallback_OnDamaged( player, FS_Scenarios_OnPlayerDamaged )
}

void function FS_Scenarios_OnPlayerDamaged( entity victim, var damageInfo )
{
	if ( !IsValid( victim ) || !victim.IsPlayer() || Bleedout_IsBleedingOut( victim ) )
		return
	
	entity attacker = InflictorOwner( DamageInfo_GetAttacker( damageInfo ) )
	
	int sourceId = DamageInfo_GetDamageSourceIdentifier( damageInfo )
	if ( sourceId == eDamageSourceId.bleedout || sourceId == eDamageSourceId.human_execution || sourceId == eDamageSourceId.damagedef_despawn )
		return
	
	if( settings.fs_scenarios_show_death_recap_onkilled )
		Flowstate_HandleDeathRecapData(victim, damageInfo)
	
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
	
	if ( currentHealth - damage <= 0 && PlayerRevivingEnabled() && !IsInstantDeath( damageInfo ) && Bleedout_AreThereAlivingMates( victim.GetTeam(), victim ) && !IsDemigod( victim ) && settings.fs_scenarios_bleedout_enabled )
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

void function FS_Scenarios_OnPlayerDisconnected( entity player )
{
	#if DEVELOPER
		printt( "[+] OnPlayerDisconnected Scenarios -", player )
	#endif
	
	_CleanupPlayerEntities( player )
	HandleGroupIsFinished( player, null )

	if( player.p.handle in file.scenariosPlayerToGroupMap )
		delete file.scenariosPlayerToGroupMap[ player.p.handle ]
}

array<vector> function FS_Scenarios_GeneratePlaneFlightPathForGroup( scenariosGroupStruct group )
{
	soloLocStruct groupLocStruct = group.groupLocStruct
	vector center = groupLocStruct.Center
	int realm = group.slotIndex

	const float CENTER_DEVIATION = 2.0
	const float POINT_FINDER_MULTIPLIER = 200

	// Get a random point from map center within specified deviation
	vector dropshipCenterPoint = center // GetRandomCenter( center, 0.0, CENTER_DEVIATION )
	dropshipCenterPoint.z = SURVIVAL_GetPlaneHeight() / 2.5

	vector dropshipMovingAngle = <0, RandomFloatRange( 0.0, 360.0 ), 0>
	vector dropshipMovingForward = AnglesToForward( dropshipMovingAngle )

	vector startPos = ClampToWorldspace( dropshipCenterPoint - dropshipMovingForward* settings.fs_scenarios_default_radius )
	vector endPos = ClampToWorldspace( dropshipCenterPoint + dropshipMovingForward* settings.fs_scenarios_default_radius )

	return [ startPos, endPos, dropshipMovingAngle, dropshipCenterPoint ]
}

void function FS_Scenarios_StartDropshipMovement( scenariosGroupStruct group )
{
	if( !IsValid( group ) )
		return

	EndSignal( svGlobal.levelEnt, "FS_EndDelayedThread" )

	soloLocStruct groupLocStruct = group.groupLocStruct
	vector center = groupLocStruct.Center
	int realm = group.slotIndex

	array<vector> foundFlightPath = FS_Scenarios_GeneratePlaneFlightPathForGroup( group )

	vector shipStart = foundFlightPath[0]
	vector shipEnd = foundFlightPath[1]
	vector shipAngles = foundFlightPath[2]
	vector shipPathCenter = foundFlightPath[3]

	// entity centerEnt = CreatePropScript_NoDispatchSpawn( $"mdl/dev/empty_model.rmdl", shipPathCenter, shipAngles )
	// centerEnt.Minimap_AlwaysShow( 0, null )
	// SetTargetName( centerEnt, "pathCenterEnt" )
	// DispatchSpawn( centerEnt )

	// entity minimapPlaneEnt = CreatePropScript_NoDispatchSpawn( $"mdl/dev/empty_model.rmdl", dropship.GetOrigin(), dropship.GetAngles() )
	// minimapPlaneEnt.NotSolid()
	// minimapPlaneEnt.SetParent( dropship )
	// minimapPlaneEnt.Minimap_AlwaysShow( 0, null )
	// SetTargetName( minimapPlaneEnt, "planeEnt" )
	// DispatchSpawn( minimapPlaneEnt )

	entity dropship = Survival_CreatePlane( shipStart, shipAngles )

	FS_Scenarios_StoreAliveDropship( dropship )

	dropship.RemoveFromAllRealms()
	dropship.AddToRealm( realm )

	EndSignal( dropship, "OnDestroy" )

	array<entity> players
	players.extend( group.team1Players )
	players.extend( group.team2Players )
	players.extend( group.team3Players )

	OnThreadEnd(
		function() : ( players, dropship )
		{
			foreach ( player in players )
			{
				if ( player.GetPlayerNetBool( "playerInPlane" ) )
					Survival_DropPlayerFromPlane_UseCallback( player )
			}

			// centerEnt.Destroy()
			// minimapPlaneEnt.Destroy()
			// minimapPlaneEnt.ClearParent()
			try{
				ClearChildren( dropship, true )
				dropship.Destroy()
			}
			catch( e420 )
			{
				printt("DROPSHIP BUG CATCHED - DEBUG THIS, DID DROPSHIP HAVE BOTS?")
			}
		}
	)

	foreach ( team in GetTeamsForPlayers( players ) )
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

	foreach ( player in players )
		FS_Scenarios_RespawnPlayerInDropship( player, dropship )

	float DROP_TOTAL_TIME = 20 // GetCurrentPlaylistVarFloat( "survival_plane_jump_duration", 20.0 )

	dropship.NonPhysicsMoveTo( shipEnd, DROP_TOTAL_TIME, 0.0, 0.0 )

	foreach ( player in players )
		AddCallback_OnUseButtonPressed( player, Survival_DropPlayerFromPlane_UseCallback )

	wait DROP_TOTAL_TIME
}

void function FS_Scenarios_RespawnPlayerInDropship( entity player, entity dropship )
{
	const float POS_OFFSET = -525.0 // Offset from dropship's origin

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

	AddCallback_OnUseButtonPressed( player, Survival_DropPlayerFromPlane_UseCallback )

	array<entity> playerTeam = GetPlayerArrayOfTeam( player.GetTeam() )
	bool isAlone = playerTeam.len() <= 1

	if ( isAlone )
		player.SetPlayerNetBool( "isJumpmaster", true )

	// AddCinematicFlag( player, CE_FLAG_HIDE_MAIN_HUD_INSTANT )
}

void function FS_Scenarios_SaveBigDoorData( entity door )
{
	bigDoorsData bigDoor
	bigDoor.origin = door.GetOrigin()
	bigDoor.angles = door.GetAngles()
	bigDoor.model = door.GetModelName()
	bigDoor.scriptname = door.GetScriptName()
	
	file.allBigMapDoors.append( bigDoor )

	door.Destroy()
}

void function FS_Scenarios_SpawnBigDoorsForGroup( scenariosGroupStruct group )
{
	if( !IsValid( group ) )
		return

	soloLocStruct groupLocStruct = group.groupLocStruct
	vector center = groupLocStruct.Center
	int realm = group.slotIndex

	array< bigDoorsData > chosenSpawns
	int count = 0

	foreach( i, bigDoorsData data in file.allBigMapDoors )
	{
		if( Distance2D( data.origin, center) <= group.calculatedRingRadius )
			chosenSpawns.append( data )
	}
	
	foreach( i, bigDoorsData data in chosenSpawns )
	{
	    entity door = CreateEntity( "prop_dynamic" )
        {
            door.SetValueForModelKey( data.model )
            door.SetOrigin( data.origin )
            door.SetAngles( data.angles )
            door.SetScriptName( data.scriptname )
			SetTargetName( door, "flowstate_realms_doors_by_cafe" )
			door.kv.solid = SOLID_VPHYSICS
			door.AllowMantle()
			door.RemoveFromAllRealms()
			door.AddToRealm( realm )

            DispatchSpawn( door )

			group.doors.append( door )
			count++
        }
	}
	#if DEVELOPER
		printt( "created", count, "big doors for group", group.groupHandle )
	#endif
}

void function FS_Scenarios_SaveDoorsData()
{
	foreach( door in GetAllPropDoors() )
	{
		doorsData mapDoor
		mapDoor.door = door
		mapDoor.origin = door.GetOrigin()
		mapDoor.angles = door.GetAngles()
		mapDoor.linked = IsValid( door.GetLinkEnt() )

		mapDoor.linkOrigin = mapDoor.linked == true ? door.GetLinkEnt().GetOrigin() : <0,0,0>
		mapDoor.linkAngles = mapDoor.linked == true ? door.GetLinkEnt().GetAngles() : <0,0,0>
		
		file.allMapDoors.append( mapDoor )
		RemoveDoorFromManagedEntArray( door )
	}

	foreach( i, doorsData data in file.allMapDoors )
	{
		foreach( j, doorsData data2 in file.allMapDoors )
		{
			if( data.linked && IsValid( data.door ) && IsValid( data2.door ) && data.door.GetLinkEnt() == data2.door )
			{
				file.allMapDoors.remove( j )
				// printt( "removed double door" )
				data2.door.Destroy() //save edicts even more
				j--
			}
		}
	}
	
	foreach( i, doorsData data in file.allMapDoors )
	{
		if( IsValid( data.door ) )
			data.door.Destroy() //save edicts even more
	}
}

void function FS_Scenarios_SpawnDoorsForGroup( scenariosGroupStruct group )
{
	if( !IsValid( group ) )
		return

	soloLocStruct groupLocStruct = group.groupLocStruct
	vector center = groupLocStruct.Center
	int realm = group.slotIndex

	array< doorsData > chosenSpawns
	
	foreach( i, doorsData data in file.allMapDoors )
	{
		if( Distance2D( data.origin, center) <= group.calculatedRingRadius )
			chosenSpawns.append( data )
	}
	
	foreach( i, doorsData data in chosenSpawns )
	{
		entity singleDoor = CreateEntity("prop_door")
		singleDoor.SetValueForModelKey( $"mdl/door/canyonlands_door_single_02.rmdl" )
		singleDoor.SetScriptName( "flowstate_door_realms" )
		singleDoor.SetOrigin( data.origin )
		singleDoor.SetAngles( data.angles )

		singleDoor.RemoveFromAllRealms()
		singleDoor.AddToRealm( realm )

		DispatchSpawn( singleDoor )
		
		if( data.linked )
		{
			entity doubleDoor = CreateEntity("prop_door")
			doubleDoor.SetValueForModelKey( $"mdl/door/canyonlands_door_single_02.rmdl" )
			doubleDoor.SetScriptName( "flowstate_door_realms" )
			doubleDoor.SetOrigin( data.linkOrigin )
			doubleDoor.SetAngles( data.linkAngles )

			doubleDoor.RemoveFromAllRealms()
			doubleDoor.AddToRealm( realm )
			doubleDoor.LinkToEnt( singleDoor )

			DispatchSpawn( doubleDoor )
			group.doors.append( doubleDoor )
		}

		group.doors.append( singleDoor )
	}

	//bro
	bool skip = false
	foreach( door in group.doors )
	{
		skip = false
		foreach( door2 in group.doors )
		{
			if( skip )
				continue

			if( door == door2 )
				continue

			if( door.GetOrigin() == door2.GetOrigin() )
			{
				if( IsValid( door ) && IsValid( door.GetLinkEnt() ) )
					door2.Destroy()
				else if( IsValid( door ) )
					door.Destroy()

				skip = true
			}
		}
	}
	#if DEVELOPER
		printt( "spawned", group.doors.len(), "doors for realm", realm )
	#endif
}

void function FS_Scenarios_DestroyDoorsForGroup( scenariosGroupStruct group )
{
	if( !IsValid( group ) )
		return

	int count = 0
	foreach( door in group.doors )
		if( IsValid( door ) )
		{
			count++
			RemoveDoorFromManagedEntArray( door )
			door.Destroy()
		}

	#if DEVELOPER
		printt( "destroyed", count, "doors for group", group.groupHandle )
	#endif
}

int function FS_Scenarios_GetAmountOfTeams()
{
	return settings.fs_scenarios_teamAmount
}

bool function FS_Scenarios_GetDeathboxesEnabled()
{
	return settings.fs_scenarios_deathboxes_enabled
}

void function FS_Scenarios_StoreAliveDeathbox( entity deathbox )
{
	if( !IsValid( deathbox ) )
		return

	file.aliveDeathboxes.append( deathbox )
	
	#if DEVELOPER
		printt( "added deathbox to alive deathboxes array", deathbox )
	#endif
}

void function FS_Scenarios_CleanupDeathboxes()
{
	foreach( i, deathbox in file.aliveDeathboxes )
	{
		if( !IsValid( deathbox ) )
		{
			file.aliveDeathboxes.removebyvalue( deathbox )
		}
	}
}

void function FS_Scenarios_DestroyAllAliveDeathboxesForRealm( int realm = -1 )
{
	int count = 0
	foreach( deathbox in file.aliveDeathboxes )
		if( IsValid( deathbox ) && realm == -1 || IsValid( deathbox ) && deathbox.IsInRealm( realm )  )
		{
			if( IsValid( deathbox.GetParent() ) )
				deathbox.GetParent().Destroy() // Destroy physics

			deathbox.Destroy()
			
			count++
		}
	#if DEVELOPER
		printt( "removed", count, "deathboxes for realm", realm )
	#endif
}

void function FS_Scenarios_StoreAliveDropship( entity dropship )
{
	if( !IsValid( dropship ) )
		return

	file.aliveDropships.append( dropship )
	
	#if DEVELOPER
		printt( "added dropship to alive dropships array", dropship )
	#endif
}

void function FS_Scenarios_CleanupDropships()
{
	foreach( i, dropship in file.aliveDropships )
	{
		if( !IsValid( dropship ) )
		{
			file.aliveDropships.removebyvalue( dropship )
		}
	}
}

void function FS_Scenarios_DestroyAllAliveDropships()
{
	foreach( dropship in file.aliveDropships )
		if( IsValid( dropship ) )
			dropship.Destroy()
}

void function FS_Scenarios_SaveLootbinData( entity lootbin )
{
	lootbinsData lootbinStruct
	lootbinStruct.origin = lootbin.GetOrigin()
	lootbinStruct.angles = lootbin.GetAngles()
	file.allMapLootbins.append( lootbinStruct )

	lootbin.Destroy() //save edicts even more
}

void function FS_Scenarios_SpawnLootbinsForGroup( scenariosGroupStruct group )
{
	if( !IsValid( group ) )
		return

	soloLocStruct groupLocStruct = group.groupLocStruct
	vector center = groupLocStruct.Center
	int realm = group.slotIndex

	array< lootbinsData > chosenSpawns
	
	foreach( i, lootbinStruct in file.allMapLootbins )
		if( Distance2D( lootbinStruct.origin, center) <= group.calculatedRingRadius )
			chosenSpawns.append( lootbinStruct )

	string zoneRef = "zone_high"

	int count = 0
	int weapons = 0

	foreach( lootbinStruct in chosenSpawns )
	{
		entity lootbin = FS_Scenarios_CreateCustomLootBin( lootbinStruct.origin, lootbinStruct.angles )

		if( !IsValid( lootbin ) )
			continue

		FS_Scenarios_InitLootBin( lootbin )

		array<string> Refs
		string itemRef
		LootData lootData

		for(int i = 0; i < RandomIntRangeInclusive(3,5); i++)
		{
			for(int j = 0; j < 1; j++)
			{
				itemRef = SURVIVAL_GetWeightedItemFromGroup( "zone_high" )
				lootData = SURVIVAL_Loot_GetLootDataByRef( itemRef )

				if(  lootData.lootType == eLootType.RESOURCE ||
				lootData.lootType == eLootType.DATAKNIFE ||
				lootData.lootType == eLootType.INCAPSHIELD ||
				lootData.lootType == eLootType.BACKPACK ||
				lootData.lootType == eLootType.HELMET ||
				lootData.lootType == eLootType.ARMOR ||
				lootData.lootType == eLootType.GADGET ||
				itemRef == "blank" ||
				itemRef == "mp_weapon_raygun" ||
				itemRef == "" )
				{
					j--
					continue
				}
				
				if( lootData.lootType == eLootType.MAINWEAPON )
					weapons++

				Refs.append( itemRef )
			}
		}
		
		lootbin.RemoveFromAllRealms()
		lootbin.AddToRealm( realm )
		
		AddMultipleLootItemsToLootBin( lootbin, Refs )

		group.lootbins.append( lootbin )
		count++
	}
	
	#if DEVELOPER
		printt("spawned", count, "lootbins for group", group.groupHandle, "in realm", group.slotIndex, "- WEAPONS: ", weapons )
	#endif
}

entity function FS_Scenarios_CreateCustomLootBin( vector origin, vector angles )
{
	entity lootbin = CreateEntity( "prop_dynamic" )
	lootbin.SetScriptName( LOOT_BIN_SCRIPTNAME_CUSTOM_REALMS )
	lootbin.SetValueForModelKey( LOOT_BIN_MODEL )
	lootbin.SetOrigin( origin )
	lootbin.SetAngles( angles )
	lootbin.kv.solid = SOLID_VPHYSICS

	DispatchSpawn( lootbin )

	return lootbin
}

void function FS_Scenarios_DestroyLootbinsForGroup( scenariosGroupStruct group )
{
	if( !IsValid( group ) )
		return

	int count = 0
	foreach( lootbin in group.lootbins )
		if( IsValid( lootbin ) )
		{
			count++
			RemoveLootBinReferences_Preprocess( lootbin )
			lootbin.Destroy()
		}
		
	#if DEVELOPER
		printt( "destroyed", count, "lootbins for group", group.groupHandle )
	#endif
}

void function FS_Scenarios_SaveLocationFromLootSpawn( entity ent )
{
	file.allLootSpawnsLocations.append( ent.GetOrigin() )
	ent.Destroy() //save edicts even more
}

void function FS_Scenarios_SpawnLootForGroup( scenariosGroupStruct group )
{
	if( !IsValid( group ) )
		return

	soloLocStruct groupLocStruct = group.groupLocStruct
	vector center = groupLocStruct.Center
	int realm = group.slotIndex

	array<vector> chosenSpawns
	
	foreach( spawn in file.allLootSpawnsLocations )
		if( Distance2D( spawn, center) <= group.calculatedRingRadius )
			chosenSpawns.append( spawn )

	string zoneRef = "zone_high"

	int count = 0
	int weapons = 0

	foreach( spawn in chosenSpawns )
	{
		string itemRef
		LootData lootData

		for(int i = 0; i < 1; i++)
		{
			itemRef = SURVIVAL_GetWeightedItemFromGroup( zoneRef )
			lootData = SURVIVAL_Loot_GetLootDataByRef( itemRef )

			if(  lootData.lootType == eLootType.RESOURCE ||
			lootData.lootType == eLootType.DATAKNIFE ||
			lootData.lootType == eLootType.INCAPSHIELD ||
			lootData.lootType == eLootType.BACKPACK ||
			lootData.lootType == eLootType.HELMET ||
			lootData.lootType == eLootType.ARMOR ||
			lootData.lootType == eLootType.GADGET ||
			itemRef == "blank" ||
			itemRef == "mp_weapon_raygun" ||
			itemRef == "" )
			{
				i--
				continue
			}
		}

		TraceResults traceResult = TraceLine(  spawn + < 0, 0, 32 >, spawn - < 0, 0, 32 >, [], TRACE_MASK_SHOT | TRACE_MASK_NPCWORLDSTATIC, TRACE_COLLISION_GROUP_NONE )
		spawn = traceResult.endPos

		int zangle = 0

		if( lootData.lootType == eLootType.MAINWEAPON )
		{
			weapons++
			string ammoType = lootData.ammoType
			
			if ( !SURVIVAL_Loot_IsRefValid( ammoType ) )
				continue

			int countperdrop = SURVIVAL_Loot_GetLootDataByRef( ammoType ).countPerDrop
			array<TraceResults> circlePositions
			
			for(int i = 0; i < 8; i++)
			{
				float r = float(i) / float( 8 ) * 2 * PI
				vector start = spawn + RandomFloatRange( 35, 45 ) * <sin( r ), cos( r ), 0.0>
				circlePositions.append( TraceLine( start + < 0, 0, 32 >, start - < 0, 0, 32 >, [], TRACE_MASK_SHOT | TRACE_MASK_NPCWORLDSTATIC, TRACE_COLLISION_GROUP_NONE ) )
			}

			//Add two ammo stacks per weapon
			TraceResults traceAmmo1 = circlePositions.getrandom()
			entity ammo1 = SpawnGenericLoot( ammoType, traceAmmo1.endPos, <0, RandomFloatRange( -180, 180 ), 1>, countperdrop )
			count++
			circlePositions.fastremovebyvalue( traceAmmo1 )
			TraceResults traceAmmo2 = circlePositions.getrandom()
			
			entity ammo2 = SpawnGenericLoot( ammoType, traceAmmo2.endPos, <0, RandomFloatRange( -180, 180 ), 1>, countperdrop )
			count++

			ammo1.RemoveFromAllRealms()
			ammo1.AddToRealm( realm )
			ammo2.RemoveFromAllRealms()
			ammo2.AddToRealm( realm )

			group.groundLoot.append( ammo1 )
			group.groundLoot.append( ammo2 )

			vector anglesA = AnglesOnSurface( traceAmmo1.surfaceNormal, AnglesToForward( ammo1.GetAngles() ) )
			ammo1.SetAngles( anglesA )
			anglesA = AnglesOnSurface( traceAmmo2.surfaceNormal, AnglesToForward( ammo2.GetAngles() ) )
			ammo2.SetAngles( anglesA )

			zangle = 90
		}

		entity loot = SpawnGenericLoot( itemRef, spawn + <0, 0, 2>, <0, RandomFloatRange( -180, 180 ), zangle>, lootData.countPerDrop )
		vector angles = AnglesOnSurface( traceResult.surfaceNormal, AnglesToForward( loot.GetAngles() ) )
		loot.SetAngles( < angles.x, angles.y, AnglesCompose( angles, <0,0,zangle> ).z > )

		loot.RemoveFromAllRealms()
		loot.AddToRealm( realm )

		group.groundLoot.append( loot )
		count++
	}

	#if DEVELOPER
		printt("spawned", count, "ground loot for group", group.groupHandle, "in realm", group.slotIndex, "- WEAPONS: ", weapons )
	#endif
}

void function FS_Scenarios_DestroyLootForGroup( scenariosGroupStruct group )
{
	if( !IsValid( group ) )
		return

	int count = 0
	foreach( loot in group.groundLoot )
		if( IsValid( loot ) )
		{
			count++
			loot.Destroy()
		}
		
	#if DEVELOPER
		printt( "destroyed", count, "ground loot for group", group.groupHandle )
	#endif
}

table<int, scenariosGroupStruct> function FS_Scenarios_GetInProgressGroupsMap()
{
	return file.scenariosGroupsInProgress
}

table<int, scenariosGroupStruct> function FS_Scenarios_GetPlayerToGroupMap()
{
	return file.scenariosPlayerToGroupMap
}

bool function FS_Scenarios_GetGroundLootEnabled()
{
	return settings.fs_scenarios_ground_loot
}

bool function FS_Scenarios_GetInventoryEmptyEnabled()
{
	return settings.fs_scenarios_inventory_empty
}

bool function FS_Scenarios_GetDropshipEnabled()
{
	return settings.fs_scenarios_dropshipenabled
}

void function FS_Scenarios_SetIsUsedBoolForTeamSlot( int team, bool usedState )
{
	if( team == -1 )
		return

	try
	{
		if ( !team ) { return } //temporary crash fix
		teamSlots[ team ] = usedState
	}
	catch(e)
	{	
		#if DEVELOPER
		sqprint("SetIsUsedBoolForRealmSlot crash " + e )
		#endif
	}
}

int function FS_Scenarios_GetAvailableTeamSlotIndex()
{
	for( int slot = 3; slot < teamSlots.len(); slot++ )
	{
		if( teamSlots[slot] == false )
		{
			FS_Scenarios_SetIsUsedBoolForTeamSlot( slot, true )
			return slot
		}
	}

	return -1
}
bool function FS_Scenarios_IsPlayerIn3v3Mode( entity player ) 
{
	if( !IsValid (player) )
	{	
		#if DEVELOPER
			sqprint("isPlayerInSoloMode entity was invalid")
		#endif
		
		return false 
	}
	
    return ( player.p.handle in file.scenariosPlayerToGroupMap )
}

bool function FS_Scenarios_GroupToInProgressList( scenariosGroupStruct newGroup, array<entity> players ) 
{
	#if DEVELOPER
		printt( "FS_Scenarios_GroupToInProgressList" )
	#endif

	int slotIndex = getAvailableRealmSlotIndex()

	if( slotIndex == -1 )
		return false
	
	foreach( player in players )
	{
		if( !IsValid( player ) )
			continue
		
		if( player.p.handle in file.scenariosPlayerToGroupMap )
		{
			delete file.scenariosPlayerToGroupMap[ player.p.handle ]
		}
		
		deleteWaitingPlayer( player.p.handle )
		deleteSoloPlayerResting( player )
		Message_New( player, "", 1 )
	}

	newGroup.slotIndex = slotIndex
    newGroup.groupLocStruct = soloLocations.getrandom()
	int groupHandle = GetUniqueID()

	newGroup.groupHandle = groupHandle
	newGroup.endTime = Time() + settings.fs_scenarios_maxIndividualMatchTime

	try 
	{
		if( !( groupHandle in file.scenariosGroupsInProgress ) )
		{
			#if DEVELOPER
			sqprint(format("adding group: %d", groupHandle ))
			#endif

			foreach( player in players )
			{
				if( !IsValid( player ) || player.p.handle in file.scenariosPlayerToGroupMap )
					continue

				file.scenariosPlayerToGroupMap[ player.p.handle] <- newGroup
			}

			file.scenariosGroupsInProgress[ groupHandle ] <- newGroup

			foreach( player in newGroup.team1Players )
			{
				if( !IsValid( player ) )
					continue

				SetTeam( player, newGroup.team1Index )
			}

			foreach( player in newGroup.team2Players )
			{
				if( !IsValid( player ) )
					continue

				SetTeam( player, newGroup.team2Index )
			}
			
			if( settings.fs_scenarios_teamAmount > 2 )
				foreach( player in newGroup.team3Players )
				{
					if( !IsValid( player ) )
						continue

					SetTeam( player, newGroup.team3Index )
				}
		}
		else 
		{	
			#if DEVELOPER
			sqerror(format("Logic flow error, group: [%d] already exists", groupHandle))
			#endif
			return false
		}
	}
	catch(e)
	{
		#if DEVELOPER
		sqprint("addGroup crash: " + e)
		#endif
		return false
	}

    return true
}

void function FS_Scenarios_RemoveGroup( scenariosGroupStruct groupToRemove ) 
{
	if( !IsValid(groupToRemove) )
	{
		sqerror("Logic flow error:  groupToRemove is invalid")
		return
	}
	
	try{
		if( groupToRemove.groupHandle in file.scenariosGroupsInProgress )
		{
			#if DEVELOPER
			sqprint(format("removing group: %d", groupToRemove.groupHandle) )
			#endif
			delete file.scenariosGroupsInProgress[groupToRemove.groupHandle]
		}
		else 
		{
			#if DEVELOPER
			sqprint(format("groupToRemove.groupHandle: %d not in file.groupsInProgress", groupToRemove.groupHandle ))
			#endif
		}
	}
	catch(e2)
	{	
		#if DEVELOPER
		sqprint( "removeGroup crash: " + e2 )
		#endif
	}
}

scenariosGroupStruct function FS_Scenarios_ReturnGroupForPlayer( entity player ) 
{
	scenariosGroupStruct group;	
	if(!IsValid (player) )
	{	
		#if DEVELOPER
		sqprint("FS_Scenarios_ReturnGroupForPlayer entity was invalid")
		#endif
		
		return group; 
	}
	
	try
	{
		if ( player.p.handle in file.scenariosPlayerToGroupMap ) 
		{	
			if( IsValid( file.scenariosPlayerToGroupMap[player.p.handle] ) )
			{
				return file.scenariosPlayerToGroupMap[ player.p.handle ]
			}
		}
	}
	catch(e)
	{
		#if DEVELOPER
		sqprint("returnSoloGroupOfPlayer crash " + e)
		#endif
	}
	return group;
}

void function FS_Scenarios_RespawnIn3v3Mode( entity player )
{
	if ( !IsValid(player) )
		return
	
	if ( !player.p.isConnected )
		return

   	if( player.p.isSpectating )
    {
		player.SetPlayerNetInt( "spectatorTargetCount", 0 )
		player.p.isSpectating = false
		player.SetSpecReplayDelay( 0 )
		player.SetObserverTarget( null )
		player.StopObserverMode()
        Remote_CallFunction_NonReplay(player, "ServerCallback_KillReplayHud_Deactivate")
        player.MakeVisible()
		player.ClearInvulnerable()
		player.SetTakeDamageType( DAMAGE_YES )
    }

	Remote_CallFunction_NonReplay( player, "ForceScoreboardLoseFocus" )

   	if( isPlayerInRestingList( player ) )
	{	
		try
		{
			DecideRespawnPlayer(player, true)
		}
		catch (erroree)
		{	
			#if DEVELOPER
			sqprint("Caught an error that would crash the server" + erroree)
			#endif
		}
	
		LocPair waitingRoomLocation = getWaitingRoomLocation()
		if (!IsValid(waitingRoomLocation)) return
		
		// GivePlayerCustomPlayerModel( player )
		maki_tp_player(player, waitingRoomLocation)
		player.MakeVisible()
		player.ClearInvulnerable() // !FIXME
		player.SetTakeDamageType( DAMAGE_YES )
		HolsterAndDisableWeapons(player)

		//set realms for resting player
		FS_ClearRealmsAndAddPlayerToAllRealms( player )

		return
	}

	scenariosGroupStruct group = FS_Scenarios_ReturnGroupForPlayer(player)

	if( !IsValid( group ) )
	{	
		#if DEVELOPER
		sqerror("group was invalid, err 007")
		#endif
		return
	}
}

void function FS_Scenarios_Main_Thread(LocPair waitingRoomLocation)
{
    WaitForGameState(eGameState.Playing)
	FS_Scenarios_SaveDoorsData()

	OnThreadEnd(
		function() : (  )
		{
			Warning(Time() + "Solo thread is down!!!!!!!!!!!!!!!")
			GameRules_ChangeMap( GetMapName(), GameRules_GetGameMode() )
		}
	)

	while(true)
	{
		wait 0.1

		FS_Scenarios_CleanupDropships()
		FS_Scenarios_CleanupDeathboxes()

		// Recién conectados
		foreach ( player in GetPlayerArray() )
		{
			if( !IsValid( player ) ) 
				continue

			// New player connected
			if( player.p.isConnected && !isPlayerInWaitingList( player) && !isPlayerInRestingList( player ) && !FS_Scenarios_IsPlayerIn3v3Mode( player ) )
			{
				soloModePlayerToWaitingList(player)
			}
		}
		
		//Los jugadores que están en la sala de espera no se pueden alejar mucho de ahí
		foreach ( playerHandle, playerInWaitingStruct in FS_1v1_GetPlayersWaiting() )
		{
			if ( !IsValid( playerInWaitingStruct.player ) )
			{
				deleteWaitingPlayer(playerInWaitingStruct.handle) //struct contains players handle as basic int
				continue
			}

			float t_radius = 600;

			if( Distance2D( playerInWaitingStruct.player.GetOrigin(), waitingRoomLocation.origin) > t_radius ) //waiting player should be in waiting room,not battle area
			{
				maki_tp_player( playerInWaitingStruct.player, waitingRoomLocation ) //waiting player should be in waiting room,not battle area
				HolsterAndDisableWeapons( playerInWaitingStruct.player )
			}
		}

		array<scenariosGroupStruct> groupsToRemove

		foreach( groupHandle, group in file.scenariosGroupsInProgress ) 
		{
			if( !IsValid( group ) || !group.isReady )
				continue

			array<entity> players
			players.extend( group.team1Players )
			players.extend( group.team2Players )
			players.extend( group.team3Players )

			//Anuncio que la ronda individual está a punto de terminar
			if( !group.IsFinished && Time() > group.endTime - 30 && !group.showedEndMsg )
			{
				foreach( player in players )
				{
					if( !IsValid( player ) )
						continue

					Message_New( player, "%$rui/menu/store/feature_timer% 30 Seconds remaining",  5 )
				}
				group.showedEndMsg = true
			}

			// Acabó la ronda, todos los jugadores de un equipo murieron o se superó el tiempo límite de la ronda
			if ( group.IsFinished || !group.IsFinished && Time() > group.endTime )
			{
				#if DEVELOPER
					printt( "Group has finished!", group.groupHandle )
				#endif 
				
				FS_Scenarios_DestroyRingsForGroup( group )
				FS_Scenarios_DestroyDoorsForGroup( group )

				if( settings.fs_scenarios_ground_loot )
				{
					FS_Scenarios_DestroyLootForGroup( group )
					FS_Scenarios_DestroyLootbinsForGroup( group )
				}

				FS_Scenarios_DestroyAllAliveDeathboxesForRealm( group.slotIndex )
				ClearActiveProjectilesForRealm( group.slotIndex )

				SetIsUsedBoolForRealmSlot( group.slotIndex, false )
				FS_Scenarios_SetIsUsedBoolForTeamSlot( group.team1Index, false )
				FS_Scenarios_SetIsUsedBoolForTeamSlot( group.team2Index, false )
				FS_Scenarios_SetIsUsedBoolForTeamSlot( group.team3Index, false )

				//Some abilities designed to stay like, bombardments, zipline, care package, decoy, grenades
				//should be destroyed when the scenarios round ends and not when the player dies

				array<entity> ents = GetScriptManagedEntArray( group.trackedEntsArrayIndex )
				foreach ( ent in ents )
				{
					if( IsValid( ent ) )
					{
						#if DEVELOPER
							printt( "tracked ent", ent, "destroyed" )
						#endif 
						
						ent.Destroy()
					}
				}

				DestroyScriptManagedEntArray( group.trackedEntsArrayIndex )

				foreach( player in players )
				{
					if( !IsValid( player ) )
						continue

					if( player.Player_IsFreefalling() )
					{
						Signal( player, "PlayerSkyDive" )
					}

					soloModePlayerToWaitingList( player )
					HolsterAndDisableWeapons( player )
				}

				groupsToRemove.append(group)
			}

			// No se pueden alejar mucho de la zona de juego
			soloLocStruct groupLocStruct = group.groupLocStruct
			vector Center = groupLocStruct.Center

			foreach( player in players )
			{
				if( !IsValid( player ) || IsValid( player.p.respawnPod ) ) continue
				
				//Se murió, a la sala de espera
				if( !IsAlive( player ) )
				{
					soloModePlayerToWaitingList( player )
					DecideRespawnPlayer( player, false )
					HolsterAndDisableWeapons( player )

					foreach( splayer in players )
						Remote_CallFunction_Replay( splayer, "FS_Scenarios_ChangeAliveStateForPlayer", player.GetEncodedEHandle(), false )

					if( settings.fs_scenarios_show_death_recap_onkilled )
					{
						player.p.InDeathRecap = true
						Remote_CallFunction_NonReplay( player, "ServerCallback_ShowFlowstateDeathRecapNoSpectate" )
					} else
						player.p.InDeathRecap = false

					#if DEVELOPER
						printt( "player killed in scenarios! player sent to waiting room and added to waiting list", player)
					#endif 
					
					continue
				}
				player.p.lastDamageTime = Time() //avoid player regen health

				if ( player.IsPhaseShifted() )
					continue

				if( Distance2D( player.GetOrigin(),Center) > group.currentRingRadius && Time() - player.p.lastRingDamagedTime > 1.5 ) //DAMAGE_CHECK_STEP_TIME
				{
					Remote_CallFunction_Replay( player, "ServerCallback_PlayerTookDamage", 0, 0, 0, 0, DF_BYPASS_SHIELD | DF_DOOMED_HEALTH_LOSS, eDamageSourceId.deathField, null )
					player.TakeDamage( 25, null, null, { scriptType = DF_BYPASS_SHIELD | DF_DOOMED_HEALTH_LOSS, damageSourceId = eDamageSourceId.deathField } )
					player.p.lastRingDamagedTime = Time()
					// printt( player, " TOOK DAMAGE", Distance2D( player.GetOrigin(),Center ) )
				}
			}
		}//foreach

		foreach ( group in groupsToRemove )
		{
			FS_Scenarios_RemoveGroup(group)
		}

		if( groupsToRemove.len() > 0 )
			continue

		// Revivir jugadores muertos que están descansando ( No debería pasar, pero por si acaso )
		foreach ( restingPlayerHandle, restingStruct in FS_1v1_GetPlayersResting() )
		{
			if( !restingPlayerHandle )
			{	
				sqerror("Null handle")
				continue
			}
			
			entity restingPlayerEntity = GetEntityFromEncodedEHandle( restingPlayerHandle )
			
			if( !IsValid(restingPlayerEntity) ) continue

			if( !IsAlive(restingPlayerEntity)  )
			{	
				FS_Scenarios_RespawnIn3v3Mode(restingPlayerEntity)
			}
			
			//TakeAllWeapons( restingPlayer )
			HolsterAndDisableWeapons( restingPlayerEntity )
		}

		if( GetScoreboardShowingState() )
				continue

		// Hay suficientes jugadores para crear un equipo?
		if( FS_1v1_GetPlayersWaiting().len() < ( settings.fs_scenarios_playersPerTeam * settings.fs_scenarios_teamAmount ) )
			continue		

		scenariosGroupStruct newGroup
		table<int, soloPlayerStruct> waitingPlayersShuffledTable = FS_1v1_GetPlayersWaiting()
		array<entity> waitingPlayers

		foreach ( playerHandle, eachPlayerStruct in waitingPlayersShuffledTable )
		{	
			if( !IsValid(eachPlayerStruct) )
				continue				
			
			entity player = eachPlayerStruct.player
			
			if( !IsValid( player ) )
				continue

			if( Time() < eachPlayerStruct.waitingTime )
				continue
				
			// if( player.p.InDeathRecap ) //Has player closed Death Recap?
				// continue

			waitingPlayers.append( player )
		}

		// Hay suficientes jugadores para crear un equipo?
		if( waitingPlayers.len() < ( settings.fs_scenarios_playersPerTeam * settings.fs_scenarios_teamAmount ) )
			continue	

		Assert( waitingPlayers.len() < ( settings.fs_scenarios_playersPerTeam * settings.fs_scenarios_teamAmount ) )

		#if DEVELOPER
			printt("------------------MATCHING GROUP------------------")
		#endif

		waitingPlayers.randomize()

		// mkos please add proper matchmaking for teams lol	
		foreach( player in waitingPlayers )
		{
			//Temp !FIXME
			if( newGroup.team1Players.len() < settings.fs_scenarios_playersPerTeam )
				newGroup.team1Players.append( player )
			else if( newGroup.team2Players.len() < settings.fs_scenarios_playersPerTeam )
				newGroup.team2Players.append( player )
			else if( newGroup.team3Players.len() < settings.fs_scenarios_playersPerTeam && settings.fs_scenarios_teamAmount > 2 )
				newGroup.team3Players.append( player )
		}

		newGroup.team1Index = FS_Scenarios_GetAvailableTeamSlotIndex()
		newGroup.team2Index = FS_Scenarios_GetAvailableTeamSlotIndex()
		if( settings.fs_scenarios_teamAmount > 2 )
			newGroup.team3Index = FS_Scenarios_GetAvailableTeamSlotIndex()

		array<entity> players
		players.extend( newGroup.team1Players )
		players.extend( newGroup.team2Players )
		players.extend( newGroup.team3Players )

		bool success = FS_Scenarios_GroupToInProgressList( newGroup, players )
		
		if( !success )
		{
			FS_Scenarios_RemoveGroup( newGroup )

			FS_Scenarios_SetIsUsedBoolForTeamSlot( newGroup.team1Index, false )
			FS_Scenarios_SetIsUsedBoolForTeamSlot( newGroup.team2Index, false )
			FS_Scenarios_SetIsUsedBoolForTeamSlot( newGroup.team3Index, false )

			foreach( player in players )
			{
				if( !IsValid( player ) )
					continue

				soloModePlayerToWaitingList(player)
			}
			continue
		}
		
		newGroup.trackedEntsArrayIndex = CreateScriptManagedEntArray()
		
		#if DEVELOPER
			printt( "tracked ents script managed array created for group", newGroup.groupHandle, newGroup.trackedEntsArrayIndex )
		#endif

		// Setup HUD
		foreach( player in newGroup.team1Players )
		{
			foreach( splayer in newGroup.team1Players )
			{
				if( IsValid( player ) && IsValid( splayer ) )
					Remote_CallFunction_NonReplay( player, "FS_Scenarios_AddAllyHandle", splayer.GetEncodedEHandle() )
			}
			foreach( splayer in newGroup.team2Players )
			{
				if( IsValid( player ) && IsValid( splayer ) )
					Remote_CallFunction_NonReplay( player, "FS_Scenarios_AddEnemyHandle", splayer.GetEncodedEHandle() )
			}
			foreach( splayer in newGroup.team3Players )
			{
				if( IsValid( player ) && IsValid( splayer ) )
					Remote_CallFunction_NonReplay( player, "FS_Scenarios_AddEnemyHandle2", splayer.GetEncodedEHandle() )
			}
		}
		
		foreach( player in newGroup.team2Players )
		{
			foreach( splayer in newGroup.team1Players )
			{
				if( IsValid( player ) && IsValid( splayer ) )
					Remote_CallFunction_NonReplay( player, "FS_Scenarios_AddEnemyHandle", splayer.GetEncodedEHandle() )
			}
			foreach( splayer in newGroup.team2Players )
			{
				if( IsValid( player ) && IsValid( splayer ) )
					Remote_CallFunction_NonReplay( player, "FS_Scenarios_AddAllyHandle", splayer.GetEncodedEHandle() )
			}
			foreach( splayer in newGroup.team3Players )
			{
				if( IsValid( player ) && IsValid( splayer ) )
					Remote_CallFunction_NonReplay( player, "FS_Scenarios_AddEnemyHandle2", splayer.GetEncodedEHandle() )
			}
		}

		foreach( player in newGroup.team3Players )
		{
			foreach( splayer in newGroup.team1Players )
			{
				if( IsValid( player ) && IsValid( splayer ) )
					Remote_CallFunction_NonReplay( player, "FS_Scenarios_AddEnemyHandle", splayer.GetEncodedEHandle() )
			}
			foreach( splayer in newGroup.team2Players )
			{
				if( IsValid( player ) && IsValid( splayer ) )
					Remote_CallFunction_NonReplay( player, "FS_Scenarios_AddEnemyHandle2", splayer.GetEncodedEHandle() )
			}
			foreach( splayer in newGroup.team3Players )
			{
				if( IsValid( player ) && IsValid( splayer ) )
					Remote_CallFunction_NonReplay( player, "FS_Scenarios_AddAllyHandle", splayer.GetEncodedEHandle() )
			}
		}

		thread function () : ( newGroup, players )
		{
			EndSignal( svGlobal.levelEnt, "FS_EndDelayedThread" )

			soloLocStruct groupLocStruct = newGroup.groupLocStruct
			vector Center = groupLocStruct.Center
			
			#if DEVELOPER
				DebugDrawSphere( Center, 30, 255,0,0, true, 300 )
			#endif
			float ringRadius = 0

			foreach( LocPair spawn in groupLocStruct.respawnLocations )
			{
				if( Distance( spawn.origin, Center ) > ringRadius )
					ringRadius = Distance(spawn.origin, Center )
			}

			newGroup.calculatedRingRadius = ringRadius + settings.fs_scenarios_default_radius_padding
			newGroup.currentRingRadius = newGroup.calculatedRingRadius
			
			if( !settings.fs_scenarios_zonewars_ring_mode )
				newGroup.calculatedRingRadius = settings.fs_scenarios_default_radius

			newGroup.ring = CreateSmallRingBoundary( groupLocStruct.Center, newGroup.slotIndex, newGroup.calculatedRingRadius )

			//Play fx on players screen
			foreach ( entity player in players )
			{
				if( !IsValid( player ) )
					return

				Remote_CallFunction_NonReplay( player, "FS_CreateTeleportFirstPersonEffectOnPlayer" )
				Flowstate_AssignUniqueCharacterForPlayer( player, true )
			}

			thread FS_Scenarios_SpawnDoorsForGroup( newGroup )
			thread FS_Scenarios_SpawnBigDoorsForGroup( newGroup )

			if( settings.fs_scenarios_ground_loot )
			{
				thread FS_Scenarios_SpawnLootbinsForGroup( newGroup )
				thread FS_Scenarios_SpawnLootForGroup( newGroup )
			} 
			#if DEVELOPER
				else
				{
					printt( "ground loot is disabled from playlist!" )
				}
			#endif

			wait 0.5
			
			int spawnSlot = -1
			int oldSpawnSlot = -1
			int j = 0
			foreach ( int i, entity player in players )
			{
				if( !IsValid( player ) )
					return

				player.p.notify = false
				player.p.destroynotify = true
				FS_SetRealmForPlayer( player, newGroup.slotIndex )
				
				
				int amountPlayersPerTeam

				if( player.GetTeam() == newGroup.team1Index )
				{
					spawnSlot = 0
					amountPlayersPerTeam = newGroup.team1Players.len()
				}
				else if( player.GetTeam() == newGroup.team2Index )
				{
					spawnSlot = 1
					amountPlayersPerTeam = newGroup.team2Players.len()
				}
				else if( player.GetTeam() == newGroup.team3Index )
				{
					spawnSlot = 2
					amountPlayersPerTeam = newGroup.team3Players.len()
				}

				if ( spawnSlot == -1 ) 
				{
					soloModePlayerToWaitingList( player )
					continue
				}

				if( spawnSlot != oldSpawnSlot )
					j = 0

				FS_Scenarios_RespawnIn3v3Mode( player )

				EmitSoundOnEntityOnlyToPlayer( player, player, "PhaseGate_Enter_1p" )
				EmitSoundOnEntityExceptToPlayer( player, player, "PhaseGate_Enter_3p" )

				if( !settings.fs_scenarios_dropshipenabled  )
				{
					LocPair location = groupLocStruct.respawnLocations[ spawnSlot ]

					player.SetVelocity( < 0,0,0 > )
					player.SetAngles( location.angles )
					vector pos = location.origin

					float r = float(j) / float( amountPlayersPerTeam ) * 2 * PI
					vector circledPos = pos + 50.0 * <sin( r ), cos( r ), 0.0> 
					player.SetOrigin( circledPos + <0,0,5> )
					PutEntityInSafeSpot( player, null, null, circledPos, player.GetOrigin() )
					j++
				}
				oldSpawnSlot = spawnSlot
				Remote_CallFunction_NonReplay( player, "UpdateRUITest")

				Message_New( player, "%$rui/menu/buttons/tip% Kill and win to get points in the global match", 5 )
			}

			if( settings.fs_scenarios_dropshipenabled )
			{
				thread FS_Scenarios_StartDropshipMovement( newGroup )
			} else
			{
				thread FS_Scenarios_GiveWeaponsToGroup( players )
			}
			newGroup.isReady = true
			
			thread FS_Scenarios_StartRingMovementTest( newGroup )
		}()
	}//while(true)

}//thread


void function FS_Scenarios_StartRingMovementTest( scenariosGroupStruct group )
{
	if( !IsValid( group ) )
		return

	EndSignal( svGlobal.levelEnt, "FS_EndDelayedThread" )
	
	entity ring = group.ring
	EndSignal( ring, "OnDestroy" )

	OnThreadEnd(
		function() : ( group )
		{
			if( IsValid( group ) )
				group.currentRingRadius = 0
		}
	)

	while ( group.currentRingRadius > 0 && !group.IsFinished )
	{
		array<entity> players
		players.extend( group.team1Players )
		players.extend( group.team2Players )
		players.extend( group.team3Players )
		ArrayRemoveInvalid( players )

		float radius = group.currentRingRadius
		
		group.currentRingRadius = radius - settings.fs_scenarios_zonewars_ring_ringclosingspeed 

		foreach( player in  players )
		{
			player.SetPlayerNetTime( "currentPlayerDeathfieldRadius", group.currentRingRadius )
		}
		WaitFrame()
	}
}

entity function CreateSmallRingBoundary(vector Center, int realm = -1, float radius = -1)
{
    vector smallRingCenter = Center
	entity smallcircle = CreateEntity( "prop_script" )
	smallcircle.SetValueForModelKey( $"mdl/dev/empty_model.rmdl" )
	smallcircle.kv.fadedist = 2000
	smallcircle.kv.renderamt = 1
	smallcircle.kv.solid = 0
	smallcircle.kv.VisibilityFlags = ENTITY_VISIBLE_TO_EVERYONE
	// smallcircle.SetOwner(Owner)
	smallcircle.SetOrigin( smallRingCenter )
	smallcircle.SetAngles( <0, 0, 0> )
	smallcircle.NotSolid()
	smallcircle.DisableHibernation()
	SetTargetName( smallcircle, "scenariosDeathField" )

	if( realm > -1 )
	{
		smallcircle.RemoveFromAllRealms()
		smallcircle.AddToRealm( realm )
	}

	DispatchSpawn(smallcircle)

	return smallcircle
}

void function FS_Scenarios_DestroyRingsForGroup( scenariosGroupStruct group )
{
	if(!IsValid(group)) return
	if(!IsValid(group.ring)) return
	group.ring.Destroy()
}

void function FS_Scenarios_ForceAllRoundsToFinish()
{
	FS_Scenarios_DestroyAllAliveDropships()

	foreach(player in GetPlayerArray())
	{
		if(!IsValid(player)) continue
		
		try{
			if(player.p.isSpectating)
			{
				player.SetPlayerNetInt( "spectatorTargetCount", 0 )
				player.p.isSpectating = false
				player.SetSpecReplayDelay( 0 )
				player.SetObserverTarget( null )
				player.StopObserverMode()
				Remote_CallFunction_NonReplay(player, "ServerCallback_KillReplayHud_Deactivate")
				player.MakeVisible()
				player.ClearInvulnerable()
				player.SetTakeDamageType( DAMAGE_YES )
			}
		}catch(e420){}
		
		if(isPlayerInWaitingList(player))
		{
			continue
		}

		scenariosGroupStruct group = FS_Scenarios_ReturnGroupForPlayer(player) 	
		if( IsValid( group ) )
		{
			FS_Scenarios_DestroyRingsForGroup(group)		
			group.IsFinished = true //tell solo thread this round has finished
		}
	}
	Signal( svGlobal.levelEnt, "FS_EndDelayedThread" )
}

//////////////////// STATS /////////////////
#if TRACKER 

//(for demo)
var function TrackerStats_ScenariosKills( string uid )
{
	return Tracker_StatsMetricsByUID(uid).kills
}

var function TrackerStats_ScenariosDeaths( string uid )
{
	return Tracker_StatsMetricsByUID(uid).deaths
}
#endif 

#if DEVELOPER
void function Cafe_KillAllPlayers()
{
	entity player = gp()[0]
	
	foreach( splayer in gp() )
	{
		if( splayer == player )
			continue
		
		splayer.TakeDamage( 420, null, null, { scriptType = DF_BYPASS_SHIELD | DF_DOOMED_HEALTH_LOSS, damageSourceId = eDamageSourceId.deathField } )
	}
}

void function Cafe_EndAllRounds()
{
	FS_Scenarios_ForceAllRoundsToFinish()
}
#endif


LocPairData function CustomSpawns()
{
	array<LocPair> spawns
	switch( MapName() )
	{
		case eMaps.mp_rr_desertlands_64k_x_64k:
			spawns = 
			[ 
				NewLocPair( < 21571.2, -38315.6, -2220.33 >, < 5.24698, 276.919, 0 > ),
				NewLocPair( < 19886.9, -40480.5, -2220.33 >, < 3.51996, 7.62843, 0 > ),
				NewLocPair( < 21706.7, -40174.5, -2220.3 >, < 4.56219, 142.329, 0 > ),
				NewLocPair( < 20994.1, -10747.6, -4134.61 >, < 2.58227, 114.477, 0 > ),
				NewLocPair( < 20404, -9440, -4130.61 >, < 4.33487, 294.074, 0 > ),
				NewLocPair( < 19168.6, -10683, -4174.59 >, < 359.776, 27.1522, 0 > ),
				NewLocPair( < 27898, -4883.51, -3975.98 >, < 2.27297, 314.628, 0 > ),
				NewLocPair( < 29196, -6981.77, -3620.77 >, < 4.91559, 42.2109, 0 > ),
				NewLocPair( < 30156.8, -8187.79, -3695.4 >, < 359.362, 201.996, 0 > ),
				NewLocPair( < 19568.1, 3619.8, -4083.48 >, < 8.71203, 358.715, 0 > ),
				NewLocPair( < 20440.1, 4088.34, -3935.97 >, < 5.23619, 27.8162, 0 > ),
				NewLocPair( < 21840.5, 3244.21, -4087.97 >, < 3.42291, 179.432, 0 > ),
				NewLocPair( < 30499, 10332.4, -3463.97 >, < 2.19265, 340.815, 0 > ),
				NewLocPair( < 32962, 9651.33, -3595.97 >, < 1.8348, 204.779, 0 > ),
				NewLocPair( < 32303.5, 7670.99, -3399.97 >, < 5.88895, 86.1931, 0 > ),
				NewLocPair( < 27656, 11566.7, -3333.05 >, < 6.70514, 89.4928, 0 > ),
				NewLocPair( < 28169.9, 14017.2, -3096.08 >, < 8.58106, 176.488, 0 > ),
				NewLocPair( < 27055.7, 14253.5, -3121.8 >, < 6.91889, 328.014, 0 > ),
				NewLocPair( < 12028, 19842.8, -5071.97 >, < 7.74917, 61.6774, 0 > ),
				NewLocPair( < 10763.7, 20620.4, -5021.19 >, < 0.721139, 2.94495, 0 > ),
				NewLocPair( < 12422, 20024.9, -3955.5 >, < 6.13481, 37.477, 0 > ),
				NewLocPair( < 12215.7, 6224.99, -4135.97 >, < 2.15493, 301.381, 0 > ),
				NewLocPair( < 13710.8, 5519.57, -4295.97 >, < 3.51585, 135.276, 0 > ),
				NewLocPair( < 13727.8, 6805.13, -4125.45 >, < 7.85658, 207.357, 0 > ),
				NewLocPair( < 9739.9, 5670.5, -3695.97 >, < 6.19938, 206.917, 0 > ),
				NewLocPair( < 9899.33, 5889.62, -4295.97 >, < 0.241581, 226.194, 0 > ),
				NewLocPair( < 8188.41, 6422.55, -4328.97 >, < 4.43221, 343.673, 0 > ),
				NewLocPair( < -3173.09, 19093.4, -2710.9 >, < 3.11988, 328.317, 0 > ),
				NewLocPair( < 44.5532, 18607.7, -2950.61 >, < 1.29781, 134.363, 0 > ),
				NewLocPair( < 170.456, 20832.4, -2998.95 >, < 359.924, 233.759, 0 > ),
				NewLocPair( < -9093.1, 29465.8, -3297.97 >, < 7.87784, 340.927, 0 > ),
				NewLocPair( < -9109.85, 29733.4, -3705.97 >, < 4.4871, 298.136, 0 > ),
				NewLocPair( < -9036.7, 29103.5, -3985.97 >, < 1.55586, 102, 0 > ),
				NewLocPair( < -19067.1, 22952.7, -3351.97 >, < 7.82167, 290.408, 0 > ),
				NewLocPair( < -19354.7, 22662.6, -4039.97 >, < 8.6704, 56.1921, 0 > ),
				NewLocPair( < -20649.8, 23252.1, -4088.94 >, < 358.799, 356.094, 0 > ),
				NewLocPair( < -25572.1, 8425.76, -2960.97 >, < 4.11316, 39.1704, 0 > ),
				NewLocPair( < -25531.3, 8567.46, -3364.97 >, < 0.992981, 225.578, 0 > ),
				NewLocPair( < -27476, 9324.44, -3168.97 >, < 4.99117, 324.014, 0 > ),
				NewLocPair( < -22985, -20526.7, -4080.12 >, < 8.68259, 359.654, 0 > ),
				NewLocPair( < -20570.5, -17410.2, -4043.91 >, < 3.60389, 266.156, 0 > ),
				NewLocPair( < -19860.9, -20718.1, -3187.63 >, < 10.476, 191.576, 0 > ),
				NewLocPair( < -17184.4, -29771.7, -3471.97 >, < 3.20937, 183.963, 0 > ),
				NewLocPair( < -19610.4, -29894.6, -3749.41 >, < 6.02845, 225.983, 0 > ),
				NewLocPair( < -20096.8, -30485.4, -3751.52 >, < 3.42621, 44.4348, 0 > ),
				NewLocPair( < -6612.29, -30421.6, -3559.94 >, < 9.03763, 262.677, 0 > ),
				NewLocPair( < -5476.95, -33721.2, -3337.12 >, < 10.6455, 178.458, 0 > ),
				NewLocPair( < -7238.02, -32846, -3469.78 >, < 3.58117, 356.822, 0 > ),
				NewLocPair( < 12125.6, 1809.22, -3621.78 >, < 12.9427, 91.5103, 0 > ),
				NewLocPair( < 10943.2, 3012.45, -4295.97 >, < 358.444, 317.55, 0 > ),
				NewLocPair( < 14546.3, 3803.29, -4271.99 >, < 359.183, 221.825, 0 > ),
				NewLocPair( < 17412.6, -1700.06, -3466.56 >, < 359.477, 201.463, 0 > ),
				NewLocPair( < 14846.7, -2687.5, -3236.45 >, < 8.30138, 57.1494, 0 > ),
				NewLocPair( < 14109.1, -694.488, -3625.18 >, < 4.55861, 315.723, 0 > ),
				NewLocPair( < -12933.8, 32999.7, -3863.97 >, < 5.53265, 269.791, 0 > ),
				NewLocPair( < -12773.3, 32075.2, -4079.97 >, < 2.5599, 177.638, 0 > ),
				NewLocPair( < -13309.9, 30093, -4039.99 >, < 2.25235, 81.8431, 0 > ),
				NewLocPair( < -10221.7, -26834.7, -2895.19 >, < 8.6499, 332.555, 0 > ),
				NewLocPair( < -7745.85, -26691.1, -4136.14 >, < 1.36961, 209.059, 0 > ),
				NewLocPair( < -9225.73, -28118.5, -3796.55 >, < 349.513, 104.549, 0 > )
			]
			break
			
		//these are for testing, i love to use different maps while developing so i don't get bored. Colombia
		case eMaps.mp_rr_canyonlands_mu2:
			spawns = [
				NewLocPair( <19356.6816, 8522.87305, 4042.40039> , <0, 55.6736412, 0> ),
				NewLocPair( <26999.6836, 17004.0176, 3332.56128> , <0, -151.621841, 0> ),

				NewLocPair( <-16412.1445, -8597.46973, 3309.15259> , <0, -132.202454, 0> ),
				NewLocPair( <-20556.3535, -13442.3467, 3205.87817> , <0, 61.0804405, 0> ),
				
				NewLocPair( <3425.80518, -10499.7891, 3285.03125> , <0, -175.575607, 0> ),
				NewLocPair( <-2240.12695, -11501.4404, 3167.58057> , <0, 9.96513939, 0> ),

				NewLocPair( <34933.0859, 20244.8984, 4202.85254> , <0, 35.38274, 0> ),
				NewLocPair( <37117.9102, 23769.4707, 4019.0625> , <0, -122.349365, 0> )
			]
			break

		case eMaps.mp_rr_olympus_mu1:
			spawns = [
				NewLocPair( <-20382.9375, 28349.0488, -6379.54199>, <0, 42.8024635, 0> ),
				NewLocPair( <-15628.7354, 33786.6602, -6181.9043>, <0, -144.864426, 0> ),
				NewLocPair( <-21250.4883, 34012.3867, -6383.88867>, <0, -62.3558273, 0> ),

				NewLocPair( <-20105.1855, -1279.15027, -5568.2041>, <0, 149.361572, 0> ),
				NewLocPair( <-26193.8652, 2219.52808, -5573.85596>, <0, -30.5185471, 0> ),
				NewLocPair( <-24378.3047, -1635.08997, -5341.96875>, <0, 59.6698799, 0> ),
				
				NewLocPair( <21201.8613, -14852.7305, -5032.22363>, <0, -78.5065842, 0> ),
				NewLocPair( <21783.9785, -21842.8613, -5032.22363>, <0, 107.717316, 0> ),
				NewLocPair( <17949.0391, -18802.1172, -4923.96875>, <0, 5.94164991, 0> ),

				NewLocPair( <9436.18555, 28426.0469, -4654.91553>, <0, -127.501564, 0> ),
				NewLocPair( <3670.51611, 20282.0215, -5598.02393>, <0, 57.8940849, 0> ),
				NewLocPair( <7840.729, 19089.4102, -5498.23828>, <0, 81.0241699, 0> )
			]
			break
	}

	return CreateLocPairObject( spawns, true )
}
