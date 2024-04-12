// By @CafeFPS

global function Init_FS_Scenarios
global function FS_Scenarios_IsPlayerIn3v3Mode
global function FS_Scenarios_GroupToInProgressList
global function FS_Scenarios_AddGroup
global function FS_Scenarios_RemoveGroup
global function FS_Scenarios_ReturnGroupForPlayer
global function FS_Scenarios_RespawnIn3v3Mode
global function FS_Scenarios_Main_Thread

global function FS_Scenarios_GetInProgressGroupsMap
global function FS_Scenarios_GetPlayerToGroupMap

global struct scenariosGroupStruct
{
	int groupHandle
	array<entity> team1Players
	array<entity> team2Players

	// save legends indexes ?

	soloLocStruct &groupLocStruct

	int slotIndex
	int team1Index
	int team2Index

	bool IsFinished = false
	float startTime
}

struct {
	table<int, scenariosGroupStruct> scenariosPlayerToGroupMap = {} //map for quick assessment
	table<int, scenariosGroupStruct> scenariosGroupsInProgress = {} //group map to group
} file

struct {
	bool flowstate_3v3_dropshipenabled = false
	int flowstate_3v3_playersPerTeam = 3
} settings

array< bool > teamSlots

void function Init_FS_Scenarios()
{
	settings.flowstate_3v3_dropshipenabled = GetCurrentPlaylistVarBool( "flowstate_3v3_dropshipenabled", true )

	teamSlots.resize( 119 )
	teamSlots[ 0 ] = true
	teamSlots[ 1 ] = true
	teamSlots[ 2 ] = true
	for (int i = 1; i < teamSlots.len(); i++)
	{
		teamSlots[ i ] = false
	}
}

table<int, scenariosGroupStruct> function FS_Scenarios_GetInProgressGroupsMap()
{
	return file.scenariosGroupsInProgress
}

