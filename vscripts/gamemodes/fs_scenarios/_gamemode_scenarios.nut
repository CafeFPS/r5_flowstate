// By @CafeFPS

global function Init_FS_Scenarios
global function FS_Scenarios_GroupToInProgressList
global function FS_Scenarios_ReturnGroupForPlayer
global function FS_Scenarios_RespawnIn3v3Mode
global function FS_Scenarios_Main_Thread

global function FS_Scenarios_GetInProgressGroupsMap
global function FS_Scenarios_GetPlayerToGroupMap
global function FS_Scenarios_GetSkydiveFromDropshipEnabled
global function FS_Scenarios_ForceAllRoundsToFinish

#if DEVELOPER
global function DEV_KillAllPlayers
#endif

global struct scenariosGroupStruct
{
	int groupHandle
	array<entity> team1Players
	array<entity> team2Players

	// save legends indexes ?

	soloLocStruct &groupLocStruct
	entity ring
	int slotIndex
	int team1Index
	int team2Index

	bool IsFinished = false
	float endTime
	bool showedEndMsg = false
}

struct {
	table<int, scenariosGroupStruct> scenariosPlayerToGroupMap = {} //map for quick assessment
	table<int, scenariosGroupStruct> scenariosGroupsInProgress = {} //group map to group
} file

struct {
	bool fs_scenarios_dropshipenabled = false
	int fs_scenarios_playersPerTeam = 3

	float fs_scenarios_maxIndividualMatchTime = 300
	float fs_scenarios_max_queuetime = 150
	int fs_scenarios_minimum_team_allowed = 1 // used only when max_queuetime is triggered
	int fs_scenarios_maximum_team_allowed = 3
	
	bool fs_scenarios_ground_loot = false
	bool fs_scenarios_inventory_empty = false
	bool fs_scenarios_start_skydiving = true
} settings

array< bool > teamSlots

