// By @CafeFPS

global function Init_FS_Scenarios
global function FS_Scenarios_GroupToInProgressList
global function FS_Scenarios_ReturnGroupForPlayer
global function FS_Scenarios_RespawnIn3v3Mode
global function FS_Scenarios_Main_Thread

global function FS_Scenarios_GetInProgressGroupsMap
global function FS_Scenarios_GetPlayerToGroupMap
global function FS_Scenarios_GetSkydiveFromDropshipEnabled
global function FS_Scenarios_GetGroundLootEnabled
global function FS_Scenarios_GetInventoryEmptyEnabled
global function FS_Scenarios_GetAmountOfTeams
global function FS_Scenarios_GetDeathboxesEnabled
global function FS_Scenarios_ForceAllRoundsToFinish
global function FS_Scenarios_GetDropshipEnabled
global function FS_Scenarios_SaveLocationFromLootSpawn
global function FS_Scenarios_SaveLootbinData
global function FS_Scenarios_SaveBigDoorData

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

	float fs_scenarios_default_radius = 8000
	float fs_scenarios_maxIndividualMatchTime = 300
	// float fs_scenarios_max_queuetime = 150
	// int fs_scenarios_minimum_team_allowed = 1 // used only when max_queuetime is triggered
	// int fs_scenarios_maximum_team_allowed = 3
	
	bool fs_scenarios_ground_loot = false
	bool fs_scenarios_inventory_empty = false
	bool fs_scenarios_start_skydiving = true
	bool fs_scenarios_deathboxes_enabled = true
	bool fs_scenarios_bleedout_enabled = true
	bool fs_scenarios_show_death_recap_onkilled = true
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
	settings.fs_scenarios_start_skydiving = GetCurrentPlaylistVarBool( "fs_scenarios_start_skydiving", true )
	settings.fs_scenarios_deathboxes_enabled = GetCurrentPlaylistVarBool( "fs_scenarios_deathboxes_enabled", true )
	settings.fs_scenarios_bleedout_enabled = GetCurrentPlaylistVarBool( "fs_scenarios_bleedout_enabled", true )
	settings.fs_scenarios_show_death_recap_onkilled = GetCurrentPlaylistVarBool( "fs_scenarios_show_death_recap_onkilled", true )

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
	printt( "[+] OnPlayerKilled Scenarios -", victim, "by", attacker )

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
	printt( "[+] OnPlayerConnected Scenarios -", player )

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
	printt( "[+] OnPlayerDisconnected Scenarios -", player )
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
		if( Distance2D( data.origin, center) <= settings.fs_scenarios_default_radius )
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
	printt( "created", count, "big doors for group", group.groupHandle )
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
		if( Distance2D( data.origin, center) <= settings.fs_scenarios_default_radius )
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
	printt( "spawned", group.doors.len(), "doors for realm", realm )
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

	printt( "destroyed", count, "doors for group", group.groupHandle )
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
	printt( "added deathbox to alive deathboxes array", deathbox )
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
	printt( "removed", count, "deathboxes for realm", realm )
}

void function FS_Scenarios_StoreAliveDropship( entity dropship )
{
	if( !IsValid( dropship ) )
		return

	file.aliveDropships.append( dropship )
	printt( "added dropship to alive dropships array", dropship )
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
		if( Distance2D( lootbinStruct.origin, center) <= settings.fs_scenarios_default_radius )
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
	printt("spawned", count, "lootbins for group", group.groupHandle, "in realm", group.slotIndex, "- WEAPONS: ", weapons )
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
		
	printt( "destroyed", count, "lootbins for group", group.groupHandle )
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
		if( Distance2D( spawn, center) <= settings.fs_scenarios_default_radius )
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

	printt("spawned", count, "ground loot for group", group.groupHandle, "in realm", group.slotIndex, "- WEAPONS: ", weapons )
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
		
	printt( "destroyed", count, "ground loot for group", group.groupHandle )
}

table<int, scenariosGroupStruct> function FS_Scenarios_GetInProgressGroupsMap()
{
	return file.scenariosGroupsInProgress
}

table<int, scenariosGroupStruct> function FS_Scenarios_GetPlayerToGroupMap()
{
	return file.scenariosPlayerToGroupMap
}