table<int, scenariosGroupStruct> function FS_Scenarios_GetPlayerToGroupMap()
{
	return file.scenariosPlayerToGroupMap
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
	for( int slot = 1; slot < teamSlots.len(); slot++ )
	{
		if( !teamSlots[slot] )
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

void function FS_Scenarios_GroupToInProgressList( scenariosGroupStruct newGroup ) 
{
	printt( "FS_Scenarios_GroupToInProgressList" )

	array<entity> players
	players.extend( newGroup.team1Players )
	players.extend( newGroup.team2Players )

	foreach( player in players )
	{
		//!FIXME
		// if ( player.p.handle in file.playerToGroupMap || opponent.p.handle in file.playerToGroupMap ) 
		// {	
			// //directly assign since we checked. - mkos
			// soloGroupStruct existingGroup = player.p.handle in file.playerToGroupMap ? file.playerToGroupMap[player.p.handle] : file.playerToGroupMap[opponent.p.handle];
			
			// destroyRingsForGroup(existingGroup);
			
			// #if DEVELOPER
			// sqprint("remove group request 02")
			// #endif
			
			// while(mGroupMutexLock) 
			// {
				// #if DEVELOPER
				// sqprint("Waiting for lock to release R002")
				// #endif
				// WaitFrame() 
			// }
			
			// removeGroup(existingGroup);

			// return
		// }

		deleteWaitingPlayer(player.p.handle)
		deleteSoloPlayerResting(player)
	}

    int slotIndex = getAvailableRealmSlotIndex();
    if (slotIndex > -1) 
	{
        newGroup.slotIndex = slotIndex;
        newGroup.groupLocStruct = soloLocations.getrandom()

		FS_Scenarios_AddGroup(newGroup); 
    } 

    return
}

void function FS_Scenarios_AddGroup( scenariosGroupStruct newGroup) 
{
	if(!IsValid(newGroup))
	{
		sqerror("[addGroup]: Logic Flow Error: group is invalid during creation")
		return
	}
	array<entity> players
	players.extend( newGroup.team1Players )
	players.extend( newGroup.team2Players )
	
	try 
	{
		int groupHandle = GetUniqueID();
		
		newGroup.groupHandle = groupHandle
		newGroup.startTime = Time()
		
		#if DEVELOPER
		sqprint(format("adding group: %d", groupHandle ))
		#endif
		if( !( groupHandle in file.scenariosGroupsInProgress ) )
		{
			bool success = true
			
			// Si algún equipo tiene 0 jugadores válidos, no agregar, success sería falso
			int count = 0
			foreach( player in players )
			{
				if( !IsValid( player ) )
					continue

				file.scenariosPlayerToGroupMap[ player.p.handle] <- newGroup
				count++
			}
			
			if( count == 0 )
				success = false

			if(success)
			{
				file.scenariosGroupsInProgress[groupHandle] <- newGroup
			}
		}
		else 
		{	
			#if DEVELOPER
			sqerror(format("Logic flow error, group: [%d] already exists", groupHandle))
			#endif
		}
		
		
	}
	catch(e)
	{
		#if DEVELOPER
		sqprint("addGroup crash: " + e)
		#endif
	}
}

void function FS_Scenarios_RemoveGroup( scenariosGroupStruct groupToRemove ) 
{
	if(!IsValid(groupToRemove))
	{
		sqerror("Logic flow error:  groupToRemove is invalid")
		return
	}
	array<entity> players
	players.extend( groupToRemove.team1Players )
	players.extend( groupToRemove.team2Players )	
	try
	{
		foreach( player in players )
		{
			if( IsValid( player ) && player.p.handle in file.scenariosPlayerToGroupMap )
			{
				delete file.scenariosPlayerToGroupMap[ player.p.handle ]
			}
		}

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
	catch(e)
	{	
		#if DEVELOPER
		sqprint( "removeGroup crash: " + e )
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

void function FS_Scenarios_RespawnIn3v3Mode(entity player, int respawnSlotIndex = -1)
{
	EndSignal( player, "OnDeath" )

	if (!IsValid(player)) return
	
	if ( !player.p.isConnected ) return //crash fix mkos
	
	// printt("respawnInSoloMode!")
	// Warning("respawn player: " + player.GetPlayerName())

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
    }//disable replay mode

	Remote_CallFunction_NonReplay( player, "ForceScoreboardLoseFocus" )

   	if( isPlayerInRestingList(player) )
	{	
		/*
		try 
		{
			DoRespawnPlayer( player, null ) //mkos
		}
		catch(o){sqprint("Caught an error that would crash the server")}
		*/
		
		
		// Warning("resting respawn")
		try
		{
			DecideRespawnPlayer(player, true)
		}
		catch (erroree)
		{	
			#if DEVELOPER
			sqprint("Caught an error that would crash the server" + erroree)
			#endif
			// printt("fail to respawn")
		}
		
		SetTeam( player, 2 )
		LocPair waitingRoomLocation = getWaitingRoomLocation()
		if (!IsValid(waitingRoomLocation)) return
		
		GivePlayerCustomPlayerModel( player )
		maki_tp_player(player, waitingRoomLocation)
		player.MakeVisible()
		player.ClearInvulnerable()
		player.SetTakeDamageType( DAMAGE_YES )
		HolsterAndDisableWeapons(player)

		//set realms for resting player
		FS_ClearRealmsAndAddPlayerToAllRealms( player )

		return
	}//玩家在休息模式

	scenariosGroupStruct group = FS_Scenarios_ReturnGroupForPlayer(player)

	if( !IsValid( group ) )
	{	
		#if DEVELOPER
		sqerror("group was invalid, err 007")
		#endif
		return //Is this group available
	}

	if ( respawnSlotIndex == -1 ) 
		return
	
	/*try 	
	{
		DoRespawnPlayer( player, null ) //mkos
	}
	catch(o){sqprint("Caught an error that would crash the server")}
	*/
	if( !settings.flowstate_3v3_dropshipenabled )
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
	
	GivePlayerCustomPlayerModel( player )
	
	// if dropship enabled
	if( settings.flowstate_3v3_dropshipenabled )
	{
		WaitSignal( player, "PlayerDroppedFromDropship" )
		Remote_CallFunction_NonReplay( player, "UpdateRUITest")
	} else
	{
		soloLocStruct groupLocStruct = group.groupLocStruct
		maki_tp_player(player, groupLocStruct.respawnLocations[ respawnSlotIndex ] )
	}

	#if DEVELOPER
	#else
	wait 0.2 //防攻击的伤害传递止上一条命被到下一条命的玩家上
	#endif

	if(!IsValid(player)) return

	Inventory_SetPlayerEquipment(player, "armor_pickup_lv3", "armor")
	
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
	
	wait 0.1
	ReCheckGodMode(player)
}

void function FS_Scenarios_Main_Thread(LocPair waitingRoomLocation)
{
	//printt("solo mode thread start!")

	string Text5 = "FLOWSTATE 3V3 GAME STARTED" 

	wait 8

	while(true)
	{
		WaitFrame()
		
		if( GetScoreboardShowingState() )
			continue
		
		//cycle waiting queue
		foreach ( playerHandle, playerInWaitingStruct in FS_1v1_GetPlayersWaiting() )
		{
			if ( !IsValid( playerInWaitingStruct.player ) )
			{
				deleteWaitingPlayer(playerInWaitingStruct.handle) //struct contains players handle as basic int
				continue
			}

			//timeout preferred matchmaking 
			if (playerInWaitingStruct.waitingTime < Time() && !playerInWaitingStruct.IsTimeOut && IsValid(playerInWaitingStruct.player))
			{
				playerInWaitingStruct.IsTimeOut = true;
			}
		}//foreach

		array<scenariosGroupStruct> groupsToRemove;
		bool quit;
		bool removed;
		
		foreach (groupHandle, group in file.scenariosGroupsInProgress) 
		{
			quit = false
			removed = false

			if(!IsValid(group))
			{
				removed = true
			}
			
			// Acabó la ronda, todos los jugadores de un equipo murieron
			if ( !removed && group.IsFinished )
			{
				array<entity> players
				players.extend( group.team1Players )
				players.extend( group.team2Players )

				SetIsUsedBoolForRealmSlot( group.slotIndex, false )

				FS_Scenarios_SetIsUsedBoolForTeamSlot( group.team1Index, false )
				FS_Scenarios_SetIsUsedBoolForTeamSlot( group.team2Index, false )

				foreach( player in players )
				{
					soloModePlayerToWaitingList( player )
					processRestRequest( player )
					HolsterAndDisableWeapons( player )
				}

				#if DEVELOPER
				sqprint("remove group request 04")
				#endif

				groupsToRemove.append(group)
				quit = true
			}

			// Si todos los jugadores de un equipo son inválidos, mandar el otro equipo a la lista de espera
			//implement processRestRequest
			int check = 0
			foreach( player in group.team1Players )
			{
				if( IsValid( player ) )
					check++
			}
			if( check == 0 )
			{
				foreach( player in group.team2Players )
				{
					
					soloModePlayerToWaitingList(player)
					HolsterAndDisableWeapons( player )
				}

				SetIsUsedBoolForRealmSlot(group.slotIndex, false);
				groupsToRemove.append( group)

				quit = true
			}

			check = 0
			foreach( player in group.team2Players )
			{
				if( IsValid( player ) )
					check++
			}
			if( check == 0 )
			{
				foreach( player in group.team1Players )
				{
					
					soloModePlayerToWaitingList(player)
					HolsterAndDisableWeapons( player )
				}
				
				SetIsUsedBoolForRealmSlot(group.slotIndex, false);
				groupsToRemove.append( group)

				quit = true
			}

			// Que no se se vayan de la zona
			if(!removed && !quit)
			{
				soloLocStruct groupLocStruct = group.groupLocStruct
				vector Center = groupLocStruct.Center
				array<entity> players
				players.extend( group.team1Players )
				players.extend( group.team2Players )
				foreach (eachPlayer in players )
				{
					if(!IsValid(eachPlayer)) continue
					eachPlayer.p.lastDamageTime = Time() //avoid player regen health

					if(Distance2D(eachPlayer.GetOrigin(),Center) > 2000) //检测乱跑的脑残
					{
						Remote_CallFunction_Replay( eachPlayer, "ServerCallback_PlayerTookDamage", 0, 0, 0, 0, DF_BYPASS_SHIELD | DF_DOOMED_HEALTH_LOSS, eDamageSourceId.deathField, null )
						eachPlayer.TakeDamage( 1, null, null, { scriptType = DF_BYPASS_SHIELD | DF_DOOMED_HEALTH_LOSS, damageSourceId = eDamageSourceId.deathField } )
					}
				}
			}
		}//foreach

		foreach ( group in groupsToRemove )
		{	
			#if DEVELOPER
			sqprint(format("arrayloop: Removing group: %d", group.groupHandle ))
			#endif 

			if(IsValid(group))
			{
				FS_Scenarios_RemoveGroup(group)
			}
			else 
			{
				#if DEVELOPER
				sqerror("Invalid group cannot be removed by reference alone")
				#endif
			}
		}

		// Revivir jugadores muertos que están descansando ( No debería pasar, pero por si acaso )
		foreach ( restingPlayerHandle,restingStruct in FS_1v1_GetPlayersResting() )
		{
			if(!restingPlayerHandle)
			{	
				sqerror("Null handle")
					continue
			}
			
			entity restingPlayerEntity = GetEntityFromEncodedEHandle(restingPlayerHandle)
			
			if(!IsValid(restingPlayerEntity)) continue

			if(!IsAlive(restingPlayerEntity)  )
			{	
				thread FS_Scenarios_RespawnIn3v3Mode(restingPlayerEntity)
			}
			
			//TakeAllWeapons( restingPlayer )
			HolsterAndDisableWeapons( restingPlayerEntity )
		}

		// Los jugadores que están en la sala de espera no se pueden alejar mucho de ahí
		foreach ( player in GetPlayerArray() )
		{
			if( !IsValid( player ) ) 
				continue
			
			if( FS_Scenarios_IsPlayerIn3v3Mode( player ) )
				continue

			float t_radius = 600;

			if( Distance2D( player.GetOrigin(), waitingRoomLocation.origin) > t_radius ) //waiting player should be in waiting room,not battle area
			{
				maki_tp_player( player, waitingRoomLocation ) //waiting player should be in waiting room,not battle area
				HolsterAndDisableWeapons( player )
			}
		}

		// Esperar a que hayan 6 jugadores, reworkear esto para que se espere al menos 4, si hay 5 esperar un 6.
		if(FS_1v1_GetPlayersWaiting().len()<6)
		{	
			
			//mkos
			foreach ( player, solostruct in FS_1v1_GetPlayersWaiting() )
			{			
				if ( !IsValid( player ) )
				{
					continue
				}
				
				if(!IsValid(solostruct) || !IsValid(solostruct.player))
				{
					continue
				}
				
				Remote_CallFunction_NonReplay( solostruct.player, "ForceScoreboardLoseFocus" );
				Message_New( solostruct.player, "Waiting for players...", 4 )
				// CreatePanelText(solostruct.player, "", "Waiting for\n   players...",IBMM_WFP_Coordinates(),IBMM_WFP_Angles(), false, 2.5, solostruct.player.p.handle )
				// SetMsg( solostruct.player, false )
			}

			wait 6
			continue		
		}

		printt("------------------more than 6 (cambiar a 4 ) player in solo waiting array,matching------------------")
		scenariosGroupStruct newGroup
		entity opponent
		bool bMatchFound = false

		// mkos please add proper matchmaking for teams lol
		foreach ( playerHandle, eachPlayerStruct in FS_1v1_GetPlayersWaiting() )
		{	
			if(!IsValid(eachPlayerStruct))
			{
				continue
			}					
			
			entity playerSelf = eachPlayerStruct.player
			float selfKd = eachPlayerStruct.kd
			
			//Temp !FIXME
			if( newGroup.team1Players.len() < settings.flowstate_3v3_playersPerTeam )
				newGroup.team1Players.append( playerSelf )
			else if( newGroup.team2Players.len() < settings.flowstate_3v3_playersPerTeam )
				newGroup.team2Players.append( playerSelf )
		}
		
		if( newGroup.team1Players.len() > 0 && newGroup.team2Players.len() > 0 )
		{
			newGroup.team1Index = FS_Scenarios_GetAvailableTeamSlotIndex()
			newGroup.team2Index = FS_Scenarios_GetAvailableTeamSlotIndex()

			foreach( player in newGroup.team1Players )
			{
				SetTeam( player, newGroup.team1Index )
			}

			foreach( player in newGroup.team2Players )
			{
				SetTeam( player, newGroup.team2Index )
			}

			printt( "available team 1:", newGroup.team1Index )
			printt( "available team 2:", newGroup.team2Index )
			
			bMatchFound = true
		}
		array<entity> players
		players.extend( newGroup.team1Players )
		players.extend( newGroup.team2Players )

		// Si todos los jugadores de un equipo son inválidos, mandar el otro equipo a la lista de espera
		int check = 0
		foreach( player in newGroup.team1Players )
		{
			if( IsValid( player ) )
				check++
		}
		if( check == 0 )
		{
			foreach( player in newGroup.team2Players )
			{
				
				soloModePlayerToWaitingList(player)
			}
			continue
		}

		check = 0
		foreach( player in newGroup.team2Players )
		{
			if( IsValid( player ) )
				check++
		}
		if( check == 0 )
		{
			foreach( player in newGroup.team1Players )
			{
				
				soloModePlayerToWaitingList(player)
			}
			continue
		}

		//Emparejamos al menos cuatro jugadores
		thread FS_Scenarios_GroupToInProgressList(newGroup)

		foreach (index,eachPlayer in players )
		{
			eachPlayer.p.notify = false
			eachPlayer.p.destroynotify = true
			EnableOffhandWeapons( eachPlayer )
			DeployAndEnableWeapons( eachPlayer )
			thread FS_Scenarios_RespawnIn3v3Mode(eachPlayer, eachPlayer.GetTeam() == newGroup.team1Index ? 0 : 1 )

			FS_SetRealmForPlayer( eachPlayer, newGroup.slotIndex )
		}

		if( settings.flowstate_3v3_dropshipenabled )
		{
			soloLocStruct groupLocStruct = newGroup.groupLocStruct
			thread RespawnPlayersInDropshipAtPoint( newGroup.team1Players, groupLocStruct.respawnLocations[ 0 ].origin, groupLocStruct.respawnLocations[ 1 ].angles, newGroup.slotIndex )
			waitthread RespawnPlayersInDropshipAtPoint( newGroup.team2Players, groupLocStruct.respawnLocations[ 1 ].origin, groupLocStruct.respawnLocations[ 0 ].angles, newGroup.slotIndex )
		} else
		{
			GiveWeaponsToGroup( players )
		}
	}//while(true)

	OnThreadEnd(
		function() : (  )
		{
			// Warning(Time() + "Solo thread is down!!!!!!!!!!!!!!!")
			GameRules_ChangeMap( GetMapName(), GameRules_GetGameMode() )
		}
	)

}//thread