void function Init_FS_Scenarios()
{
	settings.fs_scenarios_dropshipenabled = GetCurrentPlaylistVarBool( "fs_scenarios_dropshipenabled", true )
	settings.fs_scenarios_maxIndividualMatchTime = GetCurrentPlaylistVarFloat( "fs_scenarios_maxIndividualMatchTime", 300.0 )
	settings.fs_scenarios_max_queuetime = GetCurrentPlaylistVarFloat( "fs_scenarios_max_queuetime", 150.0 )
	settings.fs_scenarios_minimum_team_allowed = GetCurrentPlaylistVarInt( "fs_scenarios_minimum_team_allowed", 1 ) // used only when max_queuetime is triggered
	settings.fs_scenarios_maximum_team_allowed = GetCurrentPlaylistVarInt( "fs_scenarios_maximum_team_allowed", 3 )

	settings.fs_scenarios_ground_loot = GetCurrentPlaylistVarBool( "fs_scenarios_ground_loot", false )
	settings.fs_scenarios_inventory_empty = GetCurrentPlaylistVarBool( "fs_scenarios_inventory_empty", false ) // used only when max_queuetime is triggered
	settings.fs_scenarios_start_skydiving = GetCurrentPlaylistVarBool( "fs_scenarios_start_skydiving", true )

	teamSlots.resize( 119 )
	teamSlots[ 0 ] = true
	teamSlots[ 1 ] = true
	teamSlots[ 2 ] = true
	for (int i = 1; i < teamSlots.len(); i++)
	{
		teamSlots[ i ] = false
	}
	SurvivalFreefall_Init()
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

void function FS_Scenarios_SetIsUsedBoolForTeamSlot( int team, bool usedState )
{
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

				if( settings.fs_scenarios_dropshipenabled )
				{
					player.TakeDamage( 420, null, null, { scriptType = DF_BYPASS_SHIELD | DF_DOOMED_HEALTH_LOSS, damageSourceId = eDamageSourceId.damagedef_despawn } )
				}
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

	FS_Scenarios_DestroyRingsForGroup( groupToRemove )

	array<entity> players
	players.extend( groupToRemove.team1Players )
	players.extend( groupToRemove.team2Players )	
	try
	{
		foreach( player in players )
		{
			if( IsValid( player ) && player.p.handle in file.scenariosPlayerToGroupMap )
			{
				#if DEVELOPER
				sqprint(format("removing player in progress: %d", player) )
				#endif
				delete file.scenariosPlayerToGroupMap[ player.p.handle ]
			}
		}
	}
	catch(e)
	{	
		#if DEVELOPER
		sqprint( "remove player in progress crash: " + e )
		#endif
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

	// EndSignal( player, "OnDeath" )

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

	if( !settings.fs_scenarios_dropshipenabled )
	{
		try
		{
			DecideRespawnPlayer(player, true)
		}
		catch (error)
		{
			#if DEVELOPER
			sqprint("Caught an error that would crash the server")
			#endif
			// Warning("fail to respawn")
		}
	}

	// if dropship enabled
	if( settings.fs_scenarios_dropshipenabled && fromDropship )
	{
		WaitSignal( player, "PlayerDroppedFromDropship" )
	} else if( !settings.fs_scenarios_dropshipenabled && fromDropship )
	{
		soloLocStruct groupLocStruct = group.groupLocStruct
		maki_tp_player(player, groupLocStruct.respawnLocations[ respawnSlotIndex ] )
	}

	Message_New( player, "Kill and win to get points in the global match", 5 )

	#if DEVELOPER
	#else
	wait 0.2 //防攻击的伤害传递止上一条命被到下一条命的玩家上
	#endif

	if(!IsValid(player)) return

	Inventory_SetPlayerEquipment( player, "armor_pickup_lv3", "armor")
	
	if ( g_bLGmode )
	{
		PlayerRestoreHP_1v1(player, 100, 0 ) //lg
	}
	else 
	{
		PlayerRestoreHP_1v1(player, 100, player.GetShieldHealthMax().tofloat())
	}
	Remote_CallFunction_NonReplay( player, "UpdateRUITest")
	//re-enable for inventory. 
	Survival_SetInventoryEnabled( player, true )
	SetPlayerInventory( player, [] ) //TODO: set array to list of custom attachments if any - mkos
}

void function FS_Scenarios_Main_Thread(LocPair waitingRoomLocation)
{
    WaitForGameState(eGameState.Playing)

	OnThreadEnd(
		function() : (  )
		{
			Warning(Time() + "Solo thread is down!!!!!!!!!!!!!!!")
			GameRules_ChangeMap( GetMapName(), GameRules_GetGameMode() )
		}
	)

	while(true)
	{
		WaitFrame()

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
			if( !IsValid( group ) )
				continue

			array<entity> players
			players.extend( group.team1Players )
			players.extend( group.team2Players )

			//Anuncio que la ronda individual está a punto de terminar
			if( !group.IsFinished && Time() > group.endTime - 30 && !group.showedEndMsg )
			{
				foreach( player in players )
				{
					if( !IsValid( player ) )
						continue

					Message_New( player, "Scenario will end in 30 seconds",  5 )
				}
				group.showedEndMsg = true
			}

			// Acabó la ronda, todos los jugadores de un equipo murieron o se superó el tiempo límite de la ronda
			if ( group.IsFinished || !group.IsFinished && Time() > group.endTime )
			{
				SetIsUsedBoolForRealmSlot( group.slotIndex, false )

				FS_Scenarios_SetIsUsedBoolForTeamSlot( group.team1Index, false )
				FS_Scenarios_SetIsUsedBoolForTeamSlot( group.team2Index, false )

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
					printt( "player killed in scenarios! player sent to waiting room and added to waiting list", player)
					continue
				}
				player.p.lastDamageTime = Time() //avoid player regen health

				if ( player.IsPhaseShifted() )
					continue

				if( Distance2D( player.GetOrigin(),Center) > 6000 ) //检测乱跑的脑残
				{
					Remote_CallFunction_Replay( player, "ServerCallback_PlayerTookDamage", 0, 0, 0, 0, DF_BYPASS_SHIELD | DF_DOOMED_HEALTH_LOSS, eDamageSourceId.deathField, null )
					player.TakeDamage( 1, null, null, { scriptType = DF_BYPASS_SHIELD | DF_DOOMED_HEALTH_LOSS, damageSourceId = eDamageSourceId.deathField } )
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
				thread FS_Scenarios_RespawnIn3v3Mode(restingPlayerEntity)
			}
			
			//TakeAllWeapons( restingPlayer )
			HolsterAndDisableWeapons( restingPlayerEntity )
		}

		if( GetScoreboardShowingState() )
				continue

		// Hay suficientes jugadores para crear un equipo?
		if( FS_1v1_GetPlayersWaiting().len() < ( settings.fs_scenarios_maximum_team_allowed * 2 ) )
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

			waitingPlayers.append( player )
		}

		// Hay suficientes jugadores para crear un equipo?
		if( waitingPlayers.len() < ( settings.fs_scenarios_maximum_team_allowed * 2 ) )
			continue	

		Assert( waitingPlayers.len() < ( settings.fs_scenarios_maximum_team_allowed * 2 ) )

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
		}

		newGroup.team1Index = FS_Scenarios_GetAvailableTeamSlotIndex()
		newGroup.team2Index = FS_Scenarios_GetAvailableTeamSlotIndex()

		array<entity> players
		players.extend( newGroup.team1Players )
		players.extend( newGroup.team2Players )

		bool success = FS_Scenarios_GroupToInProgressList( newGroup, players )
		
		if( !success )
		{
			FS_Scenarios_RemoveGroup( newGroup )
			foreach( player in players )
			{
				if( !IsValid( player ) )
					continue

				soloModePlayerToWaitingList(player)
			}
			continue
		}
		
		//Send teams to fight
		soloLocStruct groupLocStruct = newGroup.groupLocStruct
		newGroup.ring = CreateSmallRingBoundary( groupLocStruct.Center, newGroup.slotIndex )

		foreach ( entity player in players )
		{
			if( !IsValid( player ) )
				return

			player.p.notify = false
			player.p.destroynotify = true
			FS_SetRealmForPlayer( player, newGroup.slotIndex )

			thread FS_Scenarios_RespawnIn3v3Mode( player, player.GetTeam() == newGroup.team1Index ? 0 : 1, true )
		}

		if( settings.fs_scenarios_dropshipenabled )
		{
			thread RespawnPlayersInDropshipAtPoint( newGroup.team1Players, groupLocStruct.respawnLocations[ 0 ].origin + < 0, 0, 3000 >, groupLocStruct.respawnLocations[ 0 ].angles, newGroup.slotIndex )
			thread RespawnPlayersInDropshipAtPoint( newGroup.team2Players, groupLocStruct.respawnLocations[ 1 ].origin + < 0, 0, 3000 >, groupLocStruct.respawnLocations[ 1 ].angles, newGroup.slotIndex )
		} else
		{
			GiveWeaponsToGroup( players )
		}
	}//while(true)

}//thread

entity function CreateSmallRingBoundary(vector Center, int realm = -1)
{
    vector smallRingCenter = Center
	float smallRingRadius = 6000
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
}

#if DEVELOPER
void function DEV_KillAllPlayers()
{
	entity player = gp()[0]
	
	foreach( splayer in gp() )
	{
		if( splayer == player )
			continue
		
		splayer.TakeDamage( 420, null, null, { scriptType = DF_BYPASS_SHIELD | DF_DOOMED_HEALTH_LOSS, damageSourceId = eDamageSourceId.deathField } )
	}
}
#endif