bool function FS_Scenarios_GetSkydiveFromDropshipEnabled()
{
	return settings.fs_scenarios_start_skydiving
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
bool function FS_Scenarios_IsPlayerIn3v3Mode(entity player) 
{
	if(!IsValid (player) )
	{	
		#if DEVELOPER
		sqprint("isPlayerInSoloMode entity was invalid")
		#endif
		return false 
	}
	
    return ( player.p.handle in file.scenariosPlayerToGroupMap );
}

bool function FS_Scenarios_GroupToInProgressList( scenariosGroupStruct newGroup, array<entity> players ) 
{
	printt( "FS_Scenarios_GroupToInProgressList" )

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

void function FS_Scenarios_RespawnIn3v3Mode(entity player, int respawnSlotIndex = -1, bool fromDropship = false )
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

	if ( respawnSlotIndex == -1 ) 
		return

	// if dropship enabled
	if( !settings.fs_scenarios_dropshipenabled && fromDropship )
	{
		soloLocStruct groupLocStruct = group.groupLocStruct
		maki_tp_player(player, groupLocStruct.respawnLocations[ respawnSlotIndex ] )
	}

	Message_New( player, "%$rui/menu/buttons/tip% Kill and win to get points in the global match", 5 )
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
				printt( "Group has finished!", group.groupHandle )
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
						printt( "tracked ent", ent, "destroyed" )
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

					printt( "player killed in scenarios! player sent to waiting room and added to waiting list", player)
					continue
				}
				player.p.lastDamageTime = Time() //avoid player regen health

				if ( player.IsPhaseShifted() )
					continue

				if( Distance2D( player.GetOrigin(),Center) > settings.fs_scenarios_default_radius ) //检测乱跑的脑残
				{
					Remote_CallFunction_Replay( player, "ServerCallback_PlayerTookDamage", 0, 0, 0, 0, DF_BYPASS_SHIELD | DF_DOOMED_HEALTH_LOSS, eDamageSourceId.deathField, null )
					player.TakeDamage( 3, null, null, { scriptType = DF_BYPASS_SHIELD | DF_DOOMED_HEALTH_LOSS, damageSourceId = eDamageSourceId.deathField } )
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

		printt("------------------MATCHING GROUP------------------")

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
		printt( "tracked ents script managed array created for group", newGroup.groupHandle, newGroup.trackedEntsArrayIndex )

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
			newGroup.ring = CreateSmallRingBoundary( groupLocStruct.Center, newGroup.slotIndex )

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
			} else
				printt( "ground loot is disabled from playlist!" )

			wait 0.5

			foreach ( entity player in players )
			{
				if( !IsValid( player ) )
					return

				player.p.notify = false
				player.p.destroynotify = true
				FS_SetRealmForPlayer( player, newGroup.slotIndex )
				
				int spawnSlot = -1
				
				if( player.GetTeam() == newGroup.team1Index )
					spawnSlot = 0
				else if( player.GetTeam() == newGroup.team2Index )
					spawnSlot = 1
				else
					spawnSlot = 2

				FS_Scenarios_RespawnIn3v3Mode( player, spawnSlot, true )
				Remote_CallFunction_NonReplay( player, "UpdateRUITest")

				EmitSoundOnEntityOnlyToPlayer( player, player, "PhaseGate_Enter_1p" )
				EmitSoundOnEntityExceptToPlayer( player, player, "PhaseGate_Enter_3p" )
			}

			if( settings.fs_scenarios_dropshipenabled )
			{
				thread FS_Scenarios_StartDropshipMovement( newGroup )
			} else
			{
				thread FS_Scenarios_GiveWeaponsToGroup( players )
			}
			newGroup.isReady = true
		}()
	}//while(true)

}//thread

entity function CreateSmallRingBoundary(vector Center, int realm = -1)
{
    vector smallRingCenter = Center
	float smallRingRadius = settings.fs_scenarios_default_radius
	entity smallcircle = CreateEntity( "prop_script" )
	smallcircle.SetValueForModelKey( $"mdl/fx/ar_survival_radius_1x100.rmdl" )
	smallcircle.kv.fadedist = 2000
	smallcircle.kv.modelscale = smallRingRadius
	smallcircle.kv.renderamt = 1
	smallcircle.kv.rendercolor = FlowState_RingColor()
	smallcircle.kv.solid = 0
	smallcircle.kv.VisibilityFlags = ENTITY_VISIBLE_TO_EVERYONE
	// smallcircle.SetOwner(Owner)
	smallcircle.SetOrigin( smallRingCenter )
	smallcircle.SetAngles( <0, 0, 0> )
	smallcircle.NotSolid()
	smallcircle.DisableHibernation()
	if( realm > -1 )
	{
		smallcircle.RemoveFromAllRealms()
		smallcircle.AddToRealm( realm )
	}

	// smallcircle.Minimap_SetObjectScale( min(smallRingRadius / SURVIVAL_MINIMAP_RING_SCALE, 1) )
	// smallcircle.Minimap_SetAlignUpright( true )
	// smallcircle.Minimap_SetZOrder( 2 )
	// smallcircle.Minimap_SetClampToEdge( true )
	// smallcircle.Minimap_SetCustomState( eMinimapObject_prop_script.OBJECTIVE_AREA )

	DispatchSpawn(smallcircle)

	// foreach ( eachPlayer in GetPlayerArray() )
	// {
	// 	smallcircle.Minimap_AlwaysShow( 0, eachPlayer )
	// }
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